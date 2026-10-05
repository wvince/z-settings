-- If we are on a SoD realm, ignore everything in this file
if C_Seasons and C_Seasons.GetActiveSeason and C_Seasons.GetActiveSeason() == 2 then return end

-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
local _G = getfenv(0)
local string = _G.string
local format = string.format

-- WoW

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local addonname = ...
local AtlasLoot = _G.AtlasLoot
local data = AtlasLoot.ItemDB:Add(addonname, 1, AtlasLoot.CLASSIC_VERSION_NUM)

local AL = AtlasLoot.Locales

local GetForVersion = AtlasLoot.ReturnForGameVersion

local NORMAL_DIFF = data:AddDifficulty("NORMAL", nil, nil, nil, true)
local RAID20_DIFF = data:AddDifficulty("20RAID")
local RAID40_DIFF = data:AddDifficulty("40RAID")
local FOREVER_DUNGEON_CONTENT = data:AddContentType("Forever Dungeons", { 0.30, 0.50, 0.70, 1 })

local ALLIANCE_DIFF, HORDE_DIFF, LOAD_DIFF
if UnitFactionGroup("player") == "Horde" then
	HORDE_DIFF = data:AddDifficulty(FACTION_HORDE, "horde", nil, 1)
	ALLIANCE_DIFF = data:AddDifficulty(FACTION_ALLIANCE, "alliance", nil, 1)
	LOAD_DIFF = HORDE_DIFF
else
	ALLIANCE_DIFF = data:AddDifficulty(FACTION_ALLIANCE, "alliance", nil, 1)
	HORDE_DIFF = data:AddDifficulty(FACTION_HORDE, "horde", nil, 1)
	LOAD_DIFF = ALLIANCE_DIFF
end

local NORMAL_ITTYPE = data:AddItemTableType("Item", "Item")
local SET_ITTYPE = data:AddItemTableType("Set", "Item")

local QUEST_EXTRA_ITTYPE = data:AddExtraItemTableType("Quest")
local PRICE_EXTRA_ITTYPE = data:AddExtraItemTableType("Price")

local DUNGEON_CONTENT = data:AddContentType(AL["Dungeons"], ATLASLOOT_DUNGEON_COLOR)
local FOREVER_RAID_CONTENT = data:AddContentType("Forever Raids", { 0.75, 0.45, 0.20, 1 })
local RAID20_CONTENT = data:AddContentType(AL["20 Raids"], ATLASLOOT_RAID20_COLOR)
local RAID40_CONTENT = data:AddContentType(AL["40 Raids"], ATLASLOOT_RAID40_COLOR)

local ATLAS_MODULE_NAME = "Atlas_ClassicWoW"

local BLUE = "|cff6666ff%s|r"
--local GREY = "|cff999999%s|r"
local GREEN = "|cff66cc33%s|r"
local _RED = "|cffcc6666%s|r"
local PURP = "|cff9900ff%s|r"
local WHIT = "|cffffffff%s|r"

local NAME_COLOR, NAME_COLOR_BOSS = "|cffC0C0C0", "|cffC0C0C0"
local NAME_BRD_RING_OF_LAW = NAME_COLOR_BOSS..AL["Ring of Law"]..":|r %s" -- Tempest Keep

-- ============================================================================
-- New Custom Dungeons (shit will be added soon)
-- ============================================================================

data["TheHallOfThanes"] = {
	name = "Hall of Thanes" .. LTNX,
	ContentType = FOREVER_DUNGEON_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 10, 13, 18 }, -- { minEnter, recMin, recMax }
	items = {
		{ -- Boss 1: Faldrim Anvilmar
			name = "Faldrim Anvilmar",
			[NORMAL_DIFF] = {
				{ 1, 270227 }, -- Ephemeral Choker (neck)
				{ 2, 271096 }, -- Aetherwisp Bracers (wrist, cloth)
				{ 3, 271097 }, -- Spiritwraith Drape (back, cloth)
			},
		},
		{ -- Boss 2: Magmatus
			name = "Magmatus",
			[NORMAL_DIFF] = {
				{ 1, 270230 }, -- Kindlegem Girdle (waist, mail)
				{ 2, 270231 }, -- Flamefist Grips (hands, leather)
				{ 3, 271095 }, -- Fang of Magmatus (main hand, dagger)
			},
		},
		{ -- Boss 3: Plunder
			name = "Plunder",
			[NORMAL_DIFF] = {
				{ 1, 270228 }, -- Golemheart Stave (two-hand, staff)
				{ 2, 270229 }, -- Treads of the Protector Golem (feet, mail)
				{ 3, 271098 }, -- Golemguard Chest (chest, mail)
			},
		},
		{ -- Boss 4: Durgen Dirgehammer
			name = "Durgen Dirgehammer",
			[NORMAL_DIFF] = {
				{ 1, 270256 }, -- Durgen's Crescent Axe (main hand, axe)
				{ 2, 270260 }, -- Direhammer Leggings (legs, leather)
				{ 3, 270261 }, -- Robes of the Disgraced Thane (chest, cloth)
			},
		},
	},
}

