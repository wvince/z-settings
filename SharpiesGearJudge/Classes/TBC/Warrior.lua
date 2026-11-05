local addonName, MSC = ...
local Warrior = {}
Warrior.Name = "WARRIOR"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Warrior.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5,
        ["MSC_WEAPON_DPS"]=2.0 
    },
    ["FURY_DW"] = { 
        ["MSC_WEAPON_DPS"]                  = 6.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.35,
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.3, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.5,            
        -- TRACE VALUES (Avoids penalty)
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=0.02,
        -- ZERO VALUES (Kills Double Dipping)
        ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0,
    },
    ["FURY_2H"] = { 
        ["MSC_WEAPON_DPS"]                  = 6.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.2, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.35, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.5,                
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=0.02,
        -- ZERO VALUES
        ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0,
    },    
    ["ARMS_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 5.0,
        ["MSC_WEAPON_SPEED"]                = 15.0,      
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.3, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.5, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.4, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.4,
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=0.02,
    },      
    ["ARMS_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 4.5,
        ["MSC_WEAPON_SPEED"]                = 15.0,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.8,  
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.5,
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.0,                
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=0.02,
    },      
    ["DEEP_PROT"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.096, 
        ["MSC_WEAPON_DPS"]                  = 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.6, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 2.4, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]      = 0.7, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 1.0, 
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 1.0, 
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 0.9, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.6, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.6, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.5,                
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0,
    },
    ["FURY_PROT"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.084,
        ["MSC_WEAPON_DPS"]                  = 4.0,
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9,
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.6,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.0,
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0,
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.4,
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.2,
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.2,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02,
        ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0,
    },
    ["ARMS_PROT"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.078,
        ["MSC_WEAPON_DPS"]                  = 3.5,
        ["MSC_WEAPON_SPEED"]                = 10.0,
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.5,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.0,
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.3,
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.4,
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 0.9,
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 0.8,
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, ["ITEM_MOD_SPIRIT_SHORT"]=0.02, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02,
        ["ITEM_MOD_MANA_SHORT"]=0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0,
    },
}

-- Safety Init
Warrior.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS
-- =============================================================
Warrior.LevelingBrackets = {

    -- [[ 1. ARMS / 2H LEVELING ]]
    ["Leveling_1_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 0.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, -- Added (1 Str = 2 AP)
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.1, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.25, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.5, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.1, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5
        }
    },
    ["Leveling_2H_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 1.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.25, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 13.0, 
            ["MSC_WEAPON_SPEED"] = 2.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.4, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        }
    },
    ["Leveling_2H_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 13.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5, -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.6, -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        }
    },
    ["Leveling_2H_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 2.8, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.6, -- Added
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.75, -- Added
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.3, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        }
    },
    ["Leveling_2H_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.75, -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 0.5,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 16.0, 
            ["MSC_WEAPON_SPEED"] = 3.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 4.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 2.0, -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.2,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        }
    },      

    -- [[ 2. FURY / DUAL WIELD ]]
    -- MSC_OH_WEAPON_SPEED 0: the off hand's speed isn't scored (it would otherwise use the
    -- MH Speed weight). A fast-OH preference would need a negative weight, which the scorer ignores.
    ["Leveling_DW_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 1.0, 
            ["MSC_OH_WEAPON_SPEED"] = -1.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 11.0, 
            ["MSC_WEAPON_SPEED"] = 1.2, 
            ["MSC_OH_WEAPON_SPEED"] = -1.2, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.25, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        }
    },
    ["Leveling_DW_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 11.0, 
            ["MSC_WEAPON_SPEED"] = 1.5, 
            ["MSC_OH_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5, -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 1.8, 
            ["MSC_OH_WEAPON_SPEED"] = -1.8, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.6, -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.6,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.8,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        }
    },
    ["Leveling_DW_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.0, 
            ["MSC_OH_WEAPON_SPEED"] = -2.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.6, -- Added
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.4, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 13.0, 
            ["MSC_WEAPON_SPEED"] = 2.2, 
            ["MSC_OH_WEAPON_SPEED"] = -2.2, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.75, -- Added
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.6, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.4,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        }
    },
    ["Leveling_DW_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["MSC_OH_WEAPON_SPEED"] = -2.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.75, -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.0,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["MSC_OH_WEAPON_SPEED"] = -3.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STRENGTH_SHORT"] = 4.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 2.0, -- Added
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.0,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 2.0,
			["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1 -- Better than nothing
        }
    },

    -- [[ 3. PROT / TANK ]]
    -- MSC_WEAPON_SPEED 0: weapon speed isn't scored for tanks (no "prefer fast" in the scorer).
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = -1.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 0.9, -- Added
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.1,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.1,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.1, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 0.5
        }
    },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 2.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, -- Added
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 9.0,
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 4.0, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.1, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5
        }
    },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 9.0,
            ["MSC_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_STAMINA_SHORT"] = 4.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.1, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0,
            ["MSC_WEAPON_SPEED"] = 0.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 4.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.8,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.25, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5
        }
    },
    ["Leveling_Tank_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 0.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 5.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.8, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.25, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 0.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 6.0,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 4.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 3.5,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5, -- Added
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 3.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.5
        }
    }
}

