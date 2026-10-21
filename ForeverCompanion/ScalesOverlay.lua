-- Forever Companion — ScalesOverlay.lua
-- Sur les récompenses de quête et les jets de butin :
--   • flèche verte (icône du jeu) : l'objet est meilleur que celui porté, d'après l'échelle active (Scales.lua) ;
--   • étoile du jeu dorée : n°1 de ma liste BiS (ma spé, phase mise en avant) ; argentée : autre objet de la liste.
local FC = ForeverCompanion
local API = ForeverCompanionAPI
local Scales = FC.Scales

local pending = false   -- un objet n'était pas encore chargé : on refera un passage à sa réception

-- Icônes du jeu : étoile de la fenêtre de réputation (la même que dans la fenêtre du butin des
-- donjons), en haut à gauche ; flèche verte des sacs (amélioration), en haut à droite.
local function Badge(btn, anchor)
    local b = btn.fcScaleBadge
    if not b then
        b = CreateFrame("Frame", nil, btn)
        b.arrow = b:CreateTexture(nil, "OVERLAY")
        Scales.SetArrowTexture(b.arrow)
        b.arrow:SetSize(16, 16)
        b.star = b:CreateTexture(nil, "OVERLAY")
        Scales.SetStarTexture(b.star)
        b.star:SetSize(14, 14)
        btn.fcScaleBadge = b
    end
    b:SetFrameLevel((btn:GetFrameLevel() or 1) + 4)
    b:ClearAllPoints(); b:SetAllPoints(anchor or btn)
    b.star:ClearAllPoints(); b.star:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
    b.arrow:ClearAllPoints(); b.arrow:SetPoint("TOPRIGHT", b, "TOPRIGHT", 4, 4)
    return b
end

-- Décore un bouton d'objet (link = nil : rien à afficher). Renvoie flèche, rang BiS (pour les tests).
local function Decorate(btn, link, anchor)
    if not btn then return end
    if not link then
        if btn.fcScaleBadge then btn.fcScaleBadge:Hide() end
        return
    end
    local g = FC.db.global
    local up, rank = false, nil
    local on = g.scales_enabled ~= false   -- interrupteur général (Options → Tabs & features)
    if on and g.scale_arrows ~= false then
        local ev, wait = Scales.Evaluate(link)
        if wait then pending = true end
        up = ev and ev.upgrade or false
    end
    if on and g.scale_stars ~= false then rank = Scales.BisRank(tonumber(link:match("item:(%d+)"))) end
    if not up and not rank then
        if btn.fcScaleBadge then btn.fcScaleBadge:Hide() end
        return false, nil
    end
    local b = Badge(btn, anchor)
    if up then b.arrow:Show() else b.arrow:Hide() end
    if rank then
        b.star:SetDesaturated(rank ~= 1)   -- dorée : n°1 ; grisée (argentée) : alternative
        b.star:Show()
    else
        b.star:Hide()
    end
    b:Show()
    return up, rank
end
FC.ScaleDecorate = Decorate   -- exposé pour les tests

