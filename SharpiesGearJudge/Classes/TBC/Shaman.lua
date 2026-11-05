local addonName, MSC = ...
local Shaman = {}
Shaman.Name = "SHAMAN"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Shaman.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_MANA_SHORT"]=0.05, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5,
        ["MSC_WEAPON_DPS"]=1.0
    },

    -- [[ 1. ELEMENTAL ]]
    ["ELE_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.5, 
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },

    -- [[ 2. ELEMENTAL PVP ]]
    ["ELE_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 3. ENHANCEMENT ]]
    ["ENH_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 4.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.1, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.6, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.1, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.4,
        -- POISON
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02, 
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },

    -- [[ 4. RESTORATION ]]
    ["RESTO_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 1.0, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.9, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.6, 
        -- POISON
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },

    -- [[ 5. SHAMAN TANK ]]
    ["SHAMAN_TANK"] = { 
        ["MSC_WEAPON_DPS"]                  = 1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 2.0, 
        ["ITEM_MOD_ARMOR_SHORT"]            = 0.8, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]      = 1.5, 
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.2, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
    },

    ["HYBRID_ELE_RESTO"] = {
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0,
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.1,
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.7,
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.8,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.6,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]= 0.5,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 1.5,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },
    ["HYBRID_ENH_RESTO"] = {
        ["MSC_WEAPON_DPS"]                  = 3.5,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.0,
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.0,
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.5,
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.2,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]= 0.5,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 1.5,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.6,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },
}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (Shaman Part 1: Melee & Caster)
-- =============================================================
Shaman.LevelingBrackets = {
    -- [[ STANDARD MELEE (1-39) ]]
    -- 2H Axes/Maces/Staves. Windfury unlocks at Lvl 30.
    ["Leveling_1_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 0.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, -- 1 Str = 2 AP
            ["ITEM_MOD_AGILITY_SHORT"] = 0.8, -- 0 AP in TBC. Only Crit/Armor. Low prio early.
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5, -- Mana for shocks
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, -- Added for sync
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.5 -- Added for sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.8
        }
    },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, -- Windfury Era (Lvl 30)
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 2.0, -- Windfury demands SLOW weapons
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.1 -- Added for sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, -- Flurry uptime
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2
        }
    },

    -- [[ ENHANCEMENT DUAL WIELD (40-70) ]]
    -- Meta: Slow MH / Slow OH (for Stormstrike). 
    -- Mental Dexterity: Int provides AP (1 Int = 1 AP).
    -- TBC Mechanics: Agility provides ZERO AP. Only Crit/Armor.
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, -- Slow MH
            ["MSC_OH_WEAPON_SPEED"] = 2.5, -- Slow OH
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, -- 1 Str = 2 AP
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.3, -- 1 Int = 1 AP (Mental Dexterity)
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0, -- Purely Crit/Armor stat now
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, -- DW Penalty
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5 -- Added TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.8, 
            ["MSC_OH_WEAPON_SPEED"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.4,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.8, 
            ["MSC_OH_WEAPON_SPEED"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.4,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["MSC_OH_WEAPON_SPEED"] = 3.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5
        }
    },
    ["Leveling_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["MSC_OH_WEAPON_SPEED"] = 3.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.6,
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 0.5, -- TBC Stat
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.5 -- TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 16.0, 
            ["MSC_WEAPON_SPEED"] = 3.5, 
            ["MSC_OH_WEAPON_SPEED"] = 3.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.8,
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 3.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.5
        }
    },

    -- [[ ELEMENTAL CASTER ]]
    -- Spell Power > Hit > Crit > Int. Spirit is dead.
    ["Leveling_Caster_40_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 40, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, -- Mana pool is vital at 40
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        }
    },
    ["Leveling_Caster_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        }
    },
    ["Leveling_Caster_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.0, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 2.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.5, -- TBC Stat
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.5, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 2.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_MANA_SHORT"] = 0.02,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 1.0,
			["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 0.8 -- Secondary priority below Nature/SP
        }
    },

    -- [[ SHAMAN TANK (Warden) ]]
    -- High Stamina + Block + Agility (Dodge). Weapon Speed 0 = not scored: a fast weapon
    -- (Rockbiter/Frostbrand threat) would need a negative weight, which the scorer ignores.
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.5, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 2.8, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8, 
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1
        }
    },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1
        }
    },
    ["Leveling_Tank_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 6.0, 
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.5, -- Added for Sync
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 6.0, 
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 4.0, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.8,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1
        }
    },

    -- [[ RESTO HEALER ]]
    -- Healing Power > Mp5 > Int. Spirit is garbage.
    ["Leveling_Healer_40_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 40, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8
        }
    },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8, -- Added for Sync
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_Healer_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 2.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0, -- Added for Sync
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.5 -- TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0,
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 2.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 1.0
        }
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Shaman.Specs = { [1]="Elemental", [2]="Enhancement", [3]="Restoration" }

