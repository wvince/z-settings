--localization file for english/United States
local Lang = LibStub("AceLocale-3.0"):NewLocale("Attune", "enUS", true, true)
if (not Lang) then
	return;
end


-- INTERFACE
Lang["Credits"] = "A huge thank you to my guild |cffffd100<Calm Down>|r for their support and understanding while I test the addon.\n\nIf you see me around, throw me a |cffffd100/hug|r!\n\nCixi Delmont / Gaya Greyhoof"
Lang["Zoom"] = "Zoom"
Lang["Pan_DESC"] = "Click and drag to pan the chain. Shift+mouse wheel pans horizontally."
Lang["Version"] = "Attune v##VERSION## by Cixi Delmont / Gaya Greyhoof"
Lang["Splash"] = "v##VERSION## by Cixi Delmont / Gaya Greyhoof. Type /attune to start."
Lang["Survey"] = "Survey"
Lang["Guild"] = "Guild"
Lang["Party"] = "Party"
Lang["Raid"] = "Raid"
Lang["Run an attunement survey (for people with the addon)"] = "Run an attunement survey (for people with the addon)"
Lang["Toggle between attunements and survey results"] = "Toggle between attunements and survey results" 
Lang["Close"] = "Close" 
Lang["Export"] = "Export"
Lang["My Data"] = "My Data"
Lang["Last Survey"] = "Last Survey"
Lang["Guild Data"] = "Guild Data"
Lang["All Data"] = "All Data"
Lang["Export your Attune data to the website"] = "Export your Attune data to the website"
Lang["Copy the text below, then upload it to"] = "Copy the text below, then upload it to"
Lang["Results"] = "Results"
Lang["Not in a guild"] = "Not in a guild"
Lang["Click on a header to sort the results"] = "Click on header to sort the results" 
Lang["Character"] = "Character" 
Lang["Characters"] = "Characters"
Lang["Last survey results"] = "Last survey results"	
Lang["All FACTION results"] = "All ##FACTION## results"
Lang["Guild members"] = "Guild members" 
Lang["All results"] = "All results" 
Lang["Minimum level"] = "Minimum level" 
Lang["Click to navigate to that attunement"] = "Click to navigate to that attunement"
Lang["Click to show map"] = "Click to show rewards and map. Click again to return."
Lang["Starts at"] = "Starts at"
Lang["Attunes"] = "Attunes"
Lang["Guild members on this step"] = "Guild members on this step"
Lang["Attuned guild members"] = "Attuned guild members"
Lang["Attuned alts"] = "Attuned alts"
Lang["Alts on this step"] = "Alts on this step"
Lang["Settings"] = "Settings"
Lang["Survey Log"] = "Survey Log"
Lang["LeftClick"] = "Left Click"
Lang["OpenAttune"] = "    Open Attune"
Lang["RightClick"] = "Right Click"
Lang["OpenSettings"] = "  Open Settings"
Lang["Addon disabled"] = "Addon disabled"
Lang["StartAutoGuildSurvey"] = "Sending automatic Guild silent survey"
Lang["SendingDataTo"] = "Sending Attune data to |cffffd100##NAME##|r"
Lang["NewVersionAvailable"] = "A |cffffd100new version|r of Attune is available, make sure to update it!"
Lang["CompletedStep"] = "Completed ##TYPE## |cffe4e400##STEP##|r for attunement |cffe4e400##NAME##|r."
Lang["AttuneComplete"] = "Attunement |cffe4e400##NAME##|r complete!"
Lang["AttuneCompleteGuild"] = "##NAME## attunement complete!"
Lang["SendingSurveyWhat"] = "Sending ##WHAT## survey"
Lang["SendingGuildSilentSurvey"] = "Sending Guild silent survey"
Lang["SendingYellSilentSurvey"] = "Sending Yell silent survey"
Lang["ReceivedDataFromName"] = "Received data from |cffffd100##NAME##|r"
Lang["ExportingData"] = "Exporting Attune data for ##COUNT## character(s)"
Lang["ReceivedRequestFrom"] = "Received a survey request from |cffffd100##FROM##|r"
Lang["Help1"] = "This addon allows you to check and export your attunement progress"
Lang["Help2"] = "Run |cfffff700/attune|r to start."
Lang["Help3"] = "To survey the progress of your guild, click |cfffff700survey|r to collect the information."
Lang["Help4"] = "You will then receive progress data from any guild member with the addon."
Lang["Help5"] = "Once you have enough information, click |cfffff700export|r to export the guild progress"
Lang["Help6"] = "Data can be uploaded to |cfffff700https://warcraftratings.com/attune/upload|r"
Lang["Survey_DESC"] = "Run an attunement survey (for people with the addon)"
Lang["Export_DESC"] = "Export your Attune data to the website"
Lang["Toggle_DESC"] = "Toggle between attunements and survey results"
--Lang["PreferredLocale_TEXT"] = "Preferred Language"
--Lang["PreferredLocale_DESC"] = "Select the language you want to see Attune in. Changes to this will require a reload to take effect."
--v220
Lang["My Toons"] = "My Toons"
Lang["No Target"] = "You do not have a target"
Lang["No Response From"] = "No response from ##PLAYER##"
Lang["Sync Request From"] = "New Attune Sync request from:\n\n##PLAYER##"
Lang["Could be slow"] = "Depending on the amount of data you have, this could be a very slow process"
Lang["Accept"] = "Accept"
Lang["Reject"] = "Reject"
Lang["Busy right now"] = "##PLAYER## is busy right now, try again later"
Lang["Sending Sync Request"] = "Sending Sync Request to ##PLAYER##"
Lang["Request accepted, sending data to "] = "Request accepted, sending data to ##PLAYER##"
Lang["Received request from"] = "Received request from ##PLAYER##"
Lang["Request rejected"] = "Request rejected"
Lang["Sync over"] = "Sync over, took ##DURATION##"
Lang["Syncing Attune data with"] = "Syncing Attune data with ##PLAYER##"
Lang["Cannot sync while another sync is in progress"] = "Cannot sync while another sync is in progress"
Lang["Sync with target"] = "Sync with target"
Lang["Show Profiles"] = "Show Profiles"
Lang["Show Progress"] = "Back to Progress"
Lang["Status"] = "Status"
Lang["Role"] = "Role"
Lang["Last Surveyed"] = "Last Surveyed"
Lang['Seconds ago'] = "##DURATION## ago"
Lang["Main"] = "Main"
Lang["Alt"] = "Alt"
Lang["Tank"] = "Tank"
Lang["Healer"] = "Healer"
Lang["Melee DPS"] = "Melee DPS"
Lang["Ranged DPS"] = "Ranged DPS"
Lang["Bank"] = "Bank"
Lang["DelAlts_TEXT"] = "Delete all Alts"
Lang["DelAlts_DESC"] = "Delete all the information about players marked as Alts"
Lang["DelAlts_CONF"] = "Really delete all Alts?"
Lang["DelAlts_DONE"] = "All Alts deleted"
Lang["DelUnspecified_TEXT"] = "Delete Unspecified"
Lang["DelUnspecified_DESC"] = "Delete all the information about players with an unspecified Main/Alt status"
Lang["DelUnspecified_CONF"] = "Really delete all characters with an unspecified Main/Alt status?"
Lang["DelUnspecified_DONE"] = "All unspecified Main/Alt statuses deleted"
--v221
Lang["Open Raid Planner"] = "Open Raid Planner"
Lang["Unspecified"] = "Unspecified"
Lang["Empty"] = "Empty"
Lang["Guildies only"] = "Show Guildies only"
Lang["Show Mains"] = "Show Mains"
Lang["Show Unspecified"] = "Show Unspecified"
Lang["Show Alts"] = "Show Alts"
Lang["Show Unattuned"] = "Show Unattuned"
Lang["Raid spots"] = "##SIZE## Raid spots"
Lang["Group Number"] = "Group ##NUMBER##"
Lang["Move to next group"] = "    Move to the next group"
Lang["Remove from raid"] = "  Remove from raid"
Lang["Select a raid and click on players to add them in"] = "Select a raid and click on players to add them in"
Lang["Planner"] = "Planner"
--v224
Lang["Enter a new name for this raid group"] = "Enter a new name for this raid group"
Lang["Save"] = "Save"
--v226
Lang["Invite"] = "Invite"
Lang["Send raid invites to all listed players?"] = "Send raid invites to all listed players?"
Lang["External link"] = "Link to an online database"
Lang["Quest rewards"] = "Quest rewards"
Lang["No item rewards"] = "This quest has no item rewards."
Lang["Rewards only if available"] = "Item rewards are listed only for quests available to this character."
Lang["Loading rewards"] = "Loading rewards..."
Lang["Show link"] = "Show link"
Lang["Choose one reward"] = "Choose one"
Lang["Experience reward"] = "+%s XP"
--v243
Lang["Ogrila"] = "Ogri'la"
Lang["Ogri'la Quest Hub"] = "Ogri'la Quest Hub"
Lang["Ogrila_Desc"] = "Ogri'la is a Neutral faction in The Burning Crusade with weapons, armor, and consumables as rewards."
Lang["DelInactive_TEXT"] = "Delete Inactive"
Lang["DelInactive_DESC"] = "Delete all the information about players marked as Inactive"
Lang["DelInactive_CONF"] = "Really delete all Inactive?"
Lang["DelInactive_DONE"] = "All Inactive deleted"
Lang["RAIDS"] = "RAIDS"
Lang["KEYS"] = "KEYS"
Lang["MISC"] = "MISC"
Lang["HEROICS"] = "HEROICS"
Lang["DUNGEONS"] = "DUNGEONS"
--v244
Lang["Ally of the Netherwing"] = "Ally of the Netherwing"
Lang["Netherwing_Desc"] = "The Netherwing is a faction of dragons located in Outland."
--v247
Lang["Tirisfal Glades"] = "Tirisfal Glades"
Lang["Scholomance"] = "Scholomance"
--v248
Lang["Target"] = "Target"
Lang["SendingSurveyTo"] = "Sending survey to ##TO##"


-- OPTIONS
Lang["MinimapButton_TEXT"] = "Show the Minimap button"
Lang["MinimapButton_DESC"] = "Display a Minimap button to quickly access the addon interface or options."
Lang["FullMap_TEXT"] = "Use full map for quest giver locations"
Lang["FullMap_DESC"] = "When you click a quest, open the world map at the quest giver instead of showing a map in the side panel. Quest rewards then fill the side panel."
Lang["AutoSurvey_TEXT"] = "Run an automatic guild survey on logon"
Lang["AutoSurvey_DESC"] = "Whenever you log into the game, the addon will perform a guild survey."
Lang["ShowSurveyed_TEXT"] = "Show when I've been surveyed"
Lang["ShowSurveyed_DESC"] =  "Displays a chat message when receiving (and answering) a survey request."
Lang["ShowResponses_TEXT"] = "Show responses when I do a survey"
Lang["ShowResponses_DESC"] = "Displays a chat message for each survey response."
Lang["ShowSetMessages_TEXT"] = "Show step completion messages"
Lang["ShowSetMessages_DESC"] = "Displays a chat message when a step or attunement is completed."
Lang["AnnounceToGuild_TEXT"] = "Announce completion in guild chat"
Lang["AnnounceToGuild_DESC"] = "Send a guild message when an attunement is completed."
Lang["ShowOther_TEXT"] = "Show other chat messages"
Lang["ShowOther_DESC"] = "Displays all other generic chat messages (splash, sending survey, update available, etc)."
Lang["ShowGuildies_TEXT"] = "Show list of guild members at each attunement step.               Max list size"  --this has a gap for the editbox
Lang["ShowGuildies_DESC"] = "Displays in the step tooltip a list of guild members that are currently at that attunement step.\nAdjust the max number of guildies to list on each attunement step if needed."
Lang["ShowAltsInstead_TEXT"] = "Show list of alts instead of guild members"
Lang["ShowAltsInstead_DESC"] = "The step tooltips will display any of your alts that are currently at that attunement step instead of guildies."
Lang["ClearAll_TEXT"] = "Delete ALL results"
Lang["ClearAll_DESC"] = "Delete all the gathered information about other players."
Lang["ClearAll_CONF"] = "Really delete ALL results?"
Lang["ClearAll_DONE"] = "All results deleted."
Lang["DelNonGuildies_TEXT"] = "Delete non guildies"
Lang["DelNonGuildies_DESC"] = "Delete all the gathered information about players from outside your guild."
Lang["DelNonGuildies_CONF"] = "Really delete all non-guildies?"
Lang["DelNonGuildies_DONE"] = "All results outside your guild deleted."
Lang["DelUnder60_TEXT"] = "Delete characters under 60"
Lang["DelUnder60_DESC"] = "Delete all the gathered information about players under level 60."
Lang["DelUnder60_CONF"] = "Really delete all characters under level 60?"
Lang["DelUnder60_DONE"] = "All results under 60 deleted."
Lang["DelUnder70_TEXT"] = "Delete characters under 70"
Lang["DelUnder70_DESC"] = "Delete all the gathered information about players under level 70."
Lang["DelUnder70_CONF"] = "Really delete all characters under level 70?"
Lang["DelUnder70_DONE"] = "All results under 70 deleted."


-- TREEVIEW
Lang["World of Warcraft"] = "World of Warcraft"
Lang["The Burning Crusade"] = "The Burning Crusade"
Lang["Molten Core"] = "Molten Core"
Lang["Onyxia's Lair"] = "Onyxia's Lair"
Lang["Blackwing Lair"] = "Blackwing Lair"
Lang["Naxxramas"] = "Naxxramas"
Lang["Ragefire Chasm"] = "Ragefire Chasm"
Lang["The Deadmines"] = "The Deadmines"
Lang["Scepter of the Shifting Sands"] = "Scepter of the Shifting Sands"
Lang["Shadow Labyrinth"] = "Shadow Labyrinth"
Lang["The Shattered Halls"] = "The Shattered Halls"
Lang["The Arcatraz"] = "The Arcatraz"
Lang["The Black Morass"] = "The Black Morass"
Lang["Thrallmar Heroics"] = "Thrallmar Heroics"
Lang["Honor Hold Heroics"] = "Honor Hold Heroics"
Lang["Cenarion Expedition Heroics"] = "Cenarion Expedition Heroics"
Lang["Lower City Heroics"] = "Lower City Heroics"
Lang["Sha'tar Heroics"] = "Sha'tar Heroics"
Lang["Keepers of Time Heroics"] = "Keepers of Time Heroics"
Lang["Nightbane"] = "Nightbane"
Lang["Karazhan"] = "Karazhan"
Lang["Serpentshrine Cavern"] = "Serpentshrine Cavern"
Lang["The Eye"] = "The Eye"
Lang["Mount Hyjal"] = "Mount Hyjal"
Lang["Black Temple"] = "Black Temple"
Lang["MC_Desc"] = "All members of the raid group need to have this attunement in order to zone into the raid instance, unless they enter via BRD." 
Lang["Ony_Desc"] = "All members of the raid group need to have the Drakefire Amulet in their bag, in order to zone into the raid instance."
Lang["BWL_Desc"] = "All members of the raid group need to have this attunement in order to zone into the raid instance, unless they enter via UBRS."
Lang["All_Desc"] = "All members of the raid group need to have this attunement in order to zone into the raid instance."
Lang["AQ_Desc"] = "Only one person per realm needs to complete this in order to open the gates of Ahn'Qiraj."
Lang["OnlyOne_Desc"] = "Only one person in the group needs to have this key. A rogue with 350 lockpicking can also open the gate."
Lang["DungeonQuest_Desc"] = "Complete the dungeon quests and any chains that lead into this instance."
Lang["Work in progress"] = "Work in progress"
Lang["Heroic_Desc"] = "All members of the group need to have the rep and key in order to zone into the Heroic dungeons."
Lang["NB_Desc"] = "Only one member of the raid group needs to have the Blackened Urn in order to summon Nightbane."
Lang["BT_Desc"] = "All members of the raid group need to have the Medallion of Karabor in order to zone into the raid instance."
Lang["BM_Desc"] = "All members of the group need to complete the quest chain in order to zone into the instance." 
--v250
Lang["Aqual Quintessence"] = "Aqual Quintessence"
Lang["MC2_Desc"] = "Used to summon Majordomo Executus. Every boss in Molten Core except Lucifron and Geddon have runes on the ground that need to be doused for Majordomo to spawn."
Lang["Cozy Sleeping Bag"] = "Cozy Sleeping Bag"
Lang["CSB_Desc"] = "Follow the notes across Kalimdor and the Eastern Kingdoms to earn the Cozy Sleeping Bag." 


-- GENERIC
Lang["Reach level"] = "Reach level"
Lang["Attuned"] = "Complete"
Lang["Not attuned"] = "Not complete"
Lang["AttuneColors"] = "Blue: Attuned\nRed:  Not attuned"
Lang["Minimum Level"] = "This is the minimum level to have access to the quests."
Lang["NPC Not Found"] = "NPC information not found"
Lang["Level"] = "Level"
Lang["Exalted with"] = "Exalted with"
Lang["Revered with"] = "Revered with"
Lang["Honored with"] = "Honored with"
Lang["Friendly with"] = "Friendly with"
Lang["Neutral with"] = "Neutral with"
Lang["Quest"] = "Quest"
Lang["Pick Up"] = "Pick Up"
Lang["Inside"] = "Inside"
Lang["Inside the dungeon"] = "Inside the dungeon"
Lang["Turn In"] = "Turn In"
Lang["Kill"] = "Kill"
Lang["Interact"] = "Interact"
Lang["Item"] = "Item"
Lang["Required level"] = "Required level"
Lang["Requires level"] = "Requires level"
Lang["Attunement or key"] = "Attunement or key"
Lang["Reputation"] = "Reputation"
Lang["in"] = "in"
Lang["Unknown Reputation"] = "Unknown Reputation"
Lang["Current progress"] = "Current progress"
Lang["Completion"] = "Completion"
Lang["Quest information not found"] = "Quest information not found"
Lang["Information not found"] = "Information not found"
Lang["Solo quest"] = "Solo quest"
Lang["Party quest"] = "Party quest (##NB##-man)"
Lang["Raid quest"] = "Raid quest (##NB##-man)"
Lang["HEROIC"] = "H"
Lang["Elite"] = "Elite"
Lang["Boss"] = "Boss"
Lang["Rare Elite"] = "Rare Elite"
Lang["Dragonkin"] = "Dragonkin"
Lang["Troll"] = "Troll"
Lang["Ogre"] = "Ogre"
Lang["Orc"] = "Orc"
Lang["Half-Orc"] = "Half-Orc"
Lang["Dragonkin (in Blood Elf form)"] = "Dragonkin (in Blood Elf form)"
Lang["Human"] = "Human"
Lang["Dwarf"] = "Dwarf"
Lang["Mechanical"] = "Mechanical"
Lang["Arakkoa"] = "Arakkoa"
Lang["Dragonkin (in Humanoid form)"] = "Dragonkin (in Humanoid form)"
Lang["Ethereal"] = "Ethereal"
Lang["Blood Elf"] = "Blood Elf"
Lang["Elemental"] = "Elemental"
Lang["Shiny thingy"] = "Shiny thingy"
Lang["Naga"] = "Naga"
Lang["Demon"] = "Demon"
Lang["Gronn"] = "Gronn"
Lang["Undead (in Dragon form)"] = "Undead (in Dragon form)"
Lang["Tauren"] = "Tauren"
Lang["Qiraji"] = "Qiraji"
Lang["Gnome"] = "Gnome"
Lang["Broken"] = "Broken"
Lang["Draenei"] = "Draenei"
Lang["Undead"] = "Undead"
Lang["Gorilla"] = "Gorilla"
Lang["Shark"] = "Shark"
Lang["Chimaera"] = "Chimaera"
Lang["Wisp"] = "Wisp"
Lang["Night-Elf"] = "Night-Elf"
Lang["Quillboar"] = "Quillboar"


-- REP
Lang["Argent Dawn"] = "Argent Dawn"
Lang["Brood of Nozdormu"] = "Brood of Nozdormu"
Lang["Thrallmar"] = "Thrallmar"
Lang["Honor Hold"] = "Honor Hold"
Lang["Cenarion Expedition"] = "Cenarion Expedition"
Lang["Lower City"] = "Lower City"
Lang["The Sha'tar"] = "The Sha'tar"
Lang["Keepers of Time"] = "Keepers of Time"
Lang["The Violet Eye"] = "The Violet Eye"
Lang["The Aldor"] = "The Aldor"
Lang["The Scryers"] = "The Scryers"


-- LOCATIONS
Lang["Blackrock Mountain"] = "Blackrock Mountain"
Lang["Blackrock Depths"] = "Blackrock Depths"
Lang["Badlands"] = "Badlands"
Lang["Lower Blackrock Spire"] = "Lower Blackrock Spire"
Lang["Upper Blackrock Spire"] = "Upper Blackrock Spire"
Lang["Orgrimmar"] = "Orgrimmar"
Lang["Thunder Bluff"] = "Thunder Bluff"
Lang["Durotar"] = "Durotar"
Lang["Ragefire Chasm"] = "Ragefire Chasm"
Lang["Westfall"] = "Westfall"
Lang["Ironforge"] = "Ironforge"
Lang["The Deadmines"] = "The Deadmines"
Lang["Western Plaguelands"] = "Western Plaguelands"
Lang["Desolace"] = "Desolace"
Lang["Dustwallow Marsh"] = "Dustwallow Marsh"
Lang["Tanaris"] = "Tanaris"
Lang["Winterspring"] = "Winterspring"
Lang["Swamp of Sorrows"] = "Swamp of Sorrows"
Lang["Wetlands"] = "Wetlands"
Lang["Arathi Highlands"] = "Arathi Highlands"
Lang["Mulgore"] = "Mulgore"
Lang["Burning Steppes"] = "Burning Steppes"
Lang["Redridge Mountains"] = "Redridge Mountains"
Lang["Stormwind City"] = "Stormwind City"
Lang["Eastern Plaguelands"] = "Eastern Plaguelands"
Lang["Silithus"] = "Silithus"
Lang["The Temple of Atal'Hakkar"] = "The Temple of Atal'Hakkar"
Lang["Teldrassil"] = "Teldrassil"
Lang["Moonglade"] = "Moonglade"
Lang["Hinterlands"] = "Hinterlands"
Lang["Ashenvale"] = "Ashenvale"
Lang["Feralas"] = "Feralas"
Lang["Duskwood"] = "Duskwood"
Lang["Azshara"] = "Azshara"
Lang["Blasted Lands"] = "Blasted Lands"
Lang["Undercity"] = "Undercity"
Lang["Silverpine Forest"] = "Silverpine Forest"
Lang["Shadowmoon Valley"] = "Shadowmoon Valley"
Lang["Hellfire Peninsula"] = "Hellfire Peninsula"
Lang["Sethekk Halls"] = "Sethekk Halls"
Lang["Caverns Of Time"] = "Caverns Of Time"
Lang["Netherstorm"] = "Netherstorm"
Lang["Shattrath City"] = "Shattrath City"
Lang["The Mechanaar"] = "The Mechanaar"
Lang["The Botanica"] = "The Botanica"
Lang["Zangarmarsh"] = "Zangarmarsh"
Lang["Terokkar Forest"] = "Terokkar Forest"
Lang["Deadwind Pass"] = "Deadwind Pass"
Lang["Alterac Mountains"] = "Alterac Mountains"
Lang["The Steamvault"] = "The Steamvault"
Lang["Slave Pens"] = "Slave Pens"
Lang["Gruul's Lair"] = "Gruul's Lair"
Lang["Magtheridon's Lair"] = "Magtheridon's Lair"
Lang["Zul'Aman"] = "Zul'Aman"
Lang["Sunwell Plateau"] = "Sunwell Plateau"



