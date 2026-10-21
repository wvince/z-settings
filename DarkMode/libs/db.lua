local _, DarkMode = ...
function DarkMode:GetCP(from)
	DMTAB = DMTAB or {}
	DMTAB["CURRENTPROFILE"] = DMTAB["CURRENTPROFILE"] or "DEFAULT"

	return DMTAB["CURRENTPROFILE"]
end

function DarkMode:AddProfile(name)
	DMTAB = DMTAB or {}
	DMTAB["PROFILES"] = DMTAB["PROFILES"] or {}
	-- Profile
	DMTAB["PROFILES"][name] = DMTAB["PROFILES"][name] or {}
	-- Frames
	DMTAB["PROFILES"][name]["FRAMES"] = DMTAB["PROFILES"][name]["FRAMES"] or {}
	DMTAB["PROFILES"][name]["FRAMES"]["POINTS"] = DMTAB["PROFILES"][name]["FRAMES"]["POINTS"] or {}
	DMTAB["PROFILES"][name]["FRAMES"]["SIZES"] = DMTAB["PROFILES"][name]["FRAMES"]["SIZES"] or {}
	-- Eles
	DMTAB["PROFILES"][name]["ELES"] = DMTAB["PROFILES"][name]["ELES"] or {}
	DMTAB["PROFILES"][name]["ELES"]["POINTS"] = DMTAB["PROFILES"][name]["ELES"]["POINTS"] or {}
	DMTAB["PROFILES"][name]["ELES"]["SIZES"] = DMTAB["PROFILES"][name]["ELES"]["SIZES"] or {}
	DMTAB["PROFILES"][name]["ELES"]["OPTIONS"] = DMTAB["PROFILES"][name]["ELES"]["OPTIONS"] or {}
	DMTAB["PROFILES"][name]["ELES"]["OPTIONS"]["ACTIONBARS"] = DMTAB["PROFILES"][name]["ELES"]["OPTIONS"]["ACTIONBARS"] or {}
end

local DMDBVERSION = 1
local DMCOLORMODEV1 = {[7] = 8, [8] = 7, [9] = 8}
function DarkMode:MigrateDB()
	DMTAB = DMTAB or {}
	DMTAB["VALUES"] = DMTAB["VALUES"] or {}
	if (DMTAB["DBVERSION"] or 0) < 1 then
		for name, value in pairs(DMTAB["VALUES"]) do
			if type(name) == "string" and type(value) == "number" and strfind(name, "^COLORMODE") and DMCOLORMODEV1[value] then
				DMTAB["VALUES"][name] = DMCOLORMODEV1[value]
			end
		end
	end

	DMTAB["DBVERSION"] = DMDBVERSION
end

function DarkMode:InitDB()
	-- DB
	DMTAB = DMTAB or {}
	-- PROFILES
	DMTAB["PROFILES"] = DMTAB["PROFILES"] or {}
	DMTAB["CURRENTPROFILE"] = DMTAB["CURRENTPROFILE"] or "DEFAULT"
	DarkMode:AddProfile("DEFAULT")
	DarkMode:MigrateDB()
end

function DarkMode:GetTab(from)
	if DMTAB == nil or DMTAB["PROFILES"] == nil then
		DarkMode:MSG("[GetTab] Get Tab to early", from)

		return {}
	end

	if DMTAB["PROFILES"][DarkMode:GetCP(from)] == nil then
		DarkMode:MSG("[GetTab] Get Profile Tab to early", from)

		return {}
	end

	return DMTAB["PROFILES"][DarkMode:GetCP(from)]
end

function DarkMode:SetEnabled(element, value)
	if DMTAB == nil or DMTAB["PROFILES"] == nil then
		DarkMode:MSG("[SetEnabled] Get Tab to early", element)

		return false
	end

	if DMTAB["PROFILES"][DarkMode:GetCP("SetEnabled")] == nil then
		DarkMode:MSG("[SetEnabled] Get Profile Tab to early", element)

		return false
	end

	DarkMode:GetTab("SetEnabled")["ELES"]["OPTIONS"][element] = DarkMode:GetTab()["ELES"]["OPTIONS"][element] or {}
	DarkMode:GetTab("SetEnabled")["ELES"]["OPTIONS"][element]["ENABLED"] = value
	if DarkMode.InvalidateColorCache then DarkMode:InvalidateColorCache() end
