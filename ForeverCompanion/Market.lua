-- Forever Companion — Market.lua
-- Fenêtre « Auction House » : prix en mémoire (recherche + courbe), ventes et
-- achats (courrier de l'HV), et graphique de l'or des personnages du royaume.
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local W, H = 780, 560
local ROW_H = 22
local mf
local fmtDate = function(fmt, t) return (date or os.date)(fmt, t) end

local function QualityHex(q)
    local r, g, b = API.GetItemQualityColor(q or 1)
    return string.format("|cff%02x%02x%02x", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255)
end
local function ClassHex(token)
    local c = token and RAID_CLASS_COLORS and RAID_CLASS_COLORS[token]
    return c and string.format("|cff%02x%02x%02x", c.r * 255, c.g * 255, c.b * 255) or "|cffffffff"
end
local function Icon(id)
    return (id and id > 0 and API.GetItemIcon(id)) or "Interface\\Icons\\INV_Misc_QuestionMark"
end
-- Nom d'un objet : relevé de l'HV, cache du jeu, sinon « Item 123 »
local function ItemName(id, e)
    local n, _, q = nil, nil, nil
    if API.ItemIsCached(id) then n, _, q = API.GetItemInfo(id) end
    return n or (e and e.n) or ("Item " .. id), q or 1
end
-- Noms normalisés pour la recherche (cache en mémoire, jamais sauvegardé)
local normCache = setmetatable({}, { __mode = "k" })

-- ── Graphique (courbe + axes + survol) ───────────────────────────────────
-- Axe vertical : 4 intervalles « ronds » (1, 2 ou 5 × 10ⁿ cuivre), assez grands pour que
-- chaque graduation affiche une valeur différente (voir MoneyAxis), et une hauteur minimale
-- de 10 % de la valeur : quelques pièces de cuivre de variation ne remplissent pas l'écran.
local function NiceStep(raw)
    local p = 1
    while p * 10 <= raw do p = p * 10 end
    for _, m in ipairs({ 1, 2, 5, 10 }) do if m * p >= raw then return m * p end end
    return 10 * p
end
local function YBounds(pts, zero)
    local lo, hi = math.huge, -math.huge
    for _, p in ipairs(pts) do if p[2] < lo then lo = p[2] end; if p[2] > hi then hi = p[2] end end
    if zero then lo = 0 end
    local minSpan = math.max(hi * 0.1, 4)
    if hi - lo < minSpan then
        local mid = (lo + hi) / 2
        lo, hi = mid - minSpan / 2, mid + minSpan / 2
        if lo < 0 then hi, lo = hi - lo, 0 end
    end
    local pad = (hi - lo) * 0.05
    lo, hi = zero and 0 or math.max(0, lo - pad), hi + pad
    -- précision des étiquettes : à l'or près au-delà de 100 or, à l'argent près au-delà d'1 or
    local minStep = hi >= 1000000 and 10000 or hi >= 10000 and 100 or 1
    local step = NiceStep(math.max(minStep, (hi - lo) / 4))
    local y0 = math.floor(lo / step) * step
    while y0 + 4 * step < hi do
        step = NiceStep(step + 1)
        y0 = math.floor(lo / step) * step
    end
    return y0, y0 + 4 * step
end

-- cfg.right : place réservée à droite pour une deuxième échelle (opts.series2, ex. quantité en vente)
local function CreateGraph(parent, cfg)
    cfg = cfg or {}
    local g = CreateFrame("Frame", nil, parent)
    g.area = CreateFrame("Frame", nil, g)
    g.area:SetPoint("TOPLEFT", 70, -10); g.area:SetPoint("BOTTOMRIGHT", -(cfg.right or 12), 22)
    g.grid, g.ylab, g.ylab2, g.xlab, g.segs, g.dots = {}, {}, {}, {}, {}, {}
    for i = 1, 5 do
        local l = g.area:CreateTexture(nil, "BACKGROUND"); l:SetHeight(1); l:SetColorTexture(1, 1, 1, 0.07)
        g.grid[i] = l
        local fs = g:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        fs:SetWidth(66); fs:SetJustifyH("RIGHT")
        g.ylab[i] = fs
        if cfg.right then
            local f2 = g:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            f2:SetWidth(cfg.right - 6); f2:SetJustifyH("LEFT")
            g.ylab2[i] = f2
        end
    end
    for i = 1, 4 do g.xlab[i] = g:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall") end
    g.empty = g:CreateFontString(nil, "OVERLAY", "GameFontDisable"); g.empty:SetPoint("CENTER", g.area)
    g.marker = g.area:CreateTexture(nil, "OVERLAY"); g.marker:SetWidth(1); g.marker:SetColorTexture(1, 1, 1, 0.35); g.marker:Hide()
    g.dot = g.area:CreateTexture(nil, "OVERLAY"); g.dot:SetSize(7, 7); g.dot:SetColorTexture(1, 0.82, 0, 1); g.dot:Hide()
    g.dot2 = g.area:CreateTexture(nil, "OVERLAY"); g.dot2:SetSize(7, 7); g.dot2:Hide()

    local function seg(i)
        local s = g.segs[i]
        if not s then
            if g.area.CreateLine then s = g.area:CreateLine(nil, "ARTWORK"); s:SetThickness(2)
            else s = g.area:CreateTexture(nil, "ARTWORK"); s.fallback = true end
            g.segs[i] = s
        end
        return s
    end

    function g:SetData(points, opts)
        self.points, self.opts = points or {}, opts or {}
        self:Draw()
    end
    function g:Draw()
        for _, s in ipairs(self.segs) do s:Hide() end
        self.marker:Hide(); self.dot:Hide(); self.dot2:Hide()
        self.drawn2, self.bounds2 = nil, nil
        local pts, o = self.points or {}, self.opts or {}
        local w, h = self.area:GetWidth() or 0, self.area:GetHeight() or 0
        for _, l in ipairs(self.ylab) do l:SetText("") end
        for _, l in ipairs(self.ylab2) do l:SetText("") end
        for _, l in ipairs(self.xlab) do l:SetText("") end
        if #pts < 2 then
            self.empty:SetText(o.emptyText or "Not enough data yet"); self.empty:Show()
            for _, l in ipairs(self.grid) do l:Hide() end
            return
        end
        self.empty:Hide()
        if w < 20 or h < 20 then return end   -- pas encore dimensionné : OnSizeChanged redessinera
        -- Bornes
        local x0, x1 = o.xmin or pts[1][1], o.xmax or pts[#pts][1]
        if x1 <= x0 then x1 = x0 + 1 end
        local y0, y1 = YBounds(pts, o.zero)
        self.bounds = { x0, x1, y0, y1, w, h }
        local function X(x) return (x - x0) / (x1 - x0) * w end
        local function Y(y) return (y - y0) / (y1 - y0) * h end
        -- Grille et axes
        for i = 1, 5 do
            local v = y0 + (y1 - y0) * (i - 1) / 4
            local yy = Y(v)
            self.grid[i]:ClearAllPoints(); self.grid[i]:SetPoint("BOTTOMLEFT", self.area, "BOTTOMLEFT", 0, yy)
            self.grid[i]:SetPoint("BOTTOMRIGHT", self.area, "BOTTOMLEFT", w, yy); self.grid[i]:Show()
            self.ylab[i]:ClearAllPoints(); self.ylab[i]:SetPoint("RIGHT", self.area, "BOTTOMLEFT", -4, yy)
            self.ylab[i]:SetText(o.hideMain and "" or (o.fmtY or tostring)(v))
        end
        local prevX
        for i = 1, 4 do
            local x = x0 + (x1 - x0) * (i - 1) / 3
            local l = self.xlab[i]
            l:ClearAllPoints(); l:SetPoint("TOP", self.area, "BOTTOMLEFT", X(x), -4)
            if i == 1 then l:SetPoint("TOP", self.area, "BOTTOMLEFT", X(x) + 16, -4) elseif i == 4 then l:SetPoint("TOP", self.area, "BOTTOMLEFT", X(x) - 16, -4) end
            local txt = (o.fmtX or tostring)(x)
            l:SetText(txt ~= prevX and txt or "")   -- pas deux fois la même date
            prevX = txt
        end
        -- Points réduits à un par pixel environ
        local draw, lastPx = {}, nil
        for _, p in ipairs(pts) do
            if p[1] >= x0 and p[1] <= x1 then
                local px = math.floor(X(p[1]))
                if o.stepped or px ~= lastPx then draw[#draw + 1] = p else draw[#draw] = p end
                lastPx = px
            end
        end
        if #draw > 600 then   -- escalier très dense : on garde un point sur n
            local step, k = math.ceil(#draw / 600), {}
            for i = 1, #draw, step do k[#k + 1] = draw[i] end
            if k[#k] ~= draw[#draw] then k[#k + 1] = draw[#draw] end
            draw = k
        end
        self.drawn = draw
        local r, gg, b = unpack(o.color or { 1, 0.82, 0 })
        local n = 0
        local function line(ax, ay, bx, by)
            n = n + 1
            local s = seg(n)
            if s.SetThickness then s:SetThickness(2) end
            if s.fallback then
                s:SetColorTexture(r, gg, b, 1); s:ClearAllPoints()
                s:SetSize(math.max(2, math.abs(bx - ax)), math.max(2, math.abs(by - ay)))
                s:SetPoint("BOTTOMLEFT", self.area, "BOTTOMLEFT", math.min(ax, bx), math.min(ay, by))
            else
                s:SetColorTexture(r, gg, b, 1)
                s:SetStartPoint("BOTTOMLEFT", self.area, ax, ay)
                s:SetEndPoint("BOTTOMLEFT", self.area, bx, by)
            end
            s:Show()
        end
        -- Deuxième courbe (échelle à droite, à partir de 0) : dessinée sous la première
        local s2 = o.series2
        if s2 and s2.points and #s2.points > 0 and #self.ylab2 > 0 then
            local q = {}
            for _, p in ipairs(s2.points) do if p[1] >= x0 and p[1] <= x1 then q[#q + 1] = p end end
            if #q == 1 then q[2] = { x1, q[1][2] } end   -- un seul jour : trait jusqu'au bout du graphique
            if #q >= 2 then
                local hi = 0
                for _, p in ipairs(q) do if p[2] > hi then hi = p[2] end end
                local step = NiceStep(math.max(1, math.ceil(hi * 1.05 / 4)))
                local top = 4 * step
                local function Y2(v) return v / top * h end
                local fmt2 = s2.fmtY or function(v) return tostring(math.floor(v + 0.5)) end
                local c2 = s2.color or { 0.4, 0.7, 1 }
                for i = 1, 5 do
                    local yy = h * (i - 1) / 4
                    local l = self.ylab2[i]
                    l:ClearAllPoints(); l:SetPoint("LEFT", self.area, "BOTTOMRIGHT", 4, yy)
                    l:SetText(fmt2(step * (i - 1))); l:SetTextColor(c2[1], c2[2], c2[3], 0.9)
                end
                local pr, pg_, pb = r, gg, b
                r, gg, b = c2[1], c2[2], c2[3]
                for i = 1, #q - 1 do line(X(q[i][1]), Y2(q[i][2]), X(q[i + 1][1]), Y2(q[i + 1][2])) end
                r, gg, b = pr, pg_, pb
                self.drawn2, self.bounds2 = q, top
                self.dot2:SetColorTexture(c2[1], c2[2], c2[3], 1)
            end
        end
        for i = 1, (o.hideMain and 0 or #draw - 1) do   -- courbe principale cachée (légende) : pas de trait
            local a, c = draw[i], draw[i + 1]
            if o.stepped then
                line(X(a[1]), Y(a[2]), X(c[1]), Y(a[2]))
                if c[2] ~= a[2] then line(X(c[1]), Y(a[2]), X(c[1]), Y(c[2])) end
            else
                line(X(a[1]), Y(a[2]), X(c[1]), Y(c[2]))
            end
        end
    end
    g:SetScript("OnSizeChanged", function(self) self:Draw() end)
    g:SetScript("OnShow", function(self) if C_Timer then C_Timer.After(0, function() self:Draw() end) end end)
    -- Survol : valeur sous la souris
    g.area:EnableMouse(true)
    g.area:SetScript("OnLeave", function(self) g.marker:Hide(); g.dot:Hide(); g.dot2:Hide(); GameTooltip:Hide(); self.hover = nil end)
    g.area:SetScript("OnEnter", function(self) self.hover = true end)
    g.area:SetScript("OnUpdate", function(self)
        if not self.hover or not g.bounds or not g.drawn or #g.drawn == 0 then return end
        local x0, x1, y0, y1, w, h = unpack(g.bounds)
        local cx = GetCursorPosition() / self:GetEffectiveScale() - (self:GetLeft() or 0)
        local xv = x0 + math.max(0, math.min(w, cx)) / w * (x1 - x0)
        if xv < g.drawn[1][1] then g.marker:Hide(); g.dot:Hide(); g.dot2:Hide(); GameTooltip:Hide(); return end   -- avant le premier relevé
        local best = g.drawn[1]
        for _, p in ipairs(g.drawn) do
            if g.opts.stepped then if p[1] <= xv then best = p end
            elseif math.abs(p[1] - xv) < math.abs(best[1] - xv) then best = p end
        end
        local px = g.opts.stepped and cx or (best[1] - x0) / (x1 - x0) * w
        local py = (best[2] - y0) / (y1 - y0) * h
        g.marker:ClearAllPoints(); g.marker:SetPoint("TOP", self, "TOPLEFT", px, 0); g.marker:SetPoint("BOTTOM", self, "BOTTOMLEFT", px, 0); g.marker:Show()
        if g.opts.hideMain then g.dot:Hide()
        else g.dot:ClearAllPoints(); g.dot:SetPoint("CENTER", self, "BOTTOMLEFT", px, py); g.dot:Show() end
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:AddLine((g.opts.fmtTipX or g.opts.fmtX or tostring)(g.opts.stepped and xv or best[1]), 1, 0.82, 0)
        if not g.opts.hideMain then GameTooltip:AddLine(API.Money(best[2]), 1, 1, 1) end
        -- Deuxième courbe : valeur du même jour (rien si elle n'a pas été relevée ce jour-là)
        g.dot2:Hide()
        local s2 = g.opts.series2
        if s2 and g.drawn2 and not g.opts.stepped then
            for _, p in ipairs(g.drawn2) do
                if p[1] == best[1] then
                    local c2 = s2.color or { 0.4, 0.7, 1 }
                    GameTooltip:AddLine((s2.label or "") .. (s2.fmtTip or tostring)(p[2]), c2[1], c2[2], c2[3])
                    g.dot2:ClearAllPoints(); g.dot2:SetPoint("CENTER", self, "BOTTOMLEFT", px, p[2] / g.bounds2 * h); g.dot2:Show()
                    break
                end
            end
        end
        -- Détail (ex. or de chaque personnage à cet instant)
        if g.opts.tipExtra then
            local lines = g.opts.tipExtra(g.opts.stepped and xv or best[1]) or {}
            if #lines > 1 then
                GameTooltip:AddLine(" ")
                for _, l in ipairs(lines) do GameTooltip:AddDoubleLine(l[1], l[2], 1, 1, 1, 1, 1, 1) end
            end
        end
        GameTooltip:Show()
    end)
    return g
end

-- Graduations : à l'or près au-delà de 100 or, sinon à l'argent près (« 1 or 37 ») ;
-- en dessous d'1 or, au cuivre près
local function MoneyAxis(v)
    if v >= 1000000 then return API.Money(math.floor(v / 10000 + 0.5) * 10000, true) end
    if v >= 10000 then return API.Money(math.floor(v / 100 + 0.5) * 100, true) end
    return API.Money(math.floor(v + 0.5), true)
end

-- ── Petits éléments ──────────────────────────────────────────────────────
local function Seg(parent, defs, x, y, onPick)
    local btns = {}
    local cx = x
    for _, d in ipairs(defs) do
        local b = API.CreateMenuButton(parent, d[3] or 90, 22, d[2])
        b:SetPoint("TOPLEFT", cx, y)
        b:SetScript("OnClick", function() onPick(d[1]) end)
        btns[d[1]] = b
        cx = cx + (d[3] or 90) + 4
    end
    function btns.Set(_, id) for k, b in pairs(btns) do if type(b) == "table" and b.LockHighlight then if k == id then b:LockHighlight() else b:UnlockHighlight() end end end end
    return btns
end

local function HeaderBar(parent, anchorY, cols, onSort)
    local hdr = CreateFrame("Frame", nil, parent)
    hdr:SetPoint("TOPLEFT", 12, anchorY); hdr:SetPoint("TOPRIGHT", -12, anchorY); hdr:SetHeight(18)
    API.StripedBackground(hdr, "header")
    hdr.cols = {}
    for _, c in ipairs(cols) do
        local b = CreateFrame("Button", nil, hdr)
        b:SetHeight(18)
        local fs = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetAllPoints(); fs:SetJustifyH(c.right and "RIGHT" or "LEFT"); fs:SetText(c.text)
        b.fs = fs
        if c.right then b:SetPoint("RIGHT", hdr, "LEFT", c.x, 0); b:SetWidth(c.w or 80)
        else b:SetPoint("LEFT", c.x, 0); b:SetWidth(c.w or 120) end
        if c.sort and onSort then
            b:SetScript("OnClick", function() onSort(c.sort) end)
            b:SetScript("OnEnter", function() fs:SetTextColor(1, 1, 1) end)
            b:SetScript("OnLeave", function() fs:SetTextColor(1, 0.82, 0) end)
        end
        hdr.cols[c.sort or c.text] = b
    end
    return hdr
end

-- ── Page « Prices » ──────────────────────────────────────────────────────
local function PriceRow(parent)
    local r = CreateFrame("Button", nil, parent)
    r:SetHeight(ROW_H)
    r.bgL, r.bgR = API.RowBackground(r, 1)
    r.sel = r:CreateTexture(nil, "BORDER"); r.sel:SetAllPoints(); r.sel:SetColorTexture(1, 0.82, 0, 0.14); r.sel:Hide()
    r:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
    local hl = r:GetHighlightTexture(); if type(hl) == "table" then hl:SetAlpha(0.25) end
    r.icon = r:CreateTexture(nil, "ARTWORK"); r.icon:SetSize(18, 18); r.icon:SetPoint("LEFT", 8, 0); r.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.name:SetPoint("LEFT", 32, 0); r.name:SetWidth(330); r.name:SetJustifyH("LEFT"); r.name:SetWordWrap(false)
    local function num(x, w)
        local fs = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("RIGHT", r, "LEFT", x, 0); fs:SetWidth(w); fs:SetJustifyH("RIGHT"); return fs
    end
    r.min, r.avg, r.qty = num(470, 100), num(580, 100), num(650, 60)
    r.seen = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); r.seen:SetPoint("RIGHT", -8, 0)
    r:RegisterForClicks("LeftButtonUp")
    r:SetScript("OnEnter", function(self) if self.id then API.ShowItemTooltip(self, self.id, { n = self.nameText }) end end)
    r:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r:SetScript("OnClick", function(self, button)
        if not self.id then return end
        if IsModifiedClick and IsModifiedClick() then API.ItemClick(self.id, { n = self.nameText }, button); return end
        mf.pages.prices:Select(self.id)
    end)
    return r
end
local function FillPrice(r, d)
    local e = d.e
    r.id, r.nameText = d.id, d.name
    r.icon:SetTexture(Icon(d.id))
    r.name:SetText(QualityHex(d.q) .. d.name .. "|r")
    r.min:SetText(e.m and API.Money(e.m, true) or "—")
    r.avg:SetText(e.a and API.Money(e.a, true) or "")
    r.qty:SetText(e.q or "")
    r.seen:SetText(FC.Auction.Age(e.t))
    r.sel:SetShown(mf.pages.prices.selected == d.id)
end

local function BuildPrices(f, pg)
    pg.sort, pg.desc = "name", false
    pg.search = API.CreateSearchBox(pg, 240, function(t)
        pg.query = API.SearchNorm(t):gsub("^%s+", ""):gsub("%s+$", "")
        pg:Render(true)
    end, "Search an item")
    pg.search:SetPoint("TOPLEFT", 18, -4)
    pg.info = pg:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    pg.info:SetPoint("TOPRIGHT", -16, -8)
    local function sortBy(k)
        if pg.sort == k then pg.desc = not pg.desc else pg.sort, pg.desc = k, (k ~= "name") end
        pg:Render(true)
    end
    local hdr = HeaderBar(pg, -30, {
        { text = "Item", x = 32, w = 200, sort = "name" },
        { text = "Lowest", x = 470, w = 100, right = true, sort = "min" },
        { text = "7-day avg", x = 580, w = 100, right = true, sort = "avg" },
        { text = "On sale", x = 650, w = 60, right = true, sort = "qty" },
        { text = "Seen", x = W - 62, w = 60, right = true, sort = "seen" },
    }, sortBy)
    API.AddInset(pg, -3, 3, -8, 196, hdr)
    pg.sf = API.CreateScrollFrame(pg, nil)
    pg.sf:SetPoint("TOPLEFT", hdr, "BOTTOMLEFT", 0, -2); pg.sf:SetPoint("BOTTOMRIGHT", -30, 200)
    pg.sc = CreateFrame("Frame", nil, pg.sf); pg.sc:SetSize(W - 54, 1)
    pg.sf:SetScrollChild(pg.sc)
    pg.list_ = API.VirtualList(pg.sf, pg.sc, {
        row = { h = ROW_H + 1, create = PriceRow, fill = FillPrice },
        note = { h = 30, create = function(p) local x = CreateFrame("Frame", nil, p); x.t = x:CreateFontString(nil, "OVERLAY", "GameFontDisable"); x.t:SetPoint("LEFT", 12, 0); return x end,
                 fill = function(x, d) x.t:SetText(d.text) end },
    })
    -- Courbe de l'objet choisi
    API.AddInset(pg, 12, -(H - 62 - 188), -8, 12)
    pg.gTitle = pg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    pg.gTitle:SetPoint("TOPLEFT", pg, "BOTTOMLEFT", 22, 180)
    pg.graph = CreateGraph(pg, { right = 44 })
    pg.graph:SetPoint("TOPLEFT", pg, "BOTTOMLEFT", 12, 164); pg.graph:SetPoint("BOTTOMRIGHT", -12, 14)
    -- Légende cliquable : cacher / réafficher chaque courbe (choix retenu ; une courbe reste toujours visible)
    local LEG = { price = { key = "ah_graph_hide_price", text = "lowest buyout", color = { 1, 0.82, 0 } },
                  qty = { key = "ah_graph_hide_qty", text = "number on sale", color = { 0.4, 0.7, 1 } } }
    local function Legend(kind, other)
        local d = LEG[kind]
        local b = CreateFrame("Button", nil, pg)
        b:SetHeight(16)
        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        b.text:SetPoint("LEFT", 0, 0); b.text:SetText(d.text)
        b:SetWidth((b.text:GetStringWidth() or 80) + 4)
        function b:Paint(hidden)
            if hidden then self.text:SetTextColor(0.5, 0.5, 0.5) else self.text:SetTextColor(d.color[1], d.color[2], d.color[3]) end
        end
        b:SetScript("OnClick", function()
            local g = FC.db.global
            if g[d.key] then g[d.key] = nil
            else
                g[d.key] = true
                g[LEG[other].key] = nil   -- l'autre courbe revient : il en reste toujours une
            end
            if pg.selected then pg:Select(pg.selected) end
        end)
        b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:AddLine(FC.db.global[d.key] and "Click to show this line" or "Click to hide this line", 1, 1, 1)
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)
        b:Hide()
        return b
    end
    pg.legPrice = Legend("price", "qty")
    pg.legQty = Legend("qty", "price")
    pg.legPrice:SetPoint("LEFT", pg.gTitle, "RIGHT", 10, 0)
    pg.legQty:SetPoint("LEFT", pg.legPrice, "RIGHT", 8, 0)
    pg.legNote = pg:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    pg.legNote:SetText("(each day)")

    function pg:Select(id)
        self.selected = id
        self.list_:Refresh(function(l) return l.kind == "row" end)
        local e = FC:GetAuctionEntry(id)
        if not e then
            self.gTitle:SetText("Select an item to see its price history"); self.graph:SetData({})
            self.legPrice:Hide(); self.legQty:Hide(); self.legNote:Hide()
            return
        end
        local name, q = ItemName(id, e)
        local pts, qty = {}, {}
        for _, x in ipairs(FC.Auction.ParseHistory(e.h)) do
            local t = x[1] * 86400 + 43200
            pts[#pts + 1] = { t, x[2] }
            if x[3] then qty[#qty + 1] = { t, x[3] } end   -- quantité en vente ce jour-là (relevé complet)
        end
        if #pts == 1 then pts[2] = { math.max(time(), pts[1][1] + 3600), pts[1][2] } end
        self.gTitle:SetText("Price history — " .. QualityHex(q) .. name .. "|r")
        -- Courbes affichées (légende) : sans quantité relevée, le prix reste affiché
        local hasQty = #qty > 0
        local hidePrice = hasQty and FC.db.global.ah_graph_hide_price == true
        local hideQty = hasQty and not hidePrice and FC.db.global.ah_graph_hide_qty == true
        self.legPrice:Paint(hidePrice); self.legPrice:Show()
        self.legQty:Paint(hideQty); if hasQty then self.legQty:Show() else self.legQty:Hide() end
        self.legNote:ClearAllPoints(); self.legNote:SetPoint("LEFT", hasQty and self.legQty or self.legPrice, "RIGHT", 8, 0); self.legNote:Show()
        self.graph:SetData(pts, { fmtY = MoneyAxis, fmtX = function(t) return fmtDate("%d/%m", t) end,
            fmtTipX = function(t) return fmtDate("%d/%m/%Y", t) end, emptyText = "No price recorded yet", hideMain = hidePrice,
            series2 = { points = hideQty and {} or qty, color = { 0.4, 0.7, 1 }, label = "On sale: ",
                fmtY = function(v) return v >= 10000 and (math.floor(v / 1000 + 0.5) .. "k") or tostring(math.floor(v + 0.5)) end } })
    end

    function pg:Render(resetScroll)
        local items = (FC.db.factionrealm.ah and FC.db.factionrealm.ah.items) or {}
        local q = self.query
        local list, total = {}, 0
        for id, e in pairs(items) do
            total = total + 1
            local name, qual = ItemName(id, e)
            local ok = true
            if q and #q >= 2 then
                local c = normCache[e]
                if not c or c[1] ~= name then c = { name, API.SearchNorm(name) }; normCache[e] = c end
                ok = c[2]:find(q, 1, true) ~= nil
            end
            if ok then list[#list + 1] = { id = id, e = e, name = name, q = qual } end
        end
        local key, desc = self.sort, self.desc
        local val = {
            name = function(d) return d.name end, min = function(d) return d.e.m or 0 end, avg = function(d) return d.e.a or 0 end,
            qty = function(d) return d.e.q or 0 end, seen = function(d) return d.e.t or 0 end,
        }
        local v = val[key] or val.name
        table.sort(list, function(a, b)
            local x, y = v(a), v(b)
            if x == y then return a.name < b.name end
            if desc then return x > y end
            return x < y
        end)
        local lines = {}
        for _, d in ipairs(list) do lines[#lines + 1] = { kind = "row", data = d } end
        if #lines == 0 then
            lines[1] = { kind = "note", data = { text = total == 0 and "No price in memory yet: open the Auction House (a full scan starts automatically, or use the \"Full scan\" button)." or "No match." } }
        end
        self.list_:SetLines(lines, resetScroll ~= false)
        local db = FC.db.factionrealm.ah
        self.info:SetText(total .. " items" .. (((db.lastFull or 0) > 0) and ("  ·  last full scan " .. FC.Auction.Age(db.lastFull) .. " ago") or ""))
        if not self.selected and list[1] then self:Select(list[1].id) elseif self.selected then self:Select(self.selected) end
    end
end

-- ── Page « Sales & purchases » ───────────────────────────────────────────
local function SaleRow(parent)
    local r = CreateFrame("Button", nil, parent)
    r:SetHeight(ROW_H)
    r.bgL, r.bgR = API.RowBackground(r, 1)
    r.date = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); r.date:SetPoint("LEFT", 8, 0)
    r.icon = r:CreateTexture(nil, "ARTWORK"); r.icon:SetSize(18, 18); r.icon:SetPoint("LEFT", 84, 0); r.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.name:SetPoint("LEFT", 108, 0); r.name:SetWidth(240); r.name:SetJustifyH("LEFT"); r.name:SetWordWrap(false)
    local function num(x, w)
        local fs = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetPoint("RIGHT", r, "LEFT", x, 0); fs:SetWidth(w); fs:SetJustifyH("RIGHT"); return fs
    end
    r.qty, r.unit, r.total = num(400, 44), num(500, 96), num(610, 104)
    r.who = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    r.who:SetPoint("LEFT", 622, 0); r.who:SetWidth(W - 54 - 630); r.who:SetJustifyH("LEFT"); r.who:SetWordWrap(false)
    r:SetScript("OnEnter", function(self)
        local e = self.e; if not e then return end
        if e.id then API.ShowItemTooltip(self, e.id, { n = e.n }) else GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:AddLine(e.n or "?") end
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine(e.k == "sale" and "Sold to" or "Bought from", e.o or "?", 1, 0.82, 0, 1, 1, 1)
        if e.f then GameTooltip:AddDoubleLine("Auction House cut", API.Money(e.f), 1, 0.82, 0, 1, 1, 1) end
        GameTooltip:AddDoubleLine("Character", e.c or "?", 1, 0.82, 0, 1, 1, 1)
        GameTooltip:Show()
    end)
    r:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r:SetScript("OnClick", function(self, button) local e = self.e; if e and e.id then API.ItemClick(e.id, { n = e.n }, button) end end)
    return r
end
local function FillSale(r, e)
    r.e = e
    r.date:SetText(fmtDate("%d/%m %H:%M", e.t))
    r.icon:SetTexture(Icon(e.id))
    local q = e.id and select(3, API.GetItemInfo(e.id)) or 1
    r.name:SetText(QualityHex(q) .. (e.n or "?") .. "|r")
    r.qty:SetText(e.q or "")
    r.unit:SetText((e.q and e.q > 1) and API.Money(e.p / e.q, true) or "")
    local net = e.k == "sale" and (e.p - (e.f or 0)) or e.p
    r.total:SetText((e.k == "sale" and "|cff40bf40+|r" or "|cffff5050-|r") .. API.Money(net, true))
    r.who:SetText((e.k == "sale" and "to " or "from ") .. (e.o or "?"))
end

local function BuildSales(f, pg)
    pg.kind, pg.days = nil, 30
    pg.kinds = Seg(pg, { { "all", "All", 60 }, { "sale", "Sales", 70 }, { "buy", "Purchases", 90 } }, 14, -2, function(k)
        pg.kind = (k ~= "all") and k or nil; pg:Render(true)
    end)
    pg.periods = Seg(pg, { { 7, "7 days", 70 }, { 30, "30 days", 70 }, { 0, "All", 50 } }, 262, -2, function(d)
        pg.days = d > 0 and d or nil; pg:Render(true)
    end)
    pg.search = API.CreateSearchBox(pg, 170, function(t) pg.query = API.SearchNorm(t):gsub("^%s+", ""):gsub("%s+$", ""); pg:Render(true) end, "Search an item")
    pg.search:SetPoint("TOPRIGHT", -18, -4)
    local hdr = HeaderBar(pg, -30, {
        { text = "Date", x = 8, w = 70 }, { text = "Item", x = 108, w = 200 },
        { text = "Qty", x = 400, w = 44, right = true }, { text = "Unit", x = 500, w = 96, right = true },
        { text = "Total", x = 610, w = 104, right = true }, { text = "Player", x = 622, w = 100 },
    })
    API.AddInset(pg, -3, 3, -8, 40, hdr)
    pg.sf = API.CreateScrollFrame(pg, nil)
    pg.sf:SetPoint("TOPLEFT", hdr, "BOTTOMLEFT", 0, -2); pg.sf:SetPoint("BOTTOMRIGHT", -30, 44)
    pg.sc = CreateFrame("Frame", nil, pg.sf); pg.sc:SetSize(W - 54, 1)
    pg.sf:SetScrollChild(pg.sc)
    pg.list_ = API.VirtualList(pg.sf, pg.sc, {
        row = { h = ROW_H + 1, create = SaleRow, fill = FillSale },
        note = { h = 30, create = function(p) local x = CreateFrame("Frame", nil, p); x.t = x:CreateFontString(nil, "OVERLAY", "GameFontDisable"); x.t:SetPoint("LEFT", 12, 0); return x end,
                 fill = function(x, d) x.t:SetText(d.text) end },
    })
    pg.footer = pg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    pg.footer:SetPoint("BOTTOMLEFT", 18, 16)

    function pg:Render(resetScroll)
        self.kinds:Set(self.kind or "all"); self.periods:Set(self.days or 0)
        local list = FC.Ledger.Entries(self.kind, self.days, self.query)
        local lines, sold, fees, bought = {}, 0, 0, 0
        for _, e in ipairs(list) do
            lines[#lines + 1] = { kind = "row", data = e }
            if e.k == "sale" then sold = sold + e.p; fees = fees + (e.f or 0) else bought = bought + e.p end
        end
        if #lines == 0 then
            lines[1] = { kind = "note", data = { text = FC.db.global.ledger_track == false and "Recording is turned off (Options > Auction House)."
                or "Nothing yet. Sales and purchases are read from the Auction House mail when you open your mailbox." } }
        end
        self.list_:SetLines(lines, resetScroll ~= false)
        self.footer:SetText("Sales |cff40bf40" .. API.Money(sold - fees, true) .. "|r" .. (fees > 0 and ("  |cff9d9d9d(cut " .. API.Money(fees, true) .. ")|r") or "")
            .. "     Purchases |cffff5050" .. API.Money(bought, true) .. "|r     Net " .. ((sold - fees - bought) >= 0 and "|cff40bf40" or "|cffff5050")
            .. API.Money(sold - fees - bought, true) .. "|r")
    end
end

-- ── Page « Gold » ────────────────────────────────────────────────────────
local function BuildGold(f, pg)
    pg.who, pg.days = nil, 30
    pg.dd = API.CreateDropdown(pg, 200, function()
        local items = { { text = "All characters", isSelected = function() return pg.who == nil end, func = function() pg.who = nil; pg:Render() end } }
        for _, c in ipairs(FC.Ledger.Characters()) do
            items[#items + 1] = { text = ClassHex(c.class) .. c.name .. "|r", isSelected = function() return pg.who == c.name end,
                func = function() pg.who = c.name; pg:Render() end }
        end
        return items
    end)
    pg.dd.frame:SetPoint("TOPLEFT", 14 + (pg.dd.xInset or 0), -2)
    pg.periods = Seg(pg, { { 7, "7 days", 70 }, { 30, "30 days", 70 }, { 0, "All", 50 } }, 232, -2, function(d)
        pg.days = d > 0 and d or nil; pg:Render()
    end)
    pg.total = pg:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); pg.total:SetPoint("TOPRIGHT", -16, -4)
    pg.change = pg:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); pg.change:SetPoint("TOPRIGHT", pg.total, "BOTTOMRIGHT", 0, -2)
    local RIGHT_W = 200
    API.AddInset(pg, 12, -44, -(RIGHT_W + 18), 12)
    pg.graph = CreateGraph(pg)
    pg.graph:SetPoint("TOPLEFT", 12, -48); pg.graph:SetPoint("BOTTOMRIGHT", -(RIGHT_W + 18), 14)
    -- Liste des personnages
    API.AddInset(pg, W - RIGHT_W - 12, -44, -8, 12)
    pg.chars = {}
    pg.charHdr = CreateFrame("Frame", nil, pg)
    pg.charHdr:SetPoint("TOPLEFT", W - RIGHT_W - 8, -48); pg.charHdr:SetSize(RIGHT_W - 8, 20)
    API.StripedBackground(pg.charHdr, "header")
    local ht = pg.charHdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); ht:SetPoint("LEFT", 6, 0); ht:SetText("Characters")

    function pg:Render()
        self.periods:Set(self.days or 0)
        self.dd.SetText(self.who and (self.who) or "All characters")
        local from = self.days and (time() - self.days * 86400) or nil
        local series = FC.Ledger.GoldSeries(self.who, from)
        local cur = series[#series] and series[#series][2] or 0
        local startV = series[1] and series[1][2] or cur
        self.total:SetText(API.Money(cur, true))
        local d = cur - startV
        -- Suivi plus récent que la période choisie : on l'indique (« since 29/09 18:40 »)
        local began = series[1] and series[1][1]
        local label = (self.days and began and from and began <= from + 60) and ("last " .. self.days .. " days: ")
            or (began and ("since " .. fmtDate("%d/%m %H:%M", began) .. ": ") or "")
        self.change:SetText(label .. (d >= 0 and "|cff40bf40+" or "|cffff5050") .. API.Money(d, true) .. "|r")
        -- Axe du temps : du premier relevé (ou du début de la période) à maintenant, sur au moins
        -- une heure ; un suivi tout juste commencé ne s'étire pas sur toute la largeur
        local now = time()
        local xmin = math.min(began or now, now - 3600)
        local span = now - xmin
        self.graph:SetData(series, { stepped = true, fmtY = MoneyAxis, color = { 1, 0.82, 0 }, xmin = xmin, xmax = now,
            fmtX = function(t)
                if span > 4 * 86400 then return fmtDate("%d/%m", t) end
                if span > 86400 then return fmtDate("%d/%m %Hh", t) end
                return fmtDate("%H:%M", t)
            end,
            fmtTipX = function(t) return fmtDate("%d/%m %H:%M", t) end,
            tipExtra = not self.who and function(t)
                local out = {}
                for _, v in ipairs(FC.Ledger.ValuesAt(t)) do out[#out + 1] = { ClassHex(v.class) .. v.name .. "|r", API.Money(v.money, true) } end
                return out
            end or nil,
            emptyText = FC.db.global.gold_track == false and "Gold tracking is turned off (Options > Auction House)." or "Not enough data yet" })
        -- Personnages
        for _, r in ipairs(self.chars) do r:Hide() end
        for i, c in ipairs(FC.Ledger.Characters()) do
            local r = self.chars[i]
            if not r then
                r = CreateFrame("Button", nil, self)
                r:SetSize(RIGHT_W - 8, 20)
                r.bgL, r.bgR = API.RowBackground(r, i)
                r.n = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); r.n:SetPoint("LEFT", 6, 0); r.n:SetWidth(90); r.n:SetJustifyH("LEFT"); r.n:SetWordWrap(false)
                r.m = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); r.m:SetPoint("RIGHT", -6, 0)
                r:SetScript("OnClick", function(b) pg.who = (pg.who ~= b.who) and b.who or nil; pg:Render() end)
                self.chars[i] = r
            end
            r:SetPoint("TOPLEFT", self.charHdr, "BOTTOMLEFT", 0, -(i - 1) * 21 - 2)
            r.who = c.name
            r.n:SetText(ClassHex(c.class) .. c.name .. "|r" .. (self.who == c.name and " |cffffd100<|r" or ""))
            r.m:SetText(API.Money(c.money, true))
            r:Show()
        end
    end
end

-- ── Fenêtre ──────────────────────────────────────────────────────────────
local PAGES = {
    { id = "prices", name = "Prices", w = 90, build = BuildPrices },
    { id = "sales", name = "Sales & purchases", w = 150, build = BuildSales },
    { id = "gold", name = "Gold", w = 80, build = BuildGold },
}

local function Build()
    local f = API.CreateWindow("ForeverCompanionMarketFrame", UIParent, W, H)
    f:SetPoint("CENTER", 60, 0)
    f:SetFrameStrata("HIGH")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    API.CloseOnEscape(f)
    f.title = API.WindowTitle(f)
    f.pages, f.tabBtns = {}, {}
    local x = 14
    for _, p in ipairs(PAGES) do
        local b = API.CreateMenuButton(f, p.w, 22, p.name)
        b:SetPoint("TOPLEFT", x, -33)
        b:SetScript("OnClick", function() f:ShowPage(p.id) end)
        f.tabBtns[p.id] = b
        x = x + p.w + 4
    end
    f.optBtn = API.CreateOptionsButton and API.CreateOptionsButton(f, function() FC:OpenOptions("auction") end)
    function f:ShowPage(id)
        local def
        for _, p in ipairs(PAGES) do if p.id == id then def = p end end
        def = def or PAGES[1]
        for k, pg in pairs(self.pages) do pg:Hide() end
        for k, b in pairs(self.tabBtns) do if k == def.id then b:LockHighlight() else b:UnlockHighlight() end end
        local pg = self.pages[def.id]
        if not pg then
            pg = CreateFrame("Frame", nil, self)
            pg:SetPoint("TOPLEFT", 0, -60); pg:SetPoint("BOTTOMRIGHT", 0, 0)
            def.build(self, pg)
            self.pages[def.id] = pg
        end
        pg:Show()
        self.current = def.id
        FC.db.char.market_page = def.id
        self.title:SetText("Auction House — " .. def.name)
        pg:Render(true)
    end
    return f
end

function FC:OpenMarket(page)
    if FC.db.global.ah_enabled == false then
        print("|cffffd700" .. FC.NAME .. "|r : Auction House features are turned off (Options > Auction House).")
        return
    end
    if not mf then mf = Build() end
    mf:ShowPage(page or mf.current or FC.db.char.market_page or "prices")
    mf:Show()
    mf:Raise()
end

-- Rafraîchit une page si elle est affichée (après un scan, une facture, etc.)
function FC:RefreshMarket(which)
    if not mf or not mf:IsShown() or (which and mf.current ~= which) then return end
    local pg = mf.pages[mf.current]
    if pg then pg:Render(false) end
end
