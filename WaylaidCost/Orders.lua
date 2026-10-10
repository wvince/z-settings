local _, W = ...

function W.IsWritView()
  return W.db and W.db.enableWrits and W.db.orderKind == "writs"
end
function W.GetCatalog()
  return W.IsWritView() and WaylaidCostWrits or WaylaidCostCrates
end
function W.OrderName(order)
  if W.Locale() ~= "enUS" then
    return W.ItemLabel(order.kind == "writ" and order.bundles[1][2] or order.name)
  end
  return order.name:gsub("^Waylaid Crate: ", ""):gsub("^Craftsman's Writ: ", "")
end
function W.Reputation(order)
  local faction = UnitFactionGroup and UnitFactionGroup("player")
  local id = faction == "Horde" and 2587 or (faction == "Alliance" and 2586)
  if not id then return nil, "Trade faction" end
  for _, reward in ipairs(order.reputation or {}) do
    if reward[1] == id then
      local data = C_Reputation and C_Reputation.GetFactionDataByID and C_Reputation.GetFactionDataByID(id)
      local name = data and data.name or (GetFactionInfoByID and GetFactionInfoByID(id))
      return reward[2], name or (id == 2587 and "Durotar Supply and Logistics" or "Azeroth Commerce Authority")
    end
  end
end
function W.GetSnapshot(kind)
  local saved = W.db and W.db.snapshots and W.db.snapshots[kind]
  if not saved and W.db and W.db.lastSnapshot and (W.db.lastSnapshot.kind or "waylaid") == kind then saved = W.db.lastSnapshot end
  if type(saved) == "table" and (saved.schema == 1 or saved.schema == 2) and saved.key == W.scanKey
    and (saved.kind or "waylaid") == kind and W.SnapshotLocaleMatches(saved)
    and type(saved.books) == "table" and type(saved.scannedAt) == "number" then return saved end
end
function W.LoadSnapshot()
  local saved = W.GetSnapshot(W.IsWritView() and "writs" or "waylaid")
  if saved then
    W.db.snapshots = W.db.snapshots or {}
    W.db.snapshots[saved.kind or "waylaid"] = saved
  end
  W.books = saved and saved.books or {}
  W.scannedAt = saved and saved.scannedAt or nil
  W.incomplete = saved and saved.incomplete or false
  W.scanTimeUnknown = saved and saved.timeUnknown or false
  W.targeted = saved and saved.targeted or false
  W.scanMode = saved and saved.mode == "fast" and "fast" or "full"
  W.auctionatorSource = nil
  if W.UseAuctionatorPrices then W.UseAuctionatorPrices(saved) end
  W.message = nil; W.scanError = false
end

function W.AuctionatorAPI()
  return Auctionator and Auctionator.API and Auctionator.API.v1
end

