local addonName, W = ...
local addon = CreateFrame("Frame")
local metadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
W.version = metadata and metadata(addonName, "Version") or "0.1.2-dev"
W.author = metadata and metadata(addonName, "Author") or "Shakam"
W.target = metadata and metadata(addonName, "X-Game-Version") or "WoW Forever 1.60 beta (1.60.1)"
W.icon = "Interface\\AddOns\\" .. addonName .. "\\Assets\\Icon"
W.logo = "Interface\\AddOns\\" .. addonName .. "\\Assets\\Logo"
W.title = W.Text("WaylaidCost — Crates & Writs")
W.books = {}
local ahOpen = false
local selectTab
local function chat(text) print("|cff79c4ffWaylaidCost:|r " .. W.Text(text)) end

function W.Refresh()
  -- Item tooltips read the saved books directly. Ranking is only needed while
  -- the AH tab is visible; settings/level events must not rebuild it at idle.
  if not W.db or not W.panel or not W.panel:IsShown() then return end
  local settings = W.db
  if W.auctionatorSource then settings = setmetatable({showUnavailable=true}, {__index=W.db}) end
  W.results = W.Evaluate(W.GetCatalog(), W.books, settings, UnitLevel("player"), W.scannedAt, W.incomplete, W.targeted)
  W.Draw()
