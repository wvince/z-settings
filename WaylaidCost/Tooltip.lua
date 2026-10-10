local _, W = ...
local catalog = {}
local function normalize(name)
  return name:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("\194\160", " ")
    :gsub("’", "'"):gsub("%s+", " "):gsub("%s*:%s*", ": "):match("^%s*(.-)%s*$"):lower()
end
for _, crate in ipairs(WaylaidCostCrates) do catalog[normalize(crate.name)] = crate end
for _, writ in ipairs(WaylaidCostWrits) do catalog[normalize(writ.name)] = writ end

local function itemName(tooltip, data)
  local name, link
  if tooltip.GetItem then name, link = tooltip:GetItem() end
  if not name and data and data.id then
    local getInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
    if getInfo then name = getInfo(data.id) end
  end
  if not name and data and data.lines and data.lines[1] then name = data.lines[1].leftText end
  return type(name) == "string" and name or nil, link or (data and data.id)
end
local function price(value, estimated)
  return (estimated and "≈ " or "") .. W.Money(value)
end
function W.ShowTooltipExplanations()
  local mode = W.db and W.db.tooltipExplanations or "shift"
  return mode == "always" or (mode == "shift" and IsShiftKeyDown and IsShiftKeyDown())
end
local function addScanSource(tooltip, explanations, source)
  tooltip:AddLine(W.Text(" "))
  if source.auctionatorSource then
    tooltip:AddLine(W.Text(source.auctionatorSource == "mixed" and "Mixed prices; Auctionator estimates included" or "Auctionator estimate; stock unknown"), 1, 0.82, 0.45, true)
    return
  end
  if not source.scannedAt then
    tooltip:AddLine(W.Text("No saved scan. Open the AH and run Fast Scan or Full Scan."), 1, 0.68, 0.47, true)
    return
  end
  if explanations then
    tooltip:AddLine(W.Text(source.mode == "fast" and "Based on Fast Scan · estimates, quantities at each price not verified."
      or "Based on Full Scan · recorded prices and quantities."), 0.65, 0.74, 0.84, true)
  else
    tooltip:AddLine(W.Text(source.mode == "fast" and "Fast Scan · estimate, stock not verified" or "Full Scan · recorded prices"), 0.65, 0.74, 0.84)
  end
  if source.timeUnknown or source.scannedAt <= 0 then
    tooltip:AddLine(W.Text("Last scan: date unknown (recovered snapshot)."), 1, 0.68, 0.47, true)
  else
    local minutes = math.max(0, math.floor((time() - source.scannedAt) / 60))
    local age = minutes < 60 and (minutes .. " min") or (math.floor(minutes / 60) .. " h " .. minutes % 60 .. " min")
    tooltip:AddLine(W.Text("Last scan: " .. date("%Y-%m-%d %H:%M", source.scannedAt) .. " (local time)"), 0.65, 0.74, 0.84)
    if explanations or minutes >= 15 then
      tooltip:AddLine(W.Text(age .. " ago · prices may have changed."), minutes >= 15 and 1 or 0.65, 0.7, 0.5, true)
    end
  end
  if source.incomplete then tooltip:AddLine(W.Text("Incomplete snapshot: some prices or stock may be missing."), 1, 0.68, 0.47, true) end
end

