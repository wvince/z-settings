-- Forever Companion — Options.lua
-- Fenêtre d'options au style de l'addon : catégories à gauche, réglages à droite.
-- Ouverte par la roue dentée de la fenêtre BiS, le clic droit sur le bouton de la
-- minicarte, /fc config, et le bouton du panneau Échap → Options → AddOns.
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local W, H = 700, 560
local LIST_W = 170          -- largeur de la colonne des catégories
local HEAD_H = 56           -- hauteur de l'en-tête de page (icône, titre, description)
local PAGE_W = W - LIST_W - 64
local optFrame

-- ── Petits éléments de formulaire ────────────────────────────────────────
-- page.y = position de la prochaine ligne ; les éléments qui lisent un réglage
-- sont ajoutés à page.controls et ont :Refresh().
local function Tooltip(frame, title, desc)
    if not desc then return end
    frame:HookScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(title, 1, 0.82, 0)
        GameTooltip:AddLine(desc, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    frame:HookScript("OnLeave", function() GameTooltip:Hide() end)
end

-- Bandeau de section (comme les en-têtes des Statistiques)
local function Section(page, text)
    if page.y > 4 then page.y = page.y + 6 end
    local h = CreateFrame("Frame", nil, page.content)
    h:SetHeight(22)
    h:SetPoint("TOPLEFT", 0, -page.y); h:SetPoint("RIGHT", page.content, "RIGHT", 0, 0)
    h:SetFrameLevel(page.content:GetFrameLevel())
    API.StripedBackground(h, "header")
    h.text = h:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    h.text:SetPoint("LEFT", 8, 0); h.text:SetText(text)
    page.y = page.y + 28
    return h
end

-- Mention à droite d'un bandeau de section, visible quand une fonction est coupée (Tabs & features)
local function OffNote(page, header, isOff)
    local fs = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fs:SetPoint("RIGHT", -8, 0)
    fs:SetText("|cffff8c33Turned off in Tabs & features|r")
    table.insert(page.controls, { Refresh = function() if isOff() then fs:Show() else fs:Hide() end end })
    return fs
end
local function GatherOn() return FC.db.global.gather_enabled ~= false end
local function ScalesOn() return FC.db.global.scales_enabled ~= false end

local function Text(page, text, indent)
    local fs = page.content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    fs:SetPoint("TOPLEFT", 10 + (indent or 0), -page.y)
    fs:SetWidth(page.width - 20 - (indent or 0)); fs:SetJustifyH("LEFT")
    fs:SetText(text)
    page.y = page.y + (fs:GetStringHeight() or 12) + 8
    return fs
end

-- Case à cocher. o = { desc, x, inline, small, width, icon }
--  x : décalage horizontal ; inline : ne pas passer à la ligne ;
--  width : largeur maximale (le texte est tronqué, jamais chevauché) ;
--  icon : petite icône entre la case et le texte. Le texte est cliquable.
local function Check(page, label, get, set, o)
    o = o or {}
    local cb = CreateFrame("CheckButton", nil, page.content, "UICheckButtonTemplate")
    cb:SetSize(24, 24)
    cb:SetPoint("TOPLEFT", 6 + (o.x or 0), -page.y)
    local anchor, gap = cb, 2
    if o.icon then
        cb.icon = cb:CreateTexture(nil, "ARTWORK")
        cb.icon:SetSize(18, 18); cb.icon:SetPoint("LEFT", cb, "RIGHT", 2, 0)
        cb.icon:SetTexture(API.IconPath(o.icon)); cb.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        anchor, gap = cb.icon, 6
    end
    cb.label = cb:CreateFontString(nil, "OVERLAY", o.small and "GameFontHighlightSmall" or "GameFontHighlight")
    cb.label:SetPoint("LEFT", anchor, "RIGHT", gap, 1)
    cb.label:SetJustifyH("LEFT")
    cb.label:SetText(label)
    local textW
    if o.width then
        textW = o.width - 26 - (o.icon and 26 or 0)
        cb.label:SetWidth(textW); cb.label:SetWordWrap(false)
    else
        textW = cb.label:GetStringWidth() or 100
    end
    cb:SetHitRectInsets(0, -(textW + (o.icon and 26 or 4)), 0, 0)   -- le texte coche aussi la case
    cb:SetScript("OnClick", function(self)
        set(self:GetChecked() and true or false)
        page:RefreshAll()
    end)
    function cb:Refresh()
        self:SetChecked(get() and true or false)
        if o.enabledIf then   -- réglage qui dépend d'un autre : grisé quand l'autre est coupé
            local on = o.enabledIf() and true or false
            self:SetEnabled(on)
            if on then self.label:SetTextColor(1, 1, 1) else self.label:SetTextColor(0.5, 0.5, 0.5) end
        end
    end
    Tooltip(cb, label, o.desc)
    table.insert(page.controls, cb)
    if not o.inline then page.y = page.y + 26 end
    return cb
end

local function Dropdown(page, label, width, build, getText, desc)
    local fs = page.content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fs:SetPoint("TOPLEFT", 10, -page.y); fs:SetText(label)
    local dd = API.CreateDropdown(page.content, width, build)
    dd.frame:SetPoint("TOPLEFT", 8 + (dd.xInset or 0), -(page.y + 15))
    table.insert(page.controls, { Refresh = function() dd.SetText(getText()) end })
    Tooltip(dd.frame, label, desc)
    page.y = page.y + 50
    return dd
end

-- Bouton ; x / inline comme pour Check
local function Button(page, text, width, onClick, desc, x, inline)
    local b = API.CreateMenuButton(page.content, width, 24, text)
    b:SetPoint("TOPLEFT", 8 + (x or 0), -page.y)
    b:SetScript("OnClick", function() onClick(); page:RefreshAll() end)
    Tooltip(b, text, desc)
    if not inline then page.y = page.y + 32 end
    return b
end

-- Raccourci clavier (actions de Bindings.xml) : clic gauche puis une touche (avec Maj, Ctrl ou Alt) ;
-- clic droit : retirer ; Échap : annuler. Enregistré dans les raccourcis du jeu (mêmes que Échap → Raccourcis).
local function KeyText(action)
    local k = GetBindingKey and GetBindingKey(action)
    if not k then return "|cff9d9d9dNot bound|r" end
    return (GetBindingText and GetBindingText(k)) or k
end
local function KeyBind(page, label, action)
    local fs = page.content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fs:SetPoint("TOPLEFT", 12, -(page.y + 6)); fs:SetText(label)
    local b = API.CreateMenuButton(page.content, 150, 24)
    b:SetPoint("TOPLEFT", page.width - 168, -page.y)
    if b.RegisterForClicks then b:RegisterForClicks("LeftButtonUp", "RightButtonUp") end
    local function unbind()
        for _, k in ipairs({ GetBindingKey(action) }) do SetBinding(k) end
    end
    local function stop()
        b.waiting = nil
        b:EnableKeyboard(false)
        b:SetScript("OnKeyDown", nil)
        b:SetText(KeyText(action))
    end
    local function save() SaveBindings(GetCurrentBindingSet and GetCurrentBindingSet() or 1) end
    b:SetScript("OnHide", function() if b.waiting then stop() end end)
    b:SetScript("OnClick", function(self, button)
        if InCombatLockdown and InCombatLockdown() then
            print("|cffffd700" .. FC.NAME .. "|r : key bindings can't be changed in combat.")
            return
        end
        if button == "RightButton" then unbind(); save(); stop(); return end
        if self.waiting then stop(); return end
        self.waiting = true
        self:SetText("|cffffd100Press a key…|r")
        self:EnableKeyboard(true)
        self:SetScript("OnKeyDown", function(_, key)
            if key == "ESCAPE" then stop(); return end
            if key == "UNKNOWN" or key:find("SHIFT$") or key:find("CTRL$") or key:find("ALT$") or key:find("META$") then return end   -- touche de modification seule : attendre
            local full = (IsAltKeyDown() and "ALT-" or "") .. (IsControlKeyDown() and "CTRL-" or "") .. (IsShiftKeyDown() and "SHIFT-" or "") .. key
            local old = GetBindingAction and GetBindingAction(full)
            unbind()
            SetBinding(full, action)
            save()
            if old and old ~= "" and old ~= action then
                print("|cffffd700" .. FC.NAME .. "|r : " .. full .. " was used by « " .. (_G["BINDING_NAME_" .. old] or old) .. " » — replaced.")
            end
            stop()
        end)
    end)
    Tooltip(b, label, "Left-click, then press a key (with Shift, Ctrl or Alt if you like). Right-click: remove the key. Escape: cancel.")
    table.insert(page.controls, { Refresh = function() if not b.waiting then b:SetText(KeyText(action)) end end })
    page.y = page.y + 30
    return b
end

local function ClassHex(cn)
    local cc = FC.CLASS_COLORS[cn] or { r = 1, g = 1, b = 1 }
    return string.format("|cff%02x%02x%02x", cc.r * 255, cc.g * 255, cc.b * 255)
end

local function RefreshLoot(resetScroll)
    local lf = _G.ForeverCompanionLootFrame
    if lf and lf.Update and lf:IsShown() then lf:Update(resetScroll) end
end

-- ── Pages ────────────────────────────────────────────────────────────────
local PAGES = {}

PAGES[#PAGES + 1] = { id = "general", name = "General", icon = "inv_misc_gear_01",
    desc = "Your specialization and the minimap button.",
    build = function(page)
    Section(page, "My specialization")
    Dropdown(page, "Specialization", 260, function()
        local _, classEn = UnitClass("player")
        local cn = FC:ClassFromToken(classEn)
        local items = { { text = FC.L.spec_auto, isSelected = function() return FC.db.char.my_spec == nil end,
            func = function() FC.db.char.my_spec = nil; FC:OnPlayerSpecChanged(true); page:RefreshAll() end } }
        for _, sn in ipairs(FC:GetSpecs(cn)) do
            table.insert(items, { text = sn, isSelected = function() return FC.db.char.my_spec == sn end,
                func = function() FC.db.char.my_spec = sn; FC:OnPlayerSpecChanged(true); page:RefreshAll() end })
        end
        return items
    end, function() return FC.db.char.my_spec or FC.L.spec_auto end,
    "Automatic: detected from your talents. If several specs share a talent tree, you are asked once which one you play.")
    Button(page, "Reset alternative spec choices", 250, function()
        wipe(FC.db.char.spec_choice); FC:OnPlayerSpecChanged(true)
    end, "Ask again which spec you play when several specs match your talent tree.")

    Section(page, "Minimap button")
    Check(page, "Show the minimap button", function() return not FC.db.global.minimap.hide end, function(v)
        FC.db.global.minimap.hide = not v
        local icon = LibStub("LibDBIcon-1.0", true)
        if icon then if v then icon:Show("ForeverCompanion") else icon:Hide("ForeverCompanion") end end
    end, { desc = "Left click: BiS window. Right click: options." })
end }

PAGES[#PAGES + 1] = { id = "tooltips", name = "Item tooltips", icon = "inv_misc_note_01",
    desc = "Which specs have an item in their BiS list, and its rank for each phase.",
    build = function(page)
    Section(page, "Phase")
    Check(page, "Highlight a phase in tooltips", function() return FC.db.char.phase_highlight_enabled end,
        function(v) FC.db.char.phase_highlight_enabled = v end)
    Dropdown(page, "Phase to highlight", 200, function()
        local items = {}
        for _, ph in ipairs(FC.PHASES) do
            table.insert(items, { text = FC:PhaseLabel(ph), isSelected = function() return FC:GetHighlightPhase() == ph end,
                func = function() FC.db.char.phase_highlight = ph; page:RefreshAll() end })
        end
        return items
    end, function() return FC:PhaseLabel(FC:GetHighlightPhase()) end)

    Section(page, "Highlighted spec")
    Check(page, "Follow my class and spec", function() return FC.db.char.auto_highlight end, function(v)
        FC.db.char.auto_highlight = v
        if v then FC:AutoDetectHighlight() end
    end, { desc = "The spec shown first and highlighted in tooltips follows your talents." })
    Dropdown(page, "Or choose a spec", 260, function()
        local items = {}
        for _, cn in ipairs(FC:GetClasses()) do
            local children = {}
            for _, sn in ipairs(FC:GetSpecs(cn)) do
                table.insert(children, { text = sn,
                    isSelected = function() return FC.db.char.highlight_class == cn and FC.db.char.highlight_spec == sn end,
                    func = function()
                        FC.db.char.highlight_class, FC.db.char.highlight_spec = cn, sn
                        FC.db.char.auto_highlight = false
                        page:RefreshAll()
                    end })
            end
            table.insert(items, { text = ClassHex(cn) .. cn .. "|r", children = children })
        end
        return items
    end, function()
        local c, s = FC.db.char.highlight_class, FC.db.char.highlight_spec
        return (c and s) and (ClassHex(c) .. c .. "|r — " .. s) or "—"
    end, "Choosing a spec here turns off \"Follow my class and spec\".")

    Section(page, "Specs shown in tooltips")
    Text(page, "Unchecked specs are hidden from tooltips. Hold ALT over an item to see them all.")
    local function setAll(v)
        for _, cn in ipairs(FC:GetClasses()) do
            FC.db.char.filter_specs[cn] = FC.db.char.filter_specs[cn] or {}
            for _, sn in ipairs(FC:GetSpecs(cn)) do FC.db.char.filter_specs[cn][sn] = v end
        end
    end
    Button(page, "Check all", 120, function() setAll(true) end, nil, 0, true)
    Button(page, "Uncheck all", 120, function() setAll(false) end, nil, 128)
    -- Une ligne par classe (fond alterné), 3 specs par ligne au maximum
    local CLASS_W = 92
    local COL_W = math.floor((page.width - CLASS_W - 8) / 3)
    for idx, cn in ipairs(FC:GetClasses()) do
        local specs = FC:GetSpecs(cn)
        local lines = math.max(1, math.ceil(#specs / 3))
        local row = CreateFrame("Frame", nil, page.content)
        row:SetPoint("TOPLEFT", 0, -page.y); row:SetPoint("RIGHT", page.content, "RIGHT", 0, 0)
        row:SetHeight(lines * 24 + 6)
        row:SetFrameLevel(page.content:GetFrameLevel())   -- sous les cases
        API.RowBackground(row, idx)
        local name = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        name:SetPoint("TOPLEFT", 10, -8); name:SetWidth(CLASS_W - 12); name:SetJustifyH("LEFT"); name:SetWordWrap(false)
        name:SetText(ClassHex(cn) .. cn .. "|r")
        local y0 = page.y
        for i, sn in ipairs(specs) do
            local col, line = (i - 1) % 3, math.floor((i - 1) / 3)
            page.y = y0 + 3 + line * 24
            Check(page, sn, function()
                local fs = FC.db.char.filter_specs[cn]
                return not (fs and fs[sn] == false)
            end, function(v)
                FC.db.char.filter_specs[cn] = FC.db.char.filter_specs[cn] or {}
                FC.db.char.filter_specs[cn][sn] = v
            end, { x = CLASS_W + col * COL_W - 6, inline = true, small = true, width = COL_W })
        end
        page.y = y0 + lines * 24 + 7
    end
end }

-- Fenêtre d'import / export d'une échelle au format Pawn
local pawnFrame
local function PawnWindow(mode, text, onDone)
    if not pawnFrame then
        local f = API.CreateWindow("ForeverCompanionPawnFrame", UIParent, 540, 260)
        f:SetPoint("CENTER", 0, 80)
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:SetClampedToScreen(true)
        f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        API.CloseOnEscape(f)
        f.title = API.WindowTitle(f)
        f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        f.hint:SetPoint("TOPLEFT", 16, -34); f.hint:SetPoint("RIGHT", f, "RIGHT", -16, 0); f.hint:SetJustifyH("LEFT")
        API.AddInset(f, 12, -66, -12, 46)
        local sf = API.CreateScrollFrame(f, nil)
        sf:SetPoint("TOPLEFT", 18, -72); sf:SetPoint("BOTTOMRIGHT", -34, 52)
        local eb = CreateFrame("EditBox", nil, sf)
        eb:SetMultiLine(true); eb:SetAutoFocus(false); eb:SetMaxLetters(0)
        eb:SetFontObject(ChatFontNormal or "ChatFontNormal")
        eb:SetWidth(470); eb:SetHeight(120)
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)
        sf:EnableMouse(true)
        sf:SetScript("OnMouseDown", function() eb:SetFocus() end)
        f.edit = eb
        f.status = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        f.status:SetPoint("BOTTOMLEFT", 18, 20); f.status:SetPoint("RIGHT", f, "RIGHT", -250, 0); f.status:SetJustifyH("LEFT")
        f.ok = API.CreateMenuButton(f, 110, 24, "Import")
        f.ok:SetPoint("BOTTOMRIGHT", -128, 14)
        f.close = API.CreateMenuButton(f, 110, 24, "Close")
        f.close:SetPoint("BOTTOMRIGHT", -12, 14)
        f.close:SetScript("OnClick", function() f:Hide() end)
        pawnFrame = f
    end
    local f = pawnFrame
    f.status:SetText("")
    if mode == "import" then
        f.title:SetText("Import a scale")
        f.hint:SetText("Paste a scale shared as text (from a guide, a friend…).\nIt is added to your own scales.")
        f.edit:SetText("")
        f.ok:Show()
        f.ok:SetScript("OnClick", function()
            local def, ignored = FC.Scales.ParsePawn(f.edit:GetText())
            if not def then f.status:SetText("|cffff5050" .. tostring(ignored) .. "|r"); return end
            local c = FC.Scales.AddCustom(def)
            local mine = not c.class or c.class == FC.Scales.PlayerToken()
            if mine then FC.db.char.scale = "my:" .. c.id end
            local msg = "scale \"" .. c.name .. "\" imported" .. (mine and "" or (" for " .. tostring(c.class):sub(1, 1) .. tostring(c.class):sub(2):lower()))
            if ignored and #ignored > 0 then msg = msg .. " (stats this addon doesn't use: " .. table.concat(ignored, ", ") .. ")" end
            print("|cffffd700" .. FC.NAME .. "|r : " .. msg)
            f:Hide()
            if onDone then onDone() end
        end)
        f.edit:SetFocus()
    else
        f.title:SetText("Export a scale")
        f.hint:SetText("Press Ctrl+C to copy it, then share it or keep it.")
        f.ok:Hide()
        f.edit:SetText(text or "")
        f.edit:SetFocus()
        f.edit:HighlightText()
    end
    f:Show(); f:Raise()
end

PAGES[#PAGES + 1] = { id = "scales", name = "Gear scales", icon = "inv_shield_06",
    desc = "Item values from stat weights, upgrade arrows and BiS stars.",
    build = function(page)
    local Sc = FC.Scales
    local G = function(k) return function() return FC.db.global[k] ~= false end end
    local function refresh()
        if FC.RefreshScaleOverlays then FC:RefreshScaleOverlays() end
        if GameTooltip and GameTooltip:IsShown() then API.RefreshTooltip(GameTooltip) end
    end
    local S = function(k) return function(v) FC.db.global[k] = v; refresh() end end
    Text(page, "|cff9d9d9dThe value of an item is the sum of its stats × the weights of your scale. Display settings and your own scales are shared by all your characters.|r")
    OffNote(page, Section(page, "Show"), function() return not ScalesOn() end)
    Check(page, "Item value in tooltips", G("scale_tooltip"), S("scale_tooltip"),
        { desc = "With your active scale, compared to the item you wear in that slot (green: better, red: worse).", enabledIf = ScalesOn })
    Check(page, "Green arrow on upgrades", G("scale_arrows"), S("scale_arrows"),
        { desc = "On quest rewards and loot rolls, when the item is better than the one you wear, for your active scale.", enabledIf = ScalesOn })
    Check(page, "Star on BiS items", G("scale_stars"), S("scale_stars"),
        { desc = "Gold: best item of your BiS list (your spec, highlighted phase). Grey: an alternative from the list.", enabledIf = ScalesOn })

    Section(page, "Active scale")
    local function label(s)
        return s.label .. (s.wowhead and "  |cff9d9d9d(default)|r" or "  |cff66ccff(mine)|r")
    end
    Dropdown(page, "Scale", 300, function()
        local items = { { text = "Automatic (from my talents)", isSelected = function() return not Sc.ByKey(FC.db.char.scale) end,
            func = function() FC.db.char.scale = nil; refresh(); page:RefreshAll() end } }
        for _, s in ipairs(Sc.ForClass()) do
            items[#items + 1] = { text = label(s), isSelected = function() return FC.db.char.scale == s.key end,
                func = function() FC.db.char.scale = s.key; refresh(); page:RefreshAll() end }
        end
        return items
    end, function()
        local s, auto = Sc.Active()
        if not s then return "No scale for this class" end
        return auto and ("Automatic: " .. s.label) or s.label
    end, "Automatic: the default scale of your main talent tree. Choose one to keep it whatever your talents.")
    local bCopy = Button(page, "Copy to edit", 120, function()
        local s = Sc.Active(); if not s then return end
        local c = Sc.Copy(s)
        FC.db.char.scale = "my:" .. c.id
        refresh()
    end, "Creates your own scale from the active one: you can then change its weights.", 0, true)
    Button(page, "Import scale…", 120, function()
        PawnWindow("import", nil, function() refresh(); page:RefreshAll() end)
    end, "Paste a scale shared as text (from a guide, a friend…).", 126, true)
    Button(page, "Export", 90, function()
        local s = Sc.Active(); if s then PawnWindow("export", Sc.Export(s)) end
    end, "Gives the active scale as text, to copy and share.", 252, true)
    local del
    del = Button(page, "Delete", 90, function()
        local s = Sc.Active()
        if not (s and s.custom) then return end
        if del.armed then
            del.armed = nil; del:SetText("Delete")
            Sc.DeleteCustom(s.custom); refresh()
        else
            del.armed = true; del:SetText("|cffff5050Sure?|r")
            C_Timer.After(4, function() if del.armed then del.armed = nil; del:SetText("Delete") end end)
        end
    end, "Deletes your scale (click twice). Default scales can't be deleted.", 348)
    table.insert(page.controls, { Refresh = function()
        local s = Sc.Active()
        if s then bCopy:Enable() else bCopy:Disable() end
        if s and s.custom then del:Enable() else del:Disable() end
    end })

    Section(page, "Weights")
    page.wInfo = Text(page, " ")
    page.wTop = page.y + 14   -- le texte peut tenir sur deux lignes
    page.wRows = {}
    local COL_W = math.floor((page.width - 8) / 2)
    local function row(i)
        local r = page.wRows[i]
        if r then return r end
        r = CreateFrame("Frame", nil, page.content)
        r:SetSize(COL_W - 6, 22)
        r.label = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        r.label:SetPoint("LEFT", 8, 0); r.label:SetJustifyH("LEFT"); r.label:SetWidth(COL_W - 90); r.label:SetWordWrap(false)
        r.value = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        r.value:SetPoint("RIGHT", -10, 0); r.value:SetJustifyH("RIGHT")
        r.edit = CreateFrame("EditBox", nil, r, "InputBoxTemplate")
        r.edit:SetSize(56, 18); r.edit:SetPoint("RIGHT", -6, 0); r.edit:SetAutoFocus(false); r.edit:SetJustifyH("RIGHT")
        local function save(self)
            if not r.custom then return end
            local txt = (self:GetText() or ""):gsub(",", ".")
            Sc.SetWeight(r.custom, r.stat, tonumber(txt))
            local v = r.custom.w[r.stat]
            self:SetText(v and Sc.FormatScore(v) or "")
            refresh()
        end
        r.edit:SetScript("OnEnterPressed", function(self) save(self); self:ClearFocus() end)
        r.edit:SetScript("OnEditFocusLost", save)
        r.edit:SetScript("OnEscapePressed", function(self)
            local v = r.custom and r.custom.w[r.stat]
            self:SetText(v and Sc.FormatScore(v) or ""); self:ClearFocus()
        end)
        API.RowBackground(r, math.floor((i - 1) / 2) + 1)
        page.wRows[i] = r
        return r
    end
    -- Nom de l'échelle personnelle
    page.nameLabel = page.content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    page.nameLabel:SetText("Name")
    page.nameEdit = CreateFrame("EditBox", nil, page.content, "InputBoxTemplate")
    page.nameEdit:SetSize(240, 20); page.nameEdit:SetAutoFocus(false)
    local function saveName(self)
        local s = Sc.Active()
        if s and s.custom then
            local n = Sc.Rename(s.custom, self:GetText())
            self:SetText(n)
            page:RefreshAll()
        end
    end
    page.nameEdit:SetScript("OnEnterPressed", function(self) saveName(self); self:ClearFocus() end)
    page.nameEdit:SetScript("OnEditFocusLost", saveName)
    function page:LayoutWeights()
        local s = Sc.Active()
        local custom = s and s.custom or nil
        local y = self.wTop
        if not s then
            self.wInfo:SetText("|cff9d9d9dNo scale for your class yet. Import one to start.|r")
        elseif custom then
            self.wInfo:SetText("Your scale: type a weight per stat (empty = 0), then Enter. 1 point = 1 % for hit, crit, dodge, parry and block; weapon speed in seconds.")
        else
            self.wInfo:SetText("|cff9d9d9dDefault scale (read only). Click \"Copy to edit\" to change its weights.|r")
        end
        if custom then
            self.nameLabel:ClearAllPoints(); self.nameLabel:SetPoint("TOPLEFT", 10, -(y + 4)); self.nameLabel:Show()
            self.nameEdit:ClearAllPoints(); self.nameEdit:SetPoint("TOPLEFT", 60, -y); self.nameEdit:Show()
            if not self.nameEdit:HasFocus() then self.nameEdit:SetText(custom.name) end
            y = y + 28
        else
            self.nameLabel:Hide(); self.nameEdit:Hide()
        end
        local list = {}
        for _, st in ipairs(Sc.STATS) do
            local v = s and s.w[st[1]]
            if custom or (v and v ~= 0) then list[#list + 1] = st end
        end
        for i, st in ipairs(list) do
            local r = row(i)
            local col, line = (i - 1) % 2, math.floor((i - 1) / 2)
            r:ClearAllPoints(); r:SetPoint("TOPLEFT", col * COL_W, -(y + line * 23))
            r.stat, r.custom = st[1], custom
            r.label:SetText(st[2])
            local v = s.w[st[1]]
            if custom then
                r.value:Hide(); r.edit:Show()
                if not r.edit:HasFocus() then r.edit:SetText(v and Sc.FormatScore(v) or "") end
            else
                r.edit:Hide(); r.value:Show()
                r.value:SetText(Sc.FormatScore(v))
            end
            r:Show()
        end
        for k = #list + 1, #self.wRows do self.wRows[k]:Hide() end
        self.content:SetHeight(y + math.ceil(#list / 2) * 23 + 16)
    end
    page.fixedHeight = true
    table.insert(page.controls, { Refresh = function() page:LayoutWeights() end })
end }

PAGES[#PAGES + 1] = { id = "tabs", name = "Tabs & features", icon = "inv_misc_book_09",
    desc = "Choose what the addon shows: tabs of the BiS window, and features.",
    build = function(page)
    Section(page, "Tabs shown")
    Text(page, "Unchecked tabs are hidden. Click a tab once to open its window, again to close it.")
    for _, t in ipairs(FC.UI_TABS) do
        local id = t.id
        Check(page, t.label or id, function() return not FC.db.char.tab_off[id] end, function(v)
            FC.db.char.tab_off[id] = (not v) or nil
            if FC.RefreshBislist then FC:RefreshBislist() end
        end, { icon = t.icon, enabledIf = id == "market" and function() return FC.db.global.ah_enabled ~= false end or nil })
        page.y = page.y + 2
    end
    -- Interrupteurs généraux : chaque fonction garde ses réglages détaillés (grisés tant qu'elle est coupée)
    Section(page, "Features")
    Text(page, "Unchecked features are turned off completely. Their detailed settings are kept for when you turn them back on.")
    Check(page, "Gathering locations", GatherOn, function(v)
        FC.db.global.gather_enabled = v
        if FC.RefreshGatherMap then FC:RefreshGatherMap() end
    end, { icon = "trade_herbalism", desc = "Plants and veins on the world map and the minimap, and the ones you gather. Detailed settings: Professions page." })
    page.y = page.y + 2
    Check(page, "Gear scales", ScalesOn, function(v)
        FC.db.global.scales_enabled = v
        if FC.RefreshScaleOverlays then FC:RefreshScaleOverlays() end
        if GameTooltip and GameTooltip:IsShown() then API.RefreshTooltip(GameTooltip) end
    end, { icon = "inv_shield_06", desc = "Item score in tooltips, green arrow on upgrades and star on BiS items. Detailed settings: Gear scales page." })
    page.y = page.y + 2
    Check(page, "Items on my characters", function() return FC.db.global.inventory_enabled ~= false end, function(v)
        FC.db.global.inventory_enabled = v
    end, { icon = "inv_misc_bag_08", desc = "In item tooltips: how many your characters have (bags, equipped, bank, mail, auctions). Detailed settings: Items & loot page." })
    page.y = page.y + 2
    Check(page, "Trainer spells", function() return FC.db.global.training_enabled ~= false end, function(v)
        FC.db.global.training_enabled = v
        if FC.RefreshTraining then FC:RefreshTraining() end
    end, { icon = "inv_misc_book_09", desc = "The spells to learn at your class trainer, in a list next to your spellbook (tab on its right edge)." })
end }

PAGES[#PAGES + 1] = { id = "items", name = "Items & loot", icon = "inv_misc_bag_10",
    desc = "Clicking items, Dungeon Loot, faction, and the items on your characters.",
    build = function(page)
    Section(page, "Clicking an item")
    Check(page, "Open its pinned tooltip", function() return FC.db.char.item_click_ref ~= false end,
        function(v) FC.db.char.item_click_ref = v end,
        { desc = "Like clicking an item link in chat. Shift-click always links the item in chat." })
    Section(page, "Dungeon Loot")
    Check(page, "Dim items my class can't use", function() return FC.db.char.loot_dim_unusable ~= false end, function(v)
        FC.db.char.loot_dim_unusable = v
        RefreshLoot(false)
    end)
    Check(page, "Show only BiS items of the selected spec", function() return FC.db.char.loot_bis_only end, function(v)
        FC.db.char.loot_bis_only = v
        RefreshLoot(true)
    end)
    Section(page, "Faction")
    Check(page, "Hide items of the other faction", function() return FC.db.global.faction_filter ~= false end, function(v)
        FC.db.global.faction_filter = v
        if FC.RefreshBislist then FC:RefreshBislist() end
        RefreshLoot(true)
        if FC.RefreshScaleOverlays then FC:RefreshScaleOverlays() end
    end, { desc = "Quest rewards, PvP and reputation items of the other faction are left out of the BiS window and the Dungeon Loot window; the next items move up a rank, and the gold BiS star goes to the best item of your faction." })
    -- Objets de mes personnages (Inventory.lua)
    local invOn = function() return FC.db.global.inventory_enabled ~= false end
    OffNote(page, Section(page, "Items on my characters"), function() return not invOn() end)
    Text(page, "|cff9d9d9dItem tooltips show how many your characters of this realm have. Bags and equipment are always up to date; the bank, the mailbox and your auctions are read when you open them.|r")
    Check(page, "Include characters of the other faction", function() return FC.db.global.inventory_cross ~= false end,
        function(v) FC.db.global.inventory_cross = v end, { enabledIf = invOn })
    local function maxText(n) return (n == 0 and "All" or tostring(n)) .. (n == 3 and " (default)" or "") end
    Dropdown(page, "Characters shown", 180, function()
        local items = {}
        for _, n in ipairs({ 1, 2, 3, 4, 5, 6, 8, 10, 0 }) do
            items[#items + 1] = { text = maxText(n), isSelected = function() return (tonumber(FC.db.global.inventory_max) or 3) == n end,
                func = function() FC.db.global.inventory_max = n; page:RefreshAll() end }
        end
        return items
    end, function() return maxText(tonumber(FC.db.global.inventory_max) or 3) end,
        "The character you are playing comes first, then those who have the most. Hold Alt to see them all.")
    Dropdown(page, "Forget a character", 200, function()
        local items = {}
        for _, c in ipairs(FC.InventoryCharacters and FC:InventoryCharacters() or {}) do
            items[#items + 1] = { text = c.name .. (c.faction and ("  |cff9d9d9d" .. c.faction .. "|r") or ""), isSelected = function() return false end,
                func = function()
                    FC:InventoryForget(c.name)
                    print("|cffffd700" .. FC.NAME .. "|r : " .. c.name .. " forgotten.")
                    page:RefreshAll()
                end }
        end
        return items
    end, function() return "Choose…" end, "Removes a deleted or renamed character from the tooltips. A character you log in with again is recorded again.")
end }

PAGES[#PAGES + 1] = { id = "professions", name = "Professions", icon = "trade_blacksmithing",
    desc = "Order of the profession tabs, and which professions are shown.",
    build = function(page)
    Section(page, "World map")
    local mapOn = function() return FC.db.global.map_gather ~= false end
    local refreshMap = function() if FC.RefreshMapLevels then FC:RefreshMapLevels() end end
    Check(page, "Show gathering skill levels under zone names", mapOn, function(v) FC.db.global.map_gather = v; refreshMap(); page:RefreshAll() end,
        { desc = "Herbalism and mining: lowest and highest skill required by the plants and veins of the zone you point at on the world map." })
    Check(page, "Also for gathering professions I don't know", function() return FC.db.global.map_gather_all == true end,
        function(v) FC.db.global.map_gather_all = v; refreshMap() end, { x = 20, enabledIf = mapOn })
    OffNote(page, Section(page, "Gathering nodes"), function() return not GatherOn() end)
    local gm = function() if FC.RefreshGatherMap then FC:RefreshGatherMap() end end
    local G = function(k) return function() return FC.db.global[k] ~= false end end
    Check(page, "Show plants and veins on the world map", G("gather_worldmap"), function(v) FC.db.global.gather_worldmap = v; gm() end,
        { desc = "Known positions, plus the ones you gather yourself. Icons are dimmed and red when your skill is too low.", enabledIf = GatherOn })
    Check(page, "Show them on the minimap", G("gather_minimap"), function(v) FC.db.global.gather_minimap = v; gm() end, { enabledIf = GatherOn })
    Check(page, "Only for gathering professions I know", G("gather_only_known"), function(v) FC.db.global.gather_only_known = v; gm() end, { enabledIf = GatherOn })
    Check(page, "Hide plants and veins my skill is too low for", function() return FC.db.global.gather_hide_low == true end,
        function(v) FC.db.global.gather_hide_low = v; gm() end, { enabledIf = GatherOn })
    Check(page, "Fade the icons near my position on the world map", G("gather_fade_player"), function(v) FC.db.global.gather_fade_player = v end,
        { desc = "Icons around your arrow become almost transparent, so you can still see where you are.", enabledIf = GatherOn })
    Check(page, "Record the plants and veins I gather", G("gather_record"), function(v) FC.db.global.gather_record = v end,
        { desc = "Adds them to the map where no position is known yet, even for unknown plants and veins.", enabledIf = GatherOn })
    local function trackText(d) return d == 0 and "Off" or (d .. " yards") end
    Dropdown(page, "Detection range on the minimap", 180, function()
        local items = {}
        for _, d in ipairs({ 0, 50, 75, 100, 125, 150 }) do
            items[#items + 1] = { text = trackText(d), isSelected = function() return (FC.db.global.gather_track_dist or 100) == d end,
                func = function() FC.db.global.gather_track_dist = d; gm(); page:RefreshAll() end }
        end
        return items
    end, function() return trackText(FC.db.global.gather_track_dist or 100) end,
        "Closer than this, the icon becomes a colored ring: the game's yellow tracking dot shows inside it if the plant or vein is really there.")
    -- Taille des icônes (carte du monde : 10 par défaut ; minicarte : 8)
    local function SizeDD(label, key, def, sizes, desc)
        local function txt(v) return v .. (v == def and " (default)" or "") end
        Dropdown(page, label, 180, function()
            local items = {}
            for _, v in ipairs(sizes) do
                items[#items + 1] = { text = txt(v), isSelected = function() return (FC.db.global[key] or def) == v end,
                    func = function() FC.db.global[key] = v; gm(); page:RefreshAll() end }
            end
            return items
        end, function() return txt(FC.db.global[key] or def) end, desc)
    end
    SizeDD("Icon size on the world map", "gather_icon_size", 10, { 6, 8, 10, 12, 14, 16, 18, 20, 24, 28 }, "Size of the plant and vein icons on the world map.")
    SizeDD("Icon size on the minimap", "gather_minimap_size", 8, { 4, 6, 8, 10, 12, 14, 16, 18, 20 }, "Size of the plant and vein icons on the minimap.")
    Section(page, "Key bindings")
    KeyBind(page, "Show / hide the icons on the world map", "FORECOMP_GATHER_WORLDMAP")
    KeyBind(page, "Show / hide the icons on the minimap", "FORECOMP_GATHER_MINIMAP")
    Section(page, "Order and visibility")
    Text(page, "Hidden professions are also left out of the search.")
    page.profTop = page.y
    page.profRows = {}
    function page:LayoutProfessions()
        local order = FC:GetProfessionOrder(true)
        local y = self.profTop
        for pos, i in ipairs(order) do
            local p = FC.Professions[i]
            local row = self.profRows[pos]
            if not row then
                row = CreateFrame("Frame", nil, self.content)
                row:SetHeight(28)
                API.RowBackground(row, pos)
                row.cb = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
                row.cb:SetSize(24, 24); row.cb:SetPoint("LEFT", 6, 0)
                row.num = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
                row.num:SetPoint("LEFT", row.cb, "RIGHT", 2, 0); row.num:SetWidth(16)
                row.icon = row:CreateTexture(nil, "ARTWORK"); row.icon:SetSize(20, 20); row.icon:SetPoint("LEFT", row.num, "RIGHT", 4, 0)
                row.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                row.name:SetPoint("LEFT", row.icon, "RIGHT", 8, 0); row.name:SetJustifyH("LEFT")
                row.down = CreateFrame("Button", nil, row, "UIPanelButtonTemplate"); row.down:SetSize(58, 22); row.down:SetText("Down")
                row.up = CreateFrame("Button", nil, row, "UIPanelButtonTemplate"); row.up:SetSize(58, 22); row.up:SetText("Up")
                row.down:SetPoint("RIGHT", -8, 0); row.up:SetPoint("RIGHT", row.down, "LEFT", -4, 0)
                row.name:SetPoint("RIGHT", row.up, "LEFT", -8, 0); row.name:SetWordWrap(false)
                self.profRows[pos] = row
            end
            row:ClearAllPoints(); row:SetPoint("TOPLEFT", 0, -y); row:SetPoint("RIGHT", self.content, "RIGHT", 0, 0)
            row.num:SetText(pos)
            row.icon:SetTexture(API.IconPath(p.ic))
            local hidden = FC.db.char.prof_hidden[p.id]
            row.name:SetText((p.n or p.id) .. (p.g and "  |cff9d9d9d(gathering)|r" or ""))
            row.name:SetAlpha(hidden and 0.45 or 1); row.icon:SetDesaturated(hidden and true or false)
            row.cb:SetChecked(not hidden)
            row.cb:SetScript("OnClick", function(b)
                FC.db.char.prof_hidden[p.id] = (not b:GetChecked()) or nil
                FC:RefreshProfessionTabs(); self:LayoutProfessions()
            end)
            local function move(d)
                local list = FC:GetProfessionOrder(true)
                local np = pos + d
                if np < 1 or np > #list then return end
                list[pos], list[np] = list[np], list[pos]
                local ids = {}
                for _, k in ipairs(list) do table.insert(ids, FC.Professions[k].id) end
                FC.db.char.prof_order = ids
                FC:RefreshProfessionTabs(); self:LayoutProfessions()
            end
            row.up:SetScript("OnClick", function() move(-1) end)
            row.down:SetScript("OnClick", function() move(1) end)
            if pos == 1 then row.up:Disable() else row.up:Enable() end
            if pos == #order then row.down:Disable() else row.down:Enable() end
            row:Show()
            y = y + 29
        end
        for k = #order + 1, #self.profRows do self.profRows[k]:Hide() end
        self.resetBtn:ClearAllPoints(); self.resetBtn:SetPoint("TOPLEFT", 8, -(y + 10))
        self.content:SetHeight(y + 48)
    end
    page.resetBtn = API.CreateMenuButton(page.content, 170, 24, "Reset order")
    page.resetBtn:SetScript("OnClick", function()
        wipe(FC.db.char.prof_order); wipe(FC.db.char.prof_hidden)
        FC:RefreshProfessionTabs(); page:LayoutProfessions()
    end)
    Tooltip(page.resetBtn, "Reset order", "Back to the default order, all professions shown.")
    if #FC.Professions == 0 then
        Text(page, "|cff9d9d9dNo profession data.|r")
        page.resetBtn:Hide()
        return
    end
    page:LayoutProfessions()
    page.fixedHeight = true
    table.insert(page.controls, { Refresh = function() page:LayoutProfessions() end })
end }

PAGES[#PAGES + 1] = { id = "auction", name = "Auction House", icon = "inv_misc_coin_02",
    desc = "Price scans, tooltips, sales history and gold tracking.",
    build = function(page)
    local G = function(k) return function() return FC.db.global[k] ~= false end end
    local S = function(k, after) return function(v) FC.db.global[k] = v; if after then after(v) end end end
    local function refreshAH()
        if FC.Auction and FC.Auction.UpdateUI then FC.Auction.UpdateUI() end
        -- Onglet de la fenêtre BiS, fenêtre Auction House, info-bulle affichée, prix des guides
        local mfr = _G.ForeverCompanionMarketFrame
        if mfr and FC.db.global.ah_enabled == false then mfr:Hide() end
        if FC.RefreshBislist then FC:RefreshBislist() end
        if FC.RefreshProfessionPrices then FC:RefreshProfessionPrices() end
        if GameTooltip and GameTooltip:IsShown() then API.RefreshTooltip(GameTooltip) end
    end
    local on = function() return FC.db.global.ah_enabled ~= false end
    Text(page, "|cff9d9d9dThese settings are shared by all your characters.|r")
    Section(page, "Auction House")
    Check(page, "Enable Auction House features", G("ah_enabled"), S("ah_enabled", refreshAH),
        { desc = "Turns everything below on or off at once: scans, prices in tooltips and guides, the Auction House tab, sales history and gold tracking. Recorded data is kept." })
    Check(page, "Full scan automatically when I open the Auction House", G("ah_autoscan"), S("ah_autoscan"),
        { enabledIf = on, desc = "The game allows one full scan every 15 minutes. Turn this off if opening the Auction House lags; the \"Full scan\" button stays available." })
    Check(page, "Record the prices of my own searches", G("ah_passive"), S("ah_passive"),
        { enabledIf = on, desc = "Prices shown while you browse the Auction House are saved too (no extra request to the server)." })
    Section(page, "Tooltips")
    Check(page, "Show the Auction House price", G("ah_tooltip"), S("ah_tooltip"), { enabledIf = on, desc = "Lowest buyout per unit, with how long ago it was seen. Hold Shift over a stack to see the stack price." })
    Check(page, "Show the 7-day average", function() return FC.db.global.ah_tooltip_avg end, S("ah_tooltip_avg"), { enabledIf = on })
    Check(page, "Show the vendor price", function() return FC.db.global.ah_tooltip_vendor end, S("ah_tooltip_vendor"),
        { enabledIf = on, desc = "Useful if the game doesn't show it already." })
    Section(page, "History")
    Dropdown(page, "Keep price history for", 160, function()
        local items = {}
        for _, d in ipairs({ 30, 60, 90, 180, 365 }) do
            items[#items + 1] = { text = d .. " days", isSelected = function() return (FC.db.global.ah_keep_days or 60) == d end,
                func = function() FC.db.global.ah_keep_days = d; page:RefreshAll() end }
        end
        return items
    end, function() return (FC.db.global.ah_keep_days or 60) .. " days" end)
    Check(page, "Record my sales and purchases (Auction House mail)", G("ledger_track"), S("ledger_track"),
        { enabledIf = on, desc = "Read from the Auction House invoices when you open your mailbox." })
    Check(page, "Track my gold (graph)", G("gold_track"), S("gold_track"), { enabledIf = on, desc = "Each character's gold is saved when it changes." })
    Section(page, "Data")
    local info = Text(page, " ")   -- une ligne réservée (texte rempli à l'affichage)
    table.insert(page.controls, { Refresh = function()
        local n = 0
        for _ in pairs((FC.db.factionrealm.ah and FC.db.factionrealm.ah.items) or {}) do n = n + 1 end
        local last = FC.db.factionrealm.ah and FC.db.factionrealm.ah.lastFull or 0
        info:SetText(n .. " items in memory" .. (last > 0 and FC.Auction and ("  ·  last full scan " .. FC.Auction.Age(last) .. " ago") or "")
            .. "  ·  " .. #((FC.db.factionrealm.ledger and FC.db.factionrealm.ledger.list) or {}) .. " sales / purchases")
    end })
    -- Effacement en deux clics (le bouton demande confirmation pendant 4 s)
    local function Danger(text, x, inline, fn)
        local b
        b = Button(page, text, 148, function()
            if b.armed then b.armed = nil; b:SetText(text); fn()
            else
                b.armed = true; b:SetText("|cffff5050Click again|r")
                C_Timer.After(4, function() if b.armed then b.armed = nil; b:SetText(text) end end)
            end
        end, "Click twice to confirm.", x, inline)
        return b
    end
    Danger("Clear prices", 0, true, function()
        wipe(FC.db.factionrealm.ah.items); FC.db.factionrealm.ah.lastFull = 0
        if FC.RefreshMarket then FC:RefreshMarket() end
    end)
    Danger("Clear sales history", 154, true, function()
        wipe(FC.db.factionrealm.ledger.list); wipe(FC.db.factionrealm.ledger.seen)
        if FC.RefreshMarket then FC:RefreshMarket() end
    end)
    Danger("Clear gold history", 308, false, function()
        if FC.Ledger then FC.Ledger.ClearGold() end
        if FC.RefreshMarket then FC:RefreshMarket() end
    end)
end }

PAGES[#PAGES + 1] = { id = "about", name = "About", icon = "Interface\\AddOns\\ForeverCompanion\\Media\\LogoAddon.tga",
    desc = "Version, data and chat commands.",
    build = function(page)
    Section(page, "Version")
    Text(page, "Addon |cffffd100" .. tostring(FC.VERSION) .. "|r")
    Text(page, "Data |cffffd100v" .. tostring(FC.DATA_VERSION) .. "|r  " .. tostring(FC.DATA_UPDATED or ""))
    Text(page, "|cffff8c33Beta: data (BiS, rotations, talents, stat caps) may change drastically.|r")
    Button(page, "What's new", 150, function() FC:ShowNews() end, "The changes of the latest versions.", 0, true)
    Button(page, "Take the tour", 150, function() if FC.StartTour then FC:StartTour() end end,
        "A guided tour of the windows and options, step by step.", 156)
    Check(page, "Show what's new after an update", function() return FC.db.global.news_auto ~= false end,
        function(v) FC.db.global.news_auto = v end, { desc = "Opens once, the first time you open the BiS window after an update." })
    Section(page, "Chat commands")
    local cmds = {
        { "/fc", "BiS window" },
        { "/fc rotation", "Rotation" },
        { "/fc conso", "Consumables" },
        { "/fc talents", "BiS talents" },
        { "/fc loot", "Dungeon loot" },
        { "/fc prof", "Professions" },
        { "/fc ah", "Auction House: prices, sales, gold" },
        { "/fc spec", "Choose your specialization" },
        { "/fc config", "This window" },
        { "/fc tour", "Guided tour of the addon" },
    }
    for i, c in ipairs(cmds) do
        local row = CreateFrame("Frame", nil, page.content)
        row:SetPoint("TOPLEFT", 0, -page.y); row:SetPoint("RIGHT", page.content, "RIGHT", 0, 0)
        row:SetHeight(20)
        API.RowBackground(row, i)
        local a = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        a:SetPoint("LEFT", 10, 0); a:SetText(c[1])
        local b = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        b:SetPoint("LEFT", 150, 0); b:SetText(c[2])
        page.y = page.y + 21
    end
end }

-- ── Fenêtre ──────────────────────────────────────────────────────────────
local function Build()
    local C = API.COLORS
    local f = API.CreateWindow("ForeverCompanionOptionsFrame", UIParent, W, H)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    API.CloseOnEscape(f)
    API.WindowTitle(f):SetText(FC.NAME .. " — Options")

    -- Catégories à gauche
    API.AddInset(f, 8, -30, -(W - LIST_W - 8), 8)
    f.catBtns = {}
    for i, pg in ipairs(PAGES) do
        local b = CreateFrame("Button", nil, f)
        b:SetSize(LIST_W - 12, 32)
        b:SetPoint("TOPLEFT", 14, -36 - (i - 1) * 33)
        API.RowBackground(b, i)
        b.selL, b.selR = API.StripedBackground(b, "header", "BORDER")
        b.accent = b:CreateTexture(nil, "OVERLAY")
        b.accent:SetPoint("TOPLEFT"); b.accent:SetPoint("BOTTOMLEFT"); b.accent:SetWidth(2)
        b.accent:SetColorTexture(1, 0.82, 0, 0.9)
        b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetSize(22, 22); b.icon:SetPoint("LEFT", 8, 0)
        b.icon:SetTexture(API.IconPath(pg.icon))
        if not pg.icon:find("[\\/]") then b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) end
        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.text:SetPoint("LEFT", b.icon, "RIGHT", 8, 0); b.text:SetPoint("RIGHT", -4, 0)
        b.text:SetJustifyH("LEFT"); b.text:SetWordWrap(false)
        b.text:SetText(pg.name)
        b:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
        local hl = b:GetHighlightTexture(); if type(hl) == "table" then hl:SetAlpha(0.35) end
        b:SetScript("OnClick", function() f:ShowPage(i) end)
        function b:SetSelected(on)
            self.selL:SetShown(on); self.selR:SetShown(on); self.accent:SetShown(on)
            if on then self.text:SetTextColor(1, 1, 1) else self.text:SetTextColor(1, 0.82, 0) end
        end
        b:SetSelected(false)
        f.catBtns[i] = b
    end
    local ver = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    ver:SetPoint("BOTTOMLEFT", 16, 16)
    ver:SetText("v" .. tostring(FC.VERSION) .. "  ·  data v" .. tostring(FC.DATA_VERSION))

    -- En-tête de page à droite : icône, titre, description, filet
    local RX = LIST_W + 14
    API.AddInset(f, RX, -30, -8, 8)
    f.headIcon = f:CreateTexture(nil, "ARTWORK")
    f.headIcon:SetSize(34, 34); f.headIcon:SetPoint("TOPLEFT", RX + 12, -40)
    f.headTitle = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    f.headTitle:SetPoint("TOPLEFT", f.headIcon, "TOPRIGHT", 10, -1)
    f.headDesc = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.headDesc:SetPoint("TOPLEFT", f.headTitle, "BOTTOMLEFT", 0, -4)
    f.headDesc:SetWidth(PAGE_W - 40); f.headDesc:SetJustifyH("LEFT"); f.headDesc:SetWordWrap(false)
    local sep = f:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", RX + 10, -30 - HEAD_H + 2); sep:SetPoint("TOPRIGHT", -18, -30 - HEAD_H + 2)
    sep:SetColorTexture(C.sep[1], C.sep[2], C.sep[3], C.sep[4] or 0.35)

    -- Pages (construites à la première ouverture)
    f.pages = {}
    function f:ShowPage(i)
        i = PAGES[i] and i or 1
        for _, p in pairs(self.pages) do
            p.sf:Hide(); if p.bar then p.bar:Hide() end; if p.fade then p.fade:Hide() end
        end
        for k, b in ipairs(self.catBtns) do b:SetSelected(k == i) end
        local def = PAGES[i]
        self.headIcon:SetTexture(API.IconPath(def.icon))
        if def.icon:find("[\\/]") then self.headIcon:SetTexCoord(0, 1, 0, 1) else self.headIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93) end
        self.headTitle:SetText(def.name)
        self.headDesc:SetText(def.desc or "")
        local page = self.pages[i]
        if not page then
            local sf, bar = API.CreateScrollFrame(self, nil)
            if type(bar) ~= "table" then bar = nil end
            sf:SetPoint("TOPLEFT", RX + 6, -30 - HEAD_H - 4)
            sf:SetPoint("BOTTOMRIGHT", -30, 12)
            local content = CreateFrame("Frame", nil, sf)
            content:SetSize(PAGE_W, 1)
            sf:SetScrollChild(content)
            page = { sf = sf, bar = bar, content = content, width = PAGE_W, y = 4, controls = {} }
            function page:RefreshAll() for _, c in ipairs(self.controls) do c:Refresh() end end
            def.build(page)
            if not page.fixedHeight then content:SetHeight(page.y + 12) end
            if API.AddBottomFade then page.fade = API.AddBottomFade(sf, 24, bar and 12 or 0) end
            self.pages[i] = page
        end
        page.sf:Show(); if page.bar then page.bar:Show() end
        page:RefreshAll()
        page.sf:SetVerticalScroll(0)
        self.current = i
        FC.db.char.options_page = def.id
    end
    f:SetScript("OnShow", function(self)
        if self.current and self.pages[self.current] then self.pages[self.current]:RefreshAll() end
    end)
    -- Un cadre est visible dès sa création : sans ce Hide, le tout premier clic sur la roue dentée
    -- (ouvrir / fermer) le refermait aussitôt, et il fallait recliquer.
    f:Hide()
    return f
end

-- FC:OpenOptions()        : ouvre / ferme (dernière catégorie vue)
-- FC:OpenOptions("loot")  : ouvre directement une catégorie (id de page)
function FC:OpenOptions(pageId)
    if not optFrame then optFrame = Build() end
    if not pageId and optFrame:IsShown() then optFrame:Hide(); return end
    local want = pageId or FC.db.char.options_page
    local start = 1
    for i, pg in ipairs(PAGES) do if pg.id == want then start = i end end
    optFrame:ShowPage(start)
    optFrame:Show()
    optFrame:Raise()
end

-- Panneau du jeu (Échap → Options → AddOns) : un bouton qui ouvre la fenêtre
function FC:RegisterOptionsPanel()
    if self.optionsPanel then return end
    local panel = CreateFrame("Frame")
    panel.name = self.NAME
    local t = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    t:SetPoint("TOPLEFT", 16, -16); t:SetText(self.NAME)
    local d = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    d:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 0, -8); d:SetText("All settings are in the addon's own options window.")
    local b = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    b:SetSize(200, 26); b:SetPoint("TOPLEFT", d, "BOTTOMLEFT", 0, -12); b:SetText("Open options")
    b:SetScript("OnClick", function()
        -- Referme le panneau du jeu (sans erreur possible) avant d'ouvrir la fenêtre de l'addon
        for _, p in ipairs({ SettingsPanel, InterfaceOptionsFrame }) do
            if p and p:IsShown() and HideUIPanel then pcall(HideUIPanel, p) end
        end
        FC:OpenOptions(FC.db.char.options_page or "general")
    end)
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local ok, cat = pcall(Settings.RegisterCanvasLayoutCategory, panel, self.NAME)
        if ok and cat then pcall(Settings.RegisterAddOnCategory, cat) end
    elseif InterfaceOptions_AddCategory then
        pcall(InterfaceOptions_AddCategory, panel)
    end
    self.optionsPanel = panel
end
