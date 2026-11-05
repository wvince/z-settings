local addonName, MSC = ...

-- ============================================================================
-- 1. GLOBAL CONSTANTS & MAPS
-- ============================================================================
MSC.SlotMap = {
    ["INVTYPE_HEAD"]=1, ["INVTYPE_NECK"]=2, ["INVTYPE_SHOULDER"]=3, ["INVTYPE_BODY"]=4, 
    ["INVTYPE_CHEST"]=5, ["INVTYPE_ROBE"]=5, ["INVTYPE_WAIST"]=6, ["INVTYPE_LEGS"]=7, 
    ["INVTYPE_FEET"]=8, ["INVTYPE_WRIST"]=9, ["INVTYPE_HAND"]=10, ["INVTYPE_FINGER"]=11, 
    ["INVTYPE_TRINKET"]=13, ["INVTYPE_CLOAK"]=15, ["INVTYPE_WEAPON"]=16, ["INVTYPE_SHIELD"]=17, 
    ["INVTYPE_2HWEAPON"]=16, ["INVTYPE_WEAPONMAINHAND"]=16, ["INVTYPE_WEAPONOFFHAND"]=17, 
    ["INVTYPE_HOLDABLE"]=17, ["INVTYPE_RANGED"]=18, ["INVTYPE_THROWN"]=18, 
    ["INVTYPE_RANGEDRIGHT"]=18, ["INVTYPE_RELIC"]=18 
}

MSC.ShortNames = {
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = MSC.L["Resilience"],
    ["ITEM_MOD_HASTE_RATING_SHORT"]      = MSC.L["Haste"],
    ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= MSC.L["Spell Haste"],
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"]  = MSC.L["Expertise"],
    ["ITEM_MOD_ARMOR_PENETRATION_SHORT"] = MSC.L["Armor Pen"],
    ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = MSC.L["Armor Pen"],
    ["ITEM_MOD_SPELL_PENETRATION_SHORT"] = MSC.L["Spell Pen"],
    ["ITEM_MOD_SPELL_PENETRATION_RATING_SHORT"] = MSC.L["Spell Pen"],
    ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]= MSC.L["Feral AP"],
    ["MSC_PVP_UTILITY"]                  = MSC.L["PvP Utility"],
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = MSC.L["Weapon Skill"], 
    ["RESISTANCE0_NAME"]              = MSC.L["Armor"], 
    ["ITEM_MOD_ARMOR_SHORT"]          = MSC.L["Armor"],
    ["ITEM_MOD_AGILITY_SHORT"]        = MSC.L["Agility"],
    ["ITEM_MOD_STRENGTH_SHORT"]       = MSC.L["Strength"],
    ["ITEM_MOD_INTELLECT_SHORT"]      = MSC.L["Intellect"],
    ["ITEM_MOD_SPIRIT_SHORT"]         = MSC.L["Spirit"],
    ["ITEM_MOD_STAMINA_SHORT"]        = MSC.L["Stamina"],
    ["ITEM_MOD_HEALTH_SHORT"]         = MSC.L["Health"],
    ["ITEM_MOD_MANA_SHORT"]           = MSC.L["Mana"],
    ["ITEM_MOD_SPELL_POWER_SHORT"]    = MSC.L["Spell Power"],
    ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]  = MSC.L["Healing"],
    ["ITEM_MOD_SPELL_HEALING_DONE"]   = MSC.L["Healing"], 
    ["ITEM_MOD_MANA_REGENERATION_SHORT"] = MSC.L["Mp5"],
    ["ITEM_MOD_POWER_REGEN0_SHORT"]   = MSC.L["Mp5"], 
    ["ITEM_MOD_ATTACK_POWER_SHORT"]      = MSC.L["Attack Power"],
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = MSC.L["Ranged AP"], 
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = MSC.L["Feral AP"],
    ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = MSC.L["Hp5"],
    ["ITEM_MOD_CRIT_RATING_SHORT"]       = MSC.L["Crit"],
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = MSC.L["Spell Crit"],
    ["ITEM_MOD_HIT_RATING_SHORT"]        = MSC.L["Hit"],
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]  = MSC.L["Spell Hit"],
    ["ITEM_MOD_CRIT_FROM_STATS_SHORT"]         = MSC.L["Crit (from Agi)"],
    ["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = MSC.L["Spell Crit (from Int)"],
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = MSC.L["Defense"],
    ["ITEM_MOD_DODGE_RATING_SHORT"]      = MSC.L["Dodge"],
    ["ITEM_MOD_PARRY_RATING_SHORT"]      = MSC.L["Parry"],
    ["ITEM_MOD_BLOCK_RATING_SHORT"]      = MSC.L["Block %"],
    ["ITEM_MOD_BLOCK_VALUE_SHORT"]       = MSC.L["Block Value"],
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]     = MSC.L["Shadow Dmg"],
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"]       = MSC.L["Fire Dmg"],
    ["ITEM_MOD_FROST_DAMAGE_SHORT"]      = MSC.L["Frost Dmg"],
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]     = MSC.L["Arcane Dmg"],
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"]     = MSC.L["Nature Dmg"],
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"]       = MSC.L["Holy Dmg"],
    ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"] = MSC.L["Shadow Res"],
    ["ITEM_MOD_FIRE_RESISTANCE_SHORT"]   = MSC.L["Fire Res"],
    ["ITEM_MOD_FROST_RESISTANCE_SHORT"]  = MSC.L["Frost Res"],
    ["ITEM_MOD_NATURE_RESISTANCE_SHORT"] = MSC.L["Nature Res"],
    ["ITEM_MOD_ARCANE_RESISTANCE_SHORT"] = MSC.L["Arcane Res"],
    ["ITEM_MOD_ALL_RESISTANCE_SHORT"]    = MSC.L["All Res"],
    ["MSC_WEAPON_SPEED"]                 = MSC.L["Speed"],
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = MSC.L["Weapon DPS"],
    ["MSC_WEAPON_DPS"]                   = MSC.L["Weapon DPS"],
    ["MSC_WEAPON_DPS_MELEE"]             = MSC.L["Melee Weapon DPS"],
    ["MSC_WAND_DPS"]                     = MSC.L["Wand DPS"],
}

-- Canonical stat keys: map legacy/parser variants to one internal key
MSC.StatAliases = {
    ["ITEM_MOD_RESISTANCE_ALL_SHORT"] = "ITEM_MOD_ALL_RESISTANCE_SHORT",
}
-- Classic Era profiles (Classes/ERA) weight weapon and wand DPS as
-- ITEM_MOD_DAMAGE_PER_SECOND_SHORT, like Forever's, but the scanner reads it
-- as MSC_WEAPON_DPS / MSC_WAND_DPS, so without these a weapon's DPS scored
-- nothing on Era. (TBC profiles use MSC_WEAPON_DPS itself: no alias there.)
if MSC.IsEra then
    MSC.StatAliases["MSC_WEAPON_DPS"] = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT"
    MSC.StatAliases["MSC_WAND_DPS"] = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT"
end

MSC.PrettyNames = {
    ["Leveling_1_20"]  = MSC.L["Starter (1-20)"],
    ["Leveling_21_40"] = MSC.L["Standard Leveling (21-40)"],
    ["Leveling_41_51"] = MSC.L["Standard Leveling (41-51)"],
    ["Leveling_52_59"] = MSC.L["Standard Leveling (52-59)"],
    ["Leveling_60_70"] = MSC.L["Standard Leveling (Outland)"],
}

-- =============================================================
-- TBC MANA REGEN FORMULA
-- =============================================================
MSC.BaseRegenTable = {
    [1]=0.034965, [2]=0.034191, [3]=0.033465, [4]=0.032526, [5]=0.031661,
    [6]=0.031076, [7]=0.030523, [8]=0.029994, [9]=0.029307, [10]=0.028661,
    [11]=0.027584, [12]=0.026215, [13]=0.025381, [14]=0.024300, [15]=0.023345,
    [16]=0.022748, [17]=0.021958, [18]=0.021386, [19]=0.020790, [20]=0.020121,
    [21]=0.019733, [22]=0.019155, [23]=0.018819, [24]=0.018316, [25]=0.017936,
    [26]=0.017576, [27]=0.017201, [28]=0.016919, [29]=0.016581, [30]=0.016233,
    [31]=0.015994, [32]=0.015707, [33]=0.015464, [34]=0.015204, [35]=0.014956,
    [36]=0.014744, [37]=0.014495, [38]=0.014302, [39]=0.014094, [40]=0.013895,
    [41]=0.013724, [42]=0.013522, [43]=0.013363, [44]=0.013175, [45]=0.012996,
    [46]=0.012853, [47]=0.012687, [48]=0.012539, [49]=0.012384, [50]=0.012233,
    [51]=0.012113, [52]=0.011973, [53]=0.011859, [54]=0.011714, [55]=0.011575,
    [56]=0.011473, [57]=0.011342, [58]=0.011245, [59]=0.011110, [60]=0.010999,
    [61]=0.010700, [62]=0.010522, [63]=0.010290, [64]=0.010119, [65]=0.009968,
    [66]=0.009808, [67]=0.009651, [68]=0.009553, [69]=0.009445, [70]=0.009327
}

-- ============================================================================
-- 2. ENCHANTS
-- ============================================================================
-- MSC.EnchantDB and MSC.EnchantCandidates are generated from each game's client
-- and live in Enchants_Era.lua / Enchants_TBC.lua / Enchants_Forever.lua.

-- ============================================================================
-- 3. GEM DATABASE
-- ============================================================================

