local _, DarkMode = ...
local DMColorModes = {"Dark", "More Dark", "Darker", "More Darker", "Black", "ClassColor", "Custom", "Off"}
local DMColorModeIDs = {}
for i, v in pairs(DMColorModes) do
	DMColorModeIDs[v] = i
end

local DMDROPDOWNWIDTH = 140
local DMSWATCHSIZE = 24
local DMDEFAULTWIDTH = 620
local dmChoices = {}
local dmSwatches = {}
local dmLinked = {}
local dmSettings = nil
for i, v in ipairs(DMColorModes) do
	tinsert(dmChoices, {
		["value"] = i,
		["label"] = "LID_" .. v
	})
end

function DarkMode:GetColorModes()
	return DMColorModes
end

function DarkMode:GetColorModeID(name)
	return DMColorModeIDs[name] or 1
end

local function DMSetSolidColor(texture, r, g, b, a)
	if texture == nil then return end
	if texture.SetColorTexture then
		texture:SetColorTexture(r, g, b, a)
	else
		texture:SetTexture(r, g, b, a)
	end
end

local function DMEnableSave()
	if dmSettings == nil then return end
	if dmSettings.DMSave == nil then return end
	dmSettings.DMSave:Enable()
end

local function DMUpdateShowErrors()
	if dmSettings == nil then return end
	if dmSettings.DMShowErrors == nil then return end
	if GetCVar("ScriptErrors") == "0" then
		dmSettings.DMShowErrors:Show()
	else
		dmSettings.DMShowErrors:Hide()
	end
end

local function DMUpdateSwatches()
	local custom = DarkMode:GetColorModeID("Custom")
	for i = 1, #dmSwatches do
		local btn = dmSwatches[i]
		if DarkMode:DMGV(btn.dmkey, 1) == custom then
			local r, g, b, a = DarkMode:GetCustomColor(btn.dmcolorkey)
			DMSetSolidColor(btn.dmfill, r, g, b, a)
			btn:Show()
		else
			btn:Hide()
		end
	end
end

local function DMGetCollapsed(key)
	if key == nil then return nil end
	if type(DMTAB) ~= "table" then return nil end
	if type(DMTAB["COLLAPSED"]) ~= "table" then return nil end
	return DMTAB["COLLAPSED"][key]
end

local function DMSetCollapsed(key, collapsed)
	if key == nil then return end
	if type(DMTAB) ~= "table" then return end
	if type(DMTAB["COLLAPSED"]) ~= "table" then DMTAB["COLLAPSED"] = {} end
	DMTAB["COLLAPSED"][key] = collapsed == true
end

function DarkMode:ShowColorPicker(r, g, b, a, changedCallback)
	if ColorPickerFrame.SetupColorPickerAndShow then
		local info = {}
		info.r = r
		info.g = g
		info.b = b
		info.swatchFunc = changedCallback
		info.hasOpacity = a ~= nil
		info.opacityFunc = changedCallback
		info.opacity = a
		self.previousValues = {
			r = info.r,
			g = info.g,
			b = info.b,
			a = info.opacity
		}

		info.cancelFunc = nil
		info.extraInfo = "TEST"
		ColorPickerFrame:SetupColorPickerAndShow(info)
	else
		ColorPickerFrame.func = changedCallback
		ColorPickerFrame.opacityFunc = changedCallback
		ColorPickerFrame.swatchFunc = changedCallback
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = a ~= nil, 1 - a
		ColorPickerFrame.previousValues = {r, g, b, a}
		if ColorPickerFrame.SetColorRGB then
			ColorPickerFrame:SetColorRGB(r, g, b)
		elseif ColorPickerFrame.Content.ColorSwatchCurrent.SetColorTexture then
			ColorPickerFrame.Content.ColorSwatchCurrent:SetColorTexture(r, g, b)
		else
			DarkMode:MSG("Failed ColorPicker #1")
		end

		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = a ~= nil, 1 - a
		ColorPickerFrame:Hide() -- Need to run the OnShow handler.
		ColorPickerFrame:Show()
	end
end

