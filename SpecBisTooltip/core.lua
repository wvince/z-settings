-- By D4KiR
local _, SpecBisTooltip = ...
local validEquipSlots = {"INVTYPE_HEAD", "INVTYPE_NECK", "INVTYPE_SHOULDER", "INVTYPE_CLOAK", "INVTYPE_ROBE", "INVTYPE_CHEST", "INVTYPE_WRIST", "INVTYPE_HAND", "INVTYPE_WAIST", "INVTYPE_LEGS", "INVTYPE_FEET", "INVTYPE_FINGER", "INVTYPE_TRINKET", "INVTYPE_WEAPON", "INVTYPE_2HWEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONOFFHAND", "INVTYPE_HOLDABLE", "INVTYPE_RANGED", "INVTYPE_RANGEDRIGHT", "INVTYPE_AMMO", "INVTYPE_THROWN", "INVTYPE_SHIELD", "INVTYPE_QUIVER", "INVTYPE_RELIC",}
local invalidEquipSlots = {}
invalidEquipSlots["INVTYPE_TABARD"] = true
invalidEquipSlots["INVTYPE_BODY"] = true
invalidEquipSlots["INVTYPE_BAG"] = true
invalidEquipSlots["INVTYPE_NON_EQUIP_IGNORE"] = true
function SpecBisTooltip:HoldModifierText()
	return SpecBisTooltip:Trans("LID_HOLDMODIFIER") .. " "
end

local once = true
local once2 = true
function SpecBisTooltip:GetItemTyp(class, specId, itemId, invType)
	if itemId == nil then return "NOTBIS", nil end
	local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, _, _, _, _, _ = SpecBisTooltip:GetItemInfo(itemId)
	if SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class] == nil then
		if once then
			once = false
			SpecBisTooltip:MSG("[GetItemTyp] Missing Class: " .. class .. " | WoW: " .. SpecBisTooltip:GetBisPool())
		end
		return
	end

	if SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class][specId] == nil then
		if once2 then
			once2 = false
			SpecBisTooltip:MSG("[GetItemTyp] Missing Spec for Class: " .. class .. " OR no spec selected" .. " | WoW: " .. SpecBisTooltip:GetBisPool())
		end
		return
	end

	if SBTTABPC and invType then
		if SBTTABPC[invType .. 1] then SBTTABPC[invType .. 1] = tonumber(SBTTABPC[invType .. 1]) end
		if SBTTABPC[invType .. 2] then SBTTABPC[invType .. 2] = tonumber(SBTTABPC[invType .. 2]) end
		if SBTTABPC[invType .. 1] and SBTTABPC[invType .. 1] == itemId or SBTTABPC[invType .. 2] and SBTTABPC[invType .. 2] == itemId then
			return "BIS", nil
		elseif SBTTABPC[invType] then
			SBTTABPC[invType] = tonumber(SBTTABPC[invType])
			if SBTTABPC[invType] == itemId then
				return "BIS", nil
			else
				return "NOTBIS", nil
			end
		end
	end

	if itemEquipLoc ~= nil and tContains(validEquipSlots, itemEquipLoc) and SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class][specId] and SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class][specId][itemId] then return SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class][specId][itemId][1], SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class][specId][itemId][2] end
	return "NOTBIS", nil
end

local function IsCatalystSource(sourceId)
	return type(sourceId) == "string" and string.find(sourceId, "catalyst", 1, true) == 1
end

local function GetCatalystSourceId(class, specId, itemId, content)
	if not SpecBisTooltip:GV(SBTTAB, "SHOWCATALYST", true) then return nil end
	local tierItemId = SpecBisTooltip:GetCatalystTarget(class, specId, content, itemId)
	if tierItemId == nil then return nil end
	return "catalyst;into=" .. tierItemId
end