if MSC.IsTBC then
    local GEMS = {
	
LEVELING_PRISMATIC = {
			-- ========================================================================
			-- [[ Leveling: Prismatic ]]
			-- ========================================================================
			{ id=22460, stat="ITEM_MOD_ALL_RESISTANCE_SHORT", val=3, name="Prismatic Sphere", colorType="PRISMATIC", quality=3 },
		},
		
		LEVELING_RED = {
			-- ========================================================================
			-- [[ COMMON (Quality 1 / Vendor: Tourmaline) ]]
			-- ========================================================================
			{ id=28458, stat="ITEM_MOD_STRENGTH_SHORT", val=4, name="Bold Tourmaline", colorType="RED", quality=1 },
			{ id=28459, stat="ITEM_MOD_AGILITY_SHORT", val=4, name="Delicate Tourmaline", colorType="RED", quality=1 },
			{ id=28460, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=9, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=3, name="Teardrop Tourmaline", colorType="RED", quality=1 },
			{ id=28461, stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, name="Runed Tourmaline", colorType="RED", quality=1 },
			{ id=28462, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=8, name="Bright Tourmaline", colorType="RED", quality=1 },
			
			-- ========================================================================
			-- [[ UNCOMMON (Quality 2 / Leveling: Blood Garnet) ]]
			-- ========================================================================
			{ id=23094, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=13, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=5, name="Teardrop Blood Garnet", colorType="RED", quality=2 },
			{ id=23095, stat="ITEM_MOD_STRENGTH_SHORT", val=6, name="Bold Blood Garnet", colorType="RED", quality=2 },
			{ id=23096, stat="ITEM_MOD_SPELL_POWER_SHORT", val=7, name="Runed Blood Garnet", colorType="RED", quality=2 },
			{ id=23097, stat="ITEM_MOD_AGILITY_SHORT", val=6, name="Delicate Blood Garnet", colorType="RED", quality=2 },
			{ id=28595, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=12, name="Bright Blood Garnet", colorType="RED", quality=2 },
		},
		
		LEVELING_BLUE = {
		    -- ========================================================================
			-- [[ COMMON (Quality 1 / Vendor: Zircon) ]]
			-- ========================================================================
			{ id=28463, stat="ITEM_MOD_STAMINA_SHORT", val=6, name="Solid Zircon", colorType="BLUE", quality=1 },
			{ id=28464, stat="ITEM_MOD_SPIRIT_SHORT", val=4, name="Sparkling Zircon", colorType="BLUE", quality=1 },
			{ id=28465, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=1, name="Lustrous Zircon", colorType="BLUE", quality=1 },
			
			-- ========================================================================
			-- [[ UNCOMMON (Quality 2 / Leveling: Azure Moonstone) ]]
			-- ========================================================================
			{ id=23118, stat="ITEM_MOD_STAMINA_SHORT", val=9, name="Solid Azure Moonstone", colorType="BLUE", quality=2 },
			{ id=23119, stat="ITEM_MOD_SPIRIT_SHORT", val=6, name="Sparkling Azure Moonstone", colorType="BLUE", quality=2 },
			{ id=23120, stat="ITEM_MOD_SPELL_PENETRATION_SHORT", val=8, name="Stormy Azure Moonstone", colorType="BLUE", quality=2 },
			{ id=23121, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=2, name="Lustrous Azure Moonstone", colorType="BLUE", quality=2 },
		},
		
		LEVELING_YELLOW = {
		    -- ========================================================================
			-- [[ COMMON (Quality 1 / Vendor: Amber) ]]
			-- ========================================================================
			{ id=28466, stat="ITEM_MOD_INTELLECT_SHORT", val=4, name="Brilliant Amber", colorType="YELLOW", quality=1 },
			{ id=28467, stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, name="Smooth Amber", colorType="YELLOW", quality=1 },
			{ id=28468, stat="ITEM_MOD_HIT_RATING_SHORT", val=4, name="Rigid Amber", colorType="YELLOW", quality=1 },
			{ id=28469, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=4, name="Gleaming Amber", colorType="YELLOW", quality=1 },
			{ id=28470, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=4, name="Thick Amber", colorType="YELLOW", quality=1 },
			
			-- ========================================================================
			-- [[ UNCOMMON (Quality 2 / Leveling: Golden Draenite) ]]
			-- ========================================================================
			{ id=23113, stat="ITEM_MOD_INTELLECT_SHORT", val=6, name="Brilliant Golden Draenite", colorType="YELLOW", quality=2 },
			{ id=23114, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=6, name="Gleaming Golden Draenite", colorType="YELLOW", quality=2 },
			{ id=23115, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=6, name="Thick Golden Draenite", colorType="YELLOW", quality=2 },
			{ id=23116, stat="ITEM_MOD_HIT_RATING_SHORT", val=6, name="Rigid Golden Draenite", colorType="YELLOW", quality=2 },
			{ id=28290, stat="ITEM_MOD_CRIT_RATING_SHORT", val=6, name="Smooth Golden Draenite", colorType="YELLOW", quality=2 },
			{ id=31860, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=6, name="Great Golden Draenite", colorType="YELLOW", quality=2 },
		},
		
		LEVELING_ORANGE = {
		    -- ========================================================================
			-- [[ UNCOMMON (Leveling: Flame Spessarite) ]]
			-- ========================================================================
			{ id=23098, stat="ITEM_MOD_CRIT_RATING_SHORT", val=3, stat2="ITEM_MOD_STRENGTH_SHORT", val2=3, name="Inscribed Flame Spessarite", colorType="ORANGE", quality=2 },
			{ id=23099, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=7, stat2="ITEM_MOD_INTELLECT_SHORT", val2=3, name="Luminous Flame Spessarite", colorType="ORANGE", quality=2 },
			{ id=23100, stat="ITEM_MOD_HIT_RATING_SHORT", val=3, stat2="ITEM_MOD_AGILITY_SHORT", val2=3, name="Glinting Flame Spessarite", colorType="ORANGE", quality=2 },
			{ id=23101, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=3, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=4, name="Potent Flame Spessarite", colorType="ORANGE", quality=2 },
			{ id=31866, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=3, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=4, name="Veiled Flame Spessarite", colorType="ORANGE", quality=2 },
			{ id=31869, stat="ITEM_MOD_CRIT_RATING_SHORT", val=3, stat2="ITEM_MOD_ATTACK_POWER_SHORT", val2=6, name="Wicked Flame Spessarite", colorType="ORANGE", quality=2 },
		},
		
		LEVELING_PURPLE = {
		    -- ========================================================================
			-- [[ UNCOMMON (Leveling: Shadow Draenite & Jaggal Pearl) ]]
			-- ========================================================================
			{ id=23108, stat="ITEM_MOD_SPELL_POWER_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name="Glowing Shadow Draenite", colorType="PURPLE", quality=2 },
			{ id=23109, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=7, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=1, name="Royal Shadow Draenite", colorType="PURPLE", quality=2 },
			{ id=23110, stat="ITEM_MOD_AGILITY_SHORT", val=3, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name="Shifting Shadow Draenite", colorType="PURPLE", quality=2 },
			{ id=23111, stat="ITEM_MOD_STRENGTH_SHORT", val=3, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name="Sovereign Shadow Draenite", colorType="PURPLE", quality=2 },
			{ id=31862, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=6, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name="Balanced Shadow Draenite", colorType="PURPLE", quality=2 },
			{ id=31864, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=6, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=1, name="Infused Shadow Draenite", colorType="PURPLE", quality=2 },
			{ id=32833, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=7, stat2="ITEM_MOD_SPIRIT_SHORT", val2=3, name="Purified Jaggal Pearl", colorType="PURPLE", quality=2 },
		},
		
		LEVELING_GREEN = {
		    -- ========================================================================
			-- [[ UNCOMMON (Leveling: Deep Peridot) ]]
			-- ========================================================================
			{ id=23103, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=3, stat2="ITEM_MOD_SPELL_PENETRATION_SHORT", val2=4, name="Radiant Deep Peridot", colorType="GREEN", quality=2 },
			{ id=23104, stat="ITEM_MOD_CRIT_RATING_SHORT", val=3, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name="Jagged Deep Peridot", colorType="GREEN", quality=2 },
			{ id=23105, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=3, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name="Enduring Deep Peridot", colorType="GREEN", quality=2 },
			{ id=23106, stat="ITEM_MOD_INTELLECT_SHORT", val=3, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=1, name="Dazzling Deep Peridot", colorType="GREEN", quality=2 },
		},

		PRISMATIC_P1 = {
			-- ========================================================================
			-- [[ PHASE 1: PRISMATIC ]]
			-- ========================================================================
			{ id=22459, stat="ITEM_MOD_ALL_RESISTANCE_SHORT", val=4, name="Void Sphere", colorType="PRISMATIC", quality=3 },
		},
		
		RED_P1 = {
			-- ========================================================================
			-- [[ RARE (Phase 1: Living Ruby) ]]
			-- ========================================================================
			{ id=24027, stat="ITEM_MOD_STRENGTH_SHORT", val=8, name="Bold Living Ruby", colorType="RED", quality=3 },
			{ id=24028, stat="ITEM_MOD_AGILITY_SHORT", val=8, name="Delicate Living Ruby", colorType="RED", quality=3 },
			{ id=24029, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=18, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=6, name="Teardrop Living Ruby", colorType="RED", quality=3 },
			{ id=24030, stat="ITEM_MOD_SPELL_POWER_SHORT", val=9, name="Runed Living Ruby", colorType="RED", quality=3 },
			{ id=24031, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=16, name="Bright Living Ruby", colorType="RED", quality=3 },
			{ id=24032, stat="ITEM_MOD_DODGE_RATING_SHORT", val=8, name="Subtle Living Ruby", colorType="RED", quality=3 },
			{ id=24036, stat="ITEM_MOD_PARRY_RATING_SHORT", val=8, name="Flashing Living Ruby", colorType="RED", quality=3 },
			-- PvP / Faction Gems
			{ id=27777, stat="ITEM_MOD_SPELL_POWER_SHORT", val=8, name="Stark Blood Garnet", colorType="RED", unique=true, quality=3 },
			{ id=28118, stat="ITEM_MOD_SPELL_POWER_SHORT", val=12, name="Runed Ornate Ruby", colorType="RED", unique=true, quality=3 },
			{ id=28360, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=14, name="Mighty Blood Garnet", colorType="RED", unique=true, quality=3 },
			{ id=28362, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=20, name="Bold Ornate Ruby", colorType="RED", unique=true, quality=3 },
			
			-- Heroic Dungeon Drops (Epic)
			{ id=30571, stat="ITEM_MOD_STRENGTH_SHORT", val=8, name="Don Rodrigo's Heart", colorType="RED", unique=true, quality=4 },
			{ id=30598, stat="ITEM_MOD_STRENGTH_SHORT", val=8, name="Don Amancio's Heart", colorType="RED", unique=true, quality=4 },
		},
		
		BLUE_P1 = {
			-- ========================================================================
			-- [[ RARE (Phase 1: Star of Elune) ]]
			-- ========================================================================
			{ id=24033, stat="ITEM_MOD_STAMINA_SHORT", val=12, name="Solid Star of Elune", colorType="BLUE", quality=3 },
			{ id=24035, stat="ITEM_MOD_SPIRIT_SHORT", val=8, name="Sparkling Star of Elune", colorType="BLUE", quality=3 },
			{ id=24037, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=3, name="Lustrous Star of Elune", colorType="BLUE", quality=3 },
			{ id=24039, stat="ITEM_MOD_SPELL_PENETRATION_SHORT", val=10, name="Stormy Star of Elune", colorType="BLUE", quality=3 },
			-- Special Drops / Zul'Aman (Epic)
			{ id=34256, stat="ITEM_MOD_STAMINA_SHORT", val=15, name="Charmed Amani Jewel", colorType="BLUE", unique=true, quality=4 },
		},
				
		YELLOW_P1 = {
			-- ========================================================================
			-- [[ RARE (Phase 1: Dawnstone) ]]
			-- ========================================================================
			{ id=24047, stat="ITEM_MOD_INTELLECT_SHORT", val=8, name="Brilliant Dawnstone", colorType="YELLOW", quality=3 },
			{ id=24048, stat="ITEM_MOD_CRIT_RATING_SHORT", val=8, name="Smooth Dawnstone", colorType="YELLOW", quality=3 },
			{ id=24050, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=8, name="Gleaming Dawnstone", colorType="YELLOW", quality=3 },
			{ id=24051, stat="ITEM_MOD_HIT_RATING_SHORT", val=8, name="Rigid Dawnstone", colorType="YELLOW", quality=3 },
			{ id=24052, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=8, name="Thick Dawnstone", colorType="YELLOW", quality=3 },
			{ id=24053, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=8, name="Mystic Dawnstone", colorType="YELLOW", quality=3 },
			{ id=31861, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=8, name="Great Dawnstone", colorType="YELLOW", quality=3 },
			{ id=35315, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=8, name="Quick Dawnstone", colorType="YELLOW", quality=3 },
			
			-- ========================================================================
            -- [[ UNIQUE-EQUIPPED (PvP, Faction) ]]
            -- ========================================================================
            { id=27679, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=10, name="Sublime Mystic Dawnstone", colorType="YELLOW", unique=true, quality=3 },
            { id=28119, stat="ITEM_MOD_CRIT_RATING_SHORT", val=10, name="Smooth Ornate Dawnstone", colorType="YELLOW", unique=true, quality=3 },
            { id=28120, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=10, name="Gleaming Ornate Dawnstone", colorType="YELLOW", unique=true, quality=3 },
            -- Faction Twins (Not Unique)
            { id=38546, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=10, name="Gleaming Ornate Dawnstone", colorType="YELLOW", quality=3 },
            { id=38550, stat="ITEM_MOD_CRIT_RATING_SHORT", val=10, name="Smooth Ornate Dawnstone", colorType="YELLOW", quality=3 },
        },
		
		ORANGE_P1 = {
            -- ========================================================================
            -- [[ RARE (Phase 1: Noble Topaz) ]]
            -- ========================================================================
            { id=24058, stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STRENGTH_SHORT", val2=4, name="Inscribed Noble Topaz", colorType="ORANGE", quality=3 },
            { id=24059, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=5, name="Potent Noble Topaz", colorType="ORANGE", quality=3 },
            { id=24060, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=9, stat2="ITEM_MOD_INTELLECT_SHORT", val2=4, name="Luminous Noble Topaz", colorType="ORANGE", quality=3 },
            { id=24061, stat="ITEM_MOD_HIT_RATING_SHORT", val=4, stat2="ITEM_MOD_AGILITY_SHORT", val2=4, name="Glinting Noble Topaz", colorType="ORANGE", quality=3 },
            { id=31867, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=4, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=5, name="Veiled Noble Topaz", colorType="ORANGE", quality=3 },
            { id=31868, stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_ATTACK_POWER_SHORT", val2=8, name="Wicked Noble Topaz", colorType="ORANGE", quality=3 },

            -- ========================================================================
            -- [[ UNIQUE-EQUIPPED (PvP & Heroic Fire Opals) ]]
            -- ========================================================================
            -- Phase 2 Unstable Raid Drops (Epic)
            { id=32634, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=8, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Unstable Amethyst", colorType="ORANGE", unique=true, quality=4 },
            { id=32635, stat="ITEM_MOD_INTELLECT_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Unstable Peridot", colorType="ORANGE", unique=true, quality=4 },
            { id=32636, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=9, stat2="ITEM_MOD_SPIRIT_SHORT", val2=4, name="Unstable Sapphire", colorType="ORANGE", unique=true, quality=4 },
            { id=32637, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=8, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=4, name="Unstable Citrine", colorType="ORANGE", unique=true, quality=4 },
            { id=32638, stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, stat2="ITEM_MOD_INTELLECT_SHORT", val2=4, name="Unstable Topaz", colorType="ORANGE", unique=true, quality=4 },
        
            -- PvP / Faction Gems (Rare)
            { id=28123, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val2=5, name="Potent Ornate Topaz", colorType="ORANGE", unique=true, quality=3 },
            { id=28363, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=5, name="Inscribed Ornate Topaz", colorType="ORANGE", unique=true, quality=3 },
            { id=38547, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=5, name="Inscribed Ornate Topaz", colorType="ORANGE", quality=3 }, -- Faction Twin
            { id=38548, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val2=5, name="Potent Ornate Topaz", colorType="ORANGE", quality=3 }, -- Faction Twin

            -- Heroic Dungeon Drops (Epic)
            { id=30601, stat="ITEM_MOD_DODGE_RATING_SHORT", val=5, stat2="ITEM_MOD_RESILIENCE_RATING_SHORT", val2=4, name="Beaming Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30547, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_INTELLECT_SHORT", val2=4, name="Luminous Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30584, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=4, name="Enscribed Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30585, stat="ITEM_MOD_AGILITY_SHORT", val=4, stat2="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val2=5, name="Glistening Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30587, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val2=4, name="Champion's Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30588, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val2=4, name="Potent Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30553, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name="Pristine Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30554, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=5, stat2="ITEM_MOD_DODGE_RATING_SHORT", val2=4, name="Stalwart Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30559, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name="Etched Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30604, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_RESILIENCE_RATING_SHORT", val2=4, name="Resplendent Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30607, stat="ITEM_MOD_PARRY_RATING_SHORT", val=5, stat2="ITEM_MOD_RESILIENCE_RATING_SHORT", val2=4, name="Splendid Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30551, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_INTELLECT_SHORT", val2=4, name="Infused Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30591, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=8, stat2="ITEM_MOD_RESILIENCE_RATING_SHORT", val2=5, name="Empowered Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30558, stat="ITEM_MOD_PARRY_RATING_SHORT", val=5, stat2="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val2=4, name="Glimmering Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30556, stat="ITEM_MOD_AGILITY_SHORT", val=5, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name="Glinting Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30582, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=8, stat2="ITEM_MOD_CRIT_RATING_SHORT", val2=5, name="Deadly Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30575, stat="ITEM_MOD_DODGE_RATING_SHORT", val=5, stat2="ITEM_MOD_HIT_RATING_SHORT", val2=4, name="Nimble Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30581, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_RESILIENCE_RATING_SHORT", val2=4, name="Durable Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30573, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_SPELL_PENETRATION_SHORT", val2=5, name="Mysterious Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30565, stat="ITEM_MOD_CRIT_RATING_SHORT", val=6, stat2="ITEM_MOD_DODGE_RATING_SHORT", val2=5, name="Assassin's Fire Opal", colorType="ORANGE", unique=true, quality=4 },
            { id=30564, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_HIT_SPELL_RATING_SHORT", val2=5, name="Shining Fire Opal", colorType="ORANGE", unique=true, quality=4 },
        },
		
		PURPLE_P1 = {
            -- ========================================================================
            -- [[ RARE (Phase 1: Nightseye & Shadow Pearl) ]]
            -- ========================================================================
            { id=24054, stat="ITEM_MOD_STRENGTH_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Sovereign Nightseye", colorType="PURPLE", quality=3 },
            { id=24055, stat="ITEM_MOD_AGILITY_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Shifting Nightseye", colorType="PURPLE", quality=3 },
            { id=24056, stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Glowing Nightseye", colorType="PURPLE", quality=3 },
            { id=24057, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=9, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Royal Nightseye", colorType="PURPLE", quality=3 },
            { id=31863, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=8, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Balanced Nightseye", colorType="PURPLE", quality=3 },
            { id=31865, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=8, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Infused Nightseye", colorType="PURPLE", quality=3 },
            { id=32836, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=9, stat2="ITEM_MOD_SPIRIT_SHORT", val2=4, name="Purified Shadow Pearl", colorType="PURPLE", quality=3 },
            { id=35707, stat="ITEM_MOD_DODGE_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Regal Nightseye", colorType="PURPLE", quality=3 },

            -- ========================================================================
            -- [[ UNIQUE-EQUIPPED (Heroic Tanzanites) & BoP (Karazhan) ]]
            -- ========================================================================
            { id=30600, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_SPIRIT_SHORT", val2=4, name="Fluorescent Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            { id=30546, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Sovereign Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            { id=30552, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Blessed Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            { id=30563, stat="ITEM_MOD_DODGE_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Regal Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            { id=30603, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Royal Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            { id=30549, stat="ITEM_MOD_AGILITY_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Shifting Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            { id=30555, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Glowing Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            { id=30574, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Brutal Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            { id=30572, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=9, stat2="ITEM_MOD_SPIRIT_SHORT", val2=5, name="Imperial Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            { id=30566, stat="ITEM_MOD_PARRY_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Defender's Tanzanite", colorType="PURPLE", unique=true, quality=4 },
            
            -- Quest Rewards (Karazhan)
            { id=31116, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Infused Amethyst", colorType="PURPLE", unique=true, quality=4 }, 
			{ id=31117, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Soothing Amethyst", colorType="PURPLE", unique=true, quality=4 }, 
			{ id=31118, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Pulsing Amethyst", colorType="PURPLE", unique=true, quality=4 },
		},
        
        GREEN_P1 = {
            -- ========================================================================
            -- [[ RARE (Phase 1: Talasite) ]]
            -- ========================================================================
            { id=24062, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Enduring Talasite", colorType="GREEN", quality=3 },
            { id=24065, stat="ITEM_MOD_INTELLECT_SHORT", val=4, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Dazzling Talasite", colorType="GREEN", quality=3 },
            { id=24066, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_SPELL_PENETRATION_SHORT", val2=5, name="Radiant Talasite", colorType="GREEN", quality=3 },
            { id=24067, stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Jagged Talasite", colorType="GREEN", quality=3 },
            { id=33782, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Steady Talasite", colorType="GREEN", quality=3 },
            { id=35318, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Forceful Talasite", colorType="GREEN", quality=3 },

            -- ========================================================================
            -- [[ UNIQUE-EQUIPPED / BoP (Heroics, Faction & Phase 2 Raid) ]]
            -- ========================================================================
            { id=32639, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name="Unstable Talasite", colorType="GREEN", unique=true, quality=4 },
        
            -- PvP / Faction Gems
            { id=27785, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=3, name="Notched Deep Peridot", colorType="GREEN", unique=true, quality=3 },
            { id=27786, stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=3, name="Barbed Deep Peridot", colorType="GREEN", unique=true, quality=3 },
            { id=27809, stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=3, name="Barbed Deep Peridot", colorType="GREEN", unique=true, quality=3 }, 
            { id=27820, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=3, name="Notched Deep Peridot", colorType="GREEN", unique=true, quality=3 }, 
            
            -- Phase 2 Unstable Raid Drop
            { id=32639, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=4, stat2="ITEM_MOD_STAMINA_SHORT", val2=4, name="Unstable Talasite", colorType="GREEN", unique=true, quality=4 }, 

            -- Heroic Dungeon Drops
            { id=30594, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=5, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Effulgent Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30592, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Steady Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30602, stat="ITEM_MOD_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Jagged Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30548, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Polished Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30583, stat="ITEM_MOD_INTELLECT_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Timeless Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30586, stat="ITEM_MOD_INTELLECT_SHORT", val=4, stat2="ITEM_MOD_SPIRIT_SHORT", val2=5, name="Seer's Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30560, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Rune Covered Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30605, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Vivid Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30606, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=5, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Lambent Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30608, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_SPELL_PENETRATION_SHORT", val2=5, name="Radiant Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30550, stat="ITEM_MOD_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Sundered Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30589, stat="ITEM_MOD_INTELLECT_SHORT", val=5, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Dazzling Chrysoprase", colorType="GREEN", unique=true, quality=4 },
            { id=30590, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=6, name="Enduring Chrysoprase", colorType="GREEN", unique=true, quality=4 },
        },
		
		META_P1 = {
		    -- ========================================================================
			-- [[ PHASE 1: STANDARD METAS ]]
			-- ========================================================================
			{ id=25890, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=14, special=MSC.L["1% Spell Reflect"], name="Destructive Skyfire Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=25893, special=MSC.L["Chance to Increase Spell Cast Speed"], name="Mystical Skyfire Diamond", isMeta=true, colorType="META", quality=3 }, 
			{ id=25894, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=24, special=MSC.L["Minor Run Speed"], name="Swift Skyfire Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=25895, stat="ITEM_MOD_CRIT_RATING_SHORT", val=12, special=MSC.L["5% Snare/Root Resist"], name="Enigmatic Skyfire Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=25896, stat="ITEM_MOD_STAMINA_SHORT", val=18, special=MSC.L["5% Stun Resist"], name="Powerful Earthstorm Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=25897, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=26, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=9, special=MSC.L["2% Reduced Threat"], name="Bracing Earthstorm Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=25898, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=12, special=MSC.L["Chance to Restore 120-180 HP on melee"], name="Tenacious Earthstorm Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=25899, stat="ITEM_MOD_DAMAGE_PER_SECOND_SHORT", val=3, special=MSC.L["Chance to Stun Target"], name="Brutal Earthstorm Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=25901, stat="ITEM_MOD_INTELLECT_SHORT", val=12, special=MSC.L["5% chance to restore 300 mana"], name="Insightful Earthstorm Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=32409, stat="ITEM_MOD_AGILITY_SHORT", val=12, special=MSC.L["3% Increased Crit Damage"], name="Relentless Earthstorm Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=32410, special=MSC.L["Chance for +240 Melee/Ranged Haste (6s, 40s CD)"], name="Thundering Skyfire Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=34220, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=12, special=MSC.L["3% Increased Crit Damage"], name="Chaotic Skyfire Diamond", isMeta=true, colorType="META", quality=3 },
			{ id=28556, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=20, special=MSC.L["Minor Run Speed"], name="Swift Windfire Diamond", isMeta=true, colorType="META", unique=true, quality=3 },
            { id=28557, stat="ITEM_MOD_SPELL_POWER_SHORT", val=12, special=MSC.L["Minor Run Speed"], name="Swift Starfire Diamond", isMeta=true, colorType="META", unique=true, quality=4 },
            { id=32640, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=24, special=MSC.L["5% Stun Resistance"], name="Potent Unstable Diamond", isMeta=true, colorType="META", unique=true, quality=4 },
            { id=32641, stat="ITEM_MOD_SPELL_POWER_SHORT", val=14, special=MSC.L["5% Stun Resistance"], name="Imbued Unstable Diamond", isMeta=true, colorType="META", unique=true, quality=4 },
        },
		
		RED_P3 = {
		    -- ========================================================================
			-- [[ EPIC (Phase 3: Crimson Spinel) ]]
			-- ========================================================================
			{ id=32193, stat="ITEM_MOD_STRENGTH_SHORT", val=10, name="Bold Crimson Spinel", colorType="RED", quality=4 },
			{ id=32194, stat="ITEM_MOD_AGILITY_SHORT", val=10, name="Delicate Crimson Spinel", colorType="RED", quality=4 },
			{ id=32195, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=22, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=8, name="Teardrop Crimson Spinel", colorType="RED", quality=4 },
			{ id=32196, stat="ITEM_MOD_SPELL_POWER_SHORT", val=12, name="Runed Crimson Spinel", colorType="RED", quality=4 },
			{ id=32197, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=20, name="Bright Crimson Spinel", colorType="RED", quality=4 },
			{ id=32198, stat="ITEM_MOD_DODGE_RATING_SHORT", val=10, name="Subtle Crimson Spinel", colorType="RED", quality=4 },
			{ id=32199, stat="ITEM_MOD_PARRY_RATING_SHORT", val=10, name="Flashing Crimson Spinel", colorType="RED", quality=4 },
		},
		
		BLUE_P3 = {
			-- ========================================================================
			-- [[ EPIC (Phase 3: Empyrean Sapphire) ]]
			-- ========================================================================
			{ id=32200, stat="ITEM_MOD_STAMINA_SHORT", val=15, name="Solid Empyrean Sapphire", colorType="BLUE", quality=4 },
			{ id=32201, stat="ITEM_MOD_SPIRIT_SHORT", val=10, name="Sparkling Empyrean Sapphire", colorType="BLUE", quality=4 },
			{ id=32202, stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=4, name="Lustrous Empyrean Sapphire", colorType="BLUE", quality=4 },
			{ id=32203, stat="ITEM_MOD_SPELL_PENETRATION_SHORT", val=13, name="Stormy Empyrean Sapphire", colorType="BLUE", quality=4 },
		},
		
		YELLOW_P3 = {
			-- ========================================================================
            -- [[ EPIC (Phase 3: Lionseye) ]]
            -- ========================================================================
            { id=32204, stat="ITEM_MOD_INTELLECT_SHORT", val=10, name="Brilliant Lionseye", colorType="YELLOW", quality=4 },
            { id=32205, stat="ITEM_MOD_CRIT_RATING_SHORT", val=10, name="Smooth Lionseye", colorType="YELLOW", quality=4 },
            { id=32206, stat="ITEM_MOD_HIT_RATING_SHORT", val=10, name="Rigid Lionseye", colorType="YELLOW", quality=4 },
            { id=32207, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=10, name="Gleaming Lionseye", colorType="YELLOW", quality=4 },
            { id=32208, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=10, name="Thick Lionseye", colorType="YELLOW", quality=4 },
            { id=32209, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=10, name="Mystic Lionseye", colorType="YELLOW", quality=4 },
            { id=32210, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=10, name="Great Lionseye", colorType="YELLOW", quality=4 },
		},
		
		ORANGE_P3 = {
		    -- ========================================================================
			-- [[ EPIC (Phase 3: Pyrestone) ]]
			-- ========================================================================
			{ id=32217, stat="ITEM_MOD_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_STRENGTH_SHORT", val2=5, name="Inscribed Pyrestone", colorType="ORANGE", quality=4 },
			{ id=32218, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=6, name="Potent Pyrestone", colorType="ORANGE", quality=4 },
			{ id=32219, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_INTELLECT_SHORT", val2=5, name="Luminous Pyrestone", colorType="ORANGE", quality=4 },
			{ id=32220, stat="ITEM_MOD_HIT_RATING_SHORT", val=5, stat2="ITEM_MOD_AGILITY_SHORT", val2=5, name="Glinting Pyrestone", colorType="ORANGE", quality=4 },
			{ id=32221, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=5, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=6, name="Veiled Pyrestone", colorType="ORANGE", quality=4 },
			{ id=32222, stat="ITEM_MOD_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_ATTACK_POWER_SHORT", val2=10, name="Wicked Pyrestone", colorType="ORANGE", quality=4 },
		},
		
		PURPLE_P3 = {
		    -- ========================================================================
            -- [[ EPIC (Phase 3: Shadowsong Amethyst) ]]
            -- ========================================================================
            { id=32211, stat="ITEM_MOD_STRENGTH_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name="Sovereign Shadowsong Amethyst", colorType="PURPLE", quality=4 },
            { id=32212, stat="ITEM_MOD_AGILITY_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name="Shifting Shadowsong Amethyst", colorType="PURPLE", quality=4 },
            { id=32213, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name="Balanced Shadowsong Amethyst", colorType="PURPLE", quality=4 },
            { id=32214, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Infused Shadowsong Amethyst", colorType="PURPLE", quality=4 },
            { id=32215, stat="ITEM_MOD_SPELL_POWER_SHORT", val=6, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name="Glowing Shadowsong Amethyst", colorType="PURPLE", quality=4 },
            { id=32216, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Royal Shadowsong Amethyst", colorType="PURPLE", quality=4 },
		
		},
		
		GREEN_P3 = {
		    -- ========================================================================
			-- [[ EPIC (Phase 3: Seaspray Emerald) ]]
			-- ========================================================================
			{ id=32223, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name="Enduring Seaspray Emerald", colorType="GREEN", quality=4 },
			{ id=32224, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_SPELL_PENETRATION_SHORT", val2=6, name="Radiant Seaspray Emerald", colorType="GREEN", quality=4 },
			{ id=32225, stat="ITEM_MOD_INTELLECT_SHORT", val=5, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", val2=2, name="Dazzling Seaspray Emerald", colorType="GREEN", quality=4 },
			{ id=32226, stat="ITEM_MOD_CRIT_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name="Jagged Seaspray Emerald", colorType="GREEN", quality=4 },
		},
		
		META_P3 = {
		
		},
		
		RED_P5 = {
		
		},
		
		BLUE_P5 = {
		
		},
		
		YELLOW_P5 = {
		    -- ========================================================================
			-- [[ EPIC (Phase 5: Lionseye) ]]
			-- ========================================================================
			{ id=35761, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=10, name="Quick Lionseye", colorType="YELLOW", quality=4 },	
		},
		
		ORANGE_P5 = {
		    -- ========================================================================
			-- [[ RARE (Phase 5: Noble Topaz) ]]
			-- ========================================================================
			{ id=35316, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=4, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=5, name="Reckless Noble Topaz", colorType="ORANGE", quality=3 },
			-- ========================================================================
			-- [[ EPIC (Phase 5: Pyrestone) ]]
			-- ========================================================================
			{ id=35760, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=5, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=6, name="Reckless Pyrestone", colorType="ORANGE", quality=4 },
		},
		
		PURPLE_P5 = {
		    -- ========================================================================
			-- [[ EPIC (Phase 5: Shadowsong Amethyst) ]]
			-- ========================================================================
			{ id=37503, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=11, stat2="ITEM_MOD_SPIRIT_SHORT", val2=5, name="Purified Shadowsong Amethyst", colorType="PURPLE", quality=4 },
		},
		
		GREEN_P5 = {
		    -- ========================================================================
			-- [[ EPIC (Phase 5: Seaspray Emerald) ]]
			-- ========================================================================
			{ id=35758, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name="Steady Seaspray Emerald", colorType="GREEN", quality=4 },
			{ id=35759, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=5, stat2="ITEM_MOD_STAMINA_SHORT", val2=7, name="Forceful Seaspray Emerald", colorType="GREEN", quality=4 },
		},
		
		META_P5 = {
			-- ========================================================================
            -- [[ PHASE 5 METAS ]]
            -- ========================================================================
			{ id=35501, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=12, special=MSC.L["+10% Shield Block Value"], name="Eternal Earthstorm Diamond", isMeta=true, colorType="META", quality=3 },
            { id=35503, stat="ITEM_MOD_SPELL_POWER_SHORT", val=14, special=MSC.L["+2% Intellect"], name="Ember Skyfire Diamond", isMeta=true, colorType="META", quality=3 },	
		},
		
		JC_RED = {
			-- ========================================================================
			-- [[JC-Only UNIQUE-EQUIPPED ]]
			-- ========================================================================
			{ id=33131, stat="ITEM_MOD_ATTACK_POWER_SHORT", val=24, name="Crimson Sun", colorType="RED", unique=true, isJC=true, quality=4 },
			{ id=33132, stat="ITEM_MOD_AGILITY_SHORT", val=12, name="Delicate Fire Ruby", colorType="RED", unique=true, isJC=true, quality=4 },
			{ id=33133, stat="ITEM_MOD_SPELL_POWER_SHORT", val=14, name="Don Julio's Heart", colorType="RED", unique=true, isJC=true, quality=4 },
			{ id=33134, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=26, stat2="ITEM_MOD_SPELL_POWER_SHORT", val2=9, name="Kailee's Rose", colorType="RED", unique=true, isJC=true, quality=4 },
		},
		
		JC_BLUE = {
			-- ========================================================================
			-- [[JC-Only UNIQUE-EQUIPPED ]]
			-- ========================================================================
		    { id=33135, stat="ITEM_MOD_STAMINA_SHORT", val=18, name="Falling Star", colorType="BLUE", unique=true, isJC=true, quality=4 },
			{ id=33137, stat="ITEM_MOD_SPIRIT_SHORT", val=12, name="Sparkling Falling Star", colorType="BLUE", unique=true, isJC=true, quality=4 },
		},
		
		JC_YELLOW = {
			-- ========================================================================
			-- [[JC-Only UNIQUE-EQUIPPED ]]
			-- ========================================================================
			{ id=33138, stat="ITEM_MOD_RESILIENCE_RATING_SHORT", val=12, name="Mystic Bladestone", colorType="YELLOW", unique=true, isJC=true, quality=4 },
			{ id=33139, stat="ITEM_MOD_INTELLECT_SHORT", val=12, name="Brilliant Bladestone", colorType="YELLOW", unique=true, isJC=true, quality=4 },
			{ id=33140, stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=12, name="Blood of Amber", colorType="YELLOW", unique=true, isJC=true, quality=4 },
			{ id=33141, stat="ITEM_MOD_HIT_SPELL_RATING_SHORT", val=12, name="Great Bladestone", colorType="YELLOW", unique=true, isJC=true, quality=4 },
			{ id=33142, stat="ITEM_MOD_HIT_RATING_SHORT", val=12, name="Rigid Bladestone", colorType="YELLOW", unique=true, isJC=true, quality=4 },
			{ id=33143, stat="ITEM_MOD_CRIT_RATING_SHORT", val=12, name="Stone of Blades", colorType="YELLOW", unique=true, isJC=true, quality=4 },
			{ id=33144, stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=12, name="Facet of Eternity", colorType="YELLOW", unique=true, isJC=true, quality=4 },
		},
	}

-- [[ CONSTRUCT OPTIONS PROGRAMMATICALLY (TBC ONLY) ]]
    local function AddTo(targetList, sourceList, defaultQuality)
        if not sourceList then return end
        for _, gem in ipairs(sourceList) do
            local copy = {}
            for k, v in pairs(gem) do copy[k] = v end
            
            if not copy.quality then
                if string.find(copy.name, "Tourmaline") or string.find(copy.name, "Zircon") or string.find(copy.name, "Amber") then
                    copy.quality = 1
                elseif string.find(copy.name, "Blood Garnet") or string.find(copy.name, "Azure Moonstone") or string.find(copy.name, "Golden Draenite") or string.find(copy.name, "Flame Spessarite") or string.find(copy.name, "Shadow Draenite") or string.find(copy.name, "Deep Peridot") or string.find(copy.name, "Jaggal Pearl") or string.find(copy.name, "Sphere") then
                    copy.quality = 2
                else
                    copy.quality = defaultQuality or 3
                end
            end
            
            table.insert(targetList, copy)
        end
    end

    function MSC:BuildGemOptionsForPhase(phase)
        phase = tonumber(phase) or 1

        MSC.GemOptions = {
            EMPTY_SOCKET_RED = {}, EMPTY_SOCKET_YELLOW = {}, EMPTY_SOCKET_BLUE = {},
            EMPTY_SOCKET_META = {}, PRISMATIC_GEMS = {}
        }
        MSC.GemOptions_Leveling = {
            EMPTY_SOCKET_RED = {}, EMPTY_SOCKET_YELLOW = {}, EMPTY_SOCKET_BLUE = {},
            EMPTY_SOCKET_META = GEMS.META_P1, PRISMATIC_GEMS = {}
        }

        AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.LEVELING_RED)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.RED_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.LEVELING_ORANGE)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.ORANGE_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.LEVELING_PURPLE)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.PURPLE_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.PRISMATIC_P1)

        AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_YELLOW)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.YELLOW_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_ORANGE)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.ORANGE_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_GREEN)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.GREEN_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.PRISMATIC_P1)

        AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.LEVELING_BLUE)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.BLUE_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.LEVELING_PURPLE)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.PURPLE_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.LEVELING_GREEN)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.GREEN_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.PRISMATIC_P1)

        AddTo(MSC.GemOptions.EMPTY_SOCKET_META, GEMS.META_P1)
        AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.LEVELING_PRISMATIC)
        AddTo(MSC.GemOptions.PRISMATIC_GEMS, GEMS.PRISMATIC_P1)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.JC_RED)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.JC_BLUE)
        AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.JC_YELLOW)

        AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_RED, GEMS.LEVELING_RED)
        AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_RED, GEMS.LEVELING_ORANGE)
        AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_RED, GEMS.LEVELING_PURPLE)
        AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_YELLOW)
        AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_ORANGE)
        AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_YELLOW, GEMS.LEVELING_GREEN)
        AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_BLUE, GEMS.LEVELING_BLUE)
        AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_BLUE, GEMS.LEVELING_PURPLE)
        AddTo(MSC.GemOptions_Leveling.EMPTY_SOCKET_BLUE, GEMS.LEVELING_GREEN)
        AddTo(MSC.GemOptions_Leveling.PRISMATIC_GEMS, GEMS.LEVELING_RED)
        AddTo(MSC.GemOptions_Leveling.PRISMATIC_GEMS, GEMS.LEVELING_BLUE)
        AddTo(MSC.GemOptions_Leveling.PRISMATIC_GEMS, GEMS.LEVELING_YELLOW)

        if phase >= 3 then
            AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.RED_P3)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.ORANGE_P3)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.PURPLE_P3)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.YELLOW_P3)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.ORANGE_P3)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.GREEN_P3)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.BLUE_P3)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.PURPLE_P3)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.GREEN_P3)
        end

        if phase >= 5 then
            AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.RED_P5)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.ORANGE_P5)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_RED, GEMS.PURPLE_P5)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.YELLOW_P5)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.ORANGE_P5)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_YELLOW, GEMS.GREEN_P5)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.BLUE_P5)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.PURPLE_P5)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_BLUE, GEMS.GREEN_P5)
            AddTo(MSC.GemOptions.EMPTY_SOCKET_META, GEMS.META_P5)
        end

        MSC.GemIDCache = {}
        if MSC.BuildGemCache then MSC:BuildGemCache() end
    end

    MSC:BuildGemOptionsForPhase(1)