local function DMAddColorSwatch(holder, key, colorKey)
	local btn = DarkMode:CreateButton("DMSettingsSwatch" .. key, holder, true)
	btn:SetSize(DMSWATCHSIZE, DMSWATCHSIZE)
	btn:SetPoint("RIGHT", holder, "RIGHT", 0, 0)
	btn.dmborder = btn:CreateTexture(nil, "BACKGROUND")
	btn.dmborder:SetAllPoints(btn)
	DMSetSolidColor(btn.dmborder, 0.6, 0.6, 0.6, 1)
	btn.dmfill = btn:CreateTexture(nil, "ARTWORK")
	btn.dmfill:SetPoint("TOPLEFT", btn, "TOPLEFT", 1, -1)
	btn.dmfill:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -1, 1)
	btn.dmhighlight = btn:CreateTexture(nil, "HIGHLIGHT")
	btn.dmhighlight:SetAllPoints(btn)
	DMSetSolidColor(btn.dmhighlight, 1, 1, 1, 0.25)
	btn.dmkey = key
	btn.dmcolorkey = colorKey
	btn:SetScript("OnEnter", function(sel)
		GameTooltip:SetOwner(sel, "ANCHOR_RIGHT")
		GameTooltip:SetText(DarkMode:Trans("LID_COLOR"))
		GameTooltip:Show()
	end)

	btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
	btn:SetScript("OnClick", function()
		local r, g, b, a = DarkMode:GetCustomColor(colorKey)
		DarkMode:ShowColorPicker(r, g, b, a, function(restore)
			local newR, newG, newB, newA
			if restore then
				newR, newG, newB, newA = unpack(restore)
			else
				local OpacitySliderFrame = getglobal("OpacitySliderFrame")
				if OpacitySliderFrame then
					newA, newR, newG, newB = 1 - OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
				elseif ColorPickerFrame.Content.ColorPicker.GetColorAlpha then
					newA, newR, newG, newB = ColorPickerFrame.Content.ColorPicker:GetColorAlpha(), ColorPickerFrame:GetColorRGB()
				else
					DarkMode:MSG("Failed ColorPicker #2")
				end
			end

			DarkMode:SetCustomColor(colorKey, newR, newG, newB, newA)
			DMUpdateSwatches()
		end)
	end)

	tinsert(dmSwatches, btn)
	return btn
end

local function DMAddCheckbox(key, default, func)
	return dmSettings:AddCheckbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = DarkMode:IsEnabled(key, default),
		["func"] = function(value)
			DarkMode:SetEnabled(key, value)
			if func then func(value) end
			DMEnableSave()
		end
	})
end

local function DMAddColorMode(key, default, colorKey, linked)
	local holder = dmSettings:AddDropdown({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = DarkMode:DMGV(key, default),
		["width"] = DMDROPDOWNWIDTH,
		["choices"] = dmChoices,
		["func"] = function(value)
			DarkMode:DMSV(key, value)
			DarkMode:UpdateColors()
			DMUpdateSwatches()
			DMEnableSave()
		end
	})

	if holder == nil then return nil end
	DMAddColorSwatch(holder, key, colorKey)
	if linked then
		tinsert(dmLinked, {
			["key"] = key,
			["holder"] = holder
		})
	end
	return holder
end

local function DMAddGeneralColorMode()
	return dmSettings:AddDropdown({
		["label"] = "LID_COLORMODEG",
		["search"] = "COLORMODEG",
		["value"] = DarkMode:DMGV("COLORMODEG", 1),
		["width"] = DMDROPDOWNWIDTH,
		["choices"] = dmChoices,
		["func"] = function(value)
			DarkMode:DMSV("COLORMODEG", value)
			for i = 1, #dmLinked do
				DarkMode:DMSV(dmLinked[i]["key"], value)
				dmLinked[i]["holder"]:SetValue(value)
			end

			DarkMode:UpdateColors()
			DMUpdateSwatches()
			DMEnableSave()
		end
	})
end

local function DMBuildFooter()
	local footer = dmSettings:AddFooter({
		["height"] = 24
	})

	dmSettings.DMSave = DarkMode:CreateReloadButton("DMSettingsSave", footer)
	dmSettings.DMSave:SetSize(100, 24)
	dmSettings.DMSave:SetPoint("LEFT", footer, "LEFT", 0, 0)
	dmSettings.DMSave:SetText(SAVE)
	dmSettings.DMSave:Disable()
	dmSettings.DMReload = DarkMode:CreateReloadButton("DMSettingsReload", footer)
	dmSettings.DMReload:SetSize(100, 24)
	dmSettings.DMReload:SetPoint("LEFT", dmSettings.DMSave, "RIGHT", 4, 0)
	dmSettings.DMReload:SetText(RELOADUI or "RELOADUI")
	dmSettings.DMShowErrors = DarkMode:CreateButton("DMSettingsShowErrors", footer)
	dmSettings.DMShowErrors:SetSize(110, 24)
	dmSettings.DMShowErrors:SetPoint("LEFT", dmSettings.DMReload, "RIGHT", 4, 0)
	dmSettings.DMShowErrors:SetText("Show Errors")
	dmSettings.DMShowErrors:SetScript("OnClick", function()
		if GetCVar("ScriptErrors") == "0" then
			SetCVar("ScriptErrors", 1)
			DMReload()
		end

		DMUpdateShowErrors()
	end)

	dmSettings.DMDiscord = CreateFrame("EditBox", "DMSettingsDiscord", footer, "InputBoxTemplate")
	dmSettings.DMDiscord:SetText("discord.gg/AYB3qR5hQm")
	dmSettings.DMDiscord:SetSize(160, 24)
	dmSettings.DMDiscord:SetPoint("RIGHT", footer, "RIGHT", 0, 0)
	dmSettings.DMDiscord:SetAutoFocus(false)
end

