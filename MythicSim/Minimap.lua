-- MythicSim: minimap button
--
-- One click to the copy window, the way the SimulationCraft addon works:
-- left-click opens the export with the text already selected, so it is
-- click, Ctrl-C, paste. On the Forever client that is the character
-- export; on retail it is the group link when you are in a party or raid.
--
-- Hand-rolled rather than LibDBIcon so the addon stays free of embedded
-- libraries. The button is an ordinary child of Minimap, which is what
-- minimap button collectors look for, so they pick it up like any other.
--
--   left-click   open (or close) the copy window
--   right-click  list the commands
--   drag         move the button around the minimap
--   /mythicsim minimap   show or hide the button

local addonName, ns = ...
local MythicSim = _G.MythicSim
local print_info = ns.print_info

-- The mythicsim.com icon, a 64px TGA beside this file.
local ICON = "Interface\\AddOns\\MythicSim\\icon"
local DEFAULT_ANGLE = 215

local atan2 = math.atan2 or math.atan
local button

local function settings()
    MythicSimDB = MythicSimDB or {}
    MythicSimDB.minimap = MythicSimDB.minimap or {}
    return MythicSimDB.minimap
end

-- --------------------------------------------------------------------
-- Position
--
-- The button rides the minimap's edge at a saved angle. Square minimaps
-- (GetMinimapShape is an addon convention, set by the minimap addon)
-- get the corner clamp so the button follows the square instead of
-- cutting across it.
-- --------------------------------------------------------------------

local function place(angle)
    local radius = (Minimap:GetWidth() or 140) / 2 + 5
    local rad = math.rad(angle)
    local x, y = math.cos(rad) * radius, math.sin(rad) * radius
    local shape = GetMinimapShape and GetMinimapShape() or "ROUND"
    if shape ~= "ROUND" then
        x = math.max(-radius, math.min(x * 1.4142, radius))
        y = math.max(-radius, math.min(y * 1.4142, radius))
    end
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local function follow_cursor()
    local mx, my = Minimap:GetCenter()
    local px, py = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    if not (mx and px and scale) then return end
    local angle = math.deg(atan2(py / scale - my, px / scale - mx)) % 360
    settings().angle = angle
    place(angle)
end

-- --------------------------------------------------------------------
-- Click
-- --------------------------------------------------------------------

-- What the button and the bare slash command both do.
function MythicSim:DefaultAction()
    if not ns.IS_RETAIL then
        MythicSim:CommandExport()
    elseif IsInGroup() then
        MythicSim:CommandGroup()
    else
        MythicSim:CommandSim()
    end
end

local function on_click(_, mouseButton)
    if mouseButton == "RightButton" then
        MythicSim:CommandHelp()
        return
    end
    -- A second click puts the window away again.
    local frame = _G.MythicSimExportFrame
    if frame and frame:IsShown() then
        frame:Hide()
        return
    end
    MythicSim:DefaultAction()
end

-- The retail addon compartment (the dropdown under the minimap) calls
-- this by name, from `## AddonCompartmentFunc` in the TOC.
function MythicSim_OnAddonCompartmentClick(_, mouseButton)
    on_click(nil, mouseButton)
end

local function show_tooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("MythicSim")
    if ns.IS_RETAIL then
        GameTooltip:AddLine("Click: group sim link for your party or raid", 1, 1, 1)
    else
        GameTooltip:AddLine("Click: export this character, ready to copy", 1, 1, 1)
    end
    GameTooltip:AddLine("Right-click: commands", 1, 1, 1)
    GameTooltip:AddLine("Drag: move this button", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end

-- --------------------------------------------------------------------
-- The button
--
-- Sizes and offsets are the long-standing minimap button convention: a
-- 31px button, the 53px tracking border over it, the icon inset behind.
-- --------------------------------------------------------------------

local function build_button()
    local b = CreateFrame("Button", "MythicSimMinimapButton", Minimap)
    b:SetSize(31, 31)
    b:SetFrameStrata("MEDIUM")
    b:SetFrameLevel(8)
    b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    b:RegisterForDrag("LeftButton")
    b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local background = b:CreateTexture(nil, "BACKGROUND")
    background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    background:SetSize(20, 20)
    background:SetPoint("TOPLEFT", 7, -5)

    local icon = b:CreateTexture(nil, "ARTWORK")
    icon:SetTexture(ICON)
    icon:SetSize(17, 17)
    icon:SetPoint("TOPLEFT", 7, -6)
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    b.icon = icon

    local border = b:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(53, 53)
    border:SetPoint("TOPLEFT")

    b:SetScript("OnClick", on_click)
    b:SetScript("OnEnter", show_tooltip)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:SetScript("OnDragStart", function(self)
        GameTooltip:Hide()
        self:SetScript("OnUpdate", follow_cursor)
    end)
    b:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
    return b
end

local function apply_visibility()
    if settings().hide then button:Hide() else button:Show() end
end

function MythicSim:CommandMinimap()
    local db = settings()
    db.hide = not db.hide
    apply_visibility()
    if db.hide then
        print_info("Minimap button hidden. /mythicsim minimap brings it back.")
    else
        print_info("Minimap button shown.")
    end
end

-- Saved variables are only there from PLAYER_LOGIN on.
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
    button = build_button()
    place(settings().angle or DEFAULT_ANGLE)
    apply_visibility()
end)
