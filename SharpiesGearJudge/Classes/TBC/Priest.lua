local addonName, MSC = ...
local Priest = {}
Priest.Name = "PRIEST"

-- =============================================================
-- ENDGAME STAT WEIGHTS (Static Profiles)
-- =============================================================
Priest.Weights = {
    -- Before a spec is known: Spell Power keeps a small damage value (it heals at the Healing weight too).
    ["Default"] = { 
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0,
		["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.3,		
        ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5,
        ["MSC_WEAPON_DPS"]=0.0, 
    },
    
    -- [[ 1. HOLY (Deep Healing) ]]
    -- Spell Power is the damage value only: "damage and healing" gear also heals, and the scorer adds that at the Healing weight.
    ["HOLY_DEEP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 1.1, -- Spiritual Guidance
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.4, 

        -- POISON PROTECTION
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 2. DISC (Support/Efficiency) ]]
    -- Spell Power is the damage value only: "damage and healing" gear also heals, and the scorer adds that at the Healing weight.
    ["DISC_SUPPORT"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.5, -- Max Mana = Rapture
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.6, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.5,
        
        -- POISON PROTECTION
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 3. SHADOW PVE (Mana Battery) ]]
    ["SHADOW_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.4, -- Cap is #1
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.2, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.4, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.3, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.05, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.5,
        
        -- POISON PROTECTION
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]    = 0.1, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 4. SMITE DPS (Niche) ]]
    ["SMITE_DPS"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_HOLY_DAMAGE_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.7, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.7, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 5. SHADOW PVP ]]
    ["SHADOW_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.6, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },
}

-- Safety Init
Priest.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (The Interpolation System)
-- =============================================================
Priest.LevelingBrackets = {
    -- [[ 1. SHADOW / SPIRIT TAP (1-20) ]]
    -- Wand is primary DPS source. Spirit is primary Mana source.
    ["Leveling_1_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
		min = 1, max = 20,
		Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
			["MSC_WAND_DPS"] = 4.0, -- Priest 1-20 is 50% Wanding. Priority #1.
			["MSC_WEAPON_DPS"] = 0.1,
			["ITEM_MOD_SPIRIT_SHORT"] = 3.0, 
			["ITEM_MOD_SPELL_POWER_SHORT"] = 0.5, 
			["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
			["ITEM_MOD_STAMINA_SHORT"] = 0.8,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
			["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 0.2
		},
		End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
			["MSC_WAND_DPS"] = 3.0, 
			["MSC_WEAPON_DPS"] = 0.1,
			["ITEM_MOD_SPIRIT_SHORT"] = 2.5, 
			["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
			["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
			["ITEM_MOD_STAMINA_SHORT"] = 0.8,
			["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
			["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 0.5
		}
	},
    
    -- [[ 2. SHADOW / SPIRIT TAP (21-40) ]]
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 21, max = 40,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 2.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1, -- Added for Sync
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2 -- Added for Sync
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 2.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5
        }
    },
    
    -- [[ 3. SHADOWFORM ERA (41-59) ]]
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 2.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1 -- Added for Sync
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 1.0, -- Spells taking over
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.8, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 2.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1 -- Added for Sync
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.2, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.8,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    
    -- [[ 5. OUTLAND SHADOW (60-70) ]]
    -- Crit nerfed significantly (DoTs don't crit). SP/Shadow bumped.
    ["Leveling_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.5, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 2.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.5, -- TBC Stat
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1 -- Added for Sync
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 3.0, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 3.0, -- Frozen Shadoweave is BiS
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5, -- NERFED: Crit is weak for Shadow
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    
    -- [[ SMITE PRIEST (Holy Fire/Smite) ]]
    -- Unlike Shadow, Smite DOES Crit. Keep Crit high here.
    ["Leveling_Smite_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 21, max = 40,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.8,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.2, -- Added for Sync
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1, -- Added for Sync
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8 -- Added for Sync
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8
        }
    },
    ["Leveling_Smite_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1, -- Added for Sync
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8 -- Added for Sync
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8
        }
    },
    ["Leveling_Smite_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1, -- Added for Sync
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8 -- Added for Sync
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.4, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8
        }
    },
    ["Leveling_Smite_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.4, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.5, -- TBC Stat
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1 -- Added for Sync
        },
        End = { ["MSC_WEAPON_DPS_MELEE"]=0, 
            ["MSC_WEAPON_DPS"] = 0.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.4, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_HOLY_DAMAGE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 0.1
        }
    },
    
    -- [[ HEALER BRACKETS (Dungeon Grinding) ]]
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.2, -- [[ ADDED ]]
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0,
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.2, -- [[ ADDED ]]
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8
        }
    },
    ["Leveling_Healer_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.2, -- [[ ADDED ]]
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.5,
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 0.8, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 0.0, 
            ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = 1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 0.2, -- [[ ADDED ]]
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.8, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 3.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = 1.0
        }
    },
}	

