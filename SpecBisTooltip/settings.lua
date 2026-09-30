-- By D4KiR
local _, SpecBisTooltip = ...
local ICON = 136031
local DEFAULT_WIDTH = 600
local DEFAULT_HEIGHT = 600
local validEquipSlotsClassic = {"INVTYPE_HEAD", "INVTYPE_NECK", "INVTYPE_SHOULDER", "INVTYPE_CLOAK", "INVTYPE_CHEST", "INVTYPE_WRIST", "INVTYPE_HAND", "INVTYPE_WAIST", "INVTYPE_LEGS", "INVTYPE_FEET", "INVTYPE_FINGER", "INVTYPE_TRINKET", "INVTYPE_WEAPON", "INVTYPE_2HWEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_HOLDABLE", "INVTYPE_RANGED", "INVTYPE_THROWN", "INVTYPE_SHIELD", "INVTYPE_RELIC",}
local validEquipSlotsRetail = {"INVTYPE_HEAD", "INVTYPE_NECK", "INVTYPE_SHOULDER", "INVTYPE_CLOAK", "INVTYPE_CHEST", "INVTYPE_WRIST", "INVTYPE_HAND", "INVTYPE_WAIST", "INVTYPE_LEGS", "INVTYPE_FEET", "INVTYPE_FINGER", "INVTYPE_TRINKET", "INVTYPE_WEAPON", "INVTYPE_2HWEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_HOLDABLE", "INVTYPE_RANGED", "INVTYPE_SHIELD"}
local sbt_settings = nil
local function ShowMinimapButtonDefault()
	return SpecBisTooltip:GetWoWBuild() ~= "RETAIL"
end

local function ApplyDefaults()
	SBTTAB = SBTTAB or {}
	SBTTABPC = SBTTABPC or {}
	SpecBisTooltip:SV(SBTTAB, "SHOWMINIMAPBUTTON", SpecBisTooltip:GV(SBTTAB, "SHOWMINIMAPBUTTON", ShowMinimapButtonDefault()))
	SpecBisTooltip:SV(SBTTAB, "SMALLERTOOLTIP", SpecBisTooltip:GV(SBTTAB, "SMALLERTOOLTIP", false))
	SpecBisTooltip:SV(SBTTAB, "SHOWPREBIS", SpecBisTooltip:GV(SBTTAB, "SHOWPREBIS", true))
	SpecBisTooltip:SV(SBTTAB, "SHOWOTHERSPECS", SpecBisTooltip:GV(SBTTAB, "SHOWOTHERSPECS", true))
	SpecBisTooltip:SV(SBTTAB, "SHOWOTHERCLASSES", SpecBisTooltip:GV(SBTTAB, "SHOWOTHERCLASSES", false))
	SpecBisTooltip:SV(SBTTAB, "SHOWNOTBIS", SpecBisTooltip:GV(SBTTAB, "SHOWNOTBIS", false))
	if SpecBisTooltip:GetBisPool() == "RETAIL" then
		SpecBisTooltip:SV(SBTTAB, "PREFERREDCONTENT", SpecBisTooltip:GV(SBTTAB, "PREFERREDCONTENT", "BISO"))
		SpecBisTooltip:SV(SBTTAB, "SHOWCATALYST", SpecBisTooltip:GV(SBTTAB, "SHOWCATALYST", true))
	else
		SpecBisTooltip:SV(SBTTAB, "SHOWOLDERPHASES", SpecBisTooltip:GV(SBTTAB, "SHOWOLDERPHASES", true))
	end
end

local function GetCollapsed(key)
	if key == nil then return nil end
	if type(SBTTAB) ~= "table" then return nil end
	if type(SBTTAB["COLLAPSED"]) ~= "table" then return nil end

	return SBTTAB["COLLAPSED"][key]
end

local function SetCollapsed(key, collapsed)
	if key == nil then return end
	if type(SBTTAB) ~= "table" then return end
	if type(SBTTAB["COLLAPSED"]) ~= "table" then SBTTAB["COLLAPSED"] = {} end
	if collapsed then
		SBTTAB["COLLAPSED"][key] = true
	else
		SBTTAB["COLLAPSED"][key] = nil
	end
end

local function AddCheckbox(key, value, func)
	sbt_settings:AddCheckbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = SpecBisTooltip:GV(SBTTAB, key, value),
		["func"] = function(val)
			SpecBisTooltip:SV(SBTTAB, key, val)
			if func then func(val) end
		end
	})
end

local function GetCustomSlots()
	local slots = {}
	local tab = validEquipSlotsClassic
	if SpecBisTooltip:GetBisPool() == "RETAIL" then tab = validEquipSlotsRetail end
	for _, invType in ipairs(tab) do
		if invType == "INVTYPE_FINGER" or invType == "INVTYPE_TRINKET" then
			tinsert(slots, {invType, invType .. 1})
			tinsert(slots, {invType, invType .. 2})
		else
			tinsert(slots, {invType, invType})
		end
	end

	return slots
end

