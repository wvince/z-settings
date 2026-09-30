-- By D4KiR
local _, SpecBisTooltip = ...
local function GetCatalystItemName(itemId)
    local itemName = SpecBisTooltip:GetItemInfo(itemId)
    if itemName == nil or itemName == "" then return tostring(itemId) end
    return itemName
end

local function GetCatalystItemSlot(itemId)
    local invType = select(4, SpecBisTooltip:GetItemInfoInstant(itemId))
    if invType == nil or invType == "" then return "" end
    return SpecBisTooltip:Trans("LID_" .. invType)
end

local function GetCatalystRawSource(rawItemId)
    if SpecBisTooltip.GetCatalystTable == nil then return "" end
    local catalystTab = SpecBisTooltip:GetCatalystTable()
    if catalystTab == nil then return "" end
    local buildTab = catalystTab[SpecBisTooltip:GetBisPool()]
    if buildTab == nil then return "" end
    local rawSourceId = buildTab[rawItemId]
    if rawSourceId == nil then return "" end
    if string.find(rawSourceId, "catalyst", 1, true) == 1 then return "" end
    local _, rawSourceName, rawSourceLocation = SpecBisTooltip:GetSource(rawSourceId)
    if rawSourceName == nil or rawSourceName == "" then return "" end
    if rawSourceLocation and rawSourceLocation ~= "" then return rawSourceName .. ", " .. rawSourceLocation end
    return rawSourceName
end

function SpecBisTooltip:GetSource(sourceId)
    if sourceId == nil then return "", "" end
    if sourceId == "npc;sold=213278" then return "catalyst", nil, nil end -- DF
    if sourceId == "npc;sold=224270" then return "catalyst", nil, nil end -- TWW
    if sourceId == "npc;sold=213285" then return "catalyst", nil, nil end
    if sourceId == "catalyst/unknown" then return "catalyst", nil, nil end
    local rawItemId = tonumber(string.match(sourceId, "^catalyst;item=(%d+)$"))
    if rawItemId then return "catalyst", GetCatalystItemName(rawItemId), GetCatalystRawSource(rawItemId) end
    local tierItemId = tonumber(string.match(sourceId, "^catalyst;into=(%d+)$"))
    if tierItemId then return "catalystinto", GetCatalystItemName(tierItemId), GetCatalystItemSlot(tierItemId) end
    local sourceMap = SpecBisTooltip:GetTranslationMap()
    if sourceMap == nil then return "", "" end
    local sourceEntry = sourceMap[sourceId]
    local location = ""
    if sourceEntry then
        if type(sourceEntry) == "table" then
            location = sourceEntry[2]
            sourceEntry = sourceEntry[1]
        end

        local sepPos = string.find(sourceId, "=")
        if sepPos ~= nil then
            local sourceKind = string.sub(sourceId, 1, sepPos - 1)
            return sourceKind, sourceEntry, location
        else
            SpecBisTooltip:MSG("FAILED TO FIND", sourceId)
        end
    end
    return nil, nil, nil
end

local lang = GetLocale()
if SpecBisTooltip.TranslationenUS then
    SpecBisTooltip:TranslationenUS()
    if lang == "deDE" then
        SpecBisTooltip:TranslationdeDE()
    elseif lang == "esES" then
        SpecBisTooltip:TranslationesES()
    elseif lang == "frFR" then
        SpecBisTooltip:TranslationfrFR()
    elseif lang == "itIT" then
        SpecBisTooltip:TranslationitIT()
    elseif lang == "koKR" then
        SpecBisTooltip:TranslationkoKR()
    elseif lang == "ptBR" then
        SpecBisTooltip:TranslationptBR()
    elseif lang == "ruRU" then
        SpecBisTooltip:TranslationruRU()
    elseif lang == "zhCN" then
        SpecBisTooltip:TranslationzhCN()
    elseif lang == "zhTW" then
        SpecBisTooltip:TranslationzhTW()
    end
else
    SpecBisTooltip:MSG("Missing TRANSLATIONS")
end
