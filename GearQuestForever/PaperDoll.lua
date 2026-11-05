local _, GQ = ...

GQ.PaperDoll = GQ.PaperDoll or {}

function GQ.PaperDoll:Init()
    if self.initialized then
        return
    end
    self.initialized = true

    local slots = GQ.Data and GQ.Data.PAPER_DOLL_SLOTS
    if not slots then
        return
    end

    for _, slotName in ipairs(slots) do
        local button = _G["Character" .. slotName .. "Slot"]
        if button and not button.GearQuestHooked then
            button.GearQuestHooked = true
            button:HookScript("OnClick", function(self, mouseButton)
                local gq = _G.GearQuest
                if mouseButton == "RightButton" and CharacterFrame and CharacterFrame:IsShown() then
                    if slotName == "SecondaryHand" and gq and gq.Data and gq.Log then
                        local offOn = gq.Log.WeaponStyleEnabled and gq.Log:WeaponStyleEnabled("off")
                        local shield = gq.Data.OffHandShowsShieldOrHeld and gq.Data:OffHandShowsShieldOrHeld()
                        local dual = gq.Data.CanDualWield and gq.Data:CanDualWield()
                        -- A damaging off hand opens when Off Hand is on and the spec
                        -- can dual wield. Shamans cannot. Shields still open here.
                        if not shield and not (dual and offOn) then
                            return
                        end
                    end
                    if gq and gq.Popup then
                        gq.Popup:ShowForSlot(slotName, self)
                    end
                    return
                end
                if gq and gq.Popup and gq.Popup.container and gq.Popup.container:IsShown() then
                    gq.Popup:Hide()
                end
            end)
        end
    end
end