local function AddCustomSlot(invType, key, guideText)
	sbt_settings:AddCategory({
		["label"] = "LID_" .. key,
		["search"] = key,
		["key"] = "CUSTOM_" .. key,
		["level"] = 2
	})

	local item = SpecBisTooltip:GV(SBTTABPC, key, "")
	if item == nil then item = "" end
	sbt_settings:AddEditbox({
		["label"] = SpecBisTooltip:Trans("LID_ITEM") .. guideText,
		["search"] = key,
		["value"] = tostring(item),
		["numeric"] = true,
		["maxLetters"] = 10,
		["func"] = function(value) SpecBisTooltip:SV(SBTTABPC, key, tonumber(value)) end
	})

	local source = SpecBisTooltip:GV(SBTTABPC, key .. "_SOURCE", "")
	if source == nil then source = "" end
	sbt_settings:AddEditbox({
		["label"] = SpecBisTooltip:Trans("LID_SOURCE"),
		["search"] = key .. "_SOURCE",
		["value"] = tostring(source),
		["func"] = function(value)
			if value == "" then value = nil end
			SpecBisTooltip:SV(SBTTABPC, key .. "_SOURCE", value)
		end
	})
end

function SpecBisTooltip:ToggleSettings()
	if sbt_settings then sbt_settings:Toggle() end
end

function SpecBisTooltip:InitSettings()
	ApplyDefaults()
	sbt_settings = SpecBisTooltip:CreateUIWindow({
		["name"] = "SpecBisTooltipSettings",
		["pTab"] = {"CENTER"},
		["width"] = SpecBisTooltip:GV(SBTTAB, "WINDOWWIDTH", DEFAULT_WIDTH),
		["height"] = SpecBisTooltip:GV(SBTTAB, "WINDOWHEIGHT", DEFAULT_HEIGHT),
		["minWidth"] = 360,
		["minHeight"] = 240,
		["onResize"] = function(width, height)
			SpecBisTooltip:SV(SBTTAB, "WINDOWWIDTH", width)
			SpecBisTooltip:SV(SBTTAB, "WINDOWHEIGHT", height)
		end,
		["getCollapsed"] = function(key) return GetCollapsed(key) end,
		["setCollapsed"] = function(key, collapsed) SetCollapsed(key, collapsed) end,
		["title"] = format("|T%d:16:16:0:0|t SpecBisTooltip v%s", ICON, SpecBisTooltip:GetVersion())
	})

	sbt_settings:SuspendLayout()
	sbt_settings:AddSearch()
	sbt_settings:AddCategory({
		["label"] = "LID_GENERAL",
		["search"] = "GENERAL",
		["key"] = "GENERAL"
	})

	AddCheckbox("SHOWMINIMAPBUTTON", ShowMinimapButtonDefault(), function(value)
		if value then
			SpecBisTooltip:ShowMMBtn("SpecBisTooltip")
		else
			SpecBisTooltip:HideMMBtn("SpecBisTooltip")
		end
	end)

	sbt_settings:AddCategory({
		["label"] = "LID_TOOLTIP",
		["search"] = "TOOLTIP",
		["key"] = "TOOLTIP"
	})

	AddCheckbox("SMALLERTOOLTIP", false)
	AddCheckbox("SHOWPREBIS", true)
	AddCheckbox("SHOWOTHERSPECS", true)
	AddCheckbox("SHOWOTHERCLASSES", false)
	AddCheckbox("SHOWNOTBIS", false)
	if SpecBisTooltip:GetBisPool() == "RETAIL" then
		AddCheckbox("SHOWCATALYST", true)
		sbt_settings:AddDropdown({
			["label"] = "LID_PREFERREDCONTENT",
			["search"] = "PREFERREDCONTENT",
			["value"] = SpecBisTooltip:GV(SBTTAB, "PREFERREDCONTENT", "BISO"),
			["choices"] = {
				{
					["value"] = "BISO",
					["label"] = "LID_PREFERREDBISO"
				},
				{
					["value"] = "BISR",
					["label"] = "LID_PREFERREDBISR"
				},
				{
					["value"] = "BISM",
					["label"] = "LID_PREFERREDBISM"
				},
			},
			["func"] = function(value) SpecBisTooltip:SV(SBTTAB, "PREFERREDCONTENT", value) end
		})
	else
		AddCheckbox("SHOWOLDERPHASES", true)
	end

	sbt_settings:AddCategory({
		["label"] = "LID_CUSTOMBISIDS",
		["search"] = "CUSTOMBISIDS",
		["key"] = "CUSTOMBISIDS",
		["collapsed"] = true
	})

	local specId = SpecBisTooltip:GetTalentInfo()
	local _, class = UnitClass("PLAYER")
	local guideTexts = {}
	for _, slot in ipairs(GetCustomSlots()) do
		local invType, key = slot[1], slot[2]
		if guideTexts[invType] == nil then
			local guideText = ""
			local _, _, _, itemId = SpecBisTooltip:GetBisSource(invType, class, specId, SpecBisTooltip:GV(SBTTAB, "PREFERREDCONTENT", "BISO"), nil, true)
			if itemId then guideText = " (" .. SpecBisTooltip:Trans("LID_GUIDEITEMID") .. ": " .. itemId .. ")" end
			guideTexts[invType] = guideText
		end

		AddCustomSlot(invType, key, guideTexts[invType])
	end

	sbt_settings:ResumeLayout()
end
