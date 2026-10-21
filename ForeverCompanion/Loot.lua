-- Forever Companion — Loot.lua
-- Tables de loot des donjons : liste des donjons à gauche, boss et objets à droite.
-- Données : Data/Loot.lua (ForeverCompanionData.dungeons / lootItems), générées par le Studio.
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local W, H = 680, 560
local LIST_W = 190
local ROW_H = 26
local lootFrame

-- Objets BiS de la spé (toutes phases) : [itemId] = true
local function BisSet(cn, sn)
    local set = {}
    local phases = cn and sn and FC.BisData[cn] and FC.BisData[cn][sn]
    for _, slots in pairs(phases or {}) do
        for _, se in ipairs(slots) do
            for _, it in ipairs(se.items or {}) do set[it.itemId] = true end
        end
    end
    return set
end

-- Nom, qualité et icône d'un objet : le client d'abord, les données en secours
local function ItemInfo(id)
    local data = FC.LootItems[id] or FC.CraftItems[id] or {}
    local name, _, quality = API.GetItemInfo(id)
    local icon = API.GetItemIcon(id)
    if not icon and data.ic then icon = API.IconPath(data.ic) end
    return name or data.n or ("Item " .. id), quality or data.r or 1, icon or "Interface\\Icons\\INV_Misc_QuestionMark", data
end

local function QualityHex(q)
    local r, g, b = API.GetItemQualityColor(q or 1)
    return string.format("|cff%02x%02x%02x", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255)
end

-- ── Objets utilisables par la classe du joueur (règles de WoW Classic au niveau max) ──
-- Armures et armes par classe. Les objets sans type (bijoux, capes, tenus en main gauche…)
-- sont utilisables par tous. Table à ajuster ici si WoW Forever change les maîtrises.
local ARMOR = {
    WARRIOR = { cloth = 1, leather = 1, mail = 1, plate = 1, shield = 1 },
    PALADIN = { cloth = 1, leather = 1, mail = 1, plate = 1, shield = 1, libram = 1 },
    HUNTER  = { cloth = 1, leather = 1, mail = 1 },
    ROGUE   = { cloth = 1, leather = 1 },
    PRIEST  = { cloth = 1 },
    SHAMAN  = { cloth = 1, leather = 1, mail = 1, shield = 1, totem = 1 },
    MAGE    = { cloth = 1 },
    WARLOCK = { cloth = 1 },
    DRUID   = { cloth = 1, leather = 1, idol = 1 },
}
local WEAPON = {
    WARRIOR = { axe1 = 1, axe2 = 1, mace1 = 1, mace2 = 1, sword1 = 1, sword2 = 1, polearm = 1, staff = 1, dagger = 1, fist = 1, bow = 1, gun = 1, crossbow = 1, thrown = 1 },
    PALADIN = { axe1 = 1, axe2 = 1, mace1 = 1, mace2 = 1, sword1 = 1, sword2 = 1, polearm = 1 },
    HUNTER  = { axe1 = 1, axe2 = 1, sword1 = 1, sword2 = 1, polearm = 1, staff = 1, dagger = 1, fist = 1, bow = 1, gun = 1, crossbow = 1, thrown = 1 },
    ROGUE   = { mace1 = 1, sword1 = 1, dagger = 1, fist = 1, bow = 1, gun = 1, crossbow = 1, thrown = 1 },
    PRIEST  = { mace1 = 1, dagger = 1, staff = 1, wand = 1 },
    SHAMAN  = { axe1 = 1, axe2 = 1, mace1 = 1, mace2 = 1, staff = 1, dagger = 1, fist = 1 },
    MAGE    = { sword1 = 1, dagger = 1, staff = 1, wand = 1 },
    WARLOCK = { sword1 = 1, dagger = 1, staff = 1, wand = 1 },
    DRUID   = { mace1 = 1, mace2 = 1, staff = 1, dagger = 1, fist = 1 },
}
-- Sous-classes du client (C_Item.GetItemInfoInstant) -> clés ci-dessus
local WEAPON_SUB = { [0] = "axe1", [1] = "axe2", [2] = "bow", [3] = "gun", [4] = "mace1", [5] = "mace2", [6] = "polearm",
    [7] = "sword1", [8] = "sword2", [10] = "staff", [13] = "fist", [15] = "dagger", [16] = "thrown", [18] = "crossbow", [19] = "wand" }
