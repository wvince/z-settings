local addonName, MSC = ...
local Hunter = {}
Hunter.Name = "HUNTER"

-- =============================================================
-- ENDGAME STAT WEIGHTS (Static Profiles)
-- =============================================================
Hunter.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.3, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.9, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.4,
        ["MSC_WEAPON_DPS"]=1.5 
    },

    -- [[ 1. BEAST MASTERY (Standard Raid) ]]
    ["RAID_BM"] = { 
        ["MSC_WEAPON_DPS"]                  = 12.0, -- Pet scales huge off this
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, -- Cap #1
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.9, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]= 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, -- Go for the Throat
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.3, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 2. SURVIVAL (Expose Weakness Support) ]]
    ["RAID_SURV"] = { 
        ["MSC_WEAPON_DPS"]                  = 10.0, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 3.0, -- KING STAT (Expose Weakness)
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.1, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 0.6, 
        ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]= 0.6,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.6, -- Thrill of the Hunt
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.2,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },

    -- [[ 3. MARKSMANSHIP (Raw DPS) ]]
    ["RAID_MM"] = { 
        ["MSC_WEAPON_DPS"]                  = 13.0, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]= 1.0,
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.5, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.5, 
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },

    -- [[ 4. PVP (Marksmanship) ]]
    ["PVP_MM"] = { 
        ["MSC_WEAPON_DPS"]                  = 1.5,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.5, 
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },
}

