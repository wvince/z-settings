-- Forever Companion — Compat.lua
-- Couche de compatibilité : WoW Forever (interface 16001) repose sur l'API du jeu
-- actuel (12.x) ; les anciennes fonctions globales sont utilisées en secours.
-- Tout le reste de l'addon passe par ces fonctions : en cas de changement d'API
-- dans le client, c'est ici (et seulement ici) qu'il faut corriger.
local API = {}
ForeverCompanionAPI = API

local C_Item, C_Spell = C_Item, C_Spell

-- ── Items ────────────────────────────────────────────────────────────────
-- Renvoie les mêmes valeurs que l'ancien GetItemInfo (nom, lien, qualité, …, icône)
function API.GetItemInfo(item)
    if C_Item and C_Item.GetItemInfo then return C_Item.GetItemInfo(item) end
    if GetItemInfo then return GetItemInfo(item) end
end

-- Icône d'un objet (lue dans les fichiers du client, sans requête au serveur quand
-- C_Item.GetItemIconByID existe). Renvoie nil pour un objet inconnu du client
-- (le point d'interrogation 134400 n'est pas une vraie icône).
local QUESTION_MARK = 134400
function API.GetItemIcon(item)
    if C_Item and C_Item.GetItemIconByID then
        local ok, icon = pcall(C_Item.GetItemIconByID, item)
        if ok and icon and icon ~= QUESTION_MARK then return icon end
        return nil
    end
    return (select(10, API.GetItemInfo(item)))
end

function API.GetItemInfoInstant(item)
    if C_Item and C_Item.GetItemInfoInstant then return C_Item.GetItemInfoInstant(item) end
    if GetItemInfoInstant then return GetItemInfoInstant(item) end
end

function API.GetItemQualityColor(quality)
    if C_Item and C_Item.GetItemQualityColor then return C_Item.GetItemQualityColor(quality) end
    if GetItemQualityColor then return GetItemQualityColor(quality) end
    return 1, 1, 1
end

-- Nombre d'exemplaires possédés (sacs + banque)
function API.ItemCount(id)
    local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
    if not fn or not id or id <= 0 then return 0 end
    local ok, n = pcall(fn, id, true)
    return (ok and tonumber(n)) or 0
end

-- ── Argent ───────────────────────────────────────────────────────────────
-- « 12 [or] 34 [argent] 5 [cuivre] » avec les icônes de pièces du jeu.
-- short : n'affiche que les deux plus grosses unités (listes, info-bulles).
local COIN_G = "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t"
local COIN_S = "|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t"
local COIN_C = "|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t"
local function Thousands(n)
    local s = tostring(n)
    local out = s:reverse():gsub("(%d%d%d)", "%1 "):reverse()
    return (out:gsub("^ ", ""))
end
function API.Money(c, short)
    c = math.floor((tonumber(c) or 0) + 0.5)
    local neg = c < 0; if neg then c = -c end
    local g, s, cu = math.floor(c / 10000), math.floor(c / 100) % 100, c % 100
    local out = {}
    if g > 0 then table.insert(out, Thousands(g) .. COIN_G) end
    if s > 0 and not (short and g >= 100) then table.insert(out, s .. COIN_S) end
    if cu > 0 and not (short and g > 0) then table.insert(out, cu .. COIN_C) end
    if #out == 0 then out[1] = "0" .. COIN_C end
    return (neg and "-" or "") .. table.concat(out, " ")
end

-- ── Sorts ────────────────────────────────────────────────────────────────
function API.GetSpellName(spell)
    if C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(spell) end
    if C_Spell and C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(spell)
        return info and info.name
    end
    if GetSpellInfo then return (GetSpellInfo(spell)) end
end

function API.GetSpellIcon(spell)
    if C_Spell and C_Spell.GetSpellTexture then return C_Spell.GetSpellTexture(spell) end
    if GetSpellTexture then return GetSpellTexture(spell) end
    if GetSpellInfo then return (select(3, GetSpellInfo(spell))) end
end

-- ID du sort connu par le joueur portant ce nom (bon rang, bonne version du jeu), sinon nil
function API.GetSpellIDByName(name)
    if not name or name == "" then return nil end
    if C_Spell and C_Spell.GetSpellInfo then
        local ok, info = pcall(C_Spell.GetSpellInfo, name)
        if ok and type(info) == "table" and info.spellID then return info.spellID end
    elseif GetSpellInfo then
        local ok, _, _, _, _, _, _, id = pcall(GetSpellInfo, name)
        if ok and id then return id end
    end
end

-- Un ID de sort existe-t-il dans ce client ?
function API.SpellExists(id)
    if not id or id <= 0 then return false end
    if C_Spell and C_Spell.DoesSpellExist then
        local ok, r = pcall(C_Spell.DoesSpellExist, id); if ok then return r and true or false end
    end
    return API.GetSpellName(id) ~= nil
end

function API.GetSpellLink(spell)
    if C_Spell and C_Spell.GetSpellLink then return C_Spell.GetSpellLink(spell) end
    if GetSpellLink then return GetSpellLink(spell) end
end

-- Le joueur connaît-il ce sort (ce rang précis) ? Plusieurs API selon le client : la première qui répond oui
function API.IsSpellKnown(id)
    if not id or id <= 0 then return false end
    local fns = { C_SpellBook and C_SpellBook.IsSpellKnown or false, IsPlayerSpell or false, IsSpellKnown or false }
    for i = 1, 3 do   -- (pas ipairs : il s'arrêterait à la première API absente)
        local fn = fns[i]
        if type(fn) == "function" then
            local ok, v = pcall(fn, id)
            if ok and v then return true end
        end
    end
    return false
end

-- Sous-titre du sort (« Rang 3 » dans la langue du client), sinon nil
function API.GetSpellSubtext(id)
    if C_Spell and C_Spell.GetSpellSubtext then
        local ok, v = pcall(C_Spell.GetSpellSubtext, id); if ok and v and v ~= "" then return v end
    end
    if GetSpellSubtext then
        local ok, v = pcall(GetSpellSubtext, id); if ok and v and v ~= "" then return v end
    end
end

-- ── Tooltips d'items ─────────────────────────────────────────────────────
-- callback(tooltip, itemId) est appelé à chaque affichage d'un tooltip d'item.
function API.HookItemTooltips(callback)
    local function safe(tt, id)
        if not id then return end
        local ok, err = pcall(callback, tt, id)
        if not ok and ForeverCompanion and ForeverCompanion.db and ForeverCompanion.db.char.inspectDebug then
            print("|cffff6600Forever Companion|r tooltip: " .. tostring(err))
        end
    end
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
        -- API actuelle (10.0.2+)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tt, data)
            if tt ~= GameTooltip and tt ~= ItemRefTooltip then return end
            local id = data and data.id
            if not id and tt.GetItem then
                local _, link = tt:GetItem()
                id = link and tonumber(link:match("item:(%d+)"))
            end
            safe(tt, id)
        end)
        return "TooltipDataProcessor"
    end
    -- Ancienne API
    local function onSetItem(tt)
        local _, link = tt:GetItem()
        safe(tt, link and tonumber(link:match("item:(%d+)")))
    end
    for _, tt in ipairs({ GameTooltip, ItemRefTooltip }) do
        if tt and tt.HookScript then pcall(tt.HookScript, tt, "OnTooltipSetItem", onSetItem) end
    end
    return "OnTooltipSetItem"
end