else
    -- [[ VANILLA FALLBACK (Empty Tables) ]]
    MSC.GemOptions = {
        EMPTY_SOCKET_RED = {}, EMPTY_SOCKET_YELLOW = {}, EMPTY_SOCKET_BLUE = {},
        EMPTY_SOCKET_META = {}, PRISMATIC_GEMS = {}
    }
    MSC.GemOptions_Leveling = {
        EMPTY_SOCKET_RED = {}, EMPTY_SOCKET_YELLOW = {}, EMPTY_SOCKET_BLUE = {},
        EMPTY_SOCKET_META = {}, PRISMATIC_GEMS = {}
    }
end

-- ============================================================================
-- 4. ITEM OVERRIDES (Manual Stats for "Use" & "Proc" Items)
-- Lookup order at runtime: ProcDB -> WeaponDB -> TrinketDB (Helpers GetRawItemStats);
-- ItemOverrides / TrinketDB here for Parse tooltip notes and class-specific overrides.
-- ============================================================================
MSC.ItemOverrides = MSC.ItemOverrides or {}
MSC.TrinketDB = MSC.TrinketDB or {}

-- This function feeds BOTH the Math Engine and the Tooltip Notes!
local function AddOverrides(db)
    for itemID, data in pairs(db) do
        data.estimate = true -- Forces the addon to apply our math!
        MSC.ItemOverrides[itemID] = data
        MSC.TrinketDB[itemID] = data
    end
