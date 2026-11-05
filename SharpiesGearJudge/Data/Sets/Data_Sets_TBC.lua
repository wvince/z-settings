local _, MSC = ...

-- ============================================================================
-- TBC ANNIVERSARY ITEM SETS, SET BONUSES AND PROCS
-- ============================================================================
-- Generated from the client's own tables (wago.tools, build 2.5.6.69795:
-- ItemSet, ItemSetSpell, SpellEffect, Spell) by
-- SharpiesGearJudge-Research/sets/gen_sets.py. Rerun it after a client
-- update instead of editing the set tables by hand.
--
-- SetBonusScores entries per piece count:
--   stats = bonuses that are plain stats, in the same units as this game's items
--           (ratings; a % bonus is converted at level 70, e.g. 1% hit = 15.77). Added to the character's stat totals.
--   equiv = an ESTIMATE for a proc or class bonus the addon can't model: the
--           better of the listed stats for the current profile (Spell Power for
--           casters and healers, Attack Power for melee), scaled by the set's
--           item level and piece count. Counts toward the score only.
-- Resistance, run speed and similar utility bonuses are left unscored. The
-- comment above each entry is the client's bonus text.
-- ============================================================================
MSC.PvPDB       = MSC.PvPDB or {}
MSC.WeaponDB    = MSC.WeaponDB or {}
MSC.TrinketDB   = MSC.TrinketDB or {}
MSC.RingDB      = MSC.RingDB or {}
MSC.ClassItemDB = MSC.ClassItemDB or {}

