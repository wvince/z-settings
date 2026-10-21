-- Forever Companion — GatherMap.lua
-- Points de récolte (plantes, filons) sur la carte du monde et la minicarte, comme GatherMate :
--   * positions relevées par Wowhead (Data/Nodes.lua, généré par le Studio) ;
--   * plus les points que tu récoltes toi-même (enregistrés en jeu, pour les zones où Wowhead manque) ;
--   * icône de l'herbe / du minerai, assombrie et rougie si ta compétence est trop basse.
-- Données : ForeverCompanionData.nodes[zone] = { {sl, n, l, it, o, p}, … } ; p = 4 caractères par point
-- (x puis y en dixièmes de % de la carte de la zone, base 36).
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local TEMPLATE = "ForeverCompanionNodePinTemplate"
local GATHER_SL = { [182] = true, [186] = true }   -- herboristerie, minage
local ZONE_TYPE = (Enum and Enum.UIMapType and Enum.UIMapType.Zone) or 3

local function Opt(k) return FC.db and FC.db.global[k] end
-- Interrupteur général « Gathering locations » (Options → Tabs & features) : coupe carte, minicarte et relevé
local function On() return Opt("gather_enabled") ~= false end
local function Nodes() return (ForeverCompanionData and ForeverCompanionData.nodes) or {} end

