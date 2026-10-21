-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSLoot = private.NewLib("RareScannerLoot")

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSLootDB = private.ImportLib("RareScannerLootDB")
local RSCollectionsDB = private.ImportLib("RareScannerCollectionsDB")
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")

-- RareScanner general libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSConstants = private.ImportLib("RareScannerConstants")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTooltipScanners = private.ImportLib("RareScannerTooltipScanners")

---============================================================================
-- Filters to apply to the loot displayed under the main button and the worldmap
---============================================================================

local function IsToy(itemLink, itemID)
	if (RSLootDB.IsToy(itemID)) then
		return true
	elseif (RSTooltipScanners.ScanLoot(itemLink, TOY)) then
		RSLootDB.SetItemAsToy(itemID)
		return true
	end
end

local function IsFilteredByCategory(itemLink, itemID, itemClassID, itemSubClassID)
	-- If filtered by category
	if (RSConfigDB.GetLootFilterByCategory(itemClassID, itemSubClassID) == false) then
		-- We ignore toys from this filter because they are scattered all around
		if (IsToy(itemLink, itemID)) then
			return false
		end
		
		return true
	end
	
	return false
end

local function IsCollectionFiltered(type, entityID, itemID)
	local items = RSCollectionsDB.GetEntityCollectionsLoot(entityID, type)
	if (RSUtils.Contains(items, itemID)) then
		return false
	end
	
	RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por estar ya conseguido o estar filtrado en el explorador", itemID))
	return true
end

function RSLoot.IsFiltered(entityID, itemID, itemLink, itemRarity, itemEquipLoc, itemClassID, itemSubClassID)
	-- Quality filter
	if (itemRarity < tonumber(RSConfigDB.GetLootFilterMinQuality())) then
		RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por su calidad.", itemID))
		return true
	end
	
	-- Individual filter
	if (RSConfigDB.GetItemFiltered(itemID)) then
		RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado individualmente.", itemID))
		return true
	end

	-- Drop chance filter (items without a known drop chance count as 0%)
	local minChance = RSConfigDB.GetLootFilterMinChance()
	local maxChance = RSConfigDB.GetLootFilterMaxChance()
	if (minChance or maxChance) then
		local chances = RSNpcDB.GetNpcLootChance(entityID) or RSContainerDB.GetContainerLootChance(entityID)
		local chance = tonumber(chances and chances[itemID]) or 0
		if ((minChance and chance < minChance) or (maxChance and chance > maxChance)) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por su probabilidad de drop.", itemID))
			return true
		end
	end

	-- Equipable filter
	if (RSConfigDB.IsFilteringLootByNotEquipableItems() and not C_Item.IsEquippableItem(itemID)) then
		RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por no ser equipable.", itemID))
		return true;
	end
	
	-- Usable filter (any requirement not met except the level, like class, faction, profession, reputation, armor or weapon type...)
	if (RSConfigDB.IsFilteringLootByNotUsable() and not RSTooltipScanners.GetItemRestrictions(itemID).isUsable) then
		RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por no poder usarlo.", itemID))
		return true;
	end
	
	-- Filter by explorer results
	if (RSConfigDB.IsFilteringByExplorerResults() and RSUtils.GetTableLength(RSCollectionsDB.GetAllEntitiesCollectionsLoot()) > 0) then
		return IsCollectionFiltered(RSConstants.ITEM_SOURCE.NPC, entityID, itemID) and IsCollectionFiltered(RSConstants.ITEM_SOURCE.CONTAINER, entityID, itemID)
	end

	-- Category filter
	if (not RSConfigDB.IsFilteringByExplorerResults() and IsFilteredByCategory(itemLink, itemID, itemClassID, itemSubClassID)) then
		RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por su categoria.", itemID))
		return true
	end
	
	return false
end
