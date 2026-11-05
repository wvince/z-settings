local _, ns = ...
local Public, Yes = ns.Public, ns.Yes

-- A spot (Flash.lua) on every enemy nameplate: above it, or at its left or
-- right. Spots are attached on NAME_PLATE_UNIT_ADDED and released
-- synchronously on NAME_PLATE_UNIT_REMOVED: the client reissues the same
-- unit token to another plate within the frame, so a deferred release would
-- draw a flash on the wrong enemy.
--
-- A plate whose side changes while it is up (a duel starting or ending: a
-- player of your own faction turns hostile) keeps its plate and token;
-- UNIT_FACTION for that plate or the player, and DUEL_FINISHED, ask every
-- plate again (as Forever Cast 0.15.5 does).
--
-- Your duel opponent: the one plate that passes ns.Opponent, or your target
-- when several do. That plate's spot gets your new debuffs (Flash.lua).

local records, pool = {}, {}
local present = {}  -- every plate up, enemy or not
local opponent      -- the opponent's plate token, or nil
local events = CreateFrame("Frame")
local enabled = false
-- Show on screen: samples on every plate up, enemy or not, until then.
local previewUntil = 0
local SAMPLE_GAP = 0.4
local ticker = CreateFrame("Frame")
local function Previewing() return GetTime() < previewUntil end

-- A plate's strata and level can be secret (GetFrameStrata gained
-- SecretReturnsForAspect FrameStrata in 1.60.1.70291, GetFrameLevel has
-- FrameLevel; SimpleFrameAPIDocumentation.lua); then the spot keeps its own.
local function MatchLayer(frame, plate)
    local strata, level = plate:GetFrameStrata(), plate:GetFrameLevel()
    if Public(strata) and type(strata) == "string" then frame:SetFrameStrata(strata) end
    if Public(level) and type(level) == "number" then frame:SetFrameLevel(level + 5) end
end

-- What a spot lines up with: the plate's health bar, and at the right the
-- level badge beside it (UnitFrame.HealthBarsContainer.healthBar and
-- UnitFrame.PlayerLevelDiffFrame, Blizzard_NamePlates.xml and
-- Camelot/Blizzard_NamePlateLevelFrame.xml on 1.60.1.70425). Missing ones
-- fall back to the plate itself, so a changed plate only moves the icon.
-- At the left (0.6.3) the spot hangs from the bar's container, the bar area
-- as Blizzard lays it out: the bar fills it (Blizzard_NamePlateUnitFrame.lua
-- UpdateAnchors on 1.60.1.70532; Classic style insets the bar 3.5 px inside
-- its border), so the icon stays put while clearing whatever a plate addon
-- draws inside it at the bar's left end (a class icon).
local function Region(object)
    if type(object) == "table" and type(object.GetObjectType) == "function" then return object end
end
-- The badge counts only while it has a place: a plate addon that clears
-- its points would take a Right icon to the middle of the plate (a player's
-- report, 20 October 2026); then the bar's own edge is used. Where the badge
-- hangs cannot be read: on 1.60.1.70450 (22 October 2026, desktop) GCD
-- 0.4.1's GetPoint on it errored ("Can't measure restricted regions") and
-- no icon was placed, while GetNumPoints read plainly.
local function Placed(level)
    local count = level:GetNumPoints()
    if not Public(count) or type(count) ~= "number" then return true end
    return count > 0
end
local function Anchors(plate)
    local unitFrame = Region(plate.UnitFrame)
    local container = unitFrame and Region(unitFrame.HealthBarsContainer)
    local health = container and (Region(container.healthBar) or container)
    local level = unitFrame and Region(unitFrame.PlayerLevelDiffFrame)
    if level and health and not Placed(level) then level = nil end
    return health or plate, level or health or plate, container or health or plate
end

-- Puts a spot's frame above its plate's health bar, or at its left or
-- right with the icon centred on the bar, so it sits beside the plate.
-- Up/down then nudges it, for plate addons that draw their own bar away
-- from Blizzard's (a player on Luna's plates, 22 October 2026).
local function Place(frame, plate)
    local gap, position, size = ns.Get("offset"), ns.Get("position"), ns.Get("size")
    local lift = ns.Get("lift") or 0
    local health, right, left = Anchors(plate)
    frame:ClearAllPoints()
    if position == "left" then
        frame:SetPoint("TOPRIGHT", left, "LEFT", -gap, size / 2 + lift)
    elseif position == "right" then
        frame:SetPoint("TOPLEFT", right, "RIGHT", gap, size / 2 + lift)
    else
        frame:SetPoint("BOTTOM", health, "TOP", 0, gap + lift)
    end
end
ns.PlaceSpot = Place

