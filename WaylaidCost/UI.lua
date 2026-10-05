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
  if q.cost and q.isCommodity then return string.format("%d available · %d needed", q.available, q.required) end
  if q.cost then return string.format("%d available · %d required · %d purchased · %d surplus", q.available, q.required, q.purchased, q.extra) end
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
  f:SetPoint("TOPLEFT", x, y); f:SetJustifyH("LEFT"); f:SetText(W.Text(W.L(text)))
  return f
end
local function button(parent, text, width, x, y, callback)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(width, 23); b:SetPoint("TOPRIGHT", x, y); b:SetText(W.Text(W.L(text))); b:SetScript("OnClick", callback)
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
  GameTooltip:AddLine(W.Text(name), 1, 0.82, 0.45)
  GameTooltip:AddLine(W.Text(W.Reason(q)), 0.85, 0.88, 0.94, true)
  if not W.ShowTooltipExplanations() then
    if q.cost then
      GameTooltip:AddDoubleLine(W.Text(q.isCommodity and "Cost for the required quantity" or "Total for whole stacks"), W.Price(q.cost), 0.8, 0.85, 0.9, 1, 1, 1)
      if q.extra and q.extra > 0 then
        GameTooltip:AddLine(W.Text("  Whole stacks: " .. q.purchased .. " purchased, " .. q.extra .. " extra."), 1, 0.68, 0.47, true)
      end
    end
    GameTooltip:AddLine(W.Text(q.estimated and "Fast Scan · estimate, stock not verified" or "Snapshot prices: check the auctions before buying."), 0.7, 0.75, 0.82, true)
    if q.mayIncludeOwn then GameTooltip:AddLine(W.Text("Summary stock includes your auctions; purchasable prices are not verified."), 1, 0.68, 0.47, true) end
    return
  end
  if q.estimated then
    if q.estimateUnitPrice then
      GameTooltip:AddDoubleLine(W.Text("Lowest listed price"),W.Text(W.Money(q.estimateUnitPrice)), 0.8, 0.85, 0.9, 1, 1, 1)
      GameTooltip:AddDoubleLine(W.Text("Estimate for " .. q.required),W.Text("≈ " .. W.Money(q.cost)), 1, 0.82, 0.45, 1, 1, 1)
    end
    GameTooltip:AddLine(W.Text("Fast Scan assumes the lowest price for the required quantity. Price tiers, stacks, sellers and buyout availability are not verified."), 1, 0.68, 0.47, true)
    if q.mayIncludeOwn then GameTooltip:AddLine(W.Text("This summary includes your auctions. Their share of the stock and purchasable prices have not been checked."), 1, 0.68, 0.47, true) end
    GameTooltip:AddLine(W.Text("Run Full Scan to verify prices and quantities before choosing."), 0.7, 0.8, 0.9, true)
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
      GameTooltip:AddDoubleLine(W.Text(offer.count .. " × " .. W.Money(offer.unitPrice) .. " / unit"),W.Text(W.Money(offer.buyout)), 1, 1, 1, 1, 1, 1)
    else
      GameTooltip:AddDoubleLine(W.Text(group.n .. " stack(s) of " .. offer.count),W.Text(W.Money(offer.buyout) .. " / stack"), 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine(W.Text("  " .. W.Money(offer.buyout / offer.count) .. " / unit (rounded)"), 0.65, 0.7, 0.78)
    end
  end
  if q.cost then GameTooltip:AddDoubleLine(W.Text(q.isCommodity and "Cost for the required quantity" or "Total for whole stacks"),W.Text(W.Money(q.cost)), 1, 0.82, 0.45, 1, 1, 1) end
  if q.cost then GameTooltip:AddDoubleLine(W.Text("Average price per purchased unit"),W.Text(W.Money(q.cost / (q.purchased or q.required))), 0.8, 0.85, 0.9, 1, 1, 1) end
  if q.cost and q.extra and q.extra > 0 then
    GameTooltip:AddLine(W.Text("This price includes the full auction stack. Surplus items are not needed for this turn-in."), 0.8, 0.85, 0.9, true)
  end
  if q.bidOnly > 0 then GameTooltip:AddLine(W.Text(q.bidOnly .. " bid-only units excluded"), 0.7, 0.7, 0.7) end
  if q.own > 0 then GameTooltip:AddLine(W.Text(q.own .. " units from your own auctions excluded"), 0.7, 0.7, 0.7) end
  GameTooltip:AddLine(W.Text("Snapshot prices: check the auctions before buying."), 0.6, 0.65, 0.7, true)
  GameTooltip:Show()
end

local function searchTooltip(owner, name)
  name = W.ItemLabel(name)
  -- Anchor the action hint to the name button, not the moving cursor.
  -- Detailed row prices keep the separate ANCHOR_RIGHT placement.
  GameTooltip:SetOwner(owner, "ANCHOR_TOPLEFT")
  GameTooltip:AddLine(W.Text("Click to search in the Buy tab"), 1, 0.82, 0.45)
  GameTooltip:AddLine(W.Text(name), 0.85, 0.88, 0.94, true)
  if W.scanning then GameTooltip:AddLine(W.Text("Stops this scan and keeps the previous snapshot."), 1, 0.68, 0.47, true) end
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
  label(settings, "WaylaidCost — " .. W.L("Settings"), 15, -14, "GameFontNormalLarge")
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
  -- Reserve more room for the client's full currency name; long translations
  -- wrap inside the button instead of extending into the neighbouring tabs.
  local tabWidths, tabLeft = {82, 82, 151, 82}, 15
  for i, name in ipairs({"Display", "Tooltips", "Favor", "About"}) do
    local index = i
    local width = tabWidths[i]
    local tab = button(settings, name, width, tabLeft + width - 445, -39, function() selectTab(index) end)
    tab:SetHeight(32)
    local text = tab:GetFontString()
    if text then
      text:SetWidth(width - 12); text:SetHeight(28)
      text:SetWordWrap(true)
    end
    tab:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine(W.Text(name), 1, 0.82, 0.45, true)
      GameTooltip:Show()
    end)
    tab:SetScript("OnLeave", function() GameTooltip:Hide() end)
    settings.tabs[i] = tab
    tabLeft = tabLeft + width + 6
  end
  label(options, "Changes are applied and saved automatically.", 15, -40)
  label(options, "Display", 15, -67, "GameFontNormal")
  settings.checks, settings.edits = {}, {}
  local function help(control, title, text)
    control:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:AddLine(W.Text(title), 1, 0.82, 0.45)
      GameTooltip:AddLine(W.Text(text), 0.85, 0.88, 0.94, true)
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
      if key == "showMinimap" then W.SetMinimapVisible(value) end
      if key == "enableWrits" then W.SetOrderKind("waylaid") end
      W.Refresh()
    end)
    if description then help(b, text, description) end
    return b
  end
  check("details", "Show details for all orders", 12, -84)
  check("levelOnly", "Hide orders above my level", 12, -110, false, options,
    "Uses the catalog's listed level only. This does not check writ quest eligibility, profession skill or reputation requirements.")
  check("common", color("Common crates", WHITE), 12, -136):SetHitRectInsets(0, -180, 0, 0)
  check("uncommon", color("Uncommon crates", GREEN), 237, -136):SetHitRectInsets(0, -170, 0, 0)
  check("showMinimap", "Show the minimap icon", 12, -162, false, options,
    "Left-click opens Waylaid at the auction house. Right-click opens settings. If hidden, use /wcrate config.")
  check("enableWrits", "Enable Craftsman's Writs", 12, -204, false, options,
    "Enabled by default for new settings. Adds the Craftsman's Writs tab and item tooltips. Prices cover the writ and requested finished goods. Writs rank by cost per base reputation. Each tab is scanned separately.")
  label(options, "Using the results", 15, -284, "GameFontNormal")
  local tips = label(options, "Click an item name to search in the Buy tab.\nClick the row or arrow to show or hide required items.\nChoose Waylaid Crates or Craftsman's Writs in the AH.\nUse Available to buy beside the tabs to hide unlisted orders.", 15, -310)
  tips:SetWidth(405)
  label(tooltips, "Item tooltips", 15, -48, "GameFontNormalLarge")
  check("itemTooltips", "Show prices on crate / writ item tooltips", 12, -80, false, tooltips,
    "Adds cached goods prices when hovering a crate or enabled writ in your bags, the auction house, or an item link. Disabling this only hides WaylaidCost's section.")
  label(tooltips, "Explanations", 15, -132, "GameFontNormal")
  local explanation = "Explains the cheapest option, rounded unit averages and Fast/Full Scan data. Prices, missing stock and the scan date stay visible. Hold Shift and hover the item again to reveal explanations in Shift mode."
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
  local rewardNote = label(rewards, "Apprentice: 5 / 10. Journeyman: 10 / 20. Expert: 15 / 30.\nArtisan: unconfirmed; leave blank if unknown.\nSource: beta reports, checked 4 Oct 2026.\nPerformance Bonus can double Favor and is excluded.\nThese settings do not change in-game rewards.", 15, -306)
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
    for _, edit in ipairs(settings.edits) do edit:SetText(W.Text(tostring((W.db.rewards[edit.family] or {})[edit.quality] or ""))) end
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

