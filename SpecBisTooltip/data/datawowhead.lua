-- By D4KiR
local _, SpecBisTooltip = ...
local C_Seasons = getglobal("C_Seasons")
function SpecBisTooltip:AddToSOD(class, specid, tab)
	if tab then
		for i, v in pairs(tab) do
			if SpecBisTooltip:GetBisTable()["CLASSIC"][class][specid][i] == nil then SpecBisTooltip:GetBisTable()["CLASSIC"][class][specid][i] = v end
		end
	end
end

if C_Seasons and C_Seasons.GetActiveSeason and C_Seasons.GetActiveSeason() == 2 then SpecBisTooltip:AddOldSodPhases() end
local sortBfs = {}
sortBfs["BISO"] = 1
sortBfs["BISMR"] = 2
sortBfs["BISM"] = 3
sortBfs["BISR"] = 4
sortBfs["BIS,PVE,P6"] = 10
sortBfs["BIS,PVE,P5"] = 11
sortBfs["BIS,PVE,P4"] = 12
sortBfs["BIS,PVE,P3"] = 13
sortBfs["BIS,PVE,P2"] = 14
sortBfs["BIS,PVE,P1"] = 15
sortBfs["PREBIS,PVE,P6"] = 20
sortBfs["PREBIS,PVE,P5"] = 21
sortBfs["PREBIS,PVE,P4"] = 22
sortBfs["PREBIS,PVE,P3"] = 23
sortBfs["PREBIS,PVE,P2"] = 24
sortBfs["PREBIS,PVE,P1"] = 25
sortBfs["BIS,PREPATCH"] = 26
sortBfs["BIS,PVE,SODP8"] = 30
sortBfs["PREBIS,PVE,SODP8"] = 31
sortBfs["BIS,PVE,SODP7"] = 32
sortBfs["PREBIS,PVE,SODP7"] = 33
sortBfs["BIS,PVE,SODP6"] = 34
sortBfs["PREBIS,PVE,SODP6"] = 35
sortBfs["BIS,PVE,SODP5"] = 36
sortBfs["PREBIS,PVE,SODP5"] = 37
sortBfs["BIS,PVE,SODP4"] = 38
sortBfs["PREBIS,PVE,SODP4"] = 39
sortBfs["BIS,PVE,SODP3"] = 40
sortBfs["PREBIS,PVE,SODP3"] = 41
sortBfs["BIS,PVE,SODP2"] = 42
sortBfs["PREBIS,PVE,SODP2"] = 43
sortBfs["BIS,PVE,SODP1"] = 44
sortBfs["PREBIS,PVE,SODP1"] = 45
sortBfs["PREBIS,PVE"] = 46
sortBfs["S+"] = 60
sortBfs["S"] = 61
sortBfs["S-"] = 62
sortBfs["A+"] = 63
sortBfs["A"] = 64
sortBfs["A-"] = 65
sortBfs["B+"] = 66
sortBfs["B"] = 67
sortBfs["B-"] = 68
sortBfs["C+"] = 69
sortBfs["C"] = 70
sortBfs["C-"] = 71
sortBfs["D+"] = 72
sortBfs["D"] = 73
sortBfs["D-"] = 74
sortBfs["E+"] = 75
sortBfs["E"] = 76
sortBfs["E-"] = 77
sortBfs["F+"] = 78
sortBfs["F"] = 79
sortBfs["F-"] = 80
sortBfs["G+"] = 81
sortBfs["G"] = 82
sortBfs["G-"] = 83
sortBfs["No"] = 84
sortBfs["?"] = 90
sortBfs["?????"] = 99
local bfs = {}
local catalystRaw = {}
local function AddBfsEntry(content, itemId, className, specId, itemEntry)
	bfs[content][itemId] = bfs[content][itemId] or {}
	for i, entry in pairs(bfs[content][itemId]) do
		if entry[1] == className and entry[2] == specId then return end
	end

	table.insert(bfs[content][itemId], {className, specId, itemEntry})
