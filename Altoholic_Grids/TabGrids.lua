local addonTabName = ...
local addonName = "Altoholic"
local addon = _G[addonName]
local colors = AddonFactory.Colors
local icons = AddonFactory.Icons

local L = AddonFactory:GetLocale(addonName)

local MVC = LibStub("LibMVC-1.0")
local Formatter = MVC:GetService("AltoholicUI.Formatter")

local tab		-- small shortcut to easily address the frame (set in OnBind)
local options

local currentPanelKey = "Grids"
local currentPage
local MAX_PAGES = 12	-- good for 144 alts, should be enough, 1 page per class is even possible

local gridCallbacks = {}

addon:Controller("AltoholicUI.TabGrids", {
	OnBind = function(frame)
		tab = frame
		
		currentPage = 1
		frame.PageNumber:SetText(format(MERCHANT_PAGE_NUMBER, currentPage, MAX_PAGES))
		
		frame.SelectRealm:RegisterClassEvent("RealmChanged", function(self, account, realm) 
				frame.ClassIcons:Update(account, realm, 1)	-- page 1 when changing realm
				frame.Status:SetText("")
				frame:Update()
			end)
		
		frame.ClassIcons.OnCharacterChanged = function(self)
				local account, realm = frame.SelectRealm:GetCurrentRealm()
				self:Update(account, realm, currentPage)
				frame:Update()
			end

		frame.currentGridID = 1
	end,
	
	RegisterPanel = function(frame, key, panel)
		-- a simple list of all the child frames
		frame.Panels = frame.Panels or {}
		frame.Panels[key] = panel
	end,
	HideAllPanels = function(frame)
		for _, panel in pairs(frame.Panels) do
			panel:Hide()
		end
	end,
	ShowPanel = function(frame, panelKey)
		if not panelKey then return end
		
		currentPanelKey = panelKey
		
		frame:HideAllPanels()
		
		local panel = frame.Panels[currentPanelKey]
		
		panel:Show()
		if panel.PreUpdate then
			panel:PreUpdate()
		end
		panel:Update()
	end,
	SetStatus = function(frame, text)
		frame.Status:SetText(text)
	end,
	
	-- ** Grid **
	RegisterGrid = function(frame, gridID, callbacks)
		gridCallbacks[gridID] = callbacks
	end,
	InitializeGrid = function(frame, gridID)
		if gridCallbacks[gridID] and gridCallbacks[gridID].InitViewDDM then
			gridCallbacks[gridID].InitViewDDM(frame.SelectView, frame.TextView)
		end
		frame.currentGridID = gridID
	end,
	GetCurrentGridObject = function(frame)
		return gridCallbacks[frame.currentGridID]
	end,
	Update = function(frame)
		frame:ShowPanel(currentPanelKey)
	end,
	
	-- ** Pagination **
	GoToPreviousPage = function(frame)
		frame:SetPage(currentPage - 1)
	end,
	GoToNextPage = function(frame)
		frame:SetPage(currentPage + 1)
	end,
	GetPage = function(frame)
		return currentPage
	end,
	SetPage = function(frame, pageNum)
		currentPage = pageNum

		-- fix minimum page number
		currentPage = (currentPage < 1) and 1 or currentPage
		
		if currentPage == 1 then
			frame.PrevPage:Disable()
		else
			frame.PrevPage:Enable()
		end
		
		-- fix maximum page number
		currentPage = (currentPage > MAX_PAGES) and MAX_PAGES or currentPage
		
		if currentPage == MAX_PAGES then
			frame.NextPage:Disable()
		else
			frame.NextPage:Enable()
		end
		
		local account, realm = frame.SelectRealm:GetCurrentRealm()
		frame.ClassIcons:Update(account, realm, currentPage)
		frame.PageNumber:SetText(format(MERCHANT_PAGE_NUMBER, currentPage, MAX_PAGES))	
		frame:Update()
	end,
	GetRealm = function(frame)
		local account, realm = frame.SelectRealm:GetCurrentRealm()
		return realm, account
	end,
})

local function categoriesList_OnClick(categoryData)
	tab:InitializeGrid(categoryData.gridID)
	tab:Update()
end

local function faction_OnClick(categoryData)
	options["Reputations.CurrentXPack"] = categoryData.xPackID
	options["Reputations.CurrentFactionGroup"] = categoryData.factionID
	
	tab:InitializeGrid(2)
	tab:Update()
end

local function currency_OnClick(categoryData)
	-- get the header if any (for all-in-one), or the text (necessary to avoid comparing with the colored text)
	local value = categoryData.header or categoryData.text
	
	if value == L["All-in-one"] then
		value = nil		-- pass nil if All in one is selected
	end

	options["Currencies.CurrentTokenType"] = value
	
	tab:SetStatus(format("%s%s|r / %s%s", 
		colors.white, L["Currencies"], 
		colors.green, categoryData.text))
	tab:InitializeGrid(3)
	tab:Update()