-- ITEMS
Lang["Drakkisath's Brand"] = "Drakkisath's Brand"
Lang["Crystalline Tear"] = "Crystalline Tear"
Lang["I_18412"] = "Core Fragment"			-- https://www.thegeekcrusade-serveur.com/db/?item=18412
Lang["I_12562"] = "Important Blackrock Documents"			-- https://www.thegeekcrusade-serveur.com/db/?item=12562
Lang["I_16786"] = "Black Dragonspawn Eye"			-- https://www.thegeekcrusade-serveur.com/db/?item=16786
Lang["I_11446"] = "A Crumpled Up Note"			-- https://www.thegeekcrusade-serveur.com/db/?item=11446
Lang["I_11465"] = "Marshal Windsor's Lost Information"			-- https://www.thegeekcrusade-serveur.com/db/?item=11465
Lang["I_11464"] = "Marshal Windsor's Lost Information"			-- https://www.thegeekcrusade-serveur.com/db/?item=11464
Lang["I_18987"] = "Blackhand's Command"			-- https://www.thegeekcrusade-serveur.com/db/?item=18987
Lang["I_20383"] = "Head of the Broodlord Lashlayer"			-- https://www.thegeekcrusade-serveur.com/db/?item=20383
Lang["I_21138"] = "Red Scepter Shard"			-- https://www.thegeekcrusade-serveur.com/db/?item=21138
Lang["I_21146"] = "Fragment of the Nightmare's Corruption"			-- https://www.thegeekcrusade-serveur.com/db/?item=21146
Lang["I_21147"] = "Fragment of the Nightmare's Corruption"			-- https://www.thegeekcrusade-serveur.com/db/?item=21147
Lang["I_21148"] = "Fragment of the Nightmare's Corruption"			-- https://www.thegeekcrusade-serveur.com/db/?item=21148
Lang["I_21149"] = "Fragment of the Nightmare's Corruption"			-- https://www.thegeekcrusade-serveur.com/db/?item=21149
Lang["I_21139"] = "Green Scepter Shard"			-- https://www.thegeekcrusade-serveur.com/db/?item=21139
Lang["I_21103"] = "Draconic for Dummies - Chapter I"			-- https://www.thegeekcrusade-serveur.com/db/?item=21103
Lang["I_21104"] = "Draconic for Dummies - Chapter II"			-- https://www.thegeekcrusade-serveur.com/db/?item=21104
Lang["I_21105"] = "Draconic for Dummies - Chapter III"			-- https://www.thegeekcrusade-serveur.com/db/?item=21105
Lang["I_21106"] = "Draconic for Dummies - Chapter IV"			-- https://www.thegeekcrusade-serveur.com/db/?item=21106
Lang["I_21107"] = "Draconic for Dummies - Chapter V"			-- https://www.thegeekcrusade-serveur.com/db/?item=21107
Lang["I_21108"] = "Draconic for Dummies - Chapter VI"			-- https://www.thegeekcrusade-serveur.com/db/?item=21108
Lang["I_21109"] = "Draconic for Dummies - Chapter VII"			-- https://www.thegeekcrusade-serveur.com/db/?item=21109
Lang["I_21110"] = "Draconic for Dummies - Chapter VIII"			-- https://www.thegeekcrusade-serveur.com/db/?item=21110
Lang["I_21111"] = "Draconic For Dummies: Volume II"			-- https://www.thegeekcrusade-serveur.com/db/?item=21111
Lang["I_21027"] = "Lakmaeran's Carcass"			-- https://www.thegeekcrusade-serveur.com/db/?item=21027
Lang["I_21024"] = "Chimaerok Tenderloin"			-- https://www.thegeekcrusade-serveur.com/db/?item=21024
Lang["I_20951"] = "Narain's Scrying Goggles"			-- https://www.thegeekcrusade-serveur.com/db/?item=20951
Lang["I_21137"] = "Blue Scepter Shard"			-- https://www.thegeekcrusade-serveur.com/db/?item=21137
Lang["I_21175"] = "The Scepter of the Shifting Sands"			-- https://www.thegeekcrusade-serveur.com/db/?item=21175
Lang["I_31241"] = "Primed Key Mold"			-- https://www.thegeekcrusade-serveur.com/db/?item=31241
Lang["I_31239"] = "Primed Key Mold"			-- https://www.thegeekcrusade-serveur.com/db/?item=31239
Lang["I_27991"] = "Shadow Labyrinth Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=27991
Lang["I_31086"] = "Bottom Shard of the Arcatraz Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=31086
Lang["I_31085"] = "Top Shard of the Arcatraz Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=31085
Lang["I_31084"] = "Key to the Arcatraz"			-- https://www.thegeekcrusade-serveur.com/db/?item=31084
Lang["I_30637"] = "Flamewrought Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30637
Lang["I_30622"] = "Flamewrought Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30622
Lang["I_30623"] = "Reservoir Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30623
Lang["I_30633"] = "Auchenai Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30633
Lang["I_30634"] = "Warpforged Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30634
Lang["I_30635"] = "Key of Time"			-- https://www.thegeekcrusade-serveur.com/db/?item=30635
Lang["I_185686"] = "Flamewrought Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30637
Lang["I_185687"] = "Flamewrought Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30622
Lang["I_185690"] = "Reservoir Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30623
Lang["I_185691"] = "Auchenai Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30633
Lang["I_185692"] = "Warpforged Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=30634
Lang["I_185693"] = "Key of Time"			-- https://www.thegeekcrusade-serveur.com/db/?item=30635
Lang["I_24514"] = "First Key Fragment"			-- https://www.thegeekcrusade-serveur.com/db/?item=24514
Lang["I_24487"] = "Second Key Fragment"			-- https://www.thegeekcrusade-serveur.com/db/?item=24487
Lang["I_24488"] = "Third Key Fragment"			-- https://www.thegeekcrusade-serveur.com/db/?item=24488
Lang["I_24490"] = "The Master's Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=24490
Lang["I_23933"] = "Medivh's Journal"			-- https://www.thegeekcrusade-serveur.com/db/?item=23933
Lang["I_25462"] = "Tome of Dusk"			-- https://www.thegeekcrusade-serveur.com/db/?item=25462
Lang["I_25461"] = "Book of Forgotten Names"			-- https://www.thegeekcrusade-serveur.com/db/?item=25461
Lang["I_24140"] = "Blackened Urn"			-- https://www.thegeekcrusade-serveur.com/db/?item=24140
Lang["I_31750"] = "Earthen Signet"			-- https://www.thegeekcrusade-serveur.com/db/?item=31750
Lang["I_31751"] = "Blazing Signet"			-- https://www.thegeekcrusade-serveur.com/db/?item=31751
Lang["I_31716"] = "Unused Axe of the Executioner"			-- https://www.thegeekcrusade-serveur.com/db/?item=31716
Lang["I_31721"] = "Kalithresh's Trident"			-- https://www.thegeekcrusade-serveur.com/db/?item=31721
Lang["I_31722"] = "Murmur's Essence"			-- https://www.thegeekcrusade-serveur.com/db/?item=31722
Lang["I_31704"] = "The Tempest Key"			-- https://www.thegeekcrusade-serveur.com/db/?item=31704
Lang["I_29905"] = "Kael's Vial Remnant"			-- https://www.thegeekcrusade-serveur.com/db/?item=29905
Lang["I_29906"] = "Vashj's Vial Remnant"			-- https://www.thegeekcrusade-serveur.com/db/?item=29906
Lang["I_31307"] = "Heart of Fury"			-- https://www.thegeekcrusade-serveur.com/db/?item=31307
Lang["I_32649"] = "Medaillon of Karabor"			-- https://www.thegeekcrusade-serveur.com/db/?item=32649
--v247
Lang["Shrine of Thaurissan"] = "Shrine of Thaurissan"
Lang["I_14610"] = "Araj's Scarab"
--v250
Lang["I_17332"] = "Hand of Shazzrah"
Lang["I_17329"] = "Hand of Lucifron"
Lang["I_17331"] = "Hand of Gehennas"
Lang["I_17330"] = "Hand of Sulfuron"
Lang["I_17333"] = "Aqual Quintessence"
-- Ragefire Chasm / Deadmines
Lang["I_14544"] = "Lieutenant's Insignia"
Lang["I_14540"] = "Taragaman the Hungerer's Heart"
Lang["I_14395"] = "Spells of Shadow"
Lang["I_14396"] = "Incantations from the Nether"
Lang["I_915"] = "Red Silk Bandana"
Lang["I_3637"] = "Head of VanCleef"
Lang["I_7365"] = "Gnoam Sprecklesprocket"
Lang["I_1894"] = "Miners' Union Card"
Lang["I_1875"] = "Thistlenettle's Badge"
Lang["I_2874"] = "An Unsent Letter"
-- The Stockade
Lang["I_2909"] = "Red Wool Bandana"
Lang["I_2926"] = "Head of Bazil Thredd"
Lang["I_3628"] = "Hand of Dextren Ward"
Lang["I_3630"] = "Head of Targorr"
-- Wailing Caverns
Lang["I_5334"] = "99-Year-Old Port"
Lang["I_5339"] = "Serpentbloom"
Lang["I_6443"] = "Deviate Hide"
Lang["I_6464"] = "Wailing Essence"
-- Shadowfang Keep
Lang["I_5442"] = "Head of Arugal"
Lang["I_6283"] = "The Book of Ur"
-- Blackfathom Deeps
Lang["I_5359"] = "Lorgalis Manuscript"
Lang["I_5952"] = "Corrupted Brain Stem"
Lang["I_5879"] = "Twilight Pendant"
Lang["I_5881"] = "Head of Kelris"
Lang["I_16762"] = "Fathom Core"
Lang["I_16784"] = "Sapphire of Aku'Mai"
Lang["I_16790"] = "Damp Note"
-- Gnomeregan
Lang["I_9278"] = "Essential Artificial"
Lang["I_9309"] = "Robo-mechanical Guts"
Lang["I_9284"] = "Full Leaden Collection Phial"
Lang["I_9277"] = "Techbot's Memory Core"
Lang["I_9153"] = "Rig Blueprints"
Lang["I_9299"] = "Thermaplugg's Safe Combination"
-- Scarlet Monastery
Lang["I_5535"] = "Compendium of the Fallen"
Lang["I_5536"] = "Mythology of the Titans"
Lang["I_5538"] = "Vorrel's Wedding Ring"
Lang["I_5805"] = "Heart of Zeal"
Lang["I_5861"] = "Beginnings of the Undead Threat"
-- Razorfen Kraul
Lang["I_5801"] = "Kraul Guano"
Lang["I_5825"] = "Treshala's Pendant"
Lang["I_5793"] = "Razorflank's Heart"
Lang["I_5792"] = "Razorflank's Medallion"
Lang["I_5876"] = "Blueleaf Tuber"
-- Razorfen Downs / Maraudon / Hall of Thanes
Lang["I_10420"] = "Skull of the Coldbringer"
Lang["I_17009"] = "Ambassador Malcin's Head"
Lang["I_17684"] = "Theradric Crystal Carving"
Lang["I_17756"] = "Shadowshard Fragment"
Lang["I_17758"] = "Amulet of Union"
Lang["I_17702"] = "Celebrian Rod"
Lang["I_17703"] = "Celebrian Diamond"
Lang["I_274286"] = "Durgen Dirgehammer's Head"
Lang["I_274289"] = "Dwarven Heirloom"
Lang["I_281030"] = "Treaty of Understanding"


-- QUESTS - Classic
Lang["Q1_7848"] = "Attunement to the Core"			-- https://www.thegeekcrusade-serveur.com/db/?quest=7848
Lang["Q2_7848"] = "Venture to the Molten Core entry portal in Blackrock Depths and recover a Core Fragment. Return to Lothos Riftwaker in Blackrock Mountain when you have recovered the Core Fragment."
Lang["Q1_4903"] = "Warlord's Command"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4903
Lang["Q2_4903"] = "Slay Highlord Omokk, War Master Voone, and Overlord Wyrmthalak. Recover Important Blackrock Documents. Return to Warlord Goretooth in Kargath when the mission has been accomplished."
Lang["Q1_4941"] = "Eitrigg's Wisdom"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4941
Lang["Q2_4941"] = "Speak with Eitrigg in Orgrimmar. When you have discussed matters with Eitrigg, seek council from Thrall.\n\nYou recall having seen Eitrigg in Thrall's chamber."
Lang["Q1_4974"] = "For The Horde!"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4974
Lang["Q2_4974"] = "Travel to Blackrock Spire and slay Warchief Rend Blackhand. Take his head and return to Orgrimmar."
Lang["Q1_6566"] = "What the Wind Carries"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6566
Lang["Q2_6566"] = "Listen to Thrall."
Lang["Q1_6567"] = "The Champion of the Horde"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6567
Lang["Q2_6567"] = "Seek out Rexxar. The Warchief has instructed you as to his whereabouts. Search the paths of Desolace, between the Stonetalon Mountains and Feralas."
Lang["Q1_6568"] = "The Testament of Rexxar"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6568
Lang["Q2_6568"] = "Deliver Rexxar's Letter to Myranda the Hag in the Western Plaguelands."
Lang["Q1_6569"] = "Oculus Illusions"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6569
Lang["Q2_6569"] = "Travel to Blackrock Spire and collect 20 Black Dragonspawn Eyes. Return to Myranda the Hag when the task is complete."
Lang["Q1_6570"] = "Emberstrife"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6570
Lang["Q2_6570"] = "Travel to the Wyrmbog in Dustwallow Marsh and seek out Emberstrife's Den. Once inside, wear the Amulet of Draconic Subversion and speak with Emberstrife."
Lang["Q1_6584"] = "The Test of Skulls, Chronalis"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6584
Lang["Q2_6584"] = "Guarding the Caverns of Time in the Tanaris Desert is Chronalis, child of Nozdormu. Destroy him and return his skull to Emberstrife."
Lang["Q1_6582"] = "The Test of Skulls, Scryer"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6582
Lang["Q2_6582"] = "You must find the blue dragonflight drake champion, Scryer, and slay him. Pry his skull from his corpse and return it to Emberstrife. \n\nYou know that Scryer can be found in Winterspring."
Lang["Q1_6583"] = "The Test of Skulls, Somnus"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6583
Lang["Q2_6583"] = "Destroy the drake champion of the Green Flight, Somnus. Take his skull and return it to Emberstrife."
Lang["Q1_6585"] = "The Test of Skulls, Axtroz"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6585
Lang["Q2_6585"] = "Travel to Grim Batol and track down Axtroz, drake champion of the Red Flight. Destroy him and take his skull. Return the skull to Emberstrife."
Lang["Q1_6601"] = "Ascension..."			-- https://www.thegeekcrusade-serveur.com/db/?quest=6601
Lang["Q2_6601"] = "It would appear as if the charade is over. You know that the Amulet of Draconic Subversion that Myranda the Hag created for you will not function inside Blackrock Spire. Perhaps you should find Rexxar and explain your predicament. Show him the Dull Drakefire Amulet. Hopefully he will know what to do next."
Lang["Q1_6602"] = "Blood of the Black Dragon Champion"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6602
Lang["Q2_6602"] = "Travel to Blackrock Spire and slay General Drakkisath. Gather his blood and return it to Rexxar."
Lang["Q1_4182"] = "Dragonkin Menace"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4182
Lang["Q2_4182"] = "Slay 15 Black Broodlings, 10 Black Dragonspawn, 4 Black Wyrmkin and 1 Black Drake. Return to Helendis Riverhorn when the task is complete."
Lang["Q1_4183"] = "The True Masters"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4183
Lang["Q2_4183"] = "Travel to Lakeshire and deliver Helendis Riverhorn's Letter to Magistrate Solomon."
Lang["Q1_4184"] = "The True Masters"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4184
Lang["Q2_4184"] = "Travel to Stormwind and deliver Solomon's Plea to Highlord Bolvar Fordragon.\n\nBolvar resides in Stormwind Keep."
Lang["Q1_4185"] = "The True Masters"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4185
Lang["Q2_4185"] = "Speak with Highlord Bolvar Fordragon after speaking with Lady Katrana Prestor."
Lang["Q1_4186"] = "The True Masters"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4186
Lang["Q2_4186"] = "Take Bolvar's Decree to Magistrate Solomon in Lakeshire."
Lang["Q1_4223"] = "The True Masters"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4223
Lang["Q2_4223"] = "Speak with Marshal Maxwell in the Burning Steppes."
Lang["Q1_4224"] = "The True Masters"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4224
Lang["Q2_4224"] = "Speak with Ragged John to learn of Marshal Windsor's fate and return to Marshal Maxwell when you have completed this task.\n\nYou recall Marshal Maxwell telling you to search for him in a cave to the north."
Lang["Q1_4241"] = "Marshal Windsor"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4241
Lang["Q2_4241"] = "Travel to Blackrock Mountain in the northwest and enter Blackrock Depths. Find out what became of Marshal Windsor.\n\nYou recall Ragged John talking about Windsor being dragged off to a prison."
Lang["Q1_4242"] = "Abandoned Hope"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4242
Lang["Q2_4242"] = "Give Marshal Maxwell the bad news."
Lang["Q1_4264"] = "A Crumpled Up Note"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4264
Lang["Q2_4264"] = "You may have just stumbled on to something that Marshal Windsor would be interested in seeing. There may be hope, after all."
Lang["Q1_4282"] = "A shred of Hope"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4282
Lang["Q2_4282"] = "Return Marshal Windsor's Lost Information.\n\nMarshal Windsor believes that the information is being held by Golem Lord Argelmach and General Angerforge."
Lang["Q1_4322"] = "Jail Break"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4322
Lang["Q2_4322"] = "Help Marshal Windsor get his gear back and free his friends. Return to Marshal Maxwell if you succeed."
Lang["Q1_6402"] = "Stormwind Rendezvous"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6402
Lang["Q2_6402"] = "Travel to Stormwind City and venture to the city gates. Speak with Squire Rowe so that he may let Marshal Windsor know that you have arrived."
Lang["Q1_6403"] = "The Great Masquerade"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6403
Lang["Q2_6403"] = "Follow Reginald Windsor through Stormwind. Protect him from harm!"
Lang["Q1_6501"] = "The Dragon's Eye"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6501
Lang["Q2_6501"] = "You must search the world for a being capable of restoring the power to the Fragment of the Dragon's Eye. The only information you possess about such a being is that they exist."
Lang["Q1_6502"] = "Drakefire Amulet"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6502
Lang["Q2_6502"] = "You must retrieve the Blood of the Black Dragon Champion from General Drakkisath. Drakkisath can be found in his throne room behind the Halls of Ascension in Blackrock Spire."
Lang["Q1_7761"] = "Blackhand's Command"			-- https://www.thegeekcrusade-serveur.com/db/?quest=7761
Lang["Q2_7761"] = "That is one stupid orc. It would appear as if you need to find this brand and gain the Mark of Drakkisath in order to access the Orb of Command.\n\nThe letter indicates that General Drakkisath guards the brand. Perhaps you should investigate."
Lang["Q1_9121"] = "The Dread Citadel - Naxxramas"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9121
Lang["Q2_9121"] = "Archmage Angela Dosantos at Light's Hope Chapel in the Eastern Plaguelands wants 5 Arcane Crystals, 2 Nexus Crystals, 1 Righteous Orb and 60 gold pieces. You must also be Honored with the Argent Dawn."
Lang["Q1_9122"] = "The Dread Citadel - Naxxramas"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9122
Lang["Q2_9122"] = "Archmage Angela Dosantos at Light's Hope Chapel in the Eastern Plaguelands wants 2 Arcane Crystals, 1 Nexus Crystal and 30 gold pieces. You must also be Revered with the Argent Dawn."
Lang["Q1_9123"] = "The Dread Citadel - Naxxramas"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9123
Lang["Q2_9123"] = "Archmage Angela Dosantos at Light's Hope Chapel in the Eastern Plaguelands will grant you Arcane Cloaking at no cost. You must be Exalted with the Argent Dawn."
Lang["Q1_8286"] = "What Tomorrow Brings"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8286
Lang["Q2_8286"] = "Venture to the Caverns of Time in Tanaris and find Anachronos, Brood of Nozdormu."
Lang["Q1_8288"] = "Only One May Rise"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8288
Lang["Q2_8288"] = "Return the Head of the Broodlord Lashlayer to Baristolth of the Shifting Sands at Cenarion Hold in Silithus."
Lang["Q1_8301"] = "The Path of the Righteous"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8301
Lang["Q2_8301"] = "Collect 200 Silithid Carapace Fragments and return to Baristolth."
Lang["Q1_8303"] = "Anachronos"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8303
Lang["Q2_8303"] = "Seek out Anachronos at the Caverns of Time in Tanaris."
Lang["Q1_8305"] = "Long Forgotten Memories"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8305
Lang["Q2_8305"] = "Locate the Crystalline Tear in Silithus and gaze into its depths."
Lang["Q1_8519"] = "A Pawn on the Eternal Board"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8519
Lang["Q2_8519"] = "Learn all that you can of the past, then speak with Anachronos at the Caverns of Time in Tanaris."
Lang["Q1_8555"] = "The Charge of the Dragonflights"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8555
Lang["Q2_8555"] = "Eranikus, Vaelastrasz, and Azuregos... No doubt you know of these dragons, mortal. It is no coincidence, then, that they have played such influential roles as watchers of our world.\n\nUnfortunately (and my own naivety is partially to blame) whether by agents of the Old Gods or betrayal by those that would call them friend, each guardian has fallen to tragedy. The extent of which has fueled my own distrust towards your kind.\n\nSeek them out... And prepare yourself for the worst."
Lang["Q1_8730"] = "Nefarius's Corruption"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8730
Lang["Q2_8730"] = "Slay Nefarian and recover the Red Scepter Shard. Return the Red Scepter Shard to Anachronos at the Caverns of Time in Tanaris. You have 5 hours to complete this task."
Lang["Q1_8733"] = "Eranikus, Tyrant of the Dream"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8733
Lang["Q2_8733"] = "Travel to the continent of Teldrassil and find Malfurion's agent somewhere outside the walls of Darnassus."
Lang["Q1_8734"] = "Tyrande and Remulos"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8734
Lang["Q2_8734"] = "Travel to the Moonglade and speak to Keeper Remulos."
Lang["Q1_8735"] = "The Nightmare's Corruption"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8735
Lang["Q2_8735"] = "Travel to the four Emerald Dream portals in Azeroth and collect a Fragment of the Nightmare's Corruption from each. Return to Keeper Remulos in the Moonglade when you have completed this task."
Lang["Q1_8736"] = "The Nightmare Manifests"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8736
Lang["Q2_8736"] = "Defend Nighthaven from Eranikus. Do not let Keeper Remulos perish. Do not slay Eranikus. Defend yourself. Await Tyrande."
Lang["Q1_8741"] = "The Champion Returns"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8741
Lang["Q2_8741"] = "Take the Green Scepter Shard to Anachronos at the Caverns of Time in Tanaris."
Lang["Q1_8575"] = "Azuregos's Magical Ledger"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8575
Lang["Q2_8575"] = "Deliver Azuregos's Magical Ledger to Narain Soothfancy in Tanaris."
Lang["Q1_8576"] = "Translating the Ledger"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8576
Lang["Q2_8576"] = "First things first! We need to figure out what Azuregos wrote in this ledger.\n\nYou say that he's told you to make an arcanite buoy and that this is the schematic? Strange that he would write this in Draconic. That old goat knows I can't read this nonsense.\n\nIf this is going to work, I'm going to need my scrying goggles, a five hundred pound chicken and volume II of 'Draconic for Dummies.' Not necessarily in that order."
Lang["Q1_8597"] = "Draconic for Dummies"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8597
Lang["Q2_8597"] = "Find Narain Soothfancy's book, buried on an island in the South Seas."
Lang["Q1_8599"] = "Love Song for Narain"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8599
Lang["Q2_8599"] = "Take Meridith's Love Letter to Narain Soothfancy in Tanaris."
Lang["Q1_8598"] = "rAnS0m"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8598
Lang["Q2_8598"] = "Return the Ransom Letter to Narain Soothfancy in Tanaris."
Lang["Q1_8606"] = "Decoy!"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8606
Lang["Q2_8606"] = "Narain Soothfancy in Tanaris wants you to travel to Winterspring and place the Bag of Gold at the drop off point documented by the booknappers."
Lang["Q1_8620"] = "The Only Prescription"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8620
Lang["Q2_8620"] = "Recover the 8 lost chapters of Draconic for Dummies and combine them with the Magical Book Binding and return the completed book of Draconic for Dummies: Volume II to Narain Soothfancy in Tanaris."
Lang["Q1_8584"] = "Never Ask Me About My Business"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8584
Lang["Q2_8584"] = "Narain Soothfancy in Tanaris wants you to speak with Dirge Quickcleave in Gadgetzan."
Lang["Q1_8585"] = "The Isle of Dread!"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8585
Lang["Q2_8585"] = "Recover Lakmaeran's Carcass and 20 Chimaerok Tenderloins for Dirge Quickcleave in Tanaris."
Lang["Q1_8586"] = "Dirge's Kickin' Chimaerok Chops"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8586
Lang["Q2_8586"] = "Dirge Quickcleave in Gadgetzan wants you to bring him 20 Goblin Rocket Fuel and 20 Deeprock Salt."
Lang["Q1_8587"] = "Return to Narain"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8587
Lang["Q2_8587"] = "Deliver the 500 Pound Chicken to Narain Soothfancy in Tanaris."
Lang["Q1_8577"] = "Stewvul, Ex-B.F.F."			-- https://www.thegeekcrusade-serveur.com/db/?quest=8577
Lang["Q2_8577"] = "Narain Soothfancy wants you to find his ex-best friend forever (BFF), Stewvul, and take back the scrying goggles that Stewvul stole from him."
Lang["Q1_8578"] = "Scrying Goggles? No Problem!"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8578
Lang["Q2_8578"] = "Find Narain's Scrying Goggles and return them to Narain Soothfancy in Tanaris."
Lang["Q1_8728"] = "The Good News and The Bad News"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8728
Lang["Q2_8728"] = "Narain Soothfancy in Tanaris wants you to bring him 20 Arcanite Bars, 10 Elementium Ore, 10 Azerothian Diamonds, and 10 Blue Sapphires."
Lang["Q1_8729"] = "The Wrath of Neptulon"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8729
Lang["Q2_8729"] = "Use the Arcanite Buoy at the Swirling Maelstrom at the Bay of Storms in Azshara."
Lang["Q1_8742"] = "The Might of Kalimdor"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8742
Lang["Q2_8742"] = "A thousand years has passed and just as it was fated, one stands before me. One who shall lead their people to a new age.\n\nThe Old God trembles. Oh yes, it fears your faith. Shatter the prophecy of C'Thun.\n\nIt knows you come, champion - and with you comes the might of Kalimdor. You have only to let me know when you are prepared and I shall grant you the Scepter of the Shifting Sands."
Lang["Q1_8745"] = "Treasure of the Timeless One"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8745
Lang["Q2_8745"] = "Greetings, champion. I am Jonathan, keeper of the sacred gong and eternal watcher of the Bronze Flight.\n\nI have been empowered by the Timeless One himself to grant you an item of your choosing from his timeless treasure trove. May it aid you in your battles against C'Thun."