function W.ShowSettings()
  if not W.db then return end
  if not W.settings then buildSettings() end
  W.settings:Show()
end

function W.SetMinimapVisible(value)
  W.db.showMinimap = value and true or false
  if W.minimap then W.minimap:SetShown(W.db.showMinimap) end
  if W.optionsPanel then W.optionsPanel.minimap:SetChecked(W.db.showMinimap) end
  if W.settings then
    for _, check in ipairs(W.settings.checks) do
      if check.key == "showMinimap" then check:SetChecked(W.db.showMinimap) end
    end
  end
end

function W.RegisterOptions()
  if W.optionsPanel or not W.db then return end
  local modern = Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory
  if not modern and not InterfaceOptions_AddCategory then return end
  local panel = CreateFrame("Frame")
  panel.name = "WaylaidCost"
  panel:Hide()
  label(panel, "WaylaidCost", 16, -16, "GameFontNormalLarge")
  local check = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  check:SetSize(24, 24); check:SetPoint("TOPLEFT", 16, -55)
  local caption = label(check, "Show the minimap icon", 28, -5)
  caption:SetWidth(360)
  check:SetHitRectInsets(0, -360, 0, 0)
  check:SetScript("OnClick", function(self) W.SetMinimapVisible(self:GetChecked()) end)
  panel.minimap = check
  panel:SetScript("OnShow", function() check:SetChecked(W.db.showMinimap) end)
  local open = button(panel, "Settings", 220, 0, 0, function()
    GameTooltip:Hide()
    if HideUIPanel then
      if SettingsPanel then HideUIPanel(SettingsPanel) end
      if InterfaceOptionsFrame then HideUIPanel(InterfaceOptionsFrame) end
    end
    W.ShowSettings()
  end)
  open:ClearAllPoints(); open:SetPoint("TOPLEFT", 16, -100)
  panel.openSettings = open
  W.optionsPanel = panel
  if modern then
    W.optionsCategory = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(W.optionsCategory)
  else
    InterfaceOptions_AddCategory(panel)
  end