local ARMOR_SUB = { [1] = "cloth", [2] = "leather", [3] = "mail", [4] = "plate", [6] = "shield", [7] = "libram", [8] = "idol", [9] = "totem" }

-- Type d'objet d'après les données du site (slot + type)
local function KindFromData(data)
    local t = tostring(data.t or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    local slot = tostring(data.s or ""):lower()
    if t == "" then return nil end
    if ARMOR.WARRIOR[t] or t == "libram" or t == "idol" or t == "totem" then return "armor", t end
    local base = t:gsub(" weapon$", ""):gsub("s$", "")
    if base == "fist" or base == "dagger" or base == "staff" or base == "staves" or base == "polearm" or base == "bow" or base == "gun"
        or base == "crossbow" or base == "thrown" or base == "wand" then
        return "weapon", (base == "staves" and "staff" or base)
    end
    if base == "axe" or base == "mace" or base == "sword" then
        return "weapon", base .. ((slot == "two-hand") and "2" or "1")
    end
    return nil
end

local function PlayerClassToken()
    local _, token = UnitClass("player")
    return token
end

-- true si la classe du joueur peut équiper l'objet (true aussi quand on ne sait pas)
local function CanPlayerUse(id, data)
    local cls = PlayerClassToken()
    if not cls or not ARMOR[cls] then return true end
    local kind, key
    local _, _, _, equipLoc, _, classID, subClassID = API.GetItemInfoInstant(id)
    if classID == 2 and WEAPON_SUB[subClassID] then kind, key = "weapon", WEAPON_SUB[subClassID]
    elseif classID == 4 and ARMOR_SUB[subClassID] then kind, key = "armor", ARMOR_SUB[subClassID]
    elseif classID == 2 or classID == 4 then return true
    else kind, key = KindFromData(data or {}) end
    if kind == "armor" then
        -- Les capes sont en tissu mais utilisables par tous
        if key == "cloth" and (equipLoc == "INVTYPE_CLOAK" or (data and data.s == "back")) then return true end
        return ARMOR[cls][key] ~= nil
    elseif kind == "weapon" then
        return WEAPON[cls][key] ~= nil
    end
    return true
end

local SLOT_TEXT = { ["two-hand"] = "Two-Hand", ["one-hand"] = "One-Hand", ["main-hand"] = "Main Hand", ["off-hand"] = "Off Hand",
    finger = "Finger", trinket = "Trinket", back = "Back", head = "Head", neck = "Neck", shoulder = "Shoulder", chest = "Chest",
    wrist = "Wrist", hands = "Hands", waist = "Waist", legs = "Legs", feet = "Feet", ranged = "Ranged", relic = "Relic" }

-- Ligne d'objet (réutilisée)
local function ItemRow(parent)
    local r = CreateFrame("Button", nil, parent)
    r:SetHeight(ROW_H)
    r.bg = API.RowBackground(r, 1)
    r.icon = r:CreateTexture(nil, "ARTWORK")
    r.icon:SetSize(ROW_H - 4, ROW_H - 4); r.icon:SetPoint("LEFT", 4, 0)
    r.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    r.star = r:CreateTexture(nil, "OVERLAY")
    r.star:SetSize(14, 14); r.star:SetPoint("TOPLEFT", r.icon, "TOPLEFT", -4, 4)
    r.star:SetTexture("Interface\\Common\\ReputationStar"); r.star:SetTexCoord(0, 0.5, 0, 0.5)
    r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.name:SetPoint("LEFT", r.icon, "RIGHT", 6, 0); r.name:SetJustifyH("LEFT"); r.name:SetWidth(230)
    r.slot = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    r.slot:SetPoint("LEFT", r.name, "RIGHT", 6, 0); r.slot:SetJustifyH("LEFT"); r.slot:SetWidth(120)
    r.drop = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.drop:SetPoint("RIGHT", -8, 0); r.drop:SetJustifyH("RIGHT")
    r.tag = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.tag:SetPoint("RIGHT", r.drop, "LEFT", -8, 0)
    -- Surbrillance légère au survol
    r.hl = r:CreateTexture(nil, "HIGHLIGHT")
    r.hl:SetAllPoints()
    r.hl:SetColorTexture(1, 0.82, 0.45, 0.12)
    r:SetScript("OnEnter", function(self)
        if not self.itemId then return end
        local extra
        if self.source then extra = { { self.source, 0.6, 0.8, 1 } } end
        API.ShowItemTooltip(self, self.itemId, FC.LootItems[self.itemId], extra)
    end)
    r:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r:SetScript("OnClick", function(self, button)
        if self.itemId then API.ItemClick(self.itemId, FC.LootItems[self.itemId], button) end
    end)
    return r
end

-- Remplit une ligne (appelé aussi quand le client reçoit les infos de l'objet)
local function FillItemRow(r)
    local it, ctx = r.entry, r.ctx
    if not it then return end
    local name, q, icon, data = ItemInfo(it.id)
    r.itemId = it.id
    r.icon:SetTexture(icon)
    r.name:SetText(QualityHex(q) .. name .. "|r")
    local slot = SLOT_TEXT[data.s or ""] or data.s or ""
    r.slot:SetText(slot .. ((data.t and data.t ~= "") and (" · " .. data.t) or ""))
    r.drop:SetText(it.d and string.format("%.1f%%", it.d * 100) or "")
    local isBis = ctx.bis[it.id]
    r.tag:SetText(isBis and "|cffffd100BiS|r" or (it.new and "|cffff9933NEW|r" or ""))
    if isBis then r.star:Show() else r.star:Hide() end
    -- Objet que la classe ne peut pas équiper : estompé et en noir et blanc
    local usable = not ctx.dim or CanPlayerUse(it.id, data)
    r:SetAlpha(usable and 1 or 0.35)
    r.icon:SetDesaturated(not usable)
end

local function Header(parent)
    local h = CreateFrame("Frame", nil, parent)
    h:SetHeight(22)
    API.StripedBackground(h, "header")
    h.text = h:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    h.text:SetPoint("LEFT", 8, 0)
    h.sub = h:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    h.sub:SetPoint("LEFT", h.text, "RIGHT", 8, 0)
    return h
end

-- Sous-titre (boss d'un donjon dans les résultats de recherche)
local function SubHeader(parent)
    local h = CreateFrame("Frame", nil, parent)
    h:SetHeight(18)
    h.text = h:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    h.text:SetPoint("LEFT", 14, 0)
    h.sub = h:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    h.sub:SetPoint("LEFT", h.text, "RIGHT", 6, 0)
    h.line = h:CreateTexture(nil, "ARTWORK")
    h.line:SetHeight(1); h.line:SetPoint("BOTTOMLEFT", 14, 0); h.line:SetPoint("BOTTOMRIGHT", -4, 0)
    h.line:SetColorTexture(API.COLORS.border[1], API.COLORS.border[2], API.COLORS.border[3], 0.8)
    return h
end

-- Recherche dans tous les donjons : nom du donjon, du boss / de la quête, ou de l'objet
-- (nom anglais des données, et nom du client quand il est déjà en cache).
-- Textes normalisés une seule fois ; aucune requête au serveur.
-- Renvoie { {di, d, groups = { {title, sub, items} }, count} }, total
local function Search(q, bis, only)
    local out, total = {}, 0
    for di, d in ipairs(FC.Dungeons) do
        local dHit = API.Has(q, API.NormField(d, "n"))
        local groups, count = {}, 0
        local function scan(g, title, sub, list)
            local gHit = dHit or API.Has(q, API.NormField(g, "n"))
            local items = {}
            for _, it in ipairs(list or {}) do
                if (not only or bis[it.id]) and not FC:IsOtherFaction(it.id) then
                    if gHit or API.Has(q, API.NormField(FC.LootItems[it.id], "n")) or API.Has(q, API.ItemSearchName(it.id)) then
                        table.insert(items, it)
                    end
                end
            end
            if #items > 0 then table.insert(groups, { title = title, sub = sub, items = items }); count = count + #items end
        end
        for _, b in ipairs(d.b or {}) do scan(b, b.n == "Trash" and "Trash mobs" or b.n, nil, b.i) end
        for _, qq in ipairs(d.q or {}) do
            if not FC:IsOtherFaction(nil, qq.f) then scan(qq, "Quest: " .. (qq.n or ""), qq.f and ("(" .. qq.f .. ")") or nil, qq.i) end
        end
        if count > 0 then table.insert(out, { di = di, d = d, groups = groups, count = count }); total = total + count end
    end
    return out, total
end

local function DungeonForLevel()
    local lvl = UnitLevel and UnitLevel("player") or 1
    local best
    for i, d in ipairs(FC.Dungeons) do
        local lv = d.lv or {}
        if lv[1] and lv[2] and lvl >= lv[1] and lvl <= lv[2] then return i end
        if lv[1] and lv[1] <= lvl then best = i end
    end
    return best or 1
end

local function Build()
    local f = API.CreateWindow("ForeverCompanionLootFrame", UIParent, W, H)
    f:SetPoint("CENTER", 60, 0)
    f:SetFrameStrata("HIGH")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    API.CloseOnEscape(f)
    f.title = API.WindowTitle(f)

    -- Filtre BiS de la spé sélectionnée
    f.bisOnly = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
    f.bisOnly:SetSize(22, 22)
    f.bisOnly:SetPoint("TOPLEFT", LIST_W + 20, -30)
    f.bisOnly.label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.bisOnly.label:SetPoint("LEFT", f.bisOnly, "RIGHT", 2, 0)
    f.bisOnly:SetScript("OnClick", function(self) FC.db.char.loot_bis_only = self:GetChecked() and true or false; f:Update(true) end)

    -- Estomper les objets que la classe du joueur ne peut pas équiper
    f.dimUnusable = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
    f.dimUnusable:SetSize(22, 22)
    f.dimUnusable:SetPoint("TOPRIGHT", -190, -30)
    f.dimUnusable.label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.dimUnusable.label:SetPoint("LEFT", f.dimUnusable, "RIGHT", 2, 0)
    f.dimUnusable.label:SetText("Dim items my class can't use")
    f.dimUnusable:SetScript("OnClick", function(self) FC.db.char.loot_dim_unusable = self:GetChecked() and true or false; f:Update(false) end)

    -- Recherche (tous les donjons)
    f.search = API.CreateSearchBox(f, LIST_W - 22, function(t)
        f.query = API.SearchNorm(t):gsub("^%s+", ""):gsub("%s+$", "")
        f:Update(true)
    end, "Search item, boss, dungeon")
    f.search:SetPoint("TOPLEFT", 18, -32)

    -- Liste des donjons
    API.AddInset(f, 8, -58, -(W - LIST_W - 8), 8)
    f.list = API.CreateScrollFrame(f, "ForeverCompanionLootList")
    f.list:SetPoint("TOPLEFT", 12, -62); f.list:SetPoint("BOTTOMLEFT", 12, 12); f.list:SetWidth(LIST_W - 26)
    f.listChild = CreateFrame("Frame", nil, f.list); f.listChild:SetSize(LIST_W - 26, 1)
    f.list:SetScrollChild(f.listChild)
    f.listBtns = {}

    -- Contenu du donjon
    API.AddInset(f, LIST_W + 14, -58, -8, 8)
    f.sf = API.CreateScrollFrame(f, "ForeverCompanionLootScroll")
    f.sf:SetPoint("TOPLEFT", LIST_W + 18, -62); f.sf:SetPoint("BOTTOMRIGHT", -30, 12)
    f.sc = CreateFrame("Frame", nil, f.sf); f.sc:SetSize(W - LIST_W - 52, 1)
    f.sf:SetScrollChild(f.sc)
    f.list_ = API.VirtualList(f.sf, f.sc, {
        header = { h = 24, create = Header, fill = function(h, d) h.text:SetText(d.text); h.sub:SetText(d.sub or "") end },
        sub    = { h = 20, create = SubHeader, fill = function(h, d) h.text:SetText(d.text); h.sub:SetText(d.sub or "") end },
        item   = { h = ROW_H + 1, create = ItemRow, fill = function(r, d)
            r.entry, r.ctx, r.source = d.it, d.ctx, d.source
            FillItemRow(r)
        end },
        gap    = { h = 4 },
    })

    local function searching() return f.query and #f.query >= 2 end

    function f:NewListButton(i)
        local b = CreateFrame("Button", nil, self.listChild)
        b:SetSize(LIST_W - 26, 34)
        b.bg = API.RowBackground(b, i)
        b.name = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        b.name:SetPoint("TOPLEFT", 6, -4); b.name:SetWidth(LIST_W - 38); b.name:SetJustifyH("LEFT")
        b.lv = b:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        b.lv:SetPoint("BOTTOMLEFT", 6, 4)
        b.sel = b:CreateTexture(nil, "OVERLAY")
        b.sel:SetAllPoints(); b.sel:SetColorTexture(1, 0.82, 0, 0.15)
        b:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
        self.listBtns[i] = b
        return b
    end

    -- Liste de gauche : tous les donjons, ou seulement ceux trouvés par la recherche
    function f:RenderList()
        for _, b in ipairs(self.listBtns) do b:Hide() end
        if searching() then
            for n, e in ipairs(self.results or {}) do
                local b = self.listBtns[n] or self:NewListButton(n)
                b:SetPoint("TOPLEFT", 0, -(n - 1) * 35)
                b.name:SetText(e.d.n or e.d.id)
                b.lv:SetText("|cffffd100" .. e.count .. "|r match" .. (e.count > 1 and "es" or ""))
                b.sel:Hide()
                b:SetScript("OnClick", function()
                    local y = self.sectionY and self.sectionY[e.di]
                    if y then self.sf:SetVerticalScroll(math.min(y, self.sf:GetVerticalScrollRange() or y)) end
                end)
                b:Show()
            end
            self.listChild:SetHeight(#(self.results or {}) * 35 + 4)
            return
        end
        for i, d in ipairs(FC.Dungeons) do
            local b = self.listBtns[i] or self:NewListButton(i)
            b:SetPoint("TOPLEFT", 0, -(i - 1) * 35)
            b.name:SetText(d.n or d.id)
            local lv = d.lv or {}
            local where = d.raid and ("|cffff8000Raid|r" .. (d.sz and d.sz ~= "" and ("  " .. d.sz) or "")) or (lv[1] and (lv[1] .. "-" .. (lv[2] or "")) or "")
            b.lv:SetText(where .. (d.new and "  |cffff9933NEW|r" or ""))
            if i == self.selected then b.sel:Show() else b.sel:Hide() end
            b:SetScript("OnClick", function()
                self.selected = i; FC.db.char.loot_dungeon = d.id
                self:RenderList(); self:Render(true)
            end)
            b:Show()
        end
        self.listChild:SetHeight(#FC.Dungeons * 35 + 4)
    end

    -- Recalcule la recherche puis redessine ; resetScroll = revenir en haut de la liste
    function f:Update(resetScroll)
        if searching() then
            self.results, self.total = Search(self.query, BisSet(self.cn, self.sn), FC.db.char.loot_bis_only)
        else
            self.results, self.total = nil, 0
        end
        self:RenderList()
        self:Render(resetScroll)
    end

    function f:Render(resetScroll)
        local cls, spec = self.cn, self.sn
        self.bisOnly.label:SetText(spec and ("BiS only: " .. spec .. " " .. (cls or "")) or "BiS only")
        self.bisOnly:SetChecked(FC.db.char.loot_bis_only and true or false)
        local dim = FC.db.char.loot_dim_unusable ~= false   -- activé par défaut
        self.dimUnusable:SetChecked(dim)
        local ctx = { bis = BisSet(cls, spec), dim = dim }
        local only = FC.db.char.loot_bis_only
        local lines, nItems = {}, 0
        local function add(kind, data, h) table.insert(lines, { kind = kind, data = data, h = h }) end
        local function item(it, source) add("item", { it = it, ctx = ctx, source = source }); nItems = nItems + 1 end

        if searching() then
            -- Résultats : donjon > boss > objets (liste virtuelle : aucune limite nécessaire)
            self.title:SetText("Dungeon Loot — search")
            local sectionLine = {}
            for _, e in ipairs(self.results or {}) do
                local lv = e.d.lv or {}
                sectionLine[e.di] = #lines + 1
                add("header", { text = e.d.n or e.d.id, sub = lv[1] and ("(" .. lv[1] .. "-" .. (lv[2] or "") .. ")") or nil })
                for _, g in ipairs(e.groups) do
                    add("sub", { text = g.title, sub = g.sub })
                    for _, it in ipairs(g.items) do item(it, (e.d.n or "") .. " — " .. g.title) end
                    add("gap", nil, 2)
                end
                add("gap", nil, 6)
            end
            if #(self.results or {}) == 0 then add("header", { text = "No match for \"" .. self.query .. "\"." }) end
            self.list_:SetLines(lines, resetScroll)
            self.sectionY = {}
            for di, i in pairs(sectionLine) do self.sectionY[di] = lines[i].y end
        else
            local d = FC.Dungeons[self.selected or 1]
            if not d then self.list_:SetLines({}, true); return end
            self.title:SetText((d.raid and "Raid Loot — " or "Dungeon Loot — ") .. (d.n or ""))
            local listed = false   -- raid dont le site ne liste pas encore le butin : les boss restent affichés
            for _, b in ipairs(d.b or {}) do if b.i and #b.i > 0 then listed = true end end
            local function group(text, sub, list)
                local shown = {}
                for _, it in ipairs(list or {}) do if (not only or ctx.bis[it.id]) and not FC:IsOtherFaction(it.id) then table.insert(shown, it) end end
                if #shown == 0 then
                    if d.raid and not listed then add("header", { text = text, sub = "|cff9d9d9d(loot not listed yet)|r" }) end
                    return
                end
                add("header", { text = text, sub = sub })
                for _, it in ipairs(shown) do item(it, (d.n or "") .. " — " .. text) end
                add("gap", nil, 4)
            end
            for _, b in ipairs(d.b or {}) do group(b.n == "Trash" and "Trash mobs" or b.n, nil, b.i) end
            for _, q in ipairs(d.q or {}) do   -- quêtes de l'autre faction : cachées (filtre des options)
                if not FC:IsOtherFaction(nil, q.f) then group("Quest: " .. (q.n or ""), q.f and ("(" .. q.f .. ")") or nil, q.i) end
            end
            if nItems == 0 and not (d.raid and not listed) then add("header", { text = only and "No BiS item for this spec here." or "No loot data." }) end
            self.list_:SetLines(lines, resetScroll)
        end
    end

    -- Infos d'un objet reçues du serveur : on ne remet à jour que ses lignes
    -- (pas de nouveau rendu complet : la position de défilement ne bouge pas)
    API.OnItemInfo(function(id)
        if not f:IsShown() then return end
        f.list_:Refresh(function(l) return l.kind == "item" and l.data.it.id == id end)
    end)
    return f
end

function FC:OpenLootFrame(cn, sn)
    if #FC.Dungeons == 0 then
        print("|cFFFF6600" .. FC.NAME .. "|r : no dungeon loot data yet.")
        return
    end
    if not lootFrame then lootFrame = Build() end
    if not cn then cn, sn = FC:DetectPlayerSpec() end
    lootFrame.cn, lootFrame.sn = cn, sn
    -- Donjon mémorisé, sinon celui du niveau du joueur
    local sel
    for i, d in ipairs(FC.Dungeons) do if d.id == FC.db.char.loot_dungeon then sel = i end end
    lootFrame.selected = sel or DungeonForLevel()
    lootFrame:Update(true)
    lootFrame:Show()
    lootFrame:Raise()
end
