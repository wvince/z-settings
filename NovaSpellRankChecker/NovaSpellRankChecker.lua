---------------------------
--Nova Spell Rank Checker--
---------------------------
--Novaspark/Venomisto-Arugal OCE (classic)
--https://www.curseforge.com/members/venomisto/projects
--Adds a scanButton to spellbook when clicked will highlight any low spell ranks on your hotbars.

local addonName, NPRC = ...;
local CustomGlow = LibStub("LibCustomGlow-1.0");
local spellData, highlighted = {}, {};
local defaultBars = {"Action", "MultiBarBottomLeft", "MultiBarBottomRight", "MultiBarRight", "MultiBarLeft", "MultiBar5", "MultiBar6", "MultiBar7"};
local SpellBookFrame = SpellBookFrame;
local GetSpellInfo = GetSpellInfo;
local GetSpellLink = GetSpellLink or C_Spell.GetSpellLink;
local scanButton, loadedFrames;

function NPRC:loadFrameStuff()
	if (loadedFrames) then
		return;
	end
	loadedFrames = true;
	SpellBookFrame:HookScript("OnHide", function(self, arg)
		NPRC:removeAllHighlighted();
	end)
	
	scanButton = CreateFrame("Button", "$parentScanButton", SpellBookFrame, "UIPanelButtonTemplate");
	scanButton:SetFrameLevel(6000);
	scanButton:SetWidth(140);
	scanButton:SetHeight(24);
	scanButton:SetScale(0.8);
	scanButton:SetText("Check Hotbar Ranks");
	scanButton:SetScript("OnClick", function(self, arg)
		NPRC:scanHotbars();
	end)
end

if (SpellBookFrame) then
	--Classic.
	NPRC:loadFrameStuff();
	local f = CreateFrame("Frame");
	f:RegisterEvent("PLAYER_ENTERING_WORLD");
	f:SetScript("OnEvent", function(self, event, ...)
		local isLogon, isReload = ...;
		if (isLogon or isReload) then
			if (ModernSpellBookFrame) then
				scanButton:SetParent(ModernSpellBookFrame);
				scanButton:SetPoint("TOPRIGHT", ModernSpellBookFrame, "TOPRIGHT", -110, -2);
			elseif (ElvUI) then
				scanButton:SetPoint("TOPRIGHT", SpellBookFrame, "TOPRIGHT", -72, -34);
			else
				scanButton:SetPoint("TOPRIGHT", SpellBookFrame, "TOPRIGHT", -56, -52);
			end
		end
		f:UnregisterEvent("PLAYER_ENTERING_WORLD");
	end)
else
	--Forever.
	local f = CreateFrame("Frame");
	f:RegisterEvent("ADDON_LOADED");
	f:SetScript("OnEvent", function(self, event, ...)
		local addon = ...;
		if (addon == "Blizzard_PlayerSpells") then
			SpellBookFrame = PlayerSpellsFrame;
			NPRC:loadFrameStuff();
			if (ModernSpellBookFrame) then
				scanButton:SetParent(ModernSpellBookFrame);
				scanButton:SetPoint("TOPRIGHT", ModernSpellBookFrame, "TOPRIGHT", -110, -2);
			elseif (ElvUI) then
				scanButton:SetPoint("TOPRIGHT", SpellBookFrame, "TOPRIGHT", -72, -34);
				if (PlayerSpellsFrame.SpellBookFrame:IsShown()) then
					scanButton:Show();
				else
					scanButton:Hide();
				end
			else
				scanButton:SetPoint("TOPRIGHT", SpellBookFrame, "TOPRIGHT", -80, -125);
				PlayerSpellsFrame:HookScript("OnHide", function(self, arg)
					if (PlayerSpellsFrame.SpellBookFrame:IsShown()) then
						scanButton:Show();
					else
						scanButton:Hide();
					end
				end)
			end
			f:UnregisterEvent("ADDON_LOADED");
		end
	end)
end

local function ActionButton_ShowOverlayGlow(button)
	CustomGlow.ButtonGlow_Start(button);
end

local function ActionButton_HideOverlayGlow(button)
	CustomGlow.ButtonGlow_Stop(button);
end