function SpecBisTooltip:GetItemTypRetail(class, specId, itemId, content, invType)
	if itemId == nil then return "NOTBIS", nil, nil end
	local name, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, _, _, _, _, _ = SpecBisTooltip:GetItemInfo(itemId)
	if name == nil then return end
	local classData = SpecBisTooltip:GetBisTable()[SpecBisTooltip:GetBisPool()][class]
	if classData == nil then
		if once then
			once = false
			SpecBisTooltip:MSG("Missing Class: " .. class .. " | WoW: " .. SpecBisTooltip:GetBisPool())
		end
		return
	end

	local specData = classData[specId]
	if specData == nil then
		if once2 then
			once2 = false
			SpecBisTooltip:MSG("[GetItemTypRetail] Missing Spec for Class: " .. class .. " OR no spec selected")
		end
		return
	end

	if SBTTABPC and invType then
		if SBTTABPC[invType .. 1] then SBTTABPC[invType .. 1] = tonumber(SBTTABPC[invType .. 1]) end
		if SBTTABPC[invType .. 2] then SBTTABPC[invType .. 2] = tonumber(SBTTABPC[invType .. 2]) end
		if SBTTABPC[invType .. 1] and SBTTABPC[invType .. 1] == itemId or SBTTABPC[invType .. 2] and SBTTABPC[invType .. 2] == itemId then
			return content, nil
		elseif SBTTABPC[invType] then
			SBTTABPC[invType] = tonumber(SBTTABPC[invType])
			if SBTTABPC[invType] == itemId then
				return content, nil
			else
				return "NOTBIS", nil
			end
		end
	end

	if itemEquipLoc ~= nil and tContains(validEquipSlots, itemEquipLoc) then
		local contentData = specData[content]
		local heroSpecId = SpecBisTooltip:GetHeroSpecId()
		if heroSpecId and contentData and contentData[heroSpecId] and contentData[heroSpecId][itemId] then
			return content, contentData[heroSpecId][itemId][1]
		elseif contentData and contentData[itemId] then
			return content, contentData[itemId][1], contentData[itemId][2]
		end

		local catalystSourceId = GetCatalystSourceId(class, specId, itemId, content)
		if catalystSourceId then return content, catalystSourceId end
	end
	return "NOTBIS", nil, nil
end

function SpecBisTooltip:GetSpecItemTyp(itemId, specId, invType)
	local _, engClass = UnitClass("PLAYER")
	if engClass and specId then return SpecBisTooltip:GetItemTyp(engClass, specId, itemId, invType) end
	return nil, nil, nil
end

function SpecBisTooltip:GetSpecItemTypRetail(itemId, specId, content, invType)
	local _, engClass = UnitClass("PLAYER")
	if engClass and specId then return SpecBisTooltip:GetItemTypRetail(engClass, specId, itemId, content, invType) end
	return nil, nil, nil
end

function SpecBisTooltip:GetSpecItemTypTrinketRetail(itemId, specId)
	local _, engClass = UnitClass("PLAYER")
	if engClass and specId then return SpecBisTooltip:GetItemTypRetail(engClass, specId, itemId, "TRINKETS", "INVTYPE_TRINKET") end
	return nil, nil, nil
end