Shaman.PrettyNames = {
    ["ELE_PVE"]         = MSC.L["Raid: Elemental"],
    ["ELE_PVP"]         = MSC.L["PvP: Elemental"],
    ["ENH_PVE"]         = MSC.L["Raid: Enhancement"],
    ["RESTO_PVE"]       = MSC.L["Raid: Restoration"],
    ["SHAMAN_TANK"]     = MSC.L["Tank: Warden"],
    ["HYBRID_ELE_RESTO"]= MSC.L["Hybrid: Ele / Resto (NS)"],
    ["HYBRID_ENH_RESTO"]= MSC.L["Hybrid: Enh / Resto (PvP)"],
    -- Leveling Brackets
    ["Leveling_1_20"]  = MSC.L["Starter (1-20)"],
    ["Leveling_21_40"] = MSC.L["Standard Leveling (21-40)"],
    ["Leveling_41_51"] = MSC.L["Standard Leveling (41-51)"],
    ["Leveling_52_59"] = MSC.L["Standard Leveling (52-59)"],
    ["Leveling_60_70"] = MSC.L["Standard Leveling (Outland)"],
    ["Leveling_Caster_40_51"] = MSC.L["Elemental (40-51)"],
    ["Leveling_Caster_52_59"] = MSC.L["Elemental (52-59)"],
    ["Leveling_Caster_60_70"] = MSC.L["Elemental (Outland)"],
    ["Leveling_Healer_40_51"] = MSC.L["Resto Dungeon (40-51)"],
    ["Leveling_Healer_52_59"] = MSC.L["Resto Dungeon (52-59)"],
    ["Leveling_Healer_60_70"] = MSC.L["Resto Dungeon (Outland)"],
    ["Leveling_Tank_1_20"]    = MSC.L["Shaman Tank (1-20)"],
    ["Leveling_Tank_21_40"]   = MSC.L["Shaman Tank (21-40)"],
    ["Leveling_Tank_41_51"]   = MSC.L["Shaman Tank (41-51)"],
    ["Leveling_Tank_52_59"]   = MSC.L["Shaman Tank (52-59)"],
    ["Leveling_Tank_60_70"]   = MSC.L["Shaman Tank (Outland)"],
}

Shaman.SpeedChecks = {
	["Default"]={ MH_Slow=true },
    ["ENH_PVE"]={ MH_Slow=true, OH_Slow=true }
}

Shaman.EndgameTabMap = { [1] = "ELE_PVE", [2] = "ENH_PVE", [3] = "RESTO_PVE" }

Shaman.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes (2H via Talent)
    [4]=true, [5]=true,   -- 1H/2H Maces (2H via Talent)
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    -- (No [6]: weapon subclass 6 is Polearms, which Shamans can't use; shields are armor.)
}

Shaman.StatToCritMatrix = { 
    Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } 
}

