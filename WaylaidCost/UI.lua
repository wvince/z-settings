local _, W = ...
local WHITE, GREEN, GOLD, MUTED = "|cffffffff", "|cff1eff00", "|cffffd173", "|cff9ca9b9"
local function color(text, code) return code .. text .. "|r" end
function W.Money(value)
  if value == nil then return color("—", MUTED) end
  value = math.ceil(value)
  local gold, silver, copper = math.floor(value / 10000), math.floor(value / 100) % 100, value % 100
  local function coin(amount, kind)
    return amount .. "|TInterface\\MoneyFrame\\UI-" .. kind .. "Icon:12:12:1:0|t"
  end
  local text = gold > 0 and coin(gold, "Gold") .. " " or ""
  if silver > 0 or gold > 0 then text = text .. coin(silver, "Silver") .. " " end
  if copper > 0 or value == 0 then text = text .. coin(copper, "Copper") end
  return text:gsub("%s+$", "")
end
function W.Reason(q)
  if q.estimated and q.cost then return string.format("Estimate · %d total listed · stock at this price not verified", q.available) end
  if q.reason == "summaryShort" then return string.format("Summary: %d/%d total units · at least %d missing", q.available, q.required, q.missing) end
  if q.reason == "estimateUnknown" then return "No estimate: run Full Scan to check buyout availability and unit prices" end
  if q.cost and q.isCommodity then return string.format("%d available · %d needed · purchased per unit", q.available, q.required) end
  if q.cost then return string.format("%d available · %d purchased · %d extra", q.available, q.purchased, q.extra) end
  if q.reason == "unscanned" then return "Unknown price: run a scan" end
  if q.reason == "skipped" then return "Not scanned: no matching order available to buy" end
  if q.reason == "mode" then return "Price pending: auction sale type has not loaded" end
  if q.reason == "incomplete" then return string.format("Incomplete scan: %d/%d known units", q.available, q.required) end
  if q.reason == "short" then return string.format("Insufficient stock: %d/%d · %d missing", q.available, q.required, q.missing) end
  if q.reason == "bid" then return string.format("No buyout · %d units available for bidding only", q.bidOnly) end
  if q.reason == "own" then return "Only your own auctions: cannot purchase" end
  return "Not found in this snapshot · required quantity: " .. q.required
end
function W.CrateStatus(q)
  if q.reason == "absent" then return "Crate not listed at the time of this snapshot" end
  return "Crate: " .. W.Reason(q)
end
local function rarity(q)
  if q == 1 then return WHITE, "Common" end
  if q == 2 then return GREEN, "Uncommon" end
  if q < 0 then return MUTED, "Unknown rarity" end
  local c = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[q]
  return c and c.hex or WHITE, _G["ITEM_QUALITY" .. q .. "_DESC"] or ("Quality " .. q)
end
local function label(parent, text, x, y, font)
  local f = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlightSmall")
  f:SetPoint("TOPLEFT", x, y); f:SetJustifyH("LEFT"); f:SetText(text)
  return f
end
local function button(parent, text, width, x, y, callback)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(width, 23); b:SetPoint("TOPRIGHT", x, y); b:SetText(text); b:SetScript("OnClick", callback)
  return b
end
local function backdrop(frame)
  frame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12,
    insets = { left = 3, right = 3, top = 3, bottom = 3 } })
  frame:SetBackdropColor(0.035, 0.045, 0.065, 1)
  frame:SetBackdropBorderColor(0.35, 0.42, 0.51, 1)
