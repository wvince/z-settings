-- MythicSim addon
--
-- Bridges WoW to mythicsim.com via deep links. The WoW client
-- sandboxes addons away from the network, so we can't POST directly:
-- instead each command composes a URL carrying the data in the query
-- string and prints it as a clickable chat link. The player clicks,
-- their browser opens, and mythicsim.com handles the rest.
--
-- Commands:
--   /mythicsim            - help
--   /mythicsim sim        - link the player's /simc to mythicsim.com
--   /mythicsim group      - link the party/raid roster to a group comparison
--   /mythicsim export     - World of Warcraft: Forever character export (Forever.lua)
--   /mythicsim probe      - client API report (Forever.lua)
--   /mythicsim minimap    - show or hide the minimap button (Minimap.lua)
--
-- Dependencies are optional: the `sim` command prefers the existing
-- Simulationcraft addon's /simc output, falling back to an armory
-- lookup server-side if Simulationcraft isn't installed. `group`
-- ships only names + realms so it never needs the SimC addon.

-- `ns` is the addon-private table shared with Forever.lua, which adds
-- the World of Warcraft: Forever character export on Classic-family
-- clients and reuses the helpers published on it below.
local addonName, ns = ...
local WEB_BASE = "https://mythicsim.com"
ns.WEB_BASE = WEB_BASE
-- The Forever client reports WOW_PROJECT_MAINLINE like retail does (seen on
-- 1.60.1.69913), so the project id cannot tell them apart. The interface
-- number can: Forever is 16001, retail is 120001.
ns.IS_RETAIL = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
    and (select(4, GetBuildInfo()) or 0) >= 100000

local MythicSim = {}
_G.MythicSim = MythicSim

-- --------------------------------------------------------------------
-- URL encoding + JSON serialization
--
-- Pure-Lua implementations so the addon stays dep-free. Roster JSON is
-- small (~1KB for a 20-raid) and only emitted on explicit command, so
-- perf doesn't matter.
-- --------------------------------------------------------------------

