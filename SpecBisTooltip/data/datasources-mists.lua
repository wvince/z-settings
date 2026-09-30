-- By D4KiR
local _, SpecBisTooltip = ...
local s = {}
if SpecBisTooltip:GetBisPool() == "MISTS" then
    function SpecBisTooltip:GetTranslationMap()
        return s
    end
end

-- SOURCE FROM: 10.09.2026
if SpecBisTooltip:GetBisPool() == "MISTS" then
    function SpecBisTooltip:TranslationenUS()
        s["npc;drop=52571"] = {"Majordomo Staghelm <Archdruid of the Flame>", "Firelands"}
        s["npc;drop=53879"] = {"Deathwing <The Destroyer>", "Dragon Soul"}
        s["npc;drop=55265"] = {"Morchok", "Dragon Soul"}
        s["npc;drop=55294"] = {"Ultraxion", "Dragon Soul"}
        s["npc;drop=56427"] = {"Warmaster Blackhorn", "Dragon Soul"}
        s["npc;drop=59080"] = {"Darkmaster Gandling", "Scholomance"}
        s["npc;drop=60009"] = {"Feng the Accursed <Keeper of Champion Spirits>", "Mogu'shan Vaults"}
        s["npc;drop=60043"] = {"Jade Guardian", "Mogu'shan Vaults"}
        s["npc;drop=60051"] = {"Cobalt Guardian", "Mogu'shan Vaults"}
        s["npc;drop=60143"] = {"Gara'jal the Spiritbinder", "Mogu'shan Vaults"}
        s["npc;drop=60399"] = {"Qin-xi <Emperor's Closed Fist>", "Mogu'shan Vaults"}
        s["npc;drop=60400"] = {"Jan-xi <Emperor's Open Hand>", "Mogu'shan Vaults"}
        s["npc;drop=60410"] = {"Elegon", "Mogu'shan Vaults"}
        s["npc;drop=60583"] = {"Protector Kaolan", "Terrace of Endless Spring"}
        s["npc;drop=60701"] = {"Zian of the Endless Shadow <Sorcerer King>", "Mogu'shan Vaults"}
        s["npc;drop=60999"] = {"Sha of Fear", "Terrace of Endless Spring"}
        s["npc;drop=62397"] = {"Wind Lord Mel'jarak", "Heart of Fear"}
        s["npc;drop=62442"] = {"Tsulong", "Terrace of Endless Spring"}
        s["npc;drop=62511"] = {"Amber-Shaper Un'sok", "Heart of Fear"}
        s["npc;drop=62543"] = {"Blade Lord Ta'yak", "Heart of Fear"}
        s["npc;drop=62837"] = {"Grand Empress Shek'zeer", "Heart of Fear"}
        s["npc;drop=62980"] = {"Imperial Vizier Zor'lok <Voice of the Empress>", "Heart of Fear"}
        s["npc;drop=62983"] = {"Lei Shi", "Terrace of Endless Spring"}
        s["npc;drop=63191"] = {"Garalon", "Heart of Fear"}
        s["npc;drop=64340"] = {"Instructor Maltik <Keeper of Unseen Strike>", "Heart of Fear"}
        s["npc;drop=67977"] = {"Tortos", "Throne of Thunder"}
        s["npc;drop=68397"] = {"Lei Shen <The Thunder King>", "Throne of Thunder"}
        s["npc;drop=71153"] = {"Hisek the Swarmkeeper", "Siege of Orgrimmar"}
        s["npc;drop=71161"] = {"Kil'ruk the Wind-Reaver", "Siege of Orgrimmar"}
        s["npc;drop=71454"] = {"Malkorok", "Siege of Orgrimmar"}
        s["npc;drop=71466"] = {"Iron Juggernaut", "Siege of Orgrimmar"}
        s["npc;drop=71479"] = {"He Softfoot", "Siege of Orgrimmar"}
        s["npc;drop=71480"] = {"Sun Tenderheart", "Siege of Orgrimmar"}
        s["npc;drop=71504"] = {"Siegecrafter Blackfuse <Blackfuse Company>", "Siege of Orgrimmar"}
        s["npc;drop=71515"] = {"General Nazgrim", "Siege of Orgrimmar"}
        s["npc;drop=71529"] = {"Thok the Bloodthirsty", "Siege of Orgrimmar"}
        s["npc;drop=71543"] = {"Immerseus <Tears of the Vale>", "Siege of Orgrimmar"}
        s["npc;drop=71734"] = {"Sha of Pride", "Siege of Orgrimmar"}
        s["npc;drop=71858"] = {"Wavebinder Kardris", "Siege of Orgrimmar"}
        s["npc;drop=71859"] = {"Earthbreaker Haromm", "Siege of Orgrimmar"}
        s["npc;drop=71865"] = {"Garrosh Hellscream <Warchief>", "Siege of Orgrimmar"}
        s["npc;drop=71889"] = {"Secured Stockpile of Pandaren Spoils", "Siege of Orgrimmar"}
        s["npc;drop=71965"] = {"Norushen", "Siege of Orgrimmar"}
        s["npc;drop=72249"] = {"Galakras <The Last Brood of Galakrond>", "Siege of Orgrimmar"}
        s["npc;drop=72276"] = {"Amalgam of Corruption", "Siege of Orgrimmar"}
        s["npc;sold=44245"] = {"Faldren Tillsdale <Valor Quartermaster>", "Stormwind City"}
        s["npc;sold=59908"] = {"Jaluu the Generous <The Golden Lotus Quartermaster>", "Vale of Eternal Blossoms"}
        s["npc;sold=64606"] = {"Commander Oxheart <Valor Quartermaster>", "Townlong Steppes"}
        s["npc;sold=69060"] = {"Tuskripper Grukna <Dominance Offensive Quartermaster>", "Krasarang Wilds"}
        s["npc;sold=70346"] = {"Ao Pye <Shado-Pan Assault Quartermaster>", "Townlong Steppes"}
        s["npc;sold=74019"] = {"Tu'aho Pathcutter <Heroic Vendor>", "Shrine of Two Moons"}
        s["npc;sold=74027"] = {"Lorry Warmheart <Heroic Vendor>", "Shrine of Seven Stars"}
        s["object;contained=221740"] = {"Vault of Forbidden Treasures", "Siege of Orgrimmar"}
        s["object;contained=221742"] = {"Vault of Forbidden Treasures", "Siege of Orgrimmar"}
        s["object;contained=222750"] = {"Unlocked Stockpile of Pandaren Spoils", "Siege of Orgrimmar"}
        s["object;contained=222752"] = {"Unlocked Stockpile of Pandaren Spoils", "Siege of Orgrimmar"}
        s["object;contained=223237"] = {"Tears of the Vale", "Siege of Orgrimmar"}
        s["object;contained=223238"] = {"Tears of the Vale", "Siege of Orgrimmar"}
        s["quest;reward=30449"] = {"Darkmoon Crane Deck", "Elwynn Forest"}
        s["quest;reward=30450"] = {"Darkmoon Ox Deck", "Elwynn Forest"}
        s["quest;reward=30451"] = {"Darkmoon Serpent Deck", "Elwynn Forest"}
        s["quest;reward=30452"] = {"Darkmoon Tiger Deck", "Elwynn Forest"}
        s["quest;reward=31612"] = {"Shadow of the Empire", "Dread Wastes"}
        s["spell;created=146560"] = {"Cloak Transformation Spell 01", ""}
        s["spell;created=146562"] = {"Cloak Transformation Spell 02", ""}
        s["spell;created=146563"] = {"Cloak Transformation Spell 03", ""}
        s["spell;created=146564"] = {"Cloak Transformation Spell 04", ""}
        s["spell;created=146565"] = {"Cloak Transformation Spell 05", ""}
        s["spell;created=146566"] = {"Cloak Transformation Spell 06", ""}
    end

    function SpecBisTooltip:TranslationdeDE()
        s["npc;drop=52571"] = {"Majordomus Hirschhaupt <Erzdruide der Flamme>", "Feuerlande"}
        s["npc;drop=53879"] = {"Todesschwinge <Der Zerstörer>", "Drachenseele"}
        s["npc;drop=56427"] = {"Kriegsmeister Schwarzhorn", "Drachenseele"}
        s["npc;drop=59080"] = {"Dunkelmeister Gandling", "Scholomance"}
        s["npc;drop=60009"] = {"Feng der Verfluchte <Hüter der Champion-Geister>", "Mogu'shangewölbe"}
        s["npc;drop=60043"] = {"Jadewächter", "Mogu'shangewölbe"}
        s["npc;drop=60051"] = {"Kobaltwächter", "Mogu'shangewölbe"}
        s["npc;drop=60143"] = {"Gara'jal der Geisterbinder", "Mogu'shangewölbe"}
        s["npc;drop=60399"] = {"Qin-xi <Geschlossene Faust des Kaisers>", "Mogu'shangewölbe"}
        s["npc;drop=60400"] = {"Jan-xi <Offene Hand des Kaisers>", "Mogu'shangewölbe"}
        s["npc;drop=60583"] = {"Beschützer Kaolan", "Terrasse des Endlosen Frühlings"}
        s["npc;drop=60701"] = {"Zian des endlosen Schattens <Zaubererkönig>", "Mogu'shangewölbe"}
        s["npc;drop=60999"] = {"Sha der Angst", "Terrasse des Endlosen Frühlings"}
        s["npc;drop=62397"] = {"Windfürst Mel'jarak", "Das Herz der Angst"}
        s["npc;drop=62511"] = {"Bernformer Un'sok", "Das Herz der Angst"}
        s["npc;drop=62543"] = {"Klingenfürst Ta'yak", "Das Herz der Angst"}
        s["npc;drop=62837"] = {"Großkaiserin Shek'zeer", "Das Herz der Angst"}
        s["npc;drop=62980"] = {"Kaiserlicher Wesir Zor'lok <Stimme der Kaiserin>", "Das Herz der Angst"}
        s["npc;drop=64340"] = {"Ausbilder Maltik <Bewahrer des ungesehenen Schlages>", "Das Herz der Angst"}
        s["npc;drop=67977"] = {"Tortos", "Der Thron des Donners"}
        s["npc;drop=68397"] = {"Lei Shen <Der Donnerkönig>", "Der Thron des Donners"}
        s["npc;drop=71153"] = {"Hisek der Schwarmwächter", "Schlacht um Orgrimmar"}
        s["npc;drop=71161"] = {"Kil'ruk der Windschnitter", "Schlacht um Orgrimmar"}
        s["npc;drop=71454"] = {"Malkorok", "Schlacht um Orgrimmar"}
        s["npc;drop=71466"] = {"Eiserner Koloss", "Schlacht um Orgrimmar"}
        s["npc;drop=71479"] = {"Hee Samtfuß", "Schlacht um Orgrimmar"}
        s["npc;drop=71480"] = {"Sun Zartherz", "Schlacht um Orgrimmar"}
        s["npc;drop=71504"] = {"Belagerungsingenieur Rußschmied <Rußschmied & Co.>", "Schlacht um Orgrimmar"}
        s["npc;drop=71515"] = {"General Nazgrim", "Schlacht um Orgrimmar"}
        s["npc;drop=71529"] = {"Thok der Blutrünstige", "Schlacht um Orgrimmar"}
        s["npc;drop=71543"] = {"Immerseus <Tränen des Tals>", "Schlacht um Orgrimmar"}
        s["npc;drop=71734"] = {"Sha des Stolzes", "Schlacht um Orgrimmar"}
        s["npc;drop=71858"] = {"Wellenbinderin Kardris", "Schlacht um Orgrimmar"}
        s["npc;drop=71859"] = {"Erdbrecher Haromm", "Schlacht um Orgrimmar"}
        s["npc;drop=71865"] = {"Garrosh Höllschrei <Kriegshäuptling>", "Schlacht um Orgrimmar"}
        s["npc;drop=71889"] = {"Gesicherte Titanentruhe mit Pandarenschätzen", "Schlacht um Orgrimmar"}
        s["npc;drop=71965"] = {"Norushen", "Schlacht um Orgrimmar"}
        s["npc;drop=72249"] = {"Galakras <Die letzte Brut von Galakrond>", "Schlacht um Orgrimmar"}
        s["npc;drop=72276"] = {"Amalgam der Verderbnis", "Schlacht um Orgrimmar"}
        s["npc;sold=44245"] = {"Faldren Tillsdale <Rüstmeister für Tapferkeitspunkte>", "Sturmwind"}
        s["npc;sold=59908"] = {"Jaluu der Spendable <Rüstmeister des Goldenen Lotus>", "Tal der Ewigen Blüten"}
        s["npc;sold=64606"] = {"Kommandantin Ochsenherz <Rüstmeisterin für Tapferkeitspunkte>", "Tonlongsteppe"}
        s["npc;sold=69060"] = {"Fangzahnschlächter Gurkna <Rüstmeister der Herrschaftsoffensive>", "Krasarangwildnis"}
        s["npc;sold=70346"] = {"Ao Pye <Rüstmeisterin des Shado-Pan-Vorstoßes>", "Tonlongsteppe"}
        s["npc;sold=74019"] = {"Tu'aho Wegschneider <Händler für heroische Schlachtzüge>", "Schrein der Zwei Monde"}
        s["npc;sold=74027"] = {"Lorry Warmherz <Händlerin für heroische Schlachtzüge>", "Schrein der Sieben Sterne"}
        s["object;contained=221740"] = {"Tresor der verbotenen Schätze", "Schlacht um Orgrimmar"}
        s["object;contained=221742"] = {"Tresor der verbotenen Schätze", "Schlacht um Orgrimmar"}
        s["object;contained=222750"] = {"Entsicherte Titanentruhe mit Pandarenschätzen", "Schlacht um Orgrimmar"}
        s["object;contained=222752"] = {"Entsicherte Titanentruhe mit Pandarenschätzen", "Schlacht um Orgrimmar"}
        s["object;contained=223237"] = {"Tränen des Tals", "Schlacht um Orgrimmar"}
        s["object;contained=223238"] = {"Tränen des Tals", "Schlacht um Orgrimmar"}
        s["quest;reward=30449"] = {"Kranichkartenset des Dunkelmond-Jahrmarkts", "Wald von Elwynn"}
        s["quest;reward=30450"] = {"Ochsenkartenset des Dunkelmond-Jahrmarkts", "Wald von Elwynn"}
        s["quest;reward=30451"] = {"Schlangenkartenset des Dunkelmond-Jahrmarkts", "Wald von Elwynn"}
        s["quest;reward=30452"] = {"Tigerkartenset des Dunkelmond-Jahrmarkts", "Wald von Elwynn"}
        s["quest;reward=31612"] = {"Schatten des Kaiserreichs", "Schreckensöde"}
    end

    function SpecBisTooltip:TranslationesES()
        s["npc;drop=52571"] = {"Mayordomo Corzocelada <Archidruida de la Llama>", "Tierras de Fuego"}
        s["npc;drop=53879"] = {"Alamuerte <El Destructor>", "Alma de Dragón"}
        s["npc;drop=56427"] = {"Maestro de guerra Cuerno Negro", "Alma de Dragón"}
        s["npc;drop=59080"] = {"Maestro oscuro Gandling", "Scholomance"}
        s["npc;drop=60009"] = {"Feng el Detestable <Vigilante de espíritus campeones>", "Cámaras Mogu'shan"}
        s["npc;drop=60043"] = {"Guardián de jade", "Cámaras Mogu'shan"}
        s["npc;drop=60051"] = {"Guardián de cobalto", "Cámaras Mogu'shan"}
        s["npc;drop=60143"] = {"Gara'jal el Vinculador de Espíritus", "Cámaras Mogu'shan"}
        s["npc;drop=60399"] = {"Qin-xi <Puño cerrado del Emperador>", "Cámaras Mogu'shan"}
        s["npc;drop=60400"] = {"Jan-xi <Mano abierta del Emperador>", "Cámaras Mogu'shan"}
        s["npc;drop=60701"] = {"Zian de la Sombra Infinita <Rey hechicero>", "Cámaras Mogu'shan"}
        s["npc;drop=60999"] = {"Sha del miedo", "Veranda de la Primavera Eterna"}
        s["npc;drop=62397"] = {"Señor del viento Mel'jarak", "Corazón del Miedo"}
        s["npc;drop=62511"] = {"Formador de ámbar Un'sok", "Corazón del Miedo"}
        s["npc;drop=62543"] = {"Señor de las espadas Ta'yak", "Corazón del Miedo"}
        s["npc;drop=62837"] = {"Gran emperatriz Shek'zeer", "Corazón del Miedo"}
        s["npc;drop=62980"] = {"Visir imperial Zor'lok <Voz de la Emperatriz>", "Corazón del Miedo"}
        s["npc;drop=64340"] = {"Instructor Maltik <Vigilante del Golpe invisible>", "Corazón del Miedo"}
        s["npc;drop=67977"] = {"[Tortos]", "Solio del Trueno"}
        s["npc;drop=68397"] = {"Lei Shen <El Rey del Trueno>", "Solio del Trueno"}
        s["npc;drop=71153"] = {"Hisek el Guardaenjambres", "Asedio de Orgrimmar"}
        s["npc;drop=71161"] = {"Kil'ruk el Atracavientos", "Asedio de Orgrimmar"}
        s["npc;drop=71454"] = {"Malkorok", "Asedio de Orgrimmar"}
        s["npc;drop=71466"] = {"Gigante férreo", "Asedio de Orgrimmar"}
        s["npc;drop=71479"] = {"[He Softfoot]", "Asedio de Orgrimmar"}
        s["npc;drop=71480"] = {"[Sun Tenderheart]", "Asedio de Orgrimmar"}
        s["npc;drop=71504"] = {"Asediador Mechanegra <Compañía Mechanegra>", "Asedio de Orgrimmar"}
        s["npc;drop=71515"] = {"General Nazgrim", "Asedio de Orgrimmar"}
        s["npc;drop=71529"] = {"[Thok the Bloodthirsty]", "Asedio de Orgrimmar"}
        s["npc;drop=71543"] = {"Immerseus <Lágrimas del Valle>", "Asedio de Orgrimmar"}
        s["npc;drop=71734"] = {"Sha del orgullo", "Asedio de Orgrimmar"}
        s["npc;drop=71858"] = {"Vinculaolas Kardris", "Asedio de Orgrimmar"}
        s["npc;drop=71859"] = {"Rompesuelos Haromm", "Asedio de Orgrimmar"}
        s["npc;drop=71865"] = {"Garrosh Grito Infernal <Jefe de Guerra>", "Asedio de Orgrimmar"}
        s["npc;drop=71889"] = {"Reserva protegida del botín pandaren", "Asedio de Orgrimmar"}
        s["npc;drop=71965"] = {"[Norushen]", "Asedio de Orgrimmar"}
        s["npc;drop=72249"] = {"Galakras <El último descendiente de Galakrond>", "Asedio de Orgrimmar"}
        s["npc;drop=72276"] = {"[Amalgam of Corruption]", "Asedio de Orgrimmar"}
        s["npc;sold=44245"] = {"Faldren Labravalle <Intendente de valor>", "Ciudad de Ventormenta"}
        s["npc;sold=59908"] = {"Jaluu el Generoso <Intendente de El Loto Dorado>", "Valle de la Flor Eterna"}
        s["npc;sold=64606"] = {"Comandante Corazón de Buey <Intendente de valor>", "Estepas de Tong Long"}
        s["npc;sold=69060"] = {"Destripacolmillo Grukna <Intendente de la Ofensiva de Dominancia>", "Espesura Krasarang"}
        s["npc;sold=70346"] = {"Ao Pye <Intendente del Asalto del Shadopan>", "Estepas de Tong Long"}
        s["npc;sold=74019"] = {"Tu'aho Cortapasos <Vendedor de modo heroico>", "Santuario de las Dos Lunas"}
        s["npc;sold=74027"] = {"Lorry Corazón Gentil <Vendedora de modo heroico>", "Santuario de las Siete Estrellas"}
        s["object;contained=221740"] = {"[Vault of Forbidden Treasures]", "Asedio de Orgrimmar"}
        s["object;contained=221742"] = {"[Vault of Forbidden Treasures]", "Asedio de Orgrimmar"}
        s["object;contained=222750"] = {"[Unlocked Stockpile of Pandaren Spoils]", "Asedio de Orgrimmar"}
        s["object;contained=222752"] = {"[Unlocked Stockpile of Pandaren Spoils]", "Asedio de Orgrimmar"}
        s["object;contained=223237"] = {"[Tears of the Vale]", "Asedio de Orgrimmar"}
        s["object;contained=223238"] = {"[Tears of the Vale]", "Asedio de Orgrimmar"}
        s["quest;reward=30449"] = {"La baraja de la grulla de la Luna Negra", "Bosque de Elwynn"}
        s["quest;reward=30450"] = {"La baraja del buey de la Luna Negra", "Bosque de Elwynn"}
        s["quest;reward=30451"] = {"La baraja del dragón de la Luna Negra", "Bosque de Elwynn"}
        s["quest;reward=30452"] = {"La baraja del tigre de la Luna Negra", "Bosque de Elwynn"}
        s["quest;reward=31612"] = {"La sombra del imperio", "Desierto del Pavor"}
    end

    function SpecBisTooltip:TranslationfrFR()
        s["npc;drop=52571"] = {"Chambellan Forteramure <Archidruide de la Flamme>", "Terres de Feu"}
        s["npc;drop=53879"] = {"Aile de mort <Le Destructeur>", "L’Âme des dragons"}
        s["npc;drop=56427"] = {"Maître de guerre Corne-Noire", "L’Âme des dragons"}
        s["npc;drop=59080"] = {"Sombre Maître Gandling", "Scholomance"}
        s["npc;drop=60009"] = {"Feng le Maudit <Gardien des esprits de champions>", "Caveaux Mogu’shan"}
        s["npc;drop=60043"] = {"Gardien de jade", "Caveaux Mogu’shan"}
        s["npc;drop=60051"] = {"Gardien de cobalt", "Caveaux Mogu’shan"}
        s["npc;drop=60143"] = {"Gara’jal le Lieur d’esprit", "Caveaux Mogu’shan"}
        s["npc;drop=60399"] = {"Qin Xi <Poing fermé de l’empereur>", "Caveaux Mogu’shan"}
        s["npc;drop=60400"] = {"Jan Xi <Main ouverte de l’empereur>", "Caveaux Mogu’shan"}
        s["npc;drop=60583"] = {"Protecteur Kaolan", "Terrasse Printanière"}
        s["npc;drop=60701"] = {"Zian des Ombres éternelles <Roi-sorcier>", "Caveaux Mogu’shan"}
        s["npc;drop=60999"] = {"Sha de la peur", "Terrasse Printanière"}
        s["npc;drop=62397"] = {"Seigneur du Vent Mel’jarak", "Cœur de la peur"}
        s["npc;drop=62511"] = {"Sculpte-ambre Un’sok", "Cœur de la peur"}
        s["npc;drop=62543"] = {"Seigneur des lames Ta’yak", "Cœur de la peur"}
        s["npc;drop=62837"] = {"Grande impératrice Shek’zeer", "Cœur de la peur"}
        s["npc;drop=62980"] = {"Vizir impérial Zor’lok <Voix de l’impératrice>", "Cœur de la peur"}
        s["npc;drop=64340"] = {"Instructeur Maltik <Gardien de l’attaque invisible>", "Cœur de la peur"}
        s["npc;drop=67977"] = {"Tortos", "Trône du tonnerre"}
        s["npc;drop=68397"] = {"Lei Shen <Le roi-tonnerre>", "Trône du tonnerre"}
        s["npc;drop=71153"] = {"Hisek le Gardien de l’essaim", "Siège d’Orgrimmar"}
        s["npc;drop=71161"] = {"Kil’ruk le Saccageur des vents", "Siège d’Orgrimmar"}
        s["npc;drop=71454"] = {"Malkorok", "Siège d’Orgrimmar"}
        s["npc;drop=71466"] = {"Mastodonte de fer", "Siège d’Orgrimmar"}
        s["npc;drop=71479"] = {"He Pas de Loup", "Siège d’Orgrimmar"}
        s["npc;drop=71480"] = {"Sun Cœur de Douceur", "Siège d’Orgrimmar"}
        s["npc;drop=71504"] = {"Ingé-siège Boîte-Noire <Compagnie Boîte-Noire>", "Siège d’Orgrimmar"}
        s["npc;drop=71515"] = {"Général Nazgrim", "Siège d’Orgrimmar"}
        s["npc;drop=71529"] = {"Thok le Sanguinaire", "Siège d’Orgrimmar"}
        s["npc;drop=71543"] = {"Immerseus <Les larmes du Val>", "Siège d’Orgrimmar"}
        s["npc;drop=71734"] = {"Sha de l’orgueil", "Siège d’Orgrimmar"}
        s["npc;drop=71858"] = {"Lieuse de vague Kardris", "Siège d’Orgrimmar"}
        s["npc;drop=71859"] = {"Brise-terre Haromm", "Siège d’Orgrimmar"}
        s["npc;drop=71865"] = {"Garrosh Hurlenfer <Chef de guerre>", "Siège d’Orgrimmar"}
        s["npc;drop=71889"] = {"Réserve sécurisée de butin de Pandarie", "Siège d’Orgrimmar"}
        s["npc;drop=71965"] = {"Norushen", "Siège d’Orgrimmar"}
        s["npc;drop=72249"] = {"Galakras <Dernier descendant de Galakrond>", "Siège d’Orgrimmar"}
        s["npc;drop=72276"] = {"Amalgame de corruption", "Siège d’Orgrimmar"}
        s["npc;sold=44245"] = {"Faldren Tillsdale <Intendant des emblèmes de vaillance>", "Hurlevent"}
        s["npc;sold=59908"] = {"Jaluu le Généreux <Intendant du Lotus doré>", "Val de l’Éternel printemps"}
        s["npc;sold=64606"] = {"Commandant Cœur de Buffle <Intendant des emblèmes de vaillance>", "Steppes de Tanglong"}
        s["npc;sold=69060"] = {"Arrache-défenses Grukna <Intendante de l’offensive Domination>", "Étendues sauvages de Krasarang"}
        s["npc;sold=70346"] = {"Ao Pye <Intendante de l’assaut des Pandashan>", "Steppes de Tanglong"}
        s["npc;sold=74019"] = {"Tu’aho Coupe-Chemin <Marchande d’équipement héroïque>", "Sanctuaire des Deux-Lunes"}
        s["npc;sold=74027"] = {"Lorry Cœur-Ardent <Marchande d’équipement héroïque>", "Sanctuaire des Sept-Étoiles"}
        s["object;contained=221740"] = {"[Vault of Forbidden Treasures]", "Siège d’Orgrimmar"}
        s["object;contained=221742"] = {"Caveau des trésors interdits", "Siège d’Orgrimmar"}
        s["object;contained=222750"] = {"[Unlocked Stockpile of Pandaren Spoils]", "Siège d’Orgrimmar"}
        s["object;contained=222752"] = {"[Unlocked Stockpile of Pandaren Spoils]", "Siège d’Orgrimmar"}
        s["object;contained=223237"] = {"[Tears of the Vale]", "Siège d’Orgrimmar"}
        s["object;contained=223238"] = {"Larmes du val", "Siège d’Orgrimmar"}
        s["quest;reward=30449"] = {"Suite de Grues de Sombrelune", "Forêt d’Elwynn"}
        s["quest;reward=30450"] = {"Suite de Buffles de Sombrelune", "Forêt d’Elwynn"}
        s["quest;reward=30451"] = {"Suite de Serpents de Sombrelune", "Forêt d’Elwynn"}
        s["quest;reward=30452"] = {"Suite de Tigres de Sombrelune", "Forêt d’Elwynn"}
        s["quest;reward=31612"] = {"L'ombre de l'empire", "Terres de l’Angoisse"}
    end

    function SpecBisTooltip:TranslationitIT()
        s["npc;drop=52571"] = {"Majordomo Staghelm <Archdruid of the Flame>", "Firelands"}
        s["npc;drop=67977"] = {"Tortos", ""}
        s["npc;drop=68397"] = {"Lei Shen <The Thunder King>", ""}
        s["npc;drop=71153"] = {"Hisek the Swarmkeeper", ""}
        s["npc;drop=71161"] = {"Kil'ruk the Wind-Reaver", ""}
        s["npc;drop=71454"] = {"Malkorok", ""}
        s["npc;drop=71466"] = {"Iron Juggernaut", ""}
        s["npc;drop=71479"] = {"He Softfoot", ""}
        s["npc;drop=71480"] = {"Sun Tenderheart", ""}
        s["npc;drop=71504"] = {"Siegecrafter Blackfuse <Blackfuse Company>", ""}
        s["npc;drop=71515"] = {"General Nazgrim", ""}
        s["npc;drop=71529"] = {"Thok the Bloodthirsty", ""}
        s["npc;drop=71543"] = {"Immerseus <Tears of the Vale>", ""}
        s["npc;drop=71734"] = {"Sha of Pride", ""}
        s["npc;drop=71858"] = {"Wavebinder Kardris", ""}
        s["npc;drop=71859"] = {"Earthbreaker Haromm", ""}
        s["npc;drop=71865"] = {"Garrosh Hellscream <Warchief>", ""}
        s["npc;drop=71889"] = {"Secured Stockpile of Pandaren Spoils", ""}
        s["npc;drop=71965"] = {"Norushen", ""}
        s["npc;drop=72249"] = {"Galakras <The Last Brood of Galakrond>", ""}
        s["npc;drop=72276"] = {"Amalgam of Corruption", ""}
        s["npc;sold=70346"] = {"Ao Pye <Shado-Pan Assault Quartermaster>", ""}
        s["npc;sold=74019"] = {"Tu'aho Pathcutter <Heroic Vendor>", ""}
        s["npc;sold=74027"] = {"Lorry Warmheart <Heroic Vendor>", ""}
        s["object;contained=221740"] = {"[Vault of Forbidden Treasures]", "Siege of Orgrimmar"}
        s["object;contained=221742"] = {"[Vault of Forbidden Treasures]", "Siege of Orgrimmar"}
        s["object;contained=222750"] = {"[Unlocked Stockpile of Pandaren Spoils]", "Siege of Orgrimmar"}
        s["object;contained=222752"] = {"[Unlocked Stockpile of Pandaren Spoils]", "Siege of Orgrimmar"}
        s["object;contained=223237"] = {"[Tears of the Vale]", "Siege of Orgrimmar"}
        s["object;contained=223238"] = {"[Tears of the Vale]", "Siege of Orgrimmar"}
        s["quest;reward=30449"] = {"[Darkmoon Crane Deck]", "Elwynn Forest"}
        s["quest;reward=30450"] = {"[Darkmoon Ox Deck]", "Elwynn Forest"}
        s["quest;reward=30451"] = {"[Darkmoon Serpent Deck]", "Elwynn Forest"}
        s["quest;reward=30452"] = {"[Darkmoon Tiger Deck]", "Elwynn Forest"}
        s["quest;reward=31612"] = {"[Shadow of the Empire]", "Dread Wastes"}
    end

    function SpecBisTooltip:TranslationkoKR()
        s["npc;drop=52571"] = {"청지기 스태그헬름 <화염의 대드루이드>", "불의 땅"}
        s["npc;drop=53879"] = {"[Deathwing] <[The Destroyer]>", "용의 영혼"}
        s["npc;drop=55265"] = {"[Morchok]", "용의 영혼"}
        s["npc;drop=55294"] = {"[Ultraxion]", "용의 영혼"}
        s["npc;drop=56427"] = {"[Warmaster Blackhorn]", "용의 영혼"}
        s["npc;drop=59080"] = {"암흑스승 간들링", "스칼로맨스"}
        s["npc;drop=60009"] = {"저주받은 펑 <용사 영혼 관리자>", "모구샨 금고"}
        s["npc;drop=60043"] = {"비취 수호자", "모구샨 금고"}
        s["npc;drop=60051"] = {"코발트 수호자", "모구샨 금고"}
        s["npc;drop=60143"] = {"영혼결속자 가라잘", "모구샨 금고"}
        s["npc;drop=60399"] = {"친시 <황제의 꽉 쥔 주먹>", "모구샨 금고"}
        s["npc;drop=60400"] = {"잔시 <황제의 펼친 손>", "모구샨 금고"}
        s["npc;drop=60410"] = {"엘레곤", "모구샨 금고"}
        s["npc;drop=60583"] = {"수호병 카오란", "영원한 봄의 정원"}
        s["npc;drop=60701"] = {"영원한 어둠의 쯔안 <마술사 왕>", "모구샨 금고"}
        s["npc;drop=60999"] = {"공포의 샤", "영원한 봄의 정원"}
        s["npc;drop=62397"] = {"바람군주 멜자라크", "공포의 심장"}
        s["npc;drop=62442"] = {"출롱", "영원한 봄의 정원"}
        s["npc;drop=62511"] = {"호박석구체자 운속", "공포의 심장"}
        s["npc;drop=62543"] = {"[Blade Lord Ta'yak]", "공포의 심장"}
        s["npc;drop=62837"] = {"위대한 여제 셰크지르", "공포의 심장"}
        s["npc;drop=62980"] = {"황실 장로 조르로크 <여제의 목소리>", "공포의 심장"}
        s["npc;drop=62983"] = {"레이 스", "영원한 봄의 정원"}
        s["npc;drop=63191"] = {"[Garalon]", "공포의 심장"}
        s["npc;drop=64340"] = {"[Instructor Maltik] <[Keeper of Unseen Strike]>", "공포의 심장"}
        s["npc;drop=67977"] = {"토르토스", "천둥의 왕좌"}
        s["npc;drop=68397"] = {"레이 션 <천둥왕>", "천둥의 왕좌"}
        s["npc;drop=71153"] = {"[Hisek the Swarmkeeper]", "오그리마 공성전"}
        s["npc;drop=71161"] = {"[Kil'ruk the Wind-Reaver]", "오그리마 공성전"}
        s["npc;drop=71454"] = {"[Malkorok]", "오그리마 공성전"}
        s["npc;drop=71466"] = {"[Iron Juggernaut]", "오그리마 공성전"}
        s["npc;drop=71479"] = {"[He Softfoot]", "오그리마 공성전"}
        s["npc;drop=71480"] = {"[Sun Tenderheart]", "오그리마 공성전"}
        s["npc;drop=71504"] = {"공성기술자 블랙퓨즈 <블랙퓨즈 사>", "오그리마 공성전"}
        s["npc;drop=71515"] = {"[General Nazgrim]", "오그리마 공성전"}
        s["npc;drop=71529"] = {"[Thok the Bloodthirsty]", "오그리마 공성전"}
        s["npc;drop=71543"] = {"[Immerseus] <[Tears of the Vale]>", "오그리마 공성전"}
        s["npc;drop=71734"] = {"교만의 샤", "오그리마 공성전"}
        s["npc;drop=71858"] = {"[Wavebinder Kardris]", "오그리마 공성전"}
        s["npc;drop=71859"] = {"[Earthbreaker Haromm]", "오그리마 공성전"}
        s["npc;drop=71865"] = {"가로쉬 헬스크림 <대족장>", "오그리마 공성전"}
        s["npc;drop=71889"] = {"[Secured Stockpile of Pandaren Spoils]", "오그리마 공성전"}
        s["npc;drop=71965"] = {"[Norushen]", "오그리마 공성전"}
        s["npc;drop=72249"] = {"[Galakras] <[The Last Brood of Galakrond]>", "오그리마 공성전"}
        s["npc;drop=72276"] = {"[Amalgam of Corruption]", "오그리마 공성전"}
        s["npc;sold=44245"] = {"폴드런 틸스데일 <용맹 병참장교>", "스톰윈드"}
        s["npc;sold=59908"] = {"너그러운 잘루 <황금 연꽃 병참장교>", "영원꽃 골짜기"}
        s["npc;sold=64606"] = {"사령관 옥스하트 <용맹 병참장교>", "탕랑 평원"}
        s["npc;sold=69060"] = {"엄니갈퀴 그루크나 <지배령 선봉대 병참장교>", "크라사랑 밀림"}
        s["npc;sold=70346"] = {"[Ao Pye] <[Shado-Pan Assault Quartermaster]>", "탕랑 평원"}
        s["npc;sold=74019"] = {"투아호 패스커터 <영웅 공격대 상인>", "두 달의 제단"}
        s["npc;sold=74027"] = {"로리 웜하트 <영웅 공격대 상인>", "일곱 별의 제단"}
        s["object;contained=221740"] = {"[Vault of Forbidden Treasures]", "오그리마 공성전"}
        s["object;contained=221742"] = {"[Vault of Forbidden Treasures]", "오그리마 공성전"}
        s["object;contained=222750"] = {"[Unlocked Stockpile of Pandaren Spoils]", "오그리마 공성전"}
        s["object;contained=222752"] = {"[Unlocked Stockpile of Pandaren Spoils]", "오그리마 공성전"}
        s["object;contained=223237"] = {"[Tears of the Vale]", "오그리마 공성전"}
        s["object;contained=223238"] = {"[Tears of the Vale]", "오그리마 공성전"}
        s["quest;reward=30449"] = {"다크문 학 카드 한 벌", "엘윈 숲"}
        s["quest;reward=30450"] = {"다크문 소 카드 한 벌", "엘윈 숲"}
        s["quest;reward=30451"] = {"다크문 용 카드 한 벌", "엘윈 숲"}
        s["quest;reward=30452"] = {"다크문 호랑이 카드 한 벌", "엘윈 숲"}
        s["quest;reward=31612"] = {"제국의 그림자", "공포의 황무지"}
    end

    function SpecBisTooltip:TranslationptBR()
        s["npc;drop=52571"] = {"[Majordomo Staghelm] <[Archdruid of the Flame]>", "Terras do Fogo"}
        s["npc;drop=53879"] = {"[Deathwing] <[The Destroyer]>", "Alma Dragônica"}
        s["npc;drop=55265"] = {"[Morchok]", "Alma Dragônica"}
        s["npc;drop=55294"] = {"[Ultraxion]", "Alma Dragônica"}
        s["npc;drop=56427"] = {"[Warmaster Blackhorn]", "Alma Dragônica"}
        s["npc;drop=59080"] = {"Umbromestre Gandling", "Scolomântia"}
        s["npc;drop=60009"] = {"[Feng the Accursed] <[Keeper of Champion Spirits]>", "Galerias Mogu'shan"}
        s["npc;drop=60043"] = {"[Jade Guardian]", "Galerias Mogu'shan"}
        s["npc;drop=60051"] = {"[Cobalt Guardian]", "Galerias Mogu'shan"}
        s["npc;drop=60143"] = {"Gara'jal, o Atador de Almas", "Galerias Mogu'shan"}
        s["npc;drop=60399"] = {"[Qin-xi] <[Emperor's Closed Fist]>", "Galerias Mogu'shan"}
        s["npc;drop=60400"] = {"[Jan-xi] <[Emperor's Open Hand]>", "Galerias Mogu'shan"}
        s["npc;drop=60583"] = {"Protetor Kaolan", "Terraço da Primavera Eterna"}
        s["npc;drop=60701"] = {"[Zian of the Endless Shadow] <[Sorcerer King]>", "Galerias Mogu'shan"}
        s["npc;drop=60999"] = {"Sha do Medo", "Terraço da Primavera Eterna"}
        s["npc;drop=62397"] = {"Senhor do Vento Mel'jarak", "Coração do Medo"}
        s["npc;drop=62511"] = {"Molda-âmbar Un'sok", "Coração do Medo"}
        s["npc;drop=62543"] = {"[Blade Lord Ta'yak]", "Coração do Medo"}
        s["npc;drop=62837"] = {"Grã-imperatriz Shek'zeer", "Coração do Medo"}
        s["npc;drop=62980"] = {"[Imperial Vizier Zor'lok] <[Voice of the Empress]>", "Coração do Medo"}
        s["npc;drop=63191"] = {"[Garalon]", "Coração do Medo"}
        s["npc;drop=64340"] = {"[Instructor Maltik] <[Keeper of Unseen Strike]>", "Coração do Medo"}
        s["npc;drop=67977"] = {"Tórtus", "Trono do Trovão"}
        s["npc;drop=68397"] = {"[Lei Shen] <[The Thunder King]>", "Trono do Trovão"}
        s["npc;drop=71153"] = {"[Hisek the Swarmkeeper]", "Cerco a Orgrimmar"}
        s["npc;drop=71161"] = {"[Kil'ruk the Wind-Reaver]", "Cerco a Orgrimmar"}
        s["npc;drop=71454"] = {"[Malkorok]", "Cerco a Orgrimmar"}
        s["npc;drop=71466"] = {"[Iron Juggernaut]", "Cerco a Orgrimmar"}
        s["npc;drop=71479"] = {"[He Softfoot]", "Cerco a Orgrimmar"}
        s["npc;drop=71480"] = {"[Sun Tenderheart]", "Cerco a Orgrimmar"}
        s["npc;drop=71504"] = {"Cerqueiro Pavio Preto <Companhia Pavio Preto>", "Cerco a Orgrimmar"}
        s["npc;drop=71515"] = {"[General Nazgrim]", "Cerco a Orgrimmar"}
        s["npc;drop=71529"] = {"[Thok the Bloodthirsty]", "Cerco a Orgrimmar"}
        s["npc;drop=71543"] = {"[Immerseus] <[Tears of the Vale]>", "Cerco a Orgrimmar"}
        s["npc;drop=71734"] = {"[Sha of Pride]", "Cerco a Orgrimmar"}
        s["npc;drop=71858"] = {"[Wavebinder Kardris]", "Cerco a Orgrimmar"}
        s["npc;drop=71859"] = {"[Earthbreaker Haromm]", "Cerco a Orgrimmar"}
        s["npc;drop=71865"] = {"Garrosh Grito Infernal <Chefe Guerreiro>", "Cerco a Orgrimmar"}
        s["npc;drop=71889"] = {"[Secured Stockpile of Pandaren Spoils]", "Cerco a Orgrimmar"}
        s["npc;drop=71965"] = {"[Norushen]", "Cerco a Orgrimmar"}
        s["npc;drop=72249"] = {"[Galakras] <[The Last Brood of Galakrond]>", "Cerco a Orgrimmar"}
        s["npc;drop=72276"] = {"[Amalgam of Corruption]", "Cerco a Orgrimmar"}
        s["npc;sold=44245"] = {"Fernão Thadeo <Intendente de Bravura>", "Ventobravo"}
        s["npc;sold=59908"] = {"Jaluu, o Generoso <Zelador>", "Vale das Flores Eternas"}
        s["npc;sold=64606"] = {"[Commander Oxheart] <[Valor Quartermaster]>", "Estepes de Taolong"}
        s["npc;sold=69060"] = {"[Tuskripper Grukna] <[Dominance Offensive Quartermaster]>", "Selva de Krasarang"}
        s["npc;sold=70346"] = {"[Ao Pye] <[Shado-Pan Assault Quartermaster]>", "Estepes de Taolong"}
        s["npc;sold=74019"] = {"[Tu'aho Pathcutter] <[Heroic Vendor]>", "Santuário das Duas Luas"}
        s["npc;sold=74027"] = {"[Lorry Warmheart] <[Heroic Vendor]>", "Santuário das Sete Estrelas"}
        s["object;contained=221740"] = {"[Vault of Forbidden Treasures]", "Cerco a Orgrimmar"}
        s["object;contained=221742"] = {"[Vault of Forbidden Treasures]", "Cerco a Orgrimmar"}
        s["object;contained=222750"] = {"[Unlocked Stockpile of Pandaren Spoils]", "Cerco a Orgrimmar"}
        s["object;contained=222752"] = {"[Unlocked Stockpile of Pandaren Spoils]", "Cerco a Orgrimmar"}
        s["object;contained=223237"] = {"[Tears of the Vale]", "Cerco a Orgrimmar"}
        s["object;contained=223238"] = {"[Tears of the Vale]", "Cerco a Orgrimmar"}
        s["quest;reward=30449"] = {"Baralho do Grou de Negraluna", "Floresta de Elwynn"}
        s["quest;reward=30450"] = {"Baralho do Boi de Negraluna", "Floresta de Elwynn"}
        s["quest;reward=30451"] = {"Baralho da Serpente de Negraluna", "Floresta de Elwynn"}
        s["quest;reward=30452"] = {"Baralho do Tigre de Negraluna", "Floresta de Elwynn"}
        s["quest;reward=31612"] = {"[Shadow of the Empire]", "Ermo do Medo"}
        s["spell;created=146560"] = {"Feitiço de Transformação do Manto 01", ""}
        s["spell;created=146562"] = {"Feitiço de Transformação do Manto 02", ""}
        s["spell;created=146563"] = {"Feitiço de Transformação do Manto 03", ""}
        s["spell;created=146564"] = {"Feitiço de Transformação do Manto 04", ""}
        s["spell;created=146565"] = {"Feitiço de Transformação do Manto 05", ""}
        s["spell;created=146566"] = {"Feitiço de Transformação do Manto 06", ""}
    end

    function SpecBisTooltip:TranslationruRU()
        s["npc;drop=52571"] = {"Мажордом Фэндрал Олений Шлем <Верховный друид пламени>", "Огненные Просторы"}
        s["npc;drop=53879"] = {"Смертокрыл <Разрушитель>", "Душа Дракона"}
        s["npc;drop=55265"] = {"Морхок", "Душа Дракона"}
        s["npc;drop=55294"] = {"Ультраксион", "Душа Дракона"}
        s["npc;drop=56427"] = {"Воевода Черный Рог", "Душа Дракона"}
        s["npc;drop=59080"] = {"Темный магистр Гандлинг", "Некроситет"}
        s["npc;drop=60009"] = {"Фэн Проклятый <Хранитель древних духов>", "Подземелья Могу'шан"}
        s["npc;drop=60043"] = {"Нефритовый страж", "Подземелья Могу'шан"}
        s["npc;drop=60051"] = {"Кобальтовый страж", "Подземелья Могу'шан"}
        s["npc;drop=60143"] = {"Душелов Гара'джал", "Подземелья Могу'шан"}
        s["npc;drop=60399"] = {"Цинь-си <Сжатый кулак императора>", "Подземелья Могу'шан"}
        s["npc;drop=60400"] = {"Цзань-си <Открытая ладонь императора>", "Подземелья Могу'шан"}
        s["npc;drop=60410"] = {"Элегон", "Подземелья Могу'шан"}
        s["npc;drop=60583"] = {"Защитник Каолань", "Терраса Вечной Весны"}
        s["npc;drop=60701"] = {"Цзыань Беспросветная Тьма <Король чародеев>", "Подземелья Могу'шан"}
        s["npc;drop=60999"] = {"Ша Страха", "Терраса Вечной Весны"}
        s["npc;drop=62397"] = {"Повелитель ветров Мел'джарак", "Сердце Страха"}
        s["npc;drop=62442"] = {"Цулон", "Терраса Вечной Весны"}
        s["npc;drop=62511"] = {"Ваятель янтаря Ун'сок", "Сердце Страха"}
        s["npc;drop=62543"] = {"Повелитель клинков Та'як", "Сердце Страха"}
        s["npc;drop=62837"] = {"Великая императрица Шек'зир", "Сердце Страха"}
        s["npc;drop=62980"] = {"Императорский визирь Зор'лок <Голос императрицы>", "Сердце Страха"}
        s["npc;drop=62983"] = {"Лэй Ши", "Терраса Вечной Весны"}
        s["npc;drop=63191"] = {"Гаралон", "Сердце Страха"}
        s["npc;drop=64340"] = {"Инструктор Малтик <Мастер незримого удара>", "Сердце Страха"}
        s["npc;drop=67977"] = {"Тортос", "Престол Гроз"}
        s["npc;drop=68397"] = {"Лэй Шэнь <Властелин Грома>", "Престол Гроз"}
        s["npc;drop=71153"] = {"Хисек Хранитель Роя", "Осада Оргриммара"}
        s["npc;drop=71161"] = {"Кил'рук Рассекающий Ветер", "Осада Оргриммара"}
        s["npc;drop=71454"] = {"Малкорок", "Осада Оргриммара"}
        s["npc;drop=71466"] = {"Железный исполин", "Осада Оргриммара"}
        s["npc;drop=71479"] = {"Хэ Легкая Нога", "Осада Оргриммара"}
        s["npc;drop=71480"] = {"Сунь Доброе Сердце", "Осада Оргриммара"}
        s["npc;drop=71504"] = {"Мастер осады Черноплавс <Компания Черноплавса>", "Осада Оргриммара"}
        s["npc;drop=71515"] = {"Генерал Назгрим", "Осада Оргриммара"}
        s["npc;drop=71529"] = {"Ток Кровожадный", "Осада Оргриммара"}
        s["npc;drop=71543"] = {"Глубиний <Слезы Дола>", "Осада Оргриммара"}
        s["npc;drop=71734"] = {"Ша Гордыни", "Осада Оргриммара"}
        s["npc;drop=71858"] = {"Покорительница волн Кардрис", "Осада Оргриммара"}
        s["npc;drop=71859"] = {"Землелом Харомм", "Осада Оргриммара"}
        s["npc;drop=71865"] = {"Гаррош Адский Крик <Вождь>", "Осада Оргриммара"}
        s["npc;drop=71889"] = {"Охраняемый запас пандаренских трофеев", "Осада Оргриммара"}
        s["npc;drop=71965"] = {"Норусхен", "Осада Оргриммара"}
        s["npc;drop=72249"] = {"Галакрас <Последний потомок Галакронда>", "Осада Оргриммара"}
        s["npc;drop=72276"] = {"Слияние скверны", "Осада Оргриммара"}
        s["npc;sold=44245"] = {"Фалдрен Тиллсдейл <Награды за очки доблести>", "Штормград"}
        s["npc;sold=59908"] = {"Джалуу Щедрый <Интендант Золотого Лотоса>", "Вечноцветущий дол"}
        s["npc;sold=64606"] = {"Командир Бычье Сердце <Награды за очки доблести>", "Танлунские степи"}
        s["npc;sold=69060"] = {"Клыкодер Грукна <Интендант Армии Покорителей>", "Красарангские джунгли"}
        s["npc;sold=70346"] = {"Ао Пай <Интендант Натиска Шадо-Пан>", "Танлунские степи"}
        s["npc;sold=74019"] = {"Ту'ахо Прокладывающий Тропы <Торговец (награды за рейд героического режима)>", "Святилище Двух Лун"}
        s["npc;sold=74027"] = {"Лорри Горячее Сердце <Торговец (награды за рейд героического режима)>", "Святилище Семи Звезд"}
        s["object;contained=221740"] = {"Хранилище запретных сокровищ", "Осада Оргриммара"}
        s["object;contained=221742"] = {"Хранилище запретных сокровищ", "Осада Оргриммара"}
        s["object;contained=222750"] = {"Неохраняемый запас пандаренских трофеев", "Осада Оргриммара"}
        s["object;contained=222752"] = {"[Unlocked Stockpile of Pandaren Spoils]", "Осада Оргриммара"}
        s["object;contained=223237"] = {"Слезы Дола", "Осада Оргриммара"}
        s["object;contained=223238"] = {"Слезы Дола", "Осада Оргриммара"}
        s["quest;reward=30449"] = {"Колода карт Новолуния: Журавль", "Элвиннский лес"}
        s["quest;reward=30450"] = {"Колода карт Новолуния: Бык", "Элвиннский лес"}
        s["quest;reward=30451"] = {"Колода карт Новолуния: Змея", "Элвиннский лес"}
        s["quest;reward=30452"] = {"Колода карт Новолуния: Тигр", "Элвиннский лес"}
        s["quest;reward=31612"] = {"Тень империи", "Жуткие пустоши"}
    end

    function SpecBisTooltip:TranslationzhCN()
        s["npc;drop=52571"] = {"[Majordomo Staghelm] <[Archdruid of the Flame]>", "火焰之地"}
        s["npc;drop=53879"] = {"[Deathwing] <[The Destroyer]>", "巨龙之魂"}
        s["npc;drop=55265"] = {"[Morchok]", "巨龙之魂"}
        s["npc;drop=55294"] = {"[Ultraxion]", "巨龙之魂"}
        s["npc;drop=56427"] = {"[Warmaster Blackhorn]", "巨龙之魂"}
        s["npc;drop=59080"] = {"[Darkmaster Gandling]", "通灵学院"}
        s["npc;drop=60009"] = {"受诅者魔封 <勇士之魂守护者>", "魔古山宝库"}
        s["npc;drop=60043"] = {"青玉守护者", "魔古山宝库"}
        s["npc;drop=60051"] = {"[Cobalt Guardian]", "魔古山宝库"}
        s["npc;drop=60143"] = {"缚灵者戈拉亚", "魔古山宝库"}
        s["npc;drop=60399"] = {"秦希 <皇帝的蓄势之拳>", "魔古山宝库"}
        s["npc;drop=60400"] = {"[Jan-xi] <[Emperor's Open Hand]>", "魔古山宝库"}
        s["npc;drop=60410"] = {"伊拉贡", "魔古山宝库"}
        s["npc;drop=60583"] = {"守护者考兰", "永春台"}
        s["npc;drop=60701"] = {"永影之提安 <巫王>", "魔古山宝库"}
        s["npc;drop=60999"] = {"惧之煞", "永春台"}
        s["npc;drop=62397"] = {"风领主梅尔加拉克", "恐惧之心"}
        s["npc;drop=62442"] = {"[Tsulong]", "永春台"}
        s["npc;drop=62511"] = {"琥珀塑形者昂舒克", "恐惧之心"}
        s["npc;drop=62543"] = {"[Blade Lord Ta'yak]", "恐惧之心"}
        s["npc;drop=62837"] = {"大女皇夏柯希尔", "恐惧之心"}
        s["npc;drop=62980"] = {"皇家宰相佐尔洛克 <女王喉舌>", "恐惧之心"}
        s["npc;drop=62983"] = {"雷施", "永春台"}
        s["npc;drop=63191"] = {"[Garalon]", "恐惧之心"}
        s["npc;drop=64340"] = {"[Instructor Maltik] <[Keeper of Unseen Strike]>", "恐惧之心"}
        s["npc;drop=67977"] = {"[Tortos]", "雷电王座"}
        s["npc;drop=68397"] = {"雷神 <雷电之王>", "雷电王座"}
        s["npc;drop=71153"] = {"[Hisek the Swarmkeeper]", "决战奥格瑞玛"}
        s["npc;drop=71161"] = {"[Kil'ruk the Wind-Reaver]", "决战奥格瑞玛"}
        s["npc;drop=71454"] = {"[Malkorok]", "决战奥格瑞玛"}
        s["npc;drop=71466"] = {"[Iron Juggernaut]", "决战奥格瑞玛"}
        s["npc;drop=71479"] = {"[He Softfoot]", "决战奥格瑞玛"}
        s["npc;drop=71480"] = {"[Sun Tenderheart]", "决战奥格瑞玛"}
        s["npc;drop=71504"] = {"攻城匠师黑索 <黑索公司>", "决战奥格瑞玛"}
        s["npc;drop=71515"] = {"纳兹戈林将军", "决战奥格瑞玛"}
        s["npc;drop=71529"] = {"[Thok the Bloodthirsty]", "决战奥格瑞玛"}
        s["npc;drop=71543"] = {"伊墨苏斯 <山谷之泪>", "决战奥格瑞玛"}
        s["npc;drop=71734"] = {"[Sha of Pride]", "决战奥格瑞玛"}
        s["npc;drop=71858"] = {"[Wavebinder Kardris]", "决战奥格瑞玛"}
        s["npc;drop=71859"] = {"[Earthbreaker Haromm]", "决战奥格瑞玛"}
        s["npc;drop=71865"] = {"加尔鲁什·地狱咆哮 <酋长>", "决战奥格瑞玛"}
        s["npc;drop=71889"] = {"[Secured Stockpile of Pandaren Spoils]", "决战奥格瑞玛"}
        s["npc;drop=71965"] = {"[Norushen]", "决战奥格瑞玛"}
        s["npc;drop=72249"] = {"[Galakras] <[The Last Brood of Galakrond]>", "决战奥格瑞玛"}
        s["npc;drop=72276"] = {"[Amalgam of Corruption]", "决战奥格瑞玛"}
        s["npc;sold=44245"] = {"[Faldren Tillsdale] <[Valor Quartermaster]>", "暴风城"}
        s["npc;sold=59908"] = {"[Jaluu the Generous] <[The Golden Lotus Quartermaster]>", "锦绣谷"}
        s["npc;sold=64606"] = {"[Commander Oxheart] <[Valor Quartermaster]>", "螳螂高原"}
        s["npc;sold=69060"] = {"[Tuskripper Grukna] <[Dominance Offensive Quartermaster]>", "卡桑琅丛林"}
        s["npc;sold=70346"] = {"白傲 <影踪突袭营军需官>", "螳螂高原"}
        s["npc;sold=74019"] = {"[Tu'aho Pathcutter] <[Heroic Vendor]>", "双月殿"}
        s["npc;sold=74027"] = {"[Lorry Warmheart] <[Heroic Vendor]>", "七星殿"}
        s["object;contained=221740"] = {"[Vault of Forbidden Treasures]", "决战奥格瑞玛"}
        s["object;contained=221742"] = {"[Vault of Forbidden Treasures]", "决战奥格瑞玛"}
        s["object;contained=222750"] = {"[Unlocked Stockpile of Pandaren Spoils]", "决战奥格瑞玛"}
        s["object;contained=222752"] = {"[Unlocked Stockpile of Pandaren Spoils]", "决战奥格瑞玛"}
        s["object;contained=223237"] = {"[Tears of the Vale]", "决战奥格瑞玛"}
        s["object;contained=223238"] = {"[Tears of the Vale]", "决战奥格瑞玛"}
        s["quest;reward=30449"] = {"[Darkmoon Crane Deck]", "艾尔文森林"}
        s["quest;reward=30450"] = {"[Darkmoon Ox Deck]", "艾尔文森林"}
        s["quest;reward=30451"] = {"[Darkmoon Serpent Deck]", "艾尔文森林"}
        s["quest;reward=30452"] = {"[Darkmoon Tiger Deck]", "艾尔文森林"}
        s["quest;reward=31612"] = {"[Shadow of the Empire]", "恐惧废土"}
    end

    function SpecBisTooltip:TranslationzhTW()
        s["npc;drop=52571"] = {"[Majordomo Staghelm] <[Archdruid of the Flame]>", "火焰之地"}
        s["npc;drop=53879"] = {"[Deathwing] <[The Destroyer]>", "巨龙之魂"}
        s["npc;drop=55265"] = {"[Morchok]", "巨龙之魂"}
        s["npc;drop=55294"] = {"[Ultraxion]", "巨龙之魂"}
        s["npc;drop=56427"] = {"[Warmaster Blackhorn]", "巨龙之魂"}
        s["npc;drop=59080"] = {"[Darkmaster Gandling]", "通灵学院"}
        s["npc;drop=60009"] = {"受诅者魔封 <勇士之魂守护者>", "魔古山宝库"}
        s["npc;drop=60043"] = {"青玉守护者", "魔古山宝库"}
        s["npc;drop=60051"] = {"[Cobalt Guardian]", "魔古山宝库"}
        s["npc;drop=60143"] = {"缚灵者戈拉亚", "魔古山宝库"}
        s["npc;drop=60399"] = {"秦希 <皇帝的蓄势之拳>", "魔古山宝库"}
        s["npc;drop=60400"] = {"[Jan-xi] <[Emperor's Open Hand]>", "魔古山宝库"}
        s["npc;drop=60410"] = {"伊拉贡", "魔古山宝库"}
        s["npc;drop=60583"] = {"守护者考兰", "永春台"}
        s["npc;drop=60701"] = {"永影之提安 <巫王>", "魔古山宝库"}
        s["npc;drop=60999"] = {"惧之煞", "永春台"}
        s["npc;drop=62397"] = {"风领主梅尔加拉克", "恐惧之心"}
        s["npc;drop=62442"] = {"[Tsulong]", "永春台"}
        s["npc;drop=62511"] = {"琥珀塑形者昂舒克", "恐惧之心"}
        s["npc;drop=62543"] = {"[Blade Lord Ta'yak]", "恐惧之心"}
        s["npc;drop=62837"] = {"大女皇夏柯希尔", "恐惧之心"}
        s["npc;drop=62980"] = {"皇家宰相佐尔洛克 <女王喉舌>", "恐惧之心"}
        s["npc;drop=62983"] = {"雷施", "永春台"}
        s["npc;drop=63191"] = {"[Garalon]", "恐惧之心"}
        s["npc;drop=64340"] = {"[Instructor Maltik] <[Keeper of Unseen Strike]>", "恐惧之心"}
        s["npc;drop=67977"] = {"[Tortos]", "雷电王座"}
        s["npc;drop=68397"] = {"雷神 <雷电之王>", "雷电王座"}
        s["npc;drop=71153"] = {"[Hisek the Swarmkeeper]", "决战奥格瑞玛"}
        s["npc;drop=71161"] = {"[Kil'ruk the Wind-Reaver]", "决战奥格瑞玛"}
        s["npc;drop=71454"] = {"[Malkorok]", "决战奥格瑞玛"}
        s["npc;drop=71466"] = {"[Iron Juggernaut]", "决战奥格瑞玛"}
        s["npc;drop=71479"] = {"[He Softfoot]", "决战奥格瑞玛"}
        s["npc;drop=71480"] = {"[Sun Tenderheart]", "决战奥格瑞玛"}
        s["npc;drop=71504"] = {"攻城匠师黑索 <黑索公司>", "决战奥格瑞玛"}
        s["npc;drop=71515"] = {"纳兹戈林将军", "决战奥格瑞玛"}
        s["npc;drop=71529"] = {"[Thok the Bloodthirsty]", "决战奥格瑞玛"}
        s["npc;drop=71543"] = {"伊墨苏斯 <山谷之泪>", "决战奥格瑞玛"}
        s["npc;drop=71734"] = {"[Sha of Pride]", "决战奥格瑞玛"}
        s["npc;drop=71858"] = {"[Wavebinder Kardris]", "决战奥格瑞玛"}
        s["npc;drop=71859"] = {"[Earthbreaker Haromm]", "决战奥格瑞玛"}
        s["npc;drop=71865"] = {"加尔鲁什·地狱咆哮 <酋长>", "决战奥格瑞玛"}
        s["npc;drop=71889"] = {"[Secured Stockpile of Pandaren Spoils]", "决战奥格瑞玛"}
        s["npc;drop=71965"] = {"[Norushen]", "决战奥格瑞玛"}
        s["npc;drop=72249"] = {"[Galakras] <[The Last Brood of Galakrond]>", "决战奥格瑞玛"}
        s["npc;drop=72276"] = {"[Amalgam of Corruption]", "决战奥格瑞玛"}
        s["npc;sold=44245"] = {"[Faldren Tillsdale] <[Valor Quartermaster]>", "暴风城"}
        s["npc;sold=59908"] = {"[Jaluu the Generous] <[The Golden Lotus Quartermaster]>", "锦绣谷"}
        s["npc;sold=64606"] = {"[Commander Oxheart] <[Valor Quartermaster]>", "螳螂高原"}
        s["npc;sold=69060"] = {"[Tuskripper Grukna] <[Dominance Offensive Quartermaster]>", "卡桑琅丛林"}
        s["npc;sold=70346"] = {"白傲 <影踪突袭营军需官>", "螳螂高原"}
        s["npc;sold=74019"] = {"[Tu'aho Pathcutter] <[Heroic Vendor]>", "双月殿"}
        s["npc;sold=74027"] = {"[Lorry Warmheart] <[Heroic Vendor]>", "七星殿"}
        s["object;contained=221740"] = {"[Vault of Forbidden Treasures]", "决战奥格瑞玛"}
        s["object;contained=221742"] = {"[Vault of Forbidden Treasures]", "决战奥格瑞玛"}
        s["object;contained=222750"] = {"[Unlocked Stockpile of Pandaren Spoils]", "决战奥格瑞玛"}
        s["object;contained=222752"] = {"[Unlocked Stockpile of Pandaren Spoils]", "决战奥格瑞玛"}
        s["object;contained=223237"] = {"[Tears of the Vale]", "决战奥格瑞玛"}
        s["object;contained=223238"] = {"[Tears of the Vale]", "决战奥格瑞玛"}
        s["quest;reward=30449"] = {"[Darkmoon Crane Deck]", "艾尔文森林"}
        s["quest;reward=30450"] = {"[Darkmoon Ox Deck]", "艾尔文森林"}
        s["quest;reward=30451"] = {"[Darkmoon Serpent Deck]", "艾尔文森林"}
        s["quest;reward=30452"] = {"[Darkmoon Tiger Deck]", "艾尔文森林"}
        s["quest;reward=31612"] = {"[Shadow of the Empire]", "恐惧废土"}
    end
end
