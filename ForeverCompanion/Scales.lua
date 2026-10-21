-- Forever Companion — Scales.lua
-- Échelles de stats, comme l'addon Pawn : la valeur d'un objet est la somme « poids × stat ».
--   • échelles de Wowhead (Data/Weights.lua, générées par le Studio), une ou plusieurs par spécialisation ;
--   • échelles personnelles (compte entier) : copie d'une échelle Wowhead modifiée en jeu, ou texte Pawn importé.
-- L'échelle active est celle choisie dans les options, sinon celle de Wowhead qui correspond à
-- l'arbre de talents le plus rempli. La valeur d'un objet est comparée à celle de l'objet porté :
-- ligne dans l'infobulle, flèche verte et étoile BiS (ScalesOverlay.lua).
-- Les noms des stats sont ceux de Pawn (Strength, HitRating, MeleeDps…), pour l'import / export.
local FC = ForeverCompanion
local API = ForeverCompanionAPI
local Scales = {}
FC.Scales = Scales

-- ── Stats ─────────────────────────────────────────────────────────────────
-- Ordre d'affichage (éditeur, export). Pour toucher, critique, esquive, parade et blocage :
-- 1 point = 1 % (objets de Classic). Vitesse des armes : en secondes.
Scales.STATS = {
    { "Strength", "Strength" }, { "Agility", "Agility" }, { "Stamina", "Stamina" }, { "Intellect", "Intellect" }, { "Spirit", "Spirit" },
    { "Ap", "Attack power" }, { "Rap", "Ranged attack power" }, { "FeralAp", "Feral attack power" },
    { "HitRating", "Hit %" }, { "CritRating", "Crit %" },
    { "MeleeDps", "Melee weapon DPS" }, { "MeleeSpeed", "Melee weapon speed" },
    { "RangedDps", "Ranged weapon DPS" }, { "RangedSpeed", "Ranged weapon speed" },
    { "SpellPower", "Spell damage and healing" }, { "SpellDamage", "Spell damage" }, { "Healing", "Healing" },
    { "ArcaneSpellDamage", "Arcane spell damage" }, { "FireSpellDamage", "Fire spell damage" }, { "FrostSpellDamage", "Frost spell damage" },
    { "HolySpellDamage", "Holy spell damage" }, { "NatureSpellDamage", "Nature spell damage" }, { "ShadowSpellDamage", "Shadow spell damage" },
    { "SpellHitRating", "Spell hit %" }, { "SpellCritRating", "Spell crit %" }, { "SpellPenetration", "Spell penetration" },
    { "Mp5", "Mana per 5 sec" }, { "Hp5", "Health per 5 sec" },
    { "Armor", "Armor" }, { "DefenseRating", "Defense" }, { "DodgeRating", "Dodge %" }, { "ParryRating", "Parry %" },
    { "BlockRating", "Block %" }, { "BlockValue", "Block value" },
}
Scales.LABEL = {}
local ALIAS = {}   -- nom en minuscules (Pawn, variantes) → nom de la stat
for _, s in ipairs(Scales.STATS) do Scales.LABEL[s[1]] = s[2]; ALIAS[s[1]:lower()] = s[1] end
for k, v in pairs({ hit = "HitRating", crit = "CritRating", spellhit = "SpellHitRating", spellcrit = "SpellCritRating",
    defense = "DefenseRating", dodge = "DodgeRating", parry = "ParryRating", block = "BlockRating",
    attackpower = "Ap", rangedattackpower = "Rap", feralattackpower = "FeralAp", manaregen = "Mp5", healthregen = "Hp5",
    bonusarmor = "Armor", spelldamageandhealing = "SpellPower", healingpower = "Healing", spellpen = "SpellPenetration" }) do ALIAS[k] = v end

