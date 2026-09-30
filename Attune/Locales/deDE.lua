--localization file for german/Germany
local Lang = LibStub("AceLocale-3.0"):NewLocale("Attune", "deDE")
if (not Lang) then
	return;
end


-- INTERFACE
Lang["Credits"] = "Ein großes Dankeschön an meine Gilde |cffffd100<Calm Down>|r für ihre Unterstützung und Verständnis, während ich das Addon teste.\n\nWenn ihr mich seht, werft mir ein |cffffd100/hug|r zu!\n\nCixi Delmont / Gaya Greyhoof"
Lang["Zoom"] = "Zoom"
Lang["Pan_DESC"] = "Ziehen zum Verschieben der Kette. Umschalt+Mausrad für horizontalen Schwenk."
Lang["Version"] = "Attune v##VERSION## von Cixi Delmont / Gaya Greyhoof"
Lang["Splash"] = "v##VERSION## von Cixi Delmont / Gaya Greyhoof. Gib /attune ein um zu starten."
Lang["Survey"] = "Umfrage"
Lang["Guild"] = "Gilde"
Lang["Party"] = "Gruppe"
Lang["Raid"] = "Schlachtzug"
Lang["Run an attunement survey (for people with the addon)"] = "Führe eine Statusumfrage für Spieler mit dem Addon durch"
Lang["Toggle between attunements and survey results"] = "Umschalten zwischen Zugängen und Umfrageergebnis" 
Lang["Close"] = "Schließen" 
Lang["Export"] = "Export"
Lang["My Data"] = "Meine Daten"
Lang["Last Survey"] = "Letzte Statusumfrage"
Lang["Guild Data"] = "Gilden Daten"
Lang["All Data"] = "Alle Daten"
Lang["Export your Attune data to the website"] = "Exportiere deine Attune Daten für die Website"
Lang["Copy the text below, then upload it to"] = "Kopiere den text unten und laden ihn dann hier hoch:"
Lang["Results"] = "Ergebnisse"
Lang["Not in a guild"] = "Nicht in einer Gilde"
Lang["Click on a header to sort the results"] = "Klicke auf die Kategorie um die Ergebnisse zu sortieren" 
Lang["Character"] = "Charakter" 
Lang["Characters"] = "Charakteren"
Lang["Last survey results"] = "Letzte Umfrageergebnisse"	
Lang["All FACTION results"] = "Alle ##FACTION## Ergebnisse"
Lang["Guild members"] = "Gildenmitglieder" 
Lang["All results"] = "Alle Ergebnisse" 
Lang["Minimum level"] = "Mindestlevel" 
Lang["Click to navigate to that attunement"] = "Klicken um zu diesem Zugang zu wechseln"
Lang["Click to show map"] = "Klicken für Belohnungen und Karte. Erneut klicken, um zurückzukehren."
Lang["Starts at"] = "Beginnt bei"
Lang["Attunes"] = "Zugänge"
Lang["Guild members on this step"] = "Gildenmitglieder mit dieser Quest"
Lang["Attuned guild members"] = "Gildenmitglieder mit dem Zugang"
Lang["Attuned alts"] = "Twinks mit dem Zugang"
Lang["Alts on this step"] = "Twinks mit dieser Quest"
Lang["Settings"] = "Einstellungen"
Lang["Survey Log"] = "Umfrage Log"
Lang["LeftClick"] = "Linksklick"
Lang["OpenAttune"] = "    Öffne Attune"
Lang["RightClick"] = "Rechtsklick"
Lang["OpenSettings"] = "  Öffne Einstellungen"
Lang["Addon disabled"] = "Addon deaktiviert"
Lang["StartAutoGuildSurvey"] = "Starte automatische Gildenumfrage im Hintergrund"
Lang["SendingDataTo"] = "Sende Attune Daten zu |cffffd100##NAME##|r"
Lang["NewVersionAvailable"] = "eine |cffffd100neue Version|r von Attune ist verfügbar, bitte aktualisiere das Addon!"
Lang["CompletedStep"] = "Schritt ##TYPE## |cffe4e400##STEP##|r für Zugang |cffe4e400##NAME##|r abgeschlossen."
Lang["AttuneComplete"] = "Zugang zu |cffe4e400##NAME##|r gewährt!"
Lang["AttuneCompleteGuild"] = "##NAME## Zugang erfolgreich!"
Lang["SendingSurveyWhat"] = "Sende ##WHAT## Umfrage"
Lang["SendingGuildSilentSurvey"] = "Sende Gildenumfrage im Hintergrund"
Lang["SendingYellSilentSurvey"] = "Sende Umfrage im Hintergrund"
Lang["ReceivedDataFromName"] = "Daten von |cffffd100##NAME##|r erhalten"
Lang["ExportingData"] = "Exportiere Attune Daten für ##COUNT## Charakter(e)"
Lang["ReceivedRequestFrom"] = "Umfrageanfrage von |cffffd100##FROM##|r erhalten"
Lang["Help1"] = "Dieses Addon ermöglicht das Aufzeichen und Exportieren deines Fortschrittes für Raidzugänge"
Lang["Help2"] = "Gib |cfffff700/attune|r ein um zu starten."
Lang["Help3"] = "Um deinen Gildenfortschritt zu sehen, klicke auf |cfffff700survey|r."
Lang["Help4"] = "Du erhälst Fortschrittsdaten von jedem Gildenmitglied mit diesem Addon"
Lang["Help5"] = "Wenn du genug Informationen gesammelt hast, klicke auf |cfffff700export|r um den Gildenfortschritt zu exportieren"
Lang["Help6"] = "Daten können auf |cfffff700https://warcraftratings.com/attune/upload|r hochgeladen werden"
Lang["Survey_DESC"] = "Führt eine Statusumfrage aus (für Spieler mit dem Addon)"
Lang["Export_DESC"] = "Exportiert deine Attune Daten für die Website"
Lang["Toggle_DESC"] = "Umschalten zwischen Umfrageergebnissen und Zugangsquests"
--Lang["PreferredLocale_TEXT"] = "Bervorzugte Sprache"
--Lang["PreferredLocale_DESC"] = "Wähle die Sprache in der du Attune nutzen möchtest. Das Addon muss danach neu geladen werden."
--v220
Lang["My Toons"] = "Meine Twinks"
Lang["No Target"] = "Sie haben kein Ziel"
Lang["No Response From"] = "Keine Antwort von ##PLAYER##"
Lang["Sync Request From"] = "Neue Attune Synchronisierungsanforderung von:\n\n##PLAYER##"
Lang["Could be slow"] = "Abhängig von der Datenmenge, die Sie haben, kann dies ein sehr langsamer Prozess sein"
Lang["Accept"] = "Akzeptieren"
Lang["Reject"] = "Ablehnen"
Lang["Busy right now"] = "##PLAYER## ist gerade beschäftigt, versuchen Sie es später noch einmal."
Lang["Sending Sync Request"] = "Senden einer Synchronisierungsanforderung an ##PLAYER##"
Lang["Request accepted, sending data to "] = "Anfrage angenommen, Daten an ##PLAYER## senden"
Lang["Received request from"] = "Anfrage von ##PLAYER## erhalten"
Lang["Request rejected"] = "Antrag abgelehnt"
Lang["Sync over"] = "Die Synchronisierung dauerte ##DURATION##"
Lang["Syncing Attune data with"] = "Synchronisieren von Attune-Daten mit ##PLAYER##"
Lang["Cannot sync while another sync is in progress"] = "Unmöglich, während eine weitere Synchronisierung ausgeführt wird"
Lang["Sync with target"] = "Mit Ziel synchronisieren"
Lang["Show Profiles"] = "Profile anzeigen"
Lang["Show Progress"] = "Fortschritt anzeigen"
Lang["Status"] = "Status"
Lang["Role"] = "Rolle"
Lang["Last Surveyed"] = "Zuletzt befragt"
Lang['Seconds ago'] = "vor ##DURATION## Sekunden"
Lang["Main"] = "Main"
Lang["Alt"] = "Twink"
Lang["Tank"] = "Tank"
Lang["Healer"] = "Healer"
Lang["Melee DPS"] = "Nahkampf-DPS"
Lang["Ranged DPS"] = "Fernkampf-DPS"
Lang["Bank"] = "Bank"
Lang["DelAlts_TEXT"] = "Alle Twinks löschen"
Lang["DelAlts_DESC"] = "Löschen Sie alle Informationen zu Spielern, die als Alts markiert sind"
Lang["DelAlts_CONF"] = "Wirklich alle Twinks löschen?"
Lang["DelAlts_DONE"] = "Alle Twinks gelöscht"
Lang["DelUnspecified_TEXT"] = "Nicht angegeben löschen"
Lang["DelUnspecified_DESC"] = "Löschen Sie alle Informationen zu Spielern mit einem nicht angegebenen Main/Twink Status"
Lang["DelUnspecified_CONF"] = "Löschen Sie wirklich alle Zeichen mit einem nicht angegebenen Main/Twink Status?"
Lang["DelUnspecified_DONE"] = "Alle nicht angegebenen Main/Twink Status wurden gelöscht"
--v221
Lang["Open Raid Planner"] = "Öffne Raid Planer"
Lang["Unspecified"] = "unbekannt"
Lang["Empty"] = "Leer"
Lang["Guildies only"] = "Nur Gildenmitglieder zeigen"
Lang["Show Alts"] = "Zeige Twinks"
Lang["Show Mains"] = "Zeige Mains"
Lang["Show Unspecified"] = "Zeige unbekannt"
Lang["Show Unattuned"] = "Zeige Spieler ohne Zugang"
Lang["Raid spots"] = "##SIZE## Raid Plätze"
Lang["Group Number"] = "Gruppe ##NUMBER##"
Lang["Move to next group"] = "    Schiebe in nächste Gruppe"
Lang["Remove from raid"] = "  Aus Raid entfernen"
Lang["Select a raid and click on players to add them in"] = "Wähle den Raid und klicke auf Spieler um sie hinzuzufügen"
Lang["Planner"] = "Planer"
--v224
Lang["Enter a new name for this raid group"] = "Geben Sie einen neuen Namen für diese Schlachtzugsgruppe ein"
Lang["Save"] = "Speichern"
--v226
Lang["Invite"] = "Einladen"
Lang["Send raid invites to all listed players?"] = "Raid-Einladungen an alle aufgelisteten Spieler senden?"
Lang["External link"] = "Link zu einer Online-Datenbank"
Lang["Quest rewards"] = "Questbelohnungen"
Lang["No item rewards"] = "Diese Quest hat keine Gegenstandsbelohnungen."
Lang["Rewards only if available"] = "Gegenstandbelohnungen werden nur für Quests angezeigt, die diesem Charakter zur Verfügung stehen."
Lang["Loading rewards"] = "Belohnungen werden geladen..."
Lang["Show link"] = "Link anzeigen"
Lang["Choose one reward"] = "Eines wählen"
--v243
Lang["Ogrila"] = "Ogri'la"
Lang["Ogri'la Quest Hub"] = "Ogri'la Quest-Hub"
Lang["Ogrila_Desc"] = "Die erleuchteten Bewohner von Ogri'la haben sich im Westen des Schergrats angesiedelt."
Lang["DelInactive_TEXT"] = "Inaktiv löschen"
Lang["DelInactive_DESC"] = "Löschen Sie alle Informationen über Spieler, die als inaktiv markiert sind"
Lang["DelInactive_CONF"] = "Wirklich alle Inaktiven löschen?"
Lang["DelInactive_DONE"] = "Alle Inaktiven gelöscht"
Lang["RAIDS"] = "Schlachtzüge"
Lang["KEYS"] = "Schlüssel"
Lang["MISC"] = "Sonstiges"
Lang["HEROICS"] = "Heroisch"
--v244
Lang["Ally of the Netherwing"] = "Verbündeter der Netherschwingen"
Lang["Netherwing_Desc"] = "Die Netherwing ist eine Drachenfraktion in der Scherbenwelt."
--v247
Lang["Tirisfal Glades"] = "Tirisfal"
Lang["Scholomance"] = "Scholomance"
--v248
Lang["Target"] = "Ziel"
Lang["SendingSurveyTo"] = "Umfrage wird an ##TO## gesendet"


-- OPTIONS
Lang["MinimapButton_TEXT"] = "Minimapknopf anzeigen"
Lang["MinimapButton_DESC"] = "Zeige den Minimapknopf an um schnell auf Attune zugreifen zu können."
Lang["FullMap_TEXT"] = "Vollständige Karte für Questgeber verwenden"
Lang["FullMap_DESC"] = "Beim Klick auf eine Quest wird die Weltkarte beim Questgeber geöffnet, statt eine Karte im Seitenbereich anzuzeigen. Die Questbelohnungen füllen dann den Seitenbereich."
Lang["AutoSurvey_TEXT"] = "Automatische Gildenumfrage bei Login"
Lang["AutoSurvey_DESC"] = "Bei jedem Login führt das Addon eine automatische Gildenumfrage durch."
Lang["ShowSurveyed_TEXT"] = "Zeige Umfragen an"
Lang["ShowSurveyed_DESC"] =  "Zeigt eine Chatnachricht wenn Umfragen empfangen und beantwortet wurden."
Lang["ShowResponses_TEXT"] = "Zeige Antworten auf Umfragen an"
Lang["ShowResponses_DESC"] = "Zeigt eine Chatnachricht für jede Antwort auf eine von mir gestartete Umfrage an."
Lang["ShowSetMessages_TEXT"] = "Zeige Fortschrittsnachrichten an"
Lang["ShowSetMessages_DESC"] = "Zeigt eine Chatnachricht für jeden Fortschritt einer Zugangsquest an."
Lang["AnnounceToGuild_TEXT"] = "Kündige fertige Zugangsquests in der Gilde an"
Lang["AnnounceToGuild_DESC"] = "Sendet eine Nachricht an die Gilde wenn eine Zugangsquest komplett abgeschlossen wurde."
Lang["ShowOther_TEXT"] = "Zeige andere Chatnachrichten"
Lang["ShowOther_DESC"] = "Zeigt andere generische Chatnachrichten an (z.B. gesendete Anfragen, Update verfügbar, etc)."
Lang["ShowGuildies_TEXT"] = "Zeige Gildenmitglieder in jedem Questfortschritt                Länge der Liste"  --this has a gap for the editbox
Lang["ShowGuildies_DESC"] = "Zeigt eine Liste der Gildenmitglieder in dieser Quest im Tooltip an.\nPasse die Anzahl der Gildenmitglieder an, wenn nötig."
Lang["ShowAltsInstead_TEXT"] = "Zeige die Liste der Twinks anstatt der Gildenmitglieder"
Lang["ShowAltsInstead_DESC"] = "Der Tooltip zeigt deine Twinks anstatt deiner Gildenmitglieder an"
Lang["ClearAll_TEXT"] = "Leere die Ergebnisliste"
Lang["ClearAll_DESC"] = "Löscht ALLE Daten über andere Spieler aus der lokalen Datenbank. Dieser Schritt kann nicht rückgängig gemacht werden!"
Lang["ClearAll_CONF"] = "Möchte du wirklich ALLE Daten löschen?"
Lang["ClearAll_DONE"] = "Alle Daten gelöscht!"
Lang["DelNonGuildies_TEXT"] = "Lösche Spieler (ausser Gilde)"
Lang["DelNonGuildies_DESC"] = "Lösche alle Daten von Spieler ausserhalb deiner Gilde."
Lang["DelNonGuildies_CONF"] = "Wirklich ALLE Daten von Spieler ausserhalb der Gilde löschen?"
Lang["DelNonGuildies_DONE"] = "Alle Daten (ausser Gilde) gelöscht!"
Lang["DelUnder60_TEXT"] = "Lösche Spieler unter Level 60"
Lang["DelUnder60_DESC"] = "Lösche alle Daten von Spielern unter Level 60."
Lang["DelUnder60_CONF"] = "Wirklich ALLE Daten von Spieler unter 60 löschen?"
Lang["DelUnder60_DONE"] = "Alle Spieler unter 60 gelöscht."
Lang["DelUnder70_TEXT"] = "Lösche Spieler unter Level 70"
Lang["DelUnder70_DESC"] = "Lösche alle Daten von Spielern unter Level  70."
Lang["DelUnder70_CONF"] = "Wirklich ALLE Daten von Spieler unter 70 löschen?"
Lang["DelUnder70_DONE"] = "Alle Spieler unter 70 gelöscht."


-- TREEVIEW
Lang["World of Warcraft"] = "World of Warcraft"
Lang["The Burning Crusade"] = "The Burning Crusade"
Lang["Molten Core"] = "Geschmolzener Kern"
Lang["Onyxia's Lair"] = "Onyxias Hort"
Lang["Blackwing Lair"] = "Pechschwingenhort"
Lang["Naxxramas"] = "Naxxramas"
Lang["Scepter of the Shifting Sands"] = "Szepter der Sandstürme"
Lang["Shadow Labyrinth"] = "Schattenlabyrinth"
Lang["The Shattered Halls"] = "Die zerschmetterten Hallen"
Lang["The Arcatraz"] = "Die Arkatraz"
Lang["The Black Morass"] = "Der schwarze Morast"
Lang["Thrallmar Heroics"] = "Thrallmar"
Lang["Honor Hold Heroics"] = "Ehrenfeste"
Lang["Cenarion Expedition Heroics"] = "Expedition des Cenarius"
Lang["Lower City Heroics"] = "Unteres Viertel"
Lang["Sha'tar Heroics"] = "Sha'tar"
Lang["Keepers of Time Heroics"] = "Hüter der Zeit"
Lang["Nightbane"] = "Schrecken der Nacht"
Lang["Karazhan"] = "Karazhan"
Lang["Serpentshrine Cavern"] = "Höhle des Schlangenschreins"
Lang["The Eye"] = "Das Auge"
Lang["Mount Hyjal"] = "Schlacht um den Hyjal"
Lang["Black Temple"] = "Der schwarze Tempel"
Lang["MC_Desc"] = "Alle Mitglieder der Raidgruppe müssen den Zugang haben oder über den Eingang in den Schwarzfelstiefen in den Raid gehen" 
Lang["Ony_Desc"] = "Alle Mitglieder der Raidgruppe müssen den Zugang haben sowie das Drachenfeueramulett bei sich tragen um den Raid betreten zu können."
Lang["BWL_Desc"] = "Alle Mitglieder der Raidgruppe müssen den Zugang haben oder über den Eingang in den Obere Schwarzfelsspitze in den Raid gehen" 
Lang["All_Desc"] = "Alle Mitglieder der Raidgruppe müssen den Zugang haben um den Raid zu betreten."
Lang["AQ_Desc"] = "Nur ein Spieler des Servers muss die Quest abschließen um die Tore von Ahn´Qiraji zu öffnen."
Lang["OnlyOne_Desc"] = "Nur ein Spieler der Gruppe muss den Schlüssel haben. Ein Schurke mit 350 Schlösser knacken kann die Tür ebenfalls öffnen."
Lang["Heroic_Desc"] = "Alle Mitglieder der Gruppe müssen sowohl den Ruf als auch den Schlüssel haben um die Instanz zu betreten"
Lang["NB_Desc"] = "Nur ein Mitglied des Raids benötigt die Urne um den Schrecken der Nacht zu beschwören."
Lang["BT_Desc"] = "Alle Mitglieder des Raids müssen das Medaillion von Karabor dabei haben um den Raid zu betreten."
Lang["BM_Desc"] = "Alle Mitglieder der Gruppe müssen die Questkette abschließen, um in die Instanz einzusteigen." 
--v250
Lang["Aqual Quintessence"] = "Wässrige Quintessenz"
Lang["MC2_Desc"] = "Wird verwendet, um Majordomus Executus zu beschwören. Jeder Boss in Molten Core außer Lucifron und Geddon hat Runen auf dem Boden, die gelöscht werden müssen, damit Executus spawnen kann." 


-- GENERIC
Lang["Reach level"] = "Erreiche Level"
Lang["Attuned"] = "Abgeschlossen"
Lang["Not attuned"] = "Nicht abgeschlossen"
Lang["AttuneColors"] = "Blau: Freigeschaltet\nRot:  Nicht freigeschaltet"
Lang["Minimum Level"] = "Mindestlevel um die Quest zu erhalten"
Lang["NPC Not Found"] = "NPC Information nicht gefunden"
Lang["Level"] = "Level"
Lang["Exalted with"] = "Ehrfürchtig"
Lang["Revered with"] = "Respektvoll"
Lang["Honored with"] = "Wohlwollend"
Lang["Friendly with"] = "Freundlich"
Lang["Neutral with"] = "Neutral"
Lang["Quest"] = "Quest"
Lang["Pick Up"] = "Annehmen"
Lang["Inside"] = "Innen"
Lang["Inside the dungeon"] = "Im Dungeon"
Lang["Turn In"] = "Abgeben"
Lang["Kill"] = "Töte"
Lang["Interact"] = "Interagiere"
Lang["Item"] = "Item"
Lang["Required level"] = "Benötigtes Level"
Lang["Requires level"] = "benötigt Level"
Lang["Attunement or key"] = "Zugang oder Schlüssel"
Lang["Reputation"] = "Ruf"
Lang["in"] = "in"
Lang["Unknown Reputation"] = "Unbekannter Ruf"
Lang["Current progress"] = "Aktueller Fortschritt"
Lang["Completion"] = "Abschluss"
Lang["Quest information not found"] = "Quest Informationen nicht gefunden"
Lang["Information not found"] = "Informationen nicht gefunden"
Lang["Solo quest"] = "Solo Quest"
Lang["Party quest"] = "Gruppen Quest (##NB## Spieler)"
Lang["Raid quest"] = "Raid Quest (##NB## Spieler)"
Lang["HEROIC"] = "Heroisch"
Lang["Elite"] = "Elite"
Lang["Boss"] = "Boss"
Lang["Rare Elite"] = "Elite (Selten)"
Lang["Dragonkin"] = "Drachkin"
Lang["Troll"] = "Troll"
Lang["Ogre"] = "Oger"
Lang["Orc"] = "Ork"
Lang["Half-Orc"] = "Halb-Ork"
Lang["Dragonkin (in Blood Elf form)"] = "Drachkin (in Blutelfenform)"
Lang["Human"] = "Mensch"
Lang["Dwarf"] = "Zwerg"
Lang["Mechanical"] = "Mechanisch"
Lang["Arakkoa"] = "Arakkoa"
Lang["Dragonkin (in Humanoid form)"] = "Drachkin (in Menschenform)"
Lang["Ethereal"] = "Etherwesen"
Lang["Blood Elf"] = "Blutelf"
Lang["Elemental"] = "Elementar"
Lang["Shiny thingy"] = "Glitzerdings"
Lang["Naga"] = "Naga"
Lang["Demon"] = "Dämon"
Lang["Gronn"] = "Gronn"
Lang["Undead (in Dragon form)"] = "Untoter (in Drachenform)"
Lang["Tauren"] = "Taure"
Lang["Qiraji"] = "Qiraji"
Lang["Gnome"] = "Gnom"
Lang["Broken"] = "Broken"
Lang["Draenei"] = "Draenei"
Lang["Undead"] = "Untoter"
Lang["Gorilla"] = "Gorilla"
Lang["Shark"] = "Hai"
Lang["Chimaera"] = "Chimaere"
Lang["Wisp"] = "Irrwisch"
Lang["Night-Elf"] = "Nachtelf"


