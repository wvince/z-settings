-- The workspace's save guard: what an addon does when its SavedVariables
-- table was written by a different addon that uses the same folder and save
-- name (Morpster's Forever Combat Text, five ForeverThreats, a Forever Bank and
-- a Forever Cooldowns on CurseForge, found 31 October 2026). The user's
-- choices, 1 November 2026 (https://claude.ai/artifact/RJEkSzhnoCmgwNJCCPZRfo):
-- our addon comes first and starts on its own defaults, a popup says so once,
-- and the other addon's table is kept, one copy, until the player forgets it
-- or puts it back. The master is tools/save-guard/SaveGuard.lua. Each addon
-- keeps an identical copy at its root, listed in its TOC before the file that
-- loads its settings. Change only the master, test it with
--   lua5.1 tools/save-guard/tests/run.lua
-- and copy it out with tools/save-guard/Sync-SaveGuard.ps1.
--
-- How a save is read:
--   nil or {}            a first install: load(nil)
--   tagged ours          savedBy == "Tarolg": the addon's own rules, as before
--                        (older migrates; newer or damaged pauses with the
--                        original intact). savedBy and setAside are lifted
--                        out while load runs, so its checks never see them.
--   untagged, ours       a save from before the tag: a whole-number schema
--                        from 1 to the current one (or legacy(saved) true
--                        for a save from before schemas) that load accepts,
--                        tried on a copy. It is tagged from now on.
--   anything else        another addon's: load(nil), and the table goes to
--                        db.setAside = { at = time(), data = <it> }. Every
--                        version from this kit on tags its save, so an
--                        untagged schema above ours is not ours.
--
-- Calls:
--   ns.SaveGuard.Load(saved, options) -> db, why, foreign
--       options.schema   the addon's current schema (number)
--       options.load     function(t) -> db or nil, why: the addon's own
--                        loader; t is nil for a first install
--       options.legacy   optional function(t) -> true when an untagged table
--                        with no schema is an old save of ours
--       db is tagged; nil with why when load refused (pause, as before).
--       foreign is true when another addon's table was set aside just now.
--   ns.SaveGuard.SetAside(db) -> { at, data } or nil   the copy kept
--   ns.SaveGuard.Forget(db)                            drops the copy
--   ns.SaveGuard.PutBack(db) -> table or nil           the other addon's
--       table exactly as it was; the caller assigns it to the global and
--       pauses itself for the session, so the save written at logout is it.
--   ns.SaveGuard.Heading(page, { kit, title, roots }) -> heading   the
--       settings page's Old settings heading with Put back and Forget, shown
--       while a copy is kept (below, before Guard.Notice)
--   ns.SaveGuard.Day(at) -> "1 November 2026"
--   ns.SaveGuard.Notice(title, where)   the popup, once, at the next
--       PLAYER_ENTERING_WORLD (or now if the world is already shown); title
--       is the addon's name as players see it, where the settings path that
--       holds Put back and Forget.

local _, ns = ...
local Guard = {}
ns.SaveGuard = Guard

local TAG = "Tarolg"
Guard.TAG = TAG

local function Copy(value)
    if type(value) ~= "table" then return value end
    local out = {}
    for key, item in pairs(value) do out[Copy(key)] = Copy(item) end
    return out
end

local function KnownSchema(value, current)
    return type(value) == "number" and value == math.floor(value) and value >= 1 and value <= current
end

local function ValidAside(aside)
    if type(aside) == "table" and type(aside.at) == "number" and aside.data ~= nil then return aside end
    return nil
end

local function Tag(db, aside)
    db.savedBy = TAG
    db.setAside = aside
    return db
end

function Guard.Load(saved, options)
    local load, current = options.load, options.schema
    if saved == nil or (type(saved) == "table" and next(saved) == nil) then
        local db, why = load(nil)
        if not db then return nil, why end
        return Tag(db, nil)
    end
    if type(saved) == "table" and saved.savedBy == TAG then
        local aside = saved.setAside
        saved.savedBy, saved.setAside = nil, nil
        local db, why = load(saved)
        -- A loader that returns a new table, or refuses, leaves the original
        -- as it was (an addon with two saves may still refuse the other).
        if db ~= saved then saved.savedBy, saved.setAside = TAG, aside end
        if not db then return nil, why end
        return Tag(db, ValidAside(aside))
    end
    if type(saved) == "table" then
        local ours = KnownSchema(saved.schema, current)
            or (saved.schema == nil and options.legacy ~= nil and options.legacy(saved) == true)
        if ours then
            local db = load(Copy(saved))
            if db then return Tag(db, nil) end
        end
    end
    local db, why = load(nil)
    if not db then return nil, why end
    local now = type(time) == "function" and time() or 0
    return Tag(db, { at = now, data = saved }), nil, true
end

function Guard.SetAside(db)
    return type(db) == "table" and ValidAside(db.setAside) or nil
end

function Guard.Forget(db)
    if type(db) == "table" then db.setAside = nil end
end

function Guard.PutBack(db)
    local aside = Guard.SetAside(db)
    if not aside then return nil end
    db.setAside = nil
    return aside.data
end

-- "1 November 2026", the day a copy was set aside.
local function Day(at)
    if type(date) ~= "function" then return "an earlier day" end
    return tonumber(date("%d", at)) .. date(" %B %Y", at)
end
Guard.Day = Day

-- Two clicks within 5 seconds; the first one says "Click again".
local function TwoClicks(label, action)
    local armed
    return function(self)
        if armed and GetTime() - armed <= 5 then
            armed = nil
            self.label:SetText(label)
            action()
            return
        end
        armed = GetTime()
        self.label:SetText("Click again")
        C_Timer.After(5, function()
            if armed and GetTime() - armed >= 5 then
                armed = nil
                self.label:SetText(label)
            end
        end)
    end
end

-- The settings page's Old settings heading, shown only while a copy is kept
-- or was put back this session (the user's pick A, 1 November 2026). It
-- starts closed (the pages' rule: at most two headings open), its summary
-- dating the copy, and holds two rows, Put back and Forget, each needing a
-- second click. Call it on the addon's main page just before page.Help.
-- options:
--   kit     the page kit (ns.PageKit.New's result): its C1 column
--   title   the addon's name as players see it
--   roots   { { get = fn() -> the live table, or nil while paused,
--             put = fn(data) }, ... }: each save the guard loads; put
--           assigns the save's global
-- Put back hands each copy to its put, so the save written at logout is the
-- other addon's table as it was, and this addon's own settings are no longer
-- saved (it runs on to the end of the session). Forget drops the copies.
-- Returns the heading.
function Guard.Heading(page, options)
    local title, roots, kit = options.title, options.roots, options.kit
    local putBack = false
    local function Kept()
        local first
        for _, root in ipairs(roots) do
            local aside = Guard.SetAside(root.get())
            if aside and (not first or aside.at < first.at) then first = aside end
        end
        return first
    end
    local function Shows() return putBack or Kept() ~= nil end
    local heading = page.Group("Old settings", false, function()
        if putBack then return "put back: they go in at logout" end
        local aside = Kept()
        return aside and ("another addon's, kept from " .. Day(aside.at)) or "none kept"
    end, "The settings another addon named " .. title .. " left in this save before " .. title .. " replaced it.")
    heading.block.when = Shows
    local back = page.Row("Put back", function()
        if putBack then
            return "The other addon's settings go back into the save when you log out, and " .. title
                .. " is not saving its own this session. Replace " .. title .. " with the other addon before you log in"
                .. " again; if " .. title .. " is still installed then, it keeps them aside again."
        end
        local aside = Kept()
        return "Another addon named " .. title .. " left its settings here before " .. title .. " replaced it"
            .. (aside and (", on " .. Day(aside.at)) or "") .. ". They are kept as they were and not used. Put back"
            .. " writes them back into the save at logout, ready for the other addon, and your " .. title
            .. " settings are not saved from then on. Click twice."
    end)
    back:When(Shows)
    local put = back:Button(kit.C1, "Put back", TwoClicks("Put back", function()
        for _, root in ipairs(roots) do
            local data = Guard.PutBack(root.get())
            if data ~= nil then root.put(data) end
        end
        putBack = true
    end))
    local status = back:Status(function() return putBack and "Put back: at logout" or "" end, kit.C1)
    local forget = page.Row("Forget", "Delete the settings the other addon left, for good. Click twice.")
    forget:When(function() return not putBack and Kept() ~= nil end)
    forget:Button(kit.C1, "Forget", TwoClicks("Forget", function()
        for _, root in ipairs(roots) do Guard.Forget(root.get()) end
    end))
    page.OnRefresh(function()
        put:SetShown(not putBack)
        status:SetShown(putBack)
    end)
    return heading
end

local noticeFrame
function Guard.Notice(title, where)
    local key = "FOREVER_SAVE_GUARD_" .. tostring(title):upper():gsub("%W", "_")
    local text = "Another addon named " .. title .. " was installed here before. " .. title
        .. " has replaced it and starts on its own settings.\n\nOne addon per job works best, so if you"
        .. " also use another addon that does the same job, turn it off.\n\nThe old addon's settings are"
        .. " kept. " .. where .. " can put them back or forget them."
    local function Show()
        if not StaticPopupDialogs or not StaticPopup_Show then return end
        StaticPopupDialogs[key] = StaticPopupDialogs[key] or {
            text = text, button1 = rawget(_G, "OKAY") or "OK", timeout = 0, whileDead = true, hideOnEscape = true,
            showAlert = true, preferredIndex = 3,
        }
        StaticPopup_Show(key)
    end
    if IsPlayerInWorld and IsPlayerInWorld() then Show() return end
    noticeFrame = noticeFrame or CreateFrame("Frame")
    noticeFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    noticeFrame:SetScript("OnEvent", function(self)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        Show()
    end)
end