local col_green = "|cff90ee90"
local col_orange = "|cffbf9000"
local col_yellow = "|cffffff4b"
local col_red = "|cffff4b47"
local bisTextLookup = {
	["NOTBIS"] = {
		colorCode = col_red,
		translationArgs = {"LID_NOTBIS"}
	},
	["BIS"] = {
		colorCode = col_green,
		translationArgs = {"LID_BIS"}
	},
	["BISO"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISO"}
	},
	["BISMR"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISMR"}
	},
	["BISM"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISM"}
	},
	["BISR"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISR"}
	},
	["BIS,PVE"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVE"}
	},
	["BIS,PREPATCH"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPREPATCH"}
	},
	["BIS,PVE,P1"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVEPHASEX", nil, 1}
	},
	["BIS,PVE,P2"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVEPHASEX", nil, 2}
	},
	["BIS,PVE,P3"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVEPHASEX", nil, 3}
	},
	["BIS,PVE,P4"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVEPHASEX", nil, 4}
	},
	["BIS,PVE,P5"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVEPHASEX", nil, 5}
	},
	["BIS,PVE,P6"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVEPHASEX", nil, 6}
	},
	["BIS,PVE,SODP1"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVESODX", nil, 1}
	},
	["BIS,PVE,SODP2"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVESODX", nil, 2}
	},
	["BIS,PVE,SODP3"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVESODX", nil, 3}
	},
	["BIS,PVE,SODP4"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVESODX", nil, 4}
	},
	["BIS,PVE,SODP5"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVESODX", nil, 5}
	},
	["BIS,PVE,SODP6"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVESODX", nil, 6}
	},
	["BIS,PVE,SODP7"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVESODX", nil, 7}
	},
	["BIS,PVE,SODP8"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVESODX", nil, 8}
	},
	["BIS,PVP"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISPVP"}
	},
	["S+"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISTRINKETX", nil, "S+"}
	},
	["S"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISTRINKETX", nil, "S"}
	},
	["S-"] = {
		colorCode = col_green,
		translationArgs = {"LID_BISTRINKETX", nil, "S-"}
	},
	["A+"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_BISTRINKETX", nil, "A+"}
	},
	["A"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_BISTRINKETX", nil, "A"}
	},
	["A-"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_BISTRINKETX", nil, "A-"}
	},
	["B+"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_BISTRINKETX", nil, "B+"}
	},
	["B"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_BISTRINKETX", nil, "B"}
	},
	["B-"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_BISTRINKETX", nil, "B-"}
	},
	["C+"] = {
		colorCode = col_orange,
		translationArgs = {"LID_BISTRINKETX", nil, "C+"}
	},
	["C"] = {
		colorCode = col_orange,
		translationArgs = {"LID_BISTRINKETX", nil, "C"}
	},
	["C-"] = {
		colorCode = col_orange,
		translationArgs = {"LID_BISTRINKETX", nil, "C-"}
	},
	["D+"] = {
		colorCode = col_orange,
		translationArgs = {"LID_BISTRINKETX", nil, "D+"}
	},
	["D"] = {
		colorCode = col_orange,
		translationArgs = {"LID_BISTRINKETX", nil, "D"}
	},
	["D-"] = {
		colorCode = col_orange,
		translationArgs = {"LID_BISTRINKETX", nil, "D-"}
	},
	["E+"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "E+"}
	},
	["E"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "E"}
	},
	["E-"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "E-"}
	},
	["F+"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "F+"}
	},
	["F"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "F"}
	},
	["F-"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "F-"}
	},
	["G+"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "G+"}
	},
	["G"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "G"}
	},
	["G-"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "G-"}
	},
	["No"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "No"}
	},
	["PREBIS,PVE"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVE"}
	},
	["PREBIS,PVE,P1"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVEPHASEX", nil, 1}
	},
	["PREBIS,PVE,P2"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVEPHASEX", nil, 2}
	},
	["PREBIS,PVE,P3"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVEPHASEX", nil, 3}
	},
	["PREBIS,PVE,P4"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVEPHASEX", nil, 4}
	},
	["PREBIS,PVE,P5"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVEPHASEX", nil, 5}
	},
	["PREBIS,PVE,P6"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVEPHASEX", nil, 6}
	},
	["PREBIS,PVE,SODP1"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVESODX", nil, 1}
	},
	["PREBIS,PVE,SODP2"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVESODX", nil, 2}
	},
	["PREBIS,PVE,SODP3"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVESODX", nil, 3}
	},
	["PREBIS,PVE,SODP4"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVESODX", nil, 4}
	},
	["PREBIS,PVE,SODP5"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVESODX", nil, 5}
	},
	["PREBIS,PVE,SODP6"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVESODX", nil, 6}
	},
	["PREBIS,PVE,SODP7"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVESODX", nil, 7}
	},
	["PREBIS,PVE,SODP8"] = {
		colorCode = col_yellow,
		translationArgs = {"LID_PREBISPVESODX", nil, 8}
	},
	["?"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "?"}
	},
	["??????"] = {
		colorCode = col_red,
		translationArgs = {"LID_BISTRINKETX", nil, "?????"}
	},
	["TRINKETS"] = {
		colorCode = col_red,
		translationArgs = {"LID_"}
	}
}

local oldPhases = {}
if SpecBisTooltip:GetBisPool() == "CLASSIC" then
	oldPhases["BIS,PVE,SODP4"] = true
	oldPhases["PREBIS,PVE,SODP4"] = true
	oldPhases["BIS,PVE,SODP3"] = true
	oldPhases["PREBIS,PVE,SODP3"] = true
	oldPhases["BIS,PVE,SODP2"] = true
	oldPhases["PREBIS,PVE,SODP2"] = true
	oldPhases["BIS,PVE,SODP1"] = true
	oldPhases["PREBIS,PVE,SODP1"] = true
elseif SpecBisTooltip:GetBisPool() == "WRATH" then
	oldPhases["BIS,PVE,P1"] = true
	oldPhases["BIS,PVE,P2"] = true
	oldPhases["BIS,PVE,P3"] = true
end

local missingTypes = {}
local function GetBISText(typ)
	if not SpecBisTooltip:GV(SBTTAB, "SHOWPREBIS", true) and string.find(typ, "PRE", 1, true) then typ = "NOTBIS" end
	if not SpecBisTooltip:GV(SBTTAB, "SHOWOLDERPHASES", true) and oldPhases[typ] then typ = "NOTBIS" end
	local entry = bisTextLookup[typ]
	if typ == "NOTBIS" and not SpecBisTooltip:GV(SBTTAB, "SHOWNOTBIS", true) then return "" end
	if entry then
		local colorCode = entry.colorCode
		local text = SpecBisTooltip:Trans(unpack(entry.translationArgs))
		return colorCode .. text
	else
		if missingTypes[tostring(typ)] == nil then
			missingTypes[tostring(typ)] = true
			SpecBisTooltip:MSG("Missing Type in GetBISText:", "[" .. tostring(typ) .. "]", "Level:", UnitLevel("player"))
		end
		return ""
	end
end

