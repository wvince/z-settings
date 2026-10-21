-- Forever Companion — Core.lua
-- Toutes les données (listes BiS, phases, classes, tokens, plans…) viennent de
-- Data/*.lua (générés par Forever Companion Studio) via DataLoader.lua.

ForeverCompanion = LibStub("AceAddon-3.0"):NewAddon("ForeverCompanion", "AceConsole-3.0")
local FC = ForeverCompanion
FC.NAME    = "Forever Companion"
FC.L = {
    spec_prompt = "Plusieurs spécialisations correspondent à tes talents.\nLaquelle joues-tu ?",
    spec_manual = "Choisis ta spécialisation (elle sera utilisée quels que soient tes talents) :",
    spec_auto   = "Automatique (d'après mes talents)",
    spec_hint   = "Modifiable à tout moment : /fc spec",
    spec_set    = "spécialisation : %s",
}
if GetLocale() ~= "frFR" then
    FC.L.spec_prompt = "Several specializations match your talents.\nWhich one do you play?"
    FC.L.spec_manual = "Choose your specialization (used regardless of your talents):"
    FC.L.spec_auto   = "Automatic (from my talents)"
    FC.L.spec_hint   = "Change it any time: /fc spec"
    FC.L.spec_set    = "specialization: %s"
end
-- Version : celle du What's new le plus récent (Data/Meta.lua, écrite avec les nouveautés), au format
-- « 1.0.5 » ; sinon celle du TOC. Affichée dans les options, /fc, /fc diag, et comparée entre joueurs
-- (« A new version is available »).
FC.CODE_VERSION = "1.0.0"   -- ## Version du TOC
function FC.NewsVersion(news)
    local top = type(news) == "table" and news[1]
    local id = type(top) == "table" and top.id
    if type(id) ~= "string" then return nil end
    local v = id:match("^%s*[vV]?(%d+%.%d+[%d%.]*)%s*$")
    if v then v = v:gsub("%.+$", "") end
    return v
end
FC.VERSION = FC.NewsVersion(ForeverCompanionData and ForeverCompanionData.news) or FC.CODE_VERSION

-- Récupérer les entrées BiS pour tous les items d'un token de set
function FC:GetEntriesForToken(tokenId)
    local items = self.TOKEN_TO_ITEMS and self.TOKEN_TO_ITEMS[tokenId]
    if not items then return {} end
    local results = {}
    for _, itemId in ipairs(items) do
        for _, e in ipairs(self:GetEntriesForItem(itemId)) do
            table.insert(results, e)
        end
    end
    -- Trier par classe (ordre du Studio) puis spec
    local classIdx = {}
    for i, cn in ipairs(self.CLASS_ORDER) do classIdx[cn] = i end
    table.sort(results, function(a, b)
        local ca = classIdx[a.class_name] or 99
        local cb = classIdx[b.class_name] or 99
        if ca ~= cb then return ca < cb end
        return (a.spec_name or "") < (b.spec_name or "")
    end)
    return results
end

function FC:GetSpecIcon(cn, sn)
    return (self.SPEC_ICONS[cn] or {})[sn]
end

function FC:GetClassIcon(cn)
    return self.CLASS_ICONS[cn]
end

-- Nom de classe (tel que dans les données) depuis le token Blizzard (ex. "DRUID")
function FC:ClassFromToken(classEn)
    if not classEn then return nil end
    return self.CLASS_BY_TOKEN[classEn] or (classEn:sub(1, 1):upper() .. classEn:sub(2):lower())
end

-- Points par arbre de talents (joueur ou cible inspectée) : voir Compat.lua.
-- Renvoie bestTab, bestPoints, totalPoints (bestTab = nil si indisponible).
function FC:CountTalentPoints(isInspect, unit)
    return ForeverCompanionAPI.CountTalentPoints(isInspect, unit)
end

-- Spec par défaut associée à un arbre de talents (défini dans le Studio)
function FC:SpecFromTab(cn, tab)
    local tabs = self.TAB_TO_SPEC[cn]
    local sn = tabs and tabs[tab] or nil
    if sn == "" then sn = nil end
    return sn
end

function FC:HasSpec(cn, sn)
    for _, s in ipairs(self.SPEC_ORDER[cn] or {}) do if s == sn then return true end end
    return self.BisData[cn] and self.BisData[cn][sn] ~= nil
end

-- Specs possibles pour un arbre dominant : la spec par défaut de l'arbre,
-- les specs alternatives rattachées à cet arbre et les specs hybrides (arbre 0).
function FC:SpecCandidates(cn, tab)
    local out, seen = {}, {}
    local function add(sn)
        if sn and not seen[sn] then seen[sn] = true; table.insert(out, sn) end
    end
    add(self:SpecFromTab(cn, tab))
    for _, sn in ipairs(self.SPEC_ORDER[cn] or {}) do
        local t = (self.SPEC_TREE[cn] or {})[sn]
        if t == tab or t == 0 then add(sn) end
    end
    return out
end

-- Spec du joueur, dans cet ordre :
--   1) spec choisie à la main (/fc spec ou options)
--   2) arbre dominant → spec unique, ou choix mémorisé parmi les alternatives
--   3) sinon la spec par défaut de l'arbre (et on propose le choix au joueur)
function FC:DetectPlayerSpec()
    local _, classEn = UnitClass("player")
    local cn = self:ClassFromToken(classEn)
    if not cn then return nil, nil end
    local db = self.db and self.db.char
    if db and db.my_spec and self:HasSpec(cn, db.my_spec) then return cn, db.my_spec end

    local bestTab, _, totalPoints = self:CountTalentPoints(false)
    -- Aucun point dépensé (perso bas niveau) ou API indisponible : pas de spec fiable
    if not bestTab or totalPoints == 0 then return cn, nil end

    local cands = self:SpecCandidates(cn, bestTab)
    if #cands <= 1 then return cn, cands[1] end
    local choice = db and db.spec_choice and db.spec_choice[bestTab]
    for _, sn in ipairs(cands) do
        if sn == choice then return cn, sn end
    end
    self:QueueSpecPrompt(cn, bestTab, cands)
    return cn, cands[1]
end

-- ── Choix de spé alternative ──────────────────────────────────────────────
local prompted = {}
function FC:QueueSpecPrompt(cn, tab, cands)
    if prompted[tab] or not self.db then return end
    prompted[tab] = true
    C_Timer.After(2, function()
        if InCombatLockdown and InCombatLockdown() then prompted[tab] = nil; return end
        self:ShowSpecChooser(cn, cands, tab)
    end)
end

-- Fenêtre de choix. Avec tab : choix mémorisé pour cet arbre de talents.
-- Sans tab (/fc spec) : spec imposée quels que soient les talents, ou « Automatique ».
local chooser
function FC:ShowSpecChooser(cn, specs, tab)
    if not cn or not specs or #specs == 0 then return end
    if not chooser then
        chooser = ForeverCompanionAPI.CreateWindow("ForeverCompanionSpecChooser", UIParent)
        chooser:SetFrameStrata("DIALOG")
        chooser:SetPoint("CENTER", 0, 120)
        chooser:SetMovable(true); chooser:EnableMouse(true)
        chooser:RegisterForDrag("LeftButton")
        chooser:SetScript("OnDragStart", chooser.StartMoving)
        chooser:SetScript("OnDragStop", chooser.StopMovingOrSizing)
        chooser.title = ForeverCompanionAPI.WindowTitle(chooser)
        chooser.text = chooser:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        chooser.text:SetPoint("TOP", 0, -36)
        chooser.text:SetWidth(300)
        chooser.close = chooser.CloseButton
        chooser.buttons = {}
        ForeverCompanionAPI.CloseOnEscape(chooser)
    end
    local L = self.L
    chooser.title:SetText(self.NAME)
    chooser.text:SetText(tab and L.spec_prompt or L.spec_manual)

    local entries = {}
    for _, sn in ipairs(specs) do table.insert(entries, { sn = sn }) end
    if not tab then table.insert(entries, { sn = nil, label = L.spec_auto }) end

    for _, b in ipairs(chooser.buttons) do b:Hide() end
    local y = -36 - chooser.text:GetStringHeight() - 14
    for i, e in ipairs(entries) do
        local b = chooser.buttons[i]
        if not b then
            b = ForeverCompanionAPI.CreateMenuButton(chooser, 260, 24)
            b:SetSize(240, 24)
            chooser.buttons[i] = b
        end
        local icon = e.sn and self:GetSpecIcon(cn, e.sn)
        b:SetText(((icon and ("|T" .. icon .. ":16:16:0:0|t ")) or "") .. (e.label or e.sn))
        b:ClearAllPoints(); b:SetPoint("TOP", 0, y)
        b:SetScript("OnClick", function()
            if tab then
                self.db.char.spec_choice[tab] = e.sn
            else
                self.db.char.my_spec = e.sn
            end
            chooser:Hide()
            self:OnPlayerSpecChanged(true)
        end)
        b:Show()
        y = y - 28
    end
    chooser:SetSize(320, -y + 30)
    chooser.hint = chooser.hint or chooser:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    chooser.hint:SetPoint("BOTTOM", 0, 10)
    chooser.hint:SetText(L.spec_hint)
    chooser:Show()
end

-- La spec du joueur a peut-être changé : mettre à jour la mise en avant
function FC:OnPlayerSpecChanged(announce)
    if not self.db then return end
    if self.db.char.auto_highlight then self:AutoDetectHighlight() end
    if announce then
        local _, sn = self:DetectPlayerSpec()
        if sn then print("|cffffd700" .. self.NAME .. "|r : " .. string.format(self.L.spec_set, sn)) end
    end
end

local specEvents = CreateFrame("Frame")
for _, ev in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_TALENT_UPDATE", "CHARACTER_POINTS_CHANGED",
    "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_SPECIALIZATION_CHANGED", "TRAIT_CONFIG_UPDATED", "TRAIT_NODE_CHANGED" }) do
    pcall(specEvents.RegisterEvent, specEvents, ev)   -- certains évènements n'existent pas selon le client
end
specEvents:SetScript("OnEvent", function(_, event, unit)
    if event == "PLAYER_SPECIALIZATION_CHANGED" and unit and unit ~= "player" then return end
    FC:OnPlayerSpecChanged(false)
end)

-- ── Faction ──────────────────────────────────────────────────────────────
-- Objets réservés à une faction (récompenses de quête, JcJ, réputations) : champ f des données
-- (« A » / « H », calculé par le Studio), sinon d'après le type de source (« Quest (Alliance) »).
local FACTION_CODE = { A = "Alliance", H = "Horde", Alliance = "Alliance", Horde = "Horde" }
function FC:PlayerFaction()
    local f = UnitFactionGroup and UnitFactionGroup("player")
    return (f == "Alliance" or f == "Horde") and f or nil
end
function FC:ItemFaction(id)
    local it = id and self.ITEMS and self.ITEMS[id]
    if not it then return nil end
    if it.f then return FACTION_CODE[it.f] end
    local st, n = it.st or "", it.n or ""
    if st:find("%(Alliance%)") or n:find("of the Alliance") then return "Alliance" end
    if st:find("%(Horde%)") or n:find("of the Horde") then return "Horde" end
end
function FC:FactionFilterOn() return self.db ~= nil and self.db.global.faction_filter ~= false end
-- Objet (ou faction donnée) de l'autre faction, à cacher quand le filtre est actif.
-- mine : faction de référence (la fenêtre BiS peut montrer la liste de l'autre faction), sinon la mienne
function FC:IsOtherFaction(id, faction, mine)
    if not self:FactionFilterOn() then return false end
    mine = mine or self:PlayerFaction()
    if not mine then return false end
    faction = FACTION_CODE[faction or ""] or (id and self:ItemFaction(id))
    return faction ~= nil and faction ~= mine
end

-- ── Index itemId → entrées BiS ─────────────────────────────────────────────
FC._byItemId = nil

-- Slots à fusionner (finger1+2 → finger, trinket1+2 → trinket)
local SLOT_MERGE = {
    ["finger 1"] = "finger", ["finger 2"] = "finger",
    ["trinket 1"] = "trinket", ["trinket 2"] = "trinket",
}
-- Slots armes : afficher le slot dans le nom de spec "(main hand)" / "(off hand)"
local WEAPON_SLOTS = { ["weapon"] = true, ["off hand"] = true, ["main hand"] = true }

function FC:BuildIndex()
    if self._byItemId then return end
    self._byItemId = {}
    for cn, specs in pairs(self.BisData or {}) do
        for sn, phases in pairs(specs) do
            for ph, slots in pairs(phases) do
                local tempIndex = {}
                for _, slotEntry in ipairs(slots) do
                    local rawSlot = slotEntry.slot
                    local slotKey = SLOT_MERGE[rawSlot] or rawSlot
                    -- Rangs dans la liste de chaque faction (comme la fenêtre BiS : objets de l'autre camp retirés)
                    local cA, cH = 0, 0
                    for _, item in ipairs(slotEntry.items or {}) do
                        local id = item.itemId
                        local rA, rH
                        if id and id > 0 then
                            local fac = self:ItemFaction(id)
                            if fac ~= "Horde" then cA = cA + 1; rA = cA end
                            if fac ~= "Alliance" then cH = cH + 1; rH = cH end
                        end
                        if id and id > 0 then
                            -- Clé unique par slot pour ne pas fusionner arme + main gauche
                            local key = cn .. "|" .. sn .. "|" .. ph .. "|" .. id .. "|" .. slotKey
                            if not tempIndex[key] then
                                -- spec_name reste INCHANGÉ (ex. "Holy") pour que IsHighlighted()
                                -- fonctionne sur les armes ; le slot d'arme va dans slot_display.
                                local slotDisplay = nil
                                if WEAPON_SLOTS[rawSlot] then
                                    slotDisplay = rawSlot == "weapon" and "main hand" or rawSlot
                                end
                                tempIndex[key] = {
                                    class_name = cn, spec_name = sn, spec_key = sn, phase = ph,
                                    slot = slotKey, slot_display = slotDisplay, rank = item.rank, rankA = rA, rankH = rH,
                                    source = item.source or "",
                                    source_type = item.source_type or "",
                                    drop_chance = item.drop_chance or 0,
                                    enchant = item.enchant, gems = item.gems or {},
                                    itemId = id,
                                }
                            else
                                local t = tempIndex[key]
                                if rA and (not t.rankA or rA < t.rankA) then t.rankA = rA end
                                if rH and (not t.rankH or rH < t.rankH) then t.rankH = rH end
                                if item.rank < t.rank then
                                    t.rank = item.rank
                                    t.enchant = item.enchant
                                    t.gems = item.gems or {}
                                end
                            end
                        end
                    end
                end
                for _, entry in pairs(tempIndex) do
                    local id = entry.itemId
                    if not self._byItemId[id] then self._byItemId[id] = {} end
                    table.insert(self._byItemId[id], entry)
                end
            end
        end
    end
end

-- Rang affiché d'une entrée BiS : dans la liste de ma faction (comme la fenêtre BiS) ; objet de l'autre
-- faction : son rang dans la liste de sa faction ; filtre de faction coupé : rang de la liste complète
function FC:EntryRank(e)
    if not e or not self:FactionFilterOn() then return e and e.rank end
    local fac = self:ItemFaction(e.itemId)
    local mine = self:PlayerFaction()
    local ref = (fac and fac ~= mine) and fac or mine
    if ref == "Alliance" then return e.rankA or e.rank end
    if ref == "Horde" then return e.rankH or e.rank end
    return e.rank
end

function FC:GetEntriesForItem(itemId)
    self:BuildIndex()
    if not itemId or itemId == 0 then return {} end
    return self._byItemId[itemId] or {}
end

-- ── Icône minimap ──────────────────────────────────────────────────────────
local function addMapIcon()
    local LDB = LibStub("LibDataBroker-1.1", true)
    local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)
    if not LDB or not LDBIcon then return end
    local obj = LDB:NewDataObject("ForeverCompanion", {
        type = "launcher", text = FC.NAME,
        icon = "Interface\\AddOns\\ForeverCompanion\\Media\\LogoAddon.tga",
        OnClick = function(_, btn)
            if btn == "LeftButton" then FC:ToggleBislist()
            else FC:OpenOptions() end
        end,
        OnTooltipShow = function(tt)
            tt:AddLine("|cffffd700" .. FC.NAME .. "|r")
            tt:AddLine("|cffffff00Left click|r BiS window")
            tt:AddLine("|cffffff00Right click|r Options")
        end,
    })
    pcall(LDBIcon.Register, LDBIcon, "ForeverCompanion", obj, FC.db.global)
end

-- Menu « compartiment d'addons » du jeu actuel (déclaré dans le .toc)
function ForeverCompanion_OnAddonCompartmentClick(_, button)
    if button == "RightButton" then FC:OpenOptions()
    else FC:ToggleBislist() end
end

-- ── Vérification de mise à jour (peer-to-peer via SendAddonMessage) ───────────
local ADDON_MSG_PREFIX = "ForeverCompanion"   -- 16 caractères max
local newerVersionFound = false

local function versionToNum(v)
    local a, b, c = v:match("(%d+)%.(%d+)%.(%d+)")
    if not a then a, b = v:match("(%d+)%.(%d+)"); c = 0 end
    return (tonumber(a) or 0) * 10000 + (tonumber(b) or 0) * 100 + (tonumber(c) or 0)
end

local function onAddonMessage(prefix, msg, _, sender)
    if prefix ~= ADDON_MSG_PREFIX then return end
    if sender == UnitName("player") then return end
    local theirVersion = msg:match("^VER:(.+)$")
    if not theirVersion then return end
    if versionToNum(theirVersion) > versionToNum(FC.VERSION) and not newerVersionFound then
        newerVersionFound = true
        print("|cffffd700" .. FC.NAME .. ":|r A new version is available (v" .. theirVersion .. "). Update via CurseForge!")
    end
end

local function broadcastVersion(channel)
    return pcall(function()
        C_ChatInfo.SendAddonMessage(ADDON_MSG_PREFIX, "VER:" .. FC.VERSION, channel)
    end)
end

local versionFrame = CreateFrame("Frame")
versionFrame:RegisterEvent("CHAT_MSG_ADDON")
versionFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
versionFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
versionFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "CHAT_MSG_ADDON" then
        onAddonMessage(...)
    elseif event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" then
        C_Timer.After(3, function()
            if IsInGuild() then broadcastVersion("GUILD") end
            if IsInRaid() then broadcastVersion("RAID")
            elseif IsInGroup() then broadcastVersion("PARTY") end
        end)
    end
end)
C_ChatInfo.RegisterAddonMessagePrefix(ADDON_MSG_PREFIX)

-- ── Commandes ──────────────────────────────────────────────────────────────
-- /fc            : fenêtre BiS          /fc talents : talents BiS
-- /fc rotation   : rotation             /fc conso   : consommables
-- /fc spec       : choisir sa spé        /fc config  : options
-- /bis          : fenêtre BiS
local function slashHandler(input)
    local cmd = strtrim(input or ""):lower()
    if cmd == "" or cmd == "bis" then
        FC:ToggleBislist()
    elseif cmd == "rot" or cmd == "rotation" then
        FC:OpenRotationFrame()
    elseif cmd == "conso" or cmd == "consumes" or cmd == "consumables" then
        FC:OpenConsumeFrame()
    elseif cmd == "talents" or cmd == "talent" then
        FC:OpenBisTalentFrame()
    elseif cmd == "spec" then
        local _, classEn = UnitClass("player")
        local cn = FC:ClassFromToken(classEn)
        FC:ShowSpecChooser(cn, FC:GetSpecs(cn), nil)
    elseif cmd == "scan" then
        FC:ScanSpellIDs()
    elseif cmd == "scan tout" or cmd == "scan all" then
        FC:ScanSpellIDs(true)
    elseif cmd:match("^recipes") or cmd:match("^recettes") then
        FC:RecipeCommand(cmd:match("^%S+%s+(%S+)"))
    elseif cmd == "skin" then
        ForeverCompanionAPI.DumpFrameUnderMouse(2)
    elseif cmd == "loot" or cmd == "donjons" or cmd == "dungeons" then
        FC:OpenLootFrame()
    elseif cmd == "prof" or cmd == "metiers" or cmd == "professions" then
        FC:OpenProfessionsFrame()
    elseif cmd == "ah" or cmd == "hv" or cmd == "market" or cmd == "gold" then
        local mfr = _G.ForeverCompanionMarketFrame
        if mfr and mfr:IsShown() and cmd ~= "gold" then mfr:Hide() else FC:OpenMarket(cmd == "gold" and "gold" or nil) end
    elseif cmd == "diag" then
        FC:PrintDiagnostics()
    elseif cmd == "preview" or cmd == "apercu" or cmd == "scales" then
        FC:ShowScalePreview()
    elseif cmd == "tour" or cmd == "help" or cmd == "aide" then
        FC:StartTour()
    elseif cmd == "training export" then
        FC:ShowTrainingExport()   -- relevé des maîtres, à coller dans le Studio
    elseif cmd == "training" then
        FC:ToggleTraining()
    elseif cmd == "tour reset" then
        -- Pour revoir la bulle « New here? » sans toucher aux SavedVariables
        FC.db.global.tour_done, FC.db.global.tour_hint = nil, nil
        print("|cffffd700" .. FC.NAME .. "|r : tour hint reset. Open the BiS window (/fc) to see it.")
        local mf = rawget(_G, "ForeverCompanionFrame")
        if mf and mf:IsShown() and mf.helpBtn then FC:ShowTourHint(mf.helpBtn) end
    elseif cmd == "news reset" then
        -- Pour revoir l'ouverture automatique de « What's new » : /reload ensuite
        FC.db.global.news_seen = nil
        print("|cffffd700" .. FC.NAME .. "|r : what's new reset. Open the BiS window (/fc) to see it.")
    elseif cmd == "map" or cmd == "carte" then
        FC:MapLevelsDebug()
        if FC.GatherMapDebug then FC:GatherMapDebug() end
    elseif cmd == "config" or cmd == "options" then
        FC:OpenOptions()
    else
        print("|cffffd700" .. FC.NAME .. "|r v" .. FC.VERSION .. " (data " .. FC.DATA_UPDATED .. ")")
        print("  /fc — BiS list   /fc rotation   /fc conso   /fc talents   /fc spec   /fc config   /fc loot   /fc prof   /fc ah")
    end
end

-- /fc diag : état des API du client (à copier pour le support pendant la bêta)
function FC:PrintDiagnostics()
    local function yn(v) return v and "oui" or "non" end
    local _, _, _, iface = GetBuildInfo()
    local tab, pts, total = self:CountTalentPoints(false)
    local _, sn = self:DetectPlayerSpec()
    local lines = {
        "Forever Companion " .. self.VERSION .. " | données v" .. tostring(self.DATA_VERSION) .. " (" .. tostring(self.DATA_UPDATED) .. ") | interface " .. tostring(iface),
        "tooltips: " .. tostring(self.tooltipHook) .. " | menus: " .. (MenuUtil and "nouveaux" or "UIDropDownMenu"),
        "C_Item: " .. yn(C_Item and C_Item.GetItemInfo) .. " | C_Spell: " .. yn(C_Spell and C_Spell.GetSpellTexture)
            .. " | GetTalentInfo: " .. yn(GetTalentInfo) .. " | GetNumTalentTabs: " .. yn(GetNumTalentTabs)
            .. " | GetSpecialization: " .. yn(GetSpecialization),
        "talents: arbre " .. tostring(tab) .. " (" .. tostring(pts) .. " pts, total " .. tostring(total) .. ") -> spec " .. tostring(sn)
            .. " | choix manuel: " .. tostring(self.db.char.my_spec),
        "fenêtres talents: PlayerTalentFrame=" .. yn(PlayerTalentFrame) .. " PlayerSpellsFrame=" .. yn(PlayerSpellsFrame)
            .. " ClassTalentFrame=" .. yn(ClassTalentFrame) .. " | InspectFrame=" .. yn(InspectFrame),
    }
    -- Fenêtre « What's new » et tour guidé : pourquoi une fenêtre ne s'ouvre pas toute seule
    do
        local news = (ForeverCompanionData and ForeverCompanionData.news) or {}
        local g = self.db.global
        table.insert(lines, "what's new: " .. #news .. " version(s) dans les données (dernière " .. tostring(news[1] and news[1].id) .. ")"
            .. " | déjà vue: " .. tostring(g.news_seen) .. " | ouverture auto: " .. yn(g.news_auto ~= false)
            .. " | tour fait: " .. yn(g.tour_done) .. " | bulle du tour vue: " .. yn(g.tour_hint))
    end
    -- Valeurs brutes des API de talents (pour adapter la détection au client)
    local function dump(...)
        local t = {}
        for i = 1, math.min(select("#", ...), 8) do t[i] = tostring((select(i, ...))) end
        return table.concat(t, ", ")
    end
    local function try(label, fn, ...)
        if not fn then return label .. "=absent" end
        local r = { pcall(fn, ...) }
        if not r[1] then return label .. "=erreur" end
        return label .. "=(" .. dump(select(2, unpack(r))) .. ")"
    end
    table.insert(lines, try("GetNumTalentTabs", GetNumTalentTabs) .. " " .. try("GetSpecialization", GetSpecialization))
    for t = 1, 3 do table.insert(lines, try("GetTalentTabInfo(" .. t .. ")", GetTalentTabInfo, t)) end
    table.insert(lines, try("GetTalentInfo(1,1)", GetTalentInfo, 1, 1) .. " " .. try("GetNumTalents(1)", GetNumTalents, 1))
    local okT, r, tot, ti = pcall(ForeverCompanionAPI.TraitTalentPoints, false)
    if okT and r then
        table.insert(lines, "traits: config " .. tostring(ti.configID) .. ", " .. ti.trees .. " arbre(s), " .. ti.nodes .. " nœuds, "
            .. ti.bought .. " achetés, " .. ti.matched .. " reconnus (ID " .. ti.byId .. ", nom " .. ti.byName .. ", position " .. ti.byPos
            .. ", colonnes " .. ti.columns .. ") -> " .. r[1] .. "/" .. r[2] .. "/" .. r[3]
            .. (#ti.unmatched > 0 and (" | non reconnus : " .. table.concat(ti.unmatched, ", ")) or ""))
    else
        table.insert(lines, "traits: " .. (okT and "aucune configuration active" or ("erreur " .. tostring(r))))
    end
    if C_SpecializationInfo and C_SpecializationInfo.GetSpecialization then
        table.insert(lines, try("C_SpecializationInfo.GetSpecialization", C_SpecializationInfo.GetSpecialization))
    end
    -- Hôtel des ventes : API disponible dans ce client
    if self.Auction then
        local ah = self.db.factionrealm.ah
        local n = 0; for _ in pairs(ah.items) do n = n + 1 end
        table.insert(lines, "HV: API " .. tostring(self.Auction.API()) .. " | ReplicateItems=" .. yn(C_AuctionHouse and C_AuctionHouse.ReplicateItems)
            .. " QueryAuctionItems=" .. yn(QueryAuctionItems) .. " | " .. n .. " objets en mémoire, dernier scan complet "
            .. ((ah.lastFull or 0) > 0 and (self.Auction.Age(ah.lastFull)) or "jamais")
            .. " | factures: GetInboxInvoiceInfo=" .. yn(GetInboxInvoiceInfo) .. " | ligne: CreateLine=" .. yn(UIParent and UIParent.CreateLine))
    end
    if self.RecipeScan and self.RecipeScan.Diag then
        local okR, txt = pcall(self.RecipeScan.Diag)
        table.insert(lines, okR and txt or ("métier: erreur " .. tostring(txt)))
    end
    table.insert(lines, "C_Traits=" .. yn(C_Traits) .. " C_ClassTalents=" .. yn(C_ClassTalents) .. " C_SpecializationInfo=" .. yn(C_SpecializationInfo)
        .. " | UnitLevel=" .. tostring(UnitLevel and UnitLevel("player")))
    for _, l in ipairs(lines) do print("|cffffd700FC|r " .. l) end
end

function FC:OnInitialize()
    self:initConfig()
    addMapIcon()
    self:initTooltip()
    self:initBislist()
    if self.initAuction then self:initAuction() end
    if self.initLedger then self:initLedger() end
    self:RegisterChatCommand("fc", slashHandler)
    self:RegisterChatCommand("bis", function() self:ToggleBislist() end)
end