-- Append our own section instead of replacing Blizzard's item description or
-- modifying lines owned by another addon. Never send auction requests here.
function W.AppendCrateTooltip(tooltip, data)
  if not W.db or W.db.itemTooltips == false or not tooltip or (tooltip.IsForbidden and tooltip:IsForbidden()) then return end
  local name, itemReference = itemName(tooltip, data)
  local id = type(itemReference) == "number" and itemReference
    or (type(itemReference) == "string" and tonumber(itemReference:match("item:(%d+)")))
    or (data and data.id)
  local crate = W.ordersByID[id] or (W.Locale() == "enUS" and name and catalog[normalize(name)])
  if not crate or (crate.kind == "writ" and not W.db.enableWrits) then return end
  local kind = crate.kind == "writ" and "writs" or "waylaid"
  local source
  if kind == (W.IsWritView() and "writs" or "waylaid") then
    source = {books = W.books, scannedAt = W.scannedAt, incomplete = W.incomplete,
      targeted = W.targeted, mode = W.scanMode, timeUnknown = W.scanTimeUnknown, auctionatorSource = W.auctionatorSource}
  else source = W.GetSnapshot(kind) or {books = {}} end
  if tooltip.__waylaidCostCrate then return end
  if not tooltip.__waylaidCostClearHook then
    tooltip.__waylaidCostClearHook = true
    hooksecurefunc(tooltip, "ClearLines", function() tooltip.__waylaidCostCrate = nil end)
  end
  tooltip.__waylaidCostCrate = crate.name

  local options, best = {}, nil
  for _, bundle in ipairs(crate.bundles) do
    local book = source.books[bundle[2]]
    local q = W.Quote(book, bundle[1], source.scannedAt, source.incomplete, source.targeted and book == nil)
    local option = {name = bundle[2], quantity = bundle[1], quote = q}
    options[#options + 1] = option
    if q.cost and (not best or q.cost < best.quote.cost) then best = option end
  end
  tooltip:AddLine(W.Text(" "))
  tooltip:AddLine(W.Text(crate.kind == "writ" and "WaylaidCost · requested goods only" or "WaylaidCost · materials only"), 1, 0.82, 0.45)
  if crate.kind ~= "writ" then
    -- Same-named crates can have different rarities and rewards. Resolve the
    -- hovered item itself, never a matching auction or a name-only lookup.
    local getInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
    local quality
    if getInfo and itemReference then
      local _, _, itemQuality = getInfo(itemReference)
      quality = itemQuality
    end
    local rewards = W.db.rewards and W.db.rewards[crate.family]
    local favor = quality and rewards and tonumber(rewards[quality])
    tooltip:AddDoubleLine(W.Text("Merchant's Favor (base)"),W.Text(favor and favor > 0 and ("+" .. favor)
      or (quality == nil and "Unknown rarity" or "Unknown / not set")), 0.85, 0.88, 0.94, 1, 0.82, 0.45)
  end
  local surplus, ownEstimate = false, false
  for _, option in ipairs(options) do
    local q = option.quote
    local text = option.quantity .. "× " .. W.ItemLabel(option.name)
    if option == best then text = "|cff1eff00" .. text .. "|r" end
    if q.cost then
      -- Whole auctions can require surplus units. Their average is computed
      -- over units actually purchased; Total always includes the whole stack.
      local units = q.purchased or q.required
      tooltip:AddDoubleLine(W.Text(text),W.Text(price(q.cost / units, q.estimated) .. " |cff9ca9b9" .. W.L("/ unit") .. "|r"), 0.85, 0.88, 0.94, 1, 1, 1)
      tooltip:AddDoubleLine(W.Text("  Total"),W.Text(price(q.cost, q.estimated)), 0.65, 0.74, 0.84, 1, 1, 1)
      if q.databaseEstimate then tooltip:AddLine(W.Text(W.Reason(q)), 0.7, 0.75, 0.82, true) end
      if q.extra and q.extra > 0 then
        surplus = true
        tooltip:AddLine(W.Text("  Whole stacks: " .. q.purchased .. " purchased, " .. q.extra .. " extra."), 0.7, 0.75, 0.82, true)
      end
      ownEstimate = ownEstimate or q.mayIncludeOwn
    else
      tooltip:AddDoubleLine(W.Text(text),W.Text("— / unit"), 0.85, 0.88, 0.94, 0.7, 0.75, 0.82)
      tooltip:AddLine(W.Text("  " .. W.Reason(q)), 1, 0.68, 0.47, true)
    end
  end
  local explanations = W.ShowTooltipExplanations()
  if explanations then
    tooltip:AddLine(W.Text(" "))
    if crate.kind ~= "writ" then tooltip:AddLine(W.Text("Favor uses your configured tier and rarity reward; bonuses are excluded."), 0.65, 0.74, 0.84, true) end
    if best and crate.kind ~= "writ" then tooltip:AddLine(W.Text("Green = cheapest priced filling option. Crate purchase not included."), 0.65, 0.74, 0.84, true) end
    tooltip:AddLine(W.Text(surplus and "Unit averages use purchased quantities; totals include surplus units."
      or "Unit averages are rounded up for display; totals use unrounded prices."), 0.65, 0.74, 0.84, true)
  end
  if ownEstimate then tooltip:AddLine(W.Text("Summary stock includes your auctions; purchasable prices are not verified."), 1, 0.68, 0.47, true) end
  if crate.kind == "writ" then W.AddWritDetails(tooltip, crate, false, explanations) end
  addScanSource(tooltip, explanations, source)
  if not explanations and W.db.tooltipExplanations == "shift" then
    tooltip:AddLine(W.Text("Hold Shift and hover again for explanations"), 0.55, 0.61, 0.7)
  end
end

function W.InitItemTooltips()
  if W.itemTooltipsInitialized then return end
  W.itemTooltipsInitialized = true
  -- Read Shift during Blizzard's own tooltip population. Forcing a rebuild
  -- from an addon event re-enters native tooltip processing in addon context;
  -- SetHyperlink also replaces the original bag/slot context. Leave both alone.
  if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
      if tooltip == GameTooltip or tooltip == ItemRefTooltip then W.AppendCrateTooltip(tooltip, data) end
    end)
  else
    for _, name in ipairs({"GameTooltip", "ItemRefTooltip"}) do
      local tooltip = _G[name]
      if tooltip and tooltip.HookScript and tooltip.HasScript and tooltip:HasScript("OnTooltipSetItem") then
        tooltip:HookScript("OnTooltipSetItem", function(self) W.AppendCrateTooltip(self) end)
      end
    end
  end
end
