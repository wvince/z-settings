local QUALITY_COLOR = {
    [0] = "|cFF9D9D9D", -- Poor
    [1] = "|cFFFFFFFF", -- Common
    [2] = "|cFF1EFF00", -- Uncommon
    [3] = "|cFF0070DD", -- Rare
    [4] = "|cFFA335EE", -- Epic
    [5] = "|cFFFF8000", -- Legendary
}
local addonName = ...

-- Localization: uses TrinketMenuDB.language (auto/en/es); in 'auto' it follows the client locale.
local function L(key, ...)
    local lang = TrinketMenuDB and TrinketMenuDB.language
    if not lang or lang == "auto" or not TrinketMenuLocales[lang] then
        lang = (GetLocale() or "enUS"):sub(1, 2) == "es" and "es" or "en"
    end
    local text = TrinketMenuLocales[lang][key] or TrinketMenuLocales.en[key] or key
    if select("#", ...) > 0 then return text:format(...) end
    return text
end

local EQUIPMENT_SLOTS = {
    { id = 13, labelKey = "TRINKET1", dbKey = "showSlot13" },
    { id = 14, labelKey = "TRINKET2", dbKey = "showSlot14" },
}

local function GetItemInfo(itemID)
    if not itemID then return nil end
    if C_Item and C_Item.GetItemInfo then
        return C_Item.GetItemInfo(itemID)
    elseif _G.GetItemInfo then
        return _G.GetItemInfo(itemID)
    end
end

local function GetItemInfoInstant(itemID)
    if not itemID then return nil end
    if C_Item and C_Item.GetItemInfoInstant then
        return C_Item.GetItemInfoInstant(itemID)
    elseif _G.GetItemInfoInstant then
        return _G.GetItemInfoInstant(itemID)
    end
end

local function GetBagSlotCount(bag)
    if C_Container and C_Container.GetContainerNumSlots then
        return C_Container.GetContainerNumSlots(bag) or 0
    end
    return GetContainerNumSlots and GetContainerNumSlots(bag) or 0
end

local function GetBagItemID(bag, slot)
    if C_Container and C_Container.GetContainerItemID then
        return C_Container.GetContainerItemID(bag, slot)
    end
    return GetContainerItemID and GetContainerItemID(bag, slot)
end

local function GetBagItemLink(bag, slot)
    if C_Container and C_Container.GetContainerItemLink then
        return C_Container.GetContainerItemLink(bag, slot)
    end
    return GetContainerItemLink and GetContainerItemLink(bag, slot)
end

local function GetBagItemIcon(bag, slot)
    if C_Container and C_Container.GetContainerItemInfo then
        local info = C_Container.GetContainerItemInfo(bag, slot)
        return type(info) == "table" and info.iconFileID or nil
    end
    if GetContainerItemInfo then
        return (GetContainerItemInfo(bag, slot))
    end
end

local function PickupBagItem(bag, slot)
    if C_Container and C_Container.PickupContainerItem then
        C_Container.PickupContainerItem(bag, slot)
    elseif PickupContainerItem then
        PickupContainerItem(bag, slot)
    else
        error(L("ERR_BAG_API"))
    end
end

local function GetItemEquipLocation(itemID)
    if not itemID then return nil end
    local _, _, _, equipLocation = GetItemInfoInstant(itemID)
    if equipLocation then return equipLocation end

    local _, _, _, _, _, _, _, _, equipLocation = GetItemInfo(itemID)
    return equipLocation
end

local function Print(message)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFD100[TrinketMenu]|r " .. tostring(message))
    end
end

local function GetItemName(itemID)
    if not itemID then return L("SLOT_EMPTY", "") end
    local name = GetItemInfo(itemID)
    if name then return name end
    return L("ITEM_N", itemID)
end

local function GetBagTrinkets()
    local items = {}
    local seen = {}
    local numBags = NUM_BAG_SLOTS or 4

    for bag = 0, numBags do
        local slots = GetBagSlotCount(bag)
        for slot = 1, slots do
            local itemID = GetBagItemID(bag, slot)
            if itemID then
                local name, link, quality, _, _, _, _, _, _, icon = GetItemInfo(itemID)
                if not name and C_Item and C_Item.RequestLoadItemDataByID then
                    C_Item.RequestLoadItemDataByID(itemID)
                end
                if GetItemEquipLocation(itemID) == "INVTYPE_TRINKET" then
                    local key = tostring(itemID) .. ":" .. tostring(bag) .. ":" .. tostring(slot)
                    if not seen[key] then
                        seen[key] = true
                        local bagIcon = GetBagItemIcon(bag, slot)
                        items[#items + 1] = {
                            id = itemID,
                            name = name or L("ITEM_N", itemID),
                            link = link or GetBagItemLink(bag, slot),
                            icon = icon or bagIcon or "Interface\\Icons\\INV_Misc_QuestionMark",
                            quality = quality,
                            bag = bag,
                            bagSlot = slot,
                            equippedSlot = nil,
                            isTargetSlot = false,
                        }
                    end
                end
            end
        end
    end

    table.sort(items, function(a, b)
        local aName = a.name or ""
        local bName = b.name or ""
        if aName ~= bName then
            return aName < bName
        end
        return (a.id or 0) < (b.id or 0)
    end)

    return items
end

local function GetAvailableTrinkets(targetSlotID)
    local items = GetBagTrinkets()
    local seen = {}
    for _, item in ipairs(items) do
        seen[item.id] = true
    end

    for _, slotInfo in ipairs(EQUIPMENT_SLOTS) do
        local itemID = GetInventoryItemID("player", slotInfo.id)
        if itemID and not seen[itemID] then
            local name, link, quality, _, _, _, _, _, _, icon = GetItemInfo(itemID)
            if not name and C_Item and C_Item.RequestLoadItemDataByID then
                C_Item.RequestLoadItemDataByID(itemID)
            end
            items[#items + 1] = {
                id = itemID,
                name = name or L("ITEM_N", itemID),
                link = link or GetInventoryItemLink("player", slotInfo.id),
                icon = icon or GetInventoryItemTexture("player", slotInfo.id)
                    or "Interface\\Icons\\INV_Misc_QuestionMark",
                quality = quality,
                equippedSlot = slotInfo.id,
                equippedSlotLabel = L(slotInfo.labelKey),
                isTargetSlot = (slotInfo.id == targetSlotID),
            }
            seen[itemID] = true
        end
    end

    table.sort(items, function(a, b)
        local aTarget = (a.isTargetSlot == true)
        local bTarget = (b.isTargetSlot == true)
        if aTarget ~= bTarget then
            return aTarget
        end
        local aName = a.name or ""
        local bName = b.name or ""
        if aName ~= bName then
            return aName < bName
        end
        return (a.id or 0) < (b.id or 0)
    end)
    return items
end

local function GetItemCooldownInfo(itemID)
    if C_Item and C_Item.GetItemCooldown then
        return C_Item.GetItemCooldown(itemID)
    elseif GetItemCooldown then
        return GetItemCooldown(itemID)
    end
end

local addon = CreateFrame("Frame", "ForeverTrinketMenuEventFrame", UIParent)
addon:RegisterEvent("PLAYER_LOGIN")
addon:RegisterEvent("BAG_UPDATE")
addon:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
addon:RegisterEvent("GET_ITEM_INFO_RECEIVED")
addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:RegisterEvent("SPELL_UPDATE_COOLDOWN")
addon:RegisterEvent("BAG_UPDATE_COOLDOWN")

function addon:FillTooltip(tooltip)
    tooltip:AddLine("|cFFFFD100Forever " .. L("NAME") .. "|r")
    tooltip:AddLine(L("MINIMAP_LEFT"), 0.85, 0.85, 0.85, true)
    tooltip:AddLine(L("MINIMAP_RIGHT"), 0.85, 0.85, 0.85, true)
    tooltip:AddLine(L("MINIMAP_SHIFT"), 0.85, 0.85, 0.85, true)
end