local function AddToTooltipRetail(tooltip, id, specId, icon, content, invType)
	if id == nil then return end
	local bisTyp, sourceId = SpecBisTooltip:GetSpecItemTypRetail(id, specId, content, invType)
	if bisTyp == nil then return end
	return bisTyp, sourceId
end

local function AddToTooltipTrinketRetail(tooltip, id, specId, icon)
	if id == nil then return end
	local typ, _, tier = SpecBisTooltip:GetSpecItemTypTrinketRetail(id, specId)
	if tier == nil then return end
	local iconText = ""
	if icon then iconText = "|T" .. icon .. ":20:20:0:0|t" end
	local bisText = GetBISText(tier)
	if bisText ~= "" then
		if bisText ~= "BLOCKED" then
			if typ == "NOTBIS" then
				return false
			else
				tooltip:AddDoubleLine(iconText .. " " .. bisText, "|T136031:20:20:0:0|t")
			end
		end
		return true
	else
		local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, _, _, _, _, _ = SpecBisTooltip:GetItemInfo(id)
		if itemEquipLoc and itemEquipLoc ~= "" and not tContains(validEquipSlots, itemEquipLoc) and invalidEquipSlots[itemEquipLoc] == nil then tooltip:AddDoubleLine("BIS: ERROR? " .. specId .. " " .. tostring(itemEquipLoc), "|T136031:20:20:0:0|t") end
	end
	return false
end

local function AddToTooltip(tooltip, id, specId, icon, invType, num)
	local n = num or 1
	local _, class = UnitClass("PLAYER")
	if id == nil then return end
	local typ, _ = SpecBisTooltip:GetSpecItemTyp(id, specId, invType)
	if typ == nil then return end
	local iconText = ""
	if icon then iconText = "|T" .. icon .. ":20:20:0:0|t" end
	local bisText = GetBISText(typ)
	if bisText ~= "" then
		if bisText ~= "BLOCKED" then
			if typ == "NOTBIS" then
				if invType then
					local _, _, _, itemId, custom = SpecBisTooltip:GetBisSource(invType, class, specId, n)
					if custom and itemId then
						local source = SBTTABPC[invType .. "_SOURCE"]
						if n then source = SBTTABPC[invType .. n .. "_SOURCE"] end
						if source and source ~= "" then
							tooltip:AddDoubleLine(iconText .. " [C] " .. bisText .. ": " .. itemId, format(SpecBisTooltip:Trans("LID_yourbissource"), source) .. " |T136031:20:20:0:0|t")
						else
							tooltip:AddDoubleLine(iconText .. " [C] " .. bisText .. ": " .. itemId, "|T136031:20:20:0:0|t")
						end
					else
						tooltip:AddDoubleLine(iconText .. " " .. bisText, "|T136031:20:20:0:0|t")
					end
				end
			else
				tooltip:AddDoubleLine(iconText .. " " .. bisText, "|T136031:20:20:0:0|t")
			end
		end
	else
		local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, _, _, _, _, _ = SpecBisTooltip:GetItemInfo(id)
		if itemEquipLoc and itemEquipLoc ~= "" and not tContains(validEquipSlots, itemEquipLoc) and invalidEquipSlots[itemEquipLoc] == nil then tooltip:AddDoubleLine("BIS: ERROR? " .. specId .. " " .. tostring(itemEquipLoc), "|T136031:20:20:0:0|t") end
	end
end

local function AddBisTooltip(tooltip, otherClasses, bisText, oldBisText, specIcon, leftText)
	if bisText ~= "" and bisText ~= "BLOCKED" then
		if otherClasses then
			tooltip:AddDoubleLine(format("%s %s", leftText, oldBisText), "|T136031:20:20:0:0|t")
		else
			tooltip:AddDoubleLine(format("|T%s:20:20:0:0|t %s", specIcon, oldBisText), "|T136031:20:20:0:0|t")
		end
	end
end

local function AddBisTooltipRetail(tooltip, otherClasses, bisText, oldBisText, specIcon, leftText)
	if bisText ~= "" and bisText ~= "BLOCKED" then tooltip:AddDoubleLine(leftText .. " " .. oldBisText, "|T136031:20:20:0:0|t") end
end

local function FitForSpec(specId, yourSpecId, otherClasses, className, ownClassName)
	if otherClasses then return className ~= ownClassName end
	return specId ~= yourSpecId and className == ownClassName
end

