local _G = getfenv(0)

local function SyncStyle(footer, parent)
    if not footer or not parent then return end
    
    -- Copy Backdrop
    if parent.GetBackdrop then
        footer:SetBackdrop(parent:GetBackdrop())
    end
    
    -- Copy Color
    if parent.GetBackdropColor then
        local r, g, b, a = parent:GetBackdropColor()
        footer:SetBackdropColor(r, g, b, a)
    end
    
    -- Copy Border
    if parent.GetBackdropBorderColor then
        local r, g, b, a = parent:GetBackdropBorderColor()
        footer:SetBackdropBorderColor(r, g, b, a)
    end
end

-- checkbox frame
local function CreateBiSToggleFrame()
    local parentFrame = _G["AtlasLoot_GUI-Frame"]
    if not parentFrame then return end
    
    -- Prevent duplicate
    if _G["AtlasLoot_BiS_Footer"] then return end

    -- Create Footer
    local footer = CreateFrame("Frame", "AtlasLoot_BiS_Footer", parentFrame, _G.BackdropTemplateMixin and "BackdropTemplate" or nil)
    footer:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 0, 0)
    footer:SetPoint("TOPRIGHT", parentFrame, "BOTTOMRIGHT", 0, 0)
    footer:SetHeight(24)
    
    -- Apply Style
    SyncStyle(footer, parentFrame)

    -- Create a container
    local centerGroup = CreateFrame("Frame", nil, footer)
    centerGroup:SetHeight(44)
    centerGroup:SetPoint("CENTER", 0, 5)

    -- 1. Create Checkbox (Show BiS)
    local check = CreateFrame("CheckButton", nil, centerGroup, "UICheckButtonTemplate")
    check:SetSize(20, 20)
    check:SetScale(1.5)
    check:SetPoint("BOTTOMLEFT", centerGroup, "BOTTOMLEFT", 0, 0)
    if _G.slcDB then
        check:SetChecked(_G.slcDB.showBiS == 1)
    end
    check:SetScript("OnClick", function(self)
        _G.slcDB.showBiS = self:GetChecked() and 1 or 0
    end)

    -- NEW: Dropdown for Phase selection (Inserted BETWEEN Checkbox and Text)
    local phaseDropdown = CreateFrame("Frame", "AtlasLoot_BiSPhaseDropdown", centerGroup, "UIDropDownMenuTemplate")
    -- Anchor to the right of the checkbox (-15 negates standard invisible padding, 0 keeps it flat)
    phaseDropdown:SetPoint("LEFT", check, "RIGHT", -15, 2)
    UIDropDownMenu_SetWidth(phaseDropdown, 80)
    
    local function OnPhaseSelect(self)
        if _G.slcDB then _G.slcDB.bisPhase = self.value end
        UIDropDownMenu_SetSelectedValue(AtlasLoot_BiSPhaseDropdown, self.value)
        --local colorStr = self.value == 3 and "|cFF00FF00Phase 3|r" or self.value == 2 and "|cFFFF8000Phase 2|r" or "|cFFFF0000Phase 1|r"
		local colorStr = self.value == 1 and "|cFF00FF00Phase 1|r" or self.value == 2 and "|cFFFF8000Phase 2|r" or "|cFFFF0000Phase 3|r"
		UIDropDownMenu_SetText(AtlasLoot_BiSPhaseDropdown, colorStr)
    end
    
    local function InitPhaseDropdown(self, level)
        local info = UIDropDownMenu_CreateInfo()
        info.text = "Phase 1"
        info.value = 1
        info.func = OnPhaseSelect
        info.checked = (_G.slcDB and _G.slcDB.bisPhase == 1)
        UIDropDownMenu_AddButton(info)
        
        info = UIDropDownMenu_CreateInfo()
        info.text = "Phase 2"
        info.value = 2
        info.func = OnPhaseSelect
        info.checked = (_G.slcDB and _G.slcDB.bisPhase == 2)
        UIDropDownMenu_AddButton(info)
		
		info.text = "Phase 3"
        info.value = 3
        info.func = OnPhaseSelect
        info.checked = (_G.slcDB and _G.slcDB.bisPhase == 3)
        UIDropDownMenu_AddButton(info)
    end
    
    UIDropDownMenu_Initialize(phaseDropdown, InitPhaseDropdown)
    if _G.slcDB then
        -- Default to Phase 1 for new users/updates
        if not _G.slcDB.bisPhase or _G.slcDB.bisPhase == 0 then _G.slcDB.bisPhase = 1 end 
        UIDropDownMenu_SetSelectedValue(phaseDropdown, _G.slcDB.bisPhase)
        --local initColorStr = _G.slcDB.bisPhase == 3 and "|cFF00FF00Phase 3|r" or _G.slcDB.bisPhase == 2 and "|cFFFF8000Phase 2|r" or "|cFFFF0000Phase 1|r"
		local initColorStr = _G.slcDB.bisPhase == 1 and "|cFF00FF00Phase 1|r" or _G.slcDB.bisPhase == 2 and "|cFFFF8000Phase 2|r" or "|cFFFF0000Phase 3|r"
		UIDropDownMenu_SetText(phaseDropdown, initColorStr)
    end

    -- 2. Text (Show BiS)
    local text = centerGroup:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    -- Anchor to the right of the Dropdown (-15 negates right-side padding, 0 keeps it flat)
    text:SetPoint("LEFT", phaseDropdown, "RIGHT", -15, 0)
    text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE") 
    text:SetText(" Show BiS Tooltips")
    text:SetTextColor(1, 0.82, 0)

    -- 3. Create Checkbox (Show only my Class)
    local classCheck = CreateFrame("CheckButton", nil, centerGroup, "UICheckButtonTemplate")
    classCheck:SetSize(20, 20)
    classCheck:SetScale(1.5)
    classCheck:SetPoint("LEFT", text, "RIGHT", 15, -1) -- 15px gap after first text
    if _G.slcDB then
        classCheck:SetChecked(_G.slcDB.showOnlyMyClass == 1)
    end
    classCheck:SetScript("OnClick", function(self)
        _G.slcDB.showOnlyMyClass = self:GetChecked() and 1 or 0
    end)

    -- 4. Text (Show only my Class)
    local classText = centerGroup:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    classText:SetPoint("LEFT", classCheck, "RIGHT", 2, 1)
    classText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    classText:SetText("My Class only")
    classText:SetTextColor(1, 0.82, 0)

    -- 5. Create Checkbox (Arena Point PvP Tab)
    local estimateCheck = CreateFrame("CheckButton", "AtlasLootArenaEstimateCheckbox", centerGroup, "UICheckButtonTemplate")
    estimateCheck:SetSize(20, 20)
    estimateCheck:SetScale(1.5)
    estimateCheck:SetPoint("LEFT", classText, "RIGHT", 15, -1)
    if _G.slcDB then
        -- Default to 1 (true) if the user has never set this before
        if _G.slcDB.showArenaEstimate == nil then
            _G.slcDB.showArenaEstimate = 1
        end
        estimateCheck:SetChecked(_G.slcDB.showArenaEstimate == 1)
    end
    estimateCheck:SetScript("OnClick", function(self)
        if _G.slcDB then
            _G.slcDB.showArenaEstimate = self:GetChecked() and 1 or 0
        end
    end)

    -- 6. Text (Show Arena Estimate)
    local estimateText = centerGroup:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    estimateText:SetPoint("LEFT", estimateCheck, "RIGHT", 2, 1)
    estimateText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    estimateText:SetText("Honor Calculator PvP Tab")
    estimateText:SetTextColor(1, 0.82, 0)

    -- ===== Replacement: Currency row (Honor, Arena, Badge + BG Marks) =====
    do
        local currencyFrame = CreateFrame("Frame", nil, centerGroup)
        currencyFrame:SetPoint("BOTTOM", centerGroup, "TOP", 10, -15) -- Anchored to top of checks
        currencyFrame:SetHeight(20)

        local iconSize = 18
        local gap = 8

        -- 1. Honor (currencyID 1901)
        local honorIcon = currencyFrame:CreateTexture(nil, "ARTWORK")
        honorIcon:SetSize(iconSize, iconSize)
        honorIcon:SetPoint("LEFT", currencyFrame, "LEFT", 0, 0)
        honorIcon:SetTexture("Interface\\AddOns\\AtlasLootClassic\\honoricon.tga")

        local honorText = currencyFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        honorText:SetPoint("LEFT", honorIcon, "RIGHT", 4, 0)
        honorText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        honorText:SetTextColor(1, 0.82, 0)

        -- 2. Arena Points (currencyID 1900)
        --local arenaIcon = currencyFrame:CreateTexture(nil, "ARTWORK")
        --arenaIcon:SetSize(iconSize, iconSize)
        --arenaIcon:SetPoint("LEFT", honorText, "RIGHT", gap, 0)
        --arenaIcon:SetTexture(4006481)

        --local arenaText = currencyFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        --arenaText:SetPoint("LEFT", arenaIcon, "RIGHT", 4, 0)
        --arenaText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        --arenaText:SetTextColor(1, 0.82, 0)

        -- 3. Badge of Justice (itemID 29434)
        --local badgeIcon = currencyFrame:CreateTexture(nil, "ARTWORK")
        --badgeIcon:SetSize(iconSize, iconSize)
        --badgeIcon:SetPoint("LEFT", arenaText, "RIGHT", gap, 0)

        --local badgeText = currencyFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        --badgeText:SetPoint("LEFT", badgeIcon, "RIGHT", 4, 0)
        --badgeText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        --badgeText:SetTextColor(1, 0.82, 0)

        -- 4. Alterac Valley Mark (itemID 20560)
        local avIcon = currencyFrame:CreateTexture(nil, "ARTWORK")
        avIcon:SetSize(iconSize, iconSize)
        local avText = currencyFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        avText:SetPoint("LEFT", avIcon, "RIGHT", 4, 0)
        avText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        avText:SetTextColor(1, 0.82, 0)

        -- 5. Warsong Gulch Mark (itemID 20558)
        local wsIcon = currencyFrame:CreateTexture(nil, "ARTWORK")
        wsIcon:SetSize(iconSize, iconSize)
        local wsText = currencyFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        wsText:SetPoint("LEFT", wsIcon, "RIGHT", 4, 0)
        wsText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        wsText:SetTextColor(1, 0.82, 0)

        -- 6. Arathi Basin Mark (itemID 20559)
        local abIcon = currencyFrame:CreateTexture(nil, "ARTWORK")
        abIcon:SetSize(iconSize, iconSize)
        local abText = currencyFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        abText:SetPoint("LEFT", abIcon, "RIGHT", 4, 0)
        abText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        abText:SetTextColor(1, 0.82, 0)

        -- 7. Eye of the Storm Mark (itemID 29024)
        local eyeIcon = currencyFrame:CreateTexture(nil, "ARTWORK")
        eyeIcon:SetSize(iconSize, iconSize)
        local eyeText = currencyFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        eyeText:SetPoint("LEFT", eyeIcon, "RIGHT", 4, 0)
        eyeText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        eyeText:SetTextColor(1, 0.82, 0)


        -- Helper function to calculate ap (not needed for now but lets keep it, in case they add arena or some shit)
        local function GetProjectedArenaPoints()
            local maxPoints = 0
            for i = 1, 3 do
                local rating = 0
                local played = 0
                
                -- modern API
                if GetPersonalRatedInfo then
                    local r, _, _, _, _, wp = GetPersonalRatedInfo(i)
                    if r then
                        rating = tonumber(r) or 0
                        played = tonumber(wp) or 0
                    end
                end
                
                -- Fallback to old API
                if rating == 0 and GetArenaTeam then
                    local _, _, tRating, tPlayed = GetArenaTeam(i)
                    if tRating then
                        rating = tonumber(tRating) or 0
                        played = tonumber(tPlayed) or 0
                    end
                end

                if rating > 0 and played >= 10 then
                    local p = ((1651.94 - 475) / (1 + 2500000 * math.pow(2.71828, -0.009 * rating)) + 475) * 1.5
                    
                    local multiplier = 1.0
                    if i == 1 then multiplier = 0.76      -- 2v2
                    elseif i == 2 then multiplier = 0.88  -- 3v3
                    end
                    
                    local points = math.floor(p * multiplier + 0.5)
                    if points > maxPoints then
                        maxPoints = points
                    end
                end
            end
            return maxPoints
        end


        -- Update function
        local function UpdateCurrencyDisplay()
            -- 1. Honor
            local honorAmount = 0
            if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
                local info = C_CurrencyInfo.GetCurrencyInfo(1792) or C_CurrencyInfo.GetCurrencyInfo(1901)
                if info then honorAmount = info.quantity or info.totalEarned or 0 end
            end
            honorText:SetText("Honor: " .. honorAmount)

            -- 2. Arena
            --local arenaAmount = 0
            --if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
            --    local info = C_CurrencyInfo.GetCurrencyInfo(1900)
            --    if info then arenaAmount = info.quantity or info.totalEarned or 0 end
            --end
            
            -- Display logic for current + projected points
            --local projectedPoints = GetProjectedArenaPoints()
            --if projectedPoints > 0 then
            --    -- Hex |cff55FF55 light green
            --    arenaText:SetText(string.format("Arena: %s (+|cff55FF55%s next week|r)", arenaAmount, projectedPoints))
            --else
            --    arenaText:SetText("Arena: " .. arenaAmount)
            --end

            -- 3. Badges (Static)
            --local badgeCount = (GetItemCount and GetItemCount(29434, false)) or 0
            --badgeText:SetText("Badges: " .. badgeCount)
            --if GetItemIcon then
            --    badgeIcon:SetTexture(GetItemIcon(29434))
            --end

            -- (OLD, if we renable arena or badges or any other new currency, we need to change this again)Start calculating width from the static elements
            --local totalWidth = 0
            --totalWidth = totalWidth + iconSize + 4 + honorText:GetStringWidth()
            --totalWidth = totalWidth + gap + iconSize + 4 + arenaText:GetStringWidth()
            --totalWidth = totalWidth + gap + iconSize + 4 + badgeText:GetStringWidth()

            -- Anchor chain tracking
            --local lastAnchor = badgeText
			
			--NEW:
			local totalWidth = iconSize + 4 + honorText:GetStringWidth()
			local lastAnchor = honorText

            -- Helper for Conditional BG Marks
            local function UpdateDynamicMark(itemId, icon, text)
                local count = (GetItemCount and GetItemCount(itemId, false)) or 0
                if count > 0 then
                    icon:Show()
                    text:Show()
                    text:SetText(count) -- Number only, no label
                    if GetItemIcon then
                        icon:SetTexture(GetItemIcon(itemId))
                    end
                    
                    -- Dynamic Anchor
                    icon:ClearAllPoints()
                    icon:SetPoint("LEFT", lastAnchor, "RIGHT", gap, 0)
                    
                    -- Update tracking
                    totalWidth = totalWidth + gap + iconSize + 4 + text:GetStringWidth()
                    lastAnchor = text
                else
                    icon:Hide()
                    text:Hide()
                end
            end

            -- Process BG Marks in order
            UpdateDynamicMark(20560, avIcon, avText)   -- Alterac
            UpdateDynamicMark(20558, wsIcon, wsText)   -- Warsong
            UpdateDynamicMark(20559, abIcon, abText)   -- Arathi
            UpdateDynamicMark(29024, eyeIcon, eyeText) -- Eye

            currencyFrame:SetWidth(totalWidth)
        end

        local updater = CreateFrame("Frame", nil, currencyFrame)
        updater:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
        updater:RegisterEvent("BAG_UPDATE")
        -- Listen for the server returning new PvP data to prevent ghost data caching
        --no arena points in forever(YET LOL)
		--updater:RegisterEvent("ARENA_TEAM_UPDATE")
        pcall(function() updater:RegisterEvent("PVP_RATED_STATS_UPDATE") end)
        
        updater:SetScript("OnEvent", UpdateCurrencyDisplay)
        
        -- Force UI update when the frame is shown
        currencyFrame:SetScript("OnShow", function()
            if RequestPVPRewards then pcall(RequestPVPRewards) end
            if RequestRatedInfo then pcall(RequestRatedInfo) end
            UpdateCurrencyDisplay()
        end)
        
        -- Automatically fetch this character's true data the second you log in
        -- This forces the API to wipe the previous character's cached ghost data
        local loginFetcher = CreateFrame("Frame")
        loginFetcher:RegisterEvent("PLAYER_ENTERING_WORLD")
        loginFetcher:SetScript("OnEvent", function(self)
            if RequestPVPRewards then pcall(RequestPVPRewards) end
            if RequestRatedInfo then pcall(RequestRatedInfo) end
            self:UnregisterAllEvents()
        end)

        UpdateCurrencyDisplay()
    end

    -- Recalculate Total Width to keep group centered (Now including the 3rd checkbox)
    local width1 = (20 * 1.5) + 2 + text:GetStringWidth() + 110 -- Added 110 for Dropdown Menu
    local width2 = 15 + (20 * 1.5) + 2 + classText:GetStringWidth()
    local width3 = 15 + (20 * 1.5) + 2 + estimateText:GetStringWidth()
    centerGroup:SetWidth(width1 + width2 + width3)
