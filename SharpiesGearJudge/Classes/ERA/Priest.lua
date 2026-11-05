local addonName, MSC = ...
local Priest = {}
Priest.Name = "PRIEST"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla)
-- =============================================================
Priest.Weights = {
    ["Default"] = {
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5 
    },
    ["HOLY_DEEP"] = {
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 
    },
    ["DISC_PI_SUPPORT"] = {
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=0.6 
    },
    ["SHADOW_PVE"] = {
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
    },
    ["SHADOW_PVP"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 
    },
    ["HYBRID_POWER_WEAVING"] = {
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 
    },
}

-- =============================================================
-- LEVELING WEIGHTS (Spirit is King)
-- =============================================================
Priest.LevelingWeights = {
    -- Shadow/Wand
    ["Leveling_1_20"]  = { ["MSC_WEAPON_DPS_MELEE"]=0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
    ["Leveling_21_40"] = { ["MSC_WEAPON_DPS_MELEE"]=0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.6 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    
    -- Healer
["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, 
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2, -- damage only (Smite): its healing is added at the Healing weight
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.8 
    },
	
    -- Smite
    ["Leveling_Smite_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=5.0 },
    ["Leveling_Smite_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
    ["Leveling_Smite_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Priest.PrettyNames = {
    ["HOLY_DEEP"]          = "Healer: Deep Holy",
    ["DISC_PI_SUPPORT"]    = "Healer: Disc (Power Infusion)",
    ["SHADOW_PVE"]         = "DPS: Shadow (PvE)",
    ["SHADOW_PVP"]         = "PvP: Shadow (Blackout)",
    ["HYBRID_POWER_WEAVING"] = "Support: Power Weaving",
    
    ["Leveling_1_20"]       = "Leveling (1-20)",
    ["Leveling_21_40"]      = "Leveling: Shadow/Wand (21-40)",
    ["Leveling_41_51"]      = "Leveling: Shadow (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Shadow (52-59)",
    
    ["Leveling_Smite_21_40"] = "Leveling: Smite/Holy (21-40)",
    ["Leveling_Smite_41_51"] = "Leveling: Smite/Holy (41-51)",
    ["Leveling_Smite_52_59"] = "Leveling: Smite/Holy (52-59)",
    
    ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Healer (52-59)",
}

-- =============================================================
-- ERA TALENTS
-- =============================================================
Priest.Talents = { 
    ["SHADOWFORM"]      = MSC.L["Shadowform"],
    ["POWER_INFUSION"]  = MSC.L["Power Infusion"],
    ["SPIRIT_GUIDANCE"] = MSC.L["Spiritual Guidance"],
    ["SHADOW_WEAVING"]  = MSC.L["Shadow Weaving"],
    ["BLACKOUT"]        = MSC.L["Blackout"],
    ["WAND_SPEC"]       = MSC.L["Wand Specialization"],
    ["SPIRIT_TAP"]      = MSC.L["Spirit Tap"],
    ["MENTAL_STRENGTH"] = MSC.L["Mental Strength"],
    ["DIVINE_FURY"]     = MSC.L["Divine Fury"],
    ["SHADOW_FOCUS"]    = MSC.L["Shadow Focus"],
}

-- =============================================================
-- LOGIC
-- =============================================================
Priest.ValidWeapons = {
    [4]=true,             -- 1H Maces
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

function Priest:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        -- Find Level Range Suffix
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end

        -- Determine Role
        local role = "Leveling" -- Default Shadow/Wand
        if Rank("SHADOWFORM") == 0 and Rank("DIVINE_FURY") > 0 then 
            role = "Leveling_Smite" -- Smite
        elseif Rank("SPIRIT_GUIDANCE") > 0 then
            role = "Leveling_Healer" -- Holy
        end
        
        -- Build Key
        local key = role .. suffix
        
        -- Fallback: If Smite/Healer key doesn't exist for this level, revert to default
        if Priest.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("SHADOWFORM") > 0 and Rank("SHADOW_WEAVING") > 0 then return "SHADOW_PVE" end
    if Rank("SHADOWFORM") > 0 and Rank("BLACKOUT") > 0 then return "SHADOW_PVP" end
    if Rank("POWER_INFUSION") > 0 and Rank("SHADOW_WEAVING") > 0 then return "HYBRID_POWER_WEAVING" end
    if Rank("POWER_INFUSION") > 0 then return "DISC_PI_SUPPORT" end
    if Rank("SPIRIT_GUIDANCE") > 0 then return "HOLY_DEEP" end
    return "HOLY_DEEP"
end

function Priest:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Spiritual Guidance (Spirit -> Spell Power) ]]
    local rSG = Rank("SPIRIT_GUIDANCE")
    if rSG > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        -- Damage and healing: worth what a point of Spell Power scores (its damage
        -- weight plus its healing at the Healing weight).
        local spWeight = (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0) + (weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or 0)
        if spWeight <= 0 then spWeight = 1.0 end
        -- Add SP value to Spirit (0.05 per rank)
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] + (spWeight * (rSG * 0.05))
    end
    
    -- [[ 2. Covariance (Mana Regen / Healing Power Synergy) ]]
    if currentSpec:find("HOLY") or currentSpec:find("DISC") then
        -- FIX: Use GetPlayerStat via Shim (This usually returns bonus healing)
        local healPower = MSC.GetJudgingStats().heal -- unbuffed, plus assumed buffs
        
        if healPower > 600 then
            local hScaler = 1 + ((healPower - 600) / 6000)
            weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * hScaler
        end
    end

    -- [[ 3. Shadow Hit Cap (16%) ]]
    if currentSpec:find("SHADOW") and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        -- FIX: Use GetPlayerStat via Shim (Returns Percent in Era)
        local gearHit = MSC:GetPlayerStat("SPELL_HIT") 
        local talentHit = Rank("SHADOW_FOCUS") * 2 -- 2% per rank in Era
        local totalHit = gearHit + talentHit
        
        if totalHit >= 16 then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0 -- Cap reached
            table.insert(activeCaps, "Hit (16%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Priest:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- REGISTER
-- =============================================================
Priest.Profiles = {}
for k, v in pairs(Priest.Weights) do Priest.Profiles[k] = v end
for k, v in pairs(Priest.LevelingWeights) do Priest.Profiles[k] = v end

MSC.RegisterModule("PRIEST", Priest)

