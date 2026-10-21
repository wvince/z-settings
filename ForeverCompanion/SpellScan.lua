-- Forever Companion — SpellScan.lua
-- /fc scan      : cherche dans la base de sorts du client l'ID des sorts des rotations
--                 et des talents qui n'ont pas d'ID valide.
-- /fc scan tout : revérifie aussi ceux qui ont déjà un ID (pour corriger un mauvais choix).
-- Quand plusieurs sorts portent le même nom, une fenêtre de choix affiche chaque
-- candidat (icône + info-bulle au survol) : un clic choisit le bon.
-- Résultat : liste « Nom=ID » à coller dans Forever Companion Studio
-- (Dictionnaires > Sorts > « Coller des ID… »).
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local MAX_ID   = 2000000  -- plage d'ID parcourue (le client actuel dépasse 1 200 000)
local PER_TICK = 10000    -- ID testés par image (le scan dure quelques secondes)
local MAX_CAND = 10       -- candidats gardés par nom

-- Nom comparable : minuscules, apostrophes typographiques unifiées, espaces nettoyés
local function Norm(s)
    s = tostring(s or ""):lower()
    s = s:gsub("\226\128\153", "'"):gsub("\226\128\152", "'"):gsub("`", "'")
    s = s:gsub("%s+", " "):gsub("^ ", ""):gsub(" $", "")
    return s
end

-- « Faerie Fire (Feral) » → base « faerie fire », précision « feral »
local function SplitParen(s)
    local base, sub = s:match("^(.-)%s*%((.-)%)$")
    if base and base ~= "" then return base, sub end
end

local function SpellSubtext(id)
    if C_Spell and C_Spell.GetSpellSubtext then
        local ok, t = pcall(C_Spell.GetSpellSubtext, id); if ok then return t end
    end
    if GetSpellSubtext then
        local ok, t = pcall(GetSpellSubtext, id); if ok then return t end
    end
end

-- Noms à chercher : wanted[nom] = { current = ID actuel ou nil, talent = true/nil }
local function WantedSpells(all)
    local wanted, n = {}, 0
    local function add(name, id, isTalent)
        if not name or name == "" then return end
        local valid = API.SpellExists(id)
        if valid and not all then return end
        local w = wanted[name]
        if not w then w = {}; wanted[name] = w; n = n + 1 end
        if valid and not w.current then w.current = id end
        if isTalent then w.talent = true end
    end
    for _, trees in pairs(FC.TalentTrees or {}) do
        for _, tree in pairs(trees) do
            for _, t in ipairs(tree.talents or {}) do add(t.name, t.id, true) end
        end
    end
    local function scanSteps(steps)
        for _, st in ipairs(steps or {}) do
            if type(st) == "table" and not st.t then
                for _, seg in ipairs(st) do
                    if seg.t == "skill" then add(seg.v, seg.id, false) end
                end
            end
        end
    end
    for _, specs in pairs(FC.RotationData or {}) do
        for _, r in pairs(specs) do
            scanSteps(r.steps); scanSteps(r.aoe)
            if r.intro then scanSteps({ r.intro }) end
            for _, sec in ipairs(r.sections or {}) do scanSteps(sec.steps) end
        end
    end
    return wanted, n
end

-- ── Fenêtre d'export (Ctrl+A puis Ctrl+C) ────────────────────────────────
local exportFrame
local function ShowExport(text)
    if not exportFrame then
        local f = API.CreateWindow("ForeverCompanionScanFrame", UIParent)
        f:SetSize(420, 420); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG")
        f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        API.WindowTitle(f):SetText(FC.NAME .. " — ID de sorts")
        local hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        hint:SetPoint("TOPLEFT", 14, -30); hint:SetWidth(390); hint:SetJustifyH("LEFT")
        hint:SetText("Ctrl+A puis Ctrl+C, et colle dans le Studio : Dictionnaires > Sorts > « Coller des ID ».")
        local sf = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        sf:SetPoint("TOPLEFT", 12, -52); sf:SetPoint("BOTTOMRIGHT", -32, 12)
        local eb = CreateFrame("EditBox", nil, sf)
        eb:SetMultiLine(true); eb:SetAutoFocus(true); eb:SetFontObject(ChatFontNormal); eb:SetWidth(360)
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)
        f.edit = eb
        API.CloseOnEscape(f)
        exportFrame = f
    end
    exportFrame.edit:SetText(text)
    exportFrame.edit:HighlightText()
    exportFrame:Show()
    exportFrame:Raise()
