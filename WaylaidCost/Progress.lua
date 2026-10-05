local _, W = ...

-- Union of the beta profession prices supplied by the project owner.
W.FavorThresholds = {30, 45, 60, 90, 120, 180, 240, 270, 360, 1000}
local ranks = {"Hated", "Hostile", "Unfriendly", "Neutral", "Friendly", "Honored", "Revered", "Exalted"}
local rankStarts = {-42000, -6000, -3000, 0, 3000, 9000, 21000, 42000}
local function rankName(rank) return _G["FACTION_STANDING_LABEL" .. rank] or ranks[rank] end
local function settingKey() return W.IsWritView() and "reputationGoal" or "favorGoal" end

function W.ProgressState()
  local saved = tonumber(W.db[settingKey()])
  if W.IsWritView() then
    local faction = UnitFactionGroup and UnitFactionGroup("player")
    local id = faction == "Alliance" and 2586 or faction == "Horde" and 2587
    local data
    if id and C_Reputation and C_Reputation.GetFactionDataByID then
      data = C_Reputation.GetFactionDataByID(id)
    elseif id and GetFactionInfoByID then
      local name, _, reaction, low, high, value = GetFactionInfoByID(id)
      if name then data = {name = name, reaction = reaction, currentReactionThreshold = low,
        nextReactionThreshold = high, currentStanding = value} end
    end
    if not data or not data.name or not data.reaction or not data.currentStanding
      or not data.currentReactionThreshold or not data.nextReactionThreshold then
      return {text = "Reputation unavailable", targets = {}}
    end
    local targets = {}
    for rank = data.reaction + 1, 8 do
      targets[#targets + 1] = {value = rank == data.reaction + 1 and data.nextReactionThreshold or rankStarts[rank], label = rankName(rank)}
    end
    if data.reaction >= 8 then
      return {text = "Exalted · Maximum reputation", missing = 0, targets = targets, name = data.name}
    end
    local goal = saved or targets[1].value
    local targetName = "Custom target"
    for rank, value in ipairs(rankStarts) do if value == goal then targetName = rankName(rank) end end
    for _, target in ipairs(targets) do if target.value == goal then targetName = target.label end end
    local base = data.currentReactionThreshold
    local text = goal <= data.currentStanding and (targetName .. " reached")
      or string.format("%d / %d · %s", data.currentStanding - base, goal - base, targetName)
    return {text = text,
      missing = math.max(0, goal - data.currentStanding), target = goal, targets = targets,
      base = base, name = data.name, input = math.max(0, goal - base), maxInput = 42000 - base,
      prompt = "Target reputation from the start of your current rank:"}
  end
  local info = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(3402)
  local amount = info and info.quantity
  if type(amount) ~= "number" then return {text = "Favor balance unavailable", targets = {}} end
  local targets, nextGoal = {}, nil
  for _, value in ipairs(W.FavorThresholds) do
    if value > amount then
      targets[#targets + 1] = {value = value}
      if not nextGoal then nextGoal = value end
    end
  end
  local goal = saved or nextGoal or W.FavorThresholds[#W.FavorThresholds]
  return {text = string.format("%d / %d Favor", amount, goal), missing = math.max(0, goal - amount),
    target = goal, targets = targets, name = "Merchant's Favor", icon = info.iconFileID,
    base = 0, input = goal, maxInput = 100000, prompt = "Target Merchant's Favor balance:"}
end

-- Greedy route over shared snapshot stock. Each purchase is removed from a
-- private book; whole-stack surplus is reused. Not a global integer optimizer.
function W.EstimateGoal(missing, results)
  if not missing or missing <= 0 or not W.scannedAt or W.scanMode == "fast" then return end
  local books, inventory, revision, quotes = {}, {}, {}, {}
  for name, book in pairs(W.books or {}) do
    local copy = {}; books[name] = copy
    for _, offer in ipairs(book) do
      local entry = {}; for key, value in pairs(offer) do entry[key] = value end
      copy[#copy + 1] = entry
    end
  end
  local function quote(name, quantity, quality)
    local key = name .. ":" .. tostring(quality or "goods")
    local cacheKey = key .. ":" .. quantity
    local cached = quotes[cacheKey]
    if cached and cached.revision == (revision[name] or 0) then return cached end
    local owned = math.min(quantity, inventory[key] or 0)
    local need = quantity - owned
    local q = {cost = 0, purchased = 0, plan = {}}
    if need > 0 then
      local book = {}
      for _, offer in ipairs(books[name] or {}) do
        if not quality or (offer.quality or -1) == quality then book[#book + 1] = offer end
      end
      q = W.Quote(book, need, true, W.incomplete)
    end
    q.name, q.stockKey, q.used, q.need, q.quality = name, key, owned, need, quality
    q.revision = revision[name] or 0; quotes[cacheKey] = q
    return q
  end
  local function consume(q)
    local book = books[q.name] or {}
    for _, purchase in ipairs(q.plan) do
      if q.isCommodity then
        local left = purchase.count
        for index = #book, 1, -1 do
          local offer = book[index]
          if not offer.own and offer.buyout > 0 and (not q.quality or (offer.quality or -1) == q.quality)
            and offer.buyout / offer.count == purchase.unitPrice then
            local take = math.min(left, offer.count)
            local unitPrice = offer.buyout / offer.count
            offer.count = offer.count - take; offer.buyout = offer.count * unitPrice
            left = left - take
            if offer.count == 0 then table.remove(book, index) end
            if left == 0 then break end
          end
        end
      else
        for index = #book, 1, -1 do
          if book[index] == purchase then table.remove(book, index); break end
        end
      end
    end
    inventory[q.stockKey] = (inventory[q.stockKey] or 0) - q.used + (q.purchased or 0) - q.need
    revision[q.name] = (revision[q.name] or 0) + 1
  end
  local plan = {count = 0, cost = 0, reward = 0, steps = {}}
  local grouped = {}
  while plan.reward < missing and plan.count < 2000 do
    local best
    for _, item in ipairs(results or {}) do
      if item.rewardValue and item.rewardValue > 0 then
        local order = quote(item.crate.name, 1, item.quality)
        if order.cost then
          for _, bundle in ipairs(item.bundles) do
            local goods = quote(bundle.name, bundle.quantity)
            if goods.cost then
              local cost = order.cost + goods.cost
              local score = cost / math.min(item.rewardValue, missing - plan.reward)
              if not best or score < best.score or (score == best.score and cost < best.cost) then
                best = {item = item, bundle = bundle, order = order, goods = goods, cost = cost, score = score}
              end
            end
          end
        end
      end
    end
    if not best then break end
    consume(best.order); consume(best.goods)
    plan.count = plan.count + 1; plan.cost = plan.cost + best.cost; plan.reward = plan.reward + best.item.rewardValue
    local key = best.item.key .. ":" .. best.bundle.name
    if not grouped[key] then
      grouped[key] = {name = W.OrderName(best.item.crate), goods = best.bundle.name, count = 0}
      plan.steps[#plan.steps + 1] = grouped[key]
    end
    grouped[key].count = grouped[key].count + 1
  end
  plan.remaining = math.max(0, missing - plan.reward)
  plan.complete = plan.remaining == 0
  plan.limited = not plan.complete and plan.count == 2000
  return plan
end

local function goalPlan(state)
  local cache = W.goalCache
  if not cache or cache.results ~= W.results or cache.missing ~= state.missing or cache.mode ~= W.scanMode then
    cache = {results = W.results, missing = state.missing, mode = W.scanMode, plan = W.EstimateGoal(state.missing, W.results)}
    W.goalCache = cache
  end
  return cache.plan
end

function W.BuildProgress(panel)
  local strip = CreateFrame("Button", nil, panel)
  panel.progress = strip
  -- Keep the wider progress layout separate from native item/search tooltips.
  local GameTooltip = CreateFrame("GameTooltip", "WaylaidCostProgressTooltip", UIParent, "GameTooltipTemplate")
  GameTooltip:SetClampedToScreen(true)
  strip:SetScript("OnHide", function() GameTooltip:Hide() end)
  strip:SetPoint("TOPRIGHT", -20, -77); strip:SetSize(330, 40)
  strip:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  strip:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight")
  strip.title = strip:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  strip.title:SetPoint("TOPLEFT", 0, -2); strip.title:SetPoint("TOPRIGHT", 0, -2)
  strip.title:SetHeight(16); strip.title:SetJustifyH("RIGHT")
  strip.cost = strip:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  strip.cost:SetPoint("TOPLEFT", 0, -21); strip.cost:SetPoint("TOPRIGHT", 0, -21)
  strip.cost:SetHeight(16); strip.cost:SetJustifyH("RIGHT")
  local editor = CreateFrame("Frame", nil, strip, "BackdropTemplate")
  strip.editor = editor
  editor:SetPoint("TOPRIGHT", strip, "BOTTOMRIGHT", 0, -3); editor:SetSize(350, 70)
  editor:SetFrameStrata("DIALOG"); editor:EnableMouse(true)
  editor:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
  editor:SetBackdropColor(0.04, 0.05, 0.07, 1)
  editor.label = editor:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  editor.label:SetPoint("TOPLEFT", 10, -10)
  editor.input = CreateFrame("EditBox", nil, editor, "InputBoxTemplate")
  editor.input:SetPoint("TOPLEFT", 16, -33); editor.input:SetSize(135, 24)
  editor.input:SetAutoFocus(false); editor.input:SetNumeric(true); editor.input:SetMaxLetters(6)
  local function save()
    local value = tonumber(editor.input:GetText())
    if not value or value < 0 or value > editor.maxInput or value ~= math.floor(value) then
      editor.label:SetText(W.Text("Enter a whole number from 0 to " .. editor.maxInput .. ".")); return
    end
    W.db[editor.key] = value + editor.base; editor:Hide(); W.UpdateProgress()
  end
  editor.input:SetScript("OnEnterPressed", save)
  editor.input:SetScript("OnEscapePressed", function() editor:Hide() end)
  editor:SetScript("OnHide", function() editor.input:ClearFocus() end)
  for i, text in ipairs({"Save", "Cancel"}) do
    local b = CreateFrame("Button", nil, editor, "UIPanelButtonTemplate")
    b:SetPoint("TOPLEFT", 158 + (i - 1) * 80, -33); b:SetSize(74, 24); b:SetText(W.Text(text))
    b:SetScript("OnClick", i == 1 and save or function() editor:Hide() end)
  end
  editor:Hide()
  strip:SetScript("OnClick", function(_, mouse)
    local state = W.ProgressState()
    GameTooltip:Hide()
    if mouse == "RightButton" then
      if not state.input then return end
      editor.key, editor.base, editor.maxInput = settingKey(), state.base, state.maxInput
      editor.label:SetText(W.Text(state.prompt)); editor.input:SetText(W.Text(tostring(state.input)))
      editor:Show(); editor.input:SetFocus(); editor.input:HighlightText()
    else
      editor:Hide()
      local target = state.targets[1]
      for _, entry in ipairs(state.targets) do
        if entry.value > (state.target or 0) then target = entry; break end
      end
      if target then W.db[settingKey()] = target.value; W.UpdateProgress() end
    end
  end)
  strip:SetScript("OnEnter", function(self)
    local state = W.ProgressState()
    local plan = goalPlan(state)
    local explanations = W.ShowTooltipExplanations()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 8, 0)
    GameTooltip:SetMinimumWidth(400)
    GameTooltip:AddLine(W.Text(state.name or "Progress"), 1, 0.82, 0.45)
    GameTooltip:AddLine(W.Text(state.text), 1, 1, 1, true)
    GameTooltip:AddLine(W.Text("Left-click: next target. Right-click: custom amount."), 0.8, 0.85, 0.9, true)
    if state.missing then GameTooltip:AddLine(W.Text(state.missing .. (W.IsWritView() and " reputation remaining" or " Favor remaining")), 1, 1, 1) end
    if plan then
      if plan.count > 0 then
        GameTooltip:AddDoubleLine(W.Text("%d %s%s", plan.count, plan.count == 1 and "turn-in" or "turn-ins",
          plan.complete and "" or " (partial)"),W.Text("≈ " .. W.Money(plan.cost)), 1, 1, 1, 1, 1, 1)
      end
      if not plan.complete then
        GameTooltip:AddLine(W.Text((plan.limited and "Planning limit reached: " or "Not enough stock for this route: ")
          .. plan.remaining .. (W.IsWritView() and " reputation" or " Favor") .. " still needed."), 1, 0.68, 0.47, true)
      end
      if explanations then
        GameTooltip:AddLine(W.Text(" "))
        for index, step in ipairs(plan.steps) do
          if index > 12 then GameTooltip:AddLine(W.Text("Additional orders included…"), 0.8, 0.85, 0.9); break end
          GameTooltip:AddLine(W.Text("%d × %s (%s)", step.count, step.name, W.ItemLabel(step.goods)), 0.8, 0.85, 0.9, true)
        end
        GameTooltip:AddLine(W.Text("Uses scanned stock and price tiers across displayed orders and their filling options, sharing materials and reusing purchased surplus. Chooses the cheapest next reward; the overall route is not guaranteed cheapest."), 0.8, 0.85, 0.9, true)
        GameTooltip:AddLine(W.Text("Owned items, bonuses and quest payments are excluded. Quest eligibility and reputation caps are not modeled. Partial costs cover only the planned turn-ins."), 0.8, 0.85, 0.9, true)
      end
    elseif state.missing and state.missing > 0 then GameTooltip:AddLine(W.Text("Run Full Scan to calculate a route from recorded stock and price tiers."), 0.8, 0.85, 0.9, true) end
    if explanations and not W.IsWritView() then GameTooltip:AddLine(W.Text("Targets combine profession prices and use your current Favor balance. Cycling skips reached targets and wraps to the first remaining target."), 0.8, 0.85, 0.9, true) end
    if plan and plan.count > 0 then GameTooltip:AddLine(W.Text("Quick estimate: double-check prices, stock and quest requirements before buying."), 0.8, 0.85, 0.9, true) end
    if W.scannedAt then GameTooltip:AddLine(W.Text("Source scan: " .. (W.scanTimeUnknown and "date unknown" or date("%Y-%m-%d %H:%M", W.scannedAt))), 0.8, 0.85, 0.9) end
    if not explanations and W.db.tooltipExplanations == "shift" then
      GameTooltip:AddLine(W.Text("Hold Shift and hover again for the breakdown"), 0.55, 0.61, 0.7)
    end
    GameTooltip:Show()
  end)
  strip:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

function W.UpdateProgress()
  local panel = W.panel
  if not panel or not panel:IsShown() or not panel.progress then return end
  local strip, writs = panel.progress, W.IsWritView()
  if strip.kind ~= writs then strip.editor:Hide(); strip.kind = writs end
  local state = W.ProgressState()
  if strip.editor:IsShown() and strip.editor.base ~= state.base then strip.editor:Hide() end
  local icon = state.icon or (writs and "Interface/Icons/INV_Misc_Note_01" or "Interface/Icons/INV_Misc_Coin_01")
  strip.title:SetText(W.Text("|T" .. icon .. ":16:16|t " .. state.text))
  local plan = goalPlan(state)
  local text = ""
  if state.missing == 0 then text = "Target reached"
  elseif state.missing then
    if plan and plan.count > 0 then
      text = string.format("%d %s · ≈ ", plan.count, plan.count == 1 and "turn-in" or "turn-ins") .. W.Money(plan.cost)
      if not plan.complete then text = text .. " · Partial" end
    elseif plan then text = "Insufficient scanned stock"
    else text = "Full Scan needed for goal cost" end
  end
  strip.cost:SetText(W.Text(text))
end

