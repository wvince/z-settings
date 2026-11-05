local _, MSC = ...

-- ============================================================================
-- CLASSIC ERA ITEM SETS, SET BONUSES AND PROCS
-- ============================================================================
-- Generated from the client's own tables (wago.tools, build 1.15.9.70003:
-- ItemSet, ItemSetSpell, SpellEffect, Spell) by
-- SharpiesGearJudge-Research/sets/gen_sets.py. Rerun it after a client
-- update instead of editing the set tables by hand.
--
-- SetBonusScores entries per piece count:
--   stats = bonuses that are plain stats, in the same units as this game's items
--           (1% hit = 1 Hit, 1% crit = 1 Crit, 1 skill point = 1). Added to the character's stat totals.
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
    [142] = { {15056,15057,15058,21278} }, -- Stormshroud Armor (ilvl 58)
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
    [1570] = { {209683,209671,209669} }, -- Twilight Invoker's Vestments (ilvl 30)
    [1571] = { {211263} }, -- Judgement Redoubt (ilvl 76)
    [1577] = { {211506,211504,211505} }, -- Blackfathom Avenger's Mail (ilvl 30)
    [1578] = { {211510,211511,211512} }, -- Blackfathom Slayer's Leather (ilvl 30)
    [1579] = { {211507,211508,211509} }, -- Blackfathom Elementalist's Hide (ilvl 30)
    [1584] = { {215377,215379,215378} }, -- Irradiated Garments (ilvl 45)
    [1585] = { {213313,213332,213341} }, -- Insulated Leathers (ilvl 45)
    [1586] = { {213312,213331,213342} }, -- Insulated Sorceror's Leathers (ilvl 45)
    [1587] = { {213311,213336,213329} }, -- Hyperconductive Wizard's Attire (ilvl 45)
    [1588] = { {213310,213328,213337} }, -- Hyperconductive Mender's Meditation (ilvl 45)
    [1589] = { {213316,213330,213335} }, -- H.A.Z.A.R.D. Suit (ilvl 45)
    [1590] = { {213314,213339,213333} }, -- Electromantic Devastator's Mail (ilvl 45)
    [1591] = { {213315,213334,213338} }, -- Electromantic Stormbringer's Chain (ilvl 45)
    [1592] = { {216486,216485,216484} }, -- Shockforged Warplate (ilvl 45)
    [1618] = { {220803,220796,220807,220800,220801,220798} }, -- Blood Guard's Plate (ilvl 53)
    [1619] = { {220794,220797,220804,220795,220806,220799} }, -- Knight-Lieutenant's Plate (ilvl 53)
    [1620] = { {220810,220808,220813,220809,220811,220812} }, -- Knight-Lieutenant's Imbued Plate (ilvl 53)
    [1621] = { {220819,220818,220815,220816,220814,220817} }, -- Knight-Lieutenant's Lamellar Plate (ilvl 53)
    [1622] = { {220820,220823,220826,220834,220835,220831} }, -- Blood Guard's Mail (ilvl 53)
    [1623] = { {220848,220849,220844,220847,220846,220845} }, -- Blood Guard's Pulsing Mail (ilvl 53)
    [1624] = { {220842,220841,220838,220839,220840,220843} }, -- Blood Guard's Inscribed Mail (ilvl 53)
    [1625] = { {220824,220821,220830,220836,220827,220833} }, -- Blood Guard's Chain (ilvl 53)
    [1626] = { {220828,220832,220825,220822,220829,220837} }, -- Knight-Lieutenant's Chain (ilvl 53)
    [1627] = { {220851,220853,220861,220857,220855,220859} }, -- Blood Guard's Leather (ilvl 53)
    [1628] = { {220854,220858,220850,220852,220860,220856} }, -- Knight-Lieutenant's Leather (ilvl 53)
    [1629] = { {220875,220877,220885,220881,220879,220883} }, -- Blood Guard's Restored Leather (ilvl 53)
    [1630] = { {220878,220882,220874,220876,220884,220880} }, -- Knight-Lieutenant's Restored Leather (ilvl 53)
    [1631] = { {220873,220871,220863,220867,220865,220869} }, -- Blood Guard's Crackling Leather (ilvl 53)
    [1632] = { {220864,220868,220872,220870,220862,220866} }, -- Knight-Lieutenant's Crackling Leather (ilvl 53)
    [1633] = { {220907,220905,220909,220908,220906,220904} }, -- Blood Guard's Dreadweave (ilvl 53)
    [1634] = { {220888,220886,220889,220887,220891,220890} }, -- Knight-Lieutenant's Dreadweave (ilvl 53)
    [1635] = { {220899,220901,220900,220898,220903,220902} }, -- Blood Guard's Satin (ilvl 53)
    [1636] = { {220892,220893,220896,220894,220895,220897} }, -- Knight Lieutenant's Satin (ilvl 53)
    [1637] = { {220783,220781,220784} }, -- Nightmare Prophet's Garb (ilvl 55)
    [1638] = { {220683,220684,220685} }, -- Benevolent Prophet's Vestments (ilvl 55)
    [1639] = { {220680,220679,220681} }, -- Malevolent Prophet's Vestments (ilvl 55)
    [1640] = { {220779,220778,220780} }, -- Coagulate Bloodguard's Leathers (ilvl 55)
    [1641] = { {220676,220678,220677} }, -- Blood Corrupted Leathers (ilvl 55)
    [1642] = { {220672,220673,220675} }, -- Lost Worshipper's Armor (ilvl 55)
    [1643] = { {220669,220671,220670} }, -- Exiled Prophet's Raiment (ilvl 55)
    [1644] = { {220665,220663,220664} }, -- Corrupted Spiritweaver's Mail (ilvl 55)
    [1645] = { {220657,220658,220659} }, -- Ostracized Berserker's Battlemail (ilvl 55)
    [1646] = { {220660,220661,220662} }, -- Shunned Devotee's Chainmail (ilvl 55)
    [1647] = { {220666,220667,220668} }, -- Dread Hunter's Chain (ilvl 55)
    [1648] = { {220650,220651,220652} }, -- Obsessed Prophet's Plate (ilvl 55)
    [1649] = { {220653,220654,220656} }, -- Wailing Berserker's Plate Armor (ilvl 55)
    [1650] = { {220642,220643,220648} }, -- Banished Martyr's Full Plate (ilvl 55)
    [1651] = { {220588,220589} }, -- Serpent's Ascension (ilvl 55)
    [1652] = { {221381,221380,221379,221378,221377,221376} }, -- Emerald Dream Plate (ilvl 50)
    [1653] = { {221387,221386,221385,221384,221383,221382} }, -- Emerald Encrusted Battleplate (ilvl 50)
    [1654] = { {221393,221392,221391,221390,221389,221388} }, -- Emerald Scalemail (ilvl 50)
    [1655] = { {221399,221398,221397,221396,221395,221394} }, -- Emerald Laden Chain (ilvl 50)
    [1656] = { {221405,221404,221403,221402,221401,221400} }, -- Emerald Chainmail (ilvl 50)
    [1657] = { {221411,221410,221409,221408,221407,221406} }, -- Emerald Leathers (ilvl 50)
    [1658] = { {221417,221416,221415,221414,221413,221412} }, -- Emerald Dreamkeeper Garb (ilvl 50)
    [1659] = { {221424,221423,221422,221421,221420,221419} }, -- Emerald Watcher Vestments (ilvl 50)
    [1660] = { {221431,221430,221429,221427,221426,221425} }, -- Emerald Enchanted Vestments (ilvl 50)
    [1661] = { {221438,221437,221436,221435,221434,221432} }, -- Emerald Woven Garb (ilvl 50)
    [1665] = { {223078,223077,223076,223075,223074,223073} }, -- Knight-Lieutenant's Mail (ilvl 53)
    [1666] = { {226712,226713,226714,226708,226711,226709,226710,226715} }, -- Wildheart Raiment (ilvl 60)
    [1667] = { {226821,226822,226820,226819,226818,226817,226816,226815} }, -- Feralheart Raiment (ilvl 62)
    [1668] = { {226718,226717,226722,226720,226721,226716,226719,226723} }, -- Beaststalker Armor (ilvl 60)
    [1669] = { {226903,226904,226902,226901,226900,226899,226898,226897} }, -- Beastmaster Armor (ilvl 62)
    [1670] = { {226724,226725,226730,226728,226731,226727,226726,226729} }, -- Magister's Regalia (ilvl 60)
    [1671] = { {226943,226944,226942,226941,226940,226939,226938,226937} }, -- Sorcerer's Regalia (ilvl 62)
    [1672] = { {226732,226738,226739,226734,226737,226733,226736,226735} }, -- Lightforge Armor (ilvl 60)
    [1673] = { {226999,227000,226998,226997,226996,226995,226994,226993} }, -- Soulforge Armor (ilvl 62)
    [1674] = { {226744,226742,226746,226740,226741,226745,226743,226747} }, -- Vestments of the Devout (ilvl 60)
    [1675] = { {226967,226968,226966,226965,226964,226963,226961,226962} }, -- Vestments of the Virtuous (ilvl 62)
    [1676] = { {226851,226852,226850,226849,226848,226847,226846,226845} }, -- Darkmantle Armor (ilvl 62)
    [1677] = { {226701,226703,226704,226707,226702,226705,226706,226700} }, -- Shadowcraft Armor (ilvl 60)
    [1678] = { {226751,226752,226755,226754,226748,226750,226753,226749} }, -- The Elements (ilvl 60)
    [1679] = { {227039,227040,227038,227037,227036,227035,227034,227033} }, -- The Five Thunders (ilvl 62)
    [1680] = { {226761,226759,226760,226756,226762,226757,226763,226758} }, -- Dreadmist Raiment (ilvl 60)
    [1681] = { {226927,226928,226926,226925,226924,226923,226922,226921} }, -- Deathmist Raiment (ilvl 62)
    [1682] = { {226765,226764,226766,226770,226771,226769,226767,226768} }, -- Battlegear of Valor (ilvl 60)
    [1698] = { {226658,226657,226656,226654,226653,226651,226652,226655} }, -- Cenarion Eclipse (ilvl 66)
    [1699] = { {226662,226664,226660,226659,226665,226663,226666,226661} }, -- Cenarion Cunning (ilvl 66)
    [1700] = { {226650,226645,226649,226648,226647,226646,226644,221785} }, -- Cenarion Bounty (ilvl 66)
    [1701] = { {226675,226670,226669,226671,226674,226667,226673,226668} }, -- Cenarion Rage (ilvl 66)
    [1702] = { {226529,226531,226530,226534,226527,226528,226533,226532} }, -- Giantstalker Pursuit (ilvl 66)
    [1703] = { {226537,226535,226542,226536,226540,226538,226543,226541} }, -- Giantstalker Prowess (ilvl 66)
    [1704] = { {226555,226558,226557,226562,226556,226561,226560,226559} }, -- Arcanist Insight (ilvl 66)
    [1705] = { {226570,226563,226569,226564,226565,226568,226566,226567} }, -- Arcanist Moment (ilvl 66)
    [1706] = { {226592,226593,226589,226610,226591,226590,226594,226588} }, -- Lawbringer Mercy (ilvl 66)
    [1707] = { {226601,226602,226599,226597,226600,226598,221783,226596} }, -- Lawbringer Radiance (ilvl 66)
    [1708] = { {226604,226595,226608,226607,226606,226605,226609,226603} }, -- Lawbringer Will (ilvl 66)
    [1709] = { {226571,226573,226577,226572,226576,226574,226575,226578} }, -- Dawn Prophecy (ilvl 66)
    [1710] = { {226580,226584,226582,226585,226583,226586,226581,226579} }, -- Twilight Prophecy (ilvl 66)
    [1711] = { {226440,226442,226447,226443,226446,226441,226445,226444} }, -- Nightslayer Thrill (ilvl 66)
    [1712] = { {226476,226473,226475,226480,226479,226478,226477,226474} }, -- Nightslayer Battlearmor (ilvl 66)
    [1713] = { {226616,226613,226618,226611,226615,226612,226614,226617} }, -- Earthfury Relief (ilvl 66)
    [1714] = { {226621,226623,226624,226619,226622,226625,226620,226626} }, -- Earthfury Eruption (ilvl 66)
    [1715] = { {226636,226642,226639,226635,226641,226637,226638,226640} }, -- Earthfury Impact (ilvl 66)
    [1716] = { {226630,226629,226632,226628,226631,226627,226633,226634} }, -- Earthfury Resolve (ilvl 66)
    [1717] = { {226551,226553,226552,226549,226547,226548,226550,226554} }, -- Corrupted Felheart (ilvl 66)
    [1718] = { {216920,216918,216922,216924,216921,216923,216925,216919} }, -- Wicked Felheart (ilvl 66)
    [1719] = { {226485,226484,226489,226486,226488,226490,226491,226487} }, -- Immoveable Might (ilvl 66)
    [1720] = { {226499,226497,226494,226495,226493,226492,226498,226496} }, -- Unstoppable Might (ilvl 66)
    [1721] = { {231535,231534,231530,231533,231531,231532} }, -- Warlord's Battlegear (ilvl 72)
    [1722] = { {231684,231687,231686,231683,231685,231688} }, -- Warlord's Sanctuary (ilvl 72)
    [1723] = { {231681,231678,231679,231680,231677,231682} }, -- Warlord's Wildhide (ilvl 72)
    [1724] = { {231674,231672,231675,231673,231671,231676} }, -- Warlord's Refuge (ilvl 72)
    [1725] = { {231571,231572,231573,231574,231570,231575} }, -- Warlord's Pursuit (ilvl 72)
    [1726] = { {231568,231565,231566,231567,231564,231569} }, -- Warlord's Prowess (ilvl 72)
    [1727] = { {231596,231601,231594,231595,231598,231597} }, -- Warlord's Regalia (ilvl 72)
    [1728] = { {231612,231611,231615,231610,231614,231613} }, -- Warlord's Raiment (ilvl 72)
    [1729] = { {231632,231631,231635,231630,231634,231633} }, -- Warlord's Investiture (ilvl 72)
    [1730] = { {231553,231551,231549,231554,231552,231555} }, -- Warlord's Vestments (ilvl 72)
    [1731] = { {231654,231657,231653,231655,231658,231656} }, -- Warlord's Earthshaker (ilvl 72)
    [1732] = { {231659,231663,231662,231661,231664,231660} }, -- Warlord's Thunderfist (ilvl 72)
    [1733] = { {231669,231665,231668,231670,231666,231667} }, -- Warlord's Wartide (ilvl 72)
    [1734] = { {231591,231592,231590,231588,231589,231593} }, -- Warlord's Threads (ilvl 72)
    [1735] = { {231696,231695,231699,231698,231700,231697} }, -- Field Marshal's Wildhide (ilvl 72)
    [1736] = { {231701,231705,231702,231706,231704,231703} }, -- Field Marshal's Refuge (ilvl 72)
    [1737] = { {231690,231689,231693,231694,231691,231692} }, -- Field Marshal's Sanctuary (ilvl 72)
    [1738] = { {231562,231557,231563,231558,231561,231560} }, -- Field Marshal's Prowess (ilvl 72)
    [1739] = { {231580,231576,231581,231577,231579,231578} }, -- Field Marshal's Pursuit (ilvl 72)
    [1740] = { {231604,231602,231603,231606,231607,231605} }, -- Field Marshal's Regalia (ilvl 72)
    [1741] = { {231616,231621,231618,231617,231619,231620} }, -- Field Marshal's Raiment (ilvl 72)
    [1742] = { {231622,231628,231624,231623,231626,231627} }, -- Field Marshal's Investiture (ilvl 72)
    [1743] = { {231545,231547,231543,231548,231546,231544} }, -- Field Marshal's Vestments (ilvl 72)
    [1744] = { {231649,231648,231651,231650,231647,231652} }, -- Field Marshal's Vindication (ilvl 72)
    [1745] = { {231641,231640,231645,231643,231646,231639} }, -- Field Marshal's Redemption (ilvl 72)
    [1746] = { {231584,231582,231583,231585,231586,231587} }, -- Field Marshal's Threads (ilvl 72)
    [1747] = { {231538,231537,231536,231540,231539,231541} }, -- Field Marshal's Battlegear (ilvl 72)
    [1748] = { {227188,227187,227186,227184,227189,227185} }, -- Champion's Wildhide (ilvl 68)
    [1749] = { {227204,227203,227205,227207,227206,227202} }, -- Champion's Refuge (ilvl 68)
    [1750] = { {227180,227181,227174,227175,227179,227177} }, -- Champion's Sanctuary (ilvl 68)
    [1751] = { {227081,227082,227080,227078,227083,227079} }, -- Champion's Prowess (ilvl 68)
    [1752] = { {227074,227075,227067,227069,227071,227073} }, -- Champion's Pursuit (ilvl 68)
    [1753] = { {227117,227110,227105,227104,227107,227106} }, -- Champion's Regalia (ilvl 68)
    [1754] = { {227133,227134,227132,227130,227131,227135} }, -- Champion's Raiment (ilvl 68)
    [1755] = { {227126,227127,227118,227120,227123,227124} }, -- Champion's Investiture (ilvl 68)
    [1756] = { {227063,227062,227057,227056,227060,227059} }, -- Champion's Vestments (ilvl 68)
    [1757] = { {227163,227164,227162,227160,227165,227161} }, -- Champion's Thunderfist (ilvl 68)
    [1758] = { {227170,227169,227166,227168,227171,227167} }, -- Champion's Wartide (ilvl 68)
    [1759] = { {227158,227159,227155,227154,227157,227156} }, -- Champion's Earthshaker (ilvl 68)
    [1760] = { {227099,227098,227090,227092,227097,227094} }, -- Champion's Threads (ilvl 68)
    [1761] = { {227050,227051,227043,227042,227049,227048} }, -- Champion's Battlegear (ilvl 68)
    [1762] = { {227195,227191,227194,227193,227192,227190} }, -- Lieutenant Commander's Wildhide (ilvl 68)
    [1763] = { {227200,227196,227198,227197,227199,227201} }, -- Lieutenant Commander's Refuge (ilvl 68)
    [1764] = { {227176,227178,227183,227182,227173,227172} }, -- Lieutenant Commander's Sanctuary (ilvl 68)
    [1765] = { {227089,227085,227087,227088,227086,227084} }, -- Lieutenant Commander's Prowess (ilvl 68)
    [1766] = { {227070,227072,227076,227077,227066,227068} }, -- Lieutenant Commander's Pursuit (ilvl 68)
    [1767] = { {227109,227108,227116,227112,227103,227102} }, -- Lieutenant Commander's Regalia (ilvl 68)
    [1768] = { {227137,227141,227139,227140,227138,227136} }, -- Lieutenant Commander's Raiment (ilvl 68)
    [1769] = { {227125,227122,227128,227129,227121,227119} }, -- Lieutenant Commander's Investiture (ilvl 68)
    [1770] = { {227058,227061,227065,227064,227055,227054} }, -- Lieutenant Commander's Vestments (ilvl 68)
    [1774] = { {227095,227096,227100,227101,227093,227091} }, -- Lieutenant Commander's Threads (ilvl 68)
    [1775] = { {227046,227047,227053,227052,227044,227045} }, -- Lieutenant Commander's Battlegear (ilvl 68)
    [1776] = { {227151,227150,227152,227153,227149,227148} }, -- Lieutenant Commander's Redemption (ilvl 68)
    [1777] = { {227142,227143,227147,227146,227144,227145} }, -- Lieutenant Commander's Vindication (ilvl 68)
    [1778] = { {226879,226880,226878,226877,226876,226875,226874,226873} }, -- Battlegear of Heroism (ilvl 62)
    [1779] = { {228145,228146,228147} }, -- Core Hound's Call (ilvl 69)
    [1780] = { {228297,228298} }, -- Shard of the Gods (ilvl 77)
    [1781] = { {228350,228349,228360,228759} }, -- Spirit of Eskhandar (ilvl 67)
    [1782] = { {228528,228524,228529,228527,228525} }, -- The Postmaster (ilvl 61)
    [1783] = { {228573,228592} }, -- Spider's Kiss (ilvl 60)
    [1784] = { {228653,228652} }, -- Dal'Rend's Arms (ilvl 63)
    [1785] = { {228596,228597,228598,228681,228066,228700,228038,228547} }, -- Ironweave Battlesuit (ilvl 62)
    [1786] = { {227999,228008,228002,228006,228000} }, -- Deathbone Guardian (ilvl 61)
    [1787] = { {228009,228011,228018,228010,228013} }, -- Necropile Raiment (ilvl 61)
    [1788] = { {228014,227998,228020,228012,228003} }, -- Bloodmail Regalia (ilvl 61)
    [1789] = { {227868,227867,227866} }, -- Volcanic Armor (ilvl 63)
    [1790] = { {227875,227874,227873} }, -- Blue Dragon Mail (ilvl 59)
    [1791] = { {227879,227878,227877} }, -- Green Dragon Mail (ilvl 54)
    [1792] = { {227829,227851,227852,227853} }, -- Black Dragon Mail (ilvl 66)
    [1793] = { {227848,227847} }, -- Devilsaur Armor (ilvl 65)
    [1795] = { {230867,231001} }, -- Zanzil's Concentration (ilvl 66)
    [1796] = { {230915,231000} }, -- Prayer of the Primal (ilvl 66)
    [1797] = { {230921,230929} }, -- Major Mojo Infusion (ilvl 65)
    [1798] = { {230934,230925} }, -- Primal Blessing (ilvl 68)
    [1799] = { {230943,230999} }, -- Overlord's Resolution (ilvl 66)
    [1800] = { {231309,230992} }, -- The Twin Blades of Hakkari (ilvl 70)
    [1801] = { {231246,231247,231248,231249,231250,231251,231252,231253} }, -- Eclipse of Stormrage (ilvl 76)
    [1802] = { {231230,231231,231232,231233,231234,231235,231236,231237} }, -- Bounty of Stormrage (ilvl 76)
    [1803] = { {231254,231255,231256,231257,231258,231259,231260,231261} }, -- Cunning of Stormrage (ilvl 76)
    [1804] = { {231238,231239,231240,231241,231242,231243,231244,231245} }, -- Fury of Stormrage (ilvl 76)
    [1805] = { {231062,231061,231060,231059,231058,231057,231056,231055} }, -- Dragonstalker's Pursuit (ilvl 76)
    [1806] = { {231071,231070,231069,231068,231067,231066,231065,231063} }, -- Dragonstalker's Prowess (ilvl 76)
    [1807] = { {231105,231101,231102,231103,231104,231106,231100,231107} }, -- Netherwind Insight (ilvl 76)
    [1808] = { {231113,231109,231110,231111,231112,231114,231108,231115} }, -- Netherwind Moment (ilvl 76)
    [1809] = { {231197,231196,231195,231194,231193,231192,231191,231190} }, -- Merciful Judgement (ilvl 76)
    [1810] = { {231181,231180,231179,231178,231177,231176,231175,231174} }, -- Radiant Judgement (ilvl 76)
    [1811] = { {231187,231189,231188,231186,231185,231184,231183,231182} }, -- Wilfull Judgement (ilvl 76)
    [1812] = { {231159,231155,231156,231157,231158,231160,231161,231162} }, -- Dawn of Transcendence (ilvl 76)
    [1813] = { {231169,231165,231166,231167,231168,231170,231171,231172} }, -- Twilight of Transcendence (ilvl 76)
    [1814] = { {231040,231041,231042,231043,231044,231039,231045,231046} }, -- Bloodfang Thrill (ilvl 76)
    [1815] = { {231048,231049,231050,231051,231052,231047,231053,231054} }, -- Bloodfang Battlearmor (ilvl 76)
    [1816] = { {231205,231204,231198,231203,231202,231201,231200,231199} }, -- Relief of the Ten Storms (ilvl 76)
    [1817] = { {231221,231220,231214,231219,231218,231217,231216,231215} }, -- Eruption of the Ten Storms (ilvl 76)
    [1818] = { {231229,231228,231222,231227,231226,231225,231224,231223} }, -- Impact of the Ten Storms (ilvl 76)
    [1819] = { {231213,231212,231206,231211,231210,231209,231208,231207} }, -- Resolve of the Ten Storms (ilvl 76)
    [1820] = { {231076,231072,231073,231074,231075,231077,231078,231079} }, -- Corrupted Nemesis (ilvl 76)
    [1821] = { {231095,231090,231091,231092,231093,231096,231097,231098} }, -- Wicked Nemesis (ilvl 76)
    [1822] = { {231030,231029,231028,231027,231026,231025,231024,231023} }, -- Immoveable Wrath (ilvl 76)
    [1823] = { {231038,231037,231036,231035,231034,231033,231032,231031} }, -- Unstoppable Wrath (ilvl 76)
    [1824] = { {231319,231318,231317,231316,231280} }, -- Haruspex's Garb (ilvl 66)
    [1825] = { {231323,231322,231321,231320,231288} }, -- Predator's Armor (ilvl 66)
    [1826] = { {231327,231325,231326,231324,231282} }, -- Illusionist's Attire (ilvl 66)
    [1827] = { {231329,231330,231331,231285,231328} }, -- Freethinker's Armor (ilvl 66)
    [1828] = { {231335,231334,231333,231332,231283} }, -- Confessor's Raiment (ilvl 66)
    [1829] = { {231339,231338,231337,231336,231287} }, -- Madcap's Outfit (ilvl 66)
    [1830] = { {231343,231342,231341,231340,231281} }, -- Augur's Regalia (ilvl 66)
    [1831] = { {231349,231348,231347,231346,231284} }, -- Demoniac's Threads (ilvl 66)
    [1832] = { {231353,231352,231351,231350,231286} }, -- Vindicator's Battlegear (ilvl 66)
    [1835] = { {233723,233722,233721,233720,233719} }, -- Genesis Bounty (ilvl 81)
    [1836] = { {233718,233717,233716,233715,233714} }, -- Genesis Eclipse (ilvl 81)
    [1837] = { {233412,233413,233415,233416,233414} }, -- Genesis Fury (ilvl 81)
    [1838] = { {233709,233713,233711,233710,233712} }, -- Genesis Cunning (ilvl 81)
    [1839] = { {233410,233409,233411,233408,233407} }, -- Striker's Pursuit (ilvl 82)
    [1840] = { {233666,233668,233664,233667,233665} }, -- Striker's Prowess (ilvl 82)
    [1841] = { {233404,233403,233406,233405,233402} }, -- Enigma Insight (ilvl 81)
    [1842] = { {233676,233677,233674,233675,233678} }, -- Enigma Moment (ilvl 81)
    [1843] = { {233687,233684,233688,233685,233686} }, -- Avenger's Mercy (ilvl 81)
    [1844] = { {233692,233689,233693,233690,233691} }, -- Avenger's Will (ilvl 81)
    [1845] = { {233398,233401,233397,233400,233399} }, -- Avenger's Radiance (ilvl 81)
    [1846] = { {233682,233681,233679,233683,233680} }, -- Dawn of the Oracle (ilvl 81)
    [1847] = { {233393,233394,233396,233392,233395} }, -- Twilight of the Oracle (ilvl 81)
    [1848] = { {233388,233387,233389,233390,233391} }, -- Deathdealer's Thrill (ilvl 81)
    [1849] = { {233661,233663,233659,233662,233660} }, -- Deathdealer's Battlearmor (ilvl 81)
    [1850] = { {233385,233383,233386,233382,233384} }, -- Stormcaller's Relief (ilvl 81)
    [1851] = { {233705,233707,233704,233708,233706} }, -- Stormcaller's Eruption (ilvl 81)
    [1852] = { {233695,233697,233694,233698,233696} }, -- Stormcaller's Resolve (ilvl 81)
    [1853] = { {233700,233702,233699,233703,233701} }, -- Stormcaller's Impact (ilvl 81)
    [1854] = { {233381,233379,233378,233377,233380} }, -- Doomcaller's Corruption (ilvl 81)
    [1855] = { {233669,233671,233672,233673,233670} }, -- Doomcaller's Malevolence (ilvl 81)
    [1856] = { {233653,233658,233651,233654,233652} }, -- Conqueror's Advance (ilvl 81)
    [1857] = { {233375,233376,233373,233374,233372} }, -- Conqueror's Bulwark (ilvl 81)
    [1858] = { {233418,233419,233417} }, -- Symbols of Unending Life (ilvl 76)
    [1859] = { {233421,233420,233422} }, -- Trappings of the Unseen Path (ilvl 76)
    [1860] = { {233424,233425,233423} }, -- Trappings of Vaulted Secrets (ilvl 76)
    [1861] = { {233427,233428,233426} }, -- Battlegear of Eternal Justice (ilvl 76)
    [1862] = { {233430,233431,233429} }, -- Finery of Infinite Wisdom (ilvl 76)
    [1863] = { {233433,233432,233434} }, -- Emblems of Veiled Shadows (ilvl 76)
    [1864] = { {233436,233437,233435} }, -- Gift of the Gathering Storm (ilvl 76)
    [1865] = { {233438,233440,233439} }, -- Implements of Unspoken Names (ilvl 76)
    [1866] = { {233442,233441,233443} }, -- Battlegear of Unyielding Strength (ilvl 76)
    [1881] = { {235893,235894} }, -- Kharon's Decree (ilvl 83)
    [1882] = { {236007,236008,236005,236011,236006,236009,236012,236010,236013} }, -- Dreadnaught's Battlegear (ilvl 88)
    [1883] = { {236016,236017,236014,236020,236015,236018,236021,236019,236022} }, -- Dreadnaught's Warplate (ilvl 88)
    [1884] = { {236072,236070,236069,236071,236075,236068,236073,236076,236074} }, -- Plagueheart Stitchings (ilvl 88)
    [1885] = { {236064,236065,236066,236060,236059,236061,236063,236062,236067} }, -- Plagueheart Raiment (ilvl 88)
    [1886] = { {236165,236163,236169,236162,236164,236168,236160,236166,236167} }, -- The Earthshatterer's Resolve (ilvl 88)
    [1887] = { {236144,236145,236147,236148,236143,236146,236149,236142,236150} }, -- The Earthshatterer (ilvl 88)
    [1888] = { {236174,236172,236179,236171,236173,236177,236170,236175,236176} }, -- The Earthshatterer's Rage (ilvl 88)
    [1889] = { {236155,236153,236159,236152,236154,236158,236151,236156,236157} }, -- The Earthshatterer's Storm (ilvl 88)
    [1890] = { {236037,236035,236039,236032,236036,236033,236040,236038,236034} }, -- Bonescythe Leathers (ilvl 88)
    [1891] = { {236025,236026,236023,236029,236024,236027,236030,236028,236031} }, -- Bonescythe Armor (ilvl 88)
    [1892] = { {236103,236102,236098,236101,236099,236100,236104,236097,236105} }, -- Vestments of Faith (ilvl 88)
    [1893] = { {236110,236108,236107,236109,236113,236106,236111,236114,236112} }, -- Raiments of Faith (ilvl 88)
    [1894] = { {236137,236135,236141,236134,236136,236140,236133,236138,236139} }, -- Redemption Bulwark (ilvl 88)
    [1895] = { {236117,236122,236115,236120,236121,236123,236119,236118,236116} }, -- Redemption Armor (ilvl 88)
    [1896] = { {236128,236126,236132,236125,236127,236131,236124,236129,236130} }, -- Redemption Warplate (ilvl 88)
    [1897] = { {236091,236089,236088,236090,236094,236087,236092,236095,236093} }, -- Frostfire Vestments (ilvl 88)
    [1898] = { {236083,236084,236078,236079,236080,236077,236082,236081,236085} }, -- Frostfire Regalia (ilvl 88)
    [1899] = { {236046,236044,236043,236048,236045,236049,236042,236047,236041} }, -- Cryptstalker Armor (ilvl 88)
    [1900] = { {236054,236052,236058,236051,236053,236057,236050,236055,236056} }, -- Cryptstalker Prowess (ilvl 88)
    [1901] = { {236205,236203,236209,236202,236204,236208,236201,236206,236207} }, -- Dreamwalker Guardian (ilvl 88)
    [1902] = { {236182,236189,236186,236187,236188,236185,236183,236184,236190} }, -- Dreamwalker Raiment (ilvl 88)
    [1903] = { {236214,236212,236218,236211,236213,236217,236210,236215,236216} }, -- Dreamwalker Ferocity (ilvl 88)
    [1904] = { {236196,236194,236200,236193,236195,236199,236192,236197,236198} }, -- Dreamwalker Eclipse (ilvl 88)
    [1905] = { {236707,236713,236711} }, -- Undead Slayer's Armor (ilvl 70)
    [1906] = { {236709,236710,236715} }, -- Garb of the Undead Slayer (ilvl 70)
    [1907] = { {236708,236714,236712} }, -- Battlegear of Undead Slaying (ilvl 70)
    [1908] = { {236718,236717,236716} }, -- Regalia of Undead Cleansing (ilvl 70)
    [1909] = { {236748,236747,236746} }, -- Battlegear of Undead Warding (ilvl 70)
    [1910] = { {236745,236744,236743} }, -- Battlegear of Undead Purification (ilvl 70)
    [1911] = { {236734,236735,236736} }, -- Garb of the Undead Cleansing (ilvl 70)
    [1912] = { {236737,236738,236739} }, -- Garb of the Undead Warder (ilvl 70)
    [1913] = { {236742,236741,236740} }, -- Garb of the Undead Purifier (ilvl 70)
    [1914] = { {236727,236726,236725} }, -- Undead Cleanser's Armor (ilvl 70)
    [1915] = { {236730,236729,236728} }, -- Undead Purifier's Armor (ilvl 70)
    [1916] = { {236733,236732,236731} }, -- Undead Warder's Armor (ilvl 70)
    [1917] = { {236721,236720,236719} }, -- Regalia of Undead Purification (ilvl 70)
    [1918] = { {236724,236723,236722} }, -- Regalia of Undead Warding (ilvl 70)
    [1932] = { {239517,239516,239519,239513,239518,239515,239512,239514} }, -- Lightbreaker's Warplate (ilvl 98)
    [1933] = { {239525,239524,239527,239521,239526,239523,239520,239522} }, -- Lightbreaker's Battlegear (ilvl 98)
    [1934] = { {239560,239559,239562,239556,239561,239558,239555,239557} }, -- Duskwraith Armor (ilvl 98)
    [1935] = { {239550,239552,239548,239554,239551,239553,239547,239549} }, -- Duskwraith Leathers (ilvl 98)
    [1936] = { {239532,239534,239529,239535,239533,239530,239536,239531} }, -- Dawnstalker Prowess (ilvl 98)
    [1937] = { {239540,239542,239543,239538,239541,239537,239544,239539} }, -- Dawnstalker Armor (ilvl 98)
    [1938] = { {239575,239581,239582,239577,239572,239583,239574,239565} }, -- Raiments of Revelation (ilvl 98)
    [1939] = { {239585,239586,239590,239587,239589,239588,239584,239591} }, -- Vestments of Revelation (ilvl 98)
    [1940] = { {240027,240025,240030,240024,240026,240029,240023,240028} }, -- Inquisition Warplate (ilvl 98)
    [1941] = { {240040,240021,240039,240043,240020,240022,240042,240041} }, -- Inquisition Armor (ilvl 98)
    [1942] = { {240035,240033,240038,240032,240034,240037,240031,240036} }, -- Inquisition Bulwark (ilvl 98)
    [1943] = { {240056,240054,240053,240055,240058,240052,240057,240059} }, -- Fireleaf Regalia (ilvl 98)
    [1944] = { {240048,240046,240045,240047,240050,240044,240049,240051} }, -- Fireleaf Vestments (ilvl 98)
    [1945] = { {240064,240062,240067,240061,240063,240066,240060,240065} }, -- Waywatcher Ferocity (ilvl 98)
    [1946] = { {240072,240070,240075,240069,240071,240074,240068,240073} }, -- Waywatcher Eclipse (ilvl 98)
    [1947] = { {240088,240086,240091,240085,240087,240090,240084,240089} }, -- Waywatcher Raiment (ilvl 98)
    [1948] = { {240080,240078,240083,240077,240079,240082,240076,240081} }, -- Waywatcher Guardian (ilvl 98)
    [1949] = { {240104,240106,240101,240107,240105,240102,240108,240103} }, -- The Soulcrusher's Resolve (ilvl 98)
    [1950] = { {240096,240098,240092,240099,240097,240093,240100,240095} }, -- The Soulcrusher (ilvl 98)
    [1951] = { {240131,240135,240128,240136,240134,240129,240137,240130} }, -- The Soulcrusher's Rage (ilvl 98)
    [1952] = { {240123,240125,240109,240126,240124,240110,240127,240122} }, -- The Soulcrusher's Storm (ilvl 98)
    [1953] = { {240148,240150,240151,240149,240153,240152,240147,240146} }, -- Heretic Stitchings (ilvl 98)
    [1954] = { {240141,240143,240144,240142,240139,240145,240140,240138} }, -- Heretic Raiment (ilvl 98)
    [1955] = { {236343,240853} }, -- Fallen Regality (ilvl 92)
    [1956] = { {240922,240923} }, -- Tools of the Nathrezim (ilvl 94)
    [1959] = { {240854,240852} }, -- Hack and Smash (ilvl 96)
    [1963] = { {246062,246061,246060,246059,246058,246057,246056,246055} }, -- Inquisition Shockplate (ilvl 98)
}