local function AddBisForSpec(tooltip, itemId, yourSpecId, otherClasses)
	local _, ownClassName = UnitClass("player")
	local bfs = SpecBisTooltip:GetBFS(itemId)
	local num = 0
	if bfs == nil then
		if otherClasses then
			tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_NOOTHERCLASSNEEDSTHIS"), "|T136031:20:20:0:0|t")
		else
			tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_NOOTHERSPECNEEDSTHIS"), "|T136031:20:20:0:0|t")
		end
		return
	end

	local oldBisText = nil
	local leftText = ""
	local max = 0
	local lastTab = ""
	for i, tab in pairs(bfs) do
		local className = tab[1]
		local specId = tab[2]
		if FitForSpec(specId, yourSpecId, otherClasses, className, ownClassName) then
			max = max + 1
			lastTab = tab
		end
	end

	local index = 0
	local maxRow = 12
	if not SpecBisTooltip:GV(SBTTAB, "SMALLERTOOLTIP", false) or IsControlKeyDown() then maxRow = 24 end
	for i, tab in pairs(bfs) do
		local className = tab[1]
		local specId = tab[2]
		if FitForSpec(specId, yourSpecId, otherClasses, className, ownClassName) then
			if num == 0 then
				if otherClasses then
					tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_OTHERCLASSES") .. ":", "|T136031:20:20:0:0|t")
				else
					tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_OTHERSPECS") .. ":", "|T136031:20:20:0:0|t")
				end
			end

			local specIcon = SpecBisTooltip:GetSpecIcon(className, specId)
			if tab[3][1] then
				local bisText = GetBISText(tab[3][1])
				if oldBisText == nil then oldBisText = bisText end
				if otherClasses == false then
					AddBisTooltip(tooltip, otherClasses, bisText, bisText, specIcon, leftText)
					leftText = ""
				elseif bisText ~= oldBisText and leftText ~= "" then
					AddBisTooltip(tooltip, otherClasses, oldBisText, oldBisText, specIcon, leftText)
					leftText = ""
					index = 0
				end

				oldBisText = bisText
				index = index + 1
				leftText = leftText .. format("|T%s:20:20:0:0|t", specIcon) --.. specId
				if otherClasses and tab == lastTab then
					AddBisTooltip(tooltip, otherClasses, bisText, oldBisText, specIcon, leftText)
				elseif otherClasses and index == maxRow then
					AddBisTooltip(tooltip, otherClasses, bisText, oldBisText, specIcon, leftText)
					leftText = ""
					index = 0
				end
			end

			num = num + 1
		end
	end

	if num == 0 then
		if otherClasses then
			tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_NOOTHERCLASSNEEDSTHIS"), "|T136031:20:20:0:0|t")
		else
			tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_NOOTHERSPECNEEDSTHIS"), "|T136031:20:20:0:0|t")
		end
	end
end

local function AddBisForSpecRetail(tooltip, itemId, yourSpecId, otherClasses, content, first)
	if first == nil then first = false end
	local _, ownClassName = UnitClass("player")
	local bfs = SpecBisTooltip:GetBFSRetail(itemId, content)
	local num = 0
	if bfs == nil then return false end
	local oldBisText = nil
	local leftText = ""
	local max = 0
	local lastTab = ""
	for i, tab in pairs(bfs) do
		local className = tab[1]
		local specId = tab[2]
		if FitForSpec(specId, yourSpecId, otherClasses, className, ownClassName) then
			max = max + 1
			lastTab = tab
		end
	end

	local index = 0
	local maxRow = 12
	if not SpecBisTooltip:GV(SBTTAB, "SMALLERTOOLTIP", false) or IsControlKeyDown() then maxRow = 24 end
	for i, tab in pairs(bfs) do
		local className = tab[1]
		local specId = tab[2]
		if FitForSpec(specId, yourSpecId, otherClasses, className, ownClassName) then
			index = index + 1
			if first and num == 0 and max > 0 then
				if otherClasses then
					tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_OTHERCLASSES") .. ":", "|T136031:20:20:0:0|t")
				else
					tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_OTHERSPECS") .. ":", "|T136031:20:20:0:0|t")
				end
			end

			local specIcon = SpecBisTooltip:GetSpecIcon(className, specId)
			local bisText = GetBISText(content)
			if content == "TRINKETS" and tab[3] and tab[3][2] then bisText = GetBISText(tab[3][2]) end
			if oldBisText == nil then oldBisText = bisText end
			if bisText ~= oldBisText and leftText ~= "" then
				AddBisTooltipRetail(tooltip, otherClasses, oldBisText, oldBisText, specIcon, leftText)
				leftText = ""
				index = 1
			end

			oldBisText = bisText
			leftText = leftText .. format("|T%s:20:20:0:0|t", specIcon) --.. specId
			if max > 0 and tab == lastTab then
				AddBisTooltipRetail(tooltip, otherClasses, bisText, oldBisText, specIcon, leftText)
			elseif index == maxRow then
				AddBisTooltipRetail(tooltip, otherClasses, bisText, oldBisText, specIcon, leftText)
				leftText = ""
				index = 0
			end

			num = num + 1
		end
	end
	return max > 0
