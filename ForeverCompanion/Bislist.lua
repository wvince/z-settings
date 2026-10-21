-- Forever Companion — Bislist.lua
-- Icônes chargées via GET_ITEM_INFO_RECEIVED (même méthode qu'AtlasLoot)

local FW=570; local FH=640
local ICON=36; local MINI=18; local GAP=2
local SLOT_COL=120; local GEM_COL=130
local ROW_H=ICON+GAP*2+4

local FC = ForeverCompanion
local API = ForeverCompanionAPI
-- Libellés d'emplacements, enchantements et gemmes : dictionnaires générés par le Studio
local function SLOT_LABEL(slot) return FC.SLOT_LABELS[slot] or slot end
local function ENCHANT(name) return FC.ENCHANT_DATA[name] end
local function GEM_ID(name) return FC.GEM_ITEMS[name] end

-- ── Système de chargement d'icônes (copié d'AtlasLoot) ───────────────────────
-- Quand GetItemInfo retourne nil, on enregistre le bouton et on attend
-- l'event GET_ITEM_INFO_RECEIVED pour le re-render
local pendingItems = {}  -- itemId -> list of textures à mettre à jour

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(_, event, itemId)
    if event == "GET_ITEM_INFO_RECEIVED" and itemId and pendingItems[itemId] then
        local icon = API.GetItemIcon(itemId)
        if icon then
            for _, tex in ipairs(pendingItems[itemId]) do
                if tex:GetParent() then tex:SetTexture(icon) end
            end
        end
        pendingItems[itemId] = nil
        if not next(pendingItems) then
            eventFrame:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
        end
    end
end)

local function setItemTexture(tex, itemId)
    if not itemId or itemId == 0 then
        tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        return
    end
    local icon = API.GetItemIcon(itemId)
    if icon then
        tex:SetTexture(icon)
    else
        tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        -- Enregistrer pour mise à jour via event
        if not pendingItems[itemId] then
            pendingItems[itemId] = {}
            eventFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
        end
        table.insert(pendingItems[itemId], tex)
    end
end

local function setEnchantTexture(tex, enchName)
    local d = ENCHANT(enchName)
    if not d then tex:SetTexture("Interface\\Icons\\Trade_Engraving"); return end
    if d.t == "item" then
        -- Item achetable (glyphe, inscription, kit jambe, scope) → icône via GetItemInfo
        setItemTexture(tex, d.id)
    else
        -- Enchant pur (spell) → GetSpellInfo retourne l'icône correcte
        local icon = API.GetSpellIcon(d.id)
        tex:SetTexture(icon or d.tex or "Interface\\Icons\\Trade_Engraving")
    end
end

-- ── Nettoyage ─────────────────────────────────────────────────────────────────
local mainFrame=nil; local scrollChild=nil; local rowPool={}

local function cleanRows()
    for _,r in ipairs(rowPool) do r:Hide(); r:SetParent(nil) end
    rowPool={}
    if scrollChild then
        for _,c in ipairs({scrollChild:GetChildren()}) do c:Hide(); c:SetParent(nil) end
    end
end

-- ── Bouton item ───────────────────────────────────────────────────────────────
-- Items équipés par le joueur actuellement inspecté (itemID -> true)
local inspectedItems = nil

-- Choix manuel de spec pendant la SESSION (non sauvegardé : remis à zéro à
-- chaque reload/reconnexion, ce qui fait repartir sur la spec réelle du joueur).
local sessionClass, sessionSpec = nil, nil

function FC:SetInspectedItems(t)
    inspectedItems = t
end

function FC:ClearInspectedItems()
    inspectedItems = nil
end

function FC:HasInspectedItems()
    return inspectedItems ~= nil
end

local function makeItemBtn(parent, item, posX, posY)
    if not item or not item.itemId or item.itemId==0 then return end
    local itemId=item.itemId

    local btn=CreateFrame("Button",nil,parent)
    btn:SetSize(ICON,ICON)
    btn:SetPoint("TOPLEFT",parent,"TOPLEFT",posX,-posY)
    btn.itemId=itemId

    local bg=btn:CreateTexture(nil,"BACKGROUND")
    bg:SetAllPoints(); bg:SetColorTexture(0,0,0,0.75)

    local tex=btn:CreateTexture(nil,"ARTWORK")
    tex:SetPoint("TOPLEFT",btn,"TOPLEFT",1,-1)
    tex:SetPoint("BOTTOMRIGHT",btn,"BOTTOMRIGHT",-1,1)
    tex:SetTexCoord(0.08,0.92,0.08,0.92)
    setItemTexture(tex, itemId)

    -- Contour vert si équipé
    local function checkEquipped()
        for slot=1,19 do
            if GetInventoryItemID("player",slot)==itemId then
                local function mkBorder(p1,p2,isH)
                    local b=btn:CreateTexture(nil,"OVERLAY")
                    b:SetColorTexture(0,1,0,1)
                    if isH then b:SetHeight(2); b:SetPoint(p1,btn,p1); b:SetPoint(p2,btn,p2)
                    else b:SetWidth(2); b:SetPoint(p1,btn,p1); b:SetPoint(p2,btn,p2) end
                end
                mkBorder("TOPLEFT","TOPRIGHT",true); mkBorder("BOTTOMLEFT","BOTTOMRIGHT",true)
                mkBorder("TOPLEFT","BOTTOMLEFT",false); mkBorder("TOPRIGHT","BOTTOMRIGHT",false)
                return
            end
        end
    end
    checkEquipped()

    -- Contour bleu si équipé par le joueur inspecté
    if inspectedItems and inspectedItems[itemId] then
        local function mkBlueBorder(p1,p2,isH)
            local b=btn:CreateTexture(nil,"OVERLAY")
            b:SetColorTexture(0.2,0.5,1,1)
            if isH then b:SetHeight(2); b:SetPoint(p1,btn,p1); b:SetPoint(p2,btn,p2)
            else b:SetWidth(2); b:SetPoint(p1,btn,p1); b:SetPoint(p2,btn,p2) end
        end
        mkBlueBorder("TOPLEFT","TOPRIGHT",true); mkBlueBorder("BOTTOMLEFT","BOTTOMRIGHT",true)
        mkBlueBorder("TOPLEFT","BOTTOMLEFT",false); mkBlueBorder("TOPRIGHT","BOTTOMRIGHT",false)
    end

    btn:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
        GameTooltip:SetItemByID(itemId)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    btn:SetScript("OnClick",function(self, mouseBtn)
        local it = FC.ITEMS[itemId] or {}
        API.ItemClick(itemId, { n = it.n }, mouseBtn)
    end)
    return btn
