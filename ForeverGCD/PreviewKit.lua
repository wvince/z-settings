-- The workspace's preview kit: the live preview boxes on the settings pages
-- (AGENTS.md "Previews in settings"; the user's choices of 11 October 2026).
-- The master is tools/preview-kit/PreviewKit.lua. Each addon whose settings
-- page shows a preview keeps an identical copy at its root, listed in its TOC
-- before Settings.lua. Change only the master, test it with
--   lua5.1 tools/preview-kit/tests/run.lua
-- and copy it out with tools/preview-kit/Sync-PreviewKit.ps1. A page must
-- still work if the file is missing (ns.PreviewKit nil: no preview, nothing
-- else changes).
--
-- A preview box is a grey line saying what the samples are (with a Show on
-- screen button at its end when the samples can be played on the real
-- screen), over a strip the samples stand on: a dim strip of world (a dusk
-- sky over grass and earth, drawn here, no art of its own), or a plain fill
-- for things that are opaque in game. The samples are the addon's own frames,
-- drawn by its own code from fixed plain values; the kit only holds them.
--
-- Calls:
--   ns.PreviewKit.New(frame, options) -> preview. frame is the box's frame
--     (a settings block or a pinned header). options:
--       x, width     the strip's left edge and width in frame (14, 508)
--       onScreen     function: the Show on screen button calls it
--       screenTip    that button's tooltip text
--       plain        a colour { r, g, b } for an opaque strip instead of world
--       resize       function(height): the box needs this height
--   preview.holder   samples hang from it; preview.top is where they start
--                    below its top, preview.left where they start across it
--   preview.text     a layer above the samples; preview.Caption(width) makes
--                    a grey caption on it: one line without width, wrapped
--                    to width (and as many lines as it needs) with it
--   preview.SetLabel(text)   the grey line (it wraps; the strip moves down
--                            by preview.labelDrop, also kept as
--                            preview.extra, which is the kit's name: give
--                            an addon's own fields other names)
--   preview.Fit(bottom)      the lowest sample edge below the holder's top;
--                            calls options.resize with the box's height
--   preview.Lift()   keeps the captions, outlines, tag and Show on screen
--                    above every sample, however high the addon set a
--                    sample's frame level (Settle, Fit and Point call it)
--   preview.loops[i] = { play(now, first), step(now), done(), still(), stop() }
--                    motion: a sample plays (first: the first run after a
--                    change, which may start part-way), steps each frame
--                    until done, waits a moment and plays again. Loops run
--                    only while the box is on screen and nothing is pointed.
--   preview.parts[part] = function() return regions, whole end
--                    what a settings row's part names; whole is outlined
--                    instead (tagged "not shown") when no region shows
--   preview.Settle() after any change: samples start again (or are drawn
--                    still while a row is pointed) and a pointed part is
--                    outlined where it is now
--   preview.Point(part, name)  a row is hovered (nil: left): samples hold
--                    still, a gold box round each shown region of the part,
--                    the row's name in a gold tag
--   Click a part to find its setting (kit 3; the user's choice of 13 October
--   2026). With options.find(parts) given (and options.names(parts), the
--   rows' names for the tag):
--     the grey line ends with a gold "click a part to find its setting";
--     every shown region of preview.parts gets an invisible button over it
--     (preview.hotspots), rebuilt by Settle; while the mouse is on the strip
--     each has a faint gold outline, the one under the mouse is pointed (its
--     rows' names in the tag) and the pointer is Blizzard's magnifying glass
--     (SetCursor "INSPECT_CURSOR", as InputUtil.lua's inspect cursor);
--     a click calls options.find(parts) with every part that region draws;
--     each time the box is shown the outlines pulse three times under a
--     small gold note (preview.Pulse), every time, not only the first.
--   preview.Mark(part, text)  the thing a page's picker has picked (kit 4;
--                    its boxes are preview.markBoxes, a name no addon
--                    used for its own field):
--                    a thick gold box round each shown region of the part,
--                    held through every change, with text (default
--                    "Editing") in a gold tag on it; nil clears it
--   Found rows (kit 4; the user, 14 October 2026: a click on a part must
--   not scroll the page, it shows the rows that change it instead):
--   ns.PreviewKit.Found(scroll, strips, names)  each strip (a row's name
--                    strip) gets a gold glow and a gold arrow at its left
--                    that pulse three times and hold for a few seconds;
--                    the page does not move. When some of them are out of
--                    sight, a gold bar along the bottom (or top) of scroll
--                    says how many and names them (names[i] for strips[i]);
--                    a click on it glides the page to them. It goes once
--                    they are in sight, or after ten seconds.
--   The picker (kit 4; the user, 14 October 2026: the thing that chooses
--   which bar or lane the rows change must be impossible to miss):
--   ns.PreviewKit.Picker(frame, options) -> picker. frame is a settings
--                    block; options:
--       x, width     the panel's left edge and width in frame (14, 508)
--       title        the big gold line ("Choose a lane to edit")
--       hint         grey words after it
--       choices      function: { { key =, label = }, ... }
--       get, set     the picked key; set(key) picks one
--       tip          function(choice): a chip's tooltip line
--       noun         what the rows change, for the line under the chips
--       resize       function(height): the block needs this height
--     A gold-edged panel with a gold bar down its left: the title, a chip
--     per choice (the picked one solid gold), then "The rows below change:
--     <label>". The bar runs on down the left of the rows it controls.
--     picker.Refresh()  repaint after a pick or a rename (refits)
--     picker.Rail(frames)  the rows' frames: the bar runs down to the last
--                    one shown (call after each layout)
--     picker.Pulse()   the panel's edge and the picked chip pulse three
--                    times; it runs each time the block is shown
--   The move panel (kit 5; the user, 15 October 2026: boxes that hide until
--   something happens are moved from a panel at the top of their page that
--   cannot be missed, with Show on screen always beside Unlock; the
--   settings window stays open, closing it is the player's choice):
--   ns.PreviewKit.Move(frame, options) -> move. frame is a settings block
--                    at the top of the page; options:
--       x, width     the panel's left edge and width in frame (14, 508)
--       title        the big gold line ("Move the displays")
--       hint         grey words under it: when the boxes show, what to do
--       locked()     true while every box is locked
--       setLocked(on)  lock every box (true) or unlock them (false)
--       onScreen     Show on screen: plays samples on the real boxes
--       screenTip, unlockTip, lockTip  the buttons' tooltips
--       how          words or function: the amber line while unlocked
--                    (what the mouse does to an unlocked box)
--       parts        optional function: { { label =, locked = fn, set =
--                    fn(on) }, ... }, a chip per box that locks on its own
--       resize       function(height): the block needs this height
--     A gold-edged panel with a gold bar inside its left: the title, the
--     hint, Unlock to move (solid gold) or Lock in place, Show on screen
--     and Locked or Unlocked, then the chips, then the amber line. No
--     button closes the settings window. It pulses each time shown.
--     move.Refresh()   repaint after a lock change (refits)
--     move.Pulse()
--   ns.PreviewKit.PlaceTooltip(tip, owner)  kit 6 (15 October 2026): puts
--                    a filled, shown tooltip beside the window that holds
--                    owner, level with owner, so it never covers its row;
--                    the kit's own chips and buttons use it
--   ns.PreviewKit.MatchStrata(sample, holder)  a sample takes its holder's
--                    strata (settings windows are HIGH; addon frames often
--                    set MEDIUM, which would draw behind the page)
--   ns.PreviewKit.Scale(width, scale, notes, room, height, roomHeight)  the
--                    scale to draw a sample at, shrunk to fit room across
--                    (496) and, given height and roomHeight, roomHeight
--                    down; notes gets what to say
--   ns.PreviewKit.Flow(sizes, room, gap, lineGap) -> places, height, width
--                    samples side by side, a new line when the next would
--                    pass room (496): sizes[i] = { width, height } as drawn,
--                    places[i] = { x = , y = } from the first's top left,
--                    height and width of the whole (gap 12, lineGap 6)
--   ns.PreviewKit.Copy(settings)  a shallow copy of a settings table
--   ns.PreviewKit.GREY, .AMBER  colour codes for the grey line

local _, ns = ...

local Kit = {}
ns.PreviewKit = Kit

-- A settings tooltip never covers its row (kit 6, 15 October 2026; AGENTS.md
-- "Gears and quick settings"): it sits beside the window that holds the page
-- (owner's topmost frame below UIParent: Forever Settings' window, Blizzard's
-- Options or a gear panel), level with owner; right of the window when it
-- fits, else left, else under owner (over it when owner is low on the
-- screen). Call it after the tooltip is filled and shown, so its size is
-- known. With ANCHOR_RIGHT a tall tooltip met the top of the screen and was
-- pushed down over the row's slider (Forever Visibility, 15 October 2026).
local function Measure(value)
    if type(value) ~= "number" or (issecretvalue and issecretvalue(value)) then return nil end
    return value
end
function Kit.PlaceTooltip(tip, owner)
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
Kit.VERSION = 6

local WHITE = "Interface\\Buttons\\WHITE8X8"
local GOLD = { 0.95, 0.76, 0.35 }
local GREY = { 0.55, 0.55, 0.58 }
local BACKDROP = { bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 }
local EDGE = { edgeFile = WHITE, edgeSize = 1 }
Kit.GREY, Kit.AMBER = "|cff8c8c94", "|cffff9f1a"

local LABEL_TOP, SAMPLE_TOP, SAMPLE_LEFT = 4, 24, 6
local SCREEN_W, SCREEN_H = 104, 16
local LOOP_GAP = 0.6
-- Click a part to find its setting (kit 3): the hint after the grey line,
-- the note over the strip while the outlines pulse, and the pulse itself
-- (three beats).
local FIND_HINT = "|cffd9c08aclick a part to find its setting|r"
local FIND_NOTE = "Click any part to find its setting"
local PULSE_BEAT, PULSE_BEATS = 0.7, 3
local GHOST_ALPHA = 0.35
-- The world strip: a dusk sky over grass and earth.
local SKY, HORIZON, GROUND = { 0.2, 0.25, 0.3 }, { 0.25, 0.28, 0.22 }, { 0.16, 0.15, 0.12 }

local function Gradient(texture, top, bottom)
    texture:SetColorTexture(1, 1, 1, 1)
    texture:SetGradient("VERTICAL", CreateColor(bottom[1], bottom[2], bottom[3], 1), CreateColor(top[1], top[2], top[3], 1))
end

-- The workspace's flat button: a black edge, and on hover a gold line
-- inside it.
local function FlatButton(parent, text, width, height, tip)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(width, height)
    button:SetBackdrop(BACKDROP)
    button:SetBackdropColor(0.14, 0.145, 0.16, 1)
    button:SetBackdropBorderColor(0, 0, 0, 1)
    local gold = CreateFrame("Frame", nil, button, "BackdropTemplate")
    gold:SetPoint("TOPLEFT", 1, -1)
    gold:SetPoint("BOTTOMRIGHT", -1, 1)
    gold:SetBackdrop(EDGE)
    gold:SetBackdropBorderColor(0.8, 0.62, 0.25, 1)
    gold:Hide()
    button.gold = gold
    local label = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetPoint("CENTER", 0, 0)
    label:SetText(text)
    label:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    button.label = label
    button:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.24, 0.20, 0.12, 1)
        gold:Show()
        if tip then
            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetText(text)
            GameTooltip:AddLine(tip, 0.85, 0.85, 0.85, true)
            GameTooltip:Show()
            Kit.PlaceTooltip(GameTooltip, self)
        end
    end)
    button:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.14, 0.145, 0.16, 1)
        gold:Hide()
        if tip then GameTooltip:Hide() end
    end)
    return button
end

-- The kit's layers sit at least this many levels above the holder: the
-- captions, then the outlines and their tag. Lift raises them further when
-- a sample stands higher. The walk over the samples is bounded.
local TEXT_ABOVE, OUTLINE_ABOVE, LIFT_LIMIT = 20, 30, 2000

-- A frame's level as a plain number, or nil (GetFrameLevel can return a
-- secret: SecretReturnsForAspect FrameLevel).
local function Level(frame)
    if type(frame) ~= "table" or type(frame.GetFrameLevel) ~= "function" then return nil end
    local level = frame:GetFrameLevel()
    if issecretvalue and issecretvalue(level) then return nil end
    if type(level) ~= "number" then return nil end
    return level
