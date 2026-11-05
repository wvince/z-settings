local addon = Altoholic

addon:Service("AltoholicUI.TabSummaryColumns",  function()
	local columns = {}

	return {
		RegisterColumn = function(name, data)
			if columns[name] then
				addon:Print(format("AltoholicUI.TabSummaryColumns:RegisterColumn() : Column %s already registered", name))
				return
			end
			
			columns[name] = data
		end,
		Get = function(name)
			return columns[name]
		end,
}end)

addon:Service("AltoholicUI.TabSummaryColumnProfiles",  function() 
	local profiles = {
		-- Account Summary
		[1] = { "Name", "Level", "RestXP", "Money", "Played", "AiL", "LastOnline" },
		-- Experience
		[2] = { "Name", "Level", "RestXP", "MaxRestXP", "SavedRestXP", "EarnedRestXP", "FullyRestedIn" },
		-- Levels
		-- [3] = { "Name", "Level", "AiL", "HonorLevel", "Renown" },
		[3] = { "Name", "Level", "AiL", "Renown", "DungeonScore" },
		-- Guild
		[4] = { "Name", "Level", "GuildName", "GuildRank", "GuildRep" },
		-- Location
		[5] = { "Name", "Level", "Hearthstone", "Zone", "SubZone" },
		-- Miscellaneous
		[6] = { "Name", "Level", "ClassAndSpec", "BankType", "AltGroup" },

		-- Bags
		[7] = { "Name", "Level", "BagSlots", "FreeBagSlots", "BankSlots", "FreeBankSlots" },
		-- Skills
		-- [8] = { "Name", "Level", "Prof1", "Prof2", "ProfCooking", "ProfFishing", "ProfArchaeology", "Riding" },
		[8] = { "Name", "Level", "Prof1", "Prof2", "ProfCooking", "ProfFirstAid", "ProfFishing" },
		-- Activity
		-- [9] = { "Name", "Level", "Mails", "LastMailCheck", "Auctions", "Bids", "AHLastVisit", "MissionTableLastVisit" },
		[9] = { "Name", "Level", "Mails", "LastMailCheck", "Auctions", "Bids", "AHLastVisit" },
		
		-- Currencies / Miscellaneous
		[10] = { "Name", "Level", "Cur_TimewarpedBadge", "Cur_Darkmoon", "Cur_Epicurean", "Cur_Ironpaw", "Cur_SpiritShard", "Cur_ChampionsSeal" },
			
		-- Activity / Mails
		[34] = { "Name", "Level", "Mails", "LastMailCheck", "Mails_NumReturns", "Mails_ClosestReturn", "Mails_NumDelete", "Mails_ClosestDelete" },
		
		-- Activity / Auctions
		[35] = { "Name", "Level", "Auctions", "AHLastVisit", "Auction_HighBuyout", "Auction_LowBuyout", "Auction_ClosestExpiry" },

		-- Activity / Bids
		-- [36] = { "Name", "Level", "Bids", "AHLastVisit" },

		-- Equipment
		[37] = { "Name", "Level", "AiL", "Inv_HighestLevel", "Inv_LowestLevel", "Inv_NumEpics", "Inv_NumBlues", "Inv_NumGreens", "Inv_NumHeirlooms" },

	}

	return {
		Get = function(index)
			return profiles[index]
		end,
}end)