-- ── Lecture d'un objet sans afficher son infobulle ───────────────────────
-- Lignes de l'infobulle : { { l = texte de gauche, r = texte de droite, red = texte en rouge }, … }
-- (rouge : objet que le personnage ne peut pas utiliser, niveau trop bas…). nil si illisible.
local scanTip
local function IsRed(r, g, b)
    if type(r) == "table" then r, g, b = r.r, r.g, r.b end
    return (r and g and b and r > 0.9 and g < 0.3 and b < 0.3) and true or false
end
function API.TooltipLines(link)
    if not link then return nil end
    if C_TooltipInfo and C_TooltipInfo.GetHyperlink then
        local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
        if not ok or not data or not data.lines then return nil end
        local out = {}
        for _, ln in ipairs(data.lines) do
            if ln.leftText == nil and ln.args and TooltipUtil and TooltipUtil.SurfaceArgs then pcall(TooltipUtil.SurfaceArgs, ln) end
            out[#out + 1] = { l = ln.leftText, r = ln.rightText,
                red = IsRed(ln.leftColor) or (ln.rightText ~= nil and ln.rightText ~= "" and IsRed(ln.rightColor)) }
        end
        return out
    end
    -- Anciens clients : infobulle cachée
    if not scanTip then
        scanTip = CreateFrame("GameTooltip", "ForeverCompanionScanTooltip", nil, "GameTooltipTemplate")
    end
    scanTip:SetOwner(WorldFrame or UIParent, "ANCHOR_NONE")
    scanTip:ClearLines()
    if not pcall(scanTip.SetHyperlink, scanTip, link) then return nil end
    local out = {}
    for i = 1, scanTip:NumLines() or 0 do
        local L, R = _G["ForeverCompanionScanTooltipTextLeft" .. i], _G["ForeverCompanionScanTooltipTextRight" .. i]
        local lt = L and L:GetText()
        local rt = R and R:IsShown() and R:GetText() or nil
        out[#out + 1] = { l = lt, r = rt, red = (L and IsRed(L:GetTextColor())) or (rt and IsRed(R:GetTextColor())) or false }
    end
    scanTip:Hide()
    return out
end

-- Caractéristiques d'un objet (table ITEM_MOD_…_SHORT = valeur), nil si indisponible
function API.GetItemStats(link)
    local fn = (C_Item and C_Item.GetItemStats) or GetItemStats
    if not fn or not link then return nil end
    local ok, t = pcall(fn, link)
    return ok and type(t) == "table" and t or nil
end

-- Réaffiche le tooltip courant (ex. appui sur ALT)
function API.RefreshTooltip(tt)
    if not tt or not tt:IsShown() then return end
    if tt.RefreshData then
        pcall(tt.RefreshData, tt)
        return
    end
    local _, link = tt:GetItem()
    if link then tt:SetHyperlink(link) end
end

-- ── Fenêtres ─────────────────────────────────────────────────────────────
-- Fermeture par Échap sans intercepter le clavier (compatible combat)
function API.CloseOnEscape(frame)
    local name = frame and frame:GetName()
    if not name or not UISpecialFrames then return end
    for _, n in ipairs(UISpecialFrames) do if n == name then return end end
    table.insert(UISpecialFrames, name)
end

function API.IsAddOnLoaded(name)
    if C_AddOns and C_AddOns.IsAddOnLoaded then return C_AddOns.IsAddOnLoaded(name) end
    if IsAddOnLoaded then return IsAddOnLoaded(name) end
end

-- Accroche un bouton à une fenêtre Blizzard : visible seulement quand elle l'est
function API.AttachToFrame(btn, frame)
    frame:HookScript("OnShow", function() btn:Show() end)
    frame:HookScript("OnHide", function() btn:Hide() end)
    if frame:IsShown() then btn:Show() else btn:Hide() end
end

-- ── Fenêtres au style du jeu ─────────────────────────────────────────────
-- Les fenêtres de l'addon reprennent les modèles du client (comme la fiche
-- personnage) : elles prennent donc automatiquement l'apparence de WoW Forever.
-- Ordre d'essai : PortraitFrameTemplate (sans portrait) → BasicFrameTemplateWithInset
-- → cadre simple dessiné par l'addon (secours).
local function TemplateExists(tpl)
    if C_XMLUtil and C_XMLUtil.GetTemplateInfo then
        local ok, info = pcall(C_XMLUtil.GetTemplateInfo, tpl)
        return ok and info ~= nil
    end
    return tpl == "BasicFrameTemplateWithInset"   -- anciens clients : modèle sûr
end

