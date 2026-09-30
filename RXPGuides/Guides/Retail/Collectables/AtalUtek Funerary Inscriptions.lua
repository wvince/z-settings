RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Treasures & Renown
#subweight 991
#name a) M The Honored Dead
#displayname The Honored Dead

step
    .goto 2512,45.40,64.90
    .zone 2509 >>Enter the Vaults of Atal'Utek
step
    .isQuestAvailable 98035
    .isQuestAvailable account,98035
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,45.84,61.86
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r on the left-side pillar near the stairs in the Amani Foothold.
    .achievement 63610,7 >>Read |cRXP_PICK_To Failure|r
step
    .isQuestAvailable 98029
    .isQuestAvailable account,98029
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,49.46,56.65
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r on the right of the second staircase while leaving the Amani Foothold.
    .achievement 63610,1 >>Read |cRXP_PICK_To a Daughter|r
step
    .isQuestAvailable 98030
    .isQuestAvailable account,98030
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,52.16,45.30
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r in the right-side corridor.
    .achievement 63610,2 >>Read |cRXP_PICK_To a Lover|r
step
    #arrowtext Enter the |cRXP_WARN_Profaned Mausoleum|r
    .goto 2509,54.83,48.11
    >>Enter the |cRXP_WARN_Profaned Mausoleum|r.
step
    .isQuestAvailable 98031
    .isQuestAvailable account,98031
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2638,14.55,63.93
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r on the right-side wall just inside the mausoleum.
    .achievement 63610,3 >>Read |cRXP_PICK_To Parents|r
step
    .zone 2509 >>Leave the Profaned Mausoleum the way you entered
step
    .isQuestAvailable 98032
    .isQuestAvailable account,98032
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,55.63,40.47
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r on the right as you approach the Gate of the Serpent's Eye.
    .achievement 63610,4 >>Read |cRXP_PICK_To a Dream|r
step
    .isQuestAvailable 98033
    .isQuestAvailable account,98033
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,52.93,33.92
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r at the top of the right staircase leading toward the Venomous Abyss.
    .achievement 63610,5 >>Read |cRXP_PICK_To a Captain|r
step
    .isQuestAvailable 98040
    .isQuestAvailable account,98040
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,56.44,23.02
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r at the Seal of Wrath.
    .achievement 63610,12 >>Read |cRXP_PICK_To a Shield-bearer|r
step
    .isQuestAvailable 98037
    .isQuestAvailable account,98037
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,46.78,7.74
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r inside the Underbelly Entrance at the far north of the vaults.
    .achievement 63610,9 >>Read |cRXP_PICK_To a Sister|r
step
    .isQuestAvailable 98036
    .isQuestAvailable account,98036
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,47.24,28.92
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r below the two connecting bridges.
    .achievement 63610,8 >>Read |cRXP_PICK_To a Father|r
step
    .isQuestAvailable 98039
    .isQuestAvailable account,98039
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,42.65,32.92
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r beneath the left bridge leading toward the Venomous Abyss.
    .achievement 63610,11 >>Read |cRXP_PICK_To a Stranger|r
step
    .isQuestAvailable 98034
    .isQuestAvailable account,98034
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2509,42.83,39.93
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r at the top of the staircase leading down toward the venom lake.
    .achievement 63610,6 >>Read |cRXP_PICK_To Sons|r
step
    #arrowtext Enter the |cRXP_WARN_Vault of Restless Bones|r
    .goto 2509,39.70,48.19
    >>Enter the |cRXP_WARN_Vault of Restless Bones|r.
step
    .isQuestAvailable 98038
    .isQuestAvailable account,98038
    #arrowtext Click the |cRXP_PICK_Funerary Inscription|r
    .goto 2636,77.01,36.87
    >>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Funerary Inscription|r on the right-hand side just inside the vault.
    .achievement 63610,10 >>Read |cRXP_PICK_To Comrades|r
step
    +You have discovered all 12 Funerary Inscriptions and completed |cRXP_WARN_The Honored Dead|r.
]])

RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup Treasures & Renown
#subweight 991
#name a) N Altar of Corrosion Discoveries
#displayname Altar of Corrosion Discoveries

step
    .goto 2512,45.40,64.90
    .zone 2509 >>Enter the Vaults of Atal'Utek
