local addonName, MSC = ...
local L = MSC.L

-- =============================================================
-- WHAT'S NEW POPUP
-- =============================================================
-- Shown once after each update (and on a fresh install), a few seconds after
-- login: a short rundown of the release plus the Discord invite. The last
-- version seen is stored per account in SGJ_Settings.LastSeenVersion.
-- Reopen any time with /sgj whatsnew.
--
-- Update WHATS_NEW for each release. forever = true lines only show on the
-- Forever client; classic = true lines only show on Era and TBC; era = true
-- lines only on Era (not Season of Discovery). Keep it
-- short: the full list lives in CHANGELOG.md.

local DISCORD_URL = "https://discord.gg/aYmhmtGxYs"

local WHATS_NEW = {
    -- v3.2.11
    { forever = true, text = "Recipes in DaylightUI's profession window now get the green upgrade arrow too." },
    { forever = true, text = "Enhancement Shaman leveling weights rebuilt: at levels 15-24 Spirit counts for a bit less, Intellect and Stamina for more." },
    { forever = true, text = "Enhancement Shaman levels 1-9: Intellect, Spirit and Stamina no longer jump about 6x at level 10." },
    { forever = true, text = "Talents plugin: the build glow, step numbers and panel now work in DaylightUI's talent window." },
    { forever = true, text = "Paladin solo leveling weights rebuilt with Hammer of Wrath from level 44. Retribution levels 1-9 no longer jump about 4x in Stamina and Spirit at level 10." },
    { forever = true, text = "Retribution levels 40-47: Mp5 no longer drops to 0, and Spirit counts for about twice as much." },
    { forever = true, text = "Paladin profile Holy: Solo Leveling is now named Shockadin: Solo Leveling. It's a melee and Holy Shock build, not a healing one." },
    { forever = true, text = "Talents plugin: Retribution and Retribution to Protection solo orders updated, and the Paladin % slower tags corrected." },
    { forever = true, text = "Talents plugin: Holy Paladin dungeon order adjusted slightly at levels 15-17." },
}

-- "3.1.0-Forever" -> "3.1.0", so every edition shares one "last seen" value.
local function BaseVersion(v)
    return (tostring(v or ""):gsub("%-%a+$", ""))
end

local function CurrentVersion()
    local GetMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    local v = (GetMetadata and GetMetadata(addonName, "Version")) or MSC.Version
    return BaseVersion(v)
end

local frame

local function BuildFrame()
    local f = CreateFrame("Frame", "SGJ_WhatsNewFrame", UIParent, "BackdropTemplate")
    f:SetWidth(470)
    f:SetPoint("CENTER", 0, 60)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true); f:SetMovable(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    tinsert(UISpecialFrames, "SGJ_WhatsNewFrame") -- Escape closes it

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -5, -5)

    f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    f.Title:SetPoint("TOP", 0, -20)

    local newHeader = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    newHeader:SetPoint("TOPLEFT", 26, -52)
    newHeader:SetText(L["What's new"])

    f.Notes = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.Notes:SetPoint("TOPLEFT", newHeader, "BOTTOMLEFT", 0, -8)
    f.Notes:SetWidth(418)
    f.Notes:SetJustifyH("LEFT")
    f.Notes:SetSpacing(3)

    local discordHeader = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    discordHeader:SetPoint("TOPLEFT", f.Notes, "BOTTOMLEFT", 0, -16)
    discordHeader:SetText(L["Discord"])

    local discordText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    discordText:SetPoint("TOPLEFT", discordHeader, "BOTTOMLEFT", 0, -6)
    discordText:SetWidth(418)
    discordText:SetJustifyH("LEFT")
    discordText:SetText(L["Join the Sharpie's Gear Judge Discord to request features, report bugs, and tell us when a stat weight feels off for your spec. Click the link and press Ctrl+C to copy it."])

    -- WoW can't open web links, so the invite sits in a box to copy from.
    local link = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    link:SetPoint("TOPLEFT", discordText, "BOTTOMLEFT", 6, -8)
    link:SetSize(300, 22)
    link:SetAutoFocus(false)
    link:SetText(DISCORD_URL)
    link:SetCursorPosition(0)
    link:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
    link:SetScript("OnMouseUp", function(self) self:SetFocus(); self:HighlightText() end)
    link:SetScript("OnTextChanged", function(self, userInput)
        if userInput then self:SetText(DISCORD_URL); self:HighlightText() end -- keep it read-only
    end)
    link:SetScript("OnEscapePressed", function(self) self:ClearFocus(); f:Hide() end)
    link:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

    local ok = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    ok:SetSize(110, 24)
    ok:SetPoint("BOTTOM", 0, 18)
    ok:SetText(L["Got it"])
    ok:SetScript("OnClick", function() f:Hide() end)

    f.Link = link
    f.Measure = function(self)
        -- Height follows the text so nothing is clipped at any font size.
        local h = 52 + newHeader:GetStringHeight() + 8 + self.Notes:GetStringHeight()
            + 16 + discordHeader:GetStringHeight() + 6 + discordText:GetStringHeight()
            + 8 + 22 + 18 + 24 + 22
        self:SetHeight(h)
    end
    return f
end

function MSC.ShowWhatsNew()
    if not frame then frame = BuildFrame() end
    local lines = {}
    for _, entry in ipairs(WHATS_NEW) do
        if (not entry.forever or MSC.IsForever) and (not entry.classic or not MSC.IsForever)
            and (not entry.era or (MSC.IsEra and not MSC.IsSoD)) then
            lines[#lines + 1] = "|cffffd100-|r " .. L[entry.text]
        end
    end
    -- A release can be all Forever-only lines; don't show an empty list elsewhere. An empty
    -- WHATS_NEW (a version still being worked on, opened with /sgj whatsnew) says nothing about Forever.
    if #lines == 0 then
        local text = (#WHATS_NEW == 0) and L["Small fixes and improvements."]
            or L["Fixes and improvements for WoW Forever; nothing changed for your game version."]
        lines[1] = "|cffffd100-|r " .. text
    end
    frame.Title:SetText(string.format(L["Sharpie's Gear Judge v%s"], CurrentVersion()))
    frame.Notes:SetText(table.concat(lines, "\n"))
    frame:Measure()
    frame:Show()
end

-- On login: show once per new version. Waits a few seconds so it doesn't land
-- in the middle of the loading screen, and waits out combat.
local watcher = CreateFrame("Frame")
watcher:RegisterEvent("PLAYER_LOGIN")
watcher:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")
        if type(SGJ_Settings) ~= "table" then return end
        local current = CurrentVersion()
        if current == "" or SGJ_Settings.LastSeenVersion == current then return end
        -- Nothing written yet for this version: don't pop up, and don't mark it seen, so it
        -- still opens once its list is filled in.
        if #WHATS_NEW == 0 then return end
        local function show()
            if InCombatLockdown and InCombatLockdown() then
                self:RegisterEvent("PLAYER_REGEN_ENABLED")
                return
            end
            SGJ_Settings.LastSeenVersion = current
            MSC.ShowWhatsNew()
        end
        self.Show = show
        if C_Timer and C_Timer.After then C_Timer.After(4, show) else show() end
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        if self.Show then self.Show() end
    end
end)