end

local function emissary_OnClick(categoryData)
	options["Emissaries.CurrentXPack"] = categoryData.xPackID
	
	tab:SetStatus(format("%s%s|r / %s%s|r / %s%s", 
		colors.white, QUESTS_LABEL, 
		colors.white, BOUNTY_BOARD_LOCKED_TITLE, 
		colors.green, categoryData.text))
	tab:InitializeGrid(12)
	tab:Update()
end

local function companion_OnClick(categoryData)
	options["Companions.CurrentXPack"] = categoryData.xPackID
	
	tab:SetStatus(format("%s%s|r / %s%s", 
		colors.white, COMPANIONS, 
		colors.green, categoryData.text))
	tab:InitializeGrid(5)
	tab:Update()
end

local function dungeon_OnClick(categoryData)
	options["Dungeons.CurrentXPack"] = categoryData.xPackID
	options["Dungeons.CurrentRaids"] = categoryData.difficultyIndex
	
	tab:InitializeGrid(6)
	tab:Update()
end

local function tradeskill_OnClick(categoryData)
	options["Tradeskills.CurrentXPack"] = categoryData.xPackID
	options["Tradeskills.CurrentTradeSkill"] = categoryData.tradeskillIndex
	
	tab:InitializeGrid(7)
	tab:Update()
end

local function archaeology_OnClick(categoryData)
	options["Archaeology.CurrentRace"] = categoryData.raceID
	
	tab:SetStatus(format("%s%s|r / %s%s", 
		colors.white, C_Spell.GetSpellName(78670), 
		colors.green, categoryData.text))
	tab:InitializeGrid(8)
	tab:Update()
end

local function garrisonBuilding_OnClick(categoryData)
	options["Garrisons.CurrentBuildings"] = categoryData.buildingID

	tab:SetStatus(format("%s%s|r / %s%s|r / %s%s", 
		colors.white, SPLASH_NEW_FEATURE1_TITLE, 
		colors.white, GARRISON_ARCHITECT, 
		colors.green, categoryData.text))
	tab:InitializeGrid(9)
	tab:Update()
end

local function garrisonFollower_OnClick(categoryData)
	options["Garrisons.CurrentFollowers"] = categoryData.followerID

	tab:SetStatus(format("%s%s|r / %s%s|r / %s%s", 
		colors.white, SPLASH_NEW_FEATURE1_TITLE, 
		colors.white, GARRISON_FOLLOWERS_TITLE, 
		colors.green, categoryData.text))
	tab:InitializeGrid(10)
	tab:Update()
end

local function followerAbilities_OnClick(categoryData)
	options["Garrisons.CurrentStats"] = categoryData.abilities
	
	tab:SetStatus(format("%s%s|r / %s%s|r / %s%s", 
		colors.white, SPLASH_NEW_FEATURE1_TITLE, 
		colors.white, format("%s & %s", GARRISON_RECRUIT_ABILITIES, GARRISON_RECRUIT_TRAITS), 
		colors.green, categoryData.text))
	tab:InitializeGrid(11)
	tab:Update()
end

local function GetOptionText(option, text)
	local value = options[option]
	
	return (value == true) 
		and format("%s %s", icons.ready, text) 
		or format("%s %s", icons.notReady, text)
end

local function setsOptions_OnClick(categoryData, button)
	-- Toggle the option
	options[categoryData.option] = not options[categoryData.option]
		
	categoryData.text = GetOptionText(categoryData.option, categoryData.label)
	button:GetParent():UpdateCategories()
	
	tab:InitializeGrid(13)
	tab:Update()
end

local function sets_OnClick(categoryData)
	options["Sets.CurrentXPack"] = categoryData.xPackID
	
	tab:SetStatus(format("%s%s|r / %s%s", colors.white, WARDROBE_SETS, colors.green, categoryData.text))
	tab:InitializeGrid(13)
	tab:Update()
end