-- REP
Lang["Argent Dawn"] = "Argentumdämmerung"
Lang["Brood of Nozdormu"] = "Brut Nozdormus"
Lang["Thrallmar"] = "Thrallmar"
Lang["Honor Hold"] = "Ehrenfeste"
Lang["Cenarion Expedition"] = "Expedition des Cenarius"
Lang["Lower City"] = "Unteres Viertel"
Lang["The Sha'tar"] = "Sha'tar"
Lang["Keepers of Time"] = "Hüter der Zeit"
Lang["The Violet Eye"] = "Das violette Auge"
Lang["The Aldor"] = "Die Aldor"
Lang["The Scryers"] = "Die Seher"


-- LOCATIONS
Lang["Blackrock Mountain"] = "Der Schwarzfels"
Lang["Blackrock Depths"] = "Schwarzfelstiefen"
Lang["Badlands"] = "Ödland"
Lang["Lower Blackrock Spire"] = "Untere Schwarzfelsspitze"
Lang["Upper Blackrock Spire"] = "Obere Schwarzfelsspitze"
Lang["Orgrimmar"] = "Orgrimmar"
Lang["Western Plaguelands"] = "Westliche Pestländer"
Lang["Desolace"] = "Desolace"
Lang["Dustwallow Marsh"] = "Marschen von Dustwallow"
Lang["Tanaris"] = "Tanaris"
Lang["Winterspring"] = "Winterspring"
Lang["Swamp of Sorrows"] = "Sümpfe des Elends"
Lang["Wetlands"] = "Sumpfland"
Lang["Burning Steppes"] = "Brennende Steppe"
Lang["Redridge Mountains"] = "Rotkammgebirge"
Lang["Stormwind City"] = "Stormwind"
Lang["Eastern Plaguelands"] = "Östliche Pestländer"
Lang["Silithus"] = "Silithus"
Lang["The Temple of Atal'Hakkar"] = "Der Tempel von Atal'Hakkar"
Lang["Teldrassil"] = "Teldrassil"
Lang["Moonglade"] = "Moonglade"
Lang["Hinterlands"] = "Hinterland"
Lang["Ashenvale"] = "Ashenvale"
Lang["Feralas"] = "Feralas"
Lang["Duskwood"] = "Dunkelhain"
Lang["Azshara"] = "Azshara"
Lang["Blasted Lands"] = "Verwüstete Lande"
Lang["Undercity"] = "Undercity"
Lang["Silverpine Forest"] = "Silberwald"
Lang["Shadowmoon Valley"] = "Schattenmondtal"
Lang["Hellfire Peninsula"] = "Höllenfeuerhalbinsel"
Lang["Sethekk Halls"] = "Sethekkhallen"
Lang["Caverns Of Time"] = "Höhlen der Zeit"
Lang["Netherstorm"] = "Nethersturm"
Lang["Shattrath City"] = "Shattrath"
Lang["The Mechanaar"] = "Die Mechanaar"
Lang["The Botanica"] = "Die Botanica"
Lang["Zangarmarsh"] = "Zangarmarschen"
Lang["Terokkar Forest"] = "Wälder von Terokkar"
Lang["Deadwind Pass"] = "Gebirgspass der Totenwinde"
Lang["Alterac Mountains"] = "Alteracgebirge"
Lang["The Steamvault"] = "Die Dampfkammer"
Lang["Slave Pens"] = "Die Sklavenunterkünfte"
Lang["Gruul's Lair"] = "Gruuls Unterschlupf"
Lang["Magtheridon's Lair"] = "Magtheridons Kammer"
Lang["Zul'Aman"] = "Zul'Aman"
Lang["Sunwell Plateau"] = "Sonnenbrunnenplateau"



-- ITEMS
Lang["Drakkisath's Brand"] = "Drakkisaths Brandzeichen"
Lang["Crystalline Tear"] = "Kristalline Träne"
Lang["I_18412"] = "Kernfragment"			-- https://de.classic.wowhead.com/item=18412/kernfragment
Lang["I_12562"] = "Wichtige Blackrockdokumente"			-- https://de.classic.wowhead.com/item=12562/wichtige-blackrockdokumente
Lang["I_16786"] = "Schwarzes Drachenbrutauge"			-- https://de.classic.wowhead.com/item=16786/schwarzes-drachenbrutauge
Lang["I_11446"] = "Eine zusammengeknüllte Notiz"			-- https://de.classic.wowhead.com/item=11446/eine-zusammengekn%C3%BCllte-notiz
Lang["I_11465"] = "Marschal Windsors verlorene Informationen"			-- https://de.classic.wowhead.com/item=11465/marshal-windsors-verlorene-informationen
Lang["I_11464"] = "Marschal Windsors verlorene Informationen"			-- https://de.classic.wowhead.com/item=11464/marshal-windsors-verlorene-informationen
Lang["I_18987"] = "Blackhands Befehl"			-- https://de.classic.wowhead.com/item=18987/blackhands-befehl
Lang["I_20383"] = "Kopf des Brutwächters Dreschbringer"			-- https://de.classic.wowhead.com/item=20383/kopf-des-brutw%C3%A4chters-dreschbringer
Lang["I_21138"] = "Roter Szeptersplitter"			-- https://de.classic.wowhead.com/item=21138
Lang["I_21146"] = "Verderbnisfragment des Alptraums"			-- https://de.classic.wowhead.com/item=21146
Lang["I_21147"] = "Verderbnisfragment des Alptraums"			-- https://de.classic.wowhead.com/item=21147
Lang["I_21148"] = "Verderbnisfragment des Alptraums"			-- https://de.classic.wowhead.com/item=21148
Lang["I_21149"] = "Verderbnisfragment des Alptraums"			-- https://de.classic.wowhead.com/item=21149
Lang["I_21139"] = "Grüner Szeptersplitter"			-- https://de.classic.wowhead.com/item=21139
Lang["I_21103"] = "Drachisch für Dummies - Kapitel I"			-- https://de.classic.wowhead.com/item=21103
Lang["I_21104"] = "Drachisch für Dummies - Kapitel II"			-- https://de.classic.wowhead.com/item=21104
Lang["I_21105"] = "Drachisch für Dummies - Kapitel III"			-- https://de.classic.wowhead.com/item=21105
Lang["I_21106"] = "Drachisch für Dummies - Kapitel IV"			-- https://de.classic.wowhead.com/item=21106
Lang["I_21107"] = "Drachisch für Dummies - Kapitel V"			-- https://de.classic.wowhead.com/item=21107
Lang["I_21108"] = "Drachisch für Dummies - Kapitel VI"			-- https://de.classic.wowhead.com/item=21108
Lang["I_21109"] = "Drachisch für Dummies - Kapitel VII"			-- https://de.classic.wowhead.com/item=21109
Lang["I_21110"] = "Drachisch für Dummies - Kapitel VIII"			-- https://de.classic.wowhead.com/item=21110
Lang["I_21111"] = "Drachisch für Dummies: Band 2"			-- https://de.classic.wowhead.com/item=21111
Lang["I_21027"] = "Lakmaerans Kadaver"			-- https://de.classic.wowhead.com/item=21027
Lang["I_21024"] = "Chimaeroklenden"			-- https://de.classic.wowhead.com/item=21024
Lang["I_20951"] = "Narains Wahrsagerbrille"			-- https://de.classic.wowhead.com/item=20951
Lang["I_21137"] = "Blauer Szeptersplitter"			-- https://de.tbc.wowhead.com/item=21137
Lang["I_21175"] = "Das Szepter der Sandstürme"			-- https://de.tbc.wowhead.com/item=21175
Lang["I_31241"] = "Präparierte Schlüsselform"			-- https://de.tbc.wowhead.com/item=31241
Lang["I_31239"] = "Präparierte Schlüsselform"			-- https://de.tbc.wowhead.com/item=31239
Lang["I_27991"] = "Schlüssel des Schattenlabyrinths"			-- https://de.tbc.wowhead.com/item=27991
Lang["I_31086"] = "Unteres Fragment des Schlüssels zur Arkatraz"			-- https://de.tbc.wowhead.com/item=31086
Lang["I_31085"] = "Oberes Fragment des Schlüssels zur Arkatraz"			-- https://de.tbc.wowhead.com/item=31085
Lang["I_31084"] = "Schlüssel zur Arkatraz"			-- https://de.tbc.wowhead.com/item=31084
Lang["I_30637"] = "Flammengeschmiedeter Schlüssel"			-- https://de.tbc.wowhead.com/item=30637
Lang["I_30622"] = "Flammengeschmiedeter Schlüssel"			-- https://de.tbc.wowhead.com/item=30622
Lang["I_30623"] = "Schlüssel des Kessels"			-- https://de.tbc.wowhead.com/item=30623
Lang["I_30633"] = "Schlüssel der Auchenai"			-- https://de.tbc.wowhead.com/item=30633
Lang["I_30634"] = "Warpgeschmiedeter Schlüssel"			-- https://de.tbc.wowhead.com/item=30634
Lang["I_30635"] = "Schlüssel der Zeit"			-- https://de.tbc.wowhead.com/item=30635
Lang["I_185686"] = "Flammengeschmiedeter Schlüssel"			-- https://de.tbc.wowhead.com/item=30637
Lang["I_185687"] = "Flammengeschmiedeter Schlüssel"			-- https://de.tbc.wowhead.com/item=30622
Lang["I_185690"] = "Schlüssel des Kessels"			-- https://de.tbc.wowhead.com/item=30623
Lang["I_185691"] = "Schlüssel der Auchenai"			-- https://de.tbc.wowhead.com/item=30633
Lang["I_185692"] = "Warpgeschmiedeter Schlüssel"			-- https://de.tbc.wowhead.com/item=30634
Lang["I_185693"] = "Schlüssel der Zeit"			-- https://de.tbc.wowhead.com/item=30635
Lang["I_24514"] = "Erstes Schlüsselfragment"			-- https://de.tbc.wowhead.com/item=24514
Lang["I_24487"] = "Zweites Schlüsselfragment"			-- https://de.tbc.wowhead.com/item=24487
Lang["I_24488"] = "Drittes Schlüsselfragment"			-- https://de.tbc.wowhead.com/item=24488
Lang["I_24490"] = "Der Schlüssel des Meisters"			-- https://de.tbc.wowhead.com/item=24490
Lang["I_23933"] = "Medivhs Tagebuch"			-- https://de.tbc.wowhead.com/item=23933
Lang["I_25462"] = "Dämmerfoliant"			-- https://de.tbc.wowhead.com/item=25462
Lang["I_25461"] = "Buch der vergessenen Namen"			-- https://de.tbc.wowhead.com/item=25461
Lang["I_24140"] = "Geschwärzte Urne"			-- https://de.tbc.wowhead.com/item=24140
Lang["I_31750"] = "Erdensiegel"			-- https://de.tbc.wowhead.com/item=31750
Lang["I_31751"] = "Flammensiegel"			-- https://de.tbc.wowhead.com/item=31751
Lang["I_31716"] = "Unbenutzte Axt des Henkers"			-- https://de.tbc.wowhead.com/item=31716
Lang["I_31721"] = "Kalithreshs Dreizack"			-- https://de.tbc.wowhead.com/item=31721
Lang["I_31722"] = "Murmurs Essenz"			-- https://de.tbc.wowhead.com/item=31722
Lang["I_31704"] = "Schlüssel der Stürme"			-- https://de.tbc.wowhead.com/item=31704
Lang["I_29905"] = "Überreste von Kaels Phiole"			-- https://de.tbc.wowhead.com/item=29905
Lang["I_29906"] = "Überreste von Vashjs Phiole"			-- https://de.tbc.wowhead.com/item=29906
Lang["I_31307"] = "Herz des Zorns"			-- https://de.tbc.wowhead.com/item=31307
Lang["I_32649"] = "Medaillon von Karabor"			-- https://de.tbc.wowhead.com/item=32649
--v247
Lang["Shrine of Thaurissan"] = "Schrein von Thaurissan"
Lang["I_14610"] = "Arajs Skarabäus"
--v250
Lang["I_17332"] = "Hand von Shazzrah"
Lang["I_17329"] = "Hand von Lucifron"
Lang["I_17331"] = "Hand von Gehennas"
Lang["I_17330"] = "Hand von Sulfuron"
Lang["I_17333"] = "Wässrige Quintessenz"
-- Wailing Caverns
Lang["I_5334"] = "99 Jahre alter Portwein"
Lang["I_5339"] = "Schlangenflaum"
Lang["I_6443"] = "Deviatbalg"
Lang["I_6464"] = "Klageessenz"
-- Shadowfang Keep
Lang["I_5442"] = "Arugals Kopf"
Lang["I_5535"] = "Kompendium der Gefallenen"
Lang["I_5536"] = "Mythologie der Titanen"
Lang["I_5538"] = "Vorrels Ehering"
Lang["I_5805"] = "Herz des Eifers"
Lang["I_5861"] = "Anfänge der Bedrohung durch die Untoten"
Lang["I_6283"] = "Das Buch von Ur"
-- Blackfathom Deeps
Lang["I_5359"] = "Lorgalis-Manuskript"
Lang["I_5952"] = "Verderbter Hirnstamm"
Lang["I_5879"] = "Twilightanhänger"
Lang["I_5881"] = "Kopf von Kelris"
Lang["I_16762"] = "Fathomkern"
Lang["I_16784"] = "Saphir von Aku'Mai"
Lang["I_16790"] = "Feuchte Notiz"
-- Gnomeregan
Lang["I_9278"] = "Grundlegendes Artifix"
Lang["I_9309"] = "Robomechanische Gedärme"
Lang["I_9284"] = "Volle bleierne Sammelphiole"
Lang["I_9277"] = "Techbots Speicherkern"
Lang["I_9153"] = "Maschinenblaupausen"
Lang["I_9299"] = "Thermapluggs Safekombination"
-- Razorfen Kraul
Lang["I_5801"] = "Kral-Guano"
Lang["I_5825"] = "Treshalas Anhänger"
Lang["I_5793"] = "Razorflanks Herz"
Lang["I_5792"] = "Razorflanks Medaillon"
Lang["I_5876"] = "Blaulaubknolle"