function addon:MinimapClick(mouseButton)
    if IsShiftKeyDown() then
        TrinketMenuDB.locked = not (TrinketMenuDB.locked and true or false)
        Print(TrinketMenuDB.locked and L("LOCKED") or L("UNLOCKED"))
        self:UpdateLockAppearance()
        self:UpdateOptionsText()
        return
    end
    if mouseButton == "RightButton" then
        self:ToggleOptions()
    else
        self:Toggle()
    end
end

function addon:CreateMinimapButton()
    if self.minimapButton then return end

    local LDB = LibStub and LibStub("LibDataBroker-1.1", true)
    local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)
    if LDB and LDBIcon then
        TrinketMenuDB.minimap = TrinketMenuDB.minimap or {}
        local object = LDB:GetDataObjectByName("TrinketMenu") or LDB:NewDataObject("TrinketMenu", {
            type = "launcher",
            text = "Trinket Menu",
            icon = "Interface\\Icons\\INV_Jewelry_Talisman_01",
            OnClick = function(_, mouseButton) addon:MinimapClick(mouseButton) end,
            OnTooltipShow = function(tooltip) addon:FillTooltip(tooltip) end,
        })
        if not LDBIcon:IsRegistered("TrinketMenu") then
            LDBIcon:Register("TrinketMenu", object, TrinketMenuDB.minimap)
        end
        self.minimapButton = LDBIcon:GetMinimapButton("TrinketMenu") or true
        return
    end

    local button = CreateFrame("Button", "LibDBIcon10_TrinketMenu", Minimap)
    button:SetSize(31, 31)
    button:SetFrameStrata("HIGH")
    button:SetFrameLevel(21)
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER", button, "CENTER", 0, 1)
    icon:SetTexture("Interface\\Icons\\INV_Jewelry_Talisman_01")

    -- Free 360-degree positioning and dragging
    local function UpdateMinimapPosition()
        local angle = TrinketMenuDB.minimapPos or 220
        local radius = (math.min(Minimap:GetWidth(), Minimap:GetHeight()) / 2) + 5
        local rad = math.rad(angle)
        local x = math.cos(rad) * radius
        local y = math.sin(rad) * radius
        button:ClearAllPoints()
        button:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end

    local isDragging = false
    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        isDragging = true
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local cx, cy = GetCursorPosition()
            local scale = UIParent:GetEffectiveScale()
            cx, cy = cx / scale, cy / scale
            local angle = math.deg(math.atan2(cy - my, cx - mx))
            if angle < 0 then angle = angle + 360 end
            TrinketMenuDB.minimapPos = angle
            UpdateMinimapPosition()
        end)
    end)
    button:SetScript("OnDragStop", function(self)
        isDragging = false
        self:SetScript("OnUpdate", nil)
    end)

    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function(_, mouseButton)
        if isDragging then return end
        addon:MinimapClick(mouseButton)
    end)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        addon:FillTooltip(GameTooltip)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)

    UpdateMinimapPosition()
    if Minimap.HookScript then
        Minimap:HookScript("OnSizeChanged", UpdateMinimapPosition)
    end
    button:Show()
    self.minimapButton = button
end

local TOOLTIP_BACKDROP = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}
local function ClearFrameBackdrop(f)
    if not f then return end
    f:SetBackdrop(nil)
    if f.SetBackdropColor then f:SetBackdropColor(0, 0, 0, 0) end
    if f.SetBackdropBorderColor then f:SetBackdropBorderColor(0, 0, 0, 0) end
    if f.TopEdge then f.TopEdge:Hide() end
    if f.BottomEdge then f.BottomEdge:Hide() end
    if f.LeftEdge then f.LeftEdge:Hide() end
    if f.RightEdge then f.RightEdge:Hide() end
    if f.TopLeftCorner then f.TopLeftCorner:Hide() end
    if f.TopRightCorner then f.TopRightCorner:Hide() end
    if f.BottomLeftCorner then f.BottomLeftCorner:Hide() end
    if f.BottomRightCorner then f.BottomRightCorner:Hide() end
    if f.Center then f.Center:Hide() end
end

local function ApplyTooltipBackdrop(f)
    if not f then return end
    f:SetBackdrop(TOOLTIP_BACKDROP)
    f:SetBackdropColor(0, 0, 0, 0.9)
    f:SetBackdropBorderColor(1, 1, 1, 1)
    if f.TopEdge then f.TopEdge:Show() end
    if f.BottomEdge then f.BottomEdge:Show() end
    if f.LeftEdge then f.LeftEdge:Show() end
    if f.RightEdge then f.RightEdge:Show() end
    if f.TopLeftCorner then f.TopLeftCorner:Show() end
    if f.TopRightCorner then f.TopRightCorner:Show() end
    if f.BottomLeftCorner then f.BottomLeftCorner:Show() end
    if f.BottomRightCorner then f.BottomRightCorner:Show() end
    if f.Center then f.Center:Show() end
end

local EMPTY_ICON = "Interface\\Icons\\INV_Jewelry_Talisman_01"
local BUTTON_SIZE = 36

local function FormatTime(seconds)
    if seconds >= 600 then
        return math.ceil(seconds / 60) .. "m"
    elseif seconds >= 60 then
        return string.format("%d:%02d", math.floor(seconds / 60), math.floor(seconds % 60))
    end
    return tostring(math.ceil(seconds))
end

local function CreateItemButton(name, parent, template)
    local button = CreateFrame("Button", name, parent, template)
    button:SetSize(BUTTON_SIZE, BUTTON_SIZE)

    button.icon = button:CreateTexture(nil, "BACKGROUND")
    button.icon:SetAllPoints(button)
    button.icon:SetTexture(EMPTY_ICON)

    button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2")
    local normal = button:GetNormalTexture()
    normal:ClearAllPoints()
    normal:SetPoint("TOPLEFT", button, "TOPLEFT", -15, 15)
    normal:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 15, -15)
    button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
    button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

    button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
    button.cooldown:SetAllPoints(button)
    if button.cooldown.SetHideCountdownNumbers then
        button.cooldown:SetHideCountdownNumbers(true)
    end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints(button)
    overlay:SetFrameLevel(button.cooldown:GetFrameLevel() + 1)
    button.timeText = overlay:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    button.timeText:SetPoint("CENTER", button, "CENTER", 0, 0)
    button.timeText:SetTextColor(1, 0.9, 0.2)

    -- Combat swap queue border (amber/gold)
    button.queueBorder = overlay:CreateTexture(nil, "OVERLAY")
    button.queueBorder:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
    button.queueBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4)
    button.queueBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    button.queueBorder:SetBlendMode("ADD")
    button.queueBorder:SetVertexColor(1.0, 0.75, 0.0, 1.0)
    button.queueBorder:Hide()

    -- Ready cooldown flash effect
    button.flashTex = overlay:CreateTexture(nil, "OVERLAY")
    button.flashTex:SetAllPoints(button)
    button.flashTex:SetTexture("Interface\\Buttons\\CheckButtonHilight")
    button.flashTex:SetBlendMode("ADD")
    button.flashTex:Hide()

    -- Auto-queue rank indicator badge (1, 2, 3...)
    button.rankText = overlay:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    button.rankText:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
    button.rankText:SetTextColor(1.0, 0.85, 0.0)
    button.rankText:Hide()

    return button
end

local function UpdateButtonCooldown(button, start, duration)
    if start and duration and duration > 1.5 and start > 0 then
        button.cooldown:SetCooldown(start, duration)
        local remaining = start + duration - GetTime()
        if remaining > 0 then
            button.timeText:SetText(FormatTime(remaining))
            return
        end
    else
        button.cooldown:SetCooldown(0, 0)
    end
    button.timeText:SetText("")
end

function addon:ApplyScale()
    local scale = TrinketMenuDB and TrinketMenuDB.scale or 1.0
    if self.window then self.window:SetScale(scale) end
    if self.itemMenu then self.itemMenu:SetScale(scale) end
end

