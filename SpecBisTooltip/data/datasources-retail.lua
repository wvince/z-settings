-- By D4KiR
local _, SpecBisTooltip = ...
local s = {}
if SpecBisTooltip:GetBisPool() == "RETAIL" then
    function SpecBisTooltip:GetTranslationMap()
        return s
    end
end

-- SOURCE FROM: 10.09.2026
if SpecBisTooltip:GetBisPool() == "RETAIL" then
    function SpecBisTooltip:TranslationenUS()
        s["item:contained=229129"] = {"Cache of Delver's Spoils", ""}
        s["item:contained=229354"] = {"Algari Adventurer's Cache", ""}
        s["item:contained=235639"] = {"Seasoned Adventurer's Cache", ""}
        s["item:contained=238208"] = {"Nanny's Surge Dividends", ""}
        s["item:contained=262346"] = {"Preyseeker's Champion Chest", ""}
        s["npc;drop=122056"] = {"Viceroy Nezhar", "The Seat of the Triumvirate"}
        s["npc;drop=122313"] = {"Zuraal the Ascended", "The Seat of the Triumvirate"}
        s["npc;drop=122316"] = {"Saprish <Ethereum-Lord of the Shadowguard>", "The Seat of the Triumvirate"}
        s["npc;drop=124729"] = {"L'ura", "The Seat of the Triumvirate"}
        s["npc;drop=128649"] = {"Sergeant Bainbridge", "Siege of Boralus"}
        s["npc;drop=128650"] = {"Chopper Redhook", "Siege of Boralus"}
        s["npc;drop=128651"] = {"Hadal Darkfathom", "Siege of Boralus"}
        s["npc;drop=128652"] = {"Viq'Goth <Terror of the Deep>", "Siege of Boralus"}
        s["npc;drop=129208"] = {"Dread Captain Lockwood", "Siege of Boralus"}
        s["npc;drop=129214"] = {"Coin-Operated Crowd Pummeler", "The MOTHERLODE!!"}
        s["npc;drop=129227"] = {"Azerokk", "The MOTHERLODE!!"}
        s["npc;drop=129231"] = {"Rixxa Fluxflame <Chief Scientist>", "The MOTHERLODE!!"}
        s["npc;drop=131227"] = {"Mogul Razdunk", "The MOTHERLODE!!"}
        s["npc;drop=132713"] = {"Mogul Razdunk", "The MOTHERLODE!!"}
        s["npc;drop=133384"] = {"Merektha", "Temple of Sethraliss"}
        s["npc;drop=133389"] = {"Galvazzt", "Temple of Sethraliss"}
        s["npc;drop=133392"] = {"Avatar of Sethraliss", "Temple of Sethraliss"}
        s["npc;drop=133944"] = {"Aspix", "Temple of Sethraliss"}
        s["npc;drop=134993"] = {"Mchimba the Embalmer", "Kings' Rest"}
        s["npc;drop=135322"] = {"The Golden Serpent", "Kings' Rest"}
        s["npc;drop=136160"] = {"King Dazar <The First>", "Kings' Rest"}
        s["npc;drop=144244"] = {"The Platinum Pummeler", "Operation: Mechagon"}
        s["npc;drop=144246"] = {"K.U.-J.0.", "Operation: Mechagon"}
        s["npc;drop=144248"] = {"Head Machinist Sparkflux", "Operation: Mechagon"}
        s["npc;drop=150159"] = {"King Gobbamak", "Operation: Mechagon"}
        s["npc;drop=150222"] = {"Gunker", "Operation: Mechagon"}
        s["npc;drop=150397"] = {"King Mechagon", "Operation: Mechagon"}
        s["npc;drop=152619"] = {"King Mechagon", "Operation: Mechagon"}
        s["npc;drop=156827"] = {"Echelon", "Halls of Atonement"}
        s["npc;drop=162309"] = {"Kul'tharok", "Theater of Pain"}
        s["npc;drop=162317"] = {"Gorechop", "Theater of Pain"}
        s["npc;drop=162329"] = {"Xav the Unfallen", "Theater of Pain"}
        s["npc;drop=162689"] = {"Surgeon Stitchflesh", "The Necrotic Wake"}
        s["npc;drop=162691"] = {"Blightbone", "The Necrotic Wake"}
        s["npc;drop=162693"] = {"Nalthor the Rimebinder", "The Necrotic Wake"}
        s["npc;drop=163157"] = {"Amarth <The Harvester>", "The Necrotic Wake"}
        s["npc;drop=164185"] = {"Echelon", "Halls of Atonement"}
        s["npc;drop=164218"] = {"Lord Chamberlain", "Halls of Atonement"}
        s["npc;drop=164451"] = {"Dessia the Decapitator", "Theater of Pain"}
        s["npc;drop=164501"] = {"Mistcaller", "Mists of Tirna Scithe"}
        s["npc;drop=164517"] = {"Tred'ova", "Mists of Tirna Scithe"}
        s["npc;drop=164567"] = {"Ingra Maloch", "Mists of Tirna Scithe"}
        s["npc;drop=165408"] = {"Halkias <The Sin-Stained Goliath>", "Halls of Atonement"}
        s["npc;drop=165410"] = {"High Adjudicator Aleez", "Halls of Atonement"}
        s["npc;drop=165946"] = {"Mordretha, the Endless Empress", "Theater of Pain"}
        s["npc;drop=175546"] = {"Timecap'n Hooktail", "Tazavesh, the Veiled Market"}
        s["npc;drop=175616"] = {"Zo'phex <The Sentinel>", "Tazavesh, the Veiled Market"}
        s["npc;drop=175646"] = {"P.O.S.T. Master", "Tazavesh, the Veiled Market"}
        s["npc;drop=175663"] = {"Hylbrande <Sword of the Keepers>", "Tazavesh, the Veiled Market"}
        s["npc;drop=175806"] = {"So'azmi", "Tazavesh, the Veiled Market"}
        s["npc;drop=176556"] = {"Alcruux <The Glutton>", "Tazavesh, the Veiled Market"}
        s["npc;drop=176563"] = {"Zo'gron", "Tazavesh, the Veiled Market"}
        s["npc;drop=176705"] = {"Venza Goldfuse", "Tazavesh, the Veiled Market"}
        s["npc;drop=177269"] = {"So'leah <Cartel So>", "Tazavesh, the Veiled Market"}
        s["npc;drop=188252"] = {"Melidrussa Chillworn <Infusion Specialist>", "Ruby Life Pools"}
        s["npc;drop=189232"] = {"Kokia Blazehoof", "Ruby Life Pools"}
        s["npc;drop=190485"] = {"Erkhart Stormvein", "Ruby Life Pools"}
        s["npc;drop=190609"] = {"Echo of Doragosa <Headteacher>", "Algeth'ar Academy"}
        s["npc;drop=191736"] = {"Crawth", "Algeth'ar Academy"}
        s["npc;drop=194181"] = {"Vexamus", "Algeth'ar Academy"}
        s["npc;drop=196482"] = {"Overgrown Ancient", "Algeth'ar Academy"}
        s["npc;drop=202318"] = {"Response Team Watcher", "Zaralek Cavern"}
        s["npc;drop=203355"] = {"Captain Reykal", "Zaralek Cavern"}
        s["npc;drop=207205"] = {"Stormguard Gorren", "The Rookery"}
        s["npc;drop=207207"] = {"Voidstone Monstrosity", "The Rookery"}
        s["npc;drop=207939"] = {"Baron Braunpyke", "Priory of the Sacred Flame"}
        s["npc;drop=207940"] = {"Prioress Murrpray", "Priory of the Sacred Flame"}
        s["npc;drop=207946"] = {"Captain Dailcry", "Priory of the Sacred Flame"}
        s["npc;drop=208478"] = {"Volcoross", "Amirdrassil, the Dream's Hope"}
        s["npc;drop=208743"] = {"Blazikon", "Darkflame Cleft"}
        s["npc;drop=208745"] = {"The Candle King", "Darkflame Cleft"}
        s["npc;drop=209230"] = {"Kyrioss", "The Rookery"}
        s["npc;drop=210108"] = {"E.D.N.A", "The Stonevault"}
        s["npc;drop=210153"] = {"Ol' Waxbeard", "Darkflame Cleft"}
        s["npc;drop=210156"] = {"Skarmorak", "The Stonevault"}
        s["npc;drop=210267"] = {"I'pa", "Cinderbrew Meadery"}
        s["npc;drop=210271"] = {"Brew Master Aldryr", "Cinderbrew Meadery"}
        s["npc;drop=210797"] = {"The Darkness", "Darkflame Cleft"}
        s["npc;drop=211087"] = {"Speaker Shadowcrown", "The Dawnbreaker"}
        s["npc;drop=211089"] = {"Anub'ikkaj", "The Dawnbreaker"}
        s["npc;drop=213119"] = {"Void Speaker Eirich", "The Stonevault"}
        s["npc;drop=213179"] = {"Avanoxx", "Ara-Kara, City of Echoes"}
        s["npc;drop=213217"] = {"Speaker Brokk", "The Stonevault"}
        s["npc;drop=214502"] = {"The Bloodbound Horror", "Nerub-ar Palace"}
        s["npc;drop=214506"] = {"Broodtwister Ovi'nax", "Nerub-ar Palace"}
        s["npc;drop=214650"] = {"L'ura", "Eredath"}
        s["npc;drop=214661"] = {"Goldie Baronbottom <BEE.E.O.>", "Cinderbrew Meadery"}
        s["npc;drop=215405"] = {"Anub'zekt <Swarmguard>", "Ara-Kara, City of Echoes"}
        s["npc;drop=215407"] = {"Ki'katal the Harvester", "Ara-Kara, City of Echoes"}
        s["npc;drop=215657"] = {"Ulgrax the Devourer", "Nerub-ar Palace"}
        s["npc;drop=216320"] = {"The Coaglamation", "City of Threads"}
        s["npc;drop=216619"] = {"Orator Krix'vizk <The Fifth Strand>", "City of Threads"}
        s["npc;drop=216648"] = {"Nx <Fang of the Queen>", "City of Threads"}
        s["npc;drop=216658"] = {"Izo, the Grand Splicer", "City of Threads"}
        s["npc;drop=217489"] = {"Anub'arash <The Thousand Scars>", "Nerub-ar Palace"}
        s["npc;drop=218002"] = {"Benk Buzzbee <Beekeeper>", "Cinderbrew Meadery"}
        s["npc;drop=219778"] = {"Queen Ansurek", "Nerub-ar Palace"}
        s["npc;drop=219853"] = {"Sikran <Captain of the Sureki>", "Nerub-ar Palace"}
        s["npc;drop=223779"] = {"Anub'arash <The Thousand Scars>", "Nerub-ar Palace"}
        s["npc;drop=223839"] = {"Queen's Guard Ge'zah", "Nerub-ar Palace"}
        s["npc;drop=224552"] = {"Rasha'nan", "Nerub-ar Palace"}
        s["npc;drop=225821"] = {"The Geargrinder <Vexie's War Tank>", "Liberation of Undermine"}
        s["npc;drop=226305"] = {"Emperor Dagran Thaurissan", "Blackrock Depths"}
        s["npc;drop=226306"] = {"Golem Lord Argelmach", "Blackrock Depths"}
        s["npc;drop=226315"] = {"Lord Roccor", "Blackrock Depths"}
        s["npc;drop=226396"] = {"Swampface", "Operation: Floodgate"}
        s["npc;drop=226398"] = {"Big M.O.M.M.A.", "Operation: Floodgate"}
        s["npc;drop=226403"] = {"Keeza Quickfuse", "Operation: Floodgate"}
        s["npc;drop=226404"] = {"Geezle Gigazap", "Operation: Floodgate"}
        s["npc;drop=228458"] = {"One-Armed Bandit", "Liberation of Undermine"}
        s["npc;drop=228470"] = {"Nexus-Princess Ky'veza", "Nerub-ar Palace"}
        s["npc;drop=228652"] = {"Rik Reverb <Official Gallywix Hype Man>", "Liberation of Undermine"}
        s["npc;drop=229181"] = {"Flarendo <The Furious>", "Liberation of Undermine"}
        s["npc;drop=229284"] = {"Guk Boomdog <The Slop Hawker>", "Liberation of Undermine"}
        s["npc;drop=229288"] = {"King Flamespite <Flarendo's Manager>", "Liberation of Undermine"}
        s["npc;drop=229953"] = {"Mug'Zee <Heads of Security>", "Liberation of Undermine"}
        s["npc;drop=229992"] = {"Stalagnarok", "Siren Isle"}
        s["npc;drop=230322"] = {"Stix Bunkjunker", "Liberation of Undermine"}
        s["npc;drop=230583"] = {"Sprocketmonger Lockenstock", "Liberation of Undermine"}
        s["npc;drop=230800"] = {"Slugger the Smart", "Undermine"}
        s["npc;drop=230828"] = {"Chief Foreman Gutso <Venture Co.>", "Undermine"}
        s["npc;drop=230934"] = {"Ratspit <Court of Rats>", "Undermine"}
        s["npc;drop=230946"] = {"V.V. Goosworth <Disgraced Slimeologist>", "Undermine"}
        s["npc;drop=231310"] = {"Darkfuse Precipitant", "Undermine"}
        s["npc;drop=231606"] = {"Emberdawn", "Windrunner Spire"}
        s["npc;drop=231626"] = {"Kalis", "Windrunner Spire"}
        s["npc;drop=231631"] = {"Commander Kroluk <Old Horde>", "Windrunner Spire"}
        s["npc;drop=231636"] = {"Restless Heart", "Windrunner Spire"}
        s["npc;drop=231863"] = {"Seranel Sunlash", "Magisters' Terrace"}
        s["npc;drop=231864"] = {"Gemellus", "Magisters' Terrace"}
        s["npc;drop=231865"] = {"Degentrius", "Magisters' Terrace"}
        s["npc;drop=231981"] = {"Maw of the Sands", "K'aresh"}
        s["npc;drop=233814"] = {"Plexus Sentinel", "Manaforge Omega"}
        s["npc;drop=233815"] = {"Loom'ithar", "Manaforge Omega"}
        s["npc;drop=233816"] = {"Soulbinder Naazindhri", "Manaforge Omega"}
        s["npc;drop=233824"] = {"Dimensius", "Manaforge Omega"}
        s["npc;drop=234647"] = {"Xathuux the Annihilator <Lithiel's Guardian>", "Murder Row"}
        s["npc;drop=234649"] = {"Zaen Bladesorrow", "Murder Row"}
        s["npc;drop=234845"] = {"Sthaarbs <the Mindroiler>", "K'aresh"}
        s["npc;drop=234893"] = {"Azhiccar", "Eco-Dome Al'dani"}
        s["npc;drop=234933"] = {"Taah'bat <The Relentless>", "Eco-Dome Al'dani"}
        s["npc;drop=235853"] = {"Waygate Watcher", "Manaforge Omega"}
        s["npc;drop=237415"] = {"Lithiel Cinderfury", "Murder Row"}
        s["npc;drop=237661"] = {"Adarus Duskblaze", "Manaforge Omega"}
        s["npc;drop=237763"] = {"Nexus-King Salhadaar", "Manaforge Omega"}
        s["npc;drop=237861"] = {"Fractillus <The Shatterer>", "Manaforge Omega"}
        s["npc;drop=238887"] = {"Taz'Rah", "Voidscar Arena"}
        s["npc;drop=239008"] = {"Atroxus", "Voidscar Arena"}
        s["npc;drop=239454"] = {"Darkmage Zadus", "Manaforge Omega"}
        s["npc;drop=240432"] = {"Fallen-King Salhadaar", "The Voidspire"}
        s["npc;drop=240434"] = {"Vorasius", "The Voidspire"}
        s["npc;drop=240435"] = {"Imperator Averzian", "The Voidspire"}
        s["npc;drop=241526"] = {"Chrome King Gallywix", "Liberation of Undermine"}
        s["npc;drop=241546"] = {"Lothraxion <High Commander>", "Nexus-Point Xenas"}
        s["npc;drop=242031"] = {"Spinefrill <The Deadliest Catch>", "Zul'Aman"}
        s["npc;drop=242056"] = {"Vaelgor", "The Voidspire"}
        s["npc;drop=242255"] = {"Geezle Gigazap", "Operation: Floodgate"}
        s["npc;drop=24239"] = {"Hex Lord Malacrass", "The Venomous Abyss"}
        s["npc;drop=243028"] = {"Meittik", "The Blinding Vale"}
        s["npc;drop=244752"] = {"Nexus-Princess Ky'veza", "Voidrazor Sanctuary"}
        s["npc;drop=244761"] = {"Alleria Windrunner", "The Voidspire"}
        s["npc;drop=244762"] = {"Lu'ashal", "Eversong Woods"}
        s["npc;drop=244887"] = {"Ikuzz the Light Hunter", "The Blinding Vale"}
        s["npc;drop=245044"] = {"Nightbrood", "Voidstorm"}
        s["npc;drop=245912"] = {"Lightwarden Ruia", "The Blinding Vale"}
        s["npc;drop=246633"] = {"Harried Hawkstrider", "Eversong Woods"}
        s["npc;drop=246729"] = {"Light Ember <Child of Belo'ren>", "Isle of Quel'Danas"}
        s["npc;drop=247283"] = {"Soul-Scribe", "Eco-Dome Al'dani"}
        s["npc;drop=247570"] = {"Muro'jin", "Maisara Caverns"}
        s["npc;drop=247676"] = {"Ziekket <Gnarled Lightspawn>", "The Blinding Vale"}
        s["npc;drop=247976"] = {"Poacher Rav'ik <Vilebranch Tribe>", "Zul'Aman"}
        s["npc;drop=247989"] = {"Forgeweaver Araz", "Manaforge Omega"}
        s["npc;drop=248015"] = {"Charonus", "Voidscar Arena"}
        s["npc;drop=248595"] = {"Vordaza", "Maisara Caverns"}
        s["npc;drop=248605"] = {"Rak'tul <Vessel of Souls>", "Maisara Caverns"}
        s["npc;drop=248710"] = {"The Hoardmonger <Spiritpaw Tribe>", "Den of Nalorakk"}
        s["npc;drop=248823"] = {"Blackcore", "Voidstorm"}
        s["npc;drop=249844"] = {"Chironex <The Floating Death>", "Harandar"}
        s["npc;drop=250086"] = {"Stumpy <Terror of Harandar>", "Harandar"}
        s["npc;drop=250358"] = {"Annulus the Worldshaker", "Harandar"}
        s["npc;drop=250589"] = {"War Chaplain Senn", "The Voidspire"}
        s["npc;drop=252458"] = {"Kystia Manaheart", "Murder Row"}
        s["npc;drop=252959"] = {"Nymrissa Wavecaller", "The Tidebound Grotto"}
        s["npc;drop=254176"] = {"Rotmire", "Sporefall"}
        s["npc;drop=254227"] = {"Corewarden Nysarra", "Nexus-Point Xenas"}
        s["npc;drop=256116"] = {"Chimaerus <The Undreamt God>", "The Dreamrift"}
        s["npc;drop=257347"] = {"Sszorak", "The Venomous Abyss"}
        s["npc;drop=257361"] = {"Vexhul", "The Venomous Abyss"}
        s["npc;drop=257906"] = {"Coin-Eye Skully", "The Coiled Isle"}
        s["npc;drop=258557"] = {"Breath of Ula'tek", "The Venomous Abyss"}
        s["npc;drop=258877"] = {"Nalorakk <Loa of War>", "Den of Nalorakk"}
        s["npc;drop=258916"] = {"Garsecg <The Hull Render>", "The Coiled Isle"}
        s["npc;drop=259445"] = {"Rav'i", "Altar of Fangs"}
        s["npc;drop=259446"] = {"The Writhing Coil", "Altar of Fangs"}
        s["npc;drop=259447"] = {"Zul'jan", "Altar of Fangs"}
        s["npc;drop=260905"] = {"Burning Venom", "The Venomous Abyss"}
        s["npc;drop=261053"] = {"Sentinel of Winter", "Den of Nalorakk"}
        s["npc;drop=263456"] = {"Szarith the Fanged", ""}
        s["npc;drop=264854"] = {"Farthik the Plunderer", "The Coiled Isle"}
        s["npc;drop=267077"] = {"Mor'zahi", "The Venomous Abyss"}
        s["npc;drop=268090"] = {"Kari'zah the Forgotten", "The Coiled Isle"}
        s["npc;drop=268956"] = {"Ula'tek", "The Venomous Abyss"}
        s["npc;drop=269808"] = {"Aka'ali the Conqueror", "Kings' Rest"}
        s["npc;drop=271337"] = {"Echo of Jawae <Soulcoiler Cult>", "The Venomous Abyss"}
        s["npc;drop=36476"] = {"Ick <Krick's Minion>", "Pit of Saron"}
        s["npc;drop=36494"] = {"Forgemaster Garfrost", "Pit of Saron"}
        s["npc;drop=36658"] = {"Scourgelord Tyrannus", "Pit of Saron"}
        s["npc;drop=39625"] = {"General Umbriss <Servant of Deathwing>", "Grim Batol"}
        s["npc;drop=40177"] = {"Forgemaster Throngus", "Grim Batol"}
        s["npc;drop=40319"] = {"Drahga Shadowburner <Twilight's Hammer Courier>", "Grim Batol"}
        s["npc;drop=40484"] = {"Erudax <The Duke of Below>", "Grim Batol"}
        s["npc;drop=75452"] = {"Bonemaw", "Shadowmoon Burial Grounds"}
        s["npc;drop=75964"] = {"Ranjit <Master of the Four Winds>", "Skyreach"}
        s["npc;drop=76141"] = {"Araknath <Construct of the Sun>", "Skyreach"}
        s["npc;drop=76266"] = {"High Sage Viryx", "Skyreach"}
        s["npc;drop=76379"] = {"Rukhran", "Skyreach"}
        s["npc;sold=219222"] = {"Lalandi <Conquest Quartermaster>", "Dornogal"}
        s["npc;sold=224270"] = {"Ip'xal", "City of Threads"}
        s["npc;sold=227003"] = {"Kir'xal <Collector of Curiosities>", "City of Threads"}
        s["npc;sold=231824"] = {"Kari Bridgeblaster <Junkmaster>", "Undermine"}
        s["npc;sold=243220"] = {"Irissa Bloodstar <Conquest Quartermaster>", "Silvermoon City"}
        s["npc;sold=248303"] = {"Zah'ran <Delve Trinkets>", "Excavation Site 9"}
        s["npc;sold=256670"] = {"Zah'ran <Delve Equipment>", "Collegiate Calamity"}
        s["object;contained=413563"] = {"Heavy Trunk", "Mycomancer Cavern"}
        s["object;contained=413590"] = {"Bountiful Coffer", "The Dread Pit"}
        s["object;contained=416265"] = {"Pilfered Trunk", "The Dread Pit"}
        s["object;contained=476068"] = {"Papa's Prized Putter", "Undermine"}
        s["object;contained=507768"] = {"Jettisoned Pile of Goblin-Bucks", "Sidestreet Sluice"}
        s["object;contained=574407"] = {"Challenger's Cache", "Magisters' Terrace"}
        s["object;contained=574409"] = {"Challenger's Cache", ""}
        s["object;contained=581922"] = {"Hidden Trove", "Collegiate Calamity"}
        s["object;contained=584514"] = {"Bountiful Coffer", "Collegiate Calamity"}
        s["object;contained=584518"] = {"Bountiful Heavy Trunk", "Collegiate Calamity"}
        s["object;contained=584519"] = {"Heavy Trunk", "Collegiate Calamity"}
        s["quest;reward=66119"] = {"Ruby Life Pools: Primalist Invasion", ""}
        s["quest;reward=78232"] = {"Rewriting the Rewritten", ""}
        s["quest;reward=78636"] = {"Retaking the Mines", ""}
        s["quest;reward=79342"] = {"As He Departs", ""}
        s["quest;reward=83125"] = {"Price Hike", "Zuldazar"}
        s["quest;reward=86521"] = {"Nexus-Point Xenas: Eclipse", "Voidstorm"}
        s["quest;reward=91009"] = {"Durable Information Storage Container", "Dornogal"}
        s["quest;reward=91694"] = {"Voidscar Arena: Breaking the Triad", ""}
        s["quest;reward=91958"] = {"Den of Nalorakk: Unforgiven", ""}
        s["quest;reward=93417"] = {"The Vaults of Atal'Utek: Altar of Fangs", ""}
        s["quest;reward=93651"] = {"The Blinding Vale: Lightbloom Roots", ""}
        s["quest;reward=93933"] = {"Guarded Treasures", ""}
        s["spell;created=1228945"] = {"Martyr's Bindings", "CRAFTING"}
        s["spell;created=1228950"] = {"Adherent's Silken Shroud", "CRAFTING"}
        s["spell;created=1228984"] = {"Arcanoweave Bracers", "CRAFTING"}
        s["spell;created=1228985"] = {"Arcanoweave Cloak", "CRAFTING"}
        s["spell;created=1228988"] = {"Arcanoweave Cord", "CRAFTING"}
        s["spell;created=1229427"] = {"[DNT] 12.0 Blacksmithing Recipe Spell Template", ""}
        s["spell;created=1229648"] = {"Blood Knight's Warblade", "CRAFTING"}
        s["spell;created=1229649"] = {"Bloomforged Claw", "CRAFTING"}
        s["spell;created=1229657"] = {"Spellbreaker's Warglaive", "CRAFTING"}
        s["spell;created=1229659"] = {"Farstrider's Mercy", "CRAFTING"}
        s["spell;created=1229662"] = {"Spellbreaker's Bracers", "CRAFTING"}
        s["spell;created=1229875"] = {"Aetherlume Bands", "CRAFTING"}
        s["spell;created=1229877"] = {"Aetherlume Guards", "CRAFTING"}
        s["spell;created=1230061"] = {"Aln'hara Lantern", "CRAFTING"}
        s["spell;created=1230070"] = {"Darkmoon Dominion: Blood", "CRAFTING"}
        s["spell;created=1230071"] = {"Darkmoon Dominion: Rot", "CRAFTING"}
        s["spell;created=1230072"] = {"Darkmoon Dominion: Hunt", "CRAFTING"}
        s["spell;created=1230073"] = {"Darkmoon Dominion: Void", "CRAFTING"}
        s["spell;created=1230479"] = {"Loa Worshiper's Band", "CRAFTING"}
        s["spell;created=1230485"] = {"Masterwork Sin'dorei Band", "CRAFTING"}
        s["spell;created=1230486"] = {"Masterwork Sin'dorei Amulet", "CRAFTING"}
        s["spell;created=1230487"] = {"Signet of Azerothian Blessings", "CRAFTING"}
        s["spell;created=1230861"] = {"Primal Philosopher's Stone", "CRAFTING"}
        s["spell;created=1230885"] = {"Magister's Alchemist Stone", "CRAFTING"}
        s["spell;created=1237508"] = {"Silvermoon Agent's Sneakers", "CRAFTING"}
        s["spell;created=1237509"] = {"Silvermoon Agent's Handwraps", "CRAFTING"}
        s["spell;created=1237513"] = {"Silvermoon Agent's Utility Belt", "CRAFTING"}
        s["spell;created=1237514"] = {"Silvermoon Agent's Deflectors", "CRAFTING"}
        s["spell;created=1237518"] = {"World Tender's Rootslippers", "CRAFTING"}
        s["spell;created=1237519"] = {"World Tender's Barkclasp", "CRAFTING"}
        s["spell;created=1237537"] = {"Farstrider's Razor Talons", "CRAFTING"}
        s["spell;created=1237543"] = {"Farstrider's Plated Bracers", "CRAFTING"}
        s["spell;created=1249111"] = {"Receive Wraps", "CRAFTING"}
        s["spell;created=1253219"] = {"Hunt", "CRAFTING"}
        s["spell;created=1253220"] = {"Void", "CRAFTING"}
        s["spell;created=1253221"] = {"Blood", "CRAFTING"}
        s["spell;created=1253222"] = {"Rot", "CRAFTING"}
        s["spell;created=237828"] = {"Vantus Rune: Demonic Inquisition", ""}
        s["spell;created=239649"] = {"Infernal Crash", ""}
        s["spell;created=244572"] = {"Summon Spirit", ""}
        s["spell;created=244581"] = {"Crashing Comet", ""}
        s["spell;created=244609"] = {"Summon Spirit - Drum Beat", ""}
        s["spell;created=427185"] = {"Algari Alchemist Stone", "CRAFTING"}
        s["spell;created=435382"] = {"Binding of Binding", "CRAFTING"}
        s["spell;created=435384"] = {"Ring of Earthen Craftsmanship", "CRAFTING"}
        s["spell;created=435385"] = {"Amulet of Earthen Craftsmanship", "CRAFTING"}
        s["spell;created=441051"] = {"Rune-Branded Tunic", "CRAFTING"}
        s["spell;created=441052"] = {"Rune-Branded Kickers", "CRAFTING"}
        s["spell;created=441053"] = {"Rune-Branded Grasps", "CRAFTING"}
        s["spell;created=441055"] = {"Rune-Branded Legwraps", "CRAFTING"}
        s["spell;created=441057"] = {"Rune-Branded Waistband", "CRAFTING"}
        s["spell;created=441058"] = {"Rune-Branded Armbands", "CRAFTING"}
        s["spell;created=441060"] = {"Glyph-Etched Stompers", "CRAFTING"}
        s["spell;created=441061"] = {"Glyph-Etched Gauntlets", "CRAFTING"}
        s["spell;created=441063"] = {"Glyph-Etched Cuisses", "CRAFTING"}
        s["spell;created=441065"] = {"Glyph-Etched Binding", "CRAFTING"}
        s["spell;created=441066"] = {"Glyph-Etched Vambraces", "CRAFTING"}
        s["spell;created=444070"] = {"Adrenal Surge Clasp", "CRAFTING"}
        s["spell;created=444197"] = {"Vagabond's Torch", "CRAFTING"}
        s["spell;created=444198"] = {"Vagabond's Careful Crutch", "CRAFTING"}
        s["spell;created=444199"] = {"Vagabond's Bounding Baton", "CRAFTING"}
        s["spell;created=445355"] = {"Scepter of Radiant Magics", "CRAFTING"}
        s["spell;created=446937"] = {"Consecrated Slippers", "CRAFTING"}
        s["spell;created=446938"] = {"Consecrated Cuffs", "CRAFTING"}
        s["spell;created=446939"] = {"Consecrated Cord", "CRAFTING"}
        s["spell;created=446940"] = {"Consecrated Cloak", "CRAFTING"}
        s["spell;created=447314"] = {"Studious Brilliance Expeditor", "CRAFTING"}
        s["spell;created=447315"] = {"Overclocked Idea Generator", "CRAFTING"}
        s["spell;created=447352"] = {"P.0.W. x2", "CRAFTING"}
        s["spell;created=450220"] = {"Everforged Sabatons", "CRAFTING"}
        s["spell;created=450222"] = {"Everforged Greatbelt", "CRAFTING"}
        s["spell;created=450223"] = {"Everforged Defender", "CRAFTING"}
        s["spell;created=450224"] = {"Everforged Helm", "CRAFTING"}
        s["spell;created=450226"] = {"Everforged Vambraces", "CRAFTING"}
        s["spell;created=450229"] = {"Everforged Stabber", "CRAFTING"}
        s["spell;created=450230"] = {"Everforged Dagger", "CRAFTING"}
        s["spell;created=450231"] = {"Everforged Longsword", "CRAFTING"}
        s["spell;created=450232"] = {"Everforged Warglaive", "CRAFTING"}
        s["spell;created=450234"] = {"Everforged Greataxe", "CRAFTING"}
        s["spell;created=450235"] = {"Charged Hexsword", "CRAFTING"}
        s["spell;created=450237"] = {"Charged Facesmasher", "CRAFTING"}
        s["spell;created=450238"] = {"Charged Claymore", "CRAFTING"}
        s["spell;created=450239"] = {"Charged Halberd", "CRAFTING"}
        s["spell;created=450242"] = {"Charged Slicer", "CRAFTING"}
        s["spell;created=455391"] = {"Vivacity", ""}
        s["spell;created=455392"] = {"Symbiosis", ""}
        s["spell;created=455393"] = {"Radiance", ""}
        s["spell;created=455394"] = {"Ascension", ""}
        s["spell;created=473400"] = {"Reconfiguring for Spell Casting", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationdeDE()
        s["item:contained=229129"] = {"Erbeutete Tiefenforscherschätze", ""}
        s["item:contained=229354"] = {"Truhe eines Algariabenteurers", ""}
        s["item:contained=235639"] = {"Truhe eines erfahrenen Abenteurers", ""}
        s["item:contained=238208"] = {"Omis Dividendenüberschuss", ""}
        s["item:contained=262346"] = {"Championtruhe des Beutesuchers", ""}
        s["npc;drop=122056"] = {"Vizekönig Nezhar", "Der Sitz des Triumvirats"}
        s["npc;drop=122313"] = {"Zuraal der Aufgestiegene", "Der Sitz des Triumvirats"}
        s["npc;drop=122316"] = {"Saprish <Astraleumlord der Schattenwache>", "Der Sitz des Triumvirats"}
        s["npc;drop=124729"] = {"L'ura", "Der Sitz des Triumvirats"}
        s["npc;drop=128649"] = {"Unteroffizier Badbrück", "Die Belagerung von Boralus"}
        s["npc;drop=128650"] = {"Rothaken der Häcksler", "Die Belagerung von Boralus"}
        s["npc;drop=128651"] = {"Hadal Dunkelgrund", "Die Belagerung von Boralus"}
        s["npc;drop=128652"] = {"Viq'Goth <Schrecken der Tiefe>", "Die Belagerung von Boralus"}
        s["npc;drop=129208"] = {"Schreckenskapitänin Luebke", "Die Belagerung von Boralus"}
        s["npc;drop=129214"] = {"Münzbetriebener Meuteverprügler", "Das RIESENFLÖZ!!"}
        s["npc;drop=129227"] = {"Azerokk", "Das RIESENFLÖZ!!"}
        s["npc;drop=129231"] = {"Rixxa Fluxflamme <Leitende Wissenschaftlerin>", "Das RIESENFLÖZ!!"}
        s["npc;drop=131227"] = {"Mogul Ratztunk", "Das RIESENFLÖZ!!"}
        s["npc;drop=132713"] = {"Mogul Ratztunk", "Das RIESENFLÖZ!!"}
        s["npc;drop=133384"] = {"Merektha", "Der Tempel von Sethraliss"}
        s["npc;drop=133389"] = {"Galvazzt", "Der Tempel von Sethraliss"}
        s["npc;drop=133392"] = {"Avatar von Sethraliss", "Der Tempel von Sethraliss"}
        s["npc;drop=133944"] = {"Aspix", "Der Tempel von Sethraliss"}
        s["npc;drop=134993"] = {"Mchimba der Balsamierer", "Die Königsruh"}
        s["npc;drop=135322"] = {"Die Goldschlange", "Die Königsruh"}
        s["npc;drop=136160"] = {"König Dazar <Der Erste>", "Die Königsruh"}
        s["npc;drop=144244"] = {"Der Platinprügler", "Operation: Mechagon"}
        s["npc;drop=144248"] = {"Hochmaschinist Funkenstrom", "Operation: Mechagon"}
        s["npc;drop=150159"] = {"König Gobbamak", "Operation: Mechagon"}
        s["npc;drop=150222"] = {"Schmierer", "Operation: Mechagon"}
        s["npc;drop=150397"] = {"König Mechagon", "Operation: Mechagon"}
        s["npc;drop=152619"] = {"König Mechagon", "Operation: Mechagon"}
        s["npc;drop=156827"] = {"Echelon", "Hallen der Sühne"}
        s["npc;drop=162309"] = {"Kul'tharok", "Theater der Schmerzen"}
        s["npc;drop=162317"] = {"Bluthack", "Theater der Schmerzen"}
        s["npc;drop=162329"] = {"Xav der Unbesiegte", "Theater der Schmerzen"}
        s["npc;drop=162689"] = {"Chirurg Fleischnaht", "Die Nekrotische Schneise"}
        s["npc;drop=162691"] = {"Pestknochen", "Die Nekrotische Schneise"}
        s["npc;drop=162693"] = {"Nalthor der Eisbinder", "Die Nekrotische Schneise"}
        s["npc;drop=163157"] = {"Amarth <Der Ernter>", "Die Nekrotische Schneise"}
        s["npc;drop=164185"] = {"Echelon", "Hallen der Sühne"}
        s["npc;drop=164218"] = {"Oberster Kämmerer", "Hallen der Sühne"}
        s["npc;drop=164451"] = {"Dessia die Enthaupterin", "Theater der Schmerzen"}
        s["npc;drop=164501"] = {"Nebelruferin", "Die Nebel von Tirna Scithe"}
        s["npc;drop=164517"] = {"Tred'ova", "Die Nebel von Tirna Scithe"}
        s["npc;drop=164567"] = {"Ingra Maloch", "Die Nebel von Tirna Scithe"}
        s["npc;drop=165408"] = {"Halkias <Der Sündenbefleckte Goliath>", "Hallen der Sühne"}
        s["npc;drop=165410"] = {"Hochadjudikatorin Aleez", "Hallen der Sühne"}
        s["npc;drop=165946"] = {"Mordretha, die Unendliche Kaiserin", "Theater der Schmerzen"}
        s["npc;drop=175546"] = {"Zeitkäpt'n Hakenschwanz", "Tazavesh, der Verhüllte Markt"}
        s["npc;drop=175616"] = {"Zo'phex <Der Hüter>", "Tazavesh, der Verhüllte Markt"}
        s["npc;drop=175646"] = {"P.O.S.T.-Meister", "Tazavesh, der Verhüllte Markt"}
        s["npc;drop=175663"] = {"Hylbrand <Schwert der Hüter>", "Tazavesh, der Verhüllte Markt"}
        s["npc;drop=175806"] = {"So'azmi", "Tazavesh, der Verhüllte Markt"}
        s["npc;drop=176556"] = {"Alcruux <Der Nimmersatt>", "Tazavesh, der Verhüllte Markt"}
        s["npc;drop=176563"] = {"Zo'gron", "Tazavesh, der Verhüllte Markt"}
        s["npc;drop=176705"] = {"Venza Goldschmelz", "Tazavesh, der Verhüllte Markt"}
        s["npc;drop=177269"] = {"So'leah <Kartell So>", "Tazavesh, der Verhüllte Markt"}
        s["npc;drop=188252"] = {"Melidrussa die Unterkühlte <Infusionsspezialistin>", "Rubinlebensbecken"}
        s["npc;drop=189232"] = {"Kokia Feuerhuf", "Rubinlebensbecken"}
        s["npc;drop=190485"] = {"Erkhart Sturmader", "Rubinlebensbecken"}
        s["npc;drop=190609"] = {"Echo von Doragosa <Direktorin>", "Akademie von Algeth'ar"}
        s["npc;drop=191736"] = {"Kraas", "Akademie von Algeth'ar"}
        s["npc;drop=194181"] = {"Vexamus", "Akademie von Algeth'ar"}
        s["npc;drop=196482"] = {"Überwuchertes Urtum", "Akademie von Algeth'ar"}
        s["npc;drop=202318"] = {"Hüterin der Eingreiftruppe", "Zaralekhöhle"}
        s["npc;drop=203355"] = {"Hauptmann Reykal", "Zaralekhöhle"}
        s["npc;drop=207205"] = {"Sturmwache Gorren", "Die Brutstätte"}
        s["npc;drop=207207"] = {"Leerensteinmonstrosität", "Die Brutstätte"}
        s["npc;drop=207939"] = {"Baron Braunspyß", "Priorat der Heiligen Flamme"}
        s["npc;drop=207940"] = {"Priorin Murrbet", "Priorat der Heiligen Flamme"}
        s["npc;drop=207946"] = {"Hauptmann Talschrei", "Priorat der Heiligen Flamme"}
        s["npc;drop=208478"] = {"Volcoross", "Amirdrassil, Hoffnung des Traums"}
        s["npc;drop=208743"] = {"Lohenzar", "Dunkelflammenspalt"}
        s["npc;drop=208745"] = {"Der Kerzenkönig", "Dunkelflammenspalt"}
        s["npc;drop=209230"] = {"Kyrioss", "Die Brutstätte"}
        s["npc;drop=210108"] = {"I.N.G.A.", "Das Steingewölbe"}
        s["npc;drop=210153"] = {"Alter Wachsbart", "Dunkelflammenspalt"}
        s["npc;drop=210156"] = {"Skarmorak", "Das Steingewölbe"}
        s["npc;drop=210267"] = {"I'pa", "Metbrauerei Glutbräu"}
        s["npc;drop=210271"] = {"Braumeister Aldryr", "Metbrauerei Glutbräu"}
        s["npc;drop=210797"] = {"Die Finsternis", "Dunkelflammenspalt"}
        s["npc;drop=211087"] = {"Sprecherin Schattenkrone", "Die Morgenbringer"}
        s["npc;drop=211089"] = {"Anub'ikkaj", "Die Morgenbringer"}
        s["npc;drop=213119"] = {"Leerensprecher Eirich", "Das Steingewölbe"}
        s["npc;drop=213179"] = {"Avanoxx", "Ara-Kara, Stadt der Echos"}
        s["npc;drop=213217"] = {"Sprecher Brokk", "Das Steingewölbe"}
        s["npc;drop=214502"] = {"Der blutgebundene Schrecken", "Palast der Nerub'ar"}
        s["npc;drop=214506"] = {"Brutverderber Ovi'nax", "Palast der Nerub'ar"}
        s["npc;drop=214661"] = {"Goldie Barontasch <BIEN.E.O.>", "Metbrauerei Glutbräu"}
        s["npc;drop=215405"] = {"Anub'zekt <Schwarmwache>", "Ara-Kara, Stadt der Echos"}
        s["npc;drop=215407"] = {"Ki'katal die Ernterin", "Ara-Kara, Stadt der Echos"}
        s["npc;drop=215657"] = {"Ulgrax der Verschlinger", "Palast der Nerub'ar"}
        s["npc;drop=216320"] = {"Das Koaglamat", "Stadt der Fäden"}
        s["npc;drop=216619"] = {"Orator Krix'vizk <Der fünfte Strang>", "Stadt der Fäden"}
        s["npc;drop=216648"] = {"Nx <Fangzahn der Königin>", "Stadt der Fäden"}
        s["npc;drop=216658"] = {"Izo, die große Verbinderin", "Stadt der Fäden"}
        s["npc;drop=217489"] = {"Anub'arash <Die Tausend Narben>", "Palast der Nerub'ar"}
        s["npc;drop=218002"] = {"Benk Sumsebrumm <Imker>", "Metbrauerei Glutbräu"}
        s["npc;drop=219778"] = {"Königin Ansurek", "Palast der Nerub'ar"}
        s["npc;drop=219853"] = {"Sikran <Hauptmann der Sureki>", "Palast der Nerub'ar"}
        s["npc;drop=223779"] = {"Anub'arash <Die Tausend Narben>", "Palast der Nerub'ar"}
        s["npc;drop=223839"] = {"Königinnenwache Ge'zah", "Palast der Nerub'ar"}
        s["npc;drop=224552"] = {"Rasha'nan", "Die Morgenbringer"}
        s["npc;drop=225821"] = {"[The Geargrinder]", "Befreiung von Lorenhall"}
        s["npc;drop=226305"] = {"[Emperor Dagran Thaurissan]", "Schwarzfelstiefen"}
        s["npc;drop=226306"] = {"[Golem Lord Argelmach]", "Schwarzfelstiefen"}
        s["npc;drop=226315"] = {"[Lord Roccor]", "Schwarzfelstiefen"}
        s["npc;drop=226396"] = {"[Swampface]", "Operation: Schleuse"}
        s["npc;drop=226398"] = {"[Big M.O.M.M.A.]", "Operation: Schleuse"}
        s["npc;drop=226403"] = {"[Keeza Quickfuse]", "Operation: Schleuse"}
        s["npc;drop=226404"] = {"Giesel Gigaschock", "Operation: Schleuse"}
        s["npc;drop=228458"] = {"[One-Armed Bandit]", "Befreiung von Lorenhall"}
        s["npc;drop=228470"] = {"Nexusprinzessin Ky'veza", "Palast der Nerub'ar"}
        s["npc;drop=228652"] = {"[Rik Reverb]", "Befreiung von Lorenhall"}
        s["npc;drop=229181"] = {"[Flarendo]", "Befreiung von Lorenhall"}
        s["npc;drop=229284"] = {"Guk Bummhund <Der Grützehändler>", "Befreiung von Lorenhall"}
        s["npc;drop=229288"] = {"König Bösflamme <Leuchtendos Manager>", "Befreiung von Lorenhall"}
        s["npc;drop=229953"] = {"[Mug'Zee]", "Befreiung von Lorenhall"}
        s["npc;drop=229992"] = {"Stalagnarok", "Sireneninsel"}
        s["npc;drop=230322"] = {"[Stix Bunkjunker]", "Befreiung von Lorenhall"}
        s["npc;drop=230583"] = {"[Sprocketmonger Lockenstock]", "Befreiung von Lorenhall"}
        s["npc;drop=230800"] = {"[Slugger the Smart]", "Lorenhall"}
        s["npc;drop=230828"] = {"[Chief Foreman Gutso]", "Lorenhall"}
        s["npc;drop=230934"] = {"[Ratspit]", "Lorenhall"}
        s["npc;drop=230946"] = {"[V.V. Goosworth]", "Lorenhall"}
        s["npc;drop=231310"] = {"Fällmittel der Düsternisverschmolzenen", "Lorenhall"}
        s["npc;drop=231606"] = {"Dämmerglut", "Windläuferturm"}
        s["npc;drop=231626"] = {"Kalis", "Windläuferturm"}
        s["npc;drop=231631"] = {"Kommandant Kroluk <Alte Horde>", "Windläuferturm"}
        s["npc;drop=231636"] = {"Rastloses Herz", "Windläuferturm"}
        s["npc;drop=231863"] = {"Seranel Sonnenpeitsche", "Terrasse der Magister"}
        s["npc;drop=231864"] = {"Gemellus", "Terrasse der Magister"}
        s["npc;drop=231865"] = {"Degentrius", "Terrasse der Magister"}
        s["npc;drop=231981"] = {"Schlund der Sande", "K'aresh"}
        s["npc;drop=233814"] = {"Plexuswache", "Die Manaschmiede Omega"}
        s["npc;drop=233815"] = {"Loom'ithar", "Die Manaschmiede Omega"}
        s["npc;drop=233816"] = {"Seelenbinderin Naazindhri", "Die Manaschmiede Omega"}
        s["npc;drop=233824"] = {"Dimensius", "Die Manaschmiede Omega"}
        s["npc;drop=234647"] = {"Xathuux der Vernichter <Lithiels Wächter>", "Mördergasse"}
        s["npc;drop=234649"] = {"Zaen Klingentrauer", "Mördergasse"}
        s["npc;drop=234845"] = {"Sthaarbs <der Geisttrüber>", "K'aresh"}
        s["npc;drop=234893"] = {"Azhiccar", "Die Biokuppel Al'dani"}
        s["npc;drop=234933"] = {"Taah'bat <Die Erbarmungslosen>", "Die Biokuppel Al'dani"}
        s["npc;drop=235853"] = {"Torbeobachter", "Die Manaschmiede Omega"}
        s["npc;drop=237415"] = {"Lithiel Glutzorn", "Mördergasse"}
        s["npc;drop=237661"] = {"Adarus Dämmerflamme", "Die Manaschmiede Omega"}
        s["npc;drop=237763"] = {"Nexuskönig Salhadaar", "Die Manaschmiede Omega"}
        s["npc;drop=237861"] = {"Fractillus <[The Shatterer]>", "Die Manaschmiede Omega"}
        s["npc;drop=238887"] = {"Taz'Rah", "Arena der Leerennarbe"}
        s["npc;drop=239008"] = {"Atroxus", "Arena der Leerennarbe"}
        s["npc;drop=239454"] = {"Dunkelmagier Zadus", "Die Manaschmiede Omega"}
        s["npc;drop=240432"] = {"Gefallener König Salhadaar", "Die Leerenspitze"}
        s["npc;drop=240434"] = {"Vorasius", "Die Leerenspitze"}
        s["npc;drop=240435"] = {"Imperator Averzian", "Die Leerenspitze"}
        s["npc;drop=241526"] = {"[Chrome King Gallywix]", "Befreiung von Lorenhall"}
        s["npc;drop=241546"] = {"Lothraxion <Oberkommandant>", ""}
        s["npc;drop=242031"] = {"Stachelkragen <Der tödlichste Fang>", "Zul'Aman"}
        s["npc;drop=242056"] = {"Vaelgor", "Die Leerenspitze"}
        s["npc;drop=242255"] = {"[Geezle Gigazap]", "Operation: Schleuse"}
        s["npc;drop=24239"] = {"Hexlord Malacrass", "Der Giftige Abgrund"}
        s["npc;drop=243028"] = {"Meittik", "Das blendende Tal"}
        s["npc;drop=244752"] = {"Nexusprinzessin Ky'veza", "Das Leerenmesserrefugium"}
        s["npc;drop=244761"] = {"Alleria Windläufer", "Die Leerenspitze"}
        s["npc;drop=244762"] = {"Lu'ashal", "Immersangwald"}
        s["npc;drop=244887"] = {"Ikuzz der Lichtjäger", "Das blendende Tal"}
        s["npc;drop=245044"] = {"Nachtbrut", "Leerensturm"}
        s["npc;drop=245912"] = {"Lichthüter Ruia", "Das blendende Tal"}
        s["npc;drop=246633"] = {"Gehetzter Falkenschreiter", "Immersangwald"}
        s["npc;drop=246729"] = {"Lichtglut <Kind von Belo'ren>", "Insel von Quel'Danas"}
        s["npc;drop=247283"] = {"Seelenschreiberin", "Die Biokuppel Al'dani"}
        s["npc;drop=247570"] = {"Muro'jin", "Maisarakavernen"}
        s["npc;drop=247676"] = {"Ziekket <Verwachsene Lichtbrut>", "Das blendende Tal"}
        s["npc;drop=247976"] = {"Wilderer Rav'ik <Stamm der Blutfratzen>", "Zul'Aman"}
        s["npc;drop=247989"] = {"Schmiedeweber Araz", "Die Manaschmiede Omega"}
        s["npc;drop=248015"] = {"Charonus", "Arena der Leerennarbe"}
        s["npc;drop=248595"] = {"Vordaza", "Maisarakavernen"}
        s["npc;drop=248605"] = {"Rak'tul <Gefäß der Seelen>", "Maisarakavernen"}
        s["npc;drop=248710"] = {"Der Hortraffer <Stamm der Geisterpfoten>", "Nalorakks Bau"}
        s["npc;drop=248823"] = {"Schwarzkern", "Leerensturm"}
        s["npc;drop=249844"] = {"Chironex <Der schwebende Tod>", "Harandar"}
        s["npc;drop=250086"] = {"Stubbe <Schrecken von Harandar>", "Harandar"}
        s["npc;drop=250358"] = {"Annulus der Weltenerschütterer", "Harandar"}
        s["npc;drop=250589"] = {"Kriegskaplanin Senn", "Die Leerenspitze"}
        s["npc;drop=252458"] = {"Kystia Manaherz", "Mördergasse"}
        s["npc;drop=252959"] = {"Nymrissa Wellenrufer", "Die Gezeitengebundene Grotte"}
        s["npc;drop=254176"] = {"Rottmoor", "Sporenfall"}
        s["npc;drop=254227"] = {"Kernwächterin Nysarra", "Nexuspunkt Xenas"}
        s["npc;drop=256116"] = {"Chimaerus <Der ungeträumte Gott>", "Der Traumriss"}
        s["npc;drop=257347"] = {"Sszorak", "Der Giftige Abgrund"}
        s["npc;drop=257361"] = {"Vexhul", "Der Giftige Abgrund"}
        s["npc;drop=257906"] = {"Münzauge Skully", "Die Gewundene Insel"}
        s["npc;drop=258557"] = {"Atem von Ula'tek", "Der Giftige Abgrund"}
        s["npc;drop=258877"] = {"Nalorakk <Loa des Krieges>", "Nalorakks Bau"}
        s["npc;drop=258916"] = {"Garsecg <Der Rumpfreißer>", "Die Gewundene Insel"}
        s["npc;drop=259445"] = {"Rav'i", "Der Altar der Fänge"}
        s["npc;drop=259446"] = {"Das windende Knäuel", "Der Altar der Fänge"}
        s["npc;drop=259447"] = {"Zul'jan", "Der Altar der Fänge"}
        s["npc;drop=260905"] = {"Brennendes Gift", "Der Giftige Abgrund"}
        s["npc;drop=261053"] = {"Winterwache", "Nalorakks Bau"}
        s["npc;drop=263456"] = {"Szarith der Bezahnte", ""}
        s["npc;drop=264854"] = {"Farthik die Brandschatzerin", "Die Gewundene Insel"}
        s["npc;drop=267077"] = {"Mor'zahi", "Der Giftige Abgrund"}
        s["npc;drop=268090"] = {"Kari'zah der Vergessene", "Die Gewundene Insel"}
        s["npc;drop=268956"] = {"Ula'tek", "Der Giftige Abgrund"}
        s["npc;drop=269808"] = {"Aka'ali die Bezwingerin", "Die Königsruh"}
        s["npc;drop=271337"] = {"Echo of Jawae <[Soulcoiler Cult]>", "Der Giftige Abgrund"}
        s["npc;drop=36476"] = {"Ick <Kricks Diener>", "Die Grube von Saron"}
        s["npc;drop=36494"] = {"Schmiedemeister Garfrost", "Die Grube von Saron"}
        s["npc;drop=36658"] = {"Geißelfürst Tyrannus", "Die Grube von Saron"}
        s["npc;drop=39625"] = {"General Umbriss <Diener von Todesschwinge>", "Grim Batol"}
        s["npc;drop=40177"] = {"Schmiedemeister Throngus", "Grim Batol"}
        s["npc;drop=40319"] = {"Drahga Schattenbrenner <Kurier des Schattenhammers>", "Grim Batol"}
        s["npc;drop=40484"] = {"Erudax <Der Herzog der Tiefe>", "Grim Batol"}
        s["npc;drop=75452"] = {"Knochenschlund", "Schattenmondgrabstätte"}
        s["npc;drop=75964"] = {"Ranjit <Herr der vier Winde>", "Himmelsnadel"}
        s["npc;drop=76141"] = {"Araknath <Konstrukt der Sonne>", "Himmelsnadel"}
        s["npc;drop=76266"] = {"Oberste Weise Viryx", "Himmelsnadel"}
        s["npc;drop=76379"] = {"Rukhran", "Himmelsnadel"}
        s["npc;sold=219222"] = {"Lalandi <Rüstmeister für Eroberungspunkte>", "Dornogal"}
        s["npc;sold=224270"] = {"Ip'xal <Ausstatterin des Helden>", "Stadt der Fäden"}
        s["npc;sold=227003"] = {"Kir'xal <Kuriositätensammlerin>", "Stadt der Fäden"}
        s["npc;sold=231824"] = {"[Kari Bridgeblaster]", "Lorenhall"}
        s["npc;sold=243220"] = {"Irissa Blutstern <Rüstmeisterin für Eroberungspunkte>", "Silbermond"}
        s["npc;sold=248303"] = {"Zah'ran <[Delve Trinkets]>", "Ausgrabungsstätte 9"}
        s["npc;sold=256670"] = {"Zah'ran <Tiefenausrüstung>", "Akademischer Aufruhr"}
        s["object;contained=413563"] = {"Schwere Truhe", "Mykomantenhöhle"}
        s["object;contained=413590"] = {"Großzügiger Kasten", "Der Terrorschacht"}
        s["object;contained=416265"] = {"Stibitzte Truhe", "Der Terrorschacht"}
        s["object;contained=476068"] = {"[Papa's Prized Putter]", "Lorenhall"}
        s["object;contained=507768"] = {"Über Bord geworfener Haufen Goblinkohle", "Ausgrabungsstätte 9"}
        s["object;contained=574407"] = {"Schatz des Herausforderers", "Terrasse der Magister"}
        s["object;contained=574409"] = {"Schatz des Herausforderers", ""}
        s["object;contained=581922"] = {"Versteckter Schatz", "Akademischer Aufruhr"}
        s["object;contained=584514"] = {"Großzügiger Kasten", "Akademischer Aufruhr"}
        s["object;contained=584518"] = {"Großzügige schwere Truhe", "Akademischer Aufruhr"}
        s["object;contained=584519"] = {"Schwere Truhe", "Akademischer Aufruhr"}
        s["quest;reward=66119"] = {"Rubinlebensbecken: Invasion der Primalisten", ""}
        s["quest;reward=78232"] = {"Manipulation der Manipulierten", ""}
        s["quest;reward=78636"] = {"Rückeroberung der Minen", ""}
        s["quest;reward=79342"] = {"Als er geht", ""}
        s["quest;reward=83125"] = {"", "Zuldazar"}
        s["quest;reward=86521"] = {"Nexuspunkt Xenas: Finsternis", "Leerensturm"}
        s["quest;reward=91009"] = {"Dateninformationssicherungsbehältnis", "Dornogal"}
        s["quest;reward=91694"] = {"Arena der Leerennarbe: Die Triade zerbrechen", ""}
        s["quest;reward=91958"] = {"Nalorakks Bau: Unvergessen", ""}
        s["quest;reward=93417"] = {"Die Kammern von Atal'Utek: Altar der Fänge", ""}
        s["quest;reward=93651"] = {"Das blendende Tal: Lichtblütenwurzeln", ""}
        s["quest;reward=93933"] = {"Bewachte Schätze", "Leerensturm"}
        s["spell;created=1228945"] = {"Bindungen des Märtyrers", "CRAFTING"}
        s["spell;created=1228950"] = {"Seidenschleier des Anhängers", "CRAFTING"}
        s["spell;created=1228984"] = {"Arkanostoffarmschienen", "CRAFTING"}
        s["spell;created=1228985"] = {"Arkanostoffumhang", "CRAFTING"}
        s["spell;created=1228988"] = {"Arkanostoffkordel", "CRAFTING"}
        s["spell;created=1229648"] = {"Blutritterkriegsklinge", "CRAFTING"}
        s["spell;created=1229649"] = {"Blütengeschmiedete Klaue", "CRAFTING"}
        s["spell;created=1229657"] = {"Kriegsgleve des Zauberbrechers", "CRAFTING"}
        s["spell;created=1229659"] = {"Gnade des Weltenwanderers", "CRAFTING"}
        s["spell;created=1229662"] = {"Armschienen des Zauberbrechers", "CRAFTING"}
        s["spell;created=1229875"] = {"Ätherlichtbänder", "CRAFTING"}
        s["spell;created=1229877"] = {"Ätherlichtarmschutz", "CRAFTING"}
        s["spell;created=1230061"] = {"Laterne von Aln'hara", "CRAFTING"}
        s["spell;created=1230070"] = {"Dunkelmondherrschaft: Blut", "CRAFTING"}
        s["spell;created=1230071"] = {"Dunkelmondherrschaft: Fäulnis", "CRAFTING"}
        s["spell;created=1230072"] = {"Dunkelmondherrschaft: Jagd", "CRAFTING"}
        s["spell;created=1230073"] = {"Dunkelmondherrschaft: Leere", "CRAFTING"}
        s["spell;created=1230479"] = {"Ring des Loaanbeters", "CRAFTING"}
        s["spell;created=1230485"] = {"Meisterlicher Ring der Sin'dorei", "CRAFTING"}
        s["spell;created=1230486"] = {"Meisterliches Amulett der Sin'dorei", "CRAFTING"}
        s["spell;created=1230487"] = {"Signet der Segen von Azeroth", "CRAFTING"}
        s["spell;created=1230861"] = {"Urtümlicher Stein der Weisen", "CRAFTING"}
        s["spell;created=1230885"] = {"Alchemistenstein des Magisters", "CRAFTING"}
        s["spell;created=1237508"] = {"Schleichschuhe des Silbermondagenten", "CRAFTING"}
        s["spell;created=1237509"] = {"Handlappen des Silbermondagenten", "CRAFTING"}
        s["spell;created=1237513"] = {"Werkzeuggürtel des Silbermondagenten", "CRAFTING"}
        s["spell;created=1237514"] = {"Deflektoren des Silbermondagenten", "CRAFTING"}
        s["spell;created=1237518"] = {"Wurzelpantoffeln des Weltenwächters", "CRAFTING"}
        s["spell;created=1237519"] = {"Rindenschnalle des Weltenwächters", "CRAFTING"}
        s["spell;created=1237537"] = {"Messerkrallen des Weltenwanderers", "CRAFTING"}
        s["spell;created=1237543"] = {"Plattenarmschienen des Weltenwanderers", "CRAFTING"}
        s["spell;created=1249111"] = {"Wickel erhalten", "CRAFTING"}
        s["spell;created=1253219"] = {"Jagd", ""}
        s["spell;created=1253220"] = {"Leere", ""}
        s["spell;created=1253221"] = {"Blut", "CRAFTING"}
        s["spell;created=1253222"] = {"Fäulnis", "CRAFTING"}
        s["spell;created=237828"] = {"Vantusrune: Die dämonische Inquisition", ""}
        s["spell;created=239649"] = {"Höllenbestieneinschlag", ""}
        s["spell;created=244572"] = {"Geist beschwören", ""}
        s["spell;created=244581"] = {"Krachender Komet", ""}
        s["spell;created=244609"] = {"Geist beschwören - Trommelschlag", ""}
        s["spell;created=427185"] = {"Algarischer Alchemistenstein", "CRAFTING"}
        s["spell;created=435382"] = {"Bindung der Bindung", "CRAFTING"}
        s["spell;created=435384"] = {"Ring der irdenen Handwerkskunst", "CRAFTING"}
        s["spell;created=435385"] = {"Amulett der irdenen Handwerkskunst", "CRAFTING"}
        s["spell;created=441051"] = {"Runengezeichnete Tunika", "CRAFTING"}
        s["spell;created=441052"] = {"Runengezeichnete Treter", "CRAFTING"}
        s["spell;created=441053"] = {"Runengezeichneter Handschutz", "CRAFTING"}
        s["spell;created=441055"] = {"Runengezeichnete Beinwickel", "CRAFTING"}
        s["spell;created=441057"] = {"Runengezeichneter Gürtelbund", "CRAFTING"}
        s["spell;created=441058"] = {"Runengezeichnete Armbinden", "CRAFTING"}
        s["spell;created=441060"] = {"Glyphengravierte Stampfer", "CRAFTING"}
        s["spell;created=441061"] = {"Glyphengravierte Stulpen", "CRAFTING"}
        s["spell;created=441063"] = {"Glyphengravierte Beinschienen", "CRAFTING"}
        s["spell;created=441065"] = {"Glyphengravierte Bindungen", "CRAFTING"}
        s["spell;created=441066"] = {"Glyphengravierte Unterarmschienen", "CRAFTING"}
        s["spell;created=444070"] = {"Schnalle des Adrenalinschubs", "CRAFTING"}
        s["spell;created=444197"] = {"Fackel des Vagabunden", "CRAFTING"}
        s["spell;created=444198"] = {"Kompakte Krücke des Vagabunden", "CRAFTING"}
        s["spell;created=444199"] = {"Belebter Baton des Vagabunden", "CRAFTING"}
        s["spell;created=445355"] = {"Szepter der strahlenden Magie", "CRAFTING"}
        s["spell;created=446937"] = {"Geweihte Pantoffeln", "CRAFTING"}
        s["spell;created=446938"] = {"Geweihte Manschetten", "CRAFTING"}
        s["spell;created=446939"] = {"Geweihte Kordel", "CRAFTING"}
        s["spell;created=446940"] = {"Geweihter Umhang", "CRAFTING"}
        s["spell;created=447314"] = {"Gelehriger Brillanzbeschleuniger", "CRAFTING"}
        s["spell;created=447315"] = {"Übertakteter Ideengenerator", "CRAFTING"}
        s["spell;created=447352"] = {"W.U.M.M.S. x2", "CRAFTING"}
        s["spell;created=450220"] = {"Ewiggeschmiedete Sabatons", "CRAFTING"}
        s["spell;created=450222"] = {"Ewiggeschmiedeter Großgürtel", "CRAFTING"}
        s["spell;created=450223"] = {"Ewiggeschmiedeter Verteidiger", "CRAFTING"}
        s["spell;created=450224"] = {"Ewiggeschmiedeter Helm", "CRAFTING"}
        s["spell;created=450226"] = {"Ewiggeschmiedete Unterarmschienen", "CRAFTING"}
        s["spell;created=450229"] = {"Ewiggeschmiedeter Stecher", "CRAFTING"}
        s["spell;created=450230"] = {"Ewiggeschmiedeter Dolch", "CRAFTING"}
        s["spell;created=450231"] = {"Ewiggeschmiedetes Langschwert", "CRAFTING"}
        s["spell;created=450232"] = {"Ewiggeschmiedete Kriegsgleve", "CRAFTING"}
        s["spell;created=450234"] = {"Ewiggeschmiedete Großaxt", "CRAFTING"}
        s["spell;created=450235"] = {"Geladenes Hexerschwert", "CRAFTING"}
        s["spell;created=450237"] = {"Geladener Kieferbrecher", "CRAFTING"}
        s["spell;created=450238"] = {"Geladenes Claymore", "CRAFTING"}
        s["spell;created=450239"] = {"Geladene Hellebarde", "CRAFTING"}
        s["spell;created=450242"] = {"Geladener Schlitzer", "CRAFTING"}
        s["spell;created=455391"] = {"Lebhaftigkeit", ""}
        s["spell;created=455392"] = {"Symbiose", ""}
        s["spell;created=455393"] = {"Strahlen", ""}
        s["spell;created=455394"] = {"Aszendenz", ""}
        s["spell;created=473400"] = {"Für Zauberwirken rekonfigurieren", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationesES()
        s["item:contained=229129"] = {"Alijo de botín de las profundidades", ""}
        s["item:contained=229354"] = {"Alijo de aventurero algariano", ""}
        s["item:contained=235639"] = {"Alijo de aventurero experimentado", ""}
        s["item:contained=238208"] = {"Grandes dividendos de Nana", ""}
        s["item:contained=262346"] = {"Cofre de campeón de buscapresas", ""}
        s["npc;drop=122056"] = {"Virrey Nezhar", "Trono del Triunvirato"}
        s["npc;drop=122313"] = {"Zuraal el Ascendido", "Trono del Triunvirato"}
        s["npc;drop=122316"] = {"Saprish <Señor del Etereum de la Guardia de las Sombras>", "Trono del Triunvirato"}
        s["npc;drop=124729"] = {"L'ura", "Trono del Triunvirato"}
        s["npc;drop=128649"] = {"Sargento Bainbridge", "Asedio de Boralus"}
        s["npc;drop=128650"] = {"Cortador Ganchorrojo", "Asedio de Boralus"}
        s["npc;drop=128651"] = {"Hadal Brazasombría", "Asedio de Boralus"}
        s["npc;drop=128652"] = {"Viq'Goth <Terror de las profundidades>", "Asedio de Boralus"}
        s["npc;drop=129208"] = {"Capitana aterradora Lockwood", "Asedio de Boralus"}
        s["npc;drop=129214"] = {"Repartetundas de pago", "VETA MADRE"}
        s["npc;drop=129227"] = {"Azerokk", "VETA MADRE"}
        s["npc;drop=129231"] = {"Rixxa Flujollama <Jefa científica>", "VETA MADRE"}
        s["npc;drop=131227"] = {"Mogul Razdunk", "VETA MADRE"}
        s["npc;drop=132713"] = {"Mogul Razdunk", "VETA MADRE"}
        s["npc;drop=133384"] = {"Merektha", "Templo de Sethraliss"}
        s["npc;drop=133389"] = {"Galvazzt", "Templo de Sethraliss"}
        s["npc;drop=133392"] = {"Avatar de Sethraliss", "Templo de Sethraliss"}
        s["npc;drop=133944"] = {"Aspix", "Templo de Sethraliss"}
        s["npc;drop=134993"] = {"Mchimba el Embalsamador", "Reposo de los Reyes"}
        s["npc;drop=135322"] = {"Serpiente dorada", "Reposo de los Reyes"}
        s["npc;drop=136160"] = {"Rey Dazar <El Primero>", "Reposo de los Reyes"}
        s["npc;drop=144244"] = {"Repartetundas de platino", "Operación: Mecandria"}
        s["npc;drop=144246"] = {"KU-J0", "Operación: Mecandria"}
        s["npc;drop=144248"] = {"Maquinista jefe Flujochispa", "Operación: Mecandria"}
        s["npc;drop=150159"] = {"Rey Gobbamak", "Operación: Mecandria"}
        s["npc;drop=150222"] = {"Mugroso", "Operación: Mecandria"}
        s["npc;drop=150397"] = {"Rey Mecandria", "Operación: Mecandria"}
        s["npc;drop=152619"] = {"Rey Mecandria", "Operación: Mecandria"}
        s["npc;drop=156827"] = {"Echelon", "Salas de la Expiación"}
        s["npc;drop=162309"] = {"Kul'tharok", "Teatro del Dolor"}
        s["npc;drop=162317"] = {"Tajasangre", "Teatro del Dolor"}
        s["npc;drop=162329"] = {"Xav el Invicto", "Teatro del Dolor"}
        s["npc;drop=162689"] = {"Cirujano Cosecarne", "Estela Necrótica"}
        s["npc;drop=162691"] = {"Huesoañublo", "Estela Necrótica"}
        s["npc;drop=162693"] = {"Nalthor Clamaescarcha", "Estela Necrótica"}
        s["npc;drop=163157"] = {"Amarth <El Cosechador>", "Estela Necrótica"}
        s["npc;drop=164185"] = {"Echelon", "Salas de la Expiación"}
        s["npc;drop=164218"] = {"Lord chambelán", "Salas de la Expiación"}
        s["npc;drop=164451"] = {"Dessia la Decapitadora", "Teatro del Dolor"}
        s["npc;drop=164501"] = {"Clamaneblina", "Nieblas de Tirna Scithe"}
        s["npc;drop=164517"] = {"Tred'ova", "Nieblas de Tirna Scithe"}
        s["npc;drop=164567"] = {"Ingra Maloch", "Nieblas de Tirna Scithe"}
        s["npc;drop=165408"] = {"Halkias <El goliat impenitente>", "Salas de la Expiación"}
        s["npc;drop=165410"] = {"Gran adjudicadora Aleez", "Salas de la Expiación"}
        s["npc;drop=165946"] = {"Mordretha, la Emperatriz Eterna", "Teatro del Dolor"}
        s["npc;drop=175546"] = {"Cronocapitana Colagarfio", "Tazavesh, el Mercado Velado"}
        s["npc;drop=175616"] = {"Zo'phex <El Centinela>", "Tazavesh, el Mercado Velado"}
        s["npc;drop=175646"] = {"Jefe de correos", "Tazavesh, el Mercado Velado"}
        s["npc;drop=175663"] = {"Hylbrande <Espada de los guardianes>", "Tazavesh, el Mercado Velado"}
        s["npc;drop=175806"] = {"So'azmi", "Tazavesh, el Mercado Velado"}
        s["npc;drop=176556"] = {"Alcruux <El Glotón>", "Tazavesh, el Mercado Velado"}
        s["npc;drop=176563"] = {"Zo'gron", "Tazavesh, el Mercado Velado"}
        s["npc;drop=176705"] = {"Venza Fundioro", "Tazavesh, el Mercado Velado"}
        s["npc;drop=177269"] = {"So'leah <Cártel So>", "Tazavesh, el Mercado Velado"}
        s["npc;drop=188252"] = {"Melidrussa Ajafrío <Especialista en infusión>", "Estanques de Vida Rubí"}
        s["npc;drop=189232"] = {"Kokia Pezuña de Fuego", "Estanques de Vida Rubí"}
        s["npc;drop=190485"] = {"Erkhart Venatormenta", "Estanques de Vida Rubí"}
        s["npc;drop=190609"] = {"Eco de Doragosa <Directora>", "Academia Algeth'ar"}
        s["npc;drop=191736"] = {"Crawth", "Academia Algeth'ar"}
        s["npc;drop=194181"] = {"Vexamus", "Academia Algeth'ar"}
        s["npc;drop=196482"] = {"Anciano desmesurado", "Academia Algeth'ar"}
        s["npc;drop=202318"] = {"Vigía del equipo de respuesta", "Caverna Zaralek"}
        s["npc;drop=203355"] = {"Capitana Reykal", "Caverna Zaralek"}
        s["npc;drop=207205"] = {"Guardiatormenta Gorren", "El Grajero"}
        s["npc;drop=207207"] = {"Monstruosidad de piedra del Vacío", "El Grajero"}
        s["npc;drop=207939"] = {"Barón Braunpyke", "Priorato de la Llama Sagrada"}
        s["npc;drop=207940"] = {"Priora Murrezo", "Priorato de la Llama Sagrada"}
        s["npc;drop=207946"] = {"Capitán Gritoldía", "Priorato de la Llama Sagrada"}
        s["npc;drop=208478"] = {"Volcoross", "Amirdrassil, la Esperanza del Sueño"}
        s["npc;drop=208743"] = {"Llamakon", "Grieta de Flama Oscura"}
        s["npc;drop=208745"] = {"Rey Vela", "Grieta de Flama Oscura"}
        s["npc;drop=209230"] = {"Kyrioss", "El Grajero"}
        s["npc;drop=210108"] = {"E.D.N.A.", "La Petrocámara"}
        s["npc;drop=210153"] = {"Viejo Barbacera", "Grieta de Flama Oscura"}
        s["npc;drop=210156"] = {"Skarmorak", "La Petrocámara"}
        s["npc;drop=210267"] = {"I'pa", "Lagar de Tragoceniza"}
        s["npc;drop=210271"] = {"Maestro cervecero Aldryr", "Lagar de Tragoceniza"}
        s["npc;drop=210797"] = {"La Oscuridad", "Grieta de Flama Oscura"}
        s["npc;drop=211087"] = {"Oradora Coronasombría", "El Rompealbas"}
        s["npc;drop=211089"] = {"Anub'ikkaj", "El Rompealbas"}
        s["npc;drop=213119"] = {"Portavoz del Vacío Eirich", "La Petrocámara"}
        s["npc;drop=213179"] = {"Avanoxx", "Ara-Kara, Ciudad de los Ecos"}
        s["npc;drop=213217"] = {"Orador Brokk", "La Petrocámara"}
        s["npc;drop=214502"] = {"El horror vinculado a la sangre", "Palacio Nerub'ar"}
        s["npc;drop=214506"] = {"Tuercelinajes Ovi'nax", "Palacio Nerub'ar"}
        s["npc;drop=214661"] = {"Áurea Barónez <MIEL.E.O.>", "Lagar de Tragoceniza"}
        s["npc;drop=215405"] = {"Anub'zekt <Guardaenjambre>", "Ara-Kara, Ciudad de los Ecos"}
        s["npc;drop=215407"] = {"Ki'katal la Cosechadora", "Ara-Kara, Ciudad de los Ecos"}
        s["npc;drop=215657"] = {"Ul'grax el Devorador", "Palacio Nerub'ar"}
        s["npc;drop=216320"] = {"Coaglamación", "Ciudad Tejida"}
        s["npc;drop=216619"] = {"Orador Krix'vizk <El Quinto Hilo>", "Ciudad Tejida"}
        s["npc;drop=216648"] = {"Nx <Colmillo de la Reina>", "Ciudad Tejida"}
        s["npc;drop=216658"] = {"Izo la Gran Ensambladora", "Ciudad Tejida"}
        s["npc;drop=217489"] = {"Anub'arash <Las Mil Cicatrices>", "Palacio Nerub'ar"}
        s["npc;drop=218002"] = {"Benk Abejorro <Apicultor>", "Lagar de Tragoceniza"}
        s["npc;drop=219778"] = {"Reina Ansurek", "Palacio Nerub'ar"}
        s["npc;drop=219853"] = {"Sikran <Capitán de los sureki>", "Palacio Nerub'ar"}
        s["npc;drop=223779"] = {"Anub'arash <Las Mil Cicatrices>", "Palacio Nerub'ar"}
        s["npc;drop=223839"] = {"Guardia de la reina Ge'zah", "Palacio Nerub'ar"}
        s["npc;drop=224552"] = {"Rasha'nan", "El Rompealbas"}
        s["npc;drop=225821"] = {"[The Geargrinder]", "Liberación de Minahonda"}
        s["npc;drop=226305"] = {"[Emperor Dagran Thaurissan]", "Profundidades de Roca Negra"}
        s["npc;drop=226306"] = {"[Golem Lord Argelmach]", "Profundidades de Roca Negra"}
        s["npc;drop=226315"] = {"[Lord Roccor]", "Profundidades de Roca Negra"}
        s["npc;drop=226396"] = {"[Swampface]", "Operación: Compuerta"}
        s["npc;drop=226398"] = {"[Big M.O.M.M.A.]", "Operación: Compuerta"}
        s["npc;drop=226403"] = {"[Keeza Quickfuse]", "Operación: Compuerta"}
        s["npc;drop=226404"] = {"Geezle Gigachispa", "Operación: Compuerta"}
        s["npc;drop=228458"] = {"[One-Armed Bandit]", "Liberación de Minahonda"}
        s["npc;drop=228470"] = {"Princesa del Nexo Ky'veza", "Palacio Nerub'ar"}
        s["npc;drop=228652"] = {"[Rik Reverb]", "Liberación de Minahonda"}
        s["npc;drop=229181"] = {"[Flarendo]", "Liberación de Minahonda"}
        s["npc;drop=229284"] = {"Guk Bumcan <El vendedor de bazofia>", "Liberación de Minahonda"}
        s["npc;drop=229288"] = {"Rey Escupellamas <Gerente de Flarendo>", "Liberación de Minahonda"}
        s["npc;drop=229953"] = {"[Mug'Zee]", "Liberación de Minahonda"}
        s["npc;drop=229992"] = {"Estalagmirok", "Isla de la Sirena"}
        s["npc;drop=230322"] = {"[Stix Bunkjunker]", "Liberación de Minahonda"}
        s["npc;drop=230583"] = {"[Sprocketmonger Lockenstock]", "Liberación de Minahonda"}
        s["npc;drop=230800"] = {"[Slugger the Smart]", "Minahonda"}
        s["npc;drop=230828"] = {"[Chief Foreman Gutso]", "Minahonda"}
        s["npc;drop=230934"] = {"[Ratspit]", "Minahonda"}
        s["npc;drop=230946"] = {"[V.V. Goosworth]", "Minahonda"}
        s["npc;drop=231310"] = {"Precipitante de Fundisombras", "Minahonda"}
        s["npc;drop=231606"] = {"Brasalbor", "Aguja Brisaveloz"}
        s["npc;drop=231626"] = {"Kalis", "Aguja Brisaveloz"}
        s["npc;drop=231631"] = {"Comandante Kroluk <Vieja Horda>", "Aguja Brisaveloz"}
        s["npc;drop=231636"] = {"Corazón Inquieto", "Aguja Brisaveloz"}
        s["npc;drop=231863"] = {"Seranel Cortasol", "Bancal del Magister"}
        s["npc;drop=231864"] = {"Gemellus", "Bancal del Magister"}
        s["npc;drop=231865"] = {"Degentrius", "Bancal del Magister"}
        s["npc;drop=231981"] = {"Fauce de las arenas", "K'aresh"}
        s["npc;drop=233814"] = {"Centinela del plexo", "Forja de Maná Omega"}
        s["npc;drop=233815"] = {"Loom'ithar", "Forja de Maná Omega"}
        s["npc;drop=233816"] = {"Vinculadora de almas Naazindhri", "Forja de Maná Omega"}
        s["npc;drop=233824"] = {"Dimensius", "Forja de Maná Omega"}
        s["npc;drop=234647"] = {"Xathuux el Aniquilador <Guardián de Lithiel>", "El Frontal de la Muerte"}
        s["npc;drop=234649"] = {"Zaen Hojapena", "El Frontal de la Muerte"}
        s["npc;drop=234845"] = {"Sthaarbs <El Tuercementes>", "K'aresh"}
        s["npc;drop=234893"] = {"Azhiccar", "Ecodomo Al'dani"}
        s["npc;drop=234933"] = {"Taah'bat <El Incansable>", "Ecodomo Al'dani"}
        s["npc;drop=235853"] = {"Vigía de puerta", "Forja de Maná Omega"}
        s["npc;drop=237415"] = {"Lithiel Ciniracunda", "El Frontal de la Muerte"}
        s["npc;drop=237661"] = {"Adarus Fulgorsombrío", "Forja de Maná Omega"}
        s["npc;drop=237763"] = {"Rey-nexo Salhadaar", "Forja de Maná Omega"}
        s["npc;drop=237861"] = {"Fractillus <[The Shatterer]>", "Forja de Maná Omega"}
        s["npc;drop=238887"] = {"Taz'Rah", "Arena Lacravacua"}
        s["npc;drop=239008"] = {"Atroxus", "Arena Lacravacua"}
        s["npc;drop=239454"] = {"Mago oscuro Zadus", "Forja de Maná Omega"}
        s["npc;drop=240432"] = {"Rey caído Salhadaar", "Aguja del Vacío"}
        s["npc;drop=240434"] = {"Vorasius", "Aguja del Vacío"}
        s["npc;drop=240435"] = {"Imperador Averzian", "Aguja del Vacío"}
        s["npc;drop=241526"] = {"[Chrome King Gallywix]", "Liberación de Minahonda"}
        s["npc;drop=241546"] = {"Lothraxion <Alto comandante>", ""}
        s["npc;drop=242031"] = {"Volantespina <La presa más mortífera>", "Zul'Aman"}
        s["npc;drop=242056"] = {"Vaelgor", "Aguja del Vacío"}
        s["npc;drop=242255"] = {"[Geezle Gigazap]", "Operación: Compuerta"}
        s["npc;drop=24239"] = {"Señor aojador Malacrass", "Abismo Venenoso"}
        s["npc;drop=243028"] = {"Meittik", "El Valle Cegador"}
        s["npc;drop=244752"] = {"Princesa del Nexo Ky'veza", "Santuario Filovacío"}
        s["npc;drop=244761"] = {"Alleria Windrunner", "Aguja del Vacío"}
        s["npc;drop=244762"] = {"Lu'ashal", "Bosque Canción Eterna"}
        s["npc;drop=244887"] = {"Ikuzz el cazador de Luz", "El Valle Cegador"}
        s["npc;drop=245044"] = {"Cría de la noche", "Tormenta del Vacío"}
        s["npc;drop=245912"] = {"Celador de la Luz Ruia", "El Valle Cegador"}
        s["npc;drop=246633"] = {"Halcón zancudo atosigado", "Bosque Canción Eterna"}
        s["npc;drop=246729"] = {"Ascua de Luz <Vástago de Belo'ren>", "Isla de Quel'Danas"}
        s["npc;drop=247283"] = {"Escriba de almas", "Ecodomo Al'dani"}
        s["npc;drop=247570"] = {"Muro'jin", "Cavernas de Maisara"}
        s["npc;drop=247676"] = {"Ziekket <Engendro de luz nudoso>", "El Valle Cegador"}
        s["npc;drop=247976"] = {"Cazador furtivo Rav'ik <Tribu Vilrama>", "Zul'Aman"}
        s["npc;drop=247989"] = {"Tejeforjas Araz", "Forja de Maná Omega"}
        s["npc;drop=248015"] = {"Caronus", "Arena Lacravacua"}
        s["npc;drop=248595"] = {"Vordaza", "Cavernas de Maisara"}
        s["npc;drop=248605"] = {"Rak'tul <Receptáculo de almas>", "Cavernas de Maisara"}
        s["npc;drop=248710"] = {"El Acaparatesoros <Tribu Pataespíritu>", "Guarida de Nalorakk"}
        s["npc;drop=248823"] = {"Núcleo negro", "Tormenta del Vacío"}
        s["npc;drop=249844"] = {"Avispa de mar <La Muerte Flotante>", "Harandar"}
        s["npc;drop=250086"] = {"Rechoncho <Terror de Harandar>", "Harandar"}
        s["npc;drop=250358"] = {"Annulus el Agitamundos", "Harandar"}
        s["npc;drop=250589"] = {"Capellana de guerra Seen", "Aguja del Vacío"}
        s["npc;drop=252458"] = {"Kystia Manaudaz", "El Frontal de la Muerte"}
        s["npc;drop=252959"] = {"Nymrissa Clamaolas", "La Gruta Mareal"}
        s["npc;drop=254176"] = {"Pudrelodo", "Micosis"}
        s["npc;drop=254227"] = {"Celadora del núcleo Nysarra", ""}
        s["npc;drop=256116"] = {"Chimaerus <El Dios Inconcebible>", "Falla Onírica"}
        s["npc;drop=257347"] = {"Sszorak", "Abismo Venenoso"}
        s["npc;drop=257361"] = {"Vexhul", "Abismo Venenoso"}
        s["npc;drop=257906"] = {"Skully Ojos de Moneda", "Isla Serpenteante"}
        s["npc;drop=258557"] = {"Aliento de Ula'tek", "Abismo Venenoso"}
        s["npc;drop=258877"] = {"Nalorakk <Loa de la guerra>", "Guarida de Nalorakk"}
        s["npc;drop=258916"] = {"Garsecg <El Desgarrador de Cascos>", "Isla Serpenteante"}
        s["npc;drop=259445"] = {"Rav'i", "Altar de los Colmillos"}
        s["npc;drop=259446"] = {"La Espiral Retorcida", "Altar de los Colmillos"}
        s["npc;drop=259447"] = {"Zul'jan", "Altar de los Colmillos"}
        s["npc;drop=260905"] = {"Veneno ardiente", "Abismo Venenoso"}
        s["npc;drop=261053"] = {"Centinela del invierno", "Guarida de Nalorakk"}
        s["npc;drop=263456"] = {"Szarith el Colmilludo", ""}
        s["npc;drop=264854"] = {"Farthik la Desvalijadora", "Isla Serpenteante"}
        s["npc;drop=267077"] = {"Mor'zahi", "Abismo Venenoso"}
        s["npc;drop=268090"] = {"Kari'zah el Olvidado", "Isla Serpenteante"}
        s["npc;drop=268956"] = {"Ula'tek", "Abismo Venenoso"}
        s["npc;drop=269808"] = {"Aka'ali la Conquistadora", "Reposo de los Reyes"}
        s["npc;drop=271337"] = {"Echo of Jawae <[Soulcoiler Cult]>", "Abismo Venenoso"}
        s["npc;drop=36476"] = {"Agh <Esbirro de Puagh>", "Foso de Saron"}
        s["npc;drop=36494"] = {"Maestro de forja Gargelus", "Foso de Saron"}
        s["npc;drop=36658"] = {"Señor de la Plaga Tyrannus", "Foso de Saron"}
        s["npc;drop=39625"] = {"General Umbriss <Siervo de Alamuerte>", "Grim Batol"}
        s["npc;drop=40177"] = {"Maestro de forja Throngus", "Grim Batol"}
        s["npc;drop=40319"] = {"Drahga Quemasombras <Mensajero del Martillo Crepuscular>", "Grim Batol"}
        s["npc;drop=40484"] = {"Erudax <El Duque de las profundidades>", "Grim Batol"}
        s["npc;drop=75452"] = {"Quijahueso", "Cementerio de Sombraluna"}
        s["npc;drop=75964"] = {"Ranjit <Maestro de los Cuatro Vientos>", "Trecho Celestial"}
        s["npc;drop=76141"] = {"Araknath <Ensamblaje del sol>", "Trecho Celestial"}
        s["npc;drop=76266"] = {"Suma sabia Viryx", "Trecho Celestial"}
        s["npc;drop=76379"] = {"Rukhran", "Trecho Celestial"}
        s["npc;sold=219222"] = {"Lalandi <Intendente de conquista>", "Dornogal"}
        s["npc;sold=224270"] = {"Ip'xal <Sastra de héroes>", "Ciudad Tejida"}
        s["npc;sold=227003"] = {"Kir'xal <Recaudadora de curiosidades>", "Ciudad Tejida"}
        s["npc;sold=231824"] = {"[Kari Bridgeblaster]", "Minahonda"}
        s["npc;sold=243220"] = {"Irissa Sangrestrella <Intendente de conquista>", "Ciudad de Lunargenta"}
        s["npc;sold=248303"] = {"Zah'ran <[Delve Trinkets]>", "Excavación 9"}
        s["npc;sold=256670"] = {"Zah'ran <Equipo de profundidades>", "Calamidad de Colegiado"}
        s["object;contained=413563"] = {"Baúl pesado", "Caverna del Micomante"}
        s["object;contained=413590"] = {"Arca pródiga", "Foso del Pavor"}
        s["object;contained=416265"] = {"Baúl birlado", "Foso del Pavor"}
        s["object;contained=476068"] = {"[Papa's Prized Putter]", "Minahonda"}
        s["object;contained=507768"] = {"Montón desechado de goblindólares", "Excavación 9"}
        s["object;contained=574407"] = {"Alijo de contendiente", "Bancal del Magister"}
        s["object;contained=574409"] = {"Alijo de contendiente", ""}
        s["object;contained=581922"] = {"Tesoro escondido", "Calamidad de Colegiado"}
        s["object;contained=584514"] = {"Arca pródiga", "Calamidad de Colegiado"}
        s["object;contained=584518"] = {"Baúl pesado pródigo", "Calamidad de Colegiado"}
        s["object;contained=584519"] = {"Baúl pesado", "Calamidad de Colegiado"}
        s["quest;reward=66119"] = {"Estanques de Vida Rubí: invasión primalista", ""}
        s["quest;reward=78232"] = {"Reescribir lo reescrito", ""}
        s["quest;reward=78636"] = {"La reconquista de las minas", ""}
        s["quest;reward=79342"] = {"Y llega la despedida", ""}
        s["quest;reward=83125"] = {"", "Zuldazar"}
        s["quest;reward=86521"] = {"Eclipse en el Punto de Nexo: Xenas", ""}
        s["quest;reward=91009"] = {"Depósito de Información Segura Contenida y Organizada", "Dornogal"}
        s["quest;reward=91694"] = {"Arena Lacravacua: Contra la Tríada", ""}
        s["quest;reward=91958"] = {"Guarida de Nalorakk: el Imperdonable", ""}
        s["quest;reward=93417"] = {"Las Cámaras de Atal'Utek: Altar de los Colmillos", ""}
        s["quest;reward=93651"] = {"El Valle Cegador: Raíces de flor de Luz", ""}
        s["quest;reward=93933"] = {"Tesoros protegidos", ""}
        s["spell;created=1228945"] = {"Ataduras de mártir", "CRAFTING"}
        s["spell;created=1228950"] = {"Sudario sedoso de partidario", "CRAFTING"}
        s["spell;created=1228984"] = {"Brazales de tejido Arcano", "CRAFTING"}
        s["spell;created=1228985"] = {"Capa de tejido Arcano", "CRAFTING"}
        s["spell;created=1228988"] = {"Cordón de tejido Arcano", "CRAFTING"}
        s["spell;created=1229648"] = {"Hoja de guerra de Caballero de sangre", "CRAFTING"}
        s["spell;created=1229649"] = {"Garra forjada con flores", "CRAFTING"}
        s["spell;created=1229657"] = {"Guja de guerra de rompechizos", "CRAFTING"}
        s["spell;created=1229659"] = {"Piedad de errante", "CRAFTING"}
        s["spell;created=1229662"] = {"Brazales de rompechizos", "CRAFTING"}
        s["spell;created=1229875"] = {"Muñequeras de eterluminiscencia", "CRAFTING"}
        s["spell;created=1229877"] = {"Guardas de eterluminiscencia", "CRAFTING"}
        s["spell;created=1230061"] = {"Farol de Aln'hara", "CRAFTING"}
        s["spell;created=1230070"] = {"Dominio de la Luna Negra: Sangre", "CRAFTING"}
        s["spell;created=1230071"] = {"Dominio de la Luna Negra: Podredumbre", "CRAFTING"}
        s["spell;created=1230072"] = {"Dominio de la Luna Negra: Caza", "CRAFTING"}
        s["spell;created=1230073"] = {"Dominio de la Luna Negra: Vacío", "CRAFTING"}
        s["spell;created=1230479"] = {"Sortija de adorador de loa", "CRAFTING"}
        s["spell;created=1230485"] = {"Sortija sin'dorei magistral", "CRAFTING"}
        s["spell;created=1230486"] = {"Amuleto sin'dorei magistral", "CRAFTING"}
        s["spell;created=1230487"] = {"Sello de bendiciones de Azeroth", "CRAFTING"}
        s["spell;created=1230861"] = {"Piedra filosofal primigenia", "CRAFTING"}
        s["spell;created=1230885"] = {"Piedra de alquimista de magister", "CRAFTING"}
        s["spell;created=1237508"] = {"Zapatas de agente de Lunargenta", "CRAFTING"}
        s["spell;created=1237509"] = {"Manijas de agente de Lunargenta", "CRAFTING"}
        s["spell;created=1237513"] = {"Cinturón de herramientas de agente de Lunargenta", "CRAFTING"}
        s["spell;created=1237514"] = {"Deflectores de agente de Lunargenta", "CRAFTING"}
        s["spell;created=1237518"] = {"Zapatillas raigales de cuidador del mundo", "CRAFTING"}
        s["spell;created=1237519"] = {"Cinto cortical de cuidador del mundo", "CRAFTING"}
        s["spell;created=1237537"] = {"Garfas cortantes de errante", "CRAFTING"}
        s["spell;created=1237543"] = {"Brazales de placas de errante", "CRAFTING"}
        s["spell;created=1249111"] = {"Recibir mantón", "CRAFTING"}
        s["spell;created=1253219"] = {"Caza", ""}
        s["spell;created=1253220"] = {"Vacío", ""}
        s["spell;created=1253221"] = {"Sangre", ""}
        s["spell;created=1253222"] = {"Podredumbre", ""}
        s["spell;created=237828"] = {"Runa vantus: Inquisición demoníaca", ""}
        s["spell;created=239649"] = {"Colisión infernal", ""}
        s["spell;created=244572"] = {"Invocar espíritu", ""}
        s["spell;created=244581"] = {"Cometa aplastante", ""}
        s["spell;created=244609"] = {"Invocar espíritu - Ritmo de tambor", ""}
        s["spell;created=427185"] = {"Piedra de alquimista algariana", "CRAFTING"}
        s["spell;created=435382"] = {"Anillo de vinculación", "CRAFTING"}
        s["spell;created=435384"] = {"Anillo de artesanía terránea", "CRAFTING"}
        s["spell;created=435385"] = {"Amuleto de artesanía terránea", "CRAFTING"}
        s["spell;created=441051"] = {"Guerrera con runas marcadas", "CRAFTING"}
        s["spell;created=441052"] = {"Chanclos con runas marcadas", "CRAFTING"}
        s["spell;created=441053"] = {"Mandiletes con runas marcadas", "CRAFTING"}
        s["spell;created=441055"] = {"Perneras con runas marcadas", "CRAFTING"}
        s["spell;created=441057"] = {"Pretina con runas marcadas", "CRAFTING"}
        s["spell;created=441058"] = {"Bandas con runas marcadas", "CRAFTING"}
        s["spell;created=441060"] = {"Apisonadoras con glifos grabados", "CRAFTING"}
        s["spell;created=441061"] = {"Guanteletes con glifos grabados", "CRAFTING"}
        s["spell;created=441063"] = {"Quijotes con glifos grabados", "CRAFTING"}
        s["spell;created=441065"] = {"Ataduras con glifos grabados", "CRAFTING"}
        s["spell;created=441066"] = {"Avambrazos con glifos grabados", "CRAFTING"}
        s["spell;created=444070"] = {"Cinto de aumento suprarrenal", "CRAFTING"}
        s["spell;created=444197"] = {"Antorcha de vagabundo", "CRAFTING"}
        s["spell;created=444198"] = {"Muleta cuidadosa de vagabundo", "CRAFTING"}
        s["spell;created=444199"] = {"Bastón delimitador de vagabundo", "CRAFTING"}
        s["spell;created=445355"] = {"Cetro de magia radiante", "CRAFTING"}
        s["spell;created=446937"] = {"Zapatillas consagradas", "CRAFTING"}
        s["spell;created=446938"] = {"Puños consagrados", "CRAFTING"}
        s["spell;created=446939"] = {"Cordón consagrado", "CRAFTING"}
        s["spell;created=446940"] = {"Capa consagrada", "CRAFTING"}
        s["spell;created=447314"] = {"Expedidor de luminosidad estudioso", "CRAFTING"}
        s["spell;created=447315"] = {"Generador de ideas sobrecargado", "CRAFTING"}
        s["spell;created=450220"] = {"Escarpes de forja eterna", "CRAFTING"}
        s["spell;created=450222"] = {"Gran cinturón de forja eterna", "CRAFTING"}
        s["spell;created=450223"] = {"Defensor de forja eterna", "CRAFTING"}
        s["spell;created=450224"] = {"Yelmo de forja eterna", "CRAFTING"}
        s["spell;created=450226"] = {"Avambrazos de forja eterna", "CRAFTING"}
        s["spell;created=450229"] = {"Apuñaladora de forja eterna", "CRAFTING"}
        s["spell;created=450230"] = {"Daga de forja eterna", "CRAFTING"}
        s["spell;created=450231"] = {"Tizona de forja eterna", "CRAFTING"}
        s["spell;created=450232"] = {"Guja de guerra de forja eterna", "CRAFTING"}
        s["spell;created=450234"] = {"Gran hacha de forja eterna", "CRAFTING"}
        s["spell;created=450235"] = {"Espada embrujada cargada", "CRAFTING"}
        s["spell;created=450237"] = {"Machacacaras cargado", "CRAFTING"}
        s["spell;created=450238"] = {"Mandoble cargado", "CRAFTING"}
        s["spell;created=450239"] = {"Alabarda cargada", "CRAFTING"}
        s["spell;created=450242"] = {"Cercenadora cargada", "CRAFTING"}
        s["spell;created=455391"] = {"Vivacidad", ""}
        s["spell;created=455392"] = {"Simbiosis", ""}
        s["spell;created=455393"] = {"Resplandor", ""}
        s["spell;created=455394"] = {"Ascensión", ""}
        s["spell;created=473400"] = {"Reconfiguración para lanzamiento de hechizos", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationfrFR()
        s["item:contained=229129"] = {"Cache de butin des Gouffres", ""}
        s["item:contained=229354"] = {"Cache d’aventurier algari", ""}
        s["item:contained=235639"] = {"Cache d’aventurier aguerri", ""}
        s["item:contained=238208"] = {"Dividendes inflationnistes de Mémé", ""}
        s["item:contained=262346"] = {"Coffre de champion de la Traque", ""}
        s["npc;drop=122056"] = {"Vice-roi Nezhar", "Siège du triumvirat"}
        s["npc;drop=122313"] = {"Zuraal le Zélateur", "Siège du triumvirat"}
        s["npc;drop=122316"] = {"Saprish <Seigneur de l'Ethereum ombre-garde>", "Siège du triumvirat"}
        s["npc;drop=124729"] = {"L'ura", "Siège du triumvirat"}
        s["npc;drop=128649"] = {"Sergent Bainbridge", "Siège de Boralus"}
        s["npc;drop=128650"] = {"Crochesang", "Siège de Boralus"}
        s["npc;drop=128651"] = {"Hadal Sombrabysse", "Siège de Boralus"}
        s["npc;drop=128652"] = {"Viq'Goth <Terreur des abysses>", "Siège de Boralus"}
        s["npc;drop=129208"] = {"Capitaine de l'effroi Boisclos", "Siège de Boralus"}
        s["npc;drop=129214"] = {"Disperseur de foule automatique", "Le Filon"}
        s["npc;drop=129227"] = {"Azerokk", "Le Filon"}
        s["npc;drop=129231"] = {"Rixxa Fluxifuge <Scientifique en chef>", "Le Filon"}
        s["npc;drop=131227"] = {"Nabab Razzbam", "Le Filon"}
        s["npc;drop=132713"] = {"Nabab Razzbam", "Le Filon"}
        s["npc;drop=133384"] = {"Merekpha", "Temple de Sephraliss"}
        s["npc;drop=133389"] = {"Galvazzt", "Temple de Sephraliss"}
        s["npc;drop=133392"] = {"Avatar de Sephraliss", "Temple de Sephraliss"}
        s["npc;drop=133944"] = {"Aspis", "Temple de Sephraliss"}
        s["npc;drop=134993"] = {"Mchimba l'Embaumeur", "Repos des rois"}
        s["npc;drop=135322"] = {"Le serpent doré", "Repos des rois"}
        s["npc;drop=136160"] = {"Roi Dazar <Le premier>", "Repos des rois"}
        s["npc;drop=144244"] = {"Le « Tabasseur de platine »", "Opération Mécagone"}
        s["npc;drop=144246"] = {"K.U.-J.0.", "Opération Mécagone"}
        s["npc;drop=144248"] = {"Machiniste en chef Electroflux", "Opération Mécagone"}
        s["npc;drop=150159"] = {"Roi Gobbamak", "Opération Mécagone"}
        s["npc;drop=150222"] = {"Salcrass", "Opération Mécagone"}
        s["npc;drop=150397"] = {"Roi Mécagone", "Opération Mécagone"}
        s["npc;drop=152619"] = {"Roi Mécagone", "Opération Mécagone"}
        s["npc;drop=156827"] = {"Echelon", "Salles de l’Expiation"}
        s["npc;drop=162309"] = {"Kul'tharok", "Théâtre de la Souffrance"}
        s["npc;drop=162317"] = {"Trancheboyau", "Théâtre de la Souffrance"}
        s["npc;drop=162329"] = {"Xav l'Invaincu", "Théâtre de la Souffrance"}
        s["npc;drop=162689"] = {"Docteur Sutur", "Sillage nécrotique"}
        s["npc;drop=162691"] = {"Chancros", "Sillage nécrotique"}
        s["npc;drop=162693"] = {"Nalthor le Lieur-de-Givre", "Sillage nécrotique"}
        s["npc;drop=163157"] = {"Amarth <Le Moissonneur>", "Sillage nécrotique"}
        s["npc;drop=164185"] = {"Echelon", "Salles de l’Expiation"}
        s["npc;drop=164218"] = {"Grand chambellan", "Salles de l’Expiation"}
        s["npc;drop=164451"] = {"Dessia la Décapiteuse", "Théâtre de la Souffrance"}
        s["npc;drop=164501"] = {"Mandebrume", "Brumes de Tirna Scithe"}
        s["npc;drop=164517"] = {"Tred'ova", "Brumes de Tirna Scithe"}
        s["npc;drop=164567"] = {"Ingra Maloch", "Brumes de Tirna Scithe"}
        s["npc;drop=165408"] = {"Halkias <Le goliath vicié>", "Salles de l’Expiation"}
        s["npc;drop=165410"] = {"Grande adjudicatrice Alize", "Salles de l’Expiation"}
        s["npc;drop=165946"] = {"Mordretha, l'impératrice immortelle", "Théâtre de la Souffrance"}
        s["npc;drop=175546"] = {"Chronocapitaine Harpagone", "Tazavesh, le marché dissimulé"}
        s["npc;drop=175616"] = {"Zo'phex <La Sentinelle>", "Tazavesh, le marché dissimulé"}
        s["npc;drop=175646"] = {"Maître de P.O.S.T.E.", "Tazavesh, le marché dissimulé"}
        s["npc;drop=175663"] = {"Hylbrande <Epée des gardiens>", "Tazavesh, le marché dissimulé"}
        s["npc;drop=175806"] = {"So'azmi", "Tazavesh, le marché dissimulé"}
        s["npc;drop=176556"] = {"Alcruux <Le glouton>", "Tazavesh, le marché dissimulé"}
        s["npc;drop=176563"] = {"Zo'gron", "Tazavesh, le marché dissimulé"}
        s["npc;drop=176705"] = {"Venza Mèchedor", "Tazavesh, le marché dissimulé"}
        s["npc;drop=177269"] = {"So'leah <Cartel So>", "Tazavesh, le marché dissimulé"}
        s["npc;drop=188252"] = {"Mélidrussa Manteglace <Spécialiste de l'imprégnation>", "Bassins de l’Essence rubis"}
        s["npc;drop=189232"] = {"Kokia Foulebraise", "Bassins de l’Essence rubis"}
        s["npc;drop=190485"] = {"Erkhart Foudreveine", "Bassins de l’Essence rubis"}
        s["npc;drop=190609"] = {"Echo de Doragosa <Doyenne>", "Académie d’Algeth’ar"}
        s["npc;drop=191736"] = {"Tricérabec", "Académie d’Algeth’ar"}
        s["npc;drop=194181"] = {"Vexamus", "Académie d’Algeth’ar"}
        s["npc;drop=196482"] = {"Ancien embroussaillé", "Académie d’Algeth’ar"}
        s["npc;drop=202318"] = {"Gardienne de l'équipe d'intervention", "Grotte de Zaralek"}
        s["npc;drop=203355"] = {"Capitaine Reykal", "Grotte de Zaralek"}
        s["npc;drop=207205"] = {"Garde de la tempête Gorren", "La colonie"}
        s["npc;drop=207207"] = {"Monstruosité de pierre du Vide", "La colonie"}
        s["npc;drop=207939"] = {"Baron Braunpique", "Prieuré de la Flamme sacrée"}
        s["npc;drop=207940"] = {"Prieuresse Murrpray", "Prieuré de la Flamme sacrée"}
        s["npc;drop=207946"] = {"Capitaine Dailcri", "Prieuré de la Flamme sacrée"}
        s["npc;drop=208478"] = {"Volcoross", "Amirdrassil, l’Espoir du Rêve"}
        s["npc;drop=208743"] = {"Blazikon", "Faille de Flamme-Noire"}
        s["npc;drop=208745"] = {"Le roi-bougie", "Faille de Flamme-Noire"}
        s["npc;drop=209230"] = {"Kyrioss", "La colonie"}
        s["npc;drop=210108"] = {"E.D.N.A.", "La Cavepierre"}
        s["npc;drop=210153"] = {"Vieux Barbecire", "Faille de Flamme-Noire"}
        s["npc;drop=210156"] = {"Skarmorak", "La Cavepierre"}
        s["npc;drop=210267"] = {"I'pa", "Hydromellerie de Brassecendre"}
        s["npc;drop=210271"] = {"Maître brasseur Aldryr", "Hydromellerie de Brassecendre"}
        s["npc;drop=210797"] = {"Les Ténèbres", "Faille de Flamme-Noire"}
        s["npc;drop=211087"] = {"Mandataire Couronne d'ombre", "Le Brise-Aube"}
        s["npc;drop=211089"] = {"Anub'ikkaj", "Le Brise-Aube"}
        s["npc;drop=213119"] = {"Orateur du Vide Eirich", "La Cavepierre"}
        s["npc;drop=213179"] = {"Avanoxx", "Ara-Kara, la cité des Échos"}
        s["npc;drop=213217"] = {"Mandataire Brokk", "La Cavepierre"}
        s["npc;drop=214502"] = {"L'horreur liée par le sang", "Palais des Nérub’ar"}
        s["npc;drop=214506"] = {"Toressaim Ovi'nax", "Palais des Nérub’ar"}
        s["npc;drop=214650"] = {"L'ura", "Érédath"}
        s["npc;drop=214661"] = {"Goldie Baronnie <DRH>", "Hydromellerie de Brassecendre"}
        s["npc;drop=215405"] = {"Anub'zekt <Garde-essaim>", "Ara-Kara, la cité des Échos"}
        s["npc;drop=215407"] = {"Ki'katal la Moissonneuse", "Ara-Kara, la cité des Échos"}
        s["npc;drop=215657"] = {"Ulgrax le Dévoreur", "Palais des Nérub’ar"}
        s["npc;drop=216320"] = {"La Coaglamation", "Cité des Fils"}
        s["npc;drop=216619"] = {"Mandataire Krix'vizk <Le cinquième filament>", "Cité des Fils"}
        s["npc;drop=216648"] = {"Nx <Croc de la Reine>", "Cité des Fils"}
        s["npc;drop=216658"] = {"Izo le Grand Faisceau", "Cité des Fils"}
        s["npc;drop=217489"] = {"Anub'arash <Les Mille cicatrices>", "Palais des Nérub’ar"}
        s["npc;drop=218002"] = {"Benk Bourdon <Apiculteur>", "Hydromellerie de Brassecendre"}
        s["npc;drop=219778"] = {"Reine Ansurek", "Palais des Nérub’ar"}
        s["npc;drop=219853"] = {"Sikran <Capitaine des Surekis>", "Palais des Nérub’ar"}
        s["npc;drop=223779"] = {"Anub'arash <Les Mille cicatrices>", "Palais des Nérub’ar"}
        s["npc;drop=223839"] = {"Garde de la reine Ge'zah", "Palais des Nérub’ar"}
        s["npc;drop=224552"] = {"Rasha'nan", "Le Brise-Aube"}
        s["npc;drop=225821"] = {"[The Geargrinder]", "Libération de Terremine"}
        s["npc;drop=226305"] = {"[Emperor Dagran Thaurissan]", "Les profondeurs de Rochenoire"}
        s["npc;drop=226306"] = {"[Golem Lord Argelmach]", "Les profondeurs de Rochenoire"}
        s["npc;drop=226315"] = {"[Lord Roccor]", "Les profondeurs de Rochenoire"}
        s["npc;drop=226396"] = {"[Swampface]", "Opération Vannes ouvertes"}
        s["npc;drop=226398"] = {"[Big M.O.M.M.A.]", "Opération Vannes ouvertes"}
        s["npc;drop=226403"] = {"[Keeza Quickfuse]", "Opération Vannes ouvertes"}
        s["npc;drop=226404"] = {"[Geezle Gigazap]", "Opération Vannes ouvertes"}
        s["npc;drop=228458"] = {"[One-Armed Bandit]", "Libération de Terremine"}
        s["npc;drop=228470"] = {"Princesse-nexus Ky'veza", "Palais des Nérub’ar"}
        s["npc;drop=228652"] = {"[Rik Reverb]", "Libération de Terremine"}
        s["npc;drop=229181"] = {"[Flarendo]", "Libération de Terremine"}
        s["npc;drop=229284"] = {"Guk Boumouaf <Vendeur de gruau>", "Libération de Terremine"}
        s["npc;drop=229288"] = {"Roi Hargnembrase <Impresario de Fusendo>", "Libération de Terremine"}
        s["npc;drop=229953"] = {"[Mug'Zee]", "Libération de Terremine"}
        s["npc;drop=229992"] = {"Stalagnarok", "Île aux Sirènes"}
        s["npc;drop=230322"] = {"[Stix Bunkjunker]", "Libération de Terremine"}
        s["npc;drop=230583"] = {"[Sprocketmonger Lockenstock]", "Libération de Terremine"}
        s["npc;drop=230800"] = {"[Slugger the Smart]", "Terremine"}
        s["npc;drop=230828"] = {"[Chief Foreman Gutso]", "Terremine"}
        s["npc;drop=230934"] = {"[Ratspit]", "Terremine"}
        s["npc;drop=230946"] = {"[V.V. Goosworth]", "Terremine"}
        s["npc;drop=231310"] = {"Précipitant imprégné de ténèbres", "Terremine"}
        s["npc;drop=231606"] = {"Aube-de-Braise", "Flèche de Coursevent"}
        s["npc;drop=231626"] = {"Kalis", "Flèche de Coursevent"}
        s["npc;drop=231631"] = {"Commandant Kroluk <Ancienne Horde>", "Flèche de Coursevent"}
        s["npc;drop=231636"] = {"Coeur fébrile", "Flèche de Coursevent"}
        s["npc;drop=231863"] = {"Séranel Cinglesoleil", "Terrasse des Magistères"}
        s["npc;drop=231864"] = {"Gémellus", "Terrasse des Magistères"}
        s["npc;drop=231865"] = {"Dégentrius", "Terrasse des Magistères"}
        s["npc;drop=231981"] = {"Gueule des sables", "K’aresh"}
        s["npc;drop=233814"] = {"Sentinelle du Plexus", "Manaforge Oméga"}
        s["npc;drop=233815"] = {"Rou'ethar", "Manaforge Oméga"}
        s["npc;drop=233816"] = {"Lieuse d'âme Naazindhri", "Manaforge Oméga"}
        s["npc;drop=233824"] = {"Dimensius", "Manaforge Oméga"}
        s["npc;drop=234647"] = {"Xathuux l'Annihilateur <Garde de Lithiel>", "Allée du meurtre"}
        s["npc;drop=234649"] = {"Zaen Tristelame", "Allée du meurtre"}
        s["npc;drop=234845"] = {"Sthaarbs <L'Agitateur>", "K’aresh"}
        s["npc;drop=234893"] = {"Azhiccar", "Écodôme Al’dani"}
        s["npc;drop=234933"] = {"Taah'bat <L'Implacable>", "Écodôme Al’dani"}
        s["npc;drop=235853"] = {"Guetteur de portail", "Manaforge Oméga"}
        s["npc;drop=237415"] = {"Lithiel Fureur-de-Cendre", "Allée du meurtre"}
        s["npc;drop=237661"] = {"Adarus Soirbrasier", "Manaforge Oméga"}
        s["npc;drop=237763"] = {"Roi-nexus Salhadaar", "Manaforge Oméga"}
        s["npc;drop=237861"] = {"Fractillus <[The Shatterer]>", "Manaforge Oméga"}
        s["npc;drop=238887"] = {"Taz'Rah", "Arène de la Cicatrice du Vide"}
        s["npc;drop=239008"] = {"Atroxus", "Arène de la Cicatrice du Vide"}
        s["npc;drop=239454"] = {"Mage sombre Zadus", "Manaforge Oméga"}
        s["npc;drop=240432"] = {"Roi déchu Salhadaar", "La flèche du Vide"}
        s["npc;drop=240434"] = {"Vorasius", "La flèche du Vide"}
        s["npc;drop=240435"] = {"Imperator Averzian", "La flèche du Vide"}
        s["npc;drop=241526"] = {"[Chrome King Gallywix]", "Libération de Terremine"}
        s["npc;drop=241546"] = {"Lothraxion <Haut-commandant>", ""}
        s["npc;drop=242031"] = {"Crêtréchine <Prise mortelle>", "Zul’Aman"}
        s["npc;drop=242056"] = {"Vaelgor", "La flèche du Vide"}
        s["npc;drop=242255"] = {"[Geezle Gigazap]", "Opération Vannes ouvertes"}
        s["npc;drop=24239"] = {"Seigneur des maléfices Malacrass", ""}
        s["npc;drop=243028"] = {"Meittik", "Le val Aveuglant"}
        s["npc;drop=244752"] = {"Princesse-nexus Ky'veza", "Sanctuaire du Rasoir du Vide"}
        s["npc;drop=244761"] = {"Alleria Windrunner", "La flèche du Vide"}
        s["npc;drop=244762"] = {"Lu'ashal", "Bois des Chants éternels"}
        s["npc;drop=244887"] = {"Chasselumière Ikuzz", "Le val Aveuglant"}
        s["npc;drop=245044"] = {"Couvée nocturne", "Tempête du Vide"}
        s["npc;drop=245912"] = {"Gardelumière Ruia", "Le val Aveuglant"}
        s["npc;drop=246633"] = {"Faucon-pérégrin exténué", "Bois des Chants éternels"}
        s["npc;drop=246729"] = {"Braise de la Lumière <Enfant de Belo'ren>", "Île de Quel’Danas"}
        s["npc;drop=247283"] = {"Scribe de l'âme", "Écodôme Al’dani"}
        s["npc;drop=247570"] = {"Muro'jin", "Cavernes de Maisara"}
        s["npc;drop=247676"] = {"Ziekket <Rejeton de Lumière noueux>", "Le val Aveuglant"}
        s["npc;drop=247976"] = {"Braconnier Rav'ik <Tribu vilebranche>", "Zul’Aman"}
        s["npc;drop=247989"] = {"Tisseforge Araz", "Manaforge Oméga"}
        s["npc;drop=248015"] = {"Charonus", "Arène de la Cicatrice du Vide"}
        s["npc;drop=248595"] = {"Vordaza", "Cavernes de Maisara"}
        s["npc;drop=248605"] = {"Rak'tul <Réceptacle des âmes>", "Cavernes de Maisara"}
        s["npc;drop=248710"] = {"Le Thésauriseur <Tribu patte-spirituelle>", "Antre de Nalorakk"}
        s["npc;drop=248823"] = {"Noyau noir", "Tempête du Vide"}
        s["npc;drop=249844"] = {"Chironex <La mort flottante>", "Harandar"}
        s["npc;drop=250086"] = {"Traposaure <Terreur d'Harandar>", "Harandar"}
        s["npc;drop=250358"] = {"Annulus le tremble-monde", "Harandar"}
        s["npc;drop=250589"] = {"Aumônière de guerre Senn", "La flèche du Vide"}
        s["npc;drop=252458"] = {"Kystia Coeur-de-Mana", "Allée du meurtre"}
        s["npc;drop=252959"] = {"Nymrissa Mande-vagues", "La grotte des Marées"}
        s["npc;drop=254176"] = {"Embourbe-pourri", "Chute-des-Spores"}
        s["npc;drop=254227"] = {"Garde-coeur Nysarra", ""}
        s["npc;drop=256116"] = {"Chimaerus <La divinité ineffable>", "La faille du Rêve"}
        s["npc;drop=257347"] = {"Sszorak", "L’abîme Venimeux"}
        s["npc;drop=257361"] = {"Vexhul", "L’abîme Venimeux"}
        s["npc;drop=257906"] = {"Crâneur l'Oeil-écu", "Île Annelée"}
        s["npc;drop=258557"] = {"Souffle d'Ula'tek", "L’abîme Venimeux"}
        s["npc;drop=258877"] = {"Nalorakk <Loa de la guerre>", "Antre de Nalorakk"}
        s["npc;drop=258916"] = {"Garsecg <Le Déchire-coque>", "Île Annelée"}
        s["npc;drop=259445"] = {"Rav'i", "Autel des crochets"}
        s["npc;drop=259446"] = {"L'Ophidien ondulant", "Autel des crochets"}
        s["npc;drop=259447"] = {"Zul'jan", "Autel des crochets"}
        s["npc;drop=260905"] = {"Venin brûlant", "L’abîme Venimeux"}
        s["npc;drop=261053"] = {"Sentinelle de l'hiver", "Antre de Nalorakk"}
        s["npc;drop=263456"] = {"Szarith les Crochets", ""}
        s["npc;drop=264854"] = {"Farthik la Pillarde", "Île Annelée"}
        s["npc;drop=267077"] = {"Mor'zahi", "L’abîme Venimeux"}
        s["npc;drop=268090"] = {"Kari'zah l'Oublié", "Île Annelée"}
        s["npc;drop=268956"] = {"Ula'tek", "L’abîme Venimeux"}
        s["npc;drop=269808"] = {"Aka'ali la Conquérante", "Repos des rois"}
        s["npc;drop=271337"] = {"Echo of Jawae <[Soulcoiler Cult]>", "L’abîme Venimeux"}
        s["npc;drop=36476"] = {"Ick <Serviteur de Krick>", "Fosse de Saron"}
        s["npc;drop=36494"] = {"Maître-forge Gargivre", "Fosse de Saron"}
        s["npc;drop=36658"] = {"Seigneur du Fléau Tyrannus", "Fosse de Saron"}
        s["npc;drop=39625"] = {"Général Umbriss <Serviteur d'Aile de mort>", "Grim Batol"}
        s["npc;drop=40177"] = {"Maître-forge Throngus", "Grim Batol"}
        s["npc;drop=40319"] = {"Drahga Brûle-Ombre <Messager du Marteau du crépuscule>", "Grim Batol"}
        s["npc;drop=40484"] = {"Erudax <Le duc d'En bas>", "Grim Batol"}
        s["npc;drop=75452"] = {"Ossegueule", "Terres sacrées d’Ombrelune"}
        s["npc;drop=75964"] = {"Ranjit <Maître des Quatre vents>", "Orée-du-Ciel"}
        s["npc;drop=76141"] = {"Araknath <Assemblage du soleil>", "Orée-du-Ciel"}
        s["npc;drop=76266"] = {"Grand sage Viryx", "Orée-du-Ciel"}
        s["npc;drop=76379"] = {"Rukhran", "Orée-du-Ciel"}
        s["npc;sold=219222"] = {"Lalandi <Intendante des emblèmes de conquête>", "Dornogal"}
        s["npc;sold=224270"] = {"Ip'xal <Tailleuse héroïque>", "Cité des Fils"}
        s["npc;sold=227003"] = {"Kir'xal <Collectionneuse de curiosités>", "Cité des Fils"}
        s["npc;sold=231824"] = {"[Kari Bridgeblaster]", "Terremine"}
        s["npc;sold=243220"] = {"Irissa Sangdétoile <Intendante des emblèmes de conquête>", "Lune-d’Argent"}
        s["npc;sold=248303"] = {"Zah'ran <[Delve Trinkets]>", "Site d’excavation 9"}
        s["npc;sold=256670"] = {"Zah'ran <Equipement de Gouffre>", "Calamité Universitaire"}
        s["object;contained=413563"] = {"Malle lourde", "Grotte de Mycomancie"}
        s["object;contained=413590"] = {"Coffre abondant", "La fosse de l’Effroi"}
        s["object;contained=416265"] = {"Malle chapardée", "La fosse de l’Effroi"}
        s["object;contained=476068"] = {"[Papa's Prized Putter]", "Terremine"}
        s["object;contained=507768"] = {"Tas de devises gobelines éjectées", "Site d’excavation 9"}
        s["object;contained=574407"] = {"Cache de prétendant", "Terrasse des Magistères"}
        s["object;contained=574409"] = {"Cache de prétendant", ""}
        s["object;contained=581922"] = {"Trésor caché", "Calamité Universitaire"}
        s["object;contained=584514"] = {"Coffre abondant", "Calamité Universitaire"}
        s["object;contained=584518"] = {"Malle lourde abondante", "Calamité Universitaire"}
        s["object;contained=584519"] = {"Malle lourde", "Calamité Universitaire"}
        s["quest;reward=66119"] = {"Bassins de l’Essence rubis : invasion primaliste", ""}
        s["quest;reward=78232"] = {"Réécrire la réécriture", ""}
        s["quest;reward=78636"] = {"Reprendre les mines", ""}
        s["quest;reward=79342"] = {"Dans son départ", ""}
        s["quest;reward=83125"] = {"", "Zuldazar"}
        s["quest;reward=86521"] = {"Point-nexus Xenas : éclipse", ""}
        s["quest;reward=91009"] = {"Dispositif d’Informations Sécurisé de Qualité Universelle et Éprouvée", "Dornogal"}
        s["quest;reward=91694"] = {"Arène de la Cicatrice du Vide : briser la triade", ""}
        s["quest;reward=91958"] = {"L’antre de Nalorakk : impitoyable", ""}
        s["quest;reward=93417"] = {"Les caveaux d’Atal’Utek : Autel des crochets", ""}
        s["quest;reward=93651"] = {"Le val Aveuglant : racines de luméclat", ""}
        s["quest;reward=93933"] = {"Des trésors bien gardés", ""}
        s["spell;created=1228945"] = {"Manchettes de martyre", "CRAFTING"}
        s["spell;created=1228950"] = {"Voile d’adhésion en soie", "CRAFTING"}
        s["spell;created=1228984"] = {"Brassards en tisse-arcane", "CRAFTING"}
        s["spell;created=1228985"] = {"Cape en tisse-arcane", "CRAFTING"}
        s["spell;created=1228988"] = {"Corde en tisse-arcane", "CRAFTING"}
        s["spell;created=1229648"] = {"Lame de guerre de chevalier de sang", "CRAFTING"}
        s["spell;created=1229649"] = {"Griffe forgeflore", "CRAFTING"}
        s["spell;created=1229657"] = {"Glaive de guerre de brise-sort", "CRAFTING"}
        s["spell;created=1229659"] = {"Miséricorde de pérégrin", "CRAFTING"}
        s["spell;created=1229662"] = {"Brassards de brise-sort", "CRAFTING"}
        s["spell;created=1229875"] = {"Poignets en étherlume", "CRAFTING"}
        s["spell;created=1229877"] = {"Garde-poignets en étherlume", "CRAFTING"}
        s["spell;created=1230061"] = {"Lanterne d’Aln’hara", "CRAFTING"}
        s["spell;created=1230070"] = {"Domination de Sombrelune : Sang", "CRAFTING"}
        s["spell;created=1230071"] = {"Domination de Sombrelune : Putréfaction", "CRAFTING"}
        s["spell;created=1230072"] = {"Domination de Sombrelune : Chasse", "CRAFTING"}
        s["spell;created=1230073"] = {"Domination de Sombrelune : Vide", "CRAFTING"}
        s["spell;created=1230479"] = {"Bague d’adoration de Loa", "CRAFTING"}
        s["spell;created=1230485"] = {"Bague sin’dorei ouvragée", "CRAFTING"}
        s["spell;created=1230486"] = {"Amulette sin’dorei ouvragée", "CRAFTING"}
        s["spell;created=1230487"] = {"Chevalière de bénédictions d’Azeroth", "CRAFTING"}
        s["spell;created=1230861"] = {"Pierre philosophale primordiale", "CRAFTING"}
        s["spell;created=1230885"] = {"Pierre d’alchimiste de magistère", "CRAFTING"}
        s["spell;created=1237508"] = {"Chaussures d’agent de Lune-d’Argent", "CRAFTING"}
        s["spell;created=1237509"] = {"Protège-mains d’agent de Lune-d’Argent", "CRAFTING"}
        s["spell;created=1237513"] = {"Ceinture d’outils d’agent de Lune-d’Argent", "CRAFTING"}
        s["spell;created=1237514"] = {"Déflecteurs d’agent de Lune-d’Argent", "CRAFTING"}
        s["spell;created=1237518"] = {"Chaussons racinaires de soigne-monde", "CRAFTING"}
        s["spell;created=1237519"] = {"Fermoir d’écorce de soigne-monde", "CRAFTING"}
        s["spell;created=1237537"] = {"Serres tranchantes de pérégrin", "CRAFTING"}
        s["spell;created=1237543"] = {"Brassards cuirassés de pérégrin", "CRAFTING"}
        s["spell;created=1249111"] = {"Recevoir les bandelettes", "CRAFTING"}
        s["spell;created=1253219"] = {"Chasse", ""}
        s["spell;created=1253220"] = {"Vide", ""}
        s["spell;created=1253221"] = {"Sang", ""}
        s["spell;created=1253222"] = {"Putréfaction", ""}
        s["spell;created=237828"] = {"Rune de Vantus : inquisition démoniaque", ""}
        s["spell;created=239649"] = {"Déferlante infernale", ""}
        s["spell;created=244572"] = {"Invocation d’un esprit", ""}
        s["spell;created=244581"] = {"Comète déferlante", ""}
        s["spell;created=244609"] = {"Invocation d’un esprit - Battement de tambour", ""}
        s["spell;created=427185"] = {"Pierre d’alchimiste algarie", "CRAFTING"}
        s["spell;created=435382"] = {"Lien bienfaiteur", "CRAFTING"}
        s["spell;created=435384"] = {"Anneau d’artisanat terrestre", "CRAFTING"}
        s["spell;created=435385"] = {"Amulette d’artisanat terrestre", "CRAFTING"}
        s["spell;created=441051"] = {"Tunique marquée de runes", "CRAFTING"}
        s["spell;created=441052"] = {"Demi-bottes marquées de runes", "CRAFTING"}
        s["spell;created=441053"] = {"Poignées marquées de runes", "CRAFTING"}
        s["spell;created=441055"] = {"Jambards marqués de runes", "CRAFTING"}
        s["spell;created=441057"] = {"Baudrier marqué de runes", "CRAFTING"}
        s["spell;created=441058"] = {"Bracières marquées de runes", "CRAFTING"}
        s["spell;created=441060"] = {"Croquenots gravés de glyphes", "CRAFTING"}
        s["spell;created=441061"] = {"Gantelets gravés de glyphes", "CRAFTING"}
        s["spell;created=441063"] = {"Cuissières gravées de glyphes", "CRAFTING"}
        s["spell;created=441065"] = {"Lien gravé de glyphes", "CRAFTING"}
        s["spell;created=441066"] = {"Protège-bras gravés de glyphes", "CRAFTING"}
        s["spell;created=444070"] = {"Fermoir d’afflux surrénal", "CRAFTING"}
        s["spell;created=444197"] = {"Torche de vagabondage", "CRAFTING"}
        s["spell;created=444198"] = {"Béquille prudente de vagabondage", "CRAFTING"}
        s["spell;created=444199"] = {"Férule de vagabondage", "CRAFTING"}
        s["spell;created=445355"] = {"Sceptre des magies radieuses", "CRAFTING"}
        s["spell;created=446937"] = {"Mules consacrées", "CRAFTING"}
        s["spell;created=446938"] = {"Crispins consacrés", "CRAFTING"}
        s["spell;created=446939"] = {"Corde consacrée", "CRAFTING"}
        s["spell;created=446940"] = {"Cape consacrée", "CRAFTING"}
        s["spell;created=447314"] = {"Expéditeur d’illumination studieuse", "CRAFTING"}
        s["spell;created=447315"] = {"Générateur d’idées débridé", "CRAFTING"}
        s["spell;created=447352"] = {"P.A.N. x2", "CRAFTING"}
        s["spell;created=450220"] = {"Solerets en forge perpétuelle", "CRAFTING"}
        s["spell;created=450222"] = {"Grande ceinture en forge perpétuelle", "CRAFTING"}
        s["spell;created=450223"] = {"Défenseur en forge perpétuelle", "CRAFTING"}
        s["spell;created=450224"] = {"Heaume en forge perpétuelle", "CRAFTING"}
        s["spell;created=450226"] = {"Protège-bras en forge perpétuelle", "CRAFTING"}
        s["spell;created=450229"] = {"Eustache en forge perpétuelle", "CRAFTING"}
        s["spell;created=450230"] = {"Dague en forge perpétuelle", "CRAFTING"}
        s["spell;created=450231"] = {"Épée longue en forge perpétuelle", "CRAFTING"}
        s["spell;created=450232"] = {"Glaive de guerre en forge perpétuelle", "CRAFTING"}
        s["spell;created=450234"] = {"Bardiche en forge perpétuelle", "CRAFTING"}
        s["spell;created=450235"] = {"Maléfilame chargée", "CRAFTING"}
        s["spell;created=450237"] = {"Pilonneur chargé", "CRAFTING"}
        s["spell;created=450238"] = {"Claymore chargée", "CRAFTING"}
        s["spell;created=450239"] = {"Hallebarde chargée", "CRAFTING"}
        s["spell;created=450242"] = {"Tranchoir chargé", "CRAFTING"}
        s["spell;created=455391"] = {"Vivacité", ""}
        s["spell;created=455392"] = {"Symbiose", ""}
        s["spell;created=455394"] = {"Sublimation", ""}
        s["spell;created=473400"] = {"Reconfiguration pour les sorts", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationitIT()
        s["item:contained=229129"] = {"Cassa di Spoglie delle Scorribande", ""}
        s["item:contained=229354"] = {"Cassa dell'Avventuriero Algari", ""}
        s["item:contained=235639"] = {"Cassa dell'Avventuriero Veterano", ""}
        s["item:contained=238208"] = {"Dividendi in Crescita della Nonnina", ""}
        s["item:contained=262346"] = {"Forziere del Campione del Cercaprede", ""}
        s["npc;drop=122056"] = {"Viceré Nezhar", "Seggio del Triumvirato"}
        s["npc;drop=122313"] = {"Zuraal l'Asceso", "Seggio del Triumvirato"}
        s["npc;drop=122316"] = {"Saprish <Signore Etereo della Guardia dell'Ombra>", "Seggio del Triumvirato"}
        s["npc;drop=124729"] = {"L'ura", "Seggio del Triumvirato"}
        s["npc;drop=128649"] = {"Sergente Bainbridge", "Assedio di Boralus"}
        s["npc;drop=128650"] = {"Tagliatore Ganciorosso", "Assedio di Boralus"}
        s["npc;drop=128651"] = {"Hadal Fondoscuro", "Assedio di Boralus"}
        s["npc;drop=128652"] = {"Viq'goth <Terrore del Profondo>", "Assedio di Boralus"}
        s["npc;drop=129208"] = {"Capitano del Terrore Serralegno", "Assedio di Boralus"}
        s["npc;drop=129214"] = {"Sfollagente a Gettoni", "Vena Madre"}
        s["npc;drop=129227"] = {"Azerokk", "Vena Madre"}
        s["npc;drop=129231"] = {"Rixxa Flussafumi <Capo Scienziato>", "Vena Madre"}
        s["npc;drop=131227"] = {"Magnate Trucirazzi", "Vena Madre"}
        s["npc;drop=132713"] = {"Magnate Trucirazzi", "Vena Madre"}
        s["npc;drop=133384"] = {"Merektha", "Tempio di Sethraliss"}
        s["npc;drop=133389"] = {"Galvazzt", "Tempio di Sethraliss"}
        s["npc;drop=133392"] = {"Avatar di Sethraliss", "Tempio di Sethraliss"}
        s["npc;drop=133944"] = {"Aspix", "Tempio di Sethraliss"}
        s["npc;drop=134993"] = {"Mchimba l'Imbalsamatore", "Requie dei Re"}
        s["npc;drop=135322"] = {"Serpente Dorato", "Requie dei Re"}
        s["npc;drop=136160"] = {"Re Dazar <Il Primo>", "Requie dei Re"}
        s["npc;drop=144244"] = {"Flagellatore Platinato", "Operazione: Meccagon"}
        s["npc;drop=144246"] = {"K.U.-J.0.", "Operazione: Meccagon"}
        s["npc;drop=144248"] = {"Gran Macchinista Flussascintille", "Operazione: Meccagon"}
        s["npc;drop=150159"] = {"Re Gobbamak", "Operazione: Meccagon"}
        s["npc;drop=150222"] = {"Sporcheria", "Operazione: Meccagon"}
        s["npc;drop=150397"] = {"Re Meccagon", "Operazione: Meccagon"}
        s["npc;drop=152619"] = {"Re Meccagon", "Operazione: Meccagon"}
        s["npc;drop=156827"] = {"Eminenth", "Sale della Redenzione"}
        s["npc;drop=162309"] = {"Kul'tharok", "Teatro del Dolore"}
        s["npc;drop=162317"] = {"Fendisangue", "Teatro del Dolore"}
        s["npc;drop=162329"] = {"Xav l'Immortale", "Teatro del Dolore"}
        s["npc;drop=162689"] = {"Chirurgo Cucicarne", "Scia Necrotica"}
        s["npc;drop=162691"] = {"Piagaossa", "Scia Necrotica"}
        s["npc;drop=162693"] = {"Nalthor il Vincolabrina", "Scia Necrotica"}
        s["npc;drop=163157"] = {"Amarth <Il Mietitore>", "Scia Necrotica"}
        s["npc;drop=164185"] = {"Eminenth", "Sale della Redenzione"}
        s["npc;drop=164218"] = {"Ciambellano Supremo", "Sale della Redenzione"}
        s["npc;drop=164451"] = {"Dessia la Decapitatrice", "Teatro del Dolore"}
        s["npc;drop=164501"] = {"Evocanebbie", "Nebbie di Tirna Falcis"}
        s["npc;drop=164517"] = {"Tred'ova", "Nebbie di Tirna Falcis"}
        s["npc;drop=164567"] = {"Ingra Maloch", "Nebbie di Tirna Falcis"}
        s["npc;drop=165408"] = {"Halkias <Mastodonte Macchiato dal Peccato>", "Sale della Redenzione"}
        s["npc;drop=165410"] = {"Gran Giudice Aleez", "Sale della Redenzione"}
        s["npc;drop=165946"] = {"Mordretha, l'Imperatrice Eterna", "Teatro del Dolore"}
        s["npc;drop=175546"] = {"Capitano del Tempo Coduncino", "Tazavesh, il Bazar Celato"}
        s["npc;drop=175616"] = {"Zo'phex <La Sentinella>", "Tazavesh, il Bazar Celato"}
        s["npc;drop=175646"] = {"Direttore della P.O.S.T.A.", "Tazavesh, il Bazar Celato"}
        s["npc;drop=175663"] = {"Hylbrande <Spada dei Custodi>", "Tazavesh, il Bazar Celato"}
        s["npc;drop=175806"] = {"So'azmi", "Tazavesh, il Bazar Celato"}
        s["npc;drop=176556"] = {"Alcruux <L'Ingordo>", "Tazavesh, il Bazar Celato"}
        s["npc;drop=176563"] = {"Zo'gron", "Tazavesh, il Bazar Celato"}
        s["npc;drop=176705"] = {"Venza Micciadoro", "Tazavesh, il Bazar Celato"}
        s["npc;drop=177269"] = {"So'leah <Cartello So>", "Tazavesh, il Bazar Celato"}
        s["npc;drop=188252"] = {"Melidrussa Gelolacero <Specialista di Infusioni>", "Pozze della Vita di Rubino"}
        s["npc;drop=189232"] = {"Kokia Zoccolo Ardente", "Pozze della Vita di Rubino"}
        s["npc;drop=190485"] = {"Erkhart Venariosa", "Pozze della Vita di Rubino"}
        s["npc;drop=190609"] = {"Eco di Doragosa <Preside>", "Accademia di Algeth'ar"}
        s["npc;drop=191736"] = {"Crawth", "Accademia di Algeth'ar"}
        s["npc;drop=194181"] = {"Vexamus", "Accademia di Algeth'ar"}
        s["npc;drop=196482"] = {"Antico Erboso", "Accademia di Algeth'ar"}
        s["npc;drop=202318"] = {"Osservatrice della Squadra di Risposta", "Caverna di Zaralek"}
        s["npc;drop=203355"] = {"Capitana Reykal", "Caverna di Zaralek"}
        s["npc;drop=207205"] = {"Guardia della Tempesta Gorren", "Corveria"}
        s["npc;drop=207207"] = {"Mostruosità della Pietra del Vuoto", "Corveria"}
        s["npc;drop=207939"] = {"Barone Piccasolda", "Prioria della Fiamma Sacra"}
        s["npc;drop=207940"] = {"Priora Fedecerda", "Prioria della Fiamma Sacra"}
        s["npc;drop=207946"] = {"Capitano Urlassiduo", "Prioria della Fiamma Sacra"}
        s["npc;drop=208478"] = {"Volcoross", "Amirdrassil, Speranza del Sogno"}
        s["npc;drop=208743"] = {"Ardikon", "Faglia di Fiammoscura"}
        s["npc;drop=208745"] = {"Il Re delle Candele", "Faglia di Fiammoscura"}
        s["npc;drop=209230"] = {"Kyrioss", "Corveria"}
        s["npc;drop=210108"] = {"E.D.N.A.", "Volta di Pietra"}
        s["npc;drop=210153"] = {"Vecchio Barbacera", "Faglia di Fiammoscura"}
        s["npc;drop=210156"] = {"Skarmorak", "Volta di Pietra"}
        s["npc;drop=210267"] = {"I'pa", "Idromelificio Cinereo"}
        s["npc;drop=210271"] = {"Maestro dell'Idromele Aldryr", "Idromelificio Cinereo"}
        s["npc;drop=210797"] = {"L'Oscurità", "Faglia di Fiammoscura"}
        s["npc;drop=211087"] = {"Oratrice Sertombra", "Alba Infranta"}
        s["npc;drop=211089"] = {"Anub'ikkaj", "Alba Infranta"}
        s["npc;drop=213119"] = {"Oratore del Vuoto Eirich", "Volta di Pietra"}
        s["npc;drop=213179"] = {"Avanoxx", "Ara-Kara, Città degli Echi"}
        s["npc;drop=213217"] = {"Oratore Brokk", "Volta di Pietra"}
        s["npc;drop=214502"] = {"Orrore Vincolasangue", "Palazzo dei Nerub'ar"}
        s["npc;drop=214506"] = {"Mutastirpe Ovi'nax", "Palazzo dei Nerub'ar"}
        s["npc;drop=214661"] = {"Dora Bottepiena <Amministratrice Mielegata>", "Idromelificio Cinereo"}
        s["npc;drop=215405"] = {"Anub'zekt <Guardia dello Sciame>", "Ara-Kara, Città degli Echi"}
        s["npc;drop=215407"] = {"Ki'katal la Mietitrice", "Ara-Kara, Città degli Echi"}
        s["npc;drop=215657"] = {"Ulgrax il Divoratore", "Palazzo dei Nerub'ar"}
        s["npc;drop=216320"] = {"L'Amalgama Coagulato", "Città dei Fili"}
        s["npc;drop=216619"] = {"Oratore Krix'vizk <Il Quinto Filo>", "Città dei Fili"}
        s["npc;drop=216648"] = {"Nx <Zanna della Regina>", "Città dei Fili"}
        s["npc;drop=216658"] = {"Izo, la Gran Giuntatrice", "Città dei Fili"}
        s["npc;drop=217489"] = {"Anub'arash <Le Mille Cicatrici>", "Palazzo dei Nerub'ar"}
        s["npc;drop=218002"] = {"Benk il Ronzante <Apicoltore>", "Idromelificio Cinereo"}
        s["npc;drop=219778"] = {"Regina Ansurek", "Palazzo dei Nerub'ar"}
        s["npc;drop=219853"] = {"Sikran <Capitano dei Sureki>", "Palazzo dei Nerub'ar"}
        s["npc;drop=223779"] = {"Anub'arash <[The Thousand Scars]>", "Palazzo dei Nerub'ar"}
        s["npc;drop=223839"] = {"Guardia della Regina Ge'zah", "Palazzo dei Nerub'ar"}
        s["npc;drop=224552"] = {"Rasha'nan", "Alba Infranta"}
        s["npc;drop=225821"] = {"[The Geargrinder]", "Liberazione di Cavafonda"}
        s["npc;drop=226305"] = {"[Emperor Dagran Thaurissan]", "Sotterranei di Roccianera"}
        s["npc;drop=226306"] = {"[Golem Lord Argelmach]", "Sotterranei di Roccianera"}
        s["npc;drop=226315"] = {"[Lord Roccor]", "Sotterranei di Roccianera"}
        s["npc;drop=226396"] = {"[Swampface]", "Operazione: Paratoia"}
        s["npc;drop=226398"] = {"[Big M.O.M.M.A.]", "Operazione: Paratoia"}
        s["npc;drop=226403"] = {"[Keeza Quickfuse]", "Operazione: Paratoia"}
        s["npc;drop=226404"] = {"Geezle Gigascossa", "Operazione: Paratoia"}
        s["npc;drop=228458"] = {"[One-Armed Bandit]", "Liberazione di Cavafonda"}
        s["npc;drop=228470"] = {"Principessa del Nexus Ky'veza", "Palazzo dei Nerub'ar"}
        s["npc;drop=228652"] = {"[Rik Reverb]", "Liberazione di Cavafonda"}
        s["npc;drop=229181"] = {"[Flarendo]", "Liberazione di Cavafonda"}
        s["npc;drop=229284"] = {"Guk Tirabotte <Il Venditore di Sbobba>", "Liberazione di Cavafonda"}
        s["npc;drop=229288"] = {"Re Ontardente <Responsabile di Motorendo>", "Liberazione di Cavafonda"}
        s["npc;drop=229953"] = {"[Mug'Zee]", "Liberazione di Cavafonda"}
        s["npc;drop=229992"] = {"Stalagnarok", "Isola delle Sirene"}
        s["npc;drop=230322"] = {"[Stix Bunkjunker]", "Liberazione di Cavafonda"}
        s["npc;drop=230583"] = {"[Sprocketmonger Lockenstock]", "Liberazione di Cavafonda"}
        s["npc;drop=230800"] = {"[Slugger the Smart]", "Cavafonda"}
        s["npc;drop=230828"] = {"[Chief Foreman Gutso]", "Cavafonda"}
        s["npc;drop=230934"] = {"[Ratspit]", "Cavafonda"}
        s["npc;drop=230946"] = {"[V.V. Goosworth]", "Cavafonda"}
        s["npc;drop=231310"] = {"Precipitante dei Micciascura", "Cavafonda"}
        s["npc;drop=231606"] = {"Albardente", "Pinnacolo dei Ventolesto"}
        s["npc;drop=231626"] = {"Kalis", "Pinnacolo dei Ventolesto"}
        s["npc;drop=231631"] = {"Comandante Kroluk <Vecchia Orda>", "Pinnacolo dei Ventolesto"}
        s["npc;drop=231636"] = {"Cuore Irrequieto", "Pinnacolo dei Ventolesto"}
        s["npc;drop=231863"] = {"Seranel Frustasole", "Terrazza dei Magisteri"}
        s["npc;drop=231864"] = {"Gemellus", "Terrazza dei Magisteri"}
        s["npc;drop=231865"] = {"Degentrius", "Terrazza dei Magisteri"}
        s["npc;drop=231981"] = {"Fauci delle Sabbie", "K'aresh"}
        s["npc;drop=233814"] = {"Sentinella del Plesso", "Manaforgia Omega"}
        s["npc;drop=233815"] = {"Loom'ithar", "Manaforgia Omega"}
        s["npc;drop=233816"] = {"Vincolatrice d'Anime Naazindhri", "Manaforgia Omega"}
        s["npc;drop=233824"] = {"Dimensius", "Manaforgia Omega"}
        s["npc;drop=234647"] = {"Xathuux l'Annientatore <Guardiano di Lithiel>", "Traversa degli Intrighi"}
        s["npc;drop=234649"] = {"Zaen Dololama", "Traversa degli Intrighi"}
        s["npc;drop=234845"] = {"Sthaarbs <Il Turbamenti>", "K'aresh"}
        s["npc;drop=234893"] = {"Azhiccar", "Ecosfera Al'dani"}
        s["npc;drop=234933"] = {"Taah'bat <L'Implacabile>", "Ecosfera Al'dani"}
        s["npc;drop=235853"] = {"Guardiano del Portale di Traslocazione", "Manaforgia Omega"}
        s["npc;drop=237415"] = {"Lithiel Cenerfuria", "Traversa degli Intrighi"}
        s["npc;drop=237661"] = {"Adarus Fiammavespro", "Manaforgia Omega"}
        s["npc;drop=237763"] = {"Re del Nexus Salhadaar", "Manaforgia Omega"}
        s["npc;drop=237861"] = {"Fractillus <[The Shatterer]>", "Manaforgia Omega"}
        s["npc;drop=238887"] = {"Taz'rah", "Arena Sfregiavuoto"}
        s["npc;drop=239008"] = {"Atroxus", "Arena Sfregiavuoto"}
        s["npc;drop=239454"] = {"Mago Oscuro Zadus", "Manaforgia Omega"}
        s["npc;drop=240432"] = {"Re Caduto Salhadaar", "Pinnacolo del Vuoto"}
        s["npc;drop=240434"] = {"Vorasius", "Pinnacolo del Vuoto"}
        s["npc;drop=240435"] = {"Imperatore Averzian", "Pinnacolo del Vuoto"}
        s["npc;drop=241526"] = {"[Chrome King Gallywix]", "Liberazione di Cavafonda"}
        s["npc;drop=241546"] = {"Lothraxion <Gran Comandante>", ""}
        s["npc;drop=242031"] = {"Crestaspina <Pesca estrema>", "Zul'aman"}
        s["npc;drop=242056"] = {"Vaelgor", "Pinnacolo del Vuoto"}
        s["npc;drop=242255"] = {"Geezle Gigazap", "Operazione: Paratoia"}
        s["npc;drop=24239"] = {"Malacrass il Perfido", "Abissi Velenosi"}
        s["npc;drop=243028"] = {"Meittik", "Valle Accecante"}
        s["npc;drop=244752"] = {"Principessa del Nexus Ky'veza", "Santuario Fendivuoto"}
        s["npc;drop=244761"] = {"Alleria Windrunner", "Pinnacolo del Vuoto"}
        s["npc;drop=244762"] = {"Lu'ashal", "Boschi di Cantoeterno"}
        s["npc;drop=244887"] = {"Ikuzz il Cacciatore di Luce", "Valle Accecante"}
        s["npc;drop=245044"] = {"Progenie della Notte", "Tempesta del Vuoto"}
        s["npc;drop=245912"] = {"Custode della Luce Ruia", "Valle Accecante"}
        s["npc;drop=246633"] = {"Zampalesta Affannato", "Boschi di Cantoeterno"}
        s["npc;drop=246729"] = {"Brace della Luce <Figlio di Belo'ren>", "Isola di Quel'Danas"}
        s["npc;drop=247283"] = {"Scriba dell'Anima", ""}
        s["npc;drop=247570"] = {"Muro'jin", "Caverne di Maisara"}
        s["npc;drop=247676"] = {"Ziekket <Prole della Luce Contorta>", "Valle Accecante"}
        s["npc;drop=247976"] = {"Bracconiere Rav'ik <Tribù Ramovile>", "Zul'aman"}
        s["npc;drop=247989"] = {"Tessiforgia Araz", "Manaforgia Omega"}
        s["npc;drop=248015"] = {"Charonus", "Arena Sfregiavuoto"}
        s["npc;drop=248595"] = {"Vordaza", "Caverne di Maisara"}
        s["npc;drop=248605"] = {"Rak'tul <Ricettacolo d'Anime>", "Caverne di Maisara"}
        s["npc;drop=248710"] = {"L'Accumulatore <Tribù Zampaspirito>", "Tana di Nalorakk"}
        s["npc;drop=248823"] = {"Nucleo Nero", "Tempesta del Vuoto"}
        s["npc;drop=249844"] = {"Chironex <La Morte Fluttuante>", "Harandar"}
        s["npc;drop=250086"] = {"Troncolo <Terrore di Harandar>", "Harandar"}
        s["npc;drop=250358"] = {"Annulus lo Scuotimondo", "Harandar"}
        s["npc;drop=250589"] = {"Cappellana di Guerra Senn", "Pinnacolo del Vuoto"}
        s["npc;drop=252458"] = {"Kystia Manacuore", "Traversa degli Intrighi"}
        s["npc;drop=252959"] = {"Invocatrice dell'Onda Nymrissa", "Grotta Vincolata alla Marea"}
        s["npc;drop=254176"] = {"Fangorrido", "Sporandia"}
        s["npc;drop=254227"] = {"Custode del Nucleo Nysarra", ""}
        s["npc;drop=256116"] = {"Chimaerus <Dio Mai Sognato>", "Frattura del Sogno"}
        s["npc;drop=257347"] = {"Sszorak", "Abissi Velenosi"}
        s["npc;drop=257361"] = {"Vexhul", "Abissi Velenosi"}
        s["npc;drop=257906"] = {"Skully Occhio a Moneta", "Isola Serpeggiante"}
        s["npc;drop=258557"] = {"Soffio di Ula'tek", "Abissi Velenosi"}
        s["npc;drop=258877"] = {"Nalorakk <Loa della Guerra>", "Tana di Nalorakk"}
        s["npc;drop=258916"] = {"Garsecg <Lo Sfondascafi>", "Isola Serpeggiante"}
        s["npc;drop=259445"] = {"Rav'i", "Altare delle Zanne"}
        s["npc;drop=259446"] = {"Spirale Contorcente", "Altare delle Zanne"}
        s["npc;drop=259447"] = {"Zul'jan", "Altare delle Zanne"}
        s["npc;drop=260905"] = {"Veleno Bruciante", "Abissi Velenosi"}
        s["npc;drop=261053"] = {"Sentinella dell'Inverno", "Tana di Nalorakk"}
        s["npc;drop=263456"] = {"Szarith lo Zannuto", ""}
        s["npc;drop=264854"] = {"Farthik la Saccheggiatrice", "Isola Serpeggiante"}
        s["npc;drop=267077"] = {"Mor'zahi", "Abissi Velenosi"}
        s["npc;drop=268090"] = {"Kari'zah il Dimenticato", "Isola Serpeggiante"}
        s["npc;drop=268956"] = {"Ula'tek", "Abissi Velenosi"}
        s["npc;drop=269808"] = {"Aka'ali la Conquistatrice", "Requie dei Re"}
        s["npc;drop=271337"] = {"Echo of Jawae <[Soulcoiler Cult]>", "Abissi Velenosi"}
        s["npc;drop=36476"] = {"Ick <Servitore di Krick>", "Fossa di Saron"}
        s["npc;drop=36494"] = {"Mastro Forgiatore Gargelo", "Fossa di Saron"}
        s["npc;drop=36658"] = {"Signore della Piaga Tirannus", "Fossa di Saron"}
        s["npc;drop=39625"] = {"Generale Umbriss <Servitore di Alamorte>", "Grim Batol"}
        s["npc;drop=40177"] = {"Mastro Forgiatore Throngus", "Grim Batol"}
        s["npc;drop=40319"] = {"Drahga Strinaombre <Emissario del Martello del Crepuscolo>", "Grim Batol"}
        s["npc;drop=40484"] = {"Erudax <Duca delle Profondità>", "Grim Batol"}
        s["npc;drop=75452"] = {"Fauci d'Ossa", "Necropoli dei Torvaluna"}
        s["npc;drop=75964"] = {"Ranjit <Maestro dei Quattro Venti>", "Vetta dei Cieli"}
        s["npc;drop=76141"] = {"Araknath <Costrutto del Sole>", "Vetta dei Cieli"}
        s["npc;drop=76266"] = {"Alta Saggia Viryx", "Vetta dei Cieli"}
        s["npc;drop=76379"] = {"Rukhran", "Vetta dei Cieli"}
        s["npc;sold=219222"] = {"Lalandi <Quartiermastro della Conquista>", "Dornogal"}
        s["npc;sold=224270"] = {"Ip'xal <Stilista dell'Eroe>", "Città dei Fili"}
        s["npc;sold=227003"] = {"Kir'xal <Collezionista di Curiosità>", "Città dei Fili"}
        s["npc;sold=231824"] = {"[Kari Bridgeblaster]", "Cavafonda"}
        s["npc;sold=243220"] = {"Irissa Stellacremisi <Quartiermastra della Conquista>", "Lunargenta"}
        s["npc;sold=248303"] = {"Zah'ran <[Delve Trinkets]>", "Sito di Scavo 9"}
        s["npc;sold=256670"] = {"Zah'ran <Equipaggiamento per le Scorribande>", "Calamità Accademica"}
        s["object;contained=413563"] = {"Baule Pesante", "Caverna del Micomante"}
        s["object;contained=413590"] = {"Scrigno Fruttuoso", "Fossa del Terrore"}
        s["object;contained=416265"] = {"Baule Trafugato", "Fossa del Terrore"}
        s["object;contained=476068"] = {"[Papa's Prized Putter]", "Cavafonda"}
        s["object;contained=507768"] = {"Mucchio di Soldi dei Goblin Gettati", "Sito di Scavo 9"}
        s["object;contained=574407"] = {"Cassa dello Sfidante", "Terrazza dei Magisteri"}
        s["object;contained=574409"] = {"Cassa dello Sfidante", ""}
        s["object;contained=581922"] = {"Tesoro Nascosto", "Calamità Accademica"}
        s["object;contained=584514"] = {"Scrigno Fruttuoso", "Calamità Accademica"}
        s["object;contained=584518"] = {"Baule Pesante Fruttuoso", "Calamità Accademica"}
        s["object;contained=584519"] = {"Baule Pesante", "Calamità Accademica"}
        s["quest;reward=66119"] = {"Pozze della Vita di Rubino: Invasione dei Primalisti", ""}
        s["quest;reward=78232"] = {"Riscrivere i riscritti", ""}
        s["quest;reward=78636"] = {"Riconquistare le miniere", ""}
        s["quest;reward=79342"] = {"Mentre se ne va", ""}
        s["quest;reward=83125"] = {"", "Zuldazar"}
        s["quest;reward=86521"] = {"Punta del Nexus Xenas: eclissi", ""}
        s["quest;reward=91009"] = {"Deposito Informazioni Sicure a Controllo Ottimale", "Dornogal"}
        s["quest;reward=91694"] = {"Arena Sfregiavuoto: spezzare la triade", ""}
        s["quest;reward=91958"] = {"Tana di Nalorakk: implacabile", ""}
        s["quest;reward=93417"] = {"Le Segrete di Atal'utek: Altare delle Zanne", ""}
        s["quest;reward=93651"] = {"Valle Accecante: radici della Fioritura di Luce", ""}
        s["quest;reward=93933"] = {"Tesori custoditi", ""}
        s["spell;created=1228945"] = {"Manette del Martire", "CRAFTING"}
        s["spell;created=1228950"] = {"Manto di Seta del Proselito", "CRAFTING"}
        s["spell;created=1228984"] = {"Bracciali di Tramarcana", "CRAFTING"}
        s["spell;created=1228985"] = {"Mantello di Tramarcana", "CRAFTING"}
        s["spell;created=1228988"] = {"Fascione di Tramarcana", "CRAFTING"}
        s["spell;created=1229648"] = {"Spadone da Guerra del Cavaliere del Sangue", "CRAFTING"}
        s["spell;created=1229649"] = {"Artiglio Forgiato dalla Fioritura", "CRAFTING"}
        s["spell;created=1229657"] = {"Lame da Guerra dello Spezzamagie", "CRAFTING"}
        s["spell;created=1229659"] = {"Pietà dei Lungopasso", "CRAFTING"}
        s["spell;created=1229662"] = {"Bracciali dello Spezzamagie", "CRAFTING"}
        s["spell;created=1229875"] = {"Fasce di Eterlume", "CRAFTING"}
        s["spell;created=1229877"] = {"Parapolsi di Eterlume", "CRAFTING"}
        s["spell;created=1230061"] = {"Lanterna di Aln'hara", "CRAFTING"}
        s["spell;created=1230070"] = {"Dominio di Lunacupa: Sangue", "CRAFTING"}
        s["spell;created=1230071"] = {"Dominio di Lunacupa: Marciume", "CRAFTING"}
        s["spell;created=1230072"] = {"Dominio di Lunacupa: Caccia", "CRAFTING"}
        s["spell;created=1230073"] = {"Dominio di Lunacupa: Vuoto", "CRAFTING"}
        s["spell;created=1230479"] = {"Vera degli Adoratori dei Loa", "CRAFTING"}
        s["spell;created=1230485"] = {"Vera Capolavoro dei Sin'dorei", "CRAFTING"}
        s["spell;created=1230486"] = {"Amuleto Capolavoro dei Sin'dorei", "CRAFTING"}
        s["spell;created=1230487"] = {"Anello con Sigillo delle Benedizioni Azerothiane", "CRAFTING"}
        s["spell;created=1230861"] = {"Pietra Filosofale Primordiale", "CRAFTING"}
        s["spell;created=1230885"] = {"Pietra Alchemica del Magistro", "CRAFTING"}
        s["spell;created=1237508"] = {"Calzature dell'Agente di Lunargenta", "CRAFTING"}
        s["spell;created=1237509"] = {"Mitene dell'Agente di Lunargenta", "CRAFTING"}
        s["spell;created=1237513"] = {"Cintura Multiuso dell'Agente di Lunargenta", "CRAFTING"}
        s["spell;created=1237514"] = {"Deflettori dell'Agente di Lunargenta", "CRAFTING"}
        s["spell;created=1237518"] = {"Stivali Radicali del Custode del Mondo", "CRAFTING"}
        s["spell;created=1237519"] = {"Fibbia Corticale del Custode del Mondo", "CRAFTING"}
        s["spell;created=1237537"] = {"Artigli Affilati dei Lungopasso", "CRAFTING"}
        s["spell;created=1237543"] = {"Bracciali a Piastre dei Lungopasso", "CRAFTING"}
        s["spell;created=1249111"] = {"Ricevimento Fasciature", "CRAFTING"}
        s["spell;created=1253219"] = {"Caccia", ""}
        s["spell;created=1253220"] = {"Vuoto", ""}
        s["spell;created=1253221"] = {"Sangue", ""}
        s["spell;created=1253222"] = {"Marciume", ""}
        s["spell;created=237828"] = {"Runa Vantus - Inquisizione Demoniaca", ""}
        s["spell;created=239649"] = {"Schianto Infernale", ""}
        s["spell;created=244572"] = {"Evocazione: Spirito", ""}
        s["spell;created=244581"] = {"Cometa Dirompente", ""}
        s["spell;created=427185"] = {"Pietra Alchemica Algari", "CRAFTING"}
        s["spell;created=435382"] = {"Vera del Vincolo", "CRAFTING"}
        s["spell;created=435384"] = {"Anello dell'Artigianato Terrigeno", "CRAFTING"}
        s["spell;created=435385"] = {"Amuleto dell'Artigianato Terrigeno", "CRAFTING"}
        s["spell;created=441051"] = {"Giubba Marchiata con Rune", "CRAFTING"}
        s["spell;created=441052"] = {"Tiracalci Marchiati con Rune", "CRAFTING"}
        s["spell;created=441053"] = {"Guardamani Marchiati con Rune", "CRAFTING"}
        s["spell;created=441055"] = {"Coprigambe Marchiati con Rune", "CRAFTING"}
        s["spell;created=441057"] = {"Fusciacca Marchiata con Rune", "CRAFTING"}
        s["spell;created=441058"] = {"Antibracci Marchiati con Rune", "CRAFTING"}
        s["spell;created=441060"] = {"Stivalacci Incisi con Glifi", "CRAFTING"}
        s["spell;created=441061"] = {"Guanti Lunghi Incisi con Glifi", "CRAFTING"}
        s["spell;created=441063"] = {"Cosciali Incisi con Glifi", "CRAFTING"}
        s["spell;created=441065"] = {"Cinta Incisa con Glifi", "CRAFTING"}
        s["spell;created=441066"] = {"Avambracci Incisi con Glifi", "CRAFTING"}
        s["spell;created=444070"] = {"Fibbia dell'Impeto Adrenalinico", "CRAFTING"}
        s["spell;created=444197"] = {"Torcia del Vagabondo", "CRAFTING"}
        s["spell;created=444198"] = {"Stampella Attenta del Vagabondo", "CRAFTING"}
        s["spell;created=444199"] = {"Bacchetta Vincolante del Vagabondo", "CRAFTING"}
        s["spell;created=445355"] = {"Scettro delle Magie Radiose", "CRAFTING"}
        s["spell;created=446937"] = {"Pianelle Consacrate", "CRAFTING"}
        s["spell;created=446938"] = {"Polsiere Consacrate", "CRAFTING"}
        s["spell;created=446939"] = {"Fascione Consacrato", "CRAFTING"}
        s["spell;created=446940"] = {"Mantello Consacrato", "CRAFTING"}
        s["spell;created=447314"] = {"Acceleratore di Acume Erudito", "CRAFTING"}
        s["spell;created=447315"] = {"Generatore di Idee Velocizzato", "CRAFTING"}
        s["spell;created=450220"] = {"Calzari Eternoforgiati", "CRAFTING"}
        s["spell;created=450222"] = {"Grancintura Eternoforgiata", "CRAFTING"}
        s["spell;created=450223"] = {"Difensore Eternoforgiato", "CRAFTING"}
        s["spell;created=450224"] = {"Elmo Eternoforgiato", "CRAFTING"}
        s["spell;created=450226"] = {"Avambracci Eternoforgiati", "CRAFTING"}
        s["spell;created=450229"] = {"Daga Eternoforgiata", "CRAFTING"}
        s["spell;created=450230"] = {"Pugnale Eternoforgiato", "CRAFTING"}
        s["spell;created=450231"] = {"Spada Lunga Eternoforgiata", "CRAFTING"}
        s["spell;created=450232"] = {"Lame da Guerra Eternoforgiate", "CRAFTING"}
        s["spell;created=450234"] = {"Grandascia Eternoforgiata", "CRAFTING"}
        s["spell;created=450235"] = {"Spada Maledetta Carica", "CRAFTING"}
        s["spell;created=450237"] = {"Sfondafacce Carico", "CRAFTING"}
        s["spell;created=450238"] = {"Spadone Carico", "CRAFTING"}
        s["spell;created=450239"] = {"Alabarda Carica", "CRAFTING"}
        s["spell;created=450242"] = {"Ascia Tagliente Caricata", "CRAFTING"}
        s["spell;created=455391"] = {"Vivacità", ""}
        s["spell;created=455392"] = {"Simbiosi", ""}
        s["spell;created=455393"] = {"Radiosità", ""}
        s["spell;created=455394"] = {"Ascensione", ""}
        s["spell;created=473400"] = {"Riconfigurazione per Lancio d'Incantesimi", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationkoKR()
        s["item:contained=229129"] = {"구렁 탐험가의 전리품 보관함", ""}
        s["item:contained=229354"] = {"알가르 모험가의 보관함", ""}
        s["item:contained=235639"] = {"노련한 모험가의 보관함", ""}
        s["item:contained=238208"] = {"대모의 폭등 배당금", ""}
        s["item:contained=262346"] = {"사냥감 추적자의 챔피언 궤짝", ""}
        s["npc;drop=122056"] = {"총독 네자르", "삼두정의 권좌"}
        s["npc;drop=122313"] = {"승천자 주라알", "삼두정의 권좌"}
        s["npc;drop=122316"] = {"사프리쉬 <어둠수호 에테리움 군주>", "삼두정의 권좌"}
        s["npc;drop=124729"] = {"르우라", "삼두정의 권좌"}
        s["npc;drop=128649"] = {"하사관 베인브릿지", "보랄러스 공성전"}
        s["npc;drop=128650"] = {"난도질꾼 레드후크", "보랄러스 공성전"}
        s["npc;drop=128651"] = {"하달 다크패덤", "보랄러스 공성전"}
        s["npc;drop=128652"] = {"비크고스 <심해의 공포>", "보랄러스 공성전"}
        s["npc;drop=129208"] = {"공포의 선장 록우드", "보랄러스 공성전"}
        s["npc;drop=129214"] = {"동전 투입식 군중 난타기", "왕노다지 광산!!"}
        s["npc;drop=129227"] = {"아제로크", "왕노다지 광산!!"}
        s["npc;drop=129231"] = {"릭사 플럭스플레임 <수석 과학자>", "왕노다지 광산!!"}
        s["npc;drop=131227"] = {"모굴 라즈덩크", "왕노다지 광산!!"}
        s["npc;drop=132713"] = {"모굴 라즈덩크", "왕노다지 광산!!"}
        s["npc;drop=133384"] = {"메레크타", "세스랄리스 사원"}
        s["npc;drop=133389"] = {"갈바즈트", "세스랄리스 사원"}
        s["npc;drop=133392"] = {"세스랄리스의 화신", "세스랄리스 사원"}
        s["npc;drop=133944"] = {"아스픽스", "세스랄리스 사원"}
        s["npc;drop=134993"] = {"장의사 음침바", "왕들의 안식처"}
        s["npc;drop=135322"] = {"황금 날뱀", "왕들의 안식처"}
        s["npc;drop=136160"] = {"왕 다자르 <초대 왕>", "왕들의 안식처"}
        s["npc;drop=144244"] = {"백금 난타로봇", "작전명: 메카곤"}
        s["npc;drop=144246"] = {"쿠.조.", "작전명: 메카곤"}
        s["npc;drop=144248"] = {"수석 기계공 스파크플럭스", "작전명: 메카곤"}
        s["npc;drop=150159"] = {"왕 고바막", "작전명: 메카곤"}
        s["npc;drop=150222"] = {"진창오물", "작전명: 메카곤"}
        s["npc;drop=150397"] = {"왕 메카곤", "작전명: 메카곤"}
        s["npc;drop=152619"] = {"왕 메카곤", "작전명: 메카곤"}
        s["npc;drop=156827"] = {"에첼론", "속죄의 전당"}
        s["npc;drop=162309"] = {"쿨타로크", "고통의 투기장"}
        s["npc;drop=162317"] = {"선혈토막", "고통의 투기장"}
        s["npc;drop=162329"] = {"몰락하지 않은 자 자브", "고통의 투기장"}
        s["npc;drop=162689"] = {"의사 스티치플레시", "죽음의 상흔"}
        s["npc;drop=162691"] = {"역병뼈닥이", "죽음의 상흔"}
        s["npc;drop=162693"] = {"냉기결속사 날토르", "죽음의 상흔"}
        s["npc;drop=163157"] = {"아마스 <수확자>", "죽음의 상흔"}
        s["npc;drop=164185"] = {"에첼론", "속죄의 전당"}
        s["npc;drop=164218"] = {"시종장", "속죄의 전당"}
        s["npc;drop=164451"] = {"참수자 데시아", "고통의 투기장"}
        s["npc;drop=164501"] = {"미스트콜러", "티르너 사이드의 안개"}
        s["npc;drop=164517"] = {"트레도바", "티르너 사이드의 안개"}
        s["npc;drop=164567"] = {"잉그라 말로크", "티르너 사이드의 안개"}
        s["npc;drop=165408"] = {"할키아스 <죄악에 물든 거수>", "속죄의 전당"}
        s["npc;drop=165410"] = {"대심판관 알리즈", "속죄의 전당"}
        s["npc;drop=165946"] = {"무한의 여제 모르드레타", "고통의 투기장"}
        s["npc;drop=175546"] = {"시간선장 후크테일", "미지의 시장 타자베쉬"}
        s["npc;drop=175616"] = {"조펙스 <파수꾼>", "미지의 시장 타자베쉬"}
        s["npc;drop=175646"] = {"우.정.국.장.", "미지의 시장 타자베쉬"}
        s["npc;drop=175663"] = {"힐브란데 <수호자의 칼>", "미지의 시장 타자베쉬"}
        s["npc;drop=175806"] = {"소아즈미", "미지의 시장 타자베쉬"}
        s["npc;drop=176556"] = {"알크룩스 <게걸먹보>", "미지의 시장 타자베쉬"}
        s["npc;drop=176563"] = {"조그론", "미지의 시장 타자베쉬"}
        s["npc;drop=176705"] = {"벤자 골드퓨즈", "미지의 시장 타자베쉬"}
        s["npc;drop=177269"] = {"소레아 <소 중개단>", "미지의 시장 타자베쉬"}
        s["npc;drop=188252"] = {"멜리드루사 칠원 <주입 전문가>", "루비 생명의 웅덩이"}
        s["npc;drop=189232"] = {"코키아 블레이즈후프", "루비 생명의 웅덩이"}
        s["npc;drop=190485"] = {"에크하트 스톰베인", "루비 생명의 웅덩이"}
        s["npc;drop=190609"] = {"도라고사의 메아리 <교장>", "알게타르 대학"}
        s["npc;drop=191736"] = {"크로스", "알게타르 대학"}
        s["npc;drop=194181"] = {"벡사무스", "알게타르 대학"}
        s["npc;drop=196482"] = {"비대해진 고대정령", "알게타르 대학"}
        s["npc;drop=202318"] = {"대응반 감시자", "자랄레크 동굴"}
        s["npc;drop=203355"] = {"대장 레이칼", "자랄레크 동굴"}
        s["npc;drop=207205"] = {"폭풍수호병 고렌", "부화장"}
        s["npc;drop=207207"] = {"공허석 괴수", "부화장"}
        s["npc;drop=207939"] = {"남작 브라운파이크", "신성한 불꽃의 수도원"}
        s["npc;drop=207940"] = {"수도원장 머프레이", "신성한 불꽃의 수도원"}
        s["npc;drop=207946"] = {"대장 데일크라이", "신성한 불꽃의 수도원"}
        s["npc;drop=208478"] = {"볼코로스", "꿈의 희망 아미드랏실"}
        s["npc;drop=208743"] = {"블레지콘", "어둠불꽃 동굴"}
        s["npc;drop=208745"] = {"양초왕", "어둠불꽃 동굴"}
        s["npc;drop=209230"] = {"키리오스", "부화장"}
        s["npc;drop=210108"] = {"토.보.무.전", "바위금고"}
        s["npc;drop=210153"] = {"밀랍수염 영감", "어둠불꽃 동굴"}
        s["npc;drop=210156"] = {"스카모락", "바위금고"}
        s["npc;drop=210267"] = {"이파", "잿불맥주 양조장"}
        s["npc;drop=210271"] = {"양조장인 알드리르", "잿불맥주 양조장"}
        s["npc;drop=210797"] = {"어둠의 존재", "어둠불꽃 동굴"}
        s["npc;drop=211087"] = {"대변자 섀도크라운", "새벽인도자호"}
        s["npc;drop=211089"] = {"아눕이카즈", "새벽인도자호"}
        s["npc;drop=213119"] = {"공허 대변자 에리히", "바위금고"}
        s["npc;drop=213179"] = {"아바녹스", "메아리의 도시 아라카라"}
        s["npc;drop=213217"] = {"대변자 브록", "바위금고"}
        s["npc;drop=214502"] = {"피결속 공포", "네룹아르 궁전"}
        s["npc;drop=214506"] = {"혈족왜곡자 오비낙스", "네룹아르 궁전"}
        s["npc;drop=214650"] = {"르우라", "에레다스"}
        s["npc;drop=214661"] = {"골디 바론바텀 <최고 양봉 경영자>", "잿불맥주 양조장"}
        s["npc;drop=215405"] = {"아눕젝트 <무리경비병>", "메아리의 도시 아라카라"}
        s["npc;drop=215407"] = {"수확자 키카탈", "메아리의 도시 아라카라"}
        s["npc;drop=215657"] = {"포식자 울그락스", "네룹아르 궁전"}
        s["npc;drop=216320"] = {"응집체", "실타래의 도시"}
        s["npc;drop=216619"] = {"웅변가 크릭스비즈크 <다섯 번째 가닥>", "실타래의 도시"}
        s["npc;drop=216648"] = {"늑스 <여왕의 송곳니>", "실타래의 도시"}
        s["npc;drop=216658"] = {"대접합사 이조", "실타래의 도시"}
        s["npc;drop=217489"] = {"아눕아라쉬 <일천 개의 상흔>", "네룹아르 궁전"}
        s["npc;drop=218002"] = {"벤크 버즈비 <벌지기>", "잿불맥주 양조장"}
        s["npc;drop=219778"] = {"여왕 안수레크", "네룹아르 궁전"}
        s["npc;drop=219853"] = {"시크란 <수레키 대장>", "네룹아르 궁전"}
        s["npc;drop=223779"] = {"아눕아라쉬 <일천 개의 상흔>", "네룹아르 궁전"}
        s["npc;drop=223839"] = {"여왕 근위병 게자", "네룹아르 궁전"}
        s["npc;drop=224552"] = {"라샤난", "네룹아르 궁전"}
        s["npc;drop=225821"] = {"[The Geargrinder]", "언더마인 해방전선"}
        s["npc;drop=226305"] = {"[Emperor Dagran Thaurissan]", "검은바위 나락"}
        s["npc;drop=226306"] = {"[Golem Lord Argelmach]", "검은바위 나락"}
        s["npc;drop=226315"] = {"[Lord Roccor]", "검은바위 나락"}
        s["npc;drop=226396"] = {"[Swampface]", "작전명: 수문"}
        s["npc;drop=226398"] = {"[Big M.O.M.M.A.]", "작전명: 수문"}
        s["npc;drop=226403"] = {"[Keeza Quickfuse]", "작전명: 수문"}
        s["npc;drop=226404"] = {"기즐 기가잽", "작전명: 수문"}
        s["npc;drop=228458"] = {"[One-Armed Bandit]", "언더마인 해방전선"}
        s["npc;drop=228470"] = {"연합공작 카이베자", "네룹아르 궁전"}
        s["npc;drop=228652"] = {"[Rik Reverb]", "언더마인 해방전선"}
        s["npc;drop=229181"] = {"[Flarendo]", "언더마인 해방전선"}
        s["npc;drop=229284"] = {"구크 붐도그 <음식물 행상인>", "언더마인 해방전선"}
        s["npc;drop=229288"] = {"왕 불꽃원한 <플레렌도의 담당자>", "언더마인 해방전선"}
        s["npc;drop=229953"] = {"[Mug'Zee]", "언더마인 해방전선"}
        s["npc;drop=229992"] = {"스탈라그나로그", "세이렌의 섬"}
        s["npc;drop=230322"] = {"[Stix Bunkjunker]", "언더마인 해방전선"}
        s["npc;drop=230583"] = {"[Sprocketmonger Lockenstock]", "언더마인 해방전선"}
        s["npc;drop=230800"] = {"[Slugger the Smart]", "언더마인"}
        s["npc;drop=230828"] = {"[Chief Foreman Gutso]", "언더마인"}
        s["npc;drop=230934"] = {"[Ratspit]", "언더마인"}
        s["npc;drop=230946"] = {"[V.V. Goosworth]", "언더마인"}
        s["npc;drop=231310"] = {"다크퓨즈 침전물", "언더마인"}
        s["npc;drop=231606"] = {"잿불여명", "윈드러너 첨탑"}
        s["npc;drop=231626"] = {"칼리스", "윈드러너 첨탑"}
        s["npc;drop=231631"] = {"지휘관 크롤루크 <구 호드>", "윈드러너 첨탑"}
        s["npc;drop=231636"] = {"잠 못 드는 심장", "윈드러너 첨탑"}
        s["npc;drop=231863"] = {"사라넬 선래쉬", "마법학자의 정원"}
        s["npc;drop=231864"] = {"제멜루스", "마법학자의 정원"}
        s["npc;drop=231865"] = {"디젠트리우스", "마법학자의 정원"}
        s["npc;drop=231981"] = {"모래의 아귀", "크아레쉬"}
        s["npc;drop=233814"] = {"흐름망 파수꾼", "마나괴철로 종극점"}
        s["npc;drop=233815"] = {"룸이타르", "마나괴철로 종극점"}
        s["npc;drop=233816"] = {"영혼술사 나진드리", "마나괴철로 종극점"}
        s["npc;drop=233824"] = {"디멘시우스", "마나괴철로 종극점"}
        s["npc;drop=234647"] = {"파멸자 자투스 <리시엘의 수호자>", "죽음의 골목"}
        s["npc;drop=234649"] = {"자엔 블레이드소로우", "죽음의 골목"}
        s["npc;drop=234845"] = {"스타브스 <정신교란자>", "크아레쉬"}
        s["npc;drop=234893"] = {"아즈히카르", "생태지구 알다니"}
        s["npc;drop=234933"] = {"타바트 <가혹한 자>", "생태지구 알다니"}
        s["npc;drop=235853"] = {"차원문 감시자", "마나괴철로 종극점"}
        s["npc;drop=237415"] = {"리시엘 신더퓨리", "죽음의 골목"}
        s["npc;drop=237661"] = {"아다루스 더스크블레이즈", "마나괴철로 종극점"}
        s["npc;drop=237763"] = {"연합왕 살라다르", "마나괴철로 종극점"}
        s["npc;drop=237861"] = {"Fractillus <[The Shatterer]>", "마나괴철로 종극점"}
        s["npc;drop=238887"] = {"타즈라", "공허흉터 투기장"}
        s["npc;drop=239008"] = {"아트로서스", "공허흉터 투기장"}
        s["npc;drop=239454"] = {"암흑마법사 자두스", "마나괴철로 종극점"}
        s["npc;drop=240432"] = {"몰락한 왕 살라다르", "공허첨탑"}
        s["npc;drop=240434"] = {"보라시우스", "공허첨탑"}
        s["npc;drop=240435"] = {"전제군주 아베르지안", "공허첨탑"}
        s["npc;drop=241526"] = {"[Chrome King Gallywix]", "언더마인 해방전선"}
        s["npc;drop=241546"] = {"로스락시온 <총사령관>", ""}
        s["npc;drop=242031"] = {"가시주름 <위험한 사냥>", "줄아만"}
        s["npc;drop=242056"] = {"바엘고어", "공허첨탑"}
        s["npc;drop=242255"] = {"Geezle Gigazap", "작전명: 수문"}
        s["npc;drop=24239"] = {"사술 군주 말라크라스", "맹독 심연"}
        s["npc;drop=243028"] = {"메이티크", "눈부신 골짜기"}
        s["npc;drop=244752"] = {"연합공작 카이베자", "공허서슬 성역"}
        s["npc;drop=244761"] = {"Alleria Windrunner", "공허첨탑"}
        s["npc;drop=244762"] = {"루아샬", "영원노래 숲"}
        s["npc;drop=244887"] = {"빛 사냥꾼 이쿠즈", "눈부신 골짜기"}
        s["npc;drop=245044"] = {"밤의 혈족", "공허폭풍"}
        s["npc;drop=245912"] = {"빛의 감시자 루이아", "눈부신 골짜기"}
        s["npc;drop=246633"] = {"초조한 매타조", "영원노래 숲"}
        s["npc;drop=246729"] = {"빛의 불씨 <벨로렌의 자손>", "쿠엘다나스 섬"}
        s["npc;drop=247283"] = {"Soul-Scribe", ""}
        s["npc;drop=247570"] = {"무로진", "마이사라 동굴"}
        s["npc;drop=247676"] = {"지케트 <옹이진 빛의 정령>", "눈부신 골짜기"}
        s["npc;drop=247976"] = {"밀렵꾼 라빅 <썩은가지 부족>", "줄아만"}
        s["npc;drop=247989"] = {"제련직공 아라즈", "마나괴철로 종극점"}
        s["npc;drop=248015"] = {"차로누스", "공허흉터 투기장"}
        s["npc;drop=248595"] = {"보르다자", "마이사라 동굴"}
        s["npc;drop=248605"] = {"락툴 <영혼의 그릇>", "마이사라 동굴"}
        s["npc;drop=248710"] = {"The Hoardmonger <[Spiritpaw Tribe]>", "날로라크의 소굴"}
        s["npc;drop=248823"] = {"검은 핵", "공허폭풍"}
        s["npc;drop=249844"] = {"시로넥스 <날아다니는 죽음>", "하란다르"}
        s["npc;drop=250086"] = {"몽땅이 <하란다르의 공포>", "하란다르"}
        s["npc;drop=250358"] = {"세계전율자 아눌루스", "하란다르"}
        s["npc;drop=250589"] = {"전투전도사 센", "공허첨탑"}
        s["npc;drop=252458"] = {"키스티아 마나하트", "죽음의 골목"}
        s["npc;drop=252959"] = {"님리사 웨이브콜러", "해일결속 동굴"}
        s["npc;drop=254176"] = {"부식수렁", "진균나락"}
        s["npc;drop=254227"] = {"핵감시관 니사라", ""}
        s["npc;drop=256116"] = {"카이메루스 <꿈결을 벗어난 신>", "꿈의 균열"}
        s["npc;drop=257347"] = {"스조라크", "맹독 심연"}
        s["npc;drop=257361"] = {"벡스훌", "맹독 심연"}
        s["npc;drop=257906"] = {"동전눈 스컬리", "똬리의 섬"}
        s["npc;drop=258557"] = {"울라텍의 숨결", "맹독 심연"}
        s["npc;drop=258877"] = {"날로라크 <전쟁의 로아>", "날로라크의 소굴"}
        s["npc;drop=258916"] = {"가르세그 <선체 분쇄자>", "똬리의 섬"}
        s["npc;drop=259445"] = {"라비", "송곳니의 제단"}
        s["npc;drop=259446"] = {"격동하는 똬리", "송곳니의 제단"}
        s["npc;drop=259447"] = {"줄잔", "송곳니의 제단"}
        s["npc;drop=260905"] = {"타오르는 맹독", "맹독 심연"}
        s["npc;drop=261053"] = {"겨울의 파수꾼", "날로라크의 소굴"}
        s["npc;drop=263456"] = {"송곳니 스자리스", ""}
        s["npc;drop=264854"] = {"약탈자 파트히크", "똬리의 섬"}
        s["npc;drop=267077"] = {"모르자히", "맹독 심연"}
        s["npc;drop=268090"] = {"잊힌 자 카리자", "똬리의 섬"}
        s["npc;drop=268956"] = {"울라텍", "맹독 심연"}
        s["npc;drop=269808"] = {"정복자 아카알리", "왕들의 안식처"}
        s["npc;drop=271337"] = {"Echo of Jawae <[Soulcoiler Cult]>", "맹독 심연"}
        s["npc;drop=36476"] = {"이크 <크리크의 하수인>", "사론의 구덩이"}
        s["npc;drop=36494"] = {"제련장인 가프로스트", "사론의 구덩이"}
        s["npc;drop=36658"] = {"스컬지군주 티라누스", "사론의 구덩이"}
        s["npc;drop=39625"] = {"장군 움브리스 <데스윙의 하수인>", "그림 바톨"}
        s["npc;drop=40177"] = {"제련장인 트롱구스", "그림 바톨"}
        s["npc;drop=40319"] = {"드라가 섀도버너 <황혼의 망치단 급사>", "그림 바톨"}
        s["npc;drop=40484"] = {"에루닥스 <지하 군주>", "그림 바톨"}
        s["npc;drop=75452"] = {"해골아귀", "어둠달 지하묘지"}
        s["npc;drop=75964"] = {"란지트 <네 바람의 지배자>", "하늘탑"}
        s["npc;drop=76141"] = {"아라크나스 <태양의 피조물>", "하늘탑"}
        s["npc;drop=76266"] = {"대현자 비릭스", "하늘탑"}
        s["npc;drop=76379"] = {"루크란", "하늘탑"}
        s["npc;sold=219222"] = {"랄란디 <정복 병참장교>", "도르노갈"}
        s["npc;sold=224270"] = {"입잘", "실타래의 도시"}
        s["npc;sold=227003"] = {"키르잘 <진귀품 수집가>", "실타래의 도시"}
        s["npc;sold=231824"] = {"[Kari Bridgeblaster]", "언더마인"}
        s["npc;sold=243220"] = {"이리사 블러드스타 <정복 병참장교>", "실버문"}
        s["npc;sold=248303"] = {"자흐란 <구렁 장신구>", "채굴지 9호"}
        s["npc;sold=256670"] = {"자흐란 <구렁 장비>", "대학 대소동"}
        s["object;contained=413563"] = {"육중한 보관함", "일몰의 성소"}
        s["object;contained=413590"] = {"풍요로운 금고", "공포의 무저갱"}
        s["object;contained=416265"] = {"도둑맞은 보관함", "공포의 무저갱"}
        s["object;contained=476068"] = {"[Papa's Prized Putter]", "언더마인"}
        s["object;contained=507768"] = {"버려진 고블린 화폐 더미", "채굴지 9호"}
        s["object;contained=574407"] = {"도전자의 보관함", "마법학자의 정원"}
        s["object;contained=574409"] = {"도전자의 보관함", ""}
        s["object;contained=581922"] = {"숨겨진 상자", "대학 대소동"}
        s["object;contained=584514"] = {"풍요로운 금고", "대학 대소동"}
        s["object;contained=584518"] = {"풍요로운 육중한 보관함", "대학 대소동"}
        s["object;contained=584519"] = {"육중한 보관함", "대학 대소동"}
        s["quest;reward=66119"] = {"루비 생명의 웅덩이: 원시술사의 침공", ""}
        s["quest;reward=78232"] = {"퇴고의 퇴고", ""}
        s["quest;reward=78636"] = {"광산 탈환", ""}
        s["quest;reward=79342"] = {"떠나는 길에", ""}
        s["quest;reward=83125"] = {"", "줄다자르"}
        s["quest;reward=86521"] = {"공결탑 제나스: 일월식", ""}
        s["quest;reward=91009"] = {"고강도 정보 저장소", "도르노갈"}
        s["quest;reward=91694"] = {"공허흉터 투기장: 무너지는 3인방", ""}
        s["quest;reward=91958"] = {"날로라크의 소굴: 용서받지 못한 자", ""}
        s["quest;reward=93417"] = {"아탈우텍 금고: 송곳니의 제단", ""}
        s["quest;reward=93651"] = {"눈부신 골짜기: 빛만개의 뿌리", ""}
        s["quest;reward=93933"] = {"보호받는 보물", ""}
        s["spell;created=1228945"] = {"순교자의 손목띠", "CRAFTING"}
        s["spell;created=1228950"] = {"신봉자의 비단 수의", "CRAFTING"}
        s["spell;created=1228984"] = {"비전매듭 팔보호구", "CRAFTING"}
        s["spell;created=1228985"] = {"비전매듭 망토", "CRAFTING"}
        s["spell;created=1228988"] = {"비전매듭 장식끈", "CRAFTING"}
        s["spell;created=1229648"] = {"혈기사의 전투칼날", "CRAFTING"}
        s["spell;created=1229649"] = {"만개벼림 발톱", "CRAFTING"}
        s["spell;created=1229657"] = {"주문파괴자의 전투검", "CRAFTING"}
        s["spell;created=1229659"] = {"원정순찰대원의 자비", "CRAFTING"}
        s["spell;created=1229662"] = {"주문파괴자의 팔보호구", "CRAFTING"}
        s["spell;created=1229875"] = {"실체 없는 빛 손목매듭", "CRAFTING"}
        s["spell;created=1229877"] = {"실체 없는 빛 손목보호대", "CRAFTING"}
        s["spell;created=1230061"] = {"알른하라의 등불", "CRAFTING"}
        s["spell;created=1230070"] = {"다크문 지배: 혈기", "CRAFTING"}
        s["spell;created=1230071"] = {"다크문 지배: 부식", "CRAFTING"}
        s["spell;created=1230072"] = {"다크문 지배: 사냥", "CRAFTING"}
        s["spell;created=1230073"] = {"다크문 지배: 공허", "CRAFTING"}
        s["spell;created=1230479"] = {"로아 신봉자의 고리", "CRAFTING"}
        s["spell;created=1230485"] = {"걸작 신도레이 고리", "CRAFTING"}
        s["spell;created=1230486"] = {"걸작 신도레이 아뮬렛", "CRAFTING"}
        s["spell;created=1230487"] = {"아제로스의 축복 인장", "CRAFTING"}
        s["spell;created=1230861"] = {"원시 현자의 돌", "CRAFTING"}
        s["spell;created=1230885"] = {"마법학자의 연금술사 돌", "CRAFTING"}
        s["spell;created=1237508"] = {"실버문 요원의 신발", "CRAFTING"}
        s["spell;created=1237509"] = {"실버문 요원의 손등싸개", "CRAFTING"}
        s["spell;created=1237513"] = {"실버문 요원의 연장허리띠", "CRAFTING"}
        s["spell;created=1237514"] = {"실버문 요원의 굴절보호대", "CRAFTING"}
        s["spell;created=1237518"] = {"세계지기의 뿌리끌신", "CRAFTING"}
        s["spell;created=1237519"] = {"세계지기의 껍질죔쇠띠", "CRAFTING"}
        s["spell;created=1237537"] = {"원정순찰대원의 갈퀴 발톱", "CRAFTING"}
        s["spell;created=1237543"] = {"원정순찰대원의 철판 팔보호구", "CRAFTING"}
        s["spell;created=1249111"] = {"붕대 받기", "CRAFTING"}
        s["spell;created=1253219"] = {"사냥", ""}
        s["spell;created=1253220"] = {"공허", ""}
        s["spell;created=1253221"] = {"혈기", ""}
        s["spell;created=1253222"] = {"부식", ""}
        s["spell;created=237828"] = {"반투스 룬: 악마 심문관", ""}
        s["spell;created=239649"] = {"지옥불 충돌", ""}
        s["spell;created=244572"] = {"영혼 소환", ""}
        s["spell;created=244581"] = {"몰아치는 유성", ""}
        s["spell;created=244609"] = {"영혼 소환 - 북 치기", ""}
        s["spell;created=427185"] = {"알가르 연금술사 돌", "CRAFTING"}
        s["spell;created=435382"] = {"결속의 고리", "CRAFTING"}
        s["spell;created=435384"] = {"토석인 장인 정신의 반지", "CRAFTING"}
        s["spell;created=435385"] = {"토석인 장인 정신의 아뮬렛", "CRAFTING"}
        s["spell;created=441051"] = {"룬낙인 튜닉", "CRAFTING"}
        s["spell;created=441052"] = {"룬낙인 장화", "CRAFTING"}
        s["spell;created=441053"] = {"룬낙인 손아귀", "CRAFTING"}
        s["spell;created=441055"] = {"룬낙인 다리싸개", "CRAFTING"}
        s["spell;created=441057"] = {"룬낙인 허리보호띠", "CRAFTING"}
        s["spell;created=441058"] = {"룬낙인 완장", "CRAFTING"}
        s["spell;created=441060"] = {"문양새김 디딤장화", "CRAFTING"}
        s["spell;created=441061"] = {"문양새김 건틀릿", "CRAFTING"}
        s["spell;created=441063"] = {"문양새김 다리가리개", "CRAFTING"}
        s["spell;created=441065"] = {"문양새김 결속띠", "CRAFTING"}
        s["spell;created=441066"] = {"문양새김 완갑", "CRAFTING"}
        s["spell;created=444070"] = {"솟구치는 아드레날린 죔쇠띠", "CRAFTING"}
        s["spell;created=444197"] = {"방랑자의 횃불", "CRAFTING"}
        s["spell;created=444198"] = {"방랑자의 신중한 목발", "CRAFTING"}
        s["spell;created=444199"] = {"방랑자의 도약하는 지휘봉", "CRAFTING"}
        s["spell;created=445355"] = {"빛나는 마법의 홀", "CRAFTING"}
        s["spell;created=446937"] = {"축성된 끌신", "CRAFTING"}
        s["spell;created=446938"] = {"축성된 소매장식", "CRAFTING"}
        s["spell;created=446939"] = {"축성된 장식끈", "CRAFTING"}
        s["spell;created=446940"] = {"축성된 망토", "CRAFTING"}
        s["spell;created=447314"] = {"근면한 총명함 촉진기", "CRAFTING"}
        s["spell;created=447315"] = {"과부하된 발상 생성기", "CRAFTING"}
        s["spell;created=447352"] = {"분.해.포. x2", "CRAFTING"}
        s["spell;created=450220"] = {"영원벼림 발덮개", "CRAFTING"}
        s["spell;created=450222"] = {"영원벼림 철갑허리띠", "CRAFTING"}
        s["spell;created=450223"] = {"영원벼림 파수 방패", "CRAFTING"}
        s["spell;created=450224"] = {"영원벼림 투구", "CRAFTING"}
        s["spell;created=450226"] = {"영원벼림 완갑", "CRAFTING"}
        s["spell;created=450229"] = {"영원벼림 찌르개", "CRAFTING"}
        s["spell;created=450230"] = {"영원벼림 단검", "CRAFTING"}
        s["spell;created=450231"] = {"영원벼림 장검", "CRAFTING"}
        s["spell;created=450232"] = {"영원벼림 전투검", "CRAFTING"}
        s["spell;created=450234"] = {"영원벼림 거대도끼", "CRAFTING"}
        s["spell;created=450235"] = {"충만한 사술검", "CRAFTING"}
        s["spell;created=450237"] = {"충만한 얼굴분쇄기", "CRAFTING"}
        s["spell;created=450238"] = {"충만한 클레이모어", "CRAFTING"}
        s["spell;created=450239"] = {"충만한 미늘창", "CRAFTING"}
        s["spell;created=450242"] = {"충만한 절단도끼", "CRAFTING"}
        s["spell;created=455391"] = {"생기", ""}
        s["spell;created=455392"] = {"공생", ""}
        s["spell;created=455393"] = {"광휘", ""}
        s["spell;created=455394"] = {"승천", ""}
        s["spell;created=473400"] = {"주문 시전 맞춤 조정", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationptBR()
        s["item:contained=229129"] = {"Baú de Espólios do Imersor", ""}
        s["item:contained=229354"] = {"Baú do Aventureiro Algari", ""}
        s["item:contained=235639"] = {"Baú do Aventureiro Experiente", ""}
        s["item:contained=238208"] = {"Dividendos Dinâmicos da Tia", ""}
        s["item:contained=262346"] = {"Baú do Campeão do Rapinante", ""}
        s["npc;drop=122056"] = {"Vice-rei Nezhar", "Sede do Triunvirato"}
        s["npc;drop=122313"] = {"Zuraal, o Elevado", "Sede do Triunvirato"}
        s["npc;drop=122316"] = {"Saprish <Lorde-etéreo da Guarda Sombria>", "Sede do Triunvirato"}
        s["npc;drop=124729"] = {"L'ura", "Sede do Triunvirato"}
        s["npc;drop=128649"] = {"Sargento Belponte", "Cerco de Boralus"}
        s["npc;drop=128650"] = {"Gancho Estraçalho", "Cerco de Boralus"}
        s["npc;drop=128651"] = {"Hadal Abismo Negro", "Cerco de Boralus"}
        s["npc;drop=128652"] = {"Viq'Goth <Terror das Profundezas>", "Cerco de Boralus"}
        s["npc;drop=129208"] = {"Terrível Capitã Madeira", "Cerco de Boralus"}
        s["npc;drop=129214"] = {"Espanca-gente de Ficha", "MEGAMINA!!!"}
        s["npc;drop=129227"] = {"Azerokk", "MEGAMINA!!!"}
        s["npc;drop=129231"] = {"Rixxa Fazfaísca <Cientista-chefe>", "MEGAMINA!!!"}
        s["npc;drop=131227"] = {"Dalberto Frustrus", "MEGAMINA!!!"}
        s["npc;drop=132713"] = {"Barão dos Negócios Frustrus", "MEGAMINA!!!"}
        s["npc;drop=133384"] = {"Merektha", "Templo de Sethraliss"}
        s["npc;drop=133389"] = {"Galvazzt", "Templo de Sethraliss"}
        s["npc;drop=133392"] = {"Avatar de Sethraliss", "Templo de Sethraliss"}
        s["npc;drop=133944"] = {"Jararax", "Templo de Sethraliss"}
        s["npc;drop=134993"] = {"Muquimba, o Embalsamador", "Repouso do Rei"}
        s["npc;drop=135322"] = {"A Serpente Dourada", "Repouso do Rei"}
        s["npc;drop=136160"] = {"Rei Dazar <Primeiro>", "Repouso do Rei"}
        s["npc;drop=144244"] = {"Esbordoador de Platina", "Operação: Gnomecan"}
        s["npc;drop=144246"] = {"K.U.-J.0.", "Operação: Gnomecan"}
        s["npc;drop=144248"] = {"Maquinista-chefe Fluichispa", "Operação: Gnomecan"}
        s["npc;drop=150159"] = {"Rei Gobbamak", "Operação: Gnomecan"}
        s["npc;drop=150222"] = {"Visgueiro", "Operação: Gnomecan"}
        s["npc;drop=150397"] = {"Rei Gnomecan", "Operação: Gnomecan"}
        s["npc;drop=152619"] = {"Rei Gnomecan", "Operação: Gnomecan"}
        s["npc;drop=156827"] = {"Escalon", "Salões da Expiação"}
        s["npc;drop=162309"] = {"Kul'tharok", "Teatro da Dor"}
        s["npc;drop=162317"] = {"Estripança", "Teatro da Dor"}
        s["npc;drop=162329"] = {"Xav, o Não-caído", "Teatro da Dor"}
        s["npc;drop=162689"] = {"Cirurgião Suturítico", "A Chaga Necrótica"}
        s["npc;drop=162691"] = {"Pragosso", "A Chaga Necrótica"}
        s["npc;drop=162693"] = {"Nalthor, o Senhor da Geada", "A Chaga Necrótica"}
        s["npc;drop=163157"] = {"Amarth <O Ceifador>", "A Chaga Necrótica"}
        s["npc;drop=164185"] = {"Escalon", "Salões da Expiação"}
        s["npc;drop=164218"] = {"Lorde Camarista", "Salões da Expiação"}
        s["npc;drop=164451"] = {"Déssia, a Decapitadora", "Teatro da Dor"}
        s["npc;drop=164501"] = {"Chamabruma", "Brumas de Tirna Scithe"}
        s["npc;drop=164517"] = {"Tred'ova", "Brumas de Tirna Scithe"}
        s["npc;drop=164567"] = {"Ingra Maloch", "Brumas de Tirna Scithe"}
        s["npc;drop=165408"] = {"Hálkias <Golias Maculado pelo Pecado>", "Salões da Expiação"}
        s["npc;drop=165410"] = {"Alta-adjudicadora Alee", "Salões da Expiação"}
        s["npc;drop=165946"] = {"Mordretha, a Imperatriz Infinda", "Teatro da Dor"}
        s["npc;drop=175546"] = {"Capitã Temporal Rabo-de-gancho", "Tazavesh, o Mercado Oculto"}
        s["npc;drop=175616"] = {"Zo'phex <A Sentinela>", "Tazavesh, o Mercado Oculto"}
        s["npc;drop=175646"] = {"Chefe do C.O.R.R.E.I.O", "Tazavesh, o Mercado Oculto"}
        s["npc;drop=175663"] = {"Hylbrande <Espada dos Guardiões>", "Tazavesh, o Mercado Oculto"}
        s["npc;drop=175806"] = {"So'azmi", "Tazavesh, o Mercado Oculto"}
        s["npc;drop=176556"] = {"Alcruux <O Glutão>", "Tazavesh, o Mercado Oculto"}
        s["npc;drop=176563"] = {"Zo'gron", "Tazavesh, o Mercado Oculto"}
        s["npc;drop=176705"] = {"Vina Fusauro", "Tazavesh, o Mercado Oculto"}
        s["npc;drop=177269"] = {"So'leah <Cartel So>", "Tazavesh, o Mercado Oculto"}
        s["npc;drop=188252"] = {"Melidrussa Geladura <Especialista em Infusões>", "Poços da Vida Rubi"}
        s["npc;drop=189232"] = {"Kokia Patardida", "Poços da Vida Rubi"}
        s["npc;drop=190485"] = {"Erkhart Vendaveia", "Poços da Vida Rubi"}
        s["npc;drop=190609"] = {"Eco de Doragosa <Diretor>", "Academia Algeth'ar"}
        s["npc;drop=191736"] = {"Crawth", "Academia Algeth'ar"}
        s["npc;drop=194181"] = {"Vexamus", "Academia Algeth'ar"}
        s["npc;drop=196482"] = {"Anciente Supercrescido", "Academia Algeth'ar"}
        s["npc;drop=202318"] = {"Vigia da Equipe de Resposta", "Caverna Zaralek"}
        s["npc;drop=203355"] = {"Capitã Reykal", "Caverna Zaralek"}
        s["npc;drop=207205"] = {"Tempesguarda Gorren", "O Viveiro"}
        s["npc;drop=207207"] = {"Monstruosidade da Pedra do Caos", "O Viveiro"}
        s["npc;drop=207939"] = {"Barão Hastanha", "Priorado da Chama Sagrada"}
        s["npc;drop=207940"] = {"Priora Orália", "Priorado da Chama Sagrada"}
        s["npc;drop=207946"] = {"Capitão Bradano", "Priorado da Chama Sagrada"}
        s["npc;drop=208478"] = {"Volcoross", "Amirdrassil, a Esperança Onírica"}
        s["npc;drop=208743"] = {"Brasikon", "Fenda Chamanegra"}
        s["npc;drop=208745"] = {"O Rei da Vela", "Fenda Chamanegra"}
        s["npc;drop=209230"] = {"Kyrioss", "O Viveiro"}
        s["npc;drop=210108"] = {"E.D.N.A.", "Abóboda de Pedra"}
        s["npc;drop=210153"] = {"Velho Barbacera", "Fenda Chamanegra"}
        s["npc;drop=210156"] = {"Skarmorak", "Abóboda de Pedra"}
        s["npc;drop=210267"] = {"I'pa", "Hidromelaria Cinzagris"}
        s["npc;drop=210271"] = {"Mestre Fermentador Aldryr", "Hidromelaria Cinzagris"}
        s["npc;drop=210797"] = {"A Escuridão", "Fenda Chamanegra"}
        s["npc;drop=211087"] = {"Mensageira Coronumbra", "Alvorada"}
        s["npc;drop=211089"] = {"Anub'ikkaj", "Alvorada"}
        s["npc;drop=213119"] = {"Voz do Caos Eirich", "Abóboda de Pedra"}
        s["npc;drop=213179"] = {"Avanoxx", "Ara-Kara, a Cidade dos Ecos"}
        s["npc;drop=213217"] = {"Mensageiro Brokk", "Abóboda de Pedra"}
        s["npc;drop=214502"] = {"O Terror Sanguino", "Palácio Nerub-ar"}
        s["npc;drop=214506"] = {"Prolemante Ovi'nax", "Palácio Nerub-ar"}
        s["npc;drop=214661"] = {"Doura de Ricalhaz Nababa <Apoisidente>", "Hidromelaria Cinzagris"}
        s["npc;drop=215405"] = {"Anub'zekt <Zanguarda>", "Ara-Kara, a Cidade dos Ecos"}
        s["npc;drop=215407"] = {"Ki'katal, a Ceifadora", "Ara-Kara, a Cidade dos Ecos"}
        s["npc;drop=215657"] = {"Ulgrax, o Devorador", "Palácio Nerub-ar"}
        s["npc;drop=216320"] = {"A Coaglamação", "Cidade das Tramas"}
        s["npc;drop=216619"] = {"Orador Krix'vizk <O Quinto Fio>", "Cidade das Tramas"}
        s["npc;drop=216648"] = {"Nx <Presa da Rainha>", "Cidade das Tramas"}
        s["npc;drop=216658"] = {"Izo, a Grande Entrançadora", "Cidade das Tramas"}
        s["npc;drop=217489"] = {"Anub'arash <As Mil Cicatrizes>", "Palácio Nerub-ar"}
        s["npc;drop=218002"] = {"Apílio Abelhudo <Apicultor>", "Hidromelaria Cinzagris"}
        s["npc;drop=219778"] = {"Rainha Ansurek", "Palácio Nerub-ar"}
        s["npc;drop=219853"] = {"Sikran <Capitão dos Sureki>", "Palácio Nerub-ar"}
        s["npc;drop=223779"] = {"Anub'arash <As Mil Cicatrizes>", "Palácio Nerub-ar"}
        s["npc;drop=223839"] = {"Guarda da Rainha Ge'zah", "Palácio Nerub-ar"}
        s["npc;drop=224552"] = {"Rasha'nan", "Alvorada"}
        s["npc;drop=225821"] = {"[The Geargrinder]", "Libertação da Inframina"}
        s["npc;drop=226305"] = {"[Emperor Dagran Thaurissan]", "Abismo Rocha Negra"}
        s["npc;drop=226306"] = {"[Golem Lord Argelmach]", "Abismo Rocha Negra"}
        s["npc;drop=226315"] = {"[Lord Roccor]", "Abismo Rocha Negra"}
        s["npc;drop=226396"] = {"[Swampface]", "Operação: Comporta"}
        s["npc;drop=226398"] = {"[Big M.O.M.M.A.]", "Operação: Comporta"}
        s["npc;drop=226403"] = {"[Keeza Quickfuse]", "Operação: Comporta"}
        s["npc;drop=226404"] = {"Guizol Gigazap", "Operação: Comporta"}
        s["npc;drop=228458"] = {"[One-Armed Bandit]", "Libertação da Inframina"}
        s["npc;drop=228470"] = {"Princesa do Nexus Ky'veza", "Palácio Nerub-ar"}
        s["npc;drop=228652"] = {"[Rik Reverb]", "Libertação da Inframina"}
        s["npc;drop=229181"] = {"[Flarendo]", "Libertação da Inframina"}
        s["npc;drop=229284"] = {"Guk Bumcão <Falcoeiro de Meleca>", "Libertação da Inframina"}
        s["npc;drop=229288"] = {"Rei Flamódio <Empresário de Flarendo>", "Libertação da Inframina"}
        s["npc;drop=229953"] = {"[Mug'Zee]", "Libertação da Inframina"}
        s["npc;drop=229992"] = {"Estalagnarok", "Ilha das Sirenas"}
        s["npc;drop=230322"] = {"[Stix Bunkjunker]", "Libertação da Inframina"}
        s["npc;drop=230583"] = {"[Sprocketmonger Lockenstock]", "Libertação da Inframina"}
        s["npc;drop=230800"] = {"[Slugger the Smart]", "Inframina"}
        s["npc;drop=230828"] = {"[Chief Foreman Gutso]", "Inframina"}
        s["npc;drop=230934"] = {"[Ratspit]", "Inframina"}
        s["npc;drop=230946"] = {"[V.V. Goosworth]", "Inframina"}
        s["npc;drop=231310"] = {"Precipitante Sombrafuso", "Inframina"}
        s["npc;drop=231606"] = {"Brasaurora", "Pico dos Correventos"}
        s["npc;drop=231626"] = {"Kális", "Pico dos Correventos"}
        s["npc;drop=231631"] = {"Comandante Kroluk <Antiga Horda>", "Pico dos Correventos"}
        s["npc;drop=231636"] = {"Coração Inquieto", "Pico dos Correventos"}
        s["npc;drop=231863"] = {"Seranel Talho do Sol", "Terraço dos Magísteres"}
        s["npc;drop=231864"] = {"Gemellus", "Terraço dos Magísteres"}
        s["npc;drop=231865"] = {"Degentrius", "Terraço dos Magísteres"}
        s["npc;drop=231981"] = {"Bocarra das Areias", "K'aresh"}
        s["npc;drop=233814"] = {"Sentinela do Plexo", "Manaforja Ômega"}
        s["npc;drop=233815"] = {"Fian'dhar", "Manaforja Ômega"}
        s["npc;drop=233816"] = {"Atalmas Naazindhri", "Manaforja Ômega"}
        s["npc;drop=233824"] = {"Dimensius", "Manaforja Ômega"}
        s["npc;drop=234647"] = {"Xathuux, o Aniquilador <Guardião de Lithiel>", "Travessa do Assassino"}
        s["npc;drop=234649"] = {"Zaen Laminúrio", "Travessa do Assassino"}
        s["npc;drop=234845"] = {"Sthaarbs <o Espiramente>", "K'aresh"}
        s["npc;drop=234893"] = {"Azhiccar", "Ecodomo Al'dani"}
        s["npc;drop=234933"] = {"Taah'bat <O Incansável>", "Ecodomo Al'dani"}
        s["npc;drop=235853"] = {"Vigia do Pórtico", "Manaforja Ômega"}
        s["npc;drop=237415"] = {"Lithiel Brasafúria", "Travessa do Assassino"}
        s["npc;drop=237661"] = {"Adarus Gumúmbrio", "Manaforja Ômega"}
        s["npc;drop=237763"] = {"Rei do Nexus Salhadaar", "Manaforja Ômega"}
        s["npc;drop=237861"] = {"Fractillus <[The Shatterer]>", "Manaforja Ômega"}
        s["npc;drop=238887"] = {"Taz'Rah", "Arena da Chaga do Caos"}
        s["npc;drop=239008"] = {"Atroxus", "Arena da Chaga do Caos"}
        s["npc;drop=239454"] = {"Neromago Zadus", "Manaforja Ômega"}
        s["npc;drop=240432"] = {"Rei Caído Salhadaar", "A Torre do Caos"}
        s["npc;drop=240434"] = {"Vorasius", "A Torre do Caos"}
        s["npc;drop=240435"] = {"Imperador Averzian", "A Torre do Caos"}
        s["npc;drop=241526"] = {"[Chrome King Gallywix]", "Libertação da Inframina"}
        s["npc;drop=241546"] = {"Lothráxion <Alto-comandante>", ""}
        s["npc;drop=242031"] = {"Espinhoso-enrugado <A Pesca Mortal>", "Zul'Aman"}
        s["npc;drop=242056"] = {"Vaelgor", "A Torre do Caos"}
        s["npc;drop=242255"] = {"Geezle Gigazap", "Operação: Comporta"}
        s["npc;drop=24239"] = {"Grão-bagateiro Malacrass", "Abismo Peçonhento"}
        s["npc;drop=243028"] = {"Meittik", "O Vale Ofuscante"}
        s["npc;drop=244752"] = {"Princesa do Nexus Ky'veza", "Santuário Navalha do Caos"}
        s["npc;drop=244761"] = {"Alleria Windrunner", "A Torre do Caos"}
        s["npc;drop=244762"] = {"Lu'ashal", "Floresta do Canto Eterno"}
        s["npc;drop=244887"] = {"Ikanz, o Caça-luz", "O Vale Ofuscante"}
        s["npc;drop=245044"] = {"Ninhada da Noite", "Tempestade do Caos"}
        s["npc;drop=245912"] = {"Guardião da Luz Ruia", "O Vale Ofuscante"}
        s["npc;drop=246633"] = {"Falcostruz Atormentado", "Floresta do Canto Eterno"}
        s["npc;drop=246729"] = {"Brasa de Luz <Cria de Belo'ren>", "Ilha de Quel'Danas"}
        s["npc;drop=247283"] = {"Escriba d'Alma", "Ecodomo Al'dani"}
        s["npc;drop=247570"] = {"Muro'jin", "Cavernas de Maisara"}
        s["npc;drop=247676"] = {"Ziekket <Cria da Luz Nodosa>", "O Vale Ofuscante"}
        s["npc;drop=247976"] = {"Caçador Rav'ik <Tribo Ramatorpe>", "Zul'Aman"}
        s["npc;drop=247989"] = {"Tece-forja Araz", "Manaforja Ômega"}
        s["npc;drop=248015"] = {"Charonus", "Arena da Chaga do Caos"}
        s["npc;drop=248595"] = {"Vordaza", "Cavernas de Maisara"}
        s["npc;drop=248605"] = {"Rak'tul <Receptáculo das Almas>", "Cavernas de Maisara"}
        s["npc;drop=248710"] = {"The Hoardmonger <[Spiritpaw Tribe]>", "Covil de Nalorakk"}
        s["npc;drop=248823"] = {"Negrinúcleo", "Tempestade do Caos"}
        s["npc;drop=249844"] = {"Chironex <A Morte Flutuante>", "Harandar"}
        s["npc;drop=250086"] = {"Toquinho <Terror de Harandar>", "Harandar"}
        s["npc;drop=250358"] = {"Annulus, o Abala-mundo", "Harandar"}
        s["npc;drop=250589"] = {"Capelã de Guerra Senn", "A Torre do Caos"}
        s["npc;drop=252458"] = {"Kystia Manacárdia", "Travessa do Assassino"}
        s["npc;drop=252959"] = {"Nymrissa Clamaondas", "Gruta Marejante"}
        s["npc;drop=254176"] = {"Necrocharco", "Esporasca"}
        s["npc;drop=254227"] = {"Guarda-núcleo Nysarra", ""}
        s["npc;drop=256116"] = {"Quimerus <A Divindade Insonhada>", "A Fenda Onírica"}
        s["npc;drop=257347"] = {"Sszorak", "Abismo Peçonhento"}
        s["npc;drop=257361"] = {"Vexhul", "Abismo Peçonhento"}
        s["npc;drop=257906"] = {"Caveirinha Olho de Moeda", "A Ilha Enrolada"}
        s["npc;drop=258557"] = {"Sopro de Ula'tek", "Abismo Peçonhento"}
        s["npc;drop=258877"] = {"Nalorakk <Loa da Guerra>", "Covil de Nalorakk"}
        s["npc;drop=258916"] = {"Garsecg <O Fende-cascos>", "A Ilha Enrolada"}
        s["npc;drop=259445"] = {"Rav'i", "Altar das Presas"}
        s["npc;drop=259446"] = {"Espiral Contorcida", "Altar das Presas"}
        s["npc;drop=259447"] = {"Zul'jan", "Altar das Presas"}
        s["npc;drop=260905"] = {"Peçonha Ardente", "Abismo Peçonhento"}
        s["npc;drop=261053"] = {"Sentinela do Inverno", "Covil de Nalorakk"}
        s["npc;drop=263456"] = {"Szarith Presa Afiada", ""}
        s["npc;drop=264854"] = {"Farthik, a Saqueadora", "A Ilha Enrolada"}
        s["npc;drop=267077"] = {"Mor'zahi", "Abismo Peçonhento"}
        s["npc;drop=268090"] = {"Kari'zah, o Esquecido", "A Ilha Enrolada"}
        s["npc;drop=268956"] = {"Ula'tek", "Abismo Peçonhento"}
        s["npc;drop=269808"] = {"Aka'ali, a Conquistadora", "Repouso do Rei"}
        s["npc;drop=271337"] = {"Echo of Jawae <[Soulcoiler Cult]>", "Abismo Peçonhento"}
        s["npc;drop=36476"] = {"Ick <Lacaio de Krick>", "Fosso de Saron"}
        s["npc;drop=36494"] = {"Mestre Forjador Criomal", "Fosso de Saron"}
        s["npc;drop=36658"] = {"Senhor do Flagelo Tyrannus", "Fosso de Saron"}
        s["npc;drop=39625"] = {"General Umbriss <Servo do Asa da Morte>", "Grim Batol"}
        s["npc;drop=40177"] = {"Mestre Forjador Throngus", "Grim Batol"}
        s["npc;drop=40319"] = {"Drahga Queimassombra <Mensageiro do Martelo do Crepúsculo>", "Grim Batol"}
        s["npc;drop=40484"] = {"Erúdax <O Duque do Abismo>", "Grim Batol"}
        s["npc;drop=75452"] = {"Gorjóssea", "Sepulcrário da Lua Negra"}
        s["npc;drop=75964"] = {"Ranjit <Mestre dos Quatro Ventos>", "Beira-céu"}
        s["npc;drop=76141"] = {"Araknath <Constructo Solar>", "Beira-céu"}
        s["npc;drop=76266"] = {"Alta Sábia Viryx", "Beira-céu"}
        s["npc;drop=76379"] = {"Rukhran", "Beira-céu"}
        s["npc;sold=219222"] = {"Lalandi <Intendente de Dominação>", "Dornogal"}
        s["npc;sold=224270"] = {"Ip'xal <Provedora do Herói>", "Cidade das Tramas"}
        s["npc;sold=227003"] = {"Kir'xal <Colecionadora de Curiosidades>", "Cidade das Tramas"}
        s["npc;sold=231824"] = {"[Kari Bridgeblaster]", "Inframina"}
        s["npc;sold=243220"] = {"Irissa Rubrestela <Intendente de Dominação>", "Luaprata"}
        s["npc;sold=248303"] = {"Zah'ran <[Delve Trinkets]>", "Sítio de Escavação 9"}
        s["npc;sold=256670"] = {"Zah'ran <Equipamento de Imersão>", "Calamidade Colegiada"}
        s["object;contained=413563"] = {"Baú Pesado", "Caverna Micomante"}
        s["object;contained=413590"] = {"Cofre Abundante", "Fosso do Pavor"}
        s["object;contained=416265"] = {"Baú Furtado", "Fosso do Pavor"}
        s["object;contained=476068"] = {"[Papa's Prized Putter]", "Inframina"}
        s["object;contained=507768"] = {"Pilha de Moedas Goblínicas Descartadas", "Sítio de Escavação 9"}
        s["object;contained=574407"] = {"Baú do Desafiante", "Terraço dos Magísteres"}
        s["object;contained=574409"] = {"Baú do Desafiante", ""}
        s["object;contained=581922"] = {"Arca Escondida", "Calamidade Colegiada"}
        s["object;contained=584514"] = {"Cofre Abundante", "Calamidade Colegiada"}
        s["object;contained=584518"] = {"Baú Pesado Abundante", "Calamidade Colegiada"}
        s["object;contained=584519"] = {"Baú Pesado", "Calamidade Colegiada"}
        s["quest;reward=66119"] = {"Poços da Vida Rubi: invasão Primevista", ""}
        s["quest;reward=78232"] = {"Reprogramando o reprogramado", ""}
        s["quest;reward=78636"] = {"Retomada das minas", ""}
        s["quest;reward=79342"] = {"E ele se vai", ""}
        s["quest;reward=83125"] = {"", "Zuldazar"}
        s["quest;reward=86521"] = {"Eclipse no Ponto de Nexus Xenas", ""}
        s["quest;reward=91009"] = {"Dispositivo de Informações Seguras Confiável", "Dornogal"}
        s["quest;reward=91694"] = {"Arena da Chaga do Caos: o fim da tríade", ""}
        s["quest;reward=91958"] = {"Covil de Nalorakk: Imperdoável", ""}
        s["quest;reward=93417"] = {"Câmaras de Atal'Utek: Altar das Presas", ""}
        s["quest;reward=93651"] = {"O Vale Ofuscante: Raízes de Floraluz", ""}
        s["quest;reward=93933"] = {"Tesouros guardados", ""}
        s["spell;created=1228945"] = {"Braceletes do Mártir", "CRAFTING"}
        s["spell;created=1228950"] = {"Mortalha Sedosa do Seguidor", "CRAFTING"}
        s["spell;created=1228984"] = {"Braçadeiras de Arcanotrama", "CRAFTING"}
        s["spell;created=1228985"] = {"Manto de Arcanotrama", "CRAFTING"}
        s["spell;created=1228988"] = {"Cordão de Arcanotrama", "CRAFTING"}
        s["spell;created=1229648"] = {"Lâmina de Guerra do Cavaleiro Sangrento", "CRAFTING"}
        s["spell;created=1229649"] = {"Garra de Floraforja", "CRAFTING"}
        s["spell;created=1229657"] = {"Glaive de Guerra do Quebra-feitiço", "CRAFTING"}
        s["spell;created=1229659"] = {"Misericórdia do Andarilho", "CRAFTING"}
        s["spell;created=1229662"] = {"Braçadeiras do Quebra-feitiço", "CRAFTING"}
        s["spell;created=1229875"] = {"Embraces de Aeterlúmen", "CRAFTING"}
        s["spell;created=1229877"] = {"Guardas de Aeterlúmen", "CRAFTING"}
        s["spell;created=1230061"] = {"Lanterna de Aln'hara", "CRAFTING"}
        s["spell;created=1230070"] = {"Domínio de Negraluna: Sangue", "CRAFTING"}
        s["spell;created=1230071"] = {"Domínio de Negraluna: Podridão", "CRAFTING"}
        s["spell;created=1230072"] = {"Domínio de Negraluna: Caçada", "CRAFTING"}
        s["spell;created=1230073"] = {"Domínio de Negraluna: Caos", "CRAFTING"}
        s["spell;created=1230479"] = {"Elo do Adorador dos Loas", "CRAFTING"}
        s["spell;created=1230485"] = {"Elo Sin'dorei Magistral", "CRAFTING"}
        s["spell;created=1230486"] = {"Amuleto Sin'dorei Magistral", "CRAFTING"}
        s["spell;created=1230487"] = {"Sinete das Bênçãos Azerothianas", "CRAFTING"}
        s["spell;created=1230861"] = {"Pedra Filosofal Primeva", "CRAFTING"}
        s["spell;created=1230885"] = {"Pedra do Alquimista do Magíster", "CRAFTING"}
        s["spell;created=1237508"] = {"Calçados do Agente de Luaprata", "CRAFTING"}
        s["spell;created=1237509"] = {"Mitenes do Agente de Luaprata", "CRAFTING"}
        s["spell;created=1237513"] = {"Cinto de Utilidades do Agente de Luaprata", "CRAFTING"}
        s["spell;created=1237514"] = {"Defletores do Agente de Luaprata", "CRAFTING"}
        s["spell;created=1237518"] = {"Sapatiraiz do Conservador de Mundos", "CRAFTING"}
        s["spell;created=1237519"] = {"Arvofecho do Conservador de Mundos", "CRAFTING"}
        s["spell;created=1237537"] = {"Garras de Navalha do Andarilho", "CRAFTING"}
        s["spell;created=1237543"] = {"Braçadeiras de Placa do Andarilho", "CRAFTING"}
        s["spell;created=1249111"] = {"Receber Faixas", "CRAFTING"}
        s["spell;created=1253219"] = {"Caçada", ""}
        s["spell;created=1253220"] = {"Caos", ""}
        s["spell;created=1253221"] = {"Sangue", ""}
        s["spell;created=1253222"] = {"Podridão", ""}
        s["spell;created=237828"] = {"Runa Vantus: Inquisição Demoníaca", ""}
        s["spell;created=239649"] = {"Colisão Infernal", ""}
        s["spell;created=244572"] = {"Evocar Espírito", ""}
        s["spell;created=244581"] = {"Cometa Estrondoso", ""}
        s["spell;created=427185"] = {"Pedra do Alquimista Algari", "CRAFTING"}
        s["spell;created=435382"] = {"Vínculo da Vinculação", "CRAFTING"}
        s["spell;created=435384"] = {"Anel da Confecção Terrana", "CRAFTING"}
        s["spell;created=435385"] = {"Amuleto da Confecção Terrana", "CRAFTING"}
        s["spell;created=441051"] = {"Túnica com Marcações Rúnicas", "CRAFTING"}
        s["spell;created=441052"] = {"Pisantes com Marcações Rúnicas", "CRAFTING"}
        s["spell;created=441053"] = {"Agarres com Marcações Rúnicas", "CRAFTING"}
        s["spell;created=441055"] = {"Culotes com Marcações Rúnicas", "CRAFTING"}
        s["spell;created=441057"] = {"Cintel com Marcações Rúnicas", "CRAFTING"}
        s["spell;created=441058"] = {"Embraces com Marcações Rúnicas", "CRAFTING"}
        s["spell;created=441060"] = {"Pisoteadores Gravados com Glifos", "CRAFTING"}
        s["spell;created=441061"] = {"Manoplas Gravadas com Glifos", "CRAFTING"}
        s["spell;created=441063"] = {"Cuísses Gravadas com Glifos", "CRAFTING"}
        s["spell;created=441065"] = {"Amarra Gravada com Glifos", "CRAFTING"}
        s["spell;created=441066"] = {"Avambraços Gravados com Glifos", "CRAFTING"}
        s["spell;created=444070"] = {"Fecho do Surto Adrenal", "CRAFTING"}
        s["spell;created=444197"] = {"Tocha do Vagabundo", "CRAFTING"}
        s["spell;created=444198"] = {"Bengala Cautelosa do Vagabundo", "CRAFTING"}
        s["spell;created=444199"] = {"Bastão Vinculante do Vagabundo", "CRAFTING"}
        s["spell;created=445355"] = {"Cetro de Magias Radiantes", "CRAFTING"}
        s["spell;created=446937"] = {"Sapatilhas Consagradas", "CRAFTING"}
        s["spell;created=446938"] = {"Manilhas Consagradas", "CRAFTING"}
        s["spell;created=446939"] = {"Cordão Consagrado", "CRAFTING"}
        s["spell;created=446940"] = {"Manto Consagrado", "CRAFTING"}
        s["spell;created=447314"] = {"Facilitador de Inteligência Acadêmica", "CRAFTING"}
        s["spell;created=447315"] = {"Gerador de Ideias Turbinado", "CRAFTING"}
        s["spell;created=447352"] = {"P0U x2", "CRAFTING"}
        s["spell;created=450220"] = {"Escarpes Semperforja", "CRAFTING"}
        s["spell;created=450222"] = {"Correão Semperforja", "CRAFTING"}
        s["spell;created=450223"] = {"Defensor Semperforja", "CRAFTING"}
        s["spell;created=450224"] = {"Elmo Semperforja", "CRAFTING"}
        s["spell;created=450226"] = {"Avambraços Semperforja", "CRAFTING"}
        s["spell;created=450229"] = {"Apunhalador Semperforja", "CRAFTING"}
        s["spell;created=450230"] = {"Adaga Semperforja", "CRAFTING"}
        s["spell;created=450231"] = {"Espada Longa Semperforja", "CRAFTING"}
        s["spell;created=450232"] = {"Glaive de Guerra Semperforja", "CRAFTING"}
        s["spell;created=450234"] = {"Machadão Semperforja", "CRAFTING"}
        s["spell;created=450235"] = {"Bagateira Carregada", "CRAFTING"}
        s["spell;created=450237"] = {"Quebra-fuça Carregado", "CRAFTING"}
        s["spell;created=450238"] = {"Espadão Carregado", "CRAFTING"}
        s["spell;created=450239"] = {"Alabarda Carregada", "CRAFTING"}
        s["spell;created=450242"] = {"Fatiador Carregado", "CRAFTING"}
        s["spell;created=455391"] = {"Vivacidade", ""}
        s["spell;created=455392"] = {"Simbiose", ""}
        s["spell;created=455393"] = {"Resplendor", ""}
        s["spell;created=455394"] = {"Ascensão", ""}
        s["spell;created=473400"] = {"Reconfigurando para Lançamento de Feitiços", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationruRU()
        s["item:contained=229129"] = {"Тайник с трофеями из вылазок", ""}
        s["item:contained=229354"] = {"Тайник алгарийского искателя приключений", ""}
        s["item:contained=235639"] = {"Тайник опытного искателя приключений", ""}
        s["item:contained=238208"] = {"Крупный навар тетушки", ""}
        s["item:contained=262346"] = {"Сундук охотника-защитника", ""}
        s["npc;drop=122056"] = {"Наместник Незжар", "Престол Триумвирата"}
        s["npc;drop=122313"] = {"Зураал Перерожденный", "Престол Триумвирата"}
        s["npc;drop=122316"] = {"Сарпиш <Владыка Темной Стражи>", "Престол Триумвирата"}
        s["npc;drop=124729"] = {"Л'ура", "Престол Триумвирата"}
        s["npc;drop=128649"] = {"Сержант Бейнбридж", "Осада Боралуса"}
        s["npc;drop=128650"] = {"Головорез Краснокрюк", "Осада Боралуса"}
        s["npc;drop=128651"] = {"Хадал Черная Бездна", "Осада Боралуса"}
        s["npc;drop=128652"] = {"Вик'Гот <Кошмар глубин>", "Осада Боралуса"}
        s["npc;drop=129208"] = {"Жуткий капитан Локвуд", "Осада Боралуса"}
        s["npc;drop=129214"] = {"Платный разгонятель толпы", "ЗОЛОТАЯ ЖИЛА!!!"}
        s["npc;drop=129227"] = {"Азерокк", "ЗОЛОТАЯ ЖИЛА!!!"}
        s["npc;drop=129231"] = {"Рикса Огневерт <Старший ученый>", "ЗОЛОТАЯ ЖИЛА!!!"}
        s["npc;drop=131227"] = {"Шеф Разданк", "ЗОЛОТАЯ ЖИЛА!!!"}
        s["npc;drop=132713"] = {"Шеф Разданк", "ЗОЛОТАЯ ЖИЛА!!!"}
        s["npc;drop=133384"] = {"Меректа", "Храм Сетралисс"}
        s["npc;drop=133389"] = {"Гальваззт", "Храм Сетралисс"}
        s["npc;drop=133392"] = {"Аватара Сетралисс", "Храм Сетралисс"}
        s["npc;drop=133944"] = {"Аспидис", "Храм Сетралисс"}
        s["npc;drop=134993"] = {"Мчимба Бальзамировщик", "Гробница королей"}
        s["npc;drop=135322"] = {"Золотой Змей", "Гробница королей"}
        s["npc;drop=136160"] = {"Король Дазар <Первый>", "Гробница королей"}
        s["npc;drop=144244"] = {"'Платиновый лупцеватор'", "Операция 'Мехагон'"}
        s["npc;drop=144246"] = {"КУ-ДЖ0", "Операция 'Мехагон'"}
        s["npc;drop=144248"] = {"Главный машинист Искроточец", "Операция 'Мехагон'"}
        s["npc;drop=150159"] = {"Король Гоббамак", "Операция 'Мехагон'"}
        s["npc;drop=150222"] = {"Токсикоид", "Операция 'Мехагон'"}
        s["npc;drop=150397"] = {"Король Мехагон", "Операция 'Мехагон'"}
        s["npc;drop=152619"] = {"Король Мехагон", "Операция 'Мехагон'"}
        s["npc;drop=156827"] = {"Эшелон", "Чертоги Покаяния"}
        s["npc;drop=162309"] = {"Кул'тарок", "Театр Боли"}
        s["npc;drop=162317"] = {"Кроворуб", "Театр Боли"}
        s["npc;drop=162329"] = {"Ксав Несломленный", "Театр Боли"}
        s["npc;drop=162689"] = {"Хирург Трупошов", "Смертельная тризна"}
        s["npc;drop=162691"] = {"Чумокост", "Смертельная тризна"}
        s["npc;drop=162693"] = {"Налтор Криомант", "Смертельная тризна"}
        s["npc;drop=163157"] = {"Амарт <Жнец>", "Смертельная тризна"}
        s["npc;drop=164185"] = {"Эшелон", "Чертоги Покаяния"}
        s["npc;drop=164218"] = {"Лорд-камергер", "Чертоги Покаяния"}
        s["npc;drop=164451"] = {"Дессия Обезглавливательница", "Театр Боли"}
        s["npc;drop=164501"] = {"Призывательница Туманов", "Туманы Тирна Скитта"}
        s["npc;drop=164517"] = {"Тред'ова", "Туманы Тирна Скитта"}
        s["npc;drop=164567"] = {"Ингра Малох", "Туманы Тирна Скитта"}
        s["npc;drop=165408"] = {"Халкиас <Запятнанный грехом голиаф>", "Чертоги Покаяния"}
        s["npc;drop=165410"] = {"Верховный адъюдикатор Ализа", "Чертоги Покаяния"}
        s["npc;drop=165946"] = {"Мордрета, Вечная императрица", "Театр Боли"}
        s["npc;drop=175546"] = {"Хронокэп Крюкохвост", "Тайный рынок Тазавеш"}
        s["npc;drop=175616"] = {"Зо'фекс <Часовой>", "Тайный рынок Тазавеш"}
        s["npc;drop=175646"] = {"ПОЧТ-мейстер", "Тайный рынок Тазавеш"}
        s["npc;drop=175663"] = {"Хильбранд <Меч Хранителей>", "Тайный рынок Тазавеш"}
        s["npc;drop=175806"] = {"Со'азми", "Тайный рынок Тазавеш"}
        s["npc;drop=176556"] = {"Алькруукс <Обжора>", "Тайный рынок Тазавеш"}
        s["npc;drop=176563"] = {"Зо'грон", "Тайный рынок Тазавеш"}
        s["npc;drop=176705"] = {"Венца Голдаплавс", "Тайный рынок Тазавеш"}
        s["npc;drop=177269"] = {"Со'лея <Картель Со>", "Тайный рынок Тазавеш"}
        s["npc;drop=188252"] = {"Мелидрусса Истощенная Холодом <Специалистка по насыщению>", "Рубиновые Омуты Жизни"}
        s["npc;drop=189232"] = {"Кокия Пламенное Копыто", "Рубиновые Омуты Жизни"}
        s["npc;drop=190485"] = {"Эркхарт Кровь Бури", "Рубиновые Омуты Жизни"}
        s["npc;drop=190609"] = {"Эхо Дорагосы <Директор академии>", "Академия Алгет'ар"}
        s["npc;drop=191736"] = {"Кроут", "Академия Алгет'ар"}
        s["npc;drop=194181"] = {"Вексам", "Академия Алгет'ар"}
        s["npc;drop=196482"] = {"Заросшее древо", "Академия Алгет'ар"}
        s["npc;drop=202318"] = {"Дозорная группы реагирования", "Пещера Заралек"}
        s["npc;drop=203355"] = {"Капитан Рэйкал", "Пещера Заралек"}
        s["npc;drop=207205"] = {"Бурестраж Горрен", "Гнездовье"}
        s["npc;drop=207207"] = {"Чудище камня Бездны", "Гнездовье"}
        s["npc;drop=207939"] = {"Барон Браунпайк", "Приорат Священного Пламени"}
        s["npc;drop=207940"] = {"Настоятельница Муррпрэй", "Приорат Священного Пламени"}
        s["npc;drop=207946"] = {"Капитан Дейлкрай", "Приорат Священного Пламени"}
        s["npc;drop=208478"] = {"Вулкаросс", "Амирдрассил, Надежда Сна"}
        s["npc;drop=208743"] = {"Пламекон", "Расселина Темного Пламени"}
        s["npc;drop=208745"] = {"Свечной Король", "Расселина Темного Пламени"}
        s["npc;drop=209230"] = {"Кириосс", "Гнездовье"}
        s["npc;drop=210108"] = {"ЗАЗУ", "Каменный Свод"}
        s["npc;drop=210153"] = {"Старый Воскобород", "Расселина Темного Пламени"}
        s["npc;drop=210156"] = {"Скарморак", "Каменный Свод"}
        s["npc;drop=210267"] = {"И'па", "Искроварня"}
        s["npc;drop=210271"] = {"Хмелевар Алдрир", "Искроварня"}
        s["npc;drop=210797"] = {"Тьма", "Расселина Темного Пламени"}
        s["npc;drop=211087"] = {"Проповедница Темная Корона", "Сияющий Рассвет"}
        s["npc;drop=211089"] = {"Ануб'иккадж", "Сияющий Рассвет"}
        s["npc;drop=213119"] = {"Вестник Бездны Эйрих", "Каменный Свод"}
        s["npc;drop=213179"] = {"Аванокс", "Ара-Кара, Город Отголосков"}
        s["npc;drop=213217"] = {"Глашатай Брокк", "Каменный Свод"}
        s["npc;drop=214502"] = {"Скованный кровью ужас", "Неруб'арский дворец"}
        s["npc;drop=214506"] = {"Исказитель яиц Ови'накс", "Неруб'арский дворец"}
        s["npc;drop=214650"] = {"Л'ура", "Эредат"}
        s["npc;drop=214661"] = {"Голди Барондон <Надзирательница медоварни>", "Искроварня"}
        s["npc;drop=215405"] = {"Ануб'зект <Страж роя>", "Ара-Кара, Город Отголосков"}
        s["npc;drop=215407"] = {"Ки'катал Жница", "Ара-Кара, Город Отголосков"}
        s["npc;drop=215657"] = {"Улгракс Пожиратель", "Неруб'арский дворец"}
        s["npc;drop=216320"] = {"Сгустолиция", "Город Нитей"}
        s["npc;drop=216619"] = {"Оратор Крикс'визк <Пятая Нить>", "Город Нитей"}
        s["npc;drop=216648"] = {"Нкс <Клык королевы>", "Город Нитей"}
        s["npc;drop=216658"] = {"Изо Великая Сращивательница", "Город Нитей"}
        s["npc;drop=217489"] = {"Ануб'араш <Меченный тысячей шрамов>", "Неруб'арский дворец"}
        s["npc;drop=218002"] = {"Бенк Жужжикс <Пчеловод>", "Искроварня"}
        s["npc;drop=219778"] = {"Королева Ансурек", "Неруб'арский дворец"}
        s["npc;drop=219853"] = {"Сикран <Капитан суреки>", "Неруб'арский дворец"}
        s["npc;drop=223779"] = {"Ануб'араш <Меченный тысячей шрамов>", "Неруб'арский дворец"}
        s["npc;drop=223839"] = {"Стражник королевы Ге'за", "Неруб'арский дворец"}
        s["npc;drop=224552"] = {"Раша'нан", "Неруб'арский дворец"}
        s["npc;drop=225821"] = {"[The Geargrinder]", "Освобождение Нижней Шахты"}
        s["npc;drop=226305"] = {"[Emperor Dagran Thaurissan]", "Глубины Черной горы"}
        s["npc;drop=226306"] = {"[Golem Lord Argelmach]", "Глубины Черной горы"}
        s["npc;drop=226315"] = {"[Lord Roccor]", "Глубины Черной горы"}
        s["npc;drop=226396"] = {"[Swampface]", "Операция: шлюз"}
        s["npc;drop=226398"] = {"[Big M.O.M.M.A.]", "Операция: шлюз"}
        s["npc;drop=226403"] = {"[Keeza Quickfuse]", "Операция: шлюз"}
        s["npc;drop=226404"] = {"Гизл Гигабжик", "Операция: шлюз"}
        s["npc;drop=228458"] = {"[One-Armed Bandit]", "Освобождение Нижней Шахты"}
        s["npc;drop=228470"] = {"Принцесса Нексуса Ки'веза", "Неруб'арский дворец"}
        s["npc;drop=228652"] = {"[Rik Reverb]", "Освобождение Нижней Шахты"}
        s["npc;drop=229181"] = {"[Flarendo]", "Освобождение Нижней Шахты"}
        s["npc;drop=229284"] = {"Гук Бумгавс <Продавец варева>", "Освобождение Нижней Шахты"}
        s["npc;drop=229288"] = {"Король Флэймспайт <Менеджер Пламендо>", "Освобождение Нижней Шахты"}
        s["npc;drop=229953"] = {"[Mug'Zee]", "Освобождение Нижней Шахты"}
        s["npc;drop=229992"] = {"Сталагнарос", "Остров Сирен"}
        s["npc;drop=230322"] = {"[Stix Bunkjunker]", "Освобождение Нижней Шахты"}
        s["npc;drop=230583"] = {"[Sprocketmonger Lockenstock]", "Освобождение Нижней Шахты"}
        s["npc;drop=230800"] = {"[Slugger the Smart]", "Нижняя Шахта"}
        s["npc;drop=230828"] = {"[Chief Foreman Gutso]", "Нижняя Шахта"}
        s["npc;drop=230934"] = {"[Ratspit]", "Нижняя Шахта"}
        s["npc;drop=230946"] = {"[V.V. Goosworth]", "Нижняя Шахта"}
        s["npc;drop=231310"] = {"Стимулирующий реагент Мрачных Минеров", "Нижняя Шахта"}
        s["npc;drop=231606"] = {"Алозар", "Шпили Ветрокрылых"}
        s["npc;drop=231626"] = {"Калис", "Шпили Ветрокрылых"}
        s["npc;drop=231631"] = {"Командир Кролук <Старая Орда>", "Шпили Ветрокрылых"}
        s["npc;drop=231636"] = {"Неупокоенное сердце", "Шпили Ветрокрылых"}
        s["npc;drop=231863"] = {"Серанель Бич Солнца", "Терраса Магистров"}
        s["npc;drop=231864"] = {"Гемелл", "Терраса Магистров"}
        s["npc;drop=231865"] = {"Дегентрий", "Терраса Магистров"}
        s["npc;drop=231981"] = {"Пасть песков", "К'ареш"}
        s["npc;drop=233814"] = {"Сплетенный страж", "Манагорн Омега"}
        s["npc;drop=233815"] = {"Ткан'итар", "Манагорн Омега"}
        s["npc;drop=233816"] = {"Стражница душ Наазиндри", "Манагорн Омега"}
        s["npc;drop=233824"] = {"Пространствус", "Манагорн Омега"}
        s["npc;drop=234647"] = {"Затуукс Разрушитель <Страж Литиэль>", "Закоулок душегубов"}
        s["npc;drop=234649"] = {"Заэн Траурный Клинок", "Закоулок душегубов"}
        s["npc;drop=234845"] = {"Стаарбс <Будоражащий>", "К'ареш"}
        s["npc;drop=234893"] = {"Ажиккар", "Заповедник 'Аль'дани'"}
        s["npc;drop=234933"] = {"Таа'бат <Неумолимый>", "Заповедник 'Аль'дани'"}
        s["npc;drop=235853"] = {"Смотритель путевых врат", "Манагорн Омега"}
        s["npc;drop=237415"] = {"Литиэль Пепельная Ярость", "Закоулок душегубов"}
        s["npc;drop=237661"] = {"Адар Вспышка Сумерек", "Манагорн Омега"}
        s["npc;drop=237763"] = {"Соправитель Салхадаар", "Манагорн Омега"}
        s["npc;drop=237861"] = {"Fractillus <[The Shatterer]>", "Манагорн Омега"}
        s["npc;drop=238887"] = {"Таз'ра", "Арена Шрама Бездны"}
        s["npc;drop=239008"] = {"Атрокс", "Арена Шрама Бездны"}
        s["npc;drop=239454"] = {"Темный маг Зейд", "Манагорн Омега"}
        s["npc;drop=240432"] = {"Павший король Салхадаар", "Шпиль Бездны"}
        s["npc;drop=240434"] = {"Ненасытникус", "Шпиль Бездны"}
        s["npc;drop=240435"] = {"Император Аверзиан", "Шпиль Бездны"}
        s["npc;drop=241526"] = {"[Chrome King Gallywix]", "Освобождение Нижней Шахты"}
        s["npc;drop=241546"] = {"Лотраксион <Главнокомандующий>", ""}
        s["npc;drop=242031"] = {"Колючешей <Последний улов>", "Зул'Аман"}
        s["npc;drop=242056"] = {"Ваэлгор", "Шпиль Бездны"}
        s["npc;drop=242255"] = {"[Geezle Gigazap]", "Операция: шлюз"}
        s["npc;drop=24239"] = {"Повелитель проклятий Малакрасс", "Отравленная бездна"}
        s["npc;drop=243028"] = {"Мейттик", "Слепящая долина"}
        s["npc;drop=244752"] = {"Принцесса Нексуса Ки'веза", "Убежище рассекателя Бездны"}
        s["npc;drop=244761"] = {"Alleria Windrunner", "Шпиль Бездны"}
        s["npc;drop=244762"] = {"Лу'ашал", "Леса Вечной Песни"}
        s["npc;drop=244887"] = {"Икузз Охотник Света", "Слепящая долина"}
        s["npc;drop=245044"] = {"Ночная оса", "Буря Бездны"}
        s["npc;drop=245912"] = {"Страж Света Руйя", "Слепящая долина"}
        s["npc;drop=246633"] = {"Загнанный крылобег", "Леса Вечной Песни"}
        s["npc;drop=246729"] = {"Уголь Света <Дитя Бело'рена>", "Остров Кель'Данас"}
        s["npc;drop=247283"] = {"Soul-Scribe", ""}
        s["npc;drop=247570"] = {"Муро'джин", "Пещеры Маисара"}
        s["npc;drop=247676"] = {"Зиккет <Искривленное порождение Света>", "Слепящая долина"}
        s["npc;drop=247976"] = {"Браконьер Рав'ик <Племя Порочной Ветви>", "Зул'Аман"}
        s["npc;drop=247989"] = {"Ткач горна Араз", "Манагорн Омега"}
        s["npc;drop=248015"] = {"Харон", "Арена Шрама Бездны"}
        s["npc;drop=248595"] = {"Вордаза", "Пещеры Маисара"}
        s["npc;drop=248605"] = {"Рак'тул <Сосуд душ>", "Пещеры Маисара"}
        s["npc;drop=248710"] = {"Прозапасник <Племя Призрачной Лапы>", "Берлога Налоракка"}
        s["npc;drop=248823"] = {"Черноруд", "Буря Бездны"}
        s["npc;drop=249844"] = {"Хиронекс <Парящая смерть>", "Харандар"}
        s["npc;drop=250086"] = {"Коряжун <Ужас Харандара>", "Харандар"}
        s["npc;drop=250358"] = {"Аннулий Сотрясатель Миров", "Харандар"}
        s["npc;drop=250589"] = {"Боевой капеллан Сенн", "Шпиль Бездны"}
        s["npc;drop=252458"] = {"Кистия Сердце Маны", "Закоулок душегубов"}
        s["npc;drop=252959"] = {"Нимрисса Волногон", "Приливный грот"}
        s["npc;drop=254176"] = {"Гнилотоп", "Споропад"}
        s["npc;drop=254227"] = {"Ядрохранительница Нисарра", ""}
        s["npc;drop=256116"] = {"Химерий <Неприснившийся Бог>", "Провал снов"}
        s["npc;drop=257347"] = {"Ссзорак", "Отравленная бездна"}
        s["npc;drop=257361"] = {"Вексул", "Отравленная бездна"}
        s["npc;drop=257906"] = {"Золотоглазый Скалли", "Спиральный остров"}
        s["npc;drop=258557"] = {"Дыхание Ула'тек", "Отравленная бездна"}
        s["npc;drop=258877"] = {"Налоракк <Лоа войны>", "Берлога Налоракка"}
        s["npc;drop=258916"] = {"Гарсекг <Остовокрушитель>", "Спиральный остров"}
        s["npc;drop=259445"] = {"Рав'и", "Алтарь Клыков"}
        s["npc;drop=259446"] = {"Извивающийся виток", "Алтарь Клыков"}
        s["npc;drop=259447"] = {"Зул'джан", "Алтарь Клыков"}
        s["npc;drop=260905"] = {"Жгучий яд", "Отравленная бездна"}
        s["npc;drop=261053"] = {"Часовой зимы", "Берлога Налоракка"}
        s["npc;drop=263456"] = {"Сзарит Клыкастый", ""}
        s["npc;drop=264854"] = {"Фартик Расхитительница", "Спиральный остров"}
        s["npc;drop=267077"] = {"Мор'захи", "Отравленная бездна"}
        s["npc;drop=268090"] = {"Кари'за Забытый", "Спиральный остров"}
        s["npc;drop=268956"] = {"Ула'тек", "Отравленная бездна"}
        s["npc;drop=269808"] = {"Ака'али Завоевательница", "Гробница королей"}
        s["npc;drop=271337"] = {"Echo of Jawae <[Soulcoiler Cult]>", "Отравленная бездна"}
        s["npc;drop=36476"] = {"Ик <Прислужник Крика>", "Яма Сарона"}
        s["npc;drop=36494"] = {"Начальник кузни Гархлад", "Яма Сарона"}
        s["npc;drop=36658"] = {"Повелитель Плети Тираний", "Яма Сарона"}
        s["npc;drop=39625"] = {"Генерал Умбрисс <Служитель Смертокрыла>", "Грим Батол"}
        s["npc;drop=40177"] = {"Начальник кузни Тронг", "Грим Батол"}
        s["npc;drop=40319"] = {"Драгх Горячий Мрак <Курьер Сумеречного Молота>", "Грим Батол"}
        s["npc;drop=40484"] = {"Эрудакс <Повелитель Глубин>", "Грим Батол"}
        s["npc;drop=75452"] = {"Костебрюх", "Некрополь Призрачной Луны"}
        s["npc;drop=75964"] = {"Ранжит <Повелитель Четырех Ветров>", "Небесный Путь"}
        s["npc;drop=76141"] = {"Аракнат <Творение Солнца>", "Небесный Путь"}
        s["npc;drop=76266"] = {"Высший мудрец Вирикс", "Небесный Путь"}
        s["npc;drop=76379"] = {"Рухран", "Небесный Путь"}
        s["npc;sold=219222"] = {"Лаланди <Награды за очки завоевания>", "Дорногал"}
        s["npc;sold=224270"] = {"Ип'ксал", "Город Нитей"}
        s["npc;sold=227003"] = {"Кир'ксал <Сборщица диковинок>", "Город Нитей"}
        s["npc;sold=231824"] = {"[Kari Bridgeblaster]", "Нижняя Шахта"}
        s["npc;sold=243220"] = {"Ирисса Кровавая Звезда <Награды за очки завоевания>", "Луносвет"}
        s["npc;sold=248303"] = {"Zah'ran <[Delve Trinkets]>", "Место раскопок 9"}
        s["npc;sold=256670"] = {"Зах'ран <Снаряжение из вылазок>", "Общая Беда"}
        s["object;contained=413563"] = {"Тяжелый ларь", "Пещера микомантов"}
        s["object;contained=413590"] = {"Богатый сундук", "Яма Ужаса"}
        s["object;contained=416265"] = {"Опустошенный ларь", "Яма Ужаса"}
        s["object;contained=476068"] = {"[Papa's Prized Putter]", "Нижняя Шахта"}
        s["object;contained=507768"] = {"Выброшенная куча гоблинской валюты", "Место раскопок 9"}
        s["object;contained=574407"] = {"Тайник претендента", "Терраса Магистров"}
        s["object;contained=574409"] = {"Тайник претендента", ""}
        s["object;contained=581922"] = {"Тайное сокровище", "Общая Беда"}
        s["object;contained=584514"] = {"Богатый сундук", "Общая Беда"}
        s["object;contained=584518"] = {"Богатый тяжелый ларь", "Общая Беда"}
        s["object;contained=584519"] = {"Тяжелый ларь", "Общая Беда"}
        s["quest;reward=66119"] = {"Рубиновые Омуты Жизни: вторжение воинов стихий", ""}
        s["quest;reward=78232"] = {"Переписывая переписанное", ""}
        s["quest;reward=78636"] = {"Битва за рудники", ""}
        s["quest;reward=79342"] = {"Расставание", ""}
        s["quest;reward=83125"] = {"", "Зулдазар"}
        s["quest;reward=86521"] = {"Узел Нексуса Зенас: Затмение", ""}
        s["quest;reward=91009"] = {"Долговечный Информационный Сохраняющий Контейнер", "Дорногал"}
        s["quest;reward=91694"] = {"Арена Шрама Бездны: Раскол троицы", ""}
        s["quest;reward=91958"] = {"Берлога Налоракка: Непрощенный", ""}
        s["quest;reward=93417"] = {"Хранилища Атал'Утека: Алтарь Клыков", ""}
        s["quest;reward=93651"] = {"Слепящая долина: корни светоцвета", ""}
        s["quest;reward=93933"] = {"Сокровища под охраной", ""}
        s["spell;created=1228945"] = {"Наручники мученика", "CRAFTING"}
        s["spell;created=1228950"] = {"Шелковый покров приверженца", "CRAFTING"}
        s["spell;created=1228984"] = {"Наручи из тайной ткани", "CRAFTING"}
        s["spell;created=1228985"] = {"Плащ из тайной ткани", "CRAFTING"}
        s["spell;created=1228988"] = {"Шнурованный ремень из тайной ткани", "CRAFTING"}
        s["spell;created=1229648"] = {"Боевой меч рыцаря крови", "CRAFTING"}
        s["spell;created=1229649"] = {"Цветокованный коготь", "CRAFTING"}
        s["spell;created=1229657"] = {"Боевой клинок разрушителя чар", "CRAFTING"}
        s["spell;created=1229659"] = {"Милосердие Странника", "CRAFTING"}
        s["spell;created=1229662"] = {"Наручи разрушителя чар", "CRAFTING"}
        s["spell;created=1229875"] = {"Поручи из эфирного волокна", "CRAFTING"}
        s["spell;created=1229877"] = {"Наручи из эфирного волокна", "CRAFTING"}
        s["spell;created=1230061"] = {"Светильник Альн'ары", "CRAFTING"}
        s["spell;created=1230070"] = {"Господство Новолуния 'Кровь'", "CRAFTING"}
        s["spell;created=1230071"] = {"Господство Новолуния 'Гниль'", "CRAFTING"}
        s["spell;created=1230072"] = {"Господство Новолуния 'Охота'", "CRAFTING"}
        s["spell;created=1230073"] = {"Господство Новолуния 'Бездна'", "CRAFTING"}
        s["spell;created=1230479"] = {"Кольцо почитателя лоа", "CRAFTING"}
        s["spell;created=1230485"] = {"Син'дорайский перстень искусной работы", "CRAFTING"}
        s["spell;created=1230486"] = {"Син'дорайский амулет искусной работы", "CRAFTING"}
        s["spell;created=1230487"] = {"Печатка азеротских благословений", "CRAFTING"}
        s["spell;created=1230861"] = {"Изначальный философский камень", "CRAFTING"}
        s["spell;created=1230885"] = {"Алхимический камень магистра", "CRAFTING"}
        s["spell;created=1237508"] = {"Тихие сапоги луносветского агента", "CRAFTING"}
        s["spell;created=1237509"] = {"Повязки луносветского агента", "CRAFTING"}
        s["spell;created=1237513"] = {"Рабочий пояс луносветского агента", "CRAFTING"}
        s["spell;created=1237514"] = {"Отражатели луносветского агента", "CRAFTING"}
        s["spell;created=1237518"] = {"Корневые туфли хранителя Древа", "CRAFTING"}
        s["spell;created=1237519"] = {"Древесная пряжка хранителя Древа", "CRAFTING"}
        s["spell;created=1237537"] = {"Острые когти Странника", "CRAFTING"}
        s["spell;created=1237543"] = {"Пластинчатые наручи Странника", "CRAFTING"}
        s["spell;created=1249111"] = {"Получение повязок", "CRAFTING"}
        s["spell;created=1253219"] = {"Охота", ""}
        s["spell;created=1253220"] = {"Бездна", ""}
        s["spell;created=1253221"] = {"Кровь", ""}
        s["spell;created=1253222"] = {"Гниль", ""}
        s["spell;created=237828"] = {"Вантийская руна: демоническая инквизиция", ""}
        s["spell;created=239649"] = {"Инфернальное сокрушение", ""}
        s["spell;created=244572"] = {"Призыв духа", ""}
        s["spell;created=244581"] = {"Падающая комета", ""}
        s["spell;created=244609"] = {"Призыв духа - барабанный бой", ""}
        s["spell;created=427185"] = {"Алгарийский алхимический камень", "CRAFTING"}
        s["spell;created=435382"] = {"Узы связи", "CRAFTING"}
        s["spell;created=435384"] = {"Кольцо мастерства земельников", "CRAFTING"}
        s["spell;created=435385"] = {"Амулет мастерства земельников", "CRAFTING"}
        s["spell;created=441051"] = {"Мундир с руническим клеймом", "CRAFTING"}
        s["spell;created=441052"] = {"Тяжелые ботинки с руническим клеймом", "CRAFTING"}
        s["spell;created=441053"] = {"Захваты с руническим клеймом", "CRAFTING"}
        s["spell;created=441055"] = {"Бриджи с руническим клеймом", "CRAFTING"}
        s["spell;created=441057"] = {"Боевой пояс с руническим клеймом", "CRAFTING"}
        s["spell;created=441058"] = {"Поручи с руническим клеймом", "CRAFTING"}
        s["spell;created=441060"] = {"Гравированные символами высокие ботинки", "CRAFTING"}
        s["spell;created=441061"] = {"Гравированные символами рукавицы", "CRAFTING"}
        s["spell;created=441063"] = {"Гравированные символами шоссы", "CRAFTING"}
        s["spell;created=441065"] = {"Гравированная символами обвязка", "CRAFTING"}
        s["spell;created=441066"] = {"Гравированные символами тяжелые наручи", "CRAFTING"}
        s["spell;created=444070"] = {"Застежка выброса адреналина", "CRAFTING"}
        s["spell;created=444197"] = {"Факел бродяги", "CRAFTING"}
        s["spell;created=444198"] = {"Аккуратная трость бродяги", "CRAFTING"}
        s["spell;created=444199"] = {"Ограничивающий жезл бродяги", "CRAFTING"}
        s["spell;created=445355"] = {"Скипетр сияющей магии", "CRAFTING"}
        s["spell;created=446937"] = {"Освященные туфли", "CRAFTING"}
        s["spell;created=446938"] = {"Освященные манжеты", "CRAFTING"}
        s["spell;created=446939"] = {"Освященный шнурованный ремень", "CRAFTING"}
        s["spell;created=446940"] = {"Освященный плащ", "CRAFTING"}
        s["spell;created=447314"] = {"Ускоритель мыслительного процесса", "CRAFTING"}
        s["spell;created=447315"] = {"Перегруженный генератор идей", "CRAFTING"}
        s["spell;created=447352"] = {"ПИФ-П4Ф", "CRAFTING"}
        s["spell;created=450220"] = {"Выкованные навеки башмаки", "CRAFTING"}
        s["spell;created=450222"] = {"Выкованный навеки большой пояс", "CRAFTING"}
        s["spell;created=450223"] = {"Выкованный навеки защитник", "CRAFTING"}
        s["spell;created=450224"] = {"Выкованный навеки шлем", "CRAFTING"}
        s["spell;created=450226"] = {"Выкованные навеки тяжелые наручи", "CRAFTING"}
        s["spell;created=450229"] = {"Выкованный навеки пронзатель", "CRAFTING"}
        s["spell;created=450230"] = {"Выкованный навеки кинжал", "CRAFTING"}
        s["spell;created=450231"] = {"Выкованный навеки длинный меч", "CRAFTING"}
        s["spell;created=450232"] = {"Выкованный навеки боевой клинок", "CRAFTING"}
        s["spell;created=450234"] = {"Выкованный навеки большой топор", "CRAFTING"}
        s["spell;created=450235"] = {"Заряженный колдовской меч", "CRAFTING"}
        s["spell;created=450237"] = {"Заряженный разбиватель шлемов", "CRAFTING"}
        s["spell;created=450238"] = {"Заряженный клеймор", "CRAFTING"}
        s["spell;created=450239"] = {"Заряженная алебарда", "CRAFTING"}
        s["spell;created=450242"] = {"Заряженный рассекатель", "CRAFTING"}
        s["spell;created=455391"] = {"Бодрость", ""}
        s["spell;created=455392"] = {"Симбиоз", ""}
        s["spell;created=455393"] = {"Сияние", ""}
        s["spell;created=455394"] = {"Вознесение", ""}
        s["spell;created=473400"] = {"Рекалибровка для заклинаний", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationzhCN()
        s["item:contained=229129"] = {"一箱地下堡行者的宝藏", ""}
        s["item:contained=229354"] = {"阿加冒险者的宝箱", ""}
        s["item:contained=235639"] = {"干练冒险者的宝箱", ""}
        s["item:contained=238208"] = {"奶奶的峰时红利", ""}
        s["item:contained=262346"] = {"寻猎者的勇士宝箱", ""}
        s["npc;drop=122056"] = {"总督奈扎尔", "执政团之座"}
        s["npc;drop=122313"] = {"晋升者祖拉尔", "执政团之座"}
        s["npc;drop=122316"] = {"萨普瑞什 <影卫复仇军领主>", "执政团之座"}
        s["npc;drop=124729"] = {"鲁拉", "执政团之座"}
        s["npc;drop=128649"] = {"拜恩比吉中士", "围攻伯拉勒斯"}
        s["npc;drop=128650"] = {"“屠夫”血钩", "围攻伯拉勒斯"}
        s["npc;drop=128651"] = {"哈达尔·黑渊", "围攻伯拉勒斯"}
        s["npc;drop=128652"] = {"维克戈斯 <深渊魔王>", "围攻伯拉勒斯"}
        s["npc;drop=129208"] = {"恐怖船长洛克伍德", "围攻伯拉勒斯"}
        s["npc;drop=129214"] = {"投币式群体打击者", "暴富矿区！！"}
        s["npc;drop=129227"] = {"艾泽洛克", "暴富矿区！！"}
        s["npc;drop=129231"] = {"瑞克莎·流火", "暴富矿区！！"}
        s["npc;drop=131227"] = {"商业大亨拉兹敦克", "暴富矿区！！"}
        s["npc;drop=132713"] = {"商业大亨拉兹敦克", "暴富矿区！！"}
        s["npc;drop=133384"] = {"米利克萨", "塞塔里斯神庙"}
        s["npc;drop=133389"] = {"加瓦兹特", "塞塔里斯神庙"}
        s["npc;drop=133392"] = {"塞塔里斯的化身", "塞塔里斯神庙"}
        s["npc;drop=133944"] = {"阿斯匹克斯", "塞塔里斯神庙"}
        s["npc;drop=134993"] = {"殓尸者姆沁巴", "诸王之眠"}
        s["npc;drop=135322"] = {"黄金风蛇", "诸王之眠"}
        s["npc;drop=136160"] = {"达萨大王 <始皇>", "诸王之眠"}
        s["npc;drop=144244"] = {"白金拳手", "麦卡贡行动"}
        s["npc;drop=144246"] = {"狂犬K.U.-J.0.", "麦卡贡行动"}
        s["npc;drop=144248"] = {"首席机械师闪流", "麦卡贡行动"}
        s["npc;drop=150159"] = {"戈巴马克国王", "麦卡贡行动"}
        s["npc;drop=150222"] = {"冈克", "麦卡贡行动"}
        s["npc;drop=150397"] = {"麦卡贡国王", "麦卡贡行动"}
        s["npc;drop=152619"] = {"麦卡贡国王", "麦卡贡行动"}
        s["npc;drop=156827"] = {"艾谢朗", "赎罪大厅"}
        s["npc;drop=162309"] = {"库尔萨洛克", "伤逝剧场"}
        s["npc;drop=162317"] = {"斩血", "伤逝剧场"}
        s["npc;drop=162329"] = {"无堕者哈夫", "伤逝剧场"}
        s["npc;drop=162689"] = {"外科医生缝肉", "通灵战潮"}
        s["npc;drop=162691"] = {"凋骨", "通灵战潮"}
        s["npc;drop=162693"] = {"缚霜者纳尔佐", "通灵战潮"}
        s["npc;drop=163157"] = {"阿玛厄斯 <收割者>", "通灵战潮"}
        s["npc;drop=164185"] = {"艾谢朗", "赎罪大厅"}
        s["npc;drop=164218"] = {"宫务大臣", "赎罪大厅"}
        s["npc;drop=164451"] = {"斩首者德茜雅", "伤逝剧场"}
        s["npc;drop=164501"] = {"唤雾者", "塞兹仙林的迷雾"}
        s["npc;drop=164517"] = {"特雷德奥瓦", "塞兹仙林的迷雾"}
        s["npc;drop=164567"] = {"英格拉·马洛克", "塞兹仙林的迷雾"}
        s["npc;drop=165408"] = {"哈尔吉亚斯 <罪污巨像>", "赎罪大厅"}
        s["npc;drop=165410"] = {"高阶裁决官阿丽兹", "赎罪大厅"}
        s["npc;drop=165946"] = {"无尽女皇莫德蕾莎", "伤逝剧场"}
        s["npc;drop=175546"] = {"时空船长钩尾", "塔扎维什，帷纱集市"}
        s["npc;drop=175616"] = {"佐·菲克斯 <哨卫>", "塔扎维什，帷纱集市"}
        s["npc;drop=175646"] = {"P.O.S.T.总管", "塔扎维什，帷纱集市"}
        s["npc;drop=175663"] = {"希尔布兰德 <守护者之剑>", "塔扎维什，帷纱集市"}
        s["npc;drop=175806"] = {"索·阿兹密", "塔扎维什，帷纱集市"}
        s["npc;drop=176556"] = {"阿尔克鲁克斯 <暴食者>", "塔扎维什，帷纱集市"}
        s["npc;drop=176563"] = {"佐·格伦", "塔扎维什，帷纱集市"}
        s["npc;drop=176705"] = {"雯扎·金线", "塔扎维什，帷纱集市"}
        s["npc;drop=177269"] = {"索·莉亚 <索财团>", "塔扎维什，帷纱集市"}
        s["npc;drop=188252"] = {"梅莉杜莎·寒妆 <注能专家>", "红玉新生法池"}
        s["npc;drop=189232"] = {"柯姬雅·焰蹄", "红玉新生法池"}
        s["npc;drop=190485"] = {"厄克哈特·风脉", "红玉新生法池"}
        s["npc;drop=190609"] = {"多拉苟萨的回响 <首席教师>", "艾杰斯亚学院"}
        s["npc;drop=191736"] = {"克罗兹", "艾杰斯亚学院"}
        s["npc;drop=194181"] = {"维克萨姆斯", "艾杰斯亚学院"}
        s["npc;drop=196482"] = {"茂林古树", "艾杰斯亚学院"}
        s["npc;drop=202318"] = {"响应战队守护者", "查拉雷克洞窟"}
        s["npc;drop=203355"] = {"雷卡尔上尉", "查拉雷克洞窟"}
        s["npc;drop=207205"] = {"雷卫戈伦", "驭雷栖巢"}
        s["npc;drop=207207"] = {"虚空石畸体", "驭雷栖巢"}
        s["npc;drop=207939"] = {"布朗派克男爵", "圣焰隐修院"}
        s["npc;drop=207940"] = {"隐修院长穆普雷", "圣焰隐修院"}
        s["npc;drop=207946"] = {"戴尔克莱上尉", "圣焰隐修院"}
        s["npc;drop=208478"] = {"沃尔科罗斯", "阿梅达希尔，梦境之愿"}
        s["npc;drop=208743"] = {"布雷炙孔", "暗焰裂口"}
        s["npc;drop=208745"] = {"蜡烛之王", "暗焰裂口"}
        s["npc;drop=209230"] = {"凯里欧斯", "驭雷栖巢"}
        s["npc;drop=210108"] = {"E.D.N.A.", "矶石宝库"}
        s["npc;drop=210153"] = {"老蜡须", "暗焰裂口"}
        s["npc;drop=210156"] = {"斯卡莫拉克", "矶石宝库"}
        s["npc;drop=210267"] = {"艾帕", "燧酿酒庄"}
        s["npc;drop=210271"] = {"酿造大师阿德里尔", "燧酿酒庄"}
        s["npc;drop=210797"] = {"黑暗之主", "暗焰裂口"}
        s["npc;drop=211087"] = {"代言人夏多克朗", "破晨号"}
        s["npc;drop=211089"] = {"阿努布伊卡基", "破晨号"}
        s["npc;drop=213119"] = {"虚空代言人艾里克", "矶石宝库"}
        s["npc;drop=213179"] = {"阿瓦诺克斯", "艾拉-卡拉，回响之城"}
        s["npc;drop=213217"] = {"代言人布洛克", "矶石宝库"}
        s["npc;drop=214502"] = {"血缚恐魔", "尼鲁巴尔王宫"}
        s["npc;drop=214506"] = {"虫巢扭曲者欧维纳克斯", "尼鲁巴尔王宫"}
        s["npc;drop=214650"] = {"鲁拉", "艾瑞达斯"}
        s["npc;drop=214661"] = {"戈尔迪·底爵 <蜂老板>", "燧酿酒庄"}
        s["npc;drop=215405"] = {"阿努布泽克特 <虫群卫士>", "艾拉-卡拉，回响之城"}
        s["npc;drop=215407"] = {"收割者吉卡塔尔", "艾拉-卡拉，回响之城"}
        s["npc;drop=215657"] = {"噬灭者乌格拉克斯", "尼鲁巴尔王宫"}
        s["npc;drop=216320"] = {"凝结聚合体", "千丝之城"}
        s["npc;drop=216619"] = {"演说者基克斯威兹克 <第五帛丝>", "千丝之城"}
        s["npc;drop=216648"] = {"恩克斯 <女王之牙>", "千丝之城"}
        s["npc;drop=216658"] = {"大捻接师艾佐", "千丝之城"}
        s["npc;drop=217489"] = {"阿努巴拉什 <千疤者>", "尼鲁巴尔王宫"}
        s["npc;drop=218002"] = {"本克·鸣蜂 <养蜂人>", "燧酿酒庄"}
        s["npc;drop=219778"] = {"安苏雷克女王", "尼鲁巴尔王宫"}
        s["npc;drop=219853"] = {"席克兰 <苏雷吉队长>", "尼鲁巴尔王宫"}
        s["npc;drop=223779"] = {"Anub'arash <[The Thousand Scars]>", "尼鲁巴尔王宫"}
        s["npc;drop=223839"] = {"女王亲卫杰扎", "尼鲁巴尔王宫"}
        s["npc;drop=224552"] = {"拉夏南", "尼鲁巴尔王宫"}
        s["npc;drop=225821"] = {"[The Geargrinder]", "解放安德麦"}
        s["npc;drop=226305"] = {"[Emperor Dagran Thaurissan]", "黑石深渊"}
        s["npc;drop=226306"] = {"[Golem Lord Argelmach]", "黑石深渊"}
        s["npc;drop=226315"] = {"[Lord Roccor]", "黑石深渊"}
        s["npc;drop=226396"] = {"[Swampface]", "水闸行动"}
        s["npc;drop=226398"] = {"[Big M.O.M.M.A.]", "水闸行动"}
        s["npc;drop=226403"] = {"[Keeza Quickfuse]", "水闸行动"}
        s["npc;drop=226404"] = {"吉泽尔·超震", "水闸行动"}
        s["npc;drop=228458"] = {"[One-Armed Bandit]", "解放安德麦"}
        s["npc;drop=228470"] = {"节点女亲王凯威扎", "尼鲁巴尔王宫"}
        s["npc;drop=228652"] = {"[Rik Reverb]", "解放安德麦"}
        s["npc;drop=229181"] = {"[Flarendo]", "解放安德麦"}
        s["npc;drop=229284"] = {"古克·轰犬 <污液贩子>", "解放安德麦"}
        s["npc;drop=229288"] = {"喷焰大王 <弗莱兰多的经理>", "解放安德麦"}
        s["npc;drop=229953"] = {"[Mug'Zee]", "解放安德麦"}
        s["npc;drop=229992"] = {"石笋纳罗克", "海妖岛"}
        s["npc;drop=230322"] = {"[Stix Bunkjunker]", "解放安德麦"}
        s["npc;drop=230583"] = {"[Sprocketmonger Lockenstock]", "解放安德麦"}
        s["npc;drop=230800"] = {"[Slugger the Smart]", "安德麦"}
        s["npc;drop=230828"] = {"[Chief Foreman Gutso]", "安德麦"}
        s["npc;drop=230934"] = {"[Ratspit]", "安德麦"}
        s["npc;drop=230946"] = {"[V.V. Goosworth]", "安德麦"}
        s["npc;drop=231310"] = {"暗索沉淀剂", "安德麦"}
        s["npc;drop=231606"] = {"烬晓", "风行者之塔"}
        s["npc;drop=231626"] = {"卡莉斯", "风行者之塔"}
        s["npc;drop=231631"] = {"指挥官克罗鲁科 <旧部落>", "风行者之塔"}
        s["npc;drop=231636"] = {"无眠之心", "风行者之塔"}
        s["npc;drop=231863"] = {"瑟拉奈尔·日鞭", "魔导师平台"}
        s["npc;drop=231864"] = {"吉美尔鲁斯", "魔导师平台"}
        s["npc;drop=231865"] = {"迪詹崔乌斯", "魔导师平台"}
        s["npc;drop=231981"] = {"沙海之喉", "卡雷什"}
        s["npc;drop=233814"] = {"集能哨兵", "法力熔炉：欧米伽"}
        s["npc;drop=233815"] = {"卢米萨尔", "法力熔炉：欧米伽"}
        s["npc;drop=233816"] = {"缚魂者娜欣达利", "法力熔炉：欧米伽"}
        s["npc;drop=233824"] = {"迪门修斯", "法力熔炉：欧米伽"}
        s["npc;drop=234647"] = {"歼灭者萨祖克斯 <利希尔的守护者>", "密谋小径"}
        s["npc;drop=234649"] = {"赞恩·刃悲", "密谋小径"}
        s["npc;drop=234845"] = {"司萨阿布斯 <心智搅荡者>", "卡雷什"}
        s["npc;drop=234893"] = {"阿兹希卡", "奥尔达尼生态圆顶"}
        s["npc;drop=234933"] = {"塔尔·巴特 <无情者>", "奥尔达尼生态圆顶"}
        s["npc;drop=235853"] = {"界门观察者", "法力熔炉：欧米伽"}
        s["npc;drop=237415"] = {"利希尔·烬怒", "密谋小径"}
        s["npc;drop=237661"] = {"阿达拉斯·暮焰", "法力熔炉：欧米伽"}
        s["npc;drop=237763"] = {"节点之王萨哈达尔", "法力熔炉：欧米伽"}
        s["npc;drop=237861"] = {"Fractillus <[The Shatterer]>", "法力熔炉：欧米伽"}
        s["npc;drop=238887"] = {"塔兹拉尔", "虚空之痕竞技场"}
        s["npc;drop=239008"] = {"阿特洛苏斯", "虚空之痕竞技场"}
        s["npc;drop=239454"] = {"暗法师扎杜斯", "法力熔炉：欧米伽"}
        s["npc;drop=240432"] = {"陨落之王萨哈达尔", "虚影尖塔"}
        s["npc;drop=240434"] = {"弗拉希乌斯", "虚影尖塔"}
        s["npc;drop=240435"] = {"元首阿福扎恩", "虚影尖塔"}
        s["npc;drop=241526"] = {"[Chrome King Gallywix]", "解放安德麦"}
        s["npc;drop=241546"] = {"洛萨克森 <高阶指挥官>", ""}
        s["npc;drop=242031"] = {"刺鳍 <最致命的猎物>", "祖阿曼"}
        s["npc;drop=242056"] = {"威厄高尔", "虚影尖塔"}
        s["npc;drop=242255"] = {"[Geezle Gigazap]", "水闸行动"}
        s["npc;drop=24239"] = {"妖术领主玛拉卡斯", "烈毒之渊"}
        s["npc;drop=243028"] = {"梅提克", "夺目谷"}
        s["npc;drop=244752"] = {"节点女亲王凯威扎", "虚空之锋庇护所"}
        s["npc;drop=244761"] = {"Alleria Windrunner", "虚影尖塔"}
        s["npc;drop=244762"] = {"鲁阿夏尔", "永歌森林"}
        s["npc;drop=244887"] = {"圣光猎手伊库兹", "夺目谷"}
        s["npc;drop=245044"] = {"暮夜蜂", "虚影风暴"}
        s["npc;drop=245912"] = {"护光者鲁伊亚", "夺目谷"}
        s["npc;drop=246633"] = {"疲惫的陆行鸟", "永歌森林"}
        s["npc;drop=246729"] = {"圣光燃烬 <贝洛朗的子嗣>", "奎尔丹纳斯岛"}
        s["npc;drop=247283"] = {"Soul-Scribe", ""}
        s["npc;drop=247570"] = {"姆罗金", "迈萨拉洞窟"}
        s["npc;drop=247676"] = {"兹欧凯特 <瘤节光耀之子>", "夺目谷"}
        s["npc;drop=247976"] = {"盗猎者拉维科 <邪枝部族>", "祖阿曼"}
        s["npc;drop=247989"] = {"熔炉编织者阿拉兹", "法力熔炉：欧米伽"}
        s["npc;drop=248015"] = {"煞戎努斯", "虚空之痕竞技场"}
        s["npc;drop=248595"] = {"沃达扎", "迈萨拉洞窟"}
        s["npc;drop=248605"] = {"拉克图尔 <聚魂之器>", "迈萨拉洞窟"}
        s["npc;drop=248710"] = {"The Hoardmonger <[Spiritpaw Tribe]>", "纳洛拉克的洞穴"}
        s["npc;drop=248823"] = {"黑核", "虚影风暴"}
        s["npc;drop=249844"] = {"海蜂蜇 <飘浮的死神>", "哈籁恩达尔"}
        s["npc;drop=250086"] = {"断株 <哈籁恩达尔的魔王>", "哈籁恩达尔"}
        s["npc;drop=250358"] = {"撼世者安努勒斯", "哈籁恩达尔"}
        s["npc;drop=250589"] = {"战争牧师瑟恩", "虚影尖塔"}
        s["npc;drop=252458"] = {"凯斯媞亚·魔力之心", "密谋小径"}
        s["npc;drop=252959"] = {"尼姆瑞莎·唤波者", "潮缚石窟"}
        s["npc;drop=254176"] = {"腐沼", "孢陨幽境"}
        s["npc;drop=254227"] = {"核心守卫奈萨拉", ""}
        s["npc;drop=256116"] = {"奇美鲁斯 <未梦之神>", "梦境裂隙"}
        s["npc;drop=257347"] = {"斯索拉克", "烈毒之渊"}
        s["npc;drop=257361"] = {"维克苏尔", "烈毒之渊"}
        s["npc;drop=257906"] = {"钱眼斯卡利", "盘卷蛇岛"}
        s["npc;drop=258557"] = {"乌拉特克之息", "烈毒之渊"}
        s["npc;drop=258877"] = {"纳洛拉克 <战争之神>", "纳洛拉克的洞穴"}
        s["npc;drop=258916"] = {"加赛格 <船体撕裂者>", "盘卷蛇岛"}
        s["npc;drop=259445"] = {"拉维", "毒牙祭坛"}
        s["npc;drop=259446"] = {"扭缠盘蛇", "毒牙祭坛"}
        s["npc;drop=259447"] = {"祖尔加", "毒牙祭坛"}
        s["npc;drop=260905"] = {"燃烧剧毒", "烈毒之渊"}
        s["npc;drop=261053"] = {"寒冬哨兵", "纳洛拉克的洞穴"}
        s["npc;drop=263456"] = {"锐牙者萨里斯", ""}
        s["npc;drop=264854"] = {"掠夺者法锡克", "盘卷蛇岛"}
        s["npc;drop=267077"] = {"莫尔扎希", "烈毒之渊"}
        s["npc;drop=268090"] = {"被遗忘的卡里扎", "盘卷蛇岛"}
        s["npc;drop=268956"] = {"乌拉特克", "烈毒之渊"}
        s["npc;drop=269808"] = {"征服者阿卡阿里", "诸王之眠"}
        s["npc;drop=271337"] = {"Echo of Jawae <[Soulcoiler Cult]>", "烈毒之渊"}
        s["npc;drop=36476"] = {"伊克 <科瑞克的奴仆>", "萨隆矿坑"}
        s["npc;drop=36494"] = {"熔炉之主加弗斯特", "萨隆矿坑"}
        s["npc;drop=36658"] = {"天灾领主泰兰努斯", "萨隆矿坑"}
        s["npc;drop=39625"] = {"乌比斯将军 <死亡之翼的仆从>", "格瑞姆巴托"}
        s["npc;drop=40177"] = {"铸炉之主索朗格斯", "格瑞姆巴托"}
        s["npc;drop=40319"] = {"达加·燃影者 <暮光之锤信使>", "格瑞姆巴托"}
        s["npc;drop=40484"] = {"埃鲁达克 <地狱公爵>", "格瑞姆巴托"}
        s["npc;drop=75452"] = {"骨喉", "影月墓地"}
        s["npc;drop=75964"] = {"兰吉特 <四风大师>", "通天峰"}
        s["npc;drop=76141"] = {"阿拉卡纳斯 <炎阳构装体>", "通天峰"}
        s["npc;drop=76266"] = {"高阶贤者维里克斯", "通天峰"}
        s["npc;drop=76379"] = {"鲁克兰", "通天峰"}
        s["npc;sold=219222"] = {"拉兰迪 <征服军需官>", "多恩诺嘉尔"}
        s["npc;sold=224270"] = {"伊普克萨", "千丝之城"}
        s["npc;sold=227003"] = {"基尔克萨 <奇珍收集者>", "千丝之城"}
        s["npc;sold=231824"] = {"[Kari Bridgeblaster]", "安德麦"}
        s["npc;sold=243220"] = {"伊蕊莎·血星 <征服军需官>", "银月城"}
        s["npc;sold=248303"] = {"Zah'ran <[Delve Trinkets]>", "九号挖掘场"}
        s["npc;sold=256670"] = {"扎阿兰 <地下堡装备>", "学府骚动"}
        s["object;contained=413563"] = {"沉重之箱", "丝菌师洞穴"}
        s["object;contained=413590"] = {"丰裕宝匣", "恐惧陷坑"}
        s["object;contained=416265"] = {"失窃之箱", "恐惧陷坑"}
        s["object;contained=476068"] = {"[Papa's Prized Putter]", "安德麦"}
        s["object;contained=507768"] = {"丢弃的地精货币堆", "九号挖掘场"}
        s["object;contained=574407"] = {"挑战者的箱子", "魔导师平台"}
        s["object;contained=574409"] = {"挑战者的箱子", ""}
        s["object;contained=581922"] = {"隐秘财宝", "学府骚动"}
        s["object;contained=584514"] = {"丰裕宝匣", "学府骚动"}
        s["object;contained=584518"] = {"丰裕沉重之箱", "学府骚动"}
        s["object;contained=584519"] = {"沉重之箱", "学府骚动"}
        s["quest;reward=66119"] = {"红玉新生法池：拜荒者入侵", ""}
        s["quest;reward=78232"] = {"反复覆写", ""}
        s["quest;reward=78636"] = {"夺回矿坑", ""}
        s["quest;reward=79342"] = {"他的辞别", ""}
        s["quest;reward=83125"] = {"", "祖达萨"}
        s["quest;reward=86521"] = {"节点希纳斯：月蚀", ""}
        s["quest;reward=91009"] = {"牢固信息保全容器", "多恩诺嘉尔"}
        s["quest;reward=91694"] = {"虚空之痕竞技场：三人不成行", ""}
        s["quest;reward=91958"] = {"纳洛拉克的洞穴：未获宽恕", ""}
        s["quest;reward=93417"] = {"阿塔乌特克地窟：毒牙祭坛", ""}
        s["quest;reward=93651"] = {"夺目谷：光绽根须", ""}
        s["quest;reward=93933"] = {"守卫宝藏", ""}
        s["spell;created=1228945"] = {"殉难者的裹腕", "CRAFTING"}
        s["spell;created=1228950"] = {"信徒的流丝罩袍", "CRAFTING"}
        s["spell;created=1228984"] = {"奥纹护腕", "CRAFTING"}
        s["spell;created=1228985"] = {"奥纹披风", "CRAFTING"}
        s["spell;created=1228988"] = {"奥纹束带", "CRAFTING"}
        s["spell;created=1229648"] = {"血骑士的战剑", "CRAFTING"}
        s["spell;created=1229649"] = {"绽铸之爪", "CRAFTING"}
        s["spell;created=1229657"] = {"破法者的战刃", "CRAFTING"}
        s["spell;created=1229659"] = {"远行者的慈悲", "CRAFTING"}
        s["spell;created=1229662"] = {"破法者的护腕", "CRAFTING"}
        s["spell;created=1229875"] = {"以太流明腕带", "CRAFTING"}
        s["spell;created=1229877"] = {"以太流明腕铠", "CRAFTING"}
        s["spell;created=1230061"] = {"艾林哈籁灯笼", "CRAFTING"}
        s["spell;created=1230070"] = {"暗月统御：鲜血", "CRAFTING"}
        s["spell;created=1230071"] = {"暗月统御：腐烂", "CRAFTING"}
        s["spell;created=1230072"] = {"暗月统御：狩猎", "CRAFTING"}
        s["spell;created=1230073"] = {"暗月统御：虚空", "CRAFTING"}
        s["spell;created=1230479"] = {"神灵崇拜者的指环", "CRAFTING"}
        s["spell;created=1230485"] = {"精工辛多雷指环", "CRAFTING"}
        s["spell;created=1230486"] = {"精工辛多雷护符", "CRAFTING"}
        s["spell;created=1230487"] = {"艾泽拉斯祝福印戒", "CRAFTING"}
        s["spell;created=1230861"] = {"原始点金石", "CRAFTING"}
        s["spell;created=1230885"] = {"魔导师的炼金石", "CRAFTING"}
        s["spell;created=1237508"] = {"银月城特工的匿踪靴", "CRAFTING"}
        s["spell;created=1237509"] = {"银月城特工的裹手", "CRAFTING"}
        s["spell;created=1237513"] = {"银月城特工的多功能腰带", "CRAFTING"}
        s["spell;created=1237514"] = {"银月城特工的偏斜腕甲", "CRAFTING"}
        s["spell;created=1237518"] = {"世界照护者的根须便鞋", "CRAFTING"}
        s["spell;created=1237519"] = {"世界照护者的树皮腰扣", "CRAFTING"}
        s["spell;created=1237537"] = {"远行者的刀锋战靴", "CRAFTING"}
        s["spell;created=1237543"] = {"远行者的板层护腕", "CRAFTING"}
        s["spell;created=1249111"] = {"收到裹布", "CRAFTING"}
        s["spell;created=1253219"] = {"狩猎", ""}
        s["spell;created=1253220"] = {"虚空", ""}
        s["spell;created=1253221"] = {"鲜血", ""}
        s["spell;created=1253222"] = {"腐烂", ""}
        s["spell;created=237828"] = {"凡图斯符文：恶魔审判庭", ""}
        s["spell;created=239649"] = {"地狱火撞击", ""}
        s["spell;created=244572"] = {"召唤灵魂", ""}
        s["spell;created=244581"] = {"彗星冲撞", ""}
        s["spell;created=244609"] = {"召唤灵魂 - 鼓点", ""}
        s["spell;created=427185"] = {"阿加炼金石", "CRAFTING"}
        s["spell;created=435382"] = {"知己之玑", "CRAFTING"}
        s["spell;created=435384"] = {"土灵匠工之戒", "CRAFTING"}
        s["spell;created=435385"] = {"土灵匠工护符", "CRAFTING"}
        s["spell;created=441051"] = {"符烙胸甲", "CRAFTING"}
        s["spell;created=441052"] = {"符烙之靴", "CRAFTING"}
        s["spell;created=441053"] = {"符烙手套", "CRAFTING"}
        s["spell;created=441055"] = {"符烙裤子", "CRAFTING"}
        s["spell;created=441057"] = {"符烙腰带", "CRAFTING"}
        s["spell;created=441058"] = {"符烙束腕", "CRAFTING"}
        s["spell;created=441060"] = {"刻纹便鞋", "CRAFTING"}
        s["spell;created=441061"] = {"刻纹护手", "CRAFTING"}
        s["spell;created=441063"] = {"刻纹护腿", "CRAFTING"}
        s["spell;created=441065"] = {"刻纹腰链", "CRAFTING"}
        s["spell;created=441066"] = {"刻纹腕扣", "CRAFTING"}
        s["spell;created=444070"] = {"肾上腺素激涌腰带", "CRAFTING"}
        s["spell;created=444197"] = {"流浪者的火炬", "CRAFTING"}
        s["spell;created=444198"] = {"流浪者的精细腋杖", "CRAFTING"}
        s["spell;created=444199"] = {"流浪者的划界指挥棒", "CRAFTING"}
        s["spell;created=445355"] = {"光耀魔法节杖", "CRAFTING"}
        s["spell;created=446937"] = {"圣化便鞋", "CRAFTING"}
        s["spell;created=446938"] = {"圣化腕扣", "CRAFTING"}
        s["spell;created=446939"] = {"圣化腰索", "CRAFTING"}
        s["spell;created=446940"] = {"圣化披风", "CRAFTING"}
        s["spell;created=447314"] = {"勤勉聪慧激励器", "CRAFTING"}
        s["spell;created=447315"] = {"超频构想发生器", "CRAFTING"}
        s["spell;created=447352"] = {"P.0.W. x2型", "CRAFTING"}
        s["spell;created=450220"] = {"永铸战靴", "CRAFTING"}
        s["spell;created=450222"] = {"永铸重型腰带", "CRAFTING"}
        s["spell;created=450223"] = {"永铸防御者", "CRAFTING"}
        s["spell;created=450224"] = {"永铸之盔", "CRAFTING"}
        s["spell;created=450226"] = {"永铸腕甲", "CRAFTING"}
        s["spell;created=450229"] = {"永铸戳刺者", "CRAFTING"}
        s["spell;created=450230"] = {"永铸匕首", "CRAFTING"}
        s["spell;created=450231"] = {"永铸长剑", "CRAFTING"}
        s["spell;created=450232"] = {"永铸战刃", "CRAFTING"}
        s["spell;created=450234"] = {"永铸巨斧", "CRAFTING"}
        s["spell;created=450235"] = {"充能妖术剑", "CRAFTING"}
        s["spell;created=450237"] = {"充能碎面锤", "CRAFTING"}
        s["spell;created=450238"] = {"充能大剑", "CRAFTING"}
        s["spell;created=450239"] = {"充能长戟", "CRAFTING"}
        s["spell;created=450242"] = {"充能切斧", "CRAFTING"}
        s["spell;created=455391"] = {"盎溢", ""}
        s["spell;created=455392"] = {"共生", ""}
        s["spell;created=455393"] = {"光辉", ""}
        s["spell;created=455394"] = {"扬升", ""}
        s["spell;created=473400"] = {"施法重配置", "CRAFTING"}
    end

    function SpecBisTooltip:TranslationzhTW()
        s["item:contained=229129"] = {"一箱地下堡行者的宝藏", ""}
        s["item:contained=229354"] = {"阿加冒险者的宝箱", ""}
        s["item:contained=235639"] = {"干练冒险者的宝箱", ""}
        s["item:contained=238208"] = {"奶奶的峰时红利", ""}
        s["item:contained=262346"] = {"寻猎者的勇士宝箱", ""}
        s["npc;drop=122056"] = {"总督奈扎尔", "执政团之座"}
        s["npc;drop=122313"] = {"晋升者祖拉尔", "执政团之座"}
        s["npc;drop=122316"] = {"萨普瑞什 <影卫复仇军领主>", "执政团之座"}
        s["npc;drop=124729"] = {"鲁拉", "执政团之座"}
        s["npc;drop=128649"] = {"拜恩比吉中士", "围攻伯拉勒斯"}
        s["npc;drop=128650"] = {"“屠夫”血钩", "围攻伯拉勒斯"}
        s["npc;drop=128651"] = {"哈达尔·黑渊", "围攻伯拉勒斯"}
        s["npc;drop=128652"] = {"维克戈斯 <深渊魔王>", "围攻伯拉勒斯"}
        s["npc;drop=129208"] = {"恐怖船长洛克伍德", "围攻伯拉勒斯"}
        s["npc;drop=129214"] = {"投币式群体打击者", "暴富矿区！！"}
        s["npc;drop=129227"] = {"艾泽洛克", "暴富矿区！！"}
        s["npc;drop=129231"] = {"瑞克莎·流火", "暴富矿区！！"}
        s["npc;drop=131227"] = {"商业大亨拉兹敦克", "暴富矿区！！"}
        s["npc;drop=132713"] = {"商业大亨拉兹敦克", "暴富矿区！！"}
        s["npc;drop=133384"] = {"米利克萨", "塞塔里斯神庙"}
        s["npc;drop=133389"] = {"加瓦兹特", "塞塔里斯神庙"}
        s["npc;drop=133392"] = {"塞塔里斯的化身", "塞塔里斯神庙"}
        s["npc;drop=133944"] = {"阿斯匹克斯", "塞塔里斯神庙"}
        s["npc;drop=134993"] = {"殓尸者姆沁巴", "诸王之眠"}
        s["npc;drop=135322"] = {"黄金风蛇", "诸王之眠"}
        s["npc;drop=136160"] = {"达萨大王 <始皇>", "诸王之眠"}
        s["npc;drop=144244"] = {"白金拳手", "麦卡贡行动"}
        s["npc;drop=144246"] = {"狂犬K.U.-J.0.", "麦卡贡行动"}
        s["npc;drop=144248"] = {"首席机械师闪流", "麦卡贡行动"}
        s["npc;drop=150159"] = {"戈巴马克国王", "麦卡贡行动"}
        s["npc;drop=150222"] = {"冈克", "麦卡贡行动"}
        s["npc;drop=150397"] = {"麦卡贡国王", "麦卡贡行动"}
        s["npc;drop=152619"] = {"麦卡贡国王", "麦卡贡行动"}
        s["npc;drop=156827"] = {"艾谢朗", "赎罪大厅"}
        s["npc;drop=162309"] = {"库尔萨洛克", "伤逝剧场"}
        s["npc;drop=162317"] = {"斩血", "伤逝剧场"}
        s["npc;drop=162329"] = {"无堕者哈夫", "伤逝剧场"}
        s["npc;drop=162689"] = {"外科医生缝肉", "通灵战潮"}
        s["npc;drop=162691"] = {"凋骨", "通灵战潮"}
        s["npc;drop=162693"] = {"缚霜者纳尔佐", "通灵战潮"}
        s["npc;drop=163157"] = {"阿玛厄斯 <收割者>", "通灵战潮"}
        s["npc;drop=164185"] = {"艾谢朗", "赎罪大厅"}
        s["npc;drop=164218"] = {"宫务大臣", "赎罪大厅"}
        s["npc;drop=164451"] = {"斩首者德茜雅", "伤逝剧场"}
        s["npc;drop=164501"] = {"唤雾者", "塞兹仙林的迷雾"}
        s["npc;drop=164517"] = {"特雷德奥瓦", "塞兹仙林的迷雾"}
        s["npc;drop=164567"] = {"英格拉·马洛克", "塞兹仙林的迷雾"}
        s["npc;drop=165408"] = {"哈尔吉亚斯 <罪污巨像>", "赎罪大厅"}
        s["npc;drop=165410"] = {"高阶裁决官阿丽兹", "赎罪大厅"}
        s["npc;drop=165946"] = {"无尽女皇莫德蕾莎", "伤逝剧场"}
        s["npc;drop=175546"] = {"时空船长钩尾", "塔扎维什，帷纱集市"}
        s["npc;drop=175616"] = {"佐·菲克斯 <哨卫>", "塔扎维什，帷纱集市"}
        s["npc;drop=175646"] = {"P.O.S.T.总管", "塔扎维什，帷纱集市"}
        s["npc;drop=175663"] = {"希尔布兰德 <守护者之剑>", "塔扎维什，帷纱集市"}
        s["npc;drop=175806"] = {"索·阿兹密", "塔扎维什，帷纱集市"}
        s["npc;drop=176556"] = {"阿尔克鲁克斯 <暴食者>", "塔扎维什，帷纱集市"}
        s["npc;drop=176563"] = {"佐·格伦", "塔扎维什，帷纱集市"}
        s["npc;drop=176705"] = {"雯扎·金线", "塔扎维什，帷纱集市"}
        s["npc;drop=177269"] = {"索·莉亚 <索财团>", "塔扎维什，帷纱集市"}
        s["npc;drop=188252"] = {"梅莉杜莎·寒妆 <注能专家>", "红玉新生法池"}
        s["npc;drop=189232"] = {"柯姬雅·焰蹄", "红玉新生法池"}
        s["npc;drop=190485"] = {"厄克哈特·风脉", "红玉新生法池"}
        s["npc;drop=190609"] = {"多拉苟萨的回响 <首席教师>", "艾杰斯亚学院"}
        s["npc;drop=191736"] = {"克罗兹", "艾杰斯亚学院"}
        s["npc;drop=194181"] = {"维克萨姆斯", "艾杰斯亚学院"}
        s["npc;drop=196482"] = {"茂林古树", "艾杰斯亚学院"}
        s["npc;drop=202318"] = {"响应战队守护者", "查拉雷克洞窟"}
        s["npc;drop=203355"] = {"雷卡尔上尉", "查拉雷克洞窟"}
        s["npc;drop=207205"] = {"雷卫戈伦", "驭雷栖巢"}
        s["npc;drop=207207"] = {"虚空石畸体", "驭雷栖巢"}
        s["npc;drop=207939"] = {"布朗派克男爵", "圣焰隐修院"}
        s["npc;drop=207940"] = {"隐修院长穆普雷", "圣焰隐修院"}
        s["npc;drop=207946"] = {"戴尔克莱上尉", "圣焰隐修院"}
        s["npc;drop=208478"] = {"沃尔科罗斯", "阿梅达希尔，梦境之愿"}
        s["npc;drop=208743"] = {"布雷炙孔", "暗焰裂口"}
        s["npc;drop=208745"] = {"蜡烛之王", "暗焰裂口"}
        s["npc;drop=209230"] = {"凯里欧斯", "驭雷栖巢"}
        s["npc;drop=210108"] = {"E.D.N.A.", "矶石宝库"}
        s["npc;drop=210153"] = {"老蜡须", "暗焰裂口"}
        s["npc;drop=210156"] = {"斯卡莫拉克", "矶石宝库"}
        s["npc;drop=210267"] = {"艾帕", "燧酿酒庄"}
        s["npc;drop=210271"] = {"酿造大师阿德里尔", "燧酿酒庄"}
        s["npc;drop=210797"] = {"黑暗之主", "暗焰裂口"}
        s["npc;drop=211087"] = {"代言人夏多克朗", "破晨号"}
        s["npc;drop=211089"] = {"阿努布伊卡基", "破晨号"}
        s["npc;drop=213119"] = {"虚空代言人艾里克", "矶石宝库"}
        s["npc;drop=213179"] = {"阿瓦诺克斯", "艾拉-卡拉，回响之城"}
        s["npc;drop=213217"] = {"代言人布洛克", "矶石宝库"}
        s["npc;drop=214502"] = {"血缚恐魔", "尼鲁巴尔王宫"}
        s["npc;drop=214506"] = {"虫巢扭曲者欧维纳克斯", "尼鲁巴尔王宫"}
        s["npc;drop=214650"] = {"鲁拉", "艾瑞达斯"}
        s["npc;drop=214661"] = {"戈尔迪·底爵 <蜂老板>", "燧酿酒庄"}
        s["npc;drop=215405"] = {"阿努布泽克特 <虫群卫士>", "艾拉-卡拉，回响之城"}
        s["npc;drop=215407"] = {"收割者吉卡塔尔", "艾拉-卡拉，回响之城"}
        s["npc;drop=215657"] = {"噬灭者乌格拉克斯", "尼鲁巴尔王宫"}
        s["npc;drop=216320"] = {"凝结聚合体", "千丝之城"}
        s["npc;drop=216619"] = {"演说者基克斯威兹克 <第五帛丝>", "千丝之城"}
        s["npc;drop=216648"] = {"恩克斯 <女王之牙>", "千丝之城"}
        s["npc;drop=216658"] = {"大捻接师艾佐", "千丝之城"}
        s["npc;drop=217489"] = {"阿努巴拉什 <千疤者>", "尼鲁巴尔王宫"}
        s["npc;drop=218002"] = {"本克·鸣蜂 <养蜂人>", "燧酿酒庄"}
        s["npc;drop=219778"] = {"安苏雷克女王", "尼鲁巴尔王宫"}
        s["npc;drop=219853"] = {"席克兰 <苏雷吉队长>", "尼鲁巴尔王宫"}
        s["npc;drop=223779"] = {"Anub'arash <[The Thousand Scars]>", "尼鲁巴尔王宫"}
        s["npc;drop=223839"] = {"女王亲卫杰扎", "尼鲁巴尔王宫"}
        s["npc;drop=224552"] = {"拉夏南", "尼鲁巴尔王宫"}
        s["npc;drop=225821"] = {"[The Geargrinder]", "解放安德麦"}
        s["npc;drop=226305"] = {"[Emperor Dagran Thaurissan]", "黑石深渊"}
        s["npc;drop=226306"] = {"[Golem Lord Argelmach]", "黑石深渊"}
        s["npc;drop=226315"] = {"[Lord Roccor]", "黑石深渊"}
        s["npc;drop=226396"] = {"[Swampface]", "水闸行动"}
        s["npc;drop=226398"] = {"[Big M.O.M.M.A.]", "水闸行动"}
        s["npc;drop=226403"] = {"[Keeza Quickfuse]", "水闸行动"}
        s["npc;drop=226404"] = {"吉泽尔·超震", "水闸行动"}
        s["npc;drop=228458"] = {"[One-Armed Bandit]", "解放安德麦"}
        s["npc;drop=228470"] = {"节点女亲王凯威扎", "尼鲁巴尔王宫"}
        s["npc;drop=228652"] = {"[Rik Reverb]", "解放安德麦"}
        s["npc;drop=229181"] = {"[Flarendo]", "解放安德麦"}
        s["npc;drop=229284"] = {"古克·轰犬 <污液贩子>", "解放安德麦"}
        s["npc;drop=229288"] = {"喷焰大王 <弗莱兰多的经理>", "解放安德麦"}
        s["npc;drop=229953"] = {"[Mug'Zee]", "解放安德麦"}
        s["npc;drop=229992"] = {"石笋纳罗克", "海妖岛"}
        s["npc;drop=230322"] = {"[Stix Bunkjunker]", "解放安德麦"}
        s["npc;drop=230583"] = {"[Sprocketmonger Lockenstock]", "解放安德麦"}
        s["npc;drop=230800"] = {"[Slugger the Smart]", "安德麦"}
        s["npc;drop=230828"] = {"[Chief Foreman Gutso]", "安德麦"}
        s["npc;drop=230934"] = {"[Ratspit]", "安德麦"}
        s["npc;drop=230946"] = {"[V.V. Goosworth]", "安德麦"}
        s["npc;drop=231310"] = {"暗索沉淀剂", "安德麦"}
        s["npc;drop=231606"] = {"烬晓", "风行者之塔"}
        s["npc;drop=231626"] = {"卡莉斯", "风行者之塔"}
        s["npc;drop=231631"] = {"指挥官克罗鲁科 <旧部落>", "风行者之塔"}
        s["npc;drop=231636"] = {"无眠之心", "风行者之塔"}
        s["npc;drop=231863"] = {"瑟拉奈尔·日鞭", "魔导师平台"}
        s["npc;drop=231864"] = {"吉美尔鲁斯", "魔导师平台"}
        s["npc;drop=231865"] = {"迪詹崔乌斯", "魔导师平台"}
        s["npc;drop=231981"] = {"沙海之喉", "卡雷什"}
        s["npc;drop=233814"] = {"集能哨兵", "法力熔炉：欧米伽"}
        s["npc;drop=233815"] = {"卢米萨尔", "法力熔炉：欧米伽"}
        s["npc;drop=233816"] = {"缚魂者娜欣达利", "法力熔炉：欧米伽"}
        s["npc;drop=233824"] = {"迪门修斯", "法力熔炉：欧米伽"}
        s["npc;drop=234647"] = {"歼灭者萨祖克斯 <利希尔的守护者>", "密谋小径"}
        s["npc;drop=234649"] = {"赞恩·刃悲", "密谋小径"}
        s["npc;drop=234845"] = {"司萨阿布斯 <心智搅荡者>", "卡雷什"}
        s["npc;drop=234893"] = {"阿兹希卡", "奥尔达尼生态圆顶"}
        s["npc;drop=234933"] = {"塔尔·巴特 <无情者>", "奥尔达尼生态圆顶"}
        s["npc;drop=235853"] = {"界门观察者", "法力熔炉：欧米伽"}
        s["npc;drop=237415"] = {"利希尔·烬怒", "密谋小径"}
        s["npc;drop=237661"] = {"阿达拉斯·暮焰", "法力熔炉：欧米伽"}
        s["npc;drop=237763"] = {"节点之王萨哈达尔", "法力熔炉：欧米伽"}
        s["npc;drop=237861"] = {"Fractillus <[The Shatterer]>", "法力熔炉：欧米伽"}
        s["npc;drop=238887"] = {"塔兹拉尔", "虚空之痕竞技场"}
        s["npc;drop=239008"] = {"阿特洛苏斯", "虚空之痕竞技场"}
        s["npc;drop=239454"] = {"暗法师扎杜斯", "法力熔炉：欧米伽"}
        s["npc;drop=240432"] = {"陨落之王萨哈达尔", "虚影尖塔"}
        s["npc;drop=240434"] = {"弗拉希乌斯", "虚影尖塔"}
        s["npc;drop=240435"] = {"元首阿福扎恩", "虚影尖塔"}
        s["npc;drop=241526"] = {"[Chrome King Gallywix]", "解放安德麦"}
        s["npc;drop=241546"] = {"洛萨克森 <高阶指挥官>", ""}
        s["npc;drop=242031"] = {"刺鳍 <最致命的猎物>", "祖阿曼"}
        s["npc;drop=242056"] = {"威厄高尔", "虚影尖塔"}
        s["npc;drop=242255"] = {"[Geezle Gigazap]", "水闸行动"}
        s["npc;drop=24239"] = {"妖术领主玛拉卡斯", "烈毒之渊"}
        s["npc;drop=243028"] = {"梅提克", "夺目谷"}
        s["npc;drop=244752"] = {"节点女亲王凯威扎", "虚空之锋庇护所"}
        s["npc;drop=244761"] = {"Alleria Windrunner", "虚影尖塔"}
        s["npc;drop=244762"] = {"鲁阿夏尔", "永歌森林"}
        s["npc;drop=244887"] = {"圣光猎手伊库兹", "夺目谷"}
        s["npc;drop=245044"] = {"暮夜蜂", "虚影风暴"}
        s["npc;drop=245912"] = {"护光者鲁伊亚", "夺目谷"}
        s["npc;drop=246633"] = {"疲惫的陆行鸟", "永歌森林"}
        s["npc;drop=246729"] = {"圣光燃烬 <贝洛朗的子嗣>", "奎尔丹纳斯岛"}
        s["npc;drop=247283"] = {"Soul-Scribe", ""}
        s["npc;drop=247570"] = {"姆罗金", "迈萨拉洞窟"}
        s["npc;drop=247676"] = {"兹欧凯特 <瘤节光耀之子>", "夺目谷"}
        s["npc;drop=247976"] = {"盗猎者拉维科 <邪枝部族>", "祖阿曼"}
        s["npc;drop=247989"] = {"熔炉编织者阿拉兹", "法力熔炉：欧米伽"}
        s["npc;drop=248015"] = {"煞戎努斯", "虚空之痕竞技场"}
        s["npc;drop=248595"] = {"沃达扎", "迈萨拉洞窟"}
        s["npc;drop=248605"] = {"拉克图尔 <聚魂之器>", "迈萨拉洞窟"}
        s["npc;drop=248710"] = {"The Hoardmonger <[Spiritpaw Tribe]>", "纳洛拉克的洞穴"}
        s["npc;drop=248823"] = {"黑核", "虚影风暴"}
        s["npc;drop=249844"] = {"海蜂蜇 <飘浮的死神>", "哈籁恩达尔"}
        s["npc;drop=250086"] = {"断株 <哈籁恩达尔的魔王>", "哈籁恩达尔"}
        s["npc;drop=250358"] = {"撼世者安努勒斯", "哈籁恩达尔"}
        s["npc;drop=250589"] = {"战争牧师瑟恩", "虚影尖塔"}
        s["npc;drop=252458"] = {"凯斯媞亚·魔力之心", "密谋小径"}
        s["npc;drop=252959"] = {"尼姆瑞莎·唤波者", "潮缚石窟"}
        s["npc;drop=254176"] = {"腐沼", "孢陨幽境"}
        s["npc;drop=254227"] = {"核心守卫奈萨拉", ""}
        s["npc;drop=256116"] = {"奇美鲁斯 <未梦之神>", "梦境裂隙"}
        s["npc;drop=257347"] = {"斯索拉克", "烈毒之渊"}
        s["npc;drop=257361"] = {"维克苏尔", "烈毒之渊"}
        s["npc;drop=257906"] = {"钱眼斯卡利", "盘卷蛇岛"}
        s["npc;drop=258557"] = {"乌拉特克之息", "烈毒之渊"}
        s["npc;drop=258877"] = {"纳洛拉克 <战争之神>", "纳洛拉克的洞穴"}
        s["npc;drop=258916"] = {"加赛格 <船体撕裂者>", "盘卷蛇岛"}
        s["npc;drop=259445"] = {"拉维", "毒牙祭坛"}
        s["npc;drop=259446"] = {"扭缠盘蛇", "毒牙祭坛"}
        s["npc;drop=259447"] = {"祖尔加", "毒牙祭坛"}
        s["npc;drop=260905"] = {"燃烧剧毒", "烈毒之渊"}
        s["npc;drop=261053"] = {"寒冬哨兵", "纳洛拉克的洞穴"}
        s["npc;drop=263456"] = {"锐牙者萨里斯", ""}
        s["npc;drop=264854"] = {"掠夺者法锡克", "盘卷蛇岛"}
        s["npc;drop=267077"] = {"莫尔扎希", "烈毒之渊"}
        s["npc;drop=268090"] = {"被遗忘的卡里扎", "盘卷蛇岛"}
        s["npc;drop=268956"] = {"乌拉特克", "烈毒之渊"}
        s["npc;drop=269808"] = {"征服者阿卡阿里", "诸王之眠"}
        s["npc;drop=271337"] = {"Echo of Jawae <[Soulcoiler Cult]>", "烈毒之渊"}
        s["npc;drop=36476"] = {"伊克 <科瑞克的奴仆>", "萨隆矿坑"}
        s["npc;drop=36494"] = {"熔炉之主加弗斯特", "萨隆矿坑"}
        s["npc;drop=36658"] = {"天灾领主泰兰努斯", "萨隆矿坑"}
        s["npc;drop=39625"] = {"乌比斯将军 <死亡之翼的仆从>", "格瑞姆巴托"}
        s["npc;drop=40177"] = {"铸炉之主索朗格斯", "格瑞姆巴托"}
        s["npc;drop=40319"] = {"达加·燃影者 <暮光之锤信使>", "格瑞姆巴托"}
        s["npc;drop=40484"] = {"埃鲁达克 <地狱公爵>", "格瑞姆巴托"}
        s["npc;drop=75452"] = {"骨喉", "影月墓地"}
        s["npc;drop=75964"] = {"兰吉特 <四风大师>", "通天峰"}
        s["npc;drop=76141"] = {"阿拉卡纳斯 <炎阳构装体>", "通天峰"}
        s["npc;drop=76266"] = {"高阶贤者维里克斯", "通天峰"}
        s["npc;drop=76379"] = {"鲁克兰", "通天峰"}
        s["npc;sold=219222"] = {"拉兰迪 <征服军需官>", "多恩诺嘉尔"}
        s["npc;sold=224270"] = {"伊普克萨", "千丝之城"}
        s["npc;sold=227003"] = {"基尔克萨 <奇珍收集者>", "千丝之城"}
        s["npc;sold=231824"] = {"[Kari Bridgeblaster]", "安德麦"}
        s["npc;sold=243220"] = {"伊蕊莎·血星 <征服军需官>", "银月城"}
        s["npc;sold=248303"] = {"Zah'ran <[Delve Trinkets]>", "九号挖掘场"}
        s["npc;sold=256670"] = {"扎阿兰 <地下堡装备>", "学府骚动"}
        s["object;contained=413563"] = {"沉重之箱", "丝菌师洞穴"}
        s["object;contained=413590"] = {"丰裕宝匣", "恐惧陷坑"}
        s["object;contained=416265"] = {"失窃之箱", "恐惧陷坑"}
        s["object;contained=476068"] = {"[Papa's Prized Putter]", "安德麦"}
        s["object;contained=507768"] = {"丢弃的地精货币堆", "九号挖掘场"}
        s["object;contained=574407"] = {"挑战者的箱子", "魔导师平台"}
        s["object;contained=574409"] = {"挑战者的箱子", ""}
        s["object;contained=581922"] = {"隐秘财宝", "学府骚动"}
        s["object;contained=584514"] = {"丰裕宝匣", "学府骚动"}
        s["object;contained=584518"] = {"丰裕沉重之箱", "学府骚动"}
        s["object;contained=584519"] = {"沉重之箱", "学府骚动"}
        s["quest;reward=66119"] = {"红玉新生法池：拜荒者入侵", ""}
        s["quest;reward=78232"] = {"反复覆写", ""}
        s["quest;reward=78636"] = {"夺回矿坑", ""}
        s["quest;reward=79342"] = {"他的辞别", ""}
        s["quest;reward=83125"] = {"", "祖达萨"}
        s["quest;reward=86521"] = {"节点希纳斯：月蚀", ""}
        s["quest;reward=91009"] = {"牢固信息保全容器", "多恩诺嘉尔"}
        s["quest;reward=91694"] = {"虚空之痕竞技场：三人不成行", ""}
        s["quest;reward=91958"] = {"纳洛拉克的洞穴：未获宽恕", ""}
        s["quest;reward=93417"] = {"阿塔乌特克地窟：毒牙祭坛", ""}
        s["quest;reward=93651"] = {"夺目谷：光绽根须", ""}
        s["quest;reward=93933"] = {"守卫宝藏", ""}
        s["spell;created=1228945"] = {"殉难者的裹腕", "CRAFTING"}
        s["spell;created=1228950"] = {"信徒的流丝罩袍", "CRAFTING"}
        s["spell;created=1228984"] = {"奥纹护腕", "CRAFTING"}
        s["spell;created=1228985"] = {"奥纹披风", "CRAFTING"}
        s["spell;created=1228988"] = {"奥纹束带", "CRAFTING"}
        s["spell;created=1229648"] = {"血骑士的战剑", "CRAFTING"}
        s["spell;created=1229649"] = {"绽铸之爪", "CRAFTING"}
        s["spell;created=1229657"] = {"破法者的战刃", "CRAFTING"}
        s["spell;created=1229659"] = {"远行者的慈悲", "CRAFTING"}
        s["spell;created=1229662"] = {"破法者的护腕", "CRAFTING"}
        s["spell;created=1229875"] = {"以太流明腕带", "CRAFTING"}
        s["spell;created=1229877"] = {"以太流明腕铠", "CRAFTING"}
        s["spell;created=1230061"] = {"艾林哈籁灯笼", "CRAFTING"}
        s["spell;created=1230070"] = {"暗月统御：鲜血", "CRAFTING"}
        s["spell;created=1230071"] = {"暗月统御：腐烂", "CRAFTING"}
        s["spell;created=1230072"] = {"暗月统御：狩猎", "CRAFTING"}
        s["spell;created=1230073"] = {"暗月统御：虚空", "CRAFTING"}
        s["spell;created=1230479"] = {"神灵崇拜者的指环", "CRAFTING"}
        s["spell;created=1230485"] = {"精工辛多雷指环", "CRAFTING"}
        s["spell;created=1230486"] = {"精工辛多雷护符", "CRAFTING"}
        s["spell;created=1230487"] = {"艾泽拉斯祝福印戒", "CRAFTING"}
        s["spell;created=1230861"] = {"原始点金石", "CRAFTING"}
        s["spell;created=1230885"] = {"魔导师的炼金石", "CRAFTING"}
        s["spell;created=1237508"] = {"银月城特工的匿踪靴", "CRAFTING"}
        s["spell;created=1237509"] = {"银月城特工的裹手", "CRAFTING"}
        s["spell;created=1237513"] = {"银月城特工的多功能腰带", "CRAFTING"}
        s["spell;created=1237514"] = {"银月城特工的偏斜腕甲", "CRAFTING"}
        s["spell;created=1237518"] = {"世界照护者的根须便鞋", "CRAFTING"}
        s["spell;created=1237519"] = {"世界照护者的树皮腰扣", "CRAFTING"}
        s["spell;created=1237537"] = {"远行者的刀锋战靴", "CRAFTING"}
        s["spell;created=1237543"] = {"远行者的板层护腕", "CRAFTING"}
        s["spell;created=1249111"] = {"收到裹布", "CRAFTING"}
        s["spell;created=1253219"] = {"狩猎", ""}
        s["spell;created=1253220"] = {"虚空", ""}
        s["spell;created=1253221"] = {"鲜血", ""}
        s["spell;created=1253222"] = {"腐烂", ""}
        s["spell;created=237828"] = {"凡图斯符文：恶魔审判庭", ""}
        s["spell;created=239649"] = {"地狱火撞击", ""}
        s["spell;created=244572"] = {"召唤灵魂", ""}
        s["spell;created=244581"] = {"彗星冲撞", ""}
        s["spell;created=244609"] = {"召唤灵魂 - 鼓点", ""}
        s["spell;created=427185"] = {"阿加炼金石", "CRAFTING"}
        s["spell;created=435382"] = {"知己之玑", "CRAFTING"}
        s["spell;created=435384"] = {"土灵匠工之戒", "CRAFTING"}
        s["spell;created=435385"] = {"土灵匠工护符", "CRAFTING"}
        s["spell;created=441051"] = {"符烙胸甲", "CRAFTING"}
        s["spell;created=441052"] = {"符烙之靴", "CRAFTING"}
        s["spell;created=441053"] = {"符烙手套", "CRAFTING"}
        s["spell;created=441055"] = {"符烙裤子", "CRAFTING"}
        s["spell;created=441057"] = {"符烙腰带", "CRAFTING"}
        s["spell;created=441058"] = {"符烙束腕", "CRAFTING"}
        s["spell;created=441060"] = {"刻纹便鞋", "CRAFTING"}
        s["spell;created=441061"] = {"刻纹护手", "CRAFTING"}
        s["spell;created=441063"] = {"刻纹护腿", "CRAFTING"}
        s["spell;created=441065"] = {"刻纹腰链", "CRAFTING"}
        s["spell;created=441066"] = {"刻纹腕扣", "CRAFTING"}
        s["spell;created=444070"] = {"肾上腺素激涌腰带", "CRAFTING"}
        s["spell;created=444197"] = {"流浪者的火炬", "CRAFTING"}
        s["spell;created=444198"] = {"流浪者的精细腋杖", "CRAFTING"}
        s["spell;created=444199"] = {"流浪者的划界指挥棒", "CRAFTING"}
        s["spell;created=445355"] = {"光耀魔法节杖", "CRAFTING"}
        s["spell;created=446937"] = {"圣化便鞋", "CRAFTING"}
        s["spell;created=446938"] = {"圣化腕扣", "CRAFTING"}
        s["spell;created=446939"] = {"圣化腰索", "CRAFTING"}
        s["spell;created=446940"] = {"圣化披风", "CRAFTING"}
        s["spell;created=447314"] = {"勤勉聪慧激励器", "CRAFTING"}
        s["spell;created=447315"] = {"超频构想发生器", "CRAFTING"}
        s["spell;created=447352"] = {"P.0.W. x2型", "CRAFTING"}
        s["spell;created=450220"] = {"永铸战靴", "CRAFTING"}
        s["spell;created=450222"] = {"永铸重型腰带", "CRAFTING"}
        s["spell;created=450223"] = {"永铸防御者", "CRAFTING"}
        s["spell;created=450224"] = {"永铸之盔", "CRAFTING"}
        s["spell;created=450226"] = {"永铸腕甲", "CRAFTING"}
        s["spell;created=450229"] = {"永铸戳刺者", "CRAFTING"}
        s["spell;created=450230"] = {"永铸匕首", "CRAFTING"}
        s["spell;created=450231"] = {"永铸长剑", "CRAFTING"}
        s["spell;created=450232"] = {"永铸战刃", "CRAFTING"}
        s["spell;created=450234"] = {"永铸巨斧", "CRAFTING"}
        s["spell;created=450235"] = {"充能妖术剑", "CRAFTING"}
        s["spell;created=450237"] = {"充能碎面锤", "CRAFTING"}
        s["spell;created=450238"] = {"充能大剑", "CRAFTING"}
        s["spell;created=450239"] = {"充能长戟", "CRAFTING"}
        s["spell;created=450242"] = {"充能切斧", "CRAFTING"}
        s["spell;created=455391"] = {"盎溢", ""}
        s["spell;created=455392"] = {"共生", ""}
        s["spell;created=455393"] = {"光辉", ""}
        s["spell;created=455394"] = {"扬升", ""}
        s["spell;created=473400"] = {"施法重配置", "CRAFTING"}
    end
end
