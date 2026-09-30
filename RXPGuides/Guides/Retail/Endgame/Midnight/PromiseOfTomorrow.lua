-- The Promise of Tomorrow, patch 12.1.5 PTR.
-- Converted from installed Pathwise route revision 11 (2026-09-09).
-- RestedXP route with a rescue display helper; no Pathwise dependency.
-- Keep the complete available route in chapter 1, matching the source and user-confirmed PTR availability.
-- Chapters 2 and 3 are menu placeholders until their quests become available.

-- Use the full rescue total for display while native scenario logic keeps
-- advancing each waypoint at its individual rescue threshold.
local _, guideAddon = ...
if type(guideAddon) == "table" and guideAddon.game == "RETAIL" then
    local nativeScenario = guideAddon.functions.scenario
    guideAddon.functions.events.promiseRescue = guideAddon.functions.events.scenario
    guideAddon.icons.promiseRescue = guideAddon.icons.scenario
    guideAddon.functions.events.promiseCombat = guideAddon.functions.events.scenario
    guideAddon.icons.promiseCombat = guideAddon.icons.combat
    guideAddon.functions.promiseCombat = guideAddon.functions.scenario
    function guideAddon.functions.promiseRescue(self, ...)
        local result = nativeScenario(self, ...)
        if type(self) == "string" then return result end
        local element = self.element
        if not element.step.active then return result end
        local info = C_ScenarioInfo.GetCriteriaInfoByStep(element.stage, element.criteriaIndex)
        if not info then return result end
        local total = info.totalQuantity and info.totalQuantity > 0 and info.totalQuantity or 7
        local quantity = info.quantity
        if quantity == nil then
            if not info.completed then return result end
            quantity = total
        end
        element.criteria = string.format("%s: %d/%d", info.description or "Civilians rescued",
            math.max(0, math.min(total, quantity)), total)
        if element.rawtext ~= "" then element.criteria = "\n" .. element.criteria end
        element.text = element.rawtext .. element.criteria
        return result
    end
end

RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#subgroup |cFFE74C3C(90)|r Max-Level Campaigns
#subweight 980
#name A) 12.1.5 The Promise of Tomorrow
#displayname The Promise of Tomorrow (12.1.5)
#chapters a) What Slept Below (Shared);b) Sins of the Past (Shared);c) To the Faithful (Shared)
step
+1
]])

