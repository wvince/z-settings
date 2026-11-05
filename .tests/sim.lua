-- Simulated WoW for Z-Settings: you export, a friend imports on another PC, then undoes; then you copy
-- one of your characters onto another.
local ADDON, CHARACTERS, MINIMAP = ...

local function deepcopy(t, seen)
  if type(t) ~= "table" then return t end
  seen = seen or {}
  if seen[t] then return seen[t] end
  local c = {}; seen[t] = c
  for k, v in pairs(t) do c[deepcopy(k, seen)] = deepcopy(v, seen) end
  return c
end

local SPELLS = { [1] = "Shadow Bolt", [2] = "Corruption", [3] = "Bane of Agony", [4] = "Siphon Life",
  [5] = "Immolate", [6] = "Fear", [7] = "Life Tap", [8] = "Summon Imp" }
local SPELL_ID = {}
for id, n in pairs(SPELLS) do SPELL_ID[n] = id end

local function newAccount()
  return {
    general = {},                 -- macros: { name, icon, body }
    binds = { { "MOVEFORWARD", "W" }, { "ACTIONBUTTON1", "E" }, { "ACTIONBUTTON2", "1" },
              { "FOCUSTARGET", "ALT-F" }, { "ACTIONBUTTON3", nil }, { "MULTIACTIONBAR1BUTTON2", "BUTTON4" } },
    editmode = { layouts = { layouts = { { layoutName = "Main", layoutType = 1, systems = { { system = 0, x = 1 } } } }, activeLayout = 3 },
                 settings = { { setting = 1, value = 0 } } },
  }
end

local function newChar(name, realm, account, known)
  local k = {}
  for _, n in ipairs(known) do k[n] = true end
  return { name = name, realm = realm, account = account, known = k, bars = {}, charMacros = {},
    clicks = { { type = 3, actionID = 1, button = "LeftButton", modifiers = 0 } },
    cvars = { nameplateShowEnemies = "1", enableMouseoverCast = "0", graphicsQuality = "9", NamePlateHorizontalScale = "1", nameplateMaxDistance = "41",
              SoftTargetEnemy = "1", enableMultiActionBars = "15", Sound_MasterVolume = "1.0",
              hardTrackedQuests = name .. "-quests", autoLootDefault = "1" },
    cdm = name .. "-cdm",
    chat = { [1] = { "General", 14, 0, 0, 0, 0.4, true, true, nil, false, "TOPLEFT", 10, 10, 400, 200, { "SAY", "PARTY" }, { "General" } },
             [2] = { "Combat Log", 14, 0, 0, 0, 0.4, true, true, 1, false, nil, nil, nil, nil, nil, {}, {} } },
    addons = { DBM = true, GTFO = false, Leatrix_Plus = true, SpyGodMode = true } }
end