end

local function releaseRow(row)
  row:Hide()
  row:SetScript("OnClick", nil); row:SetScript("OnEnter", nil)
  row.search:SetScript("OnClick", nil); row.search:SetScript("OnEnter", nil)
  row.expand:SetScript("OnClick", nil); row.quest:SetScript("OnClick", nil)
  row.name:SetText(W.Text("")); row.sub:SetText(W.Text("")); row.icon:SetTexture(nil)
  row.costLabel:SetText(W.Text("")); row.goodsLabel:SetText(W.Text("")); row.goodsCost:SetText(W.Text(""))
  for _, field in ipairs(row.cols) do field:SetText(W.Text("")) end
end

function W.ReleaseResults()
  W.results = nil
  W.goalCache = nil
  -- Keep the reusable frames, but release closures that retain old quotes and
  -- purchase plans (including rows left over from a larger previous view).
  if W.panel then
    for _, row in ipairs(W.panel.rows) do releaseRow(row) end
  end
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
  local title = label(panel, W.title, 0, 0, "GameFontNormalLarge")
  title:ClearAllPoints(); title:SetPoint("LEFT", icon, "RIGHT", 8, 0)
  title:SetPoint("TOPRIGHT", panel, "TOPRIGHT", W.Locale() == "enUS" and -240 or -320, -10); title:SetHeight(24)
  panel.title = title
  panel.viewTabs = {}
  for i, entry in ipairs({{"waylaid", "Waylaid Crates", 145}, {"writs", "Craftsman's Writs", 175}}) do
    local kind = entry[1]
    local tab = CreateFrame("Button", nil, panel)
    tab:SetSize(W.Locale() == "enUS" and entry[3] or (i == 1 and 170 or 180), 28)
    tab:SetPoint("TOPLEFT", i == 1 and 15 or (W.Locale() == "enUS" and 164 or 189), -44)
    tab.bg = tab:CreateTexture(nil, "BACKGROUND"); tab.bg:SetAllPoints()
    tab.selectedLine = tab:CreateTexture(nil, "ARTWORK")
    tab.selectedLine:SetPoint("BOTTOMLEFT", 0, 0); tab.selectedLine:SetPoint("BOTTOMRIGHT", 0, 0); tab.selectedLine:SetHeight(2)
    tab.selectedLine:SetColorTexture(0.95, 0.77, 0.35, 1)
    tab.label = label(tab, entry[2], 0, 0, "GameFontNormal")
    tab.label:ClearAllPoints(); tab.label:SetPoint("CENTER")
    tab:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight", "ADD")
    tab:SetScript("OnClick", function() GameTooltip:Hide(); W.SetOrderKind(kind) end)
    tab:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
      GameTooltip:AddLine(W.Text(entry[2]), 1, 0.82, 0.45)
      GameTooltip:AddLine(W.Text("Each tab keeps its own scan. Switching tabs stops an active scan."), 0.8, 0.85, 0.9, true)
      GameTooltip:Show()
    end)
    tab:SetScript("OnLeave", function() GameTooltip:Hide() end)
    panel.viewTabs[kind] = tab
  end
  panel.available = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
  panel.available:SetSize(24, 24); panel.available:SetPoint("TOPRIGHT", -162, -46)
  panel.available:SetHitRectInsets(0, -145, 0, 0)
  label(panel.available, "Available to buy", 25, -6)
  panel.available:SetScript("OnClick", function(self)
    W.db.showUnavailable = not self:GetChecked()
    panel.scroll:SetVerticalScroll(0); W.Refresh()
  end)
  panel.available:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:AddLine(W.Text("Available to buy"), 1, 0.82, 0.45)
    GameTooltip:AddLine(W.Text("Show orders with a buyout price in the saved scan. Goods may still be missing. Fast Scan availability is estimated."), 0.8, 0.85, 0.9, true)
    GameTooltip:Show()
  end)
  panel.available:SetScript("OnLeave", function() GameTooltip:Hide() end)
  W.BuildProgress(panel)
  panel.summary = label(panel, "", 15, -84)
  panel.summary:SetPoint("TOPRIGHT", -365, -84)
  panel.summary:SetHeight(32)
  panel.fast = button(panel, "Fast Scan", W.Locale() == "enUS" and 100 or 140, W.Locale() == "enUS" and -124 or -164, -11, function() W.Scan("fast") end)
  panel.fast:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:AddLine(W.Text("Fast Scan — estimate"), 1, 0.82, 0.45)
    GameTooltip:AddLine(W.Text("Reads summaries for this view's orders and required goods. Lowest price × required quantity, without checking price tiers or sellers."), 1, 1, 1, true)
    GameTooltip:AddLine(W.Text("Estimated prices are marked ≈. Scan time depends on auction house responses and result pages."), 0.7, 0.8, 0.9, true)
    GameTooltip:Show()
  end)
  panel.fast:SetScript("OnLeave", function() GameTooltip:Hide() end)
  panel.scan = button(panel, "Full Scan", 100, -14, -11, function() W.Scan("full") end)
  panel.scan:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:AddLine(W.Text("Full Scan — verified prices and quantities"), 1, 0.82, 0.45)
    GameTooltip:AddLine(W.Text("Checks this view's orders, then their required goods or filling options. Requests respect the server limits."), 1, 1, 1, true)
    GameTooltip:AddLine(W.Text("Stay in this tab while scanning. Click the button again to stop. The last successful snapshot is saved."), 0.7, 0.8, 0.9, true)
    GameTooltip:Show()
  end)
  panel.scan:SetScript("OnLeave", function() GameTooltip:Hide() end)
  panel.orderHeader = label(panel, "Crate / recommended fill", 17, -128, "GameFontNormalSmall")
  panel.headers = {}
  for i, text in ipairs({ "Crate / Materials", "Cost / Favor", "Total cost" }) do
    panel.headers[i] = label(panel, text, 0, -128, "GameFontNormalSmall")
  end
  local efficiencyHelp = CreateFrame("Frame", nil, panel)
  efficiencyHelp:SetAllPoints(panel.headers[2]); efficiencyHelp:EnableMouse(true)
  efficiencyHelp:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(W.Text(W.IsWritView() and "Cost / Rep" or "Cost / Favor"), 1, 0.82, 0.45, true)
    GameTooltip:AddLine(W.Text("Sorted by the unrounded ratio; displayed amounts are rounded up to the next copper."), 0.7, 0.75, 0.82, true)
    GameTooltip:Show()
  end)
  efficiencyHelp:SetScript("OnLeave", function() GameTooltip:Hide() end)
  local scroll = CreateFrame("ScrollFrame", "WaylaidCostScrollFrame", panel, "UIPanelScrollFrameTemplate")
  panel.scroll = scroll
  scroll:SetPoint("TOPLEFT", 12, -149); scroll:SetPoint("BOTTOMRIGHT", -31, 57)
  local content = CreateFrame("Frame", nil, scroll); content:SetSize(1, 1); scroll:SetScrollChild(content)
  panel.content = content
  scroll:EnableMouseWheel(true)
  scroll:SetScript("OnMouseWheel", function(self, delta)
    self:SetVerticalScroll(math.max(0, math.min(self:GetVerticalScrollRange(), self:GetVerticalScroll() - delta * 48)))
  end)
  panel.status = label(panel, "", 15, 0); panel.status:ClearAllPoints()
  panel.status:SetPoint("BOTTOMLEFT", 15, 32); panel.status:SetPoint("BOTTOMRIGHT", -15, 32)
  panel.status:SetJustifyH("LEFT")
  panel.note = label(panel, "", 15, 0)
  panel.note:ClearAllPoints(); panel.note:SetPoint("BOTTOMLEFT", 15, 13); panel.note:SetTextColor(0.55, 0.61, 0.7)
  panel.note:SetPoint("BOTTOMRIGHT", -15, 13)
  panel.scanInfo = CreateFrame("Frame", nil, panel)
  panel.scanInfo:SetPoint("BOTTOMLEFT", 15, 28); panel.scanInfo:SetPoint("BOTTOMRIGHT", -15, 28); panel.scanInfo:SetHeight(20)
  panel.scanInfo:EnableMouse(true)
  panel.scanInfo:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(W.Text("Scan details"), 1, 0.82, 0.45)
    if W.scannedAt then
      GameTooltip:AddLine(W.Text(W.scanTimeUnknown and "Snapshot date unknown" or ("Last scan: " .. date("%Y-%m-%d %H:%M", W.scannedAt) .. " (local time)")), 0.8, 0.85, 0.9)
      GameTooltip:AddLine(W.Text(W.scanMode == "fast" and "Estimates; stock at the lowest price is not verified." or "Recorded prices and quantities; auctions may have changed."), 0.8, 0.85, 0.9, true)
    end
    if W.message then GameTooltip:AddLine(W.Text(W.message), 0.8, 0.85, 0.9, true) end
    GameTooltip:Show()
  end)
  panel.scanInfo:SetScript("OnLeave", function() GameTooltip:Hide() end)
  panel.empty = label(content, "", 10, -20); panel.empty:SetWidth(600)

  panel:SetScript("OnSizeChanged", function() if W.results then W.Draw() end end)
  panel:SetScript("OnShow", function() W.Refresh() end)
  panel:SetScript("OnHide", function()
    panel.progress.editor:Hide()
    W.CancelScan("Scan cancelled: left the tab")
    W.ReleaseResults()
    GameTooltip:Hide()
  end)
  panel:Hide()