Shaman.Talents = { 
    ["ELEMENTAL_MASTERY"]	= MSC.L["Elemental Mastery"], 
    ["TOTEM_OF_WRATH"]		= MSC.L["Totem of Wrath"], 
    ["LIGHTNING_MASTERY"]	= MSC.L["Lightning Mastery"], 
    ["STORMSTRIKE"]			= MSC.L["Stormstrike"], 
    ["SHAMANISTIC_RAGE"]	= MSC.L["Shamanistic Rage"], 
    ["MANA_TIDE"]			= MSC.L["Mana Tide Totem"], 
    ["EARTH_SHIELD"]		= MSC.L["Earth Shield"], 
    ["ELEMENTAL_PRECISION"] = MSC.L["Elemental Precision"],
    ["NATURE_GUIDANCE"]		= MSC.L["Nature's Guidance"], 
    ["ANCESTRAL_KNOW"]		= MSC.L["Ancestral Knowledge"], 
    ["MENTAL_QUICKNESS"]	= MSC.L["Mental Quickness"], 
    ["SHIELD_SPEC"]			= MSC.L["Shield Specialization"], 
    ["ANTICIPATION"]		= MSC.L["Anticipation"],
    ["DUAL_WIELD_SPEC"]		= MSC.L["Dual Wield Specialization"],
	["NATURES_BLESSING"]	= MSC.L["NATURES_BLESSING"],
    ["NATURES_SWIFTNESS"]   = MSC.L["Nature's Swiftness"],
}

-- =============================================================
-- LOGIC
-- =============================================================
function Shaman:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("NATURES_SWIFTNESS") > 0 and (Rank("TOTEM_OF_WRATH") > 0 or Rank("ELEMENTAL_MASTERY") > 0) then return "HYBRID_ELE_RESTO", "high" end
        if Rank("NATURES_SWIFTNESS") > 0 and (Rank("SHAMANISTIC_RAGE") > 0 or Rank("STORMSTRIKE") > 0) then return "HYBRID_ENH_RESTO", "high" end
        if Rank("TOTEM_OF_WRATH") > 0 or Rank("ELEMENTAL_MASTERY") > 0 then return "ELE_PVE", "high" end
        if Rank("SHAMANISTIC_RAGE") > 0 or Rank("STORMSTRIKE") > 0 then return "ENH_PVE", "high" end
        if Rank("EARTH_SHIELD") > 0 or Rank("MANA_TIDE") > 0 then return "RESTO_PVE", "high" end
        if Rank("SHIELD_SPEC") > 0 and Rank("ANTICIPATION") > 0 then return "SHAMAN_TANK", "high" end
        local fallback, conf = MSC:GetDominantTalentTree(Shaman.EndgameTabMap, 5)
        if fallback then return fallback, conf end
        return "RESTO_PVE", "ambiguous"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("SHIELD_SPEC") > 0 and Rank("ANTICIPATION") > 0 then role = "Leveling_Tank"
    elseif Rank("ELEMENTAL_MASTERY") > 0 or Rank("TOTEM_OF_WRATH") > 0 then role = "Leveling_Caster"
    elseif Rank("MANA_TIDE") > 0 or Rank("EARTH_SHIELD") > 0 then role = "Leveling_Healer"
    end 

    local specificKey = role .. suffix
    if Shaman.LevelingBrackets and Shaman.LevelingBrackets[specificKey] then return specificKey, "high" end
    -- The Elemental and Restoration rows for this band are named _40_51 (they start at 40)
    if suffix == "_41_51" and Shaman.LevelingBrackets and Shaman.LevelingBrackets[role .. "_40_51"] then
        return role .. "_40_51", "high"
    end
    return "Leveling" .. suffix, "low"
end