-- QUESTS - TBC
Lang["Q1_10755"] = "Entry Into the Citadel"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10755
Lang["Q2_10755"] = "Bring the Primed Key Mold to Nazgrel at Thrallmar in Hellfire Peninsula."
Lang["Q1_10756"] = "Grand Master Rohok"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10756
Lang["Q2_10756"] = "Bring the Primed Key Mold to Rohok in Thrallmar."
Lang["Q1_10757"] = "Rohok's Request"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10757
Lang["Q2_10757"] = "Bring 4 Fel Iron Bars, 2 Arcane Dust and 4 Motes of Fire to Rohok at Thrallmar in Hellfire Peninsula."
Lang["Q1_10758"] = "Hotter than Hell"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10758
Lang["Q2_10758"] = "Destroy a Fel Reaver in Hellfire Peninsula and plunge the Unfired Key Mold into its remains. Bring the Charred Key Mold to Rohok in Thrallmar."
Lang["Q1_10754"] = "Entry Into the Citadel"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10754
Lang["Q2_10754"] = "Bring the Primed Key Mold to Force Commander Danath at Honor Hold in Hellfire Peninsula."
Lang["Q1_10762"] = "Grand Master Dumphry"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10762
Lang["Q2_10762"] = "Bring the Primed Key Mold to Dumphry in Honor Hold."
Lang["Q1_10763"] = "Dumphry's Request"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10763
Lang["Q2_10763"] = "Bring 4 Fel Iron Bars, 2 Arcane Dust and 4 Motes of Fire to Dumphry at Honor Hold in Hellfire Peninsula."
Lang["Q1_10764"] = "Hotter than Hell"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10764
Lang["Q2_10764"] = "Destroy a Fel Reaver in Hellfire Peninsula and plunge the Unfired Key Mold into its remains. Bring the Charred Key Mold to Dumphry in Honor Hold."
Lang["Q1_10279"] = "To The Master's Lair"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10279
Lang["Q2_10279"] = "Speak to Andormu at the Caverns of Time."
Lang["Q1_10277"] = "The Caverns of Time"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10277
Lang["Q2_10277"] = "Andormu at the Caverns of Time has asked that you follow the Custodian of Time around the cavern."
Lang["Q1_10282"] = "Old Hillsbrad"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10282
Lang["Q2_10282"] = "Andormu at the Caverns of Time has asked that you venture to Old Hillsbrad and speak with Erozion."
Lang["Q1_10283"] = "Taretha's Diversion"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10283
Lang["Q2_10283"] = "Travel to Durnholde Keep and set 5 incendiary charges at the barrels located inside each of the internment lodges using the Pack of Incendiary Bombs given to you by Erozion."
Lang["Q1_10284"] = "Escape from Durnholde"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10284
Lang["Q2_10284"] = "When you are ready to proceed, let Thrall know. Follow Thrall out of Durnholde Keep and help him free Taretha and fulfill his destiny."
Lang["Q1_10285"] = "Return to Andormu"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10285
Lang["Q2_10285"] = "Return to the child Andormu at the Caverns of Time in the Tanaris desert."
Lang["Q1_10265"] = "Consortium Crystal Collection"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10265
Lang["Q2_10265"] = "Obtain an Arklon Crystal Artifact and return it to Nether-Stalker Khay'ji at Area 52 in the Netherstorm."
Lang["Q1_10262"] = "A Heap of Ethereals"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10262
Lang["Q2_10262"] = "Collect 10 Zaxxis Insignias and return them to Nether-Stalker Khay'ji at Area 52 in the Netherstorm."
Lang["Q1_10205"] = "Warp-Raider Nesaad"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10205
Lang["Q2_10205"] = "Kill Warp-Raider Nesaad and then return to Nether-Stalker Khay'ji at Area 52 in the Netherstorm."
Lang["Q1_10266"] = "Request for Assistance"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10266
Lang["Q2_10266"] = "Seek out and offer your services to Gahruj. He is located at the Midrealm Post inside Eco-Dome Midrealm in the Netherstorm."
Lang["Q1_10267"] = "Rightful Repossession"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10267
Lang["Q2_10267"] = "Collect 10 Boxes of Surveying Equipment and return them to Gahruj at the Midrealm Post inside Eco-Dome Midrealm in the Netherstorm."
Lang["Q1_10268"] = "An Audience with the Prince"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10268
Lang["Q2_10268"] = "Deliver the Surveying Equipment to the Image of Nexus-Prince Haramad at the Stormspire in the Netherstorm."
Lang["Q1_10269"] = "Triangulation Point One"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10269
Lang["Q2_10269"] = "Use the Triangulation Device to point your way toward the first triangulation point. Once you have found it, report the location to Dealer Hazzin at the Protectorate Watchpost on the Manaforge Ultris island in the Netherstorm."
Lang["Q1_10275"] = "Triangulation Point Two"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10275
Lang["Q2_10275"] = "Use the Triangulation Device to point your way toward the second triangulation point. Once you have found it, report the location to Wind Trader Tuluman at Tuluman's Landing, just on the other side of the bridge from the Manaforge Ara island in the Netherstorm."
Lang["Q1_10276"] = "Full Triangle"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10276
Lang["Q2_10276"] = "Recover the Ata'mal Crystal and deliver it to the Image of Nexus-Prince Haramad at the Stormspire in the Netherstorm."
Lang["Q1_10280"] = "Special Delivery to Shattrath City"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10280
Lang["Q2_10280"] = "Deliver the Ata'mal Crystal to A'dal on the Terrace of Light in Shattrath City."
Lang["Q1_10704"] = "How to Break Into the Arcatraz"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10704
Lang["Q2_10704"] = "A'dal has tasked you with the recovery of the Top and Bottom Shards of the Arcatraz Key. Return them to him, and he will fashion them into the Key to the Arcatraz for you."
Lang["Q1_9824"] = "Arcane Disturbances"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9824
Lang["Q2_9824"] = "Use the Violet Scrying Crystal near underground sources of water in the Master's Cellar and return to Archmage Alturus outside of Karazhan."
Lang["Q1_9825"] = "Restless Activity"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9825
Lang["Q2_9825"] = "Bring 10 Ghostly Essences to Archmage Alturus outside of Karazhan."
Lang["Q1_9826"] = "Contact from Dalaran"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9826
Lang["Q2_9826"] = "Bring Alturus's Report to Archmage Cedric in the outskirts of Dalaran."
Lang["Q1_9829"] = "Khadgar"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9829
Lang["Q2_9829"] = "Deliver Alturus's Report to Khadgar in Shattrath City in Terokkar Forest."
Lang["Q1_9831"] = "Entry Into Karazhan"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9831
Lang["Q2_9831"] = "Khadgar wants you to enter the Shadow Labyrinth at Auchindoun and retrieve the First Key Fragment from an Arcane Container hidden there."
Lang["Q1_9832"] = "The Second and Third Fragments"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9832
Lang["Q2_9832"] = "Obtain the Second Key Fragment from an Arcane Container inside Coilfang Reservoir and the Third Key Fragment from an Arcane Container inside Tempest Keep. Return to Khadgar in Shattrath City after you've completed this task."
Lang["Q1_9836"] = "The Master's Touch"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9836
Lang["Q2_9836"] = "Go into the Caverns of Time and convince Medivh to enable your Restored Apprentice's Key."
Lang["Q1_9837"] = "Return to Khadgar"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9837
Lang["Q2_9837"] = "Return to Khadgar in Shattrath City and show him the Master's Key."
Lang["Q1_9838"] = "The Violet Eye"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9838
Lang["Q2_9838"] = "Speak to Archmage Alturus outside Karazhan."
Lang["Q1_9630"] = "Medivh's Journal"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9630
Lang["Q2_9630"] = "Archmage Alturus at Deadwind Pass wants you go into Karazhan and speak to Wravien."
Lang["Q1_9638"] = "In Good Hands"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9638
Lang["Q2_9638"] = "Speak to Gradav at the Guardian's Library in Karazhan."
Lang["Q1_9639"] = "Kamsis"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9639
Lang["Q2_9639"] = "Speak to Kamsis at the Guardian's Library in Karazhan."
Lang["Q1_9640"] = "The Shade of Aran"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9640
Lang["Q2_9640"] = "Obtain Medivh's Journal and return to Kamsis at the Guardian's Library in Karazhan."
Lang["Q1_9645"] = "The Master's Terrace"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9645
Lang["Q2_9645"] = "Go to the Master's Terrace in Karazhan and read Medivh's Journal. Return to Archmage Alturus with Medivh's Journal after completing this task."
Lang["Q1_9680"] = "Digging Up the Past"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9680
Lang["Q2_9680"] = "Archmage Alturus wants you to go to the mountains south of Karazhan in Deadwind Pass and retrieve a Charred Bone Fragment.\n\nDon't be like Bel, get out of raid first."
Lang["Q1_9631"] = "A Colleague's Aid"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9631
Lang["Q2_9631"] = "Take the Charred Bone Fragment to Kalynna Lathred at Area 52 in Netherstorm."
Lang["Q1_9637"] = "Kalynna's Request"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9637
Lang["Q2_9637"] = "Kalynna Lathred wants you to retrieve the Tome of Dusk from Grand Warlock Nethekurse in the Shattered Halls of Hellfire Citadel and the Book of Forgotten Names from Darkweaver Syth in the Sethekk Halls in Auchindoun."
Lang["Q1_9644"] = "Nightbane"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9644
Lang["Q2_9644"] = "Go to the Master's Terrace in Karazhan and use Kalynna's Urn to summon Nightbane. Retrieve the Faint Arcane Essence from Nightbane's corpse and bring it to Archmage Alturus."
Lang["Q1_10901"] = "The Cudgel of Kar'desh"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10901
Lang["Q2_10901"] = "Skar'this the Heretic in the heroic Slave Pens of Coilfang Reservoir wants you to bring him the Earthen Signet and the Blazing Signet."
Lang["Q1_10900"] = "The Mark of Vashj"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10900
Lang["Q2_10900"] = ""
Lang["Q1_10681"] = "The Hand of Gul'dan"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10681
Lang["Q2_10681"] = "Speak with Earthmender Torlok at the Altar of Damnation in Shadowmoon Valley."
Lang["Q1_10458"] = "Enraged Spirits of Fire and Earth"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10458
Lang["Q2_10458"] = "Earthmender Torlok at the Altar of Damnation in Shadowmoon Valley wants you to use the Totem of Spirits to capture 8 Earthen Souls and 8 Fiery Souls."
Lang["Q1_10480"] = "Enraged Spirits of Water"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10480
Lang["Q2_10480"] = "Earthmender Torlok at the Altar of Damnation in Shadowmoon Valley wants you to use the Totem of Spirits to capture 5 Watery Souls."
Lang["Q1_10481"] = "Enraged Spirits of Air"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10481
Lang["Q2_10481"] = "Earthmender Torlok at the Altar of Damnation in Shadowmoon Valley wants you to use the Totem of Spirits to capture 10 Airy Souls."
Lang["Q1_10513"] = "Oronok Torn-heart"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10513
Lang["Q2_10513"] = "Seek out Oronok Torn-heart on the Shattered Shelf - north of Coilskar Cistern."
Lang["Q1_10514"] = "I Was A Lot Of Things..."			-- https://www.thegeekcrusade-serveur.com/db/?quest=10514
Lang["Q2_10514"] = "Oronok Torn-heart at Oronok's Farm in Shadowmoon Valley wants you to recover 10 Shadowmoon Tubers from the Shattered Plains."
Lang["Q1_10515"] = "A Lesson Learned"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10515
Lang["Q2_10515"] = "Oronok Torn-heart at Oronok's Farm in Shadowmoon Valley wants you to destroy 10 Ravenous Flayer Eggs on the Shattered Plains."
Lang["Q1_10519"] = "The Cipher of Damnation - Truth and History"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10519
Lang["Q2_10519"] = "Oronok Torn-heart at Oronok's Farm in Shadowmoon Valley wants you to listen to his story. Speak to Oronok to begin hearing his story."
Lang["Q1_10521"] = "Grom'tor, Son of Oronok"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10521
Lang["Q2_10521"] = "Find Grom'tor, Son of Oronok at Coilskar Point in Shadowmoon Valley."
Lang["Q1_10527"] = "Ar'tor, Son of Oronok"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10527
Lang["Q2_10527"] = "Find Ar'tor, Son of Oronok at Illidari Point in Shadowmoon Valley."
Lang["Q1_10546"] = "Borak, Son of Oronok"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10546
Lang["Q2_10546"] = "Find Borak, Son of Oronok near Eclipse Point in Shadowmoon Valley."
Lang["Q1_10522"] = "The Cipher of Damnation - Grom'tor's Charge"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10522
Lang["Q2_10522"] = "Grom'tor, Son of Oronok at Coilskar Point in Shadowmoon Valley wants you to recover the First Fragment of the Cipher of Damnation."
Lang["Q1_10528"] = "Demonic Crystal Prisons"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10528
Lang["Q2_10528"] = "Seek out and slay Painmistress Gabrissa at Illidari Point and return to the corpse of Ar'tor, Son of Oronok with the Crystalline Key."
Lang["Q1_10547"] = "Of Thistleheads and Eggs..."			-- https://www.thegeekcrusade-serveur.com/db/?quest=10547
Lang["Q2_10547"] = "Borak, Son of Oronok at the bridge north of Eclipse Point wants you to find a Rotten Arakkoa Egg and deliver it to Tobias the Filth Gorger in Shattrath City, located in northwest Terokkar Forest."
Lang["Q1_10523"] = "The Cipher of Damnation - The First Fragment Recovered"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10523
Lang["Q2_10523"] = "Take Grom'tor's Lockbox to Oronok Torn-heart at Oronok's Farm in Shadowmoon Valley."
Lang["Q1_10537"] = "Lohn'goron, Bow of the Torn-heart"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10537
Lang["Q2_10537"] = "The Spirit of Ar'tor at Illidari Point in Shadowmoon Valley wants you to recover Lohn'goron, Bow of the Torn-heart from the demons of the area."
Lang["Q1_10550"] = "The Bundle of Bloodthistle"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10550
Lang["Q2_10550"] = "Take the Bundle of Bloodthistle back to Borak, Son of Oronok at the bridge near Eclipse Point in Shadowmoon Valley."
Lang["Q1_10540"] = "The Cipher of Damnation - Ar'tor's Charge"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10540
Lang["Q2_10540"] = "The Spirit of Ar'tor at Illidari Point in Shadowmoon Valley wants you to recover the Second Fragment of the Cipher of Damnation from Veneratus the Many.\n\nCreatures attacked or damaged by the Spirit Hunter will not yield loot or experience."
Lang["Q1_10570"] = "To Catch A Thistlehead"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10570
Lang["Q2_10570"] = "Borak, Son of Oronok at the bridge near Eclipse Point in Shadowmoon Valley wants you to recover the Stormrage Missive."
Lang["Q1_10576"] = "The Shadowmoon Shuffle"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10576
Lang["Q2_10576"] = "Borak, Son of Oronok at the bridge near Eclipse Point in Shadowmoon Valley wants you to recover 6 pieces of Eclipsion Armor."
Lang["Q1_10577"] = "What Illidan Wants, Illidan Gets..."			-- https://www.thegeekcrusade-serveur.com/db/?quest=10577
Lang["Q2_10577"] = "Borak, Son of Oronok at the bridge near Eclipse Point in Shadowmoon Valley wants you to Deliver Illidan's Message to Grand Commander Ruusk at Eclipse Point."
Lang["Q1_10578"] = "The Cipher of Damnation - Borak's Charge"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10578
Lang["Q2_10578"] = "Borak, Son of Oronok at the bridge near Eclipse Point in Shadowmoon Valley wants you to recover the Third Part of the Cipher of Damnation from Ruul the Darkener."
Lang["Q1_10541"] = "The Cipher of Damnation - The Second Fragment Recovered"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10541
Lang["Q2_10541"] = "Take Ar'tor's Lockbox to Oronok Torn-heart at Oronok's Farm in Shadowmoon Valley."
Lang["Q1_10579"] = "The Cipher of Damnation - The Third Fragment Recovered"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10579
Lang["Q2_10579"] = "Take Borak's Lockbox to Oronok Torn-heart at Oronok's Farm in Shadowmoon Valley."
Lang["Q1_10588"] = "The Cipher of Damnation"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10588
Lang["Q2_10588"] = "Use the Cipher of Damnation at the Altar of Damnation to summon Cyrukh the Firelord.\n\nDestroy Cyrukh the Firelord and then speak with Earthmender Torlok, also found at the Altar of Damnation."
Lang["Q1_10883"] = "The Tempest Key"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10883
Lang["Q2_10883"] = "Speak with A'dal in Shattrath City."
Lang["Q1_10884"] = "Trial of the Naaru: Mercy"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10884
Lang["Q2_10884"] = "A'dal in Shattrath City wants you to recover the Unused Axe of the Executioner from the Shattered Halls of Hellfire Citadel.\n\nThis quest must be completed in Heroic dungeon difficulty."
Lang["Q1_10885"] = "Trial of the Naaru: Strength"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10885
Lang["Q2_10885"] = "A'dal in Shattrath City wants you to recover Kalithresh's Trident and Murmur's Essence.\n\nThis quest must be completed in Heroic dungeon difficulty."
Lang["Q1_10886"] = "Trial of the Naaru: Tenacity"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10886
Lang["Q2_10886"] = "A'dal in Shattrath City wants you to rescue Millhouse Manastorm from the Arcatraz of Tempest Keep.\n\nThis quest must be completed in Heroic dungeon difficulty."
Lang["Q1_10888"] = "Trial of the Naaru: Magtheridon"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10888
Lang["Q2_10888"] = "A'dal in Shattrath City wants you to slay Magtheridon."
Lang["Q1_10680"] = "The Hand of Gul'dan"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10680
Lang["Q2_10680"] = "Speak with Earthmender Torlok at the Altar of Damnation in Shadowmoon Valley."
Lang["Q1_10445"] = "The Vials of Eternity"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10445
Lang["Q2_10445"] = "Soridormi at Caverns of Time wants you to retrieve Vashj's Vial Remnant from Lady Vashj at Coilfang Reservoir and Kael's Vial Remnant from Kael'thas Sunstrider at Tempest Keep."
Lang["Q1_10568"] = "Tablets of Baa'ri"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10568
Lang["Q2_10568"] = "Anchorite Ceyla at the Altar of Sha'tar wants you to collect 12 Baa'ri Tablets from the ground and from Ashtongue Workers at the Ruins of Baa'ri.\n\nCompleting quests with the Aldor will cause your Scryers reputation level to decrease."
Lang["Q1_10683"] = "Tablets of Baa'ri"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10683
Lang["Q2_10683"] = "Arcanist Thelis at the Sanctum of the Stars wants you to collect 12 Baa'ri Tablets from the ground and from Ashtongue Workers at the Ruins of Baa'ri.\n\nCompleting quests with the Scryers will cause your Aldor reputation level to decrease."
Lang["Q1_10571"] = "Oronu the Elder"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10571
Lang["Q2_10571"] = "Anchorite Ceyla at the Altar of Sha'tar wants you to obtain the Orders from Akama from Oronu the Elder at the Ruins of Baa'ri.\n\nCompleting quests for the Aldor will cause your Scryers reputation level to decrease."
Lang["Q1_10684"] = "Oronu the Elder"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10684
Lang["Q2_10684"] = "Arcanist Thelis at the Sanctum of the Stars wants you to obtain the Orders from Akama from Oronu the Elder at the Ruins of Baa'ri.\n\nCompleting quests for the Scryers will cause your Aldor reputation level to decrease."
Lang["Q1_10574"] = "The Ashtongue Corruptors"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10574
Lang["Q2_10574"] = "Obtain the four medallion fragments from Haalum, Eykenen, Lakaan and Uylaru and return to Anchorite Ceyla at the Altar of Sha'tar in Shadowmoon Valley.\n\nPerforming quests for the Aldor will cause your Scryers reputation level to decrease."
Lang["Q1_10685"] = "The Ashtongue Corruptors"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10685
Lang["Q2_10685"] = "Obtain the four medallion fragments from Haalum, Eykenen, Lakaan and Uylaru and return to Arcanist Thelis at the Sanctum of the Stars in Shadowmoon Valley.\n\nPerforming quests for the Scryers will cause your Aldor reputation level to decrease."
Lang["Q1_10575"] = "The Warden's Cage"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10575
Lang["Q2_10575"] = "Anchorite Ceyla wants you to enter the Warden's Cage, south of the Ruins of Baa'ri and interrogate Sanoru on Akama's whereabouts.\n\nCompleting quests for the Aldor will cause your Scryers reputation to decrease."
Lang["Q1_10686"] = "The Warden's Cage"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10686
Lang["Q2_10686"] = "Arcanist Thelis wants you to enter the Warden's Cage, south of the Ruins of Baa'ri and interrogate Sanoru on Akama's whereabouts.\n\nCompleting quests for the Scryers will cause your Aldor reputation to decrease."
Lang["Q1_10622"] = "Proof of Allegiance"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10622
Lang["Q2_10622"] = "Slay Zandras at the Warden's Cage in Shadowmoon Valley and return to Sanoru."
Lang["Q1_10628"] = "Akama"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10628
Lang["Q2_10628"] = "Speak to Akama inside the hidden chamber in the Warden's Cage."
Lang["Q1_10705"] = "Seer Udalo"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10705
Lang["Q2_10705"] = "Find Seer Udalo inside the Arcatraz in Tempest Keep."
Lang["Q1_10706"] = "A Mysterious Portent"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10706
Lang["Q2_10706"] = "Return to Akama at the Warden's Cage in Shadowmoon Valley."
Lang["Q1_10707"] = "The Ata'mal Terrace"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10707
Lang["Q2_10707"] = "Go to the top of the Atam'al Terrace in Shadowmoon Valley and obtain the Heart of Fury. Return to Akama at the Warden's Cage in Shadowmoon Valley when you've completed this task."
Lang["Q1_10708"] = "Akama's Promise"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10708
Lang["Q2_10708"] = "Bring the Medallion of Karabor to A'dal in Shattrath City."
Lang["Q1_10944"] = "The Secret Compromised"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10944
Lang["Q2_10944"] = "Travel to the Warden's Cage in Shadowmoon Valley and speak to Akama."
Lang["Q1_10946"] = "Ruse of the Ashtongue"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10946
Lang["Q2_10946"] = "Travel into Tempest Keep and slay Al'ar while wearing the Ashtongue Cowl. Return to Akama in Shadowmoon Valley once you've completed this task."
Lang["Q1_10947"] = "An Artifact From the Past"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10947
Lang["Q2_10947"] = "Go to the Caverns of Time in Tanaris and gain access to the Battle of Mount Hyjal. Once inside, defeat Rage Winterchill and bring the Time-Phased Phylactery to Akama in Shadowmoon Valley."
Lang["Q1_10948"] = "The Hostage Soul"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10948
Lang["Q2_10948"] = "Travel to Shattrath City to tell A'dal about Akama's request."
Lang["Q1_10949"] = "Entry Into the Black Temple"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10949
Lang["Q2_10949"] = "Travel to the entrance to the Black Temple in Shadowmoon Valley and speak to Xi'ri."
Lang["Q1_10985"] = "A Distraction for Akama"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10985
Lang["Q2_10985"] = "Ensure that Akama and Maiev enter the Black Temple in Shadowmoon Valley after Xi'ri's forces create a distraction."
--v243
Lang["Q1_10984"] = "Speak with the Ogre"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10984
Lang["Q2_10984"] = "Speak with the Ogre, Grok, in the Lower City section of Shattrath City."
Lang["Q1_10983"] = "Mog'dorg the Wizened"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10983
Lang["Q2_10983"] = "Visit Mog'dorg the Wizened atop one of the towers just outside the Circle of Blood in the Blade's Edge Mountains."
Lang["Q1_10995"] = "Grulloc Has Two Skulls"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10995
Lang["Q2_10995"] = "Retrieve Grulloc's Dragon Skull and deliver it to Mog'dorg the Wizened atop the tower at the Circle of Blood in the Blade's Edge Mountains."
Lang["Q1_10996"] = "Maggoc's Treasure Chest"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10996
Lang["Q2_10996"] = "Retrieve Maggoc's Treasure Chest and deliver it to Mog'dorg the Wizened atop the tower at the Circle of Blood in the Blade's Edge Mountains."
Lang["Q1_10997"] = "Even Gronn Have Standards"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10997
Lang["Q2_10997"] = "Retrieve Slaag's Standard and deliver it to Mog'dorg the Wizened atop the tower at the Circle of Blood in the Blade's Edge Mountains."
Lang["Q1_10998"] = "Grim(oire) Business"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10998
Lang["Q2_10998"] = "You must retrieve Vim'gol's Vile Grimoire. Deliver it to Mog'dorg the Wizened atop the tower at the Circle of Blood in the Blade's Edge Mountains."
Lang["Q1_11000"] = "Into the Soulgrinder"			-- https://www.thegeekcrusade-serveur.com/db/?quest=11000
Lang["Q2_11000"] = "Retrieve Skulloc's Soul and deliver it to Mog'dorg the Wizened atop the tower at the Circle of Blood in the Blade's Edge Mountains."
Lang["Q1_11022"] = "Speak with Mog'dorg"			-- https://www.thegeekcrusade-serveur.com/db/?quest=11022
Lang["Q2_11022"] = "Speak with Mog'dorg the Wizened. He stands atop the tower on the east side of the Circle of Blood in the Blade's Edge Mountains."
Lang["Q1_11009"] = "Ogre Heaven"			-- https://www.thegeekcrusade-serveur.com/db/?quest=11009
Lang["Q2_11009"] = "Mog'dorg the Wizened has asked you to speak with Chu'a'lor at Ogri'la in the Blade's Edge Mountains."
--v244
Lang["Q1_10804"] = "Kindness"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10804
Lang["Q2_10804"] = "Mordenai at Netherwing Fields in Shadowmoon Valley wants you to feed 8 Mature Netherwing Drakes."
Lang["Q1_10811"] = "Seek Out Neltharaku"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10811
Lang["Q2_10811"] = "Seek out Neltharaku, patron of the Netherwing Dragonflight."
Lang["Q1_10814"] = "Neltharaku's Tale"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10814
Lang["Q2_10814"] = "Speak with Neltharaku and listen to his story."
Lang["Q1_10836"] = "Infiltrating Dragonmaw Fortress"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10836
Lang["Q2_10836"] = "Neltharaku, flying high above Netherwing Fields in Shadowmoon Valley, wants you to slay 15 Dragonmaw Orcs."
Lang["Q1_10837"] = "To Netherwing Ledge!"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10837
Lang["Q2_10837"] = "Neltharaku, flying high above Netherwing Fields in Shadowmoon Valley, wants you to collect 12 Nethervine Crystals from Netherwing Ledge."
Lang["Q1_10854"] = "The Force of Neltharaku"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10854
Lang["Q2_10854"] = "Neltharaku, flying high above Netherwing Fields in Shadowmoon Valley, wants you to free 5 Enslaved Netherwing Drakes."
Lang["Q1_10858"] = "Karynaku"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10858
Lang["Q2_10858"] = "Seek out Karynaku at Dragonmaw Fortress."
Lang["Q1_10866"] = "Zuluhed the Whacked"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10866
Lang["Q2_10866"] = "Kill Zuluhed the Whacked and recover Zuluhed's Key. Use Zuluhed's Key on Zuluhed's Chains to free Karynaku."
Lang["Q1_10870"] = "Ally of the Netherwing"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10870
Lang["Q2_10870"] = "Let Karynaku return you to Mordenai in the Netherwing Fields."
--v247
Lang["Q1_3801"] = "Dark Iron Legacy"			-- https://www.thegeekcrusade-serveur.com/db/?quest=3801
Lang["Q2_3801"] = "Speak with Franclorn Forgewright if you are interested in obtaining a key to the city major."
Lang["Q1_3802"] = "Dark Iron Legacy"			-- https://www.thegeekcrusade-serveur.com/db/?quest=3802
Lang["Q2_3802"] = "Slay Fineous Darkvire and recover the great hammer, Ironfel. Take Ironfel to the Shrine of Thaurissan and place it on the statue of Franclorn Forgewright."
Lang["Q1_5096"] = "Scarlet Diversions"
Lang["Q2_5096"] = "Proceed to the Scarlet Crusade's base camp between Felstone Field and Dalson's Tears and destroy their command tent."
Lang["Q1_5098"] = "All Along the Watchtowers"
Lang["Q2_5098"] = "Using the Beacon Torch, mark each tower in Andorhal; you will need to stand in the doorway of the tower to successfully mark it."
Lang["Q1_838"] = "Scholomance"
Lang["Q2_838"] = "Speak with Apothecary Dithers at the Bulwark, Western Plaguelands."
Lang["Q1_964"] = "Skeletal Fragments"
Lang["Q2_964"] = "Bring 15 Skeletal Fragments to Apothecary Dithers at the Bulwark, Western Plaguelands."
Lang["Q1_5514"] = "Mold Rhymes With..."
Lang["Q2_5514"] = "Bring the Imbued Skeletal Fragments and 15 gold coins to Krinkle Goodsteel in Gadgetzan."
Lang["Q1_5802"] = "Fire Plume Forged"
Lang["Q2_5802"] = "Take the Skeleton Key Mold and 2 Thorium Bars to the top of Fire Plume Ridge in Un'Goro Crater. Use the Skeleton Key Mold by the lava lake to forge the Unfinished Skeleton Key."
Lang["Q1_5804"] = "Araj's Scarab"
Lang["Q2_5804"] = "Destroy Araj the Summoner and bring Araj's Scarab to Apothecary Dithers at the Bulwark, Western Plaguelands."
Lang["Q1_5511"] = "The Key to Scholomance"
Lang["Q2_5511"] = "Well, here you are - the completed Skeleton Key.  I am certain as I can be that this key will allow you within the confines of the Scholomance. "
Lang["Q1_5092"] = "Clear the Way"
Lang["Q2_5092"] = "Kill 10 Skeletal Flayers and 10 Slavering Ghouls in Sorrow Hill."
Lang["Q1_5097"] = "All Along the Watchtowers"
Lang["Q2_5097"] = "Using the Beacon Torch, mark each tower in Andorhal; you will need to stand in the doorway of the tower to successfully mark it."
Lang["Q1_5533"] = "Scholomance"
Lang["Q2_5533"] = "Speak with Alchemist Arbington at Chillwind Point, Western Plaguelands."
Lang["Q1_5537"] = "Skeletal Fragments"
Lang["Q2_5537"] = "Bring 15 Skeletal Fragments to Alchemist Arbington at Chillwind Point, Western Plaguelands."
Lang["Q1_5538"] = "Mold Rhymes With..."
Lang["Q2_5538"] = "Bring the Imbued Skeletal Fragments and 15 gold coins to Krinkle Goodsteel in Gadgetzan."
Lang["Q1_5801"] = "Fire Plume Forged"
Lang["Q2_5801"] = "Take the Skeleton Key Mold and 2 Thorium Bars to the top of Fire Plume Ridge in Un'Goro Crater. Use the Skeleton Key Mold by the lava lake to forge the Unfinished Skeleton Key."
Lang["Q1_5803"] = "Araj's Scarab"
Lang["Q2_5803"] = "Destroy Araj the Summoner and bring Araj's Scarab to Alchemist Arbington at Chillwind Point, Western Plaguelands."
Lang["Q1_5505"] = "The Key to Scholomance"
Lang["Q2_5505"] = "Well, here you are - the completed Skeleton Key.  I am certain as I can be that this key will allow you within the confines of the Scholomance. "
--v250
Lang["Q1_6804"] = "Poisoned Water"
Lang["Q2_6804"] = "Use the Aspect of Neptulon on poisoned elementals of Eastern Plaguelands. Bring 12 Discordant Bracers and the Aspect of Neptulon to Duke Hydraxis in Azshara."
Lang["Q1_6805"] = "Stormers and Rumblers"
Lang["Q2_6805"] = "Kill 15 Dust Stormers and 15 Desert Rumbers and then return to Duke Hydraxis in Azshara."
Lang["Q1_6821"] = "Eye of the Emberseer"
Lang["Q2_6821"] = "Bring the Eye of the Emberseer to Duke Hydraxis in Azshara."
Lang["Q1_6822"] = "The Molten Core"
Lang["Q2_6822"] = "Kill 1 Fire Lord, 1 Molten Giant, 1 Ancient Core Hound and 1 Lava Surger, then return to Duke Hydraxis in Azshara."
Lang["Q1_6823"] = "Agent of Hydraxis"
Lang["Q2_6823"] = "Earn an Honored faction with the Hydraxian Waterlords, then talk to Duke Hydraxis in Azshara."
Lang["Q1_6824"] = "Hands of the Enemy"
Lang["Q2_6824"] = "Bring the Hands of Lucifron, Sulfuron, Gehennas and Shazzrah to Duke Hydraxis in Azshara."
Lang["Q1_7486"] = "A Hero's Reward"
Lang["Q2_7486"] = "Claim your reward from Hydraxis' Coffer."
-- Ragefire Chasm
Lang["Q1_5726"] = "Hidden Enemies"
Lang["Q2_5726"] = "Bring a Lieutenant's Insignia to Thrall in Orgrimmar."
Lang["Q1_5727"] = "Hidden Enemies"
Lang["Q2_5727"] = "Take the Lieutenant's Insignia to Neeru Fireblade and speak to him. Gauge if he believes you are a member of the Burning Blade and then return to Thrall in Orgrimmar."
Lang["Q1_5728"] = "Hidden Enemies"
Lang["Q2_5728"] = "Kill Bazzalan and Jergosh the Invoker before returning to Thrall in Orgrimmar."
Lang["Q1_5729"] = "Hidden Enemies"
Lang["Q2_5729"] = "Speak to Neeru Fireblade in Orgrimmar."
Lang["Q1_5730"] = "Hidden Enemies"
Lang["Q2_5730"] = "Speak to Thrall in Orgrimmar and tell him what you've learned."
Lang["Q1_5722"] = "Searching for the Lost Satchel"
Lang["Q2_5722"] = "Search Ragefire Chasm for Maur Grimtotem's corpse and search it for any items of interest."
Lang["Q1_5723"] = "Testing an Enemy's Strength"
Lang["Q2_5723"] = "Search Orgrimmar for Ragefire Chasm, then kill 8 Ragefire Troggs and 8 Ragefire Shaman before returning to Rahauro in Thunder Bluff."
Lang["Q1_5724"] = "Returning the Lost Satchel"
Lang["Q2_5724"] = "Take the Grimtotem Satchel to Rahauro in Thunder Bluff."
Lang["Q1_5725"] = "The Power to Destroy..."
Lang["Q2_5725"] = "Bring the books Spells of Shadow and Incantations from the Nether to Varimathras in Undercity."
Lang["Q1_5761"] = "Slaying the Beast"
Lang["Q2_5761"] = "Enter Ragefire Chasm and slay Taragaman the Hungerer, then bring his heart back to Neeru Fireblade in Orgrimmar."
-- The Deadmines
Lang["Q1_12"] = "The People's Militia"
Lang["Q2_12"] = "Gryan Stoutmantle wants you to kill 15 Defias Trappers and 15 Defias Smugglers then return to him on Sentinel Hill."
Lang["Q1_13"] = "The People's Militia"
Lang["Q2_13"] = "Gryan Stoutmantle wants you to kill 15 Defias Pillagers and 15 Defias Looters and return to him on Sentinel Hill."
Lang["Q1_14"] = "The People's Militia"
Lang["Q2_14"] = "Gryan Stoutmantle wants you to kill 15 Defias Highwaymen, 5 Defias Pathstalkers and 5 Defias Knuckledusters then return to him on Sentinel Hill."
Lang["Q1_65"] = "The Defias Brotherhood"
Lang["Q2_65"] = "Gryan Stoutmantle wants you to talk to Wiley in Lakeshire."
Lang["Q1_132"] = "The Defias Brotherhood"
Lang["Q2_132"] = "Take Wiley's Note to Gryan Stoutmantle in Westfall."
Lang["Q1_135"] = "The Defias Brotherhood"
Lang["Q2_135"] = "Take Wiley's Note to Mathias Shaw in Stormwind."
Lang["Q1_141"] = "The Defias Brotherhood"
Lang["Q2_141"] = "Take Shaw's report to Gryan Stoutmantle in Westfall."
Lang["Q1_142"] = "The Defias Brotherhood"
Lang["Q2_142"] = "Track down the Defias Messenger in Westfall and bring his message to Stoutmantle."
Lang["Q1_155"] = "The Defias Brotherhood"
Lang["Q2_155"] = "Escort the Defias Traitor to the secret hideout of the Defias Brotherhood. Once the Defias Traitor shows you where VanCleef and his men are hiding out, return to Gryan Stoutmantle with the information."
Lang["Q1_166"] = "The Defias Brotherhood"
Lang["Q2_166"] = "Kill Edwin VanCleef and bring his head to Gryan Stoutmantle."
Lang["Q1_167"] = "Oh Brother..."
Lang["Q2_167"] = "Bring Foreman Thistlenettle's Explorers' League Badge to Wilder Thistlenettle in Stormwind."
Lang["Q1_168"] = "Collecting Memories"
Lang["Q2_168"] = "Retrieve 4 Miners' Union Cards and return them to Wilder Thistlenettle in Stormwind."
Lang["Q1_214"] = "Red Silk Bandanas"
Lang["Q2_214"] = "Scout Riell at the Sentinel Hill Tower wants you to bring her 10 Red Silk Bandanas."
Lang["Q1_2040"] = "Underground Assault"
Lang["Q2_2040"] = "Retrieve the Gnoam Sprecklesprocket from the Deadmines and return it to Shoni the Shilent in Stormwind."
Lang["Q1_2041"] = "Speak with Shoni"
Lang["Q2_2041"] = "Speak with Shoni the Shilent in Stormwind."
Lang["Q1_373"] = "The Unsent Letter"
Lang["Q2_373"] = "Deliver the Letter to the City Architect to Baros Alexston in Stormwind."
Lang["Q1_92742"] = "Testing the Wells"
Lang["Q2_92742"] = "Use the Well Water Sample Kit to collect samples from the wells at the Jansen Stead and the Molsen Farm."
Lang["Q1_92744"] = "Murloc Gills"
Lang["Q2_92744"] = "Collect 7 Longshore Murloc Gills along the shoreline of Westfall for Alba Fairmoon."
Lang["Q1_92745"] = "The State of the Mines"
Lang["Q2_92745"] = "Slay 4 Kobold Diggers in the Jangolode Mine and 6 Riverpaw Miners in the Gold Coast Quarry."
Lang["Q1_92747"] = "Moonbrook Espionage"
Lang["Q2_92747"] = "Collect 8 Suspicious Industrial Supplies from Moonbrook."
Lang["Q1_92748"] = "Explosive Consultation"
Lang["Q2_92748"] = "Travel to the Dwarven District in Stormwind and find an engineer who can help."
Lang["Q1_92749"] = "A Dynamite Plan"
Lang["Q2_92749"] = "Obtain 10 Coarse Dynamite, then return to Sprite Jumpsprocket in the Dwarven District of Stormwind."
Lang["Q1_92750"] = "Detonation at a Distance"
Lang["Q2_92750"] = "Talk to someone in Stormwind Intelligence about acquiring a remote detonator."
Lang["Q1_92751"] = "Detonation at a Distance"
Lang["Q2_92751"] = "Bring the Remote Detonator Kit to Sprite Jumpsprocket in the Dwarven District of Stormwind."
Lang["Q1_92752"] = "Explosive Consultation"
Lang["Q2_92752"] = "Return to Alba Fairmoon in Westfall with the Extra-Destructive Explosives."
Lang["Q1_92753"] = "Destruction in Deadmines"
Lang["Q2_92753"] = "Find the forge hidden in the Deadmines, and plant the Extra-Destructive Explosives nearby. Then, meet up with Alba Fairmoon at the Deadmines exit."
	

