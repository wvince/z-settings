--=====================================================================================================================
--
--  InterfacePanelLib-1.0  ("IPL")
--
--  A single-file, shareable library that wraps the modern WoW Settings API (Blizzard_Settings_Shared) so ANY addon
--  can build an Interface Options panel with one-line calls instead of the clunky, poorly documented default flow.
--
--  Widget coverage (everything defined in Blizzard_SettingControls.lua / Blizzard_Settings.lua / Blizzard_Setting.lua):
--      * Vertical layout categories + subcategories            Panel:CreateCategory / Panel:CreateSubcategory
--      * Canvas layout categories + subcategories              Panel:CreateCanvasCategory / Panel:CreateCanvasSubcategory
--      * Section headers                                       Panel:CreateHeader
--      * Expandable (collapsible) sections                     Panel:CreateExpandableSection
--      * Checkboxes (addon variable, CVar, or proxy)           Panel:CreateCheckbox
--      * Sliders with unit formatters (GB, MB, ms, %, ...)     Panel:CreateSlider
--      * Dropdowns with unit formatters                        Panel:CreateDropdown
--      * Checkbox + Slider combo rows                          Panel:CreateCheckboxSlider
--      * Checkbox + Dropdown combo rows                        Panel:CreateCheckboxDropdown
--      * Checkbox + Button combo rows                          Panel:CreateCheckboxButton
--      * Buttons                                               Panel:CreateButton
--      * Color swatches                                        Panel:CreateColorSwatch
--      * Checkbox + Color swatch combo rows                    Panel:CreateCheckboxColorSwatch
--      * Modified-click dropdowns (SELFCAST-style bindings)    Panel:CreateModifiedClickDropdown
--      * Dependencies / show-hide / enable-disable predicates  Options.Parent / ShownIf / EnabledIf (any widget)
--
--  Every value-holding widget supports these flags (see COMMON WIDGET OPTIONS below):
--      IsCVar      - the value lives in a game CVar instead of your saved-variables table
--      UseDefault  - what the panel's "Defaults" button resets to: "addon" (your Default) or "game" (the CVar's
--                    game-defined default; CVar widgets only)
--      IsSpecial   - marks a widget as needing supporting code elsewhere (event handlers, apply-on-login, etc.,
--                    like the Display Pet option in Hyperframe); the library indexes these for you
--
--
--  INSTALLATION
--  ------------
--  Option A (standalone library addon, recommended):
--      Keep this folder ("InterfacePanelLib") in Interface\AddOns and add it to your addon's TOC:
--          ## Dependencies: InterfacePanelLib
--      Your users install the library once and every addon that declares the dependency shares it.
--
--  Option B (embedded — ship the library inside your addon, no separate download for users):
--      1. Copy ONLY InterfacePanelLib-1.0.lua into your addon's folder (a "Libs" subfolder keeps things
--         tidy). Do NOT copy InterfacePanelLib.toc — embedded copies must not be their own addon.
--
--      2. List the file in your TOC BEFORE any of your files that use the library:
--             ## Title: MyAddon
--             ## SavedVariables: MyAddonDB
--
--             Libs\InterfacePanelLib-1.0.lua
--             MyAddonSettings.lua
--         Do NOT add "## Dependencies: InterfacePanelLib" — that would still force users to install
--         the standalone addon, defeating the point of embedding.
--
--      3. (Recommended) Also add:
--             ## OptionalDeps: InterfacePanelLib
--         This makes the game load a standalone copy of the library FIRST when one happens to be
--         installed, so the version guard below can pick the newest copy without load-order luck.
--
--      4. Use the library exactly as documented in this file. Nothing else changes: the library still
--         publishes itself as the global "InterfacePanelLib", and you call InterfacePanelLib:RegisterAddon
--         the same way in both installation modes.
--
--      How multiple embedded copies coexist (the version guard, top of this file):
--         Every copy checks the global before loading. If a same-or-newer LIBRARY_VERSION is already
--         loaded (from another addon's embedded copy or the standalone addon), the file returns
--         immediately and the loaded copy serves every addon. Only a strictly newer copy replaces it —
--         the registry (InterfacePanelLib.Addons) is carried over, so already-registered panels survive.
--         Never edit your embedded copy in place; if you need newer features, replace the whole file
--         with the newer release so LIBRARY_VERSION stays truthful.
--
--
--  REGISTRY LAYOUT (how widgets are stored, browsable per addon)
--  -------------------------------------------------------------
--      InterfacePanelLib.Addons["MyAddon"] = {
--          AddonName        = "MyAddon",
--          SettingsTable    = <your saved-variables table>,
--          Categories       = { [name] = {Category=, Layout=, Parent=, IsCanvas=} },
--          Headers          = { [key]  = {Initializer=, ...} },
--          Sections         = { [key]  = <section handle> },
--          Checkboxes       = { [key]  = {Initializer=, Setting=, Options=} },
--          Sliders          = { [key]  = {Initializer=, Setting=, Options=} },
--          Dropdowns        = { [key]  = {Initializer=, Setting=, Options=} },
--          CheckboxSliders  = { [key]  = {Initializer=, CheckboxSetting=, SliderSetting=, Options=} },
--          CheckboxDropdowns= { [key]  = {Initializer=, CheckboxSetting=, DropdownSetting=, Options=} },
--          CheckboxButtons  = { [key]  = {Initializer=, Setting=, Options=} },
--          Buttons          = { [key]  = {Initializer=, Options=} },
--          ColorSwatches    = { [key]  = {Initializer=, Setting=, Options=} },
--          ModifiedClicks   = { [key]  = {Initializer=, Setting=, Options=} },
--          Settings         = { [key]  = <setting object> },        -- every registered setting, by Variable key
--          SpecialWidgets   = { [key]  = <widget record> },         -- every widget created with IsSpecial = true
--      }
--
--  "key" is the widget's Variable (or a name-derived key for buttons/headers), so you can always look a widget up:
--      local record = InterfacePanelLib.Addons["MyAddon"].Sliders["CacheSize"]
--
--
--  QUICK START — BUILDING A PANEL FROM START TO FINISH
--  ----------------------------------------------------
--      -- STEP 0: TOC file
--      --   ## SavedVariables: MyAddonDB
--      --   ## Dependencies: InterfacePanelLib        (or list the embedded lua file before this one)
--
--      -- STEP 1: Wait for your saved variables, then register your addon with the library.
--      local frame = CreateFrame("Frame")
--      frame:RegisterEvent("ADDON_LOADED")
--      frame:SetScript("OnEvent", function(_, _, addonName)
--          if addonName ~= "MyAddon" then return end
--          MyAddonDB = MyAddonDB or {}
--
--          local Panel = InterfacePanelLib:RegisterAddon("MyAddon", MyAddonDB)
--
--          -- STEP 2: Create the top-level category (this is what appears in the AddOns list of the options window).
--          local Category = Panel:CreateCategory({ Name = "My Addon" })
--
--          -- STEP 3: Add widgets, top to bottom, in the order you want them to appear.
--          Panel:CreateHeader({ Category = Category, Name = "General" })
--
--          Panel:CreateCheckbox({
--              Category = Category,
--              Name     = "Enable Awesome Mode",
--              Variable = "AwesomeMode",           -- key in MyAddonDB
--              Default  = true,
--              Tooltip  = "Turns on awesome mode.",
--              OnChanged = function(setting, value) print("Awesome:", value) end,
--          })
--
--          Panel:CreateSlider({
--              Category = Category,
--              Name     = "Cache Size",
--              Variable = "CacheSize",
--              Default  = 64 * 1024 * 1024,        -- stored raw (bytes)
--              Min      = 16 * 1024 * 1024,
--              Max      = 512 * 1024 * 1024,
--              Step     = 16 * 1024 * 1024,
--              Format      = "MB",                 -- label shows "64 MB"
--              FormatScale = 1024 * 1024,          -- raw value divided by this for display
--          })
--
--          Panel:CreateDropdown({
--              Category = Category,
--              Name     = "Update Interval",
--              Variable = "UpdateInterval",
--              Default  = 250,
--              Options  = { 100, 250, 500, 1000 },
--              Format   = "ms",                    -- entries display as "100 ms", "250 ms", ...
--          })
--
--          -- STEP 4 (optional): subcategories, CVar widgets, combos, buttons — see each section below.
--          local Sub = Panel:CreateSubcategory({ Parent = Category, Name = "Advanced" })
--          Panel:CreateButton({
--              Category   = Sub,
--              Name       = "Maintenance",
--              ButtonText = "Reset Statistics",
--              OnClick    = function() wipe(MyAddonDB.Stats) end,
--          })
--
--          -- STEP 5 (optional): re-fire every OnChanged once on login so saved values get applied to the game.
--          Panel:ApplyAll()
--      end)
--
--      -- Open your panel from a slash command:  Panel:Open()
--
--
--  COMMON WIDGET OPTIONS (accepted by every value widget: checkbox, slider, dropdown, combos, color swatch)
--  --------------------------------------------------------------------------------------------------------
--      Category    (table)     REQUIRED. Category/subcategory object from CreateCategory/CreateSubcategory.
--      Name        (string)    REQUIRED. The label displayed in the panel.
--      Variable    (string)    REQUIRED. Key in your saved-variables table; also the registry lookup key.
--                              (Internally the library prefixes it "IPL_<AddonName>_" so it is globally unique,
--                              as the Settings API requires. Your saved-variables key is NOT prefixed.)
--      Default     (any)       The addon-defined default value. Written into your table for brand-new users and
--                              used by the "Defaults" button when UseDefault = "addon".
--      Type        (string)    "boolean" | "number" | "string". Only needed when it can't be inferred from Default
--                              (e.g. a CVar widget with UseDefault = "game" and no Default given).
--      Tooltip     (string)    Tooltip shown on mouseover.
--      OnChanged   (function)  function(setting, value) — fired whenever the value changes (user, Defaults button,
--                              or code). Do your "apply it to the game" work here.
--      Table       (table)     Override the saved-variables table for this one widget (defaults to the table you
--                              passed to RegisterAddon).
--
--      IsCVar      (boolean)   The value lives in a game CVar. Set CVar = "cvarName" (falls back to Variable).
--                              The library reads/writes the CVar directly with correctly typed accessors, and
--                              registers under a unique prefixed variable so it never collides with the game's
--                              own registration of the same CVar.
--      CVar        (string)    The CVar name (only used with IsCVar).
--      UseDefault  (string)    What the panel's "Defaults" button resets this widget to:
--                                  "addon" — your Default value (works for CVar and non-CVar widgets)
--                                  "game"  — the CVar's game-defined default via C_CVar.GetCVarDefault()
--                                            (CVar widgets only; this is the default for IsCVar widgets)
--                              Non-CVar widgets always use "addon".
--      IsSpecial   (boolean)   Marks the widget as needing supporting code elsewhere in your addon (event
--                              handlers, login application, other frames — e.g. Hyperframe's Display Pet option).
--                              The setting object gets .IPL_IsSpecial = true and the widget record is added to
--                              Panel.SpecialWidgets so you can iterate them:
--                                  for key, record in pairs(InterfacePanelLib.Addons["MyAddon"].SpecialWidgets) do ... end
--
--      GetValue    (function)  } Provide BOTH to make the widget a full proxy: the library stores nothing and
--      SetValue    (function)  } your functions are the source of truth. Default is still required.
--
--      Indent      (boolean)   Indent the row (visually nests it under the row above).
--      Parent      (initializer) Another widget's initializer; this row indents and greys out unless the parent
--                              checkbox is checked. (Implemented as Indent + a modify predicate, NOT Blizzard's
--                              SetParentInitializer — see TAINT WARNING. The child row keeps the normal font size.)
--      ParentPredicate (function) Optional custom predicate for Parent (default: parent checkbox is true).
--      ShownIf     (function)  Row is only shown while this returns true.
--      EnabledIf   (function)  Row is only interactable while this returns true.
--      Section     (handle)    A section handle from CreateExpandableSection; the row hides while collapsed.
--      SearchTags  (table)     IGNORED since v3 (see TAINT WARNING). Kept so existing calls don't error.
--
--      TAINT WARNING (12.1+): the Options search box loops over every addon's initializers without protection.
--      Anything that search reads which addon code wrote taints that search, and the Social panel's Discord row then
--      throws ADDON_ACTION_FORBIDDEN for C_Discord.IsUserOAuthed() (Stanzilla/WoWUIBugs#873). What the library does
--      about it:
--        * Search tags are only ever added by Blizzard's secure registration path (a setting's own Name), never by
--          addon code. So Buttons, CheckboxSlider rows, and SearchTags don't add keywords: buttons and checkbox+slider
--          rows don't appear in search; checkbox+button rows are still found by their checkbox Name.
--        * Parent is emulated (the search reads initializer.parentInitializer on every matching row).
--        * STILL UNSAFE, avoid where possible: ShownIf and Section. The search calls every row's shown-predicates,
--          so an addon predicate taints EVERY search. Prefer EnabledIf (greys the row; the search never calls it).
--
--
--  FORMATTERS (sliders and dropdowns)
--  ----------------------------------
--      Format      (string|function)
--                      A unit suffix appended to the displayed number: "GB", "MB", "KB", "ms", "s", "fps",
--                      "Frames", "px" — any string works. "%" is appended without a space.
--                      Or a function(rawValue, scaledValue) -> string for full custom control.
--      FormatScale (number)    Divide the RAW stored value by this before display. Store bytes, show MB:
--                              FormatScale = 1024*1024. Display only — the stored value stays raw.
--      Decimals    (number)    Decimal places for the displayed number (default 0).
--      ValueLabels (table)     Raw-value -> label overrides checked before the formatter, e.g.
--                              ValueLabels = { [0] = "Disabled", [1] = "1 Frame" }.
--
--=====================================================================================================================