end

-- The highest level among frame's descendants, leaving out the kit's own
-- layers (own) and stopping after LIFT_LIMIT frames.
local function Highest(frame, own, top, count)
    if type(frame.GetChildren) ~= "function" then return top, count end
    for _, child in ipairs({ frame:GetChildren() }) do
        if count >= LIFT_LIMIT then break end
        if type(child) == "table" and not own[child] then
            count = count + 1
            local level = Level(child)
            if level and level > top then top = level end
            top, count = Highest(child, own, top, count)
        end
    end
    return top, count
end

local function SetLevel(frame, level)
    if Level(frame) ~= level then frame:SetFrameLevel(level) end
end

-- A thin gold box round a region, drawn above the samples (thick: 2 px).
local function Outline(holder, level, thick)
    local box = CreateFrame("Frame", nil, holder)
    box:SetFrameLevel(level or (holder:GetFrameLevel() + OUTLINE_ABOVE))
    for _, side in ipairs({ { "TOPLEFT", "TOPRIGHT", true }, { "BOTTOMLEFT", "BOTTOMRIGHT", true },
        { "TOPLEFT", "BOTTOMLEFT" }, { "TOPRIGHT", "BOTTOMRIGHT" } }) do
        local line = box:CreateTexture(nil, "OVERLAY")
        line:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
        line:SetPoint(side[1])
        line:SetPoint(side[2])
        if side[3] then line:SetHeight(thick and 2 or 1) else line:SetWidth(thick and 2 or 1) end
    end
    box:Hide()
    return box
end

-- Whether the mouse is over a frame; IsMouseOver can return a secret
-- (SecretWhenAnchoringSecret), which counts as not over.
local function Over(frame)
    if not frame or type(frame.IsMouseOver) ~= "function" then return false end
    local over = frame:IsMouseOver()
    if issecretvalue and issecretvalue(over) then return false end
    return over == true
end

-- The pointer over a clickable part: Blizzard's magnifying glass, the
-- inspect cursor (GameCursorDocumentation SetCursor, ResetCursor).
local function Magnifier(on)
    if on then
        if SetCursor then SetCursor("INSPECT_CURSOR") end
    elseif ResetCursor then
        ResetCursor()
    end
end

-- The rough area of a region, to put smaller clickable parts above the
-- larger ones they sit in (the spell name above the bar).
local function Area(region)
    local width = type(region.GetWidth) == "function" and region:GetWidth() or 0
    local height = type(region.GetHeight) == "function" and region:GetHeight() or 0
    if issecretvalue and (issecretvalue(width) or issecretvalue(height)) then return 0 end
    if type(width) ~= "number" or type(height) ~= "number" then return 0 end
    return width * height
end

