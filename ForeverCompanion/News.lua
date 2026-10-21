-- Forever Companion — News.lua
-- Fenêtre « What's new » : texte écrit dans Forever Companion Studio (Nouveautés), Data/Meta.lua (news).
-- S'ouvre toute seule une fois après chaque mise à jour (la version du haut a changé), à la première
-- ouverture de la fenêtre BiS (jamais au milieu de l'écran sans que l'addon soit ouvert), et depuis
-- Options → About. Mise en forme : « # Titre » ou « **Titre** » seul sur sa ligne = titre doré,
-- « - » ou « • » = puce, **mot** = blanc, ligne vide = espace.
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local W, H = 480, 440
local frame

local function News() return (ForeverCompanionData and ForeverCompanionData.news) or {} end

local function Inline(s)
    return (tostring(s):gsub("%*%*(.-)%*%*", "|cffffffff%1|r"))
end
-- Une ligne de texte → kind ("h", "li", "p", "gap"), texte prêt à afficher
function FC.NewsLine(line)
    local t = tostring(line or ""):gsub("\r", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if t == "" then return "gap", "" end
    local head = t:match("^#+%s*(.+)$") or t:match("^%*%*(.+)%*%*$")
    if head and not head:find("%*%*") then return "h", head end
    local li = t:match("^[-*]%s+(.+)$") or t:match("^\226\128\162%s*(.+)$")   -- « - », « * », « • »
    if li then return "li", Inline(li) end
    return "p", Inline(t)
end

local function DateText(d)
    local y, m, dd = tostring(d or ""):match("^(%d+)%-(%d+)%-(%d+)$")
    if not y then return d end
    local months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
    return tonumber(dd) .. " " .. (months[tonumber(m)] or m) .. " " .. y
end

local function Build()
    local f = API.CreateWindow("ForeverCompanionNewsFrame", UIParent, W, H)
    f:SetPoint("CENTER", 0, 40)
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    API.CloseOnEscape(f)
    API.WindowTitle(f):SetText(FC.NAME .. " — What's new")
    API.AddInset(f, 10, -30, -10, 10)
    local sf, bar = API.CreateScrollFrame(f, nil)
    sf:SetPoint("TOPLEFT", 18, -38)
    sf:SetPoint("BOTTOMRIGHT", -32, 16)
    local content = CreateFrame("Frame", nil, sf)
    content:SetSize(W - 60, 1)
    sf:SetScrollChild(content)
    f.sf, f.content, f.lines = sf, content, {}
    if API.AddBottomFade then API.AddBottomFade(sf, 24, (type(bar) == "table") and 12 or 0) end
    f:Hide()
    -- Fermée : la bulle du tour, si elle attendait, peut s'afficher. Posé APRÈS le Hide de la création
    -- (sinon elle s'afficherait en même temps que cette fenêtre) ; petit délai : avec Échap, la fenêtre
    -- BiS se ferme aussi, et la bulle ne doit pas être « vue » dans une fenêtre déjà fermée.
    f:SetScript("OnHide", function()
        C_Timer.After(0.1, function() if FC.ShowTourHintIfOpen then FC:ShowTourHintIfOpen() end end)
    end)
    return f
end

local FONTS = { v = "GameFontNormalLarge", h = "GameFontNormal", li = "GameFontHighlight", p = "GameFontHighlight", date = "GameFontDisableSmall" }
local function Render(f)
    local width = W - 64
    local used, y = 0, 4
    local function line(kind, text, indent, gapAfter)
        used = used + 1
        local fs = f.lines[used]
        if not fs then
            fs = f.content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            fs:SetJustifyH("LEFT")
            f.lines[used] = fs
        end
        fs:SetFontObject(FONTS[kind] or "GameFontHighlight")
        fs:ClearAllPoints()
        fs:SetPoint("TOPLEFT", indent or 0, -y)
        fs:SetWidth(width - (indent or 0))
        fs:SetText(text)
        fs:Show()
        y = y + (fs:GetStringHeight() or 14) + (gapAfter or 4)
        return fs
    end
    local list = News()
    if #list == 0 then
        line("p", "|cff9d9d9dNothing new to show.|r")
    end
    for i, n in ipairs(list) do
        if i > 1 then y = y + 14 end
        line("v", "|cffffd100" .. tostring(n.id or "") .. "|r", 0, 0)
        if n.d then line("date", DateText(n.d), 0, 8) else y = y + 6 end
        for raw in (tostring(n.t or "") .. "\n"):gmatch("(.-)\n") do
            local kind, text = FC.NewsLine(raw)
            if kind == "gap" then y = y + 6
            elseif kind == "h" then y = y + 4; line("h", text, 0, 4)
            elseif kind == "li" then line("li", "• " .. text, 10, 3)
            else line("p", text, 0, 4) end
        end
    end
    for k = used + 1, #f.lines do f.lines[k]:Hide() end
    f.content:SetHeight(y + 8)
    if f.sf.SetVerticalScroll then f.sf:SetVerticalScroll(0) end
end

-- FC:ShowNews() : ouvre / ferme la fenêtre
function FC:ShowNews()
    frame = frame or Build()
    if frame:IsShown() then frame:Hide(); return end
    Render(frame)
    frame:Show(); frame:Raise()
    local top = News()[1]
    if top and self.db then self.db.global.news_seen = top.id end
end

-- Ouverture automatique : une fois par nouvelle version, quand la fenêtre BiS s'ouvre (hors combat :
-- elle attend alors la prochaine ouverture). Renvoie true si la fenêtre a été ouverte.
local function AutoShow()
    local top = News()[1]
    local g = FC.db and FC.db.global
    if not top or not g or g.news_auto == false or g.news_seen == top.id then return end
    if InCombatLockdown and InCombatLockdown() then return false end
    if not (frame and frame:IsShown()) then FC:ShowNews() end
    return true
end
FC.NewsAutoShow = AutoShow