--=====================================================================================================================
-- LIBRARY INITIALIZATION (version-guarded so embedded copies coexist; newest version wins)
--=====================================================================================================================

-- 2: CreateButton no longer taints Options search.
-- 3: CheckboxSlider / CheckboxButton / SearchTags / Parent no longer taint Options search.
local LIBRARY_ID, LIBRARY_VERSION = "InterfacePanelLib-1.0", 3

local globalEnv = _G or getfenv(0)
local existing = globalEnv[LIBRARY_ID]
if existing and (existing.Version or 0) >= LIBRARY_VERSION then
    return -- A same-or-newer copy is already loaded.
end

local IPL = existing or {}
globalEnv[LIBRARY_ID]          = IPL
globalEnv["InterfacePanelLib"] = IPL
globalEnv["IPL"]               = IPL

IPL.Version = LIBRARY_VERSION
IPL.Addons  = IPL.Addons or {}   -- [AddonName] = panel handle (see REGISTRY LAYOUT above)



--=====================================================================================================================
-- INTERNAL HELPERS (not part of the public API)
--=====================================================================================================================

local VarType = {
    Boolean = Settings.VarType.Boolean,
    Number  = Settings.VarType.Number,
    String  = Settings.VarType.String,
}

-- Round a number to N decimal places.
local function Round(value, decimals)
    local multiplier = 10 ^ (decimals or 0)
    return math.floor(value * multiplier + 0.5) / multiplier
