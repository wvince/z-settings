-------------------------------------------------------------------------
--
--	Copyright (c) 2019-2021 by Antoine Desmarets.
--	Cixi Delmont/Gaya Greyhoof of Wow Forever Horde
--
--	Attune is distributed in the hope that it will be useful/entertaining
--	but WITHOUT ANY WARRANTY. Use at your own risk.
--
-------------------------------------------------------------------------
--
-- 16001-26
--   - Fixed an issue with displaying City of Dalaran
--   - Added the Dire Maul quests
--  
-- 16001-25
--   - Added City of Dalaran quests
--   - Added Lazy Sleeping Bag quests
--
-- 16001-24
--   - Added Excavation Site: Wetlands quests
--   - Fixed an issue where Attune was interfering with the treeview in other addons
--
-- 16001-23
--   - Added Placeholders for upcoming dungeons
--   - Changed step colors for quests and items: yellow if you have the quest or some of the required items, green is you have all the required items or have completed the quest, grey otherwise
--   - Added Zul'Farrak quests
--   - Added The Temple of Atal'Hakkar quests
--   - if you are not at the minimum level for a quest, the quest level text will show in red
--
-- 16001-22
--   - Added option to use full map in quest details
--   - Added missing Wailing Caverns quests for Alliance
--   - Added dungeon art as background
--   - Added level range for dungeons
--
-- 16001-21
--   - Click a quest to list its reward items and map of the quest giver. Click it again to go back to the treeview
--   - Attune now uses the Forever frame
--
-- 16001-20
--   - Added quest giver in tooltip and map display
--   - Changed default to not announce completion in guild chat
--
-- 16001-19
--  Updated dungeons up to Maraudon
--



-------------------------------------------------------------------------
-- ADDON VARIABLES
-------------------------------------------------------------------------

local addonName, addon = ...

local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local GetNumAddOns = C_AddOns.GetNumAddOns or GetNumAddOns
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded or IsAddOnLoaded;
local IsAddOnLoadOnDemand = C_AddOns.IsAddOnLoadOnDemand or IsAddOnLoadOnDemand;
local GetAddOnInfo = C_AddOns.GetAddOnInfo or GetAddOnInfo
local GetAddOnDependencies = C_AddOns.GetAddOnDependencies or GetAddOnDependencies
local GetItemCount = C_Item.GetItemCount or GetItemCount
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo

-- Forever / Midnight use C_Reputation; Classic still has GetFactionInfoByID.
local function Attune_GetFactionInfoByID(factionID)
	factionID = tonumber(factionID)
	if not factionID then return nil end
	if C_Reputation and C_Reputation.GetFactionDataByID then
		local data = C_Reputation.GetFactionDataByID(factionID)
		if not data then return nil end
		-- Match legacy GetFactionInfoByID return positions used by this addon (name @1, earned @6).
		return data.name, data.description, data.reaction, data.currentReactionThreshold, data.nextReactionThreshold, data.currentStanding
	end
	if GetFactionInfoByID then
		return GetFactionInfoByID(factionID)
	end
end

-- Midnight (12.0+) and Forever/Camelot (1.60.x / Interface 16001) forbid CLEU registration.
local attunelocal_interfaceVersion = select(4, GetBuildInfo())
local attunelocal_hasCombatLog = not (
	attunelocal_interfaceVersion >= 120000
	or (attunelocal_interfaceVersion >= 16000 and attunelocal_interfaceVersion < 20000)
)

Attune = LibStub("AceAddon-3.0"):NewAddon("Attune", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0")
Attune_Data = {};							-- Attunements / steps / tooltips

AttuneLang = LibStub("AceLocale-3.0"):GetLocale("Attune")

local AceGUI = LibStub("AceGUI-3.0")

-- Style Attune's own TreeGroup only (never patch shared AceGUI:Create).
local function Attune_StyleTreeGroup(widget)
	if widget.treeframe then
		widget.treeframe:SetBackdropColor(0, 0, 0, 0.5)
	end
	if widget.border then
		widget.border:SetBackdropColor(0, 0, 0, 0.5)
	end
	-- 20% wider than AceGUI's 175px default; keep resizable (second arg) so the drag handle stays enabled.
	widget:SetTreeWidth(210)
end

local _G = getfenv(0)

local attunelocal_ldb = LibStub("LibDataBroker-1.1")
local Attune_Broker = nil
local attunelocal_minimapicon = LibStub("LibDBIcon-1.0")
local attunelocal_brokervalue = nil
local attunelocal_brokerlabel = nil
local attunelocal_settingsCategoryID = nil

local attunelocal_version = tostring(GetAddOnMetadata(addonName, "Version"))
local attunelocal_prefix = "Attune_Channel"			-- used for addon chat communications
local attunelocal_versionprefix = "Attune_Version"	-- used for addon version check
local attunelocal_syncprefix = "Attune_Sync"		-- used for addon version check
local attunelocal_detectedNewer = false;			-- flag to only warn about new version once per session

-- Defaults for Node size
local attunelocal_Node_Width = 170
local attunelocal_Node_Height = 48
local attunelocal_Node_HGap = 10

-- HALFSIZE steps occupy half a column (layout slot and drawn width).
local function Attune_NodeWidth(step)
	if step and step.HALFSIZE then
		return (attunelocal_Node_Width - attunelocal_Node_HGap) / 2
	end
	return attunelocal_Node_Width
end

local attunelocal_Node_VGap = 30
local attunelocal_Icon_Size = 32
local attunelocal_Line_Thickness = 6
local attunelocal_Side_Pad = 10			-- padding inside the Inside-quests box
local attunelocal_Side_VGap = 8			-- vertical gap between stacked Inside quests
local attunelocal_Side_BoxGap = 28		-- horizontal gap between box edge and End (for side connector)

-- Graph zoom (SetScale on the chain container)
local attunelocal_Zoom_Min = 0.5
local attunelocal_Zoom_Max = 1.0
local attunelocal_Zoom_Step = 0.01

-- Frame variables
local attunelocal_frame						-- main frame
local attunelocal_tree = {}					-- tree data (nodes and leaves)
local attunelocal_treeframe					-- Ace TreeGroup object for attune tab
local attunelocal_guildframe				-- Ace SimpleGroup object for result tab
local attunelocal_treeIsShown = false		-- indicates whether we're on the tree view or result view
local attunelocal_right						-- right panel of the TreeGroup object
local attunelocal_scroll					-- scroller inside of the TreeGroup right panel
local attunelocal_dungeonArt				-- loading-screen art behind the dungeon view
local attunelocal_gscroll					-- scroller inside the SimpleGroup of the result tab
local attunelocal_glist						-- individual rows of data inside the result tab
local attunelocal_export_frame				-- export submenu frame
local attunelocal_survey_frame				-- survey submenu frame
local attunelocal_resultselection = 1 		-- indicates whether to show last survey results(0) or guild results(1) or all(2)
local attunelocal_exportselection = 0 		-- indicates what dataset to export 0:me, 1:last survey, 2:guild, 3:all, 4:all my alts
local attunelocal_gflabel					-- table header (used to update the number of characters in list)
local attunelocal_showResultAttunes = true 	-- profiles UI disabled; keep true to always show attune results
local attunelocal_graphRoot					-- container for attune chain nodes (scaled for zoom)
local attunelocal_graphHeight = 0			-- unscaled chain height (for live zoom scroll updates)
local attunelocal_contentHeight = 50		-- scroll content height accounting for zoom
local attunelocal_graphHeaderOffset = 10    -- fixed (unscaled) px below AceGUI title/desc before graph
local attunelocal_zoomSlider				-- fixed overlay zoom slider (not inside scroll)
local attunelocal_graphPanX = 0				-- horizontal pan offset (parent coords)
local attunelocal_graphMaxExtent = 0		-- unscaled half-width of widest stage
local attunelocal_graphMaxPanX = 0			-- max |panX| allowed at current zoom/view
local attunelocal_graphDragging = false		-- true while click-dragging the chain
local attunelocal_graphDragLastX = 0
local attunelocal_graphDragLastY = 0
local attunelocal_graphPanHooked = false	-- Shift+wheel hook installed on scrollframe
local attunelocal_wipFrame					-- centered "work in progress" overlay for empty trees

--local attunelocal_repWidget					-- Reputation Widget frame
--local attunelocal_repWidget_frames = {} 	-- list of non-Ace frames for the rep widget (to reuse them later)

local attunelocal_syncProgressWidget		-- Sync Progress Widget
local attunelocal_syncProgressStatusBar		-- actual progress bar
local attunelocal_syncProgress_frames = {} 	-- list of non-Ace frames for the sync progess widget (to reuse them later)
local attunelocal_syncStartTime = nil		-- to calculate sync duration
local attunelocal_syncAmountToReceive = 0	-- Total amount we're due to receive
local attunelocal_syncAmountReceived = 0	-- amount we've received so far
local attunelocal_syncAmountToSend = 0		-- Total amount we're due to send
local attunelocal_syncAmountSent = 0		-- amount we've sent so far
local attunelocal_syncChunksSent = 0		-- chunks sent so far

local attunelocal_frames = {} 				-- list of non-Ace frames (to reuse them later)
local attunelocal_initial = true			-- first run

local attunelocal_myguild = ""				-- Guild of the current character
-- local attunelocal_realm = GetRealmName()	-- Realm of the current character

local guildToonMap = {}						-- matching guild to toon

local attunelocal_data = {}					-- data being exported to website
local attunelocal_count = 0					-- count of toons being exported

local attunelocal_myFirst = "FirstName"
local attunelocal_myLast = "LastName"
local attunelocal_myFullName = attunelocal_myFirst .. " " .. attunelocal_myLast
local attunelocal_charKey = attunelocal_myFullName --.. "-" .. attunelocal_realm			-- Character unique name
local attunelocal_statusText = AttuneLang["Version"]:gsub("##VERSION##", attunelocal_version)		-- Default status text

local attunelocal_refreshDone = false		-- flag to indicate when the UI refresh has been done, to avoid doing it too many times and freezing UI)

local attunelocal_syncTarget = nil
local attunelocal_syncStatus = -1

--[=[ Raid Planner locals disabled for now
local attunelocal_raidframe						-- main frame
local attunelocal_raidtree = {}					-- tree data (nodes and leaves)
local attunelocal_raidtreeframe					-- Ace TreeGroup object for attune tab
local attunelocal_raidscroll					-- scroller inside of the raid
local attunelocal_raidroster					-- scroller inside the raid SimpleGroup of the result tab
--local attunelocal_raidtoonIcon = {}				-- Icon object of the toon list
local attunelocal_raidspotIcon = {}				-- Icon object of the raid spots
]=]
local attunelocal_faction = ""
--[=[ Raid Planner locals disabled for now
local attunelocal_raidname = ""					-- selected Raid name
local attunelocal_raidsize = 0					-- selected Raid size
local attunelocal_raidcount = 1  				-- selected raid, number of raid groups to show
]=]

local attunelocal_inactivity = 60*60*24*30		-- number of seconds to account for inactivity

--local attunelocal_achieveDelayDone = false		-- Wait a few seconds to avoid the barrage of achieves when one first logs in

local patch = 0

-- This is to work around the fact that xpcall is quite costly and drops framerate when spammed for lots of little events
-- Thanks @RoadBlock for this
-- On Forever/Midnight, CLEU is forbidden; PARTY_KILL / UNIT_DIED replace kill detection.
local cleu_parser = CreateFrame("Frame")
cleu_parser.OnEvent = function(frame, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		Attune.COMBAT_LOG_EVENT_UNFILTERED(Attune, event, ...)
	elseif event == "PARTY_KILL" then
		Attune:PARTY_KILL(...)
	elseif event == "UNIT_DIED" then
		Attune:UNIT_DIED_KILL(...)
	end
end
cleu_parser:SetScript("OnEvent", cleu_parser.OnEvent)
-- End of xpcall workaround


local IsQuestFlaggedCompleted = _G.IsQuestFlaggedCompleted or C_QuestLog.IsQuestFlaggedCompleted  -- This is to handle the changes in TBC (C_QuestLog)


local attune_options = {
    name = "Attune",
    handler = Attune,
    type = "group",
	childGroups = "tab",
    args = {
        tab1 = {
            type = "group",
            name = AttuneLang["Settings"],
			width = "full",
			order = 1,
			args = {

				spacer1 = {
					type = "description",
					name = " ",
					width = "full",
					order = 2,
				},
				showMinimapButton = {
					type = "toggle",
					name = AttuneLang["MinimapButton_TEXT"],
					desc = AttuneLang["MinimapButton_DESC"],
					get = function(info) return not Attune_DB.minimapbuttonpos.hide end,
					set = function(info, val)
							if val then attunelocal_minimapicon:Show("Attune_Broker") else attunelocal_minimapicon:Hide("Attune_Broker") end
							Attune_DB.minimapbuttonpos.hide = not val
						end,
					width = 2.5,
					order = 5,
				},
				autosurvey = {
					type = "toggle",
					name = AttuneLang["AutoSurvey_TEXT"],
					desc = AttuneLang["AutoSurvey_DESC"],
					get = function(info) return Attune_DB.autosurvey end,
					set = function(info, val) Attune_DB.autosurvey = val end,
					width = 2.5,
					order = 6,
				},
				useFullMap = {
					type = "toggle",
					name = AttuneLang["FullMap_TEXT"],
					desc = AttuneLang["FullMap_DESC"],
					get = function(info) return Attune_DB.useFullMap end,
					set = function(info, val)
						Attune_DB.useFullMap = val
						if Attune_RefreshQuestMapMode then Attune_RefreshQuestMapMode() end
					end,
					width = 2.5,
					order = 7,
				},
				showSurveyed = {
					type = "toggle",
					name = AttuneLang["ShowSurveyed_TEXT"],
					desc = AttuneLang["ShowSurveyed_DESC"],
					get = function(info) return Attune_DB.showSurveyed end,
					set = function(info, val) Attune_DB.showSurveyed = val end,
					width = 1.65,
					order = 15,
				},
				showResponses = {
					type = "toggle",
					name = AttuneLang["ShowResponses_TEXT"],
					desc = AttuneLang["ShowResponses_DESC"],
					get = function(info) return Attune_DB.showResponses end,
					set = function(info, val) Attune_DB.showResponses = val end,
					width = 1.65,
					order = 16,
				},
				showStepReached = {
					type = "toggle",
					name = AttuneLang["ShowSetMessages_TEXT"],
					desc = AttuneLang["ShowSetMessages_DESC"],
					get = function(info) return Attune_DB.showStepReached end,
					set = function(info, val) Attune_DB.showStepReached = val end,
					width = 1.65,
					order = 17,
				},
				announceAttuneCompleted = {
					type = "toggle",
					name = AttuneLang["AnnounceToGuild_TEXT"],
					desc = AttuneLang["AnnounceToGuild_DESC"],
					get = function(info) return Attune_DB.announceAttuneCompleted end,
					set = function(info, val) Attune_DB.announceAttuneCompleted = val end,
					width = 1.65,
					order = 18,
				},
				showOtherChat = {
					type = "toggle",
					name = AttuneLang["ShowOther_TEXT"],
					desc = AttuneLang["ShowOther_DESC"],
					get = function(info) return Attune_DB.showOtherChat end,
					set = function(info, val) Attune_DB.showOtherChat = val end,
					width = 1.65,
					order = 19,
				},
--[[				announceAchieveCompleted = {
					type = "toggle",
					name = AttuneLang["AnnounceAchieve_TEXT"],
					desc = AttuneLang["AnnounceAchieve_DESC"],
					get = function(info) return Attune_DB.toons[attunelocal_charKey].announceAchieveCompleted end,
					set = function(info, val) Attune_DB.toons[attunelocal_charKey].announceAchieveCompleted = val end,
					width = 2.6,
					order = 20,
				},				
				achieveMinPoints = {
					type = "select",
					name = "",
					desc = "",
					values = {	
						[10] = "10 Points", 
						[20] = "20 Points",
						[25] = "25 Points",
						[30] = "30 Points",
						[40] = "40 Points",
						[50] = "50 Points",
						[60] = "60 Points",
						[70] = "70 Points",
						[80] = "80 Points",
						[90] = "90 Points",
						[100] = "100 Points",
					},
					get = function(info) return Attune_DB.toons[attunelocal_charKey].achieveMinPoints end,
					set = function(info, val) Attune_DB.toons[attunelocal_charKey].achieveMinPoints = val end,
					width = 0.7,
					order = 21,
				},
]]--
				showList = {
					type = "toggle",
					name = AttuneLang["ShowGuildies_TEXT"],
					desc = AttuneLang["ShowGuildies_DESC"],
					get = function(info) return Attune_DB.showList end,
					set = function(info, val) Attune_DB.showList = val end,
					width = 2.8,
					order = 23,
				},
				maxListSize = {
					type = "input",
					name = "",
					desc = "",
					get = function(info) return Attune_DB.maxListSize end,
					set = function(info, val) Attune_DB.maxListSize = val end,
					width = 0.5,
					order = 24,
				},
				-- showListAlt = {
				-- 	type = "toggle",
				-- 	name = AttuneLang["ShowAltsInstead_TEXT"],
				-- 	desc = AttuneLang["ShowAltsInstead_DESC"],
				-- 	get = function(info) return Attune_DB.showListAlt end,
				-- 	set = function(info, val) Attune_DB.showListAlt = val end,
				-- 	width = 2.5,
				-- 	order = 26,
				-- },
				-- showDeprecatedAttunes = {
				-- 	type = "toggle",
				-- 	name = AttuneLang["showDeprecatedAttunes_TEXT"],
				-- 	desc = AttuneLang["showDeprecatedAttunes_DESC"],
				-- 	get = function(info) return Attune_DB.showDeprecatedAttunes end,
				-- 	set = function(info, val) Attune_DB.showDeprecatedAttunes = val; 	Attune_LoadTree(); 	Attune_ForceAttuneTabRefresh() end,
				-- 	width = 2.5,
				-- 	order = 27,
				-- },
				websiteUrl = {
					type = "input",
					name = "Database Website URL",
					desc = "URL of a World of Warcraft database website",
					get = function(info) return Attune_DB.websiteUrl end,
					set = function(info, val) Attune_DB.websiteUrl = val end,
					width = "full",
					order = 28,
				},
				spacer3 = {
					type = "description",
					name = " ",
					width = "full",
					order = 30,
				},
				spacer4 = {
					type = "description",
					name = " ",
					width = "full",
					order = 40,
				},
				deleteAll = {
					type = "execute",
					name = AttuneLang["ClearAll_TEXT"],
					desc = AttuneLang["ClearAll_DESC"],
					confirm = true,
					confirmText = AttuneLang["ClearAll_CONF"],
					func = function(info, val)
						for kt, t in pairs(Attune_DB.toons) do
							if kt ~= attunelocal_charKey then
								Attune_DB.toons[kt] = nil
							end
						end
						if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["ClearAll_TEXT"]) end
					end,
					width = 1.6,
					order = 32,
				},
				deleteGuild = {
					type = "execute",
					name = AttuneLang["DelNonGuildies_TEXT"],
					desc = AttuneLang["DelNonGuildies_DESC"],
					confirm = true,
					confirmText = AttuneLang["DelNonGuildies_CONF"],
					func = function(info, val)
						for kt, t in pairs(Attune_DB.toons) do
							if kt ~= attunelocal_charKey then
								if t.guild ~= nil then
									if t.guild ~= attunelocal_myguild then
										Attune_DB.toons[kt] = nil
									end
								end
							end
						end
						if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["DelNonGuildies_DONE"]) end
					end,
					width = 1.6,
					order = 33,
				},

	--[[
				spacer5 = {
					type = "description",
					name = " ",
					width = "full",
					order = 40,
				},
	]]

				credits = {
					type = "description",
					name = AttuneLang["Credits"],
					width = "full",
					fontSize = "medium",
					order = 45,
				},
  --[[				showWidget = {
					type = "toggle",
					name = "Show Reputation Widget",
					desc = "Displays a reputation tracking window, allowing you to check your attunement reputation gains and progress.",
					get = function(info) return Attune_DB.repWidget.showWidget end,
					set = function(info, val) Attune_DB.repWidget.showWidget = val;
						if attunelocal_repWidget ~= nil then
							if val then attunelocal_repWidget:Show()
							else attunelocal_repWidget:Hide()
							end
						end
					end,
					width = 1.7,
					order = 41,
				},
				lockWidget = {
					type = "toggle",
					name = "Lock Reputation Widget",
					desc = "Lock the reputation widget in place, preventing its movement and hiding usage information.",
					get = function(info) return Attune_DB.repWidget.lockWidget end,
					set = function(info, val) Attune_DB.repWidget.lockWidget = val
						if attunelocal_repWidget ~= nil then
							print("in")
							if val then
								attunelocal_repWidget:SetMovable(false)
								print("NOT movable")
							else
								attunelocal_repWidget:SetMovable(true)
								print("movable")
							end
						end
					end,
					width = 1.7,
					order = 42,
				},
  ]]
			},
		},

        tab2 = {
            type = "group",
            name = AttuneLang["Survey Log"],
			width = "full",
			order = 100,
			args = {
				logs = {
					type = "description",
					name = "",
					width = "full",
					order = 110,
				},
			},
		},
	},
}

-------------------------------------------------------------------------
-- EVENT: Addon is Initialized
-------------------------------------------------------------------------

function Attune:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Attune", attune_options, nil)
	-- Second return is the Settings category ID (numeric on modern clients).
	local _, categoryID = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Attune")
	attunelocal_settingsCategoryID = categoryID
end

-------------------------------------------------------------------------
-- EVENT: Addon is enabled
-------------------------------------------------------------------------

function Attune:OnEnable()
	-- Called when the addon is enabled
	C_ChatInfo.RegisterAddonMessagePrefix(attunelocal_prefix)
	C_ChatInfo.RegisterAddonMessagePrefix(attunelocal_versionprefix)
    --	C_ChatInfo.RegisterAddonMessagePrefix(attunelocal_syncprefix)


	Attune:RegisterComm(attunelocal_syncprefix)

	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("QUEST_ACCEPTED")
	self:RegisterEvent("QUEST_TURNED_IN")
	self:RegisterEvent("UPDATE_FACTION")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_DETAIL")
--	self:RegisterEvent("ACHIEVEMENT_EARNED")

    attunelocal_myFirst, attunelocal_myLast = UnitName("player")
    attunelocal_myFullName = attunelocal_myFirst .. " " .. attunelocal_myLast
    attunelocal_charKey = attunelocal_myFullName --.. "-" .. attunelocal_realm			-- Character unique name
    
	--self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	if attunelocal_hasCombatLog then
		cleu_parser:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		-- Forever / Midnight: CLEU registration is ADDON_ACTION_FORBIDDEN
		cleu_parser:RegisterEvent("PARTY_KILL")
		cleu_parser:RegisterEvent("UNIT_DIED")
	end

	_, _, _, patch	 = GetBuildInfo()
	
	if Attune_DB == nil then Attune_DB = {} end
	if Attune_DB.width == nil then Attune_DB.width = 1200 end
	if Attune_DB.height == nil then Attune_DB.height = 720 end
	if Attune_DB.zoom == nil then Attune_DB.zoom = 1.0 end	-- proportional scale of the attune chain (0.5–1.0)
	if Attune_DB.zoom < attunelocal_Zoom_Min then Attune_DB.zoom = attunelocal_Zoom_Min end
	if Attune_DB.zoom > attunelocal_Zoom_Max then Attune_DB.zoom = attunelocal_Zoom_Max end
	if Attune_DB.toons == nil then Attune_DB.toons = {} end
	if Attune_DB.toons[attunelocal_charKey] == nil then Attune_DB.toons[attunelocal_charKey] = {} end
	if Attune_DB.survey == nil then Attune_DB.survey = {} end
	if Attune_DB.sortresult == nil then Attune_DB.sortresult = { 0, true } end -- sort order for the result tab (attune, asc/desc)  (0 for name)
	if Attune_DB.showList == nil then Attune_DB.showList = true end
	if Attune_DB.showListAlt == nil then Attune_DB.showListAlt = false end
	if Attune_DB.showSurveyed == nil then Attune_DB.showSurveyed = false end
	if Attune_DB.showResponses == nil then Attune_DB.showResponses = true end
	if Attune_DB.showStepReached == nil then Attune_DB.showStepReached = true end
	if Attune_DB.announceAttuneCompleted == nil then Attune_DB.announceAttuneCompleted = false end
	if Attune_DB.showDeprecatedAttunes == nil then Attune_DB.showDeprecatedAttunes = true end
		
	
--[[	--convert global setting to a per toon setting
	local oldAnnounceAchieveCompleted = true
	if Attune_DB.announceAchieveCompleted ~= nil then oldAnnounceAchieveCompleted = Attune_DB.announceAchieveCompleted;  end --get previous setting
	if Attune_DB.toons[attunelocal_charKey].announceAchieveCompleted == nil then Attune_DB.toons[attunelocal_charKey].announceAchieveCompleted = oldAnnounceAchieveCompleted end

	local oldAchieveMinPoints = 20
	if Attune_DB.achieveMinPoints ~= nil then oldAchieveMinPoints = Attune_DB.achieveMinPoints  end  --get previous setting
	if Attune_DB.toons[attunelocal_charKey].achieveMinPoints == nil then Attune_DB.toons[attunelocal_charKey].achieveMinPoints = oldAchieveMinPoints end

	local oldAnnounceAchieveSurvey = false
	if Attune_DB.announceAchieveSurvey ~= nil then oldAnnounceAchieveSurvey = Attune_DB.announceAchieveSurvey  end  --get previous setting
	if Attune_DB.toons[attunelocal_charKey].announceAchieveSurvey == nil then Attune_DB.toons[attunelocal_charKey].announceAchieveSurvey = oldAnnounceAchieveSurvey end
]]
	
	if Attune_DB.showOtherChat == nil then Attune_DB.showOtherChat = true end
	if Attune_DB.maxListSize == nil then Attune_DB.maxListSize = "20" end
	if Attune_DB.logs == nil then Attune_DB.logs = {} end
	if Attune_DB.minimapbuttonpos == nil then Attune_DB.minimapbuttonpos = {} end
	if Attune_DB.minimapbuttonpos.hide == nil then Attune_DB.minimapbuttonpos.hide = false end
	if Attune_DB.autosurvey == nil then Attune_DB.autosurvey = false end
	if Attune_DB.useFullMap == nil then Attune_DB.useFullMap = false end
	if Attune_DB.websiteUrl == nil then Attune_DB.websiteUrl = "https://wowhead.com/forever" end
	if TreeExpandStatus == nil then TreeExpandStatus = {} end
	
	

	--[=[ Raid planner disabled for now
	--raid planner
	if Attune_DB.raidShowMains == nil then Attune_DB.raidShowMains = true end
	if Attune_DB.raidShowAlts == nil then Attune_DB.raidShowAlts = false end
	if Attune_DB.raidShowUnattuned == nil then Attune_DB.raidShowUnattuned = false end
	if Attune_DB.raidShowUnspecified == nil then Attune_DB.raidShowUnspecified = false end
	if Attune_DB.raidGuildOnly == nil then Attune_DB.raidGuildOnly = true end
	
	if Attune_DB.raidPlans == nil then Attune_DB.raidPlans = {} end
	if Attune_DB.raidNames == nil then Attune_DB.raidNames = {} end
	attunelocal_faction = UnitFactionGroup("player")
	if Attune_DB.raidPlans[attunelocal_faction] == nil then Attune_DB.raidPlans[attunelocal_faction] = {} end
	if Attune_DB.raidNames[attunelocal_faction] == nil then Attune_DB.raidNames[attunelocal_faction] = {} end
	if Attune_DB.raidSelection == nil then Attune_DB.raidSelection = {} end
	if Attune_DB.raidSelection[attunelocal_faction] == nil then Attune_DB.raidSelection[attunelocal_faction] = 115 end
	]=]
	attunelocal_faction = UnitFactionGroup("player")
	--[[	local gameLocale = GetLocale()
		if gameLocale == "enGB" then
			gameLocale = "enUS"
		end
		if Attune_DB.preferredLocale == nil then Attune_DB.preferredLocale = gameLocale end
	
	if (Attune_DB.repWidget == nil) then Attune_DB.repWidget = {}; end
	if (Attune_DB.repWidget.showWidget == nil) then Attune_DB.repWidget.showWidget = false; end
	if (Attune_DB.repWidget.lockWidget == nil) then Attune_DB.repWidget.lockWidget = false; end
	if (Attune_DB.repWidget.showInRaid == nil) then Attune_DB.repWidget.showInRaid = true; end
	if (Attune_DB.repWidget.showInDungeon == nil) then Attune_DB.repWidget.showInDungeon = true; end
	if (Attune_DB.repWidget.showInWorld == nil) then Attune_DB.repWidget.showInWorld = true; end
	if (Attune_DB.repWidget.showInBg == nil) then Attune_DB.repWidget.showInBg = true; end
	if (Attune_DB.repWidget.point == nil) then Attune_DB.repWidget.point = nil; end
]]

	if Attune_DB.showOtherChat then DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[Attune]|r "..AttuneLang["Splash"]:gsub("##VERSION##", attunelocal_version)) end


	-- add new fields to toons data
	for kt, t in pairs(Attune_DB.toons) do
		if t.status == nil then t.status = "None" end
		if t.role == nil then t.role = "None" end
		if t.survey == nil then t.survey = 0 end
		if t.guild == nil then t.guild = "" end
		if t.class == nil then t.class = "UNKNOWN" end
		if t.attuned == nil then t.attuned = {} end
		if t.done == nil then t.done = {} end
		for i, a in pairs(Attune_Data.noattunes) do
			--mark as automatically attuned for those raids that do not require attunement
			if t.attuned[a.ID] == nil then t.attuned[a.ID] = 100 end
		end
		for i, a in pairs(Attune_Data.attunes) do
			if t.attuned[a.ID] == nil then t.attuned[a.ID] = 0 end
		end


--[[	-- NOW REMOVED as it was clearing alt status

		-- tentative fix for SSC
		-- attune was granted on error (picking up quest instead of turning in)
		t.attuned["120"] = 0		-- removing completion status
		t.done["120-60"] = nil		-- removing kill and item
		t.done["120-70"] = nil		-- removing kill and item
		t.done["120-80"] = nil		-- removing kill and item
		t.done["120-90"] = nil		-- removing kill and item
		t.done["120-110"] = nil		-- removing 'end' step
		t.done["120-100"] = nil		-- removing bad step (mark of vashj)
		t.done["120-95"] = nil		-- removing quest turn in step  --  this should re-complete itself automatically if the player has done it
]]
	end 

	Attune_UpdateLogs()
	
	--this is per character as it could cause problems with alliance vs horde last viewed (ex if last viewed is Honor Hold)
	-- Default: first dungeon for this faction (Alliance → Hall of Thanes, Horde → Ragefire Chasm)
	if AttuneLastViewed == nil then
		local defaultAttune = Attune_Data.attunes[1]
		for _, a in ipairs(Attune_Data.attunes) do
			if a.GROUP == AttuneLang['DUNGEONS'] and (a.FACTION == attunelocal_faction or a.FACTION == "Both") then
				defaultAttune = a
				break
			end
		end
		AttuneLastViewed = defaultAttune.EXPAC.."\001"..defaultAttune.GROUP.."\001"..defaultAttune.ID
	end

	Attune_CheckProgress() -- get your own standing
	Attune:BAG_UPDATE(nil)


	-- calculate how many steps this toon has done on the attune
	local attuneDone = {}
	local t = Attune_DB.toons[attunelocal_charKey]
	Attune_AutoCompleteSpacers(attunelocal_charKey)
	local spacerDone = {}
	for _, s in pairs(Attune_Data.steps) do
		if s.TYPE == "Spacer" then spacerDone[s.ID_ATTUNE .. "-" .. s.ID] = true end
	end
	local attuneSteps = {}
	for i, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE ~= "Spacer" then
				if attuneSteps[s.ID_ATTUNE] == nil then attuneSteps[s.ID_ATTUNE] = 0 end
				attuneSteps[s.ID_ATTUNE] = attuneSteps[s.ID_ATTUNE] +1
			end
		end
	end
	for i, d in pairs(t.done) do
		if not spacerDone[i] then
			local Ids = Attune_split(i, "-")
			if attuneDone[Ids[1]] == nil then attuneDone[Ids[1]] = 0 end
			attuneDone[Ids[1]] = attuneDone[Ids[1]] +1
		end
	end
	if t.attuned == nil then t.attuned = {} end
	for i, a in pairs(Attune_Data.attunes) do
		if attuneDone[a.ID] == nil then attuneDone[a.ID] = 0 end
		if (attuneSteps[a.ID] or 0) > 0 then
			t.attuned[a.ID] = math.floor(100*(attuneDone[a.ID]/attuneSteps[a.ID]))
		else
			t.attuned[a.ID] = 0
		end

	end
	-- End step done means fully attuned (Kill/Interact may lag behind in the done map)
	Attune_ApplyCompletedEndSteps(t)



	-- sending a couple version checks to make sure people update to the latest version
	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then
		C_Timer.After(11, function()
			if attunelocal_myguild ~= "" then Attune:SendCommMessage(attunelocal_versionprefix, attunelocal_version, "GUILD", ""); end
		end)
	end

	C_Timer.After(11, function()
		Attune:SendCommMessage(attunelocal_versionprefix, attunelocal_version, "YELL", "");
	end)

--[[	C_Timer.After(15, function()
		attunelocal_achieveDelayDone = true -- after 10s the spam should have been done
	end)
]]
	-- sending a couple version checks to make sure people update to the latest version

	if Attune_DB.autosurvey then
		C_Timer.After(13, function()
			if attunelocal_myguild ~= "" then 
				if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["StartAutoGuildSurvey"]) end
				Attune:SendCommMessage(attunelocal_prefix, "SILENTSURVEY", "GUILD", ""); 
			end
		end)
	end



	Attune_Broker = attunelocal_ldb:NewDataObject("Attune_Broker", {
		type = "data source",
		label = "Attune",
		text = "Click me!",
		icon = "Interface\\Icons\\inv_scroll_03",
		OnClick = function(self, button)
			if button=="LeftButton" then
				Attune_SlashCommandHandler("")
			elseif button=="RightButton" then
				if Settings and Settings.OpenToCategory and type(attunelocal_settingsCategoryID) == "number" then
					Settings.OpenToCategory(attunelocal_settingsCategoryID)
				elseif InterfaceOptionsFrame_OpenToCategory then
					InterfaceOptionsFrame_OpenToCategory("Attune")
					InterfaceOptionsFrame_OpenToCategory("Attune")
				else
					LibStub("AceConfigDialog-3.0"):Open("Attune")
				end
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine("|cFFffffffAttune v"..attunelocal_version.."|r")

			if 	attunelocal_brokerlabel ~= nil then
				tooltip:AddLine(" ")
				tooltip:AddLine("|cffffd100"..attunelocal_brokerlabel..":|r |cFFffffff"..attunelocal_brokervalue.."|r")
			end

			tooltip:AddLine(" ")
			tooltip:AddLine("|cffffd100"..AttuneLang["LeftClick"].."|r"..AttuneLang["OpenAttune"].."\n|cffffd100"..AttuneLang["RightClick"].."|r"..AttuneLang["OpenSettings"], 0.2, 1, 0.2)
		end,
	})





	local aid = nil
	-- Find the last selected attunement
	local st, le = string.find(AttuneLastViewed, "\001")

	if st ~= nil then -- not top level
		--get actual attune (remove expac/group)
		expac, group, sel = strsplit("\001", AttuneLastViewed);
		if sel ~= "" and sel ~= nil then
			aid = sel
		end
	end

	if aid ~= nil then
		for k, a in pairs(Attune_Data.attunes) do
			if a.ID == aid then
				attunelocal_brokerlabel = a.NAME
			end
		end
		if Attune_DB.toons[attunelocal_charKey].attuned[aid] ~= nil then
			attunelocal_brokervalue = Attune_DB.toons[attunelocal_charKey].attuned[aid].."%"
		else
			attunelocal_brokervalue = "0%"
		end
		Attune_Broker.text = attunelocal_brokervalue
	end


	attunelocal_minimapicon:Register("Attune_Broker", Attune_Broker, Attune_DB.minimapbuttonpos)
	if Attune_DB.minimapbuttonpos.hide then attunelocal_minimapicon:Hide("Attune_Broker"); attunelocal_minimapicon:Hide("Attune_Broker") else attunelocal_minimapicon:Show("Attune_Broker");attunelocal_minimapicon:Show("Attune_Broker") end


--[[
	C_Timer.After(10, function()
		if not Attune_DB.toons[attunelocal_charKey].announceAchieveSurvey then
			StaticPopupDialogs["ACHIEVEANNOUNCE_CONFIRM"] = {
				text = AttuneLang["\n"..AttuneLang["AchieveSurvey"]:gsub("##WHO##", attunelocal_myFullName).."\n\n"],
				button1 = AttuneLang["Yes"],
				button2 = AttuneLang["No"],
				timeout = 0,
				hasEditBox = false,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				OnAccept = function()
					Attune_DB.toons[attunelocal_charKey].announceAchieveSurvey = true
					Attune_DB.toons[attunelocal_charKey].announceAchieveCompleted = true
				end,
				OnCancel = function (_,reason)
					Attune_DB.toons[attunelocal_charKey].announceAchieveSurvey = true
					Attune_DB.toons[attunelocal_charKey].announceAchieveCompleted = false
				end,
			}
			StaticPopup_Show ("ACHIEVEANNOUNCE_CONFIRM")
		end
	end)
]]

	--Attune_CreateRepWidget()



	-- Remedy can be time consuming because of the recursive loop.
	-- Only perform when a new version of the addon is found
	local ind = 0
	if Attune_DB.version == nil or Attune_DB.version < attunelocal_version then 
		-- remedy IsNext
		for it, tt in pairs(Attune_DB.toons) do
			if tt.next ~= nil then 

				C_Timer.After(0.200*ind, function() --stagger those to not freeze
					--print("Checking "..it)
					for i, n in Attune_spairs(tt.next, function(t,a,b) 
							local aa = Attune_split(a, "-")
							local bb = Attune_split(b, "-")
							local aaa = aa[1]*1000 + aa[2]
							local bbb = bb[1]*1000 + bb[2]
							return (bbb < aaa) 
						end) do
						for is, ts in pairs(Attune_Data.steps) do
							if showPatchStep(ts) then
								if ts.ID_ATTUNE .. "-" .. ts.ID == i then 
									if ts.FOLLOWS ~= "0" then 

										--this is where the remediation needs to happen
										Attune_remedyIsNext(it, ts.ID_ATTUNE, ts.FOLLOWS)
										
									end
									break
								end
							end
						end
					end
				end)
				ind = ind + 1
			end
		end
		Attune_DB.version = attunelocal_version
	end