-- ── Positions ─────────────────────────────────────────────────────────────
local decoded = {}   -- cache : chaîne → { x1, y1, x2, y2… } (0-1)
local function Decode(p)
    local t = decoded[p]
    if t then return t end
    t = {}
    for i = 1, #p - 3, 4 do
        local x, y = tonumber(p:sub(i, i + 1), 36), tonumber(p:sub(i + 2, i + 3), 36)
        if x and y then t[#t + 1] = x / 1000; t[#t + 1] = y / 1000 end
    end
    decoded[p] = t
    return t
end
local function Encode(x, y)   -- x, y entre 0 et 1
    local function two(v)
        local n = math.max(0, math.min(1000, math.floor(v * 1000 + 0.5)))
        local d = "0123456789abcdefghijklmnopqrstuvwxyz"
        local hi, lo = math.floor(n / 36), n % 36
        return d:sub(hi + 1, hi + 1) .. d:sub(lo + 1, lo + 1)
    end
    return two(x) .. two(y)
end

-- Points appris en jeu : db.global.gather_learned[zone][objet] = « positions » (même format)
local function Learned() return (FC.db and FC.db.global.gather_learned) or {} end

-- Point d'un objet du jeu (ID) → entrée des données (nom, métier, compétence, icône)
local byObject, byItem
local function ObjectIndex()
    if byObject then return byObject, byItem end
    byObject, byItem = {}, {}
    for _, list in pairs(Nodes()) do
        for _, e in ipairs(list) do
            for _, o in ipairs(e.o or {}) do byObject[o] = byObject[o] or e end
            if e.it then byItem[e.it] = byItem[e.it] or e end
        end
    end
    -- Objets du jeu inconnus de Wowhead, reconnus en jeu par ce qu'ils donnent (plante, minerai)
    for oid, it in pairs((FC.db and FC.db.global.gather_objects) or {}) do byObject[oid] = byObject[oid] or byItem[it] end
    return byObject, byItem
end

-- Entrées à afficher dans une zone : données + points appris (regroupés par objet)
local function ZoneEntries(area)
    local out = {}
    for _, e in ipairs(Nodes()[area] or {}) do out[#out + 1] = { e = e, p = e.p } end
    local idx = ObjectIndex()
    for oid, p in pairs(Learned()[area] or {}) do
        local e = idx[oid]
        if e and p ~= "" then out[#out + 1] = { e = e, p = p, learned = true } end
    end
    return out
end

-- Filtre et couleur selon la compétence du joueur
-- renvoie nil (caché) ou l'état : "ok", "low" (trop bas), "gray" (plus rien à gagner)
local function State(e)
    if not GATHER_SL[e.sl] then return nil end
    local ranks = FC.GatherRanks and FC:GatherRanks() or {}
    local rank = ranks[e.sl]
    if not rank and Opt("gather_only_known") ~= false then return nil end
    if not rank then return "ok" end
    local need = e.l or 0
    if rank < need then
        if Opt("gather_hide_low") == true then return nil end
        return "low"
    end
    if rank >= need + 100 then return "gray" end
    return "ok"
end
local function Paint(tex, e, state)
    local icon = (e.it and API.GetItemIcon and API.GetItemIcon(e.it))
        or (e.sl == 182 and "Interface\\Icons\\INV_Misc_Flower_02" or "Interface\\Icons\\INV_Ore_Copper_01")
    tex:SetTexture(icon)
    tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)   -- sans le cadre sombre des icônes d'objet
    if tex.SetDesaturated then tex:SetDesaturated(state == "low" or state == "gray") end
    if state == "low" then tex:SetVertexColor(1, 0.45, 0.45) else tex:SetVertexColor(1, 1, 1) end
    tex:SetAlpha(state == "gray" and 0.6 or 1)
end
-- Minicarte, dans la portée de détection : anneau de couleur (comme GatherMate), le point jaune de
-- la détection du jeu reste visible au centre s'il y a bien une plante ou un filon
local RING = "Interface\\AddOns\\ForeverCompanion\\Media\\NodeRing"
local function PaintRing(tex, e, state)
    tex:SetTexture(RING)
    tex:SetTexCoord(0, 1, 0, 1)
    if tex.SetDesaturated then tex:SetDesaturated(false) end
    if state == "low" then tex:SetVertexColor(1, 0.3, 0.3)
    elseif e.sl == 182 then tex:SetVertexColor(0.3, 1, 0.3)
    else tex:SetVertexColor(1, 0.6, 0.2) end
    tex:SetAlpha(state == "gray" and 0.6 or 1)
end
local function NodeTooltip(owner, e, learned)
    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    GameTooltip:AddLine(e.n or "?", 1, 0.82, 0)
    local prof = e.sl == 182 and "Herbalism" or "Mining"
    local ranks = FC.GatherRanks and FC:GatherRanks() or {}
    local rank = ranks[e.sl]
    local need = e.l or 0
    local r, g, b = 0.6, 0.6, 0.6
    if rank then
        if rank < need then r, g, b = 1, 0.3, 0.3 elseif rank >= need + 100 then r, g, b = 0.6, 0.6, 0.6 else r, g, b = 0.25, 0.75, 0.25 end
    end
    GameTooltip:AddLine(prof .. " " .. need .. (rank and ("  (you: " .. rank .. ")") or ""), r, g, b)
    if learned then GameTooltip:AddLine("Recorded by you", 0.6, 0.8, 1) end
    GameTooltip:Show()
end

-- ── Carte du monde : fournisseur de données de la carte (pins du jeu) ───────
ForeverCompanionNodePinMixin = (CreateFromMixins and MapCanvasPinMixin) and CreateFromMixins(MapCanvasPinMixin) or {}
local Pin = ForeverCompanionNodePinMixin
function Pin:OnLoad()
    if self.UseFrameLevelType then self:UseFrameLevelType("PIN_FRAME_LEVEL_AREA_POI") end
    if self.SetScalingLimits then self:SetScalingLimits(1, 1.0, 1.25) end
end
function Pin:OnAcquired(e, x, y, state, learned)
    self.e, self.learned, self.nx, self.ny, self.faded = e, learned, x, y, nil
    self:SetAlpha(1)
    local size = Opt("gather_icon_size") or 10
    self:SetSize(size, size)
    Paint(self.Icon, e, state)
    self:SetPosition(x, y)
end
function Pin:OnMouseEnter() NodeTooltip(self, self.e, self.learned) end
function Pin:OnMouseLeave() GameTooltip:Hide() end
-- La carte règle les clics qui traversent chaque icône (SetPassThroughButtons) en la créant
-- (AcquirePin). Depuis les dernières mises à jour du client, cette fonction est protégée en combat :
-- appelée pour nos icônes (redessin après une montée de compétence, un changement de zone, la carte
-- ouverte en combat), le jeu bloquait l'appel et affichait une erreur. En combat, on le fait à la fin
-- du combat ; les icônes s'affichent quand même.
local basePassthrough = MapCanvasPinMixin and MapCanvasPinMixin.CheckMouseButtonPassthrough
local pendingPass = setmetatable({}, { __mode = "k" })
function Pin:CheckMouseButtonPassthrough(...)
    if not basePassthrough then return end
    if InCombatLockdown and InCombatLockdown() then
        pendingPass[self] = { n = select("#", ...), ... }
        return
    end
    pendingPass[self] = nil
    return basePassthrough(self, ...)
end
local function FlushPassthrough()
    if not basePassthrough or (InCombatLockdown and InCombatLockdown()) then return end
    for pin, a in pairs(pendingPass) do
        pendingPass[pin] = nil
        pcall(basePassthrough, pin, unpack(a, 1, a.n))
    end
end

local provider
local function CurrentZone(map)
    local mapID = map and map.GetMapID and map:GetMapID()
    local info = mapID and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
    if not info or info.mapType ~= ZONE_TYPE then return nil end
    return FC.AreaForMap and FC:AreaForMap(mapID, info.name)
end
local function MakeProvider()
    if provider or not (CreateFromMixins and MapCanvasDataProviderMixin) then return provider end
    provider = CreateFromMixins(MapCanvasDataProviderMixin)
    function provider:RemoveAllData() self:GetMap():RemoveAllPinsByTemplate(TEMPLATE); self.pins = {} end
    function provider:RefreshAllData()
        self:RemoveAllData()
        if not On() or Opt("gather_worldmap") == false then return end
        local area = CurrentZone(self:GetMap())
        if not area then return end
        local n = 0
        for _, z in ipairs(ZoneEntries(area)) do
            local state = State(z.e)
            if state then
                local pts = Decode(z.p)
                for i = 1, #pts - 1, 2 do
                    if n >= 3000 then return end   -- garde-fou : carte lisible, jeu fluide
                    local pin = self:GetMap():AcquirePin(TEMPLATE, z.e, pts[i], pts[i + 1], state, z.learned)
                    if pin then self.pins[#self.pins + 1] = pin end
                    n = n + 1
                end
            end
        end
    end
    function provider:OnMapChanged() self:RefreshAllData() end
    return provider
end
-- Icônes proches de ma position (flèche du joueur) presque transparentes, pour continuer à se voir
local FADE_PX, FADE_ALPHA = 24, 0.2
local function FadeNearPlayer()
    if not (provider and provider.pins and WorldMapFrame and WorldMapFrame:IsShown()) then return end
    local map = provider:GetMap()
    local mapID = map and map.GetMapID and map:GetMapID()
    local pos = mapID and Opt("gather_fade_player") ~= false and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(mapID, "player")
    local canvas = pos and map.GetCanvas and map:GetCanvas()
    local px, py = pos and (pos.x or (pos.GetXY and select(1, pos:GetXY()))), pos and (pos.y or (pos.GetXY and select(2, pos:GetXY())))
    local l, b, w, h
    if canvas and px then l, b, w, h = canvas:GetRect() end
    if not (l and w and w > 0) then
        for _, pin in ipairs(provider.pins) do if pin.faded then pin.faded = nil; pin:SetAlpha(1) end end
        return
    end
    local cs = canvas:GetEffectiveScale()
    -- Distance en pixels de l'écran, calculée sur la position de chaque icône dans la carte (pas de
    -- GetCenter : des centaines d'icônes, 5 fois par seconde)
    local sw, sh = w * cs, h * cs
    local r = FADE_PX * (UIParent and UIParent:GetEffectiveScale() or 1)
    local r2 = r * r
    for _, pin in ipairs(provider.pins) do
        local near = false
        if pin.nx then
            local dx, dy = (pin.nx - px) * sw, (pin.ny - py) * sh
            near = dx * dx + dy * dy < r2
        end
        if near ~= (pin.faded or false) then
            pin.faded = near
            pin:SetAlpha(near and FADE_ALPHA or 1)
        end
    end
end
local function InitWorldMap()
    if not WorldMapFrame or not WorldMapFrame.AddDataProvider then return end
    local p = MakeProvider()
    if p and not p.added then WorldMapFrame:AddDataProvider(p); p.added = true end
end

-- ── Minicarte ─────────────────────────────────────────────────────────────
-- Diamètre de la minicarte en mètres selon le zoom (extérieur / intérieur)
local OUTDOOR = { [0] = 466 + 2 / 3, 400, 333 + 1 / 3, 266 + 2 / 3, 200, 133 + 1 / 3 }
local INDOOR = { [0] = 300, 240, 180, 120, 80, 50 }
local mm = { pins = {}, used = 0 }
local function ZoneMapOfPlayer()
    if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetMapInfo) then return nil end
    local m = C_Map.GetBestMapForUnit("player")
    local info = m and C_Map.GetMapInfo(m)
    for _ = 1, 4 do
        if not info or info.mapType == ZONE_TYPE or not info.parentMapID or info.parentMapID == 0 then break end
        info = C_Map.GetMapInfo(info.parentMapID)
    end
    if info and info.mapType == ZONE_TYPE then return info.mapID, info.name end
end
local function MapSize(mapID)
    if C_Map.GetMapWorldSize then
        local w, h = C_Map.GetMapWorldSize(mapID)
        if w and w > 0 then return w, h end
    end
    if C_Map.GetWorldPosFromMapPos and CreateVector2D then
        local _, a = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0))
        local _, b = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1))
        if a and b then return math.abs(b.y - a.y), math.abs(b.x - a.x) end
    end
