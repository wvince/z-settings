--     _   _   _                 _                 _   _____  ____    ____ 
--    / \ | |_| |  __ _   ___  | |  ___    ___   | |_|_   _|| __ )  / ___|
--   / _ \| __| | / _` | / __| | | / _ \  / _ \  | __| | |  |  _ \ | |    
--  / ___ \ |_| || (_| | \__ \ | || (_) || (_) | | |_  | |  | |_) || |___ 
-- /_/   \_\__|_| \__,_| |___/ |_| \___/  \___/   \__| |_|  |____/  \____|
--
--[[
    ***********************************************************************
    * PROJECT: AtlasBiS Integration Module                                *
    * MODULE: Core Renderer & Data Handler                                *
    * VERSION: 1.0.1                           				              *
    * DESC: Handles tooltip injection via native API hooking mechanisms.  *
    ***********************************************************************
]]

local _G = _G
local pairs, ipairs, select, tostring, type = pairs, ipairs, select, tostring, type
local string_format, string_match = string.format, string.match
local math_floor = math.floor


-- SYSTEM CONSTANTS & ASSETS

local ADDON_NAME, PrivateNamespace = ...
local ASSET_ROOT_PATH = [[Interface\AddOns\AtlasBIStooltips\media\]]

-- Global namespace definition for Atlas integration
sliccNote.BIS = sliccNote.BIS or {}
sliccNote.Items = sliccNote.Items or {}

-- Internal configuration for visual rendering
local RENDER_CONFIG = {
    ICON_SIZE = 64,
    ICON_PADDING = 6,
    DISPLAY_SIZE = 14,
    TEXTURE_DIM = 256,
    HEADER_COLOR = { r = 1.0, g = 0.82, b = 0.0 }
}


-- UTILITY: LOGGING WRAPPER

local Logger = {
    _prefix = "|cFF00FF00[System]|r ",
    Log = function(self, message)
        -- Placeholder for future debugging output streams
        -- print(self._prefix .. tostring(message)) 
        return nil
    end
}


-- SUBSYSTEM: CONFIGURATION MANAGER

local ConfigManager = {}

function ConfigManager:Initialize()
    -- [PERSISTENCE] Initialize the global database if it is undefined
    if not _G.slcDB then 
        _G.slcDB = {
            showBiS = 1,          -- Default: Enabled
            showOnlyMyClass = 0,  -- Default: Disabled
            bisPhase = 1          -- Default: Phase 1 (Changed from 0)
        }
    else
        -- [VALIDATION] Ensure integrity of existing keys
        if _G.slcDB.showBiS == nil then _G.slcDB.showBiS = 1 end
        if _G.slcDB.showOnlyMyClass == nil then _G.slcDB.showOnlyMyClass = 0 end
        if _G.slcDB.bisPhase == nil then _G.slcDB.bisPhase = 1 end -- Default: Phase 1 (Changed from 0)
    end
    Logger:Log("Configuration module initialized.")
end

function ConfigManager:GetState(key)
    if _G.slcDB and _G.slcDB[key] ~= nil then
        return _G.slcDB[key]
    end
    return 0 -- Fail safe return
end


-- SUBSYSTEM: TEXTURE & ASSET CALCULATOR

local AssetEngine = {}

-- texture stringindividual class files
function AssetEngine:GenerateTextureString(className)
    if not className then return "" end

    local texturePath = string_format("%s%s", ASSET_ROOT_PATH, className:lower())
    
    return string_format(
        "|T%s:%d:%d|t",
        texturePath,
        RENDER_CONFIG.DISPLAY_SIZE,
        RENDER_CONFIG.DISPLAY_SIZE
    )
end


-- SUBSYSTEM: TOOLTIP RENDERER

local TooltipRenderer = {}

-- Tooltip Processing and Rendering Logic
function TooltipRenderer:ProcessItem(tooltipRef, data)
    -- [GUARD] Sanity check on the tooltip object
    if not tooltipRef or tooltipRef:IsForbidden() then return end

    -- [QUERY] Retrieve item ID (supports modern TooltipDataProcessor and legacy GetItem)
    local itemID = data and data.id
    if not itemID and tooltipRef.GetItem then
        local linkName, linkString = tooltipRef:GetItem()
        itemID = linkString and string_match(linkString, "item:(%d+)")
    end
    
    -- Normalize key check for sliccNote.Items (supports string or number)
    if not itemID then return end
    local itemKey = sliccNote.Items[tostring(itemID)] and tostring(itemID) or (sliccNote.Items[tonumber(itemID)] and tonumber(itemID))
    if not itemKey then return end

    -- [STATE CHECK] Verify if the user wants to see BiS info
    if ConfigManager:GetState("showBiS") == 0 then return end

    -- Begin rendering process
    self:DrawTooltipLines(tooltipRef, itemKey)
end

function TooltipRenderer:DrawTooltipLines(targetTooltip, itemID)
    local itemDataMap = sliccNote.Items[itemID]
    local _, playerClassStr = UnitClass("player")
    local filterByClass = (ConfigManager:GetState("showOnlyMyClass") == 1)
    local currentPhase = ConfigManager:GetState("bisPhase") -- NEW: Get current dropdown phase
    
    local hasRenderedHeader = false
    local theme = RENDER_CONFIG.HEADER_COLOR

    -- Iterate through all registered BiS entries for this item
    for uniqueKey, phaseValue in pairs(itemDataMap) do
        local bisRecord = sliccNote.BIS[uniqueKey]

        if bisRecord and bisRecord.class then
            local specStr = bisRecord.spec or ""
            local isP2Entry = specStr:match("_P2$") ~= nil -- NEW: Check if this is a P2 data block
            
            -- NEW: Logic to determine if we should show this specific row
            local belongsToCurrentPhase = false
            if currentPhase == 1 and not specStr:match("_P[23]$") then
                belongsToCurrentPhase = true
            elseif currentPhase == 2 and specStr:match("_P2$") then
                belongsToCurrentPhase = true
            elseif currentPhase == 3 and specStr:match("_P3$") then
                belongsToCurrentPhase = true
            end

            if belongsToCurrentPhase then
                local normalizedClass = string.upper(bisRecord.class)
                
                -- [LOGIC] Determine visibility based on user settings
                local shouldDisplay = true
                if filterByClass and (normalizedClass ~= playerClassStr) then
                    shouldDisplay = false
                end

                if shouldDisplay then
                    -- Fetch Blizzard standard class colors
                    local classColor = RAID_CLASS_COLORS[normalizedClass]

                    if classColor then
                        -- [UI] Inject Header (Once per item)
                        if not hasRenderedHeader then
                            targetTooltip:AddLine(" ") -- Spacing
                            local tq_r, tq_g, tq_b = 0, 1, 0.82
                            -- NEW: Dynamic Header Text based on phase
                            local phaseColored = currentPhase == 3 and "|cFF00FF00Phase 3|r" or currentPhase == 2 and "|cFFFF8000Phase 2|r" or "|cFFFF0000Phase 1|r"
							local headerText = string_format("AtlasLootTBC %s BiS for", phaseColored)
                            targetTooltip:AddDoubleLine(
                                headerText,                        -- Left side
                                "Rank:",                           -- Right side
                                theme.r, theme.g, theme.b,         -- Left side color
                                tq_r, tq_g, tq_b                   -- Right side color
                            )
                                
                            hasRenderedHeader = true
                        end

                        -- [GRAPHICS] Generate the icon string from custom media
                        local iconString = AssetEngine:GenerateTextureString(normalizedClass)

                        -- [TEXT] Build the description string
                        local commentStr = bisRecord.comment or ""
                        
                        -- NEW: Strip the "_P2" off the string so the user just sees "Resto"
                        local cleanSpecStr = specStr:gsub("_P[23]$", "") 
                        
                        local displayLine = string_format("%s %s %s", iconString, cleanSpecStr, commentStr)

                        -- [RENDER] Add the double line to the tooltip
                        targetTooltip:AddDoubleLine(
                            displayLine, 
                            phaseValue, 
                            classColor.r, classColor.g, classColor.b, -- Left Color
                            classColor.r, classColor.g, classColor.b  -- Right Color
                        )
                    end
                end
            end
        end
    end

    -- Force UI update to accommodate new lines
    targetTooltip:Show()
end

--[[
    API: RECslot
    Desc: Maps an item ID to a registered BiS entry and assigns a phase value.
    Updated: Abstracted data injection logic.
]]
function sliccNote:RECslot(configurationObj, targetItemId, tierValue)
    -- Enclose operations in a local scope to isolate logic
    do
        -- 1. Acquire a pointer to the central item repository
        local registryRoot = self.Items

        -- 2. Resolve the specific container for this Item ID
        -- If the container does not exist, initialize a new table structure
        local itemContainer = registryRoot[targetItemId]
        
        if (itemContainer == nil) then
            itemContainer = {}
            registryRoot[targetItemId] = itemContainer
        end

        -- 3. Extract the unique hash key from the provided configuration object
        local entryHash = configurationObj["ID"]

        -- 4. Commit the tier data to the resolved container
        if entryHash then
            itemContainer[entryHash] = tierValue
        end
    end
end

-- SYSTEM: LIFECYCLE & HOOKS

local SystemCore = CreateFrame("Frame", ADDON_NAME .. "_CoreFrame")

-- List of tooltips to intercept
local TARGET_TOOLTIPS = {
    "GameTooltip",
    "ItemRefTooltip",
    "ShoppingTooltip1",
    "ShoppingTooltip2"
}

-- Safe hook implementation
local function InstallHooks()
    local function HandleTooltip(tooltip, data)
        pcall(function()
            TooltipRenderer:ProcessItem(tooltip, data)
        end)
    end

    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
        -- Modern client API (Dragonflight / The War Within / Midnight / Modern Beta)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, HandleTooltip)
    else
        -- Legacy client API fallback
        for _, tooltipName in ipairs(TARGET_TOOLTIPS) do
            local tooltipObject = _G[tooltipName]
            if tooltipObject and tooltipObject.HookScript then
                tooltipObject:HookScript("OnTooltipSetItem", function(self)
                    HandleTooltip(self)
                end)
            end
        end
    end
end

-- Event Handler
SystemCore:RegisterEvent("PLAYER_ENTERING_WORLD")
SystemCore:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        
        -- Boot Sequence
        ConfigManager:Initialize()
        InstallHooks()
        
        Logger:Log("System hooks established.")
    end
end)


-- PUBLIC API (ATLAS INTEGRATION POINTS)


--[[
    API: RegisterBIS
    Desc: Creates a definition entry for a specific class/spec configuration.
    Returns: The constructed entry object.
]]
function sliccNote:RegisterBIS(className, specName, commentText)
    -- Normalize inputs
    local safeClass = className
    local safeSpec = specName or ""
    local safeComment = commentText or ""
    
    -- Create Data Object
    local dataObject = {
        class = safeClass,
        spec = safeSpec,
        comment = safeComment
    }
    
    -- Generate deterministic unique ID
    dataObject.ID = string_format("%s%s%s", dataObject.class, dataObject.spec, dataObject.comment)
    
    -- Persist to global store
    sliccNote.BIS[dataObject.ID] = dataObject
    
    return dataObject
end