-- QUESTS - Classic
Lang["Q1_7848"] = "Abstimmung mit dem Kern"			-- https://de.classic.wowhead.com/quest=7848
Lang["Q2_7848"] = "Begebt Euch zum Portal in den Blackrocktiefen, das in den geschmolzenen Kern führt, und findet ein Kernfragment. Kehrt mit dem Fragment zu Lothos Riftwaker am Blackrock zurück. "
Lang["Q1_4903"] = "Befehl des Kriegsherrn"			-- https://de.classic.wowhead.com/quest=4903
Lang["Q2_4903"] = "Tötet Hochlord Omokk, Kriegsmeister Voone und Oberanführer Wyrmthalak. Findet die wichtigen Blackrockdokumente. Kehrt zum Kriegsherrn Goretooth nach Kargath zurück, sobald Ihr diese Mission erledigt habt."
Lang["Q1_4941"] = "Eitriggs Weisheit"			-- https://de.classic.wowhead.com/quest=4941
Lang["Q2_4941"] = "Sprecht mit Etrigg in Orgrimmar. Wenn Ihr die Angelegenheit mit Etrigg besprochen habt, bittet Thrall um Rat.\n\nIhr erinnert Euch, dass Ihr Etrigg in Thralls Gemächern gesehen habt."
Lang["Q1_4974"] = "Für die Horde!"			-- https://de.classic.wowhead.com/quest=4974
Lang["Q2_4974"] = "Begebt Euch zur Blackrockspitze und tötet den Kriegshäuptling Rend Blackhand. Nehmt seinen Kopf und kehrt nach Orgrimmar zurück. "
Lang["Q1_6566"] = "Was der Wind erzählt"			-- https://de.classic.wowhead.com/quest=6566
Lang["Q2_6566"] = "Hört Thrall zu."
Lang["Q1_6567"] = "Der Champion der Horde"			-- https://de.classic.wowhead.com/quest=6567
Lang["Q2_6567"] = "Sucht Rexxar auf. Der Kriegshäuptling hat Euch erklärt, wo Ihr ihn finden könnt. Sucht die Wege von Desolace zwischen dem Steinkrallengebirge und Feralas ab. "
Lang["Q1_6568"] = "Nachricht von Rexxar"			-- https://de.classic.wowhead.com/quest=6568
Lang["Q2_6568"] = "Überbringt Myranda der Vettel in den westlichen Pestländern Rexxars Nachricht."
Lang["Q1_6569"] = "Oculus-Illusionen"			-- https://de.classic.wowhead.com/quest=6569
Lang["Q2_6569"] = "Reist zur Blackrockspitze und sammelt 20 schwarze Drachenbrutaugen. Kehrt zu Myranda der Vettel zurück, sobald Ihr die Aufgabe erfüllt habt. "
Lang["Q1_6570"] = "Aschenschwinge"			-- https://de.classic.wowhead.com/quest=6570
Lang["Q2_6570"] = "Reist zum Drachensumpf in den Marschen von Dustwallow und begebt Euch in Aschenschwinges Bau. Sobald Ihr darin seid, tragt das Amulett der drachischen Subversion und sprecht mit Aschenschwinge."
Lang["Q1_6584"] = "Die Prüfung der Schädel, Chronalis"			-- https://de.classic.wowhead.com/quest=6584
Lang["Q2_6584"] = "Chronalis, ein Kind Nozdormus, bewacht die Höhlen der Zeit in der Tanariswüste. Vernichtet ihn und bringt seinen Schädel zu Aschenschwinge. "
Lang["Q1_6582"] = "Die Prüfung der Schädel, Scryer"			-- https://de.classic.wowhead.com/quest=6582
Lang["Q2_6582"] = "Ihr müsst Scryer, den Champion der blauen Großdrachen, finden und ihn töten. Schlagt seinem Kadaver den Schädel ab und bringt ihn zu Aschenschwinge.\n\nIhr wisst, dass Scryer in Winterspring zu finden ist."
Lang["Q1_6583"] = "Die Prüfung der Schädel, Somnus"			-- https://de.classic.wowhead.com/quest=6583
Lang["Q2_6583"] = "Vernichtet den Drachenchampion des grünen Drachenschwarms, Somnus. Nehmt seinen Schädel und bringt ihn zu Aschenschwinge zurück."
Lang["Q1_6585"] = "Die Prüfung der Schädel, Axtroz"			-- https://de.classic.wowhead.com/quest=6585
Lang["Q2_6585"] = "Begebt Euch nach Grim Batol und spürt Axtroz auf, den Drachenchampion des Roten Drachenschwarms. Vernichtet ihn und nehmt seinen Schädel. Bringt den Schädel zu Aschenschwinge zurück. "
Lang["Q1_6601"] = "Aufstieg..."			-- https://de.classic.wowhead.com/quest=6601
Lang["Q2_6601"] = "Mir scheint, als sei die Charade jetzt vorüber. Ihr wisst, dass das Amulett der drachischen Unterwanderung, das Myranda die Vettel für Euch erschuf, auf der Blackrockspitze nicht funktioniert. Vielleicht solltet Ihr Rexxar aufsuchen und ihm Eure Notlage erklären. Zeigt ihm das glanzlose Drachenfeueramulett. Er wird hoffentlich wissen, was als Nächstes zu tun ist."
Lang["Q1_6602"] = "Blut des schwarzen Großdrachen-Helden"			-- https://de.classic.wowhead.com/quest=6602
Lang["Q2_6602"] = "Begebt Euch zur Blackrockspitze und tötet General Drakkisath. Sammelt sein Blut und bringt es zu Rexxar."
Lang["Q1_4182"] = "Drachkin Bedrohung"			-- https://de.classic.wowhead.com/quest=4182
Lang["Q2_4182"] = "Erschlagt 15 schwarze Brutlinge, 10 Exemplare der schwarzen Großdrachenbrut, 4 schwarze Wyrmkin und 1 Schwarzdrachen. Kehrt zu Helendis Riverhorn zurück, sobald die Aufgabe erledigt ist."
Lang["Q1_4183"] = "Die wahren Meister"			-- https://de.classic.wowhead.com/quest=4183
Lang["Q2_4183"] = "Reist nach Seenhain und händigt Magistrat Solomon Helendis Riverhorns Brief aus."
Lang["Q1_4184"] = "Die wahren Meister"			-- https://de.classic.wowhead.com/quest=4184
Lang["Q2_4184"] = "Reist nach Stormwind und tragt Solomons Hilfegesuch dem Hochlord Bolvar Fordragon vor.\n\nBolvar residiert in der Burg Stormwind. ."
Lang["Q1_4185"] = "Die wahren Meister"			-- https://de.classic.wowhead.com/quest=4185
Lang["Q2_4185"] = "Sprecht zuerst mit Lady Katrana Prestor, dann mit Hochlord Bolvar Fordragon."
Lang["Q1_4186"] = "Die wahren Meister"			-- https://de.classic.wowhead.com/quest=4186
Lang["Q2_4186"] = "Händigt Bolvars Erlass an Magistrat Solomon in Seenhain aus."
Lang["Q1_4223"] = "Die wahren Meister"			-- https://de.classic.wowhead.com/quest=4223
Lang["Q2_4223"] = "Sprecht mit Marshal Maxwell in der brennenden Steppe."
Lang["Q1_4224"] = "Die wahren Meister"			-- https://de.classic.wowhead.com/quest=4224
Lang["Q2_4224"] = "Sprecht mit dem struppigen John, um etwas über Marshal Windsors Schicksal zu erfahren, und kehrt dann zu Marshal Maxwell zurück, wenn Ihr diese Aufgabe erledigt habt.\n\nIhr erinnert Euch daran, dass Marshal Maxwell Euch geraten hat, ihn in einer Höhle im Norden zu suchen."
Lang["Q1_4241"] = "Marshal Windsor"			-- https://de.classic.wowhead.com/quest=4241
Lang["Q2_4241"] = "Reist zum Blackrock im Nordwesten und dann weiter zu den Blackrocktiefen. Findet heraus, was aus Marshal Windsor geworden ist.\n\nIhr erinnert Euch daran, dass der struppige John sagte, man hätte Windsor in ein Gefängnis verschleppt. "
Lang["Q1_4242"] = "Verlorene Hoffnung"			-- https://de.classic.wowhead.com/quest=4242
Lang["Q2_4242"] = "Überbringt Marshal Maxwell die schlechten Neuigkeiten. "
Lang["Q1_4264"] = "Eine zusammengeknüllte Notiz"			-- https://de.classic.wowhead.com/quest=4264
Lang["Q2_4264"] = "Soeben seid Ihr auf etwas gestoßen, das Marshal Windsor mit Sicherheit sehr interessiert. Vielleicht besteht ja doch noch Hoffnung."
Lang["Q1_4282"] = "Ein Funken Hoffnung"			-- https://de.classic.wowhead.com/quest=4282
Lang["Q2_4282"] = "Holt Marshal Windsors verloren gegangene Informationen zurück.\n\nMarshal Windsor glaubt, dass sich die Informationen in den Händen des Golemlords Argelmach und des Generals Zornesschmied befinden. "
Lang["Q1_4322"] = "Gefängnisausbruch!"			-- https://de.classic.wowhead.com/quest=4322
Lang["Q2_4322"] = "Helft Marshal Windsor, seine Ausrüstung zurückzuholen und seine Freunde zu befreien. Kehrt zu Marshal Windsor zurück, wenn Ihr Erfolg hattet."
Lang["Q1_6402"] = "Treffen in Stormwind"			-- https://de.classic.wowhead.com/quest=6402
Lang["Q2_6402"] = "Reist nach Stormwind und begebt Euch zu den Stadttoren. Sprecht mit Knappe Rowe, damit er Marshal Windsor über Eure Ankunft informiert."
Lang["Q1_6403"] = "Die große Maskerade"			-- https://de.classic.wowhead.com/quest=6403
Lang["Q2_6403"] = "Folgt Reginald Windsor durch Stormwind. Schützt ihn vor Gefahren!"
Lang["Q1_6501"] = "Das Großdrachenauge"			-- https://de.classic.wowhead.com/quest=6501
Lang["Q2_6501"] = "Ihr müsst die Welt nach jemandem absuchen, der fähig ist, die Macht des Fragments des Großdrachenauges wieder herzustellen. Die einzige Information, die Ihr über ein solches Wesen besitzt ist, dass es existiert."
Lang["Q1_6502"] = "Drachenfeueramulett"			-- https://de.classic.wowhead.com/quest=6502
Lang["Q2_6502"] = "Ihr müsst das Blut des schwarzen Großdrachen-Helden von General Drakkisath bekommen. Ihr findet Drakkisath in seinem Thronsaal hinter den Hallen des Aufstiegs auf der Blackrockspitze."
Lang["Q1_7761"] = "Blackhands Befehl"			-- https://de.classic.wowhead.com/quest=7761
Lang["Q2_7761"] = "Das war ja vielleicht mal ein dummer Orc. Es sieht so aus, als müsstet Ihr dieses Brandzeichen finden, um an das Mal von Drakkisath zu gelangen. Damit sollte sich die Befehlskugel aktivieren lassen.\n\nDem Brief zufolge, wird das Brandzeichen von General Drakkisath bewacht. Vielleicht solltet Ihr diesem Hinweis nachgehen. "
Lang["Q1_9121"] = "Die Zitadelle des Schreckens - Naxxramas" 	-- https://de.classic.wowhead.com/quest=9121
Lang["Q2_9121"] = "Erzmagierin Angela Dosantos bei der Kapelle des hoffnungsvollen Lichts in den östlichen Pestländern möchte 5 Arkankristalle, 2 Nexuskristalle, 1 rechtschaffene Kugel und 60 Goldstücke. Euer Ruf bei der Argentumdämmerung muss außerdem wohlwollend sein."
Lang["Q1_9122"] = "Die Zitadelle des Schreckens - Naxxramas"			-- https://de.classic.wowhead.com/quest=9122
Lang["Q2_9122"] = "Erzmagierin Angela Dosantos bei der Kapelle des hoffnungsvollen Lichts in den östlichen Pestländern möchte 2 Arkankristalle, 1 Nexuskristall und 30 Goldstücke. Euer Ruf bei der Argentumdämmerung muss außerdem respektvoll sein. "
Lang["Q1_9123"] = "Die Zitadelle des Schreckens - Naxxramas"			-- https://de.classic.wowhead.com/quest=9123
Lang["Q2_9123"] = "Erzmagierin Angela Dosantos bei der Kapelle des hoffnungsvollen Lichts in den östlichen Pestländern wird Euch die arkane Tarnung kostenfrei gewähren. Euer Ruf bei der Argentumdämmerung muss ehrfürchtig sein. "
Lang["Q1_8286"] = "Was uns morgen erwartet"			-- https://de.classic.wowhead.com/quest=8286
Lang["Q2_8286"] = "Reist zu den Höhlen der Zeit in Tanaris und findet Anachronos, Nachkomme Nozdormus. "
Lang["Q1_8288"] = "Nur einer kann sich erheben"			-- https://de.classic.wowhead.com/quest=8288
Lang["Q2_8288"] = "Bringt Brutwächter Dreschbringers Kopf zu Baristolth der Sandstürme in die Burg Cenarius in Silithus."
Lang["Q1_8301"] = "Der Pfad des Gerechten"			-- https://de.classic.wowhead.com/quest=8301
Lang["Q2_8301"] = "Kehrt zu Baristolth zurück, sobald Ihr 200 Silithidenknochenpanzerfragmente gesammelt habt. "
Lang["Q1_8303"] = "Anachronos"			-- https://de.classic.wowhead.com/quest=8303
Lang["Q2_8303"] = "Sucht nach Anachronos bei den Höhlen der Zeit in Tanaris. "
Lang["Q1_8305"] = "Lang Vergessenes"			-- https://de.classic.wowhead.com/quest=8305
Lang["Q2_8305"] = "Sucht die Kristallträne und blickt in ihr Innerstes."
Lang["Q1_8519"] = "Eine Spielfigur auf dem Schachbrett der Ewigkeit"			-- https://de.classic.wowhead.com/quest=8519
Lang["Q2_8519"] = "Lernt so viel Ihr könnt über die Vergangenheit, sprecht dann mit Anachronos in den Höhlen der Zeit in Tanaris."
Lang["Q1_8555"] = "Der Bund der Drachenschwärme"			-- https://de.classic.wowhead.com/quest=8555
Lang["Q2_8555"] = "Eranikus, Vaelastrasz und Azuregos... zweifellos kennt Ihr diese Drachen, Sterblicher. Es ist daher auch kein Zufall, dass sie eine so wichtige Rolle als Behüter unserer Welt gespielt haben.\n\nUnglücklicherweise (und zum Teil ist auch meine eigene Naivität daran schuld) fiel jeder Wächter, sei es durch Beauftragte der alten Götter oder Verrat derer, die sie ihre Freunde nannten, der Tragödie zum Opfer. Das Ausmaß dessen, schürte mein Misstrauen zu Euereins noch mehr an.\n\nSucht nach ihnen... und bereitet Euch auf das Schlimmste vor. "
Lang["Q1_8730"] = "Nefarius' Verderbnis"			-- https://de.classic.wowhead.com/quest=8730
Lang["Q2_8730"] = "Tötet Nefarian und bringt den roten Szeptersplitter wieder in Euren Besitz. Bringt den roten Szeptersplitter zu Anachronos in den Höhlen der Zeit in Tanaris. Euch bleiben 5 Stunden, um diese Aufgabe zu erfüllen."
Lang["Q1_8733"] = "Eranikus, der Tyrann des Traums"			-- https://de.classic.wowhead.com/quest=8733
Lang["Q2_8733"] = "Reist nach Teldrassil und sucht Malfurions Agenten irgendwo außerhalb der Stadtmauern von Darnassus auf."
Lang["Q1_8734"] = "Tyrande und Remulos"			-- https://de.classic.wowhead.com/quest=8734
Lang["Q2_8734"] = "Reist nach Moonglade und sprecht mit Bewahrer Remulos."
Lang["Q1_8735"] = "Die Verderbnis des Alptraums"			-- https://de.classic.wowhead.com/quest=8735
Lang["Q2_8735"] = "Reist zu den vier Portalen des smaragdgrünen Traums in Azeroth und sammelt dort jeweils ein Verderbnisfragment des Alptraums ein. Kehrt zu Bewahrer Remulos in Moonglade zurück, sobald Ihr diese Aufgabe erfüllt habt."
Lang["Q1_8736"] = "Der Alptraum offenbart sich"			-- https://de.classic.wowhead.com/quest=8736
Lang["Q2_8736"] = "Verteidigt Nighthaven gegen Eranikus. Bewahrer Remulos darf dabei nicht ums Leben kommen und Eranikus darf nicht getötet werden. Verteidigt Euch. Erwartet Tyrande."
Lang["Q1_8741"] = "Der Held kehrt zurück"			-- https://de.classic.wowhead.com/quest=8741
Lang["Q2_8741"] = "Bringt den grünen Szeptersplitter zu Anachronos in den Höhlen der Zeit. "
Lang["Q1_8575"] = "Azuregos' magisches Buch"			-- https://de.classic.wowhead.com/quest=8575
Lang["Q2_8575"] = "Bringt Azuregos' magisches Buch zu Narain Soothfancy in Tanaris. "
Lang["Q1_8576"] = "Übersetzung des Buchs"			-- https://de.classic.wowhead.com/quest=8576
Lang["Q2_8576"] = "Eins nach dem anderen! Wir müssen herausfinden was Azuregos in dieses Buch geschrieben hat.\n\nEr hat Euch also gesagt, dass Ihr eine Arkanitboje herstellen sollt und dass dies hier der Bauplan dafür ist? Komisch, dass er das in Drachisch schreiben würde. Der alte Fuchs weiß doch, dass ich diesen Quatsch nicht lesen kann.\n\nWenn das klappen soll, dann werde ich meine Wahrsagebrille, ein 500 Pfund-Hühnchen und Band 2 von Drachisch für Dummies benötigen. Nicht unbedingt in dieser Reihenfolge. "
Lang["Q1_8597"] = "Drachisch für Dummies"			-- https://de.classic.wowhead.com/quest=8597
Lang["Q2_8597"] = "Findet Narain Soothfancys Buch, das auf einer Insel der südlichen Meere vergraben ist."
Lang["Q1_8599"] = "Liebesbrief für Narain"			-- https://de.classic.wowhead.com/quest=8599
Lang["Q2_8599"] = "Bringt Meridiths Liebesbrief zu Narain Soothfancy in Tanaris."
Lang["Q1_8598"] = "lÖsEGeLd"			-- https://de.classic.wowhead.com/quest=8598
Lang["Q2_8598"] = "Bringt die Lösegeldforderung zu Narain Soothfancy in Tanaris."
Lang["Q1_8606"] = "Lockvogel!"			-- https://de.classic.wowhead.com/quest=8606
Lang["Q2_8606"] = "Narain Soothfancy in Tanaris möchte, dass Ihr nach Winterspring reist und die Tasche voller Gold, so wie es die Buchnapper angegeben haben, am Übergabepunkt platziert."
Lang["Q1_8620"] = "Der einzige Weg"			-- https://de.classic.wowhead.com/quest=8620
Lang["Q2_8620"] = "Findet die 8 verlorenen Kapitel von Drachisch für Dummies und vereint sie mit dem magischen Bucheinband. Bringt das vollständige Buch Drachisch für Dummies: Band 2 zu Narain Soothfancy in Tanaris."
Lang["Q1_8584"] = "Fragt mich nie nach meinen Angelegenheiten"			-- https://de.classic.wowhead.com/quest=8584
Lang["Q2_8584"] = "Narain Soothfancy in Tanaris möchte, dass Ihr mit Dirge Quikcleave in Gadgetzan sprecht."
Lang["Q1_8585"] = "Die Insel des Schreckens!"			-- https://de.classic.wowhead.com/quest=8585
Lang["Q2_8585"] = "Dirge Quikcleave in Tanaris möchte, dass Ihr Lakmaerans Kadaver, sowie 20 Chimaeroklenden beschafft."
Lang["Q1_8586"] = "Dirges abgefahrene Chimaerokkoteletts"			-- https://de.classic.wowhead.com/quest=8586
Lang["Q2_8586"] = "Dirge Quikcleave in Gadgetzan möchte, dass Ihr ihm 20 Einheiten Goblin-Raketentreibstoff und 20 Einheiten Tiefsteinsalz bringt."
Lang["Q1_8587"] = "Rückkehr zu Narain"			-- https://de.classic.wowhead.com/quest=8587
Lang["Q2_8587"] = "Bringt das 500 Pfund-Hühnchen zu Narain Soothfancy in Tanaris."
Lang["Q1_8577"] = "Stewvul, Ex-B.F.F.I."			-- https://de.classic.wowhead.com/quest=8577
Lang["Q2_8577"] = "Narain Soothfancy möche, dass Ihr seinen Ex-'Besten Freund für immer' (B.F.F.I.) Stewvul ausfindig macht. Nehmt ihm die gestohlene Wahrsagerbrille ab und bringt sie Narain zurück."
Lang["Q1_8578"] = "Wahrsagerbrille? Kein Problem!"			-- https://de.classic.wowhead.com/quest=8578
Lang["Q2_8578"] = "Findet Narains Wahrsagerbrille und bringt sie Narain Soothfancy in Tanaris."
Lang["Q1_8728"] = "Die gute und die schlechte Nachricht"			-- https://de.classic.wowhead.com/quest=8728
Lang["Q2_8728"] = "Narain Soothfancy in Tanaris möchte, dass Ihr ihm 20 Arkanitbarren, 10 Elementiumerz, 10 Azerothianische Diamanten und 10 blaue Saphire bringt."
Lang["Q1_8729"] = "Der Zorn von Neptulon"			-- https://de.classic.wowhead.com/quest=8729
Lang["Q2_8729"] = "Benutzt die Arkanitboje am wirbelnden Maelstrom in der Bucht der Stürme in Azshara."
Lang["Q1_8742"] = "The Might of Kalimdor"			-- https://de.classic.wowhead.com/quest=8742
Lang["Q2_8742"] = "Eintausend Jahre sind vergangen und wie es vorausgesagt wurde, steht die Eine nun vor mir. die Auserwählte, welche Ihr Volk in ein neues Zeitalter führen wird. Spürt Ihr es? Der alte Gott erzittert, Oh ja, er fürchtet Eure Bestimmung. Zerschlagt die Prophezeiung von C'thun!\n\nEr weiß, dass Ihr zu ihm kommen werdet - und mit Euch kommt die Macht von Kalimdor. Lasst es mich wissen, wenn Ihr bereit seid und ich werde Euch das Szepter der Sandstürme anvertrauen. "
Lang["Q1_8745"] = "Der Schatz des Zeitlosen"			-- https://de.classic.wowhead.com/quest=8745
Lang["Q2_8745"] = "Seig gegrüßt, großer Held! Ich bin Jonathan, der Bewahrer des heiligen Gongs und ewige Wächter des bronzenen Drachenschwarms.\n\nDer Zeitlose hat mich dazu ermächtigt, Euch aus seinem Schatz einen Gegenstand Eurer Wahl zu gewähren. Möge er Euren Kampf gegen C'Thun erleichtern. "


