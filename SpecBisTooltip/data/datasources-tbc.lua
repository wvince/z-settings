-- By D4KiR
local _, SpecBisTooltip = ...
local s = {}
if SpecBisTooltip:GetBisPool() == "TBC" then
    function SpecBisTooltip:GetTranslationMap()
        return s
    end
end

-- SOURCE FROM: 10.09.2026
if SpecBisTooltip:GetBisPool() == "TBC" then
    function SpecBisTooltip:TranslationenUS()
        s["npc;drop=15550"] = {"Attumen the Huntsman", "Karazhan"}
        s["npc;drop=15687"] = {"Moroes <Tower Steward>", "Karazhan"}
        s["npc;drop=15688"] = {"Terestian Illhoof", "Karazhan"}
        s["npc;drop=15689"] = {"Netherspite", "Karazhan"}
        s["npc;drop=15690"] = {"Prince Malchezaar", "Karazhan"}
        s["npc;drop=15691"] = {"The Curator", "Karazhan"}
        s["npc;drop=15989"] = {"Sapphiron", "Naxxramas"}
        s["npc;drop=16011"] = {"Loatheb", "Naxxramas"}
        s["npc;drop=16152"] = {"Attumen the Huntsman", "Karazhan"}
        s["npc;drop=16179"] = {"Hyakiss the Lurker", "Karazhan"}
        s["npc;drop=16180"] = {"Shadikith the Glider", "Karazhan"}
        s["npc;drop=16181"] = {"Rokad the Ravager", "Karazhan"}
        s["npc;drop=16411"] = {"Spectral Chef", "Karazhan"}
        s["npc;drop=16457"] = {"Maiden of Virtue", "Karazhan"}
        s["npc;drop=16485"] = {"Arcane Watchman", "Karazhan"}
        s["npc;drop=16504"] = {"Arcane Protector", "Karazhan"}
        s["npc;drop=16524"] = {"Shade of Aran", "Karazhan"}
        s["npc;drop=16807"] = {"Grand Warlock Nethekurse", "The Shattered Halls"}
        s["npc;drop=16808"] = {"Warchief Kargath Bladefist", "The Shattered Halls"}
        s["npc;drop=16816"] = {"Echo of Medivh", "Karazhan"}
        s["npc;drop=17225"] = {"Nightbane", "Karazhan"}
        s["npc;drop=17257"] = {"Magtheridon", "Magtheridon's Lair"}
        s["npc;drop=17377"] = {"Keli'dan the Breaker", "The Blood Furnace"}
        s["npc;drop=17381"] = {"The Maker", "The Blood Furnace"}
        s["npc;drop=17521"] = {"The Big Bad Wolf", "Karazhan"}
        s["npc;drop=17533"] = {"Romulo", "Karazhan"}
        s["npc;drop=17534"] = {"Julianne", "Karazhan"}
        s["npc;drop=17711"] = {"Doomwalker", "Shadowmoon Valley"}
        s["npc;drop=17767"] = {"Rage Winterchill", "Hyjal Summit"}
        s["npc;drop=17798"] = {"Warlord Kalithresh", "The Steamvault"}
        s["npc;drop=17808"] = {"Anetheron", "Hyjal Summit"}
        s["npc;drop=17842"] = {"Azgalor", "Hyjal Summit"}
        s["npc;drop=17848"] = {"Lieutenant Drake", "Old Hillsbrad Foothills"}
        s["npc;drop=17879"] = {"Chrono Lord Deja", "The Black Morass"}
        s["npc;drop=17880"] = {"Temporus", "The Black Morass"}
        s["npc;drop=17881"] = {"Aeonus", "The Black Morass"}
        s["npc;drop=17882"] = {"The Black Stalker", "The Underbog"}
        s["npc;drop=17888"] = {"Kaz'rogal", "Hyjal Summit"}
        s["npc;drop=17897"] = {"Crypt Fiend", ""}
        s["npc;drop=17898"] = {"Abomination", ""}
        s["npc;drop=17908"] = {"Giant Infernal", ""}
        s["npc;drop=17942"] = {"Quagmirran", "The Slave Pens"}
        s["npc;drop=17968"] = {"Archimonde", "Hyjal Summit"}
        s["npc;drop=17975"] = {"High Botanist Freywinn", "The Botanica"}
        s["npc;drop=17977"] = {"Warp Splinter", "The Botanica"}
        s["npc;drop=17978"] = {"Thorngrin the Tender", "The Botanica"}
        s["npc;drop=17980"] = {"Laj", "The Botanica"}
        s["npc;drop=17991"] = {"Rokmar the Crackler", "The Slave Pens"}
        s["npc;drop=18093"] = {"Tarren Mill Protector", ""}
        s["npc;drop=18096"] = {"Epoch Hunter", "Old Hillsbrad Foothills"}
        s["npc;drop=18105"] = {"Ghaz'an", "The Underbog"}
        s["npc;drop=18168"] = {"The Crone", "Karazhan"}
        s["npc;drop=18341"] = {"Pandemonius", "Mana-Tombs"}
        s["npc;drop=18343"] = {"Tavarok", "Mana-Tombs"}
        s["npc;drop=18344"] = {"Nexus-Prince Shaffar", "Mana-Tombs"}
        s["npc;drop=18371"] = {"Shirrak the Dead Watcher", "Auchenai Crypts"}
        s["npc;drop=18373"] = {"Exarch Maladaar", "Auchenai Crypts"}
        s["npc;drop=184259"] = {"Night Lord", "Karazhan"}
        s["npc;drop=18472"] = {"Darkweaver Syth", "Sethekk Halls"}
        s["npc;drop=18473"] = {"Talon King Ikiss", "Sethekk Halls"}
        s["npc;drop=18478"] = {"Avatar of the Martyred", "Auchenai Crypts"}
        s["npc;drop=18667"] = {"Blackheart the Inciter", "Shadow Labyrinth"}
        s["npc;drop=18693"] = {"Speaker Mar'grom", "Blade's Edge Mountains"}
        s["npc;drop=18697"] = {"Chief Engineer Lorthander", "Netherstorm"}
        s["npc;drop=18708"] = {"Murmur", "Shadow Labyrinth"}
        s["npc;drop=18728"] = {"Doom Lord Kazzak", "Hellfire Peninsula"}
        s["npc;drop=18731"] = {"Ambassador Hellmaw", "Shadow Labyrinth"}
        s["npc;drop=18805"] = {"High Astromancer Solarian", "The Eye"}
        s["npc;drop=18831"] = {"High King Maulgar <Lord of the Ogres>", "Gruul's Lair"}
        s["npc;drop=19044"] = {"Gruul the Dragonkiller", "Gruul's Lair"}
        s["npc;drop=19220"] = {"Pathaleon the Calculator", "The Mechanar"}
        s["npc;drop=19221"] = {"Nethermancer Sepethrea", "The Mechanar"}
        s["npc;drop=19514"] = {"Al'ar <Phoenix God>", "The Eye"}
        s["npc;drop=19516"] = {"Void Reaver", "The Eye"}
        s["npc;drop=20035"] = {"Bloodwarder Marshal", "Tempest Keep"}
        s["npc;drop=20036"] = {"Bloodwarder Squire", "Tempest Keep"}
        s["npc;drop=20042"] = {"Tempest-Smith", "Tempest Keep"}
        s["npc;drop=20044"] = {"Novice Astromancer", "Tempest Keep"}
        s["npc;drop=20885"] = {"Dalliah the Doomsayer", "The Arcatraz"}
        s["npc;drop=21174"] = {"Magtheridon", ""}
        s["npc;drop=21212"] = {"Lady Vashj <Coilfang Matron>", "Serpentshrine Cavern"}
        s["npc;drop=21213"] = {"Morogrim Tidewalker", "Serpentshrine Cavern"}
        s["npc;drop=21214"] = {"Fathom-Lord Karathress", "Serpentshrine Cavern"}
        s["npc;drop=21215"] = {"Leotheras the Blind", "Serpentshrine Cavern"}
        s["npc;drop=21217"] = {"The Lurker Below", "Serpentshrine Cavern"}
        s["npc;drop=21251"] = {"Underbog Colossus", "Serpentshrine Cavern"}
        s["npc;drop=21466"] = {"Harbinger Skyriss", "The Arcatraz"}
        s["npc;drop=21838"] = {"Terokk", "Terokkar Forest"}
        s["npc;drop=21845"] = {"Leotheras the Blind", ""}
        s["npc;drop=21932"] = {"Hydross the Unstable <Duke of Currents>", ""}
        s["npc;drop=22052"] = {"Daggermaw Blackhide", "Blade's Edge Mountains"}
        s["npc;drop=22841"] = {"Shade of Akama", "Black Temple"}
        s["npc;drop=22845"] = {"Ashtongue Mystic", "Black Temple"}
        s["npc;drop=22871"] = {"Teron Gorefiend", "Black Temple"}
        s["npc;drop=22884"] = {"Leviathan", "Black Temple"}
        s["npc;drop=22898"] = {"Supremus", "Black Temple"}
        s["npc;drop=22917"] = {"Illidan Stormrage <The Betrayer>", "Black Temple"}
        s["npc;drop=22930"] = {"Yor <Void Hound of Shaffar>", "Mana-Tombs"}
        s["npc;drop=22947"] = {"Mother Shahraz", "Black Temple"}
        s["npc;drop=22948"] = {"Gurtogg Bloodboil", "Black Temple"}
        s["npc;drop=22950"] = {"High Nethermancer Zerevor", "Black Temple"}
        s["npc;drop=23054"] = {"Kael'thas Sunstrider <Lord of the Blood Elves>", "Shattrath City"}
        s["npc;drop=23236"] = {"Bonechewer Shield Disciple", "Black Temple"}
        s["npc;drop=23281"] = {"Insidion", "Blade's Edge Mountains"}
        s["npc;drop=23282"] = {"Obsidia", "Blade's Edge Mountains"}
        s["npc;drop=23374"] = {"Ashtongue Stalker", "Black Temple"}
        s["npc;drop=23397"] = {"Illidari Blood Lord", "Black Temple"}
        s["npc;drop=23402"] = {"Illidari Battle-mage", "Black Temple"}
        s["npc;drop=23420"] = {"Essence of Anger", "Black Temple"}
        s["npc;drop=23774"] = {"Amani'shi Trainer", "Zul'Aman"}
        s["npc;drop=23872"] = {"Coren Direbrew", "Blackrock Depths"}
        s["npc;sold=12777"] = {"Captain Dirgehammer <Armor Quartermaster>", "Alterac Valley"}
        s["npc;sold=12781"] = {"Master Sergeant Biggins <Officer Accessories Quartermaster>", "Stormwind City"}
        s["npc;sold=12792"] = {"Lady Palanseer <Armor Quartermaster>", "Alterac Valley"}
        s["npc;sold=17585"] = {"Quartermaster Urgronn <Thrallmar Quartermaster>", "Hellfire Peninsula"}
        s["npc;sold=17657"] = {"Logistics Officer Ulrike <Honor Hold Quartermaster>", "Hellfire Peninsula"}
        s["npc;sold=17904"] = {"Fedryen Swiftspear <Cenarion Expedition Quartermaster>", "Zangarmarsh"}
        s["npc;sold=18525"] = {"G'eras", "Shattrath City"}
        s["npc;sold=18898"] = {"Explodyne Fizzlespurt <Arena Vendor>", "Nagrand"}
        s["npc;sold=19321"] = {"Quartermaster Endarin <Aldor: Quartermaster>", "Shattrath City"}
        s["npc;sold=19331"] = {"Quartermaster Enuril <Scryers: Quartermaster>", "Shattrath City"}
        s["npc;sold=19536"] = {"Dealer Jadyan <Exotic Weapons>", "Netherstorm"}
        s["npc;sold=19772"] = {"Spirit Sage Gartok", "Terokkar Forest"}
        s["npc;sold=20278"] = {"Vixton Pinchwhistle <Arena Vendor>", "Netherstorm"}
        s["npc;sold=20613"] = {"Arodis Sunblade <Keeper of Sha'tari Artifacts>", "Shattrath City"}
        s["npc;sold=20616"] = {"Asuur <Keeper of Sha'tari Artifacts>", "Shattrath City"}
        s["npc;sold=21432"] = {"Almaador <Sha'tari Quartermaster>", "Shattrath City"}
        s["npc;sold=21643"] = {"Alurmi <Keepers of Time Quartermaster>", "Tanaris"}
        s["npc;sold=21655"] = {"Nakodu <Lower City Quartermaster>", "Shattrath City"}
        s["npc;sold=21905"] = {"Veynna Dawnstar <Keeper of Sha'tari Heirlooms>", "Shattrath City"}
        s["npc;sold=21906"] = {"Kelara <Keeper of Sha'tari Heirlooms>", "Shattrath City"}
        s["npc;sold=23159"] = {"Okuno <Ashtongue Deathsworn Quartermaster>", "Black Temple"}
        s["npc;sold=23381"] = {"Tydormu <Keeper of Lost Artifacts>", ""}
        s["npc;sold=23428"] = {"Jho'nass <Ogri'la Quartermaster>", "Blade's Edge Mountains"}
        s["npc;sold=25176"] = {"Grikkin Copperspring <Arena Vendor>", "Nagrand"}
        s["npc;sold=26089"] = {"Kayri <Exotic Gear Purveyor>", "Isle of Quel'Danas"}
        s["npc;sold=27668"] = {"Ontok Shatterhorn <Arena Vendor>", "Shattrath City"}
        s["npc;sold=3523"] = {"Bowen Brisboise <Tailoring Trainer>", "Tirisfal Glades"}
        s["npc;sold=3703"] = {"Krulmoo Fullmoon <Leatherworking Trainer>", "The Barrens"}
        s["object;contained=184465"] = {"Cache of the Legion", "The Mechanar"}
        s["object;contained=185119"] = {"Dust Covered Chest", "Karazhan"}
        s["object;contained=185169"] = {"Reinforced Fel Iron Chest", "Hellfire Ramparts"}
        s["object;contained=185584"] = {"Naj'entus Spine", "Black Temple"}
        s["quest;reward=10011"] = {"Forge Camp: Annihilated", ""}
        s["quest;reward=10091"] = {"The Soul Devices", ""}
        s["quest;reward=10136"] = {"Cruel's Intentions", ""}
        s["quest;reward=10176"] = {"Ar'kelos the Guardian", ""}
        s["quest;reward=10185"] = {"A Fate Worse Than Death", ""}
        s["quest;reward=10188"] = {"The Sigil of Krasus", ""}
        s["quest;reward=10280"] = {"Special Delivery to Shattrath City", "Netherstorm"}
        s["quest;reward=10298"] = {"Hero of the Brood", ""}
        s["quest;reward=10320"] = {"Destroy Naberius!", ""}
        s["quest;reward=10323"] = {"Shutting Down Manaforge Ara", ""}
        s["quest;reward=10337"] = {"When the Cows Come Home", ""}
        s["quest;reward=10345"] = {"The Flesh Lies...", ""}
        s["quest;reward=10353"] = {"Arconus the Insatiable", ""}
        s["quest;reward=10365"] = {"Shutting Down Manaforge Ara", ""}
        s["quest;reward=10381"] = {"Aldor No More", ""}
        s["quest;reward=10400"] = {"Overlord", ""}
        s["quest;reward=10409"] = {"Deathblow to the Legion", ""}
        s["quest;reward=10425"] = {"Escape from the Staging Grounds", ""}
        s["quest;reward=10439"] = {"Dimensius the All-Devouring", ""}
        s["quest;reward=10460"] = {"Defender's Pledge", ""}
        s["quest;reward=10462"] = {"Champion's Pledge", ""}
        s["quest;reward=10463"] = {"Sage's Pledge", ""}
        s["quest;reward=10472"] = {"Sage's Covenant", ""}
        s["quest;reward=10473"] = {"Restorer's Covenant", ""}
        s["quest;reward=10474"] = {"Champion's Covenant", ""}
        s["quest;reward=10507"] = {"Turning Point", ""}
        s["quest;reward=10579"] = {"The Cipher of Damnation - The Third Fragment Recovered", ""}
        s["quest;reward=10645"] = {"Teron Gorefiend, I am...", ""}
        s["quest;reward=10704"] = {"How to Break Into the Arcatraz", ""}
        s["quest;reward=10728"] = {"Eminence Among the Violet Eye", ""}
        s["quest;reward=10745"] = {"News of Victory", ""}
        s["quest;reward=10769"] = {"Dissension Amongst the Ranks...", ""}
        s["quest;reward=10781"] = {"Battle of the Crimson Watch", ""}
        s["quest;reward=10806"] = {"Showdown", "Blade's Edge Mountains"}
        s["quest;reward=10912"] = {"The Hound-Master", ""}
        s["quest;reward=10938"] = {"Darkmoon Blessings Deck", ""}
        s["quest;reward=10940"] = {"Darkmoon Furies Deck", ""}
        s["quest;reward=10941"] = {"Darkmoon Lunacy Deck", ""}
        s["quest;reward=11001"] = {"Vanquish the Raven God", ""}
        s["quest;reward=11002"] = {"The Fall of Magtheridon", "Hellfire Peninsula"}
        s["quest;reward=11007"] = {"Kael'thas and the Verdant Sphere", ""}
        s["quest;reward=11031"] = {"Archmage No More", ""}
        s["quest;reward=11032"] = {"Protector No More", "Deadwind Pass"}
        s["quest;reward=11033"] = {"Assassin No More", "Deadwind Pass"}
        s["quest;reward=11041"] = {"A Job Unfinished...", ""}
        s["quest;reward=11092"] = {"Hail, Commander!", ""}
        s["quest;reward=9120"] = {"The Fall of Kel'Thuzad", "Eastern Plaguelands"}
        s["quest;reward=9271"] = {"Atiesh, Greatstaff of the Guardian", "Stratholme"}
        s["quest;reward=9494"] = {"Fel Embers", ""}
        s["quest;reward=9763"] = {"The Warlord's Hideout", ""}
        s["quest;reward=9860"] = {"The New Directive", ""}
        s["spell;created=17632"] = {"Alchemist's Stone", "CRAFTING"}
        s["spell;created=23537"] = {"Enrage", ""}
        s["spell;created=23773"] = {"Suffering of Sanity", ""}
        s["spell;created=23786"] = {"Powerful Anti-Venom", ""}
        s["spell;created=23793"] = {"Strength", ""}
        s["spell;created=26752"] = {"Spellfire Belt", "CRAFTING"}
        s["spell;created=26753"] = {"Spellfire Gloves", "CRAFTING"}
        s["spell;created=26754"] = {"Spellfire Robe", "CRAFTING"}
        s["spell;created=26756"] = {"Frozen Shadoweave Shoulders", "CRAFTING"}
        s["spell;created=26757"] = {"Frozen Shadoweave Boots", "CRAFTING"}
        s["spell;created=26758"] = {"Frozen Shadoweave Robe", "CRAFTING"}
        s["spell;created=26760"] = {"Primal Mooncloth Belt", "CRAFTING"}
        s["spell;created=26761"] = {"Primal Mooncloth Shoulders", "CRAFTING"}
        s["spell;created=26762"] = {"Primal Mooncloth Robe", "CRAFTING"}
        s["spell;created=28439"] = {"Create Eternal Quintessence", ""}
        s["spell;created=29548"] = {"Fel Iron Plate Boots", "CRAFTING"}
        s["spell;created=29606"] = {"Adamantite Breastplate", "CRAFTING"}
        s["spell;created=29619"] = {"Felsteel Gloves", "CRAFTING"}
        s["spell;created=29620"] = {"Felsteel Leggings", "CRAFTING"}
        s["spell;created=29621"] = {"Felsteel Helm", "CRAFTING"}
        s["spell;created=29622"] = {"Gauntlets of the Iron Tower", "CRAFTING"}
        s["spell;created=29664"] = {"Helm of the Stalwart Defender", "CRAFTING"}
        s["spell;created=29668"] = {"Oathkeeper's Helm", "CRAFTING"}
        s["spell;created=29671"] = {"Bracers of the Green Fortress", "CRAFTING"}
        s["spell;created=30031"] = {"Rampage", "CRAFTING"}
        s["spell;created=30033"] = {"Rampage", "CRAFTING"}
        s["spell;created=30036"] = {"Steal Magic", "CRAFTING"}
        s["spell;created=30039"] = {"Transference", "CRAFTING"}
        s["spell;created=30563"] = {"Goblin Rocket Launcher", "CRAFTING"}
        s["spell;created=30569"] = {"Gnomish Poultryizer", "CRAFTING"}
        s["spell;created=31060"] = {"Delicate Eternium Ring", "CRAFTING"}
        s["spell;created=31070"] = {"Braided Eternium Chain", "CRAFTING"}
        s["spell;created=31079"] = {"Figurine - Felsteel Boar", "CRAFTING"}
        s["spell;created=31080"] = {"Figurine - Dawnstone Crab", "CRAFTING"}
        s["spell;created=31081"] = {"Figurine - Living Ruby Serpent", "CRAFTING"}
        s["spell;created=31435"] = {"Bracers of Havok", "CRAFTING"}
        s["spell;created=31440"] = {"Cloak of Eternity", "CRAFTING"}
        s["spell;created=31443"] = {"Girdle of Ruination", "CRAFTING"}
        s["spell;created=31448"] = {"Resolute Cape", "CRAFTING"}
        s["spell;created=31449"] = {"Vengeance Wrap", "CRAFTING"}
        s["spell;created=31452"] = {"Spellstrike Pants", "CRAFTING"}
        s["spell;created=31454"] = {"Whitemend Hood", "CRAFTING"}
        s["spell;created=31455"] = {"Spellstrike Hood", "CRAFTING"}
        s["spell;created=32494"] = {"Fel Leather Leggings", "CRAFTING"}
        s["spell;created=32495"] = {"Heavy Clefthoof Vest", "CRAFTING"}
        s["spell;created=32497"] = {"Heavy Clefthoof Boots", "CRAFTING"}
        s["spell;created=32499"] = {"Felstalker Bracer", "CRAFTING"}
        s["spell;created=32756"] = {"Shadowy Disguise", ""}
        s["spell;created=32774"] = {"Avenger's Shield", ""}
        s["spell;created=33173"] = {"Greater Polymorph", ""}
        s["spell;created=33803"] = {"Flame Wave", ""}
        s["spell;created=34534"] = {"Bulwark of Kings", "CRAFTING"}
        s["spell;created=34540"] = {"Lionheart Champion", "CRAFTING"}
        s["spell;created=34544"] = {"Mooncleaver", "CRAFTING"}
        s["spell;created=34546"] = {"Dragonmaw", "CRAFTING"}
        s["spell;created=35559"] = {"Cobrascale Gloves", "CRAFTING"}
        s["spell;created=35563"] = {"Windslayer Wraps", "CRAFTING"}
        s["spell;created=35576"] = {"Ebon Netherscale Belt", "CRAFTING"}
        s["spell;created=35577"] = {"Ebon Netherscale Bracers", "CRAFTING"}
        s["spell;created=35580"] = {"Netherstrike Breastplate", "CRAFTING"}
        s["spell;created=35582"] = {"Netherstrike Belt", "CRAFTING"}
        s["spell;created=35584"] = {"Netherstrike Bracers", "CRAFTING"}
        s["spell;created=35585"] = {"Windhawk Hauberk", "CRAFTING"}
        s["spell;created=35587"] = {"Windhawk Belt", "CRAFTING"}
        s["spell;created=35588"] = {"Windhawk Bracers", "CRAFTING"}
        s["spell;created=35589"] = {"Primalstrike Vest", "CRAFTING"}
        s["spell;created=35591"] = {"Primalstrike Bracers", "CRAFTING"}
        s["spell;created=36315"] = {"Belt of Blasting", "CRAFTING"}
        s["spell;created=36317"] = {"Boots of Blasting", "CRAFTING"}
        s["spell;created=36355"] = {"Boots of Natural Grace", "CRAFTING"}
        s["spell;created=40744"] = {"Apexis Crystal Infusion", ""}
        s["spell;created=41160"] = {"Swiftstrike Shoulders", "CRAFTING"}
        s["spell;created=41161"] = {"Bindings of Lightning Reflexes", "CRAFTING"}
        s["spell;created=41163"] = {"Living Earth Bindings", "CRAFTING"}
        s["spell;created=41205"] = {"Bracers of Nimble Thought", "CRAFTING"}
        s["spell;created=41207"] = {"Swiftheal Wraps", "CRAFTING"}
        s["spell;created=42546"] = {"Cloak of Darkness", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationdeDE()
        s["npc;drop=15550"] = {"Attumen der Jäger", "Karazhan"}
        s["npc;drop=15687"] = {"Moroes <Turmwärter>", "Karazhan"}
        s["npc;drop=15688"] = {"Terestian Siechhuf", "Karazhan"}
        s["npc;drop=15689"] = {"Nethergroll", "Karazhan"}
        s["npc;drop=15690"] = {"Prinz Malchezaar", "Karazhan"}
        s["npc;drop=15691"] = {"Der Kurator", "Karazhan"}
        s["npc;drop=15989"] = {"Saphiron", "Naxxramas"}
        s["npc;drop=16152"] = {"Attumen der Jäger", "Karazhan"}
        s["npc;drop=16179"] = {"Hyakiss der Lauerer", "Karazhan"}
        s["npc;drop=16180"] = {"Shadikith der Gleiter", "Karazhan"}
        s["npc;drop=16181"] = {"Rokad der Verheerer", "Karazhan"}
        s["npc;drop=16411"] = {"Spektraler Küchenchef", "Karazhan"}
        s["npc;drop=16457"] = {"Tugendhafte Maid", "Karazhan"}
        s["npc;drop=16485"] = {"Arkanwachmann", "Karazhan"}
        s["npc;drop=16504"] = {"Arkanbeschützer", "Karazhan"}
        s["npc;drop=16524"] = {"Arans Schemen", "Karazhan"}
        s["npc;drop=16807"] = {"Großhexenmeister Nethekurse", "Die Zerschmetterten Hallen"}
        s["npc;drop=16808"] = {"Kriegshäuptling Kargath Messerfaust", "Die Zerschmetterten Hallen"}
        s["npc;drop=16816"] = {"Echo Medivhs", "Karazhan"}
        s["npc;drop=17225"] = {"Schrecken der Nacht", "Karazhan"}
        s["npc;drop=17257"] = {"Magtheridon", "Magtheridons Kammer"}
        s["npc;drop=17377"] = {"Keli'dan der Zerstörer", "Der Blutkessel"}
        s["npc;drop=17381"] = {"Der Schöpfer", "Der Blutkessel"}
        s["npc;drop=17521"] = {"Der große böse Wolf", "Karazhan"}
        s["npc;drop=17711"] = {"Verdammniswandler", "Schattenmondtal"}
        s["npc;drop=17767"] = {"Furor Winterfrost", "Hyjalgipfel"}
        s["npc;drop=17798"] = {"Kriegsherr Kalithresh", "Die Dampfkammer"}
        s["npc;drop=17808"] = {"Anetheron", "Hyjalgipfel"}
        s["npc;drop=17842"] = {"Azgalor", "Hyjalgipfel"}
        s["npc;drop=17848"] = {"Leutnant Drach", "Vorgebirge des Alten Hügellands"}
        s["npc;drop=17879"] = {"Chronolord Deja", "Der schwarze Morast"}
        s["npc;drop=17880"] = {"Temporus", "Der schwarze Morast"}
        s["npc;drop=17881"] = {"Aeonus", "Der schwarze Morast"}
        s["npc;drop=17882"] = {"Die Schattenmutter", "Der Tiefensumpf"}
        s["npc;drop=17888"] = {"Kaz'rogal", "Hyjalgipfel"}
        s["npc;drop=17897"] = {"Gruftscheusal", ""}
        s["npc;drop=17898"] = {"Monstrosität", ""}
        s["npc;drop=17908"] = {"Riesige Höllenbestie", ""}
        s["npc;drop=17942"] = {"Quagmirran", "Die Sklavenunterkünfte"}
        s["npc;drop=17968"] = {"Archimonde", "Hyjalgipfel"}
        s["npc;drop=17975"] = {"Hochbotaniker Freywinn", "Die Botanika"}
        s["npc;drop=17977"] = {"Warpzweig", "Die Botanika"}
        s["npc;drop=17978"] = {"Dorngrin der Hüter", "Die Botanika"}
        s["npc;drop=17980"] = {"Laj", "Die Botanika"}
        s["npc;drop=17991"] = {"Rokmar der Zerquetscher", "Die Sklavenunterkünfte"}
        s["npc;drop=18093"] = {"Beschützer von Tarrens Mühle", ""}
        s["npc;drop=18096"] = {"Epochenjäger", "Vorgebirge des Alten Hügellands"}
        s["npc;drop=18105"] = {"Ghaz'an", "Der Tiefensumpf"}
        s["npc;drop=18168"] = {"Die böse Hexe", "Karazhan"}
        s["npc;drop=18341"] = {"Pandemonius", "Managruft"}
        s["npc;drop=18343"] = {"Tavarok", "Managruft"}
        s["npc;drop=18344"] = {"Nexusprinz Shaffar", "Managruft"}
        s["npc;drop=18371"] = {"Shirrak der Totenwächter", "Auchenaikrypta"}
        s["npc;drop=18373"] = {"Exarch Maladaar", "Auchenaikrypta"}
        s["npc;drop=184259"] = {"Herr der Nacht", "Karazhan"}
        s["npc;drop=18472"] = {"Dunkelwirker Syth", "Sethekkhallen"}
        s["npc;drop=18473"] = {"Klauenkönig Ikiss", "Sethekkhallen"}
        s["npc;drop=18478"] = {"Avatar des Gemarterten", "Auchenaikrypta"}
        s["npc;drop=18667"] = {"Schwarzherz der Hetzer", "Schattenlabyrinth"}
        s["npc;drop=18693"] = {"Sprecher Mar'grom", "Schergrat"}
        s["npc;drop=18697"] = {"Chefingenieur Lorthander", "Nethersturm"}
        s["npc;drop=18708"] = {"Murmur", "Schattenlabyrinth"}
        s["npc;drop=18728"] = {"Verdammnislord Kazzak", "Höllenfeuerhalbinsel"}
        s["npc;drop=18731"] = {"Botschafter Höllenschlund", "Schattenlabyrinth"}
        s["npc;drop=18805"] = {"Hochastromantin Solarian", "Festung der Stürme"}
        s["npc;drop=18831"] = {"Hochkönig Maulgar <Lord der Oger>", "Gruuls Unterschlupf"}
        s["npc;drop=19044"] = {"Gruul der Drachenschlächter", "Gruuls Unterschlupf"}
        s["npc;drop=19220"] = {"Pathaleon der Kalkulator", "Die Mechanar"}
        s["npc;drop=19221"] = {"Nethermantin Sepethrea", "Die Mechanar"}
        s["npc;drop=19514"] = {"Al'ar <Phönixgott>", "Festung der Stürme"}
        s["npc;drop=19516"] = {"Leerhäscher", "Festung der Stürme"}
        s["npc;drop=20035"] = {"Marschall der Blutwärter", "Festung der Stürme"}
        s["npc;drop=20036"] = {"Knappe der Blutwärter", "Festung der Stürme"}
        s["npc;drop=20042"] = {"Schmied der Stürme", "Festung der Stürme"}
        s["npc;drop=20044"] = {"Astromantennovize", "Festung der Stürme"}
        s["npc;drop=20885"] = {"Dalliah die Verdammnisverkünderin", "Die Arkatraz"}
        s["npc;drop=21212"] = {"Lady Vashj <Matrone des Echsenkessels>", "Höhle des Schlangenschreins"}
        s["npc;drop=21213"] = {"Morogrim Gezeitenwandler", "Höhle des Schlangenschreins"}
        s["npc;drop=21214"] = {"Tiefenlord Karathress", "Höhle des Schlangenschreins"}
        s["npc;drop=21215"] = {"Leotheras der Blinde", "Höhle des Schlangenschreins"}
        s["npc;drop=21217"] = {"Das Grauen aus der Tiefe", "Höhle des Schlangenschreins"}
        s["npc;drop=21251"] = {"Tiefensumpfkoloss", "Höhle des Schlangenschreins"}
        s["npc;drop=21466"] = {"Herold Horizontiss", "Die Arkatraz"}
        s["npc;drop=21838"] = {"Terokk", "Wälder von Terokkar"}
        s["npc;drop=21845"] = {"Leotheras der Blinde", ""}
        s["npc;drop=21932"] = {"Hydross der Unstete <Fürst der Strömung>", ""}
        s["npc;drop=22052"] = {"Schwarzhautdolchrachen", "Schergrat"}
        s["npc;drop=22841"] = {"Akamas Schemen", "Der Schwarze Tempel"}
        s["npc;drop=22845"] = {"Mystiker der Aschenzungen", "Der Schwarze Tempel"}
        s["npc;drop=22871"] = {"Teron Blutschatten", "Der Schwarze Tempel"}
        s["npc;drop=22884"] = {"Leviathan", "Der Schwarze Tempel"}
        s["npc;drop=22898"] = {"Supremus", "Der Schwarze Tempel"}
        s["npc;drop=22917"] = {"Illidan Sturmgrimm <Der Verräter>", "Der Schwarze Tempel"}
        s["npc;drop=22930"] = {"Yor <Shaffars Leerenhund>", "Managruft"}
        s["npc;drop=22947"] = {"Mutter Shahraz", "Der Schwarze Tempel"}
        s["npc;drop=22948"] = {"Gurtogg Siedeblut", "Der Schwarze Tempel"}
        s["npc;drop=22950"] = {"Hochnethermant Zerevor", "Der Schwarze Tempel"}
        s["npc;drop=23054"] = {"Kael'thas Sonnenwanderer <Fürst der Blutelfen>", "Shattrath"}
        s["npc;drop=23236"] = {"Schildjünger der Knochenmalmer", "Der Schwarze Tempel"}
        s["npc;drop=23281"] = {"Insidion", "Schergrat"}
        s["npc;drop=23282"] = {"Obsidia", "Schergrat"}
        s["npc;drop=23374"] = {"Pirscher der Aschenzungen", "Der Schwarze Tempel"}
        s["npc;drop=23397"] = {"Blutlord der Illidari", "Der Schwarze Tempel"}
        s["npc;drop=23402"] = {"Kampfmagier der Illidari", "Der Schwarze Tempel"}
        s["npc;drop=23420"] = {"Essenz des Zorns", "Der Schwarze Tempel"}
        s["npc;drop=23774"] = {"Ausbilder der Amani'shi", ""}
        s["npc;drop=23872"] = {"Coren Düsterbräu", "Schwarzfelstiefen"}
        s["npc;sold=12777"] = {"Hauptmann Klagehammer <Rüstmeister für Rüstungen>", "Alteractal"}
        s["npc;sold=12781"] = {"Hauptfeldwebel Biggins <Rüstmeister für Offizierszubehör>", "Sturmwind"}
        s["npc;sold=12792"] = {"Lady Palanseher <Rüstmeisterin für Rüstungen>", "Alteractal"}
        s["npc;sold=17585"] = {"Rüstmeister Urgronn <Rüstmeister von Thrallmar>", "Höllenfeuerhalbinsel"}
        s["npc;sold=17657"] = {"Nachschuboffizier Ulrike <Rüstmeisterin der Ehrenfeste>", "Höllenfeuerhalbinsel"}
        s["npc;sold=17904"] = {"Fedryen Flinkspeer <Rüstmeister der Expedition des Cenarius>", "Zangarmarschen"}
        s["npc;sold=18525"] = {"G'eras", "Shattrath"}
        s["npc;sold=18898"] = {"Explodine Zischelspurt <Arenaverkäufer>", "Nagrand"}
        s["npc;sold=19321"] = {"Rüstmeister Endarin <Rüstmeister der Aldor>", "Shattrath"}
        s["npc;sold=19331"] = {"Rüstmeister Enuril <Rüstmeister der Seher>", "Shattrath"}
        s["npc;sold=19536"] = {"Händler Jadyan <Exotische Waffen>", "Nethersturm"}
        s["npc;sold=19772"] = {"Geistweiser Gartok", "Wälder von Terokkar"}
        s["npc;sold=20278"] = {"Vixton Quetschpfeife <Arenaverkäufer>", "Nethersturm"}
        s["npc;sold=20613"] = {"Arodis Sonnenklinge <Bewahrer der Artefakte der Sha'tari>", "Shattrath"}
        s["npc;sold=20616"] = {"Asuur <Bewahrer der Artefakte der Sha'tari>", "Shattrath"}
        s["npc;sold=21432"] = {"Almaador <Rüstmeister der Sha'tari>", "Shattrath"}
        s["npc;sold=21643"] = {"Alurmi <Rüstmeisterin der Hüter der Zeit>", "Tanaris"}
        s["npc;sold=21655"] = {"Nakodu <Rüstmeister des unteren Viertels>", "Shattrath"}
        s["npc;sold=21905"] = {"Veynna Morgenstern <Bewahrerin des Erbes der Sha'tari>", "Shattrath"}
        s["npc;sold=21906"] = {"Kelara <Bewahrerin des Erbes der Sha'tari>", "Shattrath"}
        s["npc;sold=23159"] = {"Okuno <Rüstmeister der Todeshörigen>", "Der Schwarze Tempel"}
        s["npc;sold=23381"] = {"Tydormu <Bewahrer der verlorenen Artefakte>", ""}
        s["npc;sold=23428"] = {"Jho'nass <Rüstmeister von Ogri'la>", "Schergrat"}
        s["npc;sold=25176"] = {"Grikkin Kupferspule <Arenaverkäufer>", "Nagrand"}
        s["npc;sold=26089"] = {"Kayri <Lieferantin für exotische Ausrüstung>", "Insel von Quel'Danas"}
        s["npc;sold=27668"] = {"Ontok Schmetterhorn <Arenaverkäufer>", "Shattrath"}
        s["npc;sold=3523"] = {"Bowen Brisboise <Schneiderlehrer>", "Tirisfal"}
        s["npc;sold=3703"] = {"Krulmoo Vollmond <Lederverarbeitungslehrer>", "Brachland"}
        s["object;contained=184465"] = {"Behälter der Legion", "Die Mechanar"}
        s["object;contained=185119"] = {"Staubbedeckte Truhe", "Karazhan"}
        s["object;contained=185169"] = {"Verstärkte Teufelseisentruhe", "Höllenfeuerbollwerk"}
        s["object;contained=185584"] = {"Naj'entus' Stachel", "Der Schwarze Tempel"}
        s["quest;reward=10011"] = {"Konstruktionslager: zerstört", ""}
        s["quest;reward=10091"] = {"Seeleninstrumente", ""}
        s["quest;reward=10136"] = {"Grausame Pläne", ""}
        s["quest;reward=10176"] = {"Ar'kelos der Wächter", ""}
        s["quest;reward=10185"] = {"Schlimmer als der Tod", ""}
        s["quest;reward=10188"] = {"Das Siegel von Krasus", ""}
        s["quest;reward=10280"] = {"Sonderlieferung nach Shattrath", "Nethersturm"}
        s["quest;reward=10298"] = {"Held des Schwarms", ""}
        s["quest;reward=10320"] = {"Vernichtet Naberius!", ""}
        s["quest;reward=10323"] = {"Manaschmiede Ara abschalten", ""}
        s["quest;reward=10337"] = {"Almabtrieb", ""}
        s["quest;reward=10345"] = {"Fleisch geworden", ""}
        s["quest;reward=10353"] = {"Arconus der Unersättliche", ""}
        s["quest;reward=10365"] = {"Manaschmiede Ara abschalten", ""}
        s["quest;reward=10381"] = {"Nie mehr Aldor", ""}
        s["quest;reward=10400"] = {"Oberanführer", ""}
        s["quest;reward=10409"] = {"Todesstoß für die Legion", ""}
        s["quest;reward=10425"] = {"Ausbruch aus dem Stützpunkt", ""}
        s["quest;reward=10439"] = {"Dimensius der alles Verschlingende", ""}
        s["quest;reward=10460"] = {"Das Versprechen des Verteidigers", ""}
        s["quest;reward=10462"] = {"Das Versprechen des Helden", ""}
        s["quest;reward=10463"] = {"Das Versprechen des Weisen", ""}
        s["quest;reward=10472"] = {"Das Bündnis des Weisen", ""}
        s["quest;reward=10473"] = {"Das Bündnis des Bewahrers", ""}
        s["quest;reward=10474"] = {"Das Bündnis des Helden", ""}
        s["quest;reward=10507"] = {"Der Wendepunkt", ""}
        s["quest;reward=10579"] = {"Die Litanei der Verdammnis - Dritter Teil", ""}
        s["quest;reward=10645"] = {"Ich bin Teron Blutschatten...", ""}
        s["quest;reward=10704"] = {"Wie man in Arkatraz einbricht", ""}
        s["quest;reward=10728"] = {"Geachtet vom Violetten Auge", ""}
        s["quest;reward=10745"] = {"Nachricht vom Sieg", ""}
        s["quest;reward=10769"] = {"Zwietracht in den Rängen...", ""}
        s["quest;reward=10781"] = {"Die Schlacht an der Purpurwacht", ""}
        s["quest;reward=10806"] = {"Finale", "Schergrat"}
        s["quest;reward=10912"] = {"Der Hundehetzer", ""}
        s["quest;reward=10938"] = {"Segenskartenset des Dunkelmond-Jahrmarkts", ""}
        s["quest;reward=10940"] = {"Furienkartenset des Dunkelmond-Jahrmarkts", ""}
        s["quest;reward=10941"] = {"Deliriumkartenset des Dunkelmond-Jahrmarkts", ""}
        s["quest;reward=11001"] = {"Vernichtet den Rabengott", ""}
        s["quest;reward=11002"] = {"Magtheridons Untergang", "Höllenfeuerhalbinsel"}
        s["quest;reward=11007"] = {"Kael'thas und die tiefgrüne Sphäre", ""}
        s["quest;reward=11031"] = {"Nicht mehr Erzmagier", ""}
        s["quest;reward=11032"] = {"Nicht mehr Beschützer", "Gebirgspass der Totenwinde"}
        s["quest;reward=11033"] = {"Nicht mehr Assassine", "Gebirgspass der Totenwinde"}
        s["quest;reward=11041"] = {"Eine unerledigte Aufgabe...", ""}
        s["quest;reward=11092"] = {"Glück auf, Kommandant!", ""}
        s["quest;reward=9120"] = {"Der Niedergang Kel'Thuzads", "Östliche Pestländer"}
        s["quest;reward=9271"] = {"Atiesh, Hohestab des Wächters", "Stratholme"}
        s["quest;reward=9494"] = {"Teufelsglut", ""}
        s["quest;reward=9763"] = {"Das Versteck des Kriegsherren", ""}
        s["quest;reward=9860"] = {"Neue Anweisungen", ""}
        s["spell;created=17632"] = {"Alchimistenstein", "CRAFTING"}
        s["spell;created=23537"] = {"Wutanfall", ""}
        s["spell;created=23773"] = {"Leiden des Verstands", ""}
        s["spell;created=23786"] = {"Mächtiges Gegengift", ""}
        s["spell;created=23793"] = {"Stärke", ""}
        s["spell;created=26752"] = {"Zauberfeuergürtel", "CRAFTING"}
        s["spell;created=26753"] = {"Zauberfeuerhandschuhe", "CRAFTING"}
        s["spell;created=26754"] = {"Zauberfeuerrobe", "CRAFTING"}
        s["spell;created=26756"] = {"Eisschattenzwirnschultern", "CRAFTING"}
        s["spell;created=26757"] = {"Eisschattenzwirnstiefel", "CRAFTING"}
        s["spell;created=26758"] = {"Eisschattenzwirnrobe", "CRAFTING"}
        s["spell;created=26760"] = {"Urmondstoffgürtel", "CRAFTING"}
        s["spell;created=26761"] = {"Urmondstoffschultern", "CRAFTING"}
        s["spell;created=26762"] = {"Urmondstoffrobe", "CRAFTING"}
        s["spell;created=28439"] = {"Ewige Quintessenz herstellen", ""}
        s["spell;created=29548"] = {"Teufelseisenplattenstiefel", "CRAFTING"}
        s["spell;created=29606"] = {"Adamantitbrustplatte", "CRAFTING"}
        s["spell;created=29619"] = {"Teufelsstahlhandschuhe", "CRAFTING"}
        s["spell;created=29620"] = {"Teufelsstahlgamaschen", "CRAFTING"}
        s["spell;created=29621"] = {"Teufelsstahlhelm", "CRAFTING"}
        s["spell;created=29622"] = {"Stulpen des eisernen Turms", "CRAFTING"}
        s["spell;created=29664"] = {"Helm des tapferen Verteidigers", "CRAFTING"}
        s["spell;created=29668"] = {"Helm der Eidestreue", "CRAFTING"}
        s["spell;created=29671"] = {"Armschienen der grünen Festung", "CRAFTING"}
        s["spell;created=30031"] = {"Toben", "CRAFTING"}
        s["spell;created=30033"] = {"Toben", "CRAFTING"}
        s["spell;created=30036"] = {"Magie stehlen", "CRAFTING"}
        s["spell;created=30039"] = {"Übertragung", "CRAFTING"}
        s["spell;created=30563"] = {"Goblinraketenwerfer", "CRAFTING"}
        s["spell;created=30569"] = {"Gnomischer Geflügelisierer", "CRAFTING"}
        s["spell;created=31060"] = {"Feiner Eterniumring", "CRAFTING"}
        s["spell;created=31070"] = {"Geflochtene Eterniumkette", "CRAFTING"}
        s["spell;created=31079"] = {"Figur - Teufelsstahleber", "CRAFTING"}
        s["spell;created=31080"] = {"Figur - Dämmersteinkrebs", "CRAFTING"}
        s["spell;created=31081"] = {"Figur - Lebendige Rubinschlange", "CRAFTING"}
        s["spell;created=31435"] = {"Armschienen der Verwüstung", "CRAFTING"}
        s["spell;created=31440"] = {"Umhang der Ewigkeit", "CRAFTING"}
        s["spell;created=31443"] = {"Gurt der Zerstörung", "CRAFTING"}
        s["spell;created=31448"] = {"Cape der Entschlossenheit", "CRAFTING"}
        s["spell;created=31449"] = {"Wickeltuch der Vergeltung", "CRAFTING"}
        s["spell;created=31452"] = {"Hose des Zauberschlags", "CRAFTING"}
        s["spell;created=31454"] = {"Kapuze des weißen Heilers", "CRAFTING"}
        s["spell;created=31455"] = {"Kapuze des Zauberschlags", "CRAFTING"}
        s["spell;created=32494"] = {"Teufelsledergamaschen", "CRAFTING"}
        s["spell;created=32495"] = {"Schwere Grollhufweste", "CRAFTING"}
        s["spell;created=32497"] = {"Schwere Grollhufstiefel", "CRAFTING"}
        s["spell;created=32499"] = {"Armschienen des Teufelspirschers", "CRAFTING"}
        s["spell;created=32756"] = {"Schattenhafte Verkleidung", ""}
        s["spell;created=32774"] = {"Schild des Rächers", ""}
        s["spell;created=33173"] = {"Große Verwandlung", ""}
        s["spell;created=33803"] = {"Flammenwelle", ""}
        s["spell;created=34534"] = {"Bollwerk der Könige", "CRAFTING"}
        s["spell;created=34540"] = {"Löwenherzchampion", "CRAFTING"}
        s["spell;created=34544"] = {"Mondspaltbeil", "CRAFTING"}
        s["spell;created=34546"] = {"Drachenmal", "CRAFTING"}
        s["spell;created=35559"] = {"Kobraschuppenhandschuhe", "CRAFTING"}
        s["spell;created=35563"] = {"Windtöterwickel", "CRAFTING"}
        s["spell;created=35576"] = {"Ebenholzfarbener Netherschuppengürtel", "CRAFTING"}
        s["spell;created=35577"] = {"Ebenholzfarbene Netherschuppenarmschienen", "CRAFTING"}
        s["spell;created=35580"] = {"Netherstoßbrustplatte", "CRAFTING"}
        s["spell;created=35582"] = {"Netherstoßgürtel", "CRAFTING"}
        s["spell;created=35584"] = {"Netherstoßarmschienen", "CRAFTING"}
        s["spell;created=35585"] = {"Windfalkenhalsberge", "CRAFTING"}
        s["spell;created=35587"] = {"Windfalkengürtel", "CRAFTING"}
        s["spell;created=35588"] = {"Windfalkenarmschienen", "CRAFTING"}
        s["spell;created=35589"] = {"Erstschlagweste", "CRAFTING"}
        s["spell;created=35591"] = {"Erstschlagarmschienen", "CRAFTING"}
        s["spell;created=36315"] = {"Gürtel der Zauberwucht", "CRAFTING"}
        s["spell;created=36317"] = {"Stiefel der Zauberwucht", "CRAFTING"}
        s["spell;created=36355"] = {"Stiefel der naturgleichen Anmut", "CRAFTING"}
        s["spell;created=40744"] = {"Energie der Apexiskristalle", ""}
        s["spell;created=41160"] = {"Flinkschlagschultern", "CRAFTING"}
        s["spell;created=41161"] = {"Bindungen der blitzartigen Reflexe", "CRAFTING"}
        s["spell;created=41163"] = {"Lebendige Erdbindungen", "CRAFTING"}
        s["spell;created=41205"] = {"Armschienen des flinken Gedankens", "CRAFTING"}
        s["spell;created=41207"] = {"Flinkheiltücher", "CRAFTING"}
        s["spell;created=42546"] = {"Umhang der Dunkelheit", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationesES()
        s["npc;drop=15550"] = {"Attumen el Montero", "Karazhan"}
        s["npc;drop=15687"] = {"Moroes <Administrador de la torre>", "Karazhan"}
        s["npc;drop=15688"] = {"Terestian Pezuña Enferma", "Karazhan"}
        s["npc;drop=15689"] = {"Rencor abisal", "Karazhan"}
        s["npc;drop=15690"] = {"Príncipe Malchezaar", "Karazhan"}
        s["npc;drop=15691"] = {"Curator", "Karazhan"}
        s["npc;drop=15989"] = {"Safirón", "Naxxramas"}
        s["npc;drop=16152"] = {"Attumen el Montero", "Karazhan"}
        s["npc;drop=16179"] = {"Hyakiss el Rondador", "Karazhan"}
        s["npc;drop=16180"] = {"Shadikith el Planeador", "Karazhan"}
        s["npc;drop=16181"] = {"Rokad el Devastador", "Karazhan"}
        s["npc;drop=16411"] = {"Chef espectral", "Karazhan"}
        s["npc;drop=16457"] = {"Doncella de Virtud", "Karazhan"}
        s["npc;drop=16485"] = {"Velador Arcano", "Karazhan"}
        s["npc;drop=16504"] = {"Protector Arcano", "Karazhan"}
        s["npc;drop=16524"] = {"Sombra de Aran", "Karazhan"}
        s["npc;drop=16807"] = {"Brujo supremo Malbisal", "Las Salas Arrasadas"}
        s["npc;drop=16808"] = {"Jefe de Guerra Kargath Garrafilada", "Las Salas Arrasadas"}
        s["npc;drop=16816"] = {"Eco de Medivh", "Karazhan"}
        s["npc;drop=17225"] = {"Nocturno", "Karazhan"}
        s["npc;drop=17257"] = {"Magtheridon", "Guarida de Magtheridon"}
        s["npc;drop=17377"] = {"Keli'dan el Ultrajador", "El Horno de Sangre"}
        s["npc;drop=17381"] = {"El Hacedor", "El Horno de Sangre"}
        s["npc;drop=17521"] = {"El Lobo Feroz", "Karazhan"}
        s["npc;drop=17711"] = {"Caminante del Destino", "Valle Sombraluna"}
        s["npc;drop=17767"] = {"Ira Fríoinvierno", "La Cima Hyjal"}
        s["npc;drop=17798"] = {"Señor de la Guerra Kalithresh", "La Cámara de Vapor"}
        s["npc;drop=17808"] = {"Anetheron", "La Cima Hyjal"}
        s["npc;drop=17842"] = {"Azgalor", "La Cima Hyjal"}
        s["npc;drop=17848"] = {"Teniente Draco", "Antiguas Laderas de Trabalomas"}
        s["npc;drop=17879"] = {"Cronolord Deja", "La Ciénaga Negra"}
        s["npc;drop=17880"] = {"Temporus", "La Ciénaga Negra"}
        s["npc;drop=17881"] = {"Aeonus", "La Ciénaga Negra"}
        s["npc;drop=17882"] = {"La acechadora negra", "La Sotiénaga"}
        s["npc;drop=17888"] = {"Kaz'rogal", "La Cima Hyjal"}
        s["npc;drop=17897"] = {"Maligno de cripta", ""}
        s["npc;drop=17898"] = {"Abominación", ""}
        s["npc;drop=17908"] = {"Infernal gigante", ""}
        s["npc;drop=17942"] = {"Quagmirran", "Recinto de los Esclavos"}
        s["npc;drop=17968"] = {"Archimonde", "La Cima Hyjal"}
        s["npc;drop=17975"] = {"Gran botánico Freywinn", "El Invernáculo"}
        s["npc;drop=17977"] = {"Disidente de distorsión", "El Invernáculo"}
        s["npc;drop=17978"] = {"Thorngrin el Tierno", "El Invernáculo"}
        s["npc;drop=17980"] = {"Laj", "El Invernáculo"}
        s["npc;drop=17991"] = {"Rokmar el Crujidor", "Recinto de los Esclavos"}
        s["npc;drop=18093"] = {"Protector de Molino Tarren", ""}
        s["npc;drop=18096"] = {"Cazador de eras", "Antiguas Laderas de Trabalomas"}
        s["npc;drop=18105"] = {"Ghaz'an", "La Sotiénaga"}
        s["npc;drop=18168"] = {"La Vieja Bruja", "Karazhan"}
        s["npc;drop=18341"] = {"Pandemonius", "Tumbas de Maná"}
        s["npc;drop=18343"] = {"Tavarok", "Tumbas de Maná"}
        s["npc;drop=18344"] = {"Príncipe-nexo Shaffar", "Tumbas de Maná"}
        s["npc;drop=18371"] = {"Shirrak el Vigía de los Muertos", "Criptas Auchenai"}
        s["npc;drop=18373"] = {"Exarca Maladaar", "Criptas Auchenai"}
        s["npc;drop=184259"] = {"Dueño de la noche", "Karazhan"}
        s["npc;drop=18472"] = {"Tejeoscuro Syth", "Salas Sethekk"}
        s["npc;drop=18473"] = {"Rey Garra Ikiss", "Salas Sethekk"}
        s["npc;drop=18478"] = {"Avatar de los Martirizados", "Criptas Auchenai"}
        s["npc;drop=18667"] = {"Negrozón el Incitador", "Laberinto de las Sombras"}
        s["npc;drop=18693"] = {"Portavoz Mar'grom", "Montañas Filospada"}
        s["npc;drop=18697"] = {"Ingeniero jefe Lorthander", "Tormenta Abisal"}
        s["npc;drop=18708"] = {"Murmullo", "Laberinto de las Sombras"}
        s["npc;drop=18728"] = {"Señor Apocalíptico Kazzak", "Península del Fuego Infernal"}
        s["npc;drop=18731"] = {"Embajador Faucinferno", "Laberinto de las Sombras"}
        s["npc;drop=18805"] = {"Gran astromántica Solarian", "El Castillo de la Tempestad"}
        s["npc;drop=18831"] = {"Su majestad Maulgar <Señor de los ogros>", "Guarida de Gruul"}
        s["npc;drop=19044"] = {"Gruul el Asesino de Dragones", "Guarida de Gruul"}
        s["npc;drop=19220"] = {"Pathaleon el Calculador", "El Mechanar"}
        s["npc;drop=19221"] = {"Abisálica Sepethrea", "El Mechanar"}
        s["npc;drop=19514"] = {"Al'ar <Dios Fénix>", "El Castillo de la Tempestad"}
        s["npc;drop=19516"] = {"Atracador del vacío", "El Castillo de la Tempestad"}
        s["npc;drop=20035"] = {"Mariscal Depositario de sangre", "El Castillo de la Tempestad"}
        s["npc;drop=20036"] = {"Escudero Depositario de sangre", "El Castillo de la Tempestad"}
        s["npc;drop=20042"] = {"Herrero Tempestad", "El Castillo de la Tempestad"}
        s["npc;drop=20044"] = {"Astromántico novicio", "El Castillo de la Tempestad"}
        s["npc;drop=20885"] = {"Dalliah la Decidora del Destino", "El Arcatraz"}
        s["npc;drop=21212"] = {"Lady Vashj <Matrona Colmillo Torcido>", "Caverna Santuario Serpiente"}
        s["npc;drop=21213"] = {"Morogrim Levantamareas", "Caverna Santuario Serpiente"}
        s["npc;drop=21214"] = {"Señor de las profundidades Karathress", "Caverna Santuario Serpiente"}
        s["npc;drop=21215"] = {"Leotheras el Ciego", "Caverna Santuario Serpiente"}
        s["npc;drop=21217"] = {"El Rondador de abajo", "Caverna Santuario Serpiente"}
        s["npc;drop=21251"] = {"Coloso de la Sotiénaga", "Caverna Santuario Serpiente"}
        s["npc;drop=21466"] = {"Presagista Cieloriss", "El Arcatraz"}
        s["npc;drop=21838"] = {"Terokk", "Bosque de Terokkar"}
        s["npc;drop=21845"] = {"Leotheras el Ciego", ""}
        s["npc;drop=21932"] = {"Hydross el Inestable <Duque de corrientes>", ""}
        s["npc;drop=22052"] = {"Pellejo negro Faucedaga", "Montañas Filospada"}
        s["npc;drop=22841"] = {"Sombra de Akama", "Templo Oscuro"}
        s["npc;drop=22845"] = {"Místico Lengua de ceniza", "Templo Oscuro"}
        s["npc;drop=22871"] = {"Teron Sanguino", "Templo Oscuro"}
        s["npc;drop=22884"] = {"Leviatán", "Templo Oscuro"}
        s["npc;drop=22898"] = {"Supremus", "Templo Oscuro"}
        s["npc;drop=22917"] = {"Illidan Tempestira <El Traidor>", "Templo Oscuro"}
        s["npc;drop=22930"] = {"Yor <Can del vacío de Shaffar>", "Tumbas de Maná"}
        s["npc;drop=22947"] = {"Madre Shahraz", "Templo Oscuro"}
        s["npc;drop=22948"] = {"Gurtogg Sangre Hirviente", "Templo Oscuro"}
        s["npc;drop=22950"] = {"Sumo abisálico Zerevor", "Templo Oscuro"}
        s["npc;drop=23054"] = {"Kael'thas Caminante del Sol <Señor de los elfos de sangre>", "Ciudad de Shattrath"}
        s["npc;drop=23236"] = {"Discípulo escudo Mascahuesos", "Templo Oscuro"}
        s["npc;drop=23281"] = {"Insidion", "Montañas Filospada"}
        s["npc;drop=23282"] = {"Obsidia", "Montañas Filospada"}
        s["npc;drop=23374"] = {"Acechador Lengua de ceniza", "Templo Oscuro"}
        s["npc;drop=23397"] = {"Señor de sangre Illidari", "Templo Oscuro"}
        s["npc;drop=23402"] = {"Mago de batalla Illidari", "Templo Oscuro"}
        s["npc;drop=23420"] = {"Esencia de Inquina", "Templo Oscuro"}
        s["npc;drop=23774"] = {"Instructor Amani'shi", ""}
        s["npc;drop=23872"] = {"Coren Cerveza Temible", "Profundidades de Roca Negra"}
        s["npc;sold=12777"] = {"Capitán Martillo Temible <Intendente de armaduras>", "Valle de Alterac"}
        s["npc;sold=12781"] = {"Sargento maestro Biggins <Oficial intendente de accesorios>", "Ciudad de Ventormenta"}
        s["npc;sold=12792"] = {"Lady Palanseer <Intendente de armaduras>", "Cuenca de Arathi"}
        s["npc;sold=17585"] = {"Intendente Urgronn <Intendente de Thrallmar>", "Península del Fuego Infernal"}
        s["npc;sold=17657"] = {"Oficial de logística Ulrike <Intendente del Bastión del Honor>", "Península del Fuego Infernal"}
        s["npc;sold=17904"] = {"Fedryen Lanzapresta <Intendente de la expedición de Cenarion>", "Marisma de Zangar"}
        s["npc;sold=18525"] = {"G'eras", "Ciudad de Shattrath"}
        s["npc;sold=18898"] = {"Explodyne Esfuerzovano <Vendedora de arena>", "Nagrand"}
        s["npc;sold=19321"] = {"Intendente Endarin <Aldor: Intendente>", "Ciudad de Shattrath"}
        s["npc;sold=19331"] = {"Intendente Enuril <Arúspices: Intendente>", "Ciudad de Shattrath"}
        s["npc;sold=19536"] = {"Tratante Jadyan <Armas exóticas>", "Tormenta Abisal"}
        s["npc;sold=19772"] = {"Espíritu de sabio Gartok", "Bosque de Terokkar"}
        s["npc;sold=20278"] = {"Vixton Silbapellizco <Vendedor de arena>", "Tormenta Abisal"}
        s["npc;sold=20613"] = {"Arodis Filosol <Vigilante de artefactos Sha'tari>", "Ciudad de Shattrath"}
        s["npc;sold=20616"] = {"Asuur <Vigilante de artefactos Sha'tari>", "Ciudad de Shattrath"}
        s["npc;sold=21432"] = {"Almaador <Intendente Sha'tari>", "Ciudad de Shattrath"}
        s["npc;sold=21643"] = {"Alurmi <Intendente de los Vigilantes del Tiempo>", "Tanaris"}
        s["npc;sold=21655"] = {"Nakodu <Intendente del Bajo Arrabal>", "Ciudad de Shattrath"}
        s["npc;sold=21905"] = {"Veynna Estrella del Alba <Vigilante de reliquias Sha'tari>", "Ciudad de Shattrath"}
        s["npc;sold=21906"] = {"Kelara <Vigilante de reliquias Sha'tari>", "Ciudad de Shattrath"}
        s["npc;sold=23159"] = {"Okuno <Intendente juramorte Lengua de ceniza>", "Templo Oscuro"}
        s["npc;sold=23381"] = {"Tydormu <Vigilante de artefactos perdidos>", ""}
        s["npc;sold=23428"] = {"Jho'nass <Intendente Ogri'la>", "Montañas Filospada"}
        s["npc;sold=25176"] = {"Grikkin Pococobre <Vendedor de arena>", "Nagrand"}
        s["npc;sold=26089"] = {"Kayri <Abastecedora de equipo exótico>", "Isla de Quel'Danas"}
        s["npc;sold=27668"] = {"Ontok Quebrantacuernos <Vendedor de arena>", "Ciudad de Shattrath"}
        s["npc;sold=3523"] = {"Bowen Brisboise <Instructor de sastrería>", "Claros de Tirisfal"}
        s["npc;sold=3703"] = {"Krulmoo Lunallena <Instructor de peletería>", "Los Baldíos"}
        s["object;contained=184465"] = {"Alijo de la Legión", "El Mechanar"}
        s["object;contained=185119"] = {"Cofre cubierto de polvo", "Karazhan"}
        s["object;contained=185169"] = {"Cofre de hierro vil reforzado", "Murallas del Fuego Infernal"}
        s["object;contained=185584"] = {"Espinazo de Naj'entus", "Templo Oscuro"}
        s["quest;reward=10011"] = {"Campamento Forja: aniquilado", ""}
        s["quest;reward=10091"] = {"Los dispositivos de almas", ""}
        s["quest;reward=10136"] = {"Crueles intenciones", ""}
        s["quest;reward=10176"] = {"Ar'kelos el Guardián", ""}
        s["quest;reward=10185"] = {"Terrible destino", ""}
        s["quest;reward=10188"] = {"El Sigilo de Krasus", ""}
        s["quest;reward=10280"] = {"Una entrega especial a la Ciudad de Shattrath", "Tormenta Abisal"}
        s["quest;reward=10298"] = {"Adalid del linaje", ""}
        s["quest;reward=10320"] = {"¡Destruir a Naberius!", ""}
        s["quest;reward=10323"] = {"El cierre de la Forja de Maná Ara", ""}
        s["quest;reward=10337"] = {"Cuando las vacas vuelven a casa", ""}
        s["quest;reward=10345"] = {"La carne sí engaña", ""}
        s["quest;reward=10353"] = {"Arconus el Insaciable", ""}
        s["quest;reward=10365"] = {"El cierre de la Forja de Maná Ara", ""}
        s["quest;reward=10381"] = {"Se acabaron los Aldor", ""}
        s["quest;reward=10400"] = {"Señor Supremo", ""}
        s["quest;reward=10409"] = {"Golpe mortal a la Legión", ""}
        s["quest;reward=10425"] = {"Huida del punto de escala", ""}
        s["quest;reward=10439"] = {"Dimensius el Devoratodo", ""}
        s["quest;reward=10460"] = {"Juramento de defensor", ""}
        s["quest;reward=10462"] = {"Juramento de campeón", ""}
        s["quest;reward=10463"] = {"Juramento de sabio", ""}
        s["quest;reward=10472"] = {"El pacto del sabio", ""}
        s["quest;reward=10473"] = {"El pacto del restaurador", ""}
        s["quest;reward=10474"] = {"El pacto del campeón", ""}
        s["quest;reward=10507"] = {"Punto de inflexión", ""}
        s["quest;reward=10579"] = {"La Clave de Condenación: Tercer trozo recuperado", ""}
        s["quest;reward=10645"] = {"Teron Sanguino, soy...", ""}
        s["quest;reward=10704"] = {"Cómo infiltrarse en El Arcatraz", ""}
        s["quest;reward=10728"] = {"Eminencia ante El Ojo Violeta", ""}
        s["quest;reward=10745"] = {"Noticias victoriosas", ""}
        s["quest;reward=10769"] = {"Disensión entre las filas...", ""}
        s["quest;reward=10781"] = {"La batalla de la Atalaya Carmesí", ""}
        s["quest;reward=10806"] = {"Enfrentamiento", "Montañas Filospada"}
        s["quest;reward=10912"] = {"El Maestro de canes", ""}
        s["quest;reward=10938"] = {"La baraja de Bendiciones de la Luna Negra", ""}
        s["quest;reward=10940"] = {"La baraja de Furias de la Luna Negra", ""}
        s["quest;reward=10941"] = {"La baraja de Locuras de la Luna Negra", ""}
        s["quest;reward=11001"] = {"Derrota al Dios Cuervo", ""}
        s["quest;reward=11002"] = {"La caída de Magtheridon", "Península del Fuego Infernal"}
        s["quest;reward=11007"] = {"Kael'thas y la esfera verdeante", ""}
        s["quest;reward=11031"] = {"Ya no es archimago", ""}
        s["quest;reward=11032"] = {"Ya no es protector", "Paso de la Muerte"}
        s["quest;reward=11033"] = {"Ya no es asesino", "Paso de la Muerte"}
        s["quest;reward=11041"] = {"Un trabajo sin terminar...", ""}
        s["quest;reward=11092"] = {"¡Saludos, comandante!", ""}
        s["quest;reward=9120"] = {"La caída de Kel'Thuzad", "Tierras de la Peste del Este"}
        s["quest;reward=9271"] = {"Atiesh, el gran báculo del guardián", "Stratholme"}
        s["quest;reward=9494"] = {"Ascuas viles", ""}
        s["quest;reward=9763"] = {"La guarida del Señor de la Guerra", ""}
        s["quest;reward=9860"] = {"La nueva directiva", ""}
        s["spell;created=17632"] = {"Piedra de alquimista", "CRAFTING"}
        s["spell;created=23537"] = {"Enfurecer", ""}
        s["spell;created=23773"] = {"Sufrimiento de sanidad", ""}
        s["spell;created=23786"] = {"Contraveneno potente", ""}
        s["spell;created=23793"] = {"Fuerza", ""}
        s["spell;created=26752"] = {"Cinturón fuego de hechizo", "CRAFTING"}
        s["spell;created=26753"] = {"Guantes fuego de hechizo", "CRAFTING"}
        s["spell;created=26754"] = {"Toga fuego de hechizo", "CRAFTING"}
        s["spell;created=26756"] = {"Sobrehombros de tejido de sombra congelado", "CRAFTING"}
        s["spell;created=26757"] = {"Botas de tejido de sombra congelado", "CRAFTING"}
        s["spell;created=26758"] = {"Túnica de tejido de sombra congelado", "CRAFTING"}
        s["spell;created=26760"] = {"Cinturón de tela lunar primigenia", "CRAFTING"}
        s["spell;created=26761"] = {"Sobrehombros de tela lunar primigenia", "CRAFTING"}
        s["spell;created=26762"] = {"Toga de tela lunar primigenia", "CRAFTING"}
        s["spell;created=28439"] = {"Crear quintaesencia eterna", ""}
        s["spell;created=29548"] = {"Botas de placas de hierro vil", "CRAFTING"}
        s["spell;created=29606"] = {"Coraza de adamantita", "CRAFTING"}
        s["spell;created=29619"] = {"Guantes de acero vil", "CRAFTING"}
        s["spell;created=29620"] = {"Leotardos de acero vil", "CRAFTING"}
        s["spell;created=29621"] = {"Yelmo de acero vil", "CRAFTING"}
        s["spell;created=29622"] = {"Guanteletes de la Torre de Hierro", "CRAFTING"}
        s["spell;created=29664"] = {"Yelmo de adepto defensor", "CRAFTING"}
        s["spell;created=29668"] = {"Yelmo de El Guardián del Juramento", "CRAFTING"}
        s["spell;created=29671"] = {"Brazales de la Fortaleza Verde", "CRAFTING"}
        s["spell;created=30031"] = {"Desenfreno", "CRAFTING"}
        s["spell;created=30033"] = {"Desenfreno", "CRAFTING"}
        s["spell;created=30036"] = {"Robar magia", "CRAFTING"}
        s["spell;created=30039"] = {"Transferencia", "CRAFTING"}
        s["spell;created=30563"] = {"Lanzacohetes goblin", "CRAFTING"}
        s["spell;created=30569"] = {"Pollotizador gnómico", "CRAFTING"}
        s["spell;created=31060"] = {"Anillo de eternio delicado", "CRAFTING"}
        s["spell;created=31070"] = {"Cadena de eternio trenzada", "CRAFTING"}
        s["spell;created=31079"] = {"Figurilla: jabalí de acero vil", "CRAFTING"}
        s["spell;created=31080"] = {"Figurilla: cangrejo de piedra del alba", "CRAFTING"}
        s["spell;created=31081"] = {"Figurilla: serpiente de rubí vivo", "CRAFTING"}
        s["spell;created=31435"] = {"Brazales del caos", "CRAFTING"}
        s["spell;created=31440"] = {"Capa de eternidad", "CRAFTING"}
        s["spell;created=31443"] = {"Faja de ruina", "CRAFTING"}
        s["spell;created=31448"] = {"Manteo resuelto", "CRAFTING"}
        s["spell;created=31449"] = {"Brazalete de venganza", "CRAFTING"}
        s["spell;created=31452"] = {"Pantalones de golpe de hechizo", "CRAFTING"}
        s["spell;created=31454"] = {"Caperuza con remiendos blancos", "CRAFTING"}
        s["spell;created=31455"] = {"Caperuza de golpe de hechizo", "CRAFTING"}
        s["spell;created=32494"] = {"Leotardos de cuero vil", "CRAFTING"}
        s["spell;created=32495"] = {"Jubón uñagrieta pesado", "CRAFTING"}
        s["spell;created=32497"] = {"Botas uñagrieta pesadas", "CRAFTING"}
        s["spell;created=32499"] = {"Brazal de acechador vil", "CRAFTING"}
        s["spell;created=32756"] = {"Disfraz de las Sombras", ""}
        s["spell;created=32774"] = {"Escudo de vengador", ""}
        s["spell;created=33173"] = {"Polimorfia superior", ""}
        s["spell;created=33803"] = {"Ola de llamas", ""}
        s["spell;created=34534"] = {"Baluarte de reyes", "CRAFTING"}
        s["spell;created=34540"] = {"Campeón corazón de león", "CRAFTING"}
        s["spell;created=34544"] = {"Cortaluna", "CRAFTING"}
        s["spell;created=34546"] = {"Faucedraco", "CRAFTING"}
        s["spell;created=35559"] = {"Guantes de escamas de cobra", "CRAFTING"}
        s["spell;created=35563"] = {"Guantes destripaviento", "CRAFTING"}
        s["spell;created=35576"] = {"Cinturón de escamas abisales de ébano", "CRAFTING"}
        s["spell;created=35577"] = {"Brazales de escamas abisales de ébano", "CRAFTING"}
        s["spell;created=35580"] = {"Coraza de golpe abisal", "CRAFTING"}
        s["spell;created=35582"] = {"Cinturón de golpe abisal", "CRAFTING"}
        s["spell;created=35584"] = {"Brazales de golpe abisal", "CRAFTING"}
        s["spell;created=35585"] = {"Camisote de halcón del viento", "CRAFTING"}
        s["spell;created=35587"] = {"Cinturón de halcón del viento", "CRAFTING"}
        s["spell;created=35588"] = {"Brazales de halcón del viento", "CRAFTING"}
        s["spell;created=35589"] = {"Jubón de golpe primigenio", "CRAFTING"}
        s["spell;created=35591"] = {"Brazales de golpe primigenio", "CRAFTING"}
        s["spell;created=36315"] = {"Cinturón de detonación", "CRAFTING"}
        s["spell;created=36317"] = {"Botas de detonación", "CRAFTING"}
        s["spell;created=36355"] = {"Botas de gracia natural", "CRAFTING"}
        s["spell;created=40744"] = {"Infusión de cristal de ápices", ""}
        s["spell;created=41160"] = {"Sobrehombros Golpeveloz", "CRAFTING"}
        s["spell;created=41161"] = {"Ataduras de reflejos de relámpago", "CRAFTING"}
        s["spell;created=41163"] = {"Ataduras Tierra Viva", "CRAFTING"}
        s["spell;created=41205"] = {"Brazales de pensamiento ágil", "CRAFTING"}
        s["spell;created=41207"] = {"Brazaletes Sanaveloz", "CRAFTING"}
        s["spell;created=42546"] = {"Capa de oscuridad", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationfrFR()
        s["npc;drop=15550"] = {"Attumen le Veneur", "Karazhan"}
        s["npc;drop=15687"] = {"Moroes <Régisseur de la tour>", "Karazhan"}
        s["npc;drop=15688"] = {"Terestian Malsabot", "Karazhan"}
        s["npc;drop=15689"] = {"Dédain-du-Néant", "Karazhan"}
        s["npc;drop=15691"] = {"Le conservateur", "Karazhan"}
        s["npc;drop=15989"] = {"Saphiron", "Naxxramas"}
        s["npc;drop=16011"] = {"Horreb", "Naxxramas"}
        s["npc;drop=16152"] = {"Attumen le Veneur", "Karazhan"}
        s["npc;drop=16179"] = {"Hyakiss la Rôdeuse", "Karazhan"}
        s["npc;drop=16180"] = {"Shadikith le glisseur", "Karazhan"}
        s["npc;drop=16181"] = {"Rodak le ravageur", "Karazhan"}
        s["npc;drop=16411"] = {"Chef spectral", "Karazhan"}
        s["npc;drop=16457"] = {"Damoiselle de vertu", "Karazhan"}
        s["npc;drop=16485"] = {"Veilleur arcanique", "Karazhan"}
        s["npc;drop=16504"] = {"Protecteur arcanique", "Karazhan"}
        s["npc;drop=16524"] = {"Ombre d'Aran", "Karazhan"}
        s["npc;drop=16807"] = {"Grand démoniste Néanathème", "Les Salles brisées"}
        s["npc;drop=16808"] = {"Chef de guerre Kargath Lamepoing", "Les Salles brisées"}
        s["npc;drop=16816"] = {"Echo de Medivh", "Karazhan"}
        s["npc;drop=17225"] = {"Plaie-de-nuit", "Karazhan"}
        s["npc;drop=17257"] = {"Magtheridon", "Le Repaire de Magtheridon"}
        s["npc;drop=17377"] = {"Keli'dan le Briseur", "La Fournaise du Sang"}
        s["npc;drop=17381"] = {"Le Faiseur", "La Fournaise du sang"}
        s["npc;drop=17521"] = {"Le Grand Méchant Loup", "Karazhan"}
        s["npc;drop=17711"] = {"Marche-funeste", "Vallée d'Ombrelune"}
        s["npc;drop=17767"] = {"Rage Froidhiver", "Sommet d'Hyjal"}
        s["npc;drop=17798"] = {"Seigneur de guerre Kalithresh", "Le Caveau de la vapeur"}
        s["npc;drop=17808"] = {"Anetheron", "Sommet d'Hyjal"}
        s["npc;drop=17842"] = {"Azgalor", "Sommet d'Hyjal"}
        s["npc;drop=17848"] = {"Lieutenant Drake", ""}
        s["npc;drop=17879"] = {"Chronoseigneur Déjà", "Le Noir Marécage"}
        s["npc;drop=17880"] = {"Temporus", "Le Noir Marécage"}
        s["npc;drop=17881"] = {"Aeonus", "Le Noir Marécage"}
        s["npc;drop=17882"] = {"La Traqueuse noire", "La Basse-Tourbière"}
        s["npc;drop=17888"] = {"Kaz'rogal", "Sommet d'Hyjal"}
        s["npc;drop=17897"] = {"Démon des cryptes", ""}
        s["npc;drop=17908"] = {"Infernal géant", ""}
        s["npc;drop=17942"] = {"Bourbierreux", "Les enclos aux esclaves"}
        s["npc;drop=17968"] = {"Archimonde", "Sommet d'Hyjal"}
        s["npc;drop=17975"] = {"Grand botaniste Freywinn", ""}
        s["npc;drop=17977"] = {"Brise-dimension", "La Botanica"}
        s["npc;drop=17978"] = {"Rirépine le Tendre", ""}
        s["npc;drop=17980"] = {"Laj", ""}
        s["npc;drop=17991"] = {"Rokmar le Crépitant", "Les Enclos aux Esclaves"}
        s["npc;drop=18093"] = {"Protecteur de Moulin-de-Tarren", ""}
        s["npc;drop=18096"] = {"Chasseur d'époques", "Contreforts de Hautebrande d'antan"}
        s["npc;drop=18105"] = {"Ghaz'an", "La Basse-Tourbière"}
        s["npc;drop=18168"] = {"La Mégère", "Karazhan"}
        s["npc;drop=18341"] = {"Pandemonius", "Tombes-Mana"}
        s["npc;drop=18343"] = {"Tavarok", "Tombes-Mana"}
        s["npc;drop=18344"] = {"Prince-nexus Shaffar", "Tombes-Mana"}
        s["npc;drop=18371"] = {"Shirrak le Veillemort", "Cryptes Auchenaï"}
        s["npc;drop=18373"] = {"Exarque Maladaar", "Cryptes Auchenaï"}
        s["npc;drop=184259"] = {"Seigneur de la Nuit", "Karazhan"}
        s["npc;drop=18472"] = {"Tisseur d'ombre Syth", "Les Salles de Setthek"}
        s["npc;drop=18473"] = {"Roi-serre Ikiss", "Les Salles de Setthek"}
        s["npc;drop=18478"] = {"Avatar des martyrs", "Cryptes Auchenaï"}
        s["npc;drop=18667"] = {"Coeur-noir le Séditieux", "Labyrinthe des ombres"}
        s["npc;drop=18693"] = {"Porte-parole Mar'grom", "Les Tranchantes"}
        s["npc;drop=18697"] = {"Ingénieur en chef Lorthander", "Raz-de-Néant"}
        s["npc;drop=18708"] = {"Marmon", "Labyrinthe des Ombres"}
        s["npc;drop=18728"] = {"Seigneur funeste Kazzak", "Péninsule des Flammes infernales"}
        s["npc;drop=18731"] = {"Ambassadeur Gueule-d'enfer", "Labyrinthe des ombres"}
        s["npc;drop=18805"] = {"Grande astromancienne Solarian", ""}
        s["npc;drop=18831"] = {"Haut Roi Maulgar <Seigneur des ogres>", "Repaire de Gruul"}
        s["npc;drop=19044"] = {"Gruul le Tue-dragon", "Repaire de Gruul"}
        s["npc;drop=19220"] = {"Pathaleon le Calculateur", "Le Méchanar"}
        s["npc;drop=19221"] = {"Néantomancienne Sepethrea", "Le Méchanar"}
        s["npc;drop=19514"] = {"Al'ar <Dieu phénix>", ""}
        s["npc;drop=19516"] = {"Saccageur du Vide", ""}
        s["npc;drop=20035"] = {"Maréchal Garde-sang", "Donjon de la Tempête"}
        s["npc;drop=20036"] = {"Ecuyer garde-sang", "Donjon de la Tempête"}
        s["npc;drop=20042"] = {"Forgeron-Tempête", "Donjon de la Tempête"}
        s["npc;drop=20044"] = {"Astromancien novice", "Donjon de la Tempête"}
        s["npc;drop=20885"] = {"Dalliah l'Auspice-funeste", "L'Arcatraz"}
        s["npc;drop=21212"] = {"Dame Vashj <Matrone de Glissecroc>", "Caverne du Sanctuaire du Serpent"}
        s["npc;drop=21213"] = {"Morogrim Marcheur-des-flots", "Caverne du Sanctuaire du Serpent"}
        s["npc;drop=21214"] = {"Seigneur des fonds Karathress", "Caverne du Sanctuaire du Serpent"}
        s["npc;drop=21215"] = {"Leotheras l'Aveugle", "Caverne du Sanctuaire du Serpent"}
        s["npc;drop=21217"] = {"Le Rôdeur d'En bas", "Caverne du Sanctuaire du Serpent"}
        s["npc;drop=21251"] = {"Colosse de Basse-tourbière", "Caverne du sanctuaire du Serpent"}
        s["npc;drop=21466"] = {"Messager Cieuriss", "L'Arcatraz"}
        s["npc;drop=21838"] = {"Terokk", "Forêt de Terokkar"}
        s["npc;drop=21845"] = {"Leotheras l'Aveugle", ""}
        s["npc;drop=21932"] = {"Hydross l'Instable <Duc des courants>", ""}
        s["npc;drop=22052"] = {"Cuir-noir Crocs-lames", "Les Tranchantes"}
        s["npc;drop=22841"] = {"Ombre d'Akama", "Temple Noir"}
        s["npc;drop=22845"] = {"Mystique cendrelangue", "Temple noir"}
        s["npc;drop=22871"] = {"Teron Fielsang", "Temple Noir"}
        s["npc;drop=22884"] = {"Léviathan", "Temple noir"}
        s["npc;drop=22898"] = {"Supremus", "Temple Noir"}
        s["npc;drop=22917"] = {"Illidan Hurlorage <Le Traître>", "Temple Noir"}
        s["npc;drop=22930"] = {"Yor <Molosse du Vide de Shaffar>", "Tombes-Mana"}
        s["npc;drop=22947"] = {"Mère Shahraz", "Temple Noir"}
        s["npc;drop=22948"] = {"Gurtogg Fièvresang", "Temple Noir"}
        s["npc;drop=22950"] = {"Grand néantomancien Zerevor", "Temple noir"}
        s["npc;drop=23054"] = {"Kael'thas Haut-soleil <Seigneur des elfes de sang>", "Shattrath"}
        s["npc;drop=23236"] = {"Disciple du bouclier Mâche-les-os", "Temple noir"}
        s["npc;drop=23281"] = {"Insidion", "Les Tranchantes"}
        s["npc;drop=23282"] = {"Obsidia", "Les Tranchantes"}
        s["npc;drop=23374"] = {"Traqueur cendrelangue", "Temple noir"}
        s["npc;drop=23397"] = {"Seigneur de sang illidari", "Temple noir"}
        s["npc;drop=23402"] = {"Mage de bataille illidari", "Temple noir"}
        s["npc;drop=23420"] = {"Essence de la colère", "Temple Noir"}
        s["npc;drop=23774"] = {"Entraîneur amani'shi", ""}
        s["npc;drop=23872"] = {"Coren Navrebière", "Profondeurs de Rochenoire"}
        s["npc;sold=12777"] = {"Capitaine Mornemartel <Intendant des armures>", "Vallée d'Alterac"}
        s["npc;sold=12781"] = {"Sergent-chef Socquet <Officier Intendant des accessoires>", "Hurlevent"}
        s["npc;sold=12792"] = {"Dame Palanseer <Intendant des armures>", "Bassin d'Arathi"}
        s["npc;sold=17585"] = {"Intendant Urgronn <Intendant de Thrallmar>", "Péninsule des Flammes infernales"}
        s["npc;sold=17657"] = {"Officier de logistique Ulrike <Intendante du bastion de l'Honneur>", "Péninsule des Flammes infernales"}
        s["npc;sold=17904"] = {"Fedryen Vivelance <Intendant de l'Expédition cénarienne>", "Marécage de Zangar"}
        s["npc;sold=18525"] = {"G'eras", "Shattrath"}
        s["npc;sold=18898"] = {"Explodyne Scintegicle <Vendeuse de l'arène>", "Nagrand"}
        s["npc;sold=19321"] = {"Intendant Endarin <Aldor : Intendance>", "Shattrath"}
        s["npc;sold=19331"] = {"Intendant Enuril <Clairvoyants : Intendance>", "Shattrath"}
        s["npc;sold=19536"] = {"Camelot Jadyan <Armes exotiques>", "Raz-de-Néant"}
        s["npc;sold=19772"] = {"Sage esprit Gartok", "Forêt de Terokkar"}
        s["npc;sold=20278"] = {"Vixton Sifflepince <Vendeur de l'arène>", "Raz-de-Néant"}
        s["npc;sold=20613"] = {"Arodis Lamesoleil <Gardien des artefacts sha'tari>", "Shattrath"}
        s["npc;sold=20616"] = {"Asuur <Gardien des artefacts sha'tari>", "Shattrath"}
        s["npc;sold=21432"] = {"Almaador <Intendant Sha'tari>", "Shattrath"}
        s["npc;sold=21643"] = {"Alurmi <Intendant des gardiens du Temps>", "Tanaris"}
        s["npc;sold=21655"] = {"Nakodu <Intendant de la Ville basse>", "Shattrath"}
        s["npc;sold=21905"] = {"Veynna Aubétoile <Gardienne des héritages sha'tari>", "Shattrath"}
        s["npc;sold=21906"] = {"Kelara <Gardienne des héritages sha'tari>", "Shattrath"}
        s["npc;sold=23159"] = {"Okuno <Intendant des ligemorts cendrelangue>", "Temple noir"}
        s["npc;sold=23381"] = {"Tydormu <Gardien des artefacts perdus>", ""}
        s["npc;sold=23428"] = {"Jho'nass <Intendant d'Ogri'la>", "Les Tranchantes"}
        s["npc;sold=25176"] = {"Grikkin Cuivressort <Vendeur de l'arène>", "Nagrand"}
        s["npc;sold=26089"] = {"Kayri <Fourniture de matériel exotique>", "Île de Quel'Danas"}
        s["npc;sold=27668"] = {"Ontok Brise-corne <Vendeur de l'arène>", "Shattrath"}
        s["npc;sold=3523"] = {"Bowen Brisboise <Maître des tailleurs>", "Clairières de Tirisfal"}
        s["npc;sold=3703"] = {"Krulmoo Pleine-lune <Maître des travailleurs du cuir>", "Les Tarides"}
        s["object;contained=184465"] = {"Cache de la Légion", "Le Méchanar"}
        s["object;contained=185119"] = {"Coffre couvert de poussière", "Karazhan"}
        s["object;contained=185169"] = {"Coffre en gangrefer renforcé", "Remparts des Flammes infernales"}
        s["object;contained=185584"] = {"Epine dorsale de Naj'entus", "Temple noir"}
        s["quest;reward=10011"] = {"Le camp de forge Anéanti", ""}
        s["quest;reward=10091"] = {"Les machines à âmes", ""}
        s["quest;reward=10136"] = {"Les Liaisons cruelles", ""}
        s["quest;reward=10176"] = {"Ar'kelos le Gardien", ""}
        s["quest;reward=10185"] = {"Un sort pire que la mort", ""}
        s["quest;reward=10188"] = {"Le glyphe de Krasus", ""}
        s["quest;reward=10280"] = {"Livraison spéciale à Shattrath", "Raz-de-Néant"}
        s["quest;reward=10298"] = {"Héros de la progéniture", ""}
        s["quest;reward=10320"] = {"Détruisez Naberius !", ""}
        s["quest;reward=10323"] = {"Extinction de la manaforge Ara", ""}
        s["quest;reward=10337"] = {"Marguerite rentre au pays", ""}
        s["quest;reward=10345"] = {"La chair ment...", ""}
        s["quest;reward=10353"] = {"Arconus l'Insatiable", ""}
        s["quest;reward=10365"] = {"Extinction de la manaforge Ara", ""}
        s["quest;reward=10381"] = {"L'Aldor c'est mort", ""}
        s["quest;reward=10400"] = {"Suzerain", ""}
        s["quest;reward=10409"] = {"Un coup fatal à la Légion", ""}
        s["quest;reward=10425"] = {"L'évasion du lieu de rassemblement", ""}
        s["quest;reward=10439"] = {"Dimensius l'Omni-dévoreur", ""}
        s["quest;reward=10460"] = {"Le serment du défenseur", ""}
        s["quest;reward=10462"] = {"Le serment du champion", ""}
        s["quest;reward=10463"] = {"Le serment du sage", ""}
        s["quest;reward=10472"] = {"L'engagement du sage", ""}
        s["quest;reward=10473"] = {"L'engagement du guérisseur", ""}
        s["quest;reward=10474"] = {"L'engagement du champion", ""}
        s["quest;reward=10507"] = {"Un moment décisif", ""}
        s["quest;reward=10579"] = {"La Formule de damnation - Troisième fragment retrouvé", ""}
        s["quest;reward=10645"] = {"Teron Fielsang, je suis...", ""}
        s["quest;reward=10704"] = {"Comment pénétrer dans l'Arcatraz", ""}
        s["quest;reward=10728"] = {"L'excellence auprès de l'Œil pourpre", ""}
        s["quest;reward=10745"] = {"Des nouvelles de la victoire", ""}
        s["quest;reward=10769"] = {"De la dissension dans les rangs...", ""}
        s["quest;reward=10781"] = {"La bataille du Guet cramoisi", ""}
        s["quest;reward=10806"] = {"Cartes sur table", "Les Tranchantes"}
        s["quest;reward=10912"] = {"Le maître-chien", ""}
        s["quest;reward=10938"] = {"Suite de Bénédictions de Sombrelune", ""}
        s["quest;reward=10940"] = {"Suite de Furies de Sombrelune", ""}
        s["quest;reward=10941"] = {"Suite de Déraison de Sombrelune", ""}
        s["quest;reward=11001"] = {"Triompher du dieu corbeau", ""}
        s["quest;reward=11002"] = {"La chute de Magtheridon", "Péninsule des Flammes infernales"}
        s["quest;reward=11007"] = {"Kael'thas et la sphère verdoyante", ""}
        s["quest;reward=11031"] = {"Quitter la voie de l'archimage", ""}
        s["quest;reward=11032"] = {"Quitter la voie du protecteur", "Défilé de Deuillevent"}
        s["quest;reward=11033"] = {"Quitter la voie de l'assassin", "Défilé de Deuillevent"}
        s["quest;reward=11041"] = {"Un travail à terminer...", ""}
        s["quest;reward=11092"] = {"Salut, commandant !", ""}
        s["quest;reward=9120"] = {"La chute de Kel'Thuzad", "Maleterres de l'est"}
        s["quest;reward=9271"] = {"Atiesh, le grand bâton du Gardien", "Stratholme"}
        s["quest;reward=9494"] = {"Les gangrebraises", ""}
        s["quest;reward=9763"] = {"Le repaire du seigneur de guerre", ""}
        s["quest;reward=9860"] = {"La nouvelle directive", ""}
        s["spell;created=17632"] = {"Pierre d'alchimiste", "CRAFTING"}
        s["spell;created=23537"] = {"Enrager", ""}
        s["spell;created=23773"] = {"Santé mentale affaiblie", ""}
        s["spell;created=23786"] = {"Anti-venin puissant", ""}
        s["spell;created=23793"] = {"Force", ""}
        s["spell;created=26752"] = {"Ceinture du feu-sorcier", "CRAFTING"}
        s["spell;created=26753"] = {"Gants du feu-sorcier", "CRAFTING"}
        s["spell;created=26754"] = {"Robe du feu-sorcier", "CRAFTING"}
        s["spell;created=26756"] = {"Epaulières en tisse-ombre gelé", "CRAFTING"}
        s["spell;created=26757"] = {"Bottes en tisse-ombre gelé", "CRAFTING"}
        s["spell;created=26758"] = {"Robe en tisse-ombre gelé", "CRAFTING"}
        s["spell;created=26760"] = {"Ceinture d'étoffe lunaire primordiale", "CRAFTING"}
        s["spell;created=26761"] = {"Epaulières d'étoffe lunaire primordiale", "CRAFTING"}
        s["spell;created=26762"] = {"Robe d'étoffe lunaire primordiale", "CRAFTING"}
        s["spell;created=28439"] = {"Créer la Quintessence éternelle", ""}
        s["spell;created=29548"] = {"Bottes en plaques de gangrefer", "CRAFTING"}
        s["spell;created=29606"] = {"Cuirasse en adamantite", "CRAFTING"}
        s["spell;created=29619"] = {"Gants en gangracier", "CRAFTING"}
        s["spell;created=29620"] = {"Jambières en gangracier", "CRAFTING"}
        s["spell;created=29621"] = {"Casque en gangracier", "CRAFTING"}
        s["spell;created=29622"] = {"Gantelets de la Tour de fer", "CRAFTING"}
        s["spell;created=29664"] = {"Heaume du fidèle défenseur", "CRAFTING"}
        s["spell;created=29668"] = {"Casque de la parole donnée", "CRAFTING"}
        s["spell;created=29671"] = {"Brassards de la forteresse verte", "CRAFTING"}
        s["spell;created=30031"] = {"Saccager", "CRAFTING"}
        s["spell;created=30033"] = {"Saccager", "CRAFTING"}
        s["spell;created=30036"] = {"Vol de magie", "CRAFTING"}
        s["spell;created=30039"] = {"Redirection", "CRAFTING"}
        s["spell;created=30563"] = {"Lance-roquettes gobelin", "CRAFTING"}
        s["spell;created=30569"] = {"Pouletisateur gnome", "CRAFTING"}
        s["spell;created=31060"] = {"Anneau délicat en éternium", "CRAFTING"}
        s["spell;created=31070"] = {"Chaîne en éternium tressé", "CRAFTING"}
        s["spell;created=31079"] = {"Figurine - Sanglier en gangracier", "CRAFTING"}
        s["spell;created=31080"] = {"Figurine - Crabe de pierre d'aube", "CRAFTING"}
        s["spell;created=31081"] = {"Figurine - Serpent de rubis vivant", "CRAFTING"}
        s["spell;created=31435"] = {"Brassards de Sans-quartier", "CRAFTING"}
        s["spell;created=31440"] = {"Cape d'éternité", "CRAFTING"}
        s["spell;created=31443"] = {"Ceinturon de saccage", "CRAFTING"}
        s["spell;created=31448"] = {"Cape résolue", "CRAFTING"}
        s["spell;created=31449"] = {"Houppelande vengeresse", "CRAFTING"}
        s["spell;created=31452"] = {"Pantalon frappe-sort", "CRAFTING"}
        s["spell;created=31454"] = {"Chaperon de la blanche guérison", "CRAFTING"}
        s["spell;created=31455"] = {"Chaperon frappe-sort", "CRAFTING"}
        s["spell;created=32494"] = {"Jambières en gangrecuir", "CRAFTING"}
        s["spell;created=32495"] = {"Gilet du sabot-fourchu épais", "CRAFTING"}
        s["spell;created=32497"] = {"Bottes du sabot-fourchu épaisses", "CRAFTING"}
        s["spell;created=32499"] = {"Brassards de traqueur gangrené", "CRAFTING"}
        s["spell;created=32756"] = {"Déguisement ténébreux", ""}
        s["spell;created=32774"] = {"Bouclier du vengeur", ""}
        s["spell;created=33173"] = {"Métamorphose supérieure", ""}
        s["spell;created=33803"] = {"Vague de flammes", ""}
        s["spell;created=34534"] = {"Rempart des rois", "CRAFTING"}
        s["spell;created=34540"] = {"Championne Coeur-de-lion", "CRAFTING"}
        s["spell;created=34544"] = {"Tranchelune", "CRAFTING"}
        s["spell;created=34546"] = {"Gueule-de-dragon", "CRAFTING"}
        s["spell;created=35559"] = {"Gants en écailles de cobra", "CRAFTING"}
        s["spell;created=35563"] = {"Protège-mains de tueur du vent", "CRAFTING"}
        s["spell;created=35576"] = {"Ceinture d'ébène en écailles du Néant", "CRAFTING"}
        s["spell;created=35577"] = {"Brassards d'ébène en écailles du Néant", "CRAFTING"}
        s["spell;created=35580"] = {"Cuirasse Coup-de-Néant", "CRAFTING"}
        s["spell;created=35582"] = {"Ceinture Coup-de-Néant", "CRAFTING"}
        s["spell;created=35584"] = {"Brassards Coup-de-Néant", "CRAFTING"}
        s["spell;created=35585"] = {"Haubert Faucon-du-vent", "CRAFTING"}
        s["spell;created=35587"] = {"Ceinture Faucon-du-vent", "CRAFTING"}
        s["spell;created=35588"] = {"Brassards Faucon-du-vent", "CRAFTING"}
        s["spell;created=35589"] = {"Gilet de frappe primordiale", "CRAFTING"}
        s["spell;created=35591"] = {"Brassards de frappe primordiale", "CRAFTING"}
        s["spell;created=36315"] = {"Ceinture d'explosion", "CRAFTING"}
        s["spell;created=36317"] = {"Bottes d'explosion", "CRAFTING"}
        s["spell;created=36355"] = {"Bottes de grâce naturelle", "CRAFTING"}
        s["spell;created=40744"] = {"Imprégnation aux cristaux apogides", ""}
        s["spell;created=41160"] = {"Epaulières de frappe rapide", "CRAFTING"}
        s["spell;created=41161"] = {"Manchettes des réflexes éclairs", "CRAFTING"}
        s["spell;created=41163"] = {"Manchettes de la terre vivante", "CRAFTING"}
        s["spell;created=41205"] = {"Brassards de la pensée agile", "CRAFTING"}
        s["spell;created=41207"] = {"Couvre-bras des soins vifs", "CRAFTING"}
        s["spell;created=42546"] = {"Cape des ténèbres", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationitIT()
        s["npc;drop=15687"] = {"Moroes <Tower Steward>", "Karazhan"}
        s["npc;drop=18805"] = {"High Astromancer Solarian", "Tempest Keep"}
        s["npc;drop=18831"] = {"High King Maulgar <Lord of the Ogres>", "Gruul's Lair"}
        s["npc;drop=19514"] = {"Al'ar <Phoenix God>", "Tempest Keep"}
        s["npc;drop=19516"] = {"Void Reaver", "Tempest Keep"}
        s["npc;drop=23774"] = {"Amani'shi Trainer", ""}
        s["npc;sold=12792"] = {"Lady Palanseer <Armor Quartermaster>", "Alterac Valley"}
        s["npc;sold=17585"] = {"Quartermaster Urgronn <Thrallmar Quartermaster>", "Hellfire Peninsula"}
        s["npc;sold=17657"] = {"Logistics Officer Ulrike <Honor Hold Quartermaster>", "Hellfire Peninsula"}
        s["npc;sold=17904"] = {"Fedryen Swiftspear <Cenarion Expedition Quartermaster>", "Zangarmarsh"}
        s["npc;sold=20613"] = {"Arodis Sunblade <Keeper of Sha'tari Artifacts>", "Shattrath City"}
        s["npc;sold=21643"] = {"Alurmi <Keepers of Time Quartermaster>", "Tanaris"}
        s["npc;sold=25176"] = {"Grikkin Copperspring <Arena Vendor>", "Nagrand"}
        s["quest;reward=10280"] = {"Special Delivery to Shattrath City", "Netherstorm"}
        s["quest;reward=10806"] = {"Showdown", "Blade's Edge Mountains"}
        s["quest;reward=11002"] = {"The Fall of Magtheridon", "Hellfire Peninsula"}
        s["quest;reward=11032"] = {"Protector No More", "Deadwind Pass"}
        s["quest;reward=11033"] = {"Assassin No More", "Deadwind Pass"}
        s["quest;reward=9120"] = {"The Fall of Kel'Thuzad", "Eastern Plaguelands"}
        s["quest;reward=9271"] = {"Atiesh, Greatstaff of the Guardian", "Stratholme"}
    end

    function SpecBisTooltip:TranslationkoKR()
        s["npc;drop=15550"] = {"사냥꾼 어튜멘", "카라잔"}
        s["npc;drop=15687"] = {"모로스 <집사>", "카라잔"}
        s["npc;drop=15688"] = {"테레스티안 일후프", "카라잔"}
        s["npc;drop=15689"] = {"황천의 원령", "카라잔"}
        s["npc;drop=15690"] = {"공작 말체자르", "카라잔"}
        s["npc;drop=15691"] = {"전시 관리인", "카라잔"}
        s["npc;drop=15989"] = {"사피론", "낙스라마스"}
        s["npc;drop=16011"] = {"로데브", "낙스라마스"}
        s["npc;drop=16152"] = {"사냥꾼 어튜멘", "카라잔"}
        s["npc;drop=16179"] = {"잠복꾼 히아키스", "카라잔"}
        s["npc;drop=16180"] = {"활강의 샤디키스", "카라잔"}
        s["npc;drop=16181"] = {"파괴자 로카드", "카라잔"}
        s["npc;drop=16411"] = {"유령 주방장", "카라잔"}
        s["npc;drop=16457"] = {"고결의 여신", "카라잔"}
        s["npc;drop=16485"] = {"비전 보초", "카라잔"}
        s["npc;drop=16504"] = {"비전 파수병", "카라잔"}
        s["npc;drop=16524"] = {"아란의 망령", "카라잔"}
        s["npc;drop=16807"] = {"대흑마법사 네더쿠르스", "으스러진 손의 전당"}
        s["npc;drop=16808"] = {"대족장 카르가스 블레이드피스트", "으스러진 손의 전당"}
        s["npc;drop=16816"] = {"메디브의 메아리", "카라잔"}
        s["npc;drop=17225"] = {"파멸의 어둠", "카라잔"}
        s["npc;drop=17257"] = {"마그테리돈", "마그테리돈의 둥지"}
        s["npc;drop=17377"] = {"파괴자 켈리단", "피의 용광로"}
        s["npc;drop=17381"] = {"재앙의 창조자", "피의 용광로"}
        s["npc;drop=17521"] = {"커다란 나쁜 늑대", "카라잔"}
        s["npc;drop=17533"] = {"로밀로", "카라잔"}
        s["npc;drop=17534"] = {"줄리엔", "카라잔"}
        s["npc;drop=17711"] = {"파멸의 절단기", "어둠달 골짜기"}
        s["npc;drop=17767"] = {"격노한 윈터칠", "하이잘 정상"}
        s["npc;drop=17798"] = {"장군 칼리스레쉬", "증기 저장고"}
        s["npc;drop=17808"] = {"아네테론", "하이잘 정상"}
        s["npc;drop=17842"] = {"아즈갈로", "하이잘 정상"}
        s["npc;drop=17848"] = {"부관 드레이크", "옛 힐스브래드 구릉지"}
        s["npc;drop=17879"] = {"시간의 군주 데자", "검은늪"}
        s["npc;drop=17880"] = {"템퍼루스", "검은늪"}
        s["npc;drop=17881"] = {"아에누스", "검은늪"}
        s["npc;drop=17882"] = {"검은 추적자", "지하수렁"}
        s["npc;drop=17888"] = {"카즈로갈", "하이잘 정상"}
        s["npc;drop=17897"] = {"지하마귀", ""}
        s["npc;drop=17898"] = {"누더기골렘", ""}
        s["npc;drop=17908"] = {"거대한 지옥불정령", ""}
        s["npc;drop=17942"] = {"쿠아그미란", "강제 노역소"}
        s["npc;drop=17968"] = {"아키몬드", "하이잘 정상"}
        s["npc;drop=17975"] = {"고위 식물학자 프레이윈", "신록의 정원"}
        s["npc;drop=17977"] = {"차원의 분리자", "신록의 정원"}
        s["npc;drop=17978"] = {"감시인 쏜그린", "신록의 정원"}
        s["npc;drop=17980"] = {"라즈", "신록의 정원"}
        s["npc;drop=17991"] = {"딱딱이 로크마르", "강제 노역소"}
        s["npc;drop=18093"] = {"타렌 밀농장 민병대원", ""}
        s["npc;drop=18096"] = {"시대의 사냥꾼", "옛 힐스브래드 구릉지"}
        s["npc;drop=18105"] = {"가즈안", "지하수렁"}
        s["npc;drop=18168"] = {"마녀", "카라잔"}
        s["npc;drop=18341"] = {"팬더모니우스", "마나 무덤"}
        s["npc;drop=18343"] = {"타바로크", "마나 무덤"}
        s["npc;drop=18344"] = {"연합왕자 샤파르", "마나 무덤"}
        s["npc;drop=18371"] = {"죽음의 감시인 쉴라크", "아키나이 납골당"}
        s["npc;drop=18373"] = {"총독 말라다르", "아키나이 납골당"}
        s["npc;drop=184259"] = {"밤의 군주", "카라잔"}
        s["npc;drop=18472"] = {"흑마술사 시스", "세데크 전당"}
        s["npc;drop=18473"] = {"갈퀴대왕 이키스", "세데크 전당"}
        s["npc;drop=18478"] = {"순교자의 화신", "아키나이 납골당"}
        s["npc;drop=18667"] = {"선동자 검은심장", "어둠의 미궁"}
        s["npc;drop=18693"] = {"연설가 마르그롬", "칼날 산맥"}
        s["npc;drop=18697"] = {"선임기술자 노산더", "황천의 폭풍"}
        s["npc;drop=18708"] = {"울림", "어둠의 미궁"}
        s["npc;drop=18728"] = {"파멸의 군주 카자크", "지옥불 반도"}
        s["npc;drop=18731"] = {"사자 지옥아귀", "어둠의 미궁"}
        s["npc;drop=18805"] = {"고위 점성술사 솔라리안", "폭풍우 요새"}
        s["npc;drop=18831"] = {"왕중왕 마울가르 <오우거 군주>", "그룰의 둥지"}
        s["npc;drop=19044"] = {"용 학살자 그룰", "그룰의 둥지"}
        s["npc;drop=19220"] = {"철두철미한 파탈리온", "메카나르"}
        s["npc;drop=19221"] = {"황천술사 세페스레아", "메카나르"}
        s["npc;drop=19514"] = {"알라르 <불사조 신>", "폭풍우 요새"}
        s["npc;drop=19516"] = {"공허의 절단기", "폭풍우 요새"}
        s["npc;drop=20035"] = {"붉은경비대 대장", "폭풍우 요새"}
        s["npc;drop=20036"] = {"붉은경비대 기사", "폭풍우 요새"}
        s["npc;drop=20042"] = {"폭풍우 대장장이", "폭풍우 요새"}
        s["npc;drop=20044"] = {"수습 점성술사", "폭풍우 요새"}
        s["npc;drop=20885"] = {"파멸의 예언자 달리아", "알카트라즈"}
        s["npc;drop=21174"] = {"마그테리돈", ""}
        s["npc;drop=21212"] = {"여군주 바쉬 <갈퀴송곳니 여군주>", "불뱀 제단"}
        s["npc;drop=21213"] = {"겅둥파도 모로그림", "불뱀 제단"}
        s["npc;drop=21214"] = {"심연의 군주 카라드레스", "불뱀 제단"}
        s["npc;drop=21215"] = {"눈먼 레오테라스", "불뱀 제단"}
        s["npc;drop=21217"] = {"심연의 잠복꾼", "불뱀 제단"}
        s["npc;drop=21251"] = {"지하수렁 거대괴수", "불뱀 제단"}
        s["npc;drop=21466"] = {"선구자 스키리스", "알카트라즈"}
        s["npc;drop=21838"] = {"테로크", "테로카르 숲"}
        s["npc;drop=21845"] = {"눈먼 레오테라스", ""}
        s["npc;drop=21932"] = {"불안정한 히드로스 <해일의 군주>", ""}
        s["npc;drop=22052"] = {"검은가죽 비수아귀랩터", "칼날 산맥"}
        s["npc;drop=22841"] = {"아카마의 망령", "검은 사원"}
        s["npc;drop=22845"] = {"잿빛혓바닥 비술사", "검은 사원"}
        s["npc;drop=22871"] = {"테론 고어핀드", "검은 사원"}
        s["npc;drop=22884"] = {"거대괴수", "검은 사원"}
        s["npc;drop=22898"] = {"궁극의 심연", "검은 사원"}
        s["npc;drop=22917"] = {"일리단 스톰레이지 <배신자>", "검은 사원"}
        s["npc;drop=22930"] = {"요르 <샤파르의 사냥개>", "마나 무덤"}
        s["npc;drop=22947"] = {"대모 샤라즈", "검은 사원"}
        s["npc;drop=22948"] = {"구르토그 블러드보일", "검은 사원"}
        s["npc;drop=22950"] = {"고위 황천술사 제레보르", "검은 사원"}
        s["npc;drop=23054"] = {"캘타스 선스트라이더 <블러드 엘프 군주>", "샤트라스"}
        s["npc;drop=23236"] = {"해골이빨 방패 신도", "검은 사원"}
        s["npc;drop=23281"] = {"인시디온", "칼날 산맥"}
        s["npc;drop=23282"] = {"옵시디아", "칼날 산맥"}
        s["npc;drop=23374"] = {"잿빛혓바닥 추적자", "검은 사원"}
        s["npc;drop=23397"] = {"일리다리 혈군주", "검은 사원"}
        s["npc;drop=23402"] = {"일리다리 전투마법사", "검은 사원"}
        s["npc;drop=23420"] = {"격노의 정수", "검은 사원"}
        s["npc;drop=23774"] = {"아마니쉬 조련사", ""}
        s["npc;drop=23872"] = {"코렌 다이어브루", "검은바위 나락"}
        s["npc;sold=12777"] = {"대장 더지해머 <방어구 병참장교>", "알터랙 계곡"}
        s["npc;sold=12781"] = {"하사관 비긴스 <장교용 장신구 병참장교>", "스톰윈드"}
        s["npc;sold=12792"] = {"여군주 팔란시어 <방어구 병참장교>", "아라시 분지"}
        s["npc;sold=17585"] = {"병참장교 울그론 <스랄마 병참장교>", "지옥불 반도"}
        s["npc;sold=17657"] = {"병참장교 울리케 <명예의 요새 병참장교>", "지옥불 반도"}
        s["npc;sold=17904"] = {"페드리엔 스위프트스피어 <세나리온 원정대 병참장교>", "장가르 습지대"}
        s["npc;sold=18525"] = {"게라스", "샤트라스"}
        s["npc;sold=18898"] = {"익스플로디네 피즐스퍼트 <투기장 상인>", "나그란드"}
        s["npc;sold=19321"] = {"병참장교 엔다린 <알도르 사제회 병참장교>", "샤트라스"}
        s["npc;sold=19331"] = {"병참장교 에누릴 <점술가 길드 병참장교>", "샤트라스"}
        s["npc;sold=19536"] = {"무역업자 야디안 <진귀한 무기 상인>", "황천의 폭풍"}
        s["npc;sold=19772"] = {"영혼의 현자 가르톡", "테로카르 숲"}
        s["npc;sold=20278"] = {"빅스톤 핀치휘슬 <투기장 상인>", "황천의 폭풍"}
        s["npc;sold=20613"] = {"아로디스 선블레이드 <샤타리 유물의 수호자>", "샤트라스"}
        s["npc;sold=20616"] = {"아수르 <샤타리 유물의 수호자>", "샤트라스"}
        s["npc;sold=21432"] = {"알마도르 <샤타리 병참장교>", "샤트라스"}
        s["npc;sold=21643"] = {"알룰미 <시간의 수호자 병참장교>", "타나리스"}
        s["npc;sold=21655"] = {"나코두 <고난의 거리 병참장교>", "샤트라스"}
        s["npc;sold=21905"] = {"베인나 돈스타 <샤타리 가보의 수호자>", "샤트라스"}
        s["npc;sold=21906"] = {"켈라라 <샤타리 가보의 수호자>", "샤트라스"}
        s["npc;sold=23159"] = {"오쿠노 <잿빛혓바닥 결사단 병참장교>", "검은 사원"}
        s["npc;sold=23381"] = {"타이도르무 <잃어버린 유물의 수호자>", ""}
        s["npc;sold=23428"] = {"조나쉬 <오그릴라 병참장교>", "칼날 산맥"}
        s["npc;sold=25176"] = {"그리킨 코퍼스프링 <투기장 상인>", "나그란드"}
        s["npc;sold=26089"] = {"케이리 <특수 장비 상인>", "쿠엘다나스 섬"}
        s["npc;sold=27668"] = {"온토크 쉐터혼 <투기장 상인>", "샤트라스"}
        s["npc;sold=3523"] = {"보웬 브리스부아즈 <전문 재봉사>", "티리스팔 숲"}
        s["npc;sold=3703"] = {"크룰무 풀문 <전문 가죽세공인>", "불모의 땅"}
        s["object;contained=184465"] = {"군단 저장고", "메카나르"}
        s["object;contained=185119"] = {"먼지투성이 궤짝", "카라잔"}
        s["object;contained=185169"] = {"강화된 지옥무쇠 궤짝", "지옥불 성루"}
        s["object;contained=185584"] = {"나젠투스 돌기", "검은 사원"}
        s["quest;reward=10011"] = {"괴철로 기지 섬멸", ""}
        s["quest;reward=10091"] = {"영혼의 장치", ""}
        s["quest;reward=10136"] = {"가차없는 처단", ""}
        s["quest;reward=10176"] = {"수호자 알켈로스", ""}
        s["quest;reward=10185"] = {"죽음보다 더한 운명", ""}
        s["quest;reward=10188"] = {"크라서스의 인장", ""}
        s["quest;reward=10280"] = {"샤트라스로 특별 배달", "황천의 폭풍"}
        s["quest;reward=10298"] = {"종족의 영웅", ""}
        s["quest;reward=10320"] = {"나베리우스 처치!", ""}
        s["quest;reward=10323"] = {"아라 마나괴철로 차단", ""}
        s["quest;reward=10337"] = {"집으로 돌아온 소", ""}
        s["quest;reward=10345"] = {"누워 있는 시체들", ""}
        s["quest;reward=10353"] = {"탐욕의 아르코누스", ""}
        s["quest;reward=10365"] = {"아라 마나괴철로 차단", ""}
        s["quest;reward=10381"] = {"알도르여 안녕히...", ""}
        s["quest;reward=10400"] = {"불타는 군단 군주", ""}
        s["quest;reward=10409"] = {"불타는 군단을 향한 치명타", ""}
        s["quest;reward=10425"] = {"작전 지역 탈출", ""}
        s["quest;reward=10439"] = {"만물의 포식자 디멘시우스", ""}
        s["quest;reward=10460"] = {"수호자의 약속", ""}
        s["quest;reward=10462"] = {"용사의 약속", ""}
        s["quest;reward=10463"] = {"현자의 약속", ""}
        s["quest;reward=10472"] = {"현자의 맹약", ""}
        s["quest;reward=10473"] = {"구원자의 맹약", ""}
        s["quest;reward=10474"] = {"용사의 맹약", ""}
        s["quest;reward=10507"] = {"전세 역전", ""}
        s["quest;reward=10579"] = {"파멸의 암호 - 세 번째 조각 입수", ""}
        s["quest;reward=10645"] = {"테론 고어핀드의 정체", ""}
        s["quest;reward=10704"] = {"알카트라즈에 잠입하는 방법", ""}
        s["quest;reward=10728"] = {"보랏빛 수호자로서의 명성", ""}
        s["quest;reward=10745"] = {"승리의 소식", ""}
        s["quest;reward=10769"] = {"이간질...", ""}
        s["quest;reward=10781"] = {"붉은 감시초소 대전", ""}
        s["quest;reward=10806"] = {"최후의 대결", "칼날 산맥"}
        s["quest;reward=10912"] = {"사냥개군주 바엘몬", ""}
        s["quest;reward=10938"] = {"다크문 축복 카드 한벌", ""}
        s["quest;reward=10940"] = {"다크문 원한 카드 한벌", ""}
        s["quest;reward=10941"] = {"다크문 열광 카드 한벌", ""}
        s["quest;reward=11001"] = {"무찌르자, 까마귀 신!", ""}
        s["quest;reward=11002"] = {"마그테리돈의 죽음", "지옥불 반도"}
        s["quest;reward=11007"] = {"캘타스와 신록의 구슬", ""}
        s["quest;reward=11031"] = {"대마법사의 길 포기", ""}
        s["quest;reward=11032"] = {"위대한 수호자의 길 포기", "죽음의 고개"}
        s["quest;reward=11033"] = {"일급 암살자의 길 포기", "죽음의 고개"}
        s["quest;reward=11041"] = {"끝나지 않은 임무...", ""}
        s["quest;reward=11092"] = {"지휘관이여!", ""}
        s["quest;reward=9120"] = {"켈투자드의 죽음", "동부 역병지대"}
        s["quest;reward=9271"] = {"아티쉬, 수호자의 지팡이", "스트라솔름"}
        s["quest;reward=9494"] = {"지옥의 불씨", ""}
        s["quest;reward=9763"] = {"장군의 은신처", ""}
        s["quest;reward=9860"] = {"새로운 지령", ""}
        s["spell;created=17632"] = {"연금술사의 돌", "CRAFTING"}
        s["spell;created=23537"] = {"격노", ""}
        s["spell;created=23773"] = {"이성의 고통", ""}
        s["spell;created=23786"] = {"강력한 해독제", ""}
        s["spell;created=23793"] = {"힘", ""}
        s["spell;created=26752"] = {"마법불꽃 허리띠", "CRAFTING"}
        s["spell;created=26753"] = {"마법불꽃 장갑", "CRAFTING"}
        s["spell;created=26754"] = {"마법불꽃 로브", "CRAFTING"}
        s["spell;created=26756"] = {"얼어붙은 그림자매듭 어깨보호구", "CRAFTING"}
        s["spell;created=26757"] = {"얼어붙은 그림자매듭 장화", "CRAFTING"}
        s["spell;created=26758"] = {"얼어붙은 그림자매듭 로브", "CRAFTING"}
        s["spell;created=26760"] = {"태초의 달빛매듭 허리띠", "CRAFTING"}
        s["spell;created=26761"] = {"태초의 달빛매듭 어깨보호대", "CRAFTING"}
        s["spell;created=26762"] = {"태초의 달빛매듭 로브", "CRAFTING"}
        s["spell;created=28439"] = {"불변의 정수 생성", ""}
        s["spell;created=29548"] = {"지옥무쇠 장화", "CRAFTING"}
        s["spell;created=29606"] = {"아다만타이트 흉갑", "CRAFTING"}
        s["spell;created=29619"] = {"지옥강철 장갑", "CRAFTING"}
        s["spell;created=29620"] = {"지옥강철 다리보호구", "CRAFTING"}
        s["spell;created=29621"] = {"지옥강철 투구", "CRAFTING"}
        s["spell;created=29622"] = {"철탑의 건틀릿", "CRAFTING"}
        s["spell;created=29664"] = {"강인한 수호자의 투구", "CRAFTING"}
        s["spell;created=29668"] = {"굳은 신념의 투구", "CRAFTING"}
        s["spell;created=29671"] = {"푸른 요새의 팔보호구", "CRAFTING"}
        s["spell;created=30031"] = {"광란", "CRAFTING"}
        s["spell;created=30033"] = {"광란", "CRAFTING"}
        s["spell;created=30036"] = {"마법 훔치기", "CRAFTING"}
        s["spell;created=30039"] = {"전이", "CRAFTING"}
        s["spell;created=30563"] = {"고블린 로켓 발사기", "CRAFTING"}
        s["spell;created=30569"] = {"노움 꼬꼬댁 변신장치", "CRAFTING"}
        s["spell;created=31060"] = {"섬세한 이터늄 반지", "CRAFTING"}
        s["spell;created=31070"] = {"이터늄 고리 목걸이", "CRAFTING"}
        s["spell;created=31079"] = {"조각상 - 지옥강철 멧돼지", "CRAFTING"}
        s["spell;created=31080"] = {"조각상 - 여명석 게", "CRAFTING"}
        s["spell;created=31081"] = {"조각상 - 생명의 루비 뱀", "CRAFTING"}
        s["spell;created=31435"] = {"대혼란의 팔보호구", "CRAFTING"}
        s["spell;created=31440"] = {"영원의 망토", "CRAFTING"}
        s["spell;created=31443"] = {"몰락의 벨트", "CRAFTING"}
        s["spell;created=31448"] = {"결의의 외투", "CRAFTING"}
        s["spell;created=31449"] = {"복수의 외투", "CRAFTING"}
        s["spell;created=31452"] = {"마법 강타의 바지", "CRAFTING"}
        s["spell;created=31454"] = {"백마법 두건", "CRAFTING"}
        s["spell;created=31455"] = {"마법 강타의 두건", "CRAFTING"}
        s["spell;created=32494"] = {"지옥 가죽 다리보호구", "CRAFTING"}
        s["spell;created=32495"] = {"질긴 갈래발굽 조끼", "CRAFTING"}
        s["spell;created=32497"] = {"질긴 갈래발굽 장화", "CRAFTING"}
        s["spell;created=32499"] = {"지옥추적자 팔보호구", "CRAFTING"}
        s["spell;created=32756"] = {"어둠의 변장", ""}
        s["spell;created=32774"] = {"응징의 방패", ""}
        s["spell;created=33173"] = {"상급 변이", ""}
        s["spell;created=33803"] = {"불길의 파도", ""}
        s["spell;created=34534"] = {"왕의 보루흉갑", "CRAFTING"}
        s["spell;created=34540"] = {"용사의 사자심장 검", "CRAFTING"}
        s["spell;created=34544"] = {"달빛 클레버", "CRAFTING"}
        s["spell;created=34546"] = {"용아귀", "CRAFTING"}
        s["spell;created=35559"] = {"코브라 비늘 장갑", "CRAFTING"}
        s["spell;created=35563"] = {"바람의 학살자 장갑", "CRAFTING"}
        s["spell;created=35576"] = {"칠흑의 황천비늘 허리띠", "CRAFTING"}
        s["spell;created=35577"] = {"칠흑의 황천비늘 팔보호구", "CRAFTING"}
        s["spell;created=35580"] = {"황천쐐기 흉갑", "CRAFTING"}
        s["spell;created=35582"] = {"황천쐐기 허리띠", "CRAFTING"}
        s["spell;created=35584"] = {"황천쐐기 팔보호구", "CRAFTING"}
        s["spell;created=35585"] = {"바람매 갑옷", "CRAFTING"}
        s["spell;created=35587"] = {"바람매 허리띠", "CRAFTING"}
        s["spell;created=35588"] = {"바람매 팔보호구", "CRAFTING"}
        s["spell;created=35589"] = {"원소쐐기 조끼", "CRAFTING"}
        s["spell;created=35591"] = {"원소쐐기 팔보호구", "CRAFTING"}
        s["spell;created=36315"] = {"발파의 허리띠", "CRAFTING"}
        s["spell;created=36317"] = {"발파의 장화", "CRAFTING"}
        s["spell;created=36355"] = {"자연이 내린 은총의 장화", "CRAFTING"}
        s["spell;created=40744"] = {"에펙시스 수정 마력 주입", ""}
        s["spell;created=41160"] = {"재빠른 일격의 어깨보호구", "CRAFTING"}
        s["spell;created=41161"] = {"번개같은 반사 신경의 손목띠", "CRAFTING"}
        s["spell;created=41163"] = {"살아있는 대지의 손목띠", "CRAFTING"}
        s["spell;created=41205"] = {"기민한 사고의 팔보호구", "CRAFTING"}
        s["spell;created=41207"] = {"신속한 치유의 손목끈", "CRAFTING"}
        s["spell;created=42546"] = {"암흑의 망토", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationptBR()
        s["npc;drop=15550"] = {"Attumen, o Caçador", "Karazhan"}
        s["npc;drop=15687"] = {"Moroes <Castelão da Torre>", "Karazhan"}
        s["npc;drop=15688"] = {"Terestian Cascopodre", "Karazhan"}
        s["npc;drop=15689"] = {"Eteródio", "Karazhan"}
        s["npc;drop=15690"] = {"Príncipe Malquezaar", "Karazhan"}
        s["npc;drop=15691"] = {"O Curador", "Karazhan"}
        s["npc;drop=16011"] = {"Repugnaz", "Naxxramas"}
        s["npc;drop=16152"] = {"Attumen, o Caçador", "Karazhan"}
        s["npc;drop=16179"] = {"Hyakiss, a Tocaieira", "Karazhan"}
        s["npc;drop=16180"] = {"Shadikith, o Planador", "Karazhan"}
        s["npc;drop=16181"] = {"Rokad, o Assolador", "Karazhan"}
        s["npc;drop=16411"] = {"Cozinheiro Espectral", "Karazhan"}
        s["npc;drop=16457"] = {"Donzela da Virtude", "Karazhan"}
        s["npc;drop=16485"] = {"Vigia Arcano", "Karazhan"}
        s["npc;drop=16504"] = {"Protetor Arcano", "Karazhan"}
        s["npc;drop=16524"] = {"Vulto de Aran", "Karazhan"}
        s["npc;drop=16807"] = {"Grão-bruxo Eterrívio", "Salões Despedaçados"}
        s["npc;drop=16808"] = {"Chefe Guerreiro Karrath Carpunhal", "Salões Despedaçados"}
        s["npc;drop=16816"] = {"Eco de Medivh", "Karazhan"}
        s["npc;drop=17225"] = {"Nocturno", "Karazhan"}
        s["npc;drop=17257"] = {"Magtheridon", "Covil de Magtheridon"}
        s["npc;drop=17377"] = {"Keli'dan, o Quebrador", "Fornalha de Sangue"}
        s["npc;drop=17381"] = {"O Criador", "Fornalha de Sangue"}
        s["npc;drop=17521"] = {"Lobo Mau", "Karazhan"}
        s["npc;drop=17533"] = {"Romão", "Karazhan"}
        s["npc;drop=17711"] = {"Armagedom", "Vale da Lua Negra"}
        s["npc;drop=17767"] = {"Cólerus Hibernálgida", "Pico Hyjal"}
        s["npc;drop=17798"] = {"Senhor da Guerra Kalithresh", "Câmara dos Vapores"}
        s["npc;drop=17808"] = {"Anetheron", "Pico Hyjal"}
        s["npc;drop=17842"] = {"Azgalor", "Pico Hyjal"}
        s["npc;drop=17848"] = {"Tenente Drake", "Antigo Contraforte de Eira dos Montes"}
        s["npc;drop=17879"] = {"Crono-lorde Deja", "Lamaçal Negro"}
        s["npc;drop=17880"] = {"Temporus", "Lamaçal Negro"}
        s["npc;drop=17881"] = {"Aeonus", "Lamaçal Negro"}
        s["npc;drop=17882"] = {"A Espreitadora Negra", "Brejo Oculto"}
        s["npc;drop=17888"] = {"Kaz'rogal", "Pico Hyjal"}
        s["npc;drop=17897"] = {"Carnífice da Cripta", ""}
        s["npc;drop=17898"] = {"Abominação", ""}
        s["npc;drop=17908"] = {"Infernal Gigante", ""}
        s["npc;drop=17942"] = {"Atolaço", "Pátio dos Escravos"}
        s["npc;drop=17968"] = {"Arquimonde", "Pico Hyjal"}
        s["npc;drop=17975"] = {"Alto-botânico Freywinn", "Jardim Botânico"}
        s["npc;drop=17977"] = {"Estilhaço Dimensional", "Jardim Botânico"}
        s["npc;drop=17978"] = {"Cardônico, o Mantenedor", "Jardim Botânico"}
        s["npc;drop=17980"] = {"Laj", "Jardim Botânico"}
        s["npc;drop=17991"] = {"Rokmar, o Talhador", "Pátio dos Escravos"}
        s["npc;drop=18093"] = {"Protetor da Serraria Tarren", ""}
        s["npc;drop=18096"] = {"Caçador das Eras", "Antigo Contraforte de Eira dos Montes"}
        s["npc;drop=18105"] = {"Ghaz'an", "Brejo Oculto"}
        s["npc;drop=18168"] = {"Bruxa Má", "Karazhan"}
        s["npc;drop=18341"] = {"Pandemônio", "Tumbas de Mana"}
        s["npc;drop=18343"] = {"Tavarok", "Tumbas de Mana"}
        s["npc;drop=18344"] = {"Príncipe do Nexus Shaffar", "Tumbas de Mana"}
        s["npc;drop=18371"] = {"Shirrak, o Vigia dos Mortos", "Catacumbas Auchenai"}
        s["npc;drop=18373"] = {"Exarca Maladaar", "Catacumbas Auchenai"}
        s["npc;drop=184259"] = {"[Night Lord]", "Karazhan"}
        s["npc;drop=18472"] = {"Tecetrevas Syth", "Salões dos Sethekk"}
        s["npc;drop=18473"] = {"Ikiss, o Rei-gadanho", "Salões dos Sethekk"}
        s["npc;drop=18478"] = {"Avatar do Mártir", "Catacumbas Auchenai"}
        s["npc;drop=18667"] = {"Nerocordius, o Incitador", "Labirinto Soturno"}
        s["npc;drop=18693"] = {"Orador Mar'grom", "Montanhas da Lâmina Afiada"}
        s["npc;drop=18697"] = {"Engenheiro-chefe Lorthander", "Eternévoa"}
        s["npc;drop=18708"] = {"Murmúrio", "Labirinto Soturno"}
        s["npc;drop=18728"] = {"Senhor da Perdição Kazzak", "Península Fogo do Inferno"}
        s["npc;drop=18731"] = {"Embaixador Gorjavernus", "Labirinto Soturno"}
        s["npc;drop=18805"] = {"Alta-astromante Solarian", "Bastilha da Tormenta"}
        s["npc;drop=18831"] = {"Alto-rei Maulgar <Senhor dos Ogros>", "Covil de Gruul"}
        s["npc;drop=19044"] = {"Gruul, o Matador de Dragões", "Covil de Gruul"}
        s["npc;drop=19220"] = {"Pathaleon, o Calculista", "Mecanar"}
        s["npc;drop=19221"] = {"Etermante Sepethrea", "Mecanar"}
        s["npc;drop=19514"] = {"Al'ar <Deus Fênix>", "Bastilha da Tormenta"}
        s["npc;drop=19516"] = {"Aniquilador do Caos", "Bastilha da Tormenta"}
        s["npc;drop=20035"] = {"Delegado da Falange Sangrenta", "Bastilha da Tormenta"}
        s["npc;drop=20036"] = {"Escudeiro da Falange Sangrenta", "Bastilha da Tormenta"}
        s["npc;drop=20042"] = {"Forja-tempestades", "Bastilha da Tormenta"}
        s["npc;drop=20044"] = {"Astromante Noviço", "Bastilha da Tormenta"}
        s["npc;drop=20885"] = {"Dalliah, a Agoureira", "Arcatraz"}
        s["npc;drop=21212"] = {"Lady Vashj <Máter Presacurva>", "Caverna do Serpentário"}
        s["npc;drop=21213"] = {"Morogrim Andamaré", "Caverna do Serpentário"}
        s["npc;drop=21214"] = {"Senhor do Abismo Karathress", "Caverna do Serpentário"}
        s["npc;drop=21215"] = {"Leóteras, o Cego", "Caverna do Serpentário"}
        s["npc;drop=21217"] = {"O Tocaieiro Subterrâneo", "Caverna do Serpentário"}
        s["npc;drop=21251"] = {"Colosso do Brejo Oculto", "Caverna do Serpentário"}
        s["npc;drop=21466"] = {"Precursor Skiriss", "Arcatraz"}
        s["npc;drop=21838"] = {"Terokk", "Mata Terokkar"}
        s["npc;drop=21845"] = {"Leóteras, o Cego", ""}
        s["npc;drop=21932"] = {"Hidross, o Instável <Duque das Correntezas>", ""}
        s["npc;drop=22052"] = {"Couronegro Gorjadaga", "Montanhas da Lâmina Afiada"}
        s["npc;drop=22841"] = {"Vulto de Akama", "Templo Negro"}
        s["npc;drop=22845"] = {"Místico Grislíngua", "Templo Negro"}
        s["npc;drop=22871"] = {"Teron Sanguinávido", "Templo Negro"}
        s["npc;drop=22884"] = {"Leviatã", "Templo Negro"}
        s["npc;drop=22898"] = {"Supremus", "Templo Negro"}
        s["npc;drop=22917"] = {"Illidan Tempesfúria <O Traidor>", "Templo Negro"}
        s["npc;drop=22930"] = {"Yor <Cão do Caos de Shaffar>", "Tumbas de Mana"}
        s["npc;drop=22947"] = {"Mãe Shahraz", "Templo Negro"}
        s["npc;drop=22948"] = {"Gurtogg Fervessangue", "Templo Negro"}
        s["npc;drop=22950"] = {"Sumo Etereomante Zerevor", "Templo Negro"}
        s["npc;drop=23054"] = {"Kael'thas Andassol <Senhor dos Elfos Sangrentos>", "Shattrath"}
        s["npc;drop=23236"] = {"Escudarte Mascaosso", "Templo Negro"}
        s["npc;drop=23281"] = {"Insidion", "Montanhas da Lâmina Afiada"}
        s["npc;drop=23282"] = {"Obsídia", "Montanhas da Lâmina Afiada"}
        s["npc;drop=23374"] = {"Espreitador Grislíngua", "Templo Negro"}
        s["npc;drop=23397"] = {"Lorde Sangrento Illidari", "Templo Negro"}
        s["npc;drop=23402"] = {"Mago de Batalha Illidari", "Templo Negro"}
        s["npc;drop=23420"] = {"Essência da Ira", "Templo Negro"}
        s["npc;drop=23774"] = {"Instrutor Amani'shi", ""}
        s["npc;drop=23872"] = {"Coren Cervatroz", "Abismo Rocha Negra"}
        s["npc;sold=12777"] = {"Capitão Martelúgubre <Intendente de Armaduras>", "Vale Alterac"}
        s["npc;sold=12781"] = {"Primeiro-sargento Biggins <Intendente de Acessórios de Oficiais>", "Ventobravo"}
        s["npc;sold=12792"] = {"Lady Palanseer <Intendente de Armaduras>", "Bacia Arathi"}
        s["npc;sold=17585"] = {"Intendente Urgronn <Intendente de Thrallmar>", "Península Fogo do Inferno"}
        s["npc;sold=17657"] = {"Oficial de Logística Ulrike <Intendente da Fortaleza da Honra>", "Península Fogo do Inferno"}
        s["npc;sold=17904"] = {"Fedryen Lancélere <Intendente da Expedição Cenariana>", "Pântano Zíngaro"}
        s["npc;sold=18525"] = {"G'eras", "Shattrath"}
        s["npc;sold=18898"] = {"Explodina Chiesguicha <Comerciante da Arena>", "Nagrand"}
        s["npc;sold=19321"] = {"Intendente Endarin <Intendente dos Aldor>", "Shattrath"}
        s["npc;sold=19331"] = {"Intendente Enuril <Áugures: Intendente>", "Shattrath"}
        s["npc;sold=19536"] = {"Mercador Jadyan <Armas Exóticas>", "Eternévoa"}
        s["npc;sold=19772"] = {"Sábio Espiritual Gartok", "Mata Terokkar"}
        s["npc;sold=20278"] = {"Vixton Beliscapito <Comerciante da Arena>", "Eternévoa"}
        s["npc;sold=20613"] = {"Arodis Gumélion <Guardião das Relíquias Sha'tari>", "Shattrath"}
        s["npc;sold=20616"] = {"Asuur <Guardião das Relíquias Sha'tari>", "Shattrath"}
        s["npc;sold=21432"] = {"Almaador <Intendente Sha'tari>", "Shattrath"}
        s["npc;sold=21643"] = {"Alurmi <Intendente dos Defensores do Tempo>", "Tanaris"}
        s["npc;sold=21655"] = {"Nakodu <Intendente do Bairro Inferior>", "Shattrath"}
        s["npc;sold=21905"] = {"Veynna Aurestela <Guardiã das Relíquias Sha'tari>", "Shattrath"}
        s["npc;sold=21906"] = {"Kelara <Guardiã das Relíquias Sha'tari>", "Shattrath"}
        s["npc;sold=23159"] = {"Okuno <Intendente Devoto da Morte Grislíngua>", "Templo Negro"}
        s["npc;sold=23381"] = {"Tydormu <Guardião dos Artefatos Perdidos>", ""}
        s["npc;sold=23428"] = {"Jho'nass <Intendente de Ogri'la>", "Montanhas da Lâmina Afiada"}
        s["npc;sold=25176"] = {"Grikkin Molacobre <Comerciante da Arena>", "Nagrand"}
        s["npc;sold=26089"] = {"Kayri <Comerciante de Itens Exóticos>", "Ilha de Quel'Danas"}
        s["npc;sold=27668"] = {"Ontok Modorrento <Comerciante da Arena>", "Shattrath"}
        s["npc;sold=3523"] = {"Bowen Brisboise <Treinamento de Alfaiataria>", "Clareiras de Tirisfal"}
        s["npc;sold=3703"] = {"Krulmoo Lua Cheia <Treinamento de Couraria>", "Sertões"}
        s["object;contained=184465"] = {"Baú da Legião", "Mecanar"}
        s["object;contained=185119"] = {"Baú Empoeirado", "Karazhan"}
        s["object;contained=185169"] = {"Baú Reforçado de Ferrovil", "Muralha Fogo do Inferno"}
        s["object;contained=185584"] = {"Espinho de Naj'entus", "Templo Negro"}
        s["quest;reward=10011"] = {"Campo-forja: aniquilado", ""}
        s["quest;reward=10091"] = {"Os engenhos das almas", ""}
        s["quest;reward=10136"] = {"As intenções do Cruel", ""}
        s["quest;reward=10176"] = {"Ar'kelos, o guardião", ""}
        s["quest;reward=10185"] = {"Uma sina pior do que a morte", ""}
        s["quest;reward=10188"] = {"O signo de Krasus", ""}
        s["quest;reward=10280"] = {"Entrega especial para Shattrath", "Eternévoa"}
        s["quest;reward=10298"] = {"Herói da prole", ""}
        s["quest;reward=10320"] = {"Destrua Naberius!", ""}
        s["quest;reward=10323"] = {"Desativar Manaforja Ara", ""}
        s["quest;reward=10337"] = {"Quando as vacas voltam para o lar", ""}
        s["quest;reward=10345"] = {"A carne é forte...", ""}
        s["quest;reward=10353"] = {"Arconus, o Insaciável", ""}
        s["quest;reward=10365"] = {"Desativar Manaforja Ara", ""}
        s["quest;reward=10381"] = {"Abaixo com Aldor", ""}
        s["quest;reward=10400"] = {"Lorde supremo", ""}
        s["quest;reward=10409"] = {"O golpe de misericórdia à Legião", ""}
        s["quest;reward=10425"] = {"Fuga dos bivaques", ""}
        s["quest;reward=10439"] = {"Dimensius, O que Tudo Devora", ""}
        s["quest;reward=10460"] = {"Jura do defensor", ""}
        s["quest;reward=10462"] = {"Jura do campeão", ""}
        s["quest;reward=10463"] = {"Jura do sábio", ""}
        s["quest;reward=10472"] = {"Pacto do sábio", ""}
        s["quest;reward=10473"] = {"Pacto do restaurador", ""}
        s["quest;reward=10474"] = {"Pacto do campeão", ""}
        s["quest;reward=10507"] = {"Virada", ""}
        s["quest;reward=10579"] = {"A Cifra da Danação: terceiro fragmento recuperado", ""}
        s["quest;reward=10645"] = {"Teron Sanguinávido eu sou...", ""}
        s["quest;reward=10704"] = {"Como entrar em Arcatraz", ""}
        s["quest;reward=10728"] = {"Eminência do Olho Violeta", ""}
        s["quest;reward=10745"] = {"Vitória da conquista", ""}
        s["quest;reward=10769"] = {"Discórdia nas fileiras...", ""}
        s["quest;reward=10781"] = {"Batalha da Vigília Carmesim", ""}
        s["quest;reward=10806"] = {"Confronto final", "Montanhas da Lâmina Afiada"}
        s["quest;reward=10912"] = {"O Mestre dos Cães", ""}
        s["quest;reward=10938"] = {"Baralho de Bênçãos de Negraluna", ""}
        s["quest;reward=10940"] = {"Baralho de Fúrias de Negraluna", ""}
        s["quest;reward=10941"] = {"Baralho de Insânias de Negraluna", ""}
        s["quest;reward=11002"] = {"A queda de Magtheridon", "Península Fogo do Inferno"}
        s["quest;reward=11007"] = {"Kael'thas e a esfera verdejante", ""}
        s["quest;reward=11031"] = {"Arquimago, não mais", ""}
        s["quest;reward=11032"] = {"Protetor, não mais", "Trilha do Vento Morto"}
        s["quest;reward=11033"] = {"Assassino, não mais", "Trilha do Vento Morto"}
        s["quest;reward=11041"] = {"Serviço deixado pela metade...", ""}
        s["quest;reward=11092"] = {"Saudações, Comandante!", ""}
        s["quest;reward=9120"] = {"A queda de Kel'Thuzad", "Terras Pestilentas Orientais"}
        s["quest;reward=9271"] = {"Atiesh, Grande Cajado do Guardião", "Stratholme"}
        s["quest;reward=9494"] = {"Brasas vis", ""}
        s["quest;reward=9763"] = {"O esconderijo do senhor da guerra", ""}
        s["quest;reward=9860"] = {"A nova diretriz", ""}
        s["spell;created=17632"] = {"Pedra do Alquimista", "CRAFTING"}
        s["spell;created=23537"] = {"Enfurecer", ""}
        s["spell;created=23773"] = {"Sofrimento de Sanidade", ""}
        s["spell;created=23786"] = {"Antipeçonha Poderoso", ""}
        s["spell;created=23793"] = {"Força", ""}
        s["spell;created=26752"] = {"Cinto de Fogo Místico", "CRAFTING"}
        s["spell;created=26753"] = {"Luvas de Fogo Místico", "CRAFTING"}
        s["spell;created=26754"] = {"Veste de Fogo Místico", "CRAFTING"}
        s["spell;created=26756"] = {"Omoplatas de Umbratrama Congeladas", "CRAFTING"}
        s["spell;created=26757"] = {"Botas de Umbratrama Congeladas", "CRAFTING"}
        s["spell;created=26758"] = {"Veste de Umbratrama Congelada", "CRAFTING"}
        s["spell;created=26760"] = {"Cinto de Lunatrama Primeva", "CRAFTING"}
        s["spell;created=26761"] = {"Omoplatas de Lunatrama Primeva", "CRAFTING"}
        s["spell;created=26762"] = {"Veste de Lunatrama Primeva", "CRAFTING"}
        s["spell;created=28439"] = {"Criar Quintessência Eterna", ""}
        s["spell;created=29548"] = {"Botas de Placa de Ferrovil", "CRAFTING"}
        s["spell;created=29606"] = {"Peitoral de Adamantita", "CRAFTING"}
        s["spell;created=29619"] = {"Luvas de Açovil", "CRAFTING"}
        s["spell;created=29620"] = {"Perneiras de Açovil", "CRAFTING"}
        s["spell;created=29621"] = {"Elmo de Açovil", "CRAFTING"}
        s["spell;created=29622"] = {"Manoplas da Torre de Ferro", "CRAFTING"}
        s["spell;created=29664"] = {"Elmo do Defensor Impávido", "CRAFTING"}
        s["spell;created=29668"] = {"Elmo do Guardião do Juramento", "CRAFTING"}
        s["spell;created=29671"] = {"Braçadeiras da Fortaleza Verde", "CRAFTING"}
        s["spell;created=30031"] = {"Alvoroço", "CRAFTING"}
        s["spell;created=30033"] = {"Alvoroço", "CRAFTING"}
        s["spell;created=30036"] = {"Roubar Magia", "CRAFTING"}
        s["spell;created=30039"] = {"Transferência", "CRAFTING"}
        s["spell;created=30563"] = {"Lança-foguetes Goblínico", "CRAFTING"}
        s["spell;created=30569"] = {"Galinhaitor Gnômico", "CRAFTING"}
        s["spell;created=31060"] = {"Anel de Etérnio Delicado", "CRAFTING"}
        s["spell;created=31070"] = {"Corrente Trançada de Etérnio", "CRAFTING"}
        s["spell;created=31079"] = {"Estatueta - Javali de Açovil", "CRAFTING"}
        s["spell;created=31080"] = {"Estatueta - Caranguejo de Aurolita", "CRAFTING"}
        s["spell;created=31081"] = {"Estatueta - Serpente de Rubi Vivo", "CRAFTING"}
        s["spell;created=31435"] = {"Braçadeiras da Tormenta", "CRAFTING"}
        s["spell;created=31440"] = {"Manto da Eternidade", "CRAFTING"}
        s["spell;created=31443"] = {"Cinturão da Ruína", "CRAFTING"}
        s["spell;created=31448"] = {"Capa Resoluta", "CRAFTING"}
        s["spell;created=31449"] = {"Mantelete da Vingança", "CRAFTING"}
        s["spell;created=31452"] = {"Calças do Golpe Mágico", "CRAFTING"}
        s["spell;created=31454"] = {"Capuz Remendalvo", "CRAFTING"}
        s["spell;created=31455"] = {"Capuz do Golpe Mágico", "CRAFTING"}
        s["spell;created=32494"] = {"Perneiras de Couro Vil", "CRAFTING"}
        s["spell;created=32495"] = {"Colete Pesado de Fenoceronte", "CRAFTING"}
        s["spell;created=32497"] = {"Botas Pesadas de Fenoceronte", "CRAFTING"}
        s["spell;created=32499"] = {"Braçadeira do Espreitador Vil", "CRAFTING"}
        s["spell;created=32756"] = {"Disfarce Sombrio", ""}
        s["spell;created=32774"] = {"Escudo do Vingador", ""}
        s["spell;created=33173"] = {"Polimorfia Maior", ""}
        s["spell;created=33803"] = {"Onda de Chamas", ""}
        s["spell;created=34534"] = {"Baluarte dos Reis", "CRAFTING"}
        s["spell;created=34540"] = {"Campeão Coração de Leão", "CRAFTING"}
        s["spell;created=34544"] = {"Fendelua", "CRAFTING"}
        s["spell;created=34546"] = {"Presa do Dragão", "CRAFTING"}
        s["spell;created=35559"] = {"Luvas de Escama de Naja", "CRAFTING"}
        s["spell;created=35563"] = {"Braçadeiras do Mataventos", "CRAFTING"}
        s["spell;created=35576"] = {"Cinto de Ébano de Escama Etérea", "CRAFTING"}
        s["spell;created=35577"] = {"Braçadeiras de Ébano de Escama Etérea", "CRAFTING"}
        s["spell;created=35580"] = {"Peitoral do Golpe Etéreo", "CRAFTING"}
        s["spell;created=35582"] = {"Cinto do Golpe Etéreo", "CRAFTING"}
        s["spell;created=35584"] = {"Braçadeiras do Golpe Etéreo", "CRAFTING"}
        s["spell;created=35585"] = {"Cota do Falcão do Vento", "CRAFTING"}
        s["spell;created=35587"] = {"Cinto do Falcão do Vento", "CRAFTING"}
        s["spell;created=35588"] = {"Braçadeiras do Falcão do Vento", "CRAFTING"}
        s["spell;created=35589"] = {"Colete do Golpe Primevo", "CRAFTING"}
        s["spell;created=35591"] = {"Braçadeiras do Golpe Primevo", "CRAFTING"}
        s["spell;created=36315"] = {"Cinto do Impacto", "CRAFTING"}
        s["spell;created=36317"] = {"Botas do Impacto", "CRAFTING"}
        s["spell;created=36355"] = {"Botas do Encanto Natural", "CRAFTING"}
        s["spell;created=40744"] = {"Infusão de Cristal dos Apexis", ""}
        s["spell;created=41160"] = {"Omoplatas do Golpepresto", "CRAFTING"}
        s["spell;created=41161"] = {"Braçadeiras do Reflexo Relâmpago", "CRAFTING"}
        s["spell;created=41163"] = {"Braceletes da Terra Viva", "CRAFTING"}
        s["spell;created=41205"] = {"Braçadeiras do Pensamento Ligeiro", "CRAFTING"}
        s["spell;created=41207"] = {"Braceletes da Cura Célere", "CRAFTING"}
        s["spell;created=42546"] = {"Manto de Trevas", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationruRU()
        s["npc;drop=15550"] = {"Ловчий Аттумен", "Каражан"}
        s["npc;drop=15687"] = {"Мороуз <Дворецкий>", "Каражан"}
        s["npc;drop=15688"] = {"Терестиан Больное Копыто", "Каражан"}
        s["npc;drop=15689"] = {"Гнев Пустоты", "Каражан"}
        s["npc;drop=15690"] = {"Принц Малчезар", "Каражан"}
        s["npc;drop=15691"] = {"Смотритель", "Каражан"}
        s["npc;drop=15989"] = {"Сапфирон", "Наксрамас"}
        s["npc;drop=16011"] = {"Лотхиб", "Наксрамас"}
        s["npc;drop=16152"] = {"Ловчий Аттумен", "Каражан"}
        s["npc;drop=16179"] = {"Хиакисс Скрытень", "Каражан"}
        s["npc;drop=16180"] = {"Шадикит Скользящий", "Каражан"}
        s["npc;drop=16181"] = {"Рокад Опустошитель", "Каражан"}
        s["npc;drop=16411"] = {"Призрачный шеф-повар", "Каражан"}
        s["npc;drop=16457"] = {"Благочестивая дева", "Каражан"}
        s["npc;drop=16485"] = {"Волшебный смотритель", "Каражан"}
        s["npc;drop=16504"] = {"Волшебный заступник", "Каражан"}
        s["npc;drop=16524"] = {"Тень Арана", "Каражан"}
        s["npc;drop=16807"] = {"Главный чернокнижник Пустоклят", "Разрушенные залы"}
        s["npc;drop=16808"] = {"Вождь Каргат Острорук", "Разрушенные залы"}
        s["npc;drop=16816"] = {"Эхо Медива", "Каражан"}
        s["npc;drop=17225"] = {"Ночная Погибель", "Каражан"}
        s["npc;drop=17257"] = {"Магтеридон", "Логово Магтеридона"}
        s["npc;drop=17377"] = {"Кели'дан Разрушитель", "Кузня Крови"}
        s["npc;drop=17381"] = {"Мастер", "Кузня Крови"}
        s["npc;drop=17521"] = {"Злой и страшный серый волк", "Каражан"}
        s["npc;drop=17533"] = {"Ромуло", "Каражан"}
        s["npc;drop=17534"] = {"Джулианна", "Каражан"}
        s["npc;drop=17711"] = {"Судьболом", "Долина Призрачной Луны"}
        s["npc;drop=17767"] = {"Лютый Хлад", "Вершина Хиджала"}
        s["npc;drop=17798"] = {"Полководец Калитреш", "Паровое подземелье"}
        s["npc;drop=17808"] = {"Анетерон", "Вершина Хиджала"}
        s["npc;drop=17842"] = {"Азгалор", "Вершина Хиджала"}
        s["npc;drop=17848"] = {"Лейтенант Дрейк", "Старые предгорья Хилсбрада"}
        s["npc;drop=17879"] = {"Повелитель времени Дежа", "Черные топи"}
        s["npc;drop=17880"] = {"Темпорус", "Черные топи"}
        s["npc;drop=17881"] = {"Эонус", "Черные топи"}
        s["npc;drop=17882"] = {"Черная Охотница", "Нижетопь"}
        s["npc;drop=17888"] = {"Каз'рогал", "Вершина Хиджала"}
        s["npc;drop=17897"] = {"Некроарахнид", ""}
        s["npc;drop=17898"] = {"Поганище", ""}
        s["npc;drop=17908"] = {"Гигантский инфернал", ""}
        s["npc;drop=17942"] = {"Зыбун", "Узилище"}
        s["npc;drop=17968"] = {"Архимонд", "Вершина Хиджала"}
        s["npc;drop=17975"] = {"Верховный ботаник Фрейвин", "Ботаника"}
        s["npc;drop=17977"] = {"Узлодревень", "Ботаника"}
        s["npc;drop=17978"] = {"Скалезуб Скорбный", "Ботаника"}
        s["npc;drop=17980"] = {"Ладж", "Ботаника"}
        s["npc;drop=17991"] = {"Рокмар Трескун", "Узилище"}
        s["npc;drop=18093"] = {"Защитник Мельницы Таррен", ""}
        s["npc;drop=18096"] = {"Охотник Вечности", "Старые предгорья Хилсбрада"}
        s["npc;drop=18105"] = {"Газ'ан", "Нижетопь"}
        s["npc;drop=18168"] = {"Ведьма", "Каражан"}
        s["npc;drop=18341"] = {"Пандемоний", "Гробницы маны"}
        s["npc;drop=18343"] = {"Таварок", "Гробницы маны"}
        s["npc;drop=18344"] = {"Принц Шаффар", "Гробницы маны"}
        s["npc;drop=18371"] = {"Ширрак Страж Мертвых", "Аукенайские гробницы"}
        s["npc;drop=18373"] = {"Экзарх Маладаар", "Аукенайские гробницы"}
        s["npc;drop=184259"] = {"Владыка ночи", "Каражан"}
        s["npc;drop=18472"] = {"Темнопряд Сит", "Сетеккские залы"}
        s["npc;drop=18473"] = {"Король воронов Айкисс", "Сетеккские залы"}
        s["npc;drop=18478"] = {"Аватара Мученика", "Аукенайские гробницы"}
        s["npc;drop=18667"] = {"Черносерд Подстрекатель", "Темный лабиринт"}
        s["npc;drop=18693"] = {"Проповедник Маргром", "Острогорье"}
        s["npc;drop=18697"] = {"Главный инженер Лортандер", "Пустоверть"}
        s["npc;drop=18708"] = {"Бормотун", "Темный лабиринт"}
        s["npc;drop=18728"] = {"Владыка судеб Каззак", "Полуостров Адского Пламени"}
        s["npc;drop=18731"] = {"Посол Гиблочрев", "Темный лабиринт"}
        s["npc;drop=18805"] = {"Верховный звездочет Солариан", "Крепость Бурь"}
        s["npc;drop=18831"] = {"Король Молгар <Повелитель огров>", "Логово Груула"}
        s["npc;drop=19044"] = {"Груул Драконобой", "Логово Груула"}
        s["npc;drop=19220"] = {"Паталеон Вычислитель", "Механар"}
        s["npc;drop=19221"] = {"Пустомант Сепетрея", "Механар"}
        s["npc;drop=19514"] = {"Ал'ар <Феникс-бог>", "Крепость Бурь"}
        s["npc;drop=19516"] = {"Страж Бездны", "Крепость Бурь"}
        s["npc;drop=20035"] = {"Кровостраж-маршал", "Крепость Бурь"}
        s["npc;drop=20036"] = {"Кровостраж-оруженосец", "Крепость Бурь"}
        s["npc;drop=20042"] = {"Кузнец крепости", "Крепость Бурь"}
        s["npc;drop=20044"] = {"Начинающий звездочет", "Крепость Бурь"}
        s["npc;drop=20885"] = {"Даллия Глашатай Судьбы", "The Arcatraz"}
        s["npc;drop=21174"] = {"Магтеридон", ""}
        s["npc;drop=21212"] = {"Леди Вайш <Правительница резервуара Кривого Клыка>", "Змеиное святилище"}
        s["npc;drop=21213"] = {"Морогрим Волноступ", "Змеиное святилище"}
        s["npc;drop=21214"] = {"Повелитель глубин Каратресс", "Змеиное святилище"}
        s["npc;drop=21215"] = {"Леотерас Слепец", "Змеиное святилище"}
        s["npc;drop=21217"] = {"Скрытень из глубин", "Змеиное святилище"}
        s["npc;drop=21251"] = {"Колосс Нижетопи", "Змеиное святилище"}
        s["npc;drop=21466"] = {"Предвестник Скайрисс", "The Arcatraz"}
        s["npc;drop=21838"] = {"Терокк", "Лес Тероккар"}
        s["npc;drop=21845"] = {"Леотерас Слепец", ""}
        s["npc;drop=21932"] = {"Гидросс Нестабильный <Властитель течений>", ""}
        s["npc;drop=22052"] = {"Черношкур из каньона Кинжальной Пасти", "Острогорье"}
        s["npc;drop=22841"] = {"Тень Акамы", "Черный храм"}
        s["npc;drop=22845"] = {"Пеплоуст-мистик", "Черный храм"}
        s["npc;drop=22871"] = {"Терон Кровожад", "Черный храм"}
        s["npc;drop=22884"] = {"Левиафан", "Черный храм"}
        s["npc;drop=22898"] = {"Супремус", "Черный храм"}
        s["npc;drop=22917"] = {"Иллидан Ярость Бури <Предатель>", "Черный храм"}
        s["npc;drop=22930"] = {"Йор <Исчадие Бездны Шаффара>", "Гробницы маны"}
        s["npc;drop=22947"] = {"Матушка Шахраз", "Черный храм"}
        s["npc;drop=22948"] = {"Гуртогг Кипящая Кровь", "Черный храм"}
        s["npc;drop=22950"] = {"Верховный пустомант Зеревор", "Черный храм"}
        s["npc;drop=23054"] = {"Кель'тас Солнечный Скиталец <Правитель эльфов крови>", "Шаттрат"}
        s["npc;drop=23236"] = {"Щитоносец-ученик из клана Костеглодов", "Черный храм"}
        s["npc;drop=23281"] = {"Инсидион", "Острогорье"}
        s["npc;drop=23282"] = {"Обсидия", "Острогорье"}
        s["npc;drop=23374"] = {"Пеплоуст-ловец", "Черный храм"}
        s["npc;drop=23397"] = {"Иллидарский лорд крови", "Черный храм"}
        s["npc;drop=23402"] = {"Иллидарский боевой маг", "Черный храм"}
        s["npc;drop=23420"] = {"Воплощение гнева", "Черный храм"}
        s["npc;drop=23774"] = {"Наставник из племени Амани", ""}
        s["npc;drop=23872"] = {"Корен Худовар", "Глубины Черной горы"}
        s["npc;sold=12777"] = {"Капитан Сокрушающий Молот <Начальник снабжения доспехами>", "Альтеракская долина"}
        s["npc;sold=12781"] = {"Старший сержант Биггинс <Начальник офицерского снабжения>", "Штормград"}
        s["npc;sold=12792"] = {"Леди Палансир <Начальник снабжения доспехами>", "Альтеракская долина"}
        s["npc;sold=17585"] = {"Интендант Ургронн <Начальник снабжения Траллмара>", "Полуостров Адского Пламени"}
        s["npc;sold=17657"] = {"Офицер-логистик Ульрика <Интендантка Оплота Чести>", "Полуостров Адского Пламени"}
        s["npc;sold=17904"] = {"Федриен Быстрое Копье <Начальник снабжения Кенарийской экспедиции>", "Зангартопь"}
        s["npc;sold=18525"] = {"Г'ирас", "Шаттрат"}
        s["npc;sold=18898"] = {"Бумбарахта Шумосвист <Продавец экипировки арены>", "Награнд"}
        s["npc;sold=19321"] = {"Интендант Эндарин <Начальник снабжения Алдоров>", "Шаттрат"}
        s["npc;sold=19331"] = {"Интендант Инурил <Начальник снабжения Провидцев>", "Шаттрат"}
        s["npc;sold=19536"] = {"Делец Джайдиан <Экзотическое оружие>", "Пустоверть"}
        s["npc;sold=19772"] = {"Заклинатель духов Гарток", "Лес Тероккар"}
        s["npc;sold=20278"] = {"Викстон Паросвист <Продавец экипировки арены>", "Пустоверть"}
        s["npc;sold=20613"] = {"Ародис Солнечный Клинок <Хранитель артефактов Ша'тар>", "Шаттрат"}
        s["npc;sold=20616"] = {"Асуур <Хранитель артефактов Ша'тар>", "Шаттрат"}
        s["npc;sold=21432"] = {"Альмаадор <Начальник снабжения Ша'тар>", "Шаттрат"}
        s["npc;sold=21643"] = {"Алурми <Начальник снабжения Хранителей Времени>", "Танарис"}
        s["npc;sold=21655"] = {"Накоду <Интендант Нижнего города>", "Шаттрат"}
        s["npc;sold=21905"] = {"Вейнна Утренняя Звезда <Хранитель наследия Ша'тар>", "Шаттрат"}
        s["npc;sold=21906"] = {"Келара <Хранитель наследия Ша'тар>", "Шаттрат"}
        s["npc;sold=23159"] = {"Окуно <Начальник снабжения Пеплоустов>", "Черный храм"}
        s["npc;sold=23381"] = {"Тайдорму <Хранитель утраченных артефактов>", ""}
        s["npc;sold=23428"] = {"Джхо'ннас <Интендант Огри'ла>", "Острогорье"}
        s["npc;sold=25176"] = {"Гриккин Медипрыг <Продавец экипировки арены>", "Награнд"}
        s["npc;sold=26089"] = {"Кайри <Поставщик экзотического снаряжения>", "Остров Кель'Данас"}
        s["npc;sold=27668"] = {"Онток Сломанный Рог <Продавец экипировки арены>", "Шаттрат"}
        s["npc;sold=3523"] = {"Боуэн Брисбойс <Учитель портняжного дела>", "Тирисфальские леса"}
        s["npc;sold=3703"] = {"Крульмоо Полная Луна <Учитель кожевничества>", "Степи"}
        s["object;contained=184465"] = {"Тайник Легиона", "Механар"}
        s["object;contained=185119"] = {"Пыльный сундук", "Каражан"}
        s["object;contained=185169"] = {"Укрепленный сундук из оскверненного железа", "Бастионы Адского Пламени"}
        s["object;contained=185584"] = {"Шип Надж'ентуса", "Черный храм"}
        s["quest;reward=10011"] = {"Лагеря Легиона: уничтожены", ""}
        s["quest;reward=10091"] = {"Инструменты души", ""}
        s["quest;reward=10136"] = {"Безжалостные планы", ""}
        s["quest;reward=10176"] = {"Страж Ар'келос", ""}
        s["quest;reward=10185"] = {"Участь хуже, чем смерть", ""}
        s["quest;reward=10188"] = {"Печать Краса", ""}
        s["quest;reward=10280"] = {"Специальный груз в город Шаттрат", "Пустоверть"}
        s["quest;reward=10298"] = {"Герой драконьего племени", ""}
        s["quest;reward=10320"] = {"Уничтожить Набериуса!", ""}
        s["quest;reward=10323"] = {"Отключить манагорн Ара", ""}
        s["quest;reward=10337"] = {"Когда коровы возвращаются домой", ""}
        s["quest;reward=10345"] = {"Усеял мертвыми костями...", ""}
        s["quest;reward=10353"] = {"Арконус Ненасытный", ""}
        s["quest;reward=10365"] = {"Отключить манагорн Ара", ""}
        s["quest;reward=10381"] = {"Нет больше Алдора", ""}
        s["quest;reward=10400"] = {"Владыка", ""}
        s["quest;reward=10409"] = {"Удар по Легиону", ""}
        s["quest;reward=10425"] = {"Побег с полигона", ""}
        s["quest;reward=10439"] = {"Пространствус Всепоглощающий", ""}
        s["quest;reward=10460"] = {"Посвящение в защитники", ""}
        s["quest;reward=10462"] = {"Посвящение в герои", ""}
        s["quest;reward=10463"] = {"Посвящение в мудрецы", ""}
        s["quest;reward=10472"] = {"Договор мудреца", ""}
        s["quest;reward=10473"] = {"Договор целителя", ""}
        s["quest;reward=10474"] = {"Договор героя", ""}
        s["quest;reward=10507"] = {"Поворотная точка", ""}
        s["quest;reward=10579"] = {"Код Проклятия – Третий фрагмент", ""}
        s["quest;reward=10645"] = {"Терон Кровожад, то есть я...", ""}
        s["quest;reward=10704"] = {"Как проникнуть в Аркатрац", ""}
        s["quest;reward=10728"] = {"Аметистовое Око в восхищении", ""}
        s["quest;reward=10745"] = {"Вести о Победе", ""}
        s["quest;reward=10769"] = {"Удар исподтишка", ""}
        s["quest;reward=10781"] = {"Битва у Кровавого дозора", ""}
        s["quest;reward=10806"] = {"Перед выстрелом", "Острогорье"}
        s["quest;reward=10912"] = {"Псарь", ""}
        s["quest;reward=10938"] = {"Колода карт Новолуния: Благословения", ""}
        s["quest;reward=10940"] = {"Колода карт Новолуния: Ярость", ""}
        s["quest;reward=10941"] = {"Колода карт Новолуния: Безумие", ""}
        s["quest;reward=11001"] = {"Изгнание бога-ворона", ""}
        s["quest;reward=11002"] = {"Падение Магтеридона", "Полуостров Адского Пламени"}
        s["quest;reward=11007"] = {"Кель'тас и зеленеющая сфера", ""}
        s["quest;reward=11031"] = {"Перестать быть верховным магом из Аметистового Ока", ""}
        s["quest;reward=11032"] = {"Перестать быть защитником из Аметистового Ока", "Перевал Мертвого Ветра"}
        s["quest;reward=11033"] = {"Перестать быть убийцей из Аметистового Ока", "Перевал Мертвого Ветра"}
        s["quest;reward=11041"] = {"Неоконченное дело", ""}
        s["quest;reward=11092"] = {"Приветствую тебя, Командир!", ""}
        s["quest;reward=9120"] = {"Падение Кел'Тузада", "Восточные Чумные земли"}
        s["quest;reward=9271"] = {"Атиеш, большой посох Стража", "Стратхольм"}
        s["quest;reward=9494"] = {"Угли Скверны", ""}
        s["quest;reward=9763"] = {"Убежище врага", ""}
        s["quest;reward=9860"] = {"Новое направление", ""}
        s["spell;created=17632"] = {"Алхимический камень", "CRAFTING"}
        s["spell;created=23537"] = {"Исступление", ""}
        s["spell;created=23773"] = {"Муки разума", ""}
        s["spell;created=23786"] = {"Мощное противоядие", ""}
        s["spell;created=23793"] = {"Сила", ""}
        s["spell;created=26752"] = {"Пояс из огненной чароткани", "CRAFTING"}
        s["spell;created=26753"] = {"Перчатки из огненной чароткани", "CRAFTING"}
        s["spell;created=26754"] = {"Одеяние из огненной чароткани", "CRAFTING"}
        s["spell;created=26756"] = {"Наплечники из застывшей тенеткани", "CRAFTING"}
        s["spell;created=26757"] = {"Сапоги из застывшей тенеткани", "CRAFTING"}
        s["spell;created=26758"] = {"Одеяние из застывшей тенеткани", "CRAFTING"}
        s["spell;created=26760"] = {"Пояс из изначальной луноткани", "CRAFTING"}
        s["spell;created=26761"] = {"Наплечники из изначальной луноткани", "CRAFTING"}
        s["spell;created=26762"] = {"Одеяние из изначальной луноткани", "CRAFTING"}
        s["spell;created=28439"] = {"Создание вечной квинтэссенции", ""}
        s["spell;created=29548"] = {"Латные сапоги из оскверненного железа", "CRAFTING"}
        s["spell;created=29606"] = {"Адамантитовая кираса", "CRAFTING"}
        s["spell;created=29619"] = {"Перчатки из оскверненной стали", "CRAFTING"}
        s["spell;created=29620"] = {"Поножи из оскверненной стали", "CRAFTING"}
        s["spell;created=29621"] = {"Шлем из оскверненной стали", "CRAFTING"}
        s["spell;created=29622"] = {"Рукавицы Железной крепости", "CRAFTING"}
        s["spell;created=29664"] = {"Шлем стойкого защитника", "CRAFTING"}
        s["spell;created=29668"] = {"Шлем хранителя клятвы", "CRAFTING"}
        s["spell;created=29671"] = {"Наручи зеленой крепости", "CRAFTING"}
        s["spell;created=30031"] = {"Буйство", "CRAFTING"}
        s["spell;created=30033"] = {"Буйство", "CRAFTING"}
        s["spell;created=30036"] = {"Похищение магии", "CRAFTING"}
        s["spell;created=30039"] = {"Перенаправление", "CRAFTING"}
        s["spell;created=30563"] = {"Гоблинский ракетомет", "CRAFTING"}
        s["spell;created=30569"] = {"Гномский полюсный птицефикатор", "CRAFTING"}
        s["spell;created=31060"] = {"Изысканное этерниевое кольцо", "CRAFTING"}
        s["spell;created=31070"] = {"Оплетенная этерниевая кольчуга", "CRAFTING"}
        s["spell;created=31079"] = {"Статуэтка вепря из оскверненной стали", "CRAFTING"}
        s["spell;created=31080"] = {"Статуэтка краба из зоревика", "CRAFTING"}
        s["spell;created=31081"] = {"Статуэтка змеи из животворного рубина", "CRAFTING"}
        s["spell;created=31435"] = {"Наручи Разора", "CRAFTING"}
        s["spell;created=31440"] = {"Плащ вечности", "CRAFTING"}
        s["spell;created=31443"] = {"Ремень опустошения", "CRAFTING"}
        s["spell;created=31448"] = {"Накидка твердости", "CRAFTING"}
        s["spell;created=31449"] = {"Плащ отмщения", "CRAFTING"}
        s["spell;created=31452"] = {"Штаны сокрушительной магии", "CRAFTING"}
        s["spell;created=31454"] = {"Капюшон белого целителя", "CRAFTING"}
        s["spell;created=31455"] = {"Капюшон сокрушительной магии", "CRAFTING"}
        s["spell;created=32494"] = {"Поножи из сквернокожи", "CRAFTING"}
        s["spell;created=32495"] = {"Тяжелый панцирь из шкуры копытня", "CRAFTING"}
        s["spell;created=32497"] = {"Тяжелые сапоги из шкуры копытня", "CRAFTING"}
        s["spell;created=32499"] = {"Наручи ловца Скверны", "CRAFTING"}
        s["spell;created=32756"] = {"Темный облик.", ""}
        s["spell;created=32774"] = {"Щит мстителя", ""}
        s["spell;created=33173"] = {"Могущественное превращение", ""}
        s["spell;created=33803"] = {"Волна пламени", ""}
        s["spell;created=34534"] = {"Оплот королей", "CRAFTING"}
        s["spell;created=34540"] = {"Защитник львиного сердца", "CRAFTING"}
        s["spell;created=34544"] = {"Лунный колун", "CRAFTING"}
        s["spell;created=34546"] = {"Драконья Пасть", "CRAFTING"}
        s["spell;created=35559"] = {"Перчатки из чешуи кобры", "CRAFTING"}
        s["spell;created=35563"] = {"Напульсники ветроубийцы", "CRAFTING"}
        s["spell;created=35576"] = {"Черный пояс из чешуи дракона Пустоты", "CRAFTING"}
        s["spell;created=35577"] = {"Черные наручи из чешуи дракона Пустоты", "CRAFTING"}
        s["spell;created=35580"] = {"Кираса удара Пустоты", "CRAFTING"}
        s["spell;created=35582"] = {"Пояс удара Пустоты", "CRAFTING"}
        s["spell;created=35584"] = {"Наручи удара Пустоты", "CRAFTING"}
        s["spell;created=35585"] = {"Хауберк легкокрылого ястреба", "CRAFTING"}
        s["spell;created=35587"] = {"Пояс легкокрылого ястреба", "CRAFTING"}
        s["spell;created=35588"] = {"Наручи легкокрылого ястреба", "CRAFTING"}
        s["spell;created=35589"] = {"Жилет упреждающего удара", "CRAFTING"}
        s["spell;created=35591"] = {"Наручи упреждающего удара", "CRAFTING"}
        s["spell;created=36315"] = {"Пояс взрыва", "CRAFTING"}
        s["spell;created=36317"] = {"Сапоги взрыва", "CRAFTING"}
        s["spell;created=36355"] = {"Сапоги природной милости", "CRAFTING"}
        s["spell;created=40744"] = {"Воздействие апекситового кристалла", ""}
        s["spell;created=41160"] = {"Наплечники молниеносного удара", "CRAFTING"}
        s["spell;created=41161"] = {"Наручники молниеносной реакции", "CRAFTING"}
        s["spell;created=41163"] = {"Наручники живой земли", "CRAFTING"}
        s["spell;created=41205"] = {"Наручи сообразительности", "CRAFTING"}
        s["spell;created=41207"] = {"Повязки быстрого исцеления", "CRAFTING"}
        s["spell;created=42546"] = {"Плащ Тьмы", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationzhCN()
        s["npc;drop=15550"] = {"猎手阿图门", "卡拉赞"}
        s["npc;drop=15687"] = {"莫罗斯 <管家>", "卡拉赞"}
        s["npc;drop=15688"] = {"特雷斯坦·邪蹄", "卡拉赞"}
        s["npc;drop=15689"] = {"虚空幽龙", "卡拉赞"}
        s["npc;drop=15690"] = {"玛克扎尔王子", "卡拉赞"}
        s["npc;drop=15691"] = {"馆长", "卡拉赞"}
        s["npc;drop=15989"] = {"萨菲隆", "纳克萨玛斯"}
        s["npc;drop=16011"] = {"洛欧塞布", "纳克萨玛斯"}
        s["npc;drop=16152"] = {"猎手阿图门", "卡拉赞"}
        s["npc;drop=16179"] = {"潜伏者希亚其斯", "卡拉赞"}
        s["npc;drop=16180"] = {"滑翔者沙德基斯", "卡拉赞"}
        s["npc;drop=16181"] = {"蹂躏者洛卡德", "卡拉赞"}
        s["npc;drop=16411"] = {"鬼灵厨师", "卡拉赞"}
        s["npc;drop=16457"] = {"贞节圣女", "卡拉赞"}
        s["npc;drop=16485"] = {"奥术看守", "卡拉赞"}
        s["npc;drop=16504"] = {"奥术保卫者", "卡拉赞"}
        s["npc;drop=16524"] = {"埃兰之影", "卡拉赞"}
        s["npc;drop=16807"] = {"高阶术士奈瑟库斯", "破碎大厅"}
        s["npc;drop=16808"] = {"酋长卡加斯·刃拳", "破碎大厅"}
        s["npc;drop=16816"] = {"麦迪文的回音", "卡拉赞"}
        s["npc;drop=17225"] = {"夜之魇", "卡拉赞"}
        s["npc;drop=17257"] = {"玛瑟里顿", "玛瑟里顿的巢穴"}
        s["npc;drop=17377"] = {"击碎者克里丹", "鲜血熔炉"}
        s["npc;drop=17381"] = {"制造者", "鲜血熔炉"}
        s["npc;drop=17521"] = {"大灰狼", "卡拉赞"}
        s["npc;drop=17533"] = {"罗密欧", "卡拉赞"}
        s["npc;drop=17534"] = {"朱丽叶", "卡拉赞"}
        s["npc;drop=17711"] = {"末日行者", "影月谷"}
        s["npc;drop=17767"] = {"雷基·冬寒", "海加尔峰"}
        s["npc;drop=17798"] = {"督军卡利瑟里斯", "蒸汽地窟"}
        s["npc;drop=17808"] = {"安纳塞隆", "海加尔峰"}
        s["npc;drop=17842"] = {"阿兹加洛", "海加尔峰"}
        s["npc;drop=17848"] = {"德拉克中尉", "旧希尔斯布莱德丘陵"}
        s["npc;drop=17879"] = {"时空领主德亚", "黑色沼泽"}
        s["npc;drop=17880"] = {"坦普卢斯", "黑色沼泽"}
        s["npc;drop=17881"] = {"埃欧努斯", "黑色沼泽"}
        s["npc;drop=17882"] = {"黑色阔步者", "幽暗沼泽"}
        s["npc;drop=17888"] = {"卡兹洛加", "海加尔峰"}
        s["npc;drop=17897"] = {"地穴恶魔", ""}
        s["npc;drop=17898"] = {"憎恶", ""}
        s["npc;drop=17908"] = {"庞大的地狱火", ""}
        s["npc;drop=17942"] = {"夸格米拉", "奴隶围栏"}
        s["npc;drop=17968"] = {"阿克蒙德", "海加尔峰"}
        s["npc;drop=17975"] = {"高级植物学家弗雷温", "生态船"}
        s["npc;drop=17977"] = {"迁跃扭木", "生态船"}
        s["npc;drop=17978"] = {"看管者索恩格林", "生态船"}
        s["npc;drop=17980"] = {"拉伊", "生态船"}
        s["npc;drop=17991"] = {"巨钳鲁克玛尔", "奴隶围栏"}
        s["npc;drop=18093"] = {"塔伦米尔保卫者", ""}
        s["npc;drop=18096"] = {"时空猎手", "旧希尔斯布莱德丘陵"}
        s["npc;drop=18105"] = {"加兹安", "幽暗沼泽"}
        s["npc;drop=18168"] = {"巫婆", "卡拉赞"}
        s["npc;drop=18341"] = {"潘德莫努斯", "法力陵墓"}
        s["npc;drop=18343"] = {"塔瓦洛克", "法力陵墓"}
        s["npc;drop=18344"] = {"节点亲王沙法尔", "法力陵墓"}
        s["npc;drop=18371"] = {"死亡观察者希尔拉克", "奥金尼地穴"}
        s["npc;drop=18373"] = {"大主教玛拉达尔", "奥金尼地穴"}
        s["npc;drop=184259"] = {"夜之领主", "卡拉赞"}
        s["npc;drop=18472"] = {"黑暗编织者塞斯", "塞泰克大厅"}
        s["npc;drop=18473"] = {"利爪之王艾吉斯", "塞泰克大厅"}
        s["npc;drop=18478"] = {"殉难者的化身", "奥金尼地穴"}
        s["npc;drop=18667"] = {"煽动者布莱卡特", "暗影迷宫"}
        s["npc;drop=18693"] = {"演讲者玛尔高姆", "刀锋山"}
        s["npc;drop=18697"] = {"主工程师洛杉德尔", "虚空风暴"}
        s["npc;drop=18708"] = {"摩摩尔", "暗影迷宫"}
        s["npc;drop=18728"] = {"末日领主卡扎克", "地狱火半岛"}
        s["npc;drop=18731"] = {"赫尔默大使", "暗影迷宫"}
        s["npc;drop=18805"] = {"大星术师索兰莉安", "风暴要塞"}
        s["npc;drop=18831"] = {"莫加尔大王 <食人魔之王>", "格鲁尔的巢穴"}
        s["npc;drop=19044"] = {"屠龙者格鲁尔", "格鲁尔的巢穴"}
        s["npc;drop=19220"] = {"计算者帕萨雷恩", "能源舰"}
        s["npc;drop=19221"] = {"灵术师塞比瑟蕾", "能源舰"}
        s["npc;drop=19514"] = {"奥 <凤凰之神>", "风暴要塞"}
        s["npc;drop=19516"] = {"空灵机甲", "风暴要塞"}
        s["npc;drop=20035"] = {"血警卫典狱长", "风暴要塞"}
        s["npc;drop=20036"] = {"血警卫侍从", "风暴要塞"}
        s["npc;drop=20042"] = {"风暴要塞铁匠", "风暴要塞"}
        s["npc;drop=20044"] = {"星术师学徒", "风暴要塞"}
        s["npc;drop=20885"] = {"末日预言者达尔莉安", "禁魔监狱"}
        s["npc;drop=21174"] = {"玛瑟里顿", ""}
        s["npc;drop=21212"] = {"瓦丝琪 <盘牙女王>", "毒蛇神殿"}
        s["npc;drop=21213"] = {"莫洛格里·踏潮者", "毒蛇神殿"}
        s["npc;drop=21214"] = {"深水领主卡拉瑟雷斯", "毒蛇神殿"}
        s["npc;drop=21215"] = {"盲眼者莱欧瑟拉斯", "毒蛇神殿"}
        s["npc;drop=21217"] = {"鱼斯拉", "毒蛇神殿"}
        s["npc;drop=21251"] = {"幽暗沼泽巨人", "毒蛇神殿"}
        s["npc;drop=21466"] = {"预言者斯克瑞斯", "禁魔监狱"}
        s["npc;drop=21838"] = {"泰罗克", "泰罗卡森林"}
        s["npc;drop=21845"] = {"盲眼者莱欧瑟拉斯", ""}
        s["npc;drop=21932"] = {"不稳定的海度斯 <水流公爵>", ""}
        s["npc;drop=22052"] = {"刃喉黑皮龙", "刀锋山"}
        s["npc;drop=22841"] = {"阿卡玛之影", "黑暗神殿"}
        s["npc;drop=22845"] = {"灰舌秘术师", "黑暗神殿"}
        s["npc;drop=22871"] = {"塔隆·血魔", "黑暗神殿"}
        s["npc;drop=22884"] = {"海兽", "黑暗神殿"}
        s["npc;drop=22898"] = {"苏普雷姆斯", "黑暗神殿"}
        s["npc;drop=22917"] = {"伊利丹·怒风 <背叛者>", "黑暗神殿"}
        s["npc;drop=22930"] = {"尤尔 <沙法尔的虚空猎犬>", "法力陵墓"}
        s["npc;drop=22947"] = {"莎赫拉丝主母", "黑暗神殿"}
        s["npc;drop=22948"] = {"古尔图格·血沸", "黑暗神殿"}
        s["npc;drop=22950"] = {"高阶灵术师塞勒沃尔", "黑暗神殿"}
        s["npc;drop=23054"] = {"凯尔萨斯·逐日者 <血精灵之王>", "沙塔斯城"}
        s["npc;drop=23236"] = {"噬骨持盾者", "黑暗神殿"}
        s["npc;drop=23281"] = {"因斯迪安", "刀锋山"}
        s["npc;drop=23282"] = {"欧比斯迪", "刀锋山"}
        s["npc;drop=23374"] = {"灰舌潜伏者", "黑暗神殿"}
        s["npc;drop=23397"] = {"伊利达雷血领主", "黑暗神殿"}
        s["npc;drop=23402"] = {"伊利达雷战斗法师", "黑暗神殿"}
        s["npc;drop=23420"] = {"愤怒精华", "黑暗神殿"}
        s["npc;drop=23774"] = {"阿曼尼训练师", ""}
        s["npc;drop=23872"] = {"科林·烈酒", "黑石深渊"}
        s["npc;sold=12777"] = {"迪格汉默上尉 <护甲军需官>", "奥特兰克山谷"}
        s["npc;sold=12781"] = {"军士长贝金斯 <杂货军需官>", "暴风城"}
        s["npc;sold=12792"] = {"帕兰蒂尔 <护甲军需官>", "奥特兰克山谷"}
        s["npc;sold=17585"] = {"军需官乌尔格隆 <萨尔玛军需官>", "地狱火半岛"}
        s["npc;sold=17657"] = {"后勤军需官乌瑞卡 <荣耀堡军需官>", "地狱火半岛"}
        s["npc;sold=17904"] = {"芬德雷·迅矛 <塞纳里奥远征队军需官>", "赞加沼泽"}
        s["npc;sold=18525"] = {"基厄拉斯", "沙塔斯城"}
        s["npc;sold=18898"] = {"伊克普罗迪·菲兹普特 <竞技场商人>", "纳格兰"}
        s["npc;sold=19321"] = {"军需官恩达尔林 <奥尔多军需官>", "沙塔斯城"}
        s["npc;sold=19331"] = {"军需官恩努利尔 <占星者军需官>", "沙塔斯城"}
        s["npc;sold=19536"] = {"商人亚德安 <特种武器>", "虚空风暴"}
        s["npc;sold=19772"] = {"灵魂先知加尔托克", "泰罗卡森林"}
        s["npc;sold=20278"] = {"维克斯顿 <竞技场商人>", "虚空风暴"}
        s["npc;sold=20613"] = {"阿罗迪斯·炎刃 <沙塔尔神器管理者>", "沙塔斯城"}
        s["npc;sold=20616"] = {"阿苏尔 <沙塔尔神器管理者>", "沙塔斯城"}
        s["npc;sold=21432"] = {"奥玛多尔 <沙塔尔军需官>", "沙塔斯城"}
        s["npc;sold=21643"] = {"艾鲁尔米 <时光守护者军需官>", "塔纳利斯"}
        s["npc;sold=21655"] = {"纳克杜 <贫民窟军需官>", "沙塔斯城"}
        s["npc;sold=21905"] = {"维恩娜·晨星 <沙塔尔宝物管理者>", "沙塔斯城"}
        s["npc;sold=21906"] = {"克尔拉兰 <沙塔尔宝物管理者>", "沙塔斯城"}
        s["npc;sold=23159"] = {"沃库诺 <灰舌死誓者军需官>", "黑暗神殿"}
        s["npc;sold=23381"] = {"泰多姆 <失落神器的保管者>", ""}
        s["npc;sold=23428"] = {"霍纳斯 <奥格瑞拉军需官>", "刀锋山"}
        s["npc;sold=25176"] = {"格里金·考伯斯宾 <竞技场商人>", "纳格兰"}
        s["npc;sold=26089"] = {"卡艾莉 <特种装备销售商>", "奎尔丹纳斯岛"}
        s["npc;sold=27668"] = {"安图克·裂角 <竞技场商人>", "沙塔斯城"}
        s["npc;sold=3523"] = {"博文·布里斯博埃斯 <裁缝训练师>", "提瑞斯法林地"}
        s["npc;sold=3703"] = {"克鲁姆·满月 <制皮训练师>", "贫瘠之地"}
        s["object;contained=184465"] = {"军团宝箱", "能源舰"}
        s["object;contained=185119"] = {"灰尘覆盖的箱子", "卡拉赞"}
        s["object;contained=185169"] = {"强化魔铁箱", "地狱火城墙"}
        s["object;contained=185584"] = {"纳因图斯之脊", "黑暗神殿"}
        s["quest;reward=10011"] = {"扫荡铸魔营地", ""}
        s["quest;reward=10091"] = {"灵魂装置", ""}
        s["quest;reward=10136"] = {"阿拉修斯的意图", ""}
        s["quest;reward=10176"] = {"守护者阿尔凯洛斯", ""}
        s["quest;reward=10185"] = {"悲惨的命运", ""}
        s["quest;reward=10188"] = {"克拉苏斯的魔符", ""}
        s["quest;reward=10280"] = {"送往沙塔斯的特殊货物", "虚空风暴"}
        s["quest;reward=10298"] = {"龙族的英雄", ""}
        s["quest;reward=10320"] = {"毁灭纳比留斯！", ""}
        s["quest;reward=10323"] = {"关闭法力熔炉：艾拉", ""}
        s["quest;reward=10337"] = {"奶牛回家", ""}
        s["quest;reward=10345"] = {"血肉会撒谎......", ""}
        s["quest;reward=10353"] = {"贪婪者阿克努斯", ""}
        s["quest;reward=10365"] = {"关闭法力熔炉：艾拉", ""}
        s["quest;reward=10381"] = {"退出奥尔多", ""}
        s["quest;reward=10400"] = {"霸王", ""}
        s["quest;reward=10409"] = {"重创燃烧军团", ""}
        s["quest;reward=10425"] = {"逃离前沿基地", ""}
        s["quest;reward=10439"] = {"诸界吞噬者迪门修斯", ""}
        s["quest;reward=10460"] = {"防御者的契约", ""}
        s["quest;reward=10462"] = {"勇士的契约", ""}
        s["quest;reward=10463"] = {"先知的契约", ""}
        s["quest;reward=10472"] = {"先知的盟约", ""}
        s["quest;reward=10473"] = {"治愈者的盟约", ""}
        s["quest;reward=10474"] = {"勇士的盟约", ""}
        s["quest;reward=10507"] = {"转折点", ""}
        s["quest;reward=10579"] = {"诅咒密码 - 第三块碎片", ""}
        s["quest;reward=10645"] = {"我就是塔隆·血魔......", ""}
        s["quest;reward=10704"] = {"如何杀入禁魔监狱", ""}
        s["quest;reward=10728"] = {"紫罗兰之眼的荣耀", ""}
        s["quest;reward=10745"] = {"胜利的消息", ""}
        s["quest;reward=10769"] = {"散播敌意......", ""}
        s["quest;reward=10781"] = {"火红岗哨之战", ""}
        s["quest;reward=10806"] = {"摊牌", "刀锋山"}
        s["quest;reward=10912"] = {"犬王", ""}
        s["quest;reward=10938"] = {"暗月祝福套牌", ""}
        s["quest;reward=10940"] = {"暗月报复套牌", ""}
        s["quest;reward=10941"] = {"暗月愚人套牌", ""}
        s["quest;reward=11001"] = {"消灭乌鸦之神", ""}
        s["quest;reward=11002"] = {"玛瑟里顿之死", "地狱火半岛"}
        s["quest;reward=11007"] = {"凯尔萨斯和翠绿的魔珠", ""}
        s["quest;reward=11031"] = {"远离大法师之路", ""}
        s["quest;reward=11032"] = {"远离保卫者之路", "逆风小径"}
        s["quest;reward=11033"] = {"远离刺客之路", "逆风小径"}
        s["quest;reward=11041"] = {"未完的工作......", ""}
        s["quest;reward=11092"] = {"你好，指挥官！", ""}
        s["quest;reward=9120"] = {"克尔苏加德的末日", "东瘟疫之地"}
        s["quest;reward=9271"] = {"埃提耶什，守护者的传说之杖", "斯坦索姆"}
        s["quest;reward=9494"] = {"邪能灰烬", ""}
        s["quest;reward=9763"] = {"督军的末日", ""}
        s["quest;reward=9860"] = {"新的指示", ""}
        s["spell;created=17632"] = {"炼金石", "CRAFTING"}
        s["spell;created=23537"] = {"激怒", ""}
        s["spell;created=23773"] = {"神智受难", ""}
        s["spell;created=23786"] = {"特效抗毒药剂", ""}
        s["spell;created=23793"] = {"力量", ""}
        s["spell;created=26752"] = {"魔焰腰带", "CRAFTING"}
        s["spell;created=26753"] = {"魔焰手套", "CRAFTING"}
        s["spell;created=26754"] = {"魔焰长袍", "CRAFTING"}
        s["spell;created=26756"] = {"冰霜暗纹护肩", "CRAFTING"}
        s["spell;created=26757"] = {"冰霜暗纹长靴", "CRAFTING"}
        s["spell;created=26758"] = {"冰霜暗纹外衣", "CRAFTING"}
        s["spell;created=26760"] = {"原始月布腰带", "CRAFTING"}
        s["spell;created=26761"] = {"原始月布护肩", "CRAFTING"}
        s["spell;created=26762"] = {"原始月布长袍", "CRAFTING"}
        s["spell;created=29548"] = {"魔铁板甲战靴", "CRAFTING"}
        s["spell;created=29606"] = {"精金胸甲", "CRAFTING"}
        s["spell;created=29619"] = {"魔钢手套", "CRAFTING"}
        s["spell;created=29620"] = {"魔钢护腿", "CRAFTING"}
        s["spell;created=29621"] = {"魔钢头盔", "CRAFTING"}
        s["spell;created=29622"] = {"铁塔护手", "CRAFTING"}
        s["spell;created=29664"] = {"坚定防御者头盔", "CRAFTING"}
        s["spell;created=29668"] = {"誓言守护者头盔", "CRAFTING"}
        s["spell;created=29671"] = {"绿色要塞护腕", "CRAFTING"}
        s["spell;created=30031"] = {"暴怒", "CRAFTING"}
        s["spell;created=30033"] = {"暴怒", "CRAFTING"}
        s["spell;created=30036"] = {"窃取魔法", "CRAFTING"}
        s["spell;created=30039"] = {"传送", "CRAFTING"}
        s["spell;created=30563"] = {"地精火箭发射器", "CRAFTING"}
        s["spell;created=30569"] = {"侏儒变鸡器", "CRAFTING"}
        s["spell;created=31060"] = {"精致恒金戒指", "CRAFTING"}
        s["spell;created=31070"] = {"恒金饰链", "CRAFTING"}
        s["spell;created=31079"] = {"雕像 - 魔钢野猪", "CRAFTING"}
        s["spell;created=31080"] = {"雕像 - 黎明石螃蟹", "CRAFTING"}
        s["spell;created=31081"] = {"雕像 - 红曜石毒蛇", "CRAFTING"}
        s["spell;created=31435"] = {"浩劫护腕", "CRAFTING"}
        s["spell;created=31440"] = {"永恒披风", "CRAFTING"}
        s["spell;created=31443"] = {"毁灭束带", "CRAFTING"}
        s["spell;created=31448"] = {"坚毅披风", "CRAFTING"}
        s["spell;created=31449"] = {"复仇披风", "CRAFTING"}
        s["spell;created=31452"] = {"法术打击短裤", "CRAFTING"}
        s["spell;created=31454"] = {"白色治愈兜帽", "CRAFTING"}
        s["spell;created=31455"] = {"法术打击兜帽", "CRAFTING"}
        s["spell;created=32494"] = {"魔能皮甲护腿", "CRAFTING"}
        s["spell;created=32495"] = {"厚重裂蹄外套", "CRAFTING"}
        s["spell;created=32497"] = {"厚重裂蹄长靴", "CRAFTING"}
        s["spell;created=32499"] = {"魔能猎手护腕", "CRAFTING"}
        s["spell;created=32756"] = {"阴暗伪装", ""}
        s["spell;created=32774"] = {"复仇者之盾", ""}
        s["spell;created=33173"] = {"强效变形术", ""}
        s["spell;created=33803"] = {"烈焰波", ""}
        s["spell;created=34534"] = {"王者壁垒", "CRAFTING"}
        s["spell;created=34540"] = {"狮心圣剑", "CRAFTING"}
        s["spell;created=34544"] = {"月牙屠斧", "CRAFTING"}
        s["spell;created=34546"] = {"巨龙之喉", "CRAFTING"}
        s["spell;created=35559"] = {"眼镜蛇鳞片手套", "CRAFTING"}
        s["spell;created=35563"] = {"风斩裹手", "CRAFTING"}
        s["spell;created=35576"] = {"黑色虚鳞腰带", "CRAFTING"}
        s["spell;created=35577"] = {"黑色虚鳞护腕", "CRAFTING"}
        s["spell;created=35580"] = {"虚空打击胸甲", "CRAFTING"}
        s["spell;created=35582"] = {"虚空打击腰带", "CRAFTING"}
        s["spell;created=35584"] = {"虚空打击护腕", "CRAFTING"}
        s["spell;created=35585"] = {"风鹰胸甲", "CRAFTING"}
        s["spell;created=35587"] = {"风鹰腰带", "CRAFTING"}
        s["spell;created=35588"] = {"风鹰护腕", "CRAFTING"}
        s["spell;created=35589"] = {"原始打击外衣", "CRAFTING"}
        s["spell;created=35591"] = {"原始打击护腕", "CRAFTING"}
        s["spell;created=36315"] = {"冲击腰带", "CRAFTING"}
        s["spell;created=36317"] = {"冲击长靴", "CRAFTING"}
        s["spell;created=36355"] = {"自然优雅之靴", "CRAFTING"}
        s["spell;created=40744"] = {"埃匹希斯水晶灌注", ""}
        s["spell;created=41160"] = {"迅捷打击护肩", "CRAFTING"}
        s["spell;created=41161"] = {"闪电反射护腕", "CRAFTING"}
        s["spell;created=41163"] = {"生命之地护腕", "CRAFTING"}
        s["spell;created=41205"] = {"敏锐思维护腕", "CRAFTING"}
        s["spell;created=41207"] = {"迅捷治疗护腕", "CRAFTING"}
        s["spell;created=42546"] = {"黑暗披风", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationzhTW()
        s["npc;drop=15550"] = {"猎手阿图门", "卡拉赞"}
        s["npc;drop=15687"] = {"莫罗斯 <管家>", "卡拉赞"}
        s["npc;drop=15688"] = {"特雷斯坦·邪蹄", "卡拉赞"}
        s["npc;drop=15689"] = {"虚空幽龙", "卡拉赞"}
        s["npc;drop=15690"] = {"玛克扎尔王子", "卡拉赞"}
        s["npc;drop=15691"] = {"馆长", "卡拉赞"}
        s["npc;drop=15989"] = {"萨菲隆", "纳克萨玛斯"}
        s["npc;drop=16011"] = {"洛欧塞布", "纳克萨玛斯"}
        s["npc;drop=16152"] = {"猎手阿图门", "卡拉赞"}
        s["npc;drop=16179"] = {"潜伏者希亚其斯", "卡拉赞"}
        s["npc;drop=16180"] = {"滑翔者沙德基斯", "卡拉赞"}
        s["npc;drop=16181"] = {"蹂躏者洛卡德", "卡拉赞"}
        s["npc;drop=16411"] = {"鬼灵厨师", "卡拉赞"}
        s["npc;drop=16457"] = {"贞节圣女", "卡拉赞"}
        s["npc;drop=16485"] = {"奥术看守", "卡拉赞"}
        s["npc;drop=16504"] = {"奥术保卫者", "卡拉赞"}
        s["npc;drop=16524"] = {"埃兰之影", "卡拉赞"}
        s["npc;drop=16807"] = {"高阶术士奈瑟库斯", "破碎大厅"}
        s["npc;drop=16808"] = {"酋长卡加斯·刃拳", "破碎大厅"}
        s["npc;drop=16816"] = {"麦迪文的回音", "卡拉赞"}
        s["npc;drop=17225"] = {"夜之魇", "卡拉赞"}
        s["npc;drop=17257"] = {"玛瑟里顿", "玛瑟里顿的巢穴"}
        s["npc;drop=17377"] = {"击碎者克里丹", "鲜血熔炉"}
        s["npc;drop=17381"] = {"制造者", "鲜血熔炉"}
        s["npc;drop=17521"] = {"大灰狼", "卡拉赞"}
        s["npc;drop=17533"] = {"罗密欧", "卡拉赞"}
        s["npc;drop=17534"] = {"朱丽叶", "卡拉赞"}
        s["npc;drop=17711"] = {"末日行者", "影月谷"}
        s["npc;drop=17767"] = {"雷基·冬寒", "海加尔峰"}
        s["npc;drop=17798"] = {"督军卡利瑟里斯", "蒸汽地窟"}
        s["npc;drop=17808"] = {"安纳塞隆", "海加尔峰"}
        s["npc;drop=17842"] = {"阿兹加洛", "海加尔峰"}
        s["npc;drop=17848"] = {"德拉克中尉", "旧希尔斯布莱德丘陵"}
        s["npc;drop=17879"] = {"时空领主德亚", "黑色沼泽"}
        s["npc;drop=17880"] = {"坦普卢斯", "黑色沼泽"}
        s["npc;drop=17881"] = {"埃欧努斯", "黑色沼泽"}
        s["npc;drop=17882"] = {"黑色阔步者", "幽暗沼泽"}
        s["npc;drop=17888"] = {"卡兹洛加", "海加尔峰"}
        s["npc;drop=17897"] = {"地穴恶魔", ""}
        s["npc;drop=17898"] = {"憎恶", ""}
        s["npc;drop=17908"] = {"庞大的地狱火", ""}
        s["npc;drop=17942"] = {"夸格米拉", "奴隶围栏"}
        s["npc;drop=17968"] = {"阿克蒙德", "海加尔峰"}
        s["npc;drop=17975"] = {"高级植物学家弗雷温", "生态船"}
        s["npc;drop=17977"] = {"迁跃扭木", "生态船"}
        s["npc;drop=17978"] = {"看管者索恩格林", "生态船"}
        s["npc;drop=17980"] = {"拉伊", "生态船"}
        s["npc;drop=17991"] = {"巨钳鲁克玛尔", "奴隶围栏"}
        s["npc;drop=18093"] = {"塔伦米尔保卫者", ""}
        s["npc;drop=18096"] = {"时空猎手", "旧希尔斯布莱德丘陵"}
        s["npc;drop=18105"] = {"加兹安", "幽暗沼泽"}
        s["npc;drop=18168"] = {"巫婆", "卡拉赞"}
        s["npc;drop=18341"] = {"潘德莫努斯", "法力陵墓"}
        s["npc;drop=18343"] = {"塔瓦洛克", "法力陵墓"}
        s["npc;drop=18344"] = {"节点亲王沙法尔", "法力陵墓"}
        s["npc;drop=18371"] = {"死亡观察者希尔拉克", "奥金尼地穴"}
        s["npc;drop=18373"] = {"大主教玛拉达尔", "奥金尼地穴"}
        s["npc;drop=184259"] = {"夜之领主", "卡拉赞"}
        s["npc;drop=18472"] = {"黑暗编织者塞斯", "塞泰克大厅"}
        s["npc;drop=18473"] = {"利爪之王艾吉斯", "塞泰克大厅"}
        s["npc;drop=18478"] = {"殉难者的化身", "奥金尼地穴"}
        s["npc;drop=18667"] = {"煽动者布莱卡特", "暗影迷宫"}
        s["npc;drop=18693"] = {"演讲者玛尔高姆", "刀锋山"}
        s["npc;drop=18697"] = {"主工程师洛杉德尔", "虚空风暴"}
        s["npc;drop=18708"] = {"摩摩尔", "暗影迷宫"}
        s["npc;drop=18728"] = {"末日领主卡扎克", "地狱火半岛"}
        s["npc;drop=18731"] = {"赫尔默大使", "暗影迷宫"}
        s["npc;drop=18805"] = {"大星术师索兰莉安", "风暴要塞"}
        s["npc;drop=18831"] = {"莫加尔大王 <食人魔之王>", "格鲁尔的巢穴"}
        s["npc;drop=19044"] = {"屠龙者格鲁尔", "格鲁尔的巢穴"}
        s["npc;drop=19220"] = {"计算者帕萨雷恩", "能源舰"}
        s["npc;drop=19221"] = {"灵术师塞比瑟蕾", "能源舰"}
        s["npc;drop=19514"] = {"奥 <凤凰之神>", "风暴要塞"}
        s["npc;drop=19516"] = {"空灵机甲", "风暴要塞"}
        s["npc;drop=20035"] = {"血警卫典狱长", "风暴要塞"}
        s["npc;drop=20036"] = {"血警卫侍从", "风暴要塞"}
        s["npc;drop=20042"] = {"风暴要塞铁匠", "风暴要塞"}
        s["npc;drop=20044"] = {"星术师学徒", "风暴要塞"}
        s["npc;drop=20885"] = {"末日预言者达尔莉安", "禁魔监狱"}
        s["npc;drop=21174"] = {"玛瑟里顿", ""}
        s["npc;drop=21212"] = {"瓦丝琪 <盘牙女王>", "毒蛇神殿"}
        s["npc;drop=21213"] = {"莫洛格里·踏潮者", "毒蛇神殿"}
        s["npc;drop=21214"] = {"深水领主卡拉瑟雷斯", "毒蛇神殿"}
        s["npc;drop=21215"] = {"盲眼者莱欧瑟拉斯", "毒蛇神殿"}
        s["npc;drop=21217"] = {"鱼斯拉", "毒蛇神殿"}
        s["npc;drop=21251"] = {"幽暗沼泽巨人", "毒蛇神殿"}
        s["npc;drop=21466"] = {"预言者斯克瑞斯", "禁魔监狱"}
        s["npc;drop=21838"] = {"泰罗克", "泰罗卡森林"}
        s["npc;drop=21845"] = {"盲眼者莱欧瑟拉斯", ""}
        s["npc;drop=21932"] = {"不稳定的海度斯 <水流公爵>", ""}
        s["npc;drop=22052"] = {"刃喉黑皮龙", "刀锋山"}
        s["npc;drop=22841"] = {"阿卡玛之影", "黑暗神殿"}
        s["npc;drop=22845"] = {"灰舌秘术师", "黑暗神殿"}
        s["npc;drop=22871"] = {"塔隆·血魔", "黑暗神殿"}
        s["npc;drop=22884"] = {"海兽", "黑暗神殿"}
        s["npc;drop=22898"] = {"苏普雷姆斯", "黑暗神殿"}
        s["npc;drop=22917"] = {"伊利丹·怒风 <背叛者>", "黑暗神殿"}
        s["npc;drop=22930"] = {"尤尔 <沙法尔的虚空猎犬>", "法力陵墓"}
        s["npc;drop=22947"] = {"莎赫拉丝主母", "黑暗神殿"}
        s["npc;drop=22948"] = {"古尔图格·血沸", "黑暗神殿"}
        s["npc;drop=22950"] = {"高阶灵术师塞勒沃尔", "黑暗神殿"}
        s["npc;drop=23054"] = {"凯尔萨斯·逐日者 <血精灵之王>", "沙塔斯城"}
        s["npc;drop=23236"] = {"噬骨持盾者", "黑暗神殿"}
        s["npc;drop=23281"] = {"因斯迪安", "刀锋山"}
        s["npc;drop=23282"] = {"欧比斯迪", "刀锋山"}
        s["npc;drop=23374"] = {"灰舌潜伏者", "黑暗神殿"}
        s["npc;drop=23397"] = {"伊利达雷血领主", "黑暗神殿"}
        s["npc;drop=23402"] = {"伊利达雷战斗法师", "黑暗神殿"}
        s["npc;drop=23420"] = {"愤怒精华", "黑暗神殿"}
        s["npc;drop=23774"] = {"阿曼尼训练师", ""}
        s["npc;drop=23872"] = {"科林·烈酒", "黑石深渊"}
        s["npc;sold=12777"] = {"迪格汉默上尉 <护甲军需官>", "奥特兰克山谷"}
        s["npc;sold=12781"] = {"军士长贝金斯 <杂货军需官>", "暴风城"}
        s["npc;sold=12792"] = {"帕兰蒂尔 <护甲军需官>", "奥特兰克山谷"}
        s["npc;sold=17585"] = {"军需官乌尔格隆 <萨尔玛军需官>", "地狱火半岛"}
        s["npc;sold=17657"] = {"后勤军需官乌瑞卡 <荣耀堡军需官>", "地狱火半岛"}
        s["npc;sold=17904"] = {"芬德雷·迅矛 <塞纳里奥远征队军需官>", "赞加沼泽"}
        s["npc;sold=18525"] = {"基厄拉斯", "沙塔斯城"}
        s["npc;sold=18898"] = {"伊克普罗迪·菲兹普特 <竞技场商人>", "纳格兰"}
        s["npc;sold=19321"] = {"军需官恩达尔林 <奥尔多军需官>", "沙塔斯城"}
        s["npc;sold=19331"] = {"军需官恩努利尔 <占星者军需官>", "沙塔斯城"}
        s["npc;sold=19536"] = {"商人亚德安 <特种武器>", "虚空风暴"}
        s["npc;sold=19772"] = {"灵魂先知加尔托克", "泰罗卡森林"}
        s["npc;sold=20278"] = {"维克斯顿 <竞技场商人>", "虚空风暴"}
        s["npc;sold=20613"] = {"阿罗迪斯·炎刃 <沙塔尔神器管理者>", "沙塔斯城"}
        s["npc;sold=20616"] = {"阿苏尔 <沙塔尔神器管理者>", "沙塔斯城"}
        s["npc;sold=21432"] = {"奥玛多尔 <沙塔尔军需官>", "沙塔斯城"}
        s["npc;sold=21643"] = {"艾鲁尔米 <时光守护者军需官>", "塔纳利斯"}
        s["npc;sold=21655"] = {"纳克杜 <贫民窟军需官>", "沙塔斯城"}
        s["npc;sold=21905"] = {"维恩娜·晨星 <沙塔尔宝物管理者>", "沙塔斯城"}
        s["npc;sold=21906"] = {"克尔拉兰 <沙塔尔宝物管理者>", "沙塔斯城"}
        s["npc;sold=23159"] = {"沃库诺 <灰舌死誓者军需官>", "黑暗神殿"}
        s["npc;sold=23381"] = {"泰多姆 <失落神器的保管者>", ""}
        s["npc;sold=23428"] = {"霍纳斯 <奥格瑞拉军需官>", "刀锋山"}
        s["npc;sold=25176"] = {"格里金·考伯斯宾 <竞技场商人>", "纳格兰"}
        s["npc;sold=26089"] = {"卡艾莉 <特种装备销售商>", "奎尔丹纳斯岛"}
        s["npc;sold=27668"] = {"安图克·裂角 <竞技场商人>", "沙塔斯城"}
        s["npc;sold=3523"] = {"博文·布里斯博埃斯 <裁缝训练师>", "提瑞斯法林地"}
        s["npc;sold=3703"] = {"克鲁姆·满月 <制皮训练师>", "贫瘠之地"}
        s["object;contained=184465"] = {"军团宝箱", "能源舰"}
        s["object;contained=185119"] = {"灰尘覆盖的箱子", "卡拉赞"}
        s["object;contained=185169"] = {"强化魔铁箱", "地狱火城墙"}
        s["object;contained=185584"] = {"纳因图斯之脊", "黑暗神殿"}
        s["quest;reward=10011"] = {"扫荡铸魔营地", ""}
        s["quest;reward=10091"] = {"灵魂装置", ""}
        s["quest;reward=10136"] = {"阿拉修斯的意图", ""}
        s["quest;reward=10176"] = {"守护者阿尔凯洛斯", ""}
        s["quest;reward=10185"] = {"悲惨的命运", ""}
        s["quest;reward=10188"] = {"克拉苏斯的魔符", ""}
        s["quest;reward=10280"] = {"送往沙塔斯的特殊货物", "虚空风暴"}
        s["quest;reward=10298"] = {"龙族的英雄", ""}
        s["quest;reward=10320"] = {"毁灭纳比留斯！", ""}
        s["quest;reward=10323"] = {"关闭法力熔炉：艾拉", ""}
        s["quest;reward=10337"] = {"奶牛回家", ""}
        s["quest;reward=10345"] = {"血肉会撒谎......", ""}
        s["quest;reward=10353"] = {"贪婪者阿克努斯", ""}
        s["quest;reward=10365"] = {"关闭法力熔炉：艾拉", ""}
        s["quest;reward=10381"] = {"退出奥尔多", ""}
        s["quest;reward=10400"] = {"霸王", ""}
        s["quest;reward=10409"] = {"重创燃烧军团", ""}
        s["quest;reward=10425"] = {"逃离前沿基地", ""}
        s["quest;reward=10439"] = {"诸界吞噬者迪门修斯", ""}
        s["quest;reward=10460"] = {"防御者的契约", ""}
        s["quest;reward=10462"] = {"勇士的契约", ""}
        s["quest;reward=10463"] = {"先知的契约", ""}
        s["quest;reward=10472"] = {"先知的盟约", ""}
        s["quest;reward=10473"] = {"治愈者的盟约", ""}
        s["quest;reward=10474"] = {"勇士的盟约", ""}
        s["quest;reward=10507"] = {"转折点", ""}
        s["quest;reward=10579"] = {"诅咒密码 - 第三块碎片", ""}
        s["quest;reward=10645"] = {"我就是塔隆·血魔......", ""}
        s["quest;reward=10704"] = {"如何杀入禁魔监狱", ""}
        s["quest;reward=10728"] = {"紫罗兰之眼的荣耀", ""}
        s["quest;reward=10745"] = {"胜利的消息", ""}
        s["quest;reward=10769"] = {"散播敌意......", ""}
        s["quest;reward=10781"] = {"火红岗哨之战", ""}
        s["quest;reward=10806"] = {"摊牌", "刀锋山"}
        s["quest;reward=10912"] = {"犬王", ""}
        s["quest;reward=10938"] = {"暗月祝福套牌", ""}
        s["quest;reward=10940"] = {"暗月报复套牌", ""}
        s["quest;reward=10941"] = {"暗月愚人套牌", ""}
        s["quest;reward=11001"] = {"消灭乌鸦之神", ""}
        s["quest;reward=11002"] = {"玛瑟里顿之死", "地狱火半岛"}
        s["quest;reward=11007"] = {"凯尔萨斯和翠绿的魔珠", ""}
        s["quest;reward=11031"] = {"远离大法师之路", ""}
        s["quest;reward=11032"] = {"远离保卫者之路", "逆风小径"}
        s["quest;reward=11033"] = {"远离刺客之路", "逆风小径"}
        s["quest;reward=11041"] = {"未完的工作......", ""}
        s["quest;reward=11092"] = {"你好，指挥官！", ""}
        s["quest;reward=9120"] = {"克尔苏加德的末日", "东瘟疫之地"}
        s["quest;reward=9271"] = {"埃提耶什，守护者的传说之杖", "斯坦索姆"}
        s["quest;reward=9494"] = {"邪能灰烬", ""}
        s["quest;reward=9763"] = {"督军的末日", ""}
        s["quest;reward=9860"] = {"新的指示", ""}
        s["spell;created=17632"] = {"炼金石", "CRAFTING"}
        s["spell;created=23537"] = {"激怒", ""}
        s["spell;created=23773"] = {"神智受难", ""}
        s["spell;created=23786"] = {"特效抗毒药剂", ""}
        s["spell;created=23793"] = {"力量", ""}
        s["spell;created=26752"] = {"魔焰腰带", "CRAFTING"}
        s["spell;created=26753"] = {"魔焰手套", "CRAFTING"}
        s["spell;created=26754"] = {"魔焰长袍", "CRAFTING"}
        s["spell;created=26756"] = {"冰霜暗纹护肩", "CRAFTING"}
        s["spell;created=26757"] = {"冰霜暗纹长靴", "CRAFTING"}
        s["spell;created=26758"] = {"冰霜暗纹外衣", "CRAFTING"}
        s["spell;created=26760"] = {"原始月布腰带", "CRAFTING"}
        s["spell;created=26761"] = {"原始月布护肩", "CRAFTING"}
        s["spell;created=26762"] = {"原始月布长袍", "CRAFTING"}
        s["spell;created=29548"] = {"魔铁板甲战靴", "CRAFTING"}
        s["spell;created=29606"] = {"精金胸甲", "CRAFTING"}
        s["spell;created=29619"] = {"魔钢手套", "CRAFTING"}
        s["spell;created=29620"] = {"魔钢护腿", "CRAFTING"}
        s["spell;created=29621"] = {"魔钢头盔", "CRAFTING"}
        s["spell;created=29622"] = {"铁塔护手", "CRAFTING"}
        s["spell;created=29664"] = {"坚定防御者头盔", "CRAFTING"}
        s["spell;created=29668"] = {"誓言守护者头盔", "CRAFTING"}
        s["spell;created=29671"] = {"绿色要塞护腕", "CRAFTING"}
        s["spell;created=30031"] = {"暴怒", "CRAFTING"}
        s["spell;created=30033"] = {"暴怒", "CRAFTING"}
        s["spell;created=30036"] = {"窃取魔法", "CRAFTING"}
        s["spell;created=30039"] = {"传送", "CRAFTING"}
        s["spell;created=30563"] = {"地精火箭发射器", "CRAFTING"}
        s["spell;created=30569"] = {"侏儒变鸡器", "CRAFTING"}
        s["spell;created=31060"] = {"精致恒金戒指", "CRAFTING"}
        s["spell;created=31070"] = {"恒金饰链", "CRAFTING"}
        s["spell;created=31079"] = {"雕像 - 魔钢野猪", "CRAFTING"}
        s["spell;created=31080"] = {"雕像 - 黎明石螃蟹", "CRAFTING"}
        s["spell;created=31081"] = {"雕像 - 红曜石毒蛇", "CRAFTING"}
        s["spell;created=31435"] = {"浩劫护腕", "CRAFTING"}
        s["spell;created=31440"] = {"永恒披风", "CRAFTING"}
        s["spell;created=31443"] = {"毁灭束带", "CRAFTING"}
        s["spell;created=31448"] = {"坚毅披风", "CRAFTING"}
        s["spell;created=31449"] = {"复仇披风", "CRAFTING"}
        s["spell;created=31452"] = {"法术打击短裤", "CRAFTING"}
        s["spell;created=31454"] = {"白色治愈兜帽", "CRAFTING"}
        s["spell;created=31455"] = {"法术打击兜帽", "CRAFTING"}
        s["spell;created=32494"] = {"魔能皮甲护腿", "CRAFTING"}
        s["spell;created=32495"] = {"厚重裂蹄外套", "CRAFTING"}
        s["spell;created=32497"] = {"厚重裂蹄长靴", "CRAFTING"}
        s["spell;created=32499"] = {"魔能猎手护腕", "CRAFTING"}
        s["spell;created=32756"] = {"阴暗伪装", ""}
        s["spell;created=32774"] = {"复仇者之盾", ""}
        s["spell;created=33173"] = {"强效变形术", ""}
        s["spell;created=33803"] = {"烈焰波", ""}
        s["spell;created=34534"] = {"王者壁垒", "CRAFTING"}
        s["spell;created=34540"] = {"狮心圣剑", "CRAFTING"}
        s["spell;created=34544"] = {"月牙屠斧", "CRAFTING"}
        s["spell;created=34546"] = {"巨龙之喉", "CRAFTING"}
        s["spell;created=35559"] = {"眼镜蛇鳞片手套", "CRAFTING"}
        s["spell;created=35563"] = {"风斩裹手", "CRAFTING"}
        s["spell;created=35576"] = {"黑色虚鳞腰带", "CRAFTING"}
        s["spell;created=35577"] = {"黑色虚鳞护腕", "CRAFTING"}
        s["spell;created=35580"] = {"虚空打击胸甲", "CRAFTING"}
        s["spell;created=35582"] = {"虚空打击腰带", "CRAFTING"}
        s["spell;created=35584"] = {"虚空打击护腕", "CRAFTING"}
        s["spell;created=35585"] = {"风鹰胸甲", "CRAFTING"}
        s["spell;created=35587"] = {"风鹰腰带", "CRAFTING"}
        s["spell;created=35588"] = {"风鹰护腕", "CRAFTING"}
        s["spell;created=35589"] = {"原始打击外衣", "CRAFTING"}
        s["spell;created=35591"] = {"原始打击护腕", "CRAFTING"}
        s["spell;created=36315"] = {"冲击腰带", "CRAFTING"}
        s["spell;created=36317"] = {"冲击长靴", "CRAFTING"}
        s["spell;created=36355"] = {"自然优雅之靴", "CRAFTING"}
        s["spell;created=40744"] = {"埃匹希斯水晶灌注", ""}
        s["spell;created=41160"] = {"迅捷打击护肩", "CRAFTING"}
        s["spell;created=41161"] = {"闪电反射护腕", "CRAFTING"}
        s["spell;created=41163"] = {"生命之地护腕", "CRAFTING"}
        s["spell;created=41205"] = {"敏锐思维护腕", "CRAFTING"}
        s["spell;created=41207"] = {"迅捷治疗护腕", "CRAFTING"}
        s["spell;created=42546"] = {"黑暗披风", "CRAFTING"}
    end
end