end

local function valueTooltip(item, total)
  GameTooltip:AddLine(W.Text(" "))
  GameTooltip:AddDoubleLine(W.Text(W.scanMode == "fast" and "Estimated total (not verified)" or "Total cost"),W.Text(W.Price(total)), 1, 0.82, 0.45, 1, 1, 1)
  GameTooltip:AddDoubleLine(W.Text(item.crate.kind == "writ" and "Base reputation" or "Merchant Favor"),W.Text(item.rewardValue and tostring(item.rewardValue) or "Unknown / not set"), 0.8, 0.85, 0.9, 1, 1, 1)
  if total and item.rewardValue then
    GameTooltip:AddDoubleLine(W.Text("Cost / " .. item.rewardLabel),W.Price(total / item.rewardValue), 0.8, 0.85, 0.9, 1, 1, 1)
    if W.ShowTooltipExplanations() then
      GameTooltip:AddLine(W.Text("Sorted by the unrounded ratio; displayed amounts are rounded up to the next copper."), 0.6, 0.65, 0.7, true)
    end
  end
end

local function tooltipHint()
  if W.db.tooltipExplanations == "shift" and not W.ShowTooltipExplanations() then
    GameTooltip:AddLine(W.Text("Hold Shift and hover again for explanations"), 0.55, 0.61, 0.7, true)
  end
