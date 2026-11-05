local addonName, MSC = ...
local Mage = {}
Mage.Name = "MAGE"

-- =============================================================
-- ENDGAME STAT WEIGHTS (Static Profiles)
-- =============================================================
Mage.Weights = {
    ["Default"] = { ["MSC_WEAPON_DPS_MELEE"]=0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
        ["MSC_WEAPON_DPS"]=0.02 
    },

    -- [[ 1. ARCANE (Mana Battery / Burst) ]]
    ["ARCANE_RAID"] = { ["MSC_WEAPON_DPS_MELEE"]=0, 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.2, -- King Stat (Mind Mastery)
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.7, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.6, -- Arcane Meditation
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 2. FIRE (Crit / Ignite) ]]
    ["FIRE_RAID"] = { ["MSC_WEAPON_DPS_MELEE"]=0, 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.95, -- Ignite
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 3. FROST PVE (Safe DPS) ]]
    ["FROST_PVE"] = { ["MSC_WEAPON_DPS_MELEE"]=0, 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]     = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.02,
    },

    -- [[ 4. FROST PVP ]]
    ["FROST_PVP"] = { ["MSC_WEAPON_DPS_MELEE"]=0, 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]     = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
        ["MSC_PVP_UTILITY"]                 = 1.0,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 5. FROST AOE ]]
    ["FROST_AOE"] = { ["MSC_WEAPON_DPS_MELEE"]=0, 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.5, -- Mana Pool
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]     = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.1, -- Blizzard doesn't crit
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.1, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },
}

-- Safety Init
Mage.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (The Interpolation System)
-- =============================================================
Mage.LevelingBrackets = {
    -- [[ 1. STANDARD FROST (Single Target) ]]
    -- Wand DPS is king early.
    ["Leveling_1_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
		min = 1, max = 20,
		Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
			["MSC_WAND_DPS"] = 3.0, -- CRITICAL FIX: Wand, not Melee
			["MSC_WEAPON_DPS"] = 0.1, -- Melee is useless
			["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
			["ITEM_MOD_SPIRIT_SHORT"] = 0.8, -- Buffed: Spirit = uptime
			["ITEM_MOD_STAMINA_SHORT"] = 0.8, 
			["ITEM_MOD_SPELL_POWER_SHORT"] = 0.5, 
			["ITEM_MOD_FROST_DAMAGE_SHORT"] = 0.5,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
		},
		End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
			["MSC_WAND_DPS"] = 2.0, 
			["MSC_WEAPON_DPS"] = 0.1,
			["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
			["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8, 
			["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
			["ITEM_MOD_SPIRIT_SHORT"] = 0.8,
			["ITEM_MOD_FROST_DAMAGE_SHORT"] = 0.8,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
		}
	},
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 21, max = 40,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2 -- Added for Sync
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5
        }
    },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.6, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, -- Added for Sync
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.2, -- Added for Sync
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, -- Added for Sync
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 2.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },

    -- [[ 6. FIRE LEVELING ]]
    -- Crit is vital for Master of Elements (Mana Sustain).
    ["Leveling_Fire_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.8, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.5, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Fire_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.5, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.8, -- Added for Sync
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.2, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2, -- Scaling down to match lvl 60 start
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_Fire_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.2, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },

    -- [[ 7. AOE BLIZZARD LEVELING ]]
    -- Stamina (Don't Die) > Int (Don't OOM) > SP (Kill).
    ["Leveling_AoE_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.8,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.2
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.2
        }
    },
    ["Leveling_AoE_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.2
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.2
        }
    },
    ["Leveling_AoE_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 2.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.8, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.2
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 3.5, -- Effective Health is King
            ["ITEM_MOD_INTELLECT_SHORT"] = 3.0, -- Mana Pool is Queen
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, -- Spell Power is just a nice bonus
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.2
        }
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Mage.Specs = { [1]="Arcane", [2]="Fire", [3]="Frost" }

Mage.PrettyNames = {
    ["FIRE_RAID"]        = MSC.L["Raid: Deep Fire"],
    ["ARCANE_RAID"]      = MSC.L["Raid: Arcane (Mind Mastery)"],
    ["FROST_PVE"]        = MSC.L["Raid: Deep Frost"],
    ["FROST_PVP"]        = MSC.L["PvP: Frost"],
    ["FROST_AOE"]        = MSC.L["Farming: AoE Blizzard"],
    
    ["Leveling_1_20"]  = MSC.L["Starter (1-20)"],
    ["Leveling_21_40"] = MSC.L["Standard Leveling (21-40)"],
    ["Leveling_41_51"] = MSC.L["Standard Leveling (41-51)"],
    ["Leveling_52_59"] = MSC.L["Standard Leveling (52-59)"],
    ["Leveling_60_70"] = MSC.L["Standard Leveling (Outland)"],
    
    ["Leveling_Fire_21_40"] = MSC.L["Fire (21-40)"],
    ["Leveling_Fire_41_51"] = MSC.L["Fire (41-51)"],
    ["Leveling_Fire_52_59"] = MSC.L["Fire (52-59)"],
    ["Leveling_Fire_60_70"] = MSC.L["Fire (Outland)"],
    
    ["Leveling_AoE_21_40"] = MSC.L["Frost AoE Grind (21-40)"],
    ["Leveling_AoE_41_51"] = MSC.L["Frost AoE Grind (41-51)"],
    ["Leveling_AoE_52_59"] = MSC.L["Frost AoE Grind (52-59)"],
    ["Leveling_AoE_60_70"] = MSC.L["Frost AoE Grind (Outland)"],
}