end

AddOverrides({

	[30542] = { note = MSC.L["Use: Teleport (8 possible malfunctions!)"] },
	[28789] = { note = MSC.L["Proc: 170 SP (On Resist Only)"] }, 
	[34471] = { note = MSC.L["Passive: 15 mp5 + Heal Battery"] },
	[30449] = { note = MSC.L["Pet Proc"] }, 
	[11811] = { note = MSC.L["Passive: Resistances not valued"] },
	
    -- [[ WEAPONS & CHAMPION ]]
    [9449]  = { _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=150 }, note = MSC.L["Use: 50% Haste - Burst Value"] },
    [8345]  = { _AUTO_PROC = { stat="ITEM_MOD_FERAL_ATTACK_POWER_SHORT", val=80 }, note = MSC.L["Powershift: Energy Refund valued as 80 AP"] },
	
	[833] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_REGENERATION_SHORT", val=1.38 }, note = MSC.L["Use: 500 Avg Heal (30m CD)"] }, -- Lifestone
	[11819] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=1.67 }, note = MSC.L["Use: 1.67 Avg mp5 (15m CD)"] },
    [11832] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=2.8 }, note = MSC.L["Use: ~2.8 Avg mp5 from cost reduction (15m CD)"] },-- Burst of Knowledge: Assuming ~5 casts in 10s = 500 mana saved. Over 15m (900s), 500 / 180 = 2.8 MP5.
    [17759] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_REGENERATION_SHORT", val=1.39 }, note = MSC.L["Use: ~1.4 Avg hp5 (30m CD)"] },
    [21777] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=12 }, note = MSC.L["Use: 12 Avg mp5 (5m CD)"] }, 
	[24390] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=6 }, note = MSC.L["Use: 6 Avg mp5 (3m CD)"] }, -- Auslese's Light Channeler (215 Mana / 180s)
    [30841] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=18.3 }, note = MSC.L["Use: ~18.3 Avg mp5 from cost reduction (1m CD)"] },-- Lower City Prayerbook: Assuming ~10 casts during the 15s window = 220 mana saved. 220 mana / 60s CD = 18.3 mp5
	
    -- Pet/Minor damage effects assigned proxy Spell Power or Attack Power equivalents.
    [18354] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=10 }, note = MSC.L["Equip: Imp Firebolt Dmg +8.1 (10 SP Proxy)"] }, 
    [18355] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=20 }, note = MSC.L["Equip: Pet Dmg +4% (20 AP Proxy)"] },
    [18815] = { note = MSC.L["Equip: 13 Fire Thorns (not scored)"] }, -- Essence of the Pure Flame: thorns neither heal nor scale with Spell Power 
    [18951] = { _AUTO_PROC = { stat="ITEM_MOD_AGILITY_SHORT", val=1 }, note = MSC.L["Equip: Reduced Fall Dmg (1 Agi Proxy)"] }, 

    -- Direct Damage: (Avg Dmg / Cooldown Seconds) = DPS. DPS * 14 = AP Equivalent.
    [23836] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=140 }, note = MSC.L["Use: 1200 Dmg (2m CD / ~140 AP Proxy)"] }, -- 10 DPS * 14
    [10577] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=10.5 }, note = MSC.L["Use: 450 AoE Dmg (10m CD / ~10.5 AP Proxy)"] }, -- 0.75 DPS * 14
    
    -- Small token utility scores so they don't read as 0.
    [21756] = { _AUTO_PROC = { stat="ITEM_MOD_AGILITY_SHORT", val=5 }, note = MSC.L["Use: 30% Speed + Snare Immune (5 Agi Proxy)"] }, 
    [21758] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=4.5 }, note = MSC.L["Use: 4.5 Avg AP (5m CD)"] }, 

    -- Damage Reduction -> Block Value Proxy: DR * (Duration / Cooldown).
    [21760] = { _AUTO_PROC = { stat="ITEM_MOD_BLOCK_VALUE_SHORT", val=1.33 }, note = MSC.L["Use: 1.33 Avg DR (5m CD / Block Proxy)"] }, -- 20 DR * (20s/300s)
    [21763] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=14 }, note = MSC.L["Use: Summon Truesilver Boar (14 AP Proxy)"] }, -- Assuming ~1 DPS avg over 15m
    [21784] = { _AUTO_PROC = { stat="ITEM_MOD_BLOCK_VALUE_SHORT", val=2.33 }, note = MSC.L["Use: 2.33 Avg DR (5m CD / Block Proxy)"] }, -- 35 DR * (20s/300s)
    [22954] = { _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=25 }, note = MSC.L["Use: 25 Avg Haste (2m CD)"] }, 
    [23001] = { _AUTO_PROC = { stat="ITEM_MOD_AGILITY_SHORT", val=5 }, note = MSC.L["Use: Threat Reduction (5 Agi Proxy)"] }, 
    [23040] = { _AUTO_PROC = { stat="ITEM_MOD_BLOCK_VALUE_SHORT", val=39.2 }, note = MSC.L["Use: 39.2 Avg Block Value (2m CD)"] },

	-- Procs and Proxies
    [22321] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=35 }, note = MSC.L["Equip: Fire Dmg Proc (~35 AP Proxy)"] }, -- Heart of Wyrmthalak (Assuming ~1 PPM)
    
    -- Conditional vs Undead/Demons (Calculated at full value, note explains condition)
    [23206] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=150 }, note = MSC.L["Equip: 150 AP (vs Undead/Demons)"] }, -- Mark of the Champion (Melee)
    [23207] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=85 }, note = MSC.L["Equip: 85 SP (vs Undead/Demons)"] }, -- Mark of the Champion (Caster)

    -- Standard Cooldown Averages (Stat * Duration / CD)
    [23041] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=43.3 }, note = MSC.L["Use: 43.3 Avg AP (2m CD)"] }, -- Slayer's Crest (260 AP / 20s / 120s)
    [23046] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=21.7 }, note = MSC.L["Use: 21.7 Avg SP (2m CD)"] }, -- Restrained Essence of Sapphiron (130 SP / 20s / 120s)
    [24124] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=20 }, note = MSC.L["Use: Summon Felsteel Boar (20 AP Proxy)"] }, -- Figurine - Felsteel Boar
    [28288] = { _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=21.7 }, note = MSC.L["Use: 21.7 Avg Haste (2m CD)"] }, -- Abacus of Violent Odds (Item ID)
    [29383] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=46.3 }, note = MSC.L["Use: 46.3 Avg AP (2m CD)"] }, -- Bloodlust Brooch (278 AP / 20s / 120s)
    [29776] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=33.3 }, note = MSC.L["Use: 33.3 Avg AP (2m CD)"] }, -- Core of Ar'kelos (200 AP / 20s / 120s)
    [30293] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=39.7 }, note = MSC.L["Use: 39.7 Avg Heal / 13.2 Avg SP (90s CD)"] }, -- Heavenly Inspiration (238 Heal / 15s / 90s)
    [30665] = { _AUTO_PROC = { stat="ITEM_MOD_SPIRIT_SHORT", val=50 }, note = MSC.L["Use: 50 Avg Spirit (2m CD)"] }, -- Earring of Soulful Meditation (300 Spirit / 20s / 120s)
    
	-- Charge-based Cooldowns
    [23047] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=37.5 }, note = MSC.L["Use: 5 Spell Charges (37.5 Avg Heal Proxy / 2m CD)"] }, -- Eye of the Dead (450 Heal * 5)
    
    -- Identical Faction Quest Rewards
    [25619] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=17.3 }, note = MSC.L["Use: 17.3 Avg SP (2m CD)"] }, -- Glowing Crystal Insignia (Horde)
    [25620] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=17.3 }, note = MSC.L["Use: 17.3 Avg SP (2m CD)"] }, -- Ancient Crystal Talisman (Alliance)
    
    -- Identical Faction PvP Trinkets
    [25628] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=23.1 }, note = MSC.L["Use: 23.1 Avg AP (2m CD)"] }, -- Ogre Mauler's Badge (185 AP / 15s / 120s)
    [25633] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=23.1 }, note = MSC.L["Use: 23.1 Avg AP (2m CD)"] }, -- Uniting Charm (185 AP / 15s / 120s)
    
    [25634] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=35.5 }, note = MSC.L["Use: 35.5 Avg Heal / 11.8 Avg SP (2m CD)"] }, -- Oshu'gun Relic (213 Heal / 20s / 120s)
    [27828] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=47 }, note = MSC.L["Use: 47 Avg Heal / 15.6 Avg SP (2m CD)"] }, -- Warp-Scarab Brooch (282 Heal / 20s / 120s)
    
    -- Conditional On-Kill Restores (Assumes optimal usage on Cooldown for Max Potential)
    [26055] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=37.5 }, note = MSC.L["Use: 37.5 Max mp5 (Requires Killingblow / 2m CD)"] }, -- Oculus of the Hidden Eye (900 Mana / 120s)
    [27416] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_REGENERATION_SHORT", val=37.5 }, note = MSC.L["Use: 37.5 Max hp5 (Requires Killingblow / 2m CD)"] }, -- Fetish of the Fallen (900 Health / 120s)
    [28108] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=100 }, note = MSC.L["Equip: 100 Max mp5 (Requires Killingblows / 10s CD)"] }, -- Power Infused Mushroom
    [28109] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_REGENERATION_SHORT", val=100 }, note = MSC.L["Equip: 100 Max hp5 (Requires Killingblows / 10s CD)"] }, -- Essence Infused Mushroom
  
    -- Faction Equivalent Proc Trinkets
    [27920] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=10 }, note = MSC.L["Equip: Melee Heal or Ranged Mana Proc (~10 mp5 Proxy)"] }, -- Mark of Conquest
    [27921] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=10 }, note = MSC.L["Equip: Melee Heal or Ranged Mana Proc (~10 mp5 Proxy)"] }, -- Mark of Conquest

    -- Stacking/Complex Healing Cooldowns
    -- Ribbon of Sacrifice: Max stacks yield 150 bonus healing received. Very hard to average, assigning proxy.
    [28590] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=30 }, note = MSC.L["Use: Stacking Heal Bonus (~30 Heal Proxy)"] },

    -- Class Specific / Unique Procs
    [30446] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=70 }, note = MSC.L["Equip: +70 AP to Battle Shout"] }, -- Solarian's Sapphire (Warrior)
    [30448] = { _AUTO_PROC = { stat="ITEM_MOD_RANGED_ATTACK_POWER_SHORT", val=40 }, note = MSC.L["Equip: Shot Dmg Bonus (~40 RAP Proxy)"] }, -- Talon of Al'ar (Hunter)
    [30621] = { _AUTO_PROC = { stat="ITEM_MOD_AGILITY_SHORT", val=5 }, note = MSC.L["Equip: Threat Reduction on Crits (5 Agi Proxy)"] }, -- Prism of Inner Calm
    [30720] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=28.1 }, note = MSC.L["Equip: 28.1 Avg SP / ~25 mp5 via Mana Gems"] },-- Serpent-Coil Braid (Mage): Gems have 2m CD. 225 SP / 15s / 120s = 28.1 SP. 25% gem mana is ~600 extra mana every 2m = ~25 mp5.

	-- High-End Raid / Badge Trinkets
    [32483] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=29.2 }, note = MSC.L["Use: 29.2 Avg Haste (2m CD)"] }, -- The Skull of Gul'dan (175 Haste / 20s / 120s)
    [32654] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=36 }, note = MSC.L["Use: 36 Avg AP (1m CD)"] }, -- Crystalforged Trinket (216 AP / 10s / 60s)
    [33828] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=66 }, note = MSC.L["Use: 66 Avg Heal / 22 Avg SP (2m CD)"] }, -- Tome of Diabolic Remedy (396 Heal / 20s / 120s)
    [33829] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=35.2 }, note = MSC.L["Use: 35.2 Avg SP (2m CD)"] }, -- Hex Shrunken Head (211 SP / 20s / 120s)
    [33831] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=60 }, note = MSC.L["Use: 60 Avg AP (2m CD)"] }, -- Berserker's Call (360 AP / 20s / 120s)
    [34430] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=33.3 }, note = MSC.L["Use: 33.3 Avg mp5 (5m CD)"] }, -- Glimmering Naaru Sliver (2000 Total Mana / 300s)

    -- Battlemaster's Trinkets (1750 Max HP / 15s / 180s = 145.8 Avg Health)
    [33832] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=145.8 }, note = MSC.L["Use: 145.8 Avg Health (3m CD)"] }, -- Battlemaster's Determination
    [34049] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=145.8 }, note = MSC.L["Use: 145.8 Avg Health (3m CD)"] }, -- Battlemaster's Audacity
    [34050] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=145.8 }, note = MSC.L["Use: 145.8 Avg Health (3m CD)"] }, -- Battlemaster's Perseverance
    [34578] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=145.8 }, note = MSC.L["Use: 145.8 Avg Health (3m CD)"] }, -- Battlemaster's Determination
    [34579] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=145.8 }, note = MSC.L["Use: 145.8 Avg Health (3m CD)"] }, -- Battlemaster's Audacity
    [34580] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_SHORT", val=145.8 }, note = MSC.L["Use: 145.8 Avg Health (3m CD)"] }, -- Battlemaster's Perseverance

    -- Jewelcrafting Figurines (Phase 5 IDs)
    [35694] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=20 }, note = MSC.L["Use: Summon Khorium Boar (20 AP Proxy)"] }, 
    [35702] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=53.3 }, note = MSC.L["Use: 53.3 Avg AP (90s CD)"] }, -- Figurine - Shadowsong Panther (320 AP / 15s / 90s)
    [35703] = { _AUTO_PROC = { stat="ITEM_MOD_MANA_REGENERATION_SHORT", val=25 }, note = MSC.L["Use: 25 Avg mp5 (3m CD)"] }, -- Figurine - Seaspray Albatross (900 Mana / 180s)

    -- Brewfest Event Trinkets
    [38287] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=46.3 }, note = MSC.L["Use: 46.3 Avg AP (2m CD)"] }, -- Empty Mug of Direbrew (278 AP / 20s / 120s)
    [38288] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=49.5 }, note = MSC.L["Use: 49.5 Avg Heal / 16.5 Avg SP (2m CD)"] }, -- Direbrew Hops (297 Heal / 20s / 120s)
    [38289] = { _AUTO_PROC = { stat="ITEM_MOD_BLOCK_VALUE_SHORT", val=33.3 }, note = MSC.L["Use: 33.3 Avg Block Value (2m CD)"] }, -- Coren's Lucky Coin (200 BV / 20s / 120s)
    [38290] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=25.8 }, note = MSC.L["Use: 25.8 Avg SP (2m CD)"] }, -- Dark Iron Smoking Pipe (155 SP / 20s / 120s)

    -- Starter / TBC Classic Boost Item
    [185988] = { _AUTO_PROC = { stat="ITEM_MOD_HEALTH_REGENERATION_SHORT", val=3.3 }, note = MSC.L["Use: 3.3 Avg hp5 (10m CD)"] }, -- Communal Stone of Stoicism (400 Avg Health / 600s)

    -- [[ TBC PROC TRINKETS & WEAPONS (Averaged Uptime) ]]
    [28830] = { _AUTO_PROC = { stat="ITEM_MOD_HASTE_RATING_SHORT", val=160 }, note = MSC.L["Equip: 160 Avg Haste (DST Proxy)"] }, -- Dragonspine Trophy
    [27683] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", val=42 }, note = MSC.L["Equip: 42 Avg Spell Haste (Quagmirran's)"] }, -- Quagmirran's Eye
    [30626] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=63 }, note = MSC.L["Equip: 63 Avg SP (Sextant)"] }, -- Sextant of Unstable Currents
    [30627] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=75 }, note = MSC.L["Equip: 75 Avg AP (Tsunami)"] }, -- Tsunami Talisman
    [32505] = { _AUTO_PROC = { stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", val=186 }, note = MSC.L["Equip: 186 Avg ArP (Madness)"] }, -- Madness of the Betrayer
    [34472] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=102 }, note = MSC.L["Equip: 102 Avg AP (Shard of Contempt)"] }, -- Shard of Contempt
    [31323] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=55 }, note = MSC.L["Equip: 55 Avg AP (Don Santos)"] }, -- Don Santos' Famous Hunting Rifle
    [28573] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=60 }, note = MSC.L["Equip: 60 Avg AP (Despair)"] }, -- Despair
    [32262] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=60 }, note = MSC.L["Equip: 60 Avg AP (Syphon of the Nathrezim)"] }, -- Syphon of the Nathrezim
    [29301] = { _AUTO_PROC = { stat="ITEM_MOD_ATTACK_POWER_SHORT", val=26 }, note = MSC.L["Equip: 26 Avg AP (Band of Eternal Champion)"] },
    [29305] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_POWER_SHORT", val=21 }, note = MSC.L["Equip: 21 Avg SP (Band of Eternal Sage)"] },
    [29309] = { _AUTO_PROC = { stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", val=37 }, note = MSC.L["Equip: 37 Avg Heal (Band of Eternal Restorer)"] },
    [29313] = { _AUTO_PROC = { stat="ITEM_MOD_ARMOR_SHORT", val=133 }, note = MSC.L["Equip: 133 Avg Armor (Band of Eternal Defender)"] },

})