function Shaman:GetDynamicWeights(forceKey)
    -- [[ TRANSLATOR ]]
    -- If the dropdown sends a "Pretty Name" (e.g. "Standard Leveling..."), 
    -- we reverse-lookup the "Code Key" (e.g. "Leveling_2H...").
    if forceKey and not Shaman.LevelingBrackets[forceKey] and not Shaman.Weights[forceKey] then
        if Shaman.PrettyNames then
            for key, name in pairs(Shaman.PrettyNames) do
                if name == forceKey then
                    forceKey = key
                    break
                end
            end
        end
    end

    local level = UnitLevel("player")
    local specKey, specConf
    if forceKey then
        specKey = forceKey
    else
        specKey, specConf = self:GetSpec()
        MSC.CachedSpecConfidence = specConf or "high"
    end

    -- 1. Check Leveling Brackets
    if Shaman.LevelingBrackets and Shaman.LevelingBrackets[specKey] then
        local bracket = Shaman.LevelingBrackets[specKey]
        
        -- Calculate progress
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        
        -- [[ PREVIEW CLAMPING ]]
        -- If previewing a different level bracket, force progress to 0 or 1 
        -- to prevent "Negative Stats" from vanishing.
        if forceKey then
            if level < bracket.min then progress = 0 end -- Show Start weights
            if level > bracket.max then progress = 1 end -- Show End weights
        else
            -- Normal play strict clamping
            if progress < 0 then progress = 0 end
            if progress > 1 then progress = 1 end
        end

        local dynamicWeights = {}
        
        -- [[ ROBUSTNESS ]]
        -- Collect ALL keys so nothing vanishes if you made a typo in Start vs End
        local allStats = {}
        if bracket.Start then for k in pairs(bracket.Start) do allStats[k] = true end end
        if bracket.End then for k in pairs(bracket.End) do allStats[k] = true end end

        for stat, _ in pairs(allStats) do
            local startValue = (bracket.Start and bracket.Start[stat]) or 0
            local endValue = (bracket.End and bracket.End[stat]) or 0
            
            local result = startValue + ((endValue - startValue) * progress)
            
            -- Safety: Never return negative weight
            if result < 0 and not stat:find("WEAPON_SPEED", 1, true) then result = 0 end -- (negative speed = prefer fast)
            
            dynamicWeights[stat] = result
        end
        
        -- Weights set on the bracket itself (outside Start/End, e.g. armor) apply
        -- flat across the whole bracket. They were silently dropped before.
        for stat, v in pairs(bracket) do
            if type(v) == "number" and stat ~= "min" and stat ~= "max" and dynamicWeights[stat] == nil then
                dynamicWeights[stat] = v
            end
        end

        return dynamicWeights, specKey
    end

    -- 2. Static Weights Fallback
    if Shaman.Weights and Shaman.Weights[specKey] then 
        return Shaman.Weights[specKey], specKey
    elseif Shaman.LevelingWeights and Shaman.LevelingWeights[specKey] then 
        return Shaman.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Shaman:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- [[ 1. DUAL WIELD DPS FIX ]]
    -- Ensure Enhancement Shamans get credit for their DW Spec talent (+25% OH Dmg)
    if currentSpec:find("ENH") or (Rank("DUAL_WIELD_SPEC") > 0) then
        if not weights["MSC_WEAPON_DPS_OH"] then
            weights["MSC_WEAPON_DPS_OH"] = 0.625 -- 50% Base * 1.25 Talent
        end
    end

    -- [[ 2. EXISTING TALENTS ]]
    local rAnc = Rank("ANCESTRAL_KNOW")
    if rAnc > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAnc * 0.01)) 
    end
    
    -- [[ 3. MENTAL QUICKNESS (AP -> SP Conversion Value) ]]
    -- We buff AP weight here because it provides SP via the talent.
    local rMent = Rank("MENTAL_QUICKNESS")
    if rMent > 0 and weights["ITEM_MOD_ATTACK_POWER_SHORT"] then 
        weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * 1.1 
    end

    -- [[ 4. COVARIANCE (Synergy) ]]
    if currentSpec:find("ENH") or currentSpec:find("Tank") then
        if weights["ITEM_MOD_CRIT_RATING_SHORT"] then
            local totalAP = MSC.GetJudgingStats().ap -- unbuffed, plus assumed buffs
            if totalAP > 1000 then 
                 local apScaler = 1 + ((totalAP - 1000) / 20000)
                 if apScaler > 1.15 then apScaler = 1.15 end
                 weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * apScaler
            end
        end

    elseif currentSpec:find("ELE") or currentSpec:find("Caster") then
        if weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
            local spellPower = MSC.GetJudgingSpellDamage(4) -- 4 = Nature
            if spellPower > 600 then
                 local spScaler = 1 + ((spellPower - 600) / 10000)
                 if spScaler > 1.2 then spScaler = 1.2 end
                 weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * spScaler
            end
        end

    elseif currentSpec:find("RESTO") or currentSpec:find("Healer") then
        if weights["ITEM_MOD_MANA_REGENERATION_SHORT"] then
            local healPower = MSC.GetJudgingStats().heal
            if healPower > 800 then
                local hScaler = 1 + ((healPower - 800) / 10000)
                if hScaler > 1.2 then hScaler = 1.2 end
                weights["ITEM_MOD_MANA_REGENERATION_SHORT"] = weights["ITEM_MOD_MANA_REGENERATION_SHORT"] * hScaler
            end
        end
    end
    
    -- [[ 5. CAPS with HYSTERESIS ]]
    local level = UnitLevel("player")
    if level > 70 then level = 70 end
    
    local hitScalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level] and MSC.CombatRatingScalars[level][6]) or 15.8
    local spellHitScalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level] and MSC.CombatRatingScalars[level][8]) or 12.6
    
    local _, race = UnitRace("player")
    local racialHitPct = (race == "Draenei") and 1 or 0
    local natureGuidancePct = Rank("NATURE_GUIDANCE") * 1

    -- A. DUAL WIELD HIT (Enhancement)
    if currentSpec:find("ENH") and Rank("DUAL_WIELD_SPEC") > 0 then
         local hitRating = (MSC.GetGearHitRating and MSC.GetGearHitRating("MELEE")) or MSC.SanitizeStat(GetCombatRating(6)) -- gear, unbuffed
         -- DW wants 9% to cap specials, but continues scaling well up to ~24% for white damage
         local dwSpecPct = Rank("DUAL_WIELD_SPEC") * 2
         local specialCapPct = math.max(0, 9 - dwSpecPct - natureGuidancePct - racialHitPct)
         local specialCapRating = specialCapPct * hitScalar
         
         if hitRating >= (specialCapRating + (2 * hitScalar)) then
			weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.8 
			table.insert(activeCaps, MSC.L["Yellow Hit"])
		elseif hitRating >= specialCapRating then
			weights["ITEM_MOD_HIT_RATING_SHORT"] = 1.4
			table.insert(activeCaps, MSC.L["Y-Hit (Soft)"])
		end

    -- B. 2H / TANK HIT (Hard Cap)
    elseif MSC.BuffEngine and weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
         MSC.BuffEngine:ApplyMeleeHitCap(weights, activeCaps, currentSpec, natureGuidancePct)
    end
    
    -- C. SPELL HIT (Elemental)
    if MSC.BuffEngine and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
         local precisionPct = Rank("ELEMENTAL_PRECISION") * 2
         local wrathPct = (Rank("TOTEM_OF_WRATH") > 0) and 3 or 0
         local talentPct = precisionPct + natureGuidancePct + wrathPct
         MSC.BuffEngine:ApplySpellHitCap(weights, activeCaps, currentSpec, talentPct, { hardVal = 0.02, hardLabel = MSC.L["Spell Hit"] })
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Shaman:GetWeaponBonus(itemLink, weights) 
    if not itemLink or not weights then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local race = MSC.CtxRace()
    local apScoreValue = (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 1.0)

    -- Racial: Orc (Axe/Fist)
    if race == "Orc" and (subClassID == 0 or subClassID == 1 or subClassID == 13) then 
        bonus = bonus + (40 * apScoreValue) 
    end
    
    return bonus
