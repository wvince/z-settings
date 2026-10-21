-- Forever Companion — Consumables.lua
-- Consommables de raid BiS par spec

local FC = ForeverCompanion
-- Listes par spec (FC.ConsumesData) et ID des consommables (FC.CONSUME_IDS) :
-- données générées par le Studio (Data/Consumes.lua, Data/Dictionary.lua).

-- ============================================================
-- LOCALISATION
-- ============================================================
local _LC = {
    title       = "BiS Consumables",
    best_food   = "Best Food",
    alt_food    = "Alternative Food",
    best_flask  = "Best Flask/Elixirs",
    alt_flask   = "Alternative Flask",
    best_potion = "Best Potion",
    alt_potion  = "Alternative Potion",
}
local function InitConsumeLocale() end

-- ============================================================
-- FRAME CONSOMMABLES
-- ============================================================
local consumeFrame = nil
local CF_W, CF_H = 420, 480

local function GetPlayerSpecForConsumes()
    if FC and FC.DetectPlayerSpec then
        local cn, sn = FC:DetectPlayerSpec()
        if cn and sn then return cn, sn end
    end
    return nil, nil
end

local function CreateConsumeRow(parent, yOffset, headerText, consumeNames)
    -- Header
    local header = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    header:SetPoint("TOPLEFT", 16, -yOffset)
    header:SetTextColor(1, 0.84, 0)
    header:SetText(headerText)
    yOffset = yOffset + 20

    -- Items
    for _, name in ipairs(consumeNames) do
        local itemId = FC.CONSUME_IDS[name]
        if itemId == 0 then itemId = nil end
        local row = CreateFrame("Button", nil, parent)
        row:SetSize(CF_W - 40, 24)
        row:SetPoint("TOPLEFT", 24, -yOffset)

        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetSize(20, 20)
        icon:SetPoint("LEFT", 0, 0)
        icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

        local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("LEFT", icon, "RIGHT", 6, 0)
        label:SetText(name)

        if itemId then
            -- Charger icône + nom localisé
            local function refresh()
                local localName,_,quality,_,_,_,_,_,_,tex = ForeverCompanionAPI.GetItemInfo(itemId)
                if localName then
                    label:SetText(localName)
                    if quality then
                        local r,g,b = ForeverCompanionAPI.GetItemQualityColor(quality)
                        label:SetTextColor(r,g,b)
                    end
                end
                if tex then icon:SetTexture(tex) end
            end
            refresh()
            row.itemId = itemId
            row:RegisterEvent("GET_ITEM_INFO_RECEIVED")
            row:SetScript("OnEvent", function(self,_,id)
                if id == itemId then refresh() end
            end)

            row:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink("item:"..itemId)
                GameTooltip:Show()
            end)
            row:SetScript("OnLeave", function() GameTooltip:Hide() end)
            row:SetScript("OnClick", function(self, mouseBtn)
                ForeverCompanionAPI.ItemClick(itemId, { n = name }, mouseBtn)
            end)

            local hl = row:CreateTexture(nil, "HIGHLIGHT")
            hl:SetAllPoints()
            hl:SetColorTexture(1, 1, 1, 0.1)
        end

        yOffset = yOffset + 26
    end

    return yOffset + 6
end

local function OpenConsumeFrame(forceClass, forceSpec)
    local cn, sn
    if forceClass and forceSpec then
        cn, sn = forceClass, forceSpec
    else
        cn, sn = GetPlayerSpecForConsumes()
    end
    if not cn or not sn then
        print("|cFFFF6600Forever Companion|r : Spec non détectée.")
        return
    end
    local classData = FC.ConsumesData[cn]
    local specData = classData and classData[sn]
    if not specData then
        print("|cFFFF6600Forever Companion|r : Pas de consommables pour "..sn.." "..cn)
        return
    end

    if consumeFrame then
        consumeFrame:Hide()
        consumeFrame = nil
    end

    InitConsumeLocale()

    local f = ForeverCompanionAPI.CreateWindow("ForeverCompanionConsumeFrame", UIParent)
    consumeFrame = f
    FC.ConsumeFrame = f           -- fenêtre actuelle (utilisée par l'onglet de la fenêtre principale)
    f:SetSize(CF_W, CF_H)
    f:SetPoint("CENTER")
    f:SetFrameStrata("HIGH")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)

    ForeverCompanionAPI.CloseOnEscape(f)   -- fermeture par Échap

    -- Titre
    ForeverCompanionAPI.WindowTitle(f):SetText(_LC.title.." — "..sn.." "..cn)
    ForeverCompanionAPI.AddInset(f, 8, -30, -8, 8)

    -- Contenu
    local y = 40
    if specData.bestFood and #specData.bestFood > 0 then
        y = CreateConsumeRow(f, y, _LC.best_food, specData.bestFood)
    end
    if specData.food and #specData.food > 0 then
        y = CreateConsumeRow(f, y, _LC.alt_food, specData.food)
    end
    if specData.bestFlask and #specData.bestFlask > 0 then
        y = CreateConsumeRow(f, y, _LC.best_flask, specData.bestFlask)
    end
    if specData.flask and #specData.flask > 0 then
        y = CreateConsumeRow(f, y, _LC.alt_flask, specData.flask)
    end
    if specData.bestPotion and #specData.bestPotion > 0 then
        y = CreateConsumeRow(f, y, _LC.best_potion, specData.bestPotion)
    end
    if specData.potion and #specData.potion > 0 then
        y = CreateConsumeRow(f, y, _LC.alt_potion, specData.potion)
    end

    -- Ajuster la hauteur au contenu
    f:SetHeight(y + 14)
    f:Show()
end

-- ============================================================
-- COMMANDES & INTÉGRATION
-- ============================================================
SLASH_FCCONSUMES1 = "/fcconso"
SLASH_FCCONSUMES2 = "/bisconso"
SlashCmdList["FCCONSUMES"] = OpenConsumeFrame

function FC:OpenConsumeFrame()
    OpenConsumeFrame()
end

function FC:OpenConsumeFrameForSpec(cn, sn)
    OpenConsumeFrame(cn, sn)
end
