-- Forever Companion — Inspect.lua
-- Bouton "BiS List" dans la fenêtre d'inspection
-- - Détecte la classe/spec du joueur inspecté (talents, flag inspect)
-- - Surligne en bleu dans la Bislist les items BiS qu'il porte déjà
-- - Attend INSPECT_READY si les données ne sont pas encore chargées

local inspectBisBtn   = nil
local lastReadyGuid   = nil   -- GUID du dernier INSPECT_READY reçu
local pendingOpen     = false -- ouverture différée en attente de INSPECT_READY

local FC = ForeverCompanion

local function GetInspectUnit()
    return (InspectFrame and InspectFrame.unit) or "target"
end

-- Détecte classe + spec du joueur inspecté : l'arbre dominant donne la spec
-- (correspondance arbre → spec définie dans le Studio, FC.TAB_TO_SPEC)
local function DetectInspectedSpec()
    local unit = GetInspectUnit()
    if not UnitExists(unit) or not UnitIsPlayer(unit) then return nil, nil end

    local _, classEn = UnitClass(unit)
    local cn = FC:ClassFromToken(classEn)
    if not cn then return nil, nil end

    local bestTab, bestPoints, totalPoints = FC:CountTalentPoints(true, unit)
    local debug = FC.db and FC.db.char and FC.db.char.inspectDebug
    if not bestTab or totalPoints == 0 then
        if debug then
            print("|cFFFF6600BiS Debug|r: "..cn.." totalPoints=0 (talents pas chargés)")
        end
        return cn, nil
    end
    local sn = FC:SpecFromTab(cn, bestTab)
    if debug then
        print(string.format("|cFFFF6600BiS Debug|r: %s | tab gagnant=%d (%d pts) | total=%d | spec=%s",
            cn, bestTab, bestPoints, totalPoints, tostring(sn)))
    end
    return cn, sn
end

-- Commande pour activer/désactiver le debug d'inspection
SLASH_FCINSPECTDEBUG1 = "/fcdebug"
SLASH_FCINSPECTDEBUG2 = "/bisdebug"
SlashCmdList["FCINSPECTDEBUG"] = function()
    if not FC.db or not FC.db.char then return end
    FC.db.char.inspectDebug = not FC.db.char.inspectDebug
    print("|cFFFF6600Forever Companion|r : debug inspection "..(FC.db.char.inspectDebug and "ACTIVÉ" or "désactivé"))
end

-- Scanne les 19 slots d'équipement du joueur inspecté
local function ScanInspectedItems()
    local unit = GetInspectUnit()
    if not UnitExists(unit) then return nil end
    local items = {}
    local found = false
    for slot = 1, 19 do
        local id = GetInventoryItemID(unit, slot)
        if id then items[id] = true; found = true end
    end
    return found and items or nil
end

local function DoOpenBislist()
    local cn, sn = DetectInspectedSpec()
    if not cn then
        print("|cFFFF6600Forever Companion|r : Aucun joueur inspecté.")
        return
    end
    -- Items équipés du joueur inspecté -> bordures bleues dans la liste
    -- (remplace la sélection précédente : reset automatique entre inspections)
    if FC.SetInspectedItems then
        FC:SetInspectedItems(ScanInspectedItems())
    end
    if FC.OpenBislistForSpec then
        FC:OpenBislistForSpec(cn, sn)
    end
end

local function OnInspectBisClick()
    local unit = GetInspectUnit()
    if not UnitExists(unit) or not UnitIsPlayer(unit) then
        print("|cFFFF6600Forever Companion|r : Aucun joueur inspecté.")
        return
    end
    -- Si les données d'inspection ne correspondent pas au joueur affiché,
    -- relancer une inspection et ouvrir quand INSPECT_READY arrive
    if UnitGUID(unit) ~= lastReadyGuid then
        pendingOpen = true
        if CanInspect(unit) then
            NotifyInspect(unit)
            -- Sécurité : abandonner après 2s si rien ne revient
            C_Timer.After(2, function()
                if pendingOpen then
                    pendingOpen = false
                    DoOpenBislist() -- tenter quand même avec ce qu'on a
                end
            end)
        else
            pendingOpen = false
            DoOpenBislist()
        end
    else
        DoOpenBislist()
    end
end

local function CreateInspectBisButton()
    if inspectBisBtn then return end
    if not InspectFrame then return end

    inspectBisBtn = CreateFrame("Button", "ForeverCompanionInspectBtn", UIParent, "UIPanelButtonTemplate")
    inspectBisBtn:SetSize(90, 22)
    inspectBisBtn:SetText("BiS List")
    inspectBisBtn:SetFrameStrata("DIALOG")
    inspectBisBtn:SetFrameLevel(100)
    inspectBisBtn:SetPoint("BOTTOMRIGHT", InspectFrame, "TOPRIGHT", 0, -2)
    inspectBisBtn:SetScript("OnClick", OnInspectBisClick)

    ForeverCompanionAPI.AttachToFrame(inspectBisBtn, InspectFrame)
    InspectFrame:HookScript("OnHide", function()
        pendingOpen = false
        -- Fin d'inspection : retirer les bordures bleues et re-render la liste
        if FC.HasInspectedItems and FC:HasInspectedItems() then
            FC:ClearInspectedItems()
            if FC.RefreshBislist then
                FC:RefreshBislist()
            end
        end
    end)
end

local evtFrame = CreateFrame("Frame")
evtFrame:RegisterEvent("ADDON_LOADED")
evtFrame:RegisterEvent("PLAYER_LOGIN")
evtFrame:RegisterEvent("INSPECT_READY")
evtFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Blizzard_InspectUI" then
        CreateInspectBisButton()
    elseif event == "PLAYER_LOGIN" then
        if InspectFrame then CreateInspectBisButton() end
    elseif event == "INSPECT_READY" then
        lastReadyGuid = arg1
        if pendingOpen then
            pendingOpen = false
            DoOpenBislist()
        end
    end
end)
