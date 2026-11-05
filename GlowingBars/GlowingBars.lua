
local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local function require(file, ...)
    if ____moduleCache[file] then
        return ____moduleCache[file].value
    end
    if ____modules[file] then
        local module = ____modules[file]
        local value = nil
        if (select("#", ...) > 0) then value = module(...) else value = module(file) end
        ____moduleCache[file] = { value = value }
        return value
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
["lualib_bundle"] = function(...) 
local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

local function __TS__ArrayIndexOf(self, searchElement, fromIndex)
    if fromIndex == nil then
        fromIndex = 0
    end
    local len = #self
    if len == 0 then
        return -1
    end
    if fromIndex >= len then
        return -1
    end
    if fromIndex < 0 then
        fromIndex = len + fromIndex
        if fromIndex < 0 then
            fromIndex = 0
        end
    end
    for i = fromIndex + 1, len do
        if self[i] == searchElement then
            return i - 1
        end
    end
    return -1
end

local function __TS__CountVarargs(...)
    return select("#", ...)
end

local function __TS__ArraySplice(self, ...)
    local args = {...}
    local len = #self
    local actualArgumentCount = __TS__CountVarargs(...)
    local start = args[1]
    local deleteCount = args[2]
    if start < 0 then
        start = len + start
        if start < 0 then
            start = 0
        end
    elseif start > len then
        start = len
    end
    local itemCount = actualArgumentCount - 2
    if itemCount < 0 then
        itemCount = 0
    end
    local actualDeleteCount
    if actualArgumentCount == 0 then
        actualDeleteCount = 0
    elseif actualArgumentCount == 1 then
        actualDeleteCount = len - start
    else
        actualDeleteCount = deleteCount or 0
        if actualDeleteCount < 0 then
            actualDeleteCount = 0
        end
        if actualDeleteCount > len - start then
            actualDeleteCount = len - start
        end
    end
    local out = {}
    for k = 1, actualDeleteCount do
        local from = start + k
        if self[from] ~= nil then
            out[k] = self[from]
        end
    end
    if itemCount < actualDeleteCount then
        for k = start + 1, len - actualDeleteCount do
            local from = k + actualDeleteCount
            local to = k + itemCount
            if self[from] then
                self[to] = self[from]
            else
                self[to] = nil
            end
        end
        for k = len - actualDeleteCount + itemCount + 1, len do
            self[k] = nil
        end
    elseif itemCount > actualDeleteCount then
        for k = len - actualDeleteCount, start + 1, -1 do
            local from = k + actualDeleteCount
            local to = k + itemCount
            if self[from] then
                self[to] = self[from]
            else
                self[to] = nil
            end
        end
    end
    local j = start + 1
    for i = 3, actualArgumentCount do
        self[j] = args[i]
        j = j + 1
    end
    for k = #self, len - actualDeleteCount + itemCount + 1, -1 do
        self[k] = nil
    end
    return out
end

local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end

local function __TS__ArrayMap(self, callbackfn, thisArg)
    local result = {}
    for i = 1, #self do
        result[i] = callbackfn(thisArg, self[i], i - 1, self)
    end
    return result
end

local function __TS__StringIncludes(self, searchString, position)
    if not position then
        position = 1
    else
        position = position + 1
    end
    local index = string.find(self, searchString, position, true)
    return index ~= nil
end

local function __TS__ClassExtends(target, base)
    target.____super = base
    local staticMetatable = setmetatable({__index = base}, base)
    setmetatable(target, staticMetatable)
    local baseMetatable = getmetatable(base)
    if baseMetatable then
        if type(baseMetatable.__index) == "function" then
            staticMetatable.__index = baseMetatable.__index
        end
        if type(baseMetatable.__newindex) == "function" then
            staticMetatable.__newindex = baseMetatable.__newindex
        end
    end
    setmetatable(target.prototype, base.prototype)
    if type(base.prototype.__index) == "function" then
        target.prototype.__index = base.prototype.__index
    end
    if type(base.prototype.__newindex) == "function" then
        target.prototype.__newindex = base.prototype.__newindex
    end
    if type(base.prototype.__tostring) == "function" then
        target.prototype.__tostring = base.prototype.__tostring
    end
end

local Error, RangeError, ReferenceError, SyntaxError, TypeError, URIError
do
    local function getErrorStack(self, constructor)
        if debug == nil then
            return nil
        end
        local level = 1
        while true do
            local info = debug.getinfo(level, "f")
            level = level + 1
            if not info then
                level = 1
                break
            elseif info.func == constructor then
                break
            end
        end
        if __TS__StringIncludes(_VERSION, "Lua 5.0") then
            return debug.traceback(("[Level " .. tostring(level)) .. "]")
        elseif _VERSION == "Lua 5.1" then
            return string.sub(
                debug.traceback("", level),
                2
            )
        else
            return debug.traceback(nil, level)
        end
    end
    local function wrapErrorToString(self, getDescription)
        return function(self)
            local description = getDescription(self)
            local caller = debug.getinfo(3, "f")
            local isClassicLua = __TS__StringIncludes(_VERSION, "Lua 5.0")
            if isClassicLua or caller and caller.func ~= error then
                return description
            else
                return (description .. "\n") .. tostring(self.stack)
            end
        end
    end
    local function initErrorClass(self, Type, name)
        Type.name = name
        return setmetatable(
            Type,
            {__call = function(____, _self, message) return __TS__New(Type, message) end}
        )
    end
    local ____initErrorClass_1 = initErrorClass
    local ____class_0 = __TS__Class()
    ____class_0.name = ""
    function ____class_0.prototype.____constructor(self, message)
        if message == nil then
            message = ""
        end
        self.message = message
        self.name = "Error"
        self.stack = getErrorStack(nil, __TS__New)
        local metatable = getmetatable(self)
        if metatable and not metatable.__errorToStringPatched then
            metatable.__errorToStringPatched = true
            metatable.__tostring = wrapErrorToString(nil, metatable.__tostring)
        end
    end
    function ____class_0.prototype.__tostring(self)
        return self.message ~= "" and (self.name .. ": ") .. self.message or self.name
    end
    Error = ____initErrorClass_1(nil, ____class_0, "Error")
    local function createErrorClass(self, name)
        local ____initErrorClass_3 = initErrorClass
        local ____class_2 = __TS__Class()
        ____class_2.name = ____class_2.name
        __TS__ClassExtends(____class_2, Error)
        function ____class_2.prototype.____constructor(self, ...)
            ____class_2.____super.prototype.____constructor(self, ...)
            self.name = name
        end
        return ____initErrorClass_3(nil, ____class_2, name)
    end
    RangeError = createErrorClass(nil, "RangeError")
    ReferenceError = createErrorClass(nil, "ReferenceError")
    SyntaxError = createErrorClass(nil, "SyntaxError")
    TypeError = createErrorClass(nil, "TypeError")
    URIError = createErrorClass(nil, "URIError")
end

local function __TS__ArrayIncludes(self, searchElement, fromIndex)
    if fromIndex == nil then
        fromIndex = 0
    end
    local len = #self
    local k = fromIndex
    if fromIndex < 0 then
        k = len + fromIndex
    end
    if k < 0 then
        k = 0
    end
    for i = k + 1, len do
        if self[i] == searchElement then
            return true
        end
    end
    return false
end

local function __TS__ObjectAssign(target, ...)
    local sources = {...}
    for i = 1, #sources do
        local source = sources[i]
        if type(source) == "table" then
            for key in pairs(source) do
                target[key] = source[key]
            end
        end
    end
    return target
end

local function __TS__ObjectGetOwnPropertyDescriptor(object, key)
    local metatable = getmetatable(object)
    if not metatable then
        return
    end
    if not rawget(metatable, "_descriptors") then
        return
    end
    return rawget(metatable, "_descriptors")[key]
end

local function __TS__CloneDescriptor(____bindingPattern0)
    local value
    local writable
    local set
    local get
    local configurable
    local enumerable
    enumerable = ____bindingPattern0.enumerable
    configurable = ____bindingPattern0.configurable
    get = ____bindingPattern0.get
    set = ____bindingPattern0.set
    writable = ____bindingPattern0.writable
    value = ____bindingPattern0.value
    local descriptor = {enumerable = enumerable == true, configurable = configurable == true}
    local hasGetterOrSetter = get ~= nil or set ~= nil
    local hasValueOrWritableAttribute = writable ~= nil or value ~= nil
    if hasGetterOrSetter and hasValueOrWritableAttribute then
        error("Invalid property descriptor. Cannot both specify accessors and a value or writable attribute.", 0)
    end
    if get or set then
        descriptor.get = get
        descriptor.set = set
    else
        descriptor.value = value
        descriptor.writable = writable == true
    end
    return descriptor
end

local __TS__DescriptorGet
do
    local getmetatable = _G.getmetatable
    local ____rawget = _G.rawget
    function __TS__DescriptorGet(self, metatable, key)
        while metatable do
            local rawResult = ____rawget(metatable, key)
            if rawResult ~= nil then
                return rawResult
            end
            local descriptors = ____rawget(metatable, "_descriptors")
            if descriptors then
                local descriptor = descriptors[key]
                if descriptor ~= nil then
                    if descriptor.get then
                        return descriptor.get(self)
                    end
                    return descriptor.value
                end
            end
            metatable = getmetatable(metatable)
        end
    end
end

local __TS__DescriptorSet
do
    local getmetatable = _G.getmetatable
    local ____rawget = _G.rawget
    local rawset = _G.rawset
    function __TS__DescriptorSet(self, metatable, key, value)
        while metatable do
            local descriptors = ____rawget(metatable, "_descriptors")
            if descriptors then
                local descriptor = descriptors[key]
                if descriptor ~= nil then
                    if descriptor.set then
                        descriptor.set(self, value)
                    else
                        if descriptor.writable == false then
                            error(
                                ((("Cannot assign to read only property '" .. key) .. "' of object '") .. tostring(self)) .. "'",
                                0
                            )
                        end
                        descriptor.value = value
                    end
                    return
                end
            end
            metatable = getmetatable(metatable)
        end
        rawset(self, key, value)
    end
end

local __TS__SetDescriptor
do
    local getmetatable = _G.getmetatable
    local function descriptorIndex(self, key)
        return __TS__DescriptorGet(
            self,
            getmetatable(self),
            key
        )
    end
    local function descriptorNewIndex(self, key, value)
        return __TS__DescriptorSet(
            self,
            getmetatable(self),
            key,
            value
        )
    end
    function __TS__SetDescriptor(target, key, desc, isPrototype)
        if isPrototype == nil then
            isPrototype = false
        end
        local ____isPrototype_0
        if isPrototype then
            ____isPrototype_0 = target
        else
            ____isPrototype_0 = getmetatable(target)
        end
        local metatable = ____isPrototype_0
        if not metatable then
            metatable = {}
            setmetatable(target, metatable)
        end
        if not isPrototype and not rawget(metatable, "_isOwnDescriptorMetatable") then
            local instanceMetatable = {}
            instanceMetatable._isOwnDescriptorMetatable = true
            setmetatable(instanceMetatable, metatable)
            setmetatable(target, instanceMetatable)
            metatable = instanceMetatable
        end
        local value = rawget(target, key)
        if value ~= nil then
            rawset(target, key, nil)
        end
        if not rawget(metatable, "_descriptors") then
            metatable._descriptors = {}
        end
        metatable._descriptors[key] = __TS__CloneDescriptor(desc)
        metatable.__index = descriptorIndex
        metatable.__newindex = descriptorNewIndex
    end
end

local function __TS__DecorateLegacy(decorators, target, key, desc)
    local result = target
    do
        local i = #decorators
        while i >= 0 do
            local decorator = decorators[i + 1]
            if decorator ~= nil then
                local oldResult = result
                if key == nil then
                    result = decorator(nil, result)
                elseif desc == true then
                    local value = rawget(target, key)
                    local descriptor = __TS__ObjectGetOwnPropertyDescriptor(target, key) or ({configurable = true, writable = true, value = value})
                    local desc = decorator(nil, target, key, descriptor) or descriptor
                    local isSimpleValue = desc.configurable == true and desc.writable == true and not desc.get and not desc.set
                    if isSimpleValue then
                        rawset(target, key, desc.value)
                    else
                        __TS__SetDescriptor(
                            target,
                            key,
                            __TS__ObjectAssign({}, descriptor, desc)
                        )
                    end
                elseif desc == false then
                    result = decorator(nil, target, key, desc)
                else
                    result = decorator(nil, target, key)
                end
                result = result or oldResult
            end
            i = i - 1
        end
    end
    return result
end

local function __TS__SparseArrayNew(...)
    local sparseArray = {...}
    sparseArray.sparseLength = __TS__CountVarargs(...)
    return sparseArray
end

local function __TS__SparseArrayPush(sparseArray, ...)
    local args = {...}
    local argsLen = __TS__CountVarargs(...)
    local listLen = sparseArray.sparseLength
    for i = 1, argsLen do
        sparseArray[listLen + i] = args[i]
    end
    sparseArray.sparseLength = listLen + argsLen
end

local function __TS__SparseArraySpread(sparseArray)
    local _unpack = unpack or table.unpack
    return _unpack(sparseArray, 1, sparseArray.sparseLength)
end

local function __TS__ArrayFindIndex(self, callbackFn, thisArg)
    for i = 1, #self do
        if callbackFn(thisArg, self[i], i - 1, self) then
            return i - 1
        end
    end
    return -1
end

local function __TS__ArrayPush(self, ...)
    local items = {...}
    local len = #self
    for i = 1, #items do
        len = len + 1
        self[len] = items[i]
    end
    return len
end

local function __TS__ArrayPushArray(self, items)
    local len = #self
    for i = 1, #items do
        len = len + 1
        self[len] = items[i]
    end
    return len
end

local function __TS__ArrayJoin(self, separator)
    if separator == nil then
        separator = ","
    end
    local parts = {}
    for i = 1, #self do
        parts[i] = tostring(self[i])
    end
    return table.concat(parts, separator)
end

local function __TS__ArrayIsArray(value)
    return type(value) == "table" and (value[1] ~= nil or next(value) == nil)
end

local function __TS__ArrayFlatMap(self, callback, thisArg)
    local result = {}
    local len = 0
    for i = 1, #self do
        local value = callback(thisArg, self[i], i - 1, self)
        if __TS__ArrayIsArray(value) then
            for j = 1, #value do
                len = len + 1
                result[len] = value[j]
            end
        else
            len = len + 1
            result[len] = value
        end
    end
    return result
end

local function __TS__ArrayFilter(self, callbackfn, thisArg)
    local result = {}
    local len = 0
    for i = 1, #self do
        if callbackfn(thisArg, self[i], i - 1, self) then
            len = len + 1
            result[len] = self[i]
        end
    end
    return result
end

local function __TS__ArrayFind(self, predicate, thisArg)
    for i = 1, #self do
        local elem = self[i]
        if predicate(thisArg, elem, i - 1, self) then
            return elem
        end
    end
    return nil
end

local function __TS__ArraySome(self, callbackfn, thisArg)
    for i = 1, #self do
        if callbackfn(thisArg, self[i], i - 1, self) then
            return true
        end
    end
    return false
end

local function __TS__ObjectValues(obj)
    local result = {}
    local len = 0
    for key in pairs(obj) do
        len = len + 1
        result[len] = obj[key]
    end
    return result
end

local function __TS__ObjectGetOwnPropertyDescriptors(object)
    local metatable = getmetatable(object)
    if not metatable then
        return {}
    end
    return rawget(metatable, "_descriptors") or ({})
end

local function __TS__Delete(target, key)
    local descriptors = __TS__ObjectGetOwnPropertyDescriptors(target)
    local descriptor = descriptors[key]
    if descriptor then
        if not descriptor.configurable then
            error(
                __TS__New(
                    TypeError,
                    ((("Cannot delete property " .. tostring(key)) .. " of ") .. tostring(target)) .. "."
                ),
                0
            )
        end
        descriptors[key] = nil
        return true
    end
    target[key] = nil
    return true
end

local function __TS__ArraySort(self, compareFn)
    if compareFn ~= nil then
        table.sort(
            self,
            function(a, b) return compareFn(nil, a, b) < 0 end
        )
    else
        table.sort(self)
    end
    return self
end

local function __TS__ArrayForEach(self, callbackFn, thisArg)
    for i = 1, #self do
        callbackFn(thisArg, self[i], i - 1, self)
    end
end

local function __TS__ArraySlice(self, first, last)
    local len = #self
    first = first or 0
    if first < 0 then
        first = len + first
        if first < 0 then
            first = 0
        end
    else
        if first > len then
            first = len
        end
    end
    last = last or len
    if last < 0 then
        last = len + last
        if last < 0 then
            last = 0
        end
    else
        if last > len then
            last = len
        end
    end
    local out = {}
    first = first + 1
    last = last + 1
    local n = 1
    while first < last do
        out[n] = self[first]
        first = first + 1
        n = n + 1
    end
    return out
end

local function __TS__ArrayEvery(self, callbackfn, thisArg)
    for i = 1, #self do
        if not callbackfn(thisArg, self[i], i - 1, self) then
            return false
        end
    end
    return true
end

return {
  __TS__Class = __TS__Class,
  __TS__ArrayIndexOf = __TS__ArrayIndexOf,
  __TS__ArraySplice = __TS__ArraySplice,
  __TS__New = __TS__New,
  __TS__ArrayMap = __TS__ArrayMap,
  Error = Error,
  RangeError = RangeError,
  ReferenceError = ReferenceError,
  SyntaxError = SyntaxError,
  TypeError = TypeError,
  URIError = URIError,
  __TS__ArrayIncludes = __TS__ArrayIncludes,
  __TS__DecorateLegacy = __TS__DecorateLegacy,
  __TS__SparseArrayNew = __TS__SparseArrayNew,
  __TS__SparseArrayPush = __TS__SparseArrayPush,
  __TS__SparseArraySpread = __TS__SparseArraySpread,
  __TS__ArrayFindIndex = __TS__ArrayFindIndex,
  __TS__ArrayPush = __TS__ArrayPush,
  __TS__ArrayPushArray = __TS__ArrayPushArray,
  __TS__ArrayJoin = __TS__ArrayJoin,
  __TS__ArrayFlatMap = __TS__ArrayFlatMap,
  __TS__ArrayFilter = __TS__ArrayFilter,
  __TS__ObjectAssign = __TS__ObjectAssign,
  __TS__ArrayFind = __TS__ArrayFind,
  __TS__ArraySome = __TS__ArraySome,
  __TS__ObjectValues = __TS__ObjectValues,
  __TS__Delete = __TS__Delete,
  __TS__ArraySort = __TS__ArraySort,
  __TS__ArrayForEach = __TS__ArrayForEach,
  __TS__ArraySlice = __TS__ArraySlice,
  __TS__ArrayEvery = __TS__ArrayEvery
}
 end,
["packages.@wowkit.core.src.event-bus"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.EventBus = __TS__Class()
local EventBus = ____exports.EventBus
EventBus.name = "EventBus"
function EventBus.prototype.____constructor(self)
    self.handlers = {}
end
function EventBus.prototype.on(self, name, handler)
    local list = self.handlers[name] or ({})
    list[#list + 1] = handler
    self.handlers[name] = list
end
function EventBus.prototype.emit(self, name, ...)
    for ____, handler in ipairs({unpack(self.handlers[name] or ({}))}) do
        handler(...)
    end
end
return ____exports
 end,
["packages.@wowkit.core.src.game-events"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
____exports.GameEvents = __TS__Class()
local GameEvents = ____exports.GameEvents
GameEvents.name = "GameEvents"
function GameEvents.prototype.____constructor(self)
    self.handlers = {}
end
function GameEvents.prototype.listen(self, event, handler)
    return self:subscribe(
        event,
        handler,
        function() return self:getEventFrame():RegisterEvent(event) end
    )
end
function GameEvents.prototype.listenToUnit(self, event, handler)
    return self:subscribe(
        event,
        handler,
        function() return self:getEventFrame():RegisterUnitEvent(event, "player") end
    )
end
function GameEvents.prototype.getEventFrame(self)
    if self.eventFrame then
        return self.eventFrame
    end
    local frame = CreateFrame("Frame")
    frame:SetScript(
        "OnEvent",
        function(_frame, event, ...)
            local list = self.handlers[event]
            if list == nil then
                return
            end
            for ____, handler in ipairs({unpack(list)}) do
                handler(...)
            end
        end
    )
    self.eventFrame = frame
    return frame
end
function GameEvents.prototype.subscribe(self, event, handler, register)
    local list = self.handlers[event]
    if list == nil then
        list = {}
        self.handlers[event] = list
        register()
    end
    list[#list + 1] = handler
    return function()
        local current = self.handlers[event]
        if current == nil then
            return
        end
        local index = __TS__ArrayIndexOf(current, handler)
        if index >= 0 then
            __TS__ArraySplice(current, index, 1)
        end
        if #current == 0 then
            self.handlers[event] = nil
            self:getEventFrame():UnregisterEvent(event)
        end
    end
end
--- Runs `action` every `seconds` until the returned function is called.
function ____exports.runInterval(seconds, action)
    local ticker = C_Timer.NewTicker(seconds, action)
    return function() return ticker:Cancel() end
end
return ____exports
 end,
["packages.@wowkit.core.src.metadata"] = function(...) 
local ____exports = {}
--- Class prototype -> what its methods listen to.
____exports.listeners = {}
function ____exports.addListener(prototype, spec)
    local list = ____exports.listeners[prototype] or ({})
    list[#list + 1] = spec
    ____exports.listeners[prototype] = list
end
return ____exports
 end,
["packages.@wowkit.core.src.types"] = function(...) 
local ____exports = {}
return ____exports
 end,
["packages.@wowkit.core.src.addon"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local ____exports = {}
local ____event_2Dbus = require("packages.@wowkit.core.src.event-bus")
local EventBus = ____event_2Dbus.EventBus
local ____game_2Devents = require("packages.@wowkit.core.src.game-events")
local GameEvents = ____game_2Devents.GameEvents
local runInterval = ____game_2Devents.runInterval
local ____metadata = require("packages.@wowkit.core.src.metadata")
local listeners = ____metadata.listeners
--- The addon: its services are made by hand, in order, and handed to `register`; `start` then connects them to the
-- game's events and runs their lifecycle hooks.
-- 
--     const addon = new Addon(addonName);
--     const settings = addon.register(new SettingsService(...));
--     addon.start();
-- 
-- Lifecycle, in order: `onAddonLoaded` at ADDON_LOADED of this addon (the saved data is there); at the first
-- PLAYER_LOGIN or PLAYER_ENTERING_WORLD `onFirstLogin` once and then the regular work (@Interval)
-- starts; `onLogin` at PLAYER_LOGIN only; `onReady` after PLAYER_LOGIN and after every
-- PLAYER_ENTERING_WORLD; `onLogout` at PLAYER_LOGOUT, when the regular work stops. Hooks run in
-- the order the services were registered, so a service is registered after the services it needs.
____exports.Addon = __TS__Class()
local Addon = ____exports.Addon
Addon.name = "Addon"
function Addon.prototype.____constructor(self, addonName)
    self.addonName = addonName
    self.events = __TS__New(EventBus)
    self.gameEvents = __TS__New(GameEvents)
    self.services = {}
    self.intervals = {}
    self.stoppers = {}
    self.hasBooted = false
end
function Addon.prototype.register(self, service)
    local ____self_services_0 = self.services
    ____self_services_0[#____self_services_0 + 1] = service
    return service
end
function Addon.prototype.start(self)
    for ____, instance in ipairs(self.services) do
        self:connectListeners(instance)
    end
    local stopWaiting
    stopWaiting = self.gameEvents:listen(
        "ADDON_LOADED",
        function(loaded)
            if loaded ~= self.addonName then
                return
            end
            stopWaiting()
            self:runHook("onAddonLoaded")
        end
    )
    self.gameEvents:listen(
        "PLAYER_LOGIN",
        function()
            self:runFirstLogin()
            self:runHook("onLogin")
            self:runHook("onReady")
        end
    )
    self.gameEvents:listen(
        "PLAYER_ENTERING_WORLD",
        function()
            self:runFirstLogin()
            self:runHook("onReady")
        end
    )
    self.gameEvents:listen(
        "PLAYER_LOGOUT",
        function() return self:stopWork() end
    )
end
function Addon.prototype.connectListeners(self, instance)
    local implementation = instance.constructor
    local specs = listeners[implementation.prototype] or ({})
    for ____, spec in ipairs(specs) do
        local function handle(...)
            return self:callMethod(instance, spec.method, ...)
        end
        if spec.kind == "game" then
            self.gameEvents:listen(spec.name, handle)
        elseif spec.kind == "unit" then
            self.gameEvents:listenToUnit(spec.name, handle)
        elseif spec.kind == "event" then
            self.events:on(spec.name, handle)
        else
            local ____self_intervals_1 = self.intervals
            ____self_intervals_1[#____self_intervals_1 + 1] = {instance = instance, seconds = spec.seconds, method = spec.method}
        end
    end
end
function Addon.prototype.runHook(self, hook)
    for ____, instance in ipairs(self.services) do
        if instance[hook] ~= nil then
            self:callMethod(instance, hook)
        end
    end
end
function Addon.prototype.runFirstLogin(self)
    if self.hasBooted then
        return
    end
    self.hasBooted = true
    self:runHook("onFirstLogin")
    self.stoppers = __TS__ArrayMap(
        self.intervals,
        function(____, ____bindingPattern0)
            local method
            local seconds
            local instance
            instance = ____bindingPattern0.instance
            seconds = ____bindingPattern0.seconds
            method = ____bindingPattern0.method
            return runInterval(
                seconds,
                function() return self:callMethod(instance, method) end
            )
        end
    )
end
function Addon.prototype.stopWork(self)
    for ____, stop in ipairs(self.stoppers) do
        stop()
    end
    self.stoppers = {}
    self:runHook("onLogout")
end
function Addon.prototype.callMethod(self, instance, name, ...)
    local method = instance[name]
    if method == nil then
        error(
            __TS__New(Error, "no method " .. name),
            0
        )
    end
    method(instance, ...)
end
return ____exports
 end,
["packages.@wowkit.core.src.decorators"] = function(...) 
local ____exports = {}
local ____metadata = require("packages.@wowkit.core.src.metadata")
local addListener = ____metadata.addListener
--- Method: call it for these game events (PLAYER_DEAD...).
function ____exports.OnGameEvent(...)
    local events = {...}
    return function(____, prototype, method)
        for ____, name in ipairs(events) do
            addListener(prototype, {kind = "game", name = name, method = method})
        end
    end
end
--- Method: call it for these game events when they are about the player (UNIT_AURA...).
function ____exports.OnUnitEvent(...)
    local events = {...}
    return function(____, prototype, method)
        for ____, name in ipairs(events) do
            addListener(prototype, {kind = "unit", name = name, method = method})
        end
    end
end
--- Method: call it when the addon announces something on the EventBus (see AppEvents).
function ____exports.OnEvent(...)
    local names = {...}
    return function(____, prototype, method)
        for ____, name in ipairs(names) do
            addListener(prototype, {kind = "event", name = name, method = method})
        end
    end
end
--- Method: call it every `milliseconds`, from the first login until logout.
function ____exports.Interval(milliseconds)
    return function(____, prototype, method)
        addListener(prototype, {kind = "interval", seconds = milliseconds / 1000, method = method})
    end
end
return ____exports
 end,
["packages.@wowkit.core.src.utils.text_utils"] = function(...) 
local ____exports = {}
--- The text without leading and trailing white space.
function ____exports.trimText(text)
    local trimmed = string.match(text, "^%s*(.-)%s*$")
    return trimmed or ""
end
--- Plain-text search (no Lua patterns).
function ____exports.contains(text, token)
    return (string.find(text, token, 1, true)) ~= nil
end
return ____exports
 end,
["packages.@wowkit.core.src.index"] = function(...) 
local ____exports = {}
do
    local ____addon = require("packages.@wowkit.core.src.addon")
    ____exports.Addon = ____addon.Addon
end
do
    local ____decorators = require("packages.@wowkit.core.src.decorators")
    ____exports.Interval = ____decorators.Interval
    ____exports.OnEvent = ____decorators.OnEvent
    ____exports.OnGameEvent = ____decorators.OnGameEvent
    ____exports.OnUnitEvent = ____decorators.OnUnitEvent
end
do
    local ____event_2Dbus = require("packages.@wowkit.core.src.event-bus")
    ____exports.EventBus = ____event_2Dbus.EventBus
end
do
    local ____export = require("packages.@wowkit.core.src.utils.text_utils")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
return ____exports
 end,
["packages.@wowkit.wow.src.button-registry_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.ButtonRegistryService = __TS__Class()
local ButtonRegistryService = ____exports.ButtonRegistryService
ButtonRegistryService.name = "ButtonRegistryService"
function ButtonRegistryService.prototype.____constructor(self)
    self.bars = {}
    self.stances = {}
    self.shapes = {}
end
function ButtonRegistryService.prototype.registerButton(self, button, bar, shape)
    self.bars[button] = bar or 0
    self:setShape(button, shape)
end
function ButtonRegistryService.prototype.registerStanceButton(self, button, stance, shape)
    self.stances[button] = stance
    self:setShape(button, shape)
end
function ButtonRegistryService.prototype.findShape(self, button)
    return self.shapes[button]
end
function ButtonRegistryService.prototype.setShape(self, button, shape)
    if shape ~= nil then
        self.shapes[button] = shape
    else
        self.shapes[button] = nil
    end
end
function ButtonRegistryService.prototype.isRegistered(self, button)
    return self.bars[button] ~= nil or self.stances[button] ~= nil
end
function ButtonRegistryService.prototype.findBar(self, button)
    local bar = self.bars[button]
    return bar ~= nil and bar > 0 and bar or nil
end
function ButtonRegistryService.prototype.listActionButtons(self, bar)
    local buttons = {}
    for button, buttonBar in pairs(self.bars) do
        if bar == nil or buttonBar == bar then
            buttons[#buttons + 1] = button
        end
    end
    return buttons
end
function ButtonRegistryService.prototype.listStanceButtons(self)
    local buttons = {}
    for button, stance in pairs(self.stances) do
        buttons[#buttons + 1] = {button, stance}
    end
    return buttons
end
function ButtonRegistryService.prototype.countButtons(self)
    return #self:listActionButtons() + #self:listStanceButtons()
end
return ____exports
 end,
["packages.@wowkit.wow.src.clock_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.ClockService = __TS__Class()
local ClockService = ____exports.ClockService
ClockService.name = "ClockService"
function ClockService.prototype.____constructor(self)
end
function ClockService.prototype.getCurrentTime(self)
    return GetTime()
end
function ClockService.prototype.runAfter(self, seconds, action)
    C_Timer.After(seconds, action)
end
return ____exports
 end,
["packages.@wowkit.wow.src.utils.protected-call_utils"] = function(...) 
local ____exports = {}
--- Calls `fn` in protected mode: whether it succeeded, and its result.
function ____exports.tryCall(fn, ...)
    local didSucceed, result = pcall(fn, ...)
    if not didSucceed then
        return false, nil
    end
    return true, result
end
--- Calls `fn` in protected mode: its result, or undefined when it raised an error.
function ____exports.attempt(fn, ...)
    local ____, result = ____exports.tryCall(fn, ...)
    return result
end
--- `attempt` for functions with several results: ok, then the results (all nil on error).
function ____exports.attemptMulti(fn)
    return pcall(fn)
end
return ____exports
 end,
["packages.@wowkit.wow.src.utils.secret-value_utils"] = function(...) 
local ____exports = {}
--- A value addon code may look at: not nil, not secret, and accessible from this code.
function ____exports.isReadable(value)
    if value == nil then
        return false
    end
    if issecretvalue(value) then
        return false
    end
    return canaccessvalue(value)
end
--- The value when readable, else undefined.
function ____exports.getReadable(value)
    local ____isReadable_result_0
    if ____exports.isReadable(value) then
        ____isReadable_result_0 = value
    else
        ____isReadable_result_0 = nil
    end
    return ____isReadable_result_0
end
--- A readable positive number (spell, item or texture ID), else undefined.
function ____exports.getReadableId(value)
    if not ____exports.isReadable(value) or value == 0 or value == "" then
        return nil
    end
    local n = tonumber(value)
    return n ~= nil and n > 0 and n or nil
end
return ____exports
 end,
["packages.@wowkit.wow.src.utils.item-button_utils"] = function(...) 
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local getReadableId = ____secret_2Dvalue_2Eutils.getReadableId
--- The item the button holds; undefined for anything else, or while the client keeps it secret.
function ____exports.findButtonItem(actionBars, button)
    local slot = actionBars:getActionSlot(button)
    if slot == nil then
        return nil
    end
    local didRead, kind, itemId = attemptMulti(function() return GetActionInfo(slot) end)
    if not didRead or getReadable(kind) ~= "item" then
        return nil
    end
    return getReadable(itemId)
end
--- Items are looked up among the buttons of the spells, under numbers no spell has.
local ITEM_BUTTON_KEYS = 1000000000
--- What the buttons holding an item are found by (see ActionBarsService.findButtonsOf).
function ____exports.getItemButtonKey(itemId)
    return ITEM_BUTTON_KEYS + itemId
end
--- Does the client know an item by this ID?
function ____exports.isKnownItem(itemId)
    local didRead, id = attemptMulti(function() return C_Item.GetItemInfoInstant(itemId) end)
    return didRead and getReadable(id) ~= nil
end
--- Does the button hold an item of which the bags have none? Not when the client keeps the count secret.
function ____exports.isOutOfItem(actionBars, button)
    local itemId = ____exports.findButtonItem(actionBars, button)
    return itemId ~= nil and getReadable(attempt(C_Item.GetItemCount, itemId)) == 0
end
--- The spell an item casts when used; undefined when it has none, or the client does not say yet.
function ____exports.findItemUseSpell(itemId)
    local didRead, ____, spellId = attemptMulti(function() return C_Item.GetItemSpell(itemId) end)
    local ____didRead_0
    if didRead then
        ____didRead_0 = getReadableId(spellId)
    else
        ____didRead_0 = nil
    end
    return ____didRead_0
end
--- The name and icon of an item, as the client knows them.
function ____exports.readItemLook(itemId)
    return {
        name = getReadable(attempt(C_Item.GetItemNameByID, itemId)),
        iconId = getReadable(attempt(C_Item.GetItemIconByID, itemId))
    }
end
return ____exports
 end,
["packages.@wowkit.wow.src.spell-book_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local contains = ____core.contains
local trimText = ____core.trimText
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
--- Rebuilds that are not forced wait this long after the previous one.
local MIN_REBUILD_INTERVAL = 5
--- Test spells and old versions the client also knows by the same name.
function ____exports.isJunkSpellName(name)
    if name == nil then
        return true
    end
    local upper = string.upper(name)
    return contains(upper, "TEST") or contains(upper, "(OLD)") or contains(upper, "(PT)")
end
____exports.SpellBookService = __TS__Class()
local SpellBookService = ____exports.SpellBookService
SpellBookService.name = "SpellBookService"
function SpellBookService.prototype.____constructor(self, bus)
    self.bus = bus
    self.generation = 0
    self.isBuildRunning = false
    self.lastBuildAt = 0
end
function SpellBookService.prototype.isReady(self)
    return self.entries ~= nil
end
function SpellBookService.prototype.isBuilding(self)
    return self.isBuildRunning
end
function SpellBookService.prototype.findSpellIdByName(self, name)
    local ____opt_0 = self.entries
    return ____opt_0 and ____opt_0.byName[self:buildSpellBookKey(name)]
end
function SpellBookService.prototype.listSpellIds(self)
    local ids = {}
    if self.entries then
        for ____, id in pairs(self.entries.byName) do
            ids[#ids + 1] = id
        end
    end
    return ids
end
function SpellBookService.prototype.getRanksByName(self, name)
    local ____opt_2 = self.entries
    return ____opt_2 and ____opt_2.ranks[self:buildSpellBookKey(name)] or ({})
end
function SpellBookService.prototype.invalidate(self)
    self.generation = self.generation + 1
    self.entries = nil
    self.isBuildRunning = false
end
function SpellBookService.prototype.noteLearned(self, id, name)
    if not self.entries then
        return
    end
    local key = self:buildSpellBookKey(name)
    local ranks = self.entries.ranks[key] or ({})
    self.entries.ranks[key] = ranks
    if not __TS__ArrayIncludes(ranks, id) then
        ranks[#ranks + 1] = id
    end
end
function SpellBookService.prototype.rebuild(self, isImmediate)
    if self.isBuildRunning and not isImmediate then
        return
    end
    if not isImmediate and self.entries and GetTime() - self.lastBuildAt < MIN_REBUILD_INTERVAL then
        return
    end
    self.generation = self.generation + 1
    local generation = self.generation
    self.entries = nil
    self.isBuildRunning = true
    self.lastBuildAt = GetTime()
    local entries = {byName = {}, ranks = {}}
    local function readSlot(slot)
        for ____, bank in ipairs(self:listBanks()) do
            local name, id = self:readBookItem(slot, bank)
            if id ~= nil and name ~= nil and name ~= "" and not ____exports.isJunkSpellName(name) then
                local key = self:buildSpellBookKey(name)
                local ranks = entries.ranks[key]
                if ranks then
                    ranks[#ranks + 1] = id
                else
                    entries.ranks[key] = {id}
                end
                if not (entries.byName[key] ~= nil) then
                    entries.byName[key] = id
                end
            end
        end
    end
    local lineCount = attempt(C_SpellBook.GetNumSpellBookSkillLines) or 0
    local line = 1
    local legacySlot = 1
    --- Reads a few skill lines; true while there are more.
    local function readLineBatch()
        do
            local budget = isImmediate and 99 or 2
            while line <= lineCount and budget > 0 do
                local info = attempt(C_SpellBook.GetSpellBookSkillLineInfo, line)
                if info then
                    local offset = tonumber(info.itemIndexOffset) or 0
                    local count = tonumber(info.numSpellBookItems) or 0
                    do
                        local slot = offset + 1
                        while slot <= offset + count do
                            readSlot(slot)
                            slot = slot + 1
                        end
                    end
                end
                do
                    line = line + 1
                    budget = budget - 1
                end
            end
        end
        return line <= lineCount
    end
    --- No skill lines reported: reads the first 400 slots, a few at a time; true while there are more.
    local function readLegacyBatch()
        do
            local budget = isImmediate and 400 or 40
            while legacySlot <= 400 and budget > 0 do
                readSlot(legacySlot)
                do
                    legacySlot = legacySlot + 1
                    budget = budget - 1
                end
            end
        end
        return legacySlot <= 400
    end
    local readNextBatch
    readNextBatch = function()
        if generation ~= self.generation then
            return
        end
        local ____temp_4
        if lineCount > 0 then
            ____temp_4 = readLineBatch()
        else
            ____temp_4 = readLegacyBatch()
        end
        local hasMore = ____temp_4
        if hasMore then
            return C_Timer.After(0, readNextBatch)
        end
        self.entries = entries
        self.isBuildRunning = false
        self.bus:emit("spellbook.built")
    end
    if isImmediate then
        readNextBatch()
    else
        C_Timer.After(0, readNextBatch)
    end
end
function SpellBookService.prototype.listBanks(self)
    return {Enum.SpellBookSpellBank.Player, Enum.SpellBookSpellBank.Pet}
end
function SpellBookService.prototype.readBookItem(self, slot, bank)
    local info = attempt(C_SpellBook.GetSpellBookItemInfo, slot, bank)
    if info then
        if getReadable(info.itemType) == Enum.SpellBookItemType.FutureSpell then
            return
        end
        return getReadable(info.name), getReadable(info.spellID)
    end
    local didSucceed, name = attemptMulti(function() return C_SpellBook.GetSpellBookItemName(slot, bank) end)
    if not didSucceed then
        return
    end
    return getReadable(name), nil
end
function SpellBookService.prototype.buildSpellBookKey(self, name)
    local key = string.gsub(
        string.lower(name),
        "%s*%([^%)]*%)",
        ""
    )
    key = string.gsub(key, "%s*rank%s*%d+", "")
    key = string.gsub(key, "%s+", " ")
    return trimText(key)
end
return ____exports
 end,
["packages.@wowkit.wow-data.src.items"] = function(...) 
local ____exports = {}
--- The reagents of the group buffs.
____exports.Reagents = {
    HolyCandle = 17028,
    SacredCandle = 17029,
    WildBerries = 17021,
    WildThornroot = 17026,
    ArcanePowder = 17020,
    SymbolOfKings = 21177
}
--- Every table above, by name: what the check goes through. A new table is added here too.
____exports.ITEMS = {Reagents = ____exports.Reagents}
return ____exports
 end,
["packages.@wowkit.wow-data.src.spells"] = function(...) 
local ____exports = {}
____exports.Druid = {
    MarkOfTheWild = 1126,
    Thorns = 467,
    Moonkin = 24858,
    BearForm = 5487,
    DireBearForm = 9634,
    CatForm = 768,
    TravelForm = 783,
    AquaticForm = 1066,
    GiftOfTheWild = {21849, 21850},
    Wrath = 5176,
    Moonfire = 8921,
    Starfire = 2912,
    FaerieFire = 770,
    InsectSwarm = 5570,
    Hurricane = 16914,
    HealingTouch = 5185,
    Regrowth = 8936,
    Rejuvenation = 774,
    Swiftmend = 18562,
    Tranquility = 740,
    Innervate = 29166,
    NaturesSwiftness = 17116,
    WildGrowth = 408120,
    Barkskin = 22812,
    NaturesGrasp = 16689,
    Maul = 6807,
    Swipe = 779,
    Claw = 1082,
    Rake = 1822,
    Rip = 1079,
    Shred = 5221,
    FerociousBite = 22568,
    TigersFury = 5217,
    DemoralizingRoar = 99,
    Growl = 6795,
    Bash = 5211,
    Ravage = 6785,
    Prowl = 5215,
    Enrage = 5229,
    FrenziedRegeneration = 22842,
    FeralCharge = 16979,
    FeralChargeCat = 414924,
    Lacerate = 414644,
    Mangle = 407995,
    Berserk = 417141
}
____exports.Paladin = {
    DevotionAura = 465,
    RetributionAura = 7294,
    ConcentrationAura = 19746,
    SanctityAura = 20218,
    FireResistAura = 19891,
    FrostResistAura = 19888,
    ShadowResistAura = 19876,
    BlessingMight = 19740,
    BlessingKings = 20217,
    BlessingWisdom = 19742,
    BlessingSalvation = 1038,
    BlessingLight = 19977,
    RighteousFury = 25780,
    GreaterBlessingMight = {25782, 25916},
    GreaterBlessingKings = {25898},
    GreaterBlessingWisdom = {25894, 25918},
    GreaterBlessingSalvation = {25895},
    GreaterBlessingLight = {25890},
    HolyLight = 635,
    FlashOfLight = 19750,
    LayOnHands = 633,
    LightsVigil = 1310911,
    SealOfRighteousness = 20154,
    SealOfFury = 20163,
    SealOfCommand = 20375,
    SealOfTheCrusader = 21082,
    SealOfLight = 20165,
    SealOfWisdom = 20166,
    SealOfJustice = 20164,
    Judgement = 20271,
    JudgementOfTheCrusader = 21183,
    JudgementOfJustice = 20184,
    JudgementOfLight = 20185,
    JudgementOfWisdom = 20186,
    SwiftJudgement = 1310994,
    Consecration = 26573,
    HammerOfJustice = 853,
    HammerOfWrath = 24275,
    Exorcism = 879,
    HolyWrath = 2812,
    HolyShock = 20473,
    HolyShield = 20925,
    CrusaderStrike = 678,
    HolyStrike = 678,
    DivineProtection = 498,
    DivineShield = 642,
    VoiceOfTruth = 1310897,
    TemplarsBulwark = 1311015
}
____exports.Warrior = {
    BattleShout = 6673,
    HeroicStrike = 78,
    Charge = 100,
    Rend = 772,
    ThunderClap = 6343,
    Overpower = 7384,
    Execute = 5308,
    MortalStrike = 12294,
    Bloodthirst = 23881,
    Whirlwind = 1680,
    Hamstring = 1715,
    SunderArmor = 7386,
    Revenge = 6572,
    ShieldSlam = 23922,
    ShieldBlock = 2565,
    Taunt = 355,
    LastStand = 12975,
    ShieldWall = 871,
    Bloodrage = 2687,
    Pummel = 6552,
    Cleave = 845,
    Recklessness = 1719,
    SweepingStrikes = 12292,
    DeathWish = 12328,
    BerserkerRage = 18499,
    Intercept = 20252,
    Slam = 1464,
    DemoralizingShout = 1160,
    Retaliation = 20230,
    Disarm = 676,
    ShieldBash = 72,
    MockingBlow = 694,
    PiercingHowl = 12323,
    SpearingStrike = 1310222,
    VictoryRush = 402927
}
____exports.Hunter = {
    AspectHawk = 13165,
    AspectMonkey = 13163,
    AspectWild = 20043,
    AspectCheetah = 5118,
    AspectPack = 13159,
    AspectBeast = 13161,
    TrueshotAura = 19506,
    AutoShot = 75,
    SerpentSting = 1978,
    ViperSting = 3034,
    ScorpidSting = 3043,
    ArcaneShot = 3044,
    AimedShot = 19434,
    MultiShot = 2643,
    Volley = 1510,
    HuntersMark = 1130,
    ConcussiveShot = 5116,
    RapidFire = 3045,
    ScatterShot = 19503,
    HydraShot = 1293020,
    SniperShot = 1310687,
    TranquilizingShot = 19801,
    EnchantedFlare = 1221404,
    Flare = 1543,
    DistractingShot = 20736,
    RaptorStrike = 2973,
    WingClip = 2974,
    MongooseBite = 1495,
    Counterattack = 19306,
    Lacerate = 1299332,
    StriderKick = 1317257,
    MendPet = 136,
    CallPet = 883,
    RevivePet = 982,
    SummonHawk = 1293241,
    BestialWrath = 19574,
    Intimidation = 19577,
    FeignDeath = 5384,
    Deterrence = 19263,
    Disengage = 781
}
____exports.Priest = {
    InnerFire = 588,
    PowerWordFortitude = 1243,
    DivineSpirit = 14752,
    ShadowProtection = 976,
    Shadowform = 15473,
    PrayerOfFortitude = {21562, 21564},
    PrayerOfSpirit = {27681},
    PrayerOfShadowProtection = {27683},
    Shoot = 5019,
    Smite = 585,
    ShadowWordPain = 589,
    MindBlast = 8092,
    HolyFire = 14914,
    HolyNova = 15237,
    MindFlay = 15407,
    DevouringPlague = 2944,
    ManaBurn = 8129,
    Silence = 15487,
    Chastise = 1277331,
    ConfoundingFlash = 1277455,
    Penance = 402174,
    ShadowWordDeath = 401955,
    LesserHeal = 2050,
    Heal = 2054,
    FlashHeal = 2061,
    GreaterHeal = 2060,
    Renew = 139,
    PowerWordShield = 17,
    WeakenedSoul = 6788,
    PrayerOfHealing = 596,
    PrayerOfMending = 401859,
    BindingHeal = 401937,
    DivineGrace = 1277370,
    ContingencyPlan = 1277462,
    Feedback = 13896,
    DesperatePrayer = 13908,
    ElunesGrace = 2651,
    Starshards = 10797,
    PsychicScream = 8122,
    Fade = 586,
    InnerFocus = 14751,
    PowerInfusion = 10060,
    VampiricEmbrace = 15286,
    DarkSacrifice = 1277324
}
____exports.Rogue = {
    InstantPoison = 8679,
    DeadlyPoison = 2823,
    CripplingPoison = 3408,
    WoundPoison = 13219,
    MindNumbingPoison = 5761,
    SinisterStrike = 1752,
    Backstab = 53,
    Hemorrhage = 16511,
    GhostlyStrike = 14278,
    Mutilate = 1329,
    Gouge = 1776,
    Eviscerate = 2098,
    SliceAndDice = 5171,
    Rupture = 1943,
    KidneyShot = 408,
    Venom = 1310703,
    ExposeArmor = 8647,
    Stealth = 1784,
    Garrote = 703,
    Ambush = 8676,
    CheapShot = 1833,
    Premeditation = 14183,
    Kick = 1766,
    Riposte = 14251,
    Evasion = 5277,
    Sprint = 2983,
    Vanish = 1856,
    Feint = 1966,
    BladeFlurry = 13877,
    AdrenalineRush = 13750,
    ColdBlood = 14177,
    Preparation = 14185
}
____exports.Shaman = {
    LightningShield = 324,
    WaterShield = 408510,
    Windfury = {
        8232,
        8235,
        10486,
        16362,
        439431,
        461636
    },
    Flametongue = {
        8024,
        8027,
        8030,
        16339,
        16341,
        16342,
        461634
    },
    Rockbiter = {
        8017,
        8018,
        8019,
        10399,
        16314,
        16315,
        16316,
        461635
    },
    Frostbrand = {
        8033,
        8038,
        10456,
        16355,
        16356,
        461633
    },
    LightningBolt = 403,
    ChainLightning = 421,
    EarthShock = 8042,
    FlameShock = 8050,
    FrostShock = 8056,
    Stormstrike = 17364,
    LavaBurst = 408490,
    Purge = 370,
    HealingWave = 331,
    LesserHealingWave = 8004,
    ChainHeal = 1064,
    Riptide = 408521,
    SearingTotem = 3599,
    MagmaTotem = 8190,
    FireNovaTotem = 408341,
    EarthbindTotem = 2484,
    StoneclawTotem = 5730,
    StrengthOfEarthTotem = 8075,
    StoneskinTotem = 8071,
    TremorTotem = 8143,
    HealingStreamTotem = 5394,
    ManaSpringTotem = 5675,
    WindfuryTotem = 8512,
    GraceOfAirTotem = 8835,
    GroundingTotem = 8177,
    CallOfTheElements = 66842,
    CallOfTheAncestors = 66843,
    CallOfTheSpirits = 66844,
    TotemicRecall = 36936,
    TotemicProjection = 437009,
    ElementalMastery = 16166,
    NaturesSwiftness = 16188,
    CureDisease = 2870,
    CurePoison = 526
}
____exports.Mage = {
    ArcaneIntellect = 1459,
    MageArmor = 6117,
    IceArmor = 7302,
    FrostArmor = 168,
    AmplifyMagic = 1008,
    ArcaneBrilliance = {23028},
    DampenMagic = 604,
    Shoot = 5019,
    Fireball = 133,
    Frostbolt = 116,
    FireBlast = 2136,
    ArcaneMissiles = 5143,
    FrostNova = 122,
    ArcaneExplosion = 1449,
    ConeOfCold = 120,
    Pyroblast = 11366,
    Flamestrike = 2120,
    Scorch = 2948,
    Blizzard = 10,
    BlastWave = 11113,
    FrostfireBolt = 401502,
    IceLance = 400640,
    ArcaneBlast = 400574,
    FireVulnerability = 22959,
    WintersChill = 12579,
    Counterspell = 2139,
    RemoveLesserCurse = 475,
    Blink = 1953,
    Evocation = 12051,
    IceBlock = 11958,
    IceBarrier = 11426,
    Combustion = 11129,
    PresenceOfMind = 12043,
    ArcanePower = 12042,
    ManaShield = 1463,
    FireWard = 543,
    FrostWard = 6143
}
____exports.Warlock = {
    DemonArmor = 706,
    DemonSkin = 687,
    UnendingBreath = 5697,
    Firestone = 6366,
    Spellstone = 2362,
    DetectInvisibility = 132,
    Shoot = 5019,
    ShadowBolt = 686,
    Immolate = 348,
    Corruption = 172,
    CurseOfAgony = 980,
    CurseOfTheElements = 11723,
    CurseOfShadow = 402791,
    BaneOfHavoc = 1225228,
    DrainLife = 689,
    DrainSoul = 1120,
    SiphonLife = 18265,
    SearingPain = 5676,
    RainOfFire = 5740,
    Hellfire = 1949,
    Shadowburn = 17877,
    Conflagrate = 17962,
    SoulFire = 6353,
    Incinerate = 412758,
    Wrack = 1316697,
    LifeTap = 1454,
    Fear = 5782,
    DeathCoil = 6789,
    HowlOfTerror = 5484,
    ShadowWard = 6229,
    SummonImp = 688,
    SummonVoidwalker = 697,
    SummonSuccubus = 712,
    SummonIncubus = 713,
    SummonFelhunter = 691
}
--- The racial spells, Forever's Aeolid ones included.
____exports.Racial = {
    Perception = 20600,
    BloodFury = 20572,
    Stoneform = 20594,
    Shadowmeld = 20580,
    WillOfTheForsaken = 7744,
    WarStomp = 20549,
    EscapeArtist = 20589,
    Berserking = 20554,
    Cannibalize = 20577,
    LeyLine = 1259705,
    SkyView = 1259686,
    Eureka = 1259813,
    WillToSurvive = 1259718,
    ElunesLight = 1259799,
    ShatterCurse = 1299026,
    RapidRegeneration = 1260270
}
--- The trackings: the gathering professions' (Find Minerals, Find Herbs), the dwarf's, the hunter's, the paladin's and the
-- warlock's. Only one can be on at a time.
____exports.Tracking = {
    FindMinerals = 2580,
    FindHerbs = 2383,
    FindTreasure = 2481,
    TrackBeasts = 1494,
    TrackHumanoids = 19883,
    TrackUndead = 19884,
    TrackHidden = 19885,
    TrackElementals = 19880,
    TrackDemons = 19878,
    TrackGiants = 19882,
    TrackDragonkin = 19879,
    SenseUndead = 5502,
    SenseDemons = 5500
}
--- The cures of the classes (the paladin's, the priest's and the druid's; the shaman's and mage's are in their tables).
____exports.Cure = {
    Cleanse = 4987,
    Purify = 1152,
    AbolishDisease = 552,
    PriestCureDisease = 528,
    DispelMagic = 527,
    AbolishPoison = 2893,
    DruidCurePoison = 8946,
    RemoveCurse = 2782
}
--- The buffs of eating and drinking: a food gives the buff "Food", a drink "Drink", Forever's better ones "Nutritious Food"
-- and "Nutritious Drink" (each food has an ID of its own, the name is the one to go by); a good food or a Nutritious Drink, after it, "Well Fed".
____exports.Consumable = {
    Food = 433,
    Drink = 430,
    NutritiousFood = 1248377,
    NutritiousDrink = 1249906,
    WellFed = 19705
}
--- The English spellbook names of IDs the client may not name (the first one is the one shown): a facade falls back on them.
____exports.SPELL_NAME_HINT = {
    [____exports.Consumable.Food] = "Food",
    [____exports.Consumable.NutritiousFood] = "Nutritious Food",
    [____exports.Consumable.NutritiousDrink] = "Nutritious Drink",
    [____exports.Consumable.WellFed] = "Well Fed",
    [____exports.Shaman.WaterShield] = "Water Shield",
    [____exports.Priest.PrayerOfFortitude[1]] = "Prayer of Fortitude",
    [____exports.Priest.PrayerOfFortitude[2]] = "Prayer of Fortitude",
    [____exports.Priest.PrayerOfSpirit[1]] = "Prayer of Spirit",
    [____exports.Priest.PrayerOfShadowProtection[1]] = "Prayer of Shadow Protection",
    [____exports.Druid.GiftOfTheWild[1]] = "Gift of the Wild",
    [____exports.Druid.GiftOfTheWild[2]] = "Gift of the Wild",
    [____exports.Mage.ArcaneBrilliance[1]] = "Arcane Brilliance",
    [____exports.Paladin.GreaterBlessingMight[1]] = "Greater Blessing of Might",
    [____exports.Paladin.GreaterBlessingKings[1]] = "Greater Blessing of Kings",
    [____exports.Paladin.GreaterBlessingWisdom[1]] = "Greater Blessing of Wisdom",
    [____exports.Paladin.GreaterBlessingSalvation[1]] = "Greater Blessing of Salvation",
    [____exports.Paladin.GreaterBlessingLight[1]] = "Greater Blessing of Light",
    [____exports.Warrior.VictoryRush] = "Victory Rush",
    [____exports.Warrior.SpearingStrike] = "Spearing Strike",
    [____exports.Paladin.HolyStrike] = "Holy Strike",
    [____exports.Paladin.LightsVigil] = "Light's Vigil",
    [____exports.Paladin.VoiceOfTruth] = "Voice of Truth",
    [____exports.Paladin.TemplarsBulwark] = "Templar's Bulwark",
    [____exports.Paladin.SwiftJudgement] = "Swift Judgement",
    [____exports.Paladin.JudgementOfTheCrusader] = "Judgement of the Crusader",
    [____exports.Paladin.JudgementOfJustice] = "Judgement of Justice",
    [____exports.Paladin.JudgementOfLight] = "Judgement of Light",
    [____exports.Paladin.JudgementOfWisdom] = "Judgement of Wisdom",
    [____exports.Mage.FireVulnerability] = "Fire Vulnerability",
    [____exports.Mage.WintersChill] = "Winter's Chill",
    [____exports.Hunter.TranquilizingShot] = "Tranquilizing Shot",
    [____exports.Hunter.EnchantedFlare] = "Enchanted Flare",
    [____exports.Hunter.Flare] = "Flare",
    [____exports.Hunter.DistractingShot] = "Distracting Shot",
    [____exports.Rogue.Preparation] = "Preparation",
    [____exports.Hunter.StriderKick] = "Strider Kick",
    [____exports.Hunter.SummonHawk] = "Summon Hawk",
    [____exports.Hunter.SniperShot] = "Sniper Shot",
    [____exports.Hunter.ScatterShot] = "Scatter Shot",
    [____exports.Hunter.Lacerate] = "Lacerate",
    [____exports.Rogue.Venom] = "Venom",
    [____exports.Warlock.BaneOfHavoc] = "Bane of Havoc",
    [____exports.Warlock.Wrack] = "Wrack",
    [____exports.Hunter.HydraShot] = "Hydra Shot",
    [____exports.Rogue.Mutilate] = "Mutilate",
    [____exports.Priest.Chastise] = "Chastise",
    [____exports.Priest.ConfoundingFlash] = "Confounding Flash",
    [____exports.Priest.DarkSacrifice] = "Dark Sacrifice",
    [____exports.Priest.DivineGrace] = "Divine Grace",
    [____exports.Priest.ContingencyPlan] = {"Contingency Plan", "Emergency Plan"},
    [____exports.Priest.Penance] = "Penance",
    [____exports.Priest.PrayerOfMending] = "Prayer of Mending",
    [____exports.Priest.BindingHeal] = "Binding Heal",
    [____exports.Priest.ShadowWordDeath] = {"Shadow Word: Death", "Shadow Word:Death"},
    [____exports.Shaman.CallOfTheElements] = "Call of the Elements",
    [____exports.Shaman.CallOfTheAncestors] = "Call of the Ancestors",
    [____exports.Shaman.CallOfTheSpirits] = "Call of the Spirits",
    [____exports.Shaman.TotemicRecall] = "Totemic Recall",
    [____exports.Shaman.LavaBurst] = "Lava Burst",
    [____exports.Shaman.Riptide] = "Riptide",
    [____exports.Shaman.TotemicProjection] = "Totemic Projection",
    [____exports.Shaman.FireNovaTotem] = {"Fire Nova", "Fire Nova Totem"},
    [____exports.Mage.FrostfireBolt] = "Frostfire Bolt",
    [____exports.Mage.IceLance] = "Ice Lance",
    [____exports.Mage.ArcaneBlast] = "Arcane Blast",
    [____exports.Warlock.Incinerate] = "Incinerate",
    [____exports.Warlock.CurseOfAgony] = {"Bane of Agony", "Curse of Agony"},
    [____exports.Warlock.SummonIncubus] = "Summon Incubus",
    [____exports.Druid.FeralChargeCat] = "Feral Charge",
    [____exports.Druid.Lacerate] = "Lacerate",
    [____exports.Druid.Mangle] = {"Mangle", "Mangle (Bear)", "Mangle (Cat)"},
    [____exports.Druid.Berserk] = "Berserk",
    [____exports.Druid.WildGrowth] = "Wild Growth",
    [____exports.Racial.Cannibalize] = "Cannibalize",
    [____exports.Racial.Eureka] = {"Eureka!", "Eureka"},
    [____exports.Racial.WillToSurvive] = "Will to Survive",
    [____exports.Racial.ElunesLight] = "Elune's Light",
    [____exports.Racial.ShatterCurse] = "Shatter Curse",
    [____exports.Racial.RapidRegeneration] = "Rapid Regeneration"
}
--- Every table above, by name: what the check goes through. A new table is added here too.
____exports.SPELLS = {
    Consumable = ____exports.Consumable,
    Cure = ____exports.Cure,
    Druid = ____exports.Druid,
    Hunter = ____exports.Hunter,
    Mage = ____exports.Mage,
    Paladin = ____exports.Paladin,
    Priest = ____exports.Priest,
    Racial = ____exports.Racial,
    Rogue = ____exports.Rogue,
    Shaman = ____exports.Shaman,
    Tracking = ____exports.Tracking,
    Warlock = ____exports.Warlock,
    Warrior = ____exports.Warrior
}
return ____exports
 end,
["packages.@wowkit.wow-data.src.index"] = function(...) 
local ____exports = {}
do
    local ____export = require("packages.@wowkit.wow-data.src.items")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow-data.src.spells")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
return ____exports
 end,
["packages.@wowkit.wow.src.spells_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local trimText = ____core.trimText
local ____spell_2Dbook_2Eservice = require("packages.@wowkit.wow.src.spell-book_service")
local isJunkSpellName = ____spell_2Dbook_2Eservice.isJunkSpellName
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local tryCall = ____protected_2Dcall_2Eutils.tryCall
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local SPELL_NAME_HINT = ____wow_2Ddata.SPELL_NAME_HINT
____exports.SpellsService = __TS__Class()
local SpellsService = ____exports.SpellsService
SpellsService.name = "SpellsService"
function SpellsService.prototype.____constructor(self, book, bus)
    self.book = book
    self.bus = bus
    self.resolveCache = {}
    self.findAlias = function(spellId) return spellId end
end
function SpellsService.prototype.onFirstLogin(self)
    self:invalidateSpells(true)
    self:rebuildSpellBook(false)
end
function SpellsService.prototype.noteSpellBookBuilt(self)
    self:invalidateSpells(false)
    C_Timer.After(
        0,
        function() return self.bus:emit("spellbook.indexed") end
    )
end
__TS__DecorateLegacy(
    {OnEvent("spellbook.built")},
    SpellsService.prototype,
    "noteSpellBookBuilt",
    true
)
function SpellsService.prototype.useIdAlias(self, alias)
    self.findAlias = alias
end
function SpellsService.prototype.forgetResolved(self, spellId)
    self.resolveCache[spellId] = nil
end
function SpellsService.prototype.getSpellInfo(self, spellId)
    if spellId == nil then
        return nil
    end
    return attempt(
        C_Spell.GetSpellInfo,
        self.findAlias(spellId)
    )
end
function SpellsService.prototype.getSpellName(self, spellId)
    local info = self:getSpellInfo(spellId)
    local ____info_0
    if info then
        ____info_0 = getReadable(info.name)
    else
        ____info_0 = nil
    end
    return ____info_0
end
function SpellsService.prototype.rebuildSpellBook(self, isImmediate)
    self.book:rebuild(isImmediate)
end
function SpellsService.prototype.resolveFromName(self, name)
    if name == nil or name == "" or isJunkSpellName(name) then
        return nil
    end
    return self:findPlayerSpellByName(name) or self:lookUpSpellId(name)
end
function SpellsService.prototype.getHintName(self, spellId)
    return self:getHintNames(spellId)[1]
end
function SpellsService.prototype.getHintNames(self, spellId)
    local ____temp_1
    if spellId ~= nil then
        ____temp_1 = SPELL_NAME_HINT[spellId]
    else
        ____temp_1 = nil
    end
    local hint = ____temp_1
    if hint == nil then
        return {}
    end
    return type(hint) == "string" and ({hint}) or hint
end
function SpellsService.prototype.getSpellLabel(self, spellId)
    return self:getSpellName(spellId) or self:getHintName(spellId)
end
function SpellsService.prototype.invalidateSpells(self, shouldDropSpellBook)
    for id, resolved in pairs(self.resolveCache) do
        if shouldDropSpellBook or resolved == false then
            self.resolveCache[id] = nil
        end
    end
    if shouldDropSpellBook then
        self.book:invalidate()
    end
    self.bus:emit("spells.invalidated")
end
function SpellsService.prototype.resolve(self, spellId)
    if spellId == nil then
        return nil
    end
    local cached = self.resolveCache[spellId]
    if cached ~= nil then
        local ____temp_2
        if cached == false then
            ____temp_2 = nil
        else
            ____temp_2 = cached
        end
        return ____temp_2
    end
    local id = self:findKnownId(self.findAlias(spellId))
    self.resolveCache[spellId] = id or false
    return id
end
function SpellsService.prototype.resolveOrSame(self, spellId)
    return self:resolve(spellId) or spellId
end
function SpellsService.prototype.isLearned(self, spellId)
    return self:resolve(spellId) ~= nil
end
function SpellsService.prototype.isCastable(self, spellId)
    local didSucceed, isUsable = attemptMulti(function() return C_Spell.IsSpellUsable(self.findAlias(spellId)) end)
    if not didSucceed or not isReadable(isUsable) then
        return nil
    end
    return isUsable == true
end
function SpellsService.prototype.getSpellTooltipTexts(self, spellId)
    local tooltip = attempt(
        C_TooltipInfo.GetSpellByID,
        self.findAlias(spellId)
    )
    if tooltip == nil or type(tooltip) ~= "table" then
        return nil
    end
    local texts = {}
    for ____, line in ipairs(tooltip.lines or ({})) do
        for ____, text in ipairs({
            getReadable(line.leftText),
            getReadable(line.rightText)
        }) do
            if text ~= nil then
                texts[#texts + 1] = text
            end
        end
    end
    return texts
end
function SpellsService.prototype.readTooltipReagents(self, spellId)
    local word = _G.SPELL_REAGENTS
    local own = type(word) == "string" and trimText((string.match(word, "^([^%%|]*)")) or "") or ""
    local labels = own ~= "" and ({own, "Reagents:", "Reagent:"}) or ({"Reagents:", "Reagent:"})
    for ____, text in ipairs(self:getSpellTooltipTexts(spellId) or ({})) do
        for ____, label in ipairs(labels) do
            if string.sub(text, 1, #label) == label then
                return string.sub(text, #label + 1)
            end
        end
    end
    return nil
end
function SpellsService.prototype.listSpellBookIds(self)
    return self.book:listSpellIds()
end
function SpellsService.prototype.getSpellRank(self, spellId)
    local text = getReadable(attempt(
        C_Spell.GetSpellSubtext,
        self.findAlias(spellId)
    ))
    if text == nil then
        return nil
    end
    local digits = string.match(text, "(%d+)")
    local ____temp_3
    if digits ~= nil then
        ____temp_3 = tonumber(digits)
    else
        ____temp_3 = nil
    end
    return ____temp_3
end
function SpellsService.prototype.noteLearnedSpell(self, spellId)
    local id = getReadable(spellId)
    local name = self:getSpellName(id)
    if id ~= nil and name ~= nil and name ~= "" then
        self.book:noteLearned(id, name)
    end
end
function SpellsService.prototype.getHighestRank(self, spellId)
    local name = self:getSpellName(spellId)
    if name == nil or name == "" then
        return nil
    end
    local best
    for ____, id in ipairs(self.book:getRanksByName(name)) do
        local rank = self:getSpellRank(id)
        if rank ~= nil and (best == nil or rank > best) then
            best = rank
        end
    end
    return best
end
function SpellsService.prototype.lookUpSpellId(self, name)
    if isJunkSpellName(name) then
        return nil
    end
    local info = attempt(C_Spell.GetSpellInfo, name)
    if not info then
        return nil
    end
    local id = getReadable(info.spellID)
    local got = getReadable(info.name)
    if id ~= nil and (got == nil or got == name) and not isJunkSpellName(got or name) then
        return id
    end
    return nil
end
function SpellsService.prototype.isKnownToPlayer(self, id)
    return attempt(C_SpellBook.IsSpellKnown, id) == true or attempt(C_SpellBook.IsSpellInSpellBook, id) == true
end
function SpellsService.prototype.findPlayerSpellByName(self, name)
    if self.book:isReady() then
        return self.book:findSpellIdByName(name)
    end
    local fromApi = self:lookUpSpellId(name)
    if fromApi ~= nil and self:isKnownToPlayer(fromApi) then
        return fromApi
    end
    if not self.book:isBuilding() then
        self.book:rebuild(false)
    end
    return nil
end
function SpellsService.prototype.findOverride(self, spellId)
    local didSucceed, override = tryCall(C_Spell.GetOverrideSpell, spellId)
    return didSucceed and isReadable(override) and type(override) == "number" and override or spellId
end
function SpellsService.prototype.listSpellNames(self, spellId, overrideId)
    local names = {}
    local ____array_4 = __TS__SparseArrayNew(
        self:getSpellName(overrideId) or self:getSpellName(spellId),
        unpack(self:getHintNames(spellId))
    )
    __TS__SparseArrayPush(
        ____array_4,
        unpack(self:getHintNames(overrideId))
    )
    for ____, name in ipairs({__TS__SparseArraySpread(____array_4)}) do
        if name ~= nil and name ~= "" and not __TS__ArrayIncludes(names, name) then
            names[#names + 1] = name
        end
    end
    return names
end
function SpellsService.prototype.findKnownIdByNames(self, names)
    for ____, name in ipairs(names) do
        local fromName = self:lookUpSpellId(name)
        if fromName ~= nil and self:isKnownToPlayer(fromName) then
            return fromName
        end
        local bookId = self:findPlayerSpellByName(name)
        if bookId ~= nil then
            return bookId
        end
    end
    return nil
end
function SpellsService.prototype.findKnownId(self, spellId)
    local id = self:findOverride(spellId)
    if self:isKnownToPlayer(id) then
        return id
    end
    if id ~= spellId and self:isKnownToPlayer(spellId) then
        return spellId
    end
    return self:findKnownIdByNames(self:listSpellNames(spellId, id))
end
return ____exports
 end,
["packages.@wowkit.wow.src.bar-names"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArrayPush = ____lualib.__TS__ArrayPush
local ____exports = {}
--- The bars of Edit Mode, 1 to 8, by the prefix of their buttons' names.
____exports.BARS = {
    "Action",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarRight",
    "MultiBarLeft",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7"
}
--- Bartender4's buttons (LibActionButton-1.0, which keeps the action slot where Blizzard's buttons do): BT4Button1 to
-- BT4Button180, 12 to a bar. Where Bartender4 is not loaded there are none.
____exports.BARTENDER_PREFIX = "BT4Button"
____exports.BARTENDER_BUTTONS = 180
--- Dominos's action buttons, 1 to 168, 12 to a bar: made from Blizzard's template, so they keep the slot where Blizzard's
-- do, under the names Dominos gives them (its GetActionButtonName): the last button of each run, and the run's prefix.
____exports.DOMINOS_BUTTONS = 168
local DOMINOS_RUNS = {
    {24, "DominosActionButton"},
    {36, "MultiBarRightActionButton"},
    {48, "MultiBarLeftActionButton"},
    {60, "MultiBarBottomRightActionButton"},
    {72, "MultiBarBottomLeftActionButton"},
    {132, "DominosActionButton"},
    {144, "MultiBar5ActionButton"},
    {156, "MultiBar6ActionButton"},
    {168, "MultiBar7ActionButton"}
}
--- EllesmereUI's action buttons (its Action Bars module): made from Blizzard's template, so they keep the slot where
-- Blizzard's do, and named after the first slot of their bar, which paging does not change: EABButton61 is the first
-- button of its Action Bar 2. The first slot of each of its bars 1 to 8, less one (its EUI_ActionBars_Secure.lua).
____exports.ELLESMERE_PREFIX = "EABButton"
local ELLESMERE_BAR_OFFSETS = {
    0,
    60,
    48,
    24,
    36,
    144,
    156,
    168
}
--- EllesmereUI's bars 9 and 10, of no Blizzard bar: their buttons are mapped, but on no numbered bar.
local ELLESMERE_EXTRA_OFFSETS = {12, 108}
--- The bar (1 to 8) of EllesmereUI's button for this first slot; undefined for its bars 9 and 10.
local function findEllesmereBar(slot)
    local index = __TS__ArrayFindIndex(
        ELLESMERE_BAR_OFFSETS,
        function(____, offset) return slot > offset and slot <= offset + 12 end
    )
    return index >= 0 and index + 1 or nil
end
--- ElvUI's action buttons (LibActionButton-1.0, the slot in `action`): ElvUI_Bar1Button1 to ElvUI_Bar15Button12, its bar N
-- on the slots of page N by default (its AB.barDefaults); so its bar 6 (slots 61 to 72) is Action Bar 2, as the first
-- slots of Blizzard's bars say. Its bars 2 and 7 to 10 are of no Blizzard bar; 11 and 12 it does not make.
____exports.ELVUI_PREFIX = "ElvUI_Bar"
local ELVUI_BARS = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    13,
    14,
    15
}
--- DaylightUI's action buttons (Blizzard's template: the slot in `action`): DaylightUIBar1Button1 to DaylightUIBar8Button12,
-- its bar N counting as Action Bar N (as its author says).
____exports.DAYLIGHT_PREFIX = "DaylightUIBar"
--- The name of ElvUI's button `index` (1 to 12) of its bar `bar`.
local function getElvUIButtonName(bar, index)
    return ((____exports.ELVUI_PREFIX .. tostring(bar)) .. "Button") .. tostring(index)
end
--- Dominos's button numbers by name, made when first asked.
local dominosNumbers
--- The name of Dominos's button of this number (1 to 168): its own buttons count on, Blizzard-named runs from 1.
function ____exports.getDominosButtonName(id)
    local first = 1
    for ____, ____value in ipairs(DOMINOS_RUNS) do
        local last = ____value[1]
        local prefix = ____value[2]
        if id <= last then
            return prefix == "DominosActionButton" and prefix .. tostring(id) or prefix .. tostring(id - first + 1)
        end
        first = last + 1
    end
    return nil
end
--- The number of Dominos's button of this name; undefined for another name.
local function findDominosNumber(name)
    if dominosNumbers == nil then
        dominosNumbers = {}
        do
            local id = 1
            while id <= ____exports.DOMINOS_BUTTONS do
                dominosNumbers[____exports.getDominosButtonName(id)] = id
                id = id + 1
            end
        end
    end
    return dominosNumbers[name]
end
--- The names of every action button of the bar addons: Bartender4's, Dominos's, EllesmereUI's (its bars 1 to 10), ElvUI's,
-- DaylightUI's.
function ____exports.listAddonButtonNames()
    local names = {}
    do
        local i = 1
        while i <= ____exports.BARTENDER_BUTTONS do
            names[#names + 1] = ____exports.BARTENDER_PREFIX .. tostring(i)
            i = i + 1
        end
    end
    do
        local i = 1
        while i <= ____exports.DOMINOS_BUTTONS do
            names[#names + 1] = ____exports.getDominosButtonName(i)
            i = i + 1
        end
    end
    local ____array_0 = __TS__SparseArrayNew(unpack(ELLESMERE_BAR_OFFSETS))
    __TS__SparseArrayPush(
        ____array_0,
        unpack(ELLESMERE_EXTRA_OFFSETS)
    )
    for ____, offset in ipairs({__TS__SparseArraySpread(____array_0)}) do
        do
            local i = 1
            while i <= 12 do
                names[#names + 1] = ____exports.ELLESMERE_PREFIX .. tostring(offset + i)
                i = i + 1
            end
        end
    end
    for ____, bar in ipairs(ELVUI_BARS) do
        do
            local i = 1
            while i <= 12 do
                names[#names + 1] = getElvUIButtonName(bar, i)
                i = i + 1
            end
        end
    end
    do
        local bar = 1
        while bar <= #____exports.BARS do
            do
                local i = 1
                while i <= 12 do
                    names[#names + 1] = ((____exports.DAYLIGHT_PREFIX .. tostring(bar)) .. "Button") .. tostring(i)
                    i = i + 1
                end
            end
            bar = bar + 1
        end
    end
    return names
end
--- The bar (1 to 8) a button of this name is on; undefined for a button of no numbered bar (the totem bar, the stance bar).
function ____exports.findBarNumber(name)
    local dominosNumber = findDominosNumber(name)
    if dominosNumber ~= nil then
        local bar = math.ceil(dominosNumber / 12)
        return bar <= #____exports.BARS and bar or nil
    end
    local ellesmereSlot = string.match(name, ("^" .. ____exports.ELLESMERE_PREFIX) .. "(%d+)$")
    if ellesmereSlot ~= nil then
        return findEllesmereBar(tonumber(ellesmereSlot))
    end
    local daylightBar = string.match(name, ("^" .. ____exports.DAYLIGHT_PREFIX) .. "(%d+)Button%d+$")
    if daylightBar ~= nil then
        local ____temp_1
        if tonumber(daylightBar) <= #____exports.BARS then
            ____temp_1 = tonumber(daylightBar)
        else
            ____temp_1 = nil
        end
        return ____temp_1
    end
    local elvBar = string.match(name, ("^" .. ____exports.ELVUI_PREFIX) .. "(%d+)Button%d+$")
    if elvBar ~= nil then
        return findEllesmereBar((tonumber(elvBar) - 1) * 12 + 1)
    end
    local bartenderIndex = string.match(name, ("^" .. ____exports.BARTENDER_PREFIX) .. "(%d+)$")
    if bartenderIndex ~= nil then
        local bar = math.ceil(tonumber(bartenderIndex) / 12)
        return bar <= #____exports.BARS and bar or nil
    end
    local prefix = string.match(name, "^(.-)Button%d+$")
    local index = prefix ~= nil and __TS__ArrayIndexOf(____exports.BARS, prefix) or -1
    return index >= 0 and index + 1 or nil
end
--- The names of the buttons of a bar (1 to 8): Blizzard's, and Bartender4's, Dominos's, EllesmereUI's, ElvUI's and
-- DaylightUI's of the same number.
function ____exports.listBarButtonNames(bar)
    local prefix = ____exports.BARS[bar]
    if prefix == nil then
        return {}
    end
    local names = {}
    do
        local i = 1
        while i <= 12 do
            local id = (bar - 1) * 12 + i
            __TS__ArrayPush(
                names,
                (prefix .. "Button") .. tostring(i),
                ____exports.BARTENDER_PREFIX .. tostring(id),
                ____exports.getDominosButtonName(id),
                ____exports.ELLESMERE_PREFIX .. tostring(ELLESMERE_BAR_OFFSETS[bar] + i),
                getElvUIButtonName(ELLESMERE_BAR_OFFSETS[bar] / 12 + 1, i),
                ((____exports.DAYLIGHT_PREFIX .. tostring(bar)) .. "Button") .. tostring(i)
            )
            i = i + 1
        end
    end
    return names
end
return ____exports
 end,
["packages.@wowkit.wow.src.gamepad-buttons"] = function(...) 
local ____exports = {}
local GAMEPAD_BAR = "GamepadMainActionBarFrame"
--- How deep the buttons of the gamepad bars sit under their frame, at most.
local GAMEPAD_DEPTH = 6
--- Every child of the gamepad bars' frame, at any depth, that shows an action slot; none outside gamepad mode.
function ____exports.listGamepadButtons()
    local found = {}
    local addButtonsUnder
    addButtonsUnder = function(frame, depth)
        if depth > GAMEPAD_DEPTH then
            return
        end
        for ____, child in ipairs({frame:GetChildren()}) do
            if type(child.action) == "number" then
                found[#found + 1] = child
            else
                addButtonsUnder(child, depth + 1)
            end
        end
    end
    local root = _G[GAMEPAD_BAR]
    if root ~= nil then
        addButtonsUnder(root, 0)
    end
    return found
end
return ____exports
 end,
["packages.@wowkit.wow.src.action-bars_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayPushArray = ____lualib.__TS__ArrayPushArray
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local trimText = ____core.trimText
local ____item_2Dbutton_2Eutils = require("packages.@wowkit.wow.src.utils.item-button_utils")
local findButtonItem = ____item_2Dbutton_2Eutils.findButtonItem
local getItemButtonKey = ____item_2Dbutton_2Eutils.getItemButtonKey
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadableId = ____secret_2Dvalue_2Eutils.getReadableId
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
local ____bar_2Dnames = require("packages.@wowkit.wow.src.bar-names")
local BARS = ____bar_2Dnames.BARS
local findBarNumber = ____bar_2Dnames.findBarNumber
local listAddonButtonNames = ____bar_2Dnames.listAddonButtonNames
local ____gamepad_2Dbuttons = require("packages.@wowkit.wow.src.gamepad-buttons")
local listGamepadButtons = ____gamepad_2Dbuttons.listGamepadButtons
--- Buttons mapped per frame.
local MAP_BUDGET = 20
--- Mapping is skipped when the last one is more recent than this (unless forced).
local MAP_THROTTLE = 2
--- An icon on more buttons than this is a generic one, not a particular spell's.
local MAX_BUTTONS_PER_ICON = 4
____exports.ActionBarsService = __TS__Class()
local ActionBarsService = ____exports.ActionBarsService
ActionBarsService.name = "ActionBarsService"
function ActionBarsService.prototype.____constructor(self, clock, spells, bus, registry)
    self.clock = clock
    self.spells = spells
    self.bus = bus
    self.registry = registry
    self.buttonsBySpell = {}
    self.buttonsByName = {}
    self.buttonsByNameKey = {}
    self.buttonsByIcon = {}
    self.slotByButton = {}
    self.lastMapAt = 0
    self.mapGeneration = 0
    self.barsChangedAt = -10
end
function ActionBarsService.prototype.onFirstLogin(self)
    self:mapBars(true)
end
function ActionBarsService.prototype.noteBarsChanged(self)
    self.barsChangedAt = self.clock:getCurrentTime()
end
function ActionBarsService.prototype.getSecondsSinceBarsChanged(self)
    return self.clock:getCurrentTime() - self.barsChangedAt
end
function ActionBarsService.prototype.mapBars(self, isForced)
    if not isForced and self.lastMapAt > 0 and self.clock:getCurrentTime() - self.lastMapAt < MAP_THROTTLE then
        return
    end
    self:clear(self.buttonsBySpell)
    self:clear(self.buttonsByName)
    self:clear(self.buttonsByNameKey)
    self:clear(self.buttonsByIcon)
    self:clear(self.slotByButton)
    self.lastMapAt = self.clock:getCurrentTime()
    local queue = self:listButtonsToMap()
    self.mapGeneration = self.mapGeneration + 1
    local generation = self.mapGeneration
    local next = 0
    local mapNextButtons
    mapNextButtons = function()
        if generation ~= self.mapGeneration then
            return
        end
        do
            local budget = MAP_BUDGET
            while next < #queue and budget > 0 do
                local ____next_0 = next
                next = ____next_0 + 1
                local entry = queue[____next_0 + 1]
                if entry.spellButton ~= nil then
                    self:addSpell(entry.spellButton.spellID, entry.spellButton)
                elseif not (entry.stance ~= nil) then
                    self:addButton(entry.button)
                elseif entry.button then
                    local didSucceed, ____, ____, ____, spellId = attemptMulti(function() return GetShapeshiftFormInfo(entry.stance) end)
                    if didSucceed then
                        self:addSpell(spellId, entry.button)
                    end
                end
                budget = budget - 1
            end
        end
        if next < #queue then
            C_Timer.After(0, mapNextButtons)
        else
            self.bus:emit("bars.mapped")
        end
    end
    mapNextButtons()
end
function ActionBarsService.prototype.getBarNumber(self, button)
    if self.registry:isRegistered(button) then
        return self.registry:findBar(button)
    end
    return findBarNumber(button:GetName() or "")
end
function ActionBarsService.prototype.isRegistered(self, button)
    return self.registry:isRegistered(button)
end
function ActionBarsService.prototype.getButtonShape(self, button)
    return self.registry:findShape(button) or button.activeButtonShape
end
function ActionBarsService.prototype.findButtonsOf(self, spellId)
    local out = {}
    local seen = {}
    local function take(list)
        for ____, button in ipairs(list or ({})) do
            if not (seen[button] ~= nil) then
                seen[button] = true
                out[#out + 1] = button
            end
        end
    end
    local id = getReadableId(spellId)
    local resolved = getReadableId(self.spells:resolve(spellId))
    if id ~= nil then
        take(self.buttonsBySpell[id])
    end
    if resolved ~= nil and resolved ~= id then
        take(self.buttonsBySpell[resolved])
    end
    local name = self:getReadableSpellName(id) or self:getReadableSpellName(resolved)
    if name ~= nil then
        take(self.buttonsByName[name])
        local key = self:buildButtonKey(name)
        if key ~= nil then
            take(self.buttonsByNameKey[key])
        end
    end
    if #out == 0 then
        for ____, list in ipairs(self:listIconButtons(id, resolved)) do
            take(list)
        end
    end
    return out
end
function ActionBarsService.prototype.listIconButtons(self, id, resolved)
    local icons = {}
    self:addIconKeys(id, icons)
    self:addIconKeys(resolved or id, icons)
    local lists = {}
    for key in pairs(icons) do
        local list = self.buttonsByIcon[key]
        if list and #list > 0 and #list <= MAX_BUTTONS_PER_ICON then
            lists[#lists + 1] = list
        end
    end
    return lists
end
function ActionBarsService.prototype.findSlotOf(self, spellId)
    for ____, button in ipairs(self:findButtonsOf(spellId)) do
        local slot = self.slotByButton[button]
        if slot ~= nil then
            return slot
        end
    end
    return nil
end
function ActionBarsService.prototype.isMapped(self)
    return self.lastMapAt > 0
end
function ActionBarsService.prototype.isOnBars(self, spellId)
    return #self:findButtonsOf(spellId) > 0
end
function ActionBarsService.prototype.listSpellIdsOnBars(self)
    local ids = {}
    for id in pairs(self.buttonsBySpell) do
        ids[#ids + 1] = id
    end
    return ids
end
function ActionBarsService.prototype.getReadableSpellName(self, spellId)
    local id = getReadableId(spellId)
    if id == nil then
        return nil
    end
    local ____opt_1 = self.spells:getSpellInfo(id)
    local name = ____opt_1 and ____opt_1.name
    return name ~= nil and isReadable(name) and name ~= "" and name or nil
end
function ActionBarsService.prototype.addSpellName(self, name, button)
    self:push(self.buttonsByName, name, button)
    local key = self:buildButtonKey(name)
    if key ~= nil then
        self:push(self.buttonsByNameKey, key, button)
    end
end
function ActionBarsService.prototype.addSpell(self, spellId, button)
    local id = getReadableId(spellId)
    if id == nil then
        return
    end
    self:push(self.buttonsBySpell, id, button)
    local name = self:getReadableSpellName(id)
    if name ~= nil then
        self:addSpellName(name, button)
    end
end
function ActionBarsService.prototype.addIcons(self, button, slot)
    local function add(value)
        local key = self:getTextureKey(value)
        if key ~= nil then
            self:push(self.buttonsByIcon, key, button)
        end
    end
    add(attempt(C_ActionBar.GetActionTexture, slot))
    local name = button:GetName()
    local ____temp_4 = button.icon or button.Icon
    if ____temp_4 == nil then
        local ____temp_3
        if name ~= nil then
            ____temp_3 = self:getGlobal(name .. "Icon")
        else
            ____temp_3 = nil
        end
        ____temp_4 = ____temp_3
    end
    local icon = ____temp_4
    if icon then
        add(attempt(function() return icon:GetTexture() end))
    end
end
function ActionBarsService.prototype.addMacroSpells(self, macro, button)
    local body = attempt(GetMacroBody, macro)
    if body == nil or not isReadable(body) then
        return
    end
    for line in string.gmatch(body, "[^\r\n]+") do
        local command = string.match(line, "^%s*#showtooltip%s+(.+)$")
        if command == nil then
            command = string.match(line, "^%s*/%S+%s+(.+)$")
        end
        if command ~= nil then
            local cleaned = string.gsub(command, "%b[]", " ")
            for rawToken in string.gmatch(cleaned, "[^,;]+") do
                self:addMacroToken(rawToken, button)
            end
        end
    end
end
function ActionBarsService.prototype.addMacroToken(self, rawToken, button)
    local token = string.gsub(
        strtrim(rawToken),
        "^!",
        ""
    )
    token = string.gsub(token, "%s*%([^)]*%)%s*$", "")
    if token == "" then
        return
    end
    local info = attempt(C_Spell.GetSpellInfo, token)
    if info == nil or type(info) ~= "table" then
        return
    end
    self:addSpellName(
        isReadable(info.name) and info.name ~= "" and info.name or token,
        button
    )
    self:addSpell(info.spellID, button)
end
function ActionBarsService.prototype.addButton(self, button)
    local slot = self:getActionSlot(button)
    local kind, id = self:getButtonAction(button, slot)
    if kind == "macro" and id ~= nil then
        local macro = id
        local macroSpell = getReadableId(attempt(GetMacroSpell, macro))
        if macroSpell ~= nil then
            kind, id = "spell", macroSpell
        end
        self:addMacroSpells(macro, button)
    end
    if slot ~= nil then
        self.slotByButton[button] = slot
    end
    local itemId = findButtonItem(self, button)
    if itemId ~= nil then
        self:push(
            self.buttonsBySpell,
            getItemButtonKey(itemId),
            button
        )
    end
    if slot ~= nil and attempt(C_ActionBar.HasAction, slot) == true then
        self:addIcons(button, slot)
    end
    if kind == "spell" and id ~= nil then
        local ____self_addSpell_8 = self.addSpell
        local ____getReadableId_7 = getReadableId
        local ____opt_5 = self.spells:getSpellInfo(getReadableId(id))
        ____self_addSpell_8(
            self,
            ____getReadableId_7(____opt_5 and ____opt_5.spellID) or getReadableId(id),
            button
        )
    end
end
function ActionBarsService.prototype.addIconKeys(self, spellId, keys)
    if spellId == nil then
        return
    end
    local function add(value)
        local key = self:getTextureKey(value)
        if key ~= nil then
            keys[key] = true
        end
    end
    add(attempt(function() return C_Spell.GetSpellTexture(spellId) end))
    local info = self.spells:getSpellInfo(spellId)
    if info then
        add(info.iconID)
        add(info.originalIconID)
    end
end
function ActionBarsService.prototype.push(self, map, key, button)
    local list = map[key]
    if list then
        list[#list + 1] = button
    else
        map[key] = {button}
    end
end
function ActionBarsService.prototype.clear(self, map)
    for key in pairs(map) do
        map[key] = nil
    end
end
function ActionBarsService.prototype.listButtonsToMap(self)
    local queue = {}
    local function add(name)
        local button = self:getGlobal(name)
        if button then
            queue[#queue + 1] = {button = button}
        end
    end
    for ____, bar in ipairs(BARS) do
        do
            local i = 1
            while i <= 12 do
                add((bar .. "Button") .. tostring(i))
                i = i + 1
            end
        end
    end
    do
        local i = 1
        while i <= 12 do
            add("MultiCastActionButton" .. tostring(i))
            i = i + 1
        end
    end
    for ____, name in ipairs(listAddonButtonNames()) do
        add(name)
    end
    for ____, button in ipairs(listGamepadButtons()) do
        queue[#queue + 1] = self:getActionSlot(button) == nil and ({spellButton = button}) or ({button = button})
    end
    local forms = attempt(GetNumShapeshiftForms) or 0
    do
        local i = 1
        while i <= forms do
            for ____, name in ipairs({
                "StanceButton" .. tostring(i),
                "BT4StanceButton" .. tostring(i),
                "DominosStanceButton" .. tostring(i),
                "ElvUI_StanceBarButton" .. tostring(i)
            }) do
                queue[#queue + 1] = {
                    stance = i,
                    button = self:getGlobal(name)
                }
            end
            i = i + 1
        end
    end
    __TS__ArrayPushArray(
        queue,
        self:listRegisteredToMap(forms)
    )
    return queue
end
function ActionBarsService.prototype.listRegisteredToMap(self, forms)
    local queue = __TS__ArrayMap(
        self.registry:listActionButtons(),
        function(____, button) return {button = button} end
    )
    for ____, ____value in ipairs(self.registry:listStanceButtons()) do
        local button = ____value[1]
        local stance = ____value[2]
        if stance <= forms then
            queue[#queue + 1] = {stance = stance, button = button}
        end
    end
    return queue
end
function ActionBarsService.prototype.getGlobal(self, name)
    return _G[name]
end
function ActionBarsService.prototype.isToken(self, value, expected)
    return isReadable(value) and value == expected
end
function ActionBarsService.prototype.getTextureKey(self, value)
    if not isReadable(value) or value == 0 or value == "" then
        return nil
    end
    if type(value) == "number" and value > 0 then
        return value
    end
    if type(value) == "string" then
        return string.lower(value)
    end
    return nil
end
function ActionBarsService.prototype.getActionSlot(self, button)
    local function getValidSlot(slot)
        return slot ~= nil and slot ~= 0 and slot or nil
    end
    local ____button_GetPagedID_9
    if button.GetPagedID then
        ____button_GetPagedID_9 = attempt(function() return button:GetPagedID() end)
    else
        ____button_GetPagedID_9 = nil
    end
    local ____getValidSlot_result_11 = getValidSlot(____button_GetPagedID_9)
    if ____getValidSlot_result_11 == nil then
        local ____button_CalculateAction_10
        if button.CalculateAction then
            ____button_CalculateAction_10 = attempt(function() return button:CalculateAction() end)
        else
            ____button_CalculateAction_10 = nil
        end
        ____getValidSlot_result_11 = getValidSlot(____button_CalculateAction_10)
    end
    return ____getValidSlot_result_11 or getValidSlot(button.action) or getValidSlot(tonumber(attempt(function() return button:GetAttribute("action") end)))
end
function ActionBarsService.prototype.findItemSpell(self, actionId)
    local itemId = getReadableId(actionId)
    local didReadItemSpell, ____, itemSpell = attemptMulti(function() return C_Item.GetItemSpell(itemId) end)
    local ____didReadItemSpell_12
    if didReadItemSpell then
        ____didReadItemSpell_12 = getReadableId(itemSpell)
    else
        ____didReadItemSpell_12 = nil
    end
    return ____didReadItemSpell_12
end
function ActionBarsService.prototype.getSlotAction(self, slot)
    local didSucceed, kind, actionId, ____, spellFromAction = attemptMulti(function() return GetActionInfo(slot) end)
    if not didSucceed then
        return nil, nil
    end
    if self:isToken(kind, "spell") then
        return "spell", getReadableId(spellFromAction) or getReadableId(actionId)
    end
    if self:isToken(kind, "macro") then
        return "macro", actionId
    end
    local ____table_isToken_result_13
    if self:isToken(kind, "item") then
        ____table_isToken_result_13 = self:findItemSpell(actionId)
    else
        ____table_isToken_result_13 = nil
    end
    local itemSpell = ____table_isToken_result_13
    if itemSpell ~= nil then
        return "spell", itemSpell
    end
    return nil, nil
end
function ActionBarsService.prototype.getButtonAction(self, button, slot)
    local attrType = attempt(function() return button:GetAttribute("type") end)
    if attrType == "spell" or attrType == "macro" then
        return attrType, attempt(function() return button:GetAttribute(attrType) end)
    end
    if attrType ~= nil and attrType ~= "action" then
        return attrType, nil
    end
    if slot == nil or not attempt(C_ActionBar.HasAction, slot) == true then
        return attrType, nil
    end
    local kind, id = self:getSlotAction(slot)
    return kind or attrType, id
end
function ActionBarsService.prototype.buildButtonKey(self, name)
    local stripped = string.gsub(name, "%s*%([^)]*%)%s*$", "")
    local key = trimText(string.lower(stripped))
    return key ~= "" and key or nil
end
return ____exports
 end,
["packages.@wowkit.wow.src.wow_constants"] = function(...) 
local ____exports = {}
--- Inventory slots of the weapons.
____exports.MAIN_HAND_SLOT = 16
____exports.OFF_HAND_SLOT = 17
____exports.RANGED_SLOT = 18
--- "Seconds left" of something without an end, or whose end the client did not tell.
____exports.NO_EXPIRY = 9999
--- A real, known number of seconds left (not NO_EXPIRY). Anything from 9000 seconds up counts as
-- "no end", leaving a margin below the NO_EXPIRY marker.
function ____exports.hasKnownExpiry(remain)
    return remain > 0 and remain < 9000
end
return ____exports
 end,
["packages.@wowkit.wow.src.auras_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local tryCall = ____protected_2Dcall_2Eutils.tryCall
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
local ____wow_2Econstants = require("packages.@wowkit.wow.src.wow_constants")
local NO_EXPIRY = ____wow_2Econstants.NO_EXPIRY
--- A scan is reused for this long.
local SCAN_REUSE = 0.2
____exports.AurasService = __TS__Class()
local AurasService = ____exports.AurasService
AurasService.name = "AurasService"
function AurasService.prototype.____constructor(self, spells)
    self.spells = spells
    self.scans = {}
end
function AurasService.prototype.wipeAuraScans(self)
    for key in pairs(self.scans) do
        self.scans[key] = nil
    end
end
__TS__DecorateLegacy(
    {OnEvent("spells.invalidated")},
    AurasService.prototype,
    "wipeAuraScans",
    true
)
function AurasService.prototype.wipeAuraScan(self, unit)
    if unit == nil then
        return self:wipeAuraScans()
    end
    for ____, filter in ipairs({"HELPFUL", "HARMFUL", "HARMFUL|PLAYER"}) do
        self.scans[(unit .. "\0") .. filter] = nil
    end
end
function AurasService.prototype.readPlayerAura(self, spellId)
    local resolved = self.spells:resolve(spellId)
    local ____temp_0
    if resolved ~= nil then
        ____temp_0 = self:readPlayerAuraById(resolved)
    else
        ____temp_0 = nil
    end
    local fromResolved = ____temp_0
    local fromId = fromResolved or self:readPlayerAuraById(spellId)
    if fromId then
        return fromId
    end
    local name = self.spells:getSpellName(resolved or spellId) or self.spells:getSpellName(spellId)
    if name == nil or name == "" then
        return nil
    end
    return self:findAuraByName(name, "player", "HELPFUL")
end
function AurasService.prototype.findAuraByName(self, name, unit, filter)
    local named = attempt(C_UnitAuras.GetAuraDataBySpellName, unit, name, filter)
    if named == nil or type(named) ~= "table" then
        return nil
    end
    local entry = self:describeAura(named)
    local ____entry_isHidden_1
    if entry.isHidden then
        ____entry_isHidden_1 = nil
    else
        ____entry_isHidden_1 = {isFound = true, remain = entry.remain, isUnreadable = false, stacks = entry.stacks}
    end
    return ____entry_isHidden_1
end
function AurasService.prototype.scanAuras(self, unit, filter)
    if filter == nil then
        filter = "HELPFUL"
    end
    local now = GetTime()
    local key = (unit .. "\0") .. filter
    local cached = self.scans[key]
    if cached and now - cached.at < SCAN_REUSE then
        return cached.scan
    end
    local scan = {auras = {}, isUnreadable = false}
    do
        local i = 1
        while i <= 40 do
            local didSucceed, aura = tryCall(C_UnitAuras.GetAuraDataByIndex, unit, i, filter)
            if not didSucceed then
                scan.isUnreadable = true
                break
            end
            if aura == nil then
                break
            end
            local entry = self:describeAura(aura)
            if entry.isHidden then
                scan.isUnreadable = true
            end
            local ____scan_auras_2 = scan.auras
            ____scan_auras_2[#____scan_auras_2 + 1] = entry
            i = i + 1
        end
    end
    self.scans[key] = {at = now, scan = scan}
    return scan
end
function AurasService.prototype.readPlayerAuraById(self, spellId)
    local aura = attempt(C_UnitAuras.GetPlayerAuraBySpellID, spellId)
    if aura == nil or type(aura) ~= "table" then
        return nil
    end
    return {
        isFound = true,
        remain = self:getRemainingSeconds(aura),
        isUnreadable = false,
        stacks = self:getStacks(aura)
    }
end
function AurasService.prototype.getStacks(self, aura)
    local stacks = getReadable(aura.applications)
    return stacks ~= nil and type(stacks) == "number" and stacks > 0 and stacks or 1
end
function AurasService.prototype.getRemainingSeconds(self, aura)
    local expiration = getReadable(aura.expirationTime)
    if expiration ~= nil and expiration > 0 then
        return math.max(
            expiration - GetTime(),
            0
        )
    end
    return NO_EXPIRY
end
function AurasService.prototype.findAuraCaster(self, aura)
    local source = getReadable(aura.sourceUnit)
    if source == nil then
        return "hidden"
    end
    return attempt(UnitIsUnit, source, "player") == true and "player" or "other"
end
function AurasService.prototype.describeAura(self, aura)
    local spellId = getReadable(aura.spellId)
    local name = getReadable(aura.name)
    local isHidden = aura.spellId ~= nil and spellId == nil or aura.name ~= nil and name == nil
    if not isHidden and spellId == nil and name == nil then
        isHidden = true
    end
    local dispelType = getReadable(aura.dispelName)
    local ____spellId_4 = spellId
    local ____name_5 = name
    local ____temp_6 = self:getRemainingSeconds(aura)
    local ____isHidden_7 = isHidden
    local ____temp_8 = self:findAuraCaster(aura)
    local ____temp_9 = self:getStacks(aura)
    local ____temp_3
    if type(dispelType) == "string" and dispelType ~= "" then
        ____temp_3 = dispelType
    else
        ____temp_3 = nil
    end
    return {
        spellId = ____spellId_4,
        name = ____name_5,
        remain = ____temp_6,
        isHidden = ____isHidden_7,
        caster = ____temp_8,
        stacks = ____temp_9,
        dispelType = ____temp_3,
        isStealable = isReadable(aura.isStealable) and aura.isStealable == true
    }
end
return ____exports
 end,
["packages.@wowkit.wow.src.bags_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
____exports.BagsService = __TS__Class()
local BagsService = ____exports.BagsService
BagsService.name = "BagsService"
function BagsService.prototype.____constructor(self)
end
function BagsService.prototype.getItemCount(self, itemId)
    return getReadable(attempt(C_Item.GetItemCount, itemId)) or 0
end
function BagsService.prototype.getItemCountByName(self, name)
    return getReadable(attempt(C_Item.GetItemCount, name)) or 0
end
function BagsService.prototype.getItemName(self, itemId)
    return getReadable(attempt(C_Item.GetItemNameByID, itemId))
end
return ____exports
 end,
["packages.@wowkit.wow.src.utils.glow-picture_utils"] = function(...) 
local ____exports = {}
--- How soon to look again at a loop that has not reached a picture yet.
local RETRY_SECONDS = 0.1
--- Stops the loop on the picture it has reached. It may have reached none yet, as the game still loads, and then shows
-- the whole sheet of its pictures: it is looked at again later, unseen until then.
local function applyLoopPicture(alert, picture, sheetWidth, ____then, delay)
    C_Timer.After(
        delay,
        function()
            if not alert:IsShown() then
                return
            end
            local ulX, ulY, llX, llY, urX, urY, lrX, lrY = picture:GetTexCoord()
            if urX - ulX > sheetWidth * 0.9 then
                return applyLoopPicture(
                    alert,
                    picture,
                    sheetWidth,
                    ____then,
                    RETRY_SECONDS
                )
            end
            alert.ProcLoop:Stop()
            picture:SetTexCoord(
                ulX,
                ulY,
                llX,
                llY,
                urX,
                urY,
                lrX,
                lrY
            )
            picture:SetAlpha(1)
            ____then()
        end
    )
end
--- A picture of the loop's flipbook (of this atlas), standing still; `then` runs once it stands (a frame later at the soonest).
function ____exports.showLoopPicture(alert, atlas, ____then)
    local picture = alert.ProcLoopFlipbook
    if picture == nil then
        return
    end
    picture:SetAtlas(atlas)
    picture:SetAlpha(0)
    local sheetLeft, ____, ____, ____, sheetRight = picture:GetTexCoord()
    picture:Show()
    alert.ProcLoop:Play()
    applyLoopPicture(
        alert,
        picture,
        sheetRight - sheetLeft,
        ____then,
        0
    )
end
return ____exports
 end,
["packages.@wowkit.wow.src.value-curves_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
____exports.ValueCurvesService = __TS__Class()
local ValueCurvesService = ____exports.ValueCurvesService
ValueCurvesService.name = "ValueCurvesService"
function ValueCurvesService.prototype.____constructor(self)
    self.curves = {}
end
function ValueCurvesService.prototype.getHealthAlpha(self, unit, thresholdPercent, side)
    local curve = self:getCurve(thresholdPercent, side)
    if curve == nil then
        return nil
    end
    return attempt(UnitHealthPercent, unit, true, curve)
end
function ValueCurvesService.prototype.getManaAlpha(self, thresholdPercent, side)
    local curve = self:getCurve(thresholdPercent, side)
    if curve == nil then
        return nil
    end
    return attempt(
        UnitPowerPercent,
        "player",
        Enum.PowerType.Mana,
        false,
        curve
    )
end
function ValueCurvesService.prototype.getCurve(self, thresholdPercent, side)
    local threshold = math.floor(thresholdPercent + 0.5)
    local key = (side .. ":") .. tostring(threshold)
    local cached = self.curves[key]
    if cached ~= nil then
        local ____temp_0
        if cached == false then
            ____temp_0 = nil
        else
            ____temp_0 = cached
        end
        return ____temp_0
    end
    local made = attempt(function()
        local curve = C_CurveUtil.CreateCurve()
        curve:SetType(Enum.LuaCurveType.Linear)
        local at = math.max(
            0.05,
            math.min(1, threshold / 100)
        )
        local low, high = unpack(side == "below" and ({1, 0}) or ({0, 1}), 1, 2)
        curve:AddPoint(0, low)
        curve:AddPoint(
            math.max(0.01, at - 0.02),
            low
        )
        curve:AddPoint(at, high)
        curve:AddPoint(1, high)
        return curve
    end)
    self.curves[key] = made or false
    return made
end
return ____exports
 end,
["packages.@wowkit.wow.src.glow_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayJoin = ____lualib.__TS__ArrayJoin
local __TS__ArrayFlatMap = ____lualib.__TS__ArrayFlatMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____glow_2Dpicture_2Eutils = require("packages.@wowkit.wow.src.utils.glow-picture_utils")
local showLoopPicture = ____glow_2Dpicture_2Eutils.showLoopPicture
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local tryCall = ____protected_2Dcall_2Eutils.tryCall
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
--- Fallback art if the spell-alert glow template is missing; built-in client art only.
local GLOW_FALLBACK = "Interface\\Cooldown\\star4"
local GLOW_SCALE = 1.45
local GLOW_ALPHA = 0.95
--- The glow of a round gamepad button, in two layers of the client's own gamepad art: a soft round halo well around the
-- button (the glow it flashes when a cast completes), and the ring it highlights the button with.
local RING_ATLAS = "gamepad-actionbar-circleslot-border-hover"
local RING_SCALE = 1.2
local HALO_ATLAS = "gamepad-hud-actionbar-casting-complete-glow"
--- The halo's size, against the ring's.
local HALO_SCALE = 1.35
--- A breathing glow fades between full and this opacity, half a second each way.
local RING_PULSE_ALPHA = 0.45
local RING_PULSE_SECONDS = 0.5
--- The loop of the alert's glow, a flipbook. A glow that does not circle shows one picture of it still: the loop runs a
-- frame, so the client cuts the picture out, and is stopped, its picture kept: while it runs, even paused, it holds the
-- picture's opacity, so a fade could not change it.
local LOOP_ATLAS = "UI-HUD-ActionBar-Proc-Loop-Flipbook"
--- A still glow fades in and out this fast.
local STILL_FADE_SECONDS = 0.25
____exports.GlowService = __TS__Class()
local GlowService = ____exports.GlowService
GlowService.name = "GlowService"
function GlowService.prototype.____constructor(self, actionBars)
    self.actionBars = actionBars
    self.overlays = {}
    self.sizes = {}
    self.tracked = {}
    self.pulses = {}
    self.roundAnimation = "breathing"
end
function GlowService.prototype.setRoundAnimation(self, roundAnimation)
    self.roundAnimation = roundAnimation
end
function GlowService.prototype.createButtonGlow(self, glowKey, animation, isButtonShown)
    local glowing = {}
    local last
    local function clearGlow()
        for button in pairs(glowing) do
            local ____opt_0 = self.overlays[button]
            local entry = ____opt_0 and ____opt_0[glowKey]
            if entry then
                self:hideOverlay(entry)
            end
            glowing[button] = nil
        end
        last = nil
    end
    return {
        clear = clearGlow,
        setAlpha = function(alpha)
            local value = alpha or GLOW_ALPHA
            for button in pairs(glowing) do
                local ____opt_4 = self.overlays[button]
                local ____opt_2 = ____opt_4 and ____opt_4[glowKey]
                if ____opt_2 ~= nil then
                    ____opt_2.frame:SetAlpha(value)
                end
            end
        end,
        show = function(spellIds, color)
            if #spellIds == 0 then
                return clearGlow()
            end
            local key = (table.concat(spellIds, ",") .. "|") .. __TS__ArrayJoin(color, ",")
            local buttons = __TS__ArrayFilter(
                __TS__ArrayFlatMap(
                    spellIds,
                    function(____, spellId) return self.actionBars:findButtonsOf(spellId) end
                ),
                function(____, button) return isButtonShown == nil or isButtonShown(button) end
            )
            if key == last and not (next(glowing) == nil) and self:isSameButtons(glowing, buttons) then
                return
            end
            clearGlow()
            for ____, button in ipairs(buttons) do
                if not (glowing[button] ~= nil) then
                    self:showOverlay(
                        self:getOverlay(button, glowKey, color, animation),
                        button
                    )
                    glowing[button] = true
                end
            end
            last = key
        end
    }
end
function GlowService.prototype.showOverlay(self, entry, button)
    entry.isWanted = true
    if entry.isBeside == true and not button:IsVisible() then
        return
    end
    local ____opt_6 = entry.fadeOut
    if (____opt_6 and ____opt_6:IsPlaying()) == true then
        entry.fadeOut:Stop()
    else
        entry.frame:Show()
    end
end
function GlowService.prototype.hideOverlay(self, entry)
    entry.isWanted = false
    if entry.animation == "none" and entry.fadeOut ~= nil and entry.frame:IsShown() then
        entry.fadeOut:Play()
    else
        entry.frame:Hide()
    end
end
function GlowService.prototype.listGlowing(self)
    local buttons = {}
    for button in pairs(self.overlays) do
        if self:isGlowing(button) and not self:isGamepadButton(button) then
            buttons[#buttons + 1] = button
        end
    end
    return buttons
end
function GlowService.prototype.isGlowing(self, button)
    for ____, entry in pairs(self.overlays[button] or ({})) do
        if entry.isWanted == true then
            return true
        end
    end
    return false
end
function GlowService.prototype.isSameButtons(self, glowing, buttons)
    local wanted = {}
    for ____, button in ipairs(buttons) do
        if not (glowing[button] ~= nil) then
            return false
        end
        wanted[button] = true
    end
    for button in pairs(glowing) do
        if not (wanted[button] ~= nil) then
            return false
        end
    end
    return true
end
function GlowService.prototype.getOverlay(self, button, key, ____bindingPattern0, animation)
    local b
    local g
    local r
    r = ____bindingPattern0[1]
    g = ____bindingPattern0[2]
    b = ____bindingPattern0[3]
    local byKey = self.overlays[button]
    if not byKey then
        byKey = {}
        self.overlays[button] = byKey
    end
    local entry = byKey[key]
    if not entry then
        entry = self:createOverlay(button, animation)
        byKey[key] = entry
    end
    self:applySize(entry, button)
    if entry.alert then
        for ____, texture in ipairs({entry.alert.ProcStartFlipbook, entry.alert.ProcLoopFlipbook}) do
            if texture ~= nil then
                texture:SetDesaturated(true)
            end
            if texture ~= nil then
                texture:SetVertexColor(r, g, b)
            end
        end
        entry.frame:SetAlpha(GLOW_ALPHA)
    else
        entry.texture:SetVertexColor(r, g, b, GLOW_ALPHA)
        local ____opt_12 = entry.halo
        if ____opt_12 ~= nil then
            ____opt_12:SetVertexColor(r, g, b, GLOW_ALPHA)
        end
    end
    return entry
end
function GlowService.prototype.applySize(self, entry, button)
    local width, height, buttonScale = unpack(
        self:readButtonSize(button),
        1,
        3
    )
    local scale = (entry.isRing == true and RING_SCALE or GLOW_SCALE) * (entry.isBeside == true and buttonScale or 1)
    entry.frame:SetSize(width * scale, height * scale)
    local ____opt_14 = entry.halo
    if ____opt_14 ~= nil then
        ____opt_14:SetSize(width * scale * HALO_SCALE, height * scale * HALO_SCALE)
    end
end
function GlowService.prototype.readButtonSize(self, button)
    local width = getReadable(button:GetWidth())
    local height = getReadable(button:GetHeight())
    local screenScale, ownScale = getReadable(UIParent:GetEffectiveScale()), getReadable(button:GetEffectiveScale())
    local scale = screenScale ~= nil and ownScale ~= nil and screenScale > 0 and ownScale / screenScale or 1
    if width ~= nil and height ~= nil and width >= 8 and height >= 8 then
        self.sizes[button] = {width, height, scale}
    end
    return self.sizes[button] or ({36, 36, 1})
end
function GlowService.prototype.isGamepadButton(self, button)
    return button.activeButtonShape ~= nil and not self.actionBars:isRegistered(button)
end
function GlowService.prototype.trackButton(self, button)
    if self.tracked[button] ~= nil then
        return
    end
    self.tracked[button] = true
    button:HookScript(
        "OnHide",
        function()
            for ____, entry in pairs(self.overlays[button] or ({})) do
                entry.frame:Hide()
            end
        end
    )
    button:HookScript(
        "OnShow",
        function()
            for ____, entry in pairs(self.overlays[button] or ({})) do
                if entry.isWanted == true then
                    entry.frame:Show()
                end
            end
        end
    )
end
function GlowService.prototype.startAlert(self, alert, fades)
    alert.ProcLoop:Stop()
    local isCircling = fades.animation == "circling"
    local ____opt_16 = alert.ProcStartFlipbook
    if ____opt_16 ~= nil then
        ____opt_16:SetShown(isCircling)
    end
    if isCircling then
        local ____opt_18 = alert.ProcLoopFlipbook
        if ____opt_18 ~= nil then
            ____opt_18:SetAtlas(LOOP_ATLAS)
        end
        local ____opt_20 = alert.ProcLoopFlipbook
        if ____opt_20 ~= nil then
            ____opt_20:SetAlpha(0)
        end
        alert.ProcStartAnim:Play()
        return
    end
    showLoopPicture(
        alert,
        LOOP_ATLAS,
        function()
            if fades.animation == "none" then
                local ____opt_22 = fades.fadeIn
                if ____opt_22 ~= nil then
                    ____opt_22:Play()
                end
            elseif fades.breathe ~= nil then
                self.pulses[fades.breathe] = true
                self:syncPulses()
            end
        end
    )
end
function GlowService.prototype.createFade(self, alert, fromAlpha, toAlpha, seconds)
    local group = alert:CreateAnimationGroup()
    local fade = group and group:CreateAnimation("Alpha")
    if group == nil or fade == nil or alert.ProcLoopFlipbook == nil then
        return nil
    end
    fade:SetTarget(alert.ProcLoopFlipbook)
    fade:SetFromAlpha(fromAlpha)
    fade:SetToAlpha(toAlpha)
    fade:SetDuration(seconds)
    return group
end
function GlowService.prototype.createOverlay(self, button, animation)
    if not self:isGamepadButton(button) then
        return self:createOverlayIn(button, button, animation)
    end
    self:trackButton(button)
    local overlay = self:createOverlayIn(UIParent, button, animation)
    overlay.isBeside = true
    overlay.frame:SetFrameStrata(button:GetFrameStrata())
    return overlay
end
function GlowService.prototype.createOverlayIn(self, parent, button, animation)
    local level = button:GetFrameLevel() + 6
    if self:isRoundButton(button) then
        return self:createRing(parent, button, level, animation)
    end
    local didSucceed, created = tryCall(function() return CreateFrame("Frame", nil, parent, "ActionButtonSpellAlertTemplate") end)
    local alert = didSucceed and created or nil
    if alert and alert.ProcStartAnim and alert.ProcLoop then
        alert:SetFrameStrata("MEDIUM")
        alert:SetFrameLevel(level)
        alert:SetPoint(
            "CENTER",
            button,
            "CENTER",
            0,
            0
        )
        local fades = {
            animation = animation,
            fadeIn = self:createFade(alert, 0, 1, STILL_FADE_SECONDS),
            fadeOut = self:createFade(alert, 1, 0, STILL_FADE_SECONDS),
            breathe = self:createFade(alert, 1, RING_PULSE_ALPHA, RING_PULSE_SECONDS)
        }
        local ____opt_28 = fades.breathe
        if ____opt_28 ~= nil then
            ____opt_28:SetLooping("BOUNCE")
        end
        local ____opt_30 = fades.fadeOut
        if ____opt_30 ~= nil then
            ____opt_30:SetScript(
                "OnFinished",
                function() return alert:Hide() end
            )
        end
        alert:SetScript(
            "OnShow",
            function() return self:startAlert(alert, fades) end
        )
        alert:SetScript(
            "OnHide",
            function()
                alert.ProcStartAnim:Stop()
                alert.ProcLoop:Stop()
                for ____, fade in ipairs({fades.fadeIn, fades.fadeOut, fades.breathe}) do
                    if fade ~= nil then
                        fade:Stop()
                    end
                end
                if fades.breathe ~= nil then
                    self.pulses[fades.breathe] = nil
                end
            end
        )
        local ____opt_34 = alert.ProcAltGlow
        if ____opt_34 ~= nil then
            ____opt_34:Hide()
        end
        alert:Hide()
        return __TS__ObjectAssign({frame = alert, alert = alert}, fades)
    end
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetFrameStrata("MEDIUM")
    frame:SetFrameLevel(level)
    frame:SetPoint(
        "CENTER",
        button,
        "CENTER",
        0,
        0
    )
    local texture = frame:CreateTexture(nil, "OVERLAY")
    texture:SetAllPoints(frame)
    texture:SetTexture(GLOW_FALLBACK)
    texture:SetBlendMode("ADD")
    frame:Hide()
    return {frame = frame, texture = texture, animation = animation}
end
function GlowService.prototype.isRoundButton(self, button)
    return self.actionBars:getButtonShape(button) == "Circle"
end
function GlowService.prototype.createRing(self, parent, button, level, animation)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetFrameStrata("MEDIUM")
    frame:SetFrameLevel(level)
    frame:SetPoint(
        "CENTER",
        button,
        "CENTER",
        0,
        0
    )
    local pulsing = CreateFrame("Frame", nil, frame)
    pulsing:SetAllPoints(frame)
    local halo = self:createRingLayer(pulsing, HALO_ATLAS, "ARTWORK")
    halo:SetPoint(
        "CENTER",
        pulsing,
        "CENTER",
        0,
        0
    )
    local texture = self:createRingLayer(pulsing, RING_ATLAS, "OVERLAY")
    texture:SetAllPoints(pulsing)
    local pulse = pulsing:CreateAnimationGroup()
    local fade = pulse and pulse:CreateAnimation("Alpha")
    if pulse ~= nil and fade ~= nil then
        fade:SetFromAlpha(1)
        fade:SetToAlpha(RING_PULSE_ALPHA)
        fade:SetDuration(RING_PULSE_SECONDS)
        pulse:SetLooping("BOUNCE")
        frame:SetScript(
            "OnShow",
            function()
                if (animation == "circling" and self.roundAnimation or animation) ~= "breathing" then
                    return
                end
                self.pulses[pulse] = true
                self:syncPulses()
            end
        )
        frame:SetScript(
            "OnHide",
            function()
                pulse:Stop()
                self.pulses[pulse] = nil
            end
        )
    end
    frame:Hide()
    return {
        frame = frame,
        texture = texture,
        halo = halo,
        isRing = true,
        animation = animation
    }
end
function GlowService.prototype.syncPulses(self)
    for pulse in pairs(self.pulses) do
        pulse:Stop()
        pulse:Play()
    end
end
function GlowService.prototype.createRingLayer(self, frame, atlas, layer)
    local texture = frame:CreateTexture(nil, layer)
    texture:SetAtlas(atlas)
    texture:SetDesaturated(true)
    texture:SetBlendMode("ADD")
    return texture
end
return ____exports
 end,
["packages.@wowkit.wow.src.bar-fade_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____bar_2Dnames = require("packages.@wowkit.wow.src.bar-names")
local listBarButtonNames = ____bar_2Dnames.listBarButtonNames
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
--- An opacity this close to the wanted one is it (the client keeps opacities as bytes).
local ALPHA_MARGIN = 0.01
____exports.BarFadeService = __TS__Class()
local BarFadeService = ____exports.BarFadeService
BarFadeService.name = "BarFadeService"
function BarFadeService.prototype.____constructor(self, glow, registry)
    self.glow = glow
    self.registry = registry
    self.faded = {}
    self.opaque = {}
end
function BarFadeService.prototype.applyBarFades(self, opacityByBar)
    local wanted = {}
    for bar, opacity in pairs(opacityByBar) do
        for ____, button in ipairs(self:listBarButtons(bar)) do
            wanted[button] = self.glow:isGlowing(button) and 1 or opacity
        end
    end
    for button, opacity in pairs(wanted) do
        local alpha = getReadable(button:GetAlpha())
        if alpha == nil or math.abs(alpha - opacity) > ALPHA_MARGIN then
            button:SetAlpha(opacity)
        end
        self.faded[button] = opacity
    end
    for button in pairs(self.faded) do
        if not (wanted[button] ~= nil) then
            button:SetAlpha(1)
            self.faded[button] = nil
        end
    end
    self:showGlowingInFull()
end
function BarFadeService.prototype.showGlowingInFull(self)
    local glowing = {}
    for ____, button in ipairs(self.glow:listGlowing()) do
        glowing[button] = true
        if not (self.opaque[button] ~= nil) then
            button:SetIgnoreParentAlpha(true)
        end
        self.opaque[button] = true
    end
    for button in pairs(self.opaque) do
        if not (glowing[button] ~= nil) then
            button:SetIgnoreParentAlpha(false)
            self.opaque[button] = nil
        end
    end
end
function BarFadeService.prototype.listBarButtons(self, bar)
    local globals = _G
    local buttons = self.registry:listActionButtons(bar)
    for ____, name in ipairs(listBarButtonNames(bar)) do
        local button = globals[name]
        if button then
            buttons[#buttons + 1] = button
        end
    end
    return buttons
end
return ____exports
 end,
["packages.@wowkit.wow.src.character_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
--- Race IDs by the client's race file name; Forever's Aeolids are 95 (Alliance) and 96 (Horde).
local RACE_BY_FILE = {
    Human = 1,
    Orc = 2,
    Dwarf = 3,
    NightElf = 4,
    Scourge = 5,
    Undead = 5,
    Tauren = 6,
    Gnome = 7,
    Troll = 8,
    Aeolid = 95,
    Highborne = 95,
    Skyborne = 95,
    Windborne = 96
}
--- The talent trees with the most points are looked up again after this long.
local TREE_REUSE = 3
____exports.CharacterService = __TS__Class()
local CharacterService = ____exports.CharacterService
CharacterService.name = "CharacterService"
function CharacterService.prototype.____constructor(self)
    self.mainTreeAt = -10
end
function CharacterService.prototype.getLevel(self)
    local level = getReadable(attempt(UnitLevel, "player"))
    local ____temp_0
    if type(level) == "number" then
        ____temp_0 = level
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
function CharacterService.prototype.getRaceId(self)
    local didSucceed, ____, raceFile, raceId = attemptMulti(function() return UnitRace("player") end)
    if not didSucceed then
        return nil
    end
    local id = getReadable(raceId)
    if type(id) == "number" then
        return id
    end
    local file = getReadable(raceFile)
    local ____temp_1
    if file ~= nil then
        ____temp_1 = RACE_BY_FILE[file]
    else
        ____temp_1 = nil
    end
    local byFile = ____temp_1
    if byFile == 95 and self:getFaction() == "Horde" then
        return 96
    end
    return byFile
end
function CharacterService.prototype.getFaction(self)
    local didSucceed, faction = attemptMulti(function() return UnitFactionGroup("player") end)
    local ____temp_2
    if didSucceed and isReadable(faction) and type(faction) == "string" and faction ~= "" then
        ____temp_2 = faction
    else
        ____temp_2 = nil
    end
    return ____temp_2
end
function CharacterService.prototype.isInGroup(self)
    return attempt(IsInGroup) == true
end
function CharacterService.prototype.isInMyGroup(self, unit)
    if getReadable(attempt(UnitInParty, unit)) == true then
        return true
    end
    return type(getReadable(attempt(UnitInRaid, unit))) == "number"
end
function CharacterService.prototype.getMainTalentTree(self)
    local now = GetTime()
    if self.mainTreeAt > 0 and now - self.mainTreeAt < TREE_REUSE then
        return self.mainTree
    end
    self.mainTreeAt = now
    self.mainTree = nil
    local bestPoints = 0
    do
        local index = 1
        while index <= 4 do
            local didSucceed, specId, name, ____, ____, ____, ____, points = attemptMulti(function() return C_SpecializationInfo.GetSpecializationInfo(index) end)
            if not didSucceed or specId == nil or specId == 0 then
                break
            end
            local spent = tonumber(getReadable(points)) or 0
            if spent > bestPoints and type(name) == "string" and isReadable(name) then
                bestPoints = spent
                self.mainTree = string.lower(name)
            end
            index = index + 1
        end
    end
    return self.mainTree
end
function CharacterService.prototype.hasTamedPet(self)
    local didSucceed, info = attemptMulti(function() return C_StableInfo.GetStablePetInfo(1) end)
    if not didSucceed then
        return nil
    end
    return type(info) == "table"
end
function CharacterService.prototype.isMouseoverCastOn(self)
    return attempt(C_CVar.GetCVarBool, "enableMouseoverCast") == true
end
return ____exports
 end,
["packages.@wowkit.wow.src.cooldowns_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
--- A cooldown this short is the global cooldown, not the spell's own.
local GLOBAL_COOLDOWN = 1.51
____exports.CooldownsService = __TS__Class()
local CooldownsService = ____exports.CooldownsService
CooldownsService.name = "CooldownsService"
function CooldownsService.prototype.____constructor(self)
end
function CooldownsService.prototype.readCooldown(self, spellId)
    local info = attempt(C_Spell.GetSpellCooldown, spellId)
    if info == nil or type(info) ~= "table" then
        return {remain = 0, duration = 0, isHidden = true}
    end
    local start = info.startTime
    local duration = info.duration
    if start ~= nil and not isReadable(start) or duration ~= nil and not isReadable(duration) then
        return {remain = 0, duration = 0, isHidden = true}
    end
    local startAt = tonumber(start) or 0
    local length = tonumber(duration) or 0
    if length > 0 and length <= GLOBAL_COOLDOWN then
        return {remain = 0, duration = length, isHidden = false}
    end
    return {
        remain = math.max(
            length - (GetTime() - startAt),
            0
        ),
        duration = length,
        isHidden = false
    }
end
function CooldownsService.prototype.getBaseCooldown(self, spellId)
    local didSucceed, cooldown, gcd = attemptMulti(function() return GetSpellBaseCooldown(spellId) end)
    if not didSucceed then
        return 0
    end
    return self:convertToSeconds(cooldown, gcd)
end
function CooldownsService.prototype.convertToSeconds(self, cooldown, gcd)
    local ____isReadable_result_0
    if isReadable(cooldown) then
        ____isReadable_result_0 = tonumber(cooldown)
    else
        ____isReadable_result_0 = nil
    end
    local length = ____isReadable_result_0
    local ____isReadable_result_1
    if isReadable(gcd) then
        ____isReadable_result_1 = tonumber(gcd)
    else
        ____isReadable_result_1 = nil
    end
    local global = ____isReadable_result_1
    if length == nil or length <= 0 then
        return 0
    end
    if length < 500 then
        local gcdSeconds = global ~= nil and global < 500 and global or 1.5
        return (length <= gcdSeconds + 0.05 or length <= 1.5) and 0 or length
    end
    return length <= (global or 1500) + 50 and 0 or length / 1000
end
return ____exports
 end,
["packages.@wowkit.wow.src.notice_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
____exports.NOTICE_SECONDS = 10
____exports.NoticeService = __TS__Class()
local NoticeService = ____exports.NoticeService
NoticeService.name = "NoticeService"
function NoticeService.prototype.____constructor(self, owner)
    self.owner = owner
end
function NoticeService.prototype.playSound(self, kitName, fallbackId)
    local ____temp_0
    if kitName ~= nil then
        ____temp_0 = SOUNDKIT[kitName]
    else
        ____temp_0 = nil
    end
    local soundKitId = ____temp_0 or fallbackId
    attempt(C_Sound.PlaySound, soundKitId, nil, true)
end
function NoticeService.prototype.printToChat(self, text)
    print(text)
end
function NoticeService.prototype.showNotice(self, text)
    local shared = self:getSharedNotices()
    local entry = __TS__ArrayFind(
        shared.entries,
        function(____, candidate) return candidate.owner == self.owner end
    )
    if not entry then
        entry = {owner = self.owner, text = text, token = 0}
        local ____shared_entries_1 = shared.entries
        ____shared_entries_1[#____shared_entries_1 + 1] = entry
    end
    entry.text = text
    entry.token = entry.token + 1
    local token = entry.token
    self:draw(shared)
    C_Timer.After(
        ____exports.NOTICE_SECONDS,
        function() return self:removeExpired(token) end
    )
end
function NoticeService.prototype.clearNotice(self)
    local shared = WowkitNotices
    if not shared then
        return
    end
    local before = #shared.entries
    shared.entries = __TS__ArrayFilter(
        shared.entries,
        function(____, candidate) return candidate.owner ~= self.owner end
    )
    if #shared.entries ~= before then
        self:draw(shared)
    end
end
function NoticeService.prototype.removeExpired(self, token)
    local shared = WowkitNotices
    if not shared then
        return
    end
    local entry = __TS__ArrayFind(
        shared.entries,
        function(____, candidate) return candidate.owner == self.owner end
    )
    if not entry or entry.token ~= token then
        return
    end
    shared.entries = __TS__ArrayFilter(
        shared.entries,
        function(____, candidate) return candidate ~= entry end
    )
    self:draw(shared)
end
function NoticeService.prototype.draw(self, shared)
    if #shared.entries == 0 then
        shared.frame:Hide()
        return
    end
    shared.text:SetText(table.concat(
        __TS__ArrayMap(
            shared.entries,
            function(____, entry) return entry.text end
        ),
        "\n"
    ))
    shared.frame:Show()
end
function NoticeService.prototype.getSharedNotices(self)
    if WowkitNotices then
        return WowkitNotices
    end
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(700, 40)
    frame:SetPoint(
        "TOP",
        UIParent,
        "TOP",
        0,
        -180
    )
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    text:SetPoint("CENTER")
    text:SetTextColor(1, 0.82, 0)
    WowkitNotices = {frame = frame, text = text, entries = {}}
    return WowkitNotices
end
return ____exports
 end,
["packages.@wowkit.wow.src.party_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
____exports.PartyService = __TS__Class()
local PartyService = ____exports.PartyService
PartyService.name = "PartyService"
function PartyService.prototype.____constructor(self)
end
function PartyService.prototype.isInRaid(self)
    return attempt(UnitExists, "raid1") == true
end
function PartyService.prototype.getPartyUnits(self)
    local units = {}
    do
        local i = 1
        while i <= 4 do
            local unit = "party" .. tostring(i)
            if attempt(UnitExists, unit) == true then
                units[#units + 1] = unit
            end
            i = i + 1
        end
    end
    return units
end
function PartyService.prototype.getRaidUnits(self)
    local units = {}
    do
        local i = 1
        while i <= 40 do
            local unit = "raid" .. tostring(i)
            if attempt(UnitExists, unit) == true and attempt(UnitIsUnit, unit, "player") ~= true then
                units[#units + 1] = unit
            end
            i = i + 1
        end
    end
    return units
end
function PartyService.prototype.isReachable(self, unit)
    return attempt(UnitIsConnected, unit) == true and attempt(UnitIsDeadOrGhost, unit) ~= true and attempt(UnitIsVisible, unit) == true
end
function PartyService.prototype.isInSpellRange(self, spellId, unit)
    local isInRange = getReadable(attempt(C_Spell.IsSpellInRange, spellId, unit))
    if isInRange ~= nil then
        return isInRange
    end
    local didSucceed, isNear, wasChecked = attemptMulti(function() return UnitInRange(unit) end)
    if not didSucceed or not isReadable(wasChecked) or wasChecked ~= true then
        return true
    end
    return isReadable(isNear) and isNear == true
end
function PartyService.prototype.doesUseMana(self, unit)
    local didSucceed, powerType = attemptMulti(function() return UnitPowerType(unit) end)
    return didSucceed and isReadable(powerType) and powerType == Enum.PowerType.Mana
end
function PartyService.prototype.getUnitIdentity(self, unit)
    local didReadName, name = attemptMulti(function() return UnitName(unit) end)
    local didReadClass, ____, classFile = attemptMulti(function() return UnitClass(unit) end)
    return {
        name = didReadName and isReadable(name) and name ~= nil and name or unit,
        classToken = didReadClass and isReadable(classFile) and classFile ~= nil and classFile or "?"
    }
end
return ____exports
 end,
["packages.@wowkit.wow.src.player_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local Consumable = ____wow_2Ddata.Consumable
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local tryCall = ____protected_2Dcall_2Eutils.tryCall
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
local ____wow_2Econstants = require("packages.@wowkit.wow.src.wow_constants")
local OFF_HAND_SLOT = ____wow_2Econstants.OFF_HAND_SLOT
local RANGED_SLOT = ____wow_2Econstants.RANGED_SLOT
____exports.PlayerService = __TS__Class()
local PlayerService = ____exports.PlayerService
PlayerService.name = "PlayerService"
function PlayerService.prototype.____constructor(self)
end
function PlayerService.prototype.isInCombat(self)
    local didSucceed, isFighting = tryCall(UnitAffectingCombat, "player")
    if not didSucceed then
        return false
    end
    if isReadable(isFighting) then
        return isFighting == true
    end
    return isFighting ~= nil
end
function PlayerService.prototype.isResting(self)
    return attempt(IsResting) == true
end
function PlayerService.prototype.isSwimming(self)
    return attempt(IsSwimming) == true
end
function PlayerService.prototype.isDead(self)
    return attempt(UnitIsDeadOrGhost, "player") == true
end
function PlayerService.prototype.isOnTaxi(self)
    return attempt(UnitOnTaxi, "player") == true
end
function PlayerService.prototype.hasTarget(self)
    return attempt(UnitExists, "target") == true
end
function PlayerService.prototype.hasEnemyTarget(self)
    return self:hasTarget() and getReadable(attempt(UnitCanAttack, "player", "target")) == true and attempt(UnitIsDeadOrGhost, "target") ~= true
end
function PlayerService.prototype.isMounted(self)
    return attempt(IsMounted) == true
end
function PlayerService.prototype.findMainTalentTree(self)
    local nodes = self:listTalentNodes()
    if #nodes == 0 then
        return nil
    end
    local left = math.huge
    local right = -math.huge
    for ____, node in ipairs(nodes) do
        left = math.min(left, node.posX)
        right = math.max(right, node.posX)
    end
    local width = (right - left) / 3
    local points = {0, 0, 0}
    for ____, node in ipairs(nodes) do
        local tree = width > 0 and math.min(
            2,
            math.floor((node.posX - left) / width)
        ) or 0
        points[tree + 1] = points[tree + 1] + node.rank
    end
    local best = math.max(points[1], points[2], points[3])
    return best > 0 and __TS__ArrayIndexOf(points, best) + 1 or nil
end
function PlayerService.prototype.listTalentNodes(self)
    local configId = attempt(function() return C_ClassTalents.GetActiveConfigID() end)
    local ____temp_2
    if configId ~= nil then
        ____temp_2 = attempt(function()
            local ____opt_0 = C_Traits.GetConfigInfo(configId)
            return ____opt_0 and ____opt_0.treeIDs[1]
        end)
    else
        ____temp_2 = nil
    end
    local treeId = ____temp_2
    if configId == nil or treeId == nil then
        return {}
    end
    local nodes = {}
    for ____, nodeId in ipairs(attempt(function() return C_Traits.GetTreeNodes(treeId) end) or ({})) do
        local info = attempt(function() return C_Traits.GetNodeInfo(configId, nodeId) end)
        local ____temp_3
        if info ~= nil then
            ____temp_3 = tonumber(getReadable(info.posX))
        else
            ____temp_3 = nil
        end
        local posX = ____temp_3
        if posX ~= nil then
            nodes[#nodes + 1] = {
                posX = posX,
                rank = tonumber(getReadable(info.currentRank)) or 0
            }
        end
    end
    return nodes
end
function PlayerService.prototype.getClassToken(self)
    local ____, classFile = UnitClass("player")
    if classFile ~= nil and isReadable(classFile) then
        return string.upper(classFile)
    end
    local base = UnitClassBase("player")
    if base ~= nil and isReadable(base) then
        return string.upper(base)
    end
    return nil
end
function PlayerService.prototype.getEquippedItemId(self, slot)
    local itemId = attempt(GetInventoryItemID, "player", slot)
    local ____temp_4
    if type(itemId) == "number" then
        ____temp_4 = itemId
    else
        ____temp_4 = nil
    end
    return ____temp_4
end
function PlayerService.prototype.isOffhandWeaponEquipped(self)
    local itemId = self:getEquippedItemId(OFF_HAND_SLOT)
    if itemId == nil then
        return false
    end
    local ____, ____, ____, ____, ____, classId = C_Item.GetItemInfoInstant(itemId)
    return classId == Enum.ItemClass.Weapon
end
function PlayerService.prototype.getCastingSpellName(self)
    local didSucceed, name = attemptMulti(function() return UnitCastingInfo("player") end)
    local ____temp_5
    if didSucceed and isReadable(name) and type(name) == "string" then
        ____temp_5 = name
    else
        ____temp_5 = nil
    end
    return ____temp_5
end
function PlayerService.prototype.getChannelingSpellName(self)
    local didSucceed, name = attemptMulti(function() return UnitChannelInfo("player") end)
    local ____temp_6
    if didSucceed and isReadable(name) and type(name) == "string" then
        ____temp_6 = name
    else
        ____temp_6 = nil
    end
    return ____temp_6
end
function PlayerService.prototype.getCastRemaining(self)
    local cast = self:readCastEnd(function() return UnitCastingInfo("player") end)
    return cast > 0 and cast or self:readCastEnd(function() return UnitChannelInfo("player") end)
end
function PlayerService.prototype.readComboPoints(self)
    local power = getReadable(attempt(UnitPower, "player", Enum.PowerType.ComboPoints))
    local onTarget = getReadable(attempt(GetComboPoints, "player", "target"))
    if type(power) ~= "number" and type(onTarget) ~= "number" then
        return nil
    end
    return math.max(
        type(power) == "number" and power or 0,
        type(onTarget) == "number" and onTarget or 0
    )
end
function PlayerService.prototype.getPosition(self)
    local didSucceed, x, y, ____, mapId = attemptMulti(function() return UnitPosition("player") end)
    if not didSucceed or not isReadable(x) or not isReadable(y) or type(x) ~= "number" or type(y) ~= "number" then
        return nil
    end
    return {
        x = x,
        y = y,
        mapId = getReadable(mapId) or 0
    }
end
function PlayerService.prototype.getRangedSpeed(self)
    local didSucceed, speed = attemptMulti(function() return UnitRangedDamage("player") end)
    local ____temp_7
    if didSucceed and isReadable(speed) then
        ____temp_7 = tonumber(speed)
    else
        ____temp_7 = nil
    end
    local seconds = ____temp_7
    return seconds ~= nil and seconds > 0.4 and seconds or nil
end
function PlayerService.prototype.getRangedWeaponSpeed(self)
    local tooltip = attempt(C_TooltipInfo.GetInventoryItem, "player", RANGED_SLOT)
    if tooltip == nil or type(tooltip) ~= "table" then
        return nil
    end
    for ____, line in ipairs(tooltip.lines or ({})) do
        local text = getReadable(line.rightText)
        if text ~= nil and (string.find(
            string.lower(text),
            "speed",
            1,
            true
        )) ~= nil then
            local digits = string.match(text, "(%d+%.?%d*)")
            local speed = tonumber(digits)
            if speed ~= nil and speed > 0.4 then
                return speed
            end
        end
    end
    return nil
end
function PlayerService.prototype.listShapeshiftForms(self)
    local count = getReadable(attempt(GetNumShapeshiftForms))
    local forms = {}
    if type(count) ~= "number" then
        return forms
    end
    do
        local index = 1
        while index <= count do
            local didSucceed, ____, isActive, ____, spellId = attemptMulti(function() return GetShapeshiftFormInfo(index) end)
            if didSucceed and isReadable(spellId) and spellId ~= nil then
                local ____spellId_9 = spellId
                local ____isReadable_result_8
                if isReadable(isActive) then
                    ____isReadable_result_8 = isActive == true or isActive == 1
                else
                    ____isReadable_result_8 = nil
                end
                forms[#forms + 1] = {spellId = ____spellId_9, isActive = ____isReadable_result_8}
            end
            index = index + 1
        end
    end
    return forms
end
function PlayerService.prototype.isEating(self)
    do
        local i = 1
        while i <= 40 do
            local aura = attempt(C_UnitAuras.GetAuraDataByIndex, "player", i, "HELPFUL")
            if not aura then
                return false
            end
            local name = getReadable(aura.name)
            if name ~= nil and self:getEatingNames()[string.lower(name)] ~= nil then
                return true
            end
            i = i + 1
        end
    end
    return false
end
function PlayerService.prototype.readCastEnd(self, read)
    local results = {pcall(read)}
    if results[1] ~= true or results[2] == nil or not isReadable(results[2]) then
        return 0
    end
    local ____isReadable_result_10
    if isReadable(results[6]) then
        ____isReadable_result_10 = tonumber(results[6])
    else
        ____isReadable_result_10 = nil
    end
    local endTime = ____isReadable_result_10
    if endTime == nil then
        return 0
    end
    if endTime > 100000 then
        endTime = endTime / 1000
    end
    return math.max(
        endTime - GetTime(),
        0
    )
end
function PlayerService.prototype.getEatingNames(self)
    if self.eatingNames then
        return self.eatingNames
    end
    local names = {}
    for ____, ____value in ipairs({{Consumable.Food, "food"}, {Consumable.Drink, "drink"}, {Consumable.NutritiousFood, "nutritious food"}, {Consumable.NutritiousDrink, "nutritious drink"}}) do
        local spellId = ____value[1]
        local english = ____value[2]
        names[english] = true
        local ____getReadable_13 = getReadable
        local ____opt_11 = attempt(C_Spell.GetSpellInfo, spellId)
        local name = ____getReadable_13(____opt_11 and ____opt_11.name)
        if name ~= nil and name ~= "" then
            names[string.lower(name)] = true
        end
    end
    self.eatingNames = names
    return names
end
return ____exports
 end,
["packages.@wowkit.wow.src.utils.global_utils"] = function(...) 
local ____exports = {}
--- Sets the global `name`; another addon reads it as `_G[name]`, or by its name.
function ____exports.setGlobal(name, value)
    _G[name] = value
end
return ____exports
 end,
["packages.@wowkit.wow.src.utils.spell-name_utils"] = function(...) 
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local trimText = ____core.trimText
--- "Power Word: Fortitude (Rank 2)" -> "power word: fortitude".
function ____exports.buildNameKey(name)
    local stripped = string.gsub(
        string.lower(name),
        "%s*%([^%)]*%)",
        ""
    )
    return trimText(stripped)
end
return ____exports
 end,
["packages.@wowkit.wow.src.saved-variables_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.SavedVariablesService = __TS__Class()
local SavedVariablesService = ____exports.SavedVariablesService
SavedVariablesService.name = "SavedVariablesService"
function SavedVariablesService.prototype.____constructor(self, variableName)
    self.variableName = variableName
end
function SavedVariablesService.prototype.loadTable(self)
    return _G[self.variableName]
end
function SavedVariablesService.prototype.bindTable(self, ____table)
    _G[self.variableName] = ____table
end
return ____exports
 end,
["packages.@wowkit.wow.src.spell-cast_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnUnitEvent = ____core.OnUnitEvent
____exports.SpellCastService = __TS__Class()
local SpellCastService = ____exports.SpellCastService
SpellCastService.name = "SpellCastService"
function SpellCastService.prototype.____constructor(self, player, spells, bus)
    self.player = player
    self.spells = spells
    self.bus = bus
end
function SpellCastService.prototype.noteCastStart(self)
    self.lastCastName = self.player:getCastingSpellName() or self.lastCastName
end
__TS__DecorateLegacy(
    {OnUnitEvent("UNIT_SPELLCAST_START")},
    SpellCastService.prototype,
    "noteCastStart",
    true
)
function SpellCastService.prototype.noteCastSucceeded(self, _unit, _castGuid, spellId)
    local spellName = self.lastCastName
    self.lastCastName = nil
    local isHidden = spellId == nil or issecretvalue(spellId)
    local ____self_1 = self.bus
    local ____self_1_emit_2 = ____self_1.emit
    local ____isHidden_0
    if isHidden then
        ____isHidden_0 = self.spells:resolveFromName(spellName)
    else
        ____isHidden_0 = spellId
    end
    ____self_1_emit_2(____self_1, "player.spell-cast", {spellId = ____isHidden_0, spellName = spellName})
end
__TS__DecorateLegacy(
    {OnUnitEvent("UNIT_SPELLCAST_SUCCEEDED")},
    SpellCastService.prototype,
    "noteCastSucceeded",
    true
)
return ____exports
 end,
["packages.@wowkit.wow.src.spell-details_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
____exports.SpellDetailsService = __TS__Class()
local SpellDetailsService = ____exports.SpellDetailsService
SpellDetailsService.name = "SpellDetailsService"
function SpellDetailsService.prototype.____constructor(self)
end
function SpellDetailsService.prototype.getCastTimeMs(self, spellId)
    local info = attempt(C_Spell.GetSpellInfo, spellId)
    local ____info_0
    if info then
        ____info_0 = getReadable(info.castTime)
    else
        ____info_0 = nil
    end
    local castTime = ____info_0
    return type(castTime) == "number" and castTime or 0
end
function SpellDetailsService.prototype.getMaxRange(self, spellId)
    local info = attempt(C_Spell.GetSpellInfo, spellId)
    local ____info_1
    if info then
        ____info_1 = getReadable(info.maxRange)
    else
        ____info_1 = nil
    end
    local range = ____info_1
    local ____temp_2
    if type(range) == "number" and range == range then
        ____temp_2 = range
    else
        ____temp_2 = nil
    end
    return ____temp_2
end
function SpellDetailsService.prototype.isHelpful(self, spellId)
    return attempt(C_Spell.IsSpellHelpful, spellId) == true
end
function SpellDetailsService.prototype.isHarmful(self, spellId)
    return attempt(C_Spell.IsSpellHarmful, spellId) == true
end
function SpellDetailsService.prototype.isAutoRepeating(self, spellId)
    return attempt(C_Spell.IsAutoRepeatSpell, spellId) == true
end
function SpellDetailsService.prototype.readUsability(self, spellId)
    local didSucceed, isUsable, isOutOfPower = attemptMulti(function() return C_Spell.IsSpellUsable(spellId) end)
    if not didSucceed then
        return {isUsable = nil, isOutOfPower = nil}
    end
    return {
        isUsable = getReadable(isUsable),
        isOutOfPower = getReadable(isOutOfPower)
    }
end
function SpellDetailsService.prototype.listCosts(self, spellId)
    local costs = attempt(C_Spell.GetSpellPowerCost, spellId)
    if costs == nil or type(costs) ~= "table" then
        return {}
    end
    local out = {}
    for ____, cost in ipairs(costs) do
        local amount = tonumber(getReadable(cost.cost))
        local powerType = tonumber(getReadable(cost.type)) or 0
        if amount ~= nil then
            out[#out + 1] = {powerType = powerType, amount = amount}
        end
    end
    return out
end
function SpellDetailsService.prototype.getDescription(self, spellId)
    local text = getReadable(attempt(C_Spell.GetSpellDescription, spellId))
    local ____temp_3
    if type(text) == "string" and text ~= "" then
        ____temp_3 = text
    else
        ____temp_3 = nil
    end
    return ____temp_3
end
function SpellDetailsService.prototype.isInRange(self, spellId, unit)
    return self:readFlag(attempt(C_Spell.IsSpellInRange, spellId, unit))
end
function SpellDetailsService.prototype.isActionInRange(self, slot)
    return self:readFlag(attempt(C_ActionBar.IsActionInRange, slot))
end
function SpellDetailsService.prototype.isNotBehindError(self, message)
    return SPELL_FAILED_NOT_BEHIND ~= nil and message == SPELL_FAILED_NOT_BEHIND or (string.find(
        string.lower(message),
        "behind",
        1,
        true
    )) ~= nil
end
function SpellDetailsService.prototype.readFlag(self, value)
    if not isReadable(value) then
        return nil
    end
    if value == true or value == 1 then
        return true
    end
    if value == false or value == 0 then
        return false
    end
    return nil
end
return ____exports
 end,
["packages.@wowkit.wow.src.tooltip_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadableId = ____secret_2Dvalue_2Eutils.getReadableId
____exports.TooltipService = __TS__Class()
local TooltipService = ____exports.TooltipService
TooltipService.name = "TooltipService"
function TooltipService.prototype.____constructor(self)
end
function TooltipService.prototype.addSpellLines(self, getLine)
    TooltipDataProcessor.AddTooltipPostCall(
        Enum.TooltipDataType.Spell,
        function(tooltip, data) return self:addLine(tooltip, data, getLine) end
    )
end
function TooltipService.prototype.addItemLines(self, getLine)
    TooltipDataProcessor.AddTooltipPostCall(
        Enum.TooltipDataType.Item,
        function(tooltip, data) return self:addLine(tooltip, data, getLine) end
    )
end
function TooltipService.prototype.getUseSpellId(self, itemId)
    local didSucceed, ____, spellId = attemptMulti(function() return C_Item.GetItemSpell(itemId) end)
    local ____didSucceed_0
    if didSucceed then
        ____didSucceed_0 = getReadableId(spellId)
    else
        ____didSucceed_0 = nil
    end
    return ____didSucceed_0
end
function TooltipService.prototype.addLine(self, tooltip, data, getLine)
    local id = getReadableId(data.id)
    if id == nil then
        return
    end
    local line = getLine(id)
    if line ~= nil then
        tooltip:AddLine(line, 1, 1, 1)
    end
end
return ____exports
 end,
["packages.@wowkit.wow.src.totems_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
--- The totem slots: fire 1, earth 2, water 3, air 4.
____exports.TOTEM_SLOTS = 4
____exports.TotemsService = __TS__Class()
local TotemsService = ____exports.TotemsService
TotemsService.name = "TotemsService"
function TotemsService.prototype.____constructor(self)
end
function TotemsService.prototype.readTotemSlot(self, slot)
    local didSucceed, hasTotem, name, startTime, duration = attemptMulti(function() return GetTotemInfo(slot) end)
    if not didSucceed or not isReadable(hasTotem) then
        return nil
    end
    if not hasTotem then
        return false
    end
    if not isReadable(name) or not isReadable(startTime) or not isReadable(duration) or type(name) ~= "string" or name == "" then
        return nil
    end
    return {
        name = name,
        startTime = tonumber(startTime) or 0,
        duration = tonumber(duration) or 0
    }
end
function TotemsService.prototype.listTotemBarSpells(self)
    local spells = {}
    do
        local i = 1
        while i <= ____exports.TOTEM_SLOTS do
            local button = _G["MultiCastActionButton" .. tostring(i)]
            local ____button_0
            if button then
                ____button_0 = button.action or tonumber(attempt(function() return button:GetAttribute("action") end))
            else
                ____button_0 = nil
            end
            local slot = ____button_0
            if slot ~= nil then
                local didSucceed, kind, id = attemptMulti(function() return GetActionInfo(slot) end)
                if didSucceed and isReadable(kind) and kind == "spell" and getReadable(id) ~= nil then
                    spells[#spells + 1] = id
                end
            end
            i = i + 1
        end
    end
    return spells
end
return ____exports
 end,
["packages.@wowkit.wow.src.units_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
local attemptMulti = ____protected_2Dcall_2Eutils.attemptMulti
local tryCall = ____protected_2Dcall_2Eutils.tryCall
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
--- Interact distances of the client: 3 duel (~10 yd), 2 trade (~11 yd), 1 inspect (~28 yd).
local DUEL_DISTANCE = 3
local TRADE_DISTANCE = 2
local INSPECT_DISTANCE = 1
____exports.UnitsService = __TS__Class()
local UnitsService = ____exports.UnitsService
UnitsService.name = "UnitsService"
function UnitsService.prototype.____constructor(self, player)
    self.player = player
end
function UnitsService.prototype.doesExist(self, unit)
    return attempt(UnitExists, unit) == true
end
function UnitsService.prototype.isDead(self, unit)
    local didSucceed, isDead = tryCall(UnitIsDead, unit)
    local ____temp_0
    if didSucceed and isReadable(isDead) then
        ____temp_0 = isDead == true
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
function UnitsService.prototype.isDeadOrGhost(self, unit)
    return attempt(UnitIsDeadOrGhost, unit) == true
end
function UnitsService.prototype.getReaction(self, unit)
    local reaction = getReadable(attempt(UnitReaction, "player", unit))
    local ____temp_1
    if type(reaction) == "number" then
        ____temp_1 = reaction
    else
        ____temp_1 = nil
    end
    return ____temp_1
end
function UnitsService.prototype.isFriend(self, unit)
    if not self:doesExist(unit) or self:isDead(unit) == true then
        return false
    end
    local didSucceed, canAttack = tryCall(UnitCanAttack, "player", unit)
    if didSucceed and not isReadable(canAttack) then
        return false
    end
    if canAttack == true then
        return false
    end
    local reaction = getReadable(attempt(UnitReaction, "player", unit))
    if reaction ~= nil then
        return reaction > 4
    end
    return didSucceed and canAttack == false
end
function UnitsService.prototype.canAttack(self, unit)
    return getReadable(attempt(UnitCanAttack, "player", unit)) == true
end
function UnitsService.prototype.isPlayer(self, unit)
    return attempt(UnitIsPlayer, unit) == true
end
function UnitsService.prototype.isSameUnit(self, unit, other)
    local didSucceed, isSame = tryCall(UnitIsUnit, unit, other)
    local ____temp_2
    if didSucceed and isReadable(isSame) then
        ____temp_2 = isSame == true
    else
        ____temp_2 = nil
    end
    return ____temp_2
end
function UnitsService.prototype.isInCombat(self, unit)
    local didSucceed, isFighting = tryCall(UnitAffectingCombat, unit)
    local ____temp_3
    if didSucceed and isReadable(isFighting) then
        ____temp_3 = isFighting == true
    else
        ____temp_3 = nil
    end
    return ____temp_3
end
function UnitsService.prototype.getGuid(self, unit)
    local guid = getReadable(attempt(UnitGUID, unit))
    local ____temp_4
    if type(guid) == "string" then
        ____temp_4 = guid
    else
        ____temp_4 = nil
    end
    return ____temp_4
end
function UnitsService.prototype.getLevel(self, unit)
    local level = getReadable(attempt(UnitLevel, unit))
    local ____temp_5
    if type(level) == "number" then
        ____temp_5 = level
    else
        ____temp_5 = nil
    end
    return ____temp_5
end
function UnitsService.prototype.getClassification(self, unit)
    local classification = getReadable(attempt(UnitClassification, unit))
    local ____temp_6
    if type(classification) == "string" then
        ____temp_6 = classification
    else
        ____temp_6 = nil
    end
    return ____temp_6
end
function UnitsService.prototype.getCreatureType(self, unit)
    if not self:doesExist(unit) then
        return nil
    end
    local didSucceed, name = attemptMulti(function() return UnitCreatureType(unit) end)
    if not didSucceed or not isReadable(name) or type(name) ~= "string" or name == "" then
        return nil
    end
    return string.lower(name)
end
function UnitsService.prototype.getThreatStatus(self, unit)
    local status = getReadable(attempt(UnitThreatSituation, "player", unit))
    local ____temp_7
    if type(status) == "number" then
        ____temp_7 = status
    else
        ____temp_7 = nil
    end
    return ____temp_7
end
function UnitsService.prototype.isOnThreatTable(self, unit)
    local didSucceed, status = tryCall(UnitThreatSituation, "player", unit)
    if not didSucceed or status ~= nil and not isReadable(status) then
        return nil
    end
    return status ~= nil
end
function UnitsService.prototype.getHealthPercent(self, unit)
    local health = getReadable(attempt(UnitHealth, unit))
    local max = getReadable(attempt(UnitHealthMax, unit))
    if health ~= nil and max ~= nil and max > 0 then
        return health / max * 100
    end
    local curve = CurveConstants and CurveConstants.ScaleTo100
    if curve == nil then
        return nil
    end
    local percent = getReadable(attempt(UnitHealthPercent, unit, true, curve))
    return type(percent) == "number" and percent or nil
end
function UnitsService.prototype.getMaxHealth(self, unit)
    local max = getReadable(attempt(UnitHealthMax, unit))
    return max ~= nil and max > 0 and max or nil
end
function UnitsService.prototype.readPower(self, unit, powerType)
    local current = getReadable(attempt(UnitPower, unit, powerType))
    local max = getReadable(attempt(UnitPowerMax, unit, powerType))
    if type(current) ~= "number" or type(max) ~= "number" then
        return nil
    end
    return {current = current, max = max}
end
function UnitsService.prototype.readCast(self, unit)
    local casting = self:readCastFrom(
        function() return UnitCastingInfo(unit) end,
        8
    )
    if casting.isCasting then
        return casting
    end
    return self:readCastFrom(
        function() return UnitChannelInfo(unit) end,
        7
    )
end
function UnitsService.prototype.getRangeBand(self, unit)
    if not self:doesExist(unit) then
        return nil, nil
    end
    local didMeasure, distanceSquared, wasChecked = attemptMulti(function() return UnitDistanceSquared(unit) end)
    if didMeasure and isReadable(wasChecked) and wasChecked == true and isReadable(distanceSquared) and distanceSquared >= 0 then
        local yards = math.sqrt(distanceSquared)
        return yards, yards
    end
    local ____temp_10 = self:isWithinInteract(unit, DUEL_DISTANCE)
    if ____temp_10 == nil then
        ____temp_10 = self:isWithinInteract(unit, TRADE_DISTANCE)
    end
    local isClose = ____temp_10
    local isInspectable = self:isWithinInteract(unit, INSPECT_DISTANCE)
    if isClose == true then
        return 0, 11
    end
    if isInspectable == true then
        return 11, 28
    end
    if isInspectable == false then
        return 28, 100
    end
    return nil, nil
end
function UnitsService.prototype.isWithinDuelDistance(self, unit)
    local ____temp_11 = self:isWithinInteract(unit, DUEL_DISTANCE)
    if ____temp_11 == nil then
        ____temp_11 = self:isWithinInteract(unit, TRADE_DISTANCE)
    end
    return ____temp_11
end
function UnitsService.prototype.isWithinInspectDistance(self, unit)
    return self:isWithinInteract(unit, INSPECT_DISTANCE)
end
function UnitsService.prototype.isWithinInteract(self, unit, distance)
    if self.player:isInCombat() and getReadable(attempt(UnitCanAttack, "player", unit)) == false then
        return nil
    end
    local answer = getReadable(attempt(CheckInteractDistance, unit, distance))
    if answer == true or answer == 1 then
        return true
    end
    if answer == false or answer == 0 then
        return false
    end
    return nil
end
function UnitsService.prototype.readCastFrom(self, read, shieldIndex)
    local results = {pcall(read)}
    if results[1] ~= true or results[2] == nil then
        return {isCasting = false, isShielded = false}
    end
    local isShielded = results[shieldIndex + 1]
    return {
        isCasting = true,
        isShielded = isReadable(isShielded) and isShielded == true
    }
end
return ____exports
 end,
["packages.@wowkit.wow.src.weapon-enchants_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local contains = ____core.contains
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local tryCall = ____protected_2Dcall_2Eutils.tryCall
local ____secret_2Dvalue_2Eutils = require("packages.@wowkit.wow.src.utils.secret-value_utils")
local isReadable = ____secret_2Dvalue_2Eutils.isReadable
local getReadable = ____secret_2Dvalue_2Eutils.getReadable
local ____wow_2Econstants = require("packages.@wowkit.wow.src.wow_constants")
local MAIN_HAND_SLOT = ____wow_2Econstants.MAIN_HAND_SLOT
local NO_EXPIRY = ____wow_2Econstants.NO_EXPIRY
local OFF_HAND_SLOT = ____wow_2Econstants.OFF_HAND_SLOT
____exports.WeaponEnchantsService = __TS__Class()
local WeaponEnchantsService = ____exports.WeaponEnchantsService
WeaponEnchantsService.name = "WeaponEnchantsService"
function WeaponEnchantsService.prototype.____constructor(self)
    self.tooltipCacheAt = 0
end
function WeaponEnchantsService.prototype.getWeaponEnchant(self, isOffhand)
    return self:readTemporaryEnchant(isOffhand) or self:readItemEnchant(isOffhand) or ({has = nil, remain = 0})
end
function WeaponEnchantsService.prototype.clearWeaponTooltipCache(self)
    self.tooltipCacheAt = 0
    self.tooltipCache = nil
end
function WeaponEnchantsService.prototype.hasWeaponTooltipText(self, tokens)
    if #tokens == 0 then
        return false
    end
    for ____, text in ipairs(self:getWeaponTooltipTexts()) do
        for ____, token in ipairs(tokens) do
            if token ~= "" and contains(text, token) then
                return true
            end
        end
    end
    return false
end
function WeaponEnchantsService.prototype.getWeaponTooltipTexts(self)
    local now = GetTime()
    if self.tooltipCache and now - self.tooltipCacheAt < 1 then
        return self.tooltipCache
    end
    local texts = {}
    for ____, slot in ipairs({MAIN_HAND_SLOT, OFF_HAND_SLOT}) do
        local didSucceed, data = tryCall(C_TooltipInfo.GetInventoryItem, "player", slot)
        if didSucceed and data ~= nil and type(data) == "table" and data.lines then
            for ____, line in ipairs(data.lines) do
                local text = getReadable(line.leftText)
                if text ~= nil then
                    texts[#texts + 1] = string.lower(text)
                end
            end
        end
    end
    self.tooltipCacheAt = now
    self.tooltipCache = texts
    return texts
end
function WeaponEnchantsService.prototype.convertToNumber(self, value)
    if not isReadable(value) then
        return nil
    end
    return tonumber(value)
end
function WeaponEnchantsService.prototype.readTemporaryEnchant(self, isOffhand)
    local didSucceed, info = tryCall(C_PaperDollInfo.GetTemporaryEnchantmentInfo, isOffhand and OFF_HAND_SLOT or MAIN_HAND_SLOT)
    if not didSucceed then
        return nil
    end
    if info == nil then
        return {has = false, remain = 0, enchantId = 0}
    end
    if type(info) ~= "table" then
        return nil
    end
    local enchant = info
    local remainMs = self:convertToNumber(enchant.remainingTimeMs)
    local remain = remainMs ~= nil and remainMs / 1000 or 0
    return {
        has = true,
        remain = remain > 0 and remain or NO_EXPIRY,
        enchantId = self:convertToNumber(enchant.enchantID)
    }
end
function WeaponEnchantsService.prototype.isTemporaryOrImbue(self, entry)
    local kind = getReadable(entry.enchantType)
    return (kind == Enum.ItemEnchantType.Temporary or kind == Enum.ItemEnchantType.Imbue) and getReadable(entry.hasEnchant) == true
end
function WeaponEnchantsService.prototype.describeItemEnchant(self, entry)
    local remain = self:convertToNumber(entry.timeLeft) or 0
    if remain > 10000 then
        remain = remain / 1000
    end
    local enchantId = self:convertToNumber(entry.enchantID)
    return {has = true, remain = remain > 0 and remain or NO_EXPIRY, enchantId = enchantId ~= nil and enchantId > 0 and enchantId or nil}
end
function WeaponEnchantsService.prototype.readItemEnchant(self, isOffhand)
    local didSucceed, list = tryCall(C_Item.GetWeaponEnchantInfo, isOffhand and Enum.WeaponSlot.OffHand or Enum.WeaponSlot.MainHand)
    if not didSucceed or type(list) ~= "table" then
        return nil
    end
    for ____, entry in ipairs(list) do
        if self:isTemporaryOrImbue(entry) then
            return self:describeItemEnchant(entry)
        end
    end
    return {has = false, remain = 0, enchantId = 0}
end
return ____exports
 end,
["packages.@wowkit.wow.src.bar-refresh_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local Interval = ____core.Interval
local OnEvent = ____core.OnEvent
local OnGameEvent = ____core.OnGameEvent
local ____bar_2Dnames = require("packages.@wowkit.wow.src.bar-names")
local listAddonButtonNames = ____bar_2Dnames.listAddonButtonNames
local ____protected_2Dcall_2Eutils = require("packages.@wowkit.wow.src.utils.protected-call_utils")
local attempt = ____protected_2Dcall_2Eutils.attempt
--- The bars are mapped again this long after the last change (changes come in bursts).
local BAR_SETTLE = 0.5
--- How often the buttons of the bar addons are counted: they make buttons with no bar event (EllesmereUI after the login,
-- past the first map of the bars, a bar switched on in its options, and the buttons an addon registers), so a new count
-- maps the bars again.
local BUTTON_COUNT_INTERVAL_MS = 2000
____exports.BarRefreshService = __TS__Class()
local BarRefreshService = ____exports.BarRefreshService
BarRefreshService.name = "BarRefreshService"
function BarRefreshService.prototype.____constructor(self, actionBars, clock, registry)
    self.actionBars = actionBars
    self.clock = clock
    self.registry = registry
    self.generation = 0
    self.addonButtonCount = 0
    self.addonButtonNames = listAddonButtonNames()
end
function BarRefreshService.prototype.onFirstLogin(self)
    self.addonButtonCount = self:countAddonButtons()
end
function BarRefreshService.prototype.checkForNewButtons(self)
    if attempt(InCombatLockdown) == true then
        return
    end
    local count = self:countAddonButtons()
    if count == self.addonButtonCount then
        return
    end
    self.addonButtonCount = count
    self.actionBars:mapBars(true)
end
__TS__DecorateLegacy(
    {Interval(BUTTON_COUNT_INTERVAL_MS)},
    BarRefreshService.prototype,
    "checkForNewButtons",
    true
)
function BarRefreshService.prototype.scheduleBarRemap(self)
    self.actionBars:noteBarsChanged()
    self.generation = self.generation + 1
    local generation = self.generation
    self.clock:runAfter(
        BAR_SETTLE,
        function()
            if generation ~= self.generation then
                return
            end
            self.actionBars:mapBars(true)
        end
    )
end
__TS__DecorateLegacy(
    {OnGameEvent("SPELL_PUSHED_TO_ACTIONBAR", "ACTIONBAR_SLOT_CHANGED", "ACTIONBAR_PAGE_CHANGED")},
    BarRefreshService.prototype,
    "scheduleBarRemap",
    true
)
function BarRefreshService.prototype.scheduleRemapAfterSpellRefresh(self)
    self:scheduleBarRemap()
end
__TS__DecorateLegacy(
    {OnEvent("spells.refreshed")},
    BarRefreshService.prototype,
    "scheduleRemapAfterSpellRefresh",
    true
)
function BarRefreshService.prototype.countAddonButtons(self)
    local globals = _G
    local count = 0
    for ____, name in ipairs(self.addonButtonNames) do
        if globals[name] ~= nil then
            count = count + 1
        end
    end
    return count + self.registry:countButtons()
end
return ____exports
 end,
["packages.@wowkit.wow.src.spell-refresh_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnGameEvent = ____core.OnGameEvent
--- Spell lookups are cleared this long after a learn or a level-up.
local SPELL_SETTLE = 0.5
____exports.SpellRefreshService = __TS__Class()
local SpellRefreshService = ____exports.SpellRefreshService
SpellRefreshService.name = "SpellRefreshService"
function SpellRefreshService.prototype.____constructor(self, spells, clock, bus)
    self.spells = spells
    self.clock = clock
    self.bus = bus
    self.generation = 0
end
function SpellRefreshService.prototype.scheduleSpellRefresh(self)
    self.generation = self.generation + 1
    local generation = self.generation
    self.clock:runAfter(
        SPELL_SETTLE,
        function()
            if generation ~= self.generation then
                return
            end
            self.spells:invalidateSpells(false)
            self.bus:emit("spells.refreshed")
        end
    )
end
__TS__DecorateLegacy(
    {OnGameEvent("PLAYER_TALENT_UPDATE", "PLAYER_LEVEL_UP")},
    SpellRefreshService.prototype,
    "scheduleSpellRefresh",
    true
)
function SpellRefreshService.prototype.noteLearnedSpellAndRefresh(self, spellId)
    self.spells:noteLearnedSpell(spellId)
    self:scheduleSpellRefresh()
end
__TS__DecorateLegacy(
    {OnGameEvent("LEARNED_SPELL_IN_SKILL_LINE")},
    SpellRefreshService.prototype,
    "noteLearnedSpellAndRefresh",
    true
)
return ____exports
 end,
["packages.@wowkit.wow.src.index"] = function(...) 
local ____exports = {}
do
    local ____export = require("packages.@wowkit.wow.src.action-bars_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.auras_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.bags_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.bar-fade_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.bar-names")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.button-registry_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.character_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.clock_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.cooldowns_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.glow_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.notice_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.party_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.player_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.utils.protected-call_utils")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.utils.global_utils")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.utils.item-button_utils")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.utils.secret-value_utils")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.utils.spell-name_utils")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.saved-variables_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.spell-book_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.spell-cast_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.spell-details_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.spells_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.tooltip_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.totems_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.units_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.value-curves_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.weapon-enchants_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.wow_constants")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.bar-refresh_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.wow.src.spell-refresh_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
return ____exports
 end,
["packages.@wowkit.ui.src.sounds_constants"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__ArraySome = ____lualib.__TS__ArraySome
local ____exports = {}
--- Is this a sound of the list? A saved choice may be from a time the list was longer.
function ____exports.isSoundKey(value)
    return __TS__ArraySome(
        ____exports.SOUNDS,
        function(____, sound) return sound.key == value end
    )
end
--- The sounds the player can pick. The first entry is "no sound".
____exports.SOUNDS = {
    {key = "none", label = "No sound"},
    {key = "raidwarning", label = "Raid warning", kit = "RAID_WARNING", id = 8959},
    {key = "battlegroundstart", label = "Battleground start", kit = "UI_BATTLEGROUND_COUNTDOWN_FINISHED", id = 25478},
    {key = "rolecheck", label = "Role check", kit = "LFG_ROLE_CHECK", id = 17317},
    {key = "alarm1", label = "Alarm clock 1", kit = "ALARM_CLOCK_WARNING_1", id = 18871},
    {key = "alarm2", label = "Alarm clock 2", kit = "ALARM_CLOCK_WARNING_2", id = 12867},
    {key = "alarm3", label = "Alarm clock 3", kit = "ALARM_CLOCK_WARNING_3", id = 12889}
}
return ____exports
 end,
["packages.@wowkit.ui.src.messages_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____sounds_2Econstants = require("packages.@wowkit.ui.src.sounds_constants")
local SOUNDS = ____sounds_2Econstants.SOUNDS
____exports.MessagesService = __TS__Class()
local MessagesService = ____exports.MessagesService
MessagesService.name = "MessagesService"
function MessagesService.prototype.____constructor(self, notice, title)
    self.notice = notice
    self.title = title
end
function MessagesService.prototype.playAlertSound(self, key)
    local choice = __TS__ArrayFind(
        SOUNDS,
        function(____, sound) return sound.key == key end
    )
    if (choice and choice.id) == nil then
        return
    end
    self.notice:playSound(choice.kit, choice.id)
end
function MessagesService.prototype.say(self, message)
    self.notice:printToChat((("|cff66ccff" .. self.title) .. "|r: ") .. message)
end
return ____exports
 end,
["packages.@wowkit.ui.src.settings_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.SettingsService = __TS__Class()
local SettingsService = ____exports.SettingsService
SettingsService.name = "SettingsService"
function SettingsService.prototype.____constructor(self, savedVariables, bus, createDefaults, repair)
    self.savedVariables = savedVariables
    self.bus = bus
    self.createDefaults = createDefaults
    self.repair = repair
    self.values = createDefaults()
end
function SettingsService.prototype.onAddonLoaded(self)
    local saved = self.savedVariables:loadTable()
    if saved ~= nil then
        for key, value in pairs(saved) do
            self.values[key] = value
        end
    end
    local ____opt_0 = self.repair
    if ____opt_0 ~= nil then
        ____opt_0(self.values)
    end
    self.savedVariables:bindTable(self.values)
end
function SettingsService.prototype.get(self, key)
    return self.values[key]
end
function SettingsService.prototype.getDefault(self, key)
    return self.createDefaults()[key]
end
function SettingsService.prototype.change(self, key, value)
    self.values[key] = value
    self.bus:emit("setting.changed", key)
end
return ____exports
 end,
["packages.@wowkit.ui.src.controls_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____sounds_2Econstants = require("packages.@wowkit.ui.src.sounds_constants")
local SOUNDS = ____sounds_2Econstants.SOUNDS
____exports.ControlsService = __TS__Class()
local ControlsService = ____exports.ControlsService
ControlsService.name = "ControlsService"
function ControlsService.prototype.____constructor(self, settings, messages, variablePrefix)
    self.settings = settings
    self.messages = messages
    self.variablePrefix = variablePrefix
end
function ControlsService.prototype.addHeader(self, layout, label)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(label))
end
function ControlsService.prototype.addCheckbox(self, category, variable, label, tooltip, isOnByDefault, get, set)
    return Settings.CreateCheckbox(
        category,
        self:registerSetting(
            category,
            variable,
            Settings.VarType.Boolean,
            label,
            isOnByDefault,
            get,
            set
        ),
        tooltip
    )
end
function ControlsService.prototype.addSwitchCheckbox(self, category, key, label, tooltip)
    return self:addCheckbox(
        category,
        tostring(key),
        label,
        tooltip,
        self.settings:getDefault(key),
        function() return self.settings:get(key) end,
        function(isChecked) return self.settings:change(key, isChecked) end
    )
end
function ControlsService.prototype.addDropdown(self, category, variable, label, tooltip, defaultValue, get, set, items, isStatic)
    if isStatic == nil then
        isStatic = false
    end
    local setting = self:registerSetting(
        category,
        variable,
        Settings.VarType.String,
        label,
        defaultValue,
        get,
        set
    )
    local cached
    local function buildOptions()
        if isStatic and cached ~= nil then
            return cached
        end
        local container = Settings.CreateControlTextContainer()
        for ____, ____value in ipairs(items()) do
            local value = ____value[1]
            local text = ____value[2]
            container:Add(value, text)
        end
        local data = container:GetData()
        if isStatic then
            cached = data
        end
        return data
    end
    return Settings.CreateDropdown(category, setting, buildOptions, tooltip)
end
function ControlsService.prototype.addSoundDropdown(self, category, variable, label, tooltip, get, set)
    self:addDropdown(
        category,
        variable,
        label,
        tooltip,
        "none",
        get,
        function(value)
            set(value)
            self.messages:playAlertSound(value)
        end,
        function() return __TS__ArrayMap(
            SOUNDS,
            function(____, sound) return {sound.key, sound.label} end
        ) end,
        true
    )
end
function ControlsService.prototype.addColorSwatch(self, category, variable, label, defaultColor, get, set)
    local createSwatch = Settings.CreateColorSwatch
    if not createSwatch then
        return
    end
    local function convertToHexColor(____bindingPattern0)
        local b
        local g
        local r
        r = ____bindingPattern0[1]
        g = ____bindingPattern0[2]
        b = ____bindingPattern0[3]
        return CreateColor(r, g, b):GenerateHexColor()
    end
    local setting = self:registerSetting(
        category,
        "color_" .. variable,
        Settings.VarType.String,
        label,
        convertToHexColor(defaultColor),
        function() return convertToHexColor(get()) end,
        function(value)
            local picked = CreateColorFromHexString(value)
            if picked then
                set({picked.r, picked.g, picked.b})
            end
        end
    )
    createSwatch(category, setting)
end
function ControlsService.prototype.registerSetting(self, category, variable, varType, label, defaultValue, get, set)
    return Settings.RegisterProxySetting(
        category,
        (self.variablePrefix .. "_") .. variable,
        varType,
        label,
        defaultValue,
        get,
        set
    )
end
return ____exports
 end,
["packages.@wowkit.ui.src.widgets_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local attempt = ____wow.attempt
____exports.WidgetsService = __TS__Class()
local WidgetsService = ____exports.WidgetsService
WidgetsService.name = "WidgetsService"
function WidgetsService.prototype.____constructor(self, messages, texts)
    self.messages = messages
    self.texts = texts
end
function WidgetsService.prototype.addLinkButton(self, layout, label, url)
    layout:AddInitializer(CreateSettingsButtonInitializer(
        label,
        self.texts.copy,
        function() return self:copyText(url) end,
        url,
        false
    ))
end
function WidgetsService.prototype.addButton(self, layout, label, buttonText, onClick, tooltip)
    layout:AddInitializer(CreateSettingsButtonInitializer(
        label,
        buttonText,
        onClick,
        tooltip,
        false
    ))
end
function WidgetsService.prototype.copyText(self, text)
    local chat = ChatFrameUtil
    local openChat = chat and chat.OpenChat
    if openChat and attempt(function()
        openChat(text, DEFAULT_CHAT_FRAME)
        return true
    end) == true then
        local ____opt_2 = DEFAULT_CHAT_FRAME.editBox
        if ____opt_2 ~= nil then
            ____opt_2:HighlightText()
        end
        self.messages:say(self.texts.copied)
        return
    end
    local ____chat_ChooseBoxForSend_6
    if chat and chat.ChooseBoxForSend then
        ____chat_ChooseBoxForSend_6 = chat.ChooseBoxForSend()
    else
        ____chat_ChooseBoxForSend_6 = nil
    end
    local box = ____chat_ChooseBoxForSend_6 or DEFAULT_CHAT_FRAME.editBox
    if not box then
        self.messages:say(text)
        return
    end
    if chat and chat.ActivateChat then
        attempt(chat.ActivateChat, box)
    end
    box:SetText(text)
    box:HighlightText()
    box:SetFocus()
    self.messages:say(self.texts.copied)
end
return ____exports
 end,
["packages.@wowkit.ui.src.about_section"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.AboutSection = __TS__Class()
local AboutSection = ____exports.AboutSection
AboutSection.name = "AboutSection"
function AboutSection.prototype.____constructor(self, widgets, texts, githubUrl)
    self.widgets = widgets
    self.texts = texts
    self.githubUrl = githubUrl
end
function AboutSection.prototype.addAboutSection(self, layout)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(self.texts.header))
    self.widgets:addLinkButton(layout, self.texts.githubLabel, self.githubUrl)
    self.widgets:addLinkButton(layout, self.texts.issuesLabel, self.githubUrl .. "/issues")
end
return ____exports
 end,
["packages.@wowkit.ui.src.greeting_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.GreetingService = __TS__Class()
local GreetingService = ____exports.GreetingService
GreetingService.name = "GreetingService"
function GreetingService.prototype.____constructor(self, messages, greeting)
    self.messages = messages
    self.greeting = greeting
end
function GreetingService.prototype.onLogin(self)
    self.messages:say(self.greeting)
end
return ____exports
 end,
["packages.@wowkit.ui.src.locale_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.LocaleService = __TS__Class()
local LocaleService = ____exports.LocaleService
LocaleService.name = "LocaleService"
function LocaleService.prototype.____constructor(self, texts)
    self.texts = texts
end
function LocaleService.prototype.getText(self, key)
    return self.texts[key]
end
return ____exports
 end,
["packages.@wowkit.ui.src.options_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.OptionsService = __TS__Class()
local OptionsService = ____exports.OptionsService
OptionsService.name = "OptionsService"
function OptionsService.prototype.____constructor(self, messages, title, page)
    self.messages = messages
    self.title = title
    self.page = page
    self.isRegistered = false
end
function OptionsService.prototype.onFirstLogin(self)
    if self.isRegistered or type(Settings) == "nil" then
        return
    end
    self.isRegistered = true
    local didSucceed, ____error = pcall(function() return self:registerPage() end)
    if not didSucceed then
        self.messages:say(tostring(____error))
    end
end
function OptionsService.prototype.registerPage(self)
    local category, layout = Settings.RegisterVerticalLayoutCategory(self.title)
    self.page:buildPage(category, layout)
    Settings.RegisterAddOnCategory(category)
end
return ____exports
 end,
["packages.@wowkit.ui.src.index"] = function(...) 
local ____exports = {}
do
    local ____export = require("packages.@wowkit.ui.src.controls_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.ui.src.about_section")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.ui.src.greeting_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.ui.src.locale_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.ui.src.messages_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.ui.src.options_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.ui.src.settings_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.ui.src.sounds_constants")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("packages.@wowkit.ui.src.widgets_service")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
return ____exports
 end,
["addons.glowing-bars.src.api.public-api"] = function(...) 
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local BARS = ____wow.BARS
local setGlobal = ____wow.setGlobal
--- A whole number from `low` up; undefined for anything else.
local function readWhole(value, low)
    return type(value) == "number" and value >= low and math.floor(value) or nil
end
--- A shape the glow knows; undefined for anything else.
local function readShape(value)
    return (value == "Circle" or value == "Square") and value or nil
end
--- Puts the API in the global GlowingBars.
function ____exports.registerPublicApi(registry)
    local api = {
        RegisterButton = function(button, bar, shape)
            if type(button) ~= "table" then
                return
            end
            local number = readWhole(bar, 1)
            registry:registerButton(
                button,
                number ~= nil and number <= #BARS and number or nil,
                readShape(shape)
            )
        end,
        RegisterStanceButton = function(button, stance, shape)
            local index = readWhole(stance, 1)
            if type(button) == "table" and index ~= nil then
                registry:registerStanceButton(
                    button,
                    index,
                    readShape(shape)
                )
            end
        end
    }
    setGlobal("GlowingBars", api)
end
return ____exports
 end,
["addons.glowing-bars.src.knowledge.buff-categories_constants"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local ____exports = {}
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local H = ____wow_2Ddata.Hunter
local M = ____wow_2Ddata.Mage
local P = ____wow_2Ddata.Paladin
local Pr = ____wow_2Ddata.Priest
local D = ____wow_2Ddata.Druid
local L = ____wow_2Ddata.Warlock
local Tracking = ____wow_2Ddata.Tracking
local ____array_0 = __TS__SparseArrayNew(
    P.BlessingMight,
    P.BlessingKings,
    P.BlessingWisdom,
    P.BlessingSalvation,
    P.BlessingLight,
    unpack(P.GreaterBlessingMight)
)
__TS__SparseArrayPush(
    ____array_0,
    unpack(P.GreaterBlessingKings)
)
__TS__SparseArrayPush(
    ____array_0,
    unpack(P.GreaterBlessingWisdom)
)
__TS__SparseArrayPush(
    ____array_0,
    unpack(P.GreaterBlessingSalvation)
)
__TS__SparseArrayPush(
    ____array_0,
    unpack(P.GreaterBlessingLight)
)
____exports.BUFF_CATEGORIES = {
    {
        key = "blessing",
        members = {__TS__SparseArraySpread(____array_0)},
        seconds = 300
    },
    {key = "palaura", members = {
        P.DevotionAura,
        P.RetributionAura,
        P.ConcentrationAura,
        P.SanctityAura,
        P.FireResistAura,
        P.FrostResistAura,
        P.ShadowResistAura
    }, seconds = 1800},
    {key = "missingSeal", members = {
        P.SealOfRighteousness,
        P.SealOfCommand,
        P.SealOfTheCrusader,
        P.SealOfWisdom,
        P.SealOfLight,
        P.SealOfJustice,
        P.SealOfFury
    }, seconds = 30},
    {
        key = "missingTracking",
        members = __TS__ObjectValues(Tracking),
        seconds = 1800
    },
    {key = "aspect", members = {
        H.AspectHawk,
        H.AspectMonkey,
        H.AspectWild,
        H.AspectCheetah,
        H.AspectPack,
        H.AspectBeast
    }, seconds = 1800},
    {key = "magearmor", members = {M.MageArmor, M.IceArmor, M.FrostArmor}, seconds = 1800},
    {key = "lockarmor", members = {L.DemonArmor, L.DemonSkin}, seconds = 1800},
    {
        key = "fortitude",
        members = {
            Pr.PowerWordFortitude,
            unpack(Pr.PrayerOfFortitude)
        },
        seconds = 1800
    },
    {
        key = "spirit",
        members = {
            Pr.DivineSpirit,
            unpack(Pr.PrayerOfSpirit)
        },
        seconds = 1800
    },
    {
        key = "shadowprotection",
        members = {
            Pr.ShadowProtection,
            unpack(Pr.PrayerOfShadowProtection)
        },
        seconds = 600
    },
    {
        key = "wild",
        members = {
            D.MarkOfTheWild,
            unpack(D.GiftOfTheWild)
        },
        seconds = 1800
    },
    {
        key = "intellect",
        members = {
            M.ArcaneIntellect,
            unpack(M.ArcaneBrilliance)
        },
        seconds = 1800
    }
}
return ____exports
 end,
["addons.glowing-bars.src.settings.settings_interface"] = function(...) 
local ____exports = {}
return ____exports
 end,
["addons.glowing-bars.src.reminders.class-buff_interface"] = function(...) 
local ____exports = {}
return ____exports
 end,
["addons.glowing-bars.src.reminders.class-buffs_constants"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local D = ____wow_2Ddata.Druid
local H = ____wow_2Ddata.Hunter
local M = ____wow_2Ddata.Mage
local P = ____wow_2Ddata.Paladin
local Pr = ____wow_2Ddata.Priest
local Sh = ____wow_2Ddata.Shaman
local L = ____wow_2Ddata.Warlock
local W = ____wow_2Ddata.Warrior
local function createClassBuff(key, id, options, isOnByDefault)
    if options == nil then
        options = {}
    end
    if isOnByDefault == nil then
        isOnByDefault = true
    end
    return __TS__ObjectAssign({key = key, id = id, isOnByDefault = isOnByDefault}, options)
end
--- A blessing: the player's own counts, its Greater version covers one class.
local function createBlessing(groupIds)
    return {groupIds = groupIds, isPerClass = true, isOwnOnly = true}
end
local mageArmors = {M.MageArmor, M.IceArmor, M.FrostArmor}
local lockSkins = {L.DemonArmor, L.DemonSkin}
local shamanShields = {Sh.LightningShield, Sh.WaterShield}
local palaAuras = {
    P.DevotionAura,
    P.RetributionAura,
    P.ConcentrationAura,
    P.SanctityAura,
    P.FireResistAura,
    P.FrostResistAura,
    P.ShadowResistAura
}
local palaBlessings = {
    P.BlessingMight,
    P.BlessingKings,
    P.BlessingWisdom,
    P.BlessingSalvation,
    P.BlessingLight
}
local hunterAspects = {
    H.AspectHawk,
    H.AspectMonkey,
    H.AspectWild,
    H.AspectCheetah,
    H.AspectPack,
    H.AspectBeast
}
--- Of a group, the buff each talent tree (by its place in the client's list) wants first, before the player has cast one:
-- the list of the tree, in order; a buff of another group in the same list is skipped.
____exports.TALENT_BUFFS = {PALADIN = {[1] = {P.ConcentrationAura, P.BlessingWisdom}, [2] = {P.DevotionAura, P.BlessingKings}, [3] = {P.SanctityAura, P.RetributionAura, P.BlessingMight}}, SHAMAN = {[1] = {Sh.LightningShield}, [2] = {Sh.LightningShield}, [3] = {Sh.WaterShield}}, MAGE = {[1] = {M.MageArmor}, [2] = {M.MageArmor}, [3] = {M.IceArmor}}}
--- Classes with mana that fight with weapons: Kings or Might, not Wisdom.
____exports.WEAPON_MANA_CLASSES = {"HUNTER"}
____exports.PARTY_BLESSINGS = {mana = {P.BlessingWisdom, P.BlessingKings, P.BlessingMight}, other = {P.BlessingKings, P.BlessingMight, P.BlessingWisdom}}
--- Battle Shout's reminder comes this many seconds before it runs out: it runs out in a fight, and needs rage.
local BATTLE_SHOUT_LEAD = 3
--- In list order: of a category, the first one that is learned and on the bars is the one asked for.
____exports.BUFF_LISTS = {
    DRUID = {
        createClassBuff("MarkoftheWild", D.MarkOfTheWild, {last = 1800, party = {groupIds = D.GiftOfTheWild}}),
        createClassBuff("Thorns", D.Thorns, {last = 600}),
        createClassBuff("Moonkin", D.Moonkin, {}, false)
    },
    PALADIN = {
        createClassBuff("DevotionAura", P.DevotionAura, {categoryMembers = palaAuras}),
        createClassBuff("RetributionAura", P.RetributionAura, {categoryMembers = palaAuras}),
        createClassBuff("ConcentrationAura", P.ConcentrationAura, {categoryMembers = palaAuras}),
        createClassBuff("SanctityAura", P.SanctityAura, {categoryMembers = palaAuras}),
        createClassBuff("FireResistAura", P.FireResistAura, {categoryMembers = palaAuras}),
        createClassBuff("FrostResistAura", P.FrostResistAura, {categoryMembers = palaAuras}),
        createClassBuff("ShadowResistAura", P.ShadowResistAura, {categoryMembers = palaAuras}),
        createClassBuff(
            "BlessingMight",
            P.BlessingMight,
            {
                categoryMembers = palaBlessings,
                party = createBlessing(P.GreaterBlessingMight)
            }
        ),
        createClassBuff(
            "BlessingKings",
            P.BlessingKings,
            {
                categoryMembers = palaBlessings,
                party = createBlessing(P.GreaterBlessingKings)
            }
        ),
        createClassBuff(
            "BlessingWisdom",
            P.BlessingWisdom,
            {
                categoryMembers = palaBlessings,
                party = createBlessing(P.GreaterBlessingWisdom)
            }
        ),
        createClassBuff("RighteousFury", P.RighteousFury, {last = 1800}, false)
    },
    WARRIOR = {createClassBuff("BattleShout", W.BattleShout, {last = 120, lead = BATTLE_SHOUT_LEAD})},
    HUNTER = {
        createClassBuff("AspectHawk", H.AspectHawk, {categoryMembers = hunterAspects}),
        createClassBuff("AspectMonkey", H.AspectMonkey, {categoryMembers = hunterAspects}),
        createClassBuff("AspectWild", H.AspectWild, {categoryMembers = hunterAspects}),
        createClassBuff("TrueshotAura", H.TrueshotAura, {last = 1800})
    },
    ROGUE = {},
    PRIEST = {
        createClassBuff("InnerFire", Pr.InnerFire, {last = 600}),
        createClassBuff("PowerWordFortitude", Pr.PowerWordFortitude, {last = 1800, party = {groupIds = Pr.PrayerOfFortitude}}),
        createClassBuff("DivineSpirit", Pr.DivineSpirit, {last = 1800, party = {groupIds = Pr.PrayerOfSpirit}}),
        createClassBuff("ShadowProtection", Pr.ShadowProtection, {last = 600, party = {groupIds = Pr.PrayerOfShadowProtection}}),
        createClassBuff("Shadowform", Pr.Shadowform, {last = 1800})
    },
    SHAMAN = {
        createClassBuff("LightningShield", Sh.LightningShield, {categoryMembers = shamanShields, last = 600}),
        createClassBuff("WaterShield", Sh.WaterShield, {categoryMembers = shamanShields, last = 600})
    },
    MAGE = {
        createClassBuff("ArcaneIntellect", M.ArcaneIntellect, {last = 1800, party = {groupIds = M.ArcaneBrilliance, isManaOnly = true}}),
        createClassBuff("MageArmor", M.MageArmor, {categoryMembers = mageArmors}),
        createClassBuff("IceArmor", M.IceArmor, {categoryMembers = mageArmors}),
        createClassBuff("FrostArmor", M.FrostArmor, {categoryMembers = mageArmors}),
        createClassBuff("AmplifyMagic", M.AmplifyMagic, {last = 600}, false)
    },
    WARLOCK = {
        createClassBuff("DemonArmor", L.DemonArmor, {categoryMembers = lockSkins}),
        createClassBuff("DemonSkin", L.DemonSkin, {categoryMembers = lockSkins}),
        createClassBuff("UnendingBreath", L.UnendingBreath, {isSwimmingOnly = true, last = 600})
    }
}
return ____exports
 end,
["addons.glowing-bars.src.reminders.class-buffs_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____class_2Dbuffs_2Econstants = require("addons.glowing-bars.src.reminders.class-buffs_constants")
local BUFF_LISTS = ____class_2Dbuffs_2Econstants.BUFF_LISTS
local TALENT_BUFFS = ____class_2Dbuffs_2Econstants.TALENT_BUFFS
____exports.ClassBuffsService = __TS__Class()
local ClassBuffsService = ____exports.ClassBuffsService
ClassBuffsService.name = "ClassBuffsService"
function ClassBuffsService.prototype.____constructor(self, player, spells, settings)
    self.player = player
    self.spells = spells
    self.settings = settings
end
function ClassBuffsService.prototype.getClassBuffs(self)
    local token = self.player:getClassToken()
    local ____temp_0
    if token ~= nil then
        ____temp_0 = BUFF_LISTS[token]
    else
        ____temp_0 = nil
    end
    return ____temp_0 or ({})
end
function ClassBuffsService.prototype.getBuffSeconds(self, spellId, name)
    for ____, classBuff in ipairs(self:getClassBuffs()) do
        if classBuff.last ~= nil and (classBuff.id == spellId or self.spells:getSpellName(classBuff.id) == name) then
            return classBuff.last
        end
    end
    return 30
end
function ClassBuffsService.prototype.isBuffEnabled(self, classBuff)
    local ____table_classBuff_key_1 = self.settings:get("enabledBuffs")[classBuff.key]
    if ____table_classBuff_key_1 == nil then
        ____table_classBuff_key_1 = classBuff.isOnByDefault
    end
    return ____table_classBuff_key_1
end
function ClassBuffsService.prototype.setBuffEnabled(self, classBuff, isOn)
    local enabledBuffs = __TS__ObjectAssign(
        {},
        self.settings:get("enabledBuffs")
    )
    local ____classBuff_key_3 = classBuff.key
    local ____temp_2
    if isOn == classBuff.isOnByDefault then
        ____temp_2 = nil
    else
        ____temp_2 = isOn
    end
    enabledBuffs[____classBuff_key_3] = ____temp_2
    self.settings:change("enabledBuffs", enabledBuffs)
end
function ClassBuffsService.prototype.pickGroupBuff(self, members)
    local first = members[1]
    if #members == 1 then
        return first
    end
    local last = self.settings:get("lastBuffs")[self:getGroupKey(first)]
    local castLast = __TS__ArrayFind(
        members,
        function(____, member) return member.id == last end
    )
    if castLast ~= nil then
        return castLast
    end
    local tree = self.player:findMainTalentTree()
    local token = self.player:getClassToken()
    local ____temp_6
    if tree ~= nil and token ~= nil then
        local ____opt_4 = TALENT_BUFFS[token]
        ____temp_6 = ____opt_4 and ____opt_4[tree] or ({})
    else
        ____temp_6 = {}
    end
    local wanted = ____temp_6
    for ____, id in ipairs(wanted) do
        local found = __TS__ArrayFind(
            members,
            function(____, member) return member.id == id end
        )
        if found ~= nil then
            return found
        end
    end
    return first
end
function ClassBuffsService.prototype.getGroupKey(self, classBuff)
    local ____string_format_9 = string.format
    local ____opt_7 = classBuff.categoryMembers
    return ____string_format_9("%d", ____opt_7 and ____opt_7[1] or classBuff.id)
end
return ____exports
 end,
["addons.glowing-bars.src.knowledge.buff-knowledge_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local ____wow = require("packages.@wowkit.wow.src.index")
local buildNameKey = ____wow.buildNameKey
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local Druid = ____wow_2Ddata.Druid
local ____buff_2Dcategories_2Econstants = require("addons.glowing-bars.src.knowledge.buff-categories_constants")
local BUFF_CATEGORIES = ____buff_2Dcategories_2Econstants.BUFF_CATEGORIES
--- The shapeshift forms: they have no end, and change only with a shapeshift.
local FORMS = {
    Druid.BearForm,
    Druid.DireBearForm,
    Druid.CatForm,
    Druid.TravelForm,
    Druid.AquaticForm,
    Druid.Moonkin
}
____exports.BuffKnowledgeService = __TS__Class()
local BuffKnowledgeService = ____exports.BuffKnowledgeService
BuffKnowledgeService.name = "BuffKnowledgeService"
function BuffKnowledgeService.prototype.____constructor(self, classBuffs, spells)
    self.classBuffs = classBuffs
    self.spells = spells
end
function BuffKnowledgeService.prototype.forgetNames(self)
    self.categoryByName = nil
    self.formKeys = nil
end
__TS__DecorateLegacy(
    {OnEvent("spells.invalidated")},
    BuffKnowledgeService.prototype,
    "forgetNames",
    true
)
function BuffKnowledgeService.prototype.findCategory(self, name)
    if name == nil or name == "" then
        return nil
    end
    return self:getCategoryNames()[buildNameKey(name)]
end
function BuffKnowledgeService.prototype.isFormKey(self, key)
    if not self.formKeys then
        self.formKeys = {}
        for ____, spellId in ipairs(FORMS) do
            for ____, name in ipairs(self:listNames(spellId)) do
                self.formKeys[buildNameKey(name)] = true
            end
        end
    end
    return self.formKeys[key] ~= nil
end
function BuffKnowledgeService.prototype.getSeconds(self, spellId, name)
    return self.classBuffs:getBuffSeconds(spellId, name)
end
function BuffKnowledgeService.prototype.getCategoryNames(self)
    if self.categoryByName then
        return self.categoryByName
    end
    local names = {}
    for ____, category in ipairs(BUFF_CATEGORIES) do
        for ____, spellId in ipairs(category.members) do
            for ____, name in ipairs(self:listNames(spellId)) do
                names[buildNameKey(name)] = category
            end
        end
    end
    self.categoryByName = names
    return names
end
function BuffKnowledgeService.prototype.listNames(self, spellId)
    local names = {}
    local clientName = self.spells:getSpellName(spellId)
    local hintName = self.spells:getHintName(spellId)
    if clientName ~= nil and clientName ~= "" then
        names[#names + 1] = clientName
    end
    if hintName ~= nil and hintName ~= "" then
        names[#names + 1] = hintName
    end
    return names
end
return ____exports
 end,
["addons.glowing-bars.src.character.buff-memory_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local hasKnownExpiry = ____wow.hasKnownExpiry
local buildNameKey = ____wow.buildNameKey
--- A shapeshift form (Cat Form, Travel Form...): no end, only changes with a shapeshift.
local FORM_SECONDS = 1800
--- After a cast, a missing aura is not believed for this long (it may not have arrived yet).
local CAST_SETTLE = 1
--- After a shapeshift, the form cast this recently is the new one.
local FORM_CAST_SETTLE = 1.5
____exports.BuffMemoryService = __TS__Class()
local BuffMemoryService = ____exports.BuffMemoryService
BuffMemoryService.name = "BuffMemoryService"
function BuffMemoryService.prototype.____constructor(self, spells, clock, knowledge)
    self.spells = spells
    self.clock = clock
    self.knowledge = knowledge
    self.heldNames = {}
    self.heldCategories = {}
    self.castAt = {}
end
function BuffMemoryService.prototype.isEmpty(self)
    return next(self.heldNames) == nil and next(self.heldCategories) == nil
end
function BuffMemoryService.prototype.remember(self, spellId, auraName, remain, isFromCast)
    local name = auraName or self.spells:getSpellName(spellId)
    if name == nil or name == "" then
        return
    end
    local key = buildNameKey(name)
    local category = self.knowledge:findCategory(name)
    local seconds = category and category.seconds or (self.knowledge:isFormKey(key) and FORM_SECONDS or self.knowledge:getSeconds(spellId, name))
    local now = self.clock:getCurrentTime()
    local expires = self:findExpiry(
        key,
        now,
        seconds,
        remain,
        isFromCast
    )
    if expires ~= nil then
        self.heldNames[key] = expires
        if category then
            self.heldCategories[category.key] = expires
        end
    end
    if isFromCast then
        self.castAt[key] = now
        if category then
            self.castAt[category.key] = now
        end
    end
end
function BuffMemoryService.prototype.isRemembered(self, spellId, lead)
    if lead == nil then
        lead = 0
    end
    local name = self.spells:getSpellName(spellId)
    if name == nil or name == "" then
        return false
    end
    local now = self.clock:getCurrentTime() + lead
    if now < (self.heldNames[buildNameKey(name)] or 0) then
        return true
    end
    local category = self.knowledge:findCategory(name)
    return category ~= nil and now < (self.heldCategories[category.key] or 0)
end
function BuffMemoryService.prototype.release(self, spellId, categoriesSeen)
    local name = self.spells:getSpellName(spellId)
    if name == nil or name == "" then
        return
    end
    local key = buildNameKey(name)
    local now = self.clock:getCurrentTime()
    if now - (self.castAt[key] or -10) < CAST_SETTLE then
        return
    end
    self.heldNames[key] = nil
    local category = self.knowledge:findCategory(name)
    if category and not (categoriesSeen and categoriesSeen[category.key] ~= nil) and now - (self.castAt[category.key] or -10) >= CAST_SETTLE then
        self.heldCategories[category.key] = nil
    end
end
function BuffMemoryService.prototype.forgetForms(self)
    local now = self.clock:getCurrentTime()
    for key in pairs(self.heldNames) do
        if self.knowledge:isFormKey(key) and now - (self.castAt[key] or -10) >= FORM_CAST_SETTLE then
            self.heldNames[key] = nil
        end
    end
end
function BuffMemoryService.prototype.findExpiry(self, key, now, seconds, remain, isFromCast)
    if remain ~= nil and hasKnownExpiry(remain) then
        return now + remain
    end
    local isRenewal = isFromCast or remain ~= nil or (self.heldNames[key] or 0) <= now
    return isRenewal and now + seconds or nil
end
return ____exports
 end,
["addons.glowing-bars.src.character.buff-state_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local isReadable = ____wow.isReadable
local buildNameKey = ____wow.buildNameKey
local hasKnownExpiry = ____wow.hasKnownExpiry
____exports.BuffStateService = __TS__Class()
local BuffStateService = ____exports.BuffStateService
BuffStateService.name = "BuffStateService"
function BuffStateService.prototype.____constructor(self, auras, spells, player, memory, knowledge)
    self.auras = auras
    self.spells = spells
    self.player = player
    self.memory = memory
    self.knowledge = knowledge
end
function BuffStateService.prototype.wipeAuraScans(self)
    self.auras:wipeAuraScans()
end
function BuffStateService.prototype.wipeAuraScan(self, unit)
    self.auras:wipeAuraScan(unit)
end
function BuffStateService.prototype.findAura(self, spellId)
    if spellId == nil then
        return {isFound = false, remain = 0, isUnreadable = false}
    end
    return self.auras:readPlayerAura(spellId) or self:readFromScan(spellId)
end
function BuffStateService.prototype.hasAura(self, spellId, lead)
    if lead == nil then
        lead = 0
    end
    local read = self:findAura(spellId)
    if read.isFound then
        self.memory:remember(spellId, nil, read.remain, false)
        return lead == 0 or not hasKnownExpiry(read.remain) or read.remain > lead
    end
    if read.isUnreadable then
        return self.memory:isRemembered(spellId, lead)
    end
    self.memory:release(spellId, read.categories)
    return false
end
function BuffStateService.prototype.findAuras(self, spellId)
    local scan = self.auras:scanAuras("player")
    if scan.isUnreadable or __TS__ArraySome(
        scan.auras,
        function(____, aura) return aura.isHidden or aura.name == nil end
    ) then
        return nil
    end
    local wantKey = buildNameKey(self:getBuffName(spellId) or "")
    return __TS__ArrayFilter(
        scan.auras,
        function(____, aura) return buildNameKey(aura.name) == wantKey end
    )
end
function BuffStateService.prototype.noteSelfBuff(self, spellId)
    if spellId == nil or not isReadable(spellId) then
        return
    end
    self.memory:remember(spellId, nil, nil, true)
end
function BuffStateService.prototype.noteFormChange(self)
    self.memory:forgetForms()
    self.auras:wipeAuraScans()
end
function BuffStateService.prototype.getUnitBuffState(self, unit, spellId, isOwnOnly)
    local wantName = self:getBuffName(spellId)
    if wantName == nil then
        return "unknown"
    end
    local wantKey = buildNameKey(wantName)
    local wantCategory = self.knowledge:findCategory(wantName)
    local scan = self.auras:scanAuras(unit)
    local isUnreadable = scan.isUnreadable
    for ____, aura in ipairs(scan.auras) do
        local verdict = self:judgeUnitAura(aura, wantKey, wantCategory, isOwnOnly)
        if verdict == "has" then
            return "has"
        end
        if verdict == "hidden" then
            isUnreadable = true
        end
    end
    return isUnreadable and "unknown" or "missing"
end
function BuffStateService.prototype.findOwnUnitBuff(self, unit, buffs)
    for ____, aura in ipairs(self.auras:scanAuras(unit).auras) do
        do
            local __continue24
            repeat
                if aura.isHidden or aura.name == nil or aura.caster ~= "player" then
                    __continue24 = true
                    break
                end
                local auraKey = buildNameKey(aura.name)
                for ____, ____value in ipairs(buffs) do
                    local key = ____value[1]
                    local spellIds = ____value[2]
                    if __TS__ArraySome(
                        spellIds,
                        function(____, id) return self:getBuffName(id) == aura.name or buildNameKey(self.spells:getHintName(id) or "") == auraKey end
                    ) then
                        return key
                    end
                end
                __continue24 = true
            until true
            if not __continue24 then
                break
            end
        end
    end
    return nil
end
function BuffStateService.prototype.judgeUnitAura(self, aura, wantKey, wantCategory, isOwnOnly)
    if aura.isHidden or aura.name == nil then
        return "hidden"
    end
    local isWanted = buildNameKey(aura.name) == wantKey or wantCategory ~= nil and self.knowledge:findCategory(aura.name) == wantCategory
    if not isWanted then
        return "other"
    end
    if not isOwnOnly or aura.caster == "player" then
        return "has"
    end
    return aura.caster == "hidden" and "hidden" or "other"
end
function BuffStateService.prototype.getBuffName(self, spellId)
    return self.spells:getSpellName(self.spells:resolve(spellId) or spellId) or self.spells:getSpellLabel(spellId)
end
function BuffStateService.prototype.readFromScan(self, spellId)
    local resolved = self.spells:resolve(spellId)
    local wantName = self:getBuffName(spellId)
    local scan = self.auras:scanAuras("player")
    local hasHiddenAura = __TS__ArraySome(
        scan.auras,
        function(____, aura) return aura.isHidden or aura.name == nil end
    )
    local isUnreadable = scan.isUnreadable or hasHiddenAura or #scan.auras == 0 and self:isEmptyListSuspicious()
    local ____temp_0 = self:indexAuras(scan.auras)
    local names = ____temp_0.names
    local ids = ____temp_0.ids
    local categories = ____temp_0.categories
    local wantCategory = self.knowledge:findCategory(wantName)
    local ____temp_1
    if wantName ~= nil then
        ____temp_1 = names[buildNameKey(wantName)]
    else
        ____temp_1 = nil
    end
    local ____temp_1_3 = ____temp_1
    if ____temp_1_3 == nil then
        local ____temp_2
        if resolved ~= nil then
            ____temp_2 = ids[resolved]
        else
            ____temp_2 = nil
        end
        ____temp_1_3 = ____temp_2
    end
    local ____temp_5 = ____temp_1_3 or ids[spellId]
    if ____temp_5 == nil then
        local ____wantCategory_4
        if wantCategory then
            ____wantCategory_4 = categories[wantCategory.key]
        else
            ____wantCategory_4 = nil
        end
        ____temp_5 = ____wantCategory_4
    end
    local aura = ____temp_5
    if aura then
        return {isFound = true, remain = aura.remain, isUnreadable = false, categories = categories}
    end
    return {isFound = false, remain = 0, isUnreadable = isUnreadable, categories = categories}
end
function BuffStateService.prototype.indexAuras(self, auras)
    local names = {}
    local ids = {}
    local categories = {}
    for ____, aura in ipairs(auras) do
        do
            local __continue40
            repeat
                if aura.isHidden then
                    __continue40 = true
                    break
                end
                if aura.spellId ~= nil then
                    ids[aura.spellId] = aura
                end
                if aura.name == nil then
                    __continue40 = true
                    break
                end
                names[buildNameKey(aura.name)] = aura
                local category = self.knowledge:findCategory(aura.name)
                if category then
                    categories[category.key] = aura
                end
                __continue40 = true
            until true
            if not __continue40 then
                break
            end
        end
    end
    return {names = names, ids = ids, categories = categories}
end
function BuffStateService.prototype.isEmptyListSuspicious(self)
    return not self.memory:isEmpty() and self.player:isInCombat()
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.weapon.weapon-buff_interface"] = function(...) 
local ____exports = {}
return ____exports
 end,
["addons.glowing-bars.src.reminders.reminders_interface"] = function(...) 
local ____exports = {}
return ____exports
 end,
["addons.glowing-bars.src.reminders.weapon.weapon-buffs_constants"] = function(...) 
local ____exports = {}
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local Rogue = ____wow_2Ddata.Rogue
local Shaman = ____wow_2Ddata.Shaman
local Warlock = ____wow_2Ddata.Warlock
____exports.WEAPON_BUFFS = {SHAMAN = {{
    key = "Windfury",
    id = Shaman.Windfury[1],
    duration = 3600,
    ranks = Shaman.Windfury,
    enchants = {
        283,
        284,
        525,
        1669,
        7569
    },
    match = {"windfury"}
}, {
    key = "Flametongue",
    id = Shaman.Flametongue[1],
    duration = 3600,
    ranks = Shaman.Flametongue,
    enchants = {
        3,
        4,
        5,
        523,
        1665,
        1666,
        7567
    },
    match = {"flametongue"}
}, {
    key = "Rockbiter",
    id = Shaman.Rockbiter[1],
    duration = 3600,
    ranks = Shaman.Rockbiter,
    enchants = {
        1,
        6,
        29,
        503,
        504,
        683,
        1663,
        1664,
        7568
    },
    match = {"rockbiter"}
}, {
    key = "Frostbrand",
    id = Shaman.Frostbrand[1],
    duration = 3600,
    ranks = Shaman.Frostbrand,
    enchants = {
        2,
        12,
        524,
        1667,
        1668,
        7566
    },
    match = {"frostbrand"}
}}, ROGUE = {
    {
        key = "InstantPoison",
        name = "Instant Poison",
        id = Rogue.InstantPoison,
        items = {
            {item = 6947, spell = 8679},
            {item = 6949, spell = 8686},
            {item = 6950, spell = 8688},
            {item = 8926, spell = 11338},
            {item = 8927, spell = 11339},
            {item = 8928, spell = 11340}
        },
        duration = 1800,
        enchants = {
            323,
            324,
            325,
            623,
            624,
            625
        },
        match = {"instant poison"}
    },
    {
        key = "DeadlyPoison",
        name = "Deadly Poison",
        id = Rogue.DeadlyPoison,
        items = {
            {item = 2892, spell = 2823},
            {item = 2893, spell = 2824},
            {item = 8984, spell = 11355},
            {item = 8985, spell = 11356},
            {item = 20844, spell = 25351}
        },
        duration = 1800,
        enchants = {
            7,
            8,
            626,
            627,
            2630
        },
        match = {"deadly poison"}
    },
    {
        key = "CripplingPoison",
        name = "Crippling Poison",
        id = Rogue.CripplingPoison,
        items = {{item = 3775, spell = 3408}, {item = 3776, spell = 11202}},
        duration = 1800,
        enchants = {22, 603},
        match = {"crippling"}
    },
    {
        key = "WoundPoison",
        name = "Wound Poison",
        id = Rogue.WoundPoison,
        items = {{item = 10918, spell = 13219}, {item = 10920, spell = 13225}, {item = 10921, spell = 13226}, {item = 10922, spell = 13227}},
        duration = 1800,
        enchants = {703, 704, 705, 706},
        match = {"wound poison"}
    },
    {
        key = "MindNumbingPoison",
        name = "Mind-numbing Poison",
        id = Rogue.MindNumbingPoison,
        items = {{item = 5237, spell = 5761}, {item = 6951, spell = 8693}, {item = 9186, spell = 11399}},
        duration = 1800,
        enchants = {23, 35, 643},
        match = {"mind-numbing", "mind numbing"}
    }
}, WARLOCK = {{
    key = "Firestone",
    id = Warlock.Firestone,
    items = {{item = 1254, spell = 758}, {item = 13699, spell = 17945}, {item = 13700, spell = 17947}, {item = 13701, spell = 17949}},
    duration = 7200,
    enchants = {1803, 1823, 1824, 1825},
    match = {"firestone"}
}, {
    key = "Spellstone",
    id = Warlock.Spellstone,
    items = {{item = 5522, spell = 1237152}, {item = 13602, spell = 1237156}, {item = 13603, spell = 1237159}},
    duration = 7200,
    enchants = {8059, 8060, 8061},
    match = {"spellstone"}
}}}
--- The automatic pick, best first (melee shamans pick Windfury on the options page).
____exports.WEAPON_PRIORITY = {SHAMAN = {"Flametongue", "Rockbiter", "Frostbrand", "Windfury"}, ROGUE = {
    "InstantPoison",
    "DeadlyPoison",
    "WoundPoison",
    "CripplingPoison",
    "MindNumbingPoison"
}}
--- The weapon buff each talent tree (by its place: a shaman's Elemental, Enhancement, Restoration) wants, before any is put on.
____exports.TALENT_WEAPON_BUFFS = {SHAMAN = {[1] = "Flametongue", [2] = "Windfury", [3] = "Flametongue"}}
--- Classes that coat both weapons, and what goes on the off-hand by default.
____exports.OFFHAND_PRIORITY = {ROGUE = {
    "DeadlyPoison",
    "InstantPoison",
    "CripplingPoison",
    "WoundPoison",
    "MindNumbingPoison"
}}
____exports.WEAPON_BUFF_BY_SPELL = {}
____exports.WEAPON_BUFF_BY_ENCHANT = {}
for ____, list in pairs(____exports.WEAPON_BUFFS) do
    for ____, entry in ipairs(list or ({})) do
        ____exports.WEAPON_BUFF_BY_SPELL[entry.id] = entry
        for ____, rankId in ipairs(entry.ranks or ({})) do
            ____exports.WEAPON_BUFF_BY_SPELL[rankId] = entry
        end
        for ____, ____value in ipairs(entry.items or ({})) do
            local spell = ____value.spell
            ____exports.WEAPON_BUFF_BY_SPELL[spell] = entry
        end
        for ____, enchantId in ipairs(entry.enchants) do
            ____exports.WEAPON_BUFF_BY_ENCHANT[enchantId] = entry
        end
    end
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.weapon.weapon-choice_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySome = ____lualib.__TS__ArraySome
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local contains = ____core.contains
local ____weapon_2Dbuffs_2Econstants = require("addons.glowing-bars.src.reminders.weapon.weapon-buffs_constants")
local OFFHAND_PRIORITY = ____weapon_2Dbuffs_2Econstants.OFFHAND_PRIORITY
local TALENT_WEAPON_BUFFS = ____weapon_2Dbuffs_2Econstants.TALENT_WEAPON_BUFFS
local WEAPON_BUFF_BY_ENCHANT = ____weapon_2Dbuffs_2Econstants.WEAPON_BUFF_BY_ENCHANT
local WEAPON_BUFF_BY_SPELL = ____weapon_2Dbuffs_2Econstants.WEAPON_BUFF_BY_SPELL
local WEAPON_BUFFS = ____weapon_2Dbuffs_2Econstants.WEAPON_BUFFS
local WEAPON_PRIORITY = ____weapon_2Dbuffs_2Econstants.WEAPON_PRIORITY
--- The key of the weapon buff last put on a hand, in the saved settings.
local function getLastWeaponKey(isOffhand)
    return isOffhand and "weapon:off" or "weapon:main"
end
____exports.WeaponChoiceService = __TS__Class()
local WeaponChoiceService = ____exports.WeaponChoiceService
WeaponChoiceService.name = "WeaponChoiceService"
function WeaponChoiceService.prototype.____constructor(self, player, spells, settings, actionBars, bags)
    self.player = player
    self.spells = spells
    self.settings = settings
    self.actionBars = actionBars
    self.bags = bags
    self.tokenCache = {}
end
function WeaponChoiceService.prototype.forgetNames(self)
    self.weaponNames = nil
    for entry in pairs(self.tokenCache) do
        self.tokenCache[entry] = nil
    end
end
__TS__DecorateLegacy(
    {OnEvent("spells.invalidated")},
    WeaponChoiceService.prototype,
    "forgetNames",
    true
)
function WeaponChoiceService.prototype.getWeaponChoices(self)
    local token = self.player:getClassToken()
    local ____temp_0
    if token ~= nil then
        ____temp_0 = WEAPON_BUFFS[token]
    else
        ____temp_0 = nil
    end
    return ____temp_0 or ({})
end
function WeaponChoiceService.prototype.isWeaponBuffLearned(self, entry)
    return self:findUsableId(entry) ~= nil
end
function WeaponChoiceService.prototype.hasOffhandChoice(self)
    local token = self.player:getClassToken()
    return token ~= nil and OFFHAND_PRIORITY[token] ~= nil
end
function WeaponChoiceService.prototype.isCoatingBothWeapons(self)
    return self:hasOffhandChoice() and self.player:isOffhandWeaponEquipped()
end
function WeaponChoiceService.prototype.noteWeaponBuffPut(self, entry, isOffhand)
    if entry == nil or not __TS__ArrayIncludes(
        self:getWeaponChoices(),
        entry
    ) then
        return
    end
    local lastBuffs = self.settings:get("lastBuffs")
    local key = getLastWeaponKey(isOffhand)
    if lastBuffs[key] ~= entry.id then
        self.settings:change(
            "lastBuffs",
            __TS__ObjectAssign({}, lastBuffs, {[key] = entry.id})
        )
    end
end
function WeaponChoiceService.prototype.noteWeaponEnchant(self, enchantId, isOffhand)
    if enchantId ~= nil then
        self:noteWeaponBuffPut(WEAPON_BUFF_BY_ENCHANT[enchantId], isOffhand)
    end
end
function WeaponChoiceService.prototype.findAutomaticWeaponBuff(self, isOffhand)
    local choices = self:getWeaponChoices()
    local preferred = self:findPreferredWeaponBuff(choices, isOffhand)
    if preferred then
        return preferred
    end
    local token = self.player:getClassToken()
    local ____temp_1
    if token ~= nil then
        ____temp_1 = (isOffhand and OFFHAND_PRIORITY or WEAPON_PRIORITY)[token]
    else
        ____temp_1 = nil
    end
    local order = ____temp_1
    for ____, key in ipairs(order or ({})) do
        local found = self:createPickedWeaponBuff(__TS__ArrayFind(
            choices,
            function(____, choice) return choice.key == key end
        ))
        if found then
            return found
        end
    end
    for ____, entry in ipairs(choices) do
        local found = self:createPickedWeaponBuff(entry)
        if found then
            return found
        end
    end
    return nil
end
function WeaponChoiceService.prototype.findPreferredWeaponBuff(self, choices, isOffhand)
    local last = self.settings:get("lastBuffs")[getLastWeaponKey(isOffhand)]
    local lastPick = self:createPickedWeaponBuff(__TS__ArrayFind(
        choices,
        function(____, choice) return choice.id == last end
    ))
    if lastPick then
        return lastPick
    end
    local token = self.player:getClassToken()
    local tree = self.player:findMainTalentTree()
    local ____temp_4
    if token ~= nil and tree ~= nil then
        local ____opt_2 = TALENT_WEAPON_BUFFS[token]
        ____temp_4 = ____opt_2 and ____opt_2[tree]
    else
        ____temp_4 = nil
    end
    local talentKey = ____temp_4
    return self:createPickedWeaponBuff(__TS__ArrayFind(
        choices,
        function(____, choice) return choice.key == talentKey end
    ))
end
function WeaponChoiceService.prototype.findSelectedWeaponBuff(self, isOffhand)
    if isOffhand == nil then
        isOffhand = false
    end
    local ____isOffhand_5
    if isOffhand then
        ____isOffhand_5 = self.settings:get("weaponBuffOff")
    else
        ____isOffhand_5 = self.settings:get("weaponBuff")
    end
    local key = ____isOffhand_5
    local ____temp_6
    if key ~= nil and key ~= "auto" then
        ____temp_6 = self:createPickedWeaponBuff(__TS__ArrayFind(
            self:getWeaponChoices(),
            function(____, choice) return choice.key == key end
        ))
    else
        ____temp_6 = nil
    end
    local chosen = ____temp_6
    return chosen or self:findAutomaticWeaponBuff(isOffhand)
end
function WeaponChoiceService.prototype.findWeaponBuffForCast(self, spellId, castName)
    if spellId ~= nil then
        local entry = WEAPON_BUFF_BY_SPELL[spellId]
        if entry then
            return entry
        end
        local name = self.spells:getSpellName(spellId)
        local ____temp_9
        if name ~= nil and self:getWeaponNameSet()[name] ~= nil then
            local ____opt_7 = self:findSelectedWeaponBuff()
            ____temp_9 = ____opt_7 and ____opt_7.entry
        else
            ____temp_9 = nil
        end
        local selected = ____temp_9
        if selected then
            return selected
        end
    end
    if castName ~= nil then
        return __TS__ArrayFind(
            self:getWeaponChoices(),
            function(____, choice) return self:doesMatchName(choice, castName) end
        )
    end
    return nil
end
function WeaponChoiceService.prototype.getWeaponMatchTokens(self, entry)
    local cached = self.tokenCache[entry]
    if cached then
        return cached
    end
    local tokens = {}
    local function add(token)
        if token == nil or token == "" then
            return
        end
        local key = string.lower(token)
        if not __TS__ArrayIncludes(tokens, key) then
            tokens[#tokens + 1] = key
        end
    end
    for ____, token in ipairs(entry.match) do
        add(token)
    end
    for ____, id in ipairs({
        entry.id,
        unpack(entry.ranks or ({}))
    }) do
        add(self.spells:getSpellName(id))
        add(self.spells:getHintName(id))
    end
    self.tokenCache[entry] = tokens
    return tokens
end
function WeaponChoiceService.prototype.findItemRank(self, entry, items)
    local onBars = __TS__ArrayFilter(
        items,
        function(____, ____bindingPattern0)
            local spell
            spell = ____bindingPattern0.spell
            return self.actionBars:isOnBars(spell)
        end
    )
    local owned = __TS__ArrayFilter(
        onBars,
        function(____, ____bindingPattern0)
            local item
            item = ____bindingPattern0.item
            return self.bags:getItemCount(item) > 0
        end
    )
    if #owned > 0 then
        return owned[#owned].spell
    end
    local maker = self:findLearnedId(entry)
    if maker ~= nil and self.spells:isCastable(maker) == false then
        return nil
    end
    if maker ~= nil and (#onBars == 0 or self.actionBars:isOnBars(maker)) then
        return maker
    end
    local ____opt_10 = onBars[#onBars]
    return ____opt_10 and ____opt_10.spell
end
function WeaponChoiceService.prototype.findUsableId(self, entry)
    local ____temp_14
    if (entry and entry.items) ~= nil then
        ____temp_14 = self:findItemRank(entry, entry.items)
    else
        ____temp_14 = self:findLearnedId(entry)
    end
    return ____temp_14
end
function WeaponChoiceService.prototype.findLearnedId(self, entry)
    if not entry then
        return nil
    end
    local ranks = entry.ranks or ({})
    do
        local i = #ranks - 1
        while i >= 0 do
            if self.spells:isLearned(ranks[i + 1]) then
                return ranks[i + 1]
            end
            i = i - 1
        end
    end
    if self.spells:isLearned(entry.id) and (entry.name == nil or self.spells:getSpellName(self.spells:resolve(entry.id) or entry.id) == entry.name) then
        return entry.id
    end
    if entry.name ~= nil then
        local byName = self.spells:resolveFromName(entry.name)
        if byName ~= nil and self.spells:isLearned(byName) then
            return byName
        end
    end
    return nil
end
function WeaponChoiceService.prototype.createPickedWeaponBuff(self, entry)
    if entry ~= nil and self.settings:get("enabledSpells")[string.format("%d", entry.id)] == false then
        return nil
    end
    local spellId = self:findUsableId(entry)
    return entry and spellId ~= nil and ({entry = entry, spellId = spellId}) or nil
end
function WeaponChoiceService.prototype.getWeaponNameSet(self)
    if self.weaponNames and not (next(self.weaponNames) == nil) then
        return self.weaponNames
    end
    self.weaponNames = {}
    for ____, list in pairs(WEAPON_BUFFS) do
        for ____, entry in ipairs(list or ({})) do
            local name = self.spells:getSpellName(entry.id)
            if name ~= nil then
                self.weaponNames[name] = true
            end
            if entry.name ~= nil then
                self.weaponNames[entry.name] = true
            end
        end
    end
    return self.weaponNames
end
function WeaponChoiceService.prototype.doesMatchName(self, entry, name)
    local lower = string.lower(name)
    if __TS__ArraySome(
        entry.match,
        function(____, token) return token ~= "" and contains(lower, token) end
    ) then
        return true
    end
    return __TS__ArraySome(
        {
            entry.id,
            unpack(entry.ranks or ({}))
        },
        function(____, id)
            local spell = self.spells:getSpellName(id)
            return spell ~= nil and string.lower(spell) == lower
        end
    )
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.weapon.weapon-memory_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
--- After a cast, a missing reading is ignored this long (the enchant is still landing).
local CAST_GRACE = 3
--- An enchant change this soon after our own cast is that cast, not a drop.
local CAST_ENCHANT_WINDOW = 8
____exports.WeaponMemoryService = __TS__Class()
local WeaponMemoryService = ____exports.WeaponMemoryService
WeaponMemoryService.name = "WeaponMemoryService"
function WeaponMemoryService.prototype.____constructor(self)
    self.graceUntil = 0
    self.castAt = 0
    self.seenUntil = 0
    self.shouldRecheckDrop = false
    self.handMissingSince = {}
end
function WeaponMemoryService.prototype.rememberApply(self, buff, now)
    self.graceUntil = now + CAST_GRACE
    self.castAt = now
    self.seenUntil = now + buff.duration
    self.shouldRecheckDrop = false
end
function WeaponMemoryService.prototype.rememberSeen(self, now, secondsLeft)
    self.shouldRecheckDrop = false
    self.seenUntil = now + secondsLeft
    self.graceUntil = 0
end
function WeaponMemoryService.prototype.forgetSeen(self)
    self.seenUntil = 0
    self.graceUntil = 0
end
function WeaponMemoryService.prototype.forgetAll(self)
    self.graceUntil = 0
    self.seenUntil = 0
    self.castAt = 0
    self.shouldRecheckDrop = false
end
function WeaponMemoryService.prototype.isInGrace(self, now)
    return now < self.graceUntil
end
function WeaponMemoryService.prototype.isSeenYet(self, now)
    return now < self.seenUntil
end
function WeaponMemoryService.prototype.getSecondsSeenLeft(self, now)
    return math.max(self.seenUntil - now, 0)
end
function WeaponMemoryService.prototype.isChangeOurOwn(self, now)
    return self:isInGrace(now) or self.castAt > 0 and now - self.castAt < CAST_ENCHANT_WINDOW
end
function WeaponMemoryService.prototype.expectDrop(self)
    self.shouldRecheckDrop = true
end
function WeaponMemoryService.prototype.takeExpectedDrop(self)
    local wasExpected = self.shouldRecheckDrop
    self.shouldRecheckDrop = false
    return wasExpected
end
function WeaponMemoryService.prototype.noteMissing(self, now)
    if self.missingSince == nil then
        self.missingSince = now
    end
    return now - self.missingSince
end
function WeaponMemoryService.prototype.stopMissing(self)
    self.missingSince = nil
end
function WeaponMemoryService.prototype.noteHandMissing(self, hand, now)
    local since = self.handMissingSince[hand] or now
    self.handMissingSince[hand] = since
    return now - since
end
function WeaponMemoryService.prototype.stopHandMissing(self, hand)
    self.handMissingSince[hand] = nil
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.weapon.weapon-reading_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local NO_EXPIRY = ____wow.NO_EXPIRY
local ____weapon_2Dbuffs_2Econstants = require("addons.glowing-bars.src.reminders.weapon.weapon-buffs_constants")
local WEAPON_BUFF_BY_ENCHANT = ____weapon_2Dbuffs_2Econstants.WEAPON_BUFF_BY_ENCHANT
____exports.WeaponReadingService = __TS__Class()
local WeaponReadingService = ____exports.WeaponReadingService
WeaponReadingService.name = "WeaponReadingService"
function WeaponReadingService.prototype.____constructor(self, auras, enchants, choice)
    self.auras = auras
    self.enchants = enchants
    self.choice = choice
end
function WeaponReadingService.prototype.readHand(self, entry, isOffhand)
    local read = self.enchants:getWeaponEnchant(isOffhand)
    if read.has == true then
        local ____temp_0
        if read.enchantId ~= nil then
            ____temp_0 = WEAPON_BUFF_BY_ENCHANT[read.enchantId]
        else
            ____temp_0 = nil
        end
        local owner = ____temp_0
        if owner and owner ~= entry then
            return {state = "other", remain = 0}
        end
        return {state = "up", remain = read.remain}
    end
    return {state = read.has == false and "no" or "unknown", remain = 0}
end
function WeaponReadingService.prototype.readHandOrAura(self, entry, isOffhand)
    local hand = self:readHand(entry, isOffhand)
    if hand.state == "up" then
        return hand
    end
    local aura = self:findWeaponBuffAura(entry)
    return aura.isFound and ({state = "up", remain = aura.remain}) or hand
end
function WeaponReadingService.prototype.readWeaponBuff(self, entry)
    local aura = self:findWeaponBuffAura(entry)
    if aura.isFound then
        return {status = "up", remain = aura.remain}
    end
    local main = self:readHand(entry, false)
    local off = self:readHand(entry, true)
    if main.state == "up" then
        return {status = "up", remain = main.remain}
    end
    if off.state == "up" then
        return {status = "up", remain = off.remain}
    end
    if self.enchants:hasWeaponTooltipText(self.choice:getWeaponMatchTokens(entry)) then
        return {status = "up", remain = NO_EXPIRY}
    end
    return {
        status = self:isGone(main.state) and self:isGone(off.state) and "missing" or "unknown",
        remain = 0
    }
end
function WeaponReadingService.prototype.findWeaponBuffAura(self, entry)
    for ____, id in ipairs({
        entry.id,
        unpack(entry.ranks or ({}))
    }) do
        local read = self.auras:findAura(id)
        if read.isFound then
            return read
        end
    end
    return {isFound = false, remain = 0, isUnreadable = false}
end
function WeaponReadingService.prototype.isGone(self, state)
    return state == "no" or state == "other"
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.weapon.weapon-reactions"] = function(...) 
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local hasKnownExpiry = ____wow.hasKnownExpiry
--- Weapon buffs warn this many seconds before they run out.
____exports.EXPIRY_WARNING = 30
--- A "missing" reading must hold this long before it is believed.
____exports.MISSING_CONFIRM = 1.5
--- The buff has a known end and it is near.
function ____exports.isAboutToExpire(remain)
    return hasKnownExpiry(remain) and remain <= ____exports.EXPIRY_WARNING
end
local function reactToDrop(memory)
    memory:forgetSeen()
    return {remain = 0, isNeeded = true}
end
local function reactToUp(memory, buff, reading, now)
    memory:rememberSeen(
        now,
        hasKnownExpiry(reading.remain) and reading.remain or buff.duration
    )
    return {
        remain = reading.remain,
        isNeeded = ____exports.isAboutToExpire(reading.remain)
    }
end
local function reactToMissing(memory, _buff, _reading, now)
    local missingSeconds = memory:noteMissing(now)
    if not memory:isInGrace(now) and missingSeconds >= ____exports.MISSING_CONFIRM then
        return reactToDrop(memory)
    end
    if memory:isInGrace(now) or memory:isSeenYet(now) then
        local left = memory:getSecondsSeenLeft(now)
        return {remain = left, isNeeded = left > 0 and left <= ____exports.EXPIRY_WARNING}
    end
    return reactToDrop(memory)
end
--- The client did not say: trust the grace time and what we saw last.
local function reactToUnknown(memory, _buff, _reading, now)
    if memory:isInGrace(now) then
        return {remain = 0, isNeeded = false}
    end
    if memory:isSeenYet(now) then
        local left = memory:getSecondsSeenLeft(now)
        return {remain = left, isNeeded = left <= ____exports.EXPIRY_WARNING}
    end
    return {remain = 0, isNeeded = true}
end
local REACTORS = {up = reactToUp, missing = reactToMissing, unknown = reactToUnknown}
function ____exports.reactToReading(memory, buff, reading, now)
    if reading.status ~= "missing" then
        memory:stopMissing()
    end
    if reading.status ~= "up" and memory:takeExpectedDrop() then
        return reactToDrop(memory)
    end
    return REACTORS[reading.status](memory, buff, reading, now)
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.weapon.weapon-reminder_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____weapon_2Dreactions = require("addons.glowing-bars.src.reminders.weapon.weapon-reactions")
local isAboutToExpire = ____weapon_2Dreactions.isAboutToExpire
local MISSING_CONFIRM = ____weapon_2Dreactions.MISSING_CONFIRM
local reactToReading = ____weapon_2Dreactions.reactToReading
____exports.WeaponReminderService = __TS__Class()
local WeaponReminderService = ____exports.WeaponReminderService
WeaponReminderService.name = "WeaponReminderService"
function WeaponReminderService.prototype.____constructor(self, clock, enchants, choice, memory, reading)
    self.clock = clock
    self.enchants = enchants
    self.choice = choice
    self.memory = memory
    self.reading = reading
    self.wasNeededLast = false
end
function WeaponReminderService.prototype.noteCast(self, spellId, castName)
    local isIdentified = spellId ~= nil or castName ~= nil
    local ____temp_3 = self.choice:findWeaponBuffForCast(spellId, castName)
    if ____temp_3 == nil then
        local ____temp_2
        if not isIdentified and self.wasNeededLast then
            local ____opt_0 = self.choice:findSelectedWeaponBuff()
            ____temp_2 = ____opt_0 and ____opt_0.entry
        else
            ____temp_2 = nil
        end
        ____temp_3 = ____temp_2
    end
    local entry = ____temp_3
    if not entry then
        return
    end
    self.memory:rememberApply(
        entry,
        self.clock:getCurrentTime()
    )
    self.enchants:clearWeaponTooltipCache()
    if not self.choice:isCoatingBothWeapons() then
        self.choice:noteWeaponBuffPut(entry, false)
    end
end
function WeaponReminderService.prototype.noteEnchantChanged(self)
    self.choice:noteWeaponEnchant(
        self.enchants:getWeaponEnchant(false).enchantId,
        false
    )
    if self.choice:isCoatingBothWeapons() then
        self.choice:noteWeaponEnchant(
            self.enchants:getWeaponEnchant(true).enchantId,
            true
        )
    end
    local pick = self.choice:findSelectedWeaponBuff()
    if not pick then
        return
    end
    local now = self.clock:getCurrentTime()
    if self.wasNeededLast then
        return self.memory:rememberApply(pick.entry, now)
    end
    if self.memory:isChangeOurOwn(now) then
        return
    end
    self.memory:expectDrop()
end
function WeaponReminderService.prototype.clearMemory(self)
    self.memory:forgetAll()
end
function WeaponReminderService.prototype.check(self)
    if self.choice:isCoatingBothWeapons() then
        return self:checkBothHands()
    end
    local pick = self.choice:findSelectedWeaponBuff()
    if not pick then
        self.wasNeededLast = false
        return nil
    end
    local reading = self.reading:readWeaponBuff(pick.entry)
    local ____reactToReading_result_4 = reactToReading(
        self.memory,
        pick.entry,
        reading,
        self.clock:getCurrentTime()
    )
    local remain = ____reactToReading_result_4.remain
    local isNeeded = ____reactToReading_result_4.isNeeded
    self.wasNeededLast = isNeeded
    return {spellId = pick.spellId, remain = remain, isNeeded = isNeeded}
end
function WeaponReminderService.prototype.checkHand(self, isOffhand, now)
    local hand = isOffhand and "off" or "main"
    local pick = self.choice:findSelectedWeaponBuff(isOffhand)
    if not pick then
        self.memory:stopHandMissing(hand)
        return nil
    end
    local ____temp_5 = self.reading:readHandOrAura(pick.entry, isOffhand)
    local state = ____temp_5.state
    local remain = ____temp_5.remain
    if state == "up" or state == "unknown" then
        self.memory:stopHandMissing(hand)
        return state == "up" and isAboutToExpire(remain) and ({spellId = pick.spellId, remain = remain}) or nil
    end
    local missingSeconds = self.memory:noteHandMissing(hand, now)
    if self.memory:isInGrace(now) or missingSeconds < MISSING_CONFIRM then
        return nil
    end
    return {spellId = pick.spellId, remain = 0}
end
function WeaponReminderService.prototype.checkBothHands(self)
    local now = self.clock:getCurrentTime()
    local due = self:checkHand(false, now) or self:checkHand(true, now)
    self.wasNeededLast = due ~= nil
    if due then
        return {spellId = due.spellId, remain = due.remain, isNeeded = true}
    end
    local ____opt_6 = self.choice:findSelectedWeaponBuff(false)
    return {spellId = ____opt_6 and ____opt_6.spellId, remain = 0, isNeeded = false}
end
return ____exports
 end,
["addons.glowing-bars.src.settings.settings-migration"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
--- The settings that only changed their name.
local RENAMED_SETTINGS = {
    isMuted = "isDisabled",
    hideResting = "shouldStayQuietInTowns",
    showBuff = "isMissingBuffEnabled",
    showWeapon = "isWeaponBuffEnabled",
    showSeals = "isMissingSealEnabled",
    showTracking = "isMissingTrackingEnabled",
    showReagents = "isLowReagentEnabled",
    showStock = "isLowStockEnabled",
    showCooldowns = "isReadyCooldownEnabled",
    showProcs = "isProcEnabled",
    showRanks = "isOldRankEnabled",
    partyGroupMin = "partyGroupFrom",
    raidGroupMin = "raidGroupFrom",
    barFaded = "fadedBars",
    glowOn = "enabledSpells",
    buffOn = "enabledBuffs",
    reagentOn = "enabledReagents"
}
--- The old names of the types of reminder.
local RENAMED_TYPES = {
    buff = "missingBuff",
    weapon = "weaponBuff",
    seal = "missingSeal",
    tracking = "missingTracking",
    cooldown = "readyCooldown",
    rank = "oldRank",
    reagent = "lowReagent",
    stock = "lowStock"
}
--- What the old limits were by default: a saved default is no choice of the player's, so it takes the new one.
local OLD_REAGENT_LOW = 5
local OLD_STOCK_LOW = 20
local OLD_COOLDOWN_GLOW_SECONDS = 3
--- A saved value that should be a table and may not be: nothing but this addon writes them, but a file can be damaged.
local function readTable(value)
    return type(value) == "table" and value or ({})
end
--- The look of a type or a spell, with the names of today.
local function convertStyle(style)
    local converted = __TS__ObjectAssign({}, style)
    if converted.isTextOn ~= nil then
        converted.isMessageOn = converted.isTextOn
    end
    if converted.opacity ~= nil then
        converted.glowPercent = converted.opacity
    end
    converted.isTextOn = nil
    converted.opacity = nil
    return converted
end
local function convertStyles(values)
    local styles = {}
    for key, style in pairs(readTable(values.styles)) do
        if type(style) == "table" then
            styles[RENAMED_TYPES[key] or key] = convertStyle(style)
        end
    end
    values.styles = styles
    local spellStyles = {}
    for key, style in pairs(readTable(values.spellStyles)) do
        do
            local __continue9
            repeat
                if type(key) ~= "string" or type(style) ~= "table" then
                    __continue9 = true
                    break
                end
                local oldType, name = string.match(key, "^(%a+):(.*)$")
                local newType = RENAMED_TYPES[oldType]
                spellStyles[newType ~= nil and (newType .. ":") .. name or key] = convertStyle(style)
                __continue9 = true
            until true
            if not __continue9 then
                break
            end
        end
    end
    values.spellStyles = spellStyles
end
--- What was "this many or fewer" is "below this" now: one more says the same.
local function convertLimits(values)
    if type(values.reagentLow) == "number" and values.reagentLow ~= OLD_REAGENT_LOW then
        values.reagentBelow = values.reagentLow + 1
    end
    if type(values.stockLow) == "number" and values.stockLow ~= OLD_STOCK_LOW then
        values.stockBelow = values.stockLow + 1
    end
    values.reagentLow = nil
    values.stockLow = nil
    if values.lowAt == nil then
        return
    end
    local belowLimits = {}
    for key, limit in pairs(readTable(values.lowAt)) do
        do
            local __continue15
            repeat
                local oldType, entry = unpack(
                    type(key) == "string" and ({string.match(key, "^(%a+):(.*)$")}) or ({}),
                    1,
                    2
                )
                if oldType == nil or type(limit) ~= "number" then
                    __continue15 = true
                    break
                end
                belowLimits[((RENAMED_TYPES[oldType] or oldType) .. ":") .. entry] = limit + 1
                __continue15 = true
            until true
            if not __continue15 then
                break
            end
        end
    end
    values.belowLimits = belowLimits
    values.lowAt = nil
end
--- An old map of what is switched off (true) as a new map of what is on, where off is false.
local function convertSwitchedOff(values, oldName, newName)
    if values[oldName] == nil then
        return
    end
    local enabled = {}
    for key, isOff in pairs(readTable(values[oldName])) do
        if isOff == true then
            enabled[key] = false
        end
    end
    values[newName] = enabled
    values[oldName] = nil
end
local function convertAddedSpells(values)
    if values.customCues == nil then
        return
    end
    local cues = readTable(values.customCues)
    values.addedSpells = __TS__ArrayMap(
        __TS__ArrayFilter(
            cues,
            function(____, cue) return type(cue) == "table" end
        ),
        function(____, cue) return {id = cue.id, reminderType = RENAMED_TYPES[cue.kind] or cue.kind} end
    )
    values.customCues = nil
end
--- A setting for all glows or all cooldowns that is now a part of the look of a type.
local function convertToLooks(values)
    local styles = values.styles
    local function changeLook(reminderType, change)
        styles[reminderType] = __TS__ObjectAssign({}, styles[reminderType], change)
    end
    local glowStyle = values.glowStyle
    if glowStyle == "breathing" or glowStyle == "still" then
        local animation = glowStyle == "still" and "none" or glowStyle
        for ____, reminderType in pairs(RENAMED_TYPES) do
            changeLook(reminderType, {animation = animation})
        end
        changeLook("proc", {animation = animation})
    end
    if values.showCooldownsOutOfCombat == true then
        changeLook("readyCooldown", {when = "always"})
    end
    local seconds = values.cooldownGlowSeconds
    if seconds ~= nil and seconds ~= OLD_COOLDOWN_GLOW_SECONDS then
        changeLook("readyCooldown", {glowTime = seconds})
    end
    values.glowStyle = nil
    values.showCooldownsOutOfCombat = nil
    values.cooldownGlowSeconds = nil
end
--- Brings settings saved under the old names to the new ones; the saved values were already laid over the defaults.
function ____exports.convertOldSettings(settings)
    local values = settings
    for oldName, newName in pairs(RENAMED_SETTINGS) do
        do
            local __continue32
            repeat
                if values[oldName] == nil then
                    __continue32 = true
                    break
                end
                values[newName] = values[oldName]
                values[oldName] = nil
                __continue32 = true
            until true
            if not __continue32 then
                break
            end
        end
    end
    for ____, name in ipairs({"fadedBars", "enabledSpells", "enabledBuffs", "enabledReagents"}) do
        values[name] = readTable(values[name])
    end
    if values.roundGlowStyle ~= nil then
        values.roundAnimation = values.roundGlowStyle == "still" and "none" or values.roundGlowStyle
    end
    values.roundGlowStyle = nil
    convertStyles(values)
    convertLimits(values)
    convertSwitchedOff(values, "rankOff", "enabledRanks")
    convertSwitchedOff(values, "barOff", "barsThatGlow")
    convertAddedSpells(values)
    convertToLooks(values)
end
return ____exports
 end,
["addons.glowing-bars.src.settings.settings_constants"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____ui = require("packages.@wowkit.ui.src.index")
local isSoundKey = ____ui.isSoundKey
local ____wow = require("packages.@wowkit.wow.src.index")
local tryCall = ____wow.tryCall
local ____settings_2Dmigration = require("addons.glowing-bars.src.settings.settings-migration")
local convertOldSettings = ____settings_2Dmigration.convertOldSettings
--- The global the TOC saves per character (## SavedVariablesPerCharacter).
____exports.SAVED_VARIABLES_NAME = "GlowingBarsCharDB"
function ____exports.createDefaultSettings()
    return {
        isDisabled = false,
        shouldStayQuietInTowns = true,
        roundAnimation = "breathing",
        isMissingBuffEnabled = true,
        isWeaponBuffEnabled = true,
        showPartyBuffs = true,
        showRaidBuffs = true,
        partyGroupFrom = 2,
        raidGroupFrom = 1,
        isOldRankEnabled = true,
        isLowReagentEnabled = true,
        isReadyCooldownEnabled = true,
        showCooldownsAtFightStart = false,
        reagentBelow = 10,
        stockBelow = 20,
        isLowStockEnabled = true,
        belowLimits = {},
        isProcEnabled = true,
        isMissingSealEnabled = true,
        isMissingTrackingEnabled = true,
        styles = {},
        spellStyles = {},
        enabledBuffs = {},
        barsThatGlow = {},
        fadedBars = {},
        fadedOpacity = 50,
        showTooltipIds = false,
        isTableAdvanced = false,
        idOverrides = {},
        addedSpells = {},
        enabledReagents = {},
        enabledRanks = {},
        enabledSpells = {},
        lastBuffs = {},
        fedBuffs = {},
        fedItems = {}
    }
end
--- The look of each type of reminder until the player changes it. The old ranks and the low reagents are a quiet hint.
____exports.STYLE_DEFAULTS = {
    missingBuff = {
        color = {0.2, 0.55, 1},
        glowPercent = 100,
        isMessageOn = false,
        sound = "none",
        ["repeat"] = 0,
        when = "always",
        glowTime = 0,
        animation = "circling"
    },
    weaponBuff = {
        color = {1, 0.55, 0.1},
        glowPercent = 100,
        isMessageOn = false,
        sound = "alarm2",
        ["repeat"] = 0,
        when = "always",
        glowTime = 0,
        animation = "circling"
    },
    missingSeal = {
        color = {1, 0.85, 0.2},
        glowPercent = 100,
        isMessageOn = false,
        sound = "none",
        ["repeat"] = 0,
        when = "inCombat",
        glowTime = 0,
        animation = "circling"
    },
    missingTracking = {
        color = {0.1, 0.65, 0.75},
        glowPercent = 100,
        isMessageOn = false,
        sound = "none",
        ["repeat"] = 0,
        when = "always",
        glowTime = 0,
        animation = "circling"
    },
    readyCooldown = {
        color = {1, 1, 1},
        glowPercent = 100,
        isMessageOn = false,
        sound = "none",
        ["repeat"] = 0,
        when = "inCombat",
        glowTime = 3,
        animation = "circling"
    },
    proc = {
        color = {1, 0.12, 0.08},
        glowPercent = 100,
        isMessageOn = false,
        sound = "none",
        ["repeat"] = 0,
        when = "always",
        glowTime = 0,
        animation = "circling"
    },
    oldRank = {
        color = {1, 0.85, 0.2},
        glowPercent = 50,
        isMessageOn = true,
        sound = "alarm1",
        ["repeat"] = 0,
        when = "always",
        glowTime = 0,
        animation = "circling"
    },
    lowReagent = {
        color = {1, 0.85, 0.2},
        glowPercent = 50,
        isMessageOn = true,
        sound = "none",
        ["repeat"] = 0,
        when = "townAlert",
        glowTime = 0,
        animation = "circling"
    },
    lowStock = {
        color = {1, 0.12, 0.08},
        glowPercent = 50,
        isMessageOn = true,
        sound = "none",
        ["repeat"] = 0,
        when = "always",
        glowTime = 0,
        animation = "circling"
    }
}
--- When a reminder of the reminderType may show: by combat or a target; the low reagents and the low stock also with their alert in a town.
function ____exports.listWhenChoices(reminderType)
    local choices = {"always", "inCombat", "outOfCombat", "enemyTargeted"}
    local ____temp_1
    if reminderType == "lowReagent" or reminderType == "lowStock" then
        local ____array_0 = __TS__SparseArrayNew(unpack(choices))
        __TS__SparseArrayPush(____array_0, "townAlert")
        ____temp_1 = {__TS__SparseArraySpread(____array_0)}
    else
        ____temp_1 = choices
    end
    return ____temp_1
end
--- The choices of how often a sound repeats while its glow is on (seconds; 0 = once).
____exports.REPEAT_CHOICES = {
    0,
    5,
    10,
    30,
    60
}
--- The choices of how visible a faded bar's buttons are, in percent.
____exports.FADED_OPACITY_CHOICES = {
    0,
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90
}
--- The choices of how a glow moves.
____exports.ANIMATION_CHOICES = {"circling", "breathing", "none"}
--- The choices of how long a reminder shows once it is due (seconds; 0 = until it is done).
____exports.GLOW_TIME_CHOICES = {
    0,
    1,
    2,
    3,
    5,
    10
}
--- The choices of from how many missing a buff its group version is asked for.
____exports.GROUP_FROM_CHOICES = {
    1,
    2,
    3,
    4,
    5
}
--- The types a spell can be added as, in the order the add button goes through them.
____exports.ADDABLE_TYPES = {
    "readyCooldown",
    "proc",
    "missingBuff",
    "weaponBuff",
    "lowReagent",
    "lowStock",
    "missingSeal",
    "missingTracking"
}
--- The types in the order the tables list them.
____exports.TYPE_ORDER = {
    "missingBuff",
    "weaponBuff",
    "missingSeal",
    "missingTracking",
    "lowReagent",
    "lowStock",
    "readyCooldown",
    "proc",
    "oldRank"
}
--- A saved value that is one of the choices; undefined for any other.
local function pickChoice(value, choices)
    local ____temp_2
    if value ~= nil and __TS__ArrayIncludes(choices, value) then
        ____temp_2 = value
    else
        ____temp_2 = nil
    end
    return ____temp_2
end
--- A saved When that the type has; undefined for any other (the type of a spell look not known: none).
local function repairWhen(when, reminderType)
    return reminderType ~= nil and __TS__ArrayIncludes(
        ____exports.listWhenChoices(reminderType),
        when
    ) and when or nil
end
--- The part of a saved look that can be used: a sound that is no longer in the list, or a color that is no color, is dropped.
local function repairStyle(style, reminderType)
    if style == nil or type(style) ~= "table" then
        return nil
    end
    local repaired = {}
    repaired.when = repairWhen(style.when, reminderType)
    if isSoundKey(style.sound) then
        repaired.sound = style.sound
    end
    if type(style.isMessageOn) == "boolean" then
        repaired.isMessageOn = style.isMessageOn
    end
    repaired["repeat"] = pickChoice(style["repeat"], ____exports.REPEAT_CHOICES)
    repaired.glowTime = pickChoice(style.glowTime, ____exports.GLOW_TIME_CHOICES)
    repaired.animation = pickChoice(style.animation, ____exports.ANIMATION_CHOICES)
    local glowPercent = tonumber(style.glowPercent)
    if glowPercent ~= nil then
        repaired.glowPercent = math.max(
            1,
            math.min(
                100,
                math.floor(glowPercent + 0.5)
            )
        )
    end
    local color = style.color
    if color ~= nil and type(color) == "table" and tonumber(color[1]) ~= nil then
        repaired.color = {color[1], color[2] or 0, color[3] or 0}
    end
    return repaired
end
--- A limit of how few is running low: any number from 0.
local function repairLimit(limit, byDefault)
    return type(limit) == "number" and limit >= 0 and limit or byDefault
end
--- Puts right what a saved look got wrong.
function ____exports.repairSettings(values)
    tryCall(function() return convertOldSettings(values) end)
    local defaults = ____exports.createDefaultSettings()
    if not __TS__ArrayIncludes({"breathing", "none"}, values.roundAnimation) then
        values.roundAnimation = defaults.roundAnimation
    end
    if not __TS__ArrayIncludes(____exports.FADED_OPACITY_CHOICES, values.fadedOpacity) then
        values.fadedOpacity = defaults.fadedOpacity
    end
    values.addedSpells = __TS__ArrayFilter(
        values.addedSpells or ({}),
        function(____, cue) return type(cue) == "table" and tonumber(cue.id) ~= nil and __TS__ArrayIncludes(____exports.ADDABLE_TYPES, cue.reminderType) end
    )
    values.reagentBelow = repairLimit(values.reagentBelow, defaults.reagentBelow)
    values.stockBelow = repairLimit(values.stockBelow, defaults.stockBelow)
    local old = values
    if old.showGreaterForOne == true then
        values.partyGroupFrom = 1
    end
    old.showGreaterForOne = nil
    if not __TS__ArrayIncludes(____exports.GROUP_FROM_CHOICES, values.partyGroupFrom) then
        values.partyGroupFrom = defaults.partyGroupFrom
    end
    if not __TS__ArrayIncludes(____exports.GROUP_FROM_CHOICES, values.raidGroupFrom) then
        values.raidGroupFrom = defaults.raidGroupFrom
    end
    for ____, reminderType in ipairs(____exports.TYPE_ORDER) do
        values.styles[reminderType] = repairStyle(values.styles[reminderType], reminderType)
    end
    for key, style in pairs(values.spellStyles) do
        local reminderType = string.match(key, "^(%a+):")
        values.spellStyles[key] = repairStyle(
            style,
            __TS__ArrayFind(
                ____exports.TYPE_ORDER,
                function(____, known) return known == reminderType end
            )
        )
    end
end
return ____exports
 end,
["addons.glowing-bars.src.settings.style_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____settings_2Econstants = require("addons.glowing-bars.src.settings.settings_constants")
local STYLE_DEFAULTS = ____settings_2Econstants.STYLE_DEFAULTS
--- The parts of a look.
local PARTS = {
    "color",
    "glowPercent",
    "isMessageOn",
    "sound",
    "repeat",
    "when",
    "glowTime",
    "animation"
}
____exports.StyleService = __TS__Class()
local StyleService = ____exports.StyleService
StyleService.name = "StyleService"
function StyleService.prototype.____constructor(self, spells, settings)
    self.spells = spells
    self.settings = settings
    self.hasOwnLook = function() return false end
end
function StyleService.prototype.useOwnLooks(self, hasOwnLook)
    self.hasOwnLook = hasOwnLook
end
function StyleService.prototype.getStyle(self, reminderType, spellId)
    local layers = {
        spellId ~= nil and self:getOverride(reminderType, spellId) or ({}),
        self:getOverride(reminderType),
        STYLE_DEFAULTS[reminderType]
    }
    return {
        color = self:pickPart(layers, "color"),
        glowPercent = self:pickPart(layers, "glowPercent"),
        isMessageOn = self:pickPart(layers, "isMessageOn"),
        sound = self:pickPart(layers, "sound"),
        ["repeat"] = self:pickPart(layers, "repeat"),
        when = self:pickPart(layers, "when"),
        glowTime = self:pickPart(layers, "glowTime"),
        animation = self:pickPart(layers, "animation")
    }
end
function StyleService.prototype.getOverride(self, reminderType, spellId)
    if spellId == nil then
        return self.settings:get("styles")[reminderType] or ({})
    end
    return self.settings:get("spellStyles")[self:getStyleKey(reminderType, spellId)] or ({})
end
function StyleService.prototype.isOverridden(self, reminderType, spellId)
    local override = self:getOverride(reminderType, spellId)
    return __TS__ArraySome(
        PARTS,
        function(____, part) return override[part] ~= nil end
    )
end
function StyleService.prototype.changeStyle(self, reminderType, spellId, change)
    local inherited = spellId == nil and STYLE_DEFAULTS[reminderType] or self:getStyle(reminderType)
    local merged = __TS__ObjectAssign(
        {},
        self:getOverride(reminderType, spellId)
    )
    for ____, part in ipairs(PARTS) do
        do
            local __continue11
            repeat
                local value = change[part]
                if value == nil then
                    __continue11 = true
                    break
                end
                if self:isSameValue(value, inherited[part]) then
                    __TS__Delete(merged, part)
                else
                    merged[part] = value
                end
                __continue11 = true
            until true
            if not __continue11 then
                break
            end
        end
    end
    local isEmpty = not __TS__ArraySome(
        PARTS,
        function(____, part) return merged[part] ~= nil end
    )
    if spellId == nil then
        local styles = self:copyWithout(
            self.settings:get("styles"),
            reminderType
        )
        if not isEmpty then
            styles[reminderType] = merged
        end
        self.settings:change("styles", styles)
    else
        local key = self:getStyleKey(reminderType, spellId)
        local spellStyles = self:copyWithout(
            self.settings:get("spellStyles"),
            key
        )
        if not isEmpty then
            spellStyles[key] = merged
        end
        self.settings:change("spellStyles", spellStyles)
    end
end
function StyleService.prototype.resetType(self, reminderType)
    self.settings:change(
        "styles",
        self:copyWithout(
            self.settings:get("styles"),
            reminderType
        )
    )
end
function StyleService.prototype.resetSpell(self, reminderType, spellId)
    self.settings:change(
        "spellStyles",
        self:copyWithout(
            self.settings:get("spellStyles"),
            self:getStyleKey(reminderType, spellId)
        )
    )
end
function StyleService.prototype.getSpellKey(self, spellId)
    return self.spells:getSpellName(spellId) or string.format("%d", spellId)
end
function StyleService.prototype.applyTextColor(self, color, text)
    local r, g, b = unpack(color, 1, 3)
    return string.format(
        "|cff%02x%02x%02x%s|r",
        math.floor(r * 255 + 0.5),
        math.floor(g * 255 + 0.5),
        math.floor(b * 255 + 0.5),
        text
    )
end
function StyleService.prototype.getStyleKey(self, reminderType, spellId)
    return (reminderType .. ":") .. (self.hasOwnLook(spellId) and string.format("%d", spellId) or self:getSpellKey(spellId))
end
function StyleService.prototype.isSameValue(self, a, b)
    if type(a) == "table" and type(b) == "table" then
        return table.concat(a, ",") == table.concat(b, ",")
    end
    return a == b
end
function StyleService.prototype.copyWithout(self, entries, key)
    local copy = {}
    for name, value in pairs(entries) do
        if name ~= key then
            copy[name] = value
        end
    end
    return copy
end
function StyleService.prototype.pickPart(self, layers, part)
    for ____, layer in ipairs(layers) do
        local value = layer[part]
        if value ~= nil then
            return value
        end
    end
    return STYLE_DEFAULTS.missingBuff[part]
end
return ____exports
 end,
["addons.glowing-bars.src.locale.texts_constants"] = function(...) 
local ____exports = {}
____exports.TEXTS = {
    TITLE = "Glowing Bars",
    INIT = "Loaded. Type /gb to customize your reminders.",
    HDR_ABOUT = "Help",
    INFO_GITHUB = "GitHub",
    INFO_ISSUES = "Report an issue",
    INFO_COPY = "Copy",
    INFO_COPIED = "The link is in your chat box. Press Ctrl+C to copy it.",
    HDR_CHARACTER = "This character",
    OPT_DISABLE = "Disable on this character",
    TIP_DISABLE = "Turns off all glows, sounds and messages on this character. Your other characters aren't affected.",
    OPT_STAY_QUIET_IN_TOWNS = "Stay quiet in towns and inns",
    TIP_STAY_QUIET_IN_TOWNS = "No glows or messages while resting in a town or inn (out of combat). Turn this off to get reminders there too.",
    HDR_BARS = "Action bars that glow",
    OPT_BAR = "Action Bar %d",
    TIP_BAR = "Buttons on this bar can glow. Turn a bar off to keep it quiet, e.g. if you have the same spells on a cooldown bar next to your character.",
    HDR_FADED = "Faded until they glow",
    TIP_FADE = "The buttons of this bar are faded while they don't glow; a glowing one shows in full.",
    OPT_FADED_OPACITY = "Faded opacity",
    TIP_FADED_OPACITY = "How visible the buttons of a faded bar are while they don't glow.",
    OPT_PERCENT = "%d%%",
    HDR_BUFFS = "Buffs",
    OPT_PARTY_BUFFS = "Party members missing your buffs",
    TIP_PARTY_BUFFS = "Out of combat, in a party, lists members in range who are missing one of your buffs, and the buff's button glows. Off: only your own buffs are watched.",
    OPT_RAID_BUFFS = "Raid members missing your buffs",
    TIP_RAID_BUFFS = "Out of combat, in a raid, lists members in range who are missing one of your buffs, and the buff's button glows. Your blessings only on the classes you gave one there. Off: only your own buffs are watched.",
    OPT_GROUP_FROM = "Group version from",
    TIP_PARTY_GROUP_MIN = "In a party, how many missing a buff (you counted, but never you alone) make the group version glow instead: Prayer of Fortitude, Gift of the Wild, Arcane Brilliance, or a Greater Blessing (counting one class). It needs its reagent in your bags.",
    TIP_RAID_GROUP_MIN = "In a raid, how many missing a buff (you counted, but never you alone) make the group version glow instead: Prayer of Fortitude, Gift of the Wild, Arcane Brilliance, or a Greater Blessing (counting one class). It needs its reagent in your bags.",
    OPT_MEMBER_MISSING = "%d member missing",
    OPT_MEMBERS_MISSING = "%d members missing",
    HDR_WEAPON = "Weapon buff",
    OPT_WEAPON_PICK = "Weapon buff to keep up",
    OPT_WEAPON_PICK_MAIN = "Main-hand poison",
    OPT_WEAPON_PICK_OFF = "Off-hand poison",
    TIP_WEAPON_PICK = "Automatic picks the best weapon buff you've learned (it changes as you level). Only learned buffs are listed.",
    OPT_AUTOMATIC = "Automatic",
    HDR_COOLDOWNS = "Ready cooldowns",
    OPT_COOLDOWNS_FIGHT_START = "Also at the start of a fight",
    TIP_COOLDOWNS_FIGHT_START = "When a fight starts, every ready cooldown glows too, as a reminder to use it (Berserking, Recklessness...).",
    HDR_REMINDERS = "Reminders",
    OPT_TABLE = "Colors, sounds and on/off per spell",
    TIP_TABLE = "Set the color, glow, message and sound of each reminder type and each spell, and turn them on or off. Also /gb.",
    BTN_OPEN = "Open",
    OPT_ROUND_ANIMATION = "Circling on round buttons (alpha)",
    TIP_ROUND_ANIMATION = "A round button (the gamepad bars, or another addon's round buttons) cannot have a glow running around it. Where the table's Animation column says Circling, a round button breathes instead, or stands still.",
    ANIMATION_CIRCLING = "Circling",
    ANIMATION_BREATHING = "Breathing",
    ANIMATION_NONE = "None",
    BTN_RESET = "Reset",
    TABLE_TITLE = "Glowing Bars",
    HDR_TABLE_DEFAULTS = "Defaults",
    HDR_TABLE_SPELLS = "Spells (override the defaults)",
    COL_SPELL_ITEM = "Spell / Item",
    COL_TYPE = "Type",
    COL_SPELL_ITEM_ID = "Spell / Item ID",
    COL_ENABLED = "Enabled",
    TIP_TYPE = "The type of the reminder. Its row under Defaults sets the look of all its rows, unless you change a row.",
    TIP_ID = "The ID the addon looks for. Change it if the game uses a different ID, e.g. after a patch the addon hasn't caught up with yet. The ID of an item or an old rank can't be changed.",
    TIP_COLOR = "The color of the glow and the message. Click to choose another.",
    TIP_GLOW_PERCENT = "How strong the glow is, 1 to 100. Type a number.",
    TIP_MESSAGE = "Shows a short message at the top of the screen.",
    TIP_WHEN = "When the reminder may show: always, only in combat, only out of combat, or only while a living enemy is targeted. Low reagent and Low stock also have Alert in town: the button glows anywhere, and the message and the sound come only in a town or an inn. Click for the next choice, right-click for the one before.",
    TIP_BELOW = "Reminds you when you have fewer than this. The number on a row under Defaults is used for every row of that type, unless you set a different number on the row.",
    TIP_ENABLED = "Turns the reminder on or off. On a row under Defaults, it turns the whole type on or off: while it's off, none of its rows work and they are grayed out.",
    TIP_ADD = "Low stock needs an Item ID, every other type a Spell ID. To see them, turn on \"Show spell and item IDs in tooltips\" in the Settings.",
    HDR_TABLE_ADD = "Add spell/item by ID",
    OPT_TOOLTIP_IDS = "Show spell and item IDs in tooltips",
    TIP_TOOLTIP_IDS = "Shows the Spell ID on spell tooltips and the Item ID on item tooltips. If an item has a use (an elixir, a potion, food, a drink), it also shows the ID of the spell it casts. Handy for adding a spell or item in the table.",
    TOOLTIP_SPELL_ID = "Spell ID: %d",
    TOOLTIP_USE_SPELL_ID = "Use spell ID: %d",
    TOOLTIP_ITEM_ID = "Item ID: %d",
    BTN_ADD = "Add",
    MSG_UNKNOWN_SPELL = "No spell found with ID %d.",
    MSG_ALREADY_LISTED = "%s is already in the list.",
    MSG_FOOD_IS_BUFF = "%s is a food or drink, add it as Missing buff.",
    MSG_NO_COOLDOWN = "%s has no cooldown, pick another type.",
    MSG_NO_REAGENT = "%s uses no reagent, pick another type.",
    COL_COLOR = "Color",
    COL_GLOW_PERCENT = "Glow %",
    COL_MESSAGE = "Message",
    COL_BELOW = "Below",
    MSG_UNKNOWN_ITEM = "No item found with ID %d.",
    COL_SOUND = "Sound",
    TIP_SOUND = "The sound that plays when the reminder starts. Click for the next choice, right-click for the one before.",
    COL_REPEAT = "Repeat",
    REPEAT_OFF = "Off",
    REPEAT_SECONDS = "%d s",
    TIP_REPEAT = "Every so many seconds, the glow, the message and the sound come again, for the glow time (with Until done the glow stays, and the sound and the message come again). Off shows them once, as the reminder starts. Click for the next choice, right-click for the one before.",
    COL_ANIMATION = "Animation",
    TIP_ANIMATION = "How the glow moves. Circling: it runs around the button. Breathing: it stands still and slowly fades out and in. None: it stands still, fading in and out only as it comes and goes. Round buttons cannot circle: there Circling does what the Settings page says (Breathing by default). Click for the next choice, right-click for the one before.",
    COL_GLOW_TIME = "Glow time",
    GLOW_UNTIL_DONE = "Until done",
    TIP_GLOW_TIME = "How long the glow and the message show once the reminder is due, and again with each repeat. Until done: the whole time, until you cast the buff, press the cooldown... Click for the next choice, right-click for the one before.",
    COL_WHEN = "When",
    COL_ACTIONS = "Actions",
    TIP_ACTIONS = "Reset: undoes your changes on this row. X: removes a spell or item you added. Each one only shows on the rows where it can be used.",
    BTN_ADVANCED = "Advanced",
    BTN_BASIC = "Basic",
    WHEN_ALWAYS = "Always",
    WHEN_IN_COMBAT = "In combat",
    WHEN_OUT_OF_COMBAT = "Out of combat",
    WHEN_ENEMY_TARGETED = "Enemy targeted",
    WHEN_TOWN_ALERT = "Alert in town",
    NO_COLOR_PICKER = "No color picker available on this client.",
    TYPE_MISSING_BUFF = "Missing buff",
    TYPE_WEAPON_BUFF = "Weapon buff",
    TYPE_MISSING_SEAL = "Missing seal",
    TYPE_MISSING_TRACKING = "Missing tracking",
    TYPE_READY_COOLDOWN = "Ready cooldown",
    TYPE_PROC = "Proc",
    TYPE_OLD_RANK = "Old rank",
    TYPE_LOW_REAGENT = "Low reagent",
    TYPE_LOW_STOCK = "Low stock",
    TEXT_BUFF = "Missing buff",
    TEXT_WEAPON = "Weapon buff",
    TEXT_SEAL = "Missing seal",
    TEXT_TRACKING = "Missing tracking",
    TEXT_COOLDOWN = "Cooldown ready",
    TEXT_PROC = "Proc",
    TEXT_RANK = "Old spell rank",
    NOTICE_NOT_ON_BAR = "Missing buff (not on your action bars): %s",
    NOTICE_PARTY = "%s missing on: %s",
    NOTICE_PARTY_COUNT = "%s missing on %d members",
    NOTICE_REAGENTS_LOW = "Running low: %s",
    NOTICE_STOCK_LOW = "Running low: %s (%d)",
    BLOCKED_ACTION = "The game blocked an action from this addon (%s). Please report it."
}
return ____exports
 end,
["addons.glowing-bars.src.locale.locale_interface"] = function(...) 
local ____exports = {}
return ____exports
 end,
["addons.glowing-bars.src.reagents.reagent_interface"] = function(...) 
local ____exports = {}
return ____exports
 end,
["addons.glowing-bars.src.reminders.outdated-ranks_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
____exports.OutdatedRanksService = __TS__Class()
local OutdatedRanksService = ____exports.OutdatedRanksService
OutdatedRanksService.name = "OutdatedRanksService"
function OutdatedRanksService.prototype.____constructor(self, actionBars, spells, settings)
    self.actionBars = actionBars
    self.spells = spells
    self.settings = settings
end
function OutdatedRanksService.prototype.findOutdatedRanks(self)
    local byName = {}
    for ____, id in ipairs(self.actionBars:listSpellIdsOnBars()) do
        local name = self.spells:getSpellName(id)
        local ____temp_0
        if name ~= nil and name ~= "" then
            ____temp_0 = self.spells:getSpellRank(id)
        else
            ____temp_0 = nil
        end
        local rank = ____temp_0
        local ____temp_3 = name ~= nil and rank ~= nil
        if ____temp_3 then
            local ____opt_1 = byName[name]
            ____temp_3 = rank > (____opt_1 and ____opt_1.rank or -1)
        end
        if ____temp_3 then
            byName[name] = {id = id, rank = rank}
        end
    end
    local outdated = {}
    for name, entry in pairs(byName) do
        local best = self.spells:getHighestRank(entry.id)
        if best ~= nil and best > entry.rank then
            outdated[#outdated + 1] = {id = entry.id, name = name, onBar = entry.rank, best = best}
        end
    end
    __TS__ArraySort(
        outdated,
        function(____, a, b) return a.name < b.name and -1 or (a.name > b.name and 1 or 0) end
    )
    local enabledRanks = self.settings:get("enabledRanks")
    return __TS__ArrayFilter(
        outdated,
        function(____, rank) return enabledRanks[rank.name] ~= false end
    )
end
return ____exports
 end,
["addons.glowing-bars.src.tick.tick_interface"] = function(...) 
local ____exports = {}
return ____exports
 end,
["addons.glowing-bars.src.tick.notices_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayJoin = ____lualib.__TS__ArrayJoin
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local NOTICE_SECONDS = ____wow.NOTICE_SECONDS
--- A party message names this many members at most; past them, it counts them (a raid).
local NAMES_MAX = 5
--- After the bars changed they are mapped again; until then the old map would call every spell missing.
local NOTICE_AFTER_BAR_CHANGE = 1.5
____exports.NoticesService = __TS__Class()
local NoticesService = ____exports.NoticesService
NoticesService.name = "NoticesService"
function NoticesService.prototype.____constructor(self, actionBars, clock, notice, spells, locale, styles)
    self.actionBars = actionBars
    self.clock = clock
    self.notice = notice
    self.spells = spells
    self.locale = locale
    self.styles = styles
    self.lastText = ""
    self.shownAt = {}
end
function NoticesService.prototype.showNoticeIfNew(self, reminders)
    if self.actionBars:getSecondsSinceBarsChanged() <= NOTICE_AFTER_BAR_CHANGE then
        return
    end
    local now = self.clock:getCurrentTime()
    local lines = self:listLines(reminders)
    self:forgetOver(lines)
    local due = __TS__ArrayFilter(
        lines,
        function(____, line) return self:isDue(line, now) end
    )
    local text = table.concat(
        __TS__ArrayMap(
            __TS__ArrayFilter(
                lines,
                function(____, line) return __TS__ArrayIncludes(due, line) or self:isStillUp(line, now) end
            ),
            function(____, line) return line.text end
        ),
        "\n"
    )
    for ____, line in ipairs(due) do
        for ____, part in ipairs(line.parts) do
            self.shownAt[part] = now
        end
    end
    if #due == 0 and text == self.lastText then
        return
    end
    self.lastText = text
    if text == "" then
        self.notice:clearNotice()
    else
        self.notice:showNotice(text)
    end
end
function NoticesService.prototype.isDue(self, line, now)
    return __TS__ArraySome(
        line.parts,
        function(____, part)
            local at = self.shownAt[part]
            return at == nil or line["repeat"] > 0 and now - at >= line["repeat"]
        end
    )
end
function NoticesService.prototype.isStillUp(self, line, now)
    return __TS__ArraySome(
        line.parts,
        function(____, part) return now - (self.shownAt[part] or 0) < NOTICE_SECONDS end
    )
end
function NoticesService.prototype.forgetOver(self, lines)
    local shownAt = {}
    for ____, line in ipairs(lines) do
        for ____, part in ipairs(line.parts) do
            local at = self.shownAt[part]
            if at ~= nil then
                shownAt[part] = at
            end
        end
    end
    self.shownAt = shownAt
end
function NoticesService.prototype.listLines(self, reminders)
    local lines = {}
    self:addTypeLines(lines, "missingBuff", reminders.buffsToCast, "TEXT_BUFF")
    local ____self_addTypeLines_1 = self.addTypeLines
    local ____array_0 = __TS__SparseArrayNew(unpack(reminders.weaponSpell ~= nil and ({reminders.weaponSpell}) or ({})))
    __TS__SparseArrayPush(
        ____array_0,
        unpack(reminders.addedWeaponSpells)
    )
    ____self_addTypeLines_1(
        self,
        lines,
        "weaponBuff",
        {__TS__SparseArraySpread(____array_0)},
        "TEXT_WEAPON"
    )
    self:addTypeLines(lines, "missingSeal", reminders.seals, "TEXT_SEAL")
    self:addTypeLines(lines, "missingTracking", reminders.trackings, "TEXT_TRACKING")
    self:addTypeLines(lines, "readyCooldown", reminders.readyCooldowns, "TEXT_COOLDOWN")
    self:addTypeLines(lines, "proc", reminders.procs, "TEXT_PROC")
    self:addTypeLines(
        lines,
        "oldRank",
        __TS__ArrayMap(
            reminders.outdatedRanks,
            function(____, rank) return rank.id end
        ),
        "TEXT_RANK"
    )
    for ____, stock in ipairs(reminders.lowStock) do
        local style = self.styles:getStyle("lowStock", stock.key)
        local text = self.styles:applyTextColor(
            style.color,
            string.format(
                self.locale:getText("NOTICE_STOCK_LOW"),
                stock.name,
                stock.count
            )
        )
        if self:isTold(style, reminders) then
            lines[#lines + 1] = {
                parts = {"lowStock:" .. tostring(stock.itemId)},
                text = text,
                ["repeat"] = style["repeat"]
            }
        end
    end
    self:addReagentLine(lines, reminders)
    for ____, spellId in ipairs(reminders.buffsNotOnBars) do
        local name = self.spells:getSpellName(spellId) or "?"
        self:addNamedLine(
            lines,
            spellId,
            {"bar:" .. tostring(spellId)},
            string.format(
                self.locale:getText("NOTICE_NOT_ON_BAR"),
                name
            )
        )
    end
    for ____, suggestion in ipairs(reminders.partySuggestions) do
        local names = table.concat(suggestion.names, ", ")
        local spellName = self.spells:getSpellName(suggestion.spellId) or "?"
        local count = #suggestion.names
        local text = count > NAMES_MAX and string.format(
            self.locale:getText("NOTICE_PARTY_COUNT"),
            spellName,
            count
        ) or string.format(
            self.locale:getText("NOTICE_PARTY"),
            spellName,
            names
        )
        local parts = __TS__ArrayMap(
            suggestion.names,
            function(____, name) return (("party:" .. tostring(suggestion.spellId)) .. ":") .. name end
        )
        self:addNamedLine(lines, suggestion.spellId, parts, text)
    end
    return lines
end
function NoticesService.prototype.isTold(self, style, reminders)
    return style.isMessageOn and (style.when ~= "townAlert" or reminders.isInTown == true)
end
function NoticesService.prototype.addReagentLine(self, lines, reminders)
    local told = __TS__ArrayFilter(
        __TS__ArrayMap(
            reminders.lowReagents,
            function(____, stock) return {
                stock = stock,
                style = self.styles:getStyle("lowReagent", stock.spellId)
            } end
        ),
        function(____, ____bindingPattern0)
            local style
            style = ____bindingPattern0.style
            return self:isTold(style, reminders)
        end
    )
    local first = told[1]
    if first == nil then
        return
    end
    local ____repeat = 0
    for ____, ____value in ipairs(told) do
        local style = ____value.style
        if style["repeat"] > 0 and (____repeat == 0 or style["repeat"] < ____repeat) then
            ____repeat = style["repeat"]
        end
    end
    local names = table.concat(
        __TS__ArrayMap(
            told,
            function(____, ____bindingPattern0)
                local stock
                stock = ____bindingPattern0.stock
                return ((stock.name .. " (") .. tostring(stock.count)) .. ")"
            end
        ),
        ", "
    )
    lines[#lines + 1] = {
        parts = __TS__ArrayMap(
            told,
            function(____, ____bindingPattern0)
                local stock
                stock = ____bindingPattern0.stock
                return "lowReagent:" .. stock.name
            end
        ),
        text = self.styles:applyTextColor(
            first.style.color,
            string.format(
                self.locale:getText("NOTICE_REAGENTS_LOW"),
                names
            )
        ),
        ["repeat"] = ____repeat
    }
end
function NoticesService.prototype.addTypeLines(self, lines, reminderType, spellIds, text)
    local groups = {}
    for ____, id in ipairs(spellIds) do
        do
            local __continue46
            repeat
                local style = self.styles:getStyle(reminderType, id)
                if not style.isMessageOn then
                    __continue46 = true
                    break
                end
                local group = __TS__ArrayFind(
                    groups,
                    function(____, candidate) return __TS__ArrayJoin(candidate.color, ",") == __TS__ArrayJoin(style.color, ",") end
                )
                if group == nil then
                    groups[#groups + 1] = {color = style.color, ids = {id}, ["repeat"] = style["repeat"]}
                else
                    local ____group_ids_2 = group.ids
                    ____group_ids_2[#____group_ids_2 + 1] = id
                    if style["repeat"] > 0 and (group["repeat"] == 0 or style["repeat"] < group["repeat"]) then
                        group["repeat"] = style["repeat"]
                    end
                end
                __continue46 = true
            until true
            if not __continue46 then
                break
            end
        end
    end
    for ____, group in ipairs(groups) do
        local lineText = self.styles:applyTextColor(
            group.color,
            self.locale:getText(text)
        )
        lines[#lines + 1] = {
            parts = __TS__ArrayMap(
                group.ids,
                function(____, id) return (reminderType .. ":") .. tostring(id) end
            ),
            text = lineText,
            ["repeat"] = group["repeat"]
        }
    end
end
function NoticesService.prototype.addNamedLine(self, lines, spellId, parts, text)
    local style = self.styles:getStyle("missingBuff", spellId)
    if style.isMessageOn then
        lines[#lines + 1] = {
            parts = parts,
            text = self.styles:applyTextColor(style.color, text),
            ["repeat"] = style["repeat"]
        }
    end
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.below-limits_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- The types with a limit, and the setting that holds the limit of the type.
local TYPE_LIMITS = {lowReagent = "reagentBelow", lowStock = "stockBelow"}
____exports.BelowLimitsService = __TS__Class()
local BelowLimitsService = ____exports.BelowLimitsService
BelowLimitsService.name = "BelowLimitsService"
function BelowLimitsService.prototype.____constructor(self, settings)
    self.settings = settings
end
function BelowLimitsService.prototype.hasLimit(self, reminderType)
    return reminderType == "lowReagent" or reminderType == "lowStock"
end
function BelowLimitsService.prototype.getLimit(self, reminderType, entry)
    local ____temp_0
    if entry ~= nil then
        ____temp_0 = self.settings:get("belowLimits")[(reminderType .. ":") .. entry]
    else
        ____temp_0 = nil
    end
    local own = ____temp_0
    return own or self.settings:get(TYPE_LIMITS[reminderType])
end
function BelowLimitsService.prototype.setLimit(self, reminderType, entry, limit)
    if entry == nil then
        return self.settings:change(TYPE_LIMITS[reminderType], limit)
    end
    local belowLimits = __TS__ObjectAssign(
        {},
        self.settings:get("belowLimits")
    )
    local ____temp_2 = (reminderType .. ":") .. entry
    local ____temp_1
    if limit == self:getLimit(reminderType) then
        ____temp_1 = nil
    else
        ____temp_1 = limit
    end
    belowLimits[____temp_2] = ____temp_1
    self.settings:change("belowLimits", belowLimits)
end
return ____exports
 end,
["addons.glowing-bars.src.reagents.reagents_constants"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local Druid = ____wow_2Ddata.Druid
local Mage = ____wow_2Ddata.Mage
local Paladin = ____wow_2Ddata.Paladin
local Priest = ____wow_2Ddata.Priest
local Reagents = ____wow_2Ddata.Reagents
local ____array_4 = __TS__SparseArrayNew({itemId = Reagents.HolyCandle, name = "Holy Candle", classToken = "PRIEST", spells = {Priest.PrayerOfFortitude[1]}})
local ____Reagents_SacredCandle_1 = Reagents.SacredCandle
local ____array_0 = __TS__SparseArrayNew(
    Priest.PrayerOfFortitude[2],
    unpack(Priest.PrayerOfSpirit)
)
__TS__SparseArrayPush(
    ____array_0,
    unpack(Priest.PrayerOfShadowProtection)
)
__TS__SparseArrayPush(
    ____array_4,
    {
        itemId = ____Reagents_SacredCandle_1,
        name = "Sacred Candle",
        classToken = "PRIEST",
        spells = {__TS__SparseArraySpread(____array_0)}
    },
    {itemId = Reagents.WildBerries, name = "Wild Berries", classToken = "DRUID", spells = {Druid.GiftOfTheWild[1]}},
    {itemId = Reagents.WildThornroot, name = "Wild Thornroot", classToken = "DRUID", spells = {Druid.GiftOfTheWild[2]}},
    {
        itemId = Reagents.ArcanePowder,
        name = "Arcane Powder",
        classToken = "MAGE",
        spells = {unpack(Mage.ArcaneBrilliance)}
    }
)
local ____Reagents_SymbolOfKings_3 = Reagents.SymbolOfKings
local ____array_2 = __TS__SparseArrayNew(unpack(Paladin.GreaterBlessingMight))
__TS__SparseArrayPush(
    ____array_2,
    unpack(Paladin.GreaterBlessingKings)
)
__TS__SparseArrayPush(
    ____array_2,
    unpack(Paladin.GreaterBlessingWisdom)
)
__TS__SparseArrayPush(
    ____array_4,
    {
        itemId = ____Reagents_SymbolOfKings_3,
        name = "Symbol of Kings",
        classToken = "PALADIN",
        spells = {__TS__SparseArraySpread(____array_2)}
    }
)
____exports.REAGENTS = {__TS__SparseArraySpread(____array_4)}
return ____exports
 end,
["addons.glowing-bars.src.reagents.reagents_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local contains = ____core.contains
local ____reagents_2Econstants = require("addons.glowing-bars.src.reagents.reagents_constants")
local REAGENTS = ____reagents_2Econstants.REAGENTS
____exports.ReagentsService = __TS__Class()
local ReagentsService = ____exports.ReagentsService
ReagentsService.name = "ReagentsService"
function ReagentsService.prototype.____constructor(self, bags, spells, limits)
    self.bags = bags
    self.spells = spells
    self.limits = limits
    self.reagentBySpell = {}
    self.tooltipNeedsReagent = {}
    for ____, reagent in ipairs(REAGENTS) do
        for ____, spellId in ipairs(reagent.spells) do
            self.reagentBySpell[spellId] = reagent
        end
    end
end
function ReagentsService.prototype.forgetTooltips(self)
    for id in pairs(self.tooltipNeedsReagent) do
        self.tooltipNeedsReagent[id] = nil
    end
end
__TS__DecorateLegacy(
    {OnEvent("spells.invalidated")},
    ReagentsService.prototype,
    "forgetTooltips",
    true
)
function ReagentsService.prototype.hasReagentFor(self, spellId)
    local reagent = self:findReagentFor(spellId)
    return reagent == nil or self:getReagentCount(reagent) > 0
end
function ReagentsService.prototype.findTooltipReagent(self, spellId)
    local list = self.spells:readTooltipReagents(spellId)
    if list == nil then
        return nil
    end
    local plain = string.gsub((string.gsub(list, "|c%x%x%x%x%x%x%x%x", "")), "|r", "")
    local first = string.match(plain, "^%s*([^,%(]-)%s*[,%(]")
    return first or (string.match(plain, "^%s*(.-)%s*$"))
end
function ReagentsService.prototype.findReagentOfSpell(self, spellId)
    return __TS__ArrayFind(
        REAGENTS,
        function(____, reagent) return __TS__ArrayIncludes(reagent.spells, spellId) end
    )
end
function ReagentsService.prototype.getReagentsOfClass(self, classToken)
    return __TS__ArrayFilter(
        REAGENTS,
        function(____, reagent) return reagent.classToken == classToken end
    )
end
function ReagentsService.prototype.findLowReagents(self, isWanted)
    if isWanted == nil then
        isWanted = function() return true end
    end
    local low = {}
    __TS__ArrayForEach(
        REAGENTS,
        function(____, reagent, index)
            if not isWanted(reagent) then
                return
            end
            local usedBy = __TS__ArrayFind(
                reagent.spells,
                function(____, spellId) return self.spells:isLearned(spellId) and self:findReagentFor(spellId) ~= nil and not self:isOutranked(spellId, index) end
            )
            local count = self:getReagentCount(reagent)
            if usedBy ~= nil and self:isLow(
                count,
                string.format("%d", reagent.itemId)
            ) then
                low[#low + 1] = {
                    reagent = reagent,
                    spellId = usedBy,
                    name = self:getReagentName(reagent),
                    count = count
                }
            end
        end
    )
    return low
end
function ReagentsService.prototype.isOutranked(self, spellId, index)
    local name = self.spells:getSpellName(spellId)
    if name == nil then
        return false
    end
    return __TS__ArraySome(
        __TS__ArraySlice(REAGENTS, index + 1),
        function(____, later) return __TS__ArraySome(
            later.spells,
            function(____, id) return self.spells:isLearned(id) and self.spells:getSpellName(id) == name end
        ) end
    )
end
function ReagentsService.prototype.findSpellsWithLowReagent(self, isWanted)
    if isWanted == nil then
        isWanted = function() return true end
    end
    local spellIds = {}
    for ____, stock in ipairs(self:findLowReagents(isWanted)) do
        for ____, spellId in ipairs(stock.reagent.spells) do
            local learned = self.spells:resolve(spellId)
            if learned ~= nil and self:findReagentFor(spellId) ~= nil and not __TS__ArrayIncludes(spellIds, learned) then
                spellIds[#spellIds + 1] = learned
            end
        end
    end
    return spellIds
end
function ReagentsService.prototype.isLow(self, count, entry)
    return count < self.limits:getLimit("lowReagent", entry)
end
function ReagentsService.prototype.getReagentName(self, reagent)
    return self.bags:getItemName(reagent.itemId) or reagent.name
end
function ReagentsService.prototype.getReagentCount(self, reagent)
    return self.bags:getItemCount(reagent.itemId)
end
function ReagentsService.prototype.doesTooltipNameReagent(self, spellId, reagent)
    if self.tooltipNeedsReagent[spellId] ~= nil then
        return self.tooltipNeedsReagent[spellId] == true
    end
    local texts = self.spells:getSpellTooltipTexts(self.spells:resolve(spellId) or spellId)
    if texts == nil then
        return true
    end
    local reagentName = string.lower(self:getReagentName(reagent))
    local isNeeded = __TS__ArraySome(
        texts,
        function(____, text) return contains(
            string.lower(text),
            reagentName
        ) end
    )
    if self.bags:getItemName(reagent.itemId) ~= nil then
        self.tooltipNeedsReagent[spellId] = isNeeded
    end
    return isNeeded
end
function ReagentsService.prototype.findReagentFor(self, spellId)
    local reagent = self.reagentBySpell[spellId]
    return reagent and self:doesTooltipNameReagent(spellId, reagent) and reagent or nil
end
return ____exports
 end,
["addons.glowing-bars.src.glows.added-spells_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local isKnownItem = ____wow.isKnownItem
____exports.AddedSpellsService = __TS__Class()
local AddedSpellsService = ____exports.AddedSpellsService
AddedSpellsService.name = "AddedSpellsService"
function AddedSpellsService.prototype.____constructor(self, spells, settings, cooldowns, reagents)
    self.spells = spells
    self.settings = settings
    self.cooldowns = cooldowns
    self.reagents = reagents
end
function AddedSpellsService.prototype.findTypeProblem(self, spellId, reminderType)
    if reminderType == "readyCooldown" and self.cooldowns:getBaseCooldown(spellId) <= 0 then
        return "MSG_NO_COOLDOWN"
    end
    if reminderType == "lowReagent" and self.reagents:findTooltipReagent(spellId) == nil then
        return "MSG_NO_REAGENT"
    end
    return nil
end
function AddedSpellsService.prototype.getEffectiveId(self, listId)
    return self.settings:get("idOverrides")[string.format("%d", listId)] or listId
end
function AddedSpellsService.prototype.isKnownSpell(self, spellId)
    return self.spells:getSpellName(spellId) ~= nil
end
function AddedSpellsService.prototype.changeOverride(self, listId, spellId)
    if not self:isKnownSpell(spellId) then
        return false
    end
    local overrides = __TS__ObjectAssign(
        {},
        self.settings:get("idOverrides")
    )
    local ____string_format_result_1 = string.format("%d", listId)
    local ____temp_0
    if spellId == listId then
        ____temp_0 = nil
    else
        ____temp_0 = spellId
    end
    overrides[____string_format_result_1] = ____temp_0
    self.spells:forgetResolved(listId)
    self.settings:change("idOverrides", overrides)
    return true
end
function AddedSpellsService.prototype.listAdded(self, reminderType)
    return __TS__ArrayMap(
        __TS__ArrayFilter(
            self.settings:get("addedSpells"),
            function(____, spell) return spell.reminderType == reminderType end
        ),
        function(____, spell) return spell.id end
    )
end
function AddedSpellsService.prototype.addSpell(self, spellId, reminderType)
    if not self:isKnownSpell(spellId) then
        return false
    end
    local spells = self.settings:get("addedSpells")
    if not __TS__ArraySome(
        spells,
        function(____, spell) return spell.id == spellId end
    ) then
        local ____self_3 = self.settings
        local ____self_3_change_4 = ____self_3.change
        local ____array_2 = __TS__SparseArrayNew(unpack(spells))
        __TS__SparseArrayPush(____array_2, {id = spellId, reminderType = reminderType})
        ____self_3_change_4(
            ____self_3,
            "addedSpells",
            {__TS__SparseArraySpread(____array_2)}
        )
    end
    return true
end
function AddedSpellsService.prototype.addItem(self, itemId)
    if not isKnownItem(itemId) then
        return false
    end
    local spells = self.settings:get("addedSpells")
    if not __TS__ArraySome(
        spells,
        function(____, spell) return spell.id == itemId and spell.reminderType == "lowStock" end
    ) then
        local ____self_6 = self.settings
        local ____self_6_change_7 = ____self_6.change
        local ____array_5 = __TS__SparseArrayNew(unpack(spells))
        __TS__SparseArrayPush(____array_5, {id = itemId, reminderType = "lowStock"})
        ____self_6_change_7(
            ____self_6,
            "addedSpells",
            {__TS__SparseArraySpread(____array_5)}
        )
    end
    return true
end
function AddedSpellsService.prototype.changeAdded(self, oldId, spellId)
    if not self:isKnownSpell(spellId) then
        return false
    end
    local spells = __TS__ArrayMap(
        self.settings:get("addedSpells"),
        function(____, spell) return spell.id == oldId and ({id = spellId, reminderType = spell.reminderType}) or spell end
    )
    self.settings:change("addedSpells", spells)
    return true
end
function AddedSpellsService.prototype.removeAdded(self, spellId, reminderType)
    self.settings:change(
        "addedSpells",
        __TS__ArrayFilter(
            self.settings:get("addedSpells"),
            function(____, spell) return spell.id ~= spellId or reminderType ~= nil and reminderType == "lowStock" ~= (spell.reminderType == "lowStock") end
        )
    )
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.fed-buffs_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArrayEvery = ____lualib.__TS__ArrayEvery
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local Interval = ____core.Interval
local OnEvent = ____core.OnEvent
local ____wow = require("packages.@wowkit.wow.src.index")
local buildNameKey = ____wow.buildNameKey
local findButtonItem = ____wow.findButtonItem
local findItemUseSpell = ____wow.findItemUseSpell
local isOutOfItem = ____wow.isOutOfItem
local readItemLook = ____wow.readItemLook
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local Consumable = ____wow_2Ddata.Consumable
--- The buff of eating may take this long to show after the cast; a spell with no eating after it is no food.
local EATING_GRACE_SECONDS = 1.5
--- Two Well Fed closer than this in what they have left came at the same moment: their order cannot be told.
local SAME_MOMENT_SECONDS = 0.1
--- The spells named so give a Well Fed, whatever their ID, by what they are; any other is known once learned.
local FED_SPELLS = {Food = {Consumable.Food, Consumable.NutritiousFood}, Drink = {Consumable.NutritiousDrink}}
____exports.FedBuffsService = __TS__Class()
local FedBuffsService = ____exports.FedBuffsService
FedBuffsService.name = "FedBuffsService"
function FedBuffsService.prototype.____constructor(self, addedSpells, spells, buffState, player, clock, settings, actionBars)
    self.addedSpells = addedSpells
    self.spells = spells
    self.buffState = buffState
    self.player = player
    self.clock = clock
    self.settings = settings
    self.actionBars = actionBars
    self.used = {}
end
function FedBuffsService.prototype.noteUse(self, cast)
    local spellId = cast.spellId
    if spellId == nil then
        return
    end
    local isAdded = __TS__ArraySome(
        self.addedSpells:listAdded("missingBuff"),
        function(____, id) return id == spellId or self.spells:resolve(id) == spellId end
    )
    if isAdded then
        local ____self_used_0 = self.used
        ____self_used_0[#____self_used_0 + 1] = {
            spellId = spellId,
            usedAt = self.clock:getCurrentTime()
        }
    end
end
__TS__DecorateLegacy(
    {OnEvent("player.spell-cast")},
    FedBuffsService.prototype,
    "noteUse",
    true
)
function FedBuffsService.prototype.checkWellFed(self)
    local auras = self.buffState:findAuras(Consumable.WellFed)
    if auras == nil then
        return
    end
    local now = self.clock:getCurrentTime()
    local isEating = self.player:isEating()
    self.used = __TS__ArrayFilter(
        self.used,
        function(____, food) return isEating or now - food.usedAt < EATING_GRACE_SECONDS end
    )
    local seen = self.seen
    self.seen = {}
    for ____, aura in ipairs(auras) do
        if aura.spellId ~= nil then
            self.seen[aura.spellId] = true
        end
    end
    if seen ~= nil then
        self:rememberNew(__TS__ArrayFilter(
            auras,
            function(____, aura) return aura.spellId ~= nil and not (seen[aura.spellId] ~= nil) end
        ))
    end
end
__TS__DecorateLegacy(
    {Interval(200)},
    FedBuffsService.prototype,
    "checkWellFed",
    true
)
function FedBuffsService.prototype.isFedSpell(self, spellId)
    return self.settings:get("fedBuffs")[string.format("%d", spellId)] ~= nil or self:findFedKind(spellId) ~= nil
end
function FedBuffsService.prototype.isButtonWanted(self, button, wanted)
    local spellId = self:findButtonSpell(button)
    return spellId == nil or not self:isFedSpell(spellId) or __TS__ArrayIncludes(wanted, spellId)
end
function FedBuffsService.prototype.isOnBarsWithSome(self, spellId)
    return __TS__ArraySome(
        self.actionBars:findButtonsOf(spellId),
        function(____, button) return self:findButtonSpell(button) == spellId and not isOutOfItem(self.actionBars, button) end
    )
end
function FedBuffsService.prototype.findItemLook(self, spellId)
    if not self:isFedSpell(spellId) then
        return nil
    end
    local key = string.format("%d", spellId)
    local button = __TS__ArrayFind(
        self.actionBars:findButtonsOf(spellId),
        function(____, candidate) return self:findButtonSpell(candidate) == spellId end
    )
    local ____temp_1
    if button ~= nil then
        ____temp_1 = findButtonItem(self.actionBars, button)
    else
        ____temp_1 = nil
    end
    local seen = ____temp_1
    if seen ~= nil and self.settings:get("fedItems")[key] ~= seen then
        self.settings:change(
            "fedItems",
            __TS__ObjectAssign(
                {},
                self.settings:get("fedItems"),
                {[key] = seen}
            )
        )
    end
    local itemId = self.settings:get("fedItems")[key]
    return itemId ~= nil and readItemLook(itemId) or nil
end
function FedBuffsService.prototype.findMissing(self, spellIds)
    local auras = self.buffState:findAuras(Consumable.WellFed)
    if auras == nil then
        return self.buffState:hasAura(Consumable.WellFed) and ({}) or spellIds
    end
    local keyByAura = self:listLearned()
    local upKeys = {}
    local unknown = 0
    for ____, aura in ipairs(auras) do
        local key = keyByAura[aura.spellId or 0]
        if key ~= nil then
            upKeys[key] = true
        else
            unknown = unknown + 1
        end
    end
    local waiting = {}
    for ____, id in ipairs(spellIds) do
        local key = self:getKey(id)
        if not (upKeys[key] ~= nil) and not __TS__ArrayIncludes(waiting, key) then
            waiting[#waiting + 1] = key
        end
    end
    if unknown >= #waiting then
        return {}
    end
    return __TS__ArrayFilter(
        spellIds,
        function(____, id) return __TS__ArrayIncludes(
            waiting,
            self:getKey(id)
        ) end
    )
end
function FedBuffsService.prototype.rememberNew(self, auras)
    if #auras == 0 or #self.used == 0 then
        return
    end
    local sorted = __TS__ArraySort(
        {unpack(auras)},
        function(____, a, b) return a.remain - b.remain end
    )
    local isClear = __TS__ArrayEvery(
        sorted,
        function(____, aura, i) return i == 0 or aura.remain - sorted[i].remain > SAME_MOMENT_SECONDS end
    )
    local foods = __TS__ArraySplice(self.used, 0, #sorted)
    if not isClear then
        return
    end
    local learned = __TS__ObjectAssign(
        {},
        self.settings:get("fedBuffs")
    )
    __TS__ArrayForEach(
        foods,
        function(____, food, i)
            learned[string.format("%d", food.spellId)] = sorted[i + 1].spellId
        end
    )
    self.settings:change("fedBuffs", learned)
end
function FedBuffsService.prototype.listLearned(self)
    local keyByAura = {}
    for spell, aura in pairs(self.settings:get("fedBuffs")) do
        if aura ~= nil then
            keyByAura[aura] = self:getKey(tonumber(spell))
        end
    end
    return keyByAura
end
function FedBuffsService.prototype.findButtonSpell(self, button)
    local itemId = findButtonItem(self.actionBars, button)
    local ____temp_2
    if itemId ~= nil then
        ____temp_2 = findItemUseSpell(itemId)
    else
        ____temp_2 = nil
    end
    return ____temp_2
end
function FedBuffsService.prototype.findFedKind(self, spellId)
    local key = self:getNameKey(spellId)
    for kind, ids in pairs(FED_SPELLS) do
        if __TS__ArraySome(
            ids,
            function(____, id) return self:getNameKey(id) == key end
        ) then
            return kind
        end
    end
    return nil
end
function FedBuffsService.prototype.getKey(self, spellId)
    return self:findFedKind(spellId) or self:getNameKey(spellId)
end
function FedBuffsService.prototype.getNameKey(self, spellId)
    return buildNameKey(self.spells:getSpellLabel(spellId) or string.format("%d", spellId))
end
return ____exports
 end,
["addons.glowing-bars.src.tick.show-reminders_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__ArrayJoin = ____lualib.__TS__ArrayJoin
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local isOutOfItem = ____wow.isOutOfItem
local TYPES = {
    {
        category = "missingBuff",
        isOnSetting = "isMissingBuffEnabled",
        findSpells = function(reminders) return reminders.buffsToCast end
    },
    {
        category = "weaponBuff",
        isOnSetting = "isWeaponBuffEnabled",
        findSpells = function(reminders)
            local ____array_0 = __TS__SparseArrayNew(unpack(reminders.weaponSpell ~= nil and ({reminders.weaponSpell}) or ({})))
            __TS__SparseArrayPush(
                ____array_0,
                unpack(reminders.addedWeaponSpells)
            )
            return {__TS__SparseArraySpread(____array_0)}
        end
    },
    {
        category = "missingSeal",
        isOnSetting = "isMissingSealEnabled",
        findSpells = function(reminders) return reminders.seals end
    },
    {
        category = "missingTracking",
        isOnSetting = "isMissingTrackingEnabled",
        findSpells = function(reminders) return reminders.trackings end
    },
    {
        category = "readyCooldown",
        isOnSetting = "isReadyCooldownEnabled",
        findSpells = function(reminders) return reminders.readyCooldowns end
    },
    {
        category = "proc",
        isOnSetting = "isProcEnabled",
        findSpells = function(reminders) return reminders.procs end
    },
    {
        category = "oldRank",
        isOnSetting = "isOldRankEnabled",
        findSpells = function(reminders) return __TS__ArrayMap(
            reminders.outdatedRanks,
            function(____, rank) return rank.id end
        ) end
    },
    {
        category = "lowReagent",
        isOnSetting = "isLowReagentEnabled",
        findSpells = function(reminders) return reminders.reagentSpells end
    },
    {
        category = "lowStock",
        isOnSetting = "isLowStockEnabled",
        findSpells = function(reminders) return __TS__ArrayMap(
            reminders.lowStock,
            function(____, stock) return stock.key end
        ) end
    }
}
____exports.ShowRemindersService = __TS__Class()
local ShowRemindersService = ____exports.ShowRemindersService
ShowRemindersService.name = "ShowRemindersService"
function ShowRemindersService.prototype.____constructor(self, glow, messages, settings, notices, styles, actionBars, barFade, clock, fedBuffs)
    self.glow = glow
    self.messages = messages
    self.settings = settings
    self.notices = notices
    self.styles = styles
    self.actionBars = actionBars
    self.barFade = barFade
    self.clock = clock
    self.fedBuffs = fedBuffs
    self.glows = {}
    self.previous = __TS__ArrayMap(
        TYPES,
        function() return {} end
    )
    self.soundPlayedAt = {}
    self.wasInTown = false
    self.usedUpShown = {}
    self.groupSpells = {}
end
function ShowRemindersService.prototype.showReminders(self, reminders)
    self:playSoundsForNewReminders(reminders)
    self.notices:showNoticeIfNew(reminders)
    self:updateGlows(reminders)
    self:applyBarFades()
end
function ShowRemindersService.prototype.applyBarFades(self)
    local opacityByBar = {}
    local glowPercent = self.settings:get("fadedOpacity") / 100
    for bar, isFaded in pairs(self.settings:get("fadedBars")) do
        local number = tonumber(bar)
        if isFaded == true and number ~= nil then
            opacityByBar[number] = glowPercent
        end
    end
    self.barFade:applyBarFades(opacityByBar)
end
function ShowRemindersService.prototype.markGlowsStale(self)
    self.shownGlowKey = nil
end
function ShowRemindersService.prototype.redrawGlowsAfterSettingChange(self, key)
    if key ~= "styles" and key ~= "spellStyles" and key ~= "barsThatGlow" and key ~= "idOverrides" and key ~= "addedSpells" and key ~= "roundAnimation" and not __TS__ArraySome(
        TYPES,
        function(____, reminderType) return reminderType.isOnSetting == key end
    ) then
        return
    end
    for ____, glow in pairs(self.glows) do
        glow.clear()
    end
    self:markGlowsStale()
end
function ShowRemindersService.prototype.playSoundsForNewReminders(self, reminders)
    local now = self.clock:getCurrentTime()
    local hasArrivedInTown = reminders.isInTown == true and not self.wasInTown
    self.wasInTown = reminders.isInTown == true
    local playedAt = {}
    local sounds = {}
    __TS__ArrayForEach(
        TYPES,
        function(____, reminderType, index)
            local spells = reminderType.findSpells(reminders)
            for ____, id in ipairs(spells) do
                local key = (reminderType.category .. ":") .. tostring(id)
                local style = self.styles:getStyle(reminderType.category, id)
                local lastAt = self.soundPlayedAt[key]
                local isNew = not __TS__ArrayIncludes(self.previous[index + 1], id) or lastAt == nil or self:isStartingOver(style, hasArrivedInTown)
                local isDue = not isNew and style["repeat"] > 0 and now - lastAt >= style["repeat"]
                playedAt[key] = (isNew or isDue) and now or lastAt
                if self:isHeardHere(style, reminders) and (isNew or isDue) and not __TS__ArrayIncludes(sounds, style.sound) then
                    sounds[#sounds + 1] = style.sound
                end
            end
            self.previous[index + 1] = spells
        end
    )
    self.soundPlayedAt = playedAt
    for ____, sound in ipairs(sounds) do
        self.messages:playAlertSound(sound)
    end
end
function ShowRemindersService.prototype.isStartingOver(self, style, hasArrivedInTown)
    return hasArrivedInTown and style.when == "townAlert"
end
function ShowRemindersService.prototype.isHeardHere(self, style, reminders)
    return style.when ~= "townAlert" or reminders.isInTown == true
end
function ShowRemindersService.prototype.updateGlows(self, reminders)
    local groups = self:listGroups(reminders)
    self.groupSpells = {}
    for ____, group in ipairs(groups) do
        self.groupSpells[group.key] = group.spells
    end
    local weaponSpells = reminders.weaponSpell ~= nil and ({reminders.weaponSpell}) or ({})
    local ____array_1 = __TS__SparseArrayNew(unpack(weaponSpells))
    __TS__SparseArrayPush(
        ____array_1,
        unpack(reminders.addedWeaponSpells)
    )
    __TS__SparseArrayPush(
        ____array_1,
        unpack(__TS__ArrayMap(
            reminders.lowStock,
            function(____, stock) return stock.key end
        ))
    )
    self.usedUpShown = {__TS__SparseArraySpread(____array_1)}
    local glowKey = table.concat(
        __TS__ArrayMap(
            groups,
            function(____, group) return (group.key .. "=") .. table.concat(group.spells, ",") end
        ),
        ";"
    )
    if glowKey == self.shownGlowKey then
        return
    end
    self.glow:setRoundAnimation(self.settings:get("roundAnimation"))
    for key, glow in pairs(self.glows) do
        if not __TS__ArraySome(
            groups,
            function(____, group) return group.key == key end
        ) then
            glow.clear()
        end
    end
    for ____, group in ipairs(groups) do
        local glow = self.glows[group.key]
        if glow == nil then
            local key = group.key
            glow = self.glow:createButtonGlow(
                key,
                group.animation,
                function(button) return self:isBarShown(button, key) end
            )
            self.glows[group.key] = glow
        end
        glow.show(group.spells, group.color)
        glow.setAlpha(group.glowPercent / 100)
    end
    self.shownGlowKey = glowKey
end
function ShowRemindersService.prototype.isBarShown(self, button, groupKey)
    local isUsedUpShown = __TS__ArraySome(
        self.usedUpShown,
        function(____, id) return __TS__ArrayIncludes(
            self.actionBars:findButtonsOf(id),
            button
        ) end
    )
    if not isUsedUpShown and isOutOfItem(self.actionBars, button) then
        return false
    end
    local spells = self.groupSpells[groupKey] or ({})
    local isOwnUsedUp = __TS__ArraySome(
        spells,
        function(____, id) return __TS__ArrayIncludes(self.usedUpShown, id) and __TS__ArrayIncludes(
            self.actionBars:findButtonsOf(id),
            button
        ) end
    )
    if not isOwnUsedUp and not self.fedBuffs:isButtonWanted(button, spells) then
        return false
    end
    local bar = self.actionBars:getBarNumber(button)
    return bar == nil or self.settings:get("barsThatGlow")[string.format("%d", bar)] ~= false
end
function ShowRemindersService.prototype.listGroups(self, reminders)
    local groups = {}
    for ____, reminderType in ipairs(TYPES) do
        for ____, id in ipairs(reminderType.findSpells(reminders)) do
            local style = self.styles:getStyle(reminderType.category, id)
            local key = (((__TS__ArrayJoin(style.color, ",") .. "|") .. tostring(style.glowPercent)) .. "|") .. style.animation
            local group = __TS__ArrayFind(
                groups,
                function(____, candidate) return candidate.key == key end
            )
            local color = style.color
            local glowPercent = style.glowPercent
            local animation = style.animation
            if group == nil then
                groups[#groups + 1] = {
                    key = key,
                    color = color,
                    glowPercent = glowPercent,
                    animation = animation,
                    spells = {id}
                }
            elseif not __TS__ArrayIncludes(group.spells, id) then
                local ____group_spells_2 = group.spells
                ____group_spells_2[#____group_spells_2 + 1] = id
            end
        end
    end
    return groups
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.buff-reminder_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
____exports.BuffReminderService = __TS__Class()
local BuffReminderService = ____exports.BuffReminderService
BuffReminderService.name = "BuffReminderService"
function BuffReminderService.prototype.____constructor(self, auras, spells, player, actionBars, classBuffs, settings)
    self.auras = auras
    self.spells = spells
    self.player = player
    self.actionBars = actionBars
    self.classBuffs = classBuffs
    self.settings = settings
end
function BuffReminderService.prototype.checkBuff(self, classBuff)
    local id = self.spells:resolve(classBuff.id)
    if id == nil or not self.spells:isLearned(id) then
        return {isWanted = false}
    end
    if classBuff.isSwimmingOnly and not self.player:isSwimming() then
        return {isWanted = false}
    end
    for ____, other in ipairs(classBuff.categoryMembers or ({})) do
        if self.auras:hasAura(other) then
            return {isWanted = false}
        end
    end
    if self.auras:hasAura(id, classBuff.lead) then
        return {isWanted = false}
    end
    return {isWanted = true}
end
function BuffReminderService.prototype.rememberSelfBuffs(self)
    if self.player:isInCombat() then
        return
    end
    local blessings = {}
    for ____, classBuff in ipairs(self.classBuffs:getClassBuffs()) do
        if self.classBuffs:isBuffEnabled(classBuff) then
            local id = self.spells:resolve(classBuff.id)
            if id ~= nil then
                self.auras:hasAura(id)
            end
        end
        local ____opt_0 = classBuff.party
        if ____opt_0 and ____opt_0.isPerClass then
            blessings[#blessings + 1] = {
                classBuff.id,
                {
                    classBuff.id,
                    unpack(classBuff.party.groupIds or ({}))
                }
            }
        end
    end
    local ____temp_2
    if #blessings > 0 then
        ____temp_2 = self.auras:findOwnUnitBuff("player", blessings)
    else
        ____temp_2 = nil
    end
    local onPlayer = ____temp_2
    local castBuff = __TS__ArrayFind(
        self.classBuffs:getClassBuffs(),
        function(____, classBuff) return classBuff.id == onPlayer end
    )
    if castBuff ~= nil then
        self:noteGroupBuff(castBuff)
    end
end
function BuffReminderService.prototype.noteCast(self, cast)
    if cast.spellId == nil then
        return
    end
    local id = self.spells:resolveOrSame(cast.spellId)
    local castName = self.spells:getSpellName(id)
    local castBuff = __TS__ArrayFind(
        self.classBuffs:getClassBuffs(),
        function(____, classBuff)
            local ____temp_5 = classBuff.categoryMembers ~= nil
            if ____temp_5 then
                local ____opt_3 = classBuff.party
                ____temp_5 = (____opt_3 and ____opt_3.isPerClass) ~= true
            end
            local ____temp_5_9 = ____temp_5
            if ____temp_5_9 then
                local ____classBuff_id_8 = classBuff.id
                local ____opt_6 = classBuff.party
                ____temp_5_9 = __TS__ArraySome(
                    {
                        ____classBuff_id_8,
                        unpack(____opt_6 and ____opt_6.groupIds or ({}))
                    },
                    function(____, buffId) return (self.spells:resolve(buffId) or buffId) == id or self.spells:getSpellName(buffId) == castName end
                )
            end
            return ____temp_5_9
        end
    )
    if castBuff ~= nil then
        self:noteGroupBuff(castBuff)
    end
end
__TS__DecorateLegacy(
    {OnEvent("player.spell-cast")},
    BuffReminderService.prototype,
    "noteCast",
    true
)
function BuffReminderService.prototype.noteGroupBuff(self, classBuff)
    local group = self.classBuffs:getGroupKey(classBuff)
    local lastBuffs = self.settings:get("lastBuffs")
    if lastBuffs[group] ~= classBuff.id then
        self.settings:change(
            "lastBuffs",
            __TS__ObjectAssign({}, lastBuffs, {[group] = classBuff.id})
        )
    end
end
function BuffReminderService.prototype.findMissingBuffs(self)
    local groups = {}
    local groupOf = {}
    local candidates = {}
    local categoryOnBars = {}
    for ____, classBuff in ipairs(self.classBuffs:getClassBuffs()) do
        do
            local __continue27
            repeat
                if not self.classBuffs:isBuffEnabled(classBuff) or not self:checkBuff(classBuff).isWanted then
                    __continue27 = true
                    break
                end
                local id = self.spells:resolve(classBuff.id) or classBuff.id
                local category = classBuff.categoryMembers or classBuff
                if not self.actionBars:isOnBars(id) then
                    candidates[#candidates + 1] = {id = id, category = category}
                    __continue27 = true
                    break
                end
                categoryOnBars[category] = true
                if self.spells:isCastable(id) == false then
                    __continue27 = true
                    break
                end
                local members = groupOf[category]
                if members == nil then
                    members = {}
                    groupOf[category] = members
                    groups[#groups + 1] = members
                end
                members[#members + 1] = classBuff
                __continue27 = true
            until true
            if not __continue27 then
                break
            end
        end
    end
    local glow = __TS__ArrayMap(
        groups,
        function(____, members)
            local picked = self.classBuffs:pickGroupBuff(members)
            return self.spells:resolve(picked.id) or picked.id
        end
    )
    local notOnBars = {}
    local named = {}
    for ____, candidate in ipairs(candidates) do
        if not (categoryOnBars[candidate.category] ~= nil) and not (named[candidate.category] ~= nil) then
            named[candidate.category] = true
            notOnBars[#notOnBars + 1] = candidate.id
        end
    end
    return {glow = glow, notOnBars = notOnBars}
end
return ____exports
 end,
["addons.glowing-bars.src.glows.glow-cues_constants"] = function(...) 
local ____exports = {}
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local Druid = ____wow_2Ddata.Druid
local Hunter = ____wow_2Ddata.Hunter
local Mage = ____wow_2Ddata.Mage
local Paladin = ____wow_2Ddata.Paladin
local Priest = ____wow_2Ddata.Priest
local Racial = ____wow_2Ddata.Racial
local Rogue = ____wow_2Ddata.Rogue
local Shaman = ____wow_2Ddata.Shaman
local Warlock = ____wow_2Ddata.Warlock
local Warrior = ____wow_2Ddata.Warrior
--- Important cooldowns: they glow when ready, in combat. The player can switch each off.
____exports.COOLDOWN_CUES = {
    DRUID = {
        Druid.Innervate,
        Druid.NaturesSwiftness,
        Druid.Barkskin,
        Druid.TigersFury,
        Druid.Berserk,
        Druid.FrenziedRegeneration
    },
    HUNTER = {Hunter.RapidFire, Hunter.BestialWrath, Hunter.Deterrence},
    MAGE = {
        Mage.PresenceOfMind,
        Mage.ArcanePower,
        Mage.Combustion,
        Mage.Evocation,
        Mage.IceBlock,
        Mage.IceBarrier
    },
    PALADIN = {Paladin.DivineShield, Paladin.DivineProtection, Paladin.LayOnHands, Paladin.SwiftJudgement},
    PRIEST = {Priest.InnerFocus, Priest.PowerInfusion, Priest.Fade},
    ROGUE = {
        Rogue.AdrenalineRush,
        Rogue.BladeFlurry,
        Rogue.ColdBlood,
        Rogue.Preparation,
        Rogue.Evasion,
        Rogue.Vanish
    },
    SHAMAN = {Shaman.ElementalMastery, Shaman.NaturesSwiftness},
    WARLOCK = {Warlock.DeathCoil},
    WARRIOR = {
        Warrior.Recklessness,
        Warrior.DeathWish,
        Warrior.Bloodrage,
        Warrior.SweepingStrikes,
        Warrior.BerserkerRage,
        Warrior.Retaliation,
        Warrior.ShieldWall,
        Warrior.LastStand
    }
}
--- The racials worth a glow in a fight, of every race: only the ones the player has learned count. Offensive (Blood Fury,
-- Berserking, Elune's Light, Eureka), defensive (Stoneform, Will to Survive, Rapid Regeneration), and the ones that break
-- out of a hold (Will of the Forsaken, Escape Artist, Shatter Curse), War Stomp and Perception. And the priest's spells
-- of each race that have a cooldown (Desperate Prayer, Elune's Grace, Feedback, Divine Grace...); the ones without one
-- (Touch of Weakness, Shadowguard, Hex of Weakness) are buffs and debuffs, not cooldowns.
____exports.RACIAL_COOLDOWNS = {
    Racial.BloodFury,
    Racial.Berserking,
    Racial.ElunesLight,
    Racial.Eureka,
    Racial.Stoneform,
    Racial.WillToSurvive,
    Racial.RapidRegeneration,
    Racial.WillOfTheForsaken,
    Racial.EscapeArtist,
    Racial.ShatterCurse,
    Racial.WarStomp,
    Racial.Perception,
    Priest.DesperatePrayer,
    Priest.DivineGrace,
    Priest.Feedback,
    Priest.Chastise,
    Priest.ElunesGrace,
    Priest.Starshards,
    Priest.DarkSacrifice,
    Priest.ConfoundingFlash,
    Priest.ContingencyPlan
}
--- Procs: the spell glows while the game says it is usable (and not on cooldown). The player can switch each off.
____exports.PROC_CUES = {HUNTER = {Hunter.Counterattack, Hunter.MongooseBite}, PALADIN = {Paladin.HammerOfWrath}, ROGUE = {Rogue.Riposte}, WARRIOR = {Warrior.Overpower, Warrior.Revenge, Warrior.Execute, Warrior.VictoryRush}}
--- Cooldowns that start when another spell is cast, not when they are: Swift Judgement makes the next Judgement cheap, and
-- its cooldown starts as that Judgement uses it up, however long that takes. Until then the spell is not ready.
____exports.COOLDOWN_STARTED_BY = {{Paladin.SwiftJudgement, {Paladin.Judgement}}}
return ____exports
 end,
["addons.glowing-bars.src.glows.cooldown-tracker_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local ____glow_2Dcues_2Econstants = require("addons.glowing-bars.src.glows.glow-cues_constants")
local COOLDOWN_STARTED_BY = ____glow_2Dcues_2Econstants.COOLDOWN_STARTED_BY
--- A cooldown this short is the global cooldown, which never takes a spell out of the picture.
local GLOBAL_COOLDOWN = 1.51
--- Under this many seconds a cooldown counts as over.
____exports.READY_MARGIN = 0.2
--- What a cooldown that waits for another spell's cast has left: it is not ready until then.
local WAITING = math.huge
--- Right after a cast the client may not show the new cooldown yet; a readable "ready" is not believed for this long.
local CAST_GRACE = 1
____exports.CooldownTrackerService = __TS__Class()
local CooldownTrackerService = ____exports.CooldownTrackerService
CooldownTrackerService.name = "CooldownTrackerService"
function CooldownTrackerService.prototype.____constructor(self, spells, cooldowns, clock)
    self.spells = spells
    self.cooldowns = cooldowns
    self.clock = clock
    self.endsAt = {}
    self.knownLength = {}
    self.castAt = {}
    self.waiting = {}
end
function CooldownTrackerService.prototype.getRemaining(self, spellId)
    local id = self.spells:resolveOrSame(spellId)
    if self.waiting[id] ~= nil then
        return WAITING
    end
    local read = self.cooldowns:readCooldown(id)
    local now = self.clock:getCurrentTime()
    if not read.isHidden then
        if read.duration > GLOBAL_COOLDOWN then
            self.knownLength[id] = read.duration
        end
        if read.remain > ____exports.READY_MARGIN then
            self.endsAt[id] = now + read.remain
            return read.remain
        end
        if now - (self.castAt[id] or -CAST_GRACE) > CAST_GRACE then
            self.endsAt[id] = nil
            return 0
        end
    end
    local endsAt = self.endsAt[id]
    if endsAt == nil then
        return 0
    end
    if endsAt <= now then
        self.endsAt[id] = nil
        return 0
    end
    return endsAt - now
end
function CooldownTrackerService.prototype.noteSpellCast(self, cast)
    if cast.spellId == nil then
        return
    end
    local id = self.spells:resolveOrSame(cast.spellId)
    local now = self.clock:getCurrentTime()
    local started = {}
    for waitingId in pairs(self.waiting) do
        if self:isStartedBy(waitingId, id) then
            started[#started + 1] = waitingId
        end
    end
    for ____, waitingId in ipairs(started) do
        self.waiting[waitingId] = nil
        self:startCooldown(waitingId, now)
    end
    self.castAt[id] = now
    if __TS__ArraySome(
        COOLDOWN_STARTED_BY,
        function(____, ____bindingPattern0)
            local spellId
            spellId = ____bindingPattern0[1]
            return self.spells:resolveOrSame(spellId) == id
        end
    ) then
        self.waiting[id] = true
        self.endsAt[id] = nil
    else
        self:startCooldown(id, now)
    end
end
__TS__DecorateLegacy(
    {OnEvent("player.spell-cast")},
    CooldownTrackerService.prototype,
    "noteSpellCast",
    true
)
function CooldownTrackerService.prototype.startCooldown(self, id, now)
    local seconds = math.max(
        self.cooldowns:getBaseCooldown(id),
        self.knownLength[id] or 0
    )
    if seconds > GLOBAL_COOLDOWN then
        self.endsAt[id] = now + seconds
    end
end
function CooldownTrackerService.prototype.isStartedBy(self, waitingId, castId)
    return __TS__ArraySome(
        COOLDOWN_STARTED_BY,
        function(____, ____bindingPattern0)
            local startedBy
            local spellId
            spellId = ____bindingPattern0[1]
            startedBy = ____bindingPattern0[2]
            return self.spells:resolveOrSame(spellId) == waitingId and __TS__ArraySome(
                startedBy,
                function(____, starter) return self.spells:resolveOrSame(starter) == castId end
            )
        end
    )
end
return ____exports
 end,
["addons.glowing-bars.src.glows.glow-cues_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnGameEvent = ____core.OnGameEvent
local ____glow_2Dcues_2Econstants = require("addons.glowing-bars.src.glows.glow-cues_constants")
local COOLDOWN_CUES = ____glow_2Dcues_2Econstants.COOLDOWN_CUES
local PROC_CUES = ____glow_2Dcues_2Econstants.PROC_CUES
local RACIAL_COOLDOWNS = ____glow_2Dcues_2Econstants.RACIAL_COOLDOWNS
local ____cooldown_2Dtracker_2Eservice = require("addons.glowing-bars.src.glows.cooldown-tracker_service")
local READY_MARGIN = ____cooldown_2Dtracker_2Eservice.READY_MARGIN
____exports.GlowCuesService = __TS__Class()
local GlowCuesService = ____exports.GlowCuesService
GlowCuesService.name = "GlowCuesService"
function GlowCuesService.prototype.____constructor(self, player, spells, spellDetails, actionBars, tracker, settings, addedSpells)
    self.player = player
    self.spells = spells
    self.spellDetails = spellDetails
    self.actionBars = actionBars
    self.tracker = tracker
    self.settings = settings
    self.addedSpells = addedSpells
    self.usedInCombat = {}
end
function GlowCuesService.prototype.startFight(self)
    self.usedInCombat = {}
    local isReadyGlowing = self.settings:get("showCooldownsAtFightStart")
    for ____, id in ipairs(self:listCues(self:listCueIds("readyCooldown"))) do
        if isReadyGlowing or self.tracker:getRemaining(id) > READY_MARGIN then
            self.usedInCombat[id] = true
        end
    end
end
__TS__DecorateLegacy(
    {OnGameEvent("PLAYER_REGEN_DISABLED")},
    GlowCuesService.prototype,
    "startFight",
    true
)
function GlowCuesService.prototype.findReadyCooldowns(self)
    if not self.settings:get("isReadyCooldownEnabled") then
        return {}
    end
    local isInCombat = self.player:isInCombat()
    local ready = {}
    for ____, id in ipairs(self:listCues(self:listCueIds("readyCooldown"))) do
        do
            local __continue9
            repeat
                if self.tracker:getRemaining(id) > READY_MARGIN then
                    if isInCombat then
                        self.usedInCombat[id] = true
                    end
                    __continue9 = true
                    break
                end
                if not isInCombat or self.usedInCombat[id] ~= nil then
                    ready[#ready + 1] = id
                end
                __continue9 = true
            until true
            if not __continue9 then
                break
            end
        end
    end
    return ready
end
function GlowCuesService.prototype.findProcs(self)
    if not self.settings:get("isProcEnabled") then
        return {}
    end
    return __TS__ArrayFilter(
        self:listCues(self:listCueIds("proc")),
        function(____, id) return self.spellDetails:readUsability(id).isUsable == true and self.tracker:getRemaining(id) <= READY_MARGIN end
    )
end
function GlowCuesService.prototype.listBuiltInIds(self, reminderType)
    local classToken = self.player:getClassToken() or ""
    if reminderType == "proc" then
        return PROC_CUES[classToken] or ({})
    end
    local racials = __TS__ArrayFilter(
        RACIAL_COOLDOWNS,
        function(____, id) return self.spells:isLearned(self.addedSpells:getEffectiveId(id)) end
    )
    local ____array_0 = __TS__SparseArrayNew(unpack(COOLDOWN_CUES[classToken] or ({})))
    __TS__SparseArrayPush(
        ____array_0,
        unpack(racials)
    )
    return {__TS__SparseArraySpread(____array_0)}
end
function GlowCuesService.prototype.listCueIds(self, reminderType)
    local ids = {}
    local ____array_1 = __TS__SparseArrayNew(unpack(self:listBuiltInIds(reminderType)))
    __TS__SparseArrayPush(
        ____array_1,
        unpack(self.addedSpells:listAdded(reminderType))
    )
    for ____, id in ipairs({__TS__SparseArraySpread(____array_1)}) do
        if not __TS__ArrayIncludes(ids, id) then
            ids[#ids + 1] = id
        end
    end
    return ids
end
function GlowCuesService.prototype.listCues(self, ids)
    local enabledSpells = self.settings:get("enabledSpells")
    local found = {}
    for ____, id in ipairs(ids) do
        do
            local __continue25
            repeat
                local learned = self.spells:resolve(self.addedSpells:getEffectiveId(id))
                if learned == nil or enabledSpells[tostring(id)] == false or not self.actionBars:isOnBars(learned) then
                    __continue25 = true
                    break
                end
                found[#found + 1] = learned
                __continue25 = true
            until true
            if not __continue25 then
                break
            end
        end
    end
    return found
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.added-reminders_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArraySome = ____lualib.__TS__ArraySome
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local isOutOfItem = ____wow.isOutOfItem
____exports.AddedRemindersService = __TS__Class()
local AddedRemindersService = ____exports.AddedRemindersService
AddedRemindersService.name = "AddedRemindersService"
function AddedRemindersService.prototype.____constructor(self, addedSpells, spells, actionBars, buffState, weaponEnchants, bags, settings, reagents, fedBuffs)
    self.addedSpells = addedSpells
    self.spells = spells
    self.actionBars = actionBars
    self.buffState = buffState
    self.weaponEnchants = weaponEnchants
    self.bags = bags
    self.settings = settings
    self.reagents = reagents
    self.fedBuffs = fedBuffs
end
function AddedRemindersService.prototype.findMissingBuffs(self)
    local ids = self:listOnBars("missingBuff")
    local missingFed = self.fedBuffs:findMissing(__TS__ArrayFilter(
        ids,
        function(____, id) return self.fedBuffs:isFedSpell(id) end
    ))
    return __TS__ArrayFilter(
        ids,
        function(____, id)
            local ____table_fedBuffs_isFedSpell_result_0
            if self.fedBuffs:isFedSpell(id) then
                ____table_fedBuffs_isFedSpell_result_0 = __TS__ArrayIncludes(missingFed, id)
            else
                ____table_fedBuffs_isFedSpell_result_0 = not self.buffState:hasAura(id)
            end
            return ____table_fedBuffs_isFedSpell_result_0
        end
    )
end
function AddedRemindersService.prototype.findWeaponSpells(self)
    local spellIds = self:listOnBars("weaponBuff")
    if #spellIds == 0 then
        return {}
    end
    return self.weaponEnchants:getWeaponEnchant(false).has == false and spellIds or ({})
end
function AddedRemindersService.prototype.findReagentSpells(self)
    return __TS__ArrayFilter(
        self:listOnBars("lowReagent"),
        function(____, id)
            local reagent = self.reagents:findTooltipReagent(id)
            return reagent ~= nil and self.reagents:isLow(
                self.bags:getItemCountByName(reagent),
                "spell" .. string.format("%d", id)
            )
        end
    )
end
function AddedRemindersService.prototype.findLowReagents(self)
    local low = {}
    local enabledSpells = self.settings:get("enabledSpells")
    for ____, id in ipairs(self.addedSpells:listAdded("lowReagent")) do
        do
            local __continue11
            repeat
                local spellId = self.spells:resolve(id)
                local name = self.reagents:findTooltipReagent(id)
                if spellId == nil or name == nil or enabledSpells[string.format("%d", id)] == false then
                    __continue11 = true
                    break
                end
                local count = self.bags:getItemCountByName(name)
                local isLow = self.reagents:isLow(
                    count,
                    "spell" .. string.format("%d", id)
                )
                if isLow and not __TS__ArraySome(
                    low,
                    function(____, other) return other.name == name end
                ) then
                    low[#low + 1] = {spellId = spellId, name = name, count = count}
                end
                __continue11 = true
            until true
            if not __continue11 then
                break
            end
        end
    end
    return low
end
function AddedRemindersService.prototype.listOnBars(self, reminderType)
    local found = {}
    local enabledSpells = self.settings:get("enabledSpells")
    for ____, id in ipairs(self.addedSpells:listAdded(reminderType)) do
        do
            local __continue17
            repeat
                if enabledSpells[string.format("%d", id)] == false then
                    __continue17 = true
                    break
                end
                local learned = self.spells:resolve(id) or id
                local ____table_fedBuffs_isFedSpell_result_1
                if self.fedBuffs:isFedSpell(learned) then
                    ____table_fedBuffs_isFedSpell_result_1 = self.fedBuffs:isOnBarsWithSome(learned)
                else
                    ____table_fedBuffs_isFedSpell_result_1 = __TS__ArraySome(
                        self.actionBars:findButtonsOf(learned),
                        function(____, button) return not isOutOfItem(self.actionBars, button) end
                    )
                end
                local isOnBars = ____table_fedBuffs_isFedSpell_result_1
                if isOnBars then
                    found[#found + 1] = learned
                end
                __continue17 = true
            until true
            if not __continue17 then
                break
            end
        end
    end
    return found
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.low-stock_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local getItemButtonKey = ____wow.getItemButtonKey
____exports.LowStockService = __TS__Class()
local LowStockService = ____exports.LowStockService
LowStockService.name = "LowStockService"
function LowStockService.prototype.____constructor(self, addedSpells, bags, limits, settings)
    self.addedSpells = addedSpells
    self.bags = bags
    self.limits = limits
    self.settings = settings
end
function LowStockService.prototype.findLowStock(self)
    if not self.settings:get("isLowStockEnabled") then
        return {}
    end
    local low = {}
    local enabledSpells = self.settings:get("enabledSpells")
    for ____, itemId in ipairs(self.addedSpells:listAdded("lowStock")) do
        do
            local __continue5
            repeat
                local key = getItemButtonKey(itemId)
                if enabledSpells[string.format("%d", key)] == false then
                    __continue5 = true
                    break
                end
                local count = self.bags:getItemCount(itemId)
                if count < self.limits:getLimit(
                    "lowStock",
                    string.format("%d", itemId)
                ) then
                    low[#low + 1] = {
                        key = key,
                        itemId = itemId,
                        name = self.bags:getItemName(itemId) or string.format("%d", itemId),
                        count = count
                    }
                end
                __continue5 = true
            until true
            if not __continue5 then
                break
            end
        end
    end
    return low
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.seal-reminder_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local Paladin = ____wow_2Ddata.Paladin
--- The seals, in the order the table lists them (their wow-data IDs).
____exports.SEALS = {
    Paladin.SealOfRighteousness,
    Paladin.SealOfCommand,
    Paladin.SealOfTheCrusader,
    Paladin.SealOfWisdom,
    Paladin.SealOfLight,
    Paladin.SealOfJustice,
    Paladin.SealOfFury
}
--- A seal's reminder comes this many seconds before it runs out: one global cooldown, to cast the next in time.
local SEAL_LEAD = 1.5
--- The seal each talent tree (1 Holy, 2 Protection, 3 Retribution) wants first, before the player has cast one.
local TALENT_SEALS = {[1] = {Paladin.SealOfWisdom, Paladin.SealOfLight}, [2] = {Paladin.SealOfRighteousness}, [3] = {Paladin.SealOfCommand, Paladin.SealOfRighteousness}}
--- The key of the seal cast last in the saved settings.
local LAST_SEAL_KEY = "missingSeal"
____exports.SealReminderService = __TS__Class()
local SealReminderService = ____exports.SealReminderService
SealReminderService.name = "SealReminderService"
function SealReminderService.prototype.____constructor(self, spells, actionBars, buffState, player, settings, addedSpells)
    self.spells = spells
    self.actionBars = actionBars
    self.buffState = buffState
    self.player = player
    self.settings = settings
    self.addedSpells = addedSpells
end
function SealReminderService.prototype.listSeals(self)
    return __TS__ArrayFilter(
        ____exports.SEALS,
        function(____, id) return self.spells:resolve(id) ~= nil end
    )
end
function SealReminderService.prototype.listAllSeals(self)
    local ____array_0 = __TS__SparseArrayNew(unpack(self:listSeals()))
    __TS__SparseArrayPush(
        ____array_0,
        unpack(self.addedSpells:listAdded("missingSeal"))
    )
    return {__TS__SparseArraySpread(____array_0)}
end
function SealReminderService.prototype.noteCast(self, cast)
    if cast.spellId == nil then
        return
    end
    local id = self.spells:resolveOrSame(cast.spellId)
    local castName = self.spells:getSpellName(id)
    local listId = __TS__ArrayFind(
        self:listAllSeals(),
        function(____, sealId) return (self.spells:resolve(sealId) or sealId) == id or self.spells:getSpellName(sealId) == castName end
    )
    local lastBuffs = self.settings:get("lastBuffs")
    if listId ~= nil and lastBuffs[LAST_SEAL_KEY] ~= listId then
        self.settings:change(
            "lastBuffs",
            __TS__ObjectAssign({}, lastBuffs, {[LAST_SEAL_KEY] = listId})
        )
    end
end
__TS__DecorateLegacy(
    {OnEvent("player.spell-cast")},
    SealReminderService.prototype,
    "noteCast",
    true
)
function SealReminderService.prototype.findMissingSeal(self)
    if not self.settings:get("isMissingSealEnabled") then
        return {}
    end
    local enabledSpells = self.settings:get("enabledSpells")
    local onBars = {}
    for ____, listId in ipairs(self:listAllSeals()) do
        local id = self.spells:resolve(listId) or listId
        if self.buffState:hasAura(id, SEAL_LEAD) then
            return {}
        end
        if enabledSpells[string.format("%d", listId)] ~= false and self.actionBars:isOnBars(id) then
            onBars[#onBars + 1] = listId
        end
    end
    local picked = self:pickSeal(onBars)
    return picked ~= nil and ({self.spells:resolve(picked) or picked}) or ({})
end
function SealReminderService.prototype.pickSeal(self, onBars)
    local last = self.settings:get("lastBuffs")[LAST_SEAL_KEY]
    if last ~= nil and __TS__ArrayIncludes(onBars, last) then
        return last
    end
    local tree = self.player:findMainTalentTree()
    for ____, id in ipairs(tree ~= nil and (TALENT_SEALS[tree] or ({})) or ({})) do
        if __TS__ArrayIncludes(onBars, id) then
            return id
        end
    end
    return onBars[1]
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.tracking-reminder_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____wow_2Ddata = require("packages.@wowkit.wow-data.src.index")
local Tracking = ____wow_2Ddata.Tracking
--- The trackings of the gathering professions, in the order the table lists them (their wow-data IDs).
____exports.GATHERING_TRACKINGS = {Tracking.FindMinerals, Tracking.FindHerbs}
____exports.TrackingReminderService = __TS__Class()
local TrackingReminderService = ____exports.TrackingReminderService
TrackingReminderService.name = "TrackingReminderService"
function TrackingReminderService.prototype.____constructor(self, spells, actionBars, buffState, settings, addedSpells)
    self.spells = spells
    self.actionBars = actionBars
    self.buffState = buffState
    self.settings = settings
    self.addedSpells = addedSpells
end
function TrackingReminderService.prototype.listTrackings(self)
    return __TS__ArrayFilter(
        ____exports.GATHERING_TRACKINGS,
        function(____, id) return self.spells:resolve(id) ~= nil end
    )
end
function TrackingReminderService.prototype.findMissingTrackings(self)
    if not self.settings:get("isMissingTrackingEnabled") then
        return {}
    end
    local enabledSpells = self.settings:get("enabledSpells")
    local onBars = {}
    local ____array_0 = __TS__SparseArrayNew(unpack(self:listTrackings()))
    __TS__SparseArrayPush(
        ____array_0,
        unpack(self.addedSpells:listAdded("missingTracking"))
    )
    for ____, listId in ipairs({__TS__SparseArraySpread(____array_0)}) do
        local id = self.spells:resolve(listId) or listId
        if self.buffState:hasAura(id) then
            return {}
        end
        if enabledSpells[string.format("%d", listId)] ~= false and self.actionBars:isOnBars(id) then
            onBars[#onBars + 1] = id
        end
    end
    return onBars
end
return ____exports
 end,
["addons.glowing-bars.src.reminders.party-buffs_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayFlatMap = ____lualib.__TS__ArrayFlatMap
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ArrayPushArray = ____lualib.__TS__ArrayPushArray
local ____exports = {}
local ____class_2Dbuffs_2Econstants = require("addons.glowing-bars.src.reminders.class-buffs_constants")
local PARTY_BLESSINGS = ____class_2Dbuffs_2Econstants.PARTY_BLESSINGS
local WEAPON_MANA_CLASSES = ____class_2Dbuffs_2Econstants.WEAPON_MANA_CLASSES
--- Party auras are read at most this often.
local REFRESH_SECONDS = 1
____exports.PartyBuffsService = __TS__Class()
local PartyBuffsService = ____exports.PartyBuffsService
PartyBuffsService.name = "PartyBuffsService"
function PartyBuffsService.prototype.____constructor(self, auras, spells, clock, party, player, classBuffs, reagents, settings, buffReminder)
    self.auras = auras
    self.spells = spells
    self.clock = clock
    self.party = party
    self.player = player
    self.classBuffs = classBuffs
    self.reagents = reagents
    self.settings = settings
    self.buffReminder = buffReminder
    self.cachedAt = -10
    self.cached = {}
end
function PartyBuffsService.prototype.findPartyBuffSuggestions(self)
    local isInRaid = self.party:isInRaid()
    if self.wasInRaid ~= nil and self.wasInRaid ~= isInRaid then
        self:forgetGivenBlessings()
        self.cachedAt = -10
    end
    self.wasInRaid = isInRaid
    if not self.settings:get(isInRaid and "showRaidBuffs" or "showPartyBuffs") or self.player:isInCombat() then
        return {}
    end
    local now = self.clock:getCurrentTime()
    if now - self.cachedAt < REFRESH_SECONDS then
        return self.cached
    end
    self.cachedAt = now
    local others = __TS__ArrayMap(
        __TS__ArrayFilter(
            isInRaid and self.party:getRaidUnits() or self.party:getPartyUnits(),
            function(____, unit) return self.party:isReachable(unit) end
        ),
        function(____, unit) return __TS__ObjectAssign(
            {unit = unit},
            self.party:getUnitIdentity(unit)
        ) end
    )
    local ____array_0 = __TS__SparseArrayNew(unpack(others))
    __TS__SparseArrayPush(
        ____array_0,
        __TS__ObjectAssign(
            {unit = "player"},
            self.party:getUnitIdentity("player"),
            {isPlayer = true}
        )
    )
    local members = {__TS__SparseArraySpread(____array_0)}
    self.cached = #others == 0 and ({}) or __TS__ArrayFlatMap(
        self:listPartyGroups(),
        function(____, group) return self:buildGroupSuggestions(group, members, isInRaid) end
    )
    return self.cached
end
function PartyBuffsService.prototype.refreshPartyBuffs(self)
    self.cachedAt = -10
end
function PartyBuffsService.prototype.listPartyGroups(self)
    local groups = {}
    local groupOf = {}
    for ____, classBuff in ipairs(self.classBuffs:getClassBuffs()) do
        do
            local __continue12
            repeat
                if not classBuff.party or not self.classBuffs:isBuffEnabled(classBuff) or not self.spells:isLearned(classBuff.id) then
                    __continue12 = true
                    break
                end
                local category = classBuff.categoryMembers or classBuff
                local members = groupOf[category]
                if members == nil then
                    members = {}
                    groupOf[category] = members
                    groups[#groups + 1] = members
                end
                members[#members + 1] = classBuff
                __continue12 = true
            until true
            if not __continue12 then
                break
            end
        end
    end
    return groups
end
function PartyBuffsService.prototype.buildGroupSuggestions(self, group, members, isInRaid)
    if not group[1].party.isPerClass then
        return self:buildSuggestionsFor(
            self.classBuffs:pickGroupBuff(group),
            members,
            isInRaid
        )
    end
    self:noteGivenBlessings(
        group,
        __TS__ArrayFilter(
            members,
            function(____, member) return member.isPlayer ~= true end
        )
    )
    local buffs = {}
    local membersOf = {}
    for ____, member in ipairs(members) do
        do
            local __continue19
            repeat
                local buff = self:pickMemberBlessing(group, member, isInRaid)
                if buff == nil then
                    __continue19 = true
                    break
                end
                local list = membersOf[buff] or ({})
                if #list == 0 then
                    buffs[#buffs + 1] = buff
                end
                list[#list + 1] = member
                membersOf[buff] = list
                __continue19 = true
            until true
            if not __continue19 then
                break
            end
        end
    end
    return __TS__ArrayFlatMap(
        buffs,
        function(____, buff) return self:buildSuggestionsFor(buff, membersOf[buff], isInRaid) end
    )
end
function PartyBuffsService.prototype.forgetGivenBlessings(self)
    local lastBuffs = __TS__ObjectAssign(
        {},
        self.settings:get("lastBuffs")
    )
    local hasForgotten = false
    for ____, group in ipairs(self:listPartyGroups()) do
        local prefix = self:getClassKey(group, "")
        for key in pairs(lastBuffs) do
            if string.sub(key, 1, #prefix) == prefix then
                lastBuffs[key] = nil
                hasForgotten = true
            end
        end
    end
    if hasForgotten then
        self.settings:change("lastBuffs", lastBuffs)
    end
end
function PartyBuffsService.prototype.getClassKey(self, group, classToken)
    return (self.classBuffs:getGroupKey(group[1]) .. ":") .. classToken
end
function PartyBuffsService.prototype.noteGivenBlessings(self, group, members)
    local spellsOf = __TS__ArrayMap(
        group,
        function(____, buff)
            local ____buff_id_4 = buff.id
            local ____buff_id_3 = buff.id
            local ____opt_1 = buff.party
            return {
                ____buff_id_4,
                {
                    ____buff_id_3,
                    unpack(____opt_1 and ____opt_1.groupIds or ({}))
                }
            }
        end
    )
    for ____, member in ipairs(members) do
        local given = self.auras:findOwnUnitBuff(member.unit, spellsOf)
        local key = self:getClassKey(group, member.classToken)
        local lastBuffs = self.settings:get("lastBuffs")
        if given ~= nil and lastBuffs[key] ~= given then
            self.settings:change(
                "lastBuffs",
                __TS__ObjectAssign({}, lastBuffs, {[key] = given})
            )
        end
    end
end
function PartyBuffsService.prototype.pickMemberBlessing(self, group, member, isInRaid)
    if member.isPlayer == true then
        return self.classBuffs:pickGroupBuff(group)
    end
    local last = self.settings:get("lastBuffs")[self:getClassKey(group, member.classToken)]
    local shouldGetWisdom = self.party:doesUseMana(member.unit) and not __TS__ArrayIncludes(WEAPON_MANA_CLASSES, member.classToken)
    local order = isInRaid and ({}) or (shouldGetWisdom and PARTY_BLESSINGS.mana or PARTY_BLESSINGS.other)
    local ____array_5 = __TS__SparseArrayNew(unpack(last ~= nil and ({last}) or ({})))
    __TS__SparseArrayPush(
        ____array_5,
        unpack(order)
    )
    for ____, id in ipairs({__TS__SparseArraySpread(____array_5)}) do
        local found = __TS__ArrayFind(
            group,
            function(____, buff) return buff.id == id end
        )
        if found ~= nil then
            return found
        end
    end
    local ____isInRaid_6
    if isInRaid then
        ____isInRaid_6 = nil
    else
        ____isInRaid_6 = group[1]
    end
    return ____isInRaid_6
end
function PartyBuffsService.prototype.findUsableGroupSpell(self, classBuff)
    local ____opt_7 = classBuff.party
    local ranks = ____opt_7 and ____opt_7.groupIds or ({})
    do
        local i = #ranks - 1
        while i >= 0 do
            local id = ranks[i + 1]
            if self.spells:isLearned(id) then
                return self.reagents:hasReagentFor(id) and id or nil
            end
            i = i - 1
        end
    end
    return nil
end
function PartyBuffsService.prototype.buildSuggestionsFor(self, classBuff, members, isInRaid)
    local missing = __TS__ArrayFilter(
        members,
        function(____, member) return self:isMissing(classBuff, member) end
    )
    if #missing == 0 then
        return {}
    end
    local groupSpell = self:findUsableGroupSpell(classBuff)
    if groupSpell == nil then
        return self:buildSuggestion(classBuff, classBuff.id, missing)
    end
    local groupMin = self.settings:get(isInRaid and "raidGroupFrom" or "partyGroupFrom")
    if not classBuff.party.isPerClass then
        return self:buildSuggestion(
            classBuff,
            self:isGroupWorth(missing, groupMin) and groupSpell or classBuff.id,
            missing
        )
    end
    return self:buildGreaterSuggestions(classBuff, groupSpell, missing, groupMin)
end
function PartyBuffsService.prototype.isGroupWorth(self, missing, groupMin)
    return #missing >= groupMin and __TS__ArraySome(
        missing,
        function(____, member) return member.isPlayer ~= true end
    )
end
function PartyBuffsService.prototype.isMissing(self, classBuff, member)
    if member.isPlayer == true then
        return self.buffReminder:checkBuff(classBuff).isWanted
    end
    local party = classBuff.party
    return (not party.isManaOnly or self.party:doesUseMana(member.unit)) and self.party:isInSpellRange(classBuff.id, member.unit) and self.auras:getUnitBuffState(member.unit, classBuff.id, party.isOwnOnly == true) == "missing"
end
function PartyBuffsService.prototype.buildSuggestion(self, classBuff, spellId, missing)
    local isGroup = spellId ~= classBuff.id
    local names = __TS__ArrayMap(
        __TS__ArrayFilter(
            missing,
            function(____, member) return member.isPlayer ~= true end
        ),
        function(____, member) return member.name end
    )
    if not isGroup and #names == 0 then
        return {}
    end
    local isForPlayer = isGroup and __TS__ArraySome(
        missing,
        function(____, member) return member.isPlayer == true end
    )
    return {{
        spellId = spellId,
        names = names,
        buffId = self.spells:resolve(classBuff.id) or classBuff.id,
        isForPlayer = isForPlayer
    }}
end
function PartyBuffsService.prototype.buildGreaterSuggestions(self, classBuff, groupSpell, missing, groupMin)
    local byClass = {}
    for ____, member in ipairs(missing) do
        local list = byClass[member.classToken] or ({})
        list[#list + 1] = member
        byClass[member.classToken] = list
    end
    local out = {}
    local singles = {}
    for ____, list in pairs(byClass) do
        if self:isGroupWorth(list, groupMin) then
            __TS__ArrayPushArray(
                out,
                self:buildSuggestion(classBuff, groupSpell, list)
            )
        else
            __TS__ArrayPushArray(singles, list)
        end
    end
    __TS__ArrayPushArray(
        out,
        self:buildSuggestion(classBuff, classBuff.id, singles)
    )
    return out
end
return ____exports
 end,
["addons.glowing-bars.src.character.idle_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.IdleService = __TS__Class()
local IdleService = ____exports.IdleService
IdleService.name = "IdleService"
function IdleService.prototype.____constructor(self, player)
    self.player = player
end
function IdleService.prototype.shouldStayIdle(self, shouldStayQuietWhenResting)
    if self.player:isDead() or self.player:isOnTaxi() or self.player:isMounted() then
        return true
    end
    return shouldStayQuietWhenResting and not self.player:isInCombat() and self.player:isResting()
end
return ____exports
 end,
["addons.glowing-bars.src.tick.find-reminders_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
____exports.FindRemindersService = __TS__Class()
local FindRemindersService = ____exports.FindRemindersService
FindRemindersService.name = "FindRemindersService"
function FindRemindersService.prototype.____constructor(self, lowStock, actionBars, idle, player, spells, buffReminder, partyBuffs, weaponReminder, outdatedRanks, glowCues, reagents, addedReminders, sealReminder, trackingReminder, settings)
    self.lowStock = lowStock
    self.actionBars = actionBars
    self.idle = idle
    self.player = player
    self.spells = spells
    self.buffReminder = buffReminder
    self.partyBuffs = partyBuffs
    self.weaponReminder = weaponReminder
    self.outdatedRanks = outdatedRanks
    self.glowCues = glowCues
    self.reagents = reagents
    self.addedReminders = addedReminders
    self.sealReminder = sealReminder
    self.trackingReminder = trackingReminder
    self.settings = settings
end
function FindRemindersService.prototype.findReminders(self)
    self.buffReminder:rememberSelfBuffs()
    if self.idle:shouldStayIdle(false) or self.settings:get("isDisabled") then
        return self:createEmptyReminders()
    end
    local reagentSpells = self:findReagentSpells()
    local lowReagents = self:findLowReagents()
    local lowStock = self.lowStock:findLowStock()
    if self.idle:shouldStayIdle(self.settings:get("shouldStayQuietInTowns")) then
        return __TS__ObjectAssign(
            {},
            self:createEmptyReminders(),
            {reagentSpells = reagentSpells, lowReagents = lowReagents, lowStock = lowStock}
        )
    end
    local isMissingBuffEnabled = self.settings:get("isMissingBuffEnabled")
    local missingBuffs = isMissingBuffEnabled and self.buffReminder:findMissingBuffs() or ({glow = {}, notOnBars = {}})
    local partySuggestions = isMissingBuffEnabled and self.partyBuffs:findPartyBuffSuggestions() or ({})
    local ____table_settings_get_result_0
    if self.settings:get("isWeaponBuffEnabled") then
        ____table_settings_get_result_0 = self.weaponReminder:check()
    else
        ____table_settings_get_result_0 = nil
    end
    local weaponCheck = ____table_settings_get_result_0
    local ____array_1 = __TS__SparseArrayNew(unpack(self:findBuffsToCast(missingBuffs.glow, partySuggestions)))
    __TS__SparseArrayPush(
        ____array_1,
        unpack(isMissingBuffEnabled and self.addedReminders:findMissingBuffs() or ({}))
    )
    local ____temp_5 = {__TS__SparseArraySpread(____array_1)}
    local ____weaponCheck_isNeeded_4
    if weaponCheck and weaponCheck.isNeeded then
        ____weaponCheck_isNeeded_4 = weaponCheck.spellId
    else
        ____weaponCheck_isNeeded_4 = nil
    end
    return {
        buffsToCast = ____temp_5,
        weaponSpell = ____weaponCheck_isNeeded_4,
        addedWeaponSpells = self.settings:get("isWeaponBuffEnabled") and self.addedReminders:findWeaponSpells() or ({}),
        seals = self.sealReminder:findMissingSeal(),
        trackings = self.trackingReminder:findMissingTrackings(),
        buffsNotOnBars = missingBuffs.notOnBars,
        partySuggestions = partySuggestions,
        outdatedRanks = self.settings:get("isOldRankEnabled") and self.outdatedRanks:findOutdatedRanks() or ({}),
        readyCooldowns = self.glowCues:findReadyCooldowns(),
        procs = self.glowCues:findProcs(),
        reagentSpells = reagentSpells,
        lowReagents = lowReagents,
        lowStock = lowStock
    }
end
function FindRemindersService.prototype.findReagentSpells(self)
    if not self.settings:get("isLowReagentEnabled") then
        return {}
    end
    local enabledReagents = self.settings:get("enabledReagents")
    local listed = __TS__ArrayFilter(
        self.reagents:findSpellsWithLowReagent(function(reagent) return enabledReagents[tostring(reagent.itemId)] ~= false end),
        function(____, id) return self.actionBars:isOnBars(id) end
    )
    local ____array_6 = __TS__SparseArrayNew(unpack(listed))
    __TS__SparseArrayPush(
        ____array_6,
        unpack(self.addedReminders:findReagentSpells())
    )
    return {__TS__SparseArraySpread(____array_6)}
end
function FindRemindersService.prototype.findLowReagents(self)
    if not self.settings:get("isLowReagentEnabled") then
        return {}
    end
    local enabledReagents = self.settings:get("enabledReagents")
    local listed = self.reagents:findLowReagents(function(reagent) return enabledReagents[tostring(reagent.itemId)] ~= false end)
    local added = __TS__ArrayFilter(
        self.addedReminders:findLowReagents(),
        function(____, stock) return not __TS__ArraySome(
            listed,
            function(____, other) return other.name == stock.name end
        ) end
    )
    local ____array_7 = __TS__SparseArrayNew(unpack(listed))
    __TS__SparseArrayPush(
        ____array_7,
        unpack(added)
    )
    return {__TS__SparseArraySpread(____array_7)}
end
function FindRemindersService.prototype.findBuffsToCast(self, ownBuffs, partySuggestions)
    local buffs = {unpack(ownBuffs)}
    for ____, suggestion in ipairs(partySuggestions) do
        do
            local __continue16
            repeat
                if not self.actionBars:isOnBars(suggestion.spellId) or self.spells:isCastable(suggestion.spellId) == false then
                    __continue16 = true
                    break
                end
                if suggestion.isForPlayer then
                    buffs = __TS__ArrayFilter(
                        buffs,
                        function(____, id) return id ~= suggestion.buffId end
                    )
                end
                if not __TS__ArrayIncludes(buffs, suggestion.spellId) then
                    buffs[#buffs + 1] = suggestion.spellId
                end
                __continue16 = true
            until true
            if not __continue16 then
                break
            end
        end
    end
    return buffs
end
function FindRemindersService.prototype.createEmptyReminders(self)
    return {
        buffsToCast = {},
        weaponSpell = nil,
        addedWeaponSpells = {},
        seals = {},
        trackings = {},
        buffsNotOnBars = {},
        partySuggestions = {},
        outdatedRanks = {},
        readyCooldowns = {},
        reagentSpells = {},
        lowReagents = {},
        lowStock = {},
        procs = {}
    }
end
return ____exports
 end,
["addons.glowing-bars.src.tick.when-state"] = function(...) 
local ____exports = {}
--- For each When, does it hold now?
function ____exports.readWhenState(player)
    local isInCombat = player:isInCombat()
    return {
        always = true,
        inCombat = isInCombat,
        outOfCombat = not isInCombat,
        enemyTargeted = player:hasEnemyTarget(),
        townAlert = true
    }
end
return ____exports
 end,
["addons.glowing-bars.src.tick.reminder-filter"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- The reminders `isShown` keeps.
function ____exports.filterReminders(reminders, isShown)
    local function pickShown(reminderType, ids)
        return __TS__ArrayFilter(
            ids,
            function(____, id) return isShown(reminderType, id) end
        )
    end
    local weapon = reminders.weaponSpell
    return __TS__ObjectAssign(
        {},
        reminders,
        {
            buffsToCast = pickShown("missingBuff", reminders.buffsToCast),
            buffsNotOnBars = pickShown("missingBuff", reminders.buffsNotOnBars),
            partySuggestions = __TS__ArrayFilter(
                reminders.partySuggestions,
                function(____, suggestion) return isShown("missingBuff", suggestion.spellId) end
            ),
            weaponSpell = weapon ~= nil and isShown("weaponBuff", weapon) and weapon or nil,
            addedWeaponSpells = pickShown("weaponBuff", reminders.addedWeaponSpells),
            seals = pickShown("missingSeal", reminders.seals),
            trackings = pickShown("missingTracking", reminders.trackings),
            outdatedRanks = __TS__ArrayFilter(
                reminders.outdatedRanks,
                function(____, rank) return isShown("oldRank", rank.id) end
            ),
            lowStock = __TS__ArrayFilter(
                reminders.lowStock,
                function(____, stock) return isShown("lowStock", stock.key) end
            ),
            reagentSpells = pickShown("lowReagent", reminders.reagentSpells),
            lowReagents = __TS__ArrayFilter(
                reminders.lowReagents,
                function(____, stock) return isShown("lowReagent", stock.spellId) end
            ),
            readyCooldowns = pickShown("readyCooldown", reminders.readyCooldowns),
            procs = pickShown("proc", reminders.procs)
        }
    )
end
return ____exports
 end,
["addons.glowing-bars.src.tick.glow-schedule"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.GlowSchedule = __TS__Class()
local GlowSchedule = ____exports.GlowSchedule
GlowSchedule.name = "GlowSchedule"
function GlowSchedule.prototype.____constructor(self)
    self.dueSince = {}
    self.seen = {}
end
function GlowSchedule.prototype.startTick(self)
    for key in pairs(self.dueSince) do
        if not (self.seen[key] ~= nil) then
            self.dueSince[key] = nil
        end
    end
    self.seen = {}
end
function GlowSchedule.prototype.isShowing(self, key, style, now, isInTown, isStartingOver)
    self.seen[key] = true
    local isTownAlert = style.when == "townAlert"
    local since = self.dueSince[key]
    if since == nil or isStartingOver then
        since = now
        self.dueSince[key] = since
    end
    if style.glowTime == 0 then
        return true
    end
    local elapsed = now - since
    if elapsed < style.glowTime then
        return true
    end
    local ____repeat = isTownAlert and not isInTown and 0 or style["repeat"]
    return ____repeat > 0 and elapsed % ____repeat < style.glowTime
end
return ____exports
 end,
["addons.glowing-bars.src.tick.tick_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local Interval = ____core.Interval
local ____when_2Dstate = require("addons.glowing-bars.src.tick.when-state")
local readWhenState = ____when_2Dstate.readWhenState
local ____reminder_2Dfilter = require("addons.glowing-bars.src.tick.reminder-filter")
local filterReminders = ____reminder_2Dfilter.filterReminders
local ____glow_2Dschedule = require("addons.glowing-bars.src.tick.glow-schedule")
local GlowSchedule = ____glow_2Dschedule.GlowSchedule
____exports.TickService = __TS__Class()
local TickService = ____exports.TickService
TickService.name = "TickService"
function TickService.prototype.____constructor(self, finder, shower, player, styles, clock)
    self.finder = finder
    self.shower = shower
    self.player = player
    self.styles = styles
    self.clock = clock
    self.isRunning = false
    self.schedule = __TS__New(GlowSchedule)
    self.wasInTown = false
    self.wasInCombat = false
end
function TickService.prototype.onFirstLogin(self)
    self.isRunning = true
end
function TickService.prototype.onLogout(self)
    self.isRunning = false
end
function TickService.prototype.onReady(self)
    self:tick()
end
function TickService.prototype.tick(self)
    if not self.isRunning then
        return
    end
    self.shower:showReminders(self:filterShowing(self.finder:findReminders()))
end
__TS__DecorateLegacy(
    {Interval(200)},
    TickService.prototype,
    "tick",
    true
)
function TickService.prototype.filterShowing(self, reminders)
    local now = readWhenState(self.player)
    local byWhen = filterReminders(
        reminders,
        function(reminderType, id) return now[self.styles:getStyle(reminderType, id).when] end
    )
    local time = self.clock:getCurrentTime()
    local isInTown = self.player:isResting()
    local hasArrivedInTown = isInTown and not self.wasInTown
    self.wasInTown = isInTown
    local hasFightStarted = now.inCombat and not self.wasInCombat
    self.wasInCombat = now.inCombat
    self.schedule:startTick()
    return __TS__ObjectAssign(
        {},
        filterReminders(
            byWhen,
            function(reminderType, id)
                local style = self.styles:getStyle(reminderType, id)
                local isStartingOver = style.when == "townAlert" and hasArrivedInTown or reminderType == "readyCooldown" and hasFightStarted
                return self.schedule:isShowing(
                    (reminderType .. ":") .. tostring(id),
                    style,
                    time,
                    isInTown,
                    isStartingOver
                )
            end
        ),
        {isInTown = isInTown}
    )
end
return ____exports
 end,
["addons.glowing-bars.src.tick.refresh_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local OnGameEvent = ____core.OnGameEvent
____exports.RefreshService = __TS__Class()
local RefreshService = ____exports.RefreshService
RefreshService.name = "RefreshService"
function RefreshService.prototype.____constructor(self, ticker, shower, auras, clock, barRefresh)
    self.ticker = ticker
    self.shower = shower
    self.auras = auras
    self.clock = clock
    self.barRefresh = barRefresh
    self.isTickQueued = false
end
function RefreshService.prototype.requestTick(self)
    self.shower:markGlowsStale()
    if self.isTickQueued then
        return
    end
    self.isTickQueued = true
    self.clock:runAfter(
        0,
        function()
            self.isTickQueued = false
            self.ticker:tick()
        end
    )
end
__TS__DecorateLegacy(
    {OnEvent("bars.mapped", "spells.refreshed")},
    RefreshService.prototype,
    "requestTick",
    true
)
function RefreshService.prototype.requestTickForBags(self)
    self:requestTick()
end
__TS__DecorateLegacy(
    {OnGameEvent("BAG_UPDATE_DELAYED")},
    RefreshService.prototype,
    "requestTickForBags",
    true
)
function RefreshService.prototype.requestTickForWhen(self)
    self:requestTick()
end
__TS__DecorateLegacy(
    {OnGameEvent("PLAYER_TARGET_CHANGED", "PLAYER_REGEN_DISABLED")},
    RefreshService.prototype,
    "requestTickForWhen",
    true
)
function RefreshService.prototype.requestTickWithFreshAuras(self)
    self.auras:wipeAuraScans()
    self:requestTick()
end
__TS__DecorateLegacy(
    {OnGameEvent(
        "PLAYER_UPDATE_RESTING",
        "ZONE_CHANGED_NEW_AREA",
        "PLAYER_ALIVE",
        "PLAYER_UNGHOST",
        "PLAYER_MOUNT_DISPLAY_CHANGED",
        "PLAYER_DEAD",
        "PLAYER_REGEN_ENABLED"
    )},
    RefreshService.prototype,
    "requestTickWithFreshAuras",
    true
)
function RefreshService.prototype.noteShapeshift(self)
    self.auras:noteFormChange()
    self.barRefresh:scheduleBarRemap()
end
__TS__DecorateLegacy(
    {OnGameEvent("UPDATE_SHAPESHIFT_FORM")},
    RefreshService.prototype,
    "noteShapeshift",
    true
)
return ____exports
 end,
["addons.glowing-bars.src.character.aura-watch_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local OnUnitEvent = ____core.OnUnitEvent
____exports.AuraWatchService = __TS__Class()
local AuraWatchService = ____exports.AuraWatchService
AuraWatchService.name = "AuraWatchService"
function AuraWatchService.prototype.____constructor(self, refresh, auras, weaponReminder)
    self.refresh = refresh
    self.auras = auras
    self.weaponReminder = weaponReminder
end
function AuraWatchService.prototype.wipeScan(self, unit)
    self.auras:wipeAuraScan(unit)
end
__TS__DecorateLegacy(
    {OnUnitEvent("UNIT_AURA")},
    AuraWatchService.prototype,
    "wipeScan",
    true
)
function AuraWatchService.prototype.noteCast(self, cast)
    self.auras:noteSelfBuff(cast.spellId)
    self.weaponReminder:noteCast(cast.spellId, cast.spellName)
    self.auras:wipeAuraScan("player")
    self.refresh:requestTick()
end
__TS__DecorateLegacy(
    {OnEvent("player.spell-cast")},
    AuraWatchService.prototype,
    "noteCast",
    true
)
return ____exports
 end,
["addons.glowing-bars.src.character.blocked-action_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnGameEvent = ____core.OnGameEvent
local contains = ____core.contains
____exports.BlockedActionService = __TS__Class()
local BlockedActionService = ____exports.BlockedActionService
BlockedActionService.name = "BlockedActionService"
function BlockedActionService.prototype.____constructor(self, addonName, player, messages, locale)
    self.addonName = addonName
    self.player = player
    self.messages = messages
    self.locale = locale
end
function BlockedActionService.prototype.noteBlockedAction(self, addon, action)
    local text = (tostring(addon) .. " | ") .. tostring(action)
    if not contains(text, self.addonName) then
        return
    end
    local described = (text .. " | ") .. (self.player:isInCombat() and "inCombat" or "no combat")
    self.messages:say(string.format(
        self.locale:getText("BLOCKED_ACTION"),
        described
    ))
end
__TS__DecorateLegacy(
    {OnGameEvent("ADDON_ACTION_BLOCKED", "ADDON_ACTION_FORBIDDEN")},
    BlockedActionService.prototype,
    "noteBlockedAction",
    true
)
return ____exports
 end,
["addons.glowing-bars.src.character.equipment_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnGameEvent = ____core.OnGameEvent
local OnUnitEvent = ____core.OnUnitEvent
local ____wow = require("packages.@wowkit.wow.src.index")
local MAIN_HAND_SLOT = ____wow.MAIN_HAND_SLOT
local OFF_HAND_SLOT = ____wow.OFF_HAND_SLOT
____exports.EquipmentService = __TS__Class()
local EquipmentService = ____exports.EquipmentService
EquipmentService.name = "EquipmentService"
function EquipmentService.prototype.____constructor(self, refresh, player, enchants, weaponReminder)
    self.refresh = refresh
    self.player = player
    self.enchants = enchants
    self.weaponReminder = weaponReminder
end
function EquipmentService.prototype.onReady(self)
    self.mainHandItem = self.player:getEquippedItemId(MAIN_HAND_SLOT)
    self.offHandItem = self.player:getEquippedItemId(OFF_HAND_SLOT)
end
function EquipmentService.prototype.noteEquipmentChange(self, slot)
    if slot == MAIN_HAND_SLOT or slot == OFF_HAND_SLOT then
        local itemId = self.player:getEquippedItemId(slot)
        local ____temp_0
        if slot == MAIN_HAND_SLOT then
            ____temp_0 = self.mainHandItem
        else
            ____temp_0 = self.offHandItem
        end
        local previousItemId = ____temp_0
        if itemId ~= previousItemId then
            if slot == MAIN_HAND_SLOT then
                self.mainHandItem = itemId
            else
                self.offHandItem = itemId
            end
            self.weaponReminder:clearMemory()
        end
        self.enchants:clearWeaponTooltipCache()
    end
    self.refresh:requestTick()
end
__TS__DecorateLegacy(
    {OnGameEvent("PLAYER_EQUIPMENT_CHANGED")},
    EquipmentService.prototype,
    "noteEquipmentChange",
    true
)
function EquipmentService.prototype.noteInventoryChange(self)
    self.enchants:clearWeaponTooltipCache()
    self.refresh:requestTick()
end
__TS__DecorateLegacy(
    {OnUnitEvent("UNIT_INVENTORY_CHANGED")},
    EquipmentService.prototype,
    "noteInventoryChange",
    true
)
function EquipmentService.prototype.noteEnchantChange(self)
    self.enchants:clearWeaponTooltipCache()
    self.weaponReminder:noteEnchantChanged()
    self.refresh:requestTick()
end
__TS__DecorateLegacy(
    {OnGameEvent("WEAPON_ENCHANT_CHANGED")},
    EquipmentService.prototype,
    "noteEnchantChange",
    true
)
return ____exports
 end,
["addons.glowing-bars.src.character.roster_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnGameEvent = ____core.OnGameEvent
____exports.RosterService = __TS__Class()
local RosterService = ____exports.RosterService
RosterService.name = "RosterService"
function RosterService.prototype.____constructor(self, refresh, partyBuffs)
    self.refresh = refresh
    self.partyBuffs = partyBuffs
end
function RosterService.prototype.updateParty(self)
    self.partyBuffs:refreshPartyBuffs()
    self.refresh:requestTick()
end
__TS__DecorateLegacy(
    {OnGameEvent("GROUP_ROSTER_UPDATE")},
    RosterService.prototype,
    "updateParty",
    true
)
return ____exports
 end,
["addons.glowing-bars.src.options.reminder-controls_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____settings_2Econstants = require("addons.glowing-bars.src.settings.settings_constants")
local GROUP_FROM_CHOICES = ____settings_2Econstants.GROUP_FROM_CHOICES
____exports.ReminderControlsService = __TS__Class()
local ReminderControlsService = ____exports.ReminderControlsService
ReminderControlsService.name = "ReminderControlsService"
function ReminderControlsService.prototype.____constructor(self, controls, locale, settings)
    self.controls = controls
    self.locale = locale
    self.settings = settings
end
function ReminderControlsService.prototype.addHeader(self, layout, label)
    self.controls:addHeader(
        layout,
        self.locale:getText(label)
    )
end
function ReminderControlsService.prototype.addSwitch(self, category, key, label, tooltip)
    return self.controls:addSwitchCheckbox(
        category,
        key,
        self.locale:getText(label),
        self.locale:getText(tooltip)
    )
end
function ReminderControlsService.prototype.addGroupMin(self, category, key, tooltip, parent, parentKey)
    local initializer = self.controls:addDropdown(
        category,
        key,
        self.locale:getText("OPT_GROUP_FROM"),
        self.locale:getText(tooltip),
        string.format(
            "%d",
            self.settings:getDefault(key)
        ),
        function() return string.format(
            "%d",
            self.settings:get(key)
        ) end,
        function(value) return self.settings:change(
            key,
            tonumber(value) or self.settings:getDefault(key)
        ) end,
        function() return __TS__ArrayMap(
            GROUP_FROM_CHOICES,
            function(____, count) return {
                string.format("%d", count),
                string.format(
                    self.locale:getText(count == 1 and "OPT_MEMBER_MISSING" or "OPT_MEMBERS_MISSING"),
                    count
                )
            } end
        ) end,
        true
    )
    initializer:SetParentInitializer(
        parent,
        function() return self.settings:get(parentKey) end
    )
end
return ____exports
 end,
["addons.glowing-bars.src.options.bars_section"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____settings_2Econstants = require("addons.glowing-bars.src.settings.settings_constants")
local FADED_OPACITY_CHOICES = ____settings_2Econstants.FADED_OPACITY_CHOICES
--- The bars of the game, numbered as Edit Mode numbers them.
local BAR_COUNT = 8
____exports.BarsSection = __TS__Class()
local BarsSection = ____exports.BarsSection
BarsSection.name = "BarsSection"
function BarsSection.prototype.____constructor(self, locale, settings, controls, reminderControls)
    self.locale = locale
    self.settings = settings
    self.controls = controls
    self.reminderControls = reminderControls
end
function BarsSection.prototype.addBarsSection(self, category, layout)
    self.reminderControls:addHeader(layout, "HDR_BARS")
    do
        local bar = 1
        while bar <= BAR_COUNT do
            local key = string.format("%d", bar)
            self.controls:addCheckbox(
                category,
                "bar_" .. key,
                string.format(
                    self.locale:getText("OPT_BAR"),
                    bar
                ),
                self.locale:getText("TIP_BAR"),
                true,
                function() return self.settings:get("barsThatGlow")[key] ~= false end,
                function(isChecked) return self:setBarOn(key, isChecked) end
            )
            bar = bar + 1
        end
    end
end
function BarsSection.prototype.addFadedSection(self, category, layout)
    self.reminderControls:addHeader(layout, "HDR_FADED")
    do
        local bar = 1
        while bar <= BAR_COUNT do
            local key = string.format("%d", bar)
            self.controls:addCheckbox(
                category,
                "fade_" .. key,
                string.format(
                    self.locale:getText("OPT_BAR"),
                    bar
                ),
                self.locale:getText("TIP_FADE"),
                false,
                function() return self.settings:get("fadedBars")[key] == true end,
                function(isChecked) return self:setBarFaded(key, isChecked) end
            )
            bar = bar + 1
        end
    end
    self.controls:addDropdown(
        category,
        "fadedOpacity",
        self.locale:getText("OPT_FADED_OPACITY"),
        self.locale:getText("TIP_FADED_OPACITY"),
        string.format(
            "%d",
            self.settings:getDefault("fadedOpacity")
        ),
        function() return string.format(
            "%d",
            self.settings:get("fadedOpacity")
        ) end,
        function(value) return self.settings:change(
            "fadedOpacity",
            tonumber(value) or self.settings:getDefault("fadedOpacity")
        ) end,
        function() return __TS__ArrayMap(
            FADED_OPACITY_CHOICES,
            function(____, percent) return {
                string.format("%d", percent),
                string.format(
                    self.locale:getText("OPT_PERCENT"),
                    percent
                )
            } end
        ) end,
        true
    )
end
function BarsSection.prototype.setBarFaded(self, key, isFaded)
    local fadedBars = __TS__ObjectAssign(
        {},
        self.settings:get("fadedBars")
    )
    local ____key_1 = key
    local ____isFaded_0
    if isFaded then
        ____isFaded_0 = true
    else
        ____isFaded_0 = nil
    end
    fadedBars[____key_1] = ____isFaded_0
    self.settings:change("fadedBars", fadedBars)
end
function BarsSection.prototype.setBarOn(self, key, isOn)
    local barsThatGlow = __TS__ObjectAssign(
        {},
        self.settings:get("barsThatGlow")
    )
    local ____key_3 = key
    local ____isOn_2
    if isOn then
        ____isOn_2 = nil
    else
        ____isOn_2 = false
    end
    barsThatGlow[____key_3] = ____isOn_2
    self.settings:change("barsThatGlow", barsThatGlow)
end
return ____exports
 end,
["addons.glowing-bars.src.options.animation_section"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
--- The words of each style (the table's Animation column says them too).
____exports.ANIMATION_TEXTS = {circling = "ANIMATION_CIRCLING", breathing = "ANIMATION_BREATHING", none = "ANIMATION_NONE"}
____exports.AnimationSection = __TS__Class()
local AnimationSection = ____exports.AnimationSection
AnimationSection.name = "AnimationSection"
function AnimationSection.prototype.____constructor(self, locale, settings, controls)
    self.locale = locale
    self.settings = settings
    self.controls = controls
end
function AnimationSection.prototype.addAnimationSection(self, category)
    local styles = {"breathing", "none"}
    local key = "roundAnimation"
    self.controls:addDropdown(
        category,
        key,
        self.locale:getText("OPT_ROUND_ANIMATION"),
        self.locale:getText("TIP_ROUND_ANIMATION"),
        self.settings:getDefault(key),
        function() return self.settings:get(key) end,
        function(value) return self.settings:change(
            key,
            __TS__ArrayIncludes(styles, value) and value or self.settings:getDefault(key)
        ) end,
        function() return __TS__ArrayMap(
            styles,
            function(____, style) return {
                style,
                self.locale:getText(____exports.ANIMATION_TEXTS[style])
            } end
        ) end,
        false
    )
end
return ____exports
 end,
["addons.glowing-bars.src.options.glows_section"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.GlowsSection = __TS__Class()
local GlowsSection = ____exports.GlowsSection
GlowsSection.name = "GlowsSection"
function GlowsSection.prototype.____constructor(self, reminderControls, glowCues)
    self.reminderControls = reminderControls
    self.glowCues = glowCues
end
function GlowsSection.prototype.addGlowsSection(self, category, layout)
    if #self.glowCues:listCueIds("readyCooldown") == 0 then
        return
    end
    self.reminderControls:addHeader(layout, "HDR_COOLDOWNS")
    self.reminderControls:addSwitch(category, "showCooldownsAtFightStart", "OPT_COOLDOWNS_FIGHT_START", "TIP_COOLDOWNS_FIGHT_START")
end
return ____exports
 end,
["addons.glowing-bars.src.options.id-tooltip_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.IdTooltipService = __TS__Class()
local IdTooltipService = ____exports.IdTooltipService
IdTooltipService.name = "IdTooltipService"
function IdTooltipService.prototype.____constructor(self, tooltips, settings, locale)
    self.tooltips = tooltips
    self.settings = settings
    self.locale = locale
end
function IdTooltipService.prototype.onAddonLoaded(self)
    self.tooltips:addSpellLines(function(spellId) return self:isOn() and string.format(
        self.locale:getText("TOOLTIP_SPELL_ID"),
        spellId
    ) or nil end)
    self.tooltips:addItemLines(function(itemId) return self:isOn() and string.format(
        self.locale:getText("TOOLTIP_ITEM_ID"),
        itemId
    ) or nil end)
    self.tooltips:addItemLines(function(itemId)
        if not self:isOn() then
            return nil
        end
        local useSpellId = self.tooltips:getUseSpellId(itemId)
        local ____temp_0
        if useSpellId == nil then
            ____temp_0 = nil
        else
            ____temp_0 = string.format(
                self.locale:getText("TOOLTIP_USE_SPELL_ID"),
                useSpellId
            )
        end
        return ____temp_0
    end)
end
function IdTooltipService.prototype.isOn(self)
    return self.settings:get("showTooltipIds")
end
return ____exports
 end,
["addons.glowing-bars.src.options.style-table_constants"] = function(...) 
local ____exports = {}
____exports.WINDOW_NAME = "GlowingBarsLooks"
____exports.WINDOW_HEIGHT = 520
____exports.ROW_HEIGHT = 36
____exports.ICON_SIZE = 30
--- Every second row is tinted bronze, the color of the classic interface.
____exports.STRIPE_COLOR = {0.85, 0.62, 0.3}
____exports.STRIPE_ALPHA = 0.14
____exports.BRONZE_TEXT = {0.78, 0.62, 0.42}
____exports.HEADER_HEIGHT = 24
--- The small heading of a type in the list of spells.
____exports.TYPE_HEADING_HEIGHT = 20
--- The columns, side by side. The spell's name and its type read from the left of their column; every other control is
-- centered in its column, under its header, so the two check box columns line up the same way.
____exports.COLUMN = {
    icon = {x = 4, width = 34},
    name = {x = 38, width = 146},
    type = {x = 184, width = 86},
    id = {x = 270, width = 90},
    color = {x = 360, width = 56},
    glowPercent = {x = 416, width = 60},
    message = {x = 476, width = 66},
    sound = {x = 542, width = 130},
    ["repeat"] = {x = 672, width = 62},
    when = {x = 734, width = 108},
    glowTime = {x = 842, width = 76},
    animation = {x = 918, width = 86},
    belowLimits = {x = 1004, width = 56},
    enabled = {x = 1060, width = 66},
    actions = {x = 1126, width = 72}
}
--- The columns of the Basic view: the ones everybody needs. The others keep working, unseen.
____exports.BASIC_COLUMN = {
    icon = ____exports.COLUMN.icon,
    name = ____exports.COLUMN.name,
    type = ____exports.COLUMN.type,
    color = {x = 270, width = 56},
    message = {x = 326, width = 66},
    sound = {x = 392, width = 130},
    belowLimits = {x = 522, width = 56},
    enabled = {x = 578, width = 66},
    actions = {x = 644, width = 72}
}
--- Where the columns of a view are.
function ____exports.findColumns(isAdvanced)
    return isAdvanced and ____exports.COLUMN or ____exports.BASIC_COLUMN
end
--- A row is as wide as its columns.
____exports.TABLE_WIDTH = ____exports.COLUMN.actions.x + ____exports.COLUMN.actions.width
____exports.TABLE_LEFT = 28
--- The window around a table this wide: a margin inside its border on the left, the scroll bar on the right.
function ____exports.findWindowWidth(tableWidth)
    return ____exports.TABLE_LEFT + tableWidth + 34
end
--- Where a control of this width starts to sit in the middle of its column.
function ____exports.findCenteredX(column, controlWidth)
    return column.x + (column.width - controlWidth) / 2
end
--- The name of an overridden spell, against the gray of one that follows its type.
____exports.OVERRIDDEN_COLOR = {1, 0.82, 0}
--- The window border: the silver dialog art, tinted bronze.
____exports.BORDER_COLOR = {0.85, 0.6, 0.3}
return ____exports
 end,
["addons.glowing-bars.src.options.style-rows_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local ____wow = require("packages.@wowkit.wow.src.index")
local getItemButtonKey = ____wow.getItemButtonKey
local readItemLook = ____wow.readItemLook
local ____settings_2Econstants = require("addons.glowing-bars.src.settings.settings_constants")
local ADDABLE_TYPES = ____settings_2Econstants.ADDABLE_TYPES
local TYPE_ORDER = ____settings_2Econstants.TYPE_ORDER
--- The words that name each type of reminder.
____exports.TYPE_TEXTS = {
    missingBuff = "TYPE_MISSING_BUFF",
    weaponBuff = "TYPE_WEAPON_BUFF",
    missingSeal = "TYPE_MISSING_SEAL",
    missingTracking = "TYPE_MISSING_TRACKING",
    readyCooldown = "TYPE_READY_COOLDOWN",
    proc = "TYPE_PROC",
    oldRank = "TYPE_OLD_RANK",
    lowReagent = "TYPE_LOW_REAGENT",
    lowStock = "TYPE_LOW_STOCK"
}
____exports.StyleRowsService = __TS__Class()
local StyleRowsService = ____exports.StyleRowsService
StyleRowsService.name = "StyleRowsService"
function StyleRowsService.prototype.____constructor(self, player, spells, classBuffs, weaponChoice, reagents, locale, styles, glowCues, addedSpells, sealReminder, trackingReminder, fedBuffs)
    self.player = player
    self.spells = spells
    self.classBuffs = classBuffs
    self.weaponChoice = weaponChoice
    self.reagents = reagents
    self.locale = locale
    self.styles = styles
    self.glowCues = glowCues
    self.addedSpells = addedSpells
    self.sealReminder = sealReminder
    self.trackingReminder = trackingReminder
    self.fedBuffs = fedBuffs
end
function StyleRowsService.prototype.listTypeRows(self, spellRows)
    return __TS__ArrayMap(
        __TS__ArrayFilter(
            TYPE_ORDER,
            function(____, reminderType) return __TS__ArraySome(
                spellRows,
                function(____, row) return row.reminderType == reminderType end
            ) end
        ),
        function(____, reminderType) return {
            reminderType = reminderType,
            spellId = nil,
            label = self.locale:getText(____exports.TYPE_TEXTS[reminderType]),
            iconId = nil
        } end
    )
end
function StyleRowsService.prototype.isSharingName(self, spellId)
    return self.fedBuffs:isFedSpell(spellId)
end
function StyleRowsService.prototype.readLook(self, spellId, name, isAdded)
    local ____isAdded_0
    if isAdded then
        ____isAdded_0 = self.fedBuffs:findItemLook(spellId)
    else
        ____isAdded_0 = nil
    end
    local item = ____isAdded_0
    local ____temp_8 = isAdded and self:isSharingName(spellId) and string.format("%d", spellId) or name
    local ____temp_9 = item and item.name or self.spells:getSpellLabel(spellId) or name
    local ____temp_7 = item and item.iconId
    if ____temp_7 == nil then
        local ____opt_5 = self.spells:getSpellInfo(spellId)
        ____temp_7 = ____opt_5 and ____opt_5.iconID
    end
    return {key = ____temp_8, label = ____temp_9, iconId = ____temp_7}
end
function StyleRowsService.prototype.listAddedRows(self)
    local added = {}
    for ____, reminderType in ipairs(ADDABLE_TYPES) do
        for ____, id in ipairs(self.addedSpells:listAdded(reminderType)) do
            do
                local __continue11
                repeat
                    if reminderType ~= "lowStock" then
                        added[#added + 1] = {reminderType = reminderType, id = id, extra = {isAdded = true}}
                        __continue11 = true
                        break
                    end
                    local ____readItemLook_result_10 = readItemLook(id)
                    local name = ____readItemLook_result_10.name
                    local iconId = ____readItemLook_result_10.iconId
                    local extra = {
                        isAdded = true,
                        itemId = id,
                        label = name or string.format("%d", id),
                        iconId = iconId
                    }
                    added[#added + 1] = {
                        reminderType = reminderType,
                        id = getItemButtonKey(id),
                        extra = extra
                    }
                    __continue11 = true
                until true
                if not __continue11 then
                    break
                end
            end
        end
    end
    return added
end
function StyleRowsService.prototype.listSpellRows(self)
    local rows = {}
    local keys = {}
    --- A spell is listed once, unless `suffix` tells two rows of one name apart (the ranks of a group buff with their reagents).
    local function add(reminderType, spellId, extra, suffix)
        if extra == nil then
            extra = {}
        end
        if spellId == nil then
            return
        end
        local name = self.styles:getSpellKey(spellId)
        local look = self:readLook(spellId, name, extra.isAdded == true)
        local key = extra.isAdded == true and (reminderType .. ":") .. look.key or (suffix ~= nil and (name .. "|") .. suffix or name)
        if keys[key] ~= nil then
            return
        end
        keys[key] = true
        rows[#rows + 1] = __TS__ObjectAssign({reminderType = reminderType, spellId = spellId, label = suffix ~= nil and ((look.label .. " (") .. suffix) .. ")" or look.label, iconId = look.iconId}, extra)
    end
    local function addListed(reminderType, listId, suffix)
        if listId ~= nil then
            add(
                reminderType,
                self.addedSpells:getEffectiveId(listId),
                {listId = listId},
                suffix
            )
        end
    end
    for ____, classBuff in ipairs(self.classBuffs:getClassBuffs()) do
        addListed("missingBuff", classBuff.id)
    end
    for ____, entry in ipairs(self.weaponChoice:getWeaponChoices()) do
        addListed("weaponBuff", entry.id)
    end
    for ____, id in ipairs(self.sealReminder:listSeals()) do
        addListed("missingSeal", id)
    end
    for ____, id in ipairs(self.trackingReminder:listTrackings()) do
        addListed("missingTracking", id)
    end
    for ____, reminderType in ipairs({"readyCooldown", "proc"}) do
        for ____, id in ipairs(self.glowCues:listBuiltInIds(reminderType)) do
            addListed(reminderType, id)
        end
    end
    for ____, ____value in ipairs(self:listAddedRows()) do
        local reminderType = ____value.reminderType
        local id = ____value.id
        local extra = ____value.extra
        add(reminderType, id, extra)
    end
    for ____, reagent in ipairs(self.reagents:getReagentsOfClass(self.player:getClassToken())) do
        addListed(
            "lowReagent",
            reagent.spells[1],
            self.reagents:getReagentName(reagent)
        )
    end
    for ____, id in ipairs(self.spells:listSpellBookIds()) do
        if self.spells:getSpellRank(id) ~= nil then
            add("oldRank", id)
        end
    end
    __TS__ArraySort(
        rows,
        function(____, a, b) return self:compareRows(a, b) end
    )
    return rows
end
function StyleRowsService.prototype.compareRows(self, a, b)
    local byType = __TS__ArrayIndexOf(TYPE_ORDER, a.reminderType) - __TS__ArrayIndexOf(TYPE_ORDER, b.reminderType)
    if byType ~= 0 then
        return byType
    end
    return a.label < b.label and -1 or (a.label > b.label and 1 or 0)
end
return ____exports
 end,
["addons.glowing-bars.src.options.style-choices_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local ____ui = require("packages.@wowkit.ui.src.index")
local SOUNDS = ____ui.SOUNDS
local ____settings_2Econstants = require("addons.glowing-bars.src.settings.settings_constants")
local ANIMATION_CHOICES = ____settings_2Econstants.ANIMATION_CHOICES
local GLOW_TIME_CHOICES = ____settings_2Econstants.GLOW_TIME_CHOICES
local REPEAT_CHOICES = ____settings_2Econstants.REPEAT_CHOICES
local listWhenChoices = ____settings_2Econstants.listWhenChoices
local ____animation_2Esection = require("addons.glowing-bars.src.options.animation_section")
local ANIMATION_TEXTS = ____animation_2Esection.ANIMATION_TEXTS
local ____style_2Dtable_2Econstants = require("addons.glowing-bars.src.options.style-table_constants")
local COLUMN = ____style_2Dtable_2Econstants.COLUMN
local findCenteredX = ____style_2Dtable_2Econstants.findCenteredX
--- The words of each When.
local WHEN_TEXTS = {
    always = "WHEN_ALWAYS",
    inCombat = "WHEN_IN_COMBAT",
    outOfCombat = "WHEN_OUT_OF_COMBAT",
    enemyTargeted = "WHEN_ENEMY_TARGETED",
    townAlert = "WHEN_TOWN_ALERT"
}
____exports.StyleChoicesService = __TS__Class()
local StyleChoicesService = ____exports.StyleChoicesService
StyleChoicesService.name = "StyleChoicesService"
function StyleChoicesService.prototype.____constructor(self, locale, styles, messages)
    self.locale = locale
    self.styles = styles
    self.messages = messages
end
function StyleChoicesService.prototype.chooseNextSound(self, row, step)
    local current = self.styles:getStyle(row.reminderType, row.spellId).sound
    local index = math.max(
        0,
        __TS__ArrayFindIndex(
            SOUNDS,
            function(____, sound) return sound.key == current end
        )
    )
    local chosen = SOUNDS[(index + step + #SOUNDS) % #SOUNDS + 1].key
    self.styles:changeStyle(row.reminderType, row.spellId, {sound = chosen})
    self.messages:playAlertSound(chosen)
end
function StyleChoicesService.prototype.createChoiceButtons(self, frame, getRow)
    return {
        ["repeat"] = self:createRepeatButton(frame, getRow),
        when = self:createWhenButton(frame, getRow),
        glowTime = self:createGlowTimeButton(frame, getRow),
        animation = self:createAnimationButton(frame, getRow)
    }
end
function StyleChoicesService.prototype.fillChoices(self, buttons, row)
    self:fillRepeat(buttons["repeat"], row)
    self:fillWhen(buttons.when, row)
    local style = self.styles:getStyle(row.reminderType, row.spellId)
    buttons.animation:SetText(self.locale:getText(ANIMATION_TEXTS[style.animation]))
    local seconds = style.glowTime
    buttons.glowTime:SetText(seconds == 0 and self.locale:getText("GLOW_UNTIL_DONE") or string.format(
        self.locale:getText("REPEAT_SECONDS"),
        seconds
    ))
end
function StyleChoicesService.prototype.createRepeatButton(self, frame, getRow)
    local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    button:SetSize(54, 24)
    button:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        findCenteredX(COLUMN["repeat"], 54),
        0
    )
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript(
        "OnClick",
        function(_button, mouseButton)
            local row = getRow()
            if row ~= nil then
                self:chooseNextRepeat(row, mouseButton == "RightButton" and -1 or 1)
            end
        end
    )
    return button
end
function StyleChoicesService.prototype.createWhenButton(self, frame, getRow)
    local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    button:SetSize(104, 24)
    button:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        findCenteredX(COLUMN.when, 104),
        0
    )
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript(
        "OnClick",
        function(_button, mouseButton)
            local row = getRow()
            if row == nil then
                return
            end
            local choices = listWhenChoices(row.reminderType)
            local index = math.max(
                0,
                __TS__ArrayIndexOf(
                    choices,
                    self.styles:getStyle(row.reminderType, row.spellId).when
                )
            )
            local step = mouseButton == "RightButton" and -1 or 1
            self.styles:changeStyle(row.reminderType, row.spellId, {when = choices[(index + step + #choices) % #choices + 1]})
        end
    )
    return button
end
function StyleChoicesService.prototype.fillWhen(self, button, row)
    button:SetText(self.locale:getText(WHEN_TEXTS[self.styles:getStyle(row.reminderType, row.spellId).when]))
end
function StyleChoicesService.prototype.createGlowTimeButton(self, frame, getRow)
    local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    button:SetSize(72, 24)
    button:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        findCenteredX(COLUMN.glowTime, 72),
        0
    )
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript(
        "OnClick",
        function(_button, mouseButton)
            local row = getRow()
            if row == nil then
                return
            end
            local index = math.max(
                0,
                __TS__ArrayIndexOf(
                    GLOW_TIME_CHOICES,
                    self.styles:getStyle(row.reminderType, row.spellId).glowTime
                )
            )
            local step = mouseButton == "RightButton" and -1 or 1
            local chosen = GLOW_TIME_CHOICES[(index + step + #GLOW_TIME_CHOICES) % #GLOW_TIME_CHOICES + 1]
            self.styles:changeStyle(row.reminderType, row.spellId, {glowTime = chosen})
        end
    )
    return button
end
function StyleChoicesService.prototype.createAnimationButton(self, frame, getRow)
    local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    button:SetSize(82, 24)
    button:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        findCenteredX(COLUMN.animation, 82),
        0
    )
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript(
        "OnClick",
        function(_button, mouseButton)
            local row = getRow()
            if row == nil then
                return
            end
            local index = math.max(
                0,
                __TS__ArrayIndexOf(
                    ANIMATION_CHOICES,
                    self.styles:getStyle(row.reminderType, row.spellId).animation
                )
            )
            local step = mouseButton == "RightButton" and -1 or 1
            local chosen = ANIMATION_CHOICES[(index + step + #ANIMATION_CHOICES) % #ANIMATION_CHOICES + 1]
            self.styles:changeStyle(row.reminderType, row.spellId, {animation = chosen})
        end
    )
    return button
end
function StyleChoicesService.prototype.fillRepeat(self, button, row)
    local seconds = self.styles:getStyle(row.reminderType, row.spellId)["repeat"]
    button:SetText(seconds == 0 and self.locale:getText("REPEAT_OFF") or string.format(
        self.locale:getText("REPEAT_SECONDS"),
        seconds
    ))
end
function StyleChoicesService.prototype.chooseNextRepeat(self, row, step)
    local index = math.max(
        0,
        __TS__ArrayIndexOf(
            REPEAT_CHOICES,
            self.styles:getStyle(row.reminderType, row.spellId)["repeat"]
        )
    )
    local chosen = REPEAT_CHOICES[(index + step + #REPEAT_CHOICES) % #REPEAT_CHOICES + 1]
    self.styles:changeStyle(row.reminderType, row.spellId, {["repeat"] = chosen})
end
function StyleChoicesService.prototype.chooseColor(self, row)
    local picker = ColorPickerFrame
    if picker.SetupColorPickerAndShow == nil then
        self.messages:say(self.locale:getText("NO_COLOR_PICKER"))
        return
    end
    --- Of the glow and of the message.
    local r, g, b = unpack(
        self.styles:getStyle(row.reminderType, row.spellId).color,
        1,
        3
    )
    picker:SetupColorPickerAndShow({
        r = r,
        g = g,
        b = b,
        hasOpacity = false,
        swatchFunc = function()
            local pickedR, pickedG, pickedB = picker:GetColorRGB()
            self.styles:changeStyle(row.reminderType, row.spellId, {color = {pickedR, pickedG, pickedB}})
        end,
        cancelFunc = function() return self.styles:changeStyle(row.reminderType, row.spellId, {color = {r, g, b}}) end
    })
end
return ____exports
 end,
["addons.glowing-bars.src.settings.enabled_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- The setting that switches a type of reminder on.
local TYPE_SWITCHES = {
    missingBuff = "isMissingBuffEnabled",
    weaponBuff = "isWeaponBuffEnabled",
    missingSeal = "isMissingSealEnabled",
    missingTracking = "isMissingTrackingEnabled",
    lowReagent = "isLowReagentEnabled",
    readyCooldown = "isReadyCooldownEnabled",
    proc = "isProcEnabled",
    oldRank = "isOldRankEnabled",
    lowStock = "isLowStockEnabled"
}
____exports.EnabledService = __TS__Class()
local EnabledService = ____exports.EnabledService
EnabledService.name = "EnabledService"
function EnabledService.prototype.____constructor(self, spells, classBuffs, reagents, settings)
    self.spells = spells
    self.classBuffs = classBuffs
    self.reagents = reagents
    self.settings = settings
end
function EnabledService.prototype.isTypeEnabled(self, reminderType)
    return self.settings:get(TYPE_SWITCHES[reminderType])
end
function EnabledService.prototype.isEnabled(self, row)
    local spellId = row.spellId
    if spellId == nil then
        return self.settings:get(TYPE_SWITCHES[row.reminderType])
    end
    local classBuff = self:findClassBuff(row)
    if classBuff ~= nil then
        return self.classBuffs:isBuffEnabled(classBuff)
    end
    local itemId = self:findReagentItem(row)
    if itemId ~= nil then
        return self.settings:get("enabledReagents")[itemId] ~= false
    end
    if row.reminderType == "oldRank" then
        return self.settings:get("enabledRanks")[self:getName(spellId)] ~= false
    end
    return self.settings:get("enabledSpells")[self:getGlowKey(row, spellId)] ~= false
end
function EnabledService.prototype.setEnabled(self, row, isEnabled)
    local spellId = row.spellId
    if spellId == nil then
        return self.settings:change(TYPE_SWITCHES[row.reminderType], isEnabled)
    end
    local classBuff = self:findClassBuff(row)
    if classBuff ~= nil then
        return self.classBuffs:setBuffEnabled(classBuff, isEnabled)
    end
    local itemId = self:findReagentItem(row)
    if itemId ~= nil then
        local ____self_changeEntry_1 = self.changeEntry
        local ____isEnabled_0
        if isEnabled then
            ____isEnabled_0 = nil
        else
            ____isEnabled_0 = false
        end
        return ____self_changeEntry_1(self, "enabledReagents", itemId, ____isEnabled_0)
    end
    if row.reminderType == "oldRank" then
        local ____self_changeEntry_4 = self.changeEntry
        local ____temp_3 = self:getName(spellId)
        local ____isEnabled_2
        if isEnabled then
            ____isEnabled_2 = nil
        else
            ____isEnabled_2 = false
        end
        return ____self_changeEntry_4(self, "enabledRanks", ____temp_3, ____isEnabled_2)
    end
    local ____self_changeEntry_7 = self.changeEntry
    local ____temp_6 = self:getGlowKey(row, spellId)
    local ____isEnabled_5
    if isEnabled then
        ____isEnabled_5 = nil
    else
        ____isEnabled_5 = false
    end
    ____self_changeEntry_7(self, "enabledSpells", ____temp_6, ____isEnabled_5)
end
function EnabledService.prototype.findClassBuff(self, row)
    if row.reminderType ~= "missingBuff" or row.isAdded == true then
        return nil
    end
    return __TS__ArrayFind(
        self.classBuffs:getClassBuffs(),
        function(____, classBuff) return classBuff.id == row.spellId end
    )
end
function EnabledService.prototype.findReagentItem(self, row)
    if row.reminderType ~= "lowReagent" or row.isAdded == true or row.spellId == nil then
        return nil
    end
    local reagent = self.reagents:findReagentOfSpell(row.spellId)
    return reagent ~= nil and string.format("%d", reagent.itemId) or nil
end
function EnabledService.prototype.getGlowKey(self, row, spellId)
    return string.format("%d", row.listId or spellId)
end
function EnabledService.prototype.getName(self, spellId)
    return self.spells:getSpellName(spellId) or string.format("%d", spellId)
end
function EnabledService.prototype.changeEntry(self, key, entry, newValue)
    local copy = __TS__ObjectAssign(
        {},
        self.settings:get(key)
    )
    copy[entry] = newValue
    self.settings:change(key, copy)
end
return ____exports
 end,
["addons.glowing-bars.src.options.style-edits_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySome = ____lualib.__TS__ArraySome
local ____exports = {}
local ____settings_2Econstants = require("addons.glowing-bars.src.settings.settings_constants")
local ADDABLE_TYPES = ____settings_2Econstants.ADDABLE_TYPES
local ____style_2Dtable_2Econstants = require("addons.glowing-bars.src.options.style-table_constants")
local COLUMN = ____style_2Dtable_2Econstants.COLUMN
local HEADER_HEIGHT = ____style_2Dtable_2Econstants.HEADER_HEIGHT
local ROW_HEIGHT = ____style_2Dtable_2Econstants.ROW_HEIGHT
local TABLE_WIDTH = ____style_2Dtable_2Econstants.TABLE_WIDTH
local findCenteredX = ____style_2Dtable_2Econstants.findCenteredX
local ____style_2Drows_2Eservice = require("addons.glowing-bars.src.options.style-rows_service")
local TYPE_TEXTS = ____style_2Drows_2Eservice.TYPE_TEXTS
--- How faded the spell rows of a type that is switched off are.
local TYPE_OFF_ALPHA = 0.4
--- What was typed is wrong: nothing was done, or something else than was asked.
local ERROR_COLOR = {1, 0.25, 0.2}
____exports.StyleEditsService = __TS__Class()
local StyleEditsService = ____exports.StyleEditsService
StyleEditsService.name = "StyleEditsService"
function StyleEditsService.prototype.____constructor(self, locale, addedSpells, notice, switches, rows, styles, limits, reagents)
    self.locale = locale
    self.addedSpells = addedSpells
    self.notice = notice
    self.switches = switches
    self.rows = rows
    self.styles = styles
    self.limits = limits
    self.reagents = reagents
end
function StyleEditsService.prototype.connectEnabled(self, box, getRow)
    box:SetPoint(
        "LEFT",
        box:GetParent(),
        "LEFT",
        findCenteredX(COLUMN.enabled, 24),
        0
    )
    box:SetSize(24, 24)
    box:SetScript(
        "OnClick",
        function()
            local row = getRow()
            if row ~= nil then
                self.switches:setEnabled(
                    row,
                    box:GetChecked()
                )
            end
        end
    )
end
function StyleEditsService.prototype.connectRemove(self, button, getRow)
    button:SetSize(22, 22)
    button:SetPoint(
        "LEFT",
        button:GetParent(),
        "LEFT",
        COLUMN.actions.x + 50,
        0
    )
    button:SetText("X")
    button:SetScript(
        "OnClick",
        function()
            local row = getRow()
            local id = row and row.itemId or row and row.spellId
            if id ~= nil then
                self.addedSpells:removeAdded(id, row and row.reminderType)
            end
        end
    )
end
function StyleEditsService.prototype.fillEnabled(self, box, frame, row)
    box:Show()
    box:SetChecked(self.switches:isEnabled(row))
    local isTypeOff = row.spellId ~= nil and not self.switches:isTypeEnabled(row.reminderType)
    frame:SetAlpha(isTypeOff and TYPE_OFF_ALPHA or 1)
end
function StyleEditsService.prototype.createIdBox(self, frame, getRow)
    local box = self:createNumberBox(
        frame,
        findCenteredX(COLUMN.id, 58),
        58,
        7
    )
    local function restore()
        local row = getRow()
        local id = row and row.itemId or row and row.spellId
        box:SetText(id ~= nil and string.format("%d", id) or "")
    end
    local function apply()
        local row = getRow()
        local spellId = tonumber(box:GetText())
        if row ~= nil and self:isIdEditable(row) and spellId ~= nil and spellId ~= row.spellId then
            self:changeId(row, spellId)
        end
        restore()
    end
    box:SetScript(
        "OnEnterPressed",
        function() return box:ClearFocus() end
    )
    box:SetScript("OnEditFocusLost", apply)
    box:SetScript(
        "OnEscapePressed",
        function()
            restore()
            box:ClearFocus()
        end
    )
    return box
end
function StyleEditsService.prototype.fillIdBox(self, box, row)
    box:SetShown(row.spellId ~= nil)
    if row.spellId ~= nil then
        box:SetText(string.format("%d", row.itemId or row.spellId))
    end
    local isEditable = self:isIdEditable(row)
    box:SetEnabled(isEditable)
    local shade = isEditable and 1 or 0.5
    box:SetTextColor(shade, shade, shade)
end
function StyleEditsService.prototype.createBelowBox(self, frame, getRow)
    local box = self:createNumberBox(
        frame,
        findCenteredX(COLUMN.belowLimits, 44),
        44,
        5
    )
    box:SetScript(
        "OnEnterPressed",
        function() return box:ClearFocus() end
    )
    box:SetScript(
        "OnEditFocusLost",
        function()
            local row = getRow()
            local limit = tonumber(box:GetText())
            if row ~= nil and limit ~= nil and self.limits:hasLimit(row.reminderType) then
                self.limits:setLimit(
                    row.reminderType,
                    self:findLimitEntry(row),
                    limit
                )
            end
            if row ~= nil then
                self:fillBelowBox(box, row)
            end
        end
    )
    return box
end
function StyleEditsService.prototype.fillBelowBox(self, box, row)
    local hasLimit = self.limits:hasLimit(row.reminderType)
    box:SetShown(hasLimit)
    if self.limits:hasLimit(row.reminderType) then
        box:SetText(string.format(
            "%d",
            self.limits:getLimit(
                row.reminderType,
                self:findLimitEntry(row)
            )
        ))
    end
end
function StyleEditsService.prototype.findLimitEntry(self, row)
    if row.spellId == nil then
        return nil
    end
    if row.itemId ~= nil then
        return string.format("%d", row.itemId)
    end
    if row.isAdded == true then
        return "spell" .. string.format("%d", row.spellId)
    end
    local reagent = self.reagents:findReagentOfSpell(row.spellId)
    return reagent ~= nil and string.format("%d", reagent.itemId) or nil
end
function StyleEditsService.prototype.isIdEditable(self, row)
    return row.itemId == nil and (row.listId ~= nil or row.isAdded == true)
end
function StyleEditsService.prototype.createAddRow(self, content)
    local frame = CreateFrame("Frame", nil, content)
    frame:SetSize(TABLE_WIDTH, ROW_HEIGHT)
    local hover = CreateFrame("Frame", nil, frame)
    hover:SetPoint(
        "BOTTOMLEFT",
        frame,
        "TOPLEFT",
        0,
        0
    )
    hover:SetSize(200, HEADER_HEIGHT)
    hover:EnableMouse(true)
    hover:SetScript(
        "OnEnter",
        function() return self:showTooltip(hover, "TIP_ADD") end
    )
    hover:SetScript(
        "OnLeave",
        function() return GameTooltip:Hide() end
    )
    local box = self:createNumberBox(frame, COLUMN.name.x, 90, 7)
    local typeIndex = 0
    local typeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    typeButton:SetSize(136, 24)
    typeButton:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        COLUMN.name.x + 110,
        0
    )
    local function showType()
        return typeButton:SetText(self.locale:getText(TYPE_TEXTS[ADDABLE_TYPES[typeIndex + 1]]))
    end
    typeButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    typeButton:SetScript(
        "OnClick",
        function(_button, mouseButton)
            local step = mouseButton == "RightButton" and -1 or 1
            typeIndex = (typeIndex + step + #ADDABLE_TYPES) % #ADDABLE_TYPES
            showType()
        end
    )
    showType()
    local addButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    addButton:SetSize(80, 24)
    addButton:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        COLUMN.name.x + 262,
        0
    )
    addButton:SetText(self.locale:getText("BTN_ADD"))
    addButton:SetScript(
        "OnClick",
        function()
            local spellId = tonumber(box:GetText())
            if spellId ~= nil and self:addSpell(spellId, ADDABLE_TYPES[typeIndex + 1]) then
                box:SetText("")
            end
            box:ClearFocus()
        end
    )
    return frame
end
function StyleEditsService.prototype.addSpell(self, spellId, reminderType)
    if reminderType == "lowStock" then
        if self.addedSpells:addItem(spellId) then
            return true
        end
        self:showProblem(
            string.format(
                self.locale:getText("MSG_UNKNOWN_ITEM"),
                spellId
            ),
            ERROR_COLOR
        )
        return false
    end
    if not self.addedSpells:isKnownSpell(spellId) then
        self:showUnknown(spellId)
        return false
    end
    local name = self.styles:getSpellKey(spellId)
    if self:isListedElsewhere(spellId) then
        self:showProblem(
            string.format(
                self.locale:getText("MSG_ALREADY_LISTED"),
                name
            ),
            ERROR_COLOR
        )
        return false
    end
    local isWrongForFood = self.rows:isSharingName(spellId) and reminderType ~= "missingBuff"
    local problem = isWrongForFood and "MSG_FOOD_IS_BUFF" or self.addedSpells:findTypeProblem(spellId, reminderType)
    if problem ~= nil then
        self:showProblem(
            string.format(
                self.locale:getText(problem),
                name
            ),
            ERROR_COLOR
        )
        return false
    end
    self.addedSpells:addSpell(spellId, reminderType)
    return true
end
function StyleEditsService.prototype.isListedElsewhere(self, spellId, except)
    local name = self.styles:getSpellKey(spellId)
    local isSharingName = self.rows:isSharingName(spellId)
    return __TS__ArraySome(
        self.rows:listSpellRows(),
        function(____, row)
            local ____temp_11 = row.reminderType ~= "oldRank" and row.spellId ~= nil
            if ____temp_11 then
                local ____isSharingName_10
                if isSharingName then
                    ____isSharingName_10 = row.spellId == spellId
                else
                    ____isSharingName_10 = self.styles:getSpellKey(row.spellId) == name
                end
                ____temp_11 = ____isSharingName_10
            end
            return ____temp_11 and not (except ~= nil and row.reminderType == except.reminderType and row.listId == except.listId and row.spellId == except.spellId)
        end
    )
end
function StyleEditsService.prototype.changeId(self, row, spellId)
    local name = self.addedSpells:isKnownSpell(spellId) and self.styles:getSpellKey(spellId) or nil
    if name ~= nil and self:isListedElsewhere(spellId, row) then
        self:showProblem(
            string.format(
                self.locale:getText("MSG_ALREADY_LISTED"),
                name
            ),
            ERROR_COLOR
        )
        return
    end
    local ____temp_12
    if row.isAdded == true then
        ____temp_12 = row.spellId ~= nil and self.addedSpells:changeAdded(row.spellId, spellId)
    else
        ____temp_12 = row.listId ~= nil and self.addedSpells:changeOverride(row.listId, spellId)
    end
    local isChanged = ____temp_12
    if not isChanged then
        self:showUnknown(spellId)
    end
end
function StyleEditsService.prototype.showUnknown(self, spellId)
    self:showProblem(
        string.format(
            self.locale:getText("MSG_UNKNOWN_SPELL"),
            spellId
        ),
        ERROR_COLOR
    )
end
function StyleEditsService.prototype.showTooltip(self, owner, text)
    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    GameTooltip:SetText(
        self.locale:getText(text),
        1,
        1,
        1,
        1,
        true
    )
    GameTooltip:Show()
end
function StyleEditsService.prototype.showProblem(self, text, color)
    self.notice:showNotice(self.styles:applyTextColor(color, text))
end
function StyleEditsService.prototype.createNumberBox(self, frame, x, width, maxLetters)
    local box = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    box:SetSize(width, 20)
    box:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        x + 3,
        0
    )
    box:SetAutoFocus(false)
    box:SetNumeric(true)
    box:SetMaxLetters(maxLetters)
    return box
end
return ____exports
 end,
["addons.glowing-bars.src.options.style-row-layout"] = function(...) 
local ____exports = {}
local ____style_2Dtable_2Econstants = require("addons.glowing-bars.src.options.style-table_constants")
local ICON_SIZE = ____style_2Dtable_2Econstants.ICON_SIZE
local findCenteredX = ____style_2Dtable_2Econstants.findCenteredX
local findColumns = ____style_2Dtable_2Econstants.findColumns
local COLUMN = ____style_2Dtable_2Econstants.COLUMN
local function applyPosition(control, frame, x)
    control:ClearAllPoints()
    control:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        x,
        0
    )
end
--- Puts the controls of a filled row in the columns of the view.
function ____exports.applyRowView(row, isAdvanced)
    local columns = findColumns(isAdvanced)
    applyPosition(
        row.swatch,
        row.frame,
        findCenteredX(columns.color, 22)
    )
    applyPosition(
        row.message,
        row.frame,
        findCenteredX(columns.message, 24)
    )
    applyPosition(
        row.sound,
        row.frame,
        findCenteredX(columns.sound, 126)
    )
    applyPosition(
        row.belowBox,
        row.frame,
        findCenteredX(columns.belowLimits, 44)
    )
    applyPosition(
        row.enabled,
        row.frame,
        findCenteredX(columns.enabled, 24)
    )
    applyPosition(row.reset, row.frame, columns.actions.x + 2)
    applyPosition(row.remove, row.frame, columns.actions.x + 50)
    local ____row_choices_0 = row.choices
    local ____repeat = ____row_choices_0["repeat"]
    local when = ____row_choices_0.when
    local glowTime = ____row_choices_0.glowTime
    local animation = ____row_choices_0.animation
    for ____, control in ipairs({
        row.glowPercent,
        ____repeat,
        when,
        glowTime,
        animation
    }) do
        control:SetShown(isAdvanced)
    end
    if not isAdvanced then
        row.spellIdBox:Hide()
    end
end
function ____exports.createStripe(frame)
    local stripe = frame:CreateTexture(nil, "BACKGROUND")
    stripe:SetAllPoints(frame)
    return stripe
end
function ____exports.createIcon(frame)
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(ICON_SIZE, ICON_SIZE)
    icon:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        findCenteredX(COLUMN.icon, ICON_SIZE),
        0
    )
    return icon
end
function ____exports.createText(frame, column, font)
    local text = frame:CreateFontString(nil, "OVERLAY", font)
    text:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        column.x,
        0
    )
    text:SetWidth(column.width - 4)
    text:SetJustifyH("LEFT")
    return text
end
return ____exports
 end,
["addons.glowing-bars.src.options.style-window_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____style_2Dtable_2Econstants = require("addons.glowing-bars.src.options.style-table_constants")
local BORDER_COLOR = ____style_2Dtable_2Econstants.BORDER_COLOR
local COLUMN = ____style_2Dtable_2Econstants.COLUMN
local findColumns = ____style_2Dtable_2Econstants.findColumns
local TABLE_LEFT = ____style_2Dtable_2Econstants.TABLE_LEFT
local TABLE_WIDTH = ____style_2Dtable_2Econstants.TABLE_WIDTH
local WINDOW_HEIGHT = ____style_2Dtable_2Econstants.WINDOW_HEIGHT
local WINDOW_NAME = ____style_2Dtable_2Econstants.WINDOW_NAME
local findWindowWidth = ____style_2Dtable_2Econstants.findWindowWidth
--- What the window leaves free of the screen's width when it has to shrink.
local SCREEN_MARGIN = 40
--- The headers that explain their column as the mouse comes over them.
local HEADER_TIPS = {
    type = "TIP_TYPE",
    id = "TIP_ID",
    color = "TIP_COLOR",
    glowPercent = "TIP_GLOW_PERCENT",
    message = "TIP_MESSAGE",
    sound = "TIP_SOUND",
    ["repeat"] = "TIP_REPEAT",
    when = "TIP_WHEN",
    glowTime = "TIP_GLOW_TIME",
    animation = "TIP_ANIMATION",
    belowLimits = "TIP_BELOW",
    enabled = "TIP_ENABLED",
    actions = "TIP_ACTIONS"
}
____exports.StyleWindowService = __TS__Class()
local StyleWindowService = ____exports.StyleWindowService
StyleWindowService.name = "StyleWindowService"
function StyleWindowService.prototype.____constructor(self, locale, settings)
    self.locale = locale
    self.settings = settings
    self.headers = {}
end
function StyleWindowService.prototype.isAdvanced(self)
    return self.settings:get("isTableAdvanced")
end
function StyleWindowService.prototype.showView(self, window)
    local columns = findColumns(self:isAdvanced())
    for ____, ____value in ipairs(self.headers) do
        local header = ____value.header
        local hover = ____value.hover
        local column = ____value.column
        local shown = columns[column]
        header:SetShown(shown ~= nil)
        if hover ~= nil then
            hover:SetShown(shown ~= nil)
        end
        if shown ~= nil then
            self:applyHeaderPosition(window, header, hover, shown)
        end
    end
    local ____opt_2 = self.viewButton
    if ____opt_2 ~= nil then
        ____opt_2:SetText(self.locale:getText(self:isAdvanced() and "BTN_BASIC" or "BTN_ADVANCED"))
    end
end
function StyleWindowService.prototype.applyHeaderPosition(self, window, header, hover, column)
    header:ClearAllPoints()
    header:SetPoint(
        "TOPLEFT",
        window,
        "TOPLEFT",
        TABLE_LEFT + column.x,
        -42
    )
    if hover ~= nil then
        hover:ClearAllPoints()
    end
    if hover ~= nil then
        hover:SetPoint(
            "TOPLEFT",
            window,
            "TOPLEFT",
            TABLE_LEFT + column.x,
            -38
        )
    end
end
function StyleWindowService.prototype.setWidthToFit(self, window, width)
    window:SetWidth(width)
    window:SetScale(math.min(
        1,
        (UIParent:GetWidth() - SCREEN_MARGIN) / width
    ))
    self:showView(window)
end
function StyleWindowService.prototype.createWindow(self)
    local window = self:createFrameWithBorder()
    window:SetSize(
        findWindowWidth(TABLE_WIDTH),
        WINDOW_HEIGHT
    )
    window:SetPoint(
        "CENTER",
        UIParent,
        "CENTER",
        0,
        0
    )
    window:SetFrameStrata("DIALOG")
    window:SetMovable(true)
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript(
        "OnDragStart",
        function() return window:StartMoving() end
    )
    window:SetScript(
        "OnDragStop",
        function() return window:StopMovingOrSizing() end
    )
    self:connectEscape(window)
    local title = window:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint(
        "TOP",
        window,
        "TOP",
        0,
        -16
    )
    title:SetText(self.locale:getText("TABLE_TITLE"))
    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint(
        "TOPRIGHT",
        window,
        "TOPRIGHT",
        -6,
        -6
    )
    self:createViewButton(window)
    self:addColumnHeaders(window)
    local scroll = CreateFrame("ScrollFrame", nil, window, "UIPanelScrollFrameTemplate")
    scroll:SetPoint(
        "TOPLEFT",
        window,
        "TOPLEFT",
        TABLE_LEFT,
        -60
    )
    scroll:SetPoint(
        "BOTTOMRIGHT",
        window,
        "BOTTOMRIGHT",
        -34,
        16
    )
    self:applyScrollBarTint(scroll)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(TABLE_WIDTH, 10)
    scroll:SetScrollChild(content)
    window:Hide()
    return {window = window, content = content}
end
function StyleWindowService.prototype.connectEscape(self, window)
    if InCombatLockdown() then
        return
    end
    window:EnableKeyboard(true)
    window:SetPropagateKeyboardInput(true)
    window:SetScript(
        "OnKeyDown",
        function(_frame, key)
            if InCombatLockdown() then
                return
            end
            local isEscape = key == "ESCAPE"
            window:SetPropagateKeyboardInput(not isEscape)
            if isEscape then
                window:Hide()
            end
        end
    )
end
function StyleWindowService.prototype.createFrameWithBorder(self)
    local didSucceed, created = pcall(function() return CreateFrame("Frame", WINDOW_NAME, UIParent, "BackdropTemplate") end)
    local frame = didSucceed and created or CreateFrame("Frame", WINDOW_NAME, UIParent)
    local background = frame:CreateTexture(nil, "BACKGROUND")
    background:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        6,
        -6
    )
    background:SetPoint(
        "BOTTOMRIGHT",
        frame,
        "BOTTOMRIGHT",
        -6,
        6
    )
    background:SetColorTexture(0.1, 0.07, 0.04, 1)
    if didSucceed then
        local backdrop = created
        backdrop:SetBackdrop({edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 32, insets = {left = 11, right = 12, top = 12, bottom = 11}})
        backdrop:SetBackdropBorderColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3])
    end
    return frame
end
function StyleWindowService.prototype.applyScrollBarTint(self, scroll)
    local bar = scroll.ScrollBar
    if bar ~= nil then
        pcall(function() return self:applyTextureTint(bar, 0) end)
    end
end
function StyleWindowService.prototype.applyTextureTint(self, frame, depth)
    for ____, region in ipairs({frame:GetRegions()}) do
        if region:GetObjectType() == "Texture" then
            region:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3])
        end
    end
    if depth < 2 then
        for ____, child in ipairs({frame:GetChildren()}) do
            self:applyTextureTint(child, depth + 1)
        end
    end
end
function StyleWindowService.prototype.createViewButton(self, window)
    local button = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    button:SetSize(80, 22)
    button:SetPoint(
        "TOPRIGHT",
        window,
        "TOPRIGHT",
        -34,
        -9
    )
    button:SetScript(
        "OnClick",
        function() return self.settings:change(
            "isTableAdvanced",
            not self:isAdvanced()
        ) end
    )
    self.viewButton = button
end
function StyleWindowService.prototype.addColumnHeaders(self, window)
    local columns = {
        {"name", "COL_SPELL_ITEM", false},
        {"type", "COL_TYPE", false},
        {"id", "COL_SPELL_ITEM_ID", true},
        {"color", "COL_COLOR", true},
        {"glowPercent", "COL_GLOW_PERCENT", true},
        {"message", "COL_MESSAGE", true},
        {"sound", "COL_SOUND", true},
        {"repeat", "COL_REPEAT", true},
        {"when", "COL_WHEN", true},
        {"glowTime", "COL_GLOW_TIME", true},
        {"animation", "COL_ANIMATION", true},
        {"belowLimits", "COL_BELOW", true},
        {"enabled", "COL_ENABLED", true},
        {"actions", "COL_ACTIONS", true}
    }
    for ____, ____value in ipairs(columns) do
        local name = ____value[1]
        local text = ____value[2]
        local isCentered = ____value[3]
        local column = COLUMN[name]
        local header = window:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        header:SetPoint(
            "TOPLEFT",
            window,
            "TOPLEFT",
            TABLE_LEFT + column.x,
            -42
        )
        header:SetWidth(column.width)
        header:SetJustifyH(isCentered and "CENTER" or "LEFT")
        header:SetText(self.locale:getText(text))
        local tip = HEADER_TIPS[name]
        local hover = tip ~= nil and self:addHeaderTooltip(window, column, tip) or nil
        local ____self_headers_8 = self.headers
        ____self_headers_8[#____self_headers_8 + 1] = {header = header, hover = hover, column = name}
    end
end
function StyleWindowService.prototype.addHeaderTooltip(self, window, column, tip)
    local hover = CreateFrame("Frame", nil, window)
    hover:SetPoint(
        "TOPLEFT",
        window,
        "TOPLEFT",
        TABLE_LEFT + column.x,
        -38
    )
    hover:SetSize(column.width, 18)
    hover:EnableMouse(true)
    hover:SetScript(
        "OnEnter",
        function()
            GameTooltip:SetOwner(hover, "ANCHOR_TOP")
            GameTooltip:SetText(
                self.locale:getText(tip),
                1,
                1,
                1,
                1,
                true
            )
            GameTooltip:Show()
        end
    )
    hover:SetScript(
        "OnLeave",
        function() return GameTooltip:Hide() end
    )
    return hover
end
return ____exports
 end,
["addons.glowing-bars.src.options.style-table_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
local ____ui = require("packages.@wowkit.ui.src.index")
local SOUNDS = ____ui.SOUNDS
local ____style_2Dtable_2Econstants = require("addons.glowing-bars.src.options.style-table_constants")
local BRONZE_TEXT = ____style_2Dtable_2Econstants.BRONZE_TEXT
local COLUMN = ____style_2Dtable_2Econstants.COLUMN
local findColumns = ____style_2Dtable_2Econstants.findColumns
local findCenteredX = ____style_2Dtable_2Econstants.findCenteredX
local HEADER_HEIGHT = ____style_2Dtable_2Econstants.HEADER_HEIGHT
local OVERRIDDEN_COLOR = ____style_2Dtable_2Econstants.OVERRIDDEN_COLOR
local ROW_HEIGHT = ____style_2Dtable_2Econstants.ROW_HEIGHT
local STRIPE_ALPHA = ____style_2Dtable_2Econstants.STRIPE_ALPHA
local STRIPE_COLOR = ____style_2Dtable_2Econstants.STRIPE_COLOR
local TABLE_WIDTH = ____style_2Dtable_2Econstants.TABLE_WIDTH
local TYPE_HEADING_HEIGHT = ____style_2Dtable_2Econstants.TYPE_HEADING_HEIGHT
local findWindowWidth = ____style_2Dtable_2Econstants.findWindowWidth
local ____style_2Drow_2Dlayout = require("addons.glowing-bars.src.options.style-row-layout")
local applyRowView = ____style_2Drow_2Dlayout.applyRowView
local createIcon = ____style_2Drow_2Dlayout.createIcon
local createStripe = ____style_2Drow_2Dlayout.createStripe
local createText = ____style_2Drow_2Dlayout.createText
local ____style_2Drows_2Eservice = require("addons.glowing-bars.src.options.style-rows_service")
local TYPE_TEXTS = ____style_2Drows_2Eservice.TYPE_TEXTS
____exports.StyleTableService = __TS__Class()
local StyleTableService = ____exports.StyleTableService
StyleTableService.name = "StyleTableService"
function StyleTableService.prototype.____constructor(self, locale, styles, rows, messages, choices, windows, edits)
    self.locale = locale
    self.styles = styles
    self.rows = rows
    self.messages = messages
    self.choices = choices
    self.windows = windows
    self.edits = edits
    self.widgets = {}
    self.headers = {}
    self.usedWidgets = 0
    self.usedHeaders = 0
    self.tableWidth = TABLE_WIDTH
end
function StyleTableService.prototype.toggle(self)
    local didSucceed, ____error = pcall(function() return self:toggleWindow() end)
    if not didSucceed then
        self.messages:say(tostring(____error))
    end
end
function StyleTableService.prototype.refreshAfterChange(self, _key)
    local ____opt_0 = self.window
    if (____opt_0 and ____opt_0:IsShown()) == true then
        self:showRows()
    end
end
__TS__DecorateLegacy(
    {OnEvent("setting.changed")},
    StyleTableService.prototype,
    "refreshAfterChange",
    true
)
function StyleTableService.prototype.toggleWindow(self)
    if self.window == nil then
        local created = self.windows:createWindow()
        self.window = created.window
        self.content = created.content
    end
    if self.window:IsShown() then
        self.window:Hide()
        return
    end
    self:showRows()
    self.window:Show()
end
function StyleTableService.prototype.showRows(self)
    local content = self.content
    if content == nil then
        return
    end
    self.usedWidgets = 0
    self.usedHeaders = 0
    local spellRows = self.rows:listSpellRows()
    local typeRows = self.rows:listTypeRows(spellRows)
    self:applyTableWidth(content)
    local y = self:drawSection(content, "HDR_TABLE_DEFAULTS", typeRows, 0)
    y = self:drawSection(content, "HDR_TABLE_SPELLS", spellRows, y)
    y = self:drawAddRow(content, y)
    do
        local i = self.usedHeaders
        while i < #self.headers do
            self.headers[i + 1]:Hide()
            i = i + 1
        end
    end
    do
        local i = self.usedWidgets
        while i < #self.widgets do
            self.widgets[i + 1].frame:Hide()
            i = i + 1
        end
    end
    content:SetHeight(math.max(10, y))
end
function StyleTableService.prototype.applyTableWidth(self, content)
    local ____findColumns_result_2 = findColumns(self.windows:isAdvanced())
    local actions = ____findColumns_result_2.actions
    self.tableWidth = actions.x + actions.width
    if self.window ~= nil then
        self.windows:setWidthToFit(
            self.window,
            findWindowWidth(self.tableWidth)
        )
    end
    content:SetWidth(self.tableWidth)
end
function StyleTableService.prototype.drawSection(self, content, headerText, rows, top)
    local header = self:takeHeader(content)
    header:SetPoint(
        "TOPLEFT",
        content,
        "TOPLEFT",
        0,
        -top
    )
    header:SetText(self.locale:getText(headerText))
    header:Show()
    local y = top + HEADER_HEIGHT
    local previousType
    for ____, row in ipairs(rows) do
        if headerText == "HDR_TABLE_SPELLS" and row.reminderType ~= previousType then
            y = self:drawTypeHeading(content, row.reminderType, y)
            previousType = row.reminderType
        end
        local widgets = self:takeWidgets(content)
        widgets.row = row
        widgets.frame:ClearAllPoints()
        widgets.frame:SetPoint(
            "TOPLEFT",
            content,
            "TOPLEFT",
            0,
            -y
        )
        widgets.frame:SetWidth(self.tableWidth)
        widgets.frame:Show()
        self:fill(widgets, row)
        widgets.stripe:SetColorTexture(STRIPE_COLOR[1], STRIPE_COLOR[2], STRIPE_COLOR[3], self.usedWidgets % 2 == 0 and STRIPE_ALPHA or 0)
        y = y + ROW_HEIGHT
    end
    return y + 10
end
function StyleTableService.prototype.drawTypeHeading(self, content, reminderType, top)
    local heading = self:takeHeader(content)
    heading:SetFontObject("GameFontNormalSmall")
    heading:SetPoint(
        "TOPLEFT",
        content,
        "TOPLEFT",
        6,
        -(top + 6)
    )
    heading:SetText(self.locale:getText(TYPE_TEXTS[reminderType]))
    heading:Show()
    return top + TYPE_HEADING_HEIGHT
end
function StyleTableService.prototype.drawAddRow(self, content, top)
    local header = self:takeHeader(content)
    header:SetPoint(
        "TOPLEFT",
        content,
        "TOPLEFT",
        0,
        -top
    )
    header:SetText(self.locale:getText("HDR_TABLE_ADD"))
    header:Show()
    self.addRow = self.addRow or self.edits:createAddRow(content)
    self.addRow:ClearAllPoints()
    self.addRow:SetPoint(
        "TOPLEFT",
        content,
        "TOPLEFT",
        0,
        -(top + HEADER_HEIGHT)
    )
    self.addRow:Show()
    return top + HEADER_HEIGHT + ROW_HEIGHT + 10
end
function StyleTableService.prototype.takeHeader(self, content)
    local header = self.headers[self.usedHeaders + 1]
    if header == nil then
        header = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        local ____self_headers_3 = self.headers
        ____self_headers_3[#____self_headers_3 + 1] = header
    end
    self.usedHeaders = self.usedHeaders + 1
    header:SetFontObject("GameFontNormalLarge")
    header:ClearAllPoints()
    return header
end
function StyleTableService.prototype.takeWidgets(self, content)
    local widgets = self.widgets[self.usedWidgets + 1]
    if widgets == nil then
        widgets = self:createWidgets(content)
        local ____self_widgets_4 = self.widgets
        ____self_widgets_4[#____self_widgets_4 + 1] = widgets
    end
    self.usedWidgets = self.usedWidgets + 1
    return widgets
end
function StyleTableService.prototype.fill(self, widgets, row)
    local style = self.styles:getStyle(row.reminderType, row.spellId)
    local isOverridden = self.styles:isOverridden(row.reminderType, row.spellId)
    widgets.icon:SetShown(row.iconId ~= nil)
    if row.iconId ~= nil then
        widgets.icon:SetTexture(row.iconId)
    end
    widgets.name:SetText(row.label)
    local r, g, b = unpack(isOverridden and row.spellId ~= nil and OVERRIDDEN_COLOR or ({1, 1, 1}), 1, 3)
    widgets.name:SetTextColor(r, g, b)
    widgets.typeText:SetTextColor(BRONZE_TEXT[1], BRONZE_TEXT[2], BRONZE_TEXT[3])
    widgets.typeText:SetText(row.spellId ~= nil and self.locale:getText(TYPE_TEXTS[row.reminderType]) or "")
    widgets.swatchColor:SetColorTexture(style.color[1], style.color[2], style.color[3], 1)
    widgets.glowPercent:SetText(string.format("%d", style.glowPercent))
    widgets.message:SetChecked(style.isMessageOn)
    local ____self_7 = widgets.sound
    local ____self_7_SetText_8 = ____self_7.SetText
    local ____opt_5 = __TS__ArrayFind(
        SOUNDS,
        function(____, sound) return sound.key == style.sound end
    )
    ____self_7_SetText_8(____self_7, ____opt_5 and ____opt_5.label or "")
    self.choices:fillChoices(widgets.choices, row)
    widgets.reset:SetShown(isOverridden)
    widgets.remove:SetShown(row.isAdded == true)
    self.edits:fillEnabled(widgets.enabled, widgets.frame, row)
    self.edits:fillIdBox(widgets.spellIdBox, row)
    self.edits:fillBelowBox(widgets.belowBox, row)
    applyRowView(
        widgets,
        self.windows:isAdvanced()
    )
end
function StyleTableService.prototype.createWidgets(self, content)
    local frame = CreateFrame("Frame", nil, content)
    frame:SetSize(TABLE_WIDTH, ROW_HEIGHT)
    local widgets
    widgets = __TS__ObjectAssign(
        {
            frame = frame,
            stripe = createStripe(frame),
            icon = createIcon(frame),
            name = createText(frame, COLUMN.name, "GameFontHighlight"),
            typeText = createText(frame, COLUMN.type, "GameFontNormalSmall")
        },
        self:createSwatch(frame),
        {
            glowPercent = self:createGlowPercentBox(frame),
            message = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate"),
            sound = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate"),
            reset = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate"),
            remove = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate"),
            enabled = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate"),
            choices = self.choices:createChoiceButtons(
                frame,
                function() return widgets.row end
            ),
            spellIdBox = self.edits:createIdBox(
                frame,
                function() return widgets.row end
            ),
            belowBox = self.edits:createBelowBox(
                frame,
                function() return widgets.row end
            ),
            row = nil
        }
    )
    self:connectSwatch(widgets)
    self:connectGlowPercent(widgets)
    self:connectMessage(widgets)
    self:connectSound(widgets)
    self:connectReset(widgets)
    self.edits:connectRemove(
        widgets.remove,
        function() return widgets.row end
    )
    self.edits:connectEnabled(
        widgets.enabled,
        function() return widgets.row end
    )
    return widgets
end
function StyleTableService.prototype.createSwatch(self, frame)
    local swatch = CreateFrame("Button", nil, frame)
    swatch:SetSize(22, 16)
    local border = swatch:CreateTexture(nil, "BACKGROUND")
    border:SetAllPoints(swatch)
    border:SetColorTexture(0.55, 0.42, 0.2, 1)
    local swatchColor = swatch:CreateTexture(nil, "ARTWORK")
    swatchColor:SetPoint(
        "TOPLEFT",
        swatch,
        "TOPLEFT",
        1,
        -1
    )
    swatchColor:SetPoint(
        "BOTTOMRIGHT",
        swatch,
        "BOTTOMRIGHT",
        -1,
        1
    )
    return {swatch = swatch, swatchColor = swatchColor}
end
function StyleTableService.prototype.createGlowPercentBox(self, frame)
    local box = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    box:SetSize(36, 20)
    box:SetPoint(
        "LEFT",
        frame,
        "LEFT",
        findCenteredX(COLUMN.glowPercent, 36) + 3,
        0
    )
    box:SetAutoFocus(false)
    box:SetNumeric(true)
    box:SetMaxLetters(3)
    return box
end
function StyleTableService.prototype.connectSwatch(self, widgets)
    widgets.swatch:SetScript(
        "OnClick",
        function()
            if widgets.row ~= nil then
                self.choices:chooseColor(widgets.row)
            end
        end
    )
end
function StyleTableService.prototype.connectGlowPercent(self, widgets)
    local function apply()
        local row = widgets.row
        local percent = tonumber(widgets.glowPercent:GetText())
        if row ~= nil and percent ~= nil then
            local glowPercent = math.max(
                1,
                math.min(
                    100,
                    math.floor(percent + 0.5)
                )
            )
            self.styles:changeStyle(row.reminderType, row.spellId, {glowPercent = glowPercent})
        end
        widgets.glowPercent:ClearFocus()
    end
    widgets.glowPercent:SetScript("OnEnterPressed", apply)
    widgets.glowPercent:SetScript("OnEditFocusLost", apply)
    widgets.glowPercent:SetScript(
        "OnEscapePressed",
        function()
            if widgets.row ~= nil then
                self:fill(widgets, widgets.row)
            end
            widgets.glowPercent:ClearFocus()
        end
    )
end
function StyleTableService.prototype.connectMessage(self, widgets)
    widgets.message:SetSize(24, 24)
    widgets.message:SetScript(
        "OnClick",
        function() return self:change(
            widgets,
            {isMessageOn = widgets.message:GetChecked()}
        ) end
    )
end
function StyleTableService.prototype.connectSound(self, widgets)
    widgets.sound:SetSize(126, 24)
    widgets.sound:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    widgets.sound:SetScript(
        "OnClick",
        function(_button, mouseButton)
            if widgets.row ~= nil then
                self.choices:chooseNextSound(widgets.row, mouseButton == "RightButton" and -1 or 1)
            end
        end
    )
end
function StyleTableService.prototype.connectReset(self, widgets)
    widgets.reset:SetSize(46, 22)
    widgets.reset:SetText(self.locale:getText("BTN_RESET"))
    widgets.reset:SetScript(
        "OnClick",
        function()
            local row = widgets.row
            if row == nil then
                return
            end
            if row.spellId == nil then
                self.styles:resetType(row.reminderType)
            else
                self.styles:resetSpell(row.reminderType, row.spellId)
            end
        end
    )
end
function StyleTableService.prototype.change(self, widgets, change)
    local row = widgets.row
    if row ~= nil then
        self.styles:changeStyle(row.reminderType, row.spellId, change)
    end
end
return ____exports
 end,
["addons.glowing-bars.src.options.table-command"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local COMMAND = "GLOWINGBARS"
____exports.TableCommand = __TS__Class()
local TableCommand = ____exports.TableCommand
TableCommand.name = "TableCommand"
function TableCommand.prototype.____constructor(self, ____table)
    self.table = ____table
end
function TableCommand.prototype.onFirstLogin(self)
    local globals = _G
    globals[("SLASH_" .. COMMAND) .. "1"] = "/gb"
    globals[("SLASH_" .. COMMAND) .. "2"] = "/glowingbars"
    SlashCmdList[COMMAND] = function() return self.table:toggle() end
end
return ____exports
 end,
["addons.glowing-bars.src.options.weapon_section"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
____exports.WeaponSection = __TS__Class()
local WeaponSection = ____exports.WeaponSection
WeaponSection.name = "WeaponSection"
function WeaponSection.prototype.____constructor(self, locale, spells, weaponChoice, settings, controls, reminderControls)
    self.locale = locale
    self.spells = spells
    self.weaponChoice = weaponChoice
    self.settings = settings
    self.controls = controls
    self.reminderControls = reminderControls
end
function WeaponSection.prototype.addWeaponSection(self, category, layout)
    if #self.weaponChoice:getWeaponChoices() == 0 then
        return
    end
    self.reminderControls:addHeader(layout, "HDR_WEAPON")
    if self.weaponChoice:hasOffhandChoice() then
        self:addWeaponPick(category, "weaponBuff", "OPT_WEAPON_PICK_MAIN", false)
        self:addWeaponPick(category, "weaponBuffOff", "OPT_WEAPON_PICK_OFF", true)
    else
        self:addWeaponPick(category, "weaponBuff", "OPT_WEAPON_PICK", false)
    end
end
function WeaponSection.prototype.addWeaponPick(self, category, key, label, isOffhand)
    self.controls:addDropdown(
        category,
        key,
        self.locale:getText(label),
        self.locale:getText("TIP_WEAPON_PICK"),
        "auto",
        function()
            local picked = __TS__ArrayFind(
                self.weaponChoice:getWeaponChoices(),
                function(____, entry) return entry.key == self.settings:get(key) end
            )
            return picked and self.weaponChoice:isWeaponBuffLearned(picked) and picked.key or "auto"
        end,
        function(value) return self.settings:change(key, value ~= "auto" and value or nil) end,
        function()
            local auto = self.weaponChoice:findAutomaticWeaponBuff(isOffhand)
            local autoLabel = auto and ((self.locale:getText("OPT_AUTOMATIC") .. " (") .. (auto.entry.name or self.spells:getSpellLabel(auto.entry.id) or auto.entry.key)) .. ")" or self.locale:getText("OPT_AUTOMATIC")
            local list = {{"auto", autoLabel}}
            for ____, entry in ipairs(self.weaponChoice:getWeaponChoices()) do
                if self.weaponChoice:isWeaponBuffLearned(entry) then
                    list[#list + 1] = {
                        entry.key,
                        entry.name or self.spells:getSpellLabel(entry.id) or entry.key
                    }
                end
            end
            return list
        end
    )
end
return ____exports
 end,
["addons.glowing-bars.src.options.reminders_page"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySome = ____lualib.__TS__ArraySome
local ____exports = {}
____exports.RemindersPage = __TS__Class()
local RemindersPage = ____exports.RemindersPage
RemindersPage.name = "RemindersPage"
function RemindersPage.prototype.____constructor(self, locale, classBuffs, settings, controls, reminderControls, weaponSection, glowsSection, about, widgets, ____table, barsSection, animationSection)
    self.locale = locale
    self.classBuffs = classBuffs
    self.settings = settings
    self.controls = controls
    self.reminderControls = reminderControls
    self.weaponSection = weaponSection
    self.glowsSection = glowsSection
    self.about = about
    self.widgets = widgets
    self.table = ____table
    self.barsSection = barsSection
    self.animationSection = animationSection
end
function RemindersPage.prototype.buildPage(self, category, layout)
    self.reminderControls:addHeader(layout, "HDR_REMINDERS")
    self.widgets:addButton(
        layout,
        self.locale:getText("OPT_TABLE"),
        self.locale:getText("BTN_OPEN"),
        function() return self.table:toggle() end,
        self.locale:getText("TIP_TABLE")
    )
    self.controls:addSwitchCheckbox(
        category,
        "showTooltipIds",
        self.locale:getText("OPT_TOOLTIP_IDS"),
        self.locale:getText("TIP_TOOLTIP_IDS")
    )
    self.animationSection:addAnimationSection(category)
    self.reminderControls:addHeader(layout, "HDR_CHARACTER")
    self.controls:addCheckbox(
        category,
        "isDisabled",
        self.locale:getText("OPT_DISABLE"),
        self.locale:getText("TIP_DISABLE"),
        false,
        function() return self.settings:get("isDisabled") end,
        function(isChecked) return self.settings:change("isDisabled", isChecked) end
    )
    self.reminderControls:addSwitch(category, "shouldStayQuietInTowns", "OPT_STAY_QUIET_IN_TOWNS", "TIP_STAY_QUIET_IN_TOWNS")
    if __TS__ArraySome(
        self.classBuffs:getClassBuffs(),
        function(____, classBuff) return classBuff.party ~= nil end
    ) then
        self.reminderControls:addHeader(layout, "HDR_BUFFS")
        local hasGroupVersion = __TS__ArraySome(
            self.classBuffs:getClassBuffs(),
            function(____, classBuff)
                local ____opt_0 = classBuff.party
                return (____opt_0 and ____opt_0.groupIds) ~= nil
            end
        )
        local partySwitch = self.reminderControls:addSwitch(category, "showPartyBuffs", "OPT_PARTY_BUFFS", "TIP_PARTY_BUFFS")
        if hasGroupVersion then
            self.reminderControls:addGroupMin(
                category,
                "partyGroupFrom",
                "TIP_PARTY_GROUP_MIN",
                partySwitch,
                "showPartyBuffs"
            )
        end
        local raidSwitch = self.reminderControls:addSwitch(category, "showRaidBuffs", "OPT_RAID_BUFFS", "TIP_RAID_BUFFS")
        if hasGroupVersion then
            self.reminderControls:addGroupMin(
                category,
                "raidGroupFrom",
                "TIP_RAID_GROUP_MIN",
                raidSwitch,
                "showRaidBuffs"
            )
        end
    end
    self.weaponSection:addWeaponSection(category, layout)
    self.glowsSection:addGlowsSection(category, layout)
    self.barsSection:addBarsSection(category, layout)
    self.barsSection:addFadedSection(category, layout)
    self.about:addAboutSection(layout)
end
return ____exports
 end,
["addons.glowing-bars.src.tick.display_service"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__DecorateLegacy = ____lualib.__TS__DecorateLegacy
local ____exports = {}
local ____core = require("packages.@wowkit.core.src.index")
local OnEvent = ____core.OnEvent
____exports.DisplayService = __TS__Class()
local DisplayService = ____exports.DisplayService
DisplayService.name = "DisplayService"
function DisplayService.prototype.____constructor(self, shower, ticker)
    self.shower = shower
    self.ticker = ticker
end
function DisplayService.prototype.redrawAfterSpellBook(self)
    self.shower:markGlowsStale()
    self.ticker:tick()
end
__TS__DecorateLegacy(
    {OnEvent("spellbook.indexed")},
    DisplayService.prototype,
    "redrawAfterSpellBook",
    true
)
function DisplayService.prototype.redrawAfterBarsMapped(self)
    self.shower:markGlowsStale()
end
__TS__DecorateLegacy(
    {OnEvent("bars.mapped")},
    DisplayService.prototype,
    "redrawAfterBarsMapped",
    true
)
function DisplayService.prototype.redrawAfterSettingChange(self, key)
    self.shower:redrawGlowsAfterSettingChange(key)
    self.ticker:tick()
end
__TS__DecorateLegacy(
    {OnEvent("setting.changed")},
    DisplayService.prototype,
    "redrawAfterSettingChange",
    true
)
return ____exports
 end,
["addons.glowing-bars.src.addon"] = function(...) 
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local makeGame, makeTexts, makeBuffs, makeReminders, makeTick, makeTable, makeOptions
local ____core = require("packages.@wowkit.core.src.index")
local Addon = ____core.Addon
local ____ui = require("packages.@wowkit.ui.src.index")
local AboutSection = ____ui.AboutSection
local ControlsService = ____ui.ControlsService
local GreetingService = ____ui.GreetingService
local LocaleService = ____ui.LocaleService
local MessagesService = ____ui.MessagesService
local OptionsService = ____ui.OptionsService
local SettingsService = ____ui.SettingsService
local WidgetsService = ____ui.WidgetsService
local ____wow = require("packages.@wowkit.wow.src.index")
local ActionBarsService = ____wow.ActionBarsService
local AurasService = ____wow.AurasService
local BagsService = ____wow.BagsService
local BarFadeService = ____wow.BarFadeService
local BarRefreshService = ____wow.BarRefreshService
local ButtonRegistryService = ____wow.ButtonRegistryService
local ClockService = ____wow.ClockService
local CooldownsService = ____wow.CooldownsService
local GlowService = ____wow.GlowService
local NoticeService = ____wow.NoticeService
local PartyService = ____wow.PartyService
local PlayerService = ____wow.PlayerService
local SavedVariablesService = ____wow.SavedVariablesService
local SpellBookService = ____wow.SpellBookService
local SpellCastService = ____wow.SpellCastService
local SpellDetailsService = ____wow.SpellDetailsService
local SpellRefreshService = ____wow.SpellRefreshService
local SpellsService = ____wow.SpellsService
local TooltipService = ____wow.TooltipService
local WeaponEnchantsService = ____wow.WeaponEnchantsService
local ____public_2Dapi = require("addons.glowing-bars.src.api.public-api")
local registerPublicApi = ____public_2Dapi.registerPublicApi
local ____aura_2Dwatch_2Eservice = require("addons.glowing-bars.src.character.aura-watch_service")
local AuraWatchService = ____aura_2Dwatch_2Eservice.AuraWatchService
local ____blocked_2Daction_2Eservice = require("addons.glowing-bars.src.character.blocked-action_service")
local BlockedActionService = ____blocked_2Daction_2Eservice.BlockedActionService
local ____buff_2Dmemory_2Eservice = require("addons.glowing-bars.src.character.buff-memory_service")
local BuffMemoryService = ____buff_2Dmemory_2Eservice.BuffMemoryService
local ____buff_2Dstate_2Eservice = require("addons.glowing-bars.src.character.buff-state_service")
local BuffStateService = ____buff_2Dstate_2Eservice.BuffStateService
local ____equipment_2Eservice = require("addons.glowing-bars.src.character.equipment_service")
local EquipmentService = ____equipment_2Eservice.EquipmentService
local ____idle_2Eservice = require("addons.glowing-bars.src.character.idle_service")
local IdleService = ____idle_2Eservice.IdleService
local ____roster_2Eservice = require("addons.glowing-bars.src.character.roster_service")
local RosterService = ____roster_2Eservice.RosterService
local ____cooldown_2Dtracker_2Eservice = require("addons.glowing-bars.src.glows.cooldown-tracker_service")
local CooldownTrackerService = ____cooldown_2Dtracker_2Eservice.CooldownTrackerService
local ____added_2Dspells_2Eservice = require("addons.glowing-bars.src.glows.added-spells_service")
local AddedSpellsService = ____added_2Dspells_2Eservice.AddedSpellsService
local ____glow_2Dcues_2Eservice = require("addons.glowing-bars.src.glows.glow-cues_service")
local GlowCuesService = ____glow_2Dcues_2Eservice.GlowCuesService
local ____buff_2Dknowledge_2Eservice = require("addons.glowing-bars.src.knowledge.buff-knowledge_service")
local BuffKnowledgeService = ____buff_2Dknowledge_2Eservice.BuffKnowledgeService
local ____texts_2Econstants = require("addons.glowing-bars.src.locale.texts_constants")
local TEXTS = ____texts_2Econstants.TEXTS
local ____bars_2Esection = require("addons.glowing-bars.src.options.bars_section")
local BarsSection = ____bars_2Esection.BarsSection
local ____animation_2Esection = require("addons.glowing-bars.src.options.animation_section")
local AnimationSection = ____animation_2Esection.AnimationSection
local ____glows_2Esection = require("addons.glowing-bars.src.options.glows_section")
local GlowsSection = ____glows_2Esection.GlowsSection
local ____id_2Dtooltip_2Eservice = require("addons.glowing-bars.src.options.id-tooltip_service")
local IdTooltipService = ____id_2Dtooltip_2Eservice.IdTooltipService
local ____reminder_2Dcontrols_2Eservice = require("addons.glowing-bars.src.options.reminder-controls_service")
local ReminderControlsService = ____reminder_2Dcontrols_2Eservice.ReminderControlsService
local ____style_2Dchoices_2Eservice = require("addons.glowing-bars.src.options.style-choices_service")
local StyleChoicesService = ____style_2Dchoices_2Eservice.StyleChoicesService
local ____style_2Dedits_2Eservice = require("addons.glowing-bars.src.options.style-edits_service")
local StyleEditsService = ____style_2Dedits_2Eservice.StyleEditsService
local ____style_2Drows_2Eservice = require("addons.glowing-bars.src.options.style-rows_service")
local StyleRowsService = ____style_2Drows_2Eservice.StyleRowsService
local ____style_2Dtable_2Eservice = require("addons.glowing-bars.src.options.style-table_service")
local StyleTableService = ____style_2Dtable_2Eservice.StyleTableService
local ____style_2Dwindow_2Eservice = require("addons.glowing-bars.src.options.style-window_service")
local StyleWindowService = ____style_2Dwindow_2Eservice.StyleWindowService
local ____table_2Dcommand = require("addons.glowing-bars.src.options.table-command")
local TableCommand = ____table_2Dcommand.TableCommand
local ____reminders_2Epage = require("addons.glowing-bars.src.options.reminders_page")
local RemindersPage = ____reminders_2Epage.RemindersPage
local ____weapon_2Esection = require("addons.glowing-bars.src.options.weapon_section")
local WeaponSection = ____weapon_2Esection.WeaponSection
local ____reagents_2Eservice = require("addons.glowing-bars.src.reagents.reagents_service")
local ReagentsService = ____reagents_2Eservice.ReagentsService
local ____buff_2Dreminder_2Eservice = require("addons.glowing-bars.src.reminders.buff-reminder_service")
local BuffReminderService = ____buff_2Dreminder_2Eservice.BuffReminderService
local ____class_2Dbuffs_2Eservice = require("addons.glowing-bars.src.reminders.class-buffs_service")
local ClassBuffsService = ____class_2Dbuffs_2Eservice.ClassBuffsService
local ____added_2Dreminders_2Eservice = require("addons.glowing-bars.src.reminders.added-reminders_service")
local AddedRemindersService = ____added_2Dreminders_2Eservice.AddedRemindersService
local ____fed_2Dbuffs_2Eservice = require("addons.glowing-bars.src.reminders.fed-buffs_service")
local FedBuffsService = ____fed_2Dbuffs_2Eservice.FedBuffsService
local ____below_2Dlimits_2Eservice = require("addons.glowing-bars.src.reminders.below-limits_service")
local BelowLimitsService = ____below_2Dlimits_2Eservice.BelowLimitsService
local ____low_2Dstock_2Eservice = require("addons.glowing-bars.src.reminders.low-stock_service")
local LowStockService = ____low_2Dstock_2Eservice.LowStockService
local ____outdated_2Dranks_2Eservice = require("addons.glowing-bars.src.reminders.outdated-ranks_service")
local OutdatedRanksService = ____outdated_2Dranks_2Eservice.OutdatedRanksService
local ____seal_2Dreminder_2Eservice = require("addons.glowing-bars.src.reminders.seal-reminder_service")
local SealReminderService = ____seal_2Dreminder_2Eservice.SealReminderService
local ____tracking_2Dreminder_2Eservice = require("addons.glowing-bars.src.reminders.tracking-reminder_service")
local TrackingReminderService = ____tracking_2Dreminder_2Eservice.TrackingReminderService
local ____party_2Dbuffs_2Eservice = require("addons.glowing-bars.src.reminders.party-buffs_service")
local PartyBuffsService = ____party_2Dbuffs_2Eservice.PartyBuffsService
local ____weapon_2Dchoice_2Eservice = require("addons.glowing-bars.src.reminders.weapon.weapon-choice_service")
local WeaponChoiceService = ____weapon_2Dchoice_2Eservice.WeaponChoiceService
local ____weapon_2Dmemory_2Eservice = require("addons.glowing-bars.src.reminders.weapon.weapon-memory_service")
local WeaponMemoryService = ____weapon_2Dmemory_2Eservice.WeaponMemoryService
local ____weapon_2Dreading_2Eservice = require("addons.glowing-bars.src.reminders.weapon.weapon-reading_service")
local WeaponReadingService = ____weapon_2Dreading_2Eservice.WeaponReadingService
local ____weapon_2Dreminder_2Eservice = require("addons.glowing-bars.src.reminders.weapon.weapon-reminder_service")
local WeaponReminderService = ____weapon_2Dreminder_2Eservice.WeaponReminderService
local ____settings_2Econstants = require("addons.glowing-bars.src.settings.settings_constants")
local SAVED_VARIABLES_NAME = ____settings_2Econstants.SAVED_VARIABLES_NAME
local createDefaultSettings = ____settings_2Econstants.createDefaultSettings
local repairSettings = ____settings_2Econstants.repairSettings
local ____style_2Eservice = require("addons.glowing-bars.src.settings.style_service")
local StyleService = ____style_2Eservice.StyleService
local ____enabled_2Eservice = require("addons.glowing-bars.src.settings.enabled_service")
local EnabledService = ____enabled_2Eservice.EnabledService
local ____display_2Eservice = require("addons.glowing-bars.src.tick.display_service")
local DisplayService = ____display_2Eservice.DisplayService
local ____find_2Dreminders_2Eservice = require("addons.glowing-bars.src.tick.find-reminders_service")
local FindRemindersService = ____find_2Dreminders_2Eservice.FindRemindersService
local ____notices_2Eservice = require("addons.glowing-bars.src.tick.notices_service")
local NoticesService = ____notices_2Eservice.NoticesService
local ____refresh_2Eservice = require("addons.glowing-bars.src.tick.refresh_service")
local RefreshService = ____refresh_2Eservice.RefreshService
local ____show_2Dreminders_2Eservice = require("addons.glowing-bars.src.tick.show-reminders_service")
local ShowRemindersService = ____show_2Dreminders_2Eservice.ShowRemindersService
local ____tick_2Eservice = require("addons.glowing-bars.src.tick.tick_service")
local TickService = ____tick_2Eservice.TickService
function makeGame(addon, addonName)
    local clock = addon:register(__TS__New(ClockService))
    local player = addon:register(__TS__New(PlayerService))
    local party = addon:register(__TS__New(PartyService))
    local bags = addon:register(__TS__New(BagsService))
    local savedVariables = addon:register(__TS__New(SavedVariablesService, SAVED_VARIABLES_NAME))
    local spellBook = addon:register(__TS__New(SpellBookService, addon.events))
    local spells = addon:register(__TS__New(SpellsService, spellBook, addon.events))
    addon:register(__TS__New(SpellCastService, player, spells, addon.events))
    addon:register(__TS__New(SpellRefreshService, spells, clock, addon.events))
    local spellDetails = addon:register(__TS__New(SpellDetailsService))
    local cooldowns = addon:register(__TS__New(CooldownsService))
    local auras = addon:register(__TS__New(AurasService, spells))
    local buttonRegistry = addon:register(__TS__New(ButtonRegistryService))
    registerPublicApi(buttonRegistry)
    local actionBars = addon:register(__TS__New(
        ActionBarsService,
        clock,
        spells,
        addon.events,
        buttonRegistry
    ))
    local barRefresh = addon:register(__TS__New(BarRefreshService, actionBars, clock, buttonRegistry))
    local weaponEnchants = addon:register(__TS__New(WeaponEnchantsService))
    local glow = addon:register(__TS__New(GlowService, actionBars))
    local barFade = addon:register(__TS__New(BarFadeService, glow, buttonRegistry))
    local notice = addon:register(__TS__New(NoticeService, addonName))
    local tooltips = addon:register(__TS__New(TooltipService))
    return {
        clock = clock,
        player = player,
        party = party,
        bags = bags,
        savedVariables = savedVariables,
        spells = spells,
        spellDetails = spellDetails,
        cooldowns = cooldowns,
        auras = auras,
        actionBars = actionBars,
        barRefresh = barRefresh,
        weaponEnchants = weaponEnchants,
        glow = glow,
        barFade = barFade,
        notice = notice,
        tooltips = tooltips
    }
end
function makeTexts(addon, game)
    local settings = addon:register(__TS__New(
        SettingsService,
        game.savedVariables,
        addon.events,
        createDefaultSettings,
        repairSettings
    ))
    local locale = addon:register(__TS__New(LocaleService, TEXTS))
    local messages = addon:register(__TS__New(
        MessagesService,
        game.notice,
        locale:getText("TITLE")
    ))
    addon:register(__TS__New(
        GreetingService,
        messages,
        locale:getText("INIT")
    ))
    local styles = addon:register(__TS__New(StyleService, game.spells, settings))
    return {settings = settings, locale = locale, messages = messages, styles = styles}
end
function makeBuffs(addon, game, texts)
    local idle = addon:register(__TS__New(IdleService, game.player))
    local classBuffs = addon:register(__TS__New(ClassBuffsService, game.player, game.spells, texts.settings))
    local knowledge = addon:register(__TS__New(BuffKnowledgeService, classBuffs, game.spells))
    local memory = addon:register(__TS__New(BuffMemoryService, game.spells, game.clock, knowledge))
    local state = addon:register(__TS__New(
        BuffStateService,
        game.auras,
        game.spells,
        game.player,
        memory,
        knowledge
    ))
    return {idle = idle, classBuffs = classBuffs, state = state}
end
function makeReminders(addon, addonName, game, texts, buffs)
    local ____texts_0 = texts
    local settings = ____texts_0.settings
    local buff = addon:register(__TS__New(
        BuffReminderService,
        buffs.state,
        game.spells,
        game.player,
        game.actionBars,
        buffs.classBuffs,
        settings
    ))
    local limits = addon:register(__TS__New(BelowLimitsService, settings))
    local reagents = addon:register(__TS__New(ReagentsService, game.bags, game.spells, limits))
    local party = addon:register(__TS__New(
        PartyBuffsService,
        buffs.state,
        game.spells,
        game.clock,
        game.party,
        game.player,
        buffs.classBuffs,
        reagents,
        settings,
        buff
    ))
    local weaponChoice = addon:register(__TS__New(
        WeaponChoiceService,
        game.player,
        game.spells,
        settings,
        game.actionBars,
        game.bags
    ))
    local weaponMemory = addon:register(__TS__New(WeaponMemoryService))
    local weaponReading = addon:register(__TS__New(WeaponReadingService, buffs.state, game.weaponEnchants, weaponChoice))
    local weapon = addon:register(__TS__New(
        WeaponReminderService,
        game.clock,
        game.weaponEnchants,
        weaponChoice,
        weaponMemory,
        weaponReading
    ))
    local outdatedRanks = addon:register(__TS__New(OutdatedRanksService, game.actionBars, game.spells, settings))
    local addedSpells = addon:register(__TS__New(
        AddedSpellsService,
        game.spells,
        settings,
        game.cooldowns,
        reagents
    ))
    game.spells:useIdAlias(function(spellId) return addedSpells:getEffectiveId(spellId) end)
    local tracker = addon:register(__TS__New(CooldownTrackerService, game.spells, game.cooldowns, game.clock))
    local glowCues = addon:register(__TS__New(
        GlowCuesService,
        game.player,
        game.spells,
        game.spellDetails,
        game.actionBars,
        tracker,
        settings,
        addedSpells
    ))
    local fedBuffs = addon:register(__TS__New(
        FedBuffsService,
        addedSpells,
        game.spells,
        buffs.state,
        game.player,
        game.clock,
        settings,
        game.actionBars
    ))
    texts.styles:useOwnLooks(function(spellId) return fedBuffs:isFedSpell(spellId) end)
    local ____game_1 = game
    local spells = ____game_1.spells
    local actionBars = ____game_1.actionBars
    local weaponEnchants = ____game_1.weaponEnchants
    local bags = ____game_1.bags
    local added = addon:register(__TS__New(
        AddedRemindersService,
        addedSpells,
        spells,
        actionBars,
        buffs.state,
        weaponEnchants,
        bags,
        settings,
        reagents,
        fedBuffs
    ))
    local seal = addon:register(__TS__New(
        SealReminderService,
        game.spells,
        game.actionBars,
        buffs.state,
        game.player,
        settings,
        addedSpells
    ))
    local tracking = addon:register(__TS__New(
        TrackingReminderService,
        game.spells,
        game.actionBars,
        buffs.state,
        settings,
        addedSpells
    ))
    return {
        buff = buff,
        reagents = reagents,
        party = party,
        weaponChoice = weaponChoice,
        weapon = weapon,
        outdatedRanks = outdatedRanks,
        glowCues = glowCues,
        addedSpells = addedSpells,
        added = added,
        fedBuffs = fedBuffs,
        limits = limits,
        seal = seal,
        tracking = tracking
    }
end
function makeTick(addon, addonName, game, texts, buffs, reminders)
    local ____texts_2 = texts
    local settings = ____texts_2.settings
    local locale = ____texts_2.locale
    local messages = ____texts_2.messages
    local styles = ____texts_2.styles
    local finder = addon:register(__TS__New(
        FindRemindersService,
        addon:register(__TS__New(
            LowStockService,
            reminders.addedSpells,
            game.bags,
            reminders.limits,
            settings
        )),
        game.actionBars,
        buffs.idle,
        game.player,
        game.spells,
        reminders.buff,
        reminders.party,
        reminders.weapon,
        reminders.outdatedRanks,
        reminders.glowCues,
        reminders.reagents,
        reminders.added,
        reminders.seal,
        reminders.tracking,
        settings
    ))
    local notices = addon:register(__TS__New(
        NoticesService,
        game.actionBars,
        game.clock,
        game.notice,
        game.spells,
        locale,
        styles
    ))
    local ____reminders_3 = reminders
    local fedBuffs = ____reminders_3.fedBuffs
    local shower = addon:register(__TS__New(
        ShowRemindersService,
        game.glow,
        messages,
        settings,
        notices,
        styles,
        game.actionBars,
        game.barFade,
        game.clock,
        fedBuffs
    ))
    local tick = addon:register(__TS__New(
        TickService,
        finder,
        shower,
        game.player,
        styles,
        game.clock
    ))
    local refresh = addon:register(__TS__New(
        RefreshService,
        tick,
        shower,
        buffs.state,
        game.clock,
        game.barRefresh
    ))
    addon:register(__TS__New(DisplayService, shower, tick))
    addon:register(__TS__New(
        EquipmentService,
        refresh,
        game.player,
        game.weaponEnchants,
        reminders.weapon
    ))
    addon:register(__TS__New(AuraWatchService, refresh, buffs.state, reminders.weapon))
    addon:register(__TS__New(RosterService, refresh, reminders.party))
    addon:register(__TS__New(
        BlockedActionService,
        addonName,
        game.player,
        messages,
        locale
    ))
end
function makeTable(addon, addonName, game, texts, buffs, reminders)
    local ____texts_4 = texts
    local locale = ____texts_4.locale
    local messages = ____texts_4.messages
    local styles = ____texts_4.styles
    local rows = addon:register(__TS__New(
        StyleRowsService,
        game.player,
        game.spells,
        buffs.classBuffs,
        reminders.weaponChoice,
        reminders.reagents,
        locale,
        styles,
        reminders.glowCues,
        reminders.addedSpells,
        reminders.seal,
        reminders.tracking,
        reminders.fedBuffs
    ))
    local choices = addon:register(__TS__New(StyleChoicesService, locale, styles, messages))
    local windows = addon:register(__TS__New(StyleWindowService, locale, texts.settings))
    local switches = addon:register(__TS__New(
        EnabledService,
        game.spells,
        buffs.classBuffs,
        reminders.reagents,
        texts.settings
    ))
    local tableNotice = addon:register(__TS__New(NoticeService, addonName .. "-table"))
    local edits = addon:register(__TS__New(
        StyleEditsService,
        locale,
        reminders.addedSpells,
        tableNotice,
        switches,
        rows,
        styles,
        reminders.limits,
        reminders.reagents
    ))
    local ____table = addon:register(__TS__New(
        StyleTableService,
        locale,
        styles,
        rows,
        messages,
        choices,
        windows,
        edits
    ))
    addon:register(__TS__New(TableCommand, ____table))
    return ____table
end
function makeOptions(addon, addonName, game, texts, buffs, reminders)
    local ____texts_5 = texts
    local settings = ____texts_5.settings
    local locale = ____texts_5.locale
    local messages = ____texts_5.messages
    local controls = addon:register(__TS__New(ControlsService, settings, messages, addonName))
    local widgets = addon:register(__TS__New(
        WidgetsService,
        messages,
        {
            copy = locale:getText("INFO_COPY"),
            copied = locale:getText("INFO_COPIED")
        }
    ))
    local reminderControls = addon:register(__TS__New(ReminderControlsService, controls, locale, settings))
    addon:register(__TS__New(IdTooltipService, game.tooltips, settings, locale))
    local weaponSection = addon:register(__TS__New(
        WeaponSection,
        locale,
        game.spells,
        reminders.weaponChoice,
        settings,
        controls,
        reminderControls
    ))
    local glowsSection = addon:register(__TS__New(GlowsSection, reminderControls, reminders.glowCues))
    local ____table = makeTable(
        addon,
        addonName,
        game,
        texts,
        buffs,
        reminders
    )
    local barsSection = addon:register(__TS__New(
        BarsSection,
        locale,
        settings,
        controls,
        reminderControls
    ))
    local animationSection = addon:register(__TS__New(AnimationSection, locale, settings, controls))
    local about = addon:register(__TS__New(
        AboutSection,
        widgets,
        {
            header = locale:getText("HDR_ABOUT"),
            githubLabel = locale:getText("INFO_GITHUB"),
            issuesLabel = locale:getText("INFO_ISSUES")
        },
        "https://github.com/vattiss/wowkit"
    ))
    local page = addon:register(__TS__New(
        RemindersPage,
        locale,
        buffs.classBuffs,
        settings,
        controls,
        reminderControls,
        weaponSection,
        glowsSection,
        about,
        widgets,
        ____table,
        barsSection,
        animationSection
    ))
    addon:register(__TS__New(
        OptionsService,
        messages,
        locale:getText("TITLE"),
        page
    ))
end
function ____exports.startAddon(addonName)
    local addon = __TS__New(Addon, addonName)
    local game = makeGame(addon, addonName)
    local texts = makeTexts(addon, game)
    local buffs = makeBuffs(addon, game, texts)
    local reminders = makeReminders(
        addon,
        addonName,
        game,
        texts,
        buffs
    )
    makeTick(
        addon,
        addonName,
        game,
        texts,
        buffs,
        reminders
    )
    makeOptions(
        addon,
        addonName,
        game,
        texts,
        buffs,
        reminders
    )
    addon:start()
end
return ____exports
 end,
["addons.glowing-bars.src.main"] = function(...) 
local ____exports = {}
local ____addon = require("addons.glowing-bars.src.addon")
local startAddon = ____addon.startAddon
local addonName = ...
startAddon(addonName)
return ____exports
 end,
}
local ____entry = require("addons.glowing-bars.src.main", ...)
return ____entry
