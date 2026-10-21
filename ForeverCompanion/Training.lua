-- Forever Companion — Training.lua
-- Sorts à apprendre chez le maître de classe, dans une fenêtre collée à droite du grimoire (comme
-- l'addon What's Training). Un onglet sur le bord du grimoire l'ouvre ou la ferme ; elle suit le grimoire.
-- Données : Data/Training.lua (ForeverCompanionData.training[CLASSE] = { {id, n, r, l, c, f, ra}, … }),
-- lues par le Studio chez les maîtres de classe. Catégories : disponibles maintenant, rang précédent
-- manquant, talent ou quête requis, deux prochains niveaux, plus tard, ignorés, connus.
-- Clic droit : ignorer (Maj : tous les rangs) ; Maj-clic : lien dans le chat.
-- Démoniste : les grimoires du maître des démons (ForeverCompanionData.grimoires) sont mêlés aux sorts,
-- « Imp: Firebolt (Rank 2) » ; appris : vu dans le grimoire du démon quand il est invoqué, ou « Déjà connu »
-- chez le maître des démons (noté pour le personnage).
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local W, ROW_H = 300, 22
local panel, launcher, book, outer
local collapsed = { ignored = true, known = true }   -- catégories repliées (pour la session)

local CATS = {
    { id = "now",     label = "Available now",          color = "|cff40ff40", total = true },
    { id = "prev",    label = "Missing a previous rank", color = "|cffffd100", total = true },
    { id = "soon",    label = "Next two levels",         color = "|cffffffff", total = true },
    { id = "later",   label = "Later levels",            color = "|cffc0c0c0", total = true },
    { id = "talent",  label = "Needs a talent or quest", color = "|cffff8c33" },   -- en bas : on ne peut rien y faire au maître
    { id = "ignored", label = "Ignored",                 color = "|cff9d9d9d" },
    { id = "known",   label = "Known",                   color = "|cff9d9d9d" },
}

local function On() return FC.db ~= nil and FC.db.global.training_enabled ~= false end
local function Ignored()
    local c = FC.db.char
    c.training_ignored = c.training_ignored or {}
    return c.training_ignored
end

-- Relevés faits chez les maîtres (compte entier) : [CLASSE][sort] = { l, c, rx, fa, n, r, at }
local function Scans(token)
    local g = FC.db and FC.db.global
    if not g then return {} end
    g.training_scans = g.training_scans or {}
    if token then g.training_scans[token] = g.training_scans[token] or {}; return g.training_scans[token] end
    return g.training_scans
end
-- Grimoires appris (personnage) : [objet] = true
local function GrimoiresKnown()
    local c = FC.db.char
    c.grimoires_known = c.grimoires_known or {}
    return c.grimoires_known
end
local function GrimoireData()
    return (ForeverCompanionData and ForeverCompanionData.grimoires) or {}
end
-- Le démon invoqué connaît-il ce sort ?
local function PetKnows(sp)
    if not sp or not (UnitExists and UnitExists("pet")) then return false end
    if C_SpellBook and C_SpellBook.IsSpellInSpellBook and Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Pet then
        local ok, v = pcall(C_SpellBook.IsSpellInSpellBook, sp, Enum.SpellBookSpellBank.Pet, false)
        if ok and v then return true end
    end
    if IsSpellKnown then
        local ok, v = pcall(IsSpellKnown, sp, true)
        if ok and v then return true end
    end
    return false
end
-- Grimoires dont le démon invoqué connaît le sort : notés comme appris
local function CheckPetGrimoires()
    if not FC.db or not (UnitExists and UnitExists("pet")) then return false end
    local known, changed = GrimoiresKnown(), false
    for _, g in ipairs(GrimoireData()) do
        if g.sp and not known[g.it] and PetKnows(g.sp) then known[g.it] = true; changed = true end
    end
    return changed
end
FC.TrainingCheckPet = CheckPetGrimoires   -- tests
-- Sort à interroger pour le nom, l'icône, le sous-titre (grimoire : sort appris au démon)
local function Sid(e) if e.it then return e.sp end return e.id end