end

-- ── Mini bouton enchant ───────────────────────────────────────────────────────
local function makeEnchantBtn(parent,enchName,posX,posY)
    local btn=CreateFrame("Button",nil,parent)
    btn:SetSize(MINI,MINI)
    btn:SetPoint("TOPLEFT",parent,"TOPLEFT",posX,-posY)
    local bg=btn:CreateTexture(nil,"BACKGROUND"); bg:SetAllPoints(); bg:SetColorTexture(0,0,0,0.6)
    local tex=btn:CreateTexture(nil,"ARTWORK")
    tex:SetPoint("TOPLEFT",btn,"TOPLEFT",1,-1); tex:SetPoint("BOTTOMRIGHT",btn,"BOTTOMRIGHT",-1,1)
    tex:SetTexCoord(0.08,0.92,0.08,0.92)
    setEnchantTexture(tex, enchName)
    btn:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
        local d=ENCHANT(enchName)
        if d and d.id and d.id>0 then
            local ok=pcall(function()
                GameTooltip:SetHyperlink(d.t..":"..d.id)
            end)
            if not ok then GameTooltip:AddLine(enchName,0.4,0.8,1) end
        else
            GameTooltip:AddLine(enchName,0.4,0.8,1)
        end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    btn:SetScript("OnClick",function(self, mouseBtn)
        if mouseBtn ~= "LeftButton" then return end
        local d=ENCHANT(enchName)
        if not d or not d.id or d.id<=0 then return end
        local link
        if d.t == "item" then
            -- Parchemin/glyphe/inscription : lien item standard
            link = select(2, API.GetItemInfo(d.id))
        else
            -- Enchant de sort : récupérer le nom localisé du sort et créer un lien spell clickable
            local spellName = API.GetSpellName(d.id)
            if spellName then
                link = API.GetSpellLink(d.id)
                if not link then
                    link = "|cff71d5ff|Hspell:"..d.id.."|h["..spellName.."]|h|r"
                end
            end
        end
        if link then
            -- HandleModifiedItemClick gère chat, hôtel des ventes, craft, etc.
            if not HandleModifiedItemClick(link) then
                ChatEdit_InsertLink(link)
            end
        end
    end)
end

-- ── Mini bouton gem ───────────────────────────────────────────────────────────
local function makeGemBtn(parent,gemName,posX,posY)
    local btn=CreateFrame("Button",nil,parent)
    btn:SetSize(MINI,MINI)
    btn:SetPoint("TOPLEFT",parent,"TOPLEFT",posX,-posY)
    local bg=btn:CreateTexture(nil,"BACKGROUND"); bg:SetAllPoints(); bg:SetColorTexture(0,0,0,0.6)
    local tex=btn:CreateTexture(nil,"ARTWORK")
    tex:SetPoint("TOPLEFT",btn,"TOPLEFT",1,-1); tex:SetPoint("BOTTOMRIGHT",btn,"BOTTOMRIGHT",-1,1)
    tex:SetTexCoord(0.08,0.92,0.08,0.92)
    local gemId=GEM_ID(gemName)
    if gemId and gemId>0 then
        setItemTexture(tex, gemId)
    else
        tex:SetTexture("Interface\\Icons\\INV_Jewelcrafting_gem_01")
    end
    btn:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
        local gid=GEM_ID(gemName)
        if gid and gid>0 then GameTooltip:SetItemByID(gid)
        else GameTooltip:AddLine(gemName,0.8,0.55,1) end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    btn:SetScript("OnClick",function(self, mouseBtn)
        if mouseBtn ~= "LeftButton" then return end
        local gid=GEM_ID(gemName)
        if gid and gid>0 then API.ItemClick(gid, { n = gemName }, mouseBtn) end
    end)
end

