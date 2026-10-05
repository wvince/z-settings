local _, W = ...
-- One user-started, sequential search session. No purchases, replication or
-- background refresh. All callbacks are tied to their session and operation.
local active, internalRequest, hooked
local searchTimes = {}
local function trimSearchTimes()
  while searchTimes[1] and GetTime() - searchTimes[1] >= 60.1 do table.remove(searchTimes, 1) end
end
local function normalize(name)
  return name:gsub("\194\160", " "):gsub("’", "'"):gsub("%s+", " "):gsub("%s*:%s*", ": "):match("^%s*(.-)%s*$"):lower()
end
local function keyID(key)
  return table.concat({key.itemID or 0, key.itemLevel or 0, key.itemSuffix or 0, key.battlePetSpeciesID or 0}, ":")
end
local function status(s, text)
  if active ~= s then return end
  W.message = text
  W.Draw()
end
local function finish(s, errorText)
  if active ~= s then return end
  active = nil; W.scanning = false; W.runningMode = nil
  W.scanError = errorText ~= nil
  if errorText then
    W.message = errorText .. (W.scannedAt and " · Previous snapshot kept." or " · No new snapshot saved.")
  else
    W.books, W.scannedAt, W.targeted = s.books, time(), true
    W.scanMode = s.scanMode
    W.incomplete, W.scanTimeUnknown = false, false
    W.message = string.format("%d orders · %d goods · %d requests · %.1f s", s.crateCount, #s.materials, s.requests, GetTime() - s.started)
    W.db.lastSnapshot = {schema = 2, key = W.scanKey, locale = W.Locale(), books = W.books, scannedAt = W.scannedAt, targeted = true, mode = W.scanMode, kind = s.kind}
    W.db.snapshots = W.db.snapshots or {}
    W.db.snapshots[s.kind] = W.db.lastSnapshot
  end
  W.Refresh()
end
function W.CancelScan(reason)
  if active then finish(active, reason or "Scan stopped") end
end
local function operation(s, text)
  s.operation = {}; s.waiting = false; s.pending = nil
  s.deadline = GetTime() + 45
  local op = s.operation
  status(s, text)
  local function watchdog()
    if active ~= s or s.operation ~= op then return end
    local remaining = s.deadline - GetTime()
    if remaining > 0 then C_Timer.After(remaining, watchdog)
    else finish(s, "Incomplete auction response or timeout: " .. text) end
  end
  C_Timer.After(45, watchdog)
  return op
end
local function request(s, fn, search)
  local op = s.operation
  local pending = {}; s.pending = pending
  local polling = false
  local function send()
    if active ~= s or s.operation ~= op or s.pending ~= pending then return end
    local api = C_AuctionHouse
    trimSearchTimes()
    local delay = search and #searchTimes >= 100 and math.max(0.01, searchTimes[1] + 60.1 - GetTime()) or 0
    if delay > 0 or not api.IsThrottledMessageSystemReady() then
      if delay > 0 then
        s.deadline = math.max(s.deadline, GetTime() + delay + 45)
        status(s, "Full Scan · search limit reached, resuming in " .. math.ceil(delay) .. " s")
      end
      if not polling then
        polling = true
        C_Timer.After(delay > 0 and delay or 0.1, function() polling = false; send() end)
      end
      return
    end
    s.pending = nil; s.waiting = true; s.deadline = GetTime() + 45
    s.requests = s.requests + 1
    if search then searchTimes[#searchTimes + 1] = GetTime() end
    internalRequest = true
    local ok = pcall(fn)
    internalRequest = false
    if not ok and active == s then finish(s, "The auction house rejected the search") end
  end
  pending.send = send
  send()
end
local function browse(s, text, wanted, done, classID)
  local op = operation(s, text)
  s.mode, s.browseEntries, s.browseSeen = "browse", {}, {}
  s.browseDone = function()
    -- Item key metadata can arrive after the browse results. Missing metadata
    -- is never interpreted as an absent item or an unknown commodity mode.
    local function resolve()
      if active ~= s or s.operation ~= op then return end
      local matches = {}
      for _, entry in ipairs(s.browseEntries) do
        -- In localized clients only verified IDs can match. Unrelated auction
        -- metadata must not stall a scan that browses without an English prefix.
        if W.Locale() == "enUS" or wanted[entry.itemKey.itemID] then
          local info = C_AuctionHouse.GetItemKeyInfo(entry.itemKey)
          if not info or not info.itemName or type(info.isCommodity) ~= "boolean" or not info.quality then
            C_Timer.After(0.2, resolve); return
          end
          local name = wanted[entry.itemKey.itemID] or (W.Locale() == "enUS" and wanted[normalize(info.itemName)])
          if name then matches[#matches + 1] = {key = entry.itemKey, info = info, name = name, summary = entry} end
        end
      end
      s.mode = nil
      done(matches)
    end
    resolve()
  end
  request(s, function()
    C_AuctionHouse.SendBrowseQuery({searchString = text, sorts = {}, filters = {}, itemClassFilters = classID and {{classID = classID}} or {}})
  end)
end
local function searchKeys(s, matches, done)
  local index = 0
  local function nextKey()
    if active ~= s then return end
    index = index + 1
    local match = matches[index]
    if not match then done(); return end
    local current = s.phase == "Orders" and index or s.completed + 1
    operation(s, s.phase .. " " .. current .. "/" .. s.total .. " · " .. match.name)
    s.mode, s.match, s.searchDone = "search", match, nextKey
    request(s, function() C_AuctionHouse.SendSearchQuery(match.key, {}, true) end, true)
  end
  nextKey()
end
local function searchResponse(s)
  local api, match = C_AuctionHouse, s.match
  if not api.HasSearchResults(match.key) then return end
  local commodity, id = match.info.isCommodity, match.key.itemID
  local full = commodity and api.HasFullCommoditySearchResults(id) or (not commodity and api.HasFullItemSearchResults(match.key))
  s.waiting = false
  if not full then
    request(s, function()
      if commodity then api.RequestMoreCommoditySearchResults(id) else api.RequestMoreItemSearchResults(match.key) end
    end)
    return
  end
  local count = commodity and api.GetNumCommoditySearchResults(id) or api.GetNumItemSearchResults(match.key)
  local book = s.books[match.name]
  for i = 1, count do
    local result
    if commodity then result = api.GetCommoditySearchResultInfo(id, i) else result = api.GetItemSearchResultInfo(match.key, i) end
    if not result or not result.quantity or result.quantity <= 0 or (commodity and not result.unitPrice) then
      finish(s, "Price or quantity not loaded: " .. match.name); return
    end
    -- numOwnerItems allows an aggregated commodity price level to contain
    -- both the player's units and other sellers' units.
    local ownCount = commodity and math.min(result.quantity, result.numOwnerItems or 0) or 0
    local own = result.containsOwnerItem or result.containsAccountItem or false
    local function add(quantity, isOwn)
      if quantity <= 0 then return end
      book[#book + 1] = {count = quantity, buyout = commodity and result.unitPrice * quantity or (result.buyoutAmount or 0),
        quality = match.info.quality, itemID = id, icon = match.info.iconFileID, own = isOwn, isCommodity = commodity}
    end
    if commodity and ownCount > 0 and not result.containsAccountItem then
      add(ownCount, true); add(result.quantity - ownCount, false)
    else add(result.quantity, own) end
  end
  s.mode = nil; s.searchDone()
end
local events = CreateFrame("Frame")
for _, event in ipairs({"AUCTION_HOUSE_BROWSE_RESULTS_UPDATED", "AUCTION_HOUSE_BROWSE_RESULTS_ADDED", "AUCTION_HOUSE_BROWSE_FAILURE",
  "COMMODITY_SEARCH_RESULTS_UPDATED", "COMMODITY_SEARCH_RESULTS_ADDED", "ITEM_SEARCH_RESULTS_UPDATED", "ITEM_SEARCH_RESULTS_ADDED",
  "AUCTION_HOUSE_THROTTLED_MESSAGE_DROPPED", "AUCTION_HOUSE_THROTTLED_SYSTEM_READY"}) do events:RegisterEvent(event) end
events:SetScript("OnEvent", function(_, event, payload)
  local s = active
  if s and event == "AUCTION_HOUSE_THROTTLED_SYSTEM_READY" and s.pending then s.pending.send(); return end
  if not s or not s.waiting then return end
  if event == "AUCTION_HOUSE_THROTTLED_MESSAGE_DROPPED" or (s.mode == "browse" and event == "AUCTION_HOUSE_BROWSE_FAILURE") then
    finish(s, "Search rejected by the auction house; try again later"); return
  end
  if s.mode == "browse" and (event == "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" or event == "AUCTION_HOUSE_BROWSE_RESULTS_ADDED") then
    local results = event == "AUCTION_HOUSE_BROWSE_RESULTS_ADDED" and payload or C_AuctionHouse.GetBrowseResults()
    for _, entry in ipairs(results or {}) do
      local id = keyID(entry.itemKey)
      if not s.browseSeen[id] then s.browseSeen[id] = true; s.browseEntries[#s.browseEntries + 1] = entry end
    end
    s.waiting = false
    if C_AuctionHouse.HasFullBrowseResults() then s.browseDone()
    else request(s, function() C_AuctionHouse.RequestMoreBrowseResults() end) end
  elseif s.mode == "search" then
    local commodity = s.match.info.isCommodity
    if commodity and (event == "COMMODITY_SEARCH_RESULTS_UPDATED" or event == "COMMODITY_SEARCH_RESULTS_ADDED") and payload == s.match.key.itemID then
      searchResponse(s)
    elseif not commodity and (event == "ITEM_SEARCH_RESULTS_UPDATED" or event == "ITEM_SEARCH_RESULTS_ADDED") and type(payload) == "table" and keyID(payload) == keyID(s.match.key) then
      searchResponse(s)
    end
  end
end)
local function addEstimates(s, matches)
  for _, match in ipairs(matches) do
    local summary = match.summary
    if type(summary.minPrice) ~= "number" or type(summary.totalQuantity) ~= "number" then
      finish(s, "Incomplete auction summary: " .. match.name); return false
    end
    local book = s.books[match.name]
    book[#book + 1] = {count = summary.totalQuantity, minPrice = summary.minPrice,
      quality = match.info.quality, itemID = match.key.itemID, icon = match.info.iconFileID,
      containsOwnerItem = summary.containsOwnerItem, isCommodity = match.info.isCommodity}
  end
  return true
end
local function fullMaterials(s)
  if #s.materials == 0 then finish(s); return end
  local names = {}
  for _, name in ipairs(s.materials) do
    names[normalize(name)] = name
    if W.itemIDs[name] then names[W.itemIDs[name]] = name end
  end
  browse(s, "", names, function(matches)
    local keysByName = {}
    for _, match in ipairs(matches) do
      local keys = keysByName[match.name] or {}
      keysByName[match.name] = keys
      keys[#keys + 1] = match
    end
    local function nextMaterial()
      if active ~= s then return end
      local name = s.materials[s.completed + 1]
      if not name then finish(s); return end
      local function verify(keys)
        searchKeys(s, keys, function() s.completed = s.completed + 1; nextMaterial() end)
      end
      if keysByName[name] then
        verify(keysByName[name])
      else
        -- Category absence is not global absence: check other categories too.
        local wanted = {[normalize(name)] = name}
        if W.itemIDs[name] then wanted[W.itemIDs[name]] = name end
        browse(s, s.localizedNames[name] or name, wanted, verify)
        status(s, "Materials " .. (s.completed + 1) .. "/" .. s.total .. " · " .. name)
      end
    end
    nextMaterial()
  end, Enum and Enum.ItemClass and Enum.ItemClass.Tradegoods or 7)
  status(s, "Full Scan · locating Trade Goods")
end
local function fastMaterials(s)
  if #s.materials == 0 then finish(s); return end
  local names, found = {}, {}
  for _, name in ipairs(s.materials) do
    names[normalize(name)] = name
    if W.itemIDs[name] then names[W.itemIDs[name]] = name end
  end
  -- One category summary instead of a separate detailed search per material.
  -- Items outside Trade Goods (and missing items) get an exact-name fallback.
  browse(s, "", names, function(matches)
    if not addEstimates(s, matches) then return end
    for _, match in ipairs(matches) do found[match.name] = true end
    local index = 0
    local function missing()
      if active ~= s then return end
      index = index + 1
      while s.materials[index] and found[s.materials[index]] do index = index + 1 end
      local name = s.materials[index]
      if not name then finish(s); return end
      local wanted = {[normalize(name)] = name}
      if W.itemIDs[name] then wanted[W.itemIDs[name]] = name end
      browse(s, s.localizedNames[name] or name, wanted, function(keys)
        if addEstimates(s, keys) then missing() end
      end)
      status(s, "Fast Scan · summary: " .. name)
    end
    missing()
  end, Enum and Enum.ItemClass and Enum.ItemClass.Tradegoods or 7)
  status(s, "Fast Scan · Trade Goods summaries")
end
function W.StartTargetedScan(mode)
  if active then return end
  local api = C_AuctionHouse
  for _, name in ipairs({"SendBrowseQuery", "GetBrowseResults", "HasFullBrowseResults", "RequestMoreBrowseResults", "GetItemKeyInfo",
    "SendSearchQuery", "HasSearchResults", "HasFullCommoditySearchResults", "HasFullItemSearchResults", "RequestMoreCommoditySearchResults",
    "RequestMoreItemSearchResults", "GetNumCommoditySearchResults", "GetNumItemSearchResults", "GetCommoditySearchResultInfo",
    "GetItemSearchResultInfo", "IsThrottledMessageSystemReady"}) do
    if not api or not api[name] then W.scanError = true; W.message = "Targeted scans unavailable on this client: " .. name; W.Draw(); return end
  end
  local localizedNames = {}
  if not hooked then
    hooked = true
    -- Search buffers are shared with Blizzard and other addons. Yield ownership
    -- if another search is started, rather than assigning its prices to ours.
    for _, name in ipairs({"SendBrowseQuery", "SendSearchQuery", "SendSellSearchQuery", "RequestMoreBrowseResults", "RequestMoreCommoditySearchResults",
      "RequestMoreItemSearchResults", "RefreshCommoditySearchResults", "RefreshItemSearchResults", "SearchForItemKeys", "SearchForFavorites"}) do
      if api[name] then hooksecurefunc(api, name, function()
        if not internalRequest and (name == "SendSearchQuery" or name == "SendSellSearchQuery") then
          trimSearchTimes(); searchTimes[#searchTimes + 1] = GetTime()
        end
        if active and not internalRequest then W.CancelScan("Scan interrupted by another auction house search") end
      end) end
    end
  end
  mode = mode == "fast" and "fast" or "full"
  local kind = W.IsWritView() and "writs" or "waylaid"
  local catalog = W.GetCatalog()
  local s = {books = {}, materials = {}, completed = 0, total = 0, phase = "Orders", crateCount = 0,
    scanMode = mode, requests = 0, started = GetTime(), kind = kind, localizedNames = localizedNames}
  local names = {}
  for _, crate in ipairs(catalog) do
    names[normalize(crate.name)] = crate.name
    if crate.itemID then names[crate.itemID] = crate.name end
    s.books[crate.name] = {estimated = mode == "fast"}
  end
  active = s; W.scanning = true; W.runningMode = mode; W.scanError = false
  local function startBrowse()
  -- Both catalogs have known IDs; do not assume translated common prefixes.
  browse(s, W.Locale() ~= "enUS" and "" or (kind == "writs" and "Craftsman's Writ" or "Waylaid Crate"), names, function(matches)
    s.total = #matches
    local function cratesReady()
      local seen = {}
      for _, crate in ipairs(catalog) do
        local q = W.Quote(s.books[crate.name], 1, true)
        if q.cost or (mode == "fast" and q.available > 0) then
          s.crateCount = s.crateCount + 1
          for _, bundle in ipairs(crate.bundles) do
            local name = bundle[2]
            if not seen[name] then seen[name] = true; s.materials[#s.materials + 1] = name; s.books[name] = {estimated = mode == "fast"} end
          end
        end
      end
      table.sort(s.materials)
      s.phase, s.completed, s.total = "Materials", 0, #s.materials
      if mode == "fast" then fastMaterials(s) else fullMaterials(s) end
    end
    if mode == "fast" then
      if addEstimates(s, matches) then cratesReady() end
    else searchKeys(s, matches, cratesReady) end
  end)
  status(s, (mode == "fast" and "Fast Scan · " or "Full Scan · ") .. (kind == "writs" and "Craftsman's Writs" or "Waylaid Crates"))
  end
  if W.Locale() == "enUS" then startBrowse(); return end
  -- A cold client needs item data before name-search fallback can be safe.
  -- Keep the user's scan active while it loads instead of requiring a second click.
  local op = operation(s, "Loading localized item data…")
  local requested, lastMissing = {}, nil
  local function prepare()
    if active ~= s or s.operation ~= op then return end
    local missing, seen = 0, {}
    for _, order in ipairs(catalog) do
      local names = {order.name}
      for _, bundle in ipairs(order.bundles) do names[#names + 1] = bundle[2] end
      for _, name in ipairs(names) do
        if not seen[name] then
          seen[name] = true
          localizedNames[name] = W.LocalItemName(name)
          if not localizedNames[name] then
            local id = W.itemIDs[name]
            if not id then finish(s, "Missing catalog item ID: " .. name); return end
            missing = missing + 1
            if not requested[id] and C_Item and C_Item.RequestLoadItemDataByID then
              requested[id] = true; C_Item.RequestLoadItemDataByID(id)
            end
          end
        end
      end
    end
    if missing == 0 then startBrowse(); return end
    if lastMissing ~= missing then
      lastMissing = missing
      status(s, string.format("Loading localized item data: %d remaining", missing))
    end
    C_Timer.After(0.2, prepare)
  end
  prepare()
end