function addon:UpdateLockAppearance()
    local frame = self.window
    if not frame then return end

    local isLocked = TrinketMenuDB and TrinketMenuDB.locked and true or false
    local hideFrame = TrinketMenuDB and TrinketMenuDB.hideFrameBorder and true or false
    local hideMenuBorder = TrinketMenuDB and TrinketMenuDB.hideMenuBorder and true or false

    if hideFrame then
        ClearFrameBackdrop(frame)
    else
        ApplyTooltipBackdrop(frame)
    end

    if isLocked then
        frame:EnableMouse(false)
    else
        frame:EnableMouse(true)
    end

    local menu = self.itemMenu
    if menu and menu:IsShown() then
        if hideMenuBorder then
            ClearFrameBackdrop(menu)
        else
            ApplyTooltipBackdrop(menu)
        end
    end
end

function addon:UpdateQueueIndicators()
    if not self.slotButtons then return end
    for slotID, slotButton in pairs(self.slotButtons) do
        if self.queuedSwaps and self.queuedSwaps[slotID] then
            slotButton.queueBorder:Show()
        else
            slotButton.queueBorder:Hide()
        end
    end
end

-- ============================================================
-- AUTO-QUEUE (Automatic rotation queue)
-- ============================================================
function addon:GetAutoQueueRank(slotID, itemID)
    if not TrinketMenuDB or not TrinketMenuDB.autoQueue then return nil end
    local list = TrinketMenuDB.autoQueue[slotID]
    if not list then return nil end
    for rank, id in ipairs(list) do
        if id == itemID then return rank end
    end
    return nil
end

