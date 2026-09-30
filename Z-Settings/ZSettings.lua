-- Z-Settings: share your whole interface with friends.
-- /z export saves your setup for the git commit hook, /z import applies the setup that ships with this
-- addon (ZBundle.lua, written by that hook), /z undo puts back what you had. Each reloads the UI itself.
-- Shared: interface settings, keybinds (converted between QWERTY and AZERTY), Edit Mode, chat windows,
-- enabled addons, every addon's account-wide settings, target/menu click casting and General macros that
-- cast no spell. Left out: action bars, Cooldown Manager, character macros and spell macros (class-specific),
-- per-character addon data, and the personal setup addons. On command only. Never in combat.

local FORMAT = "ZS1:"
local MAX_ACCOUNT_MACROS = (Constants and Constants.MacroConsts and Constants.MacroConsts.MAX_ACCOUNT_MACROS) or 120
local MAX_ADDON_TABLE = 300000   -- bytes of one addon's settings before compression; larger ones are listed, not shared
-- never shared or switched: this addon and the personal setup addons
local KEEP_ADDONS = { ["Z-Settings"] = true, BarSync = true, ZeroshinSetup = true }

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

local function readEditMode()
  local ok, layouts = pcall(C_EditMode.GetLayouts)
  local ok2, settings = pcall(C_EditMode.GetAccountSettings)
  if not ok or not ok2 then return nil end
  return { layouts = layouts, settings = settings }
end

-- Import adds your active layout to the friend's layouts under this name, or overwrites the one
-- already there; their own layouts stay. With every layout slot taken, all of yours replace theirs.
local LAYOUT_NAME = "Zeroshin"
local function applyEditMode(em, exact)
  local mine = em.layouts
  if not mine then return end
  local presets = (Enum.EditModePresetLayoutsMeta and Enum.EditModePresetLayoutsMeta.NumValues) or 2
  local account = (Enum.EditModeLayoutType and Enum.EditModeLayoutType.Account) or 1
  local max = (Constants and Constants.EditModeConsts and Constants.EditModeConsts.EditModeMaxLayoutsPerType) or 5
  local shared = mine.layouts and mine.layouts[(mine.activeLayout or 0) - presets]
  local ok, theirs = pcall(C_EditMode.GetLayouts)
  if exact or not shared or not ok or type(theirs) ~= "table" or type(theirs.layouts) ~= "table" then
    pcall(C_EditMode.SaveLayouts, mine)
    if mine.activeLayout then pcall(C_EditMode.SetActiveLayout, mine.activeLayout) end
    return
  end
  local layout = {}
  for k, v in pairs(shared) do layout[k] = v end
  layout.layoutName, layout.layoutType = LAYOUT_NAME, account
  local at, accounts, lastAccount = nil, 0, 0
  for i, l in ipairs(theirs.layouts) do
    if l.layoutName == LAYOUT_NAME then at = i end
    if l.layoutType == account then accounts, lastAccount = accounts + 1, i end
  end
  if at then
    theirs.layouts[at] = layout
    note(("Edit Mode: layout %s updated and active"):format(LAYOUT_NAME))
  elseif accounts < max then
    at = lastAccount + 1   -- account layouts come before character ones
    table.insert(theirs.layouts, at, layout)
    note(("Edit Mode: layout %s added and active"):format(LAYOUT_NAME))
  else
    pcall(C_EditMode.SaveLayouts, mine)
    if mine.activeLayout then pcall(C_EditMode.SetActiveLayout, mine.activeLayout) end
    note(("Edit Mode: no free layout slot for %s, so all your layouts were replaced"):format(LAYOUT_NAME))
    return
  end
  theirs.activeLayout = at + presets
  pcall(C_EditMode.SaveLayouts, theirs)
  pcall(C_EditMode.SetActiveLayout, theirs.activeLayout)
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

local function readAddons()
  local out, who = {}, UnitName("player")
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

local function applyBinds(wanted)
  local current = readBinds()
  for key, command in pairs(current) do
    if wanted[key] ~= command then SetBinding(key, nil, context(command)) end
  end
  for key, command in pairs(wanted) do
    if current[key] ~= command then SetBinding(key, command, context(command)) end
  end
  SaveBindings(GetCurrentBindingSet())
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

