local addonName, MSC = ...
local L = MSC.L

-- =============================================================
-- BLIZZARD OPTIONS > ADDONS PANEL
-- =============================================================
-- A small launcher page in the game's own Options > AddOns list, for players
-- who don't know the slash commands or have hidden the minimap button.

local SETTINGS_TAB = 4 -- "Protocol" in the main window's tab list

local function CloseBlizzardOptions()
    if SettingsPanel and SettingsPanel:IsShown() then HideUIPanel(SettingsPanel) end
    if InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown() then HideUIPanel(InterfaceOptionsFrame) end
end

-- Opens the main window (if it isn't open) and optionally a tab.
function MSC.OpenMainWindow(tab)
    if not (MSC.MainFrame and MSC.MainFrame:IsShown()) and MSC.ToggleMainMenu then MSC.ToggleMainMenu() end
    if tab and MSC.SwitchTab then MSC.SwitchTab(tab) end
end

function MSC.OpenSettingsTab() MSC.OpenMainWindow(SETTINGS_TAB) end

local panel = CreateFrame("Frame")
panel.name = "Sharpie's Gear Judge"

local function Build(self)
    local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Sharpie's Gear Judge")

    local version = self:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    version:SetPoint("LEFT", title, "RIGHT", 10, -2)
    self.Version = version

    local desc = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    desc:SetWidth(560)
    desc:SetJustifyH("LEFT")
    desc:SetText(L["Scores gear with stat weights for your class, spec and level, and shows on every tooltip whether an item is an upgrade. Most settings live in the Gear Judge window."])

    local function Button(text, anchor, x, y, onClick)
        local b = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
        b:SetSize(180, 26)
        b:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", x, y)
        b:SetText(text)
        b:SetScript("OnClick", onClick)
        return b
    end

    local open = Button(L["Open Gear Judge"], desc, 0, -18, function() CloseBlizzardOptions(); MSC.OpenMainWindow() end)
    local settings = Button(L["Gear Judge Settings"], open, 0, -8, function() CloseBlizzardOptions(); MSC.OpenSettingsTab() end)
    local news = Button(L["What's New"], settings, 0, -8, function() CloseBlizzardOptions(); if MSC.ShowWhatsNew then MSC.ShowWhatsNew() end end)

    local minimap = CreateFrame("CheckButton", nil, self, "UICheckButtonTemplate")
    minimap:SetPoint("TOPLEFT", news, "BOTTOMLEFT", -4, -16)
    minimap.Label = minimap:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    minimap.Label:SetPoint("LEFT", minimap, "RIGHT", 4, 1)
    minimap.Label:SetText(L["Show minimap button"])
    minimap:SetScript("OnClick", function(cb)
        if type(SGJ_Settings) ~= "table" then return end
        SGJ_Settings.HideMinimap = not cb:GetChecked()
        if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
    end)
    self.Minimap = minimap

    local cmdHeader = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    cmdHeader:SetPoint("TOPLEFT", minimap, "BOTTOMLEFT", 4, -18)
    cmdHeader:SetText(L["Chat commands"])

    local cmds = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    cmds:SetPoint("TOPLEFT", cmdHeader, "BOTTOMLEFT", 0, -8)
    cmds:SetWidth(560)
    cmds:SetJustifyH("LEFT")
    cmds:SetSpacing(3)
    cmds:SetText(table.concat({
        "|cffffd100/sgj|r  " .. L["Open or close the Gear Judge window"],
        "|cffffd100/sgj options|r  " .. L["Open the settings page"],
        "|cffffd100/sgj whatsnew|r  " .. L["Show what changed in this version"],
        "|cffffd100/sgj import|r  " .. L["Import a Pawn or Sixty Upgrades weight string"],
    }, "\n"))
end

panel:SetScript("OnShow", function(self)
    if not self.Built then Build(self); self.Built = true end
    self.Version:SetText(MSC.Version and ("v" .. tostring(MSC.Version):gsub("%-%a+$", "")) or "")
    self.Minimap:SetChecked(not (type(SGJ_Settings) == "table" and SGJ_Settings.HideMinimap))
end)

-- Retail-style Settings API (Forever and current Classic clients), with the
-- old Interface Options call as a fallback.
if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
    local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(category)
    MSC.BlizzardSettingsCategory = category
elseif InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory(panel)
end
