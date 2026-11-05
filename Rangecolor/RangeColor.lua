--[[
    RangeColor
    Tints action bar icons red when the current target is out of range,
    instead of relying only on the small range indicator dot.

    Type /rangecolor (or /rc) in-game to open the settings panel and
    choose which action bars (1-8) the addon applies to.

    Works with Dominos too: its bars are found and listed in the settings
    panel as "Dominos bars" (each can be turned on or off).

    Default SavedVariables:
        RangeColorDB.color        = {1, 0.2, 0.2}  -- out-of-range tint (r,g,b)
        RangeColorDB.inRangeColor = {1, 1, 1}       -- normal tint (r,g,b)
        RangeColorDB.enabledBars  = { [1]=true, [2]=true, ... [8]=true }
        RangeColorDB.enabledDominosBars = { [n]=false for a Dominos bar turned off }
]]

RangeColorDB = RangeColorDB or {}
RangeColorDB.color = RangeColorDB.color or {1, 0.2, 0.2}
RangeColorDB.inRangeColor = RangeColorDB.inRangeColor or {1, 1, 1}

if RangeColorDB.enabledBars == nil then
    RangeColorDB.enabledBars = {}
    for i = 1, 8 do
        RangeColorDB.enabledBars[i] = true
    end
end

-- Dominos bars: on unless turned off (a bar Dominos adds later is on too)
if type(RangeColorDB.enabledDominosBars) ~= "table" then
    RangeColorDB.enabledDominosBars = {}
end

-- Maps bar number -> button name prefix.
local BAR_PREFIXES = {
    [1] = "ActionButton",
    [2] = "MultiBarBottomLeftButton",
    [3] = "MultiBarBottomRightButton",
    [4] = "MultiBarRightButton",
    [5] = "MultiBarLeftButton",
    [6] = "MultiBar5Button",
    [7] = "MultiBar6Button",
    [8] = "MultiBar7Button",
}

local hookedButtons = {} -- button -> bar number (Blizzard bars), or "dominos"

-- The action a button shows right now. Dominos keeps it in the button's
-- "action" attribute (it changes as the bar pages: stances, forms, bar 1
-- paging...); Blizzard's buttons keep it in button.action.
local function GetButtonAction(button)
    local attr = button.GetAttribute and button:GetAttribute("action")
    if type(attr) == "number" and attr > 0 then return attr end
    return button.action
end

-- Which Dominos bar a Dominos button is on (its parent is the bar, which has an id)
local function DominosBarOf(button)
    local bar = button.GetParent and button:GetParent()
    local id = bar and bar.id
    if type(id) == "number" then return id end
end

-- Toggle with "/rc debug". Prints what the addon sees for whichever button
-- your mouse is over, so range/resource issues can be diagnosed from chat
-- instead of guesswork.
local DEBUG = false

