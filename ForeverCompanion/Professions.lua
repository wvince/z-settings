-- Forever Companion — Professions.lua
-- Recettes des métiers, groupées par palier de compétence, avec composants et source.
-- Données : Data/Professions.lua (ForeverCompanionData.professions / craftItems), générées par le Studio.
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local W, H = 780, 600
local NAME_X, NAME_W = 138, 250     -- colonne « Recipe »
local REAG_X = 400                  -- colonne « Reagents »
local ROW_H = 34
local profFrame

local BRACKETS = {
    -- 0 = compétence requise inconnue (recettes relevées en jeu)
    { 0, 74, "Apprentice (1-75)" }, { 75, 149, "Journeyman (75-150)" }, { 150, 224, "Expert (150-225)" },
    { 225, 299, "Artisan (225-300)" }, { 300, 9999, "300+" },
}
-- Couleurs des paliers : orange (apprise à), jaune, vert, gris
local SKILL_HEX = { "|cffff8040", "|cffffff00", "|cff40bf40", "|cff9d9d9d" }

local function ItemInfo(id)
    local data = FC.CraftItems[id] or FC.LootItems[id] or {}
    local name, _, quality = API.GetItemInfo(id)
    local icon = API.GetItemIcon(id)
    if not icon and data.ic then icon = API.IconPath(data.ic) end
    return name or data.n or ("Item " .. id), quality or data.r or 1, icon or "Interface\\Icons\\INV_Misc_QuestionMark"
end

-- Icône seule : lue dans les fichiers du client, sans requête au serveur
local function IconOnly(id)
    local icon = API.GetItemIcon(id)
    if not icon then local data = FC.CraftItems[id] or FC.LootItems[id]; if data and data.ic then icon = API.IconPath(data.ic) end end
    return icon or "Interface\\Icons\\INV_Misc_QuestionMark"
end

-- ── Coût et bénéfice d'une recette ────────────────────────────────────────
-- Prix d'achat d'un composant : marchand (relevé), sinon HV (relevé), sinon prix indicatif du site ;
-- renvoie prix, estimé ?
local function BuyPrice(id)
    if FC.GetBuyPrice then
        local p, src = FC:GetBuyPrice(id)
        if p then return p, src ~= "ah" and src ~= "vendor" end
    end
    local d = FC.CraftItems and FC.CraftItems[id]
    if d and d.p then return d.p, true end
end
-- Coût des composants, valeur à l'HV de ce qui est fabriqué, bénéfice après la taxe de 5 % de l'HV,
-- nombre de composants sans prix
local function Economics(r)
    if not r or r.zn or not r.rg then return nil end
    local cost, missing = 0, 0
    for _, rg in ipairs(r.rg) do
        local p = (rg[1] or 0) > 0 and BuyPrice(rg[1])
        if p then cost = cost + p * (rg[2] or 1) else missing = missing + 1 end
    end
    local value
    if r.it and r.it.id and FC.GetItemPrice then
        local p = FC:GetItemPrice(r.it.id)
        if p then value = p * (r.it.c or 1) end
    end
    return cost, value, value and (math.floor(value * 0.95 + 0.5) - cost) or nil, missing
