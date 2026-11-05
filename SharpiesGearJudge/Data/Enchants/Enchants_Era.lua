local _, MSC = ...

-- ============================================================================
-- CLASSIC ERA ENCHANTS
-- ============================================================================
-- Generated from the client's own tables (wago.tools, build 1.15.9.70003) by
-- SharpiesGearJudge-Research/sets/gen_enchants.py. Rerun it after a client
-- update instead of editing these tables by hand.
--
-- Every enchant here can really be applied in this game: an Enchanting recipe or
-- the use effect of a real item (armor kits, arcanums, scopes, shoulder
-- inscriptions...). Stats match the enchant's tooltip line, because the addon
-- subtracts them from an item's tooltip stats. Proc enchants carry an estimated
-- average. lvl: an enchant item's required level, or for an Enchanting recipe
-- its skill rank / 5 minus 10 (enchants have no level requirement, so recipes are
-- suggested a little early); suggestions skip enchants above the player's level.
-- Ring enchants are left out (Enchanters only). classMask (bit = 2^(classID-1))
-- marks class-only enchant items such as the Zul'Gurub idols. spell / item is the
-- recipe or enchant item; MSC.GetEnchantName asks the game for its name in the
-- player's language (name is the English fallback). showStats adds the stats to
-- the name for items that share one (the Voracity arcanums).
-- ============================================================================
MSC.EnchantDB = {
    [2583] = { name = "Presence of Might", lvl = 60, classMask = 1, item = 19782, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7, ITEM_MOD_STAMINA_SHORT = 10 } }, -- Defense +7/Stamina +10/Block Value +15 (item)
    [2584] = { name = "Syncretist's Sigil", lvl = 60, classMask = 2, item = 19783, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10 } }, -- Defense +7/Stamina +10/Healing Spells +24 (item)
    [2585] = { name = "Death's Embrace", lvl = 60, classMask = 8, item = 19784, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 28, ITEM_MOD_DODGE_RATING_SHORT = 1 } }, -- Attack Power +28/Dodge +1% (item)
    [2586] = { name = "Falcon's Call", lvl = 60, classMask = 4, item = 19785, stats = { ITEM_MOD_HIT_RATING_SHORT = 1, ITEM_MOD_RANGED_ATTACK_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10 } }, -- Ranged Attack Power +24/Stamina +10/Hit +1% (item)
    [2587] = { name = "Vodouisant's Vigilant Embrace", lvl = 60, classMask = 64, item = 19786, stats = { ITEM_MOD_INTELLECT_SHORT = 15, ITEM_MOD_SPELL_POWER_SHORT = 13 } }, -- Healing and Spell Damage +13/Intellect +15 (item)
    [2588] = { name = "Presence of Sight", lvl = 60, classMask = 128, item = 19787, stats = { ITEM_MOD_HIT_SPELL_RATING_SHORT = 1, ITEM_MOD_SPELL_POWER_SHORT = 18 } }, -- Healing and Spell Damage +18/Spell Hit +1% (item)
    [2589] = { name = "Hoodoo Hex", lvl = 60, classMask = 256, item = 19788, stats = { ITEM_MOD_SPELL_POWER_SHORT = 18, ITEM_MOD_STAMINA_SHORT = 10 } }, -- Healing and Spell Damage +18/Stamina +10 (item)
    [2590] = { name = "Prophetic Aura", lvl = 60, classMask = 16, item = 19789, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 4, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10 } }, -- Mana Regen +4/Stamina +10/Healing Spells +24 (item)
    [2591] = { name = "Animist's Caress", lvl = 60, classMask = 1024, item = 19790, stats = { ITEM_MOD_INTELLECT_SHORT = 10, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10 } }, -- Intellect +10/Stamina +10/Healing Spells +24 (item)
    [1504] = { name = "Lesser Arcanum of Tenacity", lvl = 50, item = 11643, stats = { ITEM_MOD_ARMOR_SHORT = 125 } }, -- Armor +125 (item)
    [1506] = { name = "Lesser Arcanum of Voracity (+8 Strength)", lvl = 50, item = 11645, showStats = true, stats = { ITEM_MOD_STRENGTH_SHORT = 8 } }, -- Strength +8 (item)
    [1507] = { name = "Lesser Arcanum of Voracity (+8 Stamina)", lvl = 50, item = 11646, showStats = true, stats = { ITEM_MOD_STAMINA_SHORT = 8 } }, -- Stamina +8 (item)
    [1508] = { name = "Lesser Arcanum of Voracity (+8 Agility)", lvl = 50, item = 11647, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 8 } }, -- Agility +8 (item)
    [1509] = { name = "Lesser Arcanum of Voracity (+8 Intellect)", lvl = 50, item = 11648, showStats = true, stats = { ITEM_MOD_INTELLECT_SHORT = 8 } }, -- Intellect +8 (item)
    [1510] = { name = "Lesser Arcanum of Voracity (+8 Spirit)", lvl = 50, item = 11649, showStats = true, stats = { ITEM_MOD_SPIRIT_SHORT = 8 } }, -- Spirit +8 (item)
    [2544] = { name = "Arcanum of Focus", lvl = 50, item = 18330, stats = { ITEM_MOD_SPELL_POWER_SHORT = 8 } }, -- Healing and Spell Damage +8 (item)
    [2545] = { name = "Arcanum of Protection", lvl = 50, item = 18331, stats = { ITEM_MOD_DODGE_RATING_SHORT = 1 } }, -- Dodge +1% (item)
    [2604] = { name = "Zandalar Signet of Serenity", lvl = 60, item = 20078, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 33 } }, -- +33 Healing Spells (item)
    [2605] = { name = "Zandalar Signet of Mojo", lvl = 60, item = 20076, stats = { ITEM_MOD_SPELL_POWER_SHORT = 18 } }, -- +18 Spell Damage and Healing (item)
    [2606] = { name = "Zandalar Signet of Might", lvl = 60, item = 20077, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30 } }, -- +30 Attack Power (item)
    [2715] = { name = "Resilience of the Scourge", lvl = 60, item = 23547, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 5, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 31 } }, -- Healing +31 and 5 mana per 5 sec. (item)
    [2716] = { name = "Fortitude of the Scourge", lvl = 60, item = 23549, stats = { ITEM_MOD_ARMOR_SHORT = 100, ITEM_MOD_STAMINA_SHORT = 16 } }, -- Stamina +16 and Armor +100 (item)
    [2717] = { name = "Might of the Scourge", lvl = 60, item = 23548, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26, ITEM_MOD_CRIT_RATING_SHORT = 1, ITEM_MOD_RANGED_ATTACK_POWER_SHORT = 27 } }, -- Attack Power +26 and +1% Critical Strike (item)
    [2721] = { name = "Power of the Scourge", lvl = 60, item = 23545, stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 1, ITEM_MOD_SPELL_POWER_SHORT = 15 } }, -- Spell Damage +15 and +1% Spell Critical Strike (item)
    [1891] = { name = "Greater Stats", lvl = 50, spell = 20025, stats = { ITEM_MOD_AGILITY_SHORT = 4, ITEM_MOD_INTELLECT_SHORT = 4, ITEM_MOD_SPIRIT_SHORT = 4, ITEM_MOD_STAMINA_SHORT = 4, ITEM_MOD_STRENGTH_SHORT = 4 } }, -- All Stats +4 (Enchanting)
    [2503] = { name = "Core Armor Kit", lvl = 50, item = 18251, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 3 } }, -- Defense +3 (item)
    [1843] = { name = "Rugged Armor Kit", lvl = 40, item = 15564, stats = { ITEM_MOD_ARMOR_SHORT = 40 } }, -- Reinforced Armor +40 (item)
    [928] = { name = "Stats", lvl = 39, spell = 13941, stats = { ITEM_MOD_AGILITY_SHORT = 3, ITEM_MOD_INTELLECT_SHORT = 3, ITEM_MOD_SPIRIT_SHORT = 3, ITEM_MOD_STAMINA_SHORT = 3, ITEM_MOD_STRENGTH_SHORT = 3 } }, -- All Stats +3 (Enchanting)
    [18] = { name = "Thick Armor Kit", lvl = 30, item = 8173, stats = { ITEM_MOD_ARMOR_SHORT = 32 } }, -- Reinforced Armor +32 (item)
    [866] = { name = "Lesser Stats", lvl = 30, spell = 13700, stats = { ITEM_MOD_AGILITY_SHORT = 2, ITEM_MOD_INTELLECT_SHORT = 2, ITEM_MOD_SPIRIT_SHORT = 2, ITEM_MOD_STAMINA_SHORT = 2, ITEM_MOD_STRENGTH_SHORT = 2 } }, -- All Stats +2 (Enchanting)
    [847] = { name = "Minor Stats", lvl = 21, spell = 13626, stats = { ITEM_MOD_AGILITY_SHORT = 1, ITEM_MOD_INTELLECT_SHORT = 1, ITEM_MOD_SPIRIT_SHORT = 1, ITEM_MOD_STAMINA_SHORT = 1, ITEM_MOD_STRENGTH_SHORT = 1 } }, -- All Stats +1 (Enchanting)
    [17] = { name = "Heavy Armor Kit", lvl = 20, item = 4265, stats = { ITEM_MOD_ARMOR_SHORT = 24 } }, -- Reinforced Armor +24 (item)
    [16] = { name = "Medium Armor Kit", lvl = 5, item = 2313, stats = { ITEM_MOD_ARMOR_SHORT = 16 } }, -- Reinforced Armor +16 (item)
    [15] = { name = "Light Armor Kit", lvl = 1, item = 2304, stats = { ITEM_MOD_ARMOR_SHORT = 8 } }, -- Reinforced Armor +8 (item)
    [1887] = { name = "Greater Agility", lvl = 44, spell = 20012, stats = { ITEM_MOD_AGILITY_SHORT = 7 } }, -- Agility +7 (Enchanting)
    [929] = { name = "Greater Stamina", lvl = 39, spell = 13945, stats = { ITEM_MOD_STAMINA_SHORT = 7 } }, -- Stamina +7 (Enchanting)
    [852] = { name = "Stamina", lvl = 24, spell = 13648, stats = { ITEM_MOD_STAMINA_SHORT = 5 } }, -- Stamina +5 (Enchanting)
    [851] = { name = "Spirit", lvl = 23, spell = 13642, stats = { ITEM_MOD_SPIRIT_SHORT = 5 } }, -- Spirit +5 (Enchanting)
    [849] = { name = "Lesser Agility", lvl = 22, spell = 13637, stats = { ITEM_MOD_AGILITY_SHORT = 3 } }, -- Agility +3 (Enchanting)
    [724] = { name = "Lesser Stamina", lvl = 17, spell = 13501, stats = { ITEM_MOD_STAMINA_SHORT = 3 } }, -- Stamina +3 (Enchanting)
    [255] = { name = "Lesser Spirit", lvl = 13, requires2H = true, spell = 13380, stats = { ITEM_MOD_SPIRIT_SHORT = 3 } }, -- Spirit +3 (Enchanting)
    [1886] = { name = "Superior Stamina", lvl = 50, spell = 20011, stats = { ITEM_MOD_STAMINA_SHORT = 9 } }, -- Stamina +9 (Enchanting)
    [2566] = { name = "Healing Power (+24 Healing)", lvl = 50, spell = 23802, showStats = true, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 24 } }, -- Healing Spells +24 (Enchanting)
    [1885] = { name = "Superior Strength", lvl = 49, spell = 20010, stats = { ITEM_MOD_STRENGTH_SHORT = 9 } }, -- Strength +9 (Enchanting)
    [2565] = { name = "Mana Regeneration", lvl = 48, spell = 23801, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 4 } }, -- Mana Regen 4 per 5 sec. (Enchanting)
    [1884] = { name = "Superior Spirit", lvl = 44, spell = 20009, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } }, -- Spirit +9 (Enchanting)
    [1883] = { name = "Greater Intellect", lvl = 41, spell = 20008, stats = { ITEM_MOD_INTELLECT_SHORT = 7 } }, -- Intellect +7 (Enchanting)
    [927] = { name = "Greater Strength", lvl = 38, spell = 13939, stats = { ITEM_MOD_STRENGTH_SHORT = 7 } }, -- Strength +7 (Enchanting)
    [923] = { name = "Deflection", lvl = 37, spell = 13931, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 3 } }, -- Defense +3 (Enchanting)
    [907] = { name = "Greater Spirit", lvl = 34, spell = 13846, stats = { ITEM_MOD_SPIRIT_SHORT = 7 } }, -- Spirit +7 (Enchanting)
    [905] = { name = "Intellect", lvl = 32, spell = 13822, stats = { ITEM_MOD_INTELLECT_SHORT = 5 } }, -- Intellect +5 (Enchanting)
    [856] = { name = "Strength (+5 Strength)", lvl = 26, spell = 13661, showStats = true, stats = { ITEM_MOD_STRENGTH_SHORT = 5 } }, -- Strength +5 (Enchanting)
    [925] = { name = "Lesser Deflection", lvl = 24, spell = 13646, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 2 } }, -- Defense +2 (Enchanting)
    [823] = { name = "Lesser Strength", lvl = 19, spell = 13536, stats = { ITEM_MOD_STRENGTH_SHORT = 3 } }, -- Strength +3 (Enchanting)
    [723] = { name = "Lesser Intellect", lvl = 12, requires2H = true, spell = 7793, stats = { ITEM_MOD_INTELLECT_SHORT = 3 } }, -- Intellect +3 (Enchanting)
    [247] = { name = "Minor Agility", lvl = 9, spell = 7779, stats = { ITEM_MOD_AGILITY_SHORT = 1 } }, -- Agility +1 (Enchanting)
    [248] = { name = "Minor Strength", lvl = 9, spell = 7782, stats = { ITEM_MOD_STRENGTH_SHORT = 1 } }, -- Strength +1 (Enchanting)
    [243] = { name = "Minor Spirit", lvl = 7, spell = 7766, stats = { ITEM_MOD_SPIRIT_SHORT = 1 } }, -- Spirit +1 (Enchanting)
    [66] = { name = "Minor Stamina", lvl = 6, spell = 7457, stats = { ITEM_MOD_STAMINA_SHORT = 1 } }, -- Stamina +1 (Enchanting)
    [924] = { name = "Minor Deflect", lvl = 2, spell = 7428, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 1 } }, -- Defense +1 (Enchanting)
    [2614] = { name = "Shadow Power", lvl = 50, spell = 25073, stats = { ITEM_MOD_SHADOW_DAMAGE_SHORT = 20 } }, -- Shadow Damage +20 (Enchanting)
    [2615] = { name = "Frost Power", lvl = 50, spell = 25074, stats = { ITEM_MOD_FROST_DAMAGE_SHORT = 20 } }, -- Frost Damage +20 (Enchanting)
    [2616] = { name = "Fire Power", lvl = 50, spell = 25078, stats = { ITEM_MOD_FIRE_DAMAGE_SHORT = 20 } }, -- Fire Damage +20 (Enchanting)
    [2617] = { name = "Healing Power (+30 Healing)", lvl = 50, spell = 25079, showStats = true, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 30 } }, -- Healing Spells +30 (Enchanting)
    [2564] = { name = "Agility (+15 Agility)", lvl = 48, spell = 23800, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 15 } }, -- Agility +15 (Enchanting)
    [904] = { name = "Agility (+5 Agility)", lvl = 32, spell = 13815, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 5 } }, -- Agility +5 (Enchanting)
    [2622] = { name = "Dodge", lvl = 50, spell = 25086, stats = { ITEM_MOD_DODGE_RATING_SHORT = 1 } }, -- Dodge +1% (Enchanting)
    [1889] = { name = "Superior Defense", lvl = 47, spell = 20015, stats = { ITEM_MOD_ARMOR_SHORT = 70 } }, -- Armor +70 (Enchanting)
    [884] = { name = "Greater Defense", lvl = 31, spell = 13746, stats = { ITEM_MOD_ARMOR_SHORT = 50 } }, -- Armor +50 (Enchanting)
    [848] = { name = "Defense", lvl = 21, spell = 13635, stats = { ITEM_MOD_ARMOR_SHORT = 30 } }, -- Armor +30 (Enchanting)
    [744] = { name = "Lesser Protection", lvl = 14, spell = 13421, stats = { ITEM_MOD_ARMOR_SHORT = 20 } }, -- Armor +20 (Enchanting)
    [783] = { name = "Minor Protection", lvl = 8, spell = 7771, stats = { ITEM_MOD_ARMOR_SHORT = 10 } }, -- Armor +10 (Enchanting)
    [1898] = { name = "Lifestealing", lvl = 50, spell = 20032, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, -- Lifestealing (Enchanting)
    [1900] = { name = "Crusader", lvl = 50, spell = 20034, stats = { ITEM_MOD_STRENGTH_SHORT = 35 } }, -- Crusader (Enchanting)
    [1903] = { name = "Major Spirit", lvl = 50, requires2H = true, spell = 20035, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } }, -- Spirit +9 (Enchanting)
    [1904] = { name = "Major Intellect", lvl = 50, requires2H = true, spell = 20036, stats = { ITEM_MOD_INTELLECT_SHORT = 9 } }, -- Intellect +9 (Enchanting)
    [2504] = { name = "Spell Power", lvl = 50, spell = 22749, stats = { ITEM_MOD_SPELL_POWER_SHORT = 30 } }, -- Spell Damage +30 (Enchanting)
    [2505] = { name = "Healing Power (+55 Healing)", lvl = 50, spell = 22750, showStats = true, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 55 } }, -- Healing Spells +55 (Enchanting)
    [2567] = { name = "Mighty Spirit", lvl = 50, spell = 23803, stats = { ITEM_MOD_SPIRIT_SHORT = 20 } }, -- Spirit +20 (Enchanting)
    [2568] = { name = "Mighty Intellect", lvl = 50, spell = 23804, stats = { ITEM_MOD_INTELLECT_SHORT = 22 } }, -- Intellect +22 (Enchanting)
    [1896] = { name = "Superior Impact", lvl = 49, requires2H = true, spell = 20030, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 3.6 } }, -- Weapon Damage +9 (Enchanting)
    [1899] = { name = "Unholy Weapon", lvl = 49, spell = 20033, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, -- Unholy Weapon (Enchanting)
    [2563] = { name = "Strength (+15 Strength)", lvl = 48, spell = 23799, showStats = true, stats = { ITEM_MOD_STRENGTH_SHORT = 15 } }, -- Strength +15 (Enchanting)
    [2646] = { name = "Agility (+25 Agility)", lvl = 48, requires2H = true, spell = 27837, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 25 } }, -- Agility +25 (Enchanting)
    [1894] = { name = "Icy Chill", lvl = 47, spell = 20029, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1 } }, -- Icy Weapon (Enchanting)
    [803] = { name = "Fiery Weapon", lvl = 43, spell = 13898, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 3 } }, -- Fiery Weapon (Enchanting)
    [805] = { name = "Greater Striking", lvl = 39, spell = 13943, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1.6 } }, -- Weapon Damage +4 (Enchanting)
    [963] = { name = "Greater Impact", lvl = 38, requires2H = true, spell = 13937, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2.8 } }, -- Weapon Damage +7 (Enchanting)
    [1897] = { name = "Impact", lvl = 30, requires2H = true, spell = 13695, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, -- Weapon Damage +5 (Enchanting)
    [2443] = { name = "Winter's Might", lvl = 28, spell = 21931, stats = { ITEM_MOD_FROST_DAMAGE_SHORT = 7 } }, -- Frost Spell Damage +7 (Enchanting)
    [943] = { name = "Lesser Impact", lvl = 20, requires2H = true, spell = 13529, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1.2 } }, -- Weapon Damage +3 (Enchanting)
    [241] = { name = "Minor Impact", lvl = 12, requires2H = true, spell = 7745, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.8 } }, -- Weapon Damage +2 (Enchanting)
    [250] = { name = "Minor Striking", lvl = 10, spell = 7788, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.4 } }, -- Weapon Damage +1  (Enchanting)
    [1890] = { name = "Superior Spirit", lvl = 46, isShield = true, spell = 20016, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } }, -- Spirit +9 (Enchanting)
    [863] = { name = "Lesser Block", lvl = 29, isShield = true, spell = 13689, stats = { ITEM_MOD_BLOCK_RATING_SHORT = 2 } }, -- Blocking +2% (Enchanting)
    [2523] = { name = "Biznicks 247x128 Accurascope", lvl = 50, isScope = true, item = 18283, stats = { ITEM_MOD_HIT_RATING_SHORT = 3 } }, -- +3% Hit (item)
    [664] = { name = "Sniper Scope", lvl = 40, isScope = true, item = 10548, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2.8 } }, -- Scope (+7 Damage) (item)
    [663] = { name = "Deadly Scope", lvl = 30, isScope = true, item = 10546, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, -- Scope (+5 Damage) (item)
    [33] = { name = "Accurate Scope", lvl = 20, isScope = true, item = 4407, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1.2 } }, -- Scope (+3 Damage) (item)
    [32] = { name = "Standard Scope", lvl = 10, isScope = true, item = 4406, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.8 } }, -- Scope (+2 Damage) (item)
    [30] = { name = "Crude Scope", lvl = 5, isScope = true, item = 4405, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.4 } }, -- Scope (+1 Damage) (item)
}