end

local function AddCatalystEntry(content, tierItemId, className, specId, itemEntry)
	if type(itemEntry[1]) ~= "string" then return end
	local rawItemId = tonumber(string.match(itemEntry[1], "^catalyst;item=(%d+)$"))
	if rawItemId == nil then return end
	catalystRaw[className] = catalystRaw[className] or {}
	catalystRaw[className][specId] = catalystRaw[className][specId] or {}
	catalystRaw[className][specId][content] = catalystRaw[className][specId][content] or {}
	catalystRaw[className][specId][content][rawItemId] = {tierItemId, itemEntry[2]}
	AddBfsEntry(content, rawItemId, className, specId, itemEntry)
end

function SpecBisTooltip:InitBFSContent(pool, content)
	bfs[content] = {}
	if SpecBisTooltip:GetBisTable()[pool] then
		for className, classTab in pairs(SpecBisTooltip:GetBisTable()[pool]) do
			for specId, specTab in pairs(classTab) do
				if specTab[content] then
					for itemId, itemEntry in pairs(specTab[content]) do
						if itemId > 100 then
							AddBfsEntry(content, itemId, className, specId, itemEntry)
							AddCatalystEntry(content, itemId, className, specId, itemEntry)
						else
							for heroItemId, heroItemEntry in pairs(itemEntry) do
								AddBfsEntry(content, heroItemId, className, specId, heroItemEntry)
								AddCatalystEntry(content, heroItemId, className, specId, heroItemEntry)
							end
						end
					end
				end
			end
		end
	end

	for i, entries in pairs(bfs[content]) do
		table.sort(entries, function(a, b)
			local sortA = sortBfs[a[3][2]] or sortBfs[content] or 100
			local sortB = sortBfs[b[3][2]] or sortBfs[content] or 100
			if sortA == sortB then
				if a[1] == b[1] then return a[2] < b[2] end
				return a[1] < b[1]
			end

			return sortA < sortB
		end)
	end
end

function SpecBisTooltip:InitBFS()
	local pool = SpecBisTooltip:GetBisPool()
	if pool ~= "RETAIL" then
		if SpecBisTooltip:GetBisTable()[pool] then
			for className, classTab in pairs(SpecBisTooltip:GetBisTable()[pool]) do
				for specId, specTab in pairs(classTab) do
					for itemId, itemTyp in pairs(specTab) do
						bfs[itemId] = bfs[itemId] or {}
						table.insert(bfs[itemId], {className, specId, itemTyp})
					end
				end
			end
		end

		for i, bf in pairs(bfs) do
			table.sort(bf, function(a, b)
				if a == nil then
					SpecBisTooltip:MSG("[InitBFS] a is nil")
					return false
				end

				if b == nil then
					SpecBisTooltip:MSG("[InitBFS] b is nil")
					return false
				end

				if sortBfs[a[3][1]] == nil then
					SpecBisTooltip:MSG("MISSING SORTING KEY", a[3][1])
					return true
				end

				if sortBfs[b[3][1]] == nil then
					SpecBisTooltip:MSG("MISSING SORTING KEY", b[3][1])
					return false
				end

				if sortBfs[a[3][1]] == sortBfs[b[3][1]] then return a[1] < b[1] end
				return sortBfs[a[3][1]] < sortBfs[b[3][1]]
			end)
		end
	else
		SpecBisTooltip:InitBFSContent(pool, "BISO")
		SpecBisTooltip:InitBFSContent(pool, "BISR")
		SpecBisTooltip:InitBFSContent(pool, "BISM")
		SpecBisTooltip:InitBFSContent(pool, "TRINKETS")
	end
end

SpecBisTooltip:InitBFS()
function SpecBisTooltip:GetBFS(itemId)
	return bfs[itemId]
end

function SpecBisTooltip:GetBFSRetail(itemId, content)
	if bfs[content] and bfs[content][itemId] then return bfs[content][itemId] end
	return nil
end