local function getSpelldata()
	spellData = {};
	if (GetNumSpellTabs) then
		--Classic.
		for tab = 1, GetNumSpellTabs() do
			local name, texture, offset, numSlots, isGuild, offspecID = GetSpellTabInfo(tab);
			for i = offset + 1, offset + numSlots do
				local spellName, spellSubText, spellID = GetSpellBookItemName(i, BOOKTYPE_SPELL);
				local rank = strmatch(spellSubText, "%d+");
				if (rank) then
					rank = tonumber(rank);
					if (rank > 0 and not spellData[spellName] or rank > spellData[spellName]) then
						spellData[spellName] = rank;
					end
				end
			end
		end
	else
		--Forever.
		for tab = 1, C_SpellBook.GetNumSpellBookSkillLines() do
			local tabData = C_SpellBook.GetSpellBookSkillLineInfo(tab);
			local name, texture, offset, numSlots, isGuild, offspecID;
			name = tabData.name;
			texture = tabData.iconID;
			offset = tabData.itemIndexOffset;
			numSlots = tabData.numSpellBookItems;
			isGuild = tabData.isGuild;
			offspecID = tabData.offSpecID;
			for i = offset + 1, offset + numSlots do
				local spellName, spellSubText, spellID = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Player);
				local rank = strmatch(spellSubText, "%d+");
				if (rank) then
					rank = tonumber(rank);
					if (rank > 0 and not spellData[spellName] or rank > spellData[spellName]) then
						spellData[spellName] = rank;
					end
				end
			end
		end
	end
	return spellData;
end

function NPRC:removeAllHighlighted()
	for k, v in pairs(highlighted) do
		ActionButton_HideOverlayGlow(v);
	end
	highlighted = {};
end

--Some of these addons also use default bars or whatever, this is made so multiple scan types can be run in one go.
local function scanDefaultUI(spellData, count)
	count = count or 0;
	for bar, barName in pairs(defaultBars) do
		for i = 1, 12 do
			local button = _G[barName .. "Button" .. i];
			if (button) then
				local slot = button.action or 0;
				if (slot and HasAction(slot)) then
					local spellID = 0;
					local actionType, id = GetActionInfo(slot);
					if (actionType == "macro") then
						spellID = GetMacroSpell(id);
					elseif (actionType == "spell") then
						spellID = id;
					end
					if (spellID and spellID > 0) then
						local spell = Spell:CreateFromSpellID(spellID);
						spell:ContinueOnSpellLoad(function()
							local spellName = spell:GetSpellName();
							local spellSubText = spell:GetSpellSubtext();
							local rank = strmatch(spellSubText, "%d+");
							if (rank) then
								rank = tonumber(rank);
								if (rank and spellData[spellName] and rank < spellData[spellName]) then
									count = count + 1;
									ActionButton_ShowOverlayGlow(button);
									tinsert(highlighted, button);
									local text = "|cFFFFFF00Bar " .. bar .. " Slot " .. i .. ":|r " .. GetSpellLink(spellID) .. " |cFF9CD6DE(" .. RANK .. " " .. rank .. ")|r";
									text = text .. " |cFFFF6900Not Max Rank.|r";
									print(text);
								end
							end
						end);
					end
				end
			end
		end
	end
	return count;
end

local function scanBartender4(spellData, count)
	count = count or 0;
	for i = 1, 120 do
		local button = _G["BT4Button" .. i];
		if (button) then
			local slot = _G["BT4Button" .. i].id;
			if (slot and HasAction(slot)) then
				local spellID = 0;
				local actionType, id = GetActionInfo(slot);
				if (actionType == "macro") then
					spellID = GetMacroSpell(id);
				elseif (actionType == "spell") then
					spellID = id;
				end
				if (spellID and spellID > 0) then
					local spell = Spell:CreateFromSpellID(spellID);
					spell:ContinueOnSpellLoad(function()
						local spellName = spell:GetSpellName();
						local spellSubText = spell:GetSpellSubtext();
						local rank = strmatch(spellSubText, "%d+");
						if (rank) then
							rank = tonumber(rank);
							if (rank and spellData[spellName] and rank < spellData[spellName]) then
								count = count + 1;
								local bar = ceil(i / 12);
								local slot = i % 12;
								if (slot == 0) then
									slot = 12;
								end
								ActionButton_ShowOverlayGlow(button);
								tinsert(highlighted, button);
								local text = "|cFFFFFF00Bar " .. bar .. " Slot " .. slot .. ":|r " .. GetSpellLink(spellID) .. " |cFF9CD6DE(" .. RANK .. " " .. rank .. ")|r";
								text = text .. " |cFFFF6900Not Max Rank.|r";
								print(text);
							end
						end
					end);
				end
			end
		end
	end
	return count;