-- NPC
Lang["N1_9196"] = "Highlord Omokk"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9196
Lang["N2_9196"] = "Highlord Omokk is the first boss that will be encountered in Lower Blackrock Spire."
Lang["N1_9237"] = "War Master Voone"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9237
Lang["N2_9237"] = "War Master Voone is a mini-boss that will be encountered in Lower Blackrock Spire."
Lang["N1_9568"] = "Overlord Wyrmthalak"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9568
Lang["N2_9568"] = "Overlord Wyrmthalak is the last boss that will be encountered in Lower Blackrock Spire."
Lang["N1_10429"] = "Warchief Rend Blackhand"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10429
Lang["N2_10429"] = "Warchief Rend Blackhand is the sixth boss that you will encounter in Upper Blackrock Spire. Dal'rend, commonly referred to as Rend, was the ruler of the Dark Horde and the largest threat to Thrall."
Lang["N1_10182"] = "Rexxar"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10182
Lang["N2_10182"] = "<Champion of the Horde>\n\nPaths from south Stonetalon Mountains all the way down to North Feralas."
Lang["N1_8197"] = "Chronalis"	-- https://www.thegeekcrusade-serveur.com/db/?npc=8197
Lang["N2_8197"] = "Chronalis of the Bronze Dragonflight.\n\nLocated at the entrance of the Caverns of Time."
Lang["N1_10664"] = "Scryer"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10664
Lang["N2_10664"] = "Scryer of the Blue Dragonflight.\n\nLocated at the bottom of the Mazthoril cave."
Lang["N1_12900"] = "Somnus"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12900
Lang["N2_12900"] = "Somnus of the Green Dragonflight.\n\nLocated on the eastern side of the Sunken Temple."
Lang["N1_12899"] = "Axtroz"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12899
Lang["N2_12899"] = "Axtroz of the Red Dragonflight.\n\nLocated in Grim Batol, Wetlands."
Lang["N1_10363"] = "General Drakkisath"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10363
Lang["N2_10363"] = "General Drakkisath is the last boss that you will encounter in Upper Blackrock Spire."
Lang["N1_8983"] = "Golem Lord Argelmach"	-- https://www.thegeekcrusade-serveur.com/db/?npc=8983
Lang["N2_8983"] = "Golem Lord Argelmach is the ninth boss that you will encounter in Blackrock Depths."
Lang["N1_9033"] = "General Angerforge"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9033
Lang["N2_9033"] = "General Angerforge is the seventh boss that you will encounter in Blackrock Depths."
Lang["N1_17804"] = "Squire Rowe"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17804
Lang["N2_17804"] = "Located at the Stormwind gates."
Lang["N1_10929"] = "Haleh"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10929
Lang["N2_10929"] = "Stands on top of the Mazthoril cave, outside.\nCan be reached via the blue rune on the floor deep inside the cave."
Lang["N1_9046"] = "Scarshield Quartermaster"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9046
Lang["N2_9046"] = "Located outside the instance, in a little alcove near the balcony entrance of Upper Blackrock Spire"
Lang["N1_15180"] = "Baristolth of the Shifting Sands"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15180
Lang["N2_15180"] = "Baristolth of the Shifting Sands is located at Cenarion Hold in Silithus (49.6,36.6)."
Lang["N1_12017"] = "Broodlord Lashlayer"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12017
Lang["N2_12017"] = "Broodlord Lashlayer is the third boss in Blackwing Lair."
Lang["N1_13020"] = "Vaelastrasz the Corrupt"	-- https://www.thegeekcrusade-serveur.com/db/?npc=13020
Lang["N2_13020"] = "Vaelastrasz the Corrupt is the second boss in Blackwing Lair."
Lang["N1_11583"] = "Nefarian"	-- https://www.thegeekcrusade-serveur.com/db/?npc=11583
Lang["N2_11583"] = "Nefarian is the eighth and final boss of Blackwing Lair."
Lang["N1_15362"] = "Malfurion Stormrage"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15362
Lang["N2_15362"] = "He can be found in The Temple of Atal'Hakkar, and spawns once you approach the Shade of Eranikus."
Lang["N1_15624"] = "Forest Wisp"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15624
Lang["N2_15624"] = "This wisp can be found on Teldrassil, not far from the gates of Darnassus, at (37.6,48.0)."
Lang["N1_15481"] = "Spirit of Azuregos"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15481
Lang["N2_15481"] = "The spirit of Azuregos pats the southern part of Azshara, around (58.8,82.2). He likes to chat."
Lang["N1_11811"] = "Narain Soothfancy"	-- https://www.thegeekcrusade-serveur.com/db/?npc=11811
Lang["N2_11811"] = "Located in a little hut north of Steamwheedle Port (65.2,18.4)."
Lang["N1_15526"] = "Meridith the Mermaiden"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15526
Lang["N2_15526"] = "She pats the underwater area before the big trench, around (59.6,95.6). Once you complete her quest, go see her again and she will give you a swim speed buff."
Lang["N1_15554"] = "Number Two"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15554
Lang["N2_15554"] = "Number Two can be summoned in Winterspring, at a specific site (67.2,72.6). He can take a bit of time to spawn."
Lang["N1_15552"] = "Doctor Weavil"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15552
Lang["N2_15552"] = "This evil gnome can be found on Alcaz Island in Dustwallow Marsh (77.8,17.6). He is stunning!"
Lang["N1_10184"] = "Onyxia"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10184
Lang["N2_10184"] = "When she is not being a Lady in Stormwind, Onyxia resides in her Lair, south of Dustwallow Marsh."
Lang["N1_11502"] = "Ragnaros"	-- https://www.thegeekcrusade-serveur.com/db/?npc=11502
Lang["N2_11502"] = "Ragnaros, the Firelord, is the tenth and final boss of Molten Core. By Fire be Purged!"
Lang["N1_12803"] = "Lord Lakmaeran"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12803
Lang["N2_12803"] = "Located on the Isle of Dread in Feralas, just a bit north of the Chimaera area entrance (29.8,72.6)."
Lang["N1_15571"] = "Maws"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15571
Lang["N2_15571"] = "duunnn dunnn... duuuunnnn duun... duuunnnnnnnn dun dun dun dun dun dun dun dun dun dun dunnnnnnnnnnn dunnnn in Azshara at (65.6,54.6)"
Lang["N1_22037"] = "Smith Gorlunk"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22037
Lang["N2_22037"] = "Located at the forge obviously (67,36), on the northern side of the Black Temple building"
Lang["N1_18733"] = "Fel Reaver"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18733
Lang["N2_18733"] = "Tends to roams the western side of Hellfire Citadel."
Lang["N1_18473"] = "Talon King Ikiss"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18473
Lang["N2_18473"] = "Talon King Ikiss is the last boss of Sethekk Halls in Auchindoun"
Lang["N1_20142"] = "Steward of Time"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20142
Lang["N2_20142"] = "Bronze dragon, near the hourglass in the Caverns of Time."
Lang["N1_20130"] = "Andormu"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20130
Lang["N2_20130"] = "Looks like a little boy, near the hourglass in the Caverns of Time."
Lang["N1_18096"] = "Epoch Hunter"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18096
Lang["N2_18096"] = "Last boss of Caverns of Time: Old Hillsbrad Foothills, spawns in Tarren Mill when Thrall gets there."
Lang["N1_19880"] = "Nether-Stalker Khay'ji"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19880
Lang["N2_19880"] = "He stands next to the forge in Area 52 (32,64)"
Lang["N1_19641"] = "Warp-Raider Nesaad"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19641
Lang["N2_19641"] = "He is located at (28,79). Has 2 adds with him"
Lang["N1_18481"] = "A'dal"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18481
Lang["N2_18481"] = "A'dal is located in the middle of Shattrath City. Big yellow shiny thingy. Can't miss it, really."
Lang["N1_19220"] = "Pathaleon the Calculator"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19220
Lang["N2_19220"] = "Pathaleon the Calculator is the last boss of the Mechanar."
Lang["N1_17977"] = "Warp Splinter"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17977
Lang["N2_17977"] = "Warp Splinter is the fifth boss in The Botanica. He is a large tree elemental."
Lang["N1_17613"] = "Archmage Alturus"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17613
Lang["N2_17613"] = "Stands in front of the entrance of Karazhan."
Lang["N1_18708"] = "Murmur"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18708
Lang["N2_18708"] = "Murmur is the final boss of the Shadow Labyrinth. He is a large wind elemental."
Lang["N1_17797"] = "Hydromancer Thespia"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17797
Lang["N2_17797"] = "Hydromancer Thespia is the first boss of The Steamvault in Coilfang Reservoir."
Lang["N1_20870"] = "Zereketh the Unbound"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20870
Lang["N2_20870"] = "Zereketh the Unbound is the first boss found in The Arcatraz."
Lang["N1_15608"] = "Medhivh"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15608
Lang["N2_15608"] = "Medivh is near the portal, in the south part of the Black Morass."
Lang["N1_16524"] = "Shade of Aran"	-- https://www.thegeekcrusade-serveur.com/db/?npc=16524
Lang["N2_16524"] = "The crazy father of Medhivh, in Karazhan"
Lang["N1_16807"] = "Grand Warlock Nethekurse"	-- https://www.thegeekcrusade-serveur.com/db/?npc=16807
Lang["N2_16807"] = "Grand Warlock Nethekurse is a Fel Orc warlock and first boss in the Shattered Halls."
Lang["N1_18472"] = "Darkweaver Syth"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18472
Lang["N2_18472"] = "Darkweaver Syth is the first boss found in Sethekk Halls."
Lang["N1_22421"] = "Skar'this the Heretic"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22421
Lang["N2_22421"] = "Skar'this is only present in the HEROIC mode of Slave Pens. He is located shortly after the first boss. When you jump down into the pool of water and come out, he is on the left hand side in a cage."
Lang["N1_19044"] = "Gruul the Dragonkiller"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19044
Lang["N2_19044"] = "Gruul the Dragonkiller is the final boss of the raid dungeon Gruul's Lair in Blade's Edge Mountains."
Lang["N1_17225"] = "Nightbane"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17225
Lang["N2_17225"] = "Nightbane is a summonable Dragon boss in Karazhan. Check out his attunement for more info."
Lang["N1_21938"] = "Earthmender Splinthoof"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21938
Lang["N2_21938"] = "Earthmender Splinthoof is inside the small building on the highest point of Shadowmoon Village (28.6,26.6)."
Lang["N1_21183"] = "Oronok Torn-heart"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21183
Lang["N2_21183"] = "Oronok Torn-heart is on top of the hill at a place called Oronok's Farm (53.8,23.4), in between Coilskar Point and the Altar of Sha'tar."
Lang["N1_21291"] = "Grom'tor, Son of Oronok"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21291
Lang["N2_21291"] = "Located in Coilskar Point (44.6,23.6)."
Lang["N1_21292"] = "Ar'tor, Son of Oronok"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21292
Lang["N2_21292"] = "Located at Illidari Point (29.6,50.4), suspended in the air by red beams."
Lang["N1_21293"] = "Borak, Son of Oronok"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21293
Lang["N2_21293"] = "Located just north of Eclipse Point (47.6,57.2)."
Lang["N1_18166"] = "Khadgar"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18166
Lang["N2_18166"] = "He stands in the centre of Shattrath City, just next to A'dal, the big yellow shiny thingy."
Lang["N1_16808"] = "Kargath Bladefist"	-- https://www.thegeekcrusade-serveur.com/db/?npc=16808
Lang["N2_16808"] = "Warchief Kargath Bladefist is the final boss of the Shattered Halls. Spoiler alert, he has blades for fists."
Lang["N1_17798"] = "Warlord Kalithresh"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17798
Lang["N2_17798"] = "Warlord Kalithresh is the third and last boss of The Steamvault in Coilfang Reservoir."
Lang["N1_20912"] = "Harbinger Skyriss"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20912
Lang["N2_20912"] = "Harbinger Skyriss is the fifth and final boss of a multi-wave encounter in The Arcatraz."
Lang["N1_20977"] = "Millhouse Manastorm"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20977
Lang["N2_20977"] = "Millhouse Manastorm is a gnome mage found in the Harbinger Skyriss encounter in The Arcratraz. He will assist in attacking the other creatures released from the prisons."
Lang["N1_17257"] = "Magtheridon"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17257
Lang["N2_17257"] = "Magtheridon is being held prisonner under Hellfire Citadel, in the raid instance called Magtheridon's Lair."
Lang["N1_21937"] = "Earthmender Sophurus"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21937
Lang["N2_21937"] = "Earthmender Sophurus stands outside the inn at Wildhammer Stronghold (36.4,56.8)."
Lang["N1_19935"] = "Soridormi"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19935
Lang["N2_19935"] = "Soridormi wanders around the big hourglass inside the Caverns of Time."
Lang["N1_19622"] = "Kael'thas Sunstrider"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19622
Lang["N2_19622"] = "Kael'thas Sunstrider is the fourth and final boss of the raid instance the Eye."
Lang["N1_21212"] = "Lady Vashj"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21212
Lang["N2_21212"] = "Lady Vashj is the final encounter of the raid instance Serpentshrine Cavern in Coilfang Reservoir."
Lang["N1_21402"] = "Anchorite Ceyla"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21402
Lang["N2_21402"] = "Anchorite Ceyla is at the Altar of Shatar (62.6,28.4)."
Lang["N1_21955"] = "Arcanist Thelis"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21955
Lang["N2_21955"] = "Arcanist Thelis is inside the Sanctum of the Stars (56.2,59.6)"
Lang["N1_21962"] = "Seer Udalo"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21962
Lang["N2_21962"] = "He's lying dead on the small ramp before the last boss fight of The Arcatraz."
Lang["N1_22006"] = "Shadowlord Deathwail"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22006
Lang["N2_22006"] = "He's riding a dragon on the northern tower of the Black Temple (71.6,35.6) "
Lang["N1_22820"] = "Seer Olum"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22820
Lang["N2_22820"] = "Seer Olum is located in Serpentshrine Cavern, behind Fathom-Lord Karathress."
Lang["N1_21700"] = "Akama"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21700
Lang["N2_21700"] = "Akama is located at the Warden's Cage (58.0,48.2)."
Lang["N1_19514"] = "Al'ar"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19514
Lang["N2_19514"] = "Al'ar is the first boss of The Eye. He's a big fiery bird thing."
Lang["N1_17767"] = "Rage Winterchill"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17767
Lang["N2_17767"] = "Rage Winterchill is the first boss in the Mount Hyjal raid instance."
Lang["N1_18528"] = "Xi'ri"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18528
Lang["N2_18528"] = "Xi'ri is located at the entrance of the Black Temple. Big blue shiny thingy. Can't miss it either, really."
--v243
Lang["N1_22497"] = "V'eru"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22497
Lang["N2_22497"] = "V'eru is in the same room as A'dal, but he's blue. He's on the top landing."
--v244
Lang["N1_22113"] = "Mordenai"
Lang["N2_22113"] = "A Blood Elf (spoiler alert, actually a dragon) who walks the Netherwing Fields just east of the Sanctum of the Stars"
--v247
Lang["N1_8888"]  = "Franclorn Forgewright"
Lang["N2_8888"]  = "A ghost dwarf, standing on his own tomb OUTSIDE the dungeon, in the structure suspended above the lava. You can only interact with him if you are DEAD."
Lang["N1_9056"]  = "Fineous Darkvire"
Lang["N2_9056"]  = "He is INSIDE the dungeon, and patrols the quarry area outside of Lord Incendius' chamber."
Lang["N1_10837"] = "High Executor Derrington"
Lang["N2_10837"] = "He can be found at the Bulwark, near the border of Tirisfal and Western Plaguelands"
Lang["N1_10838"] = "Commander Ashlam Valorfist"
Lang["N2_10838"] = "He can be found at Chillwind Camp, just south of Andorhal in the Western Plaguelands"
Lang["N1_1852"]  = "Araj the Summoner"
Lang["N2_1852"]  = "The Lich, in the middle of Andorhal"
--v250
Lang["N1_13278"]  = "Duke Hydraxis"
Lang["N2_13278"]  = "A large Water Elemental on a tiny faraway island in Azshara (79.2,73.6)"
Lang["N1_12264"]  = "Shazzrah"
Lang["N2_12264"]  = "Shazzrah is the fifth boss of Molten Core."
Lang["N1_12118"]  = "Lucifron"
Lang["N2_12118"]  = "Lucifron is the first boss of Molten Core."
Lang["N1_12259"]  = "Gehennas"
Lang["N2_12259"]  = "Gehennas is the third boss of Molten Core."
Lang["N1_12098"]  = "Sulfuron Harbinger"
Lang["N2_12098"]  = "Sulfuron Harbinger, herald of Ragnaros, is the eighth boss of the Molten Core."
-- Ragefire Chasm / Deadmines
Lang["N1_11519"] = "Bazzalan"
Lang["N2_11519"] = "Bazzalan is a satyr boss found on the upper ledge above Jergosh in Ragefire Chasm."
Lang["N1_11518"] = "Jergosh the Invoker"
Lang["N2_11518"] = "Jergosh the Invoker is a warlock boss at the back of Ragefire Chasm."
Lang["N1_11520"] = "Taragaman the Hungerer"
Lang["N2_11520"] = "Taragaman the Hungerer is the felguard boss standing in the lava lake in Ragefire Chasm."
Lang["N1_11834"] = "Maur Grimtotem"
Lang["N2_11834"] = "Maur Grimtotem's corpse lies past the first boss in Ragefire Chasm, off the right-hand path."
Lang["N1_639"] = "Edwin VanCleef"
Lang["N2_639"] = "Edwin VanCleef is the final boss of the Deadmines, aboard the pirate ship in Ironclad Cove."
-- The Stockade
Lang["N1_1663"] = "Dextren Ward"
Lang["N2_1663"] = "Dextren Ward is a boss in The Stockade, found at the end of the left wing."
Lang["N1_1696"] = "Targorr the Dread"
Lang["N2_1696"] = "Targorr the Dread is a boss in The Stockade, found at the end of the right wing."
Lang["N1_1716"] = "Bazil Thredd"
Lang["N2_1716"] = "Bazil Thredd is the final boss of The Stockade, VanCleef's lieutenant held in the deepest cells."
-- Scarlet Monastery
Lang["N1_3974"] = "Houndmaster Loksey"
Lang["N2_3974"] = "Houndmaster Loksey is the boss of Scarlet Monastery Library, in the courtyard with his hounds."
Lang["N1_3975"] = "Herod"
Lang["N2_3975"] = "Herod the Scarlet Champion is the boss of Scarlet Monastery Armory."
Lang["N1_3976"] = "Scarlet Commander Mograine"
Lang["N2_3976"] = "Scarlet Commander Mograine is fought in Scarlet Monastery Cathedral; Whitemane resurrects him."
Lang["N1_3977"] = "High Inquisitor Whitemane"
Lang["N2_3977"] = "High Inquisitor Whitemane is the final boss of Scarlet Monastery Cathedral."
Lang["N1_4275"] = "Archmage Arugal"
Lang["N2_4275"] = "Archmage Arugal is the final boss of Shadowfang Keep, found at the top of the keep."
Lang["N1_3849"] = "Deathstalker Adamant"
Lang["N2_3849"] = "Deathstalker Adamant is in a prison cell, next to the first boss."
Lang["N1_4444"] = "Deathstalker Vincent"
Lang["N2_4444"] = "Deathstalker Vincent's corpse is found in the courthyard."
-- Blackfathom Deeps
Lang["N1_4787"] = "Argent Guard Thaelrid"
Lang["N2_4787"] = "Argent Guard Thaelrid is found inside Blackfathom Deeps, past the initial naga-infested caves."
Lang["N1_4832"] = "Twilight Lord Kelris"
Lang["N2_4832"] = "Twilight Lord Kelris is a boss in Blackfathom Deeps, in the Moonshrine Sanctum."
Lang["N1_12902"] = "Lorgus Jett"
Lang["N2_12902"] = "Lorgus Jett is a Twilight's Hammer caster found in Blackfathom Deeps, along the path toward the Sanctum."
-- Gnomeregan
Lang["N1_7800"] = "Mekgineer Thermaplugg"
Lang["N2_7800"] = "Mekgineer Thermaplugg is the final boss of Gnomeregan, in the Tinkers' Court."
Lang["N1_6231"] = "Techbot"
Lang["N2_6231"] = "Techbot stands near the Gnomeregan instance entrance, outside the dungeon proper."
Lang["N1_7850"] = "Kernobee"
Lang["N2_7850"] = "Kernobee is found inside Gnomeregan and starts the escort quest A Fine Mess."
-- Razorfen Kraul
Lang["N1_4421"] = "Charlga Razorflank"
Lang["N2_4421"] = "Charlga Razorflank is the final boss of Razorfen Kraul."
Lang["N1_4508"] = "Willix the Importer"
Lang["N2_4508"] = "Willix the Importer is found inside Razorfen Kraul and must be escorted out."
-- Razorfen Downs / Maraudon / Hall of Thanes
Lang["N1_7358"] = "Amnennar the Coldbringer"
Lang["N2_7358"] = "Amnennar the Coldbringer is the final boss of Razorfen Downs, atop the Spiral of Thorns."
Lang["N1_12865"] = "Ambassador Malcin"
Lang["N2_12865"] = "Ambassador Malcin camps outside Razorfen Downs among the Death's Head forces."
Lang["N1_12201"] = "Princess Theradras"
Lang["N2_12201"] = "Princess Theradras is the final boss of Maraudon, in Zaetar's Grave."
Lang["N1_13282"] = "Noxxion"
Lang["N2_13282"] = "Noxxion is a Maraudon boss in the orange crystal wing (Wicked Grotto)."
Lang["N1_12236"] = "Lord Vyletongue"
Lang["N2_12236"] = "Lord Vyletongue is a Maraudon boss in the purple crystal wing."
Lang["N1_261319"] = "Durgen Dirgehammer"
Lang["N2_261319"] = "Durgen Dirgehammer is the final boss of the Hall of Thanes."
Lang["N1_261306"] = "Faldrim Anvilmar"
Lang["N2_261306"] = "Faldrim Anvilmar patrols Anvilmar's Rest inside the Hall of Thanes."


