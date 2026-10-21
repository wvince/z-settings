-- Forever Companion — RecipeScan.lua
-- Relevé des recettes À LA DEMANDE uniquement (aucun relevé automatique) :
--   /fc recipes scan  : lit la fenêtre ouverte (métier, maître de métier ou marchand)
--                       et demande à quel métier elle correspond avant d'enregistrer ;
--   /fc recipes       : texte à coller dans le Studio (Importer → Recettes scannées en jeu) ;
--   /fc recipes clear : efface le relevé.
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local RS = {}
FC.RecipeScan = RS
local DATA_VERSION = 3   -- les relevés automatiques des versions précédentes sont effacés

local function DB()
    local g = FC.db and FC.db.global
    if not g then return nil end
    if not g.recipeScan or g.recipeScan.v ~= DATA_VERSION then
        g.recipeScan = { v = DATA_VERSION, profs = {}, trainer = {}, vendor = {} }
    end
    return g.recipeScan
end
RS.DB = DB

local function Say(msg) print("|cffffd700" .. FC.NAME .. "|r : " .. msg) end
local function ItemIdFromLink(link) return link and tonumber(link:match("item:(%d+)")) end
local function SpellIdFromLink(link) return link and tonumber(link:match("enchant:(%d+)") or link:match("spell:(%d+)")) end
local function Shown(name) local f = _G[name]; return f and f.IsShown and f:IsShown() end