-- Format: [SetID] = { {ItemIDs} } -- name (average item level)
MSC.SetDefinitions = {
    [1] = { {11729,11726,11728,11731,11730} }, -- The Gladiator (ilvl 57)
    [41] = { {12940,12939} }, -- Dal'Rend's Arms (ilvl 63)
    [65] = { {13218,13183} }, -- Spider's Kiss (ilvl 60)
    [81] = { {13390,13388,13391,13392,13389} }, -- The Postmaster (ilvl 61)
    [121] = { {14637,14636,14640,14638,14641} }, -- Cadaverous Garb (ilvl 61)
    [122] = { {14631,14629,14632,14633,14626} }, -- Necropile Raiment (ilvl 61)
    [123] = { {14614,14616,14615,14611,14612} }, -- Bloodmail Regalia (ilvl 61)
    [124] = { {14624,14622,14620,14623,14621} }, -- Deathbone Guardian (ilvl 61)
    [141] = { {15053,15054,15055} }, -- Volcanic Armor (ilvl 57)
    [142] = { {15056,15057,15058,21278} }, -- Stormshroud Armor (ilvl 56)
    [143] = { {15062,15063} }, -- Devilsaur Armor (ilvl 59)
    [144] = { {15066,15067} }, -- Ironfeather Armor (ilvl 56)
    [161] = { {10399,10403,10402,10401,10400} }, -- Defias Leather (ilvl 20)
    [162] = { {10412,10411,10413,10410,6473} }, -- Embrace of the Viper (ilvl 22)
    [163] = { {10329,10332,10328,10331,10330,10333} }, -- Chain of the Scarlet Crusade (ilvl 38)
    [181] = { {16685,16683,16686,16684,16687,16689,16688,16682} }, -- Magister's Regalia (ilvl 60)
    [182] = { {16696,16691,16697,16693,16692,16695,16694,16690} }, -- Vestments of the Devout (ilvl 60)
    [183] = { {16702,16703,16699,16701,16700,16704,16698,16705} }, -- Dreadmist Raiment (ilvl 60)
    [184] = { {16713,16711,16710,16721,16708,16709,16712,16707} }, -- Shadowcraft Armor (ilvl 60)
    [185] = { {16716,16715,16714,16720,16706,16718,16719,16717} }, -- Wildheart Raiment (ilvl 60)
    [186] = { {16680,16675,16681,16677,16674,16678,16679,16676} }, -- Beaststalker Armor (ilvl 60)
    [187] = { {16673,16670,16671,16667,16672,16668,16669,16666} }, -- The Elements (ilvl 60)
    [188] = { {16723,16725,16722,16726,16724,16728,16729,16727} }, -- Lightforge Armor (ilvl 60)
    [189] = { {16736,16734,16735,16730,16737,16731,16732,16733} }, -- Battlegear of Valor (ilvl 60)
    [201] = { {16802,16799,16795,16800,16801,16796,16797,16798} }, -- Arcanist Regalia (ilvl 66)
    [202] = { {16811,16813,16817,16812,16814,16816,16815,16819} }, -- Vestments of Prophecy (ilvl 66)
    [203] = { {16806,16804,16805,16810,16809,16807,16808,16803} }, -- Felheart Raiment (ilvl 66)
    [204] = { {16827,16824,16825,16820,16821,16826,16822,16823} }, -- Nightslayer Armor (ilvl 66)
    [205] = { {16828,16829,16830,16833,16831,16834,16835,16836} }, -- Cenarion Raiment (ilvl 66)
    [206] = { {16851,16849,16850,16845,16848,16852,16846,16847} }, -- Giantstalker Armor (ilvl 66)
    [207] = { {16838,16837,16840,16841,16844,16839,16842,16843} }, -- The Earthfury (ilvl 66)
    [208] = { {16858,16859,16857,16853,16860,16854,16855,16856} }, -- Lawbringer Armor (ilvl 66)
    [209] = { {16864,16861,16865,16863,16866,16867,16868,16862} }, -- Battlegear of Might (ilvl 66)
    [210] = { {16818,16918,16912,16914,16917,16913,16915,16916} }, -- Netherwind Regalia (ilvl 76)
    [211] = { {16925,16926,16919,16921,16920,16922,16924,16923} }, -- Vestments of Transcendence (ilvl 76)
    [212] = { {16933,16927,16934,16928,16930,16931,16929,16932} }, -- Nemesis Raiment (ilvl 76)
    [213] = { {16910,16906,16911,16905,16907,16908,16909,16832} }, -- Bloodfang Armor (ilvl 76)
    [214] = { {16903,16898,16904,16897,16900,16899,16901,16902} }, -- Stormrage Raiment (ilvl 76)
    [215] = { {16936,16935,16942,16940,16941,16939,16938,16937} }, -- Dragonstalker Armor (ilvl 76)
    [216] = { {16944,16943,16950,16945,16948,16949,16947,16946} }, -- The Ten Storms (ilvl 76)
    [217] = { {16952,16951,16958,16955,16956,16954,16957,16953} }, -- Judgement Armor (ilvl 76)
    [218] = { {16959,16966,16964,16963,16962,16961,16965,16960} }, -- Battlegear of Wrath (ilvl 76)
    [221] = { {7950,7948,7952,7951,7953,7949} }, -- Garb of Thero-shan (ilvl 37)
    [241] = { {17082,17064} }, -- Shard of the Gods (ilvl 72)
    [261] = { {18203,18202,18204,18205} }, -- Spirit of Eskhandar (ilvl 67)
    [281] = { {16509,16510,16513,16515,16514,16516} }, -- Champion's Battlegear (ilvl 63)
    [282] = { {16405,16406,16430,16431,16429,16432} }, -- Lieutenant Commander's Battlegear (ilvl 63)
    [301] = { {16519,16518,16522,16523,16521,16524} }, -- Champion's Earthshaker (ilvl 63)
    [321] = { {12424,12426,12425,12422,12427,12429,12428} }, -- Imperial Plate (ilvl 57)
    [341] = { {16485,16487,16491,16490,16489,16492} }, -- Champion's Regalia (ilvl 63)
    [342] = { {17616,17617,17612,17611,17613,17610} }, -- Champion's Raiment (ilvl 63)
    [343] = { {16369,16391,16413,16414,16416,16415} }, -- Lieutenant Commander's Regalia (ilvl 63)
    [344] = { {17594,17596,17600,17599,17598,17601} }, -- Lieutenant Commander's Raiment (ilvl 63)
    [345] = { {17576,17577,17572,17571,17570,17573} }, -- Champion's Threads (ilvl 63)
    [346] = { {17562,17564,17568,17567,17569,17566} }, -- Lieutenant Commander's Threads (ilvl 63)
    [347] = { {16498,16499,16505,16508,16506,16507} }, -- Champion's Vestments (ilvl 63)
    [348] = { {16392,16396,16417,16419,16420,16418} }, -- Lieutenant Commander's Vestments (ilvl 63)
    [361] = { {16531,16530,16525,16527,16526,16528} }, -- Champion's Pursuit (ilvl 63)
    [362] = { {16425,16426,16401,16403,16428,16427} }, -- Lieutenant Commander's Pursuit (ilvl 63)
    [381] = { {16423,16424,16422,16421,16393,16397} }, -- Lieutenant Commander's Sanctuary (ilvl 63)
    [382] = { {16494,16496,16504,16502,16503,16501} }, -- Champion's Sanctuary (ilvl 63)
    [383] = { {16541,16542,16544,16545,16548,16543} }, -- Warlord's Battlegear (ilvl 72)
    [384] = { {16477,16478,16480,16483,16484,16479} }, -- Field Marshal's Battlegear (ilvl 72)
    [386] = { {16577,16578,16580,16573,16574,16579} }, -- Warlord's Earthshaker (ilvl 72)
    [387] = { {16536,16533,16535,16539,16540,16534} }, -- Warlord's Regalia (ilvl 72)
    [388] = { {16441,16444,16443,16437,16440,16442} }, -- Field Marshal's Regalia (ilvl 72)
    [389] = { {17604,17603,17605,17608,17607,17602} }, -- Field Marshal's Raiment (ilvl 72)
    [390] = { {17623,17625,17622,17624,17618,17620} }, -- Warlord's Raiment (ilvl 72)
    [391] = { {17586,17588,17593,17591,17590,17592} }, -- Warlord's Threads (ilvl 72)
    [392] = { {17581,17580,17583,17584,17579,17578} }, -- Field Marshal's Threads (ilvl 72)
    [393] = { {16563,16561,16562,16564,16560,16558} }, -- Warlord's Vestments (ilvl 72)
    [394] = { {16453,16457,16455,16446,16454,16456} }, -- Field Marshal's Vestments (ilvl 72)
    [395] = { {16466,16465,16468,16462,16463,16467} }, -- Field Marshal's Pursuit (ilvl 72)
    [396] = { {16569,16571,16567,16565,16566,16568} }, -- Warlord's Pursuit (ilvl 72)
    [397] = { {16452,16451,16449,16459,16448,16450} }, -- Field Marshal's Sanctuary (ilvl 72)
    [398] = { {16554,16555,16552,16551,16549,16550} }, -- Warlord's Sanctuary (ilvl 72)
    [401] = { {16410,16409,16433,16435,16434,16436} }, -- Lieutenant Commander's Aegis (ilvl 63)
    [402] = { {16473,16474,16476,16472,16471,16475} }, -- Field Marshal's Aegis (ilvl 72)
    [421] = { {19682,19683,19684} }, -- Bloodvine Garb (ilvl 65)
    [441] = { {19685,19687,19686} }, -- Primal Batskin (ilvl 65)
    [442] = { {19688,19689} }, -- Blood Tiger Harness (ilvl 65)
    [443] = { {19690,19691,19692} }, -- Bloodsoul Embrace (ilvl 65)
    [444] = { {19693,19694,19695} }, -- The Darksoul (ilvl 65)
    [461] = { {19865,19866} }, -- The Twin Blades of Hakkari (ilvl 67)
    [462] = { {19905,19893} }, -- Zanzil's Concentration (ilvl 70)
    [463] = { {19896,19910} }, -- Primal Blessing (ilvl 65)
    [464] = { {19873,19912} }, -- Overlord's Resolution (ilvl 70)
    [465] = { {19863,19920} }, -- Prayer of the Primal (ilvl 70)
    [466] = { {19898,19925} }, -- Major Mojo Infusion (ilvl 68)
    [467] = { {20041,20048,20057} }, -- The Highlander's Resolution (ilvl 64)
    [468] = { {20042,20049,20058} }, -- The Highlander's Resolve (ilvl 64)
    [469] = { {20043,20050,20055} }, -- The Highlander's Determination (ilvl 64)
    [470] = { {20044,20051,20056} }, -- The Highlander's Fortitude (ilvl 64)
    [471] = { {20052,20045,20059} }, -- The Highlander's Purpose (ilvl 64)
    [472] = { {20053,20046,20060} }, -- The Highlander's Will (ilvl 64)
    [473] = { {20054,20047,20061} }, -- The Highlander's Intent (ilvl 64)
    [474] = { {19951,19577,19824,19823,19822} }, -- Vindicator's Battlegear (ilvl 63)
    [475] = { {19952,19588,19827,19826,19825} }, -- Freethinker's Armor (ilvl 63)
    [476] = { {19609,19956,19830,19829,19828} }, -- Augur's Regalia (ilvl 63)
    [477] = { {19621,19953,19833,19832,19831} }, -- Predator's Armor (ilvl 64)
    [478] = { {19617,19954,19836,19835,19834} }, -- Madcap's Outfit (ilvl 63)
    [479] = { {19613,19955,19840,19839,19838} }, -- Haruspex's Garb (ilvl 63)
    [480] = { {19594,19958,19843,19842,19841} }, -- Confessor's Raiment (ilvl 64)
    [481] = { {19605,19957,19848,19849,20033} }, -- Demoniac's Threads (ilvl 63)
    [482] = { {19601,19959,19846,19845,20034} }, -- Illusionist's Attire (ilvl 63)
    [483] = { {20158,20154,20150} }, -- The Defiler's Determination (ilvl 64)
    [484] = { {20195,20199,20203} }, -- The Defiler's Fortitude (ilvl 64)
    [485] = { {20176,20159,20163} }, -- The Defiler's Intent (ilvl 64)
    [486] = { {20186,20190,20194} }, -- The Defiler's Purpose (ilvl 64)
    [487] = { {20204,20208,20212} }, -- The Defiler's Resolution (ilvl 64)
    [488] = { {20167,20171,20175} }, -- The Defiler's Will (ilvl 64)
    [489] = { {16984,15050,15052,15051} }, -- Black Dragon Mail (ilvl 60)
    [490] = { {15045,15046,20296} }, -- Green Dragon Mail (ilvl 54)
    [491] = { {15048,20295,15049} }, -- Blue Dragon Mail (ilvl 59)
    [492] = { {20406,20408,20407} }, -- Twilight Trappings (ilvl 60)
    [493] = { {21355,21353,21354,21356,21357} }, -- Genesis Raiment (ilvl 81)
    [494] = { {21408,21409,21407} }, -- Symbols of Unending Life (ilvl 67)
    [495] = { {21394,21392,21393} }, -- Battlegear of Unyielding Strength (ilvl 67)
    [496] = { {21331,21329,21333,21332,21330} }, -- Conqueror's Battlegear (ilvl 81)
    [497] = { {21359,21360,21361,21362,21364} }, -- Deathdealer's Embrace (ilvl 81)
    [498] = { {21405,21406,21404} }, -- Emblems of Veiled Shadows (ilvl 67)
    [499] = { {21337,21338,21335,21334,21336} }, -- Doomcaller's Attire (ilvl 81)
    [500] = { {21416,21417,21418} }, -- Implements of Unspoken Names (ilvl 67)
    [501] = { {21372,21373,21374,21375,21376} }, -- Stormcaller's Garb (ilvl 81)
    [502] = { {21400,21398,21399} }, -- Gift of the Gathering Storm (ilvl 67)
    [503] = { {21344,21347,21346,21343,21345} }, -- Enigma Vestments (ilvl 81)
    [504] = { {21414,21413,21415} }, -- Trappings of Vaulted Secrets (ilvl 67)
    [505] = { {21389,21387,21388,21390,21391} }, -- Avenger's Battlegear (ilvl 81)
    [506] = { {21397,21395,21396} }, -- Battlegear of Eternal Justice (ilvl 67)
    [507] = { {21349,21350,21348,21352,21351} }, -- Garments of the Oracle (ilvl 81)
    [508] = { {21410,21411,21412} }, -- Finery of Infinite Wisdom (ilvl 67)
    [509] = { {21366,21365,21370,21368,21367} }, -- Striker's Garb (ilvl 82)
    [510] = { {21403,21401,21402} }, -- Trappings of the Unseen Path (ilvl 67)
    [511] = { {21994,21995,21996,21997,21998,21999,22000,22001} }, -- Battlegear of Heroism (ilvl 62)
    [512] = { {22002,22003,22004,22005,22006,22007,22008,22009} }, -- Darkmantle Armor (ilvl 62)
    [513] = { {22106,22107,22108,22109,22110,22111,22112,22113} }, -- Feralheart Raiment (ilvl 62)
    [514] = { {22078,22079,22080,22081,22082,22083,22084,22085} }, -- Vestments of the Virtuous (ilvl 62)
    [515] = { {22010,22011,22061,22013,22015,22016,22017,22060} }, -- Beastmaster Armor (ilvl 62)
    [516] = { {22086,22087,22088,22089,22090,22091,22092,22093} }, -- Soulforge Armor (ilvl 62)
    [517] = { {22062,22063,22064,22065,22066,22067,22068,22069} }, -- Sorcerer's Regalia (ilvl 62)
    [518] = { {22070,22071,22072,22073,22074,22075,22076,22077} }, -- Deathmist Raiment (ilvl 62)
    [519] = { {22095,22096,22097,22098,22099,22100,22101,22102} }, -- The Five Thunders (ilvl 62)
    [520] = { {22306,22311,22313,22302,22304,22305,22303,22301} }, -- Ironweave Battlesuit (ilvl 62)
    [521] = { {22492,22494,22493,22490,22489,22491,22488,22495,23064} }, -- Dreamwalker Raiment (ilvl 88)
    [522] = { {22864,22856,22879,22880,23257,23258} }, -- Champion's Guard (ilvl 68)
    [523] = { {22423,22416,22421,22422,22418,22417,22419,22420,23059} }, -- Dreadnaught's Battlegear (ilvl 88)
    [524] = { {22483,22476,22481,22478,22477,22479,22480,22482,23060} }, -- Bonescythe Armor (ilvl 88)
    [525] = { {22518,22519,22514,22517,22513,22512,22516,22515,23061} }, -- Vestments of Faith (ilvl 88)
    [526] = { {22502,22503,22498,22501,22497,22496,22500,22499,23062} }, -- Frostfire Regalia (ilvl 88)
    [527] = { {22468,22470,22469,22466,22465,22467,22464,22471,23065} }, -- The Earthshatterer (ilvl 88)
    [528] = { {22430,22431,22426,22428,22427,22429,22425,22424,23066} }, -- Redemption Armor (ilvl 88)
    [529] = { {22510,22511,22506,22509,22505,22504,22508,22507,23063} }, -- Plagueheart Raiment (ilvl 88)
    [530] = { {22440,22442,22441,22438,22437,22439,22436,22443,23067} }, -- Cryptstalker Armor (ilvl 88)
    [533] = { {23090,23087,23078} }, -- Battlegear of Undead Slaying (ilvl 63)
    [534] = { {23081,23089,23093} }, -- Undead Slayer's Armor (ilvl 63)
    [535] = { {23088,23082,23092} }, -- Garb of the Undead Slayer (ilvl 63)
    [536] = { {23091,23084,23085} }, -- Regalia of Undead Cleansing (ilvl 63)
    [537] = { {22868,22858,22872,22873,23244,23243} }, -- Champion's Battlearmor (ilvl 68)
    [538] = { {22857,22867,22876,22887,23259,23260} }, -- Champion's Stormcaller (ilvl 68)
    [539] = { {22863,22852,22877,22878,23253,23254} }, -- Champion's Refuge (ilvl 68)
    [540] = { {22869,22859,22882,22885,23261,23262} }, -- Champion's Investiture (ilvl 68)
    [541] = { {22865,22855,23255,23256,22881,22884} }, -- Champion's Dreadgear (ilvl 68)
    [542] = { {22870,22860,23263,23264,22883,22886} }, -- Champion's Arcanum (ilvl 68)
    [543] = { {22843,22862,23251,23252,22874,22875} }, -- Champion's Pursuance (ilvl 68)
    [544] = { {23272,23273,23274,23275,23276,23277} }, -- Lieutenant Commander's Redoubt (ilvl 68)
    [545] = { {23300,23301,23286,23287,23314,23315} }, -- Lieutenant Commander's Battlearmor (ilvl 68)
    [546] = { {23304,23305,23290,23291,23318,23319} }, -- Lieutenant Commander's Arcanum (ilvl 68)
    [547] = { {23296,23297,23282,23283,23310,23311} }, -- Lieutenant Commander's Dreadgear (ilvl 68)
    [548] = { {23298,23299,23284,23285,23312,23313} }, -- Lieutenant Commander's Guard (ilvl 68)
    [549] = { {23302,23303,23288,23289,23316,23317} }, -- Lieutenant Commander's Investiture (ilvl 68)
    [550] = { {23292,23293,23278,23279,23306,23307} }, -- Lieutenant Commander's Pursuance (ilvl 68)
    [551] = { {23294,23295,23280,23281,23308,23309} }, -- Lieutenant Commander's Refuge (ilvl 68)
    [552] = { {21848,21847,21846} }, -- Wrath of Spellfire (ilvl 105)
    [553] = { {21871,21869,21870} }, -- Shadow's Embrace (ilvl 105)
    [554] = { {21875,21874,21873} }, -- Primal Mooncloth (ilvl 113)
    [555] = { {21855,21854,21852,21851,21849,21853,21850} }, -- Netherweave Vestments (ilvl 103)
    [556] = { {21862,21861,21859,21860} }, -- Imbued Netherweave (ilvl 111)
    [557] = { {21865,21864,21863} }, -- Soulcloth Embrace (ilvl 100)
    [558] = { {21868,21866,21867} }, -- Arcanoweave Vestments (ilvl 114)
    [559] = { {24266,24262} }, -- Spellstrike Infusion (ilvl 105)
    [560] = { {23489,23488,23487,23482,23484} }, -- Fel Iron Plate (ilvl 95)
    [561] = { {23490,23491,23493,23494} }, -- Fel Iron Chain (ilvl 94)
    [562] = { {23507,23508,23506} }, -- Adamantite Battlegear (ilvl 104)
    [563] = { {23509,23512,23511,23510} }, -- Enchanted Adamantite Armor (ilvl 114)
    [564] = { {23513,23516,23514,23515} }, -- Flame Guard (ilvl 114)
    [565] = { {23523,23525,23524} }, -- Khorium Ward (ilvl 114)
    [566] = { {23522,23521,23520,33173} }, -- Burning Rage (ilvl 115)
    [567] = { {24544,24549,24545,24547,24546} }, -- Gladiator's Battlegear (ilvl 123)
    [568] = { {24556,24553,24555,24554,24552} }, -- Gladiator's Dreadgear (ilvl 123)
    [569] = { {23519,23518,23517} }, -- Faith in Felsteel (ilvl 114)
    [570] = { {24255,24249} }, -- The Unyielding (ilvl 108)
    [571] = { {24264,24261} }, -- Whitemend Wisdom (ilvl 105)
    [572] = { {24267,24263} }, -- Battlecast Garb (ilvl 105)
    [573] = { {25685,25686,25687} }, -- Fel Skin (ilvl 110)
    [574] = { {25691,25690,25689} }, -- Strength of the Clefthoof (ilvl 113)
    [575] = { {25695,25697,25696} }, -- Felstalker Armor (ilvl 113)
    [576] = { {25694,25693,25692} }, -- Fury of the Nether (ilvl 104)
    [577] = { {25834,25833,25830,25832,25831} }, -- Gladiator's Vestments (ilvl 123)
    [578] = { {25997,26000,25998,26001,25999} }, -- Gladiator's Earthshaker (ilvl 123)
    [579] = { {25854,25855,25857,25856,25858} }, -- Gladiator's Regalia (ilvl 123)
    [580] = { {27469,27470,27471,27472,27473} }, -- Gladiator's Thunderfist (ilvl 123)
    [581] = { {27707,27708,27709,27710,27711} }, -- Gladiator's Raiment (ilvl 123)
    [582] = { {27702,27703,27704,27705,27706} }, -- Gladiator's Aegis (ilvl 123)
    [583] = { {27879,27880,27881,27882,27883} }, -- Gladiator's Vindication (ilvl 123)
    [584] = { {28126,28127,28128,28129,28130} }, -- Gladiator's Sanctuary (ilvl 123)
    [585] = { {28136,28137,28138,28139,28140} }, -- Gladiator's Wildhide (ilvl 123)
    [586] = { {28334,28335,28331,28332,28333} }, -- Gladiator's Pursuit (ilvl 123)
    [611] = { {25657,25656,25655,25654} }, -- Felscale Armor (ilvl 96)
    [612] = { {25661,25659,25662,25660} }, -- Scaled Draenic Armor (ilvl 97)
    [613] = { {25668,25669,25670,25671} }, -- Thick Draenic Armor (ilvl 96)
    [614] = { {25673,25674,25675,25676} }, -- Wild Draenish Armor (ilvl 95)
    [615] = { {30186,30187,30188,30200,30201} }, -- Gladiator's Felshroud (ilvl 123)
    [616] = { {29516,29517,29515} }, -- Netherscale Armor (ilvl 113)
    [617] = { {29521,29520,29519} }, -- Netherstrike Armor (ilvl 117)
    [618] = { {29523,29524,29522} }, -- Windhawk Armor (ilvl 117)
    [619] = { {29527,29526,29525} }, -- Primal Intent (ilvl 117)
    [620] = { {27509,28414,27908,27776,28204} }, -- Assassination Armor (ilvl 115)
    [621] = { {29046,29045,29044,29048,29047} }, -- Netherblade (ilvl 120)
    [622] = { {30144,30145,30146,30148,30149} }, -- Deathmantle (ilvl 133)
    [623] = { {28203,27535,28285,27839,27739} }, -- Righteous Armor (ilvl 115)
    [624] = { {29062,29061,29065,29063,29064} }, -- Justicar Raiment (ilvl 120)
    [625] = { {29066,29068,29067,29069,29070} }, -- Justicar Armor (ilvl 120)
    [626] = { {29071,29073,29072,29074,29075} }, -- Justicar Battlegear (ilvl 120)
    [627] = { {30134,30135,30136,30137,30138} }, -- Crystalforge Raiment (ilvl 133)
    [628] = { {30123,30125,30124,30126,30127} }, -- Crystalforge Armor (ilvl 133)
    [629] = { {30129,30130,30132,30133,30131} }, -- Crystalforge Battlegear (ilvl 133)
    [630] = { {28231,27510,28349,27909,27802} }, -- Tidefury Raiment (ilvl 115)
    [631] = { {29032,29029,29028,29030,29031} }, -- Cyclone Raiment (ilvl 120)
    [632] = { {29033,29035,29034,29036,29037} }, -- Cyclone Regalia (ilvl 120)
    [633] = { {29038,29039,29040,29043,29042} }, -- Cyclone Harness (ilvl 120)
    [634] = { {30164,30165,30166,30167,30168} }, -- Cataclysm Raiment (ilvl 133)
    [635] = { {30169,30170,30171,30172,30173} }, -- Cataclysm Regalia (ilvl 133)
    [636] = { {30185,30189,30190,30192,30194} }, -- Cataclysm Harness (ilvl 133)
    [637] = { {28348,27468,27873,28202,27737} }, -- Moonglade Raiment (ilvl 115)
    [638] = { {29087,29086,29090,29088,29089} }, -- Malorne Raiment (ilvl 120)
    [639] = { {29093,29094,29091,29092,29095} }, -- Malorne Regalia (ilvl 120)
    [640] = { {29096,29097,29099,29100,29098} }, -- Malorne Harness (ilvl 120)
    [641] = { {30222,30223,30228,30229,30230} }, -- Nordrassil Harness (ilvl 133)
    [642] = { {30216,30217,30219,30220,30221} }, -- Nordrassil Raiment (ilvl 133)
    [643] = { {30231,30232,30233,30234,30235} }, -- Nordrassil Regalia (ilvl 133)
    [644] = { {27537,28415,28232,27778,27948} }, -- Oblivion Raiment (ilvl 115)
    [645] = { {28963,28968,28966,28967,28964} }, -- Voidheart Raiment (ilvl 120)
    [646] = { {30211,30212,30213,30215,30214} }, -- Corruptor Raiment (ilvl 133)
    [647] = { {28278,27508,27738,28229,27838} }, -- Incanter's Regalia (ilvl 115)
    [648] = { {29076,29080,29078,29079,29077} }, -- Aldor Regalia (ilvl 120)
    [649] = { {30206,30205,30207,30210,30196} }, -- Tirisfal Regalia (ilvl 133)
    [650] = { {28228,27474,28275,27874,27801} }, -- Beast Lord Armor (ilvl 115)
    [651] = { {29085,29081,29083,29082,29084} }, -- Demon Stalker Armor (ilvl 120)
    [652] = { {30139,30140,30141,30142,30143} }, -- Rift Stalker Armor (ilvl 133)
    [653] = { {28205,27475,27977,27803,28350} }, -- Bold Armor (ilvl 115)
    [654] = { {29012,29011,29017,29015,29016} }, -- Warbringer Armor (ilvl 120)
    [655] = { {29021,29019,29020,29022,29023} }, -- Warbringer Battlegear (ilvl 120)
    [656] = { {30113,30115,30114,30116,30117} }, -- Destroyer Armor (ilvl 133)
    [657] = { {30120,30118,30119,30121,30122} }, -- Destroyer Battlegear (ilvl 133)
    [658] = { {28193,27465,27907,28191,27796} }, -- Mana-Etched Regalia (ilvl 115)
    [659] = { {28264,27531,28224,27837,27797} }, -- Wastewalker Armor (ilvl 115)
    [660] = { {27936,28401,27528,28192,27713} }, -- Desolation Battlegear (ilvl 115)
    [661] = { {28403,27497,28225,27870,27771} }, -- Doomplate Battlegear (ilvl 115)
    [662] = { {28413,28230,27536,27775,27875} }, -- Hallowed Raiment (ilvl 115)
    [663] = { {29055,29049,29054,29050,29053} }, -- Incarnate Raiment (ilvl 120)
    [664] = { {29057,29059,29056,29058,29060} }, -- Incarnate Regalia (ilvl 120)
    [665] = { {30153,30152,30151,30154,30150} }, -- Avatar Raiment (ilvl 133)
    [666] = { {30160,30161,30162,30159,30163} }, -- Avatar Regalia (ilvl 133)
    [667] = { {31339,31338} }, -- The Twin Stars (ilvl 100)
    [668] = { {31028,31026,31027,31029,31030,34575,34448,34558} }, -- Slayer's Armor (ilvl 149)
    [669] = { {31004,31001,31003,31005,31006,34549,34443,34570} }, -- Gronnstalker's Armor (ilvl 149)
    [670] = { {31050,31051,31053,31054,31052,34564,34436,34541} }, -- Malefic Raiment (ilvl 149)
    [671] = { {31056,31055,31058,31059,31057,34574,34447,34557} }, -- Tempest Regalia (ilvl 149)
    [672] = { {30972,30975,30969,30977,30979,34546,34441,34569} }, -- Onslaught Battlegear (ilvl 149)
    [673] = { {30976,30974,30970,30978,30980,34568,34442,34547} }, -- Onslaught Armor (ilvl 149)
    [674] = { {31061,31064,31067,31070,31065,34434,34528,34563} }, -- Absolution Regalia (ilvl 149)
    [675] = { {31068,31063,31060,31069,31066,34562,34527,34435} }, -- Vestments of Absolution (ilvl 149)
    [676] = { {31042,31034,31039,31044,31048,34556,34444,34573} }, -- Thunderheart Harness (ilvl 149)
    [677] = { {31043,31035,31040,31046,31049,34572,34446,34555} }, -- Thunderheart Regalia (ilvl 149)
    [678] = { {31041,31032,31037,31045,31047,34571,34445,34554} }, -- Thunderheart Raiment (ilvl 149)
    [679] = { {30991,30987,30985,30995,30998,34488,34433,34560} }, -- Lightbringer Armor (ilvl 149)
    [680] = { {30990,30982,30993,30997,30989,34561,34431,34485} }, -- Lightbringer Battlegear (ilvl 149)
    [681] = { {30992,30983,30988,30994,30996,34432,34487,34559} }, -- Lightbringer Raiment (ilvl 149)
    [682] = { {31018,31011,31015,31021,31024,34567,34439,34545} }, -- Skyshatter Harness (ilvl 149)
    [683] = { {31016,31007,31012,31019,31022,34543,34438,34565} }, -- Skyshatter Raiment (ilvl 149)
    [684] = { {31017,31008,31014,31020,31023,34542,34437,34566} }, -- Skyshatter Regalia (ilvl 149)
    [685] = { {31375,31376,31377,31378,31379} }, -- Gladiator's Refuge (ilvl 123)
    [686] = { {31396,31397,31400,31406,31407} }, -- Gladiator's Wartide (ilvl 123)
    [687] = { {31409,31410,31411,31412,31413} }, -- Gladiator's Investiture (ilvl 123)
    [690] = { {31613,31614,31616,31618,31619} }, -- Gladiator's Redemption (ilvl 123)
    [697] = { {29600,29601,29602,29603,29604,29605} }, -- Champion's Redoubt (ilvl 68)
    [698] = { {29612,29613,29614,29615,29616,29617} }, -- Warlord's Aegis (ilvl 72)
    [699] = { {32838,32837} }, -- The Twin Blades of Azzinoth (ilvl 156)
    [717] = { {29608,29606,29611,29609,29607,29610} }, -- Field Marshal's Earthshaker (ilvl 72)
    [718] = { {29599,29595,29597,29596,29598,29594} }, -- Lieutenant Commander's Earthshaker (ilvl 68)
    [719] = { {32946,32945} }, -- The Fists of Fury (ilvl 141)
    [737] = { {34703,28189} }, -- Latro's Flurry (ilvl 115)
    [2013] = { {35370,35369,35368,35367,35366} }, -- Oathbound's Opportunistic Vestments (ilvl 115)
    [2014] = { {35407,35408,35409,35410,35411} }, -- Oathbound's Savage Plate Battlegear (ilvl 115)
    [2015] = { {35402,35403,35404,35405,35406} }, -- Oathbound's Ornamented Battlegear (ilvl 115)
    [2016] = { {35412,35413,35414,35415,35416} }, -- Oathbound's Scaled Battlegear (ilvl 115)
    [2017] = { {35391,35392,35393,35394,35395} }, -- Oathbound's Ringmail Battlegear (ilvl 115)
    [2018] = { {35386,35387,35388,35389,35390} }, -- Oathbound's Mail Battlegear (ilvl 115)
    [2019] = { {35381,35382,35383,35384,35385} }, -- Oathbound's Linked Battlegear (ilvl 115)
    [2020] = { {35376,35377,35378,35379,35380} }, -- Oathbound's Chain Battlegear (ilvl 115)
    [2021] = { {35343,35344,35345,35346,35347} }, -- Oathbound's Silk Battlegear (ilvl 115)
    [2022] = { {35328,35329,35330,35331,35332} }, -- Oathbound's Dreadweave Battlegear (ilvl 115)
    [2023] = { {35333,35334,35335,35336,35337} }, -- Oathbound's Mooncloth Battlegear (ilvl 115)
    [2024] = { {35338,35339,35340,35341,35342} }, -- Oathbound's Satin Battlegear (ilvl 115)
    [2025] = { {35356,35357,35358,35360,35359} }, -- Oathbound's Dragonhide Battlegear (ilvl 115)
    [2026] = { {35371,35372,35373,35375,35374} }, -- Oathbound's Wyrmhide Battlegear (ilvl 115)
    [2027] = { {35361,35362,35363,35365,35364} }, -- Oathbound's Kodohide Battlegear (ilvl 115)
}

