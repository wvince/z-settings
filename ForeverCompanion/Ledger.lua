-- Forever Companion — Ledger.lua
-- Ventes et achats à l'hôtel des ventes (lus dans les factures du courrier) et
-- suivi de l'or de chaque personnage du royaume (pour le graphique).
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local LG = {}
FC.Ledger = LG
local MAX_ENTRIES = 5000
local function Now() return time() end
local function Opt(k) return FC.db and FC.db.global[k] end

-- ── Or (sur le modèle du « Gold Log » de TradeSkillMaster) ─────────────
-- Par personnage, des périodes { début, fin, argent } en minutes : une période dure tant
-- que l'argent ne change pas, et sa fin avance chaque minute pendant la session.
-- Hors session, le personnage garde sa dernière valeur (son or ne bouge pas déconnecté).
-- Un 0 n'est accepté que si le jeu signale un vrai changement d'argent (PLAYER_MONEY) :
-- à la connexion, GetMoney() peut renvoyer 0 avant que l'argent soit chargé.
-- FC.db.global.goldLog[royaume][perso] = { c = classe, m = argent actuel, seg = "d:f:m,d:f:m" }
local function RealmName() return (GetRealmName and GetRealmName()) or "?" end
local function CharName() return (UnitName and UnitName("player")) or "?" end
local function NowMin() return math.floor(Now() / 60) end
local MAX_SEGMENTS = 3000

