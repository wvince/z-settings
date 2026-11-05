local _, MSC = ...

-- ============================================================================
-- TBC ANNIVERSARY ENCHANTS
-- ============================================================================
-- Generated from the client's own tables (wago.tools, build 2.5.6.69795) by
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
    [2999] = { name = "Glyph of the Defender", lvl = 70, item = 29186, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 16, ITEM_MOD_DODGE_RATING_SHORT = 17 } }, -- +16 Defense Rating and +17 Dodge Rating (item)
    [3001] = { name = "Glyph of Renewal", lvl = 70, item = 29189, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 7, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 35, ITEM_MOD_SPELL_POWER_SHORT = 12 } }, -- +35 Healing +12 Spell Damage and 7 Mana Per 5 sec. (item)
    [3002] = { name = "Glyph of Power", lvl = 70, item = 29191, stats = { ITEM_MOD_HIT_SPELL_RATING_SHORT = 14, ITEM_MOD_SPELL_POWER_SHORT = 22 } }, -- +22 Spell Power and +14 Spell Hit Rating (item)
    [3003] = { name = "Glyph of Ferocity", lvl = 70, item = 29192, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 34, ITEM_MOD_HIT_RATING_SHORT = 16 } }, -- +34 Attack Power and +16 Hit Rating (item)
    [3004] = { name = "Glyph of the Gladiator", lvl = 70, item = 29193, stats = { ITEM_MOD_RESILIENCE_RATING_SHORT = 20, ITEM_MOD_STAMINA_SHORT = 18 } }, -- +18 Stamina and +20 Resilience Rating (item)
    [3096] = { name = "Glyph of the Outcast", lvl = 70, item = 30846, stats = { ITEM_MOD_INTELLECT_SHORT = 16, ITEM_MOD_STRENGTH_SHORT = 17 } }, -- +17 Strength and +16 Intellect (item)
    [2583] = { name = "Presence of Might", lvl = 60, classMask = 1, item = 19782, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 10, ITEM_MOD_STAMINA_SHORT = 10 } }, -- +10 Defense Rating/+10 Stamina/+15 Block Value (item)
    [2584] = { name = "Syncretist's Sigil", lvl = 60, classMask = 2, item = 19783, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 10, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10 } }, -- +7 Defense/+10 Stamina/+24 Healing Spells (item)
    [2585] = { name = "Death's Embrace", lvl = 60, classMask = 8, item = 19784, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 28, ITEM_MOD_DODGE_RATING_SHORT = 12 } }, -- +28 Attack Power/+12 Dodge Rating (item)
    [2586] = { name = "Falcon's Call", lvl = 60, classMask = 4, item = 19785, stats = { ITEM_MOD_HIT_RATING_SHORT = 10, ITEM_MOD_RANGED_ATTACK_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10 } }, -- +24 Ranged Attack Power/+10 Stamina/+10 Hit Rating (item)
    [2587] = { name = "Vodouisant's Vigilant Embrace", lvl = 60, classMask = 64, item = 19786, stats = { ITEM_MOD_INTELLECT_SHORT = 15, ITEM_MOD_SPELL_POWER_SHORT = 13 } }, -- +13 Healing and Spell Damage/+15 Intellect (item)
    [2588] = { name = "Presence of Sight", lvl = 60, classMask = 128, item = 19787, stats = { ITEM_MOD_HIT_SPELL_RATING_SHORT = 8, ITEM_MOD_SPELL_POWER_SHORT = 18 } }, -- +18 Healing and Spell Damage/+8 Spell Hit (item)
    [2589] = { name = "Hoodoo Hex", lvl = 60, classMask = 256, item = 19788, stats = { ITEM_MOD_SPELL_POWER_SHORT = 18, ITEM_MOD_STAMINA_SHORT = 10 } }, -- +18 Healing and Spell Damage/+10 Stamina (item)
    [2590] = { name = "Prophetic Aura", lvl = 60, classMask = 16, item = 19789, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 4, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10 } }, -- +4 Mana Regen/+10 Stamina/+24 Healing Spells (item)
    [2591] = { name = "Animist's Caress", lvl = 60, classMask = 1024, item = 19790, stats = { ITEM_MOD_INTELLECT_SHORT = 10, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10 } }, -- +10 Intellect/+10 Stamina/+24 Healing Spells (item)
    [2841] = { name = "Heavy Knothide Armor Kit", lvl = 60, item = 34330, stats = { ITEM_MOD_STAMINA_SHORT = 10 } }, -- +10 Stamina (item)
    [1504] = { name = "Lesser Arcanum of Tenacity", lvl = 50, item = 11643, stats = { ITEM_MOD_ARMOR_SHORT = 125 } }, -- +125 Armor (item)
    [1506] = { name = "Lesser Arcanum of Voracity (+8 Strength)", lvl = 50, item = 11645, showStats = true, stats = { ITEM_MOD_STRENGTH_SHORT = 8 } }, -- +8 Strength (item)
    [1507] = { name = "Lesser Arcanum of Voracity (+8 Stamina)", lvl = 50, item = 11646, showStats = true, stats = { ITEM_MOD_STAMINA_SHORT = 8 } }, -- +8 Stamina (item)
    [1508] = { name = "Lesser Arcanum of Voracity (+8 Agility)", lvl = 50, item = 11647, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 8 } }, -- +8 Agility (item)
    [1509] = { name = "Lesser Arcanum of Voracity (+8 Intellect)", lvl = 50, item = 11648, showStats = true, stats = { ITEM_MOD_INTELLECT_SHORT = 8 } }, -- +8 Intellect (item)
    [1510] = { name = "Lesser Arcanum of Voracity (+8 Spirit)", lvl = 50, item = 11649, showStats = true, stats = { ITEM_MOD_SPIRIT_SHORT = 8 } }, -- +8 Spirit (item)
    [2978] = { name = "Greater Inscription of Warding", lvl = 70, item = 28889, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 10, ITEM_MOD_DODGE_RATING_SHORT = 15 } }, -- +15 Dodge Rating and +10 Defense Rating (item)
    [2980] = { name = "Greater Inscription of Faith", lvl = 70, item = 28887, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 4, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 33, ITEM_MOD_SPELL_POWER_SHORT = 11 } }, -- +33 Healing and +11 Spell Damage and +4 Mana Regen (item)
    [2982] = { name = "Greater Inscription of Discipline", lvl = 70, item = 28886, stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 10, ITEM_MOD_SPELL_POWER_SHORT = 18 } }, -- +18 Spell Power and +10 Spell Critical Strike Rating (item)
    [2986] = { name = "Greater Inscription of Vengeance", lvl = 70, item = 28888, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30, ITEM_MOD_CRIT_RATING_SHORT = 10 } }, -- +30 Attack Power and +10 Critical Strike Rating (item)
    [2991] = { name = "Greater Inscription of the Knight", lvl = 70, item = 28911, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 15, ITEM_MOD_DODGE_RATING_SHORT = 10 } }, -- +15 Defense Rating and +10 Dodge Rating (item)
    [2993] = { name = "Greater Inscription of the Oracle", lvl = 70, item = 28912, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 6, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 22, ITEM_MOD_SPELL_POWER_SHORT = 8 } }, -- +6 Mana Regen and +22 Healing (item)
    [2995] = { name = "Greater Inscription of the Orb", lvl = 70, item = 28909, stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 15, ITEM_MOD_SPELL_POWER_SHORT = 12 } }, -- +15 Spell Critical Strike Rating and +12 Spell Damage and Healing (item)
    [2997] = { name = "Greater Inscription of the Blade", lvl = 70, item = 28910, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 20, ITEM_MOD_CRIT_RATING_SHORT = 15 } }, -- +15 Critical Strike Rating and +20 Attack Power (item)
    [2977] = { name = "Inscription of Warding", lvl = 64, item = 28882, stats = { ITEM_MOD_DODGE_RATING_SHORT = 13 } }, -- +13 Dodge Rating (item)
    [2979] = { name = "Inscription of Faith", lvl = 64, item = 28878, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 29, ITEM_MOD_SPELL_POWER_SHORT = 10 } }, -- +29 Healing and +10 Spell Damage (item)
    [2981] = { name = "Inscription of Discipline", lvl = 64, item = 28881, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15 } }, -- +15 Spell Power (item)
    [2983] = { name = "Inscription of Vengeance", lvl = 64, item = 28885, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } }, -- +26 Attack Power (item)
    [2990] = { name = "Inscription of the Knight", lvl = 64, item = 28908, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 13 } }, -- +13 Defense Rating (item)
    [2992] = { name = "Inscription of the Oracle", lvl = 64, item = 28904, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 5 } }, -- +5 Mana Regen (item)
    [2994] = { name = "Inscription of the Orb", lvl = 64, item = 28903, stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 13 } }, -- +13 Spell Critical Strike Rating (item)
    [2996] = { name = "Inscription of the Blade", lvl = 64, item = 28907, stats = { ITEM_MOD_CRIT_RATING_SHORT = 13 } }, -- +13 Critical Strike Rating (item)
    [2604] = { name = "Zandalar Signet of Serenity", lvl = 60, item = 20078, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 33, ITEM_MOD_SPELL_POWER_SHORT = 11 } }, -- +33 Healing Spells and +11 Damage Spells (item)
    [2605] = { name = "Zandalar Signet of Mojo", lvl = 60, item = 20076, stats = { ITEM_MOD_SPELL_POWER_SHORT = 18 } }, -- +18 Spell Damage and Healing (item)
    [2606] = { name = "Zandalar Signet of Might", lvl = 60, item = 20077, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30 } }, -- +30 Attack Power (item)
    [2715] = { name = "Resilience of the Scourge", lvl = 60, item = 23547, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 5, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 31, ITEM_MOD_SPELL_POWER_SHORT = 11 } }, -- +31 Healing +11 Spell Damage and 5 mana per 5 sec. (item)
    [2716] = { name = "Fortitude of the Scourge", lvl = 60, item = 23549, stats = { ITEM_MOD_ARMOR_SHORT = 100, ITEM_MOD_STAMINA_SHORT = 16 } }, -- +16 Stamina and +100 Armor (item)
    [2717] = { name = "Might of the Scourge", lvl = 60, item = 23548, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26, ITEM_MOD_CRIT_RATING_SHORT = 14 } }, -- +26 Attack Power and +14 Critical Strike Rating (item)
    [2721] = { name = "Power of the Scourge", lvl = 60, item = 23545, stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 14, ITEM_MOD_SPELL_POWER_SHORT = 15 } }, -- +15 Spell Damage and +14 Spell Critical Rating (item)
    [1950] = { name = "Defense", lvl = 58, spell = 46594, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 15 } }, -- +15 Defense Rating (Enchanting)
    [2661] = { name = "Exceptional Stats", lvl = 56, spell = 27960, stats = { ITEM_MOD_AGILITY_SHORT = 6, ITEM_MOD_INTELLECT_SHORT = 6, ITEM_MOD_SPIRIT_SHORT = 6, ITEM_MOD_STAMINA_SHORT = 6, ITEM_MOD_STRENGTH_SHORT = 6 } }, -- +6 All Stats (Enchanting)
    [2933] = { name = "Major Resilience", lvl = 56, spell = 33992, stats = { ITEM_MOD_RESILIENCE_RATING_SHORT = 15 } }, -- +15 Resilience Rating (Enchanting)
    [2793] = { name = "Vindicator's Armor Kit", lvl = 55, item = 25651, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 8 } }, -- +8 Defense Rating (item)
    [2794] = { name = "Magister's Armor Kit", lvl = 55, item = 25652, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 3 } }, -- +3 Mana restored per 5 seconds (item)
    [1144] = { name = "Major Spirit (+15 Spirit)", lvl = 53, spell = 33990, showStats = true, stats = { ITEM_MOD_SPIRIT_SHORT = 15 } }, -- +15 Spirit (Enchanting)
    [2503] = { name = "Core Armor Kit", lvl = 50, item = 18251, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 5 } }, -- +5 Defense Rating (item)
    [2792] = { name = "Knothide Armor Kit", lvl = 50, item = 25650, stats = { ITEM_MOD_STAMINA_SHORT = 8 } }, -- +8 Stamina (item)
    [1891] = { name = "Greater Stats", lvl = 48, spell = 20025, stats = { ITEM_MOD_AGILITY_SHORT = 4, ITEM_MOD_INTELLECT_SHORT = 4, ITEM_MOD_SPIRIT_SHORT = 4, ITEM_MOD_STAMINA_SHORT = 4, ITEM_MOD_STRENGTH_SHORT = 4 } }, -- +4 All Stats (Enchanting)
    [3150] = { name = "Restore Mana Prime", lvl = 48, spell = 33991, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 6 } }, -- +6 mana every 5 sec. (Enchanting)
    [1843] = { name = "Rugged Armor Kit", lvl = 40, item = 15564, stats = { ITEM_MOD_ARMOR_SHORT = 40 } }, -- Reinforced (+40 Armor) (item)
    [928] = { name = "Stats", lvl = 39, spell = 13941, stats = { ITEM_MOD_AGILITY_SHORT = 3, ITEM_MOD_INTELLECT_SHORT = 3, ITEM_MOD_SPIRIT_SHORT = 3, ITEM_MOD_STAMINA_SHORT = 3, ITEM_MOD_STRENGTH_SHORT = 3 } }, -- +3 All Stats (Enchanting)
    [18] = { name = "Thick Armor Kit", lvl = 30, item = 8173, stats = { ITEM_MOD_ARMOR_SHORT = 32 } }, -- Reinforced (+32 Armor) (item)
    [866] = { name = "Lesser Stats", lvl = 30, spell = 13700, stats = { ITEM_MOD_AGILITY_SHORT = 2, ITEM_MOD_INTELLECT_SHORT = 2, ITEM_MOD_SPIRIT_SHORT = 2, ITEM_MOD_STAMINA_SHORT = 2, ITEM_MOD_STRENGTH_SHORT = 2 } }, -- +2 All Stats (Enchanting)
    [847] = { name = "Minor Stats", lvl = 21, spell = 13626, stats = { ITEM_MOD_AGILITY_SHORT = 1, ITEM_MOD_INTELLECT_SHORT = 1, ITEM_MOD_SPIRIT_SHORT = 1, ITEM_MOD_STAMINA_SHORT = 1, ITEM_MOD_STRENGTH_SHORT = 1 } }, -- +1 All Stats (Enchanting)
    [17] = { name = "Heavy Armor Kit", lvl = 20, item = 4265, stats = { ITEM_MOD_ARMOR_SHORT = 24 } }, -- Reinforced (+24 Armor) (item)
    [16] = { name = "Medium Armor Kit", lvl = 5, item = 2313, stats = { ITEM_MOD_ARMOR_SHORT = 16 } }, -- Reinforced (+16 Armor) (item)
    [15] = { name = "Light Armor Kit", lvl = 1, item = 2304, stats = { ITEM_MOD_ARMOR_SHORT = 8 } }, -- Reinforced (+8 Armor) (item)
    [2745] = { name = "Silver Spellthread", lvl = 60, item = 24275, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 46, ITEM_MOD_SPELL_POWER_SHORT = 16, ITEM_MOD_STAMINA_SHORT = 15 } }, -- +46 Healing +16 Spell Damage and +15 Stamina (item)
    [2746] = { name = "Golden Spellthread", lvl = 60, item = 24276, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 66, ITEM_MOD_SPELL_POWER_SHORT = 22, ITEM_MOD_STAMINA_SHORT = 20 } }, -- +66 Healing +22 Spell Damage and +20 Stamina (item)
    [2747] = { name = "Mystic Spellthread", lvl = 60, item = 24273, stats = { ITEM_MOD_SPELL_POWER_SHORT = 25, ITEM_MOD_STAMINA_SHORT = 15 } }, -- +25 Spell Damage and +15 Stamina (item)
    [2748] = { name = "Runic Spellthread", lvl = 60, item = 24274, stats = { ITEM_MOD_SPELL_POWER_SHORT = 35, ITEM_MOD_STAMINA_SHORT = 20 } }, -- +35 Spell Damage and +20 Stamina (item)
    [3010] = { name = "Cobrahide Leg Armor", lvl = 60, item = 29533, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 40, ITEM_MOD_CRIT_RATING_SHORT = 10 } }, -- +40 Attack Power and +10 Critical Strike Rating (item)
    [3011] = { name = "Clefthide Leg Armor", lvl = 60, item = 29534, stats = { ITEM_MOD_AGILITY_SHORT = 10, ITEM_MOD_STAMINA_SHORT = 30 } }, -- +30 Stamina and +10 Agility (item)
    [3012] = { name = "Nethercobra Leg Armor", lvl = 60, item = 29535, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 50, ITEM_MOD_CRIT_RATING_SHORT = 12 } }, -- +50 Attack Power and +12 Critical Strike Rating (item)
    [3013] = { name = "Nethercleft Leg Armor", lvl = 60, item = 29536, stats = { ITEM_MOD_AGILITY_SHORT = 12, ITEM_MOD_STAMINA_SHORT = 40 } }, -- +40 Stamina and +12 Agility (item)
    [2658] = { name = "Surefooted", lvl = 59, spell = 27954, stats = { ITEM_MOD_HIT_RATING_SHORT = 10 } }, -- Surefooted (Enchanting)
    [2939] = { name = "Cat's Swiftness", lvl = 58, spell = 34007, stats = { ITEM_MOD_AGILITY_SHORT = 6 } }, -- Minor Speed and +6 Agility (Enchanting)
    [2940] = { name = "Boar's Speed", lvl = 58, spell = 34008, stats = { ITEM_MOD_STAMINA_SHORT = 9 } }, -- Minor Speed and +9 Stamina (Enchanting)
    [2657] = { name = "Dexterity", lvl = 55, spell = 27951, stats = { ITEM_MOD_AGILITY_SHORT = 12 } }, -- +12 Agility (Enchanting)
    [2649] = { name = "Fortitude", lvl = 53, spell = 27950, stats = { ITEM_MOD_STAMINA_SHORT = 12 } }, -- +12 Stamina (Enchanting)
    [2656] = { name = "Vitality", lvl = 49, spell = 27948, stats = { ITEM_MOD_HEALTH_REGENERATION_SHORT = 4, ITEM_MOD_MANA_REGENERATION_SHORT = 4 } }, -- Vitality (Enchanting)
    [1887] = { name = "Greater Agility (+7 Agility)", lvl = 44, spell = 20012, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 7 } }, -- +7 Agility (Enchanting)
    [929] = { name = "Greater Stamina", lvl = 39, spell = 13945, stats = { ITEM_MOD_STAMINA_SHORT = 7 } }, -- +7 Stamina (Enchanting)
    [852] = { name = "Stamina", lvl = 24, spell = 13648, stats = { ITEM_MOD_STAMINA_SHORT = 5 } }, -- +5 Stamina (Enchanting)
    [851] = { name = "Spirit", lvl = 23, spell = 13642, stats = { ITEM_MOD_SPIRIT_SHORT = 5 } }, -- +5 Spirit (Enchanting)
    [849] = { name = "Lesser Agility", lvl = 22, spell = 13637, stats = { ITEM_MOD_AGILITY_SHORT = 3 } }, -- +3 Agility (Enchanting)
    [724] = { name = "Lesser Stamina", lvl = 17, spell = 13501, stats = { ITEM_MOD_STAMINA_SHORT = 3 } }, -- +3 Stamina (Enchanting)
    [255] = { name = "Lesser Spirit", lvl = 13, requires2H = true, spell = 13380, stats = { ITEM_MOD_SPIRIT_SHORT = 3 } }, -- +3 Spirit (Enchanting)
    [2650] = { name = "Spellpower", lvl = 58, spell = 27917, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15 } }, -- +15 Spell Damage (Enchanting)
    [2679] = { name = "Restore Mana Prime", lvl = 55, spell = 27913, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 6 } }, -- 6 Mana per 5 Sec. (Enchanting)
    [2648] = { name = "Major Defense", lvl = 53, spell = 27906, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 12 } }, -- +12 Defense Rating (Enchanting)
    [369] = { name = "Major Intellect (+12 Intellect)", lvl = 49, spell = 34001, showStats = true, stats = { ITEM_MOD_INTELLECT_SHORT = 12 } }, -- +12 Intellect (Enchanting)
    [2647] = { name = "Brawn", lvl = 49, spell = 27899, stats = { ITEM_MOD_STRENGTH_SHORT = 12 } }, -- +12 Strength (Enchanting)
    [1593] = { name = "Assault (+24 Attack Power)", lvl = 48, spell = 34002, showStats = true, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 24 } }, -- +24 Attack Power (Enchanting)
    [1885] = { name = "Superior Strength", lvl = 48, spell = 20010, stats = { ITEM_MOD_STRENGTH_SHORT = 9 } }, -- +9 Strength (Enchanting)
    [1886] = { name = "Superior Stamina", lvl = 48, spell = 20011, stats = { ITEM_MOD_STAMINA_SHORT = 9 } }, -- +9 Stamina (Enchanting)
    [2566] = { name = "Healing Power (+24 Healing, +8 Spell Power)", lvl = 48, spell = 23802, showStats = true, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 24, ITEM_MOD_SPELL_POWER_SHORT = 8 } }, -- +24 Healing and +8 Spell Damage (Enchanting)
    [2617] = { name = "Healing Power (+30 Healing, +10 Spell Power)", lvl = 48, spell = 25079, showStats = true, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 30, ITEM_MOD_SPELL_POWER_SHORT = 10 } }, -- +30 Healing and +10 Spell Damage (Enchanting)
    [2565] = { name = "Mana Regeneration", lvl = 47, spell = 23801, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 4 } }, -- Mana Regen 4 per 5 sec. (Enchanting)
    [1884] = { name = "Superior Spirit", lvl = 44, spell = 20009, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } }, -- +9 Spirit (Enchanting)
    [1883] = { name = "Greater Intellect", lvl = 41, spell = 20008, stats = { ITEM_MOD_INTELLECT_SHORT = 7 } }, -- +7 Intellect (Enchanting)
    [927] = { name = "Greater Strength", lvl = 38, spell = 13939, stats = { ITEM_MOD_STRENGTH_SHORT = 7 } }, -- +7 Strength (Enchanting)
    [923] = { name = "Deflection", lvl = 37, spell = 13931, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 5 } }, -- +5 Defense Rating (Enchanting)
    [907] = { name = "Greater Spirit", lvl = 34, spell = 13846, stats = { ITEM_MOD_SPIRIT_SHORT = 7 } }, -- +7 Spirit (Enchanting)
    [905] = { name = "Intellect (+5 Intellect)", lvl = 32, spell = 13822, showStats = true, stats = { ITEM_MOD_INTELLECT_SHORT = 5 } }, -- +5 Intellect (Enchanting)
    [856] = { name = "Strength (+5 Strength)", lvl = 26, spell = 13661, showStats = true, stats = { ITEM_MOD_STRENGTH_SHORT = 5 } }, -- +5 Strength (Enchanting)
    [925] = { name = "Lesser Deflection", lvl = 24, spell = 13646, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 3 } }, -- +3 Defense Rating (Enchanting)
    [823] = { name = "Lesser Strength", lvl = 19, spell = 13536, stats = { ITEM_MOD_STRENGTH_SHORT = 3 } }, -- +3 Strength (Enchanting)
    [723] = { name = "Lesser Intellect", lvl = 12, requires2H = true, spell = 7793, stats = { ITEM_MOD_INTELLECT_SHORT = 3 } }, -- +3 Intellect (Enchanting)
    [247] = { name = "Minor Agility", lvl = 9, spell = 7779, stats = { ITEM_MOD_AGILITY_SHORT = 1 } }, -- +1 Agility (Enchanting)
    [248] = { name = "Minor Strength", lvl = 9, spell = 7782, stats = { ITEM_MOD_STRENGTH_SHORT = 1 } }, -- +1 Strength (Enchanting)
    [243] = { name = "Minor Spirit", lvl = 7, spell = 7766, stats = { ITEM_MOD_SPIRIT_SHORT = 1 } }, -- +1 Spirit (Enchanting)
    [66] = { name = "Minor Stamina", lvl = 6, spell = 7457, stats = { ITEM_MOD_STAMINA_SHORT = 1 } }, -- +1 Stamina (Enchanting)
    [924] = { name = "Minor Deflection", lvl = 2, spell = 7428, stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 2 } }, -- +2 Defense Rating (Enchanting)
    [3260] = { name = "Glove Reinforcements", lvl = 60, item = 34207, stats = { ITEM_MOD_ARMOR_SHORT = 240 } }, -- +240 Armor (item)
    [2935] = { name = "Spell Strike", lvl = 58, spell = 33994, stats = { ITEM_MOD_HIT_SPELL_RATING_SHORT = 15 } }, -- +15 Spell Hit Rating (Enchanting)
    [2937] = { name = "Major Spellpower (+20 Spell Power)", lvl = 58, spell = 33997, showStats = true, stats = { ITEM_MOD_SPELL_POWER_SHORT = 20 } }, -- +20 Spell Damage (Enchanting)
    [2322] = { name = "Major Healing (+35 Healing, +12 Spell Power)", lvl = 57, spell = 33999, showStats = true, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 35, ITEM_MOD_SPELL_POWER_SHORT = 12 } }, -- +35 Healing Spells and +12 Damage Spells (Enchanting)
    [684] = { name = "Major Strength", lvl = 55, spell = 33995, stats = { ITEM_MOD_STRENGTH_SHORT = 15 } }, -- +15 Strength (Enchanting)
    [1594] = { name = "Assault (+26 Attack Power)", lvl = 50, spell = 33996, showStats = true, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26 } }, -- +26 Attack Power (Enchanting)
    [2934] = { name = "Blasting", lvl = 49, spell = 33993, stats = { ITEM_MOD_SPELL_CRIT_RATING_SHORT = 10 } }, -- +10 Spell Critical Strike Rating (Enchanting)
    [2614] = { name = "Shadow Power", lvl = 48, spell = 25073, stats = { ITEM_MOD_SHADOW_DAMAGE_SHORT = 20 } }, -- +20 Shadow Spell Damage (Enchanting)
    [2615] = { name = "Frost Power", lvl = 48, spell = 25074, stats = { ITEM_MOD_FROST_DAMAGE_SHORT = 20 } }, -- +20 Frost Spell Damage (Enchanting)
    [2616] = { name = "Fire Power", lvl = 48, spell = 25078, stats = { ITEM_MOD_FIRE_DAMAGE_SHORT = 20 } }, -- +20 Fire Spell Damage (Enchanting)
    [2564] = { name = "Agility (+15 Agility)", lvl = 47, spell = 23800, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 15 } }, -- +15 Agility (Enchanting)
    [931] = { name = "Minor Haste", lvl = 40, spell = 13948, stats = { ITEM_MOD_HASTE_RATING_SHORT = 10 } }, -- +10 Haste Rating (Enchanting)
    [904] = { name = "Agility (+5 Agility)", lvl = 32, spell = 13815, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 5 } }, -- +5 Agility (Enchanting)
    [368] = { name = "Greater Agility (+12 Agility)", lvl = 50, spell = 34004, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 12 } }, -- +12 Agility (Enchanting)
    [2662] = { name = "Major Armor", lvl = 50, spell = 27961, stats = { ITEM_MOD_ARMOR_SHORT = 120 } }, -- +120 Armor (Enchanting)
    [2622] = { name = "Dodge", lvl = 48, spell = 25086, stats = { ITEM_MOD_DODGE_RATING_SHORT = 12 } }, -- +12 Dodge Rating (Enchanting)
    [1889] = { name = "Superior Defense", lvl = 46, spell = 20015, stats = { ITEM_MOD_ARMOR_SHORT = 70 } }, -- +70 Armor (Enchanting)
    [884] = { name = "Greater Defense", lvl = 31, spell = 13746, stats = { ITEM_MOD_ARMOR_SHORT = 50 } }, -- +50 Armor (Enchanting)
    [744] = { name = "Lesser Protection (+20 Armor)", lvl = 14, spell = 13421, showStats = true, stats = { ITEM_MOD_ARMOR_SHORT = 20 } }, -- +20 Armor (Enchanting)
    [783] = { name = "Minor Protection", lvl = 8, spell = 7771, stats = { ITEM_MOD_ARMOR_SHORT = 10 } }, -- +10 Armor (Enchanting)
    [2671] = { name = "Sunfire", lvl = 60, spell = 27981, stats = { ITEM_MOD_ARCANE_DAMAGE_SHORT = 50, ITEM_MOD_FIRE_DAMAGE_SHORT = 50 } }, -- Sunfire (Enchanting)
    [2672] = { name = "Soulfrost", lvl = 60, spell = 27982, stats = { ITEM_MOD_FROST_DAMAGE_SHORT = 54, ITEM_MOD_SHADOW_DAMAGE_SHORT = 54 } }, -- Soulfrost (Enchanting)
    [2673] = { name = "Mongoose", lvl = 60, spell = 27984, stats = { ITEM_MOD_AGILITY_SHORT = 48, ITEM_MOD_HASTE_RATING_SHORT = 12 } }, -- Mongoose (Enchanting)
    [3223] = { name = "Adamantite Weapon Chain", lvl = 60, item = 33185, stats = { ITEM_MOD_PARRY_RATING_SHORT = 15 } }, -- Adamantite Weapon Chain (item)
    [3225] = { name = "Executioner", lvl = 60, spell = 42974, stats = { ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = 280 } }, -- Executioner (Enchanting)
    [2670] = { name = "Major Agility", lvl = 58, spell = 27977, stats = { ITEM_MOD_AGILITY_SHORT = 35 } }, -- +35 Agility (Enchanting)
    [2674] = { name = "Spellsurge", lvl = 58, spell = 28003, stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 6 } }, -- Spellsurge (Enchanting)
    [2343] = { name = "Major Healing (+81 Healing, +27 Spell Power)", lvl = 57, spell = 34010, showStats = true, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 81, ITEM_MOD_SPELL_POWER_SHORT = 27 } }, -- +81 Healing Spells and +27 Damage Spells (Enchanting)
    [2667] = { name = "Savagery", lvl = 57, spell = 27971, stats = { ITEM_MOD_ATTACK_POWER_SHORT = 70 } }, -- Savagery (Enchanting)
    [2668] = { name = "Potency", lvl = 57, spell = 27972, stats = { ITEM_MOD_STRENGTH_SHORT = 20 } }, -- +20 Strength (Enchanting)
    [2669] = { name = "Major Spellpower (+40 Spell Power)", lvl = 57, spell = 27975, showStats = true, stats = { ITEM_MOD_SPELL_POWER_SHORT = 40 } }, -- +40 Spell Damage and Healing (Enchanting)
    [3222] = { name = "Greater Agility (+20 Agility)", lvl = 57, spell = 42620, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 20 } }, -- +20 Agility (Enchanting)
    [2666] = { name = "Major Intellect (+30 Intellect)", lvl = 55, spell = 27968, showStats = true, stats = { ITEM_MOD_INTELLECT_SHORT = 30 } }, -- +30 Intellect (Enchanting)
    [3273] = { name = "Deathfrost", lvl = 55, spell = 46578, stats = { ITEM_MOD_SPELL_POWER_SHORT = 15 } }, -- Deathfrost (Enchanting)
    [1896] = { name = "Superior Impact", lvl = 48, requires2H = true, spell = 20030, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 3.6 } }, -- +9 Weapon Damage (Enchanting)
    [1898] = { name = "Lifestealing", lvl = 48, spell = 20032, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, -- Lifestealing (Enchanting)
    [1899] = { name = "Unholy Weapon", lvl = 48, spell = 20033, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, -- Unholy Weapon (Enchanting)
    [1900] = { name = "Crusader", lvl = 48, spell = 20034, stats = { ITEM_MOD_STRENGTH_SHORT = 35 } }, -- Crusader (Enchanting)
    [1903] = { name = "Major Spirit (+9 Spirit)", lvl = 48, requires2H = true, spell = 20035, showStats = true, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } }, -- +9 Spirit (Enchanting)
    [1904] = { name = "Major Intellect (+9 Intellect)", lvl = 48, requires2H = true, spell = 20036, showStats = true, stats = { ITEM_MOD_INTELLECT_SHORT = 9 } }, -- +9 Intellect (Enchanting)
    [2504] = { name = "Spell Power", lvl = 48, spell = 22749, stats = { ITEM_MOD_SPELL_POWER_SHORT = 30 } }, -- +30 Spell Damage (Enchanting)
    [2505] = { name = "Healing Power (+55 Healing, +19 Spell Power)", lvl = 48, spell = 22750, showStats = true, stats = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 55, ITEM_MOD_SPELL_POWER_SHORT = 19 } }, -- +55 Healing and +19 Spell Damage (Enchanting)
    [2567] = { name = "Mighty Spirit", lvl = 48, spell = 23803, stats = { ITEM_MOD_SPIRIT_SHORT = 20 } }, -- +20 Spirit (Enchanting)
    [2568] = { name = "Mighty Intellect", lvl = 48, spell = 23804, stats = { ITEM_MOD_INTELLECT_SHORT = 22 } }, -- +22 Intellect (Enchanting)
    [2563] = { name = "Strength (+15 Strength)", lvl = 47, spell = 23799, showStats = true, stats = { ITEM_MOD_STRENGTH_SHORT = 15 } }, -- +15 Strength (Enchanting)
    [2646] = { name = "Agility (+25 Agility)", lvl = 47, requires2H = true, spell = 27837, showStats = true, stats = { ITEM_MOD_AGILITY_SHORT = 25 } }, -- +25 Agility (Enchanting)
    [1894] = { name = "Icy Chill", lvl = 46, spell = 20029, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1 } }, -- Icy Weapon (Enchanting)
    [803] = { name = "Fiery Weapon", lvl = 43, spell = 13898, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 3 } }, -- Fiery Weapon (Enchanting)
    [805] = { name = "Greater Striking", lvl = 39, spell = 13943, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1.6 } }, -- +4 Weapon Damage (Enchanting)
    [963] = { name = "Greater Impact", lvl = 38, requires2H = true, spell = 13937, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2.8 } }, -- +7 Weapon Damage (Enchanting)
    [34] = { name = "Iron Counterweight", lvl = 33, requires2H = true, item = 6043, stats = { ITEM_MOD_HASTE_RATING_SHORT = 20 } }, -- Counterweight (+20 Haste Rating) (item)
    [1897] = { name = "Impact", lvl = 30, requires2H = true, spell = 13695, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, -- +5 Weapon Damage (Enchanting)
    [2443] = { name = "Winter's Might", lvl = 28, spell = 21931, stats = { ITEM_MOD_FROST_DAMAGE_SHORT = 7 } }, -- +7 Frost Spell Damage (Enchanting)
    [943] = { name = "Lesser Impact", lvl = 20, requires2H = true, spell = 13529, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1.2 } }, -- +3 Weapon Damage (Enchanting)
    [241] = { name = "Minor Impact", lvl = 12, requires2H = true, spell = 7745, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.8 } }, -- +2 Weapon Damage (Enchanting)
    [250] = { name = "Minor Striking", lvl = 10, spell = 7788, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.4 } }, -- +1  Weapon Damage (Enchanting)
    [2655] = { name = "Shield Block", lvl = 55, isShield = true, spell = 27946, stats = { ITEM_MOD_BLOCK_RATING_SHORT = 15 } }, -- +15 Shield Block Rating (Enchanting)
    [3229] = { name = "Resilience", lvl = 54, isShield = true, spell = 44383, stats = { ITEM_MOD_RESILIENCE_RATING_SHORT = 12 } }, -- +12 Resilience Rating (Enchanting)
    [1071] = { name = "Major Stamina", lvl = 53, isShield = true, spell = 34009, stats = { ITEM_MOD_STAMINA_SHORT = 18 } }, -- +18 Stamina (Enchanting)
    [2654] = { name = "Intellect (+12 Intellect)", lvl = 53, isShield = true, spell = 27945, showStats = true, stats = { ITEM_MOD_INTELLECT_SHORT = 12 } }, -- +12 Intellect (Enchanting)
    [1890] = { name = "Superior Spirit", lvl = 46, isShield = true, spell = 20016, stats = { ITEM_MOD_SPIRIT_SHORT = 9 } }, -- +9 Spirit (Enchanting)
    [863] = { name = "Lesser Block", lvl = 29, isShield = true, spell = 13689, stats = { ITEM_MOD_BLOCK_RATING_SHORT = 10 } }, -- +10 Shield Block Rating (Enchanting)
    [848] = { name = "Lesser Protection (+30 Armor)", lvl = 14, isShield = true, spell = 13464, showStats = true, stats = { ITEM_MOD_ARMOR_SHORT = 30 } }, -- +30 Armor (Enchanting)
    [2724] = { name = "Stabilized Eternium Scope", lvl = 60, isScope = true, item = 23766, stats = { ITEM_MOD_CRIT_RATING_SHORT = 28 } }, -- Scope (+28 Critical Strike Rating) (item)
    [2722] = { name = "Adamantite Scope", lvl = 55, isScope = true, item = 23764, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 4 } }, -- Scope (+10 Damage) (item)
    [2723] = { name = "Khorium Scope", lvl = 55, isScope = true, item = 23765, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 4.8 } }, -- Scope (+12 Damage) (item)
    [2523] = { name = "Biznicks 247x128 Accurascope", lvl = 50, isScope = true, item = 18283, stats = { ITEM_MOD_HIT_RATING_SHORT = 30 } }, -- +30 Hit Rating (item)
    [664] = { name = "Sniper Scope", lvl = 40, isScope = true, item = 10548, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2.8 } }, -- Scope (+7 Damage) (item)
    [663] = { name = "Deadly Scope", lvl = 30, isScope = true, item = 10546, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 } }, -- Scope (+5 Damage) (item)
    [33] = { name = "Accurate Scope", lvl = 20, isScope = true, item = 4407, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1.2 } }, -- Scope (+3 Damage) (item)
    [32] = { name = "Standard Scope", lvl = 10, isScope = true, item = 4406, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.8 } }, -- Scope (+2 Damage) (item)
    [30] = { name = "Crude Scope", lvl = 5, isScope = true, item = 4405, stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 0.4 } }, -- Scope (+1 Damage) (item)
}