end

-------------------------------------------------------------------------
-- Remedy IsNext (some interact / kill steps remain as IsNext)
-------------------------------------------------------------------------

function Attune_remedyIsNext(who, aID, follows)

	-- there can be multi-follows (for example FOLLOW=160|170)
	-- We need to recurse both paths
	local fIDs = Attune_split(follows, "&")
	if string.find(follows, "|") then fIDs = Attune_split(follows, "|") end

	for fi, f in pairs(fIDs) do
		for i, s in pairs(Attune_Data.steps) do
			if showPatchStep(s) then
				if s.ID_ATTUNE == aID and s.ID == f then
					if string.find(follows, "|") == nil then -- don't recurse OR, as we don't know which parent was actually done
						if Attune_DB.toons[who].next[s.ID_ATTUNE .. "-" .. s.ID] == 1 then
	--						print(who..": Removed "..s.ID_ATTUNE .. "-" .. s.ID)
							Attune_DB.toons[who].next[s.ID_ATTUNE .. "-" .. s.ID] = nil
						end
						if follows ~= 0 then -- no need to recurse first level
							Attune_remedyIsNext(who, s.ID_ATTUNE, s.FOLLOWS)
						end
					end
				end
			end
		end
	end

end


-------------------------------------------------------------------------
-- EVENT: Addon is disabled
-------------------------------------------------------------------------

function Attune:OnDisable()
	-- Called when the addon is disabled
	self:Print("|cffff00ff[Attune]|r "..AttuneLang["Addon disabled"])
end


-------------------------------------------------------------------------
-- EVENT: Fired when an achievement is gained
-------------------------------------------------------------------------
--[[
function Attune:ACHIEVEMENT_EARNED(event, id)
	local FEAT_OF_STRENGTH_CATEGID = 81

	--send a guild message when an achievement is earned 
	local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then attunelocal_myguild = guildName end

	local achieveId, achieveName, achievePoints = GetAchievementInfo(id)
	local categId = GetAchievementCategory(id)
	
	if 	(achievePoints >= Attune_DB.toons[attunelocal_charKey].achieveMinPoints or categId == FEAT_OF_STRENGTH_CATEGID)
		and Attune_DB.toons[attunelocal_charKey].announceAchieveCompleted
		and attunelocal_myguild ~= ""
		and attunelocal_achieveDelayDone then 

			local msg = "[Attune] "..AttuneLang["AchieveCompleteGuild"]:gsub("##LINK##", GetAchievementLink(id))
			if categId ~= FEAT_OF_STRENGTH_CATEGID then -- don't show points for FoS
				msg = msg .. " "..AttuneLang["AchieveCompletePoints"]:gsub("##POINTS##", GetTotalAchievementPoints())
			end
			SendChatMessage(msg , "GUILD")
	end
end
]]
-------------------------------------------------------------------------
-- EVENT: Addon Chat message is received
-------------------------------------------------------------------------

function Attune:CHAT_MSG_ADDON(event, arg1, arg2, arg3, arg4)

	--attune data channel
	if arg1 == attunelocal_prefix then
		if arg2 == 'SURVEY' or arg2 == 'SILENTSURVEY' then
			attunelocal_count = 0
			attunelocal_data = {}
			attunelocal_data['_faction'] = ""
			attunelocal_data['_realm'] = ""
			attunelocal_data['_guild'] = ""

			if arg2 == 'SURVEY' and arg4 ~= attunelocal_charKey then
				if Attune_DB.showSurveyed then print("|cffff00ff[Attune]|r "..AttuneLang["SendingDataTo"]:gsub("##NAME##", Attune_split(arg4, "-")[1]))  end
			end

			-- log all surveys (silent or not) unless they were sent by us
			if arg4 ~= attunelocal_charKey then
				Attune_DB.logs[time()] = AttuneLang["ReceivedRequestFrom"]:gsub("##FROM##", arg4)
				Attune_UpdateLogs()
			end

			Attune_SendRequestResults(arg4)
		else
			Attune_HandleRequestResults(arg2)
		end
	end

	--version check channel
	if arg1 == attunelocal_versionprefix then
		if arg2 > attunelocal_version and not attunelocal_detectedNewer then
			attunelocal_detectedNewer = true
			if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["NewVersionAvailable"].." (v"..arg2..")") end -- 	ved check with a newer version, warn the user
		end
	end


end

-------------------------------------------------------------------------
-- EVENT: Detect a mob has been killed
-------------------------------------------------------------------------

local function Attune_NpcIdFromGUID(guid)
	-- Use == nil (not truthiness): secret strings error on string conversion.
	if guid == nil then return -1 end

	-- Forever/Midnight: PARTY_KILL / UNIT_DIED may pass secret GUIDs.
	-- strsplit/tostring on secrets errors under tainted execution.
	if issecretvalue and issecretvalue(guid) then
		-- UnitTokenFromGUID accepts secret GUIDs when tainted; UnitCreatureID
		-- returns a readable ID when unit identity is not restricted (e.g. open world).
		local unit = UnitTokenFromGUID and UnitTokenFromGUID(guid)
		if unit ~= nil and UnitCreatureID then
			local id = UnitCreatureID(unit)
			if id ~= nil then return id end
		end
		-- Some clients still resolve creature ID from a secret GUID.
		if C_CreatureInfo and C_CreatureInfo.GetCreatureID then
			local ok, id = pcall(C_CreatureInfo.GetCreatureID, guid)
			if ok and id ~= nil then return id end
		end
		return -1
	end

	if C_CreatureInfo and C_CreatureInfo.GetCreatureID then
		local id = C_CreatureInfo.GetCreatureID(guid)
		if id ~= nil then return id end
	end

	local _, _, _, _, _, npc_id = strsplit("-", guid)
	return tonumber(npc_id) or -1
end

-- Resolve the NPC being talked to without converting secret GUIDs to strings.
local function Attune_GetInteractNpcID()
	if UnitCreatureID then
		local id = UnitCreatureID("npc")
		if id == nil then id = UnitCreatureID("target") end
		if id ~= nil then return id end
	end

	local guid = UnitGUID("npc")
	if guid == nil then guid = UnitGUID("target") end
	if guid == nil then return -1 end
	return Attune_NpcIdFromGUID(guid)
end

local function Attune_ProcessKill(npc_id)
	if npc_id == nil or npc_id == -1 then return end
	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE == "Kill" then
				if ""..s.ID_WOWHEAD == ""..npc_id then
					-- checking that predecessors are done (meaning this step is ISNext)
					local isNext = true
					local followOR = false
					if s.FOLLOWS ~= "0" then
						local fIDs = Attune_split(s.FOLLOWS, "&")
						if string.find(s.FOLLOWS, "|") then fIDs = Attune_split(s.FOLLOWS, "|"); followOR = true end
						if followOR then
							isNext = false
							for fi, f in pairs(fIDs) do
								if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. f] then isNext = true end
							end
						else
							isNext = true
							for fi, f in pairs(fIDs) do
								if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. f] == nil then isNext = false end
							end
						end
					end

					if isNext then
						if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
							for k, a in pairs(Attune_Data.attunes) do
								if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then
									if a.ID == s.ID_ATTUNE then
										local faction = UnitFactionGroup("player")
										if a.FACTION == faction or a.FACTION == 'Both' then
											--mark step as done
											Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
											refreshNeeded = true
											PlaySound(1210) --putdownring
											-- need to refresh attune in window
											-- fetch attune name for chat message
											if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["CompletedStep"]:gsub("##TYPE##", AttuneLang[s.TYPE]):gsub("##STEP##", AttuneLang["N1_"..s.ID_WOWHEAD]):gsub("##NAME##", a.NAME)) end
											Attune_SendPushInfo("TOON")
											Attune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID)
											Attune_CheckComplete(false)
											if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] >= 100 then
												PlaySound(5275) -- AuctionWindowClose
												if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["AttuneComplete"]:gsub("##NAME##", a.NAME)) end
												if Attune_DB.announceAttuneCompleted and attunelocal_myguild ~= "" then SendChatMessage("[Attune] "..AttuneLang["AttuneCompleteGuild"]:gsub("##NAME##", a.NAME), "GUILD") end
											end
											Attune_SendPushInfo("OVER")
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed
end

function Attune:COMBAT_LOG_EVENT_UNFILTERED(event, arg1, arg2, arg3, arg4)
	local param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16 = CombatLogGetCurrentEventInfo()

	--party kill is the better option as it knows your group did the kill (your tag), but doesn't work in raid.
	--for raids, use UNIT_DIED, as since it's a raid mob your group obviously had the tag
	if (param2 == "PARTY_KILL" and not IsInRaid()) or (param2 == "UNIT_DIED" and IsInRaid()) then
		Attune_ProcessKill(Attune_NpcIdFromGUID(param8))
	end
end

-- Forever / Midnight replacements for CLEU kill detection
function Attune:PARTY_KILL(attackerGUID, targetGUID)
	if IsInRaid() then return end
	Attune_ProcessKill(Attune_NpcIdFromGUID(targetGUID))
end

function Attune:UNIT_DIED_KILL(unitGUID)
	if not IsInRaid() then return end
	Attune_ProcessKill(Attune_NpcIdFromGUID(unitGUID))
end

-------------------------------------------------------------------------
-- EVENT: Detect a level up
-------------------------------------------------------------------------

function Attune:PLAYER_LEVEL_UP(event, arg1)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE == "Level" then
				if arg1 >= tonumber(s.ID_WOWHEAD) then

					if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then

						local faction = UnitFactionGroup("player")
						-- check attune warning is for the right faction
						for k, a in pairs(Attune_Data.attunes) do
							if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
								if a.ID == s.ID_ATTUNE then
									if a.FACTION == faction or a.FACTION == 'Both' then
										--mark step as done
										Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
										refreshNeeded = true
										PlaySound(1210) --putdownring
										-- fetch attune name for chat message
										if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", s.STEP):gsub("##NAME##", a.NAME)) end
										Attune_SendPushInfo("TOON")
										Attune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID)
										Attune_SendPushInfo("OVER")
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end


-------------------------------------------------------------------------
-- EVENT: Quest accepted
-------------------------------------------------------------------------

function Attune:QUEST_ACCEPTED(event)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE == "Pick Up" then

				local qIDs = Attune_split(s.ID_WOWHEAD, "|")
				for i=1, #qIDs do 
					if C_QuestLog.IsOnQuest(qIDs[i]) then
					
						if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then

							local faction = UnitFactionGroup("player")
							-- check attune warning is for the right faction
							for k, a in pairs(Attune_Data.attunes) do
								if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
									if a.ID == s.ID_ATTUNE then
										if a.FACTION == faction or a.FACTION == 'Both' then
											--mark step as done
											Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
											refreshNeeded = true
											PlaySound(1210) --putdownring
											-- fetch attune name for chat message
											if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", AttuneLang["Q1_"..s.ID_WOWHEAD]):gsub("##NAME##", a.NAME)) end
											Attune_SendPushInfo("TOON")
											Attune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID)
											Attune_SendPushInfo("OVER")
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end

-------------------------------------------------------------------------
-- EVENT: Quest turned in
-------------------------------------------------------------------------

function Attune:QUEST_TURNED_IN(event, arg1)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE == "Quest" or s.TYPE == "Turn In" then

				local qIDs = Attune_split(s.ID_WOWHEAD, "|")
				for i=1, #qIDs do 

					if tonumber(qIDs[i]) == arg1 then

						if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then

							local faction = UnitFactionGroup("player")
							-- check attune warning is for the right faction
							for k, a in pairs(Attune_Data.attunes) do
								if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
									if a.ID == s.ID_ATTUNE then
										if a.FACTION == faction or a.FACTION == 'Both' then
											--mark step as done
											Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
											refreshNeeded = true
											PlaySound(1210) --putdownring
											-- fetch attune name for chat message
											if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", AttuneLang["Q1_"..s.ID_WOWHEAD]):gsub("##NAME##", a.NAME)) end
											Attune_SendPushInfo("TOON")
											Attune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID)
											Attune_CheckComplete(false)
											if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] >= 100 then
												PlaySound(5275) -- AuctionWindowClose
												if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["AttuneComplete"]:gsub("##NAME##", a.NAME)) end
												if Attune_DB.announceAttuneCompleted and attunelocal_myguild ~= "" then SendChatMessage("[Attune] "..AttuneLang["AttuneCompleteGuild"]:gsub("##NAME##", a.NAME), "GUILD") end
											end
											Attune_SendPushInfo("OVER")
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end

-------------------------------------------------------------------------
-- EVENT: Interact with NPC
-------------------------------------------------------------------------
function Attune:QUEST_DETAIL(event)
	--print("QUEST_DETAIL")
	Attune:GOSSIP_SHOW(event)
end
-------------------------------------------------------------------------
function Attune:GOSSIP_SHOW(event)
	-- Forever/Midnight: UnitGUID may be secret; never use it in a truthiness
	-- check (that forces string conversion and errors when tainted).
	local npc_id = Attune_GetInteractNpcID()
	if npc_id == -1 then return end

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE == "Interact" then

				if ""..s.ID_WOWHEAD == ""..npc_id then
					if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then

						-- checking that predecessors are done (meaning this step is ISNext)
						local isNext = true
						local followOR = false
						if s.FOLLOWS ~= "0" then
							local fIDs = Attune_split(s.FOLLOWS, "&")
							if string.find(s.FOLLOWS, "|") then fIDs = Attune_split(s.FOLLOWS, "|"); followOR = true end
							if followOR then
								isNext = false
								for fi, f in pairs(fIDs) do
									if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. f] then isNext = true end
								end
							else
								isNext = true
								for fi, f in pairs(fIDs) do
									if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. f] == nil then isNext = false end
								end
							end
						end
						
						if isNext then

							local faction = UnitFactionGroup("player")
							-- check attune warning is for the right faction
							for k, a in pairs(Attune_Data.attunes) do
								if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
									if a.ID == s.ID_ATTUNE then
										if a.FACTION == faction or a.FACTION == 'Both' then
											--mark step as done
											Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
											refreshNeeded = true
											PlaySound(1210) --putdownring
											-- fetch attune name for chat message
											if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", AttuneLang["N1_"..s.ID_WOWHEAD]):gsub("##NAME##", a.NAME)) end
											Attune_SendPushInfo("TOON")
											Attune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID)
											Attune_CheckComplete(false)
											if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] >= 100 then
												PlaySound(5275) -- AuctionWindowClose
												if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["AttuneComplete"]:gsub("##NAME##", a.NAME)) end
												if Attune_DB.announceAttuneCompleted and attunelocal_myguild ~= "" then SendChatMessage("[Attune] "..AttuneLang["AttuneCompleteGuild"]:gsub("##NAME##", a.NAME), "GUILD") end
											end
											Attune_SendPushInfo("OVER")
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end

-------------------------------------------------------------------------
-- EVENT: Looted stuff
-------------------------------------------------------------------------

function Attune:BAG_UPDATE(event)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE == "Item" then

				local countNeeded = 1
				if s.COUNT ~= nil then countNeeded = s.COUNT end

				Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] = GetItemCount(s.ID_WOWHEAD, 1)

				-- Bandaid to fix the honored/revered key issue
				if s.ID_WOWHEAD == "185686" and Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] == 0 then Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] = GetItemCount("30637", 1) end -- Thrallmar
				if s.ID_WOWHEAD == "185687" and Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] == 0 then Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] = GetItemCount("30622", 1) end -- Honor Hold
				if s.ID_WOWHEAD == "185690" and Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] == 0 then Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] = GetItemCount("30623", 1) end -- Cenarion
				if s.ID_WOWHEAD == "185691" and Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] == 0 then Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] = GetItemCount("30633", 1) end -- Lower City
				if s.ID_WOWHEAD == "185692" and Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] == 0 then Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] = GetItemCount("30634", 1) end -- Shatar
				if s.ID_WOWHEAD == "185693" and Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] == 0 then Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] = GetItemCount("30635", 1) end -- KoT
				
				if Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] >= countNeeded then   --check bags and bank

					if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
						local faction = UnitFactionGroup("player")
						-- check attune warning is for the right faction
						for k, a in pairs(Attune_Data.attunes) do
							if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
								if a.ID == s.ID_ATTUNE then
									if a.FACTION == faction or a.FACTION == 'Both' then
										--mark step as done
										Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
										refreshNeeded = true
										PlaySound(1210) --putdownring
										-- fetch attune name for chat message
										if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", AttuneLang["I_"..s.ID_WOWHEAD]):gsub("##NAME##", a.NAME)) end
										Attune_SendPushInfo("TOON")
										Attune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID)
										Attune_CheckComplete(false)
										if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] >= 100 then
											PlaySound(5275) -- AuctionWindowClose
											if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["AttuneComplete"]:gsub("##NAME##", a.NAME)) end
											if Attune_DB.announceAttuneCompleted and attunelocal_myguild ~= "" then SendChatMessage("[Attune] "..AttuneLang["AttuneCompleteGuild"]:gsub("##NAME##", a.NAME), "GUILD") end
										end
										Attune_SendPushInfo("OVER")
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end

-------------------------------------------------------------------------
-- EVENT: Rep changed
-------------------------------------------------------------------------

function Attune:UPDATE_FACTION(event)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE == "Rep" then

				--loop on the all the character's factions
				local factionIndex = 1

				local name, _, _, _, _, earnedValue = Attune_GetFactionInfoByID(s.LOCATION)
				Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION] = {}
				Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION].earned = earnedValue or 0
				Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION].name = name or AttuneLang["Unknown Reputation"]
				--repeat
				--	local name, _, _, _, _, earnedValue = GetFactionInfo(factionIndex)
				--	if (name == s.LOCATION) then
				--		Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION] = earnedValue
				--		break
				--	end
				--	factionIndex = factionIndex + 1
				--until factionIndex > 200

				if Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION].earned >= tonumber(s.ID_WOWHEAD) then

					if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
						local faction = UnitFactionGroup("player")
						-- check attune warning is for the right faction
						for k, a in pairs(Attune_Data.attunes) do
							if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
								if a.ID == s.ID_ATTUNE then
									if a.FACTION == faction or a.FACTION == 'Both' then
										--mark step as done
										Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
										refreshNeeded = true
										PlaySound(1210) --putdownring
										-- fetch attune name for chat message
										if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", s.STEP):gsub("##NAME##", a.NAME)) end
										Attune_SendPushInfo("TOON")
										Attune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID)
										Attune_CheckComplete(false)
										if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] >= 100 then
											PlaySound(5275) -- AuctionWindowClose
											if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..AttuneLang["AttuneComplete"]:gsub("##NAME##", a.NAME)) end
											if Attune_DB.announceAttuneCompleted and attunelocal_myguild ~= "" then SendChatMessage("[Attune] "..AttuneLang["AttuneCompleteGuild"]:gsub("##NAME##", a.NAME), "GUILD") end
										end
										Attune_SendPushInfo("OVER")
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end



-------------------------------------------------------------------------
function Attune_UpdateLogs()

	local slogs = ""
	local cnt = 0
	for i, l in Attune_spairs(Attune_DB.logs, function(t,a,b) return b < a end) do
		if cnt < 40 then -- only about 40 lines fit in that area
			slogs = slogs .. date("%d %b %Y - %H:%M", i) .. " - " .. l .. "\n"
		else
			Attune_DB.logs[i] = nil
		end
		cnt = cnt + 1
	end

	if slogs == "" then
		attune_options.args.tab2.args.logs.name = "None yet..."
	else
		attune_options.args.tab2.args.logs.name = slogs
	end

end

-------------------------------------------------------------------------
-- Perform the attunement checks
-------------------------------------------------------------------------

function Attune_CheckProgress()

	local att = Attune_DB.toons[attunelocal_charKey]

	if att.reps == nil then att.reps = {} end
	--if att.quests == nil then att.quests = {} end
	if att.items == nil then att.items = {} end
	if att.done == nil then att.done = {} end
	if att.attuned == nil then att.attuned = {} end
	if att.next == nil then att.next = {} end

	local faction = UnitFactionGroup("player")
	-- looping through all applicable attunes
	for i, a in pairs(Attune_Data.attunes) do

		if a.FACTION == faction or a.FACTION == 'Both' and (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 

			--looping through all steps
			for i, s in pairs(Attune_Data.steps) do

				if showPatchStep(s) then
					if s.ID_ATTUNE == a.ID then

						--get REPUTATION progression
						if s.TYPE == "Rep" then

							--loop on the all the character's factions
							local factionIndex = 1
							local name, _, _, _, _, earnedValue = Attune_GetFactionInfoByID(s.LOCATION)
							att.reps[s.LOCATION] = {}
							att.reps[s.LOCATION].earned = earnedValue or 0
							att.reps[s.LOCATION].name = name or AttuneLang["Unknown Reputation"]
							--repeat
							--	local name, _, _, _, _, earnedValue = GetFactionInfo(factionIndex)
							--	if (name == s.LOCATION) then
							--		att.reps[s.LOCATION] = earnedValue
							--		break
							--	end
							--	factionIndex = factionIndex + 1
							--until factionIndex > 200

							if att.reps[s.LOCATION].earned >= tonumber(s.ID_WOWHEAD) then
								text = "|TInterface\\AddOns\\Attune\\Images\\success:16|t"
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end

						--get QUEST accepts
						if s.TYPE == "Pick Up" then
							local eitherOnQuest = false
							local qIDs = Attune_split(s.ID_WOWHEAD, "|")
							for i=1, #qIDs do 
								if C_QuestLog.IsOnQuest(qIDs[i]) then
									eitherOnQuest = true
								end
							end
							if eitherOnQuest then
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end

						--get QUEST completion
						-- A quest still in the log is not turned in, even if an older
						-- completion flag exists for the same quest id.
						if s.TYPE == "Quest" or s.TYPE == "Turn In" then
							local eitherCompleted = false
							local onQuest = false
							local qIDs = Attune_split(s.ID_WOWHEAD, "|")
							for i=1, #qIDs do
								if C_QuestLog.IsOnQuest(qIDs[i]) then
									onQuest = true
								elseif IsQuestFlaggedCompleted(qIDs[i]) then
									eitherCompleted = true
								end
							end
							if onQuest then
								att.done[a.ID .. "-" .. s.ID] = nil
							elseif eitherCompleted then
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end

						--get ITEM possession
						if s.TYPE == "Item" then
							local countNeeded = 1
							if s.COUNT ~= nil then countNeeded = s.COUNT end
							if GetItemCount(s.ID_WOWHEAD, 1) >= countNeeded then   --check bags and bank
								att.items[s.ID_WOWHEAD] = GetItemCount(s.ID_WOWHEAD, 1);
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end

						--get LEVEL progression
						if s.TYPE == "Level" then
							if UnitLevel('player') >= tonumber(s.ID_WOWHEAD) then
								att.done[a.ID .. "-" .. s.ID] = 1
							end
						end
					end
				end
			end
		end
	end

	-- some specific steps mean the whole attunement is complete. Close off the whole tree if those are done
	-- including a second pass to mark as done all non-trackable steps (interact/kill/past items) that belong to earlier (completed) quests
	Attune_SendPushInfo("TOON")
	Attune_CheckComplete(true)
	Attune_SendPushInfo("OVER")

	-- a third pass to mark as done all attunements used in further attunements
	for i, s in pairs(Attune_Data.steps) do
		--print(s.ID_ATTUNE.."-"..s.ID)
		if showPatchStep(s) then
			if s.TYPE == 'Attune' and att.attuned[s.ID_WOWHEAD] >= 100 then
				att.done[s.ID_ATTUNE.."-"..s.ID] = 1
			end
		end	
	end

end

-------------------------------------------------------------------------
-- Auto-complete Spacer steps whose FOLLOWS are done (column drop lines)
-------------------------------------------------------------------------

function Attune_AutoCompleteSpacers(who)
	local t = Attune_DB.toons[who]
	if t == nil or t.done == nil then return end

	-- Repeat until stable so Spacer→Spacer chains mark top-to-bottom
	local changed = true
	while changed do
		changed = false
		for _, s in pairs(Attune_Data.steps) do
			if showPatchStep(s) and s.TYPE == "Spacer" and s.FOLLOWS ~= nil and s.FOLLOWS ~= "0" then
				local key = s.ID_ATTUNE .. "-" .. s.ID
				if not t.done[key] then
					local allDone = true
					local followOR = false
					local fIDs = Attune_split(s.FOLLOWS, "&")
					if string.find(s.FOLLOWS, "|") then fIDs = Attune_split(s.FOLLOWS, "|"); followOR = true end
					if followOR then
						allDone = false
						for _, flw in pairs(fIDs) do
							if t.done[s.ID_ATTUNE .. "-" .. flw] then allDone = true; break end
						end
					else
						for _, flw in pairs(fIDs) do
							if not t.done[s.ID_ATTUNE .. "-" .. flw] then allDone = false; break end
						end
					end
					if allDone then
						t.done[key] = 1
						changed = true
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------
-- Check full Attune completion
-------------------------------------------------------------------------

function Attune_CheckComplete(newComplete)
	local att = Attune_DB.toons[attunelocal_charKey]

	Attune_AutoCompleteSpacers(attunelocal_charKey)

	-- WoW
	if att.done["20-45"] and att.attuned["20"] ~= 100 	then att.done["20-50"] = 1; 	Attune_SendPushInfo("20-50"); 	att.attuned["20"] = 100; Attune_UpdateTreeGroup("20"); newComplete = true;  end	-- MC
	if att.done["30-268"] and att.attuned["30"] ~= 100	then att.done["30-270"] = 1; Attune_SendPushInfo("30-270"); 	att.attuned["30"] = 100; Attune_UpdateTreeGroup("30"); newComplete = true;  end	-- Ony Horde
	if att.done["40-265"] and att.attuned["40"] ~= 100	then att.done["40-270"] = 1; Attune_SendPushInfo("40-270"); 	att.attuned["40"] = 100; Attune_UpdateTreeGroup("40"); newComplete = true;  end	-- Ony Alliance
	if att.done["50-65"] and att.attuned["50"] ~= 100 	then att.done["50-70"] = 1; 	Attune_SendPushInfo("50-70"); 	att.attuned["50"] = 100; Attune_UpdateTreeGroup("50"); newComplete = true;  end	-- BWL
	if att.done["60-40"] and att.attuned["60"] ~= 100 	then att.done["60-90"] = 1; 	Attune_SendPushInfo("60-90"); 	att.attuned["60"] = 100; Attune_UpdateTreeGroup("60"); newComplete = true;  end	-- Naxx
	if att.done["60-50"] and att.attuned["60"] ~= 100 	then att.done["60-90"] = 1; 	Attune_SendPushInfo("60-90"); 	att.attuned["60"] = 100; Attune_UpdateTreeGroup("60"); newComplete = true;  end	-- Naxx
	if att.done["60-60"] and att.attuned["60"] ~= 100 	then att.done["60-90"] = 1; 	Attune_SendPushInfo("60-90"); 	att.attuned["60"] = 100; Attune_UpdateTreeGroup("60"); newComplete = true;  end	-- Naxx
	if att.done["80-200"] and att.attuned["80"] ~= 100 	then att.done["80-210"] = 1; Attune_SendPushInfo("80-210"); 	att.attuned["80"] = 100;	 Attune_UpdateTreeGroup("80"); newComplete = true;  end	-- MC Quintessence
	if att.done["100-960"] and att.attuned["100"] ~= 100 	then att.done["100-970"] = 1;Attune_SendPushInfo("100-970"); 	att.attuned["100"] = 100; Attune_UpdateTreeGroup("100"); newComplete = true;  end	-- scarab

	if att.done["120-65"] and att.attuned["120"] ~= 100 	then att.done["120-70"] = 1; Attune_SendPushInfo("120-70"); 	att.attuned["120"] = 100; Attune_UpdateTreeGroup("120"); newComplete = true;  end	-- brd key
	if att.done["140-130"] and att.attuned["140"] ~= 100 	then att.done["140-140"] = 1; Attune_SendPushInfo("140-140"); 	att.attuned["140"] = 100; Attune_UpdateTreeGroup("140"); newComplete = true;  end	-- scholo Horde
	if att.done["150-130"] and att.attuned["150"] ~= 100 	then att.done["150-140"] = 1; Attune_SendPushInfo("150-140"); 	att.attuned["150"] = 100; Attune_UpdateTreeGroup("150"); newComplete = true;  end	-- scholo Alliance


	-- Generic: mark End done when all its FOLLOWS are complete
	for _, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) and s.TYPE == "End" and (att.attuned[s.ID_ATTUNE] or 0) < 100 then
			local allDone = true
			if s.FOLLOWS == nil or s.FOLLOWS == "0" then
				allDone = false
			else
				local fIDs = Attune_split(s.FOLLOWS, "&")
				for _, flw in pairs(fIDs) do
					if not att.done[s.ID_ATTUNE .. "-" .. flw] then allDone = false; break end
				end
			end
			if allDone then
				att.done[s.ID_ATTUNE .. "-" .. s.ID] = 1
				Attune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID)
				att.attuned[s.ID_ATTUNE] = 100
				Attune_UpdateTreeGroup(s.ID_ATTUNE)
				newComplete = true
			end
		end
	end

	if newComplete then 
		for i, s in Attune_spairs(Attune_Data.steps, function(t,a,b) 	return tonumber(t[b].ID) > tonumber(t[a].ID) end) do
			if showPatchStep(s) then
				if att.done[s.ID_ATTUNE .. "-" .. s.ID] then
					-- recurse into earlier steps to mark them as done too
					C_Timer.After(0.01, function() Attune_recursePreviousSteps(attunelocal_charKey, s.ID_ATTUNE, s.FOLLOWS) end)
				end
			end
		end
	end
	Attune_CheckIsNext(attunelocal_charKey)
end

-------------------------------------------------------------------------
-- If the End step is done, force attuned % to 100 (overrides step-count math)
-------------------------------------------------------------------------

function Attune_ApplyCompletedEndSteps(t)
	if t == nil or t.done == nil or t.attuned == nil then return end
	for _, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) and s.TYPE == "End" and t.done[s.ID_ATTUNE .. "-" .. s.ID] then
			t.attuned[s.ID_ATTUNE] = 100
		end
	end
end

-------------------------------------------------------------------------
-- Check which step is next
-------------------------------------------------------------------------

function Attune_CheckIsNext(who)
	local att = Attune_DB.toons[who]
	--print("Checking "..who)
	-- blank the array
	att.next = {}

	for i, step in pairs(Attune_Data.steps) do
		if showPatchStep(step) then

			if (step.ID_ATTUNE == "190" and step.ID == "120") then debug = true else debug=false end

			local next = false
			if  att.done[step.ID_ATTUNE .. "-" .. step.ID] ~= nil then
				-- if done, then not isnext
				next = false
			else

				local followOR = false
				local fIDs = Attune_split(step.FOLLOWS, "&")
				if string.find(step.FOLLOWS, "|") then fIDs = Attune_split(step.FOLLOWS, "|"); followOR = true end

				if followOR then
					next = false
					for fi, flw in pairs(fIDs) do
						if  att.done[step.ID_ATTUNE .. "-" .. flw] then next = true end
					end

				else
					next = true
					for fi, flw in pairs(fIDs) do
						if  att.done[step.ID_ATTUNE .. "-" .. flw] == nil or att.done[step.ID_ATTUNE .. "-" .. flw] == false then next = false end
					end
		
				end
				if step.FOLLOWS == "0" then next = true end
			end

			if next then
				att.next[step.ID_ATTUNE .. "-" .. step.ID] = 1
			else
				att.next[step.ID_ATTUNE .. "-" .. step.ID] = nil
			end
		end
	end
end

-------------------------------------------------------------------------
-- Update the treeview to show completed attunes
-------------------------------------------------------------------------

function Attune_UpdateTreeGroup(aid)

	for i, a in pairs(Attune_Data.attunes) do
		if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
			if a.ID == aid then

				-- parse expacs
				for iE, aE in pairs(attunelocal_tree) do
					if aE.value == a.EXPAC then

						-- parse groups
						for iG, aG in pairs(aE.children) do
							if aG.value == a.GROUP then

								local groupAllDone = true
								for iA, aA in pairs(aG.children) do
									if aA.value == a.ID then
										aA.text = "|cff00ff00"..aA.text.."|r"
										aA.icon = "Interface\\AddOns\\Attune\\Images\\success"
									end
									if aA.icon ~= "Interface\\AddOns\\Attune\\Images\\success" then 
										groupAllDone = false
									end
								end
								if groupAllDone then 
									aG.text = "|cff00ff00"..aG.text.."|r"
								end
							end
						end
					end
				end
			end
		end
	end

end

-------------------------------------------------------------------------
-- Recurse through previous steps (following the FOLLOWS path)
-------------------------------------------------------------------------

function Attune_recursePreviousSteps(who, aID, follows)

    
	if (Attune_DB.toons[who] ~= nil) then
		if (Attune_DB.toons[who].done ~= nil) then

			-- there can be multi-follows (for example FOLLOW=160|170)
			-- We need to recurse both paths
			local fIDs = Attune_split(follows, "&")
			if string.find(follows, "|") then fIDs = Attune_split(follows, "|") end

			for fi, f in pairs(fIDs) do
				for i, s in pairs(Attune_Data.steps) do
					if showPatchStep(s) then
						if s.ID_ATTUNE == aID and s.ID == f then
							if string.find(follows, "|") == nil then -- don't recurse OR, as we don't know which parent was actually done
								if Attune_DB.toons[who].done[s.ID_ATTUNE .. "-" .. s.ID] ~= 1 then
                                    -- print(s.ID_ATTUNE .. "-" .. s.ID)
									Attune_DB.toons[who].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
									if (who == attunelocal_charKey) then Attune_SendPushInfo(s.ID_ATTUNE .. "-" .. s.ID) end
								end
								if follows ~= 0 then -- no need to recurse first level
									Attune_recursePreviousSteps(who, s.ID_ATTUNE, s.FOLLOWS)
								end
							end
						end
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------
-- Display name, with the level range when the entry defines one
-------------------------------------------------------------------------

local function Attune_DisplayName(a)
	if a.LEVELS and a.LEVELS ~= "" then
		return a.NAME .. " (" .. a.LEVELS .. ")"
	end
	return a.NAME
end

-------------------------------------------------------------------------
-- Load the data into the TreeGroup object (nodes/leaves)
-------------------------------------------------------------------------

function Attune_LoadTree()
	attunelocal_tree = {}
	local expac = ""
	local group = ""
	local expacNode = {}
	local groupNode = {}
	local groupAllDone = true
	local attunesWithSteps = {}
	for _, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			attunesWithSteps[s.ID_ATTUNE] = true
		end
	end

	for i, a in pairs(Attune_Data.attunes) do
		if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 

			--Group Level
			if group ~= a.GROUP or expac ~= a.EXPAC then 

				if group ~= "" then
					if groupAllDone then groupNode.text = "|cff00ff00"..groupNode.text.."|r"; end
					table.insert(expacNode.children, groupNode)
				end

				--Top level
				if expac ~= a.EXPAC then

					if expac ~= "" then
						table.insert(attunelocal_tree, expacNode)
					end

					-- new expac array
					expacNode = {
						value = a.EXPAC,
						text =  a.EXPAC,
						children = {}
					}
					expac = a.EXPAC
				end

				-- new group array
				groupNode = {
					value = a.GROUP,
					text =  "|cffA0A0A0"..a.GROUP.."|r",
					children = {}
				}
				group = a.GROUP
				groupAllDone = true
			end

			if a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both' then

				local text = Attune_DisplayName(a)
				local icon = a.ICON
				if not attunesWithSteps[a.ID] then
					text = "|cff808080"..text.."|r"
					groupAllDone = false
				elseif Attune_DB.toons[attunelocal_charKey].attuned ~= nil then
					if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] >= 100 then
						text = "|cff00ff00"..text.."|r"
						icon = "Interface\\AddOns\\Attune\\Images\\success"
					else 
						groupAllDone = false
					end
				end


				local attuneNode = {
					value = a.ID,
					text = text,
					icon = icon

				}
				-- "Interface\\Icons\\" ..
				--icon = "Interface\\AddOns\\Attune\\Images\\" .. a.ICON
					table.insert(groupNode.children, attuneNode)
			end
		end
	end
	--table.insert(groupNode.children, attuneNode)
	table.insert(expacNode.children, groupNode)
	table.insert(attunelocal_tree, expacNode)

end


-------------------------------------------------------------------------

function Attune_SaveTreeExpandStatus()
	if attunelocal_treeframe ~= nil then 
		for lineId, expanded in pairs(attunelocal_treeframe.localstatus.groups) do
			if expanded then TreeExpandStatus[lineId] = 1 else TreeExpandStatus[lineId] = 0 end
		end
	end
end


-------------------------------------------------------------------------
-- Client bronze portrait frame (same template as Cooking / profession windows)
-------------------------------------------------------------------------

local attunelocal_bronzeChrome
local ATTUNE_PORTRAIT_ATTUNE = "Interface\\Icons\\INV_Scroll_03"

local function Attune_ResultsPortrait()
	if UnitFactionGroup("player") == "Horde" then
		return "Interface\\Icons\\INV_BannerPVP_01"
	end
	return "Interface\\Icons\\INV_BannerPVP_02"
end