Mage.SpeedChecks = { 
    ["Default"]={} 
}

Mage.ValidWeapons = {
    [7]=true,             -- 1H Swords
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

Mage.StatToCritMatrix = { 
    Agi = { {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } 
}

Mage.Talents = { 
    ["ELEMENTAL_PRECISION"] = MSC.L["Elemental Precision"],
    ["ARCANE_POWER"]    = MSC.L["Arcane Power"], 
    ["SLOW"]            = MSC.L["Slow"], 
    ["COMBUSTION"]      = MSC.L["Combustion"], 
    ["DRAGONS_BREATH"]  = MSC.L["Dragon's Breath"], 
    ["ICE_BARRIER"]     = MSC.L["Ice Barrier"], 
    ["SUMMON_WELE"]     = MSC.L["Summon Water Elemental"], 
    ["WINTERS_CHILL"]   = MSC.L["Winter's Chill"], 
    ["IMP_BLIZZARD"]    = MSC.L["Improved Blizzard"], 
    ["ARCANE_MIND"]     = MSC.L["Arcane Mind"], 
    ["MOLTEN_ARMOR"]    = MSC.L["Molten Armor"], 
    ["ICY_VEINS"]       = MSC.L["Icy Veins"],
    ["ARCANE_FOCUS"]    = MSC.L["Arcane Focus"],
    ["MIND_MASTERY"]    = MSC.L["Mind Mastery"]
}

-- =============================================================
-- LOGIC
-- =============================================================
function Mage:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level >= 60 then
        if Rank("DRAGONS_BREATH") > 0 or Rank("COMBUSTION") > 0 then return "FIRE_RAID" end
        if Rank("SLOW") > 0 or Rank("ARCANE_POWER") > 0 then return "ARCANE_RAID" end
        if Rank("SUMMON_WELE") > 0 or Rank("ICE_BARRIER") > 0 then
            if Rank("IMP_BLIZZARD") > 0 and Rank("WINTERS_CHILL") == 0 then return "FROST_AOE" end
            if Rank("WINTERS_CHILL") > 0 then return "FROST_PVE" end
            return "FROST_PVP"
        end
        return "FROST_PVP"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    -- Determine Role
    local role = "Leveling" 
    if Rank("IMP_BLIZZARD") >= 2 then role = "Leveling_AoE"
    elseif Rank("DRAGONS_BREATH") > 0 or Rank("COMBUSTION") > 0 then role = "Leveling_Fire"
    end 

    local specificKey = role .. suffix
    if Mage.LevelingBrackets and Mage.LevelingBrackets[specificKey] then return specificKey end
    if Mage.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Mage:GetDynamicWeights(forceKey)
    -- [[ TRANSLATOR ]]
    if forceKey and not Mage.LevelingBrackets[forceKey] and not Mage.Weights[forceKey] then
        if Mage.PrettyNames then
            for key, name in pairs(Mage.PrettyNames) do
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
    if Mage.LevelingBrackets and Mage.LevelingBrackets[specKey] then
        local bracket = Mage.LevelingBrackets[specKey]
        
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
    if Mage.Weights and Mage.Weights[specKey] then 
        return Mage.Weights[specKey], specKey
    elseif Mage.LevelingWeights and Mage.LevelingWeights[specKey] then 
        return Mage.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Mage:ApplyScalers(weights, currentSpec)
    -- [[ SAFETY COPY ]]
    local w = {}
    for k, v in pairs(weights) do w[k] = v end

    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- [[ 1. MIND MASTERY / ARCANE MIND ]]
    local rMindMastery = Rank("MIND_MASTERY")
    if rMindMastery > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
        local bonusRatio = rMindMastery * 0.05 
        w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] + (bonusRatio * (w["ITEM_MOD_SPELL_POWER_SHORT"] or 1.0))
    end

    local rArcaneMind = Rank("ARCANE_MIND")
    if rArcaneMind > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
        w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rArcaneMind * 0.03)) 
    end
    
    -- [[ 2. COVARIANCE ]]
    if w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        local spellPower = MSC.GetJudgingStats().sp -- largest school
        if spellPower > 500 then
            local spScaler = 1 + ((spellPower - 500) / 2000)
            if spScaler > 1.15 then spScaler = 1.15 end
            w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * spScaler
        end
    end

    -- [[ 3. HIT CAP (With Hysteresis) ]]
    if MSC.BuffEngine and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local arcaneBonusPct = Rank("ARCANE_FOCUS") * 2
        local frostFireBonusPct = Rank("ELEMENTAL_PRECISION") * 1
        local talentBonusPct = math.max(arcaneBonusPct, frostFireBonusPct)
        MSC.BuffEngine:ApplySpellHitCap(w, activeCaps, currentSpec, talentBonusPct)
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return w, capText
end

function Mage:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Mage.Profiles = {}
for k, v in pairs(Mage.Weights) do Mage.Profiles[k] = v end
if Mage.LevelingBrackets then
    for k, v in pairs(Mage.LevelingBrackets) do
        local prof = {}
        for stat, w in pairs(v.End or {}) do prof[stat] = w end
        for stat, w in pairs(v) do
            if type(w) == "number" and stat ~= "min" and stat ~= "max" and prof[stat] == nil then prof[stat] = w end
        end
        Mage.Profiles[k] = prof
    end
end
if Mage.LevelingWeights then
    for k, v in pairs(Mage.LevelingWeights) do Mage.Profiles[k] = v end
end

MSC.RegisterModule("MAGE", Mage)

