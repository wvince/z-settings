local _, W = ...
-- Only the selected locale file installs a dictionary. English uses source text.
function W.Locale()
  local locale = GetLocale and GetLocale() or "enUS"
  return locale == "enGB" and "enUS" or locale
end
-- Game-owned names come from the current client, never translated by the addon.
function W.FavorName()
  local info = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(3402)
  return info and info.name and info.name ~= "" and info.name or "Merchant's Favor"
end
local areas = { ["Alterac Mountains"]=36, ["Arathi Highlands"]=45, Ashenvale=331,
  Duskwood=10, ["Hillsbrad Foothills"]=267, ["Stonetalon Mountains"]=406,
  ["Stranglethorn Vale"]=33, ["Thousand Needles"]=400 }
local globals = {Common="ITEM_QUALITY1_DESC", Uncommon="ITEM_QUALITY2_DESC",
  Apprentice="PROFESSIONS_RANK_1", Journeyman="PROFESSIONS_RANK_2",
  Expert="PROFESSIONS_RANK_3", Artisan="PROFESSIONS_RANK_4"}
for rank, name in ipairs({"Hated","Hostile","Unfriendly","Neutral","Friendly","Honored","Revered","Exalted"}) do
  globals[name] = "FACTION_STANDING_LABEL" .. rank
end
function W.GameName(name)
  if globals[name] then return _G[globals[name]] or name end
  local getArea = C_Map and C_Map.GetAreaInfo or GetAreaInfo
  if areas[name] then return getArea and getArea(areas[name]) or name end
end
function W.NativeText(text)
  if type(text) ~= "string" then return text end
  local favor
  return (text:gsub("{favor}", function() favor = favor or W.FavorName(); return favor end)
    :gsub("{game:([^}]+)}", function(name) return W.GameName(name) or name end))
end
local function sourceTemplate(text)
  return (text:gsub("Merchant's Favor", "{favor}"):gsub("Merchant Favor", "{favor}"):gsub("Favor", "{favor}")
    :gsub("^Common", "{game:Common}"):gsub("^Uncommon", "{game:Uncommon}"):gsub("^Exalted", "{game:Exalted}"))
end
local function template(text)
  if W.GameName(text) then return W.GameName(text) end
  return W.dictionary and W.dictionary[text] or sourceTemplate(text)
end
function W.L(phrase, ...)
  local text = template(phrase)
  if select("#", ...) > 0 then text = string.format(text, ...) end
  return W.NativeText(text)
end
-- Translate complete display templates after their values have been inserted.
-- This keeps catalog keys, frame names, saved preferences and AH queries intact.
local patterns
function W.SafeText(value)
  if type(value) ~= "string" or W.Locale() ~= "ruRU" then return value end
  return (value:gsub("≈", "~"):gsub("·", "-"):gsub(" | ", " - "):gsub("×", "x")
    :gsub("—", "-"):gsub("…", "..."):gsub("\194\160", " "))
end
function W.Text(value, ...)
  if select("#", ...) > 0 then
    local args = {...}
    for i = 1, select("#", ...) do
      if type(args[i]) == "string" then args[i] = W.Text(args[i]) end
    end
    return W.SafeText(W.NativeText(string.format(template(value), unpack(args, 1, select("#", ...)))))
  end
  if type(value) ~= "string" then return value end
  if W.GameName(value) then return W.GameName(value) end
  if W.Locale() == "enUS" then return W.NativeText(sourceTemplate(value)) end
  local dictionary = W.dictionary
  if not dictionary then return W.SafeText(W.NativeText(sourceTemplate(value))) end
  if not patterns then
    patterns = {}
    for key in pairs(dictionary) do
      if key:find("%%[dsf]") or key:find("%%%.%df") then
        local types = {}
        -- Lua patterns do not have optional groups; tokenize format specifiers.
        local pieces, pos = {}, 1
        while true do
          local first, last, spec = key:find("(%%[%d%.]*[dsf])", pos)
          if not first then
            pieces[#pieces + 1] = key:sub(pos):gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1"); break
          end
          pieces[#pieces + 1] = key:sub(pos, first - 1):gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
          pieces[#pieces + 1] = spec:sub(-1) == "s" and "(.-)" or "([%d%.%-]+)"
          types[#types + 1] = spec:sub(-1); pos = last + 1
        end
        patterns[#patterns + 1] = {key = key, pattern = "^" .. table.concat(pieces) .. "$", types = types,
          prefix = key:sub(1, key:find("%", 1, true) - 1)}
      end
    end
    table.sort(patterns, function(a, b) return #a.key > #b.key end)
  end
  local function translate(text, depth)
    if W.GameName(text) then return W.GameName(text) end
    if dictionary[text] then return dictionary[text] end
    if depth > 4 then return text end
    local texture, body = text:match("^(|T.-|t%s+)(.+)$")
    if texture then return texture .. translate(body, depth + 1) end
    for _, entry in ipairs(patterns) do
      -- Reject literal prefixes cheaply; allocate captures only after a match.
      local captures
      if text:sub(1, #entry.prefix) == entry.prefix and text:match(entry.pattern) ~= nil then
        captures = {text:match(entry.pattern)}
      end
      if captures then
        for i, kind in ipairs(entry.types) do
          captures[i] = kind == "s" and translate(captures[i], depth + 1) or tonumber(captures[i])
        end
        local ok, result = pcall(string.format, dictionary[entry.key] or entry.key, unpack(captures))
        if ok then return result end
      end
    end
    local indent, content = text:match("^([ \t]+)(%S.*)$")
    if indent then return indent .. translate(content, depth + 1) end
    local colored = text:gsub("(|c%x%x%x%x%x%x%x%x)(.-)(|r)", function(code, inside, reset)
      return code .. translate(inside, depth + 1) .. reset
    end)
    -- Separators join independent complete phrases such as a reward and goods.
    if colored:find(" · ", 1, true) then
      local parts, pos = {}, 1
      while true do
        local first, last = colored:find(" · ", pos, true)
        parts[#parts + 1] = translate(colored:sub(pos, first and first - 1 or #colored), depth + 1)
        if not first then break end
        pos = last + 1
      end
      return table.concat(parts, " · ")
    end
    return colored
  end
  return W.SafeText(W.NativeText(translate(value, 0)))
end
W.itemIDs, W.ordersByID = {}, {}
for _, order in ipairs(WaylaidCostCrates) do
  W.itemIDs[order.name] = order.itemID
  W.ordersByID[order.itemID] = order
  for _, bundle in ipairs(order.bundles) do W.itemIDs[bundle[2]] = bundle[3] end
end
for _, order in ipairs(WaylaidCostWrits) do
  W.itemIDs[order.name] = order.itemID
  W.itemIDs[order.bundles[1][2]] = order.requiredItemID
  W.ordersByID[order.itemID] = order
end
function W.LocalItemName(name)
  local id = W.itemIDs[name]
  local getInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
  local localized = id and getInfo and getInfo(id)
  if type(localized) == "string" and localized ~= "" then return localized end
  if W.Locale() == "enUS" then return name end
end
function W.ItemLabel(name)
  return W.LocalItemName(name) or name
end
function W.SnapshotLocaleMatches(saved)
  -- Old name-keyed snapshots were produced by English-only scans.
  return (saved.locale or "enUS") == W.Locale()
end
