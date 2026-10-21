-- Forever Companion — TalentFrame.lua v1.5.0
-- Positions: wowtbc.gg (correctes) | Icônes: NRC TBC_TalentData.lua

local FC = ForeverCompanion
-- Arbres de talents (FC.TalentTrees) et builds BiS (FC.TalentBuilds) :
-- données générées par le Studio (Data/Talents.lua). Clés de classe en minuscules.

-- Localisation
local _L = {
    not_required = "Not required in this build",
    bis_points   = "BiS Points: %d / %d",
    prev         = "< Previous",
    next         = "Next >",
    auto         = "chosen for your level",
    rotation     = "Rotation",
}
local function InitLocale()
    local locale = GetLocale()
    if locale == "frFR" then
        _L.not_required = "Non requis dans ce build"
        _L.bis_points   = "Points BiS : %d / %d"
        _L.prev         = "< Précédent"
        _L.next         = "Suivant >"
        _L.auto         = "choisi selon ton niveau"
    elseif locale == "deDE" then
        _L.not_required = "In diesem Build nicht benötigt"
        _L.bis_points   = "BiS-Punkte: %d / %d"
        _L.prev         = "< Zurück"
        _L.next         = "Weiter >"
    elseif locale == "esES" or locale == "esMX" then
        _L.not_required = "No requerido en esta build"
        _L.bis_points   = "Puntos BiS: %d / %d"
        _L.prev         = "< Anterior"
        _L.next         = "Siguiente >"
    elseif locale == "ptBR" or locale == "ptPT" then
        _L.not_required = "Não necessário nesta build"
        _L.bis_points   = "Pontos BiS: %d / %d"
        _L.prev         = "< Anterior"
        _L.next         = "Seguinte >"
    elseif locale == "ruRU" then
        _L.not_required = "Не требуется в этой сборке"
        _L.bis_points   = "Очки BiS: %d / %d"
        _L.prev         = "< Назад"
        _L.next         = "Вперёд >"
    elseif locale == "koKR" then
        _L.not_required = "이 빌드에 필요하지 않음"
        _L.bis_points   = "BiS 포인트: %d / %d"
        _L.prev         = "< 이전"
        _L.next         = "다음 >"
    elseif locale == "zhCN" then
        _L.not_required = "此天赋树不需要"
        _L.bis_points   = "BiS点数: %d / %d"
        _L.prev         = "< 上一个"
        _L.next         = "下一个 >"
    elseif locale == "zhTW" then
        _L.not_required = "此天賦樹不需要"
        _L.bis_points   = "BiS點數: %d / %d"
        _L.prev         = "< 上一個"
        _L.next         = "下一個 >"
    end
end

local bisFrame        = nil
local talentBtns      = {}
local currentClass    = nil
local displayCn, displaySn = nil, nil
local currentBuilds   = nil
local currentBuildIdx = 1
local FRAME_W = 870
local FRAME_H = 680

local function GetPlayerClassAndSpec()
    if FC and FC.DetectPlayerSpec then
        local cn, sn = FC:DetectPlayerSpec()
        if cn and sn then return cn:lower(), sn end
    end
    local _, cn = UnitClass("player")
    if cn then cn = cn:lower() end
    return cn, nil
end

