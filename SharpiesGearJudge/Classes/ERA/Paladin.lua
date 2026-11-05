local addonName, MSC = ...
local Paladin = {}
Paladin.Name = "PALADIN"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Paladin.Weights = {
    ["Default"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=10,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 
    },
    -- Spell Power is the damage value only: "damage and healing" gear also heals, and the
    -- scorer adds that at the Healing weight (0.8 here counted it almost twice).
    ["HOLY_RAID"] = {
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=14.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0, ["ITEM_MOD_STAMINA_SHORT"]=0.2 
    },
    ["HOLY_DEEP"] = {
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=4.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 
    },
    ["PROT_DEEP"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.09,
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.6, ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, ["ITEM_MOD_PARRY_RATING_SHORT"]=1.5 
    },
    ["PROT_AOE"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.072,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.4, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5 
    },
    ["RET_STANDARD"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=10,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.3, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_HIT_RATING_SHORT"]=22.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2 
    },
    -- Ret with Blessing of Kings (GetSpec: Repentance + Kings). The build's extra value is
    -- the raid buff, not a different gear need: it fights as a Ret Paladin, so it uses
    -- RET_STANDARD's weights (copied below the table).
    ["RET_UTILITY"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=10,},
    ["SHOCKADIN"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.5 
    },
    ["RECK_BOMB"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 
    },
}
for stat, w in pairs(Paladin.Weights["RET_STANDARD"]) do Paladin.Weights["RET_UTILITY"][stat] = w end

-- =============================================================
-- LEVELING LOGIC
-- =============================================================
Paladin.LevelingWeights = {
    ["Leveling_1_20"]  = { ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.5 },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=6.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.3, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.4 },
    ["Leveling_Ret_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
    
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Paladin.PrettyNames = {
    ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
    ["HOLY_DEEP"]       = "Healer: Deep Holy (Buffs)",
    ["PROT_DEEP"]       = "Tank: Deep Protection",
    ["PROT_AOE"]        = "Farming: Protection AoE",
    ["RET_STANDARD"]    = "DPS: Retribution",
    ["SHOCKADIN"]       = "PvP: Shockadin (Burst)",
    ["RECK_BOMB"]       = "PvP: Reck-Bomb (One-Shot)",
    ["RET_UTILITY"]     = "Raid: Ret Utility (Nightfall)",
    
    ["Leveling_1_20"]       = "Leveling (1-20)",
    ["Leveling_21_40"]      = "Leveling: Retribution (21-40)",
    ["Leveling_41_51"]      = "Leveling: Retribution (41-51)",
    ["Leveling_Ret_52_59"]  = "Leveling: Pre-BiS Ret (52-59)",
    ["Leveling_Tank_52_59"] = "Leveling: Pre-BiS Prot (52-59)",
    ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Holy (52-59)",
}

-- =============================================================
-- ERA TALENTS
-- =============================================================
Paladin.Talents = {
    ["HOLY_SHOCK"]      = MSC.L["Holy Shock"],
    ["ILLUMINATION"]    = MSC.L["Illumination"],
    ["HOLY_SHIELD"]     = MSC.L["Holy Shield"],
    ["RECKONING"]       = MSC.L["Reckoning"],
    ["KINGS"]           = MSC.L["Blessing of Kings"],
    ["REPENTANCE"]      = MSC.L["Repentance"],
    ["VENGEANCE"]       = MSC.L["Vengeance"],
    ["IMP_MIGHT"]       = MSC.L["Improved Blessing of Might"],
    ["DIVINE_STR"]      = MSC.L["Divine Strength"],
    ["DIVINE_INT"]      = MSC.L["Divine Intellect"],
    ["PRECISION"]       = MSC.L["Precision"],
    ["REDOUBT"]         = MSC.L["Redoubt"], 
}

-- =============================================================
-- LOGIC
-- =============================================================
Paladin.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [4]=true, [5]=true,   -- 1H/2H Maces
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true              -- Polearms
}

function Paladin:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Check First
    if level < 60 then
        if level <= 20 then return "Leveling_1_20" end
        if level <= 40 then return "Leveling_21_40" end
        if level <= 51 then return "Leveling_41_51" end
        return "Leveling_Ret_52_59"
    end

    -- Endgame Spec Detection
    if Rank("RECKONING") > 0 and Rank("VENGEANCE") > 0 then return "RECK_BOMB" end
    if Rank("REPENTANCE") > 0 and Rank("KINGS") > 0 then return "RET_UTILITY" end
    if Rank("REPENTANCE") > 0 then return "RET_STANDARD" end
    if Rank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
    if Rank("HOLY_SHOCK") > 0 and Rank("KINGS") == 0 then return "SHOCKADIN" end
    if Rank("ILLUMINATION") > 0 and Rank("KINGS") > 0 then return "HOLY_RAID" end
    if Rank("ILLUMINATION") > 0 and Rank("IMP_MIGHT") > 0 then return "HOLY_DEEP" end
    return "HOLY_RAID"
end

function Paladin:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Divine Strength (+10% Str) ]]
    local rStr = Rank("DIVINE_STR")
    if rStr > 0 and weights["ITEM_MOD_STRENGTH_SHORT"] then 
        weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
    end

    -- [[ 2. Hit Cap (9%) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim
        local currentHit = MSC:GetPlayerStat("HIT") 
        if currentHit >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 -- Drop value but keep relevant for PvP
            table.insert(activeCaps, "Hit (9%)")
        end
    end
    
    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Paladin:GetWeaponBonus(itemLink, weights, slotId, specName)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local race = MSC.CtxRace()

    -- Racial: Human (Sword/Mace)
    if race == "Human" and (subClassID == 7 or subClassID == 4 or subClassID == 8 or subClassID == 5) then 
        bonus = bonus + MSC.EraWeaponSkillBonus(Paladin, weights, specName, 5)
    end
    -- Racial: Orc (No benefit for Paladins, but kept for symmetry/safety)
    
    return bonus
end

-- =============================================================
-- ERA RELIC MAPPING
-- =============================================================
Paladin.Relics = {
    [22399] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 53 }, -- Libram of Divinity (Flash of Light)
    [23006] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 80 }, -- Libram of Hope (Holy Light)
    [23203] = { ITEM_MOD_ATTACK_POWER_SHORT = 40 },  -- Libram of Fervor
    [23201] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 45, estimate = true }, -- Libram of Divinity Base
    [22396] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 45, estimate = true }, -- Libram of Truth
    [22402] = { ITEM_MOD_MANA_REGENERATION_SHORT = 8, estimate = true }, -- Libram of Hope Base
}

-- Register Profiles for UI
Paladin.Profiles = {}
for k, v in pairs(Paladin.Weights) do Paladin.Profiles[k] = v end
for k, v in pairs(Paladin.LevelingWeights) do Paladin.Profiles[k] = v end

MSC.RegisterModule("PALADIN", Paladin)
