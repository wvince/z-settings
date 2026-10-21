-- Forever Companion — Tour.lua
-- Tour guidé de l'addon : bouton « ? » de la fenêtre BiS (à gauche de la roue dentée) et Options → About.
-- Une bulle explique chaque partie, un cadre doré pulsé entoure l'élément présenté. Les fenêtres
-- présentées sont ouvertes par le tour et refermées à l'étape suivante (sauf si elles étaient
-- déjà ouvertes). Fermer la bulle (croix, Échap) termine le tour.
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local BW = 290            -- largeur de la bulle
local GAP, MARGIN = 14, 8 -- écart bulle / cible, marge au bord de l'écran
local tour = { i = 0, steps = {}, opened = {}, active = false }
local bubble
local hls = {}            -- cadres de surbrillance (un par cible)

local function Gold(s) return "|cffffd100" .. s .. "|r" end
-- Chemin dans les options (pas de flèche « → » : la police du jeu ne l'a pas)
local function Path(page) return Gold("Options > " .. page) end
local function Main() return rawget(_G, "ForeverCompanionFrame") end
local function OptFrame() return rawget(_G, "ForeverCompanionOptionsFrame") end
local function Shown(f) return type(f) == "table" and type(f.IsShown) == "function" and f:IsShown() and true or false end
local function Try(fn, ...)
    if not fn then return end
    local ok, err = pcall(fn, ...)
    if not ok and geterrorhandler then geterrorhandler()(err) end
    return ok and err
end

-- ── Fenêtres ouvertes par le tour ────────────────────────────────────────
-- get() renvoie la fenêtre, open() l'ouvre ; elle sera refermée en quittant l'étape.
local function Open(get, open)
    local w = get()
    if Shown(w) then return w end
    Try(open)
    w = get()
    if Shown(w) then table.insert(tour.opened, w) end
    return w
end
local function CloseOpened()
    for _, w in ipairs(tour.opened) do if Shown(w) then w:Hide() end end
    wipe(tour.opened)
end
local function OpenOptions(page)
    return Open(OptFrame, function() FC:OpenOptions(page) end)
end

-- ── Position des cibles (coordonnées de UIParent) ────────────────────────
local function Union(list) return { __union = list } end
local function Rect(r)
    if type(r) ~= "table" or type(r.GetRect) ~= "function" then return end
    local vis = r.IsVisible or r.IsShown
    if vis and not vis(r) then return end
    local l, b, w, h = r:GetRect()
    if not (l and b and w and h) or w <= 0 or h <= 0 then return end
    local s = (r.GetEffectiveScale and r:GetEffectiveScale() or 1) / (UIParent:GetEffectiveScale() or 1)
    return l * s, b * s, w * s, h * s
end
local function EntryRect(e)
    if type(e) == "table" and rawget(e, "__union") then
        local L, B, R, T
        for _, r in ipairs(e.__union) do
            local x, y, w, h = Rect(r)
            if x then
                L, B = math.min(L or x, x), math.min(B or y, y)
                R, T = math.max(R or x + w, x + w), math.max(T or y + h, y + h)
            end
        end
        if L then return { L, B, R - L, T - B } end
        return
    end
    local x, y, w, h = Rect(e)
    if x then return { x, y, w, h } end
end
local function List(...)   -- liste sans les nil
    local t = {}
    for i = 1, select("#", ...) do local v = select(i, ...); if v ~= nil then t[#t + 1] = v end end
    return t
end

-- Fenêtre BiS avec ses onglets (pour placer la bulle à côté, sans cacher les onglets)
local function MainArea()
    local mf = Main()
    if not mf then return end
    local t = { mf }
    for _, e in ipairs(mf.sideTabOrder or {}) do t[#t + 1] = e.tab end
    return Union(t)
end
local function TabEntry(id)
    local mf = Main()
    for _, e in ipairs((mf and mf.sideTabOrder) or {}) do if e.id == id then return e end end
end

-- ── Surbrillance ─────────────────────────────────────────────────────────
local function Highlight(i)
    if hls[i] then return hls[i] end
    local h = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    h:SetFrameStrata("FULLSCREEN_DIALOG")
    h:SetFrameLevel(2)
    h:EnableMouse(false)
    if h.SetBackdrop then
        h:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 } })
        h:SetBackdropBorderColor(1, 0.82, 0, 1)
    end
    local fill = h:CreateTexture(nil, "BACKGROUND")
    fill:SetPoint("TOPLEFT", 4, -4); fill:SetPoint("BOTTOMRIGHT", -4, 4)
    fill:SetColorTexture(1, 0.82, 0, 0.07)
    local ag = h:CreateAnimationGroup()
    if ag then
        ag:SetLooping("BOUNCE")
        local a = ag:CreateAnimation("Alpha")
        if a then a:SetFromAlpha(1); a:SetToAlpha(0.35); a:SetDuration(0.7); a:SetSmoothing("IN_OUT") end
        h.pulse = ag
    end
    h:Hide()
    hls[i] = h
    return h
