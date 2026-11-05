local addonName, MSC = ...
local Hunter = {}
Hunter.Name = "HUNTER"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Hunter.Weights = {
    ["Default"] = {
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=32.0, ["ITEM_MOD_HIT_RATING_SHORT"]=32.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5 
    },
    ["RAID_MM_STANDARD"] = {
        ["ITEM_MOD_HIT_RATING_SHORT"]=32.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=32.0 
    },
    ["RAID_MM_STARTER"] = {
        ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=32.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
    },
    ["RAID_SURV_DEEP"] = {
        ["ITEM_MOD_AGILITY_SHORT"]=3.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_HIT_RATING_SHORT"]=30.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
    },
    ["PVP_MM_UTIL"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
    },
    ["PVP_SURV_TANK"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
    },
    ["MELEE_NIGHTFALL"] = {
        ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 
    },
    ["SOLO_DME_TRIBUTE"] = {
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Hunter.LevelingWeights = {
    ["Leveling_1_20"]  = { ["ITEM_MOD_ARMOR_SHORT"]= 0.1, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    
    -- Melee Hunter
    ["Leveling_Melee_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_PARRY_RATING_SHORT"]=2.0 },
    ["Leveling_Melee_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5 },
    ["Leveling_Melee_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Hunter.PrettyNames = {
    ["RAID_MM_STANDARD"] = "Raid: Marksmanship (Standard)",
    ["RAID_MM_STARTER"]  = "Raid: MM (Surefooted)",
    ["RAID_SURV_DEEP"]   = "Raid: Deep Survival (Agi)",
    ["PVP_MM_UTIL"]      = "PvP: Marksmanship Utility",
    ["PVP_SURV_TANK"]    = "PvP: Survival Tank",
    ["MELEE_NIGHTFALL"]  = "Support: Nightfall (Melee)",
    ["SOLO_DME_TRIBUTE"] = "Farming: DM North Solo",
    
    ["Leveling_1_20"]       = "Leveling (1-20)",
    ["Leveling_21_40"]      = "Leveling: Beast Mastery (21-40)",
    ["Leveling_41_51"]      = "Leveling: Beast Mastery (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Hunter (52-59)",
    
    ["Leveling_Melee_21_40"] = "Leveling: Melee/Survival (21-40)",
    ["Leveling_Melee_41_51"] = "Leveling: Melee/Survival (41-51)",
    ["Leveling_Melee_52_59"] = "Leveling: Melee/Survival (52-59)",
}

-- =============================================================
-- ERA TALENTS
-- =============================================================
Hunter.Talents = { 
    ["BESTIAL_WRATH"]   = MSC.L["Bestial Wrath"],
    ["UNLEASHED_FURY"]  = MSC.L["Unleashed Fury"],
    ["TRUESHOT_AURA"]   = MSC.L["Trueshot Aura"],
    ["AIMED_SHOT"]      = MSC.L["Aimed Shot"],
    ["WYVERN_STING"]    = MSC.L["Wyvern Sting"],
    ["COUNTERATTACK"]   = MSC.L["Counterattack"],
    ["DETERRENCE"]      = MSC.L["Deterrence"],
    ["SUREFOOTED"]      = MSC.L["Surefooted"],
    ["LIGHTNING_REF"]   = MSC.L["Lightning Reflexes"],
    ["MORTAL_SHOTS"]    = MSC.L["Mortal Shots"],
    ["SURVIVALIST"]     = MSC.L["Survivalist"],
}

-- =============================================================
-- LOGIC
-- =============================================================
Hunter.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true,             -- Polearms
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
}

function Hunter:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        return "Leveling" .. suffix
    end
    
    -- Fallback Talent Tab Scan
    local mmPoints = MSC.GetTabPointsSpent(2)
    
    -- Endgame
    if Rank("COUNTERATTACK") > 0 then return "MELEE_NIGHTFALL" end
    if Rank("TRUESHOT_AURA") > 0 and Rank("UNLEASHED_FURY") > 0 then return "RAID_MM_STANDARD" end
    if Rank("TRUESHOT_AURA") > 0 and Rank("SUREFOOTED") > 0 then return "RAID_MM_STARTER" end
    if Rank("LIGHTNING_REF") == 5 and Rank("WYVERN_STING") > 0 then return "RAID_SURV_DEEP" end
    if Rank("TRUESHOT_AURA") > 0 and Rank("DETERRENCE") > 0 then return "PVP_MM_UTIL" end
    if (Rank("WYVERN_STING") > 0 and Rank("SUREFOOTED") > 0) then return "PVP_SURV_TANK" end
    if mmPoints >= 30 then return "RAID_MM_STANDARD" end
    return "RAID_MM_STANDARD"
end

function Hunter:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Lightning Reflexes (Agi Scaling) ]]
    local rLR = Rank("LIGHTNING_REF")
    if rLR > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then 
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rLR * 0.03)) 
    end
    
    -- [[ 2. Covariance (Crit scales with RAP) ]]
    if weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        local totalRAP = MSC.GetJudgingStats().rap -- unbuffed, plus assumed buffs
        if totalRAP > 1500 then
            local rapScaler = 1 + ((totalRAP - 1500) / 10000)
            if rapScaler > 1.2 then rapScaler = 1.2 end
            weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * rapScaler
        end
    end

    -- [[ 3. Hit Cap (9%) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim. Note: "HIT" generally returns melee/range combined in Vanilla API.
        local currentHit = MSC:GetPlayerStat("HIT")
        -- GetHitModifier already includes hit from talents (and gear), so the talent isn't added again.
        local totalHit = currentHit

        if totalHit >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 -- Cap reached (keep relevant for PvP/higher level mobs)
            table.insert(activeCaps, "Hit (9%)")
        end
    end

    -- [[ 4. Melee Weapon = Stat Stick ]]
    -- Weapon DPS weight is calibrated for the ranged slot. A ranged Hunter
    -- only swings the melee weapon for the odd Raptor Strike / Wing Clip, so
    -- its DPS is worth a fraction of that; its stats still count in full.
    if not (currentSpec or ""):upper():find("MELEE") and (weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] or 0) > 0 then
        weights["MSC_WEAPON_DPS_MELEE"] = weights["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] * 0.15
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Hunter:GetWeaponBonus(itemLink, weights, slotId, specName)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local race = MSC.CtxRace()

    -- Racial: Dwarf (Gun) / Troll (Bow) +5 Skill
    -- In Era, Weapon Skill is very valuable for hit/glancing reduction
    if race == "Dwarf" and subClassID == 3 then bonus = bonus + MSC.EraWeaponSkillBonus(Hunter, weights, specName, 5) end
    if race == "Troll" and subClassID == 2 then bonus = bonus + MSC.EraWeaponSkillBonus(Hunter, weights, specName, 5) end
    
    return bonus
end

MSC.RegisterModule("HUNTER", Hunter)