-- ── Récompenses de quête (fenêtre de quête et journal) ────────────────────
local function QuestButtons()
    local out, seen = {}, {}
    local function add(b) if b and not seen[b] then seen[b] = true; out[#out + 1] = b end end
    for _, fr in ipairs({ _G.QuestInfoRewardsFrame, _G.MapQuestInfoRewardsFrame }) do
        if fr then
            for _, b in ipairs(fr.RewardButtons or {}) do add(b) end
            local n = fr.GetName and fr:GetName()
            if n then for i = 1, 10 do add(_G[n .. "QuestInfoItem" .. i]) end end
        end
    end
    for i = 1, 10 do add(_G["QuestInfoItem" .. i]); add(_G["QuestRewardItem" .. i]); add(_G["QuestLogItem" .. i]) end
    return out
end
local function QuestLink(b)
    if not b:IsShown() then return nil end
    if b.objectType and b.objectType ~= "item" then return nil end
    local t, i = b.type, b.GetID and b:GetID()
    if not t or not i or i < 1 then return nil end
    local name = (b.GetName and b:GetName()) or ""
    local fromLog = (_G.QuestInfoFrame and _G.QuestInfoFrame.questLog) or name:find("^QuestLog") or name:find("^MapQuestInfo")
    local ok, link
    if fromLog and GetQuestLogItemLink then ok, link = pcall(GetQuestLogItemLink, t, i); if not ok then link = nil end end
    if type(link) ~= "string" and GetQuestItemLink then ok, link = pcall(GetQuestItemLink, t, i); if not ok then link = nil end end
    return type(link) == "string" and link or nil
end
function FC:RefreshQuestRewards()
    if not self.db then return end
    for _, b in ipairs(QuestButtons()) do
        local name = b.GetName and b:GetName()
        local icon = b.Icon or (name and _G[name .. "IconTexture"]) or nil
        Decorate(b, QuestLink(b), icon)
    end
end

-- ── Jets de butin (Besoin / Cupidité) ─────────────────────────────────────
local hooked = {}
local function LootFrames()
    local out, seen = {}, {}
    local function add(f) if f and not seen[f] then seen[f] = true; out[#out + 1] = f end end
    for i = 1, (tonumber(rawget(_G, "NUM_GROUP_LOOT_FRAMES")) or 4) do add(_G["GroupLootFrame" .. i]) end
    local c = _G.GroupLootContainer
    if c and type(c.rollFrames) == "table" then for _, f in pairs(c.rollFrames) do add(f) end end
    return out
end
function FC:RefreshLootRolls()
    if not self.db then return end
    for _, f in ipairs(LootFrames()) do
        if not hooked[f] and f.HookScript then
            hooked[f] = true
            f:HookScript("OnShow", function() C_Timer.After(0, function() FC:RefreshLootRolls() end) end)
        end
        local link
        if f:IsShown() and f.rollID and GetLootRollItemLink then
            local ok, l = pcall(GetLootRollItemLink, f.rollID)
            link = ok and l or nil
        end
        local name = f.GetName and f:GetName()
        local icon = f.IconFrame or (name and _G[name .. "IconFrame"]) or nil
        Decorate(icon or f, link)
    end
end

function FC:RefreshScaleOverlays()
    self:RefreshQuestRewards()
    self:RefreshLootRolls()
    if self.RefreshScalePreview then self:RefreshScalePreview() end
end

-- ── Aperçu (/fc preview) : voir la flèche et l'étoile sans aller en donjon ──
-- Objets de tes sacs (équipables) et de ta liste BiS, décorés comme les récompenses et les jets de butin ;
-- survol : infobulle avec la valeur d'après ton échelle.
local preview
local ICON, GAP, PER_ROW = 34, 6, 12
local function BagLinks(max)
    local out = {}
    local numSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
    local itemLink = (C_Container and C_Container.GetContainerItemLink) or GetContainerItemLink
    if not numSlots or not itemLink then return out end
    for bag = 0, (tonumber(rawget(_G, "NUM_BAG_SLOTS")) or 4) do
        for slot = 1, (numSlots(bag) or 0) do
            local l = itemLink(bag, slot)
            local loc
            if l then loc = select(4, API.GetItemInfoInstant(l)) end
            if loc and Scales.SLOTS[loc] then out[#out + 1] = l end
            if #out >= max then return out end
        end
    end
    return out
end
local function BisLinks(max)
    local out, seen = {}, {}
    local cn = FC:ClassFromToken(Scales.PlayerToken())
    local db = FC.db.char
    local sn = cn and ((db.highlight_class == cn and db.highlight_spec) or select(2, FC:DetectPlayerSpec()))
    local ph = FC:GetHighlightPhase()
    local slots = cn and sn and ((FC.BisData[cn] or {})[sn] or {})[ph] or {}
    for _, se in ipairs(slots) do
        for _, it in ipairs(se.items or {}) do
            if it.rank <= 2 and it.itemId and it.itemId > 0 and not seen[it.itemId] then
                seen[it.itemId] = true
                out[#out + 1] = "item:" .. it.itemId
                if #out >= max then return out, sn, ph end
            end
        end
    end
    return out, sn, ph
end
local function PreviewRow(f, key, y, title, links)
    f[key] = f[key] or {}
    local row = f[key]
    row.title = row.title or f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.title:ClearAllPoints(); row.title:SetPoint("TOPLEFT", 16, -y); row.title:SetText(title)
    y = y + 20
    row.btns = row.btns or {}
    for i, link in ipairs(links) do
        local b = row.btns[i]
        if not b then
            b = CreateFrame("Button", nil, f)
            b:SetSize(ICON, ICON)
            b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetAllPoints()
            b:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink(self.link)
                GameTooltip:Show()
            end)
            b:SetScript("OnLeave", function() GameTooltip:Hide() end)
            row.btns[i] = b
        end
        local col, line = (i - 1) % PER_ROW, math.floor((i - 1) / PER_ROW)
        b:ClearAllPoints(); b:SetPoint("TOPLEFT", 16 + col * (ICON + GAP), -(y + 4 + line * (ICON + GAP)))
        b.link = link
        b.icon:SetTexture(API.GetItemIcon(tonumber(link:match("item:(%d+)"))) or 134400)
        Decorate(b, link)
        b:Show()
    end
    for i = #links + 1, #row.btns do row.btns[i]:Hide() end
    if #links == 0 then
        row.empty = row.empty or f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        row.empty:ClearAllPoints(); row.empty:SetPoint("TOPLEFT", 20, -(y + 4)); row.empty:SetText("Nothing to show."); row.empty:Show()
        return y + 24
    end
    if row.empty then row.empty:Hide() end
    return y + 8 + math.ceil(#links / PER_ROW) * (ICON + GAP)
end
function FC:RefreshScalePreview()
    local f = preview
    if not f or not f:IsShown() then return end
    local s, auto = Scales.Active()
    f.info:SetText(FC.db.global.scales_enabled == false and "|cffff8c33Gear scales are turned off (Options > Tabs & features).|r" or s and ("Scale: |cffffd100" .. s.label .. "|r" .. (auto and "  |cff9d9d9d(automatic, from your talents)|r" or ""))
        or "|cffff5050No scale for your class yet: import one in the options (Gear scales).|r")
    local y = 58
    y = PreviewRow(f, "bags", y, "Your bags (equippable items)", BagLinks(PER_ROW * 2))
    local bis, sn, ph = BisLinks(PER_ROW * 2)
    y = PreviewRow(f, "bis", y + 6, "Your BiS list" .. (sn and (" — " .. sn .. ", " .. FC:PhaseLabel(ph)) or " (no spec detected)"), bis)
    f.hint:ClearAllPoints(); f.hint:SetPoint("TOPLEFT", 16, -(y + 8)); f.hint:SetPoint("RIGHT", f, "RIGHT", -16, 0)
    f:SetHeight(y + 60)
end
function FC:ShowScalePreview()
    if not preview then
        local f = API.CreateWindow("ForeverCompanionScalePreview", UIParent, 16 * 2 + PER_ROW * (ICON + GAP), 300)
        f:SetPoint("CENTER", 0, 60)
        f:SetFrameStrata("DIALOG")
        f:SetClampedToScreen(true)
        f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        API.CloseOnEscape(f)
        API.WindowTitle(f):SetText(FC.NAME .. " — Gear scales preview")
        f.info = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        f.info:SetPoint("TOPLEFT", 16, -34); f.info:SetPoint("RIGHT", f, "RIGHT", -16, 0); f.info:SetJustifyH("LEFT")
        f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        f.hint:SetJustifyH("LEFT")
        f.hint:SetText("Same icons as on quest rewards and loot rolls: green arrow = better than what you wear, gold star = best item of your BiS list, grey star = alternative. "
            .. "To see them on real quest rewards, open your quest log on a quest that gives items.")
        f:SetScript("OnShow", function() FC:RefreshScalePreview() end)
        f:Hide()
        preview = f
    end
    if preview:IsShown() then preview:Hide() else preview:Show(); FC:RefreshScalePreview() end
end

-- ── Évènements ────────────────────────────────────────────────────────────
local f = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_LOGIN", "QUEST_DETAIL", "QUEST_COMPLETE", "QUEST_ITEM_UPDATE", "START_LOOT_ROLL", "GET_ITEM_INFO_RECEIVED" }) do
    pcall(f.RegisterEvent, f, e)
end
local queued = false
local function Soon(fn)
    if queued then return end
    queued = true
    C_Timer.After(0.1, function() queued = false; fn() end)
end
f:SetScript("OnEvent", function(_, e)
    if e == "PLAYER_LOGIN" then
        -- La fenêtre de quête et le journal passent tous deux par QuestInfo_Display
        if type(rawget(_G, "QuestInfo_Display")) == "function" then
            hooksecurefunc("QuestInfo_Display", function() FC:RefreshQuestRewards() end)
        end
        return
    end
    if e == "GET_ITEM_INFO_RECEIVED" then
        if not pending then return end
        pending = false
        Soon(function() FC:RefreshScaleOverlays() end)
    elseif e == "START_LOOT_ROLL" then
        Soon(function() FC:RefreshLootRolls() end)
    else
        Soon(function() FC:RefreshQuestRewards() end)
    end
end)