end

-- ── Placement de la bulle ────────────────────────────────────────────────
-- r = cible principale, near = zone à ne pas couvrir (fenêtre BiS), prefer = ordre des côtés
local SIDES = { "right", "left", "below", "above" }
local function PlaceBubble(f, r, near, prefer)
    f:ClearAllPoints()
    local area = near or r
    if not area then f:SetPoint("CENTER", UIParent, "CENTER", 0, 40); return "center" end
    r = r or area
    local W, H = UIParent:GetWidth(), UIParent:GetHeight()
    local bw, bh = f:GetWidth(), f:GetHeight()
    local l, b, w, h = area[1], area[2], area[3], area[4]
    local room = { right = W - (l + w), left = l, below = b, above = H - (b + h) }
    local need = { right = bw + GAP + MARGIN, left = bw + GAP + MARGIN, below = bh + GAP + MARGIN, above = bh + GAP + MARGIN }
    local side
    for _, s in ipairs(prefer or SIDES) do if room[s] >= need[s] then side = s; break end end
    if not side then   -- pas assez de place : le côté le plus libre (la bulle chevauche un peu la cible)
        side = "right"
        for _, s in ipairs(SIDES) do if room[s] - need[s] > room[side] - need[side] then side = s end end
    end
    local x, top
    if side == "right" then x, top = l + w + GAP, r[2] + r[4]
    elseif side == "left" then x, top = l - GAP - bw, r[2] + r[4]
    elseif side == "below" then x, top = r[1] + (r[3] - bw) / 2, b - GAP
    else x, top = r[1] + (r[3] - bw) / 2, b + h + GAP + bh end
    x = math.max(MARGIN, math.min(x, W - bw - MARGIN))
    top = math.max(bh + MARGIN, math.min(top, H - MARGIN))
    f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, top)
    return side
end