function Kit.New(frame, options)
    options = options or {}
    local x, width = options.x or 14, options.width or 508
    local preview = { frame = frame, parts = {}, loops = {}, outlines = {}, markBoxes = {}, top = SAMPLE_TOP, left = x + SAMPLE_LEFT, width = width,
        labelDrop = 0, extra = 0 }

    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetPoint("TOPLEFT", x + 2, -LABEL_TOP)
    label:SetWidth(options.onScreen and (width - SCREEN_W - 8) or width)
    label:SetJustifyH("LEFT")
    label:SetTextColor(GREY[1], GREY[2], GREY[3])
    preview.label = label
    if options.onScreen then
        local button = FlatButton(frame, "Show on screen", SCREEN_W, SCREEN_H, options.screenTip)
        button:SetPoint("TOPLEFT", x + width - SCREEN_W, -1)
        button:SetScript("OnClick", function() options.onScreen() end)
        preview.screen = button
    end

    local holder = CreateFrame("Frame", nil, frame)
    holder:SetAllPoints(frame)
    holder.settingsPreview = true
    preview.holder = holder
    local stage = CreateFrame("Frame", nil, holder, "BackdropTemplate")
    stage:SetPoint("TOPLEFT", holder, "TOPLEFT", x, -(SAMPLE_TOP - 6))
    stage:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", x + width, 4)
    stage:SetFrameLevel(holder:GetFrameLevel())
    stage:SetBackdrop(EDGE)
    stage:SetBackdropBorderColor(0, 0, 0, 1)
    preview.stage = stage
    if options.plain then
        local fill = stage:CreateTexture(nil, "BACKGROUND")
        fill:SetPoint("TOPLEFT", 1, -1)
        fill:SetPoint("BOTTOMRIGHT", -1, 1)
        fill:SetColorTexture(options.plain[1], options.plain[2], options.plain[3], 1)
        preview.fill = fill
    else
        local sky = stage:CreateTexture(nil, "BACKGROUND")
        sky:SetPoint("TOPLEFT", 1, -1)
        sky:SetPoint("BOTTOMRIGHT", stage, "RIGHT", -1, 0)
        Gradient(sky, SKY, HORIZON)
        local ground = stage:CreateTexture(nil, "BACKGROUND")
        ground:SetPoint("TOPLEFT", stage, "LEFT", 1, 0)
        ground:SetPoint("BOTTOMRIGHT", -1, 1)
        Gradient(ground, HORIZON, GROUND)
        preview.sky, preview.ground = sky, ground
    end
    local text = CreateFrame("Frame", nil, holder)
    text:SetAllPoints(holder)
    text:SetFrameLevel(holder:GetFrameLevel() + TEXT_ABOVE)
    preview.text = text
    -- The kit's own frames, which Lift leaves out of the samples.
    local own = { [stage] = true, [text] = true }

    -- A caption is one line unless it is given a width: a font string
    -- wraps only at a width of its own, so a wrapped caption needs one.
    function preview.Caption(width)
        local caption = text:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        caption:SetJustifyH("LEFT")
        if type(width) == "number" and width > 0 then
            caption:SetWidth(width)
            caption:SetWordWrap(true)
        else
            caption:SetWordWrap(false)
        end
        return caption
    end

    -- The grey line wraps when it is long, so the samples hang below
    -- however many lines it takes: the holder, strip and all, moves down by
    -- what the line needs beyond one. The text is the addon's own.
    local extra = 0
    function preview.SetLabel(value)
        value = value or ""
        if options.find then value = (value ~= "" and (value .. " · ") or "") .. FIND_HINT end
        label:SetText(value)
        local height = label:GetStringHeight()
        extra = 0
        if type(height) == "number" then extra = math.max(0, math.ceil(LABEL_TOP + height + 2 - (SAMPLE_TOP - 6))) end
        holder:ClearAllPoints()
        holder:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -extra)
        holder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
        -- labelDrop is the name to read; extra stays for pages that read it.
        preview.labelDrop, preview.extra = extra, extra
        return extra
    end
    function preview.Fit(bottom)
        preview.Lift()
        local height = math.ceil(extra + bottom + 6)
        preview.height = height
        if options.resize then options.resize(height) end
        return height
    end

    -- Motion. The runner is set only while samples move and the box is on
    -- screen: holding still or hiding the box takes it away.
    local function Run()
        local now = GetTime()
        for _, loop in ipairs(preview.loops) do
            if loop.active then
                if loop.step then loop.step(now) end
                if loop.done() then loop.active, loop.next = false, now + LOOP_GAP end
            elseif loop.next and now >= loop.next then
                loop.active, loop.next = true, nil
                loop.play(now, false)
            end
        end
    end
    function preview.Restart()
        local now = GetTime()
        holder:SetScript("OnUpdate", (not preview.holding and #preview.loops > 0) and Run or nil)
        for _, loop in ipairs(preview.loops) do
            loop.stop()
            loop.active, loop.next = false, nil
            if preview.holding then
                loop.still()
            else
                loop.active = true
                loop.play(now, true)
            end
        end
    end
    function preview.Hold(on)
        on = on == true
        if preview.holding == on then return end
        preview.holding = on
        preview.Restart()
    end
    holder:SetScript("OnHide", function()
        holder:SetScript("OnUpdate", nil)
        for _, loop in ipairs(preview.loops) do
            loop.stop()
            loop.active, loop.next = false, nil
        end
    end)

    -- Hover a row, see its part.
    local tag = CreateFrame("Frame", nil, holder)
    tag:SetFrameLevel(holder:GetFrameLevel() + OUTLINE_ABOVE + 1)
    own[tag] = true
    tag:SetHeight(14)
    local tagFill = tag:CreateTexture(nil, "BACKGROUND")
    tagFill:SetAllPoints()
    tagFill:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
    local tagText = tag:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    tagText:SetPoint("CENTER", 0, 0)
    tagText:SetTextColor(0, 0, 0, 1)
    tag:Hide()
    preview.tag, preview.tagText = tag, tagText

    -- Samples are the addon's own frames, at whatever level its drawing
    -- code gives them; one at or above the caption layer would draw over
    -- the captions, outlines and tag. The layers keep their usual places
    -- (20, 30 and 31 above the holder) and rise only past a higher sample,
    -- and Show on screen with them, in case a sample reaches up to it.
    local outlineLevel = holder:GetFrameLevel() + OUTLINE_ABOVE
    preview.hotspots = {}
    local shownSpots = 0
    function preview.Lift()
        local base = Level(holder)
        if not base then return end
        local top = Highest(holder, own, base, 0)
        local textLevel = math.max(base + TEXT_ABOVE, top + 1)
        -- The clickable parts sit between the captions and the outlines,
        -- smaller ones above larger (kit 3).
        outlineLevel = math.max(base + OUTLINE_ABOVE, textLevel + 1 + shownSpots)
        SetLevel(text, textLevel)
        for index = 1, shownSpots do
            local spot = preview.hotspots[index]
            SetLevel(spot, textLevel + index)
            SetLevel(spot.ghost, textLevel + index)
        end
        for _, box in ipairs(preview.outlines) do SetLevel(box, outlineLevel) end
        for _, box in ipairs(preview.markBoxes) do SetLevel(box, outlineLevel) end
        if preview.markTag then SetLevel(preview.markTag, outlineLevel + 1) end
        SetLevel(tag, outlineLevel + 1)
        if preview.note then SetLevel(preview.note, outlineLevel + 1) end
        local screen = preview.screen
        if screen then
            local frameLevel = Level(frame)
            local wanted = math.max(frameLevel and frameLevel + 1 or 0, top + 1)
            SetLevel(screen, wanted)
            SetLevel(screen.gold, wanted + 1)
        end
        return textLevel
    end

    function preview.Point(part, name)
        for _, box in ipairs(preview.outlines) do box:Hide() end
        tag:Hide()
        local find = part and preview.parts[part]
        preview.pointed, preview.pointedName = find and part or nil, find and name or nil
        preview.Hold(find ~= nil)
        if not find then return end
        local regions, whole = find()
        local shown = {}
        for _, region in ipairs(regions or {}) do
            if region and region:IsShown() ~= false then shown[#shown + 1] = region end
        end
        local off = #shown == 0
        if off then shown[1] = whole end
        if not shown[1] then return end
        preview.Lift()
        for index, region in ipairs(shown) do
            local box = preview.outlines[index]
            if not box then
                box = Outline(holder, outlineLevel)
                own[box] = true
                preview.outlines[index] = box
            end
            box:ClearAllPoints()
            box:SetPoint("TOPLEFT", region, "TOPLEFT", -2, 2)
            box:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", 2, -2)
            box:Show()
        end
        tagText:SetText(off and ((name or "") .. ": not shown") or (name or ""))
        tag:SetWidth((tagText:GetStringWidth() or 60) + 8)
        preview.PlaceTag()
        tag:Show()
    end
    -- The row's name beside the outline, or above it when there is no room.
    -- Kit 6: above, it starts after the Editing tag (Mark) when that sits on
    -- the same top edge, which it covered before (Forever Skin's Nameplates,
    -- the looks' rows over the picked look, 1.60.1.70532, 25 October 2026).
    function preview.PlaceTag()
        local box = preview.outlines[1]
        if not box then return end
        tag:ClearAllPoints()
        local right, edge = box:GetRight(), stage:GetRight()
        if type(right) == "number" and type(edge) == "number" and right + 4 + tag:GetWidth() > edge then
            local mark, markBox = preview.markTag, preview.markBoxes[1]
            local top, markTop = box:GetTop(), markBox and markBox:GetTop()
            if mark and mark:IsShown() and type(top) == "number" and type(markTop) == "number"
                and math.abs(top - markTop) <= 6 then
                tag:SetPoint("BOTTOMLEFT", mark, "BOTTOMRIGHT", 4, 0)
            else
                tag:SetPoint("BOTTOMRIGHT", box, "TOPRIGHT", 0, 1)
            end
        else
            tag:SetPoint("LEFT", box, "RIGHT", 4, 0)
        end
    end
    -- The picked thing (kit 4): a thick gold box round it, held while the
    -- samples move, with a gold tag on its top left.
    local markTag, markText
    function preview.Mark(part, value)
        for _, box in ipairs(preview.markBoxes) do box:Hide() end
        if markTag then markTag:Hide() end
        preview.marked, preview.markedText = part, value
        local find = part and preview.parts[part]
        if not find then return end
        local shown = {}
        for _, region in ipairs((find()) or {}) do
            if region and region:IsShown() ~= false then shown[#shown + 1] = region end
        end
        if not shown[1] then return end
        preview.Lift()
        for index, region in ipairs(shown) do
            local box = preview.markBoxes[index]
            if not box then
                box = Outline(holder, outlineLevel, true)
                own[box] = true
                preview.markBoxes[index] = box
            end
            box:ClearAllPoints()
            box:SetPoint("TOPLEFT", region, "TOPLEFT", -3, 3)
            box:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", 3, -3)
            box:Show()
        end
        if not markTag then
            markTag = CreateFrame("Frame", nil, holder)
            own[markTag] = true
            markTag:SetHeight(14)
            local fill = markTag:CreateTexture(nil, "BACKGROUND")
            fill:SetAllPoints()
            fill:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
            markText = markTag:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            markText:SetPoint("CENTER", 0, 0)
            markText:SetTextColor(0, 0, 0, 1)
            preview.markTag, preview.markText = markTag, markText
        end
        SetLevel(markTag, outlineLevel + 1)
        markText:SetText(value or "Editing")
        markTag:SetWidth((markText:GetStringWidth() or 40) + 8)
        markTag:ClearAllPoints()
        markTag:SetPoint("BOTTOMLEFT", preview.markBoxes[1], "TOPLEFT", 0, -1)
        markTag:Show()
        if tag:IsShown() then preview.PlaceTag() end
    end

    -- Click a part to find its setting (kit 3). A region drawn for several
    -- parts (the spell name for Spell name and for Text size) is one
    -- clickable spot carrying all of them.
    local ghosts, hovered = false, nil
    local function ShowGhosts(on)
        ghosts = on
        for index = 1, shownSpots do preview.hotspots[index].ghost:SetShown(on) end
    end
    local function CheckGhosts()
        if Over(stage) or hovered then return end
        ShowGhosts(false)
    end
    local function Later(fn)
        if C_Timer and C_Timer.After then C_Timer.After(0, fn) else fn() end
    end
    local function Spot(index)
        local spot = preview.hotspots[index]
        if spot then return spot end
        spot = CreateFrame("Button", nil, holder)
        spot:RegisterForClicks("LeftButtonUp")
        local ghost = Outline(holder)
        ghost:SetAlpha(GHOST_ALPHA)
        spot.ghost = ghost
        own[spot], own[ghost] = true, true
        spot:SetScript("OnEnter", function(self)
            hovered = self
            ShowGhosts(true)
            Magnifier(true)
            preview.Point(self.parts[1], options.names and options.names(self.parts) or nil)
        end)
        spot:SetScript("OnLeave", function(self)
            if hovered == self then hovered = nil end
            Magnifier(false)
            preview.Point(nil)
            Later(CheckGhosts)
        end)
        spot:SetScript("OnClick", function(self)
            if options.find then options.find(self.parts) end
        end)
        preview.hotspots[index] = spot
        return spot
    end
    function preview.Hotspots()
        if not options.find then return end
        local names = {}
        for part in pairs(preview.parts) do names[#names + 1] = part end
        table.sort(names)
        local byRegion, regions = {}, {}
        for _, part in ipairs(names) do
            local list = preview.parts[part]()
            for _, region in ipairs(list or {}) do
                if region and region:IsShown() ~= false then
                    if not byRegion[region] then
                        byRegion[region] = {}
                        regions[#regions + 1] = region
                    end
                    table.insert(byRegion[region], part)
                end
            end
        end
        -- A region no row on the page changes gets no spot (names gives
        -- nothing for it): a click there would find nothing.
        if options.names then
            local kept = {}
            for _, region in ipairs(regions) do
                local label = options.names(byRegion[region])
                if type(label) == "string" and label ~= "" then kept[#kept + 1] = region end
            end
            regions = kept
        end
        table.sort(regions, function(a, b) return Area(a) > Area(b) end)
        for index, region in ipairs(regions) do
            local spot = Spot(index)
            spot.region, spot.parts = region, byRegion[region]
            spot:ClearAllPoints()
            spot:SetPoint("TOPLEFT", region, "TOPLEFT", -1, 1)
            spot:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", 1, -1)
            spot.ghost:ClearAllPoints()
            spot.ghost:SetPoint("TOPLEFT", region, "TOPLEFT", -1, 1)
            spot.ghost:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", 1, -1)
            spot.ghost:SetShown(ghosts or preview.pulsing == true)
            spot:Show()
        end
        for index = #regions + 1, #preview.hotspots do
            preview.hotspots[index]:Hide()
            preview.hotspots[index].ghost:Hide()
        end
        shownSpots = #regions
    end
    if options.find then
        stage:EnableMouse(true)
        stage:SetScript("OnEnter", function() ShowGhosts(true) end)
        stage:SetScript("OnLeave", function() Later(CheckGhosts) end)
        -- The note over the strip while the outlines pulse.
        local note = CreateFrame("Frame", nil, holder, "BackdropTemplate")
        note:SetBackdrop(BACKDROP)
        note:SetBackdropColor(0.075, 0.08, 0.09, 0.92)
        note:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], 1)
        note:SetPoint("TOPLEFT", stage, "TOPLEFT", 4, -4)
        note:SetHeight(16)
        local noteText = note:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        noteText:SetPoint("LEFT", 6, 0)
        noteText:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
        noteText:SetText(FIND_NOTE)
        note:SetWidth((noteText:GetStringWidth() or 180) + 12)
        note:Hide()
        own[note] = true
        preview.note, preview.noteText = note, noteText
        local pulser = CreateFrame("Frame", nil, holder)
        own[pulser] = true
        preview.pulser = pulser
        local pulseStart = 0
        local function PulseStep()
            local t = GetTime() - pulseStart
            if t >= PULSE_BEAT * PULSE_BEATS then
                pulser:SetScript("OnUpdate", nil)
                preview.pulsing = false
                note:Hide()
                for index = 1, shownSpots do preview.hotspots[index].ghost:SetAlpha(GHOST_ALPHA) end
                ShowGhosts(Over(stage) or hovered ~= nil)
                return
            end
            local beat = (t % PULSE_BEAT) / PULSE_BEAT
            local alpha = 0.15 + 0.85 * math.sin(beat * math.pi)
            for index = 1, shownSpots do
                local ghost = preview.hotspots[index].ghost
                ghost:Show()
                ghost:SetAlpha(alpha)
            end
        end
        -- Every time the box is shown (the user: not only the first time).
        function preview.Pulse()
            pulseStart = GetTime()
            preview.pulsing = true
            note:Show()
            pulser:SetScript("OnUpdate", PulseStep)
            PulseStep()
        end
        holder:SetScript("OnShow", function() preview.Pulse() end)
        holder:HookScript("OnHide", function()
            pulser:SetScript("OnUpdate", nil)
            preview.pulsing = false
            note:Hide()
            hovered = nil
            ShowGhosts(false)
            Magnifier(false)
        end)
    end

    function preview.Settle()
        preview.Restart()
        preview.Hotspots()
        preview.Lift()
        if preview.pointed then preview.Point(preview.pointed, preview.pointedName) end
        if preview.marked then preview.Mark(preview.marked, preview.markedText) end
    end
    return preview
end

-- Found rows (kit 4) -------------------------------------------------------------------
-- A click on a part in a preview used to scroll the page to its rows; the
-- user found the jump jarring (14 October 2026). Now the rows light up
-- where they are, and a bar at the page's edge points at any out of sight.
local GLOW_BEAT, GLOW_BEATS, GLOW_HOLD, GLOW_FADE = 0.6, 3, 2.6, 1.0
local POINTER_H, POINTER_LIFE, POINTER_CHECK, GLIDE = 22, 10, 0.1, 0.3
local GLOW_EDGE = { edgeFile = WHITE, edgeSize = 2 }

-- A plain number from a geometry call, or nil (a secret or nothing).
local function Number(value)
    if issecretvalue and issecretvalue(value) then return nil end
    if type(value) ~= "number" then return nil end
    return value
end

-- Three gold bars, 7, 5 and 3 px, pointing down, up or right.
local function Arrow(parent, layer, way, colour)
    local bars = {}
    colour = colour or GOLD
    for index, size in ipairs({ 7, 5, 3 }) do
        local bar = parent:CreateTexture(nil, layer or "OVERLAY")
        bar:SetColorTexture(colour[1], colour[2], colour[3], 1)
        if way == "right" then bar:SetSize(1, size) else bar:SetSize(size, 1) end
        bars[index] = bar
    end
    function bars.Place(point, relative, x, y)
        for index, bar in ipairs(bars) do
            bar:ClearAllPoints()
            if way == "right" then
                bar:SetPoint(point, relative, point, x + index - 1, y)
            else
                bar:SetPoint(point, relative, point, x + (7 - bar:GetWidth()) / 2, y + (way == "up" and (index - 2) or (2 - index)))
            end
        end
    end
    function bars.SetShown(on) for index = 1, 3 do bars[index]:SetShown(on) end end
    function bars.SetAlpha(alpha) for index = 1, 3 do bars[index]:SetAlpha(alpha) end end
    function bars.SetColour(c) for index = 1, 3 do bars[index]:SetColorTexture(c[1], c[2], c[3], 1) end end
    return bars
end
Kit.Arrow = Arrow

-- The glows share one runner, set only while one shows.
local glows, glowRunner = {}, nil
local function GlowStep()
    local now = GetTime()
    local live = false
    for strip, glow in pairs(glows) do
        local t = now - glow.start
        local pulse = GLOW_BEAT * GLOW_BEATS
        local fill, edge
        if t < pulse then
            local k = math.sin(((t % GLOW_BEAT) / GLOW_BEAT) * math.pi)
            fill, edge = 0.12 + 0.33 * k, 0.55 + 0.45 * k
        elseif t < pulse + GLOW_HOLD then
            fill, edge = 0.14, 1
        elseif t < pulse + GLOW_HOLD + GLOW_FADE then
            local k = 1 - (t - pulse - GLOW_HOLD) / GLOW_FADE
            fill, edge = 0.14 * k, k
        end
        if fill then
            live = true
            glow.fill:SetAlpha(fill)
            glow:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], edge)
            glow.arrow.SetAlpha(edge)
        else
            glow:Hide()
            glows[strip] = nil
        end
    end
    if not live and glowRunner then glowRunner:SetScript("OnUpdate", nil) end
end
local function Glow(strip)
    local glow = strip.kitGlow
    if not glow then
        glow = CreateFrame("Frame", nil, strip, "BackdropTemplate")
        glow:SetPoint("TOPLEFT", -1, 1)
        glow:SetPoint("BOTTOMRIGHT", 1, -1)
        glow:SetBackdrop(GLOW_EDGE)
        local fill = glow:CreateTexture(nil, "BACKGROUND")
        fill:SetPoint("TOPLEFT", 2, -2)
        fill:SetPoint("BOTTOMRIGHT", -2, 2)
        fill:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
        glow.fill = fill
        glow.arrow = Arrow(glow, "OVERLAY", "right")
        glow.arrow.Place("LEFT", glow, -9, 0)
        strip.kitGlow = glow
    end
    local level = Level(strip)
    if level then SetLevel(glow, level + 2) end
    glow.start = GetTime()
    glow:Show()
    glows[strip] = glow
    if not glowRunner then glowRunner = CreateFrame("Frame") end
    glowRunner:SetScript("OnUpdate", GlowStep)
    GlowStep()
end
Kit.Glow = Glow

-- Where a region sits on screen, top and bottom in screen pixels, or nil.
local function Span(region)
    if type(region.GetTop) ~= "function" then return nil end
    local top, bottom = Number(region:GetTop()), Number(region:GetBottom())
    local scale = Number(type(region.GetEffectiveScale) == "function" and region:GetEffectiveScale() or 1)
    if not top or not bottom or not scale then return nil end
    return top * scale, bottom * scale
end

-- The found strips out of sight in scroll, below and above, nearest first.
-- margin: the pointer's room at the edge, which hides what is under it.
local function OutOfSight(scroll, strips, names, margin)
    local top, bottom = Span(scroll)
    if not top then return nil end
    local below, above = {}, {}
    for index, strip in ipairs(strips) do
        local stripTop, stripBottom = Span(strip)
        if stripTop and strip:IsVisible() ~= false then
            local middle = (stripTop + stripBottom) / 2
            local entry = { name = names and names[index], top = stripTop, bottom = stripBottom }
            if middle < bottom + margin then
                below[#below + 1] = entry
            elseif middle > top - margin then
                above[#above + 1] = entry
            end
        end
    end
    table.sort(below, function(a, b) return a.top > b.top end)
    table.sort(above, function(a, b) return a.top < b.top end)
    return below, above, top, bottom
end

-- Glide the page so its rows rise by delta screen pixels (negative: fall).
local function Glide(scroll, delta)
    local scale = Number(scroll:GetEffectiveScale()) or 1
    local from = Number(scroll:GetVerticalScroll()) or 0
    local range = Number(scroll:GetVerticalScrollRange()) or 0
    local to = math.max(0, math.min(range, from + delta / scale))
    local start = GetTime()
    local glider = scroll.kitGlider
    if not glider then
        glider = CreateFrame("Frame", nil, scroll)
        scroll.kitGlider = glider
    end
    glider:SetScript("OnUpdate", function(self)
        local t = math.min(1, (GetTime() - start) / GLIDE)
        local eased = 1 - (1 - t) * (1 - t)
        scroll:SetVerticalScroll(from + (to - from) * eased)
        if t >= 1 then self:SetScript("OnUpdate", nil) end
    end)
    glider:GetScript("OnUpdate")(glider)
end

local function Pointer(scroll)
    local pointer = scroll.kitPointer
    if pointer then return pointer end
    pointer = CreateFrame("Button", nil, scroll:GetParent() or scroll, "BackdropTemplate")
    pointer:SetHeight(POINTER_H)
    pointer:SetBackdrop(BACKDROP)
    pointer:SetBackdropColor(0.24, 0.20, 0.12, 0.97)
    pointer:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], 1)
    pointer:RegisterForClicks("LeftButtonUp")
    local text = pointer:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("LEFT", 24, 0)
    text:SetPoint("RIGHT", -8, 0)
    text:SetJustifyH("LEFT")
    text:SetWordWrap(false)
    text:SetTextColor(1, 0.9, 0.6)
    pointer.text = text
    pointer.down = Arrow(pointer, "OVERLAY", "down")
    pointer.down.Place("LEFT", pointer, 9, 0)
    pointer.up = Arrow(pointer, "OVERLAY", "up")
    pointer.up.Place("LEFT", pointer, 9, 0)
    pointer:SetScript("OnEnter", function(self) self:SetBackdropColor(0.34, 0.27, 0.12, 0.97) end)
    pointer:SetScript("OnLeave", function(self) self:SetBackdropColor(0.24, 0.20, 0.12, 0.97) end)
    pointer:Hide()
    scroll.kitPointer = pointer
    return pointer
end

local function Plural(count, one, many) return count == 1 and one or many end

-- Puts the pointer at the edge the found rows are past, or takes it away.
local function Aim(scroll, pointer)
    local below, above, top, bottom = OutOfSight(scroll, pointer.strips, pointer.names, POINTER_H + 4)
    if not below or (#below == 0 and #above == 0) or GetTime() - pointer.start > POINTER_LIFE then
        pointer:SetScript("OnUpdate", nil)
        pointer:Hide()
        return
    end
    local list, down = below, true
    if #below == 0 then list, down = above, false end
    local names = {}
    for _, entry in ipairs(list) do
        if entry.name and entry.name ~= "" then names[#names + 1] = entry.name end
    end
    local what = #list .. " " .. Plural(#list, "setting", "settings") .. (down and " further down" or " further up")
    if #names > 0 then what = what .. ": " .. table.concat(names, ", ") end
    pointer.text:SetText(what .. " · |cffffffffclick to show " .. Plural(#list, "it", "them") .. "|r")
    pointer.down.SetShown(down)
    pointer.up.SetShown(not down)
    pointer:ClearAllPoints()
    if down then
        pointer:SetPoint("BOTTOMLEFT", scroll, "BOTTOMLEFT", 4, 4)
        pointer:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", -4, 4)
    else
        pointer:SetPoint("TOPLEFT", scroll, "TOPLEFT", 4, -4)
        pointer:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", -4, -4)
    end
    -- How far a click glides: just far enough to show them all, keeping
    -- the nearest in sight when they do not all fit.
    local edge = POINTER_H + 12
    if down then
        local first = (bottom + edge) - list[1].bottom
        local need = (bottom + edge) - list[#list].bottom
        local room = (top - 12) - list[1].top
        pointer.delta = math.max(first, math.min(need, room))
    else
        local first = (top - edge) - list[1].top
        local need = (top - edge) - list[#list].top
        local room = (bottom + 12) - list[1].bottom
        pointer.delta = math.min(first, math.max(need, room))
    end
    local level = Level(scroll)
    if level then SetLevel(pointer, level + 40) end
    pointer:Show()
end

function Kit.Found(scroll, strips, names)
    strips = strips or {}
    for _, strip in ipairs(strips) do Glow(strip) end
    if not scroll or #strips == 0 then return end
    local pointer = Pointer(scroll)
    pointer.strips, pointer.names, pointer.start = strips, names, GetTime()
    pointer:SetScript("OnClick", function(self)
        if self.delta then Glide(scroll, self.delta) end
        for _, strip in ipairs(self.strips) do Glow(strip) end
    end)
    local waited = 0
    pointer:SetScript("OnUpdate", function(self, elapsed)
        waited = waited + (Number(elapsed) or 0)
        if waited < POINTER_CHECK then return end
        waited = 0
        Aim(scroll, self)
    end)
    -- The layout settles a frame after the page opens a heading.
    local function First() Aim(scroll, pointer) end
    if C_Timer and C_Timer.After then C_Timer.After(0, First) else First() end
end

-- The picker (kit 4) ---------------------------------------------------------------------
-- Pages with one block of rows for several things (Cast's bars, Combat
-- Text's lanes) choose the thing under a picker. A plain row did not read
-- as the key to the page (the user, 14 October 2026), so the picker is a
-- gold panel of its own with a chip per thing, and its gold bar runs down
-- the rows it controls.
local CHIP_H, CHIP_GAP, CHIP_PAD, CHIP_MIN = 24, 6, 12, 64
local PICKER_TOP, PICKER_TITLE, PICKER_FOOT, PICKER_PAD = 4, 30, 22, 8
local RAIL_X, RAIL_W = 9, 3
local PANEL_FILL = { 0.15, 0.125, 0.07 }
local CHIP_FILL, CHIP_LIT = { 0.14, 0.145, 0.16 }, { 0.24, 0.20, 0.12 }
local PICKED_TEXT = { 0.08, 0.06, 0.02 }

function Kit.Picker(frame, options)
    options = options or {}
    local x, width = options.x or 14, options.width or 508
    local picker = { frame = frame, chips = {}, height = 0 }

    local panel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    panel:SetPoint("TOPLEFT", x, -PICKER_TOP)
    panel:SetWidth(width)
    panel:SetBackdrop(BACKDROP)
    panel:SetBackdropColor(PANEL_FILL[1], PANEL_FILL[2], PANEL_FILL[3], 1)
    panel:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], 1)
    picker.panel = panel
    -- A second, brighter edge just inside, for the pulse.
    local shine = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    shine:SetPoint("TOPLEFT", 1, -1)
    shine:SetPoint("BOTTOMRIGHT", -1, 1)
    shine:SetBackdrop(EDGE)
    shine:SetBackdropBorderColor(1, 0.9, 0.55, 1)
    shine:SetAlpha(0)
    picker.shine = shine
    -- The gold bar down the left, outside the panel; Rail carries it on.
    local bar = frame:CreateTexture(nil, "ARTWORK")
    bar:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
    bar:SetWidth(RAIL_W)
    bar:SetPoint("TOPLEFT", panel, "TOPLEFT", -RAIL_X, 0)
    bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", x - RAIL_X, 0)
    picker.bar = bar

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 10, -8)
    title:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    title:SetText(options.title or "Choose what to edit")
    picker.title = title
    local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    hint:SetPoint("BOTTOMLEFT", title, "BOTTOMRIGHT", 10, 1)
    hint:SetPoint("RIGHT", panel, "RIGHT", -10, 0)
    hint:SetJustifyH("LEFT")
    hint:SetWordWrap(false)
    hint:SetTextColor(GREY[1], GREY[2], GREY[3])
    hint:SetText(options.hint or "")
    picker.hint = hint

    local foot = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    foot:SetJustifyH("LEFT")
    foot:SetWordWrap(false)
    picker.foot = foot
    local footArrow = Arrow(panel, "OVERLAY", "down")
    picker.footArrow = footArrow

    local function Picked() return options.get and options.get() end
    local function Chip(index)
        local chip = picker.chips[index]
        if chip then return chip end
        chip = CreateFrame("Button", nil, panel, "BackdropTemplate")
        chip:SetHeight(CHIP_H)
        chip:SetBackdrop(BACKDROP)
        chip:SetBackdropBorderColor(0, 0, 0, 1)
        chip:RegisterForClicks("LeftButtonUp")
        local gold = CreateFrame("Frame", nil, chip, "BackdropTemplate")
        gold:SetPoint("TOPLEFT", 1, -1)
        gold:SetPoint("BOTTOMRIGHT", -1, 1)
        gold:SetBackdrop(EDGE)
        gold:SetBackdropBorderColor(0.8, 0.62, 0.25, 1)
        gold:Hide()
        chip.gold = gold
        local label = chip:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("CENTER", 0, 0)
        label:SetWordWrap(false)
        chip.label = label
        function chip.Paint()
            local on = chip.choice and chip.choice.key == Picked()
            if on then
                chip:SetBackdropColor(GOLD[1], GOLD[2], GOLD[3], 1)
                label:SetTextColor(PICKED_TEXT[1], PICKED_TEXT[2], PICKED_TEXT[3])
                gold:Hide()
            else
                local fill = chip.hover and CHIP_LIT or CHIP_FILL
                chip:SetBackdropColor(fill[1], fill[2], fill[3], 1)
                label:SetTextColor(0.92, 0.92, 0.92)
                gold:SetShown(chip.hover == true)
            end
        end
        chip:SetScript("OnClick", function(self)
            if self.choice and options.set then options.set(self.choice.key) end
            picker.Refresh()
        end)
        chip:SetScript("OnEnter", function(self)
            self.hover = true
            self.Paint()
            if not self.choice then return end
            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetText(self.choice.label)
            local tip = options.tip and options.tip(self.choice)
            GameTooltip:AddLine(tip or "Click to change it in the rows below.", 0.85, 0.85, 0.85, true)
            GameTooltip:Show()
            Kit.PlaceTooltip(GameTooltip, self)
        end)
        chip:SetScript("OnLeave", function(self)
            self.hover = false
            self.Paint()
            GameTooltip:Hide()
        end)
        picker.chips[index] = chip
        return chip
    end

    function picker.Refresh()
        local choices = (options.choices and options.choices()) or {}
        local sizes = {}
        for index, choice in ipairs(choices) do
            local chip = Chip(index)
            chip.choice = choice
            -- Measured unbounded, then held inside its chip: a name too long
            -- for the panel ends in "..." instead of running past the edge.
            chip.label:SetWidth(0)
            chip.label:SetText(choice.label or "")
            local textWidth = Number(chip.label:GetStringWidth()) or (#(choice.label or "") * 7)
            local chipWidth = math.min(width - 20, math.max(CHIP_MIN, math.ceil(textWidth) + 2 * CHIP_PAD))
            chip:SetWidth(chipWidth)
            chip.label:SetWidth(chipWidth - 2 * CHIP_PAD + 4)
            sizes[index] = { chipWidth, CHIP_H }
        end
        local places, height = Kit.Flow(sizes, width - 20, CHIP_GAP, CHIP_GAP)
        local pickedLabel
        for index, chip in ipairs(picker.chips) do
            local place = places[index]
            if place then
                chip:ClearAllPoints()
                chip:SetPoint("TOPLEFT", panel, "TOPLEFT", 10 + place.x, -(PICKER_TITLE + place.y))
                chip:Show()
                chip.Paint()
                if chip.choice.key == Picked() then pickedLabel = chip.choice.label end
            else
                chip:Hide()
                chip.choice = nil
            end
        end
        local footY = PICKER_TITLE + height + 8
        footArrow.Place("TOPLEFT", panel, 12, -(footY + 5))
        foot:ClearAllPoints()
        foot:SetPoint("TOPLEFT", panel, "TOPLEFT", 26, -footY)
        foot:SetPoint("RIGHT", panel, "RIGHT", -10, 0)
        foot:SetTextColor(0.92, 0.92, 0.92)
        foot:SetText((options.noun and ("The rows below change " .. options.noun .. ": ") or "The rows below change: ")
            .. "|cffffd27a" .. (pickedLabel or "?") .. "|r")
        local panelHeight = footY + PICKER_FOOT - 4 + PICKER_PAD
        panel:SetHeight(panelHeight)
        local total = PICKER_TOP + panelHeight + 6
        if total ~= picker.height then
            picker.height = total
            if options.resize then options.resize(total) else frame:SetHeight(total) end
        end
        return total
    end

    -- The bar runs on down the left of the rows the picker controls, to the
    -- last one shown, and ends in a short foot towards them.
    local rail = frame:GetParent() and frame:GetParent():CreateTexture(nil, "ARTWORK") or nil
    local railFoot = rail and frame:GetParent():CreateTexture(nil, "ARTWORK") or nil
    if rail then
        rail:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.85)
        rail:SetWidth(RAIL_W)
        railFoot:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.85)
        railFoot:SetSize(7, RAIL_W)
        rail:Hide()
        railFoot:Hide()
    end
    picker.rail, picker.railFoot = rail, railFoot
    function picker.Rail(frames)
        if frames then picker.railFrames = frames end
        if not rail then return end
        local last
        for _, row in ipairs(picker.railFrames or {}) do
            if row:IsShown() then last = row end
        end
        if not last or not frame:IsShown() then
            rail:Hide()
            railFoot:Hide()
            return
        end
        rail:ClearAllPoints()
        rail:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", x - RAIL_X, 0)
        rail:SetPoint("BOTTOMLEFT", last, "BOTTOMLEFT", x - RAIL_X, 2)
        railFoot:ClearAllPoints()
        railFoot:SetPoint("BOTTOMLEFT", rail, "BOTTOMLEFT", 0, 0)
        rail:Show()
        railFoot:Show()
    end

    -- The pulse: the inner edge and the picked chip brighten three times.
    local pulseStart
    local function PulseStep(self)
        local t = GetTime() - pulseStart
        if t >= PULSE_BEAT * PULSE_BEATS then
            self:SetScript("OnUpdate", nil)
            shine:SetAlpha(0)
            return
        end
        shine:SetAlpha(math.sin(((t % PULSE_BEAT) / PULSE_BEAT) * math.pi))
    end
    function picker.Pulse()
        pulseStart = GetTime()
        shine:SetScript("OnUpdate", PulseStep)
        PulseStep(shine)
    end
    panel:SetScript("OnShow", function() picker.Pulse() end)
    panel:SetScript("OnHide", function()
        shine:SetScript("OnUpdate", nil)
        shine:SetAlpha(0)
    end)

    picker.Refresh()
    return picker
end

-- The move panel (kit 5) ---------------------------------------------------------------
-- Boxes that hide until something happens (a fight, a battleground, a
-- target) were moved from an Unlock row under a closed heading, which
-- players could not find. The user (15 October 2026, option A of
-- https://claude.ai/artifact/3dug2qCEJR3e9mKx4kxyvZ) put it at the top of
-- the page in a gold panel like the picker's, always with Show on screen
-- beside it. Its buttons first closed the settings window; the user then
-- left that to the player (15 October 2026), so nothing here closes it.
local MOVE_TOP, MOVE_TITLE, MOVE_BUTTON_H, MOVE_PAD = 4, 30, 24, 8
local UNLOCK_W, SCREEN_BUTTON_W = 128, 112
local MOVE_SCREEN_TIP = "Play samples on the real boxes for a few seconds, where they are now."

-- A wide button: solid gold (the thing to press) or flat with gold words.
local function BigButton(parent, width)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(width, MOVE_BUTTON_H)
    button:SetBackdrop(BACKDROP)
    button:SetBackdropBorderColor(0, 0, 0, 1)
    button:RegisterForClicks("LeftButtonUp")
    local gold = CreateFrame("Frame", nil, button, "BackdropTemplate")
    gold:SetPoint("TOPLEFT", 1, -1)
    gold:SetPoint("BOTTOMRIGHT", -1, 1)
    gold:SetBackdrop(EDGE)
    gold:SetBackdropBorderColor(0.8, 0.62, 0.25, 1)
    gold:Hide()
    button.gold = gold
    local label = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("CENTER", 0, 0)
    label:SetWordWrap(false)
    button.label = label
    function button.Paint()
        if button.solid then
            local fill = button.hover and { 1, 0.86, 0.5 } or GOLD
            button:SetBackdropColor(fill[1], fill[2], fill[3], 1)
            label:SetTextColor(PICKED_TEXT[1], PICKED_TEXT[2], PICKED_TEXT[3])
            gold:Hide()
        else
            local fill = button.hover and CHIP_LIT or CHIP_FILL
            button:SetBackdropColor(fill[1], fill[2], fill[3], 1)
            label:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
            gold:SetShown(button.hover == true)
        end
    end
    button:SetScript("OnEnter", function(self)
        self.hover = true
        self.Paint()
        if not self.tipTitle then return end
        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:SetText(self.tipTitle)
        GameTooltip:AddLine(self.tip, 0.85, 0.85, 0.85, true)
        GameTooltip:Show()
        Kit.PlaceTooltip(GameTooltip, self)
    end)
    button:SetScript("OnLeave", function(self)
        self.hover = false
        self.Paint()
        GameTooltip:Hide()
    end)
    return button
end

function Kit.Move(frame, options)
    options = options or {}
    local x, width = options.x or 14, options.width or 508
    local move = { frame = frame, chips = {}, height = 0 }
    local function Locked() return not options.locked or options.locked() == true end

    local panel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    panel:SetPoint("TOPLEFT", x, -MOVE_TOP)
    panel:SetWidth(width)
    panel:SetBackdrop(BACKDROP)
    panel:SetBackdropColor(PANEL_FILL[1], PANEL_FILL[2], PANEL_FILL[3], 1)
    panel:SetBackdropBorderColor(GOLD[1], GOLD[2], GOLD[3], 1)
    move.panel = panel
    local shine = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    shine:SetPoint("TOPLEFT", 1, -1)
    shine:SetPoint("BOTTOMRIGHT", -1, 1)
    shine:SetBackdrop(EDGE)
    shine:SetBackdropBorderColor(1, 0.9, 0.55, 1)
    shine:SetAlpha(0)
    move.shine = shine
    -- A gold bar down the panel's left, inside it.
    local bar = panel:CreateTexture(nil, "ARTWORK")
    bar:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
    bar:SetWidth(RAIL_W + 1)
    bar:SetPoint("TOPLEFT", 1, -1)
    bar:SetPoint("BOTTOMLEFT", 1, 1)
    move.bar = bar

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 14, -8)
    title:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    title:SetText(options.title or "Move the bars")
    move.title = title
    local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    hint:SetJustifyH("LEFT")
    hint:SetWordWrap(true)
    hint:SetWidth(width - 24)
    hint:SetTextColor(GREY[1], GREY[2], GREY[3])
    hint:SetText(options.hint or "")
    move.hint = hint

    local unlock = BigButton(panel, UNLOCK_W)
    move.unlock = unlock
    unlock:SetScript("OnClick", function()
        if Locked() then
            if options.setLocked then options.setLocked(false) end
        elseif options.setLocked then
            options.setLocked(true)
        end
        move.Refresh()
    end)
    local screen = BigButton(panel, SCREEN_BUTTON_W)
    screen.label:SetText("Show on screen")
    screen.tipTitle, screen.tip = "Show on screen", options.screenTip or MOVE_SCREEN_TIP
    screen:SetScript("OnClick", function()
        if options.onScreen then options.onScreen() end
    end)
    move.screen = screen
    local status = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    status:SetJustifyH("LEFT")
    status:SetWordWrap(false)
    move.status = status
    local how = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    how:SetJustifyH("LEFT")
    how:SetWordWrap(true)
    how:SetWidth(width - 24)
    how:SetTextColor(1, 0.72, 0.3)
    move.how = how

    -- A chip per box, for addons that lock each box on its own: a click on a
    -- locked one unlocks it alone, on an unlocked
    -- one locks it.
    local function Chip(index)
        local chip = move.chips[index]
        if chip then return chip end
        chip = CreateFrame("Button", nil, panel, "BackdropTemplate")
        chip:SetHeight(CHIP_H - 4)
        chip:SetBackdrop(BACKDROP)
        chip:SetBackdropBorderColor(0, 0, 0, 1)
        chip:RegisterForClicks("LeftButtonUp")
        local gold = CreateFrame("Frame", nil, chip, "BackdropTemplate")
        gold:SetPoint("TOPLEFT", 1, -1)
        gold:SetPoint("BOTTOMRIGHT", -1, 1)
        gold:SetBackdrop(EDGE)
        gold:SetBackdropBorderColor(0.8, 0.62, 0.25, 1)
        gold:Hide()
        chip.gold = gold
        local box = chip:CreateTexture(nil, "OVERLAY")
        box:SetSize(8, 8)
        box:SetPoint("LEFT", 8, 0)
        chip.box = box
        local label = chip:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        label:SetPoint("LEFT", box, "RIGHT", 6, 0)
        label:SetWordWrap(false)
        chip.label = label
        function chip.Paint()
            local open = chip.part and chip.part.locked and chip.part.locked() == false
            local fill = chip.hover and CHIP_LIT or CHIP_FILL
            chip:SetBackdropColor(fill[1], fill[2], fill[3], 1)
            gold:SetShown(chip.hover == true)
            if open then
                box:SetColorTexture(1, 0.62, 0.1, 1)
                label:SetTextColor(1, 0.72, 0.3)
            else
                box:SetColorTexture(GREY[1], GREY[2], GREY[3], 1)
                label:SetTextColor(0.92, 0.92, 0.92)
            end
        end
        chip:SetScript("OnClick", function(self)
            local part = self.part
            if not part or not part.set then return end
            if part.locked and part.locked() == false then
                part.set(true)
            else
                part.set(false)
            end
            move.Refresh()
        end)
        chip:SetScript("OnEnter", function(self)
            self.hover = true
            self.Paint()
            if not self.part then return end
            local open = self.part.locked and self.part.locked() == false
            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetText(self.part.label)
            GameTooltip:AddLine(open and "Unlocked. Click to lock it in place."
                or "Locked. Click to unlock just this one, so you can drag it.", 0.85, 0.85, 0.85, true)
            GameTooltip:Show()
            Kit.PlaceTooltip(GameTooltip, self)
        end)
        chip:SetScript("OnLeave", function(self)
            self.hover = false
            self.Paint()
            GameTooltip:Hide()
        end)
        move.chips[index] = chip
        return chip
    end

    function move.Refresh()
        local locked = Locked()
        unlock.solid = locked
        unlock.label:SetText(locked and "Unlock to move" or "Lock in place")
        unlock.tipTitle = locked and "Unlock to move" or "Lock in place"
        unlock.tip = locked and (options.unlockTip or "Unlock the boxes: they show with samples so you can drag them.")
            or (options.lockTip or "Lock every box where it is.")
        unlock.Paint()
        screen.Paint()
        status:SetText(locked and (Kit.GREY .. "Locked|r") or (Kit.AMBER .. "Unlocked|r"))

        local y = MOVE_TITLE
        local hintText = options.hint or ""
        hint:ClearAllPoints()
        if hintText ~= "" then
            hint:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -y)
            y = y + (Number(hint:GetStringHeight()) or 12) + 6
        end
        unlock:ClearAllPoints()
        unlock:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -y)
        screen:ClearAllPoints()
        screen:SetPoint("LEFT", unlock, "RIGHT", 6, 0)
        status:ClearAllPoints()
        status:SetPoint("LEFT", screen, "RIGHT", 10, 0)
        y = y + MOVE_BUTTON_H + 6

        local parts = (options.parts and options.parts()) or {}
        local sizes = {}
        for index, part in ipairs(parts) do
            local chip = Chip(index)
            chip.part = part
            chip.label:SetWidth(0)
            chip.label:SetText(part.label or "")
            local textWidth = Number(chip.label:GetStringWidth()) or (#(part.label or "") * 6)
            local chipWidth = math.min(width - 28, math.max(CHIP_MIN, math.ceil(textWidth) + 30))
            chip:SetWidth(chipWidth)
            chip.label:SetWidth(chipWidth - 26)
            sizes[index] = { chipWidth, CHIP_H - 4 }
        end
        local places, chipsHeight = Kit.Flow(sizes, width - 28, CHIP_GAP, CHIP_GAP)
        for index, chip in ipairs(move.chips) do
            local place = places[index]
            if place then
                chip:ClearAllPoints()
                chip:SetPoint("TOPLEFT", panel, "TOPLEFT", 14 + place.x, -(y + place.y))
                chip:Show()
                chip.Paint()
            else
                chip:Hide()
                chip.part = nil
            end
        end
        if #parts > 0 then y = y + chipsHeight + 6 end

        local howText = options.how and (type(options.how) == "function" and options.how() or options.how) or nil
        how:ClearAllPoints()
        if not locked and howText and howText ~= "" then
            how:SetText(howText)
            how:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -y)
            how:Show()
            y = y + (Number(how:GetStringHeight()) or 12) + 4
        else
            how:SetText("")
            how:Hide()
        end

        local panelHeight = y + MOVE_PAD - 4
        panel:SetHeight(panelHeight)
        local total = MOVE_TOP + panelHeight + 6
        if total ~= move.height then
            move.height = total
            if options.resize then options.resize(total) else frame:SetHeight(total) end
        end
        return total
    end

    local pulseStart
    local function PulseStep(self)
        local t = GetTime() - pulseStart
        if t >= PULSE_BEAT * PULSE_BEATS then
            self:SetScript("OnUpdate", nil)
            shine:SetAlpha(0)
            return
        end
        shine:SetAlpha(math.sin(((t % PULSE_BEAT) / PULSE_BEAT) * math.pi))
    end
    function move.Pulse()
        pulseStart = GetTime()
        shine:SetScript("OnUpdate", PulseStep)
        PulseStep(shine)
    end
    panel:SetScript("OnShow", function() move.Refresh(); move.Pulse() end)
    panel:SetScript("OnHide", function()
        shine:SetScript("OnUpdate", nil)
        shine:SetAlpha(0)
    end)

    move.Refresh()
    return move
end

-- GetFrameStrata can return a secret (1.60.1.70291); the strata is then left.
function Kit.MatchStrata(sample, holder)
    local strata = holder:GetFrameStrata()
    if issecretvalue and issecretvalue(strata) then return end
    if type(strata) ~= "string" then return end
    sample:SetFrameStrata(strata)
end

-- Across, the sample must fit room; down, given height and roomHeight, it
-- must fit roomHeight too, and the smaller of the two scales wins.
function Kit.Scale(width, scale, notes, room, height, roomHeight)
    room = room or 496
    scale = scale or 1
    local fit
    if width * scale > room then fit = room / width end
    if type(height) == "number" and type(roomHeight) == "number" and height > 0 and height * scale > roomHeight then
        local down = roomHeight / height
        if not fit or down < fit then fit = down end
    end
    if fit then
        if notes then notes[#notes + 1] = "shrunk to fit" end
        return fit
    elseif scale ~= 1 and notes then
        notes[#notes + 1] = math.floor(scale * 100 + 0.5) .. "%"
    end
    return scale
end

-- Samples side by side, left to right, each line as tall as its tallest;
-- one that would pass room starts a new line (a sample wider than room
-- still gets a line of its own).
function Kit.Flow(sizes, room, gap, lineGap)
    room, gap, lineGap = room or 496, gap or 12, lineGap or 6
    local places, x, y, line, widest = {}, 0, 0, 0, 0
    for index, size in ipairs(sizes or {}) do
        local w, h = size[1] or size.width or 0, size[2] or size.height or 0
        if x > 0 and x + w > room then x, y, line = 0, y + line + lineGap, 0 end
        places[index] = { x = x, y = y }
        widest = math.max(widest, x + w)
        x = x + w + gap
        line = math.max(line, h)
    end
    return places, y + line, widest
end

function Kit.Copy(settings)
    local copy = {}
    for key, value in pairs(settings or {}) do copy[key] = value end
    return copy
end
