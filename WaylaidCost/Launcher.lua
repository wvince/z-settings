local _, W = ...

function W.BuildMinimap()
  if W.minimap or not Minimap then return end
  local b = CreateFrame("Button", "WaylaidCostMinimapButton", Minimap)
  W.minimap = b
  b:SetSize(32, 32); b:SetFrameLevel(Minimap:GetFrameLevel() + 8)
  b:RegisterForClicks("LeftButtonUp", "RightButtonUp"); b:RegisterForDrag("LeftButton")
  local icon = b:CreateTexture(nil, "ARTWORK")
  icon:SetSize(20, 20); icon:SetPoint("CENTER"); icon:SetTexture(W.icon)
  icon:SetTexCoord(0, 1, 0, 1)
  local border = b:CreateTexture(nil, "OVERLAY")
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetSize(54, 54); border:SetPoint("TOPLEFT")
  b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
  local function position()
    local angle = math.rad(tonumber(W.db.minimapAngle) or 220)
    local x, y = math.cos(angle), math.sin(angle)
    if GetMinimapShape and GetMinimapShape() == "SQUARE" then
      local divisor = math.max(math.abs(x), math.abs(y))
      x, y = x / divisor, y / divisor
    end
    b:ClearAllPoints()
    b:SetPoint("CENTER", Minimap, "CENTER", x * (Minimap:GetWidth() / 2 + 8), y * (Minimap:GetHeight() / 2 + 8))
  end
  b:SetScript("OnDragStart", function(self)
    GameTooltip:Hide()
    self:SetScript("OnUpdate", function()
      local cx, cy = Minimap:GetCenter()
      local mx, my = GetCursorPosition()
      local scale = Minimap:GetEffectiveScale()
      W.db.minimapAngle = math.deg(math.atan2(my / scale - cy, mx / scale - cx))
      position()
    end)
  end)
  b:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
  b:SetScript("OnHide", function(self) self:SetScript("OnUpdate", nil) end)
  b:SetScript("OnClick", function(_, button)
    if button == "RightButton" then W.ToggleSettings() else W.Open() end
  end)
  b:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("WaylaidCost " .. W.version, 1, 0.82, 0.45)
    GameTooltip:AddLine("Left-click: open Waylaid at the auction house.", 1, 1, 1)
    GameTooltip:AddLine("Right-click: settings and filters.", 1, 1, 1)
    GameTooltip:AddLine("Drag to move the button around the minimap.", 0.7, 0.8, 0.9)
    GameTooltip:Show()
  end)
  b:SetScript("OnLeave", function() GameTooltip:Hide() end)
  position(); b:SetShown(W.db.showMinimap)
end