Lang["O_1"] = "Click Drakkisath's Brand to complete the quest.\nIt's a glowing orb located behind General Drakkisath."
Lang["O_2"] = "It's a tiny glowing red dot on the ground\nin front of the gates of Ahn'Qiraj (28.7,89.2)."
--v247
Lang["O_3"] = "The shrine is located at the end of a corridor\nthat starts from the upper level of the Ring of Law."

-- Forever dungeon / location names
Lang["Ashenvale"] = "Ashenvale"
Lang["Blackfathom Deeps"] = "Blackfathom Deeps"
Lang["Blackrock Depths Quests"] = "Blackrock Depths Quests"
Lang["Darkshore"] = "Darkshore"
Lang["Darnassus"] = "Darnassus"
Lang["Desolace"] = "Desolace"
Lang["Dire Maul"] = "Dire Maul"
Lang["Dun Morogh"] = "Dun Morogh"
Lang["Gnomeregan"] = "Gnomeregan"
Lang["Hillsbrad Foothills"] = "Hillsbrad Foothills"
Lang["Maraudon"] = "Maraudon"
Lang["Moonglade"] = "Moonglade"
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
Lang["The Hall of Thanes"] = "The Hall of Thanes"
Lang["Excavation Site"] = "Excavation Site"
Lang["City of Dalaran"] = "City of Dalaran"
Lang["The Drowned City"] = "The Drowned City"
Lang["Krol'dok Stronghold"] = "Krol'dok Stronghold"
Lang["Alcaz Prison"] = "Alcaz Prison"
Lang["Blackmaw Hold"] = "Blackmaw Hold"
Lang["The Shapers Terrace"] = "The Shapers Terrace"
Lang["The Stockade"] = "The Stockade"
Lang["The Temple of Atal'Hakkar"] = "The Temple of Atal'Hakkar"
Lang["Thousand Needles"] = "Thousand Needles"
Lang["Uldaman"] = "Uldaman"
Lang["Wailing Caverns"] = "Wailing Caverns"
Lang["Zul'Farrak"] = "Zul'Farrak"

