-- MythicSim: World of Warcraft: Forever character export
--
-- Forever is a Classic-family client, so there is no SimulationCraft
-- addon and no /simc string. mythicsim.com/wow-forever/sim instead reads
-- the character JSON established by the WoWSims Exporter addon
-- (github.com/wowsims/exporter, MIT), which is also what the Forever
-- engine's own web UI imports. This file emits that same JSON so a paste
-- works on both, and adds one namespaced `mythicsim` object the other
-- readers ignore.
--
-- The item link parsing, the slot order and the Scourge -> Undead race
-- fix follow the WoWSims Exporter (c) 2022 General Wrex, MIT licence.
--
-- Commands (dispatched from MythicSim.lua):
--   /mythicsim export  - character JSON in the copy window
--   /mythicsim probe   - what this client's addon API looks like, for
--                        support and for keeping the talent reader honest
--
-- TALENTS are the part that differs from every Classic client. Forever's
-- trees are retail-style Traits, and the 1.60 client has no
-- GetNumTalentTabs / GetTalentInfo at all, so the Trait API is read
-- first. The GetTalentInfo reader is kept as the fallback for Classic Era
-- clients, and the export records which one produced the string.
--
-- Checked against client 1.60.1.69913: a Druid read in game, and all nine
-- classes read from that build's Trait tables, come out in exactly the
-- engine's <Class>Talents field-number order (addon/test/fixture_trees.lua).

local addonName, ns = ...
local MythicSim = _G.MythicSim

local print_info = ns.print_info
local json_string = ns.json_string
local show_export_window = ns.show_export_window

local COPY_HINT = "Copy this (Ctrl-C / Cmd-C) and paste it at mythicsim.com/wow-forever/sim"
local PROBE_HINT = "Copy this (Ctrl-C / Cmd-C) and send it to MythicSim support. It holds your character's gear and talents, nothing else."

-- Runs f and swallows a Lua error, so one API that is missing or shaped
-- differently on this client cannot take the whole export down with it.
local function try(f, ...)
    if type(f) ~= "function" then return nil end
    local ok, a, b, c, d, e, g, h = pcall(f, ...)
    if ok then return a, b, c, d, e, g, h end
    return nil
end

local function addon_version()
    local get = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    return try(get, addonName, "Version") or "unknown"
end

-- --------------------------------------------------------------------
-- Gear
--
-- Slot order is the exporter's: the sim reads items by their own type,
-- but the engine UI expects this order for rings and trinkets.
-- --------------------------------------------------------------------

local SLOT_ORDER = {
    INVSLOT_HEAD or 1,
    INVSLOT_NECK or 2,
    INVSLOT_SHOULDER or 3,
    INVSLOT_BACK or 15,
    INVSLOT_CHEST or 5,
    INVSLOT_WRIST or 9,
    INVSLOT_HAND or 10,
    INVSLOT_WAIST or 6,
    INVSLOT_LEGS or 7,
    INVSLOT_FEET or 8,
    INVSLOT_FINGER1 or 11,
    INVSLOT_FINGER2 or 12,
    INVSLOT_TRINKET1 or 13,
    INVSLOT_TRINKET2 or 14,
    INVSLOT_MAINHAND or 16,
    INVSLOT_OFFHAND or 17,
    INVSLOT_RANGED or 18,
}

