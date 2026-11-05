local addonName, MSC = ...
local Warrior = {}
Warrior.Name = "WARRIOR"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Warrior.Weights = {
    ["Default"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=10,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.3, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 
    },
    ["FURY_2H"] = {
        ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 7.5, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.3, ["ITEM_MOD_CRIT_RATING_SHORT"] = 28.0, ["ITEM_MOD_HIT_RATING_SHORT"] = 12.0, ["ITEM_MOD_STAMINA_SHORT"] = 0.5 
    },
    ["FURY_DW"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=10,
        ["ITEM_MOD_HIT_RATING_SHORT"] = 22.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 18.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 30.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.5, ["ITEM_MOD_STAMINA_SHORT"] = 0.5 
    },
    ["ARMS_MS"] = {
        ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 8.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 28.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.2, ["ITEM_MOD_STAMINA_SHORT"] = 1.5 
    },
    ["DEEP_PROT"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.09,
        ["ITEM_MOD_STAMINA_SHORT"] = 1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 0.6, ["ITEM_MOD_HIT_RATING_SHORT"] = 10.0, ["ITEM_MOD_DODGE_RATING_SHORT"] = 12.0, ["ITEM_MOD_PARRY_RATING_SHORT"] = 12.0, ["ITEM_MOD_STRENGTH_SHORT"] = 0.5 
    },
    ["FURY_PROT"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.06, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=10,
        ["ITEM_MOD_HIT_RATING_SHORT"] = 22.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 20.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_STAMINA_SHORT"] = 1.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.5 
    },
    ["ARMS_PROT"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.06,
        ["ITEM_MOD_STAMINA_SHORT"] = 1.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 20.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8, ["ITEM_MOD_PARRY_RATING_SHORT"] = 10.0 
    },
}

-- =============================================================
-- LEVELING WEIGHTS (The Spirit Meta)
-- =============================================================
Warrior.LevelingWeights = {
    -- Standard Arms/2H Fury
    ["Leveling_1_20"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=7, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=7, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.2 },
    
    -- Dual Wield Fury Leveling
    ["Leveling_DW_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    ["Leveling_DW_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_DW_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },

    -- Tank Leveling
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.1, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=5.0 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=10.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Warrior.PrettyNames = {
    ["FURY_DW"]         = "Raid: Fury (Dual Wield)",
    ["FURY_2H"]         = "Raid: Fury (2H Slam)",
    ["ARMS_MS"]         = "PvP: Arms (Mortal Strike)",
    ["DEEP_PROT"]       = "Tank: Deep Protection",
    ["FURY_PROT"]       = "Tank: Fury-Prot (Threat)",
    ["ARMS_PROT"]       = "Tank: Arms (Dungeon Hybrid)",
    
    ["Leveling_1_20"]       = "Leveling (1-20)",
    ["Leveling_21_40"]      = "Leveling: Arms/Fury (21-40)",
    ["Leveling_41_51"]      = "Leveling: Arms/Fury (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Fury (52-59)",
    
    ["Leveling_DW_21_40"]   = "Leveling: Dual Wield (21-40)",
    ["Leveling_DW_41_51"]   = "Leveling: Dual Wield (41-51)",
    ["Leveling_DW_52_59"]   = "Leveling: Dual Wield (52-59)",
    
    ["Leveling_Tank_21_40"] = "Leveling: Tank (21-40)",
    ["Leveling_Tank_41_51"] = "Leveling: Tank (41-51)",
    ["Leveling_Tank_52_59"] = "Leveling: Tank (52-59)",
}

-- =============================================================
-- ERA TALENTS (Vanilla)
-- =============================================================
Warrior.Talents = { 
    ["MORTAL_STRIKE"]    = MSC.L["Mortal Strike"],
    ["BLOODTHIRST"]      = MSC.L["Bloodthirst"],
    ["SHIELD_SLAM"]      = MSC.L["Shield Slam"],
    ["DEFIANCE"]         = MSC.L["Defiance"],
    ["IMP_SLAM"]         = MSC.L["Improved Slam"],
    ["DW_SPEC"]          = MSC.L["Dual Wield Specialization"],
    ["TACTICAL_MASTERY"] = MSC.L["Tactical Mastery"],
    ["IMPALE"]           = MSC.L["Impale"],
    ["CRUELTY"]          = MSC.L["Cruelty"],
    ["FLURRY"]           = MSC.L["Flurry"],
}

-- =============================================================
-- LOGIC
-- =============================================================
Warrior.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [4]=true, [5]=true,   -- 1H/2H Maces
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true,             -- Polearms
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
}