-- =============================================================
-- CLASS METADATA
-- =============================================================
Priest.Specs = { [1]="Discipline", [2]="Holy", [3]="Shadow" }

Priest.PrettyNames = {
    ["HOLY_DEEP"]       = MSC.L["Healer: Circle of Healing"],
    ["DISC_SUPPORT"]    = MSC.L["Healer: Discipline (Pain Supp)"],
    ["SMITE_DPS"]       = MSC.L["DPS: Smite (Holy Fire)"],
    ["SHADOW_PVE"]      = MSC.L["DPS: Shadow (Mana Battery)"],
    ["SHADOW_PVP"]      = MSC.L["PvP: Shadow"],
    
    ["Leveling_1_20"]  = MSC.L["Starter (1-20)"],
    ["Leveling_21_40"] = MSC.L["Standard Leveling (21-40)"],
    ["Leveling_41_51"] = MSC.L["Standard Leveling (41-51)"],
    ["Leveling_52_59"] = MSC.L["Standard Leveling (52-59)"],
    ["Leveling_60_70"] = MSC.L["Standard Leveling (Outland)"],
    
    ["Leveling_Smite_21_40"] = MSC.L["Smite DPS (21-40)"],
    ["Leveling_Smite_41_51"] = MSC.L["Smite DPS (41-51)"],
    ["Leveling_Smite_52_59"] = MSC.L["Smite DPS (52-59)"],
    ["Leveling_Smite_60_70"] = MSC.L["Smite DPS (Outland)"],
    
    ["Leveling_Healer_52_59"] = MSC.L["Dungeon Healer (52-59)"],
    ["Leveling_Healer_60_70"] = MSC.L["Dungeon Healer (Outland)"],
}

Priest.SpeedChecks = { ["Default"]={} }

