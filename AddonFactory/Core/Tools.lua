--[[
This file contains a list of tools that help interact with Blizzard's add-on features.
Ex: Key bindings, add-on compartment, slash commands, etc..
--]]

local addonName, addon = ...
_G[addonName] = addon

-- One empty function to rule them all
addon.EmptyFunc = function() end
addon.TrueFunc = function() return true end
addon.FalseFunc = function() return false end

-- Add support for an addon's binding to a key
function addon:AddKeyBinding(prefix, name, description)
	-- Reminder: binding is done in bindings.xml !!
	
	_G[format("BINDING_HEADER_%s", prefix)] = name
	_G[format("BINDING_NAME_%s_TOGGLE", prefix)] = description
end

-- Add support for an addon's shortcut in Blizzard's Add-on Compartment
function addon:AddToAddonCompartment(prefix, data)
	--[[
			https://wowpedia.fandom.com/wiki/Addon_compartment
			
			Do not forget to match this with the names in the .toc :
			
## AddonCompartmentFunc: <prefix>_OnAddonCompartmentClick
## AddonCompartmentFuncOnEnter: <prefix>_OnAddonCompartmentEnter
## AddonCompartmentFuncOnLeave: <prefix>_OnAddonCompartmentLeave
	--]]
	
	
	if prefix and data then 
		if data.Click then
			_G[format("%s_OnAddonCompartmentClick", prefix)] = data.Click
		end
		
		if data.Enter then
			_G[format("%s_OnAddonCompartmentEnter", prefix)] = data.Enter
		end
		
		if data.Leave then
			_G[format("%s_OnAddonCompartmentLeave", prefix)] = data.Leave
		end
	end
end

-- Create a new options table if it does not exist, with default values (if any)
function addon:SetOptionsTable(tableName, defaultValues)
	-- Create the table if it does not exist yet
	_G[tableName] = _G[tableName] or {}

	local t = _G[tableName]
	
	-- if we have default values, apply them.
	if defaultValues then
		for k, value in pairs(defaultValues) do
			if type(t[k]) == "nil" then		-- if this option does not exist yet in the table ..
				t[k] = value						-- .. then assign the default value
			end
		end
	end
	
	return t
end

-- Register a slash command
function addon:RegisterChatCommand(command, callback)
	_G[ format("SLASH_%s1", command)] = format("/%s", command:lower())
	SlashCmdList[command] = callback
end

-- Hook a simple method
function addon:InstallMethodHook(widget, method, preHook, postHook)
	local orig = widget[method]
	
	local stub = function(...)
		if preHook then preHook(...) end
		
		local a,b,c,d,e,f,g,h,i,j,k = orig(...)
		if postHook then postHook(...) end
		
		return a,b,c,d,e,f,g,h,i,j,k
	end
	
	widget[method] = stub
end



-- ** Table pool **
local tablePool = {}

--[[ Example usage

-- Get a table from the pool
local myTable = AddonFactory:GetTable()
myTable[1] = "Hello"
myTable[2] = "World"

-- Use the table...
-- Release the table back to the pool
AddonFactory:ReleaseTable(myTable)

--]] 

function addon:GetTable()
	-- Get a table from the pool or create a new one if the pool is empty
    return #tablePool > 0 and table.remove(tablePool) or {}
end

-- Return a table to the pool
function addon:ReleaseTable(t)
    wipe(t)
    table.insert(tablePool, t)
end


-- ** Character Identification **
function addon:GetPlayerName()
	local firstName, lastName = UnitName("player")

	-- For Mailine, just return the first name
	-- For Forever, return "firstName lastName"
	return lastName and format("%s %s", firstName, lastName) or firstName
end


-- ** Build Identification **
local version = select(4, GetBuildInfo())
addon.buildVersion = version

if version >= 60000 then
	addon.isRetail = true			-- retail = actual retail version
	addon.isMainline = true			-- mainline = mainline client, shared between retail & forever
elseif version >= 50000 then
	addon.isMists = true
elseif version >= 40000 then
	addon.isCata = true
elseif version >= 30000 then
	addon.isWotLK = true
elseif version >= 20000 then
	addon.isTBC = true
elseif version >= 16000 and version < 20000 then
	addon.isForever = true
	addon.isMainline = true
else
	addon.isClassic = true
end


function addon:GetAddOnVersionInfo(name)

	--[[ 
		Provides :
			addon.Version = "v12.0.001"
			--addon.VersionNum = 11 00 007
			addon.VersionNum = 1200000
		
		Usage :
			addon.Version, addon.VersionNum = AddonFactory:GetAddOnVersionInfo(addonName)
	]]

	local version = C_AddOns.GetAddOnMetadata(name, "Version")
	local v1, v2, v3, vBeta = string.match(version, "(%d+).(%d+).(%d+)-*(.*)")
	
	return format("v%s", version), format("%d%02d%03d", v1, v2, v3, vBeta or "")
end