-- =============================================================
-- CLASS METADATA
-- =============================================================

Warrior.Specs = { [1]="Arms", [2]="Fury", [3]="Protection" }

Warrior.PrettyNames = {
    ["FURY_2H"]             = MSC.L["Raid: Arms/Fury (2H)"],
    ["FURY_DW"]             = MSC.L["Raid: Fury (Dual Wield)"],
    ["ARMS_PVP"]            = MSC.L["PvP: Arms (Mortal Strike)"],
    ["ARMS_PVE"]            = MSC.L["Raid: Arms (Blood Frenzy)"],
    ["DEEP_PROT"]           = MSC.L["Tank: Deep Protection"],
    ["FURY_PROT"]           = MSC.L["Tank: Fury-Prot (Threat)"],
    ["ARMS_PROT"]           = MSC.L["Tank: Arms (Dungeon Hybrid)"],
    ["Leveling_1_20"]  = MSC.L["Starter (1-20)"],
    ["Leveling_2H_21_40"] = MSC.L["Standard Leveling (21-40)"],
    ["Leveling_2H_41_51"] = MSC.L["Standard Leveling (41-51)"],
    ["Leveling_2H_52_59"] = MSC.L["Standard Leveling (52-59)"],
    ["Leveling_2H_60_70"] = MSC.L["Standard Leveling (Outland)"],
    ["Leveling_DW_21_40"]    = MSC.L["Fury/DW (21-40)"],
    ["Leveling_DW_41_51"]    = MSC.L["Fury/DW (41-51)"],
    ["Leveling_DW_52_59"]    = MSC.L["Fury/DW (52-59)"],
    ["Leveling_DW_60_70"]    = MSC.L["Fury/DW (Outland)"],
    ["Leveling_Tank_21_40"] = MSC.L["Dungeon Tank (21-40)"],
    ["Leveling_Tank_41_51"] = MSC.L["Dungeon Tank (41-51)"],
    ["Leveling_Tank_52_59"] = MSC.L["Dungeon Tank (52-59)"],
    ["Leveling_Tank_60_70"] = MSC.L["Dungeon Tank (Outland)"],
}

Warrior.SpeedChecks = { 
    ["Default"]={ MH_Slow=true }, 
    ["FURY_DW"]={ MH_Slow=true, OH_Fast=true }, 
    ["DEEP_PROT"]={ MH_Fast=true },
    ["FURY_PROT"]={ MH_Slow=true, OH_Fast=true },
    ["ARMS_PROT"]={ MH_Slow=true },
}

Warrior.EndgameTabMap = { [1] = "ARMS_PVE", [2] = "FURY_DW", [3] = "DEEP_PROT" }
Warrior.ValidWeapons = {
    [0]=true, [1]=true, [4]=true, [5]=true, [7]=true, [8]=true, [6]=true, [10]=true, [13]=true, [15]=true,
    [2]=true, [3]=true, [18]=true, [16]=true
}

Warrior.StatToCritMatrix = { Agi = { {1, 4.0}, {60, 20.0}, {70, 33.0} } }

