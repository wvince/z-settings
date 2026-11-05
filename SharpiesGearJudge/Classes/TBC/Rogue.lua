local addonName, MSC = ...
local Rogue = {}
Rogue.Name = "ROGUE"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Rogue.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,
        ["MSC_WEAPON_DPS"]=3.0 
    },

    -- [[ 1. COMBAT (Swords/Maces/Fists) - The PvE King ]]
    ["RAID_COMBAT"] = { 
        ["MSC_WEAPON_DPS"]                  = 6.5, -- Massive weight for Main Hand
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, -- Yellow Cap is priority #1
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.1, -- Dodge reduction is massive DPS gain
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.4, -- DST / Haste Pot meta
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.35,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.1, 
        
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.02,
    },

    -- [[ 2. MUTILATE (Daggers) ]]
    ["RAID_MUTILATE"] = { 
        ["MSC_WEAPON_DPS"]                  = 5.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.6, -- Seal Fate relies on Crit
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.1, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.7, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.8, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.0,
        
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },

    -- [[ 3. SUBTLETY (PvP / Hemo) ]]
    ["PVP_SUBTLETY"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1, 
        ["MSC_WEAPON_DPS"]                  = 3.0, -- Lower priority in PvP than stats
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.8, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.4, -- Sinister Calling = Agi King
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.5, -- Only need 5% cap
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.3, 
        
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },
}

-- Safety Init
Rogue.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (The Interpolation System)
-- =============================================================
Rogue.LevelingBrackets = {
    -- [[ 1. STANDARD COMBAT (Swords/Maces/Fists) ]]
    -- Meta: Slow MH (Sinister Strike) / Fast OH (Poisons/Combat Potency)
    ["Leveling_1_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 1.0, -- Prefer Slow MH early for big SS hits
            ["ITEM_MOD_AGILITY_SHORT"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2, -- 1 Str = 1 AP in TBC (Good value)
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 0.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.2, -- Added for Sync
			["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5 -- Early game dodge reduction
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.2, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.4,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5,
			["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5 -- Early game dodge reduction
        }
    },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 1.5,
            ["ITEM_MOD_AGILITY_SHORT"] = 2.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.4, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["MSC_OH_WEAPON_SPEED"] = -1.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, -- Added for Sync
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1, -- Added for Sync
			["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5 -- Early game dodge reduction
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.0, 
            ["MSC_OH_WEAPON_SPEED"] = -2.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.1,
			["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5 -- Early game dodge reduction
        }
    },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, -- Combat Potency Era (Fast OH is mandatory)
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.0, 
            ["MSC_OH_WEAPON_SPEED"] = -2.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, -- Added for Sync
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5 -- Added TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["MSC_OH_WEAPON_SPEED"] = -2.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.6,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["MSC_OH_WEAPON_SPEED"] = -2.5, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.6, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["MSC_OH_WEAPON_SPEED"] = -3.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.8,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2
        }
    },
    ["Leveling_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["MSC_OH_WEAPON_SPEED"] = -3.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.8, -- Added for Sync
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 0.5, -- TBC Stat
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.5 -- TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 18.0, -- Weapon DPS is king for SS
            ["MSC_WEAPON_SPEED"] = 4.0, 
            ["MSC_OH_WEAPON_SPEED"] = -4.0, -- negative = prefer fast (scored as |w| x (4.0 - speed))
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.5, -- Combat loves Hit past cap (White dmg)
            ["ITEM_MOD_AGILITY_SHORT"] = 3.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.5
        }
    },

    -- [[ 2. DAGGERS (Assassination) ]]
    -- Speed doesn't matter (Daggers are always fast). Focus on Crit/Dagger Skill.
    ["Leveling_Dagger_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.4, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, -- 1 Str = 1 AP
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_Dagger_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.8, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2
        }
    },
    ["Leveling_Dagger_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2
        }
    },
    ["Leveling_Dagger_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.2, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0, -- Added for Sync
            ["ITEM_MOD_STAMINA_SHORT"] = 1.2, -- Added for Sync
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0 -- Added TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 18.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 2.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0
        }
    },

    -- [[ 3. HEMO (Subtlety) ]]
    -- Slow MH (Hemo hits harder). OH Speed less important than Combat, but Fast usually better for poisons.
    ["Leveling_Hemo_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"] = 10.0, 
            ["MSC_WEAPON_SPEED"] = 1.5, -- Hemo likes Slow
            ["ITEM_MOD_AGILITY_SHORT"] = 2.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.5, -- Added for Sync
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2
        }
    },
    ["Leveling_Hemo_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"] = 12.0, 
            ["MSC_WEAPON_SPEED"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2, -- Added for Sync
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0
        }
    },
    ["Leveling_Hemo_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"] = 14.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2 -- Added for Sync
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2
        }
    },
    ["Leveling_Hemo_60_70"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"] = 15.0, 
            ["MSC_WEAPON_SPEED"] = 2.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.8,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.2, -- Added for Sync
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0, -- TBC Stat
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 0.5 -- TBC Stat
        },
        End = { 
            ["MSC_WEAPON_DPS"] = 18.0, 
            ["MSC_WEAPON_SPEED"] = 3.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 3.5, 
            ["ITEM_MOD_STAMINA_SHORT"] = 2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.5,
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 1.0
        }
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Rogue.Specs = { [1]="Assassination", [2]="Combat", [3]="Subtlety" }

