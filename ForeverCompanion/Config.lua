-- ============================================================
-- Forever Companion — Config.lua
-- ============================================================
local FC = ForeverCompanion

-- Les phases par défaut sont résolues à l'exécution (FC:ValidPhase) car la
-- liste des phases vient des données générées par le Studio.
local defaults = {
    global = {
        minimap = { hide = false },
        -- Hôtel des ventes (réglages du compte)
        ah_enabled = true, ah_autoscan = true, ah_passive = true,
        ah_tooltip = true, ah_tooltip_avg = false, ah_tooltip_vendor = false, ah_keep_days = 60,
        gold_track = true, ledger_track = true,
        map_gather = true, map_gather_all = false,   -- niveaux de récolte sur la carte du monde (MapLevels.lua)
        -- points de récolte sur la carte (GatherMap.lua) ; gather_enabled = interrupteur général (Options → Tabs & features)
        gather_enabled = true,
        gather_worldmap = true, gather_minimap = false,   -- minicarte : à activer (Quick setup ou Options), pour la garder lisible
        gather_only_known = true, gather_hide_low = false, gather_record = true,
        gather_fade_player = true, gather_track_dist = 100,   -- icônes près du joueur atténuées ; anneau dans la portée de détection
        -- échelles de stats (Scales.lua) : ligne d'infobulle, flèche verte, étoile BiS ; échelles personnelles du compte
        scales_enabled = true,   -- interrupteur général des échelles (Options → Tabs & features)
        training_enabled = true, -- sorts à apprendre, à côté du grimoire (Training.lua)
        training_scans = {},     -- relevés chez les maîtres : [CLASSE][sort] = { l, c, rx, fa, n, r, at }
        inventory = {}, inventory_enabled = true, inventory_cross = true, inventory_max = 3,   -- objets des personnages (Inventory.lua)
        scale_tooltip = true, scale_arrows = true, scale_stars = true, custom_scales = {}, custom_scale_next = 0,
        faction_filter = true,                -- objets de l'autre faction cachés (fenêtre BiS, butin, étoile BiS)
        news_auto = true, news_seen = nil,   -- fenêtre « What's new » après une mise à jour (News.lua)
        goldLog = {},         -- [royaume] = { [perso] = { c = classe, m = argent, seg = "début:fin:argent,…" } } (Ledger.lua)
    },
    factionrealm = {
        ah = { items = {}, lastFull = 0 },
        ledger = { list = {}, seen = {} },   -- ventes / achats (courrier de l'HV)
    },
    char = {
        bislist_class = nil, bislist_spec = nil, bislist_phase = nil,
        tooltip_phase = nil,
        phase_highlight = nil,
        phase_highlight_enabled = true,
        show_enchant = true, show_gems = true, show_source = true,
        auto_highlight = true, highlight_class = nil, highlight_spec = nil,
        filter_specs = {},
        my_spec = nil,        -- spec imposée par le joueur (/fc spec), nil = automatique
        spec_choice = {},     -- [arbre] = spec alternative choisie pour cet arbre
        tab_off = {},         -- [id d'onglet] = true : onglet masqué dans la fenêtre principale
        training_open = false, training_ignored = {},   -- sorts à apprendre : liste ouverte, sorts ignorés (Training.lua)
        item_click_ref = true,-- clic sur un objet = info-bulle fixe
        prof_order = {},      -- ordre des métiers (liste d'id)
        build_choice = {},    -- ["classe:spé"] = { name = build choisi, auto = build automatique à ce moment }
        prof_hidden = {},     -- [id de métier] = true : métier masqué
        options_page = nil,   -- dernière catégorie ouverte dans la fenêtre d'options
        scale = nil,          -- échelle de stats choisie ("wh:18", "my:3"), nil = automatique (talents)
    }
}

-- La fenêtre d'options (catégories, cases, menus) est dans Options.lua.

-- ── Ordre et affichage des métiers ────────────────────────────────────────
-- Ordre enregistré par personnage ; les métiers absents de la liste suivent dans l'ordre des données.
function FC:GetProfessionOrder(includeHidden)
    local out, seen = {}, {}
    local byId = {}
    for i, p in ipairs(self.Professions) do byId[p.id] = i end
    for _, id in ipairs(self.db.char.prof_order or {}) do
        local i = byId[id]
        if i and not seen[i] then seen[i] = true; table.insert(out, i) end
    end
    for i in ipairs(self.Professions) do if not seen[i] then table.insert(out, i) end end
    if includeHidden then return out end
    local vis = {}
    for _, i in ipairs(out) do if not self.db.char.prof_hidden[self.Professions[i].id] then table.insert(vis, i) end end
    return vis
end
-- Phase mise en avant dans les tooltips (2e phase par défaut, comme avant : T5)
function FC:GetHighlightPhase()
    return self:ValidPhase(self.db.char.phase_highlight, 3)
end

function FC:AutoDetectHighlight()
    local _, classEn = UnitClass("player")
    local cn = self:ClassFromToken(classEn)
    if not cn or not self:HasClass(cn) then return end
    if self.db.char.highlight_class ~= cn then self.db.char.highlight_spec = nil end
    self.db.char.highlight_class = cn
    -- Suivre la spec détectée (ou choisie) ; sinon garder la précédente si elle existe
    local _, sn = self:DetectPlayerSpec()
    if sn and self:HasSpec(cn, sn) then
        self.db.char.highlight_spec = sn
    elseif not (self.db.char.highlight_spec and self:HasSpec(cn, self.db.char.highlight_spec)) then
        self.db.char.highlight_spec = self:GetSpecs(cn)[1]
    end
end

function FC:IsHighlighted(cn, sn)
    return self.db.char.highlight_class == cn and self.db.char.highlight_spec == sn
end

function FC:IsFiltered(cn, sn)
    if self:IsHighlighted(cn, sn) then return false end
    if IsAltKeyDown() then return false end
    local fs = self.db.char.filter_specs[cn]
    if fs and fs[sn] == false then return true end
    return false
end

function FC:initConfig()
    self.db = LibStub("AceDB-3.0"):New("ForeverCompanionDB", defaults, true)
    -- Ancien relevé automatique chez les maîtres de métier (recettes « scanned ») : supprimé
    self.db.global.trainerScans, self.db.global.trainer_scan = nil, nil
    if self.db.char.auto_highlight then self:AutoDetectHighlight() end
    if self.RegisterOptionsPanel then self:RegisterOptionsPanel() end   -- Échap → Options → AddOns
end