function API.CreateWindow(name, parent, w, h)
    parent = parent or UIParent
    local f
    if TemplateExists("PortraitFrameTemplate") then
        f = CreateFrame("Frame", name, parent, "PortraitFrameTemplate")
        f.fcStyle = "portrait"
        -- Pas de portrait rond : bordure complète, titre centré dans le bandeau
        if ButtonFrameTemplate_HidePortrait then pcall(ButtonFrameTemplate_HidePortrait, f)
        elseif f.SetPortraitShown then pcall(f.SetPortraitShown, f, false) end
    elseif TemplateExists("BasicFrameTemplateWithInset") then
        f = CreateFrame("Frame", name, parent, "BasicFrameTemplateWithInset")
        f.fcStyle = "basic"
    else
        f = CreateFrame("Frame", name, parent, "BackdropTemplate")
        f.fcStyle = "backdrop"
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
            tile = true, tileSize = 32, edgeSize = 24,
            insets = { left = 6, right = 6, top = 6, bottom = 6 },
        })
        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOP", 0, -10)
        f.TitleText = t
        f.CloseButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
        f.CloseButton:SetPoint("TOPRIGHT", 2, 2)
    end
    if w and h then f:SetSize(w, h) end
    -- Superposition : la fenêtre ouverte ou cliquée passe devant les autres,
    -- avec tout son contenu (bordures comprises)
    f:SetToplevel(true)
    f:HookScript("OnShow", function(self) self:Raise() end)
    f:Raise()
    -- Fermeture : simple Hide (pas de HideUIPanel, la fenêtre n'est pas un panneau Blizzard)
    local close = f.CloseButton
    if type(close) == "table" then close:SetScript("OnClick", function() f:Hide() end) end
    return f
end

-- Bouton au style du menu du jeu (Échap), sinon bouton standard
function API.CreateMenuButton(parent, w, h, text)
    local tpl = "UIPanelButtonTemplate"
    for _, t in ipairs({ "MainMenuFrameButtonTemplate", "GameMenuButtonTemplate" }) do
        if C_XMLUtil and C_XMLUtil.GetTemplateInfo and TemplateExists(t) then tpl = t; break end
    end
    local b = CreateFrame("Button", nil, parent, tpl)
    b:SetSize(w, h)
    if tpl ~= "UIPanelButtonTemplate" then
        -- Police du menu réduite pour tenir dans un petit bouton
        pcall(b.SetNormalFontObject, b, "GameFontHighlight")
        pcall(b.SetHighlightFontObject, b, "GameFontHighlight")
        pcall(b.SetDisabledFontObject, b, "GameFontDisable")
    end
    if text then b:SetText(text) end
    return b
end

-- ── Couleurs du panneau Statistiques de la fiche personnage (relevées en jeu) ──
-- Fond du panneau quasi noir, lignes alternées brun clair / brun foncé avec un
-- dégradé horizontal (plus sombre sur les bords), liseré bronze.
API.COLORS = {
    pane   = { 0.012, 0.004, 0.0 },
    border = { 0.23, 0.15, 0.06 },
    bar    = { 0.18, 0.145, 0.118 },
    light  = { center = { 0.231, 0.165, 0.110 }, edge = { 0.125, 0.075, 0.047 } },
    dark   = { center = { 0.145, 0.090, 0.063 }, edge = { 0.078, 0.047, 0.031 } },
    header = { center = { 0.275, 0.192, 0.125 }, edge = { 0.150, 0.095, 0.055 } },
    sep    = { 0.36, 0.25, 0.12, 0.35 },
}

-- Dégradé horizontal compatible anciens / nouveaux clients
-- c1/c2 = {r,g,b[,a]} ; en VERTICAL, c1 = bas et c2 = haut
local function Gradient(tex, c1, c2, orient)
    orient = orient or "HORIZONTAL"
    local a1, a2 = c1[4] or 1, c2[4] or 1
    tex:SetColorTexture(1, 1, 1, 1)
    if CreateColor then
        local ok = pcall(tex.SetGradient, tex, orient, CreateColor(c1[1], c1[2], c1[3], a1), CreateColor(c2[1], c2[2], c2[3], a2))
        if ok then return end
    end
    if tex.SetGradientAlpha then
        local ok = pcall(tex.SetGradientAlpha, tex, orient, c1[1], c1[2], c1[3], a1, c2[1], c2[2], c2[3], a2)
        if ok then return end
    end
    tex:SetColorTexture(c2[1], c2[2], c2[3], (a1 + a2) / 2)
end

-- Fond de ligne : bord sombre → centre clair → bord sombre (deux moitiés)
function API.StripedBackground(frame, style, layer)
    local c = API.COLORS[style] or API.COLORS.dark
    local l = frame:CreateTexture(nil, layer or "BACKGROUND")
    local r = frame:CreateTexture(nil, layer or "BACKGROUND")
    l:SetPoint("TOPLEFT"); l:SetPoint("BOTTOMRIGHT", frame, "BOTTOM")
    r:SetPoint("TOPLEFT", frame, "TOP"); r:SetPoint("BOTTOMRIGHT")
    Gradient(l, c.edge, c.center)
    Gradient(r, c.center, c.edge)
    return l, r
end

function API.RowBackground(row, idx)
    return API.StripedBackground(row, (idx % 2 == 1) and "light" or "dark")
end

-- Zone sombre du panneau : fond dessiné sur la fenêtre (sous tout le contenu)
-- + bordure du modèle InsetFrameTemplate du jeu (celle de la fiche personnage),
-- sinon un liseré bronze simple.
function API.AddInset(f, x1, y1, x2, y2, anchorTop)
    local C = API.COLORS
    local bg = f:CreateTexture(nil, "BACKGROUND", nil, 2)
    bg:SetColorTexture(C.pane[1], C.pane[2], C.pane[3], 1)
    bg:SetPoint("TOPLEFT", anchorTop or f, "TOPLEFT", x1, y1)
    bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", x2, y2)
    if TemplateExists("InsetFrameTemplate") then
        local inset = CreateFrame("Frame", nil, f, "InsetFrameTemplate")
        inset:SetAllPoints(bg)
        -- Au-dessus du contenu (ce n'est qu'une bordure) ; son fond est masqué
        inset:SetFrameLevel(f:GetFrameLevel() + 8)
        if type(inset.Bg) == "table" then inset.Bg:Hide() end
        inset:EnableMouse(false)
        return bg, inset
    end
    local function edge(p1, p2, horiz)
        local t = f:CreateTexture(nil, "BACKGROUND", nil, 3)
        t:SetColorTexture(C.border[1], C.border[2], C.border[3], 1)
        t:SetPoint(p1, bg, p1); t:SetPoint(p2, bg, p2)
        if horiz then t:SetHeight(1) else t:SetWidth(1) end
    end
    edge("TOPLEFT", "TOPRIGHT", true); edge("BOTTOMLEFT", "BOTTOMRIGHT", true)
    edge("TOPLEFT", "BOTTOMLEFT", false); edge("TOPRIGHT", "BOTTOMRIGHT", false)
    return bg
end

-- Fondu en bas d'une zone défilante (comme la dernière ligne des Statistiques) :
-- dégradé transparent → fond du panneau, par-dessus le contenu et la barre.
function API.AddBottomFade(sf, height, extraRight)
    local C = API.COLORS
    local o = CreateFrame("Frame", nil, sf:GetParent())
    o:SetPoint("BOTTOMLEFT", sf, "BOTTOMLEFT", 0, 0)
    o:SetPoint("BOTTOMRIGHT", sf, "BOTTOMRIGHT", extraRight or 0, 0)
    o:SetHeight(height or 24)
    o:SetFrameLevel(sf:GetFrameLevel() + 5)
    o:EnableMouse(false)
    local t = o:CreateTexture(nil, "OVERLAY")
    t:SetAllPoints()
    Gradient(t, { C.pane[1], C.pane[2], C.pane[3], 1 }, { C.pane[1], C.pane[2], C.pane[3], 0 }, "VERTICAL")
    -- Masqué quand la liste est tout en bas (ou ne défile pas) : la dernière ligne reste nette
    local function upd()
        local r = sf:GetVerticalScrollRange() or 0
        o:SetShown(r > 1 and (sf:GetVerticalScroll() or 0) < r - 1)
    end
    sf:HookScript("OnVerticalScroll", upd)
    sf:HookScript("OnScrollRangeChanged", upd)
    sf:HookScript("OnShow", upd)
    upd()
    return o
end

-- Petite barre lumineuse sous la liste (comme en bas des Statistiques) :
-- 3 px, plus claire au centre, qui s'efface vers les bords.
function API.AddSoftBar(f, left, right, bottomY)
    local C = API.COLORS
    local rows = { { 0, 0.35 }, { 1, 1 }, { 2, 0.35 } }   -- {décalage, intensité}
    for _, r in ipairs(rows) do
        local c = { C.bar[1] * r[2], C.bar[2] * r[2], C.bar[3] * r[2] }
        local l = f:CreateTexture(nil, "BACKGROUND", nil, 5)
        local rt = f:CreateTexture(nil, "BACKGROUND", nil, 5)
        l:SetHeight(1); rt:SetHeight(1)
        l:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", left, bottomY + r[1])
        l:SetPoint("BOTTOMRIGHT", f, "BOTTOM", (left - right) / 2, bottomY + r[1])
        rt:SetPoint("BOTTOMLEFT", l, "BOTTOMRIGHT")
        rt:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -right, bottomY + r[1])
        Gradient(l, { c[1], c[2], c[3], 0 }, { c[1], c[2], c[3], 1 })
        Gradient(rt, { c[1], c[2], c[3], 1 }, { c[1], c[2], c[3], 0 })
    end
end

-- Zone défilante avec la barre fine de la fiche personnage (MinimalScrollBar),
-- sinon la barre classique. La barre se place à droite de la zone (+6 px).
function API.CreateScrollFrame(parent, name)
    if ScrollUtil and ScrollUtil.InitScrollFrameWithScrollBar and TemplateExists("MinimalScrollBar") then
        local sf = CreateFrame("ScrollFrame", name, parent)
        local okB, bar = pcall(CreateFrame, "EventFrame", nil, parent, "MinimalScrollBar")
        if okB and bar then
            bar:SetPoint("TOPLEFT", sf, "TOPRIGHT", 5, -2)
            bar:SetPoint("BOTTOMLEFT", sf, "BOTTOMRIGHT", 5, 2)
            if pcall(ScrollUtil.InitScrollFrameWithScrollBar, sf, bar) then
                sf.fcBar = bar
                return sf, bar
            end
            bar:Hide()
        end
        -- Secours : molette seule
        sf:EnableMouseWheel(true)
        sf:SetScript("OnMouseWheel", function(self, delta)
            local maxV = self:GetVerticalScrollRange() or 0
            self:SetVerticalScroll(math.max(0, math.min(maxV, self:GetVerticalScroll() - delta * 40)))
        end)
        return sf
    end
    local sf = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
    return sf, sf.ScrollBar