local function Attune_SetPortraitTexture(chrome, texture)
	if not chrome or not texture then return end
	if chrome.SetPortraitToAsset then
		chrome:SetPortraitToAsset(texture)
		return
	end
	if chrome.SetPortraitTextureRaw then
		chrome:SetPortraitTextureRaw(texture)
		return
	end
	local candidates = {
		chrome.PortraitContainer and chrome.PortraitContainer.portrait,
		chrome.portrait and (chrome.portrait.portrait or chrome.portrait),
		chrome.Portrait,
	}
	for _, tex in ipairs(candidates) do
		if tex and tex.SetTexture then
			if SetPortraitToTexture then
				pcall(SetPortraitToTexture, tex, texture)
			else
				tex:SetTexture(texture)
			end
			return
		end
	end
end

local function Attune_SetChromeTitle(chrome, text)
	if not chrome then return end
	if chrome.SetTitle then
		chrome:SetTitle(text)
		return
	end
	if chrome.TitleContainer and chrome.TitleContainer.TitleText then
		chrome.TitleContainer.TitleText:SetText(text)
	elseif chrome.TitleText and chrome.TitleText.SetText then
		chrome.TitleText:SetText(text)
	end
end

local function Attune_HideLegacyArt(frame)
	if frame.SetBackdrop then
		pcall(frame.SetBackdrop, frame, nil)
	end
	local regions = { frame:GetRegions() }
	for _, region in ipairs(regions) do
		if region.GetObjectType and region:GetObjectType() == "Texture" then
			region:Hide()
		end
	end
end

local function Attune_RaisePiece(piece, level)
	if piece and piece.SetFrameLevel then
		piece:SetFrameLevel(level)
	end
end

function Attune_UpdateWindowPortrait()
	if not attunelocal_bronzeChrome then return end
	if attunelocal_treeIsShown then
		Attune_SetPortraitTexture(attunelocal_bronzeChrome, ATTUNE_PORTRAIT_ATTUNE)
	else
		Attune_SetPortraitTexture(attunelocal_bronzeChrome, Attune_ResultsPortrait())
	end
	Attune_SetChromeTitle(attunelocal_bronzeChrome, "Attune")
end

local function Attune_ApplyBronzeChrome(host)
	if not host or attunelocal_bronzeChrome then return end
	local ok, chrome = pcall(CreateFrame, "Frame", "AttuneBronzeChrome", host, "PortraitFrameTemplate")
	if not ok or type(chrome) ~= "table" then return end

	chrome:SetAllPoints(host)
	chrome:SetMovable(false)
	chrome:SetScript("OnMouseDown", nil)
	chrome:SetScript("OnDragStart", nil)
	chrome:SetFrameStrata(host:GetFrameStrata())
	chrome:SetFrameLevel(host:GetFrameLevel() + 1)
	Attune_HideLegacyArt(host)

	if attunelocal_frame and attunelocal_frame.titletext then
		local oldTitle = attunelocal_frame.titletext:GetParent()
		if oldTitle then oldTitle:Hide() end
	end
	if attunelocal_frame and attunelocal_frame.titlebg then
		attunelocal_frame.titlebg:Hide()
	end

	local top = chrome:GetFrameLevel() or 1
	for _, child in ipairs({ host:GetChildren() }) do
		if child ~= chrome and child.SetFrameLevel then
			child:SetFrameLevel(top + 10)
		end
	end
	-- PortraitFrameTemplate puts the border hundreds of levels above the title.
	-- Raising the title only a little leaves the text under that border.
	local borderLevel = (chrome.NineSlice and chrome.NineSlice:GetFrameLevel()) or top
	Attune_RaisePiece(chrome.PortraitContainer or chrome.portrait, top + 40)
	Attune_RaisePiece(chrome.TitleContainer, borderLevel + 10)
	Attune_RaisePiece(chrome.CloseButton, borderLevel + 11)

	if chrome.TitleContainer then
		chrome.TitleContainer:EnableMouse(true)
		chrome.TitleContainer:SetScript("OnMouseDown", function()
			host:StartMoving()
		end)
		chrome.TitleContainer:SetScript("OnMouseUp", function()
			host:StopMovingOrSizing()
			local widget = attunelocal_frame
			if widget then
				local status = widget.status or widget.localstatus
				if status then
					status.top = host:GetTop()
					status.left = host:GetLeft()
				end
			end
		end)
	end

	if chrome.CloseButton then
		chrome.CloseButton:SetScript("OnClick", function()
			if attunelocal_survey_frame and attunelocal_survey_frame.frame then
				attunelocal_survey_frame.frame:Hide()
			end
			attunelocal_frame:Hide()
			Attune_SaveTreeExpandStatus()
			Attune_Release()
		end)
	end

	attunelocal_bronzeChrome = chrome
	if attunelocal_frame and attunelocal_frame.content then
		attunelocal_frame.content:SetPoint("TOPLEFT", host, "TOPLEFT", 16, -58)
	end
	local portraitPiece = chrome.PortraitContainer or chrome.portrait
	if portraitPiece and portraitPiece.EnableMouse then
		portraitPiece:EnableMouse(false)
	end
end

-- Bronze border for the quest-reward panel. No portrait: that icon belongs to the main window.
local function Attune_ApplyButtonChrome(host, onClose)
	local ok, chrome = pcall(CreateFrame, "Frame", nil, host, "ButtonFrameTemplate")
	if not ok or type(chrome) ~= "table" then return nil end

	chrome:SetAllPoints(host)
	chrome:SetMovable(false)
	chrome:SetScript("OnMouseDown", nil)
	chrome:SetScript("OnDragStart", nil)
	chrome:SetFrameStrata(host:GetFrameStrata())
	chrome:SetFrameLevel(host:GetFrameLevel() + 1)
	Attune_HideLegacyArt(host)

	local above = (chrome:GetFrameLevel() or 1) + 10
	for _, child in ipairs({ host:GetChildren() }) do
		if child ~= chrome and child.SetFrameLevel then
			child:SetFrameLevel(above)
		end
	end
	if chrome.PortraitContainer then chrome.PortraitContainer:Hide() end
	if chrome.portrait and chrome.portrait.Hide then chrome.portrait:Hide() end
	local borderLevel = (chrome.NineSlice and chrome.NineSlice:GetFrameLevel()) or above
	Attune_RaisePiece(chrome.TitleContainer, borderLevel + 10)
	Attune_RaisePiece(chrome.CloseButton, borderLevel + 11)
	if chrome.CloseButton and onClose then
		chrome.CloseButton:SetScript("OnClick", onClose)
	end
	return chrome
end

-------------------------------------------------------------------------
-- Create the Main UI Frame
-------------------------------------------------------------------------

function Attune_Frame()

	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then attunelocal_myguild = guildName end


	attunelocal_frame = AceGUI:Create("Frame", "AttuneFrame")
	attunelocal_frame:SetTitle("  Attune")
	attunelocal_frame:SetStatusText(attunelocal_statusText)

	--print(attunelocal_frame.frame:GetAlpha())
	--attunelocal_raidspotIcon[found].frame:SetAlpha(0.25)
	attunelocal_frame:SetStatusText(attunelocal_statusText)

	attunelocal_frame:SetHeight(Attune_DB.height)
	attunelocal_frame:SetWidth(Attune_DB.width)

	attunelocal_frame.frame:SetScript("OnSizeChanged", function(self)
		local hh = self:GetHeight()
		local ww = self:GetWidth()
		if hh > self:GetParent():GetHeight() - 50 	then hh = self:GetParent():GetHeight() - 50; self:SetHeight(hh) end
		if ww > self:GetParent():GetWidth() - 50 	then ww = self:GetParent():GetWidth() - 50; self:SetWidth(ww) end
		Attune_DB.height = hh
		Attune_DB.width = ww
	end)


	--attunelocal_frame.frame:SetHeight(Attune_DB.height)
	--attunelocal_frame.frame:SetWidth(Attune_DB.width)

	if attunelocal_frame.frame.SetResizeBounds then
		attunelocal_frame.frame:SetResizeBounds(1010, 550)
	else
		attunelocal_frame.frame:SetMinResize(1010, 550)
	end
	attunelocal_frame.frame:SetFrameStrata("HIGH")


	-- Hacking into the Ace3 frame to reduce the size of the statusbox, to allow us room for other buttons
	local closebutton, statusbg, _, _, _, _, _ = attunelocal_frame.content.obj.frame:GetChildren()
	statusbg:ClearAllPoints()
	statusbg:SetPoint("BOTTOMLEFT", 15, 15)     -- taken from AceGUIContainer-Frame.lua
	statusbg:SetPoint("BOTTOMRIGHT", -280, 15)  -- taken from AceGUIContainer-Frame.lua, modified from -132

	closebutton:SetWidth(80)
	closebutton:SetScript("OnClick", function()
		-- attunelocal_export_frame.frame:Hide() -- close other submenu
		attunelocal_survey_frame.frame:Hide() -- close other submenu
		attunelocal_frame:Hide()
		Attune_SaveTreeExpandStatus()
		Attune_Release()
	end)


	-- SURVEY BUTTON
	local surveybutton = CreateFrame("Button", nil, attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	surveybutton:SetPoint("BOTTOMRIGHT", -193, 17)
	surveybutton:SetFrameStrata("DIALOG")
	surveybutton:SetHeight(20)
	surveybutton:SetWidth(80)
	surveybutton:SetText(AttuneLang["Survey"])
	--if attunelocal_myguild == "" then surveybutton:Disable() end
	surveybutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(AttuneLang["Survey_DESC"]) end)
	surveybutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	surveybutton:SetScript("OnClick", function()
		if attunelocal_survey_frame.frame:IsShown() then
			attunelocal_survey_frame.frame:Hide()
		else
			-- attunelocal_export_frame.frame:Hide() -- close other submenu
			attunelocal_survey_frame.frame:Show()
		end
	end)

	-- SURVEY SUB MENU
		attunelocal_survey_frame = AceGUI:Create("InlineGroup")
		attunelocal_survey_frame:SetLayout("Flow")
		attunelocal_survey_frame:SetWidth(160)
		attunelocal_survey_frame:SetPoint("TOPLEFT", surveybutton,"BOTTOMLEFT", 0, 10)
		attunelocal_survey_frame.frame:Hide()

		local surveyTarget = AceGUI:Create("Button")
		surveyTarget:SetText(AttuneLang["Target"])
		surveyTarget:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			if not UnitExists("target") then
				attunelocal_frame:SetStatusText(AttuneLang["No Target"])
				C_Timer.After(3, function()
					attunelocal_frame:SetStatusText(attunelocal_statusText)
				end)
			else
                local targetFirst, targetLast = UnitName("target")
				Attune_SendRequest("Target|" .. targetFirst .. " " .. targetLast)
			end
		end)
		attunelocal_survey_frame:AddChild(surveyTarget)

		local surveyGuild = AceGUI:Create("Button")
		surveyGuild:SetText(AttuneLang["Guild"])
		surveyGuild:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			Attune_SendRequest("Guild")
		end)
		attunelocal_survey_frame:AddChild(surveyGuild)

		local surveyParty = AceGUI:Create("Button")
		surveyParty:SetText(AttuneLang["Party"])
		surveyParty:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			Attune_SendRequest("Party")
		end)
		attunelocal_survey_frame:AddChild(surveyParty)

		local surveyRaid = AceGUI:Create("Button")
		surveyRaid:SetText(AttuneLang["Raid"])
		surveyRaid:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			Attune_SendRequest("Raid")
		end)
		attunelocal_survey_frame:AddChild(surveyRaid)

		local surveyClose = AceGUI:Create("Button")
		surveyClose:SetText(AttuneLang["Close"])
		surveyClose:SetCallback("OnClick", function(slid)	attunelocal_survey_frame.frame:Hide()	end)
		attunelocal_survey_frame:AddChild(surveyClose)

	-- -- EXPORT BUTTON
	-- local exportbutton = CreateFrame("Button", nil, attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	-- exportbutton:SetPoint("BOTTOMRIGHT", -193, 17)
	-- exportbutton:SetFrameStrata("DIALOG")
	-- exportbutton:SetHeight(20)
	-- exportbutton:SetWidth(80)
	-- exportbutton:SetText(AttuneLang["Export"])
	-- exportbutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(AttuneLang["Export_DESC"]) end)
	-- exportbutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	-- exportbutton:SetScript("OnClick", function()

	-- 	if attunelocal_export_frame.frame:IsShown() then
	-- 		attunelocal_export_frame.frame:Hide()
	-- 	else
	-- 		attunelocal_survey_frame.frame:Hide() -- close other submenu
	-- 		attunelocal_export_frame.frame:Show()
	-- 	end
	-- end)

	-- -- EXPORT SUB MENU
	-- 	attunelocal_export_frame = AceGUI:Create("InlineGroup")
	-- 	attunelocal_export_frame:SetLayout("Flow")
	-- 	attunelocal_export_frame:SetWidth(160)
	-- 	attunelocal_export_frame:SetPoint("TOPLEFT", exportbutton,"BOTTOMLEFT", 0, 10)
	-- 	attunelocal_export_frame.frame:Hide()

	-- 	local exportThisToon = AceGUI:Create("Button")
	-- 	exportThisToon:SetText(AttuneLang["This Toon"])
	-- 	exportThisToon:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 0
	-- 		Attune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportThisToon)

	-- 	local exportMyData = AceGUI:Create("Button")
	-- 	exportMyData:SetText(AttuneLang["My Data"])
	-- 	exportMyData:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 4
	-- 		Attune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportMyData)

	-- 	local exportLastSurvey = AceGUI:Create("Button")
	-- 	exportLastSurvey:SetText(AttuneLang["Last Survey"])
	-- 	exportLastSurvey:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 1
	-- 		Attune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportLastSurvey)

	-- 	local exportGuildData = AceGUI:Create("Button")
	-- 	exportGuildData:SetText(AttuneLang["Guild Data"])
	-- 	exportGuildData:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 2
	-- 		Attune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportGuildData)

	-- 	local exportAll = AceGUI:Create("Button")
	-- 	exportAll:SetText(AttuneLang["All Data"])
	-- 	exportAll:SetCallback("OnClick", function()
	-- 		attunelocal_export_frame.frame:Hide()
	-- 		attunelocal_exportselection = 3
	-- 		Attune_ExportToWebsite()
	-- 	end)
	-- 	attunelocal_export_frame:AddChild(exportAll)

	-- 	local exportClose = AceGUI:Create("Button")
	-- 	exportClose:SetText(AttuneLang["Close"])
	-- 	exportClose:SetCallback("OnClick", function()	attunelocal_export_frame.frame:Hide()	end)
	-- 	attunelocal_export_frame:AddChild(exportClose)

	-- RESULTS BUTTON
	local guildbutton = CreateFrame("Button", "GuildButton", attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	guildbutton:SetPoint("BOTTOMRIGHT", -110, 17)
	guildbutton:SetFrameStrata("DIALOG")
	guildbutton:SetHeight(20)
	guildbutton:SetWidth(80)
	guildbutton:SetText(AttuneLang["Results"])
	--if attunelocal_myguild == "" then guildbutton:Disable() end
	guildbutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(AttuneLang["Toggle_DESC"]) end)
	guildbutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	guildbutton:SetScript("OnClick", function()
		-- attunelocal_export_frame.frame:Hide() -- close other submenu
		attunelocal_survey_frame.frame:Hide() -- close other submenu
		Attune_ToggleView()

	end)


	-- -- PLANNER BUTTON
	-- local plannerbutton = CreateFrame("Button", "GuildButton", attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	-- plannerbutton:SetPoint("BOTTOMRIGHT", -110, 17)
	-- plannerbutton:SetFrameStrata("DIALOG")
	-- plannerbutton:SetHeight(20)
	-- plannerbutton:SetWidth(80)
	-- plannerbutton:SetText(AttuneLang["Planner"])
	-- --if attunelocal_myguild == "" then plannerbutton:Disable() end
	-- plannerbutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(AttuneLang["Open Raid Planner"]) end)
	-- plannerbutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	-- plannerbutton:SetScript("OnClick", function()
    --     -- close main frame
	-- 	attunelocal_survey_frame.frame:Hide() -- close other submenu
	-- 	attunelocal_frame:Hide()
	-- 	Attune_SaveTreeExpandStatus()
	-- 	Attune_Release()

    --     --- open raid planner
    --     if attunelocal_raidframe ~= nil then
	-- 		if attunelocal_raidframe:IsShown() then 
	-- 			attunelocal_raidframe:Hide() 
	-- 		else
	-- 			Attune_RaidPlannerFrame()
	-- 		end
	-- 	else 
	-- 		Attune_RaidPlannerFrame()
	-- 	end

	-- end)


    -- Register the global variable `Attune_MainFrame` as a "special frame"
    -- so that it is closed when the escape key is pressed.
	_G["Attune_MainFrame"] = attunelocal_frame.frame
    tinsert(UISpecialFrames, "Attune_MainFrame")
	-- _G["Attune_ExportMenuFrame"] = attunelocal_export_frame.frame
    -- tinsert(UISpecialFrames, "Attune_ExportMenuFrame")
	_G["Attune_SurveyMenuFrame"] = attunelocal_survey_frame.frame
    tinsert(UISpecialFrames, "Attune_SurveyMenuFrame")

	Attune_ApplyBronzeChrome(attunelocal_frame.frame)
	Attune_ToggleView()

end

-------------------------------------------------------------------------
-- Display the attune after it being selected in tree
-------------------------------------------------------------------------

-- Classic instance loading screens (Interface\Glues\LoadingScreens), file data IDs.
-- Hall of Thanes has no screen of its own; Deeprun Tram is the underground Ironforge art.
-- Ruins of Lordaeron uses the Blizzard loading screen of those ruins.
local ATTUNE_DUNGEON_ART = {
	["160"] = 131862, -- Ragefire Chasm
	["163"] = 131834, -- Hall of Thanes
	["166"] = 131834,
	["170"] = 131833, -- The Deadmines
	["177"] = 131882, -- Wailing Caverns
	["180"] = 131882,
	["183"] = 131867, -- Ruins of Lordaeron
	["186"] = 131867,
	["190"] = 131869, -- Shadowfang Keep
	["195"] = 7963777, -- Excavation Site: Wetlands (Forever)
	["196"] = 7963777,
	["200"] = 131823, -- Blackfathom Deeps
	["210"] = 131823,
	["220"] = 131870, -- The Stockade
	["230"] = 131841, -- Gnomeregan
	["240"] = 131841,
	["250"] = 131865, -- Razorfen Kraul
	["251"] = 131865,
	["260"] = 131852, -- Scarlet Monastery
	["270"] = 131852,
	["280"] = 131864, -- Razorfen Downs
	["290"] = 131864,
	["300"] = 131850, -- Maraudon
	["310"] = 131850,
	["320"] = 131876, -- Uldaman
	["330"] = 131876,
	["340"] = 131835, -- Dire Maul
	["350"] = 131885, -- Zul'Farrak
	["351"] = 131885,
	["360"] = 131871, -- Stratholme
	["370"] = 131872, -- Temple of Atal'Hakkar
	["380"] = 131872,
	["390"] = 131824, -- Blackrock Depths
	["400"] = 131824,
	["410"] = 131868, -- Scholomance
	["420"] = 131868,
	["120"] = 131824, -- Blackrock Depths (key)
	["140"] = 131868, -- Scholomance (key)
	["150"] = 131868,
}
local ATTUNE_DUNGEON_ART_ALPHA = 0.08

local function Attune_LayoutDungeonArt()
	local tex = attunelocal_dungeonArt
	local parent = tex and tex:GetParent()
	if not tex or not parent or not tex:IsShown() then return end
	tex:ClearAllPoints()
	tex:SetAllPoints(parent)
	-- Crop the top and bottom 20%, then stretch the middle 60% over the panel.
	tex:SetTexCoord(0, 1, 0.22, 0.80)
end

local function Attune_HideDungeonArt()
	if not attunelocal_dungeonArt then return end
	attunelocal_dungeonArt:Hide()
	attunelocal_dungeonArt:SetTexture(nil)
end

local function Attune_ShowDungeonArt(attuneId)
	-- Outer widget frame, not the ScrollFrame: art stays put and is not clipped with the quest list.
	local parent = attunelocal_scroll and attunelocal_scroll.frame
	if not parent then return end
	if not attunelocal_dungeonArt or attunelocal_dungeonArt:GetParent() ~= parent then
		Attune_HideDungeonArt()
		local tex = parent:CreateTexture(nil, "BACKGROUND")
		tex:SetAlpha(ATTUNE_DUNGEON_ART_ALPHA)
		tex:Hide()
		attunelocal_dungeonArt = tex
		if not parent.attuneArtSized then
			local prev = parent:GetScript("OnSizeChanged")
			parent:SetScript("OnSizeChanged", function(self, ...)
				if prev then prev(self, ...) end
				Attune_LayoutDungeonArt()
			end)
			parent.attuneArtSized = true
		end
	end
	local fdid = ATTUNE_DUNGEON_ART[tostring(attuneId)]
	if not fdid then
		attunelocal_dungeonArt:Hide()
		return
	end
	attunelocal_dungeonArt:SetTexture(fdid)
	attunelocal_dungeonArt:SetAlpha(ATTUNE_DUNGEON_ART_ALPHA)
	attunelocal_dungeonArt:Show()
	Attune_LayoutDungeonArt()
end

local function Attune_ShowWorkInProgress(show)
	if not show then
		if attunelocal_wipFrame then
			attunelocal_wipFrame:Hide()
			attunelocal_wipFrame:SetParent(nil)
		end
		return
	end
	local parent = attunelocal_scroll and attunelocal_scroll.frame
	if not parent then return end
	if not attunelocal_wipFrame then
		local holder = CreateFrame("Frame", nil, parent)
		holder:SetAllPoints(parent)
		holder:EnableMouse(false)
		local fs = holder:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		fs:SetPoint("CENTER", holder, "CENTER", 0, 0)
		fs:SetJustifyH("CENTER")
		fs:SetFont(GameFontNormal:GetFont(), 22, "")
		fs:SetTextColor(1, 0.82, 0)
		fs:SetShadowColor(0, 0, 0, 1)
		fs:SetShadowOffset(1, -1)
		holder.text = fs
		attunelocal_wipFrame = holder
	end
	if attunelocal_wipFrame:GetParent() ~= parent then
		attunelocal_wipFrame:SetParent(parent)
		attunelocal_wipFrame:SetAllPoints(parent)
	end
	attunelocal_wipFrame:SetFrameLevel((parent:GetFrameLevel() or 0) + 30)
	attunelocal_wipFrame.text:SetText(AttuneLang["Work in progress"] or "Work in progress")
	if show then
		attunelocal_wipFrame:Show()
	else
		attunelocal_wipFrame:Hide()
	end
end

function Attune_Select(attuneId)
	PlaySound(856)  --igMainMenuOptionCheckBoxOn
	Attune_ShowDungeonArt(attuneId)
	Attune_AutoCompleteSpacers(attunelocal_charKey)
	local scrollframe = attunelocal_scroll.content.obj.content

	attunelocal_scroll:ReleaseChildren()

	local att = Attune_DB.toons[attunelocal_charKey]

	-- Display Title
	for i, a in pairs(Attune_Data.attunes) do
		if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
			if (a.ID == attuneId) then

				attunelocal_brokerlabel = a.NAME
				if Attune_DB.toons[attunelocal_charKey].attuned[attuneId] ~= nil then
					attunelocal_brokervalue = Attune_DB.toons[attunelocal_charKey].attuned[attuneId].."%"
				else
					attunelocal_brokervalue = "0%"
				end
				Attune_Broker.text = attunelocal_brokervalue

				local titlebutton = AceGUI:Create("SimpleGroup")
				titlebutton:SetLayout("Flow")
				titlebutton:SetFullWidth(true)

					local label = AceGUI:Create("Label")
					label:SetText(Attune_DisplayName(a))
					label:SetImage(a.ICON)
					label:SetFont(GameFontNormal:GetFont(), 24, "")
					label:SetImageSize(32,32)
					label:SetFullWidth(true)
					titlebutton:AddChild(label)


				attunelocal_scroll:AddChild(titlebutton)

				-- spacer
				local label = AceGUI:Create("Label")
				label:SetText(" ")
				label:SetFullWidth(true)
				label:SetFont(GameFontHighlight:GetFont(), 20, "")
				attunelocal_scroll:AddChild(label)

				-- desc
				local label = AceGUI:Create("Label")
				label:SetText(a.DESC)
				label:SetFullWidth(true)
				label:SetFont(GameFontNormal:GetFont(), 12, "")
				attunelocal_scroll:AddChild(label)
			end
		end
	end

	-- spacer
	local label = AceGUI:Create("Label")
	label:SetText(" ")
	label:SetFullWidth(true)
	label:SetFont(GameFontHighlight:GetFont(), 20, "")
	attunelocal_scroll:AddChild(label)

	-- Fixed top margin: measure AceGUI header (title/desc) so graph sits below it
	-- without that gap shrinking when SetScale zooms the chain.
	if attunelocal_scroll.DoLayout then attunelocal_scroll:DoLayout() end
	attunelocal_graphHeaderOffset = 80
	do
		local st = scrollframe:GetTop()
		if st then
			local maxDist = 0
			for _, child in ipairs(attunelocal_scroll.children or {}) do
				local f = child.frame
				if f and f:IsShown() then
					local b = f:GetBottom()
					if b then
						local d = st - b
						if d > maxDist then maxDist = d end
					end
				end
			end
			if maxDist > 0 then attunelocal_graphHeaderOffset = maxDist + 8 end
		end
	end

	-- Hiding all non-Ace frames (all attune steps basically)
	for i, f in pairs(attunelocal_frames) do	_G[f]:Hide()	end
	if _G["Attune_SideBox"] then _G["Attune_SideBox"]:Hide() end
	if _G["Attune_SideBoxTitle"] then _G["Attune_SideBoxTitle"]:Hide() end

	-- Scaled container for the attune chain (icons, text, lines zoom together)
	if attunelocal_graphRoot == nil then
		attunelocal_graphRoot = CreateFrame("Frame", "Attune_GraphRoot", scrollframe)
	else
		attunelocal_graphRoot:SetParent(scrollframe)
	end
	attunelocal_graphPanX = 0
	attunelocal_graphRoot:ClearAllPoints()
	attunelocal_graphRoot:SetPoint("TOP", scrollframe, "TOP", attunelocal_graphPanX, -attunelocal_graphHeaderOffset)
	attunelocal_graphRoot:SetWidth(1)
	attunelocal_graphRoot:SetHeight(1)
	attunelocal_graphRoot:SetScale(Attune_DB.zoom)
	attunelocal_graphRoot:Show()

	-- Count steps per stage (main chain only; SIDE reminders are placed beside End)
	local stageSteps = {}
	local stageWidthSum = {}
	local sideSteps = {}
	local endInfo = nil
	for i, s in pairs(Attune_Data.steps) do
		if s.ID_ATTUNE == attuneId and showPatchStep(s) then
			if s.SIDE then
				table.insert(sideSteps, s)
			else
				stageSteps[s.STAGE] = (stageSteps[s.STAGE] or 0) + 1
				stageWidthSum[s.STAGE] = (stageWidthSum[s.STAGE] or 0) + Attune_NodeWidth(s)
			end
		end
	end

	-- Half-width of the widest main stage (for pan limits); SIDE width added later
	attunelocal_graphMaxExtent = 0
	for stage, count in pairs(stageSteps) do
		local rowW = stageWidthSum[stage] + math.max(0, count - 1) * attunelocal_Node_HGap
		local half = rowW / 2
		if half > attunelocal_graphMaxExtent then attunelocal_graphMaxExtent = half end
	end

	if next(stageSteps) == nil then
		attunelocal_graphRoot:Hide()
		Attune_ShowWorkInProgress(true)
		attunelocal_scroll.frame:SetScript("OnUpdate", nil)
		return
	end
	Attune_ShowWorkInProgress(false)

	-- Create/position main-chain steps (defer End until SIDE nodes exist for line anchors)
	-- First stage stays at yy=0: top margin is the unscaled header offset outside the zoomed graph.
	-- Steps are visited right-to-left; consumed walks inward from the right edge so HALFSIZE slots pack tighter.
	local yy = 0
	local curStage = 0
	local consumed = 0
	local rightEdge = 0
	local firstStage = true
	for i, s in Attune_spairs(Attune_Data.steps, function(t,a,b) 	return tonumber(t[b].STAGE)*10000 + tonumber(t[b].ID) > tonumber(t[a].STAGE)*10000 + tonumber(t[a].ID) end) do
		if s.ID_ATTUNE == attuneId and showPatchStep(s) and not s.SIDE then
			if s.STAGE ~= curStage then
				consumed = 0
				curStage = s.STAGE
				local count = stageSteps[s.STAGE]
				local rowW = stageWidthSum[s.STAGE] + math.max(0, count - 1) * attunelocal_Node_HGap
				rightEdge = rowW / 2
				if firstStage then
					firstStage = false
				else
					yy = yy + attunelocal_Node_VGap + attunelocal_Node_Height
				end
			end
			local w = Attune_NodeWidth(s)
			local xx = rightEdge - consumed - (w / 2)
			consumed = consumed + w + attunelocal_Node_HGap

			if s.TYPE == "End" then
				endInfo = { step = s, xx = xx, yy = yy }
			else
				Attune_CreateNode(s, attunelocal_graphRoot, xx, yy)
			end
		end
	end

	-- Inside-dungeon reminders: stacked in a box to the left of End, side connector into End
	if endInfo and #sideSteps > 0 then
		table.sort(sideSteps, function(a, b)
			if tonumber(a.STAGE) ~= tonumber(b.STAGE) then
				return tonumber(a.STAGE) < tonumber(b.STAGE)
			end
			return tonumber(a.ID) > tonumber(b.ID)
		end)

		local n = #sideSteps
		local pad = attunelocal_Side_Pad
		local sideVGap = attunelocal_Side_VGap
		local boxGap = attunelocal_Side_BoxGap
		local innerH = n * attunelocal_Node_Height + (n - 1) * sideVGap
		local boxW = attunelocal_Node_Width + pad * 2
		local boxH = innerH + pad * 2
		-- Drop Complete below the main chain so the Inside box has room (title + box)
		-- local endY = endInfo.yy + attunelocal_Node_VGap + attunelocal_Node_Height
        local endY = endInfo.yy + (attunelocal_Node_VGap + attunelocal_Node_Height) / 2
		local colX = endInfo.xx - (Attune_NodeWidth(endInfo.step) / 2 + boxGap + pad + attunelocal_Node_Width / 2)
		local firstY = endY

		-- Backdrop box behind the Inside quests
		local boxName = "Attune_SideBox"
		local existBox = false
		for _, f in ipairs(attunelocal_frames) do if f == boxName then existBox = true end end
		local sideBox
		if existBox then
			sideBox = _G[boxName]
		else
			sideBox = CreateFrame("Frame", boxName, attunelocal_graphRoot, BackdropTemplateMixin and "BackdropTemplate" or nil)
			table.insert(attunelocal_frames, boxName)
		end
		sideBox:SetParent(attunelocal_graphRoot)
		sideBox:SetWidth(boxW)
		sideBox:SetHeight(boxH)
		sideBox:ClearAllPoints()
		sideBox:SetPoint("TOP", attunelocal_graphRoot, "TOP", colX, -(firstY - pad))
		sideBox:SetBackdrop({
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 3, right = 3, top = 3, bottom = 3 }
		})
		sideBox:SetBackdropColor(0.04, 0.04, 0.06, 0.55)
		sideBox:SetBackdropBorderColor(0.55, 0.55, 0.60, 0.95)
		sideBox:SetFrameLevel((attunelocal_graphRoot:GetFrameLevel() or 0) + 1)
		sideBox:Show()

		-- Title above the box
		local titleName = "Attune_SideBoxTitle"
		local existTitle = false
		for _, f in ipairs(attunelocal_frames) do if f == titleName then existTitle = true end end
		local sideTitle
		if existTitle then
			sideTitle = _G[titleName]
		else
			sideTitle = sideBox:CreateFontString(titleName)
			table.insert(attunelocal_frames, titleName)
		end
		sideTitle:SetFont(GameFontNormal:GetFont(), 10, "")
		sideTitle:SetText("|cffffd100"..(AttuneLang["Inside the dungeon"] or "Inside the dungeon").."|r")
		sideTitle:ClearAllPoints()
		sideTitle:SetPoint("BOTTOMLEFT", sideBox, "TOPLEFT", 6, 2)
		sideTitle:Show()

		for i, s in ipairs(sideSteps) do
			local sy = firstY + (i - 1) * (attunelocal_Node_Height + sideVGap)
			Attune_CreateNode(s, attunelocal_graphRoot, colX, sy)
			local node = _G["Attune_Node_"..s.ID]
			if node then
				node:SetFrameLevel((sideBox:GetFrameLevel() or 0) + 2)
			end
		end

		local sideExtent = math.abs(colX) + boxW / 2
		if sideExtent > attunelocal_graphMaxExtent then attunelocal_graphMaxExtent = sideExtent end

		local sideBottom = firstY + (n - 1) * (attunelocal_Node_Height + sideVGap) + attunelocal_Node_Height + pad
		local endBottom = endY + attunelocal_Node_Height
		local contentBottom = math.max(sideBottom, endBottom)
		-- Spacer below Complete / Inside
		contentBottom = contentBottom + attunelocal_Node_VGap + attunelocal_Node_Height
		if contentBottom > yy then yy = contentBottom end

		Attune_CreateNode(endInfo.step, attunelocal_graphRoot, endInfo.xx, endY)
		Attune_DrawSideFeeder(endInfo.step, sideSteps, colX, boxW, endInfo.xx, endY)
	elseif endInfo then
		Attune_CreateNode(endInfo.step, attunelocal_graphRoot, endInfo.xx, endInfo.yy)
		-- Spacer below Complete
		local endBottom = endInfo.yy + attunelocal_Node_Height + attunelocal_Node_VGap + attunelocal_Node_Height
		if endBottom > yy then yy = endBottom end
	end

	-- Ace 'mask' needed to trick the scroller into the right size, as it doesn't detect the custom frames.
	-- Chain height is scaled so the scrollbar matches the visual (zoomed) size.
	attunelocal_graphHeight = yy
	attunelocal_contentHeight = (yy * Attune_DB.zoom) + 50
	local mask = AceGUI:Create("SimpleGroup")
	mask:SetAutoAdjustHeight(false)
	mask:SetHeight(attunelocal_contentHeight)
	mask:SetFullWidth(true)
	mask.frame:EnableMouse(true)
	mask.frame:SetScript("OnEnter", function()
		if attunelocal_frame then attunelocal_frame:SetStatusText(AttuneLang["Pan_DESC"] or attunelocal_statusText) end
	end)
	mask.frame:SetScript("OnLeave", function()
		if not attunelocal_graphDragging and attunelocal_frame then
			attunelocal_frame:SetStatusText(attunelocal_statusText)
		end
	end)
	Attune_SetupGraphPanTarget(mask.frame)
	attunelocal_scroll:AddChild(mask)

	Attune_UpdateGraphPanLimits()
	Attune_HookGraphPanMouseWheel()

	-- This script needed to allow the scrollframe resize whenever content changes or vertical size is moved
	attunelocal_scroll.frame:SetScript("OnUpdate", function(self)
		attunelocal_scroll:SetHeight(attunelocal_contentHeight)
		local w = attunelocal_scroll.scrollframe and attunelocal_scroll.scrollframe:GetWidth() or 0
		if self._attuneLastPanW ~= w then
			self._attuneLastPanW = w
			if not attunelocal_graphDragging then
				Attune_UpdateGraphPanLimits()
			end
		end
	end)



end

-------------------------------------------------------------------------
-- Horizontal pan: apply offset / clamp to view
-------------------------------------------------------------------------

function Attune_ApplyGraphPan()
	if not attunelocal_graphRoot or not attunelocal_scroll then return end
	local scrollframe = attunelocal_scroll.content and attunelocal_scroll.content.obj and attunelocal_scroll.content.obj.content
	if not scrollframe then return end
	if attunelocal_graphPanX > attunelocal_graphMaxPanX then attunelocal_graphPanX = attunelocal_graphMaxPanX end
	if attunelocal_graphPanX < -attunelocal_graphMaxPanX then attunelocal_graphPanX = -attunelocal_graphMaxPanX end
	attunelocal_graphRoot:ClearAllPoints()
	attunelocal_graphRoot:SetPoint("TOP", scrollframe, "TOP", attunelocal_graphPanX, -(attunelocal_graphHeaderOffset or 0))
end

function Attune_UpdateGraphPanLimits()
	if not attunelocal_scroll then return end
	local viewW = 400
	if attunelocal_scroll.scrollframe then
		viewW = attunelocal_scroll.scrollframe:GetWidth() or viewW
	elseif attunelocal_scroll.frame then
		viewW = attunelocal_scroll.frame:GetWidth() or viewW
	end
	local zoom = Attune_DB.zoom or 1
	-- How far past the view edge the widest stage extends (plus a little padding)
	attunelocal_graphMaxPanX = math.max(0, (attunelocal_graphMaxExtent * zoom) - (viewW / 2) + 60)
	Attune_ApplyGraphPan()
end

function Attune_StartGraphPan(frame)
	attunelocal_graphDragging = true
	local x, y = GetCursorPosition()
	attunelocal_graphDragLastX, attunelocal_graphDragLastY = x, y
	if frame then
		frame:SetScript("OnUpdate", Attune_GraphPan_OnUpdate)
	end
	if attunelocal_frame then
		attunelocal_frame:SetStatusText(AttuneLang["Pan_DESC"] or attunelocal_statusText)
	end
end

function Attune_StopGraphPan(frame)
	attunelocal_graphDragging = false
	if frame then
		frame:SetScript("OnUpdate", nil)
	end
	if attunelocal_frame then
		attunelocal_frame:SetStatusText(attunelocal_statusText)
	end
end

