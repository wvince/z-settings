------------------------------------------------------------
-- Tooltip Class Colors
------------------------------------------------------------

------------------------------------------------------------
-- Safe UnitIsPlayer
------------------------------------------------------------

local function IsPlayerUnit(unit)

    if not unit then
        return false
    end

    local success, result =
        pcall(
            UnitIsPlayer,
            unit
        )

    if success then
        return result == true
    end

    return false

end


------------------------------------------------------------
-- Safe UnitGUID
------------------------------------------------------------

local function GetUnitGUID(unit)

    local success, result =
        pcall(
            UnitGUID,
            unit
        )

    if success then
        return result
    end

end


------------------------------------------------------------
-- Safely get class for a unit
------------------------------------------------------------

local function GetUnitClass(unit)

    local success, _, englishClass =
        pcall(
            UnitClass,
            unit
        )

    if success then
        return englishClass
    end

end


------------------------------------------------------------
-- Get unit token from tooltip owner
------------------------------------------------------------

local function GetOwnerUnit(tooltip)

    local success, owner =
        pcall(
            tooltip.GetOwner,
            tooltip
        )

    if not success or not owner then
        return
    end

    local ownerSuccess, unit =
        pcall(
            function()
                return owner.unit
                    or (
                        owner.GetAttribute
                        and owner:GetAttribute("unit")
                    )
            end
        )

    if ownerSuccess then
        return unit
    end

end


------------------------------------------------------------
-- Get group member class by tooltip name
------------------------------------------------------------

local function GetGroupPlayerClassByName(unitName)

    if not unitName then
        return
    end

    local isRaid =
        IsInRaid()

    local groupSize =
        isRaid and GetNumGroupMembers() or 4

    local foundClass
    local foundUnit

    local nameSuccess, shortUnitName =
        pcall(
            string.match,
            unitName,
            "^[^-]+"
        )

    if not nameSuccess then
        shortUnitName = nil
    end

    for index = 1, groupSize do

        local groupUnit =
            (isRaid and "raid" or "party")
            .. index

        local memberName, realmName =
            UnitName(groupUnit)

        if memberName
            and (
                unitName == memberName
                or shortUnitName == memberName
                or (
                    realmName
                    and realmName ~= ""
                    and unitName == memberName .. "-" .. realmName
                )
            ) then

            local englishClass =
                GetUnitClass(groupUnit)

            if foundClass and foundClass ~= englishClass then
                return
            end

            if foundClass then
                foundUnit = nil
            else
                foundUnit = groupUnit
            end

            foundClass =
                englishClass

        end

    end

    return foundClass, foundUnit

end


------------------------------------------------------------
-- Get player class, including group roster fallback
------------------------------------------------------------

local function GetPlayerClass(unit, unitName)

    if IsPlayerUnit(unit) then

        local englishClass =
            GetUnitClass(unit)

        if englishClass then
            return englishClass, unit
        end

    end

    local success, englishClass, groupUnit =
        pcall(
            GetGroupPlayerClassByName,
            unitName
        )

    if success and englishClass then
        return englishClass, groupUnit or unit
    end

    if unit then
        local unitGUID =
            GetUnitGUID(unit)

        if unitGUID then

            local groupSize =
                GetNumGroupMembers()

            if IsInRaid() then

                for index = 1, groupSize do

                    local groupUnit =
                        "raid" .. index

                    if UnitGUID(groupUnit) == unitGUID then

                        local englishClass =
                            GetUnitClass(groupUnit)

                        return englishClass, groupUnit

                    end

                end

            else

                for index = 1, 4 do

                    local groupUnit =
                        "party" .. index

                    if UnitGUID(groupUnit) == unitGUID then

                        local englishClass =
                            GetUnitClass(groupUnit)

                        return englishClass, groupUnit

                    end

                end

            end

        end
    end

end


------------------------------------------------------------
-- Color Player Tooltip
------------------------------------------------------------

local function ColorTooltipUnit(tooltip)

    local unitName, unit =
        tooltip:GetUnit()

    if not unit then
        unit = GetOwnerUnit(tooltip)
    end

    if not unit and not unitName then
        return
    end


    --------------------------------------------------------
    -- Get player class.
    --------------------------------------------------------

    local englishClass =
        GetPlayerClass(unit, unitName)

    if not englishClass then
        return
    end


    local classColor =
        RAID_CLASS_COLORS[englishClass]

    if not classColor then
        return
    end


    --------------------------------------------------------
    -- Color player name.
    --------------------------------------------------------

    local nameText =
        _G[
            tooltip:GetName()
            .. "TextLeft1"
        ]

    if nameText then

        nameText:SetTextColor(
            classColor.r,
            classColor.g,
            classColor.b
        )

    end


    --------------------------------------------------------
    -- Color health bar.
    --------------------------------------------------------

    local statusBar =
        _G[
            tooltip:GetName()
            .. "StatusBar"
        ]
        or GameTooltipStatusBar

    if statusBar then

        statusBar:SetStatusBarColor(
            classColor.r,
            classColor.g,
            classColor.b
        )

        statusBar.lockColor = true
        statusBar:Show()

    end

end


------------------------------------------------------------
-- Tooltip Cleared
------------------------------------------------------------

local function OnTooltipCleared(tooltip)

    local statusBar =
        _G[
            tooltip:GetName()
            .. "StatusBar"
        ]
        or GameTooltipStatusBar

    if statusBar then

        statusBar.lockColor = false

    end

end


------------------------------------------------------------
-- Tooltip Hook
------------------------------------------------------------

if TooltipDataProcessor
    and TooltipDataProcessor.AddTooltipPostCall
    and Enum
    and Enum.TooltipDataType
    and Enum.TooltipDataType.Unit then

    TooltipDataProcessor.AddTooltipPostCall(
        Enum.TooltipDataType.Unit,
        ColorTooltipUnit
    )

else

    GameTooltip:HookScript(
        "OnTooltipSetUnit",
        ColorTooltipUnit
    )

end


------------------------------------------------------------
-- Tooltip Cleared Hook
------------------------------------------------------------

GameTooltip:HookScript(
    "OnTooltipCleared",
    OnTooltipCleared
)