local function Place(force)
    local s = tour.steps[tour.i]
    if not s or not bubble then return end
    local rects = {}
    for _, e in ipairs(Try(s.targets) or {}) do
        local r = EntryRect(e)
        if r then rects[#rects + 1] = r end
    end
    local near = s.near and EntryRect(Try(s.near)) or nil
    local key = {}
    for _, r in ipairs(rects) do key[#key + 1] = string.format("%.0f,%.0f,%.0f,%.0f", r[1], r[2], r[3], r[4]) end
    if near then key[#key + 1] = string.format("n%.0f,%.0f,%.0f,%.0f", near[1], near[2], near[3], near[4]) end
    key = table.concat(key, ";")
    if not force and key == tour.key then return end
    tour.key = key
    for i, r in ipairs(rects) do
        local h = Highlight(i)
        h:ClearAllPoints()
        h:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", r[1] - 6, r[2] - 6)
        h:SetSize(r[3] + 12, r[4] + 12)
        h:Show()
        if h.pulse and not h.pulse:IsPlaying() then h.pulse:Play() end
    end
    for i = #rects + 1, #hls do hls[i]:Hide() end
    if force or not bubble.userMoved then
        bubble.side = PlaceBubble(bubble, rects[1], near, s.prefer)
    end
end
FC.TourInternals = { PlaceBubble = PlaceBubble, Place = Place, state = tour, highlights = hls }   -- tests

-- ── Bulle ────────────────────────────────────────────────────────────────
local function Bubble()
    if bubble then return bubble end
    local f = API.CreateWindow("ForeverCompanionTourFrame", UIParent, BW, 160)
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:SetFrameLevel(20)
    f:SetClampedToScreen(true)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self.userMoved = true; self:StartMoving() end)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    API.CloseOnEscape(f)
    f.title = API.WindowTitle(f)
    f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.text:SetPoint("TOPLEFT", 16, -34)
    f.text:SetWidth(BW - 32); f.text:SetJustifyH("LEFT")
    if f.text.SetSpacing then f.text:SetSpacing(2) end
    f.back = API.CreateMenuButton(f, 80, 22, "Back")
    f.back:SetPoint("BOTTOMLEFT", 12, 12)
    f.back:SetScript("OnClick", function() FC:TourGo(tour.i - 1) end)
    f.next = API.CreateMenuButton(f, 80, 22, "Next")
    f.next:SetPoint("BOTTOMRIGHT", -12, 12)
    f.next:SetScript("OnClick", function()
        if tour.i >= #tour.steps then FC:EndTour() else FC:TourGo(tour.i + 1) end
    end)
    f.count = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    f.count:SetPoint("BOTTOM", 0, 18)
    f:SetScript("OnHide", function() if tour.active then FC:EndTour() end end)
    f:SetScript("OnUpdate", function(self, elapsed)   -- suit la cible si sa fenêtre est déplacée
        self.wait = (self.wait or 0) + (elapsed or 0)
        if self.wait < 0.15 then return end
        self.wait = 0
        Place(false)
        -- Étape qui suit ce que fait le joueur (grimoire ouvert…) : texte mis à jour
        local s = tour.steps[tour.i]
        if s and s.live and type(s.text) == "function" and (Try(s.text) or "") ~= self.text:GetText() then FC:TourGo(tour.i) end
    end)
    f:Hide()
    bubble = f
    return f
end

local function Render()
    local s = tour.steps[tour.i]
    local f = Bubble()
    f.title:SetText(s.title)
    local text = type(s.text) == "function" and (Try(s.text) or "") or s.text
    f.text:SetText(text)
    f.count:SetText(tour.i .. " / " .. #tour.steps)
    f.back:SetEnabled(tour.i > 1)
    f.next:SetText(tour.i >= #tour.steps and "Finish" or "Next")
    local th = f.text:GetStringHeight()
    f:SetHeight(34 + ((type(th) == "number" and th > 0) and th or 60) + 52)
    f.userMoved = nil
    tour.key = nil
    Place(true)
end

-- ── Étapes ───────────────────────────────────────────────────────────────
local TAB_TEXT = {
    consumables = "Flasks, elixirs, food and the other consumables recommended for the selected spec.",
    talents     = "The recommended talent build of the selected spec, shown on the talent trees. Some specs have several builds.",
    stats       = "The stat caps that matter for the selected spec (hit, defense…), with your current values.",
    rotation    = "The rotation of the selected spec: what to cast, step by step.",
    loot        = "Every dungeon, its bosses and their loot. Search an item by name, show only the BiS items of your spec, and dim what your class can't use.",
    professions = "The recipes of each profession by skill level, with their reagents and where to learn them, a leveling guide and the gathering nodes. With Auction House prices, the Profit view shows what is worth crafting.",
    market      = "Auction House prices seen during your searches and scans, their history (price and number on sale each day), your sales and purchases, and the gold of your characters.",
}

local function BuildSteps()
    local steps = {}
    local function add(s) steps[#steps + 1] = s end
    local mf = Main()

    add({ title = "Welcome!", targets = function() return { MainArea() } end,
        text = "This short tour shows where everything is in " .. FC.NAME .. ".\n\nUse " .. Gold("Next") .. " and "
            .. Gold("Back") .. ", or close this bubble to stop at any time. You can take the tour again with the "
            .. Gold("?") .. " button of this window, or from " .. Path("About") .. "." })

    add({ title = "Class, spec and phase",
        targets = function() local m = Main(); return { m and m.tourDropdowns and Union(m.tourDropdowns) } end,
        near = MainArea,
        text = "Choose a class, a specialization and a phase. The window opens on your own spec, detected from your talents. "
            .. "The emblem next to the phase shows the list for the other faction.\n\n"
            .. "The tabs on the right of the window follow this choice; right-click a tab for its options." })

    add({ title = "Best in slot items",
        targets = function() local m = Main(); return List(m and m.tourList) end,
        near = MainArea,
        text = "For each slot, the best items from left to right: " .. Gold("Top 1") .. " is the best, the next ones are good alternatives. "
            .. "A green border means you already wear it.\n\nHover an item to see where it comes from. Click it to pin its tooltip, Shift-click to link it in chat." })

    local tipBtn
    add({ title = "Item tooltips",
        setup = function()
            local m = Main()
            tipBtn = m and m.tourFirstItem and m.tourFirstItem()
            local enter = tipBtn and tipBtn:GetScript("OnEnter")
            if enter then enter(tipBtn) end
        end,
        cleanup = function()
            if tipBtn and GameTooltip:GetOwner() == tipBtn then GameTooltip:Hide() end
            tipBtn = nil
        end,
        targets = function() return List(tipBtn, (tipBtn and GameTooltip:GetOwner() == tipBtn and GameTooltip:IsShown()) and GameTooltip or nil) end,
        near = MainArea, prefer = { "left", "right", "below", "above" },   -- l'infobulle s'ouvre à droite de l'objet
        text = "Every item tooltip (here, in your bags, at vendors, in loot) tells which specs the item is BiS for, its rank, where it drops, "
            .. "its score with your gear scale compared to what you wear, and how many your characters have. Hold " .. Gold("Alt") .. " to see all the specs and all your characters.\n\nChoose what is shown in " .. Path("Item tooltips") .. "." })

    add({ title = "Quick setup",
        setup = function() Open(function() return rawget(_G, "ForeverCompanionQuickSetup") end, function() FC:ShowQuickSetup() end) end,
        targets = function() local m = Main(); return List(rawget(_G, "ForeverCompanionQuickSetup"), m and m.quickBtn) end,
        text = "The check mark button opens the quick setup: turn each feature on or off in one click "
            .. "(herbs and ore on the maps, item scores, trainer spells, Auction House…).\n\n"
            .. "Your detailed settings are kept for when you turn a feature back on." })

    add({ title = "Options",
        setup = function() OpenOptions("general") end,
        targets = function() local m = Main(); return List(OptFrame(), m and m.optionsBtn) end,
        text = "The gear button opens the options (also: right-click the minimap button, or type " .. Gold("/fc config") .. ").\n\n"
            .. "One page per topic on the left: tooltips, gear scales, tabs and features, items and loot, professions, Auction House…" })

    add({ title = "Tabs & features",
        setup = function() OpenOptions("tabs") end,
        targets = function() return List(OptFrame()) end,
        text = "The quick way to choose what the addon shows: uncheck a tab to hide it from the BiS window, or a feature to turn it off completely.\n\n"
            .. "• " .. Gold("Gathering locations") .. ": plants and veins on the maps.\n"
            .. "• " .. Gold("Gear scales") .. ": item score, green arrows and BiS stars.\n"
            .. "• " .. Gold("Items on my characters") .. ": how many you have, in item tooltips.\n"
            .. "• " .. Gold("Trainer spells") .. ": the list next to your spellbook.\n\n"
            .. "Check it again to bring it back, with all its settings." })

    -- Un onglet par fenêtre, dans l'ordre affiché
    local tabs = (mf and mf.sideTabOrder) or {}
    for k, e in ipairs(tabs) do
        local id = e.id
        local intro = (k == 1) and "The tabs on the right of the BiS window open the other windows.\n\n" or ""
        local outro = (k == #tabs) and ("\n\nHide the tabs you don't use in " .. Path("Tabs & features") .. ".") or ""
        add({ title = e.label or id,
            setup = function()
                local t = TabEntry(id)
                if not t then return end
                Open(function() return t.window and t.window() end, function()
                    local click = t.tab:GetScript("OnClick")
                    if click then click(t.tab, "LeftButton") end
                end)
            end,
            targets = function()
                local t = TabEntry(id)
                if not t then return {} end
                return List(t.window and t.window(), t.tab)
            end,
            text = intro .. (TAB_TEXT[id] or "") .. outro })
    end

    add({ title = "Upgrade arrows and stars",
        setup = function()
            if FC.ShowScalePreview then Open(function() return rawget(_G, "ForeverCompanionScalePreview") end, function() FC:ShowScalePreview() end) end
        end,
        targets = function() return List(rawget(_G, "ForeverCompanionScalePreview")) end,
        text = "On quest rewards and group loot rolls, a " .. Gold("green arrow") .. " marks an item better than what you wear. "
            .. "A " .. Gold("gold star") .. " marks the best item of your BiS list, a grey star a good alternative.\n\n"
            .. "This window shows them on your bags and your BiS list." })

    add({ title = "Gear scales",
        setup = function() OpenOptions("scales") end,
        targets = function() return List(OptFrame()) end,
        text = "An item's score is the sum of its stats multiplied by their weights. The scale is picked from your talents; "
            .. "you can choose another one, copy it to change its weights, or import a scale shared as text." })

    add({ title = "Gathering",
        setup = function() OpenOptions("professions") end,
        targets = function() return List(OptFrame()) end,
        text = "Herbs and ore veins are shown on the world map (and on the minimap if you turn it on in " .. Gold("Quick setup") .. "), dimmed in red when your skill is too low. "
            .. "The ones you gather where nothing was known are added.\n\nHere: the detection ring on the minimap, and key bindings to show or hide the icons." })

    -- Le tour n'ouvre pas le grimoire lui-même (une fenêtre du jeu ouverte par un addon peut bloquer des actions) :
    -- il attend que le joueur l'ouvre, puis montre l'onglet, puis la liste.
    local function TrainParts()
        if not FC.TrainingTourTargets then return end
        local p, l = FC.TrainingTourTargets()
        return Shown(p) and p or nil, Shown(l) and l or nil
    end
    add({ title = "Trainer spells", live = true,
        targets = function() local p, l = TrainParts(); return List(p or l) end,
        text = function()
            if FC.db.global.training_enabled == false then
                return "The list of the spells to learn at your class trainer is turned off. Turn it on again in " .. Path("Tabs & features") .. "."
            end
            local p, l = TrainParts()
            if p then
                return "The spells to learn at your class trainer, with their level and cost: available now, next two levels, later. "
                    .. "Warlocks also see the grimoires of the demon trainer.\n\n"
                    .. "Right-click a spell to ignore it, Shift-click to link it in chat. Opening your class trainer (or the demon trainer) updates the levels and prices."
            elseif l then
                return "Click the highlighted tab on the edge of your spellbook: it opens the list of the spells to learn at your class trainer. "
                    .. "The number on it is how many you can learn now."
            end
            local key = GetBindingKey and GetBindingKey("TOGGLESPELLBOOK")
            key = key and ((GetBindingText and GetBindingText(key)) or key) or "P"
            return "Open your spellbook (" .. Gold(key) .. "): a tab on its edge opens the list of the spells to learn at your class trainer.\n\n"
                .. "This bubble follows you as soon as the spellbook is open."
        end })

    add({ title = "Minimap button",
        targets = function()
            local b = rawget(_G, "LibDBIcon10_ForeverCompanion")
            return List(Shown(b) and b or nil)
        end,
        text = function()
            if Shown(rawget(_G, "LibDBIcon10_ForeverCompanion")) then
                return Gold("Left-click") .. ": BiS window.\n" .. Gold("Right-click") .. ": options.\n\nYou can hide it in " .. Path("General") .. "."
            end
            return "The minimap button is hidden: show it again in " .. Path("General") .. ".\n\nType "
                .. Gold("/fc") .. " for the BiS window and " .. Gold("/fc config") .. " for the options."
        end })

    add({ title = "That's all!", targets = function() return { MainArea() } end,
        text = "Type " .. Gold("/fc") .. " to open this window and " .. Gold("/fc config") .. " for the options. "
            .. "All chat commands are listed in " .. Path("About") .. ".\n\nHave fun!" })
    return steps
end

-- ── Navigation ───────────────────────────────────────────────────────────
function FC:TourGo(i)
    if not tour.active then return end
    i = math.max(1, math.min(i, #tour.steps))
    local old = tour.steps[tour.i]
    if old then Try(old.cleanup) end
    CloseOpened()
    tour.i = i
    Try(tour.steps[i].setup)
    Render()
end

local CloseHint   -- bulle « New here? » (plus bas)
function FC:StartTour()
    if tour.active then self:EndTour() end
    if CloseHint then CloseHint() end
    local opt = OptFrame()
    tour.optPage = self.db and self.db.char.options_page
    if Shown(opt) then opt:Hide() end   -- elle cacherait la fenêtre BiS
    if not Shown(Main()) and self.ToggleBislist then self:ToggleBislist() end
    -- Bulle créée (et cachée) AVANT d'activer le tour : sa création appelle Hide, donc OnHide,
    -- qui terminait le tour aussitôt (le premier clic sur « ? » ne faisait rien)
    local f = Bubble()
    tour.steps = BuildSteps()
    tour.active = true
    f:Show()
    self:TourGo(1)
end

function FC:EndTour()
    if not tour.active then return end
    tour.active = false
    local s = tour.steps[tour.i]
    if s then Try(s.cleanup) end
    CloseOpened()
    for _, h in ipairs(hls) do h:Hide() end
    if bubble and bubble:IsShown() then bubble:Hide() end
    tour.i = 0
    if self.db then
        self.db.global.tour_done = true
        if tour.optPage then self.db.char.options_page = tour.optPage end   -- dernière page des options vue avant le tour
    end
end

function FC:TourActive() return tour.active end

-- Bouton « ? » (barre de titre, à gauche du bouton donné)
function FC:AddTourButton(parent, leftOf)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(20, 20)
    if type(leftOf) == "table" then
        b:SetPoint("RIGHT", leftOf, "LEFT", -2, 0)
        b:SetFrameLevel(leftOf:GetFrameLevel())
    else
        b:SetPoint("TOPRIGHT", -54, -4)
    end
    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    b.text:SetPoint("CENTER", 0, 0)
    b.text:SetText("?")
    b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
    b:SetScript("OnMouseDown", function(self) self.text:SetPoint("CENTER", 1, -1) end)
    b:SetScript("OnMouseUp", function(self) self.text:SetPoint("CENTER", 0, 0) end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Tour", 1, 0.82, 0)
        GameTooltip:AddLine("A quick guided tour of the windows and options.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:SetScript("OnClick", function() FC:StartTour() end)
    -- Liseré doré pulsé autour du « ? » pendant que la bulle « New here? » est ouverte
    local glow = CreateFrame("Frame", nil, b, "BackdropTemplate")
    glow:SetPoint("TOPLEFT", -6, 6); glow:SetPoint("BOTTOMRIGHT", 6, -6)
    glow:EnableMouse(false)
    if glow.SetBackdrop then
        glow:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12 })
        glow:SetBackdropBorderColor(1, 0.82, 0, 1)
    end
    local ag = glow:CreateAnimationGroup()
    if ag then
        ag:SetLooping("BOUNCE")
        local a = ag:CreateAnimation("Alpha")
        if a then a:SetFromAlpha(1); a:SetToAlpha(0.3); a:SetDuration(0.6) end
        glow.pulse = ag
    end
    glow:Hide()
    b.glow = glow
    return b
end

-- Fenêtre BiS ouverte (Bislist.lua) : d'abord « What's new » après une mise à jour (News.lua) ;
-- la bulle du tour attend qu'elle soit refermée, pour ne pas ouvrir deux choses à la fois
function FC:ShowTourHintIfOpen()
    local mf = Main()
    if mf and mf:IsShown() and mf.helpBtn then self:ShowTourHint(mf.helpBtn) end
end
function FC:OnBislistShown()
    if self.NewsAutoShow and self.NewsAutoShow() then return end
    self:ShowTourHintIfOpen()
end

-- ── Bulle « New here? » : signale le tour, une seule fois ─────────────────
-- Sous le bouton « ? » de la fenêtre BiS, à la première ouverture (sauf si le tour a déjà été fait).
local hint
CloseHint = function() if hint and hint:IsShown() then hint:Hide() end end
function FC:ShowTourHint(btn)
    local g = self.db and self.db.global
    if not g or g.tour_done or g.tour_hint or tour.active then return end
    if type(btn) ~= "table" or not btn:IsVisible() then return end
    g.tour_hint = true   -- une seule fois, même si on ferme la fenêtre sans répondre
    local parent = btn:GetParent()
    if not hint then
        local f = API.CreateWindow("ForeverCompanionTourHint", parent, 250, 120)
        f:SetClampedToScreen(true)
        API.WindowTitle(f):SetText("New here?")
        f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        f.text:SetPoint("TOPLEFT", 14, -32); f.text:SetWidth(222); f.text:SetJustifyH("LEFT")
        f.text:SetText("Take a quick tour of the windows and options. You can start it anytime with the " .. Gold("?") .. " button.")
        f.go = API.CreateMenuButton(f, 110, 22, "Take the tour")
        f.go:SetPoint("BOTTOMLEFT", 12, 12)
        f.go:SetScript("OnClick", function() FC:StartTour() end)
        f.no = API.CreateMenuButton(f, 100, 22, "No thanks")
        f.no:SetPoint("BOTTOMRIGHT", -12, 12)
        f.no:SetScript("OnClick", function() f:Hide() end)
        f:SetScript("OnHide", function(self) if self.btn and self.btn.glow then self.btn.glow:Hide() end end)
        f:Hide()
        hint = f
    end
    hint:SetParent(parent)   -- la fenêtre BiS peut avoir été reconstruite
    hint:SetFrameStrata("DIALOG")
    hint.btn = btn
    local th = hint.text:GetStringHeight()
    hint:SetHeight(32 + ((type(th) == "number" and th > 0) and th or 30) + 46)
    hint:ClearAllPoints()
    hint:SetPoint("TOPRIGHT", btn, "BOTTOMRIGHT", 24, -6)
    hint:Show(); hint:Raise()
    if btn.glow then
        btn.glow:Show()
        if btn.glow.pulse then btn.glow.pulse:Play() end
    end
end