local function serialize(v)
  if type(v) ~= "table" then return tostring(v) end
  local keys = {}
  for k in pairs(v) do keys[#keys + 1] = k end
  table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
  local out = {}
  for _, k in ipairs(keys) do out[#out + 1] = tostring(k) .. "=" .. serialize(v[k]) end
  return "{" .. table.concat(out, ",") .. "}"
end
local SV = {}          -- the shared SavedVariables file, between sessions
local cur              -- active character
local combat = false
local clock = 1000
local timers, printed = {}, {}
local frame

-- WoW API ----------------------------------------------------------------------------------
Constants = { MacroConsts = { MAX_ACCOUNT_MACROS = 120 } }
Enum = { ClickBindingType = { None = 0, Spell = 1, Macro = 2, Interaction = 3, PetAction = 4 } }
function time() clock = clock + 10; return clock end
function date(f) return os.date(f, clock) end  -- WoW global; the test moves clock forward
function print(...) local t = {} for i = 1, select("#", ...) do t[#t + 1] = tostring(select(i, ...)) end printed[#printed + 1] = table.concat(t, " ") end
function UnitName() return cur.name end
function GetRealmName() return cur.realm end
function UnitClass() return cur.class or "Warlock", (cur.class or "Warlock"):upper() end
function InCombatLockdown() return combat end
C_Timer = { After = function(_, fn) timers[#timers + 1] = fn end, NewTicker = function() end }
function CreateFrame() frame = { events = {} }
  function frame:RegisterEvent(e) self.events[e] = true end
  function frame:SetScript(_, fn) self.handler = fn end
  return frame end
SlashCmdList = {}

local function macroList() return cur.account.general, cur.charMacros end
function GetNumMacros() return #cur.account.general, #cur.charMacros end
function GetMacroInfo(i)
  local m = i > 120 and cur.charMacros[i - 120] or (i <= 120 and cur.account.general[i])
  if m then return m[1], m[2], m[3] end
end
function GetMacroIndexByName(name)
  for i, m in ipairs(cur.account.general) do if m[1] == name then return i end end
  for i, m in ipairs(cur.charMacros) do if m[1] == name then return 120 + i end end
  return 0
end
function CreateMacro(name, icon, body, perChar)
  local list = perChar and cur.charMacros or cur.account.general
  assert(not perChar or #list < 30, "character macro limit")
  list[#list + 1] = { name, icon, body }
end
function EditMacro(i, name, icon, body)
  local m = i > 120 and cur.charMacros[i - 120] or cur.account.general[i]
  m[1], m[2], m[3] = name or m[1], icon or m[2], body or m[3]
end
function DeleteMacro(i)
  if i > 120 then table.remove(cur.charMacros, i - 120) else table.remove(cur.account.general, i) end
end

local cursor
function ClearCursor() cursor = nil end
function GetCursorInfo() return cursor and cursor.kind or nil end
function PickupMacro(name) if GetMacroIndexByName(name) > 0 then cursor = { kind = "macro", name = name } end end
C_Spell = {
  GetSpellName = function(id) return SPELLS[id] end,
  GetSpellInfo = function(n) if cur.known[n] then return { spellID = SPELL_ID[n] } end end,
  PickupSpell = function(n) if cur.known[n] then cursor = { kind = "spell", id = SPELL_ID[n] } end end,
}
C_Item = { PickupItem = function(id) if tonumber(id) == 6948 then cursor = { kind = "item", id = 6948 } end end }
C_EquipmentSet = { PickupEquipmentSet = function() end }
function PlaceAction(slot) assert(not combat, "PlaceAction in combat"); cur.bars[slot] = cursor; cursor = nil end
function PickupAction(slot) assert(not combat); cursor = cur.bars[slot]; cur.bars[slot] = nil end
function GetActionInfo(slot)
  if cur.barsUnloaded then return nil end
  local a = cur.bars[slot]
  if not a then return nil end
  if a.kind == "macro" then
    local i = GetMacroIndexByName(a.name)
    if i == 0 then return nil end
    return "macro", i
  end
  return a.kind, a.id
end
function GetActionText(slot) local a = cur.bars[slot]; return a and a.kind == "macro" and a.name or nil end

function GetNumBindings() return #cur.account.binds end
function GetBinding(i) local b = cur.account.binds[i]; return b[1], "cat", b[2], b[3] end
function SetBinding(key, command, ctx)
  assert(not combat)
  for _, b in ipairs(cur.account.binds) do
    if b[2] == key then b[2] = b[3]; b[3] = nil end
    if b[3] == key then b[3] = nil end
  end
  if command then
    for _, b in ipairs(cur.account.binds) do
      if b[1] == command then
        if not b[2] then b[2] = key elseif not b[3] then b[3] = key end
        return true
      end
    end
    cur.account.binds[#cur.account.binds + 1] = { command, key }
  end
  return true
end
function SaveBindings(set) cur.bindSet = set end
function LoadBindings() end
function GetCurrentBindingSet() return cur.bindSet or 1 end
C_KeyBindings = { GetBindingContextForAction = function() return 1 end }

C_ClickBindings = {
  GetProfileInfo = function() return deepcopy(cur.clicks) end,
  SetProfileByInfo = function(p) cur.clicks = deepcopy(p) end,
}

local CVAR_META = {
  nameplateShowEnemies = { 4, true }, enableMouseoverCast = { 3, true }, autoLootDefault = { 4, true },
  graphicsQuality = { 1, false }, NamePlateHorizontalScale = { 1, false }, nameplateMaxDistance = { 0, false }, hardTrackedQuests = { 4, true },
  SoftTargetEnemy = { 10, true }, enableMultiActionBars = { 10, false }, Sound_MasterVolume = { 7, true },
  showTargetOfTarget = { 4, false, true },   -- stored per character
}
function ConsoleGetAllCommands()
  local out = {}
  for n, m in pairs(CVAR_META) do out[#out + 1] = { command = n, category = m[1], commandType = 0 } end
  return out
end
C_CVar = {
  GetCVar = function(n) return cur.cvars[n] end,
  SetCVar = function(n, v) cur.cvars[n] = v end,
  GetCVarInfo = function(n) local m = CVAR_META[n]; return cur.cvars[n], "0", m[2], m[3] or false, false, false, false end,
}
C_EditMode = {
  GetLayouts = function() return deepcopy(cur.account.editmode.layouts) end,
  GetAccountSettings = function() return deepcopy(cur.account.editmode.settings) end,
  SaveLayouts = function(l) cur.account.editmode.layouts = deepcopy(l) end,
  SetActiveLayout = function(i) cur.activeLayout = i end,
  SetAccountSetting = function(s, v) for _, x in ipairs(cur.account.editmode.settings) do if x.setting == s then x.value = v end end end,
}
C_CooldownViewer = { GetLayoutData = function() return cur.cdm end, SetLayoutData = function(d) cur.cdm = d end }

Constants.ChatFrameConstants = { MaxChatWindows = 3 }
local function chatWin(i) cur.chat[i] = cur.chat[i] or { "", 0, 0, 0, 0, 0, false, false, nil, false, nil, nil, nil, nil, nil, {}, {} }; return cur.chat[i] end
function GetChatWindowInfo(i) local c = chatWin(i); return c[1], c[2], c[3], c[4], c[5], c[6], c[7], c[8], c[9], c[10] end
function GetChatWindowSavedPosition(i) local c = chatWin(i); return c[11], c[12], c[13] end
function GetChatWindowSavedDimensions(i) local c = chatWin(i); return c[14], c[15] end
function SetChatWindowName(i, v) chatWin(i)[1] = v end
function SetChatWindowSize(i, v) chatWin(i)[2] = v end
function SetChatWindowColor(i, r, g, b) local c = chatWin(i); c[3], c[4], c[5] = r, g, b end
function SetChatWindowAlpha(i, v) chatWin(i)[6] = v end
function SetChatWindowShown(i, v) chatWin(i)[7] = v end
function SetChatWindowLocked(i, v) chatWin(i)[8] = v end
function SetChatWindowDocked(i, v) chatWin(i)[9] = v end
function SetChatWindowUninteractable(i, v) chatWin(i)[10] = v end
function SetChatWindowSavedPosition(i, p, x, y) local c = chatWin(i); c[11], c[12], c[13] = p, x, y end
function SetChatWindowSavedDimensions(i, w, h) local c = chatWin(i); c[14], c[15] = w, h end
local function listRemove(t, v) for k, x in pairs(t) do if x == v then table.remove(t, k); return end end end
local function listAdd(t, v) for _, x in pairs(t) do if x == v then return end end t[#t + 1] = v end
function AddChatWindowMessages(i, m) listAdd(chatWin(i)[16], m) end
function RemoveChatWindowMessages(i, m) listRemove(chatWin(i)[16], m) end
function AddChatWindowChannel(i, ch) listAdd(chatWin(i)[17], ch) end
function RemoveChatWindowChannel(i, ch) listRemove(chatWin(i)[17], ch) end
local function loadChatFrames() -- what the UI loaded at login
  for i = 1, 3 do local c = chatWin(i); _G["ChatFrame" .. i] = { messageTypeList = deepcopy(c[16]), channelList = deepcopy(c[17]) } end
end
addonCalls = {}
C_AddOns = {
  GetNumAddOns = function() local n = 0 for _ in pairs(cur.addons) do n = n + 1 end return n end,
  GetAddOnInfo = function(i) local names = {} for k in pairs(cur.addons) do names[#names + 1] = k end table.sort(names) return names[i] end,
  GetAddOnEnableState = function(name) return cur.addons[name] and 2 or 0 end,
  EnableAddOn = function(name, character) cur.addons[name] = true; addonCalls[#addonCalls + 1] = character or "all" end,
  DisableAddOn = function(name, character) cur.addons[name] = false; addonCalls[#addonCalls + 1] = character or "all" end,
  SaveAddOns = function() saves = (saves or 0) + 1 end,
  IsAddOnLoaded = function(name) return cur.loaded[name] == true end,   -- switched on at login; a switch now loads at the next reload
}


-- encoding: a readable stand-in for CBOR, compression and Base64
local function ser(v)
  local tv = type(v)
  if tv == "string" then return string.format("%q", v) end
  if tv == "number" or tv == "boolean" or tv == "nil" then return tostring(v) end
  if tv ~= "table" then error("cannot serialize " .. tv) end
  local parts = {}
  for k, x in pairs(v) do parts[#parts + 1] = "[" .. ser(k) .. "]=" .. ser(x) end
  return "{" .. table.concat(parts, ",") .. "}"
end
C_EncodingUtil = {
  SerializeCBOR = function(v) return "C" .. ser(v) end,
  DeserializeCBOR = function(s) assert(s:sub(1, 1) == "C", "not cbor"); return assert(loadstring("return " .. s:sub(2)))() end,
  CompressString = function(s) return "Z" .. s end,
  DecompressString = function(s) assert(s:sub(1, 1) == "Z", "not compressed"); return s:sub(2) end,
  -- like real Base64, the output holds no whitespace
  EncodeBase64 = function(s) return "B" .. s:gsub(".", function(c) return string.format("%02x", c:byte()) end) end,
  DecodeBase64 = function(s) assert(s:sub(1, 1) == "B", "not base64"); return (s:sub(2):gsub("%x%x", function(h) return string.char(tonumber(h, 16)) end)) end,
}
-- Edit Mode's "Copy to clipboard" string and its import, in the same readable stand-in
C_EditMode.ConvertLayoutInfoToString = function(info) return "EM" .. ser(info) end
C_EditMode.ConvertStringToLayoutInfo = function(s) assert(s:sub(1, 2) == "EM", "not a layout"); return assert(loadstring("return " .. s:sub(3)))() end
reloads = 0
function ReloadUI() reloads = reloads + 1 end
-- frames: any method works; scripts and text are kept so the test can click and type
local frames = {}
function CreateFrame(kind, name)
  local o = { scripts = {}, text = "", kind = kind, events = {} }
  if name then _G[name] = o end
  setmetatable(o, { __index = function(_, k)
    if k == "SetScript" then return function(self, what, fn) self.scripts[what] = fn end end
    if k == "SetText" then return function(self, v) self.text = v end end
    if k == "GetText" then return function(self) return self.text end end
    if k == "SetChecked" then return function(self, v) self.checked = v and true or false end end
    if k == "GetChecked" then return function(self) return self.checked end end
    if k == "SetEnabled" then return function(self, v) self.enabled = v and true or false end end
    if k == "Show" then return function(self) self.shown = true end end
    if k == "Hide" then return function(self) self.shown = false end end
    if k == "IsShown" then return function(self) return self.shown == true end end
    if k == "CreateTexture" or k == "CreateMaskTexture" then return function() return CreateFrame("Texture") end end
    if k == "CreateFontString" then return function() return CreateFrame("FontString") end end
    if k == "RegisterEvent" then return function(self, e) self.events[e] = true end end
    return function() end
  end })
  frames[#frames + 1] = o
  return o
end
UIParent, ChatFontNormal = {}, {}
Minimap = { GetWidth = function() return 140 end }
GameTooltip = setmetatable({}, { __index = function() return function() end end })
local SVS = {}   -- addon -> "Var1, Var2"
Z_VARS_ID = "4242"
-- what the commit hook writes from the tocs, read from SVS at call time
Z_VARS = setmetatable({}, { __index = function(_, name)
  local out = {}
  for v in (SVS[name] or ""):gmatch("[^,%s]+") do out[#out + 1] = v end
  return out
end })
SVCS = {}   -- addon -> "CharVar1, CharVar2"
Z_CHARVARS = setmetatable({}, { __index = function(_, name)
  local out = {}
  for v in (SVCS[name] or ""):gmatch("[^,%s]+") do out[#out + 1] = v end
  return out
end })
C_AddOns.GetAddOnMetadata = function() return nil end   -- like the client: no SavedVariables field

-- sessions -----------------------------------------------------------------------------------
local function runTimers()
  for _ = 1, 20 do
    if #timers == 0 then return end
    local t = timers; timers = {}
    for _, fn in ipairs(t) do fn() end
  end
end

-- checks -------------------------------------------------------------------------------------
local passed, failed = 0, 0
local function check(name, cond)
  if cond then passed = passed + 1 else failed = failed + 1; print("FAIL " .. name) ; io.write("FAIL " .. name .. "\n") end
end
local function barName(c, slot)
  local a = c.bars[slot]
  if not a then return nil end
  return a.kind == "macro" and ("macro:" .. a.name) or (a.kind .. ":" .. tostring(a.id))
end
local function keyOf(acc, command)
  for _, b in ipairs(acc.binds) do if b[1] == command then return b[2] end end
end


local accA, accB = newAccount(), newAccount()
local me = newChar("Zeroshin", "Classic Beta PvP 2", accA, { "Shadow Bolt" })
local friend = newChar("Buddy", "Classic Beta PvP", accB, { "Fireball" })
-- my setup
accA.general = { { "Focus", 1, "/focus [@mouseover,harm] mouseover; target" }, { "Mana", 2, "#showtooltip\n/use Major Mana Potion" },
  { "Random nuke", 6, "/userandom Shadow Bolt, Immolate" }, { "Spell nuke", 6, "/spell Shadow Bolt" },
  { "Healthstone", 3, "#showtooltip\n/cast Create Healthstone" }, { "Warlock nuke", 4, "/cast Shadow Bolt" },
  { "RS_MACRO", 8, "/targetexact Soboz" } }
me.charMacros = { { "Tap safe", 5, "/cast [nochanneling] Life Tap" } }
me.bars = { [1] = { kind = "spell", id = 1 } }
accA.binds[1][2] = "UP"
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON1", "Q" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON2", "SHIFT-1" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON3", "ALT-Z" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON4", "SHIFT--" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON5", "M" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR3BUTTON1", "ALT-Q" }
accA.binds[#accA.binds + 1] = { "STRAFELEFT", "A" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR3BUTTON4", "SHIFT-W" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR3BUTTON2", "F5" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR3BUTTON3", "BUTTON3" }
me.clicks = { { type = 3, actionID = 1, button = "LeftButton", modifiers = 0 }, { type = 2, actionID = 121, button = "LeftButton", modifiers = 1 } }
me.cvars.nameplateShowEnemies = "0"; me.cvars.NamePlateHorizontalScale = "1.4"; me.cvars.nameplateMaxDistance = "60"; me.cvars.graphicsQuality = "3"; me.cvars.enableMultiActionBars = "31"
accA.editmode.layouts.layouts[1].systems[1].x = 77
me.chat[3] = { "Guild", 18, 0, 0, 0, 0.6, true, true, 3, false, nil, nil, nil, nil, nil, { "GUILD" }, {} }
me.addons = { Leatrix_Plus = false, Attune = true, Guide = true, DBM = true, BetterBlizzFrames = true, BigData = true, Weird = true, SpyGodMode = true, ["Z-Settings"] = true }
me.cdm = "my-warlock-cdm"
SVS = { DBM = "DBM_AllSavedOptions", BetterBlizzFrames = "BetterBlizzFramesDB", BigData = "BigDataDB", Weird = "WeirdDB",
        SpyGodMode = "SpyGodModeDB", ["Z-Settings"] = "ZSettingsDB", Attune = "Attune_DB", Guide = "GuideDB" }

-- the friend's own setup
accB.general = { { "Buddy macro", 9, "/wave" } }
accB.binds[1][2] = "W"
friend.clicks = { { type = 3, actionID = 2, button = "LeftButton", modifiers = 0 }, { type = 1, actionID = 133, button = "RightButton", modifiers = 1 } }
friend.cvars.nameplateShowEnemies = "1"
friend.addons = { Attune = true, Guide = true, DBM = true, BetterBlizzFrames = nil, BigData = false, Weird = false, SpyGodMode = false, ["Z-Settings"] = true, Details = true }
friend.addons.BetterBlizzFrames = nil  -- not installed
friend.cdm = "friend-mage-cdm"

local function useChar(c, globals)
  cur = c
  for k, v in pairs(globals) do _G[k] = v end
  loadChatFrames()
  frames = {}
  ZSettingsDB = c.ZSettingsDB
  c.loaded = {}
  for name, on in pairs(c.addons) do c.loaded[name] = on end
  local ns = {}
  assert(loadstring(ADDON))("Z-Settings", ns)
  assert(loadstring(CHARACTERS))("Z-Settings", ns)
  assert(loadstring(MINIMAP))("Z-Settings", ns)
end

-- 1. export on my character
local function pressKeys(...)
  local keys = { ... }
  for _, o in ipairs(frames) do
    if o.scripts.OnKeyDown then for _, k in ipairs(keys) do if o.scripts.OnKeyDown then o.scripts.OnKeyDown(o, k) end end end
  end
end
local function said(pattern)
  for _, p in ipairs(printed) do if p:find(pattern) then return true end end
  return false
end
local function fire(event)
  for _, o in ipairs(frames) do if o.events[event] then o.scripts.OnEvent(o, event) end end
end
useChar(me, { DBM_AllSavedOptions = { warnings = true, bars = { size = 2 } }, BetterBlizzFramesDB = { castbar = 1 },
  BigDataDB = { blob = string.rep("x", 400000) }, Attune_DB = { toons = { Zeroshin = 1 } },
  GuideDB = { profileKeys = { ["Zeroshin - PvP"] = "Zeroshin - PvP" }, profiles = { ["Zeroshin - PvP"] = { size = 2 } } }, WeirdDB = { f = function() end }, SpyGodModeDB = { secret = 1 } })
ZSettingsDB = nil
printed, reloads = {}, 0
SlashCmdList.ZSETTINGS("export")
check("1 export waits for the keyboard", reloads == 0 and ZSettingsDB == nil)
pressKeys("Q")
local text = ZSettingsDB and ZSettingsDB.export or ""
check("1 export saved for the commit hook", text:sub(1, 4) == "ZS1:" and ZSettingsDB.exportMade ~= nil)
check("1 export records the addon list it was made with", ZSettingsDB.exportVars == Z_VARS_ID)
check("1 export reloads the UI", reloads == 1)
check("1 my keyboard detected as QWERTY", said("QWERTY"))
local data = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(text:sub(5))))
check("1 keyboard stored in the export", data.layout == "qwerty")
check("1 layout shared as Edit Mode's own string", type(data.editmode.layout) == "string" and data.editmode.layouts == nil)
check("1 class-free macros shared", data.macros.Focus ~= nil and data.macros.Mana ~= nil)
check("1 spell-casting macros left out", data.macros.Healthstone == nil and data.macros["Warlock nuke"] == nil)
check("1 /userandom macro left out", data.macros["Random nuke"] == nil)
check("1 /spell macro left out", data.macros["Spell nuke"] == nil)
check("1 character macros left out", data.macros["Tap safe"] == nil)
check("1 an addon's own macro left out", data.macros.RS_MACRO == nil)
check("1 action bars left out", data.bars == nil)
check("1 cooldown manager left out", data.cdm == nil)
check("1 only target/menu clicks shared", #data.clicks == 1 and data.clicks[1].type == 3)
check("1 graphics not shared", data.cvars.graphicsQuality == nil)
check("1 local nameplate settings shared", data.cvars.NamePlateHorizontalScale == "1.4" and data.cvars.nameplateMaxDistance == "60")
check("1 DBM settings shared", data.settings.DBM_AllSavedOptions ~= nil)
check("1 SpyGodMode never shared", data.settings.SpyGodModeDB == nil)
check("1 oversized table left out", data.settings.BigDataDB == nil)
check("1 unshareable table left out", data.settings.WeirdDB == nil)
check("1 character data left out", data.settings.Attune_DB == nil)
check("1 per-character profiles left out", data.settings.GuideDB == nil)
check("1 deliberate leave-outs not reported", not said("Attune") and not said("GuideDB"))
check("1 left-out tables listed", said("BigData") and said("Weird"))
-- the reload wiped the chat: the messages come back once the UI is up
printed = {}
fire("PLAYER_LOGIN")
check("1 messages repeated after the reload", said("commit and push") and said("QWERTY"))
check("1 messages shown once", ZSettingsDB.notice == nil)

-- 2. the friend pulls the repo and imports the setup that ships with the addon
BetterBlizzFramesDB, BigDataDB, WeirdDB, SpyGodModeDB = nil, nil, nil, nil   -- the friend's PC has none of these
Z_BUNDLE = text
useChar(friend, { DBM_AllSavedOptions = { warnings = false } })
friend.ZSettingsDB = nil
printed = {}
SlashCmdList.ZSETTINGS("")
check("2 /z names the bundled setup", said("Zeroshin's setup"))
printed, reloads = {}, 0
SlashCmdList.ZSETTINGS("import")
check("2 import waits for the keyboard", reloads == 0 and friend.cvars.nameplateShowEnemies == "1")
pressKeys("A")
friend.ZSettingsDB = ZSettingsDB
check("2 import reloads the UI", reloads == 1)
check("2 settings applied", friend.cvars.nameplateShowEnemies == "0" and friend.cvars.enableMultiActionBars == "31")
check("2 graphics untouched", friend.cvars.graphicsQuality == "9")
check("2 nameplate size and distance applied", friend.cvars.NamePlateHorizontalScale == "1.4" and friend.cvars.nameplateMaxDistance == "60")
check("2 keybinds applied", keyOf(accB, "MOVEFORWARD") == "UP")
check("2 Q becomes A on AZERTY", keyOf(accB, "MULTIACTIONBAR2BUTTON1") == "A")
check("2 Alt+Q becomes Alt+A on AZERTY", keyOf(accB, "MULTIACTIONBAR3BUTTON1") == "ALT-A")
check("2 A becomes Q on AZERTY", keyOf(accB, "STRAFELEFT") == "Q")
check("2 Alt+Z becomes Alt+W on AZERTY", keyOf(accB, "MULTIACTIONBAR2BUTTON3") == "ALT-W")
check("2 number row stays (WoW maps it)", keyOf(accB, "ACTIONBUTTON2") == "1" and keyOf(accB, "MULTIACTIONBAR2BUTTON2") == "SHIFT-1")
check("2 Shift+minus stays", keyOf(accB, "MULTIACTIONBAR2BUTTON4") == "SHIFT--")
check("2 M stays M (the map key) on AZERTY", keyOf(accB, "MULTIACTIONBAR2BUTTON5") == "M")
check("2 F-keys and mouse buttons stay", keyOf(accB, "MULTIACTIONBAR3BUTTON2") == "F5" and keyOf(accB, "MULTIACTIONBAR3BUTTON3") == "BUTTON3")
check("2 arrow key untouched", keyOf(accB, "MOVEFORWARD") == "UP")
check("2 E stays E", keyOf(accB, "ACTIONBUTTON1") == "E")
check("2 Shift+W becomes Shift+Z on AZERTY", keyOf(accB, "MULTIACTIONBAR3BUTTON4") == "SHIFT-Z")
local em = accB.editmode.layouts
check("2 friend's own layout kept", em.layouts[1].layoutName == "Main" and em.layouts[1].systems[1].x == 1)
check("2 my layout added as Zeroshin UI", #em.layouts == 2 and em.layouts[2].layoutName == "Zeroshin UI" and em.layouts[2].systems[1].x == 77)
check("2 Zeroshin UI layout selected", em.activeLayout == 4 and friend.activeLayout == 4)
check("2 chat applied", friend.chat[3][1] == "Guild")
check("2 shared macros added", GetMacroIndexByName("Focus") > 0 and GetMacroIndexByName("Mana") > 0)
check("2 friend's own macro kept", GetMacroIndexByName("Buddy macro") > 0)
check("2 no warlock macro arrived", GetMacroIndexByName("Warlock nuke") == 0 and GetMacroIndexByName("Healthstone") == 0)
local spellClick, targetClick = false, false
for _, b in ipairs(friend.clicks) do
  if b.type == 1 and b.actionID == 133 then spellClick = true end
  if b.type == 3 and b.actionID == 1 then targetClick = true end
end
check("2 friend's spell click kept", spellClick)
check("2 target click taken from me", targetClick)
check("2 DBM settings replaced", DBM_AllSavedOptions.warnings == true and DBM_AllSavedOptions.bars.size == 2)
check("2 addon friend lacks skipped", BetterBlizzFramesDB == nil)
check("2 friend's Cooldown Manager untouched", friend.cdm == "friend-mage-cdm")
check("2 friend's bars untouched", next(friend.bars) == nil)
check("2 Z-Settings stays on", friend.addons["Z-Settings"] == true)
check("2 SpyGodMode not switched on", friend.addons.SpyGodMode == false)
check("2 undo step kept for this character", friend.ZSettingsDB and type(friend.ZSettingsDB.undo) == "table" and friend.ZSettingsDB.undo["Buddy-Classic Beta PvP"] ~= nil)
check("2 missing addon reported", said("BetterBlizzFrames"))
-- an addon that rewrites its table at logout doesn't undo the import
DBM_AllSavedOptions = { warnings = false }
fire("PLAYER_LOGOUT")
check("2 import survives the save at logout", DBM_AllSavedOptions.warnings == true)
printed = {}
fire("PLAYER_LOGIN")
check("2 import summary repeated after the reload", said("applied Zeroshin's setup") and said("Zeroshin UI added"))
-- importing again overwrites the Zeroshin UI layout instead of adding a second one
accB.editmode.layouts.layouts[2].systems[1].x = 5
printed = {}
SlashCmdList.ZSETTINGS("import"); pressKeys("A")
check("2 second import overwrites Zeroshin UI", #accB.editmode.layouts.layouts == 2 and accB.editmode.layouts.layouts[2].systems[1].x == 77)
check("2 second import says updated", said("Zeroshin UI updated"))

-- an older import's "Zeroshin" layout is renamed, not doubled
local renamed = newChar("Renamed", "Classic Beta PvP", newAccount(), { "Fireball" })
table.insert(renamed.account.editmode.layouts.layouts, { layoutName = "Zeroshin", layoutType = 1, systems = { { system = 0, x = 9 } } })
useChar(renamed, {}); ZSettingsDB = nil
SlashCmdList.ZSETTINGS("import"); pressKeys("A")
local rem = renamed.account.editmode.layouts
check("2 old Zeroshin layout renamed to Zeroshin UI", #rem.layouts == 2 and rem.layouts[2].layoutName == "Zeroshin UI" and rem.layouts[2].systems[1].x == 77)

-- every account slot taken: a character slot, their layouts stay
local full = newChar("Full", "Classic Beta PvP", newAccount(), { "Fireball" })
full.account.editmode.layouts.layouts = {}
for i = 1, 5 do full.account.editmode.layouts.layouts[i] = { layoutName = "L" .. i, layoutType = 1, systems = { { system = 0, x = i } } } end
useChar(full, {}); ZSettingsDB = nil
printed = {}
SlashCmdList.ZSETTINGS("import"); pressKeys("A")
local fem = full.account.editmode.layouts
check("2 full account slots use a character slot", #fem.layouts == 6 and fem.layouts[6].layoutName == "Zeroshin UI" and fem.layouts[6].layoutType == 2 and fem.activeLayout == 8)
check("2 full account slots keep their layouts", fem.layouts[1].layoutName == "L1" and fem.layouts[5].systems[1].x == 5)
-- every slot taken: Edit Mode is left alone
local packed = newChar("Packed", "Classic Beta PvP", newAccount(), { "Fireball" })
packed.account.editmode.layouts.layouts = {}
for i = 1, 10 do packed.account.editmode.layouts.layouts[i] = { layoutName = "P" .. i, layoutType = i <= 5 and 1 or 2, systems = { { system = 0, x = i } } } end
useChar(packed, {}); ZSettingsDB = nil
printed = {}
SlashCmdList.ZSETTINGS("import"); pressKeys("A")
local pem = packed.account.editmode.layouts
check("2 every slot taken leaves their layouts alone", #pem.layouts == 10 and pem.layouts[1].layoutName == "P1" and pem.activeLayout == 3)
check("2 every slot taken is explained", said("every layout slot is taken"))
check("2 a layout that didn't land isn't marked applied", not (ZSettingsDB.applied and ZSettingsDB.applied["Packed-Classic Beta PvP"] and ZSettingsDB.applied["Packed-Classic Beta PvP"].editmode))

-- an older bundle that still carries data tables can't overwrite the friend's own
do
  local old = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(text:sub(5))))
  old.settings.Attune_DB = { addon = "Attune", data = C_EncodingUtil.SerializeCBOR({ toons = { Zeroshin = 1 } }) }
  old.settings.GuideDB = { addon = "Guide", data = C_EncodingUtil.SerializeCBOR({ profileKeys = {}, profiles = {} }) }
  Z_BUNDLE = "ZS1:" .. C_EncodingUtil.EncodeBase64(C_EncodingUtil.CompressString(C_EncodingUtil.SerializeCBOR(old)))
  useChar(friend, { Attune_DB = { toons = { Buddy = 1 } }, GuideDB = { profileKeys = { ["Buddy - PvP"] = "Buddy - PvP" } } })
  ZSettingsDB = friend.ZSettingsDB
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  check("2 friend's character data kept", Attune_DB.toons.Buddy == 1 and Attune_DB.toons.Zeroshin == nil)
  check("2 friend's profiles kept", GuideDB.profileKeys["Buddy - PvP"] ~= nil)
  Z_BUNDLE = text
end

-- 3. a damaged or missing setup and combat are refused
useChar(friend, {}); ZSettingsDB = friend.ZSettingsDB
printed, reloads = {}, 0
local before = keyOf(accB, "MOVEFORWARD")
friend.cvars.nameplateShowEnemies = "1"
SlashCmdList.ZSETTINGS("import"); pressKeys("LSHIFT", "X")
check("3 other keys keep the prompt waiting", reloads == 0 and friend.cvars.nameplateShowEnemies == "1")
pressKeys("ESCAPE")
check("3 Escape cancels and changes nothing", reloads == 0 and friend.cvars.nameplateShowEnemies == "1" and said("cancelled"))
pressKeys("A")
check("3 after Escape no key applies anything", reloads == 0)
useChar(friend, {}); ZSettingsDB = friend.ZSettingsDB
SlashCmdList.ZSETTINGS("import"); pressKeys("X", "A")
check("3 a stray key first, then A, still applies", reloads == 1 and friend.cvars.nameplateShowEnemies == "0")
useChar(friend, {})
ZSettingsDB = friend.ZSettingsDB
Z_BUNDLE = "ZS1:garbage"
printed, reloads = {}, 0
SlashCmdList.ZSETTINGS("import")
check("3 damaged setup refused", said("damaged") and reloads == 0)
Z_BUNDLE = nil
printed = {}
SlashCmdList.ZSETTINGS("import")
check("3 missing setup explained", said("git pull"))
Z_BUNDLE = text
combat = true; printed = {}
SlashCmdList.ZSETTINGS("import"); combat = false
local prompted = false
for _, o in ipairs(frames) do if o.scripts.OnKeyDown then prompted = true end end
check("3 no key prompt in combat", not prompted)
check("3 no import in combat", said("not in combat"))
-- closing the prompt cancels the import
SlashCmdList.ZSETTINGS("import")
for _, o in ipairs(frames) do if o.scripts.OnHide then o.scripts.OnHide(o) end end
pressKeys("A")
check("3 closed prompt imports nothing", reloads == 0)

-- popup helpers
local function popupBoxes()
  local boxes = {}
  for _, o in ipairs(frames) do if o.kind == "CheckButton" and o.shown ~= false then boxes[#boxes + 1] = o end end
  return boxes
end
local function button(label)
  for _, o in ipairs(frames) do if o.kind == "Button" and o.text == label then return o end end
end
-- a missing button is a failed check, not a crash that hides the checks after it
local function click(label)
  local b = button(label)
  check("popup has a " .. label .. " button", b ~= nil)
  if b then b.scripts.OnClick() end
end
local function offered()
  local out = {}
  for _, b in ipairs(popupBoxes()) do out[#out + 1] = (b.label.text:gsub(" %(updated%)", "")) end
  table.sort(out)
  return table.concat(out, ", ")
end
local function updatedLabels()
  local out = {}
  for _, b in ipairs(popupBoxes()) do
    if b.label.text:find("(updated)", 1, true) then out[#out + 1] = (b.label.text:gsub(" %(updated%)", "")) end
  end
  table.sort(out)
  return table.concat(out, ", ")
end
local function boxFor(label)
  for _, o in ipairs(popupBoxes()) do if o.label.text:find(label, 1, true) then return o end end
end
local function macroBody(name)
  local i = GetMacroIndexByName(name)
  if i == 0 then return nil end
  local _, _, body = GetMacroInfo(i)
  return body
end
local function decodeSetup(t) return C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(t:sub(5)))) end
local function encodeSetup(d) return "ZS1:" .. C_EncodingUtil.EncodeBase64(C_EncodingUtil.CompressString(C_EncodingUtil.SerializeCBOR(d))) end

-- 4. undo puts back exactly what one import changed, and nothing else
local uAcc = newAccount()
uAcc.general = { { "Own macro", 9, "/wave" }, { "Focus", 7, "/say mine" } }   -- an own macro sharing a name with one of mine
local u = newChar("Undoer", "Classic Beta PvP", uAcc, { "Fireball" })
u.clicks = { { type = 3, actionID = 2, button = "LeftButton", modifiers = 0 }, { type = 1, actionID = 133, button = "RightButton", modifiers = 1 } }
u.addons = { Attune = true, Guide = true, DBM = false, ["Z-Settings"] = true }
Z_BUNDLE = text
useChar(u, {}); ZSettingsDB = nil
DBM_AllSavedOptions = nil   -- DBM has no table of its own here yet
saves = 0
SlashCmdList.ZSETTINGS("import"); pressKeys("A")
u.ZSettingsDB = ZSettingsDB
check("4 import applied", u.cvars.nameplateShowEnemies == "0" and u.addons.DBM == true and GetMacroIndexByName("Mana") > 0)
check("4 settings of an addon that wasn't running are left for later", DBM_AllSavedOptions == nil and said("aren't running"))
useChar(u, {}); ZSettingsDB = u.ZSettingsDB
fire("PLAYER_LOGIN")
check("4 once it runs, its settings are offered", offered():find("Addon settings", 1, true) ~= nil)
check("4 own macro with a shared name updated, not taken over", macroBody("Focus") ~= "/say mine" and not ZSettingsDB.owned.Focus)
check("4 addon switches are saved", saves > 0)
-- after the import the friend makes a layout, changes a setting the import left alone, adds a spell click
table.insert(uAcc.editmode.layouts.layouts, { layoutName = "Healer", layoutType = 1, systems = { { system = 0, x = 3 } } })
u.cvars.autoLootDefault = "0"
table.insert(u.clicks, { type = 1, actionID = 140, button = "MiddleButton", modifiers = 0 })
useChar(u, {}); ZSettingsDB = u.ZSettingsDB
reloads, addonCalls = 0, {}
SlashCmdList.ZSETTINGS("undo")
check("4 undo reloads the UI", reloads == 1)
local thisCharOnly = #addonCalls > 0
for _, c in ipairs(addonCalls) do if c ~= "Undoer" then thisCharOnly = false end end
check("4 undo puts back addon states for this character only", thisCharOnly)
check("4 setting back", u.cvars.nameplateShowEnemies == "1")
local names = {}
for _, l in ipairs(uAcc.editmode.layouts.layouts) do names[#names + 1] = l.layoutName end
check("4 shared layout removed, a layout made since kept", table.concat(names, ",") == "Main,Healer")
check("4 own layout selected again", u.activeLayout == 3)
check("4 keybinds back", keyOf(uAcc, "MOVEFORWARD") == "W" and keyOf(uAcc, "MULTIACTIONBAR2BUTTON1") == nil)
check("4 brought macros removed", GetMacroIndexByName("Mana") == 0)
check("4 own macro with a shared name back as it was", macroBody("Focus") == "/say mine")
check("4 own macro kept", GetMacroIndexByName("Own macro") > 0)
check("4 a setting the import left alone keeps the friend's later change", u.cvars.autoLootDefault == "0")
check("4 a spell click added since stays", (function() for _, b in ipairs(u.clicks) do if b.actionID == 140 then return true end end end)() == true)
check("4 target click back", (function() for _, b in ipairs(u.clicks) do if b.type == 3 and b.actionID == 2 then return true end end end)() == true)
check("4 DBM switched off again", u.addons.DBM == false)
check("4 undo used up", ZSettingsDB.undo["Undoer-Classic Beta PvP"] == nil)
useChar(u, {}); ZSettingsDB = u.ZSettingsDB
SlashCmdList.ZSETTINGS("update")
local marked = updatedLabels()
check("4 after undo the reverted parts count as differing again",
  marked:find("Chat windows", 1, true) and marked:find("Edit Mode layout", 1, true))
printed, reloads = {}, 0
SlashCmdList.ZSETTINGS("undo")
check("4 second undo does nothing", said("nothing to undo") and reloads == 0)
-- a table that didn't exist before the import is gone again after undo
u.addons.DBM = true
useChar(u, {}); ZSettingsDB = u.ZSettingsDB
DBM_AllSavedOptions = nil
SlashCmdList.ZSETTINGS("import"); pressKeys("A")
check("4 a running addon gets its settings", DBM_AllSavedOptions ~= nil)
useChar(u, {}); ZSettingsDB = u.ZSettingsDB
SlashCmdList.ZSETTINGS("undo")
check("4 a table that didn't exist is gone again", DBM_AllSavedOptions == nil)
-- a table over the size cap comes back whole
local big = string.rep("y", 400000)
useChar(u, {}); ZSettingsDB = u.ZSettingsDB
DBM_AllSavedOptions = { blob = big }
SlashCmdList.ZSETTINGS("import"); pressKeys("A")
useChar(u, {}); ZSettingsDB = u.ZSettingsDB
SlashCmdList.ZSETTINGS("undo")
check("4 a table over the size cap comes back", type(DBM_AllSavedOptions) == "table" and DBM_AllSavedOptions.blob == big)
-- a later setup without my Focus never deletes the friend's own Focus
do
  local noFocus = decodeSetup(text)
  noFocus.macros.Focus = nil
  Z_BUNDLE = encodeSetup(noFocus)
  useChar(u, {}); ZSettingsDB = u.ZSettingsDB
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  check("4 own macro survives a setup that drops that name", GetMacroIndexByName("Focus") > 0)
  Z_BUNDLE = text
end
-- an old bundle's data tables are not applied, so undo doesn't roll back the friend's own data either
do
  local old = decodeSetup(text)
  old.settings.Attune_DB = { addon = "Attune", data = C_EncodingUtil.SerializeCBOR({ toons = { Zeroshin = 1 } }) }
  Z_BUNDLE = encodeSetup(old)
  useChar(u, { Attune_DB = { toons = { Undoer = 1 } } }); ZSettingsDB = u.ZSettingsDB
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  Attune_DB.toons.Undoer = 2   -- the friend's own progress moves on
  useChar(u, {}); ZSettingsDB = u.ZSettingsDB
  SlashCmdList.ZSETTINGS("undo")
  check("4 undo leaves the friend's own data tables alone", Attune_DB.toons.Undoer == 2 and Attune_DB.toons.Zeroshin == nil)
  Z_BUNDLE = text
end
-- two characters share the Zeroshin UI layout: undo on one keeps it for the other
do
  local wAcc = newAccount()
  local w1 = newChar("Wone", "Classic Beta PvP", wAcc, { "Fireball" })
  local w2 = newChar("Wtwo", "Classic Beta PvP", wAcc, { "Fireball" })
  useChar(w1, {}); ZSettingsDB = nil
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  local shared = ZSettingsDB
  useChar(w2, {}); ZSettingsDB = shared
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  useChar(w1, {}); ZSettingsDB = shared
  SlashCmdList.ZSETTINGS("undo")
  local wNames = {}
  for _, l in ipairs(wAcc.editmode.layouts.layouts) do wNames[#wNames + 1] = l.layoutName end
  check("4 undo keeps the shared layout another character still uses", table.concat(wNames, ",") == "Main,Zeroshin UI")
  check("4 that character's own layout selected again", w1.activeLayout == 3)
end
-- an older version's undo still works once, and never deletes what the friend made since
do
  local lAcc = newAccount()
  lAcc.general = { { "Since macro", 9, "/wave" } }   -- made after the old import
  table.insert(lAcc.editmode.layouts.layouts, { layoutName = "Zeroshin", layoutType = 1, systems = { { system = 0, x = 77 } } })
  table.insert(lAcc.editmode.layouts.layouts, { layoutName = "Since", layoutType = 1, systems = { { system = 0, x = 4 } } })
  local l = newChar("Legacy", "Classic Beta PvP", lAcc, { "Fireball" })
  lAcc.general[#lAcc.general + 1] = { "Focus", 1, "/focus [@mouseover,harm] mouseover; target" }   -- the old import's
  useChar(l, {})
  local oldCapture = { format = 1, macros = {}, editmode = { layouts = { layouts = { { layoutName = "Main", layoutType = 1, systems = {} } }, activeLayout = 3 } } }
  ZSettingsDB = { undo = encodeSetup(oldCapture) }
  SlashCmdList.ZSETTINGS("undo")
  local lNames = {}
  for _, x in ipairs(lAcc.editmode.layouts.layouts) do lNames[#lNames + 1] = x.layoutName end
  check("4 the old undo removes the old import's macro", GetMacroIndexByName("Focus") == 0)
  check("4 the old undo keeps a macro made since", GetMacroIndexByName("Since macro") > 0)
  check("4 the old undo removes only the shared layout", table.concat(lNames, ",") == "Main,Since")
  printed = {}
  SlashCmdList.ZSETTINGS("undo")
  check("4 the old undo works once", said("nothing to undo"))
  -- an apply with this version drops an old undo: undo is one step back, never two
  useChar(l, {}); ZSettingsDB = { undo = encodeSetup(oldCapture) }
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  local db = ZSettingsDB
  useChar(l, {}); ZSettingsDB = db
  printed = {}
  SlashCmdList.ZSETTINGS("undo")
  check("4 after a new apply undo takes the new step", said("what the last apply changed"))
  useChar(l, {}); ZSettingsDB = db
  printed = {}
  SlashCmdList.ZSETTINGS("undo")
  check("4 after a new apply the old undo is gone", said("nothing to undo"))
end
-- an older version's undo: a data table that still holds the setup's copy was written by the import and
-- comes back; one the friend's addon has moved on since was never touched and stays
do
  local oldBundle = decodeSetup(text)
  oldBundle.settings.Attune_DB = { addon = "Attune", data = C_EncodingUtil.SerializeCBOR({ toons = { Zeroshin = 1 } }) }
  Z_BUNDLE = encodeSetup(oldBundle)
  local capture = encodeSetup({ format = 1, settings = { Attune_DB = { addon = "Attune", data = C_EncodingUtil.SerializeCBOR({ toons = { Buddy = 1 } }) } } })
  useChar(friend, { Attune_DB = { toons = { Zeroshin = 1 } } })
  ZSettingsDB = { undo = capture }
  SlashCmdList.ZSETTINGS("undo")
  check("4 an older version's undo restores a data table its import wrote", Attune_DB.toons.Buddy == 1 and Attune_DB.toons.Zeroshin == nil)
  useChar(friend, { Attune_DB = { toons = { Buddy = 5 } } })
  ZSettingsDB = { undo = capture }
  SlashCmdList.ZSETTINGS("undo")
  check("4 an older version's undo leaves a data table its import never wrote", Attune_DB.toons.Buddy == 5)
  -- and only on the character that made it
  useChar(friend, {})
  local byCapture = encodeSetup({ format = 1, by = "Someone", settings = {} })
  ZSettingsDB = { undo = byCapture }
  printed = {}
  SlashCmdList.ZSETTINGS("undo")
  check("4 an older version's undo only runs on the character that made it", said("belongs to Someone") and ZSettingsDB.undo == byCapture)
  Z_BUNDLE = text
end

-- 5. the popup: a friend pulls, logs in and applies what differs
local mateAcc = newAccount()
mateAcc.general = { { "Mate macro", 9, "/dance" } }
local mate = newChar("Mate", "Classic Beta PvP", mateAcc, { "Fireball" })
Z_BUNDLE = text
useChar(mate, {}); ZSettingsDB = nil
printed, reloads, addonCalls = {}, 0, {}
fire("PLAYER_LOGIN")
check("5 the minimap button shows a dot while the setup differs", ZSettingsMinimapButton.due.shown == true)
check("5 popup lists only the parts that differ", offered() ==
  "Addon settings, Addons on or off, Chat windows, Edit Mode layout, General macros, Interface and nameplate settings, Keybinds")
local allTicked = #popupBoxes() > 0
for _, b in ipairs(popupBoxes()) do if not b.checked then allTicked = false end end
check("5 every listed part ticked", allTicked)
click("Apply")
check("5 first apply asks the keyboard", reloads == 0)
pressKeys("A")
mate.ZSettingsDB = ZSettingsDB
check("5 apply reloads the UI", reloads == 1)
check("5 keyboard remembered", ZSettingsDB.layout == "azerty-be")
check("5 setup applied", mate.cvars.nameplateShowEnemies == "0" and keyOf(mateAcc, "MULTIACTIONBAR2BUTTON1") == "A")
check("5 layout added and selected", (mateAcc.editmode.layouts.layouts[2] or {}).layoutName == "Zeroshin UI" and mate.activeLayout == 4)
check("5 bars untouched", next(mate.bars) == nil)
check("5 no warlock macro arrived", GetMacroIndexByName("Warlock nuke") == 0 and GetMacroIndexByName("Random nuke") == 0)
local thisChar = #addonCalls > 0
for _, c in ipairs(addonCalls) do if c ~= "Mate" then thisChar = false end end
check("5 addons switched for this character, so undo can put them back exactly", thisChar)
-- nothing differs at the next login: no popup
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("5 no popup when nothing differs", #popupBoxes() == 0)
check("5 no dot when nothing differs", ZSettingsMinimapButton.due.shown == false)
-- the friend changes a keybind by hand: the setup's keybinds differ again
local own = mateAcc.binds[1][2]
mateAcc.binds[1][2] = "I"
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("5 a changed keybind brings Keybinds back", offered() == "Keybinds")
mateAcc.binds[1][2] = own
-- the same setup with every table in another internal order is not offered again
local function reordered(v)
  if type(v) ~= "table" then return v end
  local r, keys = {}, {}
  for i = 1, 64 do r["pad" .. i] = true end   -- a bigger table puts the same keys in other slots
  for k in pairs(v) do keys[#keys + 1] = k end
  for i = #keys, 1, -1 do r[keys[i]] = reordered(v[keys[i]]) end
  for i = 1, 64 do r["pad" .. i] = nil end
  return r
end
local same = reordered(decodeSetup(text))
for _, e in pairs(same.settings) do e.data = C_EncodingUtil.SerializeCBOR(reordered(C_EncodingUtil.DeserializeCBOR(e.data))) end
Z_BUNDLE = encodeSetup(same)
check("5 the reordered copy really is stored in another order", Z_BUNDLE ~= text)
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("5 same content in another order is not offered", #popupBoxes() == 0)
Z_BUNDLE = text
-- an alt on the same account: only what differs on that character
local alt = newChar("MateAlt", "Classic Beta PvP", mateAcc, { "Fireball" })
useChar(alt, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("5 an alt is offered only its own differing parts", offered() == "Addons on or off, Chat windows, Edit Mode layout, Interface and nameplate settings")
click("Later")
useChar(alt, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("5 after Later no popup, but the dot stays", #popupBoxes() == 0 and ZSettingsMinimapButton.due.shown == true)
ZSettingsMinimapButton.scripts.OnClick(ZSettingsMinimapButton)
check("5 a friend's menu has no Export", button("Export setup").shown == false)
click("Review setup")
check("5 the menu's Review setup runs /z update: every part", #popupBoxes() == 8 and ZSettingsMenu.shown == false)
click("Later")
-- a PC that exports never gets the popup by itself, even when its bundle trails its newest export
useChar(me, {}); ZSettingsDB = { export = "ZS1:a newer export than the bundle" }
fire("PLAYER_LOGIN")
check("5 no popup on a PC that exports", #popupBoxes() == 0)
check("5 no dot on a PC that exports", ZSettingsMinimapButton.due.shown == false)
ZSettingsMinimapButton.scripts.OnClick(ZSettingsMinimapButton)
check("5 the publisher's menu has Export", button("Export setup").shown == true)
ZSettingsMenu.shown = false
SlashCmdList.ZSETTINGS("update")
check("5 /z update lists every part there", #popupBoxes() == 8)
-- combat at login: the popup waits for combat to end
local fresh = newChar("Fresh", "Classic Beta PvP", newAccount(), { "Fireball" })
useChar(fresh, {}); ZSettingsDB = nil
combat = true; fire("PLAYER_LOGIN"); combat = false
check("5 no popup in combat", #popupBoxes() == 0)
fire("PLAYER_REGEN_ENABLED")
check("5 popup once combat ends", #popupBoxes() > 0)

-- an older setup carrying an addon's own macro: never applied, never offered, never deleted as brought
do
  local old = decodeSetup(text)
  old.macros.RS_MACRO = { 8, "/targetexact Soboz" }
  Z_BUNDLE = encodeSetup(old)
  local rsAcc = newAccount()
  rsAcc.general = { { "RS_MACRO", 8, "/targetexact Other rare" } }
  local rs = newChar("Rarehunter", "Classic Beta PvP", rsAcc, { "Fireball" })
  useChar(rs, {}); ZSettingsDB = { layout = "qwerty", owned = { RS_MACRO = true } }
  SlashCmdList.ZSETTINGS("import"); pressKeys("Q")
  rs.ZSettingsDB = ZSettingsDB
  check("5 an addon's own macro is left to the addon", macroBody("RS_MACRO") == "/targetexact Other rare")
  rsAcc.general[1][3] = "/targetexact Yet another rare"   -- the addon rewrites it as you play
  useChar(rs, {}); ZSettingsDB = rs.ZSettingsDB
  fire("PLAYER_LOGIN")
  check("5 an addon rewriting its macro brings no popup", #popupBoxes() == 0)
  Z_BUNDLE = text
end

-- 6. the next iteration: I change one keybind and drop a macro, then export with a note
useChar(me, { DBM_AllSavedOptions = { warnings = true, bars = { size = 2 } }, BetterBlizzFramesDB = { castbar = 1 } })
ZSettingsDB = nil
accA.binds[#accA.binds + 1] = { "TOGGLEBAG1", "B" }
for i, m in ipairs(accA.general) do if m[1] == "Mana" then table.remove(accA.general, i) break end end
clock = clock + 3600
SlashCmdList.ZSETTINGS("export New bag key"); pressKeys("Q")
local text2 = ZSettingsDB.export
check("6 export keeps the note as typed", decodeSetup(text2).note == "New bag key")
Z_BUNDLE = text2
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
printed, reloads = {}, 0
fire("PLAYER_LOGIN")
check("6 popup lists only what changed", offered() == "General macros, Keybinds")
local noteShown = false
for _, o in ipairs(frames) do if o.text == "New bag key" then noteShown = true end end
check("6 popup shows the note", noteShown)
local bindsBox = boxFor("Keybinds")
if bindsBox then bindsBox:SetChecked(false) end
click("Apply")
check("6 second apply asks no key and reloads", reloads == 1)
check("6 unticked keybinds left alone", keyOf(mateAcc, "TOGGLEBAG1") == nil)
check("6 macro dropped from the setup is removed", GetMacroIndexByName("Mana") == 0 and GetMacroIndexByName("Focus") > 0)
check("6 friend's own macro kept", GetMacroIndexByName("Mate macro") > 0)
-- the unticked part is still offered, until Later
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("6 skipped part offered again", offered() == "Keybinds")
click("Later")
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("6 Later keeps it quiet", #popupBoxes() == 0)
-- a re-export in the same minute is a different setup: Later doesn't hide it
useChar(me, { DBM_AllSavedOptions = { warnings = true, bars = { size = 2 } }, BetterBlizzFramesDB = { castbar = 1 } })
ZSettingsDB = nil
accA.binds[#accA.binds + 1] = { "TOGGLEBAG2", "N" }
SlashCmdList.ZSETTINGS("export New bag key"); pressKeys("Q")
local text2b = ZSettingsDB.export
check("6 the re-export has the same stamp", decodeSetup(text2b).made == decodeSetup(text2).made)
Z_BUNDLE = text2b
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("6 a same-minute re-export still shows after Later", offered() == "Keybinds")
click("Later")
SlashCmdList.ZSETTINGS("update")
check("6 /z update lists every part after Later", #popupBoxes() == 8)

-- 7. undo goes one step back: only what the last apply changed
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
reloads = 0
SlashCmdList.ZSETTINGS("undo")
check("7 undo reloads", reloads == 1)
check("7 the last apply's macro change is undone", GetMacroIndexByName("Mana") > 0)
check("7 earlier applies stay", GetMacroIndexByName("Focus") > 0 and mate.cvars.nameplateShowEnemies == "0" and keyOf(mateAcc, "MULTIACTIONBAR2BUTTON1") == "A")
check("7 own macro kept", GetMacroIndexByName("Mate macro") > 0)
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("7 popup quiet until the next setup", #popupBoxes() == 0)
-- undo on an alt touches only that alt
useChar(alt, {}); ZSettingsDB = mate.ZSettingsDB
SlashCmdList.ZSETTINGS("update")
click("Apply")
check("7 the alt took the setup", alt.cvars.nameplateShowEnemies == "0")
local altSnap = decodeSetup(mate.ZSettingsDB.undo["MateAlt-Classic Beta PvP"])
check("7 the alt's undo holds only what the alt changed", altSnap.cvars.nameplateShowEnemies == "1" and altSnap.cvars.autoLootDefault == nil)
useChar(alt, {}); ZSettingsDB = mate.ZSettingsDB
SlashCmdList.ZSETTINGS("undo")
check("7 the alt's own settings back", alt.cvars.nameplateShowEnemies == "1")
check("7 the main character keeps its setup", mate.cvars.nameplateShowEnemies == "0" and keyOf(mateAcc, "MULTIACTIONBAR2BUTTON1") == "A")
local mateLayouts = {}
for _, l in ipairs(mateAcc.editmode.layouts.layouts) do mateLayouts[#mateLayouts + 1] = l.layoutName end
check("7 the shared layout stays for the main character", table.concat(mateLayouts, ",") == "Main,Zeroshin UI")
-- the next setup after an undo offers what differs again
useChar(me, { DBM_AllSavedOptions = { warnings = true, bars = { size = 2 } }, BetterBlizzFramesDB = { castbar = 1 } })
ZSettingsDB = nil
clock = clock + 3600
SlashCmdList.ZSETTINGS("export"); pressKeys("Q")
Z_BUNDLE = ZSettingsDB.export
useChar(mate, {}); ZSettingsDB = mate.ZSettingsDB
fire("PLAYER_LOGIN")
check("7 the next setup offers what differs", offered() == "General macros, Keybinds")

-- 8. characters on one account with different addons running, and the edges of undo
-- a main and an alt with different addons running don't bounce Addon settings between them
do
  local pAcc = newAccount()
  local p1 = newChar("Pone", "Classic Beta PvP", pAcc, { "Fireball" })
  local p2 = newChar("Ptwo", "Classic Beta PvP", pAcc, { "Fireball" })
  p2.addons.DBM = false
  Z_BUNDLE = text
  useChar(p1, {}); ZSettingsDB = { layout = "azerty-be" }
  local db = ZSettingsDB
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  useChar(p2, {}); ZSettingsDB = db
  fire("PLAYER_LOGIN")
  check("8 an alt without DBM running isn't offered its settings", not offered():find("Addon settings", 1, true))
  click("Later")
  useChar(p1, {}); ZSettingsDB = db
  fire("PLAYER_LOGIN")
  check("8 the main isn't offered them again after visiting the alt", #popupBoxes() == 0)
end
-- an addon switched on by the update gets its settings in a second apply, and one undo reverts both
do
  local qAcc = newAccount()
  local q = newChar("Queue", "Classic Beta PvP", qAcc, { "Fireball" })
  q.addons.DBM = false
  useChar(q, {}); ZSettingsDB = { layout = "azerty-be" }
  local db = ZSettingsDB
  DBM_AllSavedOptions = nil
  fire("PLAYER_LOGIN"); click("Apply")
  useChar(q, {}); ZSettingsDB = db
  fire("PLAYER_LOGIN")
  check("8 after the reload the switched-on addon's settings are offered", offered() == "Addon settings")
  click("Apply")
  check("8 the second apply brings the settings", DBM_AllSavedOptions ~= nil)
  useChar(q, {}); ZSettingsDB = db
  SlashCmdList.ZSETTINGS("undo")
  check("8 one undo reverts the whole update", q.cvars.nameplateShowEnemies == "1" and q.addons.DBM == false
    and DBM_AllSavedOptions == nil and keyOf(qAcc, "MOVEFORWARD") == "W")
end
-- the older version replaced every layout when no slot was free: its undo brings the whole list back
do
  local wAcc = newAccount()
  wAcc.editmode.layouts = { layouts = { { layoutName = "Main", layoutType = 1, systems = { { system = 0, x = 77 } } } }, activeLayout = 3 }
  local w = newChar("Wholesale", "Classic Beta PvP", wAcc, { "Fireball" })
  local own = { layouts = {}, activeLayout = 4 }
  for i = 1, 5 do own.layouts[i] = { layoutName = "L" .. i, layoutType = 1, systems = { { system = 0, x = i } } } end
  useChar(w, {}); ZSettingsDB = { undo = encodeSetup({ format = 1, editmode = { layouts = own } }) }
  SlashCmdList.ZSETTINGS("undo")
  local names = {}
  for _, l in ipairs(wAcc.editmode.layouts.layouts) do names[#names + 1] = l.layoutName end
  check("8 layouts the older version replaced wholesale come back", table.concat(names, ",") == "L1,L2,L3,L4,L5" and w.activeLayout == 4)
end
-- the layout selected before the apply was deleted since: undo selects a layout that exists
do
  local aAcc = newAccount()
  local a = newChar("Afall", "Classic Beta PvP", aAcc, { "Fireball" })
  useChar(a, {}); ZSettingsDB = { layout = "azerty-be" }
  local db = ZSettingsDB
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  table.remove(aAcc.editmode.layouts.layouts, 1)   -- the friend deletes their "Main"
  useChar(a, {}); ZSettingsDB = db
  SlashCmdList.ZSETTINGS("undo")
  check("8 undo selects an existing layout when the old one is gone", #aAcc.editmode.layouts.layouts == 0 and a.activeLayout == 1)
end
-- a character-only Zeroshin UI goes with undo, even while another character has the setup applied
do
  local cAcc = newAccount()
  cAcc.editmode.layouts.layouts = {}
  for i = 1, 5 do cAcc.editmode.layouts.layouts[i] = { layoutName = "C" .. i, layoutType = 1, systems = { { system = 0, x = i } } } end
  local c = newChar("Conly", "Classic Beta PvP", cAcc, { "Fireball" })
  useChar(c, {}); ZSettingsDB = { layout = "azerty-be", applied = { ["Other-Classic Beta PvP"] = { editmode = 1 } } }
  local db = ZSettingsDB
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  useChar(c, {}); ZSettingsDB = db
  SlashCmdList.ZSETTINGS("undo")
  check("8 undo removes a character-only Zeroshin UI", #cAcc.editmode.layouts.layouts == 5)
end
-- undo on two characters leaves the brought-macros list right, so a friend's later own macro is safe
do
  local oAcc = newAccount()
  local o1 = newChar("Oone", "Classic Beta PvP", oAcc, { "Fireball" })
  local o2 = newChar("Otwo", "Classic Beta PvP", oAcc, { "Fireball" })
  useChar(o1, {}); ZSettingsDB = { layout = "azerty-be" }
  local db = ZSettingsDB
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  useChar(o2, {}); ZSettingsDB = db
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  useChar(o1, {}); ZSettingsDB = db
  SlashCmdList.ZSETTINGS("undo")
  useChar(o2, {}); ZSettingsDB = db
  SlashCmdList.ZSETTINGS("undo")
  oAcc.general[#oAcc.general + 1] = { "Mana", 3, "/say my own" }   -- the friend makes their own Mana
  local noMana = decodeSetup(text)
  noMana.macros.Mana = nil
  Z_BUNDLE = encodeSetup(noMana)
  useChar(o1, {}); ZSettingsDB = db
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  check("8 a friend's own macro made after two undos survives", macroBody("Mana") == "/say my own")
  Z_BUNDLE = text
end
-- Later and undo quiet only their own character
do
  local lAcc = newAccount()
  local l1 = newChar("Lone", "Classic Beta PvP", lAcc, { "Fireball" })
  local l2 = newChar("Ltwo", "Classic Beta PvP", lAcc, { "Fireball" })
  useChar(l1, {}); ZSettingsDB = { layout = "azerty-be" }
  local db = ZSettingsDB
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  useChar(l1, {}); ZSettingsDB = db
  SlashCmdList.ZSETTINGS("undo")
  useChar(l2, {}); ZSettingsDB = db
  fire("PLAYER_LOGIN")
  check("8 an undo on one character doesn't quiet another", #popupBoxes() > 0)
end
Z_BUNDLE = nil

-- 9. copying one of my characters onto another, any class, on the same game account and across accounts
do
  SVS = { DBM = "DBM_AllSavedOptions", Guide = "GuideDB", SpyGodMode = "SpyGodModeDB", ["Z-Settings"] = "ZSettingsDB" }
  SVCS = { DBM = "DBM_Char", GTFO = "GTFOChar" }
  local cAcc = newAccount()
  cAcc.general = { { "Shared", 1, "/wave" } }
  local src = newChar("Src", "R", cAcc, { "Shadow Bolt", "Fear" })
  local dst = newChar("Dst", "R", cAcc, { "Fear" })
  dst.class = "Mage"
  src.charMacros = { { "Tap", 5, "/cast Life Tap" } }
  dst.charMacros = { { "Blink", 1, "/cast Blink" } }
  src.bars = { [1] = { kind = "spell", id = 1 }, [2] = { kind = "spell", id = 6 }, [3] = { kind = "macro", name = "Tap" }, [4] = { kind = "item", id = 6948 } }
  dst.bars = { [1] = { kind = "spell", id = 6 }, [9] = { kind = "macro", name = "Blink" } }
  src.clicks = { { type = 2, actionID = 121, button = "LeftButton", modifiers = 2 } }
  src.cvars.showTargetOfTarget, dst.cvars.showTargetOfTarget = "1", "0"
  src.cvars.nameplateShowEnemies, dst.cvars.nameplateShowEnemies = "0", "1"
  src.cvars.enableMultiActionBars, dst.cvars.enableMultiActionBars = "31", "1"   -- which bars show
  cAcc.editmode.layouts.layouts[1].systems[1].x = 40   -- Src's account layout, before Dst's account moves it
  cAcc.editmode.layouts.layouts[2] = { layoutName = "Src own", layoutType = 2, systems = { { system = 0, x = 3 } } }
  cAcc.editmode.layouts.activeLayout = 4
  src.cdm, dst.cdm = "src-cdm", "dst-cdm"
  src.chat[3] = { "Trade", 12, 0, 0, 0, 0.5, true, true, 3, false, nil, nil, nil, nil, nil, { "CHANNEL" }, {} }
  src.addons = { DBM = true, GTFO = true, Guide = true, ["Z-Settings"] = true, SpyGodMode = true }
  dst.addons = { DBM = true, GTFO = false, Guide = true, ["Z-Settings"] = true, SpyGodMode = false }
  local guide = { profileKeys = { ["Src - R"] = "Src - R", ["Other - R"] = "Default" },
    profiles = { ["Src - R"] = { size = 5 }, Default = { size = 1 } }, char = { ["Src - R"] = { seen = 1 } } }

  useChar(src, { DBM_Char = { src = 1 }, GTFOChar = { g = 1 }, GuideDB = deepcopy(guide), DBM_AllSavedOptions = { warnings = true } })
  ZSettingsDB = { applied = { ["Src-R"] = { editmode = 111 }, ["Dst-R"] = { editmode = 222 } } }
  printed = {}
  SlashCmdList.ZSETTINGS("save")
  local db = ZSettingsDB
  check("9 save kept for this character", db.characters and type(db.characters["Src-R"]) == "string" and db.characters["Src-R"]:sub(1, 4) == "ZC1:")
  check("9 save says what it kept", said("saved Src%-R"))
  local saved = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(db.characters["Src-R"]:sub(5))))
  check("9 save holds per-character tables", saved.charTables.DBM_Char ~= nil and saved.charTables.GTFOChar ~= nil)
  check("9 save leaves SpyGodMode and Z-Settings out", saved.accountTables.SpyGodModeDB == nil and saved.accountTables.ZSettingsDB == nil)

  -- the help lists every command
  printed = {}
  SlashCmdList.ZSETTINGS("help")
  check("9 help lists every command", said("/z update") and said("/z import") and said("/z undo") and said("/z export") and said("/z save") and said("/z copy"))

  -- since the save, an account-wide addon profile changed
  guide.profiles.Default.size = 2
  useChar(dst, { DBM_Char = { dst = 1 }, GTFOChar = nil, GuideDB = deepcopy(guide) })
  ZSettingsDB = db
  cAcc.editmode.layouts.layouts[1].systems[1].x = 12   -- Dst's account had moved the frames
  printed, reloads = {}, 0
  SlashCmdList.ZSETTINGS("copy src")
  check("9 copy reloads the UI", reloads == 1)
  check("9 bars copied by what they hold", barName(dst, 2) == "spell:6" and barName(dst, 3) == "macro:Tap" and barName(dst, 4) == "item:6948")
  check("9 a spell this class lacks is left off and listed", dst.bars[1] == nil and said("Shadow Bolt"))
  check("9 a button the source lacks is cleared", GetActionInfo(9) == nil)
  check("9 character macros replaced", GetMacroIndexByName("Tap") > 0 and GetMacroIndexByName("Blink") == 0)
  check("9 General macros copied", macroBody("Shared") == "/wave")
  check("9 macro click follows the macro", #dst.clicks == 1 and dst.clicks[1].type == 2 and dst.clicks[1].actionID == GetMacroIndexByName("Tap"))
  check("9 per-character setting copied", dst.cvars.showTargetOfTarget == "1")
  check("9 the setup popup compares against the source's layout", db.applied["Dst-R"].editmode == 111)
  check("9 account setting copied", dst.cvars.nameplateShowEnemies == "0")
  check("9 which action bars show copied", dst.cvars.enableMultiActionBars == "31")
  local cem = cAcc.editmode.layouts
  check("9 UI positions copied", cem.layouts[1].systems[1].x == 40)
  check("9 source's layout selected", cem.activeLayout == 4 and dst.activeLayout == 4 and cem.layouts[2].layoutName == "Src own")
  check("9 Cooldown Manager and chat copied", dst.cdm == "src-cdm" and dst.chat[3][1] == "Trade")
  check("9 addons switched like the source", dst.addons.GTFO == true and dst.addons.SpyGodMode == false)
  check("9 per-character addon table copied", DBM_Char.src == 1 and DBM_Char.dst == nil)
  check("9 profile copied under this character's name", GuideDB.profileKeys["Dst - R"] == "Dst - R" and GuideDB.profiles["Dst - R"].size == 5)
  check("9 character data copied", GuideDB.char["Dst - R"] and GuideDB.char["Dst - R"].seen == 1)
  check("9 shared addon files: shared profile as it is now", GuideDB.profiles.Default.size == 2 and GuideDB.profileKeys["Other - R"] == "Default")
  check("9 an addon it switched on waits for the reload", said("one more reload follows for the settings of: GTFO"))

  -- the reload: GTFO runs now and gets its table, then one more reload
  dst.addons.GTFO = true
  useChar(dst, { GTFOChar = { old = 1 } })
  ZSettingsDB = db
  printed, reloads = {}, 0
  fire("PLAYER_LOGIN")
  check("9 after the reload the switched-on addon's table follows", GTFOChar.g == 1 and reloads == 1)
  check("9 the setup popup waits for that reload", #popupBoxes() == 0)
  printed, reloads = {}, 0
  fire("PLAYER_LOGIN")
  check("9 the follow-up runs once", reloads == 0)

  -- undo puts this character back
  useChar(dst, {})
  ZSettingsDB = db
  SlashCmdList.ZSETTINGS("undo")
  check("9 undo: bars back", barName(dst, 1) == "spell:6" and barName(dst, 9) == "macro:Blink" and GetActionInfo(3) == nil)
  check("9 undo: macros back", GetMacroIndexByName("Blink") > 0 and GetMacroIndexByName("Tap") == 0)
  check("9 undo: settings, Cooldown Manager, addons back", dst.cvars.showTargetOfTarget == "0" and dst.cdm == "dst-cdm" and dst.addons.GTFO == false)
  check("9 undo: addon tables back, the follow-up's too", DBM_Char.dst == 1 and GTFOChar.old == 1 and GuideDB.profileKeys["Dst - R"] == nil)
  check("9 undo: the source's own entries stay", GuideDB.profileKeys["Src - R"] == "Src - R")
  check("9 undo: the setup popup's record back", db.applied["Dst-R"].editmode == 222)

  -- another game account: the save arrives through ./characters
  Z_CHARACTERS = { ["Src-R"] = db.characters["Src-R"] }
  local xAcc = newAccount()
  xAcc.general = { { "Mine", 2, "/sit" } }
  local x = newChar("Xen", "R", xAcc, { "Fear" })
  x.addons = { DBM = true, GTFO = false, Guide = true, ["Z-Settings"] = true }
  useChar(x, { GuideDB = { profileKeys = { ["Yon - R"] = "Yon - R" }, profiles = { ["Yon - R"] = { size = 9 } } }, DBM_AllSavedOptions = { warnings = false } })
  ZSettingsDB = nil
  printed, reloads = {}, 0
  SlashCmdList.ZSETTINGS("copy")
  local row
  for _, o in ipairs(frames) do if o.kind == "Button" and o.text:find("^Src%-R, Warlock, saved ") then row = o end end
  check("9 the picker lists the other account's save", row ~= nil)
  check("9 Copy waits for a choice", button("Copy") and button("Copy").enabled == false and reloads == 0)
  if row then row.scripts.OnClick() end
  check("9 choosing a character copies nothing yet", reloads == 0 and button("Copy").enabled == true)
  click("Copy")
  check("9 other account: copy reloads", reloads == 1)
  check("9 other account: General macros copied", macroBody("Shared") == "/wave" and GetMacroIndexByName("Mine") == 0)
  check("9 other account: keybinds copied", keyOf(xAcc, "MOVEFORWARD") == keyOf(cAcc, "MOVEFORWARD"))
  check("9 other account: account settings copied", x.cvars.nameplateShowEnemies == "0")
  check("9 other account: account addon table copied", DBM_AllSavedOptions.warnings == true)
  check("9 other account: its other characters keep their profiles", GuideDB.profileKeys["Yon - R"] == "Yon - R" and GuideDB.profiles["Yon - R"].size == 9)
  check("9 other account: profile copied", GuideDB.profileKeys["Xen - R"] == "Xen - R" and GuideDB.profiles["Xen - R"].size == 5)
  check("9 other account: layouts copied", xAcc.editmode.layouts.layouts[2] and xAcc.editmode.layouts.layouts[2].layoutName == "Src own")

  -- nothing saved, and a name that isn't saved
  useChar(newChar("Lonely", "R", newAccount(), {}), {})
  ZSettingsDB, Z_CHARACTERS = nil, nil
  printed, reloads = {}, 0
  SlashCmdList.ZSETTINGS("copy")
  check("9 nothing saved is explained", said("no saved characters") and reloads == 0)
  Z_CHARACTERS = { ["Src-R"] = db.characters["Src-R"] }
  printed = {}
  SlashCmdList.ZSETTINGS("copy Nobody")
  check("9 an unknown name lists the saved ones", said("Src%-R") and reloads == 0)
  combat = true; printed = {}
  SlashCmdList.ZSETTINGS("copy Src"); combat = false
  check("9 no copy in combat", said("not in combat") and reloads == 0)
  Z_CHARACTERS = nil
end

-- 10. addons with a profile per character (AceDB: Dominos, Questie): the exporter's active profile
-- travels and lands as "Zeroshin UI", selected on the character that applies it
do
  AceDBLib = { db_registry = {} }
  LibStub = function(name) if name == "AceDB-3.0" then return AceDBLib end end
  local function aceRegister(var, key)
    local db = { sv = _G[var], keys = { char = key, profile = (_G[var].profileKeys or {})[key] or "Default" } }
    function db:GetCurrentProfile() return self.keys.profile end
    function db:SetProfile(name) self.keys.profile = name; self.sv.profileKeys = self.sv.profileKeys or {}; self.sv.profileKeys[self.keys.char] = name end
    AceDBLib.db_registry = { [db] = true }
    return db
  end
  local lockAcc, budAcc = newAccount(), newAccount()
  local lock = newChar("Zeroshin", "Lock", lockAcc, {})
  lock.addons = { Guide = true, Details = true, ["Z-Settings"] = true }
  SVS = { Guide = "GuideDB", Details = "_detalhes_global", ["Z-Settings"] = "ZSettingsDB" }
  -- Details keeps every character's profile in its account table and picks one per character
  Details = { GetCurrentProfileName = function() return _detalhes_database.active_profile end,
    -- like Details: switching first saves the live windows into the profile being left
    ApplyProfile = function(self, name, noSave)
      if not _detalhes_global.__profiles[name] then return false end
      if not noSave then self:SaveProfile() end
      _detalhes_database.active_profile = name; self.live = _detalhes_global.__profiles[name].win; return true end,
    SaveProfile = function(self) if self.live then _detalhes_global.__profiles[_detalhes_database.active_profile] = { win = self.live } end end }
  useChar(lock, { GuideDB = { profileKeys = { ["Zeroshin Lock"] = "Warlock", ["Alt Lock"] = "Default" },
    profiles = { Warlock = { bars = 5 }, Default = { bars = 1 } },
    namespaces = { Progress = { profiles = { Warlock = { xp = true } } } } },
    _detalhes_global = { __profiles = { ["Zeroshin-Lock"] = { win = 7 } } }, _detalhes_database = { active_profile = "Zeroshin-Lock" } })
  aceRegister("GuideDB", "Zeroshin Lock")
  ZSettingsDB = nil
  SlashCmdList.ZSETTINGS("export"); pressKeys("Q")
  local d = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(ZSettingsDB.export:sub(5))))
  local p = d.profiles and d.profiles.GuideDB and C_EncodingUtil.DeserializeCBOR(d.profiles.GuideDB.data)
  check("10 the active profile is exported", p and p.profile.bars == 5)
  check("10 its namespaces travel with it", p and p.namespaces.Progress.xp == true)
  check("10 the whole table still isn't shared", d.settings.GuideDB == nil)
  local dp = d.profiles and d.profiles._detalhes_global and C_EncodingUtil.DeserializeCBOR(d.profiles._detalhes_global.data)
  check("10 Details: the active profile is exported", dp and dp.win == 7)
  check("10 Details: its account table isn't shared whole", d.settings._detalhes_global == nil)
  local shared = ZSettingsDB.export
  _detalhes_global.__profiles["Zeroshin-Lock"].win = 8; Details.live = 8
  SlashCmdList.ZSETTINGS("export"); pressKeys("Q")
  local shared8 = ZSettingsDB.export

  local bud = newChar("Buddy", "Pal", budAcc, {})
  bud.addons = { Guide = true, ["Z-Settings"] = true }
  useChar(bud, { GuideDB = { profileKeys = { ["Buddy Pal"] = "Mine", ["Other Pal"] = "Mine" }, profiles = { Mine = { bars = 9 } } },
    _detalhes_global = { __profiles = { ["Buddy-Pal"] = { win = 1 } } }, _detalhes_database = { active_profile = "Buddy-Pal" } })
  local db = aceRegister("GuideDB", "Buddy Pal")
  Details.live = 1
  ZSettingsDB, Z_BUNDLE = nil, shared
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  check("10 the profile lands as Zeroshin UI", GuideDB.profiles["Zeroshin UI"] and GuideDB.profiles["Zeroshin UI"].bars == 5)
  check("10 and is selected on this character", db:GetCurrentProfile() == "Zeroshin UI" and GuideDB.profileKeys["Buddy Pal"] == "Zeroshin UI")
  local nsp = GuideDB.namespaces and GuideDB.namespaces.Progress and GuideDB.namespaces.Progress.profiles
  check("10 namespace profile lands too", nsp and nsp["Zeroshin UI"] and nsp["Zeroshin UI"].xp == true)
  check("10 their own profiles stay", GuideDB.profiles.Mine.bars == 9 and GuideDB.profileKeys["Other Pal"] == "Mine")
  check("10 Details: profile lands and is selected", _detalhes_global.__profiles["Zeroshin UI"] and _detalhes_global.__profiles["Zeroshin UI"].win == 7 and _detalhes_database.active_profile == "Zeroshin UI")
  check("10 Details: their own profile stays", _detalhes_global.__profiles["Buddy-Pal"] and _detalhes_global.__profiles["Buddy-Pal"].win == 1)
  SlashCmdList.ZSETTINGS("undo")
  check("10 undo selects their profile again", db:GetCurrentProfile() == "Mine" and GuideDB.profileKeys["Buddy Pal"] == "Mine")
  check("10 undo removes the shared profile nobody else uses", GuideDB.profiles["Zeroshin UI"] == nil)
  check("10 Details: undo selects their profile again", _detalhes_database.active_profile == "Buddy-Pal")

  GuideDB.profileKeys["Other Pal"] = "Zeroshin UI"
  GuideDB.profiles["Zeroshin UI"] = { bars = 4 }
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  SlashCmdList.ZSETTINGS("undo")
  check("10 undo keeps the shared profile another character uses", GuideDB.profiles["Zeroshin UI"] and GuideDB.profiles["Zeroshin UI"].bars == 4 and GuideDB.profileKeys["Other Pal"] == "Zeroshin UI")
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  check("10 Details: re-applied", _detalhes_database.active_profile == "Zeroshin UI" and Details.live == 7)
  Z_BUNDLE = shared8
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  check("10 Details: a newer setup replaces the selected shared profile", _detalhes_global.__profiles["Zeroshin UI"].win == 8 and Details.live == 8)
  SlashCmdList.ZSETTINGS("undo")
  check("10 Details: undo puts the earlier shared profile back", _detalhes_global.__profiles["Zeroshin UI"].win == 7 and Details.live == 7)
  Z_BUNDLE = shared
  LibStub, AceDBLib, Z_BUNDLE, Details = nil, nil, nil, nil
end

-- 11. windows the player moved (WoW keeps them per character in layout-local.txt) travel by name
do
  local function placed(name, point, x, y, user)
    local f = { name = name, pt = { point, UIParent, point, x, y }, user = user }
    function f:GetName() return self.name end
    function f:IsUserPlaced() return self.user end
    function f:IsMovable() return true end
    function f:GetNumPoints() return 1 end
    function f:GetPoint() return unpack(self.pt) end
    function f:ClearAllPoints() self.pt = {} end
    function f:SetPoint(p, rel, rp, px, py) self.pt = { p, rel, rp, px, py } end
    function f:SetUserPlaced(b) self.user = b end
    _G[name] = f
    return f
  end
  local list
  EnumerateFrames = function(prev)
    if not prev then return list[1] end
    for i, f in ipairs(list) do if f == prev then return list[i + 1] end end
  end
  local lock = newChar("Zeroshin", "Lock", newAccount(), {})
  lock.addons = { ["Z-Settings"] = true }
  SVS = { ["Z-Settings"] = "ZSettingsDB" }
  useChar(lock, {})
  list = { placed("RXPFrame", "TOPRIGHT", -217, -72, true), placed("Minimap", "TOPRIGHT", 0, 0, false) }
  ZSettingsDB = nil
  SlashCmdList.ZSETTINGS("export"); pressKeys("Q")
  local d = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(ZSettingsDB.export:sub(5))))
  check("11 a moved window's position is exported", d.positions and d.positions.RXPFrame and d.positions.RXPFrame[3] == -217)
  check("11 a window nobody moved isn't", d.positions and d.positions.Minimap == nil)
  local shared = ZSettingsDB.export

  local bud = newChar("Buddy", "Pal", newAccount(), {})
  bud.addons = { ["Z-Settings"] = true }
  useChar(bud, {})
  local rxp = placed("RXPFrame", "CENTER", 5, 5, true)
  list = { rxp }
  RareFrame = nil
  ZSettingsDB, Z_BUNDLE = nil, shared
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  check("11 the window moves there", rxp.pt[1] == "TOPRIGHT" and rxp.pt[4] == -217 and rxp.pt[5] == -72 and rxp.user == true)
  SlashCmdList.ZSETTINGS("undo")
  check("11 undo puts it back", rxp.pt[1] == "CENTER" and rxp.pt[4] == 5)
  EnumerateFrames, RXPFrame, Minimap, Z_BUNDLE = nil, nil, nil, nil
end

-- 12. Baganator's settings stay each player's own: never exported, and an older setup that carries
-- them doesn't overwrite theirs
do
  local lock = newChar("Zeroshin", "Lock", newAccount(), {})
  lock.addons = { Baganator = true, ["Z-Settings"] = true }
  SVS = { Baganator = "BAGANATOR_CONFIG", ["Z-Settings"] = "ZSettingsDB" }
  useChar(lock, { BAGANATOR_CONFIG = { bag_view_type = "category" } })
  ZSettingsDB = nil
  SlashCmdList.ZSETTINGS("export"); pressKeys("Q")
  local d = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(ZSettingsDB.export:sub(5))))
  check("12 Baganator settings not exported", d.settings.BAGANATOR_CONFIG == nil)
  d.settings.BAGANATOR_CONFIG = { addon = "Baganator", data = C_EncodingUtil.SerializeCBOR({ bag_view_type = "category" }) }
  local old = "ZS1:" .. C_EncodingUtil.EncodeBase64(C_EncodingUtil.CompressString(C_EncodingUtil.SerializeCBOR(d)))
  local bud = newChar("Buddy", "Pal", newAccount(), {})
  bud.addons = { Baganator = true, ["Z-Settings"] = true }
  useChar(bud, { BAGANATOR_CONFIG = { bag_view_type = "single" } })
  ZSettingsDB, Z_BUNDLE = nil, old
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  check("12 an older setup's Baganator settings don't land", BAGANATOR_CONFIG.bag_view_type == "single")
  Z_BUNDLE = nil
end

-- 13. tables of the exporter's own data stay home; their options still travel
do
  local lock = newChar("Zeroshin", "Lock", newAccount(), {})
  lock.addons = { Syndicator = true, DataStore = true, Details = true, Loot = true, ["Z-Settings"] = true }
  SVS = { Syndicator = "SYNDICATOR_CONFIG, SYNDICATOR_DATA, SYNDICATOR_SUMMARIES",
    DataStore = "DataStore_Containers_Characters, DataStore_Mails_Options", Details = "__details_backup",
    Loot = "ForeverLootSparklesDB", ["Z-Settings"] = "ZSettingsDB" }
  useChar(lock, { SYNDICATOR_CONFIG = { show_inventory_tooltips = true }, SYNDICATOR_DATA = { Characters = { me = 1 } },
    SYNDICATOR_SUMMARIES = { Characters = { me = 1 } }, DataStore_Containers_Characters = { me = 1 },
    DataStore_Mails_Options = { ScanMailBody = true }, __details_backup = { _instance_backup = { 1 } },
    ForeverLootSparklesDB = { sparkleHerbs = true, savedCVars = { SoftTargetInteract = "3" } } })
  ZSettingsDB = nil
  SlashCmdList.ZSETTINGS("export"); pressKeys("Q")
  local d = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(ZSettingsDB.export:sub(5))))
  local st = d.settings
  check("13 Syndicator's bag data stays home", st.SYNDICATOR_DATA == nil and st.SYNDICATOR_SUMMARIES == nil)
  check("13 Syndicator's options travel", st.SYNDICATOR_CONFIG ~= nil)
  check("13 DataStore's character data stays home", st.DataStore_Containers_Characters == nil)
  check("13 DataStore's options travel", st.DataStore_Mails_Options ~= nil)
  check("13 Details' window backup stays home", st.__details_backup == nil)
  local loot = st.ForeverLootSparklesDB and C_EncodingUtil.DeserializeCBOR(st.ForeverLootSparklesDB.data)
  check("13 a table's saved interface settings are cut, its options travel", loot and loot.sparkleHerbs == true and loot.savedCVars == nil)
  -- a setup published earlier still carries them: they don't land
  d.settings.SYNDICATOR_DATA = { addon = "Syndicator", data = C_EncodingUtil.SerializeCBOR({ Characters = { me = 1 } }) }
  d.settings.ForeverLootSparklesDB = { addon = "Loot", data = C_EncodingUtil.SerializeCBOR({ sparkleHerbs = false, savedCVars = { a = "1" } }) }
  local old = "ZS1:" .. C_EncodingUtil.EncodeBase64(C_EncodingUtil.CompressString(C_EncodingUtil.SerializeCBOR(d)))
  local bud = newChar("Buddy", "Pal", newAccount(), {})
  bud.addons = lock.addons
  useChar(bud, { SYNDICATOR_DATA = { Characters = { bud = 1 } }, ForeverLootSparklesDB = { sparkleHerbs = true, savedCVars = { b = "2" } } })
  ZSettingsDB, Z_BUNDLE = nil, old
  SlashCmdList.ZSETTINGS("import"); pressKeys("A")
  check("13 an older setup's bag data doesn't land", SYNDICATOR_DATA.Characters.bud == 1 and SYNDICATOR_DATA.Characters.me == nil)
  check("13 an older setup's options land, their saved interface settings stay", ForeverLootSparklesDB.sparkleHerbs == false and ForeverLootSparklesDB.savedCVars.b == "2")
  Z_BUNDLE = nil
end

io.write(("%d passed, %d failed\n"):format(passed, failed))