-- QUESTS - TBC
Lang["Q1_10755"] = "Zugang zur Zitadelle"			-- https://de.tbc.wowhead.com/quest=10755
Lang["Q2_10755"] = "Bringt die präparierte Schlüsselform zu Truppenkommandant Nazgrel in Thrallmar auf der Höllenfeuerhalbinsel. "
Lang["Q1_10756"] = "Großmeister Rohok"			-- https://de.tbc.wowhead.com/quest=10756
Lang["Q2_10756"] = "Bringt die präparierte Schlüsselform zu Rohok nach Thrallmar auf der Höllenfeuerhalbinsel. "
Lang["Q1_10757"] = "Rohoks Bitte"			-- https://de.tbc.wowhead.com/quest=10757
Lang["Q2_10757"] = "Bringt 4 Teufelseisenbarren, 2 Einheiten arkaner Staub und 4 Feuerpartikel zu Rohok in Thrallmar auf der Höllenfeuerhalbinsel."
Lang["Q1_10758"] = "Heißer als die Hölle"			-- https://de.tbc.wowhead.com/quest=10758
Lang["Q2_10758"] = "Zerstört einen Teufelshäscher auf der Höllenfeuerhalbinsel und haltet die ungebrannte Schlüsselform in seine Überreste. Bringt die verkohlte Schlüsselform danach zu Rohok in Thrallmar. "
Lang["Q1_10754"] = "Zugang zur Zitadelle"			-- https://de.tbc.wowhead.com/quest=10754
Lang["Q2_10754"] = "Bringt die präparierte Schlüsselform zu Truppenkommandant Danath in der Ehrenfeste auf der Höllenfeuerhalbinsel."
Lang["Q1_10762"] = "Großmeister Dumphry"			-- https://de.tbc.wowhead.com/quest=10762
Lang["Q2_10762"] = "Bringt die präparierte Schlüsselform zu Dumphry in der Ehrenfeste. "
Lang["Q1_10763"] = "Dumphrys Bitte"			-- https://de.tbc.wowhead.com/quest=10763
Lang["Q2_10763"] = "Bringt 4 Teufelseisenbarren, 2 Einheiten arkaner Staub und 4 Feuerpartikel zu Dumphry in der Ehrenfeste auf der Höllenfeuerhalbinsel. "
Lang["Q1_10764"] = "Heißer als die Hölle"			-- https://de.tbc.wowhead.com/quest=10764
Lang["Q2_10764"] = "Zerstört einen Teufelshäscher auf der Höllenfeuerhalbinsel und haltet die ungebrannte Schlüsselform in seine Überreste. Bringt die verkohlte Schlüsselform danach zu Dumphry in der Ehrenfeste. "
Lang["Q1_10279"] = "Zum Hort des Meisters"			-- https://de.tbc.wowhead.com/quest=10279
Lang["Q2_10279"] = "Sprecht mit Andormu in den Höhlen der Zeit."
Lang["Q1_10277"] = "Hie Höhlen der Zeit"			-- https://de.tbc.wowhead.com/quest=10277
Lang["Q2_10277"] = "Andormu in den Höhlen der Zeit möchte, dass Ihr der Bewahrerin der Zeit durch die Höhle folgt."
Lang["Q1_10282"] = "Das alte Hügelland"			-- https://de.tbc.wowhead.com/quest=10282
Lang["Q2_10282"] = "Andormu in den Höhlen der Zeit bittet Euch, ins Alte Hügelland zu reisen und mit Erozion zu sprechen."
Lang["Q1_10283"] = "Tarethas Ablenkungsmanöver"			-- https://de.tbc.wowhead.com/quest=10283
Lang["Q2_10283"] = "Reist nach Burg Durnholde und platziert mithilfe des Bündels mit Brandbomben, das Ihr von Erozion erhalten habt, 5 Brandsätze auf den Fässern in jeder Internierungsbaracke.\n\nSprecht mit Thrall im Kellergefängnis von Burg Durnholde, wenn Ihr die Internierungsbaracken angezündet habt. "
Lang["Q1_10284"] = "Flucht aus Durnholde"			-- https://de.tbc.wowhead.com/quest=10284
Lang["Q2_10284"] = "Gebt Thrall Bescheid, wenn Ihr bereit seid. Folgt Thrall aus der Burg Durnholde und helft ihm, Taretha zu befreien und sein Schicksal zu erfüllen.\n\nSprecht mit Erozion im Alten Hügelland, wenn Ihr diese Aufgabe erfüllt habt. "
Lang["Q1_10285"] = "Rückkehr zu Andormu"			-- https://de.tbc.wowhead.com/quest=10285
Lang["Q2_10285"] = "Kehrt zu dem jungen Andormu in den Höhlen der Zeit in Tanaris zurück."
Lang["Q1_10265"] = "Kristallsammlung des Konsortiums"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10265
Lang["Q2_10265"] = "Besorgt ein Kristallartefakt von Arklon und bringt es zu Netherpirscher Khay'ji in Area 52 im Nethersturm."
Lang["Q1_10262"] = "Ein Hügel voll Astraler"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10262
Lang["Q2_10262"] = "Sammelt 10 Insignien der Zaxxis und kehrt dann zu Netherpirscher Khay'ji in Area 52 im Nethersturm zurück."
Lang["Q1_10205"] = "Sphärenräuber Nesaad"			-- https://de.tbc.wowhead.com/quest=10205
Lang["Q2_10205"] = "Tötet Sphärenräuber Nesaad und kehrt dann zu Netherpirscher Khay'ji in Area 52 im Nethersturm zurück."
Lang["Q1_10266"] = "Bitte um Unterstützung"			-- https://de.tbc.wowhead.com/quest=10266
Lang["Q2_10266"] = "Sucht Gahruj und bietet ihm Eure Hilfe an. Er befindet sich im Mittelreichposten in der Biokuppel Mittelreich im Nethersturm."
Lang["Q1_10267"] = "Rechtmäßiger Besitz"			-- https://de.tbc.wowhead.com/quest=10267
Lang["Q2_10267"] = "Sammelt 10 Kästen mit Vermessungsausrüstung und bringt sie zu Gahruj im Mittelreichposten in der Biokuppel Mittelreich im Nethersturm."
Lang["Q1_10268"] = "Eine Audienz beim Prinzen"			-- https://de.tbc.wowhead.com/quest=10268
Lang["Q2_10268"] = "Bringt die Vermessungsausrüstung zum Bild von Nexusprinz Haramad in der Sturmsäule im Nethersturm."
Lang["Q1_10269"] = "Triangulationspunkt Eins"			-- https://de.tbc.wowhead.com/quest=10269
Lang["Q2_10269"] = "Benutzt das Triangulationsgerät, um den Weg zum ersten Triangulationspunkt zu bestimmen. Wenn Ihr ihn gefunden habt, meldet die Position an Händler Hazzin beim Wachposten des Protektorats auf der Insel der Manaschmiede Ultris im Nethersturm."
Lang["Q1_10275"] = "Triangulationspunkt Zwei"			-- https://de.tbc.wowhead.com/quest=10275
Lang["Q2_10275"] = "Benutzt das Triangulationsgerät, um den Weg zum zweiten Triangulationspunkt zu bestimmen. Wenn Ihr ihn gefunden habt, meldet die Position an Windhändler Tuluman auf Tulumans Landeplatz auf der anderen Seite der Brücke zu der Insel der Manaschmiede Ara im Nethersturm."
Lang["Q1_10276"] = "Das volle Dreieck"			-- https://de.tbc.wowhead.com/quest=10276
Lang["Q2_10276"] = "Besorgt Euch den Kristall von Ata'mal und bringt ihn zu Nexusprinz Haramad in der Sturmsäule im Nethersturm."
Lang["Q1_10280"] = "Sonderlieferung nach Shattrath"			-- https://de.tbc.wowhead.com/quest=10280
Lang["Q2_10280"] = "Bringt den Kristall von Ata'mal zu A'dal auf der Terrasse des Lichts in Shattrath."
Lang["Q1_10704"] = "Wie man in Arkatraz einbricht"			-- https://de.tbc.wowhead.com/quest=10704
Lang["Q2_10704"] = "A'dal bittet Euch, das obere und das untere Fragment des Schlüssels zur Arkatraz zu besorgen. Bringt beide Fragmente zu ihm zurück, damit er sie für Euch zum Schlüssel zur Arkatraz zusammenfügen kann."
Lang["Q1_9824"] = "Arkane Störungen"			-- https://de.tbc.wowhead.com/quest=9824
Lang["Q2_9824"] = "Benutzt den violetten Aufzeichnungskristall in der Nähe von unterirdischen Wasserquellen im Keller des Meisters und kehrt zu Erzmagier Alturus außerhalb von Karazhan zurück."
Lang["Q1_9825"] = "Rastlose Aktivität"			-- https://de.tbc.wowhead.com/quest=9825
Lang["Q2_9825"] = "Bringt 10 geisterhafte Essenzen zu Erzmagier Alturus außerhalb von Karazhan. "
Lang["Q1_9826"] = "Dalarankontaktperson"			-- https://de.tbc.wowhead.com/quest=9826
Lang["Q2_9826"] = "Bringt Alturus' Bericht zu Erzmagier Cedric am Rande des Dalarankraters."
Lang["Q1_9829"] = "Khadgar"			-- https://de.tbc.wowhead.com/quest=9829
Lang["Q2_9829"] = "Bringt Alturus' Bericht zu Khadgar in Shattrath in den Wäldern von Terokkar."
Lang["Q1_9831"] = "Nach Karazhan"			-- https://de.tbc.wowhead.com/quest=9831
Lang["Q2_9831"] = "Khadgar möchte, dass Ihr das Schattenlabyrinth von Auchindoun betretet und das erste Schlüsselfragment aus einem versteckten arkanen Behälter besorgt."
Lang["Q1_9832"] = "Das zweite und das dritte Fragment"			-- https://de.tbc.wowhead.com/quest=9832
Lang["Q2_9832"] = "Besorgt das zweite Schlüsselfragment aus einem arkanen Behälter im Echsenkessel und das dritte Schlüsselfragment aus einem arkanen Behälter in der Festung der Stürme. Kehrt dann zu Khadgar in Shattrath zurück."
Lang["Q1_9836"] = "Die Berührung des Meisters"			-- https://de.tbc.wowhead.com/quest=9836
Lang["Q2_9836"] = " Geht in die Höhlen der Zeit und überzeugt Medivh davon, den wiederhergestellten Schlüssel des Lehrlings zu aktivieren."
Lang["Q1_9837"] = "Rückkehr Khadgar"			-- https://de.tbc.wowhead.com/quest=9837
Lang["Q2_9837"] = "Kehrt zu Khadgar in Shattrath zurück und zeigt ihm den Schlüssel des Meisters."
Lang["Q1_9838"] = "Das Violette Auge"			-- https://de.tbc.wowhead.com/quest=9838
Lang["Q2_9838"] = "Sprecht mit Erzmagier Alturus außerhalb von Karazhan."
Lang["Q1_9630"] = "Medivhs Tagebuch"			-- https://de.tbc.wowhead.com/quest=9630
Lang["Q2_9630"] = "Erzmagier Alturus am Gebirgspass der Totenwinde möchte, dass Ihr nach Karazhan geht und mit Wravien sprecht."
Lang["Q1_9638"] = "In guten Händen"			-- https://de.tbc.wowhead.com/quest=9638
Lang["Q2_9638"] = "Sprecht mit Gradav in der Bibliothek des Wächters in Karazhan."
Lang["Q1_9639"] = "Kamsis"			-- https://de.tbc.wowhead.com/quest=9639
Lang["Q2_9639"] = "Sprecht mit Kamsis in der Bibliothek des Wächters in Karazhan."
Lang["Q1_9640"] = "Arans Schemen"			-- https://de.tbc.wowhead.com/quest=9640
Lang["Q2_9640"] = "Beschafft Medivhs Tagebuch und kehrt zu Kamsis in der Bibliothek des Wächters in Karazhan zurück."
Lang["Q1_9645"] = "Die Terrasse des Meisters"			-- https://de.tbc.wowhead.com/quest=9645
Lang["Q2_9645"] = "Geht zur Terrasse des Meisters in Karazhan und lest Medivhs Tagebuch"
Lang["Q1_9680"] = "Die Vergangenheit aufwühlen"			-- https://de.tbc.wowhead.com/quest=9680
Lang["Q2_9680"] = "Erzmagier Alturus möchte, dass Ihr zu den Bergen südlich von Karazhan im Gebirgspass der Totenwinde geht und ein verkohltes Knochenfragment besorgt."
Lang["Q1_9631"] = "Hilfe unter Kollegen"			-- https://de.tbc.wowhead.com/quest=9631
Lang["Q2_9631"] = "Bringt das verkohlte Knochenfragment zu Kalynna Lathred in Area 52 im Nethersturm."
Lang["Q1_9637"] = "Kalynnas Bitte"			-- https://de.tbc.wowhead.com/quest=9637
Lang["Q2_9637"] = "Kalynna Lathred möchte, dass Ihr den Dämmerfolianten vom Großhexenmeister Nethekurse in den Zerschmetterten Hallen der Höllenfeuerzitadelle und das Buch der vergessenen Namen von Dunkelwirker Syth in den Sethekkhallen in Auchindoun besorgt.\n\nIhr müsst diese Quest auf dem Schwierigkeitsgrad 'Heroisch' abschließen. "
Lang["Q1_9644"] = "Schrecken der Nacht"			-- https://de.tbc.wowhead.com/quest=9644
Lang["Q2_9644"] = "Geht zur Terrasse des Meisters in Karazhan und berührt die geschwärzte Urne, um den Schrecken der Nacht zu rufen. Entzieht dem Körper des Schreckens die schwache arkane Essenz und bringt sie zu Erzmagier Alturus."
Lang["Q1_10901"] = "Der Knüppel von Kar´desh"			-- https://de.tbc.wowhead.com/quest=10901
Lang["Q2_10901"] = "Nar'biss der Ketzer in den heroischen Sklavenunterkünften des Echsenkessels möchte, dass Ihr ihm das Erdensiegel und das Flammensiegel bringt."
Lang["Q1_10900"] = "Das Mal von Vashj"			-- https://de.tbc.wowhead.com/quest=10900
Lang["Q2_10900"] = "Brennt es nieder! Brennt alles nieder! Sie haben nichts verdient. Habt Ihr mich verstanden? NICHTS! Sie müssen für ihre Taten bezahlen. Auch für ihre zukünftigen.\n\nIch würde Vashj selbst töten, wenn ich von diesen verdammten Fesseln frei wäre.\n\nOder wollt Ihr vielleicht Neptulons Arbeit erledigen? Ihr Tod ist uns beiden dienlich, Weichhaut. Werdet Ihr mir dabei helfen, den heiligen Knüppel herzustellen? "
Lang["Q1_10681"] = "Die Hand von Gul´dan"			-- https://de.tbc.wowhead.com/quest=10681
Lang["Q2_10681"] = "Sprecht mit Erdheiler Torlok am Altar der Verdammnis im Schattenmondtal."
Lang["Q1_10458"] = "Wütende Geister des Feuers und der Erde"			-- https://de.tbc.wowhead.com/quest=10458
Lang["Q2_10458"] = "Erdheiler Torlok beim Altar der Verdammnis im Schattenmondtal möchte, dass Ihr das Totem der Geister benutzt, um 8 Erdenseelen und 8 Feuerseelen einzufangen."
Lang["Q1_10480"] = "Wütende Geister des Wassers"			-- https://de.tbc.wowhead.com/quest=10480
Lang["Q2_10480"] = "Erdheiler Torlok beim Altar der Verdammnis im Schattenmondtal möchte, dass Ihr das Totem der Geister benutzt, um 5 Wasserseelen einzufangen."
Lang["Q1_10481"] = "Wütende Geister der Luft"			-- https://de.tbc.wowhead.com/quest=10481
Lang["Q2_10481"] = "Erdheiler Torlok beim Altar der Verdammnis im Schattenmondtal möchte, dass Ihr das Totem der Geister benutzt, um 10 Luftseelen einzufangen."
Lang["Q1_10513"] = "Oronok Herzeleid"			-- https://de.tbc.wowhead.com/quest=10513
Lang["Q2_10513"] = "Sucht Oronok Herzeleid auf dem zerschlagenen Vorsprung nördlich der Zisterne der Echsennarbe."
Lang["Q1_10514"] = "Ich war schon vieles..."			-- https://de.tbc.wowhead.com/quest=10514
Lang["Q2_10514"] = "Oronok Herzeleid bei Oronoks Hof im Schattenmondtal möchte, dass Ihr 10 Schattenmondknollen aus den Zerschlagenen Weiten besorgt."
Lang["Q1_10515"] = "Eine Lektion gelernt"			-- https://de.tbc.wowhead.com/quest=10515
Lang["Q2_10515"] = "Oronok Herzeleid bei Oronoks Hof im Schattenmondtal möchte, dass Ihr 10 Eier eines gefräßigen Schinders zerstört. "
Lang["Q1_10519"] = "Die Litanei der Verdammnis - Wahrheit und Geschichte"			-- https://de.tbc.wowhead.com/quest=10519
Lang["Q2_10519"] = "Oronok Herzeleid bei Oronoks Hof im Schattenmondtal möchte, dass Ihr Euch seine Geschichte anhört. Sprecht mit Oronok, um ihm zusagen, dass er mit der Geschichte beginnen kann."
Lang["Q1_10521"] = "Grom'tor, Sohn des Oronok"			-- https://de.tbc.wowhead.com/quest=10521
Lang["Q2_10521"] = "Sucht Grom'tor, Sohn des Oronok in der Echsennarbe im Schattenmondtal."
Lang["Q1_10527"] = "Ar'tor, Sohn des Oronok"			-- https://de.tbc.wowhead.com/quest=10527
Lang["Q2_10527"] = "Findet Ar'tor, Sohn des Oronok, bei der Stätte der Illidari im Schattenmondtal."
Lang["Q1_10546"] = "Borak, Sohn des Oronok"			-- https://de.tbc.wowhead.com/quest=10546
Lang["Q2_10546"] = "Sucht Borak, Sohn des Oronok, in der Nähe der Stätte der Mondfinsternis im Schattenmondtal."
Lang["Q1_10522"] = "Die Litanei der Verdammnis - Grom'tors Angriff"			-- https://de.tbc.wowhead.com/quest=10522
Lang["Q2_10522"] = "Grom'tor, Sohn des Oronok, in der Echsennarbe im Schattenmondtal möchte, dass Ihr den ersten Teil der Litanei der Verdammnis besorgt."
Lang["Q1_10528"] = "Dämonische Kristallgefägnisse"			-- https://de.tbc.wowhead.com/quest=10528
Lang["Q2_10528"] = "Sucht und tötet Schmerzensmeisterin Gabrissa in der Stätte der Illidari und kehrt mit dem kristallenen Schlüssel zum Leichnam von Ar'tor, Sohn des Oronok, zurück."
Lang["Q1_10547"] = "Von Distelköpfen und Eiern..."			-- https://de.tbc.wowhead.com/quest=10547
Lang["Q2_10547"] = "Borak, Sohn des Oronok, bei der Brücke nördlich der Stätte der Mondfinsternis möchte, dass Ihr ein verfaultes Arakkoaei besorgt und es zu Tobias dem Faulfraß in Shattrath, nordwestlich der Wälder von Terokkar, bringt."
Lang["Q1_10523"] = "Die Litanei der Verdammnis - Erster Teil"			-- https://de.tbc.wowhead.com/quest=10523
Lang["Q2_10523"] = "Bringt Grom'tors Schließkassette zu Oronoks Hof im Schattenmondtal."
Lang["Q1_10537"] = "Lohn'goron, Bogen des Herzeleid"			-- https://de.tbc.wowhead.com/quest=10537
Lang["Q2_10537"] = "Der Geist von Ar'tor bei der Stätte der Illidari im Schattenmondtal möchte, dass Ihr Lohn'goron, den Bogen des Herzeleid, von den Dämonen in der Gegend beschafft."
Lang["Q1_10550"] = "Ein Bündel von Blutdisteln"			-- https://de.tbc.wowhead.com/quest=10550
Lang["Q2_10550"] = "Bringt das Blutdistelbündel zurück zu Borak, Sohn des Oronok, bei der Brücke in der Nähe der Stätte der Mondfinsternis im Schattenmondtal."
Lang["Q1_10540"] = "Die Litanei der Verdammnis - Ar'tors Angriff"			-- https://de.tbc.wowhead.com/quest=10540
Lang["Q2_10540"] = "Der Geist von Ar'tor bei der Stätte der Illidari im Schattenmondtal möchte, dass Ihr den zweiten Teil der Litanei der Verdammnis von Veneratus dem Vielgesichtigen besorgt.\n\nKreaturen, die vom Geistjäger angegriffen werden oder Schaden erleiden, gewähren Euch keine Beute oder Erfahrung."
Lang["Q1_10570"] = "Einen Distelsüchtigen fangen"			-- https://de.tbc.wowhead.com/quest=10570
Lang["Q2_10570"] = "Borak, Sohn des Oronok, bei der Brücke in der Nähe der Stätte der Mondfinsternis im Schattenmondtal möchte, dass Ihr Sturmgrimms Schriftwechsel beschafft."
Lang["Q1_10576"] = "Unterwürfigkeit in Schattenmond"			-- https://de.tbc.wowhead.com/quest=10576
Lang["Q2_10576"] = "Borak, Sohn des Oronok, bei der Brücke in der Nähe der Stätte der Mondfinsternis im Schattenmondtal möchte, dass Ihr 6 Teile der Rüstung der Mondfinsternis besorgt."
Lang["Q1_10577"] = "Was Illidan will, soll Illidan bekommen..."			-- https://de.tbc.wowhead.com/quest=10577
Lang["Q2_10577"] = "Borak, Sohn des Oronok, bei der Brücke in der Nähe der Stätte der Mondfinsternis im Schattenmondtal möchte, dass Ihr Großkommandant Ruusk in der Stätte der Mondfinsternis Illidans Nachricht überbringt."
Lang["Q1_10578"] = "Die Litanei der Verdammnis - Boraks Angriff"			-- https://de.tbc.wowhead.com/quest=10578
Lang["Q2_10578"] = "Borak, Sohn des Oronok, bei der Brücke in der Nähe der Stätte der Mondfinsternis im Schattenmondtal möchte, dass Ihr den dritten Teil der Litanei der Verdammnis von Ruul dem Verfinsterer besorgt."
Lang["Q1_10541"] = "Die Litanei der Verdammnis - Zweiter Teil"			-- https://de.tbc.wowhead.com/quest=10541
Lang["Q2_10541"] = "Bringt Ar'tors Schließkassette zu Oronok Herzeleid bei Oronoks Hof im Schattenmondtal."
Lang["Q1_10579"] = "Die Litanei der Verdammnis - Dritter Teil"			-- https://de.tbc.wowhead.com/quest=10579
Lang["Q2_10579"] = "Bringt Boraks Schließkassette zu Oronok Herzeleid bei Oronoks Hof im Schattenmondtal."
Lang["Q1_10588"] = "Die Litanei der Verdammnis"			-- https://de.tbc.wowhead.com/quest=10588
Lang["Q2_10588"] = "Benutzt die Litanei der Verdammnis am Altar der Verdammnis, um Cyrukh den Feuerlord zu rufen.\n\nVernichtet Cyrukh den Feuerlord und sprecht danach mit Erdheiler Torlok, der sich ebenfalls am Altar der Verdammnis befindet."
Lang["Q1_10883"] = "Der Schlüssel der Stürme"			-- https://de.tbc.wowhead.com/quest=10883
Lang["Q2_10883"] = "Sprecht mit A'dal in Shattrath."
Lang["Q1_10884"] = "Die Prüfung der Naaru: Erbarmen"			-- https://de.tbc.wowhead.com/quest=10884
Lang["Q2_10884"] = "A'dal in Shattrath möchte, dass Ihr die unbenutzte Axt des Henkers aus den Zerschmetterten Hallen der Höllenfeuerzitadelle besorgt.\n\nDiese Aufgabe muss auf dem Schwierigkeitsgrad 'Heroisch' abgeschlossen werden."
Lang["Q1_10885"] = "Die Prüfung der Naaru: Stärke"			-- https://de.tbc.wowhead.com/quest=10885
Lang["Q2_10885"] = "A'dal in Shattrath möchte, dass Ihr Kalithreshs Dreizack und Murmurs Essenz besorgt.\n\nDiese Aufgabe muss auf dem Schwierigkeitsgrad 'Heroisch' abgeschlossen werden."
Lang["Q1_10886"] = "Die Prüfung der Naaru: Zuverlässigkeit"			-- https://de.tbc.wowhead.com/quest=10886
Lang["Q2_10886"] = "A'dal in Shattrath möchte, dass Ihr Millhaus Manasturm aus der Arkatraz in der Festung der Stürme rettet.\n\nDiese Aufgabe muss auf dem Schwierigkeitsgrad 'Heroisch' abgeschlossen werden."
Lang["Q1_10888"] = "Die Prüfung der Naaru: Magtheridon"			-- https://de.tbc.wowhead.com/quest=10888
Lang["Q2_10888"] = "A'dal in Shattrath möchte, dass Ihr Magtheridon vernichtet."
Lang["Q1_10680"] = "Die Hand von Gul'dan"			-- https://de.tbc.wowhead.com/quest=10680
Lang["Q2_10680"] = "Sprecht mit Erdheiler Torlok am Altar der Verdammnis im Schattenmondtal."
Lang["Q1_10445"] = "Die Phiolen der Ewigkeit"			-- https://de.tbc.wowhead.com/quest=10445
Lang["Q2_10445"] = "Soridormi in den Höhlen der Zeit möchte, dass Ihr die Überreste von Vashjs Phiole im Echsenkessel und die Überreste von Kaels Phiole von Kael'thas Sonnenwanderer in der Festung der Stürme besorgt."
Lang["Q1_10568"] = "Schrifttafeln von Baa´ri"			-- https://de.tbc.wowhead.com/quest=10568
Lang["Q2_10568"] = "Anachoretin Ceyla beim Altar der Sha'tar möchte, dass Ihr 12 Schrifttafeln von Baa'ri vom Boden und von den Arbeitern der Aschenzungen in den Ruinen von Baa'ri sammelt.\n\nDas Abschließen von Quests für die Aldor führt zu einer Verringerung Eures Rufs bei den Sehern."
Lang["Q1_10683"] = "Schrifttafeln von Baa´ri"			-- https://de.tbc.wowhead.com/quest=10683
Lang["Q2_10683"] = "Arkanist Thelis beim Sanktum der Sterne möchte, dass Ihr 12 Schrifttafeln von Baa'ri vom Boden und von den Arbeitern der Aschenzungen in den Ruinen von Baa'ri sammelt.\n\nDas Abschließen von Quests für die Seher führt zu einer Verringerung Eures Rufs bei den Aldor."
Lang["Q1_10571"] = "Oronu der Älteste"			-- https://de.tbc.wowhead.com/quest=10571
Lang["Q2_10571"] = "Anachoretin Ceyla beim Altar der Sha'tar möchte, dass Ihr die Befehle von Akama von Oronu dem Ältesten in den Ruinen von Baa'ri besorgt.\n\nDas Abschließen von Quests für die Aldor führt zu einer Verringerung Eures Rufs bei den Sehern."
Lang["Q1_10684"] = "Oronu der Älteste"			-- https://de.tbc.wowhead.com/quest=10684
Lang["Q2_10684"] = "Arkanist Thelis beim Sanktum der Sterne möchte, dass Ihr die Befehle von Akama von Oronu dem Ältesten in den Ruinen von Baa'ri besorgt.\n\nDas Abschließen von Quests für die Seher führt zu einer Verringerung Eures Rufs bei den Aldor."
Lang["Q1_10574"] = "Die Verderber der Aschenzungen"			-- https://de.tbc.wowhead.com/quest=10574
Lang["Q2_10574"] = "Beschafft die vier Medaillonfragmente von Haalum, Eykenen, Lakaan und Uylaru und kehrt danach zu Anachoretin Ceyla beim Altar der Sha'tar im Schattenmondtal zurück.\n\nDas Ausführen von Quests für die Aldor führt zu einer Verringerung Eures Rufs bei den Sehern."
Lang["Q1_10685"] = "Die Verderber der Aschenzungen"			-- https://de.tbc.wowhead.com/quest=10685
Lang["Q2_10685"] = "Beschafft die vier Medaillonfragmente von Haalum, Eykenen, Lakaan und Uylaru und kehrt danach zu Arkanist Thelis beim Sanktum der Sterne im Schattenmondtal zurück.\n\nDas Ausführen von Quests für die Seher führt zu einer Verringerung Eures Rufs bei den Aldor."
Lang["Q1_10575"] = "Der Kerker des Wächters"			-- https://de.tbc.wowhead.com/quest=10575
Lang["Q2_10575"] = "Anachoretin Ceyla möchte, dass Ihr den Kerker des Wächters südlich der Ruinen von Baa'ri betretet und Sanoru befragt, um Akamas Aufenthaltsort herauszufinden.\n\nDas Abschließen von Quests für die Aldor führt zu einer Verringerung Eures Rufs bei den Seher."
Lang["Q1_10686"] = "Der Kerker des Wächters"			-- https://de.tbc.wowhead.com/quest=10686
Lang["Q2_10686"] = "Arkanist Thelis möchte, dass Ihr den Kerker des Wächters südlich der Ruinen von Baa'ri betretet und Sanoru über Akamas Aufenthaltsort befragt.\n\nDas Abschließen von Quests für die Seher führt zu einer Verringerung Eures Rufs bei den Aldor."
Lang["Q1_10622"] = "Beweis der Treue"			-- https://de.tbc.wowhead.com/quest=10622
Lang["Q2_10622"] = "Tötet Zandras im Kerker des Wächters im Schattenmondtal und kehrt danach zu Sanoru zurück."
Lang["Q1_10628"] = "Akama"			-- https://de.tbc.wowhead.com/quest=10628
Lang["Q2_10628"] = "Sprecht mit Akama in der verborgenen Kammer im Kerker des Wächters."
Lang["Q1_10705"] = "Seher Udalo"			-- https://de.tbc.wowhead.com/quest=10705
Lang["Q2_10705"] = "Sucht Seher Udalo in der Arkatraz in der Festung der Stürme."
Lang["Q1_10706"] = "Ein mysteriöses Omen"			-- https://de.tbc.wowhead.com/quest=10706
Lang["Q2_10706"] = "Kehrt zu Akama im Kerker des Wächters im Schattenmondtal zurück."
Lang["Q1_10707"] = "Die Terrasse von Ata'mal"			-- https://de.tbc.wowhead.com/quest=10707
Lang["Q2_10707"] = "Begebt Euch zur Spitze der Terrasse von Ata'mal im Schattenmondtal und beschafft das Herz des Zorns. Kehrt danach zu Akama beim Kerker des Wächters im Schattenmondtal zurück."
Lang["Q1_10708"] = "Akamas Versprechen"			-- https://de.tbc.wowhead.com/quest=10708
Lang["Q2_10708"] = "Bringt das Medaillon von Karabor zu A'dal in Shattrath."
Lang["Q1_10944"] = "Ds gefährdete Geheimnis"			-- https://de.tbc.wowhead.com/quest=10944
Lang["Q2_10944"] = "Reist zum Kerker des Wächters im Schattenmondtal und sprecht mit Akama."
Lang["Q1_10946"] = "Die List der Aschenzungen"			-- https://de.tbc.wowhead.com/quest=10946
Lang["Q2_10946"] = "Reist in die Festung der Stürme und tötet Al'ar, während Ihr die Gugel der Aschenzungen tragt. Kehrt nach Abschluss der Aufgabe zu Akama ins Schattenmondtal zurück."
Lang["Q1_10947"] = "Ein Artefakt aus der Vergangenheit"			-- https://de.tbc.wowhead.com/quest=10947
Lang["Q2_10947"] = "Reist zu den Höhlen der Zeit in Tanaris und verschafft Euch Zugang zur Schlacht um den Berg Hyjal. Habt Ihr dies geschafft, so bezwingt Furor Winterfrost und bringt das zeitverzerrte Phylakterium zu Akama im Schattenmondtal."
Lang["Q1_10948"] = "Die Seelengeisel"			-- https://de.tbc.wowhead.com/quest=10948
Lang["Q2_10948"] = "Reist nach Shattrath und erzählt A'dal von Akamas Bitte. "
Lang["Q1_10949"] = "Zutritt zum schwarzen Tempel"			-- https://de.tbc.wowhead.com/quest=10949
Lang["Q2_10949"] = "Reist zum Eingang des Schwarzen Tempels im Schattenmondtal und sprecht mit Xi'ri."
Lang["Q1_10985"] = "Ein Ablenkungsmanöver für Akama"			-- https://de.tbc.wowhead.com/quest=10985
Lang["Q2_10985"] = "Stellt sicher, dass Akama und Maiev den Schwarzen Tempel betreten, nachdem Xi'ris Streitkräfte ihr Ablenkungsmanöver durchgeführt haben."
--v243
Lang["Q1_10984"] = "Sprecht mit dem Oger"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10984
Lang["Q2_10984"] = "Sprecht mit dem Oger Grok im unteren Viertel von Shattrath."
Lang["Q1_10983"] = "Mog'dorg der Weise"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10983
Lang["Q2_10983"] = "Besucht Mog'dorg den Weisen auf einem der Türme außerhalb des Zirkels des Blutes im Schergrat."
Lang["Q1_10995"] = "Grulloc hat zwei Schädel"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10995
Lang["Q2_10995"] = "Beschafft Grullocs Drachenschädel und bringt ihn zu Mog'dorg dem Weisen auf dem Turm beim Zirkel des Blutes im Schergrat."
Lang["Q1_10996"] = "Maggocs Schatztruhe"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10996
Lang["Q2_10996"] = "Beschafft Euch Maggocs Schatztruhe und bringt sie zu Mog'dorg dem Weisen auf dem Turm beim Zirkel des Blutes im Schergrat."
Lang["Q1_10997"] = "Sogar ein Gronn hat Standards"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10997
Lang["Q2_10997"] = "Besorgt Euch Slaags Standarte und bringt sie zu Mog'dorg dem Weisen auf dem Turm beim Zirkel des Blutes im Schergrat."
Lang["Q1_10998"] = "In den übelsten Kreisen"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10998
Lang["Q2_10998"] = "Ihr müsst Vim'gols üblen Zauberfolianten beschafften. Bringt ihn zu Mog'dorg dem Weisen auf dem Turm beim Zirkel des Blutes im Schergrat."
Lang["Q1_11000"] = "Schänder der Seelen"			-- https://www.thegeekcrusade-serveur.com/db/?quest=11000
Lang["Q2_11000"] = "Beschafft Euch Skullocs Seele und bringt ihn zu Mog'dorg dem Weisen auf dem Turm beim Zirkel des Blutes im Schergrat."
Lang["Q1_11022"] = "Sprecht mit Mog'dorg"			-- https://www.thegeekcrusade-serveur.com/db/?quest=11022
Lang["Q2_11022"] = "Sprecht mit Mog'dorg dem Weisen. Er steht oben auf dem Turm auf der Ostseite des Zirkels des Blutes im Schergrat."
Lang["Q1_11009"] = "Ogerhimmel"			-- https://www.thegeekcrusade-serveur.com/db/?quest=11009
Lang["Q2_11009"] = "Mog'dorg der Weise hat Euch gebeten, mit Chu'a'lor in Ogri'la im Schergrat zu sprechen."
--v244
Lang["Q1_10804"] = "Freundlichkeit"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10804
Lang["Q2_10804"] = "Mordenai bei den Netherschwingenfeldern im Schattenmondtal möchte, dass Ihr 8 ausgewachsene Drachen der Netherschwingen füttert."
Lang["Q1_10811"] = "Sucht Neltharaku auf"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10811
Lang["Q2_10811"] = "Sucht Neltharaku, den Patron des Drachenschwarms der Netherschwingen auf."
Lang["Q1_10814"] = "Neltharakus Geschichte"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10814
Lang["Q2_10814"] = "Sprecht mit Neltharaku und hört Euch seine Geschichte an."
Lang["Q1_10836"] = "Unterwanderung der Festung des Drachenmals"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10836
Lang["Q2_10836"] = "Neltharaku, der hoch über den Netherschwingenfeldern im Schattenmondtal seine Kreise zieht, möchte, dass Ihr 15 Orcs des Drachenmals tötet."
Lang["Q1_10837"] = "Zur Netherschwingenscherbe!"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10837
Lang["Q2_10837"] = "Neltharaku, der hoch über den Netherschwingenfeldern im Schattenmondtal seine Kreise zieht, möchte, dass Ihr 12 Netherrankenkristalle auf der Netherschwingenscherbe sammelt."
Lang["Q1_10854"] = "Die Macht Neltharakus"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10854
Lang["Q2_10854"] = "Neltharaku, der hoch über den Netherschwingenfeldern im Schattenmondtal seine Kreise zieht, möchte, dass Ihr 5 versklavte Drachen der Netherschwingen befreit."
Lang["Q1_10858"] = "Karynaku"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10858
Lang["Q2_10858"] = "Sucht nach Karynaku in der Festung des Drachenmals."
Lang["Q1_10866"] = "Zuluhed der Geschlagene"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10866
Lang["Q2_10866"] = "Tötet Zuluhed den Geschlagenen und beschafft Euch Zuluheds Schlüssel. Benutzt Zuluheds Schlüssel, um Zuluheds Fesseln zu öffnen und Karynaku zu befreien."
Lang["Q1_10870"] = "Verbündeter der Netherschwingen"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10870
Lang["Q2_10870"] = "Lasst Euch von Karynaku zurück zu Mordenai in den Netherschwingenfeldern bringen."
--v247
Lang["Q1_3801"] = "Dunkeleisenerbe"			-- https://www.thegeekcrusade-serveur.com/db/?quest=3801
Lang["Q2_3801"] = "Sprecht mit Franclorn Forgewright, wenn Ihr daran interessiert seid, einen Schlüssel für die Hauptstadt zu erhalten."
Lang["Q1_3802"] = "Dunkeleisenerbe"			-- https://www.thegeekcrusade-serveur.com/db/?quest=3802
Lang["Q2_3802"] = "Erschlagt Fineous Darkvire und bergt den großen Hammer Ironfel. Bringt Ironfel zum Schrein von Thaurissan und legt ihn auf die Statue von Franclorn Forgewright."
Lang["Q1_5096"] = "Scharlachrote Ablenkung"
Lang["Q2_5096"] = "Zieht zum Basislager des Scharlachroten Kreuzzugs zwischen dem Teufelssteinfeld und Dalsons Tränenfeld und zerstört sein Kommandozelt."
Lang["Q1_5098"] = "Turm um Turm"
Lang["Q2_5098"] = "Markiert mit der Signalfackel jeden Turm in Andorhal; Ihr müsst im Eingang jedes Turmes stehen, um ihn erfolgreich zu markieren."
Lang["Q1_838"] = "Scholomance"
Lang["Q2_838"] = "Sprecht mit Apotheker Dithers am Bollwerk, Westliche Pestländer."
Lang["Q1_964"] = "Skelettfragmente"
Lang["Q2_964"] = "Bringt 15 Skelettfragmente zu Apotheker Dithers am Bollwerk, Westliche Pestländer."
Lang["Q1_5514"] = "Sold reimt sich auf..."
Lang["Q2_5514"] = "Bringt die magieerfüllten Skelettfragmente sowie 15 Goldstücke zu Krinkle Goodsteel in Gadgetzan."
Lang["Q1_5802"] = "Feuerfeder geschmiedet"
Lang["Q2_5802"] = "Bringt die Skelettschlüsselform und 2 Barren Thorium zur Spitze des Feuerfedergrats im Un'Goro Krater. Benutzt die Skelettschlüsselform am Lavasee, um den unvollendeten Skelettschlüssel zu schmieden."
Lang["Q1_5804"] = "Arajs Skarabäus"
Lang["Q2_5804"] = "Vernichtet Araj den Beschwörer und bringt Arajs Skarabäus zum Apotheker Dithers im Bollwerk, in den westlichen Pestländern.	"
Lang["Q1_5511"] = "Der Schlüssel zur Scholomance"
Lang["Q2_5511"] = "Tja, da ist er, der fertige Skelettschlüssel. Ich bin eigentlich absolut sicher, dass dieser Schlüssel Euch Zutritt zur Scholomance verschaffen wird."
Lang["Q1_5092"] = "Den Weg räumen"
Lang["Q2_5092"] = "Tötet 10 Skelettschinder und 10 sabbernde Ghuls in Sorrow Hill."
Lang["Q1_5097"] = "Turm um Turm"
Lang["Q2_5097"] = "Markiert mit der Signalfackel jeden Turm in Andorhal; Ihr müsst im Eingang jedes Turmes stehen, um ihn erfolgreich zu markieren."
Lang["Q1_5533"] = "Scholomance"
Lang["Q2_5533"] = "Sprecht mit Alchimist Arbington an der Chillwindspitze, Westliche Pestländer."
Lang["Q1_5537"] = "Skelettfragmente"
Lang["Q2_5537"] = "Bringt 15 Skelettfragmente zu Alchimist Arbington an der Chillwindspitze, Westliche Pestländer.."
Lang["Q1_5538"] = "Sold reimt sich auf..."
Lang["Q2_5538"] = "Bringt die magieerfüllten Skelettfragmente sowie 15 Goldstücke zu Krinkle Goodsteel in Gadgetzan."
Lang["Q1_5801"] = "Feuerfeder geschmiedet"
Lang["Q2_5801"] = "Bringt die Skelettschlüsselform und 2 Barren Thorium zur Spitze des Feuerfedergrats im Un'Goro Krater. Benutzt die Skelettschlüsselform am Lavasee, um den unvollendeten Skelettschlüssel zu schmieden."
Lang["Q1_5803"] = "Arajs Skarabäus"
Lang["Q2_5803"] = "Zerstört Araj den Beschwörer und bringt Arajs Skarabäus zum Alchimisten Arbington an der Chillwindspitze in den westlichen Pestländern."
Lang["Q1_5505"] = "Der Schlüssel zur Scholomance"
Lang["Q2_5505"] = "Tja, da ist er, der fertige Skelettschlüssel. Ich bin eigentlich absolut sicher, dass dieser Schlüssel Euch Zutritt zur Scholomance verschaffen wird."
--v250
Lang["Q1_6804"] = "Vergiftetes Wasser"
Lang["Q2_6804"] = "Wendet den Aspekt von Neptulon auf die vergifteten Elementare der östlichen Pestländer an. Bringt 12 disharmonische Armschienen, sowie den Aspekt von Neptulon zu Fürst Hydraxis in Azshara."
Lang["Q1_6805"] = "Stürmer und Rumpler"
Lang["Q2_6805"] = "Tötet 15 Staubstürmer und 15 Wüstenrumpler und kehrt dann zu Fürst Hydraxis in Azshara zurück."
Lang["Q1_6821"] = "Auge des Glutsehers"
Lang["Q2_6821"] = "Bringt das Auge des Glutsehers zu Fürst Hydraxis in Azshara."
Lang["Q1_6822"] = "Der geschmolzene Kern"
Lang["Q2_6822"] = "Tötet 1 Feuerlord, 1 geschmolzenen Riesen, 1 uralten Kernhund sowie 1 Lavawoger und kehrt dann zu Fürst Hydraxis in Azshara zurück."
Lang["Q1_6823"] = "Agent von Hydraxis"
Lang["Q2_6823"] = "Verdient Euch eine geehrte Fraktion bei den hydraxianischen Wasserlords und sprecht dann mit Fürst Hydraxis in Azshara."
Lang["Q1_6824"] = "Hände des Feindes"
Lang["Q2_6824"] = "Bringt die Hände von Lucifron, Sulfuron, Gehennas und Shazzrah zu Fürst Hydraxis in Azshara."
Lang["Q1_7486"] = "Die Belohnung eines Helden"
Lang["Q2_7486"] = "Nehmt Eure Belohnung aus Hydraxis' Kasten."