step
    +This guide unlocks all four discoverable choice nodes at the |cRXP_WARN_Altar of Corrosion|r.
    *Each discovery requires a key item from a Vaults activity, followed by a treasure that starts a quest for Er'inye.
    *Completed discoveries are skipped automatically. If you are waiting for a particular activity, you can manually skip ahead to a key you already own.

step
    .isQuestAvailable account,97669
    .isNotOnQuest 97669
    .itemcount 280004,<1
    .itemcount 278536,<1
    >>Complete |cRXP_WARN_Temple Strikes|r until you receive a |cRXP_LOOT_Corroded Key|r.
    .collect 280004,1 >>Collect a |cRXP_LOOT_Corroded Key|r
step
    #loop
    #arrowtext Find the |cRXP_PICK_Venom-Worn Coffer|r
    .isQuestAvailable account,97669
    .isNotOnQuest 97669
    .itemcount 280004,1
    .itemcount 278536,<1
    .goto 2509,52.51,53.85,12,0
    .goto 2509,41.96,53.58,12,0
    .goto 2509,47.48,37.59,12,0
    .goto 2509,42.51,12.01,12,0
    .goto 2509,53.69,18.18,12,0
    .goto 2509,41.80,10.80,12,0
    .goto 2509,40.10,18.30,12,0
    .goto 2509,52.60,10.70,12,0
    .goto 2509,53.00,53.40,12,0
    >>|TInterface/cursor/crosshair/interact.blp:20|tCheck beneath the venom waterfalls for the |cRXP_PICK_Venom-Worn Coffer|r. It can spawn at any of these locations.
    .collect 278536,1 >>Loot the |cRXP_LOOT_Mummified Lynx's Paw|r
step
    .isQuestAvailable account,97669
    .itemcount 278536,1
    >>Use the |cRXP_LOOT_Mummified Lynx's Paw|r in your bags.
    .use 278536
    .accept 97669 >>Accept The Luck of the Bound Spirit
step
    .isOnQuest 97669
    #arrowtext Talk to |cRXP_FRIENDLY_Er'inye|r
    .goto 2509,51.08,62.80
    >>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Er'inye|r beside the Altar of Corrosion.
    .turnin 97669 >>Turn in The Luck of the Bound Spirit
    .target Er'inye

step
    .isQuestAvailable account,97662
    .isNotOnQuest 97662
    .itemcount 280006,<1
    .itemcount 278523,<1
    >>Defeat an |cRXP_ENEMY_Ancient Foe|r after a successful Temple Incursion until you receive a |cRXP_LOOT_Spirit Loupe|r.
    .collect 280006,1 >>Collect a |cRXP_LOOT_Spirit Loupe|r
step
    .isQuestAvailable account,97662
    .isNotOnQuest 97662
    .itemcount 280006,1
    .itemcount 278523,<1
    #arrowtext Loot the |cRXP_PICK_Feather of Tok'jara|r
    .goto 2509,48.46,25.80
    >>|TInterface/cursor/crosshair/interact.blp:20|tLoot the |cRXP_PICK_Feather of Tok'jara|r from the small ledge near the Venomous Abyss entrance.
    .collect 278523,1 >>Loot the |cRXP_LOOT_Feather of Tok'jara|r
step
    .isQuestAvailable account,97662
    .itemcount 278523,1
    >>Use the |cRXP_LOOT_Feather of Tok'jara|r in your bags.
    .use 278523
    .accept 97662 >>Accept The Winds of Tok'jara
step
    .isOnQuest 97662
    #arrowtext Talk to |cRXP_FRIENDLY_Er'inye|r
    .goto 2509,51.08,62.80
    >>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Er'inye|r beside the Altar of Corrosion.
    .turnin 97662 >>Turn in The Winds of Tok'jara
    .target Er'inye

step
    .isQuestAvailable account,97668
    .isNotOnQuest 97668
    .itemcount 280003,<1
    .itemcount 278534,<1
    >>Complete a |cRXP_WARN_Temple Incursion|r until you receive an |cRXP_LOOT_Excising Knife|r.
    .collect 280003,1 >>Collect an |cRXP_LOOT_Excising Knife|r
step
    .isQuestAvailable account,97668
    .isNotOnQuest 97668
    .itemcount 280003,1
    .itemcount 278534,<1
    #arrowtext Enter |cRXP_WARN_The Underbelly|r
    .goto 2509,47.23,8.13 >>Enter |cRXP_WARN_The Underbelly|r at the far north of the Vaults
