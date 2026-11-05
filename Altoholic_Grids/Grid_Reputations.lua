local addonName = "Altoholic"
local addon = _G[addonName]
local colors = AddonFactory.Colors
local icons = AddonFactory.Icons

local MVC = LibStub("LibMVC-1.0")
local L = AddonFactory:GetLocale(addonName)
local PARAGON_LABEL = "Paragon"

-- *** Reputations ***
local Factions = {
	-- Factions reference table, based on http://www.wowwiki.com/Factions
	{	-- [1]
		name = "Forever",	-- "Classic"
		{	-- [1]
			name = FACTION_ALLIANCE,	-- 469
			{ name = DataStore:GetFactionName(69), icon = "Achievement_Character_Nightelf_Female" },	-- "Darnassus"
			-- { name = DataStore:GetFactionName(930), icon = "Achievement_Character_Draenei_Male" },	--  name = "Exodar"
			{ name = DataStore:GetFactionName(54), icon = "Achievement_Character_Gnome_Female" },	-- "Gnomeregan"
			{ name = DataStore:GetFactionName(47), icon = "Achievement_Character_Dwarf_Male" },		-- "Ironforge"
			{ name = DataStore:GetFactionName(72), icon = "Achievement_Character_Human_Male" },		-- "Stormwind"
			-- { name = DataStore:GetFactionName(1134), icon = "Interface\\Glues\\CharacterCreate\\UI-CHARACTERCREATE-RACES", left = 0.625, right = 0.75, top = 0, bottom = 0.25 },	-- "Gilneas"
			-- { name = DataStore:GetFactionName(1353), icon = "Interface\\Glues\\CharacterCreate\\UI-CHARACTERCREATE-RACES", left = 0.75, right = 0.875, top = 0, bottom = 0.25 },	-- "Tushui Pandaren"
			-- { name = DataStore:GetFactionName(469), icon = "INV_BannerPVP_02" },	-- "Alliance"
		},
		{	-- [2]
			name = FACTION_HORDE,
			{ name = DataStore:GetFactionName(530), icon = "Achievement_Character_Troll_Male" },		-- "Darkspear Trolls"
			{ name = DataStore:GetFactionName(76), icon = "Achievement_Character_Orc_Male" },		-- "Orgrimmar"
			{ name = DataStore:GetFactionName(81), icon = "Achievement_Character_Tauren_Male" },		-- "Thunder Bluff"
			{ name = DataStore:GetFactionName(68), icon = "Achievement_Character_Undead_Female" },		-- "Undercity"
			-- { name = DataStore:GetFactionName(911), icon = "Achievement_Character_Bloodelf_Male" },		-- "Silvermoon City"
			-- { name = DataStore:GetFactionName(1133), icon = "Interface\\Glues\\CharacterCreate\\UI-CHARACTERCREATE-RACES", left = 0.625, right = 0.75, top = 0.25, bottom = 0.5 },	--  name = "Bilgewater Cartel"
			-- { name = DataStore:GetFactionName(1352), icon = "Interface\\Glues\\CharacterCreate\\UI-CHARACTERCREATE-RACES", left = 0.75, right = 0.875, top = 0.25, bottom = 0.5 },	-- "Huojin Pandaren" 
			-- { name = DataStore:GetFactionName(67), icon = "INV_BannerPVP_01" },	-- "Horde" 
		},
		{	-- [3]
			name = L["Alliance Forces"],	-- 891
			{ name = DataStore:GetFactionName(509), icon = "Achievement_BG_winAB" },	--  name = "The League of Arathor" 
			{ name = DataStore:GetFactionName(890), icon = "Achievement_BG_captureflag_WSG" },	-- "Silverwing Sentinels" 
			{ name = DataStore:GetFactionName(730), icon = "Achievement_BG_winAV" },		-- "Stormpike Guard"
		},
		{	-- [4]
			name = L["Horde Forces"],
			{ name = DataStore:GetFactionName(510), icon = "Achievement_BG_winAB" },		-- "The Defilers" 
			{ name = DataStore:GetFactionName(889), icon = "Achievement_BG_captureflag_WSG" },	-- "Warsong Outriders" 
			{ name = DataStore:GetFactionName(729), icon = "Achievement_BG_winAV" },		-- "Frostwolf Clan" 
		},
		{	-- [5]
			name = L["Steamwheedle Cartel"],
			{ name = DataStore:GetFactionName(21), icon = "Achievement_Zone_Stranglethorn_01" },		-- "Booty Bay" 
			{ name = DataStore:GetFactionName(577), icon = "Achievement_Zone_Winterspring" },		-- "Everlook" 
			{ name = DataStore:GetFactionName(369), icon = "Achievement_Zone_Tanaris_01" },		-- "Gadgetzan" 
			{ name = DataStore:GetFactionName(470), icon = "Achievement_Zone_Barrens_01" },		-- "Ratchet" 
		},
		{	-- [6]
			name = OTHER,
			{ name = DataStore:GetFactionName(529), icon = "INV_Jewelry_Talisman_07" },		-- "Argent Dawn" 
			{ name = DataStore:GetFactionName(87), icon = "INV_Helmet_66" },		-- "Bloodsail Buccaneers" 
			{ name = DataStore:GetFactionName(910), icon = "INV_Misc_Head_Dragon_Bronze" },		-- "Brood of Nozdormu" 
			{ name = DataStore:GetFactionName(609), icon = "Achievement_Zone_Silithus_01" },		-- "Cenarion Circle" 
			{ name = DataStore:GetFactionName(909), icon = "INV_Misc_Ticket_Darkmoon_01" },		-- "Darkmoon Faire" 
			{ name = DataStore:GetFactionName(92), icon = "INV_Misc_Head_Centaur_01" },			-- "Gelkis Clan Centaur" 
			{ name = DataStore:GetFactionName(749), icon = "Spell_Frost_SummonWaterElemental_2" },		-- "Hydraxian Waterlords" 
			{ name = DataStore:GetFactionName(93), icon = "INV_Misc_Head_Centaur_01" },		-- "Magram Clan Centaur" 
			{ name = DataStore:GetFactionName(349), icon = "INV_ThrowingKnife_04" },		-- "Ravenholdt" 
			{ name = DataStore:GetFactionName(809), icon = "Achievement_Zone_Feralas" },		-- "Shen'dralar" 
			{ name = DataStore:GetFactionName(70), icon = "INV_Misc_ArmorKit_03" },		-- "Syndicate" 
			{ name = DataStore:GetFactionName(59), icon = "INV_Ingot_Thorium" },		-- "Thorium Brotherhood" 
			{ name = DataStore:GetFactionName(576), icon = "Achievement_Reputation_timbermaw" },		-- "Timbermaw Hold" 
			-- { name = DataStore:GetFactionName(922), icon = "Achievement_Zone_Ghostlands" },		-- "Tranquillien" 
			-- { name = DataStore:GetFactionName(589), icon = "Ability_Mount_PinkTiger" },		-- "Wintersaber Trainers" 
			-- { name = DataStore:GetFactionName(270), icon = "INV_Bijou_Green" },		-- "Zandalar Tribe" 
		}
	},
	-- {	-- [12]
		-- name = GUILD,
		-- {	-- [1]
			-- name = GUILD,
		-- }
	-- },
}