end
local function MinimapPin(i)
    local f = mm.pins[i]
    if f then return f end
    f = CreateFrame("Frame", nil, Minimap)
    f:SetFrameLevel((Minimap.GetFrameLevel and Minimap:GetFrameLevel() or 1) + 5)
    f.Icon = f:CreateTexture(nil, "OVERLAY")
    f.Icon:SetAllPoints()
    f:EnableMouse(true)
    f:SetScript("OnEnter", function(self) NodeTooltip(self, self.e, self.learned) end)
    f:SetScript("OnLeave", function() GameTooltip:Hide() end)
    mm.pins[i] = f
    return f
end
-- Rayon visible de la minicarte (mètres) : donné par le jeu actuel (GetViewRadius), sinon d'après le zoom.
-- Un rayon faux fait « suivre » le joueur aux icônes : elles ne bougent pas autant que le terrain.
local function MinimapRadius(zoom)
    if Minimap and Minimap.GetViewRadius then
        local ok, r = pcall(Minimap.GetViewRadius, Minimap)
        if ok and type(r) == "number" and r > 0 then return r end
    end
    return (((IsIndoors and IsIndoors()) and INDOOR or OUTDOOR)[zoom] or 466) / 2
end
-- Dessin fluide : la minicarte est redessinée à chaque image, mais seulement avec les points proches,
-- choisis de temps en temps (nouvelle zone, réglage modifié, ou après s'être déplacé d'une bonne distance).
-- cand.pts : { x, y (mètres depuis le coin de la carte de la zone), e (entrée), state, learned }
local cand = { pts = {}, n = 0 }
local function Rebuild(area, px, py, w, h, reach)
    local list, n = cand.pts, 0
    for _, z in ipairs(ZoneEntries(area)) do
        local state = State(z.e)
        if state then
            local pts = Decode(z.p)
            for i = 1, #pts - 1, 2 do
                local dx, dy = (pts[i] - px) * w, (py - pts[i + 1]) * h
                if dx * dx + dy * dy <= reach * reach and n < 600 then
                    n = n + 1
                    local c = list[n] or {}
                    c.x, c.y, c.e, c.state, c.learned = pts[i] * w, pts[i + 1] * h, z.e, state, z.learned
                    list[n] = c
                end
            end
        end
    end
    cand.n, cand.area, cand.cx, cand.cy, cand.reach, cand.w, cand.h = n, area, px * w, py * h, reach, w, h