Rogue.PrettyNames = {
    ["RAID_COMBAT"]     = MSC.L["Raid: Combat (Swords/Maces)"],
    ["RAID_MUTILATE"]   = MSC.L["Raid: Mutilate (Daggers)"],
    ["PVP_SUBTLETY"]    = MSC.L["PvP: Shadowstep / Hemo"],
    
    -- Leveling Brackets
    ["Leveling_1_20"]  = MSC.L["Starter (1-20)"],
    ["Leveling_21_40"] = MSC.L["Standard Leveling (21-40)"],
    ["Leveling_41_51"] = MSC.L["Standard Leveling (41-51)"],
    ["Leveling_52_59"] = MSC.L["Standard Leveling (52-59)"],
    ["Leveling_60_70"] = MSC.L["Standard Leveling (Outland)"],
    
    ["Leveling_Dagger_1_20"]  = MSC.L["Dagger/Ambush (1-20)"],
    ["Leveling_Dagger_21_40"] = MSC.L["Dagger/Ambush (21-40)"],
    ["Leveling_Dagger_41_51"] = MSC.L["Dagger/Ambush (41-51)"],
    ["Leveling_Dagger_52_59"] = MSC.L["Dagger/Ambush (52-59)"],
    ["Leveling_Dagger_60_70"] = MSC.L["Dagger/Ambush (Outland)"],              
    
    ["Leveling_Hemo_1_20"]    = MSC.L["Hemorrhage (1-20)"],
    ["Leveling_Hemo_21_40"]   = MSC.L["Hemorrhage (21-40)"],
    ["Leveling_Hemo_41_51"]   = MSC.L["Hemorrhage (41-51)"],
    ["Leveling_Hemo_52_59"]   = MSC.L["Hemorrhage (52-59)"],
    ["Leveling_Hemo_60_70"]   = MSC.L["Hemorrhage (Outland)"],
}

Rogue.SpeedChecks = { 
    ["Default"]={ MH_Slow=true, OH_Fast=true } 
}

Rogue.ValidWeapons = {
    [4]=true,             -- 1H Maces
    [7]=true,             -- 1H Swords
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
}

Rogue.StatToCritMatrix = { 
    Agi = { {1, 3.5}, {60, 29.0}, {70, 40.0} } 
}

Rogue.Talents = { 
    ["PRECISION"]       = MSC.L["Precision"],
    ["MUTILATE"]        = MSC.L["Mutilate"], 
    ["ADRENALINE_RUSH"] = MSC.L["Adrenaline Rush"], 
    ["SURPRISE_ATTACK"] = MSC.L["Surprise Attack"], 
    ["COMBAT_POTENCY"]  = MSC.L["Combat Potency"], 
    ["HEMORRHAGE"]      = MSC.L["Hemorrhage"], 
    ["SHADOWSTEP"]      = MSC.L["Shadowstep"], 
    ["CHEAT_DEATH"]     = MSC.L["Cheat Death"], 
    ["VITALITY"]        = MSC.L["Vitality"], 
    ["SINISTER_CALLING"]= MSC.L["Sinister Calling"],
    ["DAGGER_SPEC"]     = MSC.L["Dagger Specialization"],
    ["FIST_SPEC"]       = MSC.L["Fist Weapon Specialization"],
    ["SWORD_SPEC"]      = MSC.L["Sword Specialization"],
    ["MACE_SPEC"]       = MSC.L["Mace Specialization"],
    ["WEAPON_EXPERTISE"]= MSC.L["Weapon Expertise"],
    ["DUAL_WIELD_SPEC"] = MSC.L["Dual Wield Specialization"]    
}