-- [[ PVP UTILITY OVERRIDES ]]
local function AddPvPTrinkets()
    -- Rank 1 (Classic Insignias - Class Specific CC Breaks)
    local pvpIDs = {18854, 18856, 18849, 18851, 18852, 18853, 18850, 18846, 18834, 18845, 18841, 18839, 18832, 18835, 18837, 18838}
    for _, id in ipairs(pvpIDs) do
        -- Initialize if nil, otherwise merge to avoid wiping base stats
        MSC.ItemOverrides[id] = MSC.ItemOverrides[id] or {}
        MSC.ItemOverrides[id].MSC_PVP_UTILITY = 60
        MSC.ItemOverrides[id].estimate = true
        MSC.ItemOverrides[id].note = MSC.L["CC Break (Rank 1)"]
        
        MSC.TrinketDB[id] = MSC.ItemOverrides[id]
    end
    
    -- Rank 2 (TBC Level 70 Medallions - All CC Break + Resilience)
    -- Includes your previously commented TBC IDs (30348, 30351, 30345, 28240)
    local r2_ids = {28234, 28235, 30348, 30351, 30345, 28240}
    for _, id in ipairs(r2_ids) do
        MSC.ItemOverrides[id] = MSC.ItemOverrides[id] or {}
        MSC.ItemOverrides[id].MSC_PVP_UTILITY = 80
        MSC.ItemOverrides[id].estimate = true
        MSC.ItemOverrides[id].note = MSC.L["CC Break (Rank 2)"]
        
        MSC.TrinketDB[id] = MSC.ItemOverrides[id]
    end

    -- Rank 3 (WotLK/Late TBC - e.g., Titan-Forged / Level 80 variants)
    local r3_ids = {37864, 37865}
    for _, id in ipairs(r3_ids) do
        MSC.ItemOverrides[id] = MSC.ItemOverrides[id] or {}
        MSC.ItemOverrides[id].MSC_PVP_UTILITY = 100
        MSC.ItemOverrides[id].estimate = true
        MSC.ItemOverrides[id].note = MSC.L["CC Break (Rank 3)"]
        
        MSC.TrinketDB[id] = MSC.ItemOverrides[id]
    end
