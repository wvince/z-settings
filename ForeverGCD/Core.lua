local addonName, ns = ...
-- Forever GCD: saved settings, the slash command and start-up. Flash.lua
-- draws one place's flashes, Plates.lua puts one on every enemy nameplate,
-- Bar.lua is the optional target bar, Settings.lua the options page.
-- Every chat line here answers something the player did or reports that the
-- addon cannot work, so all of them always print and there is no Chat
-- messages setting (AGENTS.md, "Addon implementation rules").

local events = CreateFrame("Frame")
local SCHEMA = 1

-- Plain values only: a secret value is never compared or kept.
function ns.Public(value) return not issecretvalue(value) end
function ns.Yes(value) return not issecretvalue(value) and value == true end
function ns.Number(value) return not issecretvalue(value) and type(value) == "number" end
function ns.Text(value) return not issecretvalue(value) and type(value) == "string" end

-- Where the icon sits on a plate.
ns.POSITIONS = { "left", "right", "above" }
ns.POSITION_LABELS = { above = "Above", left = "Left", right = "Right" }

local defaults = { schema = SCHEMA,
    -- What flashes: an enemy's casts and instants (their hidden spell drawn
    -- by name and icon), their new buffs, and in duels your new debuffs on
    -- your opponent.
    casts = true, buffs = true, debuffs = true,
    -- The plates: on or off, where the icon sits, its size and the gap.
    plates = true, position = "left", size = 45, offset = 4,
    -- The look: the spell's name under the icon, its text size, and how long
    -- a flash stays, in tenths of a second (1.5 s, a global cooldown).
    name = true, nameSize = 10, tenths = 15,
    -- The target bar: off by default, locked, its own icon size, and its top
    -- left corner in pixels from the middle of the screen.
    bar = false, barLocked = true, barSize = 45, barX = -20, barY = -120 }
-- Whole numbers only, so a saved value always matches a slider notch.
local limits = { size = { 16, 64 }, offset = { -20, 60 }, nameSize = { 8, 20 }, tenths = { 5, 40 },
    barSize = { 16, 64 }, barX = { -4000, 4000 }, barY = { -4000, 4000 } }
local choices = { position = ns.POSITIONS }
ns.Limits, ns.Choices = limits, choices
ns.Version = C_AddOns.GetAddOnMetadata(addonName, "Version") or "?"
local db ---@type table<string, any>
local started = false

local function Valid(key, value)
    if type(value) ~= type(defaults[key]) then return false end
    if key == "schema" then return value == SCHEMA end
    if choices[key] then
        for _, option in ipairs(choices[key]) do
            if option == value then return true end
        end
        return false
    end
    if type(value) ~= "number" then return true end
    if value ~= value or value == math.huge or value == -math.huge or value ~= math.floor(value) then return false end
    if limits[key] then return value >= limits[key][1] and value <= limits[key][2] end
    return true
end

-- Validate everything before changing anything, so a rejected save is left
-- exactly as it was. Newer schemas are never touched; a missing key gets its
-- default.
local function Migrate(saved)
    if type(saved) ~= "table" or saved.schema ~= SCHEMA then return false end
    for key in pairs(defaults) do
        if saved[key] ~= nil and not Valid(key, saved[key]) then return false end
    end
    for key, value in pairs(defaults) do
        if saved[key] == nil then saved[key] = value end
    end
    return true
end

-- openGroups is a derived UI cache: string keys, boolean values, at most 200.
local MAX_OPEN_GROUPS = 200
local function ValidOpenGroups(groups)
    if type(groups) ~= "table" then return false end
    local count = 0
    for key, open in pairs(groups) do
        count = count + 1
        if type(key) ~= "string" or type(open) ~= "boolean" or count > MAX_OPEN_GROUPS then return false end
    end
    return true
end

function ns.Get(key) return db and db[key] end
-- The one way a setting changes: the settings page, the bar's gear and the
-- slash command call it, and ns.Apply brings every plate and the bar in line.
function ns.Set(key, value)
    if not db or key == "schema" or defaults[key] == nil or not Valid(key, value) then return end
    if db[key] == value then return end
    db[key] = value
    ns.ApplyMany({ key })
end
function ns.Default(key) return defaults[key] end
function ns.Seconds() return (db and db.tenths or defaults.tenths) / 10 end

