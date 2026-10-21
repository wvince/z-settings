-- Forever Companion — Inventory.lua
-- Objets de tes personnages : sacs, équipement, banque, courrier, ventes à l'HV, retenus pour chaque
-- personnage du royaume et affichés dans l'infobulle de l'objet (« Kela : 12 (bags 5, bank 7) »).
-- Sacs et équipement : à jour en continu. Banque, courrier, HV : lus à l'ouverture de la fenêtre ; les
-- envois à tes propres personnages sont ajoutés à leur courrier dès l'envoi.
-- Données : FC.db.global.inventory[royaume][personnage] = { class, faction, bags, equip, bank, mail, auction, seen }
--   (chaque emplacement : [itemID] = nombre).
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local PLACES = { "bags", "equip", "bank", "mail", "auction" }
local LABEL = { bags = "bags", equip = "equipped", bank = "bank", mail = "mail", auction = "auction" }

local function Realm() return (GetRealmName and GetRealmName()) or "?" end
-- Nombre d'objets d'une pièce jointe : le jeu actuel renvoie (nom, ID, icône, nombre…), l'ancien (nom, icône, nombre…)
local function AttachCount(id, fn, ...)
    local r = { pcall(fn, ...) }
    if not r[1] then return 1 end
    if r[3] == id then return tonumber(r[5]) or 1 end
    return tonumber(r[4]) or 1
end
local function Me() return (UnitName and UnitName("player")) or "?" end
local function On() return FC.db ~= nil and FC.db.global.inventory_enabled ~= false end

local function Store()
    local g = FC.db.global
    g.inventory = g.inventory or {}
    local realm = Realm()
    g.inventory[realm] = g.inventory[realm] or {}
    return g.inventory[realm]
end
local function MyData()
    local all = Store()
    local me = Me()
    local d = all[me] or {}
    all[me] = d
    local _, token = UnitClass("player")
    d.class = token or d.class
    d.faction = (UnitFactionGroup and UnitFactionGroup("player")) or d.faction
    d.seen = time()
    return d
end

-- ── Lecture des conteneurs ───────────────────────────────────────────────
local function NumSlots(bag)
    local fn = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
    if not fn then return 0 end
    local ok, n = pcall(fn, bag)
    return ok and tonumber(n) or 0
end
local function SlotItem(bag, slot)
    if C_Container and C_Container.GetContainerItemInfo then
        local ok, info = pcall(C_Container.GetContainerItemInfo, bag, slot)
        if ok and type(info) == "table" and info.itemID then return info.itemID, info.stackCount or 1 end
        return nil
    end
    if GetContainerItemInfo then
        local ok, _, count, _, _, _, _, link, _, _, id = pcall(GetContainerItemInfo, bag, slot)
        if not ok then return nil end
        id = id or (link and tonumber(tostring(link):match("item:(%d+)")))
        if id then return id, count or 1 end
    end
end
local function ReadBags(list)
    local t = {}
    for _, bag in ipairs(list) do
        for slot = 1, NumSlots(bag) do
            local id, n = SlotItem(bag, slot)
            if id then t[id] = (t[id] or 0) + (n or 1) end
        end
    end
    return t