local function DMBuildElementList()
	dmSettings:SuspendLayout()
	dmSettings:AddCategory({
		["label"] = "LID_GENERAL",
		["key"] = "GENERAL",
		["search"] = "GENERAL"
	})

	DMAddCheckbox("MMBTN", true, function()
		if DarkMode:IsEnabled("MMBTN", DarkMode:GetWoWBuild() ~= "RETAIL") then
			DarkMode:ShowMMBtn("DarkMode")
		else
			DarkMode:HideMMBtn("DarkMode")
		end
	end)

	DMAddCheckbox("GRYPHONS", true)
	dmSettings:AddCategory({
		["label"] = "LID_BORDERS",
		["key"] = "BORDERS",
		["search"] = "BORDERS",
		["level"] = 2
	})

	DMAddCheckbox("MASKMINIMAPBUTTONS", true)
	if not getglobal("MSQ") then
		DMAddCheckbox("MASKACTIONBUTTONS", true)
		DMAddCheckbox("MASKBUFFSANDDEBUFFS", true)
		DMAddCheckbox("THINBORDERS", false)
		DMAddCheckbox("SHADOWACTIONBARS", false)
	end

	dmSettings:AddCategory({
		["label"] = "LID_COLORS",
		["key"] = "COLORS",
		["search"] = "COLORS"
	})

	DMAddGeneralColorMode()
	DMAddColorMode("COLORMODE", 1, "CUSTOMUIC", true)
	DMAddColorMode("COLORMODEUNFR", 1, "CUSTOMUFC", true)
	DMAddColorMode("COLORMODENP", 1, "CUSTOMNPC", true)
	DMAddColorMode("COLORMODETT", 1, "CUSTOMTTC", true)
	DMAddColorMode("COLORMODEAB", 1, "CUSTOMABC", true)
	DMAddColorMode("COLORMODEBA", 1, "CUSTOMBAC", true)
	DMAddColorMode("COLORMODEMI", 1, "CUSTOMMIC", true)
	DMAddColorMode("COLORMODEBAD", 1, "CUSTOMBADC", true)
	DMAddColorMode("COLORMODEF", 1, "CUSTOMFRC", true)
	DMAddColorMode("COLORMODEFA", 1, "CUSTOMFRAC", true)
	dmSettings:AddCategory({
		["label"] = "LID_ADVANCED",
		["key"] = "ADVANCED",
		["search"] = "ADVANCED",
		["level"] = 2,
		["collapsed"] = true
	})

	DMAddCheckbox("DESATURATE", true)
	local off = DarkMode:GetColorModeID("Off")
	DMAddColorMode("COLORMODEABTNS", off, "CUSTOMBTNS", false)
	DMAddColorMode("COLORMODEAUNFRDRA", off, "CUSTOMUFDRC", false)
	DMAddColorMode("COLORMODEAUNFRHPA", off, "CUSTOMUFHPC", false)
	DMAddColorMode("COLORMODEAUNFRPORA", off, "CUSTOMUFPORC", false)
	DMAddColorMode("COLORMODEAUNFRREPA", off, "CUSTOMUFREC", false)
	dmSettings:ResumeLayout()
	DMUpdateSwatches()
end

function DarkMode:ToggleSettings()
	if dmSettings == nil then return end
	local show = not dmSettings:IsShown()
	DarkMode:SetEnabled("SETTINGS", show)
	if show then
		dmSettings:Show()
	else
		dmSettings:Hide()
	end

	DMUpdateShowErrors()
end

function DarkMode:InitDMSettings()
	DarkMode:SetVersion()
	dmSettings = DarkMode:CreateUIWindow({
		["name"] = "DMSettings",
		["pTab"] = {"CENTER"},
		["width"] = DarkMode:DMGV("SETTINGSWIDTH", DMDEFAULTWIDTH),
		["height"] = DarkMode:DMGV("SETTINGSHEIGHT", DarkMode:MClamp(640, 200, GetScreenHeight())),
		["minWidth"] = 420,
		["minHeight"] = 300,
		["title"] = format("|T%s:16:16:0:0|t DarkMode v%s", DarkMode:GetAddonIcon(), DarkMode:GetVersion()),
		["onResize"] = function(width, height)
			DarkMode:DMSV("SETTINGSWIDTH", width)
			DarkMode:DMSV("SETTINGSHEIGHT", height)
		end,
		["onMove"] = function(p1, p3, p4, p5) DarkMode:SetElePoint("DMSettings", p1, nil, p3, p4, p5) end,
		["onClose"] = function() DarkMode:ToggleSettings() end,
		["getCollapsed"] = function(key) return DMGetCollapsed(key) end,
		["setCollapsed"] = function(key, collapsed) DMSetCollapsed(key, collapsed) end
	})

	dmSettings:SetFrameLevel(99)
	dmSettings:AddSearch()
	DMBuildFooter()
	DMBuildElementList()
	local dbp1, _, dbp3, dbp4, dbp5 = DarkMode:GetElePoint("DMSettings")
	if dbp1 and dbp3 then
		dmSettings:ClearAllPoints()
		dmSettings:SetPoint(dbp1, UIParent, dbp3, dbp4, dbp5)
	end

	DMUpdateShowErrors()
	if DarkMode:IsEnabled("SETTINGS", false) then
		dmSettings:Show()
	else
		dmSettings:Hide()
	end
end