function addon:ToggleAutoQueueItem(slotID, item)
    TrinketMenuDB.autoQueue = TrinketMenuDB.autoQueue or {}
    TrinketMenuDB.autoQueue[slotID] = TrinketMenuDB.autoQueue[slotID] or {}
    local list = TrinketMenuDB.autoQueue[slotID]

    local existingRank = self:GetAutoQueueRank(slotID, item.id)
    if existingRank then
        table.remove(list, existingRank)
        Print(L("QUEUE_REMOVED", item.name))
    else
        table.insert(list, item.id)
        Print(L("QUEUE_ADDED", item.name, #list))
    end
    self:RefreshItemMenu()
end

function addon:CheckAutoQueue()
    if not TrinketMenuDB or not TrinketMenuDB.autoQueueEnabled then return end
    if not TrinketMenuDB.autoQueue then return end

    local bagItems = GetBagTrinkets()
    local bagMap = {}
    for _, item in ipairs(bagItems) do
        bagMap[item.id] = item
    end

    for _, slotInfo in ipairs(EQUIPMENT_SLOTS) do
        local slotID = slotInfo.id
        local list = TrinketMenuDB.autoQueue[slotID]
        if list and #list > 0 then
            local currentID = GetInventoryItemID("player", slotID)
            local currentStart, currentDur = GetInventoryItemCooldown("player", slotID)
            local currentRemaining = 0
            if currentStart and currentDur and currentDur > 1.5 and currentStart > 0 then
                currentRemaining = currentStart + currentDur - GetTime()
            end

            local currentRank = addon:GetAutoQueueRank(slotID, currentID) or 999
            local bestTarget = nil

            if currentRemaining > 30 then
                -- Equipped trinket is on cooldown: find the highest priority available trinket in the queue
                for _, targetID in ipairs(list) do
                    if targetID ~= currentID and bagMap[targetID] then
                        local start, dur = GetItemCooldownInfo(targetID)
                        local rem = 0
                        if start and dur and dur > 1.5 and start > 0 then
                            rem = start + dur - GetTime()
                        end
                        if rem <= 0 then
                            bestTarget = bagMap[targetID]
                            break
                        end
                    end
                end
            else
                -- Equipped trinket is ready or passive: check if there is a HIGHER priority trinket ready in bags
                for _, targetID in ipairs(list) do
                    local targetRank = addon:GetAutoQueueRank(slotID, targetID) or 999
                    if targetRank < currentRank and targetID ~= currentID and bagMap[targetID] then
                        local start, dur = GetItemCooldownInfo(targetID)
                        local rem = 0
                        if start and dur and dur > 1.5 and start > 0 then
                            rem = start + dur - GetTime()
                        end
                        if rem <= 0 then
                            bestTarget = bagMap[targetID]
                            break
                        end
                    end
                end
            end

            if bestTarget then
                if InCombatLockdown and InCombatLockdown() then
                    if not (self.queuedSwaps and self.queuedSwaps[slotID] and self.queuedSwaps[slotID].id == bestTarget.id) then
                        self.queuedSwaps = self.queuedSwaps or {}
                        self.queuedSwaps[slotID] = bestTarget
                        Print(L("AUTOQUEUE_SWAP", bestTarget.name, L(slotInfo.labelKey)))
                        self:UpdateQueueIndicators()
                    end
                else
                    Print(L("AUTOQUEUE_SWAP", bestTarget.name, L(slotInfo.labelKey)))
                    self:Equip(bestTarget, slotID)
                end
            end
        end
    end
end

-- ============================================================
-- MAIN FRAME CREATION
-- ============================================================
function addon:CreateWindow()
    if self.window then return end
    TrinketMenuDB = TrinketMenuDB or {}
    TrinketMenuDB.columns = TrinketMenuDB.columns or 4
    TrinketMenuDB.scale = TrinketMenuDB.scale or 1.0
    if TrinketMenuDB.notifyReady == nil then TrinketMenuDB.notifyReady = true end
    TrinketMenuDB.autoQueueEnabled = TrinketMenuDB.autoQueueEnabled == true
    if TrinketMenuDB.showSlot13 == nil then TrinketMenuDB.showSlot13 = true end
    if TrinketMenuDB.showSlot14 == nil then TrinketMenuDB.showSlot14 = true end
    if TrinketMenuDB.hideFrameBorder == nil then
        TrinketMenuDB.hideFrameBorder = false
    end
    if TrinketMenuDB.hideMenuBorder == nil then TrinketMenuDB.hideMenuBorder = false end
    TrinketMenuDB.autoQueue = TrinketMenuDB.autoQueue or { [13] = {}, [14] = {} }

    local frame = CreateFrame("Frame", "ForeverTrinketMenuFrame", UIParent, "BackdropTemplate")
    frame:SetSize(BUTTON_SIZE + 24, (BUTTON_SIZE * 2) + 30)
    frame:SetFrameStrata("MEDIUM")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetBackdrop(TOOLTIP_BACKDROP)
    frame:SetBackdropColor(0, 0, 0, 0.9)
    frame:SetBackdropBorderColor(1, 1, 1, 1)

    local position = TrinketMenuDB.windowPosition
    if position and TrinketMenuDB.layoutVersion == 3 then
        frame:SetPoint(position.point or "CENTER", UIParent,
            position.relativePoint or "CENTER", position.x or 0, position.y or 0)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
        TrinketMenuDB.windowPosition = nil
        TrinketMenuDB.layoutVersion = 3
    end

    local function StartMove()
        if TrinketMenuDB.locked then return end
        if InCombatLockdown and InCombatLockdown() then return end
        frame:StartMoving()
    end
    local function StopMove()
        frame:StopMovingOrSizing()
        local point, _, relativePoint, x, y = frame:GetPoint()
        TrinketMenuDB.windowPosition = { point = point, relativePoint = relativePoint, x = x, y = y }
    end
    frame:SetScript("OnDragStart", StartMove)
    frame:SetScript("OnDragStop", StopMove)

    self.slotButtons = {}
    for index, slotInfo in ipairs(EQUIPMENT_SLOTS) do
        local slotButton = CreateItemButton("ForeverTrinketMenuSlot" .. index, frame, "SecureActionButtonTemplate")
        slotButton:RegisterForClicks("AnyUp", "AnyDown")
        slotButton:SetAttribute("type", "macro")
        slotButton:SetAttribute("macrotext", "/use " .. slotInfo.id)
        slotButton:SetAttribute("type1", "macro")
        slotButton:SetAttribute("macrotext1", "/use " .. slotInfo.id)
        slotButton:RegisterForDrag("LeftButton")
        slotButton.slotInfo = slotInfo

        -- Right-click: cancels pending combat swap if any, or toggles trinket menu popup
        slotButton:HookScript("OnClick", function(self, mouseButton)
            if mouseButton == "RightButton" then
                if addon.queuedSwaps and addon.queuedSwaps[slotInfo.id] then
                    addon.queuedSwaps[slotInfo.id] = nil
                    addon:UpdateQueueIndicators()
                    Print(L("QUEUE_CANCEL"))
                    return
                end
                local menu = addon.itemMenu
                if menu and menu:IsShown() and menu.slotID == slotInfo.id then
                    menu:Hide()
                else
                    addon:ShowItemMenu(self, slotInfo.id)
                end
            end
        end)
        -- Shift+Drag to move the window directly from the icon buttons
        slotButton:SetScript("OnDragStart", function()
            if IsShiftKeyDown() then StartMove() end
        end)
        slotButton:SetScript("OnDragStop", StopMove)

        slotButton:SetScript("OnEnter", function(self)
            if TrinketMenuDB.menuOnHover ~= false then
                addon:ShowItemMenu(self, slotInfo.id)
            end
            GameTooltip:SetOwner(self, TrinketMenuDB.horizontal and "ANCHOR_TOP" or "ANCHOR_LEFT")
            if GetInventoryItemID("player", slotInfo.id) then
                GameTooltip:SetInventoryItem("player", slotInfo.id)
            else
                GameTooltip:ClearLines()
                GameTooltip:SetText(L("SLOT_EMPTY", L(slotInfo.labelKey)), 1, 1, 1)
            end
            if addon.queuedSwaps and addon.queuedSwaps[slotInfo.id] then
                local qItem = addon.queuedSwaps[slotInfo.id]
                GameTooltip:AddLine("|cFFFFFF00" .. L("SWAP_QUEUED", qItem.name or L("ITEM_N", qItem.id)) .. "|r", 1, 0.82, 0)
            end
            GameTooltip:AddLine(L("SLOT_HINT"), 0.7, 0.85, 1, true)
            GameTooltip:Show()
        end)
        slotButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
            addon:ScheduleMenuHide()
        end)
        self.slotButtons[slotInfo.id] = slotButton
    end

    frame:SetScript("OnMouseUp", function(_, mouseButton)
        if mouseButton == "RightButton" then
            if TrinketMenuDB.locked then return end
            TrinketMenuDB.horizontal = not TrinketMenuDB.horizontal
            addon:ApplyLayout()
            if addon.UpdateOptionsText then addon:UpdateOptionsText() end
        end
    end)

    frame:SetScript("OnShow", function() addon:Refresh() end)
    frame:SetScript("OnHide", function()
        if addon.itemMenu then addon.itemMenu:Hide() end
    end)
    frame:SetScript("OnUpdate", function(self, elapsed)
        self.elapsed = (self.elapsed or 0) + elapsed
        if self.elapsed >= 0.25 then
            self.elapsed = 0
            addon:UpdateCooldowns()
        end
    end)
    frame:Hide()
    self.window = frame
    self:ApplyLayout()
    self:ApplyScale()
    self:UpdateLockAppearance()
end

function addon:ApplyLayout()
    local frame = self.window
    if not frame then return end
    if InCombatLockdown and InCombatLockdown() then
        Print(L("ERR_COMBAT_LAYOUT"))
        TrinketMenuDB.horizontal = not TrinketMenuDB.horizontal
        return
    end

    local horizontal = TrinketMenuDB.horizontal
    local show1 = TrinketMenuDB.showSlot13 ~= false
    local show2 = TrinketMenuDB.showSlot14 ~= false
    if not show1 and not show2 then
        show1, show2 = true, true
        TrinketMenuDB.showSlot13, TrinketMenuDB.showSlot14 = true, true
    end

    local visibleCount = (show1 and 1 or 0) + (show2 and 1 or 0)
    local step = BUTTON_SIZE + 6

    if horizontal then
        frame:SetSize(visibleCount * step + 18, BUTTON_SIZE + 24)
    else
        frame:SetSize(BUTTON_SIZE + 24, visibleCount * step + 18)
    end

    local currentPos = 0
    for index, slotInfo in ipairs(EQUIPMENT_SLOTS) do
        local button = self.slotButtons[slotInfo.id]
        local isShown = (slotInfo.id == 13 and show1) or (slotInfo.id == 14 and show2)
        if isShown then
            button:ClearAllPoints()
            if horizontal then
                button:SetPoint("LEFT", frame, "LEFT", 12 + currentPos * step, 0)
            else
                button:SetPoint("TOP", frame, "TOP", 0, -12 - currentPos * step)
            end
            button:Show()
            currentPos = currentPos + 1
        else
            button:Hide()
        end
    end

    if self.itemMenu and self.itemMenu:IsShown() then
        self.itemMenu:Hide()
    end
    self:ApplyScale()
    self:UpdateLockAppearance()
end

function addon:ShowItemMenu(anchor, slotID)
    local menu = self.itemMenu
    if not menu then
        menu = CreateFrame("Frame", "ForeverTrinketMenuItemPopup", UIParent, "BackdropTemplate")
        menu:SetFrameStrata("DIALOG")
        menu:SetClampedToScreen(true)
        menu:EnableMouse(true)
        menu:SetBackdrop(TOOLTIP_BACKDROP)
        menu.buttons = {}
        menu:SetScript("OnLeave", function() addon:ScheduleMenuHide() end)
        menu:Hide()
        UISpecialFrames = UISpecialFrames or {}
        table.insert(UISpecialFrames, menu:GetName())
        self.itemMenu = menu
    end

    menu.slotID = slotID
    menu:ClearAllPoints()
    local horizontal = TrinketMenuDB.horizontal
    local hideMenuBorder = TrinketMenuDB and TrinketMenuDB.hideMenuBorder and true or false
    local pad = hideMenuBorder and 0 or 10
    local btnGap = hideMenuBorder and 4 or 6

    local targetAnchor = anchor or self.window
    if horizontal then
        if hideMenuBorder then
            menu:SetPoint("TOPLEFT", targetAnchor, "BOTTOMLEFT", 0, -4)
        else
            menu:SetPoint("TOPLEFT", targetAnchor, "BOTTOMLEFT", -10, 2)
        end
    else
        if hideMenuBorder then
            menu:SetPoint("TOPLEFT", targetAnchor, "TOPRIGHT", 4, 0)
        else
            menu:SetPoint("TOPLEFT", targetAnchor, "TOPRIGHT", -2, 10)
        end
    end

    local items = GetAvailableTrinkets(slotID)
    if #items == 0 then
        for _, button in ipairs(menu.buttons) do button:Hide() end
        if not menu.emptyText then
            menu.emptyText = menu:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            menu.emptyText:SetPoint("CENTER", menu, "CENTER")
            menu.emptyText:SetText(L("NO_TRINKETS"))
        end
        menu.emptyText:SetText(L("NO_TRINKETS"))
        menu.emptyText:Show()
        menu:SetSize(96, 32)
        if hideMenuBorder then
            ClearFrameBackdrop(menu)
        else
            ApplyTooltipBackdrop(menu)
        end
        menu:Show()
        return
    elseif menu.emptyText then
        menu.emptyText:Hide()
    end

    -- Grid layout (Multi-Column)
    local cols = TrinketMenuDB.columns or 4
    if cols < 1 then cols = 1 end
    local numItems = #items
    local numCols = math.min(numItems, cols)
    local numRows = math.ceil(numItems / cols)

    for index, item in ipairs(items) do
        local button = menu.buttons[index]
        if not button then
            button = CreateItemButton(nil, menu)
            button:RegisterForClicks("LeftButtonUp")
            button:SetScript("OnLeave", function()
                GameTooltip:Hide()
                addon:ScheduleMenuHide()
            end)
            menu.buttons[index] = button
        end

        local colIdx = (index - 1) % cols
        local rowIdx = math.floor((index - 1) / cols)
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", menu, "TOPLEFT", pad + colIdx * (BUTTON_SIZE + btnGap), -pad - rowIdx * (BUTTON_SIZE + btnGap))
        
        button.item = item
        button.icon:SetTexture(item.icon)
        button.icon:SetDesaturated(item.equippedSlot and true or false)

        -- Auto-queue rank badge
        local queueRank = addon:GetAutoQueueRank(slotID, item.id)
        if queueRank then
            button.rankText:SetText(tostring(queueRank))
            button.rankText:Show()
        else
            button.rankText:Hide()
        end

        -- Leveling BiS Advisor synergy
        local isBis = false
        local LBA = _G.LevelingBiSAdvisor
        if LBA and LBA.Scoring then
            local currentBiS = LBA.Scoring.currentBiS
            if currentBiS and currentBiS["Trinket"] then
                local list = currentBiS["Trinket"]
                if slotID == 13 and list[1] then
                    local candId = list[1].id or (list[1].item and list[1].item.id)
                    if candId == item.id then isBis = true end
                elseif slotID == 14 then
                    local t1Id = list[1] and (list[1].id or (list[1].item and list[1].item.id))
                    local t1Group = list[1] and list[1].data and list[1].data.uniqueGroup
                    for i = 2, #list do
                        local cand = list[i]
                        local candId = cand.id or (cand.item and cand.item.id)
                        local candGroup = cand.data and cand.data.uniqueGroup
                        local conflict = (candId == t1Id) or (t1Group and candGroup and t1Group == candGroup)
                        if not conflict then
                            if candId == item.id then isBis = true end
                            break
                        end
                    end
                end
            elseif LBA.Scoring.BestBySlot then
                local slotKey = slotID == 14 and "Trinket2" or "Trinket"
                local bestList = LBA.Scoring.BestBySlot[slotKey]
                if bestList and bestList[1] and bestList[1].item and bestList[1].item.id == item.id then
                    isBis = true
                end
            end
        end

        if not button.bisBorder then
            button.bisBorder = button:CreateTexture(nil, "OVERLAY")
            button.bisBorder:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
            button.bisBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
            button.bisBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
            button.bisBorder:SetBlendMode("ADD")
            button.bisBorder:SetVertexColor(1.0, 0.82, 0.0, 1.0)
        end
        if isBis then button.bisBorder:Show() else button.bisBorder:Hide() end

        button:SetScript("OnClick", function()
            if IsAltKeyDown() then
                addon:ToggleAutoQueueItem(slotID, item)
                return
            end
            if not item.isTargetSlot then
                addon:Equip(item, slotID)
            end
            menu:Hide()
        end)
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if item.link then
                GameTooltip:SetHyperlink(item.link)
            else
                GameTooltip:SetText(item.name)
            end
            if item.equippedSlotLabel then
                GameTooltip:AddLine(L("EQUIPPED_IN", item.equippedSlotLabel), 0.45, 0.85, 1)
            end
            if isBis then
                GameTooltip:AddLine(L("BIS_RECOMMENDED"), 1.0, 0.82, 0.0)
            end
            GameTooltip:AddLine(L("CLICK_EQUIP", L(slotID == 14 and "TRINKET2" or "TRINKET1")), 0.65, 0.85, 1)
            GameTooltip:AddLine(L("HINT_AUTOQUEUE"), 0.4, 0.8, 1)
            GameTooltip:Show()
        end)
        button:Show()
    end

    for index = #items + 1, #menu.buttons do
        menu.buttons[index]:Hide()
    end

    menu:SetSize(numCols * (BUTTON_SIZE + btnGap) - btnGap + pad * 2, numRows * (BUTTON_SIZE + btnGap) - btnGap + pad * 2)
    if hideMenuBorder then
        ClearFrameBackdrop(menu)
    else
        ApplyTooltipBackdrop(menu)
    end
    menu:Show()
    self:ApplyScale()
    self:UpdateCooldowns()