Warrior.EndgameTabMap = { [1] = "ARMS_MS", [2] = "FURY_DW", [3] = "DEEP_PROT" }

function Warrior:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("SHIELD_SLAM") > 0 then return "DEEP_PROT", "high" end
        if Rank("BLOODTHIRST") > 0 and Rank("DEFIANCE") > 0 then return "FURY_PROT", "high" end
        if Rank("TACTICAL_MASTERY") > 0 and Rank("DEFIANCE") > 0 then return "ARMS_PROT", "high" end
        if Rank("BLOODTHIRST") > 0 and Rank("IMP_SLAM") > 0 then return "FURY_2H", "high" end
        if Rank("BLOODTHIRST") > 0 then return "FURY_DW", "high" end
        if Rank("MORTAL_STRIKE") > 0 then return "ARMS_MS", "high" end
        local fallback, conf = MSC:GetDominantTalentTree(Warrior.EndgameTabMap, 5)
        if fallback then return fallback, conf end
        return "FURY_DW", "ambiguous"
    end

    -- [[ 2. LEVELING SPEC DETECTION ]]
    -- Fix: Match the strings to the LevelingWeights table exactly
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    else suffix = "_52_59" end

    -- Determine Role based on Talents
    local role = "Leveling" -- Default to 2H/Arms style
    if Rank("SHIELD_SLAM") > 0 or Rank("DEFIANCE") > 0 then 
        role = "Leveling_Tank"
    elseif Rank("DW_SPEC") > 0 or Rank("BLOODTHIRST") > 0 then 
        role = "Leveling_DW"
    end

    -- Construct Key (e.g., "Leveling_DW_21_40")
    local specificKey = role .. suffix
    
    -- Check if it exists, otherwise fall back to generic
    if Warrior.LevelingWeights[specificKey] then return specificKey, "high" end
    if Warrior.LevelingWeights["Leveling" .. suffix] then return "Leveling" .. suffix, "high" end
    
    return "Leveling_1_20", "low"
end

function Warrior:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. HIT CAP (Using Shim) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use the shim we built in Helpers.lua
        local currentHit = MSC:GetPlayerStat("HIT") 
        
        -- Detect Racial Skill
        local _, race = UnitRace("player")
        local skillBonus = 0
        if race == "Human" or race == "Orc" then skillBonus = 5 end

        local yellowCap = (skillBonus >= 5) and 6 or 9
        
        if currentHit >= yellowCap then
            -- Hit is still good for DW (White hits), but weight drops for 2H
            local mult = (currentSpec:find("DW")) and 0.5 or 0.1
            weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * mult
            table.insert(activeCaps, "Yellow Hit ("..yellowCap.."%)")
        end
    end

    -- [[ 2. WEAPON SKILL CAP (Soft Cap ~308) ]]
    if weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] then
        -- Note: We can't easily read total weapon skill from API in a lightweight way
        -- So we estimate based on racial.
        local _, race = UnitRace("player")
        local hasRacial = (race == "Human" or race == "Orc")
        
        -- If we already have racial +5, extra skill is worth LESS, but not zero.
        -- Going from 300->305 is huge. 305->308 is okay. 308+ is minor.
        if hasRacial then
            weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] * 0.5
            table.insert(activeCaps, "Skill (Soft Cap)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warrior:GetWeaponBonus(itemLink, weights, slotId, specName)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local race = MSC.CtxRace()

    -- Racial: Human (Sword=7/8, Mace=4/5)
    if race == "Human" and (subClassID == 7 or subClassID == 4 or subClassID == 8 or subClassID == 5) then 
        bonus = bonus + MSC.EraWeaponSkillBonus(Warrior, weights, specName, 5)
    end
    -- Racial: Orc (Axe=0/1)
    if race == "Orc" and (subClassID == 0 or subClassID == 1) then 
        bonus = bonus + MSC.EraWeaponSkillBonus(Warrior, weights, specName, 5)
    end
    
    return bonus
end

-- =============================================================
-- REGISTER
-- =============================================================
Warrior.Profiles = {}
for k, v in pairs(Warrior.Weights) do Warrior.Profiles[k] = v end
for k, v in pairs(Warrior.LevelingWeights) do Warrior.Profiles[k] = v end

MSC.RegisterModule("WARRIOR", Warrior)