RXPGuides.RegisterGuide([[
#retail
#version 10
#group RestedXP Midnight
#chapter
#name a) What Slept Below (Shared)
#displayname |cFF00CCFF1|r - What Slept Below
#next b) Sins of the Past (Shared)
-- 12.1.5 polish: standardized RXP icons/colors, concise quest rows, and descriptive arrow text.
step
#label ptr1215-001
#arrowtext Talk to\n|cRXP_FRIENDLY_Lor'themar Theron|r
.goto 2393,45.360,70.300
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lor'themar Theron|r.
.accept 95533 >>Accept The Aqir Swarm
.target 235787
step
#label ptr1215-002
#arrowtext Talk to\n|cRXP_FRIENDLY_Halduron Brightwing|r
.goto 2395,50.795,51.652
>>Use the |cRXP_WARN_[ExtraActionButton]|r, then |Tinterface/worldmap/chatbubble_64grey.blp:20|ttalk to |cRXP_FRIENDLY_Halduron Brightwing|r.
.complete 95533,1
.target 262944
.skipgossipid 139393
step
#label ptr1215-003
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2395,47.888,36.960
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r outside Silvermoon's walls.
.complete 95533,2
.target 262969
.skipgossipid 139397
step
#label ptr1215-003a
#arrowtext Enter the\n|cRXP_WARN_Silvermoon building|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2393,32.080,87.450,8
>>|cRXP_WARN_Enter the building|r before investigating the aqir corpse.
step
#label ptr1215-004
#arrowtext Investigate the\n|cRXP_PICK_Aqir Corpse|r
.goto 2393,31.674,88.315
>>|TInterface/cursor/crosshair/interact.blp:20|tInvestigate the |cRXP_PICK_Aqir Corpse|r inside the building.
.complete 95533,3
step
#label ptr1215-005
#arrowtext Talk to\n|cRXP_FRIENDLY_Arator|r
.goto 2393,31.547,88.376
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Arator|r.
.complete 95533,4
.target 261878
.skipgossipid 139162
step
#label ptr1215-006a
#arrowtext Kill\n|cRXP_ENEMY_Qinthix|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,32.314,87.361
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tKill |cRXP_ENEMY_Qinthix the Corpse Tearer|r.
.promiseCombat 17043,1,1
.mob Qinthix the Corpse Tearer
step
#label ptr1215-006b-1
#arrowtext Rescue a\n|cRXP_FRIENDLY_Silvermoon Civilian|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,34.650,86.490
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the next |cRXP_FRIENDLY_injured Silvermoon Civilian|r.
.promiseRescue 16877,1,1
step
#label ptr1215-006b-2
#arrowtext Rescue a\n|cRXP_FRIENDLY_Silvermoon Civilian|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,35.129,81.624
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the next |cRXP_FRIENDLY_injured Silvermoon Civilian|r.
.promiseRescue 16877,1,2
step
#label ptr1215-006b-3
#arrowtext Rescue a\n|cRXP_FRIENDLY_Silvermoon Civilian|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,35.174,79.865
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the next |cRXP_FRIENDLY_injured Silvermoon Civilian|r.
.promiseRescue 16877,1,3
step
#label ptr1215-006b-4
#arrowtext Rescue a\n|cRXP_FRIENDLY_Silvermoon Civilian|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,36.418,80.101
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the next |cRXP_FRIENDLY_injured Silvermoon Civilian|r.
.promiseRescue 16877,1,4
step
#label ptr1215-006b-5
#arrowtext Rescue a\n|cRXP_FRIENDLY_Silvermoon Civilian|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,37.837,80.938
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the next |cRXP_FRIENDLY_injured Silvermoon Civilian|r.
.promiseRescue 16877,1,5
step
#label ptr1215-006b-6
#arrowtext Rescue a\n|cRXP_FRIENDLY_Silvermoon Civilian|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,38.745,82.324
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the next |cRXP_FRIENDLY_injured Silvermoon Civilian|r.
.promiseRescue 16877,1,6
step
#label ptr1215-006b-7
#arrowtext Rescue a\n|cRXP_FRIENDLY_Silvermoon Civilian|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,40.247,82.798
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the next |cRXP_FRIENDLY_injured Silvermoon Civilian|r.
.promiseRescue 16877,1,7
step
#label ptr1215-006c
#arrowtext Reach the\n|cRXP_WARN_Front Gates|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,42.860,82.906
>>Reach the |cRXP_WARN_front gates of Silvermoon|r.
.scenario 16890,1,1
step
#label ptr1215-006d
#arrowtext Kill\n|cRXP_ENEMY_General Vixthek|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,45.322,89.709
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tKill |cRXP_ENEMY_General Vixthek|r.
.promiseCombat 16891,1,1
.mob General Vixthek
step
#label ptr1215-006e
#arrowtext Talk to\n|cRXP_FRIENDLY_Lor'themar Theron|r
.isOnQuest 95533
.isQuestNotComplete 95533
.goto 2605,45.683,89.631
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lor'themar Theron|r.
.complete 95533,5
.skipgossipid 139182
step
.isOnQuest 95533
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tFinish defending |cRXP_WARN_Silvermoon|r from the |cRXP_ENEMY_aqir|r.
.complete 95533,5
step
#label ptr1215-007
#arrowtext Talk to\n|cRXP_FRIENDLY_Lor'themar Theron|r
.goto 2393,45.417,70.411
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lor'themar Theron|r.
.turnin 95533 >>Turn in The Aqir Swarm
.target 235787
step
#label ptr1215-008
#arrowtext Talk to\n|cRXP_FRIENDLY_Lor'themar Theron|r
.goto 2393,45.417,70.411
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lor'themar Theron|r.
.accept 95187 >>Accept All Along the Watchtowers
.target 235787
step
#label ptr1215-009
#arrowtext Talk to\n|cRXP_FRIENDLY_Estelia Archtender|r
.goto 2393,39.300,80.160
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Estelia Archtender|r and view her wares.
.complete 95187,2
.target 266188
.skipgossipid 142260
step
#label ptr1215-010
#arrowtext Talk to\n|cRXP_FRIENDLY_Lord Solanar Bloodwrath|r
.goto 2393,39.136,80.030
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lord Solanar Bloodwrath|r about the aqir invasions.
.complete 95187,1
.target 266156
.skipgossipid 140062,140769
step
-- PTR 12.1.5 waypoint correction: Lady Liadrin is at 60.25, 81.39 in Eversong Woods.
#label ptr1215-011
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2395,60.25,81.39
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.turnin 95187 >>Turn in All Along the Watchtowers
.target 260155
step
#label ptr1215-012
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2395,60.25,81.39
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.accept 95190 >>Accept Double-Edged Swords
.target 260155
step
#label ptr1215-013
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2395,60.25,81.39
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.accept 95192 >>Accept Rendering Aid
.target 260155
step
#label ptr1215-014
#arrowtext Talk to\n|cRXP_FRIENDLY_Lor'themar Theron|r
.goto 2395,60.283,81.454
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lor'themar Theron|r.
.accept 95191 >>Accept The Slumbering Swarm
.target 260160
step
-- Route Arator first: he is directly on the path from Lady Liadrin/Lor'themar toward the Aqir objectives.
#label ptr1215-015
#arrowtext Talk to\n|cRXP_FRIENDLY_Arator|r
.goto 2395,60.934,80.882
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Arator|r and relay Lor'themar's orders.
.complete 95190,1
.target 260163
.skipgossipid 139157
step
#label ptr1215-016
#arrowtext Kill\n|cRXP_ENEMY_Aqir Hivetenders|r
.goto 2395,61.918,80.859
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tKill |cRXP_ENEMY_Aqir Hivetenders|r.
.complete 95191,3
.mob Aqir Hivetender
step
#label ptr1215-017
#arrowtext Kill\n|cRXP_ENEMY_Aqir Drones|r
.goto 2395,61.570,81.289
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tKill |cRXP_ENEMY_Aqir Drones|r.
.complete 95191,2
.mob Aqir Drone
step
#label ptr1215-018
#arrowtext Aid\n|cRXP_FRIENDLY_Amani Trolls|r
.goto 2395,61.014,80.573
>>|TInterface/cursor/crosshair/interact.blp:20|tAid |cRXP_FRIENDLY_Amani trolls|r in the area.
.complete 95192,1
step
#label ptr1215-019
#arrowtext Kill\n|cRXP_ENEMY_Aqir Scarabs|r
.goto 2395,60.723,80.740
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tKill |cRXP_ENEMY_Aqir Scarabs|r.
.complete 95191,1
.mob Aqir Scarab
step
#label ptr1215-020
#arrowtext Talk to\n|cRXP_FRIENDLY_Halduron Brightwing|r
.goto 2395,60.239,80.424
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Halduron Brightwing|r and relay Lor'themar's orders.
.complete 95190,2
.target 261088
.skipgossipid 139159
step
#label ptr1215-021
#arrowtext Talk to\n|cRXP_FRIENDLY_Orweyna|r
.goto 2395,60.471,83.693
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Orweyna|r and relay Lor'themar's orders.
.complete 95190,3
.target 260161
.skipgossipid 139158
step
#label ptr1215-022
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2395,62.450,81.471
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.turnin 95190 >>Turn in Double-Edged Swords
.target 260155
step
#label ptr1215-023
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2395,62.450,81.471
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.turnin 95192 >>Turn in Rendering Aid
.target 260155
step
#label ptr1215-024
#arrowtext Talk to\n|cRXP_FRIENDLY_Lor'themar Theron|r
.goto 2395,62.476,81.455
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lor'themar Theron|r.
.turnin 95191 >>Turn in The Slumbering Swarm
.target 260160
step
#label ptr1215-025
#arrowtext Talk to\n|cRXP_FRIENDLY_Lor'themar Theron|r
.goto 2395,62.476,81.455
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lor'themar Theron|r.
.accept 95193 >>Accept The Amani Impasse
.target 260160
.timer 43,RP
step
#label ptr1215-026
#arrowtext Talk to\n|cRXP_FRIENDLY_Lor'themar Theron|r
.goto 2395,62.476,81.455
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lor'themar Theron|r to signal the advance.
.complete 95193,1
.target 260160
.skipgossipid 138981
step
#label ptr1215-027
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2395,62.476,81.455
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r after the roleplay.
.turnin 95193 >>Turn in The Amani Impasse
.target 260155
step
#label ptr1215-028
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2395,62.476,81.455
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.accept 95197 >>Accept The Long Way Around
.target 260155
step
#label ptr1215-029
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2437,36.895,17.898
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tMeet |cRXP_FRIENDLY_Lady Liadrin|r in Zul'Aman.
.turnin 95197 >>Turn in The Long Way Around
.target 261975
step
#label ptr1215-030
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2437,36.895,17.898
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.accept 95199 >>Accept Tenuous Alliances
.target 261975
step
#label ptr1215-031
#arrowtext Talk to\n|cRXP_FRIENDLY_Zul'jarra|r
.goto 2437,36.895,17.898
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Zul'jarra|r.
.accept 95200 >>Accept An Offering for Halazzi
.target 260164
step
#label ptr1215-032
#arrowtext Click the\n|cRXP_PICK_Old Canoe|r
.goto 2437,35.479,17.488
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Old Canoe|r, then press |cRXP_WARN_Esc|r.
.complete 95199,1
*|cRXP_WARN_Credit is granted on the click; press Esc to cancel the channel.|r
.target 262008
step
#label ptr1215-033
#arrowtext Click the\n|cRXP_PICK_Basket of Ivy|r
.goto 2437,34.781,16.706
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Basket of Ivy|r, then press |cRXP_WARN_Esc|r.
.complete 95199,3
*|cRXP_WARN_Credit is granted on the click; press Esc to cancel the channel.|r
.target 262010
step
#label ptr1215-034
#arrowtext Click the\n|cRXP_PICK_Salt-Crusted Weaponry|r
.goto 2437,34.217,17.575
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Salt-Crusted Weaponry|r, then press |cRXP_WARN_Esc|r.
.complete 95199,4
*|cRXP_WARN_Credit is granted on the click; press Esc to cancel the channel.|r
.target 266078
step
#label ptr1215-035
#arrowtext Click the\n|cRXP_PICK_Discarded Oar|r
.goto 2437,33.211,15.706
>>|TInterface/cursor/crosshair/interact.blp:20|tClick the |cRXP_PICK_Discarded Oar|r, then press |cRXP_WARN_Esc|r.
.complete 95199,2
*|cRXP_WARN_Credit is granted on the click; press Esc to cancel the channel.|r
.target 262017
step
#label ptr1215-036
#arrowtext Collect\n|cRXP_LOOT_Fresh Beast Hearts|r
.goto 2437,31.974,14.810
>>Collect |cRXP_LOOT_6 Fresh Beast Hearts|r.
.complete 95200,1
step
#label ptr1215-037
#arrowtext Make the\n|cRXP_PICK_Offering for Halazzi|r
.goto 2437,35.462,17.558
>>|TInterface/cursor/crosshair/interact.blp:20|tMake the |cRXP_PICK_offering for Halazzi|r.
.complete 95200,2
step
#label ptr1215-038
#arrowtext Talk to\n|cRXP_FRIENDLY_Zul'jarra|r
.goto 2437,35.725,17.734
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Zul'jarra|r.
.turnin 95200 >>Turn in An Offering for Halazzi
.target 260164
step
#label ptr1215-039
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2437,35.806,17.664
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.turnin 95199 >>Turn in Tenuous Alliances
.target 260155
step
#label ptr1215-040
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2437,35.806,17.664
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.accept 95203 >>Accept The Ties That Bind
.target 260155
step
#label ptr1215-041
#arrowtext Travel to\n|cRXP_WARN_Atal'Utek|r
.goto 2437,38.036,13.646
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r and select the skip option if offered.
>>|TInterface/cursor/crosshair/interact.blp:20|tOtherwise, board the boat and sail to |cRXP_WARN_Atal'Utek|r.
.complete 95203,1
.skipgossipid 139857
step
#label ptr1215-042
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2512,24.687,58.326
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r on the Coiled Isle.
.turnin 95203 >>Turn in The Ties That Bind
.target 260155
step
#label ptr1215-043
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2512,24.687,58.326
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.accept 95208 >>Accept Back to Back
.target 260155
step
#label ptr1215-044
#arrowtext Talk to\n|cRXP_FRIENDLY_Halduron Brightwing|r
.goto 2512,24.764,58.172
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Halduron Brightwing|r.
.accept 95206 >>Accept Breaking the Blade
.target 261088
step
#label ptr1215-045
#arrowtext Assist\n|cRXP_FRIENDLY_Dak'zor and Arator|r
.goto 2512,26.036,61.063
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tHelp |cRXP_FRIENDLY_Dak'zor|r and |cRXP_FRIENDLY_Arator|r defeat the attackers.
.complete 95208,1
step
#label ptr1215-046
#arrowtext Defeat\n|cRXP_ENEMY_Twilight's Blade|r
.goto 2512,26.583,62.468
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tDefeat |cRXP_ENEMY_Twilight's Blade forces|r.
.complete 95206,1
step
#label ptr1215-046a
#arrowtext Enter the\n|cRXP_WARN_Coiled Isle building|r
.isOnQuest 95208
.isQuestNotComplete 95208
.goto 2512,29.520,63.280,8
>>|cRXP_WARN_Enter the building|r before assisting Lor'themar and Zul'jarra.
step
#label ptr1215-047
#arrowtext Assist\n|cRXP_FRIENDLY_Lor'themar and Zul'jarra|r
.goto 2512,29.573,62.618
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tHelp |cRXP_FRIENDLY_Lor'themar Theron|r and |cRXP_FRIENDLY_Zul'jarra|r defeat the attackers.
.complete 95208,2
step
#label ptr1215-048
#arrowtext Assist\n|cRXP_FRIENDLY_Tak'lejo and Halduron|r
.goto 2512,27.550,67.724
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tHelp |cRXP_FRIENDLY_Tak'lejo|r and |cRXP_FRIENDLY_Halduron Brightwing|r defeat the attackers.
.complete 95208,3
step
#label ptr1215-049
#arrowtext Assist\n|cRXP_FRIENDLY_Liadrin and Orweyna|r
.goto 2512,24.030,64.963
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tHelp |cRXP_FRIENDLY_Lady Liadrin|r and |cRXP_FRIENDLY_Orweyna|r defeat the attackers.
.complete 95208,4
step
#label ptr1215-050
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2512,28.940,65.042
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.turnin 95208 >>Turn in Back to Back
.target 274777
step
#label ptr1215-051
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2512,28.940,65.042
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.turnin 95206 >>Turn in Breaking the Blade
.target 274777
step
#label ptr1215-052
#arrowtext Talk to\n|cRXP_FRIENDLY_Halduron Brightwing|r
.goto 2512,28.894,64.945
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Halduron Brightwing|r.
.accept 95209 >>Accept The Unheard Voice
.target 261088
step
#label ptr1215-053
#arrowtext Break the\n|cRXP_PICK_Twilight Runes|r
.goto 2512,30.631,64.952
>>|TInterface/cursor/crosshair/interact.blp:20|tBreak the |cRXP_PICK_Interlocked Twilight Runes|r.
.complete 95209,1
.target 261139
step
#label ptr1215-054
#arrowtext Destroy the\n|cRXP_ENEMY_Twilight Barrier|r
.goto 2512,30.792,64.898
>>|TInterface/cursor/crosshair/interact.blp:20|tUse the |cRXP_PICK_Interlocked Twilight Runes|r to destroy the |cRXP_ENEMY_Twilight Barrier|r.
.complete 95209,2
.use 270342
*|cRXP_WARN_Use the rune item button when it appears.|r
step
#label ptr1215-055
#arrowtext Talk to\n|cRXP_FRIENDLY_Lor'themar Theron|r
.goto 2512,32.397,64.911
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lor'themar Theron|r.
.turnin 95209 >>Turn in The Unheard Voice
.target 260160
step
#label ptr1215-056
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2512,32.520,64.831
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.accept 95210 >>Accept In the Mouth of Madness
.target 260155
step
#label ptr1215-056a
#arrowtext Follow the route\n|cRXP_WARN_into the Vaults|r
.isOnQuest 95210
.isQuestNotComplete 95210
.goto 2512,32.550,64.900,6
>>|cRXP_WARN_Follow the route|r into the Vaults of Atal'Utek.
step
#label ptr1215-056b
#arrowtext Follow the route\n|cRXP_WARN_toward the Vault|r
.isOnQuest 95210
.isQuestNotComplete 95210
.goto 2512,33.520,64.920,6
>>|cRXP_WARN_Continue toward the vault|r.
step
#label ptr1215-056c
#arrowtext Follow the route\n|cRXP_WARN_toward the Vault|r
.isOnQuest 95210
.isQuestNotComplete 95210
.goto 2512,34.580,65.080,6
>>|cRXP_WARN_Continue toward the vault|r.
step
#label ptr1215-056d
#arrowtext Follow the route\n|cRXP_WARN_through the Passage|r
.isOnQuest 95210
.isQuestNotComplete 95210
.goto 2512,34.610,66.510,6
>>|cRXP_WARN_Continue through the passage|r.
step
#label ptr1215-056e
#arrowtext Follow the route\n|cRXP_WARN_to the Entrance|r
.isOnQuest 95210
.isQuestNotComplete 95210
.goto 2512,34.630,67.360,6
>>|cRXP_WARN_Continue into the vault entrance|r.
step
#label ptr1215-056f
#arrowtext Enter the\n|cRXP_WARN_Vaults of Atal'Utek|r
.isOnQuest 95210
.isQuestNotComplete 95210
.goto 2512,36.170,67.570,6
>>|cRXP_WARN_Enter the Vaults of Atal'Utek|r.
*|cRXP_WARN_Continue through the entrance until the zone changes to the Vaults of Atal'Utek.|r
step
#label ptr1215-057
#arrowtext Explore the\n|cRXP_WARN_Entrance Passage|r
.goto 2509,47.236,79.636
>>Explore the |cRXP_WARN_entrance passage|r.
.complete 95210,1
step
#label ptr1215-058
#arrowtext Survey the\n|cRXP_WARN_Central Rise|r
.goto 2509,47.112,53.393
>>Survey the |cRXP_WARN_central rise|r.
.complete 95210,2
.target 263102
step
#label ptr1215-059
#arrowtext Explore the\n|cRXP_WARN_Eastern Stairs|r
.goto 2509,49.269,53.846
>>Explore the |cRXP_WARN_eastern stairs|r.
.complete 95210,3
step
#label ptr1215-060
#arrowtext Explore the\n|cRXP_WARN_Eastern Hall|r
.goto 2509,54.223,40.468
>>Explore the |cRXP_WARN_eastern hall|r.
.complete 95210,4
step
#label ptr1215-061
#arrowtext Secure the\n|cRXP_WARN_Collapsed Bridge|r
.goto 2509,49.542,30.027
>>Secure the |cRXP_WARN_collapsed bridge|r.
.complete 95210,5
step
#label ptr1215-062
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2509,55.907,30.034
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.turnin 95210 >>Turn in In the Mouth of Madness
.target 265961
step
#label ptr1215-063
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2509,55.907,30.034
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.accept 96707 >>Accept In the Belly of the Beast
.target 265961
step
#label ptr1215-064
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2509,53.439,14.529
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r and choose |cRXP_WARN_Proceed|r.
.complete 96707,1
.target 275672
.skipgossipid 139370
step
#label ptr1215-065
#arrowtext Survive the\n|cRXP_ENEMY_Final Attack|r
.goto 2509,53.460,14.390
>>|TInterface/GossipFrame/BattleMasterGossipIcon:20|tSurvive the |cRXP_ENEMY_final attack|r.
.complete 96707,2
step
#label ptr1215-066
#arrowtext Talk to\n|cRXP_FRIENDLY_Lady Liadrin|r
.goto 2509,53.491,14.430
>>|Tinterface/worldmap/chatbubble_64grey.blp:20|tTalk to |cRXP_FRIENDLY_Lady Liadrin|r.
.turnin 96707 >>Turn in In the Belly of the Beast
.target 275672
]])

RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#chapter
#name b) Sins of the Past (Shared)
#displayname |cFF00CCFF2|r - Sins of the Past
step
#title Sins of the Past
>>Sins of the Past is not yet available on this PTR.
>>Only chapter 1, What Slept Below, is currently available.
+Return to chapter 1 to follow the available questline.
]])

RXPGuides.RegisterGuide([[
#retail
#version 1
#group RestedXP Midnight
#chapter
#name c) To the Faithful (Shared)
#displayname |cFF00CCFF3|r - To the Faithful
step
#title To the Faithful
>>To the Faithful is not yet available on this PTR.
>>Only chapter 1, What Slept Below, is currently available.
+Return to chapter 1 to follow the available questline.
]])

-- Blizzard returns to this NPC's gossip list after accepting the opening quest.
-- Close that one leftover list, only during the accept transition. Subsequent
-- conversations, other quests, and other guides retain their normal behavior.
local _, addon = ...
if type(addon) ~= "table" or addon.game ~= "RETAIL" then return end

local pendingAccept
local function isOpeningGuideActive()
    local guide = addon.currentGuide
    local profile = addon.settings and addon.settings.profile
    return guide and guide.group == "RestedXP Midnight"
        and guide.name == "a) What Slept Below (Shared)"
        and profile and profile.enableQuestAutomation
        and not addon.isHidden and not IsControlKeyDown()