-- local CAT_GUILD = #Factions
-- local CAT_ALLINONE = CAT_GUILD + 1
local CAT_ALLINONE = #Factions + 1

local VertexColors = {
	[FACTION_STANDING_LABEL1] = { r = 0.4, g = 0.13, b = 0.13 },	-- hated (dark red)
	[FACTION_STANDING_LABEL2] = { r = 0.5, g = 0.0, b = 0.0 },		-- hostile (red)
	[FACTION_STANDING_LABEL3] = { r = 0.6, g = 0.4, b = 0.13 },		-- unfriendly (dark orange)
	[FACTION_STANDING_LABEL4] = { r = 0.6, g = 0.6, b = 0.0 },		-- neutral (yellow)
	[FACTION_STANDING_LABEL5] = { r = 0.0, g = 0.6, b = 0.0 },		-- friendly (green)
	[FACTION_STANDING_LABEL6] = { r = 0.0, g = 0.6, b = 0.6 },		-- honored (teal)
	[FACTION_STANDING_LABEL7] = { r = 0.9, g = 0.3, b = 0.9 },		-- revered (magenta)
	[FACTION_STANDING_LABEL8] = { r = 1.0, g = 1.0, b = 1.0 },		-- exalted (white)
	[PARAGON_LABEL] = { r = 1.0, g = 1.0, b = 1.0 },					-- Paragon (white)
}

