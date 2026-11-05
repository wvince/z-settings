local addonName, MSC = ...
local Shaman = {}
Shaman.Name = "SHAMAN"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Shaman.Weights = {
    ["Default"] = {
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5 
    },
    ["ELE_PVE"] = {
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3 
    },
    ["ELE_PVP"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 
    },
    ["ENH_STORMSTRIKE"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=10,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=10.0 
    },
    ["RESTO_DEEP"] = {
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 
    },
    ["RESTO_TOTEM_SUPPORT"] = {
        ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=4.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.5 
    },
    ["HYBRID_ELE_RESTO"] = {
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 
    },
    ["HYBRID_ENH_RESTO"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=10,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=0.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Shaman.LevelingWeights = {
    ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5.0, ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
    
    ["Leveling_Caster_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
    
    -- Tank Shaman
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0 },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.2 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Shaman.PrettyNames = {
    ["ELE_PVE"]             = "DPS: Elemental (PvE)",
    ["ELE_PVP"]             = "PvP: Elemental (Burst)",
    ["RESTO_DEEP"]          = "Healer: Deep Restoration",
    ["RESTO_TOTEM_SUPPORT"] = "Healer: Totem Twisting",
    ["ENH_STORMSTRIKE"]     = "DPS: Enhancement",
    ["HYBRID_ELE_RESTO"]    = "Hybrid: Ele / Resto (NS)",
    ["HYBRID_ENH_RESTO"]    = "Hybrid: Enh / Resto (PvP)",
    
    ["Leveling_1_20"]       = "Leveling (1-20)",
    ["Leveling_21_40"]      = "Leveling: Enhancement (21-40)",
    ["Leveling_41_51"]      = "Leveling: Enhancement (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Enh (52-59)",
    
    ["Leveling_Caster_52_59"] = "Leveling: Elemental (52-59)",
    ["Leveling_Healer_52_59"] = "Leveling: Resto Dungeon (52-59)",
    
    ["Leveling_Tank_21_40"]   = "Leveling: Tank Shaman (21-40)",
    ["Leveling_Tank_41_51"]   = "Leveling: Tank Shaman (41-51)",
    ["Leveling_Tank_52_59"]   = "Leveling: Tank Shaman (52-59)",
}

-- =============================================================
-- ERA TALENTS
-- =============================================================
Shaman.Talents = { 
    ["ELEMENTAL_MASTERY"] = MSC.L["Elemental Mastery"],
    ["STORMSTRIKE"]       = MSC.L["Stormstrike"],
    ["MANA_TIDE"]         = MSC.L["Mana Tide Totem"],
    ["NATURES_SWIFTNESS"] = MSC.L["Nature's Swiftness"],
    ["LIGHTNING_MASTERY"] = MSC.L["Lightning Mastery"],
    ["FLURRY"]            = MSC.L["Flurry"],
    ["ENHANCING_TOTEMS"]  = MSC.L["Enhancing Totems"],
    ["EYE_OF_STORM"]      = MSC.L["Eye of the Storm"],
    ["ANCESTRAL_KNOW"]    = MSC.L["Ancestral Knowledge"],
    ["NATURE_GUIDANCE"]   = MSC.L["Nature's Guidance"],
    ["ELEMENTAL_FURY"]    = MSC.L["Elemental Fury"],
    ["SHIELD_SPEC"]       = MSC.L["Shield Specialization"],
    ["ANTICIPATION"]      = MSC.L["Anticipation"],
    ["TIDAL_MASTERY"]     = MSC.L["Tidal Mastery"], -- Added missing key
}

-- =============================================================
-- LOGIC
-- =============================================================
Shaman.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes (2H via Talent)
    [4]=true, [5]=true,   -- 1H/2H Maces (2H via Talent)
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    -- (No [6]: weapon subclass 6 is Polearms, which Shamans can't use; shields are armor.)
}

function Shaman:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        
        -- Detect Roles
        local role = "Leveling" -- Default Enh
        if Rank("SHIELD_SPEC") > 0 then role = "Leveling_Tank"
        elseif Rank("ELEMENTAL_FURY") > 0 then role = "Leveling_Caster"
        elseif Rank("MANA_TIDE") > 0 then role = "Leveling_Healer"
        end
        
        local key = role .. suffix
        if Shaman.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("ELEMENTAL_MASTERY") > 0 then 
        if Rank("EYE_OF_STORM") > 0 then return "ELE_PVP" end
        return "ELE_PVE" 
    end
    if Rank("MANA_TIDE") > 0 then return "RESTO_DEEP" end
    if Rank("STORMSTRIKE") > 0 then return "ENH_STORMSTRIKE" end
    if Rank("NATURES_SWIFTNESS") > 0 and Rank("LIGHTNING_MASTERY") > 0 then return "HYBRID_ELE_RESTO" end
    if Rank("NATURES_SWIFTNESS") > 0 and Rank("FLURRY") > 0 then return "HYBRID_ENH_RESTO" end
    if Rank("ENHANCING_TOTEMS") > 0 and Rank("TIDAL_MASTERY") > 0 then return "RESTO_TOTEM_SUPPORT" end
    return "RESTO_DEEP"
end

function Shaman:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Nature's Guidance (Hit) ]]
    local hitBonus = Rank("NATURE_GUIDANCE") -- 1% per rank
    
    -- Physical Hit Cap
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim
        local gearHit = MSC:GetPlayerStat("HIT")
        if gearHit >= 9 then -- Nature's Guidance is already in GetHitModifier
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 
            table.insert(activeCaps, "Phys Hit (9%)")
        end
    end

    -- Spell Hit Cap
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        -- FIX: Use Shim
        local gearSpellHit = MSC:GetPlayerStat("SPELL_HIT")
        if gearSpellHit >= 16 then -- and in GetSpellHitModifier
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0
            table.insert(activeCaps, "Spell Hit (16%)")
        end
    end

    -- [[ 2. Weapon Skill (Orc Racial) ]]
    if weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] then
        local _, race = UnitRace("player")
        local skillBonus = (race == "Orc") and 5 or 0
        if skillBonus >= 5 then
            weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 5.0
            table.insert(activeCaps, "Skill (+5)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Shaman:GetWeaponBonus(itemLink, weights, slotId, specName)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local race = MSC.CtxRace()

    -- Racial: Orc (Axes)
    if race == "Orc" and (subClassID == 0 or subClassID == 1) then 
        bonus = bonus + MSC.EraWeaponSkillBonus(Shaman, weights, specName, 5)
    end
    
    return bonus
end

-- =============================================================
-- CLASS SPECIFIC ITEMS (ERA TOTEMS)
-- =============================================================
Shaman.Relics = {
    [22395] = { ITEM_MOD_SPELL_POWER_SHORT = 30 }, -- Totem of Iskar
    [23200] = { ITEM_MOD_MANA_REGENERATION_SHORT = 4 }, -- Totem of Sustaining
    [22394] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 80 }, -- Totem of Rebirth
    [23199] = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 33, estimate = true }, -- Totem of the Storm
    [22397] = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 20, estimate = true }, -- Totem of Rage
}

MSC.RegisterModule("SHAMAN", Shaman)