-- Which enchant IDs the evaluator tries for each equipment slot.
MSC.EnchantCandidates = {
    -- [[ HEAD ]]
    [1] = { 2583, 2584, 2585, 2586, 2587, 2588, 2589, 2590, 2591, 1504, 1506, 1507, 1508, 1509, 1510, 2544, 2545 },
    -- [[ SHOULDER ]]
    [3] = { 2604, 2605, 2606, 2715, 2716, 2717, 2721 },
    -- [[ CHEST ]]
    [5] = { 1891, 2503, 1843, 928, 18, 866, 847, 17, 16, 15 },
    -- [[ LEGS ]]
    [7] = { 2583, 2584, 2585, 2586, 2587, 2588, 2589, 2590, 2591, 1504, 1506, 1507, 1508, 1509, 1510, 2503, 2544, 2545, 1843, 18, 17, 16, 15 },
    -- [[ FEET ]]
    [8] = { 2503, 1887, 1843, 929, 18, 852, 851, 849, 17, 724, 255, 16, 15 },
    -- [[ WRIST ]]
    [9] = { 1886, 2566, 1885, 2565, 1884, 1883, 929, 927, 923, 907, 905, 856, 852, 925, 851, 823, 724, 723, 247, 248, 243, 66, 924 },
    -- [[ HANDS ]]
    [10] = { 2503, 2614, 2615, 2616, 2617, 2564, 1887, 1843, 927, 904, 18, 17, 16, 15 },
    -- [[ BACK ]]
    [15] = { 2622, 1889, 884, 849, 848, 744, 783 },
    -- [[ WEAPON (MAIN HAND / 2H) ]]
    [16] = { 1898, 1900, 1903, 1904, 2504, 2505, 2567, 2568, 1896, 1899, 2563, 2564, 2646, 1894, 803, 805, 963, 1897, 2443, 943, 255, 241, 723, 250, 247 },
    -- [[ OFF HAND (WEAPON OR SHIELD) ]]
    [17] = { 1898, 1900, 2504, 2505, 2567, 2568, 1899, 2563, 2564, 1894, 1890, 803, 805, 929, 1897, 863, 2443, 852, 851, 943, 241, 250, 247, 66 },
    -- [[ RANGED (SCOPES) ]]
    [18] = { 2523, 664, 663, 33, 32, 30 },
}
MSC.EnchantCandidates_Leveling = nil
