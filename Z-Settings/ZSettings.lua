-- Z-Settings: share your whole interface with friends.
-- /z export saves your setup for the git commit hook. A friend logging in with a newer setup (ZBundle.lua,
-- written by that hook) gets a popup listing the parts that differ from their UI; /z update opens it,
-- /z import applies everything, /z undo puts back what the last apply or copy changed. Each reloads the UI.
-- Shared: interface settings, keybinds (converted between QWERTY and AZERTY), Edit Mode, chat windows,
-- enabled addons, every addon's account-wide settings, target/menu click casting and General macros that
-- cast no spell. Left out: action bars, Cooldown Manager, character macros and spell macros (class-specific),
-- per-character addon data. On command only. Never in combat.
-- Copying one of your own characters onto another (/z save, /z copy) lives in Characters.lua.

local _, ns = ...

local FORMAT = "ZS1:"
local MAX_ACCOUNT_MACROS = (Constants and Constants.MacroConsts and Constants.MacroConsts.MAX_ACCOUNT_MACROS) or 120
-- addon tables that hold your data or state, not settings: copying them would replace the friend's own.
-- Baganator's settings too: how bags look is each player's own, so theirs stay as they are.
local DATA_TABLES = { Attune_DB = true, RXPData = true, AUCTIONATOR_POSTING_HISTORY = true,
  BAGANATOR_CONFIG = true, BAGANATOR_DATA = true,
  -- your characters' bags, Details' backup of your windows, your item hunts and recipes, character lists
  SYNDICATOR_DATA = true, SYNDICATOR_SUMMARIES = true, __details_backup = true, __details_debug = true,
  GearQuestForeverDB = true, SkillUpForeverDB = true, Details_StreamerDB = true, DrpulseProfilesDB = true,
  QuestieTraceDumps = true,
  AUCTIONATOR_SHOPPING_LISTS = true, AUCTIONATOR_SELLING_GROUPS = true, AUCTIONATOR_RECENT_SEARCHES = true,
  AUCTIONATOR_VENDOR_PRICE_CACHE = true, AUCTIONATOR_PRICE_DATABASE = true, AUCTIONATOR_SAVEDVARS = true,
  DBM_ModsToLoadWithFullTestSupport = true, DBM_TestResults_Export = true, DBM_Test_DefaultTimeWarp = true,
  DBM_Test_PersistentImports = true, DBM_Test_Settings = true }
