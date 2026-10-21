-- Forever Companion — QuickSetup.lua
-- « Quick setup » : petite fenêtre (bouton en haut de la fenêtre BiS) pour activer ou couper chaque
-- fonctionnalité en un clic : récolte sur la carte et la minicarte, niveaux de récolte, échelles,
-- faction, objets des personnages, sorts du maître, hôtel des ventes, bouton de la minicarte.
-- Les réglages détaillés restent dans les Options (bouton « More settings »).
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local function G() return FC.db.global end
local function RefreshTip() if GameTooltip and GameTooltip:IsShown() and API.RefreshTooltip then API.RefreshTooltip(GameTooltip) end end
local function Gather() if FC.RefreshGatherMap then FC:RefreshGatherMap() end end
local function RefreshAH()
    if FC.Auction and FC.Auction.UpdateUI then FC.Auction.UpdateUI() end
    local mfr = rawget(_G, "ForeverCompanionMarketFrame")
    if mfr and G().ah_enabled == false then mfr:Hide() end
    if FC.RefreshBislist then FC:RefreshBislist() end
    if FC.RefreshProfessionPrices then FC:RefreshProfessionPrices() end
    RefreshTip()
end

-- { label, icon, desc, get, set } ; même effet que les cases des Options
local FEATURES = {
    { label = "Herbs and ore on the world map", icon = "trade_herbalism",
      desc = "Plants and veins on the world map, dimmed in red when your skill is too low.",
      get = function() return G().gather_enabled ~= false and G().gather_worldmap ~= false end,
      set = function(v) if v then G().gather_enabled = true end; G().gather_worldmap = v; Gather() end },
    { label = "Herbs and ore on the minimap", icon = "trade_mining",
      desc = "The same icons on your minimap.",
      get = function() return G().gather_enabled ~= false and G().gather_minimap ~= false end,
      set = function(v) if v then G().gather_enabled = true end; G().gather_minimap = v; Gather() end },
    { label = "Gathering skill levels on the world map", icon = "inv_misc_map_01",
      desc = "Skill needed for the plants and veins of a zone, under its name on the world map.",
      get = function() return G().map_gather ~= false end,
      set = function(v) G().map_gather = v; if FC.RefreshMapLevels then FC:RefreshMapLevels() end end },
    { label = "Item score and upgrade arrows", icon = "inv_shield_06",
      desc = "Score of items with your gear scale, green arrow on upgrades, star on BiS items.",
      get = function() return G().scales_enabled ~= false end,
      set = function(v) G().scales_enabled = v; if FC.RefreshScaleOverlays then FC:RefreshScaleOverlays() end; RefreshTip() end },
    { label = "Hide items of the other faction", icon = "inv_bannerpvp_02",
      desc = "Quest rewards, PvP and reputation items of the other faction are left out of the lists.",
      get = function() return G().faction_filter ~= false end,
      set = function(v)
          G().faction_filter = v
          if FC.RefreshBislist then FC:RefreshBislist() end
          local lf = rawget(_G, "ForeverCompanionLootFrame")
          if lf and lf.Update and lf:IsShown() then lf:Update(true) end
          if FC.RefreshScaleOverlays then FC:RefreshScaleOverlays() end
      end },
    { label = "Items on my characters", icon = "inv_misc_bag_08",
      desc = "In item tooltips: how many your characters have (bags, bank, mail, auctions).",
      get = function() return G().inventory_enabled ~= false end,
      set = function(v) G().inventory_enabled = v; RefreshTip() end },
    { label = "Trainer spells", icon = "inv_misc_book_09",
      desc = "The spells to learn at your class trainer, in a list next to your spellbook.",
      get = function() return G().training_enabled ~= false end,
      set = function(v) G().training_enabled = v; if FC.RefreshTraining then FC:RefreshTraining() end end },
    { label = "Auction House", icon = "inv_misc_coin_02",
      desc = "Price scans, prices in tooltips and guides, sales history and gold tracking.",
      get = function() return G().ah_enabled ~= false end,
      set = function(v) G().ah_enabled = v; RefreshAH() end },
    { label = "Minimap button", icon = "inv_misc_gear_01",
      desc = "Left click: BiS window. Right click: options.",
      get = function() return not (G().minimap and G().minimap.hide) end,
      set = function(v)
          G().minimap = G().minimap or {}
          G().minimap.hide = not v
          local icon = LibStub and LibStub("LibDBIcon-1.0", true)
          if icon then if v then icon:Show("ForeverCompanion") else icon:Hide("ForeverCompanion") end end
      end },
}
FC.QuickSetupFeatures = FEATURES   -- tests

