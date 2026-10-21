-- Forever Companion — Auction.lua
-- Prix de l'hôtel des ventes : scan complet (bouton, et automatique à l'ouverture
-- si l'option est active), enregistrement des prix vus pendant les recherches,
-- historique quotidien, et lignes de prix dans les info-bulles.
--
-- Deux API possibles selon le client :
--  * moderne : C_AuctionHouse.ReplicateItems (scan complet), résultats de recherche
--    (AUCTION_HOUSE_BROWSE_RESULTS_*, COMMODITY_SEARCH_RESULTS_UPDATED) ;
--  * ancienne : QueryAuctionItems(getAll) et GetAuctionItemInfo.
-- Données : FC.db.factionrealm.ah.items[id] = {
--   m = prix unitaire minimum (achat immédiat, cuivre), q = quantité en vente,
--   t = date du dernier relevé, n = nom, a = moyenne des minimums quotidiens sur 7 jours,
--   h = historique "jour:prix:quantité,jour:prix,…" (jour = time() / 86400 ; quantité en vente ce jour-là,
--       d'après le dernier relevé complet du jour, absente si aucun relevé complet) }
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local FULL_THROTTLE = 15 * 60     -- le jeu limite le scan complet à 1 toutes les 15 min
local CHUNK = 1000                -- enchères traitées par image (évite les gels)
local AH = { state = nil }
FC.Auction = AH

local function Now() return time() end
local function Today() return math.floor(Now() / 86400) end
local function DB() return FC.db and FC.db.factionrealm.ah end
local function Opt(k) return FC.db and FC.db.global[k] end

-- L'ancienne API d'abord : le client Classic Era possède aussi C_AuctionHouse.ReplicateItems,
-- mais son HV fonctionne avec QueryAuctionItems (le jeu actuel n'a plus que la nouvelle API).
function AH.API()
    if QueryAuctionItems and GetAuctionItemInfo then return "legacy" end
    if C_AuctionHouse and C_AuctionHouse.ReplicateItems and C_AuctionHouse.GetReplicateItemInfo then return "modern" end
    return nil
end

-- ── Historique ───────────────────────────────────────────────────────────
function AH.ParseHistory(h)
    local out = {}
    for d, p, q in tostring(h or ""):gmatch("(%d+):(%d+):?(%d*)") do
        table.insert(out, { tonumber(d), tonumber(p), q ~= "" and tonumber(q) or nil })
    end
    return out
end
local function WriteHistory(list)
    local parts = {}
    for _, e in ipairs(list) do parts[#parts + 1] = e[1] .. ":" .. e[2] .. (e[3] and (":" .. e[3]) or "") end
    return table.concat(parts, ",")
end

-- Met à jour une entrée avec un relevé (prix unitaire, quantité)
-- trusted = minimum réel de tout l'HV (scan complet, résultats de recherche du jeu actuel) ;
-- sinon (une page de résultats de l'ancienne API) on ne remonte pas un prix récent.
-- qtyOk = quantité complète (toutes les enchères de l'objet vues) : notée pour le jour (graphique).
local function Apply(items, id, unit, qty, name, now, today, keep, trusted, qtyOk)
    local e = items[id]
    if not e then e = {}; items[id] = e end
    if trusted or not e.m or (now - (e.t or 0)) > 3600 or unit < e.m then
        e.m, e.q = unit, qty
    end
    if qtyOk and qty then e.q = qty end
    e.t = now
    if name and name ~= "" then e.n = name end
    -- Minimum du jour + moyenne sur 7 jours
    local hist = AH.ParseHistory(e.h)
    local last = hist[#hist]
    local q = (qtyOk and qty) or nil
    if last and last[1] == today then
        last[2] = math.min(last[2], unit)
        if q then last[3] = q end   -- dernier relevé complet du jour
    else table.insert(hist, { today, unit, q }) end
    local cut = today - (keep or 60)
    local first = 1
    while hist[first] and hist[first][1] < cut do first = first + 1 end
    if first > 1 then local k = {}; for i = first, #hist do k[#k + 1] = hist[i] end; hist = k end
    local sum, n = 0, 0
    for _, x in ipairs(hist) do if x[1] > today - 7 then sum = sum + x[2]; n = n + 1 end end
    e.a = n > 0 and math.floor(sum / n + 0.5) or nil
    e.h = WriteHistory(hist)
end

-- Enregistre un lot {[id] = {min, qty, name}} ; qtyOk (quantités complètes) : comme trusted par défaut
function AH.Commit(batch, trusted, qtyOk)
    local db = DB(); if not db then return 0 end
    local now, today, keep = Now(), Today(), Opt("ah_keep_days") or 60
    if qtyOk == nil then qtyOk = trusted end
    local n = 0
    for id, v in pairs(batch) do
        Apply(db.items, id, v[1], v[2], v[3], now, today, keep, trusted, qtyOk)
        n = n + 1
    end
    if n > 0 then
        if FC.RefreshProfessionPrices then FC:RefreshProfessionPrices() end
        if FC.RefreshMarket then FC:RefreshMarket("prices") end
    end
    return n
end

local function Collect(batch, id, buyout, count, name)
    if not id or id <= 0 or not buyout or buyout <= 0 then return end
    local unit = math.floor(buyout / math.max(1, count or 1) + 0.5)
    local b = batch[id]
    if not b then batch[id] = { unit, count or 1, name }
    else
        if unit < b[1] then b[1] = unit end
        b[2] = b[2] + (count or 1)
        if name and not b[3] then b[3] = name end
    end
end

-- ── Prix pour le reste de l'addon ────────────────────────────────────────
-- Renvoie prix unitaire (cuivre), "ah" ou "site", date du relevé
function FC:GetItemPrice(id)
    local db = Opt("ah_enabled") ~= false and DB()
    local e = db and db.items[id]
    if e and e.m then return e.m, "ah", e.t end
    local d = FC.CraftItems and FC.CraftItems[id]
    if d and d.p then return d.p, "site" end
end
function FC:GetAuctionEntry(id) local db = DB(); return db and db.items[id] end

-- ── Prix des marchands : relevés à chaque ouverture d'un marchand (stock illimité, payé en or) ──
local function ReadMerchant()
    local g = FC.db and FC.db.global
    if not g or not GetMerchantNumItems then return 0 end
    g.vendor_prices = g.vendor_prices or {}
    local n = 0
    for i = 1, (GetMerchantNumItems() or 0) do
        local id = GetMerchantItemID and GetMerchantItemID(i)
        if not id then
            local link = GetMerchantItemLink and GetMerchantItemLink(i)
            id = link and tonumber(link:match("item:(%d+)"))
        end
        local price, qty, avail, ext
        if C_MerchantFrame and C_MerchantFrame.GetItemInfo then
            local info = C_MerchantFrame.GetItemInfo(i)
            if info then price, qty, avail, ext = info.price, info.stackCount, info.numAvailable, info.hasExtendedCost end
        elseif GetMerchantItemInfo then
            local _
            _, _, price, qty, avail, _, _, ext = GetMerchantItemInfo(i)
        end
        if id and price and price > 0 and not ext and (avail == nil or avail < 0) then
            g.vendor_prices[id] = math.floor(price / math.max(1, qty or 1) + 0.5)
            n = n + 1
        end
    end
    return n
end
function FC:GetVendorPrice(id) local g = FC.db and FC.db.global.vendor_prices; return g and g[id] end
-- Prix d'achat le moins cher : marchand (relevé), sinon HV (relevé), sinon prix indicatif du site
-- renvoie prix, "vendor" / "ah" / "site", date du relevé de l'HV
function FC:GetBuyPrice(id)
    local v = self:GetVendorPrice(id)
    local a, src, t
    if self.GetItemPrice then a, src, t = self:GetItemPrice(id) end
    if v and (not a or v <= a) then return v, "vendor" end
    return a, src, t
end
local merchantEv = CreateFrame("Frame")
pcall(merchantEv.RegisterEvent, merchantEv, "MERCHANT_SHOW")
pcall(merchantEv.RegisterEvent, merchantEv, "MERCHANT_UPDATE")
merchantEv:SetScript("OnEvent", function() pcall(ReadMerchant) end)
AH.ReadMerchant = ReadMerchant   -- tests

function AH.Age(t)
    if not t then return "?" end
    local s = math.max(0, Now() - t)
    if s < 3600 then return math.max(1, math.floor(s / 60)) .. " min" end
    if s < 86400 then return math.floor(s / 3600) .. " h" end
    return math.floor(s / 86400) .. " d"
end

-- ── Scan complet ─────────────────────────────────────────────────────────
local ui   -- barre sous la fenêtre de l'HV
local events = CreateFrame("Frame")

function AH.CanFullScan()
    local api = AH.API()
    if not api then return false, "no auction API" end
    if not AH.open then return false, "open the Auction House" end
    if AH.state then return false, "scan in progress" end
    if api == "legacy" and CanSendAuctionQuery then
        local ok, all = CanSendAuctionQuery()
        if not all then return false, "full scan available later (game limit)" end
        return true
    end
    local db = DB()
    local last = math.max((db and db.lastFull) or 0, (FC.db and FC.db.global.ahLastFull) or 0)   -- limite du compte entier
    local wait = FULL_THROTTLE - (Now() - last)
    if wait > 0 then return false, "next full scan in " .. math.ceil(wait / 60) .. " min" end
    return true
end

local function Status(text)
    if ui and ui.status then ui.status:SetText(text or "") end
end

local function Finish(batch, auctions, started)
    local n = AH.Commit(batch, true)
    local db = DB()
    if db then db.lastFullCount = n; db.lastFullAuctions = auctions end
    AH.state = nil
    local secs = (debugprofilestop and started) and ((debugprofilestop() - started) / 1000) or nil
    print(string.format("|cffffd700%s|r : Auction House scan — %d items, %d auctions%s.", FC.NAME, n, auctions,
        secs and string.format(" (%.1f s)", secs) or ""))
    AH.UpdateUI()
end

-- Traite les enchères par morceaux (une image = CHUNK enchères)
local function Process(total, getInfo, first)
    local batch, i = {}, first
    local last = first + total - 1
    local started = debugprofilestop and debugprofilestop()
    local function step()
        if not AH.state then return end
        if not AH.open then
            -- HV fermé en cours de route : les données restantes ne sont plus lisibles.
            -- Ce qui a été lu est gardé, sans remplacer un prix plus bas déjà connu.
            AH.Commit(batch, false); AH.state = nil; AH.UpdateUI()
            return
        end
        local stop = math.min(last, i + CHUNK - 1)
        for k = i, stop do
            local name, count, buyout, id = getInfo(k)
            Collect(batch, id, buyout, count, name)
        end
        i = stop + 1
        if i > last then Finish(batch, total, started); return end
        Status(string.format("Scanning… %d%%", math.floor((i - first) * 100 / total)))
        C_Timer.After(0, step)
    end
    step()
end

local function ModernInfo(k)
    local name, _, count, _, _, _, _, _, _, buyout, _, _, _, _, _, _, id = C_AuctionHouse.GetReplicateItemInfo(k)
    return name, count, buyout, id
end
local function LegacyInfo(k)
    local name, _, count, _, _, _, _, _, _, buyout, _, _, _, _, _, _, id = GetAuctionItemInfo("list", k)
    return name, count, buyout, id
end

function AH.FullScan(auto)
    local ok, why = AH.CanFullScan()
    if not ok then
        if not auto then print("|cffffd700" .. FC.NAME .. "|r : " .. why .. ".") end
        return false
    end
    local api = AH.API()
    local db = DB()
    AH.state = { api = api, auto = auto, started = Now(), prevLast = db.lastFull or 0, prevGlobal = FC.db.global.ahLastFull or 0 }
    db.lastFull = Now(); FC.db.global.ahLastFull = Now()
    Status("Waiting for the server…")
    if api == "modern" then
        events:RegisterEvent("REPLICATE_ITEM_LIST_UPDATE")
        C_AuctionHouse.ReplicateItems()
    else
        QueryAuctionItems("", nil, nil, 0, false, nil, true, false, nil)
    end
    -- Le serveur peut refuser (limite de temps) : pas de réponse → abandon
    local token = AH.state
    C_Timer.After(45, function()
        if AH.state == token and not token.processing then
            AH.state = nil
            events:UnregisterEvent("REPLICATE_ITEM_LIST_UPDATE")
            if token.auto then
                db.lastFull, FC.db.global.ahLastFull = token.prevLast, token.prevGlobal   -- refusé : le bouton reste disponible
            else
                print("|cffffd700" .. FC.NAME .. "|r : no answer from the server for the full scan, try again later.")
            end
            AH.UpdateUI()
        end
    end)
    AH.UpdateUI()
    return true
end

-- ── Relevés passifs (recherches normales) ────────────────────────────────
local function PassiveBrowse(results)
    if not Opt("ah_passive") or not results then return end
    local batch = {}
    for _, r in ipairs(results) do
        local id = r.itemKey and r.itemKey.itemID
        if id and r.minPrice and r.minPrice > 0 then
            -- plusieurs variantes (niveau d'objet, suffixe) peuvent partager un ID : minimum et total
            local b = batch[id]
            if b then b[1] = math.min(b[1], r.minPrice); b[2] = b[2] + (r.totalQuantity or 0)
            else batch[id] = { r.minPrice, r.totalQuantity or 1 } end
        end
    end
    AH.Commit(batch, true)
end

local function PassiveLegacyPage()
    if not Opt("ah_passive") or not GetNumAuctionItems then return end
    local n, total = GetNumAuctionItems("list")
    n = n or 0
    if n <= 0 or n > 200 then return end   -- une page de recherche, pas un scan complet
    local batch = {}
    for k = 1, n do
        local name, count, buyout, id = LegacyInfo(k)
        Collect(batch, id, buyout, count, name)
    end
    -- Tous les résultats tiennent sur cette page : les quantités des objets vus sont complètes
    AH.Commit(batch, false, total ~= nil and total <= n)
end

events:SetScript("OnEvent", function(_, ev, ...)
    if not FC.db then return end
    if Opt("ah_enabled") == false and ev ~= "AUCTION_HOUSE_CLOSED" then
        if ev == "AUCTION_HOUSE_SHOW" then AH.open = true; AH.CreateUI(); AH.UpdateUI() end
        return
    end
    if ev == "AUCTION_HOUSE_SHOW" then
        AH.open = true
        AH.CreateUI()
        AH.UpdateUI()
        if Opt("ah_autoscan") and AH.CanFullScan() then
            C_Timer.After(1.5, function() if AH.open then AH.FullScan(true) end end)
        end
    elseif ev == "AUCTION_HOUSE_CLOSED" then
        AH.open = false
        if AH.state and not AH.state.processing then AH.state = nil end
        events:UnregisterEvent("REPLICATE_ITEM_LIST_UPDATE")
    elseif ev == "REPLICATE_ITEM_LIST_UPDATE" then
        events:UnregisterEvent("REPLICATE_ITEM_LIST_UPDATE")
        if AH.state and AH.state.api == "modern" and not AH.state.processing then
            AH.state.processing = true
            local n = C_AuctionHouse.GetNumReplicateItems() or 0
            if n == 0 then Finish({}, 0) else Process(n, ModernInfo, 0) end   -- index à partir de 0
        end
    elseif ev == "AUCTION_ITEM_LIST_UPDATE" then
        if AH.state and AH.state.api == "legacy" then
            if not AH.state.processing then
                AH.state.processing = true
                local n = GetNumAuctionItems("list") or 0
                if n == 0 then Finish({}, 0) else Process(n, LegacyInfo, 1) end
            end
        else
            PassiveLegacyPage()
        end
    elseif ev == "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" then
        if C_AuctionHouse and C_AuctionHouse.GetBrowseResults then PassiveBrowse(C_AuctionHouse.GetBrowseResults()) end
    elseif ev == "AUCTION_HOUSE_BROWSE_RESULTS_ADDED" then
        PassiveBrowse((...))
    elseif ev == "COMMODITY_SEARCH_RESULTS_UPDATED" then
        local id = ...
        if Opt("ah_passive") and id and C_AuctionHouse.GetCommoditySearchResultInfo then
            local info = C_AuctionHouse.GetCommoditySearchResultInfo(id, 1)
            if info and info.unitPrice and info.unitPrice > 0 then
                local qty = C_AuctionHouse.GetCommoditySearchResultsQuantity and C_AuctionHouse.GetCommoditySearchResultsQuantity(id) or info.quantity
                AH.Commit({ [id] = { info.unitPrice, qty or 1 } }, true)
            end
        end
    end
end)

function FC:initAuction()
    for _, ev in ipairs({ "AUCTION_HOUSE_SHOW", "AUCTION_HOUSE_CLOSED", "AUCTION_ITEM_LIST_UPDATE",
        "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED", "AUCTION_HOUSE_BROWSE_RESULTS_ADDED", "COMMODITY_SEARCH_RESULTS_UPDATED" }) do
        pcall(events.RegisterEvent, events, ev)   -- certains évènements n'existent pas selon le client
    end
    -- Nettoyage de l'historique trop ancien (une fois par jour)
    local db = DB()
    if db and (db.pruned or 0) < Today() then
        local cut = Today() - (Opt("ah_keep_days") or 60)
        for id, e in pairs(db.items) do
            if e.h and e.h:match("^(%d+)") and tonumber(e.h:match("^(%d+)")) < cut then
                local keep = {}
                for _, x in ipairs(AH.ParseHistory(e.h)) do if x[1] >= cut then keep[#keep + 1] = x end end
                e.h = WriteHistory(keep)
            end
            -- objet plus vu depuis la durée de conservation : supprimé
            if (e.t or 0) < (cut * 86400) then db.items[id] = nil end
        end
        db.pruned = Today()
    end
end

-- ── Barre sous la fenêtre de l'HV : bouton de scan + état ────────────────
function AH.CreateUI()
    if ui then return end
    local host = (AH.API() == "modern" and _G.AuctionHouseFrame) or _G.AuctionFrame or _G.AuctionHouseFrame
    if not host then return end
    ui = CreateFrame("Frame", nil, host)
    ui:SetSize(360, 26)
    ui:SetPoint("TOPRIGHT", host, "BOTTOMRIGHT", -4, -2)
    ui.icon = ui:CreateTexture(nil, "ARTWORK")
    ui.icon:SetSize(20, 20); ui.icon:SetPoint("RIGHT", -2, 0)
    ui.icon:SetTexture("Interface\\AddOns\\ForeverCompanion\\Media\\LogoAddon.tga")
    ui.btn = API.CreateMenuButton(ui, 110, 22, "Full scan")
    ui.btn:SetPoint("RIGHT", ui.icon, "LEFT", -4, 0)
    ui.btn:SetScript("OnClick", function() AH.FullScan(false) end)
    ui.btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine(FC.NAME .. " — full scan", 1, 0.82, 0)
        GameTooltip:AddLine("Records the lowest buyout of every item on sale. The game allows one full scan every 15 minutes.", 1, 1, 1, true)
        local db = DB()
        if db and (db.lastFull or 0) > 0 then GameTooltip:AddLine("Last full scan: " .. AH.Age(db.lastFull) .. " ago", 0.7, 0.7, 0.7) end
        GameTooltip:Show()
    end)
    ui.btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    ui.status = ui:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    ui.status:SetPoint("RIGHT", ui.btn, "LEFT", -8, 0); ui.status:SetJustifyH("RIGHT")
    -- Mise à jour du compte à rebours
    ui.elapsed = 0
    ui:SetScript("OnUpdate", function(self, dt)
        self.elapsed = self.elapsed + dt
        if self.elapsed > 1 then self.elapsed = 0; if not AH.state then AH.UpdateUI() end end
    end)
end

function AH.UpdateUI()
    if not ui then return end
    ui:SetShown(Opt("ah_enabled") ~= false)
    if AH.state then
        ui.btn:Disable()
        if not AH.state.processing then Status("Waiting for the server…") end
        return
    end
    local ok, why = AH.CanFullScan()
    if ok then ui.btn:Enable() else ui.btn:Disable() end
    local db = DB()
    if ok then
        Status((db and (db.lastFull or 0) > 0) and ("Last scan " .. AH.Age(db.lastFull) .. " ago") or "No full scan yet")
    else
        Status(why)
    end
end

-- ── Info-bulles ──────────────────────────────────────────────────────────
local function StackCount(tt)
    local owner = tt.GetOwner and tt:GetOwner()
    if type(owner) ~= "table" then return nil end
    local n = tonumber(rawget(owner, "count") or owner.count)
    if not n and type(owner.Count) == "table" and type(owner.Count.GetText) == "function" then n = tonumber(owner.Count:GetText()) end   -- bouton d'objet des sacs
    return (n and n > 1) and n or nil
end

-- Prix à l'unité ; avec Maj enfoncée, prix de la pile survolée en plus
function FC:AddPriceLines(tt, id)
    if not FC.db or Opt("ah_enabled") == false then return false end
    local added = false
    local stack = StackCount(tt)
    local showStack = stack and IsShiftKeyDown and IsShiftKeyDown()
    local e = FC:GetAuctionEntry(id)
    if e and e.m and Opt("ah_tooltip") ~= false then
        tt:AddDoubleLine("|cffffd100Auction|r |cff9d9d9d(" .. AH.Age(e.t) .. ")|r", API.Money(e.m, true), 1, 1, 1, 1, 1, 1)
        if showStack then tt:AddDoubleLine("  Stack x" .. stack, API.Money(e.m * stack, true), 0.7, 0.7, 0.7, 1, 1, 1) end
        if Opt("ah_tooltip_avg") and e.a and e.a ~= e.m then
            tt:AddDoubleLine("  7-day average", API.Money(e.a, true), 0.7, 0.7, 0.7, 1, 1, 1)
        end
        added = true
    end
    if Opt("ah_tooltip_vendor") then
        local sell = select(11, API.GetItemInfo(id))
        if sell and sell > 0 then
            tt:AddDoubleLine("|cffffd100Vendor|r", API.Money(sell, true), 1, 1, 1, 1, 1, 1)
            if showStack then tt:AddDoubleLine("  Stack x" .. stack, API.Money(sell * stack, true), 0.7, 0.7, 0.7, 1, 1, 1) end
            added = true
        end
    end
    return added
end
