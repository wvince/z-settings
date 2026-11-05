local addonName, MSC = ...
local Warlock = {}
Warlock.Name = "WARLOCK"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Warlock.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.3, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.1, -- Tie-breaker only
        ["MSC_WEAPON_DPS"]=0.0 
    },

    -- [[ 1. DESTRUCTION SHADOW ]]
    ["DESTRUCT_SHADOW"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.3, -- SP > Shadow
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.5, -- Survival
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.05,
        -- POISON PROTECTION
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 0.02, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 2. DESTRUCTION FIRE ]]
    ["DESTRUCT_FIRE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.3, -- SP > Fire
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.5, -- Survival
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.05,
        -- POISON PROTECTION
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 3. RAID AFFLICTION ]]
    ["RAID_AFFLICTION"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.3, -- SP > Shadow
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.4, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.6, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.3,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.1,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 0.02,
    },

    -- [[ 4. DEMO PVE ]]
    ["DEMO_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 0.95, -- Added back (slightly lower than SP)
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.9, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.6, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.1,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 5. PVP SL/SL ]]
    ["PVP_SL_SL"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.8, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_SPELL_PENETRATION_SHORT"]= 1.2, -- Added: Very important for TBC PvP
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.3, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.0,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.1,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },
}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS
-- =============================================================
Warlock.LevelingBrackets = {
    -- [[ STANDARD AFFLICTION (1-20) ]]
    -- Wand is God. Spirit/Stam for Life Tap sustainability.
    ["Leveling_1_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 1, max = 20,
        Start = { 
            ["MSC_WAND_DPS"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.6, -- Bumped slightly above school specific
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 0.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.3, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.4,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        }
    },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 21, max = 40,
        Start = { 
            ["MSC_WAND_DPS"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.3, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,      
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.4,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        },
        End = { 
            ["MSC_WAND_DPS"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.6, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        }
    },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, -- Dark Pact era (Mana from Pet). Spirit value drops.
        min = 41, max = 51,
        Start = { 
            ["MSC_WAND_DPS"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.6, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,       
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,        
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.1, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        }
    },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 52, max = 59,
        Start = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.1, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.6, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5
        }
    },
    ["Leveling_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, -- Outland Drain Tanking / Affliction
        min = 60, max = 70,
        Start = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.6, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.5,     
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,           
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,         
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 3.3, -- Slight bump to prioritize generic SP
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 3.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 1.0
        }
    },

    -- [[ DESTRUCTION (FIRE) ]]
    -- Focus: Crit / Fire Dmg / Int (Mana hungry).
    ["Leveling_Fire_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 21, max = 40,
        Start = { 
            ["MSC_WAND_DPS"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.3, -- SP > Fire
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,    
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,      
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.6, -- SP > Fire
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Fire_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 41, max = 51,
        Start = { 
            ["MSC_WAND_DPS"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.6, -- SP > Fire
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.3, -- SP > Fire
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Fire_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 52, max = 59,
        Start = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.3, -- SP > Fire
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 2.2,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.6, -- SP > Fire
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Fire_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 60, max = 70,
        Start = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.6, -- SP > Fire
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 2.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,    
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 3.6, -- SP > Fire
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 3.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
-- [[ DESTRUCTION (SHADOW) LEVELING ]]
    -- Focus: Crit / Shadow Dmg / Int (Mana hungry).
    ["Leveling_Destro_Shadow_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 21, max = 40,
        Start = { 
            ["MSC_WAND_DPS"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.3, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,    
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,      
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.6, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Destro_Shadow_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 41, max = 51,
        Start = { 
            ["MSC_WAND_DPS"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.6, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.3, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Destro_Shadow_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 52, max = 59,
        Start = { 
            ["MSC_WAND_DPS"] = 0.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.3, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.2,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.6, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Destro_Shadow_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 60, max = 70,
        Start = { 
            ["MSC_WAND_DPS"] = 0.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.6, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,    
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 3.6, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 3.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.4,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
	
    -- [[ DEMO LEVELING ]]
    -- Focus: Stamina (Pet Scaling) / SP.
    ["Leveling_Demo_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 21, max = 40,
        Start = { 
            ["MSC_WAND_DPS"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.9, -- Slightly bumped
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,    
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.1,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.4,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.3, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Demo_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, -- Felguard Era
        min = 41, max = 51,
        Start = { 
            ["MSC_WAND_DPS"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.3, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,      
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.6, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.9, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.8,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Demo_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 52, max = 59,
        Start = { 
            ["MSC_WAND_DPS"] = 0.6, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.9, -- SP > Shadow       
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.3, -- SP > Shadow
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.2, -- Fixed dip
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Demo_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,
        min = 60, max = 70,
        Start = { 
            ["MSC_WAND_DPS"] = 0.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.8,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.6, -- SP > Shadow      
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.5, -- Fixed dip
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2,    
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5,           
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { 
            ["MSC_WAND_DPS"] = 0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 3.2, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 3.0, -- HUGE FIX: Was 0.5. Now stays relevant.
            ["ITEM_MOD_STAMINA_SHORT"] = 2.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
}
-- =============================================================
-- CLASS METADATA
-- =============================================================
Warlock.Specs = { [1]="Affliction", [2]="Demonology", [3]="Destruction" }

Warlock.PrettyNames = {
    ["DESTRUCT_SHADOW"]  = MSC.L["Raid: Destruction (Shadow)"],
    ["DESTRUCT_FIRE"]    = MSC.L["Raid: Destruction (Fire)"],
    ["RAID_AFFLICTION"]  = MSC.L["Raid: Affliction (UA)"],
    ["DEMO_PVE"]         = MSC.L["Raid: Demonology (Felguard)"],
    ["PVP_SL_SL"]        = MSC.L["PvP: Soul Link / Siphon Life"],
    -- Leveling Brackets
    ["Leveling_1_20"]  = MSC.L["Starter (1-20)"],
    ["Leveling_21_40"] = MSC.L["Standard Leveling (21-40)"],
    ["Leveling_41_51"] = MSC.L["Standard Leveling (41-51)"],
    ["Leveling_52_59"] = MSC.L["Standard Leveling (52-59)"],
    ["Leveling_60_70"] = MSC.L["Standard Leveling (Outland)"],
	
    ["Leveling_Fire_21_40"] = MSC.L["Destro Fire (21-40)"],
    ["Leveling_Fire_41_51"] = MSC.L["Destro Fire (41-51)"],
    ["Leveling_Fire_52_59"] = MSC.L["Destro Fire (52-59)"],
    ["Leveling_Fire_60_70"] = MSC.L["Destro Fire (Outland)"],
    
	["Leveling_Destro_Shadow_21_40"] = MSC.L["Destro Shadow (21-40)"],
    ["Leveling_Destro_Shadow_41_51"] = MSC.L["Destro Shadow (41-51)"],
    ["Leveling_Destro_Shadow_52_59"] = MSC.L["Destro Shadow (52-59)"],
    ["Leveling_Destro_Shadow_60_70"] = MSC.L["Destro Shadow (Outland)"],
	
    ["Leveling_Demo_21_40"] = MSC.L["Demonology (21-40)"],
    ["Leveling_Demo_41_51"] = MSC.L["Demonology (41-51)"],
    ["Leveling_Demo_52_59"] = MSC.L["Demonology (52-59)"],
    ["Leveling_Demo_60_70"] = MSC.L["Demonology (Outland)"],
}

Warlock.SpeedChecks = { ["Default"]={} }

Warlock.ValidWeapons = {
    [7]=true,             -- 1H Swords
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

Warlock.StatToCritMatrix = { 
    Agi = { {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.5}, {60, 60.6}, {70, 80.0} } 
}

Warlock.Talents = { 
    ["DARK_PACT"]       = MSC.L["Dark Pact"], 
    ["UNSTABLE_AFF"]    = MSC.L["Unstable Affliction"], 
    ["SIPHON_LIFE"]     = MSC.L["Siphon Life"], 
    ["SOUL_LINK"]       = MSC.L["Soul Link"],
    ["FEL_DOMINATION"]  = MSC.L["Fel Domination"], -- read by GetSpec (Soul Link leveling route)
    ["SUMMON_FELGUARD"] = MSC.L["Summon Felguard"], 
    ["CONFLAGRATE"]     = MSC.L["Conflagrate"], 
    ["RUIN"]            = MSC.L["Ruin"], 
    ["SHADOWFURY"]      = MSC.L["Shadowfury"], 
    ["DEMONIC_EMBRACE"] = MSC.L["Demonic Embrace"], 
    ["FEL_INTELLECT"]   = MSC.L["Fel Intellect"],
    ["EMBERSTORM"]      = MSC.L["Emberstorm"],
    ["SUPPRESSION"]     = MSC.L["Suppression"],
    ["DEMONIC_AEGIS"]     = MSC.L["Demonic Aegis"],
    ["DEMONIC_KNOWLEDGE"] = MSC.L["Demonic Knowledge"],
-- Combat Lab DPET Modifiers:
    ["SHADOW_MASTERY"]  = MSC.L["Shadow Mastery"],
    ["IMP_CORRUPTION"]  = MSC.L["Improved Corruption"],
    ["BANE"]            = MSC.L["Bane"],
    ["SHADOW_AND_FLAME"]= MSC.L["Shadow and Flame"],
    ["EMP_CORRUPTION"]  = MSC.L["Empowered Corruption"],
    ["CONTAGION"]       = MSC.L["Contagion"],
    ["IMP_IMMOLATE"]    = MSC.L["Improved Immolate"],
    ["SHADOWBURN"]      = MSC.L["Shadowburn"]
}

-- =============================================================
-- LOGIC
-- =============================================================
function Warlock:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
-- [[ ENDGAME DETECTION ]]
if level == 70 then
    if Rank("UNSTABLE_AFF") > 0 or Rank("SHADOW_MASTERY") > 0 then 
        return "RAID_AFFLICTION" 
    end
    if Rank("SUMMON_FELGUARD") > 0 then 
        return "DEMO_PVE" 
    end
    if Rank("EMBERSTORM") > 0 then 
        return "DESTRUCT_FIRE" 
    end
    if Rank("SHADOW_AND_FLAME") > 0 then 
        return "DESTRUCT_SHADOW" 
    end
    return "DESTRUCT_SHADOW"
end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
	if Rank("CONFLAGRATE") > 0 then 
		role = "Leveling_Fire"
	elseif Rank("SHADOW_AND_FLAME") > 0 then 
		role = "Leveling_Destro_Shadow" -- FIXED!
	elseif Rank("SOUL_LINK") > 0 or Rank("FEL_DOMINATION") > 0 then 
		role = "Leveling_Demo"
    end 

    local specificKey = role .. suffix
    if Warlock.LevelingBrackets and Warlock.LevelingBrackets[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Warlock:GetDynamicWeights(forceKey)
    -- [[ FIX 1: TRANSLATOR ]]
    -- If the dropdown sends a "Pretty Name" (e.g. "Standard Leveling..."), 
    -- we reverse-lookup the "Code Key" (e.g. "Leveling_2H...").
    if forceKey and not Warlock.LevelingBrackets[forceKey] and not Warlock.Weights[forceKey] then
        if Warlock.PrettyNames then
            for key, name in pairs(Warlock.PrettyNames) do
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
    if Warlock.LevelingBrackets and Warlock.LevelingBrackets[specKey] then
        local bracket = Warlock.LevelingBrackets[specKey]
        
        -- Calculate progress
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        
        -- [[ FIX 2: PREVIEW CLAMPING ]]
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
        
        -- [[ FIX 3: ROBUSTNESS ]]
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
    if Warlock.Weights and Warlock.Weights[specKey] then 
        return Warlock.Weights[specKey], specKey
    elseif Warlock.LevelingWeights and Warlock.LevelingWeights[specKey] then 
        return Warlock.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Warlock:ApplyScalers(weights, currentSpec)
    -- [[ FIX: SAFETY GUARD ]]
    -- We add "or 0" here. If GetTalentRank returns nil (unscanned/missing), 
    -- it defaults to 0 so the math below never crashes.
    local function Rank(k) return MSC:GetTalentRank(k) or 0 end
    
    local level = UnitLevel("player")
    local activeCaps = {}
    
    -- [[ 1. EXISTING TALENTS ]]
    -- Now safe: 1 + (0 * 0.03) = 1. No more crash.
    local rEmb = Rank("DEMONIC_EMBRACE")
    if rEmb > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then 
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03)) 
    end
    
    local rFel = Rank("FEL_INTELLECT")
    if rFel > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rFel * 0.01)) 
    end

    -- [[ 2. FEL ARMOR & DEMONIC KNOWLEDGE ]]
    if level >= 62 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        local spiritConversion = 0.3 -- Base Fel Armor (30%)
        
        local rDemonicAegis = Rank("DEMONIC_AEGIS") 
        if rDemonicAegis > 0 then
            spiritConversion = spiritConversion * (1 + (rDemonicAegis * 0.10)) 
        end
        
        -- Add Spell Power value of Spirit to the Spirit Weight
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] + (spiritConversion * (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 1.0))
    end

    -- Demonic Knowledge (Stam/Int -> SP)
    local rDemoKnow = Rank("DEMONIC_KNOWLEDGE")
    if rDemoKnow > 0 then
        local boost = rDemoKnow * 0.05
        if weights["ITEM_MOD_STAMINA_SHORT"] then 
            weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] + boost
        end
        if weights["ITEM_MOD_INTELLECT_SHORT"] then 
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + boost
        end
    end

    -- [[ 3. COVARIANCE (Destro Loves Crit/Haste) ]]
    if currentSpec:find("DESTRUCT") then
        local spellPower = 0
        if currentSpec:find("SHADOW") then spellPower = MSC.GetJudgingSpellDamage(6) -- Shadow 
        else spellPower = MSC.GetJudgingSpellDamage(3) end -- Fire
        
        if spellPower > 600 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            local scaler = 1 + ((spellPower - 600) / 10000)
            if scaler > 1.2 then scaler = 1.2 end -- Capped at 20% bonus
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * scaler
            if weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
                 weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * scaler
            end
        end
    end
    
    -- [[ 2. HIT CAP ]]
    if MSC.BuffEngine and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local talentBonusPct = 0
        if (currentSpec:find("AFFLICTION") or currentSpec:find("Leveling")) and not currentSpec:find("Fire") then
             talentBonusPct = Rank("SUPPRESSION") * 2
        end
        MSC.BuffEngine:ApplySpellHitCap(weights, activeCaps, currentSpec, talentBonusPct, { softMult = 0.2, hardLabel = MSC.L["Hit (Capped)"] })
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Warlock:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Warlock.Profiles = {}

-- 1. Register Static Weights
for k, v in pairs(Warlock.Weights) do 
    Warlock.Profiles[k] = v 
end

if Warlock.LevelingBrackets then
    for k, v in pairs(Warlock.LevelingBrackets) do 
        Warlock.Profiles[k] = v.End 
    end
end

MSC.RegisterModule("WARLOCK", Warlock)