end

-- ── Construction de la liste finale ──────────────────────────────────────
local function BuildText(wanted, chosen, approx)
    local lines, rough, missing = {}, {}, {}
    for name in pairs(wanted) do
        if chosen[name] then table.insert(lines, name .. "=" .. chosen[name])
        elseif approx[name] then table.insert(rough, name .. "=" .. approx[name])
        else table.insert(missing, name) end
    end
    table.sort(lines); table.sort(rough); table.sort(missing)
    if #rough > 0 then
        table.insert(lines, "# à vérifier (nom sans la précision entre parenthèses) :")
        for _, l in ipairs(rough) do table.insert(lines, l) end
    end
    for _, name in ipairs(missing) do table.insert(lines, "# introuvable : " .. name) end
    return table.concat(lines, "\n")
end

-- ── Fenêtre de choix entre plusieurs sorts du même nom ───────────────────
local pickFrame
local ICON, ROW_H, NAME_W = 26, 34, 170
local function ShowPicker(list, wanted, chosen, approx)
    local f = pickFrame
    if not f then
        f = API.CreateWindow("ForeverCompanionPickFrame", UIParent)
        f:SetSize(560, 520); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG")
        f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        API.WindowTitle(f):SetText(FC.NAME .. " — Choisir le bon sort")
        API.CloseOnEscape(f)
        f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        f.hint:SetPoint("TOPLEFT", 14, -30); f.hint:SetWidth(530); f.hint:SetJustifyH("LEFT")
        f.hint:SetText("Plusieurs sorts portent ces noms. Survole les icônes pour lire l'info-bulle, clique sur le bon (cadre doré), puis « Générer la liste ».")
        API.AddInset(f, 8, -58, -8, 44)
        f.sf = API.CreateScrollFrame(f, "ForeverCompanionPickScroll")
        f.sf:SetPoint("TOPLEFT", 12, -62); f.sf:SetPoint("BOTTOMRIGHT", -30, 48)
        f.sc = CreateFrame("Frame", nil, f.sf)
        f.sc:SetWidth(510); f.sc:SetHeight(1)
        f.sf:SetScrollChild(f.sc)
        f.go = API.CreateMenuButton(f, 170, 24, "Générer la liste")
        f.go:SetPoint("BOTTOMRIGHT", -14, 12)
        f.rows = {}
        pickFrame = f
    end
    for _, r in ipairs(f.rows) do r:Hide() end

    for i, e in ipairs(list) do
        local row = f.rows[i]
        if not row then
            row = CreateFrame("Frame", nil, f.sc)
            row:SetSize(510, ROW_H)
            row.label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            row.label:SetPoint("LEFT", 6, 0); row.label:SetWidth(NAME_W - 8); row.label:SetJustifyH("LEFT")
            row.btns = {}
            f.rows[i] = row
        end
        row:SetPoint("TOPLEFT", f.sc, "TOPLEFT", 0, -(i - 1) * ROW_H)
        if not row.bg then row.bg = API.RowBackground(row, i) end
        row.label:SetText(e.name .. (e.talent and " |cff9d9d9d(talent)|r" or ""))
        for _, b in ipairs(row.btns) do b:Hide() end
        local function refreshSel()
            for _, b in ipairs(row.btns) do
                if b:IsShown() then
                    if chosen[e.name] == b.spellId then b.border:SetVertexColor(1, 0.82, 0); b.border:SetAlpha(1)
                    else b.border:SetVertexColor(0.4, 0.4, 0.4); b.border:SetAlpha(0.8) end
                end
            end
        end
        for j, id in ipairs(e.cands) do
            local b = row.btns[j]
            if not b then
                b = CreateFrame("Button", nil, row)
                b:SetSize(ICON, ICON)
                b.tex = b:CreateTexture(nil, "ARTWORK"); b.tex:SetAllPoints(); b.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                b.border = b:CreateTexture(nil, "OVERLAY")
                b.border:SetPoint("TOPLEFT", -3, 3); b.border:SetPoint("BOTTOMRIGHT", 3, -3)
                b.border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border"); b.border:SetBlendMode("ADD")
                b:SetScript("OnLeave", function() GameTooltip:Hide() end)
                row.btns[j] = b
            end
            b.spellId = id
            b:SetPoint("LEFT", row, "LEFT", NAME_W + (j - 1) * (ICON + 6), 0)
            b.tex:SetTexture(API.GetSpellIcon(id) or "Interface\\Icons\\INV_Misc_QuestionMark")
            b:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                if GameTooltip.SetSpellByID and pcall(GameTooltip.SetSpellByID, GameTooltip, self.spellId) then
                    GameTooltip:AddLine("ID " .. self.spellId, 0.6, 0.6, 0.6)
                else
                    GameTooltip:AddLine(e.name, 1, 0.82, 0); GameTooltip:AddLine("ID " .. self.spellId, 0.6, 0.6, 0.6)
                end
                GameTooltip:Show()
            end)
            b:SetScript("OnClick", function(self) chosen[e.name] = self.spellId; refreshSel() end)
            b:Show()
        end
        refreshSel()
        row:Show()
    end
    f.sc:SetHeight(#list * ROW_H + 4)
    f.go:SetScript("OnClick", function()
        f:Hide()
        ShowExport(BuildText(wanted, chosen, approx))
    end)
    f:Show()
    f:Raise()
end

-- ── Scan ─────────────────────────────────────────────────────────────────
local scanning = false
function FC:ScanSpellIDs(all)
    if scanning then print("|cffffd700" .. self.NAME .. "|r : scan déjà en cours…"); return end
    local wanted, count = WantedSpells(all)
    if count == 0 then
        print("|cffffd700" .. self.NAME .. "|r : tous les sorts des rotations et les talents ont déjà un ID valide. (/fc scan tout pour tout revérifier)")
        return
    end
    print("|cffffd700" .. self.NAME .. "|r : recherche de " .. count .. " nom(s) dans la base du jeu…")
    scanning = true
    -- Tables de correspondance : nom normalisé → nom du Studio
    local byNorm, byBase = {}, {}
    for name in pairs(wanted) do
        local n = Norm(name)
        byNorm[n] = name
        local base, sub = SplitParen(n)
        if base then byBase[base] = { name = name, sub = sub } end
    end
    local cands, lastIcon, approx, nextId, lastPct = {}, {}, {}, 1, 0
    local function addCand(name, id)
        local L = cands[name]; if not L then L = {}; cands[name] = L end
        if #L >= MAX_CAND then return end
        -- Rangs successifs d'un même sort (même icône, ID proches) : on garde le premier
        local icon = API.GetSpellIcon(id)
        local prev = L[#L]
        if prev and lastIcon[name] == icon and id - prev <= 25 then return end
        table.insert(L, id); lastIcon[name] = icon
    end
    local ticker = CreateFrame("Frame")
    ticker:SetScript("OnUpdate", function(selfFrame)
        local last = math.min(nextId + PER_TICK - 1, MAX_ID)
        for id = nextId, last do
            local gname = API.GetSpellName(id)
            if gname then
                local n = Norm(gname)
                local want = byNorm[n]
                if want then
                    addCand(want, id)
                else
                    -- Nom avec précision entre parenthèses : « Faerie Fire » + sous-texte « Feral »
                    local b = byBase[n]
                    if b then
                        local st = SpellSubtext(id)
                        if st and Norm(st):find(b.sub, 1, true) then addCand(b.name, id)
                        elseif not approx[b.name] then approx[b.name] = id end
                    end
                end
            end
        end
        nextId = last + 1
        local pct = math.floor(nextId * 100 / MAX_ID)
        if pct >= lastPct + 25 and pct < 100 then lastPct = pct; print("|cffffd700FC|r scan : " .. pct .. " %") end
        if nextId > MAX_ID then
            selfFrame:SetScript("OnUpdate", nil)
            scanning = false
            -- Choix par défaut : l'ID actuel s'il fait partie des candidats, sinon le premier
            local chosen, ambiguous, nFound = {}, {}, 0
            for name, w in pairs(wanted) do
                local L = cands[name]
                if L and #L > 0 then
                    nFound = nFound + 1
                    approx[name] = nil
                    chosen[name] = L[1]
                    for _, id in ipairs(L) do if id == w.current then chosen[name] = id end end
                    if #L > 1 then table.insert(ambiguous, { name = name, cands = L, talent = w.talent }) end
                end
            end
            table.sort(ambiguous, function(a, b) return a.name < b.name end)
            print("|cffffd700" .. FC.NAME .. "|r : " .. nFound .. " / " .. count .. " trouvé(s), " .. #ambiguous .. " à départager.")
            if #ambiguous > 0 then ShowPicker(ambiguous, wanted, chosen, approx)
            else ShowExport(BuildText(wanted, chosen, approx)) end
        end
    end)
end