local function CreateBisFrame()
    local f = ForeverCompanionAPI.CreateWindow("ForeverCompanionTalentFrame",UIParent)
    f:SetSize(FRAME_W,FRAME_H)
    f:SetPoint("CENTER")
    f:SetFrameStrata("HIGH")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart",f.StartMoving)
    f:SetScript("OnDragStop",f.StopMovingOrSizing)
    ForeverCompanionAPI.CloseOnEscape(f)   -- fermeture par Échap
    f:Hide()

    f.title = ForeverCompanionAPI.WindowTitle(f)

    f.buildName = f:CreateFontString(nil,"OVERLAY","GameFontNormal")
    f.buildName:SetPoint("TOP",0,-28)
    f.buildName:SetTextColor(0.7,0.9,1)

    f.closeBtn = f.CloseButton

    f.prevBtn = ForeverCompanionAPI.CreateMenuButton(f,100,24)
    f.prevBtn:SetPoint("BOTTOMLEFT",12,14)
    f.prevBtn:SetText(_L.prev)
    f.prevBtn:Hide()

    f.nextBtn = ForeverCompanionAPI.CreateMenuButton(f,100,24)
    f.nextBtn:SetPoint("BOTTOMRIGHT",-12,14)
    f.nextBtn:SetText(_L.next)
    f.nextBtn:Hide()

    -- Rotation du build affiché, ouverte à gauche de la fenêtre (même choix de build)
    f.rotBtn = ForeverCompanionAPI.CreateMenuButton(f,100,24)
    f.rotBtn:SetText(_L.rotation)
    f.rotBtn:SetScript("OnClick",function() if FC.ToggleDockedRotation then FC:ToggleDockedRotation(f, displayCn, displaySn) end end)
    f.rotBtn:Hide()

    f.buildIdx = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    f.buildIdx:SetPoint("BOTTOM",0,18)
    f.buildIdx:SetTextColor(0.8,0.8,0.8)

    local s1 = FRAME_W*0.33333
    local s2 = FRAME_W*0.66666
    f.trees = {}
    for i = 1,3 do
        local tf = CreateFrame("Frame",nil,f)
        tf:SetClipsChildren(true)
        tf.topLeft     = tf:CreateTexture(nil,"BACKGROUND")
        tf.topRight    = tf:CreateTexture(nil,"BACKGROUND")
        tf.bottomLeft  = tf:CreateTexture(nil,"BACKGROUND")
        tf.bottomRight = tf:CreateTexture(nil,"BACKGROUND")
        tf.topLeft:SetPoint("TOPLEFT")
        tf.topRight:SetPoint("TOPLEFT",    tf.topLeft,"TOPRIGHT")
        tf.bottomLeft:SetPoint("TOPLEFT",  tf.topLeft,"BOTTOMLEFT")
        tf.bottomRight:SetPoint("TOPLEFT", tf.topLeft,"BOTTOMRIGHT")
        tf.label = tf:CreateFontString(nil,"OVERLAY","Game11Font")
        tf.label:SetPoint("TOP",0,-8)
        tf.ptsFS = tf:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        tf.ptsFS:SetPoint("LEFT",tf.label,"RIGHT",4,0)
        tf.ptsFS:SetTextColor(0.6,0.9,1)
        f.trees[i] = tf
    end
    f.trees[1]:SetPoint("TOPLEFT",6,-46)
    f.trees[1]:SetPoint("BOTTOMRIGHT",f,"BOTTOMLEFT",s1,50)
    f.trees[2]:SetPoint("TOPLEFT",s1,-46)
    f.trees[2]:SetPoint("BOTTOMRIGHT",f,"BOTTOMLEFT",s2,50)
    f.trees[3]:SetPoint("TOPLEFT",s2,-46)
    f.trees[3]:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-6,50)

    return f
end

local function AdjustBackground(tf, hOverride)
    local w = tf:GetWidth()
    local h = hOverride or tf:GetHeight()
    local tw = w/(256+44)
    local th = h/(256+75)
    tf.topLeft:SetSize(tw*256,th*256)
    tf.topRight:SetSize(tw*64,th*256)
    tf.bottomLeft:SetSize(tw*256,th*128)
    tf.bottomRight:SetSize(tw*64,th*128)
end

local function MakeBtn(parent)
    local btn = CreateFrame("Button",nil,parent)
    btn:SetSize(37,37)
    btn.tex = btn:CreateTexture(nil,"BORDER")
    btn.tex:SetAllPoints()
    local norm = btn:CreateTexture(nil,"BORDER")
    norm:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    norm:SetSize(64,64); norm:SetPoint("CENTER",0,-1)
    btn:SetNormalTexture(norm)
    local pushed = btn:CreateTexture(nil,nil)
    pushed:SetTexture("Interface\\Buttons\\UI-Quickslot-Depress")
    pushed:SetSize(36,36); pushed:SetPoint("CENTER")
    btn:SetPushedTexture(pushed)
    local hl = btn:CreateTexture(nil,"HIGHLIGHT")
    hl:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    hl:SetBlendMode("ADD"); hl:SetAllPoints()
    btn:SetHighlightTexture(hl)
    btn.outerTex = btn:CreateTexture(nil,"BACKGROUND")
    btn.outerTex:SetTexture("Interface\\Buttons\\UI-EmptySlot-White")
    btn.outerTex:SetSize(64,64); btn.outerTex:SetPoint("CENTER",0,-1)
    btn.rankBg = btn:CreateTexture(nil,"OVERLAY")
    btn.rankBg:SetTexture(136960)
    btn.rankBg:SetSize(20,20); btn.rankBg:SetPoint("BOTTOMRIGHT",8,-8)
    btn.rankFS = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    btn.rankFS:SetPoint("CENTER",btn.rankBg)
    btn:SetScript("OnLeave",function() GameTooltip:Hide() end)
    return btn