step
    .isQuestAvailable account,97668
    .isNotOnQuest 97668
    .itemcount 280003,1
    .itemcount 278534,<1
    #arrowtext Loot the |cRXP_PICK_Eye of Szarith|r
    .goto 2613,68.52,15.86
    >>|TInterface/cursor/crosshair/interact.blp:20|tLoot the |cRXP_PICK_Eye of Szarith|r floating in the venom pool in the back room.
    .collect 278534,1 >>Loot the |cRXP_LOOT_Eye of Szarith|r
step
    .isQuestAvailable account,97668
    .itemcount 278534,1
    >>Use the |cRXP_LOOT_Eye of Szarith|r in your bags.
    .use 278534
    .accept 97668 >>Accept The Watchful Gaze of Szarith
step
    .isOnQuest 97668
    .zone 2509 >>Leave The Underbelly the way you entered
step
    .isOnQuest 97668
    #arrowtext Talk to |cRXP_FRIENDLY_Er'inye|r
    .goto 2509,51.08,62.80
    >>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Er'inye|r beside the Altar of Corrosion.
    .turnin 97668 >>Turn in The Watchful Gaze of Szarith
    .target Er'inye

step
    .isQuestAvailable account,97661
    .isNotOnQuest 97661
    .itemcount 280005,<1
    .itemcount 278517,<1
    #arrowtext Enter the |cRXP_WARN_Vault of Restless Bones|r
    .goto 2509,39.70,48.19 >>Enter the |cRXP_WARN_Vault of Restless Bones|r
step
    .isQuestAvailable account,97661
    .isNotOnQuest 97661
    .itemcount 280005,<1
    .itemcount 278517,<1
    .goto 2636,48.08,72.69
    >>Defeat |cRXP_ENEMY_High Priest Jin'tal|r and |cRXP_ENEMY_Spirit of Jin'tal|r. Loot them for the |cRXP_LOOT_Dispelling Charm|r.
    *If they are unavailable, complete The Honored Med'jai storyline beginning with the Faintly Glowing Gem at 47.96, 51.82 in the main Vaults map.
    .collect 280005,1 >>Collect the |cRXP_LOOT_Dispelling Charm|r
    .mob High Priest Jin'tal
    .mob Spirit of Jin'tal
step
    .isQuestAvailable account,97661
    .isNotOnQuest 97661
    .itemcount 280005,1
    .itemcount 278517,<1
    .zone 2509 >>Leave the Vault of Restless Bones the way you entered
step
    .isQuestAvailable account,97661
    .isNotOnQuest 97661
    .itemcount 280005,1
    .itemcount 278517,<1
    #arrowtext Enter the |cRXP_WARN_Profaned Mausoleum|r
    .goto 2509,54.83,48.11 >>Enter the |cRXP_WARN_Profaned Mausoleum|r
step
    .isQuestAvailable account,97661
    .isNotOnQuest 97661
    .itemcount 280005,1
    .itemcount 278517,<1
    #arrowtext Open |cRXP_PICK_Jin'tal's Reliquary|r
    .goto 2638,36.73,24.73
    >>|TInterface/cursor/crosshair/interact.blp:20|tOpen |cRXP_PICK_Jin'tal's Reliquary|r on top of the bookshelf.
    .collect 278517,1 >>Loot the |cRXP_LOOT_Lost Med'jai Amulet|r
step
    .isQuestAvailable account,97661
    .itemcount 278517,1
    >>Use the |cRXP_LOOT_Lost Med'jai Amulet|r in your bags.
    .use 278517
    .accept 97661 >>Accept The Protection of the Med'jai
step
    .isOnQuest 97661
    .zone 2509 >>Leave the Profaned Mausoleum the way you entered
step
    .isOnQuest 97661
    #arrowtext Talk to |cRXP_FRIENDLY_Er'inye|r
    .goto 2509,51.08,62.80
    >>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Er'inye|r beside the Altar of Corrosion.
    .turnin 97661 >>Turn in The Protection of the Med'jai
    .target Er'inye
step
    +You have unlocked all four discoverable choice nodes at the |cRXP_WARN_Altar of Corrosion|r.
]])