end

function addon:ScheduleMenuHide()
    local menu = self.itemMenu
    if not menu or not menu:IsShown() or TrinketMenuDB.menuOnHover == false then return end
    if not (C_Timer and C_Timer.After) then
        menu:Hide()
        return
    end
    C_Timer.After(0.3, function()
        if not menu:IsShown() or menu:IsMouseOver() then return end
        for _, slot in pairs(addon.slotButtons) do
            if slot:IsMouseOver() then return end
        end
        menu:Hide()
    end)
end

local function CreateCenterAlertFrame()
    if addon.centerAlertFrame then return addon.centerAlertFrame end

    local f = CreateFrame("Frame", "ForeverTrinketMenuCenterAlert", UIParent)
    f:SetSize(76, 76)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(false)
    f:Hide()

    -- Solo la imagen pura del abalorio (sin recuadros ni bordes sobre la textura)
    f.icon = f:CreateTexture(nil, "ARTWORK")
    f.icon:SetAllPoints(f)
    f.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    addon.centerAlertFrame = f
    return f
end

function addon:ShowCenterAlert(itemID)
    if not itemID then return end
    local f = CreateCenterAlertFrame()
    local icon
    if C_Item and C_Item.GetItemIconByID then
        icon = C_Item.GetItemIconByID(itemID)
    end
    if not icon and GetItemInfoInstant then
        local _, _, _, _, instantIcon = GetItemInfoInstant(itemID)
        icon = instantIcon
    end
    if not icon then
        local _, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
        icon = itemIcon
    end
    icon = icon or GetInventoryItemTexture("player", 13) or EMPTY_ICON

    f.icon:SetTexture(icon)

    -- Initial opacity (0.80) to remain translucent and unobtrusive
    f:SetAlpha(0.80)
    f:Show()

    -- Smooth fade out animation (1.3s duration)
    f.timer = 1.3
    f:SetScript("OnUpdate", function(self, elapsed)
        self.timer = self.timer - elapsed
        if self.timer <= 0.6 then
            self:SetAlpha(math.max(0, (self.timer / 0.6) * 0.80))
        end
        if self.timer <= 0 then
            self:SetScript("OnUpdate", nil)
            self:Hide()
        end
    end)
end

function addon:UpdateCooldowns()
    self.cooldownTracker = self.cooldownTracker or {}
    if self.slotButtons then
        for slotID, slot in pairs(self.slotButtons) do
            local start, duration = GetInventoryItemCooldown("player", slotID)
            UpdateButtonCooldown(slot, start, duration)

            local remaining = 0
            if start and duration and duration > 1.5 and start > 0 then
                remaining = start + duration - GetTime()
            end
            local prev = self.cooldownTracker[slotID] or 0
            if prev > 1.5 and remaining <= 0 then
                -- Trinket ready: audio notification and button flash
                if TrinketMenuDB.notifyReady ~= false then
                    local itemID = GetInventoryItemID("player", slotID)
                    if itemID then
                        Print(L("TRINKET_READY", GetItemName(itemID)))
                        self:ShowCenterAlert(itemID)
                    end
                    if PlaySound then
                        pcall(PlaySound, 8959, "Master")
                    end
                end
                if slot.flashTex then
                    slot.flashTex:Show()
                    if C_Timer and C_Timer.After then
                        C_Timer.After(0.8, function()
                            if slot.flashTex then slot.flashTex:Hide() end
                        end)
                    end
                end
            end
            self.cooldownTracker[slotID] = remaining
        end
    end
    local menu = self.itemMenu
    if menu and menu:IsShown() then
        for _, button in ipairs(menu.buttons) do
            if button:IsShown() and button.item then
                UpdateButtonCooldown(button, GetItemCooldownInfo(button.item.id))
            end
        end
    end

    -- Check auto-queue rotation
    self:CheckAutoQueue()
end

function addon:Equip(item, slotID)
    -- In combat: queue swap to equip automatically upon leaving combat
    if InCombatLockdown and InCombatLockdown() then
        self.queuedSwaps = self.queuedSwaps or {}
        self.queuedSwaps[slotID] = item
        Print(L("SWAP_QUEUED", item.name or L("ITEM_N", item.id)))
        self:UpdateQueueIndicators()
        return
    end

    if not PickupInventoryItem or not CursorHasItem then
        Print(L("ERR_SWAP_API"))
        return
    end

    if item.equippedSlot == slotID then
        return
    end

    if CursorHasItem() then
        Print(L("ERR_CURSOR"))
        return
    end

    local ok, err = pcall(function()
        if item.equippedSlot then
            PickupInventoryItem(item.equippedSlot)
            PickupInventoryItem(slotID)
            if CursorHasItem() then
                PickupInventoryItem(item.equippedSlot)
            end
        elseif item.bag ~= nil and item.bagSlot ~= nil then
            PickupBagItem(item.bag, item.bagSlot)
            PickupInventoryItem(slotID)
            if CursorHasItem() then
                PickupBagItem(item.bag, item.bagSlot)
            end
        else
            error(L("ERR_NO_LOCATION"))
        end
    end)
    if not ok then
        Print(L("ERR_EQUIP_FAILED", item.name, tostring(err)))
        return
    end
    self:Refresh()
