
-- Slider Ranges (The Client Does Not Expose CVar Bounds, So They Are Defined Here)
	local sliderRanges = {
		HDRBrightness     = { Min = 0,  Max = 2000,  Step = 25,   Decimals = 0, Format = "nits" },
		HDRPeakBrightness = { Min = 0, Max = 2000, Step = 25,  Decimals = 0, Format = "nits" },
		HDRFactor         = { Min = 1,   Max = 10,    Step = 0.1, Decimals = 1,
		                      Format = function(_, display) return string.format("%.1fx", display) end },
	}

-- Render Format Entries (0/BGRA8Unorm Is Rejected By This Client, So It Is Offered Only If Already Set)
	local renderFormats = {
		{ Value = 1, Label = "10-bit (A2BGR10Unorm)",     Tooltip = "10 bits per color channel. The lowest precision this client accepts." },
		{ Value = 2, Label = "16-bit float (RGBA16F)",    Tooltip = "16-bit floating point. The client default." },
		{ Value = 3, Label = "32-bit float (RGBA32F)",    Tooltip = "32-bit floating point. The highest precision, and the most video memory and bandwidth." },
	}

	local function GetRenderFormats()
		if (tonumber(C_CVar.GetCVar("RenderFormat")) or 2) ~= 0 then
			return renderFormats
		end
		-- The CVar somehow holds 0; list it so the row shows the truth instead of blank.
		local list = { { Value = 0, Label = "8-bit (BGRA8Unorm)", Tooltip = "Not accepted by this client; shown because it is the current value." } }
		for _, entry in ipairs(renderFormats) do
			list[#list + 1] = entry
		end
		return list
	end

-- Widgets
	local HDRTunerEventFrame = CreateFrame("Frame")

-- Register Events
	HDRTunerEventFrame:RegisterEvent("ADDON_LOADED")

-- A CVar Is Only Worth Building A Row For When This Client Actually Has It
	local function CVarExists(cvar)
		return C_CVar.GetCVar(cvar) ~= nil
	end

-- Restart The Graphics Engine So Pending HDR Changes Are Picked Up
	local function RestartGraphicsEngine()
		if type(RestartGx) ~= "function" then return end
		RestartGx()
	end

-- Build The Interface Options Panel
	local function BuildPanel()
		local Panel    = InterfacePanelLib:RegisterAddon("HDRTuner")
		local Category = Panel:CreateCategory({ Name = "HDR Tuner" })

		-- Output
		Panel:CreateHeader({ Category = Category, Name = "Output" })

		if CVarExists("HDROutput") then
			Panel:CreateCheckbox({
				Category   = Category,
				Name       = "Enable HDR Output",
				IsCVar     = true,
				CVar       = "HDROutput",
				UseDefault = "game",
				Type       = "boolean",
				Tooltip    = "Enables HDR output if supported by the monitor and render settings",
				SearchTags = { "hdr", "output", "high dynamic range" },
			})
		end

		if CVarExists("RenderFormat") then
			Panel:CreateDropdown({
				Category   = Category,
				Name       = "Render Format",
				IsCVar     = true,
				CVar       = "RenderFormat",
				UseDefault = "game",
				Type       = "number",
				Options    = GetRenderFormats,
				Tooltip    = "0 = BGRA8Unorm, 1 = A2BGR10Unorm, 2 = RGBA16F, 3 = RGBA32F",
				SearchTags = { "render", "format", "bit depth", "rgba16f", "precision" },
			})
		end

		-- Brightness
		Panel:CreateHeader({ Category = Category, Name = "Brightness" })

		if CVarExists("HDRBrightness") and CVarExists("useHDRBrightness") then
			local range = sliderRanges.HDRBrightness
			Panel:CreateCheckboxSlider({
				Category   = Category,
				SearchTags = { "hdr", "brightness", "paper white", "nits" },
				Checkbox = {
					Name       = "Override Brightness",
					IsCVar     = true,
					CVar       = "useHDRBrightness",
					UseDefault = "game",
					Type       = "boolean",
					Tooltip    = "Whether HDRBrightness should be used to override the monitor's detected brightness level.",
				},
				Slider = {
					Name       = "HDR Brightness",
					IsCVar     = true,
					CVar       = "HDRBrightness",
					UseDefault = "game",
					Type       = "number",
					Min        = range.Min,
					Max        = range.Max,
					Step       = range.Step,
					Decimals   = range.Decimals,
					Format     = range.Format,
					Tooltip    = "Brightness level to use when rendering in HDR, specified in nits (cd/m^2). Only used if useHDRBrightness is set.",
				},
			})
		end

		if CVarExists("HDRPeakBrightness") and CVarExists("useHDRPeakBrightness") then
			local range = sliderRanges.HDRPeakBrightness
			Panel:CreateCheckboxSlider({
				Category   = Category,
				SearchTags = { "hdr", "peak", "brightness", "nits" },
				Checkbox = {
					Name       = "Override Peak Brightness",
					IsCVar     = true,
					CVar       = "useHDRPeakBrightness",
					UseDefault = "game",
					Type       = "boolean",
					Tooltip    = "Whether HDRPeakBrightness should be used to override the monitor's detected peak brightness level.",
				},
				Slider = {
					Name       = "HDR Peak Brightness",
					IsCVar     = true,
					CVar       = "HDRPeakBrightness",
					UseDefault = "game",
					Type       = "number",
					Min        = range.Min,
					Max        = range.Max,
					Step       = range.Step,
					Decimals   = range.Decimals,
					Format     = range.Format,
					Tooltip    = "Peak brightness the monitor is able to display when rendering in HDR, specified in nits (cd/m^2). Only used if useHDRPeakBrightness is set.",
				},
			})
		end

		-- Tone Mapping
		if CVarExists("HDRFactor") then
			local range = sliderRanges.HDRFactor
			Panel:CreateHeader({ Category = Category, Name = "Tone Mapping" })
			Panel:CreateSlider({
				Category   = Category,
				Name       = "HDR Factor",
				IsCVar     = true,
				CVar       = "HDRFactor",
				UseDefault = "game",
				Type       = "number",
				Min        = range.Min,
				Max        = range.Max,
				Step       = range.Step,
				Decimals   = range.Decimals,
				Format     = range.Format,
				Tooltip    = "Factor adjusting how far above SDR lighting HDR is allowed to push. Will be clamped to the monitor's peak brightness.",
			})
		end

		-- Graphics Engine
		Panel:CreateHeader({ Category = Category, Name = "Graphics Engine" })
		Panel:CreateButton({
			Category   = Category,
			Name       = "Apply Changes",
			ButtonText = "Restart Graphics Engine",
			OnClick    = RestartGraphicsEngine,
			Tooltip    = "Restarts the graphics engine so the HDR settings above take effect. The screen will go black for a moment.",
			SearchTags = { "restart", "graphics", "gx", "apply" },
		})
	end

-- OnEvent Function
	local function HDRTunerOnEvent(self, event, ...)
		if event == "ADDON_LOADED" then
			local addonName = ...
			if addonName ~= "HDRTuner" then return end
			self:UnregisterEvent("ADDON_LOADED")

			if not InterfacePanelLib then return end
			BuildPanel()
		end
	end

-- Set Scripts
	HDRTunerEventFrame:SetScript("OnEvent", HDRTunerOnEvent)