function LG.ParseSegments(txt)
    local out = {}
    for d, f, m in tostring(txt or ""):gmatch("(%d+):(%d+):(%d+)") do out[#out + 1] = { tonumber(d), tonumber(f), tonumber(m) } end
    return out
end
local function WriteSegments(list)
    local p = {}
    for _, e in ipairs(list) do p[#p + 1] = e[1] .. ":" .. e[2] .. ":" .. e[3] end
    return table.concat(p, ",")
end
local function Realm()
    local all = FC.db.global.goldLog
    local r = RealmName()
    all[r] = all[r] or {}
    return all[r]
end
local function Me()
    local realm, name = Realm(), CharName()
    realm[name] = realm[name] or {}
    local c = realm[name]
    local _, token = UnitClass("player")
    c.c = token or c.c
    return c
end

local session = { ready = false }

-- Enregistre l'argent actuel ; trusted = changement signalé par le jeu
function LG.RecordGold(trusted)
    if not FC.db or Opt("ah_enabled") == false or Opt("gold_track") == false or not GetMoney then return end
    local money = GetMoney() or 0
    local c = Me()
    if money == 0 and not trusted and (c.m or 0) > 0 then return end
    local now = NowMin()
    local segs = LG.ParseSegments(c.seg)
    local last = segs[#segs]
    if last and last[3] == money then
        last[2] = now
    elseif last and last[1] == now and last[2] == now then
        last[3] = money                                   -- plusieurs changements dans la même minute
    else
        if last and last[2] < now and session.ready then last[2] = now end   -- fin de la période précédente
        segs[#segs + 1] = { now, now, money }
    end
    while #segs > MAX_SEGMENTS do table.remove(segs, 1) end
    c.m, c.t, c.seg = money, Now(), WriteSegments(segs)
    session.ready = true
end

-- Chaque minute pendant la session : la période en cours s'allonge
local function Touch()
    if not session.ready or not FC.db or Opt("gold_track") == false or Opt("ah_enabled") == false then return end
    local c = Me()
    local segs = LG.ParseSegments(c.seg)
    local last = segs[#segs]
    if last and last[3] == (GetMoney and GetMoney() or -1) then
        last[2] = NowMin(); c.seg = WriteSegments(segs); c.t = Now()
    end
end

-- Connexion : on attend que l'argent soit connu (jusqu'à 15 s) avant le premier relevé
local function StartSession()
    session.ready = false
    local tries = 0
    local function try()
        tries = tries + 1
        local money = GetMoney and GetMoney() or 0
        local c = Me()
        if money > 0 or (c.m or 0) == 0 and tries >= 3 then LG.RecordGold(false); return end
        if tries < 15 and C_Timer and C_Timer.After then C_Timer.After(1, try) end
    end
    if C_Timer and C_Timer.After then C_Timer.After(1, try) else try() end
end

-- Au-delà de 30 jours : une période par jour (la dernière valeur de la journée)
local function CompactGold()
    local cut = NowMin() - 30 * 1440
    for _, chars in pairs(FC.db.global.goldLog) do
        for _, c in pairs(chars) do
            local segs, out, lastDay = LG.ParseSegments(c.seg), {}, nil
            for _, e in ipairs(segs) do
                if e[2] < cut then
                    local d = math.floor(e[1] / 1440)
                    if d == lastDay then out[#out][2], out[#out][3] = e[2], e[3] else out[#out + 1] = e; lastDay = d end
                else out[#out + 1] = e end
            end
            if #out < #segs then c.seg = WriteSegments(out) end
        end
    end
end

-- Personnages du royaume : liste triée { name, class, money, t }
function LG.Characters()
    local out = {}
    for name, c in pairs((FC.db and FC.db.global.goldLog[RealmName()]) or {}) do
        out[#out + 1] = { name = name, class = c.c, money = c.m or 0, t = c.t }
    end
    table.sort(out, function(a, b) return a.money > b.money end)
    return out
end

-- Argent de chaque personnage à l'instant t (secondes) : { {name, class, money} }
function LG.ValuesAt(t)
    local out = {}
    local tm = math.floor(t / 60)
    for name, c in pairs((FC.db and FC.db.global.goldLog[RealmName()]) or {}) do
        local segs = LG.ParseSegments(c.seg)
        local v = segs[1] and segs[1][3] or c.m or 0
        for _, e in ipairs(segs) do if e[1] <= tm then v = e[3] else break end end
        out[#out + 1] = { name = name, class = c.c, money = v }
    end
    table.sort(out, function(a, b) return a.money > b.money end)
    return out
end

-- Série { {t, total} } de fromT (secondes) à maintenant, pour un perso ou tous (who = nil).
-- Avant son premier relevé, un perso compte pour sa première valeur connue (pas de saut
-- quand un personnage est vu pour la première fois) ; hors session, sa dernière valeur.
function LG.GoldSeries(who, fromT)
    local chars = (FC.db and FC.db.global.goldLog[RealmName()]) or {}
    local events, cur = {}, {}
    for name, c in pairs(chars) do
        if not who or who == name then
            local segs = LG.ParseSegments(c.seg)
            if #segs == 0 and c.m then segs = { { NowMin(), NowMin(), c.m } } end
            if #segs > 0 then
                cur[name] = segs[1][3]
                for _, e in ipairs(segs) do events[#events + 1] = { e[1] * 60, name, e[3] } end
            end
        end
    end
    table.sort(events, function(a, b) return a[1] < b[1] end)
    local total = 0
    for _, v in pairs(cur) do total = total + v end
    local first = (events[1] and events[1][1]) or Now()
    local startT = math.max(fromT or first, first)
    for _, e in ipairs(events) do
        if e[1] > startT then break end
        total = total - cur[e[2]] + e[3]; cur[e[2]] = e[3]
    end
    local series = { { startT, total } }
    for _, e in ipairs(events) do
        if e[1] > startT then
            total = total - cur[e[2]] + e[3]; cur[e[2]] = e[3]
            series[#series + 1] = { e[1], total }
        end
    end
    series[#series + 1] = { Now(), total }
    return series
end

-- ── Conversion des anciennes données (jamais d'effacement lors d'une mise à jour) ──
-- Bêtas ≤ 54 : FC.db.global.gold[royaume][perso] = { c, m, t, h = "secondes:argent,…" }.
-- Les relevés à 0 d'un perso qui a déjà eu de l'argent étaient des lectures faites avant
-- le chargement de l'argent : ils sont écartés. L'ancien bloc n'est retiré qu'une fois
-- la conversion réussie ; les périodes déjà enregistrées au nouveau format sont gardées.
local function MigrateOldGold()
    local old = FC.db.global.gold
    if type(old) ~= "table" then return end
    local log = FC.db.global.goldLog
    local ok = pcall(function()
        for realm, chars in pairs(old) do
            for name, oc in pairs(type(chars) == "table" and chars or {}) do
                if type(oc) == "table" then
                    local pts, anyMoney = {}, false
                    for t, m in tostring(oc.h or ""):gmatch("(%d+):(%d+)") do
                        pts[#pts + 1] = { tonumber(t), tonumber(m) }
                        if tonumber(m) > 0 then anyMoney = true end
                    end
                    table.sort(pts, function(a, b) return a[1] < b[1] end)
                    local conv = {}
                    for _, p in ipairs(pts) do
                        if p[2] > 0 or not anyMoney then
                            local mn, last = math.floor(p[1] / 60), conv[#conv]
                            if last and last[3] == p[2] then last[2] = math.max(last[2], mn)
                            elseif last and last[1] == mn then last[3] = p[2]
                            else conv[#conv + 1] = { mn, mn, p[2] } end
                        end
                    end
                    log[realm] = log[realm] or {}
                    local nc = log[realm][name]
                    local lastOld = conv[#conv] and conv[#conv][3]
                    if not nc then
                        log[realm][name] = { c = oc.c, m = lastOld or oc.m or 0, t = oc.t, seg = WriteSegments(conv) }
                    else
                        local cur = LG.ParseSegments(nc.seg)
                        local firstNew = cur[1] and cur[1][1] or math.huge
                        local merged = {}
                        for _, e in ipairs(conv) do if e[1] < firstNew then merged[#merged + 1] = { e[1], math.min(e[2], firstNew), e[3] } end end
                        for _, e in ipairs(cur) do merged[#merged + 1] = e end
                        while #merged > MAX_SEGMENTS do table.remove(merged, 1) end
                        nc.seg, nc.c, nc.m = WriteSegments(merged), nc.c or oc.c, nc.m or lastOld
                    end
                end
            end
        end
    end)
    if ok then FC.db.global.gold = nil end   -- en cas d'erreur, l'ancien bloc reste intact
end
LG.MigrateOldGold = MigrateOldGold

function LG.ClearGold()
    FC.db.global.goldLog[RealmName()] = nil
    session.ready = false
    LG.RecordGold(false)
end
LG.SampleGold = LG.RecordGold   -- ancien nom

-- ── Ventes et achats (factures du courrier de l'HV) ──────────────────────
-- FC.db.factionrealm.ledger.list = { {k="sale"|"buy", t=date, id=, n=nom, q=quantité, p=prix total, f=commission, o=autre joueur, c=perso} }
local function Ledger() return FC.db and FC.db.factionrealm.ledger end

-- Nom d'objet → ID (base des prix de l'HV, sinon cache du jeu)
local nameIndex, nameIndexAt = nil, 0
local function ItemIdByName(name)
    if not name then return nil end
    local function build()
        nameIndex, nameIndexAt = {}, Now()
        for id, e in pairs((FC.db and FC.db.factionrealm.ah.items) or {}) do if e.n then nameIndex[e.n] = id end end
    end
    if not nameIndex then build() end
    if nameIndex[name] then return nameIndex[name] end
    local id = tonumber((API.GetItemInfoInstant(name)))
    if id then return id end
    if Now() - nameIndexAt > 60 then build(); return nameIndex[name] end   -- nouveaux prix relevés depuis
end

function LG.ScanInbox()
    local L = Ledger()
    if not L or Opt("ah_enabled") == false or Opt("ledger_track") == false or not GetInboxNumItems or not GetInboxInvoiceInfo then return 0 end
    local now = Now()
    -- Regroupe les factures identiques (même objet, même joueur, même prix) arrivées à moins d'une heure d'écart
    local groups, order = {}, {}
    local me = CharName()   -- chaque personnage a sa propre boîte aux lettres
    for i = 1, (GetInboxNumItems() or 0) do
        local _, _, _, subject, money, _, daysLeft, hasItem = GetInboxHeaderInfo(i)
        local kind, itemName, player, bid, _, _, consignment, _, _, _, count = GetInboxInvoiceInfo(i)
        -- Courrier déjà vidé (argent ou objet retiré) : sa date d'expiration peut changer, on l'ignore
        if (kind == "seller" and (money or 0) == 0) or (kind == "buyer" and not hasItem) then kind = nil end
        if (kind == "seller" or kind == "buyer") and itemName and bid then
            local received = now - math.floor((30 - (daysLeft or 30)) * 86400)
            local q = tonumber(count) or tonumber(subject and subject:match("%((%d+)%)%s*$"))
            local base = table.concat({ me, kind, itemName, player or "", bid }, "|")
            local g
            for _, x in ipairs(groups[base] or {}) do if math.abs(x.t - received) < 3600 then g = x end end
            if not g then
                g = { t = received, n = 0, e = { k = kind == "seller" and "sale" or "buy", n = itemName, o = player, p = bid,
                    f = (kind == "seller" and consignment and consignment > 0) and consignment or nil, q = q } }
                groups[base] = groups[base] or {}
                table.insert(groups[base], g); order[#order + 1] = { base, g }
            end
            g.n = g.n + 1
        end
    end
    -- Nouvelles factures = celles qu'on n'avait pas encore comptées
    local added = 0
    for _, bg in ipairs(order) do
        local base, g = bg[1], bg[2]
        L.seen[base] = L.seen[base] or {}
        local known
        for _, s in ipairs(L.seen[base]) do if math.abs(s.t - g.t) < 3600 then known = s end end
        local new = g.n - (known and known.n or 0)
        if known then known.n = math.max(known.n, g.n) else table.insert(L.seen[base], { t = g.t, n = g.n }) end
        for _ = 1, math.max(0, new) do
            local e = {}
            for k, v in pairs(g.e) do e[k] = v end
            e.t, e.c, e.id = g.t, me, ItemIdByName(e.n)
            table.insert(L.list, e)
            added = added + 1
        end
    end
    if added > 0 then
        table.sort(L.list, function(a, b) return a.t > b.t end)
        while #L.list > MAX_ENTRIES do table.remove(L.list) end
        if FC.RefreshMarket then FC:RefreshMarket("sales") end
    end
    return added
end

-- Oubli des factures plus vieilles que la durée de vie du courrier
local function PruneSeen()
    local L = Ledger(); if not L then return end
    local cut = Now() - 40 * 86400
    for base, list in pairs(L.seen) do
        local keep = {}
        for _, s in ipairs(list) do if s.t >= cut then keep[#keep + 1] = s end end
        L.seen[base] = #keep > 0 and keep or nil
    end
end

-- Liste filtrée : kind = "sale" | "buy" | nil ; days = nil (tout) ; q = texte normalisé
function LG.Entries(kind, days, q)
    local L = Ledger(); if not L then return {} end
    local out, cut = {}, days and (Now() - days * 86400) or nil
    for _, e in ipairs(L.list) do
        if not e.id and e.n then e.id = tonumber((API.GetItemInfoInstant(e.n))) end   -- objet connu depuis
        if (not kind or e.k == kind) and (not cut or e.t >= cut) and (not q or q == "" or API.Has(q, API.SearchNorm(e.n or ""))) then
            out[#out + 1] = e
        end
    end
    return out
end

-- ── Évènements ───────────────────────────────────────────────────────────
local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, e)
    if not FC.db then return end
    if e == "MAIL_INBOX_UPDATE" then LG.ScanInbox()
    elseif e == "PLAYER_MONEY" then LG.RecordGold(true)
    elseif e == "PLAYER_ENTERING_WORLD" then StartSession()
    elseif e == "PLAYER_LEAVING_WORLD" then Touch()   -- fin de session : la période s'arrête ici
    end
end)

function FC:initLedger()
    for _, e in ipairs({ "PLAYER_MONEY", "PLAYER_ENTERING_WORLD", "PLAYER_LEAVING_WORLD", "MAIL_INBOX_UPDATE" }) do
        pcall(ev.RegisterEvent, ev, e)
    end
    FC.db.global.goldLog = FC.db.global.goldLog or {}
    MigrateOldGold()   -- ancien format converti, jamais effacé
    CompactGold()
    if C_Timer and C_Timer.NewTicker and not session.ticker then session.ticker = C_Timer.NewTicker(60, Touch) end
    PruneSeen()
end