end

local specNotFoundOnce = true
local specIconNotFoundOnce = true
local function GetPrefferredText()
	if SpecBisTooltip:GetBisPool() == "RETAIL" then return " (" .. SpecBisTooltip:Trans("LID_" .. SpecBisTooltip:GV(SBTTAB, "PREFERREDCONTENT", "BISO")) .. ")" end
	return ""
end

local function GetCatalystSourceText(sourceName, sourceLocation)
	local catalystText = SpecBisTooltip:Trans("LID_catalyst")
	if not SpecBisTooltip:GV(SBTTAB, "SHOWCATALYST", true) then return catalystText end
	if sourceName == nil or sourceName == "" then return catalystText end
	if sourceLocation and sourceLocation ~= "" then return format(SpecBisTooltip:Trans("LID_CATALYSTFROM"), sourceName) .. " (" .. sourceLocation .. ")" end
	return format(SpecBisTooltip:Trans("LID_CATALYSTFROM"), sourceName)
end

local function HasCatalystDetail(sourceName)
	if not SpecBisTooltip:GV(SBTTAB, "SHOWCATALYST", true) then return false end
	return sourceName ~= nil and sourceName ~= ""
end

function SpecBisTooltip:AddBisText(tooltip, specId, itemId, icon, bisTyp, sourceId)
	local iconText = ""
	if icon then iconText = "|T" .. icon .. ":20:20:0:0|t" end
	local bisText = GetBISText(bisTyp)
	if bisText == "" then
		local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, _, _, _, _, _, _ = SpecBisTooltip:GetItemInfo(itemId)
		if itemEquipLoc and itemEquipLoc ~= "" and not tContains(validEquipSlots, itemEquipLoc) and invalidEquipSlots[itemEquipLoc] == nil then tooltip:AddDoubleLine("BIS: ERROR? " .. specId .. " " .. tostring(itemEquipLoc), "|T136031:20:20:0:0|t") end
		return false
	end

	if bisText == "BLOCKED" then return false end
	if bisTyp == "NOTBIS" then return false end
	local sourceKind, sourceName = SpecBisTooltip:GetSource(sourceId)
	if sourceKind == "catalystinto" and sourceName then
		tooltip:AddDoubleLine(iconText .. " " .. bisText .. " " .. format(SpecBisTooltip:Trans("LID_CATALYSTINTO"), sourceName), "|T136031:20:20:0:0|t")
		return true
	end

	tooltip:AddDoubleLine(iconText .. " " .. bisText, "|T136031:20:20:0:0|t")
	return true
end

