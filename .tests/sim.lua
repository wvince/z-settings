-- Simulated WoW for Z-Settings: you export, a friend imports on another PC, then undoes.
local ADDON = ...

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
    cvars = { nameplateShowEnemies = "1", enableMouseoverCast = "0", graphicsQuality = "9",
              SoftTargetEnemy = "1", enableMultiActionBars = "15", Sound_MasterVolume = "1.0",
              hardTrackedQuests = name .. "-quests", autoLootDefault = "1" },
    cdm = name .. "-cdm",
    chat = { [1] = { "General", 14, 0, 0, 0, 0.4, true, true, nil, false, "TOPLEFT", 10, 10, 400, 200, { "SAY", "PARTY" }, { "General" } },
             [2] = { "Combat Log", 14, 0, 0, 0, 0.4, true, true, 1, false, nil, nil, nil, nil, nil, {}, {} } },
    addons = { DBM = true, GTFO = false, Leatrix_Plus = true, BarSync = true } }
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
date = os.date  -- WoW global
function print(...) local t = {} for i = 1, select("#", ...) do t[#t + 1] = tostring(select(i, ...)) end printed[#printed + 1] = table.concat(t, " ") end
function UnitName() return cur.name end
function GetRealmName() return cur.realm end
function UnitClass() return "Warlock", "WARLOCK" end
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
function SaveBindings() end
function GetCurrentBindingSet() return 1 end
C_KeyBindings = { GetBindingContextForAction = function() return 1 end }

C_ClickBindings = {
  GetProfileInfo = function() return deepcopy(cur.clicks) end,
  SetProfileByInfo = function(p) cur.clicks = deepcopy(p) end,
}

local CVAR_META = {
  nameplateShowEnemies = { 4, true }, enableMouseoverCast = { 3, true }, autoLootDefault = { 4, true },
  graphicsQuality = { 1, false }, hardTrackedQuests = { 4, true },
  SoftTargetEnemy = { 10, true }, enableMultiActionBars = { 10, false }, Sound_MasterVolume = { 7, true },
}
function ConsoleGetAllCommands()
  local out = {}
  for n, m in pairs(CVAR_META) do out[#out + 1] = { command = n, category = m[1], commandType = 0 } end
  return out
end
C_CVar = {
  GetCVar = function(n) return cur.cvars[n] end,
  SetCVar = function(n, v) cur.cvars[n] = v end,
  GetCVarInfo = function(n) local m = CVAR_META[n]; return cur.cvars[n], "0", m[2], false, false, false, false end,
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
C_AddOns = {
  GetNumAddOns = function() local n = 0 for _ in pairs(cur.addons) do n = n + 1 end return n end,
  GetAddOnInfo = function(i) local names = {} for k in pairs(cur.addons) do names[#names + 1] = k end table.sort(names) return names[i] end,
  GetAddOnEnableState = function(name) return cur.addons[name] and 2 or 0 end,
  EnableAddOn = function(name) cur.addons[name] = true end,
  DisableAddOn = function(name) cur.addons[name] = false end,
  SaveAddOns = function() end,
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
-- frames: any method works; scripts and text are kept so the test can click and type
local frames = {}
function CreateFrame(kind, name)
  local o = { scripts = {}, text = "", kind = kind, events = {} }
  setmetatable(o, { __index = function(_, k)
    if k == "SetScript" then return function(self, what, fn) self.scripts[what] = fn end end
    if k == "SetText" then return function(self, v) self.text = v end end
    if k == "GetText" then return function(self) return self.text end end
    if k == "CreateFontString" then return function() return CreateFrame("FontString") end end
    if k == "RegisterEvent" then return function(self, e) self.events[e] = true end end
    return function() end
  end })
  frames[#frames + 1] = o
  return o
end
UIParent, ChatFontNormal = {}, {}
local SVS = {}   -- addon -> "Var1, Var2"
C_AddOns.GetAddOnMetadata = function(name, key) if key == "SavedVariables" then return SVS[name] end end

-- sessions -----------------------------------------------------------------------------------
local function runTimers()
  for _ = 1, 20 do
    if #timers == 0 then return end
    local t = timers; timers = {}
    for _, fn in ipairs(t) do fn() end
  end
end

local function login(c)
  cur, timers, printed = c, {}, {}
  BarSyncDB = deepcopy(SV.BarSyncDB)
  frame = nil
  loadChatFrames()
  assert(loadstring(ADDON))()
  assert(frame == nil, "addon must not create a frame (no events)")
  assert(#timers == 0, "addon must not start timers")
end
local function bs(cmd) SlashCmdList.BARSYNC(cmd) end

local function logout() SV.BarSyncDB = deepcopy(BarSyncDB) end

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
  { "Healthstone", 3, "#showtooltip\n/cast Create Healthstone" }, { "Warlock nuke", 4, "/cast Shadow Bolt" } }
me.charMacros = { { "Tap safe", 5, "/cast [nochanneling] Life Tap" } }
me.bars = { [1] = { kind = "spell", id = 1 } }
accA.binds[1][2] = "UP"
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON1", "Q" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON2", "SHIFT-1" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON3", "ALT-Z" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON4", "SHIFT--" }
accA.binds[#accA.binds + 1] = { "MULTIACTIONBAR2BUTTON5", "M" }
me.clicks = { { type = 3, actionID = 1, button = "LeftButton", modifiers = 0 }, { type = 2, actionID = 121, button = "LeftButton", modifiers = 1 } }
me.cvars.nameplateShowEnemies = "0"; me.cvars.graphicsQuality = "3"; me.cvars.enableMultiActionBars = "31"
accA.editmode.layouts.layouts[1].systems[1].x = 77
me.chat[3] = { "Guild", 18, 0, 0, 0, 0.6, true, true, 3, false, nil, nil, nil, nil, nil, { "GUILD" }, {} }
me.addons = { DBM = true, BetterBlizzFrames = true, BigData = true, Weird = true, BarSync = true, ["Z-Settings"] = true }
me.cdm = "my-warlock-cdm"
SVS = { DBM = "DBM_AllSavedOptions", BetterBlizzFrames = "BetterBlizzFramesDB", BigData = "BigDataDB", Weird = "WeirdDB",
        BarSync = "BarSyncDB", ["Z-Settings"] = "ZSettingsDB" }

-- the friend's own setup
accB.general = { { "Buddy macro", 9, "/wave" } }
accB.binds[1][2] = "W"
friend.clicks = { { type = 3, actionID = 2, button = "LeftButton", modifiers = 0 }, { type = 1, actionID = 133, button = "RightButton", modifiers = 1 } }
friend.cvars.nameplateShowEnemies = "1"
friend.addons = { DBM = true, BetterBlizzFrames = nil, BigData = false, Weird = false, BarSync = false, ["Z-Settings"] = true, Details = true }
friend.addons.BetterBlizzFrames = nil  -- not installed
friend.cdm = "friend-mage-cdm"

local function useChar(c, globals)
  cur = c
  for k, v in pairs(globals) do _G[k] = v end
  loadChatFrames()
  frames = {}
  ZSettingsDB = c.ZSettingsDB
  assert(loadstring(ADDON))()
end

-- 1. export on my character
useChar(me, { DBM_AllSavedOptions = { warnings = true, bars = { size = 2 } }, BetterBlizzFramesDB = { castbar = 1 },
  BigDataDB = { blob = string.rep("x", 400000) }, WeirdDB = { f = function() end }, BarSyncDB = { secret = 1 } })
printed = {}
SlashCmdList.ZSETTINGS("export")
for _, o in ipairs(frames) do if o.scripts.OnKeyDown then o.scripts.OnKeyDown(o, "Q") end end
local box
for _, o in ipairs(frames) do if o.kind == "EditBox" then box = o end end
local text = box and box.text or ""
check("1 export string made", text:sub(1, 4) == "ZS1:")
local layoutSaid = false
for _, p in ipairs(printed) do if p:find("QWERTY") then layoutSaid = true end end
check("1 my keyboard detected as QWERTY", layoutSaid)
local data = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(text:sub(5))))
check("1 keyboard stored in the string", data.layout == "qwerty")
check("1 class-free macros shared", data.macros.Focus ~= nil and data.macros.Mana ~= nil)
check("1 spell-casting macros left out", data.macros.Healthstone == nil and data.macros["Warlock nuke"] == nil)
check("1 character macros left out", data.macros["Tap safe"] == nil)
check("1 action bars left out", data.bars == nil)
check("1 cooldown manager left out", data.cdm == nil)
check("1 only target/menu clicks shared", #data.clicks == 1 and data.clicks[1].type == 3)
check("1 graphics not shared", data.cvars.graphicsQuality == nil)
check("1 DBM settings shared", data.settings.DBM_AllSavedOptions ~= nil)
check("1 BarSync never shared", data.settings.BarSyncDB == nil)
check("1 oversized table left out", data.settings.BigDataDB == nil)
check("1 unshareable table left out", data.settings.WeirdDB == nil)
local told = false
for _, p in ipairs(printed) do if p:find("BigData") and p:find("Weird") then told = true end end
check("1 left-out tables listed", told)

-- 2. the friend imports
BetterBlizzFramesDB, BigDataDB, WeirdDB, BarSyncDB = nil, nil, nil, nil   -- the friend's PC has none of these
useChar(friend, { DBM_AllSavedOptions = { warnings = false } })
friend.ZSettingsDB = nil
printed = {}
SlashCmdList.ZSETTINGS("import")
local win, importButton
for _, o in ipairs(frames) do
  if o.kind == "EditBox" then win = o end
  if o.kind == "Button" and o.scripts.OnClick then importButton = o end
end
win.text = text
importButton.scripts.OnClick()
for _, o in ipairs(frames) do if o.scripts.OnKeyDown then o.hint = o.hint or CreateFrame("FontString"); o.scripts.OnKeyDown(o, "A"); o.scripts.OnKeyDown(o, "§") end end
friend.ZSettingsDB = ZSettingsDB
check("2 settings applied", friend.cvars.nameplateShowEnemies == "0" and friend.cvars.enableMultiActionBars == "31")
check("2 graphics untouched", friend.cvars.graphicsQuality == "9")
check("2 keybinds applied", keyOf(accB, "MOVEFORWARD") == "UP")
check("2 Q becomes A on AZERTY", keyOf(accB, "MULTIACTIONBAR2BUTTON1") == "A")
check("2 Shift+1 becomes Shift+& on AZERTY", keyOf(accB, "MULTIACTIONBAR2BUTTON2") == "SHIFT-&")
check("2 Alt+Z becomes Alt+W on AZERTY", keyOf(accB, "MULTIACTIONBAR2BUTTON3") == "ALT-W")
check("2 Shift+minus becomes Shift+) on Belgian AZERTY", keyOf(accB, "MULTIACTIONBAR2BUTTON4") == "SHIFT-)")
check("2 M becomes , on AZERTY", keyOf(accB, "MULTIACTIONBAR2BUTTON5") == ",")
check("2 arrow key untouched", keyOf(accB, "MOVEFORWARD") == "UP")
check("2 E stays E", keyOf(accB, "ACTIONBUTTON1") == "E")
check("2 1 becomes & on AZERTY", keyOf(accB, "ACTIONBUTTON2") == "&")
check("2 edit mode applied", accB.editmode.layouts.layouts[1].systems[1].x == 77)
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
check("2 BarSync not switched on", friend.addons.BarSync == false)
check("2 undo saved", friend.ZSettingsDB and friend.ZSettingsDB.undo ~= nil)
local skipNote = false
for _, p in ipairs(printed) do if p:find("BetterBlizzFrames") then skipNote = true end end
check("2 missing addon reported", skipNote)
-- an addon that rewrites its table at logout doesn't undo the import
DBM_AllSavedOptions = { warnings = false }
for _, o in ipairs(frames) do if o.events.PLAYER_LOGOUT then o.scripts.OnEvent() end end
check("2 import survives the save at logout", DBM_AllSavedOptions.warnings == true)

-- 3. damaged strings and combat are refused
useChar(friend, {})
ZSettingsDB = friend.ZSettingsDB
SlashCmdList.ZSETTINGS("import")
for _, o in ipairs(frames) do
  if o.kind == "EditBox" then win = o end
  if o.kind == "Button" and o.scripts.OnClick then importButton = o end
end
printed = {}
win.text = "ZS1:garbage"
importButton.scripts.OnClick()
local refused = false
for _, p in ipairs(printed) do if p:find("damaged") then refused = true end end
check("3 damaged string refused", refused)
combat = true; printed = {}
win.text = text; importButton.scripts.OnClick(); combat = false
local prompted = false
for _, o in ipairs(frames) do if o.scripts.OnKeyDown then prompted = true end end
check("3 no key prompt in combat", not prompted)
local blocked = false
for _, p in ipairs(printed) do if p:find("not in combat") then blocked = true end end
check("3 no import in combat", blocked)

-- 4. undo puts the friend's setup back exactly
useChar(friend, {})
ZSettingsDB = friend.ZSettingsDB
SlashCmdList.ZSETTINGS("undo")
check("4 setting back", friend.cvars.nameplateShowEnemies == "1")
check("4 keybind back", keyOf(accB, "MOVEFORWARD") == "W")
check("4 imported macros removed", GetMacroIndexByName("Focus") == 0 and GetMacroIndexByName("Mana") == 0)
check("4 own macro still there", GetMacroIndexByName("Buddy macro") > 0)
check("4 target click back", (function() for _, b in ipairs(friend.clicks) do if b.type == 3 and b.actionID == 2 then return true end end end)() == true)
check("4 DBM settings back", DBM_AllSavedOptions.warnings == false)
check("4 undo used up", ZSettingsDB.undo == nil)
printed = {}
SlashCmdList.ZSETTINGS("undo")
local nothing = false
for _, p in ipairs(printed) do if p:find("nothing to undo") then nothing = true end end
check("4 second undo does nothing", nothing)

-- 5. the bundled setup: a friend updates the addon and types /z import, nothing to paste
local friend2 = newChar("Mate", "Classic Beta PvP", newAccount(), { "Fireball" })
friend2.cvars.nameplateShowEnemies = "1"
Z_BUNDLE = text
useChar(friend2, {})
ZSettingsDB = nil
printed = {}
SlashCmdList.ZSETTINGS("")
local offered = false
for _, p in ipairs(printed) do if p:find("Zeroshin's") then offered = true end end
check("5 /z names the bundled setup", offered)
SlashCmdList.ZSETTINGS("import")
local prompt
for _, o in ipairs(frames) do if o.scripts.OnKeyDown then prompt = o end end
check("5 bundled import asks for the keyboard", prompt ~= nil)
prompt.scripts.OnKeyDown(prompt, "A"); prompt.scripts.OnKeyDown(prompt, "§")
check("5 bundled setup applied", friend2.cvars.nameplateShowEnemies == "0")
check("5 bundled keybinds converted", keyOf(friend2.account, "MULTIACTIONBAR2BUTTON1") == "A")
check("5 bundled import saved an undo", ZSettingsDB and ZSettingsDB.undo ~= nil)
-- 6. a damaged bundle falls back to the paste window instead of applying anything
Z_BUNDLE = "ZS1:broken"
useChar(friend2, {})
SlashCmdList.ZSETTINGS("import")
local pasteShown = false
for _, o in ipairs(frames) do if o.kind == "Button" and o.scripts.OnClick then pasteShown = true end end
check("6 damaged bundle opens the paste window", pasteShown)
Z_BUNDLE = nil
-- 7. export keeps the string for publish.py
useChar(me, {})
ZSettingsDB = {}
SlashCmdList.ZSETTINGS("export")
for _, o in ipairs(frames) do if o.scripts.OnKeyDown then o.scripts.OnKeyDown(o, "Q") end end
check("7 export saved for publishing", type(ZSettingsDB.export) == "string" and ZSettingsDB.export:sub(1, 4) == "ZS1:" and ZSettingsDB.exportMade ~= nil)

io.write(("%d passed, %d failed\n"):format(passed, failed))