local bfi = {}
local missingSpec = false
local function BuildSlotIndex(class, specId, content)
	bfi[class] = bfi[class] or {}
	bfi[class][specId] = bfi[class][specId] or {}
	local contentKey = content or "ANY"
	if bfi[class][specId][contentKey] then return bfi[class][specId][contentKey] end
	local slots = {}
	bfi[class][specId][contentKey] = slots
	local function AddSlot(slot, itemId)
		if slot == nil then return end
		slots[slot] = slots[slot] or {}
		table.insert(slots[slot], itemId)
	end

	local pool = SpecBisTooltip:GetBisPool()
	local bisTab = SpecBisTooltip:GetBisTable()[pool]
	if bisTab == nil then
		SpecBisTooltip:MSG("Missing POOL!", pool)
		return slots
	end

	if bisTab[class] == nil then
		SpecBisTooltip:MSG("[GetBisSource] Missing Class!", class .. " | WoW: " .. pool)
		return slots
	end

	if bisTab[class][specId] == nil then
		SpecBisTooltip:MSG("Missing specId!", specId)
		return slots
	end

	for itemId, itemEntry in pairs(bisTab[class][specId]) do
		if pool == "CLASSIC" or pool == "TBC" or pool == "CATA" then
			AddSlot(itemEntry[3], itemId)
		elseif type(itemId) == "string" then
			if itemId == content then
				local contentTab = bisTab[class][specId][content]
				local heroSpecId = SpecBisTooltip:GetHeroSpecId()
				if heroSpecId and contentTab[heroSpecId] then contentTab = contentTab[heroSpecId] end
				for heroItemId, heroItemEntry in pairs(contentTab) do
					AddSlot(heroItemEntry[2], heroItemId)
				end
			end
		else
			AddSlot(itemEntry[2], itemId)
		end
	end

	return slots
end

function SpecBisTooltip:GetBisSource(invType, class, specId, content, num, guide)
	guide = guide or false
	local n = num or 1
	if invType == nil then return nil, nil, nil end
	if specId == nil then
		local level = UnitLevel("player")
		if level >= 10 and not missingSpec then
			missingSpec = true
			SpecBisTooltip:MSG("[GetBisSource] Missing SpecId (Talents not set?)")
		end
		return nil, nil, nil
	end

	if specId == 0 or specId > 4 then
		SpecBisTooltip:MSG("[GetBisSource] NO SPEC DETECTED", specId)
		return
	end

	local slots = BuildSlotIndex(class, specId, content)
	local custom = false
	if slots[invType] then
		local itemId = slots[invType][n]
		if not guide and SBTTABPC then
			if n and SBTTABPC[invType .. n] then
				itemId = SBTTABPC[invType .. n]
				custom = true
			elseif SBTTABPC[invType] then
				itemId = SBTTABPC[invType]
				custom = true
			end
		end

		if SpecBisTooltip:GetBisPool() == "RETAIL" then
			if content == nil then
				local _, sourceId = SpecBisTooltip:GetSpecItemTypRetail(itemId, specId, "BISO", invType)
				if sourceId == nil then
					_, sourceId = SpecBisTooltip:GetSpecItemTypRetail(itemId, specId, "BISR", invType)
					if sourceId == nil then _, sourceId = SpecBisTooltip:GetSpecItemTypRetail(itemId, specId, "BISM", invType) end
				end

				local sourceKind, sourceName, sourceLocation = SpecBisTooltip:GetSource(sourceId)
				return sourceKind, sourceName, sourceLocation, itemId, custom
			else
				local _, sourceId = SpecBisTooltip:GetSpecItemTypRetail(itemId, specId, content, invType)
				if sourceId then
					local sourceKind, sourceName, sourceLocation = SpecBisTooltip:GetSource(sourceId)
					return sourceKind, sourceName, sourceLocation, itemId, custom
				else
					return nil, nil, nil, itemId, custom
				end
			end
		else
			local _, sourceId = SpecBisTooltip:GetSpecItemTyp(itemId, specId, invType)
			local sourceKind, sourceName, sourceLocation = SpecBisTooltip:GetSource(sourceId)
			return sourceKind, sourceName, sourceLocation, itemId, custom
		end
	end
	return nil, nil, nil, nil, custom