local function OnTooltipSetItem(tooltip, data)
	local _, class = UnitClass("PLAYER")
	local id = nil
	local isToken = false
	if data and data.id then
		id = data.id
	elseif tooltip.GetItem then
		local _, link = tooltip:GetItem()
		if link then id = tonumber(strmatch(link, "item:(%d+):")) end
	end

	if id == nil then return end
	local invType = select(9, SpecBisTooltip:GetItemInfo(id))
	if invType == nil then return end
	if invType == "" then return end
	local specId, icon = SpecBisTooltip:GetTalentInfo()
	if SpecBisTooltip.DEBUG then tooltip:AddDoubleLine("SpecBisTooltip  ItemId: " .. id) end
	if invalidEquipSlots[invType] then
		local id1, id2, id3 = SpecBisTooltip:IsBisToken(class, specId, id)
		if id1 == nil and id2 == nil and id3 == nil then return end
		id = id1 or id2 or id3
		isToken = true
	end

	local n = 1
	if invType == "INVTYPE_TRINKET" then
		local trinket2 = GetInventoryItemID("player", getglobal("INVSLOT_TRINKET2"))
		if trinket2 == id then n = 2 end
	end

	if invType == "INVTYPE_FINGER" then
		local ring2 = GetInventoryItemID("player", getglobal("INVSLOT_FINGER2"))
		if ring2 == id then n = 2 end
	end

	if invType == "INVTYPE_WEAPON" or invType == "INVTYPE_2HWEAPON" or invType == "INVTYPE_WEAPONMAINHAND" or invType == "INVTYPE_WEAPONOFFHAND" or invType == "INVTYPE_HOLDABLE" then
		local weapon2 = GetInventoryItemID("player", getglobal("INVSLOT_OFFHAND"))
		if weapon2 == id then n = 2 end
	end

	if specId then
		if icon then
			local sourceKind, sourceName, sourceLocation, itemId, custom = SpecBisTooltip:GetBisSource(invType, class, specId, SpecBisTooltip:GV(SBTTAB, "PREFERREDCONTENT", "BISO"), n)
			if sourceKind and sourceKind ~= "" and (sourceLocation ~= nil or sourceKind == "catalyst") then
				if not SpecBisTooltip:GV(SBTTAB, "SMALLERTOOLTIP", false) or IsControlKeyDown() then
					if sourceKind == "catalyst" then
						tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. GetPrefferredText() .. ":", SpecBisTooltip:Trans("LID_SOURCE") .. ": " .. GetCatalystSourceText(sourceName, sourceLocation) .. " |T136031:20:20:0:0|t")
					else
						if sourceLocation and sourceLocation ~= "" then
							tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. GetPrefferredText() .. ":", SpecBisTooltip:Trans("LID_SOURCE") .. ": " .. sourceName .. " (" .. sourceLocation .. ")[" .. SpecBisTooltip:Trans("LID_" .. sourceKind) .. "] |T136031:20:20:0:0|t")
						else
							tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. GetPrefferredText() .. ":", SpecBisTooltip:Trans("LID_SOURCE") .. ": " .. sourceName .. " [" .. SpecBisTooltip:Trans("LID_" .. sourceKind) .. "] |T136031:20:20:0:0|t")
						end
					end
				else
					if sourceKind == "catalyst" then
						if HasCatalystDetail(sourceName) then
							tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. GetPrefferredText() .. ":", SpecBisTooltip:HoldModifierText() .. " |T136031:20:20:0:0|t")
						else
							tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. GetPrefferredText() .. ":", "|T136031:20:20:0:0|t")
						end
					else
						if sourceLocation and sourceLocation ~= "" then
							tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. GetPrefferredText() .. ":", SpecBisTooltip:HoldModifierText() .. " |T136031:20:20:0:0|t")
						else
							tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. GetPrefferredText() .. ":", "|T136031:20:20:0:0|t")
						end
					end
				end
			else
				if itemId then
					if custom then
						local source = SBTTABPC[invType .. "_SOURCE"]
						if n then source = SBTTABPC[invType .. n .. "_SOURCE"] end
						if source and source ~= "" then
							tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. " [C]: " .. itemId, format(SpecBisTooltip:Trans("LID_yourbissource"), source) .. " |T136031:20:20:0:0|t")
						else
							tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. " [C]: " .. itemId, "|T136031:20:20:0:0|t")
						end
					else
						tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC") .. ": " .. itemId, "|T136031:20:20:0:0|t")
					end
				else
					tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_YOURSPEC"), "|T136031:20:20:0:0|t")
				end
			end

			if SpecBisTooltip:GetBisPool() == "RETAIL" then
				local bisTyp1, sourceId1 = AddToTooltipRetail(tooltip, id, specId, icon, "BISO", invType)
				local bisTyp2, sourceId2 = AddToTooltipRetail(tooltip, id, specId, icon, "BISR", invType)
				local bisTyp3, sourceId3 = AddToTooltipRetail(tooltip, id, specId, icon, "BISM", invType)
				local collapse = bisTyp1 == "BISO" and bisTyp2 == "BISR" and bisTyp3 == "BISM"
				if collapse and (IsCatalystSource(sourceId1) or IsCatalystSource(sourceId2) or IsCatalystSource(sourceId3)) then collapse = sourceId1 == sourceId2 and sourceId1 == sourceId3 end
				if collapse then
					SpecBisTooltip:AddBisText(tooltip, specId, id, icon, "BIS", sourceId1)
				else
					SpecBisTooltip:AddBisText(tooltip, specId, id, icon, bisTyp1, sourceId1)
					SpecBisTooltip:AddBisText(tooltip, specId, id, icon, bisTyp2, sourceId2)
					SpecBisTooltip:AddBisText(tooltip, specId, id, icon, bisTyp3, sourceId3)
				end

				if bisTyp1 == "NOTBIS" and bisTyp2 == "NOTBIS" and bisTyp3 == "NOTBIS" and GetBISText("NOTBIS") then
					if invType == "INVTYPE_TRINKET" then
						AddToTooltipTrinketRetail(tooltip, id, specId, icon)
					else
						tooltip:AddDoubleLine("|T" .. icon .. ":20:20:0:0|t" .. " " .. GetBISText("NOTBIS"), "|T136031:20:20:0:0|t")
					end
				end

				if SpecBisTooltip:GV(SBTTAB, "SHOWOTHERSPECS", true) then
					local first = true
					if AddBisForSpecRetail(tooltip, id, specId, false, "BISO", first) then first = false end
					if AddBisForSpecRetail(tooltip, id, specId, false, "BISR", first) then first = false end
					if AddBisForSpecRetail(tooltip, id, specId, false, "BISM", first) then first = false end
					if invType == "INVTYPE_TRINKET" and AddBisForSpecRetail(tooltip, id, specId, false, "TRINKETS", first) then first = false end
					if first then tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_NOOTHERSPECNEEDSTHIS"), "|T136031:20:20:0:0|t") end
				end

				if SpecBisTooltip:GV(SBTTAB, "SHOWOTHERCLASSES", false) then
					if isToken then
						tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_OTHERCLASSESMAYALSO"), "|T136031:20:20:0:0|t")
					else
						local first = true
						if AddBisForSpecRetail(tooltip, id, specId, true, "BISO", first) then first = false end
						if AddBisForSpecRetail(tooltip, id, specId, true, "BISR", first) then first = false end
						if AddBisForSpecRetail(tooltip, id, specId, true, "BISM", first) then first = false end
						if invType == "INVTYPE_TRINKET" and AddBisForSpecRetail(tooltip, id, specId, true, "TRINKETS", first) then first = false end
						if first then tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_NOOTHERCLASSNEEDSTHIS"), "|T136031:20:20:0:0|t") end
					end
				end
			else
				AddToTooltip(tooltip, id, specId, icon, invType)
				if SpecBisTooltip:GV(SBTTAB, "SHOWOTHERSPECS", true) then AddBisForSpec(tooltip, id, specId, false) end
				if SpecBisTooltip:GV(SBTTAB, "SHOWOTHERCLASSES", false) then
					if isToken then
						tooltip:AddDoubleLine(SpecBisTooltip:Trans("LID_OTHERCLASSESMAYALSO"), "|T136031:20:20:0:0|t")
					else
						AddBisForSpec(tooltip, id, specId, true)
					end
				end
			end
		elseif specIconNotFoundOnce then
			specIconNotFoundOnce = false
			SpecBisTooltip:MSG("Icon for Spec not found")
			SpecBisTooltip:After(10, function() specIconNotFoundOnce = true end, "spec not found 1")
		end
	else
		local lvl = UnitLevel("PLAYER")
		if lvl and lvl < 10 and specNotFoundOnce then
			specNotFoundOnce = false
			SpecBisTooltip:After(10, function() specNotFoundOnce = true end, "spec not found 2")
		elseif specNotFoundOnce then
			specNotFoundOnce = false
			SpecBisTooltip:MSG("Spec not found")
			SpecBisTooltip:After(10, function() specNotFoundOnce = true end, "spec not found 3")
		end
	end