end
local function planTooltip(owner, name, q)
  GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
  GameTooltip:AddLine(name, 1, 0.82, 0.45)
  GameTooltip:AddLine(W.Reason(q), 0.85, 0.88, 0.94, true)
  if q.estimated then
    if q.estimateUnitPrice then
      GameTooltip:AddDoubleLine("Lowest listed price", W.Money(q.estimateUnitPrice), 0.8, 0.85, 0.9, 1, 1, 1)
      GameTooltip:AddDoubleLine("Estimate for " .. q.required, "≈ " .. W.Money(q.cost), 1, 0.82, 0.45, 1, 1, 1)
    end
    GameTooltip:AddLine("Fast Scan assumes the lowest price for the required quantity. Price tiers, stacks, sellers and buyout availability are not verified.", 1, 0.68, 0.47, true)
    if q.mayIncludeOwn then GameTooltip:AddLine("This summary includes your auctions. Their share of the stock and purchasable prices have not been checked.", 1, 0.68, 0.47, true) end
    GameTooltip:AddLine("Run Full Scan to verify prices and quantities before choosing.", 0.7, 0.8, 0.9, true)
    GameTooltip:Show(); return
  end
  local groups, order = {}, {}
  for _, offer in ipairs(q.plan) do
    local key = offer.count .. ":" .. offer.buyout
    if not groups[key] then groups[key] = { n = 0, offer = offer }; order[#order + 1] = groups[key] end
    groups[key].n = groups[key].n + 1
  end
  for _, group in ipairs(order) do
    local offer = group.offer
    if q.isCommodity then
      GameTooltip:AddDoubleLine(offer.count .. " × " .. W.Money(offer.unitPrice) .. " / unit",
        W.Money(offer.buyout), 1, 1, 1, 1, 1, 1)
    else
      GameTooltip:AddDoubleLine(group.n .. " stack(s) of " .. offer.count,
        W.Money(offer.buyout) .. " / stack", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("  " .. W.Money(offer.buyout / offer.count) .. " / unit (rounded)", 0.65, 0.7, 0.78)
    end
  end
  if q.cost then GameTooltip:AddDoubleLine(q.isCommodity and "Cost for the required quantity" or "Total for whole stacks", W.Money(q.cost), 1, 0.82, 0.45, 1, 1, 1) end
  if q.bidOnly > 0 then GameTooltip:AddLine(q.bidOnly .. " bid-only units excluded", 0.7, 0.7, 0.7) end
  if q.own > 0 then GameTooltip:AddLine(q.own .. " units from your own auctions excluded", 0.7, 0.7, 0.7) end
  GameTooltip:AddLine("Snapshot prices: check the auctions before buying.", 0.6, 0.65, 0.7, true)
  GameTooltip:Show()
end

-- Independent of the AH: options must be usable before the auction UI loads.
local function buildSettings()
  local settings = CreateFrame("Frame", "WaylaidCostSettings", UIParent, "BackdropTemplate")
  W.settings = settings
  settings:SetSize(445, 528); settings:SetPoint("CENTER")
  settings:SetFrameStrata("DIALOG"); settings:SetClampedToScreen(true)
  settings:EnableMouse(true); backdrop(settings)
  settings:SetMovable(true)
  local drag = CreateFrame("Frame", nil, settings)
  drag:SetPoint("TOPLEFT", 5, -5); drag:SetPoint("TOPRIGHT", -5, -5); drag:SetHeight(29)
  drag:EnableMouse(true); drag:RegisterForDrag("LeftButton")
  drag:SetScript("OnDragStart", function() settings:StartMoving() end)
  drag:SetScript("OnDragStop", function() settings:StopMovingOrSizing() end)
  if UISpecialFrames then table.insert(UISpecialFrames, "WaylaidCostSettings") end
  label(settings, "WaylaidCost — Settings", 15, -14, "GameFontNormalLarge")
  local options = CreateFrame("Frame", nil, settings)
  options:SetSize(445, 420); options:SetPoint("TOPLEFT", 0, -32)
  local tooltips = CreateFrame("Frame", nil, settings)
  tooltips:SetSize(445, 420); tooltips:SetPoint("TOPLEFT", 0, -32)
  local rewards = CreateFrame("Frame", nil, settings)
  rewards:SetSize(445, 420); rewards:SetPoint("TOPLEFT", 0, -32)
  local about = CreateFrame("Frame", nil, settings)
  about:SetSize(415, 370); about:SetPoint("TOPLEFT", 15, -80)
  local logo = about:CreateTexture(nil, "ARTWORK")
  logo:SetSize(96, 96); logo:SetPoint("TOPLEFT", 0, 0); logo:SetTexture(W.logo)
  label(about, "WaylaidCost", 112, -17, "GameFontNormalLarge")
  local summary = label(about, "AH price comparisons and crate tooltips in your bags.", 112, -42)
  summary:SetWidth(290)
  local subtitle = label(about, "Made for WoW Forever", 112, -77)
  subtitle:SetTextColor(0.65, 0.74, 0.84)
  local introduction = label(about, "I started this vibe-coded project as an experiment for my own use, then shared it with the community.", 5, -115)
  introduction:SetWidth(395)
  local feedback = label(about, "Have a feature request or a bug to report?", 5, -166, "GameFontNormal")
  feedback:SetWidth(395)
  label(about, "Contact me in-game on the beta or on Discord below.", 5, -197)
  local function contact(x, title, name, note, r, g, b)
    local card = CreateFrame("Frame", nil, about, "BackdropTemplate")
    card:SetSize(200, 88); card:SetPoint("TOPLEFT", x, -224); backdrop(card)
    card:SetBackdropBorderColor(r * 0.6, g * 0.6, b * 0.6, 1)
    label(card, title, 12, -12, "GameFontNormal")
    local handle = label(card, name, 12, -35, "GameFontNormalLarge")
    handle:SetTextColor(r, g, b)
    local hint = label(card, note, 12, -63)
    hint:SetTextColor(0.65, 0.74, 0.84)
    return card
  end
  local mage = RAID_CLASS_COLORS and RAID_CLASS_COLORS.MAGE or {r = 0.25, g = 0.78, b = 0.92}
  local inGame = contact(0, "In-game contact", "Shakam Omega", "Click to whisper on the beta", mage.r, mage.g, mage.b)
  local whisper = CreateFrame("Button", nil, inGame)
  whisper:SetPoint("TOPLEFT", 8, -30); whisper:SetSize(184, 28)
  whisper:RegisterForClicks("LeftButtonUp")
  whisper:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
  whisper:SetScript("OnClick", function()
    local editBox = ChatFrame_OpenChat("")
    if not editBox then return end
    editBox:SetAttribute("chatType", "WHISPER")
    editBox:SetAttribute("tellTarget", "Shakam Omega")
    ChatEdit_UpdateHeader(editBox)
  end)
  contact(210, "Discord", "shakam", "Suggestions & bug reports", 0.55, 0.60, 1)
  local thanks = label(about, "Thanks for trying WaylaidCost!", 5, -338)
  thanks:SetTextColor(0.85, 0.77, 0.55)
  local pages = {options, tooltips, rewards, about}
  settings.tabs = {}
  local function selectTab(selected)
    for _, edit in ipairs(settings.edits) do edit:ClearFocus() end
    GameTooltip:Hide()
    for i, page in ipairs(pages) do
      page:SetShown(i == selected); settings.tabs[i]:SetEnabled(i ~= selected)
    end
  end
  for i, name in ipairs({"Display", "Tooltips", "Favor", "About"}) do
    local index = i
    settings.tabs[i] = button(settings, name, 100, -330 + (i - 1) * 106, -39, function() selectTab(index) end)
  end
  label(options, "Changes are applied and saved automatically.", 15, -40)
  label(options, "Display", 15, -67, "GameFontNormal")
  settings.checks, settings.edits = {}, {}
  local function help(control, title, text)
    control:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:AddLine(title, 1, 0.82, 0.45)
      GameTooltip:AddLine(text, 0.85, 0.88, 0.94, true)
      GameTooltip:Show()
    end)
    control:SetScript("OnLeave", function() GameTooltip:Hide() end)
  end
  local function check(key, text, x, y, inverted, parent, description)
    local b = CreateFrame("CheckButton", nil, parent or options, "UICheckButtonTemplate")
    b:SetSize(24, 24); b:SetPoint("TOPLEFT", x, y); b:SetHitRectInsets(0, -360, 0, 0)
    label(b, text, 25, -6)
    b.key, b.inverted = key, inverted
    settings.checks[#settings.checks + 1] = b
    b:SetScript("OnClick", function(self)
      local value = self:GetChecked() and true or false
      if inverted then value = not value end
      W.db[key] = value
      if key == "details" and W.panel then W.panel.expanded = {} end
      if key == "showMinimap" and W.minimap then W.minimap:SetShown(value) end
      if key == "enableWrits" then W.SetOrderKind("waylaid") end
      W.Refresh()
    end)
    if description then help(b, text, description) end
    return b
  end
  check("details", "Show details for all orders", 12, -84)
  check("showUnavailable", "Only show orders available to buy", 12, -110, true)
  check("levelOnly", "My level only", 12, -136)
  check("common", color("Common crates", WHITE), 12, -162):SetHitRectInsets(0, -180, 0, 0)
  check("uncommon", color("Uncommon crates", GREEN), 237, -162):SetHitRectInsets(0, -170, 0, 0)
  check("showMinimap", "Show the minimap icon", 12, -188, false, options,
    "Left-click opens Waylaid at the auction house. Right-click opens settings. If hidden, use /wcrate config.")
  check("enableWrits", "Enable Craftsman's Writs", 12, -230, false, options,
    "Adds a Writs view in the AH and item tooltips. Prices cover the writ and the requested finished goods, not the raw crafting recipe. Writs rank by cost per reputation, separately from Merchant Favor. Enable, then choose Writs in the AH header and scan.")
  label(options, "Using the results", 15, -284, "GameFontNormal")
  local tips = label(options, "Click an order or material to search in Buy.\nUse + / - to expand its required goods.\nSwitch Crates / Writs using the AH header button.\nEach view keeps its own scan and reward ranking.", 15, -310)
  tips:SetWidth(405)
  label(tooltips, "Item tooltips", 15, -48, "GameFontNormalLarge")
  check("itemTooltips", "Show prices on crate / writ item tooltips", 12, -80, false, tooltips,
    "Adds cached goods prices when hovering a crate or enabled writ in your bags, the auction house, or an item link. Disabling this only hides WaylaidCost's section.")
  label(tooltips, "Explanations", 15, -132, "GameFontNormal")
  local explanation = "Explains the cheapest option, rounded unit averages and Fast/Full Scan data. Prices, missing stock and the scan date stay visible. Hold Shift while hovering a crate to reveal explanations in Shift mode."
  settings.tooltipModes = {}
  for i, choice in ipairs({{"shift", "Only while holding Shift (recommended)"}, {"always", "Always show explanations"}, {"never", "Hide explanations"}}) do
    local mode = choice[1]
    local radio = CreateFrame("CheckButton", nil, tooltips, "UIRadioButtonTemplate")
    radio:SetSize(18, 18); radio:SetPoint("TOPLEFT", 18, -162 - (i - 1) * 32)
    radio:SetHitRectInsets(0, -375, 0, 0)
    label(radio, choice[2], 25, -3)
    radio.mode = mode
    settings.tooltipModes[#settings.tooltipModes + 1] = radio
    radio:SetScript("OnClick", function()
      W.db.tooltipExplanations = mode
      for _, other in ipairs(settings.tooltipModes) do other:SetChecked(other.mode == mode) end
    end)
    help(radio, "Tooltip explanations", explanation)
  end
  local tooltipNote = label(tooltips, "Hover an option for help. Changes are saved immediately.\nTooltips use your last scan; hovering never starts a search.", 15, -294)
  tooltipNote:SetWidth(405); tooltipNote:SetTextColor(0.65, 0.74, 0.84)
  label(rewards, "Merchant Favor per filled crate", 15, -48, "GameFontNormalLarge")
  local favorNote = label(rewards, "Base Favor depends on the named crafting tier and rarity, not rarity alone. Beta values remain editable.", 15, -80)
  favorNote:SetWidth(405)
  label(rewards, "Common", 213, -126); label(rewards, color("Uncommon", GREEN), 311, -126)
  for i, family in ipairs({"Apprentice", "Journeyman", "Expert", "Artisan"}) do
    label(rewards, family, 15, -135 - i * 34)
    for quality = 1, 2 do
      local q, f = quality, family
      local edit = CreateFrame("EditBox", nil, rewards, "InputBoxTemplate")
      edit:SetSize(70, 22); edit:SetPoint("TOPLEFT", 212 + (q - 1) * 98, -129 - i * 34)
      edit:SetAutoFocus(false); edit:SetNumeric(true); edit:SetMaxLetters(5)
      edit.family, edit.quality = f, q
      edit:SetScript("OnEditFocusLost", function(self)
        local value = tonumber(self:GetText())
        value = value and value > 0 and value or nil
        W.db.rewards[f] = W.db.rewards[f] or {}
        if W.db.rewards[f][q] ~= value then W.db.rewards[f][q] = value; W.Refresh() end
      end)
      edit:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
      edit:SetScript("OnEscapePressed", function() settings:Hide() end)
      settings.edits[#settings.edits + 1] = edit
    end
  end
  local rewardNote = label(rewards, "Apprentice: 5 / 10. Journeyman: 10 / 20.\nExpert / Artisan: unconfirmed; leave blank if unknown.\nSource: beta reports, checked 27 Sep 2026.\nPerformance Bonus can double Favor and is excluded.\nThese settings do not change in-game rewards.", 15, -306)
  rewardNote:SetWidth(415)
  local credits = label(settings, "Author: " .. W.author .. "  ·  Version: " .. W.version, 15, -469)
  credits:SetWidth(310); credits:SetTextColor(0.65, 0.71, 0.79)
  local client = label(settings, W.target, 15, -492)
  client:SetWidth(310); client:SetTextColor(0.65, 0.71, 0.79)
  button(settings, "Close", 85, -14, -492, function() settings:Hide() end)
  selectTab(1)
  settings:SetScript("OnShow", function()
    for _, b in ipairs(settings.checks) do
      local value = W.db[b.key] and true or false
      if b.inverted then value = not value end
      b:SetChecked(value)
    end
    for _, edit in ipairs(settings.edits) do edit:SetText(tostring((W.db.rewards[edit.family] or {})[edit.quality] or "")) end
    for _, radio in ipairs(settings.tooltipModes) do radio:SetChecked(W.db.tooltipExplanations == radio.mode) end
  end)
  settings:Hide()
  settings:SetScript("OnHide", function()
    settings:StopMovingOrSizing()
    GameTooltip:Hide()
    for _, edit in ipairs(settings.edits) do edit:ClearFocus() end
  end)
end

function W.ToggleSettings()
  if not W.db then return end
  GameTooltip:Hide()
  if not W.settings then buildSettings() end
  W.settings:SetShown(not W.settings:IsShown())
end

function W.BuildUI(parent)
  local panel = CreateFrame("Frame", "WaylaidCostFrame", parent, "BackdropTemplate")
  W.panel = panel
  -- Leave Blizzard's money strip and bottom tabs outside our content area.
  panel:SetPoint("TOPLEFT", 4, -30); panel:SetPoint("BOTTOMRIGHT", -4, 30)
  panel:SetFrameLevel(parent:GetFrameLevel() + 20); backdrop(panel); panel:EnableMouse(true)
  local background = panel:CreateTexture(nil, "BACKGROUND")
  background:SetPoint("TOPLEFT", 3, -3); background:SetPoint("BOTTOMRIGHT", -3, 3)
  background:SetColorTexture(0.035, 0.045, 0.065, 1)
  panel.expanded, panel.rows = {}, {}
  local icon = panel:CreateTexture(nil, "ARTWORK")
  -- Blizzard's NPC portrait overlaps the upper-left corner of the AH frame.
  -- Keep the header beyond that portrait and center the title on its icon.
  icon:SetSize(24, 24); icon:SetPoint("TOPLEFT", 58, -10); icon:SetTexture(W.icon)
  icon:SetTexCoord(0, 1, 0, 1)
  local title = label(panel, "WaylaidCost", 0, 0, "GameFontNormalLarge")
  title:ClearAllPoints(); title:SetPoint("LEFT", icon, "RIGHT", 8, 0)
  title:SetSize(250, 24)
  panel.category = button(panel, "Waylaid Crates", 140, -235, -11, function()
    W.SetOrderKind(W.IsWritView() and "waylaid" or "writs")
  end)
  panel.category:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:AddLine("Click to switch Crates / Writs", 1, 0.82, 0.45)
    GameTooltip:AddLine("Each view keeps its own scan. Switching stops an active scan.", 0.8, 0.85, 0.9, true)
    GameTooltip:Show()
  end)
  panel.category:SetScript("OnLeave", function() GameTooltip:Hide() end)
  panel.summary = label(panel, "", 15, -40)
  panel.summary:SetPoint("TOPRIGHT", -20, -40)
  panel.fast = button(panel, "Fast Scan", 100, -124, -11, function() W.Scan("fast") end)
  panel.fast:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:AddLine("Fast Scan — estimate", 1, 0.82, 0.45)
    GameTooltip:AddLine("Reads summaries for this view's orders and required goods. Lowest price × required quantity, without checking price tiers or sellers.", 1, 1, 1, true)
    GameTooltip:AddLine("Estimated prices are marked ≈. Scan time depends on auction house responses and result pages.", 0.7, 0.8, 0.9, true)
    GameTooltip:Show()
  end)
  panel.fast:SetScript("OnLeave", function() GameTooltip:Hide() end)
  panel.scan = button(panel, "Full Scan", 100, -14, -11, function() W.Scan("full") end)
  panel.scan:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:AddLine("Full Scan — verified prices and quantities", 1, 0.82, 0.45)
    GameTooltip:AddLine("Checks this view's orders, then their required goods or filling options. Requests respect the server limits.", 1, 1, 1, true)
    GameTooltip:AddLine("Stay in this tab while scanning. Click the button again to stop. The last successful snapshot is saved.", 0.7, 0.8, 0.9, true)
    GameTooltip:Show()
  end)
  panel.scan:SetScript("OnLeave", function() GameTooltip:Hide() end)
  panel.orderHeader = label(panel, "Crate / recommended fill", 17, -68, "GameFontNormalSmall")
  panel.headers = {}
  for i, text in ipairs({ "Crate", "Materials", "Total cost" }) do
    panel.headers[i] = label(panel, text, 0, -68, "GameFontNormalSmall")
  end
  local scroll = CreateFrame("ScrollFrame", "WaylaidCostScrollFrame", panel, "UIPanelScrollFrameTemplate")
  panel.scroll = scroll
  scroll:SetPoint("TOPLEFT", 12, -89); scroll:SetPoint("BOTTOMRIGHT", -31, 57)
  local content = CreateFrame("Frame", nil, scroll); content:SetSize(1, 1); scroll:SetScrollChild(content)
  panel.content = content
  scroll:EnableMouseWheel(true)
  scroll:SetScript("OnMouseWheel", function(self, delta)
    self:SetVerticalScroll(math.max(0, math.min(self:GetVerticalScrollRange(), self:GetVerticalScroll() - delta * 48)))
  end)
  panel.status = label(panel, "", 15, 0); panel.status:ClearAllPoints()
  panel.status:SetPoint("BOTTOMLEFT", 15, 32); panel.status:SetPoint("BOTTOMRIGHT", -15, 32)
  panel.status:SetJustifyH("LEFT")
  panel.note = label(panel, "Click an item: search in Buy · + / -: details · Right-click minimap: settings", 15, 0)
  panel.note:ClearAllPoints(); panel.note:SetPoint("BOTTOMLEFT", 15, 13); panel.note:SetTextColor(0.55, 0.61, 0.7)
  panel.empty = label(content, "", 10, -20); panel.empty:SetWidth(600)

  panel:SetScript("OnSizeChanged", function() if W.results then W.Draw() end end)
  panel:SetScript("OnShow", function() W.Refresh() end)
  panel:SetScript("OnHide", function() W.CancelScan("Scan cancelled: left the tab"); GameTooltip:Hide() end)
  panel:Hide()
end

local function valueTooltip(item, total)
  GameTooltip:AddLine(" ")
  GameTooltip:AddDoubleLine(W.scanMode == "fast" and "Estimated total (not verified)" or "Total cost", W.Price(total), 1, 0.82, 0.45, 1, 1, 1)
  GameTooltip:AddDoubleLine(item.crate.kind == "writ" and "Base reputation" or "Merchant Favor", item.rewardValue and tostring(item.rewardValue) or "Unknown / not set", 0.8, 0.85, 0.9, 1, 1, 1)
  if total and item.rewardValue then
    GameTooltip:AddDoubleLine("Cost / " .. item.rewardLabel, W.Price(total / item.rewardValue) .. " / " .. item.rewardLabel, 0.8, 0.85, 0.9, 1, 1, 1)
    GameTooltip:AddLine("Sorted by the unrounded ratio; displayed amounts are rounded up to the next copper.", 0.6, 0.65, 0.7, true)
  end
end

function W.Price(value)
  return (W.scanMode == "fast" and value ~= nil and "≈ " or "") .. W.Money(value)
end
function W.Draw()
  local p = W.panel
  if not p then return end
  local writs = W.IsWritView()
  p.category:SetShown(W.db.enableWrits)
  p.category:SetText(writs and "Craftsman's Writs" or "Waylaid Crates")
  p.headers[1]:SetText(writs and "Writ" or "Crate")
  p.headers[2]:SetText(writs and "Required goods" or "Materials")
  p.orderHeader:SetText(writs and "Writ / required goods" or "Crate / recommended fill")
  p.scan:SetText(W.scanning and W.runningMode == "full" and "Stop" or "Full Scan")
  p.fast:SetText(W.scanning and W.runningMode == "fast" and "Stop" or "Fast Scan")
  if W.scanning and W.runningMode ~= "full" then p.scan:Disable() else p.scan:Enable() end
  if W.scanning and W.runningMode ~= "fast" then p.fast:Disable() else p.fast:Enable() end
  p.headers[3]:SetText(W.scanMode == "fast" and "Estimated total" or "Total cost")
  local width = math.max(1, p.scroll:GetWidth())
  p.content:SetWidth(width)
  local nameWidth = math.floor(width * 0.46)
  local cell = (width - nameWidth) / 3
  for i, h in ipairs(p.headers) do
    h:ClearAllPoints(); h:SetPoint("TOPLEFT", 12 + nameWidth + cell * (i - 1), -68)
    h:SetWidth(cell - 9); h:SetJustifyH("RIGHT")
  end
  local used, y, priced, unavailable = 0, 0, 0, false
  local function acquire(height, isOption)
    used = used + 1
    local row = p.rows[used]
    if not row then
      row = CreateFrame("Button", nil, p.content); row:EnableMouse(true)
      row.bg = row:CreateTexture(nil, "BACKGROUND"); row.bg:SetAllPoints()
      row.accent = row:CreateTexture(nil, "ARTWORK")
      row.accent:SetPoint("TOPLEFT", 0, -3); row.accent:SetPoint("BOTTOMLEFT", 0, 3); row.accent:SetWidth(2)
      row.icon = row:CreateTexture(nil, "ARTWORK"); row.icon:SetSize(26, 26); row.icon:SetPoint("TOPLEFT", 29, -10)
      row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
      row.expand = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
      row.expand:SetSize(22, 22); row.expand:SetPoint("TOPLEFT", 3, -14)
      row.marker = label(row, ">", 7, -7, "GameFontNormalLarge")
      row.marker:SetTextColor(0.35, 1, 0.3)
      row.quest = button(row, "Quest", 52, -8, -27, nil)
      row:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight", "ADD")
      row:EnableMouseWheel(true)
      row:SetScript("OnMouseWheel", function(_, delta)
        local scroll = p.scroll
        scroll:SetVerticalScroll(math.max(0, math.min(scroll:GetVerticalScrollRange(), scroll:GetVerticalScroll() - delta * 48)))
      end)
      row.name = label(row, "", 53, -8)
      row.sub = label(row, "", 53, -29)
      row.cols = {}
      for i = 1, 3 do row.cols[i] = label(row, "", 0, -10, i == 3 and "GameFontHighlight" or "GameFontHighlightSmall") end
      row:SetScript("OnLeave", function() GameTooltip:Hide() end)
      p.rows[used] = row
    end
    row:ClearAllPoints(); row:SetPoint("TOPLEFT", 0, -y); row:SetSize(width, height)
    row.name:ClearAllPoints(); row.name:SetPoint("TOPLEFT", isOption and 29 or 63, -8)
    row.name:SetWidth(nameWidth - (isOption and 38 or 70))
    row.sub:ClearAllPoints(); row.sub:SetPoint("TOPLEFT", isOption and 29 or 63, -29)
    row.sub:SetWidth(width - (isOption and 38 or 70))
    row.icon:SetShown(not isOption); row.expand:SetShown(not isOption)
    row.expand:SetScript("OnClick", nil); row.marker:Hide(); row.accent:SetColorTexture(0, 0, 0, 0)
    row.quest:Hide(); row.quest:SetScript("OnClick", nil)
    for i, field in ipairs(row.cols) do
      field:ClearAllPoints(); field:SetPoint("TOPLEFT", nameWidth + cell * (i - 1), -10)
      field:SetWidth(cell - 9); field:SetJustifyH("RIGHT"); field:SetText("")
    end
    row:SetScript("OnClick", nil); row:SetScript("OnEnter", nil); row:Show()
    y = y + height + 3
    return row
  end
  for rank, item in ipairs(W.results or {}) do
    if item.ratio then priced = priced + 1 end
    if W.scannedAt and not item.crateQuote.cost and not unavailable then
      unavailable = true
      local divider = acquire(27, true)
      divider.bg:SetColorTexture(0.04, 0.05, 0.065, 1)
      divider.name:SetWidth(width - 40)
      divider.name:SetText(color(W.scanMode == "fast" and "ORDERS WITHOUT AN ESTIMATE" or "ORDERS UNAVAILABLE TO BUY", MUTED)); divider.sub:SetText("")
    end
    local r = acquire(53)
    local code, qualityText = rarity(item.quality)
    local expanded = p.expanded[item.key]
    if expanded == nil then expanded = W.db.details end
    local recommended = rank == 1 and item.ratio
    r.bg:SetColorTexture(recommended and 0.085 or 0.055, recommended and 0.16 or 0.075, recommended and 0.10 or 0.095, 1)
    if recommended then r.accent:SetColorTexture(0.35, 0.8, 0.3, 1) end
    r.icon:SetTexture((W.books[item.crate.name] and W.books[item.crate.name][1] and W.books[item.crate.name][1].icon) or (writs and "Interface\\Icons\\INV_Misc_Note_01" or W.icon))
    r.expand:SetText(expanded and "-" or "+")
    r.name:SetText(color((writs and (item.crate.bundles[1][1] .. "× ") or "") .. W.OrderName(item.crate), code))
    r.cols[1]:SetText(W.Price(item.crateQuote.cost))
    r.cols[2]:SetText(W.Price(item.best and item.best.quote.cost))
    r.cols[3]:SetText(color(W.Price(item.total), item.total and GOLD or MUTED))
    local description = "Lvl. " .. item.crate.tier
    if item.rewardValue then description = description .. " · +" .. item.rewardValue .. " " .. item.rewardLabel
    else description = description .. " · Reward unknown" end
    if not W.scannedAt then description = description .. " · Run a scan to get prices"
    elseif not item.crateQuote.cost then description = description .. " · " .. W.CrateStatus(item.crateQuote)
    elseif not item.total then description = description .. (W.scanMode == "fast" and " · Incomplete estimate: run Full Scan to verify" or " · Missing materials: use + for details")
    elseif item.best then description = description .. " · " .. item.best.quantity .. "× " .. item.best.name end
    r.sub:SetText(color(description, (not W.scannedAt or item.total) and MUTED or "|cffffac79"))
    if writs then
      r.sub:SetText(color((item.reputation and ("+" .. item.reputation .. " rep · ") or "") .. W.WritDestination(item.crate), MUTED))
      r.sub:SetWidth(width - 140)
      if W.WritIsActive(item.crate) then
        r.quest:Show(); r.quest:SetScript("OnClick", function() W.OpenWritQuest(item.crate) end)
      end
    end
    r.expand:SetScript("OnClick", function() GameTooltip:Hide(); p.expanded[item.key] = not expanded; W.Draw() end)
    r:SetScript("OnClick", function() W.SearchInBuy(item.crate.name) end)
    r:SetScript("OnEnter", function(self)
      planTooltip(self, item.crate.name .. " · " .. qualityText, item.crateQuote)
      GameTooltip:AddDoubleLine(writs and "Writ" or "Crate", W.Price(item.crateQuote.cost), 0.8, 0.85, 0.9, 1, 1, 1)
      GameTooltip:AddDoubleLine(writs and "Required goods" or "Recommended materials", W.Price(item.best and item.best.quote.cost), 0.8, 0.85, 0.9, 1, 1, 1)
      valueTooltip(item, item.total)
      if writs then W.AddWritDetails(GameTooltip, item.crate) end
      if recommended then GameTooltip:AddLine(writs and "Best cost per reputation among the displayed writs." or "Best Favor efficiency among the displayed crates.", 0.35, 1, 0.3) end
      if not item.total then
        for _, bundle in ipairs(item.bundles) do
          if not bundle.quote.cost then GameTooltip:AddLine(bundle.quantity .. "× " .. bundle.name .. " : " .. W.Reason(bundle.quote), 1, 0.68, 0.47, true) end
        end
      end
      GameTooltip:AddLine("Click to search for this order in Buy. Use + / - for required goods.", 0.65, 0.7, 0.78, true)
      if W.scanning then GameTooltip:AddLine("Opening Buy stops this scan and keeps the previous snapshot.", 1, 0.68, 0.47, true) end
      GameTooltip:Show()
    end)
    if expanded then
      for _, bundle in ipairs(item.bundles) do
        local option = acquire(49, true)
        local bestOption = bundle == item.best
        option.bg:SetColorTexture(bestOption and 0.065 or 0.03, bestOption and 0.13 or 0.04, bestOption and 0.08 or 0.055, 1)
        option.marker:SetShown(bestOption)
        if bestOption then option.accent:SetColorTexture(0.35, 0.8, 0.3, 1) end
        local optionName = bundle.quantity .. "× " .. bundle.name
        option.name:SetText(bestOption and color(optionName, GREEN) or optionName)
        option.cols[2]:SetText(W.Price(bundle.quote.cost))
        local total = bundle.quote.cost and item.crateQuote.cost and bundle.quote.cost + item.crateQuote.cost
        option.cols[3]:SetText(W.Price(total))
        local detail = W.Reason(bundle.quote)
        if bestOption then detail = color(writs and "Required goods" or "Best option", GREEN) .. " · " .. detail end
        option.sub:SetText(color(detail, (bundle.quote.cost or bundle.quote.reason == "skipped") and MUTED or "|cffffac79"))
        option:SetScript("OnEnter", function(self)
          planTooltip(self, bundle.quantity .. "× " .. bundle.name, bundle.quote)
          valueTooltip(item, total)
          GameTooltip:AddLine("Click to search for this material in Buy.", 0.65, 0.7, 0.78)
          if W.scanning then GameTooltip:AddLine("Opening Buy stops this scan and keeps the previous snapshot.", 1, 0.68, 0.47, true) end
          GameTooltip:Show()
        end)
        option:SetScript("OnClick", function() W.SearchInBuy(bundle.name) end)
      end
    end
  end
  for i = used + 1, #p.rows do p.rows[i]:Hide() end
  local empty = #(W.results or {}) == 0
  p.empty:SetText(empty and "No orders match these filters. Right-click the minimap icon for settings." or "")
  p.content:SetHeight(math.max(y, p.scroll:GetHeight(), 70))
  p.scroll:UpdateScrollChildRect()
  p.scroll:SetVerticalScroll(math.min(p.scroll:GetVerticalScroll(), math.max(0, p.content:GetHeight() - p.scroll:GetHeight())))
  local best = W.results and W.results[1]
  if best and best.ratio then
    p.summary:SetText(color(W.scanMode == "fast" and "Best estimated value: " or "Best value: ", GREEN) .. W.OrderName(best.crate) .. " · " .. W.Price(best.total) .. " total · +" .. best.rewardValue .. " " .. best.rewardLabel)
  else p.summary:SetText(W.scannedAt and "No reward ratio available. Unranked orders use total cost; check prices and reward settings." or "Scan this view to compare prices and rewards.") end
  if W.scanning then
    p.status:SetText(W.message or "Scanning…"); p.status:SetTextColor(1, 0.82, 0.45)
  elseif W.scannedAt then
    local age = math.max(0, math.floor((time() - W.scannedAt) / 60))
    local stamp = W.scanTimeUnknown and "Snapshot date unknown" or ("Snapshot " .. date("%d/%m %H:%M", W.scannedAt) .. " · " .. age .. " min")
    p.status:SetText((W.scanMode == "fast" and "FAST · Estimates · " or "FULL · ") .. stamp .. " · " .. (W.message or (priced .. " priced options")) .. (W.incomplete and " · INCOMPLETE" or ""))
    p.status:SetTextColor(age >= 15 and 1 or 0.7, age >= 15 and 0.65 or 0.78, age >= 15 and 0.35 or 0.86)
  else p.status:SetText(W.message or "Choose Fast Scan for estimates or Full Scan to verify prices.") end
end