end
local last = {}   -- position, orientation, zoom au dernier dessin : rien à refaire si rien n'a bougé
local function UpdateMinimap(force)
    local used = 0
    if On() and Opt("gather_minimap") ~= false and Minimap and Minimap:IsShown() then
        local mapID, mapName = ZoneMapOfPlayer()
        local area = mapID and FC.AreaForMap and FC:AreaForMap(mapID, mapName)
        local pos = area and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(mapID, "player")
        local w, h = 0, 0
        if pos then w, h = MapSize(mapID) end
        if pos and w and w > 0 then
            local px, py = pos.x or (pos.GetXY and select(1, pos:GetXY())), pos.y or (pos.GetXY and select(2, pos:GetXY()))
            local zoom = Minimap.GetZoom and Minimap:GetZoom() or 0
            local fac = GetPlayerFacing and GetPlayerFacing() or 0
            local radius = MinimapRadius(zoom)
            if not force and last.x == px and last.y == py and last.z == zoom and last.f == fac and last.a == area and last.r == radius then return end
            last.x, last.y, last.z, last.f, last.a, last.r = px, py, zoom, fac, area, radius
            -- Points proches : choisis à nouveau si la zone change ou après un déplacement de la moitié de la marge
            local margin = math.max(150, radius)
            local mx, my = px * w, py * h
            if force or cand.area ~= area or cand.w ~= w or (cand.reach or 0) < radius + margin * 0.5
                or (mx - cand.cx) ^ 2 + (my - cand.cy) ^ 2 > (margin * 0.5) ^ 2 then
                Rebuild(area, px, py, w, h, radius + margin)
            end
            local scale = (Minimap:GetWidth() or 140) / (radius * 2)   -- pixels par mètre
            local rotate = GetCVar and GetCVar("rotateMinimap") == "1"
            local facing = rotate and GetPlayerFacing and GetPlayerFacing() or nil
            if rotate and not facing then rotate = false end
            local cs, sn = 1, 0
            if rotate then cs, sn = math.cos(facing), math.sin(facing) end
            local size = Opt("gather_minimap_size") or 8
            local track = tonumber(Opt("gather_track_dist") or 100) or 100   -- portée de détection (0 : jamais d'anneau)
            local r2, t2 = (radius * 0.95) ^ 2, track * track
            for i = 1, cand.n do
                local c = cand.pts[i]
                local dx, dy = c.x - mx, my - c.y   -- est, nord (mètres)
                local dist2 = dx * dx + dy * dy
                if dist2 <= r2 then
                    if rotate then dx, dy = dx * cs + dy * sn, -dx * sn + dy * cs end
                    used = used + 1
                    local f = MinimapPin(used)
                    local mode = (track > 0 and dist2 <= t2) and "ring" or "icon"
                    if force or f.e ~= c.e or f.mode ~= mode or f.state ~= c.state then   -- apparence : seulement si elle change
                        f.e, f.mode, f.state = c.e, mode, c.state
                        if mode == "ring" then
                            PaintRing(f.Icon, c.e, c.state)
                            f:SetSize(size + 4, size + 4)   -- un peu plus grand que le point jaune de la détection
                        else
                            Paint(f.Icon, c.e, c.state)
                            f:SetSize(size, size)
                        end
                    end
                    f.learned = c.learned
                    f:SetPoint("CENTER", Minimap, "CENTER", dx * scale, dy * scale)
                    f:Show()
                    if used >= 200 then break end
                end
            end
        end
    end
    for i = used + 1, mm.used do mm.pins[i]:Hide() end
    mm.used = used
end

-- ── Points récoltés en jeu ────────────────────────────────────────────────
-- À l'ouverture du butin d'un objet du jeu connu (plante, filon), sa position est notée (sans
-- doublon à moins de 1 % de la carte). Complète la carte là où Wowhead manque de relevés.
local function RecordLoot()
    if not On() or Opt("gather_record") == false or not GetNumLootItems or not GetLootSourceInfo then return end
    local oid
    for i = 1, GetNumLootItems() do
        local guid = GetLootSourceInfo(i)
        if type(guid) == "string" and guid:find("^GameObject") then
            oid = tonumber((select(6, strsplit("-", guid))))
            if oid then break end
        end
    end
    if not oid then return end
    local idx, items = ObjectIndex()
    if not idx[oid] and GetLootSlotLink then
        -- Objet inconnu de Wowhead : reconnu par la plante ou le minerai obtenu
        for i = 1, GetNumLootItems() do
            local link = GetLootSlotLink(i)
            local it = link and tonumber(link:match("item:(%d+)"))
            if it and items[it] then
                local g = FC.db.global
                g.gather_objects = g.gather_objects or {}
                g.gather_objects[oid] = it
                byObject = nil
                idx = ObjectIndex()
                break
            end
        end
    end
    local entry = idx[oid]
    if not entry then return end
    local mapID = ZoneMapOfPlayer()
    local area = mapID and FC:AreaForMap(mapID, select(2, ZoneMapOfPlayer()))
    local pos = area and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return end
    local x, y = pos.x or select(1, pos:GetXY()), pos.y or select(2, pos:GetXY())
    if not x or not y then return end
    -- même plante / même filon déjà connu (données ou appris) à moins de 1 % : rien à noter
    for _, z in ipairs(ZoneEntries(area)) do
        if z.e.n == entry.n and z.e.sl == entry.sl then
            local pts = Decode(z.p)
            for i = 1, #pts - 1, 2 do
                if (pts[i] - x) ^ 2 + (pts[i + 1] - y) ^ 2 < 0.0001 then return end
            end
        end
    end
    local g = FC.db.global
    g.gather_learned = g.gather_learned or {}
    g.gather_learned[area] = g.gather_learned[area] or {}
    g.gather_learned[area][oid] = (g.gather_learned[area][oid] or "") .. Encode(x, y)
    if provider and WorldMapFrame and WorldMapFrame:IsShown() then provider:RefreshAllData() end
    UpdateMinimap(true)
end

-- ── Diagnostic (/fc map) : pourquoi rien n'apparaît sur la minicarte ──────
function FC:GatherMapDebug()
    local out = {}
    local function add(t) out[#out + 1] = t end
    local zones, points = 0, 0
    for _, list in pairs(Nodes()) do
        zones = zones + 1
        for _, e in ipairs(list) do points = points + #(Decode(e.p or "")) / 2 end
    end
    add("points de récolte : activés " .. tostring(On()) .. ", options carte du monde " .. tostring(Opt("gather_worldmap") ~= false) .. ", minicarte " .. tostring(Opt("gather_minimap") ~= false)
        .. ", seulement mes métiers " .. tostring(Opt("gather_only_known") ~= false) .. ", cacher trop bas " .. tostring(Opt("gather_hide_low") == true))
    if zones == 0 then
        add("|cffff5050Data/Nodes.lua est vide|r : aucune position dans les données.")
    else
        add("Data/Nodes.lua : " .. zones .. " zone(s), " .. points .. " position(s)")
    end
    local ranks = FC.GatherRanks and FC:GatherRanks() or {}
    add("métiers : herboristerie " .. tostring(ranks[182] or "-") .. ", minage " .. tostring(ranks[186] or "-")
        .. ((not ranks[182] and not ranks[186] and Opt("gather_only_known") ~= false) and "  |cffff5050(aucun métier de récolte : décoche « Only for gathering professions I know » pour tout voir)|r" or ""))
    local function zoneLine(label, mapID, mapName)
        local area = mapID and FC.AreaForMap and FC:AreaForMap(mapID, mapName)
        local list = area and ZoneEntries(area) or {}
        local shown, pts, learned, names, order = 0, 0, 0, {}, {}
        for _, z in ipairs(list) do
            local n = #(Decode(z.p)) / 2
            if State(z.e) then shown = shown + 1; pts = pts + n end
            if z.learned then learned = learned + 1 end
            local k = (z.e.n or "?") .. (z.learned and " (toi)" or "")
            if not names[k] then names[k] = 0; order[#order + 1] = k end
            names[k] = names[k] + n
        end
        local parts = {}
        for i, k in ipairs(order) do if i <= 10 then parts[#parts + 1] = k .. " ×" .. names[k] end end
        add(label .. " : carte " .. tostring(mapID) .. " « " .. tostring(mapName) .. " » -> zone " .. tostring(area or "|cffff5050inconnue|r")
            .. " ; " .. #list .. " entrée(s) dont " .. shown .. " affichée(s) selon tes métiers, " .. pts .. " position(s), " .. learned .. " relevée(s) par toi"
            .. (#parts > 0 and (" : " .. table.concat(parts, ", ") .. (#order > 10 and ", …" or "")) or ""))
        return area, list
    end
    if WorldMapFrame and WorldMapFrame:IsShown() and WorldMapFrame.GetMapID then
        local wm = WorldMapFrame:GetMapID()
        local info = wm and C_Map.GetMapInfo and C_Map.GetMapInfo(wm)
        zoneLine("carte du monde affichée", wm, info and info.name)
    end
    local mapID, mapName = ZoneMapOfPlayer()
    local area, list = zoneLine("ta zone", mapID, mapName)
    local pos = mapID and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(mapID, "player")
    local w, h = 0, 0
    if pos then w, h = MapSize(mapID) end
    local px, py = pos and (pos.x or (pos.GetXY and select(1, pos:GetXY()))), pos and (pos.y or (pos.GetXY and select(2, pos:GetXY())))
    local near
    if px and w and w > 0 then
        for _, z in ipairs(list) do
            if State(z.e) then
                local d = Decode(z.p)
                for i = 1, #d - 1, 2 do
                    local dist = math.sqrt(((d[i] - px) * w) ^ 2 + ((d[i + 1] - py) * h) ^ 2)
                    if not near or dist < near then near = dist end
                end
            end
        end
    end
    local zoom = Minimap and Minimap.GetZoom and Minimap:GetZoom() or 0
    local diameter = MinimapRadius(zoom) * 2
    add("minicarte : position " .. (px and string.format("%.1f, %.1f", px * 100, py * 100) or "|cffff5050inconnue|r")
        .. ", taille de la carte " .. ((w and w > 0) and string.format("%d × %d m", math.floor(w), math.floor(h)) or "|cffff5050inconnue|r")
        .. ", rayon visible " .. math.floor(diameter / 2 * 0.95) .. " m, point le plus proche "
        .. (near and (math.floor(near) .. " m") or "aucun") .. ", icônes dessinées " .. mm.used
        .. ", portée de détection " .. tostring(Opt("gather_track_dist") or 100) .. " m"
        .. (Minimap and Minimap.GetViewRadius and " (rayon donné par le jeu)" or " (rayon d'après le zoom)"))
    for _, l in ipairs(out) do print("|cffffd700FC map|r " .. l) end
end

-- ── Raccourcis clavier (Bindings.xml) : afficher / masquer les icônes ─────
BINDING_HEADER_FORECOMP = "Forever Companion"
BINDING_NAME_FORECOMP_GATHER_WORLDMAP = "Gathering nodes: show / hide on the world map"
BINDING_NAME_FORECOMP_GATHER_MINIMAP = "Gathering nodes: show / hide on the minimap"
local function Toggle(k, where)
    if not FC.db then return end
    if not On() then   -- fonction coupée : le raccourci ne la rallume pas, il dit où la remettre
        print("|cffffd700" .. FC.NAME .. "|r : gathering locations are turned off (Options > Tabs & features).")
        return
    end
    local on = FC.db.global[k] == false
    FC.db.global[k] = on
    FC:RefreshGatherMap()
    print("|cffffd700" .. FC.NAME .. "|r : gathering nodes " .. (on and "shown" or "hidden") .. " on the " .. where)
end
function FC:ToggleGatherWorldMap() Toggle("gather_worldmap", "world map") end
function FC:ToggleGatherMinimap() Toggle("gather_minimap", "minimap") end

-- ── Démarrage, rafraîchissement ───────────────────────────────────────────
function FC:RefreshGatherMap()
    byObject = nil
    if provider and provider.GetMap and provider:GetMap() then provider:RefreshAllData() end
    UpdateMinimap(true)
end

local refreshQueued = false
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("ADDON_LOADED")
pcall(ev.RegisterEvent, ev, "LOOT_OPENED")
pcall(ev.RegisterEvent, ev, "SKILL_LINES_CHANGED")
pcall(ev.RegisterEvent, ev, "ZONE_CHANGED_NEW_AREA")
pcall(ev.RegisterEvent, ev, "PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, e, name)
    if e == "LOOT_OPENED" then pcall(RecordLoot); return end
    if e == "PLAYER_REGEN_ENABLED" then FlushPassthrough(); return end
    if e == "SKILL_LINES_CHANGED" or e == "ZONE_CHANGED_NEW_AREA" then
        -- En rafale à la montée de niveau (une par compétence d'arme) : un seul rafraîchissement
        if not refreshQueued then
            refreshQueued = true
            C_Timer.After(0.5, function() refreshQueued = false; FC:RefreshGatherMap() end)
        end
        return
    end
    if e == "PLAYER_LOGIN" or name == "Blizzard_WorldMap" then InitWorldMap() end
end)
-- Minicarte : à chaque image (déplacement fluide ; rien n'est refait si rien n'a bougé) ;
-- carte du monde : icônes près du joueur, 5 fois par seconde
local acc = 0
ev:SetScript("OnUpdate", function(_, elapsed)
    if not FC.db then return end
    pcall(UpdateMinimap)
    acc = acc + (elapsed or 0)
    if acc < 0.2 then return end
    acc = 0
    pcall(FadeNearPlayer)
end)

FC.GatherMapInternals = { Decode = Decode, Encode = Encode, State = State, ZoneEntries = ZoneEntries, MakeProvider = MakeProvider,
    UpdateMinimap = UpdateMinimap, RecordLoot = RecordLoot, PendingPassthrough = function() return pendingPass end, FadeNearPlayer = FadeNearPlayer, Cand = function() return cand end, Pins = function() return mm.pins, mm.used end, Provider = function() return provider end }   -- tests