function Attune_GraphPan_OnUpdate(frame)
	if not attunelocal_graphDragging then return end
	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	local dx = (x - attunelocal_graphDragLastX) / scale
	local dy = (y - attunelocal_graphDragLastY) / scale
	attunelocal_graphDragLastX, attunelocal_graphDragLastY = x, y

	attunelocal_graphPanX = attunelocal_graphPanX + dx
	Attune_ApplyGraphPan()

	-- Vertical: drag also moves the Ace scrollbar so the whole chain follows the cursor
	if attunelocal_scroll and attunelocal_scroll.scrollbar and attunelocal_scroll.scrollBarShown then
		local contentH = attunelocal_scroll.content:GetHeight() or 0
		local viewH = attunelocal_scroll.scrollframe:GetHeight() or 1
		local diff = contentH - viewH
		if diff > 0 then
			local status = attunelocal_scroll.status or attunelocal_scroll.localstatus
			local offset = (status and status.offset or 0) + dy
			if offset < 0 then offset = 0 end
			if offset > diff then offset = diff end
			local value = offset / diff * 1000
			attunelocal_scroll.scrollbar:SetValue(value)
		end
	end
end

function Attune_SetupGraphPanTarget(frame, keepMouseUp)
	if not frame then return end
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		Attune_StartGraphPan(self)
	end)
	frame:SetScript("OnDragStop", function(self)
		Attune_StopGraphPan(self)
	end)
	if not keepMouseUp then
		frame:SetScript("OnMouseUp", function(self)
			if attunelocal_graphDragging then Attune_StopGraphPan(self) end
		end)
	end
end

function Attune_HookGraphPanMouseWheel()
	if attunelocal_graphPanHooked or not attunelocal_scroll or not attunelocal_scroll.scrollframe then return end
	local sf = attunelocal_scroll.scrollframe
	local prev = sf:GetScript("OnMouseWheel")
	sf:SetScript("OnMouseWheel", function(frame, delta)
		if IsShiftKeyDown() then
			attunelocal_graphPanX = attunelocal_graphPanX + delta * 50
			Attune_UpdateGraphPanLimits()
		elseif prev then
			prev(frame, delta)
		end
	end)
	attunelocal_graphPanHooked = true
end

-------------------------------------------------------------------------
-- Apply zoom to the graph container and update scroll height (no rebuild)
-------------------------------------------------------------------------

function Attune_ApplyGraphZoom(zoom)
	if zoom < attunelocal_Zoom_Min then zoom = attunelocal_Zoom_Min end
	if zoom > attunelocal_Zoom_Max then zoom = attunelocal_Zoom_Max end
	Attune_DB.zoom = zoom
	if attunelocal_graphRoot then
		attunelocal_graphRoot:SetScale(zoom)
	end
	attunelocal_contentHeight = (attunelocal_graphHeight * zoom) + 50
	Attune_UpdateGraphPanLimits()
end

-------------------------------------------------------------------------
-- Fixed zoom slider overlay (top-right of the attune panel, does not scroll)
-------------------------------------------------------------------------

function Attune_ReleaseZoomSlider()
	if attunelocal_zoomSlider then
		attunelocal_zoomSlider:Release()
		attunelocal_zoomSlider = nil
	end
end

function Attune_CreateZoomSlider()
	Attune_ReleaseZoomSlider()
	local parent = attunelocal_scroll and attunelocal_scroll.frame or (attunelocal_right and attunelocal_right.frame)
	if not parent then return end

	local slider = AceGUI:Create("Slider")
	slider:SetWidth(160)
	slider:SetHeight(44)
	slider:SetLabel(AttuneLang["Zoom"])
	slider:SetIsPercent(true)
	slider:SetSliderValues(attunelocal_Zoom_Min, attunelocal_Zoom_Max, attunelocal_Zoom_Step)
	slider:SetValue(Attune_DB.zoom)
	slider:SetCallback("OnValueChanged", function(slid)
		Attune_ApplyGraphZoom(slid:GetValue())
	end)

	local f = slider.frame
	f:SetParent(parent)
	f:ClearAllPoints()
	-- Outer scroll frame does not move with content; pin flush to its right edge
	f:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -26, -2)
	f:SetFrameStrata(parent:GetFrameStrata())
	f:SetFrameLevel((parent:GetFrameLevel() or 0) + 50)
	f:Show()

	attunelocal_zoomSlider = slider
end

-------------------------------------------------------------------------

function showPatchStep(s)
	local showStep = false
	if (s.VALIDFROM == nil and s.VALIDTO == nil) then 
		showStep = true
	else
		if (s.VALIDFROM ~= nil and patch >= s.VALIDFROM) then showStep = true end
		if (s.VALIDTO ~= nil and patch < s.VALIDTO) then showStep = true end
	end
	return showStep
end

-------------------------------------------------------------------------
-- Look up a step / detect SIDE (Inside) steps
-------------------------------------------------------------------------

function Attune_FindStep(attuneId, stepId)
	for _, s in pairs(Attune_Data.steps) do
		if s.ID_ATTUNE == attuneId and s.ID == tostring(stepId) then
			return s
		end
	end
	return nil
end

function Attune_IsSideStep(attuneId, stepId)
	local s = Attune_FindStep(attuneId, stepId)
	return s ~= nil and s.SIDE
end

-------------------------------------------------------------------------
-- Horizontal feeder from the Inside-quests box into the End node
-------------------------------------------------------------------------

function Attune_DrawSideFeeder(endStep, sideSteps, colX, boxW, endX, endY)
	local endNode = _G["Attune_Node_"..endStep.ID]
	if not endNode then return end

	local sideFollowIds = {}
	local fIDs = Attune_split(endStep.FOLLOWS, "&")
	if string.find(endStep.FOLLOWS, "|") then fIDs = Attune_split(endStep.FOLLOWS, "|") end
	for _, flw in pairs(fIDs) do
		if Attune_IsSideStep(endStep.ID_ATTUNE, flw) then
			table.insert(sideFollowIds, flw)
		end
	end
	if #sideFollowIds == 0 then return end

	local allDone, anyDone = true, false
	for _, flw in ipairs(sideFollowIds) do
		if Attune_DB.toons[attunelocal_charKey].done[endStep.ID_ATTUNE .. "-" .. flw] then
			anyDone = true
		else
			allDone = false
		end
	end

	local lineName = "Attune_SideFeeder_"..endStep.ID
	local exist = false
	for _, f in ipairs(attunelocal_frames) do if f == lineName then exist = true end end
	local line
	if exist then
		line = _G[lineName]
	else
		line = endNode:CreateLine(lineName)
		table.insert(attunelocal_frames, lineName)
	end

	local endDone = Attune_DB.toons[attunelocal_charKey].done[endStep.ID_ATTUNE .. "-" .. endStep.ID]
		or ((Attune_DB.toons[attunelocal_charKey].attuned[endStep.ID_ATTUNE] or 0) >= 100)
	if endDone and allDone then
		line:SetColorTexture(0.388, 0.686, 0.388, 1)
		line:SetDrawLayer("ARTWORK", 2)
	elseif anyDone then
		line:SetColorTexture(0.851, 0.608, 0.0, 1)
		line:SetDrawLayer("ARTWORK", 1)
	else
		line:SetColorTexture(0.45, 0.45, 0.45, 1)
		line:SetDrawLayer("ARTWORK", 0)
	end
	line:SetThickness(attunelocal_Line_Thickness)

	-- Horizontal: box right edge → End left edge, at End vertical mid
	local boxRightX = colX + boxW / 2
	local midY = -attunelocal_Node_Height / 2
	line:SetStartPoint("TOP", boxRightX - endX, midY)
	line:SetEndPoint("TOP", -Attune_NodeWidth(endStep) / 2, midY)
	line:Show()
end

-------------------------------------------------------------------------
-- Create the frame for a single attune step (node)
-------------------------------------------------------------------------

local attunelocal_mapNameCache

local function Attune_MapIdForName(name)
	if not name or name == "" or not C_Map or not C_Map.GetMapChildrenInfo then return nil end
	if not attunelocal_mapNameCache then
		attunelocal_mapNameCache = {}
		for _, root in ipairs({ 947, 1414, 1415, 1463, 1464 }) do
			local children = C_Map.GetMapChildrenInfo(root, nil, true)
			if children then
				for _, info in ipairs(children) do
					if info.name and not attunelocal_mapNameCache[info.name] then
						attunelocal_mapNameCache[info.name] = info.mapID
					end
				end
			end
		end
	end
	return attunelocal_mapNameCache[name]
end

local function Attune_QuestIdFromStep(step)
	local questId = tonumber(step.ID_WOWHEAD)
	if not questId and step.ID_WOWHEAD and string.find(step.ID_WOWHEAD, "|", 1, true) then
		questId = tonumber(Attune_split(step.ID_WOWHEAD, "|")[1])
	end
	return questId
end

local attunelocal_openedQuestMap

local function Attune_CloseQuestGiverMap()
	if not attunelocal_openedQuestMap then return end
	attunelocal_openedQuestMap = nil
	if WorldMapFrame and WorldMapFrame:IsShown() then
		if ToggleWorldMap then ToggleWorldMap() else WorldMapFrame:Hide() end
	end
end

local function Attune_ShowQuestGiverMap(step)
	local questId = Attune_QuestIdFromStep(step)
	local loc = questId and Attune_Data.questGivers and Attune_Data.questGivers[questId]
	local uiMapID = loc and loc[1]
	local x, y = loc and loc[2], loc and loc[3]
	if uiMapID and C_Map and C_Map.GetMapInfo and not C_Map.GetMapInfo(uiMapID) then
		uiMapID, x, y = nil, nil, nil
	end
	if not uiMapID then
		uiMapID = Attune_MapIdForName(step.LOCATION)
		x, y = nil, nil
	end
	if not uiMapID then return end

	local wasShown = WorldMapFrame and WorldMapFrame:IsShown()
	if OpenWorldMap then
		OpenWorldMap(uiMapID)
	elseif WorldMapFrame then
		if not wasShown then ToggleWorldMap() end
		if WorldMapFrame.SetMapID then WorldMapFrame:SetMapID(uiMapID) end
	end
	if not wasShown then attunelocal_openedQuestMap = true end

	if x and y and C_Map and C_Map.SetUserWaypoint and UiMapPoint and C_Map.CanSetUserWaypointOnMap and C_Map.CanSetUserWaypointOnMap(uiMapID) then
		C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(uiMapID, x / 100, y / 100))
		if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			C_SuperTrack.SetSuperTrackedUserWaypoint(true)
		end
	end
end

local attunelocal_giverTip
local attunelocal_giverTipGap = 6

local function Attune_HideQuestGiverTip()
	if attunelocal_giverTip then attunelocal_giverTip:Hide() end
end

local function Attune_ShowQuestGiverTip(step, anchor)
	local questId = Attune_QuestIdFromStep(step)
	local loc = questId and Attune_Data.questGivers and Attune_Data.questGivers[questId]
	local name = loc and loc[4]
	if not name or name == "" then
		name = AttuneLang["Q1_"..step.ID_WOWHEAD]
	end

	if not attunelocal_giverTip then
		attunelocal_giverTip = CreateFrame("GameTooltip", "AttuneGiverTip", UIParent, "GameTooltipTemplate")
		attunelocal_giverTip:SetFrameStrata("TOOLTIP")
	end

	local tip = attunelocal_giverTip
	local target = GameTooltip:GetWidth() or 0
	tip:SetOwner(anchor, "ANCHOR_NONE")
	tip:ClearLines()
	if tip.SetMinimumWidth then tip:SetMinimumWidth(0) end
	tip:SetText("|cffffffff"..AttuneLang["Starts at"].." |r"..(name or ""))
	tip:AddLine(AttuneLang["Click to show map"], 0.6, 0.6, 0.6, true)
	tip:Show()
	-- Match the quest tooltip's outer width unless this bubble's own text is already wider.
	-- SetMinimumWidth adds padding on top of the number you pass, so measure and correct once.
	local natural = tip:GetWidth() or 0
	if tip.SetMinimumWidth and target > 0 and natural > 0 and natural <= target + 1 then
		tip:SetMinimumWidth(target)
		tip:Show()
		local overshoot = (tip:GetWidth() or target) - target
		if math.abs(overshoot) > 1 then
			tip:SetMinimumWidth(math.max(1, target - overshoot))
			tip:Show()
		end
	end
	-- Showing a second tooltip can hide the quest summary. Put it back, then stack them.
	GameTooltip:Show()
	tip:ClearAllPoints()
	tip:SetPoint("TOPLEFT", anchor, "TOPRIGHT", 10, 0)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", tip, "BOTTOMLEFT", 0, -attunelocal_giverTipGap)
end

-- Quest and item cells do not use the "you are on this step" highlight.
-- Quests: grey until accepted. Pick Up and Quest cells are yellow while in the log. Turn In stays grey until the required items are in hand (then yellow) or the quest is complete (then green). When those items are in hand, Pick Up turns green too. A completed quest is green on Pick Up, Quest, and Turn In.
-- Items: grey at 0, yellow for a partial stack, green at the full count or when the quest they feed is complete.
local attuneFollowerCache

local function Attune_FollowIDs(follows)
	if follows == nil or follows == "" or follows == "0" then return {} end
	local sep = "&"
	if string.find(follows, "|", 1, true) then sep = "|" end
	return Attune_split(follows, sep)
end

local function Attune_FollowersOf(attuneId, stepId)
	if attuneFollowerCache == nil then
		attuneFollowerCache = {}
		for _, s in pairs(Attune_Data.steps) do
			if showPatchStep(s) then
				local byAttune = attuneFollowerCache[s.ID_ATTUNE]
				if byAttune == nil then
					byAttune = {}
					attuneFollowerCache[s.ID_ATTUNE] = byAttune
				end
				for _, flw in ipairs(Attune_FollowIDs(s.FOLLOWS)) do
					local list = byAttune[flw]
					if list == nil then
						list = {}
						byAttune[flw] = list
					end
					table.insert(list, s)
				end
			end
		end
	end
	local byAttune = attuneFollowerCache[attuneId]
	if byAttune == nil then return nil end
	return byAttune[tostring(stepId)]
end

local function Attune_SameQuestId(step, qid)
	if step.ID_WOWHEAD == nil then return false end
	local wanted = tostring(qid)
	if step.ID_WOWHEAD == wanted then return true end
	if string.find(step.ID_WOWHEAD, "|", 1, true) then
		for _, part in ipairs(Attune_split(step.ID_WOWHEAD, "|")) do
			if part == wanted then return true end
		end
	end
	return false
end

local function Attune_IsQuestFlaggedCompleted(qid)
	if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
		local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, qid)
		if ok and done then return true end
	end
	if IsQuestFlaggedCompleted then
		local ok, done = pcall(IsQuestFlaggedCompleted, qid)
		if ok and done then return true end
	end
	return false
end

-- A saved Quest or Turn In step counts as completion for every cell of that quest.
-- Pick Up is saved as done on accept, so its own flag is not completion.
local function Attune_QuestRecordedComplete(attuneId, qid, doneMap)
	if not doneMap or not attuneId then return false end
	for _, s in pairs(Attune_Data.steps) do
		if s.ID_ATTUNE == attuneId and (s.TYPE == "Quest" or s.TYPE == "Turn In") and doneMap[s.ID_ATTUNE .. "-" .. s.ID] and Attune_SameQuestId(s, qid) then
			return true
		end
	end
	return false
end

-- completed, active (in the quest log, not turned in)
local function Attune_QuestState(idWowhead, attuneId)
	local completed, active = false, false
	local qIDs = Attune_split(tostring(idWowhead or ""), "|")
	local doneMap = Attune_DB.toons[attunelocal_charKey] and Attune_DB.toons[attunelocal_charKey].done
	for _, q in ipairs(qIDs) do
		local qid = tonumber(q)
		if qid then
			local onQuest = C_QuestLog and C_QuestLog.IsOnQuest and C_QuestLog.IsOnQuest(qid)
			if onQuest then
				-- Still in the log, so this step is not turned in.
				active = true
			elseif Attune_IsQuestFlaggedCompleted(qid) or Attune_QuestRecordedComplete(attuneId, qid, doneMap) then
				completed = true
			end
		end
	end
	if active then completed = false end
	return completed, active
end

local function Attune_OwnedItemCount(itemId)
	local count = 0
	if GetItemCount then
		count = GetItemCount(itemId, true) or 0
		if count == 0 then
			local alias
			if itemId == "185686" then alias = "30637" -- Thrallmar
			elseif itemId == "185687" then alias = "30622" -- Honor Hold
			elseif itemId == "185690" then alias = "30623" -- Cenarion
			elseif itemId == "185691" then alias = "30633" -- Lower City
			elseif itemId == "185692" then alias = "30634" -- Shatar
			elseif itemId == "185693" then alias = "30635" -- KoT
			end
			if alias then count = GetItemCount(alias, true) or 0 end
		end
	end
	return count
end

local function Attune_StepsShareQuest(a, b)
	if a.ID_WOWHEAD == nil or b.ID_WOWHEAD == nil then return false end
	if a.ID_WOWHEAD == b.ID_WOWHEAD then return true end
	local ids = {}
	for _, q in ipairs(Attune_split(tostring(a.ID_WOWHEAD), "|")) do
		ids[q] = true
	end
	for _, q in ipairs(Attune_split(tostring(b.ID_WOWHEAD), "|")) do
		if ids[q] then return true end
	end
	return false
end

-- Pick Up and Turn In of the same quest, with every item between them fully collected.
local function Attune_SplitItemsReady(step)
	if step.TYPE ~= "Pick Up" and step.TYPE ~= "Turn In" then return false end

	local turnIns, pickUpIds = {}, {}
	local hasPickUp = false
	for _, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) and s.ID_ATTUNE == step.ID_ATTUNE and Attune_StepsShareQuest(s, step) then
			if s.TYPE == "Turn In" then
				turnIns[#turnIns + 1] = s
			elseif s.TYPE == "Pick Up" then
				pickUpIds[s.ID] = true
				hasPickUp = true
			end
		end
	end
	if not hasPickUp or #turnIns == 0 then return false end

	local items, seen = {}, {}
	local function walk(id)
		if id == nil or id == "" or id == "0" or seen[id] or pickUpIds[id] then return end
		seen[id] = true
		local s = Attune_FindStep(step.ID_ATTUNE, id)
		if not s then return end
		if s.TYPE == "Item" then items[#items + 1] = s end
		for _, flw in ipairs(Attune_FollowIDs(s.FOLLOWS)) do
			walk(flw)
		end
	end
	for _, turnIn in ipairs(turnIns) do
		for _, flw in ipairs(Attune_FollowIDs(turnIn.FOLLOWS)) do
			walk(flw)
		end
	end
	if #items == 0 then return false end

	for _, item in ipairs(items) do
		local need = 1
		if item.COUNT ~= nil then need = item.COUNT end
		if Attune_OwnedItemCount(item.ID_WOWHEAD) < need then return false end
	end
	return true
end

local function Attune_QuestCellTone(step)
	local completed, active = Attune_QuestState(step.ID_WOWHEAD, step.ID_ATTUNE)
	if not completed and not active and step.TYPE ~= "Pick Up" then
		local doneMap = Attune_DB.toons[attunelocal_charKey] and Attune_DB.toons[attunelocal_charKey].done
		if doneMap and doneMap[step.ID_ATTUNE .. "-" .. step.ID] then
			completed = true
		end
	end
	-- Completed quests are green on Pick Up, Quest, and Turn In alike.
	if completed then return "green" end
	-- Required items are in hand: Pick Up is done, Turn In is ready.
	if Attune_SplitItemsReady(step) then
		if step.TYPE == "Turn In" then return "yellow" end
		return "green"
	end
	-- Turn In stays grey until the items are in hand or the quest is complete.
	if active and step.TYPE ~= "Turn In" then return "yellow" end
	return "grey"
end

-- True when a quest this item leads into (skipping kills, clicks, other items) is complete.
local function Attune_ItemQuestCompleted(step)
	local seen = {}
	local queue = { step.ID }
	local i = 1
	while queue[i] do
		local id = queue[i]
		i = i + 1
		if not seen[id] then
			seen[id] = true
			local followers = Attune_FollowersOf(step.ID_ATTUNE, id)
			if followers then
				for _, s in ipairs(followers) do
					if s.TYPE == "Quest" or s.TYPE == "Pick Up" or s.TYPE == "Turn In" then
						local completed = Attune_QuestState(s.ID_WOWHEAD, s.ID_ATTUNE)
						if completed then return true end
					elseif s.TYPE ~= "End" and s.TYPE ~= "Attune" then
						queue[#queue + 1] = s.ID
					end
				end
			end
		end
	end
	return false
end

local function Attune_ItemCellTone(step, countNeeded)
	if Attune_ItemQuestCompleted(step) then return "green" end
	local owned = Attune_OwnedItemCount(step.ID_WOWHEAD)
	if owned >= countNeeded then return "green" end
	if owned > 0 then return "yellow" end
	return "grey"
end

local function Attune_CellTone(step)
	if step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
		return Attune_QuestCellTone(step)
	elseif step.TYPE == "Item" then
		local countNeeded = 1
		if step.COUNT ~= nil then countNeeded = step.COUNT end
		return Attune_ItemCellTone(step, countNeeded)
	end
	return nil
end

-- complete, ready: ready includes a yellow in-progress step (items in hand, quest not turned in)
local function Attune_StepLineState(step, seen)
	if step == nil then return false, false end
	seen = seen or {}
	if seen[step.ID] then return false, false end
	seen[step.ID] = true

	local doneMap = Attune_DB.toons[attunelocal_charKey] and Attune_DB.toons[attunelocal_charKey].done
	local key = step.ID_ATTUNE .. "-" .. step.ID

	if step.TYPE == "Spacer" then
		local anyReady = false
		for _, flw in ipairs(Attune_FollowIDs(step.FOLLOWS)) do
			local prev = Attune_FindStep(step.ID_ATTUNE, flw)
			if prev then
				local prevComplete, prevReady = Attune_StepLineState(prev, seen)
				if prevComplete or prevReady then anyReady = true end
			elseif doneMap and doneMap[step.ID_ATTUNE .. "-" .. flw] then
				anyReady = true
			end
		end
		if doneMap and doneMap[key] then return true, true end
		return false, anyReady
	end

	local tone = Attune_CellTone(step)
	if tone == "green" then return true, true end
	if tone == "yellow" then return false, true end
	if tone == nil and doneMap and doneMap[key] then return true, true end
	return false, false
end

local function Attune_ApplyLineColor(line, curComplete, srcComplete, srcReady)
	if curComplete and srcComplete then
		line:SetColorTexture(0.388, 0.686, 0.388, 1) -- green
		line:SetDrawLayer("ARTWORK", 2)
	elseif srcComplete or srcReady then
		line:SetColorTexture(0.851, 0.608, 0.0, 1) -- yellow
		line:SetDrawLayer("ARTWORK", 1)
	else
		line:SetColorTexture(0.45, 0.45, 0.45, 1)
		line:SetDrawLayer("ARTWORK", 0)
	end
end

local function Attune_SetNodeTone(fnode, tone)
	if tone == "green" then
		fnode:SetBackdropColor(0.373, 0.729, 0.275, 0.3)
		fnode:SetBackdropBorderColor(0.373, 0.729, 0.275)
	elseif tone == "yellow" then
		fnode:SetBackdropColor(0.851, 0.608, 0.0, 0.3)
		fnode:SetBackdropBorderColor(0.851, 0.608, 0.0, 1)
	else
		fnode:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
		fnode:SetBackdropBorderColor(0.4, 0.4, 0.4)
	end
end

function Attune_CreateNode(step, parent, posX, posY)
	-- Generic look and feel for the node
	local PaneBackdrop  = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}

	local countSameStep = 0
	local countCompleted = 0
	local listSameStep = ""
	local listCompleted = ""
	local dots1 = false
	local dots2 = false
	--calculate guildmembers on this stage
	for kt, t in Attune_spairs(Attune_DB.toons, function(t,a,b) return b > a end) do

		local filter = false

		if  Attune_DB.showListAlt then
			--show alts
			if t.owner == 1 then filter = true end
		else
			--show guildies
			if t.guild == attunelocal_myguild then filter = true end
		end

		if filter then
			-- calculate how many other toon has this step marked as IsNext
			if kt ~= attunelocal_charKey then
				if t.next ~= nil then
					if t.next[step.ID_ATTUNE .. "-" .. step.ID] ~= nil then
						countSameStep = countSameStep + 1
						if countSameStep <= tonumber(Attune_DB.maxListSize) then
							listSameStep = listSameStep .. "\n" .. Attune_split(kt, "-")[1]
						else
							if dots1 == false then
								listSameStep = listSameStep .. "\n..."
								dots1 = true
							end
						end

					end
				end
			end
			-- calculate how many toons have completed this attune
			if step.TYPE == "End" then
				if t.attuned ~= nil then
					if t.attuned[step.ID_ATTUNE] ~= nil then 
						if t.attuned[step.ID_ATTUNE] >= 100 then
							countCompleted = countCompleted + 1
							if countCompleted <= tonumber(Attune_DB.maxListSize) then
								listCompleted = listCompleted .. "\n" .. Attune_split(kt, "-")[1]
							else
								if dots2 == false then
									listCompleted = listCompleted .. "\n..."
									dots2 = true
								end
							end
						end
					end
				end
			end
		end
	end

	if  Attune_DB.showListAlt then
		if listSameStep ~= "" then
			listSameStep = "\n\n|cff00ff00"..AttuneLang["Alts on this step"]..":|r" .. listSameStep
		end
		if listCompleted ~= "" then
			listCompleted = "\n\n|cff00ff00"..AttuneLang["Attuned alts"]..":|r" .. listCompleted
		end
	else
		if listSameStep ~= "" then
			listSameStep = "\n\n|cff00ff00"..AttuneLang["Guild members on this step"]..":|r" .. listSameStep
		end
		if listCompleted ~= "" then
			listCompleted = "\n\n|cff00ff00"..AttuneLang["Attuned guild members"]..":|r" .. listCompleted
		end
	end



	-- check whether the step has been done
	if Attune_DB.toons[attunelocal_charKey].done == nil then Attune_DB.toons[attunelocal_charKey].done = {}  end
	local done = Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. step.ID]

	local countNeeded = 1
	if step.COUNT ~= nil then countNeeded = step.COUNT end

	-- main node frame, reuse if possible
	local fnode
	local exist = false
	for _, f in ipairs(attunelocal_frames) do if f == "Attune_Node_"..step.ID then exist = true end end
	if exist then 	fnode = _G["Attune_Node_"..step.ID] -- reusing
	else			fnode = CreateFrame("Button", "Attune_Node_"..step.ID, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
					table.insert(attunelocal_frames, "Attune_Node_"..step.ID) -- recording, to reuse
	end
	fnode:SetParent(parent)
	local nodeWidth = Attune_NodeWidth(step)
	fnode:SetWidth(nodeWidth)
	fnode:SetHeight(attunelocal_Node_Height)
	fnode:SetPoint("TOP", posX, -posY)
	fnode:SetScript("OnMouseUp", function(self, button) end)
	Attune_SetupGraphPanTarget(fnode, true)
	fnode:SetScript("OnEnter", function()

		-- put full step info in status bar
		--if step.TYPE ~= "Spacer" then attunelocal_frame:SetStatusText(step.STEP) end

		-- display Item link or quest tooltip on hover
		if step.TYPE == "Item" then
			if countNeeded == 1 then
				attunelocal_frame:SetStatusText(AttuneLang["I_"..step.ID_WOWHEAD])
			else
				attunelocal_frame:SetStatusText(AttuneLang["I_"..step.ID_WOWHEAD] .. " (" .. Attune_OwnedItemCount(step.ID_WOWHEAD) .. "/" .. countNeeded .. ")")
			end
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetHyperlink("item:"..step.ID_WOWHEAD)

			fnode:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then Attune_ShowWebsiteURL("item=" .. step.ID_WOWHEAD)	end
			end)

		elseif step.TYPE == "End" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetText(AttuneLang["AttuneColors"])
			if listCompleted ~= "" and Attune_DB.showList then GameTooltip:AddLine(listCompleted, 1, 1, 1, 1) end

		elseif step.TYPE == "Level" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetText(AttuneLang["Minimum Level"])

		elseif step.TYPE == "Rep" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local tempRep = Attune_DB.toons[attunelocal_charKey].reps[step.LOCATION].earned
			local tempGoal = step.ID_WOWHEAD
			if tonumber(tempRep) > tonumber(step.ID_WOWHEAD) then tempRep = step.ID_WOWHEAD end

			attunelocal_frame:SetStatusText("" .. Attune_DB.toons[attunelocal_charKey].reps[step.LOCATION].name)
			GameTooltip:SetText("" .. Attune_DB.toons[attunelocal_charKey].reps[step.LOCATION].name)
			GameTooltip:AddLine(AttuneLang["Current progress"]..": ".. tempRep .. "/" ..step.ID_WOWHEAD, 0.5, 0.5, 0.5, 1)
			if step.OFFSET ~= nil then
				tempGoal = step.ID_WOWHEAD + step.OFFSET
				tempRep = tempRep + step.OFFSET
			end
			GameTooltip:AddLine(AttuneLang["Completion"]..": " .. math.floor(100*tonumber(tempRep)/tonumber(tempGoal)).."%", 0.5, 0.5, 0.5, 1)

			fnode:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then Attune_ShowWebsiteURL("faction=" .. step.LOCATION)	end
			end)

		elseif step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
			attunelocal_frame:SetStatusText(AttuneLang["Q1_"..step.ID_WOWHEAD])
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)

			local quest = Attune_Data.quests[tonumber(step.ID_WOWHEAD)]
			if string.find(step.ID_WOWHEAD, "|") then 
				quest = Attune_Data.quests[tonumber(Attune_split(step.ID_WOWHEAD, "|")[1])]
			end
			if quest == nil then
				-- error message if quest is not in AttuneData.lua
				GameTooltip:SetText(AttuneLang["Quest information not found"].." (ID "..step.ID_WOWHEAD..")", 1, 0.5, 0.5, 1)
			else
				-- build tooltip
				GameTooltip:SetText(AttuneLang["Q1_"..step.ID_WOWHEAD])
				local reqLevel = tonumber(quest[1]) or 0
				local lr, lg, lb = 0.5, 0.5, 0.5
				if UnitLevel("player") < reqLevel then lr, lg, lb = 1, 0.055, 0.075 end
				GameTooltip:AddLine(AttuneLang["Requires level"].." "..quest[1].."\n\n", lr, lg, lb, 1)
				if quest[2] == 1 then
					GameTooltip:AddLine(AttuneLang["Solo quest"].."\n\n", 0.373, 0.729, 0.275, 1)
				elseif quest[2] <= 5 then
					GameTooltip:AddLine(AttuneLang["Party quest"]:gsub("##NB##", quest[2]).."\n\n", 0.851, 0.608, 0.0, 1)
				else
					GameTooltip:AddLine(AttuneLang["Raid quest"]:gsub("##NB##", quest[2]).."\n\n", 0.857, 0.055, 0.075, 1)
				end
				if AttuneLang["Q2_"..step.ID_WOWHEAD] ~= nil then GameTooltip:AddLine(AttuneLang["Q2_"..step.ID_WOWHEAD], 1, 1, 1, 1, true) end
			end

			fnode:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then
					GameTooltip:Hide()
					Attune_HideQuestGiverTip()
					Attune_ShowWebsiteURL("quest=" .. step.ID_WOWHEAD)
				end
			end)

		elseif step.TYPE == "Kill" or step.TYPE == "Interact" then
			attunelocal_frame:SetStatusText(AttuneLang["N1_"..step.ID_WOWHEAD])
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local npc = Attune_Data.npcs[tonumber(step.ID_WOWHEAD)]
			if npc == nil then
				-- error message if quest is not in AttuneData.lua
				GameTooltip:SetText(AttuneLang["NPC Not Found"].." (ID "..step.ID_WOWHEAD..")", 1, 0.5, 0.5, 1)
			else
				-- build tooltip
				GameTooltip:SetText(AttuneLang["N1_"..step.ID_WOWHEAD])
				GameTooltip:AddLine(AttuneLang["Level"].." "..npc[1].." "..npc[2].." "..npc[3].."\n", 0.851, 0.608, 0.0, 1)
				if AttuneLang["N2_"..step.ID_WOWHEAD] ~= "" then
					GameTooltip:AddLine("\n"..AttuneLang["N2_"..step.ID_WOWHEAD], 1, 1, 1, 1, true)
				end

				fnode:SetScript("OnMouseUp", function(self, button)
					if button == "RightButton" then Attune_ShowWebsiteURL("npc=" .. step.ID_WOWHEAD)	end
				end)
			end

		elseif step.TYPE == "Click" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local other = AttuneLang["O_"..step.ID_WOWHEAD]
			if other == nil then
				-- error message if quest is not in AttuneData.lua
				GameTooltip:SetText(AttuneLang["Information not found"].." (ID "..step.ID_WOWHEAD..")", 1, 0.5, 0.5, 1)
			else
				-- build tooltip
				attunelocal_frame:SetStatusText(AttuneLang[step.STEP])
				GameTooltip:SetText(other)
			end



		-- change transparency if clickable sub-attune
		elseif step.TYPE == "Attune" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetText(AttuneLang["Click to navigate to that attunement"])

			if done then
				fnode:SetBackdropColor(0.055, 0.306, 0.576, 0.7 * 1.25) -- blue, attune
			else
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7 * 1.25)
			end
		end

		if listSameStep ~= "" and Attune_DB.showList then GameTooltip:AddLine(listSameStep, 1, 1, 1, 1) end
		GameTooltip:Show()
		if (step.TYPE == "Quest" or step.TYPE == "Pick Up") and not step.SIDE then
			Attune_ShowQuestGiverTip(step, fnode)
		else
			Attune_HideQuestGiverTip()
		end

	end)
	fnode:SetScript("OnLeave", function()
		-- restore status text to default
		attunelocal_frame:SetStatusText(attunelocal_statusText)
		GameTooltip:Hide()
		Attune_HideQuestGiverTip()
		-- restore  transparency for clickable sub-attunes
		if step.TYPE == "Attune" then
			if done then
				fnode:SetBackdropColor(0.055, 0.306, 0.576, 0.7) -- blue, attune
			else
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7) -- red
			end
		end
	end)
	fnode:SetScript("OnClick", function(self, button)

		-- shif-clicking items in chat
		if step.TYPE == "Item" then
			local _, link = GetItemInfo(tonumber(step.ID_WOWHEAD));
			if link then
				HandleModifiedItemClick(link);
			end
		-- shift clicking quests not working in Classic. Keep for TBC maybe it will work there
	--		elseif step.TYPE == "Quest" then
	--			local quest = Attune_Data.quests[tonumber(step.ID_WOWHEAD)]
	--			if quest and IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow() then
	--				ChatEdit_InsertLink(format("|cffffff00|Hquest:%d:%d|h[%s]|h|r", tonumber(step.ID_WOWHEAD), 60, quest[1]));
	--			end

		elseif (step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In") and (button == nil or button == "LeftButton") and not IsModifiedClick() then
			GameTooltip:Hide()
			Attune_HideQuestGiverTip()
			Attune_ShowQuestDetail(step)

		-- navigate to sub-attunement
		elseif step.TYPE == "Attune" then
			--call sub attune
			for i, a in pairs(Attune_Data.attunes) do
				if (a.ID == step.ID_ATTUNE) then
					attunelocal_treeframe:SelectByPath(a.EXPAC.."\001".. a.GROUP.."\001"..step.ID_WOWHEAD)
					break
				end
			end
		end

	end)


	local next = false
	if step.TYPE ~= "Spacer" then

		-- format node color
		fnode:SetBackdrop(PaneBackdrop)
		local tone = nil
		if step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
			tone = Attune_QuestCellTone(step)
		elseif step.TYPE == "Item" then
			tone = Attune_ItemCellTone(step, countNeeded)
		end
		if tone then
			Attune_SetNodeTone(fnode, tone)
		elseif done then
			if step.TYPE == "Attune" or step.TYPE == "End" then
				fnode:SetBackdropColor(0.055, 0.306, 0.576, 0.7) -- blue, attune
				fnode:SetBackdropBorderColor(1, 1, 1)

			else
				fnode:SetBackdropColor(0.373, 0.729, 0.275, 0.3) -- green, to match website colors
				fnode:SetBackdropBorderColor(0.373, 0.729, 0.275)
			end

		else
			-- check if all predecessor are done, and mark as Next if it is the case

			local followOR = false
			local fIDs = Attune_split(step.FOLLOWS, "&")
			if string.find(step.FOLLOWS, "|") then fIDs = Attune_split(step.FOLLOWS, "|"); followOR = true end

			if followOR then
				next = false
				for fi, flw in pairs(fIDs) do
					if  Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw] then next = true end
				end
			else
				next = true
				for fi, flw in pairs(fIDs) do
					if  Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw] == nil or Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw] == false then next = false end
				end
			end

			if step.FOLLOWS == "0" then next = true end

			if next then
				fnode:SetBackdropColor(0.851, 0.608, 0.0, 0.3) -- yellow
				fnode:SetBackdropBorderColor(0.851, 0.608, 0.0, 1)
			else
				fnode:SetBackdropColor(0.1, 0.1, 0.1, 0.5) -- gray
				fnode:SetBackdropBorderColor(0.4, 0.4, 0.4)
			end

			if step.TYPE == "Attune" or step.TYPE == "End" then
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7	) -- red, attune
				fnode:SetBackdropBorderColor(1, 1, 1)
			end
		end


		--icon, reuse object when possible
		local exist = false
		for _, f in ipairs(attunelocal_frames) do if f == "Attune_Icon_"..step.ID then exist = true end end
		local icon
		if exist then 	icon = _G["Attune_Icon_"..step.ID] -- reuse
		else			icon = CreateFrame("Button", "Attune_Icon_"..step.ID)
						table.insert(attunelocal_frames, "Attune_Icon_"..step.ID) -- recording, to reuse
		end
		icon:SetPoint("TOPLEFT", fnode, "TOPLEFT", 8, -8)
		icon:SetParent(fnode)
		icon:SetWidth(attunelocal_Icon_Size)
		icon:SetHeight(attunelocal_Icon_Size)
		icon:SetNormalTexture(step.ICON)
		icon:SetHighlightTexture(step.ICON)
		icon:SetToplevel(true)
		icon:EnableMouse(false)
		icon:Disable()
		icon:Show()


		-- step information, reuse when possible
		local exist = false
		for _, f in ipairs(attunelocal_frames) do if f == "Attune_Title_"..step.ID then exist = true end end
		local ftitle
		if exist then 	ftitle = _G["Attune_Title_"..step.ID] -- reuse
		else			ftitle = fnode:CreateFontString("Attune_Title_"..step.ID)
						table.insert(attunelocal_frames, "Attune_Title_"..step.ID) -- recording, to reuse
		end
		ftitle:SetWidth(nodeWidth - 50)
		ftitle:SetHeight(16)
		ftitle:SetJustifyH("LEFT")
		-- End node gets a bigger font
		if step.TYPE == 'End' then
			ftitle:SetPoint("TOPLEFT", 44, -16)
			ftitle:SetFont(GameFontNormal:GetFont(), 12, "")
			if Attune_DB.toons[attunelocal_charKey].attuned[step.ID_ATTUNE] >= 100
				or Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. step.ID] then
				ftitle:SetText(AttuneLang["Attuned"])
			else
				ftitle:SetText(AttuneLang["Not attuned"])
			end
		else
			ftitle:SetPoint("TOPLEFT", 44, -8)
			ftitle:SetFont(GameFontNormal:GetFont(), 11, "")

			if step.TYPE == "Item" then
				if countNeeded == 1 then
					--ftitle:SetText(step.STEP)
					ftitle:SetText(AttuneLang["I_"..step.ID_WOWHEAD])
				else
					ftitle:SetText(AttuneLang["I_"..step.ID_WOWHEAD] .. " (" .. Attune_OwnedItemCount(step.ID_WOWHEAD) .. "/" .. countNeeded .. ")")
				end
			elseif step.TYPE == "Kill" or step.TYPE == "Interact" then
				ftitle:SetText(AttuneLang["N1_"..step.ID_WOWHEAD])

			elseif step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
				ftitle:SetText(AttuneLang["Q1_"..step.ID_WOWHEAD])
			else
				ftitle:SetText(step.STEP)
			end
		end
		ftitle:Show()


		-- type and icon (level, interact, quest, kill...), reuse when possible
		if step.TYPE ~= 'End' then

			-- format depending on type
			local type = "|cffffd100"..AttuneLang[step.TYPE].."|r"
			if step.SIDE then
				type = "|cffffd100"..(AttuneLang["Inside"] or "Inside").."|r"
				if step.LOCATION ~= "" then type = type .. "|c60808080 ".. AttuneLang["in"].." "..AttuneLang[step.LOCATION].."|r" end
			elseif step.TYPE == "Level" then type = "|cffffd100"..AttuneLang["Required level"].."|r"
			elseif step.TYPE == "Attune" then type = "|c60808080"..AttuneLang["Attunement or key"].."|r"
			elseif step.TYPE == "Rep" then type = "|cffffd100"..AttuneLang["Reputation"].."|r"
			elseif step.LOCATION ~= "" then type = type .. "|c60808080 ".. AttuneLang["in"].." "..AttuneLang[step.LOCATION].."|r"
			end

			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_Type_"..step.ID then exist = true end end
			local ftype
			if exist then 	ftype = _G["Attune_Type_"..step.ID] --reuse
			else			ftype = fnode:CreateFontString("Attune_Type_"..step.ID)
							table.insert(attunelocal_frames, "Attune_Type_"..step.ID) -- recording, to reuse
			end
			ftype:SetPoint("TOPLEFT", 44, -24)
			ftype:SetWidth(nodeWidth - 50)
			ftype:SetHeight(16)
			ftype:SetJustifyH("LEFT")
			ftype:SetFont(GameFontNormal:GetFont(), 9, "")
			ftype:SetText(type)
			ftype:Show()
		end


		if countSameStep > 0 or countCompleted > 0 then

			--notification text
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_NotifText_"..step.ID then exist = true end end
			local notiftext
			if exist then 	notiftext = _G["Attune_NotifText_"..step.ID] -- reuse
			else			notiftext = fnode:CreateFontString("Attune_NotifText_"..step.ID)
							table.insert(attunelocal_frames, "Attune_NotifText_"..step.ID) -- recording, to reuse
			end
			notiftext:SetParent(fnode)
			notiftext:SetWidth(32)
			notiftext:SetFont(GameFontNormal:GetFont(), 10, "")
			notiftext:SetText(""..((countSameStep > 0) and countSameStep or countCompleted))
			notiftext:Show()



			--notification icon
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_Notif_"..step.ID then exist = true end end
			local notif
			if exist then 	notif = _G["Attune_Notif_"..step.ID] -- reuse
			else			notif = CreateFrame("Button", "Attune_Notif_"..step.ID)
							table.insert(attunelocal_frames, "Attune_Notif_"..step.ID) -- recording, to reuse
			end
			notif:SetPoint("TOPRIGHT", fnode, "TOPRIGHT", 8, 5)
			notif:SetParent(fnode)
			notif:SetWidth(32)
			notif:SetHeight(16)
			notif:SetFontString(notiftext)
			notif:SetNormalTexture("Interface\\AddOns\\Attune\\Images\\" .. ((countSameStep > 0) and "notification" or "completion"))
			notif:SetHighlightTexture("Interface\\AddOns\\Attune\\Images\\" .. ((countSameStep > 0) and "notification" or "completion"))
			notif:SetToplevel(true)
			notif:EnableMouse(false)
			notif:Disable()
			notif:Show()
		end

	else
		--make spacer transparent
		fnode:SetBackdropColor(0, 0, 0, 0)
		fnode:SetBackdropBorderColor(1, 1, 1, 0)

		-- Fill the invisible spacer with a vertical so column-drop FOLLOWS look solid (not dashed)
		local fillName = "Attune_SpacerFill_"..step.ID
		local fillExist = false
		for _, f in ipairs(attunelocal_frames) do if f == fillName then fillExist = true end end
		local fill
		if fillExist then fill = _G[fillName]
		else
			fill = fnode:CreateLine(fillName)
			table.insert(attunelocal_frames, fillName)
		end
		if step.FOLLOWS ~= nil and step.FOLLOWS ~= "0" then
			local upstreamComplete, upstreamReady = false, false
			for _, flw in ipairs(Attune_FollowIDs(step.FOLLOWS)) do
				local prev = Attune_FindStep(step.ID_ATTUNE, flw)
				if prev then
					local prevComplete, prevReady = Attune_StepLineState(prev)
					if prevComplete then upstreamComplete = true end
					if prevComplete or prevReady then upstreamReady = true end
				end
			end
			Attune_ApplyLineColor(fill, upstreamComplete, upstreamComplete, upstreamReady)
			fill:SetThickness(attunelocal_Line_Thickness)
			fill:SetStartPoint("TOP", 0, 0)
			fill:SetEndPoint("TOP", 0, -attunelocal_Node_Height)
			fill:Show()
		else
			fill:Hide()
		end
	end

	fnode:Show()

	-- Create lines between nodes
	-- 3 lines for each connection. No diagonals are used, only horizontal or vertical, to make it easier to look at
	-- End ← Inside (SIDE) links use a dedicated side feeder instead (see Attune_DrawSideFeeder)
	if step.FOLLOWS ~= "0" then
		local followOR = false;
		local fIDs = Attune_split(step.FOLLOWS, "&")
		if string.find(step.FOLLOWS, "|") then fIDs = Attune_split(step.FOLLOWS, "|"); followOR = true end
		for fi, flw in pairs(fIDs) do

			-- Skip L-connectors from End to SIDE steps (horizontal feeder handles those)
			if step.TYPE == "End" and Attune_IsSideStep(step.ID_ATTUNE, flw) then
				for _, suffix in ipairs({ "Line1", "Line2", "Line3" }) do
					local ln = _G["Attune_"..suffix.."_"..step.ID.."_"..flw]
					if ln then ln:Hide() end
				end
			else

			local prevStep = Attune_FindStep(step.ID_ATTUNE, flw)
			local srcComplete, srcReady = false, false
			if prevStep then
				srcComplete, srcReady = Attune_StepLineState(prevStep)
			else
				local doneMap = Attune_DB.toons[attunelocal_charKey] and Attune_DB.toons[attunelocal_charKey].done
				srcComplete = doneMap and doneMap[step.ID_ATTUNE .. "-" .. flw] and true or false
				srcReady = srcComplete
			end
			local curComplete = Attune_StepLineState(step)


			-- VERTICAL Line from prev to just under prev
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_Line1_"..step.ID.."_"..flw then exist = true end end

			local cur, _, _, curX, curY  = _G["Attune_Node_"..step.ID]:GetPoint()
			local prev, _, _, prevX, prevY = _G["Attune_Node_"..flw]:GetPoint()
			local offset = (attunelocal_Line_Thickness/2)

			local line
			if exist then 	line = _G["Attune_Line1_"..step.ID.."_"..flw] --reuse
			else			line = fnode:CreateLine("Attune_Line1_"..step.ID.."_"..flw)
							table.insert(attunelocal_frames, "Attune_Line1_"..step.ID.."_"..flw) -- recording, to reuse
			end
			Attune_ApplyLineColor(line, curComplete, srcComplete, srcReady)
			line:SetThickness(attunelocal_Line_Thickness)
			line:SetStartPoint("TOP", prevX - curX, prevY - curY - attunelocal_Node_Height)
			line:SetEndPoint("TOP", prevX - curX, prevY - curY - (attunelocal_Node_Height + (attunelocal_Node_VGap/2)) - offset)
			line:Show()


			-- VERTICAL Line to go all the way down to cur
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_Line3_"..step.ID.."_"..flw then exist = true end end

			local line
			if exist then 	line = _G["Attune_Line3_"..step.ID.."_"..flw]
			else			line = fnode:CreateLine("Attune_Line3_"..step.ID.."_"..flw)
							table.insert(attunelocal_frames, "Attune_Line3_"..step.ID.."_"..flw) -- recording, to reuse
			end
			Attune_ApplyLineColor(line, curComplete, srcComplete, srcReady)
			line:SetThickness(attunelocal_Line_Thickness)
			line:SetStartPoint("TOP", 0, prevY - curY - (attunelocal_Node_Height + (attunelocal_Node_VGap/2)) + offset)
			line:SetEndPoint("TOP", 0, -2)
			line:Show()



			-- HORIZONTAL Line to center on curX
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_Line2_"..step.ID.."_"..flw then exist = true end end

			local line
			if exist then 	line = _G["Attune_Line2_"..step.ID.."_"..flw]
			else			line = fnode:CreateLine("Attune_Line2_"..step.ID.."_"..flw)
							table.insert(attunelocal_frames, "Attune_Line2_"..step.ID.."_"..flw) -- recording, to reuse
			end
			Attune_ApplyLineColor(line, curComplete, srcComplete, srcReady)
			line:SetThickness(attunelocal_Line_Thickness)

			if prevX < 0 or curX < 0 then offset = -offset 	end -- need for the line thickness in corners
			line:SetStartPoint("TOP", offset, prevY - curY - (attunelocal_Node_Height + (attunelocal_Node_VGap/2)))
			line:SetEndPoint("TOP", prevX - curX + offset, prevY - curY - (attunelocal_Node_Height + (attunelocal_Node_VGap/2)))
			line:Show()

			end -- not SIDE→End


		end
	end