end

-- =============================================================
-- CLASS SPECIFIC ITEMS (Totems)
-- =============================================================
-- Note: Proc uptime, conditional buffs, and mana savings are averaged 
-- into standard stats (e.g., MP5 for mana reduction, AP for proc damage).
Shaman.Relics = {
    [22345] = { note = MSC.L["Reduces Reincarnation CD by 10 min."] }, -- Totem of Rebirth (Utility)
    [22395] = { ITEM_MOD_SPELL_POWER_SHORT = 15 }, -- Totem of Rage (Averaged shock dmg)
    [22396] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 80 }, -- Totem of Life
    [23199] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 33 }, -- Totem of the Storm
    [24413] = { ITEM_MOD_MANA_REGENERATION_SHORT = 15 }, -- Totem of the Thunderhead (Avg MP5 from shield triggers)
    [25645] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 79 }, -- Totem of the Plains
    [27544] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 88 }, -- Totem of Spontaneous Regrowth
    [27815] = { ITEM_MOD_ATTACK_POWER_SHORT = 40 }, -- Totem of the Astral Winds (Avg AP for WF uptime)
    [27947] = { ITEM_MOD_SPELL_POWER_SHORT = 23 }, -- Totem of Impact (Averaged shock dmg)
    [28066] = { ITEM_MOD_MANA_REGENERATION_SHORT = 25 }, -- Totem of Lightning (Avg MP5 from LB spam)
    [28248] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 55 }, -- Totem of the Void
    [28523] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 87 }, -- Totem of Healing Rains
    [29389] = { ITEM_MOD_MANA_REGENERATION_SHORT = 35 }, -- Totem of the Pulsing Earth (Avg MP5 from LB spam)
    [30023] = { ITEM_MOD_MANA_REGENERATION_SHORT = 15 }, -- Totem of the Maelstrom (Avg MP5 from HW)
    [31031] = { ITEM_MOD_MANA_REGENERATION_SHORT = 10 }, -- Stormfury Totem (Avg MP5 from SS)
    [33506] = { ITEM_MOD_SPELL_HASTE_RATING_SHORT = 35 }, -- Skycall Totem (Avg uptime haste from LB)
    [33507] = { ITEM_MOD_ATTACK_POWER_SHORT = 55 }, -- Stonebreaker's Totem (Avg 50% uptime 110 AP)
    [23005] = { ITEM_MOD_MANA_REGENERATION_SHORT = 15 }, -- Totem of Flowing Water (Avg MP5)
    [23200] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 53 }, -- Totem of Sustaining
    [27984] = { ITEM_MOD_SPELL_POWER_SHORT = 23 }, -- Totem of Impact (Duplicate itemID)
    [32330] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 85 }, -- Totem of Ancestral Guidance
    [33505] = { ITEM_MOD_MANA_REGENERATION_SHORT = 25 }, -- Totem of Living Water (Avg MP5 from CH)
    [34233] = { ITEM_MOD_MANA_REGENERATION_SHORT = 25 }, -- Totem of the Celestial Tides (Water Shield MP5)
    [34234] = { ITEM_MOD_MANA_REGENERATION_SHORT = 25 }, -- Totem of the Tortured Earth (Lightning Bolt mana reduction)

    -- [[ PvP Healer (Lesser Healing Wave) ]]
    [28357] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- Gladiator's Totem of the Third Wind
    [33078] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 }, -- Merciless Gladiator's Totem of the Third Wind
    [33843] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 }, -- Vengeful Gladiator's Totem of the Third Wind
    [35106] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 }, -- Brutal Gladiator's Totem of the Third Wind

    -- [[ PvP Enhancement (Stormstrike) ]]
    [33939] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- Gladiator's Totem of Indomitability
    [33940] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 }, -- Merciless Gladiator's Totem of Indomitability
    [33941] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 }, -- Vengeful Gladiator's Totem of Indomitability
    [35104] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 }, -- Brutal Gladiator's Totem of Indomitability

    -- [[ PvP Elemental (Shocks) ]]
    [33951] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 }, -- Gladiator's Totem of Survival
    [33952] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 }, -- Merciless Gladiator's Totem of Survival
    [33953] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 }, -- Vengeful Gladiator's Totem of Survival
    [35105] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 }, -- Brutal Gladiator's Totem of Survival

    -- [[ Communal (Boost Gear) ]]
    [186071] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 10 }, -- Communal Totem of Lightning
    [186072] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 10 }, -- Communal Totem of Restoration
    [186073] = { ITEM_MOD_MANA_REGENERATION_SHORT = 2 }, -- Communal Totem of the Storm
}

-- [[ DYNAMIC RELIC HANDLER ]]
-- Returns the interpreted stats for the Evaluator and Tooltip engines
function Shaman:GetRelicBonus(itemID, currentSpec)
    local bonus = {}
    
    if Shaman.Relics[itemID] then
        for k, v in pairs(Shaman.Relics[itemID]) do 
            bonus[k] = v 
        end
    end
    
    return bonus
end

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Shaman.Profiles = {}
for k, v in pairs(Shaman.Weights) do Shaman.Profiles[k] = v end
if Shaman.LevelingBrackets then
    for k, v in pairs(Shaman.LevelingBrackets) do
        local prof = {}
        for stat, w in pairs(v.End or {}) do prof[stat] = w end
        for stat, w in pairs(v) do
            if type(w) == "number" and stat ~= "min" and stat ~= "max" and prof[stat] == nil then prof[stat] = w end
        end
        Shaman.Profiles[k] = prof
    end
end
if Shaman.LevelingWeights then
    for k, v in pairs(Shaman.LevelingWeights) do Shaman.Profiles[k] = v end
end
MSC.RegisterModule("SHAMAN", Shaman)


