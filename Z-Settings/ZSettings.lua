-- Z-Settings: share your whole interface with friends.
-- /z import applies the setup that ships with this addon (ZBundle.lua, written by the git commit hook),
-- /z import paste takes a pasted string, /z undo puts back what you had, /z export makes a string.
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
-- Always copied, whatever the game's flags say
local CVAR_ALWAYS = { enableMultiActionBars = true } -- which action bars are switched on
local CVAR_SKIP = { "^CACHE", "^last", "Tutorial", "closedInfoFrames", "hardTracked", "trackedQuest",
  "^cameraSaved", "perksActivities", "petJournal", "^lfgSelected", "^agentUILocale", "^textLocale",
  "^audioLocale", "^portal", "^realm", "^account", "gameTip", "^engineSurvey", "^videoOptions",
  "^hwDetect", "^graphics", "^raidGraphics", "^RAID", "^gx", "^Gx", "^Sound_", "^sound",
  "ollapsed", "^num", "RenownMap$", "LastPointsMap$", "LastUpdate", "^minimapTracked", "InfoShown$", "AlreadyShown$",
  "ExampleShown$", "^notifiedOf", "^seen", "^talentPointsSpent", "^maxLevelSpecsUsed",
  "^GamepadCameraSaved" }

local function say(...) print("|cff8788eeZ-Settings|r:", ...) end

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
    if c.commandType == 0 and (CVAR_ALWAYS[c.command] or not CVAR_EXCLUDED_CATEGORIES[c.category]) then
      local skip = false
      for _, pattern in ipairs(CVAR_SKIP) do if c.command:find(pattern) then skip = true; break end end
      if not skip then
        local _, _, account, character, locked, secure, readOnly = C_CVar.GetCVarInfo(c.command)
        if (account or character or CVAR_ALWAYS[c.command]) and not locked and not secure and not readOnly then
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

-- every installed addon's account-wide settings tables (SavedVariables, not the per-character ones)
local function addonTables()
  local out = {}
  for i = 1, C_AddOns.GetNumAddOns() do
    local addon = C_AddOns.GetAddOnInfo(i)
    if addon and not KEEP_ADDONS[addon] then
      local list = C_AddOns.GetAddOnMetadata(addon, "SavedVariables")
      for var in (list or ""):gmatch("[^,%s]+") do out[#out + 1] = { addon = addon, var = var } end
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
  ["azerty-fr"] = { "²","&","é","\"","'","(","-","è","_","ç","à",")","=", "A","Z","E","R","T","Y","U","I","O","P","^","$","*",
             "Q","S","D","F","G","H","J","K","L","M","ù", "W","X","C","V","B","N",",",";",":","!" },
  ["azerty-be"] = { "²","&","é","\"","'","(","§","è","!","ç","à",")","-", "A","Z","E","R","T","Y","U","I","O","P","^","$","µ",
             "Q","S","D","F","G","H","J","K","L","M","ù", "W","X","C","V","B","N",",",";",":","=" },
}
-- AZERTY with a number row WoW names 1-0 instead of & é " (in case the client does that)
for _, name in ipairs({ "azerty-fr", "azerty-be" }) do
  local digits = {}
  for i, k in ipairs(LAYOUTS[name]) do digits[i] = k end
  for i = 2, 11 do digits[i] = LAYOUTS.qwerty[i] end
  LAYOUTS[name .. "-digits"] = digits
end
local LAYOUT_NAMES = { qwerty = "QWERTY", ["azerty-fr"] = "French AZERTY", ["azerty-be"] = "Belgian AZERTY",
  ["azerty-fr-digits"] = "French AZERTY", ["azerty-be-digits"] = "Belgian AZERTY" }

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