end
local profitMode   -- colonne « Profit » au lieu de « Source » (clic sur l'en-tête de la colonne)
local function ProfitText(r)
    local _, _, profit, missing = Economics(r)
    if not profit then return "|cff808080-|r" end
    return (profit >= 0 and ("|cff40bf40+" .. API.Money(profit, true)) or ("|cffff5050" .. API.Money(profit, true))) .. "|r"
        .. ((missing or 0) > 0 and "|cff808080 ?|r" or "")
end
local function AddEconomicsLines(tt, r)
    local cost, value, profit, missing = Economics(r)
    if not cost or (cost == 0 and not value) then return false end
    tt:AddLine(" ")
    tt:AddDoubleLine("Reagents", API.Money(cost) .. ((missing or 0) > 0 and ("  |cff808080(" .. missing .. " without price)|r") or ""), 0.8, 0.8, 0.8, 1, 1, 1)
    if value then
        tt:AddDoubleLine("Sells at the Auction House", API.Money(value), 0.8, 0.8, 0.8, 1, 1, 1)
        local c = profit >= 0 and { 0.25, 0.75, 0.25 } or { 1, 0.31, 0.31 }
        tt:AddDoubleLine("Profit (after the 5% cut)", API.Money(profit), 0.8, 0.8, 0.8, c[1], c[2], c[3])
    else
        tt:AddLine("No Auction House price for what it makes yet.", 0.6, 0.6, 0.6)
    end
    return true
end

local function QualityHex(q)
    local r, g, b = API.GetItemQualityColor(q or 1)
    return string.format("|cff%02x%02x%02x", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255)
end

local function ShowItemTooltip(owner, id)
    API.ShowItemTooltip(owner, id, FC.CraftItems[id] or FC.LootItems[id])
end

-- Où apprendre une recette (données Wowhead du Studio) : r.so = { {k=type, n=PNJ ou quête, z=zone, c=coût} }
local SOURCE_TEXT = { trainer = "Trainer", vendor = "Vendor", drop = "Drop", world = "World drop", quest = "Quest",
    discovery = "Discovery", crafted = "Crafted", fishing = "Fishing", starter = "Known", pvp = "PvP", achievement = "Achievement", other = "Other" }
local function AddSourceLines(tt, so, noHeader)
    if not so or #so == 0 then return end
    if not noHeader then tt:AddLine(" "); tt:AddLine("How to learn", 1, 0.82, 0) end
    for _, s in ipairs(so) do
        local detail = s.n or ""
        if s.z and s.z ~= "" then detail = detail ~= "" and (detail .. " |cff9d9d9d(" .. s.z .. ")|r") or ("|cff9d9d9d" .. s.z .. "|r") end
        if s.c and s.c > 0 then detail = (detail ~= "" and (detail .. "  ") or "") .. API.Money(s.c, true) end
        tt:AddDoubleLine(SOURCE_TEXT[s.k] or s.k or "?", detail, 1, 0.82, 0, 1, 1, 1)
    end
end

-- Petite icône d'objet avec quantité (composant ou recette)
local function MiniIcon(parent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(22, 22)
    b.tex = b:CreateTexture(nil, "ARTWORK"); b.tex:SetAllPoints(); b.tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    b.count = b:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    b.count:SetPoint("BOTTOMRIGHT", 2, -1)
    b:SetScript("OnEnter", function(self) if self.itemId then ShowItemTooltip(self, self.itemId) end end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:SetScript("OnClick", function(self, button)
        if self.itemId then API.ItemClick(self.itemId, FC.CraftItems[self.itemId] or FC.LootItems[self.itemId], button) end
    end)
    return b
end

local function RecipeRow(parent)
    local r = CreateFrame("Frame", nil, parent)
    r:SetHeight(ROW_H)
    r.bgL, r.bgR = API.RowBackground(r, 1)
    r.skill = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    r.skill:SetPoint("LEFT", 6, 0); r.skill:SetWidth(96); r.skill:SetJustifyH("LEFT")
    r.out = CreateFrame("Button", nil, r)
    r.out:SetSize(ROW_H - 6, ROW_H - 6); r.out:SetPoint("LEFT", 104, 0)
    r.out.tex = r.out:CreateTexture(nil, "ARTWORK"); r.out.tex:SetAllPoints(); r.out.tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    r.out.count = r.out:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall"); r.out.count:SetPoint("BOTTOMRIGHT", 2, -1)
    r.out:SetScript("OnEnter", function(self)
        if self.itemId then ShowItemTooltip(self, self.itemId)
        elseif self.spellId and GameTooltip.SetSpellByID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetSpellByID(self.spellId)
        else return end
        local rc = r.recipe
        if rc and rc.tl and #rc.tl > 0 then GameTooltip:AddLine("Tools: " .. table.concat(rc.tl, ", "), 0.6, 0.8, 1, true) end
        GameTooltip:Show()
    end)
    r.out:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r.out:SetScript("OnClick", function(self, button)
        if self.itemId then API.ItemClick(self.itemId, FC.CraftItems[self.itemId] or FC.LootItems[self.itemId], button)
        elseif self.spellId and IsModifiedClick and IsModifiedClick("CHATLINK") and ChatEdit_InsertLink then
            local link = API.GetSpellLink(self.spellId); if link then ChatEdit_InsertLink(link) end
        end
    end)
    -- Nom et catégorie : une ligne chacun, tronqués (« … ») s'ils sont trop longs
    local function oneLine(fs)
        fs:SetWidth(NAME_W); fs:SetJustifyH("LEFT")
        if fs.SetWordWrap then fs:SetWordWrap(false) end
        if fs.SetNonSpaceWrap then fs:SetNonSpaceWrap(false) end
        if fs.SetMaxLines then fs:SetMaxLines(1) end
    end
    r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.name:SetPoint("TOPLEFT", r.out, "TOPRIGHT", 6, -3); oneLine(r.name)
    r.cat = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    r.cat:SetPoint("BOTTOMLEFT", r.out, "BOTTOMRIGHT", 6, 3); oneLine(r.cat)
    r.reag = {}
    -- Source : texte (survol : détail) et, pour un objet-recette, son icône (survol : objet + détail)
    r.srcBtn = CreateFrame("Button", nil, r)
    r.srcBtn:SetSize(96, ROW_H - 8); r.srcBtn:SetPoint("RIGHT", -8, 0)
    r.src = r.srcBtn:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    r.src:SetPoint("RIGHT", 0, 0); r.src:SetJustifyH("RIGHT")
    r.srcBtn:SetScript("OnEnter", function(self)
        local rc = r.recipe
        if not rc then return end
        local hasSo = rc.so and #rc.so > 0
        if not hasSo and (r.gath or not Economics(rc)) then return end
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine(rc.n or "", 1, 1, 1)
        if hasSo then AddSourceLines(GameTooltip, rc.so, true) end
        if not r.gath then AddEconomicsLines(GameTooltip, rc) end
        GameTooltip:Show()
    end)
    r.srcBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r.srcIcon = MiniIcon(r)
    r.srcIcon:SetPoint("RIGHT", -8, 0)
    r.srcIcon:SetScript("OnEnter", function(self)
        if not self.itemId then return end
        ShowItemTooltip(self, self.itemId)
        if r.recipe and r.recipe.so then AddSourceLines(GameTooltip, r.recipe.so); GameTooltip:Show() end
    end)
    return r
end

-- En-tête de groupe. Avec une clé (palier, métier dans la recherche), un clic
-- replie / déplie les lignes du groupe (état gardé pendant la session).
local collapsed = {}
local function Header(parent)
    local h = CreateFrame("Button", nil, parent)
    h:SetHeight(22)
    API.StripedBackground(h, "header")
    h.toggle = h:CreateTexture(nil, "OVERLAY")
    h.toggle:SetSize(14, 14); h.toggle:SetPoint("LEFT", 6, 0)
    h.text = h:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    h.text:SetPoint("LEFT", 8, 0)
    h.sub = h:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    h.sub:SetPoint("LEFT", h.text, "RIGHT", 8, 0)
    h.hl = h:CreateTexture(nil, "HIGHLIGHT"); h.hl:SetAllPoints(); h.hl:SetColorTexture(1, 1, 1, 0.05)
    h:SetScript("OnClick", function(self)
        if not self.key then return end
        collapsed[self.key] = not collapsed[self.key] or nil
        if profFrame then profFrame:Render(false) end
    end)
    return h
end
local function FillHeader(h, d)
    h.key = d.key
    h.text:ClearAllPoints()
    if d.key then
        h.toggle:SetTexture(collapsed[d.key] and "Interface\\Buttons\\UI-PlusButton-Up" or "Interface\\Buttons\\UI-MinusButton-Up")
        h.toggle:Show(); h.hl:Show()
        h.text:SetPoint("LEFT", 24, 0)
    else
        h.toggle:Hide(); h.hl:Hide()
        h.text:SetPoint("LEFT", 8, 0)
    end
    h.text:SetText(d.text); h.sub:SetText(d.sub or "")
end

-- Niveau d'une recette pour le tri et les paliers : compétence requise, sinon (inconnue)
-- le premier palier connu
local function Level(r)
    if r.l and r.l > 0 then return r.l end
    if r.zn and r.av and r.av > 0 and r.av <= 525 then return math.max(1, r.av - 95) end   -- pêche : d'après la compétence sans échappée
    return (r.s and r.s[1]) or 0
end

-- Métiers connus du joueur (pour choisir le premier à afficher)
-- Métiers du joueur : [nom] = rang et [ligne de compétence] = rang (le nom est traduit
-- dans un client français, la ligne de compétence non : 171 = Alchimie, 186 = Minage…)
local function PlayerProfessionNames()
    local names = {}
    if GetProfessions and GetProfessionInfo then
        local res = { pcall(GetProfessions) }
        if res[1] then
            for i = 2, 6 do   -- métier 1, métier 2, archéologie, pêche, cuisine (des trous possibles)
                local idx = res[i]
                if idx then
                    local ok2, name, _, rank, _, _, _, skillLine = pcall(GetProfessionInfo, idx)
                    if ok2 and name then
                        names[name] = rank or 0
                        if skillLine then names[skillLine] = rank or 0 end
                    end
                end
            end
        end
    end
    return names
end
local function KnownRank(known, p) return known[p.sl or -1] or known[p.n] end

-- Ligne « zone » (dépeçage, pêche) : nom de la zone dans la langue du client (d'après son ID)
local function ZoneName(r)
    local z = r.zi and r.zi[1]
    local n = z and C_Map and C_Map.GetAreaInfo and C_Map.GetAreaInfo(z)
    return (n and n ~= "") and n or r.n
end
-- Compétence de dépeçage requise pour une créature de ce niveau (règle de Classic)
-- Niveau d'une bête : boss « ?? » (9999 sur Wowhead) = niveau maximum + 3
local function BeastLevel(lv) return (lv and lv >= 100) and 63 or lv end
local function SkinSkill(lv) lv = BeastLevel(lv); return lv <= 10 and 1 or (lv <= 20 and (lv - 10) * 10 or lv * 5) end
-- Pêche : compétence sans « le poisson s'est échappé » (valeur aberrante ignorée) ; compétence de
-- la zone, sinon déduite (règle de Classic : plus d'échappée à compétence de la zone + 95)
local function FishAvoid(r) return (r.av and r.av > 0 and r.av <= 525) and r.av or nil end
local function FishSkill(r)
    if (r.l or 0) > 0 then return r.l end
    local av = FishAvoid(r)
    return av and math.max(1, av - 95) or nil
end
local function ZoneDetail(r)
    if r.lv then
        local a, b = BeastLevel(r.lv[1]), BeastLevel(r.lv[2] or r.lv[1])
        return "Beasts level " .. (a == b and a or (a .. "-" .. b))
    end
    local av = FishAvoid(r)
    return av and ("No escapes at " .. av) or ""
end
-- Colonne « compétence » d'une ligne « zone », colorée selon ta compétence (rank) :
-- dépeçage : rouge = trop bas, vert = des bêtes te font encore progresser, gris = plus rien à gagner ;
-- pêche : rouge = trop bas, jaune = des poissons s'échappent encore, vert = plus d'échappée
local RED, YELLOW, GREEN, GRAY, ORANGE = "|cffff5050", "|cffffff00", "|cff40bf40", "|cff9d9d9d", "|cffff8040"
local zoneRowRank   -- compétence du joueur dans le métier affiché (nil : inconnue ou recherche)
local function ZoneSkillText(r)
    local rank = zoneRowRank
    if r.lv then
        local a, b = SkinSkill(r.lv[1]), SkinSkill(r.lv[2] or r.lv[1])
        local c = not rank and ORANGE or (rank < a and RED or (rank >= b + 100 and GRAY or GREEN))
        return c .. (a == b and a or (a .. "-" .. b)) .. "|r"
    end
    local sk, av = FishSkill(r), FishAvoid(r)
    if not sk then return GRAY .. "-|r" end
    local c = not rank and ORANGE or (rank < sk and RED or ((av and rank < av) and YELLOW or GREEN))
    return c .. sk .. "|r"
end

-- Remplit une ligne de recette (utilisée par la liste et par la recherche)
-- gath = métier de récolte : nom de l'entrée (filon, herbe…), objets obtenus, zones
local function FillRow(row, r, catName, gath)
    row.recipe, row.catName, row.gath = r, catName, gath
    local lv = r.l or 0
    if r.zn then
        row.skill:SetText(ZoneSkillText(r))
    else
        -- Paliers : apprise à (orange, « ? » si inconnue), puis jaune, vert, gris
        local parts = { SKILL_HEX[1] .. (lv > 0 and lv or "?") .. "|r" }
        for i, v in ipairs(r.s or {}) do table.insert(parts, (SKILL_HEX[i + 1] or SKILL_HEX[4]) .. v .. "|r") end
        row.skill:SetText(table.concat(parts, " "))
    end
    -- Objet produit
    local outId = r.it and r.it.id
    local name, q, icon
    if outId then name, q, icon = ItemInfo(outId)
    else name, q, icon = r.n, 1, ((r.ic and API.IconPath(r.ic)) or API.GetSpellIcon(r.id) or "Interface\\Icons\\INV_Misc_QuestionMark") end
    if gath then name = r.zn and ZoneName(r) or r.n or name end
    if r.zn then q = 1 end
    row.out.itemId, row.out.spellId = outId, r.id
    row.out.tex:SetTexture(icon)
    row.out.count:SetText((r.it and r.it.c and r.it.c > 1) and r.it.c or "")
    row.name:SetText(QualityHex(q) .. (name or r.n or "?") .. "|r" .. (r.new and "  |cffff9933NEW|r" or "")
        .. (r.scanned and "  |cff66bbffscanned|r" or ""))
    if gath and r.zn then
        local d = ZoneDetail(r)
        row.cat:SetText(d ~= "" and ("|cffb0c4de" .. d .. "|r") or catName)
    elseif gath then
        row.cat:SetText(r.z and r.z ~= "" and ("|cffb0c4de" .. r.z .. "|r") or catName)
    else
        row.cat:SetText(catName .. ((r.tl and #r.tl > 0) and ("  ·  |cff8fb3ffTools|r") or ""))
    end
    -- Composants
    for _, b in ipairs(row.reag) do b:Hide() end
    for i, rg in ipairs(r.rg or {}) do
        local b = row.reag[i] or MiniIcon(row); row.reag[i] = b
        local rid = rg[1] or 0
        local ricon = rid > 0 and IconOnly(rid) or "Interface\\Icons\\INV_Misc_QuestionMark"
        b.itemId = rid > 0 and rid or nil; b.tex:SetTexture(ricon); b.count:SetText((rg[2] or 1) > 1 and rg[2] or "")
        b:ClearAllPoints(); b:SetPoint("LEFT", REAG_X + (i - 1) * 26, 0)
        b:Show()
    end
    -- Source : où l'apprendre (maître, marchand, butin…), et l'objet recette (icône + info-bulle)
    local so, label = r.so, ""
    if so and so[1] then
        label = SOURCE_TEXT[so[1].k] or ""
        if #so > 1 then label = label .. " |cff9d9d9d+" .. (#so - 1) .. "|r" end
    elseif r.src == "t" then label = "Trainer"
    elseif r.src == "r" and not r.tb then label = "Recipe" end
    local profit = profitMode and not gath
    if profit then label = ProfitText(r) end
    row.srcBtn:ClearAllPoints()
    -- Objet recette (plan, patron…) : seulement en mode Source ; en mode Profit, la colonne ne montre que
    -- le bénéfice (les sources restent dans l'info-bulle du bénéfice)
    if r.tb and not profit then
        local ticon = IconOnly(r.tb)
        row.srcIcon.itemId = r.tb; row.srcIcon.tex:SetTexture(ticon); row.srcIcon.count:SetText("")
        row.srcIcon:Show()
        row.srcBtn:SetPoint("RIGHT", row.srcIcon, "LEFT", -4, 0)
    else
        row.srcIcon:Hide()
        row.srcBtn:SetPoint("RIGHT", row, "RIGHT", -8, 0)
    end
    row.src:SetText(label)
end

FC.ProfessionRows = { Create = RecipeRow, Fill = FillRow, SetRank = function(v) zoneRowRank = v end }   -- tests

-- ── Guide de leveling ─────────────────────────────────────────────────────
-- Étape p.gd[i] : {f=de, t=à, n=nom, c=nombre, st=arrêt, r=sort, it=objet, m={{id,nb[,nom]}}, src=source}
local STEP_HEX = { done = "|cff7f7f7f", cur = "|cffffd100", todo = "|cffffffff" }

-- Prix d'un objet à acheter : marchand, HV (scan) sinon prix indicatif du site ; renvoie prix, estimé?
local function Price(id) return BuyPrice(id) end

-- Nombre de fabrications restantes d'une étape selon la compétence actuelle
local function Remaining(st, rank)
    local c = st.c or 0
    if not rank or rank < (st.f or 0) then return c, "todo" end
    if rank >= (st.t or 0) then return 0, "done" end
    local span = math.max(1, (st.t or 0) - (st.f or 0))
    return math.ceil(c * ((st.t or 0) - rank) / span), "cur"
end
local function Scale(n, st, left)
    if (st.c or 0) <= 0 then return left > 0 and n or 0 end
    return math.ceil(n * left / st.c)
end

local function StepRow(parent)
    local r = RecipeRow(parent)
    r.cur = r:CreateTexture(nil, "BORDER")
    r.cur:SetAllPoints(); r.cur:SetColorTexture(1, 0.82, 0, 0.10)
    r.arrow = r:CreateTexture(nil, "OVERLAY")
    r.arrow:SetSize(14, 14); r.arrow:SetPoint("LEFT", 0, 0)
    r.arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
    r.skill:ClearAllPoints(); r.skill:SetPoint("LEFT", 14, 0); r.skill:SetWidth(88)
    r.srcIcon:Hide()
    return r
end

local function FillStep(row, d)
    local st, state, left = d.st, d.state, d.left
    row.recipe = nil
    local hex = STEP_HEX[state]
    row.skill:SetText(hex .. (st.f or 0) .. " - " .. (st.t or 0) .. "|r")
    row.cur:SetShown(state == "cur"); row.arrow:SetShown(state == "cur")
    -- Objet produit (sinon icône du sort de la recette)
    local outId = st.it
    local name, q, icon
    if outId then name, q, icon = ItemInfo(outId)
    else name, q, icon = st.n, 1, (st.r and API.GetSpellIcon(st.r)) or "Interface\\Icons\\INV_Misc_QuestionMark" end
    row.out.itemId, row.out.spellId = outId, st.r
    row.out.tex:SetTexture(icon); row.out.tex:SetDesaturated(state == "done")
    row.out.count:SetText("")
    local txt = (state == "done" and "|cff7f7f7f" or QualityHex(q)) .. (st.n or name or "?") .. "|r"
    if (st.c or 0) > 0 then txt = txt .. "  |cffffffff×" .. st.c .. "|r" end
    row.name:SetText(txt)
    local sub = {}
    if state == "cur" and left > 0 and left < (st.c or 0) then table.insert(sub, "|cffffd100" .. left .. " left|r") end
    if st.st then table.insert(sub, "Stop at " .. st.st) end
    if st.src and st.src ~= "" then table.insert(sub, st.src) end
    row.cat:SetText(table.concat(sub, "  ·  "))
    -- Composants de l'étape (quantités de l'étape entière)
    for _, b in ipairs(row.reag) do b:Hide() end
    local cost, est = 0, false
    for i, m in ipairs(st.m or {}) do
        local b = row.reag[i] or MiniIcon(row); row.reag[i] = b
        local id = m[1] or 0
        b.itemId = id > 0 and id or nil
        b.tex:SetTexture(id > 0 and IconOnly(id) or "Interface\\Icons\\INV_Misc_QuestionMark")
        b.tex:SetDesaturated(state == "done")
        b.count:SetText(m[2] or "")
        b:ClearAllPoints(); b:SetPoint("LEFT", REAG_X + (i - 1) * 26, 0)
        b:Show()
        local p, e = Price(id)
        if p then cost = cost + p * Scale(m[2] or 1, st, left); est = est or e end
    end
    row.src:SetText(left > 0 and cost > 0 and ((est and "|cff9d9d9d~|r" or "") .. API.Money(cost, true)) or "")
end

-- Liste de courses : composants des étapes restantes, moins ce qui est dans les sacs et la banque
local function ShopRow(parent)
    local r = CreateFrame("Button", nil, parent)
    r:SetHeight(24)
    r.bgL, r.bgR = API.RowBackground(r, 1)
    r.icon = MiniIcon(r); r.icon:SetSize(18, 18); r.icon:SetPoint("LEFT", 14, 0)
    r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.name:SetPoint("LEFT", 40, 0); r.name:SetWidth(250); r.name:SetJustifyH("LEFT"); r.name:SetWordWrap(false)
    local function num(x, w)
        local fs = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("RIGHT", r, "LEFT", x, 0); fs:SetWidth(w or 60); fs:SetJustifyH("RIGHT")
        return fs
    end
    r.need, r.have, r.buy = num(360), num(430), num(500)
    r.unit = num(620, 110)
    r.total = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.total:SetPoint("RIGHT", -8, 0); r.total:SetJustifyH("RIGHT")
    return r
end
local function FillShop(r, d)
    local id = d.id
    r.icon.itemId = id > 0 and id or nil
    r.icon.tex:SetTexture(id > 0 and IconOnly(id) or "Interface\\Icons\\INV_Misc_QuestionMark")
    r.icon.count:SetText("")
    local name, q = d.name, 1
    if id > 0 then name, q = ItemInfo(id) end
    r.name:SetText(QualityHex(q) .. (name or "?") .. "|r")
    r.need:SetText(d.need)
    r.have:SetText(d.have > 0 and ("|cff40bf40" .. d.have .. "|r") or "|cff7f7f7f0|r")
    r.buy:SetText(d.buy > 0 and ("|cffffd100" .. d.buy .. "|r") or "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t")
    if d.price then
        r.unit:SetText((d.est and "|cff9d9d9d~|r" or "") .. API.Money(d.price, true))
        r.total:SetText(d.buy > 0 and ((d.est and "|cff9d9d9d~|r" or "") .. API.Money(d.price * d.buy, true)) or "")
    else
        r.unit:SetText("|cff7f7f7f?|r"); r.total:SetText("")
    end
end
local function ShopHeader(parent)
    local h = Header(parent)
    h.hl:Hide()
    local function lab(x, text, w)
        local fs = h:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("RIGHT", h, "LEFT", x, 0); fs:SetWidth(w or 60); fs:SetJustifyH("RIGHT"); fs:SetText(text)
    end
    lab(360, "Need"); lab(430, "Have"); lab(500, "To buy"); lab(620, "Unit price", 110)
    h.right = h:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    h.right:SetPoint("RIGHT", -8, 0); h.right:SetText("Total")
    return h
end

local function GuideLines(p, rank, add)
    local steps = p.gd or {}
    local curIdx
    local need, order = {}, {}
    for i, st in ipairs(steps) do
        local left, state = Remaining(st, rank)
        if state == "cur" or (not curIdx and state == "todo" and rank) then curIdx = curIdx or i end
        -- première étape à faire = étape en cours quand la compétence tombe entre deux étapes
        if state == "todo" and rank and i == curIdx then state = "cur" end
        add("step", { st = st, state = state, left = left })
        for _, m in ipairs(st.m or {}) do
            local id = m[1] or 0
            local key = id > 0 and id or ("n:" .. tostring(m[3]))
            local n = Scale(m[2] or 1, st, left)
            if n > 0 then
                if not need[key] then need[key] = { id = id, name = m[3], need = 0 }; table.insert(order, key) end
                need[key].need = need[key].need + n
            end
        end
    end
    return curIdx, need, order
end

-- Catégories d'un métier : celles des données, plus les recettes relevées en jeu
-- (/fc recipes scan) qui n'y sont pas encore
-- Métier de récolte : les points (plantes, filons…) et les recettes (fonte, campement…) sont
-- affichés séparément. Libellés selon le métier (ligne de compétence).
-- Dépeçage et pêche : une ligne par zone
local NODE_LABEL = { [182] = { "Plants", "Plant", "plant" }, [186] = { "Veins", "Vein", "vein" }, [393] = { "Beasts", "Zone", "zone" }, [356] = { "Spots", "Zone", "zone" } }
local function NodeLabel(p) return NODE_LABEL[p and p.sl or 0] or { "Nodes", "Name", "entry" } end
-- Vue effective : « guide », « nodes » (points de récolte) ou « recipes »
local function ViewOf(f, p)
    if f.mode == "guide" then return "guide" end
    if p and p.g then return f.gatherView or "nodes" end
    return "recipes"
end
local function InView(p, r, view)
    if not (p and p.g) then return true end
    if view == "nodes" then return not r.rc end
    return r.rc and true or false
end

local function Categories(p)
    local extra = FC.RecipeScan and FC.RecipeScan.Extra(p) or {}
    if #extra == 0 then return p.c or {} end
    local cats = {}
    for _, c in ipairs(p.c or {}) do cats[#cats + 1] = c end
    cats[#cats + 1] = { n = FC.RecipeScan.EXTRA_CATEGORY, r = extra }
    return cats
end

local function Build()
    local f = API.CreateWindow("ForeverCompanionProfessionsFrame", UIParent, W, H)
    f:SetPoint("CENTER", 80, 0)
    f:SetFrameStrata("HIGH")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    API.CloseOnEscape(f)
    f.title = API.WindowTitle(f)

    -- Onglets des métiers à droite de la fenêtre (ordre et visibilité : options)
    -- f.tabs[i] : onglet du métier n° i des données (créé à la demande, réutilisé)
    f.tabs = {}
    function f:LayoutTabs()
        for _, tab in pairs(self.tabs) do tab:Hide() end
        local order = FC:GetProfessionOrder()
        local y = -30
        for _, i in ipairs(order) do
            local p = FC.Professions[i]
            local tab = self.tabs[i]
            if not tab then
                tab = API.CreateSideTab(self)
                tab:SetIcon(p.ic)
                tab.tooltip = p.n or p.id
                tab:SetScript("OnClick", function()
                    self.prof = i; self.cat = nil; FC.db.char.prof_last = p.id
                    if self.query and self.query ~= "" then self.search:SetText(""); self.query = "" end
                    self:Render(true)
                end)
                self.tabs[i] = tab
            end
            tab:ClearAllPoints()
            tab:SetPoint("TOPLEFT", self, "TOPRIGHT", tab.style == "forever" and -2 or 1, y)
            tab:Show()
            y = y - (tab.style == "forever" and 60 or 46)
        end
        -- Hauteur : assez pour tous les onglets visibles
        self:SetHeight(math.max(H, 40 + #order * 60))
        -- Métier affiché masqué : on passe au premier visible
        local visible = false
        for _, i in ipairs(order) do if i == self.prof then visible = true end end
        if not visible then self.prof = order[1] end
    end

    -- Catégorie
    f.catDD = API.CreateDropdown(f, 170, function()
        local items = { { text = "All categories", isSelected = function() return f.cat == nil end, func = function() f.cat = nil; f:Render() end } }
        local p = FC.Professions[f.prof or 1]
        local view = ViewOf(f, p)
        for _, c in ipairs(p and Categories(p) or {}) do
            local any = false
            for _, r in ipairs(c.r or {}) do if InView(p, r, view) then any = true; break end end
            if any then table.insert(items, { text = c.n, isSelected = function() return f.cat == c.n end, func = function() f.cat = c.n; f:Render() end }) end
        end
        return items
    end)
    f.catDD.frame:SetPoint("TOPLEFT", 14 + (f.catDD.xInset or 0), -34)
    f.search = API.CreateSearchBox(f, 200, function(t)
        f.query = API.SearchNorm(t):gsub("^%s+", ""):gsub("%s+$", "")
        f:Render()
    end, "Search all professions")
    f.search:SetPoint("TOPLEFT", 206, -38)
    -- Compétence du joueur : dans la barre de titre, à gauche du bouton de fermeture
    -- (sous la barre, les boutons Plants / Recipes / Leveling guide prennent toute la place).
    -- Créée sur le bouton de fermeture : la bordure de la fenêtre est dessinée au-dessus
    -- des textes de la fenêtre elle-même, pas au-dessus de ce bouton.
    local close = type(f.CloseButton) == "table" and f.CloseButton or nil
    f.skillText = (close or f):CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.skillText:SetJustifyH("RIGHT")
    if close then f.skillText:SetPoint("RIGHT", close, "LEFT", -4, 0)
    else f.skillText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -32, -6) end
    -- Recettes / Guide de leveling
    f.mode = FC.db.char.prof_mode == "guide" and "guide" or "recipes"
    f.modeBtns = {}
    -- « Plantes / Filons » (métiers de récolte seulement), « Recipes », « Leveling guide »
    for _, m in ipairs({ { "nodes", "Plants" }, { "recipes", "Recipes" }, { "guide", "Leveling guide" } }) do
        local b = API.CreateMenuButton(f, m[1] == "guide" and 124 or 84, 22, m[2])
        b:SetScript("OnClick", function()
            if m[1] == "guide" then f.mode = "guide" else f.mode = "recipes"; f.gatherView = m[1] end
            FC.db.char.prof_mode = f.mode
            if f.query and f.query ~= "" then f.search:SetText(""); f.query = "" end
            f.cat = nil
            f:Render(true)
        end)
        f.modeBtns[m[1]] = b
    end
    -- Place des boutons : trois pour un métier de récolte, deux sinon
    function f:LayoutModes(p)
        local g = p and p.g
        local b = self.modeBtns
        b.nodes:ClearAllPoints(); b.recipes:ClearAllPoints(); b.guide:ClearAllPoints()
        if g then
            b.nodes:SetText(NodeLabel(p)[1]); b.nodes:Show()
            b.nodes:SetPoint("TOPLEFT", 418, -37); b.recipes:SetPoint("TOPLEFT", 506, -37); b.guide:SetPoint("TOPLEFT", 594, -37)
        else
            b.nodes:Hide()
            b.recipes:SetPoint("TOPLEFT", 418, -37); b.guide:SetPoint("TOPLEFT", 510, -37)
        end
    end

    -- En-tête des colonnes + liste
    f.hdr = CreateFrame("Frame", nil, f)
    f.hdr:SetPoint("TOPLEFT", 12, -66); f.hdr:SetPoint("TOPRIGHT", -12, -66); f.hdr:SetHeight(18)
    API.AddInset(f, -3, 3, -8, 8, f.hdr)
    API.StripedBackground(f.hdr, "header")
    local function col(text, x) local fs = f.hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); fs:SetPoint("LEFT", x, 0); fs:SetText(text); return fs end
    f.colSkill, f.colName, f.colReag, f.colSrc = col("Skill", 6), col("Recipe", 104), col("Reagents", REAG_X), col("Source", W - 110)
    -- Clic sur « Source » : bénéfice de chaque recette à l'HV (et retour)
    f.srcHdr = CreateFrame("Button", nil, f.hdr)
    f.srcHdr:SetSize(100, 18); f.srcHdr:SetPoint("LEFT", f.colSrc, "LEFT", -4, 0)
    f.srcHdr:SetScript("OnClick", function() FC.db.char.prof_profit = not FC.db.char.prof_profit; f:Render() end)
    f.srcHdr:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine(FC.db.char.prof_profit and "Show where to learn each recipe" or "Show the profit of each recipe", 1, 0.82, 0)
        GameTooltip:AddLine("Profit: Auction House price of what it makes, minus the 5% cut, minus the reagents at the cheapest known price (vendor or Auction House). Sorted from the most profitable.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    f.srcHdr:SetScript("OnLeave", function() GameTooltip:Hide() end)
    f.sf = API.CreateScrollFrame(f, "ForeverCompanionProfScroll")
    f.sf:SetPoint("TOPLEFT", f.hdr, "BOTTOMLEFT", 0, -2); f.sf:SetPoint("BOTTOMRIGHT", -30, 12)
    f.sc = CreateFrame("Frame", nil, f.sf); f.sc:SetSize(W - 54, 1)
    f.sf:SetScrollChild(f.sc)
    f.list_ = API.VirtualList(f.sf, f.sc, {
        header = { h = 24, create = Header, fill = FillHeader },
        recipe = { h = ROW_H + 1, create = RecipeRow, fill = function(row, d) FillRow(row, d.r, d.cat, d.gath) end },
        step   = { h = ROW_H + 1, create = StepRow, fill = FillStep },
        shophdr = { h = 24, create = ShopHeader, fill = function(h, d) h.text:SetText(d.text); h.sub:SetText(d.sub or "") end },
        shop   = { h = 25, create = ShopRow, fill = FillShop },
        gap    = { h = 6 },
    })

    local function byLevel(a, b)
        local x, y = Level(a.r), Level(b.r)
        return x < y or (x == y and (a.r.n or "") < (b.r.n or ""))
    end

    function f:Render(resetScroll)
        local p = FC.Professions[self.prof or 1]
        if not p then return end
        local searchingNow = self.query and #self.query >= 2
        local view = ViewOf(self, p)
        local guide = view == "guide" and not searchingNow
        local nodes = view == "nodes" and not searchingNow
        local NL = NodeLabel(p)
        self:LayoutModes(p)
        -- Points de récolte : ce qu'on ramasse (« Loot ») ; recettes : composants
        self.colName:SetText(searchingNow and "Recipe" or (nodes and NL[2] or "Recipe"))
        self.colReag:SetText(searchingNow and "Reagents / Loot" or (guide and "Materials" or (nodes and "Loot" or "Reagents")))
        profitMode = FC.db.char.prof_profit == true and not guide and not nodes
        self.colSrc:SetText(guide and "Cost" or (nodes and "" or (profitMode and "Profit »" or "Source »")))
        self.srcHdr:SetShown(not guide and not nodes)
        for i, tab in pairs(self.tabs) do tab:SetActive(not searchingNow and i == self.prof) end
        for m, b in pairs(self.modeBtns) do if m == view then b:LockHighlight() else b:UnlockHighlight() end end
        self.catDD.frame:SetShown(not guide)
        self.catDD.SetText(self.cat or "All categories")
        local known = PlayerProfessionNames()
        local rank = KnownRank(known, p)
        self.skillText:SetText(rank and ("Your skill: |cffffd100" .. rank .. "|r") or "")
        zoneRowRank = (not searchingNow) and rank or nil
        local lines = {}
        local function add(kind, data) table.insert(lines, { kind = kind, data = data }) end

        if self.query and #self.query >= 2 then
            -- Recherche dans tous les métiers : recette, objet produit ou composant
            -- (noms normalisés en cache, aucune requête au serveur)
            local q = self.query
            local function hit(id) return API.Has(q, API.NormField(FC.CraftItems[id], "n")) or API.Has(q, API.ItemSearchName(id)) end
            local total = 0
            for _, pi in ipairs(FC:GetProfessionOrder()) do
                local pr = FC.Professions[pi]
                local found = {}
                local cats = Categories(pr)
                for _, c in ipairs(cats) do
                    for _, r in ipairs(c.r or {}) do
                        local ok = API.Has(q, API.NormField(r, "n")) or (r.it and hit(r.it.id))
                        if not ok and r.zn then   -- ligne « zone » : nom traduit aussi
                            if r._zs == nil then r._zs = API.SearchNorm(ZoneName(r)) end
                            ok = API.Has(q, r._zs)
                        end
                        if not ok then
                            for _, rg in ipairs(r.rg or {}) do if hit(rg[1]) then ok = true; break end end
                        end
                        if ok then table.insert(found, { r = r, cat = c.n, gath = pr.g and not r.rc }) end
                    end
                end
                if #found > 0 then
                    table.sort(found, byLevel)
                    local key = "search:" .. pr.id
                    add("header", { key = key, text = "|T" .. API.IconPath(pr.ic) .. ":16:16:0:0|t " .. (pr.n or pr.id),
                        sub = #found .. " recipe" .. (#found > 1 and "s" or "") .. (KnownRank(known, pr) and ("  ·  your skill " .. KnownRank(known, pr)) or "") })
                    if not collapsed[key] then for _, e in ipairs(found) do add("recipe", e) end end
                    add("gap")
                    total = total + #found
                end
            end
            self.title:SetText("Professions — search")
            if total == 0 then add("header", { text = "No match for \"" .. q .. "\"." }) end
            self.list_:SetLines(lines, resetScroll ~= false)
            return
        end

        if guide then
            self.title:SetText("Professions — " .. (p.n or "") .. " — leveling guide")
            if not p.gd or #p.gd == 0 then
                add("header", { text = "No leveling guide for this profession yet." })
                self.list_:SetLines(lines, resetScroll ~= false)
                return
            end
            add("header", { text = "Leveling guide", sub = #p.gd .. " steps" .. (rank and ("  ·  your skill " .. rank) or "  ·  you don't know this profession") })
            local curIdx, need, order = GuideLines(p, rank, add)
            -- Liste de courses
            local total, est, missing = 0, false, false
            local shop = {}
            for _, key in ipairs(order) do
                local e = need[key]
                local have = e.id > 0 and API.ItemCount(e.id) or 0
                local price, isEst = Price(e.id)
                local buy = math.max(0, e.need - have)
                if price then total = total + price * buy; est = est or (isEst and buy > 0) elseif buy > 0 then missing = true end
                table.insert(shop, { id = e.id, name = e.name, need = e.need, have = have, buy = buy, price = price, est = isEst })
            end
            add("gap")
            if #shop == 0 then
                add("header", { text = "Shopping list", sub = "nothing left to craft" })
            else
                add("shophdr", { text = "Shopping list", sub = (rank and ("from " .. rank .. " to " .. (p.gd[#p.gd].t or "?")) or "whole guide") })
                for _, e in ipairs(shop) do add("shop", e) end
                add("header", { text = "Total to buy: " .. (est and "~" or "") .. API.Money(total, true),
                    sub = (missing and "some prices unknown  ·  " or "") .. "prices: Auction House scan" })
            end
            self.list_:SetLines(lines, resetScroll ~= false)
            -- Défilement jusqu'à l'étape en cours
            if resetScroll ~= false and curIdx and curIdx > 3 then
                local target = 24 + (curIdx - 3) * (ROW_H + 1)
                local function go() if self:IsShown() then self.sf:SetVerticalScroll(math.min(target, self.sf:GetVerticalScrollRange() or 0)) end end
                if C_Timer and C_Timer.After then C_Timer.After(0, go) else go() end
            end
            return
        end

        self.title:SetText("Professions — " .. (p.n or ""))
        -- Recettes du métier (et de la catégorie), par palier
        local list = {}
        local cats = Categories(p)
        for _, c in ipairs(cats) do
            if not self.cat or self.cat == c.n then
                for _, r in ipairs(c.r or {}) do
                    if InView(p, r, view) then table.insert(list, { r = r, cat = c.n, gath = p.g and not r.rc }) end
                end
            end
        end
        if profitMode then   -- du plus rentable au moins rentable (sans prix : à la fin)
            for _, e in ipairs(list) do e.pf = select(3, Economics(e.r)) end
            table.sort(list, function(a, b)
                if (a.pf ~= nil) ~= (b.pf ~= nil) then return a.pf ~= nil end
                if a.pf and b.pf and a.pf ~= b.pf then return a.pf > b.pf end
                return byLevel(a, b)
            end)
        else table.sort(list, byLevel) end
        for _, br in ipairs(BRACKETS) do
            local inB = {}
            for _, e in ipairs(list) do
                local lv = Level(e.r)
                if lv >= br[1] and lv <= br[2] then inB[#inB + 1] = e end
            end
            if #inB > 0 then
                local key = p.id .. ":" .. br[1]
                local nE = 0
                for _, e in ipairs(inB) do if e.gath then nE = nE + 1 end end
                local nR = #inB - nE
                local parts = {}
                if nE > 0 then parts[#parts + 1] = nE .. " " .. NL[3] .. (nE > 1 and (NL[3] == "entry" and "" or "s") or "") end
                if nE > 1 and NL[3] == "entry" then parts[#parts] = nE .. " entries" end
                if nR > 0 then parts[#parts + 1] = nR .. " recipe" .. (nR > 1 and "s" or "") end
                add("header", { key = key, text = br[3], sub = table.concat(parts, ", ") })
                if not collapsed[key] then for _, e in ipairs(inB) do add("recipe", e) end end
            end
        end
        if #lines == 0 then
            if nodes then add("header", { text = "No " .. NL[1]:lower() .. " listed yet." })
            else add("header", { text = "No recipe for this profession." }) end
        end
        self.list_:SetLines(lines, resetScroll ~= false)
    end

    -- Infos d'un objet reçues : on ne remet à jour que les lignes affichées qui l'utilisent
    API.OnItemInfo(function(id)
        if not f:IsShown() then return end
        f.list_:Refresh(function(l)
            if l.kind == "shop" then return l.data.id == id end
            if l.kind == "step" then
                if l.data.st.it == id then return true end
                for _, m in ipairs(l.data.st.m or {}) do if m[1] == id then return true end end
                return false
            end
            if l.kind ~= "recipe" then return false end
            local r = l.data.r
            if (r.it and r.it.id == id) or r.tb == id then return true end
            for _, rg in ipairs(r.rg or {}) do if rg[1] == id then return true end end
            return false
        end)
    end)
    -- Guide : quantités possédées (sacs) et compétence qui changent
    local ev = CreateFrame("Frame", nil, f)
    ev:RegisterEvent("BAG_UPDATE_DELAYED")
    ev:RegisterEvent("SKILL_LINES_CHANGED")
    ev:SetScript("OnEvent", function()
        if f:IsShown() and f.mode == "guide" and not (f.query and #f.query >= 2) then f:Render(false) end
    end)
    return f
end

-- Appelé après un scan de l'HV : prix du guide à jour
function FC:RefreshProfessionPrices()
    if profFrame and profFrame:IsShown() and profFrame.mode == "guide" then profFrame:Render(false) end
end

function FC:OpenProfessionsFrame()
    if #FC.Professions == 0 then
        print("|cFFFF6600" .. FC.NAME .. "|r : no profession data yet.")
        return
    end
    if not profFrame then profFrame = Build() end
    local order = FC:GetProfessionOrder()
    if #order == 0 then
        print("|cFFFF6600" .. FC.NAME .. "|r : all professions are hidden (Options > Professions).")
        return
    end
    -- Dernier métier consulté, sinon un métier du joueur, sinon le premier de l'ordre choisi
    local sel
    local known = PlayerProfessionNames()
    for _, i in ipairs(order) do if FC.Professions[i].id == FC.db.char.prof_last then sel = i end end
    if not sel then for _, i in ipairs(order) do if KnownRank(known, FC.Professions[i]) then sel = i; break end end end
    profFrame.prof = sel or order[1]
    profFrame:LayoutTabs()
    profFrame:Render()
    profFrame:Show()
    profFrame:Raise()
end

-- Appelé par les options quand l'ordre ou l'affichage des métiers change
function FC:RefreshProfessionTabs()
    if not profFrame then return end
    profFrame:LayoutTabs()
    if profFrame:IsShown() then profFrame:Render(false) end
end
