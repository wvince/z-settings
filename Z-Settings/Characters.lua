-- Character copy: /z save keeps this character's whole setup, /z copy puts a saved one on the character
-- you're on. Everything goes: action bars, macros, keybinds, click casting, settings, Edit Mode, Cooldown
-- Manager, chat windows, addons on or off and every addon's settings. Any class: a spell this character
-- doesn't know is listed and its button stays empty. /z undo puts back what the copy replaced.
-- Saves live in ZSettingsDB; ./characters gathers every account's saves into ZCharacters.lua so /z copy
-- lists them on the other accounts too. What Blizzard stores per game account (General macros, account
-- keybinds, settings and layouts) is always copied from the save. Addon tables are files per WTF account
-- folder: where the copy shares that folder's ZSettingsDB (the same account, or account folders linked
-- together) they are already shared, so a save's older copy is never applied there and only the source's
-- AceDB profile choice and character data move to this character.

local _, ns = ...
local FORMAT = "ZC1:"
local SLOTS = 180
local say, note = ns.say, ns.note

local function deepcopy(v)
  if type(v) ~= "table" then return v end
  local c = {}
  for k, x in pairs(v) do c[deepcopy(k)] = deepcopy(x) end
  return c
end

local function count(t)
  local n = 0
  for _ in pairs(t or {}) do n = n + 1 end
  return n
end

