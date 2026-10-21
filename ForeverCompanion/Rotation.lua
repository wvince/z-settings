-- Forever Companion — Rotation.lua
-- Fenêtre de rotation de raid par classe/spec (données : Data/Rotations.lua)
-- Chaque étape = texte mêlé de sorts cliquables avec icône

local FC = ForeverCompanion
local rotFrame = nil
local escReg   = false

-- L'ID du sort est directement dans les données (seg.id)
-- GetSkillIcon récupère la texture du sort (API du client via Compat.lua)
local function GetSkillIcon(name, id)
    local API = ForeverCompanionAPI
    if id and id > 0 then
        local tex = API.GetSpellIcon(id)
        if tex then return tex end
    end
    -- Secours par nom (sorts connus du joueur)
    local tex = name and API.GetSpellIcon(name)
    if tex then return tex end
    return "Interface\\Icons\\INV_Misc_QuestionMark"
end


-- Largeur de la fenêtre et de la zone de texte (barre de défilement déduite)
local RF_W = 560
local CONTENT_W = RF_W - 44

-- Rendu d'une étape : icône + texte sur une ligne (multi-sorts inline)
local function BuildStepRow(parent, yOff, segments, idx)
    local row = CreateFrame("Frame", nil, parent)
    row:SetWidth(RF_W - 30)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, -yOff)

    -- Numéro de priorité
    local num = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    num:SetPoint("TOPLEFT", 0, 0)
    num:SetTextColor(1, 0.84, 0)
    num:SetText(idx ~= "" and (idx..".") or "")
    num:SetWidth(18)

    -- Construire le contenu : icônes et texte côte à côte
    local xCursor = 20
    local maxH    = 14
    local icons   = {}
    local texts   = {}

    for _, seg in ipairs(segments) do
        if seg.t == "skill" or seg.t == "consume" then
            -- Icône du sort
            local icon = row:CreateTexture(nil, "ARTWORK")
            icon:SetSize(16, 16)
            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            icon:SetPoint("TOPLEFT", row, "TOPLEFT", xCursor, -1)
            icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            local skillName = seg.v
            -- Charger l'icône de façon asynchrone si besoin
            local function loadIcon()
                local tex = GetSkillIcon(skillName)
                icon:SetTexture(tex)
            end
            loadIcon()
            table.insert(icons, {icon=icon, name=skillName, x=xCursor})
            xCursor = xCursor + 18
            maxH = math.max(maxH, 16)
        else
            -- Texte libre
            local txt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            txt:SetPoint("TOPLEFT", row, "TOPLEFT", xCursor, 0)
            txt:SetText(seg.v)
            txt:SetWidth(0)  -- auto
            txt:SetNonSpaceWrap(false)
            table.insert(texts, txt)
            -- Estimation largeur : ~6px par caractère (approximation)
            xCursor = xCursor + math.min(#seg.v * 5.5, RF_W - 30 - xCursor)
        end
    end

    row:SetHeight(maxH + 4)
    return row, maxH + 6
end

-- Construction d'une ligne de texte enrichi (icônes inline)
-- Approche simplifiée : une FontString multi-lignes avec les sorts en [NomDuSort]
-- et les icônes positionnées par-dessus (les deux layers se superposent)
local function BuildStepSimple(parent, yOff, segments, idx, ICON_SIZE)
    ICON_SIZE = ICON_SIZE or 18
    local row = CreateFrame("Frame", nil, parent)
    row:SetWidth(CONTENT_W - 4)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -yOff)
    -- Activer les hyperlinks sur ce frame
    row:EnableMouse(true)
    row:SetHyperlinksEnabled(true)
    row:SetScript("OnHyperlinkClick", function(self, link, text, btn)
        SetItemRef(link, text, btn)
    end)
    row:SetScript("OnHyperlinkEnter", function(self, link, text)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
    end)
    row:SetScript("OnHyperlinkLeave", function()
        GameTooltip:Hide()
    end)

    local xOff = (idx ~= "") and 18 or 0   -- introduction : pas de numéro
    local lineH = ICON_SIZE + 4

    local num = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    num:SetPoint("TOPLEFT", 0, -2)
    num:SetTextColor(1, 0.84, 0)
    num:SetText(idx ~= "" and (idx..".") or "")

    -- Texte avec icônes + liens Hspell cliquables
    local textLine = ""
    for _, seg in ipairs(segments) do
        if seg.t == "skill" or seg.t == "consume" then
            local link
            -- ID : sort connu du joueur sous ce nom (bon rang) en priorité,
            -- sinon l'ID des données s'il existe dans ce client
            local API = ForeverCompanionAPI
            local sid = API.GetSpellIDByName(seg.v)
            if not sid and API.SpellExists(seg.id) then sid = seg.id end
            if sid then
                link = "|cffffd000|Hspell:" .. sid .. "|h" .. seg.v .. "|h|r"
            else
                link = "|cffffd000" .. seg.v .. "|r"
            end
            textLine = textLine .. "|T" .. GetSkillIcon(seg.v, sid) .. ":" .. ICON_SIZE .. ":"
                       .. ICON_SIZE .. "|t" .. link
        else
            textLine = textLine .. seg.v:gsub("%s+", " ")
        end
    end

    local body = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    body:SetPoint("TOPLEFT", row, "TOPLEFT", xOff, -2)
    body:SetWidth(CONTENT_W - 8 - xOff)
    body:SetJustifyH("LEFT")
    body:SetJustifyV("TOP")
    body:SetText(textLine)
    body:SetNonSpaceWrap(true)
    body:SetSpacing(2)

    local textH = body:GetStringHeight()
    local rowH = math.max(lineH, textH + 4)
    row:SetHeight(rowH)
    body:SetHeight(rowH)

    return row, rowH + 2
