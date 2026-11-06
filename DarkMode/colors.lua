local _, DarkMode = ...
local DMColorModeValues = {
	["Dimmed"] = {0.5, 0.5, 0.5, 1},
	["Dark"] = {0.360, 0.360, 0.360, 1},
	["More Dark"] = {0.200, 0.200, 0.200, 1},
	["Darker"] = {0.140, 0.140, 0.140, 1},
	["More Darker"] = {0.080, 0.080, 0.080, 1},
	["Black"] = {0.000, 0.000, 0.000, 1},
	["Default"] = {1, 1, 1, 1},
}

function DarkMode:GetColor(id, name)
	local colorMode = DarkMode:GetColorModes()[id]
	local value = DMColorModeValues[colorMode]
	if value then
		return value[1], value[2], value[3], value[4]
	elseif colorMode == "ClassColor" then
		local _, PlayerClassEng, _ = UnitClass("PLAYER")
		local r, g, b, _ = DarkMode:GetClassColor(PlayerClassEng)
		return r, g, b, 1
	elseif colorMode == "Off" then
		return nil, nil, nil, nil
	elseif colorMode == "Custom" then
		return DarkMode:GetCustomColor(name)
	end

	DarkMode:INFO("[GetColor] Missing colorMode", colorMode)
	return 1.000, 0.000, 0.000, 0.3
end

function DarkMode:GetCustomColor(name)
	if name == nil then return 1, 1, 1, 0.5 end
	local r = DMTAB[name .. "_r"]
	local g = DMTAB[name .. "_g"]
	local b = DMTAB[name .. "_b"]
	local a = DMTAB[name .. "_a"]
	if r and g and b and a then
		return r, g, b, a
	else
		return 1, 1, 1, 0.5
	end
end

function DarkMode:SetCustomColor(name, r, g, b, a)
	DMTAB[name .. "_r"] = r
	DMTAB[name .. "_g"] = g
	DMTAB[name .. "_b"] = b
	DMTAB[name .. "_a"] = a
	DarkMode:InvalidateColorCache()
	DarkMode:UpdateColors()
end

function DarkMode:GetBrighterColor(r, g, b, a, texture)
	if r == nil or g == nil or b == nil then return r, g, b, a end
	local name = DarkMode:GetName(texture)
	if name and DarkMode:IsBrighterFrame(name) then return DarkMode:MClamp(r + 0.4, 0, 1), DarkMode:MClamp(g + 0.4, 0, 1), DarkMode:MClamp(b + 0.4, 0, 1), a end
	return r, g, b, a
end

local DMColorTypeList = {}
local DMColorTypes = {}
local function DMAddColorType(name, key, default, custom)
	local colorType = {
		["name"] = name,
		["key"] = key,
		["default"] = default,
		["custom"] = custom
	}

	tinsert(DMColorTypeList, colorType)
	DMColorTypes[name] = colorType
end

DMAddColorType("ufrep", "COLORMODEAUNFRREPA", "Off", "CUSTOMUFREC")
DMAddColorType("np", "COLORMODENP", 1, "CUSTOMNPC")
DMAddColorType("actionbuttons", "COLORMODEAB", 1, "CUSTOMABC")
DMAddColorType("bags", "COLORMODEBA", 1, "CUSTOMBAC")
DMAddColorType("micromenu", "COLORMODEMI", 1, "CUSTOMMIC")
DMAddColorType("buffsanddebuffs", "COLORMODEBAD", 1, "CUSTOMBADC")
DMAddColorType("ui", "COLORMODE", 1, "CUSTOMUIC")
DMAddColorType("uf", "COLORMODEUNFR", 1, "CUSTOMUFC")
DMAddColorType("btns", "COLORMODEABTNS", "Off", "CUSTOMBTNS")
DMAddColorType("ufdr", "COLORMODEAUNFRDRA", "Off", "CUSTOMUFDRC")
DMAddColorType("ufdrp", "COLORMODEAUNFRDRAP", "Off", "CUSTOMUFDRPC")
DMAddColorType("ufhp", "COLORMODEAUNFRHPA", "Off", "CUSTOMUFHPC")
DMAddColorType("ufpor", "COLORMODEAUNFRPORA", "Off", "CUSTOMUFPORC")
DMAddColorType("tt", "COLORMODETT", 1, "CUSTOMTTC")
DMAddColorType("addons", "COLORMODEFA", 1, "CUSTOMFRAC")
DMAddColorType("frames", "COLORMODEF", 1, "CUSTOMFRC")
function DarkMode:GetColorTypes()
	return DMColorTypeList
end

function DarkMode:IsColorType(typ)
	return typ ~= nil and DMColorTypes[typ] ~= nil
end

local colorCache = {}
function DarkMode:InvalidateColorCache()
	wipe(colorCache)
end

local function DMIsDBReady()
	if DMTAB == nil or DMTAB["PROFILES"] == nil then return false end
	return DMTAB["PROFILES"][DMTAB["CURRENTPROFILE"] or "DEFAULT"] ~= nil
end

function DarkMode:GetTypeColor(typ, texture)
	local colorType = DMColorTypes[typ]
	if colorType == nil then return nil, nil, nil, nil end
	local cache = colorCache[typ]
	if cache == nil then
		local default = colorType["default"]
		if type(default) == "string" then default = DarkMode:GetColorModeID(default) end
		local mode = DarkMode:DMGV(colorType["key"], default)
		local r, g, b, a = DarkMode:GetColor(mode, colorType["custom"])
		cache = {
			["r"] = r,
			["g"] = g,
			["b"] = b,
			["a"] = a,
			["colored"] = mode ~= DarkMode:GetColorModeID("Off"),
			["desaturate"] = DarkMode:IsEnabled("DESATURATE", true)
		}

		if DMIsDBReady() then colorCache[typ] = cache end
	end

	if cache["colored"] and cache["desaturate"] and texture and texture.SetDesaturated then texture:SetDesaturated(true) end
	return DarkMode:GetBrighterColor(cache["r"], cache["g"], cache["b"], cache["a"], texture)
end

function DarkMode:GetTextColor(r, g, b, a)
	if r ~= nil and g ~= nil and b ~= nil then
		local sum = r + g + b
		if sum >= 2 then return 0, 0, 0, 1 end
	end
	return 1, 1, 1, 1
end