end
local function EquippedBags() return NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS or 4 end   -- (+ sac de composants du jeu actuel)
local function BagList()
    local l = {}
    for b = 0, EquippedBags() do l[#l + 1] = b end
    if KEYRING_CONTAINER then l[#l + 1] = KEYRING_CONTAINER end   -- trousseau de clés (Classic)
    return l
end
local function BankList()
    local l = { BANK_CONTAINER or -1 }
    local first = EquippedBags() + 1
    for b = first, first + (NUM_BANKBAGSLOTS or 6) - 1 do l[#l + 1] = b end
    return l
end
-- Les sacs eux-mêmes (posés dans les emplacements de sac) comptent aussi
local function AddBagItems(t, from, to)
    local fn = (C_Container and C_Container.ContainerIDToInventoryID) or ContainerIDToInventoryID
    if not fn or not GetInventoryItemID then return end
    for b = from, to do
        local ok, slot = pcall(fn, b)
        local id = ok and slot and GetInventoryItemID("player", slot)
        if id then t[id] = (t[id] or 0) + 1 end
    end
end

local function ScanBags()
    if not On() then return end
    local d = MyData()
    d.bags = ReadBags(BagList())
    local eq = {}
    for slot = 0, 19 do
        local id = GetInventoryItemID and GetInventoryItemID("player", slot)
        if id then
            local n = (slot == 0 and GetInventoryItemCount) and GetInventoryItemCount("player", 0) or 1   -- munitions
            eq[id] = (eq[id] or 0) + math.max(1, n or 1)
        end
    end
    AddBagItems(eq, 1, EquippedBags())
    d.equip = eq
end
local bankOpen = false
local function ScanBank()
    -- Banque fermée (ou pas encore remplie) : on garde le dernier relevé
    if not On() or not bankOpen or NumSlots(BANK_CONTAINER or -1) == 0 then return end
    local t = ReadBags(BankList())
    local first = EquippedBags() + 1
    AddBagItems(t, first, first + (NUM_BANKBAGSLOTS or 6) - 1)
    MyData().bank = t
end

-- Courrier : objets joints aux lettres de la boîte
local function ScanMail()
    if not On() or not GetInboxNumItems then return end
    local t = {}
    local per = ATTACHMENTS_MAX_RECEIVE or 16
    for i = 1, (GetInboxNumItems() or 0) do
        for a = 1, per do
            local link = GetInboxItemLink and GetInboxItemLink(i, a)
            local id = link and tonumber(tostring(link):match("item:(%d+)"))
            if id then t[id] = (t[id] or 0) + AttachCount(id, GetInboxItem, i, a) end
        end
    end
    MyData().mail = t
end

-- Envoi à un de mes personnages (même royaume) : ajouté à son courrier tout de suite
local pendingSend
local function CaptureSend(recipient)
    if not On() or not recipient or recipient == "" then return end
    local typed = tostring(recipient):gsub("%-.*$", "")   -- « Nom-Royaume » → « Nom »
    local name
    for k in pairs(Store()) do if k:lower() == typed:lower() then name = k end end
    if not name or name == Me() then return end
    local t = {}
    for a = 1, (ATTACHMENTS_MAX_SEND or 12) do
        local link = GetSendMailItemLink and GetSendMailItemLink(a)
        local id = link and tonumber(tostring(link):match("item:(%d+)"))
        if id then t[id] = (t[id] or 0) + AttachCount(id, GetSendMailItem, a) end
    end
    pendingSend = next(t) and { name = name, items = t } or nil
end
local function SendDone()
    local p = pendingSend
    pendingSend = nil
    if not p then return end
    local d = Store()[p.name]
    if not d then return end
    d.mail = d.mail or {}
    for id, n in pairs(p.items) do d.mail[id] = (d.mail[id] or 0) + n end
end
FC.InventoryCaptureSend, FC.InventorySendDone = CaptureSend, SendDone   -- tests

-- Ventes en cours à l'HV
local function ScanAuctions()
    if not On() then return end
    local t, got = {}, false
    -- L'ancienne API d'abord : le client Classic possède aussi C_AuctionHouse, mais son HV utilise l'ancienne (voir Auction.lua)
    if GetNumAuctionItems and GetAuctionItemInfo then
        got = true
        for i = 1, (GetNumAuctionItems("owner") or 0) do
            local _, _, count, _, _, _, _, _, _, _, _, _, _, _, _, saleStatus, id = GetAuctionItemInfo("owner", i)
            if not id then
                local link = GetAuctionItemLink and GetAuctionItemLink("owner", i)
                id = link and tonumber(tostring(link):match("item:(%d+)"))
            end
            if id and saleStatus ~= 1 then t[id] = (t[id] or 0) + (tonumber(count) or 1) end   -- 1 : déjà vendue
        end
    elseif C_AuctionHouse and C_AuctionHouse.GetNumOwnedAuctions then
        got = true
        for i = 1, (C_AuctionHouse.GetNumOwnedAuctions() or 0) do
            local a = C_AuctionHouse.GetOwnedAuctionInfo(i)
            local id = a and a.itemKey and a.itemKey.itemID
            if id and a.status ~= 1 then t[id] = (t[id] or 0) + (a.quantity or 1) end   -- status 1 : déjà vendue
        end
    end
    if got then MyData().auction = t end
end
FC.InventoryScan = { bags = ScanBags, bank = ScanBank, mail = ScanMail, auction = ScanAuctions }   -- tests

-- ── Infobulle ────────────────────────────────────────────────────────────
local function ClassHex(token)
    local c = token and ((CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[token]) or (RAID_CLASS_COLORS and RAID_CLASS_COLORS[token]))
    if not c then return "|cffffd100" end
    return string.format("|cff%02x%02x%02x", (c.r or 1) * 255, (c.g or 1) * 255, (c.b or 1) * 255)
end
-- Lignes { nom coloré, total, détail } des personnages qui ont l'objet (moi d'abord, puis par nom)
function FC:InventoryLines(itemId)
    if not On() or not itemId then return {} end
    local all = Store()
    local myFaction = UnitFactionGroup and UnitFactionGroup("player")
    local cross = FC.db.global.inventory_cross ~= false
    local me = Me()
    local names = {}
    for name, d in pairs(all) do
        if cross or not myFaction or not d.faction or d.faction == myFaction then names[#names + 1] = name end
    end
    local out = {}
    for _, name in ipairs(names) do
        local d = all[name]
        local total, parts = 0, {}
        for _, p in ipairs(PLACES) do
            local n = d[p] and d[p][itemId]
            if n and n > 0 then total = total + n; parts[#parts + 1] = LABEL[p] .. " " .. n end
        end
        if total > 0 then out[#out + 1] = { name = ClassHex(d.class) .. name .. "|r", raw = name, me = (name == me), total = total, detail = table.concat(parts, ", ") } end
    end
    -- Personnage connecté d'abord, puis ceux qui en ont le plus (à égalité : ordre alphabétique)
    table.sort(out, function(a, b)
        if a.me ~= b.me then return a.me end
        if a.total ~= b.total then return a.total > b.total end
        return a.raw < b.raw
    end)
    return out
end
-- Nombre de personnages affichés (Options : 3 par défaut, 0 = tous) ; Alt : tous
function FC:InventoryMaxLines()
    local n = tonumber(FC.db and FC.db.global.inventory_max) or 3
    if n <= 0 or (IsAltKeyDown and IsAltKeyDown()) then return nil end
    return n
end
function FC:AddInventoryLines(tooltip, itemId)
    local lines = self:InventoryLines(itemId)
    if #lines == 0 then return false end
    local max = self:InventoryMaxLines()
    local sum = 0
    for i, l in ipairs(lines) do
        if not max or i <= max then tooltip:AddDoubleLine(l.name, l.total .. "  |cff9d9d9d(" .. l.detail .. ")|r", 1, 1, 1, 1, 1, 1) end
        sum = sum + l.total
    end
    local hidden = max and #lines - max or 0
    if hidden > 0 then
        tooltip:AddLine("|cff9d9d9d+" .. hidden .. " more character" .. (hidden > 1 and "s" or "") .. " (Alt: show all)|r")
    end
    if #lines > 1 then tooltip:AddDoubleLine("|cffffd100Total|r", tostring(sum), 1, 0.82, 0, 1, 1, 1) end
    return true
end

-- Personnages connus du royaume (Options : oublier un personnage)
function FC:InventoryCharacters()
    local t = {}
    for name, d in pairs(Store()) do t[#t + 1] = { name = name, class = d.class, faction = d.faction } end
    table.sort(t, function(a, b) return a.name < b.name end)
    return t
end
function FC:InventoryForget(name)
    Store()[name] = nil
    if name == Me() then ScanBags() end   -- le personnage connecté se remet à jour
end

-- ── Évènements ───────────────────────────────────────────────────────────
local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_LOGIN", "BAG_UPDATE_DELAYED", "PLAYER_EQUIPMENT_CHANGED", "BANKFRAME_OPENED", "BANKFRAME_CLOSED",
    "PLAYERBANKSLOTS_CHANGED", "MAIL_INBOX_UPDATE", "MAIL_SEND_SUCCESS", "MAIL_FAILED", "OWNED_AUCTIONS_UPDATED", "AUCTION_OWNED_LIST_UPDATE" }) do
    pcall(ev.RegisterEvent, ev, e)
end
local bagQueued = false
local function QueueBags()
    if bagQueued then return end
    bagQueued = true
    C_Timer.After(0.5, function() bagQueued = false; ScanBags(); ScanBank() end)
end
ev:SetScript("OnEvent", function(_, e)
    if e == "PLAYER_LOGIN" then
        if type(rawget(_G, "SendMail")) == "function" then hooksecurefunc("SendMail", CaptureSend) end
        C_Timer.After(2, ScanBags)
    elseif e == "BAG_UPDATE_DELAYED" or e == "PLAYER_EQUIPMENT_CHANGED" or e == "PLAYERBANKSLOTS_CHANGED" then QueueBags()
    elseif e == "BANKFRAME_OPENED" then bankOpen = true; ScanBank()
    elseif e == "BANKFRAME_CLOSED" then bankOpen = false
    elseif e == "MAIL_INBOX_UPDATE" then ScanMail()
    elseif e == "MAIL_SEND_SUCCESS" then SendDone()
    elseif e == "MAIL_FAILED" then pendingSend = nil
    elseif e == "OWNED_AUCTIONS_UPDATED" or e == "AUCTION_OWNED_LIST_UPDATE" then ScanAuctions()
    end
end)
FC.InventorySetBankOpen = function(v) bankOpen = v end   -- tests