-- Caractéristiques de base renvoyées par le jeu (GetItemStats)
local BASE_KEYS = {
    ITEM_MOD_STRENGTH_SHORT = "Strength", ITEM_MOD_AGILITY_SHORT = "Agility", ITEM_MOD_STAMINA_SHORT = "Stamina",
    ITEM_MOD_INTELLECT_SHORT = "Intellect", ITEM_MOD_SPIRIT_SHORT = "Spirit", RESISTANCE0_NAME = "Armor",
}
-- Effets « Équipé : » : lus dans l'infobulle (français, anglais) ; ces clés du jeu servent pour les
-- stats que l'infobulle n'a pas données (autre langue du client, stat affichée sans « Équipé : »)
local EXTRA_KEYS = {
    ITEM_MOD_HIT_RATING_SHORT = "HitRating", ITEM_MOD_CRIT_RATING_SHORT = "CritRating",
    ITEM_MOD_HIT_SPELL_RATING_SHORT = "SpellHitRating", ITEM_MOD_CRIT_SPELL_RATING_SHORT = "SpellCritRating",
    ITEM_MOD_SPELL_POWER_SHORT = "SpellPower", ITEM_MOD_SPELL_DAMAGE_DONE_SHORT = "SpellDamage", ITEM_MOD_SPELL_HEALING_DONE_SHORT = "Healing",
    ITEM_MOD_ATTACK_POWER_SHORT = "Ap", ITEM_MOD_RANGED_ATTACK_POWER_SHORT = "Rap", ITEM_MOD_FERAL_ATTACK_POWER_SHORT = "FeralAp",
    ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = "DefenseRating", ITEM_MOD_DODGE_RATING_SHORT = "DodgeRating", ITEM_MOD_PARRY_RATING_SHORT = "ParryRating",
    ITEM_MOD_BLOCK_RATING_SHORT = "BlockRating", ITEM_MOD_BLOCK_VALUE_SHORT = "BlockValue",
    ITEM_MOD_MANA_REGENERATION_SHORT = "Mp5", ITEM_MOD_HEALTH_REGEN_SHORT = "Hp5", ITEM_MOD_HEALTH_REGENERATION_SHORT = "Hp5",
    ITEM_MOD_SPELL_PENETRATION_SHORT = "SpellPenetration",
}

-- Familles de stats : une stat du jeu n'est reprise que si l'infobulle n'a rien donné pour sa famille
-- (un objet « dégâts et soins » ne doit pas compter aussi des dégâts et des soins à part)
local FAMILY = { SpellPower = "spell", SpellDamage = "spell", Healing = "spell", ArcaneSpellDamage = "spell", FireSpellDamage = "spell",
    FrostSpellDamage = "spell", HolySpellDamage = "spell", NatureSpellDamage = "spell", ShadowSpellDamage = "spell",
    Ap = "ap", Rap = "ap", FeralAp = "ap" }
local function Family(k) return FAMILY[k] or k end

-- Emplacements d'équipement comparés
local SLOTS = {
    INVTYPE_HEAD = { 1 }, INVTYPE_NECK = { 2 }, INVTYPE_SHOULDER = { 3 }, INVTYPE_CHEST = { 5 }, INVTYPE_ROBE = { 5 },
    INVTYPE_WAIST = { 6 }, INVTYPE_LEGS = { 7 }, INVTYPE_FEET = { 8 }, INVTYPE_WRIST = { 9 }, INVTYPE_HAND = { 10 },
    INVTYPE_FINGER = { 11, 12 }, INVTYPE_TRINKET = { 13, 14 }, INVTYPE_CLOAK = { 15 },
    INVTYPE_WEAPON = { 16 }, INVTYPE_2HWEAPON = { 16 }, INVTYPE_WEAPONMAINHAND = { 16 },
    INVTYPE_WEAPONOFFHAND = { 17 }, INVTYPE_SHIELD = { 17 }, INVTYPE_HOLDABLE = { 17 },
    INVTYPE_RANGED = { 18 }, INVTYPE_RANGEDRIGHT = { 18 }, INVTYPE_THROWN = { 18 }, INVTYPE_RELIC = { 18 },
}
local RANGED = { INVTYPE_RANGED = true, INVTYPE_RANGEDRIGHT = true, INVTYPE_THROWN = true }
Scales.SLOTS = SLOTS

-- ── Lecture des effets « Équipé : » (français et anglais) ─────────────────
local function has(s, ...)
    for i = 1, select("#", ...) do if s:find((select(i, ...)), 1, true) then return true end end
    return false
