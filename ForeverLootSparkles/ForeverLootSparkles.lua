-- Quest item sparkles only show when the outline mode is off and
-- outlineModeShowLootEffectWhenDisabled is on. Graphics presets reset these,
-- so they are applied at login and again after every relevant cvar change.

local ADDON_NAME, ns = ...;

local WANTED = {
	outlineModeShowLootEffectWhenDisabled = "1",
	graphicsOutlineMode = "0",
	OutlineEngineMode = "0",
	raidGraphicsOutlineMode = "0",
	RAIDOutlineEngineMode = "0",
};

-- Written once when the option is switched off: loot sparkle off, outline
-- mode back to 2 ("High" in the graphics settings). The plain cvar defaults
-- would leave the outline off too, so quest items would get no highlight.
local DISABLED = {
	outlineModeShowLootEffectWhenDisabled = "0",
	graphicsOutlineMode = "2",
	OutlineEngineMode = "2",
	raidGraphicsOutlineMode = "2",
	RAIDOutlineEngineMode = "2",
};

local WATCHED = {
	graphicsquality = true,
	raidgraphicsquality = true,
};
for cvar in pairs(WANTED) do
	WATCHED[strlower(cvar)] = true;
end

local db;
-- Whether sparkles have been on at any point since the game started. Once on,
-- they stay visible until the next restart, even after the option is switched off.
local sparklesShown;
local applying = false;
local pendingAfterCombat = false;

local function IsEnabled()
	return db == nil or db.enabled ~= false;
end

local function SetAll(values)
	applying = true;
	for cvar, value in pairs(values) do
		local current = C_CVar.GetCVar(cvar);
		if current ~= nil and current ~= value then
			pcall(C_CVar.SetCVar, cvar, value);
		end
	end
	applying = false;
end

local function Apply()
	if not IsEnabled() then
		return;
	end
	if InCombatLockdown() then
		pendingAfterCombat = true;
		return;
	end
	SetAll(WANTED);
end

local applyAt;
local timerFrame = CreateFrame("Frame");
timerFrame:Hide();
timerFrame:SetScript("OnUpdate", function(self)
	if GetTime() >= applyAt then
		self:Hide();
		Apply();
	end
end);

local function ScheduleApply(delay)
	applyAt = GetTime() + delay;
	timerFrame:Show();
end

local function OnEnabledChanged(_, value)
	if value then
		sparklesShown = true;
		Apply();
	else
		pendingAfterCombat = false;
		timerFrame:Hide();
		SetAll(DISABLED);
	end
end

local function RegisterOptions()
	local category = Settings.RegisterVerticalLayoutCategory("Forever Loot Sparkles");

	local setting = Settings.RegisterAddOnSetting(category, "FOREVER_LOOT_SPARKLES_ENABLED", "enabled",
		db, Settings.VarType.Boolean, "Show quest item sparkles", Settings.Default.True);
	setting:SetValueChangedCallback(OnEnabledChanged);
	Settings.CreateCheckbox(category, setting,
		"Keeps the outline mode off and the loot sparkle on. Switching this off turns the sparkle off and the outline mode back to High. Switching it off takes effect after restarting the game.");

	-- Switching on works at once, but switching off only takes effect after a
	-- full game restart (/reload is not enough), so only that case gets a notice.
	local notice = CreateSettingsListSectionHeaderInitializer("|cffff8000Restart the game to remove the sparkles. /reload is not enough.|r");
	notice:AddShownPredicate(function()
		return sparklesShown and not IsEnabled();
	end);
	Settings.RegisterInitializer(category, notice);

	ns.AddSoftTargetOptions(category, db);

	Settings.RegisterAddOnCategory(category);
end

local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_REGEN_ENABLED");
pcall(frame.RegisterEvent, frame, "CVAR_UPDATE");
frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" then
		if arg1 == ADDON_NAME then
			self:UnregisterEvent("ADDON_LOADED");
			ForeverLootSparklesDB = ForeverLootSparklesDB or {};
			db = ForeverLootSparklesDB;
			RegisterOptions();
			sparklesShown = IsEnabled();
		end
	elseif event == "PLAYER_LOGIN" then
		Apply();
		ScheduleApply(5);
	elseif event == "PLAYER_REGEN_ENABLED" then
		if pendingAfterCombat then
			pendingAfterCombat = false;
			Apply();
		end
	elseif not applying and type(arg1) == "string" and WATCHED[strlower(arg1)] then
		ScheduleApply(1);
	end
end);
