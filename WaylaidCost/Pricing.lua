local _, W = ...
W = W or {}
WaylaidCostEngine = W

-- Book buyout is the total price of the recorded quantity. Only commodities can
-- be split: ItemKeyInfo.isCommodity determines the purchase model, not rarity.
function W.Quote(book, required, scanned, incomplete, skipped)
  local result = { required = required, available = 0, bidOnly = 0, own = 0, plan = {} }
  if skipped then result.reason = "skipped"; return result end
  if not scanned then result.reason = "unscanned"; return result end
  if book and book.databaseMissing then result.reason = "databaseMissing"; return result end
  if book and book.databasePrice then
    result.estimated, result.databaseEstimate = true, true
    result.cost, result.estimateUnitPrice = book.databasePrice * required, book.databasePrice
    result.ageDays, result.reason = book.ageDays, "database"
    return result
  end
  if book and book.estimated then
    -- Browse stock is total stock, NOT stock at the minimum price. Do not
    -- manufacture purchase plans or price levels from these summaries.
    result.estimated = true
    local minimum
    for _, offer in ipairs(book) do
      result.available = result.available + offer.count
      result.mayIncludeOwn = result.mayIncludeOwn or offer.containsOwnerItem
      if offer.minPrice > 0 and (offer.isCommodity or required == 1) then
        minimum = not minimum and offer.minPrice or math.min(minimum, offer.minPrice)
      end
    end
    if result.available < required then
      result.missing = required - result.available
      result.reason = result.available > 0 and "summaryShort" or "absent"
    elseif minimum then
      result.cost, result.estimateUnitPrice = minimum * required, minimum
    else result.reason = "estimateUnknown" end
    return result
  end
  for _, offer in ipairs(book or {}) do
    if offer.pricingUnknown then result.pricingUnknown = true end
    if offer.isCommodity then result.isCommodity = true
    elseif not offer.pricingUnknown then result.hasWholeAuctions = true end
    if offer.own then result.own = result.own + offer.count
    elseif offer.buyout > 0 then result.available = result.available + offer.count
    else result.bidOnly = result.bidOnly + offer.count end
  end
  if result.pricingUnknown or (result.isCommodity and result.hasWholeAuctions) then
    result.reason = "mode"; return result
  end
  if result.available < required then
    result.missing = required - result.available
    result.reason = incomplete and "incomplete" or (result.available > 0 and "short" or
      (result.bidOnly > 0 and "bid" or (result.own > 0 and "own" or "absent")))
    return result
  end
  if result.isCommodity then
    local prices = {}
    for _, offer in ipairs(book or {}) do
      if not offer.own and offer.buyout > 0 then
        prices[#prices + 1] = { count = offer.count, unitPrice = offer.buyout / offer.count }
      end
    end
    table.sort(prices, function(a, b) return a.unitPrice < b.unitPrice end)
    local left, total = required, 0
    for _, price in ipairs(prices) do
      if left <= 0 then break end
      local take = math.min(left, price.count)
      local cost = take * price.unitPrice
      local previous = result.plan[#result.plan]
      if previous and previous.unitPrice == price.unitPrice then
        previous.count = previous.count + take
        previous.buyout = previous.buyout + cost
      else
        result.plan[#result.plan + 1] = { count = take, buyout = cost, unitPrice = price.unitPrice }
      end
      left, total = left - take, total + cost
    end
    result.cost, result.purchased, result.extra = total, required, 0
    result.priceLevels = #result.plan
    return result
  end
  -- Non-commodity auctions are indivisible. Bounded knapsack minimizes the
  -- total paid, including any unavoidable surplus, without reusing a listing.
  local states = { [0] = { cost = 0, count = 0, stacks = 0 } }
  for _, offer in ipairs(book or {}) do
    if not offer.own and offer.buyout > 0 then
      for quantity = required - 1, 0, -1 do
        local prev = states[quantity]
        if prev then
          local target = math.min(required, quantity + offer.count)
          local cost, count = prev.cost + offer.buyout, prev.count + offer.count
          local old = states[target]
          if not old or cost < old.cost or (cost == old.cost and count < old.count) then
            states[target] = { cost = cost, count = count, stacks = prev.stacks + 1,
              previous = prev, offer = offer }
          end
        end
      end
    end
  end
  local best = states[required]
  result.cost, result.purchased, result.stacks = best.cost, best.count, best.stacks
  result.extra = best.count - required
  while best.offer do
    table.insert(result.plan, 1, best.offer)
    best = best.previous
  end
  return result
end

function W.Evaluate(crates, books, settings, level, scanned, incomplete, targeted)
  local results, cache = {}, {}
  local function quote(key, quantity)
    local id = key .. ":" .. quantity
    if not cache[id] then cache[id] = W.Quote(books[key], quantity, scanned, incomplete, targeted and books[key] == nil) end
    return cache[id]
  end
  for _, crate in ipairs(crates) do
    if not settings.levelOnly or crate.tier <= level then
      local bundles, best = {}, nil
      for _, bundle in ipairs(crate.bundles) do
        local option = { name = bundle[2], quantity = bundle[1], quote = quote(bundle[2], bundle[1]) }
        bundles[#bundles + 1] = option
        if option.quote.cost and (not best or option.quote.cost < best.quote.cost) then best = option end
      end
      -- Rarity is observed in the scan, never inferred from the crate's level.
      local variants = {}
      for _, offer in ipairs(books[crate.name] or {}) do
        local quality = offer.quality or -1
        variants[quality] = variants[quality] or {estimated = books[crate.name].estimated,
          databasePrice = books[crate.name].databasePrice, databaseMissing = books[crate.name].databaseMissing,
          ageDays = books[crate.name].ageDays}
        table.insert(variants[quality], offer)
      end
      if not next(variants) then variants[-1] = {estimated = books[crate.name] and books[crate.name].estimated} end
      for quality, book in pairs(variants) do
        if crate.kind == "writ" or ((quality ~= 1 or settings.common) and (quality ~= 2 or settings.uncommon)
          and (quality ~= -1 or settings.common or settings.uncommon)) then
          local crateQuote = W.Quote(book, 1, scanned, incomplete)
          local rewards = settings.rewards and settings.rewards[crate.family] or {}
          local favor = tonumber(rewards[quality])
          if not favor or favor <= 0 then favor = nil end
          local reputation, faction
          if crate.kind == "writ" then reputation, faction = W.Reputation(crate); favor = nil end
          local reward = crate.kind == "writ" and reputation or favor
          local total = best and crateQuote.cost and best.quote.cost + crateQuote.cost
          local item = { crate = crate, quality = quality, bundles = bundles, best = best,
            crateQuote = crateQuote, total = total, favor = favor,
            reputation = reputation, faction = faction, rewardValue = reward, rewardLabel = crate.kind == "writ" and "rep" or "Favor",
            ratio = total and reward and total / reward, key = crate.name .. ":" .. quality }
          if settings.showUnavailable ~= false or crateQuote.cost then results[#results + 1] = item end
        end
      end
    end
  end
  table.sort(results, function(a, b)
    if a.ratio and b.ratio and a.ratio ~= b.ratio then return a.ratio < b.ratio end
    if (a.ratio ~= nil) ~= (b.ratio ~= nil) then return a.ratio ~= nil end
    if a.total and b.total and a.total ~= b.total then return a.total < b.total end
    if (a.total ~= nil) ~= (b.total ~= nil) then return a.total ~= nil end
    if (a.crateQuote.cost ~= nil) ~= (b.crateQuote.cost ~= nil) then return a.crateQuote.cost ~= nil end
    return a.key < b.key
  end)
  return results
end