end
local SCHOOLS = {
    { "ArcaneSpellDamage", { "arcane" } }, { "FireSpellDamage", { "feu", "fire" } }, { "FrostSpellDamage", { "givre", "frost" } },
    { "HolySpellDamage", { "sacre", "holy" } }, { "NatureSpellDamage", { "nature" } }, { "ShadowSpellDamage", { "ombre", "shadow" } },
}
-- n : texte normalisé (minuscules, sans accents) après « Équipé : ». Renvoie stat, valeur.
function Scales.ParseEquip(n)
    local v = n:match("(%d+[%.,]?%d*)")
    v = v and tonumber((v:gsub(",", ".")))
    if not v then return nil end
    -- Bonus de situation (contre les morts-vivants, les démons…) : ignorés, comme dans Pawn
    if has(n, "undead", "mort-vivant", "morts-vivants", "demon", "when fighting", "combattez", "contre les") then return nil end
    if has(n, "resistance") and has(n, "cible", "target") then return "SpellPenetration", v end
    local per5 = has(n, "5 sec", "5 s.", "per 5", "every 5", "toutes les 5")
    if per5 and has(n, "mana") then return "Mp5", v end
    if per5 and has(n, "health", "vie") then return "Hp5", v end
    local spell = has(n, "sort", "spell")
    if has(n, "critique", "critical") then return spell and "SpellCritRating" or "CritRating", v end
    if has(n, "toucher", "to hit") then return spell and "SpellHitRating" or "HitRating", v end
    if has(n, "esquiv", "dodge") then return "DodgeRating", v end
    if has(n, "parer", "parry") then return "ParryRating", v end
    if has(n, "valeur de blocage", "block value") then return "BlockValue", v end
    if has(n, "bloquer", "block") then return "BlockRating", v end
    if has(n, "defense") then return "DefenseRating", v end
    if has(n, "puissance d'attaque", "attack power") then
        if has(n, "felin", "cat,", "cat ", "ours", "bear") then return "FeralAp", v end
        if has(n, "distance", "ranged") then return "Rap", v end
        return "Ap", v
    end
    local dmg, heal = has(n, "degats", "damage"), has(n, "soins", "healing")
    if dmg and heal then return "SpellPower", v end
    if heal then return "Healing", v end
    if dmg then
        for _, sc in ipairs(SCHOOLS) do if has(n, unpack(sc[2])) then return sc[1], v end end
        if spell or has(n, "magique", "magical") then return "SpellDamage", v end
    end
    return nil
end

-- Préfixes « Équipé : » normalisés (texte du client, puis français et anglais)
local EQUIP_PREFIXES
local function EquipBody(norm)
    if not EQUIP_PREFIXES then
        EQUIP_PREFIXES = { "equipe :", "equipe:", "equip:", "equip :" }
        local g = rawget(_G, "ITEM_SPELL_TRIGGER_ONEQUIP")
        if type(g) == "string" and g ~= "" then table.insert(EQUIP_PREFIXES, 1, (API.SearchNorm(g):gsub("\194\160", " "))) end
    end
    for _, p in ipairs(EQUIP_PREFIXES) do
        if norm:sub(1, #p) == p then return (norm:sub(#p + 1):gsub("^%s+", "")) end
    end
end
local function Num(s)
    local v = s and (s:match("(%d+[%.,]%d+)") or s:match("(%d+)"))
    return v and tonumber((v:gsub(",", "."))) or nil
end
local function Norm(s) return (API.SearchNorm(s):gsub("\194\160", " ")) end   -- espaces insécables du client français
-- Chaîne du jeu (« Niveau %d requis ») → motif Lua normalisé (« ^niveau (.-) requis$ »), nil si absente
local function FmtPattern(g)
    local s = rawget(_G, g)
    if type(s) ~= "string" or s == "" then return nil end
    s = Norm(s):gsub("%%%d%$", "%%")                                            -- %1$s → %s
    s = s:gsub("%%c%%d", "\1"):gsub("%%d", "\2"):gsub("%%s", "\3")
    s = s:gsub("([%^%$%(%)%.%[%]%*%+%-%?%%])", "%%%1")                          -- caractères spéciaux des motifs
    s = s:gsub("\1", "[%%+%%-]?(%%d+)"):gsub("\2", "(%%d+)"):gsub("\3", "(.-)")  -- %c%d, %d : nombre ; %s : texte
    return "^" .. s .. "$"
end
local P_CACHE = {}
local function Pat(g)
    if P_CACHE[g] == nil then P_CACHE[g] = FmtPattern(g) or false end
    return P_CACHE[g] or nil
end
-- Caractéristiques de base lues dans l'infobulle (seulement si le jeu n'a pas GetItemStats)
local BASE_LINES = {
    { "Strength", "ITEM_MOD_STRENGTH", { "force", "strength" } }, { "Agility", "ITEM_MOD_AGILITY", { "agilite", "agility" } },
    { "Stamina", "ITEM_MOD_STAMINA", { "endurance", "stamina" } }, { "Intellect", "ITEM_MOD_INTELLECT", { "intelligence", "intellect" } },
    { "Spirit", "ITEM_MOD_SPIRIT", { "esprit", "spirit" } },
}
local function BaseLine(l)
    for _, b in ipairs(BASE_LINES) do
        local p = Pat(b[2])
        local v = p and l:match(p)
        if not v then
            for _, w in ipairs(b[3]) do v = v or l:match("^%+(%d+) " .. w .. "$") end
        end
        if v and tonumber(v) then return b[1], tonumber(v) end
    end
    local p = Pat("ARMOR_TEMPLATE")
    local v = (p and l:match(p)) or l:match("^(%d+) armure$") or l:match("^(%d+) armor$")
    if v and tonumber(v) then return "Armor", tonumber(v) end