local function UpdateButtonRange(button, barNum)
    if not button then return end
    local action = GetButtonAction(button)
    if not action then return end

    local icon = button.icon or (button.GetName and _G[button:GetName() .. "Icon"])
    if not icon then return end

    -- Addon disabled for this bar: don't touch the icon color at all,
    -- so Blizzard's own out-of-resource graying still works normally.
    if barNum == "dominos" then
        local n = DominosBarOf(button)
        local off = RangeColorDB.enabledDominosBars -- (missing in settings saved before this version)
        if n and type(off) == "table" and off[n] == false then return end
    elseif not RangeColorDB.enabledBars[barNum] then
        return
    end

    -- Modern API (patch 12.0+, which WoW Forever's UI is built on) moved this to C_ActionBar.
    -- Falls back to the old global for older clients/private servers that still expose it.
    local HasActionFn = (C_ActionBar and C_ActionBar.HasAction) or HasAction
    local IsActionInRangeFn = (C_ActionBar and C_ActionBar.IsActionInRange) or IsActionInRange
    local IsUsableActionFn = (C_ActionBar and C_ActionBar.IsUsableAction) or IsUsableAction
    local GetActionInfoFn = (C_ActionBar and C_ActionBar.GetActionInfo) or GetActionInfo

    -- Items only: leave the icon completely alone and let Blizzard's own
    -- code handle it. IsUsableAction's second return ("notEnoughMana") only
    -- ever covers spell resource costs -- it's always false for items, even
    -- when you have zero of that item. That blind spot was letting this
    -- addon fall through to the range-tint logic below and forcibly
    -- SetVertexColor the icon back to white every ~0.1s, permanently
    -- stomping the gray-out Blizzard applies when you're out of the item.
    -- GetActionInfo is a cheap, unprotected read, so this is safe to call
    -- every OnUpdate tick (including in combat) without taint or errors.
    if GetActionInfoFn then
        local actionType = GetActionInfoFn(action)
        if actionType == "item" then
            return
        end
    end

    if not HasActionFn or not HasActionFn(action) then
        icon:SetVertexColor(1, 1, 1)
        return
    end

    -- Key off "notEnoughMana" specifically, not the general "isUsable" flag --
    -- isUsable can be false for reasons unrelated to resources (wrong
    -- stance/form, missing reagents, etc.), and treating those as "out of
    -- resource" would incorrectly gray out icons that should show red instead.
    local notEnoughResource = false
    if IsUsableActionFn then
        local _, notEnoughMana = IsUsableActionFn(action)
        notEnoughResource = notEnoughMana and true or false
    end

    -- Pass "target" explicitly rather than relying on a default -- on some
    -- clients omitting the unit silently returns nil (treated as "no range
    -- check applies") instead of actually checking against your target.
    local inRange = IsActionInRangeFn and IsActionInRangeFn(action, "target")
    -- inRange returns: true (in range), false (out of range), nil (no range check applies, e.g. buffs)

    if DEBUG and GetMouseFocus and GetMouseFocus() == button then
        print(string.format("|cff33ff99RangeColor|r %s action=%s notEnoughResource=%s inRange=%s",
            button:GetName() or "?", tostring(action), tostring(notEnoughResource), tostring(inRange)))
    end

    -- Priority: out of resource (gray) beats out of range (red) beats normal.
    if notEnoughResource then
        icon:SetVertexColor(0.4, 0.4, 0.4)
    elseif inRange == false then
        local c = RangeColorDB.color
        icon:SetVertexColor(c[1], c[2], c[3])
    else
        local c = RangeColorDB.inRangeColor
        icon:SetVertexColor(c[1], c[2], c[3])
    end
end

-- Blizzard's own action button code re-applies its own icon coloring for
-- usability on its own schedule (via events, not just OnUpdate), separate
-- from our OnUpdate poll below. If that runs after us, it can stomp our
-- color before it's ever seen. Hooking these (when present) makes sure our
-- logic always runs last and wins, regardless of what triggered the update.
local function ForceUpdate(self)
    local barNum = hookedButtons[self]
    if barNum then UpdateButtonRange(self, barNum) end
end

if type(ActionButton_UpdateUsable) == "function" then
    hooksecurefunc("ActionButton_UpdateUsable", ForceUpdate)
end
if type(ActionButton_UpdateRangeIndicator) == "function" then
    hooksecurefunc("ActionButton_UpdateRangeIndicator", ForceUpdate)
end

local function HookButton(button, barNum)
    if not button or hookedButtons[button] then return end
    hookedButtons[button] = barNum

    -- Newer game versions redraw a button's icon color with the button's own
    -- methods (not the old global functions above): run right after them too,
    -- so the red never flickers back to white between our updates.
    for _, method in ipairs({ "UpdateUsable", "UpdateRangeIndicator", "Update" }) do
        if type(button[method]) == "function" then
            hooksecurefunc(button, method, ForceUpdate)
        end
    end

    button:HookScript("OnUpdate", function(self, elapsed)
        self.rangeColorTimer = (self.rangeColorTimer or 0) + elapsed
        -- Throttle to ~10x/second; range checks are relatively cheap but no need to run every frame.
        if self.rangeColorTimer < 0.1 then return end
        self.rangeColorTimer = 0
        UpdateButtonRange(self, hookedButtons[self])
    end)
end

-- Dominos' action buttons: from Dominos' own list when it has one, or by name
-- (DominosActionButton1-168, and the Blizzard-style names it uses for some bars)
local DOMINOS_NAMES = {
    { "DominosActionButton", 168 },
    { "MultiBarRightActionButton", 12 },
    { "MultiBarLeftActionButton", 12 },
    { "MultiBarBottomRightActionButton", 12 },
    { "MultiBarBottomLeftActionButton", 12 },
    { "MultiBar5ActionButton", 12 },
    { "MultiBar6ActionButton", 12 },
    { "MultiBar7ActionButton", 12 },
}

local function ScanDominos()
    local D = _G.Dominos
    if type(D) ~= "table" then return end
    local list = D.ActionButtons
    if type(list) == "table" and type(list.GetAll) == "function" then
        for button in list:GetAll() do
            HookButton(button, "dominos")
        end
    end
    for _, n in ipairs(DOMINOS_NAMES) do
        for i = 1, n[2] do
            local button = _G[n[1] .. i]
            if button then HookButton(button, "dominos") end
        end
    end
end

local function ScanBars()
    for barNum, prefix in pairs(BAR_PREFIXES) do
        local i = 1
        while true do
            local button = _G[prefix .. i]
            if not button then break end
            HookButton(button, barNum)
            i = i + 1
        end
    end
    ScanDominos()
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("ACTIONBAR_UPDATE_STATE")
frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        ScanBars()
    end
end)

-- Re-scan periodically in case bars from other addons (Bartender, Dominos, etc.)
-- create buttons after login. Safe no-op once everything is hooked.
local rescanFrame = CreateFrame("Frame")
local elapsedTotal = 0
rescanFrame:SetScript("OnUpdate", function(self, elapsed)
    elapsedTotal = elapsedTotal + elapsed
    if elapsedTotal > 2 then
        elapsedTotal = 0
        ScanBars()
    end
end)

--------------------------------------------------------------------------
-- Options panel: registered into the Options > AddOns category list
-- alongside other addons, using the modern Settings API when available
-- and falling back to the older InterfaceOptions API otherwise.
--------------------------------------------------------------------------

local panel = CreateFrame("Frame", "RangeColorOptionsPanel", UIParent)
panel.name = "RangeColor"

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("RangeColor")

local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetJustifyH("LEFT")
subtitle:SetText("Active on these action bars:")

local checkboxes = {}
for i = 1, 8 do
    local cb = CreateFrame("CheckButton", "RangeColorBarCheck" .. i, panel, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 8, -12 - ((i - 1) * 26))
    cb.text = _G[cb:GetName() .. "Text"]
    cb.text:SetText("Action Bar " .. i)
    cb:SetChecked(RangeColorDB.enabledBars[i])
    cb:SetScript("OnClick", function(self)
        RangeColorDB.enabledBars[i] = self:GetChecked() and true or false
    end)
    checkboxes[i] = cb
end

-- Dominos bars (shown when Dominos is running): one checkbox per Dominos bar
local dominosTitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
dominosTitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 260, -8)
dominosTitle:SetJustifyH("LEFT")
dominosTitle:SetText("Dominos bars:")
dominosTitle:Hide()
local dominosChecks = {}
local MAX_DOMINOS_CHECKS = 14