end

-- Hook into AtlasLoot loading
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
    if _G.AtlasLoot and _G.AtlasLoot.GUI then
        hooksecurefunc(_G.AtlasLoot.GUI, "Create", CreateBiSToggleFrame)
        hooksecurefunc(_G.AtlasLoot.GUI, "RefreshMainFrame", function()
            local footer = _G["AtlasLoot_BiS_Footer"]
            local parent = _G["AtlasLoot_GUI-Frame"]
            if footer and parent then
                SyncStyle(footer, parent)
            end
        end)
        if _G["AtlasLoot_GUI-Frame"] then
            CreateBiSToggleFrame()
        end
    end
end)



-- PVP Frame Enhancements (Custom Side Panel via OnUpdate)

local arenaIconString = "\124T4006481:14:14:0:-4\124t"
local greenColor = "|cff54ff54"
local bracketNames = { "work", "in", "progress" }
local bracketMultipliers = { 0.76, 0.88, 1.00 }
local panelCreated = false

-- Math Helper Function
local function CalculateArenaPoints(rating, bracketIndex)
    if not rating or rating < 0 then return 0 end
    if rating > 0 then
        local p = ((1651.94 - 475) / (1 + 2500000 * math.pow(2.71828, -0.009 * rating)) + 475) * 1.5
        local mult = bracketMultipliers[bracketIndex] or 1.0
        return math.floor(p * mult + 0.5)
    end
    return 0