end

local function scanElvUI(spellData, count)
	count = count or 0;
	for bar = 1, 12 do
		for slotNum = 1, 12 do
			local button = _G["ElvUI_Bar" .. bar .. "Button" .. slotNum];
			if (button) then
				local slot = _G["ElvUI_Bar" .. bar .. "Button" .. slotNum]._state_action;
                if (slot and HasAction(slot)) then
					local spellID = 0;
					local actionType, id = GetActionInfo(slot);
					if (actionType == "macro") then
						spellID = GetMacroSpell(id);
					elseif (actionType == "spell") then
						spellID = id;
					end
					if (spellID and spellID > 0) then
						local spell = Spell:CreateFromSpellID(spellID);
						spell:ContinueOnSpellLoad(function()
							local spellName = spell:GetSpellName();
							local spellSubText = spell:GetSpellSubtext();
							local rank = strmatch(spellSubText, "%d+");
							if (rank) then
								rank = tonumber(rank);
								if (rank and spellData[spellName] and rank < spellData[spellName]) then
									count = count + 1;
									ActionButton_ShowOverlayGlow(button);
									tinsert(highlighted, button);
									local text = "|cFFFFFF00Bar " .. bar .. " Slot " .. slotNum .. ":|r " .. GetSpellLink(spellID) .. " |cFF9CD6DE(" .. RANK .. " " .. rank .. ")|r";
									text = text .. " |cFFFF6900Not Max Rank.|r";
									print(text);
								end
							end
						end);
					end
				end
			end
		end
	end
	return count;
end

local function scanDominos(spellData, count)
	count = count or 0;
	--For dominos we need to scan default bars too, it seems to use some.
	count = count + scanDefaultUI(spellData, count);
	for i = 1, 120 do
		local button = _G["DominosActionButton" .. i];
		if (button) then
			local slot = _G["DominosActionButton" .. i].action;
			if (slot and HasAction(slot)) then
				local spellID = 0;
				local actionType, id = GetActionInfo(slot);
				if (actionType == "macro") then
					spellID = GetMacroSpell(id);
				elseif (actionType == "spell") then
					spellID = id;
				end
				if (spellID and spellID > 0) then
					local spell = Spell:CreateFromSpellID(spellID);
					spell:ContinueOnSpellLoad(function()
						local spellName = spell:GetSpellName();
						local spellSubText = spell:GetSpellSubtext();
						local rank = strmatch(spellSubText, "%d+");
						if (rank) then
							rank = tonumber(rank);
							if (rank and spellData[spellName] and rank < spellData[spellName]) then
								count = count + 1;
								local bar = ceil(i / 12);
								local slot = i % 12;
								if (slot == 0) then
									slot = 12;
								end
								ActionButton_ShowOverlayGlow(button);
								tinsert(highlighted, button);
								local text = "|cFFFFFF00Bar " .. bar .. " Slot " .. slot .. ":|r " .. GetSpellLink(spellID) .. " |cFF9CD6DE(" .. RANK .. " " .. rank .. ")|r";
								text = text .. " |cFFFF6900Not Max Rank.|r";
								print(text);
							end
						end
					end);
				end
			end
		end
	end
	return count;
end

function NPRC:scanHotbars()
	print("|cFF00C800Scanning hotbars for low rank spells:");
	NPRC:removeAllHighlighted();
	local count;
	local spellData = getSpelldata();
	if (Bartender4) then
		count = scanBartender4(spellData)
	elseif (ElvUI) then
		count = scanElvUI(spellData)
	elseif (Dominos) then
		count = scanDominos(spellData);
	else
		count = scanDefaultUI(spellData);
	end
	if (count > 0) then
		print("|cFF00C800Finished, |cFFFF6900" .. count .. "|r slots found with low rank spells.");
	else
		print("|cFF00C800Finished, none found.");
	end
	spellData = {};
end

local function checkSingleSlot()
	---TODO: Recheck slot when we drag a new spell if slot is highlighted.
	---For now we just remove highlights when spellbook is closed.
end