-- Two key presses. The key right of Tab: letters are always named by what they type, so Q means
-- QWERTY and A means AZERTY. Then the 6 key: French AZERTY types -, Belgian types §, and a 6 on
-- AZERTY means WoW names that row by its digits.
local function askLayout(done)
  if InCombatLockdown() then say("not in combat") return end
  window.box:ClearFocus()
  window:EnableKeyboard(true)
  window:SetPropagateKeyboardInput(false)
  local family
  window.hint:SetText("Press the key right of Tab (the one below 1 and 2)")
  window:SetScript("OnKeyDown", function(self, key)
    key = (key or ""):upper()
    if not family then
      if key == "Q" then
        family = "qwerty"
      elseif key == "A" then
        family = "azerty"
        self.hint:SetText("Now press the 6 key on the top row (not the numpad)")
        return
      else
        family = "unknown"
      end
    end
    local layout = family
    if family == "azerty" then
      if key == "-" then layout = "azerty-fr"
      elseif key == "§" then layout = "azerty-be"
      elseif key == "6" then layout = "azerty-be-digits"
      else layout = "azerty-be" end
    end
    self:SetScript("OnKeyDown", nil)
    self:EnableKeyboard(false)
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
    pcall(C_EditMode.SaveLayouts, data.editmode.layouts)
    if data.editmode.layouts and data.editmode.layouts.activeLayout then
      pcall(C_EditMode.SetActiveLayout, data.editmode.layouts.activeLayout)
    end
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
  if text:sub(1, #FORMAT) ~= FORMAT then return nil, "that's not a Z-Settings string" end
  local ok, data = pcall(function()
    return C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecompressString(C_EncodingUtil.DecodeBase64(text:sub(#FORMAT + 1))))
  end)
  if not ok or type(data) ~= "table" or data.format ~= 1 then return nil, "the string is damaged or incomplete" end
  return data
end

local function doImport(text, layout)
  if InCombatLockdown() then say("not in combat") return false end
  local data, err = decode(text)
  if not data then say(err) return false end
  local from = data.layout or "qwerty"
  if layout ~= "unknown" and from ~= "unknown" and from ~= layout then
    data.binds = convertBinds(data.binds or {}, from, layout)
    say(("keybinds converted from %s to %s"):format(LAYOUT_NAMES[from] or from, LAYOUT_NAMES[layout] or layout))
  end
  ZSettingsDB = ZSettingsDB or {}
  ZSettingsDB.undo = encode((capture(false)))
  local macros, tables, missing, addons = applyAll(data, false)
  say(("imported %s's setup (%s): %d macros, %d addon settings, %d addons switched."):format(
    data.by or "?", data.made or "?", macros, tables, addons))
  if #missing > 0 then say("settings for addons you don't have were skipped: " .. table.concat(missing, ", ")) end
  say("type /reload now to finish. /z undo puts back what you had.")
  return true
end

-- the window ----------------------------------------------------------------------------------

local function showWindow(mode, text)
  if not window then
    window = CreateFrame("Frame", "ZSettingsWindow", UIParent, "BackdropTemplate")
    window:SetSize(620, 420)
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")
    window:SetMovable(true)
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop", window.StopMovingOrSizing)
    window:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,
      insets = { left = 8, right = 8, top = 8, bottom = 8 } })
    window.title = window:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    window.title:SetPoint("TOP", 0, -16)
    window.hint = window:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    window.hint:SetPoint("TOP", window.title, "BOTTOM", 0, -6)
    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -6, -6)
    local scroll = CreateFrame("ScrollFrame", nil, window, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 20, -60)
    scroll:SetPoint("BOTTOMRIGHT", -40, 50)
    local box = CreateFrame("EditBox", nil, scroll)
    box:SetMultiLine(true)
    box:SetMaxLetters(0)
    box:SetFontObject(ChatFontNormal)
    box:SetWidth(540)
    box:SetAutoFocus(false)
    box:SetScript("OnEscapePressed", function() window:Hide() end)
    scroll:SetScrollChild(box)
    window.box = box
    window.action = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    window.action:SetSize(140, 24)
    window.action:SetPoint("BOTTOM", 0, 16)
    window.action:SetText("Import")
    window.action:SetScript("OnClick", function()
      local text = window.box:GetText()
      local ok, err = decode(text)
      if not ok then say(err) return end
      askLayout(function(layout)
        if doImport(text, layout) then window:Hide() end
      end)
    end)
  end
  window.box:SetText(text or "")
  if mode == "export" then
    window.title:SetText("Z-Settings: your setup")
    window.hint:SetText("Ctrl+C to copy, then send it to your friend")
    window.action:Hide()
    window:Show()
    window.box:SetFocus()
    window.box:HighlightText()
  else
    window.title:SetText("Z-Settings: import a setup")
    window.hint:SetText("Paste the string with Ctrl+V, then click Import")
    window.action:Show()
    window:Show()
    window.box:SetFocus()
  end
end

-- commands ------------------------------------------------------------------------------------

-- Z_BUNDLE is written into ZBundle.lua by the git commit hook: the setup that ships with the addon
local function bundle()
  local text = type(Z_BUNDLE) == "string" and Z_BUNDLE or nil
  return text and decode(text) and text or nil
end

SLASH_ZSETTINGS1 = "/z"
SlashCmdList.ZSETTINGS = function(msg)
  msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  if msg == "export" then
    if InCombatLockdown() then say("not in combat") return end
    local data, skipped = capture(true)
    showWindow("export", "")
    askLayout(function(layout)
      data.layout = layout
      local text = encode(data)
      ZSettingsDB = ZSettingsDB or {}
      ZSettingsDB.export, ZSettingsDB.exportMade = text, data.made   -- copied into ZBundle.lua by the commit hook
      showWindow("export", text)
      say(("your keyboard: %s. Friends on another layout get their keybinds converted."):format(LAYOUT_NAMES[layout] or "unknown"))
      if #skipped > 0 then say("not included (too large or not shareable): " .. table.concat(skipped, ", ")) end
      say("saved for publishing: /reload, then commit and push the AddOns folder")
    end)
  elseif msg == "import" then
    local text = bundle()
    if not text then showWindow("import") return end
    if InCombatLockdown() then say("not in combat") return end
    local data = decode(text)
    showWindow("import", "")
    window.title:SetText(("Z-Settings: importing %s's setup (%s)"):format(data.by or "?", data.made or "?"))
    window.action:Hide()
    askLayout(function(layout)
      if doImport(text, layout) then window:Hide() end
    end)
  elseif msg == "import paste" then
    showWindow("import")
  elseif msg == "undo" then
    if InCombatLockdown() then say("not in combat") return end
    local data = ZSettingsDB and ZSettingsDB.undo and decode(ZSettingsDB.undo)
    if not data then say("nothing to undo") return end
    applyAll(data, true)
    ZSettingsDB.undo = nil
    say("your setup from before the import is back. Type /reload now to finish.")
  else
    local b = bundle() and decode(bundle())
    say("/z import: apply " .. (b and ("the setup in this addon: %s's, %s"):format(b.by or "?", b.made or "?") or "a pasted setup string"))
    say("/z import paste: paste a string instead")
    say("/z undo: put back what you had before the last import")
    say("/z export: make a string of your own setup")
  end
end

-- keeps imported addon settings assigned while the game saves them at /reload or logout
local saver = CreateFrame("Frame")
saver:RegisterEvent("PLAYER_LOGOUT")
saver:SetScript("OnEvent", assignPending)