end

function addon:Refresh()
    if not self.window or not self.window:IsShown() then return end

    for slotID, slot in pairs(self.slotButtons) do
        slot.icon:SetTexture(GetInventoryItemTexture("player", slotID) or EMPTY_ICON)
    end
    self:UpdateCooldowns()
    self:UpdateQueueIndicators()
end

function addon:RefreshItemMenu()
    if not self.itemMenu or not self.itemMenu:IsShown() then return end
    local slotButton = self.slotButtons and self.slotButtons[self.itemMenu.slotID]
    if slotButton then self:ShowItemMenu(slotButton, self.itemMenu.slotID) end
end

function addon:Toggle()
    if not self.window then self:CreateWindow() end
    if self.window:IsShown() then
        self.window:Hide()
        TrinketMenuDB.hidden = true
    else
        self.window:Show()
        TrinketMenuDB.hidden = false
    end
end

local LANGUAGE_NAMES = { en = "English", es = "Español" }

function addon:RefreshQueuePanel()
    if not self.options or not self.options.panelQueue or not self.options.panelQueue:IsShown() then return end
    local o = self.options
    local slotID = o.selectedQueueSlot or 13

    o.btnSlot1:SetEnabled(slotID ~= 13)
    o.btnSlot2:SetEnabled(slotID ~= 14)

    local items = GetAvailableTrinkets(slotID)
    local content = o.queueContent
    content.rows = content.rows or {}

    local rowHeight = 30
    for index, item in ipairs(items) do
        local row = content.rows[index]
        if not row then
            row = CreateFrame("Frame", nil, content)
            row:SetSize(310, rowHeight)

            row.icon = row:CreateTexture(nil, "ARTWORK")
            row.icon:SetSize(22, 22)
            row.icon:SetPoint("LEFT", row, "LEFT", 4, 0)

            row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
            row.name:SetWidth(160)
            row.name:SetJustifyH("LEFT")

            row.badge = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            row.badge:SetPoint("RIGHT", row, "RIGHT", -75, 0)

            row.btn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            row.btn:SetSize(68, 20)
            row.btn:SetPoint("RIGHT", row, "RIGHT", -2, 0)

            content.rows[index] = row
        end
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(index - 1) * rowHeight)
        row.icon:SetTexture(item.icon)

        local qColor = item.quality and QUALITY_COLOR and QUALITY_COLOR[item.quality] or "|cFFFFFFFF"
        row.name:SetText(qColor .. (item.name or "") .. "|r")

        local rank = addon:GetAutoQueueRank(slotID, item.id)
        if rank then
            row.badge:SetText("|cFFFFD100#" .. rank .. "|r")
            row.btn:SetText(L("BTN_REMOVE"))
        else
            row.badge:SetText("")
            row.btn:SetText(L("BTN_ADD"))
        end

        row.btn:SetScript("OnClick", function()
            addon:ToggleAutoQueueItem(slotID, item)
            addon:RefreshQueuePanel()
        end)

        row:Show()
    end
    for index = #items + 1, #content.rows do
        content.rows[index]:Hide()
    end
    content:SetHeight(math.max(1, #items * rowHeight))
end

function addon:UpdateOptionsText()
    local o = self.options
    if not o then return end
    o.title:SetText(L("OPTIONS_TITLE"))
    o.tabGeneral:SetText(L("TAB_GENERAL"))
    o.tabQueue:SetText(L("TAB_QUEUE"))

    o.lock.text:SetText(L("OPT_LOCK"))
    o.lock:SetChecked(TrinketMenuDB.locked and true or false)
    o.hideBorder.text:SetText(L("OPT_HIDE_BORDER"))
    o.hideBorder:SetChecked(TrinketMenuDB.hideFrameBorder and true or false)
    o.hideMenuBorder.text:SetText(L("OPT_HIDE_MENU_BORDER"))
    o.hideMenuBorder:SetChecked(TrinketMenuDB.hideMenuBorder and true or false)
    o.horizontal.text:SetText(L("OPT_HORIZONTAL"))
    o.horizontal:SetChecked(TrinketMenuDB.horizontal and true or false)
    o.hover.text:SetText(L("OPT_HOVER"))
    o.hover:SetChecked(TrinketMenuDB.menuOnHover ~= false)
    o.notify.text:SetText(L("OPT_NOTIFY"))
    o.notify:SetChecked(TrinketMenuDB.notifyReady ~= false)

    o.autoqueue.text:SetText(L("OPT_AUTOQUEUE"))
    o.autoqueue:SetChecked(TrinketMenuDB.autoQueueEnabled == true)

    o.slot1.text:SetText(L("OPT_SLOT1"))
    o.slot1:SetChecked(TrinketMenuDB.showSlot13 ~= false)
    o.slot2.text:SetText(L("OPT_SLOT2"))
    o.slot2:SetChecked(TrinketMenuDB.showSlot14 ~= false)

    local currentCols = TrinketMenuDB.columns or 4
    o.colsLabel:SetText(L("OPT_COLUMNS", currentCols))
    for num, btn in pairs(o.colButtons) do
        btn:SetEnabled(num ~= currentCols)
    end

    local currentScale = TrinketMenuDB.scale or 1.0
    o.scaleLabel:SetText(L("OPT_SCALE", currentScale))

    o.langLabel:SetText(L("OPT_LANGUAGE"))
    o.hint:SetText(L("OPT_HINT"))
    local currentLang = TrinketMenuDB.language or "auto"
    for code, button in pairs(o.langButtons) do
        button:SetText(code == "auto" and L("LANG_AUTO") or LANGUAGE_NAMES[code])
        button:SetEnabled(code ~= currentLang)
    end

    o.btnSlot1:SetText(L("TRINKET1"))
    o.btnSlot2:SetText(L("TRINKET2"))
    o.queueDesc:SetText(L("QUEUE_PANEL_DESC"))
    o.btnClearQueue:SetText(L("BTN_CLEAR_QUEUE"))
end

function addon:SetLanguage(code)
    code = (code or ""):lower()
    if code == "" then code = "auto" end
    if code ~= "auto" and not TrinketMenuLocales[code] then
        Print(L("HELP"))
        return
    end
    TrinketMenuDB.language = code
    Print(L("LANG_SET", code == "auto" and L("LANG_AUTO") or LANGUAGE_NAMES[code]))
    self:UpdateOptionsText()
    self:RefreshItemMenu()
end

local function CreateCheckbox(parent, name, y)
    local check = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    check:SetPoint("TOPLEFT", parent, "TOPLEFT", 18, y)
    check.text = check.Text or _G[name .. "Text"]
    return check
end

function addon:ToggleOptions()
    if not self.options then
        local frame = CreateFrame("Frame", "ForeverTrinketMenuOptions", UIParent, "BackdropTemplate")
        frame:SetSize(380, 440)
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        frame:SetFrameStrata("DIALOG")
        frame:SetBackdrop(TOOLTIP_BACKDROP)
        frame:SetBackdropColor(0, 0, 0, 0.94)
        frame:SetClampedToScreen(true)
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
        frame:Hide()
        UISpecialFrames = UISpecialFrames or {}
        table.insert(UISpecialFrames, frame:GetName())

        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
        local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)

        -- Top tab buttons
        frame.tabGeneral = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        frame.tabGeneral:SetSize(165, 24)
        frame.tabGeneral:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -32)

        frame.tabQueue = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        frame.tabQueue:SetSize(165, 24)
        frame.tabQueue:SetPoint("TOPLEFT", frame.tabGeneral, "TOPRIGHT", 14, 0)

        -- General Panel
        local panelGeneral = CreateFrame("Frame", nil, frame)
        panelGeneral:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -60)
        panelGeneral:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
        frame.panelGeneral = panelGeneral

        -- Queue Panel
        local panelQueue = CreateFrame("Frame", nil, frame)
        panelQueue:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -60)
        panelQueue:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
        panelQueue:Hide()
        frame.panelQueue = panelQueue

        frame.tabGeneral:SetScript("OnClick", function()
            panelGeneral:Show()
            panelQueue:Hide()
            frame.tabGeneral:SetEnabled(false)
            frame.tabQueue:SetEnabled(true)
        end)

        frame.tabQueue:SetScript("OnClick", function()
            panelGeneral:Hide()
            panelQueue:Show()
            frame.tabGeneral:SetEnabled(true)
            frame.tabQueue:SetEnabled(false)
            addon:RefreshQueuePanel()
        end)

        -- General Panel controls
        frame.lock = CreateCheckbox(panelGeneral, "ForeverTrinketMenuOptLock", -10)
        frame.lock:SetScript("OnClick", function(self)
            TrinketMenuDB.locked = self:GetChecked() and true or false
            addon:UpdateLockAppearance()
        end)

        frame.hideBorder = CreateCheckbox(panelGeneral, "ForeverTrinketMenuOptHideBorder", -32)
        frame.hideBorder:SetScript("OnClick", function(self)
            TrinketMenuDB.hideFrameBorder = self:GetChecked() and true or false
            addon:UpdateLockAppearance()
        end)
        frame.hideBorder:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(L("OPT_HIDE_BORDER"))
            GameTooltip:AddLine(L("OPT_HIDE_BORDER_DESC"), 0.85, 0.85, 0.85, true)
            GameTooltip:Show()
        end)
        frame.hideBorder:SetScript("OnLeave", function() GameTooltip:Hide() end)

        frame.hideMenuBorder = CreateCheckbox(panelGeneral, "ForeverTrinketMenuOptHideMenuBorder", -54)
        frame.hideMenuBorder:SetScript("OnClick", function(self)
            TrinketMenuDB.hideMenuBorder = self:GetChecked() and true or false
            addon:UpdateLockAppearance()
            addon:RefreshItemMenu()
        end)
        frame.hideMenuBorder:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(L("OPT_HIDE_MENU_BORDER"))
            GameTooltip:AddLine(L("OPT_HIDE_MENU_BORDER_DESC"), 0.85, 0.85, 0.85, true)
            GameTooltip:Show()
        end)
        frame.hideMenuBorder:SetScript("OnLeave", function() GameTooltip:Hide() end)

        frame.horizontal = CreateCheckbox(panelGeneral, "ForeverTrinketMenuOptHorizontal", -76)
        frame.horizontal:SetScript("OnClick", function(self)
            TrinketMenuDB.horizontal = self:GetChecked() and true or false
            addon:ApplyLayout()
            addon:UpdateOptionsText()
        end)

        frame.hover = CreateCheckbox(panelGeneral, "ForeverTrinketMenuOptHover", -98)
        frame.hover:SetScript("OnClick", function(self)
            TrinketMenuDB.menuOnHover = self:GetChecked() and true or false
        end)

        frame.notify = CreateCheckbox(panelGeneral, "ForeverTrinketMenuOptNotify", -120)
        frame.notify:SetScript("OnClick", function(self)
            TrinketMenuDB.notifyReady = self:GetChecked() and true or false
        end)

        frame.autoqueue = CreateCheckbox(panelGeneral, "ForeverTrinketMenuOptAutoQueue", -142)
        frame.autoqueue:SetScript("OnClick", function(self)
            TrinketMenuDB.autoQueueEnabled = self:GetChecked() and true or false
            local status = TrinketMenuDB.autoQueueEnabled and L("STATUS_ENABLED") or L("STATUS_DISABLED")
            Print(L("AUTOQUEUE_STATUS", status))
        end)
        frame.autoqueue:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(L("OPT_AUTOQUEUE"))
            GameTooltip:AddLine(L("OPT_AUTOQUEUE_DESC"), 0.85, 0.85, 0.85, true)
            GameTooltip:Show()
        end)
        frame.autoqueue:SetScript("OnLeave", function() GameTooltip:Hide() end)

        -- Show/Hide Slot 1 & 2
        frame.slot1 = CreateCheckbox(panelGeneral, "ForeverTrinketMenuOptSlot1", -164)
        frame.slot1:SetScript("OnClick", function(self)
            TrinketMenuDB.showSlot13 = self:GetChecked() and true or false
            addon:ApplyLayout()
        end)

        frame.slot2 = CreateCheckbox(panelGeneral, "ForeverTrinketMenuOptSlot2", -164)
        frame.slot2:ClearAllPoints()
        frame.slot2:SetPoint("TOPLEFT", panelGeneral, "TOPLEFT", 180, -164)
        frame.slot2:SetScript("OnClick", function(self)
            TrinketMenuDB.showSlot14 = self:GetChecked() and true or false
            addon:ApplyLayout()
        end)

        -- Columns selector
        frame.colsLabel = panelGeneral:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        frame.colsLabel:SetPoint("TOPLEFT", panelGeneral, "TOPLEFT", 22, -196)
        frame.colButtons = {}
        local colList = { 2, 3, 4, 6 }
        local prevColBtn
        for _, num in ipairs(colList) do
            local btn = CreateFrame("Button", nil, panelGeneral, "UIPanelButtonTemplate")
            btn:SetSize(36, 20)
            btn:SetText(tostring(num))
            if prevColBtn then
                btn:SetPoint("LEFT", prevColBtn, "RIGHT", 4, 0)
            else
                btn:SetPoint("TOPLEFT", panelGeneral, "TOPLEFT", 140, -192)
            end
            btn:SetScript("OnClick", function()
                TrinketMenuDB.columns = num
                addon:UpdateOptionsText()
                addon:RefreshItemMenu()
            end)
            frame.colButtons[num] = btn
            prevColBtn = btn
        end

        -- Scale selector
        frame.scaleLabel = panelGeneral:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        frame.scaleLabel:SetPoint("TOPLEFT", panelGeneral, "TOPLEFT", 22, -224)
        
        local scaleMinus = CreateFrame("Button", nil, panelGeneral, "UIPanelButtonTemplate")
        scaleMinus:SetSize(36, 20)
        scaleMinus:SetText("-")
        scaleMinus:SetPoint("TOPLEFT", panelGeneral, "TOPLEFT", 140, -220)
        scaleMinus:SetScript("OnClick", function()
            local s = math.max(0.7, (TrinketMenuDB.scale or 1.0) - 0.1)
            TrinketMenuDB.scale = math.floor(s * 10 + 0.5) / 10
            addon:ApplyScale()
            addon:UpdateOptionsText()
        end)

        local scalePlus = CreateFrame("Button", nil, panelGeneral, "UIPanelButtonTemplate")
        scalePlus:SetSize(36, 20)
        scalePlus:SetText("+")
        scalePlus:SetPoint("LEFT", scaleMinus, "RIGHT", 4, 0)
        scalePlus:SetScript("OnClick", function()
            local s = math.min(1.5, (TrinketMenuDB.scale or 1.0) + 0.1)
            TrinketMenuDB.scale = math.floor(s * 10 + 0.5) / 10
            addon:ApplyScale()
            addon:UpdateOptionsText()
        end)

        -- Language selector
        frame.langLabel = panelGeneral:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        frame.langLabel:SetPoint("TOPLEFT", panelGeneral, "TOPLEFT", 22, -252)
        frame.langButtons = {}
        local previous
        for _, code in ipairs({ "auto", "en", "es" }) do
            local button = CreateFrame("Button", nil, panelGeneral, "UIPanelButtonTemplate")
            button:SetSize(72, 22)
            if previous then
                button:SetPoint("LEFT", previous, "RIGHT", 4, 0)
            else
                button:SetPoint("TOPLEFT", panelGeneral, "TOPLEFT", 20, -272)
            end
            button:SetScript("OnClick", function() addon:SetLanguage(code) end)
            frame.langButtons[code] = button
            previous = button
        end

        frame.hint = panelGeneral:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        frame.hint:SetPoint("BOTTOMLEFT", panelGeneral, "BOTTOMLEFT", 18, 12)
        frame.hint:SetWidth(340)
        frame.hint:SetJustifyH("LEFT")

        -- QUEUE PANEL CONTENT
        frame.selectedQueueSlot = 13

        frame.btnSlot1 = CreateFrame("Button", nil, panelQueue, "UIPanelButtonTemplate")
        frame.btnSlot1:SetSize(165, 24)
        frame.btnSlot1:SetPoint("TOPLEFT", panelQueue, "TOPLEFT", 18, -10)
        frame.btnSlot1:SetScript("OnClick", function()
            frame.selectedQueueSlot = 13
            addon:RefreshQueuePanel()
        end)

        frame.btnSlot2 = CreateFrame("Button", nil, panelQueue, "UIPanelButtonTemplate")
        frame.btnSlot2:SetSize(165, 24)
        frame.btnSlot2:SetPoint("TOPLEFT", frame.btnSlot1, "TOPRIGHT", 14, 0)
        frame.btnSlot2:SetScript("OnClick", function()
            frame.selectedQueueSlot = 14
            addon:RefreshQueuePanel()
        end)

        frame.queueDesc = panelQueue:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        frame.queueDesc:SetPoint("TOPLEFT", panelQueue, "TOPLEFT", 20, -42)
        frame.queueDesc:SetWidth(340)
        frame.queueDesc:SetJustifyH("LEFT")

        -- ScrollFrame for trinket list
        local scroll = CreateFrame("ScrollFrame", "ForeverTrinketMenuQueueScroll", panelQueue, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", panelQueue, "TOPLEFT", 14, -68)
        scroll:SetPoint("BOTTOMRIGHT", panelQueue, "BOTTOMRIGHT", -36, 42)

        local queueContent = CreateFrame("Frame", nil, scroll)
        queueContent:SetSize(310, 1)
        scroll:SetScrollChild(queueContent)
        frame.queueContent = queueContent

        -- Clear queue button
        frame.btnClearQueue = CreateFrame("Button", nil, panelQueue, "UIPanelButtonTemplate")
        frame.btnClearQueue:SetSize(340, 22)
        frame.btnClearQueue:SetPoint("BOTTOMLEFT", panelQueue, "BOTTOMLEFT", 18, 10)
        frame.btnClearQueue:SetScript("OnClick", function()
            local sID = frame.selectedQueueSlot or 13
            TrinketMenuDB.autoQueue = TrinketMenuDB.autoQueue or {}
            TrinketMenuDB.autoQueue[sID] = {}
            Print(L("QUEUE_CLEARED", L(sID == 14 and "TRINKET2" or "TRINKET1")))
            addon:RefreshQueuePanel()
            addon:RefreshItemMenu()
        end)

        frame:SetScript("OnShow", function()
            addon:UpdateOptionsText()
            frame.tabGeneral:Click()
        end)
        self.options = frame
    end
    if self.options:IsShown() then
        self.options:Hide()
    else
        self.options:Show()
    end
end

addon:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        TrinketMenuDB = TrinketMenuDB or {}
        self:CreateWindow()
        if not TrinketMenuDB.hidden then self.window:Show() end
        self:CreateMinimapButton()

        -- Migrate legacy keybindings (FOREVERTRINKET1 / FOREVERTRINKET2 -> CLICK ForeverTrinketMenuSlot...)
        if GetBindingKey and SetBinding then
            local changed = false
            local function MigrateOldBinding(oldToken, newToken)
                local key1, key2 = GetBindingKey(oldToken)
                if key1 then
                    SetBinding(key1, newToken)
                    changed = true
                end
                if key2 then
                    SetBinding(key2, newToken)
                    changed = true
                end
            end
            MigrateOldBinding("FOREVERTRINKET1", "CLICK ForeverTrinketMenuSlot1:LeftButton")
            MigrateOldBinding("FOREVERTRINKET2", "CLICK ForeverTrinketMenuSlot2:LeftButton")
            if changed and SaveBindings and GetCurrentBindingSet then
                pcall(SaveBindings, GetCurrentBindingSet())
            end
        end

        SLASH_FOREVERTRINKETMENU1 = "/tm"
        SLASH_FOREVERTRINKETMENU2 = "/trinketmenu"
        SlashCmdList.FOREVERTRINKETMENU = function(msg)
            msg = (msg or ""):lower()
            local cmd, arg = msg:match("^(%S*)%s*(.-)$")
            if cmd == "options" or cmd == "opt" or cmd == "config" then
                self:ToggleOptions()
            elseif cmd == "test" then
                local testID = GetInventoryItemID("player", 13) or GetInventoryItemID("player", 14) or 280766
                self:ShowCenterAlert(testID)
                if PlaySound then pcall(PlaySound, 8959, "Master") end
                Print("Aviso central de prueba mostrado.")
            elseif cmd == "auto" or cmd == "autoqueue" or cmd == "queue" then
                TrinketMenuDB.autoQueueEnabled = not TrinketMenuDB.autoQueueEnabled
                local status = TrinketMenuDB.autoQueueEnabled and L("STATUS_ENABLED") or L("STATUS_DISABLED")
                Print(L("AUTOQUEUE_STATUS", status))
                self:UpdateOptionsText()
            elseif cmd == "scale" then
                local num = tonumber(arg)
                if num and num >= 0.5 and num <= 2.0 then
                    TrinketMenuDB.scale = num
                    self:ApplyScale()
                    self:UpdateOptionsText()
                    Print("Scale set to " .. num)
                else
                    Print("Usage: /tm scale 0.7 - 1.5")
                end
            elseif cmd == "cols" or cmd == "columns" then
                local num = tonumber(arg)
                if num and num >= 1 and num <= 10 then
                    TrinketMenuDB.columns = num
                    self:RefreshItemMenu()
                    self:UpdateOptionsText()
                    Print("Columns set to " .. num)
                else
                    Print("Usage: /tm cols 1 - 8")
                end
            elseif cmd == "lang" then
                self:SetLanguage(arg)
            elseif cmd == "help" or cmd == "?" then
                Print(L("HELP"))
            elseif msg == "lock" or msg == "unlock" then
                TrinketMenuDB.locked = (msg == "lock")
                Print(TrinketMenuDB.locked and L("LOCKED") or L("UNLOCKED"))
                self:UpdateLockAppearance()
                self:UpdateOptionsText()
            elseif msg == "border" then
                TrinketMenuDB.hideFrameBorder = not (TrinketMenuDB.hideFrameBorder and true or false)
                Print(TrinketMenuDB.hideFrameBorder and L("BORDER_HIDDEN") or L("BORDER_SHOWN"))
                self:UpdateLockAppearance()
                self:UpdateOptionsText()
            elseif msg == "menuborder" then
                TrinketMenuDB.hideMenuBorder = not (TrinketMenuDB.hideMenuBorder and true or false)
                Print(TrinketMenuDB.hideMenuBorder and L("MENU_BORDER_HIDDEN") or L("MENU_BORDER_SHOWN"))
                self:UpdateLockAppearance()
                self:RefreshItemMenu()
                self:UpdateOptionsText()
            else
                self:Toggle()
            end
        end
        Print(L("LOADED"))
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Leave combat: process pending manual swaps and auto-queue check
        if self.queuedSwaps and next(self.queuedSwaps) then
            local pending = self.queuedSwaps
            self.queuedSwaps = {}
            self:UpdateQueueIndicators()
            for slotID, item in pairs(pending) do
                self:Equip(item, slotID)
                Print(L("SWAP_EXECUTED", item.name or L("ITEM_N", item.id)))
            end
        else
            self:CheckAutoQueue()
        end
        if self.window and self.window:IsShown() then
            self:Refresh()
            self:RefreshItemMenu()
        end
    elseif event == "SPELL_UPDATE_COOLDOWN" or event == "BAG_UPDATE_COOLDOWN" then
        if self.window and self.window:IsShown() then
            self:UpdateCooldowns()
        end
    else
        if self.window and self.window:IsShown() then
            self:Refresh()
            self:RefreshItemMenu()
        end
    end
end)