end

function W.EfficiencyHeading()
  if W.IsWritView() then return W.Text("Cost / Rep") end
  local info = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(3402)
  if not info or not info.iconFileID then return W.Text("Cost / Favor") end
  local template = W.dictionary and W.dictionary["Cost / Favor"] or "Cost / {favor}"
  return W.SafeText((template:gsub("{favor}", function() return "|T" .. info.iconFileID .. ":14:14|t" end)))
end

function W.Price(value)
  return (W.scanMode == "fast" and value ~= nil and "≈ " or "") .. W.Money(value)
end
function W.Draw()
  local p = W.panel
  if not p or not p:IsShown() then return end
  local writs = W.IsWritView()
  W.UpdateProgress()
  p.viewTabs.writs:SetShown(W.db.enableWrits)
  for kind, tab in pairs(p.viewTabs) do
    local selected = kind == (writs and "writs" or "waylaid")
    tab.selected = selected
    tab.selectedLine:SetShown(selected)
    tab.bg:SetColorTexture(selected and 0.13 or 0.055, selected and 0.16 or 0.075, selected and 0.20 or 0.095, 1)
    tab.label:SetTextColor(selected and 1 or 0.65, selected and 0.87 or 0.71, selected and 0.55 or 0.79)
  end
  p.available:SetChecked(not W.db.showUnavailable)
  p.available:SetEnabled(W.scannedAt ~= nil)
  p.headers[1]:SetText(W.Text(writs and "Writ / Goods" or "Crate / Materials"))
  p.headers[2]:SetText(W.EfficiencyHeading())
  p.orderHeader:SetText(W.Text(writs and "Writ / required goods" or "Crate / recommended fill"))
  p.scan:SetText(W.Text(W.L(W.scanning and W.runningMode == "full" and "Stop" or "Full Scan")))
  p.fast:SetText(W.Text(W.L(W.scanning and W.runningMode == "fast" and "Stop" or "Fast Scan")))
  p.scan:SetWidth(W.Locale() == "enUS" and 110 or 150)
  if W.scanning and W.runningMode ~= "full" then p.scan:Disable() else p.scan:Enable() end
  if W.scanning and W.runningMode ~= "fast" then p.fast:Disable() else p.fast:Enable() end
  p.headers[3]:SetText(W.Text(W.L(W.scanMode == "fast" and "Estimated total" or "Total cost")))
  local width = math.max(1, p.scroll:GetWidth())
  p.content:SetWidth(width)
  local nameWidth = math.floor(width * (writs and 0.40 or 0.43))
  local costWidth = math.floor(width * (writs and 0.32 or 0.28))
  local costLabelWidth = writs and math.max(112, costWidth - 112) or 86
  local cell = (width - nameWidth - costWidth) / 2
  local columnX = {nameWidth, nameWidth + costWidth, nameWidth + costWidth + cell}
  local columnWidth = {costWidth, cell, cell}
  for i, h in ipairs(p.headers) do
    h:ClearAllPoints(); h:SetPoint("TOPLEFT", 12 + columnX[i], -128)
    h:SetWidth(columnWidth[i] - 9); h:SetJustifyH("RIGHT")
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
      row.search = CreateFrame("Button", nil, row)
      row.search:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight", "ADD")
      row.search:SetScript("OnLeave", function() GameTooltip:Hide() end)
      row.sub = label(row, "", 53, -29)
      row.cols = {}
      for i = 1, 3 do row.cols[i] = label(row, "", 0, -10, i == 3 and "GameFontHighlight" or "GameFontHighlightSmall") end
      row.costLabel = label(row, "", 0, -10)
      row.goodsLabel = label(row, "", 0, -29)
      row.goodsCost = label(row, "", 0, -29)
      row.extraCost = label(row, "", 0, -29)
      row:SetScript("OnLeave", function() GameTooltip:Hide() end)
      p.rows[used] = row
    end
    row:ClearAllPoints(); row:SetPoint("TOPLEFT", 0, -y); row:SetSize(width, height)
    row.name:ClearAllPoints(); row.name:SetPoint("TOPLEFT", isOption and 46 or 63, -8)
    row.name:SetWidth(nameWidth - (isOption and 55 or 70))
    row.name:SetHeight(16)
    row.search:ClearAllPoints(); row.search:SetPoint("TOPLEFT", isOption and 24 or 63, -4)
    row.search:SetSize(nameWidth - (isOption and 33 or 70), 22)
    row.search:SetScript("OnClick", nil); row.search:SetScript("OnEnter", nil)
    row.search:Show()
    row.sub:ClearAllPoints(); row.sub:SetPoint("TOPLEFT", isOption and 29 or 63, -29)
    row.sub:SetWidth(nameWidth - (isOption and 38 or 70)); row.sub:SetHeight(16)
    row.icon:SetShown(not isOption); row.expand:SetShown(not isOption)
    row.icon:ClearAllPoints()
    row.icon:SetSize(isOption and 16 or 26, isOption and 16 or 26)
    row.icon:SetPoint("TOPLEFT", isOption and 24 or 29, isOption and -8 or -10)
    row.icon:SetTexture(nil)
    row.expand:SetScript("OnClick", nil); row.marker:Hide(); row.accent:SetColorTexture(0, 0, 0, 0)
    row.quest:Hide(); row.quest:SetScript("OnClick", nil)
    for i, field in ipairs(row.cols) do
      local inset = i == 1 and not isOption and costLabelWidth or 0
      field:ClearAllPoints(); field:SetPoint("TOPLEFT", columnX[i] + inset, -10)
      field:SetWidth(columnWidth[i] - inset - 9); field:SetJustifyH("RIGHT"); field:SetText(W.Text(""))
    end
    for i, field in ipairs({row.costLabel, row.goodsLabel}) do
      field:ClearAllPoints(); field:SetPoint("TOPLEFT", nameWidth, i == 1 and -10 or -29)
      field:SetWidth(costLabelWidth - 4); field:SetHeight(writs and not isOption and i == 2 and 28 or 16)
      field:SetJustifyV("TOP")
      field:SetText(W.Text("")); field:SetTextColor(0.65, 0.71, 0.79)
    end
    row.goodsCost:ClearAllPoints(); row.goodsCost:SetPoint("TOPLEFT", nameWidth + costLabelWidth, -29)
    row.goodsCost:SetWidth(costWidth - costLabelWidth - 9); row.goodsCost:SetJustifyH("RIGHT"); row.goodsCost:SetText(W.Text(""))
    row.extraCost:ClearAllPoints(); row.extraCost:SetPoint("TOPLEFT", columnX[3], -29)
    row.extraCost:SetWidth(columnWidth[3] - 9); row.extraCost:SetJustifyH("RIGHT")
    row.extraCost:SetText(""); row.extraCost:SetTextColor(1, 0.82, 0.45)
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
      divider.search:Hide()
      divider.name:SetText(W.Text(color(W.scanMode == "fast" and "ORDERS WITHOUT AN ESTIMATE" or "ORDERS UNAVAILABLE TO BUY", MUTED))); divider.sub:SetText(W.Text(""))
    end
    local r = acquire(writs and 65 or 53)
    local code, qualityText = rarity(item.quality)
    local expanded = p.expanded[item.key]
    if expanded == nil then expanded = W.db.details end
    local recommended = rank == 1 and item.ratio
    r.bg:SetColorTexture(recommended and 0.085 or 0.055, recommended and 0.16 or 0.075, recommended and 0.10 or 0.095, 1)
    if recommended then r.accent:SetColorTexture(0.35, 0.8, 0.3, 1) end
    r.icon:SetTexture((W.books[item.crate.name] and W.books[item.crate.name][1] and W.books[item.crate.name][1].icon) or (writs and "Interface\\Icons\\INV_Misc_Note_01" or W.icon))
    r.expand:SetText(W.Text(expanded and "v" or ">"))
    r.name:SetText(W.Text(color((writs and (item.crate.bundles[1][1] .. "× ") or "") .. W.OrderName(item.crate), code)))
    local purchased = item.crateQuote.purchased or 1
    if writs then
      local required = item.crate.bundles[1]
      r.costLabel:SetText(W.Text("Craftsman's Writ:"))
      r.goodsLabel:SetText(W.Text(required[1] == 1 and string.format("%s:", W.ItemLabel(required[2])) or string.format("%d × %s:", required[1], W.ItemLabel(required[2]))))
    else
      r.costLabel:SetText(W.Text(purchased == 1 and "%d crate" or "%d crates", purchased))
      r.goodsLabel:SetText(W.Text("Materials total"))
    end
    r.cols[1]:SetText(W.Text(W.Price(item.crateQuote.cost)))
    r.goodsCost:SetText(W.Text(W.Price(item.best and item.best.quote.cost)))
    r.cols[2]:SetText(W.Text(color(W.Price(item.ratio), recommended and GREEN or (item.ratio and GOLD or MUTED))))
    r.cols[3]:SetText(W.Text(color(W.Price(item.total), item.total and GOLD or MUTED)))
    local description = item.rewardValue and ("+" .. item.rewardValue .. " " .. item.rewardLabel) or "Reward unknown"
    if not W.scannedAt then description = description .. " · Run a scan to get prices"
    elseif not item.crateQuote.cost then description = description .. " · " .. W.CrateStatus(item.crateQuote)
    elseif not item.total then description = description .. (W.scanMode == "fast" and " · Incomplete estimate" or " · Missing materials")
    elseif item.best then description = description .. " · " .. item.best.quantity .. "× " .. W.ItemLabel(item.best.name) end
    r.sub:SetText(W.Text(color(description, (not W.scannedAt or item.total) and MUTED or "|cffffac79")))
    if writs then
      r.sub:SetText(W.Text(color((item.reputation and ("+" .. item.reputation .. " rep · ") or "") .. W.WritDestination(item.crate), MUTED)))
      if W.WritIsActive(item.crate) then
        r.quest:Show(); r.quest:SetScript("OnClick", function() W.OpenWritQuest(item.crate) end)
      end
    end
    local function toggleDetails()
      GameTooltip:Hide(); p.expanded[item.key] = not expanded; W.Draw()
    end
    r.expand:SetScript("OnClick", toggleDetails)
    r:SetScript("OnClick", toggleDetails)
    r.search:SetScript("OnClick", function() W.SearchInBuy(item.crate.name) end)
    local function showOrder(self)
      if W.ShowTooltipExplanations() then
        planTooltip(self, W.ItemLabel(item.crate.name) .. " · " .. qualityText, item.crateQuote)
      else
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(W.Text(W.ItemLabel(item.crate.name) .. " · " .. qualityText), 1, 0.82, 0.45)
        if not item.crateQuote.cost or item.crateQuote.estimated then
          GameTooltip:AddLine(W.Text(W.Reason(item.crateQuote)), 1, 0.68, 0.47, true)
        end
        if item.crateQuote.extra and item.crateQuote.extra > 0 then
          GameTooltip:AddLine(W.Text("  Whole stacks: " .. item.crateQuote.purchased .. " purchased, " .. item.crateQuote.extra .. " extra."), 1, 0.68, 0.47, true)
        end
        GameTooltip:AddLine(W.Text(W.scanMode == "fast" and "Fast Scan · estimate, stock not verified" or "Snapshot prices: check the auctions before buying."), 0.65, 0.7, 0.78, true)
        if item.crateQuote.mayIncludeOwn then GameTooltip:AddLine(W.Text("Summary stock includes your auctions; purchasable prices are not verified."), 1, 0.68, 0.47, true) end
      end
      GameTooltip:AddDoubleLine(W.Text(writs and "Writ" or "Crate"),W.Text(W.Price(item.crateQuote.cost)), 0.8, 0.85, 0.9, 1, 1, 1)
      GameTooltip:AddDoubleLine(W.Text(writs and "Required goods" or "Recommended materials"),W.Text(W.Price(item.best and item.best.quote.cost)), 0.8, 0.85, 0.9, 1, 1, 1)
      valueTooltip(item, item.total)
      if writs and W.ShowTooltipExplanations() then W.AddWritDetails(GameTooltip, item.crate) end
      if recommended then GameTooltip:AddLine(W.Text(writs and "Best cost per reputation among the displayed writs." or "Best Favor efficiency among the displayed crates."), 0.35, 1, 0.3) end
      if not item.total then
        for _, bundle in ipairs(item.bundles) do
          if not bundle.quote.cost then GameTooltip:AddLine(W.Text(bundle.quantity .. "× " .. W.ItemLabel(bundle.name) .. " : " .. W.Reason(bundle.quote)), 1, 0.68, 0.47, true) end
        end
      end
      GameTooltip:AddLine(W.Text(expanded and "Click this row to collapse required goods." or "Click this row to expand required goods."), 0.65, 0.7, 0.78, true)
      tooltipHint()
      GameTooltip:Show()
    end
    r:SetScript("OnEnter", showOrder)
    r.search:SetScript("OnEnter", function(self) searchTooltip(self, item.crate.name) end)
    if expanded then
      for _, bundle in ipairs(item.bundles) do
        local option = acquire(49, true)
        local bestOption = bundle == item.best
        option.bg:SetColorTexture(0.03, 0.04, 0.055, 1)
        if bestOption and not writs then option.accent:SetColorTexture(0.35, 0.8, 0.3, 1) end
        local optionName = bundle.quantity .. "× " .. W.ItemLabel(bundle.name)
        -- Reuse the row texture and scan metadata; no AH requests or update loop.
        local book = W.books[bundle.name]
        local icon = book and book[1] and book[1].icon
        local id = W.itemIDs[bundle.name]
        if not icon and id and C_Item and C_Item.GetItemIconByID then icon = C_Item.GetItemIconByID(id) end
        option.icon:SetTexture(icon or "Interface/Icons/INV_Misc_QuestionMark")
        option.icon:Show()
        option.name:SetText(W.Text(bestOption and not writs and color(optionName, GREEN) or optionName))
        option.cols[1]:SetText(W.Text(W.Price(bundle.quote.cost)))
        local total = bundle.quote.cost and item.crateQuote.cost and bundle.quote.cost + item.crateQuote.cost
        option.cols[2]:SetText(W.Text(W.Price(total and item.rewardValue and total / item.rewardValue)))
        option.cols[3]:SetText(W.Text(W.Price(total)))
        if writs then option.cols[2]:SetText(""); option.cols[3]:SetText("") end
        local q = bundle.quote
        local extraCost = not writs and q.cost and item.best and item.best.quote.cost
          and q.cost - item.best.quote.cost
        if extraCost and extraCost > 0 then
          option.extraCost:SetText(W.SafeText("+ " .. W.Price(extraCost)))
        elseif bestOption and not writs then
          option.extraCost:SetText(W.Text("Best option"))
          option.extraCost:SetTextColor(0.35, 1, 0.3)
        end
        local detail = W.Reason(q)
        if q.cost then
          detail = string.format(q.estimated and "%d listed · %d needed" or "%d available · %d needed", q.available, q.required)
          option.goodsCost:ClearAllPoints(); option.goodsCost:SetPoint("TOPLEFT", nameWidth, -29)
          option.goodsCost:SetWidth(costWidth - 9)
          local purchasedUnits = q.purchased or q.required
          if not writs or purchasedUnits > 1 then
            option.goodsCost:SetText(W.Text(W.Price(q.cost / purchasedUnits) .. " / unit"))
          end
        end
        if bestOption and writs then detail = color("Required goods", GREEN) .. " · " .. detail end
        option.sub:SetText(W.Text(color(detail, (bundle.quote.cost or bundle.quote.reason == "skipped") and MUTED or "|cffffac79")))
        local function showGoods(self)
          planTooltip(self, bundle.quantity .. "× " .. W.ItemLabel(bundle.name), bundle.quote)
          if not writs or W.ShowTooltipExplanations() then valueTooltip(item, total) end
          if extraCost and extraCost > 0 then
            GameTooltip:AddDoubleLine(W.Text("Extra cost vs. best option"), W.SafeText("+ " .. W.Price(extraCost)), 1, 0.82, 0.45, 1, 0.82, 0.45)
          end
          GameTooltip:AddLine(W.Text("Click this row to collapse required goods."), 0.65, 0.7, 0.78)
          tooltipHint()
          GameTooltip:Show()
        end
        option:SetScript("OnEnter", showGoods)
        option:SetScript("OnClick", toggleDetails)
        option.search:SetScript("OnEnter", function(self) searchTooltip(self, bundle.name) end)
        option.search:SetScript("OnClick", function() W.SearchInBuy(bundle.name) end)
      end
    end
  end
  for i = used + 1, #p.rows do releaseRow(p.rows[i]) end
  local empty = #(W.results or {}) == 0
  p.empty:SetText(W.Text(empty and (not W.scannedAt and "Run a scan to compare orders in this tab." or
    "No matching orders. Try clearing Available to buy or check Display settings.") or ""))
  p.content:SetHeight(math.max(y, p.scroll:GetHeight(), 70))
  p.scroll:UpdateScrollChildRect()
  p.scroll:SetVerticalScroll(math.min(p.scroll:GetVerticalScroll(), math.max(0, p.content:GetHeight() - p.scroll:GetHeight())))
  local best = W.results and W.results[1]
  if best and best.ratio then
    p.summary:SetText(W.Text("Lowest cost / " .. (writs and "base reputation" or "Favor") .. " first · " .. color("Best value highlighted", GREEN)))
  else p.summary:SetText(W.Text(W.scannedAt and "No cost / reward comparison available. Check prices and rewards." or "Choose Fast Scan for estimates or Full Scan for detailed prices.")) end
  p.note:SetText(W.Text(W.scanError and ((W.scannedAt and "Previous snapshot kept" or "No new snapshot saved") .. " · Hover the scan status for the error or cancellation details.")
    or "Item name: search in the Buy tab · Row or arrow: show/hide items · Hover row: price breakdown"))
  p.note:SetTextColor(W.scanError and 1 or 0.55, W.scanError and 0.68 or 0.61, W.scanError and 0.47 or 0.7)
  if W.scanning then
    p.status:SetText(W.Text(W.message or "Scanning…")); p.status:SetTextColor(1, 0.82, 0.45)
  elseif W.scannedAt then
    local age = math.max(0, math.floor((time() - W.scannedAt) / 60))
    local elapsed = age < 1 and "Just now" or (age < 60 and (age .. " min ago") or (math.floor(age / 60) .. " h " .. age % 60 .. " min ago"))
    local stamp = W.scanTimeUnknown and "Snapshot date unknown" or elapsed
    p.status:SetText(W.Text((W.scanMode == "fast" and "Fast scan · Estimates · " or "Full scan · ") .. stamp .. " · " .. priced .. " ranked" .. (W.incomplete and " · INCOMPLETE" or "")))
    p.status:SetTextColor(age >= 15 and 1 or 0.7, age >= 15 and 0.65 or 0.78, age >= 15 and 0.35 or 0.86)
  else p.status:SetText(W.Text("No saved scan for this tab")); p.status:SetTextColor(0.7, 0.78, 0.86) end
end