local Standings = { FACTION_STANDING_LABEL4, FACTION_STANDING_LABEL5, FACTION_STANDING_LABEL6, FACTION_STANDING_LABEL7, FACTION_STANDING_LABEL8	}

local view
local isViewValid

local OPTION_XPACK = "Reputations.CurrentXPack"
local OPTION_FACTION = "Reputations.CurrentFactionGroup"

local currentFaction

local function BuildView()
	view = view or {}
	wipe(view)
	
	local options = Altoholic_GridsTab_Options
	local currentXPack = options[OPTION_XPACK]
	local currentFactionGroup = options[OPTION_FACTION]

	if (currentXPack ~= CAT_ALLINONE) then
		for index, faction in ipairs(Factions[currentXPack][currentFactionGroup]) do
			table.insert(view, faction)	-- insert the table pointer
		end
	else	-- all in one, add all factions
		for xPackIndex, xpack in ipairs(Factions) do		-- all xpacks
			for factionGroupIndex, factionGroup in ipairs(xpack) do 	-- all faction groups
				for index, faction in ipairs(factionGroup) do
					table.insert(view, faction)	-- insert the table pointer
				end
			end
		end
		
		table.sort(view, function(a,b) 	-- sort all factions alphabetically
			if not a.name then
				DEFAULT_CHAT_FRAME:AddMessage(a.icon)
			end
			if not b.name then
				DEFAULT_CHAT_FRAME:AddMessage(b.icon)
			end
			
			return a.name < b.name
		end)
	end
	
	isViewValid = true
end

local function AddGuildsToFactionsTable(realm, account)
	-- get the guilds on this realm/account
	local guilds = AddonFactory:GetTable()
	for guildName, guild in pairs(DataStore:GetGuilds(realm, account)) do
		if DataStore:GetGuildFaction(guildName, realm, account) == FACTION_ALLIANCE then
			guilds[guildName] = "inv_misc_tournaments_banner_human"
		else
			guilds[guildName] = "inv_misc_tournaments_banner_orc"
		end
	end
	
	-- clean the Factions table
	for k, v in ipairs(Factions[CAT_GUILD][1]) do	-- ipairs ! only touch the array part, leave the hash untouched
		Factions[CAT_GUILD][1][k] = nil
	end
	
	-- add them to the Factions table
	for k, v in pairs(guilds) do
		table.insert(Factions[CAT_GUILD][1], { name = k, icon = v } )
	end
	
	AddonFactory:ReleaseTable(guilds)
end

local tab = AltoholicFrame.TabGrids

