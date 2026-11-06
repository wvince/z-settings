
	----------------------------------------------------------------------
	-- 	Leatrix Maps 1.60.28 (5th November 2026)
	----------------------------------------------------------------------

	-- 10:Func, 20:Comm, 30:Evnt, 40:Panl

	-- Create global table
	_G.LeaMapsDB = _G.LeaMapsDB or {}

	-- Create local tables
	local LeaMapsLC, LeaMapsCB, LeaConfigList, LeaLockList = {}, {}, {}, {}

	-- Version
	LeaMapsLC["AddonVer"] = "1.60.28"

	-- Get locale table
	local void, Leatrix_Maps = ...
	local L = Leatrix_Maps.L

	-- Check Wow version is valid
	do
		local gameversion, gamebuild, gamedate, gametocversion = GetBuildInfo()
		if gametocversion and gametocversion < 16000 then
			-- Game client is not Forever
			C_Timer.After(2, function()
				print(L["LEATRIX MAPS: WRONG VERSION INSTALLED!"])
			end)
			return
		end
		if gametocversion and gametocversion >= 16001 then -- 1.60.1
			LeaMapsLC.NewPatch = true
		end
	end

	-- Check for addons
	if C_AddOns.IsAddOnLoaded("ElvUI") then LeaMapsLC.ElvUI = unpack(ElvUI) end

	-- Set bindings translations
	_G.BINDING_NAME_LEATRIX_MAPS_GLOBAL_TOGGLE = L["Toggle panel"]

	-- LeaMapsLC.NewPatch
	local function ConvertRGBtoColorString(color)
		local colorString = "|cff";
		local r = color.r * 255;
		local g = color.g * 255;
		local b = color.b * 255;
		colorString = colorString..string.format("%2x%2x%2x", r, g, b);
		return colorString;
	end

	-- Create a random global name that changes every time the addon loads
	function LeaMapsLC:CreateRandomName()
		local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		local name
		repeat
			local parts = {"F"} -- Start with a letter
			for i = 1, 16 do
				local n = math.random(#chars)
				parts[#parts + 1] = chars:sub(n, n)
			end
			name = table.concat(parts)
		until not _G[name] -- Make sure the name is not already in use
		return name
	end

	-- Create a dropdown menu (the standard dropdown button but it opens a pop-up list instead of the game's menu, see
	-- LeaMapsLC:CreatePopupList for why)
	function LeaMapsLC:CreateDropdown(frame, label, width, anchor, parent, relative, x, y, reload, items)

		local dropdown = CreateFrame("DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
		LeaMapsCB[frame] = dropdown
		dropdown:SetPoint(anchor, parent, relative, x, y)
		dropdown:SetWidth(width)

		local lf = dropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal"); lf:SetPoint("TOPLEFT", dropdown, 0, 20); lf:SetPoint("TOPRIGHT", dropdown, -5, 20); lf:SetJustifyH("LEFT"); lf:SetText(L[label])

		-- List entries
		local entries = {}
		for i = 1, #items do
			entries[i] = {name = items[i][1], value = items[i][2]}
		end

		-- Function to show the current option on the button
		local function UpdateText()
			for i = 1, #entries do
				if entries[i].value == LeaMapsLC[frame] then
					dropdown:OverrideText(entries[i].name)
					return
				end
			end
			dropdown:OverrideText("")
		end

		-- Function to apply an option (runs dropdown.onChange if it's set)
		local function SetValue(value)
			LeaMapsLC[frame] = value
			UpdateText()
			if dropdown.onChange then dropdown.onChange(value) end
			if reload then
				LeaMapsLC:ReloadCheck()
			end
		end

		local popup = LeaMapsLC:CreatePopupList(parent)

		local function IsCurrent(entry)
			return entry.value == LeaMapsLC[frame]
		end

		local function Choose(entry)
			SetValue(entry.value)
		end

		-- Function to step to the next or previous option (scroll down for the next option, up for the previous one, stops at either end)
		local function Step(delta)
			local index = 1
			for i = 1, #entries do
				if entries[i].value == LeaMapsLC[frame] then index = i; break end
			end
			index = index + (delta < 0 and 1 or -1)
			if index < 1 or index > #entries then return end
			SetValue(entries[index].value)
			popup:Refresh()
		end

		-- Open or close the list when the button is clicked
		dropdown:HookScript("OnMouseDown", function(self, button)
			if button ~= "LeftButton" or not self:IsEnabled() then return end
			popup:Toggle(self, entries, IsCurrent, Choose, "TOPLEFT", "BOTTOMLEFT", 0, -2, Step)
		end)

		-- Cycle through the options with the mousewheel over the button (the open list does the same)
		dropdown:EnableMouseWheel(true)
		dropdown:HookScript("OnMouseWheel", function(self, delta)
			if self:IsEnabled() then Step(delta) end
		end)

		-- Show the current option when the button is shown
		dropdown:HookScript("OnShow", UpdateText)
		UpdateText()

	end

	----------------------------------------------------------------------
	-- Pop-up lists
	----------------------------------------------------------------------

	-- The game's menus keep their state on the menu frame and the world map reads the frame under the pointer every
	-- frame, so menu entries made by an addon spread taint into the map's own code. Lists shown over the map use these
	-- pop-up lists instead. They are frames of our own, so the map never reads anything the addon wrote.

	function LeaMapsLC:CreatePopupList(parent)

		local rowHeight, rowsPerColumn, columnWidth = 20, 25, 180
		local rows = {}
		local owner, entries, isChecked, onClick, onWheel
		local highlightColor -- Row highlight color (set with popup:SetColors)
		local rowColorFunc -- Optional function giving each row its own highlight color (set with popup:SetColors)

		local list = CreateFrame("Frame", nil, parent, "BackdropTemplate")
		list:SetFrameStrata("FULLSCREEN_DIALOG")
		list:SetClampedToScreen(true)
		list:EnableMouse(true)
		list:EnableMouseWheel(true)
		-- Mousewheel runs the wheel function if there is one (and stops the map zooming under the list)
		list:SetScript("OnMouseWheel", function(self, delta)
			if onWheel then onWheel(delta) end
		end)
		list:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8"})
		list:SetBackdropColor(0.05, 0.05, 0.05, 0.95)

		-- Border (four lines sized in whole screen pixels when the list opens, so it's the same width all the way round)
		local borderLines = {}
		for i = 1, 4 do
			borderLines[i] = list:CreateTexture(nil, "BORDER")
			borderLines[i]:SetTexture("Interface\\Buttons\\WHITE8X8")
			borderLines[i]:SetVertexColor(0.3, 0.3, 0.3, 1)
		end

		-- Function to set the border lines to 1 screen pixel
		local function SetBorderPixels()
			local scale = list:GetEffectiveScale()
			if issecretvalue and issecretvalue(scale) then return end -- Frame scales can be secret in combat
			local px = PixelUtil and PixelUtil.GetNearestPixelSize(1, scale, 1) or 1
			local top, bottom, left, right = borderLines[1], borderLines[2], borderLines[3], borderLines[4]
			top:ClearAllPoints(); top:SetPoint("TOPLEFT"); top:SetPoint("TOPRIGHT"); top:SetHeight(px)
			bottom:ClearAllPoints(); bottom:SetPoint("BOTTOMLEFT"); bottom:SetPoint("BOTTOMRIGHT"); bottom:SetHeight(px)
			left:ClearAllPoints(); left:SetPoint("TOPLEFT", 0, -px); left:SetPoint("BOTTOMLEFT", 0, px); left:SetWidth(px)
			right:ClearAllPoints(); right:SetPoint("TOPRIGHT", 0, -px); right:SetPoint("BOTTOMRIGHT", 0, px); right:SetWidth(px)
		end
		list:Hide()

		-- Close the list when clicking anywhere else (only watched while the list is showing)
		list:SetScript("OnShow", function(self) self:RegisterEvent("GLOBAL_MOUSE_DOWN") end)
		list:SetScript("OnHide", function(self) self:UnregisterEvent("GLOBAL_MOUSE_DOWN") end)
		list:SetScript("OnEvent", function(self)
			if not self:IsMouseOver() and not (owner and owner:IsMouseOver()) then
				self:Hide()
			end
		end)

		-- Function to show a row as checked or not
		local function SetRowCheck(row)
			if isChecked(row.entry) then
				row.Check:Show()
				row.Text:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
			else
				row.Check:Hide()
				row.Text:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
			end
		end

		-- Function to get a row (rows are created when first needed and reused)
		local function GetRow(index)
			local row = rows[index]
			if not row then
				row = CreateFrame("Button", nil, list)
				row:SetSize(columnWidth, rowHeight)
				row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
				if highlightColor then row:GetHighlightTexture():SetVertexColor(highlightColor[1], highlightColor[2], highlightColor[3]) end
				row.Check = row:CreateTexture(nil, "ARTWORK")
				row.Check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
				row.Check:SetSize(16, 16)
				row.Check:SetPoint("LEFT", 4, 0)
				row.Text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
				row.Text:SetPoint("LEFT", 22, 0)
				row.Text:SetPoint("RIGHT", -4, 0)
				row.Text:SetJustifyH("LEFT")
				row.Text:SetWordWrap(false)
				row:SetScript("OnClick", function(self)
					-- The click function returns true to keep the list open (such as for checkboxes)
					if onClick(self.entry) then
						for i = 1, #entries do SetRowCheck(rows[i]) end
					else
						list:Hide()
					end
				end)
				rows[index] = row
			end
			return row
		end

		local popup = {}

		-- Close the list
		function popup:Close()
			list:Hide()
		end

		-- Set the list colors (background, border and row highlight, used by the map theme)
		-- (rowFunc is optional, it is called with the row number and row count and returns a highlight color for that row)
		-- (the Blizzard map theme adds a brown fill to the list frame on top of the background color)
		function popup:SetColors(bgR, bgG, bgB, borderR, borderG, borderB, hlR, hlG, hlB, rowFunc)
			list:SetBackdropColor(bgR, bgG, bgB, 0.97)
			for i = 1, #borderLines do borderLines[i]:SetVertexColor(borderR, borderG, borderB, 1) end
			highlightColor = {hlR, hlG, hlB}
			rowColorFunc = rowFunc
			for i = 1, #rows do
				rows[i]:GetHighlightTexture():SetVertexColor(hlR, hlG, hlB)
			end
		end

		-- The list frame (so the map theme can add textures to it)
		popup.frame = list

		-- Update the checks in the open list
		function popup:Refresh()
			if not list:IsShown() then return end
			for i = 1, #entries do SetRowCheck(rows[i]) end
		end

		-- Show the list next to a button (long lists are split into columns)
		function popup:Open(button, items, checkedFunc, clickFunc, point, relativePoint, x, y, wheelFunc)
			local count = #items
			if count == 0 then return end
			owner, entries, isChecked, onClick, onWheel = button, items, checkedFunc, clickFunc, wheelFunc
			local columns = math.ceil(count / rowsPerColumn)
			local perColumn = math.ceil(count / columns)
			for i = 1, count do
				local row = GetRow(i)
				if rowColorFunc then
					row:GetHighlightTexture():SetVertexColor(rowColorFunc(i, count))
				elseif highlightColor then
					row:GetHighlightTexture():SetVertexColor(highlightColor[1], highlightColor[2], highlightColor[3])
				end
				row.entry = items[i]
				row.Text:SetText(items[i].name)
				SetRowCheck(row)
				row:ClearAllPoints()
				row:SetPoint("TOPLEFT", list, "TOPLEFT", 8 + math.floor((i - 1) / perColumn) * columnWidth, -8 - ((i - 1) % perColumn) * rowHeight)
				row:Show()
			end
			for i = count + 1, #rows do
				rows[i]:Hide()
				rows[i].entry = nil
			end
			list:SetSize(columns * columnWidth + 16, perColumn * rowHeight + 16)
			list:ClearAllPoints()
			list:SetPoint(point, button, relativePoint, x, y)
			list:SetFrameLevel(button:GetFrameLevel() + 20)
			SetBorderPixels()
			list:Show()
		end

		-- Open the list for a button or close it if it's already open for that button
		function popup:Toggle(button, ...)
			if list:IsShown() and owner == button then
				list:Hide()
			else
				self:Open(button, ...)
			end
		end

		return popup

	end

	----------------------------------------------------------------------
	-- L00: Leatrix Maps
	----------------------------------------------------------------------

	-- Main function
	function LeaMapsLC:MainFunc()

		-- Load Battlefield addon
		if not C_AddOns.IsAddOnLoaded("Blizzard_BattlefieldMap") then
			LoadAddOnWithErrorHandling("Blizzard_BattlefieldMap")
		end

		-- Get player faction
		local playerFaction = UnitFactionGroup("player")

		-- Remove blackout frame
		if LeaMapsLC["HideBlackoutFrame"] == "On" then
			WorldMapFrame.BlackoutFrame:SetAlpha(0)
			WorldMapFrame.BlackoutFrame:EnableMouse(false)
		end

		-- Hide the world map tutorial button
		WorldMapFrame.BorderFrame.Tutorial:HookScript("OnShow", WorldMapFrame.BorderFrame.Tutorial.Hide)
		SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_WORLD_MAP_FRAME, true)

		----------------------------------------------------------------------
		-- Simple map frame
		----------------------------------------------------------------------

		-- Map theme (simple map frame only, ApplyMapTheme is set when the simple map frame is created)
		-- mapTheme holds the parts the theme colors (title bar, buttons, menus, lists, coordinates background)
		local ApplyMapTheme, mapTheme = nil, {}

		if LeaMapsLC["SimpleMapFrame"] == "On" and not LeaLockList["SimpleMapFrame"] then

			-- Function to check if a frame can be changed (protected frames cannot be changed during combat)
			local function CanChange(frame)
				return not InCombatLockdown() or not frame:IsProtected()
			end

			-- Function to hide a frame or texture permanently
			local function HideFrame(frame)
				frame:SetAlpha(0)
				if frame:IsObjectType("Frame") then
					if CanChange(frame) then
						frame:Hide()
						frame:EnableMouse(false)
					end
					frame:HookScript("OnShow", function()
						if CanChange(frame) then frame:Hide() else frame:SetAlpha(0) end
					end)
				end
			end

			----------------------------------------------------------------------
			-- Hide map elements
			----------------------------------------------------------------------

			-- Hide border, portrait, title and maximise button (but not close button)
			for i, v in pairs({WorldMapFrame.BorderFrame:GetRegions()}) do
				HideFrame(v)
			end
			for i, v in pairs({WorldMapFrame.BorderFrame:GetChildren()}) do
				if v ~= WorldMapFrame.BorderFrame.CloseButton and v ~= WorldMapFrame.BorderFrame.MaximizeMinimizeFrame then
					HideFrame(v)
				end
			end

			-- Hide border background (the game moves it from the border frame to the map frame)
			HideFrame(WorldMapFrame.BorderFrame.Bg)

			-- Hide navigation bar
			HideFrame(WorldMapFrame.NavBar)

			-- Hide quest count
			HideFrame(QuestLogCount)

			----------------------------------------------------------------------
			-- Create map frame
			----------------------------------------------------------------------

			local frameLevel = math.min(WorldMapFrame:GetFrameLevel() + 2000, 9000)

			-- Create border (covers the map and the quest log when it's shown)
			local borderFrame = CreateFrame("Frame", nil, WorldMapFrame, "BackdropTemplate")
			borderFrame:SetFrameLevel(WorldMapFrame:GetFrameLevel())
			borderFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8"})
			borderFrame:SetBackdropColor(0, 0, 0, 0.9)
			mapTheme.borderFrame = borderFrame -- Used by Unlock map frame (the map can be dragged just outside the border)

			-- Create black edge with a soft drop shadow around the border (sized in whole screen pixels in SetPixelEdges)
			-- (the shadow layers stack so the shadow fades out naturally from the edge)
			local edgeTextures = {}
			for i = 1, 5 do
				local tex = borderFrame:CreateTexture(nil, "BACKGROUND", nil, -8 + i)
				tex:SetTexture("Interface\\Buttons\\WHITE8X8")
				if i == 5 then tex:SetVertexColor(0, 0, 0, 1) else tex:SetVertexColor(0, 0, 0, 0.12) end
				edgeTextures[i] = tex
			end

			-- Create title bar (uses the space left by the navigation bar)
			local titleFrame = CreateFrame("Frame", nil, WorldMapFrame)
			titleFrame:SetFrameStrata("HIGH")
			titleFrame:SetFrameLevel(frameLevel)
			titleFrame:SetHeight(22)

			-- Assign file level scope to title bar (needed for Unlock map frame)
			LeaMapsCB["MapTitleFrame"] = titleFrame

			local titleTexture = titleFrame:CreateTexture(nil, "BACKGROUND")
			titleTexture:SetAllPoints()
			titleTexture:SetTexture("Interface\\Buttons\\WHITE8X8") -- Colors are set by the map theme
			mapTheme.titleBar = titleFrame
			mapTheme.titleTexture = titleTexture

			-- Create frame for title bar text
			local titleTextFrame = CreateFrame("Frame", nil, titleFrame)
			titleTextFrame:SetAllPoints()
			titleTextFrame:SetFrameLevel(frameLevel + 2)

			-- Create map title (centered over the map, positioned in the layout function)
			local titleText = titleTextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			titleText:SetPoint("CENTER")
			titleText:SetWordWrap(false)

			-- Assign file level scope to map title (needed for Show zone menus)
			LeaMapsCB["MapTitleText"] = titleText

			-- Create quest count
			local questCount = titleTextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			questCount:SetPoint("LEFT", 8, 0)

			-- Assign file level scope to quest count (needed for Show zone menus)
			LeaMapsCB["MapQuestCount"] = questCount

			----------------------------------------------------------------------
			-- Title bar buttons
			----------------------------------------------------------------------

			-- Set button sizes to fit the title bar
			WorldMapFrame.BorderFrame.CloseButton:SetSize(20, 20)
			WorldMapFrame.BorderFrame.MaximizeMinimizeFrame:SetSize(20, 20)

			-- Function to replace button art with a white icon (the button still works as normal)
			-- The icon and hover box colors are set by the map theme (the icon turns white on hover)
			mapTheme.buttons = {}
			local function SetButtonIcon(button, file, left, right, top, bottom)
				-- Keep the game's button art so the Blizzard theme can show it again (it's hidden for the other themes)
				local art = {button:GetNormalTexture(), button:GetPushedTexture(), button:GetHighlightTexture(), button:GetDisabledTexture()}
				for i, v in pairs(art) do
					v:SetAlpha(0)
				end
				-- Hover background
				local box = button:CreateTexture(nil, "BACKGROUND")
				box:SetAllPoints()
				box:SetTexture("Interface\\Buttons\\WHITE8X8")
				box:Hide()
				-- Icon
				local icon = button:CreateTexture(nil, "OVERLAY")
				icon:SetTexture("Interface\\AddOns\\Leatrix_Maps\\" .. file)
				if left then icon:SetTexCoord(left, right, top, bottom) end
				icon:SetAllPoints()
				local entry = {box = box, icon = icon, color = {0.8, 0.8, 0.8}, art = art}
				icon:SetVertexColor(unpack(entry.color))
				mapTheme.buttons[#mapTheme.buttons + 1] = entry
				button:HookScript("OnEnter", function()
					if mapTheme.blizzard then return end -- Blizzard theme uses the game's own button art
					box:Show()
					icon:SetVertexColor(1, 1, 1)
				end)
				button:HookScript("OnLeave", function()
					box:Hide()
					icon:SetVertexColor(unpack(entry.color))
				end)
			end

			-- Set button icons (the close cross, maximise and restore icons are in Leatrix_Maps.blp)
			SetButtonIcon(WorldMapFrame.BorderFrame.CloseButton, "Leatrix_Maps.blp", 0, 0.125, 0.25, 0.375)
			SetButtonIcon(WorldMapFrame.BorderFrame.MaximizeMinimizeFrame.MaximizeButton, "Leatrix_Maps.blp", 0.125, 0.25, 0.25, 0.375)
			SetButtonIcon(WorldMapFrame.BorderFrame.MaximizeMinimizeFrame.MinimizeButton, "Leatrix_Maps.blp", 0.25, 0.375, 0.25, 0.375)

			-- Restyle quest search box to match the title bar (flat dark box filling the gap between the gold lines)
			local searchBox = QuestScrollFrame.SearchBox
			if searchBox then

				-- Hide the default rounded box art (alpha is never changed by Blizzard)
				for i, key in pairs({"Left", "Middle", "Mid", "Right"}) do
					if searchBox[key] then searchBox[key]:SetAlpha(0) end
				end

				-- Background (fills the title bar gap without covering the gold lines)
				local searchBg = searchBox:CreateTexture(nil, "BACKGROUND")
				searchBg:SetPoint("TOPLEFT", -4, -1)
				searchBg:SetPoint("BOTTOMRIGHT", 0, 0)

				-- Set background color (slightly lighter while typing, colors are set by the map theme)
				local function SetSearchBg(focused)
					local color = focused and mapTheme.searchFocused or mapTheme.searchNormal
					if color then
						searchBg:SetColorTexture(color[1], color[2], color[3], 1)
					elseif focused then
						searchBg:SetColorTexture(0.13, 0.09, 0.05, 1)
					else
						searchBg:SetColorTexture(0.08, 0.05, 0.03, 1)
					end
				end
				SetSearchBg(false)
				searchBox:HookScript("OnEditFocusGained", function() SetSearchBg(true) end)
				searchBox:HookScript("OnEditFocusLost", function() SetSearchBg(false) end)
				mapTheme.SetSearchBg = function() SetSearchBg(searchBox:HasFocus()) end

			end

			----------------------------------------------------------------------
			-- Map title bar and quest count
			----------------------------------------------------------------------

			-- Function to set map title
			local function SetMapTitle()
				local mapID = WorldMapFrame.mapID
				if mapID then
					local mapInfo = C_Map.GetMapInfo(mapID)
					if mapInfo then
						titleText:SetText(mapInfo.name)
					end
				end
			end

			-- Set map title when map is changed
			hooksecurefunc(WorldMapFrame, "OnMapChanged", SetMapTitle)

			-- Function to set quest count
			local function SetQuestCount()
				local numEntries, numQuests = C_QuestLog.GetNumQuestLogEntries()
				local maxQuests = Constants.QuestLogConsts.MAXIMUM_NUM_QUESTS_LOG_CAN_ACCEPT
				if numQuests > maxQuests then
					questCount:SetFormattedText("%s%d|r/%d", RED_FONT_COLOR_CODE, numQuests, maxQuests)
				else
					questCount:SetFormattedText("%s%d|r/%d", "|cffffffff", numQuests, maxQuests)
				end
			end

			----------------------------------------------------------------------
			-- Map frame layout
			----------------------------------------------------------------------

			local detailsHeight, detailsScrollHeight

			-- Function to set the border and its edge in whole screen pixels (so the edge is the same width all the way
			-- round at any map scale or UI scale). The border is 1 pixel bigger than the map, then 1 pixel of black edge
			-- and 4 pixels of shadow.
			local edgeQuestWidth = 0
			local function SetPixelEdges()
				local scale = borderFrame:GetEffectiveScale()
				if issecretvalue and issecretvalue(scale) then return end -- Frame scales can be secret in combat
				local px = PixelUtil and PixelUtil.GetNearestPixelSize(1, scale, 1) or 1
				borderFrame:ClearAllPoints()
				borderFrame:SetPoint("TOPLEFT", titleFrame, "TOPLEFT", -px, px)
				local footer = mapTheme.footerFrame
				if footer and WorldMapFrame:IsMaximized() then
					-- Maximised map fills the screen so the coordinates footer goes inside the bottom of the map
					footer:ClearAllPoints()
					footer:SetPoint("BOTTOMLEFT", WorldMapFrame.ScrollContainer, "BOTTOMLEFT", 0, 0)
					footer:SetPoint("BOTTOMRIGHT", WorldMapFrame.ScrollContainer, "BOTTOMRIGHT", 0, 0)
					mapTheme.PlaceCoords(true)
					borderFrame:SetPoint("BOTTOMRIGHT", WorldMapFrame.ScrollContainer, "BOTTOMRIGHT", edgeQuestWidth + px, -px)
				elseif footer then
					-- Coordinates footer under the map and quest log (the border goes round it)
					footer:ClearAllPoints()
					footer:SetPoint("TOPLEFT", WorldMapFrame.ScrollContainer, "BOTTOMLEFT", 0, 0)
					footer:SetPoint("TOPRIGHT", WorldMapFrame.ScrollContainer, "BOTTOMRIGHT", edgeQuestWidth, 0)
					mapTheme.PlaceCoords(false)
					borderFrame:SetPoint("BOTTOMRIGHT", footer, "BOTTOMRIGHT", px, -px)
				else
					borderFrame:SetPoint("BOTTOMRIGHT", WorldMapFrame.ScrollContainer, "BOTTOMRIGHT", edgeQuestWidth + px, -px)
				end
				for i = 1, #edgeTextures do
					local out = (i == 5 and 1 or 6 - i) * px -- Edge 1 pixel out, shadow 2 to 5 pixels out
					local tex = edgeTextures[i]
					tex:ClearAllPoints()
					tex:SetPoint("TOPLEFT", borderFrame, "TOPLEFT", -out, out)
					tex:SetPoint("BOTTOMRIGHT", borderFrame, "BOTTOMRIGHT", out, -out)
				end
				-- Set the map frame clickable area to match the border (Unlock map frame adds space outside it for dragging)
				if LeaMapsLC.SetMapHitRect then LeaMapsLC.SetMapHitRect() end
			end

			-- Make an edge function available to code that changes the map scale. It sets the edge now and once more on
			-- the next frame, after the game has finished laying out the scaled map. Only one next-frame pass is queued
			-- at a time.
			local edgeQueued
			local function EdgeQueued()
				edgeQueued = nil
				SetPixelEdges()
			end
			LeaMapsLC.RefreshMapLines = function()
				SetPixelEdges()
				if not edgeQueued then
					edgeQueued = true
					C_Timer.After(0, EdgeQueued)
				end
			end

			-- Update the edge when the UI scale or resolution changes
			local edgeEvents = CreateFrame("Frame")
			edgeEvents:RegisterEvent("UI_SCALE_CHANGED")
			edgeEvents:RegisterEvent("DISPLAY_SIZE_CHANGED")
			edgeEvents:SetScript("OnEvent", function() LeaMapsLC.RefreshMapLines() end)

			-- Function to get map frame clickable area insets that match the visible border (title bar, map, quest log and
			-- coordinates footer) plus grab outside it. The map frame goes above the title bar and the footer goes below the
			-- map frame so the border is not the same size as the map frame. Returns nothing if the positions are not
			-- available yet or are secret.
			local function GetBorderInsets(grab)
				local mL, mR, mT, mB = WorldMapFrame:GetLeft(), WorldMapFrame:GetRight(), WorldMapFrame:GetTop(), WorldMapFrame:GetBottom()
				local bL, bR, bT, bB = borderFrame:GetLeft(), borderFrame:GetRight(), borderFrame:GetTop(), borderFrame:GetBottom()
				if not (mL and mR and mT and mB and bL and bR and bT and bB) then return end
				if issecretvalue then
					for void, v in ipairs({mL, mR, mT, mB, bL, bR, bT, bB}) do
						if issecretvalue(v) then return end -- Can be secret in combat
					end
				end
				return bL - mL - grab, mR - bR - grab, mT - bT - grab, bB - mB - grab
			end
			mapTheme.GetBorderInsets = GetBorderInsets -- Used by Unlock map frame

			-- Set the map frame clickable area to match the visible border, so there is no clickable space outside it
			-- (Unlock map frame replaces this when it's on). It's set now and once more on the next frame, after the game
			-- has finished laying out the map (only one next-frame pass is queued at a time).
			local function SetBorderHitRect()
				if not LeaMapsLC:CanChangeMap() then return end
				local left, right, top, bottom = GetBorderInsets(0)
				if left then WorldMapFrame:SetHitRectInsets(left, right, top, bottom) end
			end
			local borderHitQueued
			local function BorderHitQueued()
				borderHitQueued = nil
				SetBorderHitRect()
			end
			LeaMapsLC.SetMapHitRect = function()
				SetBorderHitRect()
				if not borderHitQueued then
					borderHitQueued = true
					C_Timer.After(0, BorderHitQueued)
				end
			end

			-- Function to set map frame layout
			local function SetFrameLayout()

				-- Get quest log width (if it's shown)
				local questWidth = 0
				if QuestMapFrame:IsShown() then questWidth = WorldMapFrame.questLogWidth end

				-- Set title bar and border to cover the map and quest log
				titleFrame:ClearAllPoints()
				titleFrame:SetPoint("BOTTOMLEFT", WorldMapFrame.ScrollContainer, "TOPLEFT", 0, 0)
				titleFrame:SetPoint("BOTTOMRIGHT", WorldMapFrame.ScrollContainer, "TOPRIGHT", questWidth, 0)
				edgeQuestWidth = questWidth
				SetPixelEdges()

				-- Center map title over the map (the quest log part of the title bar is used by the search box)
				titleText:ClearAllPoints()
				titleText:SetPoint("CENTER", titleFrame, "CENTER", -questWidth / 2, 0)

				-- Move filter button inside the map (it's anchored to the navigation bar which is hidden)
				local filterButton = WorldMapFrame.WorldMapTrackingOptionsButton
				if filterButton and CanChange(filterButton) then
					filterButton:ClearAllPoints()
					filterButton:SetPoint("TOPRIGHT", WorldMapFrame.ScrollContainer, "TOPRIGHT", -4, -2)
				end

				-- Move close button to the right of the title bar
				local closeButton = WorldMapFrame.BorderFrame.CloseButton
				if CanChange(closeButton) then
					closeButton:ClearAllPoints()
					-- Blizzard theme: like the default map, the button sits flush with the outer edge of the border and is centered
					-- on the whole title bar including the metal edge above it
					if mapTheme.blizzard then
						closeButton:SetPoint("RIGHT", titleFrame, "RIGHT", 6, 2)
					else
						closeButton:SetPoint("RIGHT", titleFrame, "RIGHT", -2, 0)
					end
					closeButton:SetFrameLevel(frameLevel + 5)
				end

				-- Show maximise button in the title bar (it's anchored to the left of the close button)
				local maxButton = WorldMapFrame.BorderFrame.MaximizeMinimizeFrame
				if CanChange(maxButton) then
					maxButton:ClearAllPoints()
					maxButton:SetPoint("RIGHT", closeButton, "LEFT", mapTheme.blizzard and -3 or -2, 0)
					maxButton:SetFrameLevel(frameLevel + 6)
					for i, v in pairs({maxButton:GetChildren()}) do
						v:SetFrameLevel(frameLevel + 7)
					end
				end

				if QuestMapFrame:IsShown() and CanChange(QuestScrollFrame) then

					-- Move quest list under the title bar (so it's the same height as the map)
					QuestScrollFrame:ClearAllPoints()
					QuestScrollFrame:SetPoint("TOPLEFT", QuestScrollFrame:GetParent(), "TOPLEFT", 0, -50)
					QuestScrollFrame:SetPoint("BOTTOMRIGHT", QuestScrollFrame:GetParent(), "BOTTOMRIGHT", 0, 0)

					-- Move quest details under the title bar and shorten it so the bottom stays in place
					local detailsFrame = QuestMapFrame.DetailsFrame
					if CanChange(detailsFrame) and CanChange(detailsFrame.ScrollFrame) then
						if not detailsHeight then
							detailsHeight = detailsFrame:GetHeight()
							detailsScrollHeight = detailsFrame.ScrollFrame:GetHeight()
						end
						detailsFrame:ClearAllPoints()
						detailsFrame:SetPoint("TOPRIGHT", detailsFrame:GetParent(), "TOPRIGHT", 0, -47)
						detailsFrame:SetHeight(detailsHeight - 46)
						detailsFrame.ScrollFrame:SetHeight(detailsScrollHeight - 46)
						detailsFrame.Bg:SetPoint("BOTTOMLEFT", detailsFrame, "BOTTOMLEFT", 0, 0)
						detailsFrame.Bg:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", 0, 0)
					end

					-- Move quest settings button to the left of the close button
					local settingsButton = QuestScrollFrame.SettingsDropdown
					if CanChange(settingsButton) and CanChange(maxButton) then
						settingsButton:ClearAllPoints()
						settingsButton:SetPoint("RIGHT", maxButton, "LEFT", -2, 0)
						settingsButton:SetFrameLevel(frameLevel + 5)
					end

					-- Move quest search box into the title bar (from the left of the quest log to the settings button)
					local searchBox = QuestScrollFrame.SearchBox
					if searchBox and CanChange(searchBox) and CanChange(settingsButton) then
						searchBox:ClearAllPoints()
						searchBox:SetPoint("LEFT", titleFrame, "RIGHT", -questWidth + 10, 1)
						searchBox:SetPoint("RIGHT", settingsButton, "LEFT", -6, 1)
						searchBox:SetHeight(17)
						searchBox:SetFrameLevel(frameLevel + 5)
					end

				end

			end

			-- Set map frame layout when map is shown, quest log is toggled and on startup
			WorldMapFrame:HookScript("OnShow", function()
				SetQuestCount()
				SetFrameLayout()
			end)
			hooksecurefunc(WorldMapFrame, "OnFrameSizeChanged", SetFrameLayout)
			QuestMapFrame:HookScript("OnShow", SetFrameLayout)
			QuestMapFrame:HookScript("OnHide", SetFrameLayout)
			SetFrameLayout()
			SetQuestCount()

			-- Set quest count when quest log is updated and set map after combat
			local mapEvents = CreateFrame("Frame")
			mapEvents:RegisterEvent("QUEST_LOG_UPDATE")
			mapEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
			mapEvents:SetScript("OnEvent", function(self, event)
				if event == "QUEST_LOG_UPDATE" then
					SetQuestCount()
				elseif event == "PLAYER_REGEN_ENABLED" then
					if WorldMapFrame:IsShown() then SetFrameLayout() end
				end
			end)

			----------------------------------------------------------------------
			-- Map theme
			----------------------------------------------------------------------

			-- Map themes (the theme colors the title bar and coordinates background, the edge is black). The accent color is
			-- used for the title bar buttons and zone lists, the hover color for the zone menus.
			-- Themes with a base color (color = {r, g, b}) all use the same recipe as Class color: a dark wash of the color on
			-- the title bar and the color itself for the accents, so they look like a matching set.
			-- Theme numbers are saved, so new themes are added at the end (the dropdown sets the order they are listed in).
			local mapThemes = {
				-- 1: Classic (neutral black with a muted gold accent)
				{bgBottom = {0.04, 0.04, 0.04}, bgTop = {0.09, 0.09, 0.09}, accent = {0.45, 0.37, 0.20}, hover = {1, 1, 1, 0.12}},
				-- 2: Warm (dark brown with a bronze accent)
				{bgBottom = {0.06, 0.04, 0.02}, bgTop = {0.12, 0.08, 0.045}, accent = {0.55, 0.42, 0.22}, hover = {1, 0.85, 0.6, 0.14}},
				-- 3: Charcoal (cool slate)
				{bgBottom = {0.05, 0.05, 0.06}, bgTop = {0.13, 0.13, 0.15}, accent = {0.32, 0.36, 0.42}, hover = {0.75, 0.85, 1, 0.14}},
				-- 4: Class color (base color is the player's class color, filled in when the theme is applied)
				{classColor = true},
				-- 5: Pink
				{color = {1, 0.35, 0.70}},
				-- 6: Alliance
				{color = {0.25, 0.50, 1}},
				-- 7: Horde
				{color = {0.90, 0.15, 0.10}},
				-- 8: Purple
				{color = {0.60, 0.30, 1}},
				-- 9: Teal
				{color = {0.10, 0.80, 0.75}},
				-- 10: Green
				{color = {0.30, 0.85, 0.25}},
				-- 11: Rainbow (dark rainbow from left to right, violet accent to match the right-hand end)
				{rainbow = true, bgBottom = {0.04, 0.04, 0.04}, bgTop = {0.09, 0.09, 0.09}, accent = {0.65, 0.40, 1}, hover = {1, 1, 1, 0.15}},
				-- 12: Blizzard (looks like the default map: the game's frame border art, the game's title bar buttons and
				-- tooltip style lists, the border is drawn on a frame of our own)
				{blizzard = true, bgBottom = {0, 0, 0}, bgTop = {0.08, 0.08, 0.08}, accent = {1, 0.82, 0}, hover = {1, 1, 1, 0.15}},
			}

			-- Blizzard theme border (the game's frame border art, created the first time the theme is used)
			-- The art textures belong to the border frame, which is the lowest part of the map frame, so the title bar text,
			-- zone menus, buttons, map and footer always draw above it. Only the parts of the art outside the map show (like
			-- the default map). The textures are placed by the game's frame layout using a positioning frame of our own.
			local blizzBorder, blizzPieces
			local blizzLayout = "ButtonFrameTemplateNoPortrait"

			-- Function to create the border
			local function CreateBlizzardBorder()
				blizzPieces = {}
				blizzBorder = CreateFrame("Frame", nil, borderFrame)
				-- The art sits a little outside the map frame on the left, right and bottom so the metal edge shows like the
				-- default map (the top of the art already sits above the title bar)
				-- (the bottom is moved up by the drop shadow that is cut off the bottom of the art below, so the gold line stays put)
				local shadowCrop = 4
				-- (the map draws over the inner part of the left edge art, so the left side sits further out to show the whole metal edge)
				blizzBorder:SetPoint("TOPLEFT", borderFrame, "TOPLEFT", -10, 0)
				blizzBorder:SetPoint("BOTTOMRIGHT", borderFrame, "BOTTOMRIGHT", 5, -5 + shadowCrop)
				blizzBorder:EnableMouse(false)
				-- The layout asks for each piece by name, the pieces are textures on the border frame
				function blizzBorder:GetNineSlicePiece(pieceName)
					if not blizzPieces[pieceName] then
						blizzPieces[pieceName] = borderFrame:CreateTexture(nil, "BORDER")
					end
					return blizzPieces[pieceName]
				end
				if NineSliceUtil and NineSliceUtil.ApplyLayoutByName and NineSliceUtil.GetLayout and NineSliceUtil.GetLayout(blizzLayout) then
					NineSliceUtil.ApplyLayoutByName(blizzBorder, blizzLayout)
				else
					-- Game's dialog border if the frame art layout is not in the client
					local backdrop = CreateFrame("Frame", nil, borderFrame, "BackdropTemplate")
					backdrop:SetFrameLevel(borderFrame:GetFrameLevel())
					backdrop:SetPoint("TOPLEFT", borderFrame, "TOPLEFT", -6, 6)
					backdrop:SetPoint("BOTTOMRIGHT", borderFrame, "BOTTOMRIGHT", 6, -6)
					backdrop:SetBackdrop({edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", edgeSize = 32})
					blizzPieces.backdrop = backdrop
				end
				-- The center of the art is not used (the map, title bar and footer fill it)
				if blizzPieces.Center then blizzPieces.Center:Hide() end
				-- Cut the drop shadow off the bottom of the art so the border ends at the edge of the frame (the pieces are
				-- anchored at the bottom so they keep their place, works with mirrored pieces too)
				for void, name in ipairs({"BottomEdge", "BottomLeftCorner", "BottomRightCorner"}) do
					local piece = blizzPieces[name]
					local h = piece and piece:GetHeight()
					if h and not (issecretvalue and issecretvalue(h)) and h > shadowCrop then
						local f = (h - shadowCrop) / h
						local ulx, uly, llx, lly, urx, ury, lrx, lry = piece:GetTexCoord()
						piece:SetTexCoord(ulx, uly, ulx + (llx - ulx) * f, uly + (lly - uly) * f, urx, ury, urx + (lrx - urx) * f, ury + (lry - ury) * f)
						piece:SetHeight(h - shadowCrop)
					end
				end
				-- Title bar background (the game's frame background, like the title bar of the default map)
				local titleBg = borderFrame:CreateTexture(nil, "BACKGROUND", nil, 2)
				titleBg:SetAllPoints(titleFrame)
				titleBg:SetTexture("Interface\\FrameGeneral\\UI-Background-Rock", "REPEAT", "REPEAT")
				titleBg:SetHorizTile(true)
				titleBg:SetVertTile(true)
				blizzPieces.TitleBg = titleBg
			end

			-- Function to show or hide the Blizzard theme
			local function SetBlizzard(show)
				mapTheme.blizzard = show
				if show and not blizzBorder then CreateBlizzardBorder() end
				if blizzPieces then
					for name, piece in pairs(blizzPieces) do
						if name ~= "Center" then piece:SetShown(show) end
					end
				end
				-- The art replaces the black edge and shadow around the map and the title bar background
				for i = 1, #edgeTextures do edgeTextures[i]:SetShown(not show) end
				titleTexture:SetShown(not show)
				-- Quest count and title bar buttons move in a little so they clear the border art
				questCount:ClearAllPoints()
				questCount:SetPoint("LEFT", show and 12 or 8, 0)
				-- Title bar buttons are larger for the Blizzard theme (like the default map, they overlap the border lines)
				local buttonSize = show and 26 or 20
				for void, button in ipairs({WorldMapFrame.BorderFrame.CloseButton, WorldMapFrame.BorderFrame.MaximizeMinimizeFrame}) do
					if CanChange(button) then button:SetSize(buttonSize, buttonSize) end
				end
				SetFrameLayout()
				-- Game's button art in the title bar (the flat icons are used otherwise)
				for i, entry in ipairs(mapTheme.buttons) do
					for j, v in pairs(entry.art) do v:SetAlpha(show and 1 or 0) end
					entry.icon:SetShown(not show)
					entry.box:Hide()
				end
			end

			-- Function to get the part of the Blizzard theme top border art that is behind the title bar (the brown fill with
			-- a bronze line at the bottom). Returns the texture file, the top and bottom texture rows, and the width of one
			-- tile and the height of the part on screen (nothing if the art can't be placed yet, such as before the map is shown).
			local function GetTitleArt()
				local piece = blizzPieces and blizzPieces.TopEdge
				local atlas = piece and piece.GetAtlas and piece:GetAtlas()
				local info = atlas and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas)
				if not info or not info.file or not info.width or info.width <= 0 then return end
				-- The art tiles across, so it has to use the whole width of its texture file
				if info.leftTexCoord ~= 0 or info.rightTexCoord ~= 1 then return end
				local pTop, pBottom, tTop, tBottom = piece:GetTop(), piece:GetBottom(), titleFrame:GetTop(), titleFrame:GetBottom()
				if not (pTop and pBottom and tTop and tBottom) then return end
				if issecretvalue and (issecretvalue(pTop) or issecretvalue(pBottom) or issecretvalue(tTop) or issecretvalue(tBottom)) then return end
				-- Positions on screen (the art and the title bar can have different scales)
				local pScale, tScale = piece:GetEffectiveScale(), titleFrame:GetEffectiveScale()
				pTop, pBottom, tTop, tBottom = pTop * pScale, pBottom * pScale, tTop * tScale, tBottom * tScale
				local pHeight = pTop - pBottom
				if pHeight <= 0 then return end
				-- Rows of the art that are behind the title bar
				local f1 = math.max(0, math.min(1, (pTop - tTop) / pHeight))
				local f2 = math.max(0, math.min(1, (pTop - tBottom) / pHeight))
				if f2 <= f1 then return end
				local texTop = info.topTexCoord + (info.bottomTexCoord - info.topTexCoord) * f1
				local texBottom = info.topTexCoord + (info.bottomTexCoord - info.topTexCoord) * f2
				return info.file, texTop, texBottom, info.width * pScale, (f2 - f1) * pHeight
			end

			-- Function to show the title bar art on the coordinates background, so both bars match (runs when the theme is
			-- applied and when the coordinates bar is shown or resized)
			local function SetFooterArt()
				local footerRock = mapTheme.footerRock
				if not footerRock or not footerRock:IsShown() then return end
				local file, texTop, texBottom, tileWidth = GetTitleArt()
				local width = mapTheme.footer:GetWidth()
				if not file or not width or (issecretvalue and issecretvalue(width)) then return end
				footerRock:SetHorizTile(false)
				footerRock:SetVertTile(false)
				footerRock:SetTexture(file, "REPEAT", "CLAMP")
				footerRock:SetTexCoord(0, width * mapTheme.footer:GetEffectiveScale() / tileWidth, texTop, texBottom)
			end

			-- Function to fill a zone list with the brown of the title bar (Blizzard theme). The title bar art can't be repeated
			-- down a list without its edge lines showing, so the list uses the game's frame background (which repeats without
			-- a seam) tinted to the same brown. Runs when the theme is applied.
			local function SetListArt(list)
				local frame = list.frame
				if mapTheme.blizzard and not frame.leaArtFill then
					local fill = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
					fill:SetAllPoints()
					fill:SetTexture("Interface\\FrameGeneral\\UI-Background-Rock", "REPEAT", "REPEAT")
					fill:SetHorizTile(true)
					fill:SetVertTile(true)
					fill:SetVertexColor(0.63, 0.40, 0.23)
					frame.leaArtFill = fill
				end
				if frame.leaArtFill then frame.leaArtFill:SetShown(mapTheme.blizzard == true) end
			end

			-- Rainbow colors (left to right) and how dark they are drawn so the text stays readable
			local rainbowColors = {{1, 0.15, 0.15}, {1, 0.55, 0.10}, {1, 0.90, 0.15}, {0.25, 0.90, 0.30}, {0.20, 0.50, 1}, {0.65, 0.35, 1}}
			local rainbowShade = 0.30

			-- Function to get the rainbow for a bar (created the first time the rainbow theme is used)
			-- (inset keeps the rainbow inside a border, such as the zone list's 1 pixel border)
			local function GetRainbow(bar, inset)
				if bar.leaRainbow then return bar.leaRainbow end
				inset = inset or 0
				local rainbow = {}
				local count = #rainbowColors - 1
				for i = 1, count do
					local seg = bar:CreateTexture(nil, "BACKGROUND", nil, 1)
					seg:SetTexture("Interface\\Buttons\\WHITE8X8")
					local c1, c2 = rainbowColors[i], rainbowColors[i + 1]
					seg:SetGradient("HORIZONTAL", CreateColor(c1[1] * rainbowShade, c1[2] * rainbowShade, c1[3] * rainbowShade, 1), CreateColor(c2[1] * rainbowShade, c2[2] * rainbowShade, c2[3] * rainbowShade, 1))
					if i == 1 then
						seg:SetPoint("TOPLEFT", inset, -inset); seg:SetPoint("BOTTOMLEFT", inset, inset)
					else
						seg:SetPoint("TOPLEFT", rainbow[i - 1], "TOPRIGHT"); seg:SetPoint("BOTTOMLEFT", rainbow[i - 1], "BOTTOMRIGHT")
					end
					if i == count then
						seg:SetPoint("TOPRIGHT", -inset, -inset); seg:SetPoint("BOTTOMRIGHT", -inset, inset)
					end
					rainbow[i] = seg
				end
				-- Shade the bottom of the bar like the other themes
				local shade = bar:CreateTexture(nil, "BACKGROUND", nil, 2)
				shade:SetPoint("TOPLEFT", inset, -inset); shade:SetPoint("BOTTOMRIGHT", -inset, inset)
				shade:SetTexture("Interface\\Buttons\\WHITE8X8")
				shade:SetGradient("VERTICAL", CreateColor(0, 0, 0, 0.45), CreateColor(0, 0, 0, 0))
				rainbow.shade = shade
				-- Keep the segments evenly spaced when the bar changes size (the last one fills the rest)
				local function SetWidths()
					local barWidth = bar:GetWidth()
					if issecretvalue and issecretvalue(barWidth) then return end -- Frame sizes can be secret in combat
					local width = (barWidth - inset * 2) / count
					for i = 1, count - 1 do rainbow[i]:SetWidth(width) end
				end
				bar:HookScript("OnSizeChanged", SetWidths)
				SetWidths()
				bar.leaRainbow = rainbow
				return rainbow
			end

			-- Function to get the rainbow color for a list row (rows run through the rainbow from top to bottom)
			local function RainbowRowColor(index, count)
				local pos = count > 1 and (index - 1) / (count - 1) * (#rainbowColors - 1) or 0
				local i = math.min(math.floor(pos) + 1, #rainbowColors - 1)
				local f = pos - (i - 1)
				local c1, c2 = rainbowColors[i], rainbowColors[i + 1]
				return c1[1] + (c2[1] - c1[1]) * f, c1[2] + (c2[2] - c1[2]) * f, c1[3] + (c2[3] - c1[3]) * f
			end

			-- Function to show or hide the rainbow on a bar
			local function SetRainbow(bar, show, inset)
				if not show and not bar.leaRainbow then return end
				local rainbow = GetRainbow(bar, inset)
				for i = 1, #rainbow do
					if show then rainbow[i]:Show() else rainbow[i]:Hide() end
				end
				if show then rainbow.shade:Show() else rainbow.shade:Hide() end
			end

			-- Function to apply the map theme (runs on startup and when the theme is changed, no reload needed)
			ApplyMapTheme = function()
				local theme = mapThemes[LeaMapsLC["MapTheme"]] or mapThemes[1]
				local ar, ag, ab, hr, hg, hb, ha, bgBottom, bgTop
				local r, g, b
				if theme.classColor then
					local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))] or NORMAL_FONT_COLOR
					r, g, b = color.r, color.g, color.b
				elseif theme.color then
					r, g, b = theme.color[1], theme.color[2], theme.color[3]
				end
				if r then
					-- Base color recipe (dark wash on the title bar, the color itself for the accents)
					ar, ag, ab = r * 0.85, g * 0.85, b * 0.85
					hr, hg, hb, ha = r, g, b, 0.22
					bgBottom, bgTop = CreateColor(r * 0.10, g * 0.10, b * 0.10, 1), CreateColor(r * 0.20, g * 0.20, b * 0.20, 1)
				else
					ar, ag, ab = theme.accent[1], theme.accent[2], theme.accent[3]
					hr, hg, hb, ha = theme.hover[1], theme.hover[2], theme.hover[3], theme.hover[4]
					bgBottom = CreateColor(theme.bgBottom[1], theme.bgBottom[2], theme.bgBottom[3], 1)
					bgTop = CreateColor(theme.bgTop[1], theme.bgTop[2], theme.bgTop[3], 1)
				end
				local topR, topG, topB = bgTop:GetRGB()
				-- Blizzard theme border and button art
				SetBlizzard(theme.blizzard)
				-- Title bar and coordinates background
				mapTheme.titleTexture:SetGradient("VERTICAL", bgBottom, bgTop)
				SetRainbow(mapTheme.titleBar, theme.rainbow)
				if mapTheme.footer then
					mapTheme.footerTexture:SetGradient("VERTICAL", bgBottom, bgTop)
					SetRainbow(mapTheme.footer, theme.rainbow)
					-- Blizzard theme: coordinates background matches the title bar (the part of the border art behind the title bar,
					-- created the first time it's used, the game's frame background is shown until the art can be placed)
					if theme.blizzard and not mapTheme.footerRock then
						local footerRock = mapTheme.footer:CreateTexture(nil, "BACKGROUND", nil, 2)
						footerRock:SetAllPoints()
						footerRock:SetTexture("Interface\\FrameGeneral\\UI-Background-Rock", "REPEAT", "REPEAT")
						footerRock:SetHorizTile(true)
						footerRock:SetVertTile(true)
						mapTheme.footerRock = footerRock
						mapTheme.footer:HookScript("OnShow", SetFooterArt)
						mapTheme.footer:HookScript("OnSizeChanged", SetFooterArt)
					end
					if mapTheme.footerRock then mapTheme.footerRock:SetShown(theme.blizzard == true) end
					mapTheme.footerTexture:SetShown(not theme.blizzard)
					SetFooterArt()
				end
				-- Title bar buttons (icon in a bright accent color, hover box in the accent color with a white icon)
				local brightest = math.max(ar, ag, ab)
				local boost = brightest > 0 and 1 / brightest or 1 -- Brighten so the strongest channel is full (keeps the hue)
				for i, entry in ipairs(mapTheme.buttons) do
					entry.box:SetVertexColor(ar, ag, ab, 0.6)
					entry.color = {ar * boost, ag * boost, ab * boost}
					if not entry.box:IsShown() then entry.icon:SetVertexColor(unpack(entry.color)) end
				end
				-- Quest search box (title bar color, a little lighter while typing)
				mapTheme.searchNormal = {topR + 0.04, topG + 0.04, topB + 0.04}
				mapTheme.searchFocused = {topR + 0.10, topG + 0.10, topB + 0.10}
				if mapTheme.SetSearchBg then mapTheme.SetSearchBg() end
				-- Zone menu hover
				if mapTheme.menuButtons then
					for i, button in ipairs(mapTheme.menuButtons) do
						button.Hover:SetColorTexture(hr, hg, hb, ha)
					end
				end
				-- Zone menu lists (title bar color, accent border and a highlight tinted with the hover color)
				-- (Rainbow gives the list the same rainbow as the title bar and each row its own rainbow highlight color)
				for void, list in ipairs({mapTheme.popup or false, mapTheme.dungeonPopup or false}) do
					if list then
						if theme.blizzard then
							-- Title bar brown (the brown fill is added on top), bronze border and the game's
							-- plain white menu highlight
							list:SetColors(0.13, 0.08, 0.045, 0.55, 0.42, 0.22, 1, 1, 1)
						else
							list:SetColors(topR, topG, topB, ar, ag, ab, hr + (1 - hr) * 0.3, hg + (1 - hg) * 0.3, hb + (1 - hb) * 0.3, theme.rainbow and RainbowRowColor or nil)
						end
						SetRainbow(list.frame, theme.rainbow)
						-- Title bar brown fill for the Blizzard theme
						SetListArt(list)
					end
				end
				-- Dungeon map level menu (title bar color, accent border and the zone menu hover color, tooltip colors for Blizzard)
				if mapTheme.dungeonButtons then
					for i, button in ipairs(mapTheme.dungeonButtons) do
						if theme.blizzard then
							button:SetBackdropColor(0.09, 0.09, 0.19, 0.95)
							button:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
						else
							button:SetBackdropColor(topR, topG, topB, 0.95)
							button:SetBackdropBorderColor(ar, ag, ab, 1)
						end
						button.Hover:SetColorTexture(hr, hg, hb, ha)
					end
				end
			end

			-- Set theme on startup (the theme dropdown sets it when changed)
			ApplyMapTheme()

			----------------------------------------------------------------------
			-- Configuration panel
			----------------------------------------------------------------------

			-- Create configuration panel
			local simplePanel = LeaMapsLC:CreatePanel("Use simple map frame", "simplePanel")

			-- Add controls
			LeaMapsLC:MakeTx(simplePanel, "Settings", 16, -72)
			LeaMapsLC:MakeCB(simplePanel, "ShowZoneMenu", "Show zone menus", 16, -92, false, "If checked, continent and zone menus will be shown in the map title bar.|n|nThe menus cannot be used in combat.")

			-- Map theme dropdown (applies straight away)
			LeaMapsLC:CreateDropdown("MapTheme", "Map Theme", 146, "TOPLEFT", simplePanel, "TOPLEFT", 16, -152, false, {{L["Classic"], 1}, {L["Warm"], 2}, {L["Charcoal"], 3}, {L["Class Color"], 4}, {L["Alliance"], 6}, {L["Horde"], 7}, {L["Green"], 10}, {L["Teal"], 9}, {L["Purple"], 8}, {L["Pink"], 5}, {L["Rainbow"], 11}, {L["Blizzard"], 12}})
			LeaMapsCB["MapTheme"].onChange = ApplyMapTheme

			-- Back to Main Menu button click
			simplePanel.b:HookScript("OnClick", function()
				simplePanel:Hide()
				LeaMapsLC["PageF"]:Show()
			end)

			-- Reset button click
			simplePanel.r:HookScript("OnClick", function()
				LeaMapsLC["ShowZoneMenu"] = "On"
				LeaMapsLC["MapTheme"] = 1
				ApplyMapTheme()
				if LeaMapsLC.SetZoneMenus then LeaMapsLC.SetZoneMenus() end
				simplePanel:Hide(); simplePanel:Show()
			end)

			-- Show configuration panel when configuration button is clicked
			LeaMapsCB["SimpleMapFrameBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaMapsLC["ShowZoneMenu"] = "On"
					if LeaMapsLC.SetZoneMenus then LeaMapsLC.SetZoneMenus() end
					LeaMapsLC["MapTheme"] = 1
					ApplyMapTheme()
					if simplePanel:IsShown() then simplePanel:Hide(); simplePanel:Show(); end
				else
					simplePanel:Show()
					LeaMapsLC["PageF"]:Hide()
				end
			end)

		end

		----------------------------------------------------------------------
		-- Show zone menus (simple map frame only)
		----------------------------------------------------------------------

		if LeaMapsLC["SimpleMapFrame"] == "On" and not LeaLockList["SimpleMapFrame"] then

			-- The menus can be turned on and off at any time, including in combat (they only use frames of our own).
			-- Nothing is created until the menus are turned on for the first time.

			local zoneMenusReady, updateZoneMenus

			local function SetupZoneMenus()

				-- Maps are changed with C_Map.OpenWorldMap which fires WORLD_MAP_OPEN. Blizzard's own event handler then changes
				-- the map in secure code so the map is never tainted (calling WorldMapFrame:SetMapID from here would taint it).
				-- C_Map.OpenWorldMap cannot be used in combat so the menus are disabled during combat.

				local continents, continentByID, continentByName = {}, {}, {}
				local selectedContinent, selectedZone, listsBuilt
				local dungeonsEntry -- Dungeons entry in the continent menu (the zone menu lists the dungeon maps, show dungeon maps option)

				-- Create menu holder (in the title bar after the quest count, the map title is hidden while the menus show)
				local titleFrame, titleText = LeaMapsCB["MapTitleFrame"], LeaMapsCB["MapTitleText"]
				local holder = CreateFrame("Frame", nil, titleFrame)
				holder:SetHeight(20)
				holder:SetPoint("LEFT", LeaMapsCB["MapQuestCount"], "RIGHT", 4, 0)
				holder:SetFrameLevel(titleFrame:GetFrameLevel() + 3)
				holder:Hide()

				-- Function to create a divider line (separates the quest count and the menus)
				local function CreateDivider()
					local divider = holder:CreateTexture(nil, "ARTWORK")
					divider:SetColorTexture(0.4, 0.4, 0.4, 1)
					divider:SetSize(1, 12)
					return divider
				end

				-- Function to create a title bar menu button (map name, highlighted on hover)
				local function CreateMenuButton()
					local button = CreateFrame("Button", nil, holder)
					button:SetHeight(20)
					button.Hover = button:CreateTexture(nil, "BACKGROUND")
					button.Hover:SetAllPoints()
					button.Hover:SetColorTexture(1, 1, 1, 0.2)
					button.Hover:Hide()
					button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
					button.Text:SetPoint("LEFT", 6, 0)
					button.Text:SetWordWrap(false)
					button.Text:SetJustifyH("LEFT")
					button:SetScript("OnEnter", function(self)
						if self:IsEnabled() then self.Hover:Show() end
					end)
					button:SetScript("OnLeave", function(self)
						self.Hover:Hide()
					end)
					button:SetScript("OnDisable", function(self)
						self.Hover:Hide()
						self.Text:SetTextColor(DISABLED_FONT_COLOR:GetRGB())
					end)
					button:SetScript("OnEnable", function(self)
						self.Text:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
					end)
					return button
				end

				-- Function to set a button's text and fit the button to it (or to a fixed width if given, long names are cut short)
				local function SetButtonText(button, text, fixedWidth)
					button.Text:SetWidth(0)
					button.Text:SetText(text)
					local width = fixedWidth or math.min(button.Text:GetStringWidth(), 200)
					button.Text:SetWidth(width)
					button:SetWidth(width + 12)
				end

				-- Continent menu width (fits the longest continent name so the zone menu stays in the same place)
				local contWidth

				-- Create continent and zone menus (quest count | continent | zone)
				local contDivider = CreateDivider()
				contDivider:SetPoint("LEFT", holder, "LEFT", 4, 0)

				local contMenu = CreateMenuButton()
				contMenu:SetPoint("LEFT", contDivider, "RIGHT", 4, 0)

				local zoneDivider = CreateDivider()
				zoneDivider:SetPoint("LEFT", contMenu, "RIGHT", 4, 0)

				local zoneMenu = CreateMenuButton()
				zoneMenu:SetPoint("LEFT", zoneDivider, "RIGHT", 4, 0)

				-- Give the menu buttons the theme hover color
				mapTheme.menuButtons = {contMenu, zoneMenu}

				-- Function to sort entries by name
				local function SortByName(a, b) return a.name < b.name end

				-- Function to create a list entry (the first zone in each list is the continent itself)
				local function CreateEntry(mapID, name)
					local entry = {mapID = mapID, name = name, zoneByID = {}, zoneByName = {}}
					entry.zones = {{mapID = mapID, name = name}}
					return entry
				end

				-- Function to build the continent and zone lists (done once, the first time the map is shown)
				local function BuildLists()
					listsBuilt = true

					-- Continents (top-level continents in Cosmic and Azeroth, duplicate names keep the one with the most zones)
					local children = {}
					for i, rootID in ipairs({946, 947}) do
						local list = C_Map.GetMapChildrenInfo(rootID)
						if list then
							for j, info in ipairs(list) do
								if info.mapID ~= 947 and (info.mapType == Enum.UIMapType.Continent or info.mapType == Enum.UIMapType.World) then
									children[#children + 1] = info
								end
							end
						end
					end
					do
						for i, info in ipairs(children) do
							local entry = CreateEntry(info.mapID, info.name)
							local zones = C_Map.GetMapChildrenInfo(info.mapID, Enum.UIMapType.Zone)
							if zones then
								local list = {}
								for j, zoneInfo in ipairs(zones) do
									-- Duplicate zone names (such as phased versions) keep the lowest map ID
									local existing = entry.zoneByName[zoneInfo.name]
									if not existing then
										local zone = {mapID = zoneInfo.mapID, name = zoneInfo.name}
										list[#list + 1] = zone
										entry.zoneByName[zoneInfo.name] = zone
										entry.zoneByID[zoneInfo.mapID] = zone
									elseif zoneInfo.mapID < existing.mapID then
										entry.zoneByID[existing.mapID] = nil
										existing.mapID = zoneInfo.mapID
										entry.zoneByID[zoneInfo.mapID] = existing
									end
								end
								table.sort(list, SortByName)
								for j = 1, #list do
									entry.zones[#entry.zones + 1] = list[j]
								end
							end
							if #entry.zones > 1 then
								local existing = continentByName[info.name]
								if not existing or #entry.zones > #existing.zones then
									continentByName[info.name] = entry
								end
							end
						end
					end
					for name, entry in pairs(continentByName) do
						continents[#continents + 1] = entry
						continentByID[entry.mapID] = entry
					end
					table.sort(continents, SortByName)

					-- Azeroth and Cosmic go at the end (they have no zones)
					for i, mapID in ipairs({947, 946}) do
						local info = C_Map.GetMapInfo(mapID)
						if info then
							local entry = CreateEntry(mapID, info.name)
							continents[#continents + 1] = entry
							continentByID[mapID] = entry
						end
					end

					-- Dungeons entry at the end (the zone menu lists the dungeon maps)
					if LeaMapsLC.GetDungeonList then
						dungeonsEntry = {name = L["Dungeons"], isDungeons = true, zoneByID = {}, zoneByName = {}, zones = {}, byInstance = {}}
						for i, dungeon in ipairs(LeaMapsLC.GetDungeonList()) do
							local zone = {name = dungeon.name, instanceID = dungeon.id}
							dungeonsEntry.zones[#dungeonsEntry.zones + 1] = zone
							dungeonsEntry.byInstance[dungeon.id] = zone
						end
						table.sort(dungeonsEntry.zones, SortByName)
						continents[#continents + 1] = dungeonsEntry
					end

				end

				-- Function to find the continent and zone for a map (walks up the map parents)
				local function FindSelection(mapID)
					local below
					for i = 1, 20 do
						local info = mapID and C_Map.GetMapInfo(mapID)
						if not info then return end
						local continent = continentByID[mapID] or ((info.mapType == Enum.UIMapType.Continent or info.mapType == Enum.UIMapType.World) and continentByName[info.name])
						if continent then
							local zone = below and (continent.zoneByID[below.mapID] or continent.zoneByName[below.name]) or continent.zones[1]
							return continent, zone
						end
						below = info
						mapID = info.parentMapID
					end
				end

				-- Function to change the map (taint-free, not available in combat)
				local function OpenMap(mapID)
					if InCombatLockdown() then return end
					if mapID and mapID ~= WorldMapFrame:GetMapID() then
						C_Map.OpenWorldMap(mapID)
					end
				end

				-- Continent and zone lists (see LeaMapsLC:CreatePopupList, colors are set by the map theme)
				local popup = LeaMapsLC:CreatePopupList(WorldMapFrame)
				mapTheme.popup = popup
				if ApplyMapTheme then ApplyMapTheme() end
				local function IsCurrentContinent(entry) return entry == selectedContinent end
				local function IsCurrentZone(entry) return entry == selectedZone end

				-- Function to choose a list entry (a map, a dungeon map, or the Dungeons entry which shows the last dungeon map)
				-- (dungeon maps are frames of our own shown over the map so the map itself is not changed)
				local lastDungeon
				local function ChooseMap(entry)
					if entry.isDungeons then
						local zone = lastDungeon or entry.zones[1]
						if zone then LeaMapsLC.ShowDungeonPreview(zone.instanceID) end
					elseif entry.instanceID then
						lastDungeon = entry
						LeaMapsLC.ShowDungeonPreview(entry.instanceID)
					else
						if LeaMapsLC.GetDungeonPreview and LeaMapsLC.GetDungeonPreview() then LeaMapsLC.EndDungeonPreview() end
						OpenMap(entry.mapID)
					end
				end

				-- Open or close the lists when the menu buttons are clicked
				contMenu:SetScript("OnClick", function(self)
					if InCombatLockdown() then return end
					popup:Toggle(self, continents, IsCurrentContinent, ChooseMap, "TOPLEFT", "BOTTOMLEFT", 0, -2)
				end)

				zoneMenu:SetScript("OnClick", function(self)
					if InCombatLockdown() or not selectedContinent then return end
					popup:Toggle(self, selectedContinent.zones, IsCurrentZone, ChooseMap, "TOPLEFT", "BOTTOMLEFT", 0, -2)
				end)

				-- Function to enable or disable the menus (they are disabled in combat)
				local function SetMenusEnabled(inCombat)
					if inCombat then popup:Close() end
					contMenu:SetEnabled(not inCombat)
					zoneMenu:SetEnabled(not inCombat)
				end

				-- Function to update the menus to match the map that is showing
				local function HideMenus()
					popup:Close()
					holder:Hide()
					titleText:SetAlpha(1)
				end

				local function UpdateMenus()
					-- Menus turned off
					if LeaMapsLC["ShowZoneMenu"] ~= "On" then
						HideMenus()
						return
					end
					-- Build lists the first time they are needed while the map is showing
					if not listsBuilt then
						if not WorldMapFrame:IsShown() then return end
						BuildLists()
					end
					local previewID = LeaMapsLC.GetDungeonPreview and LeaMapsLC.GetDungeonPreview()
					if previewID and dungeonsEntry and dungeonsEntry.byInstance[previewID] then
						-- A dungeon map is showing so show Dungeons and the dungeon
						selectedContinent, selectedZone = dungeonsEntry, dungeonsEntry.byInstance[previewID]
						lastDungeon = selectedZone
					else
						selectedContinent, selectedZone = FindSelection(WorldMapFrame:GetMapID())
					end
					if not selectedContinent then
						HideMenus()
						return
					end

					-- Continent menu, then the zone menu if the continent has zones (it says Zones while the continent map shows)
					popup:Close()
					if not contWidth then
						contWidth = 0
						for i = 1, #continents do
							contMenu.Text:SetWidth(0)
							contMenu.Text:SetText(continents[i].name)
							contWidth = math.max(contWidth, contMenu.Text:GetStringWidth())
						end
						contWidth = math.min(math.ceil(contWidth), 200)
					end
					SetButtonText(contMenu, selectedContinent.name, contWidth)
					if #selectedContinent.zones > 1 then
						if selectedZone and (selectedContinent.isDungeons or selectedZone ~= selectedContinent.zones[1]) then
							SetButtonText(zoneMenu, selectedZone.name)
						else
							SetButtonText(zoneMenu, L["Zones"])
						end
						zoneDivider:Show()
						zoneMenu:Show()
						holder:SetWidth(9 + contMenu:GetWidth() + 9 + zoneMenu:GetWidth())
					else
						zoneDivider:Hide()
						zoneMenu:Hide()
						holder:SetWidth(9 + contMenu:GetWidth())
					end

					-- Show the menus in place of the map title
					titleText:SetAlpha(0)
					holder:Show()
					SetMenusEnabled(InCombatLockdown())
				end

				-- Update menus when the map changes (runs after Blizzard's code has finished)
				hooksecurefunc(WorldMapFrame, "OnMapChanged", UpdateMenus)

				-- Update menus when the map is shown
				WorldMapFrame:HookScript("OnShow", UpdateMenus)

				-- Disable menus during combat
				holder:RegisterEvent("PLAYER_REGEN_DISABLED")
				holder:RegisterEvent("PLAYER_REGEN_ENABLED")
				holder:SetScript("OnEvent", function(self, event)
					SetMenusEnabled(event == "PLAYER_REGEN_DISABLED")
				end)

				updateZoneMenus = UpdateMenus
				LeaMapsLC.UpdateZoneMenus = UpdateMenus -- Used when a dungeon map preview starts or ends

			end

			-- Function to turn the menus on or off
			local function SetZoneMenus()
				if LeaMapsLC["ShowZoneMenu"] == "On" and not zoneMenusReady then
					zoneMenusReady = true
					SetupZoneMenus()
				end
				if updateZoneMenus then updateZoneMenus() end
			end

			-- Set menus when the option is clicked (and from the panel reset button) and on startup
			LeaMapsCB["ShowZoneMenu"]:HookScript("OnClick", SetZoneMenus)
			LeaMapsLC.SetZoneMenus = SetZoneMenus
			SetZoneMenus()

		end

		----------------------------------------------------------------------
		-- Show dungeon maps
		----------------------------------------------------------------------

		if LeaMapsLC["ShowDungeonMaps"] == "On" then

			-- Map art: [instance map ID] = {{map ID, level name, game map texture}, ...}
			-- Maps that are not in the game use {map ID, level name, nil, x, y, nil, height} in Leatrix_Maps_Dungeon_Art (2048x4096, maps are 1024 wide and 683 high unless a height is given)
			-- Scholomance is not in the game in its classic layout so its maps are in Leatrix_Maps_Dungeon_Art too
			local dungeonArt = {
				[389] = {{213, nil, "Ragefire\\Ragefire1_"}}, -- Ragefire Chasm
				[36] = {{291, nil, "TheDeadmines\\TheDeadmines1_"}, {292, L["Ironclad Cove"], "TheDeadmines\\TheDeadmines2_"}}, -- The Deadmines
				[43] = {{279, nil, "WailingCaverns\\WailingCaverns1_"}}, -- Wailing Caverns
				[33] = {{310, L["The Courtyard"], "ShadowfangKeep\\ShadowfangKeep1_"}, {311, L["Dining Hall"], "ShadowfangKeep\\ShadowfangKeep2_"}, {312, L["The Vacant Den"], "ShadowfangKeep\\ShadowfangKeep3_"}, {313, L["Lower Observatory"], "ShadowfangKeep\\ShadowfangKeep4_"}, {314, L["Upper Observatory"], "ShadowfangKeep\\ShadowfangKeep5_"}, {316, L["The Wall Walk"], "ShadowfangKeep\\ShadowfangKeep7_"}, {315, L["Lord Godfrey's Chamber"], "ShadowfangKeep\\ShadowfangKeep6_"}}, -- Shadowfang Keep
				[34] = {{225, nil, "TheStockade\\TheStockade1_"}}, -- The Stockade
				[48] = {{221, L["The Pool of Ask'Ar"], "BlackFathomDeeps\\BlackFathomDeeps1_"}, {222, L["Moonshrine Sanctum"], "BlackFathomDeeps\\BlackFathomDeeps2_"}, {223, L["The Forgotten Pool"], "BlackFathomDeeps\\BlackFathomDeeps3_"}}, -- Blackfathom Deeps
				[90] = {{226, L["The Hall of Gears"], "Gnomeregan\\Gnomeregan1_"}, {227, L["The Dormitory"], "Gnomeregan\\Gnomeregan2_"}, {228, L["Launch Bay"], "Gnomeregan\\Gnomeregan3_"}, {229, L["Tinkers' Court"], "Gnomeregan\\Gnomeregan4_"}}, -- Gnomeregan
				[47] = {{301, nil, "RazorfenKraul\\RazorfenKraul1_"}}, -- Razorfen Kraul
				[189] = {{302, L["Graveyard"], "ScarletMonastery\\ScarletMonastery1_"}, {303, L["Library"], "ScarletMonastery\\ScarletMonastery2_"}, {304, L["Armory"], "ScarletMonastery\\ScarletMonastery3_"}, {305, L["Cathedral"], "ScarletMonastery\\ScarletMonastery4_"}}, -- Scarlet Monastery
				[129] = {{300, nil, "RazorfenDowns\\RazorfenDowns1_"}}, -- Razorfen Downs
				[70] = {{230, L["Hall of the Keepers"], "Uldaman\\Uldaman1_"}, {231, L["Khaz'Goroth's Seat"], "Uldaman\\Uldaman2_"}}, -- Uldaman
				[209] = {{219, nil, "ZulFarrak\\ZulFarrak"}}, -- Zul'Farrak
				[349] = {{280, L["Caverns of Maraudon"], "Maraudon\\Maraudon1_"}, {281, L["Zaetar's Grave"], "Maraudon\\Maraudon2_"}}, -- Maraudon
				[109] = {{220, nil, "TheTempleOfAtalHakkar\\TheTempleOfAtalHakkar1_"}}, -- Temple of Atal'Hakkar
				[230] = {{242, L["Detention Block"], "BlackrockDepths\\BlackrockDepths1_"}, {243, L["Shadowforge City"], "BlackrockDepths\\BlackrockDepths2_"}}, -- Blackrock Depths
				[229] = {{250, L["Tazz'Alor"], "BlackrockSpire\\BlackrockSpire1_"}, {251, L["Skitterweb Tunnels"], "BlackrockSpire\\BlackrockSpire2_"}, {252, L["Hordemar City"], "BlackrockSpire\\BlackrockSpire3_"}, {253, L["Hall of Blackhand"], "BlackrockSpire\\BlackrockSpire4_"}, {254, L["Halycon's Lair"], "BlackrockSpire\\BlackrockSpire5_"}, {255, L["Chamber of Battle"], "BlackrockSpire\\BlackrockSpire6_"}}, -- Blackrock Spire
				[409] = {{232, nil, "MoltenCore\\MoltenCore1_"}}, -- Molten Core
				[469] = {{287, L["Dragonmaw Garrison"], "BlackwingLair\\BlackwingLair1_"}, {288, L["Halls of Strife"], "BlackwingLair\\BlackwingLair2_"}, {289, L["Crimson Laboratories"], "BlackwingLair\\BlackwingLair3_"}, {290, L["Nefarian's Lair"], "BlackwingLair\\BlackwingLair4_"}}, -- Blackwing Lair
				[429] = {{235, L["Gordok Commons"], "DireMaul\\DireMaul1_"}, {236, L["Capital Gardens"], "DireMaul\\DireMaul2_"}, {237, L["Court of the Highborne"], "DireMaul\\DireMaul3_"}, {238, L["Prison of Immol'Thar"], "DireMaul\\DireMaul4_"}, {239, L["Warpwood Quarter"], "DireMaul\\DireMaul5_"}, {240, L["The Shrine of Eldretharr"], "DireMaul\\DireMaul6_"}}, -- Dire Maul
				[289] = {{306, L["The Reliquary"], nil, 0, 0}, {307, L["Chamber of Summoning"], nil, 1024, 0}, {308, L["The Upper Study"], nil, 0, 683}, {309, L["Headmaster's Study"], nil, 1024, 683}}, -- Scholomance
				[329] = {{317, L["Crusader's Square"], "Stratholme\\Stratholme1_"}, {318, L["The Gauntlet"], "Stratholme\\Stratholme2_"}}, -- Stratholme
				[309] = {{233, nil, "ZulGurub\\ZulGurub"}}, -- Zul'Gurub
				[249] = {{248, nil, "OnyxiasLair\\OnyxiasLair1_"}}, -- Onyxia's Lair
				[509] = {{247, nil, "RuinsofAhnQiraj\\RuinsofAhnQiraj"}}, -- Ruins of Ahn'Qiraj
				[531] = {{319, L["The Hive Undergrounds"], "AhnQiraj\\AhnQiraj1_"}, {320, L["The Temple Gates"], "AhnQiraj\\AhnQiraj2_"}, {321, L["Vault of C'Thun"], "AhnQiraj\\AhnQiraj3_"}}, -- Temple of Ahn'Qiraj
				[533] = {{162, L["The Construct Quarter"], "Naxxramas\\Naxxramas1_"}, {163, L["The Arachnid Quarter"], "Naxxramas\\Naxxramas2_"}, {164, L["The Military Quarter"], "Naxxramas\\Naxxramas3_"}, {165, L["The Plague Quarter"], "Naxxramas\\Naxxramas4_"}, {166, L["The Lower Necropolis"], "Naxxramas\\Naxxramas5_"}, {167, L["The Upper Necropolis"], "Naxxramas\\Naxxramas6_"}}, -- Naxxramas
				-- Dungeons that are new in Forever use {map key, level name, nil, x, y, nil, height} in Leatrix_Maps_Dungeon_Art.
				-- Maps and pins are from MapUtils by D4KiR, used with permission.
				[2959] = {{"2959", L["City of Dalaran"] .. " (1)", nil, 0, 1368, nil, 684}, {"2959_2", L["City of Dalaran"] .. " (2)", nil, 1024, 1368, nil, 689}}, -- City of Dalaran
				[2998] = {{"2998", nil, nil, 0, 2060, nil, 683}}, -- Excavation Site: Wetlands
				[2999] = {{"2999", nil, nil, 1024, 2060, nil, 683}}, -- The Ruins of Lordaeron
				[3065] = {{"3065", nil, nil, 0, 2752, nil, 683}}, -- The Hall of Thanes
			}

			-- Game maps in the addon folder for game locales that do not have them (such as esMX and ruRU)
			-- [game map texture] = map number (Leatrix_Maps_Dungeon_01 to 03 are 16x16 tiles of 256 pixels, 12 tiles per map in order)
			local bundledArt = {
				["Ragefire\\Ragefire1_"] = 0,
				["TheDeadmines\\TheDeadmines1_"] = 1,
				["TheDeadmines\\TheDeadmines2_"] = 2,
				["WailingCaverns\\WailingCaverns1_"] = 3,
				["ShadowfangKeep\\ShadowfangKeep1_"] = 4,
				["ShadowfangKeep\\ShadowfangKeep2_"] = 5,
				["ShadowfangKeep\\ShadowfangKeep3_"] = 6,
				["ShadowfangKeep\\ShadowfangKeep4_"] = 7,
				["ShadowfangKeep\\ShadowfangKeep5_"] = 8,
				["ShadowfangKeep\\ShadowfangKeep7_"] = 9,
				["ShadowfangKeep\\ShadowfangKeep6_"] = 10,
				["TheStockade\\TheStockade1_"] = 11,
				["BlackFathomDeeps\\BlackFathomDeeps1_"] = 12,
				["BlackFathomDeeps\\BlackFathomDeeps2_"] = 13,
				["BlackFathomDeeps\\BlackFathomDeeps3_"] = 14,
				["Gnomeregan\\Gnomeregan1_"] = 15,
				["Gnomeregan\\Gnomeregan2_"] = 16,
				["Gnomeregan\\Gnomeregan3_"] = 17,
				["Gnomeregan\\Gnomeregan4_"] = 18,
				["RazorfenKraul\\RazorfenKraul1_"] = 19,
				["ScarletMonastery\\ScarletMonastery1_"] = 20,
				["ScarletMonastery\\ScarletMonastery2_"] = 21,
				["ScarletMonastery\\ScarletMonastery3_"] = 22,
				["ScarletMonastery\\ScarletMonastery4_"] = 23,
				["RazorfenDowns\\RazorfenDowns1_"] = 24,
				["Uldaman\\Uldaman1_"] = 25,
				["Uldaman\\Uldaman2_"] = 26,
				["ZulFarrak\\ZulFarrak"] = 27,
				["Maraudon\\Maraudon1_"] = 28,
				["Maraudon\\Maraudon2_"] = 29,
				["TheTempleOfAtalHakkar\\TheTempleOfAtalHakkar1_"] = 30,
				["BlackrockDepths\\BlackrockDepths1_"] = 31,
				["BlackrockDepths\\BlackrockDepths2_"] = 32,
				["BlackrockSpire\\BlackrockSpire1_"] = 33,
				["BlackrockSpire\\BlackrockSpire2_"] = 34,
				["BlackrockSpire\\BlackrockSpire3_"] = 35,
				["BlackrockSpire\\BlackrockSpire4_"] = 36,
				["BlackrockSpire\\BlackrockSpire5_"] = 37,
				["BlackrockSpire\\BlackrockSpire6_"] = 38,
				["MoltenCore\\MoltenCore1_"] = 39,
				["BlackwingLair\\BlackwingLair1_"] = 40,
				["BlackwingLair\\BlackwingLair2_"] = 41,
				["BlackwingLair\\BlackwingLair3_"] = 42,
				["BlackwingLair\\BlackwingLair4_"] = 43,
				["DireMaul\\DireMaul1_"] = 44,
				["DireMaul\\DireMaul2_"] = 45,
				["DireMaul\\DireMaul3_"] = 46,
				["DireMaul\\DireMaul4_"] = 47,
				["DireMaul\\DireMaul5_"] = 48,
				["DireMaul\\DireMaul6_"] = 49,
				["Stratholme\\Stratholme1_"] = 50,
				["Stratholme\\Stratholme2_"] = 51,
				["ZulGurub\\ZulGurub"] = 52,
				["OnyxiasLair\\OnyxiasLair1_"] = 53,
				["RuinsofAhnQiraj\\RuinsofAhnQiraj"] = 54,
				["AhnQiraj\\AhnQiraj1_"] = 55,
				["AhnQiraj\\AhnQiraj2_"] = 56,
				["AhnQiraj\\AhnQiraj3_"] = 57,
				["Naxxramas\\Naxxramas1_"] = 58,
				["Naxxramas\\Naxxramas2_"] = 59,
				["Naxxramas\\Naxxramas3_"] = 60,
				["Naxxramas\\Naxxramas4_"] = 61,
				["Naxxramas\\Naxxramas5_"] = 62,
				["Naxxramas\\Naxxramas6_"] = 63,
			}

			-- Map pins: [map ID] = {{"entrance", x, y, type}, {"level", x, y, map ID, up}, {"boss", x, y, npc ID, name, level, display ID, style}, ...}
			local dungeonPins = {
				[213] = {
					{"entrance", 0.611, 0.072},
					{"boss", 0.564, 0.372, 11517, L["Oggleflint <Ragefire Chieftain>"], 16, 11611, 1},
					{"boss", 0.408, 0.574, 11520, L["Taragaman the Hungerer"], 16, 7970, 1},
					{"boss", 0.343, 0.814, 11518, L["Jergosh the Invoker"], 16, 11429, 1},
					{"boss", 0.422, 0.857, 11519, L["Bazzalan"], 16, 2007, 1},
				},
				[291] = {
					{"entrance", 0.297, 0.133},
					{"level", 0.655, 0.667, 292},
					{"boss", 0.364, 0.612, 644, L["Rhahk'Zor <The Foreman>"], 19, 14403, 1},
					{"boss", 0.523, 0.510, 3586, L["Miner Johnson"], 19, 556, 2},
					{"boss", 0.503, 0.863, 642, L["Sneed's Shredder / Sneed"], 20, 1269, 1},
					{"boss", 0.607, 0.572, 1763, L["Gilnid <The Smelter>"], 20, 7124, 1},
				},
				[292] = {
					{"level", 0.123, 0.883, 291, true},
					{"boss", 0.561, 0.265, 646, L["Mr. Smite <The Ship's First Mate>"], 20, 2026, 1},
					{"boss", 0.605, 0.372, 647, L["Captain Greenskin"], 20, 7113, 1},
					{"boss", 0.605, 0.447, 639, L["Edwin VanCleef <Defias Kingpin>"], 21, 2029, 1},
					{"boss", 0.668, 0.398, 645, L["Cookie <The Ship's Cook>"], 20, 1305, 1},
				},
				[279] = {
					{"entrance", 0.463, 0.590},
					{"boss", 0.307, 0.429, 3671, L["Lady Anacondra <Fanglord>"], 20, 4313, 1},
					{"boss", 0.159, 0.565, 3669, L["Lord Cobrahn <Fanglord>"], 20, 4213, 1},
					{"boss", 0.386, 0.350, 3653, L["Kresh"], 20, 5126, 1},
					{"boss", 0.190, 0.396, 3670, L["Lord Pythas <Fanglord>"], 21, 4214, 1},
					{"boss", 0.619, 0.737, 3674, L["Skum"], 21, 4203, 1},
					{"boss", 0.615, 0.534, 3673, L["Lord Serpentis <Fanglord>"], 21, 4215, 1},
					{"boss", 0.551, 0.463, 5775, L["Verdan the Everliving"], 21, 4256, 1},
					{"boss", 0.560, 0.400, 5912, L["Deviate Faerie Dragon"], 20, 1267, 2},
					{"boss", 0.344, 0.135, 3654, L["Mutanus the Devourer"], 22, 4088, 1},
				},
				[310] = {
					{"entrance", 0.705, 0.606},
					{"level", 0.367, 0.392, 311},
					{"level", 0.148, 0.866, 311},
					{"level", 0.355, 0.666, 316, true},
					{"boss", 0.667, 0.719, 3914, L["Rethilgore <The Cell Keeper>"], 20, 524, 1},
					{"boss", 0.279, 0.598, 4278, L["Commander Springvale"], 24, 3223, 1},
				},
				[311] = {
					{"level", 0.593, 0.121, 310, true},
					{"level", 0.273, 0.881, 310, true},
					{"boss", 0.303, 0.766, 3887, L["Baron Silverlaine"], 24, 3222, 1},
					{"boss", 0.472, 0.277, 3886, L["Razorclaw the Butcher"], 22, 524, 1},
				},
				[316] = {
					{"level", 0.239, 0.745, 310},
					{"level", 0.436, 0.331, 312, true},
					{"boss", 0.597, 0.824, 4279, L["Odo the Blindwatcher"], 24, 522, 1},
					{"boss", 0.690, 0.770, 3872, L["Deathsworn Captain"], 25, 3224, 2},
				},
				[312] = {
					{"level", 0.516, 0.904, 316, true},
					{"level", 0.533, 0.600, 313, true},
				},
				[313] = {
					{"level", 0.442, 0.749, 314, true},
					{"level", 0.526, 0.872, 312},
					{"boss", 0.543, 0.534, 4274, L["Fenrus the Devourer"], 25, 2352, 1},
				},
				[314] = {
					{"level", 0.437, 0.743, 315, true},
					{"level", 0.490, 0.780, 313},
				},
				[315] = {
					{"level", 0.420, 0.842, 314},
					{"boss", 0.560, 0.624, 3927, L["Wolf Master Nandos"], 25, 11179, 1},
					{"boss", 0.639, 0.200, 4275, L["Archmage Arugal"], 26, 2353, 1},
				},
				[225] = {
					{"entrance", 0.500, 0.815},
					{"boss", 0.440, 0.446, 1696, L["Targorr the Dread"], 24, 517, 1},
					{"boss", 0.691, 0.300, 1666, L["Kam Deepfury"], 27, 825, 1},
					{"boss", 0.783, 0.454, 1717, L["Hamhock"], 28, 3250, 1},
					{"boss", 0.745, 0.562, 1716, L["Bazil Thredd"], 29, 1621, 1},
					{"boss", 0.217, 0.261, 1663, L["Dextren Ward"], 26, 2149, 1},
					{"boss", 0.500, 0.210, 1720, L["Bruegal Ironknuckle"], 26, 2142, 2},
				},
				[221] = {
					{"entrance", 0.453, 0.108},
					{"level", 0.621, 0.741, 222},
					{"boss", 0.329, 0.602, 4887, L["Ghamoo-ra"], 25, 5027, 1},
					{"boss", 0.113, 0.394, 4831, L["Lady Sarevess"], 25, 4979, 1},
					{"boss", 0.543, 0.567, 6243, L["Gelihast"], 26, 1773, 1},
					{"boss", 0.614, 0.625, 12902, L["Lorgus Jett"], 26, 12822, 1},
				},
				[222] = {
					{"level", 0.477, 0.707, 223},
					{"level", 0.350, 0.290, 221},
					{"boss", 0.527, 0.817, 4832, L["Twilight Lord Kelris"], 27, 4939, 1},
					{"boss", 0.858, 0.862, 4829, L["Aku'mai"], 28, 2837, 1},
				},
				[223] = {
					{"level", 0.300, 0.612, 222, true},
					{"boss", 0.588, 0.302, 4830, L["Old Serra'kis"], 26, 1816, 1},
					{"boss", 0.234, 0.498, 12876, L["Baron Aquanis"], 28, 110, 1},
				},
				[226] = {
					{"entrance", 0.644, 0.275},
					{"level", 0.345, 0.640, 227},
					{"level", 0.470, 0.870, 227},
					{"level", 0.551, 0.440, 227},
					{"boss", 0.774, 0.664, 7361, L["Grubbis"], 32, 6533, 1},
				},
				[227] = {
					{"level", 0.245, 0.580, 228},
					{"level", 0.430, 0.830, 226, true},
					{"level", 0.640, 0.580, 226, true},
					{"boss", 0.758, 0.462, 7079, L["Viscous Fallout"], 30, 5497, 1},
				},
				[228] = {
					{"entrance", 0.870, 0.480},
					{"level", 0.488, 0.710, 229},
					{"level", 0.273, 0.308, 229},
					{"level", 0.445, 0.430, 227, true},
					{"boss", 0.432, 0.876, 6229, L["Crowd Pummeler 9-60"], 32, 6774, 1},
				},
				[229] = {
					{"level", 0.481, 0.540, 228, true},
					{"level", 0.710, 0.773, 228, true},
					{"boss", 0.655, 0.835, 6235, L["Electrocutioner 6000"], 32, 6915, 1},
					{"boss", 0.295, 0.540, 6228, L["Dark Iron Ambassador"], 41, 6669, 2},
					{"boss", 0.313, 0.293, 7800, L["Mekgineer Thermaplugg"], 34, 6980, 1},
				},
				[301] = {
					{"entrance", 0.715, 0.837},
					{"boss", 0.806, 0.514, 6168, L["Roogug"], 28, 6110, 1},
					{"boss", 0.874, 0.412, 4424, L["Aggem Thorncurse <Death's Head Prophet>"], 30, 6097, 1},
					{"boss", 0.573, 0.306, 4428, L["Death Speaker Jargba <Death's Head Captain>"], 30, 4644, 1},
					{"boss", 0.218, 0.306, 4420, L["Overlord Ramtusk"], 32, 4652, 1},
					{"boss", 0.112, 0.724, 4422, L["Agathelos the Raging"], 33, 2450, 1},
					{"boss", 0.110, 0.303, 4425, L["Blind Hunter"], 32, 4735, 2},
					{"boss", 0.079, 0.679, 4421, L["Charlga Razorflank <The Crone>"], 33, 4642, 1},
					{"boss", 0.494, 0.471, 4842, L["Earthcaller Halmgar"], 32, 6102, 2},
				},
				[302] = {
					{"entrance", 0.840, 0.830},
					{"boss", 0.721, 0.593, 3983, L["Interrogator Vishas"], 32, 2044, 1},
					{"boss", 0.243, 0.559, 4543, L["Bloodmage Thalnos"], 34, 11396, 1},
					{"boss", 0.325, 0.660, 6490, L["Azshir the Sleepless"], 33, 5534, 2},
					{"boss", 0.400, 0.460, 6488, L["Fallen Champion"], 33, 5230, 2},
					{"boss", 0.400, 0.660, 6489, L["Ironspine"], 33, 5231, 2},
				},
				[303] = {
					{"entrance", 0.130, 0.248},
					{"boss", 0.294, 0.841, 3974, L["Houndmaster Loksey"], 34, 2040, 1},
					{"boss", 0.834, 0.742, 6487, L["Arcanist Doan"], 37, 5266, 1},
				},
				[304] = {
					{"entrance", 0.610, 0.955},
					{"boss", 0.786, 0.106, 3975, L["Herod <The Scarlet Champion>"], 40, 2041, 1},
				},
				[305] = {
					{"entrance", 0.623, 0.920},
					{"boss", 0.490, 0.275, 3976, L["Scarlet Commander Mograine"], 42, 2042, 1},
					{"boss", 0.492, 0.164, 3977, L["High Inquisitor Whitemane"], 42, 2043, 1},
					{"boss", 0.554, 0.248, 4542, L["High Inquisitor Fairbanks"], 40, 2605, 1},
				},
				[300] = {
					{"entrance", 0.237, 0.190},
					{"boss", 0.470, 0.200, 7356, L["Plaguemaw the Rotting"], 40, 6124, 1},
					{"boss", 0.857, 0.465, 7357, L["Mordresh Fire Eye"], 39, 8055, 1},
					{"boss", 0.346, 0.664, 8567, L["Glutton"], 40, 7864, 1},
					{"boss", 0.529, 0.672, 7354, L["Ragglesnout"], 40, 11382, 1},
					{"boss", 0.444, 0.601, 7358, L["Amnennar the Coldbringer"], 41, 7971, 1},
					{"boss", 0.590, 0.339, 7355, L["Tuten'kash"], 40, 7845, 1},
				},
				[230] = {
					{"entrance", 0.285, 0.692},
					{"level", 0.485, 0.210, 231},
					{"entrance", 0.680, 0.725},
					{"boss", 0.532, 0.722, 6910, L["Revelosh"], 40, 5945, 1},
					{"boss", 0.585, 0.918, 6906, L["Baelog / Eric \"The Swift\" / Olaf"], 41, 5710, 1},
					{"boss", 0.475, 0.439, 7206, L["Ancient Stone Keeper"], 44, 10798, 1},
					{"boss", 0.266, 0.323, 7291, L["Galgann Firehammer"], 45, 6059, 1},
					{"boss", 0.220, 0.257, 4854, L["Grimlok <Stonevault Chieftain>"], 45, 11165, 1},
					{"boss", 0.370, 0.736, 7228, L["Ironaya"], 40, 6089, 1},
				},
				[231] = {
					{"level", 0.645, 0.410, 230, true},
					{"boss", 0.552, 0.504, 2748, L["Archaedas <Ancient Stone Watcher>"], 47, 5988, 1},
				},
				[219] = {
					{"entrance", 0.566, 0.901},
					{"boss", 0.690, 0.256, 8127, L["Antu'sul <Overseer of Sul>"], 48, 7353, 1},
					{"boss", 0.527, 0.261, 7272, L["Theka the Martyr"], 46, 6696, 1},
					{"boss", 0.442, 0.173, 7271, L["Witch Doctor Zum'rah"], 46, 6434, 1},
					{"boss", 0.255, 0.130, 7604, L["Sergeant Bly"], 45, 6433, 1},
					{"boss", 0.313, 0.408, 7795, L["Hydromancer Velratha"], 46, 6685, 1},
					{"boss", 0.423, 0.333, 7797, L["Ruuzlu"], 46, 6687, 1},
					{"boss", 0.423, 0.333, 7267, L["Chief Ukorz Sandscalp"], 48, 6439, 1},
					{"boss", 0.538, 0.373, 10082, L["Zerillis"], 45, 9293, 2},
					{"boss", 0.463, 0.578, 10080, L["Sandarr Dunereaver"], 45, 9291, 2},
					{"boss", 0.313, 0.408, 10081, L["Dustwraith"], 45, 9292, 2},
					{"boss", 0.235, 0.183, 7796, L["Nekrum Gutchewer"], 46, 6690, 1},
					{"boss", 0.334, 0.170, 7275, L["Shadowpriest Sezz'ziz"], 47, 6441, 1},
					{"boss", 0.313, 0.408, 7273, L["Gahz'rilla"], 46, 7271, 1},
				},
				[280] = {
					{"entrance", 0.768, 0.657},
					{"level", 0.145, 0.570, 281},
					{"entrance", 0.622, 0.281},
					{"boss", 0.359, 0.098, 13282, L["Noxxion"], 48, 11172, 1},
					{"boss", 0.163, 0.338, 12258, L["Razorlash"], 48, 12389, 1},
					{"boss", 0.378, 0.707, 12236, L["Lord Vyletongue"], 47, 12334, 1},
					{"boss", 0.246, 0.874, 12237, L["Meshlok the Harvester"], 48, 9014, 2},
				},
				[281] = {
					{"level", 0.295, 0.040, 280, true},
					{"boss", 0.245, 0.135, 12225, L["Celebras the Cursed"], 49, 12350, 1},
					{"boss", 0.412, 0.487, 12203, L["Landslide"], 50, 12293, 1},
					{"boss", 0.484, 0.686, 13601, L["Tinkerer Gizlock"], 50, 7125, 1},
					{"boss", 0.333, 0.771, 13596, L["Rotgrip"], 50, 13589, 1},
					{"boss", 0.259, 0.784, 12201, L["Princess Theradras"], 51, 12292, 1},
				},
				[220] = {
					{"entrance", 0.500, 0.110},
					{"boss", 0.525, 0.450, 5721, L["Dreamscythe"], 53, 7553, 1},
					{"boss", 0.470, 0.450, 5720, L["Weaver"], 51, 6375, 1},
					{"boss", 0.451, 0.585, 5713, L["Gasher"], 51, 6698, 1},
					{"boss", 0.451, 0.585, 5714, L["Loro"], 51, 6700, 1},
					{"boss", 0.451, 0.585, 5715, L["Hukku"], 52, 6702, 1},
					{"boss", 0.451, 0.585, 5712, L["Zolo"], 51, 6699, 1},
					{"boss", 0.451, 0.585, 5717, L["Mijan"], 52, 6707, 1},
					{"boss", 0.451, 0.585, 5716, L["Zul'Lor"], 52, 6701, 1},
					{"boss", 0.760, 0.370, 5710, L["Jammal'an the Prophet"], 54, 6708, 1},
					{"boss", 0.767, 0.361, 5711, L["Ogom the Wretched"], 53, 6709, 1},
					{"boss", 0.499, 0.866, 5719, L["Morphaz"], 52, 7975, 1},
					{"boss", 0.448, 0.851, 5722, L["Hazzas"], 53, 9584, 1},
					{"boss", 0.665, 0.874, 5709, L["Shade of Eranikus"], 55, 7806, 1},
					{"boss", 0.501, 0.358, 8580, L["Atal'alarion <Guardian of the Idol>"], 50, 7873, 1},
					{"boss", 0.241, 0.453, 8443, L["Avatar of Hakkar"], 49, 8053, 1},
				},
				[242] = {
					{"entrance", 0.333, 0.791},
					{"level", 0.655, 0.294, 243, true},
					{"boss", 0.494, 0.567, 9025, L["Lord Roccor"], 51, 5781, 1},
					{"boss", 0.476, 0.920, 9018, L["High Interrogator Gerstahn <Twilight's Hammer Interrogator>"], 52, 8761, 1},
					{"boss", 0.495, 0.617, 9319, L["Houndmaster Grebmar"], 52, 9212, 1},
					{"boss", 0.256, 0.526, 9016, L["Bael'Gar"], 54, 12162, 1},
					{"boss", 0.565, 0.308, 9017, L["Lord Incendius"], 55, 1204, 1},
					{"boss", 0.634, 0.206, 9056, L["Fineous Darkvire <Chief Architect>"], 54, 8704, 1},
					{"boss", 0.560, 0.667, 9024, L["Pyromancer Loregrain"], 52, 8762, 1},
					{"boss", 0.356, 0.570, 9033, L["General Angerforge"], 57, 8756, 1},
					{"boss", 0.500, 0.635, 9031, L["Anub'shiah / Eviscerator / Gorosh the Dervish / Grizzle / Hedrum the Creeper / Ok'thor the Breaker"], 56, 3004, 1},
				},
				[243] = {
					{"level", 0.595, 0.547, 242},
					{"boss", 0.595, 0.655, 9041, L["Warder Stilgiss / Verek"], 56, 9089, 1},
					{"boss", 0.364, 0.646, 8983, L["Golem Lord Argelmach"], 57, 8759, 1},
					{"boss", 0.498, 0.632, 9502, L["Phalanx"], 55, 8177, 1},
					{"boss", 0.498, 0.632, 9543, L["Ribbly Screwspigot"], 53, 8667, 1},
					{"boss", 0.498, 0.632, 9499, L["Plugger Spazzring"], 55, 8652, 1},
					{"boss", 0.539, 0.483, 9156, L["Ambassador Flamelash"], 57, 8329, 1},
					{"boss", 0.802, 0.113, 9938, L["Magmus"], 57, 12162, 1},
					{"boss", 0.535, 0.243, 9039, L["Doom'rel / Dope'rel / Hate'rel / Seeth'rel / Vile'rel / Gloom'rel / Anger'rel"], 57, 8687, 1},
					{"boss", 0.916, 0.115, 9019, L["Emperor Dagran Thaurissan"], 59, 8807, 1},
					{"boss", 0.916, 0.115, 8929, L["Princess Moira Bronzebeard <Princess of Ironforge>"], 58, 8705, 1},
					{"boss", 0.498, 0.632, 9537, L["Hurley Blackbreath"], 55, 8658, 1},
					{"boss", 0.505, 0.354, 8923, L["Panzor the Invincible"], 57, 8270, 2},
				},
				[232] = {
					{"entrance", 0.264, 0.226, "raid"},
					{"boss", 0.658, 0.376, 12118, L["Lucifron"], 9999, 13031, 3},
					{"boss", 0.689, 0.236, 11982, L["Magmadar"], 9999, 10193, 3},
					{"boss", 0.333, 0.486, 12259, L["Gehennas"], 9999, 13030, 3},
					{"boss", 0.309, 0.697, 12057, L["Garr"], 9999, 12110, 3},
					{"boss", 0.551, 0.845, 12264, L["Shazzrah"], 9999, 13032, 3},
					{"boss", 0.523, 0.775, 12056, L["Baron Geddon"], 9999, 12129, 3},
					{"boss", 0.827, 0.827, 12098, L["Sulfuron Harbinger"], 9999, 13030, 3},
					{"boss", 0.685, 0.583, 11988, L["Golemagg the Incinerator"], 9999, 11986, 3},
					{"boss", 0.839, 0.656, 12018, L["Majordomo Executus"], 9999, 12029, 3},
					{"boss", 0.558, 0.538, 11502, L["Ragnaros"], 9999, 11121, 3},
				},
				[287] = {
					{"entrance", 0.527, 0.836, "raid"},
					{"level", 0.435, 0.300, 288, true},
					{"level", 0.360, 0.130, 288, true},
					{"boss", 0.417, 0.601, 12435, L["Razorgore the Untamed"], 999, 10115, 3},
					{"boss", 0.331, 0.275, 13020, L["Vaelastrasz the Corrupt"], 999, 13992, 3},
				},
				[288] = {
					{"level", 0.525, 0.320, 287},
					{"level", 0.463, 0.198, 287},
					{"boss", 0.560, 0.780, 12017, L["Broodlord Lashlayer"], 999, 14308, 3},
				},
				[239] = {
					{"entrance", 0.070, 0.392},
					{"entrance", 0.164, 0.853},
					{"entrance", 0.954, 0.508},
					{"level", 0.505, 0.630, 240},
					{"boss", 0.122, 0.310, 14354, L["Pusillin"], 57, 7552, 1},
					{"boss", 0.439, 0.474, 11490, L["Zevrim Thornhoof"], 57, 11335, 1},
				},
				[240] = {
					{"entrance", 0.281, 0.555},
					{"level", 0.633, 0.844, 239, true},
					{"boss", 0.564, 0.284, 11492, L["Alzzin the Wildshaper"], 58, 14416, 1},
					{"boss", 0.536, 0.710, 13280, L["Hydrospawn"], 57, 5489, 1},
					{"boss", 0.576, 0.737, 14327, L["Lethtendris"], 57, 14378, 1},
				},
				[236] = {
					{"entrance", 0.935, 0.721},
					{"entrance", 0.936, 0.510},
					{"level", 0.270, 0.190, 237},
					{"level", 0.304, 0.430, 238},
					{"boss", 0.332, 0.530, 11489, L["Tendris Warpwood"], 60, 14383, 1},
					{"boss", 0.208, 0.779, 11488, L["Illyanna Ravenoak"], 60, 11270, 1},
				},
				[237] = {
					{"level", 0.415, 0.120, 236},
					{"boss", 0.338, 0.444, 11487, L["Magister Kalendris"], 60, 14384, 1},
					{"boss", 0.322, 0.143, 11467, L["Tsu'zee"], 59, 11250, 1},
				},
				[238] = {
					{"level", 0.745, 0.400, 236, true},
					{"boss", 0.349, 0.571, 11496, L["Immol'thar"], 61, 14173, 1},
					{"boss", 0.620, 0.230, 11486, L["Prince Tortheldrin"], 61, 11256, 1},
				},
				[235] = {
					{"entrance", 0.718, 0.926},
					{"boss", 0.694, 0.754, 14326, L["Guard Mol'dar"], 59, 11561, 1},
					{"boss", 0.609, 0.681, 14322, L["Stomper Kreeg <The Drunk>"], 59, 11545, 1},
					{"boss", 0.496, 0.778, 14321, L["Guard Fengus"], 59, 11561, 1},
					{"boss", 0.264, 0.570, 14323, L["Guard Slip'kik"], 59, 11561, 1},
					{"boss", 0.319, 0.496, 14325, L["Captain Kromcrush"], 61, 11564, 1},
					{"boss", 0.318, 0.263, 14324, L["Cho'Rush the Observer"], 60, 11537, 1},
					{"boss", 0.318, 0.263, 11501, L["King Gordok"], 62, 11583, 1},
				},
				[306] = {
					{"entrance", 0.390, 0.652},
				},
				[309] = {
					{"boss", 0.406, 0.884, 10508, L["Ras Frostwhisper"], 62, 7919, 1},
					{"boss", 0.674, 0.481, 10507, L["The Ravenian"], 60, 10433, 1},
					{"boss", 0.792, 0.296, 10504, L["Lord Alexei Barov"], 60, 11072, 1},
					{"boss", 0.672, 0.149, 10502, L["Lady Illucia Barov"], 60, 11835, 1},
				},
				[317] = {
					{"entrance", 0.640, 0.880},
					{"boss", 0.392, 0.287, 10808, L["Timmy the Cruel"], 58, 571, 2},
					{"entrance", 0.686, 0.880},
					{"level", 0.900, 0.330, 318, true},
					{"boss", 0.815, 0.438, 10393, L["Skul"], 58, 2606, 2},
					{"boss", 0.847, 0.454, 10558, L["Hearthsinger Forresten"], 57, 10482, 2},
					{"boss", 0.735, 0.200, 10516, L["The Unforgiven"], 57, 10771, 1},
					{"boss", 0.298, 0.405, 11032, L["Malor the Zealous"], 60, 10458, 1},
					{"boss", 0.041, 0.507, 10997, L["Cannon Master Willey"], 60, 10674, 1},
					{"boss", 0.272, 0.746, 10811, L["Archivist Galford"], 60, 10544, 1},
					{"boss", 0.204, 0.817, 10813, L["Balnazzar"], 62, 10691, 1},
				},
				[318] = {
					{"level", 0.355, 0.390, 317},
					{"level", 0.570, 0.770, 317},
					{"boss", 0.649, 0.489, 10809, L["Stonespine"], 60, 7856, 2},
					{"boss", 0.745, 0.460, 10436, L["Baroness Anastari"], 59, 10698, 1},
					{"boss", 0.571, 0.459, 10437, L["Nerub'enkan"], 60, 9793, 1},
					{"boss", 0.676, 0.213, 10438, L["Maleki the Pallid"], 61, 10546, 1},
					{"boss", 0.644, 0.752, 10435, L["Magistrate Barthilas"], 58, 10433, 1},
					{"boss", 0.391, 0.201, 10440, L["Baron Rivendare"], 62, 10729, 1},
					{"boss", 0.452, 0.197, 10439, L["Ramstein the Gorger"], 61, 12818, 1},
				},
				[233] = {
					{"entrance", 0.290, 0.490, "raid"},
					{"boss", 0.390, 0.730, 14517, L["High Priestess Jeklik"], 9999, 15219, 3},
					{"boss", 0.508, 0.541, 14507, L["High Priest Venoxis"], 9999, 15217, 3},
					{"boss", 0.470, 0.770, 14510, L["High Priestess Mar'li"], 9999, 15220, 3},
					{"boss", 0.602, 0.797, 11382, L["Bloodlord Mandokir"], 9999, 11288, 3},
					{"boss", 0.597, 0.460, 15082, L["Gri'lek / Hazza'rah / Renataki / Wushoolay"], 9999, 8390, 3},
					{"boss", 0.535, 0.320, 15114, L["Gahz'ranka"], 9999, 15288, 3},
					{"boss", 0.620, 0.340, 14509, L["High Priest Thekal"], 9999, 15216, 3},
					{"boss", 0.476, 0.204, 14515, L["High Priestess Arlokk"], 9999, 15218, 3},
					{"boss", 0.316, 0.245, 11380, L["Jin'do the Hexxer"], 9999, 11311, 3},
					{"boss", 0.499, 0.394, 14834, L["Hakkar"], 9999, 15295, 3},
				},
				[248] = {
					{"entrance", 0.341, 0.205, "raid"},
					{"boss", 0.673, 0.306, 10184, L["Onyxia"], 9999, 8570, 3},
				},
				[250] = {
					{"boss", 0.523, 0.546, 9237, L["War Master Voone"], 59, 9733, 1},
				},
				[251] = {
					{"boss", 0.554, 0.692, 9236, L["Shadow Hunter Vosh'gajin"], 58, 9732, 1},
					{"boss", 0.618, 0.739, 10596, L["Mother Smolderweb"], 59, 9929, 1},
					{"boss", 0.660, 0.700, 10376, L["Crystal Fang"], 60, 9755, 2},
				},
				[252] = {
					{"boss", 0.386, 0.586, 9196, L["Highlord Omokk"], 59, 11565, 1},
				},
				[253] = {
					{"boss", 0.454, 0.550, 10584, L["Urok Doomhowl"], 60, 11583, 1},
				},
				[254] = {
					{"boss", 0.380, 0.835, 10220, L["Halycon"], 59, 9567, 1},
					{"boss", 0.420, 0.880, 10268, L["Gizrul the Slavener"], 60, 9564, 1},
					{"boss", 0.540, 0.844, 9736, L["Quartermaster Zigris"], 59, 9738, 1},
				},
				[255] = {
					{"boss", 0.575, 0.604, 9568, L["Overlord Wyrmthalak"], 60, 8711, 1},
				},
				[289] = {
					{"boss", 0.501, 0.616, 11983, L["Firemaw"], 999, 6377, 3},
					{"boss", 0.462, 0.427, 14601, L["Ebonroc"], 999, 6377, 3},
					{"boss", 0.348, 0.209, 11981, L["Flamegor"], 999, 6377, 3},
				},
				[290] = {
					{"boss", 0.354, 0.372, 14020, L["Chromaggus"], 999, 14367, 3},
					{"boss", 0.702, 0.724, 11583, L["Nefarian"], 999, 11380, 3},
				},
				[247] = {
					{"boss", 0.559, 0.356, 15348, L["Kurinnaxx"], 999, 15742, 3},
					{"boss", 0.584, 0.492, 15341, L["General Rajaxx"], 999, 15376, 3},
					{"boss", 0.699, 0.619, 15340, L["Moam"], 999, 15392, 3},
					{"boss", 0.616, 0.899, 15370, L["Buru the Gorger"], 999, 15654, 3},
					{"boss", 0.329, 0.363, 15369, L["Ayamiss the Hunter"], 999, 15431, 3},
					{"boss", 0.432, 0.691, 15339, L["Ossirian the Unscarred"], 999, 15432, 3},
				},
				[319] = {
					{"boss", 0.621, 0.224, 15263, L["The Prophet Skeram"], 999, 15345, 3},
					{"boss", 0.721, 0.177, 15543, L["Bug Trio"], 999, 15657, 3},
					{"boss", 0.445, 0.333, 15516, L["Battleguard Sartura"], 999, 15583, 3},
					{"boss", 0.434, 0.498, 15510, L["Fankriss the Unyielding"], 999, 15743, 3},
					{"boss", 0.284, 0.493, 15299, L["Viscidus"], 999, 15686, 3},
					{"boss", 0.303, 0.812, 15509, L["Princess Huhuran"], 999, 15739, 3},
					{"boss", 0.605, 0.697, 15517, L["Ouro"], 999, 15509, 3},
				},
				[320] = {
					{"boss", 0.459, 0.513, 15275, L["Twin Emperors"], 999, 15761, 3},
				},
				[321] = {
					{"boss", 0.569, 0.625, 15727, L["C'Thun"], 999, 15787, 3},
				},
				[162] = {
					{"boss", 0.616, 0.523, 16028, L["Patchwerk"], 999, 16174, 3},
					{"boss", 0.459, 0.439, 15931, L["Grobbulus"], 999, 16035, 3},
					{"boss", 0.539, 0.417, 15932, L["Gluth"], 999, 16064, 3},
					{"boss", 0.265, 0.146, 15928, L["Thaddius"], 999, 16137, 3},
				},
				[163] = {
					{"boss", 0.306, 0.466, 15956, L["Anub'Rekhan"], 999, 15931, 3},
					{"boss", 0.440, 0.359, 15953, L["Grand Widow Faerlina"], 999, 15940, 3},
					{"boss", 0.685, 0.152, 15952, L["Maexxna"], 999, 15928, 3},
				},
				[164] = {
					{"boss", 0.674, 0.595, 16061, L["Instructor Razuvious"], 999, 16582, 3},
					{"boss", 0.427, 0.454, 16060, L["Gothik the Harvester"], 999, 16279, 3},
					{"boss", 0.302, 0.766, 16064, L["The Four Horsemen"], 999, 16155, 3},
				},
				[165] = {
					{"boss", 0.347, 0.562, 15954, L["Noth the Plaguebringer"], 999, 16590, 3},
					{"boss", 0.498, 0.454, 15936, L["Heigan the Unclean"], 999, 16309, 3},
					{"boss", 0.757, 0.282, 16011, L["Loatheb"], 999, 16110, 3},
				},
				[167] = {
					{"boss", 0.565, 0.671, 15989, L["Sapphiron"], 999, 16033, 3},
					{"boss", 0.366, 0.224, 15990, L["Kel'Thuzad"], 999, 15945, 3},
				},
				[307] = {
					{"boss", 0.496, 0.101, 10506, L["Kirtonos the Herald"], 60, 7534, 1},
					{"boss", 0.620, 0.700, 10503, L["Jandice Barov"], 61, 11073, 1},
				},
				["2959"] = {
					{"level", 0.616, 0.542, "2959_2"},
					{"level", 0.513, 0.684, "2959_2"},
					{"level", 0.531, 0.365, "2959_2"},
					{"boss", 0.524, 0.840, 245999, L["Arcane Anomaly"], 30, 129891, 1},
					{"boss", 0.565, 0.230, 246020, L["Shade of the Archmage"], 33, 130061, 1},
					{"boss", 0.517, 0.551, 246003, L["Fel Ancient"], 32, 129894, 1},
					{"boss", 0.613, 0.424, 246017, L["Unstable Sentinel"], 31, 129954, 1},
					{"boss", 0.668, 0.516, 246016, L["Arcanic Enigma"], 30, 129900, 1},
					{"boss", 0.418, 0.729, 246008, L["Mana Devourer"], 31, 129895, 1},
				},
				["2959_2"] = {
					{"entrance", 0.184, 0.840},
					{"level", 0.765, 0.570, "2959", true},
					{"boss", 0.545, 0.510, 247126, L["Atrexis the Grave Knight"], 29, 145787, 1},
					{"boss", 0.680, 0.180, 247032, L["Lyn the Ignored"], 31, 130235, 2},
				},
				["2998"] = {
					{"entrance", 0.889, 0.258},
					{"boss", 0.550, 0.360, 260322, L["Saltspine"], nil, 144209, 1},
					{"boss", 0.325, 0.700, 260326, L["Relic Guardian"], nil, 144224, 1},
					{"boss", 0.305, 0.480, 260325, L["Shadetooth"], nil, 144210, 1},
					{"boss", 0.770, 0.220, 260808, L["Highland Horror"], 28, 9010, 1},
				},
				["2999"] = {
					{"entrance", 0.612, 0.216},
					{"boss", 0.704, 0.389, 250483, L["Witherfang"], 17, 144189, 1},
					{"boss", 0.606, 0.696, 250660, L["The Baron"], 17, 144188, 1},
					{"boss", 0.382, 0.670, 256035, L["Viktor the Vile"], 19, 139455, 1},
					{"boss", 0.406, 0.534, 250631, L["The Abandoned"], 18, 138667, 1},
					{"boss", 0.424, 0.385, 256097, L["Bjork"], 19, 144170, 1},
					{"boss", 0.463, 0.623, 250657, L["Rath'mael"], 20, 144175, 1},
					{"boss", 0.433, 0.269, 255699, L["Lordaeron Captain"], 19, 139050, 2},
				},
				["3065"] = {
					{"entrance", 0.511, 0.948},
					{"boss", 0.509, 0.666, 261306, L["Faldrim Anvilmar"], 16, 142826, 1},
					{"boss", 0.717, 0.465, 261316, L["Magmatus"], 16, 1070, 1},
					{"boss", 0.509, 0.516, 261311, L["Plunder"], 16, 142840, 1},
					{"boss", 0.510, 0.167, 261319, L["Durgen Dirgehammer"], 16, 142837, 1},
				},
				[308] = {
					{"boss", 0.316, 0.643, 11622, L["Rattlegore"], 61, 12073, 1},
					{"boss", 0.511, 0.143, 10433, L["Marduk Blackpool"], 58, 10248, 1},
					{"boss", 0.571, 0.143, 10432, L["Vectus"], 60, 2606, 1},
					{"boss", 0.723, 0.219, 10901, L["Lorekeeper Polkelt"], 60, 11492, 1},
					{"boss", 0.726, 0.701, 10505, L["Instructor Malicia"], 60, 11069, 1},
					{"boss", 0.888, 0.456, 11261, L["Doctor Theolen Krastinov"], 60, 10901, 1},
					{"boss", 0.680, 0.420, 1853, L["Darkmaster Gandling"], 61, 11070, 1},
				},
			}

			-- Settings
			local artPath = "Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps_Dungeon_Art"
			local pinPath = "Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps.blp"
			local bundlePath = "Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps_Dungeon_"
			local maxZoom, wheelStep = 4, 1.25
			local bossSize, rareSize, pinSize = 34, 24, 26
			local ringScale = 1.55
			local skullLevels = 10 -- Show skull if boss is this many levels above the player

			-- Boss pin styles (ring color and dragon number in pinDragons)
			local pinStyles = {
				[0] = {0.55, 0.5, 0.4},
				[1] = {0.95, 0.75, 0.25, 0},
				[2] = {0.85, 0.87, 0.95, 1},
				[3] = {0.95, 0.75, 0.25, 0},
				[4] = {0.85, 0.87, 0.95, 2},
			}

			-- Dragon texture coordinates in Leatrix_Maps.blp (gold, silver, grey)
			local pinDragons = {
				[0] = {0.5, 1, 0, 0.5},
				[1] = {0, 0.5, 0.5, 1},
				[2] = {0.5, 1, 0.5, 1},
			}

			-- Function to check for secret values (frame sizes and scales can be secret in combat)
			local function IsSecret(a, b, c)
				if not issecretvalue then return false end
				return issecretvalue(a) or issecretvalue(b) or issecretvalue(c)
			end

			-- Private tooltip so we never write to the shared GameTooltip (avoids taint)
			local tip = CreateFrame("GameTooltip", "LeaMapsDungeonTooltip", UIParent, "GameTooltipTemplate")
			tip:SetFrameStrata("TOOLTIP")

			-- Use atlas if the client has it, otherwise use the fallback texture
			local function SetIcon(texture, atlas, fallback)
				if C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas) then
					texture:SetAtlas(atlas)
				else
					texture:SetTexture(fallback)
					texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				end
			end

			-- State
			local container = WorldMapFrame.ScrollContainer
			local levels, levelIndex, instanceID, shownMapID
			local chosenLevel = {} -- Level picked by the user while the map is open
			local hiddenFor -- Instance hidden with right-click until the map is opened again
			local view = {zoom = 1, x = 0, y = 0, baseW = 0, baseH = 0}
			local pins, pinRows = {}, nil
			local Refresh, SelectLevel, HideOverlay
			local previewID, previewIndex, previewMapID -- Instance shown with /ltm dun or a dungeon icon click (and the world map it was opened on)

			-- Create overlay (covers the map canvas)
			local overlay = CreateFrame("Frame", nil, container)
			overlay:SetAllPoints()
			overlay:EnableMouse(true)
			overlay:EnableMouseWheel(true)
			if overlay.SetClipsChildren then overlay:SetClipsChildren(true) end
			overlay:Hide()

			overlay.bg = overlay:CreateTexture(nil, "BACKGROUND")
			overlay.bg:SetAllPoints()
			overlay.bg:SetColorTexture(0, 0, 0, 1)

			-- Create canvas (holds the map art and pins, sized to the art)
			local canvas = CreateFrame("Frame", nil, overlay)
			canvas.art = canvas:CreateTexture(nil, "ARTWORK")
			canvas.art:SetAllPoints()

			-- Create game map tiles (game maps are 4x3 tiles of 256 pixels showing 1002x668 pixels)
			local tiles = {}
			for i = 1, 12 do
				local tile = canvas:CreateTexture(nil, "ARTWORK")
				local col, row = (i - 1) % 4, math.floor((i - 1) / 4)
				tile.col, tile.row = col, row
				tile:SetTexCoord(0, col == 3 and 234 / 256 or 1, 0, row == 2 and 156 / 256 or 1)
				tile:Hide()
				tiles[i] = tile
			end
			local usingTiles = false
			local nativeMissing = {} -- Game map textures that are not in the client

			-- Pop-up list for the level menu and dungeon icons with several dungeons (see LeaMapsLC:CreatePopupList, the
			-- game's menus are not used over the map as they spread taint into the map's own code)
			local popup = LeaMapsLC:CreatePopupList(WorldMapFrame)
			mapTheme.dungeonPopup = popup

			-- Create level menu (a button of our own that opens the pop-up list)
			local levelMenu = CreateFrame("Button", nil, overlay, "BackdropTemplate")
			levelMenu:SetSize(230, 24)
			levelMenu:SetPoint("TOPLEFT", overlay, "TOPLEFT", 8, -8)
			levelMenu:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
			levelMenu:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
			levelMenu:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
			levelMenu.Hover = levelMenu:CreateTexture(nil, "ARTWORK")
			levelMenu.Hover:SetPoint("TOPLEFT", 1, -1)
			levelMenu.Hover:SetPoint("BOTTOMRIGHT", -1, 1)
			levelMenu.Hover:SetColorTexture(1, 1, 1, 0.12)
			levelMenu.Hover:Hide()
			levelMenu.Arrow = levelMenu:CreateTexture(nil, "OVERLAY")
			if C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("common-dropdown-a-button") then
				levelMenu.Arrow:SetAtlas("common-dropdown-a-button")
			else
				levelMenu.Arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
				levelMenu.Arrow:SetRotation(-math.pi / 2)
			end
			levelMenu.Arrow:SetSize(18, 18)
			levelMenu.Arrow:SetPoint("RIGHT", -3, 0)
			levelMenu.Text = levelMenu:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			levelMenu.Text:SetPoint("LEFT", 8, 0)
			levelMenu.Text:SetPoint("RIGHT", levelMenu.Arrow, "LEFT", -2, 0)
			levelMenu.Text:SetJustifyH("LEFT")
			levelMenu.Text:SetWordWrap(false)
			levelMenu:SetScript("OnEnter", function(self) self.Hover:Show() end)
			levelMenu:SetScript("OnLeave", function(self) self.Hover:Hide() end)
			mapTheme.dungeonButtons = {levelMenu}

			-- Function to get level name
			local function GetLevelName(info)
				if info[2] then return info[2] end
				local instanceName = instanceID and GetRealZoneText(instanceID)
				if not instanceName or instanceName == "" then instanceName = GetInstanceInfo() end
				return instanceName or ""
			end

			-- Level list entries (rebuilt each time the list opens)
			local levelEntries = {}
			local function IsCurrentLevel(entry) return entry.index == levelIndex end
			local function ChooseLevel(entry) SelectLevel(entry.index, true) end

			levelMenu:SetScript("OnClick", function(self)
				if not levels then return end
				wipe(levelEntries)
				for i, info in ipairs(levels) do
					levelEntries[i] = {index = i, name = GetLevelName(info)}
				end
				popup:Toggle(self, levelEntries, IsCurrentLevel, ChooseLevel, "TOPLEFT", "BOTTOMLEFT", 0, -2)
			end)

			-- Apply the map theme to the level menu and list (simple map frame only)
			if ApplyMapTheme then ApplyMapTheme() end

			-- Function to position pins on the canvas
			local function PlacePins()
				for i = 1, #pins do
					local pin = pins[i]
					if pin:IsShown() then
						pin:ClearAllPoints()
						pin:SetPoint("CENTER", canvas, "TOPLEFT", view.baseW * view.zoom * pin.row[2], -view.baseH * view.zoom * pin.row[3])
					end
				end
			end

			-- Function to apply zoom and pan
			local function ApplyView()
				local ow, oh = overlay:GetWidth(), overlay:GetHeight()
				if IsSecret(ow, oh) then return end
				local w, h = view.baseW * view.zoom, view.baseH * view.zoom
				local maxX = math.max(0, (w - ow) / 2)
				local maxY = math.max(0, (h - oh) / 2)
				view.x = math.min(maxX, math.max(-maxX, view.x))
				view.y = math.min(maxY, math.max(-maxY, view.y))
				canvas:SetSize(w, h)
				canvas:ClearAllPoints()
				canvas:SetPoint("CENTER", overlay, "CENTER", view.x, view.y)
				if usingTiles then
					local tw, th = w * 256 / 1002, h * 256 / 668
					for i = 1, 12 do
						local tile = tiles[i]
						tile:SetSize(tile.col == 3 and w * 234 / 1002 or tw, tile.row == 2 and h * 156 / 668 or th)
						tile:ClearAllPoints()
						tile:SetPoint("TOPLEFT", canvas, "TOPLEFT", tile.col * tw, -tile.row * th)
					end
				end
				PlacePins()
			end

			-- Function to fit the art to the overlay
			local function Layout()
				if not levels or not levelIndex then return end
				local info = levels[levelIndex]
				local ow, oh = overlay:GetWidth(), overlay:GetHeight()
				if IsSecret(ow, oh) or not ow or not oh or ow <= 0 or oh <= 0 then return end
				local ratio = info[3] and 668 / 1002 or (info[7] or 683) / 1024
				local w, h = ow, ow * ratio
				if h > oh then h = oh; w = oh / ratio end
				view.baseW, view.baseH = w, h
				ApplyView()
			end
			overlay:SetScript("OnSizeChanged", Layout)

			-- Function to get cursor position relative to overlay center
			local function GetCursorOffset()
				local scale = overlay:GetEffectiveScale()
				local cx, cy = overlay:GetCenter()
				if IsSecret(scale, cx, cy) or not cx or not scale or scale <= 0 then return end
				local x, y = GetCursorPosition()
				return x / scale - cx, y / scale - cy
			end

			-- Zoom with mouse wheel (zooms towards the cursor)
			overlay:SetScript("OnMouseWheel", function(self, delta)
				local zoom = math.min(maxZoom, math.max(1, view.zoom * wheelStep ^ delta))
				if zoom == view.zoom then return end
				local dx, dy = GetCursorOffset()
				if dx then
					local factor = zoom / view.zoom
					view.x = dx - (dx - view.x) * factor
					view.y = dy - (dy - view.y) * factor
				end
				view.zoom = zoom
				ApplyView()
			end)

			-- Pan by dragging (update script only runs while dragging)
			local drag = {}
			local function OnDragUpdate()
				if not IsMouseButtonDown("LeftButton") then
					overlay:SetScript("OnUpdate", nil)
					return
				end
				local dx, dy = GetCursorOffset()
				if not dx then return end
				view.x = drag.x + dx - drag.cx
				view.y = drag.y + dy - drag.cy
				ApplyView()
			end

			overlay:SetScript("OnMouseDown", function(self, button)
				if button ~= "LeftButton" or view.zoom <= 1 then return end
				local dx, dy = GetCursorOffset()
				if not dx then return end
				drag.cx, drag.cy, drag.x, drag.y = dx, dy, view.x, view.y
				overlay:SetScript("OnUpdate", OnDragUpdate)
			end)

			overlay:SetScript("OnMouseUp", function(self, button)
				if button == "LeftButton" then
					overlay:SetScript("OnUpdate", nil)
				elseif button == "RightButton" then
					HideOverlay()
				end
			end)

			-- Pin tooltip
			local function PinOnEnter(pin)
				local row = pin.row
				tip:SetScale(GameTooltip:GetScale())
				tip:SetOwner(pin, "ANCHOR_RIGHT")
				if row[1] == "boss" then
					tip:SetText(row[5], 1, 0.82, 0)
					if row[8] == 2 or row[8] == 4 then
						tip:AddLine(L["Rare"], 0.7, 0.8, 1)
					else
						tip:AddLine(L["Boss"], 1, 0.5, 0.25)
					end
					if row[6] then
						if row[6] >= UnitLevel("player") + skullLevels or row[8] == 3 then
							tip:AddLine(LEVEL .. " ??", 1, 0.1, 0.1)
						else
							local color = GetCreatureDifficultyColor(row[6])
							tip:AddLine(LEVEL .. " " .. row[6], color.r, color.g, color.b)
						end
					end
				elseif row[1] == "level" then
					tip:SetText(pin.levelIndex and GetLevelName(levels[pin.levelIndex]) or "", 1, 0.82, 0)
					tip:AddLine(L["Click to show this level."], 0.6, 0.6, 0.6)
				elseif row[4] == "raid" then
					tip:SetText(L["Raid entrance"], 1, 0.82, 0)
				else
					tip:SetText(L["Dungeon entrance"], 1, 0.82, 0)
				end
				tip:Show()
			end

			local function PinOnLeave(pin)
				if tip:IsOwned(pin) then tip:Hide() end
			end

			local function PinOnClick(pin, button)
				if button == "RightButton" then
					HideOverlay()
				elseif pin.row[1] == "level" and pin.levelIndex then
					PinOnLeave(pin)
					SelectLevel(pin.levelIndex, true)
				end
			end

			-- Function to add a circular mask to a texture
			local function AddMask(owner, texture)
				local mask = owner:CreateMaskTexture()
				mask:SetAllPoints(texture)
				mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
				texture:AddMaskTexture(mask)
			end

			-- Function to create a pin
			local function CreatePin()
				local pin = CreateFrame("Button", nil, canvas)
				pin:RegisterForClicks("LeftButtonUp", "RightButtonUp")
				pin.icon = pin:CreateTexture(nil, "ARTWORK")
				pin.icon:SetAllPoints()
				pin.highlight = pin:CreateTexture(nil, "HIGHLIGHT")
				pin.highlight:SetAllPoints()
				pin.highlight:SetBlendMode("ADD")
				pin.highlight:SetAlpha(0.5)

				-- Boss portrait and ring
				pin.portrait = pin:CreateTexture(nil, "ARTWORK")
				pin.portrait:SetPoint("TOPLEFT", 2, -2)
				pin.portrait:SetPoint("BOTTOMRIGHT", -2, 2)
				AddMask(pin, pin.portrait)
				pin.ring = pin:CreateTexture(nil, "OVERLAY", nil, 1)
				pin.ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
				pin.ring:SetTexCoord(0, 0.6, 0, 0.6)
				pin.ring:SetSize((bossSize - 4) * ringScale, (bossSize - 4) * ringScale)
				pin.ring:SetPoint("CENTER", pin.portrait, "CENTER")

				-- Elite and rare dragon
				local s = (bossSize - 4) / 64
				pin.dragon = pin:CreateTexture(nil, "OVERLAY", nil, 2)
				pin.dragon:SetTexture(pinPath)
				pin.dragon:SetSize(128 * s, 128 * s)
				pin.dragon:SetPoint("CENTER", pin, "CENTER", 10 * s, -20 * s)

				-- Level badge
				local badgeSize = 16 * s * 64 / 34
				pin.badge = CreateFrame("Frame", nil, pin)
				pin.badge:SetSize(badgeSize, badgeSize)
				pin.badge:SetPoint("CENTER", pin, "CENTER", 19.5 * s, -22 * s)
				pin.badge.ring = pin.badge:CreateTexture(nil, "BORDER")
				pin.badge.ring:SetAllPoints()
				pin.badge.fill = pin.badge:CreateTexture(nil, "ARTWORK")
				pin.badge.fill:SetPoint("TOPLEFT", 1.5, -1.5)
				pin.badge.fill:SetPoint("BOTTOMRIGHT", -1.5, 1.5)
				pin.badge.fill:SetColorTexture(0.05, 0.04, 0.03, 0.95)
				AddMask(pin.badge, pin.badge.ring)
				AddMask(pin.badge, pin.badge.fill)
				pin.badge.text = pin.badge:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
				pin.badge.text:SetPoint("CENTER", 0.5, 0)
				local font, _, flags = pin.badge.text:GetFont()
				if font then pin.badge.text:SetFont(font, 8, flags) end
				pin.badge.skull = pin.badge:CreateTexture(nil, "OVERLAY")
				pin.badge.skull:SetSize(badgeSize - 5, badgeSize - 5)
				pin.badge.skull:SetPoint("CENTER")
				pin.badge.skull:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Skull")

				pin:SetScript("OnEnter", PinOnEnter)
				pin:SetScript("OnLeave", PinOnLeave)
				pin:SetScript("OnClick", PinOnClick)
				return pin
			end

			-- Function to style a pin for its row
			local function StylePin(pin, row)
				local isBoss = row[1] == "boss"
				local isRare = isBoss and (row[8] == 2 or row[8] == 4)
				local size = isRare and rareSize or isBoss and bossSize or pinSize
				pin:SetSize(size, size)
				if isBoss then
					-- Scale ring and level badge to the pin size
					local s = (size - 4) / 64
					local badgeSize = 16 * s * 64 / 34
					pin.ring:SetSize((size - 4) * ringScale, (size - 4) * ringScale)
					pin.badge:SetSize(badgeSize, badgeSize)
					pin.badge:ClearAllPoints()
					pin.badge:SetPoint("CENTER", pin, "CENTER", 19.5 * s, -22 * s)
					pin.badge.skull:SetSize(badgeSize - 5, badgeSize - 5)
				end
				pin.portrait:SetShown(isBoss)
				pin.ring:SetShown(isBoss)
				pin.icon:SetShown(not isBoss)
				pin.highlight:SetShown(not isBoss)
				pin.dragon:Hide()
				pin.badge:Hide()
				if isBoss then
					if row[7] and SetPortraitTextureFromCreatureDisplayID then
						SetPortraitTextureFromCreatureDisplayID(pin.portrait, row[7])
					else
						pin.portrait:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
					end
					local style = pinStyles[row[8]] or pinStyles[0]
					-- Rares are smaller, have a silver ring and no dragon
					if isRare then
						pin.ring:SetVertexColor(0.7, 0.8, 1)
					else
						pin.ring:SetVertexColor(1, 1, 1)
					end
					if style[4] and not isRare then
						pin.dragon:SetTexCoord(unpack(pinDragons[style[4]]))
						pin.dragon:Show()
					end
					local level = row[6]
					local isSkull = row[8] == 3 or (level and level >= UnitLevel("player") + skullLevels)
					if level or isSkull then
						pin.badge.ring:SetColorTexture(style[1], style[2], style[3], 1)
						pin.badge.text:SetShown(not isSkull)
						pin.badge.skull:SetShown(isSkull)
						if not isSkull then
							local color = GetCreatureDifficultyColor(level)
							pin.badge.text:SetText(level)
							pin.badge.text:SetTextColor(color.r, color.g, color.b)
						end
						pin.badge:Show()
					end
				elseif row[1] == "entrance" then
					SetIcon(pin.icon, row[4] == "raid" and "Raid" or "Dungeon", "Interface\\Icons\\INV_Misc_Bone_Skull_02")
					SetIcon(pin.highlight, row[4] == "raid" and "Raid" or "Dungeon", "Interface\\Icons\\INV_Misc_Bone_Skull_02")
					pin.icon:SetRotation(0)
					pin.highlight:SetRotation(0)
				else
					-- Level change arrow (points up for a level above, down for a level below)
					local rotation = row[5] and 0 or math.pi
					SetIcon(pin.icon, "Garr_LevelUpgradeArrow", "Interface\\Icons\\INV_Misc_Map_01")
					SetIcon(pin.highlight, "Garr_LevelUpgradeArrow", "Interface\\Icons\\INV_Misc_Map_01")
					pin.icon:SetRotation(rotation)
					pin.highlight:SetRotation(rotation)
				end
			end

			-- Function to show pins for a map
			local function UpdatePins(mapID)
				local rows = dungeonPins[mapID]
				local count = 0
				if rows then
					-- Draw rares above other pins and bosses above rares
					for pass = 1, 3 do
						for i = 1, #rows do
							local row = rows[i]
							local index
							if row[1] == "level" then
								for j = 1, #levels do
									if levels[j][1] == row[4] then index = j; break end
								end
							end
							local rowPass = row[1] ~= "boss" and 1 or (row[8] == 2 or row[8] == 4) and 2 or 3
							if pass == rowPass and (row[1] ~= "level" or index) then
								count = count + 1
								local pin = pins[count] or CreatePin()
								pins[count] = pin
								pin.row = row
								pin.levelIndex = index
								pin:SetFrameLevel(canvas:GetFrameLevel() + count * 4)
								pin.badge:SetFrameLevel(pin:GetFrameLevel() + 2)
								StylePin(pin, row)
								pin:Show()
							end
						end
					end
				end
				for i = count + 1, #pins do
					pins[i]:Hide()
				end
			end

			-- Function to show a level
			SelectLevel = function(index, byUser)
				if not levels or not levels[index] then return end
				if byUser then chosenLevel[instanceID] = index end
				local info = levels[index]
				if levelIndex ~= index or shownMapID ~= info[1] then
					levelIndex, shownMapID = index, info[1]
					-- Use the game map (Scholomance uses map art in the addon folder)
					usingTiles = false
					local native = info[3]
					if native and not nativeMissing[native] then
						local path = "Interface\\WorldMap\\" .. native
						local fileID
						if GetFileIDFromPath then
							fileID = GetFileIDFromPath(path .. "1")
						else
							tiles[1]:SetTexture(path .. "1")
							fileID = tiles[1]:GetTextureFileID()
						end
						if fileID and fileID > 0 then
							for i = 1, 12 do
								local tile = tiles[i]
								tile:SetTexture(path .. i)
								tile:SetTexCoord(0, tile.col == 3 and 234 / 256 or 1, 0, tile.row == 2 and 156 / 256 or 1)
							end
							usingTiles = true
						else
							nativeMissing[native] = true
						end
					end
					if not usingTiles and native and bundledArt[native] then
						-- Game map is not in this game locale so use the copy in the addon folder
						local first = bundledArt[native] * 12
						for i = 1, 12 do
							local tile = tiles[i]
							local slot = (first + i - 1) % 256
							local x, y = (slot % 16) * 256, math.floor(slot / 16) * 256
							local w, h = tile.col == 3 and 234 or 256, tile.row == 2 and 156 or 256
							tile:SetTexture(bundlePath .. string.format("%02d", math.floor((first + i - 1) / 256) + 1))
							tile:SetTexCoord((x + 0.5) / 4096, (x + w - 0.5) / 4096, (y + 0.5) / 4096, (y + h - 0.5) / 4096)
						end
						usingTiles = true
					end
					if not usingTiles and not info[4] then
						-- Game map is missing from the client so show the normal map instead
						levelIndex, shownMapID = nil, nil
						overlay:Hide()
						return
					end
					for i = 1, 12 do tiles[i]:SetShown(usingTiles) end
					canvas.art:SetShown(not usingTiles)
					if not usingTiles then
						-- Maps in the addon folder (Scholomance and dungeons that are new in Forever)
						local x, y, h = info[4], info[5], info[7] or 683
						canvas.art:SetTexture(artPath)
						canvas.art:SetTexCoord((x + 0.5) / 2048, (x + 1024 - 0.5) / 2048, (y + 0.5) / 4096, (y + h - 0.5) / 4096)
					end
					view.zoom, view.x, view.y = 1, 0, 0
					UpdatePins(info[1])
					Layout()
				end
				levelMenu.Text:SetText(GetLevelName(levels[levelIndex]))
				levelMenu:SetShown(#levels > 1)
				popup:Refresh()
			end

			-- Function to hide the overlay until the map is opened again
			HideOverlay = function()
				if previewID then LeaMapsLC.StopPreview() else hiddenFor = instanceID end
				Refresh()
			end

			-- Function to show or hide the overlay
			Refresh = function()
				local art, id
				-- End the preview if the world map has been changed to another zone
				if previewID and WorldMapFrame:GetMapID() ~= previewMapID then LeaMapsLC.StopPreview() end
				if WorldMapFrame:IsShown() and previewID then
					art, id = dungeonArt[previewID], previewID
				elseif WorldMapFrame:IsShown() then
					local mapID = select(8, GetInstanceInfo())
					local playerMap = MapUtil.GetDisplayableMapForPlayer()
					if IsSecret(mapID, playerMap) then mapID = nil end
					if mapID and dungeonArt[mapID] and hiddenFor ~= mapID and playerMap and WorldMapFrame:GetMapID() == playerMap then
						art, id = dungeonArt[mapID], mapID
					end
				end
				if not art then
					overlay:Hide()
					return
				end
				if id ~= instanceID then
					instanceID, levels, levelIndex, shownMapID = id, art, nil, nil
				end
				-- Use the level picked by the user, otherwise the level the player is on
				local index = chosenLevel[id]
				if not index then
					local bestMap = C_Map.GetBestMapForUnit("player")
					if IsSecret(bestMap) then bestMap = nil end
					for i = 1, #art do
						if art[i][1] == bestMap then index = i; break end
					end
				end
				overlay:Show()
				SelectLevel(index or levelIndex or 1)
				-- The map art could not be sized (frame sizes can be secret in combat) so show the normal map
				if overlay:IsShown() and view.baseW <= 0 then overlay:Hide() end
			end

			-- Function to find the quest panel toggle button (so it can be clicked while a dungeon map is showing)
			local function GetSidePanelToggle()
				if WorldMapFrame.SidePanelToggle then return WorldMapFrame.SidePanelToggle end
				for void, frame in ipairs(WorldMapFrame.overlayFrames or {}) do
					if frame.OpenButton and frame.CloseButton then return frame end
				end
			end

			-- Keep the coordinates footer (it is inside the map when the map is maximised) and the quest panel toggle
			-- button above the overlay. Only frame levels are changed and they are put back when the overlay is hidden.
			local raised = {}
			overlay:SetScript("OnShow", function()
				local top = 2000
				local manager = WorldMapFrame.GetPinFrameLevelsManager and WorldMapFrame:GetPinFrameLevelsManager()
				if manager and manager.GetValidFrameLevel then top = manager:GetValidFrameLevel("PIN_FRAME_LEVEL_TOPMOST", 1000) end
				overlay:SetFrameLevel(math.min(top + 100, 9000))
				canvas:SetFrameLevel(overlay:GetFrameLevel() + 1)
				for i = 1, #pins do
					pins[i]:SetFrameLevel(canvas:GetFrameLevel() + i * 4)
					pins[i].badge:SetFrameLevel(pins[i]:GetFrameLevel() + 2)
				end
				levelMenu:SetFrameLevel(overlay:GetFrameLevel() + 200)
				local offset = 300
				local raise = {}
				if mapTheme.footerFrame then raise[#raise + 1] = mapTheme.footerFrame end
				local toggle = GetSidePanelToggle()
				if toggle and not (InCombatLockdown() and toggle:IsProtected()) then
					raise[#raise + 1] = toggle
					for void, child in ipairs({toggle:GetChildren()}) do raise[#raise + 1] = child end
				end
				for void, frame in ipairs(raise) do
					raised[frame] = raised[frame] or frame:GetFrameLevel()
					frame:SetFrameLevel(overlay:GetFrameLevel() + offset)
					offset = offset + 5
				end
				if shownMapID then UpdatePins(shownMapID) end -- Level colours depend on player level
				Layout()
				if LeaMapsLC.RefreshPointsOfInterest then LeaMapsLC.RefreshPointsOfInterest() end
			end)

			overlay:SetScript("OnHide", function()
				overlay:SetScript("OnUpdate", nil)
				for frame, level in pairs(raised) do
					if not (InCombatLockdown() and frame:IsProtected()) then frame:SetFrameLevel(level) end
				end
				wipe(raised)
				popup:Close()
				if tip:GetOwner() and tip:GetOwner():GetParent() == canvas then tip:Hide() end
				if LeaMapsLC.RefreshPointsOfInterest then LeaMapsLC.RefreshPointsOfInterest() end
			end)

			-- Used by points of interest (they are hidden while a dungeon map is showing)
			LeaMapsLC.IsDungeonMapShown = function() return overlay:IsShown() end

			-- Update when the map is opened, the map changes or the player changes zone
			WorldMapFrame:HookScript("OnShow", function()
				hiddenFor = nil
				if previewID then LeaMapsLC.StopPreview() end
				wipe(chosenLevel)
				view.zoom, view.x, view.y = 1, 0, 0
				Refresh()
			end)
			hooksecurefunc(WorldMapFrame, "OnMapChanged", Refresh)

			local dungeonEvents = CreateFrame("Frame")
			dungeonEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
			dungeonEvents:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			dungeonEvents:RegisterEvent("ZONE_CHANGED")
			dungeonEvents:RegisterEvent("ZONE_CHANGED_INDOORS")
			dungeonEvents:RegisterEvent("PLAYER_REGEN_ENABLED") -- Frame sizes can be secret in combat so try again after combat
			dungeonEvents:SetScript("OnEvent", function()
				if WorldMapFrame:IsShown() then Refresh() end
			end)

			-- Preview dungeon maps without being in the dungeon (/ltm dun)
			local previewList = {
				{389, "Ragefire Chasm"},
				{36, "The Deadmines"},
				{43, "Wailing Caverns"},
				{33, "Shadowfang Keep"},
				{34, "The Stockade"},
				{48, "Blackfathom Deeps"},
				{90, "Gnomeregan"},
				{47, "Razorfen Kraul"},
				{189, "Scarlet Monastery"},
				{129, "Razorfen Downs"},
				{70, "Uldaman"},
				{209, "Zul'Farrak"},
				{349, "Maraudon"},
				{109, "Temple of Atal'Hakkar"},
				{230, "Blackrock Depths"},
				{229, "Blackrock Spire"},
				{409, "Molten Core"},
				{469, "Blackwing Lair"},
				{429, "Dire Maul"},
				{289, "Scholomance"},
				{329, "Stratholme"},
				{309, "Zul'Gurub"},
				{249, "Onyxia's Lair"},
				{509, "Ruins of Ahn'Qiraj"},
				{531, "Temple of Ahn'Qiraj"},
				{533, "Naxxramas"},
				{2959, "City of Dalaran"},
				{2998, "Excavation Site: Wetlands"},
				{2999, "The Ruins of Lordaeron"},
				{3065, "The Hall of Thanes"},
			}

			-- Arrow keys change the previewed map (key frame only exists and listens while previewing, never in combat)
			local keyFrame
			local function StartPreviewKeys()
				if InCombatLockdown() then return end
				if not keyFrame then
					keyFrame = CreateFrame("Frame", nil, overlay)
					keyFrame:EnableKeyboard(true)
					keyFrame:SetPropagateKeyboardInput(true)
					keyFrame:SetScript("OnKeyDown", function(self, key)
						if InCombatLockdown() then return end
						if key == "LEFT" or key == "RIGHT" then
							self:SetPropagateKeyboardInput(false)
							LeaMapsLC.PreviewDungeon(key == "LEFT" and "prev" or "next")
						else
							self:SetPropagateKeyboardInput(true)
						end
					end)
					-- Stop listening when combat starts or the frame hides
					keyFrame:SetScript("OnEvent", function(self) self:Hide() end)
					keyFrame:SetScript("OnHide", function(self) self:UnregisterAllEvents() end)
				end
				keyFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
				keyFrame:Show()
			end

			-- Check which game map textures are in the client (/ltm duncheck)
			LeaMapsLC.CheckDungeonMaps = function()
				if not GetFileIDFromPath then
					LeaMapsLC:Print("GetFileIDFromPath is not available in this client.")
					return
				end
				local checked, bundled, missing = 0, 0, 0
				for void, levels in pairs(dungeonArt) do
					for void, info in ipairs(levels) do
						if info[3] then
							checked = checked + 1
							for i = 1, 12 do
								if not GetFileIDFromPath("Interface\\WorldMap\\" .. info[3] .. i) then
									if bundledArt[info[3]] then
										bundled = bundled + 1
									else
										missing = missing + 1
										LeaMapsLC:Print("Missing: " .. info[3] .. i .. " (map " .. info[1] .. ")")
									end
									break
								end
							end
						end
					end
				end
				LeaMapsLC:Print(checked .. " game maps checked, " .. (checked - bundled - missing) .. " in the game, " .. bundled .. " using the addon copy, " .. missing .. " missing.")
			end

			-- Dungeon icons on the world map show the dungeon map when clicked (icon name = instance map IDs)
			LeaMapsLC.DungeonMapsByName = {
				[L["Uldaman"]] = {70},
				[L["Scarlet Monastery"]] = {189},
				[L["Shadowfang Keep"]] = {33},
				[L["Scholomance"]] = {289},
				[L["Stratholme (Main Gate)"]] = {329},
				[L["Stratholme (Service Gate)"]] = {329},
				[L["Naxxramas"]] = {533},
				[L["Gnomeregan"]] = {90},
				[L["Blackrock Mountain"]] = {230, 229, 409, 469},
				[L["Zul'Gurub"]] = {309},
				[L["Temple of Atal'Hakkar"]] = {109},
				[L["The Deadmines"]] = {36},
				[L["The Stockade"]] = {34},
				[L["Wailing Caverns"]] = {43},
				[L["Razorfen Kraul"]] = {47},
				[L["Razorfen Downs"]] = {129},
				[L["Blackfathom Deeps"]] = {48},
				[L["Maraudon"]] = {349},
				[L["Dire Maul (North)"]] = {429},
				[L["Dire Maul (West)"]] = {429},
				[L["Dire Maul (East)"]] = {429},
				[L["Onyxia's Lair"]] = {249},
				[L["Zul'Farrak"]] = {209},
				[L["Ahn'Qiraj"]] = {509, 531},
				[L["Ragefire Chasm"]] = {389},
				[L["City of Dalaran"]] = {2959},
				[L["Excavation Site: Wetlands"]] = {2998},
				[L["The Ruins of Lordaeron"]] = {2999},
				[L["The Hall of Thanes"]] = {3065},
			}

			-- Function to show the dungeon map for an instance
			local function ShowDungeonMap(id)
				for i = 1, #previewList do
					if previewList[i][1] == id then LeaMapsLC.PreviewDungeon(tostring(i), true, true) return end
				end
			end

			-- Function to show the dungeon map for a clicked dungeon icon (a list if the icon has several)
			local iconEntries = {}
			local function IsNotChecked() return false end
			local function ChooseIconEntry(entry) ShowDungeonMap(entry.id) end
			LeaMapsLC.OpenDungeonMaps = function(owner, title, ids)
				if #ids == 1 then
					ShowDungeonMap(ids[1])
					return
				end
				wipe(iconEntries)
				for void, id in ipairs(ids) do
					local name = GetRealZoneText(id)
					if not name or name == "" then
						for i = 1, #previewList do
							if previewList[i][1] == id then name = previewList[i][2] end
						end
					end
					iconEntries[#iconEntries + 1] = {id = id, name = name}
				end
				popup:Open(owner, iconEntries, IsNotChecked, ChooseIconEntry, "TOPLEFT", "CENTER", 0, 0)
			end

			LeaMapsLC.StopPreview = function()
				previewID = nil
				if keyFrame then keyFrame:Hide() end
				if LeaMapsLC.UpdateZoneMenus then LeaMapsLC.UpdateZoneMenus() end
			end

			-- Functions used by the zone menus (Dungeons entry)
			LeaMapsLC.GetDungeonList = function()
				local list = {}
				for i = 1, #previewList do
					local id = previewList[i][1]
					local name = GetRealZoneText(id)
					if not name or name == "" then name = previewList[i][2] end
					list[i] = {id = id, name = name}
				end
				return list
			end
			LeaMapsLC.GetDungeonPreview = function() return previewID end
			LeaMapsLC.ShowDungeonPreview = function(id) ShowDungeonMap(id) end
			LeaMapsLC.EndDungeonPreview = function()
				LeaMapsLC.StopPreview()
				Refresh()
			end

			-- quiet: no chat messages, noKeys: no arrow keys (used when clicking dungeon icons)
			LeaMapsLC.PreviewDungeon = function(arg, quiet, noKeys)
				if not WorldMapFrame:IsShown() then
					LeaMapsLC:Print("Open the world map first.")
					return
				end
				if arg == "off" then
					LeaMapsLC.StopPreview()
					Refresh()
					return
				end
				local index = tonumber(arg)
				if arg == "prev" then
					index = ((previewIndex or 1) - 2) % #previewList + 1
				elseif arg == "next" then
					index = (previewIndex or 0) % #previewList + 1
				elseif not index and arg then
					-- Find instance by part of its name
					for i = 1, #previewList do
						if strfind(strlower(previewList[i][2]), arg, 1, true) then index = i; break end
					end
				end
				index = index or ((previewIndex or 0) % #previewList + 1)
				if not previewList[index] then
					LeaMapsLC:Print("Use a number from 1 to " .. #previewList .. ".")
					return
				end
				local keysOn = keyFrame and keyFrame:IsShown()
				previewIndex, previewID, previewMapID = index, previewList[index][1], WorldMapFrame:GetMapID()
				chosenLevel[previewID] = nil
				Refresh()
				if not noKeys then StartPreviewKeys() end
				if LeaMapsLC.UpdateZoneMenus then LeaMapsLC.UpdateZoneMenus() end
				if not quiet then
					if not keysOn and keyFrame and keyFrame:IsShown() then LeaMapsLC:Print("Use the left and right arrow keys to change map.") end
					LeaMapsLC:Print(index .. "/" .. #previewList .. ": " .. previewList[index][2])
				end
			end

		end

		----------------------------------------------------------------------
		-- Hide filter reset button
		----------------------------------------------------------------------

		if LeaMapsLC["NoFilterResetBtn"] == "On" then
			-- Create hidden frame
			local hiddenFrame = CreateFrame("FRAME")
			hiddenFrame:Hide()
			-- Parent reset button to hidden frame
			for i, v in pairs({WorldMapFrame:GetChildren()}) do
				if v.ResetButton then
					v.ResetButton:SetParent(hiddenFrame)
				end
				if v.FilterCounter then
					v.FilterCounter:HookScript("OnShow", function() v.FilterCounter:Hide() end)
					v.FilterCounterBanner:HookScript("OnShow", function() v.FilterCounterBanner:Hide() end)
				end
			end
		end

		----------------------------------------------------------------------
		-- Scale the map
		----------------------------------------------------------------------

		if LeaMapsLC["ScaleWorldMap"] == "On" then

			-- Create configuration panel
			local scalePanel = LeaMapsLC:CreatePanel("Scale the map", "scalePanel")

			-- Add controls
			LeaMapsLC:MakeTx(scalePanel, "Scale", 16, -72)
			LeaMapsLC:MakeSL(scalePanel, "MapScale", "Windowed", "Drag to set the scale for the windowed map.", 0.5, 2, 0.05, 36, -112, "%.1f")
			LeaMapsLC:MakeSL(scalePanel, "MaxMapScale", "Maximised", "Drag to set the scale for the maximised map.", 0.5, 2, 0.05, 206, -112, "%.1f")

			-- Function to set map frame scale
			local function SetMapScale()
				LeaMapsCB["MapScale"].f:SetFormattedText("%.0f%%", LeaMapsLC["MapScale"] * 100)
				LeaMapsCB["MaxMapScale"].f:SetFormattedText("%.0f%%", LeaMapsLC["MaxMapScale"] * 100)
				-- Do not change scale if the map frame cannot be changed (scale controls are locked then)
				if not LeaMapsLC:CanChangeMap() then return end
				if not WorldMapFrame:IsMaximized() then
					WorldMapFrame:SetScale(LeaMapsLC["MapScale"])
				else
					WorldMapFrame:SetScale(LeaMapsLC["MaxMapScale"])
				end
				if LeaMapsLC.RefreshMapLines then LeaMapsLC.RefreshMapLines() end
			end

			-- Set scale properties when controls are changed and on startup
			LeaMapsCB["MapScale"]:HookScript("OnValueChanged", SetMapScale)
			LeaMapsCB["MaxMapScale"]:HookScript("OnValueChanged", SetMapScale)
			SetMapScale()

			-- Set scale when map size is toggled
			hooksecurefunc(WorldMapFrame, "SynchronizeDisplayState", SetMapScale)

			-- Lock scale controls while the map frame cannot be changed
			LeaMapsLC:AddMapLock(function(lock)
				LeaMapsLC:LockItem(LeaMapsCB["MapScale"], lock)
				LeaMapsLC:LockItem(LeaMapsCB["MaxMapScale"], lock)
				LeaMapsLC:LockItem(scalePanel.r, lock)
			end)

			-- Back to Main Menu button click
			scalePanel.b:HookScript("OnClick", function()
				scalePanel:Hide()
				LeaMapsLC["PageF"]:Show()
			end)

			-- Reset button click
			scalePanel.r:HookScript("OnClick", function()
				if not LeaMapsLC:CanChangeMap() then return end
				-- Reset map scale
				LeaMapsLC["MapScale"] = 1.0
				LeaMapsLC["MaxMapScale"] = 1.0
				SetMapScale()
				-- Refresh panel
				scalePanel:Hide(); scalePanel:Show()
			end)

			-- Show scale panel when configuration button is clicked
			LeaMapsCB["ScaleWorldMapBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile (not while the map frame cannot be changed)
					if LeaMapsLC:CanChangeMap() then
						LeaMapsLC["MapScale"] = 1.0
						LeaMapsLC["MaxMapScale"] = 0.9
						SetMapScale()
						if scalePanel:IsShown() then scalePanel:Hide(); scalePanel:Show(); end
					end
				else
					scalePanel:Show()
					LeaMapsLC["PageF"]:Hide()
				end
			end)

		end

		----------------------------------------------------------------------
		-- Enhance battlefield map
		----------------------------------------------------------------------

		if LeaMapsLC["EnhanceBattleMap"] == "On" then

			-- Show teammates
			BattlefieldMapOptions.showPlayers = true

			-- Create configuraton panel
			local battleFrame = LeaMapsLC:CreatePanel("Enhance battlefield map", "battleFrame")

			-- Add controls
			LeaMapsLC:MakeTx(battleFrame, "Settings", 16, -72)
			LeaMapsLC:MakeCB(battleFrame, "UnlockBattlefield", "Unlock battlefield map", 16, -92, false, "If checked, you can move the battlefield map by dragging any of its borders.")
			LeaMapsLC:MakeCB(battleFrame, "BattleCenterOnPlayer", "Center map on player", 16, -112, false, "If checked, the battlefield map will stay centered on your location as long as you are not in a dungeon.|n|nYou can hold shift while panning the map to temporarily prevent it from centering.")

			LeaMapsLC:MakeSL(battleFrame, "BattleGroupIconSize", "Group Icons", "Drag to set the group icon size.", 8, 32, 1, 206, -172, "%.0f")
			LeaMapsLC:MakeSL(battleFrame, "BattlePlayerArrowSize", "Player Arrow", "Drag to set the player arrow size.", 12, 48, 1, 36, -172, "%.0f")
			LeaMapsLC:MakeSL(battleFrame, "BattleMapOpacity", "Map Opacity", "Drag to set the battlefield map opacity.", 0.1, 1, 0.1, 36, -232, "%.0f")

			-- Add preview texture
			local prevIcon = battleFrame:CreateTexture(nil, "ARTWORK")
			prevIcon:SetPoint("CENTER", battleFrame, "TOPLEFT", 400, -182)
			prevIcon:SetTexture("Interface\\MINIMAP\\partyraidblipsv2")
			prevIcon:SetTexCoord(0.015625, 0.3125, 0.03125, 0.59375)
			prevIcon:SetSize(19, 18)
			prevIcon:SetVertexColor(0.78, 0.61, 0.43, 1)

			-- Hide battlefield tab button
			hooksecurefunc(BattlefieldMapTab, "Show", function() BattlefieldMapTab:Hide() end)

			-- Fix tab frame strata so it matches the battlefield map frame
			BattlefieldMapTab:SetFrameStrata(BattlefieldMapFrame:GetFrameStrata())

			-- Make battlefield map movable
			BattlefieldMapFrame:SetMovable(true)
			BattlefieldMapFrame:SetUserPlaced(true)
			BattlefieldMapFrame:SetDontSavePosition(true)
			BattlefieldMapFrame:SetClampedToScreen(true)

			-- Set battleifeld map position at startup
			BattlefieldMapFrame:ClearAllPoints()
			BattlefieldMapFrame:SetPoint(LeaMapsLC["BattleMapA"], UIParent, LeaMapsLC["BattleMapR"], LeaMapsLC["BattleMapX"], LeaMapsLC["BattleMapY"])

			-- Unlock battlefield map frame
			local eFrame = CreateFrame("Frame", nil, BattlefieldMapFrame.ScrollContainer)
			eFrame:SetPoint("TOPLEFT", 0, 0)
			eFrame:SetPoint("BOTTOMRIGHT", 0, 0)
			eFrame:SetFrameLevel(BattlefieldMapFrame:GetFrameLevel() - 1)
			eFrame:SetHitRectInsets(-15, -15, -15, -15)
			eFrame:SetAlpha(0)
			eFrame:EnableMouse(true)
			eFrame:RegisterForDrag("LeftButton")
			eFrame:SetScript("OnMouseDown", function()
				if LeaMapsLC["UnlockBattlefield"] == "On" then
					BattlefieldMapFrame:StartMoving()
				end
			end)
			eFrame:SetScript("OnMouseUp", function()
				-- Save frame positions
				BattlefieldMapFrame:StopMovingOrSizing()
				LeaMapsLC["BattleMapA"], void, LeaMapsLC["BattleMapR"], LeaMapsLC["BattleMapX"], LeaMapsLC["BattleMapY"] = BattlefieldMapFrame:GetPoint()
				BattlefieldMapFrame:SetMovable(true)
				BattlefieldMapFrame:ClearAllPoints()
				BattlefieldMapFrame:SetPoint(LeaMapsLC["BattleMapA"], UIParent, LeaMapsLC["BattleMapR"], LeaMapsLC["BattleMapX"], LeaMapsLC["BattleMapY"])
			end)

			-- Enable unlock border only when unlock is enabled
			local function SetUnlockBorder()
				if LeaMapsLC["UnlockBattlefield"] == "On" then
					eFrame:Show()
				else
					eFrame:Hide()
				end
			end

			-- Set unlock border when option is clicked and on startup
			LeaMapsCB["UnlockBattlefield"]:HookScript("OnClick", SetUnlockBorder)
			SetUnlockBorder()

			-- Toggle battlefield map frame with configuration panel
			battleFrame:HookScript("OnShow", function()
				if BattlefieldMapFrame:IsShown() then LeaMapsLC.BFMapWasShown = true else LeaMapsLC.BFMapWasShown = false end
				BattlefieldMapFrame:Show()
			end)
			battleFrame:HookScript("OnHide", function()
				if not LeaMapsLC.BFMapWasShown then BattlefieldMapFrame:Hide() end
			end)

			----------------------------------------------------------------------
			-- Center map on player
			----------------------------------------------------------------------

			do

				local cTime = -1

				-- Function to update map
				local function cUpdate(self, elapsed)
					if cTime > 2 or cTime == -1 then
						if BattlefieldMapFrame.ScrollContainer:IsPanning() then return end
						if IsShiftKeyDown() then cTime = -2000 return end
						local position = C_Map.GetPlayerMapPosition(BattlefieldMapFrame.mapID, "player")
						if position then
							local x, y = position.x, position.y
							if x then
								local minX, maxX, minY, maxY = BattlefieldMapFrame.ScrollContainer:CalculateScrollExtentsAtScale(BattlefieldMapFrame.ScrollContainer:GetCanvasScale())
								local cx = Clamp(x, minX, maxX)
								local cy = Clamp(y, minY, maxY)
								BattlefieldMapFrame.ScrollContainer:SetPanTarget(cx, cy)
							end
							cTime = 0
						end
					end
					cTime = cTime + elapsed
				end

				-- Create frame for update
				local cFrame = CreateFrame("FRAME", nil, BattlefieldMapFrame)

				-- Function to set update state
				local function SetUpdateFunc()
					cTime = -1
					if LeaMapsLC["BattleCenterOnPlayer"] == "On" then
						cFrame:SetScript("OnUpdate", cUpdate)
					else
						cFrame:SetScript("OnUpdate", nil)
					end
				end

				-- Set update state when option is clicked and on startup
				LeaMapsCB["BattleCenterOnPlayer"]:HookScript("OnClick", SetUpdateFunc)
				SetUpdateFunc()

				-- Hook reset button click
				battleFrame.r:HookScript("OnClick", function()
					LeaMapsLC["BattleCenterOnPlayer"] = "Off"
					SetUpdateFunc()
					battleFrame:Hide(); battleFrame:Show()
				end)

				-- Hook configuration panel for preset profile
				LeaMapsCB["EnhanceBattleMapBtn"]:HookScript("OnClick", function()
					if IsShiftKeyDown() and IsControlKeyDown() then
						-- Preset profile
						LeaMapsLC["BattleCenterOnPlayer"] = "On"
						SetUpdateFunc()
						if battleFrame:IsShown() then battleFrame:Hide(); battleFrame:Show(); end
					end
				end)

				-- Update location immediately or after a very short delay
				local function SetCenterNow()
					if LeaMapsLC["BattleCenterOnPlayer"] == "On" then
						if IsShiftKeyDown() then cTime = -2000 else	cTime = -1 end
					end
				end
				local function SetCenterSoon()
					if LeaMapsLC["BattleCenterOnPlayer"] == "On" then
						if IsShiftKeyDown() then cTime = -2000 else	cTime = 1.7 end
					end
				end

				BattlefieldMapFrame.ScrollContainer:HookScript("OnMouseUp", SetCenterSoon)
				BattlefieldMapFrame:HookScript("OnShow", SetCenterNow)
				BattlefieldMapFrame.ScrollContainer:HookScript("OnMouseWheel", SetCenterSoon)

			end

			----------------------------------------------------------------------
			-- Map opacity
			----------------------------------------------------------------------

			local function DoMapOpacity()
				LeaMapsCB["BattleMapOpacity"].f:SetFormattedText("%.0f%%", LeaMapsLC["BattleMapOpacity"] * 100)
				BattlefieldMapOptions.opacity = 1 - LeaMapsLC["BattleMapOpacity"]
				BattlefieldMapFrame:RefreshAlpha()
			end

			-- Set opacity when slider is changed and on startup
			LeaMapsCB["BattleMapOpacity"]:HookScript("OnValueChanged", DoMapOpacity)
			DoMapOpacity()

			----------------------------------------------------------------------
			-- Player arrow
			----------------------------------------------------------------------

			-- Function to set player arrow size
			local function SetPlayerArrow()
				BattlefieldMapFrame.groupMembersDataProvider:SetUnitPinSize("player", LeaMapsLC["BattlePlayerArrowSize"])
				BattlefieldMapFrame.groupMembersDataProvider.pin:SynchronizePinSizes()
			end

			-- Set player arrow when option is changed and on startup
			LeaMapsCB["BattlePlayerArrowSize"]:HookScript("OnValueChanged", SetPlayerArrow)
			SetPlayerArrow()

			----------------------------------------------------------------------
			-- Group icons
			----------------------------------------------------------------------

			-- Function to set group icons
			local function FixGroupPin()

				-- Icons should be under the player arrow
				BattlefieldMapFrame.groupMembersDataProvider.pin.SetAppearanceField("party", "sublevel", 0)
				BattlefieldMapFrame.groupMembersDataProvider.pin.SetAppearanceField("raid", "sublevel", 0)

				-- Icon size
				BattlefieldMapFrame.groupMembersDataProvider:SetUnitPinSize("party", LeaMapsLC["BattleGroupIconSize"])
				BattlefieldMapFrame.groupMembersDataProvider:SetUnitPinSize("raid", LeaMapsLC["BattleGroupIconSize"])
				BattlefieldMapFrame.groupMembersDataProvider.pin:SynchronizePinSizes()

			end

			-- Function to refresh size slider and update battlefield map
			local function SetIconSize()
				LeaMapsCB["BattleGroupIconSize"].f:SetText(LeaMapsLC["BattleGroupIconSize"] .. " (" .. string.format("%.0f%%", LeaMapsLC["BattleGroupIconSize"] / 8 * 100) .. ")")
				FixGroupPin()
				prevIcon:SetSize(LeaMapsLC["BattleGroupIconSize"], LeaMapsLC["BattleGroupIconSize"])
			end

			-- Set group icons when option is changed and on startup
			LeaMapsCB["BattleGroupIconSize"]:HookScript("OnValueChanged", SetIconSize)
			FixGroupPin()

			----------------------------------------------------------------------
			-- Rest of configuration panel
			----------------------------------------------------------------------

			-- Back to Main Menu button click
			battleFrame.b:HookScript("OnClick", function()
				battleFrame:Hide()
				LeaMapsLC["PageF"]:Show()
			end)

			-- Reset button click
			battleFrame.r:HookScript("OnClick", function()
				LeaMapsLC["UnlockBattlefield"] = "On"
				LeaMapsLC["BattleGroupIconSize"] = 8
				LeaMapsLC["BattlePlayerArrowSize"] = 12
				LeaMapsLC["BattleMapOpacity"] = 1
				LeaMapsLC["BattleMapA"], LeaMapsLC["BattleMapR"], LeaMapsLC["BattleMapX"], LeaMapsLC["BattleMapY"] = "BOTTOMRIGHT", "BOTTOMRIGHT", -47, 83
				BattlefieldMapFrame:ClearAllPoints()
				BattlefieldMapFrame:SetPoint(LeaMapsLC["BattleMapA"], UIParent, LeaMapsLC["BattleMapR"], LeaMapsLC["BattleMapX"], LeaMapsLC["BattleMapY"])
				SetIconSize()
				SetPlayerArrow()
				DoMapOpacity()
				SetUnlockBorder()
				battleFrame:Hide(); battleFrame:Show()
			end)

			-- Show configuration panel when configuration button is clicked
			LeaMapsCB["EnhanceBattleMapBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaMapsLC["UnlockBattlefield"] = "On"
					LeaMapsLC["BattleGroupIconSize"] = 8
					LeaMapsLC["BattlePlayerArrowSize"] = 12
					LeaMapsLC["BattleMapOpacity"] = 1
					LeaMapsLC["BattleMapA"], LeaMapsLC["BattleMapR"], LeaMapsLC["BattleMapX"], LeaMapsLC["BattleMapY"] = "BOTTOMRIGHT", "BOTTOMRIGHT", -47, 83
					BattlefieldMapFrame:ClearAllPoints()
					BattlefieldMapFrame:SetPoint(LeaMapsLC["BattleMapA"], UIParent, LeaMapsLC["BattleMapR"], LeaMapsLC["BattleMapX"], LeaMapsLC["BattleMapY"])
					SetIconSize()
					SetPlayerArrow()
					DoMapOpacity()
					SetUnlockBorder()
					if battleFrame:IsShown() then battleFrame:Hide(); battleFrame:Show(); end
				else
					battleFrame:Show()
					LeaMapsLC["PageF"]:Hide()
				end
			end)

		end

		----------------------------------------------------------------------
		-- Hide town and city icons
		----------------------------------------------------------------------

		if LeaMapsLC["HideTownCity"] == "On" then
			hooksecurefunc(BaseMapPoiPinMixin, "OnAcquired", function(self)
				local wmapID = WorldMapFrame.mapID
				if wmapID then
					local minfo = C_Map.GetMapInfo(wmapID)
					if minfo then
						local mType = minfo.mapType
						if mType then
							if mType == 1 or mType == 2 then
								-- Map type is world or continent
								if self.Texture and self.Texture:GetTexture() == 136441 then
									local a, b, c, d, e, f, g, h = self.Texture:GetTexCoord()
									if a == 0.35546875 and b == 0.001953125 and c == 0.35546875 and d == 0.03515625 and e == 0.421875 and f == 0.001953125 and g == 0.421875 and h == 0.03515625 then
										-- Hide home icons
										self:Hide()
									elseif a == 0.28515625 and b == 0.107421875 and c == 0.28515625 and d == 0.140625 and e == 0.3515625 and f == 0.107421875 and g == 0.3515625 and h == 0.140625 then
										-- Hide faction icons
										self:Hide()
										-- Hide city icons
									elseif a == 0.42578125 and b == 0.107421875 and c == 0.42578125 and d == 0.140625 and e == 0.4921875 and f == 0.107421875 and g == 0.4921875 and h == 0.140625 then
										self:Hide()
									end
								end
							end
						end
					end
				end
			end)
		end

		----------------------------------------------------------------------
		-- Show coordinates
		----------------------------------------------------------------------

		if LeaMapsLC["ShowCoords"] == "On" then

			-- Enable built-in coordinates
			SetCVar("worldMapShowPlayerCoords", "1")
			SetCVar("worldMapShowCursorCoords", "1")

			local function FindCoordsPanel()
				for void, frame in ipairs(WorldMapFrame.overlayFrames) do
					if frame.PlayerCoords and frame.CursorCoords then
						return frame
					end
				end
			end

			local coords = FindCoordsPanel()
			local canvas = WorldMapFrame:GetCanvasContainer()

			coords.PlayerCoords:SetParent(canvas)
			coords.PlayerCoords:ClearAllPoints()
			coords.PlayerCoords:SetPoint("BOTTOMLEFT", canvas, "BOTTOMLEFT", 40, 2)
			coords.PlayerCoords.Label:SetFont(coords.PlayerCoords.Label:GetFont(), 14, "OUTLINE")
			coords.PlayerCoords:SetFrameLevel(10)

			coords.CursorCoords:SetParent(canvas)
			coords.CursorCoords:ClearAllPoints()
			coords.CursorCoords:SetPoint("BOTTOMRIGHT", canvas, "BOTTOMRIGHT", -80, 2)
			coords.CursorCoords.Label:SetFont(coords.CursorCoords.Label:GetFont(), 14, "OUTLINE")
			coords.CursorCoords:SetFrameLevel(10)

			coords.CrosshairCoords:SetParent(canvas)
			coords.CrosshairCoords:ClearAllPoints()
			coords.CrosshairCoords:SetPoint("BOTTOM", canvas, "BOTTOM", -32, 2)
			coords.CrosshairCoords.Label:SetFont(coords.CrosshairCoords.Label:GetFont(), 14, "OUTLINE")
			coords.CrosshairCoords:SetFrameLevel(10)

			-- Create background frame
			local cFrame = CreateFrame("FRAME", nil, WorldMapFrame.ScrollContainer)
			cFrame:SetSize(WorldMapFrame:GetWidth(), 17)
			cFrame:SetPoint("BOTTOMLEFT", 17)
			cFrame:SetPoint("BOTTOMRIGHT", 0)

			-- Background (on its own frame so the rainbow theme can add to it)
			cFrame.back = CreateFrame("Frame", nil, cFrame)
			cFrame.back:SetAllPoints()
			cFrame.t = cFrame.back:CreateTexture(nil, "BACKGROUND")
			cFrame.t:SetAllPoints()
			cFrame.t:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
			cFrame.t:SetVertexColor(0, 0, 0, 0.5)

			-- Simple map frame: the coordinates sit in a footer under the map (so the bar does not cover anything on the
			-- map), the same width as the title bar and colored by the map theme (the footer is placed in SetPixelEdges)
			if ApplyMapTheme then
				cFrame:SetParent(WorldMapFrame)
				cFrame:ClearAllPoints()
				cFrame:SetHeight(20)
				cFrame:SetFrameStrata(mapTheme.titleBar:GetFrameStrata())
				cFrame:SetFrameLevel(mapTheme.titleBar:GetFrameLevel())
				cFrame.t:SetTexture("Interface\\Buttons\\WHITE8X8")
				cFrame.t:SetVertexColor(1, 1, 1, 1)
				mapTheme.footerFrame = cFrame
				mapTheme.footer = cFrame.back
				mapTheme.footerTexture = cFrame.t

				-- Function to move the coordinates into the footer (same places along the map as before, in the footer which
				-- is under the map, or inside the bottom of the map when the map is maximised)
				local function MoveCoords(frame, point, relativePoint, x, y)
					if not frame then return end
					frame:SetParent(cFrame)
					frame:ClearAllPoints()
					frame:SetPoint(point, canvas, relativePoint, x, y)
					frame:SetFrameLevel(cFrame:GetFrameLevel() + 2)
				end
				mapTheme.PlaceCoords = function(inside)
					local y = inside and 18 or -2
					MoveCoords(coords.PlayerCoords, "TOPLEFT", "BOTTOMLEFT", 40, y)
					MoveCoords(coords.CursorCoords, "TOPRIGHT", "BOTTOMRIGHT", -80, y)
					MoveCoords(coords.CrosshairCoords, "TOP", "BOTTOM", -32, y)
				end
				mapTheme.PlaceCoords(false)

				ApplyMapTheme()
				LeaMapsLC.RefreshMapLines()
			end

			-- Disable coordinates if option is turned off
			cFrame:RegisterEvent("PLAYER_LOGOUT")
			cFrame:SetScript("OnEvent", function()
				if LeaMapsLC["ShowCoords"] == "Off" then
					SetCVar("worldMapShowPlayerCoords", "0")
					SetCVar("worldMapShowCursorCoords", "0")
				end
			end)

			-- Create configuration panel
			local cPanel = LeaMapsLC:CreatePanel("Show coordinates", "cPanel")

			-- Add controls
			LeaMapsLC:MakeTx(cPanel, "Settings", 16, -72)
			LeaMapsLC:MakeCB(cPanel, "CoordsBackground", "Show background", 16, -92, false, "If checked, coordinates will have a dark background texture.")

			-- Function to apply settings
			local function SetCoordFunc()
				if LeaMapsLC["CoordsBackground"] == "On" then
					cFrame.back:Show()
				else
					cFrame.back:Hide()
				end
			end

			-- Set coordinates settings when options are clicked and on startup
			LeaMapsCB["CoordsBackground"]:HookScript("OnClick", SetCoordFunc)
			SetCoordFunc()

			-- Back to Main Menu button click
			cPanel.b:HookScript("OnClick", function()
				cPanel:Hide()
				LeaMapsLC["PageF"]:Show()
			end)

			-- Reset button click
			cPanel.r:HookScript("OnClick", function()
				LeaMapsLC["CoordsBackground"] = "On"
				SetCoordFunc()
				cPanel:Hide(); cPanel:Show()
			end)

			-- Show scale panel when configuration button is clicked
			LeaMapsCB["ShowCoordsBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaMapsLC["CoordsBackground"] = "On"
					SetCoordFunc()
					if cPanel:IsShown() then cPanel:Hide(); cPanel:Show(); end
				else
					cPanel:Show()
					LeaMapsLC["PageF"]:Hide()
				end
			end)

		end

		----------------------------------------------------------------------
		-- Unlock map frame
		----------------------------------------------------------------------

		if LeaMapsLC["UnlockMap"] == "On" then

			-- Create configuration panel
			local scaleFrame = LeaMapsLC:CreatePanel("Unlock map frame", "scaleFrame")

			-- Add controls
			LeaMapsLC:MakeTx(scaleFrame, "Settings", 16, -72)
			LeaMapsLC:MakeCB(scaleFrame, "EnableMovement", "Allow frame movement", 16, -92, false, "If checked, you will be able to move the frame by dragging the border.")

			----------------------------------------------------------------------
			-- Allow map frame movement
			----------------------------------------------------------------------

			local SetMapPositionFunc, ClampMapPosition -- Defined below
			local mapMoving
			local mapGrab = 20 -- How far outside the visible map border the map can be dragged (same on every side)
			local topGrips = {} -- Drag areas above the title bar (simple map frame only, turned off with frame movement)

			-- Function to check if the map frame has a position on screen (it can be missing or secret)
			local function MapHasRect()
				local left = WorldMapFrame:GetLeft()
				if issecretvalue and issecretvalue(left) then return false end
				return left ~= nil
			end

			-- Function to check if map frame position values can be saved (they can be missing or secret)
			local function IsValidMapPoint(a, r, x, y)
				if issecretvalue and (issecretvalue(a) or issecretvalue(r) or issecretvalue(x) or issecretvalue(y)) then return false end
				return type(a) == "string" and type(r) == "string" and type(x) == "number" and type(y) == "number"
			end

			-- Function to anchor the windowed map frame by its top left corner (like the default UI). The game saves a dragged
			-- frame from its nearest point (such as the bottom or center) and the map frame gets wider when the quest panel
			-- is shown, so any other anchor makes the map move when the quest panel is toggled.
			local function AnchorMapTopLeft()
				if not LeaMapsLC:CanChangeMap() or WorldMapFrame:IsMaximized() then return end
				local left, top, scale = WorldMapFrame:GetLeft(), WorldMapFrame:GetTop(), WorldMapFrame:GetEffectiveScale()
				local screenTop, uiScale = UIParent:GetTop(), UIParent:GetEffectiveScale()
				for void, v in ipairs({left, top, scale, screenTop, uiScale}) do
					if issecretvalue and issecretvalue(v) then return end -- Can be secret in combat
				end
				if not left or not top or not screenTop or not scale or scale <= 0 then return end
				local x, y = left, top - screenTop * uiScale / scale -- Map frame units
				WorldMapFrame:ClearAllPoints()
				WorldMapFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
				LeaMapsLC["MapPosA"], LeaMapsLC["MapPosR"], LeaMapsLC["MapPosX"], LeaMapsLC["MapPosY"] = "TOPLEFT", "TOPLEFT", x, y
			end

			-- Function to start moving the map frame (not while the map frame cannot be changed)
			local function StartMapMove()
				if LeaMapsLC["EnableMovement"] ~= "On" or not LeaMapsLC:CanChangeMap() then return end
				WorldMapFrame:StartMoving()
				-- Another addon's frames anchored to the map frame can leave it with no position when moving starts so
				-- stop moving and put the map frame back at its saved position
				if not MapHasRect() then
					WorldMapFrame:StopMovingOrSizing()
					WorldMapFrame:SetUserPlaced(false)
					SetMapPositionFunc()
					return
				end
				mapMoving = true
			end

			-- Function to stop moving the map frame and save its position
			local function StopMapMove()
				if not mapMoving or not LeaMapsLC:CanChangeMap() then return end
				mapMoving = nil
				WorldMapFrame:StopMovingOrSizing()
				WorldMapFrame:SetUserPlaced(false)
				ClampMapPosition()
				AnchorMapTopLeft()
				-- Save map frame position (if it's not valid, put the map frame back at its saved position)
				local a, void, r, x, y = WorldMapFrame:GetPoint()
				if not IsValidMapPoint(a, r, x, y) then
					SetMapPositionFunc()
					return
				end
				if WorldMapFrame:IsMaximized() then
					LeaMapsLC["MaxMapPosA"], LeaMapsLC["MaxMapPosR"], LeaMapsLC["MaxMapPosX"], LeaMapsLC["MaxMapPosY"] = a, r, x, y
				else
					LeaMapsLC["MapPosA"], LeaMapsLC["MapPosR"], LeaMapsLC["MapPosX"], LeaMapsLC["MapPosY"] = a, r, x, y
				end
			end

			-- Enable movement
			WorldMapFrame:SetMovable(true)
			WorldMapFrame:RegisterForDrag("LeftButton")
			WorldMapFrame:SetScript("OnDragStart", StartMapMove)
			WorldMapFrame:SetScript("OnDragStop", StopMapMove)

			-- Stop moving the map frame when combat starts (combat lockdown starts after this event and another addon
			-- may make the map frame protected during it)
			local moveEvents = CreateFrame("Frame")
			moveEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
			moveEvents:SetScript("OnEvent", StopMapMove)

			-- Allow map to be moved by the title bar (needed for simple map frame)
			if LeaMapsCB["MapTitleFrame"] then
				LeaMapsCB["MapTitleFrame"]:EnableMouse(true)
				LeaMapsCB["MapTitleFrame"]:RegisterForDrag("LeftButton")
				LeaMapsCB["MapTitleFrame"]:SetScript("OnDragStart", WorldMapFrame:GetScript("OnDragStart"))
				LeaMapsCB["MapTitleFrame"]:SetScript("OnDragStop", WorldMapFrame:GetScript("OnDragStop"))
				-- Allow map to be moved by the space above the title bar (the quest log covers the map frame there so it
				-- would not get the click). It goes up to the same height as the clickable area of the map frame (mapGrab
				-- above the border, see SetMapHitRect) so the top is as easy to grab as the other sides. The main part
				-- stops short of the title bar buttons and the part above the buttons starts a little above the title bar so
				-- the buttons can still be clicked.
				local titleFrame = LeaMapsCB["MapTitleFrame"]
				local gripTop = mapTheme.borderFrame or WorldMapFrame
				local function MakeTopGrip(left, leftX, right, rightX, bottomY)
					local grip = CreateFrame("Frame", nil, titleFrame)
					topGrips[#topGrips + 1] = grip
					grip:SetPoint("BOTTOMLEFT", titleFrame, left, leftX, bottomY)
					grip:SetPoint("BOTTOMRIGHT", titleFrame, right, rightX, bottomY)
					grip:SetPoint("TOP", gripTop, "TOP", 0, mapGrab)
					grip:EnableMouse(true)
					grip:RegisterForDrag("LeftButton")
					grip:SetScript("OnDragStart", StartMapMove)
					grip:SetScript("OnDragStop", StopMapMove)
				end
				MakeTopGrip("TOPLEFT", 0, "TOPRIGHT", -70, 0) -- Above the title bar
				MakeTopGrip("TOPRIGHT", -70, "TOPRIGHT", mapGrab, 4) -- Above the title bar buttons and the top right corner
			end

			-- The game's clamp to screen is not used. Its single clamp area cannot let the map go far off the top and far
			-- off the bottom at the same time (when it is set up to, the map jumps when it is clicked and gets stuck), so the
			-- map can be dragged freely and is moved back on the screen when it is dropped (see ClampMapPosition).
			WorldMapFrame:SetClampedToScreen(false)

			-- Function to move the map frame back if too much of it is off the screen. The map can go off any side of the
			-- screen until about 100 screen pixels of it are left on the screen (if the map is moved off the top,
			-- the title bar can be off the screen, Reset in the configuration panel brings it back).
			local mapKeepPixels = 100
			ClampMapPosition = function()
				if not LeaMapsLC:CanChangeMap() then return end
				local left, right, top, bottom = WorldMapFrame:GetLeft(), WorldMapFrame:GetRight(), WorldMapFrame:GetTop(), WorldMapFrame:GetBottom()
				local scale, uiScale = WorldMapFrame:GetEffectiveScale(), UIParent:GetEffectiveScale()
				local screenW, screenH = UIParent:GetSize()
				for void, v in ipairs({left, right, top, bottom, scale, uiScale, screenW, screenH}) do
					if issecretvalue and issecretvalue(v) then return end -- Can be secret in combat
				end
				if not left or not top or not scale or scale <= 0 then return end
				-- Screen size in map frame units
				screenW, screenH = screenW * uiScale / scale, screenH * uiScale / scale
				-- Amount to keep on the screen in map frame units (768 units at scale 1 is the screen height)
				local physHeight = GetPhysicalScreenSize and select(2, GetPhysicalScreenSize())
				local keep = 300
				if physHeight and physHeight > 0 then keep = mapKeepPixels * 768 / physHeight / scale end
				local width, height = right - left, top - bottom
				local offX, offY = math.max(0, width - keep), math.max(0, height - keep) -- How far it can go off each side
				local dx, dy = 0, 0
				if left < -offX then dx = -offX - left elseif right > screenW + offX then dx = screenW + offX - right end
				if top > screenH + offY then dy = screenH + offY - top elseif bottom < -offY then dy = -offY - bottom end
				if dx == 0 and dy == 0 then return end
				if WorldMapFrame:GetNumPoints() ~= 1 then return end
				local a, rel, r, x, y = WorldMapFrame:GetPoint()
				if not IsValidMapPoint(a, r, x, y) then return end
				WorldMapFrame:SetPoint(a, rel, r, x + dx, y + dy)
			end

			-- Function to set map position (not while the map frame cannot be changed)
			SetMapPositionFunc = function()
				if not LeaMapsLC:CanChangeMap() then return end
				WorldMapFrame:ClearAllPoints()
				if not WorldMapFrame:IsMaximized() then
					WorldMapFrame:SetPoint(LeaMapsLC["MapPosA"], UIParent, LeaMapsLC["MapPosR"], LeaMapsLC["MapPosX"], LeaMapsLC["MapPosY"])
				else
					WorldMapFrame:SetPoint(LeaMapsLC["MaxMapPosA"], UIParent, LeaMapsLC["MaxMapPosR"], LeaMapsLC["MaxMapPosX"], LeaMapsLC["MaxMapPosY"])
				end
				ClampMapPosition()
				-- Positions saved before the map was anchored by its top left corner are changed over
				if LeaMapsLC["MapPosA"] ~= "TOPLEFT" or LeaMapsLC["MapPosR"] ~= "TOPLEFT" then AnchorMapTopLeft() end
			end

			-- Set map position when map size is toggled, map size is changed and on startup
			hooksecurefunc(WorldMapFrame, "SynchronizeDisplayState", SetMapPositionFunc)
			hooksecurefunc(WorldMapFrame, "OnFrameSizeChanged", SetMapPositionFunc) -- Needed when maximising the map
			SetMapPositionFunc()

			-- Function to set map movement clickable area (not while the map frame cannot be changed)
			local function SetMapHitRect()
				if not LeaMapsLC:CanChangeMap() then return end
				-- With frame movement on, the clickable area goes mapGrab past the visible border on every side. With it
				-- off, there is no clickable space outside the visible border and the drag areas above the title bar are
				-- turned off. With the default map frame the border is the map frame.
				local moving = LeaMapsLC["EnableMovement"] == "On"
				local grab = moving and mapGrab or 0
				local left, right, top, bottom
				if mapTheme.GetBorderInsets then left, right, top, bottom = mapTheme.GetBorderInsets(grab) end
				if not left then left, right, top, bottom = -grab, -grab, -grab, -grab end
				WorldMapFrame:SetHitRectInsets(left, right, top, bottom)
				for i = 1, #topGrips do
					topGrips[i]:EnableMouse(moving)
				end
			end

			-- Function to set the clickable area now and once more on the next frame, after the game has finished laying
			-- out the map frame and its border (only one next-frame pass is queued at a time)
			local hitRectQueued
			local function HitRectQueued()
				hitRectQueued = nil
				SetMapHitRect()
			end
			local function RefreshMapHitRect()
				SetMapHitRect()
				if not hitRectQueued then
					hitRectQueued = true
					C_Timer.After(0, HitRectQueued)
				end
			end

			-- Set map movement clickable area on startup, when setting is changed and when the map layout changes
			RefreshMapHitRect()
			LeaMapsLC.SetMapHitRect = RefreshMapHitRect -- Used by the simple map frame when the border or footer moves
			LeaMapsCB["EnableMovement"]:HookScript("OnClick", RefreshMapHitRect)

			-- Lock map movement controls while the map frame cannot be changed
			LeaMapsLC:AddMapLock(function(lock)
				LeaMapsLC:LockItem(LeaMapsCB["EnableMovement"], lock)
				LeaMapsLC:LockItem(scaleFrame.r, lock)
			end)

			----------------------------------------------------------------------
			-- Panel button handlers
			----------------------------------------------------------------------

			-- Back to Main Menu button click
			scaleFrame.b:HookScript("OnClick", function()
				scaleFrame:Hide()
				LeaMapsLC["PageF"]:Show()
			end)

			-- Reset button click
			scaleFrame.r:HookScript("OnClick", function()
				if not LeaMapsLC:CanChangeMap() then return end
				-- Reset map position
				LeaMapsLC["EnableMovement"] = "On"
				LeaMapsLC["MapPosA"], LeaMapsLC["MapPosR"], LeaMapsLC["MapPosX"], LeaMapsLC["MapPosY"] = "TOPLEFT", "TOPLEFT", 16, -94
				LeaMapsLC["MaxMapPosA"], LeaMapsLC["MaxMapPosR"], LeaMapsLC["MaxMapPosX"], LeaMapsLC["MaxMapPosY"] = "CENTER", "CENTER", 0, 0
				WorldMapFrame:ClearAllPoints()
				if WorldMapFrame:IsMaximized() then
					WorldMapFrame:SetPoint(LeaMapsLC["MaxMapPosA"], UIParent, LeaMapsLC["MaxMapPosR"], LeaMapsLC["MaxMapPosX"], LeaMapsLC["MaxMapPosY"])
				else
					WorldMapFrame:SetPoint(LeaMapsLC["MapPosA"], UIParent, LeaMapsLC["MapPosR"], LeaMapsLC["MapPosX"], LeaMapsLC["MapPosY"])
				end
				-- Refresh panel
				scaleFrame:Hide(); scaleFrame:Show()
			end)

			-- Assign file level scope to reset button (needed for Remove map border)
			LeaMapsCB["UnlockMapPanelResetButton"] = scaleFrame.r

			-- Show scale panel when configuration button is clicked
			LeaMapsCB["UnlockMapBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaMapsLC["EnableMovement"] = "On"
					if scaleFrame:IsShown() then scaleFrame:Hide(); scaleFrame:Show(); end
				else
					scaleFrame:Show()
					LeaMapsLC["PageF"]:Hide()
				end
			end)

		end

		----------------------------------------------------------------------
		-- Disable map fade while moving
		----------------------------------------------------------------------

		-- Function to set map fade
		local function SetMapFade()
			if LeaMapsLC["NoMapFade"] == "On" then
				SetCVar("mapFade", "0")
			else
				SetCVar("mapFade", "1")
			end
		end

		-- Set map fade when option is clicked and on startup
		LeaMapsCB["NoMapFade"]:HookScript("OnClick", SetMapFade)
		SetMapFade()

		----------------------------------------------------------------------
		-- Show zone levels
		----------------------------------------------------------------------

		if LeaMapsLC["ShowZoneLevels"] == "On" then

			-- Create level range table
			local mapTable = {

				-- Eastern Kingdoms
				--[[Alterac Mountains]]		[1416] = {minLevel = 30, 	maxLevel = 40,		minFish = "130",},
				--[[Arathi Highlands]]		[1417] = {minLevel = 30, 	maxLevel = 40,		minFish = "130",},
				--[[Badlands]]				[1418] = {minLevel = 35, 	maxLevel = 45,},
				--[[Blasted Lands]]			[1419] = {minLevel = 45, 	maxLevel = 55},
				--[[Burning Steppes]]		[1428] = {minLevel = 50, 	maxLevel = 58,		minFish = "330",},
				--[[Deadwind Pass]]			[1430] = {minLevel = 55, 	maxLevel = 60,		minFish = "330",},
				--[[Dun Morogh]]			[1426] = {minLevel = 1, 	maxLevel = 10,		minFish = "1",},
				--[[Duskwood]]				[1431] = {minLevel = 18, 	maxLevel = 30,		minFish = "55",},
				--[[Eastern Plaguelands]]	[1423] = {minLevel = 53, 	maxLevel = 60,		minFish = "330",},
				--[[Elwynn Forest]]			[1429] = {minLevel = 1, 	maxLevel = 10,		minFish = "1",},
				--[[Hillsbrad Foothills]]	[1424] = {minLevel = 20, 	maxLevel = 30,		minFish = "55",},
				--[[Ironforge]]				[1455] = {minFish = 1,},
				--[[Loch Modan]]			[1432] = {minLevel = 10,	maxLevel = 20,		minFish = "1",},
				--[[Redridge Mountains]]	[1433] = {minLevel = 15, 	maxLevel = 25,		minFish = "55",},
				--[[Searing Gorge]]			[1427] = {minLevel = 43, 	maxLevel = 50},
				--[[Silverpine Forest]]		[1421] = {minLevel = 10, 	maxLevel = 20,		minFish = "1",},
				--[[Stormwind City]]		[1453] = {minFish = 1,},
				--[[Stranglethorn Vale]]	[1434] = {minLevel = 30, 	maxLevel = 45,		minFish = "130 (205)",},
				--[[Swamp of Sorrows]]		[1435] = {minLevel = 35, 	maxLevel = 45,		minFish = "130",},
				--[[The Hinterlands]]		[1425] = {minLevel = 40, 	maxLevel = 50,		minFish = "205",},
				--[[Tirisfal Glades]]		[1420] = {minLevel = 1, 	maxLevel = 10,		minFish = "1",},
				--[[Undercity]]				[1458] = {minFish = 1,},
				--[[Westfall]]				[1436] = {minLevel = 10, 	maxLevel = 20,		minFish = "1",},
				--[[Western Plaguelands]]	[1422] = {minLevel = 51, 	maxLevel = 58,		minFish = "205",},
				--[[Wetlands]]				[1437] = {minLevel = 20, 	maxLevel = 30,		minFish = "55",},

				-- Kalimdor
				--[[Ashenvale]]				[1440] = {minLevel = 18, 	maxLevel = 30,		minFish = "55",},
				--[[Azshara]]				[1447] = {minLevel = 45, 	maxLevel = 55,		minFish = "205 (330)",},
				--[[Darkshore]]				[1439] = {minLevel = 10,	maxLevel = 20,		minFish = "1",},
				--[[Darnassus]]				[1457] = {minFish = 1,},
				--[[Desolace]]				[1443] = {minLevel = 30, 	maxLevel = 40,		minFish = "130",},
				--[[Durotar]]				[1411] = {minLevel = 1, 	maxLevel = 10,		minFish = "1",},
				--[[Dustwallow Marsh]]		[1445] = {minLevel = 35, 	maxLevel = 45,		minFish = "130",},
				--[[Felwood]]				[1448] = {minLevel = 48, 	maxLevel = 55,		minFish = "205",},
				--[[Feralas]]				[1444] = {minLevel = 40, 	maxLevel = 50,		minFish = "205 (330)",},
				--[[Moonglade]]				[1450] = {minFish = 205,},
				--[[Mulgore]]				[1412] = {minLevel = 1, 	maxLevel = 10,		minFish = "1",},
				--[[Orgrimmar]]				[1454] = {minFish = 1,},
				--[[Silithus]]				[1451] = {minLevel = 55, 	maxLevel = 60,		minFish = "330",},
				--[[Stonetalon Mountains]]	[1442] = {minLevel = 15, 	maxLevel = 27,		minFish = "55",},
				--[[Tanaris]]				[1446] = {minLevel = 40, 	maxLevel = 50,		minFish = "205",},
				--[[Teldrassil]]			[1438] = {minLevel = 1, 	maxLevel = 10,		minFish = "1",},
				--[[The Barrens]]			[1413] = {minLevel = 10, 	maxLevel = 25,		minFish = "1",},
				--[[Thousand Needles]]		[1441] = {minLevel = 25, 	maxLevel = 35,		minFish = "130",},
				--[[Thunder Bluff]]			[1456] = {minFish = 1,},
				--[[Un'Goro Crater]]		[1449] = {minLevel = 48, 	maxLevel = 55,		minFish = "205",},
				--[[Winterspring]]			[1452] = {minLevel = 55, 	maxLevel = 60,		minFish = "330",},

				-- Forever
				--[[Hyjal]]					[2482] = {minLevel = 60, 	maxLevel = 60,},
				--[[Zephras Isle]]			[2521] = {minLevel = 1, 	maxLevel = 12,},
				--[[Riverglades]]			[2548] = {minLevel = 35, 	maxLevel = 45,},
				--[[Shen'dralas]]			[2652] = {minLevel = 35, 	maxLevel = 45,},

			}

			local lastCursorInput = "MOUSE"
			local lastMouseX, lastMouseY

			local function UpdateLastCursorInput(map)
				-- Gamepad is in use
				if SoftCursor and SoftCursor:IsShown() and SoftCursor:IsMoving() then
					lastCursorInput = "GAMEPAD"
					return
				end

				-- Mouse is in use
				local mouseX, mouseY = map:GetNormalizedCursorPosition()
				if lastMouseX and lastMouseY then
					if mouseX ~= lastMouseX or mouseY ~= lastMouseY then
						lastCursorInput = "MOUSE"
					end
				end

				lastMouseX = mouseX
				lastMouseY = mouseY
			end

			-- Replace AreaLabelFrameMixin.OnUpdate
			local function AreaLabelOnUpdate(self)
				self:ClearLabel(MAP_AREA_LABEL_TYPE.AREA_NAME)
				local map = self.dataProvider:GetMap()
				UpdateLastCursorInput(map)
				local gamepadCursorActive = lastCursorInput == "GAMEPAD"
				if map:IsCanvasMouseFocus() or gamepadCursorActive then
					local name, description
					local mapID = map:GetMapID()
					local normalizedCursorX, normalizedCursorY
					if gamepadCursorActive then
						normalizedCursorX, normalizedCursorY = map.ScrollContainer:GetNormalizedGamepadCursorPosition()
					else
						normalizedCursorX, normalizedCursorY = map:GetNormalizedCursorPosition()
					end
					local positionMapInfo = C_Map.GetMapInfoAtPosition(mapID, normalizedCursorX, normalizedCursorY)
					if positionMapInfo and positionMapInfo.mapID ~= mapID then
						-- print(positionMapInfo.mapID)
						name = positionMapInfo.name
						-- Get level range from table
						local playerMinLevel, playerMaxLevel, minFish
						if mapTable[positionMapInfo.mapID] then
							playerMinLevel = mapTable[positionMapInfo.mapID]["minLevel"]
							playerMaxLevel = mapTable[positionMapInfo.mapID]["maxLevel"]
							minFish = mapTable[positionMapInfo.mapID]["minFish"]
						end
						-- Show level range if map zone exists in table
						if name and playerMinLevel and playerMaxLevel and playerMinLevel > 0 and playerMaxLevel > 0 then
							local playerLevel = UnitLevel("player")
							local color
							if playerLevel < playerMinLevel then
								color = GetQuestDifficultyColor(playerMinLevel)
							elseif playerLevel > playerMaxLevel then
								-- Subtract 2 from the maxLevel so zones entirely below the player's level won't be yellow
								color = GetQuestDifficultyColor(playerMaxLevel - 2)
							else
								color = QuestDifficultyColors["difficult"]
							end
							color = ConvertRGBtoColorString(color)
							if playerMinLevel ~= playerMaxLevel then
								name = name..color.." ("..playerMinLevel.."-"..playerMaxLevel..")"..FONT_COLOR_CODE_CLOSE
							else
								name = name..color.." ("..playerMaxLevel..")"..FONT_COLOR_CODE_CLOSE
							end
						end
						if minFish and LeaMapsLC["ShowFishingLevels"] == "On" then
							description = L["Fishing"] .. ": " .. minFish
						end
					else
						name = MapUtil.FindBestAreaNameAtMouse(mapID, normalizedCursorX, normalizedCursorY)
					end
					if name then
						self:SetLabel(MAP_AREA_LABEL_TYPE.AREA_NAME, name, description)
					end
				end
				self:EvaluateLabels()
			end

			for provider in next, WorldMapFrame.dataProviders do
				if provider.Label then
					provider.Label:SetScript("OnUpdate", AreaLabelOnUpdate)
				end
			end

			-- Create configuraton panel
			local levelFrame = LeaMapsLC:CreatePanel("Show zone levels", "levelFrame")

			-- Add controls
			LeaMapsLC:MakeTx(levelFrame, "Settings", 16, -72)
			LeaMapsLC:MakeCB(levelFrame, "ShowFishingLevels", "Show minimum fishing skill levels", 16, -92, false, "If checked, the minimum fishing skill levels will be shown.")

			-- Back to Main Menu button click
			levelFrame.b:HookScript("OnClick", function()
				levelFrame:Hide()
				LeaMapsLC["PageF"]:Show()
			end)

			-- Reset button click
			levelFrame.r:HookScript("OnClick", function()
				LeaMapsLC["ShowFishingLevels"] = "On"
				levelFrame:Hide(); levelFrame:Show()
			end)

			-- Show configuration panel when configuration button is clicked
			LeaMapsCB["ShowZoneLevelsBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaMapsLC["ShowFishingLevels"] = "On"
					if levelFrame:IsShown() then levelFrame:Hide(); levelFrame:Show(); end
				else
					levelFrame:Show()
					LeaMapsLC["PageF"]:Hide()
				end
			end)

		end

		----------------------------------------------------------------------
		-- Show points of interest
		----------------------------------------------------------------------

		if LeaMapsLC["ShowPointsOfInterest"] == "On" then

			local poiScale = 0.7	-- POI scale
			local hitScale = 0.8	-- Fraction of the icon that counts as a hit (icons have transparent padding)

			local PinData = Leatrix_Maps["Icons"]
			local LeaMapsPOI = {}
			local LeaMapsPOIPool = {}
			local hoveredPin = nil

			-- Private tooltip so we never write to the shared GameTooltip (avoids taint)
			local tip = CreateFrame("GameTooltip", "LeaMapsPOITooltip", UIParent, "GameTooltipTemplate")
			tip:SetFrameStrata("TOOLTIP")

			-- Icon definitions
			local POIIcons = {
				Dungeon = {atlas = "Dungeon", size = 46},
				Raid = {atlas = "Raid", size = 46},
				FlightA = {atlas = "TaxiNode_Alliance", size = 30},
				FlightH = {atlas = "TaxiNode_Horde", size = 30},
				FlightN = {atlas = "TaxiNode_Neutral", size = 30},
				Spirit = {atlas = "Vehicle-TempleofKotmogu-GreenBall", size = 28},
				TravelA = {texture = "Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps.blp", size = 46, left = 0, right = 0.125, top = 0.375, bottom = 0.5},
				TravelH = {texture = "Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps.blp", size = 46, left = 0.125, right = 0.25, top = 0.375, bottom = 0.5},
				TravelN = {texture = "Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps.blp", size = 46, left = 0.25, right = 0.375, top = 0.375, bottom = 0.5},
				PortalA = {atlas = "MagePortalAlliance", size = 32},
				PortalH = {atlas = "MagePortalHorde", size = 32},
				PortalN = {atlas = "MagePortalAlliance", size = 32},
				Dunraid = {texture = "Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps.blp", size = 46, left = 0.375, right = 0.5, top = 0.375, bottom = 0.5},
				Arrow = {atlas = "Garr_LevelUpgradeArrow", width = 48, height = 54},
			}

			----------------------------------------------------------------------
			-- Pin creation and layout
			----------------------------------------------------------------------

			-- Pins are display-only: no mouse input, so they can never block the map or each other
			local function CreatePOIFrame()
				local pin = CreateFrame("Frame", nil, WorldMapFrame:GetCanvas())
				pin.isLeaMapsPin = true
				pin:SetFrameStrata("HIGH")
				pin:SetFrameLevel(100)
				pin.Texture = pin:CreateTexture(nil, "ARTWORK")
				pin.Texture:SetAllPoints()
				pin.Highlight = pin:CreateTexture(nil, "OVERLAY")
				pin.Highlight:SetAllPoints()
				pin.Highlight:SetBlendMode("ADD")
				pin.Highlight:Hide()
				pin.textures = {pin.Texture, pin.Highlight}
				return pin
			end

			local function PositionPOI(pin)
				local canvas = WorldMapFrame:GetCanvas()
				local scale = pin:GetScale()
				local x, y = pin.data[2] / 100, pin.data[3] / 100
				pin:ClearAllPoints()
				pin:SetPoint("CENTER", canvas, "TOPLEFT", (canvas:GetWidth() * x) / scale, -(canvas:GetHeight() * y) / scale)
			end

			local function UpdatePOIScale()
				local scale = poiScale / WorldMapFrame:GetCanvasScale()
				for i = 1, #LeaMapsPOI do
					local pin = LeaMapsPOI[i]
					pin:SetScale(scale)
					PositionPOI(pin)
				end
			end

			WorldMapFrame:HookScript("OnSizeChanged", UpdatePOIScale)
			hooksecurefunc(WorldMapFrame, "OnCanvasScaleChanged", UpdatePOIScale)

			local function SetupIcon(pin, icon, rotation)
				local w, h = icon.width or icon.size, icon.height or icon.size
				pin:SetSize(w, h)
				for _, tex in ipairs(pin.textures) do
					tex:SetTexture(nil)
					tex:SetTexCoord(0, 1, 0, 1)
					if icon.atlas then
						tex:SetAtlas(icon.atlas)
					else
						tex:SetTexture(icon.texture)
						if icon.left then tex:SetTexCoord(icon.left, icon.right, icon.top, icon.bottom) end
					end
					tex:SetRotation(rotation or 0)
				end
			end

			----------------------------------------------------------------------
			-- Tooltip
			----------------------------------------------------------------------

			-- Function to check if a pin can be clicked to show its destination map (zone crossing arrows, portals, trams, boats and zeppelins)
			local tramPrefix, boatPrefix, zeppPrefix = L["Tram to"], L["Boat to"], L["Zeppelin to"]
			local function IsMapLink(pinInfo)
				local kind = pinInfo[1]
				if not pinInfo[13] then return false end
				if kind == "Arrow" or kind == "PortalA" or kind == "PortalH" or kind == "PortalN" then return true end
				-- Trams, boats and zeppelins share the travel icon so they are found by their name
				if (kind == "TravelA" or kind == "TravelH" or kind == "TravelN") and pinInfo[4] then
					local name = pinInfo[4]
					if strsub(name, 1, #tramPrefix) == tramPrefix or strsub(name, 1, #boatPrefix) == boatPrefix or strsub(name, 1, #zeppPrefix) == zeppPrefix then return true end
				end
				return false
			end

			-- Function to check if a pin is a dungeon icon
			local function IsDungeonPin(pinInfo)
				return pinInfo[1] == "Dungeon" or pinInfo[1] == "Raid" or pinInfo[1] == "Dunraid"
			end

			local function BuildPOITooltip(pin)
				local pinInfo = pin.data
				if not pinInfo then return end
				local name = pinInfo[4] or ""

				if pinInfo[7] and pinInfo[8] then
					local playerLevel = UnitLevel("player")
					local minLevel, maxLevel = pinInfo[7], pinInfo[8]
					local color
					if playerLevel < minLevel then
						color = GetQuestDifficultyColor(minLevel)
					elseif playerLevel > maxLevel then
						color = GetQuestDifficultyColor(maxLevel - 2)
					else
						color = QuestDifficultyColors["difficult"]
					end
					color = ConvertRGBtoColorString(color)
					if minLevel ~= maxLevel then
						name = name .. color .. " (" .. minLevel .. "-" .. maxLevel .. ")" .. FONT_COLOR_CODE_CLOSE
					else
						name = name .. color .. " (" .. maxLevel .. ")" .. FONT_COLOR_CODE_CLOSE
					end
				end

				tip:SetScale(GameTooltip:GetScale())
				tip:SetOwner(pin, "ANCHOR_RIGHT")
				tip:SetText(name)
				if pinInfo[5] and pinInfo[5] ~= "" then
					tip:AddLine(pinInfo[5], 1, 1, 1, true)
				end
				if IsMapLink(pinInfo) and C_Map.OpenWorldMap and not InCombatLockdown() then
					tip:AddLine(L["Click to view this map."], 0, 1, 0, true)
				elseif IsDungeonPin(pinInfo) and LeaMapsLC.DungeonMapsByName and LeaMapsLC.DungeonMapsByName[pinInfo[4]] then
					tip:AddLine(L["Click to view this map."], 0, 1, 0, true)
				end
				tip:Show()
			end

			----------------------------------------------------------------------
			-- Hover (shared by mouse and gamepad)
			----------------------------------------------------------------------

			local function SetHoveredPin(pin)
				if pin == hoveredPin then return end
				if hoveredPin then
					hoveredPin.Highlight:Hide()
					tip:Hide()
				end
				hoveredPin = pin
				if pin then
					pin.Highlight:Show()
					BuildPOITooltip(pin)
				end
			end

			-- Follow whichever input was used most recently
			local activeInput = "mouse"
			local lastMouseX, lastMouseY

			local function UpdateActiveInput()
				local gamepadUI = InputUtil.IsGamepadUIEnabled()
				local mx, my = GetCursorPosition()
				local mouseMoved = mx ~= lastMouseX or my ~= lastMouseY
				local buttonDown = IsMouseButtonDown("LeftButton") or IsMouseButtonDown("RightButton")
				lastMouseX, lastMouseY = mx, my

				if gamepadUI and (SoftCursor:IsMoving() or (mouseMoved and buttonDown)) then
					-- Stick movement, or panning the map with the mouse: use the crosshair
					activeInput = "gamepad"
				elseif mouseMoved and not buttonDown then
					-- Plain mouse movement: use the pointer
					activeInput = "mouse"
				end

				return gamepadUI
			end

			-- Closest pin whose on-map footprint contains the point
			local function FindPinAt(nx, ny)
				local canvas = WorldMapFrame:GetCanvas()
				local cw, ch = canvas:GetWidth(), canvas:GetHeight()
				local best, bestDist
				for i = 1, #LeaMapsPOI do
					local pin = LeaMapsPOI[i]
					if pin:IsShown() then
						-- Distance in canvas units (pins are children of the canvas)
						local dx = (nx - pin.data[2] / 100) * cw
						local dy = (ny - pin.data[3] / 100) * ch
						local s = pin:GetScale() * hitScale * 0.5
						if math.abs(dx) <= pin:GetWidth() * s and math.abs(dy) <= pin:GetHeight() * s then
							local d = dx * dx + dy * dy
							if not bestDist or d < bestDist then
								best, bestDist = pin, d
							end
						end
					end
				end
				return best
			end

			-- True if the frame is part of the world map (used to detect Blizzard map pins)
			local function IsOnWorldMap(frame)
				local depth = 0
				while frame and depth < 20 do
					if frame == WorldMapFrame then return true end
					frame = frame:GetParent()
					depth = depth + 1
				end
				return false
			end

			-- Parented to the map, so it only runs while the map is open
			local hoverDriver = CreateFrame("Frame", nil, WorldMapFrame)
			hoverDriver:SetScript("OnUpdate", function()
				-- Points of interest are hidden while a dungeon map is showing (or its list for a dungeon icon is open)
				if (LeaMapsLC.IsDungeonMapShown and LeaMapsLC.IsDungeonMapShown()) or (mapTheme.dungeonPopup and mapTheme.dungeonPopup.frame:IsShown()) then
					SetHoveredPin(nil)
					return
				end

				local gamepadUI = UpdateActiveInput()

				-- Pin under the gamepad crosshair
				local gamepadPin
				if gamepadUI then
					local gx, gy = WorldMapFrame:GetNormalizedGamepadCursorPosition()
					if gx and gy then gamepadPin = FindPinAt(gx, gy) end
				end

				-- Pin under the mouse pointer
				local mousePin
				if WorldMapFrame.ScrollContainer:IsMouseOver() then
					local mx, my = WorldMapFrame:GetNormalizedCursorPosition()
					if mx and my then mousePin = FindPinAt(mx, my) end
				end

				-- Gamepad mode: crosshair only. Mouse mode: pointer first, but keep the
				-- crosshair's pin if the pointer isn't on one (matches Blizzard's pins)
				local pin
				if activeInput == "gamepad" and gamepadUI then
					pin = gamepadPin
				else
					pin = mousePin or gamepadPin
				end

				-- Read-only check: if a Blizzard map pin is showing its tooltip, step aside
				if pin and GameTooltip:IsShown() then
					local owner = GameTooltip:GetOwner()
					if owner and IsOnWorldMap(owner) then
						pin = nil
					end
				end

				SetHoveredPin(pin)
			end)
			hoverDriver:SetScript("OnHide", function() SetHoveredPin(nil) end)

			----------------------------------------------------------------------
			-- Click a zone crossing arrow, portal, tram, boat or zeppelin to show its destination map (or a dungeon icon to show its dungeon map)
			----------------------------------------------------------------------

			-- The map is changed with C_Map.OpenWorldMap, which fires WORLD_MAP_OPEN.
			-- Blizzard's own event handler then changes the map in secure code, so the
			-- map is never tainted (calling WorldMapFrame:SetMapID from here would taint it).
			-- C_Map.OpenWorldMap cannot be used in combat so arrows cannot be clicked in combat.
			-- Dungeon maps are frames of our own shown over the map so the map itself is not changed.
			do
				local downMapID, downX, downY

				-- Remember where a left click started (post-hook, Blizzard's handler runs first)
				WorldMapFrame.ScrollContainer:HookScript("OnMouseDown", function(self, button)
					if button == "LeftButton" then
						downMapID = WorldMapFrame:GetMapID()
						downX, downY = GetCursorPosition()
					else
						downMapID = nil
					end
				end)

				WorldMapFrame.ScrollContainer:HookScript("OnMouseUp", function(self, button)
					if button ~= "LeftButton" or not downMapID then return end
					local startMapID = downMapID
					downMapID = nil

					-- Ignore drags (panning the map)
					local x, y = GetCursorPosition()
					if math.abs(x - downX) > 5 or math.abs(y - downY) > 5 then return end

					-- Blizzard already used the click (such as opening a child map)
					if WorldMapFrame:GetMapID() ~= startMapID then return end

					-- Only the pin under the pointer that is currently highlighted
					local mx, my = WorldMapFrame:GetNormalizedCursorPosition()
					if not mx or not my then return end
					local pin = FindPinAt(mx, my)
					if not pin or pin ~= hoveredPin then return end
					local pinInfo = pin.data
					if not pinInfo then return end

					-- Dungeon icons show the dungeon map (if show dungeon maps is enabled)
					if IsDungeonPin(pinInfo) then
						local dungeonMaps = LeaMapsLC.DungeonMapsByName and LeaMapsLC.DungeonMapsByName[pinInfo[4]]
						if dungeonMaps and LeaMapsLC.OpenDungeonMaps then
							SetHoveredPin(nil)
							LeaMapsLC.OpenDungeonMaps(pin, pinInfo[4], dungeonMaps)
						end
						return
					end

					-- Zone crossing arrows, portals, trams, boats and zeppelins show their destination map (OpenWorldMap cannot be used in combat)
					if not IsMapLink(pinInfo) or not C_Map.OpenWorldMap then return end
					if InCombatLockdown() then return end
					C_Map.OpenWorldMap(pinInfo[13])
				end)
			end

			----------------------------------------------------------------------
			-- Adding and refreshing pins
			----------------------------------------------------------------------

			function LeaMapsPOI:Add(pinInfo)
				local icon = POIIcons[pinInfo[1]]
				if not icon then return end

				local pin = table.remove(LeaMapsPOIPool) or CreatePOIFrame()
				pin.data = pinInfo
				-- Instance map IDs for dungeon icons (also read by Leatrix Plus info cards)
				pin.DungeonMaps = IsDungeonPin(pinInfo) and LeaMapsLC.DungeonMapsByName and LeaMapsLC.DungeonMapsByName[pinInfo[4]] or nil
				pin.Highlight:Hide()
				pin:SetScale(poiScale / WorldMapFrame:GetCanvasScale())
				SetupIcon(pin, icon, pinInfo[12])
				PositionPOI(pin)
				pin:Show()

				self[#self + 1] = pin
			end

			local function ShouldShow(kind)
				local dungeons = LeaMapsLC["ShowDungeonIcons"] == "On"
				local flight = LeaMapsLC["ShowFlightPoints"] == "On"
				local bztram = LeaMapsLC["ShowBoatZeppTram"] == "On"
				local portal = LeaMapsLC["ShowPortals"] == "On"
				local opposing = LeaMapsLC["ShowOpposingPoi"] == "On"
				local own, other = "A", "H"
				if playerFaction == "Horde" then own, other = "H", "A" end

				if kind == "Dungeon" or kind == "Raid" or kind == "Dunraid" then return dungeons end
				if kind == "Spirit" then return LeaMapsLC["ShowSpiritHealers"] == "On" end
				if kind == "Arrow" then return LeaMapsLC["ShowZoneCrossings"] == "On" end
				if kind == "FlightN" or kind == "Flight" .. own then return flight end
				if kind == "Flight" .. other then return flight and opposing end
				if kind == "TravelN" or kind == "Travel" .. own then return bztram end
				if kind == "Travel" .. other then return bztram and opposing end
				if kind == "PortalN" or kind == "Portal" .. own then return portal end
				if kind == "Portal" .. other then return portal and opposing end
				return false
			end

			function LeaMapsPOI:RefreshAllData()
				SetHoveredPin(nil)

				for i = #self, 1, -1 do
					local pin = self[i]
					pin:Hide()
					pin:ClearAllPoints()
					pin.data = nil
					pin.DungeonMaps = nil
					LeaMapsPOIPool[#LeaMapsPOIPool + 1] = pin
					self[i] = nil
				end

				-- Points of interest are hidden while a dungeon map is showing
				if LeaMapsLC.IsDungeonMapShown and LeaMapsLC.IsDungeonMapShown() then return end

				local mapPins = WorldMapFrame.mapID and PinData[WorldMapFrame.mapID]
				if not mapPins then return end

				for i = 1, #mapPins do
					local pinInfo = mapPins[i]
					if pinInfo and ShouldShow(pinInfo[1]) then
						self:Add(pinInfo)
					end
				end
			end

			hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
				if WorldMapFrame:IsShown() then
					LeaMapsPOI:RefreshAllData()
				end
			end)

			-- Used by show dungeon maps (points of interest are hidden while a dungeon map is showing)
			LeaMapsLC.RefreshPointsOfInterest = function()
				if WorldMapFrame:IsShown() then
					LeaMapsPOI:RefreshAllData()
				end
			end

			----------------------------------------------------------------------
			-- Configuration panel
			----------------------------------------------------------------------

			-- Create configuraton panel
			local poiFrame = LeaMapsLC:CreatePanel("Show points of interest", "poiFrame")

			-- Add controls
			LeaMapsLC:MakeTx(poiFrame, "Settings", 16, -72)
			LeaMapsLC:MakeCB(poiFrame, "ShowDungeonIcons", "Show dungeons and raids", 16, -92, false, "If checked, dungeons and raids will be shown.")
			LeaMapsLC:MakeCB(poiFrame, "ShowFlightPoints", "Show flight points", 16, -112, false, "If checked, flight points will be shown.")
			LeaMapsLC:MakeCB(poiFrame, "ShowBoatZeppTram", "Show boats, zeppelins and trams", 16, -132, false, "If checked, boat harbors, zepplin towers and tram stations will be shown.")
			LeaMapsLC:MakeCB(poiFrame, "ShowPortals", "Show portals", 16, -152, false, "If checked, portals will be shown.")
			LeaMapsLC:MakeCB(poiFrame, "ShowSpiritHealers", "Show spirit healers", 16, -172, false, "If checked, spirit healers will be shown.")
			LeaMapsLC:MakeCB(poiFrame, "ShowZoneCrossings", "Show zone crossings", 16, -192, false, "If checked, zone crossings will be shown.|n|nThese are arrows that indicate the zone exit pathways.")

			local PoiFooter = LeaMapsLC:MakeFT(poiFrame, "For the settings above, you can show opposing faction points of interest too where applicable.", 16, 380, 136)
			LeaMapsLC:MakeCB(poiFrame, "ShowOpposingPoi", "Show opposing faction points of interest", 16, -292, false, "If checked, points of interest belonging to the opposing faction will be shown.|n|nThis applies to flight points, boats, zeppelins and trams, and portals.")

			-- Function to refresh points of interest
			local function SetPointsOfInterest()
				LeaMapsPOI:RefreshAllData()
				UpdatePOIScale()
			end

			-- Set points of interest when options are clicked
			LeaMapsCB["ShowDungeonIcons"]:HookScript("OnClick", SetPointsOfInterest)
			LeaMapsCB["ShowFlightPoints"]:HookScript("OnClick", SetPointsOfInterest)
			LeaMapsCB["ShowBoatZeppTram"]:HookScript("OnClick", SetPointsOfInterest)
			LeaMapsCB["ShowPortals"]:HookScript("OnClick", SetPointsOfInterest)
			LeaMapsCB["ShowSpiritHealers"]:HookScript("OnClick", SetPointsOfInterest)
			LeaMapsCB["ShowZoneCrossings"]:HookScript("OnClick", SetPointsOfInterest)
			LeaMapsCB["ShowOpposingPoi"]:HookScript("OnClick", SetPointsOfInterest)

			-- Back to Main Menu button click
			poiFrame.b:HookScript("OnClick", function()
				poiFrame:Hide()
				LeaMapsLC["PageF"]:Show()
			end)

			-- Reset button click
			poiFrame.r:HookScript("OnClick", function()
				LeaMapsLC["ShowDungeonIcons"] = "On"
				LeaMapsLC["ShowFlightPoints"] = "On"
				LeaMapsLC["ShowBoatZeppTram"] = "On"
				LeaMapsLC["ShowPortals"] = "On"
				LeaMapsLC["ShowSpiritHealers"] = "On"
				LeaMapsLC["ShowZoneCrossings"] = "On"
				LeaMapsLC["ShowOpposingPoi"] = "Off"
				SetPointsOfInterest()
				poiFrame:Hide(); poiFrame:Show()
			end)

			-- Show configuration panel when configuration button is clicked
			LeaMapsCB["ShowPointsOfInterestBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaMapsLC["ShowDungeonIcons"] = "On"
					LeaMapsLC["ShowFlightPoints"] = "On"
					LeaMapsLC["ShowBoatZeppTram"] = "On"
					LeaMapsLC["ShowPortals"] = "On"
					LeaMapsLC["ShowSpiritHealers"] = "On"
					LeaMapsLC["ShowZoneCrossings"] = "On"
					LeaMapsLC["ShowOpposingPoi"] = "Off"
					SetPointsOfInterest()
					if poiFrame:IsShown() then poiFrame:Hide(); poiFrame:Show(); end
				else
					poiFrame:Show()
					LeaMapsLC["PageF"]:Hide()
				end
			end)

		end

		----------------------------------------------------------------------
		-- Show unexplored areas
		----------------------------------------------------------------------

		if LeaMapsLC["RevealMap"] == "On" then

			-- Create table to store revealed overlays
			local overlayTextures = {}
			local bfoverlayTextures = {}
			local tex = {}

			-- Function to refresh overlays (Blizzard_SharedMapDataProviders\MapExplorationDataProvider)
			local function MapExplorationPin_RefreshOverlays(pin, fullUpdate)

				-- Remove existing textures
				for k, v in pairs(tex) do
					v:SetVertexColor(1, 1, 1, 1)
				end
				wipe(tex)

				overlayTextures = {}
				local mapID = WorldMapFrame.mapID; if not mapID then return end
				local artID = C_Map.GetMapArtID(mapID); if not artID or not Leatrix_Maps["Reveal"][artID] then return end
				local LeaMapsZone = Leatrix_Maps["Reveal"][artID]

				-- Store already explored tiles in a table so they can be ignored
				local TileExists = {}
				local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(mapID)
				if exploredMapTextures then
					for i, exploredTextureInfo in ipairs(exploredMapTextures) do
						local key = exploredTextureInfo.textureWidth .. ":" .. exploredTextureInfo.textureHeight .. ":" .. exploredTextureInfo.offsetX .. ":" .. exploredTextureInfo.offsetY
						TileExists[key] = true
					end
				end

				-- Get the sizes
				pin.layerIndex = pin:GetMap():GetCanvasContainer():GetCurrentLayerIndex()
				local layers = C_Map.GetMapArtLayers(mapID)
				local layerInfo = layers and layers[pin.layerIndex]
				if not layerInfo then return end
				local TILE_SIZE_WIDTH = layerInfo.tileWidth
				local TILE_SIZE_HEIGHT = layerInfo.tileHeight

				-- Get the map type (needed to make sure only zone maps are tinted)
				local mapType = C_Map.GetMapInfo(mapID).mapType
				if not mapType then mapType = 0 end

				-- Show textures if they are in database and have not been explored
				for key, files in pairs(LeaMapsZone) do
					if not TileExists[key] then
						local width, height, offsetX, offsetY = strsplit(":", key)
						local fileDataIDs = { strsplit(",", files) }
						local numTexturesWide = ceil(width/TILE_SIZE_WIDTH)
						local numTexturesTall = ceil(height/TILE_SIZE_HEIGHT)
						local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight
						for j = 1, numTexturesTall do
							if ( j < numTexturesTall ) then
								texturePixelHeight = TILE_SIZE_HEIGHT
								textureFileHeight = TILE_SIZE_HEIGHT
							else
								texturePixelHeight = mod(height, TILE_SIZE_HEIGHT)
								if ( texturePixelHeight == 0 ) then
									texturePixelHeight = TILE_SIZE_HEIGHT
								end
								textureFileHeight = 16
								while(textureFileHeight < texturePixelHeight) do
									textureFileHeight = textureFileHeight * 2
								end
							end
							for k = 1, numTexturesWide do
								local texture = pin.overlayTexturePool:Acquire()
								tinsert(tex, texture)
								if ( k < numTexturesWide ) then
									texturePixelWidth = TILE_SIZE_WIDTH
									textureFileWidth = TILE_SIZE_WIDTH
								else
									texturePixelWidth = mod(width, TILE_SIZE_WIDTH)
									if ( texturePixelWidth == 0 ) then
										texturePixelWidth = TILE_SIZE_WIDTH
									end
									textureFileWidth = 16
									while(textureFileWidth < texturePixelWidth) do
										textureFileWidth = textureFileWidth * 2
									end
								end
								texture:SetSize(texturePixelWidth, texturePixelHeight)
								texture:SetTexCoord(0, texturePixelWidth/textureFileWidth, 0, texturePixelHeight/textureFileHeight)
								texture:SetPoint("TOPLEFT", offsetX + (TILE_SIZE_WIDTH * (k-1)), -(offsetY + (TILE_SIZE_HEIGHT * (j - 1))))
								texture:SetTexture(tonumber(fileDataIDs[((j - 1) * numTexturesWide) + k]), nil, nil, "TRILINEAR")
								texture:SetDrawLayer("ARTWORK", -1)
								texture:Show()
								if fullUpdate then
									pin.textureLoadGroup:AddTexture(texture)
								end
								if LeaMapsLC["RevTint"] == "On" and mapType == 3 then
									texture:SetVertexColor(LeaMapsLC["tintRed"], LeaMapsLC["tintGreen"], LeaMapsLC["tintBlue"], LeaMapsLC["tintAlpha"])
								end
								tinsert(overlayTextures, texture)
							end
						end
					end
				end
			end

			-- Reset texture color and alpha
			local function TexturePool_ResetVertexColor(pool, texture)
				texture:SetVertexColor(1, 1, 1)
				texture:SetAlpha(1)
				return TexturePool_HideAndClearAnchors(pool, texture)
			end

			-- Show overlays on startup
			for pin in WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
				hooksecurefunc(pin, "RefreshOverlays", MapExplorationPin_RefreshOverlays)
				pin.overlayTexturePool.resetterFunc = TexturePool_ResetVertexColor
			end

			local bftex = {}

			-- Repeat refresh overlays function for Battlefield map
			local function bfMapExplorationPin_RefreshOverlays(pin, fullUpdate)

				-- Remove existing textures
				for k, v in pairs(bftex) do
					v:SetVertexColor(1, 1, 1, 1)
				end
				wipe(bftex)

				bfoverlayTextures = {}
				local mapID = BattlefieldMapFrame.mapID; if not mapID then return end
				local artID = C_Map.GetMapArtID(mapID); if not artID or not Leatrix_Maps["Reveal"][artID] then return end
				local LeaMapsZone = Leatrix_Maps["Reveal"][artID]

				-- Store already explored tiles in a table so they can be ignored
				local TileExists = {}
				local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(mapID)
				if exploredMapTextures then
					for i, exploredTextureInfo in ipairs(exploredMapTextures) do
						local key = exploredTextureInfo.textureWidth .. ":" .. exploredTextureInfo.textureHeight .. ":" .. exploredTextureInfo.offsetX .. ":" .. exploredTextureInfo.offsetY
						TileExists[key] = true
					end
				end

				-- Get the sizes
				pin.layerIndex = pin:GetMap():GetCanvasContainer():GetCurrentLayerIndex()
				local layers = C_Map.GetMapArtLayers(mapID)
				local layerInfo = layers and layers[pin.layerIndex]
				if not layerInfo then return end
				local TILE_SIZE_WIDTH = layerInfo.tileWidth
				local TILE_SIZE_HEIGHT = layerInfo.tileHeight

				-- Get the map type (needed to make sure only zone maps are tinted)
				local mapType = C_Map.GetMapInfo(mapID).mapType
				if not mapType then mapType = 0 end

				-- Show textures if they are in database and have not been explored
				for key, files in pairs(LeaMapsZone) do
					if not TileExists[key] then
						local width, height, offsetX, offsetY = strsplit(":", key)
						local fileDataIDs = { strsplit(",", files) }
						local numTexturesWide = ceil(width/TILE_SIZE_WIDTH)
						local numTexturesTall = ceil(height/TILE_SIZE_HEIGHT)
						local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight
						for j = 1, numTexturesTall do
							if ( j < numTexturesTall ) then
								texturePixelHeight = TILE_SIZE_HEIGHT
								textureFileHeight = TILE_SIZE_HEIGHT
							else
								texturePixelHeight = mod(height, TILE_SIZE_HEIGHT)
								if ( texturePixelHeight == 0 ) then
									texturePixelHeight = TILE_SIZE_HEIGHT
								end
								textureFileHeight = 16
								while(textureFileHeight < texturePixelHeight) do
									textureFileHeight = textureFileHeight * 2
								end
							end
							for k = 1, numTexturesWide do
								local texture = pin.overlayTexturePool:Acquire()
								tinsert(bftex, texture)
								if ( k < numTexturesWide ) then
									texturePixelWidth = TILE_SIZE_WIDTH
									textureFileWidth = TILE_SIZE_WIDTH
								else
									texturePixelWidth = mod(width, TILE_SIZE_WIDTH)
									if ( texturePixelWidth == 0 ) then
										texturePixelWidth = TILE_SIZE_WIDTH
									end
									textureFileWidth = 16
									while(textureFileWidth < texturePixelWidth) do
										textureFileWidth = textureFileWidth * 2
									end
								end
								texture:SetSize(texturePixelWidth, texturePixelHeight)
								texture:SetTexCoord(0, texturePixelWidth/textureFileWidth, 0, texturePixelHeight/textureFileHeight)
								texture:SetPoint("TOPLEFT", offsetX + (TILE_SIZE_WIDTH * (k-1)), -(offsetY + (TILE_SIZE_HEIGHT * (j - 1))))
								texture:SetTexture(tonumber(fileDataIDs[((j - 1) * numTexturesWide) + k]), nil, nil, "TRILINEAR")
								texture:SetDrawLayer("ARTWORK", -1)
								texture:Show()
								if fullUpdate then
									pin.textureLoadGroup:AddTexture(texture)
								end
								if LeaMapsLC["RevTint"] == "On" and mapType == 3 then
									texture:SetVertexColor(LeaMapsLC["tintRed"], LeaMapsLC["tintGreen"], LeaMapsLC["tintBlue"], LeaMapsLC["tintAlpha"])
								end
								tinsert(bfoverlayTextures, texture)
							end
						end
					end
				end
			end

			for pin in BattlefieldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
				hooksecurefunc(pin, "RefreshOverlays", bfMapExplorationPin_RefreshOverlays)
				pin.overlayTexturePool.resetterFunc = TexturePool_ResetVertexColor
			end

			-- Create tint frame
			local tintFrame = LeaMapsLC:CreatePanel("Show unexplored areas", "tintFrame")

			-- Add controls
			LeaMapsLC:MakeTx(tintFrame, "Settings", 16, -72)
			LeaMapsLC:MakeCB(tintFrame, "RevTint", "Tint unexplored areas", 16, -92, false, "If checked, unexplored areas will be tinted.")
			LeaMapsLC:MakeSL(tintFrame, "tintRed", "Red", "Drag to set the amount of red.", 0, 1, 0.1, 36, -142, "%.1f")
			LeaMapsLC:MakeSL(tintFrame, "tintGreen", "Green", "Drag to set the amount of green.", 0, 1, 0.1, 36, -202, "%.1f")
			LeaMapsLC:MakeSL(tintFrame, "tintBlue", "Blue", "Drag to set the amount of blue.", 0, 1, 0.1, 206, -142, "%.1f")
			LeaMapsLC:MakeSL(tintFrame, "tintAlpha", "Opacity", "Drag to set the opacity.", 0.1, 1, 0.1, 206, -202, "%.1f")

			-- Add preview color block
			local prvTitle = LeaMapsLC:MakeWD(tintFrame, "Preview", 386, -130); prvTitle:Hide()
			tintFrame.preview = tintFrame:CreateTexture(nil, "ARTWORK")
			tintFrame.preview:SetSize(50, 50)
			tintFrame.preview:SetPoint("TOPLEFT", prvTitle, "TOPLEFT", 0, -20)

			-- Function to set tint color
			local function SetTintCol()
				tintFrame.preview:SetColorTexture(LeaMapsLC["tintRed"], LeaMapsLC["tintGreen"], LeaMapsLC["tintBlue"], LeaMapsLC["tintAlpha"])
				-- Set slider values
				LeaMapsCB["tintRed"].f:SetFormattedText("%.0f%%", LeaMapsLC["tintRed"] * 100)
				LeaMapsCB["tintGreen"].f:SetFormattedText("%.0f%%", LeaMapsLC["tintGreen"] * 100)
				LeaMapsCB["tintBlue"].f:SetFormattedText("%.0f%%", LeaMapsLC["tintBlue"] * 100)
				LeaMapsCB["tintAlpha"].f:SetFormattedText("%.0f%%", LeaMapsLC["tintAlpha"] * 100)
				-- Set tint
				if LeaMapsLC["RevTint"] == "On" then
					-- Enable tint
					for i = 1, #overlayTextures  do
						overlayTextures[i]:SetVertexColor(LeaMapsLC["tintRed"], LeaMapsLC["tintGreen"], LeaMapsLC["tintBlue"], LeaMapsLC["tintAlpha"])
					end
					for i = 1, #bfoverlayTextures do
						bfoverlayTextures[i]:SetVertexColor(LeaMapsLC["tintRed"], LeaMapsLC["tintGreen"], LeaMapsLC["tintBlue"], LeaMapsLC["tintAlpha"])
					end
					-- Enable controls
					LeaMapsCB["tintRed"]:Enable(); LeaMapsCB["tintRed"]:SetAlpha(1.0)
					LeaMapsCB["tintGreen"]:Enable(); LeaMapsCB["tintGreen"]:SetAlpha(1.0)
					LeaMapsCB["tintBlue"]:Enable(); LeaMapsCB["tintBlue"]:SetAlpha(1.0)
					LeaMapsCB["tintAlpha"]:Enable(); LeaMapsCB["tintAlpha"]:SetAlpha(1.0)
					prvTitle:SetAlpha(1.0); tintFrame.preview:SetAlpha(1.0)
				else
					-- Disable tint
					for i = 1, #overlayTextures  do
						overlayTextures[i]:SetVertexColor(1, 1, 1)
						overlayTextures[i]:SetAlpha(1.0)
					end
					for i = 1, #bfoverlayTextures  do
						bfoverlayTextures[i]:SetVertexColor(1, 1, 1)
						bfoverlayTextures[i]:SetAlpha(1.0)
					end
					-- Disable controls
					LeaMapsCB["tintRed"]:Disable(); LeaMapsCB["tintRed"]:SetAlpha(0.3)
					LeaMapsCB["tintGreen"]:Disable(); LeaMapsCB["tintGreen"]:SetAlpha(0.3)
					LeaMapsCB["tintBlue"]:Disable(); LeaMapsCB["tintBlue"]:SetAlpha(0.3)
					LeaMapsCB["tintAlpha"]:Disable(); LeaMapsCB["tintAlpha"]:SetAlpha(0.3)
					prvTitle:SetAlpha(0.3); tintFrame.preview:SetAlpha(0.3)
				end
			end

			-- Set tint properties when controls are changed and on startup
			LeaMapsCB["RevTint"]:HookScript("OnClick", SetTintCol)
			LeaMapsCB["tintRed"]:HookScript("OnMouseWheel", SetTintCol)
			LeaMapsCB["tintRed"]:HookScript("OnValueChanged", SetTintCol)
			LeaMapsCB["tintGreen"]:HookScript("OnMouseWheel", SetTintCol)
			LeaMapsCB["tintGreen"]:HookScript("OnValueChanged", SetTintCol)
			LeaMapsCB["tintBlue"]:HookScript("OnMouseWheel", SetTintCol)
			LeaMapsCB["tintBlue"]:HookScript("OnValueChanged", SetTintCol)
			LeaMapsCB["tintAlpha"]:HookScript("OnMouseWheel", SetTintCol)
			LeaMapsCB["tintAlpha"]:HookScript("OnValueChanged", SetTintCol)
			SetTintCol()

			-- Back to Main Menu button click
			tintFrame.b:HookScript("OnClick", function()
				tintFrame:Hide()
				LeaMapsLC["PageF"]:Show()
			end)

			-- Reset button click
			tintFrame.r:HookScript("OnClick", function()
				LeaMapsLC["RevTint"] = "On"
				LeaMapsLC["tintRed"] = 0.6
				LeaMapsLC["tintGreen"] = 0.6
				LeaMapsLC["tintBlue"] = 1
				LeaMapsLC["tintAlpha"] = 1
				SetTintCol()
				tintFrame:Hide(); tintFrame:Show()
			end)

			-- Show tint configuration panel when configuration button is clicked
			LeaMapsCB["RevTintBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaMapsLC["RevTint"] = "On"
					LeaMapsLC["tintRed"] = 0.6
					LeaMapsLC["tintGreen"] = 0.6
					LeaMapsLC["tintBlue"] = 1
					LeaMapsLC["tintAlpha"] = 1
					SetTintCol()
					if tintFrame:IsShown() then tintFrame:Hide(); tintFrame:Show(); end
				else
					tintFrame:Show()
					LeaMapsLC["PageF"]:Hide()
				end
			end)

		end

		----------------------------------------------------------------------
		-- Show minimap icon
		----------------------------------------------------------------------

		do

			-- Minimap button click function
			local function MiniBtnClickFunc(arg1)
				-- No modifier key toggles the options panel
				if LeaMapsLC:IsMapsShowing() then
					LeaMapsLC["PageF"]:Hide()
					LeaMapsLC:HideConfigPanels()
				else
					LeaMapsLC["PageF"]:Show()
				end
			end

			-- Assign global scope for function (it's used in TOC)
			_G.LeaMapsGlobalMiniBtnClickFunc = MiniBtnClickFunc

			-- Create minimap button using LibDBIcon
			local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("Leatrix_Maps", {
				type = "data source",
				text = "Leatrix Maps",
				icon = "Interface\\HELPFRAME\\HelpIcon-Bug",
				OnClick = function(self, btn)
					MiniBtnClickFunc(btn)
				end,
				OnTooltipShow = function(tooltip)
					if not tooltip or not tooltip.AddLine then return end
					tooltip:AddLine("Leatrix Maps")
				end,
			})

			local icon = LibStub("LibDBIcon-1.0", true)
			icon:Register("Leatrix_Maps", miniButton, LeaMapsDB)

			-- Function to toggle LibDBIcon
			local function SetLibDBIconFunc()
				if LeaMapsLC["ShowMinimapIcon"] == "On" then
					LeaMapsDB["hide"] = false
					icon:Show("Leatrix_Maps")
				else
					LeaMapsDB["hide"] = true
					icon:Hide("Leatrix_Maps")
				end
			end

			-- Set LibDBIcon when option is clicked and on startup
			LeaMapsCB["ShowMinimapIcon"]:HookScript("OnClick", SetLibDBIconFunc)
			SetLibDBIconFunc()

		end

		----------------------------------------------------------------------
		-- Show memory usage
		----------------------------------------------------------------------

		do

			-- Show memory usage stat
			local function ShowMemoryUsage(frame, anchor, x, y)

				-- Create frame
				local memframe = CreateFrame("FRAME", nil, frame)
				memframe:ClearAllPoints()
				memframe:SetPoint(anchor, x, y)
				memframe:SetWidth(100)
				memframe:SetHeight(20)

				-- Create labels
				local pretext = memframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
				pretext:SetPoint("TOPLEFT", 0, 0)
				pretext:SetText(L["Memory Usage"])

				local memtext = memframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
				memtext:SetPoint("TOPLEFT", 0, 0 - 30)

				-- Create stat
				local memstat = memframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
				memstat:SetPoint("BOTTOMLEFT", memtext, "BOTTOMRIGHT")
				memstat:SetText("(calculating...)")

				-- Create update script
				local memtime = -1
				memframe:SetScript("OnUpdate", function(self, elapsed)
					if memtime > 2 or memtime == -1 then
						UpdateAddOnMemoryUsage()
						memtext = GetAddOnMemoryUsage("Leatrix_Maps")
						memtext = math.floor(memtext + .5) .. " KB"
						memstat:SetText(memtext)
						memtime = 0
					end
					memtime = memtime + elapsed
				end)

			end

			-- ShowMemoryUsage(LeaMapsLC["PageF"], "TOPLEFT", 16, -282)

		end

		----------------------------------------------------------------------
		-- Create panel in game options panel
		----------------------------------------------------------------------

		do

			local interPanel = CreateFrame("FRAME")
			interPanel.name = "Leatrix Maps"

			local maintitle = LeaMapsLC:MakeTx(interPanel, "Leatrix Maps", 0, 0)
			maintitle:SetFont(maintitle:GetFont(), 72)
			maintitle:ClearAllPoints()
			maintitle:SetPoint("TOP", 0, -72)

			local expTitle = LeaMapsLC:MakeTx(interPanel, "Shadowlands", 0, 0)
			expTitle:SetFont(expTitle:GetFont(), 32)
			expTitle:ClearAllPoints()
			expTitle:SetPoint("TOP", 0, -152)

			local subTitle = LeaMapsLC:MakeTx(interPanel, "curseforge.com/wow/addons/leatrix-maps", 0, 0)
			subTitle:SetFont(subTitle:GetFont(), 20)
			subTitle:ClearAllPoints()
			subTitle:SetPoint("BOTTOM", 0, 72)

			local slashTitle = LeaMapsLC:MakeTx(interPanel, "/ltm", 0, 0)
			slashTitle:SetFont(slashTitle:GetFont(), 72)
			slashTitle:ClearAllPoints()
			slashTitle:SetPoint("BOTTOM", subTitle, "TOP", 0, 40)
			slashTitle:SetScript("OnMouseUp", function(self, button)
				if button == "LeftButton" then
					SlashCmdList["Leatrix_Maps"]("")
				end
			end)
			slashTitle:SetScript("OnEnter", function()
				slashTitle.r,  slashTitle.g, slashTitle.b = slashTitle:GetTextColor()
				slashTitle:SetTextColor(1, 1, 0)
			end)
			slashTitle:SetScript("OnLeave", function()
				slashTitle:SetTextColor(slashTitle.r, slashTitle.g, slashTitle.b)
			end)

			local pTex = interPanel:CreateTexture(nil, "BACKGROUND")
			pTex:SetAllPoints()
			pTex:SetTexture("Interface\\GLUES\\Models\\UI_MainMenu\\swordgradient2")
			pTex:SetAlpha(0.2)
			pTex:SetTexCoord(0, 1, 1, 0)

			expTitle:SetText(L["Forever"])
			local category = Settings.RegisterCanvasLayoutCategory(interPanel, "Leatrix Maps")
			Settings.RegisterAddOnCategory(category)

		end

		----------------------------------------------------------------------
		-- Final code
		----------------------------------------------------------------------

		-- Hide the battlefield map tab because it's shown even when enhance battlefield map is disabled
		BattlefieldMapTab:Hide()

		-- Show first run message
		if not LeaMapsDB["FirstRunMessageSeen"] then
			C_Timer.After(1, function()
				LeaMapsLC:Print(L["Enter"] .. " |cff00ff00" .. "/ltm" .. "|r " .. L["or click the minimap button to open Leatrix Maps."])
				LeaMapsDB["FirstRunMessageSeen"] = true
			end)
		end

		-- Release memory
		LeaMapsLC.MainFunc = nil

	end

	----------------------------------------------------------------------
	-- L10: Functions
	----------------------------------------------------------------------

	-- Function to add textures to panels
	function LeaMapsLC:CreateBar(name, parent, width, height, anchor, r, g, b, alp, tex)
		-- The footer is drawn above the main texture (they overlap at the bottom of the panel)
		local ft = parent:CreateTexture(nil, "BORDER", nil, name == "FootTexture" and 1 or 0)
		ft:SetTexture(tex)
		ft:SetSize(width, height)
		ft:SetPoint(anchor)
		ft:SetVertexColor(r ,g, b, alp)
		if name == "MainTexture" then
			ft:SetTexCoord(0.09, 1, 0, 1)
		end
	end

	-- Create a configuration panel
	function LeaMapsLC:CreatePanel(title, globref)

		-- Create the panel
		local Side = CreateFrame("Frame", LeaMapsLC:CreateRandomName(), UIParent)

		-- Make it a system frame
		table.insert(UISpecialFrames, Side:GetName())

		-- Store it in the configuration panel table
		tinsert(LeaConfigList, Side)

		-- Set frame parameters
		Side:Hide()
		Side:SetSize(470, 420)
		Side:SetClampedToScreen(true)
		Side:SetFrameStrata("FULLSCREEN_DIALOG")
		Side:SetFrameLevel(20)

		-- Set the background color
		Side.t = Side:CreateTexture(nil, "BACKGROUND")
		Side.t:SetAllPoints()
		Side.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

		-- Add a close Button (LeaMapsLC: Custom template)
		Side.c = LeaMapsLC:CreateCloseButton(Side, 30, 30, "TOPRIGHT", 0, 0)
		Side.c:SetScript("OnClick", function() Side:Hide() end)

		-- Add reset, help and back buttons
		Side.r = LeaMapsLC:CreateButton("ResetButton", Side, "Reset", "BOTTOMLEFT", 16, 60, 25, "Click to reset the settings on this page.")
		Side.b = LeaMapsLC:CreateButton("BackButton", Side, "Back to Main Menu", "BOTTOMRIGHT", -16, 60, 25, "Click to return to the main menu.")

		-- Add a reload button and synchronise it with the main panel reload button
		local reloadb = LeaMapsLC:CreateButton("ConfigReload", Side, "Reload", "BOTTOMRIGHT", -16, 10, 25, LeaMapsCB["ReloadUIButton"].tiptext)
		LeaMapsLC:LockItem(reloadb, true)
		reloadb:SetScript("OnClick", ReloadUI)

		reloadb.f = reloadb:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
		reloadb.f:SetHeight(32)
		reloadb.f:SetPoint('RIGHT', reloadb, 'LEFT', -10, 0)
		reloadb.f:SetText(LeaMapsCB["ReloadUIButton"].f:GetText())
		reloadb.f:Hide()

		LeaMapsCB["ReloadUIButton"]:HookScript("OnEnable", function()
			LeaMapsLC:LockItem(reloadb, false)
			reloadb.f:Show()
		end)

		LeaMapsCB["ReloadUIButton"]:HookScript("OnDisable", function()
			LeaMapsLC:LockItem(reloadb, true)
			reloadb.f:Hide()
		end)

		-- Add reset map layout button (once, it's on the main panel)
		if not LeaMapsCB["ResetMapLayoutButton"] then
			local resetMapBtn = LeaMapsLC:CreateButton("ResetMapLayoutButton", LeaMapsLC["PageF"], "Reset map layout", "BOTTOMLEFT", 16, 10, 25, "Click to reset the map position and scale to the game default.")
			resetMapBtn:SetScript("OnClick", function()
				-- Do nothing if the map frame cannot be changed (the button is locked then)
				if not LeaMapsLC:CanChangeMap() then return end
				-- Reset saved map position and scale
				LeaMapsLC["MapPosA"], LeaMapsLC["MapPosR"], LeaMapsLC["MapPosX"], LeaMapsLC["MapPosY"] = "TOPLEFT", "TOPLEFT", 16, -94
				LeaMapsLC["MaxMapPosA"], LeaMapsLC["MaxMapPosR"], LeaMapsLC["MaxMapPosX"], LeaMapsLC["MaxMapPosY"] = "CENTER", "CENTER", 0, 0
				LeaMapsLC["MapScale"] = 1.0
				LeaMapsLC["MaxMapScale"] = 1.0
				-- Apply them now
				WorldMapFrame:SetScale(1)
				if LeaMapsLC["UnlockMap"] == "On" then
					WorldMapFrame:ClearAllPoints()
					if WorldMapFrame:IsMaximized() then
						WorldMapFrame:SetPoint(LeaMapsLC["MaxMapPosA"], UIParent, LeaMapsLC["MaxMapPosR"], LeaMapsLC["MaxMapPosX"], LeaMapsLC["MaxMapPosY"])
					else
						WorldMapFrame:SetPoint(LeaMapsLC["MapPosA"], UIParent, LeaMapsLC["MapPosR"], LeaMapsLC["MapPosX"], LeaMapsLC["MapPosY"])
					end
				end
			end)
			-- Lock the button while the map frame cannot be changed
			LeaMapsLC:AddMapLock(function(lock)
				LeaMapsLC:LockItem(resetMapBtn, lock)
			end)
		end

		-- Set textures
		LeaMapsLC:CreateBar("FootTexture", Side, 470, 48, "BOTTOM", 0.5, 0.5, 0.5, 1.0, "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		LeaMapsLC:CreateBar("MainTexture", Side, 470, 403, "TOPRIGHT", 0.7, 0.7, 0.7, 0.7,  "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")

		-- Allow movement
		Side:EnableMouse(true)
		Side:SetMovable(true)
		Side:RegisterForDrag("LeftButton")
		Side:SetScript("OnDragStart", Side.StartMoving)
		Side:SetScript("OnDragStop", function ()
			Side:StopMovingOrSizing()
			Side:SetUserPlaced(false)
			-- Save panel position
			LeaMapsLC["MainPanelA"], void, LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"] = Side:GetPoint()
		end)

		-- Set panel attributes when shown
		Side:SetScript("OnShow", function()
			Side:ClearAllPoints()
			Side:SetPoint(LeaMapsLC["MainPanelA"], UIParent, LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"])
		end)

		-- Add title
		Side.f = Side:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		Side.f:SetPoint('TOPLEFT', 16, -16)
		Side.f:SetText(L[title])

		-- Add description
		Side.v = Side:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
		Side.v:SetHeight(32)
		Side.v:SetPoint('TOPLEFT', Side.f, 'BOTTOMLEFT', 0, -8)
		Side.v:SetPoint('RIGHT', Side, -32, 0)
		Side.v:SetJustifyH('LEFT'); Side.v:SetJustifyV('TOP')
		Side.v:SetText(L["Configuration Panel"])

		-- Prevent options panel from showing while side panel is showing
		LeaMapsLC["PageF"]:HookScript("OnShow", function()
			if Side:IsShown() then LeaMapsLC["PageF"]:Hide(); end
		end)

		-- Return the frame
		return Side

	end

	-- Hide configuration panels
	function LeaMapsLC:HideConfigPanels()
		for k, v in pairs(LeaConfigList) do
			v:Hide()
		end
	end

	-- Create a close button without using a template
	function LeaMapsLC:CreateCloseButton(parent, w, h, anchor, x, y)
		local btn = CreateFrame("BUTTON", nil, parent)
		btn:SetSize(w, h)
		btn:SetPoint(anchor, x, y)
		btn:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		btn:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
		btn:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
		btn:SetDisabledTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Disabled")
		return btn
	end

	-- Find out if Leatrix Maps is showing (main panel or config panel)
	function LeaMapsLC:IsMapsShowing()
		if LeaMapsLC["PageF"]:IsShown() then return true end
		for k, v in pairs(LeaConfigList) do
			if v:IsShown() then
				return true
			end
		end
	end

	-- Load a string variable or set it to default if it's not set to "On" or "Off"
	function LeaMapsLC:LoadVarChk(var, def)
		if LeaMapsDB[var] and type(LeaMapsDB[var]) == "string" and LeaMapsDB[var] == "On" or LeaMapsDB[var] == "Off" then
			LeaMapsLC[var] = LeaMapsDB[var]
		else
			LeaMapsLC[var] = def
			LeaMapsDB[var] = def
		end
	end

	-- Load a numeric variable and set it to default if it's not within a given range
	function LeaMapsLC:LoadVarNum(var, def, valmin, valmax)
		if LeaMapsDB[var] and type(LeaMapsDB[var]) == "number" and LeaMapsDB[var] >= valmin and LeaMapsDB[var] <= valmax then
			LeaMapsLC[var] = LeaMapsDB[var]
		else
			LeaMapsLC[var] = def
			LeaMapsDB[var] = def
		end
	end

	-- Load an anchor point variable and set it to default if the anchor point is invalid
	function LeaMapsLC:LoadVarAnc(var, def)
		if LeaMapsDB[var] and type(LeaMapsDB[var]) == "string" and LeaMapsDB[var] == "CENTER" or LeaMapsDB[var] == "TOP" or LeaMapsDB[var] == "BOTTOM" or LeaMapsDB[var] == "LEFT" or LeaMapsDB[var] == "RIGHT" or LeaMapsDB[var] == "TOPLEFT" or LeaMapsDB[var] == "TOPRIGHT" or LeaMapsDB[var] == "BOTTOMLEFT" or LeaMapsDB[var] == "BOTTOMRIGHT" then
			LeaMapsLC[var] = LeaMapsDB[var]
		else
			LeaMapsLC[var] = def
			LeaMapsDB[var] = def
		end
	end

	-- Show tooltips for checkboxes
	function LeaMapsLC:TipSee()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		local parent = self:GetParent()
		local pscale = parent:GetEffectiveScale()
		local gscale = UIParent:GetEffectiveScale()
		local tscale = GameTooltip:GetEffectiveScale()
		local gap = ((UIParent:GetRight() * gscale) - (parent:GetRight() * pscale))
		if gap < (250 * tscale) then
			GameTooltip:SetPoint("TOPRIGHT", parent, "TOPLEFT", 0, 0)
		else
			GameTooltip:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
		end
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end

	-- Show tooltips for configuration buttons and dropdown menus
	function LeaMapsLC:ShowTooltip()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		local parent = LeaMapsLC["PageF"]
		local pscale = parent:GetEffectiveScale()
		local gscale = UIParent:GetEffectiveScale()
		local tscale = GameTooltip:GetEffectiveScale()
		local gap = ((UIParent:GetRight() * gscale) - (LeaMapsLC["PageF"]:GetRight() * pscale))
		if gap < (250 * tscale) then
			GameTooltip:SetPoint("TOPRIGHT", parent, "TOPLEFT", 0, 0)
		else
			GameTooltip:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
		end
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end

	-- Print text
	function LeaMapsLC:Print(text)
		DEFAULT_CHAT_FRAME:AddMessage(L[text], 1.0, 0.85, 0.0)
	end

	-- Check if player is in combat
	function LeaMapsLC:PlayerInCombat()
		if UnitAffectingCombat("player") then
			LeaMapsLC:Print("You cannot do that in combat.")
			return true
		end
	end

	-- Lock and unlock an item
	function LeaMapsLC:LockItem(item, lock)
		if lock then
			item:Disable()
			item:SetAlpha(0.3)
		else
			item:Enable()
			item:SetAlpha(1.0)
		end
	end

	----------------------------------------------------------------------
	-- Map frame protection
	----------------------------------------------------------------------

	-- Another addon can make the map frame protected (such as by giving it a secure child frame) and protected frames
	-- cannot be moved or scaled during combat. Actions that move or scale the map frame are not done while it cannot be
	-- changed and the controls for them are locked until it can be changed again.

	local mapLockFuncs = {}

	-- Function to check if the map frame can be moved or scaled
	function LeaMapsLC:CanChangeMap()
		return not InCombatLockdown() or not WorldMapFrame:IsProtected()
	end

	-- Function to lock or unlock controls that move or scale the map frame
	local function SetMapLocks(lock)
		for i = 1, #mapLockFuncs do
			mapLockFuncs[i](lock)
		end
	end

	-- Function to add a function that locks or unlocks controls (it's run now and when combat starts or ends)
	function LeaMapsLC:AddMapLock(func)
		tinsert(mapLockFuncs, func)
		func(not LeaMapsLC:CanChangeMap())
	end

	-- Set control locks when combat starts and ends
	local mapLockEvents = CreateFrame("Frame")
	mapLockEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
	mapLockEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
	mapLockEvents:SetScript("OnEvent", function(self, event)
		if #mapLockFuncs == 0 then return end
		if event == "PLAYER_REGEN_DISABLED" then
			-- Combat lockdown starts after this event so lock now if the map frame is protected and check again on the
			-- next frame (another addon may make the map frame protected during this event)
			if WorldMapFrame:IsProtected() then SetMapLocks(true) end
			C_Timer.After(0, function() SetMapLocks(not LeaMapsLC:CanChangeMap()) end)
		else
			SetMapLocks(not LeaMapsLC:CanChangeMap())
		end
	end)

	-- Function to set lock state for configuration buttons
	function LeaMapsLC:LockOption(option, item, reloadreq)
		if reloadreq then
			-- Option requires UI reload
			if LeaMapsLC[option] ~= LeaMapsDB[option] or LeaMapsLC[option] == "Off" then
				LeaMapsLC:LockItem(LeaMapsCB[item], true)
			else
				LeaMapsLC:LockItem(LeaMapsCB[item], false)
			end

		else
			-- Option does not require UI reload
			if LeaMapsLC[option] == "Off" then
				LeaMapsLC:LockItem(LeaMapsCB[item], true)
			else
				LeaMapsLC:LockItem(LeaMapsCB[item], false)
			end
		end
	end

	-- Set lock state for configuration buttons
	function LeaMapsLC:SetDim()
		LeaMapsLC:LockOption("SimpleMapFrame", "SimpleMapFrameBtn", true)				-- Use simple map frame
		LeaMapsLC:LockOption("ScaleWorldMap", "ScaleWorldMapBtn", true) 				-- Scale the map
		LeaMapsLC:LockOption("RevealMap", "RevTintBtn", true)							-- Shiw unexplored areas
		LeaMapsLC:LockOption("UnlockMap", "UnlockMapBtn", true)							-- Unlock map frame
		LeaMapsLC:LockOption("ShowCoords", "ShowCoordsBtn", true)						-- Show coordinates
		LeaMapsLC:LockOption("EnhanceBattleMap", "EnhanceBattleMapBtn", true) 			-- Enhance battlefield map
		LeaMapsLC:LockOption("ShowPointsOfInterest", "ShowPointsOfInterestBtn", true) 	-- Show points of interest
		LeaMapsLC:LockOption("ShowZoneLevels", "ShowZoneLevelsBtn", true) 				-- Show zone levels
	end

	-- Create a standard button
	function LeaMapsLC:CreateButton(name, frame, label, anchor, x, y, height, tip, naked)
		local mbtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		LeaMapsCB[name] = mbtn
		mbtn:SetHeight(height)
		mbtn:SetPoint(anchor, x, y)
		mbtn:SetHitRectInsets(0, 0, 0, 0)
		mbtn:SetText(L[label])

		-- Create fontstring and set button width based on it
		mbtn.f = mbtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		mbtn.f:SetText(L[label])
		mbtn:SetWidth(mbtn.f:GetStringWidth() + 20)

		-- Tooltip handler
		mbtn.tiptext = L[tip]
		mbtn:SetScript("OnEnter", LeaMapsLC.TipSee)
		mbtn:SetScript("OnLeave", GameTooltip_Hide)

		-- Set skinned button textures
		if not naked then
			mbtn:SetNormalTexture("Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps.blp")
			mbtn:GetNormalTexture():SetTexCoord(0, 0.5, 0.125, 0.25)
		end
		mbtn:SetHighlightTexture("Interface\\AddOns\\Leatrix_Maps\\Leatrix_Maps.blp")
		mbtn:GetHighlightTexture():SetTexCoord(0, 0.5, 0, 0.125)

		-- Hide the default textures
		mbtn:HookScript("OnShow", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnEnable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnDisable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnMouseDown", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnMouseUp", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)

		return mbtn
	end

	-- Set reload button status
	function LeaMapsLC:ReloadCheck()
		if	(LeaMapsLC["SimpleMapFrame"] ~= LeaMapsDB["SimpleMapFrame"])				-- Simple map frame
		or	(LeaMapsLC["UnlockMap"] ~= LeaMapsDB["UnlockMap"])							-- Unlock map
		or	(LeaMapsLC["ScaleWorldMap"] ~= LeaMapsDB["ScaleWorldMap"])					-- Scale the map
		or	(LeaMapsLC["HideBlackoutFrame"] ~= LeaMapsDB["HideBlackoutFrame"])			-- Hide blackout frame
		or	(LeaMapsLC["AddonLanguage"] ~= LeaMapsDB["AddonLanguage"])					-- Addon language
		or	(LeaMapsLC["RevealMap"] ~= LeaMapsDB["RevealMap"])							-- Show unexplored areas
		or	(LeaMapsLC["ShowPointsOfInterest"] ~= LeaMapsDB["ShowPointsOfInterest"])	-- Show unexplored areas
		or	(LeaMapsLC["ShowZoneLevels"] ~= LeaMapsDB["ShowZoneLevels"])				-- Show zone levels
		or	(LeaMapsLC["ShowCoords"] ~= LeaMapsDB["ShowCoords"])						-- Show coordinates
		or	(LeaMapsLC["HideTownCity"] ~= LeaMapsDB["HideTownCity"])					-- Hide town and city icons
		or	(LeaMapsLC["ShowDungeonMaps"] ~= LeaMapsDB["ShowDungeonMaps"])				-- Show dungeon maps
		or	(LeaMapsLC["EnhanceBattleMap"] ~= LeaMapsDB["EnhanceBattleMap"])			-- Enhance battlefield map
		or	(LeaMapsLC["NoFilterResetBtn"] ~= LeaMapsDB["NoFilterResetBtn"])			-- Hide filte reset button
		then
			-- Enable the reload button
			LeaMapsLC:LockItem(LeaMapsCB["ReloadUIButton"], false)
			LeaMapsCB["ReloadUIButton"].f:Show()
		else
			-- Disable the reload button
			LeaMapsLC:LockItem(LeaMapsCB["ReloadUIButton"], true)
			LeaMapsCB["ReloadUIButton"].f:Hide()
		end
	end

	-- Create a subheading
	function LeaMapsLC:MakeTx(frame, title, x, y)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		text:SetPoint("TOPLEFT", x, y)
		text:SetText(L[title])
		return text
	end

	-- Create text
	function LeaMapsLC:MakeWD(frame, title, x, y, width)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		text:SetPoint("TOPLEFT", x, y)
		text:SetJustifyH("LEFT")
		text:SetText(L[title])
		if width then text:SetWidth(width) end
		return text
	end

	-- Create a checkbox control
	function LeaMapsLC:MakeCB(parent, field, caption, x, y, reload, tip)

		-- Create the checkbox
		local Cbox = CreateFrame('CheckButton', nil, parent, "ChatConfigCheckButtonTemplate")
		LeaMapsCB[field] = Cbox
		Cbox:SetPoint("TOPLEFT",x, y)
		Cbox:SetScript("OnEnter", LeaMapsLC.TipSee)
		Cbox:SetScript("OnLeave", GameTooltip_Hide)

		-- Add label and tooltip
		Cbox.f = Cbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		Cbox.f:SetPoint('LEFT', 24, 0)
		if reload then
			-- Checkbox requires UI reload
			Cbox.f:SetText(L[caption] .. "*")
			Cbox.tiptext = L[tip] .. "|n|n* " .. L["Requires UI reload."]
		else
			-- Checkbox does not require UI reload
			Cbox.f:SetText(L[caption])
			Cbox.tiptext = L[tip]
		end

		-- Set label parameters
		Cbox.f:SetJustifyH("LEFT")
		Cbox.f:SetWordWrap(false)

		-- Set maximum label width
		if parent == LeaMapsLC["PageF"] then
			-- Main panel checkbox labels
			if Cbox.f:GetWidth() > 172 then
				Cbox.f:SetWidth(172)
			end
			-- Set checkbox click width
			if Cbox.f:GetStringWidth() > 172 then
				Cbox:SetHitRectInsets(0, -162, 0, 0)
			else
				Cbox:SetHitRectInsets(0, -Cbox.f:GetStringWidth() + 4, 0, 0)
			end
		else
			-- Configuration panel checkbox labels (other checkboxes either have custom functions or blank labels)
			if Cbox.f:GetWidth() > 322 then
				Cbox.f:SetWidth(322)
			end
			-- Set checkbox click width
			if Cbox.f:GetStringWidth() > 322 then
				Cbox:SetHitRectInsets(0, -312, 0, 0)
			else
				Cbox:SetHitRectInsets(0, -Cbox.f:GetStringWidth() + 4, 0, 0)
			end
		end

		-- Set default checkbox state and click area
		Cbox:SetScript('OnShow', function(self)
			if LeaMapsLC[field] == "On" then
				self:SetChecked(true)
			else
				self:SetChecked(false)
			end
		end)

		-- Process clicks
		Cbox:SetScript('OnClick', function()
			if Cbox:GetChecked() then
				LeaMapsLC[field] = "On"
			else
				LeaMapsLC[field] = "Off"
			end
			LeaMapsLC:SetDim() -- Lock invalid options
			LeaMapsLC:ReloadCheck()
		end)
	end

	-- Create configuration button
	function LeaMapsLC:CfgBtn(name, parent)
		local CfgBtn = CreateFrame("BUTTON", nil, parent)
		LeaMapsCB[name] = CfgBtn
		CfgBtn:SetWidth(20)
		CfgBtn:SetHeight(20)
		CfgBtn:SetPoint("LEFT", parent.f, "RIGHT", 0, 0)

		CfgBtn.t = CfgBtn:CreateTexture(nil, "BORDER")
		CfgBtn.t:SetAllPoints()
		CfgBtn.t:SetTexture("Interface\\WorldMap\\Gear_64.png")
		CfgBtn.t:SetTexCoord(0, 0.50, 0, 0.50)
		CfgBtn.t:SetVertexColor(1.0, 0.82, 0, 1.0)

		CfgBtn:SetHighlightTexture("Interface\\WorldMap\\Gear_64.png")
		CfgBtn:GetHighlightTexture():SetTexCoord(0, 0.50, 0, 0.50)

		CfgBtn.tiptext = L["Click to configure the settings for this option."]
		CfgBtn:SetScript("OnEnter", LeaMapsLC.ShowTooltip)
		CfgBtn:SetScript("OnLeave", GameTooltip_Hide)
	end

	-- Create a help button to the right of a fontstring
	function LeaMapsLC:CreateHelpButton(frame, panel, parent, tip)
		LeaMapsLC:CfgBtn(frame, panel)
		LeaMapsCB[frame]:ClearAllPoints()
		LeaMapsCB[frame]:SetPoint("LEFT", parent, "RIGHT", -parent:GetWidth() + parent:GetStringWidth(), 0)
		LeaMapsCB[frame]:SetSize(25, 25)
		LeaMapsCB[frame].t:SetTexture("Interface\\COMMON\\help-i.blp")
		LeaMapsCB[frame].t:SetTexCoord(0, 1, 0, 1)
		LeaMapsCB[frame].t:SetVertexColor(0.9, 0.8, 0.0)
		LeaMapsCB[frame]:SetHighlightTexture("Interface\\COMMON\\help-i.blp")
		LeaMapsCB[frame]:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
		LeaMapsCB[frame].tiptext = L[tip]
		LeaMapsCB[frame]:SetScript("OnEnter", LeaMapsLC.TipSee)
	end

	-- Show a footer
	function LeaMapsLC:MakeFT(frame, text, left, width, bottom)
		local footer = LeaMapsLC:MakeTx(frame, text, left, bottom)
		footer:SetWidth(width); footer:SetJustifyH("LEFT"); footer:SetWordWrap(true); footer:ClearAllPoints()
		footer:SetPoint("BOTTOMLEFT", left, bottom)
		return footer
	end

	-- Create a slider control
	function LeaMapsLC:MakeSL(frame, field, label, caption, low, high, step, x, y, form)

		-- Create slider control
		local Slider = CreateFrame("Slider", nil, frame, "LeaMapsConfigurationPanelSliderTemplate") -- Old is UISliderTemplate
		LeaMapsCB[field] = Slider
		Slider:SetMinMaxValues(low, high)
		Slider:SetValueStep(step)
		Slider:EnableMouseWheel(true)
		Slider:SetPoint('TOPLEFT', x,y)
		Slider:SetWidth(100)
		Slider:SetHeight(20)
		Slider:SetHitRectInsets(0, 0, 0, 0)
		Slider.tiptext = L[caption]
		Slider:SetScript("OnEnter", LeaMapsLC.TipSee)
		Slider:SetScript("OnLeave", GameTooltip_Hide)

		-- Set label
		Slider.label = Slider:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		Slider.label:SetPoint("TOP", Slider, "TOP", 0, 12)
		Slider.label:SetText(L[label])

		-- Create slider label
		Slider.f = Slider:CreateFontString(nil, 'BACKGROUND')
		Slider.f:SetFontObject('GameFontHighlight')
		Slider.f:SetPoint('LEFT', Slider, 'RIGHT', 12, 0)
		Slider.f:SetFormattedText("%.2f", Slider:GetValue())

		-- Process mousewheel scrolling
		Slider:SetScript("OnMouseWheel", function(self, arg1)
			if Slider:IsEnabled() then
				local step = step * arg1
				local value = self:GetValue()
				if step > 0 then
					self:SetValue(min(value + step, high))
				else
					self:SetValue(max(value + step, low))
				end
			end
		end)

		-- Process value changed
		Slider:SetScript("OnValueChanged", function(self, value)
			local value = floor((value - low) / step + 0.5) * step + low
			Slider.f:SetFormattedText(form, value)
			LeaMapsLC[field] = value
		end)

		-- Set slider value when shown
		Slider:SetScript("OnShow", function(self)
			self:SetValue(LeaMapsLC[field])
		end)

	end

	----------------------------------------------------------------------
	-- L20: Commands
	----------------------------------------------------------------------

	-- Slash command function
	local function SlashFunc(str)
		local str, arg1, arg2, arg3 = strsplit(" ", string.lower(str:gsub("%s+", " ")))
		if str and str ~= "" then
			-- Traverse parameters
			if str == "reset" then
				-- Reset the configuration panel position
				LeaMapsLC["MainPanelA"], LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"] = "CENTER", "CENTER", 0, 0
				if LeaMapsLC["PageF"]:IsShown() then LeaMapsLC["PageF"]:Hide() LeaMapsLC["PageF"]:Show() end
				return
			elseif str == "wipe" then
				-- Wipe all settings
				SetCVar("mapFade", "1")
				wipe(LeaMapsDB)
				LeaMapsLC["NoSaveSettings"] = true
				ReloadUI()
			elseif str == "nosave" then
				-- Prevent Leatrix Maps from overwriting LeaMapsDB at next logout
				LeaMapsLC.EventFrame:UnregisterEvent("PLAYER_LOGOUT")
				LeaMapsLC:Print("Leatrix Maps will not overwrite LeaMapsDB at next logout.")
				return
			elseif str == "debug" then
				-- Toggle debug mode
				if LeaMapsLC["DebugMode"] then
					LeaMapsLC["DebugMode"] = nil
					if GetCVar("showDungeonEntrancesOnMap") ~= "0" then
						SetCVar("showDungeonEntrancesOnMap", "0")
					end
					LeaMapsLC:Print(L["Debug"] .. "|cffffffff " .. L["disabled"] .. "|r.")
				else
					LeaMapsLC["DebugMode"] = true
					LeaMapsLC:Print(L["Debug"] .. "|cffffffff " .. L["enabled"] .. "|r.")
				end
				return
			elseif str == "setmap" then
				-- Set map to map ID
				arg1 = tonumber(arg1)
				if arg1 and arg1 > 0 and arg1 < 99999 and C_Map.GetMapArtLayers(arg1) then
					WorldMapFrame:SetMapID(arg1)
				else
					LeaMapsLC:Print("Invalid map ID.")
				end
				return
			elseif str == "findmap" then
				-- Search the game's maps by name (such as /ltm findmap lordaeron)
				local text = str and strtrim(strlower(table.concat({arg1 or "", arg2 or "", arg3 or ""}, " ")))
				if not text or text == "" then
					LeaMapsLC:Print("Use /ltm findmap <part of a map name>.")
					return
				end
				local typeNames = {}
				if Enum.UIMapType then
					for name, value in pairs(Enum.UIMapType) do typeNames[value] = name end
				end
				local found = 0
				for mapID = 1, 5000 do
					local info = C_Map.GetMapInfo(mapID)
					if info and info.name and strfind(strlower(info.name), text, 1, true) then
						found = found + 1
						local hasArt = C_Map.MapHasArt and C_Map.MapHasArt(mapID)
						LeaMapsLC:Print(mapID .. ": " .. info.name .. " (" .. (typeNames[info.mapType] or tostring(info.mapType)) .. ", " .. (hasArt and "has map" or "no map") .. ")")
					end
				end
				LeaMapsLC:Print(found .. " maps found.")
				return
			elseif str == "dun" then
				-- Preview dungeon maps
				if LeaMapsLC.PreviewDungeon then
					LeaMapsLC.PreviewDungeon(arg1)
				else
					LeaMapsLC:Print("Show dungeon maps is not enabled.")
				end
				return
			elseif str == "duncheck" then
				-- Check game dungeon maps
				if LeaMapsLC.CheckDungeonMaps then
					LeaMapsLC.CheckDungeonMaps()
				else
					LeaMapsLC:Print("Show dungeon maps is not enabled.")
				end
				return
			elseif str == "hadmin" then
				-- Show admin commands
				LeaMapsLC:Print("reset - Reset panel position")
				LeaMapsLC:Print("wipe - Wipe addon settings")
				LeaMapsLC:Print("debug - Lets you enable dungeon icons in world map settings")
				LeaMapsLC:Print("setmap <id> - Show map ID <id>")
				LeaMapsLC:Print("dun [number, name or off] - Preview dungeon maps (map must be open)")
				LeaMapsLC:Print("duncheck - Check which game dungeon maps are in the client")
				LeaMapsLC:Print("findmap <text> - Search the game's maps by name")
				LeaMapsLC:Print("admin - Load admin profile")
				return
			elseif str == "map" then
				-- Set map by ID, print currently showing map ID or print character map ID
				if not arg1 then
					-- Print map ID
					if WorldMapFrame:IsShown() then
						-- Show world map ID
						local mapID = WorldMapFrame.mapID or nil
						local artID = C_Map.GetMapArtID(mapID) or nil
						local mapName = C_Map.GetMapInfo(mapID).name or nil
						if mapID and artID and mapName then
							LeaMapsLC:Print(mapID .. " (" .. artID .. "): " .. mapName .. " (map)")
						end
					else
						-- Show character map ID
						local mapID = C_Map.GetBestMapForUnit("player") or nil
						local artID = C_Map.GetMapArtID(mapID) or nil
						local mapName = C_Map.GetMapInfo(mapID).name or nil
						if mapID and artID and mapName then
							LeaMapsLC:Print(mapID .. " (" .. artID .. "): " .. mapName .. " (player)")
						end
					end
					return
				elseif not tonumber(arg1) or not C_Map.GetMapInfo(arg1) then
					-- Invalid map ID
					LeaMapsLC:Print("Invalid map ID.")
				else
					-- Set map by ID
					WorldMapFrame:SetMapID(tonumber(arg1))
				end
				return
			elseif str == "admin" then
				-- Preset profile (reload required)
				LeaMapsLC["NoSaveSettings"] = true
				wipe(LeaMapsDB)

				-- Mechanics
				LeaMapsDB["SimpleMapFrame"] = "On"
				LeaMapsDB["UnlockMap"] = "On"
				LeaMapsDB["EnableMovement"] = "On"
				LeaMapsDB["ScaleWorldMap"] = "Off"
				LeaMapsDB["HideBlackoutFrame"] = "On"
				LeaMapsDB["ShowZoneMenu"] = "On"
				LeaMapsDB["MapTheme"] = 1
				LeaMapsDB["AddonLanguage"] = 1
				LeaMapsDB["MapScale"] = 1.0
				LeaMapsDB["MaxMapScale"] = 0.9
				LeaMapsDB["NoMapFade"] = "On"
				LeaMapsDB["NoFilterResetBtn"] = "On"

				LeaMapsDB["MapPosA"] = "TOPLEFT"
				LeaMapsDB["MapPosR"] = "TOPLEFT"
				LeaMapsDB["MapPosX"] = 16
				LeaMapsDB["MapPosY"] = -94
				LeaMapsDB["MaxMapPosA"] = "CENTER"
				LeaMapsDB["MaxMapPosR"] = "CENTER"
				LeaMapsDB["MaxMapPosX"] = 0
				LeaMapsDB["MaxMapPosY"] = 0

				-- Elements
				LeaMapsDB["RevealMap"] = "On"
				LeaMapsDB["RevTint"] = "On"
				LeaMapsDB["tintRed"] = 0.6
				LeaMapsDB["tintGreen"] = 0.6
				LeaMapsDB["tintBlue"] = 1.0
				LeaMapsDB["tintAlpha"] = 1.0
				LeaMapsDB["ShowPointsOfInterest"] = "On"
				LeaMapsDB["ShowOpposingPoi"] = "Off"
				LeaMapsDB["ShowDungeonIcons"] = "On"
				LeaMapsDB["ShowFlightPoints"] = "On"
				LeaMapsDB["ShowBoatZeppTram"] = "On"
				LeaMapsDB["ShowPortals"] = "On"
				LeaMapsDB["ShowSpiritHealers"] = "On"
				LeaMapsDB["ShowZoneCrossings"] = "On"
				LeaMapsDB["ShowZoneLevels"] = "On"
				LeaMapsDB["ShowFishingLevels"] = "On"
				LeaMapsDB["ShowCoords"] = "On"
				LeaMapsDB["CoordsBackground"] = "On"
				LeaMapsDB["HideTownCity"] = "On"
				LeaMapsDB["ShowDungeonMaps"] = "On"

				-- More
				LeaMapsDB["EnhanceBattleMap"] = "On"
				LeaMapsDB["UnlockBattlefield"] = "On"
				LeaMapsDB["BattleCenterOnPlayer"] = "On"
				LeaMapsDB["BattleGroupIconSize"] = 8
				LeaMapsDB["BattlePlayerArrowSize"] = 12
				LeaMapsDB["BattleMapOpacity"] = 1
				LeaMapsDB["BattleMapA"] = "BOTTOMRIGHT"
				LeaMapsDB["BattleMapR"] = "BOTTOMRIGHT"
				LeaMapsDB["BattleMapX"] = -47
				LeaMapsDB["BattleMapY"] = 83

				LeaMapsDB["ShowMinimapIcon"] = "On"
				LeaMapsDB["minimapPos"] = 204 -- LeaMapsDB

				ReloadUI()
			elseif str == "help" then
				-- Show available commands
				LeaMapsLC:Print("Leatrix Maps" .. "|n")
				LeaMapsLC:Print(L["FE"] .. " " .. LeaMapsLC["AddonVer"] .. "|n|n")
				LeaMapsLC:Print("/ltm reset - Reset the panel position.")
				LeaMapsLC:Print("/ltm wipe - Wipe all settings and reload.")
				LeaMapsLC:Print("/ltm help - Show this information.")
				return
			else
				-- Invalid command entered
				LeaMapsLC:Print("Invalid command.  Enter /ltm help for help.")
				return
			end
		else
			-- Prevent options panel from showing if Blizzard Store is showing
			if StoreFrame and StoreFrame:GetAttribute("isshown") then return end
			-- Toggle the options panel if game options panel is not showing
			if LeaMapsLC:IsMapsShowing() then
				LeaMapsLC["PageF"]:Hide()
				LeaMapsLC:HideConfigPanels()
			else
				LeaMapsLC["PageF"]:Show()
			end
		end
	end

	-- Add slash commands
	_G.SLASH_Leatrix_Maps1 = "/ltm"
	_G.SLASH_Leatrix_Maps2 = "/leamaps"

	SlashCmdList["Leatrix_Maps"] = function(self)
		-- Run slash command function
		SlashFunc(self)
	end

	----------------------------------------------------------------------
	-- L30: Events
	----------------------------------------------------------------------

	-- Create event frame
	local eFrame = CreateFrame("FRAME")
	LeaMapsLC.EventFrame = eFrame -- Used with nosave command
	eFrame:RegisterEvent("ADDON_LOADED")
	eFrame:RegisterEvent("PLAYER_LOGIN")
	eFrame:RegisterEvent("PLAYER_LOGOUT")
	eFrame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
	eFrame:RegisterEvent("ADDON_ACTION_BLOCKED")
	eFrame:SetScript("OnEvent", function(self, event, arg1, arg2)

		if event == "ADDON_LOADED" and arg1 == "Leatrix_Maps" then
			-- Load settings or set defaults
			LeaMapsLC:LoadVarChk("SimpleMapFrame", "On")				-- Simple map frame
			LeaMapsLC:LoadVarChk("UnlockMap", "Off")					-- Unlock map frame
			LeaMapsLC:LoadVarChk("EnableMovement", "On")				-- Enable frame movement
			LeaMapsLC:LoadVarChk("ScaleWorldMap", "Off")				-- Scale the map
			LeaMapsLC:LoadVarNum("MapScale", 1.0, 0.5, 2)				-- Map scale
			LeaMapsLC:LoadVarNum("MaxMapScale", 1.0, 0.5, 2)			-- Maximised map scale
			LeaMapsLC:LoadVarChk("HideBlackoutFrame", "On")				-- Hide blackout frame
			LeaMapsLC:LoadVarChk("ShowZoneMenu", "On")					-- Show zone menus
			LeaMapsLC:LoadVarNum("MapTheme", 1, 1, 12)					-- Map theme
			LeaMapsLC:LoadVarNum("AddonLanguage", 1, 1, 12)				-- Addon language
			LeaMapsLC:LoadVarChk("NoMapFade", "On")						-- Disable map fade
			LeaMapsLC:LoadVarChk("NoFilterResetBtn", "On")				-- Hide filter reset button

			LeaMapsLC:LoadVarAnc("MapPosA", "TOPLEFT")					-- Windowed map anchor
			LeaMapsLC:LoadVarAnc("MapPosR", "TOPLEFT")					-- Windowed map relative
			LeaMapsLC:LoadVarNum("MapPosX", 16, -5000, 5000)			-- Windowed map X
			LeaMapsLC:LoadVarNum("MapPosY", -94, -5000, 5000)			-- Windowed map Y
			LeaMapsLC:LoadVarAnc("MaxMapPosA", "CENTER")				-- Maximised map anchor
			LeaMapsLC:LoadVarAnc("MaxMapPosR", "CENTER")				-- Maximised map relative
			LeaMapsLC:LoadVarNum("MaxMapPosX", 0, -5000, 5000)			-- Maximised map X
			LeaMapsLC:LoadVarNum("MaxMapPosY", 0, -5000, 5000)			-- Maximised map Y

			-- Elements
			LeaMapsLC:LoadVarChk("RevealMap", "On")						-- Show unexplored areas
			LeaMapsLC:LoadVarChk("RevTint", "On")						-- Tint revealed unexplored areas
			LeaMapsLC:LoadVarNum("tintRed", 0.6, 0, 1)					-- Tint red
			LeaMapsLC:LoadVarNum("tintGreen", 0.6, 0, 1)				-- Tint green
			LeaMapsLC:LoadVarNum("tintBlue", 1, 0, 1)					-- Tint blue
			LeaMapsLC:LoadVarNum("tintAlpha", 1, 0, 1)					-- Tint transparency
			LeaMapsLC:LoadVarChk("ShowPointsOfInterest", "On")			-- Show points of interest
			LeaMapsLC:LoadVarChk("ShowOpposingPoi", "Off")				-- Show opposing faction points of interest
			LeaMapsLC:LoadVarChk("ShowDungeonIcons", "On")				-- Show dungeons and raids
			LeaMapsLC:LoadVarChk("ShowFlightPoints", "On")				-- Show flight points
			LeaMapsLC:LoadVarChk("ShowBoatZeppTram", "On")				-- Show boats, zeppelins and trams
			LeaMapsLC:LoadVarChk("ShowPortals", "On")					-- Show portals
			LeaMapsLC:LoadVarChk("ShowSpiritHealers", "On")				-- Show spirit healers
			LeaMapsLC:LoadVarChk("ShowZoneCrossings", "On")				-- Show zone crossings
			LeaMapsLC:LoadVarChk("ShowZoneLevels", "On")				-- Show zone levels
			LeaMapsLC:LoadVarChk("ShowFishingLevels", "On")				-- Show fishing levels

			LeaMapsLC:LoadVarChk("ShowCoords", "On")					-- Show coordinates
			LeaMapsLC:LoadVarChk("CoordsBackground", "On")				-- Coordinates background
			LeaMapsLC:LoadVarChk("HideTownCity", "On")					-- Hide town and city icons
			LeaMapsLC:LoadVarChk("ShowDungeonMaps", "On")				-- Show dungeon maps

			-- More
			LeaMapsLC:LoadVarChk("EnhanceBattleMap", "Off")				-- Enhance battlefield map
			LeaMapsLC:LoadVarChk("UnlockBattlefield", "On")				-- Unlock battlefield map
			LeaMapsLC:LoadVarChk("BattleCenterOnPlayer", "Off")			-- Center map on player
			LeaMapsLC:LoadVarNum("BattleGroupIconSize", 8, 8, 32)		-- Battlefield group icon size
			LeaMapsLC:LoadVarNum("BattlePlayerArrowSize", 12, 12, 48)	-- Battlefield player arrow size
			LeaMapsLC:LoadVarNum("BattleMapOpacity", 1, 0.1, 1)			-- Battlefield map opacity
			LeaMapsLC:LoadVarAnc("BattleMapA", "BOTTOMRIGHT")			-- Battlefield map anchor
			LeaMapsLC:LoadVarAnc("BattleMapR", "BOTTOMRIGHT")			-- Battlefield map relative
			LeaMapsLC:LoadVarNum("BattleMapX", -47, -5000, 5000)		-- Battlefield map X axis
			LeaMapsLC:LoadVarNum("BattleMapY", 83, -5000, 5000)			-- Battlefield map Y axis

			LeaMapsLC:LoadVarChk("ShowMinimapIcon", "On")				-- Show minimap button

			-- Panel
			LeaMapsLC:LoadVarAnc("MainPanelA", "CENTER")				-- Panel anchor
			LeaMapsLC:LoadVarAnc("MainPanelR", "CENTER")				-- Panel relative
			LeaMapsLC:LoadVarNum("MainPanelX", 0, -5000, 5000)			-- Panel X axis
			LeaMapsLC:LoadVarNum("MainPanelY", 0, -5000, 5000)			-- Panel Y axis

			LeaMapsLC:SetDim()

			-- Set initial minimum button position
			if not LeaMapsDB["minimapPos"] then
				LeaMapsDB["minimapPos"] = 204
			end

			-- Lock conflicting options
			do

				-- Function to disable and lock an option and add a note to the tooltip
				local function Lock(option, reason, optmodule)
					LeaLockList[option] = LeaMapsLC[option]
					LeaMapsLC:LockItem(LeaMapsCB[option], true)
					LeaMapsCB[option].tiptext = LeaMapsCB[option].tiptext .. "|n|n|cff00AAFF" .. L[reason]
					if optmodule then
						LeaMapsCB[option].tiptext = LeaMapsCB[option].tiptext .. " " .. L[optmodule] .. " " .. L["module"]
					end
					LeaMapsCB[option].tiptext = LeaMapsCB[option].tiptext .. "."
					-- Remove hover from configuration button if there is one
					local temp = {LeaMapsCB[option]:GetChildren()}
					if temp and temp[1] and temp[1].t and temp[1].t:GetTexture() == "Interface\\WorldMap\\Gear_64.png" then
						temp[1]:SetHighlightTexture(0)
						temp[1]:SetScript("OnEnter", nil)
					end
				end

				-- Disable items that conflict with ElvUI
				if LeaMapsLC.ElvUI then
					local E, S = LeaMapsLC.ElvUI
					local reason = L["Cannot be used with ElvUI"]
					if E.private.skins.blizzard.enable and E.private.skins.blizzard.worldmap then
						Lock("SimpleMapFrame", reason, "Skins: World Map") -- Use simple map frame
					end
					C_AddOns.EnableAddOn("Leatrix_Maps")
				end
			end

		elseif event == "PLAYER_LOGIN" then
			-- Run main function
			LeaMapsLC:MainFunc()

		elseif event == "PLAYER_LOGOUT" and not LeaMapsLC["NoSaveSettings"] then
			-- Mechanics
			LeaMapsDB["SimpleMapFrame"] = LeaMapsLC["SimpleMapFrame"]
			LeaMapsDB["UnlockMap"] = LeaMapsLC["UnlockMap"]
			LeaMapsDB["EnableMovement"] = LeaMapsLC["EnableMovement"]
			LeaMapsDB["ScaleWorldMap"] = LeaMapsLC["ScaleWorldMap"]
			LeaMapsDB["MapScale"] = LeaMapsLC["MapScale"]
			LeaMapsDB["MaxMapScale"] = LeaMapsLC["MaxMapScale"]
			LeaMapsDB["HideBlackoutFrame"] = LeaMapsLC["HideBlackoutFrame"]
			LeaMapsDB["ShowZoneMenu"] = LeaMapsLC["ShowZoneMenu"]
			LeaMapsDB["AddonLanguage"] = LeaMapsLC["AddonLanguage"]
			LeaMapsDB["MapTheme"] = LeaMapsLC["MapTheme"]
			LeaMapsDB["NoMapFade"] = LeaMapsLC["NoMapFade"]
			LeaMapsDB["NoFilterResetBtn"] = LeaMapsLC["NoFilterResetBtn"]

			LeaMapsDB["MapPosA"] = LeaMapsLC["MapPosA"]
			LeaMapsDB["MapPosR"] = LeaMapsLC["MapPosR"]
			LeaMapsDB["MapPosX"] = LeaMapsLC["MapPosX"]
			LeaMapsDB["MapPosY"] = LeaMapsLC["MapPosY"]
			LeaMapsDB["MaxMapPosA"] = LeaMapsLC["MaxMapPosA"]
			LeaMapsDB["MaxMapPosR"] = LeaMapsLC["MaxMapPosR"]
			LeaMapsDB["MaxMapPosX"] = LeaMapsLC["MaxMapPosX"]
			LeaMapsDB["MaxMapPosY"] = LeaMapsLC["MaxMapPosY"]

			-- Elements
			LeaMapsDB["RevealMap"] = LeaMapsLC["RevealMap"]
			LeaMapsDB["RevTint"] = LeaMapsLC["RevTint"]
			LeaMapsDB["tintRed"] = LeaMapsLC["tintRed"]
			LeaMapsDB["tintGreen"] = LeaMapsLC["tintGreen"]
			LeaMapsDB["tintBlue"] = LeaMapsLC["tintBlue"]
			LeaMapsDB["tintAlpha"] = LeaMapsLC["tintAlpha"]
			LeaMapsDB["ShowPointsOfInterest"] = LeaMapsLC["ShowPointsOfInterest"]
			LeaMapsDB["ShowOpposingPoi"] = LeaMapsLC["ShowOpposingPoi"]
			LeaMapsDB["ShowDungeonIcons"] = LeaMapsLC["ShowDungeonIcons"]
			LeaMapsDB["ShowFlightPoints"] = LeaMapsLC["ShowFlightPoints"]
			LeaMapsDB["ShowBoatZeppTram"] = LeaMapsLC["ShowBoatZeppTram"]
			LeaMapsDB["ShowPortals"] = LeaMapsLC["ShowPortals"]
			LeaMapsDB["ShowSpiritHealers"] = LeaMapsLC["ShowSpiritHealers"]
			LeaMapsDB["ShowZoneCrossings"] = LeaMapsLC["ShowZoneCrossings"]
			LeaMapsDB["ShowZoneLevels"] = LeaMapsLC["ShowZoneLevels"]
			LeaMapsDB["ShowFishingLevels"] = LeaMapsLC["ShowFishingLevels"]

			LeaMapsDB["ShowCoords"] = LeaMapsLC["ShowCoords"]
			LeaMapsDB["CoordsBackground"] = LeaMapsLC["CoordsBackground"]
			LeaMapsDB["HideTownCity"] = LeaMapsLC["HideTownCity"]
			LeaMapsDB["ShowDungeonMaps"] = LeaMapsLC["ShowDungeonMaps"]

			-- More
			LeaMapsDB["EnhanceBattleMap"] = LeaMapsLC["EnhanceBattleMap"]
			LeaMapsDB["UnlockBattlefield"] = LeaMapsLC["UnlockBattlefield"]
			LeaMapsDB["BattleCenterOnPlayer"] = LeaMapsLC["BattleCenterOnPlayer"]
			LeaMapsDB["BattleGroupIconSize"] = LeaMapsLC["BattleGroupIconSize"]
			LeaMapsDB["BattlePlayerArrowSize"] = LeaMapsLC["BattlePlayerArrowSize"]
			LeaMapsDB["BattleMapOpacity"] = LeaMapsLC["BattleMapOpacity"]
			LeaMapsDB["BattleMapA"] = LeaMapsLC["BattleMapA"]
			LeaMapsDB["BattleMapR"] = LeaMapsLC["BattleMapR"]
			LeaMapsDB["BattleMapX"] = LeaMapsLC["BattleMapX"]
			LeaMapsDB["BattleMapY"] = LeaMapsLC["BattleMapY"]

			LeaMapsDB["ShowMinimapIcon"] = LeaMapsLC["ShowMinimapIcon"]

			-- Panel
			LeaMapsDB["MainPanelA"] = LeaMapsLC["MainPanelA"]
			LeaMapsDB["MainPanelR"] = LeaMapsLC["MainPanelR"]
			LeaMapsDB["MainPanelX"] = LeaMapsLC["MainPanelX"]
			LeaMapsDB["MainPanelY"] = LeaMapsLC["MainPanelY"]

		end
	end)

	----------------------------------------------------------------------
	-- L40: Panel
	----------------------------------------------------------------------

	-- Create the panel
	local PageF = CreateFrame("Frame", LeaMapsLC:CreateRandomName(), UIParent)

	-- Make it a system frame
	table.insert(UISpecialFrames, PageF:GetName())

	-- Set frame parameters
	LeaMapsLC["PageF"] = PageF
	PageF:SetSize(470, 420)
	PageF:Hide()
	PageF:SetFrameStrata("FULLSCREEN_DIALOG")
	PageF:SetFrameLevel(20)
	PageF:SetClampedToScreen(true)
	PageF:EnableMouse(true)
	PageF:SetMovable(true)
	PageF:RegisterForDrag("LeftButton")
	PageF:SetScript("OnDragStart", PageF.StartMoving)
	PageF:SetScript("OnDragStop", function()
		PageF:StopMovingOrSizing()
		PageF:SetUserPlaced(false)
		-- Save panel position
		LeaMapsLC["MainPanelA"], void, LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"] = PageF:GetPoint()
	end)

	-- Add background color
	PageF.t = PageF:CreateTexture(nil, "BACKGROUND")
	PageF.t:SetAllPoints()
	PageF.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

	-- Add textures
	local MainTexture = PageF:CreateTexture(nil, "BORDER")
	MainTexture:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
	MainTexture:SetSize(470, 403)
	MainTexture:SetPoint("TOPRIGHT")
	MainTexture:SetVertexColor(0.7, 0.7, 0.7, 0.7)
	MainTexture:SetTexCoord(0.09, 1, 0, 1)

	local FootTexture = PageF:CreateTexture(nil, "BORDER", nil, 1) -- Drawn above the main texture
	FootTexture:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
	FootTexture:SetSize(470, 48)
	FootTexture:SetPoint("BOTTOM")
	FootTexture:SetVertexColor(0.5, 0.5, 0.5, 1.0)

	-- Set panel position when shown
	PageF:SetScript("OnShow", function()
		PageF:ClearAllPoints()
		PageF:SetPoint(LeaMapsLC["MainPanelA"], UIParent, LeaMapsLC["MainPanelR"], LeaMapsLC["MainPanelX"], LeaMapsLC["MainPanelY"])
	end)

	-- Add main title
	PageF.mt = PageF:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	PageF.mt:SetPoint('TOPLEFT', 16, -16)
	PageF.mt:SetText("Leatrix Maps")

	-- Add version text
	PageF.v = PageF:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	PageF.v:SetHeight(32)
	PageF.v:SetPoint('TOPLEFT', PageF.mt, 'BOTTOMLEFT', 0, -8)
	PageF.v:SetPoint('RIGHT', PageF, -32, 0)
	PageF.v:SetJustifyH('LEFT'); PageF.v:SetJustifyV('TOP')
	PageF.v:SetNonSpaceWrap(true); PageF.v:SetText(L["FE"] .. " " .. LeaMapsLC["AddonVer"])

	-- Add reload UI Button
	local reloadb = LeaMapsLC:CreateButton("ReloadUIButton", PageF, "Reload", "BOTTOMRIGHT", -16, 10, 25, "Your UI needs to be reloaded for some of the changes to take effect.|n|nYou don't have to click the reload button immediately but you do need to click it when you are done making changes and you want the changes to take effect.")
	LeaMapsLC:LockItem(reloadb, true)
	reloadb:SetScript("OnClick", ReloadUI)

	reloadb.f = reloadb:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	reloadb.f:SetHeight(32)
	reloadb.f:SetPoint('RIGHT', reloadb, 'LEFT', -10, 0)
	reloadb.f:SetText(L["Your UI needs to be reloaded."])
	reloadb.f:Hide()

	-- Add close Button (LeaMapsLC: Custom template)
	local CloseB = LeaMapsLC:CreateCloseButton(PageF, 30, 30, "TOPRIGHT", 0, 0)
	CloseB:SetScript("OnClick", function() PageF:Hide() end)

	-- Add content
	LeaMapsLC:MakeTx(PageF, "System", 16, -72)
	LeaMapsLC:MakeCB(PageF, "SimpleMapFrame", "Use simple map frame", 16, -92, true, "If checked, the map will use a simple frame with a compact title bar.")
	LeaMapsLC:MakeCB(PageF, "UnlockMap", "Unlock map frame", 16, -112, true, "If checked, you will be able to move the map.|n|nThe map position will be saved separately for the maximised and windowed maps.")
	LeaMapsLC:MakeCB(PageF, "ScaleWorldMap", "Scale the map", 16, -132, true, "If checked, you will be able to scale the map.")
	LeaMapsLC:MakeCB(PageF, "HideBlackoutFrame", "Hide blackout frame", 16, -152, true, "If checked, the blackout frame will be hidden.")

	LeaMapsLC:CreateDropdown("AddonLanguage", "Language", 146, "TOPLEFT", PageF, "TOPLEFT", 16, -212, true, {{L["Automatic"], 1}, {L["English"], 2}, {L["Deutsch"], 3}, {L["Español (EU)"], 4}, {L["Español (AL)"], 5}, {L["Français"], 6}, {L["Italiano"], 7}, {L["Português"], 8}, {L["Русский"], 9}, {L["한국어"], 10}, {L["简体中文"], 11}, {L["繁體中文"], 12}})

	LeaMapsLC:MakeTx(PageF, "Elements", 225, -72)
	LeaMapsLC:MakeCB(PageF, "RevealMap", "Show unexplored areas", 225, -92, true, "If checked, unexplored areas of the map will be shown on the world map and the battlefield map.")
	LeaMapsLC:MakeCB(PageF, "ShowPointsOfInterest", "Show points of interest", 225, -112, true, "If checked, points of interest will be shown.")
	LeaMapsLC:MakeCB(PageF, "ShowZoneLevels", "Show zone levels", 225, -132, true, "If checked, zone levels will be shown on the continent maps.")
	LeaMapsLC:MakeCB(PageF, "ShowCoords", "Show coordinates", 225, -152, true, "If checked, coordinates will be shown.")
	LeaMapsLC:MakeCB(PageF, "HideTownCity", "Hide town and city icons", 225, -172, true, "If checked, town and city icons will not be shown on the continent maps.")
	LeaMapsLC:MakeCB(PageF, "ShowDungeonMaps", "Show dungeon maps", 225, -192, true, "If checked, the map will show a map of the dungeon or raid you are in, with bosses, entrances and level changes.|n|nUse the mouse wheel to zoom and drag to pan.|n|nRight-click the dungeon map to show the normal map until you next open the map.")

	LeaMapsLC:MakeTx(PageF, "More", 225, -232)
	LeaMapsLC:MakeCB(PageF, "EnhanceBattleMap", "Enhance battlefield map", 225, -252, true, "If checked, you will be able to customise the battlefield map.")
	LeaMapsLC:MakeCB(PageF, "NoMapFade", "Disable map fade", 225, -272, false, "If checked, the map will not fade while your character is moving.")
	LeaMapsLC:MakeCB(PageF, "NoFilterResetBtn", "Hide filter reset button", 225, -292, true, "If checked, the world map filter reset button will be hidden.")
	LeaMapsLC:MakeCB(PageF, "ShowMinimapIcon", "Show minimap button", 225, -312, false, "If checked, the minimap button will be shown.")

	LeaMapsLC:CfgBtn("SimpleMapFrameBtn", LeaMapsCB["SimpleMapFrame"])
	LeaMapsLC:CfgBtn("ScaleWorldMapBtn", LeaMapsCB["ScaleWorldMap"])
	LeaMapsLC:CfgBtn("RevTintBtn", LeaMapsCB["RevealMap"])
	LeaMapsLC:CfgBtn("UnlockMapBtn", LeaMapsCB["UnlockMap"])
	LeaMapsLC:CfgBtn("ShowCoordsBtn", LeaMapsCB["ShowCoords"])
	LeaMapsLC:CfgBtn("EnhanceBattleMapBtn", LeaMapsCB["EnhanceBattleMap"])
	LeaMapsLC:CfgBtn("ShowPointsOfInterestBtn", LeaMapsCB["ShowPointsOfInterest"])
	LeaMapsLC:CfgBtn("ShowZoneLevelsBtn", LeaMapsCB["ShowZoneLevels"])