-- 0.6.1 Fade (a player's request): the game fades a plate's drawing below
-- the plate frame the spot hangs from (far away, behind a wall), so the
-- spot alone stayed at full opacity. Its alpha becomes the health bar's
-- drawn opacity over the plate's, capped at 1, so it ends up drawn as the
-- bar is. A secret answer (both are SecretReturnsForAspect Alpha,
-- SimpleFrameAPIDocumentation.lua), 0 or less (a plate addon hiding
-- Blizzard's plate by its alpha), or no bar of its own gives 1. No event
-- says a plate faded, so one watcher looks every 0.05 s, only while a spot
-- is attached. Nothing here measures where a plate's parts sit (0.4.1).
-- GetEffectiveAlpha also has RequiresScriptObjectAlphaAccess, which
-- returns with an error where access is denied; Forever Diagnostics 0.22
-- read it on plates' unit frames in battlegrounds without one
-- (1.60.1.70374). Should it error, `reading` stays set: the next tick
-- turns Fade off for the session and says so once, instead of an error
-- every 0.05 s.
local FADE_EVERY = 0.05
local fader = CreateFrame("Frame")
local fadeWait, reading, fadeBroken = 0, false, false
local function Broken()
    if reading then
        reading, fadeBroken = false, true
        fader:SetScript("OnUpdate", nil)
        print("Forever GCD: this build would not let the addon read a nameplate's opacity, so icons stay at full opacity until you reload (Fade).")
    end
    return fadeBroken
end
local function FadeAlpha(record)
    if Broken() or ns.Get("fade") ~= true or not record.plate then return 1 end
    local health = Anchors(record.plate)
    if health == record.plate then return 1 end
    reading = true
    local drawn, plateDrawn = health:GetEffectiveAlpha(), record.plate:GetEffectiveAlpha()
    reading = false
    if not ns.Number(drawn) or not ns.Number(plateDrawn) or drawn <= 0 or plateDrawn <= 0 then return 1 end
    return math.min(1, drawn / plateDrawn)
end
local function Fade(record) record.spot.frame:SetAlpha(FadeAlpha(record)) end
local function FadeAll()
    for _, record in pairs(records) do Fade(record) end
end
local function FadeTick(_, elapsed)
    if Broken() then return FadeAll() end
    fadeWait = fadeWait - (elapsed or 0)
    if fadeWait > 0 then return end
    fadeWait = FADE_EVERY
    FadeAll()
end
-- The watcher runs only while a spot is attached and Fade is on.
local function Watch()
    local wanted = not Broken() and ns.Get("fade") == true and next(records) ~= nil
    if wanted and not fader:GetScript("OnUpdate") then
        fadeWait = FADE_EVERY
        fader:SetScript("OnUpdate", FadeTick)
    elseif not wanted and fader:GetScript("OnUpdate") then
        fader:SetScript("OnUpdate", nil)
    end
end
-- For the tests: whether the watcher runs.
function ns.FadeWatching() return fader:GetScript("OnUpdate") ~= nil end

local function Detach(unit)
    local record = records[unit]
    if not record then return end
    records[unit] = nil
    record.spot:Stop()
    record.spot.frame:SetAlpha(1)
    record.spot.frame:Hide()
    record.spot.frame:ClearAllPoints()
    record.spot.frame:SetParent(UIParent)
    record.plate = nil
    pool[#pool + 1] = record
    Watch()
end

local function Attach(unit)
    if records[unit] then Detach(unit) end
    if ns.Get("plates") ~= true or not (ns.Hostile(unit) or Previewing()) then return end
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate then return end
    local record = table.remove(pool)
    if not record then record = { spot = ns.NewSpot(UIParent, ns.Get("size")) } end
    record.plate, record.unit = plate, unit
    local frame = record.spot.frame
    frame:SetParent(plate)
    MatchLayer(frame, plate)
    record.spot:Style(ns.Get("size"))
    Place(frame, plate)
    frame:Show()
    records[unit] = record
    Watch()
    Fade(record)
    record.spot:Follow(unit, unit == opponent, true)
    -- Once more on the next frame: a plate addon that moves the level badge
    -- on the same NAME_PLATE_UNIT_ADDED may run after this one.
    if C_Timer and C_Timer.After then
        C_Timer.After(0, function()
            if records[unit] == record and record.plate == plate then Place(frame, plate) end
        end)
    end
end

-- Which plate is your opponent's, then every spot told whether it is.
local function FindOpponent()
    local found, count = nil, 0
    for unit in pairs(present) do
        if ns.Opponent(unit) then
            count = count + 1
            found = found or unit
            local targeted = UnitIsUnit(unit, "target")
            if Public(targeted) and targeted == true then
                found, count = unit, 1
                break
            end
        end
    end
    if count ~= 1 then found = nil end
    if found == opponent then return end
    opponent = found
    for unit, record in pairs(records) do record.spot:Follow(unit, unit == opponent, false) end
end

-- A plate up, asked again: it gets or loses its spot.
local function Recheck(unit)
    if not present[unit] then return end
    local wanted = ns.Get("plates") == true and (ns.Hostile(unit) or Previewing())
    if wanted and not records[unit] then
        Attach(unit)
    elseif not wanted and records[unit] then
        Detach(unit)
    elseif records[unit] then
        records[unit].spot:Follow(unit, unit == opponent, false)
    end
end
local function RecheckAll()
    for unit in pairs(present) do Recheck(unit) end
    FindOpponent()
end

events:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_FACTION" then
        -- unitTarget (UnitDocumentation): a plate's own token, or the player
        -- or a hidden one, which may change how every plate stands.
        if Public(unit) and type(unit) == "string" and present[unit] then
            Recheck(unit)
            FindOpponent()
        elseif not Public(unit) or unit == "player" then
            RecheckAll()
        end
        return
    elseif event == "DUEL_FINISHED" or event == "PLAYER_TARGET_CHANGED" then
        RecheckAll()
        return
    end
    if not Public(unit) or type(unit) ~= "string" then return end
    if event == "NAME_PLATE_UNIT_ADDED" then
        present[unit] = true
        Attach(unit)
        FindOpponent()
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        present[unit] = nil
        Detach(unit)
        FindOpponent()
    end
end)

local function Enable(on)
    if on and not enabled then
        for _, event in ipairs({ "NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "UNIT_FACTION", "DUEL_FINISHED",
            "PLAYER_TARGET_CHANGED" }) do
            events:RegisterEvent(event)
        end
        enabled = true
        -- Plates already on screen (a /reload, or Plates turned on).
        for index = 1, 40 do
            local token = "nameplate" .. index
            if Yes(UnitExists(token)) then present[token] = true end
        end
        RecheckAll()
    elseif not on and enabled then
        events:UnregisterAllEvents()
        enabled = false
        ticker:SetScript("OnUpdate", nil)
        previewUntil = 0
        for unit in pairs(records) do Detach(unit) end
        for unit in pairs(present) do present[unit] = nil end
        opponent = nil
    end
end

-- Show on screen and /fgcd preview: each route's sample flashes in turn on
-- every plate up for this many seconds, friendly ones too so there is
-- something to see in town. A friendly plate's spot follows nothing live and
-- goes when the samples end. Returns how many plates show them.
local sampleIndex, nextSampleAt = 0, 0
local function StopSamples()
    ticker:SetScript("OnUpdate", nil)
    previewUntil = 0
    for _, record in pairs(records) do
        record.spot.cast.flash:Stop()
        record.spot.cast.button:SetAlpha(0)
    end
    if enabled then RecheckAll() end
end
local function SampleTick()
    local now = GetTime()
    if now >= previewUntil then return StopSamples() end
    if now < nextSampleAt then return end
    sampleIndex = sampleIndex % #ns.SAMPLES + 1
    local sample = ns.SampleEntry(ns.SAMPLES[sampleIndex])
    for _, record in pairs(records) do record.spot:Sample(sample) end
    nextSampleAt = now + ns.FlashLength() + SAMPLE_GAP
end
function ns.PlayPlates(seconds)
    if not enabled then return 0 end
    previewUntil = GetTime() + (seconds or 20)
    nextSampleAt, sampleIndex = 0, 0
    RecheckAll()
    ticker:SetScript("OnUpdate", SampleTick)
    SampleTick()
    return ns.PlateCount()
end

function ns.PlateCount()
    local count = 0
    for _ in pairs(records) do count = count + 1 end
    return count
end
function ns.OpponentShown() return opponent ~= nil end
-- The record of a plate, for the tests.
function ns.PlateRecord(unit) return records[unit] end

-- After settings changed: plates on or off, what flashes, the place and size.
local FOLLOW_KEYS = { casts = true, buffs = true, debuffs = true }
local PLACE_KEYS = { position = true, offset = true, lift = true, size = true, name = true, nameSize = true, tenths = true }
function ns.PlatesApply(keys)
    for _, key in ipairs(keys) do
        if key == "plates" then
            Enable(ns.Get("plates") == true)
        elseif FOLLOW_KEYS[key] then
            for unit, record in pairs(records) do record.spot:Follow(unit, unit == opponent, false) end
        elseif key == "fade" then
            FadeAll()
            Watch()
        elseif PLACE_KEYS[key] then
            for _, record in pairs(records) do
                record.spot:Style(ns.Get("size"))
                Place(record.spot.frame, record.plate)
            end
        end
    end
end

function ns.StartPlates()
    if not ns.FlashAvailable() then
        print("Forever GCD: this build has no Blizzard aura container (Blizzard_AuraContainer), so only casts can flash, not buffs or debuffs.")
    end
    Enable(ns.Get("plates") == true)
end
