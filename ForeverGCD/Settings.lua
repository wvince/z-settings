local _, ns = ...
-- Options -> AddOns -> Forever GCD: one page in the workspace's row style
-- (its page toolkit is Forever Enemy Buffs'). Every setting is one row: its
-- name on the left and its control beside it (On/Off, < Value >, or a slider
-- with step arrows and a reset arrow); details live in the tooltips. Rows
-- sit under headings that open and close, with their state beside them. The
-- Move panel at the top moves the target bar; How to use is its own tab. The
-- page answers Forever Settings' search (panel.ForeverSettingsSearch).

local WHITE = "Interface\\Buttons\\WHITE8X8"
local backdrop = {
    bgFile = WHITE, edgeFile = WHITE,
    edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 },
}
local edgeOnly = { edgeFile = WHITE, edgeSize = 1 }
local GOLD = { 0.95, 0.76, 0.35 }
local GREY = { 0.55, 0.55, 0.58 }
local GREY_TEXT = "|cff8c8c94"
local AMBER_TEXT = "|cffff9f1a"
local ROW = 26
local NAME_X, NAME_W = 14, 150
-- Three control columns, one per side; a row with one control uses SINGLE.
local C1, C2, C3, CW = 170, 284, 398, 110
local SINGLE = 2 * CW + 4
local FULL = C3 + CW - NAME_X
-- A read-out from the first control column to the right edge.
local WIDE = FULL - (C1 - NAME_X) - 4
-- The always-open last heading (page.Help, 0.5.0).
local HELP = "How to use"

-- Widgets -----------------------------------------------------------------------
local function Text(parent, text, x, y, color, width)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetPoint("TOPLEFT", x, y)
    if width then label:SetWidth(width) else label:SetPoint("TOPRIGHT", -14, y) end
    label:SetJustifyH("LEFT")
    label:SetText(text)
    if color then label:SetTextColor(color[1], color[2], color[3]) end
    return label
end
-- a settings tooltip never covers its row (AGENTS.md, "Gears and
-- quick settings"): it sits beside the window that holds the page (owner's
-- topmost frame below UIParent: Forever Settings' window, Blizzard's Options
-- or a gear panel), level with owner; right of the window when it fits,
-- else left, else under owner (over it when owner is low on the screen).
-- Call it once the tooltip is filled and shown, so its size is known. Up to
-- tooltips sat at the row's top right (ANCHOR_RIGHT).
local function Measure(value)
    if type(value) ~= "number" or (issecretvalue and issecretvalue(value)) then return nil end
    return value
end
local function PlaceTooltip(tip, owner)
    tip:ClearAllPoints()
    if not UIParent then
        tip:SetPoint("BOTTOMLEFT", owner, "TOPRIGHT")
        return
    end
    local window = owner
    while window and window.GetParent and window:GetParent() and window:GetParent() ~= UIParent do
        window = window:GetParent()
    end
    local tipScale, ownerScale = Measure(tip:GetEffectiveScale()), Measure(owner:GetEffectiveScale())
    local width, height = Measure(tip:GetWidth()), Measure(tip:GetHeight())
    local ownerTop, ownerBottom = Measure(owner:GetTop()), Measure(owner:GetBottom())
    local left, right, top = Measure(window:GetLeft()), Measure(window:GetRight()), Measure(window:GetTop())
    local windowScale, screen = Measure(window:GetEffectiveScale()), Measure(UIParent:GetRight())
    local parentScale = Measure(UIParent:GetEffectiveScale())
    if not (tipScale and ownerScale and width and ownerTop and left and right and top and windowScale and screen and parentScale) then
        tip:SetPoint("BOTTOMLEFT", owner, "TOPRIGHT")
        return
    end
    local gap = 4
    width, screen = width * tipScale, screen * parentScale
    -- How far below the window's top owner's top is, in the tooltip's units.
    local drop = (ownerTop * ownerScale - top * windowScale) / tipScale
    if right * windowScale + gap + width <= screen then
        tip:SetPoint("TOPLEFT", window, "TOPRIGHT", gap / tipScale, drop)
    elseif left * windowScale - gap - width >= 0 then
        tip:SetPoint("TOPRIGHT", window, "TOPLEFT", -gap / tipScale, drop)
    elseif ownerBottom and ownerBottom * ownerScale - (height or 0) * tipScale >= 0 then
        tip:SetPoint("TOPLEFT", owner, "BOTTOMLEFT", 0, -gap / tipScale)
    else
        tip:SetPoint("BOTTOMLEFT", owner, "TOPLEFT", 0, gap / tipScale)
    end