Priest.ValidWeapons = {
    [4]=true,             -- 1H Maces
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

Priest.StatToCritMatrix = { 
    Agi = { {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 59.2}, {70, 80.0} } 
}

Priest.Talents = { 
    ["POWER_INFUSION"]  = MSC.L["Power Infusion"], 
    ["PAIN_SUPP"]       = MSC.L["Pain Suppression"], 
    ["SPIRIT_GUIDANCE"] = MSC.L["Spiritual Guidance"], 
    ["CIRCLE_HEALING"]  = MSC.L["Circle of Healing"], 
    ["SEARING_LIGHT"]   = MSC.L["Searing Light"], 
    ["SPIRIT_OF_REDEMPTION"]= MSC.L["Spirit of Redemption"], 
    ["SHADOWFORM"]      = MSC.L["Shadowform"], 
    ["VAMPIRIC_TOUCH"]  = MSC.L["Vampiric Touch"],
    ["ENLIGHTENMENT"]   = MSC.L["Enlightenment"],
    ["SHADOW_FOCUS"]    = MSC.L["Shadow Focus"],
    ["SPIRIT_TAP"]      = MSC.L["Spirit Tap"],
    ["MEDITATION"]      = MSC.L["Meditation"],
}

-- =============================================================
-- LOGIC
-- =============================================================
function Priest:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level == 70 then
        if Rank("VAMPIRIC_TOUCH") > 0 or Rank("SHADOWFORM") > 0 then return "SHADOW_PVE" end
        if Rank("CIRCLE_HEALING") > 0 or Rank("SPIRIT_OF_REDEMPTION") > 0 then return "HOLY_DEEP" end
        if Rank("SEARING_LIGHT") > 0 then return "SMITE_DPS" end
        if Rank("PAIN_SUPP") > 0 or Rank("POWER_INFUSION") > 0 then return "DISC_SUPPORT" end
        return "HOLY_DEEP"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("SEARING_LIGHT") > 0 then role = "Leveling_Smite"
    elseif Rank("CIRCLE_HEALING") > 0 or Rank("SPIRIT_OF_REDEMPTION") > 0 then role = "Leveling_Healer"
    end 

    local specificKey = role .. suffix
    if Priest.LevelingBrackets and Priest.LevelingBrackets[specificKey] then return specificKey end
    if Priest.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Priest:GetDynamicWeights(forceKey)
    -- [[ FIX 1: TRANSLATOR ]]
    -- If the dropdown sends a "Pretty Name" (e.g. "Standard Leveling..."), 
    -- we reverse-lookup the "Code Key" (e.g. "Leveling_2H...").
    if forceKey and not Priest.LevelingBrackets[forceKey] and not Priest.Weights[forceKey] then
        if Priest.PrettyNames then
            for key, name in pairs(Priest.PrettyNames) do
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
    if Priest.LevelingBrackets and Priest.LevelingBrackets[specKey] then
        local bracket = Priest.LevelingBrackets[specKey]
        
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
    if Priest.Weights and Priest.Weights[specKey] then 
        return Priest.Weights[specKey], specKey
    elseif Priest.LevelingWeights and Priest.LevelingWeights[specKey] then 
        return Priest.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Priest:ApplyScalers(weights, currentSpec)
    -- [[ SAFETY COPY ]]
    local w = {}
    for k, v in pairs(weights) do w[k] = v end

    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 0. SMART SPIRIT SCALING ]]
    if w["ITEM_MOD_SPIRIT_SHORT"] then
        -- A. Calculate Base Value (Regen)
        local level = UnitLevel("player")
        local mp5Value = MSC:GetSpiritValueInMP5(level, 1)
        
        -- Meditation: 15/30/45% spirit regen while casting
        local rMed = Rank("MEDITATION")
        local combatMult = (rMed > 0) and (rMed * 0.15) or 0.0
        
        local mp5Weight = w["ITEM_MOD_MANA_REGENERATION_SHORT"] or 2.5
        local baseSpiritWeight = mp5Value * mp5Weight * combatMult
        
        w["ITEM_MOD_SPIRIT_SHORT"] = baseSpiritWeight

        -- [[ B. SPIRIT TAP TURBO-CHARGER ]]
        -- If user has Spirit Tap (Talent), Spirit is worth double 50% of the time while leveling.
        -- We apply a 1.5x multiplier to the Spirit weight to reflect this massive uptime value.
        local rTap = Rank("SPIRIT_TAP") 
        if rTap and rTap > 0 and (currentSpec:find("Leveling") or currentSpec:find("Smite")) then
            w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * 1.5
        end
    end
    
    -- [[ 1. EXISTING TALENT SCALING ]]
    local rEnlight = Rank("ENLIGHTENMENT")
    if rEnlight > 0 then
        local mult = 1 + (rEnlight * 0.01)
        if w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * mult end
        if w["ITEM_MOD_SPIRIT_SHORT"] then w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * mult end
        if w["ITEM_MOD_STAMINA_SHORT"] then w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * mult end
    end

    local rSpiritGuide = Rank("SPIRIT_GUIDANCE")
    if rSpiritGuide > 0 and w["ITEM_MOD_SPIRIT_SHORT"] then
        local bonus = rSpiritGuide * 0.05
        -- Spirit now gives damage and healing too: worth what a point of Spell Power
        -- scores (its damage weight plus its healing at the Healing weight).
        local spValue = (w["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + (w["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0)
        if spValue <= 0 then spValue = 1.0 end
        w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] + (bonus * spValue)
    end
    
    -- ... (Rest of function remains the same: Covariance, Hit Cap, etc.)
    
    -- [[ 2. COVARIANCE ]]
    if currentSpec:find("SHADOW") or currentSpec:find("SMITE") then
        if w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] or w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            local spellPower = 0
            if currentSpec:find("SHADOW") then spellPower = MSC.GetJudgingSpellDamage(6) -- Shadow
            else spellPower = MSC.GetJudgingSpellDamage(2) end 
            
            if spellPower > 700 then
                 local spScaler = 1 + ((spellPower - 700) / 10000)
                 if spScaler > 1.2 then spScaler = 1.2 end 
                 
                 if w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
                     w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * spScaler
                 end
                 if w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
                     w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * spScaler
                 end
            end
        end
    end
    
    -- [[ 3. HIT CAP ]]
    if MSC.BuffEngine and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local talentBonusPct = 0
        if currentSpec:find("SHADOW") then talentBonusPct = Rank("SHADOW_FOCUS") * 2 end
        MSC.BuffEngine:ApplySpellHitCap(w, activeCaps, currentSpec, talentBonusPct, { hardVal = 0.02 })
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return w, capText
end

function Priest:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- REGISTER PROFILES
-- =============================================================
Priest.Profiles = {}
for k, v in pairs(Priest.Weights) do Priest.Profiles[k] = v end
if Priest.LevelingBrackets then
    for k, v in pairs(Priest.LevelingBrackets) do
        local prof = {}
        for stat, w in pairs(v.End or {}) do prof[stat] = w end
        for stat, w in pairs(v) do
            if type(w) == "number" and stat ~= "min" and stat ~= "max" and prof[stat] == nil then prof[stat] = w end
        end
        Priest.Profiles[k] = prof
    end
end
if Priest.LevelingWeights then
    for k, v in pairs(Priest.LevelingWeights) do Priest.Profiles[k] = v end
end

MSC.RegisterModule("PRIEST", Priest)