local function applyAddons(wanted)
  local who, changed = UnitName("player"), 0
  local have = readAddons()
  for name, on in pairs(wanted) do
    if not KEEP_ADDONS[name] and have[name] ~= nil and have[name] ~= on then
      if on then C_AddOns.EnableAddOn(name, who) else C_AddOns.DisableAddOn(name, who) end
      changed = changed + 1
    end
  end
  if changed > 0 then C_AddOns.SaveAddOns() end
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

-- General macros that cast nothing: /cast, /castsequence and /castrandom make a macro class-specific
local function isShareableMacro(body)
  for line in (body or ""):gmatch("[^\n]+") do
    local cmd = line:match("^%s*/(%a+)")
    cmd = cmd and cmd:lower()
    if cmd == "cast" or cmd == "castsequence" or cmd == "castrandom" then return false end
  end
  return true
end

local function readGeneralMacros(shareOnly)
  local out = {}
  for i = 1, (GetNumMacros()) do
    local name, icon, body = GetMacroInfo(i)
    if name and (not shareOnly or isShareableMacro(body)) then out[name] = { icon, body } end
  end
  return out
end

local function applyGeneralMacros(wanted, exact)
  local changed = 0
  if exact then  -- undo: the General tab goes back exactly as it was
    for i = (GetNumMacros()), 1, -1 do
      local name = GetMacroInfo(i)
      if name and not wanted[name] then DeleteMacro(i); changed = changed + 1 end
    end
  end
  for name, m in pairs(wanted) do
    local i = findMacro(name, false)
    if not i then CreateMacro(name, m[1], m[2], false); changed = changed + 1
    else
      local _, icon, body = GetMacroInfo(i)
      if tostring(icon) ~= tostring(m[1]) or body ~= m[2] then EditMacro(i, name, m[1], m[2]); changed = changed + 1 end
    end
  end
  return changed
end