end

-- Strip whitespace from a string so it can be used as a table key / variable id.
local function MakeKey(text)
    return (text:gsub("%s+", ""))
end

-- Globally unique variable id required by the Settings API (your saved-variables key stays un-prefixed).
local function UniqueVariable(handle, key)
    return "IPL_" .. handle.AddonName .. "_" .. key
end

local function IPLError(func, message)
    error("[InterfacePanelLib:" .. func .. "]: " .. message, 3)
end

-- Resolve the setting's value type: explicit Options.Type wins, then the type of Default.
local function ResolveVarType(func, Options, fallback)
    if Options.Type then
        if Options.Type ~= "boolean" and Options.Type ~= "number" and Options.Type ~= "string" then
            IPLError(func, "'Type' must be \"boolean\", \"number\", or \"string\".")
        end
        return Options.Type
    end
    if Options.Default ~= nil then
        return type(Options.Default)
    end
    if fallback then
        return fallback
    end
    IPLError(func, "Cannot infer value type: provide 'Default' or 'Type'.")
end

-- Typed read/write closures for a CVar (booleans and numbers converted properly; CVars store strings).
local function CreateCVarAccessors(cvar, varType)
    if varType == VarType.Boolean then
        return function() return C_CVar.GetCVarBool(cvar) end,
               function(value) C_CVar.SetCVar(cvar, value and "1" or "0") end
    elseif varType == VarType.Number then
        return function() return tonumber(C_CVar.GetCVar(cvar)) or 0 end,
               function(value) C_CVar.SetCVar(cvar, tostring(value)) end
    else
        return function() return C_CVar.GetCVar(cvar) or "" end,
               function(value) C_CVar.SetCVar(cvar, tostring(value)) end
    end
end

-- The game-defined default of a CVar, converted to the setting's value type (UseDefault = "game").
local function GetCVarGameDefault(cvar, varType)
    local raw = C_CVar.GetCVarDefault(cvar)
    if varType == VarType.Boolean then
        return raw ~= nil and raw ~= "0"
    elseif varType == VarType.Number then
        return tonumber(raw) or 0
    end
    return raw or ""
end

-- Build a value -> display-text function from the FORMATTERS options (see header). Shared by sliders and dropdowns.
local function BuildValueFormatter(Options)
    local Format      = Options.Format
    local FormatScale = Options.FormatScale or 1
    local Decimals    = Options.Decimals or 0
    local ValueLabels = Options.ValueLabels

    return function(value)
        if ValueLabels and ValueLabels[value] ~= nil then
            return ValueLabels[value]
        end
        local display = value / FormatScale
        if type(Format) == "function" then
            return Format(value, display)
        end
        local text
        if Decimals > 0 then
            text = string.format("%." .. Decimals .. "f", display)
        else
            text = string.format("%d", Round(display))
        end
        if Format == "%" then
            return text .. "%"
        elseif Format then
            return text .. " " .. Format
        end
        return text
    end
end

-- Find the layout object for a category (needed to add raw initializers: headers, buttons, combo rows).
local function GetLayout(handle, category)
    for _, record in pairs(handle.Categories) do
        if record.Category == category then
            return record.Layout
        end
    end
    return SettingsPanel:GetLayout(category)
end