local function sortedKeys(t)
  local out = {}
  for k in pairs(t or {}) do out[#out + 1] = k end
  table.sort(out)
  return out
end

-- a game account has no id the client shows, so each ZSettingsDB makes its own
local function accountId()
  ZSettingsDB = ZSettingsDB or {}
  ZSettingsDB.accountId = ZSettingsDB.accountId or (tostring(time()) .. "-" .. tostring(math.random(1, 1000000000)))
  return ZSettingsDB.accountId
end

-- the character key AceDB files profiles and character data under
local function aceKey() return (UnitName("player") or "?") .. " - " .. (GetRealmName() or "?") end

-- action bars: buttons are stored by what they hold (spell name, macro name, item id), not by id ----------

local function readBars()
  local bars = {}
  for slot = 1, SLOTS do
    local kind, id = GetActionInfo(slot)
    local v
    if kind == "macro" then
      local name = GetActionText(slot)
      v = name and ("macro:" .. name)
    elseif kind == "spell" then
      local name = C_Spell.GetSpellName(id)
      v = name and ("spell:" .. name)
    elseif kind then
      v = kind .. ":" .. tostring(id)
    end
    if v then bars[tostring(slot)] = v end
  end
  return bars
end

local function pickup(v)
  ClearCursor()
  local kind, ref = v:match("^(%a+):(.*)$")
  if kind == "macro" then
    if GetMacroIndexByName(ref) > 0 then PickupMacro(ref) end
  elseif kind == "spell" then
    if C_Spell.GetSpellInfo(ref) then C_Spell.PickupSpell(ref) end
  elseif kind == "item" then
    C_Item.PickupItem(tonumber(ref) or ref)
  elseif kind == "equipmentset" then
    C_EquipmentSet.PickupEquipmentSet(tonumber(ref) or ref)
  end
  return GetCursorInfo() ~= nil
end

local function applyBars(wanted)
  local current, missing, seen = readBars(), {}, {}
  for slot = 1, SLOTS do
    local key = tostring(slot)
    local want, have = wanted[key], current[key]
    if want ~= have then
      if want and pickup(want) then
        PlaceAction(slot)
      else
        if want then   -- not on this character: the slot ends up empty, like the source's isn't
          local kind, ref = want:match("^(%a+):(.*)$")
          local name = (kind == "spell" or kind == "macro") and ref or (kind .. " " .. ref)
          if not seen[name] then seen[name] = true; missing[#missing + 1] = name end
        end
        ClearCursor(); PickupAction(slot)
      end
      ClearCursor()
    end
  end
  return missing
end

-- macros: scope "c" is this character's, "g" the account's General ones ---------------------------------

local function macroRange(scope)
  local numGeneral, numChar = GetNumMacros()
  if scope == "c" then return ns.MAX_ACCOUNT_MACROS + 1, ns.MAX_ACCOUNT_MACROS + numChar end
  return 1, numGeneral
end

local function readMacros(scope)
  local out = {}
  local first, last = macroRange(scope)
  for i = first, last do
    local name, icon, body = GetMacroInfo(i)
    if name then out[name] = { icon, body } end
  end
  return out
end

-- a macro that stays is edited in place, so buttons on it (this character's or, for General ones,
-- another character's) keep it
local function applyMacros(wanted, scope)
  local perChar = scope == "c"
  local first, last = macroRange(scope)
  for i = last, first, -1 do
    local name = GetMacroInfo(i)
    if name and not wanted[name] then DeleteMacro(i) end
  end
  for name, m in pairs(wanted) do
    local i = ns.findMacro(name, perChar)
    if not i then CreateMacro(name, m[1], m[2], perChar)
    else
      local _, icon, body = GetMacroInfo(i)
      if tostring(icon) ~= tostring(m[1]) or body ~= m[2] then EditMacro(i, name, m[1], m[2]) end
    end
  end
end

-- click casting: every click, a macro click by macro name -----------------------------------------------

local function readClicks()
  local out = {}
  for _, b in ipairs(C_ClickBindings.GetProfileInfo()) do
    local c = { type = b.type, actionID = b.actionID, button = b.button, modifiers = b.modifiers }
    if b.type == Enum.ClickBindingType.Macro then c.macro = GetMacroInfo(b.actionID) end
    out[#out + 1] = c
  end
  return out
end

local function applyClicks(list)
  local profile = {}
  for _, b in ipairs(list) do
    local c = { type = b.type, actionID = b.actionID, button = b.button, modifiers = b.modifiers }
    if b.macro then c.actionID = GetMacroIndexByName(b.macro) end
    if not b.macro or c.actionID > 0 then profile[#profile + 1] = c end
  end
  C_ClickBindings.SetProfileByInfo(profile)
end

-- the rest of the UI ------------------------------------------------------------------------------------

local function readCDM()
  local ok, data = pcall(C_CooldownViewer.GetLayoutData)
  return ok and data or nil
end

-- every layout, the selected one and the account settings
local function applyEditMode(em)
  if type(em) ~= "table" or type(em.layouts) ~= "table" then return end
  local layouts = deepcopy(em.layouts)
  for _, s in ipairs(em.settings or {}) do pcall(C_EditMode.SetAccountSetting, s.setting, s.value) end
  pcall(C_EditMode.SaveLayouts, layouts)
  if layouts.activeLayout then pcall(C_EditMode.SetActiveLayout, layouts.activeLayout) end
end

local function readState()
  return { bars = readBars(), charMacros = readMacros("c"), generalMacros = readMacros("g"),
    binds = ns.readBinds(), bindSet = GetCurrentBindingSet(), clicks = readClicks(), cvars = ns.readCVars(),
    editmode = ns.readEditMode(false), cdm = readCDM(), chat = ns.readChat(), addons = ns.readAddons() }
end

-- a part the state lacks stays as it is
local function applyState(s)
  applyMacros(s.charMacros or {}, "c")   -- first: buttons and clicks find macros by name
  if s.generalMacros then applyMacros(s.generalMacros, "g") end
  local missing = applyBars(s.bars or {})
  if s.binds then ns.applyBinds(s.binds, s.bindSet) end   -- saved into the same kind of set, account or character
  applyClicks(s.clicks or {})
  ns.applyCVars(s.cvars or {})
  applyEditMode(s.editmode)
  if s.cdm ~= nil then pcall(C_CooldownViewer.SetLayoutData, s.cdm) end
  if s.chat then ns.applyChat(s.chat) end
  if s.addons then ns.applyAddons(s.addons, ns.playerKey()) end
  return missing
end

-- addon settings ----------------------------------------------------------------------------------------

-- var -> addon for the tables named in Z_VARS or Z_CHARVARS (written by the commit hook from the tocs)
local function tableNames(list)
  local out = {}
  if type(list) ~= "table" then return out end
  for i = 1, C_AddOns.GetNumAddOns() do
    local addon = C_AddOns.GetAddOnInfo(i)
    if addon and not ns.KEEP_ADDONS[addon] then
      for _, var in ipairs(list[addon] or {}) do
        if not ns.DATA_TABLES[var] then out[var] = addon end
      end
    end
  end
  return out
end

local function loadedAddons()
  local out = {}
  for i = 1, C_AddOns.GetNumAddOns() do
    local name = C_AddOns.GetAddOnInfo(i)
    if name and C_AddOns.IsAddOnLoaded(name) then out[name] = true end
  end
  return out
end

-- running addons only: an addon that isn't running has no table to read
local function readTables(list, skipped)
  local out, loaded = {}, loadedAddons()
  for var, addon in pairs(tableNames(list)) do
    if loaded[addon] then
      local value = _G[var]
      if value == nil then out[var] = { addon = addon, clear = true }
      else
        local ok, packed = pcall(C_EncodingUtil.SerializeCBOR, value)
        if ok and packed and #packed <= ns.MAX_ADDON_TABLE then out[var] = { addon = addon, data = packed }
        else skipped[#skipped + 1] = addon .. " (" .. var .. ")" end
      end
    end
  end
  return out
end

local function unpackTable(e)
  local ok, value = pcall(C_EncodingUtil.DeserializeCBOR, e.data)
  if ok then return value end
end

local function isAce(t) return type(t) == "table" and (type(t.profileKeys) == "table" or type(t.namespaces) == "table") end

-- AceDB keeps every character's profile choice and data in one account table: the save's copy brings
-- its own entries, the other characters on this account keep theirs
local ACE_SECTIONS = { "profileKeys", "char", "realm", "class", "race", "faction", "factionrealm", "profiles" }
local function mergeAce(live, saved)
  if type(live) ~= "table" or type(saved) ~= "table" then return saved end
  for _, section in ipairs(ACE_SECTIONS) do
    if type(live[section]) == "table" then
      if type(saved[section]) ~= "table" then saved[section] = {} end
      for k, v in pairs(live[section]) do if saved[section][k] == nil then saved[section][k] = v end end
    end
  end
  if type(live.namespaces) == "table" and type(saved.namespaces) == "table" then
    for name, t in pairs(saved.namespaces) do saved.namespaces[name] = mergeAce(live.namespaces[name], t) end
  end
  return saved
end

-- This character takes the source's profile choice and character data. A profile named after the source
-- (AceDB's default) is copied to one named after this character, so the two don't share one from now on.
local function remapAce(t, src, dst)
  if type(t) ~= "table" then return end
  local keys = t.profileKeys
  if type(keys) == "table" and keys[src] ~= nil then
    if keys[src] == src and type(t.profiles) == "table" and t.profiles[src] ~= nil then
      t.profiles[dst], keys[dst] = deepcopy(t.profiles[src]), dst
    else
      keys[dst] = keys[src]
    end
  end
  if type(t.char) == "table" and t.char[src] ~= nil then t.char[dst] = deepcopy(t.char[src]) end
  for _, n in pairs(type(t.namespaces) == "table" and t.namespaces or {}) do remapAce(n, src, dst) end
end

-- The addon tables a copy writes here (var -> value or CLEAR) and the addons it waits for because they
-- aren't running. only: limit to these addons.
local function tableChanges(data, same, only)
  local changes, waiting, loaded = {}, {}, loadedAddons()
  local function wanted(addon) return not ns.KEEP_ADDONS[addon] and (not only or only[addon]) end
  for var, e in pairs(data.charTables or {}) do
    if wanted(e.addon) then
      if not loaded[e.addon] then waiting[e.addon] = true
      elseif e.clear then changes[var] = ns.CLEAR
      else changes[var] = unpackTable(e) end
    end
  end
  if same then
    for var, addon in pairs(tableNames(Z_VARS)) do
      if wanted(addon) and loaded[addon] and isAce(_G[var]) then
        local t = deepcopy(_G[var])
        remapAce(t, data.aceKey, aceKey())
        if ns.hash(t) ~= ns.hash(_G[var]) then changes[var] = t end
      end
    end
  else
    for var, e in pairs(data.accountTables or {}) do
      if wanted(e.addon) and not e.clear then   -- an account table the source lacks: this account's stays
        if not loaded[e.addon] then waiting[e.addon] = true
        else
          local value = unpackTable(e)
          if isAce(value) then
            value = mergeAce(deepcopy(_G[var]), value)
            remapAce(value, data.aceKey, aceKey())
          end
          changes[var] = value
        end
      end
    end
  end
  return changes, waiting
end

-- what those tables hold now, for /z undo
local function packTables(changes)
  local out = {}
  for var in pairs(changes) do
    local value = _G[var]
    if value == nil then out[var] = { clear = true }
    else
      local ok, packed = pcall(C_EncodingUtil.SerializeCBOR, value)
      if ok then out[var] = { data = packed } end
    end
  end
  return out
end

-- assigned again at logout, so an addon writing its old table then can't undo the copy
local function applyTables(changes)
  for var, value in pairs(changes) do ns.pending[var] = value end
  ns.assignPending()
end

-- saves ---------------------------------------------------------------------------------------------------

-- this account's saves, then the ones ./characters gathered from the others; never this character
local function saves()
  local out = {}
  for key, text in pairs(type(Z_CHARACTERS) == "table" and Z_CHARACTERS or {}) do out[key] = text end
  for key, text in pairs(ZSettingsDB and ZSettingsDB.characters or {}) do out[key] = text end
  out[ns.charKey()] = nil
  return out
end

function ns.saveCharacter()
  if InCombatLockdown() then say("not in combat") return end
  local data = readState()
  if not next(data.bars) then say("the action bars haven't loaded yet: try again in a moment") return end
  local skipped = {}
  data.format, data.kind, data.key, data.made = 1, "character", ns.charKey(), date("%Y-%m-%d %H:%M")
  data.className, data.accountId, data.aceKey = (UnitClass("player")), accountId(), aceKey()
  data.charTables, data.accountTables = readTables(Z_CHARVARS, skipped), readTables(Z_VARS, skipped)
  data.applied = ZSettingsDB.applied and ZSettingsDB.applied[data.key]   -- what the setup popup compares against
  ZSettingsDB.characters = ZSettingsDB.characters or {}
  ZSettingsDB.characters[data.key] = ns.encode(data, FORMAT)
  say(("saved %s: %d buttons, %d macros, %d addon tables"):format(data.key, count(data.bars),
    count(data.charMacros) + count(data.generalMacros), count(data.charTables) + count(data.accountTables)))
  if #skipped > 0 then
    table.sort(skipped)
    say("not included (too large or not storable): " .. table.concat(skipped, ", "))
  end
  say("log out, then /z copy on the character to copy it to")
end

local function copyFrom(key, text)
  if InCombatLockdown() then say("not in combat") return end
  local data = ns.decode(text, FORMAT)
  if not data or data.kind ~= "character" then say(("the save of %s is damaged: /z save there again"):format(key)) return end
  local same = data.accountId == accountId()
  local changes, waiting = tableChanges(data, same)
  local before = readState()
  before.format, before.kind, before.tables = 1, "copy", packTables(changes)
  ZSettingsDB.applied = ZSettingsDB.applied or {}
  before.applied = ZSettingsDB.applied[ns.charKey()] or false
  if type(ZSettingsDB.undo) ~= "table" then ZSettingsDB.undo = {} end
  ZSettingsDB.undo[ns.charKey()] = ns.encode(before)
  local missing = applyState(data)
  applyTables(changes)
  -- this character now has the source's layout and chat, so the setup popup compares against the source's
  ZSettingsDB.applied[ns.charKey()] = deepcopy(data.applied)
  ZSettingsDB.copyWaiting = ZSettingsDB.copyWaiting or {}
  ZSettingsDB.copyWaiting[ns.charKey()] = next(waiting) and { from = key, addons = waiting } or nil
  note(("copied %s, saved %s, onto this character"):format(key, data.made or "?"))
  if #missing > 0 then note("not available on this character, left off the bars: " .. table.concat(missing, ", ")) end
  if next(waiting) then note("one more reload follows for the settings of: " .. table.concat(sortedKeys(waiting), ", ")) end
  note("/z undo puts this character back as it was")
  ReloadUI()
end

-- the picker --------------------------------------------------------------------------------------------

local picker
local BACKDROP = { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,
  insets = { left = 8, right = 8, top = 8, bottom = 8 } }

-- one row per saved character; a click selects it, Copy applies it
local function showPicker(list)
  local keys = sortedKeys(list)
  if not picker then
    picker = CreateFrame("Frame", "ZSettingsCopy", UIParent, "BackdropTemplate")
    picker:SetWidth(520)
    picker:SetPoint("CENTER")
    picker:SetFrameStrata("DIALOG")
    picker:SetBackdrop(BACKDROP)
    picker.title = picker:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    picker.title:SetPoint("TOP", 0, -24)
    picker.title:SetText("Copy a character")
    picker.note = picker:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    picker.note:SetPoint("TOP", picker.title, "BOTTOM", 0, -10)
    picker.note:SetWidth(460)
    picker.note:SetText("Replaces this character's whole setup. /z undo reverts it.")
    local close = CreateFrame("Button", nil, picker, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -6, -6)
    picker.copy = CreateFrame("Button", nil, picker, "UIPanelButtonTemplate")
    picker.copy:SetSize(140, 30)
    picker.copy:SetPoint("BOTTOMRIGHT", picker, "BOTTOM", -8, 22)
    picker.copy:SetText("Copy")
    picker.cancel = CreateFrame("Button", nil, picker, "UIPanelButtonTemplate")
    picker.cancel:SetSize(140, 30)
    picker.cancel:SetPoint("BOTTOMLEFT", picker, "BOTTOM", 8, 22)
    picker.cancel:SetText("Cancel")
    picker.cancel:SetScript("OnClick", function() picker:Hide() end)
    picker.rows = {}
  end
  local chosen
  picker.copy:SetEnabled(false)
  picker.copy:SetScript("OnClick", function()
    if not chosen then return end
    picker:Hide()
    copyFrom(chosen, list[chosen])
  end)
  for i, key in ipairs(keys) do
    local row = picker.rows[i] or CreateFrame("Button", nil, picker, "UIPanelButtonTemplate")
    picker.rows[i] = row
    row:SetSize(460, 30)
    row:ClearAllPoints()
    row:SetPoint("TOP", 0, -72 - (i - 1) * 34)
    local d = ns.decode(list[key], FORMAT)
    row:SetText(d and ("%s, %s, saved %s"):format(key, d.className or "?", d.made or "?") or (key .. ", damaged: save it again"))
    row:UnlockHighlight()
    row:SetNormalFontObject("GameFontHighlight")
    row:SetScript("OnClick", function()
      for _, r in ipairs(picker.rows) do r:UnlockHighlight(); r:SetNormalFontObject("GameFontHighlight") end
      row:LockHighlight()
      row:SetNormalFontObject("GameFontNormal") -- the chosen row reads gold, the rest white
      chosen = key
      picker.copy:SetEnabled(d ~= nil)
    end)
    row:Show()
  end
  for i = #keys + 1, #picker.rows do picker.rows[i]:Hide() end
  picker:SetHeight(140 + #keys * 34)
  picker:Show()
end

-- name: "Name-Realm", or the name alone while only one saved character has it
function ns.copyCharacter(name)
  if InCombatLockdown() then say("not in combat") return end
  local list = saves()
  if not next(list) then say("no saved characters yet: /z save on the character to copy from") return end
  if name == "" then showPicker(list) return end
  local wanted, found = name:lower(), {}
  for key in pairs(list) do
    local k = key:lower()
    if k == wanted then found = { key } break end
    if k:sub(1, #wanted + 1) == wanted .. "-" then found[#found + 1] = key end
  end
  if #found == 1 then copyFrom(found[1], list[found[1]])
  elseif #found > 1 then say("more than one saved " .. name .. ": " .. table.concat(sortedKeys(found), ", "))
  else say("no saved character " .. name .. ". Saved: " .. table.concat(sortedKeys(list), ", ")) end
end

-- /z undo after a copy
function ns.restoreCopy(u)
  applyState(u)
  if u.applied ~= nil then
    ZSettingsDB.applied = ZSettingsDB.applied or {}
    ZSettingsDB.applied[ns.charKey()] = u.applied or nil
  end
  local changes = {}
  for var, e in pairs(u.tables or {}) do
    if e.clear then changes[var] = ns.CLEAR else changes[var] = unpackTable(e) end
  end
  applyTables(changes)
  if ZSettingsDB.copyWaiting then ZSettingsDB.copyWaiting[ns.charKey()] = nil end
end

-- After the copy's reload: the addons it switched on are running now, so their tables follow, the undo
-- gains their state from before, and one more reload shows them. Runs once, whatever is still missing.
-- Returns true when it reloads.
function ns.afterLogin()
  local key = ns.charKey()
  local w = ZSettingsDB and type(ZSettingsDB.copyWaiting) == "table" and ZSettingsDB.copyWaiting[key]
  if not w then return end
  ZSettingsDB.copyWaiting[key] = nil
  local text = saves()[w.from]
  local data = text and ns.decode(text, FORMAT)
  if not data or InCombatLockdown() then return end
  local changes, still = tableChanges(data, data.accountId == accountId(), w.addons)
  if next(still) then say("not running, so their settings weren't copied: " .. table.concat(sortedKeys(still), ", ")) end
  if not next(changes) then return end
  local u = type(ZSettingsDB.undo) == "table" and ns.decode(ZSettingsDB.undo[key])
  if u and u.kind == "copy" then
    u.tables = u.tables or {}
    for var, e in pairs(packTables(changes)) do if u.tables[var] == nil then u.tables[var] = e end end
    ZSettingsDB.undo[key] = ns.encode(u)
  end
  applyTables(changes)
  note(("copied the settings of %d more addon tables"):format(count(changes)))
  ReloadUI()
  return true
end