-- Métiers proposés : ceux des données (dans l'ordre choisi), puis les métiers standard absents
local STANDARD = {
    { "alchemy", "Alchemy", "trade_alchemy", 171 }, { "blacksmithing", "Blacksmithing", "trade_blacksmithing", 164 },
    { "cooking", "Cooking", "inv_misc_food_15", 185 }, { "enchanting", "Enchanting", "trade_engraving", 333 },
    { "engineering", "Engineering", "trade_engineering", 202 }, { "first-aid", "First Aid", "spell_holy_sealofsacrifice", 129 },
    { "leatherworking", "Leatherworking", "trade_leatherworking", 165 }, { "tailoring", "Tailoring", "trade_tailoring", 197 },
    { "mining", "Mining", "trade_mining", 186 }, { "herbalism", "Herbalism", "spell_nature_naturetouchgrow", 182 },
    { "skinning", "Skinning", "inv_misc_pelt_wolf_01", 393 }, { "fishing", "Fishing", "trade_fishing", 356 },
}
function RS.Choices()
    local out, seen = {}, {}
    local order = (FC.GetProfessionOrder and FC.db) and FC:GetProfessionOrder(true) or {}
    for _, i in ipairs(order) do
        local p = FC.Professions[i]
        if p and not seen[p.id] then seen[p.id] = true; out[#out + 1] = { id = p.id, n = p.n or p.id, ic = p.ic, sl = p.sl } end
    end
    for _, s in ipairs(STANDARD) do
        if not seen[s[1]] then seen[s[1]] = true; out[#out + 1] = { id = s[1], n = s[2], ic = s[3], sl = s[4] } end
    end
    return out
end

-- ── Lecture de la fenêtre ouverte ────────────────────────────────────────
-- Couleur → palier franchi : 0 orange, 1 jaune, 2 vert, 3 gris
local DIFF = { optimal = 0, medium = 1, easy = 2, trivial = 3, difficult = 0 }

-- Fenêtre de métier, ancienne API (liste affichée) ou artisanat (Enchantement en Classic)
local function ReadList(kind)
    local isCraft = kind == "craft"
    local lineFn = isCraft and GetCraftDisplaySkillLine or GetTradeSkillLine
    local numFn = isCraft and GetNumCrafts or GetNumTradeSkills
    if not (lineFn and numFn) then return nil end
    if not isCraft and IsTradeSkillLinked and IsTradeSkillLinked() then return nil, "linked" end
    local name, rank = lineFn()
    local n = numFn() or 0
    if not name or name == "UNKNOWN" or n == 0 then return nil end
    local list = {}
    for i = 1, n do
        local sname, stype
        if isCraft then local a, _, t = GetCraftInfo(i); sname, stype = a, t
        else sname, stype = GetTradeSkillInfo(i) end
        if sname and stype ~= "header" and stype ~= "subheader" then
            local r = { n = sname, rg = {}, d = DIFF[stype], l = true }
            r.id = SpellIdFromLink(isCraft and GetCraftItemLink and GetCraftItemLink(i) or (GetTradeSkillRecipeLink and GetTradeSkillRecipeLink(i)))
            if not isCraft then
                r.it = ItemIdFromLink(GetTradeSkillItemLink(i))
                if r.it and GetTradeSkillNumMade then r.c = GetTradeSkillNumMade(i) or 1 end
            end
            for k = 1, ((isCraft and GetCraftNumReagents or GetTradeSkillNumReagents)(i) or 0) do
                local _, _, cnt = (isCraft and GetCraftReagentInfo or GetTradeSkillReagentInfo)(i, k)
                local id = ItemIdFromLink((isCraft and GetCraftReagentItemLink or GetTradeSkillReagentItemLink)(i, k))
                if id then table.insert(r.rg, { id, cnt or 1 }) end
            end
            list[#list + 1] = r
        end
    end
    return { kind = "recipes", window = name, rank = rank, list = list }
end

-- Fenêtre de métier, API actuelle : seulement les recettes affichées (filtrées) si possible,
-- et, si le jeu indique le métier de chaque recette, celles du métier de la fenêtre
local function RecipeProfession(T, id)
    if T.GetProfessionInfoByRecipeID then
        local ok, pi = pcall(T.GetProfessionInfoByRecipeID, id)
        if ok and type(pi) == "table" then
            local n = (pi.parentProfessionName and pi.parentProfessionName ~= "" and pi.parentProfessionName) or pi.professionName
            if n and n ~= "" then return n end
        end
    end
    if T.GetTradeSkillLineForRecipe then
        local ok, _, sn, _, psn = pcall(T.GetTradeSkillLineForRecipe, id)
        if ok then local n = (psn and psn ~= "" and psn) or sn; if n and n ~= "" then return n end end
    end
end
local function ReadModern()
    local T = C_TradeSkillUI
    if not (T and T.GetRecipeInfo and (T.GetFilteredRecipeIDs or T.GetAllRecipeIDs)) then return nil end
    for _, f in ipairs({ "IsTradeSkillLinked", "IsTradeSkillGuild", "IsNPCCrafting" }) do
        if T[f] then local ok, v = pcall(T[f]); if ok and v then return nil, "linked" end end
    end
    local base = T.GetBaseProfessionInfo and T.GetBaseProfessionInfo()
    local child = T.GetChildProfessionInfo and T.GetChildProfessionInfo()
    local window = (base and base.professionName) or (child and child.professionName) or "?"
    local rank = (child and child.skillLevel and child.skillLevel > 0 and child.skillLevel) or (base and base.skillLevel)
    local ids
    if T.GetFilteredRecipeIDs then local ok, v = pcall(T.GetFilteredRecipeIDs); if ok and type(v) == "table" and #v > 0 then ids = v end end
    ids = ids or (T.GetAllRecipeIDs and T.GetAllRecipeIDs()) or {}
    local list, byProf = {}, {}
    for _, id in ipairs(ids) do
        local ok, info = pcall(T.GetRecipeInfo, id)
        if ok and info and not info.isDummyRecipe and not info.isRecraft then
            local r = { id = id, n = info.name, rg = {}, d = info.relativeDifficulty, l = info.learned ~= false, prof = RecipeProfession(T, id) }
            local okS, sch = pcall(T.GetRecipeSchematic, id, false)
            if okS and sch then
                if sch.outputItemID and sch.outputItemID > 0 then r.it, r.c = sch.outputItemID, sch.quantityMin or 1 end
                for _, slot in ipairs(sch.reagentSlotSchematics or {}) do
                    local rg = slot.reagents and slot.reagents[1]
                    if (slot.reagentType == nil or slot.reagentType == 1) and rg and rg.itemID then table.insert(r.rg, { rg.itemID, slot.quantityRequired or 1 }) end
                end
            end
            list[#list + 1] = r
            if r.prof then byProf[r.prof] = (byProf[r.prof] or 0) + 1 end
        end
    end
    -- Plusieurs métiers mélangés : on garde celui de la fenêtre, sinon le plus représenté
    local keep, best, ignored = nil, 0, 0
    if byProf[window] then keep = window else for p, n in pairs(byProf) do if n > best then keep, best = p, n end end end
    if keep then
        local k = {}
        for _, r in ipairs(list) do if not r.prof or r.prof == keep then k[#k + 1] = r else ignored = ignored + 1 end end
        list = k
    end
    return { kind = "recipes", window = keep or window, rank = rank, list = list, ignored = ignored }
end

-- Maître de métier : compétence requise des recettes enseignées
local function ReadTrainer()
    if not (GetNumTrainerServices and GetTrainerServiceInfo and GetTrainerServiceSkillReq) then return nil end
    local list, window = {}, nil
    for i = 1, (GetNumTrainerServices() or 0) do
        local ok, name, _, cat = pcall(GetTrainerServiceInfo, i)
        if ok and name and cat ~= "header" then
            local okR, skill, level = pcall(GetTrainerServiceSkillReq, i)
            if okR and skill and level and level > 0 then
                window = window or skill
                local ic = GetTrainerServiceIcon and GetTrainerServiceIcon(i)
                list[#list + 1] = { n = name, it = GetTrainerServiceItemLink and ItemIdFromLink(GetTrainerServiceItemLink(i)), l = level,
                    sk = skill, ic = (type(ic) == "number" or type(ic) == "string") and ic or nil }
            end
        end
    end
    if #list == 0 then return nil end
    return { kind = "trainer", window = window or "?", list = list }
end

-- Marchand : recettes et plans vendus (pas de métier à choisir)
local function ReadVendor()
    if not (GetMerchantNumItems and GetMerchantItemLink) then return nil end
    local npc = UnitName and UnitName("npc")
    local zone = (GetRealZoneText and GetRealZoneText()) or (GetZoneText and GetZoneText())
    local list = {}
    for i = 1, (GetMerchantNumItems() or 0) do
        local link = GetMerchantItemLink(i)
        local id = ItemIdFromLink(link)
        if id and select(6, API.GetItemInfoInstant(id)) == 9 then   -- Enum.ItemClass.Recipe
            local price
            if C_MerchantFrame and C_MerchantFrame.GetItemInfo then local info = C_MerchantFrame.GetItemInfo(i); price = info and info.price
            elseif GetMerchantItemInfo then price = select(3, GetMerchantItemInfo(i)) end
            list[#list + 1] = { it = id, n = link:match("%[(.-)%]"), pr = price, npc = npc, z = zone }
        end
    end
    return { kind = "vendor", window = npc or "?", list = list }
end

-- Fenêtre ouverte, dans cet ordre : métier, maître de métier, marchand
function RS.ReadOpenWindow()
    local tradeOpen = Shown("TradeSkillFrame") or Shown("ProfessionsFrame")
    local craftOpen = Shown("CraftFrame")
    if tradeOpen or craftOpen then
        local res, why
        if craftOpen then res, why = ReadList("craft") end
        if not res and tradeOpen then
            res, why = ReadList("trade")
            if not res and why ~= "linked" then res, why = ReadModern() end
        end
        if why == "linked" then return nil, "this is another player's profession" end
        if res and #res.list > 0 then return res end
        return nil, "no recipe in this window"
    end
    if Shown("ClassTrainerFrame") then
        local res = ReadTrainer()
        if res then return res end
        return nil, "no profession recipe at this trainer"
    end
    if Shown("MerchantFrame") then return ReadVendor() end
    return nil, "open a profession window, a profession trainer or a recipe vendor first"
end

-- ── Enregistrement ───────────────────────────────────────────────────────
-- Seuils jaune (1), vert (2), gris (3) d'après la couleur vue à la compétence actuelle :
-- seuil i compris dans ]lo, hi] ; exact quand hi = lo + 1 (relevés successifs).
local function Observe(rec, rank, diff)
    if not (rank and diff) then return end
    rec.o = rec.o or {}
    for i = 1, 3 do
        local b = rec.o[i] or {}
        rec.o[i] = b
        if diff >= i then if not b.hi or rank < b.hi then b.hi = rank end
        else if not b.lo or rank > b.lo then b.lo = rank end end
    end
end

function RS.Save(res, choice)
    local d = DB(); if not d or not res then return 0, 0 end
    if res.kind == "vendor" then
        for _, v in ipairs(res.list) do d.vendor["i" .. v.it] = v end
        return #res.list, 0
    end
    if res.kind == "trainer" then
        local new = 0
        for _, t in ipairs(res.list) do
            t.pid = choice.id
            local key = choice.id .. ":" .. (t.it and ("i" .. t.it) or t.n)
            if not d.trainer[key] then new = new + 1 end
            d.trainer[key] = t
        end
        return #res.list, new
    end
    local p = d.profs[choice.id] or { recipes = {} }
    d.profs[choice.id] = p
    p.pid, p.n, p.sl, p.window = choice.id, choice.n, choice.sl, res.window
    if res.rank and (not p.rank or res.rank > p.rank) then p.rank = res.rank end
    local new = 0
    for _, r in ipairs(res.list) do
        local key = r.id and ("s" .. r.id) or ("n:" .. (r.n or "?"))
        local rec = p.recipes[key]
        if not rec then rec = {}; p.recipes[key] = rec; new = new + 1 end
        rec.id, rec.n = r.id or rec.id, r.n or rec.n
        if r.it then rec.it, rec.c = r.it, r.c end
        if #r.rg > 0 then rec.rg = r.rg end
        rec.l = r.l and true or nil
        if r.l then Observe(rec, res.rank, r.d) end
    end
    return #res.list, new
end

-- ── Recettes relevées à afficher dans la fenêtre Métiers ─────────────────
-- Celles du métier choisi au relevé qui ne sont pas déjà dans les données (même sort,
-- même objet ou même nom). Les formations de rang du maître (« Minage d'apprenti ») sont ignorées.
local function Norm(s) return API.SearchNorm(tostring(s or "")) end
function RS.Extra(p)
    local g = FC.db and FC.db.global
    local d = g and g.recipeScan
    if not (p and d and d.v == DATA_VERSION) then return {} end
    local have = { id = {}, item = {}, name = {} }
    for _, c in ipairs(p.c or {}) do
        for _, r in ipairs(c.r or {}) do
            if r.id and r.id ~= 0 then have.id[r.id] = true end
            if r.it and r.it.id then have.item[r.it.id] = true end
            if r.n then have.name[Norm(r.n)] = true end
        end
    end
    local trainItem, trainName = {}, {}
    for _, t in pairs(d.trainer or {}) do
        if t.pid == p.id then
            if t.it then trainItem[t.it] = t end
            trainName[Norm(t.n)] = t
        end
    end
    local out, shownItem = {}, {}
    local sp = d.profs and d.profs[p.id]
    for _, rec in pairs(sp and sp.recipes or {}) do
        local known = (rec.id and have.id[rec.id]) or (rec.it and have.item[rec.it]) or have.name[Norm(rec.n)]
        if not known then
            local t = (rec.it and trainItem[rec.it]) or trainName[Norm(rec.n)]
            local s = {}
            for i = 1, 3 do
                local b = rec.o and rec.o[i]
                if b and b.lo and b.hi and b.hi == b.lo + 1 then s[i] = b.hi else break end
            end
            out[#out + 1] = { id = rec.id or 0, n = rec.n, l = t and t.l or 0, s = s,
                it = rec.it and { id = rec.it, c = (rec.c and rec.c > 1) and rec.c or nil } or nil,
                rg = rec.rg or {}, src = t and "t" or nil, rc = p.g and true or nil, scanned = true }
            if rec.it then shownItem[rec.it] = true end
        end
    end
    for _, t in pairs(d.trainer or {}) do
        -- sans objet produit : formation de rang (« Minage d'apprenti ») si le nom contient celui du métier
        local rankUp = not (t.it and t.it > 0) and t.sk and t.sk ~= "" and Norm(t.n):find(Norm(t.sk), 1, true)
        if t.pid == p.id and not rankUp and not (t.it and (have.item[t.it] or shownItem[t.it])) and not have.name[Norm(t.n)] then
            out[#out + 1] = { id = 0, n = t.n, l = t.l or 0, s = {}, it = (t.it and t.it > 0) and { id = t.it } or nil, ic = t.ic,
                rg = {}, src = "t", rc = p.g and true or nil, scanned = true }
        end
    end
    return out
end
RS.EXTRA_CATEGORY = "Scanned in game"

-- ── Choix du métier ──────────────────────────────────────────────────────
local picker
local function ShowPicker(res)
    if not picker then
        local f = API.CreateWindow("ForeverCompanionRecipePicker", UIParent)
        f:SetSize(420, 360); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG")
        f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        API.CloseOnEscape(f)
        API.WindowTitle(f):SetText(FC.NAME .. " — which profession?")
        f.info = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        f.info:SetPoint("TOPLEFT", 16, -32); f.info:SetWidth(388); f.info:SetJustifyH("LEFT")
        f.btns = {}
        f.cancel = API.CreateMenuButton(f, 120, 22, "Cancel")
        f.cancel:SetPoint("BOTTOM", 0, 12)
        f.cancel:SetScript("OnClick", function() f:Hide(); Say("scan cancelled, nothing recorded.") end)
        picker = f
    end
    local f = picker
    local sample = {}
    for i = 1, math.min(4, #res.list) do sample[i] = res.list[i].n end
    local what = res.kind == "trainer" and "trainer recipes" or "recipes"
    f.info:SetText(string.format("Window: |cffffd100%s|r — %d %s%s\n|cff9d9d9d%s%s|r\n\nWhich profession is it? Nothing is recorded before you choose.",
        tostring(res.window), #res.list, what, (res.ignored or 0) > 0 and string.format(" (%d of another profession ignored)", res.ignored) or "",
        table.concat(sample, ", "), #res.list > #sample and ", …" or ""))
    for _, b in ipairs(f.btns) do b:Hide() end
    local choices = RS.Choices()
    local top = -32 - (f.info:GetStringHeight() or 56) - 10
    for i, c in ipairs(choices) do
        local b = f.btns[i]
        if not b then
            b = API.CreateMenuButton(f, 186, 24, "")
            b.icon = b:CreateTexture(nil, "OVERLAY"); b.icon:SetSize(16, 16); b.icon:SetPoint("LEFT", 8, 0)
            f.btns[i] = b
        end
        local col, row = (i - 1) % 2, math.floor((i - 1) / 2)
        b:ClearAllPoints(); b:SetPoint("TOPLEFT", 16 + col * 194, top - row * 28)
        b:SetText(c.n); b.icon:SetTexture(API.IconPath(c.ic))
        b:SetScript("OnClick", function()
            local n, new = RS.Save(res, c)
            f:Hide()
            if FC.RefreshProfessionTabs then FC:RefreshProfessionTabs() end
            Say(string.format("%s: %d %s recorded (%d new). /fc recipes to export.", c.n, n, what, new))
        end)
        b:Show()
    end
    f:SetHeight(math.max(200, -top + math.ceil(#choices / 2) * 28 + 48))
    f:Show(); f:Raise()
end
RS.ShowPicker = ShowPicker

-- ── Commande /fc recipes ─────────────────────────────────────────────────
function FC:RecipeCommand(arg)
    arg = arg and arg:lower() or ""
    if arg == "scan" then
        local res, why = RS.ReadOpenWindow()
        if not res then Say("nothing to scan: " .. tostring(why) .. "."); return end
        if res.kind == "vendor" then
            local n = RS.Save(res)
            Say(n > 0 and string.format("%d recipe(s) sold by %s recorded. /fc recipes to export.", n, tostring(res.window)) or "this vendor sells no recipe.")
            return
        end
        ShowPicker(res)
    elseif arg == "clear" or arg == "effacer" then
        if FC.db then FC.db.global.recipeScan = nil end
        if FC.RefreshProfessionTabs then FC:RefreshProfessionTabs() end
        Say("recipe scan cleared.")
    else
        FC:ShowRecipeExport()
    end
end

-- ── Export (JSON pour le Studio) ─────────────────────────────────────────
local function Json(v)
    local t = type(v)
    if t == "number" then return (v == math.floor(v)) and string.format("%d", v) or tostring(v) end
    if t == "boolean" then return v and "true" or "false" end
    if t == "string" then
        return '"' .. v:gsub('[%c"\\]', function(c)
            if c == '"' then return '\\"' elseif c == "\\" then return "\\\\" elseif c == "\n" then return "\\n" end
            return string.format("\\u%04x", c:byte())
        end) .. '"'
    end
    if t ~= "table" then return "null" end
    if #v > 0 or next(v) == nil then
        local out = {}
        for i = 1, #v do out[i] = Json(v[i]) end
        return "[" .. table.concat(out, ",") .. "]"
    end
    local keys = {}
    for k in pairs(v) do keys[#keys + 1] = tostring(k) end
    table.sort(keys)
    local out = {}
    for _, k in ipairs(keys) do out[#out + 1] = Json(k) .. ":" .. Json(v[k]) end
    return "{" .. table.concat(out, ",") .. "}"
end
RS.Json = Json

function RS.Export()
    local d = DB(); if not d then return "" end
    local profs = {}
    for _, p in pairs(d.profs) do
        local recipes = {}
        for _, r in pairs(p.recipes) do
            local o = {}
            for i = 1, 3 do local b = r.o and r.o[i] or {}; o[i] = { b.lo or -1, b.hi or -1 } end
            table.insert(recipes, { id = r.id or 0, n = r.n or "", it = r.it or 0, c = r.c or 1, rg = r.rg or {}, l = r.l and true or false, o = o })
        end
        table.sort(recipes, function(a, b) return (a.n or "") < (b.n or "") end)
        table.insert(profs, { pid = p.pid, name = p.n, window = p.window or "", sl = p.sl or 0, rank = p.rank or 0, recipes = recipes })
    end
    table.sort(profs, function(a, b) return a.name < b.name end)
    local trainer, vendor = {}, {}
    for _, t in pairs(d.trainer) do table.insert(trainer, { pid = t.pid, n = t.n, it = t.it or 0, l = t.l, sk = t.sk or "" }) end
    for _, v in pairs(d.vendor) do table.insert(vendor, { it = v.it, n = v.n or "", pr = v.pr or 0, npc = v.npc or "", z = v.z or "" }) end
    table.sort(trainer, function(a, b) return a.n < b.n end)
    table.sort(vendor, function(a, b) return a.n < b.n end)
    -- Noms des objets connus du client (produits et composants), pour le Studio
    local items = {}
    local function name(id)
        if not id or id <= 0 or items[tostring(id)] then return end
        local n = (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(id)) or (API.ItemIsCached and API.ItemIsCached(id) and API.GetItemInfo(id))
        if type(n) == "string" and n ~= "" then items[tostring(id)] = n end
    end
    for _, p in ipairs(profs) do for _, r in ipairs(p.recipes) do name(r.it); for _, g in ipairs(r.rg) do name(g[1]) end end end
    return Json({ format = "fc-recipe-scan", v = 2, locale = GetLocale and GetLocale() or "", profs = profs, trainer = trainer, vendor = vendor, items = items })
end

function RS.Counts()
    local d = DB(); if not d then return 0, 0, 0, 0 end
    local np, nr, nt, nv = 0, 0, 0, 0
    for _, p in pairs(d.profs) do np = np + 1; for _ in pairs(p.recipes) do nr = nr + 1 end end
    for _ in pairs(d.trainer) do nt = nt + 1 end
    for _ in pairs(d.vendor) do nv = nv + 1 end
    return np, nr, nt, nv
end

local exportFrame
function FC:ShowRecipeExport()
    local np, nr, nt, nv = RS.Counts()
    if nr == 0 and nt == 0 and nv == 0 then
        Say("nothing recorded yet — open a profession window (or a trainer, or a recipe vendor) and type /fc recipes scan.")
        return
    end
    if not exportFrame then
        local f = API.CreateWindow("ForeverCompanionRecipeExport", UIParent)
        f:SetSize(460, 420); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG")
        f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        API.WindowTitle(f):SetText(FC.NAME .. " — recipes")
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
    exportFrame.hint:SetText(string.format("%d profession(s), %d recipe(s), %d trainer recipe(s), %d vendor recipe(s).\n"
        .. "Ctrl+A then Ctrl+C, and paste in the Studio: Import > « Recettes scannées en jeu ».", np, nr, nt, nv))
    exportFrame.edit:SetText(RS.Export())
    exportFrame.edit:HighlightText()
    exportFrame:Show()
    exportFrame:Raise()
end

-- Pour /fc diag : ce que le jeu dit de la fenêtre ouverte (sans rien enregistrer)
function RS.Diag()
    local res, why = RS.ReadOpenWindow()
    if not res then return "relevé de recettes : " .. tostring(why) end
    local profs = {}
    for _, r in ipairs(res.list) do if r.prof then profs[r.prof] = (profs[r.prof] or 0) + 1 end end
    local parts = {}
    for p, n in pairs(profs) do parts[#parts + 1] = p .. "=" .. n end
    return "relevé de recettes : fenêtre " .. tostring(res.window) .. " (" .. res.kind .. "), " .. #res.list .. " entrées"
        .. ((res.ignored or 0) > 0 and (", " .. res.ignored .. " d'un autre métier écartées") or "")
        .. (#parts > 0 and (" | par recette : " .. table.concat(parts, ", ")) or "")
end