end

-- ── Fonds des arbres de talents ──────────────────────────────────────────
-- Noms de fichiers du jeu (Interface\TalentFrame\<nom>-TopLeft…) : certains
-- arbres n'ont pas le nom de leur spécialisation.
local BG_ALIAS = {
    ShamanElemental = "ShamanElementalCombat",
    PaladinRetribution = "PaladinCombat",
    WarlockAffliction = "WarlockCurses",
    WarlockDemonology = "WarlockSummoning",
    DruidFeral = "DruidFeralCombat",
}
function API.TalentBgName(bg) return bg and (BG_ALIAS[bg] or bg) end

-- Crée les 4 morceaux du fond d'un arbre sur « owner » ; renvoie un objet
-- avec :Set(bg) et :Resize(w, h). Les morceaux partent du coin haut-gauche de anchor.
function API.CreateTalentBackground(owner, anchor, layer, sublevel)
    local o = {}
    local tl = owner:CreateTexture(nil, layer or "BACKGROUND", nil, sublevel)
    local tr = owner:CreateTexture(nil, layer or "BACKGROUND", nil, sublevel)
    local bl = owner:CreateTexture(nil, layer or "BACKGROUND", nil, sublevel)
    local br = owner:CreateTexture(nil, layer or "BACKGROUND", nil, sublevel)
    tl:SetPoint("TOPLEFT", anchor or owner, "TOPLEFT")
    tr:SetPoint("TOPLEFT", tl, "TOPRIGHT")
    bl:SetPoint("TOPLEFT", tl, "BOTTOMLEFT")
    br:SetPoint("TOPLEFT", tl, "BOTTOMRIGHT")
    function o:Set(bg)
        bg = API.TalentBgName(bg)
        local base = "Interface\\TalentFrame\\" .. tostring(bg)
        tl:SetTexture(base .. "-TopLeft"); tr:SetTexture(base .. "-TopRight")
        bl:SetTexture(base .. "-BottomLeft"); br:SetTexture(base .. "-BottomRight")
    end
    -- Partie utile de l'image : 300 × 331 px sur 320 × 384
    function o:Resize(w, h)
        local tw, th = w / (256 + 44), h / (256 + 75)
        tl:SetSize(tw * 256, th * 256); tr:SetSize(tw * 64, th * 256)
        bl:SetSize(tw * 256, th * 128); br:SetSize(tw * 64, th * 128)
    end
    o.textures = { tl, tr, bl, br }
    return o
end

-- ── Onglets latéraux à icône (comme ceux de la fiche personnage) ─────────
-- icon : ID de fichier, chemin de texture ou nom d'icône (« inv_potion_93 »)
function API.IconPath(icon)
    if type(icon) == "number" then return icon end
    local s = tostring(icon or "")
    if s == "" then return "Interface\\Icons\\INV_Misc_QuestionMark" end
    if tonumber(s) then return tonumber(s) end
    if s:find("[\\/]") then return s end
    return "Interface\\Icons\\" .. s
end

local function AtlasExists(name)
    if not (C_Texture and C_Texture.GetAtlasInfo) then return false end
    local ok, info = pcall(C_Texture.GetAtlasInfo, name)
    return ok and info ~= nil
end

-- Relevé en jeu (/fc skin sur les onglets de la fiche personnage, CharacterFrameModeTab) :
-- cadre 54×54, fond atlas « common-sidetab » 54×60, icône 50×50 (coordonnées 0,03-0,97) décalée
-- de 4 px à gauche et masquée par « common-sidetab-mask », survol « common-sidetab-hover »,
-- sélection « common-sidetab-selected » ; tout est centré sur l'onglet.
API.SIDETAB_SIZE = 54
API.AtlasExists = AtlasExists