end

local SBTSetup = CreateFrame("FRAME", "SBTSetup")
SpecBisTooltip:RegisterEvent(SBTSetup, "PLAYER_LOGIN")
SBTSetup:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		SBTTAB = SBTTAB or {}
		SBTTABPC = SBTTABPC or {}
		SpecBisTooltip:SetDbTab(SBTTAB)
		SpecBisTooltip:SetVersion(136031, "1.0.12")
		SpecBisTooltip:AddSlash("sbt", SpecBisTooltip.ToggleSettings)
		SpecBisTooltip:AddSlash("specbistooltip", SpecBisTooltip.ToggleSettings)
		local mmbtn = nil
		SpecBisTooltip:CreateMinimapButton({
			["name"] = "SpecBisTooltip",
			["icon"] = 136031,
			["var"] = mmbtn,
			["dbtab"] = SBTTAB,
			["vTT"] = {{"|T136031:16:16:0:0|t SpecBisTooltip", "v" .. SpecBisTooltip:GetVersion()}, {SpecBisTooltip:Trans("LID_LEFTCLICK"), SpecBisTooltip:Trans("LID_OPENSETTINGS")}, {SpecBisTooltip:Trans("LID_RIGHTCLICK"), SpecBisTooltip:Trans("LID_HIDEMINIMAPBUTTON")}},
			["funcL"] = function() SpecBisTooltip:ToggleSettings() end,
			["funcR"] = function()
				SpecBisTooltip:SV(SBTTAB, "SHOWMINIMAPBUTTON", false)
				SpecBisTooltip:HideMMBtn("SpecBisTooltip")
				SpecBisTooltip:MSG("Minimap Button is now hidden.")
			end,
			["dbkey"] = "SHOWMINIMAPBUTTON"
		})

		SpecBisTooltip:After(1, function()
			if ItemRefTooltip and GameTooltip and ItemRefTooltip:HasScript("OnTooltipSetItem") and GameTooltip:HasScript("OnTooltipSetItem") then
				ItemRefTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...) OnTooltipSetItem(tooltip, ...) end)
				GameTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...) OnTooltipSetItem(tooltip, ...) end)
			elseif TooltipDataProcessor then
				TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
			end
		end, "Delay1")

		SpecBisTooltip:After(2, function() SpecBisTooltip:InitSettings() end, "InitSettings")
	end
end)
