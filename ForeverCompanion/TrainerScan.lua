-- Forever Companion — TrainerScan.lua
-- Relevé des recettes enseignées par les maîtres de métier, à l'ouverture de
-- leur fenêtre. Les recettes absentes des données s'affichent tout de suite dans
-- la fenêtre Métiers ; le Studio peut aussi les importer depuis le fichier de
-- sauvegarde de l'addon (WTF\Account\<compte>\SavedVariables\ForeverCompanion.lua).
--
-- FC.db.global.trainerScans[id du métier][clé] = {
--   id = sort de la recette, n = nom (langue du client), l = compétence requise,
--   it = objet produit, itn = son nom, c = quantité produite, rg = {{id, nombre, nom}},
--   cost = prix d'apprentissage (cuivre), t = date, tr = maître, z = zone }
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local TS = {}
FC.TrainerScan = TS

-- ── Index des recettes des données (par sort et par objet produit) ──────
local indexCache = {}
function TS.RecipeIndex(p)
    local idx = indexCache[p]
    if idx then return idx end
    idx = { spell = {}, item = {} }
    for _, c in ipairs(p.c or {}) do
        for _, r in ipairs(c.r or {}) do
            if r.id and r.id > 0 then idx.spell[r.id] = r end
            if r.it and r.it.id then idx.item[r.it.id] = r end
        end
    end
    indexCache[p] = idx
    return idx
end

-- ── Métier enseigné : vote des recettes connues, sinon nom du métier ────
local function Norm(s) return API.SearchNorm(tostring(s or "")) end
local function ProfessionByName(name)
    if not name or name == "" then return nil end
    local n = Norm(name)
    local mine = {}
    if GetProfessions and GetProfessionInfo then
        local res = { pcall(GetProfessions) }
        if res[1] then
            for i = 2, 6 do
                if res[i] then
                    local ok, pname, _, _, _, _, _, sl = pcall(GetProfessionInfo, res[i])
                    if ok and pname and sl then mine[Norm(pname)] = sl end
                end
            end
        end
    end
    for _, p in ipairs(FC.Professions) do
        if Norm(p.n or p.id) == n then return p end
        if p.sl and mine[n] == p.sl then return p end
        if p.sl and C_TradeSkillUI and C_TradeSkillUI.GetTradeSkillDisplayName then
            local ok, loc = pcall(C_TradeSkillUI.GetTradeSkillDisplayName, p.sl)
            if ok and loc and Norm(loc) == n then return p end
        end
    end
end

-- ── Détails d'une recette ────────────────────────────────────────────────
local function ServiceSpellID(i)
    if C_TooltipInfo and C_TooltipInfo.GetTrainerService then
        local ok, data = pcall(C_TooltipInfo.GetTrainerService, i)
        if ok and type(data) == "table" and type(data.id) == "number" and data.id > 0 then return data.id end
    end
end

local function ItemName(id)
    local n = id and API.GetItemInfo(id)
    return n
end

-- Objet produit et composants : schéma de recette du jeu, sinon anciennes fonctions du maître
local function Details(i, spellID)
    local out = { rg = {} }
    if spellID and C_TradeSkillUI and C_TradeSkillUI.GetRecipeSchematic then
        local ok, sc = pcall(C_TradeSkillUI.GetRecipeSchematic, spellID, false)
        if ok and type(sc) == "table" then
            if sc.outputItemID and sc.outputItemID > 0 then out.it = sc.outputItemID end
            if sc.quantityMin and sc.quantityMin > 1 then out.c = sc.quantityMin end
            for _, slot in ipairs(sc.reagentSlotSchematics or {}) do
                local r = slot.reagents and slot.reagents[1]
                if r and r.itemID and slot.required ~= false and (slot.quantityRequired or 0) > 0 then
                    table.insert(out.rg, { r.itemID, slot.quantityRequired, ItemName(r.itemID) })
                end
            end
        end
    end
    if not out.it and GetTrainerServiceItemLink then
        local ok, link = pcall(GetTrainerServiceItemLink, i)
        local id = ok and link and tonumber(link:match("item:(%d+)"))
        if id then out.it = id end
    end
    if #out.rg == 0 and GetTrainerServiceNumReagents and GetTrainerServiceReagentInfo then
        local okN, nR = pcall(GetTrainerServiceNumReagents, i)
        for k = 1, (okN and nR or 0) do
            local okR, rname, _, count = pcall(GetTrainerServiceReagentInfo, i, k)
            local id
            if GetTrainerServiceReagentLink then
                local okL, link = pcall(GetTrainerServiceReagentLink, i, k)
                id = okL and link and tonumber(link:match("item:(%d+)"))
            end
            id = id or (rname and tonumber((API.GetItemInfoInstant(rname))))
            if okR and (id or rname) then table.insert(out.rg, { id or 0, count or 1, rname }) end
        end
    end
    if out.it then out.itn = ItemName(out.it) end
    return out
end

-- ── Relevé ───────────────────────────────────────────────────────────────
local scanning = false
function TS.Scan()
    if scanning or not FC.db or FC.db.global.trainer_scan == false then return nil end
    if not (GetNumTrainerServices and GetTrainerServiceInfo) then return nil end
    scanning = true
    -- Tous les types de services (disponibles, indisponibles, déjà appris), puis on remet les filtres
    local saved = {}
    if GetTrainerServiceTypeFilter and SetTrainerServiceTypeFilter then
        for _, t in ipairs({ "available", "unavailable", "used" }) do
            local ok, v = pcall(GetTrainerServiceTypeFilter, t)
            saved[t] = ok and v and true or false
            if not saved[t] then pcall(SetTrainerServiceTypeFilter, t, true) end
        end
    end
    if ExpandTrainerSkillLine then pcall(ExpandTrainerSkillLine, 0) end

    local found, votes, byName = {}, {}, {}
    local ok, err = pcall(function()
        for i = 1, (GetNumTrainerServices() or 0) do
            local name, _, category = GetTrainerServiceInfo(i)
            if name and category and category ~= "header" then
                local skillName, skillRank
                if GetTrainerServiceSkillReq then skillName, skillRank = GetTrainerServiceSkillReq(i) end
                local line = (GetTrainerServiceSkillLine and GetTrainerServiceSkillLine(i)) or skillName
                local spellID = ServiceSpellID(i)
                local e = { id = spellID, n = name, l = tonumber(skillRank) or 0 }
                if GetTrainerServiceCost then e.cost = GetTrainerServiceCost(i) end
                local d = Details(i, spellID)
                e.it, e.c, e.itn = d.it, d.c, d.itn
                if #d.rg > 0 then e.rg = d.rg end
                table.insert(found, e)
                -- Vote : recette connue d'un métier des données (sort ou objet produit)
                for _, p in ipairs(FC.Professions) do
                    local idx = TS.RecipeIndex(p)
                    if (spellID and idx.spell[spellID]) or (e.it and idx.item[e.it]) then votes[p] = (votes[p] or 0) + 1 end
                end
                if line then byName[line] = (byName[line] or 0) + 1 end
            end
        end
    end)
    -- Filtres d'origine
    for t, v in pairs(saved) do if not v then pcall(SetTrainerServiceTypeFilter, t, false) end end
    scanning = false
    if not ok then return nil, err end
    if #found == 0 then return nil end

    local prof, best = nil, 0
    for p, n in pairs(votes) do if n > best then prof, best = p, n end end
    if not prof then
        local topName, topN = nil, 0
        for nm, n in pairs(byName) do if n > topN then topName, topN = nm, n end end
        prof = ProfessionByName(topName)
    end
    if not prof then return nil end   -- maître de classe, ou métier absent des données

    local all = FC.db.global.trainerScans
    all[prof.id] = all[prof.id] or {}
    local store, now = all[prof.id], time()
    local trainer = UnitName and UnitName("npc")
    local zone = GetZoneText and GetZoneText()
    local idx = TS.RecipeIndex(prof)
    local new, missing = 0, 0
    for _, e in ipairs(found) do
        local key = e.id and tostring(e.id) or ("n:" .. e.n)
        if not store[key] then new = new + 1 end
        e.t, e.tr, e.z = now, trainer, zone
        store[key] = e
        if not ((e.id and idx.spell[e.id]) or (e.it and idx.item[e.it])) then missing = missing + 1 end
    end
    if new > 0 then
        print(string.format("|cffffd700%s|r : %s trainer — %d recipes recorded (%d new, %d not in the addon data yet).",
            FC.NAME, prof.n or prof.id, #found, new, missing))
    end
    if FC.RefreshProfessionTabs then FC:RefreshProfessionTabs() end
    return prof, #found, new, missing
end

-- Recettes relevées absentes des données d'un métier, au format des données
function TS.Extra(p)
    local scans = FC.db and FC.db.global.trainer_scan ~= false and FC.db.global.trainerScans and FC.db.global.trainerScans[p.id]
    if not scans then return {} end
    local idx = TS.RecipeIndex(p)
    local out = {}
    for _, e in pairs(scans) do
        if not ((e.id and idx.spell[e.id]) or (e.it and idx.item[e.it])) then
            local r = { id = e.id or 0, n = e.itn or e.n, l = e.l or 0, s = {}, src = "t", scanned = true, rc = p.g and true or nil }
            if e.it then r.it = { id = e.it, c = e.c } end
            if e.rg then
                r.rg = {}
                for _, x in ipairs(e.rg) do r.rg[#r.rg + 1] = { x[1] or 0, x[2] or 1, x[3] } end
            end
            out[#out + 1] = r
        end
    end
    return out
end

-- ── Évènements ───────────────────────────────────────────────────────────
-- Deux essais après l'ouverture (la liste du maître peut arriver avec un léger retard).
-- Pas de relevé sur TRAINER_UPDATE : nos changements de filtre le déclenchent.
local ev = CreateFrame("Frame")
local open = false
ev:SetScript("OnEvent", function(_, e)
    if not FC.db then return end
    if e == "TRAINER_SHOW" then
        open = true
        C_Timer.After(0.3, function()
            if open and not TS.Scan() then
                C_Timer.After(1.2, function() if open then TS.Scan() end end)
            end
        end)
    elseif e == "TRAINER_CLOSED" then
        open = false
    end
end)
for _, e in ipairs({ "TRAINER_SHOW", "TRAINER_CLOSED" }) do pcall(ev.RegisterEvent, ev, e) end