MSC.SetBonusScores = {
    -- The Gladiator
        -- (2) +20 Armor.
        -- (3) Increases defense rating by 3.
        -- (4) Increases attack power by 10.
        -- (5) Increases your critical strike rating by 14.
    [1] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=20}}, [3]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=3}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- Dal'Rend's Arms
        -- (2) Increases attack power by 50.
    [41] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=50}} },
    -- Spider's Kiss
        -- (2) Chance on Hit: Immobilizes the target and lowers their armor by 100 for 10 sec.
    [65] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- The Postmaster
        -- (2) +50 Armor.
        -- (3) +10 Fire Resistance. / +10 Arcane Resistance.
        -- (4) Increases damage and healing done by magical spells and effects by up to 12.
        -- (5) Increases run speed by 5%. / +10 Intellect.
    [81] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=50}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}}, [5]={stats={ITEM_MOD_INTELLECT_SHORT=10}} },
    -- Cadaverous Garb
        -- (2) Increases defense rating by 5.
        -- (3) Increases attack power by 10.
        -- (4) +15 All Resistances.
        -- (5) Increases your hit rating by 20.
    [121] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=5}}, [3]={stats={ITEM_MOD_ATTACK_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_HIT_RATING_SHORT=20}} },
    -- Necropile Raiment
        -- (2) Increases defense rating by 5.
        -- (3) +5 Intellect.
        -- (4) +15 All Resistances.
        -- (5) Increases damage and healing done by magical spells and effects by up to 23.
    [122] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=5}}, [3]={stats={ITEM_MOD_INTELLECT_SHORT=5}}, [5]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Bloodmail Regalia
        -- (2) Increases defense rating by 5.
        -- (3) Increases attack power by 10.
        -- (4) +15 All Resistances.
        -- (5) Increases your parry rating by 20.
    [123] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=5}}, [3]={stats={ITEM_MOD_ATTACK_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}} },
    -- Deathbone Guardian
        -- (2) Increases defense rating by 5.
        -- (3) +50 Armor.
        -- (4) +15 All Resistances.
        -- (5) Increases your parry rating by 20.
    [124] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=5}}, [3]={stats={ITEM_MOD_ARMOR_SHORT=50}}, [5]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}} },
    -- Volcanic Armor
        -- (3) 5% chance of dealing X Fire damage on a successful melee attack.
    [141] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Stormshroud Armor
        -- (2) 5% chance of dealing X Nature damage on a successful melee attack.
        -- (3) 2% chance on melee attack of restoring X energy.
        -- (4) Increases attack power by 14.
    [142] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=14}} },
    -- Devilsaur Armor
        -- (2) Increases your hit rating by 20.
    [143] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=20}} },
    -- Ironfeather Armor
        -- (2) Increases damage and healing done by magical spells and effects by up to 20.
    [144] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Defias Leather
        -- (2) +10 Armor.
        -- (3) +5 Arcane Resistance.
        -- (4) Increases expertise rating by 2.
        -- (5) Increases attack power by 10.
    [161] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=10}}, [4]={stats={ITEM_MOD_EXPERTISE_RATING_SHORT=2}}, [5]={stats={ITEM_MOD_ATTACK_POWER_SHORT=10}} },
    -- Embrace of the Viper
        -- (2) Increases damage done by Nature spells and effects by up to 7.
        -- (3) Increases expertise rating by 4.
        -- (4) Increases healing done by up to 11 and damage done by up to 4 for all magical spells and effects.
        -- (5) +10 Intellect.
    [162] = { [2]={stats={ITEM_MOD_NATURE_DAMAGE_SHORT=7}}, [3]={stats={ITEM_MOD_EXPERTISE_RATING_SHORT=4}}, [4]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=11, ITEM_MOD_SPELL_POWER_SHORT=4}}, [5]={stats={ITEM_MOD_INTELLECT_SHORT=10}} },
    -- Chain of the Scarlet Crusade
        -- (2) +10 Armor.
        -- (3) Increases defense rating by 2.
        -- (4) +5 Shadow Resistance.
        -- (5) Increases attack power by 15 when fighting Undead.
        -- (6) Increases your hit rating by 10.
    [163] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=10}}, [3]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=2}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=8, ITEM_MOD_SPELL_POWER_SHORT=4}}, [6]={stats={ITEM_MOD_HIT_RATING_SHORT=10}} },
    -- Magister's Regalia
        -- (2) +200 Armor.
        -- (4) Increases damage and healing done by magical spells and effects by up to 23.
        -- (6) When struck in combat has a chance of freezing the attacker in place for X.
        -- (8) +8 All Resistances.
    [181] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Vestments of the Devout
        -- (2) +200 Armor.
        -- (4) Increases damage and healing done by magical spells and effects by up to 23.
        -- (6) When struck in combat has a chance of shielding the wearer in a protective shield which will absorb 350 damage.
        -- (8) +8 All Resistances.
    [182] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Dreadmist Raiment
        -- (2) +200 Armor.
        -- (4) Increases damage and healing done by magical spells and effects by up to 23.
        -- (6) When struck in combat has a chance of causing the attacker to flee in terror for 2 seconds.
        -- (8) +8 All Resistances.
    [183] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Shadowcraft Armor
        -- (2) +200 Armor.
        -- (4) Increases attack power by 40.
        -- (6) Chance on melee attack to restore 35 energy.
        -- (8) +8 All Resistances.
    [184] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Wildheart Raiment
        -- (2) +200 Armor.
        -- (4) Increases attack power by 26. / Increases damage and healing done by magical spells and effects by up to 15.
        -- (6) When struck in combat has a chance of returning 300 mana, 10 rage, or 40 energy to the wearer.
        -- (8) +8 All Resistances.
    [185] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Beaststalker Armor
        -- (2) +200 Armor.
        -- (4) Increases attack power by 40.
        -- (6) Your normal ranged attacks have a 4% chance of restoring 200 mana.
        -- (8) +8 All Resistances.
    [186] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- The Elements
        -- (2) +200 Armor.
        -- (4) Increases damage and healing done by magical spells and effects by up to 23.
        -- (6) Chance on spell cast to increase your damage and healing by up to X for X.
        -- (8) +8 All Resistances.
    [187] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Lightforge Armor
        -- (2) +200 Armor.
        -- (4) Increases attack power by 40.
        -- (6) Chance on melee attack to increase your damage and healing done by magical spells and effects by up to X for X.
        -- (8) +8 All Resistances.
    [188] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Battlegear of Valor
        -- (2) +200 Armor.
        -- (4) Increases attack power by 40.
        -- (6) Chance on melee attack to heal you for X.
        -- (8) +8 All Resistances.
    [189] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Arcanist Regalia
        -- (3) Increases damage and healing done by magical spells and effects by up to 18.
        -- (5) Increases your spell penetration by 38.
        -- (8) Decreases the threat generated by your spells by 15%.
    [201] = { [3]={stats={ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Vestments of Prophecy
        -- (3) -0.1 sec to the casting time of your Flash Heal spell.
        -- (5) Improves your spell critical strike rating by 28.
        -- (8) Increases your chance of a critical hit with Prayer of Healing by 25%.
    [202] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=28}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Felheart Raiment
        -- (3) Health or Mana gained from Drain Life and Drain Mana increased by 15%.
        -- (5) Your pet gains X stamina and X spell resistance against all schools of magic.
        -- (8) Mana cost of Shadow spells reduced by 15%.
    [203] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Nightslayer Armor
        -- (3) Reduces the cooldown of your Vanish ability by 30 sec.
        -- (5) Increases your maximum Energy by 10.
        -- (8) Heals the rogue for X when Vanish is performed.
    [204] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Cenarion Raiment
        -- (3) Damage dealt by Thorns increased by 4 and duration increased by 50%.
        -- (5) Increases your spell critical strike rating by 28.
        -- (8) Reduces the cooldown of your Tranquility and Hurricane spells by 50%.
    [205] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=28}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Giantstalker Armor
        -- (3) Increases the range of your Mend Pet spell by 50% and the effect by 10%. Also reduces the cost by 30%.
        -- (5) Increases your pet's stamina by X and all spell resistances by X.
        -- (8) Increases the damage of Multi-shot and Volley by 15%.
    [206] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- The Earthfury
        -- (3) The radius of your totems that affect friendly targets is increased to 30 yd.
        -- (5) After casting your Healing Wave or Lesser Healing Wave spell, gives you a 25% chance to gain Mana equal to 35% of the base cost of the spell.
        -- (8) Your Healing Wave will now jump to additional nearby targets. Each jump reduces the effectiveness of the heal by 80%, and the spell will jump to up to two additional targets.
    [207] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Lawbringer Armor
        -- (3) Increases the chance of triggering a Judgement of Light heal by 10%.
        -- (5) Increases your spell critical strike rating by 14. / Increases your critical strike rating by 14.
        -- (8) Gives the Paladin a chance on every melee hit to heal your party for X.
    [208] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_CRIT_RATING_SHORT=14, ITEM_MOD_SPELL_CRIT_RATING_SHORT=14}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Battlegear of Might
        -- (3) Increases the block value of your shield by 30.
        -- (5) Gives you a X% chance to generate an additional Rage point whenever damage is dealt to you.
        -- (8) Increases the threat generated by Sunder Armor and Devastate by 15%.
    [209] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Netherwind Regalia
        -- (3) Reduces the threat generated by your Scorch, Arcane Missiles, Fireball, and Frostbolt spells.
        -- (5) Increases the radius of Arcane Explosion, Flamestrike, and Blizzard by 25%.
        -- (8) 10% chance after casting Arcane Missiles, Fireball, or Frostbolt that your next spell with a casting time under 10 seconds cast instantly.
    [210] = { [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Vestments of Transcendence
        -- (3) Restores 20 mana per 5 sec.
        -- (5) When struck in melee there is a X% chance you will Fade for X.
        -- (8) Your Greater Heals now have a heal over time component equivalent to a rank 5 Renew.
    [211] = { [3]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=20}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Nemesis Raiment
        -- (3) Increases damage and healing done by magical spells and effects by up to 23.
        -- (5) Your pet gains X stamina and X spell resistance against all schools of magic.
        -- (8) Reduces the threat generated by your Destruction spells by 20%.
    [212] = { [3]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Bloodfang Armor
        -- (3) Increases the chance to apply poisons to your target by 5%.
        -- (5) Improves the threat reduction of Feint by 25%.
        -- (8) Gives the Rogue a chance to inflict X damage on the target and heal the Rogue for X health every X sec. for X. on a melee hit.
    [213] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Stormrage Raiment
        -- (3) Restores 20 mana per 5 sec.
        -- (5) Reduces the casting time of your Regrowth spell by 0.2 sec.
        -- (8) Increases the duration of your Rejuvenation spell by 3 sec.
    [214] = { [3]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=20}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Dragonstalker Armor
        -- (3) Increases the ranged attack power bonus of your Aspect of the Hawk by 20%.
        -- (5) Increases your pet's stamina by X and all spell resistances by X.
        -- (8) You have a chance whenever you deal ranged damage to apply an Expose Weakness effect to the target. Expose Weakness increases the ranged attack power of all attackers against that target by X for X.
    [215] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- The Ten Storms
        -- (3) Increases the amount healed by Chain Heal to targets beyond the first by 5%.
        -- (5) Increases your spell critical strike rating by 42.
        -- (8) When you cast a Healing Wave or Lesser Healing Wave, there is a 25% chance the target also receives a free Lightning Shield that causes X Nature damage to attacker on hit.
    [216] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [5]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=42}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Judgement Armor
        -- (3) Increases the radius of a Paladin's auras to 40 yd.
        -- (5) Increases damage and healing done by magical spells and effects by up to 47.
        -- (8) Inflicts X additional Holy damage on the target of a Paladin's Judgement.
    [217] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [5]={stats={ITEM_MOD_SPELL_POWER_SHORT=47}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Battlegear of Wrath
        -- (3) Increases the attack power granted by Battle Shout by 30.
        -- (5) X% chance after using an offensive ability requiring rage that your next offensive ability requires X less rage to use.
        -- (8) X% chance to parry the next attack after a block.
    [218] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Garb of Thero-shan
        -- (6) Increases your critical strike rating by 14.
    [221] = { [6]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- Shard of the Gods (no scorable bonus)
        -- (2) +10 All Resistances.
    -- Spirit of Eskhandar
        -- (4) 1% chance on a melee critical hit to call forth the spirit of Eskhandar to protect you in battle for X.
    [261] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Champion's Battlegear
        -- (2) Increases your parry rating by 20.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +15 Stamina.
    [281] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Battlegear
        -- (2) Increases your parry rating by 20.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +15 Stamina.
    [282] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Earthshaker
        -- (2) Increases attack power by 40.
        -- (4) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +15 Stamina.
    [301] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Imperial Plate
        -- (2) +100 Armor.
        -- (4) Increases attack power by 28.
        -- (6) +18 Stamina.
    [321] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=100}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=28}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=18}} },
    -- Champion's Regalia
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 2 sec.
        -- (6) +15 Stamina.
    [341] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Raiment
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +15 Stamina.
    [342] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Regalia
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 2 sec.
        -- (6) +15 Stamina.
    [343] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Raiment
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +15 Stamina.
    [344] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Threads
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Fear spell by 0.2.1 sec.
        -- (6) +15 Stamina.
    [345] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Threads
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Fear spell by 0.2.1 sec.
        -- (6) +15 Stamina.
    [346] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Vestments
        -- (2) Increases your parry rating by 20.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +15 Stamina.
    [347] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Vestments
        -- (2) Increases your parry rating by 20.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +15 Stamina.
    [348] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Pursuit
        -- (2) Increases your parry rating by 20.
        -- (4) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +15 Stamina.
    [361] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Pursuit
        -- (2) Increases your parry rating by 20.
        -- (4) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +15 Stamina.
    [362] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Sanctuary
        -- (2) Increases attack power by 40.
        -- (4) Increases your movement speed by 15% while in Bear Form, Cat Form, or Travel Form. Only active outdoors.
        -- (6) +15 Stamina.
    [381] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Sanctuary
        -- (2) Increases attack power by 40.
        -- (4) Increases your movement speed by 15% while in Bear Form, Cat Form, or Travel Form. Only active outdoors.
        -- (6) +15 Stamina.
    [382] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Warlord's Battlegear
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) Increases attack power by 40.
    [383] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Field Marshal's Battlegear
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) Increases attack power by 40.
    [384] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Earthshaker
        -- (2) +20 Stamina.
        -- (3) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) Increases attack power by 40.
    [386] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Regalia
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Blink spell by 2 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [387] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Regalia
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Blink spell by 2 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [388] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Raiment
        -- (2) +20 Stamina.
        -- (3) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [389] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Warlord's Raiment
        -- (2) +20 Stamina.
        -- (3) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [390] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Warlord's Threads
        -- (2) +20 Stamina.
        -- (3) Reduces the casting time of your Fear spell by 0.2.1 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [391] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Threads
        -- (2) +20 Stamina.
        -- (3) Reduces the casting time of your Fear spell by 0.2.1 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [392] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Warlord's Vestments
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) Increases attack power by 40.
    [393] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Field Marshal's Vestments
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) Increases attack power by 40.
    [394] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Field Marshal's Pursuit
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +20 Agility.
    [395] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_AGILITY_SHORT=20}} },
    -- Warlord's Pursuit
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +20 Agility.
    [396] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_AGILITY_SHORT=20}} },
    -- Field Marshal's Sanctuary
        -- (2) +20 Stamina.
        -- (3) Increases your movement speed by 15% while in Bear Form, Cat Form, or Travel Form. Only active outdoors.
        -- (6) Increases attack power by 40.
    [397] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Sanctuary
        -- (2) +20 Stamina.
        -- (3) Increases your movement speed by 15% while in Bear Form, Cat Form, or Travel Form. Only active outdoors.
        -- (6) Increases attack power by 40.
    [398] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Lieutenant Commander's Aegis
        -- (2) Increases your critical strike rating by 14. / +6 Intellect.
        -- (4) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) +15 Stamina.
    [401] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=14, ITEM_MOD_INTELLECT_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Field Marshal's Aegis
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [402] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Bloodvine Garb
        -- (3) Increases your spell critical strike rating by 28.
    [421] = { [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=28}} },
    -- Primal Batskin
        -- (3) Minor increase to running and swimming speed.
    [441] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}} },
    -- Blood Tiger Harness
        -- (2) Increases your critical strike rating by 14. / Increases your spell critical strike rating by 14.
    [442] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=14, ITEM_MOD_SPELL_CRIT_RATING_SHORT=14}} },
    -- Bloodsoul Embrace
        -- (3) Restores 12 mana per 5 sec.
    [443] = { [3]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=12}} },
    -- The Darksoul
        -- (3) Increases defense rating by 30.
    [444] = { [3]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=30}} },
    -- The Twin Blades of Hakkari
        -- (2) Increases expertise rating by 14.
    [461] = { [2]={stats={ITEM_MOD_EXPERTISE_RATING_SHORT=14}} },
    -- Zanzil's Concentration
        -- (2) Increases your spell hit rating by 8. / Increases damage and healing done by magical spells and effects by up to 6.
    [462] = { [2]={stats={ITEM_MOD_HIT_SPELL_RATING_SHORT=8, ITEM_MOD_SPELL_POWER_SHORT=6}} },
    -- Primal Blessing
        -- (2) Grants a small chance when ranged or melee damage is dealt to infuse the wielder with a blessing from the Primal Gods. Ranged and melee attack power increased by 300 for 12 seconds.
    [463] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Overlord's Resolution
        -- (2) Increases your dodge rating by 12.
    [464] = { [2]={stats={ITEM_MOD_DODGE_RATING_SHORT=12}} },
    -- Prayer of the Primal
        -- (2) Increases healing done by up to 33 and damage done by up to 11 for all magical spells and effects.
    [465] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=33, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Major Mojo Infusion
        -- (2) Increases attack power by 30.
    [466] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- The Highlander's Resolution
        -- (2) +5 Stamina.
        -- (3) Increases your critical strike rating by 14.
    [467] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- The Highlander's Resolve
        -- (2) +5 Stamina.
        -- (3) Increases your critical strike rating by 14.
    [468] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- The Highlander's Determination
        -- (2) +5 Stamina.
        -- (3) Increases your critical strike rating by 14.
    [469] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- The Highlander's Fortitude
        -- (2) +5 Stamina.
        -- (3) Increases your spell critical strike rating by 14.
    [470] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=14}} },
    -- The Highlander's Purpose
        -- (2) +5 Stamina.
        -- (3) Increases your critical strike rating by 14.
    [471] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- The Highlander's Will
        -- (2) +5 Stamina.
        -- (3) Increases your spell critical strike rating by 14.
    [472] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=14}} },
    -- The Highlander's Intent
        -- (2) +5 Stamina.
        -- (3) Increases your spell critical strike rating by 14.
    [473] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=14}} },
    -- Vindicator's Battlegear
        -- (2) Increases your block rating by 10.
        -- (3) Decreases the cooldown of Intimidating Shout by 15 sec.
        -- (5) Decrease the rage cost of Whirlwind by X.
    [474] = { [2]={stats={ITEM_MOD_BLOCK_RATING_SHORT=10}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Freethinker's Armor
        -- (2) Restores 4 mana per 5 sec.
        -- (3) Reduces the casting time of your Holy Light spell by 0.1 sec.
        -- (5) Increases the duration of all Blessings by 10%.
    [475] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=4}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Augur's Regalia
        -- (2) Restores 4 mana per 5 sec.
        -- (3) Improves the duration of your Frost Shock spell by 1 sec.
        -- (5) Increase the range of your Lightning Bolt spell by 5 yds.
    [476] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=4}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Predator's Armor
        -- (2) Increases attack power by 20.
        -- (3) Decreases the cooldown of Concussive Shot by 1 sec.
        -- (5) Increases the duration of Serpent Sting by 3 sec.
    [477] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Madcap's Outfit
        -- (2) Increases attack power by 20.
        -- (3) Decreases the cooldown of Blind by 5 sec.
        -- (5) Decrease the energy cost of Eviscerate and Rupture by 5.
    [478] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Haruspex's Garb
        -- (2) Restores 4 mana per 5 sec.
        -- (3) Increases the duration of Faerie Fire by 5 sec.
        -- (5) Increases the critical hit chance of your Starfire spell 3%.
    [479] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=4}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Confessor's Raiment
        -- (2) Increases healing done by up to 22 and damage done by up to 8 for all magical spells and effects.
        -- (3) Increase the range of your Smite and Holy Fire spells by 5 yds.
        -- (5) Reduces the casting time of your Mind Control spell by 0.5 sec.
    [480] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=8}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Demoniac's Threads
        -- (2) Increases damage and healing done by magical spells and effects by up to 12.
        -- (3) Increases the damage of Corruption by 2%.
        -- (5) Decreases the cooldown of Death Coil by 15%.
    [481] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Illusionist's Attire
        -- (2) Increases damage and healing done by magical spells and effects by up to 12.
        -- (3) Decreases the mana cost of Arcane Intellect and Arcane Brilliance by 5%.
        -- (5) Reduces the casting time of your Flamestrike spell by 0.5 sec.
    [482] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- The Defiler's Determination
        -- (2) +5 Stamina.
        -- (3) Increases your critical strike rating by 14.
    [483] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- The Defiler's Fortitude
        -- (2) +5 Stamina.
        -- (3) Increases your critical strike rating by 14.
    [484] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- The Defiler's Intent
        -- (2) +5 Stamina.
        -- (3) Increases your spell critical strike rating by 14.
    [485] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=14}} },
    -- The Defiler's Purpose
        -- (2) +5 Stamina.
        -- (3) Increases your critical strike rating by 14.
    [486] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- The Defiler's Resolution
        -- (2) +5 Stamina.
        -- (3) Increases your critical strike rating by 14.
    [487] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}} },
    -- The Defiler's Will
        -- (2) +5 Stamina.
        -- (3) Increases your spell critical strike rating by 14.
    [488] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=14}} },
    -- Black Dragon Mail
        -- (2) Increases your hit rating by 10.
        -- (3) Increases your critical strike rating by 28.
        -- (4) +10 Fire Resistance.
    [489] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=10}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=28}} },
    -- Green Dragon Mail
        -- (2) Restores 3 mana per 5 sec.
        -- (3) Restores 20 mana per 5 sec.
    [490] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=3}}, [3]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=20}} },
    -- Blue Dragon Mail
        -- (2) +4 All Resistances.
        -- (3) Increases damage and healing done by magical spells and effects by up to 28.
    [491] = { [3]={stats={ITEM_MOD_SPELL_POWER_SHORT=28}} },
    -- Twilight Trappings
        -- (3) Bestows the wearer with the evil aura of a Twilight's Hammer cultist.
    [492] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Genesis Raiment
        -- (3) Increases defense rating by 22. / +150 Armor.
        -- (5) Reduces the cooldown of Rebirth by X minutes.
    [493] = { [3]={stats={ITEM_MOD_ARMOR_SHORT=150, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=22}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Symbols of Unending Life
        -- (3) Your finishing moves now refund 30 energy on a Miss, Dodge, Block, or Parry.
    [494] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Battlegear of Unyielding Strength
        -- (3) -X rage cost to Intercept.
    [495] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Conqueror's Battlegear
        -- (3) Decreases the rage cost of all Warrior shouts by 35%.
        -- (5) Increase the Slow effect and damage of Thunder Clap by 50%.
    [496] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Deathdealer's Embrace
        -- (3) Reduces the cooldown of your Evasion ability by X min.
        -- (5) 15% increased damage to your Eviscerate ability.
    [497] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Emblems of Veiled Shadows
        -- (3) -10 energy cost for your Slice and Dice ability.
    [498] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Doomcaller's Attire
        -- (3) 5% increased damage on your Immolate spell.
        -- (5) Reduces the mana cost of Shadow Bolt by 15%.
    [499] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Implements of Unspoken Names
        -- (3) 5% increased damage from your summoned pets' melee attacks and damage spells.
    [500] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Stormcaller's Garb
        -- (3) Your Lightning Bolt, Chain Lightning, and Shock spells have a 20% chance to grant up to X Nature damage to spells for X.
        -- (5) -0.4 seconds on the casting time of your Chain Heal spell.
    [501] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Gift of the Gathering Storm
        -- (3) Increases the chain target damage multiplier of your Chain Lightning spell by 5%.
    [502] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Enigma Vestments
        -- (3) Your Blizzard spell has a 30% chance to be uninterruptible.
        -- (5) Grants +X% increased spell hit chance for X when one of your spells is resisted.
    [503] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Trappings of Vaulted Secrets
        -- (3) 15% increase to the total damage absorbed by Mana Shield.
    [504] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Avenger's Battlegear
        -- (3) Increases the duration of your Judgements by 20%.
        -- (5) Increases damage and healing done by magical spells and effects by up to 71.
    [505] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [5]={stats={ITEM_MOD_SPELL_POWER_SHORT=71}} },
    -- Battlegear of Eternal Justice
        -- (3) 20% chance to regain 100 mana when you cast a Judgement.
    [506] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Garments of the Oracle
        -- (3) 20% chance that your heals on others will also heal you 10% of the amount healed.
        -- (5) Increases the duration of your Renew spell by 3 sec.
    [507] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Finery of Infinite Wisdom
        -- (3) Increases the damage of your Shadow Word: Pain spell by 5%.
    [508] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Striker's Garb
        -- (3) Reduces the cost of your Arcane Shots by 10%.
        -- (5) Reduces the cooldown of your Rapid Fire ability by X minutes.
    [509] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Trappings of the Unseen Path
        -- (3) Increases your pet's damage by 3%.
    [510] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Battlegear of Heroism
        -- (2) +8 All Resistances.
        -- (4) Chance on melee attack to heal you for X.
        -- (6) Increases attack power by 40.
        -- (8) +200 Armor.
    [511] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Darkmantle Armor
        -- (2) +8 All Resistances.
        -- (4) Chance on melee attack to restore 35 energy.
        -- (6) Increases attack power by 40.
        -- (8) +200 Armor.
    [512] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Feralheart Raiment
        -- (2) +8 All Resistances.
        -- (4) When struck in combat has a chance of returning 300 mana, 10 rage, or 40 energy to the wearer.
        -- (6) Increases damage and healing done by magical spells and effects by up to 15. / Increases attack power by 26.
        -- (8) +200 Armor.
    [513] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=15}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Vestments of the Virtuous
        -- (2) +8 All Resistances.
        -- (4) When struck in combat has a chance of shielding the wearer in a protective shield which will absorb 350 damage.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
        -- (8) +200 Armor.
    [514] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Beastmaster Armor
        -- (2) +8 All Resistances.
        -- (4) Your normal ranged attacks have a 4% chance of restoring 200 mana.
        -- (6) Increases attack power by 40.
        -- (8) +200 Armor.
    [515] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Soulforge Armor
        -- (2) +8 All Resistances.
        -- (4) Chance on melee attack to increase your damage and healing done by magical spells and effects by up to X for X.
        -- (6) Increases attack power by 40.
        -- (8) +200 Armor.
    [516] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Sorcerer's Regalia
        -- (2) +8 All Resistances.
        -- (4) When struck in combat has a chance of freezing the attacker in place for X.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
        -- (8) +200 Armor.
    [517] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Deathmist Raiment
        -- (2) +8 All Resistances.
        -- (4) When struck in combat has a chance of causing the attacker to flee in terror for 2 seconds.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
        -- (8) +200 Armor.
    [518] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- The Five Thunders
        -- (2) +8 All Resistances.
        -- (4) Chance on spell cast to increase your damage and healing by up to X for X.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
        -- (8) +200 Armor.
    [519] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Ironweave Battlesuit
        -- (4) Increases your chance to resist Silence and Interrupt effects by 10%.
        -- (8) +200 Armor.
    [520] = { [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Dreamwalker Raiment
        -- (2) Your Rejuvenation ticks have a chance to restore 60 mana, 8 energy, or 2 rage to your target.
        -- (4) Reduces the mana cost of your Healing Touch, Regrowth, Rejuvenation, and Tranquility spells by 3%.
        -- (6) Your initial cast and Regrowth ticks will increase the maximum health of your target by up to 50, stacking up to 7 times.
        -- (8) On Healing Touch critical hits, you regain 30% of the mana cost of the spell.
    [521] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Champion's Guard
        -- (2) Increases attack power by 40.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +20 Stamina.
    [522] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Dreadnaught's Battlegear
        -- (2) Increases the damage done by your Revenge ability by 75.
        -- (4) Improves your chance to hit with Taunt and Challenging Shout by 5%.
        -- (6) Improves your chance to hit with Sunder Armor, Devastate, Heroic Strike, Revenge, and Shield Slam by 5%.
        -- (8) When your health drops below 20%, for the next 5 seconds healing spells cast on you help you to Cheat Death, increasing healing done by up to X.
    [523] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Bonescythe Armor
        -- (2) Your normal melee swings have a chance to Invigorate you, healing you for X.
        -- (4) Your Backstab, Sinister Strike, and Hemorrhage critical hits cause you to regain X energy.
        -- (6) Reduces the threat from your Backstab, Sinister Strike, Hemorrhage, and Eviscerate abilities.
        -- (8) Your Eviscerate has a chance per combo point to reveal a flaw in your opponent's armor, granting a 100% critical hit chance for your next Backstab, Sinister Strike, or Hemorrhage.
    [524] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Vestments of Faith
        -- (2) Reduces the mana cost of your Renew spell by 12%.
        -- (4) On Greater Heal critical hits, your target will gain Armor of Faith, absorbing up to X damage.
        -- (6) Reduces the threat from your healing spells.
        -- (8) Each spell you cast can trigger an Epiphany, increasing your mana regeneration by X for X.
    [525] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Frostfire Regalia
        -- (2) Reduces cooldown on your Evocation by X minute.
        -- (4) Gives your Mage Armor a chance when struck by a harmful spell to increase resistance against that school of magic by X for X.
        -- (6) Your damage spells have a chance to cause your target to take up to X increased damage from subsequent spells.
        -- (8) Your damage spells have a chance to displace you, causing the next spell cast to generate no threat.
    [526] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- The Earthshatterer
        -- (2) Reduces the mana cost of your totem spells by 12%.
        -- (4) Increases the mana gained from your Mana Spring totems by 25%.
        -- (6) Your Healing Wave and Lesser Healing Wave spells have a chance to imbue your target with Totemic Power.
        -- (8) Your Lightning Shield spell also grants you X mana per 5 sec. while active.
    [527] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Redemption Armor
        -- (2) Increases the amount healed by your Judgement of Light by 20.
        -- (4) Reduces cooldown on your Lay on Hands by X min.
        -- (6) Your Flash of Light and Holy Light spells have a chance to imbue your target with Holy Power.
        -- (8) Your Cleanse spell also heals the target for 200.
    [528] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Plagueheart Raiment
        -- (2) Your Shadow Bolts now have a chance to heal you for X.
        -- (4) Increases damage caused by your Corruption by 12%.
        -- (6) Your spell critical hits generate 25% less threat. In addition, Corruption, Immolate, Curse of Agony, and Siphon Life generate 25% less threat.
        -- (8) Reduces health cost of your Life Tap by 12%.
    [529] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Cryptstalker Armor
        -- (2) Increases the duration of your Rapid Fire by 4 sec.
        -- (4) While your pet is active, increases attack power by X for both you and your pet.
        -- (6) Your ranged critical hits cause an Adrenaline Rush, granting you X mana.
        -- (8) Reduces the mana cost of your Multi-Shot and Aimed Shot by 20.
    [530] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Battlegear of Undead Slaying
        -- (3) Increases your damage against undead by 2%.
    [533] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}} },
    -- Undead Slayer's Armor
        -- (3) Increases your damage against undead by 2%.
    [534] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}} },
    -- Garb of the Undead Slayer
        -- (3) Increases your damage against undead by 2%.
    [535] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}} },
    -- Regalia of Undead Cleansing
        -- (3) Increases your damage against undead by 2%.
    [536] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}} },
    -- Champion's Battlearmor
        -- (2) Increases attack power by 40.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +20 Stamina.
    [537] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Stormcaller
        -- (2) Increases attack power by 40.
        -- (4) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +20 Stamina.
    [538] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Refuge
        -- (2) Increases attack power by 40.
        -- (4) Increases your movement speed by 15% while in Bear Form, Cat Form, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [539] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Investiture
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +20 Stamina.
    [540] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Dreadgear
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Fear spell by 0.2.1 sec.
        -- (6) +20 Stamina.
    [541] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Arcanum
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 2 sec.
        -- (6) +20 Stamina.
    [542] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Pursuance
        -- (2) +20 Agility.
        -- (4) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +20 Stamina.
    [543] = { [2]={stats={ITEM_MOD_AGILITY_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Redoubt
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) +20 Stamina.
    [544] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Battlearmor
        -- (2) Increases attack power by 40.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +20 Stamina.
    [545] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Arcanum
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 2 sec.
        -- (6) +20 Stamina.
    [546] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Dreadgear
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Fear spell by 0.2.1 sec.
        -- (6) +20 Stamina.
    [547] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Guard
        -- (2) Increases attack power by 40.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +20 Stamina.
    [548] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Investiture
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +20 Stamina.
    [549] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Pursuance
        -- (2) +20 Agility.
        -- (4) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +20 Stamina.
    [550] = { [2]={stats={ITEM_MOD_AGILITY_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Refuge
        -- (2) Increases attack power by 40.
        -- (4) Increases your movement speed by 15% while in Bear Form, Cat Form, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [551] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Wrath of Spellfire
        -- (3) Increases spell damage by up to 7% of your total Intellect.
    [552] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=32, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Shadow's Embrace
        -- (3) Your Frost and Shadow damage spells heal you for 2% of the damage they deal.
    [553] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=32, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Primal Mooncloth
        -- (3) Allow 5% of your Mana regeneration to continue while casting.
    [554] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}} },
    -- Netherweave Vestments
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases your spell critical strike rating by 14.
    [555] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=14}} },
    -- Imbued Netherweave
        -- (3) Increases your spell critical strike rating by 28.
    [556] = { [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=28}} },
    -- Soulcloth Embrace
        -- (3) Increases your spell hit rating by 16.
    [557] = { [3]={stats={ITEM_MOD_HIT_SPELL_RATING_SHORT=16}} },
    -- Arcanoweave Vestments
        -- (3) Increases your spell hit rating by 16.
    [558] = { [3]={stats={ITEM_MOD_HIT_SPELL_RATING_SHORT=16}} },
    -- Spellstrike Infusion
        -- (2) Gives a chance when your harmful spells land to increase the damage of your spells and effects by X for X.
    [559] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=32, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Fel Iron Plate
        -- (2) Increases your melee hit rating by 15.
        -- (4) +20 Strength.
    [560] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=15}}, [4]={stats={ITEM_MOD_STRENGTH_SHORT=20}} },
    -- Fel Iron Chain
        -- (2) Increases your critical strike rating by 14.
        -- (4) Restores 8 mana per 5 sec.
    [561] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=14}}, [4]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=8}} },
    -- Adamantite Battlegear
        -- (3) +4 Weapon Damage.
    [562] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=32, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Enchanted Adamantite Armor
        -- (3) Increases your parry rating by 20.
    [563] = { [3]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}} },
    -- Flame Guard
        -- (3) Increases your parry rating by 20.
    [564] = { [3]={stats={ITEM_MOD_PARRY_RATING_SHORT=20}} },
    -- Khorium Ward
        -- (3) Increases healing done by up to 55 and damage done by up to 19 for all magical spells and effects.
    [565] = { [3]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=55, ITEM_MOD_SPELL_POWER_SHORT=19}} },
    -- Burning Rage
        -- (2) Increases your hit rating by 20.
    [566] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=20}} },
    -- Gladiator's Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
    [567] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Gladiator's Dreadgear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the casting time of your Fear spell by 0.2.1 sec.
    [568] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Faith in Felsteel
        -- (3) +25 Strength.
    [569] = { [3]={stats={ITEM_MOD_STRENGTH_SHORT=25}} },
    -- The Unyielding
        -- (2) Increases resilience by 20.
    [570] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=20}} },
    -- Whitemend Wisdom
        -- (2) Increases healing by up to 10% of your total Intellect.
    [571] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=32, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Battlecast Garb
        -- (2) Increases the chance spell pushback and spell interrupt will be resisted by 5%.
    [572] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Fel Skin
        -- (3) Increases your dodge rating by 20.
    [573] = { [3]={stats={ITEM_MOD_DODGE_RATING_SHORT=20}} },
    -- Strength of the Clefthoof
        -- (3) +20 Strength.
    [574] = { [3]={stats={ITEM_MOD_STRENGTH_SHORT=20}} },
    -- Felstalker Armor
        -- (3) Increases your hit rating by 20.
    [575] = { [3]={stats={ITEM_MOD_HIT_RATING_SHORT=20}} },
    -- Fury of the Nether
        -- (3) +20 Intellect.
    [576] = { [3]={stats={ITEM_MOD_INTELLECT_SHORT=20}} },
    -- Gladiator's Vestments
        -- (2) +35 Resilience Rating.
        -- (4) Increases your maximum Energy by 10.
    [577] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=54, ITEM_MOD_SPELL_POWER_SHORT=27}} },
    -- Gladiator's Earthshaker
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Stormstrike ability by 1 sec.
    [578] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Gladiator's Regalia
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the casting time of your Polymorph spell by 0.1.2 sec.
    [579] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=54, ITEM_MOD_SPELL_POWER_SHORT=27}} },
    -- Gladiator's Thunderfist
        -- (2) +35 Resilience Rating.
        -- (4) Gives you a 50% chance to avoid interruption caused by damage while casting Lightning Bolt.
    [580] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Gladiator's Raiment
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the duration of the Weakened Soul effect caused by your Power Word: Shield by 2 sec.
    [581] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Gladiator's Aegis
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Hammer of Justice by 10 sec.
    [582] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Gladiator's Vindication
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Hammer of Justice by 10 sec.
    [583] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Gladiator's Sanctuary
        -- (2) +35 Resilience Rating.
        -- (4) Increases your movement speed by 15% while in Bear Form, Cat Form, or Travel Form. Only active outdoors.
    [584] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}} },
    -- Gladiator's Wildhide
        -- (2) +35 Resilience Rating.
        -- (4) Your Wrath casts have a chance to reduce the cast time on your next Starfire by 1.5 sec.
    [585] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=54, ITEM_MOD_SPELL_POWER_SHORT=27}} },
    -- Gladiator's Pursuit
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Multi-Shot ability by 1 sec.
    [586] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Felscale Armor
        -- (2) Increases your critical strike rating by 15.
        -- (4) +20 Stamina.
    [611] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=15}}, [4]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Scaled Draenic Armor
        -- (2) Increases your spell critical strike rating by 15.
        -- (4) Increases damage and healing done by magical spells and effects by up to 18.
    [612] = { [2]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=15}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Thick Draenic Armor
        -- (2) Increases your hit rating by 15.
        -- (4) Increases your critical strike rating by 15.
    [613] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=15}}, [4]={stats={ITEM_MOD_CRIT_RATING_SHORT=15}} },
    -- Wild Draenish Armor
        -- (2) Increases healing done by up to 33 and damage done by up to 11 for all magical spells and effects.
        -- (4) +20 Stamina.
    [614] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=33, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Gladiator's Felshroud
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the casting time of your Fear spell by 0.2.1 sec.
    [615] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Netherscale Armor
        -- (3) Increases your hit rating by 20.
    [616] = { [3]={stats={ITEM_MOD_HIT_RATING_SHORT=20}} },
    -- Netherstrike Armor
        -- (3) Increases damage and healing done by magical spells and effects by up to 23.
    [617] = { [3]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Windhawk Armor
        -- (3) Restores 8 mana per 5 sec.
    [618] = { [3]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=8}} },
    -- Primal Intent
        -- (3) Increases attack power by 40.
    [619] = { [3]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Assassination Armor
        -- (2) Your Cheap Shot and Kidney Shot attacks grant you X haste rating for X.
        -- (4) Your Eviscerate and Envenom abilities cost 10 less energy.
    [620] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Netherblade
        -- (2) Increases the duration of your Slice and Dice ability by 3 sec.
        -- (4) Your finishing moves have a X% chance to grant you a combo point.
    [621] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Deathmantle
        -- (2) Your Eviscerate and Envenom abilities cause 40 extra damage per combo point.
        -- (4) Your attacks have a chance to make your next finishing move cost no energy.
    [622] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Righteous Armor
        -- (2) Your Consecration ability costs 15% less mana.
        -- (4) Reduces the cooldown on your Righteous Defense ability by 2 sec.
    [623] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Justicar Raiment
        -- (2) Increases the amount healed by your Judgement of Light by 20.
        -- (4) Reduces the cooldown on your Divine Favor ability by 15 sec.
    [624] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Justicar Armor
        -- (2) Increases the damage dealt by your Seal of Righteousness, Seal of Vengeance, or Seal of $?fac[Blood][the Martyr] by 10%.
        -- (4) Increases the damage dealt by your Holy Shield by 15.
    [625] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Justicar Battlegear
        -- (2) Increases the damage bonus of your Judgement of the Crusader by 15%.
        -- (4) Increases the damage dealt by your Judgement of Command by 10%.
    [626] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Crystalforge Raiment
        -- (2) Each time you cast a Judgement, your party members gain X mana.
        -- (4) Your critical heals from Flash of Light and Holy Light reduce the cast time of your next Holy Light spell by X.2 sec for X. This effect cannot occur more than once per minute.
    [627] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Crystalforge Armor
        -- (2) Increases the damage from your Retribution Aura by 15.
        -- (4) Each time you use your Holy Shield ability, you gain X block value against a single attack in the next X.
    [628] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Crystalforge Battlegear
        -- (2) Reduces the cost of your Judgements by 35.
        -- (4) Each time you cast a Judgement, there is a chance it will heal all nearby party members for X.
    [629] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Tidefury Raiment
        -- (2) Your Chain Lightning Spell now only loses 17% of its damage per jump.
        -- (4) Your Water Shield ability grants an additional 56 mana each time it triggers and an additional 3 mana per 5 sec.
    [630] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Cyclone Raiment
        -- (2) Your Mana Spring Totem ability grants an additional 3 mana every 2 sec.
        -- (4) Reduces the cooldown on your Nature's Swiftness ability by 24 sec.
    [631] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Cyclone Regalia
        -- (2) Your Wrath of Air Totem ability grants an additional 20 spell damage.
        -- (4) Your offensive spell critical strikes have a chance to reduce the base mana cost of your next spell by X.
    [632] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Cyclone Harness
        -- (2) Your Strength of Earth Totem ability grants an additional 12 strength.
        -- (4) Your Stormstrike ability does an additional 30 damage per weapon.
    [633] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Cataclysm Raiment
        -- (2) Reduces the cost of your Lesser Healing Wave spell by 5%.
        -- (4) Your critical heals from Healing Wave, Lesser Healing Wave, and Chain Heal reduce the cast time of your next Healing Wave spell by X.2 sec for X. This effect cannot occur more than once per minute.
    [634] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Cataclysm Regalia
        -- (2) Each time you cast an offensive spell, there is a chance your next Lesser Healing Wave will cost X less mana.
        -- (4) Your Lightning Bolt critical strikes have a chance to grant you X mana.
    [635] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Cataclysm Harness
        -- (2) Your melee attacks have a chance to reduce the cast time of your next Lesser Healing Wave by X.1 sec.
        -- (4) You gain 5% additional haste from your Flurry ability.
    [636] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Moonglade Raiment
        -- (2) Your Rejuvenation spell now also grants 35 dodge rating.
        -- (4) Reduces the mana cost of all shapeshifting by 25%.
    [637] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Malorne Raiment
        -- (2) Your helpful spells have a chance to restore up to 120 mana.
        -- (4) Reduces the cooldown on your Nature's Swiftness ability by 24 sec.
    [638] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Malorne Regalia
        -- (2) Your harmful spells have a chance to restore up to 120 mana.
        -- (4) Reduces the cooldown on your Innervate ability by 48 sec.
    [639] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Malorne Harness
        -- (2) Your melee attacks in Bear Form and Dire Bear Form have a chance to generate X additional rage. / Your melee attacks in Cat Form have a chance to generate X additional energy.
        -- (4) Increases your armor by 1400 in Bear Form and Dire Bear Form. / Increases your strength by 30 in Cat Form.
    [640] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=72, ITEM_MOD_SPELL_POWER_SHORT=36}}, [4]={stats={ITEM_MOD_ARMOR_SHORT=1400, ITEM_MOD_STRENGTH_SHORT=30}} },
    -- Nordrassil Harness
        -- (2) When you shift out of Bear Form, Dire Bear Form, or Cat Form, your next Regrowth spell takes X.1 fewer sec. to cast.
        -- (4) Your Shred ability deals an additional 75 damage, and your Lacerate ability does an additional 15 per application.
    [641] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Nordrassil Raiment
        -- (2) Increases the duration of your Regrowth spell by 6 sec.
        -- (4) Increases the final amount healed by your Lifebloom spell by 150.
    [642] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Nordrassil Regalia
        -- (2) When you shift out of Moonkin Form, your next Regrowth spell costs X less mana.
        -- (4) Increases your Starfire damage against targets afflicted with Moonfire or Insect Swarm by 10%.
    [643] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Oblivion Raiment
        -- (2) Grants your pet 45 mana per 5 sec.
        -- (4) Your Seed of Corruption deals 180 additional damage when it detonates.
    [644] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Voidheart Raiment
        -- (2) Your shadow damage spells have a chance to grant you X bonus shadow damage for X. / Your fire damage spells have a chance to grant you X bonus fire damage for X.
        -- (4) Increases the duration of your Corruption and Immolate abilities by 3 sec.
    [645] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=72, ITEM_MOD_SPELL_POWER_SHORT=36}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Corruptor Raiment
        -- (2) Causes your pet to be healed for 15% of the damage you deal.
        -- (4) Your Shadowbolt spell hits increase the damage of Corruption by 10% and your Incinerate spell hits increase the damage of Immolate by 10%.
    [646] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Incanter's Regalia
        -- (2) Reduces cast time on your Flamestrike ability by 0.2.2 sec.
        -- (4) When you are hit while Mana Shield is active, you have a chance to gain up to X spell damage for X.
    [647] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Aldor Regalia
        -- (2) Gives you a 100% chance to avoid interruption caused by damage while casting Fireball or Frostbolt.
        -- (4) Reduces the cooldown on Presence of Mind by 24 sec, on Blast Wave by 4 sec, and on Ice Block by 40 sec.
    [648] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Tirisfal Regalia
        -- (2) Increases the damage and mana cost of Arcane Blast by 20%.
        -- (4) Your spell critical strikes grant you up to X spell damage for X.
    [649] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Beast Lord Armor
        -- (2) Reduces the cooldown on your traps by 4 sec.
        -- (4) Each time you use your Kill Command ability, your attacks ignore X of your victim's armor for X.
    [650] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Demon Stalker Armor
        -- (2) Reduces the chance your Feign Death ability will be resisted by 5%.
        -- (4) Reduces the mana cost of your Multi-Shot ability by 10%.
    [651] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Rift Stalker Armor
        -- (2) Causes your pet to be healed for 15% of the damage you deal.
        -- (4) Your Steady Shot ability has 5% increased critical strike chance.
    [652] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Bold Armor
        -- (2) All of your shout abilities cost X less rage.
        -- (4) Your Charge ability generates an additional X rage.
    [653] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Warbringer Armor
        -- (2) You have a chance each time you parry to gain Blade Turning, absorbing X damage for X.
        -- (4) Your Revenge ability causes your next damaging ability to do X% more damage.
    [654] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Warbringer Battlegear
        -- (2) Your Whirlwind ability costs X less rage.
        -- (4) You gain an additional X rage each time one of your attacks is parried or dodged.
    [655] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Destroyer Armor
        -- (2) Each time you use your Shield Block ability, you gain X block value against a single attack in the next X.
        -- (4) You have a chance each time you are hit to gain X haste rating for X.
    [656] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Destroyer Battlegear
        -- (2) Your Overpower ability now grants you X attack power for X.
        -- (4) Your Bloodthirst and Mortal Strike abilities cost 5 less rage.
    [657] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Mana-Etched Regalia
        -- (2) Increases your spell hit rating by 35.
        -- (4) Your harmful spells have a chance to grant you up to X spell damage and healing for X.
    [658] = { [2]={stats={ITEM_MOD_HIT_SPELL_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Wastewalker Armor
        -- (2) Increases your hit rating by 35.
        -- (4) Your attacks have a chance to grant you X attack power for X.
    [659] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Desolation Battlegear
        -- (2) Increases your hit rating by 35.
        -- (4) Your attacks have a chance to grant you X attack power for X.
    [660] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Doomplate Battlegear
        -- (2) Increases your hit rating by 35.
        -- (4) Your attacks have a chance to grant you X attack power for X.
    [661] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Hallowed Raiment
        -- (2) Gives you a 30% chance to avoid interruption caused by damage while casting Binding Heal.
        -- (4) Your Prayer of Mending heals an additional 100 health.
    [662] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Incarnate Raiment
        -- (2) Your Prayer of Healing spell now also causes an additional X healing over X.
        -- (4) Each time you cast Flash Heal, your next Greater Heal cast within X has its casting time reduced by X.1, stacking up to 5 times.
    [663] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Incarnate Regalia
        -- (2) Your Shadowfiend now has 75 more stamina and lasts 3 sec. longer.
        -- (4) Your Mind Flay and Smite spells deal 5% more damage.
    [664] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Avatar Raiment
        -- (2) If your Greater Heal brings the target to full health, you gain X mana.
        -- (4) Increases the duration of your Renew spell by 3 sec.
    [665] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Avatar Regalia
        -- (2) Each time you cast an offensive spell, there is a chance your next spell will cost X less mana.
        -- (4) Each time your Shadow Word: Pain deals damage, it has a chance to grant your next spell cast within X up to X damage and healing.
    [666] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- The Twin Stars
        -- (2) Increases damage and healing done by magical spells and effects by up to 15.
    [667] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Slayer's Armor
        -- (2) Increases the haste from your Slice and Dice ability by 5%.
        -- (4) Increases the damage dealt by your Backstab, Sinister Strike, Mutilate, and Hemorrhage abilities by 6%.
    [668] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Gronnstalker's Armor
        -- (2) Increases the mana you gain from your Aspect of the Viper by an additional 5% of your Intellect.
        -- (4) Increases the damage dealt by your Steady Shot ability by 10%.
    [669] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Malefic Raiment
        -- (2) Each time one of your Corruption or Immolate spells deals periodic damage, you heal X health.
        -- (4) Increases the damage dealt by your Shadow Bolt and Incinerate abilities by 6%.
    [670] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Tempest Regalia
        -- (2) Increases the duration of your Evocation ability by 2 sec.
        -- (4) Increases the damage of your Fireball, Frostbolt, and Arcane Missiles abilities by 5%.
    [671] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Onslaught Battlegear
        -- (2) Reduces the rage cost of your Execute ability by X.
        -- (4) Increases the damage of your Mortal Strike and Bloodthirst abilities by 5%.
    [672] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Onslaught Armor
        -- (2) Increases the health bonus from your Commanding Shout ability by 170.
        -- (4) Increases the damage of your Shield Slam ability by 10%.
    [673] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Absolution Regalia
        -- (2) Increases the duration of your Shadow Word: Pain ability by 3 sec.
        -- (4) Increases the damage from your Mind Blast ability by 10%.
    [674] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Vestments of Absolution
        -- (2) Reduces the mana cost of your Prayer of Healing ability by 10%.
        -- (4) Increases the healing from your Greater Heal ability by 5%.
    [675] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Thunderheart Harness
        -- (2) Reduces the energy cost of your Mangle ability in Cat Form by 5 and increases the threat generated by your Mangle ability in Bear Form by 15%.
        -- (4) Increases the damage dealt by your Rip, Swipe, and Ferocious Bite abilities by 15%.
    [676] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Thunderheart Regalia
        -- (2) Increases the duration of your Moonfire ability by 3 sec.
        -- (4) Increases the critical strike chance of your Starfire ability by 5%.
    [677] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Thunderheart Raiment
        -- (2) Reduces the cooldown of your Swiftmend ability by 2 sec.
        -- (4) Increases the healing from your Healing Touch ability by 5%.
    [678] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Lightbringer Armor
        -- (2) Increases the mana gained from your Spiritual Attunement ability by 10%.
        -- (4) Increases the damage dealt by your Consecration ability by 10%.
    [679] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Lightbringer Battlegear
        -- (2) Your melee attacks have a chance to grant you X mana.
        -- (4) Increases the damage dealt by your Hammer of Wrath ability by 10%.
    [680] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Lightbringer Raiment
        -- (2) Increases the critical strike chance of your Holy Light ability by 5%.
        -- (4) Increases the healing from your Flash of Light ability by 5%.
    [681] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Skyshatter Harness
        -- (2) Your Earth Shock, Flame Shock, and Frost Shock abilities cost 10% less mana.
        -- (4) Whenever you use Stormstrike, you gain X attack power for X.
    [682] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Skyshatter Raiment
        -- (2) Your Chain Heal ability costs 10% less mana.
        -- (4) Increases the amount healed by your Chain Heal ability by 5%.
    [683] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Skyshatter Regalia
        -- (2) Whenever you have an air totem, an earth totem, a fire totem, and a water totem active at the same time, you gain X mana per 5 sec, X spell critical strike rating, and up to X spell damage.
        -- (4) Increases the damage dealt by your Lightning Bolt ability by 5%.
    [684] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=66, ITEM_MOD_SPELL_POWER_SHORT=33}} },
    -- Gladiator's Refuge
        -- (2) +35 Resilience Rating.
        -- (4) The casting time on your Regrowth spell is reduced by 0.2.2 sec.
    [685] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=54, ITEM_MOD_SPELL_POWER_SHORT=27}} },
    -- Gladiator's Wartide
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Grounding Totem ability by 1.5.1 sec.
    [686] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Gladiator's Investiture
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the duration of the Weakened Soul effect caused by your Power Word: Shield by 2 sec.
    [687] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Gladiator's Redemption
        -- (2) +35 Resilience Rating.
        -- (4) Increases the healing from your Holy Shock spell by X%.
    [690] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=54, ITEM_MOD_SPELL_POWER_SHORT=27}} },
    -- Champion's Redoubt
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (3) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) +20 Stamina.
    [697] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Warlord's Aegis
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [698] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- The Twin Blades of Azzinoth
        -- (2) Your melee attacks have a chance to increase your haste rating by X for X. / Increases attack power by 200 when fighting Demons.
    [699] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=70, ITEM_MOD_SPELL_POWER_SHORT=35}} },
    -- Field Marshal's Earthshaker
        -- (2) +20 Stamina.
        -- (3) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) Increases attack power by 40.
    [717] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Lieutenant Commander's Earthshaker
        -- (2) Increases attack power by 40.
        -- (4) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +20 Stamina.
    [718] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- The Fists of Fury
        -- (2) Chance to bathe your enemy in flame causing X Fire damage to your target.
    [719] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=42, ITEM_MOD_SPELL_POWER_SHORT=21}} },
    -- Latro's Flurry
        -- (2) Increases attack power by 30.
    [737] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Oathbound's Opportunistic Vestments
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
    [2013] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Savage Plate Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
    [2014] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Ornamented Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Increases the healing from your Holy Shock spell by X%.
    [2015] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Oathbound's Scaled Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Hammer of Justice by 10 sec.
    [2016] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Ringmail Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Nature's Swiftness ability by 24 sec.
    [2017] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Mail Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Improves your chance to get a critical strike with all Shock spells by 2%.
    [2018] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Oathbound's Linked Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Stormstrike ability by 1 sec.
    [2019] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Chain Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Concussive Shot by 1 sec.
    [2020] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Silk Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the cooldown of your Blink spell by 2 sec.
    [2021] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Dreadweave Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the casting time of your Fear spell by 0.2.1 sec.
    [2022] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Mooncloth Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the duration of the Weakened Soul effect caused by your Power Word: Shield by 2 sec.
    [2023] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Satin Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Reduces the duration of the Weakened Soul effect caused by your Power Word: Shield by 2 sec.
    [2024] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Oathbound's Dragonhide Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Increases your movement speed by 15% while in Bear Form, Cat Form, or Travel Form. Only active outdoors.
    [2025] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}} },
    -- Oathbound's Wyrmhide Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) Your Wrath casts have a chance to reduce the cast time on your next Starfire by 1.5 sec.
    [2026] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
    -- Oathbound's Kodohide Battlegear
        -- (2) +35 Resilience Rating.
        -- (4) The casting time on your Regrowth spell is reduced by 0.2.2 sec.
    [2027] = { [2]={stats={ITEM_MOD_RESILIENCE_RATING_SHORT=35}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=50, ITEM_MOD_SPELL_POWER_SHORT=25}} },
}