end

function SpecBisTooltip:GetCatalystTarget(class, specId, content, rawItemId)
	if catalystRaw[class] == nil then return nil end
	if catalystRaw[class][specId] == nil then return nil end
	if catalystRaw[class][specId][content] == nil then return nil end
	local target = catalystRaw[class][specId][content][rawItemId]
	if target == nil then return nil end
	return target[1], target[2]
end

local head = "INVTYPE_HEAD"
local shoulder = "INVTYPE_SHOULDER"
local chest = "INVTYPE_CHEST"
local hand = "INVTYPE_HAND"
local legs = "INVTYPE_LEGS"
local token = {
	["RETAIL"] = {
		-- HUNTER, MAGE, DRUID
		[237582] = {
			["HUNTER"] = chest,
			["MAGE"] = chest,
			["DRUID"] = chest
		},
		[237594] = {
			["HUNTER"] = legs,
			["MAGE"] = legs,
			["DRUID"] = legs
		},
		[237586] = {
			["HUNTER"] = hand,
			["MAGE"] = hand,
			["DRUID"] = hand
		},
		[237598] = {
			["HUNTER"] = shoulder,
			["MAGE"] = shoulder,
			["DRUID"] = shoulder
		},
		[237590] = {
			["HUNTER"] = head,
			["MAGE"] = head,
			["DRUID"] = head
		},
		-- DEATHKNIGHT, WARLOCK, DEMONHUNTER
		[237581] = {
			["DEATHKNIGHT"] = chest,
			["WARLOCK"] = chest,
			["DEMONHUNTER"] = chest
		},
		[237593] = {
			["DEATHKNIGHT"] = legs,
			["WARLOCK"] = legs,
			["DEMONHUNTER"] = legs
		},
		[237585] = {
			["DEATHKNIGHT"] = hand,
			["WARLOCK"] = hand,
			["DEMONHUNTER"] = hand
		},
		[237597] = {
			["DEATHKNIGHT"] = shoulder,
			["WARLOCK"] = shoulder,
			["DEMONHUNTER"] = shoulder
		},
		[237589] = {
			["DEATHKNIGHT"] = head,
			["WARLOCK"] = head,
			["DEMONHUNTER"] = head
		},
		-- PALADIN, PRIEST, SHAMAN
		[237583] = {
			["PALADIN"] = chest,
			["PRIEST"] = chest,
			["SHAMAN"] = chest
		},
		[237595] = {
			["PALADIN"] = legs,
			["PRIEST"] = legs,
			["SHAMAN"] = legs
		},
		[237587] = {
			["PALADIN"] = hand,
			["PRIEST"] = hand,
			["SHAMAN"] = hand
		},
		[237599] = {
			["PALADIN"] = shoulder,
			["PRIEST"] = shoulder,
			["SHAMAN"] = shoulder
		},
		[237591] = {
			["PALADIN"] = head,
			["PRIEST"] = head,
			["SHAMAN"] = head
		},
		-- WARRIOR, ROGUE, MONK, EVOKER
		[237584] = {
			["WARRIOR"] = chest,
			["ROGUE"] = chest,
			["MONK"] = chest,
			["EVOKER"] = chest
		},
		[237596] = {
			["WARRIOR"] = legs,
			["ROGUE"] = legs,
			["MONK"] = legs,
			["EVOKER"] = legs
		},
		[237588] = {
			["WARRIOR"] = hand,
			["ROGUE"] = hand,
			["MONK"] = hand,
			["EVOKER"] = hand
		},
		[237600] = {
			["WARRIOR"] = shoulder,
			["ROGUE"] = shoulder,
			["MONK"] = shoulder,
			["EVOKER"] = shoulder
		},
		[237592] = {
			["WARRIOR"] = head,
			["ROGUE"] = head,
			["MONK"] = head,
			["EVOKER"] = head
		},
	},
	["MISTS"] = {
		-- HUNTER, MAGE, DRUID
		[0] = {
			["HUNTER"] = chest,
			["MAGE"] = chest,
			["DRUID"] = chest
		},
		[1] = {
			["HUNTER"] = legs,
			["MAGE"] = legs,
			["DRUID"] = legs
		},
		[2] = {
			["HUNTER"] = hand,
			["MAGE"] = hand,
			["DRUID"] = hand
		},
		[3] = {
			["HUNTER"] = shoulder,
			["MAGE"] = shoulder,
			["DRUID"] = shoulder
		},
		[4] = {
			["HUNTER"] = head,
			["MAGE"] = head,
			["DRUID"] = head
		},
		-- DEATHKNIGHT, WARLOCK, DEMONHUNTER
		[5] = {
			["DEATHKNIGHT"] = chest,
			["WARLOCK"] = chest,
			["DEMONHUNTER"] = chest
		},
		[6] = {
			["DEATHKNIGHT"] = legs,
			["WARLOCK"] = legs,
			["DEMONHUNTER"] = legs
		},
		[7] = {
			["DEATHKNIGHT"] = hand,
			["WARLOCK"] = hand,
			["DEMONHUNTER"] = hand
		},
		[8] = {
			["DEATHKNIGHT"] = shoulder,
			["WARLOCK"] = shoulder,
			["DEMONHUNTER"] = shoulder
		},
		[9] = {
			["DEATHKNIGHT"] = head,
			["WARLOCK"] = head,
			["DEMONHUNTER"] = head
		},
		-- PALADIN, PRIEST, SHAMAN
		[10] = {
			["PALADIN"] = chest,
			["PRIEST"] = chest,
			["SHAMAN"] = chest
		},
		[11] = {
			["PALADIN"] = legs,
			["PRIEST"] = legs,
			["SHAMAN"] = legs
		},
		[12] = {
			["PALADIN"] = hand,
			["PRIEST"] = hand,
			["SHAMAN"] = hand
		},
		[13] = {
			["PALADIN"] = shoulder,
			["PRIEST"] = shoulder,
			["SHAMAN"] = shoulder
		},
		[14] = {
			["PALADIN"] = head,
			["PRIEST"] = head,
			["SHAMAN"] = head
		},
		-- WARRIOR, ROGUE, MONK, EVOKER
		[15] = {
			["WARRIOR"] = chest,
			["ROGUE"] = chest,
			["MONK"] = chest,
			["EVOKER"] = chest
		},
		[16] = {
			["WARRIOR"] = legs,
			["ROGUE"] = legs,
			["MONK"] = legs,
			["EVOKER"] = legs
		},
		[17] = {
			["WARRIOR"] = hand,
			["ROGUE"] = hand,
			["MONK"] = hand,
			["EVOKER"] = hand
		},
		[18] = {
			["WARRIOR"] = shoulder,
			["ROGUE"] = shoulder,
			["MONK"] = shoulder,
			["EVOKER"] = shoulder
		},
		[19] = {
			["WARRIOR"] = head,
			["ROGUE"] = head,
			["MONK"] = head,
			["EVOKER"] = head
		},
	},
	["CLASSIC"] = {
		-- HUNTER, MAGE, DRUID
		[0] = {
			["HUNTER"] = chest,
			["MAGE"] = chest,
			["DRUID"] = chest
		},
		[1] = {
			["HUNTER"] = legs,
			["MAGE"] = legs,
			["DRUID"] = legs
		},
		[2] = {
			["HUNTER"] = hand,
			["MAGE"] = hand,
			["DRUID"] = hand
		},
		[3] = {
			["HUNTER"] = shoulder,
			["MAGE"] = shoulder,
			["DRUID"] = shoulder
		},
		[4] = {
			["HUNTER"] = head,
			["MAGE"] = head,
			["DRUID"] = head
		},
		-- DEATHKNIGHT, WARLOCK, DEMONHUNTER
		[5] = {
			["DEATHKNIGHT"] = chest,
			["WARLOCK"] = chest,
			["DEMONHUNTER"] = chest
		},
		[6] = {
			["DEATHKNIGHT"] = legs,
			["WARLOCK"] = legs,
			["DEMONHUNTER"] = legs
		},
		[7] = {
			["DEATHKNIGHT"] = hand,
			["WARLOCK"] = hand,
			["DEMONHUNTER"] = hand
		},
		[8] = {
			["DEATHKNIGHT"] = shoulder,
			["WARLOCK"] = shoulder,
			["DEMONHUNTER"] = shoulder
		},
		[9] = {
			["DEATHKNIGHT"] = head,
			["WARLOCK"] = head,
			["DEMONHUNTER"] = head
		},
		-- PALADIN, PRIEST, SHAMAN
		[10] = {
			["PALADIN"] = chest,
			["PRIEST"] = chest,
			["SHAMAN"] = chest
		},
		[11] = {
			["PALADIN"] = legs,
			["PRIEST"] = legs,
			["SHAMAN"] = legs
		},
		[12] = {
			["PALADIN"] = hand,
			["PRIEST"] = hand,
			["SHAMAN"] = hand
		},
		[13] = {
			["PALADIN"] = shoulder,
			["PRIEST"] = shoulder,
			["SHAMAN"] = shoulder
		},
		[14] = {
			["PALADIN"] = head,
			["PRIEST"] = head,
			["SHAMAN"] = head
		},
		-- WARRIOR, ROGUE, MONK, EVOKER
		[15] = {
			["WARRIOR"] = chest,
			["ROGUE"] = chest,
			["MONK"] = chest,
			["EVOKER"] = chest
		},
		[16] = {
			["WARRIOR"] = legs,
			["ROGUE"] = legs,
			["MONK"] = legs,
			["EVOKER"] = legs
		},
		[17] = {
			["WARRIOR"] = hand,
			["ROGUE"] = hand,
			["MONK"] = hand,
			["EVOKER"] = hand
		},
		[18] = {
			["WARRIOR"] = shoulder,
			["ROGUE"] = shoulder,
			["MONK"] = shoulder,
			["EVOKER"] = shoulder
		},
		[19] = {
			["WARRIOR"] = head,
			["ROGUE"] = head,
			["MONK"] = head,
			["EVOKER"] = head
		},
	}
}

