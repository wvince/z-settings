local addonName = "Altoholic"
local addon = _G[addonName]
local colors = AddonFactory.Colors

local L = AddonFactory:GetLocale(addonName)
local MVC = LibStub("LibMVC-1.0")
local Columns = MVC:GetService("AltoholicUI.TabSummaryColumns")
local Formatter = MVC:GetService("AltoholicUI.Formatter")

local enum = DataStore.Enum.CurrencyIDs

-- *** Utility functions ***
local function CurrencyHeader_OnEnter(frame, tooltip, column)
	tooltip:ClearLines()
	tooltip:SetOwner(frame, "ANCHOR_BOTTOM")
	tooltip:SetHyperlink(C_CurrencyInfo.GetCurrencyLink(column.currencyID, 0))
	tooltip:Show()
end

local function GetTotals(character, currencyID)
	local amount, _, _, totalMax = DataStore:GetCurrencyTotals(character, currencyID)

	-- After the DataStore_Currencies SV file was cleared, if may happen that an alt has no data, 
	-- so both values would be nil, default them to 0
	
	return amount or 0, totalMax or 0
end

local function SortByTotal(frame, character, column)
	return GetTotals(character, column.currencyID)
end

local function GetCurrencyText(character, column)
	local amount, totalMax = GetTotals(character, column.currencyID)
	local color = (amount == 0) and colors.grey or colors.white
	
	return format("%s%s", color, amount)
end

local function GetCurrencyTextWithMax(character, column)
	local amount, totalMax = GetTotals(character, column.currencyID)
	local color = (amount == 0) and colors.grey or colors.white
	
	return format("%s%s%s/%s%s", color, amount, colors.white, colors.yellow, totalMax)
end

-- ** Miscellaneous **
Columns.RegisterColumn("Cur_TimewarpedBadge", {
	currencyID = enum.TimewarpedBadge,

	-- Header
	headerWidth = 60,
	headerLabel = format("   %s", Formatter.Texture18("Interface\\Icons\\pvecurrency-justice")),
	headerOnEnter = CurrencyHeader_OnEnter,
	headerSort = SortByTotal,
	
	-- Content
	Width = 60,
	GetText = GetCurrencyText,
})

Columns.RegisterColumn("Cur_Darkmoon", {
	currencyID = enum.DarkmoonPrize,
	
	-- Header
	headerWidth = 60,
	headerLabel = format("   %s", Formatter.Texture18("Interface\\Icons\\inv_misc_ticket_darkmoon_01")),
	headerOnEnter = CurrencyHeader_OnEnter,
	headerSort = SortByTotal,
	
	-- Content
	Width = 60,
	GetText = GetCurrencyText,
})

Columns.RegisterColumn("Cur_Epicurean", {
	currencyID = enum.EpicureansAward,
	
	-- Header
	headerWidth = 60,
	headerLabel = format("   %s", Formatter.Texture18("Interface\\Icons\\inv_misc_ribbon_01")),
	headerOnEnter = CurrencyHeader_OnEnter,
	headerSort = SortByTotal,
	
	-- Content
	Width = 60,
	GetText = GetCurrencyText,
})

Columns.RegisterColumn("Cur_Ironpaw", {
	currencyID = enum.IronpawToken,
	
	-- Header
	headerWidth = 60,
	headerLabel = format("   %s", Formatter.Texture18("Interface\\Icons\\inv_relics_idolofferocity")),
	headerOnEnter = CurrencyHeader_OnEnter,
	headerSort = SortByTotal,
	
	-- Content
	Width = 60,
	GetText = GetCurrencyText,
})

Columns.RegisterColumn("Cur_SpiritShard", {
	currencyID = enum.SpiritShard,
	-- Header
	headerWidth = 80,
	headerLabel = format("%s[2.0]  %s", colors.green, Formatter.Texture18("Interface\\Icons\\inv_jewelry_frostwolftrinket_04")),
	headerOnEnter = CurrencyHeader_OnEnter,
	headerSort = SortByTotal,
	
	-- Content
	Width = 80,
	GetText = GetCurrencyTextWithMax,
})

Columns.RegisterColumn("Cur_ChampionsSeal", {
	currencyID = enum.ChampionsSeal,

	-- Header
	headerWidth = 80,
	headerLabel = format("%s[3.0]  %s", colors.green, Formatter.Texture18("Interface\\Icons\\ability_paladin_artofwar")),
	headerOnEnter = CurrencyHeader_OnEnter,
	headerSort = SortByTotal,
	
	-- Content
	Width = 80,
	GetText = GetCurrencyText,
})