-- Optional compatibility adapter: Auctionator's public price age has only day
-- precision. Its completed summary/replicate scans supply observed items.
-- Keep only our catalog IDs, using public prices; never read or modify its DB.
function W.RegisterAuctionatorScanListener()
  local bus = Auctionator and Auctionator.EventBus
  if not bus or type(bus.Register) ~= "function" then return end
  local pending, seen = {}, W.auctionatorScanEvents or {}
  for _, scan in ipairs({"FullScan", "IncrementalScan"}) do
    local object = Auctionator[scan]
    local event = object and object.Events and object.Events.ScanComplete
    if type(event) == "string" and not seen[event] then pending[#pending + 1] = event end
  end
  if #pending == 0 then return end
  local listener = W.auctionatorListener or {}
  function listener:ReceiveEvent(_, rows)
    local api = W.AuctionatorAPI()
    if not W.db or not api or not api.GetAuctionPriceByItemID or type(rows) ~= "table" then return end
    local wanted, observations = {}, {}
    for _, catalog in ipairs({WaylaidCostCrates, WaylaidCostWrits}) do
      for _, order in ipairs(catalog) do
        wanted[order.itemID] = true
        for _, bundle in ipairs(order.bundles) do
          local id = W.itemIDs[bundle[2]]
          if id then wanted[id] = true end
        end
      end
    end
    local stamp = time()
    for _, row in ipairs(rows) do
      local info = type(row) == "table" and (row.replicateInfo or row.auctionInfo)
      local id, count, buyout
      if type(info) == "table" then
        id, count, buyout = info[17], info[3], info[10]
      elseif type(row) == "table" and type(row.itemKey) == "table" then
        id, count, buyout = row.itemKey.itemID, row.totalQuantity, row.minPrice
      end
      if wanted[id] and type(count) == "number" and count > 0
        and type(buyout) == "number" and buyout > 0 then
        local ok, price = pcall(api.GetAuctionPriceByItemID, "WaylaidCost", id)
        if ok and type(price) == "number" and price > 0 and price < math.huge then
          observations[id] = {price = price, scannedAt = stamp}
        end
      end
    end
    W.db.auctionatorObservations = {key = W.scanKey, items = observations}
    if not W.scanning then W.LoadSnapshot(); W.Refresh() end
  end
  local ok = pcall(bus.Register, bus, listener, pending)
  if ok then
    W.auctionatorListener, W.auctionatorScanEvents = listener, seen
    for _, event in ipairs(pending) do seen[event] = true end
  end
end

function W.UseAuctionatorPrices(saved)
  local api = W.AuctionatorAPI()
  if not W.db or W.db.auctionatorPrices == false or W.scanning
    or not api or not api.GetAuctionPriceByItemID then return end
  local books, seen, found = {}, {}, false
  if saved then for name, book in pairs(saved.books) do books[name] = book end end
  local function add(name, id, quality)
    if not id or seen[name] then return end
    seen[name] = true
    if not saved then books[name] = {databaseMissing = true, {quality = quality, itemID = id}} end
    local ok, price = pcall(api.GetAuctionPriceByItemID, "WaylaidCost", id)
    if not ok or type(price) ~= "number" or price <= 0 or price >= math.huge then return end
    local age
    if api.GetAuctionAgeByItemID then
      local success, value = pcall(api.GetAuctionAgeByItemID, "WaylaidCost", id)
      if success and type(value) == "number" and value >= 0 then age = value end
    end
    -- Age is an integer day bucket, not a timestamp. Only replace a saved
    -- observation when even the oldest possible database observation is newer.
    -- This deliberately keeps the scan when freshness is ambiguous.
    local recorded = W.db.auctionatorObservations
    local observation = recorded and recorded.key == W.scanKey and recorded.items and recorded.items[id]
    local observedNewer = observation and observation.price == price
      and type(observation.scannedAt) == "number" and observation.scannedAt <= time()
      and saved and observation.scannedAt > saved.scannedAt
    if saved and not observedNewer and (saved.timeUnknown or saved.scannedAt <= 0 or not age
      or time() - saved.scannedAt <= (age + 1) * 86400) then return end
    books[name] = {databasePrice = price, ageDays = age,
      {quality = quality, itemID = id}}
    found = true
  end
  for _, order in ipairs(W.GetCatalog()) do
    add(order.name, order.itemID, order.quality)
    for _, bundle in ipairs(order.bundles) do add(bundle[2], W.itemIDs[bundle[2]]) end
  end
  if found then
    W.books, W.scannedAt, W.scanMode = books, saved and saved.scannedAt or 0, "fast"
    W.auctionatorSource, W.scanTimeUnknown = saved and "mixed" or true, not saved
    W.incomplete, W.targeted = false, false
  end
end

function W.AuctionatorSourceLabel()
  return W.auctionatorSource == "mixed" and "Mixed prices; Auctionator estimates included" or "Auctionator estimate; stock unknown"
end

function W.AuctionatorShoppingAvailable()
  local api = W.AuctionatorAPI()
  return W.db and W.db.auctionatorSearch ~= false and api and api.MultiSearchAdvanced
end

function W.SearchAuctionator(items)
  if not W.AuctionatorShoppingAvailable() or not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then return false end
  local terms = {}
  for _, item in ipairs(items) do
    local name = W.LocalItemName(item.name)
    if not name then
      local id = W.itemIDs[item.name]
      if id and C_Item and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(id) end
      return false
    end
    terms[#terms + 1] = {searchString = name, isExact = true, quantity = item.quantity or 1,
      quality = item.quality and item.quality > 0 and item.quality or nil}
  end
  W.CancelScan("Scan stopped: opened Buy search")
  GameTooltip:Hide()
  local ok = pcall(W.AuctionatorAPI().MultiSearchAdvanced, "WaylaidCost", terms)
  return ok
end
function W.SetOrderKind(kind)
  if not W.db then return end
  if kind == "writs" and not W.db.enableWrits then return end
  kind = kind == "writs" and "writs" or "waylaid"
  if W.db.orderKind == kind then return end
  W.CancelScan("Scan stopped: changed order type")
  W.db.orderKind = kind
  W.LoadSnapshot()
  if W.panel then W.panel.expanded = {}; W.panel.scroll:SetVerticalScroll(0) end
  W.Refresh()
end

function W.InitRewardDefaults()
  W.db.rewards = W.db.rewards or {}
  if (W.db.rewardDataVersion or 0) >= 3 then return end
  if W.db.rewardDataVersion ~= 2 then
  local defaults = {Apprentice = {[1]=5,[2]=10}, Journeyman = {[1]=10,[2]=20}, Expert = {}, Artisan = {}}
  for family, values in pairs(defaults) do
    local old = W.db.rewards[family]
    -- Replace the old shipped 5/20 assumption; preserve other user-entered values.
    if not old or (old[1] == 5 and old[2] == 20) then W.db.rewards[family] = values end
  end
  end
  -- Owner-tested on 4 Oct 2026. Fill previously unknown Expert rewards only.
  local expert = W.db.rewards.Expert or {}
  W.db.rewards.Expert = expert
  if expert[1] == nil then expert[1] = 15 end
  if expert[2] == nil then expert[2] = 30 end
  W.db.rewardDefaultsInitialized = true
  W.db.rewardDataVersion = 3
end

function W.WritIsActive(order)
  return order.questID and C_QuestLog and C_QuestLog.IsOnQuest and C_QuestLog.IsOnQuest(order.questID)
end
function W.OpenWritQuest(order)
  if not W.WritIsActive(order) then return end
  if QuestMapFrame_OpenToQuestDetails then QuestMapFrame_OpenToQuestDetails(order.questID)
  elseif ShowQuestLog then ShowQuestLog() end
end
function W.WritDestination(order)
  local first = order.turnIns and order.turnIns[1]
  if first then return first.npc .. " · " .. W.L(first.zone) end
  return W.WritIsActive(order) and "Destination: see the quest log" or "Destination: see quest details"
end
function W.AddWritDetails(tooltip, order, includeWrit, explanations)
  local reputation, faction = W.Reputation(order)
  tooltip:AddLine(W.Text(" "))
  tooltip:AddDoubleLine(W.Text("Base reputation"),W.Text(reputation and (reputation .. " · " .. faction) or "Unknown"), 1, 0.82, 0.45, 0.8, 0.88, 1)
  if order.turnIns and #order.turnIns > 0 then
    tooltip:AddLine(W.Text("Delivery (beta data)"), 1, 0.82, 0.45)
    for _, place in ipairs(order.turnIns) do
      local coord = place.coord and string.format(" (%.1f, %.1f)", place.coord[1], place.coord[2]) or ""
      tooltip:AddLine(W.Text(place.npc .. " · " .. W.L(place.zone) .. coord), 0.85, 0.88, 0.94, true)
    end
  else
    tooltip:AddLine(W.Text(W.WritDestination(order)), 0.85, 0.88, 0.94, true)
  end
  local observed = W.db.writRewards and W.db.writRewards[order.questID]
  if observed and (observed.key ~= W.scanKey or not W.SnapshotLocaleMatches(observed)) then observed = nil end
  if observed then
    tooltip:AddLine(W.Text("Rewards last shown by your quest"), 1, 0.82, 0.45)
    if observed.money and observed.money > 0 then tooltip:AddDoubleLine(W.Text("Money"),W.Text(W.Money(observed.money)), 0.85, 0.88, 0.94, 1, 1, 1) end
    for _, reward in ipairs(observed.items or {}) do tooltip:AddLine(W.Text(reward), 0.85, 0.88, 0.94, true) end
    if not observed.money or observed.money == 0 then
      if #(observed.items or {}) == 0 then tooltip:AddLine(W.Text("Payment not shown; check the quest reward screen."), 0.7, 0.75, 0.82, true) end
    end
    tooltip:AddLine(W.Text("Observed: " .. date("%Y-%m-%d %H:%M", observed.at)), 0.55, 0.61, 0.7)
  else
    tooltip:AddLine(W.Text("Payment: check the quest reward screen; not yet recorded."), 0.7, 0.75, 0.82, true)
  end
  if explanations ~= false then
    tooltip:AddLine(W.Text(includeWrit == false and "Requested goods only; writ purchase is excluded. Payment is not deducted."
      or "Totals include the writ and requested goods. Payment is not deducted."), 0.65, 0.74, 0.84, true)
    tooltip:AddLine(W.Text("Base beta reputation; faction bonuses are not included. Check the quest for its deadline."), 0.65, 0.74, 0.84, true)
  end
end

local byQuest = {}
for _, order in ipairs(WaylaidCostWrits) do byQuest[order.questID] = order end
local quests = CreateFrame("Frame")
quests:RegisterEvent("QUEST_DETAIL")
quests:RegisterEvent("QUEST_COMPLETE")
quests:RegisterEvent("QUEST_LOG_UPDATE")
quests:SetScript("OnEvent", function(_, event)
  if not W.db or not W.db.enableWrits then return end
  if event == "QUEST_LOG_UPDATE" then
    if W.panel and W.panel:IsShown() and W.IsWritView() then W.Draw() end
    return
  end
  local id = GetQuestID and GetQuestID()
  if not byQuest[id] then return end
  local items = {}
  if GetQuestItemInfo then
    for _, kind in ipairs({{"reward", GetNumQuestRewards}, {"choice", GetNumQuestChoices}}) do
      for i = 1, (kind[2] and kind[2]() or 0) do
        local name, _, quantity = GetQuestItemInfo(kind[1], i)
        if not name then return end
        items[#items + 1] = (kind[1] == "choice" and "Choice: " or "") .. (quantity or 1) .. "× " .. name
      end
    end
  end
  W.db.writRewards = W.db.writRewards or {}
  W.db.writRewards[id] = {money = GetRewardMoney and GetRewardMoney() or nil, items = items, at = time(), key = W.scanKey, locale = W.Locale()}
end)
