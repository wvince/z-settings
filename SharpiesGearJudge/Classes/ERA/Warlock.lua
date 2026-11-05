local addonName, MSC = ...
local Warlock = {}
Warlock.Name = "WARLOCK"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
-- NOTE: In Era Helpers.lua, 1.0 Rating = 1% Hit/Crit. 
-- We use standard keys so the Evaluator can match them.

Warlock.Weights = {
    ["Default"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.1 
    },
    ["RAID_DS_RUIN"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=11.0, ["ITEM_MOD_STAMINA_SHORT"]=0.3, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
    },
    ["RAID_SM_RUIN"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=9.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
    },
    ["PVE_MD_RUIN"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=11.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.3 
    },
    ["PVP_NF_CONFLAG"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 
    },
    ["PVP_SOUL_LINK"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=5.0 
    },
    ["PVP_DEEP_DESTRO"] = {
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Warlock.LevelingWeights = {
    ["Leveling_1_20"]  = { ["MSC_WEAPON_DPS_MELEE"]=0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    ["Leveling_21_40"] = { ["MSC_WEAPON_DPS_MELEE"]=0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0 },
    
    -- Fire
    ["Leveling_Fire_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
    ["Leveling_Fire_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=5.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    ["Leveling_Fire_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0 },
    
    -- Demo
    ["Leveling_Demo_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
    ["Leveling_Demo_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0 },
    ["Leveling_Demo_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=3.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Warlock.PrettyNames = {
    ["RAID_DS_RUIN"]    = "Raid: Destruction (DS/Ruin)",
    ["RAID_SM_RUIN"]    = "Raid: Affliction (SM/Ruin)",
    ["PVE_MD_RUIN"]     = "Raid: Master Demonologist",
    ["PVP_NF_CONFLAG"]  = "PvP: Nightfall / Conflagrate",
    ["PVP_SOUL_LINK"]   = "PvP: Soul Link (Tank)",
    ["PVP_DEEP_DESTRO"] = "PvP: Destruction (Conflag)",
    
    ["Leveling_1_20"]       = "Leveling (1-20)",
    ["Leveling_21_40"]      = "Leveling: Affliction (21-40)",
    ["Leveling_41_51"]      = "Leveling: Affliction (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Affliction (52-59)",
    
    ["Leveling_Fire_21_40"] = "Leveling: Destruction (21-40)",
    ["Leveling_Fire_41_51"] = "Leveling: Destruction (41-51)",
    ["Leveling_Fire_52_59"] = "Leveling: Destruction (52-59)",
    
    ["Leveling_Demo_21_40"] = "Leveling: Demonology (21-40)",
    ["Leveling_Demo_41_51"] = "Leveling: Demonology (41-51)",
    ["Leveling_Demo_52_59"] = "Leveling: Demonology (52-59)",
}

-- =============================================================
-- ERA TALENTS
-- =============================================================
Warlock.Talents = { 
    ["DEMONIC_SACRIFICE"] = MSC.L["Demonic Sacrifice"],
    ["SHADOW_MASTERY"]    = MSC.L["Shadow Mastery"],
    ["RUIN"]              = MSC.L["Ruin"],
    ["SOUL_LINK"]         = MSC.L["Soul Link"],
    ["CONFLAGRATE"]       = MSC.L["Conflagrate"],
    ["FEL_CONCENTRATION"] = MSC.L["Fel Concentration"],
    ["NIGHTFALL"]         = MSC.L["Nightfall"],
    ["INTENSITY"]         = MSC.L["Intensity"],
    ["MASTER_DEMON"]      = MSC.L["Master Demonologist"],
    ["SUPPRESSION"]       = MSC.L["Suppression"],
    ["DEMONIC_EMBRACE"]   = MSC.L["Demonic Embrace"],
    ["EMBERSTORM"]        = MSC.L["Emberstorm"],
}

-- =============================================================
-- LOGIC
-- =============================================================
Warlock.ValidWeapons = {
    [7]=true,             -- 1H Swords
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

function Warlock:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Logic
    if level < 60 then 
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end 

        local prefix = "Leveling" -- Default Affliction
        
        if Rank("CONFLAGRATE") > 0 or Rank("EMBERSTORM") > 0 then 
            prefix = "Leveling_Fire"
        elseif Rank("SOUL_LINK") > 0 or Rank("MASTER_DEMON") > 0 then 
            prefix = "Leveling_Demo"
        end 

        local key = prefix .. suffix
        if Warlock.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame Logic
    if Rank("DEMONIC_SACRIFICE") > 0 and Rank("RUIN") > 0 then return "RAID_DS_RUIN" end
    if Rank("SHADOW_MASTERY") > 0 and Rank("RUIN") > 0 then return "RAID_SM_RUIN" end
    if Rank("MASTER_DEMON") > 0 and Rank("RUIN") > 0 then return "PVE_MD_RUIN" end
    if Rank("SOUL_LINK") > 0 then return "PVP_SOUL_LINK" end
    if Rank("CONFLAGRATE") > 0 then 
        if Rank("NIGHTFALL") > 0 then return "PVP_NF_CONFLAG" end
        return "PVP_DEEP_DESTRO" 
    end
    
    return "Default"
end

function Warlock:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Demonic Embrace (Stamina) ]]
    local rEmb = Rank("DEMONIC_EMBRACE")
    if rEmb > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then 
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03)) 
    end

    -- [[ 2. Hit Cap (16%) ]]
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        -- FIX: Use Shim
        local currentHit = MSC:GetPlayerStat("SPELL_HIT")
        
        -- Suppression helps Affliction spells only: not the Shadow Bolt raid builds
        local suppressionBonus = MSC.SuppressionCounts(currentSpec) and Rank("SUPPRESSION") * 2 or 0
        local totalHit = currentHit + suppressionBonus
        
        local HIT_CAP = 16
        
        if totalHit >= HIT_CAP then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5 -- Cap reached
            table.insert(activeCaps, "Hit Cap")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warlock:GetWeaponBonus(itemLink) return 0 end

MSC.RegisterModule("WARLOCK", Warlock)