-- item:<id>:<enchant>:<gem1>:<gem2>:<gem3>:<gem4>:<suffix>:...
local function parse_item_link(link)
    local payload = link and link:match("item:([%-%d:]+)")
    if not payload then return nil end
    local fields = {}
    for field in (payload .. ":"):gmatch("([^:]*):") do
        fields[#fields + 1] = tonumber(field) or 0
    end
    if not fields[1] or fields[1] <= 0 then return nil end
    return { id = fields[1], enchant = fields[2] or 0, suffix = fields[7] or 0 }
end

local function collect_gear()
    local items = {}
    for _, slot in ipairs(SLOT_ORDER) do
        local item = parse_item_link(GetInventoryItemLink("player", slot))
        if item then items[#items + 1] = item end
    end
    return items
end

-- --------------------------------------------------------------------
-- Talents
--
-- Both readers produce the wowhead-style positional string the engine
-- takes: one digit per talent, row by row and left to right inside a
-- tree, trees joined with "-".
-- --------------------------------------------------------------------

-- The Trait canvas. One TraitTree per class holds all three tabs side by
-- side: first columns at PosX 1020 / 5020 / 9080, first row at PosY 2130,
-- squares 600 apart, four columns to a tab. TAB_BOUNDS are the midpoints
-- of the gaps between tabs.
local TRAIT_TAB_STARTS = { 1020, 5020, 9080 }
local TRAIT_TAB_BOUNDS = { 3920, 7950 }
local TRAIT_FIRST_ROW = 2130
local TRAIT_SQUARE = 600
local TRAIT_MAX_COL = 3
local TRAIT_MAX_ROW = 10

-- A node's tab, row and column, or nil when it is not on the canvas.
--
-- Positions are snapped to the grid rather than compared raw because the
-- client data is not exact: Warlock's Amplify Curse sits at PosY 3320 on
-- the 3330 row and would otherwise sort a row early. And a few nodes are
-- parked far off the canvas (Hunter's old Lightning Reflexes at PosX
-- 102800, Priest's Holy Specialization at PosY 21300); nobody can put a
-- point in those and the engine's trees do not have them. They must be
-- dropped, not appended: the engine reads the string by position, so one
-- extra digit shifts every talent after it into the wrong field.
local function trait_square(posX, posY)
    local tab = 3
    if posX < TRAIT_TAB_BOUNDS[1] then tab = 1 elseif posX < TRAIT_TAB_BOUNDS[2] then tab = 2 end
    local col = math.floor((posX - TRAIT_TAB_STARTS[tab]) / TRAIT_SQUARE + 0.5)
    local row = math.floor((posY - TRAIT_FIRST_ROW) / TRAIT_SQUARE + 0.5)
    if col < 0 or col > TRAIT_MAX_COL or row < 0 or row > TRAIT_MAX_ROW then return nil end
    return tab, row, col
end

-- Every visible node of the active talent config, unordered.
local function trait_nodes()
    if not (C_Traits and C_ClassTalents) then return nil end
    local configID = try(C_ClassTalents.GetActiveConfigID)
    if not configID then return nil end
    local config = try(C_Traits.GetConfigInfo, configID)
    if not config or not config.treeIDs then return nil end

    local nodes = {}
    for _, treeID in ipairs(config.treeIDs) do
        for _, nodeID in ipairs(try(C_Traits.GetTreeNodes, treeID) or {}) do
            local info = try(C_Traits.GetNodeInfo, configID, nodeID)
            if info and info.ID and info.ID ~= 0 and info.posX and info.posY then
                nodes[#nodes + 1] = {
                    id = info.ID,
                    tree = treeID,
                    posX = info.posX,
                    posY = info.posY,
                    visible = info.isVisible and true or false,
                    -- activeRank is the committed rank, the field Blizzard's own
                    -- talent buttons test (Blizzard_TalentButtonSpend.lua on the
                    -- 1.60.1.69913 client); currentRank would count unsaved clicks.
                    -- Clamped because the string is one digit per talent.
                    rank = math.min(info.activeRank or info.ranksPurchased or 0, info.maxRanks or 0, 9),
                    activeRank = info.activeRank,
                    purchased = info.ranksPurchased,
                    max = info.maxRanks or 0,
                    entryIDs = info.entryIDs,
                }
            end
        end
    end
    return nodes, configID
end

local function talents_from_traits()
    local nodes, configID = trait_nodes()
    if not nodes then return nil end

    -- Where two nodes sit on the same square the newer node id is the
    -- live one; the older is a leftover the tree no longer uses.
    local by_square = {}
    for _, node in ipairs(nodes) do
        local tab, row, col = trait_square(node.posX, node.posY)
        if tab and node.visible and node.max > 0 then
            node.tab, node.row, node.col = tab, row, col
            local key = tab .. ":" .. row .. ":" .. col
            local seen = by_square[key]
            if not seen or node.id > seen.id then by_square[key] = node end
        end
    end

    local tabs = { {}, {}, {} }
    local count = 0
    for _, node in pairs(by_square) do
        local tab = tabs[node.tab]
        tab[#tab + 1] = node
        count = count + 1
    end
    if count == 0 then return nil end

    local parts = {}
    for i, tab in ipairs(tabs) do
        table.sort(tab, function(a, b)
            if a.row ~= b.row then return a.row < b.row end
            return a.col < b.col
        end)
        local digits = {}
        for j, node in ipairs(tab) do digits[j] = tostring(node.rank) end
        parts[i] = table.concat(digits)
    end
    return table.concat(parts, "-"), tabs, configID
end

-- Points the client itself says are spent, summed over the tree's
-- currencies. Every Forever talent rank costs one point, so this should
-- equal the digits of the exported string; build_export records both so a
-- reader that picked the wrong rank field cannot go unnoticed.
local function trait_points_spent(configID, tabs)
    local tree = tabs and ((tabs[1][1] or tabs[2][1] or tabs[3][1] or {}).tree)
    if not (configID and tree) then return nil end
    local currencies = try(C_Traits.GetTreeCurrencyInfo, configID, tree, true)
    if type(currencies) ~= "table" then return nil end
    local spent = 0
    for _, currency in ipairs(currencies) do spent = spent + (currency.spent or 0) end
    return spent
end

-- GetTalentInfo indices stopped matching tree positions in Classic
-- 3.4.0, so order by tier then column rather than by index.
local function talents_from_legacy()
    if not (GetNumTalentTabs and GetNumTalents and GetTalentInfo) then return nil end
    local parts = {}
    local count = 0
    for tab = 1, (try(GetNumTalentTabs) or 0) do
        local talents = {}
        for i = 1, (try(GetNumTalents, tab) or 0) do
            local name, _, tier, column, rank = try(GetTalentInfo, tab, i)
            if name and tier and column then
                talents[#talents + 1] = { tier = tier, column = column, rank = rank or 0 }
            end
        end
        table.sort(talents, function(a, b)
            if a.tier ~= b.tier then return a.tier < b.tier end
            return a.column < b.column
        end)
        local digits = {}
        for j, talent in ipairs(talents) do digits[j] = tostring(talent.rank) end
        parts[tab] = table.concat(digits)
        count = count + #talents
    end
    if count == 0 then return nil end
    return table.concat(parts, "-")
end

local function collect_talents()
    local talents, tabs, configID = talents_from_traits()
    if talents then return talents, "traits", tabs, configID end
    talents = talents_from_legacy()
    if talents then return talents, "legacy" end
    return "", "none"
end

-- --------------------------------------------------------------------
-- Professions
--
-- The sim wants English names. Skill line ids are locale independent
-- where the client exposes them; otherwise the localized display name is
-- mapped back, so a zhCN or deDE client still exports "Engineering".
-- --------------------------------------------------------------------

-- SkillLine.db2
local PROFESSION_SKILL_LINES = {
    [164] = "Blacksmithing",
    [165] = "Leatherworking",
    [171] = "Alchemy",
    [182] = "Herbalism",
    [186] = "Mining",
    [197] = "Tailoring",
    [202] = "Engineering",
    [333] = "Enchanting",
    [393] = "Skinning",
}

local function profession_names()
    local names = {}
    for skillLine, english in pairs(PROFESSION_SKILL_LINES) do
        names[english] = english
        local localized = C_TradeSkillUI and try(C_TradeSkillUI.GetTradeSkillDisplayName, skillLine)
        if localized then names[localized] = english end
    end
    return names
end

local function collect_professions()
    local professions = {}
    if GetNumSkillLines and GetSkillLineInfo then
        local names = profession_names()
        for i = 1, (try(GetNumSkillLines) or 0) do
            local name, isHeader, _, skillRank = try(GetSkillLineInfo, i)
            if name and not isHeader and names[name] then
                professions[#professions + 1] = { name = names[name], level = skillRank or 0 }
            end
        end
    elseif GetProfessions and GetProfessionInfo then
        -- The first two returns are the primary professions; either can be
        -- nil on its own, so this is not an ipairs job.
        local first, second = try(GetProfessions)
        for _, index in pairs({ first = first, second = second }) do
            local _, _, skillLevel, _, _, _, skillLine = try(GetProfessionInfo, index)
            local english = skillLine and PROFESSION_SKILL_LINES[skillLine]
            if english then
                professions[#professions + 1] = { name = english, level = skillLevel or 0 }
            end
        end
        table.sort(professions, function(a, b) return a.name < b.name end)
    end
    return professions
end

-- --------------------------------------------------------------------
-- Talent spells
--
-- The positional string only means something against one version of the
-- engine's trees. The spell id of every node travels beside it, in the
-- same order, so the server can re-map by spell when the client's tree and
-- the pinned engine's tree drift apart, without an addon release.
-- --------------------------------------------------------------------

local function spell_name(spellID)
    if not spellID then return nil end
    if C_Spell and C_Spell.GetSpellName then return try(C_Spell.GetSpellName, spellID) end
    return (try(GetSpellInfo, spellID))
end

local function node_spell(configID, node)
    local entryID = node.entryIDs and node.entryIDs[1]
    local entry = entryID and try(C_Traits.GetEntryInfo, configID, entryID)
    local definition = entry and entry.definitionID and try(C_Traits.GetDefinitionInfo, entry.definitionID)
    local spellID = definition and definition.spellID
    return spellID, spell_name(spellID)
end

local function encode_talent_spells(tabs, configID)
    local out = {}
    for i, tab in ipairs(tabs) do
        local pairs_ = {}
        for j, node in ipairs(tab) do
            pairs_[j] = "[" .. (node_spell(configID, node) or 0) .. "," .. node.rank .. "]"
        end
        out[i] = "[" .. table.concat(pairs_, ",") .. "]"
    end
    return "[" .. table.concat(out, ",") .. "]"
end

-- --------------------------------------------------------------------
-- Character JSON
-- --------------------------------------------------------------------

local function english_race()
    local _, token = UnitRace("player")
    token = token or ""
    if token == "Scourge" then return "Undead" end
    return token
end

local function encode_item(item)
    local fields = { '"id":' .. item.id }
    if item.enchant ~= 0 then fields[#fields + 1] = '"enchant":' .. item.enchant end
    -- Spelled as the Classic Era exporter spells it.
    if item.suffix ~= 0 then fields[#fields + 1] = '"random_suffix":' .. item.suffix end
    return "{" .. table.concat(fields, ",") .. "}"
end

-- Only carried equipment is exported. Bank contents and consumables stay out.
local function collect_bags()
    local items = {}
    local slots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
    local link_for = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
    local equip = (C_Item and C_Item.IsEquippableItem) or IsEquippableItem
    if not slots or not link_for or not equip then return nil end
    for bag = 0, (NUM_BAG_SLOTS or 4) do
        for slot = 1, (try(slots, bag) or 0) do
            local link = try(link_for, bag, slot)
            if link and try(equip, link) then
                local item = parse_item_link(link)
                if item then items[#items + 1] = encode_item(item) end
            end
        end
    end
    return items
end

local function build_export()
    local name, realm = UnitFullName("player")
    local _, classToken = UnitClass("player")
    local talents, talentSource, talentTabs, talentConfig = collect_talents()
    local clientVersion, clientBuild, _, interface = GetBuildInfo()

    local items = {}
    for i, item in ipairs(collect_gear()) do items[i] = encode_item(item) end

    local professions = {}
    for i, p in ipairs(collect_professions()) do
        professions[i] = '{"name":' .. json_string(p.name) .. ',"level":' .. p.level .. "}"
    end

    local meta = {
        '"exporter":"MythicSim"',
        '"addonVersion":' .. json_string(addon_version()),
        '"clientVersion":' .. json_string(tostring(clientVersion)),
        '"clientBuild":' .. json_string(tostring(clientBuild)),
        '"interface":' .. (tonumber(interface) or 0),
        '"talentSource":' .. json_string(talentSource),
        '"locale":' .. json_string(GetLocale() or ""),
    }
    local points = 0
    for digit in talents:gmatch("%d") do points = points + tonumber(digit) end
    local spent = trait_points_spent(talentConfig, talentTabs)
    meta[#meta + 1] = '"talentPoints":' .. points
    if spent then meta[#meta + 1] = '"talentPointsSpent":' .. spent end
    if talentTabs then
        meta[#meta + 1] = '"talentSpells":' .. encode_talent_spells(talentTabs, talentConfig)
    end

    local fields = {
        '"version":' .. json_string(addon_version()),
        '"name":' .. json_string(name or UnitName("player") or ""),
        '"realm":' .. json_string(realm or GetRealmName() or ""),
        '"race":' .. json_string(english_race()),
        '"class":' .. json_string((classToken or ""):lower()),
        '"level":' .. (UnitLevel("player") or 0),
        '"talents":' .. json_string(talents),
        '"professions":[' .. table.concat(professions, ",") .. "]",
        '"gear":{"items":[' .. table.concat(items, ",") .. "]}",
        '"mythicsim":{' .. table.concat(meta, ",") .. "}",
    }
    local bags = collect_bags()
    if bags then fields[#fields + 1] = '"bags":[' .. table.concat(bags, ",") .. "]" end
    return "{" .. table.concat(fields, ",\n") .. "}", #items, talentSource, points, spent
end

function MythicSim:CommandExport()
    if ns.IS_RETAIL then
        print_info("This export is for the World of Warcraft: Forever client. On retail, paste your /simc output at " .. ns.WEB_BASE .. ".")
        return
    end
    local payload, itemCount, talentSource, points, spent = build_export()
    if itemCount == 0 then
        print_info("No equipped items found. Equip your gear and run /mythicsim export again.")
        return
    end
    if talentSource == "none" then
        print_info("Could not read your talents on this client. Run /mythicsim probe and send us the output.")
    end
    -- Only the unmistakable case talks to the player: points spent, none
    -- read. Any other gap between the two numbers travels in the export
    -- for us to look at, because what `spent` counts on this client has
    -- not been seen with real points yet and a false alarm on every export
    -- would be worse than none.
    if spent and spent > 0 and points == 0 then
        print_info(string.format("Heads up: the game says you have spent %d talent points but this export read none. The sim will not match your build. Run /mythicsim probe and send us the output.", spent))
    elseif points == 0 and (UnitLevel("player") or 0) >= 10 then
        print_info("No talent points found on this character. If you have spent some, run /mythicsim probe and send us the output.")
    end
    show_export_window("MythicSim Forever Export", payload, COPY_HINT)
    print_info("Export window opened. Copy it, then paste at " .. ns.WEB_BASE .. "/wow-forever/sim")
end

-- --------------------------------------------------------------------
-- /mythicsim probe
--
-- A plain-text report of the addon API this client exposes and of the
-- raw talent data behind the export, so a wrong talent string can be
-- diagnosed from a paste instead of from a screenshot.
-- --------------------------------------------------------------------

local function build_probe()
    local out = {}
    local function line(fmt, ...) out[#out + 1] = string.format(fmt, ...) end

    local clientVersion, clientBuild, buildDate, interface = GetBuildInfo()
    line("MythicSim probe, addon %s", addon_version())
    line("client %s build %s (%s) interface %s", tostring(clientVersion), tostring(clientBuild), tostring(buildDate), tostring(interface))
    line("WOW_PROJECT_ID %s (MAINLINE %s, CLASSIC %s)", tostring(WOW_PROJECT_ID), tostring(WOW_PROJECT_MAINLINE), tostring(WOW_PROJECT_CLASSIC))
    line("locale %s", tostring(GetLocale()))
    line("class %s | race %s / %s | level %s", tostring(select(2, UnitClass("player"))), tostring((UnitRace("player"))), tostring(select(2, UnitRace("player"))), tostring(UnitLevel("player")))

    line("")
    line("== API")
    local apis = {
        { "C_Traits", C_Traits }, { "C_ClassTalents", C_ClassTalents },
        { "C_SpecializationInfo", C_SpecializationInfo }, { "C_Engraving", C_Engraving },
        { "C_AddOns", C_AddOns }, { "C_Container", C_Container }, { "C_Spell", C_Spell },
        { "C_TradeSkillUI.GetTradeSkillDisplayName", C_TradeSkillUI and C_TradeSkillUI.GetTradeSkillDisplayName },
        { "GetNumTalentTabs", GetNumTalentTabs }, { "GetTalentInfo", GetTalentInfo },
        { "GetTalentTabInfo", GetTalentTabInfo }, { "GetNumSkillLines", GetNumSkillLines },
        { "GetProfessions", GetProfessions },
    }
    for _, api in ipairs(apis) do line("%s: %s", api[1], api[2] and "yes" or "no") end

    line("")
    line("== talents, exported")
    local probeTalents, probeTabs, probeConfig = talents_from_traits()
    line("traits: %s", tostring(probeTalents))
    line("points spent per the client: %s", tostring(trait_points_spent(probeConfig, probeTabs)))
    line("legacy: %s", tostring(talents_from_legacy()))

    line("")
    line("== talents, Trait API (node id, posX, posY, visible, rank/purchased/max, spell)")
    local nodes, configID = trait_nodes()
    if nodes then
        table.sort(nodes, function(a, b)
            if a.posX ~= b.posX then return a.posX < b.posX end
            if a.posY ~= b.posY then return a.posY < b.posY end
            return a.id < b.id
        end)
        line("config %s, %d nodes", tostring(configID), #nodes)
        for _, node in ipairs(nodes) do
            local spellID, name = node_spell(configID, node)
            line("%d tree %s x%d y%d %s %s/%s/%d %s %s", node.id, tostring(node.tree), node.posX, node.posY,
                node.visible and "vis" or "hid", tostring(node.activeRank), tostring(node.purchased), node.max,
                tostring(spellID), tostring(name))
        end
    else
        line("no active Trait config")
    end

    line("")
    line("== talents, GetTalentInfo (tab.index, tier, column, rank/max, name)")
    for tab = 1, (try(GetNumTalentTabs) or 0) do
        line("tab %d: %s", tab, tostring((try(GetTalentTabInfo, tab))))
        for i = 1, (try(GetNumTalents, tab) or 0) do
            local name, _, tier, column, rank, maxRank = try(GetTalentInfo, tab, i)
            line("%d.%d t%s c%s %s/%s %s", tab, i, tostring(tier), tostring(column), tostring(rank), tostring(maxRank), tostring(name))
        end
    end

    line("")
    line("== gear (slot, item string)")
    for _, slot in ipairs(SLOT_ORDER) do
        local link = GetInventoryItemLink("player", slot)
        line("%d %s", slot, link and (link:match("(item:[%-%d:]+)") or "unparsed") or "empty")
    end

    line("")
    line("== professions")
    for _, p in ipairs(collect_professions()) do line("%s %d", p.name, p.level) end

    return table.concat(out, "\n")
end

function MythicSim:CommandProbe()
    show_export_window("MythicSim Client Probe", build_probe(), PROBE_HINT)
    print_info("Probe window opened. Copy everything in it.")
end