end


-- Rotation d'un build, comme sur le site : un build « Level N » n'affiche que ses propres listes
-- (sections « … Level N »), les autres builds la rotation standard. Les sections d'un autre build
-- sont masquées ; celles qui ne correspondent à aucun build restent affichées. (Niveau / type : donnés par le Studio, sinon
-- lus dans le titre « Single Target — Level 30 ».)
local function SecLevel(sec) return sec.lv or tonumber(tostring(sec.title or ""):match("[Ll]evel%s*(%d+)") or "") end
local function SecKind(sec) return sec.kind or (tostring(sec.title or ""):match("^AoE") and "aoe" or "single") end
local function RotationLists(specData, builds, idx)
    local lv = builds[idx] and FC:BuildLevel(builds[idx])
    local buildLv = {}
    for _, b in ipairs(builds) do
        local l = FC:BuildLevel(b)
        if l then buildLv[l] = true end
    end
    local single, aoe, extra = nil, nil, {}
    for _, sec in ipairs(specData.sections or {}) do
        local sl = SecLevel(sec)
        if sl and buildLv[sl] then
            if lv == sl then
                if SecKind(sec) == "aoe" then aoe = sec.steps else single = sec.steps end
            end
        else
            table.insert(extra, sec)
        end
    end
    if lv then return { single = single, aoe = aoe, extra = extra } end
    return { single = specData.steps, aoe = specData.aoe, extra = extra }
end
FC.RotationLists = RotationLists   -- tests