-- Register the underlying "setting" object for a value widget, honoring IsCVar / UseDefault / GetValue / SetValue.
-- Returns setting, key. This is where all three storage backends converge:
--   1. CVar widgets      -> proxy setting over typed CVar accessors (unique variable, never collides with the
--                           game's own registration of that CVar). Default source picked by UseDefault.
--   2. Proxy widgets     -> your own GetValue/SetValue functions.
--   3. Addon widgets     -> Settings.RegisterAddOnSetting stores the value in your saved-variables table and
--                           seeds the key with Default for brand-new users.
local function RegisterSetting(func, handle, Options, fallbackType)
    if type(Options) ~= "table" then
        IPLError(func, "Expected a single Options table argument.")
    end
    if type(Options.Category) ~= "table" then
        IPLError(func, "'Category' is required (create one with CreateCategory / CreateSubcategory).")
    end
    if type(Options.Name) ~= "string" then
        IPLError(func, "'Name' is required and must be a string.")
    end

    local key = Options.Variable or Options.CVar or MakeKey(Options.Name)
    if handle.Settings[key] then
        IPLError(func, "A widget with Variable '" .. key .. "' is already registered for " .. handle.AddonName .. ".")
    end

    local varType  = ResolveVarType(func, Options, fallbackType)
    local variable = UniqueVariable(handle, key)
    local setting

    if Options.IsCVar then
        local cvar = Options.CVar or Options.Variable
        if type(cvar) ~= "string" then
            IPLError(func, "IsCVar widgets need 'CVar' (or 'Variable') set to the CVar name.")
        end
        local defaultValue
        if Options.UseDefault == "addon" then
            if Options.Default == nil then
                IPLError(func, "UseDefault=\"addon\" requires a 'Default' value.")
            end
            defaultValue = Options.Default
        else -- "game" (the default for CVar widgets)
            defaultValue = GetCVarGameDefault(cvar, varType)
        end
        local getValue, setValue = CreateCVarAccessors(cvar, varType)
        setting = Settings.RegisterProxySetting(Options.Category, variable, varType, Options.Name, defaultValue, getValue, setValue)

    elseif Options.GetValue or Options.SetValue then
        if type(Options.GetValue) ~= "function" or type(Options.SetValue) ~= "function" then
            IPLError(func, "Proxy widgets need BOTH 'GetValue' and 'SetValue' functions.")
        end
        if Options.Default == nil then
            IPLError(func, "Proxy widgets need a 'Default' value.")
        end
        setting = Settings.RegisterProxySetting(Options.Category, variable, varType, Options.Name, Options.Default, Options.GetValue, Options.SetValue)

    else
        local tbl = Options.Table or handle.SettingsTable
        if type(tbl) ~= "table" then
            IPLError(func, "No saved-variables table: pass one to RegisterAddon or set Options.Table.")
        end
        if Options.Default == nil then
            IPLError(func, "'Default' is required for addon-stored widgets.")
        end
        -- RegisterAddOnSetting seeds tbl[key] = Default when the key is unset (new users) and the
        -- panel's "Defaults" button resets to Default — i.e. UseDefault = "addon" behavior.
        setting = Settings.RegisterAddOnSetting(Options.Category, variable, key, tbl, varType, Options.Name, Options.Default)
    end

    if Options.IsSpecial then
        setting.IPL_IsSpecial = true
    end

    if Options.OnChanged then
        if type(Options.OnChanged) ~= "function" then
            IPLError(func, "'OnChanged' must be a function.")
        end
        -- Reading back from the setting avoids the Settings callback-registry argument-order pitfalls.
        setting:SetValueChangedCallback(function()
            Options.OnChanged(setting, setting:GetValue())
        end)
    end

    handle.Settings[key] = setting
    return setting, key
end

-- Apply layout/behavior options shared by every row: Indent, Parent, ShownIf, EnabledIf, Section, SearchTags.
local function ApplyInitializerOptions(initializer, Options)
    -- Options.SearchTags is deliberately ignored: AddSearchTags from addon code taints the Options search.
    if Options.ShownIf then
        initializer:AddShownPredicate(Options.ShownIf)
    end
    if Options.EnabledIf then
        initializer:AddModifyPredicate(Options.EnabledIf)
    end
    if Options.Parent then
        -- Emulated instead of SetParentInitializer: the search reads initializer.parentInitializer on matching
        -- rows, and ours would be addon-written (tainted). Modify predicates are only read when the row itself is
        -- initialized, inside Blizzard's per-row protection. Any setting change repaints the list, so this
        -- re-evaluates live when the parent is toggled.
        local parent = Options.Parent
        local predicate = Options.ParentPredicate or function()
            local data = parent.data
            local setting = data and (data.setting or data.cbSetting)
            return setting ~= nil and setting:GetValue() == true
        end
        initializer:AddModifyPredicate(predicate)
        if initializer.Indent then
            initializer:Indent()
        end
    end
    if Options.Section and Options.Section.AddChild then
        Options.Section:AddChild(initializer)
    end
    if Options.Indent and initializer.Indent then
        initializer:Indent()
    end
end

-- Store a widget record in the per-addon registry (and in SpecialWidgets when flagged).
local function StoreWidget(handle, kind, key, record)
    handle[kind][key] = record
    if record.Options and record.Options.IsSpecial then
        handle.SpecialWidgets[key] = record
    end
    return record
end



--=====================================================================================================================
-- ADDON REGISTRATION
--=====================================================================================================================

local PanelHandle = {}
PanelHandle.__index = PanelHandle

--[[-------------------------------------------------------------------------------------------------------------------
    InterfacePanelLib:RegisterAddon(AddonName, SettingsTable) -> Panel

    The entry point. Call once per addon (after your SavedVariables have loaded), then create everything through
    the returned Panel handle. Calling it again for the same addon returns the existing handle.

        AddonName     (string)  Your addon's name; becomes the namespace key in InterfacePanelLib.Addons.
        SettingsTable (table)   Your SavedVariables table — where addon-stored widget values live.
                                Optional if every widget is IsCVar/proxy or sets its own Options.Table.

    Example:
        MyAddonDB = MyAddonDB or {}
        local Panel = InterfacePanelLib:RegisterAddon("MyAddon", MyAddonDB)
]]---------------------------------------------------------------------------------------------------------------------
function IPL:RegisterAddon(AddonName, SettingsTable)
    if type(AddonName) ~= "string" then
        IPLError("RegisterAddon", "'AddonName' must be a string.")
    end
    if SettingsTable ~= nil and type(SettingsTable) ~= "table" then
        IPLError("RegisterAddon", "'SettingsTable' must be a table when provided.")
    end

    local handle = self.Addons[AddonName]
    if handle then
        handle.SettingsTable = SettingsTable or handle.SettingsTable
        return handle
    end

    handle = setmetatable({
        AddonName         = AddonName,
        SettingsTable     = SettingsTable,
        Categories        = {},
        Headers           = {},
        Sections          = {},
        Checkboxes        = {},
        Sliders           = {},
        Dropdowns         = {},
        CheckboxSliders   = {},
        CheckboxDropdowns = {},
        CheckboxButtons   = {},
        Buttons           = {},
        ColorSwatches     = {},
        ModifiedClicks    = {},
        Settings          = {},
        SpecialWidgets    = {},
        PrimaryCategory   = nil,
    }, PanelHandle)

    self.Addons[AddonName] = handle
    return handle
end

--[[-------------------------------------------------------------------------------------------------------------------
    InterfacePanelLib:GetAddon(AddonName) -> Panel or nil

    Fetch a previously registered Panel handle (e.g. from another file of your addon).
]]---------------------------------------------------------------------------------------------------------------------
function IPL:GetAddon(AddonName)
    return self.Addons[AddonName]
end



--=====================================================================================================================
-- CATEGORIES — vertical layout panels (the standard settings list)
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateCategory(Options) -> Category, Layout

    Creates the top-level entry in the options window's AddOns list. Do this FIRST — every widget needs a Category.

        Name (string)  REQUIRED. The name shown in the AddOns category list (usually your addon's name).

    Example:
        local Category = Panel:CreateCategory({ Name = "My Addon" })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateCategory(Options)
    if type(Options) ~= "table" or type(Options.Name) ~= "string" then
        IPLError("CreateCategory", "'Name' is required and must be a string.")
    end

    local Category, Layout = Settings.RegisterVerticalLayoutCategory(Options.Name)
    Settings.RegisterAddOnCategory(Category)

    self.Categories[Options.Name] = { Category = Category, Layout = Layout }
    self.PrimaryCategory = self.PrimaryCategory or Category
    return Category, Layout
end

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateSubcategory(Options) -> Subcategory, Layout

    A nested page under an existing category (appears as an expandable child in the category list).

        Parent (table)   REQUIRED. The Category returned by CreateCategory.
        Name   (string)  REQUIRED. The subcategory's display name.

    Example:
        local Sub = Panel:CreateSubcategory({ Parent = Category, Name = "Advanced" })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateSubcategory(Options)
    if type(Options) ~= "table" or type(Options.Parent) ~= "table" or type(Options.Name) ~= "string" then
        IPLError("CreateSubcategory", "'Parent' (category table) and 'Name' (string) are required.")
    end

    local Subcategory, Layout = Settings.RegisterVerticalLayoutSubcategory(Options.Parent, Options.Name)
    self.Categories[Options.Name] = { Category = Subcategory, Layout = Layout, Parent = Options.Parent }
    return Subcategory, Layout
end



--=====================================================================================================================
-- CANVAS PANELS — the "other" panel type: a blank frame you draw anything on (custom art, previews, own widgets)
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateCanvasCategory(Options) -> Category

    Instead of a vertical list of standard rows, the settings panel displays YOUR frame. You own everything on it.
    Build the frame first (hidden, unparented is fine); the panel shows and sizes it into the canvas area.

        Name  (string)  REQUIRED. The name shown in the AddOns category list.
        Frame (frame)   REQUIRED. Your frame. Anchor children to it; it fills the settings panel's content area.

    Example:
        local canvas = CreateFrame("Frame")
        local title = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -10)
        title:SetText("My Custom Panel")
        local Category = Panel:CreateCanvasCategory({ Name = "My Addon", Frame = canvas })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateCanvasCategory(Options)
    if type(Options) ~= "table" or type(Options.Name) ~= "string" or type(Options.Frame) ~= "table" then
        IPLError("CreateCanvasCategory", "'Name' (string) and 'Frame' (frame) are required.")
    end

    local Category, Layout = Settings.RegisterCanvasLayoutCategory(Options.Frame, Options.Name)
    Settings.RegisterAddOnCategory(Category)

    self.Categories[Options.Name] = { Category = Category, Layout = Layout, IsCanvas = true, Frame = Options.Frame }
    self.PrimaryCategory = self.PrimaryCategory or Category
    return Category
end

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateCanvasSubcategory(Options) -> Subcategory

    A canvas page nested under an existing category. Great for a custom "About"/preview page below a normal
    vertical-list category.

        Parent (table)   REQUIRED. The Category returned by CreateCategory / CreateCanvasCategory.
        Name   (string)  REQUIRED. Display name.
        Frame  (frame)   REQUIRED. Your frame.

    Example:
        local Sub = Panel:CreateCanvasSubcategory({ Parent = Category, Name = "Profile Preview", Frame = myFrame })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateCanvasSubcategory(Options)
    if type(Options) ~= "table" or type(Options.Parent) ~= "table" or type(Options.Name) ~= "string" or type(Options.Frame) ~= "table" then
        IPLError("CreateCanvasSubcategory", "'Parent' (category), 'Name' (string), and 'Frame' (frame) are required.")
    end

    local Subcategory, Layout = Settings.RegisterCanvasLayoutSubcategory(Options.Parent, Options.Frame, Options.Name)
    self.Categories[Options.Name] = { Category = Subcategory, Layout = Layout, Parent = Options.Parent, IsCanvas = true, Frame = Options.Frame }
    return Subcategory
end



--=====================================================================================================================
-- HEADERS — bold section titles that divide a vertical-list panel
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateHeader(Options) -> Initializer

    Options:
        Category (table)   REQUIRED. Which panel the header goes on.
        Name     (string)  REQUIRED. Header text.
        Tooltip  (string)  Optional tooltip.

    Example:
        Panel:CreateHeader({ Category = Category, Name = "Performance", Tooltip = "Options that affect FPS." })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateHeader(Options)
    if type(Options) ~= "table" or type(Options.Category) ~= "table" or type(Options.Name) ~= "string" then
        IPLError("CreateHeader", "'Category' (table) and 'Name' (string) are required.")
    end

    local Initializer = CreateSettingsListSectionHeaderInitializer(Options.Name, Options.Tooltip)
    GetLayout(self, Options.Category):AddInitializer(Initializer)
    ApplyInitializerOptions(Initializer, Options)

    local key = MakeKey(Options.Name)
    StoreWidget(self, "Headers", key, { Initializer = Initializer, Options = Options })
    return Initializer
end



--=====================================================================================================================
-- EXPANDABLE SECTIONS — a clickable header that collapses/expands the rows placed inside it
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateExpandableSection(Options) -> Section

    Creates a collapsible section (starts collapsed). Add rows to it either by passing Section = <handle> in any
    widget's Options, or by calling Section:AddChild(initializer) with a widget's returned initializer.

        Category (table)   REQUIRED. Which panel the section goes on.
        Name     (string)  REQUIRED. The clickable section title.

    Example:
        local Section = Panel:CreateExpandableSection({ Category = Category, Name = "Expert Options" })
        Panel:CreateCheckbox({
            Category = Category,
            Section  = Section,                 -- hidden until the section is expanded
            Name     = "Verbose Logging",
            Variable = "VerboseLog",
            Default  = false,
        })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateExpandableSection(Options)
    if type(Options) ~= "table" or type(Options.Category) ~= "table" or type(Options.Name) ~= "string" then
        IPLError("CreateExpandableSection", "'Category' (table) and 'Name' (string) are required.")
    end

    local Initializer = CreateSettingsExpandableSectionInitializer(Options.Name)

    -- The stock template calls frame:OnExpandedChanged(expanded) when clicked, but only derived Blizzard
    -- templates implement it. Injecting a handler that repairs the display makes the base template usable
    -- and re-evaluates the ShownIf predicates AddChild installs below.
    local baseInitFrame = Initializer.InitFrame
    Initializer.InitFrame = function(initializer, frame)
        baseInitFrame(initializer, frame)
        frame.OnExpandedChanged = function()
            if SettingsInbound and SettingsInbound.RepairDisplay then
                SettingsInbound.RepairDisplay()
            end
        end
    end

    GetLayout(self, Options.Category):AddInitializer(Initializer)

    local Section = {
        Initializer = Initializer,
        Options     = Options,
    }
    function Section:AddChild(childInitializer)
        childInitializer:AddShownPredicate(function()
            return Initializer.data.expanded == true
        end)
        return childInitializer
    end
    function Section:IsExpanded()
        return Initializer.data.expanded == true
    end

    local key = MakeKey(Options.Name)
    StoreWidget(self, "Sections", key, Section)
    return Section
end



--=====================================================================================================================
-- CHECKBOXES — addon-variable, CVar ("CheckboxCVar"), or proxy; optional control options
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateCheckbox(Options) -> Initializer, Setting

    A standard on/off row. Supports every COMMON WIDGET OPTION (see file header): IsCVar, UseDefault, IsSpecial,
    Indent, Parent, ShownIf, EnabledIf, Section, SearchTags, GetValue/SetValue, ...

    Checkbox-specific:
        ControlOptions (any)  Rarely needed: passed to Settings.CreateCheckboxWithOptions for Blizzard's
                              "checkbox with options" control variant.

    Example — plain addon checkbox:
        Panel:CreateCheckbox({
            Category  = Category,
            Name      = "Enable Minimap Button",
            Variable  = "MinimapButton",
            Default   = true,
            Tooltip   = "Show the minimap button.",
            OnChanged = function(setting, value) MyAddon:ToggleMinimapButton(value) end,
        })

    Example — CVar checkbox whose "Defaults" button restores the GAME default:
        Panel:CreateCheckbox({
            Category   = Category,
            Name       = "Show Target Nameplate",
            IsCVar     = true,
            CVar       = "nameplateShowEnemies",
            UseDefault = "game",
        })

    Example — CVar checkbox that defaults to YOUR value instead of the game's, and is flagged special
    (needs extra code elsewhere, like Hyperframe's Display Pet option):
        Panel:CreateCheckbox({
            Category   = Category,
            Name       = "Display Pet",
            IsCVar     = true,
            CVar       = "showPet",
            UseDefault = "addon",
            Default    = false,
            IsSpecial  = true,
        })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateCheckbox(Options)
    local Setting, key = RegisterSetting("CreateCheckbox", self, Options, VarType.Boolean)

    local Initializer
    if Options.ControlOptions then
        Initializer = Settings.CreateCheckboxWithOptions(Options.Category, Setting, Options.ControlOptions, Options.Tooltip)
    else
        Initializer = Settings.CreateCheckbox(Options.Category, Setting, Options.Tooltip)
    end
    ApplyInitializerOptions(Initializer, Options)

    StoreWidget(self, "Checkboxes", key, { Initializer = Initializer, Setting = Setting, Options = Options })
    return Initializer, Setting
end



--=====================================================================================================================
-- SLIDERS — with unit formatters (GB, MB, ms, %, fps, ...) and per-value label overrides
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateSlider(Options) -> Initializer, Setting

    A numeric slider row. Supports every COMMON WIDGET OPTION and every FORMATTER option (see file header).

    Slider-specific:
        Min  (number)  REQUIRED. Minimum RAW value.
        Max  (number)  REQUIRED. Maximum RAW value.
        Step (number)  Step between values (default 1).

    Example — bytes stored raw, displayed as MB:
        Panel:CreateSlider({
            Category    = Category,
            Name        = "Cache Size",
            Variable    = "CacheSize",
            Default     = 64 * 1024 * 1024,
            Min         = 16 * 1024 * 1024,
            Max         = 1024 * 1024 * 1024,
            Step        = 16 * 1024 * 1024,
            Format      = "MB",
            FormatScale = 1024 * 1024,          -- 67108864 displays as "64 MB"
            Tooltip     = "Memory reserved for the cache.",
        })

    Example — milliseconds with a "Disabled" label at zero:
        Panel:CreateSlider({
            Category    = Category,
            Name        = "Async Timeout",
            Variable    = "AsyncTimeout",
            Default     = 250,
            Min = 0, Max = 2000, Step = 50,
            Format      = "ms",
            ValueLabels = { [0] = "Disabled" },
        })

    Example — CVar slider with decimals:
        Panel:CreateSlider({
            Category = Category,
            Name     = "Nameplate Scale",
            IsCVar   = true,
            CVar     = "nameplateGlobalScale",
            UseDefault = "game",
            Type     = "number",
            Min = 0.5, Max = 2.0, Step = 0.05,
            Decimals = 2,
            Format   = "x",
        })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateSlider(Options)
    if type(Options) ~= "table" or type(Options.Min) ~= "number" or type(Options.Max) ~= "number" then
        IPLError("CreateSlider", "'Min' and 'Max' are required numbers.")
    end

    local Setting, key = RegisterSetting("CreateSlider", self, Options, VarType.Number)

    local SliderOptions = Settings.CreateSliderOptions(Options.Min, Options.Max, Options.Step or 1)
    SliderOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, BuildValueFormatter(Options))

    local Initializer = Settings.CreateSlider(Options.Category, Setting, SliderOptions, Options.Tooltip)
    ApplyInitializerOptions(Initializer, Options)

    StoreWidget(self, "Sliders", key, { Initializer = Initializer, Setting = Setting, Options = Options })
    return Initializer, Setting
end



--=====================================================================================================================
-- DROPDOWNS — option lists with the same unit formatters ("1024" displays as "1024 MB" with zero effort)
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateDropdown(Options) -> Initializer, Setting

    A dropdown row. Supports every COMMON WIDGET OPTION and every FORMATTER option (formatters build each entry's
    display text from its raw value, so the SAVED value stays clean).

    Dropdown-specific:
        Options.Options (table|function)  REQUIRED. The dropdown entries. Three accepted shapes:
            1. Raw values:            { 512, 1024, 2048 }
               -> labels generated by the formatter ("512 MB", "1024 MB", ... with Format = "MB")
            2. Explicit entries:      { { Value = 1024, Label = "1 GB (recommended)", Tooltip = "..." }, ... }
               -> Label used verbatim when given; otherwise generated from Value by the formatter
            3. A function returning either shape (re-evaluated each time the dropdown opens — dynamic lists).

    Example — raw values with a unit suffix:
        Panel:CreateDropdown({
            Category = Category,
            Name     = "Buffer Size",
            Variable = "BufferSize",
            Default  = 1024,
            Options  = { 256, 512, 1024, 2048 },
            Format   = "MB",                      -- entries show "256 MB" ... saved value stays 256/512/...
        })

    Example — mixed explicit entries:
        Panel:CreateDropdown({
            Category = Category,
            Name     = "Loot Mode",
            Variable = "LootMode",
            Default  = "fast",
            Options  = {
                { Value = "fast",  Label = "Fast",  Tooltip = "Loot instantly." },
                { Value = "smart", Label = "Smart", Tooltip = "Loot valuable items first." },
                { Value = "off",   Label = "Disabled" },
            },
        })

    Example — CVar dropdown:
        Panel:CreateDropdown({
            Category = Category,
            Name     = "Spell Density",
            IsCVar   = true,
            CVar     = "spellClutter",
            Type     = "number",
            Options  = {
                { Value = -1, Label = "Auto" },
                { Value = 0,  Label = "Off" },
                { Value = 1,  Label = "On" },
            },
        })
]]---------------------------------------------------------------------------------------------------------------------
local function BuildDropdownOptionsGetter(func, Options)
    local source = Options.Options
    if type(source) ~= "table" and type(source) ~= "function" then
        IPLError(func, "'Options' (the entry list) must be a table or a function returning one.")
    end
    local formatter = BuildValueFormatter(Options)

    return function()
        local container = Settings.CreateControlTextContainer()
        local list = (type(source) == "function") and source() or source
        for _, entry in ipairs(list) do
            if type(entry) == "table" then
                container:Add(entry.Value, entry.Label or formatter(entry.Value), entry.Tooltip)
            else
                container:Add(entry, formatter(entry))
            end
        end
        return container:GetData()
    end