-- Safety Init
Hunter.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (The Interpolation System)
-- =============================================================
Hunter.LevelingBrackets = {
    -- [[ 1. STANDARD RANGED (1-20) ]]
    -- Pre-Viper. Spirit is okay for regen.
    ["Leveling_1_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = 1.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.5, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 6.0, 
            ["MSC_WEAPON_SPEED"] = 1.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.8,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    
    -- [[ 2. STANDARD RANGED (21-40) ]]
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 6.0, 
            ["MSC_WEAPON_SPEED"] = 2.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.2, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 7.0, 
            ["MSC_WEAPON_SPEED"] = 2.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    
    -- [[ 3. BEAST MASTERY / MARKSMANSHIP (41-70) ]]
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 7.0, 
            ["MSC_WEAPON_SPEED"] = 2.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = 2.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 9.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    ["Leveling_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 9.0, 
            ["MSC_WEAPON_SPEED"] = 3.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 3.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, -- Added for Sync
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 0.5, -- Added TBC Stat
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.0,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },

    -- [[ MELEE HUNTER (The "Drizzt" Build) ]]
    ["Leveling_Melee_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 5.0, 
            ["MSC_WEAPON_SPEED"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.5, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 6.0, 
            ["MSC_WEAPON_SPEED"] = 2.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 2.2, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 0.8,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    ["Leveling_Melee_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 6.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.8, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.2,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 7.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0,
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    ["Leveling_Melee_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 7.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0,
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.0, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2,
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.0,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    ["Leveling_Melee_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["MSC_WEAPON_SPEED"] = 2.5, -- Added for Sync
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.2, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["MSC_WEAPON_SPEED"] = 2.5,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 1.5,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    
    -- [[ SURVIVAL (Ranged Stat Stick Build) ]]
    ["Leveling_Survival_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 6.0, 
            ["MSC_WEAPON_SPEED"] = 2.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.2, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 7.0, 
            ["MSC_WEAPON_SPEED"] = 2.2,
            ["ITEM_MOD_AGILITY_SHORT"] = 3.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    ["Leveling_Survival_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 7.0, 
            ["MSC_WEAPON_SPEED"] = 2.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 3.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    ["Leveling_Survival_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 8.0, 
            ["MSC_WEAPON_SPEED"] = 2.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 3.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 9.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
    ["Leveling_Survival_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 9.0, 
            ["MSC_WEAPON_SPEED"] = 2.8,
            ["ITEM_MOD_AGILITY_SHORT"] = 3.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.5, -- Added for Sync
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 3.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 4.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.0,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.5, -- Reduces downtime
			["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0 -- Ensure RAP items are caught
        }
    },
}
-- =============================================================
-- CLASS METADATA
-- =============================================================
Hunter.Specs = { [1]="BeastMastery", [2]="Marksmanship", [3]="Survival" }

Hunter.PrettyNames = {
    ["RAID_BM"]          = MSC.L["Raid: Beast Mastery"],
    ["RAID_SURV"]        = MSC.L["Raid: Survival (Expose Weakness)"],
    ["RAID_MM"]          = MSC.L["Raid: Marksmanship"],
    ["PVP_MM"]           = MSC.L["PvP: Marksmanship"],
    
    ["Leveling_1_20"]  = MSC.L["Starter (1-20)"],
    ["Leveling_21_40"] = MSC.L["Standard Leveling (21-40)"],
    ["Leveling_41_51"] = MSC.L["Standard Leveling (41-51)"],
    ["Leveling_52_59"] = MSC.L["Standard Leveling (52-59)"],
    ["Leveling_60_70"] = MSC.L["Standard Leveling (Outland)"],
    
    ["Leveling_Melee_21_40"] = MSC.L["Survival Melee (21-40)"],
    ["Leveling_Melee_41_51"] = MSC.L["Survival Melee (41-51)"],
    ["Leveling_Melee_52_59"] = MSC.L["Survival Melee (52-59)"],
    ["Leveling_Melee_60_70"] = MSC.L["Survival Melee (Outland)"],
    
    ["Leveling_Survival_21_40"] = MSC.L["Survival Leveling (21-40)"],
    ["Leveling_Survival_41_51"] = MSC.L["Survival Leveling (41-51)"],
    ["Leveling_Survival_52_59"] = MSC.L["Survival Leveling (52-59)"],
    ["Leveling_Survival_60_70"] = MSC.L["Survival Leveling (Outland)"],
}

Hunter.SpeedChecks = { 
    ["Default"]={ Ranged_Slow=true } 
}

Hunter.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true,             -- Polearms
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
}

Hunter.StatToCritMatrix = { 
    Agi = { {1, 4.5}, {60, 53.0}, {70, 40.0} } 
}

Hunter.Talents = { 
    ["SUREFOOTED"] = MSC.L["Surefooted"],
    ["BESTIAL_WRATH"]= MSC.L["Bestial Wrath"], 
    ["BEAST_WITHIN"]= MSC.L["The Beast Within"], 
    ["TRUESHOT_AURA"]= MSC.L["Trueshot Aura"], 
    ["SILENCING_SHOT"]= MSC.L["Silencing Shot"], 
    ["SCATTER_SHOT"]= MSC.L["Scatter Shot"], 
    ["WYVERN_STING"]= MSC.L["Wyvern Sting"], 
    ["READYNESS"]= MSC.L["Readiness"], 
    ["EXPOSE_WEAKNESS"]= MSC.L["Expose Weakness"], 
    ["CAREFUL_AIM"]= MSC.L["Careful Aim"], 
    ["SAVAGE_STRIKES"] = MSC.L["Savage Strikes"],
    ["SURVIVAL_INST"]= MSC.L["Survival Instincts"] 
}

-- =============================================================
-- LOGIC
-- =============================================================
function Hunter:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level >= 60 then
        if Rank("BEAST_WITHIN") > 0 or Rank("BESTIAL_WRATH") > 0 then return "RAID_BM" end
        if Rank("EXPOSE_WEAKNESS") > 0 then return "RAID_SURV" end -- Simplified
        if Rank("TRUESHOT_AURA") > 0 then return "RAID_MM" end
        return "RAID_BM"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

	local role = "Leveling"   
    -- 1. Check for Intentional Melee Build (Savage Strikes)
    if Rank("SAVAGE_STRIKES") > 0 then
        role = "Leveling_Melee"
    -- 2. Check for Standard Ranged Survival (Expose Weakness / Surv Instincts)
    elseif Rank("SURVIVAL_INST") > 0 or Rank("EXPOSE_WEAKNESS") > 0 then 
        role = "Leveling_Survival"
        -- Survival uses the normal 41_51 / 52_59 / 60_70 brackets (there is no 1_20 row,
        -- so low levels fall through to the generic Leveling key below).
    end

    local specificKey = role .. suffix
    if Hunter.LevelingBrackets and Hunter.LevelingBrackets[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Hunter:GetDynamicWeights(forceKey)

    if forceKey and not Hunter.LevelingBrackets[forceKey] and not Hunter.Weights[forceKey] then
        if Hunter.PrettyNames then
            for key, name in pairs(Hunter.PrettyNames) do
                if name == forceKey then
                    forceKey = key
                    break
                end
            end
        end
    end

    local level = UnitLevel("player")
    local specKey = forceKey or self:GetSpec() 

    -- 1. Check Leveling Brackets
    if Hunter.LevelingBrackets and Hunter.LevelingBrackets[specKey] then
        local bracket = Hunter.LevelingBrackets[specKey]
        
        -- Calculate progress
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        
        if forceKey then
            if level < bracket.min then progress = 0 end -- Show Start weights
            if level > bracket.max then progress = 1 end -- Show End weights
        else
            -- Normal play strict clamping
            if progress < 0 then progress = 0 end
            if progress > 1 then progress = 1 end
        end

        local dynamicWeights = {}
        
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
    if Hunter.Weights and Hunter.Weights[specKey] then 
        return Hunter.Weights[specKey], specKey
    elseif Hunter.LevelingWeights and Hunter.LevelingWeights[specKey] then 
        return Hunter.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Hunter:ApplyScalers(weights, currentSpec)
    local w = {}
    for k, v in pairs(weights) do w[k] = v end
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- [[ 1. CAREFUL AIM (Int -> RAP) ]]
    local rCare = Rank("CAREFUL_AIM")
    if rCare > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
        -- Careful Aim: 1 Int = 1 RAP. 
        -- If AP weight is 1.0, Int gets +1.0 value.
        local apWeight = w["ITEM_MOD_ATTACK_POWER_SHORT"] or 1.0
        local conversionRatio = rCare * 0.33 -- 33%, 66%, 100%
        w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] + (conversionRatio * apWeight)
    end
    
    -- [[ 2. EXPOSE WEAKNESS (Agi Scaling) ]]
    if Rank("EXPOSE_WEAKNESS") > 0 and w["ITEM_MOD_AGILITY_SHORT"] then 
        w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * 1.2 
    end

	-- [[ 3. HIT CAP (Uses Ranged Hit) ]]
    if MSC.BuffEngine and w["ITEM_MOD_HIT_RATING_SHORT"] and w["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        MSC.BuffEngine:ApplyMeleeHitCap(w, activeCaps, currentSpec, Rank("SUREFOOTED") * 1, 7)
    end

    -- [[ 4. MELEE WEAPON = STAT STICK ]]
    -- Weapon DPS weight is calibrated for the ranged slot. A ranged Hunter
    -- only swings the melee weapon for the odd Raptor Strike / Wing Clip, so
    -- its DPS is worth a fraction of that; its stats still count in full.
    if not (currentSpec or ""):upper():find("MELEE") and (w["MSC_WEAPON_DPS"] or 0) > 0 then
        w["MSC_WEAPON_DPS_MELEE"] = w["MSC_WEAPON_DPS"] * 0.15
    end

    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return w, capText
end

function Hunter:GetWeaponBonus(itemLink, weights) 
    if not itemLink or not weights then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local race = MSC.CtxRace()
    local level = MSC.CtxLevel()
    if level > 70 then level = 70 end
    
    -- Dynamically calculate how much score 1% Crit is worth right now
    local critScalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level] and MSC.CombatRatingScalars[level][9]) or 22.1
    local critWeight = weights["ITEM_MOD_CRIT_RATING_SHORT"] or 1.0
    local scoreValue = critScalar * critWeight

    -- TBC Racials: Troll (Bow) / Dwarf (Gun) give +1% Crit
    if race == "Dwarf" and subClassID == 3 then bonus = bonus + scoreValue end
    if race == "Troll" and subClassID == 2 then bonus = bonus + scoreValue end
    
    return bonus
end

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Hunter.Profiles = {}
for k, v in pairs(Hunter.Weights) do Hunter.Profiles[k] = v end
if Hunter.LevelingBrackets then
    for k, v in pairs(Hunter.LevelingBrackets) do
        local prof = {}
        for stat, w in pairs(v.End or {}) do prof[stat] = w end
        for stat, w in pairs(v) do
            if type(w) == "number" and stat ~= "min" and stat ~= "max" and prof[stat] == nil then prof[stat] = w end
        end
        Hunter.Profiles[k] = prof
    end
end
if Hunter.LevelingWeights then
    for k, v in pairs(Hunter.LevelingWeights) do Hunter.Profiles[k] = v end
end

MSC.RegisterModule("HUNTER", Hunter)
