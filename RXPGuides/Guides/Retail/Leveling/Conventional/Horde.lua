RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Max-Level Campaigns
#name F) 12.0.5 Campaign (H)
#displayname Campaign (12.0.5)
<< Horde
step
#include a) 12.0.5 Campaign
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup Pre-Turnins
#subweight 1000.5
#name a) 1Pre-Turnins Booklet (H)
#displayname Pre-Turnins Booklet|cRXP_WARN_(READ)|r
<< Horde
step
#include a) Pre-Turnins Booklet
step
+Select next guide
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Pre-Expansion Preparations
#name a1) Quest Preparations (H)
#displayname |cFF00FF001|r - Quests
#chapters a) Quest Booklet (H);a) Furniture Favor (H);a) Fishing (H);a) Cooking (H);a) Balloon (H);a) Selfie Cam (H);a) Warbanding Together (H);a) Squally (H);a) Blade in Twillight (H);a) Delve Quests (H);a) Burning Steppes Prep (H);a) Gidwin (H);a) Tirisfal Midnight Prep (H);a) Alterac Valley Quests (H);a) Pet Battle Setup (H);a) Orc Heritage Quests (H);a) Undead Heritage Armor (H);a) Tauren Heritage Quests (H);a) Troll Heritage Quests (H);a) Blood Elf Heritage Quests (H);a) Goblin Heritage Quests (H);a) Heritage Pandaren (H);a) Trading Post (H);a) Begin Your Training: Master Cheng (H) << Horde
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Pre-Expansion Preparations
#name a2) Item Preparations (H)
#displayname |cFF00FF002|r - Items
#chapters a) Item Information (H);a) Shopping List (H);a) Guild Items (H);a) Shadowberries (H);a) Bivigosa's Blood Sausages (H) << Horde
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup Pre-Turnins
#name a) 2Turnin Route Horde (H)
#displayname Miscellaneous Turnins
<< Horde
step
#include a) Turnin Route Horde
step
+Select next guide
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup Pre-Turnins
#name a) 4PoP-UP Quests Turnins (H)
#displayname First Crafts & Global Turnins
<< Horde
step
#include a) PoP-UP Quests Turnins
step
+Select next guide
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) 90 Unlocking Systems (H)
#displayname |cFF00CCFF0|r - 90 Intro Unlocking Systems
#next a) Foothold (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) 90 Unlocking Systems
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) A Dance with the Devil (H)
#displayname |cFF00CCFF14|r - A Dance with the Devil
#next a) A Domanaar's Best Friend (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) A Dance with the Devil
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) A Domanaar's Best Friend (H)
#displayname |cFF00CCFF15|r - A Domanaar's Best Friend
#next a) A More Potent Foe (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) A Domanaar's Best Friend
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) A Favor for the Lion (H)
#displayname |cFF00CCFF2|r - A Favor for the Lion |cFFFCDC00(90)|r
#chapter
<< Horde
step
#include RestedXP Midnight\a) A Favor for the Lion
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) A Gift, Given Freely (H)
#displayname |cFF00CCFF8|r - A Gift, Given Freely
#next a) Breaking the Triad (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) A Gift, Given Freely
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) A Goblin in Harandar (H)
#displayname |cFF00CCFF1|r - A Goblin in Harandar
#next a) The Legend of Aln'sharan (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) A Goblin in Harandar
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Alterac Valley Quests (H)
#next a) Pet Battle Setup (H)
#displayname Alterac Valley
#chapter
<< Horde
step
#completewith next
#label WarningText
+This sets up a |cRXP_WARN_6|r quests that rewards full XP from levels 80–90
*|cRXP_WARN_they can be completed once per character, you may have already completed it|r.
*This takes time depending on what your current reputation standing is with the Frostwolf Clan << Horde
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zoneskip 25
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a |cRXP_WARN_6|r quests that rewards full XP from levels 80–90
*|cRXP_WARN_they can be completed once per character, you may have already completed it|r.
*This takes time depending on what your current reputation standing is with the Frostwolf Clan << Horde
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Alterac Valley Quests
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) A More Potent Foe (H)
#displayname |cFF00CCFF16|r - A More Potent Foe |cFFFCDC00(90)|r
#chapter
<< Horde
step
#include RestedXP Midnight\a) A More Potent Foe
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) A Palette of Feelings (H)
#displayname |cFF00CCFF11|r - A Palette of Feelings
#next a) Predator Reintroduction (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) A Palette of Feelings
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) ARitual Sites (H)
#displayname Ritual Sites
<< Horde
step
#include a) Ritual Sites
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner & Campaign
#subweight 995.6
#name a) ASilvermoon & Voidstorm (H)
#displayname |cFFFCDC001|r - Silvermoon & Voidstorm Part 1
#next a) BVoidstorm Part 2 (H)
<< Horde
step
#completewith Trials and TabulationsZ
+This guide is for players who want to complete all campaigns & storylines as quickly as possible in one go (for levels 80-90).
step
#include a) Silvermoon & Voidstorm
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Aspiring Academic (H)
#displayname |cFF00CCFF7|r - Aspiring Academic
#next a) One Adventurous Hatchling (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Aspiring Academic
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) Atal'Aman (H)
#displayname Atal'Aman
#next a) Twilight Crypts (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Atal'Aman
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) A Venomous History (H)
#displayname |cFF00CCFF3|r - A Venomous History
#next a) The Sound of Her Voice (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) A Venomous History
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) A Voice Inside (H)
#displayname |cFF00CCFF6|r - A Voice Inside
#next a) Shadowguard's Shadow (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) A Voice Inside
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Balloon (H)
#next a) Selfie Cam (H)
#displayname Balloon
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 10minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Balloon
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup Level-Up Campaigns
#name ab) Arator's Journey (H)
#displayname |cFF00FF002|r - Arator's Journey
#chapters a) The Path of Light (H);a) Regrets of the Past (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Begin Your Training: Master Cheng (H)
#displayname Monk Quests
#chapter
<< Horde Monk
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Speed Leveling\a) Monk Quests@Master Cheng-MonkIncludePrepEnd
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Between Two Trolls (H)
#displayname |cFF00CCFF8|r - Between Two Trolls
#next a) Healing the Spirit (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Between Two Trolls
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#subweight 990
#name ab) Eversong Forest Delves (H)
#displayname Eversong Forest
#chapters a) The Shadow Enclave (H);a) Collegiate Calamity (H);a) The Darkway (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Beyond the Walls (H)
#displayname |cFF00CCFF10|r - Beyond the Walls
#next a) No Fear (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Beyond the Walls
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Bitter Honor (H)
#displayname |cFF00CCFF1|r - Bitter Honor
#next a) Sawdust to Sawdust (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Bitter Honor
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Bivigosa's Blood Sausages (H)
#displayname Bivigosa's Blood Sausages
#chapter
<< Horde
step
#include RestedXP Midnight\a) Bivigosa's Blood Sausages
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Blade in Twillight (H)
#next a) Delve Quests (H)
#displayname Xalatath Lorewalking
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up one quest that rewards XP equivalent to up to five quests from levels 80–90 and unlocks an item we’ll also make use of.
*|cRXP_WARN_It can be done at any time|r.
*|cRXP_WARN_Estimate Setup Time: 10 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up one quest that rewards XP equivalent to up to five quests from levels 80–90 and unlocks an item we’ll also make use of.
*|cRXP_WARN_It can be done at any time|r.
*|cRXP_WARN_Estimate Setup Time: 10 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Miscellaneous\a) Xal'atath@LoreWalkingPrepStart-LoreWalkingPrepEnd
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Blinding Sun (H)
#displayname |cFF00CCFF16|r - Blinding Sun
#next a) Paladin Rescue (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Blinding Sun
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Blood Elf Heritage Quests (H)
#next a) Trading Post (H)
#displayname Blood Elf Heritage Quests
#chapter
<< Horde BloodElf
step
#completewith next
#label WarningText
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Miscellaneous\a) Blood Elf Heritage Armor@StartIncludePrepGuide-EndIncludePrepGuide
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Bloodstains (H)
#displayname |cFF00CCFF16|r - Bloodstains
#next a) Something Vile This Way Comes (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Bloodstains
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Bloomtown (H)
#displayname |cFF00CCFF13|r - Bloomtown
#next a) The Grudge Pit 2 (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Bloomtown
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Breaking the Triad (H)
#displayname |cFF00CCFF9|r - Breaking the Triad
#next a) Go Low, Go Loud (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Breaking the Triad
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner & Campaign
#name a) BVoidstorm Part 2 (H)
#displayname |cFFFCDC002|r - Voidstorn Part 2
#next a) CEversong & Harandar Part 1 (H)
<< Horde
step
#include a) Voidstorm Part 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Storylines
#name ab) Zul'aman Storylines (H)
#displayname |cFF00FF002|r - Zul'Aman
#chapters a) Bitter Honor (H);a) Sawdust to Sawdust (H);a) A Venomous History (H);a) The Sound of Her Voice (H);a) Unlikely Friends (H);a) The Loa of Murlocs (H);a) Vengeance for Tolbani (H);a) Between Two Trolls (H);a) Healing the Spirit (H);a) Beyond the Walls (H);a) No Fear (H);a) Sorrowing Kin (H);a) River-Walkers of the Prowl (H);a) The Voice of Nalorakk (H);a) Reclaiming de Honor (H);a) Bloodstains (H);a) Something Vile This Way Comes (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Call of the Goddess (H)
#displayname |cFF00CCFF2|r - Call of the Goddess
#next a) Emergence (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Call of the Goddess
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner & Campaign
#name a) CEversong & Harandar Part 1 (H)
#displayname |cFFFCDC003|r - Eversong & Harandar Part 1
#next a) EEversong Woods Part 2 (H)
<< Horde
step
#include a) Eversong & Harandar Part 1
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup Level-Up Campaigns
#name ac) Harandar Campaign (H)
#displayname |cFF00FF003|r - Harandar
#chapters a) Of Caves and Cradles (H);a) Call of the Goddess (H);a) Emergence (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Storylines
#name ac) Harandar Storylines (H)
#displayname |cFF00FF003|r - Harandar
#chapters a) A Goblin in Harandar (H);a) The Legend of Aln'sharan (H);a) Late Bloomers (H);a) The Greenspeaker's Vigil (H);a) Peril Among Petals (H);a) Haranir Never Say Die (H);a) Harandar's Kitchen (H);a) Silence at Fungara Village (H);a) Cultivating Hope (H);a) Hunter's Rights (H);a) A Palette of Feelings (H);a) Predator Reintroduction (H);a) Bloomtown (H);a) The Grudge Pit 2 (H);a) Trials of the Shul'ka (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) Collegiate Calamity (H)
#displayname Collegiate Calamity
#next a) The Darkway (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Collegiate Calamity
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Cooking (H)
#next a) Balloon (H)
#displayname Cooking
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Cooking
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Cultivating Hope (H)
#displayname |cFF00CCFF9|r - Cultivating Hope
#next a) Hunter's Rights (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Cultivating Hope
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name ac) Zul'aman Delves (H)
#displayname Zul'Aman
#chapters a) Twilight Crypts (H);a) Atal'Aman (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Daggerspine Landing (H)
#displayname |cFF00CCFF13|r - Daggerspine Landing
#next a) Flowers for Amalthea (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Daggerspine Landing
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Darkening Sky (H)
#displayname |cFF00CCFF1|r - Darkening Sky
#next a) Into the Abyss (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Darkening Sky
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Dawn of a New Well (H)
#displayname |cFF00CCFF6|r - Dawn of a New Well
#chapter
<< Horde
step
#include RestedXP Midnight\a) Dawn of a New Well
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Dawn of Reckoning (H)
#displayname |cFF00CCFF4|r - Dawn of Reckoning
#chapter
<< Horde
step
#include RestedXP Midnight\a) Dawn of Reckoning
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) De Amani Never Die (H)
#displayname |cFF00CCFF4|r - De Amani Never Die
#next a) Darkening Sky (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) De Amani Never Die
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Prey & Delve Campaign
#subweight 993.97
#name B) Delves: Season 2 (H)
#displayname Delves: Season 2
<< Horde
step
#include b) Delves: Season 2
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Delve Quests (H)
#next a) Gidwin (H)
#displayname Delve Quests
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up |cRXP_WARN_13|r quests that rewards full XP on level 80
*|cRXP_WARN_Estimate Setup Time: 1 hour|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up |cRXP_WARN_13|r quests that rewards full XP on level 80
*|cRXP_WARN_Estimate Setup Time: 1 hour|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Delve Quests
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-84)|r Delves Worldtour
#subweight 994.999
#name a) Delves Worldtour (H)
#displayname Just Delve Quests
<< Horde
step
#completewith next
+This guide is for players wanting to do a delve worldtour.
*|cRXP_WARN_NOTE:|r This guide requires you to have unlocked the adventure mode or at least access to all zones.
step
#include RestedXP Midnight\a) The Light's Summons@TheLightsSummonsA-TheLightsSummonsB
step
#include RestedXP Midnight\a) Eversong Woods Route Delve Worldtour
step
#include RestedXP Midnight\a) Zul'Aman Route Delve Worldtour
step
#include RestedXP Midnight\a) Harandar Route Delve Worldtour
step
#include RestedXP Midnight\a) Voidstorm Route Delve Worldtour
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name ad) Harandar Delves (H)
#displayname Harandar
#chapters a) The Grudge Pit (H);a) The Gulf of Memory (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Dis Was Our Land (H)
#displayname |cFF00CCFF1|r - Dis Was Our Land
#next a) Path of de Hash'ey (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Dis Was Our Land
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Storylines
#name ad) Voidstorm Storylines (H)
#displayname |cFF00FF004|r - Voidstorm
#chapters a) The Void Peers Back (H);a) Shadow Puppets (H);a) The Nethersent (H);a) The Nightbreaker (H);a) Pathogenic Problem (H);a) A Voice Inside (H);a) Shadowguard's Shadow (H);a) A Gift, Given Freely (H);a) Breaking the Triad (H);a) Go Low, Go Loud (H);a) Secrets in the Dark (H);a) Oaths to Family (H);a) To Be Changed (H);a) A Dance with the Devil (H);a) A Domanaar's Best Friend (H);a) A More Potent Foe (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup Level-Up Campaigns
#name ad) Zul'aman Campaign (H)
#displayname |cFF00FF004|r - Zul'Aman
#chapters a) Dis Was Our Land (H);a) Path of de Hash'ey (H);a) Where War Slumbers (H);a) De Amani Never Die (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Storylines
#subweight 993.5
#name ae) Crimson Rogue (H)
#displayname The Crimson Rogue
#chapters a) The Regent's Request (H); a) A Favor for the Lion (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner & Campaign
#name a) EEversong Woods Part 2 (H)
#displayname |cFFFCDC004|r - Eversong Part 2
#next a) FHarandar & Eversong Part 2 (H)
<< Horde
step
#include a) Eversong Woods Part 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Emergence (H)
#displayname |cFF00CCFF3|r - Emergence
#next a) Dis Was Our Land (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Emergence
]])

RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup Level-Up Campaigns
#subweight 993.955
#name a) Eversong Woods Campaign (H)
#displayname |cFF00FF001|r - Eversong Woods
#chapters a) The Light's Summons (H);a) Whispers in the Twilight (H);a) Shadowfall (H);a) Ripple Effects (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner
#subweight 995.5
#name a) Eversong Woods Sojourner (H)
#displayname |cFFFCDC001|r - 1
#internal
<< Horde
step
#completewith Trials and TabulationsZ
+This guide is for players who want to complete all storylines as quickly as possible in one go (for levels 80-90).
step
#include a) Eversong Woods Sojourner
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Storylines
#subweight 993
#name a) Eversong Woods Storylines (H)
#displayname |cFF00FF001|r - Eversong Woods
#chapters a) The Drinking Debt (H);a) Fear and Fel (H);a) Lesser Evil (H);a) Tailor Troubles (H);a) Scootin' Through Silvermoon (H);a) How to Train Your Protege (H);a) Aspiring Academic (H);a) One Adventurous Hatchling (H);a) Far Striding (H);a) Runestone Rumbles (H);a) Theft Tracking (H);a) Port Detective (H);a) Daggerspine Landing (H);a) Flowers for Amalthea (H);a) Sunbath, Take Me Away (H);a) Blinding Sun (H);a) Paladin Rescue (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup Level-Up Campaigns
#name ae) Voidstorm Campaign (H)
#displayname |cFF00FF005|r - Voidstorm
#chapters a) Darkening Sky (H);a) Into the Abyss (H);a) The Night's Veil (H);a) Dawn of Reckoning (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name ae) Voidstorm Delves (H)
#displayname Void Storm
#chapters a) Sunkiller Sanctum (H);a) Shadowguard Point (H);a) Torment’s Rise (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Far Striding (H)
#displayname |cFF00CCFF9|r - Far Striding
#next a) Runestone Rumbles (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Far Striding
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Fear and Fel (H)
#displayname |cFF00CCFF2|r - Fear and Fel
#next a) Lesser Evil (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Fear and Fel
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner & Campaign
#name a) FHarandar & Eversong Part 2 (H)
#displayname |cFFFCDC005|r - Harandar & Eversong Part 2
#next a) GHarandar Part 3 & Eversong Woods (H)
<< Horde
step
#include a) Harandar & Eversong Part 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Fishing (H)
#next a) Cooking (H)
#displayname Fishing
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Fishing
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Flowers for Amalthea (H)
#displayname |cFF00CCFF14|r - Flowers for Amalthea
#next a) Sunbath, Take Me Away (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Flowers for Amalthea
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name af) Old Soldiers (H)
#subgroup Storylines
#displayname Old Soldiers
<< Horde
step
#include a) Old Soldiers
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Foothold (H)
#displayname |cFF00CCFF1|r - Foothold
#next a) The Voidspire (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Foothold
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Furniture Favor (H)
#next a) Fishing (H)
#displayname Balloon
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Furniture Favor
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Gathering of the Elves (H)
#displayname |cFF00CCFF3|r - Gathering of the Elves
#next a) The Battle of the Bridge (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Gathering of the Elves
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner & Campaign
#name a) GHarandar Part 3 & Eversong Woods (H)
#displayname |cFFFCDC006|r - Harandar & Eversong Part 3
#next a) HZul'aman Part 1 (H)
<< Horde
step
#include a) Harandar Part 3 & Eversong Woods
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Gidwin (H)
#next a) Tirisfal Midnight Prep (H)
#displayname Eastern Plaguelands
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This unlocks the quest Journey’s End and keeps it in your quest log so a teleport item can be used during the 80–90 campaign, saving a significant amount of time.
*|cRXP_WARN_You may have already completed this quest; if so, the item is no longer obtainable|r
*|cRXP_WARN_Estimate Setup Time: 1 hour|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zoneskip 23
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This unlocks the quest Journey’s End and keeps it in your quest log so a teleport item can be used during the 80–90 campaign, saving a significant amount of time.
*|cRXP_WARN_You may have already completed this quest; if so, the item is no longer obtainable|r
*|cRXP_WARN_Estimate Setup Time: 1 hour|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Gidwin
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Storylines
#name ag) Legends Never Die & The Empty Cradle (H)
#displayname Legends Never Die & The Empty Cradle
<< Horde
step
#include RestedXP Midnight\a) Legends Never Die & The Empty Cradle
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Goblin Heritage Quests (H)
#next a) Trading Post (H)
#displayname Goblin Heritage Quests
#chapter
<< Horde Goblin
step
#completewith next
#label WarningText
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Miscellaneous\a) Goblin Heritage Armor@StartIncludePrepGuide-EndIncludePrepGuide
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Go Low, Go Loud (H)
#displayname |cFF00CCFF10|r - Go Low, Go Loud
#next a) Secrets in the Dark (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Go Low, Go Loud
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Guild Items (H)
#displayname XP Banners & Teleport Cloaks
#chapter
<< Horde
step
#include RestedXP Midnight\a) Guild Items
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Harandar's Kitchen (H)
#displayname |cFF00CCFF7|r - Harandar's Kitchen
#next a) Silence at Fungara Village (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Harandar's Kitchen
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner
#name a) Harandar Sojourner (H)
#displayname 3
#internal
<< Horde
step
#include a) Eversong Woods Sojourner
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Haranir Never Say Die (H)
#displayname |cFF00CCFF6|r - Haranir Never Say Die
#next a) Harandar's Kitchen (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Haranir Never Say Die
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Healing the Spirit (H)
#displayname |cFF00CCFF9|r - Healing the Spirit
#next a) Beyond the Walls (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Healing the Spirit
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Heritage Pandaren (H)
#next a) Trading Post (H)
#displayname Pandaren
#chapter
<< Horde Pandaren
step
#completewith next
#label WarningText
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Heritage Pandaren
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) How to Train Your Protege (H)
#displayname |cFF00CCFF6|r - How to Train Your Protege
#next a) Aspiring Academic (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) How to Train Your Protege
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Hunter's Rights (H)
#displayname |cFF00CCFF10|r - Hunter's Rights
#next a) A Palette of Feelings (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Hunter's Rights
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner & Campaign
#name a) HZul'aman Part 1 (H)
#displayname |cFFFCDC007|r - Zul'aman Part 1
#next a) IZul'aman Part 2 & Arathor (H)
<< Horde
step
#include a) Zul'aman Part 1
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Into the Abyss (H)
#displayname |cFF00CCFF2|r - Into the Abyss
#next a) The Night's Veil (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Into the Abyss
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) Isle of Quel'danas Delves (H)
#displayname Isle of Quel'Danas
#chapters a) Parhelion Plaza (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Item Information (H)
#displayname |cFFFCDC00How to Use(MUST READ)|r
#chapter
<< Horde
step
#include RestedXP Midnight\a) Item Booklet
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner & Campaign
#name a) IZul'aman Part 2 & Arathor (H)
#displayname |cFFFCDC008|r - Zul'aman Part 2 & Arathor
#next a) Foothold (H)
<< Horde
step
#include a) Zul'aman Part 2 & Arathor
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Late Bloomers (H)
#displayname |cFF00CCFF3|r - Late Bloomers
#next a) The Greenspeaker's Vigil (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Late Bloomers
]])

RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Lesser Evil (H)
#displayname |cFF00CCFF3|r - Lesser Evil
#next a) Tailor Troubles (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Lesser Evil
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup Treasures & Renown
#subweight 991
#name a) Lore Hunter (H)
#displayname Renown Treasures Worldtour
<< Horde
step
#include RestedXP Midnight\a) Lore Hunter
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) No Fear (H)
#displayname |cFF00CCFF11|r - No Fear
#next a) Sorrowing Kin (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) No Fear
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Oaths to Family (H)
#displayname |cFF00CCFF12|r - Oaths to Family
#next a) To Be Changed (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Oaths to Family
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Of Caves and Cradles (H)
#displayname |cFF00CCFF1|r - Of Caves and Cradles
#next a) Call of the Goddess (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Of Caves and Cradles
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) One Adventurous Hatchling (H)
#displayname |cFF00CCFF8|r - One Adventurous Hatchling
#next a) Far Striding (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) One Adventurous Hatchling
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Orc Heritage Quests (H)
#next a) Trading Post (H)
#displayname Orc Heritage Quests
#chapter
<< Horde Orc
step
#completewith next
#label WarningText
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Miscellaneous\a) Orc Heritage Armor@StartIncludePrepGuide-EndIncludePrepGuide
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Paladin Rescue (H)
#displayname |cFF00CCFF17|r - Paladin Rescue |cFFFCDC00(90)|r
#chapter
<< Horde
step
#include RestedXP Midnight\a) Paladin Rescue
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) Parhelion Plaza (H)
#displayname Parhelion Plaza
#next a) The Darkway (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Parhelion Plaza
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Path of de Hash'ey (H)
#displayname |cFF00CCFF2|r - Path of de Hash'ey
#next a) Where War Slumbers (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Path of de Hash'ey
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Pathogenic Problem (H)
#displayname |cFF00CCFF5|r - Pathogenic Problem
#next a) A Voice Inside (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Pathogenic Problem
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Peril Among Petals (H)
#displayname |cFF00CCFF5|r - Peril Among Petals
#next a) Haranir Never Say Die (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Peril Among Petals
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Pet Battle Setup (H)
#displayname Pet Battles
#chapter
<< Horde
step
#completewith next
#label WarningText
+This sets up |cRXP_WARN_30-40|r quests that rewards full XP from levels 80–90
*|cRXP_WARN_they can be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 3-5 hours|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up |cRXP_WARN_30-40|r quests that rewards full XP from levels 80–90
*|cRXP_WARN_they can be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 3-5 hours|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Pet Battle Setup
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Port Detective (H)
#displayname |cFF00CCFF12|r - Port Detective
#next a) Daggerspine Landing (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Port Detective
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Predator Reintroduction (H)
#displayname |cFF00CCFF12|r - Predator Reintroduction
#next a) Bloomtown (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Predator Reintroduction
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Prey & Delve Campaign
#subweight 993.97
#name C) Prey Campaign (H)
#displayname Prey: Season 1
<< Horde
step
#include a) Prey Campaign
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Prey & Delve Campaign
#subweight 993.97
#name C2) Prey: Season 2 (H)
#displayname Prey: Season 2
<< Horde
step
#include b) Prey: Season 2
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Treasures & Renown
#name a) Profession Knowledge Worldtour (H)
#displayname Profession Knowledge Worldtour
<< Horde
step
#include RestedXP Miscellaneous\a) Eversong Woods Knowledge
step
#include RestedXP Miscellaneous\a) Zul'aman Knowledge
step
#include RestedXP Miscellaneous\a) Harandar Knowledge
step
#include RestedXP Miscellaneous\a) Voidstorm Knowledge
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Quest Booklet (H)
#next a) Furniture Favor (H)
#displayname |cFFFCDC00How to Use(MUST READ)|r
#chapter
<< Horde
step
#include RestedXP Midnight\a) Quest Booklet
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Reclaiming de Honor (H)
#displayname |cFF00CCFF15|r - Reclaiming de Honor
#next a) Bloodstains (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Reclaiming de Honor
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Regrets of the Past (H)
#displayname |cFF00CCFF2|r - Regrets of the Past
#next a) Of Caves and Cradles (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Regrets of the Past
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Ripple Effects (H)
#displayname |cFF00CCFF4|r - Ripple Effects
#next a) Regrets of the Past (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Ripple Effects
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) River-Walkers of the Prowl (H)
#displayname |cFF00CCFF13|r - River-Walkers of the Prowl
#next a) The Voice of Nalorakk (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) River-Walkers of the Prowl
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Runestone Rumbles (H)
#displayname |cFF00CCFF10|r - Runestone Rumbles
#next a) Theft Tracking (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Runestone Rumbles
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Max-Level Campaigns
#subweight 993.97
#name D) Saltheril's Haven (H)
#displayname Saltheril's Haven Campaign
<< Horde
step
#include a) Saltheril's Haven
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Sawdust to Sawdust (H)
#displayname |cFF00CCFF2|r - Sawdust to Sawdust
#next a) A Venomous History (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Sawdust to Sawdust
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Scootin' Through Silvermoon (H)
#displayname |cFF00CCFF5|r - Scootin' Through Silvermoon
#next a) How to Train Your Protege (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Scootin' Through Silvermoon
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Secrets in the Dark (H)
#displayname |cFF00CCFF11|r - Secrets in the Dark
#next a) Oaths to Family (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Secrets in the Dark
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Selfie Cam (H)
#next a) Warbanding Together (H)
#displayname Selfie Cam
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Selfie Cam
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Shadowberries (H)
#displayname Shadowberries
#chapter
<< Horde
step
#include RestedXP Midnight\a) Shadowberries
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Shadowfall (H)
#displayname |cFF00CCFF3|r - Shadowfall
#next a) Ripple Effects (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Shadowfall
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) Shadowguard Point (H)
#displayname Shadowguard Point
#next a) Sunkiller Sanctum (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Shadowguard Point
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Shadowguard's Shadow (H)
#displayname |cFF00CCFF7|r - Shadowguard's Shadow
#next a) A Gift, Given Freely (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Shadowguard's Shadow
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Shadow Puppets (H)
#displayname |cFF00CCFF2|r - Shadow Puppets
#next a) The Nethersent (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Shadow Puppets
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Shopping List (H)
#displayname Shopping
#chapter
<< Horde
step
#include RestedXP Midnight\a) Shopping List
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Silence at Fungara Village (H)
#displayname |cFF00CCFF8|r - Silence at Fungara Village
#next a) Cultivating Hope (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Silence at Fungara Village
]])
RXPGuides.RegisterGuide([[
#version 1
#retail
#group RestedXP Midnight
#subgroup Treasures & Renown
#name a) Skyriding Glyphs Worldtour (H)
#displayname Skyriding Glyphs Worldtour
<< Horde
step
#include RestedXP Miscellaneous\a) Eversong Woods Glyphs
step
#include RestedXP Miscellaneous\a) Zul'aman Glyphs
step
#include RestedXP Miscellaneous\a) Harandar Glyphs
step
#include RestedXP Miscellaneous\a) Voidstorm Glyphs
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Something Vile This Way Comes (H)
#displayname |cFF00CCFF17|r - Something Vile This Way Comes |cFFFCDC00(90)|r
#next a) A Goblin in Harandar (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Something Vile This Way Comes
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Sorrowing Kin (H)
#displayname |cFF00CCFF12|r - Sorrowing Kin
#next a) River-Walkers of the Prowl (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Sorrowing Kin
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Squally (H)
#next a) Blade in Twillight (H)
#displayname Squally
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 10minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 10minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Squally
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Sunbath, Take Me Away (H)
#displayname |cFF00CCFF15|r - Sunbath, Take Me Away
#next a) Blinding Sun (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Sunbath, Take Me Away
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) Sunkiller Sanctum (H)
#displayname Sunkiller Sanctum
#next a) Shadowguard Point (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Sunkiller Sanctum
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Tailor Troubles (H)
#displayname |cFF00CCFF4|r - Tailor Troubles
#next a) Scootin' Through Silvermoon (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Tailor Troubles
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Tauren Heritage Quests (H)
#next a) Trading Post (H)
#displayname Tauren Heritage Quests
#chapter
<< Horde Tauren
step
#completewith next
#label WarningText
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Miscellaneous\a) Tauren Heritage Armor@StartIncludePrepGuide-EndIncludePrepGuide
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Battle of the Bridge (H)
#displayname |cFF00CCFF4|r - The Battle of the Bridge
#next a) The Darkwell (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Battle of the Bridge
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) The Darkway (H)
#displayname The Darkway
#next a) The Shadow Enclave (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Darkway
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Darkwell (H)
#displayname |cFF00CCFF5|r - The Darkwell
#next a) Dawn of a New Well (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Darkwell
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Drinking Debt (H)
#displayname |cFF00CCFF1|r - The Drinking Debt
#next a) Fear and Fel (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Drinking Debt
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Theft Tracking (H)
#displayname |cFF00CCFF11|r - Theft Tracking
#next a) Port Detective (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Theft Tracking
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Greenspeaker's Vigil (H)
#displayname |cFF00CCFF4|r - The Greenspeaker's Vigil
#next a) Peril Among Petals (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Greenspeaker's Vigil
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Grudge Pit 2 (H)
#displayname |cFF00CCFF14|r - The Grudge Pit
#next a) Trials of the Shul'ka (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Grudge Pit 2
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) The Grudge Pit (H)
#displayname The Grudge Pit
#next a) The Gulf of Memory (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Grudge Pit
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) The Gulf of Memory (H)
#displayname The Gulf of Memory
#next a) The Grudge Pit (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Gulf of Memory
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Legend of Aln'sharan (H)
#displayname |cFF00CCFF2|r - The Legend of Aln'sharan
#next a) Late Bloomers (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Legend of Aln'sharan
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#groupweight 999
#name a) The Light's Summons (H)
#displayname |cFF00CCFF1|r - The Light's Summons
#next a) Whispers in the Twilight (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Light's Summons
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Loa of Murlocs (H)
#displayname |cFF00CCFF6|r - The Loa of Murlocs
#next a) Vengeance for Tolbani (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Loa of Murlocs
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Nethersent (H)
#displayname |cFF00CCFF3|r - The Nethersent
#next a) The Nightbreaker (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Nethersent
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Nightbreaker (H)
#displayname |cFF00CCFF4|r - The Nightbreaker
#next a) Pathogenic Problem (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Nightbreaker
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) The Night's Veil (H)
#displayname |cFF00CCFF3|r - The Night's Veil
#next a) Dawn of Reckoning (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Night's Veil
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) The Path of Light (H)
#displayname |cFF00CCFF1|r - The Path of Light
#next a) Regrets of the Past (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Path of Light
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Regent's Request (H)
#displayname |cFF00CCFF1|r - The Regent's Request |cFFFCDC00(80+)|r
#next a) A Favor for the Lion (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Regent's Request
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) The Shadow Enclave (H)
#displayname The Shadow Enclave
#next a) Collegiate Calamity (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Shadow Enclave
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Sound of Her Voice (H)
#displayname |cFF00CCFF4|r - The Sound of Her Voice
#next a) Unlikely Friends (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Sound of Her Voice
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Voice of Nalorakk (H)
#displayname |cFF00CCFF14|r - The Voice of Nalorakk
#next a) Reclaiming de Honor (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Voice of Nalorakk
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Void Peers Back (H)
#displayname |cFF00CCFF1|r - The Void Peers Back
#next a) Shadow Puppets (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Void Peers Back
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) The Voidspire (H)
#displayname |cFF00CCFF2|r - The Voidspire
#next a) Gathering of the Elves(H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) The Voidspire
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) To Be Changed (H)
#displayname |cFF00CCFF13|r - To Be Changed
#next a) A Dance with the Devil (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) To Be Changed
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Trading Post (H)
#next a) Begin Your Training: Master Cheng (H)
#displayname Trading Post
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a single quest that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 1-5minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Trading Post
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Trials of the Shul'ka (H)
#displayname |cFF00CCFF15|r - Trials of the Shul'ka
#next a) Trials of the Shul'ka (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Trials of the Shul'ka
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Troll Heritage Quests (H)
#next a) Trading Post (H)
#displayname Troll Heritage Quests
#chapter
<< Horde Troll
step
#completewith next
#label WarningText
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Miscellaneous\a) Troll Heritage Armor@StartIncludePrepGuide-EndIncludePrepGuide
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Turnin Route Horde 3 (H)
#subgroup |cFF1EFF00(80-90)|r Campaign & Sidequests
#displayname |cFF9D9D9D0|r - Prepturnins (Requires prepped quests)
#next ca) Eversong Woods Route 3 (H)
<< Horde
step
#include a) Turnin Route Horde
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Turnin Route Horde 4 (H)
#subgroup |cFF1EFF00(80-88)|r Campaign & Delves
#displayname |cFF9D9D9D0|r - Prepturnins (Requires prepped quests)
#next ca) Eversong Woods Route 4 (H)
<< Horde
step
#include a) Turnin Route Horde
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Delves & Ritual Sites
#name a) Twilight Crypts (H)
#displayname Twilight Crypts
#next a) Atal'Aman(H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Twilight Crypts
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Undead Heritage Armor (H)
#next a) Trading Post (H)
#displayname Undead Heritage Quests
#chapter
<< Horde Undead
step
#completewith next
#label WarningText
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up a multiple quests that rewards full XP from levels 80–90
*|cRXP_WARN_but it can only be completed once per account, you may have already completed it|r.
*|cRXP_WARN_Estimate Setup Time: 30 minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Miscellaneous\a) Undead Heritage Armor@StartIncludePrepGuide-EndIncludePrepGuide
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Unlikely Friends (H)
#displayname |cFF00CCFF5|r - Unlikely Friends
#next a) The Loa of Murlocs (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Unlikely Friends
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Vengeance for Tolbani (H)
#displayname |cFF00CCFF7|r - Vengeance for Tolbani
#next a) Between Two Trolls (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Vengeance for Tolbani
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner
#name a) Voidstorm Sojourner (H)
#displayname 4
#internal
<< Horde
step
#include a) Eversong Woods Sojourner
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#name a) Warbanding Together (H)
#next a) Squally (H)
#displayname Warbands
#chapter
<< Horde
step
#completewith next
#label WarningText
#title |cFFFCDC00Skip this step to proceed|r
+This sets up 2 quests that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 10minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#completewith WarningText
.zone 85 >>Go to Orgrimmar
step
#requires WarningText
+This sets up a 2 quests that rewards full XP from levels 80–90
*|cRXP_WARN_it can be completed once per day, even if you’ve done it before|r.
*|cRXP_WARN_Estimate Setup Time: 10minutes|r.
*|cRXP_WARN_Skip this step when done reading to see the arrow|r.
step
#include RestedXP Midnight\a) Warbanding Together
step
#title |cFFFCDC00Skip this step to proceed|r
+This section of the guide is complete and don't turn in the quest until xp is unlocked.
*|cRXP_WARN_Manually skip this step to proceed|r
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Where War Slumbers (H)
#displayname |cFF00CCFF3|r - Where War Slumbers
#next a) De Amani Never Die (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Where War Slumbers
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#name a) Whispers in the Twilight (H)
#displayname |cFF00CCFF2|r - Whispers in the Twilight
#next a) Shadowfall (H)
#chapter
<< Horde
step
#include RestedXP Midnight\a) Whispers in the Twilight
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Max-Level Campaigns
#name E) Abundance Campaign (H)
#subweight 993.96
#displayname Abundance Campaign
<< Horde
step
#include a) Abundance Campaign
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Sojourner
#name a) Zul'Aman Sojourner (H)
#displayname 2
#internal
<< Horde
step
#include a) Eversong Woods Sojourner
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#subweight 1002
#name b1) BfA Intro 2
#displayname |cFF1EFF003|r - Zuldazar << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF002|r - Zuldazar << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next ba) Horde Val'sharah 2
<< Horde
step
#include RestedXP Speed Leveling\a) Battle for Azeroth
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name ba) Horde Val'sharah 2
#displayname |cFF1EFF004|r - Val'sharah << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF003|r - Val'sharah << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bb) Horde Highmountain 2
<< Horde
step
#include RestedXP Speed Leveling\a) Val'sharah Speedrun Midnight Horde
]])

RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bba) Horde Highmountain 2 2
#displayname |cFF1EFF005.2|r - Highmountain << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF004.2|r - Highmountain << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bc) Horde Silverpine Forest 2
<< Horde
step
#include RestedXP Speed Leveling\a) Highmountain Speedrun 2 Midnight Horde
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bb) Horde Highmountain 2
#displayname |cFF1EFF005.1|r - Highmountain << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF004.1|r - Highmountain << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bba) Horde Highmountain 2 2
<< Horde
step
#include RestedXP Speed Leveling\a) Highmountain Speedrun Midnight Horde
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bc) Horde Silverpine Forest 2
#displayname |cFF1EFF006|r - Silverpine Forest << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF005|r - Silverpine Forest << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bd) Horde Hillsbrad Foothills 2
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Silverpine Forest
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bd) Horde Hillsbrad Foothills 2
#displayname |cFF1EFF007|r - Hillsbrad Foothills << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF006|r - Hillsbrad Foothills << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next be) Horde Hinterlands 2
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Hillsbrad Foothills
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name be) Horde Hinterlands 2
#displayname |cFF1EFF008|r - Hinterlands << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF007|r - Hinterlands << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bf) Horde Kun-Lai Summit 2
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Hinterlands
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bf) Horde Kun-Lai Summit 2
#displayname |cFF1EFF009|r - Kun-Lai Summit (20+) << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF008|r - Kun-Lai Summit (20+) << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#title Kun-Lai Summit
#next bg) Horde Draenor Scenario 2
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Kun-Lai Summit
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bg) Horde Draenor Scenario 2
#displayname |cFF1EFF0010|r - Draenor Scenario << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF009|r - Draenor Scenario << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bh) Horde Draenor Garrison 2
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Draenor Scenario
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bh) Horde Draenor Garrison 2
#displayname |cFF1EFF0011|r - Draenor Garrison Intro << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF0010|r - Draenor Garrison Intro << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bi) Horde Spires of Arak 2
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Draenor Garrison
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bi) Horde Spires of Arak 2
#displayname |cFF1EFF0012|r - Spires of Arak << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF0011|r - Spires of Arak << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bj) Horde Gorgrond 2
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Spires of Arak
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bj) Horde Gorgrond 2
#displayname |cFF1EFF0013|r - Gorgrond << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF0012|r - Gorgrond << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Speed Leveling\z) 70-80 First Crafts (H) 2
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Gorgrond
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bq) DF Horde Intro Midnight (H) 2
#displayname |cFF1EFF003|r - Dragonflight Intro << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF002|r - Dragonflight Intro << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Midnight\br) The Waking Shores Midnight (H) 2
<< Horde
step
#include RestedXP Speed Leveling\a) DF Horde Intro Midnight
]])
RXPGuides.RegisterGuide([[
#retail
#version 4
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name br) The Waking Shores Midnight (H) 2
#displayname |cFF1EFF004|r - The Waking Shores << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF003|r - The Waking Shores << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Midnight\bs) Val'sharah Speedrun Midnight (H) 2
<< Horde
step
#include RestedXP Speed Leveling\a) The Waking Shores Midnight@WakingShoresStart-The Courage of One's Convictions
step
#include RestedXP Speed Leveling\a) The Waking Shores Midnight@MissingEndStart-MissingEndEnd
]])
RXPGuides.RegisterGuide([[
#retail
#version 4
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bs) Ohn'ahran Plains Midnight (H) 2
#displayname |cFF1EFF005|r - Ohn'ahran Plains << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF004|r - Ohn'ahran Plains << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Speed Leveling\bt) The Azure Span Midnight (H) 2
<< Horde
step
#include RestedXP Speed Leveling\a) Ohn'ahran Plains Midnight
]])
RXPGuides.RegisterGuide([[
#retail
#version 4
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bt) The Azure Span Midnight (H) 2
#displayname |cFF1EFF006|r - The Azure Span << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF005|r - The Azure Span << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Speed Leveling\bu) Thaldraszus Midnight (H) 2
<< Horde
step
#include RestedXP Speed Leveling\a) The Azure Span Midnight
]])
RXPGuides.RegisterGuide([[
#retail
#version 4
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bu) Thaldraszus Midnight (H) 2
#displayname |cFF1EFF007|r - Thaldraszus << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF006|r - Thaldraszus << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Speed Leveling\z) 70-80 First Crafts (H) 2
<< Horde
step
#include RestedXP Speed Leveling\a) Thaldraszus Midnight
]])
RXPGuides.RegisterGuide([[
#retail
#version 3
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name bv) War Within Recap (H) 2
#displayname |cFF1EFF008|r - War Within Recap << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF007|r - War Within Recap << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Midnight\caa) Midnight Intro Route (H)
<< Horde
step
#include RestedXP Speed Leveling\a) The War Within Recap
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Campaign & Sidequests
#name caa) Midnight Intro Route 3 (H)
#displayname |cFFFCDC001|r - Midnight Intro
#next cab) Eversong Woods Route 3 (H)
<< Horde
step
#completewith TheLightsSummonsB
+This guide is for players who want to complete the campaign, best storylines and delves to level as quickly as possible.
step
#include RestedXP Midnight\a) Midnight Intro Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Alt Leveling
#name caa) Midnight Intro Route 4 (H)
#displayname |cFFFCDC001|r - Midnight Intro
#next cab) Eversong Woods Route 4 (H)
<< Horde
step
#completewith TheLightsSummonsB
+This guide is for players leveling their alts to 90. |cRXP_WARN_Remember you can do first crafts for 80-100% of level 89.|r
step
#include RestedXP Midnight\a) Midnight Intro Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-88)|r Campaign & Delves
#name caa) Midnight Intro Route 5 (H)
#displayname |cFFFCDC001|r - Midnight Intro
#next cab) Eversong Woods Route 5 (H)
<< Horde
step
#completewith TheLightsSummonsB
+This guide is for players who want to finish the campaign, complete Delve quests, and level quickly to 90.
step
#include RestedXP Midnight\a) Midnight Intro Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name caa) Midnight Intro Route (H)
#displayname |cFFFCDC001|r - Midnight Intro
#next cab) Eversong Woods Route (H)
<< Horde
step
#completewith TheLightsSummonsB
+This guide is for players who want to complete the campaign, best storylines and delves to level as quickly as possible.
step
#include RestedXP Midnight\a) Midnight Intro Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Campaign & Sidequests
#subweight 999
#name cab) Eversong Woods Route 3 (H)
#displayname |cFFFCDC002|r - Eversong Woods 1
#next cac) Eversong Woods Route 3 (H) 2
<< Horde
step
#completewith Recruit Lothraxion
+This guide is for players who want to complete the campaign, best storylines and delves to level as quickly as possible.
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Eversong Woods Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Alt Leveling
#subweight 997
#name cab) Eversong Woods Route 4 (H)
#displayname |cFFFCDC002|r - Eversong Woods 1
#next cac) Eversong Woods Route 4 (H) 2
<< Horde
step
#completewith SharpmawFairbreezeFavorsA
+This guide is for players leveling their alts to 90. |cRXP_WARN_Remember you can do first crafts for 80-100% of level 89.|r
step
#include RestedXP Midnight\a) Eversong Woods Adventure Mode
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-88)|r Campaign & Delves
#subweight 998
#name cab) Eversong Woods Route 5 (H)
#displayname |cFFFCDC002|r - Eversong Woods
#next cb) Arator Route 5 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#completewith Recruit Lothraxion
+This guide is for multiboxers or players skipping side quests, while incorporating Delves. The idea is to do Siren Isles at the start and crafting at the end with some additional prepared quests.
step
#include a) Eversong Woods Route Delve
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#subweight 1000
#name cab) Eversong Woods Route (H)
#displayname |cFFFCDC002|r - Eversong Woods 1
#next cac) Eversong Woods Route (H) 2
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Eversong Woods Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Campaign & Sidequests
#subweight 999
#name cac) Eversong Woods Route 3 (H) 2
#displayname |cFFFCDC003|r - Eversong Woods 2
#next cb) Arator Route 3 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Eversong Woods Route 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Alt Leveling
#subweight 997
#name cac) Eversong Woods Route 4 (H) 2
#displayname |cFFFCDC003|r - Eversong Woods 2
#next cb) Zul'Aman Route 4 (H)
<< Horde
step
#include RestedXP Midnight\a) Eversong Woods Adventure Mode 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#subweight 1000
#name cac) Eversong Woods Route (H) 2
#displayname |cFFFCDC003|r - Eversong Woods 2
#next cb) Arator Route (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Eversong Woods Route 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Alt Leveling
#name ca) Midnight DMF Route 4 (H)
#displayname |cFF9D9D9D0|r - Darkmoon Faire
#next caa) Midnight Intro Route 4 (H)
<< Horde
step
#include RestedXP Midnight\a) DMF
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Campaign & Sidequests
#name cb) Arator Route 3 (H)
#displayname |cFFFCDC004|r - Arator
#next cca) Harandar Route 3 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Arator Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-88)|r Campaign & Delves
#name cb) Arator Route 5 (H)
#displayname |cFFFCDC003|r - Arator
#next cc) Harandar Route 5 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Arator Route Delve
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name cb) Arator Route (H)
#displayname |cFFFCDC004|r - Arator
#next cca) Harandar Route (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Arator Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Alt Leveling
#name cb) Zul'Aman Route 4 (H)
#displayname |cFFFCDC004|r - Zul'Aman
#next cca) Harandar Route 4 (H)
<< Horde
step
#include RestedXP Midnight\a) Zul'Aman Adventure Mode
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Campaign & Sidequests
#name cca) Harandar Route 3 (H)
#displayname |cFFFCDC005|r - Harandar 1
#next ccb) Harandar Route 3 (H) 2
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Harandar Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Alt Leveling
#name cca) Harandar Route 4 (H)
#displayname |cFFFCDC005|r - Harandar 1
#next ccb) Harandar Route 4 (H) 2
<< Horde
step
#include RestedXP Midnight\a) Harandar Adventure Mode
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name cca) Harandar Route (H)
#displayname |cFFFCDC005|r - Harandar 1
#next ccb) Harandar Route (H) 2
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Harandar Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Campaign & Sidequests
#name ccb) Harandar Route 3 (H) 2
#displayname |cFFFCDC006|r - Harandar 2
#next cd) Zul'Aman Route 3 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Harandar Route 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Alt Leveling
#name ccb) Harandar Route 4 (H) 2
#displayname |cFFFCDC006|r - Harandar 2
#next cd) Voidstorm Route 4 (H)
<< Horde
step
#include RestedXP Midnight\a) Harandar Adventure Mode 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name ccb) Harandar Route (H) 2
#displayname |cFFFCDC006|r - Harandar 2
#next cd) Zul'Aman Route (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Harandar Route 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-88)|r Campaign & Delves
#name cc) Harandar Route 5 (H)
#displayname |cFFFCDC004|r - Harandar
#next cd) Zul'Aman Route 5 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Harandar Route Delve
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Alt Leveling
#name cd) Voidstorm Route 4 (H)
#displayname |cFFFCDC007|r - Voidstorm
#next RestedXP Midnight\a) 90 Unlocking Systems (H)
<< Horde
step
#include RestedXP Midnight\a) Voidstorm Adventure Mode
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Campaign & Sidequests
#name cd) Zul'Aman Route 3 (H)
#displayname |cFFFCDC007|r - Zul'Aman
#next ce) Voidstorm Route 3 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Zul'Aman Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-88)|r Campaign & Delves
#name cd) Zul'Aman Route 5 (H)
#displayname |cFFFCDC005|r - Zul'Aman
#next ce) Voidstorm Route 5 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Zul'Aman Route Delve
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name cd) Zul'Aman Route (H)
#displayname |cFFFCDC007|r - Zul'Aman
#next ce) Voidstorm Route (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Zul'Aman Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Campaign & Sidequests
#name ce) Voidstorm Route 3 (H)
#displayname |cFFFCDC008|r - Voidstorm
#next RestedXP Midnight\a) 90 Unlocking Systems (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Voidstorm Route
step
+If you're still not 90 then you can do your first crafts (in your crafting professions) now if you haven't done them already. Otherwise start the Adventure Mode guide or follow the next guide (by completing this step) to unlock the endgame systems.
step
#label MidnightCampaignSpeedrunEndA
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-88)|r Campaign & Delves
#name ce) Voidstorm Route 5 (H)
#displayname |cFFFCDC006|r - Voidstorm
#next RestedXP Midnight\a) 90 Unlocking Systems (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Voidstorm Route Delve
step
+You can do your first crafts now! Start the Adventure Mode Guide if you still need more experience to hit 90.
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name ce) Voidstorm Route (H)
#displayname |cFFFCDC008|r - Voidstorm
#next a) 90 Unlocking Systems (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include a) Voidstorm Route
step
+If you're still not 90 then you can do your first crafts (in your crafting professions) now if you haven't done them already. Otherwise start the Adventure Mode guide or follow the next guide (by completing this step) to unlock the endgame systems.
step
#label MidnightCampaignSpeedrunEndA
#hidewindow
>>1
]])

RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup |cFF1EFF00(80-90)|r Alt Leveling
#name c) Turnin Route Horde 4 (H)
#displayname |cFF9D9D9D0|r - Prepturnins (Requires prepped quests)
#next ca) Eversong Woods Route 4 (H)
#internal
<< Horde
step
#include RestedXP Midnight\a) Turnin Route Horde
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name c) Turnin Route Horde (H)
#displayname |cFF9D9D9D0|r - Prepturnins (Requires prepped quests)
#next ca) Eversong Woods Route (H)
<< Horde
step
#include a) Turnin Route Horde
]])



RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Max-Level Campaigns
#name G) Val Zone Unlock (H)
#displayname Val Showdown Zone Unlock
<< Horde
step
#include xb) Val Zone Unlock
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Max-Level Campaigns
#name H) Naigtal Zone Unlock (H)
#displayname Naigtal Showdown Zone Unlock
<< Horde
step
#include xc) Naigtal Zone Unlock
]])

RXPGuides.RegisterGuide([[
#retail
#version 3
#group RestedXP Midnight
#subgroup |cFF1EFF00(1-90)|r Default
#name z) 70-80 First Crafts (H) 2
#displayname First Crafts << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname First Crafts << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#internal
<< Horde
step
#include RestedXP Speed Leveling\a) 70-80 First Crafts
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Max-Level Campaigns
#subweight 994
#name Z) The War of Light and Shadow Campaign (H)
#displayname The War of Light and Shadow
#chapters a) 90 Unlocking Systems (H);a) Foothold (H);a) The Voidspire (H);a) Gathering of the Elves (H);a) The Battle of the Bridge (H);a) The Darkwell (H);a) Dawn of a New Well (H)
<< Horde
step
+1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name b1) BfA Intro
#displayname |cFF1EFF003|r - Zuldazar << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF002|r - Zuldazar << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next ba) Horde Val'sharah
<< Horde
step
#include RestedXP Speed Leveling\a) Battle for Azeroth
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name ba) Horde Val'sharah
#displayname |cFF1EFF004|r - Val'sharah << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF003|r - Val'sharah << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bb) Horde Highmountain
<< Horde
step
#include RestedXP Speed Leveling\a) Val'sharah Speedrun Midnight Horde
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bba) Horde Highmountain 2
#displayname |cFF1EFF005.2|r - Highmountain << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF004.2|r - Highmountain << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bc) Horde Kun-Lai Summit
<< Horde
step
#include RestedXP Speed Leveling\a) Highmountain Speedrun 2 Midnight Horde
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bb) Horde Highmountain
#displayname |cFF1EFF005.1|r - Highmountain << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF004.1|r - Highmountain << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bba) Horde Highmountain 2
<< Horde
step
#include RestedXP Speed Leveling\a) Highmountain Speedrun Midnight Horde
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bc) Horde Kun-Lai Summit
#displayname |cFF1EFF006|r - Kun-Lai Summit (20+) << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF005|r - Kun-Lai Summit (20+) << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#title Kun-Lai Summit
#next bd) Horde Silverpine Forest
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Kun-Lai Summit
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bd) Horde Silverpine Forest
#displayname |cFF1EFF007|r - Silverpine Forest << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF006|r - Silverpine Forest << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next be) Horde Hillsbrad Foothills
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Silverpine Forest
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name be) Horde Hillsbrad Foothills
#displayname |cFF1EFF008|r - Hillsbrad Foothills << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF007|r - Hillsbrad Foothills << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bf) Horde Hinterlands
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Hillsbrad Foothills
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bf) Horde Hinterlands
#displayname |cFF1EFF009|r - Hinterlands << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF008|r - Hinterlands << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bg) Horde Draenor Scenario
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Hinterlands
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bg) Horde Draenor Scenario
#displayname |cFF1EFF0010|r - Draenor Scenario << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF009|r - Draenor Scenario << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bh) Horde Draenor Garrison
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Draenor Scenario
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bh) Horde Draenor Garrison
#displayname |cFF1EFF0011|r - Draenor Garrison Intro << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF0010|r - Draenor Garrison Intro << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bi) Horde Spires of Arak
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Draenor Garrison
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bi) Horde Spires of Arak
#displayname |cFF1EFF0012|r - Spires of Arak << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF0011|r - Spires of Arak << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next bj) Horde Gorgrond
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Spires of Arak
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bj) Horde Gorgrond
#displayname |cFF1EFF0013|r - Gorgrond << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF0012|r - Gorgrond << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#name RestedXP Speed Leveling\z) 70-80 First Crafts (H)
<< Horde
step
#include RestedXP Speed Leveling\a) Horde Gorgrond
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bq) DF Horde Intro Midnight (H)
#displayname |cFF1EFF003|r - Dragonflight Intro << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF002|r - Dragonflight Intro << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Speed Leveling\br) The Waking Shores Midnight (H) 1
<< Horde
step
#include RestedXP Speed Leveling\a) DF Horde Intro Midnight
]])
RXPGuides.RegisterGuide([[
#retail
#version 4
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name br) The Waking Shores Midnight (H) 1
#displayname |cFF1EFF004|r - The Waking Shores << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF003|r - The Waking Shores << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Speed Leveling\bs) Val'sharah Speedrun Midnight (H)
<< Horde
step
#include RestedXP Speed Leveling\a) The Waking Shores Midnight@WakingShoresStart-The Courage of One's Convictions
step
#include RestedXP Speed Leveling\a) The Waking Shores Midnight@MissingEndStart-MissingEndEnd
]])
RXPGuides.RegisterGuide([[
#retail
#version 4
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bs) Ohn'ahran Plains Midnight (H)
#displayname |cFF1EFF005|r - Ohn'ahran Plains << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF004|r - Ohn'ahran Plains << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Speed Leveling\bt) The Azure Span Midnight (H)
<< Horde
step
#include RestedXP Speed Leveling\a) Ohn'ahran Plains Midnight
]])
RXPGuides.RegisterGuide([[
#retail
#version 4
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bt) The Azure Span Midnight (H)
#displayname |cFF1EFF006|r - The Azure Span << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF005|r - The Azure Span << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Speed Leveling\bu) Thaldraszus Midnight (H)
<< Horde
step
#include RestedXP Speed Leveling\a) The Azure Span Midnight
]])
RXPGuides.RegisterGuide([[
#retail
#version 4
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bu) Thaldraszus Midnight (H)
#displayname |cFF1EFF007|r - Thaldraszus << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF006|r - Thaldraszus << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Speed Leveling\bv) War Within Recap (H) 2
<< Horde
step
#include RestedXP Speed Leveling\a) Thaldraszus Midnight
]])
RXPGuides.RegisterGuide([[
#retail
#version 3
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bv) War Within Recap (A) 23324
#displayname |cFF1EFF008|r - War Within Recap << Draenei !DK /Dwarf !DK/Gnome !DK/Human !DK /NightElf !DK !DemonHunter
#displayname |cFF1EFF007|r - War Within Recap << VoidElf/KulTiran/LightforgedDraenei/Mechagnome/DarkIronDwarf/Dracthyr/Pandaren/DK/DemonHunter/Worgen/EarthenDwarf/Harronir
#next RestedXP Midnight\caa) Midnight Intro Route (A)
#internal
<< Alliance
step
#include RestedXP Speed Leveling\a) The War Within Recap
]])
RXPGuides.RegisterGuide([[
#retail
#version 3
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name bv) War Within Recap (H) 2
#displayname |cFF1EFF008|r - War Within Recap << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname |cFF1EFF007|r - War Within Recap << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#next RestedXP Midnight\caa) Midnight Intro Route (H)
<< Horde
step
#include RestedXP Speed Leveling\a) The War Within Recap
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name caa) Midnight Intro Route 2 (H)
#displayname |cFFFCDC001|r - Midnight Intro
#next cab) Eversong Woods Route 2 (H)
<< Horde
step
#completewith TheLightsSummonsB
+This guide is for players who want to complete the campaign, best storylines and delves to level as quickly as possible.
step
#include RestedXP Midnight\a) Midnight Intro Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name cab) Eversong Woods Route 2 (H)
#displayname |cFFFCDC002|r - Eversong Woods
#next cac) Eversong Woods Route 2 (H) 2
<< Horde
step
#completewith Recruit Lothraxion
+This guide is for players who want to complete the campaign, best storylines and delves to level as quickly as possible.
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include RestedXP Midnight\a) Eversong Woods Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name cac) Eversong Woods Route 2 (H) 2
#displayname |cFFFCDC003|r - Eversong Woods 2
#next cb) Arator Route 2 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include RestedXP Midnight\a) Eversong Woods Route 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name cb) Arator Route 2 (H)
#displayname |cFFFCDC004|r - Arator
#next cca) Harandar Route 2 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include RestedXP Midnight\a) Arator Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name cca) Harandar Route 2 (H)
#displayname |cFFFCDC005|r - Harandar
#next ccb) Harandar Route 2 (H) 2
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include RestedXP Midnight\a) Harandar Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name ccb) Harandar Route 2 (H) 2
#displayname |cFFFCDC006|r - Harandar
#next cd) Zul'Aman Route 2 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include RestedXP Midnight\a) Harandar Route 2
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name cd) Zul'Aman Route 2 (H)
#displayname |cFFFCDC007|r - Zul'Aman
#next ce) Voidstorm Route 2 (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include RestedXP Midnight\a) Zul'Aman Route
step
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name ce) Voidstorm Route 2 (H)
#displayname |cFFFCDC008|r - Voidstorm
#next RestedXP Midnight\a) 90 Unlocking Systems (H)
<< Horde
step
#optional
.isQuestTurnedIn account,86522
+|cRXP_WARN_Switch to the Alt Leveling Guide instead:|r
.clicknext RestedXP Midnight\cab) Eversong Woods Route 4 (H) >>CLICK HERE FOR GUIDE << Horde
step
#include RestedXP Midnight\a) Voidstorm Route
step
+If you're still not 90 then you can do your first crafts (in your crafting professions) now if you haven't done them already. Otherwise start the Adventure Mode guide or follow the next guide (by completing this step) to unlock the endgame systems.
step
#label MidnightCampaignSpeedrunEndA
#hidewindow
>>1
]])
RXPGuides.RegisterGuide([[
#retail
#version 20
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name c) Turnin Route Horde 2 (H)
#displayname |cFF9D9D9D0|r - Prepturnins (Requires prepped quests)
#next ca) Eversong Woods Route 2 (H)
<< Horde
step
#include RestedXP Midnight\a) Turnin Route Horde
]])
RXPGuides.RegisterGuide([[
#retail
#version 3
#group RestedXP Speed Leveling
#subgroup |cFFFCDC00(1-90)|r Default
#name z) 70-80 First Crafts (H)
#displayname First Crafts << Orc !DK/Troll !DK/Undead !DK/Tauren !DK/BloodElf !DK !DemonHunter
#displayname First Crafts << Goblin/Pandaren/DK/Nightborne/HighmountainTauren/MagharOrc/EarthenDwarf/ZandalariTroll/Vulpera/Dracthyr/DemonHunter/Harronir
#internal
<< Horde
step
#include RestedXP Speed Leveling\a) 70-80 First Crafts
]])
