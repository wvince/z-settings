local _, MSC = ...

-- Stat buffs for this game version, generated from the client's spell tables
-- (TBC Anniversary 2.5.6.69795) by Research/buffs/scripts/gen_lua.py. Don't edit by hand.
-- BuffAuras: aura spell id -> what it adds (MSC.GetUnbuffedStats takes it off the
-- live stats). P = the field whose live value is read from the aura's points
-- (one aura shared by foods of different strength). BuffList: the class, aura,
-- totem and world buffs the Buff Assumptions presets can add, ranks by level.
if not MSC.IsTBC then return end

MSC.BuffAuras = {
    [465] = { ARMOR = 55 }, -- Devotion Aura (Rank 1)
    [588] = { ARMOR = 315 }, -- Inner Fire (Rank 1)
    [602] = { ARMOR = 720 }, -- Inner Fire (Rank 3)
    [643] = { ARMOR = 275 }, -- Devotion Aura (Rank 3)
    [673] = { ARMOR = 50 }, -- Oil of Olaf
    [1006] = { ARMOR = 945 }, -- Inner Fire (Rank 4)
    [1032] = { ARMOR = 505 }, -- Devotion Aura (Rank 5)
    [1126] = { ARMOR = 25 }, -- Mark of the Wild (Rank 1)
    [1243] = { STA = 3 }, -- Power Word: Fortitude (Rank 1)
    [1244] = { STA = 8 }, -- Power Word: Fortitude (Rank 2)
    [1245] = { STA = 20 }, -- Power Word: Fortitude (Rank 3)
    [1459] = { INT = 2 }, -- Arcane Intellect (Rank 1)
    [1460] = { INT = 7 }, -- Arcane Intellect (Rank 2)
    [1461] = { INT = 15 }, -- Arcane Intellect (Rank 3)
    [2048] = { AP = 305 }, -- Battle Shout (Rank 8)
    [2367] = { STR = 4 }, -- Elixir of Lion's Strength
    [2374] = { AGI = 4 }, -- Elixir of Minor Agility
    [2791] = { STA = 32 }, -- Power Word: Fortitude (Rank 4)
    [2895] = { SP = 101, HEAL = 101 }, -- Wrath of Air Totem (Rank 1)
    [3160] = { AGI = 8 }, -- Elixir of Lesser Agility
    [3164] = { STR = 8 }, -- Elixir of Ogre's Strength
    [3166] = { INT = 6 }, -- Elixir of Wisdom
    [3220] = { ARMOR = 150 }, -- Elixir of Defense
    [4318] = { AGI = 12 }, -- Call of the Raptor
    [5020] = { STR = 4, INT = -5 }, -- Stormstout
    [5021] = { SPI = -4 }, -- Trogg Brew
    [5232] = { ALL = 2, ARMOR = 65 }, -- Mark of the Wild (Rank 2)
    [5234] = { ALL = 6, ARMOR = 150 }, -- Mark of the Wild (Rank 4)
    [5242] = { AP = 35 }, -- Battle Shout (Rank 2)
    [5257] = { STA = 3 }, -- Keg of Thunderbrew
    [5909] = { STA = -1, SPI = 1 }, -- Well Fed: Watered-down Beer
    [6114] = { STA = -5, INT = 4 }, -- Well Fed: Raptor Punch
    [6192] = { AP = 55 }, -- Battle Shout (Rank 3)
    [6307] = { STA = 2 }, -- Blood Pact (Rank 1)
    [6562] = { HIT = 1 }, -- Heroic Presence
    [6673] = { AP = 15 }, -- Battle Shout (Rank 1)
    [6756] = { ALL = 4, ARMOR = 105 }, -- Mark of the Wild (Rank 3)
    [7128] = { ARMOR = 495 }, -- Inner Fire (Rank 2)
    [7804] = { STA = 7 }, -- Blood Pact (Rank 2)
    [7805] = { STA = 16 }, -- Blood Pact (Rank 3)
    [7844] = { SP_FIRE = 10 }, -- Elixir of Firepower
    [8076] = { STR = 10 }, -- Strength of Earth Totem (Rank 1)
    [8091] = { ARMOR = 60 }, -- Scroll of Protection (Rank 1)
    [8094] = { ARMOR = 120 }, -- Scroll of Protection (Rank 2)
    [8095] = { ARMOR = 180 }, -- Scroll of Protection (Rank 3)
    [8096] = { INT = 4 }, -- Scroll of Intellect (Rank 1)
    [8097] = { INT = 8 }, -- Scroll of Intellect (Rank 2)
    [8098] = { INT = 12 }, -- Scroll of Intellect (Rank 3)
    [8099] = { STA = 4 }, -- Scroll of Stamina (Rank 1)
    [8100] = { STA = 8 }, -- Scroll of Stamina (Rank 2)
    [8101] = { STA = 12 }, -- Scroll of Stamina (Rank 3)
    [8112] = { SPI = 3 }, -- Scroll of Spirit (Rank 1)
    [8113] = { SPI = 7 }, -- Scroll of Spirit (Rank 2)
    [8114] = { SPI = 11 }, -- Scroll of Spirit (Rank 3)
    [8115] = { AGI = 5 }, -- Scroll of Agility (Rank 1)
    [8116] = { AGI = 9 }, -- Scroll of Agility (Rank 2)
    [8117] = { AGI = 13 }, -- Scroll of Agility (Rank 3)
    [8118] = { STR = 5 }, -- Scroll of Strength (Rank 1)
    [8119] = { STR = 9 }, -- Scroll of Strength (Rank 2)
    [8120] = { STR = 13 }, -- Scroll of Strength (Rank 3)
    [8162] = { STR = 20 }, -- Strength of Earth Totem (Rank 2)
    [8163] = { STR = 36 }, -- Strength of Earth Totem (Rank 3)
    [8212] = { STR = 8 }, -- Elixir of Giant Growth
    [8733] = { INT = 5, SPI = 5, SP_FROST = 15 }, -- Blessing of Blackfathom
    [8836] = { AGI = 43 }, -- Grace of Air Totem (Rank 1)
    [8907] = { ALL = 8, ARMOR = 195 }, -- Mark of the Wild (Rank 5)
    [9884] = { ALL = 10, ARMOR = 240 }, -- Mark of the Wild (Rank 6)
    [9885] = { ALL = 12, ARMOR = 285 }, -- Mark of the Wild (Rank 7)
    [10156] = { INT = 22 }, -- Arcane Intellect (Rank 4)
    [10157] = { INT = 31 }, -- Arcane Intellect (Rank 5)
    [10290] = { ARMOR = 160 }, -- Devotion Aura (Rank 2)
    [10291] = { ARMOR = 390 }, -- Devotion Aura (Rank 4)
    [10292] = { ARMOR = 620 }, -- Devotion Aura (Rank 6)
    [10293] = { ARMOR = 735 }, -- Devotion Aura (Rank 7)
    [10441] = { STR = 61 }, -- Strength of Earth Totem (Rank 4)
    [10626] = { AGI = 67 }, -- Grace of Air Totem (Rank 2)
    [10667] = { STR = 25 }, -- R.O.I.D.S.
    [10668] = { STA = 25 }, -- Lung Juice Cocktail
    [10669] = { AGI = 25 }, -- Ground Scorpok Assay
    [10692] = { INT = 25 }, -- Cerebral Cortex Compound
    [10693] = { SPI = 25 }, -- Gizzard Gum
    [10937] = { STA = 43 }, -- Power Word: Fortitude (Rank 5)
    [10938] = { STA = 54 }, -- Power Word: Fortitude (Rank 6)
    [10951] = { ARMOR = 1170 }, -- Inner Fire (Rank 5)
    [10952] = { ARMOR = 1395 }, -- Inner Fire (Rank 6)
    [11328] = { AGI = 15 }, -- Elixir of Agility
    [11334] = { AGI = 25 }, -- Elixir of Greater Agility
    [11348] = { ARMOR = 450 }, -- Elixir of Superior Defense
    [11349] = { ARMOR = 250 }, -- Elixir of Greater Defense
    [11390] = { SP = 20 }, -- Arcane Elixir
    [11396] = { INT = 25 }, -- Elixir of Greater Intellect
    [11405] = { STR = 25 }, -- Elixir of Giants
    [11474] = { SP_SHADOW = 40 }, -- Elixir of Shadow Power
    [11549] = { AP = 85 }, -- Battle Shout (Rank 4)
    [11550] = { AP = 130 }, -- Battle Shout (Rank 5)
    [11551] = { AP = 185 }, -- Battle Shout (Rank 6)
    [11766] = { STA = 27 }, -- Blood Pact (Rank 4)
    [11767] = { STA = 38 }, -- Blood Pact (Rank 5)
    [12174] = { AGI = 17 }, -- Scroll of Agility (Rank 4)
    [12175] = { ARMOR = 240 }, -- Scroll of Protection (Rank 4)
    [12176] = { INT = 16 }, -- Scroll of Intellect (Rank 4)
    [12177] = { SPI = 15 }, -- Scroll of Spirit (Rank 4)
    [12178] = { STA = 16 }, -- Scroll of Stamina (Rank 4)
    [12179] = { STR = 17 }, -- Scroll of Strength (Rank 4)
    [13165] = { RAP = 20 }, -- Aspect of the Hawk (Rank 1)
    [14318] = { RAP = 35 }, -- Aspect of the Hawk (Rank 2)
    [14319] = { RAP = 50 }, -- Aspect of the Hawk (Rank 3)
    [14320] = { RAP = 70 }, -- Aspect of the Hawk (Rank 4)
    [14321] = { RAP = 90 }, -- Aspect of the Hawk (Rank 5)
    [14322] = { RAP = 110 }, -- Aspect of the Hawk (Rank 6)
    [14752] = { SPI = 17 }, -- Divine Spirit (Rank 1)
    [14818] = { SPI = 23 }, -- Divine Spirit (Rank 2)
    [14819] = { SPI = 33 }, -- Divine Spirit (Rank 3)
    [15231] = { SPI = 30 }, -- Crystal Force
    [15233] = { ARMOR = 200 }, -- Crystal Ward
    [15366] = { ALL = 15 }, -- Songflower Serenade
    [16323] = { STR = 30 }, -- Juju Power
    [16327] = { INT = 30 }, -- Juju Guile
    [16329] = { AP = 40, RAP = 40 }, -- Juju Might
    [17038] = { AP = 35, RAP = 35 }, -- Winterfall Firewater
    [17535] = { INT = 18, SPI = 18 }, -- Elixir of the Sages
    [17537] = { STR = 18, STA = 18 }, -- Elixir of Brute Force
    [17538] = { AGI = 25 }, -- Elixir of the Mongoose
    [17539] = { SP = 35 }, -- Greater Arcane Elixir
    [17627] = { INT = 65 }, -- Flask of Distilled Wisdom
    [17628] = { SP = 70 }, -- Flask of Supreme Power
    [18125] = { STR = 10 }, -- Well Fed: Blessed Sunfruit
    [18141] = { SPI = 10 }, -- Blessed Sunfruit Juice
    [18191] = { STA = 10 }, -- Well Fed: Cooked Glossy Mightfish, Dried Fruit Rations, Dried Mushroom Rations +3 more
    [18192] = { AGI = 10 }, -- Well Fed: Grilled Squid
    [18193] = { SPI = 10 }, -- Well Fed: Hot Smoked Bass, Marsh Lichen
    [19506] = { AP = 50, RAP = 50 }, -- Trueshot Aura (Rank 1)
    [19705] = { STA = 2, SPI = 2 }, -- Well Fed: Bad Egg Nog, Beer Basted Boar Ribs, Cactus Apple Surprise +14 more
    [19706] = { STA = 4, SPI = 4 }, -- Well Fed: Bat Bites, Blood Sausage, Boiled Clams +9 more
    [19708] = { STA = 6, SPI = 6 }, -- Well Fed: Big Bear Steak, Crispy Lizard Tail, Crocolisk Gumbo +10 more
    [19709] = { STA = 8, SPI = 8 }, -- Well Fed: Barbecued Buzzard Wing, Carrion Surprise, Giant Clam Scorcho +9 more
    [19710] = { STA = 12, SPI = 12 }, -- Well Fed: Clamlette Surprise, Heavy Kodo Stew, Savory Sausage +4 more
    [19711] = { STA = 14, SPI = 14 }, -- Well Fed: Bonestripper Buzzard Hotwings, Edible Fern, Pickled Sausage
    [19740] = { AP = 20, RAP = 20 }, -- Blessing of Might (Rank 1)
    [19834] = { AP = 35, RAP = 35 }, -- Blessing of Might (Rank 2)
    [19835] = { AP = 55, RAP = 55 }, -- Blessing of Might (Rank 3)
    [19836] = { AP = 85, RAP = 85 }, -- Blessing of Might (Rank 4)
    [19837] = { AP = 115, RAP = 115 }, -- Blessing of Might (Rank 5)
    [19838] = { AP = 155, RAP = 155 }, -- Blessing of Might (Rank 6)
    [20217] = { ALL_PCT = 10 }, -- Blessing of Kings
    [20875] = { STA = 10 }, -- Rumsey Rum
    [20905] = { AP = 75, RAP = 75 }, -- Trueshot Aura (Rank 2)
    [20906] = { AP = 100, RAP = 100 }, -- Trueshot Aura (Rank 3)
    [21562] = { STA = 43 }, -- Prayer of Fortitude (Rank 1)
    [21564] = { STA = 54 }, -- Prayer of Fortitude (Rank 2)
    [21849] = { ALL = 10, ARMOR = 240 }, -- Gift of the Wild (Rank 1)
    [21850] = { ALL = 12, ARMOR = 285 }, -- Gift of the Wild (Rank 2)
    [21920] = { SP_FROST = 15 }, -- Elixir of Frost Power
    [22730] = { INT = 10 }, -- Well Fed: Runn Tum Tuber Surprise
    [22789] = { STA = 10 }, -- Gordok Green Grog
    [22790] = { INT = -5, SPI = 25 }, -- Kreeg's Stout Beatdown
    [22817] = { AP = 200, RAP = 200 }, -- Fengus' Ferocity
    [22818] = { STA_PCT = 15 }, -- Mol'dar's Moxie
    [22888] = { AP = 140, RAP = 140 }, -- Rallying Cry of the Dragonslayer
    [23028] = { INT = 31 }, -- Arcane Brilliance (Rank 1)
    [23697] = { SPI = 10 }, -- Bottled Alterac Spring Water
    [23735] = { STR_PCT = 10 }, -- Sayge's Dark Fortune of Strength
    [23736] = { AGI_PCT = 10 }, -- Sayge's Dark Fortune of Agility
    [23737] = { STA_PCT = 10 }, -- Sayge's Dark Fortune of Stamina
    [23738] = { SPI_PCT = 10 }, -- Sayge's Dark Fortune of Spirit
    [23766] = { INT_PCT = 10 }, -- Sayge's Dark Fortune of Intelligence
    [24382] = { STA = 25, SPI = 25 }, -- Spirit of Zanza
    [24425] = { ALL = 50, ALL_PCT = 15 }, -- Spirit of Zandalar
    [24799] = { STR = 20 }, -- Well Fed: Helboar Bacon, Smoked Desert Dumplings
    [25037] = { STA = 5 }, -- Well Fed: Rumsey Rum Light
    [25289] = { AP = 232 }, -- Battle Shout (Rank 7)
    [25291] = { AP = 185, RAP = 185 }, -- Blessing of Might (Rank 7)
    [25296] = { RAP = 120 }, -- Aspect of the Hawk (Rank 7)
    [25312] = { SPI = 50 }, -- Divine Spirit (Rank 5)
    [25360] = { AGI = 77 }, -- Grace of Air Totem (Rank 3)
    [25362] = { STR = 77 }, -- Strength of Earth Totem (Rank 5)
    [25389] = { STA = 79 }, -- Power Word: Fortitude (Rank 7)
    [25392] = { STA = 79 }, -- Prayer of Fortitude (Rank 3)
    [25431] = { ARMOR = 1580 }, -- Inner Fire (Rank 7)
    [25527] = { STR = 86 }, -- Strength of Earth Totem (Rank 6)
    [25661] = { STA = 25 }, -- Well Fed: Dirge's Kickin' Chimaerok Chops
    [25722] = { STA = 10 }, -- Well Fed: Rumsey Rum Dark
    [25782] = { AP = 155, RAP = 155 }, -- Greater Blessing of Might (Rank 1)
    [25804] = { STA = 15 }, -- Well Fed: Rumsey Rum Black Label
    [25898] = { ALL_PCT = 10 }, -- Greater Blessing of Kings
    [25916] = { AP = 185, RAP = 185 }, -- Greater Blessing of Might (Rank 2)
    [26004] = { SPI = 20 }, -- Mistletoe
    [26008] = { STA = 20 }, -- Toasting Goblet
    [26276] = { SP_FIRE = 40 }, -- Elixir of Greater Firepower
    [26990] = { ALL = 14, ARMOR = 340 }, -- Mark of the Wild (Rank 8)
    [26991] = { ALL = 14, ARMOR = 340 }, -- Gift of the Wild (Rank 3)
    [27044] = { RAP = 155 }, -- Aspect of the Hawk (Rank 8)
    [27066] = { AP = 125, RAP = 125 }, -- Trueshot Aura (Rank 4)
    [27126] = { INT = 40 }, -- Arcane Intellect (Rank 6)
    [27127] = { INT = 40 }, -- Arcane Brilliance (Rank 2)
    [27140] = { AP = 220, RAP = 220 }, -- Blessing of Might (Rank 8)
    [27141] = { AP = 220, RAP = 220 }, -- Greater Blessing of Might (Rank 3)
    [27149] = { ARMOR = 861 }, -- Devotion Aura (Rank 8)
    [27268] = { STA = 66 }, -- Blood Pact (Rank 6)
    [27664] = { INT = 30 }, -- Sack of Homemade Bread
    [27665] = { STA = 30 }, -- Ironforge Pledge Collection
    [27666] = { AGI = 30 }, -- Stack of Cards
    [27669] = { AGI = 30 }, -- Box of Fresh Pies
    [27670] = { STA = 30 }, -- Satchel of Cards
    [27671] = { INT = 30 }, -- Book of Romantic Poems
    [27681] = { SPI = 40 }, -- Prayer of Spirit (Rank 1)
    [27721] = { SP = 23 }, -- Very Berry Cream
    [27722] = { HEAL = 44 }, -- Sweet Surprise
    [27841] = { SPI = 40 }, -- Divine Spirit (Rank 4)
    [28273] = { SP = 10, HEAL = 10 }, -- Bloodthistle Petal
    [28490] = { STR = 35 }, -- Elixir of Major Strength
    [28491] = { HEAL = 50 }, -- Elixir of Healing Power
    [28493] = { SP_FROST = 55 }, -- Elixir of Major Frost Power
    [28497] = { AGI = 35 }, -- Elixir of Major Agility
    [28501] = { SP_FIRE = 55 }, -- Elixir of Major Firepower
    [28502] = { ARMOR = 550 }, -- Elixir of Major Defense
    [28503] = { SP_SHADOW = 55 }, -- Elixir of Major Shadow Power
    [28520] = { AP = 120, RAP = 120 }, -- Flask of Relentless Assault
    [28521] = { SP_HOLY = 80, SP_NATURE = 80, SP_ARCANE = 80 }, -- Flask of Blinding Light
    [28540] = { SP_FIRE = 80, SP_FROST = 80, SP_SHADOW = 80 }, -- Flask of Pure Death
    [28878] = { SPELL_HIT = 1 }, -- Inspiring Presence
    [29006] = { STA = 20 }, -- Bubbly Beverage
    [29333] = { SP = 23 }, -- Midsummer Sausage
    [29334] = { HEAL = 44 }, -- Toasted Smorc
    [30088] = { STA = 1 }, -- Lesser Mark of the Dawn
    [30089] = { STA = 2 }, -- Mark of the Dawn
    [30090] = { STA = 3 }, -- Greater Mark of the Dawn
    [30164] = { STA = 25 }, -- Permanent Lung Juice Cocktail
    [30173] = { AGI = 25 }, -- Permanent Ground Scorpok Assay
    [30175] = { INT = 25 }, -- Permanent Cerebral Cortex Compound
    [30177] = { SPI = 25 }, -- Permanent Gizzard Gum
    [30178] = { STR = 25 }, -- Permanent R.O.I.D.S.
    [30336] = { STA = 50, SPI = 50 }, -- Permanent Spirit of Zanza
    [30708] = { SPELL_HIT = 3 }, -- Totem of Wrath (Rank 1)
    [30803] = { AP_PCT = 2 }, -- Unleashed Rage (Rank 1)
    [30804] = { AP_PCT = 4 }, -- Unleashed Rage (Rank 2)
    [30805] = { AP_PCT = 6 }, -- Unleashed Rage (Rank 3)
    [30806] = { AP_PCT = 8 }, -- Unleashed Rage (Rank 4)
    [30807] = { AP_PCT = 10 }, -- Unleashed Rage (Rank 5)
    [30845] = { STA = 5 }, -- Crystal of Vitality
    [30847] = { INT = 5 }, -- Crystal of Insight
    [30848] = { AP = 10 }, -- Crystal of Ferocity
    [32999] = { SPI = 50 }, -- Prayer of Spirit (Rank 2)
    [33077] = { AGI = 20 }, -- Scroll of Agility (Rank 5)
    [33078] = { INT = 20 }, -- Scroll of Intellect (Rank 5)
    [33079] = { ARMOR = 300 }, -- Scroll of Protection (Rank 5)
    [33080] = { SPI = 30 }, -- Scroll of Spirit (Rank 5)
    [33081] = { STA = 20 }, -- Scroll of Stamina (Rank 5)
    [33082] = { STR = 20 }, -- Scroll of Strength (Rank 5)
    [33254] = { STA = 20, SPI = 20 }, -- Well Fed: Buzzard Bites, Clam Bar, Feltail Delight +1 more
    [33256] = { STR = 20, SPI = 20 }, -- Well Fed: Oronok's Tuber of Strength, Roasted Clefthoof
    [33257] = { STA = 30, SPI = 20 }, -- Well Fed: Fisherman's Feast, Spicy Crawdad
    [33259] = { SPI = 20, AP = 40, RAP = 40 }, -- Well Fed: Ravager Dog
    [33261] = { AGI = 20, SPI = 20 }, -- Well Fed: Grilled Mudfish, Oronok's Tuber of Agility, Warp Burger
    [33263] = { SPI = 20, SP = 23 }, -- Well Fed: Blackened Basilisk, Crunchy Serpent, Oronok's Tuber of Spell Power +1 more
    [33265] = { STA = 20 }, -- Well Fed: Blackened Sporefish
    [33268] = { SPI = 20, HEAL = 44 }, -- Well Fed: Golden Fish Sticks, Oronok's Tuber of Healing
    [33272] = { STA = 20, SPI = 20 }, -- Well Fed: Sporeling Snack
    [33720] = { AP = 60, RAP = 60 }, -- Onslaught Elixir
    [33721] = { SP = 24, HEAL = 24 }, -- Adept's Elixir
    [33726] = { ALL = 15 }, -- Elixir of Mastery
    [35272] = { STA = 20, SPI = 20 }, -- Well Fed: Honeyed Holiday Ham, Mok'Nathal Shortribs, Talbuk Steak +1 more
    [37058] = { STA = 20 }, -- Halaani Whiskey
    [38954] = { STA = -10, AP = 90, RAP = 90 }, -- Fel Strength Elixir
    [39627] = { INT = 30, SPI = 30 }, -- Elixir of Draenic Wisdom
    [40577] = { AGI = 20, STA = 30, AP = 40, RAP = 40 }, -- Unstable Flask of the Bandit
    [40580] = { STR = 20, AGI = 20, STA = 30 }, -- Unstable Flask of the Beast
    [40582] = { STA = 30, INT = 20 }, -- Unstable Flask of the Elder
    [40586] = { STA = 30, INT = 20, HEAL = 44 }, -- Unstable Flask of the Physician
    [40587] = { STR = 20, STA = 30 }, -- Unstable Flask of the Soldier
    [40588] = { STA = 30, INT = 20, SP = 23, HEAL = 23 }, -- Unstable Flask of the Sorcerer
    [41604] = { SP = 70 }, -- Shattrath Flask of Supreme Power
    [41606] = { AP = 120, RAP = 120 }, -- Shattrath Flask of Relentless Assault
    [42293] = { STA = 15, SPI = 15 }, -- Well Fed: Skyguard Rations
    [42735] = { ALL = 18 }, -- Flask of Chromatic Wonder
    [43722] = { SPI = 20 }, -- Well Fed: Skullfish Soup
    [43764] = { SPI = 20 }, -- Well Fed: Spicy Hot Talbuk
    [43771] = { STR = 20, SPI = 20 }, -- Well Fed: Kibler's Bits
    [44097] = { STA = 2, SPI = 2 }, -- Well Fed: Barleybrew Clear, Brewfest Mug 2007 (Filled, F), Small Step Brew
    [44098] = { STA = 4, SPI = 4 }, -- Well Fed: Barleybrew Light, Long Stride Brew
    [44099] = { STA = 6, SPI = 6 }, -- Well Fed: Barleybrew Dark, Path of Brew
    [44100] = { STA = 8, SPI = 8 }, -- Well Fed: Jungle River Water, Thunder 45
    [44101] = { STA = 12, SPI = 12 }, -- Well Fed: Brewdoo Magic, Thunderbrew Ale
    [44102] = { STA = 14, SPI = 14 }, -- Well Fed: Stout Shrunken Head, Thunderbrew Stout
    [44104] = { STA = 20, SPI = 20 }, -- Well Fed: Gordok Grog
    [44105] = { STA = 20, SPI = 20 }, -- Well Fed: Ogre Mead
    [44106] = { STR = 20, SPI = 20 }, -- Well Fed: Mudder's Milk
    [45245] = { STA = 20, SPI = 20 }, -- Well Fed: Hot Apple Cider
    [45374] = { ALL = 15 }, -- Bloodberry Elixir
    [46687] = { SP = 14, HEAL = 14 }, -- Well Fed: Juicy Bear Burger
    [46838] = { SP_FIRE = 80, SP_FROST = 80, SP_SHADOW = 80 }, -- Shattrath Flask of Pure Death
    [46840] = { SP_HOLY = 80, SP_NATURE = 80, SP_ARCANE = 80 }, -- Shattrath Flask of Blinding Light
    [46899] = { AP = 24, RAP = 24 }, -- Well Fed: Charred Bear Kabobs
    [48889] = { SP = 6 }, -- Pyroblast Cinnamon Ball
    [48891] = { HEAL = 11 }, -- Soothing Spearmint Candy
}