local function readClicks(interactionOnly)
  local out = {}
  for _, b in ipairs(C_ClickBindings.GetProfileInfo()) do
    if not interactionOnly or b.type == Enum.ClickBindingType.Interaction then out[#out + 1] = b end
  end
  return out
end

local function applyClicks(wanted, exact)
  local profile = {}
  if not exact then  -- import keeps your own spell and macro clicks and replaces target/menu clicks
    for _, b in ipairs(C_ClickBindings.GetProfileInfo()) do
      if b.type ~= Enum.ClickBindingType.Interaction then profile[#profile + 1] = b end
    end
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
    local value = _G[t.var]
    if value ~= nil then
      local ok, packed = pcall(C_EncodingUtil.SerializeCBOR, value)
      if ok and packed and #packed <= MAX_ADDON_TABLE then out[t.var] = { addon = t.addon, data = packed }
      else skipped[#skipped + 1] = t.addon .. " (" .. t.var .. (ok and ", too large" or ", not shareable") .. ")" end
    end
  end
  return out, skipped
end

-- imported addon tables stay assigned until the game saves them at /reload or logout
local pending = {}
local function assignPending()
  for var, value in pairs(pending) do _G[var] = value end
end

local function applyAddonSettings(settings)
  local installed, done, missing = {}, 0, {}
  for i = 1, C_AddOns.GetNumAddOns() do
    local name = C_AddOns.GetAddOnInfo(i)
    if name then installed[name] = true end
  end
  for var, entry in pairs(settings) do
    if installed[entry.addon] and not KEEP_ADDONS[entry.addon] then
      local ok, value = pcall(C_EncodingUtil.DeserializeCBOR, entry.data)
      if ok then pending[var] = value; done = done + 1 end
    else
      missing[entry.addon] = true
    end
  end
  assignPending()
  local list = {}
  for a in pairs(missing) do list[#list + 1] = a end
  table.sort(list)
  return done, list
end

local window

-- keyboard layouts ------------------------------------------------------------------------------
-- The same physical keys, row by row, on each layout (WoW names a key by what it types).
-- Converting a keybind: find the key's position on the sender's layout, take the receiver's
-- key at that position. Modifiers, F-keys, numpad and mouse buttons stay as they are.
local LAYOUTS = {
  qwerty = { "`","1","2","3","4","5","6","7","8","9","0","-","=", "Q","W","E","R","T","Y","U","I","O","P","[","]","\\",
             "A","S","D","F","G","H","J","K","L",";","'", "Z","X","C","V","B","N","M",",",".","/" },
  ["azerty-be"] = { "²","&","é","\"","'","(","§","è","!","ç","à",")","-", "A","Z","E","R","T","Y","U","I","O","P","^","$","µ",
             "Q","S","D","F","G","H","J","K","L","M","ù", "W","X","C","V","B","N",",",";",":","=" },
}
local LAYOUT_NAMES = { qwerty = "QWERTY", ["azerty-be"] = "Belgian AZERTY" }

local function position(layout, key)
  for i, k in ipairs(LAYOUTS[layout] or {}) do
    if k == key or k:upper() == key:upper() then return i end
  end
end

local function convertKey(key, from, to)
  if from == to or not LAYOUTS[from] or not LAYOUTS[to] then return key end
  -- peel off modifiers: "ALT-SHIFT-Q" is ALT-, SHIFT- and the key Q; "SHIFT--" is Shift+minus
  local mods, base = "", key
  while true do
    local m = base:match("^(%u+)%-.")
    if m == "ALT" or m == "CTRL" or m == "SHIFT" or m == "META" then
      mods, base = mods .. m .. "-", base:sub(#m + 2)
    else
      break
    end
  end
  if base == "" then return key end
  local i = position(from, base)
  if not i then return key end
  return mods .. LAYOUTS[to][i]
end

local function convertBinds(binds, from, to)
  if from == to then return binds end
  local out = {}
  for key, command in pairs(binds) do out[convertKey(key, from, to)] = command end
  return out
end

-- One key press: the key right of Tab types Q on QWERTY and A on Belgian AZERTY.
local function askLayout(done)
  if InCombatLockdown() then say("not in combat") return end
  window:EnableKeyboard(true)
  window:SetPropagateKeyboardInput(false)
  window.hint:SetText("Press the key right of Tab (the one below 1 and 2)")
  window:SetScript("OnKeyDown", function(self, key)
    key = (key or ""):upper()
    self:SetScript("OnKeyDown", nil)
    self:EnableKeyboard(false)
    local layout = (key == "Q" and "qwerty") or (key == "A" and "azerty-be") or "unknown"
    if layout == "unknown" then say(("key '%s' isn't a layout I know: keybinds stay as they are"):format(key)) end
    done(layout)
  end)
end

-- the whole shareable state -------------------------------------------------------------------

local function capture(forSharing)
  local settings, skipped = readAddonSettings()
  return {
    format = 1, made = date("%Y-%m-%d %H:%M"), by = UnitName("player"),
    cvars = readCVars(), binds = readBinds(), editmode = readEditMode(), chat = readChat(),
    addons = readAddons(), macros = readGeneralMacros(forSharing), clicks = readClicks(forSharing),
    settings = settings,
  }, skipped
end

local function applyAll(data, exact)
  applyCVars(data.cvars or {})
  applyBinds(data.binds or {})
  if data.editmode then
    applyEditMode(data.editmode, exact)
    for _, s in ipairs(data.editmode.settings or {}) do pcall(C_EditMode.SetAccountSetting, s.setting, s.value) end
  end
  if data.chat then applyChat(data.chat) end
  local addonsChanged = data.addons and applyAddons(data.addons) or 0
  local macros = applyGeneralMacros(data.macros or {}, exact)
  applyClicks(data.clicks or {}, exact)
  local tables, missing = applyAddonSettings(data.settings or {})
  return macros, tables, missing, addonsChanged
end

local function encode(data)
  return FORMAT .. C_EncodingUtil.EncodeBase64(C_EncodingUtil.CompressString(C_EncodingUtil.SerializeCBOR(data)))
end

local function decode(text)
  text = (text or ""):gsub("%s+", "")
  if text:sub(1, #FORMAT) ~= FORMAT then return nil, "that's not a Z-Settings setup" end
  local ok, data = pcall(function()
    return C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(text:sub(#FORMAT + 1))))
  end)
  if not ok or type(data) ~= "table" or data.format ~= 1 then return nil, "the setup is damaged or incomplete" end
  return data
end

local function doImport(text, layout)
  if InCombatLockdown() then say("not in combat") return false end
  local data, err = decode(text)
  if not data then say(err) return false end
  local from = data.layout or "qwerty"
  if layout ~= "unknown" and from ~= "unknown" and from ~= layout then
    data.binds = convertBinds(data.binds or {}, from, layout)
    note(("keybinds converted from %s to %s"):format(LAYOUT_NAMES[from] or from, LAYOUT_NAMES[layout] or layout))
  end
  ZSettingsDB = ZSettingsDB or {}
  ZSettingsDB.undo = encode((capture(false)))
  local macros, tables, missing, addons = applyAll(data, false)
  note(("imported %s's setup (%s): %d macros, %d addon settings, %d addons switched."):format(
    data.by or "?", data.made or "?", macros, tables, addons))
  if #missing > 0 then note("settings for addons you don't have were skipped: " .. table.concat(missing, ", ")) end
  note("/z undo puts back what you had")
  return true
end

-- the key prompt ------------------------------------------------------------------------------

local function showPrompt(title)
  if not window then
    window = CreateFrame("Frame", "ZSettingsWindow", UIParent, "BackdropTemplate")
    window:SetSize(460, 100)
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")
    window:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,
      insets = { left = 8, right = 8, top = 8, bottom = 8 } })
    window.title = window:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    window.title:SetPoint("TOP", 0, -20)
    window.hint = window:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    window.hint:SetPoint("TOP", window.title, "BOTTOM", 0, -14)
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
  local data, err = decode(Z_BUNDLE)
  if not data then return nil, err .. ": git pull in the AddOns folder again" end
  return Z_BUNDLE, data
end

SLASH_ZSETTINGS1 = "/z"
SlashCmdList.ZSETTINGS = function(msg)
  msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  if InCombatLockdown() and msg ~= "" then say("not in combat") return end
  if msg == "export" then
    local data, skipped = capture(true)
    showPrompt("Z-Settings: export your setup")
    askLayout(function(layout)
      data.layout = layout
      ZSettingsDB = ZSettingsDB or {}
      ZSettingsDB.export, ZSettingsDB.exportMade = encode(data), data.made   -- copied into ZBundle.lua by the commit hook
      note(("your keyboard: %s. Friends on another layout get their keybinds converted."):format(LAYOUT_NAMES[layout] or "unknown"))
      if #skipped > 0 then note("not included (too large or not shareable): " .. table.concat(skipped, ", ")) end
      note("export saved: commit and push the AddOns folder")
      window:Hide()
      ReloadUI()
    end)
  elseif msg == "import" then
    local text, data = bundle()
    if not text then say(data) return end
    showPrompt(("Z-Settings: import %s's setup (%s)"):format(data.by or "?", data.made or "?"))
    askLayout(function(layout)
      window:Hide()
      if doImport(text, layout) then ReloadUI() end
    end)
  elseif msg == "undo" then
    local data = ZSettingsDB and ZSettingsDB.undo and decode(ZSettingsDB.undo)
    if not data then say("nothing to undo") return end
    applyAll(data, true)
    ZSettingsDB.undo = nil
    note("your setup from before the import is back")
    ReloadUI()
  else
    local text, data = bundle()
    say("/z import: apply " .. (text and ("%s's setup from %s"):format(data.by or "?", data.made or "?") or "the setup in this addon (none yet)"))
    say("/z undo: put back what you had before the last import")
    say("/z export: save your own setup for publishing")
  end
end

-- keeps imported addon settings assigned while the game saves them at /reload or logout,
-- and prints what the last command said before it reloaded the UI
local saver = CreateFrame("Frame")
saver:RegisterEvent("PLAYER_LOGIN")
saver:RegisterEvent("PLAYER_LOGOUT")
saver:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGOUT" then assignPending() return end
  for _, line in ipairs(ZSettingsDB and ZSettingsDB.notice or {}) do say(line) end
  if ZSettingsDB then ZSettingsDB.notice = nil end
end)