-- ── Ligne slot ────────────────────────────────────────────────────────────────
local viewFaction=nil   -- faction de la liste affichée (logo à côté de la phase) ; nil = la mienne
local function makeRow(parent,yOff,slotEntry,rowIdx)
    -- Objets de l'autre faction retirés (filtre des options) : les suivants remontent d'un rang
    local items={}
    for _,it in ipairs(slotEntry.items or {}) do
        if not FC:IsOtherFaction(it.itemId, nil, viewFaction) then items[#items+1]=it end
    end
    local item1=items[1]
    local hasE=item1 and item1.enchant and item1.enchant.name and item1.enchant.name~=""
    local hasG=item1 and item1.gems and #item1.gems>0

    local row=CreateFrame("Frame",nil,parent)
    row:SetSize(FW-32,ROW_H); row:SetPoint("TOPLEFT",parent,"TOPLEFT",0,-yOff)
    API.RowBackground(row,rowIdx)

    local curX=4

    -- Slot label
    local slotLbl=row:CreateFontString(nil,"OVERLAY","GameFontNormal")
    slotLbl:SetPoint("TOPLEFT",row,"TOPLEFT",curX,-(ROW_H-16)/2)
    slotLbl:SetText(SLOT_LABEL(slotEntry.slot))
    slotLbl:SetWidth(SLOT_COL-4); slotLbl:SetJustifyH("LEFT")
    curX=curX+SLOT_COL

    -- Séparateur
    local s1=row:CreateTexture(nil,"ARTWORK"); s1:SetColorTexture(unpack(API.COLORS.sep)); s1:SetWidth(1)
    s1:SetPoint("TOPLEFT",row,"TOPLEFT",curX,0); s1:SetPoint("BOTTOMLEFT",row,"BOTTOMLEFT",curX,0)
    curX=curX+5

    -- Améliorations : enchantement (ligne du haut), gemmes ou autres (ligne du bas)
    do
    local row1Y=(ROW_H/2-MINI)/2
    local row2Y=ROW_H/2+(ROW_H/2-MINI)/2
    local enchX=curX

    if hasE then
        makeEnchantBtn(row,item1.enchant.name,enchX,row1Y)
        enchX=enchX+MINI+3
    end
    if hasG then
        local gemX=curX
        for _,gem in ipairs(item1.gems) do
            if gem.name and gem.name~="" then
                makeGemBtn(row,gem.name,gemX,row2Y)
                gemX=gemX+MINI+3
            end
        end
    end
    curX=curX+GEM_COL

    -- Séparateur
    local s2=row:CreateTexture(nil,"ARTWORK"); s2:SetColorTexture(unpack(API.COLORS.sep)); s2:SetWidth(1)
    s2:SetPoint("TOPLEFT",row,"TOPLEFT",curX,0); s2:SetPoint("BOTTOMLEFT",row,"BOTTOMLEFT",curX,0)
    curX=curX+5
    end

    -- Icônes items 1-6
    local iconY=(ROW_H-ICON)/2
    for rank=1,6 do
        local item=items[rank]
        if item and item.itemId and item.itemId>0 then
            local b=makeItemBtn(row,item,curX+(rank-1)*(ICON+GAP),iconY)
            row.firstBtn=row.firstBtn or b   -- exemple d'infobulle (tour guidé)
        end
    end


    table.insert(rowPool,row)
    return ROW_H+1
end

-- ── Rendu ─────────────────────────────────────────────────────────────────────
local function renderList(cn,sn,ph)
    cleanRows()
    if not cn or not sn or not ph then return end
    local slots=((FC.BisData[cn] or {})[sn] or {})[ph]
    if not slots or #slots==0 then
        local m=scrollChild:CreateFontString(nil,"OVERLAY","GameFontNormal")
        m:SetPoint("TOPLEFT",scrollChild,"TOPLEFT",10,-10)
        m:SetText("|cffff8800No data for "..cn.." "..sn.." "..FC:PhaseLabel(ph).."|r")
        return
    end
    -- On ne mémorise QUE la phase (la classe/spec suivent la détection + session)
    FC.db.char.bislist_phase=ph
    if mainFrame and mainFrame.statsPanel and mainFrame.statsPanel:IsShown() then
        mainFrame.statsPanel.refresh(cn, sn)
    end
    local yOff=0
    for i,slotEntry in ipairs(slots) do yOff=yOff+makeRow(scrollChild,yOff,slotEntry,i) end
    scrollChild:SetHeight(math.max(yOff+2,200))
end

-- ── Fenêtre ───────────────────────────────────────────────────────────────────

-- ══════════════════════════════════════════════════════════════════════════
-- STATS CAP — caps de stats TBC par spec + valeurs actuelles du joueur
-- ══════════════════════════════════════════════════════════════════════════
-- API TBC Classic : CR_HIT_MELEE=6, CR_HIT_RANGED=7, CR_HIT_SPELL=8,
--                   CR_EXPERTISE=24 ; GetCombatRatingBonus(cr) -> %
local function fmtPct(v) return string.format("%.2f%%", v or 0) end

-- ── Libellés du panneau Stats Cap (anglais) ──────────────────────────────
local _LS = {
    title="Stats Cap", cap="Cap", current="Current (you)",
    hit_spell="Spell Hit", hit_melee="Melee Hit", hit_ranged="Ranged Hit",
    crit_spell="Spell Crit", crit="Crit", expertise="Expertise",
    defense="Defense", avoidance="Total Avoidance",
    no_cap_heal="No cap (healing)", reduced_tal="reduced by talents",
    specials="specials", auto_dw="auto (DW)", dodge="dodge",
    anticrit="anti-crit (boss)", anticrush="anti-crush", resi="+ resilience",
    incl_tal="talents included", wskill="with 305 weapon skill",
}
if GetLocale and GetLocale() == "frFR" then
    _LS.current = "Actuel (toi)"; _LS.no_cap_heal = "Pas de cap (soins)"; _LS.specials = "techniques"
    _LS.incl_tal = "talents compris"; _LS.wskill = "avec 305 en compétence d'arme"; _LS.avoidance = "Évitement total"
    _LS.hit_spell = "Toucher (sorts)"; _LS.hit_melee = "Toucher (mêlée)"; _LS.hit_ranged = "Toucher (distance)"
    _LS.crit_spell = "Critique (sorts)"; _LS.crit = "Critique"; _LS.defense = "Défense"
end
local function InitStatsLocale() end

-- Hit TOTAL = rating équipement + modificateurs (talents, raciaux, buffs)
-- GetSpellHitModifier / GetHitModifier renvoient le hit HORS rating d'équipement.
local function curSpellHit()
    local gear = GetCombatRatingBonus(8) or 0
    local extra = 0
    if GetSpellHitModifier then
        local ok, v = pcall(GetSpellHitModifier)
        if ok and v then extra = v end
    end
    return fmtPct(gear + extra)
end
local function curMeleeHit()
    local gear = GetCombatRatingBonus(6) or 0
    local extra = 0
    if GetHitModifier then
        local ok, v = pcall(GetHitModifier)
        if ok and v then extra = v end
    end
    return fmtPct(gear + extra)
end
local function curRangedHit()
    local gear = GetCombatRatingBonus(7) or 0
    local extra = 0
    -- En TBC le hit distance partage le même modificateur que la mêlée (talents/raciaux)
    if GetHitModifier then
        local ok, v = pcall(GetHitModifier)
        if ok and v then extra = v end
    end
    return fmtPct(gear + extra)
end
-- ── Raciaux d'expertise TBC ───────────────────────────────────────────────
-- +5 expertise (1.25% dodge) sur la MAIN équipée du bon type d'arme.
-- Identification par subclassID NUMÉRIQUE (classID arme = 2, stable/non localisé).
-- subclassID : 0=Hache1M 1=Hache2M 4=Masse1M 5=Masse2M 7=Épée1M 8=Épée2M 15=Dague
-- L'expertise s'applique par main (main droite slot 16, main gauche slot 17).
local RACE_WEAPON_EXP = {
    Human = { [7]=true, [8]=true, [4]=true, [5]=true },  -- épées + masses
    Orc   = { [0]=true, [1]=true },                      -- haches
}

local function weaponSubClass(slotId)
    local link = GetInventoryItemLink("player", slotId)
    if not link then return nil end
    local _, _, _, _, _, classID, subClassID = API.GetItemInfoInstant(link)
    if classID ~= 2 then return nil end
    return subClassID
end

-- Nombre de mains bénéficiant du racial (0, 1 ou 2)
-- Racial d'expertise (en POINTS) pour une main donnée selon l'arme qui s'y trouve
local function racialExpertiseForHand(slotId)
    local _, raceToken = UnitRace("player")
    local map = RACE_WEAPON_EXP[raceToken]
    if not map then return 0 end
    local sub = weaponSubClass(slotId)
    return (sub and map[sub]) and 5 or 0
end

-- Le joueur est-il ambidextre (arme en main gauche) ?
local function isDualWielding()
    return weaponSubClass(17) ~= nil
end

-- Convertit des points d'expertise en % d'esquive retirée (1 exp = 0.25%)
local function expPointsToPct(pts) return pts * 0.25 end

-- En TBC l'expertise du rating est ARRONDIE VERS LE BAS pour les calculs de combat.
-- 1 point d'expertise = 3.9423 rating et = 0.25% dodge/parry retiré.
-- On affiche le score effectif (floor, ce que le jeu utilise) avec une décimale
-- pour montrer la progression vers le point suivant.
local EXP_RATING_PER_POINT = 3.9423
local function curExpertise()
    -- GetExpertise() retourne directement le score d'expertise (TBC).
    -- Il INCLUT déjà les raciaux et talents calculés par le jeu, donc on
    -- ne ré-additionne PAS les raciaux par-dessus (sinon double comptage).
    local gearScore = nil
    if GetExpertise then
        local ok, e = pcall(GetExpertise)
        if ok and e then gearScore = e end
    end

    if gearScore then
        -- Le jeu nous donne le score total directement (gear + racial + talents)
        return string.format("%.2f%% (%.1f exp)", gearScore * 0.25, gearScore).." "..(_LS.dodge or "")
    end

    -- Fallback si GetExpertise absent : % natif + racial manuel
    local gearPct = 0
    local ok, v = pcall(GetCombatRatingBonus, 24)
    if ok and v then gearPct = v end
    local gearRaw = gearPct / 0.25
    local mhRacial = racialExpertiseForHand(16)
    local ohRacial = racialExpertiseForHand(17)
    local function line(pct, raw)
        return string.format("%.2f%% (%.1f exp)", pct, raw)
    end
    if isDualWielding() and mhRacial ~= ohRacial then
        return string.format("MH %s / OH %s",
            line(gearPct + expPointsToPct(mhRacial), gearRaw + mhRacial),
            line(gearPct + expPointsToPct(ohRacial), gearRaw + ohRacial))
    else
        return line(gearPct + expPointsToPct(mhRacial), gearRaw + mhRacial).." "..(_LS.dodge or "")
    end
end
local function curDefense()
    if not UnitDefense then return "—" end
    local base, mod = UnitDefense("player")
    return tostring((base or 0) + (mod or 0))
end
local function curAvoidance()
    local d = GetDodgeChance() or 0
    local p = GetParryChance() or 0
    local b = GetBlockChance() or 0
    return fmtPct(d + p + b + 5)
end
-- ── Raciaux de crit sur armes à distance ──────────────────────────────────
-- Nain : +1% crit armes à feu (subclassID 3). Troll : +1% crit arcs (2) et jet (16).
-- Slot distance = 18.
local function rangedCritRacialBonus()
    local _, raceToken = UnitRace("player")
    local link = GetInventoryItemLink("player", 18)
    if not link then return 0 end
    local _, _, _, _, _, classID, subClassID = API.GetItemInfoInstant(link)
    if classID ~= 2 then return 0 end
    if raceToken == "Dwarf" and subClassID == 3 then return 1 end          -- armes à feu
    if raceToken == "Troll" and (subClassID == 2 or subClassID == 16) then return 1 end  -- arcs / jet
    return 0
end

-- Note : le hit draeneï (Présence inspirante, +1%) est une aura passive toujours
-- active, donc GetSpellHitModifier()/GetHitModifier() l'incluent déjà dans le hit
-- total. On ne l'ajoute pas manuellement pour éviter un double comptage.

local function curSpellCrit() return fmtPct(GetSpellCritChance(2)) end
local function curMeleeCrit()
    -- crit mêlée de base (talents/raciaux/gear inclus)
    return fmtPct(GetCritChance())
end
local function curRangedCrit()
    -- GetRangedCritChance inclut gear+talents ; on ajoute le racial nain/troll
    local base = 0
    if GetRangedCritChance then
        local ok, v = pcall(GetRangedCritChance)
        if ok and v then base = v end
    else
        base = GetCritChance() or 0
    end
    local racial = rangedCritRacialBonus()
    if racial > 0 then
        return string.format("%.2f%% (+%d%% racial)", base + racial, racial)
    end
    return fmtPct(base + racial)
end

-- Les "cap" sont construits dynamiquement avec _LS (donc traduits)
-- via des fonctions qui renvoient le texte au moment du refresh.
-- Caps confirmés en WoW Classic (niveau 60, contre un boss de raid niveau 63).
-- WoW Forever unifie le toucher (mêlée, distance, sorts) : valeurs à revoir après la bêta.
local function capLines(kind)
    if kind == "CASTER_DPS" then
        return {
            {label=function() return _LS.hit_spell end,  cap=function() return "16% (".._LS.incl_tal..")" end, cur=curSpellHit},
            {label=function() return _LS.crit_spell end, cap=function() return "—" end, cur=curSpellCrit},
        }
    elseif kind == "HEALER" then
        return {
            {label=function() return _LS.hit_spell end, cap=function() return _LS.no_cap_heal end, cur=function() return "—" end},
            {label=function() return _LS.crit_spell end, cap=function() return "—" end, cur=curSpellCrit},
        }
    elseif kind == "MELEE_2H" then
        return {
            {label=function() return _LS.hit_melee end, cap=function() return "9% (6% ".._LS.wskill..")" end, cur=curMeleeHit},
            {label=function() return _LS.crit end, cap=function() return "—" end, cur=curMeleeCrit},
        }
    elseif kind == "MELEE_DW" then
        return {
            {label=function() return _LS.hit_melee end, cap=function() return "9% ".._LS.specials.." / 27% ".._LS.auto_dw end, cur=curMeleeHit},
            {label=function() return _LS.crit end, cap=function() return "—" end, cur=curMeleeCrit},
        }
    elseif kind == "HUNTER" then
        return {
            {label=function() return _LS.hit_ranged end, cap=function() return "9%" end, cur=curRangedHit},
            {label=function() return _LS.crit end, cap=function() return "—" end, cur=curRangedCrit},
        }
    elseif kind == "TANK_BLOCK" then
        return {
            {label=function() return _LS.defense end, cap=function() return "440 ".._LS.anticrit end, cur=curDefense},
            {label=function() return _LS.avoidance end, cap=function() return "102.4% ".._LS.anticrush end, cur=curAvoidance},
            {label=function() return _LS.hit_melee end, cap=function() return "9%" end, cur=curMeleeHit},
        }
    elseif kind == "TANK_DRUID" then
        return {
            {label=function() return _LS.defense end, cap=function() return "440 ".._LS.anticrit end, cur=curDefense},
            {label=function() return _LS.hit_melee end, cap=function() return "9%" end, cur=curMeleeHit},
        }
    end
    return {}
end

-- Type de caps par spec : défini dans le Studio (FC.STATS_CAPS)

-- Panneau attaché au côté droit de la Bislist
local function buildStatsPanel(parentFrame)
    local p = API.CreateWindow("ForeverCompanionStatsPanel", parentFrame, 250, 200)
    if p.CloseButton then p.CloseButton:Hide() end   -- ouvert/fermé par le bouton Stats Cap
    -- Ancré à droite de la liste : suit la fenêtre quand on la déplace
    p:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", 56, 0)   -- à droite des onglets à icône
    p:Hide()

    p.title = API.WindowTitle(p)
    API.AddInset(p, 8, -26, -8, 8)

    p.lines = {}

    p.refresh = function(cn, sn)
        InitStatsLocale()
        p.title:SetText(_LS.title.." — "..(sn or "?"))
        for _,l in ipairs(p.lines) do l.h:Hide(); l.c:Hide(); l.v:Hide() end
        local kind = (FC.STATS_CAPS[cn] or {})[sn]
        local caps = kind and capLines(kind) or nil
        local y = 32
        if not caps or #caps == 0 then
            if not p.noData then
                p.noData = p:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
                p.noData:SetPoint("TOPLEFT",12,-32)
            end
            p.noData:SetText("|cffff8800—|r")
            p.noData:Show()
            if p.beta then p.beta:Hide(); p.betaIcon:Hide() end
            p:SetHeight(70)
            return
        end
        if p.noData then p.noData:Hide() end
        for i,entry in ipairs(caps) do
            local l = p.lines[i]
            if not l then
                l = {}
                l.h = p:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
                l.c = p:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
                l.v = p:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
                p.lines[i] = l
            end
            l.h:ClearAllPoints(); l.h:SetPoint("TOPLEFT",12,-y)
            l.h:SetTextColor(1,0.84,0)
            l.h:SetText(entry.label())
            y = y + 14
            l.c:ClearAllPoints(); l.c:SetPoint("TOPLEFT",18,-y)
            l.c:SetTextColor(0.7,0.7,0.7)
            l.c:SetText(_LS.cap.." : "..entry.cap())
            y = y + 13
            l.v:ClearAllPoints(); l.v:SetPoint("TOPLEFT",18,-y)
            l.v:SetTextColor(0.4,1,0.4)
            l.v:SetText(_LS.current.." : "..(entry.cur() or "?"))
            y = y + 18
            l.h:Show(); l.c:Show(); l.v:Show()
        end
        -- Avertissement : valeurs de bêta
        if not p.beta then
            p.betaIcon = p:CreateTexture(nil,"OVERLAY")
            p.betaIcon:SetSize(20,20)
            p.betaIcon:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
            p.beta = p:CreateFontString(nil,"OVERLAY","GameFontNormal")
            p.beta:SetTextColor(1,0.55,0.2)
            p.beta:SetText("BETA")
            p.beta:SetPoint("LEFT",p.betaIcon,"RIGHT",4,0)
        end
        p.betaIcon:ClearAllPoints(); p.betaIcon:SetPoint("TOPLEFT",12,-(y+2))
        p.betaIcon:Show(); p.beta:Show()
        y = y + 26
        p:SetHeight(y + 12)
    end

    return p
end

local function buildFrame(forceClass, forceSpec)
    mainFrame=API.CreateWindow("ForeverCompanionFrame",UIParent)
    API.CloseOnEscape(mainFrame)   -- fermeture par Échap
    mainFrame:SetSize(FW,FH); mainFrame:SetPoint("CENTER")
    mainFrame:SetMovable(true); mainFrame:EnableMouse(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart",mainFrame.StartMoving)
    mainFrame:SetScript("OnDragStop",mainFrame.StopMovingOrSizing)
    mainFrame:SetFrameStrata("HIGH")
    API.WindowTitle(mainFrame):SetText(FC.NAME)
    -- Bouton d'options (roue dentée) à gauche de la croix
    mainFrame.optionsBtn = API.CreateOptionsButton(mainFrame, function() FC:OpenOptions() end)
    -- Bouton « ? » : tour guidé de l'addon (Tour.lua)
    if FC.AddTourButton then mainFrame.helpBtn = FC:AddTourButton(mainFrame, mainFrame.optionsBtn) end
    -- Bouton « Quick setup » : activer / couper les fonctionnalités en un clic (QuickSetup.lua)
    if FC.AddQuickSetupButton then mainFrame.quickBtn = FC:AddQuickSetupButton(mainFrame, mainFrame.helpBtn or mainFrame.optionsBtn) end

    -- Détecter classe et spec réelles depuis les talents
    local detectedClass, detectedSpec = FC:DetectPlayerSpec()

    local selPhase = FC:ValidPhase(FC.db.char.bislist_phase, 2)
    local selClass, selSpec

    if forceClass then
        -- Classe/spec forcées (ex: inspection d'un joueur)
        selClass = forceClass
        selSpec  = forceSpec
    elseif sessionClass then
        -- Choix manuel fait pendant cette session : on le respecte
        selClass = sessionClass
        selSpec  = sessionSpec
    else
        -- Premier affichage de la session (après reload/reco) :
        -- on part sur la spec RÉELLE du joueur
        selClass = detectedClass
        selSpec  = detectedSpec
    end

    -- Fallback: première spec de la classe
    if selClass and not (selSpec and FC:HasSpec(selClass, selSpec)) then
        selSpec = FC:GetSpecs(selClass)[1]
    end

    local classDD, specDD, phaseDD   -- créés plus bas (menus déroulants)

    -- ── Onglets à icône à droite de la fenêtre (ordre, textes et icônes : Studio → Interface)
    -- Même apparence que les onglets de la fiche personnage ; l'onglet reste « sélectionné »
    -- tant que sa fenêtre est ouverte.
    local TAB_STEP = 60
    local function toggleStats()
        if not mainFrame.statsPanel then mainFrame.statsPanel = buildStatsPanel(mainFrame) end
        local p = mainFrame.statsPanel
        p.refresh(selClass, selSpec); p:Show()
    end
    local ACTIONS = {
        consumables = function() if FC.OpenConsumeFrameForSpec then FC:OpenConsumeFrameForSpec(selClass, selSpec) end end,
        talents     = function() if FC.OpenBisTalentFrameForSpec then FC:OpenBisTalentFrameForSpec(selClass, selSpec) end end,
        stats       = toggleStats,
        rotation    = function() if FC.OpenRotationFrameForSpec then FC:OpenRotationFrameForSpec(selClass, selSpec) end end,
        loot        = function() if FC.OpenLootFrame then FC:OpenLootFrame(selClass, selSpec) end end,
        professions = function() if FC.OpenProfessionsFrame then FC:OpenProfessionsFrame() end end,
        market      = function() if FC.OpenMarket then FC:OpenMarket() end end,
    }
    -- Fenêtre ouverte par chaque onglet (certaines sont recréées à chaque ouverture)
    local WINDOWS = {
        consumables = function() return FC.ConsumeFrame end,
        talents     = function() return _G.ForeverCompanionTalentFrame end,
        stats       = function() return mainFrame.statsPanel end,
        rotation    = function() return FC.RotationFrame end,
        loot        = function() return _G.ForeverCompanionLootFrame end,
        professions = function() return _G.ForeverCompanionProfessionsFrame end,
        market      = function() return _G.ForeverCompanionMarketFrame end,
    }
    local TAB_OPTIONS = { consumables = "tooltips", talents = "tooltips", rotation = "tooltips", loot = "items", professions = "professions", market = "auction" }
    mainFrame.sideTabs = {}
    mainFrame.sideTabOrder = {}   -- onglets dans l'ordre affiché (tour guidé)
    local y = -30
    for _, t in ipairs(FC.UI_TABS) do
        local act = ACTIONS[t.id]
        local ahOff = t.id == "market" and FC.db.global.ah_enabled == false   -- HV désactivé dans les options
        if act and t.on ~= false and not FC.db.char.tab_off[t.id] and not ahOff then
            local tab = API.CreateSideTab(mainFrame)
            tab:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", tab.style == "forever" and -2 or 1, y)
            tab:SetIcon(t.icon)
            tab.tooltip = t.label or t.id
            tab.tooltipSub = "Right-click: options"
            if tab.RegisterForClicks then tab:RegisterForClicks("LeftButtonUp", "RightButtonUp") end
            tab:SetScript("OnClick", function(self, button)
                -- Clic droit : page d'options de la fonction (Tabs & features pour celles qui n'en ont pas)
                if button == "RightButton" then FC:OpenOptions(TAB_OPTIONS[t.id] or "tabs"); return end
                -- Fenêtre déjà ouverte : le clic la ferme (comme Stats Cap)
                local open = WINDOWS[t.id]()
                if open and open:IsShown() then open:Hide(); self:SetActive(false); return end
                act()
                local w = WINDOWS[t.id]()
                if w then
                    if not w.fcTabHooked then
                        w.fcTabHooked = true
                        w:HookScript("OnShow", function() self:SetActive(true) end)
                        w:HookScript("OnHide", function() self:SetActive(false) end)
                    end
                    self:SetActive(w:IsShown())
                end
            end)
            mainFrame.sideTabs[t.id] = tab
            table.insert(mainFrame.sideTabOrder, { id = t.id, tab = tab, label = t.label or t.id, window = WINDOWS[t.id] })
            y = y - (tab.style == "forever" and TAB_STEP or 46)
        end
    end

    local hdr=CreateFrame("Frame",nil,mainFrame)
    hdr:SetPoint("TOPLEFT",mainFrame,"TOPLEFT",10,-90); hdr:SetSize(FW-20,18)
    -- Fond sombre du panneau (comme les Statistiques de la fiche personnage)
    API.AddInset(mainFrame,-3,3,-6,5,hdr)
    local function hLbl(txt,x,w)
        local fs=hdr:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        fs:SetPoint("TOPLEFT",hdr,"TOPLEFT",x,-3)
        fs:SetText(txt); fs:SetWidth(w)
    end
    local ICON_START=4+SLOT_COL+5+GEM_COL+5
    hLbl("Slot",4,SLOT_COL-4)
    hLbl(FC.HAS_GEMS and "Gems/Ench" or "Enchants",4+SLOT_COL+5,GEM_COL-4)
    for i=1,6 do hLbl("Top "..i,ICON_START+(i-1)*(ICON+GAP),ICON+GAP) end
    API.StripedBackground(hdr,"header")
    local ln=hdr:CreateTexture(nil,"ARTWORK"); ln:SetColorTexture(API.COLORS.border[1],API.COLORS.border[2],API.COLORS.border[3],1); ln:SetHeight(1)
    ln:SetPoint("BOTTOMLEFT",hdr,"BOTTOMLEFT"); ln:SetPoint("BOTTOMRIGHT",hdr,"BOTTOMRIGHT")

    local sf=API.CreateScrollFrame(mainFrame)
    sf:SetPoint("TOPLEFT",hdr,"BOTTOMLEFT",0,-2)
    sf:SetPoint("BOTTOMRIGHT",mainFrame,"BOTTOMRIGHT",-28,44)
    hdr:SetFrameLevel(mainFrame:GetFrameLevel()+2); sf:SetFrameLevel(mainFrame:GetFrameLevel()+2)
    API.AddBottomFade(sf,26,22)          -- fondu sous la liste et la barre de défilement
    API.AddSoftBar(mainFrame,12,11,37)   -- petite barre de fin de liste
    -- Avertissement bêta (bas de la fenêtre)
    local warn = mainFrame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    warn:SetPoint("BOTTOM",mainFrame,"BOTTOM",0,15)
    warn:SetWidth(FW-40); warn:SetJustifyH("CENTER")
    warn:SetTextColor(1,0.55,0.2)
    local loc = GetLocale and GetLocale() or "enUS"
    warn:SetText(loc=="frFR" and "Bêta : les données (BiS, rotations, talents, caps) peuvent changer radicalement."
        or "Beta: data (BiS, rotations, talents, caps) may change drastically.")
    scrollChild=CreateFrame("Frame",nil,sf)
    scrollChild:SetSize(FW-40,1000); sf:SetScrollChild(scrollChild)
    mainFrame.tourList = sf   -- liste des objets (tour guidé)

    local function refresh() renderList(selClass,selSpec,selPhase) end

    -- ── Menus déroulants Classe / Spec / Phase ──────────────────────────
    local function iconText(icon, name)
        return ((icon and icon > 0) and ("|T" .. icon .. ":16:16:0:0|t ") or "") .. (name or "")
    end
    local function classText(cn)
        if not cn then return "" end
        local cc = FC.CLASS_COLORS[cn] or { r = 1, g = 1, b = 1 }
        local hex = string.format("|cff%02x%02x%02x", cc.r * 255, cc.g * 255, cc.b * 255)
        return iconText(FC:GetClassIcon(cn), hex .. cn .. "|r")
    end
    local function specText(cn, sn)
        return sn and iconText(FC:GetSpecIcon(cn, sn), sn) or ""
    end
    local function mkDD(lbl, x, w, build)
        local dd = API.CreateDropdown(mainFrame, w, build)
        dd.frame:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", x + (dd.xInset or 0), -52)
        local fs = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("BOTTOMLEFT", mainFrame, "TOPLEFT", x + 4, -50)
        fs:SetText("|cffffff88" .. lbl .. "|r")
        return dd
    end
    local function updateTexts()
        classDD.SetText(classText(selClass))
        specDD.SetText(specText(selClass, selSpec))
        phaseDD.SetText(FC:PhaseLabel(selPhase))
    end

    classDD = mkDD("Class", 12, 130, function()
        local items = {}
        for _, cn in ipairs(FC:GetClasses()) do
            table.insert(items, {
                text = classText(cn),
                isSelected = function() return cn == selClass end,
                func = function()
                    selClass = cn
                    selSpec = FC:GetSpecs(cn)[1]
                    sessionClass, sessionSpec = selClass, selSpec  -- choix manuel
                    updateTexts(); refresh()
                end,
            })
        end
        return items
    end)
    specDD = mkDD("Spec", 150, 150, function()
        local items = {}
        for _, sn in ipairs(FC:GetSpecs(selClass)) do
            table.insert(items, {
                text = specText(selClass, sn),
                isSelected = function() return sn == selSpec end,
                func = function()
                    selSpec = sn
                    sessionClass, sessionSpec = selClass, selSpec  -- choix manuel
                    updateTexts(); refresh()
                end,
            })
        end
        return items
    end)
    phaseDD = mkDD("Phase", 308, 100, function()
        local items = {}
        for _, ph in ipairs(FC.PHASES) do
            table.insert(items, {
                text = FC:PhaseLabel(ph),
                isSelected = function() return ph == selPhase end,
                func = function() selPhase = ph; updateTexts(); refresh() end,
            })
        end
        return items
    end)
    -- Logo de faction à droite de la phase : bascule la liste sur l'autre faction (pour cette fenêtre
    -- seulement ; retour à ma faction à chaque ouverture). Grisé si le filtre de faction est coupé.
    viewFaction = nil
    local facBtn = CreateFrame("Button", nil, mainFrame)
    facBtn:SetSize(26, 26)
    facBtn:SetPoint("LEFT", phaseDD.frame, "RIGHT", 10, 0)
    -- Emblème du camp (sans fond) ; au survol, un fin liseré doré
    facBtn.icon = facBtn:CreateTexture(nil, "ARTWORK"); facBtn.icon:SetAllPoints()
    facBtn.icon:SetTexCoord(0, 0.625, 0, 0.625)
    facBtn.ring = CreateFrame("Frame", nil, facBtn, "BackdropTemplate")
    facBtn.ring:SetPoint("TOPLEFT", -3, 3); facBtn.ring:SetPoint("BOTTOMRIGHT", 3, -3)
    facBtn.ring:EnableMouse(false)
    if facBtn.ring.SetBackdrop then
        facBtn.ring:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10 })
        facBtn.ring:SetBackdropBorderColor(1, 0.82, 0, 0.8)
    end
    facBtn.ring:Hide()
    local function shownFaction() return viewFaction or FC:PlayerFaction() or "Alliance" end
    function facBtn:Update()
        local f = shownFaction()
        self.icon:SetTexture(f == "Horde" and "Interface\\TargetingFrame\\UI-PVP-Horde" or "Interface\\TargetingFrame\\UI-PVP-Alliance")
        local on = FC:FactionFilterOn()
        self.icon:SetDesaturated(not on)
        self.icon:SetVertexColor(0.9, 0.9, 0.9)
        self:SetAlpha(on and 1 or 0.5)
    end
    facBtn:SetScript("OnMouseDown", function(self) self.icon:SetPoint("TOPLEFT", 1, -1); self.icon:SetPoint("BOTTOMRIGHT", 1, -1) end)
    facBtn:SetScript("OnMouseUp", function(self) self.icon:ClearAllPoints(); self.icon:SetAllPoints() end)
    facBtn:SetScript("OnClick", function(self)
        if not FC:FactionFilterOn() then return end
        local mine = FC:PlayerFaction() or "Alliance"
        local cur = shownFaction()
        local nxt = cur == "Alliance" and "Horde" or "Alliance"
        viewFaction = (nxt ~= mine) and nxt or nil
        self:Update(); refresh()
        if self:IsMouseOver() and self:GetScript("OnEnter") then self:GetScript("OnEnter")(self) end
    end)
    facBtn:SetScript("OnEnter", function(self)
        self.ring:Show(); self.icon:SetVertexColor(1, 1, 1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local f = shownFaction()
        if not FC:FactionFilterOn() then
            GameTooltip:AddLine("Faction", 1, 0.82, 0)
            GameTooltip:AddLine("The faction filter is off (Options > Items & loot): items of both factions are shown.", 1, 1, 1, true)
        else
            GameTooltip:AddLine("BiS list for the " .. f, 1, 0.82, 0)
            GameTooltip:AddLine("Click to see the list for the " .. (f == "Alliance" and "Horde" or "Alliance") .. ".", 1, 1, 1, true)
        end
        GameTooltip:Show()
    end)
    facBtn:SetScript("OnLeave", function(self) self.ring:Hide(); self.icon:SetVertexColor(0.9, 0.9, 0.9); GameTooltip:Hide() end)
    facBtn:Update()
    mainFrame.factionBtn = facBtn
    mainFrame.resetFaction = function() if viewFaction then viewFaction = nil; facBtn:Update(); refresh() end end
    mainFrame.tourDropdowns = { classDD.frame, specDD.frame, phaseDD.frame, facBtn }   -- tour guidé
    mainFrame.tourSel = function() return selClass, selSpec, selPhase end
    -- Ouvertures suivantes de la fenêtre : « What's new » après une mise à jour, bulle du tour (Tour.lua)
    mainFrame:HookScript("OnShow", function()
        mainFrame.resetFaction()   -- liste de ma faction à chaque ouverture
        if FC.OnBislistShown then FC:OnBislistShown() end
    end)
    mainFrame.tourFirstItem = function()
        for _, r in ipairs(rowPool) do if r.firstBtn then return r.firstBtn end end
    end
    updateTexts()
    refresh()
end

function FC:ToggleBislist()
    if mainFrame then
        if mainFrame:IsShown() then mainFrame:Hide() else mainFrame:Show() end
        return
    end
    buildFrame(); mainFrame:Show()
    -- Fenêtre visible dès sa création : son premier Show ne déclenche pas OnShow
    if FC.OnBislistShown then FC:OnBislistShown() end
end

-- Re-render complet (utilisé pour retirer les bordures bleues après inspection)
function FC:RefreshBislist()
    if not mainFrame then return end
    local wasShown = mainFrame:IsShown()
    mainFrame:Hide()
    mainFrame:SetParent(nil)
    mainFrame = nil
    if wasShown then
        buildFrame()
        mainFrame:Show()
    end
end

-- Ouvre la Bislist pré-filtrée sur une classe/spec (utilisé par l'inspection)
function FC:OpenBislistForSpec(cn, sn)
    if not cn or not FC:HasClass(cn) then return end
    -- Valider la spec, sinon prendre la première de la classe
    if not sn or not FC:HasSpec(cn, sn) then
        sn = FC:GetSpecs(cn)[1]
    end
    -- Reconstruire le frame avec les valeurs forcées
    if mainFrame then
        mainFrame:Hide()
        mainFrame:SetParent(nil)
        mainFrame = nil
    end
    buildFrame(cn, sn)
    mainFrame:Show()
    if FC.OnBislistShown then FC:OnBislistShown() end
end

function FC:initBislist() end