-- Petit bouton d'options (roue dentée) à placer dans la barre de titre
function API.CreateOptionsButton(parent, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(20, 20)
    local close = parent.CloseButton
    if type(close) == "table" then
        b:SetPoint("RIGHT", close, "LEFT", -2, 0)
        b:SetFrameLevel((close:GetFrameLevel() or parent:GetFrameLevel()) + 1)
    else
        b:SetPoint("TOPRIGHT", -30, -4)
    end
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetAllPoints()
    if AtlasExists("QuestLog-icon-setting") then b.icon:SetAtlas("QuestLog-icon-setting")
    else b.icon:SetTexture("Interface\\Buttons\\UI-OptionsButton") end
    b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
    b:SetScript("OnMouseDown", function(self) self.icon:SetPoint("TOPLEFT", 1, -1); self.icon:SetPoint("BOTTOMRIGHT", 1, -1) end)
    b:SetScript("OnMouseUp", function(self) self.icon:SetAllPoints() end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:AddLine("Options", 1, 0.82, 0); GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:SetScript("OnClick", onClick)
    return b
end

function API.CreateSideTab(parent, size)
    local b = CreateFrame("Button", nil, parent)
    if AtlasExists("common-sidetab") then
        size = size or 54
        local k = size / 54
        b:SetSize(size, size)
        -- Relevé exact de CharacterFrameModeTab1 : tout centré, icône décalée de 4 px
        -- vers la gauche et arrondie par le masque « common-sidetab-mask »
        b.bg = b:CreateTexture(nil, "BACKGROUND")
        b.bg:SetAtlas("common-sidetab"); b.bg:SetSize(54 * k, 60 * k); b.bg:SetPoint("CENTER")
        b.icon = b:CreateTexture(nil, "ARTWORK")
        b.icon:SetSize(50 * k, 50 * k); b.icon:SetPoint("CENTER", -4 * k, 0)
        b.icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)
        if b.CreateMaskTexture and AtlasExists("common-sidetab-mask") then
            local m = b:CreateMaskTexture()
            m:SetAtlas("common-sidetab-mask"); m:SetSize(54 * k, 60 * k); m:SetPoint("CENTER")
            b.icon:AddMaskTexture(m)
            b.mask = m
        end
        b.sel = b:CreateTexture(nil, "OVERLAY")
        b.sel:SetAtlas("common-sidetab-selected"); b.sel:SetSize(54 * k, 60 * k); b.sel:SetPoint("CENTER"); b.sel:Hide()
        b.hl = b:CreateTexture(nil, "HIGHLIGHT")
        b.hl:SetAtlas("common-sidetab-hover"); b.hl:SetSize(54 * k, 60 * k); b.hl:SetPoint("CENTER")
        b.style = "forever"
    else
        -- Secours : cadre doré dessiné par l'addon
        size = size or 40
        b:SetSize(size, size)
        b.bg = b:CreateTexture(nil, "BACKGROUND")
        b.bg:SetPoint("TOPLEFT", 1, -1); b.bg:SetPoint("BOTTOMRIGHT", -1, 1)
        b.bg:SetColorTexture(0, 0, 0, 0.85)
        b.icon = b:CreateTexture(nil, "ARTWORK")
        b.icon:SetPoint("TOPLEFT", 3, -3); b.icon:SetPoint("BOTTOMRIGHT", -3, 3)
        b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        b.border = b:CreateTexture(nil, "OVERLAY")
        if AtlasExists("UI-HUD-ActionBar-IconFrame") then
            b.border:SetAtlas("UI-HUD-ActionBar-IconFrame")
            b.border:SetPoint("TOPLEFT", -1, 1); b.border:SetPoint("BOTTOMRIGHT", 1, -1)
        else
            b.border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
            b.border:SetSize(size * 1.72, size * 1.72); b.border:SetPoint("CENTER", 0, 0)
        end
        b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        b.sel = b:CreateTexture(nil, "OVERLAY", nil, 2)
        b.sel:SetTexture("Interface\\Buttons\\CheckButtonHilight"); b.sel:SetBlendMode("ADD")
        b.sel:SetAllPoints(); b.sel:Hide()
        b.style = "addon"
    end
    b:SetScript("OnEnter", function(self)
        if not self.tooltip then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(self.tooltip, 1, 0.82, 0)
        if self.tooltipSub then GameTooltip:AddLine(self.tooltipSub, 0.6, 0.6, 0.6) end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    function b:SetIcon(icon) self.icon:SetTexture(API.IconPath(icon)) end
    function b:SetActive(on) if on then self.sel:Show() else self.sel:Hide() end end
    return b
end

-- /fc skin : relevé des textures du cadre sous la souris (pour copier l'apparence
-- d'un élément de l'interface du jeu, par ex. les onglets de la fiche personnage)
function API.DumpFrameUnderMouse(maxDepth)
    local f
    if GetMouseFoci then local t = GetMouseFoci(); f = t and t[1] elseif GetMouseFocus then f = GetMouseFocus() end
    if not f then print("|cffffd700FC|r : aucun cadre sous la souris."); return end
    local function nm(o)
        if type(o) ~= "table" then return tostring(o) end
        return (o.GetName and o:GetName()) or (o.GetObjectType and o:GetObjectType()) or "?"
    end
    local function tex(r)
        local a = r.GetAtlas and r:GetAtlas()
        return a and ("atlas=" .. a) or ("tex=" .. tostring(r.GetTexture and r:GetTexture()))
    end
    local function points(r)
        local out = {}
        for i = 1, (r.GetNumPoints and r:GetNumPoints() or 0) do
            local p, rel, rp, x, y = r:GetPoint(i)
            table.insert(out, string.format("%s>%s:%s(%d,%d)", tostring(p), nm(rel), tostring(rp), x or 0, y or 0))
        end
        return table.concat(out, " ")
    end
    local function line(r)
        local l, t, _, b = 0, 0, 0, 0
        local ul, ut, ll, lb, ur, urt, lr, lrb
        if r.GetTexCoord then ul, ut, ll, lb, ur, urt, lr, lrb = r:GetTexCoord() end
        local s = string.format("%s %s %dx%d uv=%.2f-%.2f,%.2f-%.2f", r:GetObjectType(), tex(r), r:GetWidth() or 0, r:GetHeight() or 0,
            ul or 0, lr or 1, ut or 0, lrb or 1)
        if r.GetDrawLayer then s = s .. " couche=" .. tostring((r:GetDrawLayer())) end
        s = s .. " pts=" .. points(r)
        if r.GetNumMaskTextures and r:GetNumMaskTextures() > 0 then
            for i = 1, r:GetNumMaskTextures() do
                local m = r:GetMaskTexture(i)
                if m then s = s .. " MASQUE=" .. tex(m) .. string.format(" %dx%d", m:GetWidth() or 0, m:GetHeight() or 0) end
            end
        end
        return s
    end
    local function dump(frame, depth)
        local ind = string.rep("  ", depth)
        print(ind .. "|cff66ccff" .. nm(frame) .. "|r " .. string.format("%dx%d", frame:GetWidth() or 0, frame:GetHeight() or 0) .. " pts=" .. points(frame))
        for _, r in ipairs({ frame:GetRegions() }) do
            local ty = r.GetObjectType and r:GetObjectType()
            if (ty == "Texture" or ty == "MaskTexture") then print(ind .. "  " .. line(r) .. (r:IsShown() and "" or " (caché)")) end
        end
        if depth < (maxDepth or 2) then for _, c in ipairs({ frame:GetChildren() }) do dump(c, depth + 1) end end
    end
    dump(f, 0)
    local p = f.GetParent and f:GetParent()
    if p then print("|cffffd700FC|r parent : " .. nm(p)) end
end

-- ── Champ de recherche ─────────────────────────────────────────────────────
-- Modèle du jeu (loupe + croix d'effacement) si disponible ; onChange(texte) est
-- appelé 0,2 s après la dernière frappe.
function API.CreateSearchBox(parent, width, onChange, placeholder)
    local tpl = TemplateExists("SearchBoxTemplate") and "SearchBoxTemplate" or "InputBoxTemplate"
    local e = CreateFrame("EditBox", nil, parent, tpl)
    e:SetSize(width, 20)
    e:SetAutoFocus(false)
    if tpl == "InputBoxTemplate" then
        e.hint = e:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        e.hint:SetPoint("LEFT", 2, 0); e.hint:SetText(placeholder or "Search")
    elseif e.Instructions and placeholder then
        e.Instructions:SetText(placeholder)
    end
    local gen = 0
    e:HookScript("OnTextChanged", function(self)
        local t = self:GetText() or ""
        if self.hint then if t == "" then self.hint:Show() else self.hint:Hide() end end
        gen = gen + 1
        local mine = gen
        local fire = function() if mine == gen then onChange(t) end end
        if C_Timer and C_Timer.After then C_Timer.After(0.2, fire) else fire() end
    end)
    e:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
    e:HookScript("OnEnterPressed", function(self) self:ClearFocus() end)
    return e
end

-- Texte comparable pour la recherche : minuscules, accents français courants retirés
local ACCENTS = { ["\195\160"] = "a", ["\195\162"] = "a", ["\195\164"] = "a", ["\195\167"] = "c", ["\195\168"] = "e",
    ["\195\169"] = "e", ["\195\170"] = "e", ["\195\171"] = "e", ["\195\174"] = "i", ["\195\175"] = "i", ["\195\180"] = "o",
    ["\195\182"] = "o", ["\195\185"] = "u", ["\195\187"] = "u", ["\195\188"] = "u",
    ["\195\128"] = "a", ["\195\130"] = "a", ["\195\135"] = "c", ["\195\136"] = "e", ["\195\137"] = "e", ["\195\138"] = "e",
    ["\195\142"] = "i", ["\195\148"] = "o", ["\195\153"] = "u", ["\195\155"] = "u" }
function API.SearchNorm(s)
    s = tostring(s or "")
    s = s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    s = s:gsub("\195[\128-\191]", function(c) return ACCENTS[c] or c end)
    s = s:gsub("\226\128\153", "'")
    return s:lower()
end
function API.Matches(q, ...)
    if not q or q == "" then return true end
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        if v and API.SearchNorm(v):find(q, 1, true) then return true end
    end
    return false
end

-- ── Noms d'objets pour la recherche, sans requête au serveur ──────────────
-- GetItemInfo sur un objet absent du cache déclenche une requête au serveur puis
-- l'évènement GET_ITEM_INFO_RECEIVED : appelé sur des centaines d'objets à chaque
-- frappe, c'est la cause des gros ralentissements. Ici on ne lit le nom du client
-- que s'il est déjà en cache, et on le garde en mémoire (normalisé).
local itemNameNorm = {}
local itemListeners = {}
do
    local ev = CreateFrame("Frame")
    pcall(ev.RegisterEvent, ev, "GET_ITEM_INFO_RECEIVED")
    ev:SetScript("OnEvent", function(_, _, id, ok)
        if id then itemNameNorm[id] = nil end
        for _, fn in ipairs(itemListeners) do pcall(fn, id, ok) end
    end)
end
-- fn(itemId, ok) appelé quand le client reçoit les infos d'un objet
function API.OnItemInfo(fn) table.insert(itemListeners, fn) end

function API.ItemIsCached(id)
    if C_Item and C_Item.IsItemDataCachedByID then
        local ok, v = pcall(C_Item.IsItemDataCachedByID, id)
        if ok then return v and true or false end
    end
    return true
end
-- L'objet existe-t-il dans ce client ? (nil si on ne peut pas le savoir)
function API.ItemExists(id)
    if C_Item and C_Item.DoesItemExistByID then
        local ok, v = pcall(C_Item.DoesItemExistByID, id)
        if ok then return v and true or false end
    end
    return nil
end
-- Nom normalisé du client si l'objet est en cache, sinon nil (sans requête)
function API.ItemSearchName(id)
    local v = itemNameNorm[id]
    if v == nil then
        v = false
        if API.ItemIsCached(id) then
            local n = API.GetItemInfo(id)
            if n then v = API.SearchNorm(n) end
        end
        itemNameNorm[id] = v
    end
    return v or nil
end
-- Texte normalisé mis en cache dans la table t (champ _s), à partir du champ key
function API.NormField(t, key)
    if not t then return nil end
    local s = t._s
    if s == nil then s = API.SearchNorm(t[key or "n"] or ""); t._s = s end
    return s
end
function API.Has(q, s) return s ~= nil and s ~= "" and s:find(q, 1, true) ~= nil end

-- Info-bulle d'objet. Objet en cache : info-bulle du jeu. Sinon on affiche tout de
-- suite une info-bulle construite à partir des données (nom, rareté, emplacement,
-- niveau) et on demande l'objet au serveur ; si la réponse arrive pendant le survol,
-- l'info-bulle du jeu la remplace. Certains objets du site ne sont pas (encore)
-- dans le jeu : le serveur ne répond jamais et l'info-bulle des données reste.
local pendingTip
function API.ShowItemTooltip(owner, id, data, extra)
    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    local cached = API.ItemIsCached(id) and API.ItemExists(id) ~= false
    if cached then
        if GameTooltip.SetItemByID then GameTooltip:SetItemByID(id) else GameTooltip:SetHyperlink("item:" .. id) end
        pendingTip = nil
    else
        data = data or {}
        local r, g, b = API.GetItemQualityColor(data.r or 1)
        GameTooltip:AddLine(data.n or ("Item " .. id), r, g, b)
        local slot = data.s and data.s ~= "" and (data.s:gsub("^%l", string.upper)) or nil
        if slot or (data.t and data.t ~= "") then GameTooltip:AddDoubleLine(slot or "", data.t or "", 1, 1, 1, 1, 1, 1) end
        if data.lv then GameTooltip:AddLine("Item Level " .. data.lv, 1, 0.82, 0) end
        GameTooltip:AddLine("Not available from the game server (ID " .. id .. ")", 0.55, 0.55, 0.55)
        if C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, id) end
        pendingTip = { owner = owner, id = id, data = data, extra = extra }
    end
    if extra then for _, l in ipairs(extra) do GameTooltip:AddLine(l[1], l[2] or 1, l[3] or 1, l[4] or 1) end end
    GameTooltip:Show()
end
API.OnItemInfo(function(id, ok)
    local p = pendingTip
    if p and p.id == id and ok ~= false and GameTooltip:IsShown() and GameTooltip:GetOwner() == p.owner then
        API.ShowItemTooltip(p.owner, p.id, p.data, p.extra)
    end
end)

-- ── Clic sur un objet (partout dans l'addon) ─────────────────────────────
-- Lien d'objet : celui du jeu si l'objet est en cache, sinon construit à partir des données
function API.ItemLink(id, data)
    if API.ItemIsCached(id) then
        local _, link = API.GetItemInfo(id)
        if link then return link end
    end
    data = data or {}
    local r, g, b = API.GetItemQualityColor(data.r or 1)
    return string.format("|cff%02x%02x%02x|Hitem:%d::::::::::::|h[%s]|h|r", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255, id, data.n or ("Item " .. id))
end

-- Info-bulle fixe et fermable (ItemRefTooltip, comme un clic sur un objet dans le chat).
-- Un second clic sur le même objet la ferme.
function API.ShowItemRef(id, data)
    local tt = ItemRefTooltip
    if not tt then return end
    local link = API.ItemLink(id, data)
    if API.ItemIsCached(id) and API.ItemExists(id) ~= false and SetItemRef then
        tt.fcItemId = nil
        SetItemRef("item:" .. id, link, "LeftButton")
        return
    end
    -- Objet absent du cache : info-bulle des données, remplacée par celle du jeu si le serveur répond
    if tt:IsShown() and tt.fcItemId == id then tt:Hide(); tt.fcItemId = nil; return end
    if ShowUIPanel then pcall(ShowUIPanel, tt) end
    if not tt:IsShown() or tt.fcItemId == nil then tt:SetOwner(UIParent, "ANCHOR_PRESERVE") end
    tt:ClearLines()
    data = data or {}
    local r, g, b = API.GetItemQualityColor(data.r or 1)
    tt:AddLine(data.n or ("Item " .. id), r, g, b)
    local slot = data.s and data.s ~= "" and (data.s:gsub("^%l", string.upper)) or nil
    if slot or (data.t and data.t ~= "") then tt:AddDoubleLine(slot or "", data.t or "", 1, 1, 1, 1, 1, 1) end
    if data.lv then tt:AddLine("Item Level " .. data.lv, 1, 0.82, 0) end
    tt:AddLine("Not available from the game server (ID " .. id .. ")", 0.55, 0.55, 0.55)
    tt:Show()
    tt.fcItemId = id
    if C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, id) end
end
API.OnItemInfo(function(id, ok)
    local tt = ItemRefTooltip
    if tt and tt.fcItemId == id and ok ~= false and tt:IsShown() then
        tt.fcItemId = nil
        tt:SetHyperlink("item:" .. id)
    end
end)

-- Clic sur un objet : Maj = lien dans le chat, Ctrl = cabine d'essayage (et autres
-- clics modifiés du jeu), clic simple = info-bulle fixe.
function API.ItemClick(id, data, button)
    if not id or id <= 0 then return end
    if button and button ~= "LeftButton" then return end
    local link = API.ItemLink(id, data)
    if IsModifiedClick and IsModifiedClick() then
        local handled = HandleModifiedItemClick and HandleModifiedItemClick(link)
        if not handled and IsModifiedClick("CHATLINK") and ChatEdit_InsertLink then ChatEdit_InsertLink(link) end
        return
    end
    local FC = ForeverCompanion
    if FC and FC.db and FC.db.char.item_click_ref == false then return end   -- désactivé dans les options
    API.ShowItemRef(id, data)
end

-- ── Liste virtuelle ──────────────────────────────────────────────────────
-- Seules les lignes visibles ont un cadre (une vingtaine), quel que soit le nombre
-- de lignes : pas de création de centaines de cadres ni de requêtes d'objets hors écran.
-- kinds[kind] = { h = hauteur, create = function(parent) -> frame, fill = function(frame, data) }
-- (un type sans create sert d'espace vide). Lignes : { kind = "...", data = ..., h = facultatif }
function API.VirtualList(sf, sc, kinds)
    local V = { lines = {}, pools = {}, active = {}, total = 0 }
    local MARGIN = 60
    local function lineH(l) return l.h or kinds[l.kind].h end
    local function release(i)
        local f = V.active[i]
        if f then f:Hide(); f.__line = nil; table.insert(V.pools[f.__vkind], f); V.active[i] = nil end
    end
    function V:Layout()
        local top = sf:GetVerticalScroll() or 0
        local bottom = top + math.max(sf:GetHeight() or 0, 200)
        local lines = self.lines
        -- première ligne visible (recherche dichotomique sur y)
        local lo, hi = 1, #lines
        while lo < hi do
            local mid = math.floor((lo + hi) / 2)
            local l = lines[mid]
            if l.y + lineH(l) < top - MARGIN then lo = mid + 1 else hi = mid end
        end
        local keep = {}
        for i = lo, #lines do
            local l = lines[i]
            if l.y > bottom + MARGIN then break end
            local k = kinds[l.kind]
            if k.create then
                keep[i] = true
                if not self.active[i] then
                    self.pools[l.kind] = self.pools[l.kind] or {}
                    local f = table.remove(self.pools[l.kind]) or k.create(sc)
                    f.__vkind = l.kind; f.__line = l
                    f:ClearAllPoints(); f:SetPoint("TOPLEFT", 0, -l.y); f:SetPoint("RIGHT", sc, "RIGHT", 0, 0)
                    k.fill(f, l.data)
                    f:Show()
                    self.active[i] = f
                end
            end
        end
        for i in pairs(self.active) do if not keep[i] then release(i) end end
    end
    function V:SetLines(lines, resetScroll)
        for i in pairs(self.active) do release(i) end
        local y = 0
        for _, l in ipairs(lines) do l.y = y; y = y + lineH(l) end
        self.lines, self.total = lines, y
        sc:SetHeight(math.max(y + 8, 1))
        if resetScroll then sf:SetVerticalScroll(0) end
        self:Layout()
    end
    -- Remplit à nouveau les lignes affichées qui vérifient pred(ligne)
    function V:Refresh(pred)
        for _, f in pairs(self.active) do
            local l = f.__line
            if l and pred(l) then kinds[l.kind].fill(f, l.data) end
        end
    end
    function V:Each(fn) for _, f in pairs(self.active) do fn(f, f.__line) end end
    sf:HookScript("OnVerticalScroll", function() V:Layout() end)
    sf:HookScript("OnSizeChanged", function() V:Layout() end)
    return V
end

-- FontString du titre de la fenêtre (SetText, SetTextColor…)
function API.WindowTitle(f)
    local tc = rawget(f, "TitleContainer") or f.TitleContainer
    if type(tc) == "table" and type(tc.TitleText) == "table" then return tc.TitleText end
    if type(f.TitleText) == "table" then return f.TitleText end
    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", 0, -6)
    f.TitleText = t
    return t
end

-- ── Menus déroulants ─────────────────────────────────────────────────────
-- build() renvoie une liste {text=, isSelected=function, func=function}
-- ou {text=, children={…}} pour un sous-menu.
-- Utilise le nouveau système de menus (WowStyle1DropdownTemplate) s'il existe,
-- sinon UIDropDownMenu. width = largeur visible totale.
-- Renvoie un objet {frame, xInset, Refresh(), SetText(t)}.
function API.CreateDropdown(parent, width, build)
    local dd = { build = build }
    local okNew, f = false, nil
    if MenuUtil then okNew, f = pcall(CreateFrame, "DropdownButton", nil, parent, "WowStyle1DropdownTemplate") end
    if okNew and f and f.SetupMenu then
        f:SetWidth(width)
        dd.xInset = 0
        f:SetupMenu(function(_, root)
            for _, item in ipairs(dd.build()) do
                if item.children then   -- sous-menu (ex. une classe → ses specs)
                    local sub = root:CreateButton(item.text)
                    for _, c in ipairs(item.children) do
                        sub:CreateRadio(c.text, c.isSelected, function() c.func(); dd.Refresh() end)
                    end
                else
                    root:CreateRadio(item.text, item.isSelected, function()
                        item.func()
                        dd.Refresh()
                    end)
                end
            end
        end)
        dd.frame = f
        function dd.Refresh()
            if f.GenerateMenu then f:GenerateMenu() end
            if dd.text and f.OverrideText then f:OverrideText(dd.text) end
        end
        function dd.SetText(t)
            dd.text = t
            if f.OverrideText then f:OverrideText(t) elseif f.SetDefaultText then f:SetDefaultText(t) end
        end
        return dd
    end
    -- Ancienne API
    f = CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate")
    UIDropDownMenu_SetWidth(f, width - 30)   -- le modèle ajoute ~30 px de bords
    dd.xInset = -16                          -- et 16 px de marge à gauche
    local function init()
        local function add(item, indent)
            local info = UIDropDownMenu_CreateInfo()
            info.text = (indent and "   " or "") .. item.text
            info.checked = item.isSelected and item.isSelected() or false
            info.func = function() item.func(); dd.Refresh() end
            UIDropDownMenu_AddButton(info)
        end
        for _, item in ipairs(dd.build()) do
            if item.children then   -- ancienne API : titre puis entrées en retrait
                local info = UIDropDownMenu_CreateInfo()
                info.text = item.text; info.isTitle = true; info.notCheckable = true
                UIDropDownMenu_AddButton(info)
                for _, c in ipairs(item.children) do add(c, true) end
            else
                add(item)
            end
        end
    end
    UIDropDownMenu_Initialize(f, init)
    dd.frame = f
    function dd.Refresh()
        UIDropDownMenu_Initialize(f, init)
        if dd.text then UIDropDownMenu_SetText(f, dd.text) end
    end
    function dd.SetText(t) dd.text = t; UIDropDownMenu_SetText(f, t) end
    return dd
end

-- ── Talents ──────────────────────────────────────────────────────────────
-- ── Talents via le système de traits (C_Traits) : utilisé par WoW Forever ──
-- On parcourt les nœuds achetés de la configuration active et on rattache chaque
-- talent à l'un des 3 arbres des données, dans cet ordre :
--   1) ID du sort du talent (données du Studio) ;
--   2) nom : anglais des données, ou nom traduit par le jeu à partir de l'ID
--      (client français : « Frappe foudroyante » = Stormstrike) ;
--   3) position dans l'arbre : les 3 arbres sont côte à côte, de gauche à droite.
local function NormName(s)
    s = tostring(s or ""):lower():gsub("\226\128\153", "'")
    return s