local function url_encode(s)
    if s == nil then return "" end
    s = tostring(s)
    -- Encode reserved + non-ASCII bytes. WoW's Lua doesn't have
    -- string.gmatch on the byte level natively for UTF-8; we iterate
    -- bytes and pass through ASCII alphanumerics unchanged.
    local out = {}
    for i = 1, #s do
        local c = s:sub(i, i)
        local b = string.byte(c)
        if (b >= 48 and b <= 57)     -- 0-9
            or (b >= 65 and b <= 90) -- A-Z
            or (b >= 97 and b <= 122) -- a-z
            or c == "-" or c == "_" or c == "." or c == "~" then
            out[#out + 1] = c
        else
            out[#out + 1] = string.format("%%%02X", b)
        end
    end
    return table.concat(out)
end

local function json_string(s)
    -- Minimal JSON string escaper. Handles backslash, quote, control
    -- chars. Player + realm names don't contain the weirder UTF-8
    -- edge cases that would need full RFC coverage; this is good
    -- enough for our payload.
    local escaped = s:gsub("\\", "\\\\"):gsub('"', '\\"')
    return '"' .. escaped .. '"'
end
ns.json_string = json_string

local function json_encode_members(members)
    -- Hand-rolled to avoid pulling in LibJSON. Members array shape:
    -- [{"name":"X","realm":"Y","region":"us","class":"PALADIN","spec":"Retribution"}, ...]
    local parts = {}
    for i = 1, #members do
        local m = members[i]
        local fields = {
            '"name":' .. json_string(m.name),
            '"realm":' .. json_string(m.realm),
            '"region":' .. json_string(m.region or "us"),
        }
        if m.class then
            fields[#fields + 1] = '"class":' .. json_string(m.class)
        end
        if m.spec then
            fields[#fields + 1] = '"spec":' .. json_string(m.spec)
        end
        parts[i] = "{" .. table.concat(fields, ",") .. "}"
    end
    return "[" .. table.concat(parts, ",") .. "]"
end

-- --------------------------------------------------------------------
-- Chat output
--
-- Clickable hyperlinks in the chat frame use WoW's auto-detection: any
-- http:// or https:// string becomes a clickable link that opens the
-- OS browser. We print with a MythicSim prefix so the user can scroll
-- back and find it.
-- --------------------------------------------------------------------

local function print_info(msg)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFA500[MythicSim]|r " .. msg)
    end
end
ns.print_info = print_info

-- --------------------------------------------------------------------
-- Export window
--
-- SimulationCraft-style popup: a floating frame with a pre-selected
-- multi-line edit box containing the link. User hits Ctrl-C (or Cmd-C
-- on Mac) to copy, Esc or the X button to dismiss. Lazy-constructed
-- on first use so there's no cost for sessions that never export.
--
-- The edit box blocks user-typed edits (OnTextChanged restores the
-- original string) so the buffer stays copy-safe even if the user
-- accidentally hits a key while the frame is focused.
-- --------------------------------------------------------------------

local export_frame

local function build_export_frame()
    local f = CreateFrame("Frame", "MythicSimExportFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetFrameStrata("DIALOG")
    f:SetSize(620, 180)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Hide()

    -- Title: the template gives us a TitleBg strip at the top; anchor
    -- our text to it so the header always matches the frame style.
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("CENTER", f.TitleBg, "CENTER", 0, 0)
    title:SetText("MythicSim Export")
    f.titleText = title

    -- Hint text below the title, above the edit box.
    local hint = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    hint:SetPoint("TOPLEFT", 16, -32)
    hint:SetJustifyH("LEFT")
    hint:SetWidth(588)
    f.hint = hint

    local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 16, -72)
    scroll:SetPoint("BOTTOMRIGHT", -36, 16)
    f.scroll = scroll

    local edit = CreateFrame("EditBox", nil, scroll)
    edit:SetMultiLine(true)
    edit:SetFontObject(ChatFontNormal or GameFontNormal)
    edit:SetWidth(scroll:GetWidth())
    edit:SetAutoFocus(false)
    edit:SetCountInvisibleLetters(false)
    edit:SetScript("OnEscapePressed", function() f:Hide() end)
    edit:SetScript("OnTextChanged", function(self)
        -- Snap the text back if the user tries to edit. The text
        -- they see always matches what they'd paste.
        local wanted = self.mythicsimOriginal
        if wanted and self:GetText() ~= wanted then
            self:SetText(wanted)
            self:HighlightText()
        end
    end)
    -- The copy happens on key down, so by key up the clipboard has the
    -- text and the window has done its job.
    edit:SetScript("OnKeyUp", function(_, key)
        if key == "C" and (IsControlKeyDown() or (IsMetaKeyDown and IsMetaKeyDown())) then
            f:Hide()
        end
    end)
    scroll:SetScrollChild(edit)
    f.edit = edit

    return f
end

local LINK_HINT = "Copy the link (Ctrl-C / Cmd-C) and open it in your browser, or paste into Discord's /simgroup."

local function show_export_window(title_text, payload, hint_text)
    if not export_frame then
        export_frame = build_export_frame()
    end
    export_frame.titleText:SetText(title_text or "MythicSim Export")
    export_frame.hint:SetText(hint_text or LINK_HINT)
    export_frame.edit.mythicsimOriginal = payload
    export_frame.edit:SetText(payload)
    export_frame.edit:HighlightText()
    export_frame.edit:SetFocus()
    export_frame:Show()
end
ns.show_export_window = show_export_window

-- --------------------------------------------------------------------
-- Region detection
--
-- GetCurrentRegion() returns a numeric id (1 US, 2 KR, 3 EU, 4 TW, 5 CN).
-- We map to the slug mythicsim.com expects.
-- --------------------------------------------------------------------

local REGION_SLUGS = { [1] = "us", [2] = "kr", [3] = "eu", [4] = "tw", [5] = "cn" }

local function current_region()
    local id = GetCurrentRegion and GetCurrentRegion()
    return REGION_SLUGS[id] or "us"
end

-- --------------------------------------------------------------------
-- /mythicsim sim (placeholder for v1)
--
-- Solo sims live on mythicsim.com today via the existing SimC-addon
-- paste flow. Point users there rather than failing silently; a
-- deep-linked single-character sim is a v2 concern (needs a /sim
-- prefill page server-side).
-- --------------------------------------------------------------------

function MythicSim:CommandSim()
    print_info("Solo sim: paste your /simc output at " .. WEB_BASE .. ".")
    print_info("For raid comparisons, use /mythicsim group.")
end

-- --------------------------------------------------------------------
-- /mythicsim group
--
-- Collects every party/raid member's (name, realm, class, spec) and
-- packs them into a ?roster= query param. Small enough to fit in a
-- URL (a 20-raid runs ~1.5KB URL-encoded).
-- --------------------------------------------------------------------

local function split_name_realm(raw)
    -- WoW returns "Name-Realm" for cross-realm members and bare
    -- "Name" for same-realm. Split on the first '-'; realms can't
    -- contain dashes in their slugged form on the server, but in the
    -- UI name they may have spaces — we preserve whatever the API
    -- returned and let the backend normalize.
    local dash = raw:find("-", 1, true)
    if dash then
        return raw:sub(1, dash - 1), raw:sub(dash + 1)
    end
    return raw, GetRealmName()
end

local function collect_roster()
    local members = {}
    local region = current_region()

    if IsInRaid() then
        local n = GetNumGroupMembers()
        for i = 1, n do
            local raw, _, _, _, _, classFileName = GetRaidRosterInfo(i)
            if raw then
                local name, realm = split_name_realm(raw)
                members[#members + 1] = {
                    name = name,
                    realm = realm,
                    region = region,
                    class = classFileName,
                }
            end
        end
    elseif IsInGroup() then
        -- Party: the player themselves + party1..party4
        local units = { "player", "party1", "party2", "party3", "party4" }
        for _, unit in ipairs(units) do
            if UnitExists(unit) then
                local raw = UnitName(unit)
                local classKey = select(2, UnitClass(unit))
                if raw then
                    local name, realm = split_name_realm(raw)
                    members[#members + 1] = {
                        name = name,
                        realm = realm,
                        region = region,
                        class = classKey,
                    }
                end
            end
        end
    else
        return nil
    end

    return members
end

function MythicSim:CommandGroup()
    local members = collect_roster()
    if not members or #members == 0 then
        print_info("Not in a party or raid. Join a group and run /mythicsim group again.")
        return
    end

    local payload = json_encode_members(members)
    local url = WEB_BASE .. "/group/submit?roster=" .. url_encode(payload)

    -- Popup: pre-selected text you can Ctrl-C straight into Discord
    -- or a browser. The chat line keeps a scroll-back reference in
    -- case the user closes the window before copying.
    show_export_window(
        string.format("MythicSim Group Export (%d raiders)", #members),
        url
    )
    print_info(string.format(
        "Collected %d raiders. Export window opened — Ctrl-C to copy the link.",
        #members
    ))
end

-- --------------------------------------------------------------------
-- /mythicsim help
-- --------------------------------------------------------------------

function MythicSim:CommandHelp()
    print_info("Commands:")
    if ns.IS_RETAIL then
        print_info("  /mythicsim sim    - sim your character on mythicsim.com")
        print_info("  /mythicsim group  - sim your whole party or raid")
    else
        print_info("  /mythicsim export - export your character for mythicsim.com/wow-forever/sim")
        print_info("  /mythicsim probe  - client report for MythicSim support")
    end
    print_info("  /mythicsim minimap - show or hide the minimap button")
    print_info("  /mythicsim help   - show this message")
end

-- --------------------------------------------------------------------
-- Slash command dispatcher
-- --------------------------------------------------------------------

SLASH_MYTHICSIM1 = "/mythicsim"
SLASH_MYTHICSIM2 = "/msim"

SlashCmdList["MYTHICSIM"] = function(msg)
    local cmd = (msg or ""):match("^%s*(%S*)"):lower()
    -- The bare command does what a click on the minimap button does. On
    -- the Forever client there is no /simc to point at, so `sim` opens
    -- the character export there too.
    if cmd == "" then
        MythicSim:DefaultAction()
    elseif cmd == "export" or cmd == "forever" or (not ns.IS_RETAIL and cmd == "sim") then
        MythicSim:CommandExport()
    elseif cmd == "probe" then
        MythicSim:CommandProbe()
    elseif cmd == "minimap" or cmd == "button" then
        MythicSim:CommandMinimap()
    elseif cmd == "sim" then
        MythicSim:CommandSim()
    elseif cmd == "group" or cmd == "raid" or cmd == "party" then
        MythicSim:CommandGroup()
    elseif cmd == "help" or cmd == "?" then
        MythicSim:CommandHelp()
    else
        print_info("Unknown command '" .. cmd .. "'. Try /mythicsim help.")
    end
end

-- --------------------------------------------------------------------
-- Loading message. Keeps the user reassured that the addon is active
-- and nudges them toward the right slash command the first time.
-- --------------------------------------------------------------------

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
    if ns.IS_RETAIL then
        print_info("Loaded. Run /mythicsim help.")
    else
        print_info("Loaded. Click the minimap button or run /mythicsim export to sim this character.")
    end
end)