-- NPC
Lang["N1_9196"] = "Hochlord Omokk"	-- https://de.tbc.wowhead.com/npc=9196
Lang["N2_9196"] = "Hochlord Omokk ist der erste Boss in der unteren Schwarzfelsspitze"
Lang["N1_9237"] = "Kriegsmeisterin Voone"	-- https://de.tbc.wowhead.com/npc=9237
Lang["N2_9237"] = "Kriegsmeisterin Voone ist ein Miniboss in der unteren Schwarzfelsspitze"
Lang["N1_9568"] = "Oberanführer Wyrmthalak"	-- https://de.tbc.wowhead.com/npc=9568
Lang["N2_9568"] = "Oberanführer Wyrmthalak ist der letzte Boss in der unteren Schwarzfelsspitze"
Lang["N1_10429"] = "Kriegshäuptling Rend Blackhand"	-- https://de.tbc.wowhead.com/npc=10429
Lang["N2_10429"] = "Kriegshäuptling Rend Blackhand ist der sechste Boss der oberen Schwarzfelsspitze. Dal'rend, meist nur Rend, war der Häuptling der schwarzen Horde und der größte Gegner von Thrall."
Lang["N1_10182"] = "Rexxar"	-- https://de.tbc.wowhead.com/npc=10182
Lang["N2_10182"] = "<Champion der Horde>\n\nPattroulliert vom südlichen Steinkrallengebirge bis runter ins nördliche Feralas."
Lang["N1_8197"] = "Chronalis"	-- https://de.tbc.wowhead.com/npc=8197
Lang["N2_8197"] = "Chronalis des bronzenen Drachenschwarms.\n\nAm Eingang der Höhlen der Zeit."
Lang["N1_10664"] = "Scryer"	-- https://de.tbc.wowhead.com/npc=10664
Lang["N2_10664"] = "Scryer vom blauen Drachenschwarm.\n\nIn der Höhle bei Mazthoril"
Lang["N1_12900"] = "Somnus"	-- https://de.tbc.wowhead.com/npc=12900
Lang["N2_12900"] = "Somnus vom grünen Drachenschwarm.\n\nAn der östlichen Seite des versunkenen Tempels"
Lang["N1_12899"] = "Axtroz"	-- https://de.tbc.wowhead.com/npc=12899
Lang["N2_12899"] = "Axtroz vom roten Drachenschwarm.\n\nIn Grim Batol (Sumpfland)"
Lang["N1_10363"] = "General Drakkisath"	-- https://de.tbc.wowhead.com/npc=10363
Lang["N2_10363"] = "General Drakkisath ist der letzte Boss in der oberen Schwarzfelsspitze"
Lang["N1_8983"] = "Golem Lord Argelmach"	-- https://de.tbc.wowhead.com/npc=8983
Lang["N2_8983"] = "Golem Lord Argelmach ist der neunte Boss in den Schwarzfelstiefen."
Lang["N1_9033"] = "General Zornesschmied"	-- https://de.tbc.wowhead.com/npc=9033
Lang["N2_9033"] = "General Zornesschmied ist der siebte Boss in den Schwarzfelstiefen"
Lang["N1_17804"] = "Knappe Rowe"	-- https://de.tbc.wowhead.com/npc=17804
Lang["N2_17804"] = "Am Eingang von Stormwind (Tal der Helden)"
Lang["N1_10929"] = "Haleh"	-- https://de.tbc.wowhead.com/npc=10929
Lang["N2_10929"] = "Auf dem Berg über der Mazthoril Höhle.\nEin Portal befindet sich in der Höhle (Blaue Rune)."
Lang["N1_9046"] = "Rüstmeister der Schmetterschilde"	-- https://de.tbc.wowhead.com/npc=9046
Lang["N2_9046"] = "Ausserhalb der Instanzen, in der Nähe des Balkons vor dem Eingang der oberen Schwarzfelsspitze"
Lang["N1_15180"] = "Baristolth der Sandstürme"	-- https://de.tbc.wowhead.com/npc=15180
Lang["N2_15180"] = "Baristolth der Sandstürme befindet sich in der Festung des Cenarius in Silithus (49.6,36.6)."
Lang["N1_12017"] = "Brutwächter Dreschbringer"	-- https://de.tbc.wowhead.com/npc=12017
Lang["N2_12017"] = "Brutwächter Dreschbringer ist der dritte Boss im Pechschwingenhort."
Lang["N1_13020"] = "Vaelastrasz der Verdorbene"	-- https://de.tbc.wowhead.com/npc=13020
Lang["N2_13020"] = "Vaelastrasz der Verdorbene ist der zweite Boss im Pechschwingenhort."
Lang["N1_11583"] = "Nefarian"	-- https://de.tbc.wowhead.com/npc=11583
Lang["N2_11583"] = "Nefarian ist der letzte Boss im Pechschwingenhort."
Lang["N1_15362"] = "Malfurion Stormrage"	-- https://de.tbc.wowhead.com/npc=15362
Lang["N2_15362"] = "Er befindet sich im Tempel von Atal'Hakkar, er erscheint wenn man sich Eranikus Schemen nähert."
Lang["N1_15624"] = "Waldirrlicht"	-- https://de.tbc.wowhead.com/npc=15624
Lang["N2_15624"] = "Das Irrlicht findet man in Teldrassil in der Nähe zum Eingang von Darnassus (37.6,48.0)."
Lang["N1_15481"] = "Geist von Azuregos"	-- https://de.tbc.wowhead.com/npc=15481
Lang["N2_15481"] = "Der Geist von Azuregos läuft durch das südliche Aszhara, ca (58.8,82.2)."
Lang["N1_11811"] = "Narain Soothfancy"	-- https://de.tbc.wowhead.com/npc=11811
Lang["N2_11811"] = "In der kleinen Hütte nördlich von Steamwheedle (65.2,18.4)."
Lang["N1_15526"] = "Meridith die Meerjungfrau"	-- https://de.tbc.wowhead.com/npc=15526
Lang["N2_15526"] = "Sie befindet sich unter Wasser in der Nähe des großen Graben, ca bei (59.6,95.6). Nach Abschluss der Quest vergibt sie einen Buff um schneller zu schwimmen."
Lang["N1_15554"] = "Nummer Zwei"	-- https://de.tbc.wowhead.com/npc=15554
Lang["N2_15554"] = "Nummer Zwei wird in Winterspring beschworen, genau an der Stelle (67.2,72.6). Es dauert ein wenig bis er erscheint."
Lang["N1_15552"] = "Doktor Weavil"	-- https://de.tbc.wowhead.com/npc=15552
Lang["N2_15552"] = "Dieser fiese Gnom befindet sich auf der Insel Alcaz in den Marschen von Dustwallow (77.8,17.6). Er nervt!"
Lang["N1_10184"] = "Onyxia"	-- https://de.tbc.wowhead.com/npc=10184
Lang["N2_10184"] = "Wenn sie nicht gerade eine Lady in Stormwind miemt, findet ihr sie in Ihrer Höhle, südlich von Theramore in den Marschen von Dustwallow."
Lang["N1_11502"] = "Ragnaros"	-- https://de.tbc.wowhead.com/npc=11502
Lang["N2_11502"] = "Ragnaros, der Feuerlord, ist der zehnte und finale Boss im Geschmolzenen Kern. Er hält gerne lange Reden."
Lang["N1_12803"] = "Lord Lakmaeran"	-- https://de.tbc.wowhead.com/npc=12803
Lang["N2_12803"] = "Auf der Insel südlich von Feathermoon in Feralas. (29.8,72.6)."
Lang["N1_15571"] = "Der weiße Riese"	-- https://de.tbc.wowhead.com/npc=15571
Lang["N2_15571"] = "Du brauchst ein größeres Boot - in Azshara (65.6,54.6)"
Lang["N1_22037"] = "Schmied Gorlunk"	-- https://de.tbc.wowhead.com/npc=22037
Lang["N2_22037"] = "Zu finden an der Schmiede (irgendwie klar) (67,36), an der Nordseite des schwarzen Tempels"
Lang["N1_18733"] = "Teufelshäscher"	-- https://de.tbc.wowhead.com/npc=18733
Lang["N2_18733"] = "Rennt westlich der Höllenfeuerzitadelle durch die Höllenfeuerhalbinsel."
Lang["N1_18473"] = "Klauenkönig Ikiss"	-- https://de.tbc.wowhead.com/npc=18473
Lang["N2_18473"] = "Klauenkönig Ikiss ist der letzte Boss der Sethekkhallen im Auchindoun"
Lang["N1_20142"] = "Ordner der Zeit"	-- https://de.tbc.wowhead.com/npc=20142
Lang["N2_20142"] = "Bronzener Drache, in der Nähe des Stundenglases in den Höhlen der Zeit."
Lang["N1_20130"] = "Andormu"	-- https://de.tbc.wowhead.com/npc=20130
Lang["N2_20130"] = "Der kleine Junge neben dem Stundenglas in den Höhlen der Zeit"
Lang["N1_18096"] = "Epochenjäger"	-- https://de.tbc.wowhead.com/npc=18096
Lang["N2_18096"] = "Letzter Boss der Höhlen der Zeit: Flucht aus Durnholde, erscheint wenn Thrall nach Tarrens Mühle kommt."
Lang["N1_19880"] = "Netherpirscher Khay'ji"	-- https://de.tbc.wowhead.com/npc=19880
Lang["N2_19880"] = "Er steht in der Nähe der Schmiede in Area 52 (32,64)"
Lang["N1_19641"] = "Sphärenräuber Nesaad"	-- https://de.tbc.wowhead.com/npc=19641
Lang["N2_19641"] = "Zu finden bei (28,79). Er wird von zwei Adds begleitet"
Lang["N1_18481"] = "A'dal"	-- https://de.tbc.wowhead.com/npc=18481
Lang["N2_18481"] = "A'dal ist in der Mitte von Shattrath zu finden - das große leuchtende Ding - nicht zu übersehen"
Lang["N1_19220"] = "Pathaleon der Kalkulator"	-- https://de.tbc.wowhead.com/npc=19220
Lang["N2_19220"] = "Pathaleon der Kalkulator der letzte Boss der Mechanar."
Lang["N1_17977"] = "Warpzweig"	-- https://de.tbc.wowhead.com/npc=17977
Lang["N2_17977"] = "Warpzweig ist der fünfte Boss der Botanika. Er ist der große Urtum."
Lang["N1_17613"] = "Erzmagier Alturus"	-- https://de.tbc.wowhead.com/npc=17613
Lang["N2_17613"] = "Steht vor dem Eingang von Karazhan."
Lang["N1_18708"] = "Murmur"	-- https://de.tbc.wowhead.com/npc=18708
Lang["N2_18708"] = "Murmur ist der letzte Boss des Schattenlabyrinths. Es ist der große Windelementar."
Lang["N1_17797"] = "Hydromantin Thespia"	-- https://de.tbc.wowhead.com/npc=17797
Lang["N2_17797"] = "Hydromantin Thespia ist der erste Boss der Dampfkammer."
Lang["N1_20870"] = "Zereketh der Unabhängige"	-- https://de.tbc.wowhead.com/npc=20870
Lang["N2_20870"] = "Zereketh der Unabhängige ist der erste Boss in der Arkatraz."
Lang["N1_15608"] = "Medhivh"	-- https://de.tbc.wowhead.com/npc=15608
Lang["N2_15608"] = "Medivh steht in der nähe des Portals im Süden des schwarzen Morasts"
Lang["N1_16524"] = "Arans Schemen"	-- https://de.tbc.wowhead.com/npc=16524
Lang["N2_16524"] = "Der verrückte Vater von Medivh - zu finden in der Bibliothek in Karazhan"
Lang["N1_16807"] = "Großhexenmeister Nethekurse"	-- https://de.tbc.wowhead.com/npc=16807
Lang["N2_16807"] = "Großhexenmeister Nethekurse ist ein Hexenmeiter der Teufelsorcs und der erste Boss in den zerschmetterten Hallen."
Lang["N1_18472"] = "Dunkelwirker Syth"	-- https://de.tbc.wowhead.com/npc=18472
Lang["N2_18472"] = "Dunkelwirker Syth ist der erste Boss in den Sethekkhallen."
Lang["N1_22421"] = "Nar´biss der Ketzer"	-- https://de.tbc.wowhead.com/npc=22421
Lang["N2_22421"] = "Nar´biss der Ketzer befindet sich nur im Heroischen Modus in der Instanz. Er befindet sich kurz hinter dem ersten Boss. Springt ins Wasser, Er ist auf der linken Seite in einem Käfig."
Lang["N1_19044"] = "Gruul der Drachenschlächter"	-- https://de.tbc.wowhead.com/npc=19044
Lang["N2_19044"] = "Gruul der Drachenschlächter ist der letzte Boss des Raids Gruuls Unterschlupf im Schergrat."
Lang["N1_17225"] = "Schrecken der Nacht"	-- https://de.tbc.wowhead.com/npc=17225
Lang["N2_17225"] = "Schrecken der Nacht ist ein beschwörbarer Boss in Karazhan. Infos für die Beschwörungsquest gibt es im jeweiligen Guide."
Lang["N1_21938"] = "Erdheiler Griffelhuf"	-- https://de.tbc.wowhead.com/npc=21938
Lang["N2_21938"] = "Erdheiler Griffelhuf ist in einem kleinen Gebäude auf dem höchsten Punkt des Schattenmondtals(28.6,26.6)."
Lang["N1_21183"] = "Oronok Herzeleid"	-- https://de.tbc.wowhead.com/npc=21183
Lang["N2_21183"] = "Oronok Herzeleid ist auf dem Gipfel des Hügels bei Oronok's Farm (53.8,23.4), zwischen der Echsennarbe und dem Altar der Sha'tar."
Lang["N1_21291"] = "Grom'tor, Sohn von Oronok"	-- https://de.tbc.wowhead.com/npc=21291
Lang["N2_21291"] = "Bei der Echsennarbe (44.6,23.6)."
Lang["N1_21292"] = "Ar'tor, Sohn von Oronok"	-- https://de.tbc.wowhead.com/npc=21292
Lang["N2_21292"] = "Zu finden bei der Stätte der Illidari (29.6,50.4), wird in der Luft gefangen gehalten von roten Strahlen."
Lang["N1_21293"] = "Borak, Sohn von Oronok"	-- https://de.tbc.wowhead.com/npc=21293
Lang["N2_21293"] = "Nördlich der Stätte der Mondfinsternis (47.6,57.2)."
Lang["N1_18166"] = "Khadgar"	-- https://de.tbc.wowhead.com/npc=18166
Lang["N2_18166"] = "Er steht in der Mitte von Shattrath, direkt neben A'dal, dem großen leuchtenden Ding."
Lang["N1_16808"] = "Kargath Messerfaust"	-- https://de.tbc.wowhead.com/npc=16808
Lang["N2_16808"] = "Kriegshäuptling Kargath Messerfaust ist der letzte Boss der zerschmetterten Hallen. Spoiler: Er hat Messer an seinen Fäusten."
Lang["N1_17798"] = "Kriegsherr Kalithresh"	-- https://de.tbc.wowhead.com/npc=17798
Lang["N2_17798"] = "Kriegsherr Kalithresh ist der dritte und letzte Boss der Dampfkammer."
Lang["N1_20912"] = "Herold Horizontiss"	-- https://de.tbc.wowhead.com/npc=20912
Lang["N2_20912"] = "Herold Horizontiss ist der fünfte und letzte Boss in einem mehrere Wellen dauernden Kampf in der Arkatraz."
Lang["N1_20977"] = "Millhouse Manasturm"	-- https://de.tbc.wowhead.com/npc=20977
Lang["N2_20977"] = "Millhouse Manasturm ist ein Gnomenmagier während des Herold Horizontiss Kampfes in der Arkatraz. Er hilft indem er die freigelassenen Mobs bekämpft."
Lang["N1_17257"] = "Magtheridon"	-- https://de.tbc.wowhead.com/npc=17257
Lang["N2_17257"] = "Magtheridon wird unter der Höllenfeuerzitadelle festgehalten. Der Raid heisst Magtheridons Kammer"
Lang["N1_21937"] = "Erdheiler Sophurus"	-- https://de.tbc.wowhead.com/npc=21937
Lang["N2_21937"] = "Erdheiler Sophurus ist ausserhalb der Taverne in der Festung der Wildhämmer zu finden (36.4,56.8)."
Lang["N1_19935"] = "Soridormi"	-- https://de.tbc.wowhead.com/npc=19935
Lang["N2_19935"] = "Soridormi läuft um das große Stundenglas innerhalb der Höhlen der Zeit"
Lang["N1_19622"] = "Kael'thas Sonnenwanderer"	-- https://de.tbc.wowhead.com/npc=19622
Lang["N2_19622"] = "Kael'thas Sonnenwanderer ist der vierte und letzte Boss des Raids Das Auge."
Lang["N1_21212"] = "Lady Vashj"	-- https://de.tbc.wowhead.com/npc=21212
Lang["N2_21212"] = "Lady Vashj ist der letzte Boss des Raids Höhle des Schlangenschreins."
Lang["N1_21402"] = "Anchoretin Ceyla"	-- https://de.tbc.wowhead.com/npc=21402
Lang["N2_21402"] = "Anchoretin Ceyla befindet sich am Altar der Sha´tar (62.6,28.4)."
Lang["N1_21955"] = "Arkanist Thelis"	-- https://de.tbc.wowhead.com/npc=21955
Lang["N2_21955"] = "Arkanist Thelis befindet sich innerhalb des Sanktums der Sterne(56.2,59.6)"
Lang["N1_21962"] = "Seher Udalo"	-- https://de.tbc.wowhead.com/npc=21962
Lang["N2_21962"] = "Er liegt tot vor der kleinen Rampe vor dem letzten Boss in der Arkatraz."
Lang["N1_22006"] = "Schattenfürst Todesklage"	-- https://de.tbc.wowhead.com/npc=22006
Lang["N2_22006"] = "Er reitet auf einem Drachen in der Stadt nördlich des schwarzen Tempels (71.6,35.6) "
Lang["N1_22820"] = "Seher Olum"	-- https://de.tbc.wowhead.com/npc=22820
Lang["N2_22820"] = "Seher Olum ist in der Höhle des Schlangenschreins, hinter Tiefenlord Karathress."
Lang["N1_21700"] = "Akama"	-- https://de.tbc.wowhead.com/npc=21700
Lang["N2_21700"] = "Akama befindet sich im Kerker des Wächters (58.0,48.2)."
Lang["N1_19514"] = "Al'ar"	-- https://de.tbc.wowhead.com/npc=19514
Lang["N2_19514"] = "Al'ar ist der erste Boss des Auges. Der Vogel hat Feuer!"
Lang["N1_17767"] = "Furor Winterfrost"	-- https://de.tbc.wowhead.com/npc=17767
Lang["N2_17767"] = "Furor Winterfrost ist der erste Boss in der Schlacht um den Berg Hyjal."
Lang["N1_18528"] = "Xi'ri"	-- https://de.tbc.wowhead.com/npc=18528
Lang["N2_18528"] = "Xi'ri befindet sich am Eingagn des schwarzen Tempels. Großes, blaues, leuchtendes Ding. Was macht es? Es leuchtet blau!."
--v243
Lang["N1_22497"] = "V'eru"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22497
Lang["N2_22497"] = "V'eru ist im selben Raum wie A'dal, aber er ist blau. Er ist auf dem obersten Treppenabsatz."
--v244
Lang["N1_22113"] = "Mordenai"
Lang["N2_22113"] = "Ein Blutelfen (Spoiler-Alarm, eigentlich ein Drache), der die Netherschwingenfelder östlich des Heiligtums der Sterne durchwandert"
--v247
Lang["N1_8888"]  = "Franclorn Forgewright"
Lang["N2_8888"]  = "Ein Geisterzwerg, der auf seinem eigenen Grab AUSSERHALB des Verlieses steht, in der Struktur, die über der Lava hängt. Sie können nur mit ihm interagieren, wenn Sie tot sind."
Lang["N1_9056"]  = "Fineous Darkvire"
Lang["N2_9056"]  = "Er ist INNERHALB des Kerkers und patrouilliert im Steinbruchgebiet außerhalb von Lord Incendius' Kammer."
Lang["N1_10837"] = "Hochexekutor Derrington"
Lang["N2_10837"] = "Er befindet sich am Bollwerk, nahe der Grenze von Tirisfal und den Westlichen Pestländern"
Lang["N1_10838"] = "Kommandant Ashlam Valorfist"
Lang["N2_10838"] = "Er befindet sich im Chillwind Camp, südlich von Andorhal in den Westlichen Pestländern"
Lang["N1_1852"]  = "Araj der Beschwörer"
Lang["N2_1852"]  = "Der Lich, mitten in Andorhal"
--v250
Lang["N1_13278"]  = "Fürst Hydraxis"
Lang["N2_13278"]  = "Ein großer Wasserelementar auf einer winzigen, weit entfernten Insel in Azshara (79.2,73.6)"
Lang["N1_12264"]  = "Shazzrah"
Lang["N2_12264"]  = "Shazzrah ist der fünfte Boss von den geschmolzenen Kern."
Lang["N1_12118"]  = "Lucifron"
Lang["N2_12118"]  = "Lucifron ist der erste Boss von den geschmolzenen Kern."
Lang["N1_12259"]  = "Gehennas"
Lang["N2_12259"]  = "Gehennas ist der dritte Boss von den geschmolzenen Kern."
Lang["N1_12098"]  = "Sulfuronherold"
Lang["N2_12098"]  = "Sulfuron, herold von Ragnaros, ist der achte Boss von den geschmolzenen Kern."
-- Ragefire Chasm / Deadmines
Lang["N1_11519"] = "Bazzalan"
Lang["N2_11519"] = "Bazzalan ist ein Satyr-Boss auf dem oberen Vorsprung über Jergosh im Flammenschlund."
Lang["N1_11518"] = "Jergosh der Herbeirufer"
Lang["N2_11518"] = "Jergosh der Herbeirufer ist ein Hexenmeister-Boss im hinteren Teil des Flammenschlunds."
Lang["N1_11520"] = "Taragaman der Hungerleider"
Lang["N2_11520"] = "Taragaman der Hungerleider ist der Teufelswache-Boss im Lavasee des Flammenschlunds."
Lang["N1_11834"] = "Maur Grimmtotem"
Lang["N2_11834"] = "Maur Grimmtotems Leichnam liegt hinter dem ersten Boss im Flammenschlund, abseits des rechten Pfades."
Lang["N1_639"] = "Edwin van Cleef"
Lang["N2_639"] = "Edwin van Cleef ist der Endboss der Todesminen, an Bord des Piratenschiffs in der Eisenclad-Bucht."
-- Shadowfang Keep
Lang["N1_4275"] = "Erzmagier Arugal"
Lang["N2_4275"] = "Erzmagier Arugal ist der Endboss von Burg Shadowfang, ganz oben in der Burg."
Lang["N1_3849"] = "Todespirscher Adamant"
Lang["N2_3849"] = "Todespirscher Adamants Leichnam liegt früh in Burg Shadowfang, in einem Nebenraum abseits des Hofwegs."
Lang["N1_4444"] = "Todespirscher Vincent"
Lang["N2_4444"] = "Todespirscher Vincents Leichnam befindet sich tiefer in Burg Shadowfang, in der Nähe des Speisesaals."
-- Blackfathom Deeps
Lang["N1_4787"] = "Argentumwache Thaelrid"
Lang["N2_4787"] = "Argentumwache Thaelrid befindet sich in der Blackfathom-Tiefe, hinter den ersten Naga-Höhlen."
Lang["N1_4832"] = "Twilight-Lord Kelris"
Lang["N2_4832"] = "Twilight-Lord Kelris ist ein Boss in der Blackfathom-Tiefe, im Mondschreinsanktum."
Lang["N1_12902"] = "Lorgus Jett"
Lang["N2_12902"] = "Lorgus Jett ist ein Zauberer des Schattenhammers in der Blackfathom-Tiefe, auf dem Weg zum Sanktum."
-- Gnomeregan
Lang["N1_7800"] = "Robogenieur Thermaplugg"
Lang["N2_7800"] = "Robogenieur Thermaplugg ist der Endboss von Gnomeregan, im Tüftlerhof."
Lang["N1_6231"] = "Techbot"
Lang["N2_6231"] = "Techbot steht nahe dem Eingang von Gnomeregan, außerhalb der Instanz."
Lang["N1_7850"] = "Kernobee"
Lang["N2_7850"] = "Kernobee befindet sich in Gnomeregan und startet die Eskortquest Eine schöne Bescherung."
-- Razorfen Kraul
Lang["N1_4421"] = "Charlga Razorflank"
Lang["N2_4421"] = "Charlga Razorflank ist der Endboss des Kral von Razorfen."
Lang["N1_4508"] = "Willix der Importeur"
Lang["N2_4508"] = "Willix der Importeur befindet sich im Kral von Razorfen und muss hinausbegleitet werden."


