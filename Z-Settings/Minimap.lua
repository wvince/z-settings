-- The minimap button: a click opens a menu of the /z commands, a drag moves it round the minimap's edge,
-- and a dot shows while the published setup still changes something on this character (also after Later).
-- Each menu entry runs its /z command, so the button adds no behaviour of its own.

local _, ns = ...

local ENTRIES = {
  { "Review setup", "update", "Choose which parts of the published setup to apply" },
  { "Save this character", "save", "Keep this character's whole setup, to copy onto another" },
  { "Copy a character", "copy", "Put a saved character's setup onto this one" },
  { "Undo last change", "undo", "Revert the last apply or copy on this character" },
  { "Export setup", "export", "Save your setup for publishing", true },
}
local WIDTH, BUTTON, GAP = 240, 30, 8
local DUE = { 0.96, 0.64, 0.36 } -- the orange of the WoW Companion button's dot

local button, menu, due

local function run(command)
  menu:Hide()
  SlashCmdList.ZSETTINGS(command)
end

local function drawMenu()
  local m = CreateFrame("Frame", "ZSettingsMenu", UIParent, "BackdropTemplate")
  m:SetWidth(WIDTH)
  m:SetFrameStrata("DIALOG")
  m:SetClampedToScreen(true)
  m:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 } })
  m.title = m:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  m.title:SetPoint("TOP", 0, -22)
  m.title:SetText("Z-Settings")
  m.status = m:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  m.status:SetPoint("TOP", m.title, "BOTTOM", 0, -8)
  local close = CreateFrame("Button", nil, m, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -6, -6)
  m.entries = {}
  for i, e in ipairs(ENTRIES) do
    local b = CreateFrame("Button", nil, m, "UIPanelButtonTemplate")
    b:SetSize(WIDTH - 48, BUTTON)
    b:SetText(e[1])
    b.publisherOnly = e[4]
    b:SetScript("OnClick", function() run(e[2]) end)
    b:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      GameTooltip:SetText(e[1])
      GameTooltip:AddLine(e[3], 1, 1, 1, true)
      GameTooltip:AddLine("/z " .. e[2], 0.6, 0.6, 0.6)
      GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    m.entries[i] = b
  end
  if UISpecialFrames then table.insert(UISpecialFrames, "ZSettingsMenu") end -- Escape closes it
  return m
end

local function showMenu()
  menu = menu or drawMenu()
  if menu:IsShown() then menu:Hide() return end
  local publisher = ZSettingsDB and ZSettingsDB.export ~= nil
  if publisher then
    menu.status:SetText("This PC publishes the setup")
    menu.status:SetTextColor(0.8, 0.8, 0.8)
  elseif due:IsShown() then
    menu.status:SetText("A new setup is waiting")
    menu.status:SetTextColor(unpack(DUE))
  else
    menu.status:SetText("Up to date")
    menu.status:SetTextColor(0.8, 0.8, 0.8)
  end
  local y = 72
  for _, b in ipairs(menu.entries) do
    if b.publisherOnly and not publisher then
      b:Hide()
    else
      b:ClearAllPoints()
      b:SetPoint("TOP", 0, -y)
      b:Show()
      y = y + BUTTON + GAP
    end
  end
  menu:SetHeight(y + 14)
  menu:ClearAllPoints()
  menu:SetPoint("TOPRIGHT", button, "BOTTOMLEFT", 0, 0)
  menu:Show()
end

local function place()
  local angle = math.rad((ZSettingsDB and ZSettingsDB.minimap) or 230)
  local radius = Minimap:GetWidth() / 2 + 10
  button:ClearAllPoints()
  button:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
end

button = CreateFrame("Button", "ZSettingsMinimapButton", Minimap)
button:SetSize(31, 31)
button:SetFrameStrata("MEDIUM")
button:SetFrameLevel(8)
button:RegisterForClicks("LeftButtonUp")
button:RegisterForDrag("LeftButton")
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
local back = button:CreateTexture(nil, "BACKGROUND")
back:SetSize(20, 20)
back:SetPoint("TOPLEFT", 7, -5)
back:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
local icon = button:CreateTexture(nil, "ARTWORK")
icon:SetSize(18, 18)
icon:SetPoint("TOPLEFT", 7, -6)
icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")
icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
local ring = button:CreateTexture(nil, "OVERLAY")
ring:SetSize(53, 53)
ring:SetPoint("TOPLEFT")
ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
due = button:CreateTexture(nil, "OVERLAY", nil, 7)
due:SetSize(9, 9)
due:SetPoint("TOPRIGHT", icon, "TOPRIGHT", 3, 3)
due:SetColorTexture(unpack(DUE))
if button.CreateMaskTexture then -- round where the client can mask a texture
  local mask = button:CreateMaskTexture()
  mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
  mask:SetAllPoints(due)
  due:AddMaskTexture(mask)
end
due:Hide()
button.due = due

button:SetScript("OnClick", showMenu)
button:SetScript("OnDragStart", function(self)
  self:SetScript("OnUpdate", function()
    local mx, my = Minimap:GetCenter()
    local cx, cy = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    ZSettingsDB = ZSettingsDB or {}
    ZSettingsDB.minimap = math.floor(math.deg(math.atan2(cy / scale - my, cx / scale - mx)) % 360)
    place()
  end)
end)
button:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
button:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_LEFT")
  GameTooltip:SetText("Z-Settings")
  if due:IsShown() then GameTooltip:AddLine("A new setup is waiting", unpack(DUE)) end
  GameTooltip:AddLine("Click for the menu, drag to move", 0.8, 0.8, 0.8)
  GameTooltip:Show()
end)
button:SetScript("OnLeave", function() GameTooltip:Hide() end)
button:RegisterEvent("PLAYER_LOGIN") -- ZSettingsDB, and with it the saved position, is loaded by then
button:SetScript("OnEvent", place)

-- called by ZSettings.lua each time it compares the published setup with this character
function ns.setDue(on)
  if on then due:Show() else due:Hide() end
end
