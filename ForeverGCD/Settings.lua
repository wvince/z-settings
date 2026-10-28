local _, ns = ...
-- Options -> AddOns -> Forever GCD: one page in the workspace's row style.
-- Every setting is one row: its name on the left and its control beside it
-- (On/Off, < Value >, or a slider with step arrows and a reset arrow);
-- details live in the tooltips. Rows sit under headings that open and
-- close, with their state beside them. The Move panel at the top moves the
-- target bar; How to use is its own tab. The page answers Forever Settings'
-- search (panel.ForeverSettingsSearch).
-- 0.6.0: the page is built by the workspace's page kit (PageKit.lua, master
-- in tools/page-kit), the toolkit this file carried until then. Without the
-- file there is no settings page: a line in chat says so, the flashes work,
-- and opening settings (the command, the bar's gear) says so again.

if not ns.PageKit then
    local MISSING = "Forever GCD: PageKit.lua is missing, so there is no settings page; reinstall Forever GCD."
    function ns.CreateSettings() print(MISSING) end
    function ns.OpenSettings() print(MISSING) end
    return
end

-- What is this addon's own: its settings, their defaults, limits and
-- choices, and where a heading's open state is saved (by its title, its
-- More line's as "<title> / more", as before the kit). Three control
-- columns of 110 px, one per side.
local Kit = ns.PageKit.New({
    get = function(key) return ns.Get(key) end,
    set = function(key, value) ns.Set(key, value) end,
    default = function(key) return ns.Default(key) end,
    limits = ns.Limits,
    choices = function(key) return ns.Choices[key] end,
    groupOpen = function(key) return ns.GroupOpen(key) end,
    setGroupOpen = function(key, open) ns.SetGroupOpen(key, open) end,
    columns = { nameW = 150, c1 = 170, c2 = 284, c3 = 398, cw = 110 },
})
-- Every page by name, each with its rows by name.
ns.SettingsPages = Kit.pages
local Text = Kit.Text
local GOLD, GREY, GREY_TEXT = Kit.GOLD, Kit.GREY, Kit.GREY_TEXT
local AMBER_TEXT = "|cffff9f1a"
local NAME_X, NAME_W, C1, C2, FULL = Kit.NAME_X, Kit.NAME_W, Kit.C1, Kit.C2, Kit.FULL
-- A row with one control spans the first two columns.
local SINGLE = Kit.WIDE

local POSITIONS = ns.POSITION_LABELS

local function Px(value) return value .. " px" end
local function Tenths(value) return string.format("%.1f s", value / 10) end

local function Build()
    local page = Kit.NewPage("Forever GCD")
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
        -- On the How to use tab too; without the preview kit the page draws
        -- its own row below.
        bothTabs = true,
        fallback = false,
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
    -- 0.6.1: Fade shares Up or down's row (AGENTS.md "Two settings, one
    -- row"); the switch names itself, since the slider beside it is not its
    -- amount.
    local fade = page.Row("Fade and up/down", "Fade: the icon fades with its plate, so on a plate the game shows faded (far away, or behind a wall) it is faded as much.")
    fade:Toggle(C1, "fade", nil, "Fade")
    fade:Tip(fade:Slider(C2, "lift", 1, " px", SINGLE),
        "Up or down", "Moves the icon up (above 0) or down (below 0) from where Position puts it (-60 to 60 px), to line it up with plates from another addon that draws its health bar higher or lower than Blizzard's. Show on screen plays samples on every plate up.")

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
        set = function(unlocked) SetBarLocked(not unlocked) end, default = false }, nil, "Unlocked")
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