local function OpenRotationFrame(forceClass, forceSpec)
    -- Déterminer la classe/spec
    local cn, sn
    if forceClass and forceSpec then
        cn, sn = forceClass, forceSpec
    else
        cn, sn = FC:DetectPlayerSpec()
    end
    if not cn or not sn then
        print("|cFFFF6600Forever Companion|r : Spec non détectée.")
        return
    end
    local classData = FC.RotationData[cn]
    if not classData then   -- clé de classe sans tenir compte de la casse (fenêtre Talents : « hunter »)
        for k, v in pairs(FC.RotationData) do if tostring(k):lower() == tostring(cn):lower() then cn, classData = k, v; break end end
    end
    local specData  = classData and classData[sn]
    local hasSteps = specData and ((specData.steps and #specData.steps > 0) or (specData.sections and #specData.sections > 0))
    if not hasSteps then
        print("|cFFFF6600Forever Companion|r : Pas de rotation pour " .. sn .. " " .. cn)
        return
    end

    -- Fermer si déjà ouverte
    if rotFrame then rotFrame:Hide(); rotFrame = nil end

    local f = ForeverCompanionAPI.CreateWindow("ForeverCompanionRotationFrame", UIParent)
    rotFrame = f
    FC.RotationFrame = f          -- fenêtre actuelle (utilisée par l'onglet de la fenêtre principale)
    f:SetWidth(RF_W)
    f:SetFrameStrata("HIGH")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self.dockedTo = nil; self:StartMoving() end)   -- déplacée : plus rattachée
    f:SetScript("OnDragStop",  f.StopMovingOrSizing)
    f:SetPoint("CENTER")

    ForeverCompanionAPI.CloseOnEscape(f)   -- fermeture par Échap

    -- Titre
    ForeverCompanionAPI.WindowTitle(f):SetText("Rotation — " .. sn .. " " .. cn)
    local insetBg = ForeverCompanionAPI.AddInset(f, 8, -28, -8, 8)

    -- Fond : l'arbre de talents de la spécialisation, assombri pour la lisibilité
    local specBg
    do
        local trees = FC.TalentTrees[cn:lower()] or FC.TalentTrees[cn]
        local tab = FC.SPEC_TREE[cn] and FC.SPEC_TREE[cn][sn]
        if not tab or tab < 1 then
            for i, s in ipairs(FC.TAB_TO_SPEC[cn] or {}) do if s == sn then tab = i end end
        end
        local tree = trees and trees[tab or 1]
        if tree and tree.bg and tree.bg ~= "" then
            specBg = ForeverCompanionAPI.CreateTalentBackground(f, insetBg, "BACKGROUND", 3)
            specBg:Set(tree.bg)
            local shade = f:CreateTexture(nil, "BACKGROUND", nil, 4)
            shade:SetAllPoints(insetBg)
            shade:SetColorTexture(0, 0, 0, 0.72)
        end
    end

    -- Build (comme sur le site : chaque build a sa rotation) : choix partagé avec la fenêtre Talents
    f.cn, f.sn = cn, sn
    local _, builds = FC:GetBuildIndex(cn, sn)
    local top = -40
    if #builds > 1 then
        local lbl = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        lbl:SetPoint("TOPLEFT", 16, -38); lbl:SetText("Build:")
        f.buildDD = ForeverCompanionAPI.CreateDropdown(f, 220, function()
            local items = {}
            local cur = FC:GetBuildIndex(cn, sn)
            local auto = FC:AutoBuildIndex(builds)
            for i, b in ipairs(builds) do
                items[#items + 1] = { text = b.name .. (i == auto and "  |cff9d9d9d(your level)|r" or ""),
                    isSelected = function() return FC:GetBuildIndex(cn, sn) == i end,
                    func = function() FC:SetBuildIndex(cn, sn, i) end }
            end
            return items
        end)
        f.buildDD.frame:SetPoint("LEFT", lbl, "RIGHT", 8 + (f.buildDD.xInset or 0), -2)
        f.buildNote = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        f.buildNote:SetPoint("LEFT", f.buildDD.frame, "RIGHT", 10, 2)
        top = -66
    end

    -- Zone défilante : barre de défilement (modèle du client) + molette
    local sf = ForeverCompanionAPI.CreateScrollFrame(f, "ForeverCompanionRotationScroll")
    sf:SetPoint("TOPLEFT",     f, "TOPLEFT",   12, top)
    sf:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -32, 32)
    ForeverCompanionAPI.AddBottomFade(sf, 26, 22)
    ForeverCompanionAPI.AddSoftBar(f, 14, 14, 25)

    -- Contenu (recréé à chaque changement de build)
    function f:Render()
        local idx, _, isAuto = FC:GetBuildIndex(cn, sn)
        local L = RotationLists(specData, builds, idx)
        if self.buildDD then
            self.buildDD.SetText(builds[idx] and builds[idx].name or "")
            self.buildNote:SetText(isAuto and "chosen for your level" or "")
        end
        if self.sc then self.sc:Hide() end
        local sc = CreateFrame("Frame", nil, sf)
        sc:SetWidth(CONTENT_W)
        sc:SetHeight(1)
        sf:SetScrollChild(sc)
        self.sc = sc

        local y = 16

        -- Titre de section + séparateur coloré (note grise facultative)
        local function sectionHeader(text, r, g, b, note)
            local hdr = sc:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            hdr:SetPoint("TOPLEFT", sc, "TOPLEFT", 0, -y)
            hdr:SetTextColor(r, g, b)
            hdr:SetText(text .. (note and ("  |cff9d9d9d" .. note .. "|r") or ""))
            y = y + 20
            local sep = sc:CreateTexture(nil, "ARTWORK")
            sep:SetHeight(1)
            sep:SetPoint("TOPLEFT",  sc, "TOPLEFT",  0, -y)
            sep:SetPoint("TOPRIGHT", sc, "TOPRIGHT", 0, -y)
            sep:SetColorTexture(r, g, b, 0.4)
            y = y + 8
        end

        -- Liste d'étapes numérotées ; {t="header"} = sous-titre (ex. "2-3 targets:")
        local function renderEntries(entries)
            local n = 1
            for _, entry in ipairs(entries or {}) do
                if entry.t == "header" then
                    local sub = sc:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    sub:SetPoint("TOPLEFT", sc, "TOPLEFT", 0, -y)
                    sub:SetTextColor(0.8, 0.8, 0.8)
                    sub:SetText(entry.v)
                    y = y + 18
                else
                    local _, h = BuildStepSimple(sc, y, entry, n)
                    n = n + 1
                    y = y + h
                end
            end
        end

        -- Introduction (texte libre avec sorts)
        if specData.intro and #specData.intro > 0 then
            local _, h = BuildStepSimple(sc, y, specData.intro, "")
            y = y + h + 6
        end

        if L.single and #L.single > 0 then
            sectionHeader("Rotation (Priority List)", 0.4, 0.8, 1)
            renderEntries(L.single)
        end

        if L.aoe and #L.aoe > 0 then
            y = y + 8
            sectionHeader("AoE", 0.4, 1, 0.4)
            renderEntries(L.aoe)
        end

        -- Sections propres à aucun build (ex. ouverture)
        for _, sec in ipairs(L.extra) do
            if sec.steps and #sec.steps > 0 then
                y = y + 8
                sectionHeader(sec.title or "", 1, 0.84, 0)
                renderEntries(sec.steps)
            end
        end

        sc:SetHeight(y + 8)
        local maxH = math.min(640, math.floor((UIParent:GetHeight() or 800) * 0.8))
        local fh = math.min(y + 80 - (top + 40), maxH)
        self:SetHeight(fh)  -- au-delà : défilement
        if specBg then specBg:Resize(RF_W - 16, fh - 36) end
        if sf.UpdateScrollChildRect then sf:UpdateScrollChildRect() end
        sf:SetVerticalScroll(0)
    end
    f:Render()
    f:Show()
end

-- Rotation disponible pour une classe / spé (clé de classe sans tenir compte de la casse)
function FC:HasRotation(cn, sn)
    if not cn or not sn then return false end
    for k, specs in pairs(FC.RotationData or {}) do
        if tostring(k):lower() == tostring(cn):lower() then
            local d = specs[sn]
            return d and ((d.steps and #d.steps > 0) or (d.sections and #d.sections > 0)) and true or false
        end
    end
    return false
end

-- Bouton « Rotation » de la fenêtre Talents : ouvre la rotation collée à gauche de la fenêtre
-- (à droite s'il n'y a pas la place) ; un second clic la ferme. Elle se ferme avec la fenêtre
-- Talents tant qu'elle n'a pas été déplacée.
function FC:ToggleDockedRotation(anchor, cn, sn)
    local f = rotFrame
    if f and f:IsShown() and f.dockedTo == anchor and tostring(f.cn):lower() == tostring(cn):lower() and f.sn == sn then
        f:Hide(); return
    end
    OpenRotationFrame(cn, sn)
    f = rotFrame
    if not (f and anchor) then return end
    f:ClearAllPoints()
    local left = anchor:GetLeft() or 0
    if left >= RF_W + 8 then f:SetPoint("TOPRIGHT", anchor, "TOPLEFT", -6, 0)
    else f:SetPoint("TOPLEFT", anchor, "TOPRIGHT", 6, 0) end
    f.dockedTo = anchor
    if not anchor.fcRotHooked then
        anchor.fcRotHooked = true
        anchor:HookScript("OnHide", function(self) if rotFrame and rotFrame.dockedTo == self then rotFrame:Hide() end end)
    end
end

-- Build changé ailleurs (fenêtre Talents ou menu) : la rotation affichée suit
function FC:RefreshRotationBuild(cn, sn)
    local f = rotFrame
    if not (f and f:IsShown() and f.Render and f.cn) then return end
    if tostring(f.cn):lower() ~= tostring(cn):lower() or f.sn ~= sn then return end
    f:Render()
end

-- ── API publique ───────────────────────────────────────────────────────────
function FC:OpenRotationFrame()
    OpenRotationFrame()
end

function FC:OpenRotationFrameForSpec(cn, sn)
    OpenRotationFrame(cn, sn)
end

-- Commandes slash
SLASH_FCROTATION1 = "/fcrot"
SLASH_FCROTATION2 = "/bisrot"
SlashCmdList["FCROTATION"] = function() OpenRotationFrame() end