tab:RegisterGrid(2, {
	InvalidateView = function()
		isViewValid = nil
	end,
	OnUpdate = function() 
			if isViewValid then return end

			local options = Altoholic_GridsTab_Options
			local currentXPack = options[OPTION_XPACK]
			local currentFactionGroup = options[OPTION_FACTION]
			
			-- if (currentXPack == CAT_GUILD) then
				-- tab:SetStatus(format("%s%s|r / %s%s", colors.white, L["Reputations"], colors.green, GUILD))
				-- AddGuildsToFactionsTable(tab:GetRealm())
				
			-- elseif (currentXPack == CAT_ALLINONE) then
			if (currentXPack == CAT_ALLINONE) then
				tab:SetStatus(format("%s%s|r / %s%s", colors.white, L["Reputations"], colors.cyan, L["All-in-one"]))
				
			else
				tab:SetStatus(format("%s%s|r / %s%s|r / %s%s", 
					colors.white, L["Reputations"], 
					colors.white, Factions[currentXPack].name, 
					colors.green, Factions[currentXPack][currentFactionGroup].name))
			end

			BuildView()
		end,
	GetSize = function() return #view end,
	RowSetup = function(self, rowFrame, dataRowID)
			currentFaction = view[dataRowID]

			rowFrame.Name.Text:SetText(format("%s%s", colors.white, currentFaction.name))
			rowFrame.Name.Text:SetJustifyH("LEFT")
		end,
	ColumnSetup = function(self, button, dataRowID, character)
			local faction = currentFaction
			
			if faction.left then		-- if it's not a full texture, use tcoords
				button.Background:SetTexture(faction.icon)
				button.Background:SetTexCoord(faction.left, faction.right, faction.top, faction.bottom)
			else
				button.Background:SetTexture(format("Interface\\Icons\\%s", faction.icon))
				button.Background:SetTexCoord(0, 1, 0, 1)
			end		
			
			button.Name:SetFontObject("GameFontNormalSmall")
			button.Name:SetJustifyH("CENTER")
			button.Name:SetPoint("BOTTOMRIGHT", 5, 0)
			button.Background:SetDesaturated(false)
			
			local status, _, _, rate, isMajorFaction, isFriendshipFaction, factionID = DataStore:GetReputationInfo(character, faction.name)
			
			if status and rate then 
				local text
				
				if isMajorFaction then									-- If we are dealing with a major faction ..
					text = format("%d", status)					-- .. status will contain the renown level
					button.Name:SetFontObject("NumberFontNormalSmall")
					button.Name:SetJustifyH("RIGHT")
					button.Name:SetPoint("BOTTOMRIGHT", -2, 0)
				
				elseif status == FACTION_STANDING_LABEL8 then	-- If exalted .. 
					text = icons.ready									-- .. just show the green check
				elseif status == PARAGON_LABEL then					-- Else if paragon levels..
					if rate >= 100 then
						text = icons.waiting
					else
						button.Name:SetFontObject("NumberFontNormalSmall")
						button.Name:SetJustifyH("RIGHT")
						button.Name:SetPoint("BOTTOMRIGHT", 0, 0)
						text = format("%2d%%", floor(rate))
					end
				else
					if rate >= 100 then
						text = icons.ready					-- show the green check on max friendships too
					else
						button.Background:SetDesaturated(true)
						button.Name:SetFontObject("NumberFontNormalSmall")
						button.Name:SetJustifyH("RIGHT")
						button.Name:SetPoint("BOTTOMRIGHT", 0, 0)
						text = format("%2d%%", floor(rate))
					end
				end

				-- local vc = (isMajorFaction or isFriendshipFaction) and VertexColors[FACTION_STANDING_LABEL4] or VertexColors[status]

				local vcIndex = FACTION_STANDING_LABEL4

				if (isMajorFaction or isFriendshipFaction) then                           -- do something better than just all neutral
					local totalRate = 1							-- or fallback to neutral
					local maxStanding = 0

					if isMajorFaction then
						maxStanding = #(C_MajorFactions.GetRenownLevels(factionID))
					else
						maxStanding = C_GossipInfo.GetFriendshipReputationRanks(factionID).maxLevel
					end

					if maxStanding > 0 then
						totalRate = 1 + floor(4 * status / maxStanding)
					end

					vcIndex = Standings[totalRate]
				else
					vcIndex = status
				end

				local vc = VertexColors[vcIndex]										
				button.Background:SetVertexColor(vc.r, vc.g, vc.b);
				
				local color = colors.white
				if status == FACTION_STANDING_LABEL1 or status == FACTION_STANDING_LABEL2 then
					color = colors.darkred
				elseif status == PARAGON_LABEL then
					color = colors.epic
				end

				button.key = character
				button:SetID(dataRowID)
				button.Name:SetText(format("%s%s", color, text))
			else
				button.Background:SetVertexColor(0.3, 0.3, 0.3)		-- greyed out
				button.Name:SetText(icons.notReady)
				button:SetID(0)
				button.key = nil
			end
		end,
		
	OnEnter = function(frame) 
			local character = frame.key
			if not character then return end

			local faction = view[ frame:GetID() ].name
			local status, currentLevel, maxLevel, rate, isMajorFaction, isFriendshipFaction, factionID = DataStore:GetReputationInfo(character, faction)
			if not status then return end

			local tooltip = AddonFactory_Tooltip
			
			tooltip:SetOwner(frame, "ANCHOR_LEFT")
			tooltip:ClearLines()
			tooltip:AddLine(format("%s %s@ %s%s", 
				DataStore:GetColoredCharacterName(character), colors.white, colors.teal, faction))

			rate = format("%d%%", floor(rate))
			
			if isMajorFaction then
				tooltip:AddLine(format("%s: %d/%d (%s)", format(LEVEL_GAINED, status), currentLevel, maxLevel, rate),1,1,1 )
			elseif isFriendshipFaction then
				local ranks = C_GossipInfo.GetFriendshipReputationRanks(factionID)

				tooltip:AddLine(format("%s %s/%s", RANK, status, ranks.maxLevel), 1,1,1)
				tooltip:AddLine(format("%d/%d (%s)", currentLevel, maxLevel, rate), 1,1,1)
			else
				tooltip:AddLine(format("%s: %d/%d (%s)", status, currentLevel, maxLevel, rate),1,1,1)
				
				local xp = DataStore.Enum.FactionStandingXPPerLevel
				
				tooltip:AddLine(" ",1,1,1)
				tooltip:AddLine(format("%s = %s", icons.notReady, UNKNOWN), 0.8, 0.13, 0.13)
				tooltip:AddDoubleLine(FACTION_STANDING_LABEL1, xp[1], 0.8, 0.13, 0.13)
				tooltip:AddDoubleLine(FACTION_STANDING_LABEL2, xp[2], 1.0, 0.0, 0.0)
				tooltip:AddDoubleLine(FACTION_STANDING_LABEL3, xp[3], 0.93, 0.4, 0.13)
				tooltip:AddDoubleLine(FACTION_STANDING_LABEL4, xp[4], 1.0, 1.0, 0.0)
				tooltip:AddDoubleLine(FACTION_STANDING_LABEL5, xp[5], 0.0, 1.0, 0.0)
				tooltip:AddDoubleLine(FACTION_STANDING_LABEL6, xp[6], 0.0, 1.0, 0.8)
				tooltip:AddDoubleLine(FACTION_STANDING_LABEL7, xp[7], 1.0, 0.4, 1.0)
				
				tooltip:AddLine(format("%s = %s", icons.ready, FACTION_STANDING_LABEL8), 1, 1, 1)
				tooltip:AddLine(format("%s = %s%s", icons.waiting, colors.epic, PARAGON_LABEL), 1, 1, 1)
			end
			
			tooltip:AddLine(" ",1,1,1)
			tooltip:AddLine(format("%s%s", colors.green, L["Shift+Left click to link"]))
			tooltip:Show()
			
		end,
	OnClick = function(frame, button)
			local character = frame.key
			if not character then return end

			local faction = view[ frame:GetParent():GetID() ].name
			local status, currentLevel, maxLevel, rate, isMajorFaction, isFriendshipFaction = DataStore:GetReputationInfo(character, faction)
			if not status then return end
			
			if button == "LeftButton" and IsShiftKeyDown() then
				local chat = ChatEdit_GetLastActiveWindow()
				if chat:IsShown() then
					if isMajorFaction then
						status = format(LEVEL_GAINED, status)
					end
					
					chat:Insert(format(L["%s is %s with %s (%d/%d)"], DataStore:GetCharacterName(character), status, faction, currentLevel, maxLevel))
				end
			end
		end,
	OnLeave = function(self)
			AddonFactory_Tooltip:Hide() 
		end,
})