end
local function IsLevelLine(l)
    local p = Pat("ITEM_MIN_LEVEL")
    return (p and l:find(p) ~= nil) or l:find("^niveau %d+ requis") ~= nil or l:find("^requires level %d+") ~= nil
end
local function IsDpsLine(l)
    local p = Pat("DPS_TEMPLATE")
    return (p and l:find(p) ~= nil) or (l:find("^%(") ~= nil and (l:find("par seconde", 1, true) or l:find("per second", 1, true)) ~= nil)
end
local function BlockLine(l)
    local p = Pat("SHIELD_BLOCK_TEMPLATE")
    return (p and l:match(p)) or l:match("^(%d+) bloquer$") or l:match("^(%d+) block$") or l:match("^(%d+) blocage$")
end
local function SpeedText(r)
    local w = rawget(_G, "SPEED")
    w = type(w) == "string" and w ~= "" and Norm(w) or nil
    return (w and r:find(w, 1, true)) or r:find("vitesse", 1, true) or r:find("speed", 1, true)
end
-- Clé d'un objet porté ou survolé : ID, enchantement, suffixe (les liens varient selon la fenêtre)
local function ItemKey(link)
    local body = tostring(link or ""):match("item:([%-%d:]*)")
    if not body then return link end
    local p = {}
    for x in (body .. ":"):gmatch("([^:]*):") do p[#p + 1] = x end
    return (p[1] or "") .. ":" .. (p[2] or "") .. ":" .. (p[7] or "")
end
Scales.ItemKey = ItemKey

-- ── Lecture d'un objet (mise en cache par lien) ───────────────────────────
-- { loc = emplacement (INVTYPE_…), stats = { Stat = valeur }, usable = bool }, ou nil si l'objet
-- ne s'équipe pas ou n'est pas encore connu du client (réessayer plus tard)
local cache, cacheN = {}, 0
function Scales.ClearCache() cache, cacheN = {}, 0 end

function Scales.ReadItem(link)
    if type(link) ~= "string" or not link:find("item:", 1, true) then return nil end
    local hit = cache[link]
    if hit ~= nil then return hit or nil end
    local _, _, _, loc = API.GetItemInfoInstant(link)
    if not loc or not SLOTS[loc] then cache[link] = false; return nil end
    local lines = API.TooltipLines(link)
    local base = API.GetItemStats(link)
    local complete = lines and #lines >= 2
    if not complete and not base then return nil, true end   -- pas encore chargé par le client : nil, true
    local stats, usable, parsed = {}, true, {}
    local function add(k, v) if k and v and v ~= 0 then stats[k] = (stats[k] or 0) + v end end
    for k, v in pairs(base or {}) do add(BASE_KEYS[k], tonumber(v)) end
    local dps = base and tonumber(base.ITEM_MOD_DAMAGE_PER_SECOND_SHORT)
    local speed
    for i, ln in ipairs(lines or {}) do
        local l = ln.l and Norm(ln.l) or ""
        local r = ln.r and Norm(ln.r) or ""
        if ln.red and i > 1 and not IsLevelLine(l) then usable = false end
        local body = EquipBody(l)
        if body then
            local k, v = Scales.ParseEquip(body)
            if k then add(k, v); parsed[Family(k)] = true end
        else
            if r ~= "" and SpeedText(r) then speed = Num(r) end
            if not dps and IsDpsLine(l) then dps = Num(l) end
            local b = BlockLine(l)
            if b then add("BlockValue", tonumber(b)) end
            if not base then add(BaseLine(l)) end
        end
    end
    for k, v in pairs(base or {}) do
        local st = EXTRA_KEYS[k]
        if st and not parsed[Family(st)] then add(st, tonumber(v)) end
    end
    if dps and dps > 0 then add(RANGED[loc] and "RangedDps" or "MeleeDps", dps) end
    if speed and speed > 0 and (dps or 0) > 0 then add(RANGED[loc] and "RangedSpeed" or "MeleeSpeed", speed) end
    local it = { loc = loc, stats = stats, usable = usable }
    if complete then
        if cacheN > 600 then Scales.ClearCache() end
        cache[link] = it; cacheN = cacheN + 1
    end
    return it
end

function Scales.Score(stats, w)
    local s = 0
    for k, v in pairs(stats or {}) do local x = w and w[k]; if x then s = s + x * v end end
    return s
end

-- ── Échelles disponibles ──────────────────────────────────────────────────
local function PlayerToken() local _, t = UnitClass("player"); return t end
Scales.PlayerToken = PlayerToken
local function Customs()
    local g = FC.db and FC.db.global
    if not g then return {} end
    g.custom_scales = g.custom_scales or {}
    return g.custom_scales
end
Scales.Customs = Customs
local function Role(label)
    local s = tostring(label or ""):lower()
    if s:find("heal") then return "heal" end
    if s:find("tank") then return "tank" end
    return "dps"
end
-- Arbre sans échelle Wowhead : rôle le plus proche (Discipline → soins), sinon une échelle de dégâts
local FALLBACK_ROLE = { PRIEST = { [1] = "heal" } }

-- Échelles d'une classe : celles de Wowhead puis les personnelles (sans classe = toutes les classes)
function Scales.ForClass(token)
    token = token or PlayerToken()
    local out = {}
    local D = (ForeverCompanionData and ForeverCompanionData.weights) or {}
    for _, s in ipairs(D[token] or {}) do
        out[#out + 1] = { key = "wh:" .. s.id, label = s.label, tab = s.tab, icon = s.icon, w = s.w, wowhead = true }
    end
    for _, c in ipairs(Customs()) do
        if not c.class or c.class == token then
            out[#out + 1] = { key = "my:" .. c.id, label = c.name, tab = c.tab, w = c.w, custom = c }
        end
    end
    return out
end

function Scales.ByKey(key, token)
    if not key then return nil end
    for _, s in ipairs(Scales.ForClass(token)) do if s.key == key then return s end end
end

-- Échelle Wowhead d'après l'arbre de talents le plus rempli
function Scales.Auto(token)
    token = token or PlayerToken()
    local list = {}
    for _, s in ipairs(Scales.ForClass(token)) do if s.wowhead then list[#list + 1] = s end end
    if #list == 0 then return nil end
    local tab, _, total = API.CountTalentPoints(false)
    if tab and (total or 0) > 0 then
        for _, s in ipairs(list) do if s.tab == tab then return s end end
    end
    local want = (tab and (total or 0) > 0 and FALLBACK_ROLE[token] and FALLBACK_ROLE[token][tab]) or "dps"
    for _, s in ipairs(list) do if Role(s.label) == want then return s end end
    return list[1]
end

-- Échelle active : choisie dans les options (si elle existe encore), sinon automatique
function Scales.Active()
    local key = FC.db and FC.db.char.scale
    local s = key and Scales.ByKey(key)
    if s then return s, false end
    return Scales.Auto(), true
end

-- ── Échelles personnelles ─────────────────────────────────────────────────
local function UniqueName(name, except)
    name = tostring(name or "Scale"):gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then name = "Scale" end
    local function taken(n) for _, c in ipairs(Customs()) do if c ~= except and c.name == n then return true end end end
    if not taken(name) then return name end
    local i = 2
    while taken(name .. " " .. i) do i = i + 1 end
    return name .. " " .. i
end
-- def = { name, class, tab, w } → échelle enregistrée (nom rendu unique)
function Scales.AddCustom(def)
    local list = Customs()
    local g = FC.db.global
    g.custom_scale_next = (g.custom_scale_next or 0) + 1
    local w = {}
    for k, v in pairs(def.w or {}) do if Scales.LABEL[k] and tonumber(v) and tonumber(v) ~= 0 then w[k] = tonumber(v) end end
    local c = { id = g.custom_scale_next, name = UniqueName(def.name), class = def.class, tab = def.tab, w = w }
    list[#list + 1] = c
    return c
end
function Scales.Copy(scale)
    if not scale then return nil end
    return Scales.AddCustom({ name = scale.label .. " (copy)", class = PlayerToken(), tab = scale.tab, w = scale.w })
end
function Scales.Rename(c, name) c.name = UniqueName(name, c); return c.name end
function Scales.SetWeight(c, stat, v)
    v = tonumber(v)
    if not Scales.LABEL[stat] then return end
    c.w[stat] = (v and v ~= 0) and v or nil
end
function Scales.DeleteCustom(c)
    local list = Customs()
    for i, x in ipairs(list) do if x == c then table.remove(list, i); break end end
    if FC.db.char.scale == "my:" .. c.id then FC.db.char.scale = nil end
end

-- ── Format Pawn ───────────────────────────────────────────────────────────
-- ( Pawn: v1: "Nom": Class=Warrior, Spec=2, Strength=1, HitRating=10, … )
local CLASS_NUM = { "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "DEATHKNIGHT", "SHAMAN", "MAGE", "WARLOCK", "MONK", "DRUID" }
local function Fmt(v)
    local s = string.format("%.3f", v):gsub("0+$", ""):gsub("%.$", "")
    return s
end
function Scales.Export(scale)
    local parts = {}
    local token = (scale.custom and scale.custom.class) or (scale.wowhead and PlayerToken()) or nil
    if token then parts[#parts + 1] = "Class=" .. token:sub(1, 1) .. token:sub(2):lower():gsub("knight", "Knight") end
    if scale.tab and scale.tab > 0 then parts[#parts + 1] = "Spec=" .. scale.tab end
    for _, s in ipairs(Scales.STATS) do
        local v = scale.w[s[1]]
        if v and v ~= 0 then parts[#parts + 1] = s[1] .. "=" .. Fmt(v) end
    end
    return '( Pawn: v1: "' .. tostring(scale.label):gsub('"', "'") .. '": ' .. table.concat(parts, ", ") .. " )"
end
-- Renvoie def (à passer à AddCustom), ignorées (noms de stats inconnus) ; ou nil, message
function Scales.ParsePawn(text)
    text = tostring(text or ""):gsub("[\r\n]+", " ")
    local name, body = text:match('%(%s*[Pp]awn%s*:%s*v%d+%s*:%s*"([^"]*)"%s*:%s*(.-)%s*%)')
    if not name then return nil, "This text is not a scale." end
    local w, ignored, cls, tab = {}, {}, nil, nil
    local function put(k, n) if n and n ~= 0 then w[k] = (w[k] or 0) + n end end
    for k, v in body:gmatch("([%w_]+)%s*=%s*([^,%s%)]+)") do
        local lk, n = k:lower(), tonumber((v:gsub(",", ".")))
        if lk == "class" then
            cls = n and CLASS_NUM[n] or v:upper():gsub("[%s_]", "")
        elseif lk == "spec" then
            tab = n
        elseif lk == "dps" then put("MeleeDps", n); put("RangedDps", n)
        elseif lk == "speed" then put("MeleeSpeed", n); put("RangedSpeed", n)
        elseif ALIAS[lk] and n then put(ALIAS[lk], n)
        else ignored[#ignored + 1] = k end
    end
    if not next(w) then return nil, "No stat this addon knows in that scale." end
    return { name = name, class = cls, tab = tab, w = w }, ignored
end

-- ── Comparaison avec l'équipement porté ───────────────────────────────────
-- { score, old (nil si non comparable), pct, usable, equipped, upgrade } ; nil, true si l'objet n'est pas encore chargé
local EPS = 0.001
function Scales.Evaluate(link, scale)
    scale = scale or Scales.Active()
    if not scale then return nil end
    local it, wait = Scales.ReadItem(link)
    if not it then return nil, wait end
    local w, key = scale.w, ItemKey(link)
    local ev = { score = Scales.Score(it.stats, w), usable = it.usable }
    local function eq(slot)
        local l = GetInventoryItemLink("player", slot)
        if l and ItemKey(l) == key then ev.equipped = true end
        if not l then return 0, nil end
        local e = Scales.ReadItem(l)
        return e and Scales.Score(e.stats, w) or 0, e
    end
    local loc, slots = it.loc, SLOTS[it.loc]
    if loc == "INVTYPE_2HWEAPON" then
        ev.old = (eq(16)) + (eq(17))
    elseif loc == "INVTYPE_WEAPON" then
        local a = eq(16)
        local b, eb = eq(17)
        if eb and (eb.loc == "INVTYPE_WEAPON" or eb.loc == "INVTYPE_WEAPONOFFHAND") then ev.old = math.min(a, b) else ev.old = a end
    elseif slots[1] == 17 then
        local _, ea = eq(16)
        local b = eq(17)
        if not (ea and ea.loc == "INVTYPE_2HWEAPON") then ev.old = b end   -- main gauche avec une arme à deux mains : rien à comparer
    elseif slots[2] then
        ev.old = math.min((eq(slots[1])), (eq(slots[2])))
    else
        ev.old = (eq(slots[1]))
    end
    if ev.old and ev.old > EPS then ev.pct = (ev.score - ev.old) / ev.old * 100 end
    ev.upgrade = (ev.usable and not ev.equipped and ev.old and ev.score > EPS and ev.score > ev.old + EPS) and true or false
    return ev
end
function Scales.IsUpgrade(link)
    local ev = Scales.Evaluate(link)
    return ev and ev.upgrade or false
end

-- ── Étoile BiS : rang de l'objet dans la liste de ma spé (phase mise en avant) ──
-- Avec le filtre de faction, rang parmi les objets de ma faction : si le n°1 est réservé à l'autre
-- faction, le n°2 devient le meilleur (étoile dorée) ; un objet de l'autre faction n'a pas d'étoile.
local function EffectiveRank(cn, sn, ph, itemId, rank)
    if not FC:FactionFilterOn() then return rank end
    if FC:IsOtherFaction(itemId) then return nil end
    local slots = ((FC.BisData or {})[cn] or {})[sn]
    slots = slots and slots[ph]
    local best
    for _, se in ipairs(slots or {}) do
        local r = 0
        for _, it in ipairs(se.items or {}) do
            if not FC:IsOtherFaction(it.itemId) then
                r = r + 1
                if it.itemId == itemId and (not best or r < best) then best = r end
            end
        end
    end
    return best or rank
end
function Scales.BisRank(itemId)
    if not itemId then return nil end
    local cn = FC:ClassFromToken(PlayerToken())
    if not cn then return nil end
    local db = FC.db.char
    local sn = (db.highlight_class == cn and db.highlight_spec) or select(2, FC:DetectPlayerSpec())
    if not sn then return nil end
    local ph = FC:GetHighlightPhase()
    local best
    local function scan(list)
        for _, e in ipairs(list or {}) do
            if e.class_name == cn and e.spec_name == sn and e.phase == ph and e.rank then
                local r = EffectiveRank(cn, sn, ph, e.itemId or itemId, e.rank)
                if r and (not best or r < best) then best = r end
            end
        end
    end
    scan(FC:GetEntriesForItem(itemId))
    scan(FC:GetEntriesForToken(itemId))
    return best
end

-- ── Infobulle ─────────────────────────────────────────────────────────────
local MEDIA = "Interface\\AddOns\\ForeverCompanion\\Media\\"
Scales.MEDIA = MEDIA
-- Icônes du jeu : flèche verte des sacs (« bags-greenarrow ») ; l'image de l'addon ne sert que si
-- le client n'a pas cet atlas. Étoile : celle de la fenêtre de réputation, comme le butin des donjons.
local ARROW_ATLAS = "bags-greenarrow"
local STAR_TEX = "Interface\\Common\\ReputationStar"
function Scales.SetArrowTexture(tex)
    if API.AtlasExists(ARROW_ATLAS) then tex:SetAtlas(ARROW_ATLAS)
    else tex:SetTexture(MEDIA .. "UpgradeArrow"); tex:SetVertexColor(0.25, 1, 0.25) end
end
function Scales.SetStarTexture(tex)
    tex:SetTexture(STAR_TEX); tex:SetTexCoord(0, 0.5, 0, 0.5)
end
local function ArrowUp()
    if API.AtlasExists(ARROW_ATLAS) then return "|A:" .. ARROW_ATLAS .. ":14:14|a" end
    return "|T" .. MEDIA .. "UpgradeArrow:12:12:0:0:32:32:0:32:0:32:64:255:64|t"
end
function Scales.FormatScore(v)
    if math.abs(v) >= 100 then return tostring(math.floor(v + 0.5)) end
    return (string.format("%.1f", v):gsub("%.0$", ""))
end
local function Pct(p)
    if math.abs(p) >= 10 then return string.format("%+d%%", p >= 0 and math.floor(p + 0.5) or -math.floor(-p + 0.5)) end
    return (string.format("%+.1f%%", p):gsub("%.0%%", "%%"))
end
-- Texte de droite de la ligne (comparaison), exposé pour les tests
function Scales.CompareText(ev)
    if ev.equipped then return "|cff9d9d9dequipped|r" end
    if not ev.usable then return "|cff9d9d9dcan't use|r" end
    if not ev.old then return "" end
    if ev.score > ev.old + EPS then
        return ArrowUp() .. " |cff40ff40" .. (ev.pct and Pct(ev.pct) or "new") .. "|r"
    elseif ev.score < ev.old - EPS then
        return "|cffff4848" .. (ev.pct and Pct(ev.pct) or "") .. "|r"
    end
    return "|cff9d9d9d=|r"
end

function Scales.AddTooltipLine(tooltip)
    if not FC.db or FC.db.global.scales_enabled == false or FC.db.global.scale_tooltip == false or not tooltip or not tooltip.GetItem then return false end
    local _, link = tooltip:GetItem()
    if not link then return false end
    local scale = Scales.Active()
    if not scale then return false end
    local ev = Scales.Evaluate(link, scale)
    if not ev or (ev.score <= EPS and (ev.old or 0) <= EPS) then return false end
    local icon = scale.icon and ("|T" .. API.IconPath(scale.icon) .. ":12:12:0:0|t ") or ""
    -- Amélioration : toute la ligne en vert (plus visible que le seul pourcentage)
    local r, g, b = 1, 0.82, 0
    if ev.upgrade then r, g, b = 0.25, 1, 0.25 end
    tooltip:AddDoubleLine(icon .. scale.label .. ": " .. Scales.FormatScore(ev.score), Scales.CompareText(ev), r, g, b, 1, 1, 1)
    return true
end

-- Équipement, talents ou compétences qui changent : valeurs et superpositions à revoir
local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_LEVEL_UP", "SKILL_LINES_CHANGED", "LEARNED_SPELL_IN_TAB", "PLAYER_EQUIPMENT_CHANGED" }) do
    pcall(ev.RegisterEvent, ev, e)
end
local queued = false
ev:SetScript("OnEvent", function(_, e)
    if e ~= "PLAYER_EQUIPMENT_CHANGED" then Scales.ClearCache() end
    -- Montée de niveau : plusieurs évènements à la suite → un seul rafraîchissement
    if queued then return end
    queued = true
    C_Timer.After(0.3, function()
        queued = false
        if FC.RefreshScaleOverlays then FC:RefreshScaleOverlays() end
    end)
end)