function SpecBisTooltip:GetTokenTable()
	return token
end

function SpecBisTooltip:CheckIfSetItem(id)
	if id and select(16, SpecBisTooltip:GetItemInfo(id)) then return id end
	return nil
end

function SpecBisTooltip:GetSlotBis(class, specId, invType, typ)
	if SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class] == nil then return end
	if SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class][specId] == nil then return end
	if SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class][specId][typ] == nil then return end
	for id, tab in pairs(SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class][specId][typ]) do
		if tab[2] == invType then return id end
	end
end

function SpecBisTooltip:IsBisToken(class, specId, id)
	local invType = nil
	local pool = SpecBisTooltip:GetBisPool()
	local tab = SpecBisTooltip:GetTokenTable()
	if tab and tab[pool] and tab[pool][id] and tab[pool][id][class] then
		invType = tab[pool][id][class]
		local bisItem1 = SpecBisTooltip:CheckIfSetItem(SpecBisTooltip:GetSlotBis(class, specId, invType, "BISO"))
		local bisItem2 = SpecBisTooltip:CheckIfSetItem(SpecBisTooltip:GetSlotBis(class, specId, invType, "BISR"))
		local bisItem3 = SpecBisTooltip:CheckIfSetItem(SpecBisTooltip:GetSlotBis(class, specId, invType, "BISM"))
		if bisItem1 or bisItem2 or bisItem3 then
			return bisItem1, bisItem2, bisItem3
		else
			return id
		end
	end
	return nil
end
