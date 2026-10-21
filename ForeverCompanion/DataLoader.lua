-- Forever Companion — DataLoader.lua
-- Transforme les données compactes générées par Forever Companion Studio
-- (Data/*.lua → table globale ForeverCompanionData) en structures utilisées par l'interface.
-- Ce fichier est du CODE : il ne contient aucune donnée et ne doit pas changer
-- quand les listes BiS, rotations, talents ou consommables sont mises à jour.
local FC = ForeverCompanion
local D = ForeverCompanionData or {}

FC.DATA_VERSION = (D.meta and D.meta.dataVersion) or 0
FC.DATA_UPDATED = (D.meta and D.meta.updated) or ""

-- ── Phases ────────────────────────────────────────────────────────────────
FC.PHASES, FC.PHASE_LABELS = {}, {}
for _, p in ipairs(D.phases or {}) do
    table.insert(FC.PHASES, p.id)
    FC.PHASE_LABELS[p.id] = p.label or p.id
end
if #FC.PHASES == 0 then FC.PHASES = { "PR" }; FC.PHASE_LABELS.PR = "PR" end

-- Renvoie ph s'il existe, sinon la phase n° fallbackIdx (ou la dernière disponible)
function FC:ValidPhase(ph, fallbackIdx)
    for _, p in ipairs(self.PHASES) do if p == ph then return ph end end
    local i = math.min(fallbackIdx or 1, #self.PHASES)
    return self.PHASES[i]
end

function FC:PhaseLabel(ph) return self.PHASE_LABELS[ph] or ph end

-- ── Emplacements ──────────────────────────────────────────────────────────
FC.SLOT_LABELS = D.slots or {}

-- ── Classes & specs ───────────────────────────────────────────────────────
FC.CLASS_ORDER, FC.CLASS_COLORS, FC.CLASS_ICONS = {}, {}, {}
FC.SPEC_ICONS, FC.TAB_TO_SPEC, FC.STATS_CAPS, FC.CLASS_BY_TOKEN = {}, {}, {}, {}
FC.SPEC_ORDER, FC.SPEC_TREE = {}, {}

local function hexToRGB(hex)
    hex = tostring(hex or "ffffff")
    return {
        r = (tonumber(hex:sub(1, 2), 16) or 255) / 255,
        g = (tonumber(hex:sub(3, 4), 16) or 255) / 255,
        b = (tonumber(hex:sub(5, 6), 16) or 255) / 255,
    }
end

for _, c in ipairs(D.classes or {}) do
    local cn = c.id
    table.insert(FC.CLASS_ORDER, cn)
    FC.CLASS_COLORS[cn] = hexToRGB(c.color)
    FC.CLASS_ICONS[cn] = (c.icon and c.icon > 0) and c.icon or nil
    FC.CLASS_BY_TOKEN[c.token or cn:upper()] = cn
    FC.TAB_TO_SPEC[cn] = c.tabs or {}
    FC.SPEC_ICONS[cn], FC.STATS_CAPS[cn], FC.SPEC_ORDER[cn], FC.SPEC_TREE[cn] = {}, {}, {}, {}
    for _, s in ipairs(c.specs or {}) do
        table.insert(FC.SPEC_ORDER[cn], s.id)
        FC.SPEC_ICONS[cn][s.id] = (s.icon and s.icon > 0) and s.icon or nil
        if s.caps and s.caps ~= "" then FC.STATS_CAPS[cn][s.id] = s.caps end
        -- Arbre de rattachement : 1-3, 0 = hybride (tous arbres), nil = non précisé
        FC.SPEC_TREE[cn][s.id] = s.tree
    end
end

-- ── Dictionnaires ─────────────────────────────────────────────────────────
FC.ITEMS          = D.items or {}
FC.GEM_ITEMS      = D.gems or {}
FC.ENCHANT_DATA   = D.enchants or {}
FC.CONSUME_IDS    = D.consumables or {}
FC.TOKEN_TO_ITEMS = D.tokens or {}
FC.RECIPE_TO_ITEM = D.recipes or {}

-- ── Listes BiS : format étendu (classe → spec → phase → slots) ───────────
-- Chaque item : {name, itemId, rank, enchant={name}|nil, gems={{name,itemId}},
--               source, source_type, drop_chance}
FC.BisData = {}
FC.HAS_GEMS_OR_ENCHANTS = false
FC.HAS_GEMS = false               -- en-tête de colonne : « Enchants » ou « Gems/Ench »
for cn, specs in pairs(D.bis or {}) do
    FC.BisData[cn] = {}
    for sn, phases in pairs(specs) do
        FC.BisData[cn][sn] = {}
        for ph, slots in pairs(phases) do
            local outSlots = {}
            for _, se in ipairs(slots) do
                local list = {}
                for rank, e in ipairs(se.i or {}) do
                    local id = e[1]
                    local it = FC.ITEMS[id] or {}
                    local gems = {}
                    for _, g in ipairs(e.g or {}) do
                        table.insert(gems, { name = g, itemId = FC.GEM_ITEMS[g] or 0 })
                    end
                    if e.e or (e.g and #e.g > 0) then FC.HAS_GEMS_OR_ENCHANTS = true end
                    if e.g and #e.g > 0 then FC.HAS_GEMS = true end
                    table.insert(list, {
                        name = it.n or ("Item " .. id), itemId = id, rank = rank,
                        enchant = e.e and { name = e.e } or nil, gems = gems,
                        source = it.s or "", source_type = it.st or "", drop_chance = it.d or 0,
                    })
                end
                table.insert(outSlots, { slot = se.s, items = list })
            end
            FC.BisData[cn][sn][ph] = outSlots
        end
    end
end

-- Specs d'une classe, dans l'ordre défini dans le Studio (même sans liste BiS :
-- la rotation, les talents ou les consommables peuvent exister seuls)
function FC:GetSpecs(cn)
    local out, seen = {}, {}
    for _, sn in ipairs(self.SPEC_ORDER[cn] or {}) do
        if not seen[sn] then seen[sn] = true; table.insert(out, sn) end
    end
    -- Specs présentes dans les listes mais absentes des métadonnées
    local extra = {}
    for sn in pairs(self.BisData[cn] or {}) do if not seen[sn] then table.insert(extra, sn) end end
    table.sort(extra)
    for _, sn in ipairs(extra) do table.insert(out, sn) end
    return out
end

-- Classes, dans l'ordre défini dans le Studio
function FC:GetClasses()
    local out, seen = {}, {}
    for _, cn in ipairs(self.CLASS_ORDER) do table.insert(out, cn); seen[cn] = true end
    local extra = {}
    for cn in pairs(self.BisData) do if not seen[cn] then table.insert(extra, cn) end end
    table.sort(extra)
    for _, cn in ipairs(extra) do table.insert(out, cn) end
    return out
end

function FC:HasClass(cn)
    for _, c in ipairs(self:GetClasses()) do if c == cn then return true end end
    return false
end

-- ── Rotations, consommables, talents ──────────────────────────────────────
FC.RotationData = {}
for cn, specs in pairs(D.rotations or {}) do
    FC.RotationData[cn] = {}
    for sn, r in pairs(specs) do
        FC.RotationData[cn][sn] = { steps = r.single or {}, aoe = r.aoe or {}, intro = r.intro, sections = r.sections or {} }
    end
end
FC.ConsumesData = D.consumes or {}

-- ── Onglets latéraux (réglés dans le Studio, onglet Interface) ────────────
local DEFAULT_TABS = {
    { id = "consumables", label = "Consumables", icon = "inv_potion_93", on = true },
    { id = "talents", label = "BiS Talents", icon = "ability_marksmanship", on = true },
    { id = "stats", label = "Stats Cap", icon = "inv_misc_book_11", on = true },
    { id = "rotation", label = "Rotation", icon = "spell_holy_borrowedtime", on = true },
    { id = "loot", label = "Dungeon Loot", icon = "inv_misc_bag_10", on = true },
    { id = "professions", label = "Professions", icon = "trade_blacksmithing", on = true },
    { id = "market", label = "Auction House", icon = "inv_misc_coin_02", on = true },
}
FC.UI_TABS = {}
do
    local seen = {}
    for _, t in ipairs((D.ui and D.ui.tabs) or {}) do
        if t.id and not seen[t.id] then seen[t.id] = true; table.insert(FC.UI_TABS, t) end
    end
    for _, t in ipairs(DEFAULT_TABS) do
        if not seen[t.id] then table.insert(FC.UI_TABS, t) end   -- onglet absent des données (anciennes données)
    end
end

-- ── Tables de loot et métiers ─────────────────────────────────────────────
FC.Dungeons    = D.dungeons or {}
FC.LootItems   = D.lootItems or {}
FC.Professions = D.professions or {}
FC.CraftItems  = D.craftItems or {}
FC.TalentTrees  = D.talentTrees or {}
FC.TalentBuilds = D.talentBuilds or {}

-- ── Build actif d'une spé (partagé par les fenêtres Talents et Rotation) ──────
-- Niveau d'un build (« Level 30 (Beta) » → 30) : donné par le Studio (lv), sinon lu dans son nom
function FC:BuildLevel(b)
    if not b then return nil end
    if b.lv then return b.lv end
    local name = tostring(b.name or "")
    local n = name:match("[Ll]evel%s*(%d+)") or name:match("[Nn]iveau%s*(%d+)")
    return n and tonumber(n) or nil
end
function FC:GetBuilds(cn, sn)
    local c = cn and (FC.TalentBuilds[tostring(cn):lower()] or FC.TalentBuilds[cn])
    return (c and sn and c[sn]) or {}
end
-- Build choisi d'office : le plus petit « Level N » qui couvre le niveau du perso, sinon le standard
function FC:AutoBuildIndex(builds)
    local lvl = (UnitLevel and UnitLevel("player")) or 0
    local best, bestLv
    for i, b in ipairs(builds) do
        local lv = FC:BuildLevel(b)
        if lv and lvl <= lv and (not bestLv or lv < bestLv) then best, bestLv = i, lv end
    end
    if best then return best end
    for i, b in ipairs(builds) do if not FC:BuildLevel(b) then return i end end
    return 1
end
local function BuildKey(cn, sn) return tostring(cn):lower() .. ":" .. tostring(sn) end
-- Index du build actif, la liste des builds, et vrai s'il est choisi d'office.
-- Un choix manuel est gardé tant que le choix automatique ne change pas (ex. passage du niveau 30).
function FC:GetBuildIndex(cn, sn)
    local builds = FC:GetBuilds(cn, sn)
    if #builds == 0 then return nil, builds, true end
    local auto = FC:AutoBuildIndex(builds)
    local ch = FC.db and FC.db.char.build_choice and FC.db.char.build_choice[BuildKey(cn, sn)]
    if ch and builds[auto] and ch.auto == builds[auto].name then
        for i, b in ipairs(builds) do if b.name == ch.name then return i, builds, false end end
    end
    return auto, builds, true
end
function FC:SetBuildIndex(cn, sn, idx)
    local builds = FC:GetBuilds(cn, sn)
    if not builds[idx] or not FC.db then return end
    FC.db.char.build_choice = FC.db.char.build_choice or {}
    local auto = FC:AutoBuildIndex(builds)
    FC.db.char.build_choice[BuildKey(cn, sn)] = (idx ~= auto) and { name = builds[idx].name, auto = builds[auto].name } or nil
    if FC.RefreshTalentBuild then FC:RefreshTalentBuild(cn, sn) end
    if FC.RefreshRotationBuild then FC:RefreshRotationBuild(cn, sn) end
end