end
AddPvPTrinkets()


-- ============================================================================
-- 5. INITIALIZATION STRUCTURE
-- ============================================================================
-- We define these here, but Data_Sets_<Edition>.lua populates them.
if not MSC.ItemSetMap then MSC.ItemSetMap = {} end
MSC.SetNameToID = {}
MSC.RawSetData = {}

function MSC:GetSetBonusDefinition(setID, count)
    if MSC.SetBonusScores and MSC.SetBonusScores[setID] and MSC.SetBonusScores[setID][count] then
        return MSC.SetBonusScores[setID][count]
    end
    return nil
end

-- ============================================================================
-- 6. SCALAR TABLES (The Truth Data)
-- ============================================================================

-- [[ 1. COMBAT RATINGS ]]
-- Amount of Rating needed for 1% Stat (or 1 Skill) at a given level.
-- Order: { WepS, Def, Dodge, Parry, Block, Hit, Crit, Haste, SpellHit, SpellCrit, SpellHaste, Resil }
MSC.CombatRatingScalars = {
    [70] = { 3.94, 2.37, 18.92, 31.54, 7.88, 15.77, 22.08, 15.77, 12.62, 22.08, 15.77, 39.42 },
    [69] = { 3.73, 2.24, 17.89, 29.82, 7.45, 14.91, 20.87, 14.91, 11.93, 20.87, 14.91, 37.27 },
    [68] = { 3.53, 2.12, 16.97, 28.28, 7.07, 14.14, 19.79, 14.14, 11.31, 19.79, 14.14, 35.34 },
    [67] = { 3.36, 2.02, 16.13, 26.89, 6.72, 13.44, 18.82, 13.44, 10.75, 18.82, 13.44, 33.61 },
    [66] = { 3.20, 1.92, 15.38, 25.63, 6.41, 12.81, 17.94, 12.81, 10.25, 17.94, 12.81, 32.03 },
    [65] = { 3.06, 1.84, 14.69, 24.48, 6.12, 12.24, 17.13, 12.24, 9.79,  17.13, 12.24, 30.60 },
    [64] = { 2.93, 1.76, 14.06, 23.43, 5.86, 11.71, 16.40, 11.71, 9.37,  16.40, 11.71, 29.29 },
    [63] = { 2.81, 1.68, 13.48, 22.47, 5.62, 11.23, 15.73, 11.23, 8.99,  15.73, 11.23, 28.08 },
    [62] = { 2.70, 1.62, 12.95, 21.58, 5.39, 10.79, 15.11, 10.79, 8.63,  15.11, 10.79, 26.97 },
    [61] = { 2.59, 1.56, 12.46, 20.76, 5.19, 10.38, 14.53, 10.38, 8.30,  14.53, 10.38, 25.95 },
    [60] = { 2.50, 1.50, 12.00, 20.00, 5.00, 10.00, 14.00, 10.00, 8.00,  14.00, 10.00, 25.00 },
    [59] = { 2.45, 1.47, 11.77, 19.62, 4.90, 9.81,  13.73, 9.81,  7.85,  13.73, 9.81,  24.52 },
    [58] = { 2.40, 1.44, 11.54, 19.23, 4.81, 9.62,  13.46, 9.62,  7.69,  13.46, 9.62,  24.04 },
    [57] = { 2.36, 1.41, 11.31, 18.85, 4.71, 9.42,  13.19, 9.42,  7.54,  13.19, 9.42,  23.56 },
    [56] = { 2.31, 1.38, 11.08, 18.46, 4.62, 9.23,  12.92, 9.23,  7.38,  12.92, 9.23,  23.08 },
    [55] = { 2.26, 1.36, 10.85, 18.08, 4.52, 9.04,  12.65, 9.04,  7.23,  12.65, 9.04,  22.60 },
    [54] = { 2.21, 1.33, 10.62, 17.69, 4.42, 8.85,  12.38, 8.85,  7.08,  12.38, 8.85,  22.12 },
    [53] = { 2.16, 1.30, 10.38, 17.31, 4.33, 8.65,  12.12, 8.65,  6.92,  12.12, 8.65,  21.63 },
    [52] = { 2.12, 1.27, 10.15, 16.92, 4.23, 8.46,  11.85, 8.46,  6.77,  11.85, 8.46,  21.15 },
    [51] = { 2.07, 1.24, 9.92,  16.54, 4.13, 8.27,  11.58, 8.27,  6.62,  11.58, 8.27,  20.67 },
    [50] = { 2.02, 1.21, 9.69,  16.15, 4.04, 8.08,  11.31, 8.08,  6.46,  11.31, 8.08,  20.19 },
    [49] = { 1.97, 1.18, 9.46,  15.77, 3.94, 7.88,  11.04, 7.88,  6.31,  11.04, 7.88,  19.71 },
    [48] = { 1.92, 1.15, 9.23,  15.38, 3.85, 7.69,  10.77, 7.69,  6.15,  10.77, 7.69,  19.23 },
    [47] = { 1.88, 1.13, 9.00,  15.00, 3.75, 7.50,  10.50, 7.50,  6.00,  10.50, 7.50,  18.75 },
    [46] = { 1.83, 1.10, 8.77,  14.62, 3.65, 7.31,  10.23, 7.31,  5.85,  10.23, 7.31,  18.27 },
    [45] = { 1.78, 1.07, 8.54,  14.23, 3.56, 7.12,  9.96,  7.12,  5.69,  9.96,  7.12,  17.79 },
    [44] = { 1.73, 1.04, 8.31,  13.85, 3.46, 6.92,  9.69,  6.92,  5.54,  9.69,  6.92,  17.31 },
    [43] = { 1.68, 1.01, 8.08,  13.46, 3.37, 6.73,  9.42,  6.73,  5.38,  9.42,  6.73,  16.83 },
    [42] = { 1.63, 0.98, 7.85,  13.08, 3.27, 6.54,  9.15,  6.54,  5.23,  9.15,  6.54,  16.35 },
    [41] = { 1.59, 0.95, 7.62,  12.69, 3.17, 6.35,  8.88,  6.35,  5.08,  8.88,  6.35,  15.87 },
    [40] = { 1.54, 0.92, 7.38,  12.31, 3.08, 6.15,  8.62,  6.15,  4.92,  8.62,  6.15,  15.38 },
    [39] = { 1.49, 0.89, 7.15,  11.92, 2.98, 5.96,  8.35,  5.96,  4.77,  8.35,  5.96,  14.90 },
    [38] = { 1.44, 0.87, 6.92,  11.54, 2.88, 5.77,  8.08,  5.77,  4.62,  8.08,  5.77,  14.42 },
    [37] = { 1.39, 0.84, 6.69,  11.15, 2.79, 5.58,  7.81,  5.58,  4.46,  7.81,  5.58,  13.94 },
    [36] = { 1.35, 0.81, 6.46,  10.77, 2.69, 5.38,  7.54,  5.38,  4.31,  7.54,  5.38,  13.46 },
    [35] = { 1.30, 0.78, 6.23,  10.38, 2.60, 5.19,  7.27,  5.19,  4.15,  7.27,  5.19,  12.98 },
    [34] = { 1.25, 0.75, 6.00,  10.00, 2.50, 5.00,  7.00,  5.00,  4.00,  7.00,  5.00,  12.50 },
    [33] = { 1.20, 0.72, 5.77,  9.62,  2.40, 4.81,  6.73,  4.81,  3.85,  6.73,  4.81,  12.02 },
    [32] = { 1.15, 0.69, 5.54,  9.23,  2.31, 4.62,  6.46,  4.62,  3.69,  6.46,  4.62,  11.54 },
    [31] = { 1.11, 0.66, 5.31,  8.85,  2.21, 4.42,  6.19,  4.42,  3.54,  6.19,  4.42,  11.06 },
    [30] = { 1.06, 0.63, 5.08,  8.46,  2.12, 4.23,  5.92,  4.23,  3.38,  5.92,  4.23,  10.58 },
    [29] = { 1.01, 0.61, 4.85,  8.08,  2.02, 4.04,  5.65,  4.04,  3.23,  5.65,  4.04,  10.10 },
    [28] = { 0.96, 0.58, 4.62,  7.69,  1.92, 3.85,  5.38,  3.85,  3.08,  5.38,  3.85,  9.62 },
    [27] = { 0.91, 0.55, 4.38,  7.31,  1.83, 3.65,  5.12,  3.65,  2.92,  5.12,  3.65,  9.13 },
    [26] = { 0.87, 0.52, 4.15,  6.92,  1.73, 3.46,  4.85,  3.46,  2.77,  4.85,  3.46,  8.65 },
    [25] = { 0.82, 0.49, 3.92,  6.54,  1.63, 3.27,  4.58,  3.27,  2.62,  4.58,  3.27,  8.17 },
    [24] = { 0.77, 0.46, 3.69,  6.15,  1.54, 3.08,  4.31,  3.08,  2.46,  4.31,  3.08,  7.69 },
    [23] = { 0.72, 0.43, 3.46,  5.77,  1.44, 2.88,  4.04,  2.88,  2.31,  4.04,  2.88,  7.21 },
    [22] = { 0.67, 0.40, 3.23,  5.38,  1.35, 2.69,  3.77,  2.69,  2.15,  3.77,  2.69,  6.73 },
    [21] = { 0.63, 0.38, 3.00,  5.00,  1.25, 2.50,  3.50,  2.50,  2.00,  3.50,  2.50,  6.25 },
    [20] = { 0.58, 0.35, 2.77,  4.62,  1.15, 2.31,  3.23,  2.31,  1.85,  3.23,  2.31,  5.77 },
    [19] = { 0.53, 0.32, 2.54,  4.23,  1.06, 2.12,  2.96,  2.12,  1.69,  2.96,  2.12,  5.29 },
    [18] = { 0.48, 0.29, 2.31,  3.85,  0.96, 1.92,  2.69,  1.92,  1.54,  2.69,  1.92,  4.81 },
    [17] = { 0.43, 0.26, 2.08,  3.46,  0.87, 1.73,  2.42,  1.73,  1.38,  2.42,  1.73,  4.33 },
    [16] = { 0.38, 0.23, 1.85,  3.08,  0.77, 1.54,  2.15,  1.54,  1.23,  2.15,  1.54,  3.85 },
    [15] = { 0.34, 0.20, 1.62,  2.69,  0.67, 1.35,  1.88,  1.35,  1.08,  1.88,  1.35,  3.37 },
    [14] = { 0.29, 0.17, 1.38,  2.31,  0.58, 1.15,  1.62,  1.15,  0.92,  1.62,  1.15,  2.88 },
    [13] = { 0.24, 0.14, 1.15,  1.92,  0.48, 0.96,  1.35,  0.96,  0.77,  1.35,  0.96,  2.40 },
    [12] = { 0.19, 0.12, 0.92,  1.54,  0.38, 0.77,  1.08,  0.77,  0.62,  1.08,  0.77,  1.92 },
    [11] = { 0.14, 0.09, 0.69,  1.15,  0.29, 0.58,  0.81,  0.58,  0.46,  0.81,  0.58,  1.44 },
    [10] = { 0.10, 0.06, 0.46,  0.77,  0.19, 0.38,  0.54,  0.38,  0.31,  0.54,  0.38,  0.96 },
     [9] = { 0.05, 0.03, 0.23,  0.38,  0.10, 0.19,  0.27,  0.19,  0.15,  0.27,  0.19,  0.48 },
     [8] = { 0.00, 0.00, 0.00,  0.00,  0.00, 0.00,  0.00,  0.00,  0.00,  0.00,  0.00,  0.00 },
}