end

local function CreatePVPTrackerPanel()
    if panelCreated or not _G.PVPFrame then return end

    -- 1. Main Frame
    local panel = CreateFrame("Frame", "AtlasLootPVPSidePanel", _G.PVPFrame, _G.BackdropTemplateMixin and "BackdropTemplate" or nil)
    panel:SetWidth(230)
    
    -- The Character Frame right edge is offset by -32 pixels
    panel:SetPoint("TOPLEFT", _G.PVPFrame, "TOPRIGHT", -32, -12)
    panel:SetPoint("BOTTOMLEFT", _G.PVPFrame, "BOTTOMRIGHT", -32, 72)
    panel:SetFrameStrata("HIGH") -- Ensure it sits above the default UI borders

    if _G.slcDB and _G.slcDB.improveContrast == nil then
        _G.slcDB.improveContrast = 1
    end

    local function ApplyPanelBackdrop()
        if _G.slcDB and _G.slcDB.improveContrast == 1 then
            panel:SetBackdrop({
                edgeFile = "Interface\\AddOns\\AtlasLootClassic\\border.tga",
                tile = false, tileSize = 0, edgeSize = 16,
                insets = { left = 4, right = 4, top = 4, bottom = 4 }
            })

            if not panel.bgTexture then
                panel.bgTexture = panel:CreateTexture(nil, "BACKGROUND")
                panel.bgTexture:SetAllPoints(panel)
                panel.bgTexture:SetColorTexture(0, 0, 0, 0.9)
            end
            panel.bgTexture:Show()
        else
            panel:SetBackdrop({
                bgFile = "Interface\\AddOns\\AtlasLootClassic\\black.tga",
                edgeFile = "Interface\\AddOns\\AtlasLootClassic\\border.tga",
                tile = false, tileSize = 0, edgeSize = 16,
                insets = { left = 4, right = 4, top = 4, bottom = 4 }
            })
            if panel.bgTexture then
                panel.bgTexture:Hide()
            end
        end
    end

    ApplyPanelBackdrop()

    -- 2. Header
    local headerText = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    headerText:SetPoint("TOP", panel, "TOP", 15, -15) -- Shifted slightly because fucked icon
    headerText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    headerText:SetTextColor(1, 0.82, 0)
    headerText:SetText("AtlasLoot Classic Forever")

    local headerIcon = panel:CreateTexture(nil, "OVERLAY")
    headerIcon:SetSize(24, 24) -- Maybe adjust
    headerIcon:SetPoint("RIGHT", headerText, "LEFT", -5, 0)
    headerIcon:SetTexture("Interface\\AddOns\\AtlasLootClassic\\atlas_tga.tga")

    -- Helper to create text blocks with consistent styling and linebreaks
    local function CreateStatBlock(parent, yOffset)
        local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fs:SetPoint("TOPLEFT", parent, "TOPLEFT", 15, yOffset)
        fs:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        fs:SetTextColor(1, 0.82, 0)
        fs:SetJustifyH("LEFT")
        fs:SetSpacing(4)
        return fs
    end

    -- 3. Stat Strings (Adjusted Y offsets to fit the linebreaks)
    panel.currentPointsStr = CreateStatBlock(panel, -45)
    panel.highestWeekStr   = CreateStatBlock(panel, -85)
    panel.totalNextStr     = CreateStatBlock(panel, -125)
    
    panel.bracket2v2Str    = CreateStatBlock(panel, -175)
    panel.bracket3v3Str    = CreateStatBlock(panel, -215)
    panel.bracket5v5Str    = CreateStatBlock(panel, -255)

    -- 4. Point Calculator Section
    local calcLabel = CreateStatBlock(panel, -305)
    calcLabel:SetText(arenaIconString .. " Point Calculator:")

    -- Rating Input Box
    local calcInput = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    calcInput:SetSize(50, 20)
    calcInput:SetPoint("TOPLEFT", calcLabel, "BOTTOMLEFT", 5, -10)
    calcInput:SetAutoFocus(false)
    calcInput:SetNumeric(true)
    calcInput:SetMaxLetters(4)

    -- Bracket Dropdown
    local calcDropdown = CreateFrame("Frame", "AtlasLootPVPCalcDropdown", panel, "UIDropDownMenuTemplate")
    calcDropdown:SetPoint("LEFT", calcInput, "RIGHT", -15, -2)
    UIDropDownMenu_SetWidth(calcDropdown, 50)
    UIDropDownMenu_SetText(calcDropdown, "work") --default text shown in manual calcultor drop down menu
    
    -- Result Output String
    local calcResult = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    calcResult:SetPoint("LEFT", calcDropdown, "RIGHT", -5, 2)
    calcResult:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    calcResult:SetTextColor(1, 0.82, 0)
    calcResult:SetText(greenColor .. "0|r")

    -- Include Current Points Checkbox
    local includeCurrentCheck = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    includeCurrentCheck:SetSize(24, 24)
    includeCurrentCheck:SetPoint("TOPLEFT", calcInput, "BOTTOMLEFT", -5, -5)
    
    local includeCurrentText = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    includeCurrentText:SetPoint("LEFT", includeCurrentCheck, "RIGHT", 2, 0)
    includeCurrentText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE") -- slightly smaller font for multi-line
    includeCurrentText:SetTextColor(1, 0.82, 0)
    includeCurrentText:SetJustifyH("LEFT")
    includeCurrentText:SetText("Include my current\nPoints in result")
    
    local selectedCalcBracket = 3 -- Default to 5v5

    local function UpdateCalculator()
        local rating = tonumber(calcInput:GetText()) or 0
        local points = CalculateArenaPoints(rating, selectedCalcBracket)
        
        -- Add current points if checkbox is checked
        if includeCurrentCheck:GetChecked() then
            local currentArenaPoints = 0
            if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
                local info = C_CurrencyInfo.GetCurrencyInfo(1900)
                if info then currentArenaPoints = info.quantity or info.totalEarned or 0 end
            end
            points = points + currentArenaPoints
        end
        
        calcResult:SetText(greenColor .. points .. "|r")
    end

    calcInput:SetScript("OnTextChanged", UpdateCalculator)
    includeCurrentCheck:SetScript("OnClick", UpdateCalculator)

    local function OnDropdownSelect(self)
        selectedCalcBracket = self.value
        UIDropDownMenu_SetSelectedValue(calcDropdown, self.value)
        UIDropDownMenu_SetText(calcDropdown, bracketNames[self.value])
        UpdateCalculator()
    end

    local function InitializeDropdown(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for i = 1, 3 do
            info.text = bracketNames[i]
            info.value = i
            info.func = OnDropdownSelect
            info.checked = (i == selectedCalcBracket)
            UIDropDownMenu_AddButton(info)
        end
    end
    UIDropDownMenu_Initialize(calcDropdown, InitializeDropdown)

    -- 5. Hide Checkbox (Bottom)
    local hideCheck = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    hideCheck:SetSize(24, 24)
    hideCheck:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 5, 15)
    
    local hideText = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    hideText:SetPoint("LEFT", hideCheck, "RIGHT", -3, 0)
    hideText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    hideText:SetTextColor(1, 0.82, 0)
    hideText:SetText("Hide\nFrame")

    -- 6. Improve Contrast Checkbox
    local contrastCheck = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    contrastCheck:SetSize(24, 24)
    contrastCheck:SetPoint("LEFT", hideText, "RIGHT", -3, 0)

    local contrastText = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    contrastText:SetPoint("LEFT", contrastCheck, "RIGHT", -5, 0)
    contrastText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    contrastText:SetTextColor(1, 0.82, 0)
    contrastText:SetText("Improve\nContrast")
    
    if _G.slcDB then
        hideCheck:SetChecked(_G.slcDB.showArenaEstimate == 0)
        contrastCheck:SetChecked(_G.slcDB.improveContrast == 1)
    end
    
    hideCheck:SetScript("OnClick", function(self)
		if _G.slcDB then
			_G.slcDB.showArenaEstimate = self:GetChecked() and 0 or 1
		end
		-- Sync the AtlasLoot GUI checkbox
		if _G.AtlasLootArenaEstimateCheckbox then
			_G.AtlasLootArenaEstimateCheckbox:SetChecked(not self:GetChecked())
		end
		panel:Hide()
	end)

    contrastCheck:SetScript("OnClick", function(self)
        if _G.slcDB then
            _G.slcDB.improveContrast = self:GetChecked() and 1 or 0
        end
        ApplyPanelBackdrop()
    end)
	
    -- Update Function for all stats
    panel.UpdateStats = function()
        -- Ensure checkbox matches DB state
        if _G.slcDB then
            hideCheck:SetChecked(_G.slcDB.showArenaEstimate == 0)
        end

        -- Current Points
        local currentArenaPoints = 0
        if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
            local info = C_CurrencyInfo.GetCurrencyInfo(1900)
            if info then currentArenaPoints = info.quantity or info.totalEarned or 0 end
        end
        panel.currentPointsStr:SetText(arenaIconString .. " Current Honor:\n" .. greenColor .. currentArenaPoints .. "|r")

        -- Fetch Bracket Stats
        local highestPoints = 0
        local highestBracketStr = ""
        local bracketPts = {0, 0, 0}
        local bracketPlayed = {0, 0, 0}
        local maxPlayedAll = 0

        for i = 1, 3 do
            local rating, played = 0, 0
            
            -- modern API
            if GetPersonalRatedInfo then
                local r, _, _, _, _, wp = GetPersonalRatedInfo(i)
                if r then
                    rating = tonumber(r) or 0
                    played = tonumber(wp) or 0
                end
            end
            
            -- Fallback to old API
            if rating == 0 and GetArenaTeam then
                local _, _, tRating, tPlayed = GetArenaTeam(i)
                if tRating then
                    rating = tonumber(tRating) or 0
                    played = tonumber(tPlayed) or 0
                end
            end

            bracketPlayed[i] = played
            if played > maxPlayedAll then
                maxPlayedAll = played
            end

            -- Only eligible if 10 or more games are played
            if rating > 0 and played >= 10 then
                bracketPts[i] = CalculateArenaPoints(rating, i)
                if bracketPts[i] > highestPoints then
                    highestPoints = bracketPts[i]
                    highestBracketStr = bracketNames[i]
                end
            end
        end

        -- Formatter for 2v2, 3v3, 5v5 labels
        local function GetBracketText(idx, name)
            if bracketPlayed[idx] < 10 then
                return name .. ":\n|cffff0000" .. bracketPlayed[idx] .. "Work in Progress!|r"
            else
                return name .. ":\n" .. greenColor .. bracketPts[idx] .. "|r"
            end
        end

        -- Update Bracket Strings
        panel.bracket2v2Str:SetText(GetBracketText(1, "Warsong"))
        panel.bracket3v3Str:SetText(GetBracketText(2, "Arathi"))
        panel.bracket5v5Str:SetText(GetBracketText(3, "Alterac"))

        -- Highest & Total Strings
        if highestPoints > 0 then
            panel.highestWeekStr:SetText(arenaIconString .. " Highest this Week:\n" .. greenColor .. highestPoints .. "|r (" .. highestBracketStr .. ")")
            local total = currentArenaPoints + highestPoints
            local overcapStr = ""
            if total > 5000 then
                overcapStr = " (|cff00ccff" .. (total - 5000) .. " overcapped|r)"
                total = 5000
            end
            panel.totalNextStr:SetText(arenaIconString .. " Rank Next Week:\n" .. greenColor .. total .. "|r" .. overcapStr)
        else
            panel.highestWeekStr:SetText(arenaIconString .. " Highest this Week:\n|cffff0000" .. maxPlayedAll .. "Work in Progress!|r")
            panel.totalNextStr:SetText(arenaIconString .. " Rank Next Week:\n" .. greenColor .. currentArenaPoints .. "|r")
        end
    end

    panelCreated = true
