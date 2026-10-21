-- Forever Companion — Tooltip.lua
-- Affichage : icône de spec + regroupement par classe
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local C = {
    HEADER    = {r=1.00,g=1.00,b=0.00},
    HIGHLIGHT = {r=0.07,g=0.96,b=0.13},
    NORMAL    = {r=1.00,g=0.82,b=0.00},
    CLASS_SEP = {r=0.60,g=0.60,b=0.60},
    SOURCE    = {r=0.55,g=0.55,b=0.55},
    DIM       = {r=0.35,g=0.35,b=0.35},
    PHASE_HL_NORMAL = {r=1.00,g=1.00,b=1.00},  -- blanc: phase active sur spec normale
    PHASE_HL_SPEC   = {r=0.40,g=0.80,b=1.00},  -- cyan: phase active sur spec highlightée
}

local function addLine(tt,t,c) tt:AddLine(t,c.r,c.g,c.b,false) end
local function addDouble(tt,l,r,cl,cr)
    tt:AddDoubleLine(l,r,cl.r,cl.g,cl.b,cr.r,cr.g,cr.b)
end

local function iconStr(fileDataId)
    if not fileDataId or fileDataId==0 then return "" end
    return "|T"..fileDataId..":14:14:0:0|t "
end

local function groupByClass(entries, activePhase)
    -- Regroupe d'abord par class+spec, collecte les phases
    local specData = {}
    local specOrder = {}
    for _,e in ipairs(entries) do
        -- Inclure slot_display dans la clé pour garder MH et OH séparés
        local key = e.class_name.."|"..e.spec_name.."|"..(e.slot_display or "")
        if not specData[key] then
            specData[key] = {
                class_name=e.class_name, spec_name=e.spec_name,
                spec_key=e.spec_key or e.spec_name,
                slot_display=e.slot_display,
                phases={}, source="",
            }
            table.insert(specOrder, key)
        end
        table.insert(specData[key].phases, {phase=e.phase, rank=FC:EntryRank(e)})   -- rang dans la liste de ma faction
        if e.phase==activePhase or specData[key].source=="" then
            specData[key].source = e.source or ""
        end
    end

    -- Regrouper par classe
    local classData = {}
    local classOrder = {}
    for _,key in ipairs(specOrder) do
        local sd = specData[key]
        local cn = sd.class_name
        if not classData[cn] then
            classData[cn] = {}
            table.insert(classOrder, cn)
        end
        table.insert(classData[cn], sd)
    end
    table.sort(classOrder)
    return classData, classOrder
end