MSC.SetBonusScores = {
    -- The Gladiator
        -- (2) +20 Armor.
        -- (3) Increased Defense +2.
        -- (4) +10 Attack Power.
        -- (5) Improves your chance to get a critical strike by 1%.
    [1] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=20}}, [3]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=2}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- Dal'Rend's Arms
        -- (2) +50 Attack Power.
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
        -- (2) Increased Defense +3.
        -- (3) +10 Attack Power.
        -- (4) +15 All Resistances.
        -- (5) Improves your chance to hit by 2%.
    [121] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=3}}, [3]={stats={ITEM_MOD_ATTACK_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_HIT_RATING_SHORT=2}} },
    -- Necropile Raiment
        -- (2) Increased Defense +3.
        -- (3) +5 Intellect.
        -- (4) +15 All Resistances.
        -- (5) Increases damage and healing done by magical spells and effects by up to 23.
    [122] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=3}}, [3]={stats={ITEM_MOD_INTELLECT_SHORT=5}}, [5]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Bloodmail Regalia
        -- (2) Increased Defense +3.
        -- (3) +10 Attack Power.
        -- (4) +15 All Resistances.
        -- (5) Increases your chance to parry an attack by 1%.
    [123] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=3}}, [3]={stats={ITEM_MOD_ATTACK_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}} },
    -- Deathbone Guardian
        -- (2) Increased Defense +3.
        -- (3) +50 Armor.
        -- (4) +15 All Resistances.
        -- (5) Increases your chance to parry an attack by 1%.
    [124] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=3}}, [3]={stats={ITEM_MOD_ARMOR_SHORT=50}}, [5]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}} },
    -- Volcanic Armor
        -- (3) 5% chance of dealing X Fire damage on a successful melee attack.
    [141] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Stormshroud Armor
        -- (2) 5% chance of dealing X Nature damage on a successful melee attack.
        -- (3) 2% chance on melee attack of restoring X energy.
        -- (4) +14 Attack Power.
    [142] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=14}} },
    -- Devilsaur Armor
        -- (2) Improves your chance to hit by 2%.
    [143] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=2}} },
    -- Ironfeather Armor
        -- (2) Increases damage and healing done by magical spells and effects by up to 20.
    [144] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Defias Leather
        -- (2) +10 Armor.
        -- (3) +5 Arcane Resistance.
        -- (4) Increased Daggers +1.
        -- (5) +10 Attack Power.
    [161] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=10}}, [4]={stats={ITEM_MOD_WEAPON_SKILL_RATING_SHORT=1}}, [5]={stats={ITEM_MOD_ATTACK_POWER_SHORT=10}} },
    -- Embrace of the Viper
        -- (2) Increases damage done by Nature spells and effects by up to 7.
        -- (3) Increased Staves +2.
        -- (4) Increases healing done by spells and effects by up to 11.
        -- (5) +10 Intellect.
    [162] = { [2]={stats={ITEM_MOD_NATURE_DAMAGE_SHORT=7}}, [3]={stats={ITEM_MOD_WEAPON_SKILL_RATING_SHORT=2}}, [4]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=11}}, [5]={stats={ITEM_MOD_INTELLECT_SHORT=10}} },
    -- Chain of the Scarlet Crusade
        -- (2) +10 Armor.
        -- (3) Increased Defense +1.
        -- (4) +5 Shadow Resistance.
        -- (5) +15 Attack Power when fighting Undead.
        -- (6) Improves your chance to hit by 1%.
    [163] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=10}}, [3]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=1}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=8, ITEM_MOD_SPELL_POWER_SHORT=4}}, [6]={stats={ITEM_MOD_HIT_RATING_SHORT=1}} },
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
        -- (4) +40 Attack Power.
        -- (6) Chance on melee attack to restore 35 energy.
        -- (8) +8 All Resistances.
    [184] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Wildheart Raiment
        -- (2) +200 Armor.
        -- (4) +26 Attack Power. / Increases damage and healing done by magical spells and effects by up to 15.
        -- (6) When struck in combat has a chance of returning 300 mana, 10 rage, or 40 energy to the wearer.
        -- (8) +8 All Resistances.
    [185] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Beaststalker Armor
        -- (2) +200 Armor.
        -- (4) +40 Attack Power.
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
        -- (4) +40 Attack Power.
        -- (6) Chance on melee attack to increase your damage and healing done by magical spells and effects by up to X for X.
        -- (8) +8 All Resistances.
    [188] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Battlegear of Valor
        -- (2) +200 Armor.
        -- (4) +40 Attack Power.
        -- (6) Chance on melee attack to heal you for X.
        -- (8) +8 All Resistances.
    [189] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Arcanist Regalia
        -- (3) Increases damage and healing done by magical spells and effects by up to 18.
        -- (5) Decreases the magical resistances of your spell targets by 10.
        -- (8) Decreases the threat generated by your spells by 15%.
    [201] = { [3]={stats={ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Vestments of Prophecy
        -- (3) -0.1 sec to the casting time of your Flash Heal spell.
        -- (5) Improves your chance to get a critical strike with Holy spells by 2%.
        -- (8) Increases your chance of a critical hit with Prayer of Healing by 25%.
    [202] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
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
        -- (5) Improves your chance to get a critical strike with spells by 2%.
        -- (8) Reduces the cooldown of your Tranquility and Hurricane spells by 50%.
    [205] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=2}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
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
        -- (5) Improves your chance to get a critical strike with spells by 1%. / Improves your chance to get a critical strike by 1%.
        -- (8) Gives the Paladin a chance on every melee hit to heal your party for X.
    [208] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_CRIT_RATING_SHORT=1, ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Battlegear of Might
        -- (3) Increases the block value of your shield by 30.
        -- (5) Gives you a X% chance to generate an additional Rage point whenever damage is dealt to you.
        -- (8) Increases the threat generated by Sunder Armor by 15%.
    [209] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Netherwind Regalia
        -- (3) Reduces the threat generated by your Scorch, Arcane Missiles, Fireball, and Frostbolt spells.
        -- (5) Increases the radius of Arcane Explosion, Flamestrike, and Blizzard by 25%.
        -- (8) 10% chance after casting Arcane Missiles, Fireball, or Frostbolt that your next spell with a casting time under 10 seconds cast instantly.
    [210] = { [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Vestments of Transcendence
        -- (3) Allows 15% of your Mana regeneration to continue while casting.
        -- (5) When struck in melee there is a X% chance you will Fade for X.
        -- (8) Your Greater Heals now have a heal over time component equivalent to a rank 5 Renew.
    [211] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
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
        -- (3) Allows 15% of your Mana regeneration to continue while casting.
        -- (5) Reduces the casting time of your Regrowth spell by 0.2 sec.
        -- (8) Increases the duration of your Rejuvenation spell by 3 sec.
    [214] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Dragonstalker Armor
        -- (3) Increases the Ranged Attack Power bonus of your Aspect of the Hawk by 20%.
        -- (5) Increases your pet's stamina by X and all spell resistances by X.
        -- (8) You have a chance whenever you deal ranged damage to apply an Expose Weakness effect to the target. Expose Weakness increases the Ranged Attack Power of all attackers against that target by X for X.
    [215] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- The Ten Storms
        -- (3) Increases the amount healed by Chain Heal to targets beyond the first by 30%.
        -- (5) Improves your chance to get a critical strike with Nature spells by 3%.
        -- (8) When you cast a Healing Wave or Lesser Healing Wave, there is a 25% chance the target also receives a free Lightning Shield that causes X Nature damage to attacker on hit.
    [216] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Judgement Armor
        -- (3) Increases the radius of a Paladin's auras by 10.
        -- (5) Increases damage and healing done by magical spells and effects by up to 47.
        -- (8) Inflicts X additional Holy damage on the target of a Paladin's Judgement.
    [217] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [5]={stats={ITEM_MOD_SPELL_POWER_SHORT=47}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Battlegear of Wrath
        -- (3) Increases the attack power granted by Battle Shout by 30.
        -- (5) X% chance after using an offensive ability requiring rage that your next offensive ability requires X less rage to use.
        -- (8) X% chance to parry the next attack after a block.
    [218] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [8]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Garb of Thero-shan
        -- (6) Improves your chance to get a critical strike by 1%.
    [221] = { [6]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- Shard of the Gods (no scorable bonus)
        -- (2) +10 All Resistances.
    -- Spirit of Eskhandar
        -- (4) 1% chance on a melee critical hit to call forth the spirit of Eskhandar to protect you in battle for X.
    [261] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Champion's Battlegear
        -- (2) Increases your chance to parry an attack by 1%.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +15 Stamina.
    [281] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Battlegear
        -- (2) Increases your chance to parry an attack by 1%.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +15 Stamina.
    [282] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Earthshaker
        -- (2) +40 Attack Power.
        -- (4) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +15 Stamina.
    [301] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Imperial Plate
        -- (2) +100 Armor.
        -- (4) +28 Attack Power.
        -- (6) +18 Stamina.
    [321] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=100}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=28}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=18}} },
    -- Champion's Regalia
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 1.5 sec.
        -- (6) +15 Stamina.
    [341] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Raiment
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +15 Stamina.
    [342] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Regalia
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 1.5 sec.
        -- (6) +15 Stamina.
    [343] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Raiment
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +15 Stamina.
    [344] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Threads
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) +15 Stamina.
    [345] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Threads
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) +15 Stamina.
    [346] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Vestments
        -- (2) Increases your chance to parry an attack by 1%.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +15 Stamina.
    [347] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Vestments
        -- (2) Increases your chance to parry an attack by 1%.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +15 Stamina.
    [348] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Pursuit
        -- (2) Increases your chance to parry an attack by 1%.
        -- (4) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +15 Stamina.
    [361] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Pursuit
        -- (2) Increases your chance to parry an attack by 1%.
        -- (4) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +15 Stamina.
    [362] = { [2]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Lieutenant Commander's Sanctuary
        -- (2) +40 Attack Power.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +15 Stamina.
    [381] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Champion's Sanctuary
        -- (2) +40 Attack Power.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +15 Stamina.
    [382] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Warlord's Battlegear
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +40 Attack Power.
    [383] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Field Marshal's Battlegear
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +40 Attack Power.
    [384] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Earthshaker
        -- (2) +20 Stamina.
        -- (3) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +40 Attack Power.
    [386] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Regalia
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Blink spell by 1.5 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [387] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Regalia
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Blink spell by 1.5 sec.
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
        -- (3) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [391] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Threads
        -- (2) +20 Stamina.
        -- (3) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [392] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Warlord's Vestments
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +40 Attack Power.
    [393] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Field Marshal's Vestments
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +40 Attack Power.
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
        -- (3) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +40 Attack Power.
    [397] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Sanctuary
        -- (2) +20 Stamina.
        -- (3) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +40 Attack Power.
    [398] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Lieutenant Commander's Aegis
        -- (2) Improves your chance to get a critical strike by 1%. / +6 Intellect.
        -- (4) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) +15 Stamina.
    [401] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=1, ITEM_MOD_INTELLECT_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=15}} },
    -- Field Marshal's Aegis
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [402] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Bloodvine Garb
        -- (3) Improves your chance to get a critical strike with spells by 2%.
    [421] = { [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=2}} },
    -- Primal Batskin
        -- (3) Minor increase to running and swimming speed.
    [441] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}} },
    -- Blood Tiger Harness
        -- (2) Improves your chance to get a critical strike by 1%. / Improves your chance to get a critical strike with spells by 1%.
    [442] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=1, ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}} },
    -- Bloodsoul Embrace
        -- (3) Restores 12 mana per 5 sec.
    [443] = { [3]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=12}} },
    -- The Darksoul
        -- (3) Increased Defense +20.
    [444] = { [3]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=20}} },
    -- The Twin Blades of Hakkari
        -- (2) Increased Swords +6.
    [461] = { [2]={stats={ITEM_MOD_WEAPON_SKILL_RATING_SHORT=6}} },
    -- Zanzil's Concentration
        -- (2) Improves your chance to hit with spells by 1%. / Increases damage and healing done by magical spells and effects by up to 6.
    [462] = { [2]={stats={ITEM_MOD_HIT_SPELL_RATING_SHORT=1, ITEM_MOD_SPELL_POWER_SHORT=6}} },
    -- Primal Blessing
        -- (2) Grants a small chance when ranged or melee damage is dealt to infuse the wielder with a blessing from the Primal Gods. Ranged and melee attack power increased by 300 for 12 seconds.
    [463] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Overlord's Resolution
        -- (2) Increases your chance to dodge an attack by 1%.
    [464] = { [2]={stats={ITEM_MOD_DODGE_RATING_SHORT=1}} },
    -- Prayer of the Primal
        -- (2) Increases healing done by spells and effects by up to 33.
    [465] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=33}} },
    -- Major Mojo Infusion
        -- (2) +30 Attack Power.
    [466] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- The Highlander's Resolution
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike by 1%.
    [467] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- The Highlander's Resolve
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike by 1%.
    [468] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- The Highlander's Determination
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike by 1%.
    [469] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- The Highlander's Fortitude
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike with spells by 1%.
    [470] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}} },
    -- The Highlander's Purpose
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike by 1%.
    [471] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- The Highlander's Will
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike with spells by 1%.
    [472] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}} },
    -- The Highlander's Intent
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike with spells by 1%.
    [473] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}} },
    -- Vindicator's Battlegear
        -- (2) Increases your chance to block attacks with a shield by 2%.
        -- (3) Decreases the cooldown of Intimidating Shout by 15 sec.
        -- (5) Decrease the rage cost of Whirlwind by X.
    [474] = { [2]={stats={ITEM_MOD_BLOCK_RATING_SHORT=2}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
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
        -- (2) +20 Attack Power.
        -- (3) Decreases the cooldown of Concussive Shot by 1 sec.
        -- (5) Increases the duration of Serpent Sting by 3 sec.
    [477] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Madcap's Outfit
        -- (2) +20 Attack Power.
        -- (3) Decreases the cooldown of Blind by 20 sec.
        -- (5) Decrease the energy cost of Eviscerate and Rupture by 5.
    [478] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Haruspex's Garb
        -- (2) Restores 4 mana per 5 sec.
        -- (3) Increases the duration of Faerie Fire by 5 sec.
        -- (5) Increases the critical hit chance of your Starfire spell 3%.
    [479] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=4}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Confessor's Raiment
        -- (2) Increases healing done by spells and effects by up to 22.
        -- (3) Increase the range of your Smite and Holy Fire spells by 5 yds.
        -- (5) Reduces the casting time of your Mind Control spell by 0.5 sec.
    [480] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=22}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
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
        -- (3) Improves your chance to get a critical strike by 1%.
    [483] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- The Defiler's Fortitude
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike by 1%.
    [484] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- The Defiler's Intent
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike with spells by 1%.
    [485] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}} },
    -- The Defiler's Purpose
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike by 1%.
    [486] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- The Defiler's Resolution
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike by 1%.
    [487] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=1}} },
    -- The Defiler's Will
        -- (2) +5 Stamina.
        -- (3) Improves your chance to get a critical strike with spells by 1%.
    [488] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}} },
    -- Black Dragon Mail
        -- (2) Improves your chance to hit by 1%.
        -- (3) Improves your chance to get a critical strike by 2%.
        -- (4) +10 Fire Resistance.
    [489] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=1}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=2}} },
    -- Green Dragon Mail
        -- (2) Restores 3 mana per 5 sec.
        -- (3) Allows 15% of your Mana regeneration to continue while casting.
    [490] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=3}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Blue Dragon Mail
        -- (2) +4 All Resistances.
        -- (3) Increases damage and healing done by magical spells and effects by up to 28.
    [491] = { [3]={stats={ITEM_MOD_SPELL_POWER_SHORT=28}} },
    -- Twilight Trappings
        -- (3) Bestows the wearer with the evil aura of a Twilight's Hammer cultist.
    [492] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Genesis Raiment
        -- (3) Increased Defense +15. / +150 Armor.
        -- (5) Reduces the cooldown of Rebirth by X minutes.
    [493] = { [3]={stats={ITEM_MOD_ARMOR_SHORT=150, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=15}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
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
        -- (3) Reduces the cooldown of your Evasion ability by -X min.
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
        -- (6) +40 Attack Power.
        -- (8) +200 Armor.
    [511] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Darkmantle Armor
        -- (2) +8 All Resistances.
        -- (4) Chance on melee attack to restore 35 energy.
        -- (6) +40 Attack Power.
        -- (8) +200 Armor.
    [512] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Feralheart Raiment
        -- (2) +8 All Resistances.
        -- (4) When struck in combat has a chance of returning 300 mana, 10 rage, or 40 energy to the wearer.
        -- (6) Increases damage and healing done by magical spells and effects by up to 15. / +26 Attack Power.
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
        -- (6) +40 Attack Power.
        -- (8) +200 Armor.
    [515] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Soulforge Armor
        -- (2) +8 All Resistances.
        -- (4) Chance on melee attack to increase your damage and healing done by magical spells and effects by up to X for X.
        -- (6) +40 Attack Power.
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
        -- (2) +40 Attack Power.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +20 Stamina.
    [522] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Dreadnaught's Battlegear
        -- (2) Increases the damage done by your Revenge ability by 75.
        -- (4) Improves your chance to hit with Taunt and Challenging Shout by 5%.
        -- (6) Improves your chance to hit with Sunder Armor, Heroic Strike, Revenge, and Shield Slam by 5%.
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
        -- (2) Increases the duration of your Rapid Fire by 4 secs.
        -- (4) Increases Attack Power by X for both you and your pet.
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
        -- (2) +40 Attack Power.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +20 Stamina.
    [537] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Stormcaller
        -- (2) +40 Attack Power.
        -- (4) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +20 Stamina.
    [538] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Refuge
        -- (2) +40 Attack Power.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [539] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Investiture
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +20 Stamina.
    [540] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Dreadgear
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) +20 Stamina.
    [541] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Arcanum
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 1.5 sec.
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
        -- (2) +40 Attack Power.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +20 Stamina.
    [545] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Arcanum
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 1.5 sec.
        -- (6) +20 Stamina.
    [546] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Dreadgear
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) +20 Stamina.
    [547] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Guard
        -- (2) +40 Attack Power.
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
        -- (2) +40 Attack Power.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [551] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Twilight Invoker's Vestments
        -- (2) Increases damage and healing done by magical spells and effects by up to 9.
        -- (3) Improves your chance to hit with all spells and attacks by 1%.
    [1570] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=9}}, [3]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}} },
    -- Judgement Redoubt
        -- (3) Your Devotion Aura also reduces all spell damage taken by 4%.
        -- (5) Judgement generates an additional 51% threat against its target.
        -- (8) Increases damage and healing done by magical spells and effects by up to 47.
    [1571] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [8]={stats={ITEM_MOD_SPELL_POWER_SHORT=47}} },
    -- Blackfathom Avenger's Mail
        -- (2) +12 Attack Power.
        -- (3) Improves your chance to hit with all spells and attacks by 1%.
    [1577] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=12}}, [3]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}} },
    -- Blackfathom Slayer's Leather
        -- (2) +12 Attack Power.
        -- (3) Improves your chance to hit with all spells and attacks by 1%.
    [1578] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=12}}, [3]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}} },
    -- Blackfathom Elementalist's Hide
        -- (2) Increases damage and healing done by magical spells and effects by up to 12.
        -- (3) Improves your chance to hit with all spells and attacks by 1%.
    [1579] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}}, [3]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}} },
    -- Irradiated Garments
        -- (2) -4 Stamina. / Improves your chance to get a critical strike with all spells and attacks by 1%.
        -- (3) Increases damage and healing done by magical spells and effects by up to 11.
    [1584] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=1, ITEM_MOD_SPELL_CRIT_RATING_SHORT=1, ITEM_MOD_STAMINA_SHORT=-4}}, [3]={stats={ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Insulated Leathers
        -- (2) Improves your chance to get a critical strike with all spells and attacks by 1%.
        -- (3) +21 Attack Power in Cat, Bear, and Dire Bear forms only. / Increased Daggers +3.
    [1585] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=1, ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}}, [3]={stats={ITEM_MOD_ATTACK_POWER_SHORT=21, ITEM_MOD_WEAPON_SKILL_RATING_SHORT=3}} },
    -- Insulated Sorceror's Leathers
        -- (2) Increases damage and healing done by magical spells and effects by up to 16.
        -- (3) Increases the critical hit chance of Wrath and Starfire by 2%.
    [1586] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=16}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Hyperconductive Wizard's Attire
        -- (2) Improves your chance to hit with all spells and attacks by 1%. / +100 Armor.
        -- (3) Chance on spell cast to increase your damage and healing by up to X for X.
    [1587] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=100, ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Hyperconductive Mender's Meditation
        -- (2) +14 Spirit.
        -- (3) Restores 7 mana per 5 sec.
    [1588] = { [2]={stats={ITEM_MOD_SPIRIT_SHORT=14}}, [3]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=7}} },
    -- H.A.Z.A.R.D. Suit
        -- (2) Increased Defense +7. / +16 Attack Power.
        -- (3) Improves your chance to hit with all spells and attacks by 1%.
    [1589] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=7}}, [3]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}} },
    -- Electromantic Devastator's Mail
        -- (2) +24 Attack Power.
        -- (3) Your attacks have a 5% chance of restoring X mana.
    [1590] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=24}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Electromantic Stormbringer's Chain
        -- (2) Increases damage and healing done by magical spells and effects by up to 12.
        -- (3) -0.1 seconds on the casting time of your Lightning Bolt spell.
    [1591] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Shockforged Warplate
        -- (2) Increases damage and healing done by magical spells and effects by up to 12.
        -- (3) Increases the critical hit chance of Holy Shock by 2%.
    [1592] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Blood Guard's Plate
        -- (3) +15 Stamina.
        -- (6) +30 Attack Power.
    [1618] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Knight-Lieutenant's Plate
        -- (3) +15 Stamina.
        -- (6) +30 Attack Power.
    [1619] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Knight-Lieutenant's Imbued Plate
        -- (3) +15 Stamina.
        -- (6) Increases healing done by spells and effects by up to 33.
    [1620] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=33}} },
    -- Knight-Lieutenant's Lamellar Plate
        -- (3) +15 Stamina.
        -- (6) Increases damage and healing done by magical spells and effects by up to 18.
    [1621] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Blood Guard's Mail
        -- (3) +15 Stamina.
        -- (6) +30 Attack Power.
    [1622] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Blood Guard's Pulsing Mail
        -- (3) +15 Stamina.
        -- (6) Increases damage and healing done by magical spells and effects by up to 18.
    [1623] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Blood Guard's Inscribed Mail
        -- (3) +15 Stamina.
        -- (6) Increases healing done by spells and effects by up to 33.
    [1624] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=33}} },
    -- Blood Guard's Chain
        -- (3) +15 Stamina.
        -- (6) +30 Attack Power.
    [1625] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Knight-Lieutenant's Chain
        -- (3) +15 Stamina.
        -- (6) +30 Attack Power.
    [1626] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Blood Guard's Leather
        -- (3) +15 Stamina.
        -- (6) +30 Attack Power.
    [1627] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Knight-Lieutenant's Leather
        -- (3) +15 Stamina.
        -- (6) +30 Attack Power.
    [1628] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Blood Guard's Restored Leather
        -- (3) +15 Stamina.
        -- (6) Increases healing done by spells and effects by up to 33.
    [1629] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=33}} },
    -- Knight-Lieutenant's Restored Leather
        -- (3) +15 Stamina.
        -- (6) Increases healing done by spells and effects by up to 33.
    [1630] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=33}} },
    -- Blood Guard's Crackling Leather
        -- (3) +15 Stamina.
        -- (6) Increases damage and healing done by magical spells and effects by up to 18.
    [1631] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Knight-Lieutenant's Crackling Leather
        -- (3) +15 Stamina.
        -- (6) Increases damage and healing done by magical spells and effects by up to 18.
    [1632] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Blood Guard's Dreadweave
        -- (3) +15 Stamina.
        -- (6) Increases damage and healing done by magical spells and effects by up to 18.
    [1633] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Knight-Lieutenant's Dreadweave
        -- (3) +15 Stamina.
        -- (6) Increases damage and healing done by magical spells and effects by up to 18.
    [1634] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Blood Guard's Satin
        -- (3) +15 Stamina.
        -- (6) Increases healing done by spells and effects by up to 33.
    [1635] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=33}} },
    -- Knight Lieutenant's Satin
        -- (3) +15 Stamina.
        -- (6) Increases healing done by spells and effects by up to 33.
    [1636] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=33}} },
    -- Nightmare Prophet's Garb
        -- (2) Improves your chance to hit with all spells and attacks by 1%.
        -- (3) Dealing damage with Shadow Cleave reduces the cast time of your next Immolate spell by X%. Stacking up to 3 times. Lasts X.
    [1637] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Benevolent Prophet's Vestments
        -- (2) Restores 4 mana per 5 sec.
        -- (3) Your Holy damage spells cause you to gain X increased damage and healing power for X.
    [1638] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=4}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Malevolent Prophet's Vestments
        -- (2) Improves your chance to get a critical strike with all spells and attacks by 1%.
        -- (3) Your damage spells have a chance to cause your target to take up to X increased damage from subsequent spells.
    [1639] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=1, ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Coagulate Bloodguard's Leathers
        -- (2) +10 Strength.
        -- (3) Shred reduces the mana cost of your next shapeshift cast within X by X%. / Improves your chance to hit with all spells and attacks by 3% while in Bear or Dire Bear Forms.
    [1640] = { [2]={stats={ITEM_MOD_STRENGTH_SHORT=10}}, [3]={stats={ITEM_MOD_HIT_RATING_SHORT=3, ITEM_MOD_HIT_SPELL_RATING_SHORT=3}, equiv={ITEM_MOD_ATTACK_POWER_SHORT=8, ITEM_MOD_SPELL_POWER_SHORT=4}} },
    -- Blood Corrupted Leathers
        -- (2) Improves your chance to hit with all spells and attacks by 1%.
        -- (3) Backstab and Sinister Strike cause the target to take X more damage from all sources for X charges or X.
    [1641] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Lost Worshipper's Armor
        -- (2) Improves your chance to hit with all spells and attacks by 1%.
        -- (3) Increases the critical hit chance of Wrath and Starfire by 4%.
    [1642] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Exiled Prophet's Raiment
        -- (2) Restores 4 mana per 5 sec.
        -- (3) Your direct healing spell critical strikes now have a X% chance to activate Dreamstate. You must have the rune engraved.
    [1643] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=4}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Corrupted Spiritweaver's Mail
        -- (2) Restores 4 mana per 5 sec.
        -- (3) Reduces the cast time of Healing Rain by 99%.
    [1644] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=4}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Ostracized Berserker's Battlemail
        -- (2) +20 Attack Power.
        -- (3) Dealing Fire damage causes you to gain X attack power, stacking up to X times. Lasts X.
    [1645] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Shunned Devotee's Chainmail
        -- (2) Improves your chance to get a critical strike with all spells and attacks by 1%.
        -- (3) Increases Holy spell critical strike chance by 4%. / Chance on spell cast to increase your Nature spell damage and healing by up to X for X.
    [1646] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=1, ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=32, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Dread Hunter's Chain
        -- (2) +20 Attack Power.
        -- (3) Rapid Fire now also grants X% melee attack speed for X. / Increases your critical strike chance with ranged weapons by 2%.
    [1647] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=2}, equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Obsessed Prophet's Plate
        -- (2) Improves your chance to get a critical strike with all spells and attacks by 1%.
        -- (3) Increases Holy spell critical strike chance by 4%.
    [1648] = { [2]={stats={ITEM_MOD_CRIT_RATING_SHORT=1, ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Wailing Berserker's Plate Armor
        -- (2) Improves your chance to hit with all spells and attacks by 1%.
        -- (3) Gives you a X% chance to get an extra attack on the same target after dealing damage with your weapon.
    [1649] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Banished Martyr's Full Plate
        -- (2) Improves your chance to hit with all spells and attacks by 1%.
        -- (3) Gain X block value for X after blocking.
    [1650] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Serpent's Ascension
        -- (2) Grants a small chance when ranged or melee damage is dealt to infuse the wielder with a blessing of the Serpent. Ranged and melee attack power increased by X for X.
    [1651] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Emerald Dream Plate
        -- (3) +10 Stamina.
        -- (6) +20 Attack Power.
    [1652] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}} },
    -- Emerald Encrusted Battleplate
        -- (3) +10 Stamina.
        -- (6) Increases healing done by spells and effects by up to 22.
    [1653] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=22}} },
    -- Emerald Scalemail
        -- (3) +10 Stamina.
        -- (6) +20 Attack Power.
    [1654] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}} },
    -- Emerald Laden Chain
        -- (3) +10 Stamina.
        -- (6) Increases healing done by spells and effects by up to 22.
    [1655] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=22}} },
    -- Emerald Chainmail
        -- (3) +10 Stamina.
        -- (6) Increases damage and healing done by magical spells and effects by up to 12.
    [1656] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}} },
    -- Emerald Leathers
        -- (3) +10 Stamina.
        -- (6) +20 Attack Power.
    [1657] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}} },
    -- Emerald Dreamkeeper Garb
        -- (3) +10 Stamina.
        -- (6) Increases healing done by spells and effects by up to 22.
    [1658] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=22}} },
    -- Emerald Watcher Vestments
        -- (3) +10 Stamina.
        -- (6) Increases damage and healing done by magical spells and effects by up to 12.
    [1659] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}} },
    -- Emerald Enchanted Vestments
        -- (3) +10 Stamina.
        -- (6) Increases damage and healing done by magical spells and effects by up to 12.
    [1660] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}} },
    -- Emerald Woven Garb
        -- (3) +10 Stamina.
        -- (6) Increases healing done by spells and effects by up to 22.
    [1661] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=10}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=22}} },
    -- Knight-Lieutenant's Mail
        -- (3) +15 Stamina.
        -- (6) +30 Attack Power.
    [1665] = { [3]={stats={ITEM_MOD_STAMINA_SHORT=15}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Wildheart Raiment
        -- (2) +200 Armor.
        -- (4) +40 Attack Power, up to 24 increased damage from spells, and up to 45 increased healing from spells.
        -- (6) 3% chance on spellcast to energize you for X mana, 7% chance on dealing a melee autoattack to energize you for X Energy, and 4% chance on being hit by a melee attack to energize you for X Rage.
        -- (8) +8 All Resistances.
    [1666] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=24}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Feralheart Raiment
        -- (2) +40 Attack Power, up to 24 increased damage from spells, and up to 45 increased healing from spells.
        -- (4) 3% chance on spellcast to energize you for X mana, 7% chance on dealing a melee autoattack to energize you for X Energy, and 4% chance on being hit by a melee attack to energize you for X Rage.
        -- (6) +8 All Resistances.
        -- (8) +200 Armor.
    [1667] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=24}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Beaststalker Armor
        -- (2) +200 Armor.
        -- (4) +40 Attack Power.
        -- (6) Your melee and ranged autoattacks have a X% chance to energize you for X mana.
        -- (8) +8 All Resistances.
    [1668] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Beastmaster Armor
        -- (2) +40 Attack Power.
        -- (4) Your melee and ranged autoattacks have a X% chance to energize you for X mana.
        -- (6) +8 All Resistances.
        -- (8) +200 Armor.
    [1669] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Magister's Regalia
        -- (2) +200 Armor.
        -- (4) Increases damage and healing done by magical spells and effects by up to 23.
        -- (6) Your spellcasts have a X% chance to energize you for X mana.
        -- (8) +8 All Resistances.
    [1670] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Sorcerer's Regalia
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Your spellcasts have a X% chance to energize you for X mana.
        -- (6) +8 All Resistances.
        -- (8) +200 Armor.
    [1671] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Lightforge Armor
        -- (2) +200 Armor.
        -- (4) +40 Attack Power and up to 40 increased healing from spells.
        -- (6) X% chance on melee autoattack and 5% chance on spellcast to increase your damage and healing done by magical spells and effects by up to X for X.
        -- (8) +8 All Resistances.
    [1672] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_HEALING_DONE_SHORT=33}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Soulforge Armor
        -- (2) +40 Attack Power and up to 40 increased healing from spells.
        -- (4) X% chance on melee autoattack and 5% chance on spellcast to increase your damage and healing done by magical spells and effects by up to X for X.
        -- (6) +8 All Resistances.
        -- (8) +200 Armor.
    [1673] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_HEALING_DONE_SHORT=33}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Vestments of the Devout
        -- (2) +200 Armor.
        -- (4) Increases damage and healing done by magical spells and effects by up to 23.
        -- (6) Your spellcasts have a X% chance to energize you for X mana.
        -- (8) +8 All Resistances.
    [1674] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Vestments of the Virtuous
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Your spellcasts have a X% chance to energize you for X mana.
        -- (6) +8 All Resistances.
        -- (8) +200 Armor.
    [1675] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Darkmantle Armor
        -- (2) +40 Attack Power.
        -- (4) Chance on melee attack to restore 35 energy.
        -- (6) +8 All Resistances.
        -- (8) +200 Armor.
    [1676] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Shadowcraft Armor
        -- (2) +200 Armor.
        -- (4) +40 Attack Power.
        -- (6) Chance on melee attack to restore 35 energy.
        -- (8) +8 All Resistances.
    [1677] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- The Elements
        -- (2) +200 Armor.
        -- (4) +40 Attack Power, up to 24 increased damage from spells, and up to 45 increased healing from spells.
        -- (6) X% chance on mainhand autoattack and 5% chance on spellcast to increase your damage and healing done by magical spells and effects by up to X for X.
        -- (8) +8 All Resistances.
    [1678] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=24}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- The Five Thunders
        -- (2) +40 Attack Power, up to 24 increased damage from spells, and up to 45 increased healing from spells.
        -- (4) X% chance on mainhand autoattack and 5% chance on spellcast to increase your damage and healing done by magical spells and effects by up to X for X.
        -- (6) +8 All Resistances.
        -- (8) +200 Armor.
    [1679] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=24}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Dreadmist Raiment
        -- (2) +200 Armor.
        -- (4) Increases damage and healing done by magical spells and effects by up to 23.
        -- (6) Your melee autoattacks and spellcasts have a X% chance to heal you for X health.
        -- (8) +8 All Resistances.
    [1680] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Deathmist Raiment
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Your melee autoattacks and spellcasts have a X% chance to heal you for X health.
        -- (6) +8 All Resistances.
        -- (8) +200 Armor.
    [1681] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Battlegear of Valor
        -- (2) +200 Armor.
        -- (4) +40 Attack Power.
        -- (6) Chance on melee attack to heal you for X and energize you for X Rage
        -- (8) +8 All Resistances.
    [1682] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [4]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Cenarion Eclipse
        -- (2) Damage dealt by Thorns increased by 101% and duration increased by 201%.
        -- (4) Increases your chance to hit with spells and attacks by 4%.
        -- (6) Reduces the cooldown on Starfall by 49%.
    [1698] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [4]={stats={ITEM_MOD_HIT_RATING_SHORT=4, ITEM_MOD_HIT_SPELL_RATING_SHORT=4}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Cenarion Cunning
        -- (2) Your Faerie Fire (Feral) also increases the chance for all attacks to hit that target by X% for X.
        -- (4) Periodic damage from your Rake and Rip can now be critical strikes.
        -- (6) Your Rip and Ferocious Bite have a X% chance per combo point spent to refresh the duration of Savage Roar back to its initial value.
    [1699] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Cenarion Bounty
        -- (2) When you cast Innervate on another player, it is also cast on you.
        -- (4) Casting your Healing Touch or Nourish spells gives you a X% chance to gain Mana equal to 36% of the base cost of the spell.
        -- (6) Reduces the cooldown on Tranquility by 99% and increases its healing by 101%.
    [1700] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Cenarion Rage
        -- (2) You may cast Rebirth and Innervate while in Bear Form or Dire Bear Form.
        -- (4) Reduces the cooldown of Enrage by 30.0 sec and it no longer reduces your armor.
        -- (6) Bear Form and Dire Bear Form increase all threat you generate by an additional 21%, and Cower now removes all your threat against the target but has a 20.0 sec longer cooldown.
    [1701] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Giantstalker Pursuit
        -- (2) You generate X% more threat for X after using Distracting Shot.
        -- (4) While tracking a creature type, you deal 4% increased damage to that creature type.
        -- (6) Your next Shot ability within X after Aimed Shot deals X% more damage.
    [1702] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Giantstalker Prowess
        -- (2) Your Mongoose Bite also reduces its target's chance to Dodge by X% and increases your chance to hit by X% for X.
        -- (4) While tracking a creature type, you deal 4% increased damage to that creature type.
        -- (6) Mongoose Bite also activates for X whenever your target Parries or Blocks or when your melee attack misses.
    [1703] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Arcanist Insight
        -- (2) You are immune to all damage while channeling Evocation.
        -- (4) You gain X% increased damage for X each time you cast a spell from a different school of magic.
        -- (6) Mage Armor increases your mana regeneration while casting by an additional 16%. Molten Armor increases your spell damage and healing by 19. Ice Armor grants 21% increased chance to trigger Fingers of Frost.
    [1704] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Arcanist Moment
        -- (2) Your Temporal Beacons last 21% longer.
        -- (4) Increases all chronomantic healing you deal by 11%.
        -- (6) Each time you heal a target with Regeneration, the remaining cooldown on Rewind Time is reduced by 2 sec.
    [1705] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Lawbringer Mercy
        -- (2) Increases the chance for allies to trigger your Judgement of Light or Judgement of Wisdom to 71%.
        -- (4) Increases your critical strike chance with spells and attacks by 3%.
        -- (6) Whenever your Flash of Light, Holy Light, or Beacon of Light heals a target to full health, you also heal all members of their party for 200 health.
    [1706] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={stats={ITEM_MOD_CRIT_RATING_SHORT=3, ITEM_MOD_SPELL_CRIT_RATING_SHORT=3}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Lawbringer Radiance
        -- (2) Your Judgement of Light and Judgement of Wisdom also grant the effects of Judgement of the Crusader.
        -- (4) Increases your critical strike chance with spells and attacks by 3%.
        -- (6) Your Seal of Command, Seal of Righteousness, Seal of Martyrdom, and Sunlight deal 36% less damage, but now persist for 7 seconds after you cast another Seal, or until you cast a third Seal. Your Judgements can now trigger multiple Seals if active.
    [1707] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={stats={ITEM_MOD_CRIT_RATING_SHORT=3, ITEM_MOD_SPELL_CRIT_RATING_SHORT=3}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Lawbringer Will
        -- (2) Increases the block value of your shield by 31.
        -- (4) Heal for X when you Block. Can only heal once every few seconds.
        -- (6) Holy Shield no longer has charges and instead always lasts its full duration. In addition, its damage is increased by 81% of your shield block value.
    [1708] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Dawn Prophecy
        -- (2) -0.1 sec to the casting time of Flash Heal and -0.2 sec to the casting time of Greater Heal.
        -- (4) Increases your critical strike chance with spells and attacks by 3%.
        -- (6) Increases your critical strike chance with Prayer of Healing and Circle of Healing by 26%.
    [1709] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={stats={ITEM_MOD_CRIT_RATING_SHORT=3, ITEM_MOD_SPELL_CRIT_RATING_SHORT=3}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Twilight Prophecy
        -- (2) You may cast Flash Heal while in Shadowform.
        -- (4) Increases your critical strike chance with spells and attacks by 3%.
        -- (6) Mind Blast critical strikes reduce the duration of your next Mind Flay by X% while increasing its total damage by X%.
    [1710] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={stats={ITEM_MOD_CRIT_RATING_SHORT=3, ITEM_MOD_SPELL_CRIT_RATING_SHORT=3}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Nightslayer Thrill
        -- (2) Feint also grants Avoidance for X, reducing all damage taken from area of effect attacks from non-players by X%.
        -- (4) Increases the critical strike damage bonus of your Poisons by 100%.
        -- (6) Your finishing moves have a X% chance per combo point to make your next ability cost no energy.
    [1711] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Nightslayer Battlearmor
        -- (2) While Just a Flesh Wound and Blade Dance are active, Crimson Tempest, Blunderbuss, and Fan of Knives cost X less Energy and generate X% increased threat.
        -- (4) Vanish now reduces all Magic damage you take by X% for its duration, but it no longer grants Stealth or breaks movement impairing effects.
        -- (6) Your finishing moves have a X% chance per combo point to make you take X% less Physical damage from the next melee attack that hits you within X.
    [1712] = { [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Earthfury Relief
        -- (2) The radius of your totems that affect friendly targets is increased to X yd.
        -- (4) After casting your Healing Wave, Lesser Healing Wave, or Riptide spell, gives you a X% chance to gain Mana equal to 36% of the base cost of the spell.
        -- (6) Your Healing Wave will now jump to additional nearby targets. Each jump reduces the effectiveness of the heal by 61%, and the spell will jump to up to X additional targets.
    [1713] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Earthfury Eruption
        -- (2) The radius of your totems that affect friendly targets is increased to X yd.
        -- (4) Your Lightning Bolt critical strikes have a X% chance to reset the cooldown on Lava Burst and Chain Lightning and make the next Lava Burst or Chain Lightning within X instant.
        -- (6) Lava Burst now also refreshes the duration of Flame Shock on your target back to X.
    [1714] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Earthfury Impact
        -- (2) The radius of your totems that affect friendly targets is increased to X yd.
        -- (4) Increases your critical strike chance with spells and attacks by 3%.
        -- (6) Your Flurry talent grants an additional 11% increase to your attack speed.
    [1715] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [4]={stats={ITEM_MOD_CRIT_RATING_SHORT=3, ITEM_MOD_SPELL_CRIT_RATING_SHORT=3}}, [6]={stats={ITEM_MOD_SPELL_CRIT_RATING_SHORT=3}} },
    -- Earthfury Resolve
        -- (2) Increases your attack speed by X% for your next 3 swings after you parry, dodge, or block.
        -- (4) Your parries and dodges also activate your Shield Mastery rune ability.
        -- (6) Your Stoneskin Totem also reduces Physical damage taken by 4% and your Windwall Totem also reduces Magical damage taken by 4%.
    [1716] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Corrupted Felheart
        -- (2) Lifetap generates 51% more mana and 99% less threat.
        -- (4) Increases your critical strike chance with spells and attacks by 3%.
        -- (6) Your Nightfall talent has a 5% increased chance to trigger. Your Incinerate has a X% chance to trigger your Decimation regardless of the target's health.
    [1717] = { [4]={stats={ITEM_MOD_CRIT_RATING_SHORT=3, ITEM_MOD_SPELL_CRIT_RATING_SHORT=3}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Wicked Felheart
        -- (2) Banish is now instant cast, and can be cast on yourself while you are a Demon. You cannot Banish yourself while you have Forbearance, and doing so will give you Forbearance for X.
        -- (4) Each time you take damage, you and your pet gain mana equal to the damage taken, up to a maximum of 421 mana per event. Can only occur once every few seconds.
        -- (6) Your Shadow Cleave hits have a X% chance to grant you a Soul Shard, reset the cooldown on Soul Fire, and make your next Soul Fire within X instant.
    [1718] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Immoveable Might
        -- (2) Increases the block value of your shield by 31.
        -- (4) You gain X extra Rage every time you take any damage or deal auto attack damage.
        -- (6) Increases all threat you generate in Defensive Stance by an additional 11% and increases all damage you deal in Gladiator Stance by 5%.
    [1719] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Unstoppable Might
        -- (2) After changing stances, your next offensive ability's rage cost is reduced by 11.
        -- (4) For X after leaving a stance, you can use abilities requiring that stance as if you were still in that stance.
        -- (6) For the first X after activating a stance, you can gain an additional benefit: Battle Stance/Gladiator Stance: X% increased damage done. Berserker Stance: X% increased critical strike chance. Defensive Stance: X% reduced Physical damage taken.
    [1720] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=40, ITEM_MOD_SPELL_POWER_SHORT=20}} },
    -- Warlord's Battlegear
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +40 Attack Power.
    [1721] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Sanctuary
        -- (2) +20 Stamina.
        -- (3) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +40 Attack Power.
    [1722] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Wildhide
        -- (2) +20 Stamina.
        -- (3) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1723] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Warlord's Refuge
        -- (2) +20 Stamina.
        -- (3) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) Increases healing done by up to 45 and damage done by up to 16 for all magical spells and effects.
    [1724] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Warlord's Pursuit
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +20 Agility.
    [1725] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_AGILITY_SHORT=20}} },
    -- Warlord's Prowess
        -- (2) +20 Stamina.
        -- (3) Increases the duration of your Wing Clip by 2.0 sec.
        -- (6) +40 Attack Power.
    [1726] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Regalia
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Blink spell by 1.5 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1727] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Warlord's Raiment
        -- (2) +20 Stamina.
        -- (3) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1728] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Warlord's Investiture
        -- (2) +20 Stamina.
        -- (3) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) Increases healing done by up to 45 and damage done by up to 16 for all magical spells and effects.
    [1729] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Warlord's Vestments
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +40 Attack Power.
    [1730] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Earthshaker
        -- (2) +20 Stamina.
        -- (3) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +40 Attack Power.
    [1731] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Warlord's Thunderfist
        -- (2) +20 Stamina.
        -- (3) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1732] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Warlord's Wartide
        -- (2) +20 Stamina.
        -- (3) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) Increases healing done by up to 45 and damage done by up to 16 for all magical spells and effects.
    [1733] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Warlord's Threads
        -- (2) +20 Stamina.
        -- (3) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1734] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Wildhide
        -- (2) +20 Stamina.
        -- (3) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1735] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Refuge
        -- (2) +20 Stamina.
        -- (3) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) Increases healing done by up to 45 and damage done by up to 16 for all magical spells and effects.
    [1736] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Field Marshal's Sanctuary
        -- (2) +20 Stamina.
        -- (3) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +40 Attack Power.
    [1737] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Field Marshal's Prowess
        -- (2) +20 Stamina.
        -- (3) Increases the duration of your Wing Clip by 2.0 sec.
        -- (6) +40 Attack Power.
    [1738] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Field Marshal's Pursuit
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +20 Agility.
    [1739] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_AGILITY_SHORT=20}} },
    -- Field Marshal's Regalia
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Blink spell by 1.5 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1740] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Raiment
        -- (2) +20 Stamina.
        -- (3) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1741] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Investiture
        -- (2) +20 Stamina.
        -- (3) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) Increases healing done by up to 45 and damage done by up to 16 for all magical spells and effects.
    [1742] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Field Marshal's Vestments
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +40 Attack Power.
    [1743] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Field Marshal's Vindication
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) +40 Attack Power.
    [1744] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Field Marshal's Redemption
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) Increases healing done by up to 45 and damage done by up to 16 for all magical spells and effects.
    [1745] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=45, ITEM_MOD_SPELL_POWER_SHORT=16}} },
    -- Field Marshal's Threads
        -- (2) +20 Stamina.
        -- (3) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1746] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Field Marshal's Battlegear
        -- (2) +20 Stamina.
        -- (3) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +40 Attack Power.
    [1747] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [6]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}} },
    -- Champion's Wildhide
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [1748] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Refuge
        -- (2) Increases healing done by spells and effects by up to 44.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [1749] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=44}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Sanctuary
        -- (2) +40 Attack Power.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [1750] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Prowess
        -- (2) +40 Attack Power.
        -- (4) Increases the duration of your Wing Clip by 2.0 sec.
        -- (6) +20 Stamina.
    [1751] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Pursuit
        -- (2) +20 Agility.
        -- (4) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +20 Stamina.
    [1752] = { [2]={stats={ITEM_MOD_AGILITY_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Regalia
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 1.5 sec.
        -- (6) +20 Stamina.
    [1753] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Raiment
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +20 Stamina.
    [1754] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Investiture
        -- (2) Increases healing done by spells and effects by up to 44.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +20 Stamina.
    [1755] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=44}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Vestments
        -- (2) +40 Attack Power.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +20 Stamina.
    [1756] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Thunderfist
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +20 Stamina.
    [1757] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Wartide
        -- (2) Increases healing done by spells and effects by up to 44.
        -- (4) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +20 Stamina.
    [1758] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=44}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Earthshaker
        -- (2) +40 Attack Power.
        -- (4) Improves your chance to get a critical strike with all Shock spells by 2%.
        -- (6) +20 Stamina.
    [1759] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Threads
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) +20 Stamina.
    [1760] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Champion's Battlegear
        -- (2) +40 Attack Power.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +20 Stamina.
    [1761] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Wildhide
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [1762] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Refuge
        -- (2) Increases healing done by spells and effects by up to 44.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [1763] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=44}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Sanctuary
        -- (2) +40 Attack Power.
        -- (4) Increases your movement speed by 15% while in Bear, Cat, or Travel Form. Only active outdoors.
        -- (6) +20 Stamina.
    [1764] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Prowess
        -- (2) +40 Attack Power.
        -- (4) Increases the duration of your Wing Clip by 2.0 sec.
        -- (6) +20 Stamina.
    [1765] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Pursuit
        -- (2) +20 Agility.
        -- (4) Reduces the cooldown of your Concussive Shot by 1 sec.
        -- (6) +20 Stamina.
    [1766] = { [2]={stats={ITEM_MOD_AGILITY_SHORT=20}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Regalia
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the cooldown of your Blink spell by 1.5 sec.
        -- (6) +20 Stamina.
    [1767] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Raiment
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +20 Stamina.
    [1768] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Investiture
        -- (2) Increases healing done by spells and effects by up to 44.
        -- (4) Increases the duration of your Psychic Scream spell by 1 sec.
        -- (6) +20 Stamina.
    [1769] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=44}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Vestments
        -- (2) +40 Attack Power.
        -- (4) Reduces the cooldown of your Gouge ability by 1 sec.
        -- (6) +20 Stamina.
    [1770] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Threads
        -- (2) Increases damage and healing done by magical spells and effects by up to 23.
        -- (4) Reduces the casting time of your Immolate spell by 0.2 sec.
        -- (6) +20 Stamina.
    [1774] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Battlegear
        -- (2) +40 Attack Power.
        -- (4) Reduces the cooldown of your Intercept ability by 5 sec.
        -- (6) +20 Stamina.
    [1775] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Redemption
        -- (2) Increases healing done by spells and effects by up to 44.
        -- (4) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) +20 Stamina.
    [1776] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=44}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Lieutenant Commander's Vindication
        -- (2) +40 Attack Power.
        -- (4) Reduces the cooldown of your Hammer of Justice by 10 sec.
        -- (6) +20 Stamina.
    [1777] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={stats={ITEM_MOD_STAMINA_SHORT=20}} },
    -- Battlegear of Heroism
        -- (2) +40 Attack Power.
        -- (4) Chance on melee attack to heal you for X and energize you for X Rage
        -- (6) +8 All Resistances.
        -- (8) +200 Armor.
    [1778] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=40}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}}, [8]={stats={ITEM_MOD_ARMOR_SHORT=200}} },
    -- Core Hound's Call
        -- (2) Small chance on melee hit to call forth a Core Hound for X.
        -- (3) Small chance on melee hit to call forth the Spirit of Magmadar to assist you in battle. Increasing your attack speed by X% for X.
    [1779] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Shard of the Gods
        -- (2) Increases healing done by spells and effects by up to 55. / Increases damage done by magical spells and effects by up to 29. / Your spell casts have a chance to summon Servants of the Scale or Flame.
    [1780] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=55, ITEM_MOD_SPELL_POWER_SHORT=29}, equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}} },
    -- Spirit of Eskhandar
        -- (2) Improves your chance to hit with all spells and attacks by 1%.
        -- (3) Improves your chance to get a critical strike with all spells and attacks by 1%.
        -- (4) 1% chance on a melee hit to call forth the spirit of Eskhandar to protect you in battle for X.
    [1781] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=1, ITEM_MOD_SPELL_CRIT_RATING_SHORT=1}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- The Postmaster
        -- (2) +50 Armor.
        -- (3) +10 Fire Resistance. / +10 Arcane Resistance.
        -- (4) Increases damage and healing done by magical spells and effects by up to 12.
        -- (5) Increases run speed by 5%. / +10 Intellect.
    [1782] = { [2]={stats={ITEM_MOD_ARMOR_SHORT=50}}, [4]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}}, [5]={stats={ITEM_MOD_INTELLECT_SHORT=10}} },
    -- Spider's Kiss
        -- (2) Chance on Hit: Immobilizes the target and lowers their armor by 100 for 10 sec. / Increased Defense +7.
    [1783] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=7}, equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Dal'Rend's Arms
        -- (2) +50 Attack Power.
    [1784] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=50}} },
    -- Ironweave Battlesuit
        -- (2) Increases your chance to resist Silence and Interrupt effects by 10%.
        -- (4) +200 Armor.
        -- (6) Increases damage and healing done by magical spells and effects by up to 23.
    [1785] = { [4]={stats={ITEM_MOD_ARMOR_SHORT=200}}, [6]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Deathbone Guardian
        -- (2) Increased Defense +3.
        -- (3) +50 Armor.
        -- (4) +15 All Resistances.
        -- (5) Increases your chance to parry an attack by 1%.
    [1786] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=3}}, [3]={stats={ITEM_MOD_ARMOR_SHORT=50}}, [5]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}} },
    -- Necropile Raiment
        -- (2) +5 Stamina.
        -- (3) +5 Intellect.
        -- (4) +15 All Resistances.
        -- (5) Increases damage and healing done by magical spells and effects by up to 23.
    [1787] = { [2]={stats={ITEM_MOD_STAMINA_SHORT=5}}, [3]={stats={ITEM_MOD_INTELLECT_SHORT=5}}, [5]={stats={ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Bloodmail Regalia
        -- (2) Increased Defense +3.
        -- (3) +10 Attack Power.
        -- (4) +15 All Resistances.
        -- (5) Increases your chance to parry an attack by 1%.
    [1788] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=3}}, [3]={stats={ITEM_MOD_ATTACK_POWER_SHORT=10}}, [5]={stats={ITEM_MOD_PARRY_RATING_SHORT=1}} },
    -- Volcanic Armor
        -- (2) +10 Fire Resistance.
        -- (3) 5% chance of dealing X Fire damage on a successful melee attack.
    [1789] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Blue Dragon Mail
        -- (2) +4 All Resistances.
        -- (3) Increases damage and healing done by magical spells and effects by up to 28.
    [1790] = { [3]={stats={ITEM_MOD_SPELL_POWER_SHORT=28}} },
    -- Green Dragon Mail
        -- (2) Restores 3 mana per 5 sec.
        -- (3) Allows 15% of your Mana regeneration to continue while casting.
    [1791] = { [2]={stats={ITEM_MOD_MANA_REGENERATION_SHORT=3}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}} },
    -- Black Dragon Mail
        -- (2) Improves your chance to hit with all spells and attacks by 1%.
        -- (3) Improves your chance to get a critical strike with all spells and attacks by 3%.
        -- (4) +10 Fire Resistance.
    [1792] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=3, ITEM_MOD_SPELL_CRIT_RATING_SHORT=3}} },
    -- Devilsaur Armor
        -- (2) +10 Fire Resistance. / Improves your chance to hit with all spells and attacks by 3%.
    [1793] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=3, ITEM_MOD_HIT_SPELL_RATING_SHORT=3}} },
    -- Zanzil's Concentration
        -- (2) Increases damage and healing done by magical spells and effects by up to 6. / Improves your chance to hit with all spells and attacks by 1%.
    [1795] = { [2]={stats={ITEM_MOD_HIT_RATING_SHORT=1, ITEM_MOD_HIT_SPELL_RATING_SHORT=1, ITEM_MOD_SPELL_POWER_SHORT=6}} },
    -- Prayer of the Primal
        -- (2) Increases healing done by up to 34 and damage done by up to 12 for all magical spells and effects.
    [1796] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=12}} },
    -- Major Mojo Infusion
        -- (2) +30 Attack Power.
    [1797] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=30}} },
    -- Primal Blessing
        -- (2) Grants a small chance when ranged or melee damage is dealt to infuse the wielder with a blessing from the Primal Gods. Ranged and melee attack power increased by X for X.
    [1798] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Overlord's Resolution
        -- (2) Increased Defense +8.
    [1799] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=8}} },
    -- The Twin Blades of Hakkari
        -- (2) Increased Swords +3. / 3% chance on melee hit to gain 1 extra attack.
    [1800] = { [2]={stats={ITEM_MOD_WEAPON_SKILL_RATING_SHORT=3}, equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Eclipse of Stormrage
        -- (2) Increases the damage done and damage radius of Starfall's stars and Hurricane by 26%.
        -- (4) Your Wrath casts have a X% chance to summon a stand of 4 Treants to attack your target for X.
        -- (6) Your Wrath critical strikes have a X% chance to make your next Starfire deal X% increased damage, stacking up to X times.
    [1801] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Bounty of Stormrage
        -- (2) Your healing spell critical strikes trigger the Dreamstate effect, granting you X% of your mana regeneration while casting for X.
        -- (4) Your non-periodic spell critical strikes reduce the casting time of your next Healing Touch, Regrowth, or Nourish spell by X.1 sec.
        -- (6) Increases healing from Wild Growth by 11%. In addition, Wild Growth can now be used in Moonkin Form, and its healing is increased by an additional X% in that form.
    [1802] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Cunning of Stormrage
        -- (2) Increases the duration of Rake by 3.0 sec and its periodic damage by 11%.
        -- (4) Your critical strike chance is increased by X% while Tiger's Fury is active.
        -- (6) Your Shred, Ferocious Bite, and Mangle(Cat) abilities deal 11% increased damage per your Bleed effect on the target, up to a maximum of 21% increase.
    [1803] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Fury of Stormrage
        -- (2) Swipe(Bear) also causes your Maul to hit X additional target for the next X.
        -- (4) Your Mangle(Bear), Swipe(Bear), Maul, and Lacerate abilities gain 6% increased critical strike chance against targets afflicted by your Lacerate.
        -- (6) Your Swipe now spreads your Lacerate from your primary target to other targets it strikes.
    [1804] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Dragonstalker's Pursuit
        -- (2) Your Aimed Shot deals 21% more damage to targets afflicted by one of your trap effects.
        -- (4) Your damaging Shot abilities deal 11% increased damage if the previous damaging Shot used was different than the current one.
        -- (6) Your Serpent Sting damage is increased by 26% of your Attack Power over its normal duration.
    [1805] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Dragonstalker's Prowess
        -- (2) Raptor Strike increases the damage done by your next other melee ability (excluding Wing Clip) within X by X%.
        -- (4) Increases damage dealt by your main hand weapon with Raptor Strike and Wyvern Strike by 21%.
        -- (6) Your periodic damage has a X% chance to reset the cooldown on one of your Strike abilities. The Strike with the longest remaining cooldown is always chosen.
    [1806] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Netherwind Insight
        -- (2) Decreases the threat generated by your Fire spells by 19%.
        -- (4) Your Pyroblast deals 21% increased damage to targets afflicted with your Fireball's periodic effect.
        -- (6) Your Fireball's periodic effect gains increased damage over its duration equal to 101% of its impact damage.
    [1807] = { [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Netherwind Moment
        -- (2) Your Arcane Missiles refunds 11% of its base mana cost each time it deals damage.
        -- (4) Arcane Blast gains a 11% additional chance to trigger Missile Barrage, and Missile Barrage now affects Regeneration the same way it affects Arcane Missiles.
        -- (6) Your Temporal Beacons caused by Mass Regeneration now last 22 sec.
    [1808] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Merciful Judgement
        -- (2) Increases the critical strike chance of Holy Shock by 6%.
        -- (4) Increases the damage done by your Consecration by 51%.
        -- (6) While you are not your Beacon of Light target, your Beacon of Light target is also healed by 76% of the damage you deal with Consecration, Exorcism, Holy Shock, Holy Wrath, and Hammer of Wrath.
    [1809] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Radiant Judgement
        -- (2) Increases damage done by your damaging Judgements by 6% and your Judgements no longer consume your Seals on the target. Your Judgements can now trigger multiple Seals if active.
        -- (4) Reduces the cooldown on your Judgement ability by 5.0 sec, but reduces the damage your Judgements deal by 44%.
        -- (6) Your Judgement grants X% increased Holy damage for X, stacking up to X times.
    [1810] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=16, ITEM_MOD_SPELL_POWER_SHORT=8}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Wilfull Judgement
        -- (2) Increases the bonus chance to Block from Holy Shield by 11%.
        -- (4) You take X% reduced damage while Holy Shield is active.
        -- (6) Your Reckoning talent now has a 21% chance per talent point to trigger when you Block.
    [1811] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Dawn of Transcendence
        -- (2) Allows 15% of your Mana regeneration to continue while casting.
        -- (4) Your periodic healing has a X% chance to make your next spell with a casting time less than 10 seconds an instant cast spell.
        -- (6) Circle of Healing and Penance also place a heal over time effect on their targets that heals for 26% as much over X.
    [1812] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Twilight of Transcendence
        -- (2) Reduces the cooldown of your Shadow Word: Death spell by 6.0 sec.
        -- (4) Your Shadow Word: Pain has a X.1% chance per talent point in Spirit Tap to trigger your Spirit Tap talent when it deals damage, or a 21% chance per talent point when a target dies with your Shadow Word: Pain active. Inner Focus also has a 21% chance per talent point to trigger Spirit Tap.
        -- (6) While Spirit Tap is active, you deal X% more Shadow damage.
    [1813] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Bloodfang Thrill
        -- (2) Your opening moves have a X% chance to make your next ability cost no energy.
        -- (4) Increases damage dealt by your main hand weapon from combo-generating abilities by 21%.
        -- (6) Reduces the cooldown on Vanish to X min. Cannot be combined with Elusiveness.
    [1814] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Bloodfang Battlearmor
        -- (2) Your Rolling with the Punches now also activates every time you gain a combo point.
        -- (4) Your Rolling with the Punches also grants you 21% increased Armor from items per stack (capped at X%).
        -- (6) The cooldown on your Main Gauche resets every time your target Dodges or Parries.
    [1815] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Relief of the Ten Storms
        -- (2) Your non-periodic damaging and healing critical strikes now have a X% chance to trigger your Water Shield, but do not consume a charge or trigger its cooldown.
        -- (4) Your Chain Lightning now also heals the target of your most recent Earth Shield for 101% of the damage done.
        -- (6) Increases the healing of Chain Heal and the damage of Chain Lightning by 21%.
    [1816] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Eruption of the Ten Storms
        -- (2) Your spell critical strikes now have a X% chance trigger your Elemental Focus talent.
        -- (4) Loyal Beta from your Spirit of the Alpha ability now also increases Fire, Frost, and Nature damage by 6%.
        -- (6) While Clearcasting is active, you deal 16% more non-Physical damage.
    [1817] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Impact of the Ten Storms
        -- (2) Your chance to trigger Static Shock is increased by 13% (X% while dual-wielding).
        -- (4) Increases the main hand damage done by your Stormstrike by 51%.
        -- (6) While Static Shock is engraved, your Lightning Shield now gains a charge each time you hit a target with Lightning Bolt or Chain Lightning, up to a maximum of X charges. In addition, while Static Shock is engraved, your Lightning Shield can now deal critical damage.
    [1818] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Resolve of the Ten Storms
        -- (2) Your Flame Shock also grants X% increased chance to Block for X or until you Block an attack.
        -- (4) Each time you Block, your Block amount is increased by 11% of your Spell Damage for X, stacking up to X times.
        -- (6) Each time you Block an attack, you have a X% chance to trigger your Maelstrom Weapon rune.
    [1819] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Corrupted Nemesis
        -- (2) Increases the damage of your periodic spells and Felguard pet by 11%.
        -- (4) Periodic damage from your Shadowflame, Unstable Affliction, and Curse of Agony spells and damage done by your Felguard have a X% chance to grant the Shadow Trance effect.
        -- (6) Shadowbolt deals 11% increased damage for each of your effects afflicting the target, up to a maximum of 31%.
    [1820] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Wicked Nemesis
        -- (2) While you are targeting an enemy within X yards, Life Tap grants you mana at the expense of your target's health but deals 51% reduced damage to them. Mana gained remains unchanged.
        -- (4) While Metamorphosis is active, your offensive abilities and Demon summons cost no Soul Shards. In addition, you heal for X% of your maximum health when you damage a target with Shadowburn.
        -- (6) Any excess healing you deal to yourself is converted into a shield that absorbs damage. This shield can absorb up to 31% of your maximum health, and stacks from multiple heals.
    [1821] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Immoveable Wrath
        -- (2) You gain X Rage every time you Parry or one of your attacks is Parried.
        -- (4) Revenge also grants you Flurry, increasing your attack speed by X% for the next X swings.
        -- (6) When your target Parries an attack, you instantly Retaliate for X% weapon damage to that target. Retaliate cannot be Dodged, Blocked, or Parried, but can only occur once every X per target.
    [1822] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=46, ITEM_MOD_SPELL_POWER_SHORT=23}} },
    -- Unstoppable Wrath
        -- (2) Overpower critical strikes refresh the duration of Rend on your target back to its maximum duration.
        -- (4) Your Heroic Strike, Slam, and Overpower abilities deal 11% more damage.
        -- (6) Your Slam hits reset the remaining cooldown on your Mortal Strike, Bloodthirst, and Shield Slam abilities.
    [1823] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=34, ITEM_MOD_SPELL_POWER_SHORT=17}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Haruspex's Garb
        -- (2) Increases damage and healing done by magical spells and effects by up to 12.
        -- (3) Reduces the cast time and global cooldown of Starfire by 0.5.1 sec.
        -- (5) Increases the critical strike chance of Wrath by 11%.
    [1824] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=12}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Predator's Armor
        -- (2) +20 Attack Power.
        -- (3) Increases the Attack Power your Beast pet gains from your attributes by 20%.
        -- (5) Increases the Focus regeneration of your Beast pet by 20%.
    [1825] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Illusionist's Attire
        -- (2) Increases damage done by Frost spells and effects by up to 15.
        -- (3) Increases the chance to trigger your Fingers of Frost rune by an additional 16%.
        -- (5) Increases damage done by your Frostbolt and Spellfrost Bolt spells by 76%.
    [1826] = { [2]={stats={ITEM_MOD_FROST_DAMAGE_SHORT=15}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Freethinker's Armor
        -- (2) Increases damage done by Holy spells and effects by up to 15.
        -- (3) Increases damage done by your Holy Shock spell by 51%.
        -- (5) Reduces the cooldown of your Exorcism spell by 3.0 sec and increases its damage done by 76%.
    [1827] = { [2]={stats={ITEM_MOD_HOLY_DAMAGE_SHORT=15}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Confessor's Raiment
        -- (2) Increases healing done by up to 23 and damage done by up to 8 for all magical spells and effects.
        -- (3) Reduces the cooldown of your Penance spell by 6.0 sec.
        -- (5) Increases the damage absorbed by your Power Word: Shield spell by 11%.
    [1828] = { [2]={stats={ITEM_MOD_SPELL_HEALING_DONE_SHORT=23, ITEM_MOD_SPELL_POWER_SHORT=8}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Madcap's Outfit
        -- (2) +20 Attack Power.
        -- (3) Increases your chance to get a critical strike with Daggers by 5%.
        -- (5) Increases the critical strike chance of your Ambush ability by 31%.
    [1829] = { [2]={stats={ITEM_MOD_ATTACK_POWER_SHORT=20}}, [3]={stats={ITEM_MOD_CRIT_RATING_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Augur's Regalia
        -- (2) Increased Defense +7.
        -- (3) Increases your chance to block attacks with a shield by 11%.
        -- (5) Increases the chance to trigger your Power Surge rune by an additional 6%.
    [1830] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=7}}, [3]={stats={ITEM_MOD_BLOCK_RATING_SHORT=11}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Demoniac's Threads
        -- (2) Increases damage and healing done by magical spells and effects by up to 13.
        -- (3) Increases the Attack Power and Spell Damage your Demon pet gains from your attributes by 21%.
        -- (5) Increases the benefits of your Master Demonologist talent by 51%.
    [1831] = { [2]={stats={ITEM_MOD_SPELL_POWER_SHORT=13}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Vindicator's Battlegear
        -- (2) Increased Defense +7.
        -- (3) Reduces the cooldown on your Shield Slam ability by 2.0 sec.
        -- (5) Reduces the cooldown on your Bloodrage ability by 30.0 sec while you are in Gladiator Stance.
    [1832] = { [2]={stats={ITEM_MOD_DEFENSE_SKILL_RATING_SHORT=7}}, [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=10, ITEM_MOD_SPELL_POWER_SHORT=5}}, [5]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}} },
    -- Genesis Bounty
        -- (2) Reduces the cooldown of your Rebirth and Innervate spells by 64%.
        -- (4) Your critical heals with Healing Touch, Regrowth, and Nourish instantly heal the target for another 51% of the healing they dealt.
    [1835] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Genesis Eclipse
        -- (2) Your Nature's Grace talent gains 2 additional charge each time it triggers.
        -- (4) Increases the critical strike damage bonus of your Starfire, Starsurge, and Wrath by 61%.
    [1836] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Genesis Fury
        -- (2) Each time you Dodge while in Dire Bear Form, you gain X% increased damage on your next Mangle or Swipe, stacking up to X times.
        -- (4) Reduces the cooldown on Mangle (Bear) by 1.5.1 sec.
    [1837] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Genesis Cunning
        -- (2) Your Shred no longer has a positional requirement, but deals 6% more damage if you are behind the target.
        -- (4) Your Mangle, Shred, and Ferocious Bite critical strikes cause your target to Bleed for 31% of the damage done over the next X sec.
    [1838] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Striker's Pursuit
        -- (2) Increases Kill Shot's damage against non-player controlled targets by 11%.
        -- (4) Kill Shot's cooldown is reduced by 51%. While Rapid Fire is active with Rapid Killing engraved, Kill Shot has no cooldown, and when used against a non-player controlled target, fires 4 additional Kill Shots at 31% damage, with a minimum range.
    [1839] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Striker's Prowess
        -- (2) Increases Wyvern Strike damage over time by 51% and increases your pet's maximum focus by 51.
        -- (4) Increases the impact damage of Mongoose Bite and all Strikes by 21%.
    [1840] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Enigma Insight
        -- (2) Your Fire Blast now also causes your next Fire spell to gain X% increased critical strike chance for X.
        -- (4) Increases the damage done by your Ignite talent by 11%.
    [1841] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Enigma Moment
        -- (2) Your Arcane Blast increases damage done by an additional 11% per stack.
        -- (4) Your Mana Shield, Fire Ward, and Frost Ward absorb 51% more damage and also place a Temporal Beacon on the target for X.
    [1842] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Avenger's Mercy
        -- (2) Reduces the cooldown on Divine Light by 24%.
        -- (4) Your heals on your Beacon of Light target also heal the nearest friendly injured target for 91% as much.
    [1843] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Avenger's Will
        -- (2) Your Blessing of Sanctuary also grants X% increase to all stats when cast on yourself.
        -- (4) Shield of the Righteous causes your next Holy Light to be instant cast. If cast on self, it will refund 101% of its mana cost and be unaffected by Guarded by the Light.
    [1844] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Avenger's Radiance
        -- (2) Increases Crusader Strike damage by 151%.
        -- (4) Your basic attacks with two-handed melee weapons increase the damage of your next Exorcism cast within X by X%. Stacking up to 4 times.
    [1845] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Dawn of the Oracle
        -- (2) Your Prayer of Mending gains 3 additional charges.
        -- (4) Your Circle of Healing now heals the most injured member of the target party for 101% more.
    [1846] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Twilight of the Oracle
        -- (2) Your Mind Flay no longer loses duration from taking damage and launches a free Mind Spike at the target on cast.
        -- (4) Your Mind Spike is now instant, deals 11% more damage, and can be cast while channeling another spell.
    [1847] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Deathdealer's Thrill
        -- (2) Increases Mutilate and Saber Slash damage by 21%.
        -- (4) Reduces the cooldown on Adrenaline Rush by X min.
    [1848] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=18, ITEM_MOD_SPELL_POWER_SHORT=9}} },
    -- Deathdealer's Battlearmor
        -- (2) Your Main Gauche now strikes 2 additional nearby target and also causes your Sinister Strike to strike 2 additional nearby target for X. These additional strikes are not duplicated by Blade Flurry.
        -- (4) While active, your Main Gauche also causes you to heal for 16% of all damage done by Sinister Strike. Any excess healing becomes a Blood Barrier, absorbing damage up to 21% of your maximum health.
    [1849] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Stormcaller's Relief
        -- (2) Your Riptide increases the amount healed by Chain Heal by an additional 26%.
        -- (4) Reduces the cast time of Chain Heal by 0.5.1 sec.
    [1850] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Stormcaller's Eruption
        -- (2) You have a 71% chance to avoid interruption caused by damage while casting Lightning Bolt, Chain Lightning, or Lava Burst, and a 11% increased chance to trigger your Elemental Focus talent.
        -- (4) Increases the critical strike damage bonus of your Fire, Frost, and Nature spells by 61%.
    [1851] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Stormcaller's Resolve
        -- (2) Damaging a target with Stormstrike, Lava Burst, or Molten Blast also reduces all damage you take by X% for X.
        -- (4) When your Spirit of the Alpha is cast on yourself, it also increases your health by X%, your threat generated by X%, and all damage you deal by X%.
    [1852] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}} },
    -- Stormcaller's Impact
        -- (2) Increases Stormstrike and Lava Lash damage by 51%. This effect is increased to 101% if using a two-handed weapon.
        -- (4) Your Stormstrike, Lava Lash and Lava Burst critical strikes cause your target to burn for 31% of the damage done over X.
    [1853] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Doomcaller's Corruption
        -- (2) Reduces the cooldown on your Chaos Bolt by 49% and increases Chaos Bolt and Shadow Bolt damage done by 11%. In addition, Chaos Bolt can now trigger your Improved Shadow Bolt talent and causes it to have 27 additional charges (does not stack with Shadowflame's additional charges).
        -- (4) Each time you hit a target with Conflagrate, you gain X% increased Fire damage for X, stacking up to X times.
    [1854] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Doomcaller's Malevolence
        -- (2) Reduces the cooldown on your Shadow Cleave by 1.5.1 sec.
        -- (4) The effects of your Demonic Sacrifice now persist while you have a Demon pet active, as long as you do not resummon the sacrificed pet. You may have only one Demonic Sacrifice effect active at a time.
    [1855] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Conqueror's Advance
        -- (2) Reduces the cooldown on your Death Wish by 49%.
        -- (4) You deal 16% increased damage while any nearby enemy is afflicted with both your Rend and your Deep Wounds.
    [1856] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=36, ITEM_MOD_SPELL_POWER_SHORT=18}} },
    -- Conqueror's Bulwark
        -- (2) Reduces the cooldown on Thunder Clap by 99%.
        -- (4) Your Shield Slam deals 101% increased threat and its cooldown is reset if it is Dodged, Parried, or Blocked.
    [1857] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}} },
    -- Symbols of Unending Life
        -- (3) Your melee attacks have 4% less chance to be Dodged or Parried.
    [1858] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Trappings of the Unseen Path
        -- (3) Increases the Focus regeneration of your pets by 101%.
    [1859] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Trappings of Vaulted Secrets
        -- (3) Your Fireball, Frostfire Bolt, and Balefire Bolt spells gain 5% increased damage for each of your Fire effects on your target, up to a maximum increased of 13%.
    [1860] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Battlegear of Eternal Justice
        -- (3) While a one-handed weapon is equipped, Crusader Strike now unleashes the Judgement effect of your Seals, but does not consume the Seal.
    [1861] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Finery of Infinite Wisdom
        -- (3) Your Pain and Suffering rune can now refresh the duration of Devouring Plague.
    [1862] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}} },
    -- Emblems of Veiled Shadows
        -- (3) Your finishing moves cost 49% less Energy.
    [1863] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Gift of the Gathering Storm
        -- (3) Your Lava Burst damage is increased by a percentage equal to your spell critical strike chance.
    [1864] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Implements of Unspoken Names
        -- (3) For X after using Shadowcleave, your Searing Pain strikes X additional target within melee range.
    [1865] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}} },
    -- Battlegear of Unyielding Strength
        -- (3) Reduces the cooldown on Shockwave by 24%.
    [1866] = { [3]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=12, ITEM_MOD_SPELL_POWER_SHORT=6}} },
    -- Kharon's Decree
        -- (2) The damage dealt by Creeping Darkness is increased by 101%.
    [1881] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=24, ITEM_MOD_SPELL_POWER_SHORT=12}} },
    -- Dreadnaught's Battlegear
        -- (2) Your Taunt ability never misses, and your chance to be Dodged or Parried is reduced by 1%.
        -- (4) Reduces the cooldown on your Shield Wall ability by X min and reduces the cooldown on your Recklessness ability by X min. Recklessness can now be used in any Stance and does not increase damage taken.
        -- (6) When you take damage from an Undead enemy, the remaining duration of your active Last Stand is reset to 21 sec.
    [1882] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Dreadnaught's Warplate
        -- (2) Increases damage done by your Deep Wounds talent by 21%.
        -- (4) Reduces the cooldown on your Bloodthirst, Mortal Strike, and Shield Slam abilities by 24%.
        -- (6) Your melee critical strikes against Undead enemies grant you X% increased damage and critical damage done to Undead for X, stacking up to X times.
    [1883] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Plagueheart Stitchings
        -- (2) Your Menace ability never misses, and your chance to be Dodged or Parried or for your spells to miss is reduced by 1%.
        -- (4) Reduces the cooldown on your Infernal Armor ability by 10.0 sec and reduces the cooldown on your Demonic Grace ability by 3.0 sec.
        -- (6) When an Undead enemy attempts to attack you, the remaining duration of your active Vengeance is reset to 21 sec.
    [1884] = { [2]={stats={ITEM_MOD_HIT_SPELL_RATING_SHORT=3}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Plagueheart Raiment
        -- (2) Increases the damage done by your Incinerate and Corruption abilities by 21%.
        -- (4) Your non-periodic critical strikes cause your active Corruption, Immolate, Shadowflame, and Unstable Affliction spells on the target to immediately deal a tick of damage at 34% effectiveness.
        -- (6) Your Curse of Agony also applies the effects of Curse of Recklessness. In addition, it does not expire on Undead targets and continues to grow in power indefinitely.
    [1885] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- The Earthshatterer's Resolve
        -- (2) Your Earth Shock ability never misses when used as a taunt, and your chance to be Dodged or Parried is reduced by 1%.
        -- (4) Increases the damage taken reduction from your Shamanistic Rage ability by an additional 9% and during Shamanistic Rage your attack speed and spellcasting speed are increased by 31%.
        -- (6) You take 21% reduced damage from Undead enemies.
    [1886] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- The Earthshatterer
        -- (2) Your Earth Shield ability no longer loses charges.
        -- (4) Your Healing Wave Rank 9 and Rank 10 and Lesser Healing Wave Rank 6 spells have a X% chance to imbue your target with Totemic Power.
        -- (6) The target of your Earth Shield ability takes 21% reduced damage from Undead enemies.
    [1887] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- The Earthshatterer's Rage
        -- (2) While Static Shock is engraved, the damage done by your Lightning Shield is increased by 101%.
        -- (4) Reduces the cooldown on your Lava Lash and Stormstrike abilities by 1.5.1 sec.
        -- (6) You gain X% increased damage and critical damage done to Undead for X for each charge of Maelstrom Weapon you earn, stacking up to X times.
    [1888] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- The Earthshatterer's Storm
        -- (2) Increases periodic damage done by your Flame Shock ability by 41%.
        -- (4) Reduces the cooldown on your Lava Burst ability by 2.0 sec.
        -- (6) You gain X% increased damage and critical damage done to Undead for X for each time your Overload triggers from an offensive spell cast, stacking up to X times.
    [1889] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Bonescythe Leathers
        -- (2) Your Tease ability never misses, and your chance to be Dodged or Parried is reduced by 1%.
        -- (4) Reduces the cooldown on your Evasion ability by X min and reduces the cooldown on your Blade Flurry ability by X min.
        -- (6) Any damage from an Undead attacker which would otherwise kill you will instead reduce you to 11% of your maximum health (or your current health, whichever is lower). In addition, all damage taken from Undead will be reduced by X% for X. This effect cannot occur more than once per minute.
    [1890] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Bonescythe Armor
        -- (2) Your Ambush, and Instant Poison deal 21% more damage. Your Backstab deals 11% more damage (Does not benefit Mutilate). You heal for 6% of all damage done by your Poisons.
        -- (4) You have a X% chance to gain X Energy each time you deal periodic Nature or Bleed damage.
        -- (6) You gain X% increased damage and critical damage done to Undead for X per Combo Point you spend, stacking up to X times.
    [1891] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Vestments of Faith
        -- (2) Reduces the cooldown on your Circle of Healing and Penance abilities by 24%.
        -- (4) Your Penance, Flash Heal Rank 7, Binding Heal, and Greater Heal Rank 4 and Rank 5 have a X% chance to grant the target X% increased critical strike chance for X.
        -- (6) Your Power Word: Shield has a 51% chance to not deplete when the target is damaged by an Undead enemy.
    [1892] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Raiments of Faith
        -- (2) Your Shadow Word: Pain ability deals 21% more damage.
        -- (4) Reduces the cooldown on your Mind Blast ability by X.1 sec.
        -- (6) Your Mind Flay, Mind Blast, and Mind Spike abilities deal increased damage to Undead targets equal to their critical strike chance.
    [1893] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Redemption Bulwark
        -- (2) Your Hand of Reckoning ability never misses, and your chance to be Dodged or Parried is reduced by 1%.
        -- (4) Reduces the cooldown on your Divine Protection ability by X min and reduces the cooldown on your Avenging Wrath ability by X min.
        -- (6) When damage from an Undead enemy takes you below X% health, the effect from Hand of Reckoning and Righteous Fury now reduces that damage by 51%.
    [1894] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Redemption Armor
        -- (2) Reduces the cooldown on your Lay on Hands ability by X min, and your Lay on Hands now restores you to 31% of your maximum Mana when used.
        -- (4) Your Flash of Light Rank 6 and Holy Light Rank 8 and Rank 9 spells have a X% chance to imbue your target with Holy Power.
        -- (6) Your Beacon of Light target takes 21% reduced damage from Undead enemies.
    [1895] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Redemption Warplate
        -- (2) Increases the damage done by your Divine Storm ability by 101%.
        -- (4) Reduces the cast time of your Holy Wrath ability by 99%, reduces its cooldown by 24%, and reduces its mana cost by 74%.
        -- (6) Your Crusader Strike, Divine Storm, Exorcism and Holy Wrath abilities deal increased damage to Undead equal to their critical strike chance while Righteous Fury is not active and Hand of Reckoning is not engraved.
    [1896] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Frostfire Vestments
        -- (2) Allies with your Temporal Beacon heal for X health every X sec.
        -- (4) Your Regeneration ability grants your target 61% increased movement speed while you are channeling, and each time it heals your target, they have a chance to gain X% increased attack and casting speed for X.
        -- (6) Damage you deal to Undead causes 26% more chronomantic healing, and you gain mana equal to 6% of the chronomantic healing you generate from damaging Undead.
    [1897] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Frostfire Regalia
        -- (2) Reduces the cooldown on your Evocation ability by 79%.
        -- (4) Your Evocation grants you $?a1218232|a1218271|a1218275|a1218276|a1218283|a1224428[X%][X%] increased damage done every sec you channel it, stacking up to 9 times and lasting X.
        -- (6) Your Ignite damage does not decay on Undead targets below 21% health, and Undead targets below 21% health take damage as if they were Frozen.
    [1898] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Cryptstalker Armor
        -- (2) Reduces the cooldown on Chimera Shot, Explosive Shot, and Aimed Shot by 1.5.1 sec, Kill Shot by 3.0 sec, and Multi-Shot by 3.0 sec.
        -- (4) Your Serpent Sting deals 21% more damage.
        -- (6) You gain X% increased damage and critical damage done to Undead for X each time you hit an Undead enemy with a ranged attack, stacking up to X times.
    [1899] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Cryptstalker Prowess
        -- (2) Your Wyvern Strike and Mongoose Bite deal 31% more initial damage.
        -- (4) Reduces the cooldown on your Wyvern Strike ability by 2.0 sec, reduces the cooldown on your Raptor Strike ability by 1.0 sec, and reduces the cooldown on your Flanking Strike ability by 8.0 sec.
        -- (6) You gain X% increased damage and critical damage done to Undead for X each time you hit an Undead enemy with a melee attack, stacking up to X times. Stacks are lost upon performing a ranged attack.
    [1900] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Dreamwalker Guardian
        -- (2) Your Growl ability never misses, and your chance to be Dodged or Parried is reduced by 1%.
        -- (4) Reduces the cooldown on your Survival Instincts by X min, and reduces the cooldown on your Berserk ability by X min.
        -- (6) When you take damage from an Undead enemy, the remaining duration of your active Frenzied Regeneration is reset to 11 sec. In addition, Frenzied Regeneration will never consume your last 16 Rage to generate healing.
    [1901] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Dreamwalker Raiment
        -- (2) Your Lifebloom now has a 101% chance to heal the target for one application of its dispel amount each time the target takes damage. This effect can only occur once every few seconds.
        -- (4) Each time your Rejuvenation rank 10 or rank 11 heals a target, you have a 26% chance to restore X mana, X energy, or X rage to your target.
        -- (6) Your Rejuvenation and Regrowth refresh their duration to full each time their target is damaged by an Undead enemy.
    [1902] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=38, ITEM_MOD_SPELL_POWER_SHORT=19}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Dreamwalker Ferocity
        -- (2) Your Rake now deals its periodic damage against non-player controlled targets every 2 sec, increasing its total damage over time by 201%.
        -- (4) Your Tiger's Fury cooldown is reduced by 49%.
        -- (6) Each time you deal Bleed damage to an Undead target, you gain X% increased damage and critical damage done to Undead for X, stacking up to X times.
    [1903] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=52, ITEM_MOD_SPELL_POWER_SHORT=26}} },
    -- Dreamwalker Eclipse
        -- (2) Your Moonfire and Sunfire deal 21% more damage.
        -- (4) The cooldown of your Starsurge spell is reduced by 1.5.1 sec.
        -- (6) When your Starsurge strikes an Undead target, the remaining duration on your active Starfall is reset to 11 sec.
    [1904] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=26, ITEM_MOD_SPELL_POWER_SHORT=13}} },
    -- Undead Slayer's Armor
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1905] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Garb of the Undead Slayer
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1906] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Battlegear of Undead Slaying
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1907] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Regalia of Undead Cleansing
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1908] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Battlegear of Undead Warding
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1909] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Battlegear of Undead Purification
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1910] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Garb of the Undead Cleansing
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1911] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Garb of the Undead Warder
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1912] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Garb of the Undead Purifier
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1913] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Undead Cleanser's Armor
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1914] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Undead Purifier's Armor
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1915] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Undead Warder's Armor
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1916] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Regalia of Undead Purification
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1917] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Regalia of Undead Warding
        -- (2) Treats your Seal of the Dawn bonus as if you were wearing 3 additional Sanctified items. (Equipping more than 9 Sanctified items provides no additional benefit)
    [1918] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=20, ITEM_MOD_SPELL_POWER_SHORT=10}} },
    -- Lightbreaker's Warplate
        -- (2) Your Heroic Strike, Cleave, and Quick Strike damage is increased by 21% while in Battle Stance or Berserker Stance. Your Cleave strikes 2 additional target and can trigger Blood Surge.
        -- (4) Each time you hit a target with Whirlwind, Heroic Strike, Quick Strike, or Cleave, the damage of your next Slam is increased by X%, stacking up to X times.
        -- (6) Each time Deep Wounds deals damage, it reduces the remaining cooldown on your Whirlwind by 4 sec. Whirlwind deals 101% increased damage to targets afflicted with your Deep Wounds.
    [1932] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Lightbreaker's Battlegear
        -- (2) Your Shockwave deals 61% increased damage and its cooldown is reduced by 2.0.1 sec each time you hit a target with Heroic Strike or Cleave.
        -- (4) Your Recklessness, Retaliation, and Shield Wall abilities no longer share a cooldown. Additionally, your Recklessness ability lasts 15.0 sec longer, and while it is active you gain 51% of your Defense Skill over 300 as Strength.
        -- (6) Your abilities no longer have stance requirements. In addition, hits from Revenge, Devastate, or Shield Slam increase the damage done by your next Whirlwind or Execute by X%, stacking up to X times.
    [1933] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Duskwraith Armor
        -- (2) While Just a Flesh Wound is not active, your Backstab, Sinister Strike, Saber Slash, and Mutilate deal 21% increased damage per your active Poison or Bleed effect afflicting the target, up to a maximum increase of 61%.
        -- (4) Your Poison and autoattack critical strikes have a X% chance to grant you a combo point.
        -- (6) Increases Ambush, Eviscerate, Crimson Tempest, and Envenom damage by 51%.
    [1934] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Duskwraith Leathers
        -- (2) Your stacks of Rolling with the Punches also increase all damage you deal by X%.
        -- (4) Your Blade Flurry now also strikes a third target and increases your attack speed by an additional 11%. In addition, each combo point you spend reduces the remaining cooldown on your Blade Flurry by 0.5.1 sec.
        -- (6) Your Rolling with the Punches now grants 3% more health and 2% more damage per stack. At 6 stacks, each time you Dodge or Parry you will gain X Energy.
    [1935] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Dawnstalker Prowess
        -- (2) Your Strikes and Mongoose Bite deal 26% increased damage to targets afflicted with your Serpent Sting or Wyvern Strike.
        -- (4) Your melee critical strikes increase your attack speed by X% for X.
        -- (6) Increases the bonus damage from Raptor Fury by an additional 16% per stack.
    [1936] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Dawnstalker Armor
        -- (2) Your Shots deal 26% increased damage to targets afflicted with your Serpent Sting.
        -- (4) Your ranged critical strikes increase your Attack Power by X% for X.
        -- (6) Your Multi-Shot hits 3 additional targets, and your Kill Shot and Chimera Shot hits increase the damage done by your next Multi-Shot cast within X by 51%, stacking up to X times.
    [1937] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Raiments of Revelation
        -- (2) Your Mind Flay and Mind Sear no longer lose duration from taking damage during their channel. In addition, they deal 11% increased damage per other periodic Shadow effect you have on the target, up to a maximum increase of X%.
        -- (4) Your Mind Blast deals 49% reduced threat, and gains 21% damage increase from each stack of Mind Spike on the target.
        -- (6) Damage done by your Mind Flay now increases the longer you channel the spell. Each time it deals damage, subsequent damage will increase by 71%. This resets on each new channel.
    [1938] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Vestments of Revelation
        -- (2) Reduces the cooldown of Power Word: Barrier by 30.0 sec and Surge of Light now also makes Prayer of Healing and Greater Heal instant cast.
        -- (4) Power Word: Shield casts instantly heal the target for 61% of the absorb value and Serendipity empowered spells have their healing increased by 11% per stack.
        -- (6) Increases the healing of Circle of Healing and Penance by 26%. Additionally, the cooldown of your Spirit of the Redeemer is reduced by 30.0 sec and your healing is increased by 21% while your Spirit of the Redeemer is active.
    [1939] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Inquisition Warplate
        -- (2) While you have a two-handed weapon equipped, Crusader Strike and Exorcism grant you Holy Power, increasing all Holy damage you deal by X%, stacking up to X times.
        -- (4) Divine Storm, Holy Shock, and Holy Wrath consume all your Holy Power, dealing 101% increased damage per Holy Power you have accumulated, 51% effective against player controlled targets.
        -- (6) Consuming Holy Power increases your Attack Power by X% per Holy Power consumed for X.
    [1940] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Inquisition Armor
        -- (2) Lay on Hands grants you X% Spell Haste for X and reduces the Global Cooldown of your next X Divine Light, Holy Light, Flash of Light, or Holy Shock spells by X.1 seconds.
        -- (4) Your Beacon of Light now also triggers when you heal your Beacon of Light target, but at 51% reduced effectiveness.
        -- (6) An additional 26% of your healing is transferred to your Beacon of Light target.
    [1941] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Inquisition Bulwark
        -- (2) Shield of Righteousness also increases your Block Value by X% for X.
        -- (4) Shield of Righteousness deals percentage increased damage equal to your Block Chance.
        -- (6) Your Avenging Wrath no longer triggers Forbearance, lasts 15.0 sec longer, and increases your Block Value by X%.
    [1942] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Fireleaf Regalia
        -- (2) Your Living Bomb now deals damage every 2 sec, and will detonate if the target dies. In addition, the effect of Glaciate from the rune of Ice Lance now stacks up to 11 times, and Spellfrost Bolt grants 3 stacks each time it hits.
        -- (4) Casting Deep Freeze increases the remaining duration of your Icy Veins spell by 10.0 sec. Casting Pyroblast cancels 3 X:stacks; of the effect from your Balefire Bolt.
        -- (6) Reduces the cooldown on your Frozen Orb spell by 25.0 sec. Each time Glaciate is consumed, the cooldown on your Deep Freeze is reduced by 1.0.1 sec per stack consumed. Reduces the cooldown on Fire Blast by 5.0 sec and Fire Blast now refreshes the duration of your Living Bomb on the target.
    [1943] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Fireleaf Vestments
        -- (2) Your Arcane Blast has a 11% chance to cause Arcane Tunneling. Arcane Tunneling prevents your Arcane Blast effect from being consumed by the next other Arcane damage spell you cast. In addition, activating Arcane Power resets the cooldown on your Mass Regeneration.
        -- (4) Rewind Time also reduces all damage taken by your target by X% for X.
        -- (6) Reduces the cooldown of your Arcane Power by 90.0 sec and increases its duration by 10.0 sec. While Arcane Power is active, your chance to gain Arcane Tunneling is increased by 11% and each cast of Arcane Blast reduces the remaining cooldown on Mass Regeneration by 1.0.1 sec.
    [1944] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Waywatcher Ferocity
        -- (2) You gain X Energy each time Rake or Rip deals periodic damage.
        -- (4) Multiplies the damage bonus from Tiger's Fury by X.0.
        -- (6) Your Finishing Moves have a 21% chance per combo point spent to trigger Clearcasting and extend the duration of your active Tiger's Fury by X sec.
    [1945] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}} },
    -- Waywatcher Eclipse
        -- (2) Your Starfire deals 21% more damage to targets with your Moonfire, and your Wrath deals 41% more damage to targets with your Sunfire.
        -- (4) Your Starsurge now increases the damage of your next X Starfires.
        -- (6) Each time your Sunfire deals periodic damage, you gain X% increased damage to your next Wrath, stacking up to X times. Each time your Moonfire deals periodic damage, you gain X% increased damage to your next Starfire, stacking up to X times. These bonuses do not apply to Starsurge.
    [1946] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Waywatcher Raiment
        -- (2) Each time your Lifebloom heals a target, it has a X% chance to make your next Healing Touch, Nourish, or Regrowth within X instant cast.
        -- (4) Targets with your active Rejuvenation Rank 10 or Rank 11 receive X% increased healing from your spells.
        -- (6) Your non-periodic heals from Regrowth Rank 8 or Rank 9 have a X% chance to spread your Rejuvenation on that target to all members of the target's party within X yards not already affected by your Rejuvenation.
    [1947] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Waywatcher Guardian
        -- (2) Your melee critical strikes in Bear Form or Dire Bear Form grant you a shield lasting X that absorbs Physical damage equal to X% of your Attack Power the next time you take Physical damage. Stacks up to X times.
        -- (4) Increases the duration of your Berserk ability by 15.0 sec.
        -- (6) You gain X% increased attack speed for X every time you deal a critical strike.
    [1948] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- The Soulcrusher's Resolve
        -- (2) Your Shock spells activate your Shield Mastery rune ability, and the effect of Shield Mastery can now stack up to 8 times.
        -- (4) Each time your Lightning Shield deals damage, you heal for 101% of the damage it dealt, no more than once every 4 sec.
        -- (6) Your Shield Mastery stacks also reduce the cast time of your Lava Burst by 21% per stack. Lava Burst no longer consumes Maelstrom Weapon charges.
    [1949] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- The Soulcrusher
        -- (2) Heals from your Earth Shield have a 26% chance to make your next cast time heal instant cast.
        -- (4) Your Healing Wave and Lesser Healing Wave also heal your Earth Shield target for 51% as much, if that is a different target.
        -- (6) Your Chain Heal jumps to 2 additional targets and its magnitude reduces 21% less per jump.
    [1950] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- The Soulcrusher's Rage
        -- (2) While Static Shock is active, Lava Lash, Lava Burst, and Stormstrike have a X% chance to add a charge to your Lightning Shield. If charges exceed 10, Lightning Shield will immediately deal damage to your target instead of adding charges.
        -- (4) Reduces the cooldown on your Fire Nova Totem by 59%, increases its damage by 201%, and reduces its mana cost by 59%. Additionally, your Fire Nova Totem now activates instantly on cast.
        -- (6) Maelstrom Weapon can now stack up to X charges. When using a two-handed weapon, gain 3 charges at a time. Casts with over 6 charges increase that spell's damage or healing dealt by 21% per excess charge. Casts while at X charges will consume all charges and cast twice.
    [1951] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=22, ITEM_MOD_SPELL_POWER_SHORT=11}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- The Soulcrusher's Storm
        -- (2) When your Lava Burst, Chain Lightning, or Lightning Bolt strikes a target afflicted with your Flame Shock Rank 5 or Rank 6, it also deals one pulse of Flame Shock's damage.
        -- (4) Chance to trigger Overload increased by an additional 11% and Lava Bursts damage is increased by a percentage equal to your spell critical strike chance. When Lightning Bolt or Chain Lightning deal damage, increase the damage dealt by your next Lava Burst cast within X by X%, stacking up to X times.
        -- (6) When your Chain Lightning damages fewer than 4 targets, it deals 36% increased damage for each target less than 4.
    [1952] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Heretic Stitchings
        -- (2) Your Shadow Cleave now applies your Corruption Rank 7 to every target it hits but its duration is only X.
        -- (4) You heal for 11% of all damage done by your Corruption. This healing is increased to 101% if the target is also afflicted with your Drain Life.
        -- (6) Your Infernal Armor now also increases all magical damage you deal by X% and lasts an additional 10.0 sec.
    [1953] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=14, ITEM_MOD_SPELL_POWER_SHORT=7}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Heretic Raiment
        -- (2) Your Shadow and Fire non-periodic critical strikes cause the target to Burn for 26% of the damage they deal over X.
        -- (4) Your Shadow Bolt, Haunt, Chaos Bolt, Shadow Cleave, and Soul Fire deal 31% more damage to targets afflicted with your Corruption.
        -- (6) Your periodic critical strikes grant X% spellcasting haste for X, and your Backdraft grants an additional 13% spellcasting haste.
    [1954] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
    -- Fallen Regality
        -- (2) $?s21184[Damaging finishing moves have a X% chance per combo point to restore X energy.]?s446658[If Cleave hits fewer than its maximum number of targets, it deals X% more damage for each unused bounce.]?s446374[Flanking Strike's damage buff is increased by an additional X% per stack. When striking from behind, your target takes X% increased damage from Flanking Strike.][The blades will never accept you as their master.]
    [1955] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Tools of the Nathrezim
        -- (2) Duplicity and Deception's extra attacks now trigger 3 extra attacks.
    [1956] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Hack and Smash
        -- (2) The damage increases from Mercy's and Crimson Cleaver's effects are increased by 11%.
    [1959] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=28, ITEM_MOD_SPELL_POWER_SHORT=14}} },
    -- Inquisition Shockplate
        -- (2) While Shock and Awe is active, Crusader Strike and Exorcism grant you Holy Power, increasing all Holy damage you deal by X%, stacking up to X times.
        -- (4) Divine Storm, Holy Shock, and Holy Wrath consume all your Holy Power, dealing 101% increased damage per Holy Power you have accumulated, 51% effective against player controlled targets.
        -- (6) Consuming Holy Power increases your Spell Power by X% per Holy Power consumed for X.
    [1963] = { [2]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=30, ITEM_MOD_SPELL_POWER_SHORT=15}}, [4]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=44, ITEM_MOD_SPELL_POWER_SHORT=22}}, [6]={equiv={ITEM_MOD_ATTACK_POWER_SHORT=58, ITEM_MOD_SPELL_POWER_SHORT=29}} },
}