end


-------------------------------------------------------------------------
-- Trigger a redraw of the Attune tab
-------------------------------------------------------------------------

function Attune_ForceAttuneTabRefresh()
	if not attunelocal_initial then
		attunelocal_treeIsShown = not attunelocal_treeIsShown
		Attune_ToggleView()
	end
end


-------------------------------------------------------------------------
-- Toggle between the Attune tab and the result summary tab
-------------------------------------------------------------------------

function Attune_ToggleView(noToggle)

	Attune_SaveTreeExpandStatus()
	if Attune_HideQuestDetail then Attune_HideQuestDetail() end

	if noToggle == nil then noToggle = false end

	Attune_ReleaseZoomSlider()
	Attune_HideDungeonArt()
	Attune_ShowWorkInProgress(false)
	attunelocal_frame:ReleaseChildren()
	--Hiding all frames
	for i, f in pairs(attunelocal_frames) do _G[f]:Hide() end
	if attunelocal_graphRoot then attunelocal_graphRoot:Hide() end

	if attunelocal_treeIsShown or noToggle then

		_G["GuildButton"]:SetText(AttuneLang["Attunes"])

		-- SHOW RESULT FRAME
		PlaySound(856)  --igMainMenuOptionCheckBoxOn
		attunelocal_treeIsShown = false
		Attune_UpdateWindowPortrait()

		attunelocal_guildframe = AceGUI:Create("SimpleGroup")
		attunelocal_guildframe:SetLayout("Flow")
		attunelocal_guildframe:SetFullWidth(true)
		attunelocal_guildframe:SetFullHeight(true)
		attunelocal_guildframe:SetAutoAdjustHeight(false)
		attunelocal_frame:AddChild(attunelocal_guildframe)




		--Display guild name and sort message
		local titleGroup = AceGUI:Create("SimpleGroup")
		titleGroup:SetRelativeWidth(0.45)

			local label = AceGUI:Create("Label")
			label:SetText(attunelocal_myguild)
			if UnitFactionGroup("player") == 'Horde' then
				label:SetImage("Interface\\Icons\\inv_bannerpvp_01")
			else
				label:SetImage("Interface\\Icons\\inv_bannerpvp_02")
			end
			label:SetFont(GameFontHighlight:GetFont(), 24, "")
			label:SetImageSize(32,32)
			label:SetFullWidth(true)
			titleGroup:AddChild(label)


			local spacer = AceGUI:Create("Label")
			spacer:SetText(" \n ")
			spacer:SetFullWidth(true)
			titleGroup:AddChild(spacer)
--[[
			local spacer = AceGUI:Create("Label")
			spacer:SetText(" \n ")
			spacer:SetFullWidth(true)
			titleGroup:AddChild(spacer)
]]
			
--[=[ Open Raid Planner / Show Profiles disabled for now
			local raid = AceGUI:Create("Button")
			raid:SetText(AttuneLang["Open Raid Planner"])
			raid:SetCallback("OnClick", function()
				if attunelocal_initial == false and attunelocal_frame:IsShown() then 
					attunelocal_frame:Hide()
					Attune_Release()
				end
				Attune_RaidPlannerFrame()
				end)
			titleGroup:AddChild(raid)
			--raid:SetDisabled(true)
			raid.frame:Hide()


			local prof = AceGUI:Create("Button")
			if attunelocal_showResultAttunes then
				 prof:SetText(AttuneLang["Show Profiles"])
				 --raid:SetDisabled(true)
				 raid.frame:Hide()
			else 
				prof:SetText(AttuneLang["Show Progress"])
				--raid:SetDisabled(false)
				raid.frame:Show() -- only show when looking at profiles
			end
			prof:SetCallback("OnClick", function()
				attunelocal_showResultAttunes = not attunelocal_showResultAttunes

				if attunelocal_showResultAttunes then prof:SetText(AttuneLang["Show Profiles"])
				else prof:SetText(AttuneLang["Show Progress"])
				end
				Attune_ToggleView(true)
			end)
			titleGroup:AddChild(prof)


]=]
		attunelocal_guildframe:AddChild(titleGroup)


		--CheckBox
		local radioGroup = AceGUI:Create("SimpleGroup")
		radioGroup:SetRelativeWidth(0.25)

		local radio1 = AceGUI:Create("CheckBox")
		radio1:SetType("radio")
		radio1:SetLabel(AttuneLang["Last survey results"])
		radio1:SetValue(attunelocal_resultselection == 0)
		radioGroup:AddChild(radio1)

		local radio2 = AceGUI:Create("CheckBox")
		radio2:SetType("radio")
		radio2:SetLabel(AttuneLang["Guild members"])
		radio2:SetValue(attunelocal_resultselection == 1)
		radioGroup:AddChild(radio2)

		local radio3 = AceGUI:Create("CheckBox")
		radio3:SetType("radio")
		radio3:SetLabel(AttuneLang["My Toons"])
		radio3:SetValue(attunelocal_resultselection == 2)
		radioGroup:AddChild(radio3)

		local radio4 = AceGUI:Create("CheckBox")
		radio4:SetType("radio")
		radio4:SetLabel(AttuneLang["All results"])
		radio4:SetValue(attunelocal_resultselection == 3)
		radioGroup:AddChild(radio4)

		radio1:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 0
			radio1:SetValue(true)
			radio2:SetValue(false)
			radio3:SetValue(false)
			radio4:SetValue(false)
			Attune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
			-- else Attune_ShowProfileList(label)	end
		end)
		radio2:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 1
			radio1:SetValue(false)
			radio2:SetValue(true)
			radio3:SetValue(false)
			radio4:SetValue(false)
			Attune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
			-- else Attune_ShowProfileList(label)	end
		end)
		radio3:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 2
			radio1:SetValue(false)
			radio2:SetValue(false)
			radio3:SetValue(true)
			radio4:SetValue(false)
			Attune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
			-- else Attune_ShowProfileList(label)	end
		end)
		radio4:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 3
			radio1:SetValue(false)
			radio2:SetValue(false)
			radio3:SetValue(false)
			radio4:SetValue(true)
			Attune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
			-- else Attune_ShowProfileList(label)	end
		end)
		attunelocal_guildframe:AddChild(radioGroup)


		local syncGroup = AceGUI:Create("SimpleGroup")
		syncGroup:SetRelativeWidth(0.25)

			--Slider
			local slider = AceGUI:Create("Slider")
			slider:SetValue(Attune_DB.minFilterValue or 1)
			slider:SetSliderValues(1, 60, 1)
			slider:SetLabel(AttuneLang["Minimum level"])
			slider:SetCallback("OnValueChanged", function(slid)
				Attune_DB.minFilterValue = slid:GetValue()
			end)
			slider:SetCallback("OnMouseUp", function(slid)
				Attune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
				-- else Attune_ShowProfileList(label)	end
			end)
			syncGroup:AddChild(slider)

			local spacer = AceGUI:Create("Label")
			spacer:SetText(" \n ")
			spacer:SetFullWidth(true)
			syncGroup:AddChild(spacer)

			local sync = AceGUI:Create("Button")
			sync:SetText(AttuneLang["Sync with target"])
			sync:SetCallback("OnClick", function()
				Attune_SendSyncRequest()
			end)
			syncGroup:AddChild(sync)

		attunelocal_guildframe:AddChild(syncGroup)




		-- show attunes or profiles
		if attunelocal_showResultAttunes then 
			--show attunes

			--Header row
			local gftitle = AceGUI:Create("InlineGroup")
			gftitle:SetLayout("Flow")
			gftitle:SetAutoAdjustHeight(true)
			gftitle:SetFullWidth(true)

			attunelocal_gflabel = AceGUI:Create("InteractiveLabel")
			attunelocal_gflabel:SetText(AttuneLang["Character"])
			attunelocal_gflabel:SetWidth(265)
			attunelocal_gflabel:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel:SetCallback("OnClick", function()
				if Attune_DB.sortresult[1] == 0 then
					--same sort, just change order
					Attune_DB.sortresult[2] = not Attune_DB.sortresult[2]
				else
					Attune_DB.sortresult[1] = 0
					Attune_DB.sortresult[2] = true
				end
				Attune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
				-- else Attune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel)


			local expac = ""
			for i, a in pairs(Attune_Data.attunes) do
				if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 

					if (TreeExpandStatus[a.EXPAC] == nil 
					or TreeExpandStatus[a.EXPAC] == 1) 
					and (TreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == nil 
					or TreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == 1) then 


						if expac ~= a.EXPAC.."-"..a.GROUP then
							local gfspacer = AceGUI:Create("Label")
							gfspacer:SetText(" ")
							gfspacer:SetWidth(10)
							gftitle:AddChild(gfspacer)
							expac = a.EXPAC.."-"..a.GROUP
						end

						if a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both' then
							local gficon = AceGUI:Create("Icon")
							gficon:SetImage(a.ICON)
							gficon:SetWidth(30)
							gficon:SetImageSize(24, 24)
							gficon.frame:SetScript("OnClick", function()
								if Attune_DB.sortresult[1] == a.ID then
									--same sort, just change order
									Attune_DB.sortresult[2] = not Attune_DB.sortresult[2]
								else
									Attune_DB.sortresult[1] = a.ID
									Attune_DB.sortresult[2] = true --desc better for attunes, but we're reversing % further down.
								end
								Attune_ShowResultList(label) -- profiles disabled
								-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
								-- else Attune_ShowProfileList(label)	end
				
							end)
							gficon.frame:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(a.NAME.." - "..a.EXPAC)  end)
							gficon.frame:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText)  end)
							gftitle:AddChild(gficon)
						end
					end
				end
			end

			attunelocal_guildframe:AddChild(gftitle)



			attunelocal_gscroll = AceGUI:Create("ScrollFrame")
			attunelocal_gscroll:SetLayout("Flow")
			attunelocal_gscroll:SetFullWidth(true)
			
	
			-- This script needed to allow the scrollframe resize whenever content changes or vertical size is moved
			attunelocal_gscroll.frame:SetScript("OnUpdate", function()
				attunelocal_gscroll:SetHeight(attunelocal_frame.frame:GetHeight() - 255)
			end)
	
	

			attunelocal_glist = AceGUI:Create("SimpleGroup")
			attunelocal_glist:SetLayout("Flow")
			attunelocal_glist:SetAutoAdjustHeight(true)
			attunelocal_glist:SetFullWidth(true)

			Attune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
			-- else Attune_ShowProfileList(label)	end

			attunelocal_gscroll:AddChild(attunelocal_glist)

			attunelocal_guildframe:AddChild(attunelocal_gscroll)

--[=[ Show Profiles view disabled for now
		else

			--show profiles

			--Header row
			local gftitle = AceGUI:Create("InlineGroup")
			gftitle:SetLayout("Flow")
			gftitle:SetAutoAdjustHeight(true)
			gftitle:SetFullWidth(true)


			attunelocal_gflabel = AceGUI:Create("InteractiveLabel")
			attunelocal_gflabel:SetText(AttuneLang["Character"])
			attunelocal_gflabel:SetWidth(200)
			attunelocal_gflabel:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel:SetCallback("OnClick", function()
				if Attune_DB.sortresult[1] == 0 then
					--same sort, just change order
					Attune_DB.sortresult[2] = not Attune_DB.sortresult[2]
				else
					Attune_DB.sortresult[1] = 0
					Attune_DB.sortresult[2] = true
				end
				Attune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
				-- else Attune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel)

			attunelocal_gflabel2 = AceGUI:Create("InteractiveLabel")
			attunelocal_gflabel2:SetText(AttuneLang["Guild"])
			attunelocal_gflabel2:SetWidth(240)
			attunelocal_gflabel2:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel2:SetCallback("OnClick", function()
				if Attune_DB.sortresult[1] == -1 then
					--same sort, just change order
					Attune_DB.sortresult[2] = not Attune_DB.sortresult[2]
				else
					Attune_DB.sortresult[1] = -1
					Attune_DB.sortresult[2] = true
				end
				Attune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
				-- else Attune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel2)

			attunelocal_gflabel3 = AceGUI:Create("InteractiveLabel")
			attunelocal_gflabel3:SetText(AttuneLang["Status"])
			attunelocal_gflabel3:SetWidth(100)
			attunelocal_gflabel3:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel3:SetCallback("OnClick", function()
				if Attune_DB.sortresult[1] == -2 then
					--same sort, just change order
					Attune_DB.sortresult[2] = not Attune_DB.sortresult[2]
				else
					Attune_DB.sortresult[1] = -2
					Attune_DB.sortresult[2] = false
				end
				Attune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
				-- else Attune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel3)

			attunelocal_gflabel4 = AceGUI:Create("InteractiveLabel")
			attunelocal_gflabel4:SetText(AttuneLang["Role"])
			attunelocal_gflabel4:SetWidth(100)
			attunelocal_gflabel4:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel4:SetCallback("OnClick", function()
				if Attune_DB.sortresult[1] == -3 then
					--same sort, just change order
					Attune_DB.sortresult[2] = not Attune_DB.sortresult[2]
				else
					Attune_DB.sortresult[1] = -3
					Attune_DB.sortresult[2] = false
				end
				Attune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
				-- else Attune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel4)

			attunelocal_gflabel5 = AceGUI:Create("InteractiveLabel")
			attunelocal_gflabel5:SetText("    "..AttuneLang["Last Surveyed"])
			attunelocal_gflabel5:SetWidth(150)
			attunelocal_gflabel5:SetFont(GameFontHighlight:GetFont(), 16, "")
			attunelocal_gflabel5:SetCallback("OnClick", function()
				if Attune_DB.sortresult[1] == -4 then
					--same sort, just change order
					Attune_DB.sortresult[2] = not Attune_DB.sortresult[2]
				else
					Attune_DB.sortresult[1] = -4
					Attune_DB.sortresult[2] = true
				end
				Attune_ShowResultList(label) -- profiles disabled
				-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
				-- else Attune_ShowProfileList(label)	end
			end)
			gftitle:AddChild(attunelocal_gflabel5)

			local gficon = AceGUI:Create("Icon")
			gficon:SetImage("Interface\\AddOns\\Attune\\Images\\empty")
			gficon:SetWidth(30)
			gficon:SetImageSize(24, 24)
			gftitle:AddChild(gficon)

			attunelocal_guildframe:AddChild(gftitle)


			attunelocal_gscroll = AceGUI:Create("ScrollFrame")
			attunelocal_gscroll:SetLayout("Flow")
			attunelocal_gscroll:SetFullWidth(true)
			
	
			-- This script needed to allow the scrollframe resize whenever content changes or vertical size is moved
			attunelocal_gscroll.frame:SetScript("OnUpdate", function()
				attunelocal_gscroll:SetHeight(attunelocal_frame.frame:GetHeight() - 255)
			end)

			attunelocal_glist = AceGUI:Create("SimpleGroup")
			attunelocal_glist:SetLayout("Flow")
			attunelocal_glist:SetAutoAdjustHeight(true)
			attunelocal_glist:SetFullWidth(true)

			Attune_ShowResultList(label) -- profiles disabled
			-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
			-- else Attune_ShowProfileList(label)	end

			attunelocal_gscroll:AddChild(attunelocal_glist)

			attunelocal_guildframe:AddChild(attunelocal_gscroll)
]=]

		end

	else

		_G["GuildButton"]:SetText(AttuneLang["Results"])

		-- SHOW TREE FRAME
		attunelocal_treeIsShown = true
		Attune_UpdateWindowPortrait()

		-- create the tree
		attunelocal_treeframe = AceGUI:Create("TreeGroup")
		Attune_StyleTreeGroup(attunelocal_treeframe)
		attunelocal_treeframe:SetTree(attunelocal_tree)
		attunelocal_treeframe:SetLayout("Fill")
		attunelocal_treeframe:SetFullWidth(true)
		attunelocal_treeframe:SetFullHeight(true)
		attunelocal_treeframe:SetAutoAdjustHeight(false)
		-- Avoid AceGUI TreeGroup tooltip SetText(..., true-as-alpha) which errors on classic beta
		attunelocal_treeframe:EnableButtonTooltips(false)
		attunelocal_frame:AddChild(attunelocal_treeframe)

		for i, a in pairs(Attune_Data.attunes) do
			if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
				if TreeExpandStatus[a.EXPAC] == nil then TreeExpandStatus[a.EXPAC] = 1 end
				if TreeExpandStatus[a.EXPAC] == 1 then attunelocal_treeframe:SelectByPath(a.EXPAC) end

				if TreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == nil then TreeExpandStatus[a.EXPAC.."\001"..a.GROUP] = 1 end
				if TreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == 1 then attunelocal_treeframe:SelectByPath(a.EXPAC.."\001"..a.GROUP) end
			end
		end
		attunelocal_treeframe:SetCallback("OnGroupSelected", function(container, event, selection)
			--check if it's a top level expac
			local st, le = string.find(selection, "\001")
			if st ~= nil then -- not top level
				--get actual attune (remove expac/group)
				expac, group, sel = strsplit("\001", selection);
				if sel ~= "" and sel ~= nil then
					AttuneLastViewed = selection
					Attune_Select(sel)
				end
			end
		end)

		attunelocal_treeframe:SetCallback("OnTreeResize", function(container, event, group)
			--force the size to 175
			container.treeframe:SetWidth(175)
		end)

		attunelocal_right = AceGUI:Create("SimpleGroup")
		attunelocal_right:SetLayout("Fill")
		attunelocal_right:SetFullWidth(true)
		attunelocal_right:SetFullHeight(true)
		attunelocal_right:SetAutoAdjustHeight(false)
		attunelocal_treeframe:AddChild(attunelocal_right)

		attunelocal_scroll = AceGUI:Create("ScrollFrame")
		attunelocal_scroll:SetLayout("List")
		attunelocal_scroll:SetFullWidth(true)
		attunelocal_scroll:SetFullHeight(true)
		attunelocal_scroll:SetAutoAdjustHeight(false)
		attunelocal_right:AddChild(attunelocal_scroll)

		Attune_CreateZoomSlider()

		--select default attune (or last viewed)
		attunelocal_treeframe:SelectByPath(AttuneLastViewed)

	end

end

-------------------------------------------------------------------------
-- Create the Attune list shown in the Result tab
-------------------------------------------------------------------------

function Attune_ShowResultList(title)

	local count = 0 -- number of rows displayed in table

	-- number of steps per attune - this is to calculate % completion
	local attuneSteps = {}
	for i, s in pairs(Attune_Data.steps) do
		if showPatchStep(s) then
			if s.TYPE ~= "Spacer" then
				if attuneSteps[s.ID_ATTUNE] == nil then attuneSteps[s.ID_ATTUNE] = 0 end
				attuneSteps[s.ID_ATTUNE] = attuneSteps[s.ID_ATTUNE] +1
			end
		end
	end

	-- adjust the title according to the selection
	if title ~= nil then
		local gg = attunelocal_myguild
		if gg == "" then gg = AttuneLang['Not in a guild'] end

		if attunelocal_resultselection == 0 then
			title:SetText(AttuneLang["Last survey results"])
		elseif attunelocal_resultselection == 1 then
			title:SetText(gg)
		elseif attunelocal_resultselection == 2 then
			title:SetText(AttuneLang["My Toons"])
		else
			local fact, factLoc = UnitFactionGroup("player")
			title:SetText(AttuneLang["All FACTION results"]:gsub("##FACTION##", factLoc ))
		end

	end

	attunelocal_glist:ReleaseChildren()


	-- parse all recorded toons and get their progress
	local spacerDone = {}
	for _, s in pairs(Attune_Data.steps) do
		if s.TYPE == "Spacer" then spacerDone[s.ID_ATTUNE .. "-" .. s.ID] = true end
	end
	for kt, t in pairs(Attune_DB.toons) do
		-- calculate how many steps this toon has done on the attune
		local attuneDone = {}
		if t.done ~= nil then 
			Attune_AutoCompleteSpacers(kt)
			for i, d in pairs(t.done) do
				if not spacerDone[i] then
					local Ids = Attune_split(i, "-")
					if attuneDone[Ids[1]] == nil then attuneDone[Ids[1]] = 0 end
					attuneDone[Ids[1]] = attuneDone[Ids[1]] +1
				end
			end

			if t.attuned == nil then t.attuned = {} end
			for i, a in pairs(Attune_Data.attunes) do
				if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
					if attuneDone[a.ID] == nil then attuneDone[a.ID] = 0 end
					if (attuneSteps[a.ID] or 0) > 0 then
						t.attuned[a.ID] = math.floor(100*(attuneDone[a.ID]/attuneSteps[a.ID]))
					else
						t.attuned[a.ID] = 0
					end
				end
			end
			Attune_ApplyCompletedEndSteps(t)
		end
	end


	-- display the list according to the sort order
	--for kt, t in Attune_spairs(Attune_DB.toons, function(t,a,b) 	return b > a end) do
	for kt, t in Attune_spairs(Attune_DB.toons, function(t,a,b)
		if Attune_DB.sortresult[1] == 0 then
			if Attune_DB.sortresult[2] then
				return b > a
			else
				return a > b
			end
		elseif Attune_DB.sortresult[1] == -1 then
			if Attune_DB.sortresult[2] then
				return t[b].guild > t[a].guild
			else
				return t[a].guild > t[b].guild
			end
		elseif Attune_DB.sortresult[1] == -2 then
			if Attune_DB.sortresult[2] then
				return Attune_StatusRole(t[b].status) > Attune_StatusRole(t[a].status)
			else
				return Attune_StatusRole(t[a].status) > Attune_StatusRole(t[b].status)
			end
		elseif Attune_DB.sortresult[1] == -3 then
			if Attune_DB.sortresult[2] then
				return Attune_StatusRole(t[b].role) > Attune_StatusRole(t[a].role)
			else
				return Attune_StatusRole(t[a].role) > Attune_StatusRole(t[b].role)
			end
		elseif Attune_DB.sortresult[1] == -4 then
			if Attune_DB.sortresult[2] then
				return t[b].survey > t[a].survey
			else
				return t[a].survey > t[b].survey
			end
		else 
			--sort by attune % AND name. reversing the % with "100-" to be able to sort names alpha
			if Attune_DB.sortresult[2] then
				return string.format("%03i", 100-t[b].attuned[Attune_DB.sortresult[1]]) .. b > string.format("%03i", 100-t[a].attuned[Attune_DB.sortresult[1]]) .. a
			else
				return string.format("%03i", 100-t[a].attuned[Attune_DB.sortresult[1]]) .. a > string.format("%03i", 100-t[b].attuned[Attune_DB.sortresult[1]]) .. b
			end
		end
	 end) do

		-- only look at current faction (and current realm)
		--if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then  -- removing realm
        if t.faction == UnitFactionGroup("player") and (kt == t.name) then

			-- look for:
			-- 		if attunelocal_resultselection == 0, players in the same guild, or if unguilded just this player
			-- 		if attunelocal_resultselection == 1, players that have been put in the survey list
			--		if attunelocal_resultselection == 2, all players recorded
			if (attunelocal_resultselection == 0 and Attune_DB.survey[kt])
			or (attunelocal_resultselection == 1 and ((attunelocal_myguild ~= "" and t.guild == attunelocal_myguild) or t.name == attunelocal_myFullName))
			or (attunelocal_resultselection == 2 and t.owner == 1) 
			or (attunelocal_resultselection == 3) then

				if tonumber(t.level) >= (Attune_DB.minFilterValue or 1) then

					count = count + 1

					C_Timer.After(0.01*count, function()
						local lev = t.level
						if tonumber(lev) < 10 then lev = "  "..lev end -- align numbers when under 10

						local ggg = t.guild
						if ggg == '' then ggg = "(Not in a guild)" else ggg = "<"..ggg..">" end

						local vvv = t.version
						if vvv == nil then vvv = "- Very old addon version" else vvv = " - v"..vvv.."" end

						local sss = t.survey
						if sss == nil then sss = "- No survey date recorded" else sss = "- Last surveyed on "..date("%d %b %Y", sss).."" end
						
						local activeName = t.name
						local inactive = false
						if t.survey == nil or t.survey == 0 then 
						else
							if t.survey < time() - attunelocal_inactivity then 
								-- old inactive toon
								inactive = true
								activeName = "|c80606060"..activeName.."|r"
								sss = sss .. " (inactive)"
							end 
						end
						-- container for the whole row
						local gframe = AceGUI:Create("SimpleGroup")
						gframe:SetLayout("Flow")
						gframe:SetAutoAdjustHeight(true)
						gframe:SetFullWidth(true)
						gframe.frame:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(t.name.." "..ggg.." "..vvv.." "..sss)  end)
						gframe.frame:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText)  end)

						-- add toon part
							local glabel = AceGUI:Create("Label")
							glabel:SetText("    |c80606060"..lev.."|r  |T"..Attune_Icons(string.upper(t.class), nil)..":16|t  "..activeName)
							glabel:SetWidth(285)
							glabel:SetFont(GameFontNormal:GetFont(), 12, "")
							gframe:AddChild(glabel)


						-- Go through each Attune and create the corresponding % label for this toon
						local expac = ""
						for i, a in pairs(Attune_Data.attunes) do
							if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 

								if (TreeExpandStatus[a.EXPAC] == nil 
									or TreeExpandStatus[a.EXPAC] == 1) 
									and (TreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == nil 
									or TreeExpandStatus[a.EXPAC.."\001"..a.GROUP] == 1) then 
					
									-- This spacer to separate Wow classic from TBC attunes
									if expac ~= a.EXPAC.."-"..a.GROUP then
										local gfspacer = AceGUI:Create("Label")
										gfspacer:SetText(" ")
										gfspacer:SetWidth(10)
										gframe:AddChild(gfspacer)
										expac = a.EXPAC.."-"..a.GROUP
									end

									-- Only look at attunes for this toon's faction
									if a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both' then

										local gflabel = AceGUI:Create("Label")
										if t.attuned[a.ID] >= 100 then
											if inactive then 
												gflabel:SetText("|TInterface\\AddOns\\Attune\\Images\\successinactive:16|t")
											else 
												gflabel:SetText("|TInterface\\AddOns\\Attune\\Images\\success:16|t")
											end
										else
											if inactive then 
												gflabel:SetText("|c80606060"..t.attuned[a.ID].."%|r")
											else 
												gflabel:SetText(t.attuned[a.ID].."%")
											end
										end
										gflabel:SetWidth(30)
										gframe:AddChild(gflabel)

									end
								end
							end
						end


						if attunelocal_charKey ~= kt then
							-- add a delete button, to allow removing players from our data (for example if they changed guilds)
							local gdel = AceGUI:Create("Button")
							gdel:SetText("X")
							gdel:SetWidth(50)
							gdel:SetCallback("OnClick", function()
								Attune_DB.toons[kt] = nil
								Attune_ShowResultList(label) -- profiles disabled
								-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
								-- else Attune_ShowProfileList(label)	end
					
							end)
							gframe:AddChild(gdel)
						end

						-- add the row to the list
						attunelocal_glist:AddChild(gframe)
						attunelocal_gscroll.content.obj.content:SetHeight(attunelocal_frame.frame:GetHeight() - 80)
					end) -- end of timer function
				end
			end
		end
	end

	attunelocal_gflabel:SetText(AttuneLang["Characters"].." ("..count..")")
	attunelocal_gscroll.content.obj.content:SetHeight(attunelocal_frame.frame:GetHeight() - 80)