-- Which enchant IDs the evaluator tries for each equipment slot.
MSC.EnchantCandidates = {
    -- [[ HEAD ]]
    [1] = { 2999, 3001, 3002, 3003, 3004, 3096, 2583, 2584, 2585, 2586, 2587, 2588, 2589, 2590, 2591, 2841, 1504, 1506, 1507, 1508, 1509, 1510 },
    -- [[ SHOULDER ]]
    [3] = { 2978, 2980, 2982, 2986, 2991, 2993, 2995, 2997, 2977, 2979, 2981, 2983, 2990, 2992, 2994, 2996, 2604, 2605, 2606, 2715, 2716, 2717, 2721, 2841 },
    -- [[ CHEST ]]
    [5] = { 2841, 1950, 2661, 2933, 2793, 2794, 1144, 2503, 2792, 1891, 3150, 1843, 928, 18, 866, 847, 17, 16, 15 },
    -- [[ LEGS ]]
    [7] = { 2583, 2584, 2585, 2586, 2587, 2588, 2589, 2590, 2591, 2745, 2746, 2747, 2748, 2841, 3010, 3011, 3012, 3013, 2793, 2794, 1504, 1506, 1507, 1508, 1509, 1510, 2503, 2792, 1843, 18, 17, 16, 15 },
    -- [[ FEET ]]
    [8] = { 2841, 2658, 2939, 2940, 2657, 2793, 2794, 2649, 2503, 2792, 2656, 1887, 1843, 929, 18, 852, 851, 849, 17, 724, 255, 16, 15 },
    -- [[ WRIST ]]
    [9] = { 2650, 2679, 2648, 2649, 369, 2647, 1593, 1885, 1886, 1891, 2566, 2617, 2565, 1884, 1883, 929, 927, 923, 907, 905, 856, 852, 925, 851, 823, 724, 723, 247, 248, 243, 66, 924 },
    -- [[ HANDS ]]
    [10] = { 2841, 3260, 2935, 2937, 2322, 684, 2793, 2794, 1594, 2503, 2792, 2934, 2614, 2615, 2616, 2617, 2564, 1887, 931, 1843, 927, 904, 18, 17, 16, 15 },
    -- [[ BACK ]]
    [15] = { 2648, 368, 2662, 2622, 1889, 884, 849, 744, 247, 783 },
    -- [[ WEAPON (MAIN HAND / 2H) ]]
    [16] = { 2671, 2672, 2673, 3223, 3225, 2670, 2674, 2343, 2667, 2668, 2669, 3222, 2666, 3273, 1896, 1898, 1899, 1900, 1903, 1904, 2504, 2505, 2567, 2568, 2563, 2564, 2646, 1894, 803, 805, 963, 34, 1897, 2443, 943, 255, 241, 723, 250 },
    -- [[ OFF HAND (WEAPON OR SHIELD) ]]
    [17] = { 2671, 2672, 2673, 3223, 3225, 2670, 2674, 2343, 2667, 2668, 2669, 3222, 2655, 2666, 3273, 3229, 1071, 2654, 1898, 1899, 1900, 2504, 2505, 2567, 2568, 2563, 2564, 1890, 1894, 803, 805, 929, 963, 1897, 863, 2443, 852, 851, 943, 848, 255, 241, 250, 66 },
    -- [[ RANGED (SCOPES) ]]
    [18] = { 2724, 2722, 2723, 2523, 664, 663, 33, 32, 30 },
}
MSC.EnchantCandidates_Leveling = nil