-- Forever / Vanilla dungeon quests
Lang["Q1_17"] = "Uldaman Reagent Run"
Lang["Q2_17"] = "Bring 12 Magenta Fungus Caps to Ghak Healtouch in Thelsamar."
Lang["Q1_2500"] = "Badlands Reagent Run"
Lang["Q2_2500"] = "Bring 5 Buzzard Gizzards, 10 Crag Coyote Fangs, and 5 Rock Elemental Shards to Ghak Healtouch in Thelsamar."
Lang["Q1_261"] = "Down the Scarlet Path"
Lang["Q2_261"] = "Destroy 30 Undead Ravagers, then return to Brother Anton at Nijel's Point."
Lang["Q1_377"] = "Crime and Punishment"
Lang["Q2_377"] = "Bring the hand of Dextren Ward to Councilman Millstipe in Darkshire."
Lang["Q1_386"] = "What Comes Around..."
Lang["Q2_386"] = "Bring the head of Targorr the Dread to Guard Berton in Lakeshire."
Lang["Q1_387"] = "Quell The Uprising"
Lang["Q2_387"] = "Warden Thelwater wants you to kill 10 Defias Prisoners, 8 Defias Convicts and 8 Defias Insurgents."
Lang["Q1_388"] = "The Color of Blood"
Lang["Q2_388"] = "Nikova Raskol in Stormwind wants 10 Red Wool Bandanas."
Lang["Q1_389"] = "Bazil Thredd"
Lang["Q2_389"] = "Speak with Warden Thelwater in the Stockade."
Lang["Q1_391"] = "The Stockade Riots"
Lang["Q2_391"] = "Kill Bazil Thredd and bring his head back to Warden Thelwater."
Lang["Q1_709"] = "Solution to Doom"
Lang["Q2_709"] = "Bring the Tablet of Ryun'eh to Theldurin the Lost."
Lang["Q1_720"] = "A Sign of Hope"
Lang["Q2_720"] = "Find Prospector Ryedol and let him know Hammertoe Grez is alive."
Lang["Q1_721"] = "A Sign of Hope"
Lang["Q2_721"] = "Find Hammertoe Grez in Uldaman."
Lang["Q1_722"] = "Amulet of Secrets"
Lang["Q2_722"] = "Find Hammertoe's Amulet and return it to him in Uldaman."
Lang["Q1_865"] = "Raptor Horns"
Lang["Q2_865"] = "Bring 5 Intact Raptor Horns to Mebok Mizzyrix in Ratchet."
Lang["Q1_870"] = "The Forgotten Pools"
Lang["Q2_870"] = "Search the Forgotten Pools northwest of the Crossroads for a source of power, then return to Tonga Runetotem."
Lang["Q1_877"] = "The Stagnant Oasis"
Lang["Q2_877"] = "Test the Dried Seeds at the fissure in the Stagnant Oasis southeast of the Crossroads, then return to Tonga Runetotem."
Lang["Q1_880"] = "Altered Beings"
Lang["Q2_880"] = "Bring 8 Altered Snapjaw Shells to Tonga Runetotem at the Crossroads."
Lang["Q1_886"] = "The Barrens Oases"
Lang["Q2_886"] = "Speak with Tonga Runetotem at the Crossroads."
Lang["Q1_914"] = "Leaders of the Fang"
Lang["Q2_914"] = "Bring the Gems of Cobrahn, Anacondra, Pythas and Serpentis to Nara Wildmane in Thunder Bluff."
Lang["Q1_959"] = "Trouble at the Docks"
Lang["Q2_959"] = "Crane Operator Bigglefuzz in Ratchet wants you to retrieve the bottle of 99-Year-Old Port from Mad Magglish."
Lang["Q1_962"] = "Serpentbloom"
Lang["Q2_962"] = "Apothecary Zamah in Thunder Bluff wants 10 Serpentbloom."
Lang["Q1_971"] = "Knowledge in the Deeps"
Lang["Q2_971"] = "Bring the Lorgalis Manuscript to Gerrig Bonegrip in the Forlorn Cavern of Ironforge."
Lang["Q1_1013"] = "The Book of Ur"
Lang["Q2_1013"] = "Bring the Book of Ur to Keeper Bel'dugur in the Undercity."
Lang["Q1_1014"] = "Arugal Must Die"
Lang["Q2_1014"] = "Kill Arugal and bring his head to Dalar Dawnweaver at the Sepulcher."
Lang["Q1_1048"] = "Into The Scarlet Monastery"
Lang["Q2_1048"] = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod, and Houndmaster Loksey, then report to Varimathras in the Undercity."
Lang["Q1_1049"] = "Compendium of the Fallen"
Lang["Q2_1049"] = "Retrieve the Compendium of the Fallen from the Monastery and return to Sage Truthseeker in Thunder Bluff."
Lang["Q1_1050"] = "Mythology of the Titans"
Lang["Q2_1050"] = "Retrieve Mythology of the Titans from the Monastery and bring it to Librarian Mae Paledust in Ironforge."
Lang["Q1_1051"] = "Vorrel's Revenge"
Lang["Q2_1051"] = "Return Vorrel Sengutz's wedding ring to Monika Sengutz in Tarren Mill."
Lang["Q1_1052"] = "Down the Scarlet Path"
Lang["Q2_1052"] = "Take Brother Anton's Letter of Commendation to Raleigh the Devout in Southshore."
Lang["Q1_1053"] = "In the Name of the Light"
Lang["Q2_1053"] = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod, and Houndmaster Loksey, then report to Raleigh the Devout in Southshore."
Lang["Q1_1098"] = "Deathstalkers in Shadowfang"
Lang["Q2_1098"] = "Find the Deathstalker Adamant and Deathstalker Vincent."
Lang["Q1_1100"] = "Lonebrow's Journal"
Lang["Q2_1100"] = "Read Henrig Lonebrow's Journal."
Lang["Q1_1101"] = "The Crone of the Kraul"
Lang["Q2_1101"] = "Bring Razorflank's Medallion to Falfindel Waywarder in Thalanaar."
Lang["Q1_1102"] = "A Vengeful Fate"
Lang["Q2_1102"] = "Bring Razorflank's Heart to Auld Stonespire in Thunder Bluff."
Lang["Q1_1109"] = "Going, Going, Guano!"
Lang["Q2_1109"] = "Bring 1 pile of Kraul Guano to Master Apothecary Faranell in the Undercity."
Lang["Q1_1113"] = "Hearts of Zeal"
Lang["Q2_1113"] = "Master Apothecary Faranell in the Undercity wants 20 Hearts of Zeal."
Lang["Q1_1139"] = "The Lost Tablets of Will"
Lang["Q2_1139"] = "Find the Tablet of Will and return it to Advisor Belgrum in Ironforge."
Lang["Q1_1142"] = "Mortality Wanes"
Lang["Q2_1142"] = "Find and return Treshala's Pendant to Treshala Fallowbrook in Darnassus."
Lang["Q1_1144"] = "Willix the Importer"
Lang["Q2_1144"] = "Escort Willix the Importer out of Razorfen Kraul."
Lang["Q1_1149"] = "Test of Faith"
Lang["Q2_1149"] = "If you have faith, leap from the planks overlooking Thousand Needles."
Lang["Q1_1150"] = "Test of Endurance"
Lang["Q2_1150"] = "Bring Grenka's Claw to Dorn Plainstalker in Thousand Needles."
Lang["Q1_1151"] = "Test of Strength"
Lang["Q2_1151"] = "Bring Fragments of Rok'Alim to Dorn Plainstalker in Thousand Needles."
Lang["Q1_1152"] = "Test of Lore"
Lang["Q2_1152"] = "Find Braug Dimspirit near the entrance to Talondeep Path in Stonetalon Mountains."
Lang["Q1_1154"] = "Test of Lore"
Lang["Q2_1154"] = "Find the Legacy of the Aspects and return it to Braug Dimspirit near the entrance to Talondeep Path in Stonetalon Mountains."
Lang["Q1_1159"] = "Test of Lore"
Lang["Q2_1159"] = "Find Parqual Fintallas in Undercity."
Lang["Q1_1160"] = "Test of Lore"
Lang["Q2_1160"] = "Find The Beginnings of the Undead Threat, and return it to Parqual Fintallas in Undercity."
Lang["Q1_1198"] = "In Search of Thaelrid"
Lang["Q2_1198"] = "Seek out Argent Guard Thaelrid in Blackfathom Deeps."
Lang["Q1_1199"] = "Twilight Falls"
Lang["Q2_1199"] = "Bring 10 Twilight Pendants to Argent Guard Manados in Darnassus."
Lang["Q1_1200"] = "Blackfathom Villainy"
Lang["Q2_1200"] = "Bring the head of Twilight Lord Kelris to Dawnwatcher Selgorm in Darnassus."
Lang["Q1_78916"] = "The Heart of the Void"
Lang["Q2_78916"] = "Bring the Blackfathom Pearl to Dawnwatcher Selgorm in Darnassus."
Lang["Q1_1221"] = "Blueleaf Tubers"
Lang["Q2_1221"] = "Bring 6 Blueleaf Tubers to Mebok Mizzyrix in Ratchet."
Lang["Q1_1275"] = "Researching the Corruption"
Lang["Q2_1275"] = "Gershala Nightwhisper in Auberdine wants 8 Corrupt Brain stems."
Lang["Q1_1394"] = "Final Passage"
Lang["Q2_1394"] = "Speak to Dorn Plainstalker in Thousand Needles."
Lang["Q1_6627"] = "Test of Lore"
Lang["Q2_6627"] = "Answer Braug Dimspirit's question successfully and then speak to him again. He will remain in Stonetalon Mountains when you are ready."
Lang["Q1_6628"] = "Test of Lore"
Lang["Q2_6628"] = "Answer Parqual Fintallas' question successfully and then speak to him again. He will remain in the Undercity until you are ready."
Lang["Q1_1360"] = "Reclaimed Treasures"
Lang["Q2_1360"] = "Get Krom Stoutarm's treasure from the North Common Hall and bring it to Ironforge."
Lang["Q1_1424"] = "Pool of Tears"
Lang["Q2_1424"] = "Fel'Zerul in Stonard wants you to gather 10 Atal'ai Artifacts."
Lang["Q1_1429"] = "The Atal'ai Exile"
Lang["Q2_1429"] = "Bring the Bundle of Atal'ai Artifacts to the Atal'ai Exile in the Hinterlands."
Lang["Q1_1444"] = "Return to Fel'Zerul"
Lang["Q2_1444"] = "Return to Fel'Zerul in Stonard."
Lang["Q1_1445"] = "The Temple of Atal'Hakkar"
Lang["Q2_1445"] = "Collect 20 Fetishes of Hakkar and bring them to Fel'Zerul in Stonard."
Lang["Q1_1446"] = "Jammal'an the Prophet"
Lang["Q2_1446"] = "The Atal'ai Exile in the Hinterlands wants the Head of Jammal'an."
Lang["Q1_1475"] = "Into The Temple of Atal'Hakkar"
Lang["Q2_1475"] = "Gather 10 Atal'ai Tablets for Brohann Caskbelly in Stormwind."
Lang["Q1_1486"] = "Deviate Hides"
Lang["Q2_1486"] = "Nalpak wants 20 Deviate Hides."
Lang["Q1_1487"] = "Deviate Eradication"
Lang["Q2_1487"] = "Ebru wants you to kill 7 Deviate Ravagers, Vipers, Shamblers and Dreadfangs."
Lang["Q1_1489"] = "Hamuul Runetotem"
Lang["Q2_1489"] = "Speak with Hamuul Runetotem on the Elder Rise in Thunder Bluff."
Lang["Q1_1490"] = "Nara Wildmane"
Lang["Q2_1490"] = "Speak with Nara Wildmane in Thunder Bluff."
Lang["Q1_1491"] = "Smart Drinks"
Lang["Q2_1491"] = "Bring 6 portions of Wailing Essence to Mebok Mizzyrix in Ratchet."
Lang["Q1_2198"] = "The Shattered Necklace"
Lang["Q2_2198"] = "Search for the original creator of the shattered necklace to learn of its potential value."
Lang["Q1_2200"] = "Back to Uldaman"
Lang["Q2_2200"] = "Search for clues to the shattered necklace in Uldaman."
Lang["Q1_2201"] = "Find the Gems"
Lang["Q2_2201"] = "Find the ruby, sapphire and topaz in Uldaman."
Lang["Q1_2202"] = "Uldaman Reagent Run"
Lang["Q2_2202"] = "Bring 12 Magenta Fungus Caps to Jarkal Mossmeld in Kargath."
Lang["Q1_2204"] = "Restoring the Necklace"
Lang["Q2_2204"] = "Obtain a power source from the strongest construct in Uldaman and deliver it to Talvash in Ironforge."
Lang["Q1_2240"] = "The Hidden Chamber"
Lang["Q2_2240"] = "Read Baelog's Journal, explore the hidden chamber, then report to Prospector Stormpike."
Lang["Q1_2258"] = "Badlands Reagent Run"
Lang["Q2_2258"] = "Bring 5 Buzzard Gizzards, 10 Crag Coyote Fangs, and 5 Rock Elemental Shards to Jarkal Mossmeld in Kargath."
Lang["Q1_2278"] = "The Platinum Discs"
Lang["Q2_2278"] = "Speak with the stone watcher and learn what you can, then activate the Discs of Norgannon."
Lang["Q1_2279"] = "The Platinum Discs"
Lang["Q2_2279"] = "Take the miniature platinum discs to the Explorers' League in Ironforge."
Lang["Q1_2280"] = "The Platinum Discs"
Lang["Q2_2280"] = "Take the miniature platinum discs to someone interested in them in Thunder Bluff."
Lang["Q1_2283"] = "Necklace Recovery"
Lang["Q2_2283"] = "Look for a valuable necklace in the Uldaman dig site and bring it to Dran Droffers in Orgrimmar."
Lang["Q1_2284"] = "Necklace Recovery, Take 2"
Lang["Q2_2284"] = "Find a clue as to the gems' whereabouts in the depths of Uldaman."
Lang["Q1_2318"] = "Translating the Journal"
Lang["Q2_2318"] = "Find someone who can translate the paladin's journal. The closest location that might have someone is Kargath, in the Badlands."
Lang["Q1_2339"] = "Find the Gems and Power Source"
Lang["Q2_2339"] = "Recover all three gems and a power source from Uldaman; bring them to Jarkal in Kargath."
Lang["Q1_2342"] = "Reclaimed Treasures"
Lang["Q2_2342"] = "Get the Garrett Family Treasure from the South Common Hall and bring it to Undercity."
Lang["Q1_2398"] = "The Lost Dwarves"
Lang["Q2_2398"] = "Find Baelog in Uldaman."
Lang["Q1_2418"] = "Power Stones"
Lang["Q2_2418"] = "Bring 8 Dentrium Power Stones and 8 An'Alleum Power Stones to Rigglefuzz in the Badlands."
Lang["Q1_2768"] = "Divino-matic Rod"
Lang["Q2_2768"] = "Bring the Divino-matic Rod to Chief Engineer Bilgewhizzle in Gadgetzan."
Lang["Q1_2770"] = "Gahz'rilla"
Lang["Q2_2770"] = "Bring Gahz'rilla's Electrified Scale to Wizzle Brassbolts in the Shimmering Flats."
Lang["Q1_2841"] = "Rig Wars"
Lang["Q2_2841"] = "Retrieve the Rig Blueprints and Thermaplugg's Safe Combination from Gnomeregan for Nogg in Orgrimmar."
Lang["Q1_2842"] = "Chief Engineer Scooty"
Lang["Q2_2842"] = "Speak with Scooty in Booty Bay."
Lang["Q1_2843"] = "Gnomer-gooooone!"
Lang["Q2_2843"] = "Wait for Scooty to calibrate the Goblin Transponder."
Lang["Q1_2846"] = "Tiara of the Deep"
Lang["Q2_2846"] = "Bring the Tiara of the Deep to Tabetha in Dustwallow Marsh."
Lang["Q1_2865"] = "Scarab Shells"
Lang["Q2_2865"] = "Bring 5 Uncracked Scarab Shells to Tran'rek in Gadgetzan."
Lang["Q1_2904"] = "A Fine Mess"
Lang["Q2_2904"] = "Escort Kernobee to the Clockwerk Run exit, then report to Scooty in Booty Bay."
Lang["Q1_79987"] = "Return of the Ring"
Lang["Q2_79987"] = "You may keep the ring, or find the person responsible for the imprint and engravings on the inside of the band."
Lang["Q1_80324"] = "The Mad King"
Lang["Q2_80324"] = "Bring Thermaplugg's Engineering Notes to High Tinker Mekkatorque at Tinker Town in Ironforge."
Lang["Q1_2922"] = "Save Techbot's Brain!"
Lang["Q2_2922"] = "Bring Techbot's Memory Core to Tinkmaster Overspark in Ironforge."
Lang["Q1_2923"] = "Tinkmaster Overspark"
Lang["Q2_2923"] = "Speak with Tinkmaster Overspark in Ironforge."
Lang["Q1_2924"] = "Essential Artificials"
Lang["Q2_2924"] = "Bring 12 Essential Artificials to Klockmort Spannerspan in Ironforge."
Lang["Q1_2926"] = "Gnogaine"
Lang["Q2_2926"] = "Collect radioactive fallout with the Empty Leaden Collection Phial and return it to Ozzie Togglevolt."
Lang["Q1_2927"] = "The Day After"
Lang["Q2_2927"] = "Speak with Ozzie Togglevolt in Kharanos."
Lang["Q1_2928"] = "Gyrodrillmatic Excavationators"
Lang["Q2_2928"] = "Bring 24 Robo-mechanical Guts to Shoni in Stormwind."
Lang["Q1_2929"] = "The Grand Betrayal"
Lang["Q2_2929"] = "Venture to Gnomeregan and kill Mekgineer Thermaplugg. Return to High Tinker Mekkatorque."
Lang["Q1_2933"] = "Venom Bottles"
Lang["Q2_2933"] = "Bring a Venom Bottle to an apothecary in Tarren Mill."
Lang["Q1_2934"] = "Undamaged Venom Sac"
Lang["Q2_2934"] = "Bring an Undamaged Venom Sac to Apothecary Lydon in Tarren Mill."
Lang["Q1_2935"] = "Consult Master Gadrin"
Lang["Q2_2935"] = "Speak with Master Gadrin in Sen'jin Village."
Lang["Q1_2936"] = "The Spider God"
Lang["Q2_2936"] = "Read from the Tablet of Theka to learn the name of the Witherbark spider god, then return to Master Gadrin."
Lang["Q1_2991"] = "Nekrum's Medallion"
Lang["Q2_2991"] = "Bring Nekrum's Medallion to Thadius Grimshade in the Blasted Lands."
Lang["Q1_3042"] = "Troll Temper"
Lang["Q2_3042"] = "Bring 20 Vials of Troll Temper to Trenton Lighthammer in Gadgetzan."
Lang["Q1_3341"] = "Bring the End"
Lang["Q2_3341"] = "Andrew Brownell wants you to kill Amnennar the Coldbringer and return his skull."
Lang["Q1_3369"] = "In Nightmares"
Lang["Q2_3369"] = "Bring the Nightmare Shard to Hamuul Runetotem on the Elder Rise."
Lang["Q1_3373"] = "The Essence of Eranikus"
Lang["Q2_3373"] = "Place the Essence of Eranikus in the Essence Font located in this lair in the Sunken Temple."
Lang["Q1_3380"] = "The Sunken Temple"
Lang["Q2_3380"] = "Find Marvon Rivetseeker in Tanaris."
Lang["Q1_3444"] = "The Stone Circle"
Lang["Q2_3444"] = "Retrieve the Stone Circle from Marvon Rivetseeker's workshop in Ratchet."
Lang["Q1_3445"] = "The Sunken Temple"
Lang["Q2_3445"] = "Find Marvon Rivetseeker in Tanaris."
Lang["Q1_3446"] = "Into the Depths"
Lang["Q2_3446"] = "Find the Altar of Hakkar in the Sunken Temple in Swamp of Sorrows."
Lang["Q1_3447"] = "Secret of the Circle"
Lang["Q2_3447"] = "Travel to the Sunken Temple and discover the secret hidden in the circle of statues."
Lang["Q1_3523"] = "Scourge of the Downs"
Lang["Q2_3523"] = "Speak with Belnistrasz and hand the Oathstone back to him if you agree to aid him."
Lang["Q1_3525"] = "Extinguishing the Idol"
Lang["Q2_3525"] = "Protect Belnistrasz while he performs the ritual to shut down the Quilboar idol."
Lang["Q1_3520"] = "Screecher Spirits"
Lang["Q2_3520"] = "Capture the spirits of 3 screechers in Feralas, then return to Yeh'kinya in Steamwheedle Port."
Lang["Q1_3527"] = "The Prophecy of Mosh'aru"
Lang["Q2_3527"] = "Bring the First and Second Mosh'aru Tablets to Yeh'kinya in Tanaris."
Lang["Q1_4787"] = "The Ancient Egg"
Lang["Q2_4787"] = "Bring the Ancient Egg to Yeh'kinya in Tanaris."
Lang["Q1_3528"] = "The God Hakkar"
Lang["Q2_3528"] = "Bring the Filled Egg of Hakkar to Yeh'kinya in Tanaris."
Lang["Q1_3636"] = "Bring the Light"
Lang["Q2_3636"] = "Archbishop Benedictus wants you to slay Amnennar the Coldbringer in Razorfen Downs."
Lang["Q1_3906"] = "Disharmony of Flame"
Lang["Q2_3906"] = "Travel to the quarry near Blackrock Depths and slay Overmaster Pyron. Return to Thunderheart when the task is complete."
Lang["Q1_3907"] = "Disharmony of Fire"
Lang["Q2_3907"] = "Enter Blackrock Depths and track down Lord Incendius. Slay him and bring any information you find to Thunderheart."
Lang["Q1_3981"] = "Commander Gor'shak"
Lang["Q2_3981"] = "Find Commander Gor'shak in Blackrock Depths."
Lang["Q1_4001"] = "What Is Going On?"
Lang["Q2_4001"] = "Find out from Kharan Mighthammer what he knows about Princess Moira. Take that information to Thrall in Orgrimmar."
Lang["Q1_4002"] = "The Eastern Kingdoms"
Lang["Q2_4002"] = "Speak with Thrall if you are prepared to take on the mission he has planned."
Lang["Q1_4003"] = "The Royal Rescue"
Lang["Q2_4003"] = "Slay Emperor Dagran Thaurissan and free Princess Moira Bronzebeard."
Lang["Q1_4004"] = "The Princess Saved?"
Lang["Q2_4004"] = "Return to Thrall!"
Lang["Q1_4024"] = "A Taste of Flame"
Lang["Q2_4024"] = "Travel to Blackrock Depths and slay Bael'Gar. Return Encased Fiery Essence to Cyrus Therepentous."
Lang["Q1_4063"] = "The Rise of the Machines"
Lang["Q2_4063"] = "Find and slay Golem Lord Argelmach. Return his head to Lotwil. You will also need to collect 10 Intact Elemental Cores from the Ragereaver Golems."
Lang["Q1_4081"] = "KILL ON SIGHT: Dark Iron Dwarves"
Lang["Q2_4081"] = "Venture to Blackrock Depths and destroy the vile Dwarves! Warlord Goretooth wants you to kill 15 Anvilrage Guardsmen, 10 Anvilrage Wardens and 5 Anvilrage Footmen."
Lang["Q1_4082"] = "KILL ON SIGHT: High Ranking Dark Iron Officials"
Lang["Q2_4082"] = "Venture to Blackrock Depths and destroy the vile Dwarves! Warlord Goretooth wants you to kill 10 Anvilrage Medics, 10 Anvilrage Soldiers and 10 Anvilrage Officers."
Lang["Q1_4123"] = "The Heart of the Mountain"
Lang["Q2_4123"] = "Bring the Heart of the Mountain to Maxwort Uberglint in the Burning Steppes."
Lang["Q1_4126"] = "Hurley Blackbreath"
Lang["Q2_4126"] = "Bring the Lost Thunderbrew Recipe to Ragnar Thunderbrew."
Lang["Q1_4134"] = "Lost Thunderbrew Recipe"
Lang["Q2_4134"] = "Bring the Lost Thunderbrew Recipe to Vivian Lagrave."
Lang["Q1_4136"] = "Ribbly Screwspigot"
Lang["Q2_4136"] = "Bring Ribbly's Head to Yuka Screwspigot in the Burning Steppes."
Lang["Q1_4201"] = "The Love Potion"
Lang["Q2_4201"] = "Bring 4 Gromsblood, 10 Giant Silver Veins and Nagmara's Filled Vial to Mistress Nagmara in Blackrock Depths."
Lang["Q1_4262"] = "Overmaster Pyron"
Lang["Q2_4262"] = "Slay Overmaster Pyron and return to Jalinda Sprig."
Lang["Q1_4263"] = "Incendius!"
Lang["Q2_4263"] = "Find Lord Incendius in Blackrock Depths and destroy him!"
Lang["Q1_4286"] = "The Good Stuff"
Lang["Q2_4286"] = "Travel to Blackrock Depths and recover 20 Dark Iron Fanny Packs."
Lang["Q1_4341"] = "Kharan Mighthammer"
Lang["Q2_4341"] = "Travel to Blackrock Depths and find Kharan Mighthammer."
Lang["Q1_4342"] = "Kharan's Tale"
Lang["Q2_4342"] = "Listen as Kharan Mighthammer tells his story."
Lang["Q1_4361"] = "The Bearer of Bad News"
Lang["Q2_4361"] = "Return to Ironforge and speak with King Magni Bronzebeard."
Lang["Q1_4362"] = "The Fate of the Kingdom"
Lang["Q2_4362"] = "Return to Blackrock Depths and rescue Princess Moira Bronzebeard from the evil Emperor Dagran Thaurissan."
Lang["Q1_4363"] = "The Princess's Surprise"
Lang["Q2_4363"] = "Return to King Magni Bronzebeard in Ironforge and give him the good news."
Lang["Q1_5212"] = "The Flesh Does Not Lie"
Lang["Q2_5212"] = "Recover 10 Plagued Flesh Samples from Stratholme and return them to Betina Bigglezink."
Lang["Q1_5213"] = "The Active Agent"
Lang["Q2_5213"] = "Travel to Stratholme and search the ziggurats. Find and return new Scourge Data to Betina Bigglezink."
Lang["Q1_5214"] = "The Great Ezra Grimm"
Lang["Q2_5214"] = "Find Ezra Grimm's smoke shop in Stratholme and recover a box of Grimm's Premium Tobacco for Smokey LaRue."
Lang["Q1_5243"] = "Houses of the Holy"
Lang["Q2_5243"] = "Travel to Stratholme, in the north. Search the supply crates that permeate the city and recover 5 Stratholme Holy Water. Return to Leonid Barthalomew the Revered when you have collected enough of the blessed fluid."
Lang["Q1_5251"] = "The Archivist"
Lang["Q2_5251"] = "Travel to Stratholme and find Archivist Galford of the Scarlet Crusade. Destroy him and burn the Scarlet Archive."
Lang["Q1_5262"] = "The Truth Comes Crashing Down"
Lang["Q2_5262"] = "Take the Head of Balnazzar to Duke Nicholas Zverenhoff at Light's Hope Chapel."
Lang["Q1_5263"] = "Above and Beyond"
Lang["Q2_5263"] = "Venture to Stratholme and destroy Baron Rivendare. Take his head and return to Duke Nicholas Zverenhoff."
Lang["Q1_5282"] = "The Restless Souls"
Lang["Q2_5282"] = "Use Egan's Blaster on the ghostly and spectral citizens of Stratholme. When the restless souls break free of their ghostly shells, feed them again - free 15 souls and return to Egan."
Lang["Q1_5341"] = "Barov Family Fortune"
Lang["Q2_5341"] = "Venture to Scholomance and recover the Barov family fortune. Four deeds make up this fortune. Return to Alexi Barov when you have completed this task."
Lang["Q1_5342"] = "The Last Barov"
Lang["Q2_5342"] = "Travel to Chillwind Camp - Alliance territory - and assassinate Weldon Barov. Take his head and return to Alexi Barov."
Lang["Q1_5343"] = "Barov Family Fortune"
Lang["Q2_5343"] = "Venture to Scholomance and recover the Barov family fortune. Four deeds make up this fortune: The Deed to Caer Darrow; The Deed to Brill; The Deed to Tarren Mill; and The Deed to Southshore. Return to Weldon Barov when you have completed this task."
Lang["Q1_5344"] = "The Last Barov"
Lang["Q2_5344"] = "Travel to the Bulwark - Alliance territory - and assassinate Alexi Barov. Take his head and return to Weldon Barov."
Lang["Q1_5382"] = "Doctor Theolen Krastinov, the Butcher"
Lang["Q2_5382"] = "Find Doctor Theolen Krastinov inside Scholomance. Destroy him, then burn the Remains of Eva Sarkhoff and the Remains of Lucien Sarkhoff. Return to Eva Sarkhoff when the task is complete."
Lang["Q1_5384"] = "Kirtonos the Herald"
Lang["Q2_5384"] = "Return to Scholomance with the Blood of Innocents. Find the porch and place the Blood of Innocents in the brazier. Kirtonos will come to feast upon your soul. Fight valiantly, do not give an inch! Destroy Kirtonos and return to Eva Sarkhoff."
Lang["Q1_5463"] = "Menethil's Gift"
Lang["Q2_5463"] = "Travel to Stratholme and find Menethil's Gift. Place the Keepsake of Remembrance upon the unholy ground."
Lang["Q1_5466"] = "The Lich, Ras Frostwhisper"
Lang["Q2_5466"] = "Find Ras Frostwhisper in Scholomance. Use the Soulbound Keepsake on his undead form. Should you succeed, destroy the mortal Ras Frostwhisper and bring his Human Head to Magistrate Marduke."
Lang["Q1_5515"] = "Krastinov's Bag of Horrors"
Lang["Q2_5515"] = "Locate Jandice Barov in Scholomance and destroy her. Recover Krastinov's Bag of Horrors from her corpse. Return to Eva Sarkhoff."
Lang["Q1_5526"] = "Shards of the Felvine"
Lang["Q2_5526"] = "Find a Felvine Shard in Dire Maul East, seal it in a Reliquary of Purity, and return to Rabine Saturna."
Lang["Q1_5529"] = "Plagued Hatchlings"
Lang["Q2_5529"] = "Kill 20 Plagued Hatchlings, then return to Betina Bigglezink at the Light's Hope Chapel."
Lang["Q1_5848"] = "Of Love and Family"
Lang["Q2_5848"] = "Travel to Stratholme, in the northern part of the Plaguelands. Find the painting 'Of Love and Family' in the Scarlet Bastion and bring it back to Tirion Fordring."
Lang["Q1_6141"] = "Brother Anton"
Lang["Q2_6141"] = "Speak with Brother Anton in Desolace."
Lang["Q1_6521"] = "An Unholy Alliance"
Lang["Q2_6521"] = "Bring Ambassador Malcin's Head to Varimathras in the Undercity."
Lang["Q1_6522"] = "An Unholy Alliance"
Lang["Q2_6522"] = "Take the Small Scroll to Varimathras in the Undercity."
Lang["Q1_6561"] = "Blackfathom Villainy"
Lang["Q2_6561"] = "Bring the head of Twilight Lord Kelris to Bashana Runetotem in Thunder Bluff."
Lang["Q1_6922"] = "Baron Aquanis"
Lang["Q2_6922"] = "Bring the Strange Water Globe to Je'neu Sancrea at Zoram'gar Outpost, Ashenvale."
Lang["Q1_78917"] = "The Heart of the Void"
Lang["Q2_78917"] = "Bring the Blackfathom Pearl to Bashana Runetotem in Thunder Bluff."
Lang["Q1_80140"] = "Return of the Ring"
Lang["Q2_80140"] = "You may keep the ring, or find the person responsible for the imprint and engravings on the inside of the band."
Lang["Q1_80325"] = "The Mad King"
Lang["Q2_80325"] = "Bring Thermaplugg's Engineering Notes to Nogg at the Valley of Honor in Orgrimmar."
Lang["Q1_6562"] = "Trouble in the Deeps"
Lang["Q2_6562"] = "Speak with Je'neu Sancrea at Zoram'gar Outpost in Ashenvale."
Lang["Q1_6563"] = "The Essence of Aku'Mai"
Lang["Q2_6563"] = "Bring 20 Sapphires of Aku'Mai to Je'neu Sancrea at Zoram'gar Outpost."
Lang["Q1_6564"] = "Allegiance to the Old Gods"
Lang["Q2_6564"] = "Bring the Damp Note to Je'neu Sancrea at Zoram'gar Outpost."
Lang["Q1_6565"] = "Allegiance to the Old Gods"
Lang["Q2_6565"] = "Kill Lorgus Jett in Blackfathom Deeps and then return to Je'neu Sancrea."
Lang["Q1_6626"] = "A Host of Evil"
Lang["Q2_6626"] = "Kill 8 Razorfen Battleguard, 8 Razorfen Thornweavers, and 8 Death's Head Cultists; return to Myriam Moonsinger."
Lang["Q1_6921"] = "Amongst the Ruins"
Lang["Q2_6921"] = "Bring the Fathom Core to Je'neu Sancrea at Zoram'gar Outpost."
Lang["Q1_6981"] = "The Glowing Shard"
Lang["Q2_6981"] = "Travel to Ratchet to find someone that can tell you more about the glowing shard."
Lang["Q1_7028"] = "Twisted Evils"
Lang["Q2_7028"] = "Collect 15 Theradric Crystal Carvings for Willow in Desolace."
Lang["Q1_7029"] = "Vyletongue Corruption"
Lang["Q2_7029"] = "Heal 8 Vylestem Vines using the Coated Cerulean Vial, then return to Vark Battlescar in Shadowprey Village."
Lang["Q1_7041"] = "Vyletongue Corruption"
Lang["Q2_7041"] = "Heal 8 Vylestem Vines using the Coated Cerulean Vial, then return to Talendria in Nijel's Point."
Lang["Q1_7044"] = "Legends of Maraudon"
Lang["Q2_7044"] = "Recover the Celebrian Rod and Celebrian Diamond, then find a way to speak with Celebras."
Lang["Q1_7046"] = "The Scepter of Celebras"
Lang["Q2_7046"] = "Assist Celebras the Redeemed while he creates the Scepter of Celebras."
Lang["Q1_7064"] = "Corruption of Earth and Seed"
Lang["Q2_7064"] = "Slay Princess Theradras and return to Selendra near Shadowprey Village."
Lang["Q1_7065"] = "Corruption of Earth and Seed"
Lang["Q2_7065"] = "Slay Princess Theradras and return to Keeper Marandis at Nijel's Point."
Lang["Q1_7066"] = "Seed of Life"
Lang["Q2_7066"] = "Seek out Remulos in Moonglade and give him the Seed of Life."
Lang["Q1_7067"] = "The Pariah's Instructions"
Lang["Q2_7067"] = "Read the Pariah's Instructions, obtain the Amulet of Union from Maraudon, and return it to the Centaur Pariah."
Lang["Q1_7068"] = "Shadowshard Fragments"
Lang["Q2_7068"] = "Collect 10 Shadowshard Fragments from Maraudon and return them to Uthel'nay in Orgrimmar."
Lang["Q1_7070"] = "Shadowshard Fragments"
Lang["Q2_7070"] = "Collect 10 Shadowshard Fragments from Maraudon and return them to Archmage Tervosh in Theramore."
Lang["Q1_7441"] = "Pusillin and the Elder Azj'Tordin"
Lang["Q2_7441"] = "Travel to Dire Maul and locate the Imp Pusillin. Convince him to give you Azj'Tordin's Book of Incantations."
Lang["Q1_7461"] = "The Madness Within"
Lang["Q2_7461"] = "You must destroy the guardians surrounding the 5 Force Field Pylons that power Immol'thar's prison. Once the Field pylons have powered down, destroy Immol'thar, then confront Prince Tortheldrin."
Lang["Q1_7462"] = "The Treasure of the Shen'dralar"
Lang["Q2_7462"] = "Return to the Athenaeum and claim your treasure from the Treasure of the Shen'dralar. Speak with Shen'dralar Ancient for more information."
Lang["Q1_7481"] = "Elven Legends"
Lang["Q2_7481"] = "Search Dire Maul for Kariel Winthalus and report to Sage Korolusk at Camp Mojache."
Lang["Q1_7482"] = "Elven Legends"
Lang["Q2_7482"] = "Search Dire Maul for Kariel Winthalus and report to Scholar Runethorn at Feathermoon."
Lang["Q1_7488"] = "Lethtendris's Web"
Lang["Q2_7488"] = "Bring Lethtendris's Web to Latronicus Moonspear at Feathermoon Stronghold."
Lang["Q1_7489"] = "Lethtendris's Web"
Lang["Q2_7489"] = "Bring Lethtendris's Web to Talo Thornhoof at Camp Mojache."
Lang["Q1_7492"] = "Camp Mojache"
Lang["Q2_7492"] = "Speak with Talo Thornhoof at Camp Mojache in Feralas."
Lang["Q1_7494"] = "Feathermoon Stronghold"
Lang["Q2_7494"] = "Speak with Latronicus Moonspear at the Feathermoon Stronghold in Feralas."
Lang["Q1_92401"] = "A Frightened Request"
Lang["Q2_92401"] = "Investigate the disappearance of Edward Heartweaver in the Ruins of Lordaeron."
Lang["Q1_92415"] = "Remember That I Love You"
Lang["Q2_92415"] = "Bring the Blood-Stained Letter to Orphan Matron Nightingale in Stormwind City."
Lang["Q1_92421"] = "Light's Justice"
Lang["Q2_92421"] = "Collect 25 Intact Limbs within The Ruins of Lordaeron for Morbin Lightbane in the Undercity."
Lang["Q1_92422"] = "The Wrath of Rath'mael"
Lang["Q2_92422"] = "Kill Rath'mael in the Ruins of Lordaeron for Deathguard Kristof in Brill."
Lang["Q1_95189"] = "Crest of Lordaeron"
Lang["Q2_95189"] = "Return the Crest of Lordaeron to Lady Dena Kennedy in Stormwind City."
Lang["Q1_95195"] = "Bloodied Insignia"
Lang["Q2_95195"] = "Collect 10 Bloodied Insignias and take them to General Marcus Jonathan in Stormwind City."
Lang["Q1_95204"] = "Crest of Lordaeron"
Lang["Q2_95204"] = "Bring the Crest of Lordaeron to Oran Snakewrithe in Undercity."
Lang["Q1_95216"] = "The New Plague"
Lang["Q2_95216"] = "Collect the Highly Toxic Strain from Witherfang in Ruins of Lordaeron for Theodore Griffs in Undercity."
Lang["Q1_95250"] = "Abominable Creatures"
Lang["Q2_95250"] = "Collect the Head of the Baron in the Ruins of Lordaeron and bring it back to Captain Truman."
Lang["Q1_96393"] = "Old Ironforge Incursion"
Lang["Q2_96393"] = "Enter the Hall of Thanes beneath Old Ironforge and claim the Head of Durgen Dirgehammer. Deliver it to King Magni Bronzebeard."
Lang["Q1_96394"] = "The Restless Dead"
Lang["Q2_96394"] = "Kill 15 Enraged Apparitions and 10 Tormented Souls in the Hall of Thanes."
Lang["Q1_96395"] = "An Ancient Grudge"
Lang["Q2_96395"] = "Put the spirit of Faldrim Anvilmar to rest in the Hall of Thanes."
Lang["Q1_96403"] = "Important Heirlooms"
Lang["Q2_96403"] = "Collect 8 Dwarven Heirlooms from the Hall of Thanes."
Lang["Q1_98423"] = "The Treaty of Understanding"
Lang["Q2_98423"] = "Interact with the Treaty of Understanding tablet in a Reliquary of Kings vault, then deliver it to King Magni Bronzebeard in Ironforge."
Lang["Q1_97288"] = "Unending Torment"
Lang["Q2_97288"] = "Deliver the Abominable Head to someone within the Undercity."