end

-- Colonnes des 3 arbres d'après la position horizontale des nœuds : on coupe aux
-- deux plus grands écarts, s'ils sont nettement plus grands que l'écart habituel.
local function PositionTabs(xs)
    local u, seen = {}, {}
    for _, x in ipairs(xs) do if not seen[x] then seen[x] = true; u[#u + 1] = x end end
    table.sort(u)
    if #u < 6 then return nil end
    local gaps = {}
    for i = 2, #u do gaps[#gaps + 1] = { u[i] - u[i - 1], i } end
    local sorted = {}
    for _, g in ipairs(gaps) do sorted[#sorted + 1] = g[1] end
    table.sort(sorted)
    local median = sorted[math.floor((#sorted + 1) / 2)]
    table.sort(gaps, function(a, b) return a[1] > b[1] end)
    local g1, g2, g3 = gaps[1], gaps[2], gaps[3]
    if not (g1 and g2) or g2[1] < 1.5 * median or (g3 and g2[1] < 1.3 * g3[1]) then return nil end
    local cut1, cut2 = math.min(g1[2], g2[2]), math.max(g1[2], g2[2])
    local lim1, lim2 = u[cut1], u[cut2]          -- première valeur de la 2e et de la 3e colonne
    return function(x) if x < lim1 then return 1 elseif x < lim2 then return 2 else return 3 end end
end

-- Renvoie ranks[tab], total, infos (pour le diagnostic) ou nil
function API.TraitTalentPoints(isInspect, unit)
    if not (C_Traits and C_Traits.GetConfigInfo and C_Traits.GetTreeNodes and C_Traits.GetNodeInfo) then return nil end
    local configID
    if isInspect then
        configID = (Constants and Constants.TraitConsts and Constants.TraitConsts.INSPECT_TRAIT_CONFIG_ID) or -1
    elseif C_ClassTalents and C_ClassTalents.GetActiveConfigID then
        local ok, id = pcall(C_ClassTalents.GetActiveConfigID); if ok then configID = id end
    end
    if not configID then return nil end
    local okC, cfg = pcall(C_Traits.GetConfigInfo, configID)
    if not okC or type(cfg) ~= "table" or type(cfg.treeIDs) ~= "table" then return nil end

    -- Talents de la classe → arbre (1-3), par ID de sort et par nom (anglais + traduit)
    local _, classToken = UnitClass(isInspect and (unit or "target") or "player")
    local FC = ForeverCompanion
    local trees = FC and FC.TalentTrees and classToken and (FC.TalentTrees[classToken:lower()] or FC.TalentTrees[classToken])
    local nameToTab, idToTab = {}, {}
    for tab, tree in pairs(trees or {}) do
        for _, t in ipairs(tree.talents or {}) do
            nameToTab[NormName(t.name)] = tab
            if t.id and t.id > 0 then
                idToTab[t.id] = tab
                local loc = API.GetSpellName(t.id)
                if loc and loc ~= "" then nameToTab[NormName(loc)] = tab end
            end
        end
    end

    local ranks, total = { 0, 0, 0 }, 0
    local info = { configID = configID, trees = #cfg.treeIDs, nodes = 0, bought = 0, matched = 0, unmatched = {},
        byId = 0, byName = 0, byPos = 0 }
    local bought, xs = {}, {}
    for _, treeID in ipairs(cfg.treeIDs) do
        local okN, nodes = pcall(C_Traits.GetTreeNodes, treeID)
        for _, nodeID in ipairs(okN and nodes or {}) do
            info.nodes = info.nodes + 1
            local okI, node = pcall(C_Traits.GetNodeInfo, configID, nodeID)
            if okI and type(node) == "table" then
                if type(node.posX) == "number" then xs[#xs + 1] = node.posX end
                local r = node.ranksPurchased or node.activeRank or node.currentRank or 0
                if r > 0 then
                    info.bought = info.bought + 1
                    local entryID = (node.activeEntry and node.activeEntry.entryID) or (node.entryIDs and node.entryIDs[1])
                    local name, spellID
                    if entryID and C_Traits.GetEntryInfo and C_Traits.GetDefinitionInfo then
                        local okE, entry = pcall(C_Traits.GetEntryInfo, configID, entryID)
                        if okE and entry and entry.definitionID then
                            local okD, def = pcall(C_Traits.GetDefinitionInfo, entry.definitionID)
                            if okD and def then
                                spellID = def.spellID
                                name = def.overrideName
                                if (not name or name == "") and spellID then name = API.GetSpellName(spellID) end
                            end
                        end
                    end
                    bought[#bought + 1] = { r = r, name = name, spellID = spellID, x = node.posX }
                end
            end
        end
    end
    local posTab = PositionTabs(xs)
    info.columns = posTab and "3" or "?"
    for _, b in ipairs(bought) do
        local tab, how = b.spellID and idToTab[b.spellID], "byId"
        if not tab then tab, how = b.name and nameToTab[NormName(b.name)], "byName" end
        if not tab and posTab and b.x then tab, how = posTab(b.x), "byPos" end
        if tab and ranks[tab] then
            ranks[tab] = ranks[tab] + b.r; total = total + b.r
            info.matched = info.matched + 1; info[how] = info[how] + 1
        elseif #info.unmatched < 5 then
            table.insert(info.unmatched, tostring(b.name) .. (b.spellID and (" #" .. b.spellID) or ""))
        end
    end
    return ranks, total, info
end

-- Renvoie bestTab, bestPoints, totalPoints (nil si l'API n'est pas disponible).
-- 1) arbres « Classic » (GetTalentInfo) ; 2) spécialisation moderne en secours.
function API.CountTalentPoints(isInspect, unit)
    if GetTalentInfo and GetNumTalentTabs then
        local ok, res = pcall(function()
            local activeGroup = 1
            if GetActiveTalentGroup then
                local ok2, v = pcall(GetActiveTalentGroup, isInspect)
                if ok2 and type(v) == "number" then activeGroup = v end
            end
            local numTabs = GetNumTalentTabs(isInspect) or 3
            local maxTalents = ((GetNumTalents and GetNumTalents(1, isInspect)) or 30) + 20
            local bestTab, bestPoints, total = 1, 0, 0
            for tab = 1, numTabs do
                local pts = 0
                for i = 1, maxTalents do
                    local name, _, _, _, rank = GetTalentInfo(tab, i, isInspect, nil, activeGroup)
                    if type(name) ~= "string" then break end
                    if type(rank) == "number" then pts = pts + rank end
                end
                total = total + pts
                if pts > bestPoints then bestTab, bestPoints = tab, pts end
            end
            return { bestTab, bestPoints, total }
        end)
        if ok and res and res[3] > 0 then return res[1], res[2], res[3] end
    end
    -- 2) Points par arbre via GetTalentTabInfo (renvoie les points dépensés)
    if GetTalentTabInfo then
        local ok, res = pcall(function()
            local bestTab, bestPoints, total = 1, 0, 0
            for tab = 1, ((GetNumTalentTabs and GetNumTalentTabs(isInspect)) or 3) do
                local r = { GetTalentTabInfo(tab, isInspect) }
                -- Classic : name, icon, pointsSpent… ; Wrath+ : id, name, desc, icon, pointsSpent…
                local pts = (type(r[1]) == "number" and type(r[2]) == "string") and r[5] or r[3]
                pts = type(pts) == "number" and pts or 0
                total = total + pts
                if pts > bestPoints then bestTab, bestPoints = tab, pts end
            end
            return { bestTab, bestPoints, total }
        end)
        if ok and res and res[3] > 0 then return res[1], res[2], res[3] end
    end
    -- 3) Système de traits (WoW Forever)
    local ranks, tot = API.TraitTalentPoints(isInspect, unit)
    if ranks and tot and tot > 0 then
        local bestTab, bestPoints = 1, 0
        for t = 1, 3 do if ranks[t] > bestPoints then bestTab, bestPoints = t, ranks[t] end end
        return bestTab, bestPoints, tot
    end
    -- 4) Spécialisation moderne (si le client en propose une)
    if not isInspect and GetSpecialization then
        local ok, s = pcall(GetSpecialization)
        if ok and type(s) == "number" and s > 0 then return s, 0, 1 end
    elseif isInspect and GetInspectSpecialization and GetSpecializationInfoByID then
        local ok, specID = pcall(GetInspectSpecialization, unit or "target")
        if ok and type(specID) == "number" and specID > 0 and GetNumSpecializationsForClassID then
            local _, _, classID = UnitClass(unit or "target")
            for i = 1, (GetNumSpecializationsForClassID(classID) or 0) do
                if GetSpecializationInfoForClassID(classID, i) == specID then return i, 0, 1 end
            end
        end
    end
    return nil, 0, 0
end

-- Icône d'un talent d'après son nom, lue dans les arbres du client (classe du joueur).
-- Sert quand les données du site ne fournissent pas d'icône. Résultat mis en cache.
local talentIconCache
function API.FindTalentIcon(tab, name)
    if not name then return nil end
    if not talentIconCache then
        talentIconCache = {}
        if GetTalentInfo and GetNumTalentTabs then
            pcall(function()
                for t = 1, (GetNumTalentTabs() or 3) do
                    for i = 1, 60 do
                        local n, icon = GetTalentInfo(t, i)
                        if type(n) ~= "string" then break end
                        if icon then talentIconCache[n] = icon end
                    end
                end
            end)
        end
    end
    return talentIconCache[name] or API.GetSpellIcon(name)
end