-- Tables with per-character profiles (AceDB's profileKeys) can't be shared either: the friend's
-- characters aren't in them, so they'd start on defaults and lose their own profiles.
-- Details keeps every character's profile in _detalhes_global and picks one per character: like the
-- AceDB tables it travels as one profile (see addon profiles), never whole. Replacing it under a running
-- Details also broke its logout save, which then wrote its live windows out (1.9 GB).
local PROFILE_TABLES = { _detalhes_global = true }
-- Settings that are yours alone: never shared with a friend, still copied between your own characters.
-- Clique's click casting holds spells, so it belongs to a class. BetterBlizzPlates' backup holds the
-- nameplate settings from before it changed them, which it puts back when it is switched off.
local OWN_TABLES = { CliqueDB = true, CliqueDB3 = true, BBPCVarBackupsDB = true }
-- DataStore (Altoholic's database) is every character's bags, mail and auctions; only its options are settings
local function shareable(var, value)
  if var:match("^DataStore") and not var:match("_Options$") then return false end
  return not DATA_TABLES[var] and not PROFILE_TABLES[var] and not OWN_TABLES[var]
    and not (type(value) == "table" and value.profileKeys ~= nil)
end

-- keys inside a shared table that are state, not settings: never exported, and the friend's own stay.
-- ForeverLootSparkles keeps the interface settings it changed, to put them back later.
local STATE_KEYS = { ForeverLootSparklesDB = { savedCVars = true } }
local function withoutState(var, value, theirs)
  local keys = STATE_KEYS[var]
  if not keys or type(value) ~= "table" then return value end
  local out = {}
  for k, v in pairs(value) do if not keys[k] then out[k] = v end end
  for k in pairs(keys) do if type(theirs) == "table" then out[k] = theirs[k] end end
  return out
end
-- macros an addon owns and rewrites as you play (RareScanner's last rare, RXPGuides' guide target): addon
-- state, not setup. Never shared, applied or compared, so the addon rewriting them can't bring the popup back.
-- RXPGuides makes several (RXPTargeting, RXPFollow) and may add more, so its prefix decides.
local function addonMacro(name) return name == "RS_MACRO" or name:find("^RXP") ~= nil end
local MAX_ADDON_TABLE = 300000   -- bytes of one addon's settings before compression; larger ones are listed, not shared
-- never shared or switched: this addon and SpyGodMode (the exporter's own, kept out of the repo)
local KEEP_ADDONS = { ["Z-Settings"] = true, SpyGodMode = true }

-- Settings: every one Blizzard stores server-side per account or character (the interface
-- options), except these categories and the per-character state below
local CVAR_EXCLUDED_CATEGORIES = { [0] = true, [1] = true, [6] = true, [7] = true, [8] = true, [9] = true } -- Debug, Graphics, Net, Sound, Gm, Reveal
-- Always copied, whatever category or storage the game gives them: which action bars are on, and
-- every nameplate setting (size, scale, distance and stacking are stored locally, not server-side)
local CVAR_ALWAYS = { enableMultiActionBars = true }
local CVAR_ALWAYS_PATTERNS = { "^[Nn]ame[Pp]late" }
local function alwaysCopied(name)
  if CVAR_ALWAYS[name] then return true end
  for _, pattern in ipairs(CVAR_ALWAYS_PATTERNS) do if name:find(pattern) then return true end end
  return false
end
local CVAR_SKIP = { "^CACHE", "^last", "Tutorial", "closedInfoFrames", "hardTracked", "trackedQuest",
  "^cameraSaved", "perksActivities", "petJournal", "^lfgSelected", "^agentUILocale", "^textLocale",
  "^audioLocale", "^portal", "^realm", "^account", "gameTip", "^engineSurvey", "^videoOptions",
  "^hwDetect", "^graphics", "^raidGraphics", "^RAID", "^gx", "^Gx", "^Sound_", "^sound",
  "ollapsed", "^num", "RenownMap$", "LastPointsMap$", "LastUpdate", "^minimapTracked", "InfoShown$", "AlreadyShown$",
  "ExampleShown$", "^notifiedOf", "^seen", "^talentPointsSpent", "^maxLevelSpecsUsed",
  "^GamepadCameraSaved" }

local function say(...) print("|cff8788eeZ-Settings|r:", ...) end

-- Runs one part of an export, apply or copy. A part that throws (an addon half loaded, full macro
-- slots) is listed in failed as "label (error)" and gives nil, so the parts after it still run.
local function try(failed, label, fn, ...)
  local result = { pcall(fn, ...) }
  if result[1] then return unpack(result, 2) end
  failed[#failed + 1] = ("%s (%s)"):format(label, (tostring(result[2]):gsub("^.-:%d+: ", "")))
end
-- a reload clears the chat, so these lines are kept and printed again once the UI is back
local function note(line)
  say(line)
  ZSettingsDB = ZSettingsDB or {}
  ZSettingsDB.notice = ZSettingsDB.notice or {}
  table.insert(ZSettingsDB.notice, line)
end

local cvarNames
local function readBinds()
  local binds = {}
  for i = 1, GetNumBindings() do
    local command, _, key1, key2 = GetBinding(i)
    if key1 then binds[key1] = command end
    if key2 then binds[key2] = command end
  end
  return binds
end

local function syncableCVars()
  if cvarNames then return cvarNames end
  cvarNames = {}
  for _, c in ipairs(ConsoleGetAllCommands()) do
    if c.commandType == 0 and (alwaysCopied(c.command) or not CVAR_EXCLUDED_CATEGORIES[c.category]) then
      local skip = false
      for _, pattern in ipairs(CVAR_SKIP) do if c.command:find(pattern) then skip = true; break end end
      if not skip then
        local _, _, account, character, locked, secure, readOnly = C_CVar.GetCVarInfo(c.command)
        if (account or character or alwaysCopied(c.command)) and not locked and not secure and not readOnly then
          cvarNames[#cvarNames + 1] = c.command
        end
      end
    end
  end
  return cvarNames
end

local function readCVars()
  local out = {}
  for _, name in ipairs(syncableCVars()) do
    local v = C_CVar.GetCVar(name)
    if v then out[name] = v end
  end
  return out
end

local PRESETS = (Enum and Enum.EditModePresetLayoutsMeta and Enum.EditModePresetLayoutsMeta.NumValues) or 2

-- Undo keeps every layout. Sharing keeps only the active one, as the string Edit Mode's own
-- "Copy to clipboard" makes, so Blizzard checks and upgrades it on import like a pasted layout.
local function readEditMode(forSharing)
  local ok, layouts = pcall(C_EditMode.GetLayouts)
  local ok2, settings = pcall(C_EditMode.GetAccountSettings)
  if not ok or not ok2 or type(layouts) ~= "table" then return nil end
  if not forSharing then return { layouts = layouts, settings = settings } end
  local active = layouts.layouts and layouts.layouts[(layouts.activeLayout or 0) - PRESETS]
  if not active then return { preset = layouts.activeLayout, settings = settings } end
  local okS, text = pcall(C_EditMode.ConvertLayoutInfoToString, active)
  return { layout = okS and text or nil, settings = settings }
end

local function sharedLayout(em)
  if em.layout then
    local ok, info = pcall(C_EditMode.ConvertStringToLayoutInfo, em.layout)
    return ok and type(info) == "table" and info or nil
  end
  -- older bundles carried every layout as a table
  local mine = em.layouts
  local shared = mine and mine.layouts and mine.layouts[(mine.activeLayout or 0) - PRESETS]
  if not shared then return nil end
  local copy = {}
  for k, v in pairs(shared) do copy[k] = v end
  return copy
end

-- Import adds the shared layout as its own layout and selects it; the friend's layouts stay.
-- A second import overwrites it (an older import's "Zeroshin" is renamed). No free account slot
-- means a character slot; with every slot taken, Edit Mode is left alone.
local LAYOUT_NAME, OLD_LAYOUT_NAME = "Zeroshin UI", "Zeroshin"
local function applyEditMode(em)
  for _, s in ipairs(em.settings or {}) do pcall(C_EditMode.SetAccountSetting, s.setting, s.value) end
  if em.preset then pcall(C_EditMode.SetActiveLayout, em.preset) return true end
  local layout = sharedLayout(em)
  local ok, theirs = pcall(C_EditMode.GetLayouts)
  if not layout or not ok or type(theirs) ~= "table" or type(theirs.layouts) ~= "table" then
    note("Edit Mode: the shared layout couldn't be read, your layouts stay as they are")
    return false
  end
  local account = (Enum.EditModeLayoutType and Enum.EditModeLayoutType.Account) or 1
  local character = (Enum.EditModeLayoutType and Enum.EditModeLayoutType.Character) or 2
  local max = (Constants and Constants.EditModeConsts and Constants.EditModeConsts.EditModeMaxLayoutsPerType) or 5
  local at, old, accounts, chars, lastAccount = nil, nil, 0, 0, 0
  for i, l in ipairs(theirs.layouts) do
    if l.layoutName == LAYOUT_NAME then at = i elseif l.layoutName == OLD_LAYOUT_NAME then old = i end
    if l.layoutType == account then accounts, lastAccount = accounts + 1, i
    elseif l.layoutType == character then chars = chars + 1 end
  end
  at = at or old
  layout.layoutName = LAYOUT_NAME
  if at then
    layout.layoutType = theirs.layouts[at].layoutType
    theirs.layouts[at] = layout
    note(("Edit Mode: layout %s updated and selected"):format(LAYOUT_NAME))
  elseif accounts < max then
    layout.layoutType, at = account, lastAccount + 1   -- account layouts come before character ones
    table.insert(theirs.layouts, at, layout)
    note(("Edit Mode: layout %s added and selected"):format(LAYOUT_NAME))
  elseif chars < max then
    layout.layoutType, at = character, #theirs.layouts + 1
    theirs.layouts[at] = layout
    note(("Edit Mode: layout %s added for this character (every account slot is taken)"):format(LAYOUT_NAME))
  else
    note(("Edit Mode: every layout slot is taken, so %s wasn't added. Delete a layout in Edit Mode, then /z update"):format(LAYOUT_NAME))
    return false
  end
  theirs.activeLayout = at + PRESETS
  pcall(C_EditMode.SaveLayouts, theirs)
  pcall(C_EditMode.SetActiveLayout, theirs.activeLayout)
  return true
end

local function values(t)
  local out = {}
  for _, v in pairs(t or {}) do out[#out + 1] = v end
  table.sort(out)
  return out
end

-- The same calls Blizzard's own chat code saves with; the chat frames pick them up at /reload
local MAX_CHAT = (Constants and Constants.ChatFrameConstants and Constants.ChatFrameConstants.MaxChatWindows) or 10
local function readChat()
  local out = {}
  for i = 1, MAX_CHAT do
    local name, size, r, g, b, a, shown, locked, docked, uninteractable = GetChatWindowInfo(i)
    local point, x, y = GetChatWindowSavedPosition(i)
    local w, h = GetChatWindowSavedDimensions(i)
    local frame = _G["ChatFrame" .. i]
    out[i] = { name = name, size = size, r = r, g = g, b = b, a = a, shown = shown and true or false,
      locked = locked and true or false, docked = docked, uninteractable = uninteractable and true or false,
      point = point, x = x, y = y, w = w, h = h,
      messages = frame and values(frame.messageTypeList) or {}, channels = frame and values(frame.channelList) or {} }
  end
  return out
end

local function playerKey() return UnitGUID and UnitGUID("player") or UnitName("player") end

local function readAddons()
  local out, who = {}, playerKey()
  for i = 1, C_AddOns.GetNumAddOns() do
    local name = C_AddOns.GetAddOnInfo(i)
    if name then out[name] = C_AddOns.GetAddOnEnableState(name, who) > 0 end
  end
  return out
end

-- Same call Blizzard's own keybinding panel makes: the action's binding context goes along
local function context(command)
  return C_KeyBindings and C_KeyBindings.GetBindingContextForAction and C_KeyBindings.GetBindingContextForAction(command) or nil
end

-- set: the binding set to save into, account or character; the current one when nil
local function applyBinds(wanted, set)
  local current = readBinds()
  for key, command in pairs(current) do
    if wanted[key] ~= command then SetBinding(key, nil, context(command)) end
  end
  for key, command in pairs(wanted) do
    if current[key] ~= command then SetBinding(key, command, context(command)) end
  end
  SaveBindings(set or GetCurrentBindingSet())
end

local function applyCVars(wanted)
  local allowed = {}
  for _, name in ipairs(syncableCVars()) do allowed[name] = true end
  for name, value in pairs(wanted) do
    if allowed[name] and C_CVar.GetCVar(name) ~= value then pcall(C_CVar.SetCVar, name, value) end
  end
end

local function applyChat(chat)
  for i, c in pairs(chat) do
    local frame = _G["ChatFrame" .. i]
    if c.name then pcall(SetChatWindowName, i, c.name) end
    if c.size then pcall(SetChatWindowSize, i, c.size) end
    if c.r then pcall(SetChatWindowColor, i, c.r, c.g, c.b) end
    if c.a then pcall(SetChatWindowAlpha, i, c.a) end
    pcall(SetChatWindowShown, i, c.shown)
    pcall(SetChatWindowLocked, i, c.locked)
    pcall(SetChatWindowUninteractable, i, c.uninteractable)
    pcall(SetChatWindowDocked, i, c.docked)
    if c.point then pcall(SetChatWindowSavedPosition, i, c.point, c.x, c.y) end
    if c.w then pcall(SetChatWindowSavedDimensions, i, c.w, c.h) end
    local want = {}
    for _, m in ipairs(c.messages) do want[m] = true end
    for _, m in ipairs(frame and values(frame.messageTypeList) or {}) do
      if not want[m] then pcall(RemoveChatWindowMessages, i, m) end
    end
    for m in pairs(want) do pcall(AddChatWindowMessages, i, m) end
    local wantCh = {}
    for _, ch in ipairs(c.channels) do wantCh[ch] = true end
    for _, ch in ipairs(frame and values(frame.channelList) or {}) do
      if not wantCh[ch] then pcall(RemoveChatWindowChannel, i, ch) end
    end
    for ch in pairs(wantCh) do pcall(AddChatWindowChannel, i, ch) end
  end
end

-- Per character, like the AddOn list in game: undo then puts back exactly what was switched, and each
-- alt gets its own popup.
local function applyAddons(wanted, character)
  local changed, called = 0, false
  local have = readAddons()
  for name, on in pairs(wanted) do
    if not KEEP_ADDONS[name] and have[name] ~= nil then
      if on then C_AddOns.EnableAddOn(name, character) else C_AddOns.DisableAddOn(name, character) end
      called = true
      if have[name] ~= on then changed = changed + 1 end
    end
  end
  if called then C_AddOns.SaveAddOns() end
  return changed
end

local function findMacro(name, perChar)
  local numGeneral, numChar = GetNumMacros()
  local first, last = 1, numGeneral
  if perChar then first, last = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + numChar end
  for i = first, last do
    if GetMacroInfo(i) == name then return i end
  end
end

-- General macros that cast nothing: /cast (or /spell), /castsequence and /castrandom (or /userandom) make a macro
-- class-specific. /use stays allowed: a name can't tell an item from a spell (potions share recipe names).
local function isShareableMacro(body)
  for line in (body or ""):gmatch("[^\n]+") do
    local cmd = line:match("^%s*/(%a+)")
    cmd = cmd and cmd:lower()
    if cmd == "cast" or cmd == "spell" or cmd == "castsequence" or cmd == "castrandom" or cmd == "userandom" then return false end
  end
  return true
end

local function readGeneralMacros(shareOnly)
  local out = {}
  for i = 1, (GetNumMacros()) do
    local name, icon, body = GetMacroInfo(i)
    if name and (not shareOnly or (not addonMacro(name) and isShareableMacro(body))) then out[name] = { icon, body } end
  end
  return out
end

-- Import adds and updates. Only a macro an import created counts as brought (ZSettingsDB.owned); one
-- the friend already had under that name is updated but stays theirs. A brought macro the setup no
-- longer has is deleted. A macro the friend made themselves is never deleted.
local function applyGeneralMacros(wanted)
  ZSettingsDB = ZSettingsDB or {}
  local owned, changed = ZSettingsDB.owned or {}, 0
  ZSettingsDB.owned = owned   -- stored first: a macro made before a later one throws is still known as brought
  for name in pairs(owned) do
    if not wanted[name] and not addonMacro(name) then
      local i = findMacro(name, false)
      if i then DeleteMacro(i); changed = changed + 1 end
      owned[name] = nil
    end
  end
  for name, m in pairs(wanted) do
    local i = findMacro(name, false)
    if not i then
      CreateMacro(name, m[1], m[2], false); owned[name] = true; changed = changed + 1
    else
      local _, icon, body = GetMacroInfo(i)
      if tostring(icon) ~= tostring(m[1]) or body ~= m[2] then EditMacro(i, name, m[1], m[2]); changed = changed + 1 end
    end
  end
  ZSettingsDB.owned = owned
  return changed
end

local function readClicks(interactionOnly)
  local out = {}
  for _, b in ipairs(C_ClickBindings.GetProfileInfo()) do
    if not interactionOnly or b.type == Enum.ClickBindingType.Interaction then out[#out + 1] = b end
  end
  return out
end

-- replaces target/menu clicks and keeps the friend's own spell and macro clicks
local function applyClicks(wanted)
  local profile = {}
  for _, b in ipairs(C_ClickBindings.GetProfileInfo()) do
    if b.type ~= Enum.ClickBindingType.Interaction then profile[#profile + 1] = b end
  end
  for _, b in ipairs(wanted) do profile[#profile + 1] = b end
  C_ClickBindings.SetProfileByInfo(profile)
end

-- every installed addon's account-wide settings tables (SavedVariables, not the per-character ones).
-- The client won't return a toc's SavedVariables line, so the commit hook reads the tocs into Z_VARS.
local function addonTables()
  local out = {}
  for i = 1, C_AddOns.GetNumAddOns() do
    local addon = C_AddOns.GetAddOnInfo(i)
    if addon and not KEEP_ADDONS[addon] then
      for _, var in ipairs(type(Z_VARS) == "table" and Z_VARS[addon] or {}) do out[#out + 1] = { addon = addon, var = var } end
    end
  end
  return out
end

local function readAddonSettings()
  local out, skipped = {}, {}
  for _, t in ipairs(addonTables()) do
    local value = withoutState(t.var, _G[t.var])
    if value ~= nil and shareable(t.var, value) then
      local ok, packed = pcall(C_EncodingUtil.SerializeCBOR, value)
      if ok and packed and #packed <= MAX_ADDON_TABLE then out[t.var] = { addon = t.addon, data = packed }
      else skipped[#skipped + 1] = t.addon .. " (" .. t.var .. (ok and ", too large" or ", not shareable") .. ")" end
    end
  end
  return out, skipped
end

-- addon profiles --------------------------------------------------------------------------------
-- An AceDB table (Dominos, Questie) holds a profile per character, so it is never shared whole. The
-- exporter's active profile travels instead and lands as PROFILE_NAME, selected on the character that
-- applies it; their own profiles stay. The running AceDB object is asked for the character's key and
-- profile: Forever's regional names make the key "Name Surname" in current AceDB, "Name - Realm" in
-- older copies, so it can't be built from the name.
local PROFILE_NAME = LAYOUT_NAME
local function aceDB(var)
  local lib = LibStub and LibStub("AceDB-3.0", true)
  local sv = _G[var]
  if not lib or type(sv) ~= "table" then return end
  for db in pairs(lib.db_registry or {}) do
    if type(db) == "table" and not db.parent and rawequal(db.sv, sv) then return db end
  end
end

local function readProfile(sv, name)
  local p = { profile = sv.profiles and sv.profiles[name] or {}, namespaces = {} }
  for ns, n in pairs(type(sv.namespaces) == "table" and sv.namespaces or {}) do
    if type(n) == "table" and type(n.profiles) == "table" and n.profiles[name] ~= nil then p.namespaces[ns] = n.profiles[name] end
  end
  return p
end

local function writeProfile(sv, p)
  sv.profiles = sv.profiles or {}
  sv.profiles[PROFILE_NAME] = p.profile or {}
  for ns, prof in pairs(p.namespaces or {}) do
    sv.namespaces = sv.namespaces or {}
    sv.namespaces[ns] = sv.namespaces[ns] or {}
    sv.namespaces[ns].profiles = sv.namespaces[ns].profiles or {}
    sv.namespaces[ns].profiles[PROFILE_NAME] = prof
  end
end

local function removeProfile(sv)
  if type(sv.profiles) == "table" then sv.profiles[PROFILE_NAME] = nil end
  for _, n in pairs(type(sv.namespaces) == "table" and sv.namespaces or {}) do
    if type(n) == "table" and type(n.profiles) == "table" then n.profiles[PROFILE_NAME] = nil end
  end
end

local function details()
  local g = _G._detalhes_global
  if type(Details) == "table" and type(Details.GetCurrentProfileName) == "function" and type(Details.ApplyProfile) == "function"
    and type(g) == "table" and type(g.__profiles) == "table" then return Details, g.__profiles end
end

local function readProfiles()
  local out = {}
  local d, profiles = details()
  if d then
    local ok, packed = pcall(function()
      pcall(d.SaveProfile, d)   -- the windows as they are now, not as they were at login
      return C_EncodingUtil.SerializeCBOR(profiles[d:GetCurrentProfileName()] or {})
    end)
    if ok and packed and #packed <= MAX_ADDON_TABLE then out._detalhes_global = { addon = "Details", details = true, data = packed } end
  end
  for _, t in ipairs(addonTables()) do
    local db = not DATA_TABLES[t.var] and not OWN_TABLES[t.var] and aceDB(t.var)
    if db then
      local ok, packed = pcall(function() return C_EncodingUtil.SerializeCBOR(readProfile(db.sv, db:GetCurrentProfile())) end)
      if ok and packed and #packed <= MAX_ADDON_TABLE then out[t.var] = { addon = t.addon, data = packed } end
    end
  end
  return next(out) and out or nil   -- no profile addon running: no part to offer
end

-- an addon that isn't running has no AceDB object here: its profile waits for a later apply
local function applyProfiles(profiles)
  local done = 0
  for var, e in pairs(profiles) do
    -- an older setup may still carry a table that now stays home
    local db = not KEEP_ADDONS[e.addon] and not DATA_TABLES[var] and not OWN_TABLES[var] and not e.details and aceDB(var)
    local d, dprofiles
    if e.details then d, dprofiles = details() end
    local ok, p = pcall(C_EncodingUtil.DeserializeCBOR, e.data)
    if d and ok and type(p) == "table" then
      -- switching saves the live windows into the profile being left: not over the one arriving
      local leaving = d:GetCurrentProfileName()
      if leaving ~= PROFILE_NAME then pcall(d.SaveProfile, d) end
      dprofiles[PROFILE_NAME] = p
      if pcall(d.ApplyProfile, d, PROFILE_NAME, true) then done = done + 1 end
    elseif db and ok and type(p) == "table" then
      writeProfile(db.sv, p)
      db:SetProfile(PROFILE_NAME)
      done = done + 1
    end
  end
  return done
end

-- window positions ------------------------------------------------------------------------------
-- Windows the player dragged, which WoW remembers per character (layout-local.txt), travel by frame
-- name as { point, relativePoint, x, y } on the screen. A window anchored to another frame follows that
-- frame, so it stays out. One the friend's addons haven't created by the apply is skipped.
local function framePosition(f)
  local ok, point, rel, relPoint, x, y = pcall(f.GetPoint, f)
  if ok and point and (rel == nil or rel == UIParent) and f:GetNumPoints() == 1 then return { point, relPoint, x, y } end
end

local function readPositions()
  if type(EnumerateFrames) ~= "function" then return end
  local out, f = {}, EnumerateFrames()
  while f do
    local okName, name = pcall(f.GetName, f)
    local okPlaced, placed = pcall(f.IsUserPlaced, f)
    if okName and type(name) == "string" and okPlaced and placed then out[name] = framePosition(f) end
    f = EnumerateFrames(f)
  end
  return next(out) and out or nil
end

local function placeFrame(name, p, userPlaced)
  local f = _G[name]
  if type(f) ~= "table" or type(f.SetPoint) ~= "function" then return false end
  -- a protected frame (action bars) moved from here would be tainted; Dominos places its own bars
  if type(f.IsProtected) == "function" and f:IsProtected() then return false end
  return (pcall(function()
    f:ClearAllPoints()
    f:SetPoint(p[1], UIParent, p[2], p[3], p[4])
    if f:IsMovable() then f:SetUserPlaced(userPlaced ~= false) end
  end))
end

local function applyPositions(positions)
  local done = 0
  for name, p in pairs(positions) do if placeFrame(name, p) then done = done + 1 end end
  return done
end

-- imported addon tables stay assigned until the game saves them at /reload or logout; CLEAR puts
-- back a table that didn't exist before
local pending, CLEAR = {}, {}
local function assignPending()
  for var, value in pairs(pending) do
    if value == CLEAR then _G[var] = nil else _G[var] = value end
  end
end

-- The tables an import really applies here: loaded addons only (WoW saves no table for an addon that
-- isn't running), shareable tables only, never the personal addons. Missing lists the rest by addon.
local function settingsToApply(settings)
  local loaded, out, missing = {}, {}, {}
  for i = 1, C_AddOns.GetNumAddOns() do
    local name = C_AddOns.GetAddOnInfo(i)
    if name and C_AddOns.IsAddOnLoaded(name) then loaded[name] = true end
  end
  for var, e in pairs(settings) do
    if not KEEP_ADDONS[e.addon] then
      if loaded[e.addon] then
        local ok, value = pcall(C_EncodingUtil.DeserializeCBOR, e.data)
        if ok and shareable(var, value) then out[var] = { addon = e.addon, value = withoutState(var, value, _G[var]) } end
      else
        missing[e.addon] = true
      end
    end
  end
  return out, missing
end

-- applies the given tables (see settingsDiff); they stay assigned through the save at reload or logout
local function applyAddonSettings(tables)
  local done = 0
  for var, t in pairs(tables) do pending[var] = t.value; done = done + 1 end
  assignPending()
  return done
end

local window

-- keyboard layouts ------------------------------------------------------------------------------
-- Q/A and W/Z swap places between the layouts, so binds on them move to keep the same physical key
-- (WASD becomes ZQSD). M stays M: it is bound by name (the map), as Blizzard's AZERTY defaults do.
-- WoW maps every other key itself. Modifiers are kept, and a moved key wins over a bind already there.
local KEY_MOVES = {
  ["qwerty>azerty-be"] = { Q = "A", A = "Q", W = "Z", Z = "W" },
  ["azerty-be>qwerty"] = { A = "Q", Q = "A", Z = "W", W = "Z" },
}
local LAYOUT_NAMES = { qwerty = "QWERTY", ["azerty-be"] = "Belgian AZERTY" }

local function convertKey(key, moves)
  local mods, base = key:match("^(.-)(.)$")   -- "ALT-SHIFT-Q" is "ALT-SHIFT-" and "Q"
  if mods ~= "" and mods:sub(-1) ~= "-" then return key end   -- a named key like F5 or BUTTON3
  local to = moves[base]
  return to and mods .. to or key
end

local function convertBinds(binds, from, to)
  local moves = KEY_MOVES[from .. ">" .. to]
  if not moves then return binds end
  local out, moved = {}, {}
  for key, command in pairs(binds) do
    local new = convertKey(key, moves)
    if new ~= key then out[new], moved[new] = command, true
    elseif not moved[key] then out[key] = command end
  end
  return out
end

-- One key press: the key right of Tab types Q on QWERTY and A on Belgian AZERTY. Any other key keeps
-- waiting (Shift first, a stray key); Escape cancels and nothing changes.
local function askLayout(done)
  if InCombatLockdown() then say("not in combat") return end
  window:EnableKeyboard(true)
  window:SetPropagateKeyboardInput(false)
  window.hint:SetText("Press the key right of Tab (the one below 1 and 2), or Escape to cancel")
  window:SetScript("OnKeyDown", function(self, key)
    key = (key or ""):upper()
    local layout = (key == "Q" and "qwerty") or (key == "A" and "azerty-be") or nil
    if not layout and key ~= "ESCAPE" then
      self.hint:SetText("Not that one: the key right of Tab (Q or A on your keyboard), or Escape to cancel")
      return
    end
    self:SetScript("OnKeyDown", nil)
    self:EnableKeyboard(false)
    if not layout then
      self:Hide()
      say("cancelled, nothing changed")
      return
    end
    done(layout)
  end)
end

-- the whole shareable state -------------------------------------------------------------------

-- failed: the parts that threw, left out of the export
local function capture(forSharing)
  local failed = {}
  local settings, skipped = try(failed, "Addon settings", readAddonSettings)
  return {
    format = 1, made = date("%Y-%m-%d %H:%M"), by = UnitName("player"),
    cvars = try(failed, "Interface settings", readCVars), binds = try(failed, "Keybinds", readBinds),
    editmode = try(failed, "Edit Mode layout", readEditMode, forSharing), chat = try(failed, "Chat windows", readChat),
    addons = try(failed, "Addons on or off", readAddons), macros = try(failed, "General macros", readGeneralMacros, forSharing),
    clicks = try(failed, "Click casting", readClicks, forSharing), settings = settings,
    profiles = try(failed, "Addon profiles", readProfiles), positions = try(failed, "Window positions", readPositions),
  }, skipped or {}, failed
end

-- the setup in parts ----------------------------------------------------------------------------
-- Each part applies on its own. Account parts are stored once for every character, character parts
-- per character: that decides where the popup remembers what was applied.
-- live: compared with the friend's UI as it is now. applied: compared with what was last applied,
-- because addons, Blizzard's layout save and rounded chat positions change those on their own.
local PARTS = {
  { key = "cvars", label = "Interface and nameplate settings", compare = "live" },
  { key = "binds", label = "Keybinds", compare = "live" },
  { key = "editmode", label = "Edit Mode layout", compare = "applied", scope = "character" },
  { key = "chat", label = "Chat windows", compare = "applied", scope = "character" },
  { key = "addons", label = "Addons on or off", compare = "live" },
  { key = "settings", label = "Addon settings", compare = "applied", scope = "account" },
  { key = "profiles", label = "Addon profiles (Dominos, Questie and others)", compare = "applied", scope = "character" },
  { key = "positions", label = "Window positions", compare = "applied", scope = "character" },
  { key = "macros", label = "General macros", compare = "live" },
  { key = "clicks", label = "Click casting", compare = "live" },
}

-- addon settings apply through settingsDiff in applySetup, table by table
local function applyPart(key, data)
  if data[key] == nil then return end   -- a part the setup doesn't carry is left alone
  if key == "cvars" then applyCVars(data.cvars)
  elseif key == "binds" then applyBinds(data.binds)
  elseif key == "editmode" then return applyEditMode(data.editmode)
  elseif key == "chat" then applyChat(data.chat)
  elseif key == "addons" then return applyAddons(data.addons, playerKey())
  elseif key == "macros" then return applyGeneralMacros(data.macros)
  elseif key == "profiles" then return applyProfiles(data.profiles)
  elseif key == "positions" then return applyPositions(data.positions)
  elseif key == "clicks" then applyClicks(data.clicks) end
end

-- A part counts as updated when its content differs from what was last applied. Keys are sorted, so
-- table order can't fake a change; addon tables and the layout are compared decoded, not as bytes.
local function canon(v, out)
  local t = type(v)
  if t == "table" then
    local keys = {}
    for k in pairs(v) do keys[#keys + 1] = k end
    table.sort(keys, function(a, b) return type(a) .. tostring(a) < type(b) .. tostring(b) end)
    out[#out + 1] = "{"
    for _, k in ipairs(keys) do canon(k, out); out[#out + 1] = "="; canon(v[k], out); out[#out + 1] = ";" end
    out[#out + 1] = "}"
  elseif t == "string" then
    out[#out + 1] = #v .. ":" .. v
  else
    out[#out + 1] = t:sub(1, 1) .. tostring(v)
  end
end

local function hash(v)
  local out = {}
  canon(v, out)
  local s, h = table.concat(out), 5381
  for i = 1, #s, 4096 do
    for _, b in ipairs({ s:byte(i, math.min(i + 4095, #s)) }) do h = (h * 33 + b) % 4294967296 end
  end
  return h
end

local function partHashes(data)
  local out = {}
  for _, p in ipairs(PARTS) do
    local v = data[p.key]
    if v ~= nil then
      if p.key == "editmode" and v.layout then
        v = { layout = sharedLayout(v) or v.layout, settings = v.settings }
      end
      out[p.key] = hash(v)
    end
  end
  return out
end

local function charKey() return (UnitName("player") or "?") .. "-" .. (GetRealmName() or "?") end

local function appliedFor(scope)
  ZSettingsDB = ZSettingsDB or {}
  ZSettingsDB.applied = ZSettingsDB.applied or {}
  local key = scope == "account" and "account" or charKey()
  ZSettingsDB.applied[key] = ZSettingsDB.applied[key] or {}
  return ZSettingsDB.applied[key]
end

-- Addon settings are remembered per table, so a main and an alt with different addons running each
-- compare only their own. A table counts as changed when its content differs from what was applied.
local function seenSettings()
  local applied = appliedFor("account")
  if type(applied.settings) ~= "table" then applied.settings = {} end
  return applied.settings
end

local function settingsDiff(settings)
  local apply, missing = settingsToApply(settings)
  local seen, out = seenSettings(), {}
  for var, t in pairs(apply) do
    t.hash = hash(t.value)
    if seen[var] ~= t.hash then out[var] = t end
  end
  return out, missing
end

local function laterFor()
  ZSettingsDB = ZSettingsDB or {}
  if type(ZSettingsDB.later) ~= "table" then ZSettingsDB.later = {} end
  return ZSettingsDB.later
end

local function allowedCVars()
  local allowed = {}
  for _, name in ipairs(syncableCVars()) do allowed[name] = true end
  return allowed
end

local function listHash(list)
  local items = {}
  for _, v in ipairs(list or {}) do local out = {}; canon(v, out); items[#items + 1] = table.concat(out) end
  table.sort(items)
  return hash(items)
end

-- does this live part of the setup differ from the friend's UI right now
local function differsLive(key, data)
  local v = data[key]
  if key == "cvars" then
    local allowed = allowedCVars()
    for name, value in pairs(v) do
      if allowed[name] and C_CVar.GetCVar(name) ~= value then return true end
    end
  elseif key == "binds" then
    local layout, from = ZSettingsDB and ZSettingsDB.layout, data.layout or "qwerty"
    local wanted = (layout and from ~= "unknown" and from ~= layout) and convertBinds(v, from, layout) or v
    return hash(wanted) ~= hash(readBinds())
  elseif key == "macros" then
    for name, m in pairs(v) do
      local i = findMacro(name, false)
      if not i then return true end
      local _, icon, body = GetMacroInfo(i)
      if tostring(icon) ~= tostring(m[1]) or body ~= m[2] then return true end
    end
    for name in pairs(ZSettingsDB and ZSettingsDB.owned or {}) do
      if not v[name] and not addonMacro(name) and findMacro(name, false) then return true end
    end
  elseif key == "addons" then
    local have = readAddons()
    for name, on in pairs(v) do
      if not KEEP_ADDONS[name] and have[name] ~= nil and have[name] ~= on then return true end
    end
  elseif key == "clicks" then
    return listHash(v) ~= listHash(readClicks(true))
  end
  return false
end

-- the parts this setup would change here; force lists every part it carries
local function partsToOffer(data, force)
  local hashes, offer, updated = partHashes(data), {}, {}
  for _, p in ipairs(PARTS) do
    if data[p.key] ~= nil then
      local differs
      if p.compare == "live" then differs = differsLive(p.key, data)
      elseif p.key == "settings" then differs = next((settingsDiff(data.settings))) ~= nil
      else differs = hashes[p.key] ~= appliedFor(p.scope)[p.key] end
      if differs or force then offer[p.key] = true end
      if differs then updated[p.key] = true end
    end
  end
  return offer, updated
end

-- what /z undo needs to put back: for each part about to be applied, only what it will change, so a
-- later change of the friend's own is never undone and another character's apply is never repeated
local function snapshot(data, chosen)
  local snap = { format = 1, applied = {} }
  for _, p in ipairs(PARTS) do   -- what was last applied goes back too, so undo leaves no false "differs"
    if chosen[p.key] and data[p.key] ~= nil and p.compare == "applied" and p.key ~= "settings" then
      snap.applied[p.key] = appliedFor(p.scope)[p.key] or false
    end
  end
  if chosen.cvars and data.cvars then
    snap.cvars = {}
    local allowed = allowedCVars()
    for name, value in pairs(data.cvars) do
      local now = C_CVar.GetCVar(name)
      if allowed[name] and now ~= value then snap.cvars[name] = now end
    end
  end
  if chosen.binds and data.binds then   -- data.binds is already converted to this keyboard
    snap.binds = {}
    local now = readBinds()
    for key, command in pairs(now) do if data.binds[key] ~= command then snap.binds[key] = command end end
    for key, command in pairs(data.binds) do if now[key] ~= command then snap.binds[key] = now[key] or false end end
  end
  if chosen.editmode and data.editmode then
    local ok, theirs = pcall(C_EditMode.GetLayouts)
    local ok2, settings = pcall(C_EditMode.GetAccountSettings)
    if ok and type(theirs) == "table" then
      local slot, old
      for _, l in ipairs(theirs.layouts or {}) do
        if l.layoutName == LAYOUT_NAME then slot = l elseif l.layoutName == OLD_LAYOUT_NAME then old = l end
      end
      local active = theirs.layouts and theirs.layouts[(theirs.activeLayout or 0) - PRESETS]
      snap.editmode = { slot = slot or old or false, activeName = active and active.layoutName or nil,
        activePreset = not active and theirs.activeLayout or nil, settings = ok2 and settings or nil }
    end
  end
  if chosen.chat and data.chat then snap.chat = readChat() end
  if chosen.addons and data.addons then
    snap.addons = {}
    local have = readAddons()
    for name, on in pairs(data.addons) do
      if not KEEP_ADDONS[name] and have[name] ~= nil and have[name] ~= on then snap.addons[name] = have[name] end
    end
  end
  if chosen.settings and data.settings then
    snap.settings, snap.applied.settings = {}, {}
    local seen = seenSettings()
    for var, t in pairs((settingsDiff(data.settings))) do   -- the tables that will change, whatever their size
      snap.applied.settings[var] = seen[var] or false
      local value = _G[var]
      if value == nil then snap.settings[var] = { addon = t.addon, clear = true }
      else
        local ok, packed = pcall(C_EncodingUtil.SerializeCBOR, value)
        if ok then snap.settings[var] = { addon = t.addon, data = packed } end
      end
    end
  end
  if chosen.macros and data.macros then
    local before, owned = {}, {}
    for name in pairs(ZSettingsDB and ZSettingsDB.owned or {}) do owned[name] = true end
    for name, m in pairs(data.macros) do
      local i = findMacro(name, false)
      if not i then before[name] = false
      else
        local _, icon, body = GetMacroInfo(i)
        if tostring(icon) ~= tostring(m[1]) or body ~= m[2] then before[name] = { icon, body } end
      end
    end
    for name in pairs(owned) do
      local i = not data.macros[name] and findMacro(name, false)
      if i then local _, icon, body = GetMacroInfo(i); before[name] = { icon, body } end
    end
    snap.macros = { before = before, owned = owned }
  end
  if chosen.clicks and data.clicks then snap.clicks = readClicks(true) end   -- target and menu clicks only
  if chosen.positions and data.positions then
    snap.positions = {}
    for name in pairs(data.positions) do
      local f = _G[name]
      local p = type(f) == "table" and type(f.GetPoint) == "function" and framePosition(f)
      if p then
        local ok, placed = pcall(f.IsUserPlaced, f)
        p[5] = ok and placed or false
        snap.positions[name] = p
      end
    end
  end
  if chosen.profiles and data.profiles then
    snap.profiles = {}
    for var, e in pairs(data.profiles) do
      local db = not e.details and aceDB(var)
      local d, dprofiles
      if e.details then d, dprofiles = details() end
      if d then
        local ok, packed = pcall(C_EncodingUtil.SerializeCBOR, dprofiles[PROFILE_NAME] or {})
        snap.profiles[var] = { addon = e.addon, details = true, active = d:GetCurrentProfileName(),
          had = dprofiles[PROFILE_NAME] ~= nil and ok and packed or false }
      elseif db then
        local had = type(db.sv.profiles) == "table" and db.sv.profiles[PROFILE_NAME] ~= nil
        local ok, packed = pcall(C_EncodingUtil.SerializeCBOR, readProfile(db.sv, PROFILE_NAME))
        snap.profiles[var] = { addon = e.addon, active = db:GetCurrentProfile(), had = had and ok and packed or false }
      end
    end
  end
  return snap
end

-- puts back exactly what a snapshot holds; parts it doesn't hold stay as they are
local function restore(snap)
  if snap.cvars then for name, value in pairs(snap.cvars) do pcall(C_CVar.SetCVar, name, value) end end
  if snap.binds then
    local now = readBinds()
    for key, command in pairs(snap.binds) do
      if command then SetBinding(key, command, context(command))
      elseif now[key] then SetBinding(key, nil, context(now[key])) end
    end
    SaveBindings(GetCurrentBindingSet())
  end
  local em = snap.editmode
  if em then
    for _, x in ipairs(em.settings or {}) do pcall(C_EditMode.SetAccountSetting, x.setting, x.value) end
    local ok, theirs = pcall(C_EditMode.GetLayouts)
    if ok and type(theirs) == "table" and type(theirs.layouts) == "table" then
      -- only the shared layout's slot goes back; layouts made since stay. An account layout this apply
      -- added stays while another character still has it applied.
      local account = (Enum.EditModeLayoutType and Enum.EditModeLayoutType.Account) or 1
      local others = false
      for key, applied in pairs(ZSettingsDB.applied or {}) do
        if key ~= "account" and key ~= charKey() and applied.editmode then others = true end
      end
      local current = theirs.layouts[(theirs.activeLayout or 0) - PRESETS]
      local currentName = current and current.layoutName
      for i, l in ipairs(theirs.layouts) do
        if l.layoutName == LAYOUT_NAME then
          if em.slot then theirs.layouts[i] = em.slot
          elseif l.layoutType ~= account or not others then table.remove(theirs.layouts, i) end
          break
        end
      end
      -- the layout selected before; if it's gone, the one selected now; else Blizzard's first preset
      local function indexOf(name)
        for i, l in ipairs(theirs.layouts) do if name and l.layoutName == name then return i + PRESETS end end
      end
      local active = em.activePreset or indexOf(em.activeName)
        or (currentName ~= LAYOUT_NAME and indexOf(currentName))
        or (not current and (theirs.activeLayout or 0) <= PRESETS and theirs.activeLayout) or 1
      theirs.activeLayout = active
      pcall(C_EditMode.SaveLayouts, theirs)
      pcall(C_EditMode.SetActiveLayout, active)
    end
  end
  if snap.chat then applyChat(snap.chat) end
  if snap.addons then applyAddons(snap.addons, playerKey()) end
  if snap.settings then
    local seen = seenSettings()
    for var, before in pairs(snap.applied and snap.applied.settings or {}) do seen[var] = before or nil end
    for var, e in pairs(snap.settings) do
      if e.clear then pending[var] = CLEAR
      else
        local ok, value = pcall(C_EncodingUtil.DeserializeCBOR, e.data)
        if ok then pending[var] = value end
      end
    end
    assignPending()
  end
  if snap.macros then
    -- the brought-macros list changes only for the macros this apply created or deleted, so another
    -- character's apply since then keeps its own
    local owned = ZSettingsDB.owned or {}
    for name, m in pairs(snap.macros.before) do
      local i = findMacro(name, false)
      if m == false then
        if i then DeleteMacro(i) end
        owned[name] = nil
      else
        if i then EditMacro(i, name, m[1], m[2]) else CreateMacro(name, m[1], m[2], false) end
        if snap.macros.owned[name] then owned[name] = true end
      end
    end
    ZSettingsDB.owned = owned
  end
  if snap.clicks then applyClicks(snap.clicks) end   -- spell and macro clicks stay as they are now
  for name, p in pairs(snap.positions or {}) do placeFrame(name, p, p[5]) end
  -- the profile selected before comes back; the shared one goes unless another character still uses it
  for var, e in pairs(snap.profiles or {}) do
    local db = not e.details and aceDB(var)
    local d, dprofiles
    if e.details then d, dprofiles = details() end
    if d then
      -- the shared Details profile stays: another character may have it selected, and Details can't say
      local ok, p = false, nil
      if e.had then ok, p = pcall(C_EncodingUtil.DeserializeCBOR, e.had) end
      if ok and type(p) == "table" then dprofiles[PROFILE_NAME] = p end
      pcall(d.ApplyProfile, d, e.active, true)
    elseif db then
      db:SetProfile(e.active)
      local ok, p = false, nil
      if e.had then ok, p = pcall(C_EncodingUtil.DeserializeCBOR, e.had) end
      if ok and type(p) == "table" then writeProfile(db.sv, p)
      elseif not e.had then
        local used = false
        for key, name in pairs(type(db.sv.profileKeys) == "table" and db.sv.profileKeys or {}) do
          if name == PROFILE_NAME and key ~= db.keys.char then used = true end
        end
        if not used then removeProfile(db.sv) end
      end
    end
  end
end

local function encode(data, prefix)
  return (prefix or FORMAT) .. C_EncodingUtil.EncodeBase64(C_EncodingUtil.CompressString(C_EncodingUtil.SerializeCBOR(data)))
end

local function decode(text, prefix)
  prefix = prefix or FORMAT
  text = (text or ""):gsub("%s+", "")
  if text:sub(1, #prefix) ~= prefix then return nil, "that's not a Z-Settings setup" end
  local ok, data = pcall(function()
    return C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(text:sub(#prefix + 1))))
  end)
  if not ok or type(data) ~= "table" or data.format ~= 1 then return nil, "the setup is damaged or incomplete" end
  return data
end

-- a published setup; one exported before an addon's macros stayed home still carries them
local function decodeSetup(text)
  local data, err = decode(text)
  if data and type(data.macros) == "table" then
    for name in pairs(data.macros) do if addonMacro(name) then data.macros[name] = nil end end
  end
  return data, err
end

-- applies the chosen parts (all when chosen is nil); the state they replace is kept per character
-- for /z undo, and the parts compared by what was applied remember it
local function applySetup(text, layout, chosen)
  if InCombatLockdown() then say("not in combat") return false end
  local data, err = decodeSetup(text)
  if not data then say(err) return false end
  if not chosen then
    chosen = {}
    for _, p in ipairs(PARTS) do chosen[p.key] = true end
  end
  local hashes = partHashes(data)
  local from = data.layout or "qwerty"
  if chosen.binds and layout ~= "unknown" and from ~= "unknown" and from ~= layout then
    data.binds = convertBinds(data.binds or {}, from, layout)
    note(("keybinds converted from %s to %s"):format(LAYOUT_NAMES[from] or from, LAYOUT_NAMES[layout] or layout))
  end
  ZSettingsDB = ZSettingsDB or {}
  -- an older version's single undo is two steps back once this apply lands: it goes
  if type(ZSettingsDB.undo) ~= "table" then ZSettingsDB.undo = {} end
  local snap = snapshot(data, chosen)
  snap.setup = hash(text)
  -- A second apply of the same setup (the settings of an addon switched on by the first, after the
  -- reload) joins the first step: one undo reverts the whole update. The earliest state wins.
  local prev = decode(ZSettingsDB.undo[charKey()])
  if prev and prev.setup == snap.setup then
    for _, key in ipairs({ "cvars", "binds", "addons", "settings", "profiles", "positions" }) do
      if prev[key] then
        snap[key] = snap[key] or {}
        for k, v in pairs(prev[key]) do snap[key][k] = v end
      end
    end
    if prev.macros then
      snap.macros = snap.macros or { before = {}, owned = prev.macros.owned }
      for k, v in pairs(prev.macros.before) do snap.macros.before[k] = v end
      snap.macros.owned = prev.macros.owned
    end
    for _, key in ipairs({ "editmode", "chat", "clicks" }) do snap[key] = prev[key] or snap[key] end
    for k, v in pairs(prev.applied or {}) do
      if k == "settings" then
        snap.applied.settings = snap.applied.settings or {}
        for var, h in pairs(v) do snap.applied.settings[var] = h end
      else
        snap.applied[k] = v
      end
    end
  end
  ZSettingsDB.undo[charKey()] = encode(snap)
  local tables, missing = {}, {}
  if chosen.settings and data.settings then tables, missing = settingsDiff(data.settings) end
  local done, failed, macros, settingsDone, addons = {}, {}, 0, 0, 0
  for _, p in ipairs(PARTS) do
    if chosen[p.key] and data[p.key] ~= nil then
      local before, a = #failed, nil
      if p.key == "settings" then
        a = try(failed, p.label, applyAddonSettings, tables)
        if #failed == before then
          local seen = seenSettings()
          for var, t in pairs(tables) do seen[var] = t.hash end
        end
      else
        a = try(failed, p.label, applyPart, p.key, data)
      end
      -- a part that failed isn't remembered as applied, so the popup offers it again
      if #failed == before then
        if p.key == "macros" then macros = a or 0
        elseif p.key == "settings" then settingsDone = a or 0
        elseif p.key == "addons" then addons = a or 0 end
        if p.compare == "applied" and p.key ~= "settings" and (p.key ~= "editmode" or a) then
          appliedFor(p.scope)[p.key] = hashes[p.key]
        end
        done[#done + 1] = p.label:lower()
      end
    end
  end
  laterFor()[charKey()] = nil
  note(("applied %s's setup (%s): %s"):format(data.by or "?", data.made or "?", table.concat(done, ", ")))
  note(("%d macros, %d addon settings, %d addons switched"):format(macros, settingsDone, addons))
  if #failed > 0 then note("couldn't apply, /z update offers it again: " .. table.concat(failed, ", ")) end
  local skipped = {}
  for addon in pairs(missing) do skipped[#skipped + 1] = addon end
  table.sort(skipped)
  if #skipped > 0 then
    note("settings wait for addons that aren't running (off, or loading on demand): " .. table.concat(skipped, ", "))
  end
  note("/z undo puts back what this apply changed")
  return true
end

-- the key prompt ------------------------------------------------------------------------------

local function showPrompt(title)
  if not window then
    window = CreateFrame("Frame", "ZSettingsWindow", UIParent, "BackdropTemplate")
    window:SetSize(520, 132)
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")
    window:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,
      insets = { left = 8, right = 8, top = 8, bottom = 8 } })
    window.title = window:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    window.title:SetPoint("TOP", 0, -24)
    window.hint = window:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
    window.hint:SetPoint("TOP", window.title, "BOTTOM", 0, -16)
    window.hint:SetSize(460, 40) -- two lines, so the longer hint wraps instead of running off the edge
    window.hint:SetJustifyV("TOP")
    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -6, -6)
    -- closing cancels: no key press is waited for any more
    window:SetScript("OnHide", function(self) self:SetScript("OnKeyDown", nil); self:EnableKeyboard(false) end)
  end
  window.title:SetText(title)
  window.hint:SetText("")
  window:Show()
end

-- commands ------------------------------------------------------------------------------------

-- Z_BUNDLE is written into ZBundle.lua by the git commit hook: the setup that ships with the addon
local function bundle()
  if type(Z_BUNDLE) ~= "string" then return nil, "no setup in this addon yet: git pull in the AddOns folder, then restart WoW" end
  local data, err = decodeSetup(Z_BUNDLE)
  if not data then return nil, err .. ": git pull in the AddOns folder again" end
  return Z_BUNDLE, data
end

-- the key is asked once and remembered; /z import asks again to correct a wrong press
local function withLayout(ask, title, done)
  ZSettingsDB = ZSettingsDB or {}
  if ZSettingsDB.layout and not ask then done(ZSettingsDB.layout) return end
  showPrompt(title)
  askLayout(function(layout)
    window:Hide()
    ZSettingsDB.layout = layout
    done(layout)
  end)
end

-- the update popup ------------------------------------------------------------------------------

local popup
local function showUpdate(text, data, offer, updated)
  if not popup then
    popup = CreateFrame("Frame", "ZSettingsUpdate", UIParent, "BackdropTemplate")
    popup:SetSize(460, 172 + #PARTS * 30)
    popup:SetPoint("CENTER")
    popup:SetFrameStrata("DIALOG")
    popup:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,
      insets = { left = 8, right = 8, top = 8, bottom = 8 } })
    popup.title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    popup.title:SetPoint("TOP", 0, -24)
    popup.note = popup:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    popup.note:SetPoint("TOP", popup.title, "BOTTOM", 0, -10)
    popup.note:SetSize(400, 32) -- room for a two-line note from the exporter
    popup.note:SetJustifyV("TOP")
    popup.boxes = {}
    for i, p in ipairs(PARTS) do
      local box = CreateFrame("CheckButton", nil, popup, "UICheckButtonTemplate")
      box:SetPoint("TOPLEFT", 36, -96 - (i - 1) * 30)
      box.label = popup:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
      box.label:SetPoint("LEFT", box, "RIGHT", 6, 0)
      box.key = p.key
      popup.boxes[i] = box
    end
    popup.apply = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
    popup.apply:SetSize(140, 30)
    popup.apply:SetPoint("BOTTOMRIGHT", popup, "BOTTOM", -8, 22)
    popup.apply:SetText("Apply")
    popup.later = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
    popup.later:SetSize(140, 30)
    popup.later:SetPoint("BOTTOMLEFT", popup, "BOTTOM", 8, 22)
    popup.later:SetText("Later")
  end
  popup.title:SetText(("%s's setup, %s"):format(data.by or "?", data.made or "?"))
  popup.note:SetText(data.note or "Ticked parts are applied, then the UI reloads")
  local row = 0
  for i, p in ipairs(PARTS) do
    local box = popup.boxes[i]
    if offer[p.key] then
      box:ClearAllPoints()
      box:SetPoint("TOPLEFT", 36, -96 - row * 30)
      row = row + 1
      box:SetChecked(true)
      box.label:SetText(p.label .. (updated[p.key] and " (updated)" or ""))
      box:Show(); box.label:Show()
    else
      box:SetChecked(false)
      box:Hide(); box.label:Hide()
    end
  end
  popup:SetHeight(172 + row * 30)
  popup.apply:SetScript("OnClick", function()
    local chosen, any = {}, false
    for _, box in ipairs(popup.boxes) do
      if offer[box.key] and box:GetChecked() then chosen[box.key], any = true, true end
    end
    if not any then say("nothing ticked") return end
    popup:Hide()
    withLayout(false, "Z-Settings: your keyboard", function(layout)
      if applySetup(text, layout, chosen) then ReloadUI() end
    end)
  end)
  popup.later:SetScript("OnClick", function()
    laterFor()[charKey()] = hash(text)   -- the exact setup, so a re-export in the same minute still shows
    popup:Hide()
    say("/z update opens this again")
  end)
  popup:Show()
end

local waitingForCombat
-- force: /z update lists every part, also after Later and on a PC that exports
local function checkForUpdate(force)
  local text, data = bundle()
  if not text then if force then say(data) end return end
  ZSettingsDB = ZSettingsDB or {}
  -- a PC that exports is the source: ZBundle.lua there trails the newest export until the next commit
  local source = ZSettingsDB.export ~= nil
  if not force and source then return end
  local offer, updated = partsToOffer(data, force)
  -- the minimap button's dot: the setup still changes something here, also after Later
  if not source and ns.setDue then ns.setDue(next(updated) ~= nil) end
  if not force and laterFor()[charKey()] == hash(text) then return end
  if not next(offer) then
    if force then say("this setup carries nothing to apply") end
    return
  end
  if InCombatLockdown() then waitingForCombat = { force = force } return end
  showUpdate(text, data, offer, updated)
end

-- An older version's undo: a full capture from before its import, made on one character. Put back
-- without touching what the friend made since: only the macros the setup brings, only the shared layout
-- (or the whole list, when that version replaced it for lack of a free slot), only target/menu clicks,
-- only the addon tables that version wrote.
local function legacyRestore(data)
  local _, current = bundle()
  current = type(current) == "table" and current or {}
  applyCVars(data.cvars or {})
  if data.binds then applyBinds(data.binds) end
  local em = data.editmode
  if em and em.layouts then
    for _, x in ipairs(em.settings or {}) do pcall(C_EditMode.SetAccountSetting, x.setting, x.value) end
    local had, missing = false, false
    local ok, theirs = pcall(C_EditMode.GetLayouts)
    if ok and type(theirs) == "table" and type(theirs.layouts) == "table" then
      local now = {}
      for _, l in ipairs(theirs.layouts) do now[l.layoutName] = true end
      for _, l in ipairs(em.layouts.layouts or {}) do
        if l.layoutName == LAYOUT_NAME or l.layoutName == OLD_LAYOUT_NAME then had = true end
        if not now[l.layoutName] then missing = true end
      end
      local active = em.layouts.layouts and em.layouts.layouts[(em.layouts.activeLayout or 0) - PRESETS]
      if missing then
        theirs = em.layouts   -- their own layouts were replaced wholesale: the whole list comes back
      else
        for i = #theirs.layouts, 1, -1 do
          local name = theirs.layouts[i].layoutName
          if not had and (name == LAYOUT_NAME or name == OLD_LAYOUT_NAME) then table.remove(theirs.layouts, i) end
        end
      end
      local index = not active and em.layouts.activeLayout or nil
      for i, l in ipairs(theirs.layouts) do if not index and active and l.layoutName == active.layoutName then index = i + PRESETS end end
      index = index or 1
      theirs.activeLayout = index
      pcall(C_EditMode.SaveLayouts, theirs)
      pcall(C_EditMode.SetActiveLayout, index)
    end
  end
  if data.chat then applyChat(data.chat) end
  if data.addons then applyAddons(data.addons, playerKey()) end
  if data.macros then
    for name in pairs(current.macros or {}) do
      local i, m = findMacro(name, false), data.macros[name]
      if m and i then EditMacro(i, name, m[1], m[2])
      elseif not m and i then DeleteMacro(i) end
    end
    ZSettingsDB.owned = nil
  end
  if data.clicks then
    local targetMenu = {}
    for _, b in ipairs(data.clicks) do
      if b.type == Enum.ClickBindingType.Interaction then targetMenu[#targetMenu + 1] = b end
    end
    applyClicks(targetMenu)
  end
  if data.settings then
    -- a settings table the setup carries goes back; a data table only while it still holds exactly the
    -- setup's copy (builds before the data-table filter wrote those; later ones never touched them)
    for var, e in pairs(data.settings) do
      local ok, value = pcall(C_EncodingUtil.DeserializeCBOR, e.data)
      local carried = current.settings and current.settings[var]
      if ok and carried and not KEEP_ADDONS[e.addon] then
        local okB, theirs = pcall(C_EncodingUtil.DeserializeCBOR, carried.data)
        if shareable(var, value) or (okB and hash(theirs) == hash(_G[var])) then pending[var] = value end
      end
    end
    assignPending()
  end
end

local function undo()
  ZSettingsDB = ZSettingsDB or {}
  local key = charKey()
  local mine = type(ZSettingsDB.undo) == "table" and ZSettingsDB.undo[key]
  local legacy = type(ZSettingsDB.undo) == "string" and ZSettingsDB.undo   -- an older version's single undo
  local data = mine and decode(mine)
  if data and data.kind == "copy" then
    ns.restoreCopy(data)
    ZSettingsDB.undo[key] = nil
    note("what the last copy changed is back as it was")
    ReloadUI()
    return
  elseif data then
    restore(data)
    ZSettingsDB.undo[key] = nil
    for _, p in ipairs(PARTS) do
      local before = data.applied and data.applied[p.key]
      if before ~= nil and p.key ~= "settings" then appliedFor(p.scope)[p.key] = before or nil end
    end
  else
    data = legacy and decode(legacy)
    if not data then say("nothing to undo") return end
    if data.by and data.by ~= UnitName("player") then
      say(("the undo from the older version belongs to %s: log in there and type /z undo"):format(data.by))
      return
    end
    legacyRestore(data)
    ZSettingsDB.undo = nil
    if ZSettingsDB.applied then
      ZSettingsDB.applied[key] = nil
      if ZSettingsDB.applied.account then ZSettingsDB.applied.account.settings = nil end
    end
  end
  if type(Z_BUNDLE) == "string" then laterFor()[key] = hash(Z_BUNDLE) end   -- quiet here until the next setup
  note("what the last apply changed is back as it was")
  ReloadUI()
end

SLASH_ZSETTINGS1 = "/z"
SlashCmdList.ZSETTINGS = function(msg)
  local cmd, rest = (msg or ""):match("^%s*(%S*)%s*(.-)%s*$")
  cmd = cmd:lower()
  if InCombatLockdown() and cmd ~= "" then say("not in combat") return end
  if cmd == "export" then
    local data, skipped, failed = capture(true)
    data.note = rest ~= "" and rest or nil
    showPrompt("Z-Settings: export your setup")
    askLayout(function(layout)
      data.layout = layout
      ZSettingsDB = ZSettingsDB or {}
      -- copied into ZBundle.lua by the commit hook, which checks exportVars against the addon list it writes
      ZSettingsDB.export, ZSettingsDB.exportMade, ZSettingsDB.exportVars = encode(data), data.made, Z_VARS_ID
      note(("your keyboard: %s. Friends on another layout get their keybinds converted."):format(LAYOUT_NAMES[layout] or "unknown"))
      if #skipped > 0 then note("not included (too large or not shareable): " .. table.concat(skipped, ", ")) end
      if #failed > 0 then note("not included, it threw an error: " .. table.concat(failed, ", ")) end
      note("export saved: commit and push the AddOns folder")
      window:Hide()
      ReloadUI()
    end)
  elseif cmd == "import" then
    local text, data = bundle()
    if not text then say(data) return end
    withLayout(true, ("Z-Settings: import %s's setup (%s)"):format(data.by or "?", data.made or "?"), function(layout)
      if applySetup(text, layout) then ReloadUI() end
    end)
  elseif cmd == "update" then
    checkForUpdate(true)
  elseif cmd == "undo" then
    undo()
  elseif cmd == "save" then
    ns.saveCharacter()
  elseif cmd == "copy" then
    ns.copyCharacter(rest)
  else
    local text, data = bundle()
    say("/z update: choose what to apply from " .. (text and ("%s's setup of %s"):format(data.by or "?", data.made or "?") or "the published setup (none yet)"))
    say("/z import: apply the whole setup")
    say("/z save: save this character for copying")
    say("/z copy [name]: copy a saved character onto this one")
    say("/z undo: revert the last apply or copy on this character")
    say("/z export [note]: save your setup for publishing")
  end
end

-- keeps imported addon settings assigned while the game saves them at /reload or logout, prints
-- what the last command said before it reloaded the UI, and offers a newer setup
local saver = CreateFrame("Frame")
saver:RegisterEvent("PLAYER_LOGIN")
saver:RegisterEvent("PLAYER_LOGOUT")
saver:RegisterEvent("PLAYER_REGEN_ENABLED")
saver:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGOUT" then assignPending() return end
  if event == "PLAYER_REGEN_ENABLED" then
    if waitingForCombat then
      local force = waitingForCombat.force
      waitingForCombat = nil
      checkForUpdate(force)
    end
    return
  end
  for _, line in ipairs(ZSettingsDB and ZSettingsDB.notice or {}) do say(line) end
  if ZSettingsDB then ZSettingsDB.notice = nil end
  if ns.afterLogin() then return end   -- a copy's follow-up reloads the UI; the popup waits for that
  checkForUpdate(false)
end)

-- what Characters.lua reuses
ns.say, ns.note, ns.encode, ns.decode, ns.hash = say, note, encode, decode, hash
ns.readBinds, ns.applyBinds, ns.readCVars, ns.applyCVars = readBinds, applyBinds, readCVars, applyCVars
ns.readEditMode, ns.readChat, ns.applyChat, ns.readAddons, ns.applyAddons = readEditMode, readChat, applyChat, readAddons, applyAddons
ns.findMacro, ns.charKey, ns.playerKey, ns.assignPending = findMacro, charKey, playerKey, assignPending
ns.pending, ns.CLEAR, ns.DATA_TABLES, ns.KEEP_ADDONS, ns.MAX_ADDON_TABLE, ns.PRESETS = pending, CLEAR, DATA_TABLES, KEEP_ADDONS, MAX_ADDON_TABLE, PRESETS
ns.MAX_ACCOUNT_MACROS, ns.try = MAX_ACCOUNT_MACROS, try