end

-- Master OnUpdate Loop (Handles Initialization & Updates)

local pvpUpdateFrame = CreateFrame("Frame")
local pvpElapsed = 0

pvpUpdateFrame:SetScript("OnUpdate", function(self, dt)
    -- 1. Catch the exact moment PVPFrame is created by the game
    if _G.PVPFrame and not panelCreated then
        CreatePVPTrackerPanel()
    end

    -- 2. Once created, update data every 0.5 seconds while the frame is visible
    pvpElapsed = pvpElapsed + dt
    if pvpElapsed >= 0.5 then
        pvpElapsed = 0
        
        if panelCreated and _G.PVPFrame and _G.PVPFrame:IsShown() then
            -- Check user settings
            local showPvpEstimate = true
            if _G.slcDB and _G.slcDB.showArenaEstimate == 0 then
                showPvpEstimate = false
            end
            
            -- Show/Update or Hide panel dynamically
            if showPvpEstimate then
                if not _G.AtlasLootPVPSidePanel:IsShown() then
                    _G.AtlasLootPVPSidePanel:Show()
                end
                
                -- Silently ask server to refresh personal rating data
                if RequestPVPRewards then pcall(RequestPVPRewards) end
                if RequestRatedInfo then pcall(RequestRatedInfo) end
                
                _G.AtlasLootPVPSidePanel.UpdateStats()
            else
                if _G.AtlasLootPVPSidePanel:IsShown() then
                    _G.AtlasLootPVPSidePanel:Hide()
                end
            end
        end
    end
end)