MSC.RatingIndexMap = {
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 1,
	["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1,
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2,
    ["ITEM_MOD_DODGE_RATING_SHORT"] = 3,
    ["ITEM_MOD_PARRY_RATING_SHORT"] = 4,
    ["ITEM_MOD_BLOCK_RATING_SHORT"] = 5,
    ["ITEM_MOD_HIT_RATING_SHORT"] = 6,
    ["ITEM_MOD_CRIT_RATING_SHORT"] = 7,
    ["ITEM_MOD_HASTE_RATING_SHORT"] = 8,
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 9,
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 10,
    ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 11,
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 12,
}

-- [[ 2. PRIMARY STATS (Agi/Int -> Crit) ]]
-- Amount of Agility/Intellect needed for 1% Crit
MSC.PrimaryStatScalars = {
    AGI = {
        [1] = { WARRIOR=4.00, PALADIN=4.60, HUNTER=3.52, ROGUE=2.23, PRIEST=11.00, SHAMAN=6.01, MAGE=12.97, WARLOCK=6.67, DRUID=4.95 },
        [2] = { WARRIOR=4.20, PALADIN=4.83, HUNTER=3.53, ROGUE=2.33, PRIEST=11.00, SHAMAN=6.01, MAGE=12.97, WARLOCK=6.67, DRUID=4.95 },
        [3] = { WARRIOR=4.20, PALADIN=4.83, HUNTER=3.69, ROGUE=2.43, PRIEST=11.00, SHAMAN=6.32, MAGE=12.97, WARLOCK=7.00, DRUID=5.20 },
        [4] = { WARRIOR=4.40, PALADIN=5.06, HUNTER=3.95, ROGUE=2.62, PRIEST=11.56, SHAMAN=6.32, MAGE=13.61, WARLOCK=7.00, DRUID=5.20 },
        [5] = { WARRIOR=4.60, PALADIN=5.06, HUNTER=4.12, ROGUE=2.72, PRIEST=11.56, SHAMAN=6.62, MAGE=13.61, WARLOCK=7.00, DRUID=5.45 },
        [6] = { WARRIOR=4.80, PALADIN=5.29, HUNTER=4.28, ROGUE=2.82, PRIEST=11.56, SHAMAN=6.62, MAGE=13.61, WARLOCK=7.33, DRUID=5.45 },
        [7] = { WARRIOR=4.80, PALADIN=5.29, HUNTER=4.44, ROGUE=3.01, PRIEST=11.56, SHAMAN=6.62, MAGE=13.61, WARLOCK=7.33, DRUID=5.69 },
        [8] = { WARRIOR=5.00, PALADIN=5.52, HUNTER=4.61, ROGUE=3.11, PRIEST=12.11, SHAMAN=6.92, MAGE=13.61, WARLOCK=7.33, DRUID=5.69 },
        [9] = { WARRIOR=5.20, PALADIN=5.52, HUNTER=4.88, ROGUE=3.21, PRIEST=12.11, SHAMAN=6.92, MAGE=13.61, WARLOCK=7.67, DRUID=5.94 },
        [10] = { WARRIOR=5.20, PALADIN=5.75, HUNTER=5.04, ROGUE=3.40, PRIEST=12.11, SHAMAN=7.22, MAGE=14.27, WARLOCK=7.67, DRUID=6.44 },
        [11] = { WARRIOR=5.40, PALADIN=5.75, HUNTER=5.41, ROGUE=3.79, PRIEST=12.11, SHAMAN=7.22, MAGE=14.27, WARLOCK=8.00, DRUID=6.68 },
        [12] = { WARRIOR=5.60, PALADIN=5.98, HUNTER=5.99, ROGUE=4.18, PRIEST=12.66, SHAMAN=7.52, MAGE=14.27, WARLOCK=8.00, DRUID=6.68 },
        [13] = { WARRIOR=6.00, PALADIN=6.44, HUNTER=6.46, ROGUE=4.66, PRIEST=12.66, SHAMAN=7.52, MAGE=14.27, WARLOCK=8.00, DRUID=6.93 },
        [14] = { WARRIOR=6.20, PALADIN=6.44, HUNTER=6.94, ROGUE=5.05, PRIEST=12.66, SHAMAN=7.82, MAGE=14.27, WARLOCK=8.33, DRUID=6.93 },
        [15] = { WARRIOR=6.40, PALADIN=6.90, HUNTER=7.52, ROGUE=5.63, PRIEST=12.66, SHAMAN=8.12, MAGE=14.90, WARLOCK=8.67, DRUID=7.43 },
        [16] = { WARRIOR=6.60, PALADIN=6.90, HUNTER=7.89, ROGUE=6.02, PRIEST=13.21, SHAMAN=8.42, MAGE=14.90, WARLOCK=9.00, DRUID=7.43 },
        [17] = { WARRIOR=6.80, PALADIN=7.13, HUNTER=8.38, ROGUE=6.41, PRIEST=13.21, SHAMAN=8.42, MAGE=14.90, WARLOCK=9.00, DRUID=7.67 },
        [18] = { WARRIOR=7.20, PALADIN=7.59, HUNTER=8.95, ROGUE=6.90, PRIEST=13.21, SHAMAN=8.72, MAGE=14.90, WARLOCK=9.00, DRUID=7.92 },
        [19] = { WARRIOR=7.40, PALADIN=7.59, HUNTER=9.43, ROGUE=7.38, PRIEST=13.76, SHAMAN=8.72, MAGE=14.90, WARLOCK=9.34, DRUID=7.92 },
        [20] = { WARRIOR=7.80, PALADIN=8.05, HUNTER=10.02, ROGUE=7.87, PRIEST=13.76, SHAMAN=9.32, MAGE=15.55, WARLOCK=9.67, DRUID=8.91 },
        [21] = { WARRIOR=7.80, PALADIN=8.28, HUNTER=10.40, ROGUE=8.35, PRIEST=13.76, SHAMAN=9.32, MAGE=15.55, WARLOCK=10.00, DRUID=8.91 },
        [22] = { WARRIOR=8.00, PALADIN=8.28, HUNTER=10.99, ROGUE=8.74, PRIEST=13.76, SHAMAN=9.62, MAGE=15.55, WARLOCK=10.00, DRUID=9.16 },
        [23] = { WARRIOR=8.40, PALADIN=8.74, HUNTER=11.47, ROGUE=9.23, PRIEST=14.31, SHAMAN=9.62, MAGE=15.55, WARLOCK=10.33, DRUID=9.41 },
        [24] = { WARRIOR=8.60, PALADIN=8.97, HUNTER=12.06, ROGUE=9.62, PRIEST=14.31, SHAMAN=9.92, MAGE=16.21, WARLOCK=10.33, DRUID=9.41 },
        [25] = { WARRIOR=9.00, PALADIN=9.20, HUNTER=12.55, ROGUE=10.20, PRIEST=14.31, SHAMAN=10.22, MAGE=16.21, WARLOCK=11.00, DRUID=9.90 },
        [26] = { WARRIOR=9.20, PALADIN=9.43, HUNTER=13.04, ROGUE=10.68, PRIEST=14.86, SHAMAN=10.53, MAGE=16.21, WARLOCK=11.00, DRUID=9.90 },
        [27] = { WARRIOR=9.40, PALADIN=9.66, HUNTER=13.62, ROGUE=11.07, PRIEST=14.86, SHAMAN=10.53, MAGE=16.21, WARLOCK=11.00, DRUID=10.15 },
        [28] = { WARRIOR=9.80, PALADIN=9.89, HUNTER=14.10, ROGUE=11.56, PRIEST=14.86, SHAMAN=10.82, MAGE=16.21, WARLOCK=11.34, DRUID=10.40 },
        [29] = { WARRIOR=10.00, PALADIN=10.12, HUNTER=14.71, ROGUE=12.05, PRIEST=15.41, SHAMAN=10.82, MAGE=16.86, WARLOCK=11.34, DRUID=10.40 },
        [30] = { WARRIOR=10.40, PALADIN=10.58, HUNTER=15.29, ROGUE=12.63, PRIEST=15.41, SHAMAN=11.43, MAGE=16.86, WARLOCK=12.00, DRUID=11.39 },
        [31] = { WARRIOR=10.60, PALADIN=10.81, HUNTER=15.70, ROGUE=13.02, PRIEST=15.41, SHAMAN=11.43, MAGE=16.86, WARLOCK=12.00, DRUID=11.64 },
        [32] = { WARRIOR=10.80, PALADIN=10.81, HUNTER=16.29, ROGUE=13.50, PRIEST=15.95, SHAMAN=11.72, MAGE=16.86, WARLOCK=12.33, DRUID=11.64 },
        [33] = { WARRIOR=11.20, PALADIN=11.27, HUNTER=16.89, ROGUE=13.99, PRIEST=15.95, SHAMAN=12.03, MAGE=17.51, WARLOCK=12.33, DRUID=11.89 },
        [34] = { WARRIOR=11.40, PALADIN=11.49, HUNTER=17.39, ROGUE=14.47, PRIEST=15.95, SHAMAN=12.03, MAGE=17.51, WARLOCK=12.67, DRUID=12.14 },
        [35] = { WARRIOR=11.81, PALADIN=11.96, HUNTER=17.99, ROGUE=15.06, PRIEST=16.50, SHAMAN=12.63, MAGE=17.51, WARLOCK=13.00, DRUID=12.38 },
        [36] = { WARRIOR=12.00, PALADIN=12.20, HUNTER=18.48, ROGUE=15.55, PRIEST=16.50, SHAMAN=12.94, MAGE=18.15, WARLOCK=13.33, DRUID=12.63 },
        [37] = { WARRIOR=12.20, PALADIN=12.20, HUNTER=19.08, ROGUE=15.92, PRIEST=16.50, SHAMAN=12.94, MAGE=18.15, WARLOCK=13.66, DRUID=12.87 },
        [38] = { WARRIOR=12.59, PALADIN=12.64, HUNTER=19.69, ROGUE=16.42, PRIEST=17.06, SHAMAN=13.23, MAGE=18.15, WARLOCK=13.66, DRUID=12.87 },
        [39] = { WARRIOR=12.80, PALADIN=12.89, HUNTER=20.28, ROGUE=16.89, PRIEST=17.06, SHAMAN=13.23, MAGE=18.15, WARLOCK=14.01, DRUID=13.12 },
        [40] = { WARRIOR=13.19, PALADIN=13.33, HUNTER=20.79, ROGUE=17.48, PRIEST=17.06, SHAMAN=13.83, MAGE=18.80, WARLOCK=14.33, DRUID=14.10 },
        [41] = { WARRIOR=13.61, PALADIN=13.57, HUNTER=21.28, ROGUE=17.99, PRIEST=17.61, SHAMAN=14.14, MAGE=18.80, WARLOCK=14.66, DRUID=14.37 },
        [42] = { WARRIOR=13.79, PALADIN=13.57, HUNTER=21.88, ROGUE=18.45, PRIEST=17.61, SHAMAN=14.14, MAGE=18.80, WARLOCK=14.66, DRUID=14.37 },
        [43] = { WARRIOR=14.20, PALADIN=14.03, HUNTER=22.52, ROGUE=18.94, PRIEST=18.15, SHAMAN=14.43, MAGE=18.80, WARLOCK=14.99, DRUID=14.60 },
        [44] = { WARRIOR=14.41, PALADIN=14.27, HUNTER=23.09, ROGUE=19.53, PRIEST=18.15, SHAMAN=14.73, MAGE=19.46, WARLOCK=14.99, DRUID=14.86 },
        [45] = { WARRIOR=14.79, PALADIN=14.73, HUNTER=23.75, ROGUE=20.12, PRIEST=18.15, SHAMAN=15.04, MAGE=19.46, WARLOCK=15.67, DRUID=15.36 },
        [46] = { WARRIOR=14.99, PALADIN=14.95, HUNTER=24.21, ROGUE=20.58, PRIEST=18.73, SHAMAN=15.34, MAGE=19.46, WARLOCK=16.00, DRUID=15.60 },
        [47] = { WARRIOR=15.41, PALADIN=15.17, HUNTER=24.88, ROGUE=21.10, PRIEST=18.73, SHAMAN=15.65, MAGE=20.08, WARLOCK=16.00, DRUID=15.60 },
        [48] = { WARRIOR=15.80, PALADIN=15.65, HUNTER=25.58, ROGUE=21.55, PRIEST=19.27, SHAMAN=15.95, MAGE=20.08, WARLOCK=16.34, DRUID=15.85 },
        [49] = { WARRIOR=16.00, PALADIN=15.87, HUNTER=26.18, ROGUE=22.03, PRIEST=19.27, SHAMAN=15.95, MAGE=20.08, WARLOCK=16.67, DRUID=16.10 },
        [50] = { WARRIOR=16.39, PALADIN=16.34, HUNTER=26.81, ROGUE=22.73, PRIEST=19.27, SHAMAN=16.53, MAGE=20.75, WARLOCK=17.01, DRUID=17.09 },
        [51] = { WARRIOR=16.81, PALADIN=16.56, HUNTER=27.32, ROGUE=23.20, PRIEST=19.80, SHAMAN=16.84, MAGE=20.75, WARLOCK=17.33, DRUID=17.33 },
        [52] = { WARRIOR=17.01, PALADIN=16.78, HUNTER=27.93, ROGUE=23.70, PRIEST=19.80, SHAMAN=17.15, MAGE=20.75, WARLOCK=17.33, DRUID=17.57 },
        [53] = { WARRIOR=17.39, PALADIN=17.24, HUNTER=28.57, ROGUE=24.27, PRIEST=20.37, SHAMAN=17.15, MAGE=21.41, WARLOCK=17.67, DRUID=17.83 },
        [54] = { WARRIOR=17.79, PALADIN=17.48, HUNTER=29.33, ROGUE=24.75, PRIEST=20.37, SHAMAN=17.45, MAGE=21.41, WARLOCK=17.99, DRUID=17.83 },
        [55] = { WARRIOR=18.21, PALADIN=17.95, HUNTER=29.94, ROGUE=25.38, PRIEST=20.92, SHAMAN=18.05, MAGE=21.41, WARLOCK=18.35, DRUID=18.32 },
        [56] = { WARRIOR=18.42, PALADIN=18.18, HUNTER=30.49, ROGUE=25.91, PRIEST=20.92, SHAMAN=18.35, MAGE=22.03, WARLOCK=18.66, DRUID=18.55 },
        [57] = { WARRIOR=18.80, PALADIN=18.38, HUNTER=31.15, ROGUE=26.46, PRIEST=21.46, SHAMAN=18.66, MAGE=22.03, WARLOCK=19.01, DRUID=18.83 },
        [58] = { WARRIOR=19.19, PALADIN=18.87, HUNTER=31.85, ROGUE=27.03, PRIEST=21.46, SHAMAN=18.66, MAGE=22.03, WARLOCK=19.34, DRUID=19.05 },
        [59] = { WARRIOR=19.61, PALADIN=19.08, HUNTER=32.57, ROGUE=27.47, PRIEST=22.03, SHAMAN=18.94, MAGE=22.68, WARLOCK=19.34, DRUID=19.31 },
        [60] = { WARRIOR=20.00, PALADIN=19.53, HUNTER=33.22, ROGUE=28.17, PRIEST=22.03, SHAMAN=19.53, MAGE=22.68, WARLOCK=20.00, DRUID=20.28 },
        [61] = { WARRIOR=21.32, PALADIN=20.37, HUNTER=33.67, ROGUE=29.94, PRIEST=22.57, SHAMAN=20.16, MAGE=22.99, WARLOCK=20.66, DRUID=20.92 },
        [62] = { WARRIOR=22.62, PALADIN=20.70, HUNTER=34.48, ROGUE=31.06, PRIEST=22.52, SHAMAN=20.58, MAGE=23.15, WARLOCK=20.79, DRUID=21.19 },
        [63] = { WARRIOR=23.92, PALADIN=21.19, HUNTER=35.21, ROGUE=32.57, PRIEST=22.68, SHAMAN=21.28, MAGE=23.58, WARLOCK=21.28, DRUID=21.93 },
        [64] = { WARRIOR=25.19, PALADIN=21.93, HUNTER=35.84, ROGUE=33.78, PRIEST=23.09, SHAMAN=21.93, MAGE=23.64, WARLOCK=21.98, DRUID=22.37 },
        [65] = { WARRIOR=26.53, PALADIN=22.42, HUNTER=36.63, ROGUE=34.97, PRIEST=23.47, SHAMAN=22.27, MAGE=23.70, WARLOCK=22.32, DRUID=22.83 },
        [66] = { WARRIOR=27.78, PALADIN=22.88, HUNTER=37.04, ROGUE=36.23, PRIEST=23.87, SHAMAN=22.88, MAGE=24.33, WARLOCK=22.99, DRUID=23.26 },
        [67] = { WARRIOR=29.07, PALADIN=23.53, HUNTER=37.88, ROGUE=37.31, PRIEST=24.15, SHAMAN=23.42, MAGE=24.27, WARLOCK=22.94, DRUID=23.58 },
        [68] = { WARRIOR=30.40, PALADIN=24.04, HUNTER=38.61, ROGUE=38.17, PRIEST=24.27, SHAMAN=23.98, MAGE=24.51, WARLOCK=23.58, DRUID=24.27 },
        [69] = { WARRIOR=31.75, PALADIN=24.51, HUNTER=39.37, ROGUE=39.06, PRIEST=24.39, SHAMAN=24.51, MAGE=24.75, WARLOCK=24.15, DRUID=24.63 },
        [70] = { WARRIOR=33.00, PALADIN=25.00, HUNTER=40.00, ROGUE=40.00, PRIEST=25.00, SHAMAN=25.00, MAGE=25.00, WARLOCK=24.69, DRUID=25.00 },
    },
        INT = {
        [1] = { PALADIN=12.02, HUNTER=14.31, PRIEST=5.85, SHAMAN=7.50, MAGE=6.11, WARLOCK=6.67, DRUID=6.99 },
        [2] = { PALADIN=12.61, HUNTER=15.02, PRIEST=6.11, SHAMAN=7.86, MAGE=6.35, WARLOCK=6.97, DRUID=7.30 },
        [3] = { PALADIN=12.61, HUNTER=15.02, PRIEST=6.38, SHAMAN=8.22, MAGE=6.60, WARLOCK=7.27, DRUID=7.62 },
        [4] = { PALADIN=13.21, HUNTER=15.75, PRIEST=6.64, SHAMAN=8.22, MAGE=7.09, WARLOCK=7.58, DRUID=7.94 },
        [5] = { PALADIN=13.21, HUNTER=15.75, PRIEST=7.17, SHAMAN=8.58, MAGE=7.33, WARLOCK=7.88, DRUID=8.26 },
        [6] = { PALADIN=13.81, HUNTER=16.45, PRIEST=7.44, SHAMAN=8.93, MAGE=7.58, WARLOCK=8.18, DRUID=8.58 },
        [7] = { PALADIN=14.41, HUNTER=16.45, PRIEST=7.71, SHAMAN=9.29, MAGE=7.82, WARLOCK=8.48, DRUID=8.90 },
        [8] = { PALADIN=14.41, HUNTER=17.15, PRIEST=7.97, SHAMAN=9.64, MAGE=8.06, WARLOCK=8.79, DRUID=8.90 },
        [9] = { PALADIN=15.02, HUNTER=17.15, PRIEST=8.24, SHAMAN=10.00, MAGE=8.55, WARLOCK=9.09, DRUID=9.21 },
        [10] = { PALADIN=15.02, HUNTER=17.89, PRIEST=8.77, SHAMAN=10.00, MAGE=8.80, WARLOCK=9.39, DRUID=10.16 },
        [11] = { PALADIN=15.63, HUNTER=17.89, PRIEST=9.57, SHAMAN=10.72, MAGE=9.53, WARLOCK=10.30, DRUID=10.80 },
        [12] = { PALADIN=16.23, HUNTER=18.59, PRIEST=10.63, SHAMAN=11.43, MAGE=10.75, WARLOCK=11.21, DRUID=11.75 },
        [13] = { PALADIN=16.84, HUNTER=20.04, PRIEST=11.43, SHAMAN=12.50, MAGE=11.48, WARLOCK=12.12, DRUID=12.39 },
        [14] = { PALADIN=17.42, HUNTER=20.04, PRIEST=12.76, SHAMAN=13.23, MAGE=13.68, WARLOCK=13.04, DRUID=13.33 },
        [15] = { PALADIN=18.62, HUNTER=21.46, PRIEST=13.81, SHAMAN=14.29, MAGE=14.90, WARLOCK=13.95, DRUID=14.62 },
        [16] = { PALADIN=18.62, HUNTER=21.46, PRIEST=14.62, SHAMAN=15.02, MAGE=15.65, WARLOCK=14.53, DRUID=15.24 },
        [17] = { PALADIN=19.23, HUNTER=22.17, PRIEST=15.95, SHAMAN=15.72, MAGE=16.61, WARLOCK=15.75, DRUID=16.21 },
        [18] = { PALADIN=20.41, HUNTER=23.58, PRIEST=16.75, SHAMAN=16.78, MAGE=17.61, WARLOCK=16.67, DRUID=16.84 },
        [19] = { PALADIN=20.41, HUNTER=23.58, PRIEST=17.79, SHAMAN=17.51, MAGE=18.59, WARLOCK=17.57, DRUID=17.79 },
        [20] = { PALADIN=21.65, HUNTER=25.06, PRIEST=19.12, SHAMAN=18.59, MAGE=19.80, WARLOCK=18.48, DRUID=19.38 },
        [21] = { PALADIN=22.22, HUNTER=25.77, PRIEST=19.92, SHAMAN=19.31, MAGE=20.53, WARLOCK=19.38, DRUID=20.00 },
        [22] = { PALADIN=22.83, HUNTER=25.77, PRIEST=21.28, SHAMAN=20.00, MAGE=21.74, WARLOCK=20.28, DRUID=20.96 },
        [23] = { PALADIN=23.42, HUNTER=27.17, PRIEST=22.08, SHAMAN=21.10, MAGE=22.47, WARLOCK=21.23, DRUID=21.60 },
        [24] = { PALADIN=24.04, HUNTER=27.93, PRIEST=23.36, SHAMAN=21.79, MAGE=23.70, WARLOCK=22.42, DRUID=22.88 },
        [25] = { PALADIN=25.25, HUNTER=28.57, PRIEST=24.45, SHAMAN=22.88, MAGE=24.69, WARLOCK=23.31, DRUID=23.81 },
        [26] = { PALADIN=25.84, HUNTER=29.33, PRIEST=25.51, SHAMAN=23.58, MAGE=25.64, WARLOCK=23.92, DRUID=24.45 },
        [27] = { PALADIN=25.84, HUNTER=30.03, PRIEST=26.60, SHAMAN=24.27, MAGE=26.88, WARLOCK=25.13, DRUID=25.38 },
        [28] = { PALADIN=27.03, HUNTER=30.77, PRIEST=27.62, SHAMAN=25.38, MAGE=29.59, WARLOCK=26.04, DRUID=26.04 },
        [29] = { PALADIN=27.62, HUNTER=31.45, PRIEST=28.74, SHAMAN=26.11, MAGE=30.77, WARLOCK=27.25, DRUID=27.32 },
        [30] = { PALADIN=28.82, HUNTER=32.89, PRIEST=30.03, SHAMAN=27.17, MAGE=32.05, WARLOCK=28.17, DRUID=28.90 },
        [31] = { PALADIN=29.41, HUNTER=33.67, PRIEST=31.06, SHAMAN=28.25, MAGE=32.79, WARLOCK=28.82, DRUID=29.50 },
        [32] = { PALADIN=30.03, HUNTER=33.67, PRIEST=32.15, SHAMAN=28.90, MAGE=34.01, WARLOCK=30.03, DRUID=30.77 },
        [33] = { PALADIN=30.67, HUNTER=35.09, PRIEST=33.22, SHAMAN=30.03, MAGE=34.97, WARLOCK=30.86, DRUID=31.45 },
        [34] = { PALADIN=31.25, HUNTER=35.71, PRIEST=34.60, SHAMAN=30.77, MAGE=35.97, WARLOCK=32.15, DRUID=32.36 },
        [35] = { PALADIN=32.47, HUNTER=37.17, PRIEST=35.59, SHAMAN=31.85, MAGE=37.17, WARLOCK=33.00, DRUID=33.67 },
        [36] = { PALADIN=33.00, HUNTER=37.88, PRIEST=36.63, SHAMAN=32.89, MAGE=38.17, WARLOCK=33.90, DRUID=34.25 },
        [37] = { PALADIN=33.67, HUNTER=37.88, PRIEST=38.02, SHAMAN=33.56, MAGE=39.37, WARLOCK=35.21, DRUID=35.21 },
        [38] = { PALADIN=34.84, HUNTER=39.37, PRIEST=39.06, SHAMAN=34.60, MAGE=40.32, WARLOCK=36.10, DRUID=36.23 },
        [39] = { PALADIN=35.46, HUNTER=40.00, PRIEST=40.16, SHAMAN=35.34, MAGE=41.49, WARLOCK=37.31, DRUID=37.17 },
        [40] = { PALADIN=36.63, HUNTER=41.49, PRIEST=41.49, SHAMAN=36.76, MAGE=42.55, WARLOCK=38.17, DRUID=39.06 },
        [41] = { PALADIN=37.31, HUNTER=42.19, PRIEST=42.55, SHAMAN=37.45, MAGE=43.48, WARLOCK=39.06, DRUID=39.68 },
        [42] = { PALADIN=37.88, HUNTER=42.19, PRIEST=43.86, SHAMAN=38.17, MAGE=46.51, WARLOCK=40.32, DRUID=40.98 },
        [43] = { PALADIN=39.06, HUNTER=43.67, PRIEST=44.84, SHAMAN=39.37, MAGE=47.39, WARLOCK=41.15, DRUID=41.67 },
        [44] = { PALADIN=39.06, HUNTER=44.44, PRIEST=46.30, SHAMAN=40.32, MAGE=48.54, WARLOCK=42.37, DRUID=42.92 },
        [45] = { PALADIN=40.32, HUNTER=45.87, PRIEST=47.62, SHAMAN=41.49, MAGE=49.75, WARLOCK=43.67, DRUID=43.86 },
        [46] = { PALADIN=40.82, HUNTER=46.51, PRIEST=48.54, SHAMAN=42.55, MAGE=50.76, WARLOCK=44.64, DRUID=44.84 },
        [47] = { PALADIN=42.02, HUNTER=47.17, PRIEST=50.00, SHAMAN=43.29, MAGE=52.08, WARLOCK=45.45, DRUID=45.66 },
        [48] = { PALADIN=43.29, HUNTER=48.54, PRIEST=51.02, SHAMAN=44.25, MAGE=53.19, WARLOCK=46.73, DRUID=46.73 },
        [49] = { PALADIN=43.86, HUNTER=49.26, PRIEST=52.36, SHAMAN=45.45, MAGE=54.35, WARLOCK=47.85, DRUID=47.85 },
        [50] = { PALADIN=45.05, HUNTER=50.76, PRIEST=53.76, SHAMAN=46.51, MAGE=55.87, WARLOCK=49.02, DRUID=49.50 },
        [51] = { PALADIN=45.66, HUNTER=51.55, PRIEST=54.64, SHAMAN=47.62, MAGE=56.82, WARLOCK=50.00, DRUID=50.51 },
        [52] = { PALADIN=46.30, HUNTER=52.08, PRIEST=56.18, SHAMAN=48.31, MAGE=57.80, WARLOCK=51.28, DRUID=51.81 },
        [53] = { PALADIN=47.39, HUNTER=53.76, PRIEST=57.14, SHAMAN=49.75, MAGE=58.82, WARLOCK=52.36, DRUID=52.36 },
        [54] = { PALADIN=48.08, HUNTER=54.35, PRIEST=58.48, SHAMAN=50.25, MAGE=60.24, WARLOCK=53.76, DRUID=53.76 },
        [55] = { PALADIN=49.26, HUNTER=55.87, PRIEST=60.24, SHAMAN=51.81, MAGE=61.73, WARLOCK=54.95, DRUID=54.95 },
        [56] = { PALADIN=49.75, HUNTER=56.50, PRIEST=60.98, SHAMAN=52.63, MAGE=64.94, WARLOCK=55.87, DRUID=55.87 },
        [57] = { PALADIN=50.51, HUNTER=57.14, PRIEST=62.50, SHAMAN=53.48, MAGE=66.23, WARLOCK=56.82, DRUID=56.82 },
        [58] = { PALADIN=52.36, HUNTER=58.82, PRIEST=63.69, SHAMAN=54.95, MAGE=67.11, WARLOCK=58.14, DRUID=57.80 },
        [59] = { PALADIN=52.91, HUNTER=59.52, PRIEST=64.94, SHAMAN=55.87, MAGE=68.49, WARLOCK=59.52, DRUID=59.17 },
        [60] = { PALADIN=54.05, HUNTER=60.98, PRIEST=66.23, SHAMAN=57.14, MAGE=69.93, WARLOCK=60.61, DRUID=60.98 },
        [61] = { PALADIN=63.69, HUNTER=63.69, PRIEST=67.57, SHAMAN=60.98, MAGE=69.93, WARLOCK=62.89, DRUID=61.73 },
        [62] = { PALADIN=65.36, HUNTER=64.94, PRIEST=68.97, SHAMAN=62.89, MAGE=69.93, WARLOCK=64.94, DRUID=63.69 },
        [63] = { PALADIN=67.57, HUNTER=66.67, PRIEST=69.93, SHAMAN=65.79, MAGE=69.93, WARLOCK=67.57, DRUID=66.67 },
        [64] = { PALADIN=69.93, HUNTER=69.44, PRIEST=71.94, SHAMAN=68.03, MAGE=70.42, WARLOCK=69.93, DRUID=68.49 },
        [65] = { PALADIN=71.43, HUNTER=70.92, PRIEST=72.99, SHAMAN=70.42, MAGE=70.42, WARLOCK=72.46, DRUID=70.42 },
        [66] = { PALADIN=73.53, HUNTER=72.99, PRIEST=74.63, SHAMAN=72.46, MAGE=72.46, WARLOCK=74.07, DRUID=72.99 },
        [67] = { PALADIN=75.19, HUNTER=75.19, PRIEST=75.76, SHAMAN=74.63, MAGE=75.19, WARLOCK=76.92, DRUID=75.19 },
        [68] = { PALADIN=76.34, HUNTER=76.92, PRIEST=76.92, SHAMAN=76.34, MAGE=76.34, WARLOCK=78.74, DRUID=76.34 },
        [69] = { PALADIN=78.13, HUNTER=78.13, PRIEST=78.74, SHAMAN=78.13, MAGE=78.13, WARLOCK=80.00, DRUID=78.13 },
        [70] = { PALADIN=80.00, HUNTER=80.00, PRIEST=80.00, SHAMAN=80.00, MAGE=80.00, WARLOCK=81.97, DRUID=80.00 },
    }
}