MSC.BuffList = {
    MARK_OF_THE_WILD = { source = "DRUID", ranks = { { 1, 1126 }, { 10, 5232 }, { 20, 6756 }, { 30, 5234 }, { 40, 8907 }, { 50, 9884 }, { 60, 9885 }, { 70, 26990 } } }, -- Mark of the Wild
    GIFT_OF_THE_WILD = { source = "DRUID", ranks = { { 50, 21849 }, { 60, 21850 }, { 70, 26991 } } }, -- Gift of the Wild
    POWER_WORD_FORTITUDE = { source = "PRIEST", ranks = { { 1, 1243 }, { 12, 1244 }, { 24, 1245 }, { 36, 2791 }, { 48, 10937 }, { 60, 10938 }, { 70, 25389 } } }, -- Power Word: Fortitude
    PRAYER_OF_FORTITUDE = { source = "PRIEST", ranks = { { 48, 21562 }, { 60, 21564 }, { 70, 25392 } } }, -- Prayer of Fortitude
    DIVINE_SPIRIT = { source = "PRIEST", ranks = { { 30, 14752 }, { 40, 14818 }, { 50, 14819 }, { 60, 27841 }, { 70, 25312 } } }, -- Divine Spirit
    PRAYER_OF_SPIRIT = { source = "PRIEST", ranks = { { 60, 27681 }, { 70, 32999 } } }, -- Prayer of Spirit
    INNER_FIRE = { source = "PRIEST", ranks = { { 12, 588 }, { 20, 7128 }, { 30, 602 }, { 40, 1006 }, { 50, 10951 }, { 60, 10952 }, { 69, 25431 } } }, -- Inner Fire
    ARCANE_INTELLECT = { source = "MAGE", ranks = { { 1, 1459 }, { 14, 1460 }, { 28, 1461 }, { 42, 10156 }, { 56, 10157 }, { 70, 27126 } } }, -- Arcane Intellect
    ARCANE_BRILLIANCE = { source = "MAGE", ranks = { { 56, 23028 }, { 70, 27127 } } }, -- Arcane Brilliance
    BLESSING_OF_MIGHT = { source = "PALADIN", ranks = { { 4, 19740 }, { 12, 19834 }, { 22, 19835 }, { 32, 19836 }, { 42, 19837 }, { 52, 19838 }, { 60, 25291 }, { 70, 27140 } } }, -- Blessing of Might
    GREATER_BLESSING_OF_MIGHT = { source = "PALADIN", ranks = { { 52, 25782 }, { 60, 25916 }, { 70, 27141 } } }, -- Greater Blessing of Might
    BLESSING_OF_KINGS = { source = "PALADIN", ranks = { { 20, 20217 } } }, -- Blessing of Kings
    GREATER_BLESSING_OF_KINGS = { source = "PALADIN", ranks = { { 60, 25898 } } }, -- Greater Blessing of Kings
    BATTLE_SHOUT = { source = "WARRIOR", ranks = { { 1, 6673 }, { 12, 5242 }, { 22, 6192 }, { 32, 11549 }, { 42, 11550 }, { 52, 11551 }, { 60, 25289 }, { 69, 2048 } } }, -- Battle Shout
    ASPECT_OF_THE_HAWK = { source = "HUNTER", ranks = { { 10, 13165 }, { 18, 14318 }, { 28, 14319 }, { 38, 14320 }, { 48, 14321 }, { 58, 14322 }, { 60, 25296 }, { 68, 27044 } } }, -- Aspect of the Hawk
    TRUESHOT_AURA = { source = "HUNTER", ranks = { { 40, 19506 }, { 50, 20905 }, { 60, 20906 }, { 70, 27066 } } }, -- Trueshot Aura
    DEVOTION_AURA = { source = "PALADIN", ranks = { { 1, 465 }, { 10, 10290 }, { 20, 643 }, { 30, 10291 }, { 40, 1032 }, { 50, 10292 }, { 60, 10293 }, { 70, 27149 } } }, -- Devotion Aura
    BLOOD_PACT = { source = "WARLOCK", ranks = { { 4, 6307 }, { 14, 7804 }, { 26, 7805 }, { 38, 11766 }, { 50, 11767 }, { 62, 27268 } } }, -- Blood Pact
    STRENGTH_OF_EARTH_TOTEM = { source = "SHAMAN", ranks = { { 10, 8076 }, { 24, 8162 }, { 38, 8163 }, { 52, 10441 }, { 60, 25362 }, { 65, 25527 } } }, -- Strength of Earth Totem
    GRACE_OF_AIR_TOTEM = { source = "SHAMAN", ranks = { { 42, 8836 }, { 56, 10626 }, { 60, 25360 } } }, -- Grace of Air Totem
    TOTEM_OF_WRATH = { source = "SHAMAN", ranks = { { 50, 30708 } } }, -- Totem of Wrath
    WRATH_OF_AIR_TOTEM = { source = "SHAMAN", ranks = { { 64, 2895 } } }, -- Wrath of Air Totem
    UNLEASHED_RAGE = { source = "SHAMAN", ranks = { { 0, 30803 }, { 0, 30804 }, { 0, 30805 }, { 0, 30806 }, { 0, 30807 } } }, -- Unleashed Rage
    HEROIC_PRESENCE = { source = "DRAENEI", ranks = { { 0, 6562 } } }, -- Heroic Presence
    INSPIRING_PRESENCE = { source = "DRAENEI", ranks = { { 0, 28878 } } }, -- Inspiring Presence
    RALLYING_CRY_OF_THE_DRAGONSLAYER = { source = nil, ranks = { { 0, 22888 } } }, -- Rallying Cry of the Dragonslayer
    SPIRIT_OF_ZANDALAR = { source = nil, ranks = { { 0, 24425 } } }, -- Spirit of Zandalar
    SONGFLOWER_SERENADE = { source = nil, ranks = { { 50, 15366 } } }, -- Songflower Serenade
    FENGUS_FEROCITY = { source = nil, ranks = { { 50, 22817 } } }, -- Fengus' Ferocity
    MOL_DAR_S_MOXIE = { source = nil, ranks = { { 50, 22818 } } }, -- Mol'dar's Moxie
    BLESSING_OF_BLACKFATHOM = { source = nil, ranks = { { 0, 8733 } } }, -- Blessing of Blackfathom
    SAYGE_S_DARK_FORTUNE_OF_STRENGTH = { source = nil, ranks = { { 0, 23735 } } }, -- Sayge's Dark Fortune of Strength
    SAYGE_S_DARK_FORTUNE_OF_AGILITY = { source = nil, ranks = { { 0, 23736 } } }, -- Sayge's Dark Fortune of Agility
    SAYGE_S_DARK_FORTUNE_OF_STAMINA = { source = nil, ranks = { { 0, 23737 } } }, -- Sayge's Dark Fortune of Stamina
    SAYGE_S_DARK_FORTUNE_OF_SPIRIT = { source = nil, ranks = { { 0, 23738 } } }, -- Sayge's Dark Fortune of Spirit
    SAYGE_S_DARK_FORTUNE_OF_INTELLIGENCE = { source = nil, ranks = { { 0, 23766 } } }, -- Sayge's Dark Fortune of Intelligence
}