Warrior.Talents = { 
    ["PRECISION"]=MSC.L["Precision"], 
    ["MORTAL_STRIKE"]=MSC.L["Mortal Strike"], 
    ["ENDLESS_RAGE"]=MSC.L["Endless Rage"],
    ["BLOOD_FRENZY"]=MSC.L["Blood Frenzy"], 
    ["SECOND_WIND"]=MSC.L["Second Wind"], 
    ["BLOODTHIRST"]=MSC.L["Bloodthirst"],
    ["RAMPAGE"]=MSC.L["Rampage"], 
    ["SHIELD_SLAM"]=MSC.L["Shield Slam"], 
    ["DEVASTATE"]=MSC.L["Devastate"], 
    ["VITALITY"]=MSC.L["Vitality"],
    ["POLEAXE_SPEC"]=MSC.L["Poleaxe Specialization"], 
    ["SWORD_SPEC"]=MSC.L["Sword Specialization"], 
    ["MACE_SPEC"]=MSC.L["Mace Specialization"],
    ["DUAL_WIELD_SPEC"]=MSC.L["Dual Wield Specialization"],
    ["DEFIANCE"]=MSC.L["Defiance"],
    ["TACTICAL_MASTERY"]=MSC.L["Tactical Mastery"],
    ["IMP_SLAM"]=MSC.L["Improved Slam"],
}

function Warrior:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("BLOODTHIRST") > 0 and (Rank("DEVASTATE") > 0 or Rank("SHIELD_SLAM") > 0) then return "FURY_PROT", "high" end
        if Rank("MORTAL_STRIKE") > 0 and (Rank("DEVASTATE") > 0 or Rank("SHIELD_SLAM") > 0) then return "ARMS_PROT", "high" end
        if Rank("DEVASTATE") > 0 or Rank("SHIELD_SLAM") > 0 then return "DEEP_PROT", "high" end
        if Rank("BLOODTHIRST") > 0 and Rank("DUAL_WIELD_SPEC") == 0 then return "FURY_2H", "high" end
        if Rank("RAMPAGE") > 0 or Rank("BLOODTHIRST") > 0 then return "FURY_DW", "high" end
        if Rank("MORTAL_STRIKE") > 0 then
            if Rank("BLOOD_FRENZY") > 0 then return "ARMS_PVE", "high" end
            return "ARMS_PVP", "high"
        end
        local fallback, conf = MSC:GetDominantTalentTree(Warrior.EndgameTabMap, 5)
        if fallback then return fallback, conf end
        return "FURY_DW", "ambiguous"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    -- [[ BETTER DETECTION LOGIC ]]
    local role = "Leveling_2H"
    
    if Rank("SHIELD_SLAM") > 0 or Rank("DEVASTATE") > 0 then 
        role = "Leveling_Tank"
    elseif Rank("BLOODTHIRST") > 0 or Rank("RAMPAGE") > 0 or Rank("DUAL_WIELD_SPEC") > 0 then 
        -- Check for Tier 4 Fury talent "Dual Wield Specialization"
        -- This allows us to detect DW intent at Level 30-35, not just Level 40
        role = "Leveling_DW"
    else
        -- Fallback: Point Scan
        -- If user has significantly more points in Fury (Tab 2) than Arms (Tab 1), assume DW
        local furyPts = MSC.GetTabPointsSpent(2)
        local armsPts = MSC.GetTabPointsSpent(1)
        if furyPts > (armsPts + 5) and level > 25 then 
            role = "Leveling_DW" 
        end
    end

    local specificKey = role .. suffix
    if Warrior.LevelingBrackets and Warrior.LevelingBrackets[specificKey] then return specificKey, "high" end
    if Warrior.LevelingWeights[specificKey] then return specificKey, "high" end
    -- Shared rows (only Leveling_1_20 exists) live in LevelingBrackets, not LevelingWeights
    if Warrior.LevelingBrackets and Warrior.LevelingBrackets["Leveling" .. suffix] then return "Leveling" .. suffix, "high" end
    if Warrior.LevelingWeights["Leveling" .. suffix] then return "Leveling" .. suffix, "high" end
    return "Leveling_2H" .. suffix, "low"
end