-- NPC
Lang["N1_9196"] = "Highlord Omokk"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9196
Lang["N2_9196"] = "Highlord Omokk is the first boss that will be encountered in Lower Blackrock Spire."
Lang["N1_9237"] = "War Master Voone"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9237
Lang["N2_9237"] = "War Master Voone is a mini-boss that will be encountered in Lower Blackrock Spire."
Lang["N1_9568"] = "Overlord Wyrmthalak"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9568
Lang["N2_9568"] = "Overlord Wyrmthalak is the last boss that will be encountered in Lower Blackrock Spire."
Lang["N1_10429"] = "Warchief Rend Blackhand"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10429
Lang["N2_10429"] = "Warchief Rend Blackhand is the sixth boss that you will encounter in Upper Blackrock Spire. Dal'rend, commonly referred to as Rend, was the ruler of the Dark Horde and the largest threat to Thrall."
Lang["N1_10182"] = "Rexxar"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10182
Lang["N2_10182"] = "<Champion of the Horde>\n\nPaths from south Stonetalon Mountains all the way down to North Feralas."
Lang["N1_8197"] = "Chronalis"	-- https://www.thegeekcrusade-serveur.com/db/?npc=8197
Lang["N2_8197"] = "Chronalis of the Bronze Dragonflight.\n\nLocated at the entrance of the Caverns of Time."
Lang["N1_10664"] = "Scryer"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10664
Lang["N2_10664"] = "Scryer of the Blue Dragonflight.\n\nLocated at the bottom of the Mazthoril cave."
Lang["N1_12900"] = "Somnus"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12900
Lang["N2_12900"] = "Somnus of the Green Dragonflight.\n\nLocated on the eastern side of the Sunken Temple."
Lang["N1_12899"] = "Axtroz"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12899
Lang["N2_12899"] = "Axtroz of the Red Dragonflight.\n\nLocated in Grim Batol, Wetlands."
Lang["N1_10363"] = "General Drakkisath"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10363
Lang["N2_10363"] = "General Drakkisath is the last boss that you will encounter in Upper Blackrock Spire."
Lang["N1_8983"] = "Golem Lord Argelmach"	-- https://www.thegeekcrusade-serveur.com/db/?npc=8983
Lang["N2_8983"] = "Golem Lord Argelmach is the ninth boss that you will encounter in Blackrock Depths."
Lang["N1_9033"] = "General Angerforge"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9033
Lang["N2_9033"] = "General Angerforge is the seventh boss that you will encounter in Blackrock Depths."
Lang["N1_17804"] = "Squire Rowe"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17804
Lang["N2_17804"] = "Located at the Stormwind gates."
Lang["N1_10929"] = "Haleh"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10929
Lang["N2_10929"] = "Stands on top of the Mazthoril cave, outside.\nCan be reached via the blue rune on the floor deep inside the cave."
Lang["N1_9046"] = "Scarshield Quartermaster"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9046
Lang["N2_9046"] = "Located outside the instance, in a little alcove near the balcony entrance of Upper Blackrock Spire"
Lang["N1_15180"] = "Baristolth of the Shifting Sands"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15180
Lang["N2_15180"] = "Baristolth of the Shifting Sands is located at Cenarion Hold in Silithus (49.6,36.6)."
Lang["N1_12017"] = "Broodlord Lashlayer"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12017
Lang["N2_12017"] = "Broodlord Lashlayer is the third boss in Blackwing Lair."
Lang["N1_13020"] = "Vaelastrasz the Corrupt"	-- https://www.thegeekcrusade-serveur.com/db/?npc=13020
Lang["N2_13020"] = "Vaelastrasz the Corrupt is the second boss in Blackwing Lair."
Lang["N1_11583"] = "Nefarian"	-- https://www.thegeekcrusade-serveur.com/db/?npc=11583
Lang["N2_11583"] = "Nefarian is the eighth and final boss of Blackwing Lair."
Lang["N1_15362"] = "Malfurion Stormrage"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15362
Lang["N2_15362"] = "He can be found in The Temple of Atal'Hakkar, and spawns once you approach the Shade of Eranikus."
Lang["N1_15624"] = "Forest Wisp"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15624
Lang["N2_15624"] = "This wisp can be found on Teldrassil, not far from the gates of Darnassus, at (37.6,48.0)."
Lang["N1_15481"] = "Spirit of Azuregos"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15481
Lang["N2_15481"] = "The spirit of Azuregos pats the southern part of Azshara, around (58.8,82.2). He likes to chat."
Lang["N1_11811"] = "Narain Soothfancy"	-- https://www.thegeekcrusade-serveur.com/db/?npc=11811
Lang["N2_11811"] = "Located in a little hut north of Steamwheedle Port (65.2,18.4)."
Lang["N1_15526"] = "Meridith the Mermaiden"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15526
Lang["N2_15526"] = "She pats the underwater area before the big trench, around (59.6,95.6). Once you complete her quest, go see her again and she will give you a swim speed buff."
Lang["N1_15554"] = "Number Two"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15554
Lang["N2_15554"] = "Number Two can be summoned in Winterspring, at a specific site (67.2,72.6). He can take a bit of time to spawn."
Lang["N1_15552"] = "Doctor Weavil"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15552
Lang["N2_15552"] = "This evil gnome can be found on Alcaz Island in Dustwallow Marsh (77.8,17.6). He is stunning!"
Lang["N1_10184"] = "Onyxia"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10184
Lang["N2_10184"] = "When she is not being a Lady in Stormwind, Onyxia resides in her Lair, south of Dustwallow Marsh."
Lang["N1_11502"] = "Ragnaros"	-- https://www.thegeekcrusade-serveur.com/db/?npc=11502
Lang["N2_11502"] = "Ragnaros, the Firelord, is the tenth and final boss of Molten Core. By Fire be Purged!"
Lang["N1_12803"] = "Lord Lakmaeran"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12803
Lang["N2_12803"] = "Located on the Isle of Dread in Feralas, just a bit north of the Chimaera area entrance (29.8,72.6)."
Lang["N1_15571"] = "Maws"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15571
Lang["N2_15571"] = "duunnn dunnn... duuuunnnn duun... duuunnnnnnnn dun dun dun dun dun dun dun dun dun dun dunnnnnnnnnnn dunnnn in Azshara at (65.6,54.6)"
Lang["N1_22037"] = "Smith Gorlunk"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22037
Lang["N2_22037"] = "Located at the forge obviously (67,36), on the northern side of the Black Temple building"
Lang["N1_18733"] = "Fel Reaver"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18733
Lang["N2_18733"] = "Tends to roams the western side of Hellfire Citadel."
Lang["N1_18473"] = "Talon King Ikiss"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18473
Lang["N2_18473"] = "Talon King Ikiss is the last boss of Sethekk Halls in Auchindoun"
Lang["N1_20142"] = "Steward of Time"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20142
Lang["N2_20142"] = "Bronze dragon, near the hourglass in the Caverns of Time."
Lang["N1_20130"] = "Andormu"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20130
Lang["N2_20130"] = "Looks like a little boy, near the hourglass in the Caverns of Time."
Lang["N1_18096"] = "Epoch Hunter"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18096
Lang["N2_18096"] = "Last boss of Caverns of Time: Old Hillsbrad Foothills, spawns in Tarren Mill when Thrall gets there."
Lang["N1_19880"] = "Nether-Stalker Khay'ji"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19880
Lang["N2_19880"] = "He stands next to the forge in Area 52 (32,64)"
Lang["N1_19641"] = "Warp-Raider Nesaad"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19641
Lang["N2_19641"] = "He is located at (28,79). Has 2 adds with him"
Lang["N1_18481"] = "A'dal"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18481
Lang["N2_18481"] = "A'dal is located in the middle of Shattrath City. Big yellow shiny thingy. Can't miss it, really."
Lang["N1_19220"] = "Pathaleon the Calculator"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19220
Lang["N2_19220"] = "Pathaleon the Calculator is the last boss of the Mechanar."
Lang["N1_17977"] = "Warp Splinter"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17977
Lang["N2_17977"] = "Warp Splinter is the fifth boss in The Botanica. He is a large tree elemental."
Lang["N1_17613"] = "Archmage Alturus"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17613
Lang["N2_17613"] = "Stands in front of the entrance of Karazhan."
Lang["N1_18708"] = "Murmur"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18708
Lang["N2_18708"] = "Murmur is the final boss of the Shadow Labyrinth. He is a large wind elemental."
Lang["N1_17797"] = "Hydromancer Thespia"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17797
Lang["N2_17797"] = "Hydromancer Thespia is the first boss of The Steamvault in Coilfang Reservoir."
Lang["N1_20870"] = "Zereketh the Unbound"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20870
Lang["N2_20870"] = "Zereketh the Unbound is the first boss found in The Arcatraz."
Lang["N1_15608"] = "Medhivh"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15608
Lang["N2_15608"] = "Medivh is near the portal, in the south part of the Black Morass."
Lang["N1_16524"] = "Shade of Aran"	-- https://www.thegeekcrusade-serveur.com/db/?npc=16524
Lang["N2_16524"] = "The crazy father of Medhivh, in Karazhan"
Lang["N1_16807"] = "Grand Warlock Nethekurse"	-- https://www.thegeekcrusade-serveur.com/db/?npc=16807
Lang["N2_16807"] = "Grand Warlock Nethekurse is a Fel Orc warlock and first boss in the Shattered Halls."
Lang["N1_18472"] = "Darkweaver Syth"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18472
Lang["N2_18472"] = "Darkweaver Syth is the first boss found in Sethekk Halls."
Lang["N1_22421"] = "Skar'this the Heretic"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22421
Lang["N2_22421"] = "Skar'this is only present in the HEROIC mode of Slave Pens. He is located shortly after the first boss. When you jump down into the pool of water and come out, he is on the left hand side in a cage."
Lang["N1_19044"] = "Gruul the Dragonkiller"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19044
Lang["N2_19044"] = "Gruul the Dragonkiller is the final boss of the raid dungeon Gruul's Lair in Blade's Edge Mountains."
Lang["N1_17225"] = "Nightbane"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17225
Lang["N2_17225"] = "Nightbane is a summonable Dragon boss in Karazhan. Check out his attunement for more info."
Lang["N1_21938"] = "Earthmender Splinthoof"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21938
Lang["N2_21938"] = "Earthmender Splinthoof is inside the small building on the highest point of Shadowmoon Village (28.6,26.6)."
Lang["N1_21183"] = "Oronok Torn-heart"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21183
Lang["N2_21183"] = "Oronok Torn-heart is on top of the hill at a place called Oronok's Farm (53.8,23.4), in between Coilskar Point and the Altar of Sha'tar."
Lang["N1_21291"] = "Grom'tor, Son of Oronok"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21291
Lang["N2_21291"] = "Located in Coilskar Point (44.6,23.6)."
Lang["N1_21292"] = "Ar'tor, Son of Oronok"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21292
Lang["N2_21292"] = "Located at Illidari Point (29.6,50.4), suspended in the air by red beams."
Lang["N1_21293"] = "Borak, Son of Oronok"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21293
Lang["N2_21293"] = "Located just north of Eclipse Point (47.6,57.2)."
Lang["N1_18166"] = "Khadgar"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18166
Lang["N2_18166"] = "He stands in the centre of Shattrath City, just next to A'dal, the big yellow shiny thingy."
Lang["N1_16808"] = "Kargath Bladefist"	-- https://www.thegeekcrusade-serveur.com/db/?npc=16808
Lang["N2_16808"] = "Warchief Kargath Bladefist is the final boss of the Shattered Halls. Spoiler alert, he has blades for fists."
Lang["N1_17798"] = "Warlord Kalithresh"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17798
Lang["N2_17798"] = "Warlord Kalithresh is the third and last boss of The Steamvault in Coilfang Reservoir."
Lang["N1_20912"] = "Harbinger Skyriss"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20912
Lang["N2_20912"] = "Harbinger Skyriss is the fifth and final boss of a multi-wave encounter in The Arcatraz."
Lang["N1_20977"] = "Millhouse Manastorm"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20977
Lang["N2_20977"] = "Millhouse Manastorm is a gnome mage found in the Harbinger Skyriss encounter in The Arcratraz. He will assist in attacking the other creatures released from the prisons."
Lang["N1_17257"] = "Magtheridon"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17257
Lang["N2_17257"] = "Magtheridon is being held prisonner under Hellfire Citadel, in the raid instance called Magtheridon's Lair."
Lang["N1_21937"] = "Earthmender Sophurus"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21937
Lang["N2_21937"] = "Earthmender Sophurus stands outside the inn at Wildhammer Stronghold (36.4,56.8)."
Lang["N1_19935"] = "Soridormi"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19935
Lang["N2_19935"] = "Soridormi wanders around the big hourglass inside the Caverns of Time."
Lang["N1_19622"] = "Kael'thas Sunstrider"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19622
Lang["N2_19622"] = "Kael'thas Sunstrider is the fourth and final boss of the raid instance the Eye."
Lang["N1_21212"] = "Lady Vashj"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21212
Lang["N2_21212"] = "Lady Vashj is the final encounter of the raid instance Serpentshrine Cavern in Coilfang Reservoir."
Lang["N1_21402"] = "Anchorite Ceyla"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21402
Lang["N2_21402"] = "Anchorite Ceyla is at the Altar of Shatar (62.6,28.4)."
Lang["N1_21955"] = "Arcanist Thelis"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21955
Lang["N2_21955"] = "Arcanist Thelis is inside the Sanctum of the Stars (56.2,59.6)"
Lang["N1_21962"] = "Seer Udalo"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21962
Lang["N2_21962"] = "He's lying dead on the small ramp before the last boss fight of The Arcatraz."
Lang["N1_22006"] = "Shadowlord Deathwail"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22006
Lang["N2_22006"] = "He's riding a dragon on the northern tower of the Black Temple (71.6,35.6) "
Lang["N1_22820"] = "Seer Olum"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22820
Lang["N2_22820"] = "Seer Olum is located in Serpentshrine Cavern, behind Fathom-Lord Karathress."
Lang["N1_21700"] = "Akama"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21700
Lang["N2_21700"] = "Akama is located at the Warden's Cage (58.0,48.2)."
Lang["N1_19514"] = "Al'ar"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19514
Lang["N2_19514"] = "Al'ar is the first boss of The Eye. He's a big fiery bird thing."
Lang["N1_17767"] = "Rage Winterchill"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17767
Lang["N2_17767"] = "Rage Winterchill is the first boss in the Mount Hyjal raid instance."
Lang["N1_18528"] = "Xi'ri"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18528
Lang["N2_18528"] = "Xi'ri is located at the entrance of the Black Temple. Big blue shiny thingy. Can't miss it either, really."
--v243
Lang["N1_22497"] = "V'eru"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22497
Lang["N2_22497"] = "V'eru is in the same room as A'dal, but he's blue. He's on the top landing."
--v244
Lang["N1_22113"] = "Mordenai"
Lang["N2_22113"] = "A Blood Elf (spoiler alert, actually a dragon) who walks the Netherwing Fields just east of the Sanctum of the Stars"
--v247
Lang["N1_8888"]  = "Franclorn Forgewright"
Lang["N2_8888"]  = "A ghost dwarf, standing on his own tomb OUTSIDE the dungeon, in the structure suspended above the lava. You can only interact with him if you are DEAD."
Lang["N1_9056"]  = "Fineous Darkvire"
Lang["N2_9056"]  = "He is INSIDE the dungeon, and patrols the quarry area outside of Lord Incendius' chamber."
Lang["N1_10837"] = "High Executor Derrington"
Lang["N2_10837"] = "He can be found at the Bulwark, near the border of Tirisfal and Western Plaguelands"
Lang["N1_10838"] = "Commander Ashlam Valorfist"
Lang["N2_10838"] = "He can be found at Chillwind Camp, just south of Andorhal in the Western Plaguelands"
Lang["N1_1852"]  = "Araj the Summoner"
Lang["N2_1852"]  = "The Lich, in the middle of Andorhal"
--v250
Lang["N1_13278"]  = "Duke Hydraxis"
Lang["N2_13278"]  = "A large Water Elemental on a tiny faraway island in Azshara (79.2,73.6)"
Lang["N1_12264"]  = "Shazzrah"
Lang["N2_12264"]  = "Shazzrah is the fifth boss of Molten Core."
Lang["N1_12118"]  = "Lucifron"
Lang["N2_12118"]  = "Lucifron is the first boss of Molten Core."
Lang["N1_12259"]  = "Gehennas"
Lang["N2_12259"]  = "Gehennas is the third boss of Molten Core."
Lang["N1_12098"]  = "Sulfuron Harbinger"
Lang["N2_12098"]  = "Sulfuron Harbinger, herald of Ragnaros, is the eighth boss of the Molten Core."