end

local function DisplayBuild(idx)
    if not currentBuilds or not bisFrame then return end
    idx = math.max(1,math.min(idx,#currentBuilds))
    currentBuildIdx = idx
    local build = currentBuilds[idx]
    local cn, sn = displayCn, displaySn
    if not cn then cn, sn = GetPlayerClassAndSpec() end
    local dispCn = cn and (cn:sub(1,1):upper()..cn:sub(2)) or "?"
    bisFrame.title:SetText("BiS Talents — "..(sn or "?").." "..dispCn)
    bisFrame.buildName:SetText(build.name)
    local _, _, isAuto = FC:GetBuildIndex(cn, sn)
    bisFrame.buildIdx:SetText("Build "..idx.." / "..#currentBuilds..((#currentBuilds > 1 and isAuto) and ("  ·  ".._L.auto) or ""))
    if #currentBuilds > 1 then bisFrame.prevBtn:Show(); bisFrame.nextBtn:Show()
    else bisFrame.prevBtn:Hide(); bisFrame.nextBtn:Hide() end
    bisFrame.rotBtn:ClearAllPoints()
    bisFrame.rotBtn:SetPoint("BOTTOMLEFT", #currentBuilds > 1 and 118 or 12, 14)
    if FC.HasRotation and FC:HasRotation(cn, sn) then bisFrame.rotBtn:Show() else bisFrame.rotBtn:Hide() end

    -- Reset boutons si classe changée
    if currentClass ~= cn then
        for t = 1,3 do
            if talentBtns[t] then
                for _,b in ipairs(talentBtns[t]) do b:Hide() end
            end
            talentBtns[t] = nil
        end
        currentClass = cn
    else
        for t = 1,3 do
            if talentBtns[t] then
                for _,b in ipairs(talentBtns[t]) do b:Hide() end
            end
        end
    end

    local classIconData = cn and FC.TalentTrees[cn]
    if not classIconData then return end

    -- offX centré sur 4 colonnes dans chaque arbre
    local treeW = FRAME_W / 3
    local offX = (treeW - 37) / 5   -- col1=1slot, col4=4slots, +1 marge
    -- offY distribué sur 9 rows avec marge haut/bas
    local offY = (FRAME_H - 38 + 45 - 80) / 10.0   -- espacement vertical des paliers
    -- Hauteur adaptée au nombre de paliers (7 sur WoW Forever, 9 sur TBC)
    local maxRow = 5
    for t = 1, 3 do
        for _, ti in ipairs((classIconData[t] or {}).talents or {}) do
            if ti.row and ti.row > maxRow then maxRow = ti.row end
        end
    end
    local treeH = maxRow * offY + 37 + 22
    bisFrame:SetHeight(46 + 50 + treeH)

    for tab = 1,3 do
        local treeData = classIconData[tab]
        if not treeData then break end
        local tf = bisFrame.trees[tab]

        -- Background
        local bgName = ForeverCompanionAPI.TalentBgName(treeData.bg)
        tf.topLeft:SetTexture("Interface\\TalentFrame\\"..bgName.."-TopLeft")
        tf.topRight:SetTexture("Interface\\TalentFrame\\"..bgName.."-TopRight")
        tf.bottomLeft:SetTexture("Interface\\TalentFrame\\"..bgName.."-BottomLeft")
        tf.bottomRight:SetTexture("Interface\\TalentFrame\\"..bgName.."-BottomRight")
        AdjustBackground(tf, treeH)
        tf.label:SetText("|cFFFFFF00"..treeData.treeName.."|r")

        local bisTalents = build.tabs[tab] or {}
        local bisPoints = 0
        for _,r in pairs(bisTalents) do bisPoints = bisPoints + r end
        tf.ptsFS:SetText(bisPoints>0 and "|cFF9CD6DE("..bisPoints..")|r" or "")

        if not talentBtns[tab] then talentBtns[tab] = {} end

        for i, talentInfo in ipairs(treeData.talents) do
            local idx0 = i - 1  -- index 0-based comme dans FC.TalentBuilds
            local btn = talentBtns[tab][i]
            if not btn then
                btn = MakeBtn(tf)
                talentBtns[tab][i] = btn
            end
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT",tf,"TOPLEFT",
                talentInfo.col * offX,
                -(talentInfo.row * offY))
            btn:Show()
            local API = ForeverCompanionAPI
            local tid = (talentInfo.id and API.SpellExists(talentInfo.id)) and talentInfo.id or nil
            local icon = tid and API.GetSpellIcon(tid) or talentInfo.icon
            if not icon or icon == 0 then
                -- Pas d'icône dans les données : celle du client si c'est la classe du joueur
                local _, playerClass = UnitClass("player")
                if playerClass and playerClass:lower() == cn then icon = ForeverCompanionAPI.FindTalentIcon(tab, talentInfo.name) end
            end
            btn.tex:SetTexture(icon and icon ~= 0 and icon or "Interface\\Icons\\INV_Misc_QuestionMark")

            local bisRanks = bisTalents[idx0]
            if bisRanks and bisRanks > 0 then
                btn.tex:SetDesaturated(false)
                btn.outerTex:SetVertexColor(1,0.84,0)
                btn.rankBg:Show(); btn.rankFS:Show()
                btn.rankFS:SetText(bisRanks)
                if bisRanks >= talentInfo.ranks then
                    btn.rankFS:SetTextColor(1,0.84,0)
                else
                    btn.rankFS:SetTextColor(0.4,1,0.4)
                end
            else
                btn.tex:SetDesaturated(true)
                btn.outerTex:SetVertexColor(0.5,0.5,0.5)
                btn.rankBg:Hide(); btn.rankFS:Hide()
            end

            btn.talentName = talentInfo.name
            btn.spellId    = tid
            btn.bisRanks   = bisRanks or 0
            btn.maxRanks   = talentInfo.ranks
            btn:SetScript("OnEnter",function(self)
                GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
                -- Info-bulle du sort (rang 1) si l'ID est connu, puis les points BiS
                if self.spellId and GameTooltip.SetSpellByID and pcall(GameTooltip.SetSpellByID, GameTooltip, self.spellId) then
                    GameTooltip:AddLine(" ")
                    if self.bisRanks>0 then
                        GameTooltip:AddLine(string.format(_L.bis_points, self.bisRanks, self.maxRanks),0.4,0.9,1)
                    else
                        GameTooltip:AddLine(_L.not_required,0.5,0.5,0.5)
                    end
                elseif self.bisRanks>0 then
                    GameTooltip:AddLine(self.talentName,1,0.84,0)
                    GameTooltip:AddLine(string.format(_L.bis_points, self.bisRanks, self.maxRanks),0.4,0.9,1)
                else
                    GameTooltip:AddLine(self.talentName,0.7,0.7,0.7)
                    GameTooltip:AddLine(_L.not_required,0.5,0.5,0.5)
                end
                GameTooltip:Show()
            end)
        end
    end
end

local function OpenBisTalentFrame(forceClass, forceSpec)
    if not bisFrame then
        bisFrame = CreateBisFrame()
        -- Choix partagé avec la fenêtre Rotation (et mémorisé)
        local function pick(i)
            if not currentBuilds then return end
            i = math.max(1, math.min(i, #currentBuilds))
            FC:SetBuildIndex(displayCn, displaySn, i)
            DisplayBuild(i)
        end
        bisFrame.prevBtn:SetScript("OnClick",function() pick(currentBuildIdx-1) end)
        bisFrame.nextBtn:SetScript("OnClick",function() pick(currentBuildIdx+1) end)
    end

    -- Re-détecter la spec à chaque ouverture (gère les changements de spé)
    currentClass = nil  -- forcer le reset des boutons
    currentBuilds = nil

    local cn, sn
    if forceClass and forceSpec then
        -- Classe/spec forcées (ex: sélection de la Bislist) — clés minuscules
        cn, sn = forceClass:lower(), forceSpec
    else
        cn, sn = GetPlayerClassAndSpec()
    end
    if not cn or not sn then
        print("|cFFFF6600Forever Companion|r : Spec non détectée."); return
    end
    local classBuilds = FC.TalentBuilds[cn]
    if not classBuilds then
        print("|cFFFF6600Forever Companion|r : Pas de données pour "..cn); return
    end
    currentBuilds = classBuilds[sn]
    if not currentBuilds or #currentBuilds==0 then
        print("|cFFFF6600Forever Companion|r : Pas de build BiS pour "..sn.." "..cn); return
    end
    -- Mémoriser pour le titre (DisplayBuild ne doit pas re-détecter)
    displayCn, displaySn = cn, sn
    currentBuildIdx = FC:GetBuildIndex(cn, sn) or 1
    bisFrame:Show(); bisFrame:Raise()
    DisplayBuild(currentBuildIdx)
end

-- Build changé ailleurs (fenêtre Rotation) : mise à jour si la même spé est affichée
function FC:RefreshTalentBuild(cn, sn)
    if not (bisFrame and bisFrame:IsShown() and currentBuilds and displayCn) then return end
    if displayCn ~= tostring(cn):lower() or displaySn ~= sn then return end
    local idx = FC:GetBuildIndex(cn, sn)
    if idx and idx ~= currentBuildIdx then DisplayBuild(idx) end
end

SLASH_FCTALENTS1 = "/fctalents"
SLASH_FCTALENTS2 = "/bistalents"
SlashCmdList["FCTALENTS"] = function() OpenBisTalentFrame() end
function FC:OpenBisTalentFrame() OpenBisTalentFrame() end
function FC:OpenBisTalentFrameForSpec(cn, sn) OpenBisTalentFrame(cn, sn) end

-- ============================================================
-- BOUTON "BiS Talents" dans le TalentFrame Blizzard
-- ============================================================
local bisTalentBtn = nil
-- Fenêtre de talents Blizzard selon le client : Classic (PlayerTalentFrame),
-- jeu actuel (PlayerSpellsFrame, ClassTalentFrame). Le premier trouvé est utilisé.
local TALENT_FRAMES = { "PlayerTalentFrame", "PlayerSpellsFrame", "ClassTalentFrame" }

local function CreateBisTalentButton()
    if bisTalentBtn then return end
    local host
    for _, name in ipairs(TALENT_FRAMES) do
        if _G[name] and _G[name].HookScript then host = _G[name]; break end
    end
    if not host then return end

    bisTalentBtn = CreateFrame("Button", "ForeverCompanionTalentBtn", UIParent, "UIPanelButtonTemplate")
    bisTalentBtn:SetSize(90, 22)
    bisTalentBtn:SetText("BiS Talents")
    bisTalentBtn:SetFrameStrata("DIALOG")
    bisTalentBtn:SetFrameLevel(100)
    -- Au-dessus du coin supérieur droit de la fenêtre de talents
    bisTalentBtn:SetPoint("BOTTOMRIGHT", host, "TOPRIGHT", 0, -2)
    bisTalentBtn:SetScript("OnClick", function()
        if bisFrame and bisFrame:IsShown() then
            bisFrame:Hide()
        else
            OpenBisTalentFrame()
        end
    end)
    ForeverCompanionAPI.AttachToFrame(bisTalentBtn, host)
    host:HookScript("OnHide", function() if bisFrame then bisFrame:Hide() end end)
end

local btnFrame = CreateFrame("Frame")
btnFrame:RegisterEvent("PLAYER_LOGIN")
btnFrame:RegisterEvent("ADDON_LOADED")
btnFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_LOGIN" then
        InitLocale()
    end
    -- La fenêtre de talents est chargée à la demande (Blizzard_TalentUI,
    -- Blizzard_PlayerSpells…) : on réessaie à chaque chargement d'addon.
    CreateBisTalentButton()
    if bisTalentBtn then self:UnregisterEvent("ADDON_LOADED") end
end)