end

function PanelHandle:CreateDropdown(Options)
    if type(Options) ~= "table" then
        IPLError("CreateDropdown", "Expected a single Options table argument.")
    end

    -- Infer the value type from the entries when Default/Type are absent (e.g. CVar dropdowns).
    if not Options.Type and Options.Default == nil and type(Options.Options) == "table" then
        local first = Options.Options[1]
        if type(first) == "table" then first = first.Value end
        if first ~= nil then Options.Type = type(first) end
    end

    local GetOptions   = BuildDropdownOptionsGetter("CreateDropdown", Options)
    local Setting, key = RegisterSetting("CreateDropdown", self, Options, VarType.Number)

    local Initializer = Settings.CreateDropdown(Options.Category, Setting, GetOptions, Options.Tooltip)
    ApplyInitializerOptions(Initializer, Options)

    StoreWidget(self, "Dropdowns", key, { Initializer = Initializer, Setting = Setting, Options = Options })
    return Initializer, Setting
end



--=====================================================================================================================
-- CHECKBOX + SLIDER — one row: checkbox on the left, slider on the right (slider greys out while unchecked)
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateCheckboxSlider(Options) -> Initializer, CheckboxSetting, SliderSetting

    Two settings on one row. Pass the checkbox's options and the slider's options as SUB-TABLES; each sub-table
    accepts the same keys as CreateCheckbox / CreateSlider respectively (Variable, Default, IsCVar, UseDefault,
    IsSpecial, OnChanged, formatters, ...). Category / row-level options live at the top level.

        Category (table)  REQUIRED.
        Checkbox (table)  REQUIRED. { Name=, Variable=, Default=(boolean), Tooltip=, OnChanged=, IsCVar=, ... }
        Slider   (table)  REQUIRED. { Name=, Variable=, Default=, Min=, Max=, Step=, Format=, Tooltip=, ... }

    Example:
        Panel:CreateCheckboxSlider({
            Category = Category,
            Checkbox = {
                Name     = "Limit Frame Rate",
                Variable = "FPSLimitEnabled",
                Default  = false,
                Tooltip  = "Cap the frame rate while this addon is busy.",
            },
            Slider = {
                Name     = "Maximum FPS",
                Variable = "FPSLimit",
                Default  = 60,
                Min = 10, Max = 240, Step = 5,
                Format   = "fps",
            },
        })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateCheckboxSlider(Options)
    if type(Options) ~= "table" or type(Options.Checkbox) ~= "table" or type(Options.Slider) ~= "table" then
        IPLError("CreateCheckboxSlider", "'Checkbox' and 'Slider' sub-tables are required.")
    end
    Options.Checkbox.Category = Options.Category
    Options.Slider.Category   = Options.Category
    if type(Options.Slider.Min) ~= "number" or type(Options.Slider.Max) ~= "number" then
        IPLError("CreateCheckboxSlider", "Slider.'Min' and Slider.'Max' are required numbers.")
    end

    local CheckboxSetting, key = RegisterSetting("CreateCheckboxSlider", self, Options.Checkbox, VarType.Boolean)
    local SliderSetting        = RegisterSetting("CreateCheckboxSlider", self, Options.Slider, VarType.Number)

    local SliderOptions = Settings.CreateSliderOptions(Options.Slider.Min, Options.Slider.Max, Options.Slider.Step or 1)
    SliderOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, BuildValueFormatter(Options.Slider))

    -- Same data/template as Blizzard's CreateSettingsCheckboxSliderInitializer, minus its trailing
    -- initializer:AddSearchTags(cbLabel, sliderLabel): run from addon code, that taints the Options search.
    -- Cost: this row doesn't appear in search results.
    local Initializer = Settings.CreateSettingInitializer("SettingsCheckboxSliderControlTemplate", {
        name          = Options.Checkbox.Name,
        tooltip       = Options.Checkbox.Tooltip,
        cbSetting     = CheckboxSetting,
        cbLabel       = Options.Checkbox.Name,
        cbTooltip     = Options.Checkbox.Tooltip,
        sliderSetting = SliderSetting,
        sliderOptions = SliderOptions,
        sliderLabel   = Options.Slider.Name,
        sliderTooltip = Options.Slider.Tooltip,
    })
    GetLayout(self, Options.Category):AddInitializer(Initializer)
    ApplyInitializerOptions(Initializer, Options)

    StoreWidget(self, "CheckboxSliders", key, {
        Initializer = Initializer, CheckboxSetting = CheckboxSetting, SliderSetting = SliderSetting, Options = Options,
    })
    return Initializer, CheckboxSetting, SliderSetting