-- =============================================================
-- PROC DATABASE (Dynamic PPM / Cooldown Logic)
-- Scoring lookup: ProcDB -> WeaponDB -> TrinketDB in Helpers.GetRawItemStats.
-- An entry with ppm/val/stat ADDS its average value to the item's own stats
-- (a use effect is ppm = 60 / cooldown in sec, with dur). An entry with
-- score REPLACES the item's whole score, so score is only for items whose
-- value is all in the effect (no stats worth scoring).
-- Use-effect values checked against the TBC Anniversary client (ItemEffect /
-- SpellEffect, build 2.5.6.69795). Neltharion's Tear, Drake Fang Talisman,
-- Flurry Axe and the kill-triggered trinkets score from their own stats.
-- =============================================================
MSC.ProcDB = {
    -- [[ WEAPONS ]]
    [19019] = { ppm=6.0, val=300, stat="MSC_WEAPON_DPS", note = MSC.L["Chance on hit: 300 Nature Dmg"] }, -- Thunderfury
    [7717]  = { ppm=1.0, val=15, stat="MSC_WEAPON_DPS", note = MSC.L["Chance to Trigger Bladestorm"] }, -- Ravager

    -- [[ TRINKETS WITH STATS: use effect added on top ]]
    [23041] = { ppm=0.5, val=260, dur=20, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Attack Power Use Effect"] }, -- Slayer's Crest
    [23046] = { ppm=0.5, val=130, dur=20, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Spell Power Use Effect"] }, -- Restrained Essence of Sapphiron
    [23047] = { ppm=0.5, val=450, dur=12, stat="ITEM_MOD_SPELL_HEALING_DONE_SHORT", note = MSC.L["Healing/Damage Charge System"] }, -- Eye of the Dead (5 charges)

    -- [[ USE-ONLY TRINKETS ]]
    [18820] = { ppm=0.67, val=175, dur=15, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Spell Power Use Effect"] }, -- Talisman of Ephemeral Power
    [19950] = { ppm=0.5, val=100, dur=20, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Decreasing Spell Power/Damage"] }, -- Zandalarian Hero Charm (204, -17 per cast)
    [21180] = { ppm=0.5, val=280, dur=20, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Attack Power Use Effect"] }, -- Earthstrike
    [23570] = { ppm=0.5, val=357, dur=20, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Ramping Attack Power"] }, -- Jom Gabbar (65 + 65 per 2 sec)
    [20130] = { ppm=0.17, val=75, dur=60, stat="ITEM_MOD_STRENGTH_SHORT", note = MSC.L["Strength Use Effect"] }, -- Diamond Flask (+75 Str for 60 sec, 6 min cooldown)
    [21670] = { ppm=0.33, val=600, dur=30, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Armor Penetration Proc"] }, -- Badge of the Swarmguard (stacks to 1200 armor ignored over 30 sec, 3 min cooldown)
    [22954] = { ppm=0.5, val=200, dur=15, stat="ITEM_MOD_HASTE_RATING_SHORT", note = MSC.L["Haste Use Effect"] }, -- Kiss of the Spider (200 haste rating for 15 sec)
    [19339] = { ppm=0.2, val=331, dur=20, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", note = MSC.L["Haste Use Effect (Mage Only)"] }, -- Mind Quickening Gem (331 spell haste rating for 20 sec, 5 min cooldown)
    [21625] = { score=40, note = MSC.L["Heals Grant Shield"] }, -- Scarab Brooch
    [19341] = { score=40, note = MSC.L["Health Use Effect"] }, -- Lifegiving Gem

    -- [[ ENGINEERING ]]
    [10725] = { score=15, note = MSC.L["Summons Battle Chicken (Haste Buff)"] }, -- Gnomish Battle Chicken
    [16022] = { score=10, note = MSC.L["Summons Dragonling (Fire Vuln.)"] }, -- Arcanite Dragonling
    [10645] = { score=10, note = MSC.L["Burst Damage (Life Cost)"] }, -- Gnomish Death Ray
    [2820]  = { score=5,  note = MSC.L["Run Speed Use Effect"] }, -- Nifty Stopwatch
    [11905] = { score=10, note = MSC.L["Ranged Damage/Stun/Daze"] }, -- Linken's Boomerang

    -- [[ TBC: EXTRA ATTACKS & WEAPON PROCS ]]
    [11684] = { ppm=1.0, val=0, stat="ITEM_MOD_MELEE_ATTACK_POWER_SHORT", note = MSC.L["Chance on hit: 2 Extra Attacks"] }, -- Ironfoe
    [11815] = { ppm=1.0, val=0, stat="ITEM_MOD_MELEE_ATTACK_POWER_SHORT", note = MSC.L["Chance on hit: 1 Extra Attack (2s CD)"] }, -- Hand of Justice

    -- [[ TBC: DAMAGE PROCS (val is the raw damage) ]]
    [12805] = { ppm=1.0, val=60, stat="MSC_WEAPON_DPS", note = MSC.L["Chance on hit: 60 Avg Fire Dmg"] }, -- Orb of Fire
    [19289] = { ppm=1.0, val=250, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 250 Nature Dmg Proc"] }, -- Darkmoon Card: Maelstrom
    [28579] = { ppm=1.0, val=277, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 277 Nature Poison Dmg Proc"] }, -- Romulo's Poison Vial
    [34470] = { ppm=4.0, val=380, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 380 Avg Dmg on DoT tick (15s CD)"] }, -- Timbal's Focusing Crystal
    [28785] = { ppm=24.0, val=750, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 750 Avg Dmg every 3 Crits (2.5s CD)"] }, -- The Lightning Capacitor

    -- [[ TBC: STRUCK IN COMBAT / DEFENSIVE PROCS ]]
    [11302] = { score=20, note = MSC.L["Equip: 2% Chance on Struck for Holy Shield"] }, -- Uther's Strength
    [11810] = { ppm=0.3, val=25, stat="ITEM_MOD_BLOCK_VALUE_SHORT", note = MSC.L["Equip: 1% Chance on Struck for -25 Dmg Taken"] }, -- Force of Will
    [14557] = { ppm=0.3, val=250, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Equip: 1% Chance on Struck for 250 Party Armor"] }, -- The Lion Horn of Stormwind
    [17774] = { ppm=0.5, val=25, stat="ITEM_MOD_ALL_STATS", note = MSC.L["Equip: 2% Chance on Struck for +25 All Stats"] }, -- Mark of the Chosen
    [34473] = { ppm=2.0, val=152, stat="ITEM_MOD_DODGE_RATING_SHORT", note = MSC.L["Equip: 152 Dodge at <35% HP (30s CD)"] }, -- Commendation of Kael'thas
    [185986]= { ppm=0.5, val=350, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Equip: 2% Chance on Struck for 350 Armor"] }, -- Communal Stone of Durability

    -- [[ TBC: HEALING & MANA PROCS / DARKMOON CARDS ]]
    [19287] = { ppm=1.0, val=150, stat="ITEM_MOD_HEALTH_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Heal on melee"] }, -- Darkmoon Card: Heroism
    [19288] = { score=50, note = MSC.L["Equip: 100% Mana Regen while casting (15s)"] }, -- Darkmoon Card: Blue Dragon
    [19290] = { score=20, note = MSC.L["Chance to Self-Resurrect"] }, -- Darkmoon Card: Twisting Nether
    [27896] = { ppm=0.5, val=260, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 260 Mana on Struck"] }, -- Alembic of Infernal Power
    [27922] = { ppm=3.5, val=150, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Mana (17s CD)"] }, -- Mark of Defiance
    [27924] = { ppm=3.5, val=150, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Mana (17s CD)"] }, -- Mark of Defiance
    [27926] = { ppm=2.4, val=150, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Mana (25s CD)"] }, -- Mark of Vindication
    [27927] = { ppm=2.4, val=150, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 150 Avg Mana (25s CD)"] }, -- Mark of Vindication
    [28823] = { ppm=1.0, val=450, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 2% Chance on Heal for Free Cast (450 Mana)"] }, -- Eye of Gruul
    [30619] = { ppm=4.0, val=500, stat="ITEM_MOD_HEALTH_REGENERATION_SHORT", note = MSC.L["Equip: 500 HoT (15s CD)"] }, -- Fel Reaver's Piston
    [30663] = { ppm=1.5, val=335, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 335 Mana (40s CD)"] }, -- Fathom-Brooch of the Tidewalker
    [32496] = { ppm=1.2, val=76, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: 76 mp5 proc (50s CD)"] }, -- Memento of Tyrande
    [28370] = { ppm=1.2, val=30, dur=15, stat="ITEM_MOD_MANA_REGENERATION_SHORT", note = MSC.L["Equip: Mana Regen Proc (50s CD)"] }, -- Bangle of Endless Blessings (regen while casting, about 30 mp5 for 15 sec)

    -- [[ TBC: STAT PROCS (val is the full stat amount) ]]
    [27683] = { ppm=1.33, val=320, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", note = MSC.L["Equip: 320 Haste (45s CD)"] }, -- Quagmirran's Eye
    [28034] = { ppm=1.2, val=300, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 300 AP (50s CD)"] }, -- Hourglass of the Unraveller
    [28190] = { ppm=1.33, val=320, stat="ITEM_MOD_SPELL_HASTE_RATING_SHORT", note = MSC.L["Equip: 320 Haste (45s CD)"] }, -- Scarab of the Infinite Cycle
    [28418] = { ppm=1.33, val=225, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 225 SP (45s CD)"] }, -- Shiffar's Nexus-Horn
    [30450] = { ppm=2.0, val=1000, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Equip: 1000 ArP (30s CD)"] }, -- Warp-Spring Coil
    [30447] = { ppm=1.33, val=290, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 290 SP (45s CD)"] }, -- Tome of Fiery Redemption
    [28830] = { ppm=3.0, val=325, stat="ITEM_MOD_HASTE_RATING_SHORT", note = MSC.L["Equip: 325 Haste (20s CD)"] }, -- Dragonspine Trophy
    [30626] = { ppm=1.33, val=190, stat="ITEM_MOD_SPELL_POWER_SHORT", note = MSC.L["Equip: 190 SP (45s CD)"] }, -- Sextant of Unstable Currents
    [30627] = { ppm=1.33, val=340, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 340 AP (45s CD)"] }, -- Tsunami Talisman
    [32505] = { ppm=1.0, val=300, stat="ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT", note = MSC.L["Equip: 300 ArP (~20% Uptime)"] }, -- Madness of the Betrayer
    [34427] = { ppm=1.33, val=440, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: Stacking AP Proc (440 Max / 45s CD)"] }, -- Blackened Naaru Sliver
    [34472] = { ppm=1.33, val=230, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 230 AP (45s CD)"] }, -- Shard of Contempt

    -- [[ TBC: STACKING HIGH-UPTIME PROCS (assumes max stacks) ]]
    [31856] = { ppm=10.0, val=120, stat="ITEM_MOD_ATTACK_POWER_SHORT", note = MSC.L["Equip: 120 Max AP / 80 Max SP (Stacking)"] }, -- Darkmoon Card: Crusade
    [31857] = { ppm=10.0, val=50, stat="ITEM_MOD_CRIT_RATING_SHORT", note = MSC.L["Equip: Stacking Crit"] }, -- Darkmoon Card: Wrath

    -- [[ TBC: CONDITIONAL / CLASS PROCS (items with no other stats) ]]
    [13209] = { score=40, note = MSC.L["Equip: 81 AP (vs Undead)"] }, -- Seal of the Dawn
    [32485] = { score=40, note = MSC.L["Equip: Warrior Proc (Heal + 55 Str)"] }, -- Ashtongue Talisman of Valor
    [32486] = { score=40, note = MSC.L["Equip: Druid Proc (Str / SP / Heal)"] }, -- Ashtongue Talisman of Equilibrium
    [32487] = { score=40, note = MSC.L["Equip: Hunter Proc (275 AP)"] }, -- Ashtongue Talisman of Swiftness
    [32488] = { score=40, note = MSC.L["Equip: Mage Proc (145 Haste)"] }, -- Ashtongue Talisman of Insight
    [32489] = { score=40, note = MSC.L["Equip: Paladin Proc (Heal / Dmg)"] }, -- Ashtongue Talisman of Zeal
    [32490] = { score=40, note = MSC.L["Equip: Priest Proc (220 SP / Heal)"] }, -- Ashtongue Talisman of Acumen
    [32491] = { score=40, note = MSC.L["Equip: Shaman Proc (Mana / 275 AP)"] }, -- Ashtongue Talisman of Vision
    [32492] = { score=40, note = MSC.L["Equip: Rogue Proc (145 Crit)"] }, -- Ashtongue Talisman of Lethality
    [32493] = { score=40, note = MSC.L["Equip: Warlock Proc (220 SP)"] }, -- Ashtongue Talisman of Shadows
    [30664] = { score=30, note = MSC.L["Equip: Druid Blessing (3% Proc)"] }, -- Living Root of the Wildheart

    -- [[ TBC: CRAFTED WEAPONS (melee haste procs) ]]
    [28437] = { ppm=1.0, val=212, dur=10, stat="ITEM_MOD_HASTE_RATING_SHORT" }, -- Drakefist Hammer
    [28438] = { ppm=1.0, val=212, dur=10, stat="ITEM_MOD_HASTE_RATING_SHORT" }, -- Dragonmaw
    [28439] = { ppm=1.0, val=212, dur=10, stat="ITEM_MOD_HASTE_RATING_SHORT" }, -- Dragonstrike
    [28429] = { ppm=1.0, val=100, dur=10, stat="ITEM_MOD_STRENGTH_SHORT" }, -- Lionheart Champion
    [28430] = { ppm=1.0, val=100, dur=10, stat="ITEM_MOD_STRENGTH_SHORT" }, -- Lionheart Executioner
}

-- ============================================================================
--  DATABASE BUILDER (Flattening ItemID Lookup Map)
-- ============================================================================

function MSC:BuildDatabase()
    MSC.ItemSetMap = {}
    if not MSC.SetDefinitions then return end

    local collisions = {}
    local seenItems = {}
    local definedSets = {}

    for setID, itemList in pairs(MSC.SetDefinitions) do
        definedSets[setID] = true
        for _, entry in ipairs(itemList) do
            if type(entry) == "table" then
                for _, itemID in ipairs(entry) do
                    if seenItems[itemID] and seenItems[itemID] ~= setID then
                        collisions[itemID] = { seenItems[itemID], setID }
                    else
                        seenItems[itemID] = setID
                    end
                    MSC.ItemSetMap[itemID] = setID
                end
            else
                if seenItems[entry] and seenItems[entry] ~= setID then
                    collisions[entry] = { seenItems[entry], setID }
                else
                    seenItems[entry] = setID
                end
                MSC.ItemSetMap[entry] = setID
            end
        end
    end

    if MSC.Debug then
        for itemID, sets in pairs(collisions) do
            print(string.format("|cffff0000SGJ|r Item %d mapped to sets %d and %d", itemID, sets[1], sets[2]))
        end
        if MSC.SetBonusScores then
            for setID, _ in pairs(definedSets) do
                if not MSC.SetBonusScores[setID] then
                    print(string.format("|cffff8800SGJ|r Set %d has no SetBonusScores entry", setID))
                end
            end
        end
    end

    MSC.SetDefinitions = nil
end