data["TheRuinsOfLordaeron"] = {
	name = "Ruins of Lordaeron" .. LTNX,
	ContentType = FOREVER_DUNGEON_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 10, 13, 18 }, -- { minEnter, recMin, recMax }
	items = {
		{ -- Boss 1: The Baron
			name = "The Baron",
			[NORMAL_DIFF] = {
				{ 1, 271204 }, -- Meathook Slicer (one-hand, dagger)
				{ 2, 271205 }, -- Abomination Bones (chest, mail)
				{ 3, 271206 }, -- Leftover Abomination Skin (chest, cloth)
			},
		},
		{ -- Boss 2: Witherfang
			name = "Witherfang",
			[NORMAL_DIFF] = {
				{ 1, 271201 }, -- Atrophic Girdle (waist, mail)
				{ 2, 271202 }, -- Witherbite Bracers (wrist, leather)
				{ 3, 271203 }, -- Segmented Spider Leg (two-hand, staff)
			},
		},
		{ -- Boss 3: The Abandoned
			name = "The Abandoned",
			[NORMAL_DIFF] = {
				{ 1, 271207 }, -- Wispcloth Leggings (legs, cloth)
				{ 2, 271208 }, -- Grip of Fear (hands, mail)
				{ 3, 271216 }, -- Scepter of the Abandoned (main hand, mace)
			},
		},
		{ -- Boss 4: Bjork
			name = "Bjork",
			[NORMAL_DIFF] = {
				{ 1, 271209 }, -- Bonerust Leggings (legs, mail)
				{ 2, 271210 }, -- Tuskwrap Belt (waist, cloth)
				{ 3, 271217 }, -- Corpse Chopper (two-hand, axe)
			},
		},
		{ -- Boss 5: Rath'mael
			name = "Rath'mael",
			[NORMAL_DIFF] = {
				{ 1, 271213 }, -- Mirror of Rath'mael (off hand, shield)
				{ 2, 271214 }, -- Frostbane Treads (feet, cloth)
				{ 3, 271215 }, -- Coldspire Staff (two-hand, staff)
			},
		},
		{ -- Boss 6: Lordaeron Captain
			name = "Lordaeron Captain",
			[NORMAL_DIFF] = {
				{ 1, 6642 }, -- Phantom Armor
				{ 2, 6641 }, -- Haunting Blade
			},
		},
		{ -- Boss 7: Viktor the Vile
			name = "Viktor the Vile",
			[NORMAL_DIFF] = {
				{ 1, 271211 }, -- Vilewalkers (feet, mail)
				{ 2, 271212 }, -- Bloodied Chestwraps (chest, leather)
				{ 3, 271218 }, -- Vileblood Scimitar (one-hand, sword)
			},
		},
	},
}

data["ExcavationSiteWetlands"] = {
	name = "Excavation Site: Wetlands",
	ContentType = FOREVER_DUNGEON_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 20, 24, 29 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}

data["CityOfDalaran"] = {
	name = "City of Dalaran",
	ContentType = FOREVER_DUNGEON_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 24, 28, 33 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}

data["TheDrownedCity"] = {
	name = "The Drowned City",
	ContentType = FOREVER_DUNGEON_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 30, 35, 40 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}

data["KroldokStronghold"] = {
	name = "Krol'dok Stronghold",
	ContentType = FOREVER_DUNGEON_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 35, 40, 45 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}

data["AlcazPrison"] = {
	name = "Alcaz Prison",
	ContentType = FOREVER_DUNGEON_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 45, 48, 53 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}

data["BlackmawHold"] = {
	name = "Blackmaw Hold",
	ContentType = FOREVER_DUNGEON_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 50, 55, 60 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}

data["ShapersTerrace"] = {
	name = "Shaper's Terrace",
	ContentType = FOREVER_DUNGEON_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 55, 58, 60 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}

-- ============================================================================
-- New Custom Raids (Loot will be updated asap! Data mining is not yet fully possible!)
-- ============================================================================

data["MountHyjal"] = {
	name = "Mount Hyjal",
	ContentType = FOREVER_RAID_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 60, 60, 60 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}

data["BarrowDeepsRaid"] = {
	name = "Barrow Deeps Raid",
	ContentType = FOREVER_RAID_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 60, 60, 60 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}

data["OnyxiasLairNew"] = {
	name = "Onyxias Lair",
	ContentType = FOREVER_RAID_CONTENT,
	LoadDifficulty = NORMAL_DIFF,
	LevelRange = { 60, 60, 60 },
	items = {
		{
			name = "Loot will be updated asap! Data mining is not yet fully possible!",
			[NORMAL_DIFF] = {},
		},
	},
}