local function FacLetter()
    local f = FC:PlayerFaction()
    return f == "Alliance" and "A" or f == "Horde" and "H" or nil
end

-- Sorts de ma classe, de ma faction et de ma race ; niveau et prix vus chez le maître par-dessus les données,
-- et sorts vus seulement chez le maître (relevés par un personnage de ma faction)
local function MyList()
    local data = ForeverCompanionData and ForeverCompanionData.training
    local _, token = UnitClass("player")
    if not token then return {} end
    local list = (data and data[token]) or {}
    local seen = Scans(token)
    local fac = FC:PlayerFaction()
    local mine = FacLetter()
    local race = select(3, UnitRace("player"))
    local out, have = {}, {}
    for _, e in ipairs(list) do
        local ok = not e.f or not fac or ((e.f == "A") == (fac == "Alliance"))
        if ok and e.ra and race then
            ok = false
            for _, r in ipairs(e.ra) do if r == race then ok = true end end
        end
        if ok then
            local s = seen[e.id]
            if s then e = { id = e.id, n = e.n, r = e.r, f = e.f, ra = e.ra, l = s.l or e.l, c = s.c or e.c, obs = true } end
            out[#out + 1] = e
        end
        have[e.id] = true
    end
    if token == "WARLOCK" then   -- grimoires du maître des démons
        for _, g in ipairs(GrimoireData()) do
            local id = "g" .. g.it
            local s = seen[id]
            out[#out + 1] = { id = id, it = g.it, sp = g.sp, n = g.n, r = g.r, pet = g.pet, l = (s and s.l) or g.l, c = (s and s.c) or g.c, obs = s and true or nil }
            have[id] = true
        end
    end
    for id, s in pairs(seen) do
        if not have[id] and s.l and (not mine or not s.fa or s.fa:find(mine, 1, true)) then
            local it = type(id) == "string" and tonumber(id:match("^g(%d+)$")) or nil
            out[#out + 1] = { id = id, it = it, n = s.n or ("Spell " .. tostring(id)), r = s.r, l = s.l, c = s.c or 0, obs = true }
        end
    end
    table.sort(out, function(a, b)
        if a.l ~= b.l then return a.l < b.l end
        if a.n ~= b.n then return tostring(a.n) < tostring(b.n) end
        return (a.r or 0) < (b.r or 0)
    end)
    return out
end

-- Répartit les sorts dans les catégories ; renvoie cats[id] = { e… }, totaux, niveau
local function Classify(list)
    local level = UnitLevel and UnitLevel("player") or 1
    local ign = Ignored()
    local byName = {}
    local function key(e) return (e.pet or "") .. "|" .. tostring(e.n) end   -- même nom : même démon
    for _, e in ipairs(list) do
        if e.r then byName[key(e)] = byName[key(e)] or {}; byName[key(e)][e.r] = e end
    end
    local gk = GrimoiresKnown()
    local function knows(e)
        if e.it then return gk[e.it] or PetKnows(e.sp) end   -- grimoire : appris au démon
        return API.IsSpellKnown(e.id)
    end
    local cache = {}
    local function known(e)
        if cache[e] == nil then
            local k = knows(e)
            if not k and e.r and byName[key(e)] then   -- un rang supérieur connu : celui-ci compte comme connu
                for r, x in pairs(byName[key(e)]) do if r > e.r and knows(x) then k = true; break end end
            end
            cache[e] = k and true or false
        end
        return cache[e]
    end
    -- Rang précédent hors du maître (talent, quête) : le joueur connaît-il ce sort (n'importe quel rang) ?
    local function knowsName(e)
        local name = API.GetSpellName(e.id) or e.n
        return API.GetSpellIDByName(name) ~= nil
    end
    local cats, totals = {}, {}
    for _, c in ipairs(CATS) do cats[c.id] = {}; totals[c.id] = 0 end
    for _, e in ipairs(list) do
        local cat
        local ranks = e.r and byName[key(e)]
        local prev = ranks and e.r > 1 and ranks[e.r - 1] or nil
        if known(e) then cat = "known"
        elseif ign[e.id] then cat = "ignored"
        elseif e.q and not e.obs then cat = "talent"   -- vu seulement dans les fichiers du jeu : talent ou quête
        elseif not e.it and e.r and e.r > 1 and not prev and not knowsName(e) then cat = "talent"   -- (grimoire : le rang 1 vient avec le démon)
        elseif e.l > level + 2 then cat = "later"
        elseif e.l > level then cat = "soon"
        elseif prev and not known(prev) then cat = "prev"
        else cat = "now" end
        table.insert(cats[cat], e)
        totals[cat] = totals[cat] + (e.c or 0)
    end
    return cats, totals, level
end
FC.TrainingClassify = function() return Classify(MyList()) end   -- tests

local function SpellLabel(e)
    local sid = Sid(e)
    local name = (sid and API.GetSpellName(sid)) or (e.it and not e.sp and API.GetItemInfo(e.it)) or e.n
    local sub = (sid and API.GetSpellSubtext(sid)) or (e.r and ("Rank " .. e.r))
    return (e.pet and ("|cffb28cff" .. e.pet .. ":|r ") or "") .. name .. (sub and ("  |cff9d9d9d" .. sub .. "|r") or "")
end

-- ── Lignes de la liste ───────────────────────────────────────────────────
local Render
local function Header(parent)
    local h = CreateFrame("Button", nil, parent)
    h:SetHeight(22)
    API.StripedBackground(h, "header")
    h.text = h:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    h.text:SetPoint("LEFT", 8, 0); h.text:SetJustifyH("LEFT")
    h.total = h:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    h.total:SetPoint("RIGHT", -8, 0)
    h:SetScript("OnClick", function(self) collapsed[self.cat] = not collapsed[self.cat]; Render() end)
    return h
end
local function FillHeader(h, d)
    h.cat = d.cat.id
    h.text:SetText((collapsed[d.cat.id] and "+ " or "- ") .. d.cat.color .. d.cat.label .. "|r  |cff9d9d9d(" .. d.n .. ")|r")
    if d.cat.total and d.total > 0 then
        local poor = d.cat.id == "now" and GetMoney and d.total > GetMoney()
        h.total:SetText((poor and "|cffff4040" or "") .. API.Money(d.total) .. (poor and "|r" or ""))
    else
        h.total:SetText("")
    end
end

local function Row(parent)
    local r = CreateFrame("Button", nil, parent)
    r:SetHeight(ROW_H)
    if r.RegisterForClicks then r:RegisterForClicks("LeftButtonUp", "RightButtonUp") end
    r.icon = r:CreateTexture(nil, "ARTWORK")
    r.icon:SetSize(ROW_H - 4, ROW_H - 4); r.icon:SetPoint("LEFT", 6, 0)
    r.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    -- Colonnes : coût à droite, niveau juste avant (largeur fixe), nom entre l'icône et le niveau,
    -- coupé avec « … » s'il est trop long (il ne déborde plus sur le niveau)
    r.cost = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.cost:SetPoint("RIGHT", -6, 0); r.cost:SetJustifyH("RIGHT")
    r.lvl = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.lvl:SetPoint("RIGHT", -70, 0); r.lvl:SetWidth(22); r.lvl:SetJustifyH("RIGHT")
    r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.name:SetPoint("LEFT", r.icon, "RIGHT", 6, 0); r.name:SetPoint("RIGHT", r.lvl, "LEFT", -8, 0)
    r.name:SetJustifyH("LEFT"); r.name:SetWordWrap(false)
    r.hl = r:CreateTexture(nil, "HIGHLIGHT")
    r.hl:SetAllPoints(); r.hl:SetColorTexture(1, 0.82, 0.45, 0.12)
    r:SetScript("OnEnter", function(self)
        local e = self.e
        if not e then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if e.it then   -- grimoire : l'objet (il dit ce qu'il apprend au démon)
            if GameTooltip.SetItemByID then GameTooltip:SetItemByID(e.it) else GameTooltip:SetHyperlink("item:" .. e.it) end
        elseif GameTooltip.SetSpellByID then GameTooltip:SetSpellByID(e.id) else GameTooltip:AddLine(e.n, 1, 1, 1) end
        local poor = GetMoney and (e.c or 0) > GetMoney()
        GameTooltip:AddLine(" ")
        local g = poor and 0.25 or 1
        local price = e.c == nil and "Price: visit your trainer" or (e.c > 0 and API.Money(e.c) or "Free")
        GameTooltip:AddDoubleLine("Level " .. e.l, price, 1, 0.82, 0, 1, g, g)
        if e.it then GameTooltip:AddLine("Sold by the demon trainer. Learned grimoires show up when the demon is summoned.", 0.6, 0.6, 0.6, true) end
        GameTooltip:AddLine("Right-click: ignore  ·  Shift + right-click: all ranks", 0.6, 0.6, 0.6)
        GameTooltip:Show()
    end)
    r:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r:SetScript("OnClick", function(self, button)
        local e = self.e
        if not e then return end
        if button == "RightButton" then
            FC:TrainingIgnore(e, IsShiftKeyDown and IsShiftKeyDown())
        elseif IsModifiedClick and IsModifiedClick("CHATLINK") then
            local link = e.it and select(2, API.GetItemInfo(e.it)) or (not e.it and API.GetSpellLink(e.id))
            if link and ChatEdit_InsertLink then ChatEdit_InsertLink(link) end
        end
    end)
    return r
end
local function FillRow(r, d)
    local e = d.e
    r.e = e
    r.icon:SetTexture((Sid(e) and API.GetSpellIcon(Sid(e))) or (e.it and API.GetItemIcon(e.it)) or 134400)
    r.name:SetText(SpellLabel(e))
    r.lvl:SetText(tostring(e.l))
    local c = e.c or 0
    local poor = (d.cat == "now" or d.cat == "prev") and GetMoney and c > GetMoney()
    if e.c == nil then r.cost:SetText("|cff9d9d9d?|r")   -- prix inconnu tant qu'on n'est pas passé chez le maître
    else r.cost:SetText(c > 0 and ((poor and "|cffff4040" or "") .. API.Money(c) .. (poor and "|r" or "")) or "|cff9d9d9dFree|r") end
    local dim = d.cat == "known" or d.cat == "ignored"
    r:SetAlpha(dim and 0.6 or 1)
    r.icon:SetDesaturated(dim or d.cat == "talent")
end

-- Ignorer / ne plus ignorer (tous les rangs avec Maj)
function FC:TrainingIgnore(e, allRanks)
    local ign = Ignored()
    local on = not ign[e.id]
    if allRanks then
        for _, x in ipairs(MyList()) do if x.n == e.n and x.pet == e.pet then ign[x.id] = on or nil end end
    else
        ign[e.id] = on or nil
    end
    Render()
end

-- ── Fenêtre ──────────────────────────────────────────────────────────────
local function Build()
    local f = API.CreateWindow("ForeverCompanionTrainingFrame", UIParent, W, 500)
    API.WindowTitle(f):SetText("Training")
    if type(f.CloseButton) == "table" then
        f.CloseButton:SetScript("OnClick", function() FC:ToggleTraining(false) end)
    end
    f.info = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.info:SetPoint("TOPLEFT", 14, -32); f.info:SetPoint("RIGHT", f, "RIGHT", -14, 0); f.info:SetJustifyH("LEFT")
    f.search = API.CreateSearchBox(f, W - 36, function(t)
        f.query = API.SearchNorm(t):gsub("^%s+", ""):gsub("%s+$", "")
        Render(true)
    end, "Search a spell")
    f.search:SetPoint("TOPLEFT", 18, -50)
    API.AddInset(f, 8, -76, -8, 8)
    f.sf = API.CreateScrollFrame(f, "ForeverCompanionTrainingScroll")
    f.sf:SetPoint("TOPLEFT", 12, -80); f.sf:SetPoint("BOTTOMRIGHT", -30, 12)
    f.sc = CreateFrame("Frame", nil, f.sf); f.sc:SetSize(W - 46, 1)
    f.sf:SetScrollChild(f.sc)
    f.list = API.VirtualList(f.sf, f.sc, {
        header = { h = 24, create = Header, fill = FillHeader },
        spell  = { h = ROW_H + 1, create = Row, fill = FillRow },
        gap    = { h = 6 },
    })
    f:Hide()
    return f
end

Render = function(resetScroll)
    if not panel or not panel:IsShown() then return end
    local list = MyList()
    local cats, totals, level = Classify(list)
    local q = panel.query or ""
    local lines = {}
    for _, c in ipairs(CATS) do
        local shown = {}
        for _, e in ipairs(cats[c.id]) do
            if q == "" or API.Matches(q, e.n, Sid(e) and API.GetSpellName(Sid(e)), e.pet) then shown[#shown + 1] = e end
        end
        if #shown > 0 then
            lines[#lines + 1] = { kind = "header", data = { cat = c, n = #shown, total = totals[c.id] } }
            if not collapsed[c.id] or q ~= "" then
                for _, e in ipairs(shown) do lines[#lines + 1] = { kind = "spell", data = { e = e, cat = c.id } } end
            end
            lines[#lines + 1] = { kind = "gap" }
        end
    end
    panel.list:SetLines(lines, resetScroll)
    if #list == 0 then
        panel.info:SetText("|cff9d9d9dNo trainer data for your class yet.|r")
    elseif #cats.now > 0 then
        panel.info:SetText("Level " .. level .. "  ·  |cff40ff40" .. #cats.now .. " to learn now|r  ·  " .. API.Money(totals.now))
    else
        panel.info:SetText("Level " .. level .. "  ·  |cff9d9d9dnothing new at your trainer|r")
    end
end
FC.RenderTraining = function() Render() end

-- Pastille de l'onglet : nombre de sorts disponibles maintenant
local function UpdateBadge()
    if not launcher then return end
    local cats = Classify(MyList())
    local n = #cats.now
    launcher.count:SetText(n > 0 and tostring(n) or "")
    launcher.available = n
end

-- Grimoire ouvert / fermé, fonction coupée : onglet et fenêtre suivent
local function Sync()
    if not book then return end
    local vis = On() and book:IsVisible()
    if not vis then
        if launcher then launcher:Hide() end
        if panel then panel:Hide() end
        return
    end
    if not launcher then
        launcher = API.CreateSideTab(UIParent)
        launcher:SetIcon("Interface\\Icons\\INV_Misc_Book_09")
        launcher.count = launcher:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        launcher.count:SetPoint("BOTTOMRIGHT", -8, 8)
        launcher:SetScript("OnClick", function() FC:ToggleTraining() end)
        launcher:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine("Trainer spells", 1, 0.82, 0)
            local n = self.available or 0
            GameTooltip:AddLine(n > 0 and (n .. " spell(s) to learn now") or "Nothing new at your trainer", 1, 1, 1)
            GameTooltip:AddLine("Click to show / hide the list.", 0.6, 0.6, 0.6)
            GameTooltip:Show()
        end)
    end
    panel = panel or Build()
    local strata = outer.GetFrameStrata and outer:GetFrameStrata() or "HIGH"
    panel:SetFrameStrata(strata); launcher:SetFrameStrata(strata)
    -- À droite du grimoire, ou à gauche s'il n'y a pas la place (grimoire large ou collé au bord droit)
    panel:ClearAllPoints()
    local k = (outer.GetEffectiveScale and outer:GetEffectiveScale() or 1) / (UIParent:GetEffectiveScale() or 1)
    local right = (outer:GetRight() or 0) * k
    if right + W <= (UIParent:GetWidth() or 0) or ((outer:GetLeft() or 0) * k) < W then
        panel:SetPoint("TOPLEFT", outer, "TOPRIGHT", 0, 0)
        panel:SetPoint("BOTTOMLEFT", outer, "BOTTOMRIGHT", 0, 0)
        panel.side = "right"
    else
        panel:SetPoint("TOPRIGHT", outer, "TOPLEFT", 0, 0)
        panel:SetPoint("BOTTOMRIGHT", outer, "BOTTOMLEFT", 0, 0)
        panel.side = "left"
    end
    local open = FC.db.char.training_open == true
    launcher:ClearAllPoints()
    launcher:SetPoint("TOPLEFT", (open and panel.side == "right") and panel or outer, "TOPRIGHT", launcher.style == "forever" and -2 or 1, -60)
    launcher:Show()
    if launcher.SetActive then launcher:SetActive(open) end
    if open then panel:Show(); Render(true) else panel:Hide() end
    UpdateBadge()
end
FC.TrainingSync = Sync   -- tests
FC.TrainingTourTargets = function() return panel, launcher, book end   -- tour guidé

function FC:ToggleTraining(open)
    if open == nil then open = not (FC.db.char.training_open == true) end
    FC.db.char.training_open = open and true or false
    Sync()
end
function FC:RefreshTraining() Sync() end

-- Grimoire : celui du jeu actuel (PlayerSpellsFrame, chargé à la demande) ou l'ancien (SpellBookFrame)
local function Attach()
    if book then return true end
    local ps = rawget(_G, "PlayerSpellsFrame")
    if type(ps) == "table" and type(ps.SpellBookFrame) == "table" then
        book, outer = ps.SpellBookFrame, ps
    elseif type(rawget(_G, "SpellBookFrame")) == "table" then
        book = rawget(_G, "SpellBookFrame"); outer = book
    else
        return false
    end
    -- HookScript seulement (le jeu actuel gère mal hooksecurefunc avec le journal de « taint » actif)
    book:HookScript("OnShow", function() C_Timer.After(0, Sync) end)
    book:HookScript("OnHide", Sync)
    if outer ~= book then outer:HookScript("OnHide", Sync) end
    if book:IsVisible() then Sync() end
    return true
end
FC.TrainingAttach = Attach   -- tests

-- ── Relevé chez le maître ────────────────────────────────────────────────
-- À l'ouverture d'un maître (pas un maître de métier, pas le dressage du familier) : chaque sort qu'il
-- propose, avec le niveau requis et le prix payé (réduction de réputation comprise), noté pour la classe.
-- Les filtres de la fenêtre (disponible, indisponible, déjà appris) sont ouverts le temps du relevé, puis remis.
local function ScanTrainer()
    if not FC.db or not GetNumTrainerServices or not GetTrainerServiceInfo then return 0 end
    if not (C_TooltipInfo and C_TooltipInfo.GetTrainerService) then return 0 end
    if IsTradeskillTrainer and IsTradeskillTrainer() then return 0 end
    if C_Trainer and C_Trainer.GetTrainerType and Enum and Enum.TrainerType then
        local ok, tt = pcall(C_Trainer.GetTrainerType)
        if ok and (tt == Enum.TrainerType.Pet or (Enum.TrainerType.Tradeskill ~= nil and tt == Enum.TrainerType.Tradeskill)) then return 0 end
    end
    local _, token = UnitClass("player")
    if not token then return 0 end
    local saved = {}
    if GetTrainerServiceTypeFilter and SetTrainerServiceTypeFilter then
        for _, t in ipairs({ "available", "unavailable", "used" }) do
            local ok, v = pcall(GetTrainerServiceTypeFilter, t)
            saved[t] = ok and v
            if ok and not v then pcall(SetTrainerServiceTypeFilter, t, 1) end
        end
    end
    local seen = Scans(token)
    local fac = FacLetter()
    local rx = UnitReaction and UnitReaction("npc", "player") or nil
    local n = 0
    for i = 1, (GetNumTrainerServices() or 0) do
        local name, sub, kind = GetTrainerServiceInfo(i)
        if kind ~= "header" then
            local ok, td = pcall(C_TooltipInfo.GetTrainerService, i)
            local id = ok and type(td) == "table" and tonumber(td.id)
            if id and id > 0 then
                local s = seen[id] or {}
                local lv = GetTrainerServiceLevelReq and GetTrainerServiceLevelReq(i)
                local cost = GetTrainerServiceCost and GetTrainerServiceCost(i)
                s.l = tonumber(lv) or s.l
                s.c = tonumber(cost) or s.c
                s.rx, s.at, s.n = rx, time(), name or s.n
                s.r = tonumber(tostring(sub or ""):match("(%d+)")) or s.r
                if fac and not tostring(s.fa or ""):find(fac, 1, true) then s.fa = (s.fa or "") .. fac end
                seen[id] = s
                n = n + 1
            end
        end
    end
    for t, v in pairs(saved) do if not v then pcall(SetTrainerServiceTypeFilter, t, 0) end end
    return n
end
FC.TrainingScan = ScanTrainer   -- tests

-- ── Relevé chez le maître des démons (démoniste) ─────────────────────────
-- Un marchand : chaque grimoire vendu (objet connu des données, ou livre réservé aux démonistes) est noté
-- avec son niveau requis et son prix (réduction de réputation comprise), sous « g<objet> » ; « Déjà connu »
-- dans l'infobulle (avec le bon démon invoqué) : grimoire appris.
local function MerchantItem(i)
    local id = GetMerchantItemID and GetMerchantItemID(i)
    if not id and GetMerchantItemLink then
        local link = GetMerchantItemLink(i)
        id = link and tonumber(tostring(link):match("item:(%d+)"))
    end
    local name, price
    if C_MerchantFrame and C_MerchantFrame.GetItemInfo then
        local ok, info = pcall(C_MerchantFrame.GetItemInfo, i)
        if ok and type(info) == "table" then name, price = info.name, info.price end
    end
    if not name and GetMerchantItemInfo then
        local ok, n, _, p = pcall(GetMerchantItemInfo, i)
        if ok then name, price = n, p end
    end
    return id, name, price
end
local function TooltipLines(i)
    local out = {}
    if C_TooltipInfo and C_TooltipInfo.GetMerchantItem then
        local ok, td = pcall(C_TooltipInfo.GetMerchantItem, i)
        if ok and type(td) == "table" then for _, l in ipairs(td.lines or {}) do out[#out + 1] = l.leftText or "" end end
    end
    return out
end
local function ScanDemonTrainer()
    if not FC.db or not GetMerchantNumItems then return 0 end
    local cname, token = UnitClass("player")
    if token ~= "WARLOCK" then return 0 end
    local byItem = {}
    for _, g in ipairs(GrimoireData()) do byItem[g.it] = g end
    local seen, known = Scans(token), GrimoiresKnown()
    local fac = FacLetter()
    local rx = UnitReaction and UnitReaction("npc", "player") or nil
    local classLine = ITEM_CLASSES_ALLOWED and cname and ITEM_CLASSES_ALLOWED:format(cname) or nil
    local n = 0
    for i = 1, (GetMerchantNumItems() or 0) do
        local id, name, price = MerchantItem(i)
        if id then
            local lines = TooltipLines(i)
            local g = byItem[id]
            if not g then   -- pas dans les données : livre (recette) réservé aux démonistes
                local classID = select(6, API.GetItemInfoInstant(id))
                if classID == 9 and classLine then
                    for _, t in ipairs(lines) do if t == classLine then g = true end end
                end
            end
            if g then
                local key = "g" .. id
                local s = seen[key] or {}
                s.l = tonumber((select(5, API.GetItemInfo(id)))) or s.l or (type(g) == "table" and g.l) or nil
                s.c = tonumber(price) or s.c
                s.rx, s.at, s.n = rx, time(), name or s.n
                if fac and not tostring(s.fa or ""):find(fac, 1, true) then s.fa = (s.fa or "") .. fac end
                seen[key] = s
                for _, t in ipairs(lines) do if ITEM_SPELL_KNOWN and t == ITEM_SPELL_KNOWN then known[id] = true end end
                n = n + 1
            end
        end
    end
    return n
end
FC.TrainingScanDemon = ScanDemonTrainer   -- tests

-- Texte à coller dans le Studio (Importer → « Sorts de classe relevés en jeu »)
function FC:TrainingExportText()
    local L, n = { "FCTRAIN1" }, 0
    for token, spells in pairs(Scans()) do
        local ids = {}
        for id in pairs(spells) do ids[#ids + 1] = id end
        table.sort(ids, function(a, b)   -- sorts (nombres) puis grimoires (« g<objet> »)
            if type(a) ~= type(b) then return type(a) == "number" end
            return a < b
        end)
        for _, id in ipairs(ids) do
            local s = spells[id]
            L[#L + 1] = table.concat({ token, id, s.l or 0, s.c or 0, s.rx or "", s.fa or "", tostring(s.n or ""):gsub(";", ","), s.r or "" }, ";")
            n = n + 1
        end
    end
    return table.concat(L, "\n"), n
end
local exportFrame
function FC:ShowTrainingExport()
    local text, n = self:TrainingExportText()
    if n == 0 then
        print("|cffffd700" .. FC.NAME .. "|r : nothing recorded yet. Open your class trainer (or the demon trainer) first.")
        return
    end
    if not exportFrame then
        local f = API.CreateWindow("ForeverCompanionTrainingExport", UIParent)
        f:SetSize(460, 420); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG")
        f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        API.WindowTitle(f):SetText(FC.NAME .. " — trainer spells")
        f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        f.hint:SetPoint("TOPLEFT", 14, -30); f.hint:SetWidth(430); f.hint:SetJustifyH("LEFT")
        local sf = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        sf:SetPoint("TOPLEFT", 12, -66); sf:SetPoint("BOTTOMRIGHT", -32, 12)
        local eb = CreateFrame("EditBox", nil, sf)
        eb:SetMultiLine(true); eb:SetAutoFocus(true); eb:SetFontObject(ChatFontNormal); eb:SetWidth(400)
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)
        f.edit = eb
        API.CloseOnEscape(f)
        exportFrame = f
    end
    exportFrame.hint:SetText(n .. " spell(s) and grimoire(s) seen at trainers.\nCtrl+A then Ctrl+C, and paste in the Studio: Import > « Sorts de classe relevés en jeu ».")
    exportFrame.edit:SetText(text)
    exportFrame.edit:HighlightText()
    exportFrame:Show(); exportFrame:Raise()
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "ADDON_LOADED", "PLAYER_LOGIN", "PLAYER_LEVEL_UP", "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB", "PLAYER_MONEY", "TRAINER_SHOW",
    "MERCHANT_SHOW", "MERCHANT_UPDATE", "UNIT_PET", "PET_BAR_UPDATE" }) do
    pcall(ev.RegisterEvent, ev, e)
end
local queued, merchantQueued = false, false
ev:SetScript("OnEvent", function(_, e, name)
    if e == "ADDON_LOADED" then
        if name == "Blizzard_PlayerSpells" then Attach() end
        return
    end
    if e == "PLAYER_LOGIN" then Attach(); return end
    if e == "TRAINER_SHOW" then   -- seulement à l'ouverture (changer les filtres relance TRAINER_UPDATE)
        C_Timer.After(0.3, function()
            if ScanTrainer() > 0 and book and book:IsVisible() then Render(); UpdateBadge() end
        end)
        return
    end
    if e == "MERCHANT_SHOW" or e == "MERCHANT_UPDATE" then   -- maître des démons
        if merchantQueued then return end
        merchantQueued = true
        C_Timer.After(e == "MERCHANT_SHOW" and 0.3 or 1, function()
            merchantQueued = false
            if ScanDemonTrainer() > 0 and book and book:IsVisible() then Render(); UpdateBadge() end
        end)
        return
    end
    if e == "UNIT_PET" or e == "PET_BAR_UPDATE" or e == "SPELLS_CHANGED" then CheckPetGrimoires() end
    if not book or queued then return end   -- sorts appris, niveau, or : liste et pastille à jour
    queued = true
    C_Timer.After(0.2, function()
        queued = false
        if book and book:IsVisible() then Render(); UpdateBadge() end
    end)
end)