local function DominosBarCount()
    local D = _G.Dominos
    if type(D) ~= "table" then return 0 end
    local ok, n = pcall(D.NumBars, D)
    if not ok or type(n) ~= "number" then return 0 end
    return math.min(n, MAX_DOMINOS_CHECKS)
end

local function UpdateDominosChecks()
    local count = DominosBarCount()
    dominosTitle:SetShown(count > 0)
    if count > 0 then
        subtitle:SetText("Blizzard bars (hidden by Dominos):")
    end
    for i = 1, count do
        local cb = dominosChecks[i]
        if not cb then
            cb = CreateFrame("CheckButton", "RangeColorDominosCheck" .. i, panel, "UICheckButtonTemplate")
            cb:SetPoint("TOPLEFT", dominosTitle, "BOTTOMLEFT", 8, -12 - ((i - 1) * 26))
            cb.text = _G[cb:GetName() .. "Text"]
            cb.text:SetText("Dominos Bar " .. i)
            cb:SetScript("OnClick", function(self)
                if type(RangeColorDB.enabledDominosBars) ~= "table" then RangeColorDB.enabledDominosBars = {} end
                RangeColorDB.enabledDominosBars[i] = self:GetChecked() and true or false
            end)
            dominosChecks[i] = cb
        end
        local off = RangeColorDB.enabledDominosBars
        cb:SetChecked(not (type(off) == "table" and off[i] == false))
        cb:Show()
    end
    for i = count + 1, #dominosChecks do dominosChecks[i]:Hide() end
end

panel:SetScript("OnShow", function()
    for i = 1, 8 do
        checkboxes[i]:SetChecked(RangeColorDB.enabledBars[i])
    end
    UpdateDominosChecks()
end)

if Settings and Settings.RegisterCanvasLayoutCategory then
    -- Modern Settings API (Dragonflight 10.0+ / mainline 12.x, which Forever's UI is built on).
    local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    category.ID = panel.name
    Settings.RegisterAddOnCategory(category)
    RangeColorSettingsCategoryID = panel.name
elseif InterfaceOptions_AddCategory then
    -- Legacy fallback for older clients.
    InterfaceOptions_AddCategory(panel)
end

SLASH_RANGECOLOR1 = "/rangecolor"
SLASH_RANGECOLOR2 = "/rc"
SlashCmdList["RANGECOLOR"] = function(msg)
    if msg and msg:lower():find("debug") then
        DEBUG = not DEBUG
        print("|cff33ff99RangeColor|r debug mode " .. (DEBUG and "ON - hover an action button to see its values." or "OFF"))
        return
    end

    if Settings and Settings.OpenToCategory and RangeColorSettingsCategoryID then
        -- Blizzard's API has a known quirk where the first call can fail to
        -- select the category on a freshly registered panel, so call twice.
        Settings.OpenToCategory(RangeColorSettingsCategoryID)
        Settings.OpenToCategory(RangeColorSettingsCategoryID)
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(panel)
        InterfaceOptionsFrame_OpenToCategory(panel)
    end
end