-- =============================================================
-- LOGIC
-- =============================================================
function Rogue:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level == 70 then
        if Rank("SHADOWSTEP") > 0 or Rank("CHEAT_DEATH") > 0 then return "PVP_SUBTLETY" end
        if Rank("HEMORRHAGE") > 0 and Rank("ADRENALINE_RUSH") == 0 then return "PVP_SUBTLETY" end
        if Rank("MUTILATE") > 0 then return "RAID_MUTILATE" end
        if Rank("ADRENALINE_RUSH") > 0 or Rank("COMBAT_POTENCY") > 0 then return "RAID_COMBAT" end
        return "RAID_COMBAT"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("MUTILATE") > 0 then role = "Leveling_Dagger"
    elseif Rank("HEMORRHAGE") > 0 then role = "Leveling_Hemo"
    end

    local specificKey = role .. suffix
    
    -- [[ BRACKET CHECK ]]
    if Rogue.LevelingBrackets and Rogue.LevelingBrackets[specificKey] then return specificKey end
    
    -- [[ FALLBACK TO STATIC ]]
    if Rogue.LevelingWeights and Rogue.LevelingWeights[specificKey] then return specificKey end
    
    return "Leveling" .. suffix
end

function Rogue:GetDynamicWeights(forceKey)
    -- [[ FIX 1: TRANSLATOR ]]
    -- If the dropdown sends a "Pretty Name" (e.g. "Standard Leveling..."), 
    -- we reverse-lookup the "Code Key" (e.g. "Leveling_2H...").
    if forceKey and not Rogue.LevelingBrackets[forceKey] and not Rogue.Weights[forceKey] then
        if Rogue.PrettyNames then
            for key, name in pairs(Rogue.PrettyNames) do
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
    if Rogue.LevelingBrackets and Rogue.LevelingBrackets[specKey] then
        local bracket = Rogue.LevelingBrackets[specKey]
        
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
    if Rogue.Weights and Rogue.Weights[specKey] then 
        return Rogue.Weights[specKey], specKey
    elseif Rogue.LevelingWeights and Rogue.LevelingWeights[specKey] then 
        return Rogue.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Rogue:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- [[ 1. DUAL WIELD SCALING ]]
    if currentSpec:find("COMBAT") or currentSpec:find("Default") or currentSpec:find("Leveling") then
        -- Default OH penalty is 0.5. Talent adds 10-50%.
        -- 5/5 DW Spec = 50% * 1.5 = 75% Damage.
        local dwTalent = Rank("DUAL_WIELD_SPEC") or 0 -- Need to add DUAL_WIELD_SPEC to Rogue.Talents
        local ohMult = 0.5 + (dwTalent * 0.05) -- 0.5 to 0.75
        weights["MSC_WEAPON_DPS_OH"] = ohMult

        -- [[ 2. AUTO-SPEED LOGIC ]]
        -- Slow MH is wanted, fast OH for poisons: a negative OH Speed weight means
        -- "prefer fast" (GetItemScore scores it as |w| x (4.0 - speed)).
        if not weights["MSC_OH_WEAPON_SPEED"] and weights["MSC_WEAPON_SPEED"] and weights["MSC_WEAPON_SPEED"] > 0 then
             weights["MSC_OH_WEAPON_SPEED"] = -1 * weights["MSC_WEAPON_SPEED"]
        end
    end

    -- [[ 0. ARPEN SCALING ]]
    if weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] then
        local arPen = MSC.SanitizeStat(GetCombatRating(25)) or 0
        if arPen > 100 then
            local scaler = 1 + (arPen / 1000)
            if scaler > 1.4 then scaler = 1.4 end
            weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] * scaler
        end
    end
    
    -- [[ 1. TALENT SCALERS ]]
    local rVit = Rank("VITALITY")
    if rVit > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then 
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rVit * 0.01)) 
    end
    
    local rSin = Rank("SINISTER_CALLING")
    if rSin > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then 
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rSin * 0.03)) 
    end

    -- [[ 2. COVARIANCE (Crit scales with AP) ]]
    if weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        local totalAP = MSC.GetJudgingStats().ap -- unbuffed, plus assumed buffs
        
        if totalAP > 1000 then
            local apScaler = 1 + ((totalAP - 1000) / 20000)
            if apScaler > 1.15 then apScaler = 1.15 end
            weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * apScaler
        end
    end

    -- [[ 3. HIT CAP (With Hysteresis) ]]
    if MSC.BuffEngine and weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local isCombat = currentSpec:find("COMBAT") or currentSpec:find("Default") or currentSpec:find("Leveling")
        MSC.BuffEngine:ApplyMeleeHitCap(weights, activeCaps, currentSpec, Rank("PRECISION") * 1, 6, {
            hardVal = isCombat and 1.0 or 0.5,
            softMult = 0.8,
            hardLabel = isCombat and MSC.L["Yellow Hit"] or MSC.L["Hit"],
        })
    end
    
    -- [[ 4. EXPERTISE CAP ]]
    if weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] and weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] > 0.1 then
        local expRating = MSC.SanitizeStat(GetCombatRating(24))
        local level = UnitLevel("player")
        if level > 70 then level = 70 end
        local expScalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level] and MSC.CombatRatingScalars[level][1]) or 3.94
        
        local _, race = UnitRace("player")
        local humanBonus = 0
        if race == "Human" then
             local itemLink = GetInventoryItemLink("player", 16)
             if itemLink then
                 local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
                 if classID == 2 and (subClassID == 7 or subClassID == 4) then -- Sword/Mace
                     humanBonus = 5 -- 5 Expertise Skill
                 end
             end
        end
        
        local talentBonus = Rank("WEAPON_EXPERTISE") * 5 -- 5 Expertise Skill per rank
        local totalExpSkill = (expRating / expScalar) + humanBonus + talentBonus
        
        -- Cap is 6.5% Dodge (which requires 26 Expertise Skill)
        if totalExpSkill >= 28 then -- Safety buffer
			weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5
			table.insert(activeCaps, MSC.L["Exp"])
		elseif totalExpSkill >= 26 then
			weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] * 0.8
			table.insert(activeCaps, MSC.L["Exp (Soft)"])
		end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Rogue:GetWeaponBonus(itemLink, weights)
    if not itemLink or not weights then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local race = MSC.CtxRace()
    local level = MSC.CtxLevel()
    if level > 70 then level = 70 end
    
    -- Dynamically calculate how much score 1% Crit is worth right now
    local critScalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level] and MSC.CombatRatingScalars[level][9]) or 22.1
    local critScoreValue = critScalar * (weights["ITEM_MOD_CRIT_RATING_SHORT"] or 1.0)

    -- Racial: Troll (Bow/Thrown) / Dwarf (Gun) give +1% Crit
    if race == "Troll" and (subClassID == 2 or subClassID == 16) then bonus = bonus + critScoreValue end
    if race == "Dwarf" and subClassID == 3 then bonus = bonus + critScoreValue end

    -- Human Racial and Weapon Spec Talents give Extra Swings or flat damage, we can keep these as fixed high-value numbers or scale them to AP
    local apScoreValue = (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 1.0)
    
    if race == "Human" and (subClassID == 7 or subClassID == 4) then bonus = bonus + (40 * apScoreValue) end

    local function Rank(k) return MSC:GetTalentRank(k) end
    if subClassID == 15 and Rank("DAGGER_SPEC") > 0 then bonus = bonus + (Rank("DAGGER_SPEC") * 1.0 * critScoreValue) end -- 1% Crit per rank
    if subClassID == 13 and Rank("FIST_SPEC") > 0 then bonus = bonus + (Rank("FIST_SPEC") * 1.0 * critScoreValue) end -- 1% Crit per rank
    if subClassID == 7 and Rank("SWORD_SPEC") > 0 then bonus = bonus + (Rank("SWORD_SPEC") * 35.0 * apScoreValue) end -- Extra Swing
    if subClassID == 4 and Rank("MACE_SPEC") > 0 then bonus = bonus + (Rank("MACE_SPEC") * 25.0 * apScoreValue) end -- Armor Pen / Stun

    return bonus
end

-- =============================================================
-- REGISTER PROFILES
-- =============================================================
Rogue.Profiles = {}
for k, v in pairs(Rogue.Weights) do Rogue.Profiles[k] = v end
if Rogue.LevelingBrackets then
    for k, v in pairs(Rogue.LevelingBrackets) do
        local prof = {}
        for stat, w in pairs(v.End or {}) do prof[stat] = w end
        for stat, w in pairs(v) do
            if type(w) == "number" and stat ~= "min" and stat ~= "max" and prof[stat] == nil then prof[stat] = w end
        end
        Rogue.Profiles[k] = prof
    end
end
if Rogue.LevelingWeights then
    for k, v in pairs(Rogue.LevelingWeights) do Rogue.Profiles[k] = v end
end

MSC.RegisterModule("ROGUE", Rogue)