end

--[=[ Show Profiles list disabled for now
-------------------------------------------------------------------------
-- Create the Profile list shown in the Result tab
-------------------------------------------------------------------------

function Attune_ShowProfileList(title)

	local count = 0 -- number of rows displayed in table
	local att = Attune_DB.toons[attunelocal_charKey]

	-- adjust the title according to the selection
	if title ~= nil then
		local gg = attunelocal_myguild
		if gg == "" then gg = AttuneLang['Not in a guild'] end

		if attunelocal_resultselection == 0 then
			title:SetText(AttuneLang["Last survey results"])
		elseif attunelocal_resultselection == 1 then
			title:SetText(gg)
		elseif attunelocal_resultselection == 2 then
			title:SetText(AttuneLang["My Toons"])
		else
			local fact, factLoc = UnitFactionGroup("player")
			title:SetText(AttuneLang["All FACTION results"]:gsub("##FACTION##", factLoc ))
		end

	end

	attunelocal_glist:ReleaseChildren()


	-- display the list according to the sort order
	--for kt, t in Attune_spairs(Attune_DB.toons, function(t,a,b) 	return b > a end) do
	for kt, t in Attune_spairs(Attune_DB.toons, function(t,a,b)
		if Attune_DB.sortresult[1] == 0 then
			if Attune_DB.sortresult[2] then
				return b > a
			else
				return a > b
			end
		elseif Attune_DB.sortresult[1] == -1 then
			if Attune_DB.sortresult[2] then
				return t[b].guild > t[a].guild
			else
				return t[a].guild > t[b].guild
			end
		elseif Attune_DB.sortresult[1] == -2 then
			if Attune_DB.sortresult[2] then
				return Attune_StatusRole(t[b].status) > Attune_StatusRole(t[a].status)
			else
				return Attune_StatusRole(t[a].status) > Attune_StatusRole(t[b].status)
			end
		elseif Attune_DB.sortresult[1] == -3 then
			if Attune_DB.sortresult[2] then
				return Attune_StatusRole(t[b].role) > Attune_StatusRole(t[a].role)
			else
				return Attune_StatusRole(t[a].role) > Attune_StatusRole(t[b].role)
			end
		elseif Attune_DB.sortresult[1] == -4 then
			if Attune_DB.sortresult[2] then
				return t[b].survey > t[a].survey
			else
				return t[a].survey > t[b].survey
			end
		else 
			--sort by attune % AND name. reversing the % with "100-" to be able to sort names alpha
			if Attune_DB.sortresult[2] then
				return string.format("%03i", 100-Attune_IfNilZero(t[b].attuned[Attune_DB.sortresult[1] ])) .. b > string.format("%03i", 100-Attune_IfNilZero(t[a].attuned[Attune_DB.sortresult[1] ])) .. a
			else
				return string.format("%03i", 100-Attune_IfNilZero(t[a].attuned[Attune_DB.sortresult[1] ])) .. a > string.format("%03i", 100-Attune_IfNilZero(t[b].attuned[Attune_DB.sortresult[1] ])) .. b
			end
		end
	 end) do

		-- only look at current faction (and current realm)
		if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then

			-- look for:
			-- 		if attunelocal_resultselection == 0, players in the same guild, or if unguilded just this player
			-- 		if attunelocal_resultselection == 1, players that have been put in the survey list
			--		if attunelocal_resultselection == 2, all players recorded
			if (attunelocal_resultselection == 0 and Attune_DB.survey[kt])
			or (attunelocal_resultselection == 1 and ((attunelocal_myguild ~= "" and t.guild == attunelocal_myguild) or t.name == attunelocal_myFullName))
			or (attunelocal_resultselection == 2 and t.owner == 1) 
			or (attunelocal_resultselection == 3) then

				if tonumber(t.level) >= (Attune_DB.minFilterValue or 1) then

					count = count + 1

					C_Timer.After(0.01*count, function()
						local lev = t.level
						if tonumber(lev) < 10 then lev = "  "..lev end -- align numbers when under 10

						local ggg = t.guild
						if ggg == '' then ggg = "(Not in a guild)" else ggg = "<"..ggg..">" end

						local vvv = t.version
						if vvv == nil then vvv = "- Very old addon version" else vvv = "- v"..vvv.."" end

						local sss = t.survey
						if sss == nil then sss = "- No survey date recorded" else sss = "- Last surveyed on "..date("%d %b %Y", sss).."" end
						
						local activeName = t.name
						local inactive = false
						if t.survey == nil or t.survey == 0 then 
						else
							if t.survey < time() - attunelocal_inactivity then 
								-- old inactive toon
								inactive = true
								activeName = "|c80606060"..activeName.."|r"
								sss = sss .. " (inactive)"
							end 
						end

						-- container for the whole row
						local gframe = AceGUI:Create("SimpleGroup")
						gframe:SetLayout("Flow")
						gframe:SetAutoAdjustHeight(true)
						gframe:SetFullWidth(true)
						gframe.frame:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(t.name.."  "..ggg.." "..sss)  end)
						gframe.frame:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText)  end)

						-- add toon part
							local glabel = AceGUI:Create("Label")
							glabel:SetText("    |c80606060"..lev.."|r  |T"..Attune_Icons(string.upper(t.class), nil)..":16|t  "..activeName)
							glabel:SetWidth(210)
							glabel:SetFont(GameFontNormal:GetFont(), 12, "")
							gframe:AddChild(glabel)

							local gguild = AceGUI:Create("Label")
							if inactive then gguild:SetText("|c80606060"..t.guild.."|r") else gguild:SetText(t.guild) end
							gguild:SetWidth(240)
							gguild:SetFont(GameFontNormal:GetFont(), 12, "")
							gframe:AddChild(gguild)

							if t.owner == 1 or (t.guild == att.guild and att.officer == "1") then 
								local gstatus = AceGUI:Create("Dropdown")
								gstatus:SetWidth(100)
								gstatus:SetList({
--									["None"] = "-",
									["Main"] = Attune_StatusRole("Main"),
									["Alt"] = Attune_StatusRole("Alt"),
									["Bank"] = Attune_StatusRole("Bank"),								
								}, {"Main", "Alt", "Bank"})
								if t.status == nil then t.status = "None" end
								gstatus:SetValue(t.status)
								gstatus:SetCallback("OnValueChanged", function(choice) 
									t.status = choice:GetValue() 
									if attunelocal_myguild ~= "" then Attune:SendCommMessage(attunelocal_prefix, t.name .. "|TOONSTATUS|" .. t.status, "GUILD") end 
								end )
								gframe:AddChild(gstatus)

								
								local grole = AceGUI:Create("Dropdown")
								grole:SetWidth(100)
								grole:SetList({
--									["None"] = "-",
									["Tank"] = Attune_StatusRole("Tank"),
									["Healer"] = Attune_StatusRole("Healer"),
									["Melee"] = Attune_StatusRole("Melee"),
									["Ranged"] = Attune_StatusRole("Ranged"),
								}, {"Tank", "Healer", "Melee", "Ranged"})
								if t.role == nil then t.role = "None" end
								grole:SetValue(t.role)
								grole:SetCallback("OnValueChanged", function(choice) 
									t.role = choice:GetValue() 
									if attunelocal_myguild ~= "" then Attune:SendCommMessage(attunelocal_prefix, t.name .. "|TOONROLE|" .. t.role, "GUILD") end 
								end )
								gframe:AddChild(grole)

							else
								local gstatus = AceGUI:Create("Label")
								if t.status == nil then t.status = "None" end
								if inactive then gstatus:SetText("|c80606060"..Attune_StatusRole(t.status).."|r") else gstatus:SetText(Attune_StatusRole(t.status)) end
								gstatus:SetWidth(100)
								gstatus:SetFont(GameFontNormal:GetFont(), 12, "")
								gframe:AddChild(gstatus)

								local grole = AceGUI:Create("Label")
								if t.role == nil then t.role = "None" end
								if inactive then grole:SetText("|c80606060"..Attune_StatusRole(t.role).."|r") else grole:SetText(Attune_StatusRole(t.role)) end
								grole:SetWidth(100)
								grole:SetFont(GameFontNormal:GetFont(), 12, "")
								gframe:AddChild(grole)

							end

							local glast = AceGUI:Create("Label")
							if t.survey == nil or t.survey == 0 then 
								glast:SetText("    -")
								if inactive then glast:SetText("|c80606060    -|r") else glast:SetText("    -") end
							else 
								--glast:SetText("    "..AttuneLang['Seconds ago']:gsub("##DURATION##", Attune_formatTime(time() - t.survey)) )
								glast:SetText("    "..date("%d %b %Y at %H:%M", t.survey) )
								if inactive then glast:SetText("|c80606060    "..date("%d %b %Y at %H:%M", t.survey).."|r") else glast:SetText("    "..date("%d %b %Y at %H:%M", t.survey) ) end
							end
							glast:SetWidth(190)
							glast:SetFont(GameFontNormal:GetFont(), 12, "")
							gframe:AddChild(glast)


						if attunelocal_charKey ~= kt then
							-- add a delete button, to allow removing players from our data (for example if they changed guilds)
							local gdel = AceGUI:Create("Button")
							gdel:SetText("X")
							gdel:SetWidth(50)
							gdel:SetCallback("OnClick", function()
								Attune_DB.toons[kt] = nil
								Attune_ShowResultList(label) -- profiles disabled
								-- if attunelocal_showResultAttunes then Attune_ShowResultList(label)
								-- else Attune_ShowProfileList(label)	end

							end)
							gframe:AddChild(gdel)
						end

						-- add the row to the list
						attunelocal_glist:AddChild(gframe)
						attunelocal_gscroll.content.obj.content:SetHeight(attunelocal_frame.frame:GetHeight() - 80)
					end) -- end of timer function
				end
			end
		end
	end

	attunelocal_gflabel:SetText(AttuneLang["Characters"].." ("..count..")")
	attunelocal_gscroll.content.obj.content:SetHeight(attunelocal_frame.frame:GetHeight() - 80)

end]=]


-------------------------------------------------------------------------

function Attune_StatusRole(keyword)

	if keyword == "None" then return "-" end

	if keyword == "Main" then return AttuneLang["Main"] end
	if keyword == "Alt" then return AttuneLang["Alt"] end

	if keyword == "Tank" then return AttuneLang["Tank"] end
	if keyword == "Healer" then return AttuneLang["Healer"] end
	if keyword == "Melee" then return AttuneLang["Melee DPS"] end
	if keyword == "Ranged" then return AttuneLang["Ranged DPS"] end

	if keyword == "Bank" then return AttuneLang["Bank"] end
end

-------------------------------------------------------------------------

function Attune_IfNilZero(val)
	if val == nil then return 0
	else return val end
end


function Attune_count(tab)
	local attunelocal_count = 0
	for Index, Value in pairs(tab) do
		attunelocal_count = attunelocal_count + 1
	end
	return attunelocal_count

end


-------------------------------------------------------------------------
-- Send the Addon request (surve) to the selected channel
-------------------------------------------------------------------------

function Attune_SendRequest(what)

	local IsTarget = Attune_split(what, "|")

	Attune_DB.survey = {}
	if IsTarget[1] == "Target" then 
		-- local tar = IsTarget[2] .. "-" .. attunelocal_realm
        -- print("tar", tar)
		if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["SendingSurveyTo"]:gsub("##TO##", IsTarget[2])) end
		Attune:SendCommMessage(attunelocal_prefix, "SILENTSURVEY", "WHISPER", IsTarget[2]);
	else
		if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["SendingSurveyWhat"]:gsub("##WHAT##", AttuneLang[what])) end
		Attune:SendCommMessage(attunelocal_prefix, "SURVEY", string.upper(what), "");
	end

end

-------------------------------------------------------------------------
-- This is the same as SendRequest('Guild') except the surveyed players
-- won't see a message saying they replied.
-- Useful for debug purposes, to not annoy players with repeated messages
-------------------------------------------------------------------------

function Attune_SendSilentGuildRequest()
	Attune_DB.survey = {}
	if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["SendingGuildSilentSurvey"]) end
	if attunelocal_myguild ~= "" then Attune:SendCommMessage(attunelocal_prefix, "SILENTSURVEY", "GUILD", ""); end

end

-------------------------------------------------------------------------
-- Same as SendRequest, but in the YELL range
-- Quirk to see who around has the addon, silently
-------------------------------------------------------------------------

function Attune_SendSilentYellRequest()
	Attune_DB.survey = {}
	if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["SendingYellSilentSurvey"]) end
	Attune:SendCommMessage(attunelocal_prefix, "SILENTSURVEY", "YELL", "");

end

-------------------------------------------------------------------------
-- Send my attune information (request results)
-- Information is sent back via addon whisper to the surveyRequestor
-- This defines what is sent back (1. toon meta, 2. steps done, 3. end)
-------------------------------------------------------------------------

function Attune_SendRequestResults(surveyRequestor)

	local meta = {}
	meta.l = UnitLevel("player")
	local attunelocal_faction = UnitFactionGroup("player")
	_, classFile = UnitClass("player")
	_, raceFile = UnitRace("player")

	local g = UnitSex("player")
	meta.g = 'male'
	if g == 3 then meta.g = 'female' end
	meta.c = classFile
	meta.r = raceFile   --Scourge, Troll, etc
	--meta.owner = 1

	local guildName, guildRankName, guildRank = GetGuildInfo("player");
	if guildName == nil then
		meta.o = 0 --not officer
		guildName = ""
	else
		if guildRank == 0 or CanGuildRemove() then
			meta.o = 1 --officer
		else
			meta.o = 0 --not officer
		end
	end
	attunelocal_myguild = guildName

	local att = Attune_DB.toons[attunelocal_charKey]
	if att.status == nil then att.status = "None" end
	if att.role == nil then 
		if meta.c == "MAGE" or meta.c == "WARLOCK"  or meta.c == "HUNTER" then att.role = "Ranged"
		elseif meta.c == "ROGUE" then att.role = "Melee"
		else att.role = "None" end
	end

	-- Send a first response with the player metadata	
	Attune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|TOON|" .. meta.g  .. "|" .. meta.c .. "|" .. meta.r .. "|" .. meta.l .. "|" .. meta.o .. "|".. guildName.."|"..attunelocal_version.."|"..att.status.."|"..att.role, "WHISPER", surveyRequestor)  --the last pipe is in case the guildname is empty. still need it as blank, not nil


	-- then send a bunch of followup whispers with the completed steps
	for key, status in pairs(att.done) do
		if status then --step done
			Attune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|DONE|" .. key, "WHISPER", surveyRequestor)
		end
	end

	-- Send a closing message after a bit (to make sure it arrives last)
	C_Timer.After(0.250, function()
		Attune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|OVER", "WHISPER", surveyRequestor)
	end)

end



-------------------------------------------------------------------------
-- Send my attune information (automatic push on completion)
-- Information is sent via addon guild spam
-- This defines what is sent back (1. toon meta, 2. steps done, 3. end)
-------------------------------------------------------------------------

function Attune_SendPushInfo(step)

	if step == "TOON" then 
		local meta = {}
		meta.l = UnitLevel("player")
		local attunelocal_faction = UnitFactionGroup("player")
		_, classFile = UnitClass("player")
		_, raceFile = UnitRace("player")

		local g = UnitSex("player")
		meta.g = 'male'
		if g == 3 then meta.g = 'female' end
		meta.c = classFile
		meta.r = raceFile   --Scourge, Troll, etc
		--meta.owner = 1

		local guildName, guildRankName, guildRank = GetGuildInfo("player");
		if guildName == nil then
			meta.o = 0 --not officer
			guildName = ""
		else
			if guildRank == 0 or CanGuildRemove() then
				meta.o = 1 --officer
			else
				meta.o = 0 --not officer
			end
		end
		attunelocal_myguild = guildName

		local att = Attune_DB.toons[attunelocal_charKey]
		if att.status == nil then att.status = "None" end
		if att.role == nil then 
			if meta.c == "MAGE" or meta.c == "WARLOCK"  or meta.c == "HUNTER" then att.role = "Ranged"
			elseif meta.c == "ROGUE" then att.role = "Melee"
			else att.role = "None" end
		end

		-- Send a first response with the player metadata
		if attunelocal_myguild ~= "" then Attune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|TOON|" .. meta.g  .. "|" .. meta.c .. "|" .. meta.r .. "|" .. meta.l .. "|" .. meta.o .. "|".. guildName.."|"..attunelocal_version.."|"..att.status.."|"..att.role, "GUILD") end --the last pipe is in case the guildname is empty. still need it as blank, not nil

	elseif step == "OVER" then 
		-- Send a closing message after a bit (to make sure it arrives last)
		C_Timer.After(0.250, function()
			if attunelocal_myguild ~= "" then Attune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|SILENTOVER", "GUILD") end
		end)

	else
		-- then send the data for that newly completed steps
		if attunelocal_myguild ~= "" then Attune:SendCommMessage(attunelocal_prefix, attunelocal_myFullName .. "|SILENTDONE|" .. step, "GUILD") end
	end

end


-------------------------------------------------------------------------
-- Handle the replies from the survey
-- Typically comes as 1 'meta' whisper, many 'step' whispers and 1 'over'
--    META contains: name|TOON|gender|class|race|level|officer|guild
--    STEP contains: name|DONE|attune-step
--    OVER contains: name|OVER|
-------------------------------------------------------------------------

function Attune_HandleRequestResults(response)

	--consolidate responses
	local data = Attune_split(response, "|")
	local name = data[1]    --.."-"..attunelocal_realm
	local tag = data[2]


	Attune_DB.survey[name] = 1

	-- initialize the record for this player
	--	if attunelocal_data[name] == nil then attunelocal_data[name] = {} end
	--	local player = attunelocal_data[name]
	if Attune_DB.toons[name] == nil then Attune_DB.toons[name] = {} end
	local player = Attune_DB.toons[name]


	-- META reply
	if tag == 'TOON' then
		attunelocal_refreshDone = false
		attunelocal_count = attunelocal_count + 1
		player.name = data[1] -- full name
		player.gender = data[3]	--gender
		player.class = data[4]	--class
		player.race = data[5]	--race
		player.level = data[6]	--level
		player.officer = data[7]	--officer in their guild
		player.guild = data[8]	--guild
		player.version = data[9]	--version
		player.faction = UnitFactionGroup("player")
		player.survey = time()	--time of last survey
		if (data[10] ~= nil and data[10] ~= "None" and data[10] ~= "-") then player.status = data[10];	end --status
		if (data[11] ~= nil and data[11] ~= "None" and data[11] ~= "-") then player.role = data[11]; end	--role
		

		if player.status == nil then player.status = "None" end
		if player.role == nil then player.role = "None" end
		--print(""..player.name .." NORM "..player.status .. " / " .. player.role)

		if player.role == "None" then 
			if player.class == "MAGE" or player.class == "WARLOCK"  or player.class == "HUNTER" then player.role = "Ranged"
			elseif player.class == "ROGUE" then player.role = "Melee"
			end
		end

		if player.attuned == nil then player.attuned = {} end
		for i, a in pairs(Attune_Data.noattunes) do
			--mark as automatically attuned for those raids that do not require attunement
			if player.attuned[a.ID] == nil then player.attuned[a.ID] = 100 end
		end
			

		-- check if this is the requester or someone else
		if player.name == attunelocal_myFullName then player.owner = 1 else player.owner = 0 end

		-- initialize the STEP container
		if player.done == nil then	player.done = {}	end

		if player.version ~= nil then
			if player.version > attunelocal_version and not attunelocal_detectedNewer then
				attunelocal_detectedNewer = true
				if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["NewVersionAvailable"].." (v"..player.version..")") end-- detected someone with a newer version, warn the user
			end
		end

	elseif tag == 'TOONROLE' then
		if player.name ~= nil and data[3] ~= "None" then player.role = data[3] end   --don't add new members like this (not enough metadata)
--		print("received from "..player.name .." TOON role "..player.role)
	
	elseif tag == 'TOONSTATUS' then
		if player.name ~= nil and data[3] ~= "None" then player.status = data[3] end   --don't add new members like this (not enough metadata)
--		print("received from "..player.name .." TOON status "..player.status)


	-- STEP replies
	elseif tag == 'DONE' or tag == 'SILENTDONE' then
		--print("DONE " .. player.name .. ": " ..data[3])
		attunelocal_refreshDone = false
		-- DONE can arrive before TOON (or for a toon stub without done); ensure the table exists
		if player.done == nil then player.done = {} end
		player.done[data[3]] = 1 -- step
		if tag == 'SILENTDONE' then 
			--print("Received ".. data[3] .. " from " .. player.name)
			for i, s in Attune_spairs(Attune_Data.steps, function(t,a,b) 	return tonumber(t[b].ID) > tonumber(t[a].ID) end) do
				if showPatchStep(s) then
					if data[3] == (s.ID_ATTUNE .. "-" .. s.ID) then
						-- recurse into earlier steps to mark them as done too
						C_Timer.After(0.01, function() Attune_recursePreviousSteps(name, s.ID_ATTUNE, s.FOLLOWS) end)
					end
				end
			end
		end


	-- OVER reply
	elseif tag == 'OVER' or tag == 'SILENTOVER' then
		--print(tag.." " .. player.name)
		attunelocal_refreshDone = false

		if player.name ~= attunelocal_myFullName then
			if tag == 'OVER' and Attune_DB.showResponses then print("|cffff00ff[Attune]|r "..AttuneLang["ReceivedDataFromName"]:gsub("##NAME##",  player.name)) end -- received data from someone else, might as well announce it in chat
			Attune_CheckIsNext(name)
		end

		-- Wait a few seconds before refreshing the result tab, to avoid refreshing it multiple times
		C_Timer.After(5, function()
			if attunelocal_frame ~= nil then
				if not attunelocal_treeIsShown then
					if not attunelocal_refreshDone then 
						attunelocal_refreshDone = true
						Attune_ShowResultList() -- update result tab if already shown (profiles disabled)
						-- if attunelocal_showResultAttunes then Attune_ShowResultList()
						-- else Attune_ShowProfileList()	end
					end
-- Disabling the auto-swap to results as it's confusing					
--				else
--					if not attunelocal_initial then
--						attunelocal_resultselection = 0
--						Attune_ToggleView()
--					end
				end
				attunelocal_initial = false -- disable the 'no announce on first load'
			end
		end)
	end

end

-------------------------------------------------------------------------
-- encode data and show popup to copy it
-------------------------------------------------------------------------

function Attune_ExportToWebsite()

	attunelocal_data = {}
	attunelocal_data['_realm'] = GetRealmName() --attunelocal_realm
	attunelocal_data['_faction'] = UnitFactionGroup("player")

	local count = 0

	-- parse all recorded toons
	for kt, t in pairs(Attune_DB.toons) do

		-- only look at current faction and realm
		-- if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then  -- removing realm
        if t.faction == UnitFactionGroup("player") and (kt == t.name) then

			-- export data:
			-- 		if attunelocal_exportselection == 0, only this player
			-- 		if attunelocal_exportselection == 1, players that have been put in the survey list
			--		if attunelocal_exportselection == 2, all players in the same guild
			--		if attunelocal_exportselection == 3, all players recorded
			-- 		if attunelocal_exportselection == 4, all this player's data (main and alts)
			if (attunelocal_exportselection == 0 and kt == (attunelocal_charKey))
			or (attunelocal_exportselection == 4 and t.owner == 1)
			or (attunelocal_exportselection == 1 and Attune_DB.survey[kt])
			or (attunelocal_exportselection == 2 and ((attunelocal_myguild ~= "" and t.guild == attunelocal_myguild) or t.name == attunelocal_myFullName))
			or (attunelocal_exportselection == 3) then

				count = count + 1
				attunelocal_data[t.name] = {}
				attunelocal_data[t.name].g = t.gender
				attunelocal_data[t.name].c = t.class
				attunelocal_data[t.name].r = t.race
				attunelocal_data[t.name].l = t.level
				attunelocal_data[t.name].o = t.officer
				attunelocal_data[t.name].G = t.guild
				--attunelocal_data[t.name].f = t.faction
				attunelocal_data[t.name].owner = t.owner
				attunelocal_data[t.name].done = "-1"
				attunelocal_data[t.name].ro = t.role
				attunelocal_data[t.name].st = t.status
				attunelocal_data[t.name].s = t.survey

				for i, d in pairs(t.done) do
					attunelocal_data[t.name].done = attunelocal_data[t.name].done .. "|" .. i
				end
			end
		end
	end


	if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["ExportingData"]:gsub("##COUNT##", count)) end

	local serattunelocal_data = Attune_serialize(attunelocal_data)
	local ser = attunelocal_version .. "##" .. serattunelocal_data

	local encoded = Attune_enc(ser)

	StaticPopupDialogs["EXPORT_ATTUNE_GUILD"] = {
		text = AttuneLang["Copy the text below, then upload it to"].."\n\nhttps://warcraftratings.com/attune/upload",
		button1 = AttuneLang["Close"],
		OnShow = function (self, data)
			local editBox = self.EditBox or self.editBox
			editBox:SetText(""..encoded)
			editBox:HighlightText()
			editBox:SetScript("OnEscapePressed", function(self) StaticPopup_Hide ("EXPORT_ATTUNE_GUILD") end)

		end,
		timeout = 0,
		hasEditBox = true,
		editBoxWidth = 350,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	StaticPopup_Show ("EXPORT_ATTUNE_GUILD")

end



-------------------------------------------------------------------------
-- send a request for a full Sync
-------------------------------------------------------------------------

function Attune_SendSyncRequest()
	if not UnitExists("target") then 
		if attunelocal_frame ~= nil then
			attunelocal_frame:SetStatusText(AttuneLang["No Target"])
			C_Timer.After(3, function()
				attunelocal_frame:SetStatusText(attunelocal_statusText)
			end)
		end
	else

		if attunelocal_syncStatus ~= -1 then 
			if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["Cannot sync while another sync is in progress"]) end
		else 
            local targetFirst, targetLast = UnitName("target")
			attunelocal_syncTarget = targetFirst .. " " .. targetLast -- .. "-" .. GetRealmName()

			StaticPopupDialogs["SYNC_CONFIRM"] = {
				text = AttuneLang["Sending Sync Request"]:gsub("##PLAYER##", attunelocal_syncTarget) .. "\n\n" .. AttuneLang["Could be slow"],
				button1 = AttuneLang["Accept"],
				button2 = AttuneLang["Reject"],
				timeout = 0,
				hasEditBox = false,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				OnAccept = function()
					Attune_SentActualSyncRequest()
				end,
				OnCancel = function (_,reason)
					attunelocal_syncTarget = nil
				end,
			}
			StaticPopup_Show ("SYNC_CONFIRM")
		end
	end
end 

-------------------------------------------------------------------------

function Attune_SentActualSyncRequest()
	
	if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["Sending Sync Request"]:gsub("##PLAYER##", attunelocal_syncTarget)) end
	attunelocal_syncStatus = 1
	--Attune:SendCommMessage(attunelocal_syncprefix, "SYNCREQ", "WHISPER", attunelocal_syncTarget)

	local ser = Attune_serialize(Attune_DB.toons):gsub(" = ", "="):gsub("   ", ""):gsub(" }", "}")
	--print("about to send:" ..#ser)
	Attune:SendCommMessage(attunelocal_syncprefix, "SYNCREQ|"..#ser, "WHISPER", attunelocal_syncTarget)
	
	-- Close request after 10s if no response
	C_Timer.After(10, function() 
		if attunelocal_syncStatus == 1 then
			--if attunelocal_frame ~= nil then
			--	attunelocal_frame:SetStatusText(AttuneLang["No Response From"]:gsub("##PLAYER##", attunelocal_syncTarget))
			--else 
				if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["No Response From"]:gsub("##PLAYER##", attunelocal_syncTarget)) end
			--end
			attunelocal_syncStatus = -1
			attunelocal_syncTarget = nil
			C_Timer.After(3, function()
				if attunelocal_frame ~= nil then
					 attunelocal_frame:SetStatusText(attunelocal_statusText) 
				end
			end)
		end
	end)
end

-------------------------------------------------------------------------

function Attune_StartSync()

	attunelocal_syncStatus = 2
	if attunelocal_syncStartTime == nil then attunelocal_syncStartTime = GetTime() end
	if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["Request accepted, sending data to "]:gsub("##PLAYER##", attunelocal_syncTarget)) end

	--reuse object when possible
	local exist = false
	for _, f in ipairs(attunelocal_syncProgress_frames) do if f == "Attune_SyncProgress_Frame" then exist = true end end
	if exist then 	attunelocal_syncProgressWidget = _G["Attune_SyncProgress_Frame"] -- reuse
	else			attunelocal_syncProgressWidget = CreateFrame("Frame", "Attune_SyncProgress_Frame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
					table.insert(attunelocal_syncProgress_frames, "Attune_SyncProgress_Frame") -- recording, to reuse
	end


	attunelocal_syncProgressWidget:SetWidth(270)
	attunelocal_syncProgressWidget:SetHeight(50)
	attunelocal_syncProgressWidget:SetPoint("BOTTOM",UIParent, 0, 150)
	attunelocal_syncProgressWidget:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 32, edgeSize = 8, insets = { left = 2, right = 2, top = 2, bottom = 2 }	})
	attunelocal_syncProgressWidget:SetBackdropColor(0,0,0,1)
	attunelocal_syncProgressWidget:EnableMouse(true)
	attunelocal_syncProgressWidget:SetMovable(true)
	attunelocal_syncProgressWidget:SetFrameStrata("FULLSCREEN_DIALOG")
	attunelocal_syncProgressWidget:RegisterForDrag("LeftButton","RightButton");
	attunelocal_syncProgressWidget:SetClampedToScreen(true)
	attunelocal_syncProgressWidget:SetScript("OnDragStart", function()	attunelocal_syncProgressWidget:StartMoving()	end)
	attunelocal_syncProgressWidget:SetScript("OnDragStop", function()	attunelocal_syncProgressWidget:StopMovingOrSizing();	end)
	attunelocal_syncProgressWidget:Show()


	local attunelocal_syncProgressLabel = nil
	local exist = false
	for _, f in ipairs(attunelocal_syncProgress_frames) do if f == "Attune_SyncProgress_Label" then exist = true end end
	if exist then 	attunelocal_syncProgressLabel = _G["Attune_SyncProgress_Label"] -- reuse
	else			attunelocal_syncProgressLabel = attunelocal_syncProgressWidget:CreateFontString("Attune_SyncProgress_Label")
					table.insert(attunelocal_syncProgress_frames, "Attune_SyncProgress_Label") -- recording, to reuse
	end
	attunelocal_syncProgressLabel:SetPoint("TOPLEFT",attunelocal_syncProgressWidget, 10, -10)
	attunelocal_syncProgressLabel:SetFont(GameFontNormal:GetFont(), 12, "")
	attunelocal_syncProgressLabel:SetText(AttuneLang["Syncing Attune data with"]:gsub("##PLAYER##", attunelocal_syncTarget))
	

	attunelocal_syncProgressStatusBar = nil
	local exist = false
	for _, f in ipairs(attunelocal_syncProgress_frames) do if f == "Attune_SyncProgress_StatusBar" then exist = true end end
	if exist then 	attunelocal_syncProgressStatusBar = _G["Attune_SyncProgress_StatusBar"] -- reuse
	else			attunelocal_syncProgressStatusBar = CreateFrame("StatusBar", "Attune_SyncProgress_StatusBar", attunelocal_syncProgressWidget, BackdropTemplateMixin and "BackdropTemplate" or nil)
					table.insert(attunelocal_syncProgress_frames, "Attune_SyncProgress_StatusBar") -- recording, to reuse
	end
	attunelocal_syncProgressStatusBar:SetPoint("TOPLEFT",attunelocal_syncProgressWidget, 10, -26)
	attunelocal_syncProgressStatusBar:SetWidth(250)
	attunelocal_syncProgressStatusBar:SetHeight(10)
	attunelocal_syncProgressStatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	attunelocal_syncProgressStatusBar:GetStatusBarTexture():SetHorizTile(false)
	attunelocal_syncProgressStatusBar:SetStatusBarColor(1,0,0) 
	attunelocal_syncProgressStatusBar:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 32, edgeSize = 8, insets = { left = 2, right = 2, top = 2, bottom = 2 }	})
	attunelocal_syncProgressStatusBar:SetBackdropColor(0,0,0,1)
	attunelocal_syncProgressStatusBar:SetMinMaxValues(1, 100)
	attunelocal_syncProgressStatusBar:SetValue(0)
	attunelocal_syncProgressStatusBar:Show()


	--reduce string size
	local ser = Attune_serialize(Attune_DB.toons):gsub(" = ", "="):gsub("   ", ""):gsub(" }", "}")
	Attune:SendCommMessage(attunelocal_syncprefix, ser, "WHISPER", attunelocal_syncTarget, "BULK", Attune_OnChunkSent)

end

-------------------------------------------------------------------------

function Attune_OnChunkSent(arg, done, total)

	attunelocal_syncChunksSent = attunelocal_syncChunksSent + 1
	
	attunelocal_syncAmountToSend = total
	attunelocal_syncAmountSent = done
	attunelocal_syncProgressStatusBar:SetMinMaxValues(1, attunelocal_syncAmountToSend + attunelocal_syncAmountToReceive)
	attunelocal_syncProgressStatusBar:SetValue(attunelocal_syncAmountSent + attunelocal_syncAmountReceived)

	-- this is for the receiver to also show some progress (otherwise it will be stuck until this send is completely done)
	if attunelocal_syncChunksSent >= 10 then 
		Attune:SendCommMessage(attunelocal_syncprefix, "SYNCDONE|"..attunelocal_syncAmountSent, "WHISPER", attunelocal_syncTarget)
		attunelocal_syncChunksSent = 0
	end

	if (attunelocal_syncAmountSent + attunelocal_syncAmountReceived) >= (attunelocal_syncAmountToSend + attunelocal_syncAmountToReceive) then
		attunelocal_syncStatus = -1
		if attunelocal_syncStartTime ~= nil then
			if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["Sync over"]:gsub("##DURATION##", Attune_formatTime(Attune_Round(GetTime() - attunelocal_syncStartTime, 0)))) end
		end
		attunelocal_syncProgressWidget:Hide()
		attunelocal_syncStartTime = nil
	end

end


-------------------------------------------------------------------------


