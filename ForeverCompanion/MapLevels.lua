-- Forever Companion — MapLevels.lua
-- Carte du monde : sous le nom de la zone survolée, la compétence requise par les plantes
-- (herboristerie) et les filons (minage) de la zone, d'après les données Wowhead du Studio
-- (entrées des métiers de récolte : r.l = compétence requise, r.zi = zones).
-- Seulement pour les métiers appris, sauf l'option « aussi ceux que je ne connais pas ».
local FC = ForeverCompanion
local API = ForeverCompanionAPI

local PROFS = {   -- ligne de compétence et libellés
    { sl = 182, enUS = "Herbalism", frFR = "Herboristerie", deDE = "Kräuterkunde", esES = "Herboristería", esMX = "Herboristería", itIT = "Erbalismo", ptBR = "Herborismo" },
    { sl = 186, enUS = "Mining", frFR = "Minage", deDE = "Bergbau", esES = "Minería", esMX = "Minería", itIT = "Estrazione", ptBR = "Mineração" },
}
local LOCALE = (GetLocale and GetLocale()) or "enUS"
local function Label(p) return p[LOCALE] or p.enUS end

-- Clé de comparaison d'un nom de zone : sans la partie entre parenthèses (le client français de
-- WoW Forever nomme certaines zones « Bois de la Pénombre (Duskwood) » alors que la carte affiche
-- « Bois de la Pénombre »), sans majuscules, accents ni ponctuation
local function NameKey(s)
    s = tostring(s or ""):gsub("%s*%b()", "")
    s = (API and API.SearchNorm) and API.SearchNorm(s) or s:lower()
    return (s:gsub("[^%w]+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Cartes de zone de Classic (ID de carte) → zone du jeu (ID de zone, comme sur Wowhead) : la zone
-- est trouvée par son ID, sans comparer de noms (le client français de WoW Forever en traduit
-- certains différemment : la zone 331 s'appelle « Ashenvale », sa carte « Orneval »)
local UIMAP_AREA = {
    [1411] = 14, [1412] = 215, [1413] = 17, [1416] = 36, [1417] = 45, [1418] = 3, [1419] = 4, [1420] = 85,
    [1421] = 130, [1422] = 28, [1423] = 139, [1424] = 267, [1425] = 47, [1426] = 1, [1427] = 51, [1428] = 46,
    [1429] = 12, [1430] = 41, [1431] = 10, [1432] = 38, [1433] = 44, [1434] = 33, [1435] = 8, [1436] = 40,
    [1437] = 11, [1438] = 141, [1439] = 148, [1440] = 331, [1441] = 400, [1442] = 406, [1443] = 405, [1444] = 357,
    [1445] = 15, [1446] = 440, [1447] = 16, [1448] = 361, [1449] = 490, [1450] = 493, [1451] = 1377, [1452] = 618,
    [1453] = 1519, [1454] = 1637, [1455] = 1537, [1456] = 1638, [1457] = 1657, [1458] = 1497,
}

-- byArea : [ID de zone] = { [ligne de compétence] = { min, max } } ; byName : même chose par clé de nom ;
-- names : noms tels que le jeu les donne (diagnostic)
local byName, byArea, names
local function Build()
    byName, names = {}, {}
    local byZone = {}
    byArea = byZone
    for _, p in ipairs(FC.Professions or {}) do
        if p.g and p.sl then
            for _, c in ipairs(p.c or {}) do
                for _, r in ipairs(c.r or {}) do
                    local lv = r.l or 0
                    if not r.rc and lv > 0 and r.zi then
                        for _, z in ipairs(r.zi) do
                            local t = byZone[z] or {}
                            byZone[z] = t
                            local m = t[p.sl]
                            if m then
                                if lv < m[1] then m[1] = lv end
                                if lv > m[2] then m[2] = lv end
                            else t[p.sl] = { lv, lv } end
                        end
                    end
                end
            end
        end
    end
    -- Zones de Wowhead (ID de zone du jeu) → nom localisé, comparé au nom affiché par la carte
    for z, t in pairs(byZone) do
        local name = C_Map and C_Map.GetAreaInfo and C_Map.GetAreaInfo(z)
        local k = name and NameKey(name)
        if k and k ~= "" then
            if not byName[k] then names[#names + 1] = name end
            local cur = byName[k] or {}
            byName[k] = cur
            for sl, m in pairs(t) do
                local c = cur[sl]
                if c then c[1] = math.min(c[1], m[1]); c[2] = math.max(c[2], m[2]) else cur[sl] = { m[1], m[2] } end
            end
        end
    end
end

-- Rang du joueur dans chaque métier de récolte appris : [ligne de compétence] = rang
local function KnownRanks()
    local ranks = {}
    if GetProfessions and GetProfessionInfo then
        local res = { pcall(GetProfessions) }
        if res[1] then
            for i = 2, 6 do
                local idx = res[i]
                if idx then
                    local ok, _, _, rank, _, _, _, sl = pcall(GetProfessionInfo, idx)
                    if ok and sl then ranks[sl] = rank or 0 end
                end
            end
        end
    end
    if next(ranks) == nil and GetNumSkillLines and GetSkillLineInfo then   -- anciens clients : par le nom
        for i = 1, GetNumSkillLines() do
            local name, header, _, rank = GetSkillLineInfo(i)
            if name and not header then
                for _, p in ipairs(PROFS) do
                    for k, n in pairs(p) do if k ~= "sl" and n == name then ranks[p.sl] = rank or 0 end end
                end
            end
        end
    end
    return ranks
end

local ranks = {}
-- Nom de zone appris en y passant (ID de carte → nom que le jeu donne à la zone), pour les zones
-- absentes de la table ci-dessus (zones propres à WoW Forever)
local function Learned(mapID)
    local g = mapID and FC.db and FC.db.global.map_zone_names
    return g and g[LOCALE] and g[LOCALE][mapID]
end
-- Zone (ID) d'une carte du jeu : relevé du script Wowhead (Data/Nodes.lua : mapAreas, toutes les zones
-- de WoW Forever, y compris les nouvelles), sinon la table de Classic ci-dessus
local function MapArea(mapID)
    if not mapID then return nil end
    local d = ForeverCompanionData and ForeverCompanionData.mapAreas
    return (d and d[mapID]) or UIMAP_AREA[mapID]
end
-- Données d'une carte de zone : par l'ID de zone, sinon par le nom appris, sinon par le nom affiché
local function ZoneData(zoneName, mapID)
    if not byName then Build() end
    local area = MapArea(mapID)
    local t = area and byArea[area]
    if t then return t, "ID " .. area end
    local learned = Learned(mapID)
    t = learned and byName[NameKey(learned)]
    if t then return t, "nom appris « " .. learned .. " »" end
    t = zoneName and byName[NameKey(zoneName)]
    if t then return t, "nom" end
end

-- Zone du jeu (ID) d'une carte de zone : table de Classic, sinon nom appris en y passant ou nom de la
-- carte, comparés aux zones que les données connaissent (plantes, filons, points de récolte)
local areaByKey
local function BuildAreaKeys()
    areaByKey = {}
    if not byName then Build() end
    local function add(a)
        local n = C_Map and C_Map.GetAreaInfo and C_Map.GetAreaInfo(a)
        local k = n and NameKey(n)
        if k and k ~= "" and not areaByKey[k] then areaByKey[k] = a end
    end
    for a in pairs(byArea) do add(a) end
    for a in pairs((ForeverCompanionData and ForeverCompanionData.nodes) or {}) do add(a) end
end
function FC:AreaForMap(mapID, mapName)
    local known = MapArea(mapID)
    if known then return known end
    if not areaByKey then BuildAreaKeys() end
    local learned = Learned(mapID)
    return (learned and areaByKey[NameKey(learned)]) or (mapName and areaByKey[NameKey(mapName)]) or nil
end
-- Compétence du joueur dans les métiers de récolte : [ligne de compétence] = rang
function FC:GatherRanks() return ranks end

-- Texte d'une zone (nil si rien à afficher) ; mapID : carte de la zone (plus sûr que le nom)
function FC:MapLevelsText(zoneName, mapID)
    if (not zoneName and not mapID) or not FC.db or FC.db.global.map_gather == false then return nil end
    local t = ZoneData(zoneName, mapID)
    if not t then return nil end
    local all = FC.db.global.map_gather_all == true
    local parts = {}
    for _, p in ipairs(PROFS) do
        local m, rank = t[p.sl], ranks[p.sl]
        if m and (rank or all) then
            local range = (m[1] == m[2]) and tostring(m[1]) or (m[1] .. "-" .. m[2])
            -- vert : au moins une plante / un filon récoltable ; rouge : compétence trop basse ; gris : métier non appris
            local color = not rank and "|cff9d9d9d" or (rank < m[1] and "|cffff5050" or "|cff60ff60")
            parts[#parts + 1] = color .. Label(p) .. " " .. range .. "|r"
        end
    end
    return #parts > 0 and table.concat(parts, "    ") or nil
end

-- ── Affichage sur la carte ────────────────────────────────────────────────
-- Le texte est posé sur un cadre à nous, placé juste au-dessus de l'étiquette de zone du jeu :
-- un texte créé sur la carte elle-même serait dessiné sous l'image de la carte.
local text, holder, areaLabel, ticker
local function FindAreaLabel()
    for dp in pairs((WorldMapFrame and WorldMapFrame.dataProviders) or {}) do
        if type(dp) == "table" and type(dp.Label) == "table" and dp.Label.Name and dp.Label.Description then return dp.Label end
    end
end
local ZONE_TYPE = (Enum and Enum.UIMapType and Enum.UIMapType.Zone) or 3
-- Zone sous le curseur (carte d'un continent), sinon la zone affichée
local function Hovered()
    local mapID = WorldMapFrame.GetMapID and WorldMapFrame:GetMapID()
    if not mapID or not C_Map or not C_Map.GetMapInfo then return nil end
    local x, y
    if WorldMapFrame.GetNormalizedCursorPosition then x, y = WorldMapFrame:GetNormalizedCursorPosition() end
    local over = WorldMapFrame.ScrollContainer and WorldMapFrame.ScrollContainer.IsMouseOver and WorldMapFrame.ScrollContainer:IsMouseOver()
    if over and x and C_Map.GetMapInfoAtPosition then
        local info = C_Map.GetMapInfoAtPosition(mapID, x, y)
        if info and info.mapID ~= mapID and info.mapType == ZONE_TYPE then return info.name, true, info.mapID end
    end
    local cur = C_Map.GetMapInfo(mapID)
    if cur and cur.mapType == ZONE_TYPE then return cur.name, false, cur.mapID end
end
local function Lvl(f) return (f and f.GetFrameLevel and tonumber(f:GetFrameLevel())) or 0 end
local function Raise()
    local sc = WorldMapFrame.ScrollContainer or WorldMapFrame
    local base = areaLabel and Lvl(areaLabel) or (Lvl(sc) + 500)
    if areaLabel and areaLabel.GetFrameStrata and holder.SetFrameStrata then
        local st = areaLabel:GetFrameStrata()
        if st and holder:GetFrameStrata() ~= st then holder:SetFrameStrata(st) end
    end
    if Lvl(holder) <= base then holder:SetFrameLevel(math.min(base + 1, 9999)) end
end
local function Update()
    if not text then return end
    areaLabel = areaLabel or FindAreaLabel()
    Raise()
    local name, hovered, zoneMap = Hovered()
    local line = name and FC:MapLevelsText(name, zoneMap)
    if not line then text:Hide(); return end
    text:ClearAllPoints()
    local lbl = areaLabel
    local labelShowsIt = lbl and lbl:IsShown() and lbl.Name:GetText() == name
    if labelShowsIt then
        -- sous le nom (et sous la tranche de niveaux) affichés par le jeu
        local below = (lbl.Description:GetText() or "") ~= "" and lbl.Description or lbl.Name
        text:SetPoint("TOP", below, "BOTTOM", 0, -4)
        text:SetText(line)
    elseif not hovered then
        -- carte d'une zone : en haut de la carte, avec le nom de la zone
        text:SetPoint("TOP", WorldMapFrame.ScrollContainer or WorldMapFrame, "TOP", 0, -64)
        text:SetText("|cffffd100" .. name .. "|r    " .. line)
    elseif not lbl then
        text:SetPoint("TOP", WorldMapFrame.ScrollContainer or WorldMapFrame, "TOP", 0, -64)
        text:SetText(line)
    else text:Hide(); return end
    text:Show()
end
local function Init()
    if text or not WorldMapFrame then return end
    local parent = WorldMapFrame.ScrollContainer or WorldMapFrame
    holder = CreateFrame("Frame", nil, parent)
    holder:SetAllPoints(parent)
    if holder.EnableMouse then holder:EnableMouse(false) end   -- ne gêne pas les clics sur la carte
    text = holder:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    local font, size = text:GetFont()
    if font then text:SetFont(font, (size or 12) + 1, "OUTLINE") end
    text:SetJustifyH("CENTER")
    text:Hide()
    WorldMapFrame:HookScript("OnShow", function()
        ranks = KnownRanks()
        areaLabel = areaLabel or FindAreaLabel()
        if not ticker and C_Timer and C_Timer.NewTicker then ticker = C_Timer.NewTicker(0.1, Update) end
        Update()
    end)
    WorldMapFrame:HookScript("OnHide", function()
        if ticker then ticker:Cancel(); ticker = nil end
        if text then text:Hide() end
    end)
end

-- /fc map : diagnostic (carte ouverte, curseur sur une zone ; sinon zone du joueur)
function FC:MapLevelsDebug()
    local out = {}
    local function add(s) out[#out + 1] = s end
    local g = FC.db and FC.db.global or {}
    if not byName then Build() end
    local n = #names
    ranks = KnownRanks()
    local rk = {}
    for _, p in ipairs(PROFS) do rk[#rk + 1] = Label(p) .. "=" .. tostring(ranks[p.sl] or "-") end
    add("options : carte " .. tostring(g.map_gather ~= false) .. ", métiers inconnus " .. tostring(g.map_gather_all == true) .. " | métiers : " .. table.concat(rk, ", "))
    local list = {}
    for i, v in ipairs(names) do list[i] = v end
    table.sort(list)
    add("zones avec plantes/filons (" .. n .. ") : " .. (n > 0 and table.concat(list, ", ", 1, math.min(#list, 12)) .. (#list > 12 and ", …" or "") or "aucune (pas de zi dans Data/Professions.lua ?)"))
    local name, how, zmap
    if WorldMapFrame and WorldMapFrame:IsShown() then
        local hv
        name, hv, zmap = Hovered()
        how = hv and "survolée" or "affichée"
        local mapID = WorldMapFrame.GetMapID and WorldMapFrame:GetMapID()
        local info = mapID and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
        add("carte : " .. tostring(mapID) .. " " .. tostring(info and info.name) .. " (type " .. tostring(info and info.mapType) .. ")")
        local lbl = areaLabel or FindAreaLabel()
        add("étiquette du jeu : " .. (lbl and ((lbl:IsShown() and "visible" or "cachée") .. " « " .. tostring(lbl.Name:GetText()) .. " » niveau " .. Lvl(lbl)) or "introuvable")
            .. " | notre texte : niveau " .. Lvl(holder) .. ", " .. ((text and text:IsShown()) and "visible" or "caché"))
    else
        local m = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
        local info = m and C_Map.GetMapInfo(m)
        name, how, zmap = info and info.name, "du joueur (ouvre la carte et survole une zone pour tester la carte)", info and info.mapID
    end
    local _, via = ZoneData(name, zmap)
    add("zone " .. tostring(how) .. " : « " .. tostring(name) .. " » (carte " .. tostring(zmap) .. ", zone " .. tostring(MapArea(zmap) or "?")
        .. ((zmap and ForeverCompanionData and ForeverCompanionData.mapAreas and ForeverCompanionData.mapAreas[zmap]) and " (carte relevée)" or "")
        .. (Learned(zmap) and (", nom appris « " .. Learned(zmap) .. " »") or "") .. ") -> "
        .. tostring((name or zmap) and FC:MapLevelsText(name, zmap) or "rien à afficher") .. (via and (" [trouvée par " .. via .. "]") or ""))
    if name and not via then   -- noms proches (même premier mot) : nom différent sur la carte ?
        local first = NameKey(name):match("^(%S+)") or ""
        local near = {}
        for _, v in ipairs(names) do if #first > 2 and NameKey(v):find(first, 1, true) then near[#near + 1] = v end end
        if #near > 0 then add("noms proches connus : " .. table.concat(near, ", ")) end
    end
    for _, l in ipairs(out) do print("|cffffd700FC map|r " .. l) end
end

function FC:RefreshMapLevels()
    byName, areaByKey = nil, nil
    ranks = KnownRanks()
    if WorldMapFrame and WorldMapFrame:IsShown() then Update() end
end

-- Zone où se trouve le joueur : ID de sa carte → nom que le jeu donne à la zone (appris une fois)
local function LearnZone()
    if not (FC.db and C_Map and C_Map.GetBestMapForUnit and C_Map.GetMapInfo) then return end
    local m = C_Map.GetBestMapForUnit("player")
    local info = m and C_Map.GetMapInfo(m)
    for _ = 1, 4 do   -- sous-zone, bâtiment : remonter jusqu'à la carte de la zone
        if not info or info.mapType == ZONE_TYPE or not info.parentMapID or info.parentMapID == 0 then break end
        info = C_Map.GetMapInfo(info.parentMapID)
    end
    if not (info and info.mapType == ZONE_TYPE and info.mapID) then return end
    local zt = (GetRealZoneText and GetRealZoneText()) or (GetZoneText and GetZoneText())
    if not zt or zt == "" then return end
    local g = FC.db.global
    g.map_zone_names = g.map_zone_names or {}
    g.map_zone_names[LOCALE] = g.map_zone_names[LOCALE] or {}
    g.map_zone_names[LOCALE][info.mapID] = zt
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("ADDON_LOADED")
pcall(ev.RegisterEvent, ev, "SKILL_LINES_CHANGED")
pcall(ev.RegisterEvent, ev, "ZONE_CHANGED_NEW_AREA")
pcall(ev.RegisterEvent, ev, "PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function(_, e, name)
    if e == "SKILL_LINES_CHANGED" then ranks = KnownRanks(); return end
    if e == "ZONE_CHANGED_NEW_AREA" or e == "PLAYER_ENTERING_WORLD" then pcall(LearnZone); return end
    if e == "PLAYER_LOGIN" then ranks = KnownRanks() end
    if e == "PLAYER_LOGIN" or name == "Blizzard_WorldMap" then Init() end
end)
FC.MapLevelsInternals = { Build = function() Build() return byName end, KnownRanks = KnownRanks, Update = Update, SetRanks = function(r) ranks = r end,
    Holder = function() return holder end, Text = function() return text end, LearnZone = LearnZone }   -- tests
