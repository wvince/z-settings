-- Item IDs/rarities checked 2026-10-02 in Wowhead Forever. See DATA_SOURCES.md.
local materialIDs = {
  ["Arthas' Tears"] = 8836,
  ["Blindweed"] = 8839,
  ["Bolt of Linen Cloth"] = 2996,
  ["Bolt of Mageweave"] = 4339,
  ["Bolt of Runecloth"] = 14048,
  ["Bolt of Silk Cloth"] = 4305,
  ["Bolt of Woolen Cloth"] = 2997,
  ["Briarthorn"] = 2450,
  ["Bronze Bar"] = 2841,
  ["Bronze Framework"] = 4382,
  ["Bronze Tube"] = 4371,
  ["Bruiseweed"] = 2453,
  ["Copper Bar"] = 2840,
  ["Copper Modulator"] = 4363,
  ["Copper Ore"] = 2770,
  ["Copper Tube"] = 4361,
  ["Cured Heavy Hide"] = 4236,
  ["Cured Light Hide"] = 4231,
  ["Cured Medium Hide"] = 4233,
  ["Cured Thick Hide"] = 8172,
  ["Dark Iron Bar"] = 11371,
  ["Dark Iron Ore"] = 11370,
  ["Dream Dust"] = 11176,
  ["Dreamfoil"] = 13463,
  ["Earthroot"] = 2449,
  ["Fadeleaf"] = 3818,
  ["Firebloom"] = 4625,
  ["Ghost Mushroom"] = 8845,
  ["Gold Bar"] = 3577,
  ["Gold Ore"] = 2776,
  ["Gold Power Core"] = 10558,
  ["Golden Sansam"] = 13464,
  ["Goldthorn"] = 3821,
  ["Grave Moss"] = 3369,
  ["Greater Astral Essence"] = 11082,
  ["Greater Magic Essence"] = 10939,
  ["Greater Mystic Essence"] = 11135,
  ["Greater Nether Essence"] = 11175,
  ["Gromsblood"] = 8846,
  ["Handful of Copper Bolts"] = 4359,
  ["Heavy Leather"] = 4234,
  ["Icecap"] = 13467,
  ["Iron Bar"] = 3575,
  ["Iron Ore"] = 2772,
  ["Iron Strut"] = 4387,
  ["Khadgar's Whisker"] = 3358,
  ["Kingsblood"] = 3356,
  ["Large Brilliant Shard"] = 14344,
  ["Large Glimmering Shard"] = 11084,
  ["Large Glowing Shard"] = 11139,
  ["Large Radiant Shard"] = 11178,
  ["Liferoot"] = 3357,
  ["Light Leather"] = 2318,
  ["Linen Cloth"] = 2589,
  ["Mageroyal"] = 785,
  ["Mageweave Cloth"] = 4338,
  ["Medium Leather"] = 2319,
  ["Mithril Bar"] = 3860,
  ["Mithril Casing"] = 10561,
  ["Mithril Ore"] = 3858,
  ["Mithril Tube"] = 10559,
  ["Mountain Silversage"] = 13465,
  ["Peacebloom"] = 2447,
  ["Plaguebloom"] = 13466,
  ["Purple Lotus"] = 8831,
  ["Rugged Leather"] = 8170,
  ["Runecloth"] = 14047,
  ["Silk Cloth"] = 4306,
  ["Silver Bar"] = 2842,
  ["Silver Ore"] = 2775,
  ["Silverleaf"] = 765,
  ["Small Brilliant Shard"] = 14343,
  ["Small Glimmering Shard"] = 10978,
  ["Small Glowing Shard"] = 11138,
  ["Small Radiant Shard"] = 11177,
  ["Soul Dust"] = 11083,
  ["Steel Bar"] = 3859,
  ["Strange Dust"] = 10940,
  ["Stranglekelp"] = 3820,
  ["Sungrass"] = 8838,
  ["Thick Leather"] = 4304,
  ["Thorium Bar"] = 12359,
  ["Thorium Ore"] = 10620,
  ["Thorium Tube"] = 16000,
  ["Thorium Widget"] = 15994,
  ["Tin Bar"] = 3576,
  ["Tin Ore"] = 2771,
  ["Truesilver Bar"] = 6037,
  ["Truesilver Ore"] = 7911,
  ["Truesilver Transformer"] = 18631,
  ["Unstable Trigger"] = 10560,
  ["Vision Dust"] = 11137,
  ["Whirring Bronze Gizmo"] = 4375,
  ["Wild Steelbloom"] = 3355,
  ["Wintersbite"] = 3819,
  ["Wool Cloth"] = 2592,
}
-- Each entry is one alternative bundle: quantity, exact English item name.
local function add(itemID, quality, tier, label, ...)
  local family = label:match("Apprentice") or label:match("Journeyman") or label:match("Expert") or label:match("Artisan")
  WaylaidCostCrates[#WaylaidCostCrates + 1] = { itemID = itemID, quality = quality, tier = tier, family = family, name = "Waylaid Crate: " .. label, bundles = {...} }
end
WaylaidCostCrates = {}
local function b(n, item) return { n, item, materialIDs[item] } end
add(248702, 2, 10, "Apprentice Fabrics", b(2,"Cured Light Hide"),b(20,"Bolt of Linen Cloth"))
add(248703, 2, 10, "Apprentice Ingots", b(20,"Copper Bar"),b(20,"Tin Bar"),b(10,"Bronze Bar"))
add(248704, 2, 10, "Apprentice Parts", b(16,"Handful of Copper Bolts"),b(16,"Copper Tube"),b(4,"Copper Modulator"))
add(248685, 1, 10, "Apprentice Curiosities", b(20,"Strange Dust"),b(4,"Greater Magic Essence"),b(6,"Small Glimmering Shard"),b(2,"Large Glimmering Shard"))
add(248682, 1, 10, "Apprentice Herbs", b(20,"Peacebloom"),b(20,"Silverleaf"),b(10,"Earthroot"),b(10,"Mageroyal"),b(10,"Briarthorn"))
add(248683, 1, 10, "Apprentice Ore", b(20,"Copper Ore"),b(20,"Tin Ore"))
add(248684, 1, 10, "Apprentice Textiles", b(40,"Linen Cloth"),b(20,"Light Leather"))
add(248705, 2, 10, "Journeyman Fabrics", b(6,"Bolt of Woolen Cloth"),b(10,"Bolt of Silk Cloth"),b(2,"Cured Medium Hide"))
add(248706, 2, 10, "Journeyman Ingots", b(10,"Silver Bar"),b(20,"Iron Bar"))
add(248707, 2, 10, "Journeyman Parts", b(8,"Bronze Tube"),b(7,"Whirring Bronze Gizmo"),b(4,"Bronze Framework"),b(45,"Gold Power Core"))
add(248689, 1, 10, "Journeyman Curiosities", b(20,"Soul Dust"),b(4,"Greater Astral Essence"),b(6,"Small Glowing Shard"),b(2,"Large Glowing Shard"))
add(248686, 1, 10, "Journeyman Herbs", b(10,"Stranglekelp"),b(10,"Bruiseweed"),b(10,"Wild Steelbloom"),b(10,"Grave Moss"),b(10,"Kingsblood"))
add(248687, 1, 10, "Journeyman Ore", b(10,"Silver Ore"),b(20,"Iron Ore"))
add(248688, 1, 10, "Journeyman Textiles", b(20,"Wool Cloth"),b(40,"Silk Cloth"),b(20,"Medium Leather"))
add(248708, 2, 20, "Expert Fabrics", b(8,"Bolt of Mageweave"),b(2,"Cured Heavy Hide"))
add(248709, 2, 20, "Expert Ingots", b(20,"Mithril Bar"),b(15,"Steel Bar"),b(10,"Gold Bar"))
add(248710, 2, 20, "Expert Parts", b(8,"Iron Strut"),b(5,"Mithril Tube"),b(12,"Unstable Trigger"),b(5,"Mithril Casing"))
add(248694, 1, 20, "Expert Curiosities", b(20,"Vision Dust"),b(4,"Greater Mystic Essence"),b(6,"Small Radiant Shard"),b(2,"Large Radiant Shard"))
add(248690, 1, 20, "Earthly Expert Herbs", b(20,"Liferoot"),b(10,"Fadeleaf"),b(10,"Goldthorn"),b(10,"Khadgar's Whisker"))
add(248691, 1, 20, "Flowering Expert Herbs", b(10,"Wintersbite"),b(10,"Firebloom"),b(20,"Purple Lotus"),b(10,"Arthas' Tears"))
add(248692, 1, 20, "Expert Ore", b(10,"Gold Ore"),b(20,"Mithril Ore"))
add(248693, 1, 20, "Expert Textiles", b(40,"Mageweave Cloth"),b(20,"Heavy Leather"))
add(248711, 2, 35, "Artisan Fabrics", b(8,"Bolt of Runecloth"),b(2,"Cured Thick Hide"))
add(248712, 2, 35, "Artisan Ingots", b(2,"Dark Iron Bar"),b(10,"Truesilver Bar"),b(20,"Thorium Bar"))
add(248713, 2, 35, "Artisan Parts", b(5,"Thorium Widget"),b(5,"Truesilver Transformer"),b(2,"Thorium Tube"))
add(248699, 1, 35, "Artisan Curiosities", b(20,"Dream Dust"),b(4,"Greater Nether Essence"),b(6,"Small Brilliant Shard"),b(2,"Large Brilliant Shard"))
add(248695, 1, 35, "Earthly Artisan Herbs", b(10,"Golden Sansam"),b(20,"Sungrass"),b(10,"Blindweed"),b(10,"Ghost Mushroom"),b(10,"Gromsblood"))
add(248696, 1, 35, "Flowering Artisan Herbs", b(20,"Dreamfoil"),b(20,"Mountain Silversage"),b(20,"Plaguebloom"),b(20,"Icecap"))
add(248697, 1, 35, "Artisan Ore", b(10,"Truesilver Ore"),b(20,"Thorium Ore"),b(20,"Dark Iron Ore"))
add(248698, 1, 35, "Artisan Textiles", b(40,"Runecloth"),b(20,"Thick Leather"),b(20,"Rugged Leather"))