-- Progress Prediction System

local progInitFrame = CreateFrame("Frame")

progInitFrame:SetScript("OnUpdate", function(self)
    local panel = _G.AtlasLootPVPSidePanel
    -- Wait until the panel is created by the previous code block
    if panel and not panel.progInjected then
        panel.progInjected = true
        
        -- Custom icon string just for dropdowns (+5 change l8er)
        local ddIconString = "\124T4006481:14:14:0:0\124t"
        
        -- Items Database
        local items = {
            { name = "1h Weapon", cost = 2175 },
            { name = "1h Caster", cost = 2610 },
            { name = "2h Weapon", cost = 3110 },
            { name = "Ranged", cost = 830 },
            { name = "Offhand", cost = 930 },
            { name = "Relic", cost = 830 },
            { name = "Shield", cost = 1550 },
            { name = "Gloves", cost = 930 },
            { name = "Head", cost = 1550 },
            { name = "Legs", cost = 1550 },
            { name = "Shoulders", cost = 1245 },
            { name = "Chest", cost = 1550 },
            { name = "- None -", cost = 0 }
        }

        -- Find the local inputs from the parent frame
        local editBox, includeCheck
        for _, child in ipairs({panel:GetChildren()}) do
            if child:GetObjectType() == "EditBox" then
                editBox = child
            elseif child:GetObjectType() == "CheckButton" then
                local pt = child:GetPoint(1)
				-- take current points into consideration for prediction, dont fuck this up again lol
                if pt == "TOPLEFT" then
                    includeCheck = child
                end
            end
        end

        -- Toggle Button
        local progBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
        progBtn:SetSize(75, 32)
        progBtn:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -10, 10)
        
        local btnText = progBtn:GetFontString()
        btnText:SetWordWrap(true)
        btnText:SetJustifyH("CENTER")
        btnText:SetSpacing(2)
        progBtn:SetText("Show Honor\nPrediction")

        panel:SetClipsChildren(true)

        -- Progress Container
        local progFrame = CreateFrame("Frame", nil, panel)
        progFrame:SetPoint("TOPLEFT", panel, "TOPLEFT", 230, 0)
        progFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0)
        progFrame:Show()

        -- Top Text
        local topText = progFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        topText:SetPoint("TOP", progFrame, "TOP", 0, -38)
        topText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        topText:SetTextColor(1, 0.82, 0)
        topText:SetJustifyH("CENTER")
        topText:SetText("Use Point Calculator\nto run prediction")
        topText:SetAlpha(0) -- Starts invisible

        -- Meth Helper
        local function GetWeeklyIncome()
            local rating = tonumber(editBox and editBox:GetText()) or 0
            local bracketIdx = UIDropDownMenu_GetSelectedValue(_G.AtlasLootPVPCalcDropdown) or 3
            if rating > 0 then
                local p = ((1651.94 - 475) / (1 + 2500000 * math.pow(2.71828, -0.009 * rating)) + 475) * 1.5
                local mults = {0.76, 0.88, 1.00}
                return math.floor(p * (mults[bracketIdx] or 1.0) + 0.5)
            end
            return 0
        end

        local function GetCurrentPoints()
            if includeCheck and includeCheck:GetChecked() then
                if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
                    local info = C_CurrencyInfo.GetCurrencyInfo(1900)
                    return info and (info.quantity or info.totalEarned) or 0
                end
            end
            return 0
        end

        -- Updated Color Thresholds
        local function GetColorCode(totalWeeks)
            if totalWeeks <= 3 then return "|cff54ff54" end -- Light Green (1-3)
            if totalWeeks <= 6 then return "|cffffff00" end -- Yellow (4-6)
            if totalWeeks <= 8 then return "|cffffa500" end -- Orange (7-8)
            return "|cffff0000" -- Red (>8)
        end

        -- Create Dropdowns
        local dropdowns = {}
        local results = {}
        local selections = {}

        for i = 1, 12 do
            local dd = CreateFrame("Frame", "AtlasLootPVPProgDD"..i, progFrame, "UIDropDownMenuTemplate")
            dd:SetPoint("TOPLEFT", progFrame, "TOPLEFT", -10, -50 - (i * 24))
            UIDropDownMenu_SetWidth(dd, 130)
            UIDropDownMenu_SetText(dd, "Select Item...")

            local res = progFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            res:SetPoint("LEFT", dd, "RIGHT", -10, 2)
            res:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
            
            dropdowns[i] = dd
            results[i] = res
            selections[i] = 13 -- Default to None
            
            local function InitDD(self, level)
                for j, item in ipairs(items) do
                    local info = UIDropDownMenu_CreateInfo()
                    local t = item.name
                    if item.cost > 0 then
                        t = t .. "  " .. ddIconString .. item.cost
                    end
                    info.text = t
                    info.value = j
                    info.func = function(btn)
                        selections[i] = btn.value
                        UIDropDownMenu_SetSelectedValue(dd, btn.value)
                        UIDropDownMenu_SetText(dd, info.text)
                    end
                    info.checked = (selections[i] == j)
                    UIDropDownMenu_AddButton(info)
                end
            end
            UIDropDownMenu_Initialize(dd, InitDD)
        end

        -- Continuous update loop for cumulative calculations
        local updateTimer = 0
        progFrame:SetScript("OnUpdate", function(self, dt)
            updateTimer = updateTimer + dt
            if updateTimer > 0.2 then
                updateTimer = 0
                
                local weeklyIncome = GetWeeklyIncome()
                local currentBank = GetCurrentPoints()
                local totalWeeksPassed = 0
                local showNext = true
                
                for i = 1, 12 do
                    if showNext then
                        dropdowns[i]:Show()
                        local sel = selections[i]
                        
                        -- If a valid item is picked
                        if sel and sel > 0 and sel < 13 then
                            showNext = true
                            results[i]:Show()
                            
                            local cost = items[sel].cost
                            local canAffordNever = false
                            
                            if currentBank >= cost then
                                -- Buy instantly with available bank points (No weeks added to total)
                                currentBank = currentBank - cost
                            else
                                local needed = cost - currentBank
                                if weeklyIncome <= 0 then
                                    canAffordNever = true
                                else
                                    local weeksForThis = math.ceil(needed / weeklyIncome)
                                    totalWeeksPassed = totalWeeksPassed + weeksForThis
                                    -- Add the points generated over those weeks, minus the cost of this item
                                    currentBank = currentBank + (weeksForThis * weeklyIncome) - cost
                                end
                            end
                            
                            if canAffordNever then
                                results[i]:SetText("|cffff0000Never|r")
                            else
                                if totalWeeksPassed == 0 then
                                    results[i]:SetText("|cff54ff54This week|r")
                                else
                                    local color = GetColorCode(totalWeeksPassed)
                                    local weekStr = totalWeeksPassed == 1 and " Week" or " Weeks"
                                    results[i]:SetText(color .. "+" .. totalWeeksPassed .. weekStr .. "|r")
                                end
                            end
                        else
                            showNext = false
                            results[i]:Hide()
                        end
                    else
                        dropdowns[i]:Hide()
                        results[i]:Hide()
                    end
                end
            end
        end)

        -- Animation Logic (Width Expansion + Text Fade-in)
        local isExpanded = false
        local isAnimating = false
        local isFading = false
        local animTime = 0
        local fadeTime = 0
        local startW, targetW = 230, 230
        local baseW, extW = 230, 480
        
        progBtn:SetScript("OnClick", function()
            isExpanded = not isExpanded
            if isExpanded then
                progBtn:SetText("Hide\nPrediction")
                targetW = extW
            else
                progBtn:SetText("Show Honor\nPrediction")
                targetW = baseW
                
                -- Instantly hide text and stop fading
                isFading = false
                topText:SetAlpha(0)
                
                -- Reset dropdowns
                for i = 1, 12 do
                    selections[i] = 13
                    UIDropDownMenu_SetSelectedValue(dropdowns[i], 13)
                    UIDropDownMenu_SetText(dropdowns[i], "- None -")
                end
            end
            
            startW = panel:GetWidth()
            animTime = 0
            isAnimating = true
        end)
        
        panel:HookScript("OnUpdate", function(self, dt)
            if isAnimating then
                animTime = animTime + dt
                local p = animTime / 1.0 -- 1 secc duration
                if p >= 1 then
                    p = 1
                    isAnimating = false
                    
                    -- Trigger text fade-in ONLY after the panel fully finishes expanding
                    if isExpanded then
                        isFading = true
                        fadeTime = 0
                    end
                end
                
                -- Smoothstep interpolation
                local smooth_p = p * p * (3 - 2 * p)
                self:SetWidth(startW + (targetW - startW) * smooth_p)
            end
            
            if isFading then
                fadeTime = fadeTime + dt
                local alpha = fadeTime / 1.0 -- Fade over 1 second
                if alpha >= 1 then
                    alpha = 1
                    isFading = false
                end
                topText:SetAlpha(alpha)
            end
        end)

        self:Hide()
    end