end



--=====================================================================================================================
-- CHECKBOX + DROPDOWN — one row: checkbox on the left, dropdown on the right
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateCheckboxDropdown(Options) -> Initializer, CheckboxSetting, DropdownSetting

    Same sub-table pattern as CreateCheckboxSlider: the Dropdown sub-table accepts everything CreateDropdown does
    (including Options entry list shapes and formatters).

        Category (table)  REQUIRED.
        Checkbox (table)  REQUIRED. { Name=, Variable=, Default=(boolean), Tooltip=, OnChanged=, ... }
        Dropdown (table)  REQUIRED. { Name=, Variable=, Default=, Options=, Format=, Tooltip=, OnChanged=, ... }

    Example:
        Panel:CreateCheckboxDropdown({
            Category = Category,
            Checkbox = {
                Name     = "Auto-Sell Junk",
                Variable = "AutoSell",
                Default  = true,
            },
            Dropdown = {
                Name     = "Sell Delay",
                Variable = "SellDelay",
                Default  = 500,
                Options  = { 0, 250, 500, 1000 },
                Format   = "ms",
                ValueLabels = { [0] = "Instant" },
            },
        })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateCheckboxDropdown(Options)
    if type(Options) ~= "table" or type(Options.Checkbox) ~= "table" or type(Options.Dropdown) ~= "table" then
        IPLError("CreateCheckboxDropdown", "'Checkbox' and 'Dropdown' sub-tables are required.")
    end
    Options.Checkbox.Category = Options.Category
    Options.Dropdown.Category = Options.Category

    if not Options.Dropdown.Type and Options.Dropdown.Default == nil and type(Options.Dropdown.Options) == "table" then
        local first = Options.Dropdown.Options[1]
        if type(first) == "table" then first = first.Value end
        if first ~= nil then Options.Dropdown.Type = type(first) end
    end

    local GetOptions           = BuildDropdownOptionsGetter("CreateCheckboxDropdown", Options.Dropdown)
    local CheckboxSetting, key = RegisterSetting("CreateCheckboxDropdown", self, Options.Checkbox, VarType.Boolean)
    local DropdownSetting      = RegisterSetting("CreateCheckboxDropdown", self, Options.Dropdown, VarType.Number)

    local Initializer = CreateSettingsCheckboxDropdownInitializer(
        CheckboxSetting, Options.Checkbox.Name, Options.Checkbox.Tooltip,
        DropdownSetting, GetOptions, Options.Dropdown.Name, Options.Dropdown.Tooltip
    )
    GetLayout(self, Options.Category):AddInitializer(Initializer)
    ApplyInitializerOptions(Initializer, Options)

    StoreWidget(self, "CheckboxDropdowns", key, {
        Initializer = Initializer, CheckboxSetting = CheckboxSetting, DropdownSetting = DropdownSetting, Options = Options,
    })
    return Initializer, CheckboxSetting, DropdownSetting