Lang["N1_"]  = ""
Lang["N2_"]  = ""



Lang["O_1"] = "Click Drakkisath's Brand to complete the quest.\nIt's a glowing orb located behind General Drakkisath."
Lang["O_2"] = "It's a tiny glowing red dot on the ground\nin front of the gates of Ahn'Qiraj (28.7,89.2)."
--v247
Lang["O_3"] = "The shrine is located at the end of a corridor\nthat starts from the upper level of the Ring of Law."

-- Post-SM dungeon item/npc/location expansions
Lang["I_10454"] = "Essence of Eranikus"
Lang["I_10465"] = "Egg of Hakkar"
Lang["I_10662"] = "Filled Egg of Hakkar"
Lang["I_12402"] = "Ancient Egg"
Lang["I_6175"] = "Atal'ai Artifact"
Lang["I_6181"] = "Fetish of Hakkar"
Lang["I_9321"] = "Venom Bottle"
Lang["I_9322"] = "Undamaged Venom Sac"
Lang["I_10660"] = "First Mosh'aru Tablet"
Lang["I_10661"] = "Second Mosh'aru Tablet"
Lang["I_11230"] = "Encased Fiery Essence"
Lang["I_11268"] = "Head of Argelmach"
Lang["I_11309"] = "The Heart of the Mountain"
Lang["I_11312"] = "Lost Thunderbrew Recipe"
Lang["I_11313"] = "Ribbly's Head"
Lang["I_11468"] = "Dark Iron Fanny Pack"
Lang["I_13172"] = "Grimm's Premium Tobacco"
Lang["I_13174"] = "Plagued Flesh Sample"
Lang["I_13176"] = "Scourge Data"
Lang["I_13180"] = "Stratholme Holy Water"
Lang["I_13250"] = "Head of Balnazzar"
Lang["I_13207"] = "Head of Baron Rivendare"
Lang["I_13471"] = "The Deed to Brill"
Lang["I_13626"] = "Human Head of Ras Frostwhisper"
Lang["I_13725"] = "Krastinov's Bag of Horrors"
Lang["I_14679"] = "Of Love and Family"
Lang["I_18240"] = "Azj'Tordin's Book of Incantations"
Lang["I_18261"] = "Book of Incantations"
Lang["I_18426"] = "Lethtendris's Web"
Lang["I_18501"] = "Felvine Shard"
Lang["I_4631"] = "Tablet of Ryun'eh"
Lang["I_5824"] = "Tablet of Will"
Lang["I_6188"] = "Fetish of Hakkar"
Lang["I_6212"] = "Head of Jammal'an"
Lang["I_6288"] = "Atal'ai Tablet"
Lang["I_7669"] = "Shattered Necklace Ruby"
Lang["I_7670"] = "Shattered Necklace Sapphire"
Lang["I_7671"] = "Shattered Necklace Topaz"
Lang["I_7672"] = "Shattered Necklace Power Source"
Lang["I_7740"] = "Shattered Necklace"
Lang["I_4635"] = "Hammertoe's Amulet"
Lang["I_8009"] = "Dentrium Power Stone"
Lang["I_8026"] = "Garrett Family Treasure"
Lang["I_8027"] = "Krom Stoutarm's Treasure"
Lang["I_8047"] = "Magenta Fungus Cap"
Lang["I_8052"] = "An'Alleum Power Stone"
Lang["I_8548"] = "Divino-matic Rod"
Lang["I_8707"] = "Gahz'rilla's Electrified Scale"
Lang["I_9234"] = "Tiara of the Deep"
Lang["I_9238"] = "Uncracked Scarab Shell"
Lang["I_9471"] = "Nekrum's Medallion"
Lang["I_9523"] = "Troll Temper"
Lang["N1_10439"] = "Baron Rivendare"
Lang["N2_10439"] = "Baron Rivendare is the final boss of Stratholme Undead."
Lang["N1_10503"] = "Jandice Barov"
Lang["N2_10503"] = "Jandice Barov is a Scholomance boss who drops Krastinov's Bag of Horrors."
Lang["N1_10506"] = "Kirtonos the Herald"
Lang["N2_10506"] = "Kirtonos the Herald is summoned on the Scholomance porch with the Blood of Innocents."
Lang["N1_10508"] = "Ras Frostwhisper"
Lang["N2_10508"] = "Ras Frostwhisper is a lich boss in Scholomance."
Lang["N1_10811"] = "Archivist Galford"
Lang["N2_10811"] = "Archivist Galford is in the Scarlet Bastion wing of Stratholme."
Lang["N1_11261"] = "Doctor Theolen Krastinov"
Lang["N2_11261"] = "Doctor Theolen Krastinov, the Butcher, is a Scholomance boss."
Lang["N1_11486"] = "Prince Tortheldrin"
Lang["N2_11486"] = "Prince Tortheldrin is the final boss of Dire Maul West, in the Athenaeum."
Lang["N1_11496"] = "Immol'thar"
Lang["N2_11496"] = "Immol'thar is imprisoned in Dire Maul West and must be freed by destroying the pylons."
Lang["N1_14327"] = "Lethtendris"
Lang["N2_14327"] = "Lethtendris is a Dire Maul East boss who drops Lethtendris's Web."
Lang["N1_2748"] = "Archaedas"
Lang["N2_2748"] = "Archaedas is the final boss of Uldaman."
Lang["N1_5710"] = "Jammal'an the Prophet"
Lang["N2_5710"] = "Jammal'an the Prophet is a boss in the Temple of Atal'Hakkar."
Lang["N1_7272"] = "Theka the Martyr"
Lang["N2_7272"] = "Theka the Martyr is a Zul'Farrak boss who drops the First Mosh'aru Tablet."
Lang["N1_7273"] = "Gahz'rilla"
Lang["N2_7273"] = "Gahz'rilla is summoned at the pool in Zul'Farrak with the Mallet of Zul'Farrak."
Lang["N1_7795"] = "Hydromancer Velratha"
Lang["N2_7795"] = "Hydromancer Velratha patrols near Gahz'rilla's pool in Zul'Farrak."
Lang["N1_7797"] = "Nekrum Gutchewer"
Lang["N2_7797"] = "Nekrum Gutchewer appears during the Zul'Farrak pyramid stairs event."
Lang["N1_9016"] = "Bael'Gar"
Lang["N2_9016"] = "Bael'Gar is a giant magma elemental boss in Blackrock Depths."
Lang["N1_9017"] = "Lord Incendius"
Lang["N2_9017"] = "Lord Incendius is a fire elemental boss near the Black Anvil in Blackrock Depths."
Lang["N1_9019"] = "Emperor Dagran Thaurissan"
Lang["N2_9019"] = "Emperor Dagran Thaurissan is the final boss of Blackrock Depths."
Lang["N1_9543"] = "Ribbly Screwspigot"
Lang["N2_9543"] = "Ribbly Screwspigot is found in the Grim Guzzler in Blackrock Depths."
Lang["Loch Modan"] = "Loch Modan"
Lang["The Hinterlands"] = "The Hinterlands"
Lang["Giant"] = "Giant"
Lang["Beast"] = "Beast"
Lang["I_11269"] = "Intact Elemental Core"

-- New Forever dungeons and Blackrock Spire quests
Lang["Q1_4701"] = "Put Her Down"
Lang["Q2_4701"] = "Slay Halycon, the worg pack mistress in Lower Blackrock Spire, then return to Helendis Riverhorn."
Lang["Q1_4724"] = "The Pack Mistress"
Lang["Q2_4724"] = "Slay Halycon, pack mistress of the Bloodaxe worg, then return to Galamav the Marksman."
Lang["Q1_4729"] = "Kibler's Exotic Pets"
Lang["Q2_4729"] = "Capture a Bloodaxe Worg Pup in Lower Blackrock Spire and bring the Caged Worg Pup to Kibler."
Lang["Q1_4734"] = "Egg Freezing"
Lang["Q2_4734"] = "Use the Eggscilloscope Prototype on an egg in the Rookery."
Lang["Q1_4735"] = "Egg Collection"
Lang["Q2_4735"] = "Bring 8 Collected Dragon Eggs and the Collectronic Module to Tinkee Steamboil."
Lang["Q1_4742"] = "Seal of Ascension"
Lang["Q2_4742"] = "Bring Vaelan the Gemstones of Smolderthorn, Spirestone, and Bloodaxe, along with the Unadorned Seal of Ascension."
Lang["Q1_4743"] = "Seal of Ascension"
Lang["Q2_4743"] = "Break Emberstrife in Dustwallow Marsh and temper the Unforged Seal of Ascension in the flames of the black dragonflight."
Lang["Q1_4764"] = "Doomrigger's Clasp"
Lang["Q2_4764"] = "Bring Doomrigger's Clasp to Mayara Brightwing in the Burning Steppes."
Lang["Q1_4766"] = "Mayara Brightwing"
Lang["Q2_4766"] = "Speak with Mayara Brightwing in the Burning Steppes."
Lang["Q1_4768"] = "The Darkstone Tablet"
Lang["Q2_4768"] = "Bring the Darkstone Tablet to Shadowmage Vivian Lagrave in Kargath."
Lang["Q1_4769"] = "Vivian Lagrave and the Darkstone Tablet"
Lang["Q2_4769"] = "Speak with Shadowmage Vivian Lagrave."
Lang["Q1_4788"] = "The Final Tablets"
Lang["Q2_4788"] = "Bring the Fifth and Sixth Mosh'aru Tablets to Prospector Ironboot in Tanaris."
Lang["Q1_4862"] = "En-Ay-Es-Tee-Why"
Lang["Q2_4862"] = "Collect 15 Spire Spider Eggs in Lower Blackrock Spire for Kibler."
Lang["Q1_4866"] = "Mother's Milk"
Lang["Q2_4866"] = "Get Mother Smolderweb to poison you, then return to Ragged John so he can milk the venom."
Lang["Q1_4867"] = "Urok Doomhowl"
Lang["Q2_4867"] = "Read Warosh's Scroll, defeat Urok Doomhowl, and bring Warosh's Mojo to Warosh."
Lang["Q1_4981"] = "Operative Bijou"
Lang["Q2_4981"] = "Travel to Lower Blackrock Spire and find out what happened to Bijou."
Lang["Q1_4982"] = "Bijou's Belongings"
Lang["Q2_4982"] = "Find Bijou's Belongings on the bottom floor of the city and return them to her."
Lang["Q1_4983"] = "Bijou's Reconnaissance Report"
Lang["Q2_4983"] = "Take Bijou's reconnaissance report back to Lexlort in Kargath."
Lang["Q1_5001"] = "Bijou's Belongings"
Lang["Q2_5001"] = "Find Bijou's Belongings and return them to her."
Lang["Q1_5002"] = "Message to Maxwell"
Lang["Q2_5002"] = "Take Bijou's Information to Marshal Maxwell in the Burning Steppes."
Lang["Q1_5047"] = "Finkle Einhorn, At Your Service!"
Lang["Q2_5047"] = "Talk to Malyfous Darkhammer in Everlook."
Lang["Q1_5081"] = "Maxwell's Mission"
Lang["Q2_5081"] = "Destroy War Master Voone, Highlord Omokk, and Overlord Wyrmthalak, then return to Marshal Maxwell."
Lang["Q1_5089"] = "General Drakkisath's Command"
Lang["Q2_5089"] = "Take General Drakkisath's Command to Marshal Maxwell in the Burning Steppes."
Lang["Q1_5102"] = "General Drakkisath's Demise"
Lang["Q2_5102"] = "Destroy General Drakkisath in Upper Blackrock Spire, then return to Marshal Maxwell."
Lang["Q1_5160"] = "The Matron Protectorate"
Lang["Q2_5160"] = "Take Awbee's Scale to Haleh in Winterspring."
Lang["I_12263"] = "Caged Worg Pup"
Lang["I_12530"] = "Spire Spider Egg"
Lang["I_12335"] = "Gemstone of Smolderthorn"
Lang["I_12336"] = "Gemstone of Spirestone"
Lang["I_12337"] = "Gemstone of Bloodaxe"
Lang["I_12780"] = "General Drakkisath's Command"
Lang["I_12345"] = "Bijou's Belongings"
Lang["I_12352"] = "Doomrigger's Clasp"
Lang["I_12358"] = "Darkstone Tablet"
Lang["I_12712"] = "Warosh's Mojo"
Lang["I_12241"] = "Collected Dragon Egg"
Lang["I_12740"] = "Fifth Mosh'aru Tablet"
Lang["I_12741"] = "Sixth Mosh'aru Tablet"
Lang["I_12923"] = "Awbee's Scale"
Lang["I_17322"] = "Eye of the Emberseer"
Lang["N1_10220"] = "Halycon"
Lang["N2_10220"] = "Halycon is the worg pack mistress in Lower Blackrock Spire, in the Hordemar City pens."
Lang["N1_10321"] = "Emberstrife"
Lang["N2_10321"] = "Emberstrife is an ancient black drake in the Wyrmbog in Dustwallow Marsh."
Lang["N1_10584"] = "Urok Doomhowl"
Lang["N2_10584"] = "Urok Doomhowl is summoned in Lower Blackrock Spire with Warosh's Scroll."
Lang["N1_10596"] = "Mother Smolderweb"
Lang["N2_10596"] = "Mother Smolderweb guards the Skitterweb tunnels in Lower Blackrock Spire."
Lang["N1_9816"] = "Pyroguard Emberseer"
Lang["N2_9816"] = "Pyroguard Emberseer is imprisoned in Upper Blackrock Spire and must be freed before he can be killed."
Lang["N1_260322"] = "Saltspine"
Lang["N2_260322"] = "Saltspine is the first boss in the Excavation Site, a crocolisk in the Lost Marsh."
Lang["N1_260325"] = "Shadetooth"
Lang["N2_260325"] = "Shadetooth is a raptor boss in the Excavation Site."
Lang["N1_260808"] = "Highland Horror"
Lang["N2_260808"] = "Highland Horror is a bog beast boss in the Excavation Site."
Lang["N1_260326"] = "Relic Guardian"
Lang["N2_260326"] = "Relic Guardian is the final boss of the Excavation Site, a titan construct in the Site of the Guardian."

-- Excavation Site: Wetlands quests / items
Lang["Q1_275"] = "Blisters on The Land"
Lang["Q2_275"] = "Kill 8 Fen Creepers, then return to Rethiel the Greenwarden in the Wetlands."
Lang["Q1_276"] = "Tramping Paws"
Lang["Q2_276"] = "Kill 15 Mosshide Gnolls and 10 Mosshide Mongrels for Rethiel the Greenwarden in the Wetlands."
Lang["Q1_277"] = "Fire Taboo"
Lang["Q2_277"] = "Bring Rethiel the Greenwarden 9 Crude Flints."
Lang["Q1_463"] = "The Greenwarden"
Lang["Q2_463"] = "Find the Greenwarden in the Wetlands."
Lang["Q1_469"] = "Daily Delivery"
Lang["Q2_469"] = "Bring the bundle of Crocolisk Skins to James Halloran, the tanner, in Menethil Harbor."
Lang["Q1_95646"] = "Horrors in the Highland"
Lang["Q2_95646"] = "Kill a Highland Horror within Excavation Sites and bring its root core to Rethiel the Greenwarden in the Wetlands."
Lang["Q1_95647"] = "Lost in the Thicket Things"
Lang["Q2_95647"] = "Find Ardin Grassman in the Excavation Sites. Learn what happened to Ardin Grassman."
Lang["Q1_95737"] = "Seeking Caitlin"
Lang["Q2_95737"] = "Speak with Caitlin Grassman in Menethil Harbor."
Lang["Q1_95663"] = "Dragonmaw Rumors"
Lang["Q2_95663"] = "Travel to the Wetlands and meet the Deathstalker Agent in the hills above the Dragonmaw camp."
Lang["Q1_95664"] = "Elder Knowledge"
Lang["Q2_95664"] = "Take the Titan Relic to the Elder Rise in Thunder Bluff and look for someone who can tell you more about it."
Lang["Q1_95682"] = "Open the Maw"
Lang["Q2_95682"] = "Slay the Dragonmaw forces within the Excavation Site and return to the Deathstalker Agent outside with anything you recover."
Lang["Q1_95697"] = "Changing Tastes"
Lang["Q2_95697"] = "Enter the Excavation Sites in the Wetlands and bring back Thicket Raptor Meat."
Lang["Q1_95772"] = "Songblade Search"
Lang["Q2_95772"] = "Look for Dorin Songblade's brother, Daewyn, in Whelgar's Excavation Site."
Lang["Q1_95795"] = "Fallen in the Fen"
Lang["Q2_95795"] = "Report Daewyn's fate to Dorin Songblade in Lakeshire."
Lang["Q1_95809"] = "Heartwoven"
Lang["Q2_95809"] = "Take the Reed-woven Heart back to Caitlin Grassman in Menethil Harbor."
Lang["Q1_95810"] = "Lost Relic Carry"
Lang["Q2_95810"] = "Deliver the Titan Relic to Prospector Whelgar at the Wetlands excavation site."
Lang["Q1_98815"] = "Highland Hides"
Lang["Q2_98815"] = "Collect 4 Thicket Raptor Hides and take them to James Halloran in Menethil Harbor."
Lang["Q1_98823"] = "Earthen Echo"
Lang["Q2_98823"] = "Bring the Titan Relic to Muln Earthfury at the Skywatcher Plateau in northwest Mulgore."
Lang["Q1_98824"] = "Prehistoric Prism"
Lang["Q2_98824"] = "Bring the Titan Relic to High Explorer Magellas in Ironforge's Hall of Explorers."
Lang["I_270180"] = "Horrible Rootcore"
Lang["I_270866"] = "Titan Relic"
Lang["I_271100"] = "Thicket Raptor Meat"
Lang["I_284844"] = "Dragonmaw Dispatch"
Lang["I_284845"] = "Thicket Raptor Hide"

-- City of Dalaran (Horde)
Lang["Q1_544"] = "Prison Break In"
Lang["Q2_544"] = "Find the traitors and recover their artifacts, then return to Magus Voidglare in Tarren Mill."
Lang["Q1_545"] = "Dalaran Patrols"
Lang["Q2_545"] = "Kill 6 Dalaran Summoners and 12 Elemental Slaves, then return to Magus Voidglare in Tarren Mill."
Lang["Q1_93680"] = "Key to the City"
Lang["Q2_93680"] = "Acquire the Grimy Key for Magus Wordeen Voidglare in Tarren Mill."
Lang["Q1_92434"] = "Blood in the Streets"
Lang["Q2_92434"] = "Find a way into Dalaran along the Lordamere Lake."
Lang["Q1_96984"] = "Heart of Disruption"
Lang["Q2_96984"] = "Collect the Arcane Mote in the City of Dalaran for Magus Wordeen Voidglare in Tarren Mill."
Lang["Q1_96986"] = "The Grave Knight"
Lang["Q2_96986"] = "Defeat Atrexis the Grave Knight in the City of Dalaran for Melisara in Tarren Mill."
Lang["Q1_96987"] = "Opportunistic Education"
Lang["Q2_96987"] = "Collect the Founding of Dalaran from the City of Dalaran for Rexxie Copperclutch near the sewer entrance."
Lang["Q1_96988"] = "Source of Power"
Lang["Q2_96988"] = "Collect 6 Cracked Sentry Cores in the City of Dalaran for Doctor Martin Felben in Undercity."
Lang["I_279469"] = "Grimy Key"
Lang["I_251961"] = "Arcane Mote"
Lang["I_275997"] = "Cracked Sentry Core"
Lang["I_275996"] = "The Founding of Dalaran"
Lang["N1_247126"] = "Atrexis the Grave Knight"
Lang["N2_247126"] = "Atrexis the Grave Knight is a necromancer in the underbelly of the City of Dalaran."

-- City of Dalaran (Alliance)
Lang["Q1_92456"] = "A Green Sample"
Lang["Q2_92456"] = "Collect a Fel Infused Blossom from the City of Dalaran for Shylamiir in Stormwind City."
Lang["Q1_92489"] = "Power Overwhelming"
Lang["Q2_92489"] = "Slay the Mana Elemental in the City of Dalaran for High Sorcerer Andromath in Stormwind City."
Lang["Q1_92432"] = "An Alarming Request"
Lang["Q2_92432"] = "Report to the Image of Archmage Modera near the City of Dalaran."
Lang["Q1_92458"] = "Heart of Disruption"
Lang["Q2_92458"] = "Collect the Arcane Mote for the Image of Archmage Modera near the City of Dalaran."
Lang["I_251983"] = "Fel Infused Blossom"
Lang["N1_246016"] = "Arcanic Enigma"
Lang["N2_246016"] = "Arcanic Enigma is a mana elemental in the City of Dalaran."

-- Cozy Sleeping Bag
Lang["Q1_79007"] = "... and that note you found"
Lang["Q2_79007"] = "Travel to 46, 73 in The Barrens. Interact with the Burned-Out Remains and accept the quest.\n\nTurn it in at 37, 50 in Westfall by interacting with the Nailed Plank. Accept Stepping Stones from that plank before you leave."
Lang["Q1_79008"] = "... and that note you found"
Lang["Q2_79008"] = "Travel to 37, 50 in Westfall. Interact with the Burned-Out Remains beside the Nailed Plank and accept the quest.\n\nTurn it in at 46, 73 in The Barrens at the Burned-Out Remains, then interact with the Nailed Plank there and accept Stepping Stones."
Lang["Q1_79192"] = "Stepping Stones"
Lang["Q2_79192"] = "Horde accepts this from the Nailed Plank at 37, 50 in Westfall. Alliance accepts it from the Nailed Plank at 46, 73 in The Barrens.\n\nTravel to 51, 51 in Stonetalon Mountains. From the road, follow the opening into the mountains and follow the path until you reach the camp. Interact with the Pocket Litter (40.8, 52.5)."
Lang["Q1_79980"] = "Scramble"
Lang["Q2_79980"] = "At the Stonetalon camp, interact with the Pocket Litter (40.8, 52.5) to accept this quest.\n\nRun through the camp and jump down the mountains to the ledge with the Mound of Dirt (39.6, 49.9), then interact with it."
Lang["Q1_79974"] = "Wet Job"
Lang["Q2_79974"] = "Interact with the Mound of Dirt in Stonetalon Mountains (39.6, 49.9) to accept this quest.\n\nTravel to the dam at 49, 12 in Loch Modan. Jump down to the ledge and interact with the Carved Figurine (49.5, 12.8)."
Lang["Q1_79975"] = "Eagle's Fist"
Lang["Q2_79975"] = "Interact with the Carved Figurine at the Loch Modan dam (49.5, 12.8) to accept this quest.\n\nTravel to 81, 56 in Hillsbrad Foothills. While facing the gate toward Arathi Highlands, turn left and follow the wall until you reach the fallen cart. Follow the jumping puzzle toward the camp, then interact with the Messenger Bag (Arathi Highlands 22.4, 24.2)."
Lang["Q1_79976"] = "This Must Be The Place"
Lang["Q2_79976"] = "Interact with the Messenger Bag, then interact with the Hastily Rolled-Up Satchel directly beneath it to receive the Cozy Sleeping Bag."