Lang["O_1"] = "Klicke auf Drakkisaths Brandzeichen um die Quest abzuschließen.\nEs ist der glühende Ball hinter General Drakkisath."
Lang["O_2"] = "Es ist ein kleiner, rot glühender Punkt auf dem Boden\nVor den Toren von Ahn'Qiraj (28.7,89.2)."
--v247
Lang["O_3"] = "Der Schrein befindet sich am Ende eines Korridors,\nder auf der oberen Ebene des Ring of Law beginnt."

-- Synced from enUS (missing keys â€” English fallback until translated)
Lang["Beast"] = "Beast"
Lang["Blackfathom Deeps"] = "Blackfathom Deeps"
Lang["Blackrock Depths Quests"] = "Blackrock Depths Quests"
Lang["DUNGEONS"] = "DUNGEONS"
Lang["Darkshore"] = "Darkshore"
Lang["Darnassus"] = "Darnassus"
Lang["Dire Maul"] = "Dire Maul"
Lang["Dun Morogh"] = "Dun Morogh"
Lang["DungeonQuest_Desc"] = "Complete the dungeon quests and any chains that lead into this instance."
Lang["Durotar"] = "Durotar"
Lang["Giant"] = "Giant"
Lang["Gnomeregan"] = "Gnomeregan"
Lang["Hillsbrad Foothills"] = "Hillsbrad Foothills"
Lang["I_10420"] = "Skull of the Coldbringer"
Lang["I_10454"] = "Essence of Eranikus"
Lang["I_10465"] = "Egg of Hakkar"
Lang["I_11230"] = "Encased Fiery Essence"
Lang["I_11268"] = "Head of Argelmach"
Lang["I_11269"] = "Intact Elemental Core"
Lang["I_11309"] = "The Heart of the Mountain"
Lang["I_11312"] = "Lost Thunderbrew Recipe"
Lang["I_11313"] = "Ribbly's Head"
Lang["I_11468"] = "Dark Iron Fanny Pack"
Lang["I_13172"] = "Grimm's Premium Tobacco"
Lang["I_13174"] = "Plagued Flesh Sample"
Lang["I_13176"] = "Scourge Data"
Lang["I_13180"] = "Stratholme Holy Water"
Lang["I_13207"] = "Head of Baron Rivendare"
Lang["I_13250"] = "Head of Balnazzar"
Lang["I_13471"] = "The Deed to Brill"
Lang["I_13626"] = "Human Head of Ras Frostwhisper"
Lang["I_13725"] = "Krastinov's Bag of Horrors"
Lang["I_14395"] = "Spells of Shadow"
Lang["I_14396"] = "Incantations from the Nether"
Lang["I_14540"] = "Taragaman the Hungerer's Heart"
Lang["I_14544"] = "Lieutenant's Insignia"
Lang["I_14679"] = "Of Love and Family"
Lang["I_17009"] = "Ambassador Malcin's Head"
Lang["I_17684"] = "Theradric Crystal Carving"
Lang["I_17702"] = "Celebrian Rod"
Lang["I_17703"] = "Celebrian Diamond"
Lang["I_17756"] = "Shadowshard Fragment"
Lang["I_17758"] = "Amulet of Union"
Lang["I_18240"] = "Azj'Tordin's Book of Incantations"
Lang["I_18426"] = "Lethtendris's Web"
Lang["I_18502"] = "Felvine Shard"
Lang["I_1875"] = "Thistlenettle's Badge"
Lang["I_1894"] = "Miners' Union Card"
Lang["I_274286"] = "Durgen Dirgehammer's Head"
Lang["I_274289"] = "Dwarven Heirloom"
Lang["I_281030"] = "Treaty of Understanding"
Lang["I_2874"] = "An Unsent Letter"
Lang["I_2909"] = "Red Wool Bandana"
Lang["I_2926"] = "Head of Bazil Thredd"
Lang["I_3628"] = "Hand of Dextren Ward"
Lang["I_3630"] = "Head of Targorr"
Lang["I_3637"] = "Head of VanCleef"
Lang["I_4635"] = "Hammertoe's Amulet"
Lang["I_5824"] = "Tablet of Will"
Lang["I_5826"] = "Tablet of Ryun'eh"
Lang["I_6188"] = "Fetish of Hakkar"
Lang["I_6212"] = "Head of Jammal'an"
Lang["I_6288"] = "Atal'ai Tablet"
Lang["I_7365"] = "Gnoam Sprecklesprocket"
Lang["I_7672"] = "Obsidian Power Source"
Lang["I_7740"] = "Shattered Necklace"
Lang["I_8009"] = "Dentrium Power Stone"
Lang["I_8047"] = "Magenta Fungus Cap"
Lang["I_8052"] = "An'Alleum Power Stone"
Lang["I_8622"] = "Tiara of the Deep"
Lang["I_8623"] = "First Mosh'aru Tablet"
Lang["I_8624"] = "Second Mosh'aru Tablet"
Lang["I_8625"] = "Divino-matic Rod"
Lang["I_8707"] = "Gahz'rilla's Electrified Scale"
Lang["I_915"] = "Red Silk Bandana"
Lang["I_9238"] = "Uncracked Scarab Shell"
Lang["I_9471"] = "Nekrum's Medallion"
Lang["I_9523"] = "Troll Temper"
Lang["Ironforge"] = "Ironforge"
Lang["Loch Modan"] = "Loch Modan"
Lang["Maraudon"] = "Maraudon"
Lang["N1_"] = ""
Lang["N1_10439"] = "Baron Rivendare"
Lang["N1_10503"] = "Jandice Barov"
Lang["N1_10506"] = "Kirtonos the Herald"
Lang["N1_10508"] = "Ras Frostwhisper"
Lang["N1_10811"] = "Archivist Galford"
Lang["N1_11261"] = "Doctor Theolen Krastinov"
Lang["N1_11486"] = "Prince Tortheldrin"
Lang["N1_11496"] = "Immol'thar"
Lang["N1_12201"] = "Princess Theradras"
Lang["N1_12236"] = "Lord Vyletongue"
Lang["N1_12865"] = "Ambassador Malcin"
Lang["N1_13282"] = "Noxxion"
Lang["N1_14327"] = "Lethtendris"
Lang["N1_1663"] = "Dextren Ward"
Lang["N1_1696"] = "Targorr the Dread"
Lang["N1_1716"] = "Bazil Thredd"
Lang["N1_261306"] = "Faldrim Anvilmar"
Lang["N1_261319"] = "Durgen Dirgehammer"
Lang["N1_2748"] = "Archaedas"
Lang["N1_3974"] = "Houndmaster Loksey"
Lang["N1_3975"] = "Herod"
Lang["N1_3976"] = "Scarlet Commander Mograine"
Lang["N1_3977"] = "High Inquisitor Whitemane"
Lang["N1_5710"] = "Jammal'an the Prophet"
Lang["N1_7272"] = "Theka the Martyr"
Lang["N1_7273"] = "Gahz'rilla"
Lang["N1_7358"] = "Amnennar the Coldbringer"
Lang["N1_7795"] = "Hydromancer Velratha"
Lang["N1_7797"] = "Nekrum Gutchewer"
Lang["N1_9016"] = "Bael'Gar"
Lang["N1_9017"] = "Lord Incendius"
Lang["N1_9019"] = "Emperor Dagran Thaurissan"
Lang["N1_9543"] = "Ribbly Screwspigot"
Lang["N2_"] = ""
Lang["N2_10439"] = "Baron Rivendare is the final boss of Stratholme Undead."
Lang["N2_10503"] = "Jandice Barov is a Scholomance boss who drops Krastinov's Bag of Horrors."
Lang["N2_10506"] = "Kirtonos the Herald is summoned on the Scholomance porch with the Blood of Innocents."
Lang["N2_10508"] = "Ras Frostwhisper is a lich boss in Scholomance."
Lang["N2_10811"] = "Archivist Galford is in the Scarlet Bastion wing of Stratholme."
Lang["N2_11261"] = "Doctor Theolen Krastinov, the Butcher, is a Scholomance boss."
Lang["N2_11486"] = "Prince Tortheldrin is the final boss of Dire Maul West, in the Athenaeum."
Lang["N2_11496"] = "Immol'thar is imprisoned in Dire Maul West and must be freed by destroying the pylons."
Lang["N2_12201"] = "Princess Theradras is the final boss of Maraudon, in Zaetar's Grave."
Lang["N2_12236"] = "Lord Vyletongue is a Maraudon boss in the purple crystal wing."
Lang["N2_12865"] = "Ambassador Malcin camps outside Razorfen Downs among the Death's Head forces."
Lang["N2_13282"] = "Noxxion is a Maraudon boss in the orange crystal wing (Wicked Grotto)."
Lang["N2_14327"] = "Lethtendris is a Dire Maul East boss who drops Lethtendris's Web."
Lang["N2_1663"] = "Dextren Ward is a boss in The Stockade, found at the end of the left wing."
Lang["N2_1696"] = "Targorr the Dread is a boss in The Stockade, found at the end of the right wing."
Lang["N2_1716"] = "Bazil Thredd is the final boss of The Stockade, VanCleef's lieutenant held in the deepest cells."
Lang["N2_261306"] = "Faldrim Anvilmar patrols Anvilmar's Rest inside the Hall of Thanes."
Lang["N2_261319"] = "Durgen Dirgehammer is the final boss of the Hall of Thanes."
Lang["N2_2748"] = "Archaedas is the final boss of Uldaman."
Lang["N2_3974"] = "Houndmaster Loksey is the boss of Scarlet Monastery Library, in the courtyard with his hounds."
Lang["N2_3975"] = "Herod the Scarlet Champion is the boss of Scarlet Monastery Armory."
Lang["N2_3976"] = "Scarlet Commander Mograine is fought in Scarlet Monastery Cathedral; Whitemane resurrects him."
Lang["N2_3977"] = "High Inquisitor Whitemane is the final boss of Scarlet Monastery Cathedral."
Lang["N2_5710"] = "Jammal'an the Prophet is a boss in the Temple of Atal'Hakkar."
Lang["N2_7272"] = "Theka the Martyr is a Zul'Farrak boss who drops the First Mosh'aru Tablet."
Lang["N2_7273"] = "Gahz'rilla is summoned at the pool in Zul'Farrak with the Mallet of Zul'Farrak."
Lang["N2_7358"] = "Amnennar the Coldbringer is the final boss of Razorfen Downs, atop the Spiral of Thorns."
Lang["N2_7795"] = "Hydromancer Velratha patrols near Gahz'rilla's pool in Zul'Farrak."
Lang["N2_7797"] = "Nekrum Gutchewer appears during the Zul'Farrak pyramid stairs event."
Lang["N2_9016"] = "Bael'Gar is a giant magma elemental boss in Blackrock Depths."
Lang["N2_9017"] = "Lord Incendius is a fire elemental boss near the Black Anvil in Blackrock Depths."
Lang["N2_9019"] = "Emperor Dagran Thaurissan is the final boss of Blackrock Depths."
Lang["N2_9543"] = "Ribbly Screwspigot is found in the Grim Guzzler in Blackrock Depths."
Lang["Q1_1013"] = "The Book of Ur"
Lang["Q1_1014"] = "Arugal Must Die"
Lang["Q1_1048"] = "Into The Scarlet Monastery"
Lang["Q1_1049"] = "Compendium of the Fallen"
Lang["Q1_1050"] = "Mythology of the Titans"
Lang["Q1_1051"] = "Vorrel's Revenge"
Lang["Q1_1052"] = "Down the Scarlet Path"
Lang["Q1_1053"] = "In the Name of the Light"
Lang["Q1_1098"] = "Deathstalkers in Shadowfang"
Lang["Q1_1100"] = "Lonebrow's Journal"
Lang["Q1_1101"] = "The Crone of the Kraul"
Lang["Q1_1102"] = "A Vengeful Fate"
Lang["Q1_1109"] = "Going, Going, Guano!"
Lang["Q1_1113"] = "Hearts of Zeal"
Lang["Q1_1139"] = "The Lost Tablets of Will"
Lang["Q1_1142"] = "Mortality Wanes"
Lang["Q1_1144"] = "Willix the Importer"
Lang["Q1_1149"] = "Test of Faith"
Lang["Q1_1150"] = "Test of Endurance"
Lang["Q1_1151"] = "Test of Strength"
Lang["Q1_1152"] = "Test of Lore"
Lang["Q1_1154"] = "Test of Lore"
Lang["Q1_1159"] = "Test of Lore"
Lang["Q1_1160"] = "Test of Lore"
Lang["Q1_1198"] = "In Search of Thaelrid"
Lang["Q1_1199"] = "Twilight Falls"
Lang["Q1_12"] = "The People's Militia"
Lang["Q1_1200"] = "Blackfathom Villainy"
Lang["Q1_1221"] = "Blueleaf Tubers"
Lang["Q1_1275"] = "Researching the Corruption"
Lang["Q1_13"] = "The People's Militia"
Lang["Q1_132"] = "The Defias Brotherhood"
Lang["Q1_135"] = "The Defias Brotherhood"
Lang["Q1_1360"] = "Reclaimed Treasures"
Lang["Q1_1394"] = "Final Passage"
Lang["Q1_14"] = "The People's Militia"
Lang["Q1_141"] = "The Defias Brotherhood"
Lang["Q1_142"] = "The Defias Brotherhood"
Lang["Q1_1445"] = "The Temple of Atal'Hakkar"
Lang["Q1_1446"] = "Jammal'an the Prophet"
Lang["Q1_1475"] = "Into The Temple of Atal'Hakkar"
Lang["Q1_1486"] = "Deviate Hides"
Lang["Q1_1487"] = "Deviate Eradication"
Lang["Q1_1489"] = "Hamuul Runetotem"
Lang["Q1_1490"] = "Nara Wildmane"
Lang["Q1_1491"] = "Smart Drinks"
Lang["Q1_155"] = "The Defias Brotherhood"
Lang["Q1_166"] = "The Defias Brotherhood"
Lang["Q1_167"] = "Oh Brother..."
Lang["Q1_168"] = "Collecting Memories"
Lang["Q1_17"] = "Uldaman Reagent Run"
Lang["Q1_2040"] = "Underground Assault"
Lang["Q1_2041"] = "Speak with Shoni"
Lang["Q1_214"] = "Red Silk Bandanas"
Lang["Q1_2200"] = "Back to Uldaman"
Lang["Q1_2201"] = "Find the Gems"
Lang["Q1_2202"] = "Uldaman Reagent Run"
Lang["Q1_2204"] = "Restoring the Necklace"
Lang["Q1_2240"] = "The Hidden Chamber"
Lang["Q1_2278"] = "The Platinum Discs"
Lang["Q1_2279"] = "The Platinum Discs"
Lang["Q1_2280"] = "The Platinum Discs"
Lang["Q1_2283"] = "Necklace Recovery"
Lang["Q1_2284"] = "Necklace Recovery, Take 2"
Lang["Q1_2339"] = "Find the Gems and Power Source"
Lang["Q1_2342"] = "Reclaimed Treasures"
Lang["Q1_2398"] = "The Lost Dwarves"
Lang["Q1_2418"] = "Power Stones"
Lang["Q1_261"] = "Down the Scarlet Path"
Lang["Q1_2768"] = "Divino-matic Rod"
Lang["Q1_2770"] = "Gahz'rilla"
Lang["Q1_2841"] = "Rig Wars"
Lang["Q1_2842"] = "Chief Engineer Scooty"
Lang["Q1_2843"] = "Gnomer-gooooone!"
Lang["Q1_2846"] = "Tiara of the Deep"
Lang["Q1_2865"] = "Scarab Shells"
Lang["Q1_2904"] = "A Fine Mess"
Lang["Q1_2922"] = "Save Techbot's Brain!"
Lang["Q1_2923"] = "Tinkmaster Overspark"
Lang["Q1_2924"] = "Essential Artificials"
Lang["Q1_2926"] = "Gnogaine"
Lang["Q1_2927"] = "The Day After"
Lang["Q1_2928"] = "Gyrodrillmatic Excavationators"
Lang["Q1_2929"] = "The Grand Betrayal"
Lang["Q1_2936"] = "The Spider God"
Lang["Q1_2991"] = "Nekrum's Medallion"
Lang["Q1_3042"] = "Troll Temper"
Lang["Q1_3341"] = "Bring the End"
Lang["Q1_3369"] = "In Nightmares"
Lang["Q1_3373"] = "The Essence of Eranikus"
Lang["Q1_3380"] = "The Sunken Temple"
Lang["Q1_3444"] = "The Stone Circle"
Lang["Q1_3445"] = "The Sunken Temple"
Lang["Q1_3446"] = "Into the Depths"
Lang["Q1_3447"] = "Secret of the Circle"
Lang["Q1_3523"] = "Scourge of the Downs"
Lang["Q1_3525"] = "Extinguishing the Idol"
Lang["Q1_3527"] = "The Prophecy of Mosh'aru"
Lang["Q1_3528"] = "The God Hakkar"
Lang["Q1_3636"] = "Bring the Light"
Lang["Q1_373"] = "The Unsent Letter"
Lang["Q1_377"] = "Crime and Punishment"
Lang["Q1_386"] = "What Comes Around..."
Lang["Q1_387"] = "Quell The Uprising"
Lang["Q1_388"] = "The Color of Blood"
Lang["Q1_389"] = "Bazil Thredd"
Lang["Q1_3906"] = "Disharmony of Flame"
Lang["Q1_3907"] = "Disharmony of Fire"
Lang["Q1_391"] = "The Stockade Riots"
Lang["Q1_3981"] = "Commander Gor'shak"
Lang["Q1_4001"] = "What Is Going On?"
Lang["Q1_4002"] = "The Eastern Kingdoms"
Lang["Q1_4003"] = "The Royal Rescue"
Lang["Q1_4004"] = "The Princess Saved?"
Lang["Q1_4024"] = "A Taste of Flame"
Lang["Q1_4063"] = "The Rise of the Machines"
Lang["Q1_4081"] = "KILL ON SIGHT: Dark Iron Dwarves"
Lang["Q1_4082"] = "KILL ON SIGHT: High Ranking Dark Iron Officials"
Lang["Q1_4123"] = "The Heart of the Mountain"
Lang["Q1_4126"] = "Hurley Blackbreath"
Lang["Q1_4134"] = "Lost Thunderbrew Recipe"
Lang["Q1_4136"] = "Ribbly Screwspigot"
Lang["Q1_4201"] = "The Love Potion"
Lang["Q1_4262"] = "Overmaster Pyron"
Lang["Q1_4263"] = "Incendius!"
Lang["Q1_4286"] = "The Good Stuff"
Lang["Q1_4341"] = "Kharan Mighthammer"
Lang["Q1_4342"] = "Kharan's Tale"
Lang["Q1_4361"] = "The Bearer of Bad News"
Lang["Q1_4362"] = "The Fate of the Kingdom"
Lang["Q1_4363"] = "The Princess's Surprise"
Lang["Q1_5212"] = "The Flesh Does Not Lie"
Lang["Q1_5213"] = "The Active Agent"
Lang["Q1_5214"] = "The Great Ezra Grimm"
Lang["Q1_5243"] = "Houses of the Holy"
Lang["Q1_5251"] = "The Archivist"
Lang["Q1_5262"] = "The Truth Comes Crashing Down"
Lang["Q1_5263"] = "Above and Beyond"
Lang["Q1_5282"] = "The Restless Souls"
Lang["Q1_5341"] = "Barov Family Fortune"
Lang["Q1_5342"] = "The Last Barov"
Lang["Q1_5343"] = "Barov Family Fortune"
Lang["Q1_5344"] = "The Last Barov"
Lang["Q1_5382"] = "Doctor Theolen Krastinov, the Butcher"
Lang["Q1_5384"] = "Kirtonos the Herald"
Lang["Q1_5463"] = "Menethil's Gift"
Lang["Q1_5466"] = "The Lich, Ras Frostwhisper"
Lang["Q1_5515"] = "Krastinov's Bag of Horrors"
Lang["Q1_5526"] = "Shards of the Felvine"
Lang["Q1_5529"] = "Plagued Hatchlings"
Lang["Q1_5722"] = "Searching for the Lost Satchel"
Lang["Q1_5723"] = "Testing an Enemy's Strength"
Lang["Q1_5724"] = "Returning the Lost Satchel"
Lang["Q1_5725"] = "The Power to Destroy..."
Lang["Q1_5726"] = "Hidden Enemies"
Lang["Q1_5727"] = "Hidden Enemies"
Lang["Q1_5728"] = "Hidden Enemies"
Lang["Q1_5729"] = "Hidden Enemies"
Lang["Q1_5730"] = "Hidden Enemies"
Lang["Q1_5761"] = "Slaying the Beast"
Lang["Q1_5848"] = "Of Love and Family"
Lang["Q1_6141"] = "Brother Anton"
Lang["Q1_65"] = "The Defias Brotherhood"
Lang["Q1_6521"] = "An Unholy Alliance"
Lang["Q1_6522"] = "An Unholy Alliance"
Lang["Q1_6561"] = "Blackfathom Villainy"
Lang["Q1_6562"] = "Trouble in the Deeps"
Lang["Q1_6563"] = "The Essence of Aku'Mai"
Lang["Q1_6564"] = "Allegiance to the Old Gods"
Lang["Q1_6565"] = "Allegiance to the Old Gods"
Lang["Q1_6626"] = "A Host of Evil"
Lang["Q1_6627"] = "Test of Lore"
Lang["Q1_6628"] = "Test of Lore"
Lang["Q1_6921"] = "Amongst the Ruins"
Lang["Q1_6981"] = "The Glowing Shard"
Lang["Q1_7028"] = "Twisted Evils"
Lang["Q1_7029"] = "Vyletongue Corruption"
Lang["Q1_7041"] = "Vyletongue Corruption"
Lang["Q1_7044"] = "Legends of Maraudon"
Lang["Q1_7046"] = "The Scepter of Celebras"
Lang["Q1_7064"] = "Corruption of Earth and Seed"
Lang["Q1_7065"] = "Corruption of Earth and Seed"
Lang["Q1_7066"] = "Seed of Life"
Lang["Q1_7067"] = "The Pariah's Instructions"
Lang["Q1_7068"] = "Shadowshard Fragments"
Lang["Q1_7070"] = "Shadowshard Fragments"
Lang["Q1_709"] = "Solution to Doom"
Lang["Q1_721"] = "A Sign of Hope"
Lang["Q1_722"] = "Amulet of Secrets"
Lang["Q1_7441"] = "Pusillin and the Elder Azj'Tordin"
Lang["Q1_7461"] = "The Madness Within"
Lang["Q1_7462"] = "The Treasure of the Shen'dralar"
Lang["Q1_7481"] = "Elven Legends"
Lang["Q1_7482"] = "Elven Legends"
Lang["Q1_7488"] = "Lethtendris's Web"
Lang["Q1_7489"] = "Lethtendris's Web"
Lang["Q1_78916"] = "The Heart of the Void"
Lang["Q1_78917"] = "The Heart of the Void"
Lang["Q1_79987"] = "Return of the Ring"
Lang["Q1_80140"] = "Return of the Ring"
Lang["Q1_80324"] = "The Mad King"
Lang["Q1_80325"] = "The Mad King"
Lang["Q1_865"] = "Raptor Horns"
Lang["Q1_870"] = "The Forgotten Pools"
Lang["Q1_877"] = "The Stagnant Oasis"
Lang["Q1_880"] = "Altered Beings"
Lang["Q1_886"] = "The Barrens Oases"
Lang["Q1_914"] = "Leaders of the Fang"
Lang["Q1_92401"] = "A Frightened Request"
Lang["Q1_92415"] = "Remember That I Love You"
Lang["Q1_92421"] = "Light's Justice"
Lang["Q1_92422"] = "The Wrath of Rath'mael"
Lang["Q1_92742"] = "Testing the Wells"
Lang["Q1_92744"] = "Murloc Gills"
Lang["Q1_92745"] = "The State of the Mines"
Lang["Q1_92747"] = "Moonbrook Espionage"
Lang["Q1_92748"] = "Explosive Consultation"
Lang["Q1_92749"] = "A Dynamite Plan"
Lang["Q1_92750"] = "Detonation at a Distance"
Lang["Q1_92751"] = "Detonation at a Distance"
Lang["Q1_92752"] = "Explosive Consultation"
Lang["Q1_92753"] = "Destruction in Deadmines"
Lang["Q1_95189"] = "Crest of Lordaeron"
Lang["Q1_95195"] = "Bloodied Insignia"
Lang["Q1_95204"] = "Crest of Lordaeron"
Lang["Q1_95216"] = "The New Plague"
Lang["Q1_95250"] = "Abominable Creatures"
Lang["Q1_959"] = "Trouble at the Docks"
Lang["Q1_962"] = "Serpentbloom"
Lang["Q1_96393"] = "Old Ironforge Incursion"
Lang["Q1_96394"] = "The Restless Dead"
Lang["Q1_96395"] = "An Ancient Grudge"
Lang["Q1_96403"] = "Important Heirlooms"
Lang["Q1_971"] = "Knowledge in the Deeps"
Lang["Q1_97288"] = "Unending Torment"
Lang["Q1_98423"] = "The Treaty of Understanding"
Lang["Q2_1013"] = "Bring the Book of Ur to Keeper Bel'dugur in the Undercity."
Lang["Q2_1014"] = "Kill Arugal and bring his head to Dalar Dawnweaver at the Sepulcher."
Lang["Q2_1048"] = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod, and Houndmaster Loksey, then report to Varimathras in the Undercity."
Lang["Q2_1049"] = "Retrieve the Compendium of the Fallen from the Monastery and return to Sage Truthseeker in Thunder Bluff."
Lang["Q2_1050"] = "Retrieve Mythology of the Titans from the Monastery and bring it to Librarian Mae Paledust in Ironforge."
Lang["Q2_1051"] = "Return Vorrel Sengutz's wedding ring to Monika Sengutz in Tarren Mill."
Lang["Q2_1052"] = "Take Brother Anton's Letter of Commendation to Raleigh the Devout in Southshore."
Lang["Q2_1053"] = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod, and Houndmaster Loksey, then report to Raleigh the Devout in Southshore."
Lang["Q2_1098"] = "Find the Deathstalker Adamant and Deathstalker Vincent."
Lang["Q2_1100"] = "Read Henrig Lonebrow's Journal."
Lang["Q2_1101"] = "Bring Razorflank's Medallion to Falfindel Waywarder in Thalanaar."
Lang["Q2_1102"] = "Bring Razorflank's Heart to Auld Stonespire in Thunder Bluff."
Lang["Q2_1109"] = "Bring 1 pile of Kraul Guano to Master Apothecary Faranell in the Undercity."
Lang["Q2_1113"] = "Master Apothecary Faranell in the Undercity wants 20 Hearts of Zeal."
Lang["Q2_1139"] = "Find the Tablet of Will and return it to Advisor Belgrum in Ironforge."
Lang["Q2_1142"] = "Find and return Treshala's Pendant to Treshala Fallowbrook in Darnassus."
Lang["Q2_1144"] = "Escort Willix the Importer out of Razorfen Kraul."
Lang["Q2_1149"] = "If you have faith, leap from the planks overlooking Thousand Needles."
Lang["Q2_1150"] = "Bring Grenka's Claw to Dorn Plainstalker in Thousand Needles."
Lang["Q2_1151"] = "Bring Fragments of Rok'Alim to Dorn Plainstalker in Thousand Needles."
Lang["Q2_1152"] = "Find Braug Dimspirit near the entrance to Talondeep Path in Stonetalon Mountains."
Lang["Q2_1154"] = "Find the Legacy of the Aspects and return it to Braug Dimspirit near the entrance to Talondeep Path in Stonetalon Mountains."
Lang["Q2_1159"] = "Find Parqual Fintallas in Undercity."
Lang["Q2_1160"] = "Find The Beginnings of the Undead Threat, and return it to Parqual Fintallas in Undercity."
Lang["Q2_1198"] = "Seek out Argent Guard Thaelrid in Blackfathom Deeps."
Lang["Q2_1199"] = "Bring 10 Twilight Pendants to Argent Guard Manados in Darnassus."
Lang["Q2_12"] = "Gryan Stoutmantle wants you to kill 15 Defias Trappers and 15 Defias Smugglers then return to him on Sentinel Hill."
Lang["Q2_1200"] = "Bring the head of Twilight Lord Kelris to Dawnwatcher Selgorm in Darnassus."
Lang["Q2_1221"] = "Bring 6 Blueleaf Tubers to Mebok Mizzyrix in Ratchet."
Lang["Q2_1275"] = "Gershala Nightwhisper in Auberdine wants 8 Corrupt Brain stems."
Lang["Q2_13"] = "Gryan Stoutmantle wants you to kill 15 Defias Pillagers and 15 Defias Looters and return to him on Sentinel Hill."
Lang["Q2_132"] = "Take Wiley's Note to Gryan Stoutmantle in Westfall."
Lang["Q2_135"] = "Take Wiley's Note to Mathias Shaw in Stormwind."
Lang["Q2_1360"] = "Get Krom Stoutarm's treasure from the North Common Hall and bring it to Ironforge."
Lang["Q2_1394"] = "Speak to Dorn Plainstalker in Thousand Needles."
Lang["Q2_14"] = "Gryan Stoutmantle wants you to kill 15 Defias Highwaymen, 5 Defias Pathstalkers and 5 Defias Knuckledusters then return to him on Sentinel Hill."
Lang["Q2_141"] = "Take Shaw's report to Gryan Stoutmantle in Westfall."
Lang["Q2_142"] = "Track down the Defias Messenger in Westfall and bring his message to Stoutmantle."
Lang["Q2_1445"] = "Collect 20 Fetishes of Hakkar and bring them to Fel'Zerul in Stonard."
Lang["Q2_1446"] = "The Atal'ai Exile in the Hinterlands wants the Head of Jammal'an."
Lang["Q2_1475"] = "Gather 10 Atal'ai Tablets for Brohann Caskbelly in Stormwind."
Lang["Q2_1486"] = "Nalpak wants 20 Deviate Hides."
Lang["Q2_1487"] = "Ebru wants you to kill 7 Deviate Ravagers, Vipers, Shamblers and Dreadfangs."
Lang["Q2_1489"] = "Speak with Hamuul Runetotem on the Elder Rise in Thunder Bluff."
Lang["Q2_1490"] = "Speak with Nara Wildmane in Thunder Bluff."
Lang["Q2_1491"] = "Bring 6 portions of Wailing Essence to Mebok Mizzyrix in Ratchet."
Lang["Q2_155"] = "Escort the Defias Traitor to the secret hideout of the Defias Brotherhood. Once the Defias Traitor shows you where VanCleef and his men are hiding out, return to Gryan Stoutmantle with the information."
Lang["Q2_166"] = "Kill Edwin VanCleef and bring his head to Gryan Stoutmantle."
Lang["Q2_167"] = "Bring Foreman Thistlenettle's Explorers' League Badge to Wilder Thistlenettle in Stormwind."
Lang["Q2_168"] = "Retrieve 4 Miners' Union Cards and return them to Wilder Thistlenettle in Stormwind."
Lang["Q2_17"] = "Bring 12 Magenta Fungus Caps to Ghak Healtouch in Thelsamar."
Lang["Q2_2040"] = "Retrieve the Gnoam Sprecklesprocket from the Deadmines and return it to Shoni the Shilent in Stormwind."
Lang["Q2_2041"] = "Speak with Shoni the Shilent in Stormwind."
Lang["Q2_214"] = "Scout Riell at the Sentinel Hill Tower wants you to bring her 10 Red Silk Bandanas."
Lang["Q2_2200"] = "Search for clues to the shattered necklace in Uldaman."
Lang["Q2_2201"] = "Find the ruby, sapphire and topaz in Uldaman."
Lang["Q2_2202"] = "Bring 12 Magenta Fungus Caps to Jarkal Mossmeld in Kargath."
Lang["Q2_2204"] = "Obtain a power source from the strongest construct in Uldaman and deliver it to Talvash in Ironforge."
Lang["Q2_2240"] = "Read Baelog's Journal, explore the hidden chamber, then report to Prospector Stormpike."
Lang["Q2_2278"] = "Speak with the stone watcher and learn what you can, then activate the Discs of Norgannon."
Lang["Q2_2279"] = "Take the miniature platinum discs to the Explorers' League in Ironforge."
Lang["Q2_2280"] = "Take the miniature platinum discs to someone interested in them in Thunder Bluff."
Lang["Q2_2283"] = "Look for a valuable necklace in the Uldaman dig site and bring it to Dran Droffers in Orgrimmar."
Lang["Q2_2284"] = "Find a clue as to the gems' whereabouts in the depths of Uldaman."
Lang["Q2_2339"] = "Recover all three gems and a power source from Uldaman; bring them to Jarkal in Kargath."
Lang["Q2_2342"] = "Get the Garrett Family Treasure from the South Common Hall and bring it to Undercity."
Lang["Q2_2398"] = "Find Baelog in Uldaman."
Lang["Q2_2418"] = "Bring 8 Dentrium Power Stones and 8 An'Alleum Power Stones to Rigglefuzz in the Badlands."
Lang["Q2_261"] = "Destroy 30 Undead Ravagers, then return to Brother Anton at Nijel's Point."
Lang["Q2_2768"] = "Bring the Divino-matic Rod to Chief Engineer Bilgewhizzle in Gadgetzan."
Lang["Q2_2770"] = "Bring Gahz'rilla's Electrified Scale to Wizzle Brassbolts in the Shimmering Flats."
Lang["Q2_2841"] = "Retrieve the Rig Blueprints and Thermaplugg's Safe Combination from Gnomeregan for Nogg in Orgrimmar."
Lang["Q2_2842"] = "Speak with Scooty in Booty Bay."
Lang["Q2_2843"] = "Wait for Scooty to calibrate the Goblin Transponder."
Lang["Q2_2846"] = "Bring the Tiara of the Deep to Tabetha in Dustwallow Marsh."
Lang["Q2_2865"] = "Bring 5 Uncracked Scarab Shells to Tran'rek in Gadgetzan."
Lang["Q2_2904"] = "Escort Kernobee to the Clockwerk Run exit, then report to Scooty in Booty Bay."
Lang["Q2_2922"] = "Bring Techbot's Memory Core to Tinkmaster Overspark in Ironforge."
Lang["Q2_2923"] = "Speak with Tinkmaster Overspark in Ironforge."
Lang["Q2_2924"] = "Bring 12 Essential Artificials to Klockmort Spannerspan in Ironforge."
Lang["Q2_2926"] = "Collect radioactive fallout with the Empty Leaden Collection Phial and return it to Ozzie Togglevolt."
Lang["Q2_2927"] = "Speak with Ozzie Togglevolt in Kharanos."
Lang["Q2_2928"] = "Bring 24 Robo-mechanical Guts to Shoni in Stormwind."
Lang["Q2_2929"] = "Venture to Gnomeregan and kill Mekgineer Thermaplugg. Return to High Tinker Mekkatorque."
Lang["Q2_2936"] = "Read from the Tablet of Theka to learn the name of the Witherbark spider god, then return to Master Gadrin."
Lang["Q2_2991"] = "Bring Nekrum's Medallion to Thadius Grimshade in the Blasted Lands."
Lang["Q2_3042"] = "Bring 20 Vials of Troll Temper to Trenton Lighthammer in Gadgetzan."
Lang["Q2_3341"] = "Andrew Brownell wants you to kill Amnennar the Coldbringer and return his skull."
Lang["Q2_3369"] = "Bring the Nightmare Shard to Hamuul Runetotem on the Elder Rise."
Lang["Q2_3373"] = "Place the Essence of Eranikus in the Essence Font located in this lair in the Sunken Temple."
Lang["Q2_3380"] = "Find Marvon Rivetseeker in Tanaris."
Lang["Q2_3444"] = "Retrieve the Stone Circle from Marvon Rivetseeker's workshop in Ratchet."
Lang["Q2_3445"] = "Find Marvon Rivetseeker in Tanaris."
Lang["Q2_3446"] = "Find the Altar of Hakkar in the Sunken Temple in Swamp of Sorrows."
Lang["Q2_3447"] = "Travel to the Sunken Temple and discover the secret hidden in the circle of statues."
Lang["Q2_3523"] = "Speak with Belnistrasz and hand the Oathstone back to him if you agree to aid him."
Lang["Q2_3525"] = "Protect Belnistrasz while he performs the ritual to shut down the Quilboar idol."
Lang["Q2_3527"] = "Bring the First and Second Mosh'aru Tablets to Yeh'kinya in Tanaris."
Lang["Q2_3528"] = "Bring the Filled Egg of Hakkar to Yeh'kinya in Tanaris."
Lang["Q2_3636"] = "Archbishop Benedictus wants you to slay Amnennar the Coldbringer in Razorfen Downs."
Lang["Q2_373"] = "Deliver the Letter to the City Architect to Baros Alexston in Stormwind."
Lang["Q2_377"] = "Bring the hand of Dextren Ward to Councilman Millstipe in Darkshire."
Lang["Q2_386"] = "Bring the head of Targorr the Dread to Guard Berton in Lakeshire."
Lang["Q2_387"] = "Warden Thelwater wants you to kill 10 Defias Prisoners, 8 Defias Convicts and 8 Defias Insurgents."
Lang["Q2_388"] = "Nikova Raskol in Stormwind wants 10 Red Wool Bandanas."
Lang["Q2_389"] = "Speak with Warden Thelwater in the Stockade."
Lang["Q2_3906"] = "Travel to the quarry near Blackrock Depths and slay Overmaster Pyron. Return to Thunderheart when the task is complete."
Lang["Q2_3907"] = "Enter Blackrock Depths and track down Lord Incendius. Slay him and bring any information you find to Thunderheart."
Lang["Q2_391"] = "Kill Bazil Thredd and bring his head back to Warden Thelwater."
Lang["Q2_3981"] = "Find Commander Gor'shak in Blackrock Depths."
Lang["Q2_4001"] = "Find out from Kharan Mighthammer what he knows about Princess Moira. Take that information to Thrall in Orgrimmar."
Lang["Q2_4002"] = "Speak with Thrall if you are prepared to take on the mission he has planned."
Lang["Q2_4003"] = "Slay Emperor Dagran Thaurissan and free Princess Moira Bronzebeard."
Lang["Q2_4004"] = "Return to Thrall!"
Lang["Q2_4024"] = "Travel to Blackrock Depths and slay Bael'Gar. Return Encased Fiery Essence to Cyrus Therepentous."
Lang["Q2_4063"] = "Find and slay Golem Lord Argelmach. Return his head to Lotwil. You will also need to collect 10 Intact Elemental Cores from the Ragereaver Golems."
Lang["Q2_4081"] = "Venture to Blackrock Depths and destroy the vile Dwarves! Warlord Goretooth wants you to kill 15 Anvilrage Guardsmen, 10 Anvilrage Wardens and 5 Anvilrage Footmen."
Lang["Q2_4082"] = "Venture to Blackrock Depths and destroy the vile Dwarves! Warlord Goretooth wants you to kill 10 Anvilrage Medics, 10 Anvilrage Soldiers and 10 Anvilrage Officers."
Lang["Q2_4123"] = "Bring the Heart of the Mountain to Maxwort Uberglint in the Burning Steppes."
Lang["Q2_4126"] = "Bring the Lost Thunderbrew Recipe to Ragnar Thunderbrew."
Lang["Q2_4134"] = "Bring the Lost Thunderbrew Recipe to Vivian Lagrave."
Lang["Q2_4136"] = "Bring Ribbly's Head to Yuka Screwspigot in the Burning Steppes."
Lang["Q2_4201"] = "Bring 4 Gromsblood, 10 Giant Silver Veins and Nagmara's Filled Vial to Mistress Nagmara in Blackrock Depths."
Lang["Q2_4262"] = "Slay Overmaster Pyron and return to Jalinda Sprig."
Lang["Q2_4263"] = "Find Lord Incendius in Blackrock Depths and destroy him!"
Lang["Q2_4286"] = "Travel to Blackrock Depths and recover 20 Dark Iron Fanny Packs."
Lang["Q2_4341"] = "Travel to Blackrock Depths and find Kharan Mighthammer."
Lang["Q2_4342"] = "Listen as Kharan Mighthammer tells his story."
Lang["Q2_4361"] = "Return to Ironforge and speak with King Magni Bronzebeard."
Lang["Q2_4362"] = "Return to Blackrock Depths and rescue Princess Moira Bronzebeard from the evil Emperor Dagran Thaurissan."
Lang["Q2_4363"] = "Return to King Magni Bronzebeard in Ironforge and give him the good news."
Lang["Q2_5212"] = "Recover 10 Plagued Flesh Samples from Stratholme and return them to Betina Bigglezink."
Lang["Q2_5213"] = "Travel to Stratholme and search the ziggurats. Find and return new Scourge Data to Betina Bigglezink."
Lang["Q2_5214"] = "Find Ezra Grimm's smoke shop in Stratholme and recover a box of Grimm's Premium Tobacco for Smokey LaRue."
Lang["Q2_5243"] = "Travel to Stratholme, in the north. Search the supply crates that permeate the city and recover 5 Stratholme Holy Water. Return to Leonid Barthalomew the Revered when you have collected enough of the blessed fluid."
Lang["Q2_5251"] = "Travel to Stratholme and find Archivist Galford of the Scarlet Crusade. Destroy him and burn the Scarlet Archive."
Lang["Q2_5262"] = "Take the Head of Balnazzar to Duke Nicholas Zverenhoff at Light's Hope Chapel."
Lang["Q2_5263"] = "Venture to Stratholme and destroy Baron Rivendare. Take his head and return to Duke Nicholas Zverenhoff."
Lang["Q2_5282"] = "Use Egan's Blaster on the ghostly and spectral citizens of Stratholme. When the restless souls break free of their ghostly shells, feed them again - free 15 souls and return to Egan."
Lang["Q2_5341"] = "Venture to Scholomance and recover the Barov family fortune. Four deeds make up this fortune. Return to Alexi Barov when you have completed this task."
Lang["Q2_5342"] = "Travel to Chillwind Camp - Alliance territory - and assassinate Weldon Barov. Take his head and return to Alexi Barov."
Lang["Q2_5343"] = "Venture to Scholomance and recover the Barov family fortune. Four deeds make up this fortune: The Deed to Caer Darrow; The Deed to Brill; The Deed to Tarren Mill; and The Deed to Southshore. Return to Weldon Barov when you have completed this task."
Lang["Q2_5344"] = "Travel to the Bulwark - Alliance territory - and assassinate Alexi Barov. Take his head and return to Weldon Barov."
Lang["Q2_5382"] = "Find Doctor Theolen Krastinov inside Scholomance. Destroy him, then burn the Remains of Eva Sarkhoff and the Remains of Lucien Sarkhoff. Return to Eva Sarkhoff when the task is complete."
Lang["Q2_5384"] = "Return to Scholomance with the Blood of Innocents. Find the porch and place the Blood of Innocents in the brazier. Kirtonos will come to feast upon your soul. Fight valiantly, do not give an inch! Destroy Kirtonos and return to Eva Sarkhoff."
Lang["Q2_5463"] = "Travel to Stratholme and find Menethil's Gift. Place the Keepsake of Remembrance upon the unholy ground."
Lang["Q2_5466"] = "Find Ras Frostwhisper in Scholomance. Use the Soulbound Keepsake on his undead form. Should you succeed, destroy the mortal Ras Frostwhisper and bring his Human Head to Magistrate Marduke."
Lang["Q2_5515"] = "Locate Jandice Barov in Scholomance and destroy her. Recover Krastinov's Bag of Horrors from her corpse. Return to Eva Sarkhoff."
Lang["Q2_5526"] = "Find a Felvine Shard in Dire Maul East, seal it in a Reliquary of Purity, and return to Rabine Saturna."
Lang["Q2_5529"] = "Kill 20 Plagued Hatchlings, then return to Betina Bigglezink at the Light's Hope Chapel."
Lang["Q2_5722"] = "Search Ragefire Chasm for Maur Grimtotem's corpse and search it for any items of interest."
Lang["Q2_5723"] = "Search Orgrimmar for Ragefire Chasm, then kill 8 Ragefire Troggs and 8 Ragefire Shaman before returning to Rahauro in Thunder Bluff."
Lang["Q2_5724"] = "Take the Grimtotem Satchel to Rahauro in Thunder Bluff."
Lang["Q2_5725"] = "Bring the books Spells of Shadow and Incantations from the Nether to Varimathras in Undercity."
Lang["Q2_5726"] = "Bring a Lieutenant's Insignia to Thrall in Orgrimmar."
Lang["Q2_5727"] = "Take the Lieutenant's Insignia to Neeru Fireblade and speak to him. Gauge if he believes you are a member of the Burning Blade and then return to Thrall in Orgrimmar."
Lang["Q2_5728"] = "Kill Bazzalan and Jergosh the Invoker before returning to Thrall in Orgrimmar."
Lang["Q2_5729"] = "Speak to Neeru Fireblade in Orgrimmar."
Lang["Q2_5730"] = "Speak to Thrall in Orgrimmar and tell him what you've learned."
Lang["Q2_5761"] = "Enter Ragefire Chasm and slay Taragaman the Hungerer, then bring his heart back to Neeru Fireblade in Orgrimmar."
Lang["Q2_5848"] = "Travel to Stratholme, in the northern part of the Plaguelands. Find the painting 'Of Love and Family' in the Scarlet Bastion and bring it back to Tirion Fordring."
Lang["Q2_6141"] = "Speak with Brother Anton in Desolace."
Lang["Q2_65"] = "Gryan Stoutmantle wants you to talk to Wiley in Lakeshire."
Lang["Q2_6521"] = "Bring Ambassador Malcin's Head to Varimathras in the Undercity."
Lang["Q2_6522"] = "Take the Small Scroll to Varimathras in the Undercity."
Lang["Q2_6561"] = "Bring the head of Twilight Lord Kelris to Bashana Runetotem in Thunder Bluff."
Lang["Q2_6562"] = "Speak with Je'neu Sancrea at Zoram'gar Outpost in Ashenvale."
Lang["Q2_6563"] = "Bring 20 Sapphires of Aku'Mai to Je'neu Sancrea at Zoram'gar Outpost."
Lang["Q2_6564"] = "Bring the Damp Note to Je'neu Sancrea at Zoram'gar Outpost."
Lang["Q2_6565"] = "Kill Lorgus Jett in Blackfathom Deeps and then return to Je'neu Sancrea."
Lang["Q2_6626"] = "Kill 8 Razorfen Battleguard, 8 Razorfen Thornweavers, and 8 Death's Head Cultists; return to Myriam Moonsinger."
Lang["Q2_6627"] = "Answer Braug Dimspirit's question successfully and then speak to him again. He will remain in Stonetalon Mountains when you are ready."
Lang["Q2_6628"] = "Answer Parqual Fintallas' question successfully and then speak to him again. He will remain in the Undercity until you are ready."
Lang["Q2_6921"] = "Bring the Fathom Core to Je'neu Sancrea at Zoram'gar Outpost."
Lang["Q2_6981"] = "Travel to Ratchet to find someone that can tell you more about the glowing shard."
Lang["Q2_7028"] = "Collect 15 Theradric Crystal Carvings for Willow in Desolace."
Lang["Q2_7029"] = "Heal 8 Vylestem Vines using the Coated Cerulean Vial, then return to Vark Battlescar in Shadowprey Village."
Lang["Q2_7041"] = "Heal 8 Vylestem Vines using the Coated Cerulean Vial, then return to Talendria in Nijel's Point."
Lang["Q2_7044"] = "Recover the Celebrian Rod and Celebrian Diamond, then find a way to speak with Celebras."
Lang["Q2_7046"] = "Assist Celebras the Redeemed while he creates the Scepter of Celebras."
Lang["Q2_7064"] = "Slay Princess Theradras and return to Selendra near Shadowprey Village."
Lang["Q2_7065"] = "Slay Princess Theradras and return to Keeper Marandis at Nijel's Point."
Lang["Q2_7066"] = "Seek out Remulos in Moonglade and give him the Seed of Life."
Lang["Q2_7067"] = "Read the Pariah's Instructions, obtain the Amulet of Union from Maraudon, and return it to the Centaur Pariah."
Lang["Q2_7068"] = "Collect 10 Shadowshard Fragments from Maraudon and return them to Uthel'nay in Orgrimmar."
Lang["Q2_7070"] = "Collect 10 Shadowshard Fragments from Maraudon and return them to Archmage Tervosh in Theramore."
Lang["Q2_709"] = "Bring the Tablet of Ryun'eh to Theldurin the Lost."
Lang["Q2_721"] = "Find Hammertoe Grez in Uldaman."
Lang["Q2_722"] = "Find Hammertoe's Amulet and return it to him in Uldaman."
Lang["Q2_7441"] = "Travel to Dire Maul and locate the Imp Pusillin. Convince him to give you Azj'Tordin's Book of Incantations."
Lang["Q2_7461"] = "You must destroy the guardians surrounding the 5 Force Field Pylons that power Immol'thar's prison. Once the Field pylons have powered down, destroy Immol'thar, then confront Prince Tortheldrin."
Lang["Q2_7462"] = "Return to the Athenaeum and claim your treasure from the Treasure of the Shen'dralar. Speak with Shen'dralar Ancient for more information."
Lang["Q2_7481"] = "Search Dire Maul for Kariel Winthalus and report to Sage Korolusk at Camp Mojache."
Lang["Q2_7482"] = "Search Dire Maul for Kariel Winthalus and report to Scholar Runethorn at Feathermoon."
Lang["Q2_7488"] = "Bring Lethtendris's Web to Latronicus Moonspear at Feathermoon Stronghold."
Lang["Q2_7489"] = "Bring Lethtendris's Web to Talo Thornhoof at Camp Mojache."
Lang["Q2_78916"] = "Bring the Blackfathom Pearl to Dawnwatcher Selgorm in Darnassus."
Lang["Q2_78917"] = "Bring the Blackfathom Pearl to Bashana Runetotem in Thunder Bluff."
Lang["Q2_79987"] = "You may keep the ring, or find the person responsible for the imprint and engravings on the inside of the band."
Lang["Q2_80140"] = "You may keep the ring, or find the person responsible for the imprint and engravings on the inside of the band."
Lang["Q2_80324"] = "Bring Thermaplugg's Engineering Notes to High Tinker Mekkatorque at Tinker Town in Ironforge."
Lang["Q2_80325"] = "Bring Thermaplugg's Engineering Notes to Nogg at the Valley of Honor in Orgrimmar."
Lang["Q2_865"] = "Bring 5 Intact Raptor Horns to Mebok Mizzyrix in Ratchet."
Lang["Q2_870"] = "Search the Forgotten Pools northwest of the Crossroads for a source of power, then return to Tonga Runetotem."
Lang["Q2_877"] = "Test the Dried Seeds at the fissure in the Stagnant Oasis southeast of the Crossroads, then return to Tonga Runetotem."
Lang["Q2_880"] = "Bring 8 Altered Snapjaw Shells to Tonga Runetotem at the Crossroads."
Lang["Q2_886"] = "Speak with Tonga Runetotem at the Crossroads."
Lang["Q2_914"] = "Bring the Gems of Cobrahn, Anacondra, Pythas and Serpentis to Nara Wildmane in Thunder Bluff."
Lang["Q2_92401"] = "Investigate the disappearance of Edward Heartweaver in the Ruins of Lordaeron."
Lang["Q2_92415"] = "Bring the Blood-Stained Letter to Orphan Matron Nightingale in Stormwind City."
Lang["Q2_92421"] = "Collect 25 Intact Limbs within The Ruins of Lordaeron for Morbin Lightbane in the Undercity."
Lang["Q2_92422"] = "Kill Rath'mael in the Ruins of Lordaeron for Deathguard Kristof in Brill."
Lang["Q2_92742"] = "Use the Well Water Sample Kit to collect samples from the wells at the Jansen Stead and the Molsen Farm."
Lang["Q2_92744"] = "Collect 7 Longshore Murloc Gills along the shoreline of Westfall for Alba Fairmoon."
Lang["Q2_92745"] = "Slay 4 Kobold Diggers in the Jangolode Mine and 6 Riverpaw Miners in the Gold Coast Quarry."
Lang["Q2_92747"] = "Collect 8 Suspicious Industrial Supplies from Moonbrook."
Lang["Q2_92748"] = "Travel to the Dwarven District in Stormwind and find an engineer who can help."
Lang["Q2_92749"] = "Obtain 10 Coarse Dynamite, then return to Sprite Jumpsprocket in the Dwarven District of Stormwind."
Lang["Q2_92750"] = "Talk to someone in Stormwind Intelligence about acquiring a remote detonator."
Lang["Q2_92751"] = "Bring the Remote Detonator Kit to Sprite Jumpsprocket in the Dwarven District of Stormwind."
Lang["Q2_92752"] = "Return to Alba Fairmoon in Westfall with the Extra-Destructive Explosives."
Lang["Q2_92753"] = "Find the forge hidden in the Deadmines, and plant the Extra-Destructive Explosives nearby. Then, meet up with Alba Fairmoon at the Deadmines exit."
Lang["Q2_95189"] = "Return the Crest of Lordaeron to Lady Dena Kennedy in Stormwind City."
Lang["Q2_95195"] = "Collect 10 Bloodied Insignias and take them to General Marcus Jonathan in Stormwind City."
Lang["Q2_95204"] = "Bring the Crest of Lordaeron to Oran Snakewrithe in Undercity."
Lang["Q2_95216"] = "Collect the Highly Toxic Strain from Witherfang in Ruins of Lordaeron for Theodore Griffs in Undercity."
Lang["Q2_95250"] = "Collect the Head of the Baron in the Ruins of Lordaeron and bring it back to Captain Truman."
Lang["Q2_959"] = "Crane Operator Bigglefuzz in Ratchet wants you to retrieve the bottle of 99-Year-Old Port from Mad Magglish."
Lang["Q2_962"] = "Apothecary Zamah in Thunder Bluff wants 10 Serpentbloom."
Lang["Q2_96393"] = "Enter the Hall of Thanes beneath Old Ironforge and claim the Head of Durgen Dirgehammer. Deliver it to King Magni Bronzebeard."
Lang["Q2_96394"] = "Kill 15 Enraged Apparitions and 10 Tormented Souls in the Hall of Thanes."
Lang["Q2_96395"] = "Put the spirit of Faldrim Anvilmar to rest in the Hall of Thanes."
Lang["Q2_96403"] = "Collect 8 Dwarven Heirlooms from the Hall of Thanes."
Lang["Q2_971"] = "Bring the Lorgalis Manuscript to Gerrig Bonegrip in the Forlorn Cavern of Ironforge."
Lang["Q2_97288"] = "Deliver the Abominable Head to someone within the Undercity."
Lang["Q2_98423"] = "Interact with the Treaty of Understanding tablet in a Reliquary of Kings vault, then deliver it to King Magni Bronzebeard in Ironforge."
Lang["Quillboar"] = "Quillboar"
Lang["Ragefire Chasm"] = "Ragefire Chasm"
Lang["Razorfen Downs"] = "Razorfen Downs"
Lang["Razorfen Kraul"] = "Razorfen Kraul"
Lang["Ruins of Lordaeron"] = "Ruins of Lordaeron"
Lang["Scarlet Monastery"] = "Scarlet Monastery"
Lang["Scholomance Quests"] = "Scholomance Quests"
Lang["Shadowfang Keep"] = "Shadowfang Keep"
Lang["Stonetalon Mountains"] = "Stonetalon Mountains"
Lang["Stranglethorn Vale"] = "Stranglethorn Vale"
Lang["Stratholme"] = "Stratholme"
Lang["The Barrens"] = "The Barrens"
Lang["The Deadmines"] = "The Deadmines"
Lang["The Hall of Thanes"] = "The Hall of Thanes"
Lang["The Hinterlands"] = "The Hinterlands"
Lang["The Stockade"] = "The Stockade"
Lang["Thousand Needles"] = "Thousand Needles"
Lang["Thunder Bluff"] = "Thunder Bluff"
Lang["Uldaman"] = "Uldaman"
Lang["Wailing Caverns"] = "Wailing Caverns"
Lang["Westfall"] = "Westfall"
Lang["Zul'Farrak"] = "Zul'Farrak"