function Attune:OnCommReceived(prefix, message, distribution, sender)

	--Sync channel
	if prefix == attunelocal_syncprefix then
		local amount = 0 
		if string.find(message, "|") then 
			local amess = Attune_split(message, "|")
			message = amess[1]
			amount = tonumber(amess[2])
		end

		if message == 'SYNCREQ' then
			if attunelocal_syncStatus ~= -1 then 
				Attune:SendCommMessage(attunelocal_syncprefix, "SYNCBUSY", "WHISPER", sender)
			else
				--print("about to receive:" ..amount)
				attunelocal_syncTarget = sender
				attunelocal_syncAmountToReceive = amount
				attunelocal_syncAmountReceived = 0
	
				if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["Received request from"]:gsub("##PLAYER##", attunelocal_syncTarget)) end
				PlaySound(6675) -- BellTollTribal
				StaticPopupDialogs["SYNC_ATTUNE"] = {
					text = AttuneLang["Sync Request From"]:gsub("##PLAYER##", attunelocal_syncTarget).."\n\n"..AttuneLang["Could be slow"],
					button1 = AttuneLang["Accept"],
					button2 = AttuneLang["Reject"],
					timeout = 9,
					hasEditBox = false,
					whileDead = true,
					hideOnEscape = true,
					preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
					OnAccept = function()
						attunelocal_syncStatus = 2
						local ser = Attune_serialize(Attune_DB.toons):gsub(" = ", "="):gsub("   ", ""):gsub(" }", "}")
						--print("about to send:" ..#ser)
						Attune:SendCommMessage(attunelocal_syncprefix, "SYNCOK|"..#ser, "WHISPER", attunelocal_syncTarget)
						Attune_StartSync()
					end,
					OnCancel = function (_,reason)
						attunelocal_syncStatus = -1
						Attune:SendCommMessage(attunelocal_syncprefix, "SYNCNOK", "WHISPER", attunelocal_syncTarget)
						if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["Request rejected"]) end
					end,
				}
				StaticPopup_Show ("SYNC_ATTUNE")
			end

		elseif message == 'SYNCOK' then
			--print("about to receive:" ..amount)
			attunelocal_syncAmountToReceive = amount
			Attune_StartSync()

		elseif message == 'SYNCNOK' then
			attunelocal_syncStatus = -1
			if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["Request rejected"]) end

		elseif message == 'SYNCBUSY' then
			attunelocal_syncStatus = -1
			if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..AttuneLang["Busy right now"]:gsub("##PLAYER##", sender)) end

		elseif message == 'SYNCDONE' then
			attunelocal_syncAmountReceived = amount
			--print("Processed so far " .. (attunelocal_syncAmountReceived + attunelocal_syncAmountSent) .. " / " .. (attunelocal_syncAmountToReceive + attunelocal_syncAmountToSend))
			Attune_OnChunkSent(arg, attunelocal_syncAmountSent, attunelocal_syncAmountToSend)

		else

			local SyncedToons = Attune_deserialize(message)
			for kt, t in pairs(SyncedToons) do
				t.owner = 0 -- force imports to be marked as not own
				
				if Attune_DB.toons[kt] == nil then
					--new toon
					Attune_DB.toons[kt] = t
				else 
					if Attune_DB.toons[kt].owner == 0 then -- do not update my own toons

						-- Check which data set has the latest survey
						if t.survey ~= nil and Attune_DB.toons[kt].survey ~= nil then 
							if t.survey > Attune_DB.toons[kt].survey then 
								-- Already have it, but this one is newer
								Attune_DB.toons[kt] = t
							end
						else 
							if t.survey ~= nil then 
								-- Already have it, but this one is newer (as the other doesn't have a date)
								Attune_DB.toons[kt] = t
							end
						end
					end
				end
			end
			C_Timer.After(1, function()
				if attunelocal_frame ~= nil then
					if not attunelocal_treeIsShown then
						Attune_ShowResultList() -- update result tab if already shown (profiles disabled)
						-- if attunelocal_showResultAttunes then Attune_ShowResultList()
						-- else Attune_ShowProfileList()	end
					else
						if not attunelocal_initial then
							attunelocal_resultselection = 0
							Attune_ToggleView()
						end
					end
					attunelocal_initial = false -- disable the 'no announce on first load'
				end
			end)
			
			attunelocal_syncAmountReceived = attunelocal_syncAmountToReceive
			Attune_OnChunkSent(arg, attunelocal_syncAmountSent, attunelocal_syncAmountToSend)
		end
	end
end 


-------------------------------------------------------------------------

function Attune_spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[Attune_count(keys)+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-------------------------------------------------------------------------

function Attune_serialize (o)
	local res = ""
	if type(o) == "number" then
	  res = res .. o
	elseif type(o) == "string" then
		res = res .. string.format("%q", o)
	elseif type(o) == "table" then
		res = res .. "{ "
	  for k,v in pairs(o) do
		if type(k) == "number" then
			res = res .. "  [" .. k .. "] = "
		elseif type(k) == "string" then
			 res = res .. "  [\"" .. k .. "\"] = "
		end
		res = res .. Attune_serialize(v)
		res = res .. ", "
	  end
	  res = res ..  "}"
	elseif type(o) == "boolean" then
		if o then res = res .. "true"
		else res = res .. "false" end
	else
	  error("cannot serialize a " .. type(o))
	end
	return res
end

-------------------------------------------------------------------------
 
function Attune_deserialize(input)
	if type(input) == 'string' then
	   	local data = input
	   	local pos = 0
	   	function input(undo)
			if undo then
				pos = pos - 1
		  	else
				pos = pos + 1
				return string.sub(data, pos, pos)
		  	end
	   	end
	end

	local c
	repeat
		c = input()
	until c ~= ' ' and c ~= ','

	if c == '"' then
		--string value
	   	local s = ''
	   	repeat
		  	c = input()
		  	if c == '"' then
				--print("s = "..s)
				return s
		  	end
		  	s = s..c
	   	until c == ''

	elseif c == '-' or Attune_is_digit(c) then
		-- number value
	   	local s = c
	   	repeat
			c = input()
			local d = Attune_is_digit(c)
			if d then
				s = s..c
		  	end
	   	until not d
	   	input(true)
		--print("n = "..s)
	   return tonumber(s)

	elseif c == '[' then
		--print("[]")
		--Associative
	   	local o = ''
	   	repeat
		  c = input()
		  if c == ']' then
			 break
		  end
		  o = o..c
	   	until c == ''
		o = o:gsub('"', "") -- removing extra ""
	   	repeat
			c = input()
		until c == '='
		--print("o = "..o)

		local subarr = {}
		elem = Attune_deserialize(input)
		
		table.insert(subarr, "assoc")
		table.insert(subarr, o)
		table.insert(subarr, elem)
		return subarr

	elseif c == '{' then
		--array
		--print("{}")
	   	local arr = {}
	   	local elem
	   	repeat
		  	elem = Attune_deserialize(input)
			--print(type(elem))
		  	if type(elem) == 'table' then
				if elem[1] == "assoc" then 
					arr[elem[2]] = elem[3]
				else 
					table.insert(arr, elem)
				end
		  	else 
		  		table.insert(arr, elem)
			end
	   	until not elem
	   	return arr
	end
 end

------------------------------------------------------------------------- 

function Attune_is_digit(c)
	return c >= '0' and c <= '9'
end

-------------------------------------------------------------------------

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
-- encoding
function Attune_enc(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-------------------------------------------------------------------------
-- decoding
function Attune_dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

-------------------------------------------------------------------------

function Attune_formatTime(sec)
	local str = ""

	if sec ~= nil then
		local minutes, hours
		if (sec<60) then
			str = ""..sec.."sec"
		else
			minutes = math.floor(sec/60)
			sec = sec - (minutes*60)
			if (minutes<60) then
				str =  ""..minutes.."min"
			else
				hours = math.floor(minutes/60)
				minutes = minutes - (hours*60)
				str = ""..hours.."h"
				if (minutes > 0) then str = str .. " "..minutes.."min" end
			end
			if (sec > 0) then str = str .. " "..sec.."sec" end
		end
	else
		str = ""
	end
	return str
end

-------------------------------------------------------------------------

function Attune_split(str, sep)
	local t = {}
	local ind = string.find(str, sep)
	while (ind ~= nil) do
		table.insert(t, string.sub(str, 1, ind-1))
		str = string.sub(str, ind+1)
		ind = string.find(str, sep, 1, true)
	end
	if (str ~="") then table.insert(t, str) end
	return t
end

-------------------------------------------------------------------------
-- find if key exists in table
function Attune_locate(table, value)
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end

-------------------------------------------------------------------------

function Attune_Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-------------------------------------------------------------------------

function Attune_Icons(what, gender)
	local icon = "Interface/Icons/inv_misc_questionmark"
	if (what == "DRUID") 	then icon = "Interface\\Icons\\inv_misc_monsterclaw_04" end
	if (what == "HUNTER") 	then icon = "Interface\\Icons\\inv_weapon_bow_07" end
	if (what == "MAGE") 	then icon = "Interface\\Icons\\inv_staff_13" end
	if (what == "PALADIN") then icon = "Interface\\AddOns\\Attune\\Images\\class_paladin" end
	if (what == "PRIEST") 	then icon = "Interface\\AddOns\\Attune\\Images\\class_priest" 	end
	if (what == "ROGUE") 	then icon = "Interface\\AddOns\\Attune\\Images\\class_rogue" end
	if (what == "SHAMAN") 	then icon = "Interface\\Icons\\spell_nature_bloodlust" end
	if (what == "WARLOCK") then icon = "Interface\\Icons\\spell_nature_drowsy" end
	if (what == "WARRIOR") then icon = "Interface\\Icons\\inv_sword_27" end
	if (what == "DEATHKNIGHT") then icon = "Interface\\Icons\\Spell_deathknight_classicon" end
	if (what == "UNKNOWN") then icon = "Interface\\Icons\\Inv_misc_questionmark" end
	
	local g = 'male'
	if gender == 3 then g = 'female' end
	if (what == "Dwarf") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_dwarf_"..g end
	if (what == "Gnome") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_gnome_"..g end
	if (what == "Human") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_human_"..g end
	if (what == "NightElf") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_nightelf_"..g end
	if (what == "Orc") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_orc_"..g end
	if (what == "Tauren") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_tauren_"..g end
	if (what == "Troll") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_troll_"..g end
	if (what == "Scourge") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_undead_"..g end
	return icon
end

-------------------------------------------------------------------------

function Attune_SlashCommandHandler( msg )

	if (msg == 'help' or msg == '?') then

		print("|cffff00ff[Attune]|r "..AttuneLang["Help1"])
		print("|cffff00ff[Attune]|r "..AttuneLang["Help2"])
		print("|cffff00ff[Attune]|r ")
		print("|cffff00ff[Attune]|r "..AttuneLang["Help3"])
		print("|cffff00ff[Attune]|r "..AttuneLang["Help4"])
		print("|cffff00ff[Attune]|r "..AttuneLang["Help5"])
		print("|cffff00ff[Attune]|r ")
		print("|cffff00ff[Attune]|r "..AttuneLang["Help6"])

	elseif (msg == 'survey') then
		Attune_SendRequest("Guild");

	elseif (msg == 'silentsurvey') then
		Attune_SendSilentGuildRequest();	-- Guild check, without triggering the response message on remote toons. Mostly for debugging without annoying players

	elseif (msg == 'yell') then
		Attune_SendSilentYellRequest();		-- Check who's got the addon around you

	elseif (msg == 'sync') then
		Attune_SendSyncRequest()

	-- Raid Planner slash command disabled for now
	elseif false and ((msg == 'raid') or (msg == 'raidplanner') or (msg == 'planner')) then
		--[=[
		if attunelocal_raidframe ~= nil then
			if attunelocal_raidframe:IsShown() then 
				attunelocal_raidframe:Hide() 
			else
				Attune_RaidPlannerFrame()
			end
		else 
			Attune_RaidPlannerFrame()
		end
		]=]

	elseif (msg ~= '') then 
		Attune_SendRequest("Target|"..msg);

	elseif attunelocal_initial == false and attunelocal_frame:IsShown() then
		attunelocal_frame:Hide()
		Attune_SaveTreeExpandStatus()
		Attune_Release()
	else
		if attunelocal_initial then
			attunelocal_initial = false
			Attune_LoadTree()
			Attune_Frame()
			Attune_DB.survey = {}
			Attune_SendRequestResults(attunelocal_myFullName);  -- Send a request to myself
		end
		attunelocal_frame:Show()

	end

end


-------------------------------------------------------------------------

function Attune_Release()
	--[[
	if attunelocal_glist ~= nil then attunelocal_glist:ReleaseChildren() end
	if attunelocal_scroll ~= nil then attunelocal_scroll:ReleaseChildren() end
	if attunelocal_raidroster ~= nil then attunelocal_raidroster:ReleaseChildren() end
	if attunelocal_frame ~= nil then attunelocal_frame:ReleaseChildren() end
]]
end

--[=[ Raid Planner disabled for now
-------------------------------------------------------------------------

function Attune_LoadRaidTree()
	attunelocal_raidtree = {}


	local tankNode = {
		value = "Tank",
		text =  Attune_StatusRole("Tank"),
		children = {}
	}
	local healerNode = {
		value = "Healer",
		text =  Attune_StatusRole("Healer"),
		children = {}
	}
	local meleeNode = {
		value = "Melee",
		text =  Attune_StatusRole("Melee"),
		children = {}
	}
	local rangedNode = {
		value = "Ranged",
		text =  Attune_StatusRole("Ranged"),
		children = {}
	}
	local unspecNode = {
		value = "Unspec",
		text =  AttuneLang["Unspecified"],
		children = {}
	}
	
	for kt, t in Attune_spairs(Attune_DB.toons, function(t,a,b) return t[b].class > t[a].class end) do
		
		--only look at current faction and realm
		if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then
			--check they are attuned
			if Attune_DB.raidShowUnattuned or t.attuned[""..Attune_DB.raidSelection[attunelocal_faction]] >= 100 then
				
				if ((Attune_DB.raidShowMains and t.status == "Main") 
				or (Attune_DB.raidShowAlts and t.status == "Alt")
				or (Attune_DB.raidShowUnspecified and t.status == "None"))
				and (not Attune_DB.raidGuildOnly or t.guild == attunelocal_myguild)   then

					local tt = t.name
					if Attune_IsRaidSelected(t.name) ~= "" then tt = "|cff606060"..t.name.."|r" end

					local toonNode = {
						value = t.name,
						text = tt,
						icon = Attune_Icons(t.class),
					}
					
					if t.role == "Tank" then table.insert(tankNode.children, toonNode)
					elseif t.role == "Healer" then table.insert(healerNode.children, toonNode)
					elseif t.role == "Melee" then table.insert(meleeNode.children, toonNode)
					elseif t.role == "Ranged" then table.insert(rangedNode.children, toonNode)
					else table.insert(unspecNode.children, toonNode)
					end

					
				end
			end
		end
	end
	
	table.insert(attunelocal_raidtree, tankNode)
	table.insert(attunelocal_raidtree, healerNode)
	table.insert(attunelocal_raidtree, meleeNode)
	table.insert(attunelocal_raidtree, rangedNode)
	table.insert(attunelocal_raidtree, unspecNode)

end

-------------------------------------------------------------------------
-- Create the RAID PLANNER UI Frame
-------------------------------------------------------------------------

function Attune_RaidPlannerFrame()

	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then attunelocal_myguild = guildName end

	if Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]] == nil then Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]] = {} end
	if Attune_DB.raidNames[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]] == nil then Attune_DB.raidNames[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]] = {} end

	attunelocal_raidframe = AceGUI:Create("Frame")
	attunelocal_raidframe:SetTitle("  Attune Raid Planner")
	attunelocal_raidframe:SetStatusText(AttuneLang["Select a raid and click on players to add them in"])
	attunelocal_raidframe:SetHeight(620)
	attunelocal_raidframe:SetWidth(1020)
	attunelocal_raidframe:SetLayout("Flow")
	
	if attunelocal_raidframe.frame.SetResizeBounds then
		attunelocal_raidframe.frame:SetResizeBounds(620, 620)
	else
		attunelocal_raidframe.frame:SetMinResize(620, 620)
	end
	attunelocal_raidframe.frame:SetFrameStrata("HIGH")

	
    -- Register the global variable as a "special frame"
    -- so that it is closed when the escape key is pressed.
	
	_G["Attune_MainRaidFrame"] = attunelocal_raidframe.frame
    tinsert(UISpecialFrames, "Attune_MainRaidFrame")

	local options = AceGUI:Create("SimpleGroup")
	options:SetLayout("Flow")
	options:SetFullWidth(true)

		local dropd = AceGUI:Create("SimpleGroup")
		dropd:SetLayout("Flow")
		dropd:SetWidth(200)

			local raidList = {}
			for i, a in pairs(Attune_Data.attunes) do
				if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
					if a.SHOWRAIDPLANNER ~= nil and (a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both') then 
						--actual raid (not just attunement) for this faction
						raidList[tonumber(a.ID)] = a.NAME
					end
				end
			end
			for i, a in pairs(Attune_Data.noattunes) do
				--raids that require no attunement
				raidList[tonumber(a.ID)] = a.NAME
			end

			
			local raidselection = AceGUI:Create("Dropdown")
			raidselection:SetWidth(150)
			raidselection:SetList(raidList)
			raidselection:SetValue(Attune_DB.raidSelection[attunelocal_faction])
			raidselection:SetCallback("OnValueChanged", function(choice) 
				Attune_DB.raidSelection[attunelocal_faction] = choice:GetValue(); 	
				if Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]] == nil then Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]] = {} end
				if Attune_DB.raidNames[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]] == nil then Attune_DB.raidNames[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]] = {} end
				Attune_LoadRaidTree(); 	
				attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	
				Attune_RaidPlannerRoster() end)

			dropd:AddChild(raidselection)
			options:AddChild(dropd)

		

		local checkboxes = AceGUI:Create("SimpleGroup")
		checkboxes:SetLayout("Flow")
		checkboxes:SetWidth(460)

			local cb = AceGUI:Create("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(AttuneLang["Show Mains"])
			cb:SetValue(Attune_DB.raidShowMains)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	Attune_DB.raidShowMains = val; 	Attune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	Attune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			local cb = AceGUI:Create("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(AttuneLang["Show Unspecified"])
			cb:SetValue(Attune_DB.raidShowUnspecified)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	Attune_DB.raidShowUnspecified = val; 	Attune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	Attune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			local cb = AceGUI:Create("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(AttuneLang["Guildies only"])
			cb:SetValue(Attune_DB.raidGuildOnly)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	Attune_DB.raidGuildOnly = val; 	Attune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	Attune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			local cb = AceGUI:Create("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(AttuneLang["Show Alts"])
			cb:SetValue(Attune_DB.raidShowAlts)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	Attune_DB.raidShowAlts = val; 	Attune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	Attune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			local cb = AceGUI:Create("CheckBox")
			cb:SetType("checkbox")
			cb:SetLabel(AttuneLang["Show Unattuned"])
			cb:SetValue(Attune_DB.raidShowUnattuned)
			cb:SetWidth(150)
			cb:SetCallback("OnValueChanged", function(obj, evt, val)	Attune_DB.raidShowUnattuned = val; 	Attune_LoadRaidTree(); 	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	Attune_RaidPlannerRoster() 	end)
			checkboxes:AddChild(cb)

			options:AddChild(checkboxes)

		local label = AceGUI:Create("Label")
		label:SetText(" ")
		label:SetFullWidth(true)
		label:SetFont(GameFontNormal:GetFont(), 12, "")
		options:AddChild(label)

	attunelocal_raidframe:AddChild(options)

	
	Attune_LoadRaidTree()

	attunelocal_raidtreeframe = AceGUI:Create("TreeGroup")
	Attune_StyleTreeGroup(attunelocal_raidtreeframe)
	attunelocal_raidtreeframe:SetTree(attunelocal_raidtree)
	attunelocal_raidtreeframe:SetLayout("Fill")
	attunelocal_raidtreeframe:SetFullWidth(true)
	attunelocal_raidtreeframe:SetFullHeight(true)
	attunelocal_raidtreeframe:SetAutoAdjustHeight(false)
	attunelocal_raidtreeframe:EnableButtonTooltips(false)
	attunelocal_raidframe:AddChild(attunelocal_raidtreeframe)


	attunelocal_raidtreeframe:SelectByPath("Unspec")
	attunelocal_raidtreeframe:SelectByPath("Healer")
	attunelocal_raidtreeframe:SelectByPath("Melee")
	attunelocal_raidtreeframe:SelectByPath("Ranged")
	attunelocal_raidtreeframe:SelectByPath("Tank")
		
	attunelocal_raidtreeframe:SetCallback("OnGroupSelected", function(container, event, group)
		local st, le = string.find(group, "\001")
		if st ~= nil then -- not a group
			local toon = string.sub(group, st+1)
			if toon ~= "" then
				local t = Attune_DB.toons[toon.."-"..GetRealmName()]
				local found = Attune_IsRaidSelected(t.name)
				
				if found ~= "" then 
					-- already in planner -> remove
					Attune_UpdateRaidTreeGroup(t.name, false)
					Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][found] = nil
					attunelocal_raidspotIcon[found]:SetText("|TInterface\\AddOns\\Attune\\Images\\raidslot:16|t  Empty")
					attunelocal_raidspotIcon[found].frame:SetAlpha(0.25)
					attunelocal_raidspotIcon[found]:SetCallback("OnEnter", function() end)
		
				else
					-- not in planner -> add to raid. Find a spot
					local placed = Attune_FindNextRaidSpot(attunelocal_raidsize, t, 0)
					if placed then 
						Attune_UpdateRaidTreeGroup(t.name, true)
					else
					end
				end
				attunelocal_raidtreeframe:SelectByPath(t.role)
			end
		end
	end)
 
	attunelocal_raidroster = AceGUI:Create("SimpleGroup")
	attunelocal_raidroster:SetLayout("Flow")
	attunelocal_raidroster:SetFullWidth(true)
	attunelocal_raidroster:SetFullHeight(true)
	attunelocal_raidtreeframe:AddChild(attunelocal_raidroster)

	Attune_RaidPlannerRoster()
end



-------------------------------------------------------------------------
-- Update the Raid treeview to show used or unused toons
-------------------------------------------------------------------------

function Attune_UpdateRaidTreeGroup(name, selected)
	for i, a in pairs(attunelocal_raidtree) do
		if a.children ~= nil then 
			for i2, a2 in pairs(a.children) do
				if a2.value == name then
					if selected then
						a2.text = "|cff606060"..name.."|r"
					else 
						a2.text = name
					end
				end
			end
		end
	end
end
-------------------------------------------------------------------------


function Attune_RaidPlannerRoster()

	attunelocal_raidroster:ReleaseChildren()

	for i, a in pairs(Attune_Data.attunes) do
		if (a.DEPRECATED == nil or Attune_DB.showDeprecatedAttunes) then 
			if tonumber(a.ID) == Attune_DB.raidSelection[attunelocal_faction] then 
				attunelocal_raidname = a.NAME
				attunelocal_raidsize = a.GROUPSIZE
				attunelocal_raidcount = a.SHOWRAIDPLANNER
			end
		end
	end
	for i, a in pairs(Attune_Data.noattunes) do
		if tonumber(a.ID) == Attune_DB.raidSelection[attunelocal_faction] then 
			attunelocal_raidname = a.NAME
			attunelocal_raidsize = a.GROUPSIZE
			attunelocal_raidcount = a.SHOWRAIDPLANNER
		end
	end
	attunelocal_raidspotIcon = {}	

	local raidgroup = AceGUI:Create("SimpleGroup")
	raidgroup:SetLayout("Fill")
	raidgroup:SetFullHeight(true)
	--raidgroup:SetWidth(770)
	raidgroup:SetFullWidth(true)

	local raidscroll = AceGUI:Create("ScrollFrame")
	raidscroll:SetLayout("Flow")
	raidscroll:SetFullHeight(true)


	for i=1, attunelocal_raidcount, 1	do 	

		
		local rgroup = AceGUI:Create("SimpleGroup")
		rgroup:SetLayout("Flow")
		rgroup:SetWidth((attunelocal_raidsize/5)*145+50)


		local inv = AceGUI:Create("Button")
		inv:SetText(AttuneLang["Invite"])
		inv:SetWidth(70)
		inv:SetCallback("OnClick", function() 
			StaticPopupDialogs["INVITE_ATTUNE_RAID"] = {
				text = AttuneLang["Send raid invites to all listed players?"],
				button1 = AttuneLang["Accept"],
				button2 = AttuneLang["Reject"],
				timeout = 0,
				hasEditBox = false,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				OnAccept = function()
					Attune_SentRaidInvites(i)
				end,
				OnCancel = function (_,reason)
				end,
			}
			StaticPopup_Show ("INVITE_ATTUNE_RAID")
		end)
		rgroup:AddChild(inv)




		local sGroup = ""
		if attunelocal_raidcount > 1 then sGroup = " - " .. AttuneLang["Group Number"]:gsub("##NUMBER##", i) end
		
		if Attune_DB.raidNames[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][i] == nil then 
			Attune_DB.raidNames[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][i] = attunelocal_raidname .. " - " .. AttuneLang["Raid spots"]:gsub("##SIZE##", attunelocal_raidsize) .. sGroup
		end
		local label = AceGUI:Create("InteractiveLabel")
		label:SetText(" "..Attune_DB.raidNames[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][i])
		label:SetWidth((attunelocal_raidsize/5)*145+50-80)
		label.frame:SetAlpha(1)
		label:SetFont(GameFontNormal:GetFont(), 14, "")
		label:SetCallback("OnEnter", function() 
			GameTooltip:SetOwner(label.frame,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", label.frame,"BOTTOMLEFT", 10, 0)
			GameTooltip:SetText("Click to edit")
		end)				
		label:SetCallback("OnLeave", function() GameTooltip:Hide() end)
		label:SetCallback("OnClick", function() 
			StaticPopupDialogs["RENAME_ATTUNE_RAID"] = {
				text = AttuneLang["Enter a new name for this raid group"],
				hasEditBox = true,
				button1 = AttuneLang["Save"],
				button2 = AttuneLang["Close"],
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				editBoxWidth = 350,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				OnShow = function (self, data)
					local editBox = self.EditBox or self.editBox
					editBox:SetText(""..Attune_DB.raidNames[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][i])
					--editBox:HighlightText()
					editBox:SetScript("OnEscapePressed", function(self) StaticPopup_Hide ("RENAME_ATTUNE_RAID") end)
		
				end,
				OnAccept = function(self)
					local editBox = self.EditBox or self.editBox
					Attune_DB.raidNames[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][i] = editBox:GetText()
					Attune_RaidPlannerRoster()
				end,
				OnCancel = function (_,reason)
					--
				end,
				preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
				
			}
			StaticPopup_Show ("RENAME_ATTUNE_RAID")
		end)
		rgroup:AddChild(label)


		for r=1, (attunelocal_raidsize/5), 1	do 	

			local party = AceGUI:Create("InlineGroup")
			party:SetLayout("Flow")
			party:SetWidth(145)
	
			for s=1,5,1	do 	
				local spot = ((i-1)*attunelocal_raidsize) + ((r-1)*5) + s

				local icon = AceGUI:Create("InteractiveLabel")
				icon:SetCallback("OnEnter", function() 
					Attune_SetToolTip(icon.frame, nil)
				end)				

				if Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot] == nil then 
					icon:SetText("|TInterface\\AddOns\\Attune\\Images\\raidslot:16|t  Empty")
					icon.frame:SetAlpha(0.25)
					Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot] = nil
				else
					local t = Attune_DB.toons[Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot].."-"..GetRealmName()]
					if t ~= nil then 
						-- all good, toon is still in our data
						icon:SetText("|T"..Attune_Icons(t.class)..":16|t  "..t.name)
						icon.frame:SetAlpha(1)
						icon:SetCallback("OnEnter", function() 
							local gg = "<"..t.guild..">"
							if t.guild == "" then gg = AttuneLang["Not in a guild"] end

							Attune_SetToolTip(icon.frame, nil, 2)
							Attune_SetToolTip(icon.frame, t.name .. " (" .. t.level.." "..t.class:sub(1,1):upper()..t.class:sub(2):lower()..")\n|cffffffff"..gg.."|r")
						end)
					else
						-- issue. Toon has been deleted from data, empty slot
						icon:SetText("|TInterface\\AddOns\\Attune\\Images\\raidslot:16|t  Empty")
						icon.frame:SetAlpha(0.25)
						Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot] = nil
					end
				end

				icon:SetFont(GameFontNormal:GetFont(), 12, "")
				icon:SetWidth(140)
				icon:SetImageSize(32, 32)
				party:AddChild(icon)

				icon:SetCallback("OnLeave", function() GameTooltip:Hide() end)
				icon:SetCallback("OnClick", function(obj, ev, but) 
					
					if Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot] == nil then 
						-- clicking an empty tile
						-- does nothing
					else
						-- clicking a toon
						if but == "LeftButton" then 
							-- Move to the next group
							local jumpTo = spot + (5 - (spot % 5))
							if spot % 5  == 0 then jumpTo = spot end
							local placed = Attune_FindNextRaidSpot(attunelocal_raidsize, Attune_DB.toons[Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot].."-"..GetRealmName()], jumpTo )
							if placed then 
								Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot] = nil
								attunelocal_raidspotIcon[spot]:SetText("|TInterface\\AddOns\\Attune\\Images\\raidslot:16|t  Empty")
								attunelocal_raidspotIcon[spot].frame:SetAlpha(0.25)
								attunelocal_raidspotIcon[spot]:SetCallback("OnEnter", function() end)
							end
						elseif but == "RightButton" then
							-- Remove
							
							Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot] = nil
							attunelocal_raidspotIcon[spot]:SetText("|TInterface\\AddOns\\Attune\\Images\\raidslot:16|t  Empty")
							attunelocal_raidspotIcon[spot].frame:SetAlpha(0.25)
							attunelocal_raidspotIcon[spot]:SetCallback("OnEnter", function() end)
							Attune_UpdateRaidTreeGroup(Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot], false)
							Attune_LoadRaidTree(); 	
							attunelocal_raidtreeframe:SetTree(attunelocal_raidtree);	
							Attune_RaidPlannerRoster()
						end
					end
				end)
				
				attunelocal_raidspotIcon[spot] = icon   -- isUsed / icon object
				
			end
			rgroup:AddChild(party)
		end

		
		local label = AceGUI:Create("Label")
		label:SetText("\n")
		label:SetFullWidth(true)
		label:SetFont(GameFontNormal:GetFont(), 18, "")
		rgroup:AddChild(label)

		raidscroll:AddChild(rgroup)

	end
	
	raidgroup:AddChild(raidscroll)
	attunelocal_raidroster:AddChild(raidgroup)

end


-------------------------------------------------------------------------

function Attune_SentRaidInvites(raidId)
	
	local nbInv = 0
	for spot=(raidId-1)*attunelocal_raidsize+1, raidId*attunelocal_raidsize, 1	do 	

		if Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot] ~= nil then 
			nbInv = nbInv + 1
			InviteUnit(Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot])
		end 
	end
	if nbInv > 0 then 	Attune_checkRaidGroup(0) end
end


-------------------------------------------------------------------------
--check the group until someone has joined, then convert to raid

function Attune_checkRaidGroup(iter) 

	-- 50 * 0.2s = 10s
	-- this checks for 10s after the first raid invite has been sent
	local iter = iter + 1
	if iter < 50 then 
		if GetNumGroupMembers() >= 2 then 
			ConvertToRaid()
			iter = iter + 999
		else
			C_Timer.After(0.2, function() Attune_checkRaidGroup(iter) end)
		end
	end
end

-------------------------------------------------------------------------

function Attune_SetToolTip(obj, text)

	GameTooltip:SetOwner(obj,"ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", obj,"TOPRIGHT", 10, 0)

	if text == nil then 
		--GameTooltip:SetText(AttuneLang["Empty"])
	else
		GameTooltip:SetText(text)
		GameTooltip:AddLine("\n|cffA0A0A0"..AttuneLang["LeftClick"].." "..AttuneLang["Move to next group"].."\n"..AttuneLang["RightClick"].." "..AttuneLang["Remove from raid"].."|r")
	end

end

-------------------------------------------------------------------------

function Attune_FindNextRaidSpot(raidsize, t, minspot)
	-- minspot used to only select spot coming after this minspot
	local placed = false
	for i=1, (50/raidsize), 1	do 	
		for r=1, (raidsize/5), 1	do 	
			for s=1,5,1	do 	
				local spot = ((i-1)*raidsize) + ((r-1)*5) + s
				if spot > minspot then
					if Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot] == nil and not placed then
--						if attunelocal_raidtoonIcon[t.name] ~= nil then attunelocal_raidtoonIcon[t.name].frame:SetAlpha(0.25) end
						Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]][spot] = t.name
						attunelocal_raidspotIcon[spot]:SetText("|T"..Attune_Icons(t.class)..":16|t  "..t.name)
						attunelocal_raidspotIcon[spot].frame:SetAlpha(1)
						attunelocal_raidspotIcon[spot]:SetCallback("OnEnter", function() 
							local gg = "<"..t.guild..">"
							if t.guild == "" then gg = AttuneLang["Not in a guild"] end
							Attune_SetToolTip(attunelocal_raidspotIcon[spot].frame, t.name .. " (" .. t.level.." "..t.class:sub(1,1):upper()..t.class:sub(2):lower()..")\n|cffffffff"..gg.."|r")
						end)
						placed = true
						break				
					end
				end
			end
		end
	end
	return placed
end

-------------------------------------------------------------------------

function Attune_IsRaidSelected(name)
	-- check if already selected.
	for kr, r in pairs(Attune_DB.raidPlans[attunelocal_faction][Attune_DB.raidSelection[attunelocal_faction]]) do
		if r == name then return kr end
	end
	return ""
end]=]


-------------------------------------------------------------------------

local attunelocal_rewardFrame
local ATTUNE_REWARD_WIDTH = 300

local function Attune_RewardQuestIDs(idWowhead)
	local ids = {}
	local raw = tostring(idWowhead or "")
	if string.find(raw, "|", 1, true) then
		for _, part in pairs(Attune_split(raw, "|")) do
			local n = tonumber(part)
			if n then table.insert(ids, n) end
		end
	else
		local n = tonumber(raw)
		if n then table.insert(ids, n) end
	end
	return ids
end

local function Attune_AddReward(list, seen, itemID, name, texture, count, quality, choice)
	itemID = tonumber(itemID)
	if not itemID or itemID <= 0 then return end
	if seen[itemID] then return end
	seen[itemID] = true
	if type(name) ~= "string" or name == "" then name = nil end
	table.insert(list, {
		itemID = itemID,
		name = name,
		texture = texture,
		count = tonumber(count) or 1,
		quality = tonumber(quality),
		choice = choice and true or nil,
	})
end

local function Attune_ReadIndexedRewards(countFn, infoFn, questID, list, seen, choice)
	if type(countFn) ~= "function" or type(infoFn) ~= "function" then return end
	local ok, num = pcall(countFn, questID)
	if not ok or type(num) ~= "number" or num <= 0 then return end
	if num > 40 then num = 40 end
	for i = 1, num do
		local okInfo, name, texture, count, quality, _, itemID = pcall(infoFn, i, questID)
		if okInfo then
			if type(name) == "table" then
				local info = name
				Attune_AddReward(list, seen, info.itemID or info.itemId, info.name or info.itemName, info.texture or info.icon, info.quantity or info.amount or info.numItems, info.quality, choice)
			else
				Attune_AddReward(list, seen, itemID, name, texture, count, quality, choice)
			end
		end
	end
end

local function Attune_StoredItem(itemID)
	local info = Attune_Data.rewardItems and itemID and Attune_Data.rewardItems[itemID]
	if type(info) ~= "table" then return end
	local name = info[1]
	if type(name) ~= "string" or name == "" then name = nil end
	local icon = info[2]
	if type(icon) == "string" and icon ~= "" then
		if not string.find(icon, "\\", 1, true) and not string.find(icon, "/", 1, true) then
			icon = "Interface\\Icons\\" .. icon
		end
	else
		icon = nil
	end
	local quality = tonumber(info[3])
	if quality and quality < 0 then quality = nil end
	return name, icon, quality
end

-- Full item link when the client has it. Otherwise the stored name, so the
-- tooltip does not sit on "Retrieving item information" for an item the
-- server never answers.
local function Attune_ShowItemTooltip(owner, itemID, request)
	if not owner or not itemID or not owner:IsShown() then return end
	if owner.IsMouseOver and not owner:IsMouseOver() then return end
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")

	local itemName, link, itemQuality = GetItemInfo(itemID)
	if link and pcall(GameTooltip.SetHyperlink, GameTooltip, link) then
		GameTooltip:Show()
		return
	end

	local storedName, _, storedQuality = Attune_StoredItem(itemID)
	local name = (type(itemName) == "string" and itemName ~= "") and itemName or storedName
	local quality = itemQuality or storedQuality
	if name then
		local r, g, b = 1, 1, 1
		local color = ITEM_QUALITY_COLORS and quality and ITEM_QUALITY_COLORS[quality]
		if color then r, g, b = color.r, color.g, color.b end
		GameTooltip:SetText(name, r, g, b)
		GameTooltip:Show()
	elseif GameTooltip.SetItemByID and pcall(GameTooltip.SetItemByID, GameTooltip, itemID) then
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end

	if request and not link and C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, itemID)
	end
end

local function Attune_RefreshRewardTooltip(rows)
	for _, row in ipairs(rows or {}) do
		if row:IsShown() and row.itemID and row.IsMouseOver and row:IsMouseOver() then
			Attune_ShowItemTooltip(row, row.itemID, false)
			return
		end
	end
end

local function Attune_AppendStoredRewards(questID, fixed, choices, seenFixed, seenChoice)
	local row = Attune_Data.questRewards and Attune_Data.questRewards[questID]
	if not row then return end
	for _, item in ipairs(row.fixed or {}) do
		local storedName, storedIcon, storedQuality = Attune_StoredItem(item[1])
		Attune_AddReward(fixed, seenFixed, item[1], storedName, storedIcon, item[2], storedQuality, false)
	end
	for _, item in ipairs(row.choice or {}) do
		local storedName, storedIcon, storedQuality = Attune_StoredItem(item[1])
		Attune_AddReward(choices, seenChoice, item[1], storedName, storedIcon, item[2], storedQuality, true)
	end
end

local function Attune_CollectQuestRewards(questIDs)
	local fixed, choices = {}, {}
	local seenFixed, seenChoice = {}, {}
	for _, questID in ipairs(questIDs or {}) do
		if C_QuestLog then
			Attune_ReadIndexedRewards(C_QuestLog.GetNumQuestRewards, C_QuestLog.GetQuestRewardInfo, questID, fixed, seenFixed, false)
			Attune_ReadIndexedRewards(C_QuestLog.GetNumQuestChoices or C_QuestLog.GetNumQuestLogChoices, C_QuestLog.GetQuestChoiceInfo or C_QuestLog.GetQuestLogChoiceInfo, questID, choices, seenChoice, true)
		end
		local useQuestLog = not (C_QuestLog and C_QuestLog.GetNumQuestRewards)
		if not useQuestLog and GetQuestLogIndexByID and GetQuestLogSelection then
			local index = GetQuestLogIndexByID(questID)
			useQuestLog = index and index > 0 and index == GetQuestLogSelection()
		end
		if useQuestLog then
			Attune_ReadIndexedRewards(GetNumQuestLogRewards, GetQuestLogRewardInfo, questID, fixed, seenFixed, false)
			Attune_ReadIndexedRewards(GetNumQuestLogChoices, GetQuestLogChoiceInfo, questID, choices, seenChoice, true)
		end
		-- Always merge static rows; seen* skips duplicates. Live Forever data often
		-- returns only choice rewards and omits fixed ones (e.g. Changing Tastes).
		Attune_AppendStoredRewards(questID, fixed, choices, seenFixed, seenChoice)
	end
	return fixed, choices
end

-- XP from the quest log only (no static table). Returns nil when unavailable.
local function Attune_QuestLogIndexForID(questID)
	if C_QuestLog and C_QuestLog.GetLogIndexForQuestID then
		return C_QuestLog.GetLogIndexForQuestID(questID)
	end
	if GetQuestLogIndexByID then
		return GetQuestLogIndexByID(questID)
	end
	return nil
end

local function Attune_IsQuestInLog(questID)
	if C_QuestLog and C_QuestLog.IsOnQuest then
		return C_QuestLog.IsOnQuest(questID)
	end
	local index = Attune_QuestLogIndexForID(questID)
	return index and index > 0
end

local function Attune_QuestLogRewardXPForID(questID)
	questID = tonumber(questID)
	if not questID or type(GetQuestLogRewardXP) ~= "function" then return nil end
	if not Attune_IsQuestInLog(questID) then return nil end

	local ok, xp = pcall(GetQuestLogRewardXP, questID)
	if ok and type(xp) == "number" and xp > 0 then return xp end

	local index = Attune_QuestLogIndexForID(questID)
	if not index or index <= 0 or not SelectQuestLogEntry then return nil end

	local prev = GetQuestLogSelection and GetQuestLogSelection()
	SelectQuestLogEntry(index)
	ok, xp = pcall(GetQuestLogRewardXP)
	if prev and prev > 0 and prev ~= index then
		SelectQuestLogEntry(prev)
	end
	if ok and type(xp) == "number" and xp > 0 then return xp end
	return nil
end

local function Attune_GetQuestLogRewardXP(questIDs)
	local total, found = 0, false
	for _, questID in ipairs(questIDs or {}) do
		local xp = Attune_QuestLogRewardXPForID(questID)
		if xp then
			total = total + xp
			found = true
		end
	end
	if found then return total end
	return nil
end

local function Attune_FormatXPAmount(xp)
	if BreakUpLargeNumbers then return BreakUpLargeNumbers(xp) end
	return tostring(xp)
end

