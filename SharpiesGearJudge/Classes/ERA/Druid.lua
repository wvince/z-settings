local addonName, MSC = ...
local Druid = {}
Druid.Name = "DRUID"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla)
-- =============================================================
Druid.Weights = {
    ["Default"] = {
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=0.5 
    },
    ["BALANCE_BOOMKIN"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.0 
    },
    ["RESTO_MOONGLOW"] = {
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 
    },
    ["RESTO_REGROWTH"] = {
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 
    },
    ["RESTO_DEEP"] = {
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 
    },
    ["FERAL_CAT_DPS"] = {
        ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=26.0, ["ITEM_MOD_HIT_RATING_SHORT"]=22.0 
    },
    ["FERAL_BEAR_TANK"] = {
        ["ITEM_MOD_ARMOR_SHORT"]=0.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5 
    },
    ["HYBRID_HOTW"] = {
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=0.8, ["ITEM_MOD_ARMOR_SHORT"]=0.2 
    },
}

-- =============================================================
-- LEVELING WEIGHTS (Era Specific)
-- =============================================================
Druid.LevelingWeights = {
    -- Cat Form (Standard)
    -- Armor counts through ITEM_MOD_ARMOR_SHORT; the bear values already include Bear/Dire Bear
    -- Form's armor bonus (the old ARMOR_MODIFIER entries matched no item stat and were removed).
    ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, ["ITEM_MOD_ARMOR_SHORT"]= 0.2, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=12.0 },

    -- Bear Tank Leveling
    ["Leveling_Bear_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.2, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=0.8, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0 },
    ["Leveling_Bear_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.4, ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=8.0 },
    ["Leveling_Bear_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.8, ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5 },

    -- Balance
    ["Leveling_Caster_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_Caster_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },

    -- Restoration
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Druid.PrettyNames = {
    ["BALANCE_BOOMKIN"]    = "DPS: Balance (Boomkin)",
    ["RESTO_DEEP"]         = "Healer: Deep Restoration",
    ["RESTO_MOONGLOW"]     = "Healer: Moonglow",
    ["RESTO_REGROWTH"]     = "Healer: Regrowth (Crit)",
    ["FERAL_CAT_DPS"]      = "DPS: Feral Cat",
    ["FERAL_BEAR_TANK"]    = "Tank: Feral Bear",
    ["HYBRID_HOTW"]        = "Hybrid: Heart of the Wild",
    
    ["Leveling_1_20"]       = "Leveling (1-20)",
    ["Leveling_21_40"]      = "Leveling: Feral Cat (21-40)",
    ["Leveling_41_51"]      = "Leveling: Feral Cat (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Feral (52-59)",
    
    ["Leveling_Bear_21_40"] = "Leveling: Bear Tank (21-40)",
    ["Leveling_Bear_41_51"] = "Leveling: Bear Tank (41-51)",
    ["Leveling_Bear_52_59"] = "Leveling: Bear Tank (52-59)",
    
    ["Leveling_Caster_41_51"] = "Leveling: Balance (41-51)",
    ["Leveling_Caster_52_59"] = "Leveling: Pre-BiS Balance (52-59)",
    
    ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Resto (52-59)",
}

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Druid.Talents = { 
    ["MOONKIN_FORM"]    = MSC.L["Moonkin Form"],
    ["MOONGLOW"]        = MSC.L["Moonglow"],
    ["NATURES_GRACE"]   = MSC.L["Nature's Grace"],
    ["LEADER_OF_PACK"]  = MSC.L["Leader of the Pack"],
    ["HEART_WILD"]      = MSC.L["Heart of the Wild"],
    ["THICK_HIDE"]      = MSC.L["Thick Hide"],
    ["FUROR"]           = MSC.L["Furor"],
    ["SWIFTMEND"]       = MSC.L["Swiftmend"],
    ["NATURES_SWIFT"]   = MSC.L["Nature's Swiftness"],
    ["IMP_REGROWTH"]    = MSC.L["Improved Regrowth"],
    ["REFLECTION"]      = MSC.L["Reflection"],
}

-- =============================================================
-- LOGIC
-- =============================================================
Druid.ValidWeapons = {
    [4]=true, [5]=true,   -- 1H/2H Maces
    [10]=true,            -- Staves
    [13]=true,            -- Fist Weapons
    [15]=true             -- Daggers
}

function Druid:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end

        local role = "Leveling" -- Default to Cat
        if Rank("MOONKIN_FORM") > 0 then role = "Leveling_Caster"
        elseif Rank("SWIFTMEND") > 0 then role = "Leveling_Healer"
        elseif Rank("THICK_HIDE") >= 3 then role = "Leveling_Bear"
        end

        -- Not every role has a row for every band (no Bear 1-20, Caster before 41,
        -- Healer before 52): use the Cat row of that band instead of empty weights.
        local key = role .. suffix
        if Druid.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame Spec Detection
    if Rank("MOONKIN_FORM") > 0 then return "BALANCE_BOOMKIN" end
    if Rank("SWIFTMEND") > 0 then return "RESTO_DEEP" end
    if Rank("MOONGLOW") > 0 and Rank("NATURES_SWIFT") > 0 then return "RESTO_MOONGLOW" end
    if Rank("IMP_REGROWTH") >= 3 then return "RESTO_REGROWTH" end
    if Rank("HEART_WILD") > 0 and Rank("NATURES_SWIFT") > 0 then return "HYBRID_HOTW" end
    
    -- Feral Split: Bear vs Cat
    if Rank("THICK_HIDE") >= 3 then return "FERAL_BEAR_TANK" end
    return "FERAL_CAT_DPS"
end

function Druid:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {} 
    
    -- 1. Heart of the Wild
    local rHotW = Rank("HEART_WILD")
    if rHotW > 0 then
        if weights["ITEM_MOD_INTELLECT_SHORT"] then 
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04)) 
        end
        if weights["ITEM_MOD_STRENGTH_SHORT"] then
            weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rHotW * 0.04))
        end
    end

    -- 2. Covariance (Mana Regen / Healing Synergy)
    if currentSpec:find("RESTO") or currentSpec:find("Healer") then
        local healPower = MSC.GetJudgingStats().heal -- unbuffed, plus assumed buffs
        if healPower > 500 and weights["ITEM_MOD_SPIRIT_SHORT"] then -- RESTO_REGROWTH has no Spirit weight
             local hScaler = 1 + ((healPower - 500) / 5000)
             weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * hScaler
        end
    end

    -- 3. Caps (Hit Cap 9%)
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim
        local currentHit = MSC:GetPlayerStat("HIT")
        if currentHit >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 -- Drop value
            table.insert(activeCaps, "Hit (9%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Druid:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- IDOLS (Classic Era)
-- =============================================================
Druid.Relics = {
    [22398] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 20 }, -- Idol of Brutality
    [22396] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 30 },      -- Idol of Health
    [23197] = { ITEM_MOD_SPELL_POWER_SHORT = 33 },        -- Idol of the Moon
}

-- Register Profiles
Druid.Profiles = {}
for k, v in pairs(Druid.Weights) do Druid.Profiles[k] = v end
for k, v in pairs(Druid.LevelingWeights) do Druid.Profiles[k] = v end

MSC.RegisterModule("DRUID", Druid)