end)

-- ========================================================================= --
-- PVP Frame Calculator Toggle Button (Appended Feature)
-- ========================================================================= --
local calcBtnInitFrame = CreateFrame("Frame")

calcBtnInitFrame:SetScript("OnUpdate", function(self)
    -- Wait until the Blizzard PVPFrameArena actually exists
    if _G.PVPFrameArena and not _G.AtlasLootPVPCalcToggleButton then
        
        -- Create the Toggle Button
        local toggleBtn = CreateFrame("Button", "AtlasLootPVPCalcToggleButton", _G.PVPFrameArena, "UIPanelButtonTemplate")
        toggleBtn:SetSize(80, 22)
        -- Anchored to the far right of the PVPFrameArena
        toggleBtn:SetPoint("RIGHT", _G.PVPFrameArena, "RIGHT", -90, 0)
        toggleBtn:SetText("Calculator")
        
        -- Click behavior
        toggleBtn:SetScript("OnClick", function()
            -- Determine the new state (if 1 then make 0, if 0 then make 1)
            local currentState = (_G.slcDB and _G.slcDB.showArenaEstimate == 1)
            local newState = currentState and 0 or 1
            
            -- 1. Update the SavedVariable
            if _G.slcDB then
                _G.slcDB.showArenaEstimate = newState
            end
            
            -- 2. Sync the AtlasLoot GUI checkbox
            if _G.AtlasLootArenaEstimateCheckbox then
                _G.AtlasLootArenaEstimateCheckbox:SetChecked(newState == 1)
            end
            
            -- 3. Show or Hide the Custom Side Panel
            if _G.AtlasLootPVPSidePanel then
                if newState == 1 then
                    _G.AtlasLootPVPSidePanel:Show()
                    -- Force the panel to refresh its numbers and internal checkbox when opened
                    if _G.AtlasLootPVPSidePanel.UpdateStats then
                        _G.AtlasLootPVPSidePanel.UpdateStats()
                    end
                else
                    _G.AtlasLootPVPSidePanel:Hide()
                end
            end
        end)
        
        -- The button has been successfully created, kill the loop
        self:Hide()
    end
end)

