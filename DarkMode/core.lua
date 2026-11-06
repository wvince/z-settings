local _, DarkMode = ...
local bShow = false
local MSQ = nil
DMHIDDEN = CreateFrame("FRAME", "DMHIDDEN")
DMHIDDEN:Hide()
local debugDisabled = true
local debug = 0
function DarkMode:Debug(num, msg, ...)
	if debugDisabled then return end
	if debug > 0 and debug == num or debug == 11 then DarkMode:DEB("[" .. debug .. "]", msg, ...) end
end

function DarkMode:IsForbidden(obj)
	if obj == nil then return false end
	if type(obj) ~= "table" and type(obj) ~= "userdata" then return false end
	local ok, forbidden = pcall(function() return obj.IsForbidden and obj:IsForbidden() end)
	if not ok then return true end
	return forbidden == true
end

function DarkMode:SetVertexColor(texture, r, g, b, a, from)
	if not texture then
		DarkMode:MSG("Texture invalid", texture, from)
		return false
	end

	if DarkMode:IsForbidden(texture) then return false end
	if r and g and b then
		local bbfHooked = texture.bbfHooked
		local bbfChanging = texture.changing
		if bbfHooked then texture.changing = true end
		if a then
			texture:SetVertexColor(r, g, b, a)
		else
			texture:SetVertexColor(r, g, b)
		end

		if bbfHooked then texture.changing = bbfChanging end
		return true
	end
	return false
end

function DarkMode:IsValidTexture(obj)
	if obj == nil then return false end
	if DarkMode:IsForbidden(obj) then return false end
	if obj.GetTexture and obj:GetTexture() ~= nil then return true end
	if obj.GetTextureFilePath and obj:GetTextureFilePath() ~= nil then return true end
	if type(obj) == "userdata" then return true end
	return false
end

local DMTextures = {}
for _, colorType in ipairs(DarkMode:GetColorTypes()) do
	DMTextures[colorType["name"]] = {}
end

local MMBTNSETUP = {}
local function DMUpdateActionBarDividerPool(pool, typ)
	if not pool or not pool.EnumerateActive then return end
	for divider in pool:EnumerateActive() do
		DarkMode:FindTextures(divider, typ or "actionbuttons")
	end
end

local function DMUpdateMainActionBarDividers(bar, typ)
	if not bar then return end
	DMUpdateActionBarDividerPool(bar.HorizontalDividersPool, typ)
	DMUpdateActionBarDividerPool(bar.VerticalDividersPool, typ)
end

function DarkMode:LockColorType(texture, typ)
	if not DarkMode:IsValidTexture(texture) or texture.dmLockType == typ then return end
	texture.dmLockType = typ
	for _, list in pairs(DMTextures) do
		list[texture] = nil
	end

	if not DarkMode:UpdateColor(texture, typ) and not texture.dm_lock_alpha_hook and texture.SetAlpha then
		texture.dm_lock_alpha_hook = true
		hooksecurefunc(texture, "SetAlpha", function(sel, alpha)
			if alpha and alpha > 0 and not DMTextures[sel.dmLockType][sel] then DarkMode:UpdateColor(sel, sel.dmLockType) end
		end)
	end
end

function DarkMode:UpdateColor(texture, typ, from, skipIgnore)
	if not DarkMode:IsValidTexture(texture) then return false end
	if texture.dmLockType then typ = texture.dmLockType end
	if texture == nil then
		DarkMode:MSG("[UpdateColor] INVALID TEXTURE OBJECT")
		return false
	end

	if debug == 10 then
		local name = DarkMode:GetName(texture)
		if name then
			DarkMode:Debug(10, "UpdateColor", "name:", name, "typ:", typ)
		else
			DarkMode:Debug(10, "UpdateColor", "texture:", texture, "typ:", typ)
		end
	end

	local textureId = nil
	if texture.GetTexture ~= nil then
		local ok, id = pcall(texture.GetTexture, texture)
		if ok and not DarkMode:IsSecret(id) then textureId = id end
	end

	local blockTable = DarkMode:GetTextureBlockTable()
	if textureId and type(blockTable) == "table" and blockTable[textureId] and skipIgnore == nil then return false end
	if texture:GetAlpha() == 0 then return false end
	if textureId == nil and texture.SetColorTexture then
		if DarkMode:IsColorType(typ) then
			local r, g, b, a = DarkMode:GetTypeColor(typ, texture)
			if r ~= nil and g ~= nil and b ~= nil then
				if texture:GetAlpha() < 1 then a = texture:GetAlpha() end
				texture:SetColorTexture(r, g, b, a)
			end
		else
			DarkMode:INFO("[UpdateColor] #1 Missing type", typ)
		end
		return true
	elseif textureId ~= nil and texture.SetVertexColor then
		if texture.SetText then return false end
		if texture.dm_setup_texture == nil then
			texture.dm_setup_texture = true
			hooksecurefunc(texture, "SetVertexColor", function(sel, olr, olg, olb, ola)
				if DarkMode:IsForbidden(sel) then return end
				if sel.dm_setvertexcolor then return end
				sel.dm_setvertexcolor = true
				local hookTyp = sel.dmLockType or typ
				if DarkMode:IsColorType(hookTyp) then
					local r, g, b, a = DarkMode:GetTypeColor(hookTyp, sel)
					if ola and ola < 1 then a = ola end
					DarkMode:SetVertexColor(sel, r, g, b, a, hookTyp)
				else
					DarkMode:INFO("[UpdateColor] #2 Missing type", typ)
				end

				sel.dm_setvertexcolor = false
			end)
		end

		local ola = 1
		if texture:GetAlpha() < 1 then ola = texture:GetAlpha() end
		local r, g, b, a = DarkMode:GetTypeColor(DarkMode:IsColorType(typ) and typ or "frames", texture)
		if ola and ola < 1 then a = ola end
		DarkMode:SetVertexColor(texture, r, g, b, a, typ)
		if DarkMode:IsColorType(typ) then
			DMTextures[typ][texture] = true
		else
			DarkMode:MSG("[UpdateColor] Missing Type:", typ)
		end
		return true
	end
	return false
end

function DarkMode:AddActionButtonBorder(parent, btn, name, sizew, sizeh, px, py, typ, texture, actionbuttons)
	if name ~= "StanceButton" and name ~= "PetActionButton" and DarkMode:IsAddOnLoaded("DragonflightUi") then return end
	local icon = _G[name .. "Icon"]
	if icon then
		local br = 0.075
		if string.find(name, "PetActionButton", 1, true) then
			br = 0.052
		elseif string.find(name, "StanceButton", 1, true) then
			br = 0.075
		end

		icon:SetTexCoord(br, 1 - br, br, 1 - br)
	end

	if parent.dmborder ~= nil then return end
	px = px or 0
	py = py or 0
	if DarkMode:IsEnabled("SHADOWACTIONBARS", false) then
		texture = texture or "Interface\\AddOns\\DarkMode\\media\\defaultEER3"
	else
		texture = texture or "Interface\\AddOns\\DarkMode\\media\\default"
	end

	parent.dmborder = parent:CreateTexture(name .. ".DMBorder", "OVERLAY")
	local border = parent.dmborder
	border:SetDrawLayer("OVERLAY", 3)
	border:SetSize(sizew, sizeh)
	if string.find(name, "PetActionButton", 1, true) and DarkMode:IsEnabled("THINBORDERS", false) then border:SetScale(0.88) end
	if actionbuttons then
		if DarkMode:IsEnabled("THINBORDERS", false) then
			border:SetTexture("Interface\\AddOns\\DarkMode\\media\\border_thin")
		else
			border:SetTexture(texture)
		end
	else
		border:SetTexture(texture)
	end

	border:SetPoint("CENTER", btn, "CENTER", px, py)
	DarkMode:UpdateColor(border, typ)
	return border
end

local addonsDelay = 0
local addonsRetry = false
local retryScheduled = false
local foundMinimapTracking = false
local talentFrameFound = false
function DarkMode:UpdateSpellBook()
	DarkMode:FindTexts(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.View1, "sb")
	DarkMode:FindTexts(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.View2, "sb")
	DarkMode:FindTexts(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls, "sb")
end

function DarkMode:ColorCharacterBorders(frame, depth)
	depth = depth or 0
	if frame == nil or depth > 10 or DarkMode:IsForbidden(frame) then return end
	DarkMode:ForeachRegions(frame, function(region)
		if DarkMode:IsForbidden(region) or not region.GetAtlas then return end
		local atlas = region:GetAtlas()
		if type(atlas) == "string" and not DarkMode:IsSecret(atlas) and DarkMode.CharacterBorderAtlases[atlas] then DarkMode:UpdateColor(region, "frames") end
	end, "CharacterBorders")
	DarkMode:ForeachChildren(frame, function(child) DarkMode:ColorCharacterBorders(child, depth + 1) end, "CharacterBorders")
end

function DarkMode:CheckLateFrames()
	if ProfessionsFrame and DarkMode:IsForever() and not ProfessionsFrame.dmTabBordersHooked then
		ProfessionsFrame.dmTabBordersHooked = true
		for index = 0, 7 do
			local tab = index == 0 and ProfessionsFrame.ProfessionsOverviewTab or ProfessionsFrame["Professions" .. index .. "Tab"]
			if tab then
				for _, key in ipairs({"Background", "SelectedTexture", "HighlightTexture", "TabGlow"}) do
					DarkMode:LockColorType(tab[key], "frames")
				end
			end
		end
	end
	if CharacterFrame and DarkMode:IsForever() and not CharacterFrame.dmBordersHooked then
		CharacterFrame.dmBordersHooked = true
		CharacterFrame:HookScript("OnShow", function(frame) DarkMode:ColorCharacterBorders(frame) end)
		DarkMode:ColorCharacterBorders(CharacterFrame)
	end
	local MiniMapTrackingBorder = getglobal("MiniMapTrackingBorder")
	if not foundMinimapTracking and MiniMapTrackingBorder then
		foundMinimapTracking = true
		DarkMode:UpdateColor(MiniMapTrackingBorder, "addons")
	end

	if not talentFrameFound and PlayerSpellsFrame then
		talentFrameFound = true
		if PlayerSpellsFrame.TabSystem then DarkMode:ForeachChildren(PlayerSpellsFrame.TabSystem, function(child, x) DarkMode:FindTextures(child, "frames") end) end
		if PlayerSpellsFrame.SpellBookFrame then
			if PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem and not DarkMode:IsForever() then DarkMode:ForeachChildren(PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem, function(child, x) DarkMode:FindTextures(child, "frames") end) end
			if PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame and PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.View1 and PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls then
				hooksecurefunc(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame, "ApplyLayout", function() DarkMode:After(0.15, function() DarkMode:UpdateSpellBook() end, "ApplyLoadout") end)
				DarkMode:UpdateSpellBook()
			end
		end
	end
end

function DarkMode:ScheduleRetryAddonsSearch()
	if retryScheduled then return end
	retryScheduled = true
	DarkMode:After(0.12, function()
		DarkMode:Debug(7, "RetryAddonsSearch")
		DarkMode:RetryAddonsSearch()
	end, "RetryAddonsSearch addonsRetry")
end

function DarkMode:RetryAddonsSearch()
	retryScheduled = false
	DarkMode:CheckLateFrames()
	if addonsRetry then
		if GetTime() > addonsDelay then
			DarkMode:AddonsSearch("RETRY")
		else
			DarkMode:ScheduleRetryAddonsSearch()
		end
	end
end

local foundTrinket = false
function DarkMode:TriggerTrinketMenu()
	local TrinketMenu_MenuFrame = getglobal("TrinketMenu_MenuFrame")
	if TrinketMenu_MenuFrame then
		DarkMode:ForeachChildren(TrinketMenu_MenuFrame, function(child, c)
			DarkMode:ForeachRegions(child, function(region, r)
				local name = DarkMode:GetName(region)
				if name and string.find(name, "NormalTexture", 1, true) then DarkMode:UpdateColor(region, "addons") end
			end)
		end)
	end
end

function DarkMode:AddonsSearch(from)
	if GetTime() < addonsDelay then
		addonsRetry = true
		addonsDelay = GetTime() + 0.11
		DarkMode:ScheduleRetryAddonsSearch()
		return
	end

	if not debugDisabled then DarkMode:DEB("AddonsSearch", from) end
	addonsDelay = GetTime() + 0.11
	addonsRetry = false
	DarkMode:CheckLateFrames()
	local TrinketMenu_MenuFrame = getglobal("TrinketMenu_MenuFrame")
	if foundTrinket == false and TrinketMenu_MenuFrame then
		foundTrinket = true
		TrinketMenu_MenuFrame:HookScript("OnShow", function() DarkMode:TriggerTrinketMenu() end)
		TrinketMenu_MenuFrame:HookScript("OnEnter", function() DarkMode:TriggerTrinketMenu() end)
	end

	DarkMode:After(0.13, function()
		DarkMode:Debug(5, "AddonsSearch")
		DarkMode:SearchAddons(from)
		local PlayerTalentFrame = getglobal("PlayerTalentFrame")
		if PlayerTalentFrame then
			for i, v in pairs({"PlayerSpecTab1", "PlayerSpecTab2", "PlayerSpecTab3", "PlayerSpecTab4"}) do
				local tab = _G[v]
				if tab then DarkMode:ForeachRegions(tab, function(region, x) if x == 1 then DarkMode:UpdateColor(region, "frames") end end, "AddonsSearch") end
			end
		end

		local ClassTalentFrame = getglobal("ClassTalentFrame")
		if ClassTalentFrame and ClassTalentFrame.dm_setup_talent == nil then
			ClassTalentFrame.dm_setup_talent = true
			function ClassTalentFrame:UpdateColors()
				if ClassTalentFrame.TabSystem then DarkMode:ForeachChildren(ClassTalentFrame.TabSystem, function(child) DarkMode:ForeachRegions(child, function(region) DarkMode:UpdateColor(region, "frames") end, "ClassTalentFrame.TabSystem regions") end, "ClassTalentFrame.TabSystem childs") end
			end

			ClassTalentFrame:HookScript("OnShow", function(sel) ClassTalentFrame:UpdateColors() end)
			ClassTalentFrame:UpdateColors()
		end
	end, "AddonsSearch1")
end