end



--=====================================================================================================================
-- CHECKBOX + BUTTON — one row: checkbox on the left, action button on the right
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateCheckboxButton(Options) -> Initializer, Setting

    A checkbox with a companion button on the same row (like Blizzard's "Raid Frames … Edit" rows).
    The checkbox part accepts every COMMON WIDGET OPTION.

    Button-specific:
        ButtonText       (string)   REQUIRED. The button's label.
        OnClick          (function) REQUIRED. Called when the button is clicked.
        ClickRequiresSet (boolean)  Button only enabled while the checkbox is checked (default false).

    Example:
        Panel:CreateCheckboxButton({
            Category   = Category,
            Name       = "Enable Custom Layout",
            Variable   = "CustomLayout",
            Default    = false,
            Tooltip    = "Use your own frame layout.",
            ButtonText = "Edit Layout",
            OnClick    = function() MyAddon:OpenLayoutEditor() end,
            ClickRequiresSet = true,
        })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateCheckboxButton(Options)
    if type(Options) ~= "table" or type(Options.ButtonText) ~= "string" or type(Options.OnClick) ~= "function" then
        IPLError("CreateCheckboxButton", "'ButtonText' (string) and 'OnClick' (function) are required.")
    end

    local Setting, key = RegisterSetting("CreateCheckboxButton", self, Options, VarType.Boolean)

    -- Same as Blizzard's CreateSettingsCheckboxWithButtonInitializer, minus its trailing
    -- initializer:AddSearchTags(buttonText), which taints the Options search when run from addon code. The checkbox
    -- Name is still tagged by Blizzard's secure registration, so the row stays searchable by Name.
    local data = Settings.CreateSettingInitializerData(Setting, nil, Options.Tooltip)
    data.buttonText       = Options.ButtonText
    data.OnButtonClick    = Options.OnClick
    data.OnEvaluateState  = Options.OnEvaluateState
    data.clickRequiresSet = Options.ClickRequiresSet or false
    local Initializer = Settings.CreateSettingInitializer("SettingsCheckboxWithButtonControlTemplate", data)
    GetLayout(self, Options.Category):AddInitializer(Initializer)
    ApplyInitializerOptions(Initializer, Options)

    StoreWidget(self, "CheckboxButtons", key, { Initializer = Initializer, Setting = Setting, Options = Options })
    return Initializer, Setting
end



--=====================================================================================================================
-- BUTTONS — a standalone action button row (no stored value)
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateButton(Options) -> Initializer

    Options:
        Category   (table)    REQUIRED. Which panel the button goes on.
        Name       (string)   REQUIRED. The row label (left side).
        ButtonText (string)   REQUIRED. Text on the button itself.
        OnClick    (function) REQUIRED. Click handler.
        Tooltip    (string)   Optional tooltip.
        Also honors Indent / Parent / ShownIf / EnabledIf / Section / SearchTags.

    Example:
        Panel:CreateButton({
            Category   = Category,
            Name       = "Statistics",
            ButtonText = "Reset All",
            OnClick    = function() MyAddon:ResetStats() end,
            Tooltip    = "Clears all recorded statistics.",
        })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateButton(Options)
    if type(Options) ~= "table" or type(Options.Category) ~= "table"
        or type(Options.Name) ~= "string" or type(Options.ButtonText) ~= "string" or type(Options.OnClick) ~= "function" then
        IPLError("CreateButton", "'Category', 'Name', 'ButtonText', and 'OnClick' are required.")
    end

    -- Blizzard asserts addSearchTags is non-nil. Pass false: when true, CreateSettingsButtonInitializer calls
    -- AddSearchTags from OUR (insecure) execution, creating initializer.searchTags as a tainted table. The Options
    -- search box scans every initializer's searchTags in an unprotected loop, so reading ours taints the whole
    -- search, and the rebuilt result list then trips ADDON_ACTION_FORBIDDEN on the Social panel's Discord row
    -- (C_Discord.IsUserOAuthed, protected since 12.1). Cost: button rows don't appear in Options search results.
    local Initializer = CreateSettingsButtonInitializer(Options.Name, Options.ButtonText, Options.OnClick, Options.Tooltip, false)
    GetLayout(self, Options.Category):AddInitializer(Initializer)
    ApplyInitializerOptions(Initializer, Options)

    local key = MakeKey(Options.Name .. Options.ButtonText)
    StoreWidget(self, "Buttons", key, { Initializer = Initializer, Options = Options })
    return Initializer
end



--=====================================================================================================================
-- COLOR SWATCHES — a clickable color square backed by an "AARRGGBB" hex string value
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateColorSwatch(Options) -> Initializer, Setting

    The value is a color hex string like "ffff7f00" (alpha, red, green, blue). Supports every COMMON WIDGET
    OPTION, so the color can live in your saved variables or a color CVar.

    Example:
        Panel:CreateColorSwatch({
            Category  = Category,
            Name      = "Highlight Color",
            Variable  = "HighlightColor",
            Default   = "ffffd100",
            Tooltip   = "Color used to highlight new loot.",
            OnChanged = function(setting, value)
                local color = CreateColorFromHexString(value)
                MyAddon:SetHighlightColor(color:GetRGBA())
            end,
        })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateColorSwatch(Options)
    local Setting, key = RegisterSetting("CreateColorSwatch", self, Options, VarType.String)

    local Initializer = Settings.CreateColorSwatch(Options.Category, Setting, Options.Tooltip)
    ApplyInitializerOptions(Initializer, Options)

    StoreWidget(self, "ColorSwatches", key, { Initializer = Initializer, Setting = Setting, Options = Options })
    return Initializer, Setting
end

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateCheckboxColorSwatch(Options) -> Initializer, Setting

    A checkbox with a color swatch on the same row (like Blizzard's "Class Colors in Nameplates" style rows).
    The CHECKBOX is the stored setting; you supply the swatch's color and click handling.

    Options (checkbox part accepts every COMMON WIDGET OPTION), plus:
        GetSwatchColor   (function) REQUIRED. Returns a ColorMixin (e.g. CreateColor(r, g, b)) for the swatch.
        OnSwatchClick    (function) REQUIRED. Called when the swatch is clicked — open a color picker and save
                                    the choice yourself (the swatch has no stored value of its own).
        ClickRequiresSet (boolean)  Swatch only clickable while the checkbox is checked (default false).
        SwatchTooltipTitle / SwatchTooltipText (string) Tooltip for the swatch itself.

    Example:
        Panel:CreateCheckboxColorSwatch({
            Category  = Category,
            Name      = "Color Session Bars",
            Variable  = "SessionBarsColored",
            Default   = true,
            GetSwatchColor = function() return CreateColorFromHexString(MyAddonDB.BarColor or "ff00ff00") end,
            OnSwatchClick  = function() MyAddon:OpenBarColorPicker() end,
            ClickRequiresSet = true,
        })
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateCheckboxColorSwatch(Options)
    if type(Options) ~= "table" or type(Options.GetSwatchColor) ~= "function" or type(Options.OnSwatchClick) ~= "function" then
        IPLError("CreateCheckboxColorSwatch", "'GetSwatchColor' and 'OnSwatchClick' functions are required.")
    end

    local Setting, key = RegisterSetting("CreateCheckboxColorSwatch", self, Options, VarType.Boolean)

    local Initializer = CreateSettingsCheckboxWithColorSwatchInitializer(
        Setting, Options.Tooltip,
        Options.OnSwatchClick, Options.ClickRequiresSet or false, Options.InvertClickRequiresSet,
        Options.GetSwatchColor, Options.SwatchTooltipTitle, Options.SwatchTooltipText
    )
    GetLayout(self, Options.Category):AddInitializer(Initializer)
    ApplyInitializerOptions(Initializer, Options)

    StoreWidget(self, "ColorSwatches", key, { Initializer = Initializer, Setting = Setting, Options = Options })
    return Initializer, Setting
end



--=====================================================================================================================
-- MODIFIED-CLICK DROPDOWNS — "hold which modifier key?" bindings (SELFCAST / FOCUSCAST style)
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:CreateModifiedClickDropdown(Options) -> Initializer, Setting

    A dropdown of modifier keys (ALT / CTRL / SHIFT / NONE) stored as a modified-click binding — the same control
    Blizzard uses for Self Cast Key. Only useful if your addon reads the binding via IsModifiedClick("MYACTION").

        Category (table)   REQUIRED.
        Name     (string)  REQUIRED. Row label.
        Action   (string)  REQUIRED. The modified-click action id your addon checks with IsModifiedClick().
        Default  (string)  Default key, e.g. "ALT", "CTRL", "SHIFT", "NONE".
        Tooltips (table)   Optional per-key tooltip list passed to Settings.CreateModifiedClickOptions.

    Example:
        Panel:CreateModifiedClickDropdown({
            Category = Category,
            Name     = "Quick Loot Key",
            Action   = "MYADDON_QUICKLOOT",
            Default  = "SHIFT",
        })
        -- elsewhere: if IsModifiedClick("MYADDON_QUICKLOOT") then ... end
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:CreateModifiedClickDropdown(Options)
    if type(Options) ~= "table" or type(Options.Category) ~= "table"
        or type(Options.Name) ~= "string" or type(Options.Action) ~= "string" then
        IPLError("CreateModifiedClickDropdown", "'Category', 'Name', and 'Action' are required.")
    end

    local Setting = Settings.RegisterModifiedClickSetting(Options.Category, Options.Action, Options.Name, Options.Default or "NONE")
    local DropdownOptions = Settings.CreateModifiedClickOptions(Options.Tooltips)
    local Initializer = Settings.CreateDropdown(Options.Category, Setting, DropdownOptions, Options.Tooltip)
    ApplyInitializerOptions(Initializer, Options)

    StoreWidget(self, "ModifiedClicks", Options.Action, { Initializer = Initializer, Setting = Setting, Options = Options })
    self.Settings[Options.Action] = Setting
    return Initializer, Setting
end



--=====================================================================================================================
-- UTILITIES — lookups, value access, login application, opening the panel
--=====================================================================================================================

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:GetSetting(Variable) -> Setting          The raw setting object for a widget you created.
    Panel:GetValue(Variable)   -> value            Current value of a widget's setting.
    Panel:SetValue(Variable, value)                Set it from code (fires OnChanged, updates the panel row).

    Example:
        if Panel:GetValue("AwesomeMode") then ... end
        Panel:SetValue("CacheSize", 128 * 1024 * 1024)
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:GetSetting(Variable)
    return self.Settings[Variable]
end

function PanelHandle:GetValue(Variable)
    local setting = self.Settings[Variable]
    if not setting then
        IPLError("GetValue", "No widget registered with Variable '" .. tostring(Variable) .. "'.")
    end
    return setting:GetValue()
end

function PanelHandle:SetValue(Variable, value)
    local setting = self.Settings[Variable]
    if not setting then
        IPLError("SetValue", "No widget registered with Variable '" .. tostring(Variable) .. "'.")
    end
    setting:SetValue(value)
end

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:ApplyAll()

    Re-fires every widget's OnChanged callback with its current (saved) value. Call once after building your
    panel on login so saved settings actually get applied to the game — the panel alone only applies values when
    the USER changes them. (This replaces per-widget "apply on new login" hacks.)
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:ApplyAll()
    for _, setting in pairs(self.Settings) do
        setting:TriggerValueChanged(setting:GetValue())
    end
end

--[[-------------------------------------------------------------------------------------------------------------------
    Panel:Open(CategoryName)

    Opens the Interface Options window to your panel. With no argument, opens your first created category;
    pass a category/subcategory Name to open that page directly. Perfect for slash commands:

        SLASH_MYADDON1 = "/myaddon"
        SlashCmdList["MYADDON"] = function() Panel:Open() end
]]---------------------------------------------------------------------------------------------------------------------
function PanelHandle:Open(CategoryName)
    local category = self.PrimaryCategory
    if CategoryName then
        local record = self.Categories[CategoryName]
        if not record then
            IPLError("Open", "No category named '" .. tostring(CategoryName) .. "'.")
        end
        category = record.Category
    end
    if not category then
        IPLError("Open", "No categories have been created yet.")
    end
    Settings.OpenToCategory(category:GetID())
end