addon:Controller("AltoholicUI.TabGridsCategoriesList", {
	-- 2024/01/01 : changed OnBind to Initialized so that it can be called a bit later, when the SV values are available
	-- OnBind = function(frame)
	Initialize = function(frame)

		-- local OPTION_PVE = "Sets.IncludePVE"
		-- local OPTION_PVPDESC_PREFIX = "Sets.PVP."
	
		local categories = {
			{ text = L["Equipment"], callback = categoriesList_OnClick, gridID = 1 },
			{ text = L["Reputations"], gridID = 2, subMenu = {
				{ text = EXPANSION_NAME0, subMenu = {
					{ text = FACTION_ALLIANCE, callback = faction_OnClick, xPackID = 1, factionID = 1 },
					{ text = FACTION_HORDE, callback = faction_OnClick, xPackID = 1, factionID = 2 },
					{ text = L["Alliance Forces"], callback = faction_OnClick, xPackID = 1, factionID = 3 },
					{ text = L["Horde Forces"], callback = faction_OnClick, xPackID = 1, factionID = 4 },
					{ text = L["Steamwheedle Cartel"], callback = faction_OnClick, xPackID = 1, factionID = 5 },
					{ text = OTHER, callback = faction_OnClick, xPackID = 1, factionID = 6 },
				}},
				-- { text = format("%s%s", colors.green, GUILD), callback = faction_OnClick, xPackID = 12, factionID = 1 },
				{ text = format("%s%s", colors.cyan, L["All-in-one"]), callback = faction_OnClick, xPackID = 2, factionID = 1 },
			}},
		}

		-- Add currencies
		-- local currenciesMenu = categories[3].subMenu
		
		-- for _, header in ipairs(DataStore:GetCurrencyHeaders()) do
			-- table.insert(currenciesMenu, { text = header, callback = currency_OnClick })
		-- end
		
		-- table.insert(currenciesMenu, { text = format("%s%s", colors.cyan, L["All-in-one"]), header = L["All-in-one"], callback = currency_OnClick })
		
		-- Add tradeskills
		-- local tradeskillsMenu = categories[7].subMenu
		-- local tradeskills = addon.TradeSkills.spellIDs
		
		-- for xpackIndex = 0, 8 do
			-- table.insert(tradeskillsMenu, { text = _G[format("EXPANSION_NAME%d", xpackIndex)], subMenu = {} })
			
			-- local tradeskillsSubMenu = tradeskillsMenu[#tradeskillsMenu].subMenu
			
			-- for tradeskillIndex = 1, #tradeskills do
				-- local spellID = tradeskills[tradeskillIndex]
				
				-- table.insert(tradeskillsSubMenu, { 
					-- text = format("%s %s", Formatter.Texture18(C_Spell.GetSpellTexture(spellID)), C_Spell.GetSpellName(spellID)),
					-- callback = tradeskill_OnClick,
					-- xPackID = xpackIndex + 1,
					-- tradeskillIndex = tradeskillIndex
				-- })
			-- end
		-- end
	
		frame:SetCategories(categories)
		
		-- Show the equipment pane by default
		categoriesList_OnClick(categories[1])
	end,
})

AddonFactory:OnAddonLoaded(addonTabName, function() 
	AddonFactory:SetOptionsTable("Altoholic_GridsTab_Columns")
	AddonFactory:SetOptionsTable("Altoholic_GridsTab_Options", {
		["Reputations.CurrentXPack"] = 1,				-- Current expansion pack 
		["Reputations.CurrentFactionGroup"] = 1,		-- Current faction group in that xpack
		["Currencies.CurrentTokenType"] = nil,			-- Current token type (default to nil = all-in-one)
		["Companions.CurrentXPack"] = 1,					-- Current expansion pack 
		["Mounts.CurrentFaction"] = 1,					-- Current faction 
		["Tradeskills.CurrentXPack"] = 1,				-- Current expansion pack 
		["Tradeskills.CurrentTradeSkill"] = 1,			-- Current tradeskill index
		["Archaeology.CurrentRace"] = 1,					-- Current race index
		["Dungeons.CurrentXPack"] = 1,					-- Current expansion pack 
		["Dungeons.CurrentRaids"] = 1,					-- Current raid index
		["Garrisons.CurrentBuildings"] = 1,				-- Current building type
		["Garrisons.CurrentFollowers"] = 1,				-- Current follower type
		["Garrisons.CurrentStats"] = 1,					-- Current stats (abilities = 1, traits = 2, counters = 3)
		["Sets.IncludePVE"] = true,						-- Include PVE Sets
		["Sets.IncludePVP"] = true,						-- Include PVP Sets
		["Sets.CurrentXPack"] = 1,							-- Current expansion pack 
		["Emissaries.ShowXPack6"] = true,				-- Show Legion Emissaries
		["Emissaries.ShowXPack7"] = true,				-- Show BfA Emissaries
		["Emissaries.ShowXPack8"] = true,				-- Show Shadowlands Emissaries
	})
	options = Altoholic_GridsTab_Options

	-- Update only when options are ready
	local account, realm = tab.SelectRealm:GetCurrentRealm()
	tab.ClassIcons:Update(account, realm, currentPage)	
	
	tab.CategoriesList:Initialize()

end)