end
local function attach()
  if W.panel or not AuctionHouseFrame then return end
  local parent = AuctionHouseFrame
  W.BuildUI(parent)
  -- Reuse Auctionator's tab registry when present, so addon tabs don't overlap.
  local lib = LibStub and LibStub:GetLibrary("LibAHTab-1-0", true)
  if lib then
    lib:CreateTab("WaylaidCost", W.panel, "Waylaid", W.title)
    -- Other addons may register their tabs later. Insert those before ours,
    -- preserving the library's registry and selection handling.
    local own = lib:GetButton("WaylaidCost")
    local point, previous, relativePoint, x, y = own:GetPoint(1)
    hooksecurefunc(lib, "CreateTab", function(self, id)
      if id == "WaylaidCost" then return end
      local added = self:GetButton(id)
      if not added or not previous then return end
      added:ClearAllPoints(); added:SetPoint(point, previous, relativePoint, x, y)
      own:ClearAllPoints(); own:SetPoint("TOPLEFT", added, "TOPRIGHT", x, y)
      previous, relativePoint = added, "TOPRIGHT"
    end)
    selectTab = function() lib:SetSelected("WaylaidCost") end
  elseif parent.SetDisplayMode and parent.Tabs and #parent.Tabs > 0 then
    -- This template inherits parentArray="Tabs". Isolate its automatic
    -- registration from Blizzard's tab list and capture the anchor first.
    local previousTab = parent.Tabs[#parent.Tabs]
    local tabHost = CreateFrame("Frame", nil, parent)
    tabHost:SetSize(1, 1)
    tabHost:SetPoint("CENTER", previousTab, "RIGHT", 6, 0)
    local tab = CreateFrame("Button", "WaylaidCostAHTab", tabHost, "AuctionHouseFrameDisplayModeTabTemplate")
    tab:SetText(W.Text("Waylaid")); PanelTemplates_TabResize(tab, 20, nil, 70)
    tab:SetPoint("LEFT", tabHost, "CENTER", 0, 0)
    PanelTemplates_DeselectTab(tab)
    hooksecurefunc(parent, "SetDisplayMode", function()
      W.panel:Hide(); PanelTemplates_DeselectTab(tab)
    end)
    selectTab = function()
      parent:SetDisplayMode({}); parent.displayMode = nil
      for _, native in ipairs(parent.Tabs) do PanelTemplates_DeselectTab(native) end
      PanelTemplates_SelectTab(tab)
      if parent.SetTitle then parent:SetTitle(W.Text(W.title)) end
      W.panel:Show()
    end
    tab:SetScript("OnClick", selectTab)
  else
    -- A changed beta UI still gets a visible entry point inside the AH.
    local tab = CreateFrame("Button", "WaylaidCostAHTab", parent, "UIPanelButtonTemplate")
    tab:SetSize(95, 22); tab:SetPoint("TOPRIGHT", -40, -4); tab:SetText(W.Text("Waylaid"))
    selectTab = function() W.panel:SetShown(not W.panel:IsShown()) end
    tab:SetScript("OnClick", selectTab)
  end
end

function W.Open()
  if not ahOpen then chat("Open the auction house, then the Waylaid tab."); return end
  attach(); if selectTab then selectTab() end
end

function W.SearchInBuy(name)
  if not ahOpen then chat("Open the auction house first."); return end
  local ah = AuctionHouseFrame
  local bar = ah and ah.SearchBar
  local categories = ah and ah.CategoriesList
  if type(name) ~= "string" or name == "" then return end
  if W.SearchAuctionator({{name=name, quantity=1}}) then return end
  local localized = W.LocalItemName(name)
  if not localized then
    local id = W.itemIDs[name]
    if id and C_Item and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(id) end
    chat("Localized item data is not loaded. Try again after it loads.")
    return
  end
  name = localized
  if not (bar and bar.SetSearchText and bar.StartSearch and categories and categories.SetSelectedCategory
    and ah.SetDisplayMode and AuctionHouseFrameDisplayMode and AuctionHouseFrameDisplayMode.Buy) then
    chat("Buy search is unavailable on this client. Search manually for: " .. name)
    return
  end
  W.CancelScan("Scan stopped: opened Buy search")
  GameTooltip:Hide()
  if W.panel then W.panel:Hide() end
  categories:SetSelectedCategory(nil)
  ah:SetDisplayMode(AuctionHouseFrameDisplayMode.Buy)
  if PanelTemplates_SetTab then PanelTemplates_SetTab(ah, 1) end
  if ah.UpdateTitle then ah:UpdateTitle() end
  if bar.FilterButton and bar.FilterButton.Reset then bar.FilterButton:Reset() end
  bar:SetSearchText(name)
  if bar.SearchBox and bar.SearchBox.ClearFocus then bar.SearchBox:ClearFocus() end
  if C_AuctionHouse and C_AuctionHouse.IsThrottledMessageSystemReady and C_AuctionHouse.IsThrottledMessageSystemReady() then
    bar:StartSearch()
  else
    chat("Search prepared in Buy. Click Search when the auction house is ready.")
  end
end

-- Native minimap addon menu: no launcher library or polling required.
function WaylaidCost_CompartmentOnClick(_, button)
  if button == "RightButton" then W.ToggleSettings() else W.Open() end
end
function WaylaidCost_CompartmentOnEnter(_, button)
  GameTooltip:SetOwner(button or UIParent, "ANCHOR_LEFT")
  GameTooltip:AddLine(W.Text("WaylaidCost " .. W.version), 1, 0.82, 0.45)
  GameTooltip:AddLine(W.Text("By " .. W.author .. " · " .. W.target), 0.8, 0.85, 0.9)
  GameTooltip:AddLine(W.Text("Compare crate costs per Merchant Favor."), 1, 1, 1, true)
  GameTooltip:AddLine(W.Text(ahOpen and "Click to open the Waylaid tab." or "Open the auction house first."), 0.7, 0.8, 0.9, true)
  GameTooltip:AddLine(W.Text("Right-click: settings and filters."), 1, 1, 1)
  GameTooltip:Show()
end
function WaylaidCost_CompartmentOnLeave()
  GameTooltip:Hide()
end

function W.Scan(mode)
  if W.scanning then W.CancelScan(); return end
  if not ahOpen then chat("Open the auction house first."); return end
  W.Open()
  W.StartTargetedScan(mode)
end

addon:RegisterEvent("PLAYER_LOGIN")
addon:RegisterEvent("AUCTION_HOUSE_SHOW")
addon:RegisterEvent("AUCTION_HOUSE_CLOSED")
addon:RegisterEvent("PLAYER_LEVEL_UP")
addon:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
addon:RegisterEvent("UPDATE_FACTION")
addon:SetScript("OnEvent", function(_, event)
  if event == "PLAYER_LOGIN" then
    WaylaidCostDB = type(WaylaidCostDB) == "table" and WaylaidCostDB or {}
    W.db = WaylaidCostDB
    local defaults = { details = false, showUnavailable = true, levelOnly = true, common = true, uncommon = true,
      showMinimap = true, itemTooltips = true, tooltipExplanations = "shift", enableWrits = true, orderKind = "waylaid",
      auctionatorPrices = true, auctionatorSearch = true }
    for key, value in pairs(defaults) do if W.db[key] == nil then W.db[key] = value end end
    if W.db.tooltipExplanations ~= "shift" and W.db.tooltipExplanations ~= "always" and W.db.tooltipExplanations ~= "never" then
      W.db.tooltipExplanations = "shift"
    end
    W.InitRewardDefaults()
    W.scanKey = GetRealmName() .. ":" .. UnitName("player")
    W.RegisterAuctionatorScanListener()
    W.LoadSnapshot()
    W.BuildMinimap()
    W.RegisterOptions()
    W.InitItemTooltips()
    SLASH_WAYLAIDCOST1 = "/wcrate"
    SlashCmdList.WAYLAIDCOST = function(args)
      if args and args:lower():match("^%s*status%s*$") then
        local version, build, _, interface = GetBuildInfo()
        chat("WaylaidCost " .. W.version)
        chat(W.L("Client: %s · Build: %s · Interface: %s · Locale: %s",
          tostring(version), tostring(build), tostring(interface), W.Locale()))
      elseif args and args:lower():match("^%s*config%s*$") then W.ToggleSettings()
      else W.Open() end
    end
  elseif event == "AUCTION_HOUSE_SHOW" then
    ahOpen = true
    W.RegisterAuctionatorScanListener()
    C_Timer.After(0, function()
      if ahOpen then
        attach(); W.Refresh()
      end
    end)
  elseif event == "AUCTION_HOUSE_CLOSED" then
    ahOpen = false; W.CancelScan("Scan cancelled: auction house closed")
    if W.panel then W.panel:Hide() end
  elseif event == "CURRENCY_DISPLAY_UPDATE" or event == "UPDATE_FACTION" then
    W.UpdateProgress()
  elseif event == "PLAYER_LEVEL_UP" then
    C_Timer.After(0, W.Refresh)
  end
end)