function Warrior:GetDynamicWeights(forceKey)
    -- [[ TRANSLATOR ]]
    -- If the dropdown sends a "Pretty Name" (e.g. "Standard Leveling..."), 
    -- we reverse-lookup the "Code Key" (e.g. "Leveling_2H...").
    if forceKey and not Warrior.LevelingBrackets[forceKey] and not Warrior.Weights[forceKey] then
        if Warrior.PrettyNames then
            for key, name in pairs(Warrior.PrettyNames) do
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
    if Warrior.LevelingBrackets and Warrior.LevelingBrackets[specKey] then
        local bracket = Warrior.LevelingBrackets[specKey]
        
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
    if Warrior.Weights and Warrior.Weights[specKey] then 
        return Warrior.Weights[specKey], specKey
    elseif Warrior.LevelingWeights and Warrior.LevelingWeights[specKey] then 
        return Warrior.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Warrior:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ OFFHAND & FURY HANDLING ]]
    if currentSpec and (currentSpec:find("ARMS") or currentSpec:find("2H")) then
        -- 2H Spec looking at 1H weapons
        weights["MSC_WEAPON_DPS_OH"] = 0.5 
    elseif currentSpec and (currentSpec:find("FURY") or currentSpec:find("DW")) then
        -- Fury/DW Spec
        weights["MSC_WEAPON_DPS_OH"] = 0.625 -- 50% Base + 25% Talent = 62.5% effective DPS
        
        -- [[ OFF-HAND SPEED ]]
        -- Slow MH, fast OH: a negative OH Speed weight means "prefer fast"
        -- (GetItemScore scores it as |w| x (4.0 - speed)).
        if not weights["MSC_OH_WEAPON_SPEED"] and weights["MSC_WEAPON_SPEED"] then
            weights["MSC_OH_WEAPON_SPEED"] = -1 * math.abs(weights["MSC_WEAPON_SPEED"])
        end
    end

    if weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] then
        local arPen = MSC.SanitizeStat(GetCombatRating(25)) or 0
        if arPen > 100 then
            local scaler = 1 + (arPen / 1000) 
            if scaler > 1.4 then scaler = 1.4 end
            weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] * scaler
        end
    end

	-- [[ D. HIT CAP ]]
    if MSC.BuffEngine and weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        MSC.BuffEngine:ApplyMeleeHitCap(weights, activeCaps, currentSpec, Rank("PRECISION") * 1)
    end

    if weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] and weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] > 1.0 then
        local rawBD, rawAD = UnitDefense("player"); local baseDef = MSC.SanitizeStat(rawBD); local armorDef = MSC.SanitizeStat(rawAD)
        local playerLevel = UnitLevel("player")
        local dynamicDefCap = (playerLevel * 5) + 140
        
        if (baseDef + armorDef) >= dynamicDefCap then
            weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8
            table.insert(activeCaps, MSC.L["Def"])
            weights["ITEM_MOD_STAMINA_SHORT"] = (weights["ITEM_MOD_STAMINA_SHORT"] or 1.5) * 1.3
            weights["ITEM_MOD_ARMOR_SHORT"] = (weights["ITEM_MOD_ARMOR_SHORT"] or 0.1) * 1.5
        end
    end
	
	-- [[ E. CRUSH CAP (Prot) ]]
    if currentSpec:find("PROT") and weights["ITEM_MOD_BLOCK_RATING_SHORT"] then
        -- 5% Base Miss + Dodge + Parry + Block + 75% Shield Block
        local avoidance = 5.0 + GetDodgeChance() + GetParryChance() + MSC.GetPassiveBlockChance() + 75.0
        
        -- Tier 1: SAFELY CAPPED (102.8%+)
        if avoidance >= 102.8 then
            -- Block Rating is completely dead weight now
            weights["ITEM_MOD_BLOCK_RATING_SHORT"] = 0.5
            weights["ITEM_MOD_DODGE_RATING_SHORT"] = (weights["ITEM_MOD_DODGE_RATING_SHORT"] or 1.0) * 0.8
            weights["ITEM_MOD_PARRY_RATING_SHORT"] = (weights["ITEM_MOD_PARRY_RATING_SHORT"] or 1.0) * 0.8
            table.insert(activeCaps, MSC.L["Crush (Safe)"])

            -- PIVOT TO EFFECTIVE HEALTH
            weights["ITEM_MOD_STAMINA_SHORT"] = (weights["ITEM_MOD_STAMINA_SHORT"] or 1.5) * 1.2
            weights["ITEM_MOD_ARMOR_SHORT"]   = (weights["ITEM_MOD_ARMOR_SHORT"] or 0.1) * 1.2

        -- Tier 2: DANGER ZONE / SOFT CAP (102.4% - 102.79%)
        elseif avoidance >= 102.4 then
            weights["ITEM_MOD_BLOCK_RATING_SHORT"] = 0.8
            table.insert(activeCaps, MSC.L["Crush (Soft)"])
        end
    end
	
	-- [[ F. The Expertise Cap ]]
    if weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] and weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] > 0.1 then
        local expRating = MSC.SanitizeStat(GetCombatRating(24))
        local level = UnitLevel("player")
        if level > 70 then level = 70 end
        local expScalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level] and MSC.CombatRatingScalars[level][1]) or 3.94
        
        local _, raceID = UnitRace("player")
        local racialBonusExpSkill = 0
        local itemLink = GetInventoryItemLink("player", 16)
        
        if itemLink then
             local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
             if classID == 2 then 
                 if raceID == "Human" and (subClassID == 4 or subClassID == 5 or subClassID == 7 or subClassID == 8) then
                    racialBonusExpSkill = 5 
                 elseif raceID == "Orc" and (subClassID == 0 or subClassID == 1 or subClassID == 13) then
                    racialBonusExpSkill = 5 
                 end
             end
        end

        local totalExpSkill = (expRating / expScalar) + racialBonusExpSkill
        -- Defiance (Prot Talent) gives Expertise
        if currentSpec:find("PROT") or currentSpec:find("Tank") then
             totalExpSkill = totalExpSkill + (Rank("DEFIANCE") * 2)
        end

        if totalExpSkill >= 26 then
            weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] * 0.5
            table.insert(activeCaps, MSC.L["Exp"])
        end
    end

    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Warrior:GetWeaponBonus(itemLink, weights)
    if not itemLink or not weights then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local race = MSC.CtxRace()
    local apScoreValue = (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 1.0)
    local critScoreValue = (weights["ITEM_MOD_CRIT_RATING_SHORT"] or 1.0) * 22.1 -- rough fallback if scalar fails

    if race == "Human" and (subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5) then bonus = bonus + (40 * apScoreValue) end
    if race == "Orc" and (subClassID == 0 or subClassID == 1 or subClassID == 13) then bonus = bonus + (40 * apScoreValue) end

    local function Rank(k) return MSC:GetTalentRank(k) end
    if subClassID == 0 or subClassID == 1 or subClassID == 6 then
        local rank = Rank("POLEAXE_SPEC")
        if rank > 0 then bonus = bonus + (rank * 1.0 * critScoreValue) end -- 1% Crit per rank
    end
    if subClassID == 7 or subClassID == 8 then
        local rank = Rank("SWORD_SPEC")
        if rank > 0 then bonus = bonus + (rank * 35.0 * apScoreValue) end
    end
    if subClassID == 4 or subClassID == 5 then
        local rank = Rank("MACE_SPEC")
        if rank > 0 then bonus = bonus + (rank * 10.0 * apScoreValue) end
    end

    return bonus
end

Warrior.Profiles = {}
for k, v in pairs(Warrior.Weights) do Warrior.Profiles[k] = v end
if Warrior.LevelingBrackets then
    for k, v in pairs(Warrior.LevelingBrackets) do
        local prof = {}
        for stat, w in pairs(v.End or {}) do prof[stat] = w end
        for stat, w in pairs(v) do
            if type(w) == "number" and stat ~= "min" and stat ~= "max" and prof[stat] == nil then prof[stat] = w end
        end
        Warrior.Profiles[k] = prof
    end
end
if Warrior.LevelingWeights then
    for k, v in pairs(Warrior.LevelingWeights) do Warrior.Profiles[k] = v end
end

MSC.RegisterModule("WARRIOR", Warrior)