end
-- source: a row's tag from Source(), whose line goes under the detail.
-- point(true/false), when given, is told the mouse is over the control or
-- has left it (0.4.0: a row's part outlined in the preview). detail may be
-- fn() for a tooltip that changes (0.9.1: the step arrows'). A control on
-- a row of two (AGENTS.md "Two settings, one row", 0.3.0) may carry its own
-- tip, { title, detail } (row:Tip), read at hover time.
local function Tooltip(control, title, detail, source, point)
    if not detail and not point then return end
    control:HookScript("OnEnter", function(self)
        if point then point(true) end
        local own = self.tip
        local shown = own and own.detail or detail
        if not shown then return end
        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:SetText(own and own.title or title)
        GameTooltip:AddLine(type(shown) == "function" and shown() or shown, 0.85, 0.85, 0.85, true)
        if source then GameTooltip:AddLine(source.line, source.color[1], source.color[2], source.color[3], true) end
        GameTooltip:Show()
        PlaceTooltip(GameTooltip, self)
    end)
    control:HookScript("OnLeave", function(self)
        if point then point(false) end
        if detail or self.tip then GameTooltip:Hide() end
    end)
end
-- The border stays black; hover adds a gold line just inside it.
local function Skin(control, hover)
    control:SetBackdropColor(hover and 0.24 or 0.14, hover and 0.20 or 0.145, hover and 0.12 or 0.16, 1)
    control:SetBackdropBorderColor(0, 0, 0, 1)
    if not control.gold then
        local gold = CreateFrame("Frame", nil, control, "BackdropTemplate")
        gold:SetPoint("TOPLEFT", 1, -1)
        gold:SetPoint("BOTTOMRIGHT", -1, 1)
        gold:SetBackdrop(edgeOnly)
        gold:SetBackdropBorderColor(0.8, 0.62, 0.25, 1)
        control.gold = gold
    end
    control.gold:SetShown(hover)
end
local function Hover(control)
    Skin(control, false)
    control:SetScript("OnEnter", function(self) Skin(self, true) end)
    control:SetScript("OnLeave", function(self) Skin(self, false) end)
end
-- A row's name: a dark strip, not a control. source: its tag, drawn at the
-- strip's right end; the name stops short of it and ends in "..." if it
-- would run into it.
local function Strip(parent, x, y, width, text, source)
    local strip = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    strip:SetPoint("TOPLEFT", x, y)
    strip:SetSize(width, 22)
    strip:SetBackdrop(backdrop)
    strip:SetBackdropColor(0.11, 0.115, 0.13, 1)
    strip:SetBackdropBorderColor(0, 0, 0, 1)
    strip:EnableMouse(true)
    strip.label = strip:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    strip.label:SetPoint("LEFT", 8, 0)
    strip.label:SetJustifyH("LEFT")
    strip.label:SetText(text)
    if source then
        strip.tag = strip:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        strip.tag:SetPoint("RIGHT", -6, 0)
        strip.tag:SetText(source.tag)
        strip.tag:SetTextColor(source.color[1], source.color[2], source.color[3])
        strip.label:SetPoint("RIGHT", strip.tag, "LEFT", -4, 0)
        strip.label:SetWordWrap(false)
    else
        strip.label:SetPoint("RIGHT", -8, 0)
    end
    return strip
end
local function ButtonWidget(parent, x, y, width, text)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetPoint("TOPLEFT", x, y)
    button:SetSize(width, 22)
    button:SetBackdrop(backdrop)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button.label = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    button.label:SetPoint("LEFT", 8, 0)
    button.label:SetPoint("RIGHT", -8, 0)
    button.label:SetText(text or "")
    button.label:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    Hover(button)
    return button
end

-- A setting key, or { key, get, set, limits, format, default } for a value
-- shown differently; a key's default is its saved default.
local function Adapter(key)
    if type(key) == "table" then return key end
    return { key = key, get = function() return ns.Get(key) end, set = function(value) ns.Set(key, value) end,
        limits = ns.Limits[key], options = ns.Choices[key], default = ns.Default(key) }
end

-- A slider's reset arrow (AGENTS.md, "Gears and quick settings"; Forever
-- Battle Map 0.9.0's): Blizzard's undo icon (ModelSceneControlFrame.lua's
-- reset button, Blizzard_SharedXML), or its refresh arrows on a build without
-- the atlas; in colour while the value differs from its default by half a
-- step or more, when a click sets the default, and grey once it is the
-- default.
local RESET_ATLAS, RESET_FILE = "common-icon-undo", "Interface\\Buttons\\UI-RefreshButton"
local function ResetArt(texture, changed)
    if not texture.resetArt then
        if C_Texture.GetAtlasInfo(RESET_ATLAS) then texture:SetAtlas(RESET_ATLAS) else texture:SetTexture(RESET_FILE) end
        texture.resetArt = true
    end
    texture:SetDesaturated(not changed)
    if changed then texture:SetVertexColor(1, 1, 1, 1) else texture:SetVertexColor(0.5, 0.5, 0.52, 1) end
end
local function Differs(value, default, step)
    if type(value) ~= "number" or type(default) ~= "number" then return false end
    return math.abs(value - default) >= math.max((step or 0) / 2, 1e-6)
end

-- No row carries a tag: no setting here is one of Blizzard's own (AGENTS.md
-- "Blizzard's own settings are marked").
local function Source(_) return nil end

-- Page --------------------------------------------------------------------------------
local pages = {}
-- Every page by name, each with its rows by name (read by the tests).
ns.SettingsPages = pages

-- pinned: the page is about one thing, so its preview stays in view
-- in a strip above the scrolling rows (AGENTS.md "Previews in settings", as
-- Forever Skin's pages); page.Pinned() builds it. Without the preview kit
-- there is no strip and the rows start at the top as before.
-- host: a panel kit window (PanelKit.lua) whose content the rows are
-- built into instead, so the bar gear's Look and size... panel draws the
-- page's own rows (AGENTS.md "The panel kit"): host.frame is the window,
-- host.content where the rows go, host.Fit(height) sizes it. A panel page is
-- not registered, scrolls with the window and answers no search.
local function NewPage(name, pinned, host)
    local page = { name = name, rows = {}, list = {}, notes = {}, blocks = {}, refreshers = {}, groups = {}, host = host }
    local panel, body, scroll
    if host then
        panel, body = host.frame, host.content
    else
        panel = CreateFrame("Frame", nil, UIParent)
        panel:Hide()
        pages[name] = page
        if pinned and ns.PreviewKit then
            local header = CreateFrame("Frame", nil, panel, "BackdropTemplate")
            header:SetPoint("TOPLEFT", 16, -16)
            header:SetPoint("TOPRIGHT", -34, -16)
            header:SetHeight(60)
            header:SetBackdrop(backdrop)
            header:SetBackdropColor(0.075, 0.08, 0.09, 0.98)
            header:SetBackdropBorderColor(0, 0, 0, 1)
            page.header = header
        end
        scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
        if page.header then
            scroll:SetPoint("TOPLEFT", page.header, "BOTTOMLEFT", 0, -6)
        else
            scroll:SetPoint("TOPLEFT", 16, -16)
        end
        scroll:SetPoint("BOTTOMRIGHT", -34, 16)
        body = CreateFrame("Frame", nil, scroll, "BackdropTemplate")
        body:SetSize(566, 400)
        body:SetBackdrop(backdrop)
        body:SetBackdropColor(0.075, 0.08, 0.09, 0.98)
        body:SetBackdropBorderColor(0, 0, 0, 1)
        scroll:SetScrollChild(body)
        scroll:SetScript("OnSizeChanged", function(_, width) body:SetWidth(width) end)
    end
    page.panel, page.body = panel, body

    function page.OnRefresh(fn) page.refreshers[#page.refreshers + 1] = fn end
    function page.Refresh()
        for _, fn in ipairs(page.refreshers) do fn() end
    end

    -- Trying a choice before picking it (AGENTS.md "Previews in
    -- settings"): while a preset button or a dropdown choice is under the
    -- mouse, page.trial holds the values it would set and the preview reads
    -- them through page.Get; nothing is written and no plate changes.
    -- page.Try(nil) puts the saved values back. label says what is tried.
    function page.Get(key)
        local trial = page.trial
        if trial and trial[key] ~= nil then return trial[key] end
        return ns.Get(key)
    end
    function page.Try(values, label)
        if page.trial == nil and values == nil then return end
        page.trial, page.trialLabel = values, values and label or nil
        if page.RefreshPreview then page.RefreshPreview() end
    end

    -- The pinned preview: the workspace's preview kit
    -- (PreviewKit.lua) in the strip above the rows, which grows to hold it.
    -- onScreen and screenTip: its Show on screen button. nil
    -- without the kit.
    -- click a part to find its setting (preview kit 3): the pinned
    -- preview finds its rows anywhere on the page.
    function page.Pinned(onScreen, screenTip)
        local header = page.header
        if not header then return nil end
        local preview = ns.PreviewKit.New(header, { x = NAME_X, width = FULL, onScreen = onScreen, screenTip = screenTip,
            resize = function(height) header:SetHeight(height) end,
            find = function(parts) page.Find(parts) end,
            names = function(parts) return page.PartNames(parts) end })
        page.pinned = preview
        return preview
    end

    -- The open or closed group the next blocks belong to.
    local group
    -- While Forever Settings' search box holds words: the blocks to draw,
    -- else nil and the page draws as usual.
    local found
    -- (AGENTS.md "Shorter pages", Forever Cast 0.13.0's): rows after
    -- page.More() are their heading's fine-tuning (fine); blocks from
    -- page.Help on are the How to use tab's (help); the blocks before the
    -- first row, heading or preview are the page's top, shown on both tabs.
    local fine, inHelp, started = false, false, false
    page.tab = "settings"
    -- Blocks stack top to bottom.
    function page.Block(height)
        local frame = CreateFrame("Frame", nil, body)
        frame:SetHeight(height)
        local block = { frame = frame, height = height, shown = true, group = group, help = inHelp }
        page.blocks[#page.blocks + 1] = block
        if group then
            group.members[#group.members + 1] = block
            block.shown = group.open
        end
        return frame, block
    end
    -- The first row, heading or preview ends the page's top.
    local function Start()
        if started then return end
        started = true
        page.topCount = #page.blocks
        for index = 1, page.topCount do page.blocks[index].top = true end
    end

    -- A row's value differs from its default: it never folds away.
    local function Changed(row)
        for _, setting in ipairs(row.settings or {}) do
            local default = setting.default
            if default ~= nil and setting.get then
                local value = setting.get()
                if type(value) == "number" and type(default) == "number" then
                    if Differs(value, default, setting.step) then return true end
                elseif value ~= default then
                    return true
                end
            end
        end
        return false
    end
    page.Changed = Changed
    local function Folded(block)
        return block.fine and not block.group.moreOpen and not Changed(block.row)
    end
    local function Visible(block)
        -- The Move panel is the way to move the bar: it shows on both
        -- tabs and through a search.
        if block.move then return true end
        if found then
            if block.tabs or block.more then return false end
            return found[block] == true and not (block.group and block.group.folded)
        end
        if page.tabs and not block.top and not block.tabs then
            if (page.tab == "help") ~= (block.help == true) then return false end
        end
        if block.more then
            return block.shown and (block.group.moreOpen or block.more.Count() > 0)
        end
        if block.fine then return block.shown and not Folded(block) end
        return block.shown
    end
    function page.Layout()
        local y = -6
        for _, block in ipairs(page.blocks) do
            if Visible(block) then
                block.frame:ClearAllPoints()
                block.frame:SetPoint("TOPLEFT", 0, y)
                block.frame:SetPoint("TOPRIGHT", 0, y)
                block.frame:Show()
                block.y = y
                y = y - block.height
            else
                block.frame:Hide()
            end
        end
        if host then host.Fit(-y + 6) else body:SetHeight(-y + 12) end
    end

    -- More: the rows after this in the heading being built are its
    -- fine-tuning, behind one grey line at the heading's foot ("+ 3 more:
    -- curse, poison, disease"); a click opens them in place and the line
    -- becomes "- Fewer rows". The state is kept like a heading's. A row whose
    -- value differs from its default stays shown; a search shows every match.
    function page.More()
        assert(group and not group.always, "More belongs in a heading")
        group.fine = group.fine or {}
        fine = true
    end
    local function CloseMore()
        local this = group
        fine = false
        if not this or not this.fine or #this.fine == 0 or this.moreBlock then return end
        local frame, block = page.Block(24)
        this.moreBlock = block
        local more = {}
        block.more = more
        local button = CreateFrame("Button", nil, frame, "BackdropTemplate")
        button:SetPoint("TOPLEFT", NAME_X, -2)
        button:SetSize(FULL, 20)
        button:SetBackdrop(edgeOnly)
        button:SetBackdropBorderColor(0.2, 0.205, 0.23, 1)
        local plus = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        plus:SetPoint("LEFT", 8, 0)
        plus:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
        local text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetPoint("LEFT", 22, 0)
        text:SetPoint("RIGHT", -8, 0)
        text:SetJustifyH("LEFT")
        text:SetWordWrap(false)
        text:SetTextColor(GREY[1], GREY[2], GREY[3])
        more.button, more.text = button, text
        function more.Count()
            local count = 0
            for _, row in ipairs(this.fine) do
                if not Changed(row) then count = count + 1 end
            end
            return count
        end
        local folded
        local function Paint()
            if this.moreOpen then
                plus:SetText("-")
                text:SetText("Fewer rows")
            else
                local names = {}
                for _, row in ipairs(this.fine) do
                    if not Changed(row) then names[#names + 1] = row.label:lower() end
                end
                plus:SetText("+")
                text:SetText(#names .. " more: " .. table.concat(names, ", "))
            end
        end
        button:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.8, 0.62, 0.25, 1)
            text:SetTextColor(0.92, 0.92, 0.92)
        end)
        button:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0.2, 0.205, 0.23, 1)
            text:SetTextColor(GREY[1], GREY[2], GREY[3])
        end)
        button:SetScript("OnClick", function()
            this.moreOpen = not this.moreOpen
            ns.SetGroupOpen(this.key .. " / more", this.moreOpen)
            page.Layout()
            page.Refresh()
        end)
        Tooltip(button, "More", "Settings most players set once and leave: open them here. A setting you have changed from its default always shows.")
        -- A row that comes back to its default folds away at the next
        -- change; one that leaves it shows at once.
        page.OnRefresh(function()
            Paint()
            local marks = {}
            for _, row in ipairs(this.fine) do marks[#marks + 1] = Changed(row) and "1" or "0" end
            local now = table.concat(marks)
            if folded and folded ~= now then page.Layout() end
            folded = now
        end)
        this.moreOpen = ns.GroupOpen(this.key .. " / more") == true
    end
    page.CloseMore = CloseMore

    -- A preview box as the first block under the heading just made (0.4.0,
    -- as Forever Cast's), kept as its group's preview so its rows point at
    -- their parts. nil without the kit. This page pins its one preview
    -- instead (page.Pinned); the call is here for a heading that needs its own.
    function page.Preview(onScreen, screenTip)
        if not ns.PreviewKit then return nil end
        Start()
        local frame, block = page.Block(60)
        block.preview = true
        local preview = ns.PreviewKit.New(frame, { x = NAME_X, width = FULL, onScreen = onScreen, screenTip = screenTip,
            resize = function(height)
                if height == block.height then return end
                block.height = height
                frame:SetHeight(height)
                page.Layout()
            end,
            find = function(parts) page.Find(parts, block.group) end,
            names = function(parts) return page.PartNames(parts, block.group) end })
        preview.block = block
        if block.group then block.group.preview = preview end
        return preview
    end

    -- The Move panel (preview kit 5, the user's option A of 15
    -- October 2026): the target bar hides until there is a target to
    -- watch, so the way to move it is a gold panel at the top of the
    -- scrolling rows (under the tabs, above Presets; the pinned preview
    -- stays above them), with Unlock to move (or Lock in place) and Show on
    -- screen always beside it. options are the kit's (ns.PreviewKit.Move);
    -- the block resizes with the panel and the page's refresh repaints it, so
    -- a lock changed elsewhere (/fgcd lock, a right-click on the bar, the
    -- Unlock row) shows at once. Not in the bar's gear panel; nil there and
    -- without the kit, when the page draws a plain row in its place.
    function page.Move(options)
        if host or not (ns.PreviewKit and ns.PreviewKit.Move) then return nil end
        Start()
        local frame, block = page.Block(60)
        block.move = true
        local settings = {}
        for key, value in pairs(options) do settings[key] = value end
        settings.x, settings.width = settings.x or NAME_X, settings.width or FULL
        settings.resize = function(height)
            if height == block.height then return end
            block.height = height
            frame:SetHeight(height)
            page.Layout()
        end
        local move = ns.PreviewKit.Move(frame, settings)
        move.block = block
        page.move = move
        page.OnRefresh(function() move.Refresh() end)
        return move
    end

    -- The rows of a heading (every row of the page without one) that change
    -- any of parts, in page order.
    local function PartRows(parts, within)
        local wanted = {}
        for _, part in ipairs(parts or {}) do wanted[part] = true end
        local rows = {}
        for _, row in ipairs(page.list) do
            if row.part and wanted[row.part] and (not within or row.block.group == within) then rows[#rows + 1] = row end
        end
        return rows
    end
    function page.PartNames(parts, within)
        local names = {}
        for _, row in ipairs(PartRows(parts, within)) do names[#names + 1] = row.label end
        return table.concat(names, ", ")
    end
    -- Click a part to find its setting: the rows open (each one's
    -- heading, and its More line when it is folded), they light up gold where
    -- they are; the page does not move (preview kit 4; the user, 14 October
    -- 2026), and a gold bar at its edge points at rows out of sight. The
    -- pinned preview's parts may have rows under several headings; each
    -- opens.
    function page.Find(parts, within)
        local rows = PartRows(parts, within)
        if #rows == 0 then return end
        if not found then
            page.tab = "settings"
            for _, row in ipairs(rows) do
                local this = row.block.group
                if this and not this.open and not this.always then
                    this.open = true
                    ns.SetGroupOpen(this.key, true)
                    for _, member in ipairs(this.members) do member.shown = true end
                end
                if row.block.fine and this and not this.moreOpen and not Changed(row) then
                    this.moreOpen = true
                    ns.SetGroupOpen(this.key .. " / more", true)
                end
            end
            page.Layout()
            page.Refresh()
        end
        if not (ns.PreviewKit and ns.PreviewKit.Found) then return end
        local strips, names = {}, {}
        for _, row in ipairs(rows) do
            strips[#strips + 1] = row.name
            names[#names + 1] = row.label
        end
        ns.PreviewKit.Found(scroll, strips, names)
    end

    -- A group that opens and closes, drawn like the quest log's zone headers:
    -- its title and a grey summary of its state over a thin line across the
    -- rows, with a [-] or [+] box at the line's right end. A click anywhere
    -- on the header opens or closes it; the blocks after it, up to the next
    -- group, are its rows. detail: the heading's tooltip. A click's open or
    -- closed state is saved account-wide, so the heading reopens as the
    -- player left it; never clicked, it opens as coded.
    function page.Group(title, open, summary, detail)
        CloseMore()
        Start()
        group = nil
        local frame, block = page.Block(ROW + 4)
        local members = {}
        local saved = ns.GroupOpen(title)
        if saved ~= nil then open = saved end
        -- key: its saved open state's name (its More line's adds " / more").
        local this = { title = title, open = open == true, members = members, block = block, key = title }
        block.heading = this
        local toggle = CreateFrame("Button", nil, frame)
        toggle:SetPoint("TOPLEFT", NAME_X, -4)
        toggle:SetSize(FULL, 22)
        toggle:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        local heading = toggle:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        heading:SetPoint("BOTTOMLEFT", 2, 5)
        heading:SetText(title)
        local count = toggle:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        count:SetPoint("BOTTOMLEFT", heading, "BOTTOMRIGHT", 10, 0)
        count:SetPoint("RIGHT", -24, 0)
        count:SetJustifyH("LEFT")
        count:SetTextColor(GREY[1], GREY[2], GREY[3])
        local line = toggle:CreateTexture(nil, "ARTWORK")
        line:SetPoint("BOTTOMLEFT", 0, 0)
        line:SetPoint("BOTTOMRIGHT", 0, 0)
        line:SetHeight(1)
        -- The box: dark inside a black edge; a gold minus, and a bar across
        -- it for plus.
        local box = CreateFrame("Frame", nil, toggle, "BackdropTemplate")
        box:SetPoint("BOTTOMRIGHT", 0, 3)
        box:SetSize(15, 15)
        box:SetBackdrop(backdrop)
        box:SetBackdropColor(0.14, 0.145, 0.16, 1)
        box:SetBackdropBorderColor(0, 0, 0, 1)
        local across = box:CreateTexture(nil, "OVERLAY")
        across:SetPoint("CENTER", 0, 0)
        across:SetSize(7, 1)
        local down = box:CreateTexture(nil, "OVERLAY")
        down:SetPoint("CENTER", 0, 0)
        down:SetSize(1, 7)
        local hovered = false
        local function Paint()
            local lit = hovered and GOLD or { 0.92, 0.92, 0.92 }
            heading:SetTextColor(lit[1], lit[2], lit[3])
            local mark = hovered and { 1, 0.9, 0.55 } or GOLD
            across:SetColorTexture(mark[1], mark[2], mark[3], 1)
            down:SetColorTexture(mark[1], mark[2], mark[3], 1)
            if found then down:SetShown(this.folded == true) else down:SetShown(not this.open) end
            line:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], hovered and 0.9 or 0.45)
        end
        toggle:SetScript("OnEnter", function() hovered = true; Paint() end)
        toggle:SetScript("OnLeave", function() hovered = false; Paint() end)
        toggle:SetScript("OnClick", function()
            if found then
                -- During a search a click folds the heading's matches for
                -- this search only; the saved open state stays as it was.
                this.folded = not this.folded
            else
                this.open = not this.open
                ns.SetGroupOpen(title, this.open)
                for _, member in ipairs(members) do member.shown = this.open end
            end
            page.Layout()
            page.Refresh()
        end)
        Tooltip(toggle, title, detail)
        page.OnRefresh(function()
            count:SetText(summary and summary() or "")
            Paint()
        end)
        -- toggle: the header; summary: its grey state; plus: the upright bar
        -- shown while closed (read by the tests).
        this.toggle, this.summary, this.plus = toggle, count, down
        page.groups[title] = this
        group = this
        return this
    end

    -- How to use (AGENTS.md "Shared UI style"): the page's last
    -- heading, always open, gathering what is text and not a setting (the
    -- mouse, the commands) in one place. Drawn like a group's heading without
    -- the box, it takes no click and saves no open state; its blocks are
    -- page.Topic labels and page.Note lines.
    function page.Help(summary, detail)
        assert(not page.groups[HELP], "two How to use sections")
        CloseMore()
        Start()
        group = nil
        -- Its own tab (AGENTS.md "How to use"): two flat tabs after
        -- the page's top, Settings and How to use. Not saved: the page opens
        -- on Settings.
        local tabFrame, tabBlock = page.Block(28)
        table.remove(page.blocks)
        table.insert(page.blocks, page.topCount + 1, tabBlock)
        tabBlock.tabs = true
        page.tabs = tabBlock
        local tabs = {}
        for index, entry in ipairs({ { "settings", "Settings" }, { "help", HELP } }) do
            local tab = ButtonWidget(tabFrame, NAME_X + (index - 1) * 104, -3, 100, entry[2])
            tab.label:SetJustifyH("CENTER")
            local underline = tab:CreateTexture(nil, "OVERLAY")
            underline:SetPoint("BOTTOMLEFT", 1, 1)
            underline:SetPoint("BOTTOMRIGHT", -1, 1)
            underline:SetHeight(2)
            underline:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
            tab.underline, tab.key = underline, entry[1]
            tab:SetScript("OnClick", function()
                page.tab = entry[1]
                if scroll then scroll:SetVerticalScroll(0) end
                page.Layout()
                page.Refresh()
            end)
            tabs[index] = tab
        end
        page.tabButtons = tabs
        page.OnRefresh(function()
            for _, tab in ipairs(tabs) do
                local on = page.tab == tab.key
                tab.underline:SetShown(on)
                tab.label:SetTextColor(on and GOLD[1] or GREY[1], on and GOLD[2] or GREY[2], on and GOLD[3] or GREY[3])
            end
        end)
        inHelp = true
        local frame, block = page.Block(ROW + 4)
        local this = { title = HELP, open = true, always = true, members = {}, block = block }
        block.heading = this
        local head = CreateFrame("Frame", nil, frame)
        head:SetPoint("TOPLEFT", NAME_X, -4)
        head:SetSize(FULL, 22)
        head:EnableMouse(true)
        local heading = head:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        heading:SetPoint("BOTTOMLEFT", 2, 5)
        heading:SetText(HELP)
        heading:SetTextColor(0.92, 0.92, 0.92)
        local count = head:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        count:SetPoint("BOTTOMLEFT", heading, "BOTTOMRIGHT", 10, 0)
        count:SetPoint("RIGHT", -4, 0)
        count:SetJustifyH("LEFT")
        count:SetTextColor(GREY[1], GREY[2], GREY[3])
        local line = head:CreateTexture(nil, "ARTWORK")
        line:SetPoint("BOTTOMLEFT", 0, 0)
        line:SetPoint("BOTTOMRIGHT", 0, 0)
        line:SetHeight(1)
        line:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.45)
        Tooltip(head, HELP, detail)
        page.OnRefresh(function() count:SetText(summary and summary() or "") end)
        -- head: the heading; summary: its grey state; detail: its tooltip
        -- (read by the tests).
        this.head, this.summary, this.detail = head, count, detail
        page.groups[HELP] = this
        group = this
        return this
    end
    -- A small gold label inside How to use: what the notes after it are about.
    function page.Topic(title)
        assert(group and group.always, "a topic belongs under How to use")
        local frame, block = page.Block(22)
        block.topic = title
        Text(frame, title, NAME_X + 2, -8, GOLD, FULL - 4)
        return block
    end
    -- One line of How to use: what, then how in grey; plain text, no strip,
    -- so it reads as a note and not a setting. detail is its tooltip; a line
    -- too long for its column wraps and the note grows to fit. how may be a
    -- function for a line that follows a setting, set on each refresh.
    function page.Note(label, how, detail)
        assert(group and group.always, "a note belongs under How to use")
        local frame, block = page.Block(20)
        local note = { frame = frame, label = label, detail = detail, block = block }
        page.notes[#page.notes + 1] = note
        block.row = note
        frame:EnableMouse(true)
        note.name = Text(frame, label, NAME_X + 2, -4, nil, NAME_W - 4)
        note.how = Text(frame, type(how) == "function" and "" or how, C1 + 4, -4, GREY, WIDE)
        if type(how) == "function" then page.OnRefresh(function() note.how:SetText(how() or "") end) end
        local tall = math.max(note.name:GetStringHeight() or 0, note.how:GetStringHeight() or 0)
        if tall > 14 then
            block.height = math.ceil(tall) + 8
            frame:SetHeight(block.height)
        end
        Tooltip(frame, label, detail)
        return note
    end

    -- Hover a row, see its part (AGENTS.md "Previews in settings"):
    -- the preview of the row's heading, else the pinned one, holds still and
    -- outlines what the row changes. nil clears it.
    local pointed
    function page.Point(row)
        local preview = row and ((row.block.group and row.block.group.preview) or page.pinned)
        if pointed and pointed ~= preview then pointed.Point(nil) end
        pointed = preview
        if preview then preview.Point(row.part, row.label) end
    end

    -- One setting: its name, then its controls. part: what the row
    -- changes in the preview (preview.parts), if anything. height: a taller
    -- row for a read-out that may take two lines.
    function page.Row(label, detail, part, height)
        Start()
        local frame, block = page.Block(height or ROW)
        -- keys: the settings its controls change (read by the tests);
        -- settings: their adapters, for Changed.
        -- source: who does the setting's work (SOURCES), or nil.
        local source = Source(label)
        local row = { frame = frame, label = label, detail = detail, controls = {}, keys = {}, settings = {}, source = source,
            part = part, block = block }
        page.rows[label] = row
        page.list[#page.list + 1] = row
        block.row = row
        if fine and group and group.fine then
            block.fine = true
            group.fine[#group.fine + 1] = row
        end
        local point = part and function(over) page.Point(over and row or nil) end or nil
        row.name = Strip(frame, NAME_X, -2, NAME_W, label, source)
        Tooltip(row.name, label, detail, source, point)
        -- own: a control's own tooltip text instead of the row's.
        local function Keep(control, own)
            row.controls[#row.controls + 1] = control
            Tooltip(control, label, own or detail, source, point)
            return control
        end
        local function Track(setting)
            if setting.key then row.keys[#row.keys + 1] = setting.key end
            row.settings[#row.settings + 1] = setting
            return setting
        end
        -- On or Off; a click switches. name (0.3.0): on a row of two, a
        -- button says its own ("Unlocked: Off"; AGENTS.md "Two settings, one
        -- row").
        function row:Toggle(x, key, width, name)
            local setting = Track(Adapter(key))
            local button = Keep(ButtonWidget(frame, x, -2, width or CW, ""))
            button.label:SetJustifyH("CENTER")
            button:SetScript("OnClick", function()
                setting.set(not (setting.get() == true))
                page.Refresh()
            end)
            page.OnRefresh(function()
                local on = setting.get() == true
                button.label:SetText((name and (name .. ": ") or "") .. (on and "On" or "Off"))
                button.label:SetTextColor(on and GOLD[1] or GREY[1], on and GOLD[2] or GREY[2], on and GOLD[3] or GREY[3])
            end)
            return button
        end
        -- < Value >: a click picks the next choice, a right-click the one
        -- before. With four or more choices a click opens the workspace's
        -- flat dropdown list under the button instead (FlatMenu.lua; AGENTS.md
        -- "Shared UI style"): the current choice's box is gold, a click on a
        -- row picks it, and a click elsewhere, the button again or Escape (out
        -- of combat) closes it. Without FlatMenu.lua (a missing file) every
        -- choice steps. Since 0.4.0 the choice under the mouse shows in the preview
        -- (page.Try) until the mouse leaves it or the list closes; only a
        -- click writes it.
        function row:Choice(x, key, labels, width)
            local setting = Track(Adapter(key))
            local button = Keep(ButtonWidget(frame, x, -2, width or CW, ""))
            button.label:SetJustifyH("CENTER")
            local listed = #setting.options >= 4 and ns.FlatMenu ~= nil
            button.dropdown = listed
            if listed then
                button.label:SetJustifyH("LEFT")
                button.label:SetPoint("RIGHT", -20, 0)
                ns.FlatMenu.DownArrow(button)
            end
            button:SetScript("OnClick", function(_, mouse)
                if listed then
                    ns.FlatMenu.Open(button, function(_, root)
                        for _, value in ipairs(setting.options) do
                            local name = labels[value] or tostring(value)
                            local radio = root:CreateRadio(name,
                                function() return setting.get() == value end,
                                function() setting.set(value); page.Refresh() end)
                            if setting.key then
                                radio:SetOnEnter(function() page.Try({ [setting.key] = value }, label .. ": " .. name) end)
                                radio:SetOnLeave(function() page.Try(nil) end)
                            end
                        end
                        root:AddMenuReleasedCallback(function() page.Try(nil) end)
                    end)
                    return
                end
                local options = setting.options
                local index = 1
                for i, option in ipairs(options) do
                    if option == setting.get() then index = i end
                end
                index = index + (mouse == "RightButton" and -1 or 1)
                if index > #options then index = 1 elseif index < 1 then index = #options end
                setting.set(options[index])
                page.Refresh()
            end)
            page.OnRefresh(function()
                local value = setting.get()
                if listed then
                    button.label:SetText(labels[value] or tostring(value))
                else
                    button.label:SetText(GREY_TEXT .. "<|r  " .. (labels[value] or tostring(value)) .. "  " .. GREY_TEXT .. ">|r")
                end
            end)
            return button
        end
        -- A flat track with a gold thumb, the value after it, and the reset
        -- arrow at the end; format(value) writes the value. In a side column
        -- the value is narrower, so the track keeps room beside the arrow.
        -- (AGENTS.md, "Step arrows"): a grey < and > either side of
        -- the track step it one notch for fine tuning, through setting.set
        -- as a drag does, snapped to the step and kept in range; each is dim
        -- at its end of the range. The track is 16 px shorter for them.
        function row:Slider(x, key, step, unit, width)
            local setting = Track(Adapter(key))
            unit = unit or ""
            width = width or CW
            local low, high = setting.limits[1], setting.limits[2]
            local default = type(setting.default) == "number" and setting.default or nil
            setting.step = step
            local valueWidth = default and (width <= CW and 38 or 46) or 48
            local control = Keep(CreateFrame("Slider", nil, frame))
            control:SetPoint("TOPLEFT", x + 12, -4)
            control:SetSize(width - (default and 44 + valueWidth or 72), 18)
            control:SetOrientation("HORIZONTAL")
            control:SetMinMaxValues(low, high)
            control:SetValueStep(step)
            control:SetObeyStepOnDrag(true)
            control:SetThumbTexture(WHITE)
            control:GetThumbTexture():SetSize(8, 16)
            control:GetThumbTexture():SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
            local track = control:CreateTexture(nil, "BACKGROUND")
            track:SetPoint("LEFT")
            track:SetPoint("RIGHT")
            track:SetHeight(4)
            track:SetColorTexture(0.22, 0.24, 0.27, 1)
            local function Format(number)
                if setting.format then return setting.format(number) end
                return tostring(number) .. unit
            end
            -- The value one notch from the current one, snapped as a drag
            -- snaps, or nil at the end of the range.
            local function Stepped(direction)
                local current = setting.get()
                if type(current) ~= "number" then current = low end
                local number = math.max(low, math.min(high, math.floor((current + direction * step) / step + 0.5) * step))
                if not Differs(number, current, step) then return nil end
                return number
            end
            local function Arrow(direction)
                local arrow = CreateFrame("Button", nil, control)
                arrow:SetSize(10, 18)
                arrow.label = arrow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                arrow.label:SetPoint("CENTER")
                arrow.label:SetText(direction < 0 and "<" or ">")
                function arrow.Paint()
                    local lit = Stepped(direction) ~= nil
                    if lit and arrow.hovered then arrow.label:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
                    elseif lit then arrow.label:SetTextColor(GREY[1], GREY[2], GREY[3])
                    else arrow.label:SetTextColor(0.25, 0.25, 0.27) end
                end
                arrow:SetScript("OnEnter", function() arrow.hovered = true; arrow.Paint() end)
                arrow:SetScript("OnLeave", function() arrow.hovered = false; arrow.Paint() end)
                Tooltip(arrow, direction < 0 and "One step down" or "One step up", function()
                    local number = Stepped(direction)
                    if number then return "Sets " .. Format(number) .. "." end
                    return direction < 0 and "Already at the lowest value." or "Already at the highest value."
                end)
                arrow:SetScript("OnClick", function()
                    local number = Stepped(direction)
                    if not number then return end
                    setting.set(number)
                    page.Refresh()
                    arrow.Paint()
                end)
                return arrow
            end
            local down, up = Arrow(-1), Arrow(1)
            down:SetPoint("RIGHT", control, "LEFT", -1, 0)
            up:SetPoint("LEFT", control, "RIGHT", 1, 0)
            control.down, control.up = down, up
            local value = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            value:SetPoint("LEFT", up, "RIGHT", 1, 0)
            value:SetWidth(valueWidth)
            value:SetJustifyH("RIGHT")
            control.readout = value
            local reset, changed
            if default then
                reset = CreateFrame("Button", nil, frame)
                reset:SetSize(14, 14)
                reset:SetPoint("LEFT", value, "RIGHT", 2, 0)
                reset.art = reset:CreateTexture(nil, "ARTWORK")
                reset.art:SetAllPoints()
                reset:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_NONE")
                    GameTooltip:SetText("Reset to default")
                    GameTooltip:Show()
                    PlaceTooltip(GameTooltip, self)
                end)
                reset:SetScript("OnLeave", function() GameTooltip:Hide() end)
                reset:SetScript("OnClick", function()
                    if not changed then return end
                    setting.set(default)
                    page.Refresh()
                end)
                control.reset = reset
            end
            local function Paint()
                down.Paint()
                up.Paint()
                if not reset then return end
                changed = Differs(setting.get(), default, step)
                ResetArt(reset.art, changed)
            end
            local refreshing = false
            page.OnRefresh(function()
                refreshing = true
                local current = setting.get() or low
                control:SetValue(math.max(low, math.min(high, current)))
                value:SetText(Format(current))
                refreshing = false
                Paint()
            end)
            control:SetScript("OnValueChanged", function(_, raw)
                local number = math.max(low, math.min(high, math.floor(raw / step + 0.5) * step))
                value:SetText(Format(number))
                if refreshing then return end
                setting.set(number)
                Paint()
            end)
            return control
        end
        function row:Button(x, text, onClick, width, own)
            local button = Keep(ButtonWidget(frame, x, -2, width or CW, text), own)
            button:SetScript("OnClick", function(clicked, mouse) onClick(clicked, mouse); page.Refresh() end)
            return button
        end
        -- A row of two (AGENTS.md "Two settings, one row", 0.3.0): the
        -- second control's own tooltip. The page has no preview parts, so
        -- it carries no part of its own.
        function row:Tip(control, title, tipDetail)
            control.tip = { title = title, detail = tipDetail }
            return control
        end
        -- The second control dims while the setting it depends on is off
        -- (enabled() false), and still works.
        function row:DependsOn(control, enabled)
            page.OnRefresh(function()
                local alpha = enabled() and 1 or 0.45
                -- A slider's arrows, value and reset arrow dim with it.
                control:SetAlpha(alpha)
                for _, key in ipairs({ "down", "up", "reset", "readout" }) do
                    local piece = control[key]
                    if type(piece) == "table" and piece.SetAlpha then piece:SetAlpha(alpha) end
                end
            end)
            return control
        end
        -- Grey text in a control column: a read-only row, or a Mouse entry.
        function row:Status(fn, x, width)
            local status = Text(frame, "", (x or C2) + 4, -7, GREY, width or (CW + 30))
            row.status = status
            page.OnRefresh(function() status:SetText(fn() or "") end)
            return status
        end
        return row
    end

    -- Forever Settings' search (as Forever Settings 0.4.0). Its window hands
    -- the page the lower-case words typed in its search box, less those in
    -- the page's name: Count says how many rows hold every word, Show draws
    -- only those rows under their headings (nil draws the whole page again).
    -- A row is found by what it draws (its name, value or status), its
    -- tooltip and its heading's title, so a heading's title brings all its
    -- rows; the header waits.
    local function Drawn(frame, parts)
        for _, region in ipairs({ frame:GetRegions() }) do
            if region:IsObjectType("FontString") then parts[#parts + 1] = region:GetText() end
        end
        for _, child in ipairs({ frame:GetChildren() }) do Drawn(child, parts) end
        return parts
    end
    local function Holds(text, words)
        text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):lower()
        for _, word in ipairs(words) do
            if not text:find(word, 1, true) then return false end
        end
        return true
    end
    local function Match(words)
        local set, count, whole, last = {}, 0, false, false
        for _, block in ipairs(page.blocks) do
            if block.heading then
                whole = Holds(block.heading.title, words)
                last = whole
            elseif block.topic then
                last = whole
            elseif block.row then
                local parts = Drawn(block.frame, { block.row.detail or "", block.group and block.group.title or "" })
                -- A row of two: the second control's own name and detail.
                for _, control in ipairs(block.row.controls or {}) do
                    local tip = control.tip
                    if tip then
                        parts[#parts + 1] = tip.title or ""
                        parts[#parts + 1] = type(tip.detail) == "string" and tip.detail or ""
                    end
                end
                last = whole or Holds(table.concat(parts, "\n"), words)
                if last then count = count + 1 end
            end
            if last then
                set[block] = true
                if block.group then set[block.group.block] = true end
            end
        end
        -- A How to use topic shows whenever a note under it does.
        local topic
        for _, block in ipairs(page.blocks) do
            if block.topic then topic = block
            elseif block.heading then topic = nil
            elseif topic and set[block] then set[topic] = true end
        end
        -- A heading with matches keeps its column titles, and a heading's
        -- preview shows whenever a row under it does (the pinned
        -- preview is above the rows and always shows).
        for _, block in ipairs(page.blocks) do
            if (block.columns or block.preview) and block.group and set[block.group.block] then set[block] = true end
        end
        return set, count
    end
    -- A panel page's window (the panel kit's) shows it; it answers no search.
    if host then return page end
    panel.ForeverSettingsSearch = {
        Count = function(words)
            local _, count = Match(words)
            return count
        end,
        Show = function(words)
            local count = 0
            found = nil
            if type(words) == "table" and #words > 0 then found, count = Match(words) end
            for _, block in ipairs(page.blocks) do
                if block.heading then block.heading.folded = nil end
            end
            scroll:SetVerticalScroll(0)
            page.Layout()
            page.Refresh()
            return count
        end,
    }

    -- The page opens on its Settings tab; the last heading's More
    -- line is made here when no How to use came after it.
    panel:SetScript("OnShow", function()
        CloseMore()
        page.tab = "settings"
        page.Layout()
        page.Refresh()
    end)
    return page
end

local POSITIONS = ns.POSITION_LABELS

local function Px(value) return value .. " px" end
local function Tenths(value) return string.format("%.1f s", value / 10) end

local function Build()
    local page = NewPage("Forever GCD", false)
    local header = page.Block(52)
    Text(header, "Forever GCD " .. ns.Version, NAME_X, -10, GOLD, NAME_W + 60)
    Text(header, "What an enemy just did", C2 + 4, -10, GREY, FULL - C2)
    local status = Text(header, "", NAME_X, -28, nil, FULL)
    page.OnRefresh(function()
        local text = (ns.StatusText():gsub("^%l", string.upper))
        status:SetText((ns.FlashAvailable() and GREY_TEXT or AMBER_TEXT) .. text .. "|r")
    end)

    -- Move the target bar: it hides until there is a target, so it moves
    -- from the gold panel at the top. Unlocking turns the bar on.
    local function BarLocked() return not (ns.Get("bar") == true and ns.Get("barLocked") ~= true) end
    local function SetBarLocked(locked)
        if locked then
            ns.Set("barLocked", true)
        else
            ns.Set("bar", true)
            ns.Set("barLocked", false)
        end
    end
    local move = page.Move({
        title = "Move the target bar",
        hint = "It shows your target's flashes. Unlock to see it with samples, then drag it where you want; unlocking turns the bar on.",
        locked = BarLocked,
        setLocked = SetBarLocked,
        onScreen = function() ns.PlaySamples(20) end,
        screenTip = "Play the sample flashes for 20 seconds on every nameplate on screen (friendly ones too) and on your real target bar where it sits, locked or not, on or off. The same as /fgcd preview.",
        unlockTip = "Turn the target bar on and unlock it so it shows samples you can drag. The same as /fgcd unlock.",
        lockTip = "Lock the bar where it is: it then shows your target's flashes, and clicks go through it. The same as /fgcd lock.",
        how = "Drag the bar or its strip to move it (not in combat) · drag the dots at its corner to resize · right-click it to lock it · the gear on its strip opens its settings",
    })
    if not move then
        local row = page.Row("Move the bar", "Unlock to move turns the target bar on and unlocks it so you can drag it; Lock in place locks it again. Show on screen plays samples on it and on every nameplate on screen for 20 seconds.")
        local toggle = row:Button(C1, "", function() SetBarLocked(not BarLocked()) end)
        toggle.label:SetJustifyH("CENTER")
        page.OnRefresh(function() toggle.label:SetText(BarLocked() and "Unlock to move" or "Lock in place") end)
        row:Button(C2, "Show on screen", function() ns.PlaySamples(20) end).label:SetJustifyH("CENTER")
    end

    page.Group("What flashes", true, function()
        local on = {}
        if ns.Get("casts") then on[#on + 1] = "casts" end
        if ns.Get("buffs") then on[#on + 1] = "buffs" end
        if ns.Get("debuffs") then on[#on + 1] = "duel debuffs" end
        return #on > 0 and table.concat(on, " · ") or "nothing"
    end, "The three routes to what an enemy did. Each flash has its own edge colour: gold for a cast, green for their new buff, red for your new debuff.")
    page.Row("Their casts", "An enemy's casts as they start, the moment their global cooldown starts, and their instants, when the game tells addons about them. A cast they cancel by moving takes its icon away. The spell is hidden from the addon, but its name and icon still show. Most enemy instants send nothing; the next two rows cover many of those. Gold edge.")
        :Toggle(C1, "casts", SINGLE)
    page.Row("Their new buffs", "A buff new to the enemy (a shield, Ghost Wolf, Blood Fury), found and drawn by the game's own aura code, in fights too. A buff refreshed or ending shows nothing. Green edge.")
        :Toggle(C1, "buffs", SINGLE)
    page.Row("Your new debuffs", "In a duel, a debuff new to you (Shadow Word: Pain, Concussive Shot) shows on your opponent's plate, and on the target bar while they are your target. In a duel only they can have put it there; outside duels nothing is guessed. Red edge.")
        :Toggle(C1, "debuffs", SINGLE)

    page.Group("Nameplates", true, function()
        if ns.Get("plates") ~= true then return "off" end
        return POSITIONS[ns.Get("position")]:lower() .. " · " .. Px(ns.Get("size"))
    end, "The flashes over every enemy nameplate.")
    -- Rows of two (0.3.0; AGENTS.md "Two settings, one row"): the switch
    -- and the icon's size, where the icon sits and how far out. The second
    -- control starts in the middle column and keeps a full track.
    local plates = page.Row("Show on plates", "Flashes on every enemy nameplate. The slider beside it sets the icon's size.")
    plates:Toggle(C1, "plates")
    plates:DependsOn(plates:Tip(plates:Slider(C2, "size", 1, " px", SINGLE),
        "Icon size", "How large the icon is on plates (16 to 64 px)."),
        function() return ns.Get("plates") == true end)
    local place = page.Row("Position and gap", "Left or right of the plate, the icon centred on its health bar, or above it. Show on screen plays samples on every plate up.")
    place:Choice(C1, "position", POSITIONS)
    place:Tip(place:Slider(C2, "offset", 1, " px", SINGLE),
        "Gap", "Space between the plate and the icon (-20 to 60 px).")

    page.Group("Look", false, function()
        return Tenths(ns.Get("tenths")) .. (ns.Get("name") and " · spell name" or "")
    end, "How each flash looks and how long it stays, on plates and the bar.")
    page.Row("Shown for", "How long each flash stays while the sweep ticks down over its icon (0.5 to 4 s). 1.5 s is a global cooldown. In a fight, flashes already made change once the fight ends.")
        :Slider(C1, { key = "tenths", get = function() return ns.Get("tenths") end, set = function(value) ns.Set("tenths", value) end,
            limits = ns.Limits.tenths, format = Tenths, default = ns.Default("tenths") }, 1, nil, SINGLE)
    -- A row of two (0.3.0): the name and its size, dimmed while it is off.
    local name = page.Row("Spell name", "The spell's name under the icon. The slider beside it sets its size.")
    name:Toggle(C1, "name")
    name:DependsOn(name:Tip(name:Slider(C2, "nameSize", 1, "", SINGLE),
        "Name size", "The size of the spell's name (8 to 20)."),
        function() return ns.Get("name") == true end)

    page.Group("Target bar", false, function()
        if ns.Get("bar") ~= true then return "off" end
        return (ns.Get("barLocked") and "locked" or "unlocked") .. " · " .. Px(ns.Get("barSize"))
    end, "Your target's flashes on a bar of their own, anywhere on screen. Off by default.")
    -- Rows of two (0.3.0; AGENTS.md "Two settings, one row"): the bar and
    -- its icon size, dimmed while it is off; Unlock and Reset position.
    local bar = page.Row("Show bar", "Your target's flashes on a bar where you put it. Locked, it shows only flashes, and clicks go through it. The slider beside it sets the bar's icon size.")
    bar:Toggle(C1, "bar")
    bar:DependsOn(bar:Tip(bar:Slider(C2, "barSize", 1, " px", SINGLE),
        "Bar icon size", "How large the icon on the bar is (16 to 64 px). The grip in the unlocked bar's corner sets it too."),
        function() return ns.Get("bar") == true end)
    local unlock = page.Row("Unlock and reset", "Unlocked, the bar plays samples under a thin strip with its name and a gear: drag to move (out of combat), drag its corner to resize, right-click to lock. Unlocking turns the bar on.")
    unlock:Toggle(C1, { key = "barLocked", get = function() return ns.Get("bar") == true and ns.Get("barLocked") ~= true end,
        set = function(unlocked) SetBarLocked(not unlocked) end }, nil, "Unlocked")
    unlock:Tip(unlock:Button(C2, "Reset position", function() ns.ResetBarPosition() end, SINGLE),
        "Reset position", "Put the bar back at its first place, below the middle of the screen.").label:SetJustifyH("CENTER")

    local mouse = {
        { "Move panel", "Unlock to move, at the top of the page", "Unlock to move turns the target bar on and unlocks it; Lock in place locks it. Show on screen plays samples on it and on every nameplate on screen for 20 seconds." },
        { "Move the bar", "Drag the unlocked bar", "Drag the unlocked bar, or its strip, to move it. Out of combat only." },
        { "Resize the bar", "Drag its corner", "Drag the six dots at the unlocked bar's corner to change its icon size. Double-click them for the default size." },
        { "Lock the bar", "Right-click the unlocked bar", "Right-click the unlocked bar to lock it: it then shows your target's flashes, and clicks go through it." },
        { "Bar settings", "The gear on the unlocked bar", "The gear on the unlocked bar's strip opens a short menu: what flashes, nameplates, spell name, bar icon size, shown for, and All options." },
        { "Read a flash", "Its edge's colour", "Gold: a cast or instant the game told addons about. Green: a buff new to them. Red: a debuff new to you, in a duel. The sweep over the icon ticks down over Shown for." },
    }
    local commands = {
        { "Settings and list", "", "Open this page and list every command in chat." },
        { "Status", "status", "Say in chat how many enemy plates are watched." },
        { "Unlock the bar", "unlock", "Turn the target bar on and unlock it." },
        { "Lock the bar", "lock", "Lock the target bar." },
        { "Samples", "preview", "Play sample flashes on every nameplate on screen and the target bar for 20 seconds." },
        { "Open settings", "options", "Open this page without listing the commands." },
        { "List commands", "help", "List every command in chat." },
    }
    page.Help(function() return #mouse .. " controls · " .. #commands .. " commands" end,
        "What the mouse does on the target bar, how to read a flash, and the chat shortcuts.")
    page.Topic("Mouse")
    for _, line in ipairs(mouse) do page.Note(line[1], line[2], line[3]) end
    page.Topic("Commands")
    for _, command in ipairs(commands) do
        page.Note(command[1], "/fgcd" .. (command[2] ~= "" and (" " .. command[2]) or ""), command[3])
    end
    return page
end

function ns.CreateSettings()
    local page = Build()
    local category = Settings.RegisterCanvasLayoutCategory(page.panel, "Forever GCD")
    Settings.RegisterAddOnCategory(category)
    ns.settingsPage = page
    function ns.RefreshSettings()
        if page.panel:IsShown() then page.Refresh() end
    end
    function ns.OpenSettings()
        -- With Forever Settings installed the page opens in its window, in
        -- combat too (ForeverSettings.OpenPage); false means Options > AddOns.
        if type(ForeverSettings) == "table" and type(ForeverSettings.OpenPage) == "function"
            and ForeverSettings.OpenPage(category:GetID()) == true then
            return
        end
        -- Settings.OpenToCategory calls the restricted C_SettingsUtil.OpenSettingsPanel.
        if InCombatLockdown() then print("Forever GCD: open Options > AddOns > Forever GCD after combat."); return end
        Settings.OpenToCategory(category:GetID())
    end
end