local function Attune_CreateRewardRow(parent)
	local row = CreateFrame("Button", nil, parent)
	row:SetHeight(36)
	row.icon = row:CreateTexture(nil, "ARTWORK")
	row.icon:SetSize(32, 32)
	row.icon:SetPoint("LEFT", 2, 0)
	row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	row.count = row:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
	row.count:SetPoint("BOTTOMRIGHT", row.icon, "BOTTOMRIGHT", -1, 2)
	row.count:SetJustifyH("RIGHT")
	row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	row.name:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
	row.name:SetPoint("RIGHT", row, "RIGHT", -4, 0)
	row.name:SetJustifyH("LEFT")
	row.name:SetWordWrap(false)
	if row.name.SetMaxLines then row.name:SetMaxLines(1) end
	row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	row:SetScript("OnEnter", function(self)
		Attune_ShowItemTooltip(self, self.itemID, true)
	end)
	row:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	return row
end

local function Attune_HideRewardRows(frame)
	for _, row in ipairs(frame.rows) do
		row.itemID = nil
		row:Hide()
	end
	for _, header in ipairs(frame.headers) do header:Hide() end
end

local function Attune_RewardHeader(frame, index, text, y)
	local header = frame.headers[index]
	if not header then
		header = frame.content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		header:SetJustifyH("LEFT")
		frame.headers[index] = header
	end
	header:ClearAllPoints()
	header:SetPoint("TOPLEFT", 4, -y)
	header:SetPoint("RIGHT", frame.content, "RIGHT", -4, 0)
	header:SetText(text)
	header:Show()
end

local function Attune_PaintRewardItem(frame, entry, y)
	local index = frame.rowUsed + 1
	frame.rowUsed = index
	local row = frame.rows[index]
	if not row then
		row = Attune_CreateRewardRow(frame.content)
		frame.rows[index] = row
	end
	row:ClearAllPoints()
	row:SetPoint("TOPLEFT", 0, -y)
	row:SetPoint("RIGHT", frame.content, "RIGHT", 0, 0)

	row.itemID = entry.itemID
	local name = entry.name
	local quality = entry.quality
	local texture = entry.texture
	local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = GetItemInfo(entry.itemID)
	if (not itemName or itemName == "") and C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, entry.itemID)
	end
	if itemName and itemName ~= "" then
		name = itemName
		quality = itemQuality
		texture = itemTexture or texture
	end
	if not name or name == "" then name = "..." end

	row.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
	row.name:SetText(name)
	local color = ITEM_QUALITY_COLORS and quality and ITEM_QUALITY_COLORS[quality]
	if color then
		row.name:SetTextColor(color.r, color.g, color.b)
	else
		row.name:SetTextColor(1, 1, 1)
	end
	if entry.count and entry.count > 1 then
		row.count:SetText(entry.count)
		row.count:Show()
	else
		row.count:Hide()
	end
	row:Show()
end

local function Attune_FillQuestRewards(frame, final, resetScroll)
	if not frame or not frame:IsShown() then return end
	local width = frame.scroll:GetWidth()
	if not width or width < 40 then width = ATTUNE_REWARD_WIDTH - 52 end
	frame.content:SetWidth(width)

	local fixed, choices = Attune_CollectQuestRewards(frame.questIDs)
	Attune_HideRewardRows(frame)
	frame.rowUsed = 0

	if #fixed == 0 and #choices == 0 then
		frame.scroll:Hide()
		frame.empty:Show()
		frame.empty:SetText(final and AttuneLang["No item rewards"] or AttuneLang["Loading rewards"])
		frame.content:SetHeight(1)
		return
	end

	frame.empty:Hide()
	frame.scroll:Show()

	local y = 2
	local headerIndex = 0
	for _, entry in ipairs(fixed) do
		Attune_PaintRewardItem(frame, entry, y)
		y = y + 40
	end
	if #choices > 0 then
		if #fixed > 0 then y = y + 6 end
		headerIndex = headerIndex + 1
		Attune_RewardHeader(frame, headerIndex, AttuneLang["Choose one reward"], y)
		y = y + 18
		for _, entry in ipairs(choices) do
			Attune_PaintRewardItem(frame, entry, y)
			y = y + 40
		end
	end

	frame.content:SetHeight(math.max(y, 1))
	if resetScroll then frame.scroll:SetVerticalScroll(0) end
end

local function Attune_FitRewardFrame(side)
	local parent = side:GetParent()
	if not parent or not parent:IsShown() then return end
	local right = parent:GetRight()
	local screen = UIParent:GetWidth()
	if not right or not screen then return end
	local overflow = (right + side:GetWidth()) - screen
	if overflow > 4 then
		local left = parent:GetLeft() - overflow - 12
		local bottom = parent:GetBottom()
		if not left or not bottom then return end
		if left < 0 then left = 0 end
		parent:ClearAllPoints()
		parent:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
	end
end

local function Attune_EnsureRewardFrame()
	if attunelocal_rewardFrame then return attunelocal_rewardFrame end
	local parent = attunelocal_frame and attunelocal_frame.frame
	if not parent then return nil end

	local f = CreateFrame("Frame", "AttuneQuestRewardFrame", parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	f:SetWidth(ATTUNE_REWARD_WIDTH)
	f:SetPoint("TOPLEFT", parent, "TOPRIGHT", -6, 0)
	f:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", -6, 0)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 8, right = 8, top = 8, bottom = 8 },
	})
	f:SetBackdropColor(0, 0, 0, 1)
	f:EnableMouse(true)
	f:SetFrameStrata(parent:GetFrameStrata())
	f:SetFrameLevel((parent:GetFrameLevel() or 0) + 20)

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 4, 4)
	close:SetScript("OnClick", function() f:Hide() end)

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOPLEFT", 18, -16)
	title:SetPoint("RIGHT", close, "LEFT", -4, 0)
	title:SetHeight(36)
	title:SetJustifyH("LEFT")
	title:SetJustifyV("MIDDLE")
	title:SetWordWrap(true)
	f.title = title

	local urlBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	urlBtn:SetHeight(22)
	urlBtn:SetPoint("BOTTOMLEFT", 16, 16)
	urlBtn:SetPoint("BOTTOMRIGHT", -16, 16)
	urlBtn:SetText(AttuneLang["Show link"])
	urlBtn:SetScript("OnClick", function()
		if f.qstring then Attune_ShowWebsiteURL(f.qstring) end
	end)
	f.urlBtn = urlBtn

	local empty = f:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	empty:SetPoint("TOPLEFT", 20, -64)
	empty:SetPoint("RIGHT", f, "RIGHT", -20, 0)
	empty:SetJustifyH("CENTER")
	empty:SetWordWrap(true)
	f.empty = empty

	local scroll = CreateFrame("ScrollFrame", "AttuneQuestRewardScroll", f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 16, -56)
	scroll:SetPoint("BOTTOMRIGHT", -32, 46)
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local range = self:GetVerticalScrollRange() or 0
		if range <= 0 then return end
		local nextScroll = self:GetVerticalScroll() - (delta * 40)
		if nextScroll < 0 then nextScroll = 0 end
		if nextScroll > range then nextScroll = range end
		self:SetVerticalScroll(nextScroll)
	end)
	f.scroll = scroll

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(ATTUNE_REWARD_WIDTH - 52, 1)
	scroll:SetScrollChild(content)
	f.content = content
	f.rows = {}
	f.headers = {}
	f.questIDs = {}

	local listener = CreateFrame("Frame", nil, f)
	listener:SetScript("OnEvent", function(_, event, arg1)
		if not f:IsShown() then return end
		if event == "QUEST_DATA_LOAD_RESULT" then
			local wanted = false
			for _, qid in ipairs(f.questIDs) do
				if qid == arg1 then wanted = true break end
			end
			if not wanted then return end
		elseif event == "GET_ITEM_INFO_RECEIVED" then
			local wanted = false
			for _, row in ipairs(f.rows) do
				if row.itemID == arg1 then wanted = true break end
			end
			if not wanted then return end
		end
		Attune_FillQuestRewards(f, true)
		Attune_RefreshRewardTooltip(f.rows)
	end)
	f.listener = listener
	f:SetScript("OnShow", function(self)
		self.listener:RegisterEvent("QUEST_DATA_LOAD_RESULT")
		self.listener:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	end)
	f:SetScript("OnHide", function(self)
		self.listener:UnregisterEvent("QUEST_DATA_LOAD_RESULT")
		self.listener:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
		GameTooltip:Hide()
	end)

	parent:HookScript("OnHide", function()
		f:Hide()
	end)

	f.bronze = Attune_ApplyButtonChrome(f, function() f:Hide() end)
	if f.bronze and close then
		close:Hide()
	end

	f:Hide()
	attunelocal_rewardFrame = f
	return f
end

function Attune_ShowQuestRewards(step)
	if not step or not attunelocal_frame or not attunelocal_frame.frame then return end
	local f = Attune_EnsureRewardFrame()
	if not f then return end

	f.questIDs = Attune_RewardQuestIDs(step.ID_WOWHEAD)
	f.qstring = "quest=" .. step.ID_WOWHEAD
	f.token = (f.token or 0) + 1
	local title = AttuneLang["Q1_" .. step.ID_WOWHEAD]
	if not title or title == "" then title = AttuneLang["Quest rewards"] end
	if f.bronze then
		Attune_SetChromeTitle(f.bronze, title)
		f.title:Hide()
	else
		f.title:SetText(title)
		f.title:Show()
	end
	f.urlBtn:SetText(AttuneLang["Show link"])
	f:Show()
	Attune_FitRewardFrame(f)

	if C_QuestLog and C_QuestLog.RequestLoadQuestByID then
		for _, questID in ipairs(f.questIDs) do
			pcall(C_QuestLog.RequestLoadQuestByID, questID)
		end
	end

	Attune_FillQuestRewards(f, false, true)
	local token = f.token
	if C_Timer and C_Timer.After then
		C_Timer.After(0.4, function()
			if f:IsShown() and f.token == token then
				Attune_FillQuestRewards(f, true, false)
			end
		end)
	end
end

-------------------------------------------------------------------------

function Attune_ShowWebsiteURL(qstring)


--	if Dialog:ActiveDialog("AttuneWowheadUrlCopyDialog") then
--		Dialog:Dismiss("AttuneWowheadUrlCopyDialog")
--	end

	StaticPopupDialogs["ATTUNE_SHOW_URL"] = {
		text = AttuneLang["External link"],
		button1 = AttuneLang["Close"],
		OnShow = function (self, data)
			local editBox = self.EditBox or self.editBox
			editBox:SetText("".. Attune_DB.websiteUrl .. "/" .. qstring)
			editBox:HighlightText()
			editBox:SetScript("OnEscapePressed", function(self) StaticPopup_Hide ("ATTUNE_SHOW_URL") end)

		end,
		timeout = 0,
		hasEditBox = true,
		editBoxWidth = 350,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	StaticPopup_Show ("ATTUNE_SHOW_URL")

end

-------------------------------------------------------------------------

SlashCmdList["Attune"] = Attune_SlashCommandHandler
SLASH_Attune1 = "/attune"

-------------------------------------------------------------------------
-- Quest detail replaces the tree list: rewards on top, map square below
-------------------------------------------------------------------------

local attunelocal_questDetail

local function Attune_QuestDetailKey(step)
	return tostring(step.ID_ATTUNE) .. "-" .. tostring(step.ID) .. "-" .. tostring(step.ID_WOWHEAD)
end

local function Attune_DetailGiver(step)
	local questId = Attune_QuestIdFromStep(step)
	local loc = questId and Attune_Data.questGivers and Attune_Data.questGivers[questId]
	if not loc then return nil, nil, nil, nil end
	local uiMapID, x, y, name = loc[1], loc[2], loc[3], loc[4]
	if uiMapID and C_Map and C_Map.GetMapInfo and not C_Map.GetMapInfo(uiMapID) then
		return nil, nil, nil, name
	end
	return uiMapID, x, y, name
end

-- Shift-click shares this pin the same way the world map pin does: chat link plus clipboard.
local function Attune_ShareDetailPin(uiMapID, x, y)
	if not uiMapID or not x or not y or not (C_Map and C_Map.SetUserWaypoint and C_Map.GetUserWaypointHyperlink and UiMapPoint) then return end
	if C_Map.CanSetUserWaypointOnMap and not C_Map.CanSetUserWaypointOnMap(uiMapID) then return end

	local previous = C_Map.GetUserWaypoint and C_Map.GetUserWaypoint()
	local wasTracking = C_SuperTrack and C_SuperTrack.IsSuperTrackingUserWaypoint and C_SuperTrack.IsSuperTrackingUserWaypoint()

	C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(uiMapID, x / 100, y / 100))
	local link = C_Map.GetUserWaypointHyperlink()
	local waypoint = C_Map.GetUserWaypoint and C_Map.GetUserWaypoint()

	if link then
		if ChatFrameUtil and ChatFrameUtil.InsertLink then
			ChatFrameUtil.InsertLink(link)
		elseif ChatEdit_InsertLink then
			ChatEdit_InsertLink(link)
		end
	end

	if waypoint and waypoint.position and CopyToClipboard then
		local cmd = (SLASH_MAPPIN1 or "/pin") .. string.format(" %d %.1f %.1f", waypoint.uiMapID, waypoint.position.x * 100, waypoint.position.y * 100)
		CopyToClipboard(cmd)
	end

	if previous then
		C_Map.SetUserWaypoint(previous)
		if wasTracking and C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			C_SuperTrack.SetSuperTrackedUserWaypoint(true)
		end
	elseif C_Map.ClearUserWaypoint then
		C_Map.ClearUserWaypoint()
	end

	if PlaySound and SOUNDKIT and SOUNDKIT.UI_MAP_WAYPOINT_CHAT_SHARE then
		PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CHAT_SHARE)
	end
end

local function Attune_FillDetailMap(clip, uiMapID, x, y)
	clip.tiles = clip.tiles or {}
	for _, tex in ipairs(clip.tiles) do tex:Hide() end
	clip.pin:Hide()
	clip.pin.uiMapID, clip.pin.pinX, clip.pin.pinY = nil, nil, nil
	clip.empty:Hide()
	if not uiMapID or not x or not y or not C_Map or not C_Map.GetMapArtLayers or not C_Map.GetMapArtLayerTextures then
		clip.empty:Show()
		return
	end
	local layers = C_Map.GetMapArtLayers(uiMapID)
	if layers and layers.layerWidth then layers = { layers } end
	local layer = layers and layers[#layers]
	local textures = layer and C_Map.GetMapArtLayerTextures(uiMapID, #layers)
	if not layer or not textures or #textures == 0 or not layer.tileWidth or layer.tileWidth <= 0 then
		clip.empty:Show()
		return
	end
	local tileW, tileH = layer.tileWidth, layer.tileHeight
	local mapW, mapH = layer.layerWidth, layer.layerHeight
	local cols = math.ceil(mapW / tileW)
	local rows = math.ceil(mapH / tileH)
	local side = clip:GetWidth()
	if side < 8 then return end
	local view = math.min(mapW, mapH) * (0.35 / (clip.zoom or 1))
	if view < 1 then view = math.min(mapW, mapH) end
	local scale = side / view
	local gx = (x / 100) * mapW
	local gy = (y / 100) * mapH
	local left = gx - (view / 2)
	local top = gy - (view / 2)
	local n, i = 0, 0
	for row = 0, rows - 1 do
		for col = 0, cols - 1 do
			i = i + 1
			local file = textures[i]
			if file then
				n = n + 1
				local tex = clip.tiles[n]
				if not tex then
					tex = clip:CreateTexture(nil, "ARTWORK")
					clip.tiles[n] = tex
				end
				tex:SetTexture(file)
				local tw = math.min(tileW, mapW - col * tileW)
				local th = math.min(tileH, mapH - row * tileH)
				tex:SetSize(tw * scale, th * scale)
				tex:SetTexCoord(0, tw / tileW, 0, th / tileH)
				tex:ClearAllPoints()
				tex:SetPoint("TOPLEFT", clip, "TOPLEFT", (col * tileW - left) * scale, -((row * tileH - top) * scale))
				tex:Show()
			end
		end
	end
	for k = n + 1, #clip.tiles do clip.tiles[k]:Hide() end
	clip.pin.uiMapID, clip.pin.pinX, clip.pin.pinY = uiMapID, x, y
	clip.pin:Show()
	clip.pin:ClearAllPoints()
	clip.pin:SetPoint("CENTER", clip, "CENTER", 0, 0)
end

local function Attune_DetailRewardRow(parent)
	local row = CreateFrame("Button", nil, parent)
	row:SetHeight(36)
	row.icon = row:CreateTexture(nil, "ARTWORK")
	row.icon:SetSize(attunelocal_Icon_Size, attunelocal_Icon_Size)
	row.icon:SetPoint("LEFT", 2, 0)
	row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.name:SetPoint("BOTTOMLEFT", row.icon, "RIGHT", 6, 1)
	row.name:SetPoint("RIGHT", row, "RIGHT", -2, 0)
	row.name:SetJustifyH("LEFT")
	row.name:SetWordWrap(false)
	if row.name.SetMaxLines then row.name:SetMaxLines(1) end
	row.category = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	row.category:SetPoint("TOPLEFT", row.icon, "RIGHT", 6, -1)
	row.category:SetPoint("RIGHT", row, "RIGHT", -2, 0)
	row.category:SetJustifyH("LEFT")
	row.category:SetWordWrap(false)
	row.category:SetTextColor(0.55, 0.55, 0.55)
	if row.category.SetMaxLines then row.category:SetMaxLines(1) end
	row:SetScript("OnEnter", function(self)
		Attune_ShowItemTooltip(self, self.itemID, true)
	end)
	row:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return row
end

local function Attune_QuestRewardsKnown(panel)
	local ids = panel and panel.step and Attune_RewardQuestIDs(panel.step.ID_WOWHEAD) or {}
	for _, questID in ipairs(ids) do
		if panel.questLoaded and panel.questLoaded[questID] then return true end
		if Attune_Data.questRewards and Attune_Data.questRewards[questID] ~= nil then return true end
		if C_QuestLog and C_QuestLog.IsOnQuest and C_QuestLog.IsOnQuest(questID) then return true end
	end
	return false
end

local function Attune_LayoutQuestDetail(panel)
	if not panel or not panel:IsShown() or not panel.step then return end
	local width = panel:GetWidth()
	local height = panel:GetHeight()
	if width < 40 or height < 40 then return end

	local header = 50
	local sep = 10
	local margin = 10
	local useFullMap = Attune_DB and Attune_DB.useFullMap
	local mapSize, rewardsH
	if useFullMap then
		panel.map:Hide()
		panel.separator:Hide()
		rewardsH = height - header - margin
	else
		panel.map:Show()
		panel.separator:Show()
		mapSize = width - (margin * 2)
		rewardsH = height - header - sep - mapSize - margin
		if rewardsH < 28 then
			mapSize = math.max(64, height - header - sep - margin - 28)
			rewardsH = height - header - sep - mapSize - margin
		end
	end

	panel.rewardScroll:ClearAllPoints()
	panel.rewardScroll:SetPoint("TOPLEFT", 10, -(header + 6))
	panel.rewardScroll:SetPoint("TOPRIGHT", -12, -(header + 6))
	panel.rewardScroll:SetHeight(math.max(rewardsH - 8, 1))

	if not useFullMap then
		panel.separator:ClearAllPoints()
		panel.separator:SetPoint("TOPLEFT", 8, -(header + rewardsH))
		panel.separator:SetPoint("TOPRIGHT", -8, -(header + rewardsH))

		panel.map:ClearAllPoints()
		panel.map:SetSize(mapSize, mapSize)
		panel.map:SetPoint("BOTTOM", panel, "BOTTOM", 0, margin)
	end

	local questName = AttuneLang["Q1_" .. panel.step.ID_WOWHEAD]
	if not questName or questName == "" then questName = AttuneLang["Quest rewards"] end
	panel.title:SetText(questName)

	local questIDs = Attune_RewardQuestIDs(panel.step.ID_WOWHEAD)
	local fixed, choices = Attune_CollectQuestRewards(questIDs)
	local items = {}
	for _, entry in ipairs(fixed) do items[#items + 1] = entry end
	for _, entry in ipairs(choices) do items[#items + 1] = entry end

	local y = 6
	local xp = Attune_GetQuestLogRewardXP(questIDs)
	if panel.xpText then
		if xp then
			local fmt = AttuneLang["Experience reward"]
			if type(fmt) ~= "string" or fmt == "" or not string.find(fmt, "%%s", 1, true) then
				fmt = "+%s XP"
			end
			panel.xpText:SetText(fmt:format(Attune_FormatXPAmount(xp)))
			panel.xpText:ClearAllPoints()
			panel.xpText:SetPoint("TOPLEFT", 6, -y)
			panel.xpText:SetPoint("RIGHT", panel.rewardChild, "RIGHT", -6, 0)
			panel.xpText:Show()
			y = y + 20
		else
			panel.xpText:Hide()
		end
	end

	for _, row in ipairs(panel.rows) do row:Hide() end
	if #items == 0 then
		panel.empty:Show()
		local known = Attune_QuestRewardsKnown(panel)
		local msg
		if not panel.rewardsFinal and not known then
			msg = AttuneLang["Loading rewards"]
		elseif known then
			msg = AttuneLang["No item rewards"]
		else
			msg = AttuneLang["Rewards only if available"]
		end
		panel.empty:ClearAllPoints()
		panel.empty:SetPoint("TOPLEFT", 6, -y)
		panel.empty:SetPoint("RIGHT", panel.rewardChild, "RIGHT", -8, 0)
		panel.empty:SetText(msg)
		panel.rewardChild:SetHeight(math.max(y + (known and 28 or 48), 28))
	else
		panel.empty:Hide()
		local shown = 0
		for _, entry in ipairs(items) do
			local name, quality, texture = entry.name, entry.quality, entry.texture
			local itemName, _, itemQuality, _, _, itemType, itemSubType, _, itemEquipSlot, itemTexture, _, classID, subClassID = GetItemInfo(entry.itemID)
			if itemName and itemName ~= "" then
				name, quality, texture = itemName, itemQuality, itemTexture or texture
			else
				local storedName, storedIcon, storedQuality = Attune_StoredItem(entry.itemID)
				if storedName then name = storedName end
				if storedIcon and not texture then texture = storedIcon end
				if storedQuality and not quality then quality = storedQuality end
			end
			if GetItemInfoInstant and ((not itemType or itemType == "") or not itemEquipSlot or itemEquipSlot == "") then
				local _, instantType, instantSubType, instantEquip, _, instantClass, instantSubClass = GetItemInfoInstant(entry.itemID)
				if not itemType or itemType == "" then itemType, itemSubType = instantType, instantSubType end
				if (not itemEquipSlot or itemEquipSlot == "") and instantEquip and instantEquip ~= "" then itemEquipSlot = instantEquip end
				if not classID then classID = instantClass end
				if not subClassID then subClassID = instantSubClass end
			end
			if not name or name == "" then
				if C_Item and C_Item.RequestLoadItemDataByID then
					pcall(C_Item.RequestLoadItemDataByID, entry.itemID)
				end
			end
			if not name or name == "" then
				-- Wowhead has no name for this reward slot, and the client has not cached it.
			else
			shown = shown + 1
			local row = panel.rows[shown]
			if not row then
				row = Attune_DetailRewardRow(panel.rewardChild)
				panel.rows[shown] = row
			end
			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", 4, -y)
			row:SetPoint("RIGHT", panel.rewardChild, "RIGHT", -6, 0)
			row.itemID = entry.itemID
			row.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
			local text = name
			if entry.count and entry.count > 1 then text = text .. " x" .. entry.count end
			-- if entry.choice then text = text .. " (" .. AttuneLang["Choose one reward"] .. ")" end
			row.name:SetText(text)
			local slotLabel = nil
			if type(itemEquipSlot) == "string" and itemEquipSlot ~= "" and itemEquipSlot ~= "INVTYPE_NON_EQUIP_IGNORE" then
				local label = _G[itemEquipSlot]
				if type(label) == "string" and label ~= "" then slotLabel = label end
			end
			local isWeapon = classID == 2 or itemType == "Weapon"
			local isArmor = classID == 4 or itemType == "Armor"
			local isMisc = itemSubType == "Misc" or itemSubType == "Miscellaneous" or (isArmor and subClassID == 0)
			local category = ""
			if isWeapon then
				category = itemSubType or ""
			elseif isMisc then
				category = slotLabel or ""
			elseif isArmor then
				if itemSubType and itemSubType ~= "" and slotLabel then
					category = itemSubType .. " - " .. slotLabel
				elseif slotLabel then
					category = slotLabel
				else
					category = itemSubType or ""
				end
			elseif itemType and itemType ~= "" and itemSubType and itemSubType ~= "" and itemSubType ~= itemType then
				category = itemType .. " - " .. itemSubType
			elseif itemType and itemType ~= "" then
				category = itemType
			elseif itemSubType and itemSubType ~= "" then
				category = itemSubType
			end
			row.category:SetText(category)
			if category == "" then row.category:Hide() else row.category:Show() end
			row.name:ClearAllPoints()
			row.name:SetPoint("RIGHT", row, "RIGHT", -2, 0)
			if category == "" then
				row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
			else
				row.name:SetPoint("BOTTOMLEFT", row.icon, "RIGHT", 6, 1)
			end
			local color = ITEM_QUALITY_COLORS and quality and ITEM_QUALITY_COLORS[quality]
			if color then
				row.name:SetTextColor(color.r, color.g, color.b)
			else
				row.name:SetTextColor(1, 1, 1)
			end
			row:Show()
			y = y + 42
			end
		end
		if shown == 0 then
			panel.empty:Show()
			panel.empty:SetText(AttuneLang["No item rewards"])
			panel.rewardChild:SetHeight(28)
		else
			panel.rewardChild:SetWidth(math.max(width - 24, 20))
			panel.rewardChild:SetHeight(math.max(y, 1))
		end
	end

	if not (Attune_DB and Attune_DB.useFullMap) then
		local uiMapID, x, y, giver = Attune_DetailGiver(panel.step)
		if giver and giver ~= "" then
			panel.giver:SetText(AttuneLang["Starts at"] .. " " .. giver)
			panel.giver:Show()
		else
			panel.giver:Hide()
		end
		panel.map.art.zoom = panel.map.zoom or 1
		Attune_FillDetailMap(panel.map.art, uiMapID, x, y)
	end
end

local function Attune_EnsureQuestDetail()
	if attunelocal_questDetail then return attunelocal_questDetail end
	local panel = CreateFrame("Frame", "AttuneQuestDetail", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	panel:EnableMouse(true)
	panel:SetFrameStrata("HIGH")
	panel:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	panel:SetBackdropColor(0.07, 0.07, 0.07, 1)
	panel:SetBackdropBorderColor(0.45, 0.38, 0.2, 1)
	panel.rows = {}

	panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	panel.title:SetPoint("TOPLEFT", 14, -14)
	panel.title:SetPoint("RIGHT", panel, "RIGHT", -36, 0)
	panel.title:SetJustifyH("LEFT")
    panel.title:SetFont(GameFontNormal:GetFont(), 16, "")
	panel.title:SetWordWrap(false)

	panel.subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	panel.subtitle:SetPoint("TOPLEFT", 14, -36)
	panel.subtitle:SetPoint("RIGHT", panel, "RIGHT", -36, 0)
	panel.subtitle:SetJustifyH("LEFT")
    panel.subtitle:SetFont(GameFontNormal:GetFont(), 12, "")
	panel.subtitle:SetWordWrap(false)
    panel.subtitle:SetText("Quest rewards")
    panel.subtitle:SetTextColor(0.55, 0.55, 0.55)


	local close = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 4, 4)
	close:SetScript("OnClick", function() Attune_HideQuestDetail() end)

	local scroll = CreateFrame("ScrollFrame", nil, panel)
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local range = self:GetVerticalScrollRange() or 0
		if range <= 0 then return end
		local nextScroll = self:GetVerticalScroll() - (delta * 24)
		if nextScroll < 0 then nextScroll = 0 end
		if nextScroll > range then nextScroll = range end
		self:SetVerticalScroll(nextScroll)
	end)
	panel.rewardScroll = scroll
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(100, 20)
	scroll:SetScrollChild(child)
	panel.rewardChild = child
	panel.xpText = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	panel.xpText:SetJustifyH("LEFT")
	panel.xpText:SetTextColor(0.15, 0.85, 1)
	panel.xpText:Hide()
	panel.empty = child:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	panel.empty:SetPoint("TOPLEFT", 6, -20)
	panel.empty:SetPoint("RIGHT", child, "RIGHT", -8, 0)
	panel.empty:SetJustifyH("LEFT")
	panel.empty:SetWordWrap(true)

	panel.separator = panel:CreateTexture(nil, "ARTWORK")
	panel.separator:SetHeight(2)
	panel.separator:SetColorTexture(0.72, 0.58, 0.28, 0.9)

	local map = CreateFrame("Frame", nil, panel, BackdropTemplateMixin and "BackdropTemplate" or nil)
	map:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	map:SetBackdropColor(0, 0, 0, 1)
	map:SetBackdropBorderColor(0.75, 0.6, 0.28, 1)
	panel.map = map
	local art = CreateFrame("Frame", nil, map)
	art:SetPoint("TOPLEFT", 5, -5)
	art:SetPoint("BOTTOMRIGHT", -5, 5)
	if art.SetClipsChildren then art:SetClipsChildren(true) end
	map.art = art
	map.empty = art:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	map.empty:SetPoint("CENTER")
	map.empty:SetText(AttuneLang["Quest information not found"])
	map.empty:Hide()
	map.pin = CreateFrame("Button", nil, art)
	map.pin:SetSize(22, 22)
	map.pin:SetFrameLevel((art:GetFrameLevel() or 0) + 6)
	map.pin:EnableMouse(true)
	map.pin:RegisterForClicks("LeftButtonUp")
	map.pin:SetHitRectInsets(-8, -8, -8, -8)
	map.pin.icon = map.pin:CreateTexture(nil, "OVERLAY")
	map.pin.icon:SetAllPoints()
	local pinned = false
	if map.pin.icon.SetAtlas then
		pcall(map.pin.icon.SetAtlas, map.pin.icon, "Waypoint-MapPin-Tracked")
		pinned = map.pin.icon.GetAtlas and map.pin.icon:GetAtlas() == "Waypoint-MapPin-Tracked"
	end
	if not pinned then
		map.pin.icon:SetTexture("Interface\\Minimap\\Tracking\\QuestBlob")
	end
	map.pin:SetScript("OnClick", function(self)
		if IsModifiedClick("CHATLINK") then
			Attune_ShareDetailPin(self.uiMapID, self.pinX, self.pinY)
		end
	end)
	map.pin:SetScript("OnEnter", function(self)
		if not self.uiMapID then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -16, -4)
		local title = MAP_PIN_SHARING or "Map Pin"
		if GameTooltip_SetTitle then
			GameTooltip_SetTitle(GameTooltip, title)
			if MAP_PIN_SHARING_TOOLTIP and GameTooltip_AddNormalLine then
				GameTooltip_AddNormalLine(GameTooltip, MAP_PIN_SHARING_TOOLTIP)
			end
		else
			GameTooltip:SetText(title)
			if MAP_PIN_SHARING_TOOLTIP then
				GameTooltip:AddLine(MAP_PIN_SHARING_TOOLTIP, 1, 1, 1, true)
			end
		end
		GameTooltip:Show()
	end)
	map.pin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- FillDetailMap parents tiles and the pin to the clipped art frame.
	art.pin = map.pin
	art.empty = map.empty
	panel.giver = map:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	panel.giver:SetPoint("BOTTOMLEFT", 8, 8)
	panel.giver:SetPoint("BOTTOMRIGHT", -58, 8)
	panel.giver:SetJustifyH("CENTER")
	panel.giver:SetWordWrap(false)

	local function Attune_NudgeMapZoom(delta)
		local zoom = map.zoom or 1
		if delta > 0 then zoom = zoom * 1.35 else zoom = zoom / 1.35 end
		if zoom < 0.35 then zoom = 0.35 end
		if zoom > 8 then zoom = 8 end
		map.zoom = zoom
		if map.art then map.art.zoom = zoom end
		if panel:IsShown() then Attune_LayoutQuestDetail(panel) end
	end
	local zoomOut = CreateFrame("Button", nil, map, "UIPanelButtonTemplate")
	zoomOut:SetSize(22, 20)
	zoomOut:SetPoint("BOTTOMRIGHT", -6, 6)
	zoomOut:SetText("-")
	zoomOut:SetScript("OnClick", function() Attune_NudgeMapZoom(-1) end)
	local zoomIn = CreateFrame("Button", nil, map, "UIPanelButtonTemplate")
	zoomIn:SetSize(22, 20)
	zoomIn:SetPoint("RIGHT", zoomOut, "LEFT", -2, 0)
	zoomIn:SetText("+")
	zoomIn:SetScript("OnClick", function() Attune_NudgeMapZoom(1) end)
	zoomIn:SetFrameLevel(art:GetFrameLevel() + 5)
	zoomOut:SetFrameLevel(art:GetFrameLevel() + 5)
	art:EnableMouseWheel(true)
	art:SetScript("OnMouseWheel", function(_, delta) Attune_NudgeMapZoom(delta) end)
	map.pin:EnableMouseWheel(true)
	map.pin:SetScript("OnMouseWheel", function(_, delta) Attune_NudgeMapZoom(delta) end)

	local listener = CreateFrame("Frame", nil, panel)
	listener:SetScript("OnEvent", function(_, event, arg1, arg2)
		if event == "GET_ITEM_INFO_RECEIVED" then
			if not panel:IsShown() then return end
			local wanted = false
			for _, row in ipairs(panel.rows) do
				if row.itemID == arg1 then wanted = true break end
			end
			if not wanted then return end
			Attune_LayoutQuestDetail(panel)
			Attune_RefreshRewardTooltip(panel.rows)
			return
		end
		if event == "UNIT_QUEST_LOG_CHANGED" and arg1 ~= "player" then
			return
		end
		if event == "QUEST_DATA_LOAD_RESULT" and arg1 and arg2 then
			panel.questLoaded = panel.questLoaded or {}
			panel.questLoaded[arg1] = true
		end
		if panel:IsShown() then Attune_LayoutQuestDetail(panel) end
	end)
	panel:SetScript("OnShow", function(self)
		listener:RegisterEvent("QUEST_DATA_LOAD_RESULT")
		listener:RegisterEvent("GET_ITEM_INFO_RECEIVED")
		listener:RegisterEvent("QUEST_LOG_UPDATE")
		listener:RegisterEvent("QUEST_ACCEPTED")
		listener:RegisterEvent("QUEST_REMOVED")
		listener:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
	end)
	panel:SetScript("OnHide", function()
		listener:UnregisterEvent("QUEST_DATA_LOAD_RESULT")
		listener:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
		listener:UnregisterEvent("QUEST_LOG_UPDATE")
		listener:UnregisterEvent("QUEST_ACCEPTED")
		listener:UnregisterEvent("QUEST_REMOVED")
		listener:UnregisterEvent("UNIT_QUEST_LOG_CHANGED")
	end)
	panel:SetScript("OnSizeChanged", function(self)
		if self:IsShown() and not self.layingOut then
			self.layingOut = true
			Attune_LayoutQuestDetail(self)
			self.layingOut = false
		end
	end)

	panel:Hide()
	attunelocal_questDetail = panel
	return panel
end

function Attune_HideQuestDetail()
	local widget = attunelocal_treeframe
	if widget and widget.treeframe then
		widget.treeframe.attuneDetailOpen = nil
	end
	if attunelocal_questDetail then
		attunelocal_questDetail:Hide()
		attunelocal_questDetail.key = nil
		attunelocal_questDetail.step = nil
	end
	Attune_CloseQuestGiverMap()
	if widget and widget.RefreshTree and widget.treeframe and widget.treeframe:IsShown() then
		widget:RefreshTree()
	end
end

function Attune_ShowQuestDetail(step)
	if not step or not attunelocal_treeframe or not attunelocal_treeframe.treeframe then return end
	local tree = attunelocal_treeframe.treeframe
	local panel = Attune_EnsureQuestDetail()
	local key = Attune_QuestDetailKey(step)
	if panel:IsShown() and panel.key == key then
		Attune_HideQuestDetail()
		return
	end
	if attunelocal_rewardFrame then attunelocal_rewardFrame:Hide() end
	panel.key = key
	panel.step = step
	panel.rewardsFinal = false
	panel.questLoaded = {}
	if panel.map then panel.map.zoom = 1 end
	panel:SetParent(tree)
	panel:ClearAllPoints()
	panel:SetAllPoints(tree)
	panel:SetFrameStrata(tree:GetFrameStrata() or "HIGH")
	panel:SetFrameLevel((tree:GetFrameLevel() or 1) + 50)
	tree.attuneDetailOpen = true
	for _, button in ipairs(attunelocal_treeframe.buttons or {}) do
		button:Hide()
	end
	if attunelocal_treeframe.scrollbar then attunelocal_treeframe.scrollbar:Hide() end
	panel:Show()
	Attune_LayoutQuestDetail(panel)
	if Attune_DB and Attune_DB.useFullMap then
		Attune_ShowQuestGiverMap(step)
	end

	if C_QuestLog and C_QuestLog.RequestLoadQuestByID then
		for _, questID in ipairs(Attune_RewardQuestIDs(step.ID_WOWHEAD)) do
			pcall(C_QuestLog.RequestLoadQuestByID, questID)
		end
	end
	local token = key
	if C_Timer and C_Timer.After then
		C_Timer.After(0.4, function()
			if panel:IsShown() and panel.key == token then
				panel.rewardsFinal = true
				Attune_LayoutQuestDetail(panel)
			end
		end)
	end
end

function Attune_RefreshQuestMapMode()
	local panel = attunelocal_questDetail
	if not panel or not panel:IsShown() or not panel.step then return end
	Attune_LayoutQuestDetail(panel)
	if Attune_DB and Attune_DB.useFullMap then
		Attune_ShowQuestGiverMap(panel.step)
	else
		Attune_CloseQuestGiverMap()
	end
end

