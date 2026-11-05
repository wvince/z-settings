local _, ns = ...
-- Forever page kit, kit 19 (26 October 2026; kits 1 to 11 on 23 October). The
-- workspace's one settings page toolkit (.claude/rules/ui-settings-pages.md): the code that builds an
-- addon's page in Options > AddOns (and in Forever Settings' window) out of
-- headings, rows and plain text, in the compact row style every addon shares.
-- Until kit 1 each addon carried its own copy of this code at the top of its
-- Settings.lua, and the copies drifted. Every addon that builds its page with
-- it carries an identical copy of this file at its root, listed in its TOC
-- before Settings.lua; tools/page-kit/PageKit.lua is the master and
-- tools/page-kit/Sync-PageKit.ps1 copies it out and checks the copies.
-- Change the master, never a copy. Test it with
--   lua5.1 tools/page-kit/tests/run.lua
-- Unlike the flat menu and preview kits it is required, like the price kit:
-- an addon without it has no settings page. Its Settings.lua checks
-- ns.PageKit first and, when the file is missing, says so once in chat
-- instead of building a page, so the addon still loads without an error.
--
-- The kit holds the look and the behaviour; the addon passes in what is its
-- own. ns.PageKit.New(options) -> kit. options:
--   get(key), set(key, value)  read and write one of the addon's settings
--   default(key)               its default (nil: none, no reset arrow)
--   limits                     table limits[key] = { low, high }, or
--                              function(key) -> { low, high }
--   format(key, value)         a slider's value text when its setting has no
--                              format of its own (default tostring)
--   groupOpen(key) -> true, false or nil (never clicked)
--   setGroupOpen(key, open)    where a heading's open state is saved
--   groupKey(title, page)      the key a heading's state is saved under
--                              (default its title); its More line's is
--                              key .. " / more". Each addon keeps its own
--                              format, so players keep which headings they
--                              had open.
--   columns   { nameX = 14, nameW = 196, c1 = 216, c2 = 372, cw = 150,
--               row = 26, body = 566 }: a row's name strip and its two
--               control columns
--   helpTabs  false: How to use sits under the settings on the same page,
--             no tabs (GANG secret); default true, a tab of its own
--   choices(key)               a key's choices in order, for row:Choice
--                              without a list of its own
--   nameKey(label, page)       the key of a row in page.rows and a heading in
--                              page.groups (default its label); page.scope is
--                              there to build it from (Forever Cast's
--                              "<scope> / <label>")
--   tipKeepsPart  true: a control with its own tip and no part of its own
--             points at its row's part under its own name (Forever Cast);
--             default false, it points at nothing
--   reload    the reload kit's Bar options (items, before, combat, refused,
--             tip): the amber bar above the scrolling rows (with
--             ReloadKit.lua; optional like that kit)
-- Kit 5 options:
--   tipTagsRow  true: a preview's tag on a control with its own tip names
--             its row, not the control (Forever Quests, Chat, Loadout,
--             Square Forever Minimap); default false (Forever Cast)
--   point(page, row, part, name)  takes the place of the previews: a row's
--             hover points here (row nil when it leaves), for an addon
--             that outlines the real thing (Square Forever Minimap)
--   frozen()  true, or a line of text, while the addon's setters refuse
--             (combat): sliders' step arrows dim and their tooltips say
--             only that line; they still click through to the setter
--   valueWidth  a slider's value text, px, for long values (default 46
--             with a reset arrow, 48 without; the track gives way)
--   moreName(label)  a row's name in a More line (default lower case)
--   noWrap    true: row names, button labels, status text and heading
--             summaries stay on one line, cut short (Forever Bank, Loadout)
--   tooltip() the tooltip frame to draw on (default GameTooltip; Forever
--             Loadout's SettingsTooltip); with it a leave hides it only
--             while the control that left owns it. For the whole file.
-- A setting passed to a row control is a key (read through get, set,
-- default and limits) or a table { key, get, set, limits, format, default }
-- for a value kept elsewhere (a key's default is filled in from default). A
-- table with dynamic = true (a picked bar's setting) is used as it is, its
-- key, default, limits and options read each time.
--
-- kit.pages                  every page by name (the addons' tests read it)
-- kit.NewPage(name, host) -> page. host nil: a page for Options > AddOns,
--   its own panel and scroll frame, answering Forever Settings' search
--   (panel.ForeverSettingsSearch). host (a gear's panel, an embedded block):
--   { content = frame, width = n, fit = fn(height), scroll = frame or nil,
--   frame = the window or nil, shownBy = a frame whose OnShow runs
--   page.Shown }: the same rows built into host.content, not searched, no
--   Move panel and no pinned preview; without shownBy the host calls
--   page.Shown() when it shows. page.host is host.
-- page.panel, page.body, page.scroll, page.rows (by label), page.list (rows
-- in order), page.notes, page.blocks, page.groups (by title), page.tab
-- ("settings" or "help"), page.tabs and page.tabButtons (How to use's tabs),
-- page.topCount (the blocks shown on both tabs), page.preview hooks below.
--   page.Block(height) -> frame, block   a block of the page
--   page.OnRefresh(fn), page.Refresh()   every control repaints from its
--                                         setting; a refresh inside one waits
--   page.Layout()                        stack the shown blocks
--   page.AfterLayout(fn)                 run fn after each layout
--   page.Scope(name)                     page.scope, for nameKey and
--                                         groupKey (default the page's name)
--   page.Group(title, open, summary, detail) -> group  a heading that opens
--     and closes; its open state saved under groupKey; summary() its grey
--     state words; detail its tooltip
--   page.BlizzardHeading(group, hidden)  the heading's rows are all
--     Blizzard's own settings (hidden: game settings no menu shows): the
--     word after its title, none on its rows
--   page.More()   the rows after it in this heading fold behind one grey
--     line ("+ 2 more: a, b"), opened by a click and saved like a heading; a
--     row whose value differs from its default never folds away
--   page.Help(summary, detail)  How to use, the page's last heading, always
--     open, on a tab of its own (helpTabs); page.Topic(title, detail) a gold
--     label under it (detail its tooltip, kit 14), page.Note(label, how,
--     detail) a line of plain text
--   page.Preview(onScreen, screenTip) -> preview  the preview kit's box as
--     the first block under the heading just made (nil without
--     PreviewKit.lua); page.Pin(onScreen, screenTip) one pinned above the
--     scrolling rows; page.Point(row, part, name) outlines a row's part;
--     page.Find(parts, within) opens and lights up the rows that change parts;
--     page.PartNames(parts, within)
--   page.Picker(options) -> picker  the preview kit's picker panel (nil
--     without it); page.Move(options) -> move  the preview kit's Move panel
--     at the top of the page, kept through a search (without the kit a
--     plain row with Unlock to move and Show on screen, unless options.
--     fallback is false; nil in a host)
--   page.Row(label, detail, part, height) -> row  one setting: its name in a
--     dark strip, its controls beside it; part names what it changes in its
--     heading's preview
--     row:Toggle(x, setting, width, name)  On or Off; name on a row of two
--       ("Enemy: On")
--     row:Choice(x, setting, choices, labels, width), or row:Choice(x,
--       setting, labels, width) with the setting's own choices: 2 or 3 step
--       (< Value >, a right-click back); 4 or more open the flat menu's list
--       (FlatMenu.lua; without it they step)
--     row:Pick(x, { list, get, set, users, empty }, width)  a dropdown over a
--       list that changes (profiles)
--     row:Input(x, submit, width, fill)  a text box; Enter submits
--     row:When(fn)  the row shows only while fn() is true
--     row:Reload(waiting, tip)  an amber Reload (or Restart) tag while
--       waiting() is true (or "restart"); tip the amber tooltip line
--     row:Slider(x, setting, step, unit, width)  < track > value and reset
--       arrow; unit (" px", optional) follows a value the setting does not
--       format; in a 150 px column the track is 61 px and the value 38 px
--       with a reset arrow (77 without), ending at the column's edge; the
--       value widens for a longer value, the track giving way (kit 9);
--       alone on its row, the whole row (kit 8); the arrows small buttons
--     row:Button(x, text, onClick, width, tip)
--     row:Tip(control, title, detail, part)  a control's own tooltip and
--       part on a row of two
--     row:DependsOn(control, enabled)  dims while enabled() is false; still
--       works (a slider's arrows, value and reset arrow dim with it)
--     row:Status(fn, x, width)  short grey text
--     row:Blizzard(where, how)  one of Blizzard's own settings (where nil:
--       a hidden game setting): its tag and tooltip lines
--   page.Changed(row)   the row's value differs from its default
--   page.Shown()        what the panel's OnShow runs (a host calls it)
-- Kit 5 calls:
--   page.Preview(onScreen, screenTip, plain), page.Pin(onScreen, screenTip,
--     plain): plain, a colour { r, g, b }, fills the box for a sample of a
--     window that is opaque in game (Forever World Map, Bank, Minimap)
--   page.Ticks(entries, columns) -> frame  tick boxes in columns, each
--     { key, label, title, detail, part } On or Off; page.ticks, every box;
--     each counts in a search and a click on its part finds it
--   page.Rows(id, entries, make, draw) -> rows  a row per entry that
--     follows the data (page.lists[id]); make(row, holder) once, draw(row,
--     entry) on each refresh
--   page.Section(title, note), page.Paragraph(text, lines)  a gold title
--     ending any heading, and grey text (fn() read on each refresh)
--   page.Note(label, how, detail, id)  how may be fn(), id tells notes apart
--   page.Try(key, value)  try a choice before picking it: page.trial while
--     a dropdown's choice is under the mouse (row:Choice does it), and
--     page.RefreshPreview(), set by the addon, redraws its preview
--   page.OpenTab(tab)   open on "settings" or "help", now or at next show
--   page.Refreshing()   true during a refresh
--   page.order          every heading in order, How to use too
--   page.pointedRow     the row the mouse points from, while it does
--   group.header        a heading's block frame
--   row:Edit(x, setting, width)  a text setting, saved as the box loses the
--     focus (a set that returns false refuses it); row.edit
--   row:Input(x, submit, width, fill, { button = text, letters = n })  with
--     a button after it that submits too (row.inputButton)
--   row:Tip(control, title, detail, part, blizzard)  part false: points at
--     nothing; blizzard { where, how }, its own lines
--   row:Slider(x, setting, step, nil, width) keeps the width; limits may be
--     fn(); setting.valueWidth; a step passes over notches that show the
--     same value
--   host.search  a host page answers Forever Settings' search too
--   kit.WIDE     both control columns (C2 + CW - C1)
-- Kit 7 (Forever DR, Enemy Buffs and GCD):
--   columns.c3   a third control column (kit.C3); FULL reaches its edge
--   page.Columns(titles, xs)  gold titles over the control columns, shown
--     with their heading (a search too); they name the buttons under them
--   page.Move({ ..., bothTabs = true })  after the header, on How to use
--     too; move.block is the panel's block
--   row:Choice(x, setting, labels, width, name)  "Target: Right"
--   options.tag(label, page) -> { tag, color, line }  a word on the row's
--     strip and a line in its tooltips (row.source)
--   options.valueWidth may be fn(width, reset)
--   page.Try(values, label), page.Try(key, value, label), page.trialLabel,
--     page.trialValues, page.Get(key)  several values tried at once
--   block.measure() its height at each layout; host.pad, the room under
--     the last block (default 12); host.unlisted, not in kit.pages
-- Kit 11 (Forever Battleground Timers, Targets, Range and Spy):
--   page.Note(label, how, detail, id, part)  hovering outlines part
--   row:AfterCombat()  in a host, dimmed and refused in combat, "After
--     combat" in tooltips (options.waitColor, options.waitKeepsValue)
--   page.Share(preview)  a heading's rows point into another's preview
--   page.Move({ ..., inTop = true, rowDetail })  after the header, still in
--     the page's top; block.moveKit
--   page.Block(height, kind) and block.kind on the kit's own blocks
--   options.control(key, control, row), options.listScroll (false: no
--     scroll), row.Track, row.actions, a slider's step from limits[3],
--     stepped values rounded, a drag writing only a change
--   column titles follow the rows under them (More folds them along)
-- Kit 12 (Forever Settings, Movable Forever Windows, GANG secret):
--   setting.onRelease  a drag writes when the mouse lets go
--   setting.wheel, options.sliderWheel  the mouse wheel steps a slider
--   row:Indent(px)  the name strip starts px further in
--   options.searchDetails  a detail that is fn() is searched too
--   options.nameKey(label, page, kind)  kind "row" or "group"
--   group.down  the heading's plus bar (group.plus)
-- Kit 13: page.Ticks(entries, columns, { x, width, gap, height, chip })
-- Kit 14 (for Forever Junk; each opt-in, so the pages already on the kit
-- draw and behave as before):
--   page.Topic(title, detail)  detail, its tooltip (block.detail)
--   page.Ticks(entries, columns, { withRow = true, ... })  boxes that
--     belong to the row just made: shown with it, in a search only when it
--     is found, never counted one by one; block.withRow, row.ticks
--   Kit.StepArrow(parent, direction, { peek, step, tip, title, detail, late,
--     enter, leave }) -> arrow  the sliders' 18 px boxed < or > (arrow.Paint)
--   row:Keep(control, title, tip, setting) -> control  adds an addon-built
--     control to the row: its tooltip, part pointing, After combat line,
--     setting tracked for Changed, dimmed by row:DependsOn
--   row:StepArrow(direction, { control, peek, step, tip, ... }) -> arrow
--     Kit.StepArrow on the row, pointing and waiting as a slider's arrows,
--     painted on each refresh; control.down or control.up
-- Kit 15 (for Forever Cooldowns' three pages; each opt-in):
--   setting.tips  { [value] = text } or fn(value): each choice's tooltip in
--     row:Choice's list
--   setting.mixed()  true: row:Toggle reads "Some", in gold
--   options.waitOnPage  true: row:AfterCombat waits on the settings page
--     too, as in a host (dimmed whole, refused, "After combat"); text
--     boxes and dropdowns of a waiting row refuse as well
--   page.Insert(height, owner, after, kind) -> frame, block  a block made
--     after the page is built, under heading owner after block after
--   page.Controls(row, frame, y, block) -> row  a row's methods on the
--     addon's own frame at y; with block, searched and counted as a row
--   block.empty, block.filtered  never shown, searched, counted or found
--   page.Resize(block, height) -> changed; page.Offset(block) -> px
--   group.SetOpen(open)  opens or closes a heading as a click does
--   page.Picker({ ..., blocks = fn() -> blocks })  the gold bar runs down
--     those blocks, and a search shows the picker with any of them
--   row:Pick(x, { ..., label = fn(value) -> text }, width)  each value's name
-- Kit 2 (Forever Threat's toolkit joins): a slider's unit, a tooltip whose
-- detail is a function, and group.summary, group.plus and control.readout
-- as Threat's tests read them. Kit 3 (the user): a slider's < and > each
-- take the mouse over an 18 px square (Kit.ARROW), never over the track,
-- the reset arrow or the next column. Kit 4 (Forever Cast's toolkit
-- joins): choices, nameKey, page.Scope, tipKeepsPart, the reload bar and
-- row:Reload, dropdown choices, row:Pick, row:Input, row:When, dynamic
-- settings, host.shownBy, Move's fallback, and pickers shown with their rows
-- in a search.
-- Kit 5 (the next six addons join: Forever World Map, Quests, Loadout,
-- Chat, Square Forever Minimap, Bank): the options and calls above; a
-- search no longer breaks on a row whose detail is fn(); tooltip titles may
-- be fn(); a disabled button does not light up on hover. Kit 6: page.Ticks'
-- boxes draw above their row's backdrop (an unticked box drew nothing and a
-- ticked one a bare gold square in the client). Kit 7: the calls above, and
-- Move's plain row after a header is the Settings tab's first block, as the
-- panel is (it went into the page's top). Kit 8 (the user's two slider
-- choices): a slider alone on its row takes the whole row, and the step
-- arrows are small buttons that cover nothing else. Kit 9 (the user): a
-- 38 px value, widened by itself for a slider whose longest value needs it,
-- so a slider sharing its row keeps a 61 px track. Kit 10: a slider before
-- another slider on its row leaves 4 px before the next one's < box (a 59 px
-- track in the standard columns). Kit 14 (the user's answers of 25 October
-- 2026, tools/page-kit/CONVERSIONS.md "Kit 14"): what Forever Junk needs
-- to join without losing anything: its How to use topic tooltips, its
-- quality ticks searched with their rule, and its coin ladder built from
-- the kit's own arrows (the sliders' arrows are now Kit.StepArrow too, drawn
-- and behaving as before). Market's heading box takes the kit's black edge
-- like every other page (the user, 25 October 2026), so no option for it.
-- Kit 15 (the user chose to teach the kit rather than leave Forever
-- Cooldowns' Abilities page on its own toolkit, CONVERSIONS.md "Kit 14",
-- answer 4): its gaps 1 to 9, so all three Cooldowns pages move with
-- nothing lost. page.Row's controls are now made by one function, public
-- as page.Controls; a page row's look is unchanged.
-- Kit 16 (the user, 25 October 2026: "go with your recommendation"): a
-- slider dimmed by row:DependsOn or waiting for combat dims its number too
-- when it has no reset arrow (the pieces' loop stopped at the missing one).
-- Kit 17 (Forever Diagnostics' Used most; the user, 25 October 2026: "1 A",
-- the look kept exactly; opt-in, so no other page changes):
--   page.Pinned(title, summary, detail) -> group  a heading that is always
--     open: no +/- box and no click, its title and line in gold, saving
--     nothing; each of its rows sits on a faint gold wash with a 2 px gold
--     bar down the left (row.wash, row.bar); group.pinned, group.head
-- Kit 18 (for Forever Skin's three pages, CONVERSIONS.md "Forever Skin" gaps
-- 1 to 7 and "Kit 18: the user's answers"; each opt-in but the last two):
--   page.Group(title, open, summary, detail, parent)  a heading inside
--     parent: indented 14 px, a fainter line, shown while parent is open,
--     opened with it by Find, all its rows found by parent's title, folded
--     with parent in a search, no Blizzard tag on its rows under a tagged
--     parent, its rows, More line and picker indented; groupKey(title, page,
--     parent); group.parent, group.subs
--   page.TickSets(columns) -> frame, block; page.TicksIn(frame, columns,
--     left, full, top) -> height, details; page.TicksHeight(columns)  tick
--     boxes in titled sets, columns = { { { title, entries }, ... }, ... },
--     an entry { key, label, title, detail, part, waiting, reloadTip }
--   row:Tip(control, title, detail, part, blizzard, { state, reload }), or
--     row:Tip(control, title, detail, part, { blizzard, state, reload }):
--     the control's own "Now: ...." line (state()) and reload line
--   page.PinTop(height) -> strip  the pinned strip with room for title
--     lines (page.header), made without PreviewKit.lua too; page.Pin(
--     onScreen, screenTip, plain, top) the preview under that room; on a
--     pinned page the reload bar hangs over the strip
--   page.Start()  ends the page's top (the blocks shown on both tabs)
--   row:Blizzard(where, how) with how fn() -> text
--   setting.enabled()  false: the control greyed (0.4) and disabled, no
--     click, drag, step, wheel or reset doing anything (Kit.Usable)
--   setting.default fn() -> number or nil (a slider's reset arrow hidden
--     while nil), setting.reset fn() (the reset arrow's click)
--   page.onFind(parts), page.onSearch(words)  set by the page: told of a
--     click on a part, and of each search (nil when it ends)
--   Every page: a More line folds its rows only while two or more are at
--     their default; a lone one shows as a plain row, no line (the rule "a
--     More line holds two or more rows")
--   Every page: every edge the kit draws is one physical screen pixel
--     (Kit.Px(frame, n), Kit.Edge(frame, edgeOnly), Kit.RefreshEdges())
-- Kit 19 (for Forever Combat Text, CONVERSIONS.md "Kit 19: decided without
-- a new question"; each opt-in but the last):
--   page.Share(preview, group, { search = false })  group: a heading built
--     before the preview (default the heading just made); search false: its
--     rows point into the preview and a click on a part finds them, but a
--     search that finds them shows them under their own heading only, not
--     the preview and its heading (group.pointOnly)
--   block.withRows = true  an addon's own block (Forever Combat Text's
--     preset tiles) shows in a search whenever a row under its heading is
--     found, as a preview does
--   Every page: a More line counts, names and folds only the rows it will
--     show: a row hidden by its When (row:When, block.when), or in an empty
--     or filtered block, is left out ("+ 3 more" while one of four hides)
-- Kit 20 (Forever Skin 0.54.0, every page):
--   A search reads a heading's tag (page.BlizzardHeading) with its title, as
--     it is drawn after it: "blizzard" finds the rows under a Blizzard
--     heading, whose rows carry no tag of their own
-- Kit 18's history: what Forever Skin needs to join without losing anything
-- (its sub-headings, titled ticks, locked CVars and per-control state lines,
-- its fixed title strip), and the user's two answers for every page
-- (CONVERSIONS.md "Kit 18", 3 and 4): a lone row no longer folds behind
-- "+ 1 more", and edges are one screen pixel where they were one UI unit
-- (about 2 pixels on a 4K screen at UI scale 0.65, under one at a small UI
-- scale on a 1080p screen, where an edge could vanish). Skin's pages take
-- the kit's fixed gold, not Skin's Accent (answer 1).
-- Kit 19's history: Forever Combat Text's toolkit pointed every heading
-- without a preview of its own into the Lanes preview and found rows
-- page-wide, while its search showed only a heading's own preview; the
-- pointing-only share keeps both. Its preset tiles showed beside a found
-- row of Presets, which a kit block did only as a preview or a picker.
-- Until kit 18 a More line counted a row its When hid (Combat Text's
-- Colours, for Your hits only, made the Lanes line read "4 more" and open
-- three), in Combat Text's toolkit and the kit alike.
-- Kit 20's history: Forever Skin's Nameplates page held Blizzard's options
-- under one heading titled Blizzard's nameplate options, so a search for
-- blizzard found every one of them by that title; from Skin 0.54.0 they
-- sit under their topics, three headings of Blizzard's alone carrying the
-- tag instead of a title that says it.
-- Helpers, on ns.PageKit and every kit: Text, PlaceTooltip, ShowTip,
-- Tooltip, Skin, Hover, Strip, ButtonWidget, Tick, StepArrow, Tag,
-- BlizzardLines, TipFrame, HideTip, OwnPoint, ResetArt, Px, Edge, RefreshEdges, Usable,
-- Differs, Unnamed(page) (rows of two On/Off buttons where one does not say
-- its own name, for the offline tests), and the colours WHITE, BACKDROP,
-- EDGE, GOLD, GREY, GREY_TEXT, BLIZZARD, HIDDEN, AMBER, HELP, ARROW. A kit also has its
-- columns: NAME_X, NAME_W, C1, C2, CW, ROW, FULL, WIDE.

local Kit = {}
ns.PageKit = Kit
Kit.VERSION = 20

local WHITE = "Interface\\Buttons\\WHITE8X8"
local BACKDROP = {
    bgFile = WHITE, edgeFile = WHITE,
    edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 },
}
local EDGE = { edgeFile = WHITE, edgeSize = 1 }
local GOLD = { 0.95, 0.76, 0.35 }
local GREY = { 0.55, 0.55, 0.58 }
local GREY_TEXT = "|cff8c8c94"
-- Blizzard's own settings (the user, 13 October 2026): blue for one found in
-- Blizzard's menus, violet for a game setting no menu shows.
local BLIZZARD = { 0.38, 0.7, 1 }
local HIDDEN = { 0.75, 0.6, 1 }
-- The reload kit's amber (ReloadKit.lua), here so a row's reload line shows
-- without that kit.
local AMBER = { 1, 0.7, 0.25 }
local HELP = "How to use"
-- A slider's step arrow: the square that takes the mouse (kit 3).
local ARROW = 18
Kit.ARROW = ARROW
Kit.WHITE, Kit.BACKDROP, Kit.EDGE = WHITE, BACKDROP, EDGE
Kit.GOLD, Kit.GREY, Kit.GREY_TEXT = GOLD, GREY, GREY_TEXT
Kit.BLIZZARD, Kit.HIDDEN, Kit.HELP, Kit.AMBER = BLIZZARD, HIDDEN, HELP, AMBER

-- One screen pixel (kit 18; the user, 25 October 2026, CONVERSIONS.md "Kit
-- 18", answer 4: "exactly one screen pixel, on every page") -------------------
-- Every edge the kit draws (backdrops, the +/- box, the More line, step
-- arrows, tick boxes, the hover's gold line) is one physical pixel, worked
-- out as Forever Skin's ns.Px does (ForeverSkin/Style.lua 117-125): one
-- pixel is 768 / (screen height in pixels x the frame's effective scale) of
-- the frame's units, the UI being 768 units tall at scale 1 (PixelUtil.lua,
-- Blizzard_SharedXML, GetPixelToUIUnitFactor; GetPhysicalScreenSize,
-- ScreenDocumentation, 1.60.1.70532). Unlike Skin's, which only widens an
-- edge where a unit is less than a pixel, this one also thins it where a
-- unit is more: on a 4K screen at UI scale 0.65 a 1-unit edge drew about 2
-- pixels and now draws 1. It is never less than a pixel, so it never
-- vanishes. The fills keep their size and colour. A pixel of MAX_PIXEL units
-- or more is a frame caught mid-change (Skin 0.8.18 drew an 85-pixel band
-- from one), so it keeps 1 unit; so does a build without the call, a secret
-- or missing measure, and the offline tests.
local MAX_PIXEL = 8
local function ScreenHeight()
    if type(GetPhysicalScreenSize) ~= "function" then return nil end
    local _, height = GetPhysicalScreenSize()
    return height
end
-- One pixel of frame in its units; height is the screen's, read once by
-- RefreshEdges for every edge.
local function Px(frame, height)
    if type(frame) ~= "table" or type(frame.GetEffectiveScale) ~= "function" then return 1 end
    if height == nil then height = ScreenHeight() end
    local scale = frame:GetEffectiveScale()
    if type(height) ~= "number" or type(scale) ~= "number" then return 1 end
    if issecretvalue and (issecretvalue(height) or issecretvalue(scale)) then return 1 end
    if height <= 0 or scale <= 0 then return 1 end
    local pixel = 768 / (height * scale)
    if pixel >= MAX_PIXEL then return 1 end
    return pixel
end
-- Kit.Px(frame, n) -> n screen pixels (default 1) in frame's units, as
-- Skin's ns.Px(frame, n) is called.
function Kit.Px(frame, n) return (n or 1) * Px(frame) end

-- The backdrop tables for an edge of size px, kept per size (one per scale
-- in use); size 1 is BACKDROP and EDGE themselves, so a page at a unit per
-- pixel draws exactly as before.
local backdropsBySize, edgesBySize = { [1] = BACKDROP }, { [1] = EDGE }
local function BackdropOf(px, edgeOnly)
    local cache = edgeOnly and edgesBySize or backdropsBySize
    if not cache[px] then
        if edgeOnly then
            cache[px] = { edgeFile = WHITE, edgeSize = px }
        else
            cache[px] = { bgFile = WHITE, edgeFile = WHITE, edgeSize = px,
                insets = { left = px, right = px, top = px, bottom = px } }
        end
    end
    return cache[px]
end
-- A backdrop of size px on frame, its colours kept: BackdropTemplateMixin's
-- ApplyBackdrop paints both white (Backdrop.lua 330-331).
local function ApplyBackdrop(frame, px, edgeOnly)
    local fill, border
    if frame.GetBackdropColor then fill = { frame:GetBackdropColor() } end
    if frame.GetBackdropBorderColor then border = { frame:GetBackdropBorderColor() } end
    frame:SetBackdrop(BackdropOf(px, edgeOnly))
    if fill and type(fill[1]) == "number" then frame:SetBackdropColor(fill[1], fill[2], fill[3], fill[4]) end
    if border and type(border[1]) == "number" then frame:SetBackdropBorderColor(border[1], border[2], border[3], border[4]) end
end

-- Every frame with an edge the kit drew, and how to draw it at a pixel size:
-- redrawn when its pixel changes (Kit.RefreshEdges: a page that shows, a
-- page whose own pixel moved at a refresh, the UI scale or the screen).
local edged = setmetatable({}, { __mode = "k" })
local function Edged(frame, apply)
    local px = Px(frame)
    edged[frame] = { apply = apply, px = px }
    apply(frame, px)
    return frame
end
function Kit.RefreshEdges()
    local height = ScreenHeight()
    for frame, info in pairs(edged) do
        local px = Px(frame, height)
        if px ~= info.px then
            info.px = px
            info.apply(frame, px)
        end
    end
end
-- Kit.Edge(frame, edgeOnly) -> frame: the kit's backdrop on the addon's own
-- frame (its BackdropTemplate), a dark fill in a one-pixel edge, or the edge
-- alone (edgeOnly), kept one pixel as the kit's own are.
function Kit.Edge(frame, edgeOnly)
    return Edged(frame, function(self, px) ApplyBackdrop(self, px, edgeOnly) end)
end
local Edge = Kit.Edge
-- The UI scale and the screen size (UI_SCALE_CHANGED, UIManagerDocumentation;
-- DISPLAY_SIZE_CHANGED, VideoDocumentation) redraw the edges once, the frame
-- after the client's dispatch, as Forever Skin's WindowScale.lua does
-- (the client fires both inside a CVar write). Made with the first page.
local watcher, edgesPending
local function WatchScale()
    if watcher or type(CreateFrame) ~= "function" then return end
    watcher = CreateFrame("Frame")
    watcher:RegisterEvent("UI_SCALE_CHANGED")
    watcher:RegisterEvent("DISPLAY_SIZE_CHANGED")
    watcher:SetScript("OnEvent", function()
        if edgesPending then return end
        if not (C_Timer and C_Timer.After) then Kit.RefreshEdges(); return end
        edgesPending = true
        C_Timer.After(0, function()
            edgesPending = false
            Kit.RefreshEdges()
        end)
    end)
end

-- Widgets -----------------------------------------------------------------------
-- A line of small text at x, y; to the parent's right edge without width.
function Kit.Text(parent, text, x, y, color, width)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetPoint("TOPLEFT", x, y)
    if width then label:SetWidth(width) else label:SetPoint("TOPRIGHT", -14, y) end
    label:SetJustifyH("LEFT")
    label:SetText(text)
    if color then label:SetTextColor(color[1], color[2], color[3]) end
    return label
end
local Text = Kit.Text

-- A settings tooltip never covers its row (the user, 15 October 2026): it
-- sits beside the window that holds the page (owner's topmost frame below
-- UIParent), level with owner; right of the window when it fits, else left,
-- else under owner (over it when owner is low on the screen). Call it once
-- the tooltip is filled and shown, so its size is known. A secret or missing
-- measure falls back to centred above owner.
local function Measure(value)
    if type(value) ~= "number" or (issecretvalue and issecretvalue(value)) then return nil end
    return value
end
function Kit.PlaceTooltip(tip, owner)
    tip:ClearAllPoints()
    if not UIParent then
        tip:SetPoint("BOTTOM", owner, "TOP")
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
        tip:SetPoint("BOTTOM", owner, "TOP")
        return
    end
    local gap = 4
    width, screen = width * tipScale, screen * parentScale
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
local PlaceTooltip = Kit.PlaceTooltip

-- A Blizzard setting's tag, colour and two tooltip lines; info is
-- { where, how } (where nil: a game setting no Blizzard menu shows).
-- Kit 18: how may be fn() -> text, read each time the lines are drawn
-- (Forever Skin's ReloadHow and VISIBILITY, ForeverSkin/Settings.lua
-- 3874-3881 and 3902-3909: what holds the CVar for a reload, and whether
-- Forever Visibility is loaded); nil from it gives the plain line.
function Kit.BlizzardLines(info)
    local how = info.how
    if type(how) == "function" then how = how() end
    if not info.where then
        return "Hidden", HIDDEN, "Hidden game setting: the game keeps it, but no Blizzard menu shows it.",
            how or "It stays as set without this addon."
    end
    return "Blizzard", BLIZZARD, "Blizzard's own setting, also in " .. info.where .. ".",
        how or "The game keeps it: a change here shows there too and stays without this addon."
end
local BlizzardLines = Kit.BlizzardLines

-- The tooltip the kit draws on: GameTooltip, or the addon's own (options.
-- tooltip, kit 5: Forever Loadout's SettingsTooltip). With its own, a leave
-- hides it only while the control that left owns it.
function Kit.TipFrame()
    local own = Kit.tooltipFrame and Kit.tooltipFrame()
    return own or GameTooltip
end
local TipFrame = Kit.TipFrame
function Kit.HideTip(owner)
    local tip = TipFrame()
    if Kit.tooltipFrame and owner and tip.GetOwner and tip:GetOwner() ~= owner then return end
    tip:Hide()
end
local HideTip = Kit.HideTip

-- A tooltip: title, detail in light grey, and a Blizzard setting's lines in
-- its colour (info, when given).
-- amber: a reload line, or fn() giving one or nil, in the reload kit's amber.
-- title and detail may be fn() too, read now (kit 5). source (kit 7): a
-- row's own tag, { tag, color, line }, its line after the detail in its
-- colour (options.tag).
-- late (kit 11): { text, color }, a last line (Forever Targets' After combat).
-- now (kit 18, Forever Skin's row:Tip state, ForeverSkin/Settings.lua
-- 207-212): text, or fn() giving it, of what holds the setting now ("after
-- combat", "after reload", "not on this build"): an amber "Now: ...." line
-- after the reload line, its colour codes taken out.
function Kit.ShowTip(owner, title, detail, info, amber, source, late, now)
    local tip = TipFrame()
    if type(title) == "function" then title = title() end
    if type(detail) == "function" then detail = detail() end
    tip:SetOwner(owner, "ANCHOR_NONE")
    tip:SetText(title or "")
    if detail then tip:AddLine(detail, 0.85, 0.85, 0.85, true) end
    if type(source) == "table" and source.line then
        local color = source.color or GREY
        tip:AddLine(source.line, color[1], color[2], color[3], true)
    end
    if info then
        local _, color, where, how = BlizzardLines(info)
        tip:AddLine(where, color[1], color[2], color[3], true)
        tip:AddLine(how, color[1], color[2], color[3], true)
    end
    if type(amber) == "function" then amber = amber() end
    if type(amber) == "string" then tip:AddLine(amber, AMBER[1], AMBER[2], AMBER[3], true) end
    if type(now) == "function" then now = now() end
    if type(now) == "string" and now ~= "" then
        local plain = now:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        tip:AddLine("Now: " .. plain .. ".", AMBER[1], AMBER[2], AMBER[3], true)
    end
    if type(late) == "table" and late.text then
        local color = late.color or AMBER
        tip:AddLine(late.text, color[1], color[2], color[3], true)
    end
    tip:Show()
    PlaceTooltip(tip, owner)
end
local ShowTip = Kit.ShowTip

-- point(over, part, name), when given, is told the mouse is over the control
-- or has left it (a row's part outlined in its heading's preview). A control
-- on a row of two may carry its own tip, { title, detail, part, blizzard }
-- (row:Tip), read at hover time; one with its own tip and no part points at
-- nothing, or (row.keepsPart, tipKeepsPart) at its row's part, and one whose
-- part is false at nothing either way. The preview's tag names the control
-- (its own title) unless row.tagsRow (tipTagsRow): then the row. row, when
-- given, adds its Blizzard lines (row:Blizzard; a control's own replace
-- them) and its amber reload line (row:Reload). title and detail may be fn()
-- for a tooltip that changes.
local function OwnPoint(point, own, row)
    if own and (own.part == false or (own.part == nil and not (row and row.keepsPart))) then
        point(false)
    else
        point(true, own and own.part or nil, own and not (row and row.tagsRow) and own.title or nil)
    end
end
Kit.OwnPoint = OwnPoint
function Kit.Tooltip(control, title, detail, point, row)
    if not detail and not point then return end
    control:HookScript("OnEnter", function(self)
        local own = type(self.tip) == "table" and self.tip or nil
        if point then OwnPoint(point, own, row) end
        local shown = own and own.detail or detail
        if type(shown) == "function" then shown = shown() end
        if not shown then return end
        local late = row and self.waitable and row.WaitLine and row.WaitLine() or nil
        -- Kit 18: a control's own reload line (row:Tip's extra.reload) in
        -- place of the row's, and its own state line (extra.state).
        local amber = (own and own.reload) or (row and row.amberTip)
        ShowTip(self, own and own.title or title, shown, (own and own.blizzard) or (row and row.blizzard), amber,
            row and row.source, late, own and own.state)
    end)
    control:HookScript("OnLeave", function(self)
        if point then point(false) end
        if detail or type(self.tip) == "table" then HideTip(self) end
    end)
end
local Tooltip = Kit.Tooltip

-- The border stays black; hover adds a gold line just inside it, never on
-- a disabled button (kit 5, Forever Loadout).
function Kit.Skin(control, hover)
    control:SetBackdropColor(hover and 0.24 or 0.14, hover and 0.20 or 0.145, hover and 0.12 or 0.16, 1)
    control:SetBackdropBorderColor(0, 0, 0, 1)
    if not control.gold then
        local gold = CreateFrame("Frame", nil, control, "BackdropTemplate")
        -- Kit 18: one pixel inside the black, one pixel wide.
        Edged(gold, function(self, px)
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", px, -px)
            self:SetPoint("BOTTOMRIGHT", -px, px)
            self:SetBackdrop(BackdropOf(px, true))
            self:SetBackdropBorderColor(0.8, 0.62, 0.25, 1)
        end)
        control.gold = gold
    end
    control.gold:SetShown(hover)
end
local Skin = Kit.Skin
function Kit.Hover(control)
    Skin(control, false)
    control:SetScript("OnEnter", function(self) Skin(self, not (self.IsEnabled and self:IsEnabled() == false)) end)
    control:SetScript("OnLeave", function(self) Skin(self, false) end)
end
local Hover = Kit.Hover

-- A row's name: a dark strip, not a control.
function Kit.Strip(parent, x, y, width, text)
    local strip = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    strip:SetPoint("TOPLEFT", x, y)
    strip:SetSize(width, 22)
    Edge(strip)
    strip:SetBackdropColor(0.11, 0.115, 0.13, 1)
    strip:SetBackdropBorderColor(0, 0, 0, 1)
    strip:EnableMouse(true)
    strip.label = strip:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    strip.label:SetPoint("LEFT", 8, 0)
    strip.label:SetPoint("RIGHT", -8, 0)
    strip.label:SetJustifyH("LEFT")
    strip.label:SetText(text)
    return strip
end
local Strip = Kit.Strip

-- A word at the right end of a name strip, the name stopping 4 px before it
-- on one line (the Blizzard and Hidden tags).
function Kit.Tag(strip, text, color)
    strip.tag = strip:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    strip.tag:SetPoint("RIGHT", -6, 0)
    strip.tag:SetText(text)
    strip.tag:SetTextColor(color[1], color[2], color[3])
    strip.label:SetPoint("RIGHT", strip.tag, "LEFT", -4, 0)
    strip.label:SetWordWrap(false)
end
local Tag = Kit.Tag

-- A flat button: black edge, gold text, a gold line inside on hover.
function Kit.ButtonWidget(parent, x, y, width, text)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetPoint("TOPLEFT", x, y)
    button:SetSize(width, 22)
    Edge(button)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button.label = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    button.label:SetPoint("LEFT", 8, 0)
    button.label:SetPoint("RIGHT", -8, 0)
    button.label:SetText(text or "")
    button.label:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    Hover(button)
    return button
end
local ButtonWidget = Kit.ButtonWidget

-- A tick box for page.Ticks (kit 5, Forever World Map's list of what the map
-- draws): the button's look, a dark 12 px box at its left that fills gold
-- (8 px) when on, and its label after it.
-- Kit 6: the box was a BACKGROUND texture, the layer and sublevel of the
-- backdrop's own Center fill (Blizzard_SharedXML/Backdrop.lua ApplyBackdrop,
-- NineSlice.lua SetDrawLayer), so which one drew on top was not fixed: in
-- the client the row's fill covered it, leaving no box and a bare gold mark
-- (1.60.1.70425, Forever World Map 0.55.0). Every piece now has a layer
-- above the backdrop's: a 1 px black edge (ARTWORK -2) round a dark fill
-- (ARTWORK -1), the gold mark over both (ARTWORK 0). control.boxEdge,
-- control.box, control.mark.
function Kit.Tick(parent, x, y, width, text)
    local control = CreateFrame("CheckButton", nil, parent, "BackdropTemplate")
    control:SetPoint("TOPLEFT", x, y)
    control:SetSize(width, 22)
    local edge = control:CreateTexture(nil, "ARTWORK", nil, -2)
    edge:SetPoint("LEFT", 6, 0)
    edge:SetSize(12, 12)
    edge:SetColorTexture(0, 0, 0, 1)
    local box = control:CreateTexture(nil, "ARTWORK", nil, -1)
    box:SetPoint("CENTER", edge, "CENTER", 0, 0)
    box:SetColorTexture(0.04, 0.04, 0.05, 1)
    control.boxEdge, control.box = edge, box
    -- Kit 18: the button's edge and the box's black ring one pixel each;
    -- the box keeps its 12 px, its dark fill the rest.
    Edged(control, function(self, px)
        ApplyBackdrop(self, px)
        box:SetSize(12 - 2 * px, 12 - 2 * px)
    end)
    Hover(control)
    control:SetCheckedTexture(WHITE)
    local mark = control:GetCheckedTexture()
    if mark then
        mark:ClearAllPoints()
        mark:SetDrawLayer("ARTWORK", 0)
        mark:SetPoint("CENTER", edge, "CENTER", 0, 0)
        mark:SetSize(8, 8)
        mark:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 1)
        control.mark = mark
    end
    control.label = control:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    control.label:SetPoint("LEFT", 24, 0)
    control.label:SetPoint("RIGHT", -6, 0)
    control.label:SetJustifyH("LEFT")
    control.label:SetText(text)
    return control
end
local Tick = Kit.Tick

-- A step arrow (kit 14, public; it was private inside row:Slider): kit 8's
-- small button on an 18 px square (ARROW), a dark fill in a 1 px black edge
-- (ARTWORK -2 and -1, above any backdrop's Center fill, kit 6), the < or >
-- centred over them; the edge gold under the mouse; the glyph grey, gold
-- under the mouse, and dark while there is no step to take. Forever Junk's
-- coin ladder (`< 1s >`, ForeverJunk/Settings.lua 751-775, Widgets.lua
-- 133-167) is built from it, so its arrows match the sliders' (the user, 25
-- October 2026, CONVERSIONS.md "Kit 14", answer 2). direction -1 (<) or 1
-- (>). arrowOptions, all optional:
--   peek(direction)  the value a click would set, nil at that end (dark)
--   step(direction, arrow)  the click; true when it stepped, so a tooltip
--     under the mouse is filled again from the new value
--   tip(tooltip, direction)  fills the tooltip itself (Junk's
--     PriceRules.ArrowTip), placed beside the window as every kit tooltip
--   title, detail  (text or fn(direction)) the tooltip, drawn by ShowTip
--     when there is no tip
--   late()  the tooltip's last line either way, { text, color } or nil
--     (kit 11's After combat)
--   enter(arrow, direction), leave(arrow)  run as the mouse comes and goes
--     (a row's part pointed at)
-- arrow.Paint() paints it (call it once the value can be read, and when it
-- changes; row:StepArrow does it on each refresh); arrow.atEnd, arrow.edge,
-- arrow.fill, arrow.label, arrow.hovered, arrow.direction.
function Kit.StepArrow(parent, direction, arrowOptions)
    arrowOptions = arrowOptions or {}
    local arrow = CreateFrame("Button", nil, parent)
    arrow:SetSize(ARROW, 18)
    arrow.direction = direction
    arrow.edge = arrow:CreateTexture(nil, "ARTWORK", nil, -2)
    arrow.edge:SetAllPoints()
    arrow.edge:SetColorTexture(0, 0, 0, 1)
    arrow.fill = arrow:CreateTexture(nil, "ARTWORK", nil, -1)
    arrow.fill:SetColorTexture(0.14, 0.145, 0.16, 1)
    -- Kit 18: the edge one pixel round the fill.
    Edged(arrow, function(_, px)
        arrow.fill:ClearAllPoints()
        arrow.fill:SetPoint("TOPLEFT", px, -px)
        arrow.fill:SetPoint("BOTTOMRIGHT", -px, px)
    end)
    arrow.label = arrow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    arrow.label:SetPoint("CENTER", 0, 0)
    arrow.label:SetText(direction < 0 and "<" or ">")
    function arrow.Paint()
        local lit = not arrowOptions.peek or arrowOptions.peek(direction) ~= nil
        arrow.atEnd = not lit
        if lit and arrow.hovered then arrow.label:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
        elseif lit then arrow.label:SetTextColor(GREY[1], GREY[2], GREY[3])
        else arrow.label:SetTextColor(0.25, 0.25, 0.27) end
        if arrow.hovered then arrow.edge:SetColorTexture(0.8, 0.62, 0.25, 1)
        else arrow.edge:SetColorTexture(0, 0, 0, 1) end
    end
    local function Read(value)
        if type(value) == "function" then return value(direction) end
        return value
    end
    local function Enter(self)
        arrow.hovered = true
        arrow.Paint()
        if arrowOptions.enter then arrowOptions.enter(self, direction) end
        if arrowOptions.tip then
            local tip = TipFrame()
            tip:SetOwner(self, "ANCHOR_NONE")
            arrowOptions.tip(tip, direction)
            local late = arrowOptions.late and arrowOptions.late()
            if type(late) == "table" and late.text then
                local color = late.color or AMBER
                tip:AddLine(late.text, color[1], color[2], color[3], true)
            end
            tip:Show()
            PlaceTooltip(tip, self)
        elseif arrowOptions.title or arrowOptions.detail then
            ShowTip(self, Read(arrowOptions.title), Read(arrowOptions.detail), nil, nil, nil,
                arrowOptions.late and arrowOptions.late() or nil)
        end
    end
    arrow:SetScript("OnEnter", Enter)
    arrow:SetScript("OnLeave", function(self)
        arrow.hovered = false
        arrow.Paint()
        if arrowOptions.leave then arrowOptions.leave(self) end
        HideTip(self)
    end)
    arrow:SetScript("OnClick", function(self)
        local stepped = arrowOptions.step and arrowOptions.step(direction, self)
        arrow.Paint()
        if stepped and arrow.hovered then Enter(self) end
    end)
    -- Not painted here: peek may read a setting, and a slider's first
    -- paint has always waited for the page's first refresh.
    return arrow
end
local StepArrow = Kit.StepArrow

-- A slider's reset arrow (.claude/rules/ui-windows-and-menus.md, "Reset
-- arrows"): Blizzard's undo icon (ModelSceneControlFrame.lua's reset button,
-- Blizzard_SharedXML), or its refresh arrows on a build without the atlas;
-- in colour while the value differs from its default by half a step or
-- more, when a click sets the default, and grey once it is the default.
-- Drawn as FlatMenu.lua's.
local RESET_ATLAS, RESET_FILE = "common-icon-undo", "Interface\\Buttons\\UI-RefreshButton"
function Kit.ResetArt(texture, changed)
    if not texture.resetArt then
        if C_Texture.GetAtlasInfo(RESET_ATLAS) then texture:SetAtlas(RESET_ATLAS) else texture:SetTexture(RESET_FILE) end
        texture.resetArt = true
    end
    texture:SetDesaturated(not changed)
    if changed then texture:SetVertexColor(1, 1, 1, 1) else texture:SetVertexColor(0.5, 0.5, 0.52, 1) end
end
local ResetArt = Kit.ResetArt
function Kit.Differs(value, default, step)
    if type(value) ~= "number" or type(default) ~= "number" then return false end
    return math.abs(value - default) >= math.max((step or 0) / 2, 1e-6)
end
local Differs = Kit.Differs
-- setting.enabled (kit 18, Forever Skin's, ForeverSkin/Settings.lua 337 and
-- 1128-1131): fn() false while the setting cannot be used now (a Blizzard
-- CVar this build lacks or locks). Its control is greyed (0.4) and disabled,
-- and no click, drag, step, wheel or reset does anything; without it the
-- locked CVars' controls looked live.
local function Usable(setting)
    if type(setting) ~= "table" or not setting.enabled then return true end
    return setting.enabled() and true or false
end
Kit.Usable = Usable

-- The rows of a page that hold two or more On/Off buttons where one does not
-- say its own name ("Enemy: On"; the user, 23 October 2026: everywhere), by
-- label, for the offline tests.
function Kit.Unnamed(page)
    local labels = {}
    for _, row in ipairs(page.list) do
        -- Kit 7: under column titles (page.Columns) each button is named by
        -- its column's title.
        local toggles, unnamed = 0, false
        for _, control in ipairs(row.controls) do
            if control.toggleName ~= nil then
                toggles = toggles + 1
                unnamed = unnamed or control.toggleName == false
            end
        end
        local titled = row.group and row.group.columns
        if toggles >= 2 and unnamed and not titled then labels[#labels + 1] = row.label end
    end
    return labels
end

-- A kit ---------------------------------------------------------------------------
function Kit.New(options)
    options = options or {}
    local columns = options.columns or {}
    local NAME_X, NAME_W = columns.nameX or 14, columns.nameW or 196
    local C1, C2, CW = columns.c1 or 216, columns.c2 or 372, columns.cw or 150
    local ROW, BODY = columns.row or 26, columns.body or 566
    -- c3 (kit 7, Forever DR's family): a third control column; the
    -- headings, notes and panels then reach its edge.
    local C3 = columns.c3
    local FULL = (C3 or C2) + CW - NAME_X
    local WIDE = C2 + CW - C1
    local kit = setmetatable({ options = options, pages = {},
        NAME_X = NAME_X, NAME_W = NAME_W, C1 = C1, C2 = C2, C3 = C3, CW = CW, ROW = ROW, FULL = FULL, WIDE = WIDE }, { __index = Kit })
    local helpTabs = options.helpTabs ~= false
    -- The addon's own tooltip frame (kit 5): for the whole file, the static
    -- helpers too.
    if options.tooltip then Kit.tooltipFrame = options.tooltip end
    -- noWrap: names, button labels, status text and heading summaries stay
    -- on one line, cut short rather than wrapped (Forever Bank, Loadout).
    local function NoWrap(text)
        if options.noWrap and text and text.SetWordWrap then text:SetWordWrap(false) end
        return text
    end
    -- A row's name in its heading's More line (default all lower case).
    local function MoreName(label)
        if options.moreName then return options.moreName(label) end
        return label:lower()
    end

    local function GroupOpen(key)
        if options.groupOpen then return options.groupOpen(key) end
        return nil
    end
    local function SetGroupOpen(key, open)
        if options.setGroupOpen then options.setGroupOpen(key, open) end
    end
    local function Limits(key)
        local limits = options.limits
        if type(limits) == "function" then return limits(key) end
        return type(limits) == "table" and limits[key] or nil
    end
    -- A setting key, or { key, get, set, limits, format, default } for a
    -- value kept elsewhere; a key's default is its saved default.
    local function Adapter(key)
        if type(key) == "table" then
            -- A dynamic setting (a picked bar's) works its key, default,
            -- limits and choices out on every read: left as it is.
            if key.dynamic then return key end
            if key.default == nil and key.key and options.default then key.default = options.default(key.key) end
            if key.limits == nil and key.key then key.limits = Limits(key.key) end
            if key.options == nil and key.key and options.choices then key.options = options.choices(key.key) end
            return key
        end
        local default
        if options.default then default = options.default(key) end
        return { key = key, get = function() return options.get(key) end, set = function(value) return options.set(key, value) end,
            limits = Limits(key), default = default, options = options.choices and options.choices(key) or nil }
    end
    kit.Adapter = Adapter
    local function Format(setting, value)
        if setting.format then return setting.format(value) end
        if options.format and setting.key then return options.format(setting.key, value) end
        return tostring(value)
    end

    function kit.NewPage(name, host)
        local page = { name = name, host = host, rows = {}, list = {}, notes = {}, blocks = {}, refreshers = {}, groups = {}, laid = {},
            scope = name, order = {}, lists = {} }
        -- host.unlisted (kit 7): a gear's panel kept out of kit.pages.
        if not (host and host.unlisted) then kit.pages[name] = page end
        local panel, scroll, body
        if host then
            panel, scroll = host.frame or host.content, host.scroll
            body = CreateFrame("Frame", nil, host.content)
            body:SetPoint("TOPLEFT")
            body:SetSize(host.width or BODY, 400)
        else
            panel = CreateFrame("Frame", nil, UIParent)
            panel:Hide()
            scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
            scroll:SetPoint("TOPLEFT", 16, -16)
            scroll:SetPoint("BOTTOMRIGHT", -34, 16)
            body = CreateFrame("Frame", nil, scroll, "BackdropTemplate")
            body:SetSize(BODY, 400)
            Edge(body)
            body:SetBackdropColor(0.075, 0.08, 0.09, 0.98)
            body:SetBackdropBorderColor(0, 0, 0, 1)
            scroll:SetScrollChild(body)
            scroll:SetScript("OnSizeChanged", function(_, width) body:SetWidth(width) end)
        end
        page.panel, page.body, page.scroll = panel, body, scroll

        -- A change that refreshes the page again (a setter calling the
        -- addon's refresh) waits for the refresh under way.
        local refreshing = false
        function page.OnRefresh(fn) page.refreshers[#page.refreshers + 1] = fn end
        -- Kit 18: the edges stay one pixel when the page's scale moves (a
        -- window's scale, Blizzard's Settings panel taking the panel): its
        -- body's pixel is read at each refresh, and every edge redrawn when
        -- it changed. page.edgePx is the body's pixel.
        WatchScale()
        function page.Refresh()
            if refreshing then return end
            local px = Px(body)
            if px ~= page.edgePx then
                page.edgePx = px
                Kit.RefreshEdges()
            end
            refreshing = true
            for _, fn in ipairs(page.refreshers) do fn() end
            refreshing = false
        end
        -- True while a refresh runs (a control's own handler may wait).
        function page.Refreshing() return refreshing end
        function page.AfterLayout(fn) page.laid[#page.laid + 1] = fn end
        -- The page's section for its keys (nameKey, groupKey): the page's
        -- name until page.Scope names another; draws nothing.
        function page.Scope(scope) page.scope = scope end
        -- kind (kit 12, GANG secret): "row" or "group", so an addon can key
        -- rows by their heading and headings by their title.
        local function NameKey(label, kind)
            if options.nameKey then return options.nameKey(label, page, kind) end
            return label
        end
        -- The reload kit's amber bar (ReloadKit.lua; optional, like the
        -- kit), pinned above the scrolling rows while a change waits for a
        -- reload: options.reload is the kit's Bar options (items, before,
        -- combat, refused, tip). Not in a host, which shows the rows' tags.
        if scroll and not host and ns.ReloadKit and options.reload then
            page.reloadBar = ns.ReloadKit.Bar(scroll, options.reload)
            page.OnRefresh(page.reloadBar.Refresh)
        end

        -- Blocks stack top to bottom; a group's blocks show while it is open.
        local group
        -- While Forever Settings' search box holds words: the blocks to draw,
        -- else nil and the page draws as usual.
        local found
        -- Rows after page.More() are their heading's fine-tuning (fine);
        -- blocks from page.Help on are the How to use tab's (help); the
        -- blocks before the first row, heading or preview are the page's
        -- top (the title and status line), shown on both tabs.
        local fine, inHelp, started = false, false, false
        page.tab = "settings"
        -- A heading and every heading it sits in are open (kit 18: headings
        -- inside a heading, page.Group's parent).
        local function Open(this)
            while this do
                if not this.open then return false end
                this = this.parent
            end
            return true
        end
        -- Each heading's blocks shown or not as it and the headings it sits
        -- in are open: after a heading opens or closes, or Find opens some.
        local function Reshow()
            for _, block in ipairs(page.blocks) do
                if block.group then block.shown = Open(block.group) end
            end
        end
        -- The indent of what sits under a heading inside another (kit 18,
        -- Forever Skin's INDENT, ForeverSkin/Settings.lua 73): its title,
        -- line, rows, More line and picker.
        local INDENT = 14
        local function IndentOf(this) return (this and this.parent) and INDENT or 0 end
        -- kind (kit 11, Forever Spy's tests): what the block is; the kit's
        -- own say "group", "row", "note", "topic", "tabs", "preview",
        -- "more", "move", "picker", "columns", "ticks", "list", "section"
        -- and "paragraph".
        function page.Block(height, kind)
            local frame = CreateFrame("Frame", nil, body)
            frame:SetHeight(height)
            local block = { frame = frame, height = height, shown = true, group = group, help = inHelp, kind = kind }
            page.blocks[#page.blocks + 1] = block
            if group then
                group.members[#group.members + 1] = block
                block.shown = Open(group)
            end
            return frame, block
        end
        -- page.Insert(height, owner, after, kind) -> frame, block (kit 15,
        -- Forever Cooldowns' page.Insert, Options.lua 891, for its ability
        -- lists that grow, Studio.lua 742-776): a block made after the page
        -- is built, under heading owner (nil: none), straight after block
        -- after (default: the last block of owner, or the end of the page
        -- without one). It shows while owner is open. Give it controls with
        -- page.Controls(row, frame, y, block), and it is searched and
        -- counted as a row; set block.empty or block.filtered to leave it
        -- out of the page, search and counts; page.Resize grows it (an
        -- editor opening inside it). Call page.Layout() after.
        function page.Insert(height, owner, after, kind)
            local frame = CreateFrame("Frame", nil, body)
            frame:SetHeight(height)
            local block = { frame = frame, height = height, group = owner, kind = kind or "row",
                shown = owner == nil or Open(owner), help = owner ~= nil and owner.always == true }
            if not after and owner then after = owner.members[#owner.members] or owner.block end
            local at = #page.blocks + 1
            for index, other in ipairs(page.blocks) do
                if other == after then at = index + 1; break end
            end
            table.insert(page.blocks, at, block)
            if owner then
                local place = #owner.members + 1
                for index, member in ipairs(owner.members) do
                    if member == after then place = index + 1; break end
                end
                table.insert(owner.members, place, block)
            end
            return frame, block
        end
        -- page.Resize(block, height) -> true when it changed (kit 15): the
        -- block's height and its frame's; call page.Layout() after.
        function page.Resize(block, height)
            if block.height == height then return false end
            block.height = height
            block.frame:SetHeight(height)
            return true
        end
        -- page.Offset(block) -> px (kit 15, Forever Cooldowns' page.Offset,
        -- Options.lua 905-913: opening an ability from a bar's icon scrolls
        -- to it, Studio.lua 1165): how far below the body's top the block
        -- starts, counting the blocks shown above it at the last layout;
        -- nil for a block not on the page.
        function page.Offset(block)
            local y = 6
            for _, other in ipairs(page.blocks) do
                if other == block then return y end
                if other.frame:IsShown() then y = y + other.height end
            end
            return nil
        end
        -- The first row, heading or preview ends the page's top. Kit 18:
        -- public as page.Start(), for a page whose top ends sooner (Forever
        -- Skin's New windows box is a setting, ForeverSkin/Settings.lua
        -- 2310, so it must not show on the How to use tab).
        local function Start()
            if started then return end
            started = true
            page.topCount = #page.blocks
            for index = 1, page.topCount do page.blocks[index].top = true end
        end
        page.Start = Start

        -- A row's value differs from its default: it never folds away.
        -- A default may be fn() (kit 18, Forever Skin's CVar defaults): read
        -- now; nil from it (no default known) never counts as changed.
        local function Changed(row)
            for _, setting in ipairs(row and row.settings or {}) do
                local default = setting.default
                if type(default) == "function" then default = default() end
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
        -- Kit 18 (the user, 25 October 2026, CONVERSIONS.md "Kit 18",
        -- answer 3; .claude/rules/ui-settings-pages.md: "a More line holds
        -- two or more rows"): a heading's More rows fold only while two or
        -- more of them are at their default, as Forever Skin's did
        -- (ForeverSkin/Settings.lua 534-548). One row behind the line saves
        -- no room, the line being as tall as the row, and costs a click; so
        -- a lone one shows as a plain row and the line goes. Until kit 17 a
        -- lone row folded behind "+ 1 more".
        -- The count is the heading's More line's own (more.Count) once it
        -- is made: an addon's line over fine rows of its own counts them its
        -- way (Forever Cooldowns' self-buff fold, Studio.lua 1238-1262).
        -- Kit 19: a row its When hides (row:When, block.when), or in an
        -- empty or filtered block, is not on the page, so its More line
        -- neither counts nor names it (Forever Combat Text's Colours, for
        -- Your hits only: the Lanes line read "4 more" and opened three).
        local function Shows(row)
            local block = row and row.block
            if not block then return true end
            if block.empty or block.filtered then return false end
            if block.when and not block.when() then return false end
            return true
        end
        local function Foldable(this)
            if not this then return 0 end
            local line = this.moreBlock and this.moreBlock.more
            if line and line.Count then return line.Count() end
            local count = 0
            for _, row in ipairs(this.fine or {}) do
                if Shows(row) and not Changed(row) then count = count + 1 end
            end
            return count
        end
        local function Folded(block)
            if not block.fine or block.group.moreOpen or Changed(block.row) then return false end
            return Foldable(block.group) >= 2
        end
        -- During a search a click on a heading folds its matches; what sits
        -- in a folded heading goes with it (kit 18, headings inside one).
        local function SearchFolded(this)
            while this do
                if this.folded then return true end
                this = this.parent
            end
            return false
        end
        local function Visible(block)
            -- block.empty (an unused slot of a list that grows) or
            -- block.filtered (a row the addon's own filter hides) never
            -- shows, a search neither (kit 15, Forever Cooldowns' Abilities
            -- page, Options.lua 917; Studio.lua 749, 1109).
            if block.empty or block.filtered then return false end
            -- Ticks that belong to a row show while it does (kit 14).
            if block.withRow then return Visible(block.withRow) end
            -- A block shown only while when() holds (a row some picked
            -- things lack).
            if block.when and not block.when() then return false end
            if found then
                -- The Move panel is how the boxes are moved: a search never
                -- hides it.
                if block.move then return true end
                if block.tabs or block.more then return false end
                return found[block] == true and not SearchFolded(block.group)
            end
            if page.tabs and not block.top and not block.tabs and not block.bothTabs then
                if (page.tab == "help") ~= (block.help == true) then return false end
            end
            -- Kit 18: the line shows while it holds two or more rows, open
            -- or not (Foldable).
            if block.more then
                return block.shown and block.more.Count() >= 2
            end
            if block.fine then return block.shown and not Folded(block) end
            return block.shown
        end
        function page.Layout()
            local y = -6
            local shows = {}
            for index, block in ipairs(page.blocks) do
                -- block.measure() (kit 7, Forever DR's spell list): its
                -- height, asked at each layout.
                if block.measure then
                    local height = block.measure()
                    if type(height) == "number" then block.height = height end
                end
                shows[index] = Visible(block)
            end
            -- Column titles show while a row under them in their heading
            -- does (kit 11, Forever Range: offsets folded behind More take
            -- their titles along).
            for index, block in ipairs(page.blocks) do
                if block.columns and shows[index] then
                    local any = false
                    for next = index + 1, #page.blocks do
                        local after = page.blocks[next]
                        if after.group ~= block.group or after.columns then break end
                        if (after.row or after.ticks) and shows[next] then any = true; break end
                    end
                    shows[index] = any
                end
            end
            for index, block in ipairs(page.blocks) do
                -- A block with nothing in it (page.Rows with no entries)
                -- takes no room.
                if shows[index] and block.height > 0 then
                    block.frame:ClearAllPoints()
                    block.frame:SetPoint("TOPLEFT", 0, y)
                    block.frame:SetPoint("TOPRIGHT", 0, y)
                    block.frame:SetHeight(block.height)
                    block.frame:Show()
                    block.y = y
                    y = y - block.height
                else
                    block.frame:Hide()
                end
            end
            -- host.pad (kit 7): the room under the last block in a host
            -- (default 12).
            local pad = host and host.pad or 12
            body:SetHeight(-y + pad)
            if host and host.fit then host.fit(-y + pad) end
            for _, fn in ipairs(page.laid) do fn() end
        end

        -- More: the rows after this in the heading being built are its
        -- fine-tuning, behind one grey line at the heading's foot ("+ 3
        -- more: opacity, base size, bold bases"); a click opens them in place
        -- and the line becomes "- Fewer rows". The state is saved like a
        -- heading's (its key .. " / more"). A row whose value differs from
        -- its default stays shown; a search shows every match.
        function page.More()
            assert(group and not group.always, "More belongs in a heading")
            group.fine = group.fine or {}
            fine = true
        end
        local function CloseMore()
            local this = group
            fine = false
            if not this or not this.fine or #this.fine == 0 or this.moreBlock then return end
            local frame, block = page.Block(24, "more")
            this.moreBlock = block
            local more = {}
            block.more = more
            local button = CreateFrame("Button", nil, frame, "BackdropTemplate")
            -- Under a heading inside another it sits in with the rows (kit 18).
            local indent = IndentOf(this)
            button:SetPoint("TOPLEFT", NAME_X + indent, -2)
            button:SetSize(FULL - indent, 20)
            Edge(button, true)
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
            more.button, more.text, more.plus = button, text, plus
            function more.Count()
                local count = 0
                for _, row in ipairs(this.fine) do
                    if Shows(row) and not Changed(row) then count = count + 1 end
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
                        if Shows(row) and not Changed(row) then names[#names + 1] = MoreName(row.label) end
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
                SetGroupOpen(this.key .. " / more", this.moreOpen)
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
            this.moreOpen = GroupOpen(this.key .. " / more") == true
        end
        page.CloseMore = CloseMore

        -- Previews (the preview kit, PreviewKit.lua; nil without it, and
        -- nothing else changes). page.Preview: the first block under the
        -- heading just made, which keeps it as its group's preview so its
        -- rows can point at their parts. plain (kit 5): a colour { r, g, b }
        -- for an opaque fill in place of the strip of world, for a sample
        -- of a window that is opaque in game (the preview kit's plain).
        function page.Preview(onScreen, screenTip, plain)
            if not ns.PreviewKit then return nil end
            Start()
            local frame, block = page.Block(60, "preview")
            block.preview = true
            local preview
            preview = ns.PreviewKit.New(frame, { x = NAME_X, width = FULL, onScreen = onScreen, screenTip = screenTip,
                plain = plain,
                resize = function(height)
                    if height == block.height then return end
                    block.height = height
                    frame:SetHeight(height)
                    page.Layout()
                end,
                find = function(parts) page.Find(parts, preview) end,
                names = function(parts) return page.PartNames(parts, preview) end })
            preview.block = block
            if block.group then block.group.preview = preview end
            return preview
        end
        -- page.Share(preview) (kit 11, Forever Range): the heading just made
        -- points its rows into another heading's preview; a click on a part
        -- finds them, and a search shows that preview with them.
        -- Kit 19 (Forever Combat Text): owner, a heading made before the
        -- preview (Presets, over the Combat Feed's), else the heading just
        -- made; how.search false (owner.pointOnly): pointing and finding
        -- only, a search showing the rows under their own heading without
        -- the preview and its heading, as Combat Text's own toolkit did.
        function page.Share(preview, owner, how)
            owner = owner or group
            assert(owner and not owner.always, "a shared preview belongs to a heading")
            owner.preview = preview
            owner.pointOnly = (type(how) == "table" and how.search == false) or nil
            return preview
        end
        -- The strip pinned above the scrolling rows (page.Pin, page.PinTop):
        -- made once, the scroll frame hung under it. Kit 18 (gap 5 of
        -- CONVERSIONS.md's Forever Skin): the reload bar moves onto it. The
        -- bar was made on the scroll frame at NewPage and puts back the
        -- points it read there (ReloadKit.lua 168-171 and 231-238), so on a
        -- pinned page it lay over the strip; it hangs over the strip now, as
        -- Forever Skin's did (ReloadKit.Bar(page.header or scroll),
        -- ForeverSkin/Settings.lua 435), the strip and the rows moving down
        -- under it. The old bar is hidden and its refresh swapped for the
        -- new one's.
        local function PinStrip()
            if page.header then return page.header end
            local header = CreateFrame("Frame", nil, panel, "BackdropTemplate")
            header:SetPoint("TOPLEFT", 16, -16)
            header:SetPoint("TOPRIGHT", -34, -16)
            header:SetHeight(60)
            Edge(header)
            header:SetBackdropColor(0.075, 0.08, 0.09, 0.98)
            header:SetBackdropBorderColor(0, 0, 0, 1)
            page.header = header
            scroll:ClearAllPoints()
            scroll:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -6)
            scroll:SetPoint("BOTTOMRIGHT", -34, 16)
            local old = page.reloadBar
            if old and ns.ReloadKit then
                old.frame:Hide()
                old.frame:SetScript("OnSizeChanged", nil)
                old.frame:ClearAllPoints()
                local bar = ns.ReloadKit.Bar(header, options.reload)
                for index, fn in ipairs(page.refreshers) do
                    if fn == old.Refresh then page.refreshers[index] = bar.Refresh end
                end
                page.reloadBar = bar
            end
            return header
        end
        -- page.PinTop(height) -> strip (kit 18, Forever Skin's pinned pages,
        -- NewPage(name, true), ForeverSkin/Settings.lua 409-425; the user,
        -- CONVERSIONS.md "Kit 18", answer 2: "the title stays fixed above the
        -- preview"): the pinned strip with height px (default 26) at its top
        -- for the page's title lines, which the addon draws on it
        -- (page.header). It is made at once, with or without PreviewKit.lua,
        -- so the title never scrolls away; a page.Pin after it puts the
        -- preview under that room. nil in a host.
        function page.PinTop(height)
            if host then return nil end
            local header = PinStrip()
            page.pinTop = height or 26
            if not page.pinned then header:SetHeight(page.pinTop + 4) end
            return header
        end
        -- page.Pin: a preview pinned above the scrolling rows, for a page
        -- about one thing, so it stays in view while the rows scroll; every
        -- row without a preview under its own heading points into it. Not in
        -- a host. plain as page.Preview's.
        -- top (kit 18; Skin's page.Pin(nil, nil, nil, 54), Settings.lua
        -- 3375): the preview starts top px below the strip's top, under the
        -- title lines (default page.PinTop's height; without either the
        -- strip is the preview's alone, as before). With a top the strip is
        -- made without PreviewKit.lua too (page.PinTop), and Pin returns nil.
        function page.Pin(onScreen, screenTip, plain, top)
            if host then return nil end
            top = top or page.pinTop
            if not ns.PreviewKit then
                if top then page.PinTop(top) end
                return nil
            end
            local header = PinStrip()
            local holder, box = header, nil
            if top then
                page.pinTop = top
                box = CreateFrame("Frame", nil, header)
                box:SetPoint("TOPLEFT", 0, -top)
                box:SetPoint("TOPRIGHT", 0, -top)
                box:SetHeight(60)
                header:SetHeight(top + 60)
                holder = box
            end
            local pinned
            pinned = ns.PreviewKit.New(holder, { x = NAME_X, width = FULL, onScreen = onScreen,
                screenTip = screenTip, plain = plain,
                resize = function(height)
                    if box then
                        box:SetHeight(height)
                        header:SetHeight(top + height)
                    else
                        header:SetHeight(height)
                    end
                end,
                find = function(parts) page.Find(parts, pinned) end,
                names = function(parts) return page.PartNames(parts, pinned) end })
            pinned.box = box
            page.pinned = pinned
            return pinned
        end
        -- The preview a row points into: its heading's, else the pinned one.
        local function PreviewOf(row)
            -- A row on the addon's own frame (page.Controls) may have no
            -- block: its group then (kit 15).
            local owner = (row.block and row.block.group) or row.group
            -- Kit 18: else the preview of a heading it sits in.
            while owner and not owner.preview do owner = owner.parent end
            return (owner and owner.preview) or page.pinned
        end
        -- What changes any of parts, in page order: each find is a row or a
        -- tick box (page.Ticks), its block, what lights up (a row's name
        -- strip, the box itself) and its name. within: only a heading's
        -- (a group), or only what points into a preview.
        local function PartRows(parts, within)
            local wanted = {}
            for _, part in ipairs(parts or {}) do wanted[part] = true end
            local finds = {}
            local function Inside(block)
                if not within or block.group == within then return true end
                return ((block.group and block.group.preview) or page.pinned) == within
            end
            for _, block in ipairs(page.blocks) do
                local row = block.row
                -- An empty or filtered block is not on the page (kit 15).
                if block.empty or block.filtered then
                    row = nil
                elseif row and row.controls and Inside(block) then
                    -- A row of two may change a second part (row:Tip).
                    local match = row.part and wanted[row.part]
                    for _, part in ipairs(row.parts or {}) do match = match or wanted[part] end
                    if match then finds[#finds + 1] = { row = row, block = block, flash = row.name, label = row.label } end
                elseif block.ticks and Inside(block) then
                    for _, entry in ipairs(block.ticks) do
                        if entry.part and wanted[entry.part] and entry.control then
                            finds[#finds + 1] = { entry = entry, block = block, flash = entry.control,
                                label = entry.title or entry.label }
                        end
                    end
                end
            end
            return finds
        end
        function page.PartNames(parts, within)
            local names = {}
            for _, hit in ipairs(PartRows(parts, within)) do names[#names + 1] = hit.label end
            return table.concat(names, ", ")
        end
        -- Click a part to find its setting: every heading that holds one of
        -- the rows opens (and its More line when they are folded), and they
        -- light up gold where they are; the page does not move (preview kit
        -- 4; the user, 14 October 2026), and a gold bar at its edge points at
        -- rows out of sight.
        -- page.onFind(parts) (kit 18, Forever Skin's Nameplates page, where a
        -- click on a sample's aura or bar picks its kind or look first,
        -- ForeverSkin/Settings.lua 3495-3511): when the page sets it, it
        -- hears every click on a part before the rows are found.
        function page.Find(parts, within)
            if page.onFind then page.onFind(parts) end
            local finds = PartRows(parts, within)
            if #finds == 0 then return end
            if not found then
                page.tab = "settings"
                -- Kit 18: the headings a heading sits in open too.
                for _, hit in ipairs(finds) do
                    local owner = hit.block.group
                    while owner do
                        if not owner.open and not owner.always then
                            owner.open = true
                            SetGroupOpen(owner.key, true)
                        end
                        owner = owner.parent
                    end
                end
                Reshow()
                for _, hit in ipairs(finds) do
                    local owner = hit.block.group
                    -- Ticks that belong to a row behind More open it too
                    -- (kit 14). Kit 18: only rows that fold (Folded).
                    local holder = hit.block.withRow or hit.block
                    if owner and Folded(holder) then
                        owner.moreOpen = true
                        SetGroupOpen(owner.key .. " / more", true)
                    end
                end
                page.Layout()
                page.Refresh()
            end
            if not (ns.PreviewKit and ns.PreviewKit.Found and scroll) then return end
            local strips, names = {}, {}
            for _, hit in ipairs(finds) do
                strips[#strips + 1] = hit.flash
                names[#names + 1] = hit.label
            end
            ns.PreviewKit.Found(scroll, strips, names)
        end

        -- Hover a row, see its part: the preview the row points into holds
        -- still and outlines what the row changes; nil clears it. part, name:
        -- a control's own part on a row of two (row:Tip), tagged with its own
        -- name. page.pointedRow is the row while one points (a click spot on
        -- the preview leaves it nil). options.point (kit 5), when given,
        -- takes the place of the preview: point(page, row, part, name), row
        -- nil when the mouse leaves (Square Forever Minimap outlines the
        -- real minimap).
        local pointed
        function page.Point(row, part, label)
            page.pointedRow = row
            if options.point then
                if row then options.point(page, row, part or row.part, label or row.label)
                else options.point(page, nil) end
                return
            end
            local preview = row and PreviewOf(row)
            if pointed and pointed ~= preview then pointed.Point(nil) end
            pointed = preview
            if preview then preview.Point(part or row.part, label or row.label) end
        end

        -- The picker (preview kit 4): a gold panel of chips choosing what the
        -- rows after it in this heading change, its gold bar running down
        -- them to the last one shown. options are the preview kit's (title,
        -- hint, noun, choices, get, set, tip). nil without the kit.
        -- options.blocks (kit 15, Forever Cooldowns' bar picker, Studio.lua
        -- 556-583, Options.lua 1101-1113 and 1426-1436): fn() -> the blocks
        -- it steers, in page order (rows under the headings after it: Add
        -- or remove, Bar, Size, Where it shows), read at each layout and
        -- search: the gold bar runs down those, and a search shows the
        -- picker with any of them, a picker under no heading too.
        -- block.railed() is the list.
        function page.Picker(pickerOptions)
            if not (ns.PreviewKit and ns.PreviewKit.Picker) then return nil end
            Start()
            local frame, block = page.Block(80, "picker")
            block.picker = true
            local owner = group
            local picker
            local settings = {}
            for key, value in pairs(pickerOptions) do settings[key] = value end
            settings.blocks = nil
            -- Under a heading inside another the panel sits in with the
            -- rows (kit 18).
            settings.x, settings.width = NAME_X + IndentOf(owner), FULL - IndentOf(owner)
            settings.resize = function(height)
                if height == block.height then return end
                block.height = height
                frame:SetHeight(height)
                if picker then page.Layout() end
            end
            picker = ns.PreviewKit.Picker(frame, settings)
            block.kit = picker
            if pickerOptions.blocks then block.railed = pickerOptions.blocks end
            page.AfterLayout(function()
                local frames, after = {}, false
                if block.railed then
                    for _, member in ipairs(block.railed() or {}) do frames[#frames + 1] = member.frame end
                else
                    for _, member in ipairs(owner and owner.members or {}) do
                        if member == block then after = true elseif after then frames[#frames + 1] = member.frame end
                    end
                end
                picker.Rail(frames)
            end)
            page.OnRefresh(function() picker.Refresh() end)
            return picker
        end

        -- The Move panel (preview kit 5; the user, 15 October 2026): first on
        -- the page, Unlock to move (Lock in place while unlocked) and Show on
        -- screen, kept through a search. options: title, hint, locked(),
        -- setLocked(on), onScreen, screenTip, unlockTip, lockTip, how, parts
        -- (the preview kit's Move). Returns the kit's move; without
        -- PreviewKit.lua a plain row in the same place with the same two
        -- buttons, and nil; nil in a host.
        function page.Move(moveOptions)
            if host then return nil end
            -- fallback false: no plain row without the preview kit (the page
            -- draws its own).
            local function SetLocked(on)
                moveOptions.setLocked(on)
                page.Refresh()
            end
            if ns.PreviewKit and ns.PreviewKit.Move then
                -- First on the page it shares the page's top with the header
                -- after it (both tabs show it, Forever Threat); after the
                -- header it is the first of the Settings tab (Forever Cast).
                -- inTop (kit 11, Forever Range): after the header and still
                -- in the page's top, before the tabs.
                if #page.blocks > 0 and not moveOptions.inTop then Start() end
                local frame, block = page.Block(120, "move")
                block.move = true
                -- bothTabs (kit 7, Forever DR's family): after the header
                -- and still on the How to use tab too.
                block.bothTabs = moveOptions.bothTabs == true
                local settings = {}
                for key, value in pairs(moveOptions) do settings[key] = value end
                settings.x, settings.width, settings.setLocked = NAME_X, FULL, SetLocked
                settings.resize = function(height)
                    if height == block.height then return end
                    block.height = height
                    frame:SetHeight(height)
                    page.Layout()
                end
                local move = ns.PreviewKit.Move(frame, settings)
                block.kit, block.moveKit = move, move
                move.block = block
                page.move = move
                page.OnRefresh(function() move.Refresh() end)
                return move
            end
            if moveOptions.fallback == false then return nil end
            -- Without the kit: a row in the same place, which leaves the
            -- page's top (the blocks shown on both tabs) as the panel would:
            -- first on the page it shares the top with the header after it;
            -- after the header it is the Settings tab's first block (kit 7:
            -- it went into the top).
            local first = #page.blocks == 0 or moveOptions.inTop == true
            if not first then Start() end
            local before = started
            -- rowDetail (kit 11): the row's tooltip, default the hint.
            local row = page.Row(moveOptions.title, moveOptions.rowDetail or moveOptions.hint)
            if first and not before then started, page.topCount = false, nil end
            row.block.move = true
            row.block.bothTabs = moveOptions.bothTabs == true
            page.moveRow = row
            local unlock = row:Button(C1, "", function()
                SetLocked(not (moveOptions.locked() == true))
            end)
            unlock.label:SetJustifyH("CENTER")
            local screen = row:Button(C2, "Show on screen", function()
                if moveOptions.onScreen then moveOptions.onScreen() end
            end)
            screen.label:SetJustifyH("CENTER")
            page.OnRefresh(function()
                unlock.label:SetText(moveOptions.locked() == true and "Unlock to move" or "Lock in place")
            end)
            return nil
        end

        -- A group that opens and closes, drawn like the quest log's zone
        -- headers: its title and a grey summary over a thin line across the
        -- rows, with a [-] or [+] box at the line's right end. A click
        -- anywhere on the header opens or closes it; the blocks after it, up
        -- to the next group, are its rows. summary returns its state in a few
        -- words; detail, when given, is the heading's tooltip. A click's open
        -- or closed state is saved (options.setGroupOpen, under groupKey), so
        -- the heading reopens as the player left it; never clicked, it opens
        -- as coded.
        -- parent (kit 18, Forever Skin's Blizzard's nameplate options, seven
        -- headings in one, ForeverSkin/Settings.lua 3827-3829; the rule
        -- "under one closed heading", ui-settings-pages.md): the heading this
        -- one sits in. It is indented 14 px with a fainter line (0.3), shows
        -- only while parent (and every heading parent sits in) is open, and
        -- is opened along with them by Find. A search whose words are in
        -- parent's title shows all its rows, a click folding parent's
        -- matches folds its too, and under a Blizzard-tagged parent its rows
        -- carry no tag of their own. Its rows, More line and picker sit in
        -- with it. Its open state is saved under its own key: groupKey(title,
        -- page, parent), which may leave parent out (Skin's does). Built
        -- after parent's own rows; this.parent, parent.subs.
        function page.Group(title, open, summary, detail, parent)
            CloseMore()
            Start()
            group = parent
            local frame, block = page.Block(ROW + 4, "group")
            local members = {}
            local key = options.groupKey and options.groupKey(title, page, parent) or title
            local saved = GroupOpen(key)
            if saved ~= nil then open = saved end
            local this = { title = title, key = key, open = open == true, members = members, detail = detail, block = block,
                parent = parent }
            block.heading = this
            if parent then
                parent.subs = parent.subs or {}
                parent.subs[#parent.subs + 1] = this
            end
            local indent = IndentOf(this)
            local toggle = CreateFrame("Button", nil, frame)
            toggle:SetPoint("TOPLEFT", NAME_X + indent, -4)
            toggle:SetSize(FULL - indent, 22)
            toggle:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            local heading = toggle:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            heading:SetPoint("BOTTOMLEFT", 2, 5)
            heading:SetText(title)
            local count = toggle:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            count:SetPoint("BOTTOMLEFT", heading, "BOTTOMRIGHT", 10, 0)
            count:SetPoint("RIGHT", -24, 0)
            count:SetJustifyH("LEFT")
            count:SetTextColor(GREY[1], GREY[2], GREY[3])
            NoWrap(count)
            local line = toggle:CreateTexture(nil, "ARTWORK")
            line:SetPoint("BOTTOMLEFT", 0, 0)
            line:SetPoint("BOTTOMRIGHT", 0, 0)
            line:SetHeight(1)
            -- The box: dark inside a black edge; a gold minus, and a bar
            -- across it for plus.
            local box = CreateFrame("Frame", nil, toggle, "BackdropTemplate")
            box:SetPoint("BOTTOMRIGHT", 0, 3)
            box:SetSize(15, 15)
            Edge(box)
            box:SetBackdropColor(0.14, 0.145, 0.16, 1)
            box:SetBackdropBorderColor(0, 0, 0, 1)
            local across = box:CreateTexture(nil, "OVERLAY")
            across:SetPoint("CENTER", 0, 0)
            across:SetSize(7, 1)
            local down = box:CreateTexture(nil, "OVERLAY")
            down:SetPoint("CENTER", 0, 0)
            down:SetSize(1, 7)
            local hovered = false
            -- A heading inside another is a little quieter: its line fainter
            -- (kit 18, Forever Skin's 0.3).
            local lineAlpha = parent and 0.3 or 0.45
            local function Paint()
                local lit = hovered and GOLD or { 0.92, 0.92, 0.92 }
                heading:SetTextColor(lit[1], lit[2], lit[3])
                local mark = hovered and { 1, 0.9, 0.55 } or GOLD
                across:SetColorTexture(mark[1], mark[2], mark[3], 1)
                down:SetColorTexture(mark[1], mark[2], mark[3], 1)
                if found then down:SetShown(this.folded == true) else down:SetShown(not this.open) end
                line:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], hovered and 0.9 or lineAlpha)
            end
            toggle:SetScript("OnEnter", function() hovered = true; Paint() end)
            toggle:SetScript("OnLeave", function() hovered = false; Paint() end)
            -- group.SetOpen(open) (kit 15, Forever Cooldowns' heading.SetOpen,
            -- Options.lua 1219-1223, Studio.lua 1157, 1322, 1326): opens or
            -- closes the heading as a click does, saving it; call
            -- page.Layout() and page.Refresh() after.
            function this.SetOpen(value)
                this.open = value == true
                SetGroupOpen(key, this.open)
                -- Kit 18: the headings inside it and their rows too.
                Reshow()
            end
            toggle:SetScript("OnClick", function()
                if found then
                    -- During a search a click folds the heading's matches for
                    -- this search only; the saved open state stays as it was.
                    this.folded = not this.folded
                else
                    this.SetOpen(not this.open)
                end
                page.Layout()
                page.Refresh()
            end)
            Tooltip(toggle, title, detail)
            page.OnRefresh(function()
                count:SetText(summary and summary() or "")
                Paint()
            end)
            -- count (summary): its grey state; plus: the upright bar shown
            -- while closed (both read by the addons' tests).
            this.toggle = toggle
            this.count, this.summary, this.plus, this.down = count, count, down, down
            -- header: the heading's block frame (kit 5, as Square Forever
            -- Minimap's tests read it); page.order: every heading in order.
            this.titleText, this.header = heading, frame
            -- Kit 18: its line and box (a heading inside another is fainter).
            this.line, this.box = line, box
            group = this
            page.groups[NameKey(title, "group")] = this
            page.order[#page.order + 1] = this
            return this
        end

        -- A heading whose every row is one of Blizzard's own settings (or,
        -- hidden, every row a game setting no menu shows): the word right
        -- after its title, its rows without one of their own so their names
        -- keep their width; each row keeps its tooltip's lines. The summary
        -- moves along after the word. The title is unchanged: it keys the
        -- saved open state. this: the heading (default the one just made).
        function page.BlizzardHeading(this, hidden)
            this = this or group
            assert(this and not this.always and this.toggle, "a Blizzard tag belongs on a heading")
            this.blizzard = hidden and "Hidden" or "Blizzard"
            local color = hidden and HIDDEN or BLIZZARD
            local tag = this.toggle:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            tag:SetPoint("BOTTOMLEFT", this.titleText, "BOTTOMRIGHT", 6, 0)
            tag:SetText(this.blizzard)
            tag:SetTextColor(color[1], color[2], color[3])
            this.count:SetPoint("BOTTOMLEFT", tag, "BOTTOMRIGHT", 10, 0)
            this.tag = tag
            return this
        end

        -- A pinned heading (kit 17, Forever Diagnostics' Used most, its
        -- page.Pinned since 0.45.0; the user, 18 October 2026: "put the
        -- things i use the most at the top and highlight them"): always open,
        -- no box, its title and line in gold, and each of its rows on a
        -- faint gold wash with a gold bar down the left (Wash, in page.Row),
        -- so the eye lands there first. It takes no click and saves nothing.
        function page.Pinned(title, summary, detail)
            CloseMore()
            Start()
            group = nil
            local frame, block = page.Block(ROW + 4, "group")
            local this = { title = title, key = title, open = true, pinned = true, members = {}, detail = detail, block = block }
            block.heading = this
            local head = CreateFrame("Frame", nil, frame)
            head:SetPoint("TOPLEFT", NAME_X, -4)
            head:SetSize(FULL, 22)
            head:EnableMouse(true)
            local heading = head:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            heading:SetPoint("BOTTOMLEFT", 2, 5)
            heading:SetText(title)
            heading:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
            local count = head:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            count:SetPoint("BOTTOMLEFT", heading, "BOTTOMRIGHT", 10, 0)
            count:SetPoint("RIGHT", -4, 0)
            count:SetJustifyH("LEFT")
            count:SetTextColor(GREY[1], GREY[2], GREY[3])
            NoWrap(count)
            local line = head:CreateTexture(nil, "ARTWORK")
            line:SetPoint("BOTTOMLEFT", 0, 0)
            line:SetPoint("BOTTOMRIGHT", 0, 0)
            line:SetHeight(1)
            line:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.9)
            Tooltip(head, title, detail)
            page.OnRefresh(function() count:SetText(summary and summary() or "") end)
            this.head, this.header, this.titleText = head, frame, heading
            this.count, this.summary = count, count
            group = this
            page.groups[NameKey(title, "group")] = this
            page.order[#page.order + 1] = this
            return this
        end
        -- The wash and bar behind one of a pinned heading's rows.
        local function Wash(frame)
            local wash = frame:CreateTexture(nil, "BACKGROUND")
            wash:SetPoint("TOPLEFT", NAME_X - 6, 0)
            wash:SetPoint("BOTTOMLEFT", NAME_X - 6, 0)
            wash:SetWidth(FULL + 12)
            wash:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.07)
            local bar = frame:CreateTexture(nil, "ARTWORK")
            bar:SetPoint("TOPLEFT", NAME_X - 6, 0)
            bar:SetPoint("BOTTOMLEFT", NAME_X - 6, 0)
            bar:SetWidth(2)
            bar:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.9)
            return wash, bar
        end

        -- How to use: the page's last heading, always open, gathering what
        -- is text and not a setting (the mouse, the commands, how to read the
        -- display) in one place. Drawn like a group's heading without the
        -- box, it takes no click and saves nothing; its blocks are page.Topic
        -- labels and page.Note lines. With helpTabs (the default) it is on a
        -- tab of its own: two flat tabs after the page's top, Settings and
        -- How to use, the chosen one underlined in gold; not saved, so the
        -- page opens on Settings.
        function page.Help(summary, detail)
            assert(not page.groups[HELP], "two How to use sections")
            CloseMore()
            Start()
            group = nil
            if helpTabs then
                local tabFrame, tabBlock = page.Block(28, "tabs")
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
            end
            inHelp = true
            local frame, block = page.Block(ROW + 4, "group")
            local this = { title = HELP, open = true, always = true, members = {}, detail = detail, block = block }
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
            NoWrap(count)
            local line = head:CreateTexture(nil, "ARTWORK")
            line:SetPoint("BOTTOMLEFT", 0, 0)
            line:SetPoint("BOTTOMRIGHT", 0, 0)
            line:SetHeight(1)
            line:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.45)
            Tooltip(head, HELP, detail)
            page.OnRefresh(function() count:SetText(summary and summary() or "") end)
            this.head, this.header = head, frame
            this.count, this.summary = count, count
            group = this
            page.groups[HELP] = this
            page.order[#page.order + 1] = this
            return this
        end
        -- A small gold label inside How to use: what the notes after it are about.
        -- detail (kit 14, Forever Junk's 8 topics, ForeverJunk/Settings.lua
        -- 641-652): its tooltip, when given; block.detail. A topic without
        -- one takes no mouse, as before. Its detail is not searched (a
        -- topic shows with its notes, as Junk's).
        function page.Topic(title, detail)
            assert(group and group.always, "a topic belongs under How to use")
            local frame, block = page.Block(22, "topic")
            block.topic = title
            block.detail = detail
            Text(frame, title, NAME_X + 2, -8, GOLD, FULL - 4)
            if detail then
                frame:EnableMouse(true)
                Tooltip(frame, title, detail)
            end
            return block
        end
        -- One line of How to use: what, then how in grey; plain text, no
        -- strip, so it reads as a note and not a setting. detail is its
        -- tooltip; a line too long for its column wraps and the note grows.
        -- how may be fn() (kit 5), drawn again on every refresh (a click that
        -- follows a setting); id tells two notes of one name apart (default
        -- the label; note.id).
        -- part (kit 11, Forever Battleground Timers): what the line shows in
        -- the pinned preview; hovering it outlines that part. Notes are
        -- never found by a click on a part.
        function page.Note(label, how, detail, id, part)
            assert(group and group.always, "a note belongs under How to use")
            local frame, block = page.Block(20, "note")
            local note = { frame = frame, label = label, detail = detail, block = block, id = id or label }
            page.notes[#page.notes + 1] = note
            block.row = note
            frame:EnableMouse(true)
            note.name = Text(frame, label, NAME_X + 2, -4, nil, NAME_W - 4)
            local function How() return (type(how) == "function" and how() or how) or "" end
            note.how = Text(frame, How(), C1 + 4, -4, GREY, FULL - (C1 - NAME_X) - 4)
            if type(how) == "function" then page.OnRefresh(function() note.how:SetText(How()) end) end
            local tall = math.max(note.name:GetStringHeight() or 0, note.how:GetStringHeight() or 0)
            if tall > 14 then
                block.height = math.ceil(tall) + 8
                frame:SetHeight(block.height)
            end
            note.part = part
            Tooltip(frame, label, detail, part and function(over) page.Point(over and note or nil) end or nil)
            return note
        end

        -- A gold title and an optional grey line under it, ending any
        -- heading (kit 5, Forever Quests' paused page). It is not a heading:
        -- it does not open or close and saves nothing.
        function page.Section(title, note)
            CloseMore()
            group = nil
            local frame = page.Block(note and 46 or 30, "section")
            Text(frame, title, NAME_X, -12, GOLD, FULL)
            if note then Text(frame, note, NAME_X, -28, GREY, FULL) end
            return frame
        end
        -- Grey text across the rows, lines lines tall (default 1); text may
        -- be fn(), read again at every refresh. Returns its frame and label.
        function page.Paragraph(text, lines)
            local frame = page.Block(6 + 13 * (lines or 1), "paragraph")
            local label = Text(frame, type(text) == "function" and text() or text, NAME_X, -3, GREY, FULL)
            if type(text) == "function" then page.OnRefresh(function() label:SetText(text()) end) end
            return frame, label
        end

        -- Tick boxes in columns (kit 5, Forever World Map's list of what the
        -- map draws), one block: entries are { key, label, title, detail,
        -- part }; label may carry an icon (title is then the plain name, for
        -- tooltips, tags and search); part is what the box changes in its
        -- heading's preview. Each box is On or Off through the setting key.
        -- They are not rows (no reset, never folded behind More), but each
        -- one counts in a search and a click on its part finds it. Every box
        -- is in page.ticks, in order; entry.control is its box.
        -- layout (kit 13, GANG secret's crowd control kinds): { x, width,
        -- gap, height, chip }: where the boxes start (default the name
        -- strip's x), each one's width (default the columns sharing the
        -- room to the last column's edge), the gap between them (6) and
        -- their height (22). chip: small boxes whose tick fills gold, the
        -- name gold too, when on.
        -- layout.withRow (kit 14, Forever Junk's quality ticks under each
        -- rule, ForeverJunk/Settings.lua 814-830 and 864-883): the boxes
        -- belong to the row just made. They show while that row does (its
        -- heading, its More line, row:When, the tab), and in a search they
        -- show when it is found and never alone: they are not searched or
        -- counted one by one (Forever Settings' count stays the rows').
        -- A click on an entry's part still finds the box. block.withRow is
        -- the row's block, row.ticks the entries.
        function page.Ticks(entries, columns, layout)
            layout = layout or {}
            local owner
            if layout.withRow then
                owner = page.blocks[#page.blocks]
                assert(owner and owner.row and owner.row.controls, "ticks withRow follow a row")
            end
            page.ticks = page.ticks or {}
            for _, entry in ipairs(entries) do page.ticks[#page.ticks + 1] = entry end
            Start()
            local left = layout.x or NAME_X
            local gap = layout.gap or 6
            local height = layout.height or 22
            local width = layout.width or math.floor(((C3 or C2) + CW - left - (columns - 1) * gap) / columns)
            local step = layout.height and (height + gap) or ROW
            local lines = math.ceil(#entries / columns)
            local frame, block = page.Block(lines * step + 4, "ticks")
            block.ticks = entries
            if owner then
                block.withRow = owner
                owner.row.ticks = entries
            end
            for index, entry in ipairs(entries) do
                local column = (index - 1) % columns
                local line = math.floor((index - 1) / columns)
                local control = Tick(frame, left + column * (width + gap), -2 - line * step, width, entry.label)
                if layout.height then control:SetSize(width, height) end
                if layout.chip then
                    -- The tick fills its 10 px box; the name sits 4 px after
                    -- it and keeps 3 px from the box's edge, room for
                    -- "Incapacitated" (72 px) in GANG secret's 99 px boxes,
                    -- which 24/-4 cut to "Incapacitat..." (1.60.1.70532).
                    if control.mark then control.mark:SetSize(10, 10) end
                    control.label:ClearAllPoints()
                    control.label:SetPoint("LEFT", 22, 0)
                    control.label:SetPoint("RIGHT", -3, 0)
                    control.chip = true
                end
                entry.control = control
                local name = entry.title or entry.label
                local point = entry.part and function(over)
                    page.Point(over and { block = block, part = entry.part, label = name } or nil)
                end or nil
                Tooltip(control, name, entry.detail, point)
                local setting = Adapter(entry.key)
                control:SetScript("OnClick", function(self)
                    setting.set(self:GetChecked() == true)
                    page.Refresh()
                end)
                page.OnRefresh(function()
                    local on = setting.get() == true
                    control:SetChecked(on)
                    if control.chip then
                        local color = on and GOLD or { 0.92, 0.92, 0.92 }
                        control.label:SetTextColor(color[1], color[2], color[3])
                    end
                end)
            end
            return frame
        end

        -- Tick boxes in titled sets (kit 18, Forever Skin's Use Forever Skin
        -- for and New windows' Pick..., ForeverSkin/Settings.lua 1466-1521,
        -- 2483): columns side by side, each a stack of sets, a set a grey
        -- title over its boxes. columns = { { { title, entries }, ... }, ...
        -- }; an entry is { key, label, title, detail, part } as page.Ticks'
        -- (key a setting key or table; a table with enabled greys the box as
        -- row controls are), plus waiting() (true while turning it waits
        -- for a reload: the reload kit's glow and Reload tag on the box) and
        -- reloadTip (text or fn(): the amber line in its tooltip).
        -- page.TicksHeight(columns) -> px  the height the sets take
        -- page.TicksIn(frame, columns, left, full, top) -> height, details
        --   the sets drawn on any frame (an addon's own block, as Skin's New
        --   windows box), from x left across full px, top px down (default
        --   -2); details is every title and detail, for the addon's search.
        --   The boxes go in page.ticks; a click writes and refreshes.
        -- page.TickSets(columns) -> frame, block  the sets as a block of the
        --   page, under the heading being built: each box counts on its own
        --   in a search and a click on its part finds it (the user,
        --   CONVERSIONS.md "Kit 18": each box is a setting).
        local SET_TITLE = 18
        function page.TicksHeight(columns)
            local tallest = 0
            for _, column in ipairs(columns) do
                local height = 0
                for _, set in ipairs(column) do height = height + SET_TITLE + #set.entries * ROW end
                tallest = math.max(tallest, height)
            end
            return tallest
        end
        local function MarkTick(control, waiting)
            local reload = ns.ReloadKit
            if not reload or not waiting then return end
            local state = waiting()
            local kind = state == "restart" and "restart" or (state and "reload" or nil)
            if not kind and not control.reloadKitMark then return end
            local tag = reload.Mark(control, kind, control.tag)
            local label = control.label
            label:ClearAllPoints()
            label:SetPoint("LEFT", control.chip and 22 or 24, 0)
            if tag then label:SetPoint("RIGHT", tag, "LEFT", -4, 0) else label:SetPoint("RIGHT", -6, 0) end
            control.reloadTag = tag
        end
        local function SetTicks(frame, columns, left, full, top, block)
            page.ticks = page.ticks or {}
            local count = math.max(#columns, 1)
            local width = math.floor((full - (count - 1) * 6) / count)
            local details, all = {}, {}
            for c, column in ipairs(columns) do
                local x, y = left + (c - 1) * (width + 6), top or -2
                for _, set in ipairs(column) do
                    Text(frame, set.title, x + 6, y - 3, GREY, width - 6)
                    details[#details + 1] = set.title
                    y = y - SET_TITLE
                    for _, entry in ipairs(set.entries) do
                        page.ticks[#page.ticks + 1] = entry
                        all[#all + 1] = entry
                        details[#details + 1] = type(entry.detail) == "string" and entry.detail or ""
                        local control = Tick(frame, x, y, width, entry.label)
                        entry.control = control
                        local name = entry.title or entry.label
                        local point = (block and entry.part) and function(over)
                            page.Point(over and { block = block, part = entry.part, label = name } or nil)
                        end or nil
                        Tooltip(control, name, entry.detail, point, { amberTip = entry.reloadTip })
                        local setting = Adapter(entry.key)
                        control:SetScript("OnClick", function(self)
                            if not Usable(setting) then self:SetChecked(setting.get() == true); return end
                            setting.set(self:GetChecked() == true)
                            page.Refresh()
                        end)
                        page.OnRefresh(function()
                            control:SetChecked(setting.get() == true)
                            if setting.enabled then
                                local usable = Usable(setting)
                                control:SetEnabled(usable)
                                control:SetAlpha(usable and 1 or 0.4)
                            end
                            MarkTick(control, entry.waiting)
                        end)
                        y = y - ROW
                    end
                end
            end
            return page.TicksHeight(columns), table.concat(details, "\n"), all
        end
        function page.TicksIn(frame, columns, left, full, top)
            local height, details = SetTicks(frame, columns, left or NAME_X, full or FULL, top)
            return height, details
        end
        function page.TickSets(columns)
            Start()
            local frame, block = page.Block(page.TicksHeight(columns) + 4, "ticks")
            local left = NAME_X + IndentOf(group)
            local _, details, entries = SetTicks(frame, columns, left, FULL - IndentOf(group), nil, block)
            block.ticks, block.detail, block.sets = entries, details, columns
            return frame, block
        end

        -- Rows that follow the data (kit 5, Forever Bank's sections and
        -- banks): one block holding a row per entry of entries(), each made
        -- when first needed with a name strip (row.name) in a holder frame
        -- (row.frame), make(row, holder) adding its controls once, and drawn
        -- by draw(row, entry) on every refresh (row.entry is its entry).
        -- They are the data, not settings: not in page.rows, never folded,
        -- never counted in a search (they show with the row before them).
        -- page.lists[id] is the list of rows; the block takes no room while
        -- empty.
        function page.Rows(id, entries, make, draw)
            Start()
            local frame, block = page.Block(0, "list")
            block.list = id
            local rows = {}
            page.lists[id] = rows
            page.OnRefresh(function()
                local list = entries()
                for index, entry in ipairs(list) do
                    local row = rows[index]
                    if not row then
                        local holder = CreateFrame("Frame", nil, frame)
                        holder:SetHeight(ROW)
                        holder:SetPoint("TOPLEFT", 0, -(index - 1) * ROW)
                        holder:SetPoint("TOPRIGHT", 0, -(index - 1) * ROW)
                        row = { frame = holder }
                        row.name = Strip(holder, NAME_X, -2, NAME_W, "")
                        NoWrap(row.name.label)
                        make(row, holder)
                        rows[index] = row
                    end
                    row.entry = entry
                    draw(row, entry)
                    row.frame:Show()
                end
                for index = #list + 1, #rows do
                    rows[index].entry = nil
                    rows[index].frame:Hide()
                end
                local height = #list * ROW
                if height ~= block.height then
                    block.height = height
                    frame:SetHeight(height)
                    page.Layout()
                end
            end)
            return rows
        end

        -- Column titles (kit 7, Forever Enemy Buffs' three sides): a 16 px
        -- block of gold titles, one over each control column (xs, default
        -- C1, C2, C3), in the heading just made. It shows whenever its
        -- heading does, a search too; the buttons under it are named by it
        -- (Kit.Unnamed leaves its rows out).
        function page.Columns(titles, xs)
            Start()
            local frame, block = page.Block(16, "columns")
            block.columns = titles
            local at = xs or { C1, C2, C3 }
            for index, title in ipairs(titles) do
                Text(frame, title, (at[index] or C1) + 4, -2, GOLD, CW)
            end
            if group then group.columns = titles end
            return frame, block
        end

        -- Try a choice before picking it (.claude/rules/ui-settings-pages.md,
        -- "Previews in settings"; kit 5, Forever Chat): while a dropdown
        -- list is open, the choice under the mouse is page.trial = { key,
        -- value }, which the addon's preview reads in place of the saved
        -- value; nothing is saved. page.RefreshPreview, when the addon sets
        -- it, redraws the preview. page.Try(nil) puts the saved value back.
        -- Kit 7 (Forever Enemy Buffs): page.Try(values, label) tries several
        -- settings at once, values a table { [key] = value } (a preset under
        -- the mouse); page.trial is then that table. label (either form)
        -- is page.trialLabel, what the preview says it shows ("Order: By
        -- name"); row:Choice passes "<row>: <choice>". page.trialValues is
        -- { [key] = value } in either form, and page.Get(key) reads a
        -- setting through the trial.
        function page.Try(key, value, label)
            local old = page.trial
            if key == nil and old == nil then return end
            if type(key) == "table" then
                if old == key then return end
                page.trial, page.trialValues, page.trialLabel = key, key, value
            else
                if old and key ~= nil and key == old.key and value == old.value then return end
                page.trial = key ~= nil and { key = key, value = value } or nil
                page.trialValues = key ~= nil and { [key] = value } or nil
                page.trialLabel = key ~= nil and label or nil
            end
            if page.RefreshPreview then page.RefreshPreview() end
        end
        function page.Get(key)
            local values = page.trialValues
            if values and values[key] ~= nil then return values[key] end
            return options.get(key)
        end

        -- Opens the page on a tab ("settings" or "help"; kit 5, Forever
        -- Loadout's How to use button): at once while it is shown, else the
        -- next time it shows (once).
        local nextTab
        function page.OpenTab(tab)
            if panel:IsVisible() then
                page.tab = tab
                if scroll then scroll:SetVerticalScroll(0) end
                page.Layout()
                page.Refresh()
            else
                nextTab = tab
            end
        end
        local function NextTab()
            local tab = nextTab or "settings"
            nextTab = nil
            return tab
        end

        -- A row's controls, made by its methods (row:Toggle, row:Choice, ...).
        -- Kit 15 (Forever Cooldowns' Kit.Controls, Options.lua 446-760, used
        -- for its timing editor's lines and its pooled ability rows, Studio.lua
        -- 837-843, 972, 1015): the part of page.Row that gives a row its
        -- methods, public as page.Controls, so a row on a frame of the
        -- addon's own gets the kit's controls at its own y. row: a table
        -- with label and detail (each text or fn()), and part, group and
        -- block when it has them; frame: where the controls go; y: the
        -- controls' top in frame (default -2, a page row's). A slider sits 2
        -- px lower and status text 5 px, as on a page row.
        local function Controls(row, frame, y)
            y = y or -2
            row.frame = row.frame or frame
            row.controls, row.keys, row.settings = row.controls or {}, row.keys or {}, row.settings or {}
            if row.keepsPart == nil then row.keepsPart = options.tipKeepsPart == true end
            if row.tagsRow == nil then row.tagsRow = options.tipTagsRow == true end
            local label, detail = row.label, row.detail
            local function RowName()
                if type(label) == "function" then return label() or "" end
                return label or ""
            end
            local point = function(over, own, name) page.Point(over and row or nil, own, name) end
            -- title and tip, when given, are the control's own tooltip in
            -- place of the row's (a preset button says what it sets).
            local function Keep(control, title, tip)
                row.controls[#row.controls + 1] = control
                control.waitable = true
                Tooltip(control, tip and title or label, tip or detail, point, row)
                NoWrap(control.label)
                return control
            end
            -- row.Track(setting) (kit 11): a setting the addon's own control
            -- changes counts as the row's (its keys, Changed).
            local function Track(setting)
                if setting.key then row.keys[#row.keys + 1] = setting.key end
                row.settings[#row.settings + 1] = setting
                return setting
            end
            row.Track = Track
            -- options.control(key, control, row) (kit 11, Forever Spy): told of
            -- each control made for a setting key.
            local function Told(setting, control)
                if options.control and setting.key then options.control(setting.key, control, row) end
                return control
            end
            -- After combat (kit 11, Forever Targets): a row whose changes the
            -- game only takes out of combat. In a host (a gear's panel) its
            -- controls dim in combat, refuse clicks, drags, steps and resets,
            -- and their tooltips end in "After combat"; on the settings page
            -- they take changes at once (the addon applies them after
            -- combat). options.waitColor: the line's colour (default the
            -- kit's amber); options.waitKeepsValue: a slider's value and reset
            -- arrow stay bright.
            -- options.waitOnPage (kit 15, Forever Cooldowns: its profile,
            -- tracking, editor and list rows, Options.lua 338 and 749-754;
            -- the user's kit 11 answer B, CONVERSIONS.md "Kit 14", 4th
            -- decision): the settings page's rows wait too, exactly as a
            -- host's: dimmed whole, refused (clicks, drags, steps, resets,
            -- text boxes, dropdowns) and "After combat" last in their
            -- tooltips. The addon refreshes the page as combat starts and
            -- ends, as it does a host. Default off: on the page such rows
            -- take changes at once (Forever Targets).
            local function Waiting()
                return row.waits == true and (page.host ~= nil or options.waitOnPage == true)
                    and InCombatLockdown ~= nil and InCombatLockdown() == true
            end
            row.Waiting = Waiting
            function row.WaitLine()
                if Waiting() then return { text = "After combat", color = options.waitColor } end
                return nil
            end
            -- setting.enabled (kit 18): a control whose setting cannot be used
            -- now (a CVar this build lacks or locks) is greyed to 0.4 and
            -- disabled, below the 0.45 of the dims above (control.gate is
            -- its setting).
            local function Dim(control)
                local off = (control.dependsOn and not control.dependsOn()) or (row.waits and Waiting())
                local alpha = off and 0.45 or 1
                local gated = control.gate ~= nil and not Usable(control.gate)
                if gated then alpha = 0.4 end
                if control.gate ~= nil and control.SetEnabled then control:SetEnabled(not gated) end
                control:SetAlpha(alpha)
                local waitOnly = not gated and not (control.dependsOn and not control.dependsOn())
                -- Kit 16: by index, not ipairs, which stopped at a slider's
                -- missing reset arrow and left a dimmed number bright.
                local pieces = { control.down, control.up, control.reset, control.valueText }
                for index = 1, 4 do
                    local piece = pieces[index]
                    if type(piece) == "table" and piece.SetAlpha then
                        local keep = options.waitKeepsValue and waitOnly and (piece == control.reset or piece == control.valueText)
                        piece:SetAlpha(keep and 1 or alpha)
                    end
                end
                -- A kept control's own arrows (row:StepArrow, kit 14), either
                -- or both. The list above stops at its first nil (ipairs), so
                -- a lone > there would stay bright.
                for _, arrow in ipairs(control.arrows or {}) do arrow:SetAlpha(alpha) end
            end
            -- A control whose setting has enabled() is greyed at each refresh
            -- while it gives false (kit 18).
            local function Gate(control, setting)
                if not (type(setting) == "table" and setting.enabled) then return control end
                control.gate = setting
                page.OnRefresh(function() Dim(control) end)
                return control
            end
            function row:AfterCombat()
                row.waits = true
                if page.host or options.waitOnPage then
                    page.OnRefresh(function()
                        for _, control in ipairs(row.controls) do Dim(control) end
                    end)
                end
                return row
            end
            -- row:Keep(control, title, tip, setting) (kit 14, public; it was
            -- private): adds a control the addon built on row.frame to the
            -- row as the kit's own controls are added: in row.controls, its
            -- tooltip (the row's name and detail, or title and tip when tip
            -- is given; row:Tip still overrides), pointing at the row's part
            -- on hover (or its own, row:Tip), After combat's last line, one
            -- line of text under noWrap; setting (a key or a setting table,
            -- optional) counts as the row's (row.keys, page.Changed, the
            -- More line) and is told to options.control. row:DependsOn and
            -- row:AfterCombat dim it, and control.down, control.up,
            -- control.reset and control.valueText with it. Its clicks are
            -- the addon's. Forever Junk's coin ladder (CONVERSIONS.md, Forever
            -- Junk, gap 2) is the first.
            function row:Keep(control, title, tip, setting)
                if setting ~= nil then Told(Track(Adapter(setting)), control) end
                return Keep(control, title, tip)
            end
            -- row:StepArrow(direction, arrowOptions) -> arrow (kit 14):
            -- Kit.StepArrow on the row, wired as a slider's arrows are: it
            -- points at the row's part on hover (arrowOptions.control's own,
            -- row:Tip, on a row of two), is dark and refuses clicks while
            -- the row waits for combat (row:AfterCombat in a host), its
            -- tooltip ends in After combat then, and it paints on each
            -- refresh; a dark one (peek nil) takes no step. arrowOptions are
            -- Kit.StepArrow's, plus control: the kept control it steps,
            -- whose control.down (direction -1) or control.up it becomes
            -- (and one of control.arrows), so row:DependsOn and
            -- row:AfterCombat dim it along. The addon places it
            -- (arrow:SetPoint).
            function row:StepArrow(direction, arrowOptions)
                arrowOptions = arrowOptions or {}
                local owner = arrowOptions.control
                local wired = {}
                for key, value in pairs(arrowOptions) do wired[key] = value end
                wired.peek = function(d)
                    if Waiting() then return nil end
                    if arrowOptions.peek then return arrowOptions.peek(d) end
                    return true
                end
                wired.step = function(d, arrow)
                    if Waiting() or not arrowOptions.step then return false end
                    -- A dark arrow takes no step (Junk's ends, Widgets.lua 155).
                    if arrowOptions.peek and arrowOptions.peek(d) == nil then return false end
                    local stepped = arrowOptions.step(d, arrow)
                    page.Refresh()
                    return stepped
                end
                wired.enter = function(arrow, d)
                    OwnPoint(point, owner and type(owner.tip) == "table" and owner.tip or nil, row)
                    if arrowOptions.enter then arrowOptions.enter(arrow, d) end
                end
                wired.leave = function(arrow)
                    point(false)
                    if arrowOptions.leave then arrowOptions.leave(arrow) end
                end
                wired.late = function()
                    local line = arrowOptions.late and arrowOptions.late()
                    return line or row.WaitLine()
                end
                local arrow = StepArrow(frame, direction, wired)
                if owner then
                    if direction < 0 then owner.down = arrow else owner.up = arrow end
                    owner.arrows = owner.arrows or {}
                    owner.arrows[#owner.arrows + 1] = arrow
                end
                page.OnRefresh(arrow.Paint)
                return arrow
            end
            -- One of Blizzard's own settings: the tooltip lines, and the tag
            -- on its name unless its heading carries the tag already
            -- (page.BlizzardHeading). where: the place in Blizzard's UI, nil
            -- when it shows none; how: what this addon does with it, when
            -- that needs saying.
            -- Kit 18: a heading it sits in may carry the tag too (headings
            -- inside a heading); how may be fn() (Kit.BlizzardLines).
            function row:Blizzard(where, how)
                row.blizzard = { where = where, how = how }
                if not row.name then return row end
                local this = row.group
                while this do
                    if this.blizzard then return row end
                    this = this.parent
                end
                local tag, color = BlizzardLines(row.blizzard)
                Tag(row.name, tag, color)
                return row
            end
            -- The row shows only while when() is true (a row some picked
            -- things lack).
            function row:When(when)
                -- A row on the addon's own frame (page.Controls) without a
                -- block has none to hide.
                if row.block then row.block.when = when end
                return row
            end
            -- waiting() is true (or "restart") while this row's change waits
            -- for a reload (or a restart): its name strip glows amber with a
            -- Reload (Restart) tag at its right end, left of a Blizzard tag
            -- (ReloadKit.Mark), and the name stops before it. tip: the amber
            -- tooltip line saying so before the click (or fn() giving it).
            -- Without ReloadKit.lua only the tooltip line shows.
            function row:Reload(waiting, tip)
                row.amberTip = tip
                row.reloadWaiting = waiting
                page.OnRefresh(function()
                    local reload = ns.ReloadKit
                    if not reload or not row.name then return end
                    local state = waiting()
                    local kind = state == "restart" and "restart" or (state and "reload" or nil)
                    local tag = reload.Mark(row.name, kind, row.name.tag)
                    local text = row.name.label
                    text:ClearAllPoints()
                    text:SetPoint("LEFT", 8, 0)
                    local before = tag or row.name.tag
                    if before then text:SetPoint("RIGHT", before, "LEFT", -4, 0) else text:SetPoint("RIGHT", -8, 0) end
                    row.reloadTag = tag
                end)
                return row
            end
            -- On or Off; a click switches. name: on a row of two, the button
            -- says its own ("Bold: On"; "Two settings, one row").
            -- setting.mixed() (kit 15, Forever Cooldowns' abilities with only
            -- some ranks tracked, Options.lua 474-477): true draws "Some" in
            -- gold in place of On or Off; a click still sets not get().
            function row:Toggle(x, key, width, name)
                local setting = Track(Adapter(key))
                local button = Keep(ButtonWidget(frame, x, y, width or CW, ""))
                button.label:SetJustifyH("CENTER")
                button.toggleName = name or false
                Told(setting, button)
                Gate(button, setting)
                button:SetScript("OnClick", function()
                    if Waiting() or not Usable(setting) then return end
                    setting.set(not (setting.get() == true))
                    page.Refresh()
                end)
                page.OnRefresh(function()
                    local on = setting.get() == true
                    local some = setting.mixed ~= nil and setting.mixed() == true
                    button.label:SetText((name and (name .. ": ") or "") .. (some and "Some" or (on and "On" or "Off")))
                    local lit = on or some
                    button.label:SetTextColor(lit and GOLD[1] or GREY[1], lit and GOLD[2] or GREY[2], lit and GOLD[3] or GREY[3])
                end)
                return button
            end
            -- One of a few values: row:Choice(x, setting, choices, labels,
            -- width) with the choices in order and labels by value, or
            -- row:Choice(x, setting, labels, width) with the setting's own
            -- choices (setting.options, from options.choices). With 2 or 3
            -- choices a click steps to the next, a right-click back, shown
            -- as < Value >; with 4 or more a click opens the flat menu's
            -- list under the button (FlatMenu.lua; the workspace rule), the
            -- value on the left and the menu's down arrow on the right, and
            -- without FlatMenu.lua it steps as with fewer.
            -- name (kit 7): on a row of two the button says its own name
            -- ("Target: Right"); the list keeps the plain labels.
            -- setting.tips (kit 15, Forever Cooldowns' kinds, Grow and the
            -- editor's Kind, Options.lua 506): { [value] = text } or
            -- fn(value) -> text, each choice's tooltip in the list (the
            -- flat menu's SetTooltip, which takes plain text). A stepped
            -- choice (2 or 3) has no list, so no tips.
            function row:Choice(x, key, choices, labels, width, name)
                if type(labels) ~= "table" then choices, labels, width, name = nil, choices, labels, width end
                local setting = Track(Adapter(key))
                local function Choices() return choices or setting.options or {} end
                local button = Keep(ButtonWidget(frame, x, y, width or CW, ""))
                button.choiceName = name or false
                Told(setting, button)
                Gate(button, setting)
                local listed = #Choices() >= 4 and ns.FlatMenu ~= nil
                button.dropdown = listed
                if listed then
                    button.label:SetJustifyH("LEFT")
                    button.label:SetPoint("RIGHT", -20, 0)
                    ns.FlatMenu.DownArrow(button)
                else
                    button.label:SetJustifyH("CENTER")
                end
                local function Label(value) return labels[value] or tostring(value) end
                local function Shown(value) return (name and (name .. ": ") or "") .. Label(value) end
                button:SetScript("OnClick", function(_, mouse)
                    if Waiting() or not Usable(setting) then return end
                    local list = Choices()
                    if #list == 0 then return end
                    if listed then
                        ns.FlatMenu.Open(button, function(_, root)
                            for _, option in ipairs(list) do
                                local radio = root:CreateRadio(Label(option), function() return setting.get() == option end,
                                    function() page.trial = nil; setting.set(option); page.Refresh() end)
                                local tips = setting.tips
                                local tip = type(tips) == "function" and tips(option) or (type(tips) == "table" and tips[option] or nil)
                                if tip and type(radio) == "table" and type(radio.SetTooltip) == "function" then radio:SetTooltip(tip) end
                                -- Kit 5: the choice under the mouse shows in
                                -- the preview (page.Try).
                                if setting.key and type(radio) == "table" and type(radio.SetOnEnter) == "function" then
                                    radio:SetOnEnter(function() page.Try(setting.key, option, RowName() .. ": " .. Label(option)) end)
                                    radio:SetOnLeave(function() page.Try(nil) end)
                                end
                            end
                            -- options.listScroll (kit 11): false shows every
                            -- choice (Forever Spy's 17 sounds), or a height.
                            if options.listScroll ~= false and #list > 12 then root:SetScrollMode(options.listScroll or 300) end
                            if type(root.AddMenuReleasedCallback) == "function" then
                                root:AddMenuReleasedCallback(function() page.Try(nil) end)
                            end
                        end)
                        return
                    end
                    local index = 1
                    for i, option in ipairs(list) do
                        if option == setting.get() then index = i end
                    end
                    index = index + (mouse == "RightButton" and -1 or 1)
                    if index > #list then index = 1 elseif index < 1 then index = #list end
                    setting.set(list[index])
                    page.Refresh()
                end)
                page.OnRefresh(function()
                    local value = setting.get()
                    if listed then button.label:SetText(Shown(value))
                    else button.label:SetText(GREY_TEXT .. "<|r  " .. Shown(value) .. "  " .. GREY_TEXT .. ">|r") end
                end)
                return button
            end
            -- A dropdown over a list that changes (profiles): the value on
            -- the left, the flat menu's down arrow on the right, a click opens
            -- the list under it. options: list() the names, get() the chosen
            -- one or nil (empty is written then, default "None"), set(name),
            -- users(name) the tooltip lines of a name's entry. Without
            -- FlatMenu.lua a click steps through the names, a right-click back.
            -- label(value) (kit 15, Forever Cooldowns' bars, Options.lua
            -- 674): the name a value shows in the list and on the button
            -- ("1. Cooldowns" for bar 1), default the value itself; get, set
            -- and users still take the value.
            function row:Pick(x, pickOptions, width)
                local button = Keep(ButtonWidget(frame, x, y, width or CW, ""))
                local function Shown(value)
                    if pickOptions.label then return pickOptions.label(value) or tostring(value) end
                    return value
                end
                local listed = ns.FlatMenu ~= nil
                button.dropdown = listed
                if listed then
                    button.label:SetJustifyH("LEFT")
                    button.label:SetPoint("RIGHT", -20, 0)
                    ns.FlatMenu.DownArrow(button)
                else
                    button.label:SetJustifyH("CENTER")
                end
                button:SetScript("OnClick", function(_, mouse)
                    if Waiting() then return end
                    local names = pickOptions.list()
                    if #names == 0 then return end
                    if listed then
                        ns.FlatMenu.Open(button, function(_, root)
                            for _, entry in ipairs(names) do
                                local radio = root:CreateRadio(Shown(entry), function() return pickOptions.get() == entry end,
                                    function() pickOptions.set(entry); page.Refresh() end)
                                if pickOptions.users then
                                    radio:SetTooltip(function(tooltip)
                                        tooltip:SetText(Shown(entry))
                                        for _, line in ipairs(pickOptions.users(entry)) do
                                            tooltip:AddLine(line, 0.85, 0.85, 0.85, true)
                                        end
                                    end)
                                end
                            end
                            root:SetScrollMode(300)
                        end)
                        return
                    end
                    local index = 0
                    for i, entry in ipairs(names) do
                        if entry == pickOptions.get() then index = i end
                    end
                    index = index + (mouse == "RightButton" and -1 or 1)
                    if index > #names then index = 1 elseif index < 1 then index = #names end
                    pickOptions.set(names[index])
                    page.Refresh()
                end)
                page.OnRefresh(function()
                    local value = pickOptions.get()
                    local text = value ~= nil and Shown(value) or (GREY_TEXT .. (pickOptions.empty or "None") .. "|r")
                    if listed or not value then
                        button.label:SetText(text)
                    else
                        button.label:SetText(GREY_TEXT .. "<|r  " .. text .. "  " .. GREY_TEXT .. ">|r")
                    end
                end)
                return button
            end
            -- A text box in the row's style: Enter hands its text to
            -- submit(text), which returns true to empty it; Escape leaves
            -- it. fill() is the text it shows on each refresh while it does
            -- not have the focus. Blizzard's font object draws it, so names
            -- in any alphabet show. extra (kit 5): { button = text } draws a
            -- button after the box to the right column's edge that submits
            -- too (Forever Bank's "Add"; row.inputButton, returned second);
            -- letters, the most it takes (default 48).
            function row:Input(x, submit, width, fill, extra)
                extra = extra or {}
                local box = Keep(CreateFrame("EditBox", nil, frame, "BackdropTemplate"))
                box:SetPoint("TOPLEFT", x, y)
                box:SetSize(width or CW, 22)
                Edge(box)
                box:SetBackdropColor(0.1, 0.105, 0.12, 1)
                box:SetBackdropBorderColor(0, 0, 0, 1)
                box:SetFontObject(GameFontHighlightSmall)
                box:SetTextInsets(8, 8, 0, 0)
                box:SetAutoFocus(false)
                box:SetMaxLetters(extra.letters or 48)
                local function Accept()
                    -- Waiting for combat (kit 15): kept in the box, not
                    -- handed on.
                    if Waiting() then box:ClearFocus(); return end
                    if submit(box:GetText()) then box:SetText("") end
                    box:ClearFocus()
                    page.Refresh()
                end
                box:SetScript("OnEnterPressed", Accept)
                box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
                row.input = box
                -- A refused entry stays in the box to be corrected; a box
                -- with a fill shows its value again.
                page.OnRefresh(function()
                    if not fill or box:HasFocus() then return end
                    box:SetText(fill() or "")
                end)
                if extra.button then
                    local left = x + (width or CW) + 6
                    local button = Keep(ButtonWidget(frame, left, y, C2 + CW - left, extra.button))
                    button.label:SetJustifyH("CENTER")
                    button:SetScript("OnClick", Accept)
                    row.inputButton = button
                    return box, button
                end
                return box
            end
            -- A text setting (kit 5, Forever Chat's word lists): a box in
            -- Input's look across both control columns (width, default
            -- kit.WIDE) showing the setting's text; leaving the box saves
            -- it, Enter leaves it, Escape puts the saved text back. A set
            -- that returns false refuses the text, and the saved text shows
            -- again. The most it takes: setting.letters, else a number in
            -- its limits, else 255. row.edit is the box.
            function row:Edit(x, key, width)
                local setting = Track(Adapter(key))
                local box = Keep(CreateFrame("EditBox", nil, frame, "BackdropTemplate"))
                box:SetPoint("TOPLEFT", x, y)
                box:SetSize(width or WIDE, 22)
                Edge(box)
                box:SetBackdropColor(0.1, 0.105, 0.12, 1)
                box:SetBackdropBorderColor(0, 0, 0, 1)
                box:SetFontObject(GameFontHighlightSmall)
                box:SetTextInsets(8, 8, 0, 0)
                box:SetAutoFocus(false)
                box:SetMaxLetters(setting.letters or (type(setting.limits) == "number" and setting.limits) or 255)
                local function Saved()
                    local value = setting.get()
                    return value == nil and "" or tostring(value)
                end
                box:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
                box:SetScript("OnEscapePressed", function(self)
                    self:SetText(Saved())
                    self:ClearFocus()
                end)
                box:SetScript("OnEditFocusLost", function(self)
                    local text = self:GetText() or ""
                    if text == Saved() then return end
                    -- Waiting for combat (kit 15), or not usable now (kit
                    -- 18): the saved text again.
                    if Waiting() or not Usable(setting) then self:SetText(Saved()); return end
                    if setting.set(text) == false then self:SetText(Saved()) end
                    page.Refresh()
                end)
                page.OnRefresh(function()
                    if not box:HasFocus() then box:SetText(Saved()) end
                end)
                row.edit = box
                Told(setting, box)
                Gate(box, setting)
                return box
            end
            -- A flat track with a gold thumb, the value after it, and the
            -- reset arrow at the end; a grey < and > either side of the track
            -- step it one notch through the setter a drag uses, dim at that
            -- end of the range. The workspace's one slider (the user, 23
            -- October 2026): in a 150 px column the track is 61 px and the
            -- value 46 px with a reset arrow, 75 and 48 without; the last
            -- piece ends at the column's edge. unit: words after a value the
            -- setting does not format itself (" px"); it may be left out, so
            -- row:Slider(x, key, step, width) works too, and so does
            -- row:Slider(x, key, step, nil, width).
            -- Kit 5: a step passes over notches that show the same value
            -- (a setter that turns 1 to 7 into 8 shows 8 px for each), so it
            -- always moves; setting.valueWidth (else options.valueWidth) is a
            -- wider value for long texts, the track giving way; a limit may
            -- be fn() for one that moves (the largest size the screen
            -- allows), read at each refresh; options.frozen() true (or a
            -- line of text) dims both arrows and drops their "Sets" line
            -- while the addon's setter refuses (in combat), and they still
            -- click through to it.
            -- Kit 8 (the user, 23 October 2026, "Longer sliders and easier
            -- arrows"): each < and > is a small button over its 18 px square
            -- (the buttons' dark fill in a 1 px black edge, gold on hover),
            -- and no square covers the track, the value or the reset arrow:
            -- from the column's x, the < square at -4 to 14, the track from
            -- 15, 1 px, the > square, 1 px, the value, 2 px, the reset arrow
            -- (14), ending at the column's edge. In a 150 px column that
            -- leaves a 61 px track with kit 9's 38 px value and the reset
            -- arrow (77 without). A slider alone on its row in the first
            -- column, given no width of its own, takes the whole row to the
            -- last column's edge (a 217 px track in the standard columns),
            -- once the row is built: nothing else on the row (no second
            -- control, status text or frame of the addon's own), control.whole.
            function row:Slider(x, key, step, unit, width)
                if type(unit) == "number" then unit, width = nil, unit end
                local ownWidth = width ~= nil
                local setting = Track(Adapter(key))
                -- Kit 11: the step may come from the limits' third value.
                step = step or (type(setting.limits) == "table" and setting.limits[3]) or 1
                if unit and not setting.format then
                    -- Whole steps show whole numbers.
                    setting.format = function(number)
                        if step >= 1 then number = math.floor(number + 0.5) end
                        return tostring(number) .. unit
                    end
                end
                width = width or CW
                local function Bounds()
                    local limits = setting.limits
                    local lowest, highest = limits[1], limits[2]
                    if type(lowest) == "function" then lowest = lowest() end
                    if type(highest) == "function" then highest = highest() end
                    return lowest, highest
                end
                local low, high = Bounds()
                local default = type(setting.default) == "number" and setting.default or nil
                -- A dynamic slider keeps its reset arrow: some picked thing
                -- has a default, and its own is read on each refresh.
                if setting.dynamic then default = default or low end
                -- Kit 18 (Forever Skin's CVar sliders, Nameplate size, Aura
                -- size and Aura gap, ForeverSkin/Settings.lua 4069-4075 and
                -- 4314-4334): setting.default may be fn() -> number or nil,
                -- read at each refresh, the reset arrow hidden while it gives
                -- nil (a CVar this build lacks or locks) and its room kept;
                -- setting.reset, fn(), is what the arrow's click does in place
                -- of setting.set(default) (Skin writes the CVar's own
                -- default through its setter, so it waits for combat too).
                local fnDefault = type(setting.default) == "function"
                local function DefaultNow()
                    local value = setting.default()
                    return type(value) == "number" and value or nil
                end
                if fnDefault then default = DefaultNow() end
                setting.step = step
                -- options.valueWidth may be fn(width, reset) (kit 7: a 110 px
                -- column's value narrower than a wide slider's).
                local function ValueWidth(columnWidth)
                    local valueWidth = setting.valueWidth or options.valueWidth
                    if type(valueWidth) == "function" then valueWidth = valueWidth(columnWidth, default ~= nil or fnDefault) end
                    -- Kit 9 (the user, 23 October 2026: "in general wider is
                    -- better for sliders"): a 38 px value, widened at each
                    -- refresh as far as the slider's longest value needs.
                    return valueWidth or 38
                end
                local valueWidth = ValueWidth(width)
                -- The span the slider takes: its column, or the whole row.
                local span = width
                -- The track's length in a span of width: what the arrows,
                -- the value and the reset arrow leave (kit 8).
                local function TrackFor(span, valueSpan)
                    return span - 15 - 1 - ARROW - 1 - valueSpan - ((default or fnDefault) and 16 or 0)
                end
                local control = Keep(CreateFrame("Slider", nil, frame))
                Told(setting, control)
                Gate(control, setting)
                control.columnX = x
                control:SetPoint("TOPLEFT", x + 15, y - 2)
                control:SetSize(TrackFor(width, valueWidth), 18)
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
                -- Kit 11: a stepped value without the float noise of its
                -- arithmetic (0.95, not 0.95000000000000007).
                -- setting.onRelease (kit 12, Forever Settings' window scale):
                -- a drag shows its value and writes it when the mouse lets
                -- go; arrows and reset write at once. held: the value a drag
                -- waits to write.
                local held
                local function Round(number)
                    local rounded = math.floor(number * 1e9 + 0.5) / 1e9
                    -- A whole number stays whole (Lua 5.3's division makes a float).
                    if rounded == math.floor(rounded) then return math.floor(rounded) end
                    return rounded
                end
                local function Frozen()
                    if not options.frozen then return false end
                    return options.frozen() or false
                end
                -- The value the next notch that shows a different value
                -- sets, or nil at the end.
                local function Stepped(direction)
                    local lowest, highest = Bounds()
                    local current = setting.get() or lowest
                    if type(current) ~= "number" then return nil end
                    current = math.max(lowest, math.min(highest, current))
                    local shown = Format(setting, current)
                    local number = current
                    for _ = 1, 1000 do
                        local nextNumber = Round(math.max(lowest, math.min(highest, math.floor((number + direction * step) / step + 0.5) * step)))
                        if not Differs(nextNumber, number, step) then return nil end
                        number = nextNumber
                        if Format(setting, number) ~= shown then return number end
                    end
                    return nil
                end
                -- Kit 3 (the user, 23 October 2026: the arrows were too
                -- hard to hit): each arrow takes the mouse over an 18 px
                -- square, the row's control height, reaching away from the
                -- track (the < into the room on its left, the > over the
                -- plain value text, which takes no clicks); its glyph stays
                -- 5 px from the track, where the 10 px arrow had it, and
                -- turns gold anywhere on the square.
                -- Kit 8: drawn as a small button on that square, its edge
                -- (ARTWORK -2) and fill (ARTWORK -1) above any backdrop's
                -- Center fill (kit 6), the glyph centred over them.
                -- Kit 14: that button is Kit.StepArrow, public, so an
                -- addon's own stepped control draws the same arrows.
                local function Arrow(direction)
                    return StepArrow(frame, direction, {
                        peek = function()
                            if Frozen() or Waiting() or not Usable(setting) then return nil end
                            return Stepped(direction)
                        end,
                        -- An arrow outlines what its slider changes, its own
                        -- part on a row of two.
                        enter = function() OwnPoint(point, type(control.tip) == "table" and control.tip or nil, row) end,
                        leave = function() point(false) end,
                        title = direction < 0 and "One step down" or "One step up",
                        detail = function()
                            local frozen = Frozen()
                            if frozen then return type(frozen) == "string" and frozen or nil end
                            local number = Stepped(direction)
                            return number and ("Sets " .. Format(setting, number) .. ".")
                                or (direction < 0 and "Already at the lowest value." or "Already at the highest value.")
                        end,
                        late = function()
                            if Frozen() then return nil end
                            return row.WaitLine()
                        end,
                        step = function()
                            if Waiting() or not Usable(setting) then return false end
                            held = nil
                            local number = Stepped(direction)
                            if not number then return false end
                            setting.set(number)
                            page.Refresh()
                            return true
                        end,
                    })
                end
                local down, up = Arrow(-1), Arrow(1)
                down:SetPoint("RIGHT", control, "LEFT", -1, 0)
                up:SetPoint("LEFT", control, "RIGHT", 1, 0)
                -- row.down, row.up, row.value, row.reset: the row's first
                -- slider's (read by the tests); control.*: each slider's own.
                row.down, row.up = row.down or down, row.up or up
                control.down, control.up = down, up
                local value = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                -- The value starts 1 px after the > square (kit 8; it sat
                -- under the square's far side).
                value:SetPoint("LEFT", control, "RIGHT", 1 + ARROW + 1, 0)
                value:SetWidth(valueWidth)
                value:SetJustifyH("RIGHT")
                row.value = row.value or value
                control.valueText, control.readout = value, value
                local reset, changed
                if default or fnDefault then
                    reset = CreateFrame("Button", nil, frame)
                    reset:SetSize(14, 14)
                    reset:SetPoint("LEFT", value, "RIGHT", 2, 0)
                    reset.art = reset:CreateTexture(nil, "ARTWORK")
                    reset.art:SetAllPoints()
                    reset:SetScript("OnEnter", function(self) ShowTip(self, "Reset to default") end)
                    reset:SetScript("OnLeave", function(self) HideTip(self) end)
                    reset:SetScript("OnClick", function()
                        if not changed or Waiting() or not Usable(setting) then return end
                        held = nil
                        if setting.reset then setting.reset() elseif default ~= nil then setting.set(default) end
                        page.Refresh()
                    end)
                    row.reset = row.reset or reset
                    control.reset = reset
                end
                local function Paint()
                    down.Paint()
                    up.Paint()
                    if not reset then return end
                    -- Kit 18: hidden while a default fn() knows none; never
                    -- lit while the setting cannot be used (setting.enabled).
                    if fnDefault then reset:SetShown(default ~= nil) end
                    changed = default ~= nil and Differs(setting.get(), default, step) and Usable(setting)
                    ResetArt(reset.art, changed)
                end
                -- Alone on its row: the whole row, decided at the first
                -- refresh, when the row is built (kit 8).
                local decided = ownWidth or x ~= C1
                local own = { [control] = true, [down] = true, [up] = true }
                if row.name then own[row.name] = true end
                if reset then own[reset] = true end
                local function Alone()
                    if #row.controls ~= 1 or row.status then return false end
                    if frame.GetChildren then
                        for _, child in ipairs({ frame:GetChildren() }) do
                            if not own[child] then return false end
                        end
                    end
                    if frame.GetRegions then
                        for _, region in ipairs({ frame:GetRegions() }) do
                            if region ~= value and region.IsObjectType and region:IsObjectType("FontString") then return false end
                        end
                    end
                    return true
                end
                local function Decide()
                    decided = true
                    if not Alone() then return end
                    span = (C3 or C2) + CW - x
                    control.whole = true
                    row.whole = control
                end
                -- Kit 9: the value box widens for a slider whose longest
                -- value does not fit in it, the track giving the room only
                -- as far as needed. Measured on the value text itself: the
                -- values at both limits and the default, and every step's
                -- when there are at most 200 (a format may name some, "Off"),
                -- again whenever the limits move. control.needed is the
                -- widest value measured, nil when the text cannot be
                -- measured.
                local measuredFor
                local function Widest()
                    local key = tostring(low) .. "|" .. tostring(high) .. "|" .. tostring(default)
                    if measuredFor == key then return control.needed end
                    measuredFor = key
                    local measure = value.GetUnboundedStringWidth or value.GetStringWidth
                    if not measure or type(low) ~= "number" or type(high) ~= "number" then
                        control.needed = nil
                        return nil
                    end
                    local numbers = { low, high }
                    if type(default) == "number" then numbers[#numbers + 1] = default end
                    local count = step > 0 and math.floor((high - low) / step + 0.5) or 0
                    if count <= 200 then
                        for index = 1, count - 1 do numbers[#numbers + 1] = low + index * step end
                    end
                    local widest
                    for _, number in ipairs(numbers) do
                        value:SetText(Format(setting, number))
                        local measured = measure(value)
                        if type(measured) == "number" and not (issecretvalue and issecretvalue(measured)) then
                            widest = math.max(widest or 0, measured)
                        end
                    end
                    control.needed = widest
                    return widest
                end
                -- Kit 10: at least GAP px between the slider's last part and
                -- the next column's first, a slider's < box 4 px before its
                -- column (Forever Threat's Width and height): the room comes
                -- off this slider's track.
                local GAP = 4
                local function Room()
                    local room = span
                    for _, other in ipairs(row.controls) do
                        local start = other ~= control and other.columnX
                        if start and start > x and (start - 4) - (x + room) < GAP then room = start - 4 - GAP - x end
                    end
                    return room
                end
                local function Fit()
                    local room = Room()
                    local want = ValueWidth(room)
                    local widest = Widest()
                    if widest then want = math.max(want, math.ceil(widest) + 2) end
                    -- The track keeps 8 px at the least (the thumb's width).
                    want = math.min(want, room - 15 - 1 - ARROW - 1 - ((default or fnDefault) and 16 or 0) - 8)
                    if want ~= valueWidth or control.spanned ~= room then
                        valueWidth = want
                        control.spanned = room
                        control:SetSize(TrackFor(room, valueWidth), 18)
                        value:SetWidth(valueWidth)
                    end
                end
                local quiet = false
                page.OnRefresh(function()
                    if not decided then Decide() end
                    quiet = true
                    -- Limits that move, and a dynamic setting's limits and
                    -- default, which follow the picked thing.
                    low, high = Bounds()
                    control:SetMinMaxValues(low, high)
                    if fnDefault then
                        default = DefaultNow()
                    elseif setting.dynamic then
                        default = type(setting.default) == "number" and setting.default or nil
                    end
                    Fit()
                    local current = setting.get() or low
                    control:SetValue(math.max(low, math.min(high, current)))
                    value:SetText(Format(setting, current))
                    quiet = false
                    Paint()
                end)
                control:SetScript("OnValueChanged", function(_, raw)
                    local number = Round(math.max(low, math.min(high, math.floor(raw / step + 0.5) * step)))
                    value:SetText(Format(setting, number))
                    if quiet then return end
                    -- After combat in a panel, or not usable now (kit 18): the
                    -- slider goes back.
                    if Waiting() or not Usable(setting) then page.Refresh(); return end
                    if setting.onRelease then
                        held = number
                        return
                    end
                    -- Only a change is written (kit 11, Forever Range).
                    if number ~= setting.get() then setting.set(number) end
                    Paint()
                end)
                if setting.onRelease then
                    control:SetScript("OnMouseUp", function()
                        if held == nil then return end
                        local number = held
                        held = nil
                        if Waiting() or not Usable(setting) then page.Refresh(); return end
                        if number ~= setting.get() then setting.set(number) end
                        page.Refresh()
                    end)
                end
                -- setting.wheel or options.sliderWheel (kit 12, GANG secret):
                -- the mouse wheel over the track steps it one notch.
                if setting.wheel or options.sliderWheel then
                    control:EnableMouseWheel(true)
                    control:SetScript("OnMouseWheel", function(_, delta)
                        if Waiting() or not Usable(setting) then return end
                        held = nil
                        local number = Stepped(delta > 0 and 1 or -1)
                        if not number then return end
                        setting.set(number)
                        page.Refresh()
                    end)
                end
                return control
            end
            function row:Button(x, text, onClick, width, tip)
                local button = Keep(ButtonWidget(frame, x, y, width or CW, text), text, tip)
                -- row.actions (kit 11, Forever Range): the buttons' texts.
                row.actions = row.actions or {}
                row.actions[#row.actions + 1] = text
                button:SetScript("OnClick", function(clicked, mouse)
                    if Waiting() then return end
                    onClick(clicked, mouse)
                    page.Refresh()
                end)
                return button
            end
            -- A row of two ("Two settings, one row"): the second control's
            -- own tooltip and, when it changes another part of the preview,
            -- its own outline and click-to-find part.
            -- own false: the control points at nothing, even where a control
            -- without a part of its own points at its row's (tipKeepsPart).
            -- blizzard (kit 5): { where, how }, its own Blizzard lines in
            -- place of the row's (row:Blizzard).
            -- extra (kit 18, Forever Skin's paired Blizzard switches and the
            -- Aura size and gap sliders, ForeverSkin/Settings.lua 3978 and
            -- 4326-4336): { state = fn() -> text, reload = text or fn() }:
            -- state, what holds this control's setting now ("after combat",
            -- "after reload", "not on this build"), an amber "Now: ...." line
            -- in its tooltip, the status a row of one shows beside its
            -- control; reload, its own amber reload line in place of the
            -- row's (row:Reload's tip). Skin's form, row:Tip(control, title,
            -- detail, part, { blizzard, state, reload }), works too: a fifth
            -- argument holding any of those three is extra, not blizzard.
            function row:Tip(control, title, tipDetail, own, blizzard, extra)
                if type(blizzard) == "table" and extra == nil
                    and (blizzard.state ~= nil or blizzard.reload ~= nil or blizzard.blizzard ~= nil) then
                    blizzard, extra = blizzard.blizzard, blizzard
                end
                extra = extra or {}
                control.tip = { title = title, detail = tipDetail, part = own, blizzard = blizzard,
                    state = extra.state, reload = extra.reload }
                if own then
                    row.parts = row.parts or {}
                    row.parts[#row.parts + 1] = own
                end
                return control
            end
            -- The second control dims while the setting it depends on is off
            -- (enabled() false), and still works (the user, 23 October 2026).
            -- A slider's arrows, value and reset arrow dim with it.
            function row:DependsOn(control, enabled)
                control.dependsOn = enabled
                page.OnRefresh(function() Dim(control) end)
                return control
            end
            -- Short grey text after a single control (or in the control
            -- column when x is given: a mouse and keys entry).
            function row:Status(fn, x, statusWidth)
                local status = Text(frame, "", (x or C2) + 4, y - 5, GREY, statusWidth or (CW + 30))
                NoWrap(status)
                row.status = status
                page.OnRefresh(function() status:SetText(fn() or "") end)
                return status
            end
            return row
        end

        -- page.Controls(row, frame, y, block) -> row (kit 15): row's
        -- methods on the addon's own frame (Controls above). block, when
        -- given (page.Insert's), holds the row: block.row, row.block and
        -- row.group are set, so the row is searched, counted, outlined and
        -- dimmed as a page row is. Not in page.rows or page.list. The addon
        -- draws its own name strip (row.name) if it wants one; row:Indent,
        -- row:Blizzard's tag and row:Reload's tag need one.
        function page.Controls(row, frame, y, block)
            if block then
                block.row, row.block = row, block
                if row.group == nil then row.group = block.group end
            end
            return Controls(row, frame, y)
        end

        -- One setting: its name, then its controls. part: what the row
        -- changes in its heading's preview (preview.parts), if anything.
        function page.Row(label, detail, part, height)
            local rowKey = NameKey(label, "row")
            assert(not page.rows[rowKey], "two rows named " .. tostring(rowKey))
            Start()
            local frame, block = page.Block(height or ROW, "row")
            -- keys: the settings its controls change (read by the tests);
            -- settings: their adapters, for Changed.
            local row = { frame = frame, label = label, detail = detail, controls = {}, keys = {}, settings = {}, part = part,
                block = block, group = group, keepsPart = options.tipKeepsPart == true, tagsRow = options.tipTagsRow == true }
            page.rows[rowKey] = row
            page.list[#page.list + 1] = row
            block.row = row
            if fine and group and group.fine then
                block.fine = true
                group.fine[#group.fine + 1] = row
            end
            local point = function(over, own, name) page.Point(over and row or nil, own, name) end
            -- A pinned heading's row (kit 17) sits on the gold wash.
            if group and group.pinned then row.wash, row.bar = Wash(frame) end
            -- Under a heading inside another the name strip sits in with it,
            -- its right edge kept (kit 18).
            local base = IndentOf(group)
            row.name = Strip(frame, NAME_X + base, -2, NAME_W - base, label)
            -- row:Indent(px) (kit 12, GANG secret's crowd control kinds): the
            -- name strip starts px further in, its right edge kept.
            function row:Indent(px)
                row.name:ClearAllPoints()
                row.name:SetPoint("TOPLEFT", NAME_X + base + px, -2)
                row.name:SetSize(NAME_W - base - px, 22)
                row.indent = px
                return row
            end
            NoWrap(row.name.label)
            -- options.tag(label, page) (kit 7, Forever Enemy Buffs' Game
            -- code, Addon and Both): nil, or { tag, color, line }, a word at
            -- the right of the name strip and a line in every tooltip of the
            -- row (row.source).
            if options.tag then
                local source = options.tag(label, page)
                if type(source) == "table" and source.tag then
                    row.source = source
                    Tag(row.name, source.tag, source.color or GREY)
                end
            end
            Tooltip(row.name, label, detail, point, row)
            return Controls(row, frame, -2)
        end

        -- Forever Settings' search (as Forever Settings 0.4.0's own page).
        -- Its window hands the page the lower-case words typed in its search
        -- box, less those in the page's name: Count says how many settings
        -- hold every word, Show draws only those rows under their headings
        -- (nil draws the whole page again). A row is found by what it draws
        -- (its name, value or status), its tooltip and its heading's title,
        -- so a heading's title brings all its rows; another block goes with
        -- the row before it, and the header waits. A host is not searched.
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
            -- wholeOf[heading] (kit 18, Forever Skin's, ForeverSkin/Settings.lua
            -- 1545-1561): its title, or that of a heading it sits in, holds
            -- every word, so all its rows show. whole is the block's heading's;
            -- a block under no heading keeps the last heading's, as before.
            local set, count, wholeOf, last, running = {}, 0, {}, false, false
            for _, block in ipairs(page.blocks) do
                local titles = {}
                local this = block.group
                while this do
                    titles[#titles + 1] = this.title or ""
                    -- Kit 20: and its tag, drawn after the title.
                    if this.blizzard then titles[#titles + 1] = this.blizzard end
                    this = this.parent
                end
                local heading = table.concat(titles, "\n")
                local whole = running
                if block.group ~= nil then whole = wholeOf[block.group] == true end
                if block.heading then
                    local own = block.heading
                    wholeOf[own] = (own.parent ~= nil and wholeOf[own.parent] == true)
                        or Holds((own.title or "") .. (own.blizzard and ("\n" .. own.blizzard) or ""), words)
                    running = wholeOf[own]
                    last = running
                elseif block.topic then
                    last = whole
                elseif block.empty or block.filtered then
                    -- Never shown, so never found or counted (kit 15).
                    last = false
                elseif block.row then
                    -- A detail that is fn() (a tooltip that changes) is not
                    -- searched.
                    local detail = block.row.detail
                    -- options.searchDetails (kit 12, GANG secret): a detail
                    -- that is fn() is read for the search too.
                    if type(detail) == "function" and options.searchDetails then detail = detail() end
                    local parts = Drawn(block.frame, { type(detail) == "string" and detail or "", heading })
                    -- A row of two is found by its second control's own
                    -- tooltip too (row:Tip).
                    for _, control in ipairs(block.row.controls or {}) do
                        local tip = control.tip
                        if type(tip) == "table" then
                            parts[#parts + 1] = tip.title or ""
                            parts[#parts + 1] = type(tip.detail) == "string" and tip.detail or ""
                        end
                    end
                    last = whole or Holds(table.concat(parts, "\n"), words)
                    -- The Move row is how boxes move: shown, never counted
                    -- (kit 11).
                    if block.move then last = false end
                    if last then count = count + 1 end
                elseif block.ticks and block.withRow then
                    -- Ticks that belong to a row (kit 14) go with it.
                    last = set[block.withRow] == true
                elseif block.ticks then
                    -- Tick boxes are searched box by box, each one a
                    -- setting; the block shows whole when one matches.
                    last = false
                    for _, entry in ipairs(block.ticks) do
                        local detail = type(entry.detail) == "string" and entry.detail or ""
                        if whole or Holds(table.concat({ entry.title or entry.label or "", detail, heading }, "\n"), words) then
                            last = true
                            count = count + 1
                        end
                    end
                end
                if last then
                    set[block] = true
                    -- Kit 18: and every heading it sits in.
                    local owner = block.group
                    while owner do
                        set[owner.block] = true
                        owner = owner.parent
                    end
                end
            end
            -- A How to use topic shows whenever a note under it does.
            local topic
            for _, block in ipairs(page.blocks) do
                if block.topic then topic = block
                elseif block.heading then topic = nil
                elseif topic and set[block] then set[topic] = true end
            end
            -- Column titles show whenever a row under them in their heading
            -- does (kit 11).
            for index, block in ipairs(page.blocks) do
                if block.columns then
                    for next = index + 1, #page.blocks do
                        local after = page.blocks[next]
                        if after.group ~= block.group or after.columns then break end
                        if (after.row or after.ticks) and set[after] then set[block] = true; break end
                    end
                end
            end
            -- A shared preview shows with a row of a heading that shares it
            -- (page.Share), its own heading too; not with one that shares
            -- it for pointing only (kit 19).
            for _, block in ipairs(page.blocks) do
                local owner = block.group
                local preview = block.row and set[block] and owner and not owner.pointOnly and owner.preview
                if preview and preview.block and not set[preview.block] then
                    set[preview.block] = true
                    if preview.block.group then set[preview.block.group.block] = true end
                end
            end
            -- A picker steering blocks of its own (kit 15) shows with any
            -- of them.
            for _, block in ipairs(page.blocks) do
                if block.railed and not set[block] then
                    for _, member in ipairs(block.railed() or {}) do
                        if set[member] then
                            set[block] = true
                            if block.group then set[block.group.block] = true end
                            break
                        end
                    end
                end
            end
            -- A preview shows whenever a row under its heading does; so does
            -- an addon's own block marked withRows (kit 19, Forever Combat
            -- Text's preset tiles).
            for _, block in ipairs(page.blocks) do
                if (block.preview or block.picker or block.withRows) and not block.railed and not set[block] and block.group then
                    for _, member in ipairs(block.group.members) do
                        if (member.row or member.ticks) and set[member] then
                            set[block] = true
                            set[block.group.block] = true
                            break
                        end
                    end
                end
            end
            return set, count
        end
        -- A host answers too with host.search (kit 5, Square Forever
        -- Minimap's panel), keeping its scroll where it is.
        if not host or host.search then
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
                    -- page.onSearch(words) (kit 18, Forever Skin's New windows
                    -- box opens Pick... while a search names a window,
                    -- ForeverSkin/Settings.lua 2429-2439): when the page sets
                    -- it, told each search's words (nil when it ends) before
                    -- the layout, so an addon block can open for it.
                    if page.onSearch then page.onSearch(found and words or nil) end
                    if scroll and not host then scroll:SetVerticalScroll(0) end
                    page.Layout()
                    page.Refresh()
                    return count
                end,
            }
        end

        -- A page opens on its Settings tab; the last heading's More line is
        -- made here when no How to use came after it.
        function page.Shown()
            CloseMore()
            -- Kit 18: a page that shows may sit at a new scale (another
            -- window, another parent): every edge is checked.
            Kit.RefreshEdges()
            page.tab = NextTab()
            page.Layout()
            page.Refresh()
        end
        if not host then panel:SetScript("OnShow", page.Shown) end
        if host and host.shownBy then host.shownBy:HookScript("OnShow", page.Shown) end
        return page
    end
    return kit
end