end

function DarkMode:IsEnabled(element, value)
	if DMTAB == nil or DMTAB["PROFILES"] == nil then
		DarkMode:MSG("[IsEnabled] Get Tab to early", element)

		return false
	end

	if DMTAB["PROFILES"][DarkMode:GetCP("IsEnabled")] == nil then
		DarkMode:MSG("[IsEnabled] Get Profile Tab to early", element)

		return false
	end

	if element == nil then
		DarkMode:MSG("[IsEnabled] Missing Name")

		return false
	end

	if value == nil then
		DarkMode:MSG("[IsEnabled] Missing Value")

		return false
	end

	DarkMode:GetTab("IsEnabled")["ELES"]["OPTIONS"][element] = DarkMode:GetTab()["ELES"]["OPTIONS"][element] or {}
	if DarkMode:GetTab("IsEnabled")["ELES"]["OPTIONS"][element]["ENABLED"] == nil then
		DarkMode:GetTab("IsEnabled")["ELES"]["OPTIONS"][element]["ENABLED"] = value
	end

	return DarkMode:GetTab("IsEnabled")["ELES"]["OPTIONS"][element]["ENABLED"]
end

function DarkMode:GetElePoint(key)
	DarkMode:GetTab()["ELES"]["POINTS"][key] = DarkMode:GetTab()["ELES"]["POINTS"][key] or {}
	local an = DarkMode:GetTab("GetElePoint")["ELES"]["POINTS"][key]["AN"]
	local pa = DarkMode:GetTab("GetElePoint")["ELES"]["POINTS"][key]["PA"]
	local re = DarkMode:GetTab("GetElePoint")["ELES"]["POINTS"][key]["RE"]
	local px = DarkMode:GetTab("GetElePoint")["ELES"]["POINTS"][key]["PX"]
	local py = DarkMode:GetTab("GetElePoint")["ELES"]["POINTS"][key]["PY"]

	return an, pa, re, px, py
end

function DarkMode:SetElePoint(key, p1, p2, p3, p4, p5)
	DarkMode:GetTab("SetElePoint")["ELES"]["POINTS"][key]["AN"] = p1
	DarkMode:GetTab("SetElePoint")["ELES"]["POINTS"][key]["PA"] = p2
	DarkMode:GetTab("SetElePoint")["ELES"]["POINTS"][key]["RE"] = p3
	DarkMode:GetTab("SetElePoint")["ELES"]["POINTS"][key]["PX"] = p4
	DarkMode:GetTab("SetElePoint")["ELES"]["POINTS"][key]["PY"] = p5
	local frame = _G[key]
	if frame then
		frame:ClearAllPoints()
		frame:SetPoint(p1, UIParent, p3, p4, p5)
	end
end

function DarkMode:DMSV(name, value)
	DMTAB = DMTAB or {}
	DMTAB["VALUES"] = DMTAB["VALUES"] or {}
	DMTAB["VALUES"][name] = value
	if DarkMode.InvalidateColorCache then DarkMode:InvalidateColorCache() end
end

function DarkMode:DMGV(name, value)
	DMTAB = DMTAB or {}
	DMTAB["VALUES"] = DMTAB["VALUES"] or {}
	if DMTAB["VALUES"][name] == nil then
		DarkMode:DMSV(name, value)
	end

	return DMTAB["VALUES"][name] or value
end

function DarkMode:GetMinimapTable()
	DMTAB["PROFILES"] = DMTAB["PROFILES"] or {}
	DarkMode:GetTab("GetMinimapTable")["MMICON"] = DarkMode:GetTab()["MMICON"] or {}

	return DarkMode:GetTab("GetMinimapTable")["MMICON"]
end