end

local function closeAcceptedGossip(token)
    if pendingAccept ~= token then return end
    if GetTime() > token.expires or not isOpeningGuideActive() then
        pendingAccept = nil
        return
    end
    if not C_QuestLog.IsOnQuest(95533) then return end
    if not (GossipFrame and GossipFrame:IsShown()) then return end
    local guid = UnitGUID("npc")
    local npcID = guid and select(6, strsplit("-", guid))
    if tonumber(npcID) ~= 235787 then
        pendingAccept = nil
        return
    end
    pendingAccept = nil
    C_GossipInfo.CloseGossip()
end

local dialogueFrame = CreateFrame("Frame")
dialogueFrame:RegisterEvent("QUEST_ACCEPTED")
dialogueFrame:RegisterEvent("GOSSIP_SHOW")
dialogueFrame:RegisterEvent("QUEST_DETAIL")
dialogueFrame:SetScript("OnEvent", function(_, event, arg1, arg2)
    if event == "QUEST_DETAIL" then
        pendingAccept = nil
    elseif event == "QUEST_ACCEPTED" then
        pendingAccept = nil
        local questID = tonumber(arg2) or tonumber(arg1)
        if questID ~= 95533 or not isOpeningGuideActive() then return end
        pendingAccept = {expires = GetTime() + 1}
        local token = pendingAccept
        C_Timer.After(0, function() closeAcceptedGossip(token) end)
    elseif pendingAccept then
        local token = pendingAccept
        C_Timer.After(0, function() closeAcceptedGossip(token) end)
    end
end)