local W, ROW = 420, 40
local frame
local function Build()
    local f = API.CreateWindow("ForeverCompanionQuickSetup", UIParent, W, 96 + #FEATURES * ROW + 44)
    f:SetPoint("CENTER", 0, 40)
    f:SetFrameStrata("DIALOG")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetClampedToScreen(true)
    API.WindowTitle(f):SetText("Quick setup")
    API.CloseOnEscape(f)
    f.intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.intro:SetPoint("TOPLEFT", 18, -34); f.intro:SetWidth(W - 36); f.intro:SetJustifyH("LEFT")
    f.intro:SetText("Turn each feature on or off. Your detailed settings are kept for when you turn it back on.")
    f.rows = {}
    for i, ft in ipairs(FEATURES) do
        local r = CreateFrame("Button", nil, f)
        r:SetSize(W - 28, ROW - 2)
        r:SetPoint("TOPLEFT", 14, -56 - (i - 1) * ROW)
        if API.RowBackground then API.RowBackground(r, i) end
        r.cb = CreateFrame("CheckButton", nil, r, "UICheckButtonTemplate")
        r.cb:SetSize(26, 26); r.cb:SetPoint("LEFT", 4, 0)
        r.icon = r:CreateTexture(nil, "ARTWORK")
        r.icon:SetSize(24, 24); r.icon:SetPoint("LEFT", r.cb, "RIGHT", 4, 0)
        r.icon:SetTexture(API.IconPath(ft.icon)); r.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        r.label = r:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        r.label:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 8, 1); r.label:SetJustifyH("LEFT")
        r.label:SetText(ft.label)
        r.desc = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        r.desc:SetPoint("TOPLEFT", r.label, "BOTTOMLEFT", 0, -2); r.desc:SetWidth(W - 110); r.desc:SetJustifyH("LEFT")
        r.desc:SetWordWrap(false); r.desc:SetText(ft.desc)
        local function toggle(v)
            ft.set(v and true or false)
            f:Refresh()
        end
        r.cb:SetScript("OnClick", function(self) toggle(self:GetChecked()) end)
        r:SetScript("OnClick", function() toggle(not ft.get()) end)   -- toute la ligne coche la case
        r.ft = ft
        f.rows[i] = r
    end
    f.more = API.CreateMenuButton(f, 140, 22, "More settings")
    f.more:SetPoint("BOTTOMLEFT", 16, 14)
    f.more:SetScript("OnClick", function() f:Hide(); FC:OpenOptions("tabs") end)
    f.done = API.CreateMenuButton(f, 100, 22, "Done")
    f.done:SetPoint("BOTTOMRIGHT", -16, 14)
    f.done:SetScript("OnClick", function() f:Hide() end)
    function f:Refresh()
        for _, r in ipairs(self.rows) do
            local on = r.ft.get() and true or false
            r.cb:SetChecked(on)
            r.icon:SetDesaturated(not on)
            if on then r.label:SetTextColor(1, 0.82, 0) else r.label:SetTextColor(0.6, 0.6, 0.6) end
        end
    end
    f:SetScript("OnShow", function(self) self:Refresh() end)
    f:Hide()
    return f
end

function FC:ShowQuickSetup()
    frame = frame or Build()
    frame:Show(); frame:Refresh(); frame:Raise()
end
function FC:ToggleQuickSetup()
    if frame and frame:IsShown() then frame:Hide() else self:ShowQuickSetup() end
end

-- Bouton en haut de la fenêtre BiS (à gauche du « ? »)
function FC:AddQuickSetupButton(parent, leftOf)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(20, 20)
    if type(leftOf) == "table" then
        b:SetPoint("RIGHT", leftOf, "LEFT", -2, 0)
        b:SetFrameLevel(leftOf:GetFrameLevel())
    else
        b:SetPoint("TOPRIGHT", -78, -4)
    end
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetPoint("TOPLEFT", -2, 2); b.icon:SetPoint("BOTTOMRIGHT", 2, -2)
    b.icon:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
    b:SetScript("OnMouseDown", function(self) self.icon:SetPoint("TOPLEFT", -1, 1); self.icon:SetPoint("BOTTOMRIGHT", 3, -3) end)
    b:SetScript("OnMouseUp", function(self) self.icon:SetPoint("TOPLEFT", -2, 2); self.icon:SetPoint("BOTTOMRIGHT", 2, -2) end)
    b:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(1, 1, 0.6)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Quick setup", 1, 0.82, 0)
        GameTooltip:AddLine("Turn the features of the addon on or off in one place.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function(self) self.icon:SetVertexColor(1, 1, 1); GameTooltip:Hide() end)
    b:SetScript("OnClick", function() FC:ToggleQuickSetup() end)
    return b
end