local function RenderBisEntries(tooltip, entries)
    local db=FC.db.char
    local activePhase=FC:ValidPhase(db.tooltip_phase, 2)

    local filtered={}
    for _,e in ipairs(entries) do
        if not FC:IsFiltered(e.class_name,e.spec_name) then
            table.insert(filtered,e)
        end
    end
    if #filtered==0 then return end

    -- Trier: highlighted en premier
    table.sort(filtered,function(a,b)
        local ha=FC:IsHighlighted(a.class_name,a.spec_name)
        local hb=FC:IsHighlighted(b.class_name,b.spec_name)
        if ha~=hb then return ha end
        if a.class_name~=b.class_name then return a.class_name<b.class_name end
        return a.spec_name<b.spec_name
    end)

    local classData, classOrder = groupByClass(filtered, activePhase)

    addLine(tooltip," ",C.DIM)
    -- Objet de l'autre faction : les rangs sont ceux des listes de sa faction
    local id1 = entries[1] and entries[1].itemId
    if id1 and FC:IsOtherFaction(id1) then
        local fac = FC:ItemFaction(id1)
        local hex = fac == "Horde" and "|cffe0403a" or "|cff4a8cff"
        tooltip:AddLine(hex .. fac .. " only|r: ranks in the " .. fac .. " BiS lists", 1, 1, 1, true)
    end

    -- Afficher la source (boss + drop%) du Top 1 pour la phase highlight
    local _phaseHL = FC:GetHighlightPhase()
    do
        local bestEntry = nil
        for _,e in ipairs(entries) do
            if e.phase == _phaseHL and (not bestEntry or FC:EntryRank(e) < FC:EntryRank(bestEntry)) then
                bestEntry = e
            end
        end
        if not bestEntry and #entries > 0 then bestEntry = entries[1] end
        if bestEntry then
            local src = bestEntry.source or ""
            local srcType = bestEntry.source_type or ""
            local drop = bestEntry.drop_chance
            local line = ""
            if src ~= "" and srcType ~= "" then
                if drop and drop > 0 then
                    line = srcType.." - "..src.." ("..math.floor(drop*100+0.5).."%)"
                else
                    line = src.." - "..srcType
                end
            elseif srcType ~= "" then
                line = srcType
            elseif src ~= "" then
                line = src
            end
            if line ~= "" then
                addLine(tooltip, line, C.SOURCE)
                addLine(tooltip," ",C.DIM)
            end
        end
    end
    local _hlEnabled = FC.db.char.phase_highlight_enabled
    if _hlEnabled == nil then _hlEnabled = true end
    local _hParts = {}
    for _,ph in ipairs(FC.PHASES) do
        if _hlEnabled and ph == _phaseHL then
            table.insert(_hParts, "|cffffffff"..FC:PhaseLabel(ph).."|r")
        else
            table.insert(_hParts, FC:PhaseLabel(ph))
        end
    end
    addDouble(tooltip, "Spec name", table.concat(_hParts,"/"), C.HEADER, C.HEADER)

    for _,cn in ipairs(classOrder) do
        local cc = FC.CLASS_COLORS[cn] or {r=1,g=1,b=1}
        local classHex = string.format("|cff%02x%02x%02x",cc.r*255,cc.g*255,cc.b*255)
        local classIcon = iconStr(FC:GetClassIcon(cn))

        -- En-tête de classe
        addLine(tooltip, classIcon..classHex..cn.."|r", C.CLASS_SEP)

        for _,sd in ipairs(classData[cn]) do
            local highlighted = FC:IsHighlighted(cn,sd.spec_name)
            local col = highlighted and C.HIGHLIGHT or C.NORMAL
            local specIcon = iconStr(FC:GetSpecIcon(cn, sd.spec_key or sd.spec_name))

            -- Rangs par phase avec highlight de la phase active
            local rankByPhase={}
            for _,pe in ipairs(sd.phases) do rankByPhase[pe.phase]=pe.rank end
            local phaseHL = _phaseHL
            local hlEnabled = FC.db.char.phase_highlight_enabled
            if hlEnabled == nil then hlEnabled = true end
            local hlColor = highlighted and "|cff66ccff" or "|cffffffff"
            local parts={}
            for _,ph in ipairs(FC.PHASES) do
                local r = rankByPhase[ph]
                local s = " "..(r and tostring(r) or "-").." "
                if hlEnabled and ph == phaseHL then
                    s = hlColor..s.."|r"
                end
                table.insert(parts, s)
            end

            local dispName = sd.spec_name
            if sd.slot_display then
                dispName = dispName.." ("..sd.slot_display..")"
            end
            addDouble(tooltip,
                "  "..specIcon..dispName,
                table.concat(parts," / "), col, col)
        end
    end

    if #filtered<#entries then
        addLine(tooltip," Alt: show all",C.DIM)
    end
end

local function OnItemTooltip(tooltip, itemId)
    if not itemId or not FC.db then return end
    local priceId, shown = itemId, false

    -- Plan de craft → infos BiS de l'objet fabriqué
    local craftedId = FC.RECIPE_TO_ITEM and FC.RECIPE_TO_ITEM[itemId]
    if craftedId and craftedId > 0 then
        itemId = craftedId
    end

    -- Token de set → items BiS du token
    local tokenEntries = FC:GetEntriesForToken(itemId)
    if tokenEntries and #tokenEntries > 0 then
        RenderBisEntries(tooltip, tokenEntries)
        shown = true
    else
        local entries = FC:GetEntriesForItem(itemId)
        if entries and #entries > 0 then RenderBisEntries(tooltip, entries); shown = true end
    end
    -- Valeur d'après l'échelle de stats active, comparée à l'objet porté (Scales.lua)
    if FC.Scales and FC.Scales.AddTooltipLine(tooltip) then shown = true end
    -- Prix de l'hôtel des ventes (objet survolé, pas l'objet fabriqué)
    if FC.AddPriceLines and FC:AddPriceLines(tooltip, priceId) then shown = true end
    -- Combien en ont mes personnages (sacs, banque, courrier, HV) (Inventory.lua)
    if FC.AddInventoryLines and FC:AddInventoryLines(tooltip, priceId) then shown = true end
    if shown then tooltip:Show() end   -- recalcule la taille du tooltip
end
FC.OnItemTooltip = OnItemTooltip   -- exposé pour les tests

local refreshFrame = CreateFrame("Frame")
function FC:initTooltip()
    self.tooltipHook = API.HookItemTooltips(OnItemTooltip)
    -- ALT : afficher toutes les specs (y compris filtrées)
    refreshFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
    refreshFrame:SetScript("OnEvent", function(_, _, key)
        if key == "LALT" or key == "RALT" or key == "LSHIFT" or key == "RSHIFT" then   -- Maj : prix de la pile
            API.RefreshTooltip(GameTooltip)
        end
    end)
end