-- ========================================================================= --
-- Forever Beta PSA
-- ========================================================================= --
local function UpdatePSAFooterHeight()
    local footer = _G["AtlasLoot_PSA_Footer"]
    if not footer or not footer.text then return end
    local textHeight = math.ceil(footer.text:GetStringHeight() or 0)
    if textHeight > 0 then
        footer:SetHeight(math.max(30, textHeight + 12))
    end
end

local function CreatePSAFooter()
    local parentFrame = _G["AtlasLoot_GUI-Frame"]
    if not parentFrame or _G["AtlasLoot_PSA_Footer"] then return end

    local bisFooter = _G["AtlasLoot_BiS_Footer"]

    -- Create Footer
    local footer = CreateFrame("Frame", "AtlasLoot_PSA_Footer", parentFrame, _G.BackdropTemplateMixin and "BackdropTemplate" or nil)
    if bisFooter then
        footer:SetPoint("TOPLEFT", bisFooter, "BOTTOMLEFT", 0, 0)
        footer:SetPoint("TOPRIGHT", bisFooter, "BOTTOMRIGHT", 0, 0)
    else
        footer:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 0, -24)
        footer:SetPoint("TOPRIGHT", parentFrame, "BOTTOMRIGHT", 0, -24)
    end
    footer:SetHeight(36) -- Initial height, will auto-adjust below

    -- Apply parent style (copies backdrop, color, and border)
    SyncStyle(footer, parentFrame)

    -- Icon (scaled up to match larger footer)
    local icon = footer:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("LEFT", footer, "LEFT", 10, 0)
    icon:SetTexture("Interface\\AddOns\\AtlasLootClassic\\notification.tga")

    -- Text (larger font size with automatic word wrap)
    local text = footer:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    text:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    text:SetPoint("RIGHT", footer, "RIGHT", -10, 0)
    text:SetFont("Fonts\\FRIZQT__.TTF", 15.5, "OUTLINE")
    text:SetTextColor(1, 0.82, 0)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("MIDDLE")
    text:SetWordWrap(true)
    text:SetText("PSA: All new Forever items have already been added to your Atlas but you cannot see them right now, unless a player on the server has found them! New Forever related additions are now marked with the '|TInterface\\AddOns\\AtlasLootClassic\\ltn4.tga:18:18:2:0|t' Icon.")

    footer.text = text

    -- Auto-adjust footer height to fit the text + padding
    UpdatePSAFooterHeight()

    -- Ensure height dynamically updates if UI scale or width changes
    footer:SetScript("OnSizeChanged", function(self, w, h)
        UpdatePSAFooterHeight()
    end)

    -- Auto-fade footer after 15s/120s, fading over 2s on every frame show
    local fadeTimer
    local function StartPSATimer()
        if fadeTimer then fadeTimer:Cancel() end
        UIFrameFadeRemoveFrame(footer)
        footer:SetAlpha(1)
        footer:Show()
        fadeTimer = C_Timer.NewTimer(120, function()
            UIFrameFadeOut(footer, 2, 1, 0)
        end)
    end

    parentFrame:HookScript("OnShow", StartPSATimer)
    parentFrame:HookScript("OnHide", function()
        if fadeTimer then fadeTimer:Cancel() end
        UIFrameFadeRemoveFrame(footer)
    end)

    if parentFrame:IsShown() then
        StartPSATimer()
    end
end

local function InitPSAFooter()
    if _G.AtlasLoot and _G.AtlasLoot.GUI then
        hooksecurefunc(_G.AtlasLoot.GUI, "Create", CreatePSAFooter)
        hooksecurefunc(_G.AtlasLoot.GUI, "RefreshMainFrame", function()
            local footer = _G["AtlasLoot_PSA_Footer"]
            local parent = _G["AtlasLoot_GUI-Frame"]
            if footer and parent then
                SyncStyle(footer, parent)
                UpdatePSAFooterHeight()
            end
        end)
        if _G["AtlasLoot_GUI-Frame"] then
            CreatePSAFooter()
        end
    end
end

if IsLoggedIn() then
    InitPSAFooter()
else
    local psaLoader = CreateFrame("Frame")
    psaLoader:RegisterEvent("PLAYER_LOGIN")
    psaLoader:SetScript("OnEvent", function(self)
        InitPSAFooter()
        self:UnregisterAllEvents()
    end)
end