-- Several settings at once (the bar's place), each checked as ns.Set checks
-- it, applied in one pass.
function ns.SetMany(values)
    if not db then return end
    local changed = {}
    for key, value in pairs(values) do
        if key ~= "schema" and defaults[key] ~= nil and Valid(key, value) and db[key] ~= value then
            db[key] = value
            changed[#changed + 1] = key
        end
    end
    if #changed > 0 then ns.ApplyMany(changed) end
end
function ns.ResetBarPosition() ns.SetMany({ barX = defaults.barX, barY = defaults.barY }) end

-- After settings changed: the flashes' look, every plate and the bar.
function ns.ApplyMany(keys)
    if ns.FlashApply then ns.FlashApply(keys) end
    if ns.PlatesApply then ns.PlatesApply(keys) end
    if ns.BarApply then ns.BarApply(keys) end
    if ns.RefreshSettings then ns.RefreshSettings() end
end

-- A settings heading's saved state: true, false, or nil when never clicked.
function ns.GroupOpen(title)
    local groups = db and db.openGroups
    if type(groups) ~= "table" then return nil end
    return groups[title]
end
function ns.SetGroupOpen(title, open)
    local groups = db and db.openGroups
    if type(groups) ~= "table" or type(title) ~= "string" then return end
    if groups[title] == nil then
        local count = 0
        for _ in pairs(groups) do count = count + 1 end
        if count >= MAX_OPEN_GROUPS then return end
    end
    groups[title] = open == true
end

-- The settings header and /fgcd status.
function ns.StatusText()
    if not ns.FlashAvailable() then
        return "this build has no Blizzard aura container, so only casts can flash, not buffs or debuffs"
    end
    local count = ns.PlateCount and ns.PlateCount() or 0
    local words = count .. (count == 1 and " enemy plate" or " enemy plates") .. " watched"
    if ns.Get("plates") ~= true then words = "plates off" end
    if ns.OpponentShown and ns.OpponentShown() then words = words .. " · duel opponent found" end
    return words
end

-- Every command, for /fgcd and /fgcd help. How to use lists the same.
ns.COMMANDS = {
    { "", "open settings and list these commands" },
    { "status", "say how many enemy plates are watched" },
    { "unlock", "turn the target bar on and unlock it to move" },
    { "lock", "lock the target bar" },
    { "preview", "play sample flashes on nameplates and the target bar for 20 seconds" },
    { "options", "open settings" },
    { "help", "list these commands" },
}
-- Show on screen and /fgcd preview: samples on every plate up and the
-- target bar. Returns what was shown, for the chat line.
function ns.PlaySamples(seconds)
    local count = ns.PlayPlates(seconds)
    ns.PlayBar(seconds)
    local where = count == 0 and "the target bar (no nameplates on screen)"
        or (count .. (count == 1 and " nameplate" or " nameplates") .. " and the target bar")
    return "sample flashes on " .. where .. " for " .. seconds .. " seconds."
end

local function PrintHelp()
    print("Forever GCD commands:")
    for _, command in ipairs(ns.COMMANDS) do
        print("/fgcd" .. (command[1] ~= "" and (" " .. command[1]) or "") .. " - " .. command[2])
    end
end

local function Start()
    if started or not db then return end
    started = true
    ns.CreateSettings()
    SLASH_FOREVERGCD1 = "/fgcd"
    SlashCmdList.FOREVERGCD = function(message)
        local command = (type(message) == "string" and message or ""):lower():match("^%s*(%a*)%s*$")
        if command == "" then
            ns.OpenSettings()
            PrintHelp()
        elseif command == "options" then
            ns.OpenSettings()
        elseif command == "status" then
            print("Forever GCD: " .. ns.StatusText())
        elseif command == "unlock" then
            ns.Set("bar", true)
            ns.Set("barLocked", false)
            print("Forever GCD: target bar unlocked. Drag it to move it, drag its corner to resize, right-click it to lock.")
        elseif command == "lock" then
            ns.Set("barLocked", true)
            print("Forever GCD: target bar locked.")
        elseif command == "preview" then
            print("Forever GCD: " .. ns.PlaySamples(20))
        else
            PrintHelp()
        end
    end
    ns.StartPlates()
    ns.StartBar()
end

events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 ~= addonName then return end
        self:UnregisterEvent("ADDON_LOADED")
        if ForeverGCDDB == nil then ForeverGCDDB = { schema = SCHEMA } end
        if not Migrate(ForeverGCDDB) then
            print("Forever GCD: unsupported or invalid settings; original preserved. Paused.")
            return
        end
        -- Headings opened or closed by a click: UI state, not a setting, so a
        -- damaged table is replaced, never a pause.
        if not ValidOpenGroups(ForeverGCDDB.openGroups) then ForeverGCDDB.openGroups = {} end
        db = ForeverGCDDB
    elseif event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")
        -- Our own PCs only: with Forever Diagnostics loaded, the namespace
        -- goes in a dev table our own test tools read. Players never have it.
        local _, dev = C_AddOns.IsAddOnLoaded("ForeverDiagnostics")
        if dev then ForeverDev = ForeverDev or {}; ForeverDev[addonName] = ns end
        Start()
    end
end)