-- =============================================================
-- PROC DATABASE (Dynamic PPM / Cooldown Logic)
-- Scoring lookup: ProcDB -> WeaponDB -> TrinketDB in Helpers.GetRawItemStats.
-- An entry with ppm/val/stat ADDS its average value to the item's own stats
-- (a use effect is ppm = 60 / cooldown in sec, with dur). An entry with
-- score REPLACES the item's whole score, so score is only for items whose
-- value is all in the effect (no stats worth scoring).
-- Use-effect values checked against the Era client (ItemEffect / SpellEffect,
-- build 1.15.9.70003). Neltharion's Tear, Drake Fang Talisman and Flurry Axe
-- score from their own stats; Kiss of the Spider's attack speed isn't weighted.
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
    [21670] = { score=35, note = MSC.L["Armor Penetration Proc"] }, -- Badge of the Swarmguard
    [19339] = { score=40, note = MSC.L["Haste Use Effect (Mage Only)"] }, -- Mind Quickening Gem
    [21625] = { score=40, note = MSC.L["Heals Grant Shield"] }, -- Scarab Brooch
    [19341] = { score=40, note = MSC.L["Health Use Effect"] }, -- Lifegiving Gem

    -- [[ ENGINEERING ]]
    [10725] = { score=15, note = MSC.L["Summons Battle Chicken (Haste Buff)"] }, -- Gnomish Battle Chicken
    [16022] = { score=10, note = MSC.L["Summons Dragonling (Fire Vuln.)"] }, -- Arcanite Dragonling
    [10645] = { score=10, note = MSC.L["Burst Damage (Life Cost)"] }, -- Gnomish Death Ray
    [2820]  = { score=5,  note = MSC.L["Run Speed Use Effect"] }, -- Nifty Stopwatch
    [11905] = { score=10, note = MSC.L["Ranged Damage/Stun/Daze"] }, -- Linken's Boomerang
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