local function RGBToHexC(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return "|cFF" .. string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

local function RemoveColorCodes(text)
	return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
end

local DMFS = {}
function DarkMode:UpdateText(text, name, layer)
	if text and text.SetTextColor then
		if text.dm_setup_text == nil then
			text.dm_setup_text = true
			hooksecurefunc(text, "SetTextColor", function(sel, olr, olg, olb, ola)
				if sel.dm_settextcolor then return end
				sel.dm_settextcolor = true
				local r, g, b, a = DarkMode:GetTypeColor("frames")
				if r ~= nil and g ~= nil and b ~= nil then
					if a == nil then a = 1 end
					local cr, cg, cb, ca = DarkMode:GetTextColor(r, g, b, a)
					if cr ~= nil and cg ~= nil and cb ~= nil then
						sel:SetTextColor(cr, cg, cb, ca)
						if sel:GetText() then sel:SetText(RGBToHexC(cr, cg, cb) .. RemoveColorCodes(sel:GetText())) end
					end
				end

				sel.dm_settextcolor = false
			end)
		end

		local r, g, b, a = DarkMode:GetTypeColor("frames")
		if r ~= nil and g ~= nil and b ~= nil then
			if a == nil then a = 1 end
			text:SetTextColor(DarkMode:GetTextColor(r, g, b, a))
		end

		DMFS[text] = true
		return true
	end
	return false
end

function DarkMode:FindTexts(frame, name, iter)
	iter = iter or 0
	if frame ~= nil then
		if frame.SetTextColor then
			DarkMode:UpdateText(frame, name, 1)
		else
			if frame.GetRegions then
				DarkMode:ForeachRegions(frame, function(region, x)
					if region.SetTextColor then DarkMode:UpdateText(region, name, 2) end
					if type(region) == "table" then DarkMode:FindTexts(region, name) end
				end, "FindTexts")
			end

			if frame.GetChildren then
				DarkMode:ForeachChildren(frame, function(child)
					if child.SetTextColor then DarkMode:UpdateText(child, name, 3) end
					if type(child) == "table" then DarkMode:FindTexts(child, name, iter + 1) end
				end, "FindTexts")
			end
		end
	end
end

function DarkMode:FindTextsByName(name)
	local frame = DarkMode:GetFrameByName(name)
	if frame and DarkMode:DMGV("COLORMODEF", 1) ~= DarkMode:GetColorModeID("Off") then DarkMode:FindTexts(frame, name) end
end

local function DMRefreshColors(textures, typ)
	for v in pairs(textures) do
		local r, g, b, a = DarkMode:GetTypeColor(typ, v)
		if v:GetAlpha() and v:GetAlpha() < 1 then a = v:GetAlpha() end
		DarkMode:SetVertexColor(v, r, g, b, a)
	end
end

function DarkMode:UpdateColors()
	DarkMode:InvalidateColorCache()
	for _, colorType in ipairs(DarkMode:GetColorTypes()) do
		DMRefreshColors(DMTextures[colorType["name"]], colorType["name"])
	end

	DMRefreshColors(DMFS, "frames")
end

function DarkMode:FindTextures(frame, typ, findName, show)
	if frame == nil then return end
	local ignoreId1 = nil
	local ignoreId2 = nil
	local ignoreId3 = nil
	local name = DarkMode:GetName(frame)
	if frame and frame ~= StoreFrame and name then
		if string.find(name, "SkillLineTab") then
			ignoreId1 = 2
			ignoreId2 = 3
			ignoreId3 = 4
		elseif string.find(name, "XX") then
			ignoreId1 = 2
		end
	end

	if frame and frame ~= StoreFrame and name and DarkMode:GetIgnoreFrames(name) then return end
	local ignoreKey = name and DarkMode:GetIgnoreTextureKey(name)
	local ignoreRegion = ignoreKey and frame[ignoreKey]
	if frame.SetVertexColor then
		if findName == nil then
			DarkMode:UpdateColor(frame, typ)
		else
			if findName == DarkMode:GetName(frame) then return frame end
		end

		if show then DarkMode:INFO("#1", "[" .. DarkMode:GetName(frame, true) .. "]") end
	end

	if frame.GetRegions then
		local ret = DarkMode:ForeachRegions(frame, function(region, x)
			local regionName = DarkMode:GetName(region)
			if (ignoreId1 == nil or ignoreId1 ~= x) and (ignoreId2 == nil or ignoreId2 ~= x) and (ignoreId3 == nil or ignoreId3 ~= x) and ((regionName or not DarkMode:GetIgnoreFrames(regionName)) or (not regionName and region.SetVertexColor)) then
				if bShow and region.GetTexture then DarkMode:MSG(">>", regionName, region:GetTextureFilePath(), region:GetTexture(), "Size:", region:GetSize()) end
				if region ~= ignoreRegion and not DarkMode:GetIgnoreTextureName(regionName) then
					if findName == nil then
						DarkMode:UpdateColor(region, typ)
					else
						if findName == regionName then return region end
					end

					if show then DarkMode:INFO("#2", "[" .. DarkMode:GetName(region, true) .. "]") end
				end
			end
		end, "FindTextures")

		if ret then return ret end
	end

	if frame.GetChildren then
		local ret = DarkMode:ForeachChildren(frame, function(child, i)
			local childName = DarkMode:GetName(child)
			if (ignoreId1 == nil or ignoreId1 ~= i) and (ignoreId2 == nil or ignoreId2 ~= i) and (ignoreId3 == nil or ignoreId3 ~= i) and ((C_Widget.IsWidget(child) and not DarkMode:GetIgnoreFrames(childName)) or (not C_Widget.IsWidget(child) and child.SetVertexColor)) then
				if bShow and child.GetTexture then DarkMode:MSG(">>>", name, childName, child:GetTextureFilePath(), child:GetTexture(), "Size:", child:GetSize()) end
				if not childName or (childName and not DarkMode:GetIgnoreTextureName(childName)) then
					if findName == nil then
						DarkMode:UpdateColor(child, typ)
					else
						if findName == DarkMode:GetName(child) then return child end
					end

					if show then DarkMode:INFO("#3", "[" .. DarkMode:GetName(child, true) .. "]") end
				end
			end
		end, "FindTextures")

		if ret then return ret end
	end
end

function DarkMode:FindTexturesByName(name, typ)
	DarkMode:Debug(10, "FindTexturesByName", name)
	local frame = DarkMode:GetFrameByName(name)
	if frame then DarkMode:FindTextures(frame, typ) end
end

function DarkMode:FindRepeatingTextures(baseName, baseFrame, typ, isLootFrame)
	if baseFrame == nil then baseFrame = DarkMode:GetFrameByName(baseName) end
	if baseFrame == nil then return end
	local paths = DarkMode:GetDMRepeatingPaths()
	for i = 1, #paths do
		local entry = paths[i]
		if not (isLootFrame and entry["skipOnLoot"]) then
			local frame = nil
			local path = entry["path"]
			if path then
				frame = baseFrame
				for p = 1, #path do
					if type(frame) ~= "table" then
						frame = nil
						break
					end

					frame = frame[path[p]]
				end

				if type(frame) ~= "table" then frame = nil end
			elseif entry["suffix"] == "" then
				frame = baseFrame
			else
				frame = DarkMode:GetFrameByName(baseName .. entry["suffix"])
			end

			if frame then DarkMode:FindTextures(frame, typ) end
		end
	end
end

local questDelay = 0.2
function DarkMode:InitGreetingPanel()
	local frame = DarkMode:GetFrameByName("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget")
	local frameTab = {"GossipFrame", "GossipFrame.GreetingPanel", "GossipFrame.GreetingPanel.ScrollBox", "GossipFrame.GreetingPanel.ScrollBar.Background",}
	function DarkMode:UpdateGossipFrame()
		if frame == GossipFrame then
			DarkMode:FindTextsByName("GossipFrame")
		else
			DarkMode:FindTextsByName("GossipFrame.GreetingPanel.ScrollBox.ScrollTarget")
		end

		for index, name in pairs(frameTab) do
			DarkMode:FindRepeatingTextures(name, nil, "frames")
		end
	end

	if frame == nil then frame = DarkMode:GetFrameByName("GossipFrame") end
	if frame then
		if GossipFrame.GreetingPanel then hooksecurefunc(GossipFrame.GreetingPanel.ScrollBox, "FullUpdate", function() DarkMode:UpdateGossipFrame() end) end
		frame:HookScript("OnShow", function(sel, ...)
			DarkMode:After(questDelay, function()
				DarkMode:Debug(5, "InitGreetingPanel 1")
				DarkMode:UpdateGossipFrame()
			end, "InitGreetingPanel1")
		end)

		if GossipFrame.OnEvent then
			hooksecurefunc(GossipFrame, "OnEvent", function()
				DarkMode:After(questDelay, function()
					DarkMode:Debug(5, "InitGreetingPanel 2")
					DarkMode:UpdateGossipFrame()
				end, "InitGreetingPanel2")
			end)
		end
	end
end

function DarkMode:SearchForTexts(from)
	if from == nil then
		DarkMode:INFO("[SearchForTexts] Missing From")
		return
	end

	local c = 0
	for index, name in pairs(DarkMode:GetFrameTextTable()) do
		if DarkMode:GetFrameByName(name) then
			c = c + 1
			if c >= 20 then
				DarkMode:After(0.21, function() DarkMode:SearchForTexts("RETRY" .. from) end, "Retry Texts")
				return
			end

			DarkMode:FindTextsByName(name)
			DarkMode:GetFrameTextTable()[name] = nil
		end
	end
end

function DarkMode:InitQuestLogFrame()
	local frame = DarkMode:GetFrameByName("QuestLogFrame")
	function DarkMode:UpdateQuestLogFrame()
		DarkMode:SearchForTexts("UpdateQuestLogFrame")
	end

	if frame then
		frame:HookScript("OnShow", function(sel)
			DarkMode:After(questDelay, function()
				DarkMode:Debug(5, "InitQuestLogFrame 1")
				DarkMode:UpdateQuestLogFrame()
			end, "InitQuestLogFrame1")
		end)

		if frame.OnEvent then
			hooksecurefunc(frame, "OnEvent", function()
				DarkMode:After(questDelay, function()
					DarkMode:Debug(5, "InitQuestLogFrame 2")
					DarkMode:UpdateQuestLogFrame()
				end, "InitQuestLogFrame2")
			end)
		end
	end

	local QuestLogFrame = getglobal("QuestLogFrame")
	if WorldMapFrame or QuestLogFrame then
		local findNames = false
		local questMapScanning = false
		function DarkMode:UpdateQuestMapFrame()
			questMapScanning = false
			if not findNames then return end
			local tab = DarkMode:GetMapFrameTextTable()
			if next(tab) == nil then return end
			for index, name in pairs(tab) do
				if _G[name] then
					DarkMode:FindTextsByName(name)
					tab[name] = nil
				end
			end

			if next(tab) == nil then return end
			questMapScanning = true
			DarkMode:After(0.1, function() DarkMode:UpdateQuestMapFrame() end, "UpdateQuestMapFrame 1")
		end

		local function StartQuestMapScan()
			findNames = true
			if questMapScanning then return end
			if next(DarkMode:GetMapFrameTextTable()) == nil then return end
			questMapScanning = true
			DarkMode:After(0.1, function() DarkMode:UpdateQuestMapFrame() end, "UpdateQuestMapFrame 1")
		end

		if QuestFrame then
			QuestFrame:HookScript("OnShow", function(sel) StartQuestMapScan() end)
			QuestFrame:HookScript("OnHide", function(sel) findNames = false end)
		end

		if QuestLogFrame then
			QuestLogFrame:HookScript("OnShow", function(sel) StartQuestMapScan() end)
			QuestLogFrame:HookScript("OnHide", function(sel) findNames = false end)
		end

		if WorldMapFrame then
			WorldMapFrame:HookScript("OnShow", function(sel) StartQuestMapScan() end)
			WorldMapFrame:HookScript("OnHide", function(sel) findNames = false end)
		end
	end
end

local DMFramesSpecial = {}
for _, slotName in ipairs({"CharacterMainHandSlot", "CharacterRangedSlot"}) do
	local slot = getglobal(slotName)
	if slot then
		DarkMode:ForeachRegions(slot, function(region, x)
			if x == 14 then
				tinsert(DMFramesSpecial, region) -- CATA
			end
		end, slotName)
	end
end

function DarkMode:GetFrameTableSpecial()
	return DMFramesSpecial
end

function DarkMode:SearchFrames()
	local c = 0
	for index, frame in pairs(DarkMode:GetFrameTableSpecial()) do
		if frame ~= nil then
			c = c + 1
			if c >= 30 then
				DarkMode:After(0.21, function() DarkMode:SearchFrames() end, "Reached Limit Special")
				return
			end

			DarkMode:UpdateColor(frame, "frames")
			frame = nil
		end
	end

	for index, name in pairs(DarkMode:GetFrameTable()) do
		local baseFrame = DarkMode:GetFrameByName(name)
		if baseFrame then
			c = c + 1
			if c >= 30 then
				DarkMode:After(0.22, function() DarkMode:SearchFrames() end, "Reached Limit")
				return
			end

			DarkMode:FindRepeatingTextures(name, baseFrame, "frames", name == "LootFrame")
			DarkMode:GetFrameTable()[name] = nil
		end
	end
end

local foundLTPBorder = 0
function DarkMode:InitLeatrixDruidBar()
	if foundLTPBorder >= 3 then return end
	local children = {PlayerFrame:GetChildren()}
	for _, child in pairs(children) do
		if child.DefaultBorder then
			DarkMode:UpdateColor(child.DefaultBorder, "uf")
			foundLTPBorder = foundLTPBorder + 1
		end

		if child.DefaultBorderRight then
			DarkMode:UpdateColor(child.DefaultBorderRight, "uf")
			foundLTPBorder = foundLTPBorder + 1
		end

		if child.DefaultBorderLeft then
			DarkMode:UpdateColor(child.DefaultBorderLeft, "uf")
			foundLTPBorder = foundLTPBorder + 1
		end
	end
end

local foundOutfitterFrame = false
local setupOutfitterFrame = false
function DarkMode:InitOutfitterFrame()
	if foundOutfitterFrame then return end
	if OutfitterFrame then
		hooksecurefunc(OutfitterFrame, "Show", function()
			if setupOutfitterFrame then return end
			setupOutfitterFrame = true
			local children = {OutfitterFrame:GetRegions()}
			for i, child in pairs(children) do
				if i ~= 1 then DarkMode:UpdateColor(child, "addons") end
			end
		end)

		foundOutfitterFrame = true
	end
end

local foundAuctionator = false
local foundExpansion = false
local lastAddonsSearch = 0
local searchAddonsDelay = 0.1
local RANKERBUTTONS = {"RankerToggleButton", "RankerWhatIfButton"}
function DarkMode:SearchAddons(from)
	if from == nil then
		DarkMode:INFO("[SearchAddons] NO FROM")
		return
	end

	if lastAddonsSearch > GetTime() then
		DarkMode:After(searchAddonsDelay + 0.02, function() DarkMode:SearchAddons("TOFAST" .. from) end, "Retry Addons")
		return
	end

	lastAddonsSearch = GetTime() + searchAddonsDelay
	local c = 0
	local AuctionatorAHTabsContainer = getglobal("AuctionatorAHTabsContainer")
	local AuctionatorShoppingFrame = getglobal("AuctionatorShoppingFrame")
	local AuctionatorBuyFrame = getglobal("AuctionatorBuyFrame")
	local AuctionatorSellingFrame = getglobal("AuctionatorSellingFrame")
	local AuctionatorCancellingFrame = getglobal("AuctionatorCancellingFrame")
	if AuctionatorAHTabsContainer ~= nil and AuctionatorAHTabsContainer.Tabs ~= nil and foundAuctionator == false then
		foundAuctionator = true
		for x, v in pairs(AuctionatorAHTabsContainer.Tabs) do
			DarkMode:FindTextures(v, "addons")
		end
	end

	if AuctionatorShoppingFrame then
		if AuctionatorShoppingFrame.ListsContainer and AuctionatorShoppingFrame.ListsContainer.ScrollBar and AuctionatorShoppingFrame.ListsContainer.ScrollBar.Background then DarkMode:FindTextures(AuctionatorShoppingFrame.ListsContainer.ScrollBar.Background, "addons") end
		if AuctionatorShoppingFrame.ResultsListing and AuctionatorShoppingFrame.ResultsListing.ScrollArea and AuctionatorShoppingFrame.ResultsListing.ScrollArea.ScrollBar and AuctionatorShoppingFrame.ResultsListing.ScrollArea.ScrollBar.Background then DarkMode:FindTextures(AuctionatorShoppingFrame.ResultsListing.ScrollArea.ScrollBar.Background, "addons") end
	end

	if AuctionatorBuyFrame and AuctionatorBuyFrame.CurrentPrices and AuctionatorBuyFrame.CurrentPrices.SearchResultsListing and AuctionatorBuyFrame.CurrentPrices.SearchResultsListing.ScrollArea and AuctionatorBuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar and AuctionatorBuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar.Background then DarkMode:FindTextures(AuctionatorBuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar.Background, "addons") end
	if AuctionatorSellingFrame then
		if AuctionatorSellingFrame.BagListing and AuctionatorSellingFrame.BagListing.View and AuctionatorSellingFrame.BagListing.View.ScrollBar and AuctionatorSellingFrame.BagListing.View.ScrollBar.Background then DarkMode:FindTextures(AuctionatorSellingFrame.BagListing.View.ScrollBar.Background, "addons") end
		if AuctionatorSellingFrame.BuyFrame and AuctionatorSellingFrame.BuyFrame.CurrentPrices and AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing and AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing.ScrollArea and AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar and AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar.Background then DarkMode:FindTextures(AuctionatorSellingFrame.BuyFrame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar.Background, "addons") end
	end

	if AuctionatorCancellingFrame and AuctionatorCancellingFrame.ResultsListing and AuctionatorCancellingFrame.ResultsListing.ScrollArea and AuctionatorCancellingFrame.ResultsListing.ScrollArea.ScrollBar and AuctionatorCancellingFrame.ResultsListing.ScrollArea.ScrollBar.Background then DarkMode:FindTextures(AuctionatorCancellingFrame.ResultsListing.ScrollArea.ScrollBar.Background, "addons") end
	DarkMode:InitLeatrixDruidBar()
	DarkMode:InitOutfitterFrame()
	for index, name in pairs(DarkMode:GetFrameAddonsTable()) do
		local baseFrame = DarkMode:GetFrameByName(name)
		if baseFrame then
			c = c + 1
			if c >= 30 then
				DarkMode:After(0.21, function() DarkMode:SearchAddons("RETRY1" .. from) end, "Reached Limit Addon")
				return
			end

			if baseFrame.Background and baseFrame.Icon and baseFrame.Mask then
				for _, key in ipairs({"Background", "SelectedTexture", "HighlightTexture", "TabGlow"}) do
					if baseFrame[key] then DarkMode:UpdateColor(baseFrame[key], "addons") end
				end
			else
				DarkMode:FindRepeatingTextures(name, baseFrame, "addons")
			end

			DarkMode:GetFrameAddonsTable()[name] = nil
		end
	end

	for index, name in pairs(RANKERBUTTONS) do
		DarkMode:FindRepeatingTextures(name, nil, "btns")
	end

	if not foundExpansion and ExpansionLandingPage and ExpansionLandingPage.Overlay then
		DarkMode:ForeachChildren(ExpansionLandingPage.Overlay, function(child)
			foundExpansion = true
			DarkMode:FindTextures(child.NineSlice, "ui")
		end, "SearchAddons")
	end

	for index, name in pairs(DarkMode:GetUiAddonsTable()) do
		if DarkMode:GetFrameByName(name) then
			c = c + 1
			if c >= 30 then
				DarkMode:After(0.22, function() DarkMode:SearchAddons("RETRY2" .. from) end, "Reached Limit UiAddon")
				return
			end

			DarkMode:FindTexturesByName(name, "ui")
			DarkMode:GetUiAddonsTable()[name] = nil
		end
	end
end

function DarkMode:AddMinimapHeaderIcon(btn)
	if btn == nil or btn.dmIconOverlay or btn.StateTexture == nil or btn.StateTexture.GetAtlas == nil then return end
	local state = btn.StateTexture
	local atlas = state:GetAtlas()
	if atlas == nil then return end
	local icon = btn:CreateTexture(nil, "ARTWORK", nil, 1)
	icon:SetAtlas(atlas)
	icon:SetAllPoints(state)
	local inset = state:GetWidth() * 0.22
	local mask = btn:CreateMaskTexture()
	mask:SetTexture("Interface\\BUTTONS\\WHITE8X8", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	mask:SetPoint("TOPLEFT", state, "TOPLEFT", inset, -inset)
	mask:SetPoint("BOTTOMRIGHT", state, "BOTTOMRIGHT", -inset, inset)
	icon:AddMaskTexture(mask)
	btn.dmIconOverlay = icon
	hooksecurefunc(state, "SetAtlas", function(_, newAtlas) icon:SetAtlas(newAtlas) end)
end

function DarkMode:SearchUi(from)
	if not debugDisabled then DarkMode:DEB("SearchUi", from) end
	local raidOnly = from == "raid"
	if MainActionBar and MainActionBar.UpdateDividers then
		if not MainActionBar.dmDividersHooked then
			MainActionBar.dmDividersHooked = true
			hooksecurefunc(MainActionBar, "UpdateDividers", DMUpdateMainActionBarDividers)
		end
		DMUpdateMainActionBarDividers(MainActionBar)
	end
	if BagsBar and BagsBar.UpdateDividers then
		if not BagsBar.dmDividersHooked then
			BagsBar.dmDividersHooked = true
			hooksecurefunc(BagsBar, "UpdateDividers", function(bar) DMUpdateMainActionBarDividers(bar, "bags") end)
		end
		DMUpdateMainActionBarDividers(BagsBar, "bags")
	end
	if MinimapCluster and MinimapCluster.DielFrame then DarkMode:ForeachRegions(MinimapCluster.DielFrame, function(region) if region.IsObjectType and region:IsObjectType("Texture") and region:GetDrawLayer() == "OVERLAY" then DarkMode:UpdateColor(region, "ui") end end, "DielFrame") end
	if TotemFrame then
		for i = 1, 4 do
			local totem = _G["TotemFrameTotem" .. i]
			if totem then DarkMode:ForeachChildren(totem, function(child, c) if child and DarkMode:GetName(child) == nil then DarkMode:ForeachRegions(child, function(region, r) if region and r == 1 then DarkMode:UpdateColor(region, "ui") end end) end end) end
		end
	end

	if DruidComboPointBarFrame then DarkMode:ForeachChildren(DruidComboPointBarFrame, function(child, c) if child then DarkMode:ForeachRegions(child, function(region, r) if region and (r == 1 or r == 2 or r == 3 or r == 4 or r == 5 or r == 7 or r == 9) then DarkMode:UpdateColor(region, "uf") end end) end end) end
	if PersonalResourceDisplayFrame then
		if PersonalResourceDisplayFrame.ClassFrameContainer then DarkMode:ForeachChildren(PersonalResourceDisplayFrame.ClassFrameContainer, function(child, c) if child then DarkMode:ForeachChildren(child, function(cchild, cc) if cchild then DarkMode:ForeachRegions(cchild, function(region, r) if region and (r == 1 or r == 2 or r == 3 or r == 4 or r == 5 or r == 7 or r == 9) then DarkMode:UpdateColor(region, "ui") end end) end end) end end) end
		if PersonalResourceDisplayFrame.HealthBarsContainer and PersonalResourceDisplayFrame.HealthBarsContainer.healthBar then DarkMode:ForeachRegions(PersonalResourceDisplayFrame.HealthBarsContainer.healthBar, function(region, r) if r == 1 then DarkMode:UpdateColor(region, "ui") end end) end
		if PersonalResourceDisplayFrame.PowerBar then DarkMode:ForeachRegions(PersonalResourceDisplayFrame.PowerBar, function(region, r) if r == 1 then DarkMode:UpdateColor(region, "ui") end end) end
		if PersonalResourceDisplayFrame.AlternatePowerBar then DarkMode:ForeachRegions(PersonalResourceDisplayFrame.AlternatePowerBar, function(region, r) if r == 1 then DarkMode:UpdateColor(region, "ui") end end) end
	end

	for index, tab in pairs(DarkMode:GetUiTable()) do
		if raidOnly and index == "UnitFrames" then
			for x, v in pairs(tab) do
				DarkMode:FindTexturesByName(v, "uf")
			end
		else
			if index == "ActionButtons" then
				DarkMode:After(0, function()
					for i, name in pairs(tab) do
						for x = 1, 12 do
							local btn = getglobal(name .. x)
							if btn then
								local nt = btn["DragonflightUINormalTexture2Replacement"]
								DarkMode:ForeachRegions(btn, function(child, n) if DarkMode:GetName(child) == "DragonflightUINormalTexture2Replacement" then DarkMode:UpdateColor(child, "actionbuttons") end end)
								if nt then DarkMode:UpdateColor(nt, "actionbuttons") end
							end
						end
					end
				end, "ActionButtons DragonflightUI")

				for i, name in pairs(tab) do
					local max = 12
					if name == "BT4Button" or name == "DominosActionButton" then max = 200 end
					for x = 1, max do
						local btn = _G[name .. x]
						local btnTextureNormalTexture = _G[name .. x .. "NormalTexture"]
						if btnTextureNormalTexture == nil and btn and btn.GetNormalTexture and DarkMode:IsClassicUIForever() then btnTextureNormalTexture = btn:GetNormalTexture() end
						local btnTextureFloatingBG = _G[name .. x .. "FloatingBG"]
						if btn and btnTextureFloatingBG then btn:HookScript("OnLeave", function() btnTextureNormalTexture:SetAlpha(0.5) end) end
						if name == "BT4StanceButton" and btn and _G[name .. x .. "BorderFix"] == nil and (DarkMode:IsEnabled("MASKACTIONBUTTONS", true) or name == "PetActionButton" or name == "StanceButton") and DarkMode:DMGV("COLORMODEAB", 1) ~= "Off" then
							local sw, sh = btn:GetSize()
							sw = DarkMode:MathR(sw)
							sh = DarkMode:MathR(sh)
							local scale = 1.1
							DarkMode:AddActionButtonBorder(btn, btn, name .. x, sw * scale, sh * scale, 0, 0, "actionbuttons", nil, true)
						elseif btnTextureNormalTexture then
							DarkMode:UpdateColor(btnTextureNormalTexture, "actionbuttons")
						end

						if LibStub and MSQ == nil then MSQ = LibStub("Masque", true) end
						if btn and btn["SlotArt"] then DarkMode:UpdateColor(btn["SlotArt"], "actionbuttons") end
						if btn and btn["SlotBackground"] then DarkMode:UpdateColor(btn["SlotBackground"], "actionbuttons") end
						if btn and btn["RightDivider"] then
							DarkMode:UpdateColor(btn["RightDivider"]["TopEdge"], "actionbuttons")
							DarkMode:UpdateColor(btn["RightDivider"]["Center"], "actionbuttons")
							DarkMode:UpdateColor(btn["RightDivider"]["BottomEdge"], "actionbuttons")
						end
						if MSQ then
							if btn then
								if btn.__MSQ_Mask then DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons") end
								if btn.__MSQ_Normal then DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons") end
								if btn.__MSQ_NewNormal then DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons") end
							end
						else
							if btnTextureFloatingBG then DarkMode:UpdateColor(btnTextureFloatingBG, "actionbuttons") end
						end

						if not MSQ then
							if DarkMode:IsEnabled("THINBORDERS", false) then
								if name == "PetActionButton" then
									local border = _G[name .. x .. "NormalTexture2"]
									if border then
										hooksecurefunc(border, "SetAlpha", function(sel, ...)
											if sel.dm_setalpha then return end
											sel.dm_setalpha = true
											sel:SetAlpha(0)
											sel.dm_setalpha = false
										end)

										border:SetAlpha(0)
									end
								elseif name == "StanceButton" then
									local border = _G[name .. x .. "NormalTexture2"]
									if border then
										hooksecurefunc(border, "SetAlpha", function(sel, ...)
											if sel.dm_setalpha then return end
											sel.dm_setalpha = true
											sel:SetAlpha(0)
											sel.dm_setalpha = false
										end)

										border:SetAlpha(0)
									end
								end

								if btnTextureNormalTexture then
									hooksecurefunc(btnTextureNormalTexture, "SetVertexColor", function(sel, ...)
										if sel.dm_setalpha then return end
										sel.dm_setalpha = true
										sel:SetAlpha(0)
										sel.dm_setalpha = false
									end)

									btnTextureNormalTexture:SetAlpha(0)
								end

								if btnTextureFloatingBG then
									hooksecurefunc(btnTextureFloatingBG, "SetVertexColor", function(sel, ...)
										if sel.dm_setalpha then return end
										sel.dm_setalpha = true
										sel:SetAlpha(0.5)
										sel.dm_setalpha = false
									end)

									btnTextureFloatingBG:SetAlpha(0.5)
									hooksecurefunc(btnTextureFloatingBG, "SetScale", function(sel)
										if sel.dm_setscale then return end
										sel.dm_setscale = true
										sel:SetScale(0.9)
										sel.dm_setscale = false
									end)

									btnTextureFloatingBG:SetScale(0.9)
									btnTextureFloatingBG:ClearAllPoints()
									btnTextureFloatingBG:SetPoint("CENTER", btn, "CENTER", 0, 0)
								end

								if btn and btn.dmborder == nil then
									local sw, sh = btn:GetSize()
									sw = DarkMode:MathR(sw)
									sh = DarkMode:MathR(sh)
									local scale = 1
									if name == "PetActionButton" then scale = 1.2 end
									if DarkMode:IsEnabled("SHADOWACTIONBARS", false) then
										DarkMode:AddActionButtonBorder(btn, btn, name .. x, sw * scale, sh * scale, 0, 0, "actionbuttons", "Interface\\AddOns\\DarkMode\\media\\defaultEER3", true)
									else
										DarkMode:AddActionButtonBorder(btn, btn, name .. x, sw * scale, sh * scale, 0, 0, "actionbuttons", "Interface\\AddOns\\DarkMode\\media\\defaultEER", true)
									end
								end
							elseif (DarkMode:GetWoWBuild() ~= "RETAIL" or DarkMode:IsClassicUIForever()) and (DarkMode:IsEnabled("MASKACTIONBUTTONS", true) or name == "PetActionButton" or name == "StanceButton") and DarkMode:DMGV("COLORMODEAB", 1) ~= "Off" then
								local icon = _G[name .. x .. "Icon"]
								if icon then
									local br = 0.012
									icon:SetTexCoord(br, 1 - br, br, 1 - br)
								end

								if btn and _G[name .. x .. ".DMBorder"] == nil then
									local sw, sh = btn:GetSize()
									sw = DarkMode:MathR(sw)
									sh = DarkMode:MathR(sh)
									local scale = 1.1
									if DarkMode:IsEnabled("SHADOWACTIONBARS", false) then
										DarkMode:AddActionButtonBorder(btn, btn, name, sw * scale, sh * scale, 0, 0, "actionbuttons", "Interface\\AddOns\\DarkMode\\media\\defaultEER3", true)
									else
										DarkMode:AddActionButtonBorder(btn, btn, name, sw * scale, sh * scale, 0, 0, "actionbuttons", "Interface\\AddOns\\DarkMode\\media\\defaultEER", true)
									end
								end
							end
						end
					end
				end
			elseif index == "Minimap" or index == "Artworks" or index == "Chat" or index == "Castbar" or index == "ObjectiveTracker" then
				for ind, name in pairs(tab) do
					if index == "Artworks" and name == "BT4BarBlizzardArt.nineSliceParent" then
						local frame = DarkMode:GetFrameByName(name)
						if frame then
							DarkMode:ForeachChildren(frame, function(child, x)
								if x == 1 then
									DarkMode:FindTextures(child, "ui") -- Bartender Border in BlizzardArt
								end
							end, "Artworks")
						end
					end

					if name ~= "MainMenuBarBackpackButtonNormalTexture" or DarkMode:GetWoWBuild() ~= "RETAIL" then DarkMode:FindTexturesByName(name, "ui") end
				end
			elseif index == "Gryphons" then
				if DarkMode:IsEnabled("GRYPHONS", true) then
					for i, name in pairs(tab) do
						DarkMode:FindTexturesByName(name, "ui")
					end
				end
			elseif index == "Tooltips" then
				for i, name in pairs(tab) do
					DarkMode:FindTexturesByName(name, "tt")
				end
			elseif type(tab) == "string" then
				DarkMode:FindTexturesByName(tab, "ui")
			elseif index == "UnitFrames" then
				for i, name in pairs(tab) do
					DarkMode:FindTexturesByName(name, "uf")
				end
			else
				DarkMode:MSG("[SearchUi] Missing Ui index:", index, tab)
			end
		end
	end

	local mode = DarkMode:DMGV("COLORMODEMI", 1)
	if mode ~= 7 and mode ~= 9 then
		local microButtons = DarkMode:GetMicroMenuButtons()
		tinsert(microButtons, "SocialsMicroButton")
		for i, name in pairs(microButtons) do
			if name then
				local mbtn = _G[name]
				if mbtn and _G[name .. ".DMBorder"] == nil then
					if mbtn.Background and MMBTNSETUP[mbtn.Background] == nil then
						MMBTNSETUP[mbtn.Background] = true
						local border = mbtn:CreateTexture(name .. ".DMBorder", "OVERLAY")
						border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mbtn_border")
						border:SetSize(32, 64)
						border:SetPoint("CENTER", mbtn.Background, "CENTER", 0, 10)
						DarkMode:UpdateColor(border, "micromenu")
					else
						if DarkMode:GetWoWBuild() == "CLASSIC" or DarkMode:GetWoWBuild() == "TBC" or DarkMode:GetWoWBuild() == "MISTS" then
							local border = mbtn:CreateTexture(name .. ".DMBorder", "OVERLAY")
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mbtn_border")
							border:SetPoint("TOPLEFT", mbtn, "TOPLEFT", 0, 19)
							border:SetPoint("BOTTOMRIGHT", mbtn, "BOTTOMRIGHT", 0, 0)
							DarkMode:UpdateColor(border, "micromenu")
						else
							local border = mbtn:CreateTexture(name .. ".DMBorder", "OVERLAY")
							border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mbtn_border")
							border:SetAllPoints(mbtn)
							DarkMode:UpdateColor(border, "micromenu")
						end
					end
				end
			end
		end
	end

	local MinimapZoomIn = getglobal("MinimapZoomIn") or (DarkMode:IsClassicUIForever() and Minimap and Minimap.ZoomIn)
	local MinimapZoomOut = getglobal("MinimapZoomOut") or (DarkMode:IsClassicUIForever() and Minimap and Minimap.ZoomOut)
	if MinimapZoomIn and MinimapZoomOut and _G["MinimapZoomIn" .. ".DMBorder"] == nil and not DarkMode:IsAddOnLoaded("DragonflightUI") then
		local border = MinimapZoomIn:CreateTexture("MinimapZoomIn" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\zoom_border")
		border:SetAllPoints(MinimapZoomIn)
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
		local border2 = MinimapZoomOut:CreateTexture("MinimapZoomOut" .. ".DMBorder", "OVERLAY")
		border2:SetTexture("Interface\\AddOns\\DarkMode\\media\\zoom_border")
		border2:SetAllPoints(MinimapZoomOut)
		border2:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border2, "ui")
	end

	DarkMode:AddMinimapHeaderIcon(MinimapCluster and MinimapCluster.Tracking and MinimapCluster.Tracking.Button)
	DarkMode:AddMinimapHeaderIcon(getglobal("GameTimeFrame"))

	local MiniMapTrackingFrame = getglobal("MiniMapTrackingFrame")
	if MiniMapTrackingFrame and _G["MiniMapTrackingFrame" .. ".DMBorder"] == nil then
		-- Classic Era
		local border = MiniMapTrackingFrame:CreateTexture("MiniMapTrackingFrame" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT")
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end

	local MiniMapTrackingButton = getglobal("MiniMapTrackingButton")
	if MiniMapTrackingButton and _G["MiniMapTrackingButton" .. ".DMBorder"] == nil and not DarkMode:IsAddOnLoaded("DragonflightUI") then
		-- Wrath
		local border = MiniMapTrackingButton:CreateTexture("MiniMapTrackingButton" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		if border.SetScale then border:SetScale(0.86) end
		DarkMode:UpdateColor(border, "ui")
	end

	local MiniMapWorldMapButton = getglobal("MiniMapWorldMapButton")
	if MiniMapWorldMapButton and _G["MiniMapWorldMapButton" .. ".DMBorder"] == nil and DarkMode:GetWoWBuild() == "WRATH" then
		local border = MiniMapWorldMapButton:CreateTexture("MiniMapWorldMapButton" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		if border.SetScale then border:SetScale(0.8) end
		DarkMode:UpdateColor(border, "ui")
	end

	local MiniMapMailFrame = getglobal("MiniMapMailFrame")
	if MiniMapMailFrame and _G["MiniMapMailFrame" .. ".DMBorder"] == nil and not DarkMode:IsAddOnLoaded("DragonflightUI") then
		local border = MiniMapMailFrame:CreateTexture("MiniMapMailFrame" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetDrawLayer("OVERLAY", 3)
		if border.SetScale then border:SetScale(0.8) end
		DarkMode:UpdateColor(border, "ui")
	end

	if GameTimeFrame and DarkMode:GetWoWBuild() ~= "RETAIL" and _G["GameTimeFrame" .. ".DMBorder"] == nil then
		local border = GameTimeFrame:CreateTexture("GameTimeFrame" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\gt_border")
		if DarkMode:GetWoWBuild() == "TBC" then
			border:SetPoint("TOPLEFT", 0, 0)
			if border.SetScale then border:SetScale(1) end
		elseif DarkMode:GetWoWBuild() ~= "CLASSIC" then
			border:SetPoint("TOPLEFT", -1, 1)
			if border.SetScale then border:SetScale(0.82) end
		else
			border:SetPoint("TOPLEFT")
		end

		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end

	DarkMode:After(2.1, function()
		DarkMode:Debug(5, "SearchUi")
		for i, btn in pairs(_G) do
			if (strfind(i, "LibDBIcon10_", 1, true) or strfind(i, "MinimapButton_D4Lib_", 1, true) or strfind(i, "LFGMinimapFrame", 1, true)) and not strfind(i, ".DMBorder", 1, true) then
				local name = DarkMode:GetName(btn)
				if btn and _G[name .. ".DMBorder"] == nil and btn.CreateTexture ~= nil and DarkMode:IsEnabled("MASKMINIMAPBUTTONS", true) and btn.dmborder == nil and (btn.d4border == nil or btn.d4border == true) then
					btn.dmborder = btn:CreateTexture(name .. ".DMBorder", "OVERLAY")
					local border = btn.dmborder
					border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
					border:SetPoint("TOPLEFT", 0, 1)
					border:SetParent(btn)
					if border.SetScale then border:SetScale(0.84) end
					border:SetDrawLayer("OVERLAY", 3)
					DarkMode:UpdateColor(border, "ui")
				end
			end
		end

		local MiniMapLFGFrame = getglobal("MiniMapLFGFrame")
		if MiniMapLFGFrame then DarkMode:FindTextures(MiniMapLFGFrame, "ui") end
		local Lib_GPI_Minimap_LFGBulletinBoard = getglobal("Lib_GPI_Minimap_LFGBulletinBoard")
		if Lib_GPI_Minimap_LFGBulletinBoard then DarkMode:ForeachRegions(Lib_GPI_Minimap_LFGBulletinBoard, function(region, x) if x == 2 then DarkMode:UpdateColor(region, "ui") end end, "Lib_GPI_Minimap_LFGBulletinBoard") end
		local PeggledMinimapIcon = getglobal("PeggledMinimapIcon")
		if PeggledMinimapIcon and PeggledMinimapIcon.border then DarkMode:UpdateColor(PeggledMinimapIcon.border, "ui") end
		local MBB_MinimapButtonFrame = getglobal("MBB_MinimapButtonFrame")
		if MBB_MinimapButtonFrame then DarkMode:ForeachRegions(MBB_MinimapButtonFrame, function(region) if region.IsObjectType and region:IsObjectType("Texture") and region:GetDrawLayer() == "OVERLAY" then DarkMode:UpdateColor(region, "ui") end end, "MBB_MinimapButtonFrame") end
	end, "SearchUi")

	local btwQ = _G["BtWQuestsMinimapButton"]
	if btwQ and _G["BtWQuestsMinimapButton" .. ".DMBorder"] == nil then
		local border = btwQ:CreateTexture("BtWQuestsMinimapButton" .. ".DMBorder", "OVERLAY")
		border:SetTexture("Interface\\AddOns\\DarkMode\\media\\mmicon_border")
		border:SetPoint("TOPLEFT", 0, 1)
		border:SetParent(btwQ)
		if border.SetScale then border:SetScale(0.9) end
		border:SetDrawLayer("OVERLAY", 3)
		DarkMode:UpdateColor(border, "ui")
	end
end

local compactframes = {"CompactPartyFrameBorderFrame", "CompactRaidFrameContainerBorderFrame", "CompactRaidGroup1BorderFrame", "CompactRaidGroup2BorderFrame", "CompactRaidGroup3BorderFrame", "CompactRaidGroup4BorderFrame", "CompactRaidGroup5BorderFrame", "CompactRaidGroup6BorderFrame", "CompactRaidGroup7BorderFrame", "CompactRaidGroup8BorderFrame"}
for i = 1, 40 do
	table.insert(compactframes, "CompactRaidFrame" .. i .. "HorizDivider")
	table.insert(compactframes, "CompactRaidFrame" .. i .. "HorizTopBorder")
	table.insert(compactframes, "CompactRaidFrame" .. i .. "HorizBottomBorder")
	table.insert(compactframes, "CompactRaidFrame" .. i .. "VertLeftBorder")
	table.insert(compactframes, "CompactRaidFrame" .. i .. "VertRightBorder")
end

function DarkMode:CheckCompactFrames()
	local newTab = {}
	for i, v in pairs(compactframes) do
		if _G[v] then
			DarkMode:FindTexturesByName(v, "uf")
		else
			table.insert(newTab, v)
		end
	end

	compactframes = newTab
end

local rf = CreateFrame("FRAME")
rf:RegisterEvent("GROUP_ROSTER_UPDATE")
rf:SetScript("OnEvent", function(self, event, name, ...)
	DarkMode:After(0.15, function()
		DarkMode:Debug(5, "GROUP_ROSTER_UPDATE")
		DarkMode:CheckCompactFrames()
	end, "GROUP_ROSTER_UPDATE")
end)

DarkMode:After(2, function()
	DarkMode:Debug(5, "CheckCompactFrames")
	DarkMode:CheckCompactFrames()
end, "CheckCompactFrames")

local tf = CreateFrame("FRAME")
DarkMode:RegisterEvent(tf, "PLAYER_TARGET_CHANGED")
DarkMode:RegisterEvent(tf, "PLAYER_FOCUS_CHANGED")
tf:SetScript("OnEvent", function()
	local tab = DarkMode:GetUiTable()["UnitFrames"]
	for i, name in pairs(tab) do
		DarkMode:FindTexturesByName(name, "uf")
	end
end)

function DarkMode:ColorAuraButton(btn, index, btnName, from)
	if btn == nil then return end
	local name = DarkMode:GetName(btn)
	if name == nil then name = btnName end
	local icon = btn.Icon or btn
	if DarkMode:IsEnabled("THINBORDERS", false) then
		if btn and _G[name .. "Buff" .. index .. "BorderDM"] == nil and DarkMode:IsEnabled("MASKBUFFSANDDEBUFFS", true) then
			if btn.Icon then
				local br = 0.075
				btn.Icon:SetTexCoord(br, 1 - br, br, 1 - br)
			end

			_G[name .. "Buff" .. index .. "BorderDM"] = btn:CreateTexture(name .. "Buff" .. index .. "BorderDM", "OVERLAY")
			local border = _G[name .. "Buff" .. index .. "BorderDM"]
			border:SetDrawLayer("OVERLAY", 7)
			border:SetTexture("Interface\\AddOns\\DarkMode\\media\\border_thin")
			border:SetAllPoints(icon)
			DarkMode:UpdateColor(border, "buffsanddebuffs")
		end
	else
		if btn ~= nil and _G[name .. "Buff" .. index .. "BorderDM"] == nil and DarkMode:IsEnabled("MASKBUFFSANDDEBUFFS", true) then
			_G[name .. "Buff" .. index .. "BorderDM"] = btn:CreateTexture(name .. "Buff" .. index .. "BorderDM", "OVERLAY")
			local border = _G[name .. "Buff" .. index .. "BorderDM"]
			border:SetDrawLayer("OVERLAY", 7)
			border:SetTexture("Interface\\AddOns\\DarkMode\\media\\defaultbuff2")
			border:SetAllPoints(icon)
			DarkMode:UpdateColor(border, "buffsanddebuffs")
		end
	end
end

if TargetFrame_UpdateBuffAnchor then
	hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(self, button, index)
		local name = "Target"
		if type(button) == "string" then
			local btn = _G[button .. index]
			if btn then
				if btn.unit == "focus" then name = "Focus" end
				DarkMode:ColorAuraButton(btn, index, name, "TargetFrame_UpdateBuffAnchor")
			end
		else
			local btn = button
			if btn then
				if btn.unit == "focus" then name = "Focus" end
				DarkMode:ColorAuraButton(btn, index, name, "TargetFrame_UpdateBuffAnchor")
			end
		end
	end)
end

local nameplateIds = {}
local failedNameplateIds = {}
local npf = CreateFrame("FRAME")
npf:RegisterEvent("NAME_PLATE_UNIT_ADDED")
function DarkMode:ColorNameplate(id)
	if nameplateIds[id] == nil and _G["NamePlate" .. id] then
		DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.PlayerLevelDiffFrame", "np")
		if _G["NamePlate" .. id]["UnitFrame"] and _G["NamePlate" .. id]["UnitFrame"]["HealthBarsContainer"] and _G["NamePlate" .. id]["UnitFrame"]["HealthBarsContainer"]["border"] then
			nameplateIds[id] = true
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.HealthBarsContainer.border", "np")
		elseif _G["NamePlate" .. id]["UnitFrame"] and _G["NamePlate" .. id]["UnitFrame"]["HealthBarsContainer"] and _G["NamePlate" .. id]["UnitFrame"]["HealthBarsContainer"]["healthBar"] and _G["NamePlate" .. id]["UnitFrame"]["HealthBarsContainer"]["healthBar"]["bgTexture"] then
			nameplateIds[id] = true
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.HealthBarsContainer.healthBar.bgTexture", "np")
			if _G["NamePlate" .. id]["UnitFrame"] and _G["NamePlate" .. id]["UnitFrame"]["CastBarsContainer"] and _G["NamePlate" .. id]["UnitFrame"]["CastBarsContainer"]["castBar"] and _G["NamePlate" .. id]["UnitFrame"]["CastBarsContainer"]["castBar"]["Background"] then DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.CastBarsContainer.castBar.Background", "np") end
		elseif _G["NamePlate" .. id]["UnitFrame"] and _G["NamePlate" .. id]["UnitFrame"]["HealthBarsContainer"] then
			nameplateIds[id] = true
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.HealthBarsContainer", "np")
		elseif _G["NamePlate" .. id]["UnitFrame"] and _G["NamePlate" .. id]["UnitFrame"]["healthBar"] then
			nameplateIds[id] = true
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.healthBar.border", "np")
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.CastBar.Border", "np")
			DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.CastBar.BorderShield", "np")
		end

		if nameplateIds[id] ~= nil and _G["NamePlate" .. id]["UnitFrame"] and _G["NamePlate" .. id]["UnitFrame"]["castBar"] and _G["NamePlate" .. id]["UnitFrame"]["castBar"]["border"] then DarkMode:FindTexturesByName("NamePlate" .. id .. ".UnitFrame.castBar.border", "np") end
	end
	return nameplateIds[id] ~= nil
end

npf:SetScript("OnEvent", function(self, event, name, ...)
	if DarkMode:DMGV("COLORMODENP", 1) == DarkMode:GetColorModeID("Off") then return end
	local id = string.sub(name, 10)
	local worked = DarkMode:ColorNameplate(id)
	if not worked then
		DarkMode:After(0.16, function()
			DarkMode:Debug(5, "NAME_PLATE_UNIT_ADDED 1")
			worked = DarkMode:ColorNameplate(id)
			if not worked then
				DarkMode:After(0.31, function()
					DarkMode:Debug(5, "NAME_PLATE_UNIT_ADDED 2")
					worked = DarkMode:ColorNameplate(id)
					if not worked and failedNameplateIds[id] == nil then
						failedNameplateIds[id] = true
						--DarkMode:MSG("FAILED TO ADD DARKMODE ON NAMEPLATE", id, "If custom nameplates are installed, set Nameplates to 'Off' in DarkMode")
					end
				end, "NAME_PLATE_UNIT_ADDED 2")
			end
		end, "NAME_PLATE_UNIT_ADDED 1")
	end
end)

function DarkMode:InitQuestFrameGreetingPanel()
	local frame = DarkMode:GetFrameByName("QuestFrameGreetingPanel")
	function DarkMode:UpdateQuestFrameGreetingPanel()
		DarkMode:FindTextsByName("QuestFrameGreetingPanel")
	end

	if frame then
		frame:HookScript("OnShow", function(sel, ...)
			DarkMode:After(questDelay, function()
				DarkMode:Debug(5, "InitQuestFrameGreetingPanel 1")
				DarkMode:UpdateQuestFrameGreetingPanel()
			end, "InitQuestFrameGreetingPanel 1")
		end)

		if QuestFrame.OnEvent then
			hooksecurefunc(QuestFrame, "OnEvent", function()
				DarkMode:After(questDelay, function()
					DarkMode:Debug(5, "InitQuestFrameGreetingPanel 2")
					DarkMode:UpdateQuestFrameGreetingPanel()
				end, "InitQuestFrameGreetingPanel 2")
			end)
		end
	end
end

function DarkMode:InitSlash()
	DarkMode:AddSlash("dm", DarkMode.ToggleSettings)
	DarkMode:AddSlash("dark", DarkMode.ToggleSettings)
	DarkMode:AddSlash("darkmode", DarkMode.ToggleSettings)
	DarkMode:AddSlashAlias("rl", "reload")
	DarkMode:AddSlashAlias("rel", "reload")
end

local AuraFrames = {}
local TargetBuffs = {}
local FocusBuffs = {}
local BuffFrameBuffs = {}
local BAGS = {"MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot", "DominosKeyRingButton", "KeyRingButton", "CharacterReagentBag0Slot"}
function DarkMode:AddClassicBagBorders()
	for i, v in pairs(BAGS) do
		local bagF = _G[v]
		local NT = _G[v .. "NormalTexture"]
		if bagF then
			local sw, sh = bagF:GetSize()
			if NT and NT.scalesetup == nil then
				NT.scalesetup = true
				if NT:GetTexture() == 130841 then
					local scale = 1.66
					NT:SetSize(sw * scale, sh * scale)
				end
			end

			local scale = 1.1
			if v == "KeyRingButton" then scale = 1 end
			if false then scale = 1.18 end
			DarkMode:AddActionButtonBorder(bagF, bagF, v, sw * scale, sh * scale, 0, 0, "bags", nil, false)
			if LibStub and MSQ == nil then MSQ = LibStub("Masque", true) end
			if MSQ and bagF and v ~= "BagToggle" then
				if bagF.__MSQ_Mask then DarkMode:UpdateColor(bagF.__MSQ_Mask, "bags") end
				if bagF.__MSQ_Normal then DarkMode:UpdateColor(bagF.__MSQ_Normal, "bags") end
				if bagF.__MSQ_NewNormal then DarkMode:UpdateColor(bagF.__MSQ_NewNormal, "bags") end
			end
		end
	end
end
DarkMode:After(4, function()
	DarkMode:Debug(3, "startSearch 1")
	DarkMode:AddonsSearch("startSearch 1")
end, "startSearch 1")

DarkMode:After(8, function()
	DarkMode:Debug(3, "startSearch 2")
	DarkMode:AddonsSearch("startSearch 2")
end, "startSearch 2")

function DarkMode:IsClassicUIForever()
	return C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded("ClassicUIForever") or false
end

function DarkMode:IsClassicUIChrome(texture)
	if texture == nil or texture.GetTexture == nil or texture.SetText then return false end
	local files = DarkMode:GetClassicUIChromeFiles()
	if texture.GetAtlas then
		local okAtlas, atlas = pcall(texture.GetAtlas, texture)
		if okAtlas and type(atlas) == "string" and not DarkMode:IsSecret(atlas) and files[atlas:lower()] then return true end
	end

	for _, getter in ipairs({"GetTextureFilePath", "GetTexture", "GetTextureFileID"}) do
		if texture[getter] then
			local ok, value = pcall(texture[getter], texture)
			if ok and value ~= nil and not DarkMode:IsSecret(value) then
				if type(value) == "number" and files[value] then return true end
				if type(value) == "string" then
					local base = value:match("([^\\/]+)$")
					if base and files[base:gsub("%.%a+$", ""):lower()] then return true end
				end
			end
		end
	end
	return false
end

function DarkMode:ColorBackdropEdges(frame)
	if frame.backdropInfo == nil or frame.backdropInfo.edgeFile == nil then return end
	for _, key in ipairs(DarkMode:GetDMRepeatingFrames2()) do
		if frame[key] then DarkMode:UpdateColor(frame[key], "frames") end
	end
end

function DarkMode:IsClassicUIRing(frame)
	if frame.GetName == nil or frame:GetName() ~= nil or frame.GetSize == nil then return false end
	local w, h = frame:GetSize()
	if type(w) ~= "number" or type(h) ~= "number" or DarkMode:IsSecret(w) or DarkMode:IsSecret(h) then return false end
	local size = DarkMode:GetClassicUIRingSize()
	return math.abs(w - size[1]) < 0.5 and math.abs(h - size[2]) < 0.5
end

function DarkMode:ColorClassicUITab(tab, typ)
	if type(tab) ~= "table" or DarkMode:IsForbidden(tab) or not rawget(tab, "fcuiTab") or tab.GetRegions == nil then return end
	DarkMode:ForeachRegions(tab, function(region) if region.IsObjectType and region:IsObjectType("Texture") and region:GetDrawLayer() ~= "HIGHLIGHT" then DarkMode:UpdateColor(region, typ or "frames") end end, "ClassicUITab")
end

function DarkMode:ColorClassicUIChrome(frame, typ, depth)
	depth = depth or 0
	if frame == nil or depth > 10 or DarkMode:IsForbidden(frame) then return end
	DarkMode:ColorBackdropEdges(frame)
	local own = rawget(frame, "fcui")
	if type(own) == "table" then
		for _, key in ipairs(DarkMode:GetClassicUIOwnKeys()) do
			local tex = own[key]
			if type(tex) == "table" and tex.SetVertexColor and tex.GetObjectType and tex:GetObjectType() == "Texture" then DarkMode:UpdateColor(tex, typ) end
		end
	end

	local column = rawget(frame, "fcuiColumn") or rawget(frame, "fcuiTrackArt")
	local ring = DarkMode:IsClassicUIRing(frame)
	if rawget(frame, "fcuiTab") then DarkMode:ColorClassicUITab(frame, typ) end
	if frame.GetRegions then DarkMode:ForeachRegions(frame, function(region) if DarkMode:IsClassicUIChrome(region) or (region.IsObjectType and region:IsObjectType("Texture") and (ring or (column and region:GetDrawLayer() == "BACKGROUND"))) then DarkMode:UpdateColor(region, typ) end end, "ClassicUIChrome") end
	if frame.GetChildren then DarkMode:ForeachChildren(frame, function(child) DarkMode:ColorClassicUIChrome(child, typ, depth + 1) end, "ClassicUIChrome") end
end

function DarkMode:ColorClassicUIQuestText(detailChild)
	if DarkMode:DMGV("COLORMODEF", 1) ~= DarkMode:GetColorModeID("Off") then DarkMode:FindTexts(detailChild, "ForeverClassicUIQuestLog") end
end

function DarkMode:ColorClassicUIRegions(frame, typ, layer)
	if type(frame) ~= "table" or frame.GetRegions == nil or DarkMode:IsForbidden(frame) then return end
	DarkMode:ForeachRegions(frame, function(region)
		if region.IsObjectType and region:IsObjectType("Texture") then
			local drawLayer = region:GetDrawLayer()
			if drawLayer ~= "HIGHLIGHT" and (layer == nil or drawLayer == layer) then DarkMode:UpdateColor(region, typ) end
		end
	end, "ClassicUIRegions")
end

function DarkMode:ColorClassicUINamedChrome(rootName, typ)
	for _, name in ipairs(DarkMode:GetClassicUINamedChrome(rootName) or {}) do
		DarkMode:FindTexturesByName(name, typ)
		local obj = DarkMode:GetFrameByName(name)
		if type(obj) == "table" and type(rawget(obj, "SetSelected")) == "function" and not obj.dm_classicui_selected then
			obj.dm_classicui_selected = true
			hooksecurefunc(obj, "SetSelected", function(sel) DarkMode:After(0.05, function() DarkMode:FindTextures(sel, typ) end, "ClassicUITab") end)
		end
	end

	for _, name in ipairs(DarkMode:GetClassicUIParentChrome(rootName) or {}) do
		local obj = DarkMode:GetFrameByName(name)
		if obj and obj.GetParent then DarkMode:ColorClassicUIRegions(obj:GetParent(), typ) end
	end

	local root = _G[rootName]
	for field, mode in pairs(DarkMode:GetClassicUITabLists(rootName) or {}) do
		local tabs = root and rawget(root, field)
		if type(tabs) == "table" then
			for _, tab in pairs(tabs) do
				if mode == "background" then
					DarkMode:ColorClassicUIRegions(tab, typ, "BACKGROUND")
				elseif mode == "states" then
					for _, getter in ipairs({"GetNormalTexture", "GetPushedTexture", "GetDisabledTexture"}) do
						local tex = tab[getter] and tab[getter](tab)
						if tex then DarkMode:UpdateColor(tex, typ) end
					end
				else
					DarkMode:ColorClassicUIRegions(tab, typ)
				end
			end
		end
	end
end

function DarkMode:SetupClassicUIChromeRoot(frame, typ, rootName)
	if frame.dm_classicui_chrome then return end
	frame.dm_classicui_chrome = true
	local detailChild = frame == _G["ForeverClassicUIQuestLog"] and frame.detailChild or nil
	local function ColorRoot()
		DarkMode:ColorClassicUIChrome(frame, typ)
		DarkMode:ColorClassicUINamedChrome(rootName, typ)
		DarkMode:After(0.1, function() DarkMode:ColorClassicUINamedChrome(rootName, typ) end, "ClassicUIChrome")
		if detailChild then DarkMode:ColorClassicUIQuestText(detailChild) end
		DarkMode:After(0.1, function() DarkMode:ColorClassicUIChrome(frame, typ) end, "ClassicUIChrome")
		DarkMode:After(1, function() DarkMode:ColorClassicUIChrome(frame, typ) end, "ClassicUIChrome")
		DarkMode:After(5, function() DarkMode:ColorClassicUIChrome(frame, typ) end, "ClassicUIChrome")
		DarkMode:After(15, function() DarkMode:ColorClassicUIChrome(frame, typ) end, "ClassicUIChrome")
	end

	frame:HookScript("OnShow", ColorRoot)
	if detailChild then hooksecurefunc(detailChild, "SetHeight", function() DarkMode:ColorClassicUIQuestText(detailChild) end) end
	ColorRoot()
end

function DarkMode:ColorClassicUIStatusBar(status)
	for _, strip in ipairs(status.fcuiStrips or {}) do
		DarkMode:UpdateColor(strip, "ui")
	end
end

function DarkMode:SetupClassicUIStatusBars()
	for _, name in ipairs(DarkMode:GetClassicUIStatusContainers()) do
		local container = _G[name]
		if container and type(container.bars) == "table" then
			for _, bar in pairs(container.bars) do
				local status = type(bar) == "table" and bar.StatusBar
				if status and status.HookScript and not status.dm_classicui_status then
					status.dm_classicui_status = true
					hooksecurefunc(status, "SetSize", function() DarkMode:After(0.05, function() DarkMode:ColorClassicUIStatusBar(status) end, "ClassicUIStatusBar") end)
					status:HookScript("OnShow", function() DarkMode:After(0.05, function() DarkMode:ColorClassicUIStatusBar(status) end, "ClassicUIStatusBar") end)
					DarkMode:ColorClassicUIStatusBar(status)
				end
			end
		end
	end
end

function DarkMode:GetDragonTexture(texture)
	if type(texture) ~= "string" then return "" end
	local name = texture:lower():gsub("%.%a+$", ""):match("([^\\/]+)$") or ""
	name = name:gsub("%-nomana$", ""):gsub("%-big$", ""):gsub("%-thickmana$", ""):gsub("%-thickname$", "")

	return DarkMode:GetDragonTextures()[name] or ""
end

function DarkMode:AddDragonOverlay(tex, host, path, onUpdate, coordFn, typ)
	local dragon = host:CreateTexture(nil, "OVERLAY")
	dragon:SetAllPoints(tex)
	dragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare-Elite_Dragon")
	DarkMode:LockColorType(dragon, typ or "ufdr")
	local function DMUpdateDragon()
		local layer, subLevel = tex:GetDrawLayer()
		local dragonSubLevel = math.min((subLevel or 0) + 1, 7)
		dragon:SetDrawLayer(layer, dragonSubLevel)
		if coordFn then
			dragon:SetTexCoord(coordFn(path, tex:GetTexCoord()))
		else
			dragon:SetTexCoord(tex:GetTexCoord())
		end
		dragon:SetTexture(DarkMode:GetDragonTexture(path))
		if onUpdate then onUpdate(layer, dragonSubLevel) end
	end

	hooksecurefunc(tex, "SetTexture", function(sel, texture)
		path = texture
		DMUpdateDragon()
	end)

	hooksecurefunc(tex, "SetAtlas", function()
		path = nil
		DMUpdateDragon()
	end)

	hooksecurefunc(tex, "SetTexCoord", DMUpdateDragon)
	hooksecurefunc(tex, "SetShown", function(sel, shown) dragon:SetShown(shown) end)
	hooksecurefunc(tex, "Show", function() dragon:Show() end)
	hooksecurefunc(tex, "Hide", function() dragon:Hide() end)
	dragon:SetShown(tex:IsShown())
	DMUpdateDragon()

	return dragon
end

function DarkMode:LeatrixChainCoords(path, ...)
	local coords = {...}
	if type(path) == "string" and path:lower():find("leatrix_plus") then
		for i = 1, #coords, 2 do
			coords[i] = 1 - coords[i]
			coords[i + 1] = coords[i + 1] * 2 - 0.25
		end
	end

	return unpack(coords)
end

function DarkMode:ApplyLeatrixChain(tex, container, path)
	local atlas = tex:GetAtlas()
	if type(atlas) == "string" and atlas:lower():find("portraiton%-boss") then
		DarkMode:UpdateColor(tex, "ufdrp")
	elseif not tex.dmDragon and DarkMode:GetDragonTexture(path) ~= "" and DarkMode:UpdateColor(tex, "uf") then
		tex.dmDragon = DarkMode:AddDragonOverlay(tex, container, path, nil, function(p, ...) return DarkMode:LeatrixChainCoords(p, ...) end, "ufdrp")
	end
end

function DarkMode:SetupLeatrixPlayerChain(tries)
	if not DarkMode:IsAddOnLoaded("Leatrix_Plus") or DarkMode:IsAddOnLoaded("DragonflightUi") then return end
	if type(LeaPlusDB) ~= "table" or LeaPlusDB["ShowPlayerChain"] ~= "On" then return end
	local container = PlayerFrame and PlayerFrame.PlayerFrameContainer
	if not container or not container.GetRegions then return end
	local keyed = {}
	for _, v in pairs(container) do
		if type(v) == "table" then keyed[v] = true end
	end

	local classicPaths = {
		[4] = "Interface\\TargetingFrame\\UI-TargetingFrame-Rare.blp",
		[5] = "Interface\\TargetingFrame\\UI-TargetingFrame-Elite.blp",
		[6] = "Interface\\AddOns\\Leatrix_Plus\\Leatrix_Plus.blp",
	}

	local found = 0
	for _, region in ipairs({container:GetRegions()}) do
		if not keyed[region] and not region.dmLeatrixChain and region:IsObjectType("Texture") and region:GetDrawLayer() == "OVERLAY" and region:GetBlendMode() ~= "ADD" then
			region.dmLeatrixChain = true
			found = found + 1
			hooksecurefunc(region, "SetAtlas", function(sel) DarkMode:ApplyLeatrixChain(sel, container) end)
			hooksecurefunc(region, "SetTexture", function(sel, path) DarkMode:ApplyLeatrixChain(sel, container, path) end)
			local path = nil
			if region:GetAtlas() == nil and region:GetTexture() ~= nil then path = classicPaths[LeaPlusDB["PlayerChainMenu"]] end
			DarkMode:ApplyLeatrixChain(region, container, path)
		end
	end

	if found == 0 and (tries or 0) > 0 then DarkMode:After(1, function() DarkMode:SetupLeatrixPlayerChain(tries - 1) end, "LeatrixChain") end
end

function DarkMode:ColorLeatrixMapsBorder(frame)
	DarkMode:ForeachRegions(frame, function(region) if region.IsObjectType and region:IsObjectType("Texture") and region:GetDrawLayer() == "BORDER" then DarkMode:UpdateColor(region, "frames") end end, "LeatrixMapsBorder")
	for _, child in ipairs({frame:GetChildren()}) do
		DarkMode:ColorBackdropEdges(child)
	end
end

function DarkMode:SetupLeatrixMapsBorder()
	if not DarkMode:IsAddOnLoaded("Leatrix_Maps") or not WorldMapFrame or not WorldMapFrame.GetChildren then return end
	if not WorldMapFrame.dmLeatrixMapsHook then
		WorldMapFrame.dmLeatrixMapsHook = true
		WorldMapFrame:HookScript("OnShow", function() DarkMode:SetupLeatrixMapsBorder() end)
	end

	for _, child in ipairs({WorldMapFrame:GetChildren()}) do
		local info = child.backdropInfo
		if not child.dmLeatrixMapsBorder and child:GetName() == nil and type(info) == "table" and info.bgFile == "Interface\\Buttons\\WHITE8X8" and info.edgeFile == nil and child:GetFrameStrata() == WorldMapFrame:GetFrameStrata() then
			child.dmLeatrixMapsBorder = true
			hooksecurefunc(child, "CreateTexture", function() DarkMode:After(0.1, function() DarkMode:ColorLeatrixMapsBorder(child) end, "LeatrixMapsBorder") end)
			DarkMode:ColorLeatrixMapsBorder(child)
		end
	end
end

function DarkMode:SetupMapUtilsSimpleMapFrame()
	if not WorldMapFrame or not WorldMapFrame.HookScript then return end
	if not WorldMapFrame.dmMapUtilsSimpleHook then
		WorldMapFrame.dmMapUtilsSimpleHook = true
		WorldMapFrame:HookScript("OnShow", function() DarkMode:SetupMapUtilsSimpleMapFrame() end)
	end

	local frame = _G["MapUtilsSimpleMapFrame"]
	if frame == nil or frame.dmMapUtilsSimple then return end
	frame.dmMapUtilsSimple = true
	DarkMode:ForeachRegions(frame, function(region) if region.IsObjectType and region:IsObjectType("Texture") then DarkMode:UpdateColor(region, "frames") end end, "MapUtilsSimpleMapFrame")
end

function DarkMode:ColorClassicUIBarBorder(bar, layer)
	local fill = bar.GetStatusBarTexture and bar:GetStatusBarTexture()
	local found = false
	DarkMode:ForeachRegions(bar, function(region) if region ~= fill and region.IsObjectType and region:IsObjectType("Texture") and region:GetDrawLayer() == layer and DarkMode:UpdateColor(region, "ui") then found = true end end, "ClassicUIBarBorder")

	return found
end

function DarkMode:SetupClassicUIUnitArt()
	if DarkMode.dmClassicUIUnitArtDone then return end
	local pending = false
	for path, layer in pairs(DarkMode:GetClassicUIBarBorders()) do
		local bar = DarkMode:GetFrameByName(path)
		if bar and bar.GetRegions and not bar.dm_classicui_border and DarkMode:ColorClassicUIBarBorder(bar, layer) then bar.dm_classicui_border = true end
		if not (bar and bar.dm_classicui_border) then pending = true end
	end

	for _, path in ipairs(DarkMode:GetClassicUIUnitArt()) do
		local tex = DarkMode:GetFrameByName(path)
		if tex and not tex.dm_classicui_art and DarkMode:UpdateColor(tex, "uf") then tex.dm_classicui_art = true end
		if not (tex and tex.dm_classicui_art) then pending = true end
	end

	if not DarkMode:IsAddOnLoaded("DragonflightUi") then
		for _, path in ipairs(DarkMode:GetClassicUIDragonArt()) do
			local tex = DarkMode:GetFrameByName(path)
			if tex and tex.GetParent and not tex.dmDragon and DarkMode:UpdateColor(tex, "uf") then tex.dmDragon = DarkMode:AddDragonOverlay(tex, tex:GetParent(), nil, nil, nil, path:find("^PlayerFrame") and "ufdrp" or "ufdr") end
			if not (tex and tex.dmDragon) then pending = true end
		end
	end

	DarkMode.dmClassicUIUnitArtDone = not pending
end

function DarkMode:WatchClassicUIForever()
	if not DarkMode:IsClassicUIForever() then return end
	for _, fn in ipairs({"PanelTemplates_SelectTab", "PanelTemplates_DeselectTab"}) do
		if _G[fn] then hooksecurefunc(fn, function(tab) DarkMode:After(0.05, function() DarkMode:ColorClassicUITab(tab, "frames") end, "ClassicUITab") end) end
	end

	local names = DarkMode:GetClassicUIForeverFrames()
	local roots = DarkMode:GetClassicUIChromeRoots()
	C_Timer.NewTicker(0.25, function()
		local found = false
		for i = 1, #names do
			if DarkMode:GetFrameAddonsTable()[names[i]] and _G[names[i]] then found = true end
		end

		if found then DarkMode:AddonsSearch("ClassicUIForever") end
		DarkMode:SetupClassicUIStatusBars()
		DarkMode:SetupClassicUIUnitArt()
		for typ, list in pairs(roots) do
			for i = 1, #list do
				local root = _G[list[i]]
				if type(root) == "table" and root.HookScript and not root.dm_classicui_chrome then DarkMode:SetupClassicUIChromeRoot(root, typ, list[i]) end
			end
		end
	end)
end

local inspectFound = false
function DarkMode:Event(event, ...)
	if event == "PLAYER_LOGIN" then
		if DarkMode.Setup == nil then
			DarkMode.Setup = true
			DarkMode:WatchClassicUIForever()
			local foundBugSack = false
			local function StyleBugSack()
				local BugSackFrame = _G["BugSackFrame"]
				if BugSackFrame and foundBugSack == false then
					foundBugSack = true
					DarkMode:After(0.02, function()
						DarkMode:Debug(5, "foundBugSack")
						DarkMode:FindTextures(BugSackFrame, "addons")
					end, "foundBugSack")
				end
			end

			local BugSack = _G["BugSack"]
			if BugSack and BugSack.OpenSack then hooksecurefunc(BugSack, "OpenSack", StyleBugSack) end
			StyleBugSack()

			DarkMode:InitSlash()
			DarkMode:InitDB()
			DarkMode:InitDMSettings()
			DarkMode:InitGreetingPanel()
			DarkMode:InitQuestLogFrame()
			DarkMode:InitQuestFrameGreetingPanel()
			DarkMode:After(1, function()
				DarkMode:Debug(5, "GroupLootUpdate")
				DarkMode:GroupLootUpdate()
			end, "GroupLootUpdate")

			local chatButtons = {
				["ChatFrame%sButtonFrameBottomButton"] = {0.77, -0.5, 0},
				["ChatFrame%sButtonFrameDownButton"] = {0.77, -0.5, 0},
				["ChatFrame%sButtonFrameUpButton"] = {0.77, -0.5, 0},
			}

			local chatSpecialButtons = {
				["ChatFrameMenuButton"] = {0.8, 0.77, 0, 0},
				["ChatFrameChannelButton"] = {0.94, 0.94, 0, 0},
				["FriendsMicroButton"] = {0.76, 0.98, -1, 0},
				["QuickJoinToastButton"] = {0.76, 0.98, -1, 0},
			}

			local ChatFrame1ButtonFrameBottomButton = getglobal("ChatFrame1ButtonFrameBottomButton")
			if ChatFrame1ButtonFrameBottomButton then
				for i = 1, 10 do
					for btnName, btnTab in pairs(chatButtons) do
						local btn = _G[format(btnName, i)]
						if btn then
							local scale = btnTab[1]
							local px = btnTab[2]
							local py = btnTab[3]
							local _, sh = btn:GetSize()
							sh = DarkMode:MathR(sh)
							DarkMode:AddActionButtonBorder(btn, btn, format(btnName, i), sh * scale, sh * scale, px, py, "ui", nil, false)
							hooksecurefunc(btn, "SetNormalTexture", function(sel, texture)
								-- Leatrix Plus fix...
								if texture == "" and btn.border then btn.border:SetAlpha(0) end
							end)
						end
					end
				end
			end

			for btnName, btnTab in pairs(chatSpecialButtons) do
				local btn = _G[btnName]
				if btn then
					local scalew = btnTab[1]
					local scaleh = btnTab[2]
					local px = btnTab[3]
					local py = btnTab[4]
					local sw, sh = btn:GetSize()
					sw = DarkMode:MathR(sw)
					sh = DarkMode:MathR(sh)
					DarkMode:AddActionButtonBorder(btn, btn, btnName, sh * scalew, sh * scaleh, px, py, "ui", nil, false)
				end
			end

			local function DMSetupClassicFrameDragon(frameName, tries)
				local frame = _G[frameName]
				local classicFrame = frame and frame.ClassicFrame
				local tex = classicFrame and classicFrame.Texture
				if not tex then
					if tries > 0 then
						C_Timer.After(1, function() DMSetupClassicFrameDragon(frameName, tries - 1) end)
					end

					return
				end

				if classicFrame.dmDragon or DarkMode:IsAddOnLoaded("DragonflightUi") then return end
				local content = frame.TargetFrameContent or frame.PlayerFrameContent
				local contentMain = content and (content.TargetFrameContentMain or content.PlayerFrameContentMain)
				local contentContext = content and (content.TargetFrameContentContextual or content.PlayerFrameContentContextual)
				local levelText = contentMain and contentMain.LevelText or frame == PlayerFrame and PlayerLevelText
				if contentContext and contentContext:GetParent() == classicFrame and contentContext:GetFrameLevel() <= classicFrame:GetFrameLevel() and not InCombatLockdown() then contentContext:SetFrameLevel(classicFrame:GetFrameLevel() + 1) end
				local function DMLiftLevelText(layer, dragonSubLevel)
					if levelText and levelText:GetParent() == classicFrame then
						local textLayer, textSubLevel = levelText:GetDrawLayer()
						if textLayer == layer and (textSubLevel or 0) <= dragonSubLevel then levelText:SetDrawLayer(textLayer, math.min(dragonSubLevel + 1, 7)) end
					end
				end

				classicFrame.dmDragon = DarkMode:AddDragonOverlay(tex, classicFrame, tex:GetTexture(), DMLiftLevelText, nil, frame == PlayerFrame and "ufdrp" or "ufdr")
				local container = frame.PlayerFrameContainer
				if container then
					local function DMLockPlayerElite()
						if container.PlayerElite then DarkMode:LockColorType(container.PlayerElite, "ufdrp") end
					end

					DMLockPlayerElite()
					if type(BBF) == "table" and type(BBF.PlayerElite) == "function" then hooksecurefunc(BBF, "PlayerElite", DMLockPlayerElite) end
				end
			end

			for x, name in pairs({"PlayerFrame", "TargetFrame", "FocusFrame"}) do
				DMSetupClassicFrameDragon(name, 30)
			end

			if type(BBF) == "table" and type(BBF.SetClassicHDLevelRing) == "function" then
				local function DMLockHDLevelRing(frame)
					local classicFrame = frame and frame.ClassicFrame
					if classicFrame and classicFrame.HDLevelCircle then DarkMode:LockColorType(classicFrame.HDLevelCircle, "uf") end
				end

				hooksecurefunc(BBF, "SetClassicHDLevelRing", DMLockHDLevelRing)
				for x, frame in pairs({PlayerFrame, TargetFrame, FocusFrame}) do
					DMLockHDLevelRing(frame)
				end
			end

			DarkMode:After(1, function() DarkMode:SetupLeatrixPlayerChain(10) end, "LeatrixChain")
			DarkMode:After(1, function() DarkMode:SetupLeatrixMapsBorder() end, "LeatrixMapsBorder")
			DarkMode:After(1, function() DarkMode:SetupMapUtilsSimpleMapFrame() end, "MapUtilsSimpleMapFrame")

			if DarkMode:GetWoWBuild() ~= "RETAIL" then
				-- delay for other addons changing
				DarkMode:After(2, function()
					DarkMode:Debug(5, "BAGS ~= RETAIL")
					local mode = DarkMode:DMGV("COLORMODEBA", 1)
					if mode ~= 7 and mode ~= 9 then DarkMode:AddClassicBagBorders() end
				end, "BAGS")

				local function dm_endswith(sel, suffix)
					if type(suffix) ~= "string" then error("suffix must be a string", 2) end
					local len_s, len_suffix = #sel, #suffix
					if len_suffix == 0 then return true end
					if len_suffix > len_s then return false end
					return sel:sub(len_s - len_suffix + 1) == suffix
				end

				string.dm_endswith = dm_endswith
				local FocusFrameTextureFrame = getglobal("FocusFrameTextureFrame")
				local FocusFrameTextureFrameTexture = getglobal("FocusFrameTextureFrameTexture")
				if FocusFrameTextureFrame and FocusFrameTextureFrameTexture then
					FocusFrameDragon = FocusFrameTextureFrame:CreateTexture("FocusFrameDragon", "BACKGROUND")
					FocusFrameDragon:SetSize(256, 128)
					FocusFrameDragon:SetPoint("CENTER", FocusFramePortrait, "CENTER", -54, -20)
					hooksecurefunc(FocusFrameTextureFrameTexture, "SetTexture", function(sel, texture)
						if DarkMode:IsAddOnLoaded("DragonflightUi") then return end
						FocusFrameDragon:SetDrawLayer("BACKGROUND", 1)
						FocusFrameDragon:SetTexture(DarkMode:GetDragonTexture(texture))
					end)

					if not DarkMode:IsAddOnLoaded("DragonflightUi") then
						FocusFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare-Elite_Dragon")
						DarkMode:UpdateColor(FocusFrameDragon, "ufdr")
						FocusFrameDragon:SetTexture("")
					end
				end

				local TargetFrameTextureFrame = getglobal("TargetFrameTextureFrame")
				local TargetFrameTextureFrameTexture = getglobal("TargetFrameTextureFrameTexture")
				if TargetFrameTextureFrame and TargetFrameTextureFrameTexture then
					TargetFrameDragon = TargetFrameTextureFrame:CreateTexture("TargetFrameDragon", "BACKGROUND")
					TargetFrameDragon:SetSize(256, 128)
					TargetFrameDragon:SetPoint("CENTER", TargetFramePortrait, "CENTER", -54, -20)
					hooksecurefunc(TargetFrameTextureFrameTexture, "SetTexture", function(sel, texture)
						if DarkMode:IsAddOnLoaded("DragonflightUi") then return end
						TargetFrameDragon:SetDrawLayer("BACKGROUND", 1)
						TargetFrameDragon:SetTexture(DarkMode:GetDragonTexture(texture))
					end)

					if not DarkMode:IsAddOnLoaded("DragonflightUi") then
						TargetFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare-Elite_Dragon")
						DarkMode:UpdateColor(TargetFrameDragon, "ufdr")
						TargetFrameDragon:SetTexture("")
					end
				end

				local PlayerFrameTexture = getglobal("PlayerFrameTexture")
				if PlayerFrame and PlayerFrameTexture then
					local parent = DarkMode:GetParent(PlayerFrameTexture)
					if parent then
						PlayerFrameDragon = parent:CreateTexture("PlayerFrameDragon", "BORDER")
						PlayerFrameDragon:SetTexCoord(1, 0, 0, 1)
						PlayerFrameDragon:SetSize(256, 128)
						PlayerFrameDragon:SetPoint("CENTER", PlayerPortrait, "CENTER", 54, -20)
						hooksecurefunc(PlayerFrameTexture, "SetTexture", function(sel, texture)
							if DarkMode:IsAddOnLoaded("DragonflightUi") then return end
							PlayerFrameDragon:SetDrawLayer("BORDER", 1)
							PlayerFrameDragon:SetTexture(DarkMode:GetDragonTexture(texture))
						end)

						if not DarkMode:IsAddOnLoaded("DragonflightUi") then
							PlayerFrameDragon:SetTexture("Interface\\AddOns\\DarkMode\\media\\UI-TargetingFrame-Rare-Elite_Dragon")
							DarkMode:UpdateColor(PlayerFrameDragon, "ufdrp")
							PlayerFrameDragon:SetTexture("")
						end
					end
				end

				for x, name in pairs({"PlayerFrame", "TargetFrame", "FocusFrame", "TargetFrameToT", "FocusFrameToT"}) do
					local hp = DarkMode:GetFrameByName(name .. "HealthBar")
					if hp then
						local hpBar = select(1, hp:GetRegions())
						if hpBar then
							local redo = false
							hooksecurefunc(hp, "SetStatusBarColor", function(sel, ...)
								if redo then return end
								redo = true
								local r, g, b, a = DarkMode:GetTypeColor("ufhp", hpBar)
								if r and g and b and a then sel:SetStatusBarColor(r, g, b, a) end
								redo = false
							end)

							local r, g, b, a = DarkMode:GetTypeColor("ufhp", hpBar)
							if r and g and b and a then hp:SetStatusBarColor(r, g, b, a) end
						end
					end

					local portrait = DarkMode:GetFrameByName(name .. "Portrait") or DarkMode:GetFrameByName("PlayerPortrait")
					if portrait then
						local redo = false
						hooksecurefunc(portrait, "SetVertexColor", function(sel, ...)
							if redo then return end
							redo = true
							DarkMode:UpdateColor(portrait, "ufpor", "portrait2", true)
							redo = false
						end)

						DarkMode:UpdateColor(portrait, "ufpor", "portrait1", true)
					end
				end
			else
				if TargetFrame and TargetFrame.TargetFrameContainer and TargetFrame.TargetFrameContainer.BossPortraitFrameTexture then DarkMode:UpdateColor(TargetFrame.TargetFrameContainer.BossPortraitFrameTexture, "ufdr") end
				if FocusFrame and FocusFrame.TargetFrameContainer and FocusFrame.TargetFrameContainer.BossPortraitFrameTexture then DarkMode:UpdateColor(FocusFrame.TargetFrameContainer.BossPortraitFrameTexture, "ufdr") end
				for x, name in pairs({"Player", "Target", "Focus", "TargetFrameToT", "FocusFrameToT"}) do
					local healthbar = DarkMode:GetFrameByName(name .. "Frame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar")
					if healthbar and healthbar.HealthBarTexture then
						DarkMode:UpdateColor(healthbar.HealthBarTexture, "ufhp")
					else
						local healthbar2 = DarkMode:GetFrameByName(name .. ".HealthBar") or DarkMode:GetFrameByName("PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBar")
						if healthbar2 then DarkMode:UpdateColor(select(4, healthbar2:GetRegions()), "ufhp") end
					end

					local portrait = DarkMode:GetFrameByName(name .. ".Portrait") or DarkMode:GetFrameByName(name .. "Frame." .. name .. "FrameContainer.Portrait") or DarkMode:GetFrameByName(name .. "Frame." .. "Target" .. "FrameContainer.Portrait") or DarkMode:GetFrameByName(name .. "Frame." .. name .. "FrameContainer.PlayerPortrait")
					if portrait then
						local redo = false
						hooksecurefunc(portrait, "SetVertexColor", function(sel, ...)
							if redo then return end
							redo = true
							DarkMode:UpdateColor(portrait, "ufpor")
							redo = false
						end)

						DarkMode:UpdateColor(portrait, "ufpor")
					end
				end

				-- delay for other addons changing
				DarkMode:After(1, function()
					DarkMode:Debug(5, "BAGS == RETAIL")
					local mode = DarkMode:DMGV("COLORMODEBA", 1)
					if mode ~= 7 and mode ~= 9 and DarkMode:IsClassicUIForever() then
						DarkMode:AddClassicBagBorders()
						for i, v in pairs(BAGS) do
							local bagF = _G[v]
							if bagF and bagF.GetNormalTexture and bagF:GetNormalTexture() then DarkMode:UpdateColor(bagF:GetNormalTexture(), "bags") end
						end
					elseif mode ~= 7 and mode ~= 9 then
						for i, v in pairs(BAGS) do
							local bagF = _G[v]
							local NT = _G[v .. "NormalTexture"]
							if NT == nil and bagF and bagF.GetNormalTexture and DarkMode:IsForever() then NT = bagF:GetNormalTexture() end
							if bagF and NT then
								if MainMenuBarBackpackButton ~= bagF or DarkMode:IsForever() then
									if DarkMode:IsEnabled("DESATURATE", true) then NT:SetDesaturated(true) end
									DarkMode:UpdateColor(NT, "bags")
								elseif not DarkMode:IsAddOnLoaded("DragonflightUi") then
									bagF.border = bagF:CreateTexture(v .. ".BagBorder", "ARTWORK")
									bagF.border:SetTexture("Interface\\AddOns\\DarkMode\\media\\bag-main-border")
									bagF.border:SetSize(bagF:GetSize())
									bagF.border:SetPoint("CENTER", bagF, "CENTER", -1, 1)
									if DarkMode:IsEnabled("DESATURATE", true) then bagF.border:SetDesaturated(true) end
									DarkMode:UpdateColor(bagF.border, "bags")
								end
							end
						end
					end
				end, "OtherAddons")
			end

			local reputations = {"TargetFrameNameBackground", "FokusFrameNameBackground", "TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor", "FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor"}
			for i, v in pairs(reputations) do
				local reputation = _G[v]
				if reputation then
					local redo = false
					hooksecurefunc(reputation, "SetVertexColor", function(sel, ...)
						if redo then return end
						redo = true
						DarkMode:UpdateColor(reputation, "ufrep", "reputation2", true)
						redo = false
					end)

					DarkMode:UpdateColor(reputation, "ufrep", "reputation1", true)
				end
			end

			local BuffFrame_UpdateAllBuffAnchors = getglobal("BuffFrame_UpdateAllBuffAnchors")
			if DarkMode:IsEnabled("MASKBUFFSANDDEBUFFS", true) then
				if BuffFrame and BuffFrame.UpdateAuras then
					hooksecurefunc(BuffFrame, "UpdateAuras", function(sel)
						DarkMode:Debug(3, "BuffFrame Update")
						for index, btn in pairs(sel.auraFrames) do
							if btn and AuraFrames[btn] == nil then
								AuraFrames[btn] = true
								DarkMode:Debug(3, "BuffFrame Added btn", btn)
								if LibStub and MSQ == nil then MSQ = LibStub("Masque", true) end
								if MSQ and btn then
									if btn.__MSQ_Mask then DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons") end
									if btn.__MSQ_Normal then DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons") end
									if btn.__MSQ_NewNormal then DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons") end
								else
									DarkMode:ColorAuraButton(btn, index, "Aura", "BuffFrame")
								end
							end
						end
					end)
				end

				if AuraFrameMixin and AuraFrameMixin.Update then
					hooksecurefunc(AuraFrameMixin, "Update", function(sel)
						DarkMode:Debug(3, "AuraFrameMixin Update")
						for index, btn in pairs(sel.auraFrames) do
							if btn and AuraFrames[btn] == nil then
								AuraFrames[btn] = true
								DarkMode:Debug(3, "AuraFrameMixin Added btn", btn)
								if LibStub and MSQ == nil then MSQ = LibStub("Masque", true) end
								if MSQ and btn then
									if btn.__MSQ_Mask then DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons") end
									if btn.__MSQ_Normal then DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons") end
									if btn.__MSQ_NewNormal then DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons") end
								else
									DarkMode:ColorAuraButton(btn, index, "Aura", "AuraFrameMixin")
								end
							end
						end
					end)
				elseif BuffFrame_UpdateAllBuffAnchors then
					hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function(sel, ...)
						DarkMode:Debug(3, "BuffFrame_UpdateAllBuffAnchors")
						local buttonName = "BuffButton"
						local BUFF_ACTUAL_DISPLAY = getglobal("BUFF_ACTUAL_DISPLAY")
						for index = 1, BUFF_ACTUAL_DISPLAY do
							local btn = _G[buttonName .. index]
							if btn and BuffFrameBuffs[index] == nil then
								BuffFrameBuffs[index] = true
								DarkMode:Debug(3, "BuffFrame_UpdateAllBuffAnchors Added index", index)
								if LibStub and MSQ == nil then MSQ = LibStub("Masque", true) end
								if MSQ then
									if btn.__MSQ_Mask then DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons") end
									if btn.__MSQ_Normal then DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons") end
									if btn.__MSQ_NewNormal then DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons") end
								else
									DarkMode:ColorAuraButton(btn, index, buttonName, "BuffFrame_UpdateAllBuffAnchors")
								end
							end
						end
					end)
				end

				local TargetFrame_UpdateAuras = getglobal("TargetFrame_UpdateAuras")
				if TargetFrame_UpdateAuras then
					hooksecurefunc("TargetFrame_UpdateAuras", function(frame)
						DarkMode:Debug(3, "TargetFrame_UpdateAuras")
						local name = DarkMode:GetName(frame)
						if name == nil then return end
						local buttonName = name .. "Buff"
						for index = 1, 32 do
							local btn = _G[buttonName .. index]
							if LibStub and MSQ == nil then MSQ = LibStub("Masque", true) end
							if btn and ((frame == TargetFrame and TargetBuffs[index] == nil) or (frame == FocusFrame and FocusBuffs[index] == nil)) then
								if frame == TargetFrame then
									TargetBuffs[index] = true
								elseif frame == TargetFrame then
									FocusBuffs[index] = true
								end

								DarkMode:Debug(3, "TargetFrame_UpdateAuras Added index", index)
								if MSQ and btn then
									if btn.__MSQ_Mask then DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons") end
									if btn.__MSQ_Normal then DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons") end
									if btn.__MSQ_NewNormal then DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons") end
								else
									DarkMode:ColorAuraButton(btn, index, buttonName, "TargetFrame_UpdateAuras")
								end
							end
						end
					end)
				else
					function DarkMode:UpdateTargetBuffs()
						DarkMode:Debug(3, "UNIT_AURA")
						local name = "TargetFrame"
						if name == nil then return end
						local buttonName = name .. "Buff"
						for index = 1, 32 do
							local btn = _G[buttonName .. index]
							if LibStub and MSQ == nil then MSQ = LibStub("Masque", true) end
							if btn and TargetBuffs[index] == nil then
								TargetBuffs[index] = true
								DarkMode:Debug(3, "TargetFrame_UpdateAuras Added index", index)
								if MSQ and btn then
									if btn.__MSQ_Mask then DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons") end
									if btn.__MSQ_Normal then DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons") end
									if btn.__MSQ_NewNormal then DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons") end
								else
									DarkMode:ColorAuraButton(btn, index, buttonName, "TargetFrame_UpdateAuras")
								end
							end
						end
					end

					local frameT = CreateFrame("Frame")
					frameT:RegisterUnitEvent("UNIT_AURA", "target")
					frameT:SetScript("OnEvent", function(sel, eve, unit) if unit == "target" then DarkMode:UpdateTargetBuffs() end end)
					TargetFrame:HookScript("OnShow", function() DarkMode:After(0.1, function() DarkMode:UpdateTargetBuffs() end, "TargetFrameShow") end)
					function DarkMode:UpdateFocusBuffs()
						DarkMode:Debug(3, "UNIT_AURA")
						local name = "FocusFrame"
						if name == nil then return end
						local buttonName = name .. "Buff"
						for index = 1, 32 do
							local btn = _G[buttonName .. index]
							if LibStub and MSQ == nil then MSQ = LibStub("Masque", true) end
							if btn and FocusBuffs[index] == nil then
								FocusBuffs[index] = true
								DarkMode:Debug(3, "FocusFrame_UpdateAuras Added index", index)
								if MSQ and btn then
									if btn.__MSQ_Mask then DarkMode:UpdateColor(btn.__MSQ_Mask, "actionbuttons") end
									if btn.__MSQ_Normal then DarkMode:UpdateColor(btn.__MSQ_Normal, "actionbuttons") end
									if btn.__MSQ_NewNormal then DarkMode:UpdateColor(btn.__MSQ_NewNormal, "actionbuttons") end
								else
									DarkMode:ColorAuraButton(btn, index, buttonName, "FocusFrame_UpdateAuras")
								end
							end
						end
					end

					local frameF = CreateFrame("Frame")
					frameF:RegisterUnitEvent("UNIT_AURA", "focus")
					frameF:SetScript("OnEvent", function(sel, eve, unit) if unit == "focus" then DarkMode:UpdateFocusBuffs() end end)
					FocusFrame:HookScript("OnShow", function() DarkMode:After(0.1, function() DarkMode:UpdateFocusBuffs() end, "TargetFrameShow") end)
				end
			end

			local castbars = {"TargetFrameSpellBar", "FocusFrameSpellBar"}
			for index, name in pairs(castbars) do
				local spellbar = _G[name]
				if spellbar then
					local icon = spellbar.Icon
					if icon then
						local scale = 1
						local sw, sh = icon:GetSize()
						sw = DarkMode:MathR(sw)
						sh = DarkMode:MathR(sh)
						DarkMode:AddActionButtonBorder(spellbar, icon, name, sw * scale, sh * scale, 0, 0, "buffsanddebuffs", nil, false)
					end
				end
			end

			DarkMode:After(0.1, function()
				DarkMode:Debug(5, "setup")
				DarkMode:SearchUi("setup")
				DarkMode:SearchFrames()
				DarkMode:SearchForTexts("INIT")
				if ItemTextPageText then
					hooksecurefunc(ItemTextPageText, "SetTextColor", function(sel, name, ...)
						if sel.dm_settextcolor then return end
						sel.dm_settextcolor = true
						local r, g, b, a = DarkMode:GetTypeColor("frames", sel)
						local cr, cg, cb, ca = DarkMode:GetTextColor(r, g, b, a)
						sel:SetTextColor(name, cr, cg, cb, ca)
						sel.dm_settextcolor = false
					end)

					local r, g, b = 1, 1, 1
					ItemTextPageText:SetTextColor("P", r, g, b)
					ItemTextPageText:SetTextColor("H1", r, g, b)
					ItemTextPageText:SetTextColor("H2", r, g, b)
					ItemTextPageText:SetTextColor("H3", r, g, b)
				end
			end, "PLAYER_LOGIN")

			if DarkMode:GetWoWBuild() ~= "RETAIL" and FriendsFramePortrait then
				hooksecurefunc(FriendsFramePortrait, "Show", function() FriendsFramePortrait:Hide() end)
				FriendsFramePortrait:Hide()
			end

			DarkMode:After(0, function()
				local DragonflightUIXPBar = getglobal("DragonflightUIXPBar")
				if DragonflightUIXPBar and DragonflightUIXPBar.Bar then DarkMode:ForeachRegions(DragonflightUIXPBar.Bar, function(region) if DarkMode:GetName(region) == "Border" then DarkMode:UpdateColor(region, "ui") end end) end
				local DragonflightUIRepBar = getglobal("DragonflightUIRepBar")
				if DragonflightUIRepBar and DragonflightUIRepBar.Bar then DarkMode:ForeachRegions(DragonflightUIRepBar.Bar, function(region) if DarkMode:GetName(region) == "Border" then DarkMode:UpdateColor(region, "ui") end end) end
				local DragonflightUIBigBagBorder = getglobal("DragonflightUIBigBagBorder")
				if DragonflightUIBigBagBorder then DarkMode:UpdateColor(DragonflightUIBigBagBorder, "ui") end
				local DragonflightUIKeyRingBorder = getglobal("DragonflightUIKeyRingBorder")
				if DragonflightUIKeyRingBorder then DarkMode:UpdateColor(DragonflightUIKeyRingBorder, "ui") end
				for x = 0, 3 do
					local btn = getglobal("CharacterBag" .. x .. "Slot")
					if btn then DarkMode:ForeachRegions(btn, function(region) if DarkMode:GetName(region) == "DragonflightUIBagBorder" then DarkMode:UpdateColor(region, "ui") end end) end
				end
			end, "DragonflightUI")

			DarkMode:CreateMinimapButton({
				["name"] = "DarkMode",
				["icon"] = DarkMode:GetAddonIcon(),
				["dbtab"] = DMTAB,
				["vTT"] = {{format("|T%s:16:16:0:0|t DarkMode", DarkMode:GetAddonIcon()),"v" .. DarkMode:GetVersion()}, {DarkMode:Trans("LID_LEFTCLICK"), DarkMode:Trans("LID_OPENSETTINGS")}, {DarkMode:Trans("LID_RIGHTCLICK"), DarkMode:Trans("LID_HIDEMINIMAPBUTTON")}},
				["funcL"] = function() DarkMode:ToggleSettings() end,
				["funcR"] = function()
					DarkMode:SetEnabled("MMBTN", false)
					DarkMode:HideMMBtn("DarkMode")
				end,
				["dbkey"] = "MMBTN"
			})

			if GameMenuFrame then
				GameMenuFrame:HookScript("OnShow", function()
					DarkMode:ForeachChildren(GameMenuFrame, function(child, x)
						if child.Left then DarkMode:UpdateColor(child.Left, "btns") end
						if child.Middle then DarkMode:UpdateColor(child.Middle, "btns") end
						if child.Center then DarkMode:UpdateColor(child.Center, "btns") end
						if child.Right then DarkMode:UpdateColor(child.Right, "btns") end
					end)

					DarkMode:FindTextures(GameMenuFrame, "frames")
				end)
			end

			DarkMode:RetryAddonsSearch()
		end
	elseif event == "ADDON_LOADED" then
		local from = ...
		if InspectFrame and not inspectFound then
			inspectFound = true
			DarkMode:After(0.1, function()
				if InspectModelFrame then DarkMode:FindTextures(InspectModelFrame, "frames") end
				if InspectMainHandSlot then
					DarkMode:ForeachRegions(InspectMainHandSlot, function(region, x)
						if x == 14 then
							tinsert(DarkMode:GetFrameTableSpecial(), region) -- CATA
						end
					end, "InspectMainHandSlot")
				end

				local InspectRangedSlot = getglobal("InspectRangedSlot")
				if InspectRangedSlot then
					DarkMode:ForeachRegions(InspectRangedSlot, function(region, x)
						if x == 14 then
							tinsert(DarkMode:GetFrameTableSpecial(), region) -- CATA
						end
					end, "InspectRangedSlot")
				end

				for index, frame in pairs(DarkMode:GetFrameTableSpecial()) do
					DarkMode:UpdateColor(frame, "frames")
				end
			end, "Inspect Found")
		end

		DarkMode:AddonsSearch(from)
	elseif event == "START_LOOT_ROLL" then
		DarkMode:After(0.1, function()
			DarkMode:Debug(5, "GroupLootUpdate")
			DarkMode:GroupLootUpdate()
		end, "START_LOOT_ROLL")
	end
end

function DarkMode:GroupLootUpdate()
	for i, name in pairs(DarkMode:GetGroupLootTable()) do
		local gf = _G[name]
		if gf then
			DarkMode:UpdateColor(gf, "ui")
			for x, v in pairs(DarkMode:GetDMRepeatingFrames2()) do
				local texture = gf[v]
				if texture then DarkMode:UpdateColor(texture, "ui") end
			end
		end
	end
end

function DarkMode:UpdateVigor()
	if UIWidgetPowerBarContainerFrame == nil then return end
	DarkMode:ForeachChildren(UIWidgetPowerBarContainerFrame, function(child)
		if child.DecorLeft and child.DecorLeft.GetAtlas then
			local atlas = child.DecorLeft:GetAtlas()
			if atlas and string.find(atlas, "vigor", 1, true) then
				DarkMode:UpdateColor(child.DecorLeft, "ui")
				DarkMode:UpdateColor(child.DecorRight, "ui")
			end
		end

		DarkMode:ForeachChildren(child, function(cchild)
			if cchild.Frame and cchild.Frame.GetAtlas then
				local atlas = cchild.Frame:GetAtlas()
				if atlas and string.find(atlas, "vigor", 1, true) then DarkMode:UpdateColor(cchild.Frame, "ui") end
			end
		end, "UpdateVigor 2")
	end, "UpdateVigor 1")
end

local vigor = CreateFrame("Frame")
vigor:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
vigor:RegisterEvent("PLAYER_ENTERING_WORLD")
vigor:SetScript("OnEvent", function(sel, event)
	if event == "PLAYER_ENTERING_WORLD" then
		DarkMode:After(1.1, function()
			DarkMode:Debug(5, "UpdateVigor 1")
			DarkMode:UpdateVigor()
		end, "PLAYER_ENTERING_WORLD")
	elseif event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
		DarkMode:After(0.26, function()
			DarkMode:Debug(5, "UpdateVigor 2")
			DarkMode:UpdateVigor()
		end, "PLAYER_MOUNT_DISPLAY_CHANGED")
	end
end)

DarkMode:After(1, function()
	if not DarkMode:IsAddOnLoaded("DragonflightUI") then return end
	for _, frameName in ipairs({"TargetFrame", "TargetFrameToT", "FocusFrame", "FocusFrameToT"}) do
		local frame = _G[frameName]
		if frame then
			for _, part in ipairs({"Border", "Background"}) do
				local texture = DarkMode:FindTextures(frame, "uf", "DragonflightUI" .. frameName .. part)
				if texture then DarkMode:UpdateColor(texture, "uf") end
			end
		end
	end
end, "DragonflightUIFix")

local f = CreateFrame("Frame")
f:SetScript("OnEvent", DarkMode.Event)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("START_LOOT_ROLL")
f.incombat = false
if false then
	C_Timer.After(1, function()
		DarkMode:SetDebug(true)
		DarkMode:DrawDebug("DarkMode DrawDebug", function()
			local text = ""
			for i, v in pairs(DarkMode:GetCountAfter()) do
				if v > 100 then text = text .. i .. ": " .. v .. "\n" end
			end
			return text
		end, 14, 1440, 1440, "CENTER", UIParent, "CENTER", 400, 0)
	end)
end
