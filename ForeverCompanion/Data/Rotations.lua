-- Forever Companion — fichier généré par Forever Companion Studio.
-- NE PAS MODIFIER À LA MAIN : toute modification serait écrasée à la prochaine génération.

ForeverCompanionData = ForeverCompanionData or {}
local R = {}
ForeverCompanionData.rotations = R

R["Druid"] = {
  ["Balance"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Moonkin Form",id=24858},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Moonfire",id=8921},{t="text",v=" and "},{t="skill",v="Insect Swarm",id=5570},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Starfire",id=2912},{t="text",v=" with stacks of "},{t="skill",v="Eclipse",id=408248},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Wrath",id=5176},{t="text",v="."}},
    },
    aoe = {
    },
    intro = {{t="text",v="It seems like the Balance Druid rotation will center around the new talent "},{t="skill",v="Eclipse",id=408248},{t="text",v=" while maintaining your two dots. Boomkins now also provide a party-wide 3% crit buff that's exclusive with Leader of the Pack. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Maintain "},{t="skill",v="Moonfire",id=8921},{t="text",v=" and "},{t="skill",v="Insect Swarm",id=5570},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Starfire",id=2912},{t="text",v=" or "},{t="skill",v="Wrath",id=5176},{t="text",v="."}},
      }},
    },
  },
  ["Feral DPS"] = {
    single = {
      {{t="text",v="Maintain "},{t="skill",v="Faerie Fire (Feral)",id=770},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Berserk",id=417141},{t="text",v=" and any on-use effects."}},
      {{t="text",v="Cast "},{t="skill",v="Shred",id=5221},{t="text",v=" with "},{t="skill",v="Omen of Clarity",id=16864},{t="text",v=" procs."}},
      {{t="text",v="Cast "},{t="skill",v="Shifting Power",id=1322605},{t="text",v=" if below 60 energy."}},
      {{t="text",v="Maintain "},{t="skill",v="Rip",id=1079},{t="text",v=" at 5 Combo Points."}},
      {{t="text",v="Maintain "},{t="skill",v="Rake",id=1822},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Shred",id=5221},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Ferocious Bite",id=22568},{t="text",v=" if it won't delay a "},{t="skill",v="Rip",id=1079},{t="text",v="."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Feral DPS Druids now have the unique power shifting playstyle as a talent called "},{t="skill",v="Shifting Power",id=1322605},{t="text",v=", giving access to much needed energy generation. They also get access to a powerful cooldown with "},{t="skill",v="Berserk",id=417141},{t="text",v=". Finally, Ferals also provide a party-wide 3% crit buff that's exclusive with Moonkin Form. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Maintain "},{t="skill",v="Faerie Fire (Feral)",id=770},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Shred",id=5221},{t="text",v=" with "},{t="skill",v="Omen of Clarity",id=16864},{t="text",v=" procs."}},
        {{t="text",v="Cast "},{t="skill",v="Shifting Power",id=1322605},{t="text",v=" if below 60 energy."}},
        {{t="text",v="Maintain "},{t="skill",v="Rip",id=1079},{t="text",v=" at 5 Combo Points."}},
        {{t="text",v="Maintain "},{t="skill",v="Rake",id=1822},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Shred",id=5221},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Ferocious Bite",id=22568},{t="text",v=" if it won't delay a "},{t="skill",v="Rip",id=1079},{t="text",v="."}},
      }},
    },
  },
  ["Feral Tank"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Dire Bear Form",id=9634}},
      {{t="text",v="Cast "},{t="skill",v="Frenzied Regeneration",id=22842},{t="text",v=" as your emergency defensive cooldown."}},
      {{t="text",v="Cast "},{t="skill",v="Berserk",id=417141},{t="text",v=" with any on-use effects."}},
      {{t="text",v="Maintain 5 stacks of "},{t="skill",v="Lacerate",id=414644},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Faerie Fire (Feral)",id=770},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Demoralizing Roar",id=99},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Maul",id=6807},{t="text",v=" with excess rage."}},
      {{t="text",v="Cast "},{t="skill",v="Primal Bite",id=1238069},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Lacerate",id=414644},{t="text",v=" if under 5 stacks."}},
      {{t="text",v="Cast "},{t="skill",v="Swipe",id=769},{t="text",v="."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Feral Tank Druids gained access to 3 new abilities and a couple of reworked ones that make them much smoother to play. The new "},{t="skill",v="Frenzied Regeneration",id=22842},{t="text",v=" gives them access to a real defensive cooldown and "},{t="skill",v="Berserk",id=417141},{t="text",v=" to a powerful offensive one. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Dire Bear Form",id=9634}},
        {{t="text",v="Cast "},{t="skill",v="Frenzied Regeneration",id=22842},{t="text",v=" as your emergency defensive cooldown."}},
        {{t="text",v="Maintain 5 stacks of "},{t="skill",v="Lacerate",id=414644},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Faerie Fire (Feral)",id=770},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Demoralizing Roar",id=99},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Maul",id=6807},{t="text",v=" with excess rage."}},
        {{t="text",v="Cast "},{t="skill",v="Primal Bite",id=1238069},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Lacerate",id=414644},{t="text",v=" if under 5 stacks."}},
        {{t="text",v="Cast "},{t="skill",v="Swipe",id=769},{t="text",v="."}},
      }},
    },
  },
  ["Restoration"] = {
    single = {
      {{t="text",v="Cast "},{t="skill",v="Nature's Swiftness",id=16188},{t="text",v=" with "},{t="skill",v="Healing Touch",id=5185},{t="text",v=" for an instant emergency heal."}},
      {{t="text",v="Cast "},{t="skill",v="Tranquility",id=740},{t="text",v=" for AoE party-wide healing."}},
      {{t="text",v="Cast "},{t="skill",v="Wild Growth",id=408120},{t="text",v=" for AoE party-wide healing."}},
      {{t="text",v="Cast "},{t="skill",v="Swiftmend",id=18562},{t="text",v=" for an instant single-target heal."}},
      {{t="text",v="Maintain "},{t="skill",v="Rejuvenation",id=774},{t="text",v=" on as many targets as possible if large raid damage is coming."}},
      {{t="text",v="Maintain "},{t="skill",v="Rejuvenation",id=774},{t="text",v=" and "},{t="skill",v="Regrowth",id=8936},{t="text",v=" on tanks."}},
      {{t="text",v="Cast "},{t="skill",v="Regrowth",id=8936},{t="text",v=" or "},{t="skill",v="Healing Touch",id=5185},{t="text",v=" for single-target healing."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Restoration Druids will finally have access to frequent party-wide AoE healing via "},{t="skill",v="Wild Growth",id=408120},{t="text",v=". The new talents "},{t="skill",v="Gift of the Earthmother",id=414673},{t="text",v=" and "},{t="skill",v="Nature's Splendor",id=1223083},{t="text",v=" might make it possible to blanket the raid with "},{t="skill",v="Rejuvenation",id=774},{t="text",v=" efficiently. We don't know how downranking heals will work, so for now we will just list 1 version of each spell until we learn more. A lot is still unknown, but below is an idea of what the playstyle look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Cast "},{t="skill",v="Nature's Swiftness",id=16188},{t="text",v=" with "},{t="skill",v="Healing Touch",id=5185},{t="text",v=" for an instant emergency heal."}},
        {{t="text",v="Cast "},{t="skill",v="Tranquility",id=740},{t="text",v=" for AoE party-wide healing."}},
        {{t="text",v="Cast "},{t="skill",v="Swiftmend",id=18562},{t="text",v=" for an instant single-target heal."}},
        {{t="text",v="Maintain "},{t="skill",v="Rejuvenation",id=774},{t="text",v=" on as many targets as possible if large raid damage is coming."}},
        {{t="text",v="Maintain "},{t="skill",v="Regrowth",id=8936},{t="text",v=" on tanks."}},
        {{t="text",v="Cast "},{t="skill",v="Regrowth",id=8936},{t="text",v=" or "},{t="skill",v="Healing Touch",id=5185},{t="text",v=" for single-target healing."}},
      }},
    },
  },
}
R["Hunter"] = {
  ["Beast Mastery"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Aspect of the Hawk",id=13165}},
      {{t="text",v="Use "},{t="skill",v="Trueshot Aura",id=19506},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Hunter's Mark",id=1130},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Rapid Fire",id=3045},{t="text",v=", "},{t="skill",v="Bestial Wrath",id=19574},{t="text",v=", and any on-use effects."}},
      {{t="text",v="Cast "},{t="skill",v="Intimidation",id=19577},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Serpent Sting",id=1978},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Summon Hawk",id=1293241},{t="text",v=" if less than two are active."}},
      {{t="text",v="Cast "},{t="skill",v="Aimed Shot",id=19434},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Auto Shot",id=75},{t="text",v="."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Beast Mastery Hunters gain a new ability called "},{t="skill",v="Summon Hawk",id=1293241},{t="text",v=" and "},{t="skill",v="Intimidation",id=19577},{t="text",v=" now has a damage component to it. They can also access "},{t="skill",v="Trueshot Aura",id=19506},{t="text",v=" in the Marksmanship tree now. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Aspect of the Hawk",id=13165}},
        {{t="text",v="Maintain "},{t="skill",v="Hunter's Mark",id=1130},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Rapid Fire",id=3045},{t="text",v=" and any on-use effects."}},
        {{t="text",v="Maintain "},{t="skill",v="Serpent Sting",id=1978},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Summon Hawk",id=1293241},{t="text",v=" if less than two are active."}},
        {{t="text",v="Cast "},{t="skill",v="Aimed Shot",id=19434}},
        {{t="text",v=".\nCast "},{t="skill",v="Auto Shot",id=75},{t="text",v="."}},
      }},
    },
  },
  ["Marksmanship"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Aspect of the Hawk",id=13165}},
      {{t="text",v="Use "},{t="skill",v="Trueshot Aura",id=19506},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Hunter's Mark",id=1130},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Rapid Fire",id=3045},{t="text",v=" with any on-use effects."}},
      {{t="text",v="Maintain "},{t="skill",v="Serpent Sting",id=1978},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Sniper Shot",id=1310687},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Aimed Shot",id=19434}},
      {{t="text",v=".\nCast "},{t="skill",v="Auto Shot",id=75},{t="text",v="."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Marksmanship Hunters gain a new level 30 talent with "},{t="skill",v="Sniper Shot",id=1310687},{t="text",v=", "},{t="skill",v="Rapid Recuperation",id=1223987},{t="text",v=" to help with Mana, and "},{t="skill",v="Lone Wolf",id=415370},{t="text",v=" which gives you the option to play without a pet. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Aspect of the Hawk",id=13165}},
        {{t="text",v="Use "},{t="skill",v="Trueshot Aura",id=19506},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Hunter's Mark",id=1130},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Rapid Fire",id=3045},{t="text",v=" with any on-use effects."}},
        {{t="text",v="Maintain "},{t="skill",v="Serpent Sting",id=1978},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Aimed Shot",id=19434}},
        {{t="text",v=".\nCast "},{t="skill",v="Auto Shot",id=75},{t="text",v="."}},
      }},
    },
  },
  ["Survival"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Aspect of the Beast",id=13161},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Hunter's Mark",id=1130},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Rapid Fire",id=3045},{t="text",v=" with any on-use effects."}},
      {{t="text",v="Cast "},{t="skill",v="Mongoose Bite",id=1495},{t="text",v=" with "},{t="skill",v="Expose Prey",id=1310532},{t="text",v=" procs."}},
      {{t="text",v="Maintain "},{t="skill",v="Immolation Trap",id=13795},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Strider Kick",id=1317257},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Raptor Strike",id=2973},{t="text",v="."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Survival Hunters gain a full talent tree overhaul to turn them into a melee DPS. Their overall gameplay will revolve around "},{t="skill",v="Mongoose Bite",id=1495},{t="text",v=" procs and traps. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Aspect of the Beast",id=13161},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Hunter's Mark",id=1130},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Rapid Fire",id=3045},{t="text",v=" with any on-use effects."}},
        {{t="text",v="Maintain "},{t="skill",v="Immolation Trap",id=13795},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Strider Kick",id=1317257},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Raptor Strike",id=2973},{t="text",v="."}},
      }},
    },
  },
}
R["Mage"] = {
  ["Arcane"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Mage Armor",id=6117},{t="text",v=" or "},{t="skill",v="Molten Armor",id=428741},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Arcane Power",id=12042},{t="text",v=" with any on-use effects."}},
      {{t="text",v="Cast "},{t="skill",v="Arcane Missiles",id=5143},{t="text",v=" with "},{t="skill",v="Missile Barrage",id=400588},{t="text",v=" procs."}},
      {{t="text",v="Cast "},{t="skill",v="Arcane Wrath",id=1326082},{t="text",v=". Cast with "},{t="skill",v="Presence of Mind",id=12043},{t="text",v=" if available."}},
      {{t="text",v="Cast "},{t="skill",v="Arcane Blast",id=42896},{t="text",v=" if below 4 stacks."}},
      {{t="text",v="Cast "},{t="skill",v="Frostbolt",id=116},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Fire Blast",id=2136},{t="text",v=" or "},{t="skill",v="Arcane Explosion",id=1449},{t="text",v=" while moving."}},
    },
    aoe = {
    },
    intro = {{t="text",v="The Arcane Mage rotation will revolve around the new talent "},{t="skill",v="Missile Barrage",id=400588},{t="text",v=". You'll want to fish for procs by casting "},{t="skill",v="Arcane Blast",id=42896},{t="text",v=" and consume them with "},{t="skill",v="Arcane Missiles",id=5143},{t="text",v=". The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Cast "},{t="skill",v="Arcane Blast",id=42896},{t="text",v=" until 4 stacks."}},
        {{t="text",v="Cast "},{t="skill",v="Arcane Missiles",id=5143},{t="text",v=" with "},{t="skill",v="Missile Barrage",id=400588},{t="text",v=" procs."}},
        {{t="text",v="Cast "},{t="skill",v="Arcane Wrath",id=1326082},{t="text",v=". Cast with "},{t="skill",v="Presence of Mind",id=12043},{t="text",v=" if available."}},
        {{t="text",v="Cast "},{t="skill",v="Arcane Missiles",id=5143},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Fire Blast",id=2136},{t="text",v=" or "},{t="skill",v="Arcane Explosion",id=1449},{t="text",v=" while moving."}},
      }},
    },
  },
  ["Fire"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Molten Armor",id=428741},{t="text",v="."}},
      {{t="text",v="Maintain 5 stacks of "},{t="skill",v="Improved Scorch",id=11095},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Pyroblast",id=11366},{t="text",v=" with 3 stacks of "},{t="skill",v="Heating Up",id=400624},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Fire Blast",id=2136},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Frostfire Bolt",id=401502},{t="text",v="."}},
    },
    aoe = {
      {{t="text",v="Use "},{t="skill",v="Molten Armor",id=428741},{t="text",v="."}},
      {{t="text",v="Maintain 5 stacks of "},{t="skill",v="Improved Scorch",id=11095},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Pyroblast",id=11366},{t="text",v=" with 3 stacks of "},{t="skill",v="Heating Up",id=400624},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Arcane Missiles",id=5143},{t="text",v=" with "},{t="skill",v="Missile Barrage",id=400588},{t="text",v=" procs."}},
      {{t="text",v="Cast "},{t="skill",v="Fire Blast",id=2136},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Fireball",id=133},{t="text",v="."}},
    },
    intro = {{t="text",v="The Fire Mage rotation will revolve around the new talent "},{t="skill",v="Heating Up",id=400624},{t="text",v=". You'll want to fish for procs by casting "},{t="skill",v="Frostfire Bolt",id=401502},{t="text",v=" or "},{t="skill",v="Fireball",id=133},{t="text",v=" and consume them with "},{t="skill",v="Pyroblast",id=11366},{t="text",v=". We've opted for the FFB setup since you can double dip with Frost talents. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Cast "},{t="skill",v="Arcane Blast",id=42896},{t="text",v=" until 4 stacks."}},
        {{t="text",v="Maintain 5 stacks of "},{t="skill",v="Improved Scorch",id=11095},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Pyroblast",id=11366},{t="text",v=" with 3 stacks of "},{t="skill",v="Heating Up",id=400624},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Fire Blast",id=2136},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Fireball",id=133},{t="text",v="."}},
      }},
    },
  },
  ["Frost"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Molten Armor",id=428741},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Arcane Blast",id=42896},{t="text",v=" until 4 stacks."}},
      {{t="text",v="Cast "},{t="skill",v="Cone of Cold",id=120},{t="text",v=" with 5 stacks of "},{t="skill",v="Winter's Chill",id=11180},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Ice Lance",id=400640},{t="text",v=" with "},{t="skill",v="Fingers of Frost",id=400647},{t="text",v=" procs."}},
      {{t="text",v="Cast "},{t="skill",v="Frostbolt",id=116},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Ice Lance",id=400640},{t="text",v=" while moving."}},
    },
    aoe = {
    },
    intro = {{t="text",v="The Frost Mage rotation will revolve around the new talent "},{t="skill",v="Fingers of Frost",id=400647},{t="text",v=". You'll want to fish for procs by casting "},{t="skill",v="Frostbolt",id=116},{t="text",v=" and consume them with "},{t="skill",v="Ice Lance",id=400640},{t="text",v=". The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Cast "},{t="skill",v="Ice Lance",id=400640},{t="text",v=" with "},{t="skill",v="Fingers of Frost",id=400647},{t="text",v=" procs."}},
        {{t="text",v="Cast "},{t="skill",v="Arcane Missiles",id=5143},{t="text",v=" with "},{t="skill",v="Missile Barrage",id=400588},{t="text",v=" procs."}},
        {{t="text",v="Cast "},{t="skill",v="Frostbolt",id=116},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Fire Blast",id=2136},{t="text",v=" or "},{t="skill",v="Cone of Cold",id=120},{t="text",v=" while moving."}},
      }},
    },
  },
}
R["Paladin"] = {
  ["Holy"] = {
    single = {
      {{t="text",v="Use your assigned Aura."}},
      {{t="text",v="Use your assigned Blessing, otherwise "},{t="skill",v="Blessing of Kings",id=20217},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Seal of Light",id=20165},{t="text",v="'s or "},{t="skill",v="Seal of Wisdom",id=20166},{t="text",v="'s "},{t="skill",v="Judgement",id=20271},{t="text",v=" debuff. This will be refreshed by any Paladin running "},{t="skill",v="Sacred Arbiter",id=1311087},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Divine Favor",id=20216},{t="text",v=" with "},{t="skill",v="Holy Shock",id=20473},{t="text",v=" or "},{t="skill",v="Holy Light",id=635},{t="text",v=" for a guaranteed crit."}},
      {{t="text",v="Apply "},{t="skill",v="Light's Vigil",id=1311590},{t="text",v=" and then "},{t="skill",v="Holy Shock",id=20473},{t="text",v=" twice for AoE healing. You can proactively place this on a member of each party and get lots of "},{t="skill",v="Holy Shock",id=20473},{t="text",v=" AoE casts with no cooldown back to back for raid healing."}},
      {{t="text",v="Cast "},{t="skill",v="Holy Light",id=635},{t="text",v=" with "},{t="skill",v="Infusion of Light",id=426065},{t="text",v=" procs for single-target healing."}},
      {{t="text",v="Cast "},{t="skill",v="Holy Shock",id=20473},{t="text",v=" for an instant single-target heal."}},
      {{t="text",v="Cast "},{t="skill",v="Flash of Light",id=19750},{t="text",v=" or "},{t="skill",v="Holy Light",id=635},{t="text",v=" for single-target healing."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Holy Paladins get access to AoE healing with the new ability "},{t="skill",v="Light's Vigil",id=1311590},{t="text",v=". They also get a reason to use both "},{t="skill",v="Flash of Light",id=19750},{t="text",v=" and "},{t="skill",v="Holy Light",id=635},{t="text",v=" thanks to "},{t="skill",v="Infusion of Light",id=426065},{t="text",v=". We don't know how downranking heals will work, so for now we will just list 1 version of each spell until we learn more. A lot is still unknown, but below is an idea of what the playstyle look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use your assigned Aura."}},
        {{t="text",v="Use your assigned Blessing, otherwise "},{t="skill",v="Blessing of Kings",id=20217},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Seal of Light",id=20165},{t="text",v="'s or "},{t="skill",v="Seal of Wisdom",id=20166},{t="text",v="'s "},{t="skill",v="Judgement",id=20271},{t="text",v=" debuff. This will be refreshed by any Paladin running "},{t="skill",v="Sacred Arbiter",id=1311087},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Divine Favor",id=20216},{t="text",v=" with "},{t="skill",v="Holy Shock",id=20473},{t="text",v=" or "},{t="skill",v="Holy Light",id=635},{t="text",v=" for a guaranteed crit."}},
        {{t="text",v="Cast "},{t="skill",v="Holy Light",id=635},{t="text",v=" with "},{t="skill",v="Infusion of Light",id=426065},{t="text",v=" procs for single-target healing."}},
        {{t="text",v="Cast "},{t="skill",v="Holy Shock",id=20473},{t="text",v=" for an instant single-target heal."}},
        {{t="text",v="Cast "},{t="skill",v="Flash of Light",id=19750},{t="text",v=" or "},{t="skill",v="Holy Light",id=635},{t="text",v=" for single-target healing."}},
      }},
    },
  },
  ["Protection"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Righteous Fury",id=25780},{t="text",v="."}},
      {{t="text",v="Use your assigned Aura, otherwise "},{t="skill",v="Devotion Aura",id=465},{t="text",v=" or "},{t="skill",v="Retribution Aura",id=7294},{t="text",v="."}},
      {{t="text",v="Use your assigned Blessing, otherwise "},{t="skill",v="Blessing of Kings",id=20217},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Seal of Fury",id=20163},{t="text",v=". Use "},{t="skill",v="Seal of Righteousness",id=20154},{t="text",v=" instead when not tanking."}},
      {{t="text",v="Maintain "},{t="skill",v="Holy Shield",id=20925},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Templar's Bulwark",id=1311015},{t="text",v=" as your emergency defensive cooldown."}},
      {{t="text",v="Cast "},{t="skill",v="Swift Judgement",id=1310994},{t="text",v=" followed by "},{t="skill",v="Judgement",id=20271},{t="text",v=". Can be used as an emergency taunt, snap threat, or damage."}},
      {{t="text",v="Cast "},{t="skill",v="Holy Strike",id=678},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Judgement",id=20271},{t="text",v=". Keep in mind that this is also your taunt when using "},{t="skill",v="Seal of Fury",id=20163},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Consecration",id=20116},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Exorcism",id=879},{t="text",v=" if the target is Undead or Demon."}},
    },
    aoe = {
      {{t="text",v="Use "},{t="skill",v="Righteous Fury",id=25780},{t="text",v="."}},
      {{t="text",v="Use your assigned Aura, otherwise "},{t="skill",v="Devotion Aura",id=465},{t="text",v=" or "},{t="skill",v="Retribution Aura",id=7294},{t="text",v="."}},
      {{t="text",v="Use your assigned Blessing, otherwise "},{t="skill",v="Blessing of Kings",id=20217},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Seal of Fury",id=20163},{t="text",v=". Use "},{t="skill",v="Seal of Righteousness",id=20154},{t="text",v=" instead when not tanking."}},
      {{t="text",v="Cast "},{t="skill",v="Templar's Bulwark",id=1311015},{t="text",v=" as your emergency defensive cooldown."}},
      {{t="text",v="Cast "},{t="skill",v="Consecration",id=20116},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Judgement",id=20271},{t="text",v=". Keep in mind that this is also your taunt when using "},{t="skill",v="Seal of Fury",id=20163},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Holy Strike",id=678},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Exorcism",id=879},{t="text",v=" if the target is Undead or Demon."}},
    },
    intro = {{t="text",v="Protection Paladins have a lot of flexibility with their talent builds but we're opting for one that balances threat, defensiveness, and mana issues. In WoW Forever, your "},{t="skill",v="Judgement",id=20271},{t="text",v=" is also your taunt. Luckily you have a way to reset it with "},{t="skill",v="Swift Judgement",id=1310994},{t="text",v=" in case of emergency. Mana issues seem to be mostly solved by talents. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Righteous Fury",id=25780},{t="text",v="."}},
        {{t="text",v="Use your assigned Aura, otherwise "},{t="skill",v="Devotion Aura",id=465},{t="text",v=" or "},{t="skill",v="Retribution Aura",id=7294},{t="text",v="."}},
        {{t="text",v="Use your assigned Blessing, otherwise "},{t="skill",v="Blessing of Kings",id=20217},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Seal of Fury",id=20163},{t="text",v=". Use "},{t="skill",v="Seal of Righteousness",id=20154},{t="text",v=" instead when not tanking."}},
        {{t="text",v="Use "},{t="skill",v="Swift Judgement",id=1310994},{t="text",v=" followed by "},{t="skill",v="Judgement",id=20271},{t="text",v=". Can be used as an emergency taunt, snap threat, or damage."}},
        {{t="text",v="Use "},{t="skill",v="Judgement",id=20271},{t="text",v=". Keep in mind that this is also your taunt when using "},{t="skill",v="Seal of Fury",id=20163},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Holy Strike",id=678},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Consecration",id=20116},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Exorcism",id=879},{t="text",v=" if the target is Undead or Demon."}},
      }},
    },
  },
  ["Retribution"] = {
    single = {
      {{t="text",v="Use your assigned Aura."}},
      {{t="text",v="Use your assigned Blessing, otherwise "},{t="skill",v="Blessing of Kings",id=20217},{t="text",v="."}},
      {{t="text",v="Apply "},{t="skill",v="Seal of the Crusader",id=20162},{t="text",v="'s "},{t="skill",v="Judgement",id=20271},{t="text",v=" debuff. This will be refreshed by "},{t="skill",v="Sacred Arbiter",id=1311087},{t="text",v="."}},
      {{t="text",v="Alternate between "},{t="skill",v="Seal of Command",id=20375},{t="text",v=" and "},{t="skill",v="Seal of Righteousness",id=20154},{t="text",v=" after auto attacks for "},{t="skill",v="Twist of Light",id=1310735},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Holy Strike",id=678},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Judgement",id=20271},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Hammer of Wrath",id=24239},{t="text",v=" on targets that are below 20%"}},
      {{t="text",v="Cast "},{t="skill",v="Exorcism",id=879},{t="text",v=" if the target is Undead or Demon."}},
      {{t="text",v="Cast "},{t="skill",v="Consecration",id=20116},{t="text",v="."}},
    },
    aoe = {
      {{t="text",v="Use your assigned Aura."}},
      {{t="text",v="Use your assigned Blessing, otherwise "},{t="skill",v="Blessing of Kings",id=20217},{t="text",v="."}},
      {{t="text",v="Apply "},{t="skill",v="Seal of the Crusader",id=20162},{t="text",v="'s "},{t="skill",v="Judgement",id=20271},{t="text",v=" debuff. This will be refreshed by "},{t="skill",v="Sacred Arbiter",id=1311087},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Seal of Righteousness",id=20154},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Consecration",id=20116},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Holy Shock",id=20473},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Holy Strike",id=678},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Judgement",id=20271},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Exorcism",id=879},{t="text",v=" if the target is Undead or Demon."}},
    },
    intro = {{t="text",v="Seal Twisting has been added in the form of "},{t="skill",v="Twist of Light",id=1310735},{t="text",v=" which simplifies it a great deal. You also get access to "},{t="skill",v="Holy Strike",id=678},{t="text",v=" to round out the rotation. Finally, it seems the intent is to make the spec scale with both Attack Power and Spell Damage which is greatly increased by "},{t="skill",v="Champion of the Light",id=1311084},{t="text",v=". The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use your assigned Aura."}},
        {{t="text",v="Use your assigned Blessing, otherwise "},{t="skill",v="Blessing of Kings",id=20217},{t="text",v="."}},
        {{t="text",v="Apply "},{t="skill",v="Seal of the Crusader",id=20162},{t="text",v="'s "},{t="skill",v="Judgement",id=20271},{t="text",v=" debuff. This will be refreshed by "},{t="skill",v="Sacred Arbiter",id=1311087},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Seal of Command",id=20375},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Holy Strike",id=678},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Judgement",id=20271},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Exorcism",id=879},{t="text",v=" if the target is Undead or Demon."}},
        {{t="text",v="Cast "},{t="skill",v="Consecration",id=20116},{t="text",v="."}},
      }},
    },
  },
}
R["Priest"] = {
  ["Discipline"] = {
    single = {
      {{t="text",v="Cast "},{t="skill",v="Power Infusion",id=10060},{t="text",v=", ideally on a caster DPS."}},
      {{t="text",v="Cast "},{t="skill",v="Inner Focus",id=14751},{t="text",v=", ideally with "},{t="skill",v="Prayer of Healing",id=596},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Power Word: Shield",id=17},{t="text",v=" on as many targets as possible if large raid damage is coming."}},
      {{t="text",v="Maintain "},{t="skill",v="Power Word: Shield",id=17},{t="text",v=" on the tank. The duration of Weakened Soul will be reduced via "},{t="skill",v="Renewed Hope",id=425280},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Inspiration",id=14892},{t="text",v=" on the tank if assigned and needed."}},
      {{t="text",v="Cast "},{t="skill",v="Penance",id=402174},{t="text",v=" for single-target healing."}},
      {{t="text",v="Cast "},{t="skill",v="Flash Heal",id=2061},{t="text",v=" or "},{t="skill",v="Binding Heal",id=401937},{t="text",v=" for single-target healing."}},
      {{t="text",v="Cast "},{t="skill",v="Prayer of Healing",id=596},{t="text",v=" for AoE party-wide healing."}},
    },
    aoe = {
      {{t="text",v="Cast "},{t="skill",v="Power Infusion",id=10060},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Holy Nova",id=15237},{t="text",v=" during "},{t="skill",v="Searing Light",id=14909},{t="text",v=" procs. This will probably only be used in AoE situations."}},
      {{t="text",v="Maintain "},{t="skill",v="Holy Fire",id=14914},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Penance",id=402174},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Smite",id=585},{t="text",v="."}},
    },
    intro = {{t="text",v="Discipline Priests might have the option to be a healer or a dps in WoW Forever, assuming they don't get Attonement. We'll cover both just in case. We don't know how downranking heals will work, so for now we will just list 1 version of each spell until we learn more. A lot is still unknown, but below is an idea of what the playstyle look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Cast "},{t="skill",v="Power Word: Shield",id=17},{t="text",v=" on as many targets as possible if large party damage is coming."}},
        {{t="text",v="Cast "},{t="skill",v="Inner Focus",id=14751},{t="text",v=", ideally with "},{t="skill",v="Prayer of Healing",id=596},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Power Word: Shield",id=17},{t="text",v=" on the tank."}},
        {{t="text",v="Cast "},{t="skill",v="Penance",id=402174},{t="text",v=" for single-target healing."}},
        {{t="text",v="Cast "},{t="skill",v="Flash Heal",id=2061},{t="text",v=" for single-target healing."}},
        {{t="text",v="Cast "},{t="skill",v="Prayer of Healing",id=596},{t="text",v=" for AoE party-wide healing."}},
      }},
    },
  },
  ["Holy"] = {
    single = {
      {{t="text",v="You'll want to alternate casts for mana efficiency thanks to "},{t="skill",v="Litany of Light",id=1317006},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Inner Focus",id=14751},{t="text",v=", ideally with "},{t="skill",v="Greater Heal",id=2060},{t="text",v=" or "},{t="skill",v="Prayer of Healing",id=596},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Renew",id=139},{t="text",v=" on players taking constant damage."}},
      {{t="text",v="Maintain "},{t="skill",v="Inspiration",id=14892},{t="text",v=" on the tank if assigned and needed."}},
      {{t="text",v="Cast "},{t="skill",v="Prayer of Mending",id=1240827},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Prayer of Healing",id=596},{t="text",v=" for AoE party-wide healing."}},
      {{t="text",v="Cast "},{t="skill",v="Flash Heal",id=2061},{t="text",v=" or "},{t="skill",v="Binding Heal",id=401937},{t="text",v=" for quick spot single-target healing."}},
      {{t="text",v="Cast "},{t="skill",v="Greater Heal",id=2060},{t="text",v=" for large single-target healing."}},
      {{t="text",v="Cast "},{t="skill",v="Heal",id=2054},{t="text",v=" in all other situations."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Holy Priests gained two new heals with "},{t="skill",v="Binding Heal",id=401937},{t="text",v=" and "},{t="skill",v="Prayer of Mending",id=1240827},{t="text",v=". "},{t="skill",v="Litany of Light",id=1317006},{t="text",v=" incentivizes a unique playstyle of alternating spell casts. We don't know how downranking heals will work, so for now we will just list 1 version of each spell until we learn more. A lot is still unknown, but below is an idea of what the playstyle look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="You'll want to alternate casts for mana efficiency thanks to "},{t="skill",v="Litany of Light",id=1317006},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Renew",id=139},{t="text",v=" on players taking constant damage."}},
        {{t="text",v="Maintain "},{t="skill",v="Inspiration",id=14892},{t="text",v=" on the tank if assigned and needed."}},
        {{t="text",v="Cast "},{t="skill",v="Prayer of Mending",id=1240827},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Prayer of Healing",id=596},{t="text",v=" for AoE party-wide healing."}},
        {{t="text",v="Cast "},{t="skill",v="Flash Heal",id=2061},{t="text",v=" or "},{t="skill",v="Binding Heal",id=401937},{t="text",v=" for quick spot single-target healing."}},
        {{t="text",v="Cast "},{t="skill",v="Greater Heal",id=2060},{t="text",v=" for large single-target healing."}},
        {{t="text",v="Cast "},{t="skill",v="Heal",id=2054},{t="text",v=" in all other situations."}},
      }},
    },
  },
  ["Shadow"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Shadowform",id=15473},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Vampiric Embrace",id=15286},{t="text",v=" during party-wide damage."}},
      {{t="text",v="Cast "},{t="skill",v="Inner Focus",id=14751},{t="text",v=" with "},{t="skill",v="Mind Blast",id=8092},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Shadow Word: Pain",id=589},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Devouring Plague",id=2944},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Shadow Word: Death",id=401955},{t="text",v=" on targets at or below 20% health."}},
      {{t="text",v="Cast "},{t="skill",v="Mind Blast",id=8092},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Mind Flay",id=15407},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Shadow Word: Death",id=401955},{t="text",v=" while moving."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Shadow Priests mana issues might be a thing of the past thanks to "},{t="skill",v="Shadowform",id=15473},{t="text",v=" now reducing Mana costs by 50%. The talent "},{t="skill",v="Devouring Contagion",id=1309950},{t="text",v=" gives the class a bit of AoE and cleave and "},{t="skill",v="Early Demise",id=1310076},{t="text",v=" an execute phase. It is unclear if "},{t="skill",v="Shadow Word: Death",id=401955},{t="text",v=" will still be used outside of execute range. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Maintain "},{t="skill",v="Shadow Word: Pain",id=589},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Devouring Plague",id=2944},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Shadow Word: Death",id=401955},{t="text",v=" on targets at or below 20% health."}},
        {{t="text",v="Cast "},{t="skill",v="Mind Blast",id=8092},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Mind Flay",id=15407},{t="text",v="."}},
      }},
    },
  },
}
R["Rogue"] = {
  ["Assassination"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Instant Poison",id=8679},{t="text",v=" on main-hand and "},{t="skill",v="Deadly Poison",id=2835},{t="text",v=" on off-hand."}},
      {{t="text",v="Maintain "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Venom",id=1310703},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Eviscerate",id=2098},{t="text",v=" if it won't delay either "},{t="skill",v="Venom",id=1310703},{t="text",v=" or "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Mutilate",id=1241582},{t="text",v=" to generate Combo Points."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Assassination Rogues gain a new level 30 talent with "},{t="skill",v="Venom",id=1310703},{t="text",v=" and they gain a new Energy spender with "},{t="skill",v="Mutilate",id=1241582},{t="text",v=". The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Instant Poison",id=8679},{t="text",v=" on main-hand and "},{t="skill",v="Deadly Poison",id=2835},{t="text",v=" on off-hand."}},
        {{t="text",v="Maintain "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Cold Blood",id=14177},{t="text",v=" with "},{t="skill",v="Eviscerate",id=2098},{t="text",v=" at 5 Combo Points."}},
        {{t="text",v="Cast "},{t="skill",v="Eviscerate",id=2098},{t="text",v=" if it won't delay "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Mutilate",id=1241582},{t="text",v=" to generate Combo points."}},
      }},
    },
  },
  ["Combat"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Instant Poison",id=8679},{t="text",v=" on main-hand and "},{t="skill",v="Deadly Poison",id=2835},{t="text",v=" on off-hand."}},
      {{t="text",v="Maintain "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Blade Flurry",id=13877},{t="text",v=", "},{t="skill",v="Adrenaline Rush",id=13750},{t="text",v=", and any on-use effects."}},
      {{t="text",v="Cast "},{t="skill",v="Eviscerate",id=2098},{t="text",v=" if it won't delay "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Sinister Strike",id=1752},{t="text",v=" to generate Combo Points."}},
    },
    aoe = {
      {{t="text",v="Use "},{t="skill",v="Instant Poison",id=8679},{t="text",v=" on main-hand and "},{t="skill",v="Deadly Poison",id=2835},{t="text",v=" on off-hand."}},
      {{t="text",v="Maintain "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Blade Flurry",id=13877},{t="text",v=", "},{t="skill",v="Adrenaline Rush",id=13750},{t="text",v=", and any on-use effects."}},
      {{t="text",v="Cast "},{t="skill",v="Eviscerate",id=2098},{t="text",v=" if it won't delay "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Backstab",id=53},{t="text",v=" to generate Combo Points."}},
    },
    intro = {{t="text",v="Combat Rogues didn't change much. It's unclear if the "},{t="skill",v="Sinister Strike",id=1752},{t="text",v=" or the "},{t="skill",v="Backstab",id=53},{t="text",v=" variant will be stronger. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Instant Poison",id=8679},{t="text",v=" on main-hand and "},{t="skill",v="Deadly Poison",id=2835},{t="text",v=" on off-hand."}},
        {{t="text",v="Maintain "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Blade Flurry",id=13877},{t="text",v=" and any on-use effects."}},
        {{t="text",v="Cast "},{t="skill",v="Eviscerate",id=2098},{t="text",v=" if it won't delay "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Sinister Strike",id=1752},{t="text",v=" or "},{t="skill",v="Backstab",id=53},{t="text",v=" to generate Combo Points based on weapon."}},
      }},
    },
  },
  ["Subtlety"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Instant Poison",id=8679},{t="text",v=" on main-hand and "},{t="skill",v="Deadly Poison",id=2835},{t="text",v=" on off-hand."}},
      {{t="text",v="Maintain "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Rupture",id=1943},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Hemorrhage",id=16511},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Premeditation",id=14183},{t="text",v=" when below 4 Combo Points."}},
      {{t="text",v="Cast "},{t="skill",v="Vanish",id=1856},{t="text",v=" followed by "},{t="skill",v="Ambush",id=8676},{t="text",v=" when not in stealth. You can reset this with "},{t="skill",v="Preparation",id=14185},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Eviscerate",id=2098},{t="text",v=" if it won't delay "},{t="skill",v="Slice and Dice",id=6774},{t="text",v=" or "},{t="skill",v="Rupture",id=1943},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Ambush",id=8676},{t="text",v=" with "},{t="skill",v="Cutthroat",id=462708},{t="text",v=" procs or while stealthed."}},
      {{t="text",v="Cast "},{t="skill",v="Backstab",id=53},{t="text",v=" to generate Combo Points."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Subtlety Rogues rotation will revolve around the new talent "},{t="skill",v="Cutthroat",id=462708},{t="text",v=" which makes "},{t="skill",v="Ambush",id=8676},{t="text",v=" useable out of stealth. It looks to be the most complex of the three specs with lots of things to maintain. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Instant Poison",id=8679},{t="text",v=" on main-hand and "},{t="skill",v="Deadly Poison",id=2835},{t="text",v=" on off-hand."}},
        {{t="text",v="Maintain "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Vanish",id=1856},{t="text",v=" followed by "},{t="skill",v="Ambush",id=8676},{t="text",v=" when not in stealth."}},
        {{t="text",v="Cast "},{t="skill",v="Eviscerate",id=2098},{t="text",v=" if it won't delay "},{t="skill",v="Slice and Dice",id=6774},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Backstab",id=53},{t="text",v=" to generate Combo Points."}},
      }},
    },
  },
}
R["Shaman"] = {
  ["Elemental"] = {
    single = {
      {{t="text",v="Maintain "},{t="skill",v="Searing Totem",id=3599},{t="text",v=", "},{t="skill",v="Mana Spring Totem",id=5675},{t="text",v=", and your assigned Earth and Air Totems via "},{t="skill",v="Call of the Elements",id=66842},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Elemental Mastery",id=16166},{t="text",v=" with any on-use effects."}},
      {{t="text",v="Maintain "},{t="skill",v="Flame Shock",id=8050},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Lava Burst",id=408490},{t="text",v=" if the target is afflicted by "},{t="skill",v="Flame Shock",id=8050},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Chain Lightning",id=421},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Lightning Bolt",id=403},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Flame Shock",id=8050},{t="text",v=" while moving."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Elemental Shamans get three big quality of life changes in "},{t="skill",v="Call of the Elements",id=66842},{t="text",v=" now dropping all 4 totems, "},{t="skill",v="Totemic Projection",id=437009},{t="text",v=" to reposition them, and "},{t="skill",v="Ghost Wolf",id=2645},{t="text",v=" now being instant cast and useable indoors. The rotation becomes a little more involved with the addition of "},{t="skill",v="Flame Shock",id=8050},{t="text",v=" and "},{t="skill",v="Lava Burst",id=408490},{t="text",v=". It is unclear if you'll have the mana to cast "},{t="skill",v="Chain Lightning",id=421},{t="text",v=" on single target fights. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Maintain "},{t="skill",v="Searing Totem",id=3599},{t="text",v=", "},{t="skill",v="Mana Spring Totem",id=5675},{t="text",v=", and your assigned Earth and Air Totems via "},{t="skill",v="Call of the Elements",id=66842},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Flame Shock",id=8050},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Chain Lightning",id=421},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Lightning Bolt",id=403},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Flame Shock",id=8050},{t="text",v=" or "},{t="skill",v="Earth Shock",id=8042},{t="text",v=" while moving."}},
      }},
    },
  },
  ["Enhancement"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Windfury Weapon",id=8232},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Strength of Earth Totem",id=8075},{t="text",v=", "},{t="skill",v="Mana Spring Totem",id=5675},{t="text",v=", "},{t="skill",v="Searing Totem",id=3599},{t="text",v=", and either "},{t="skill",v="Windfury Totem",id=8512},{t="text",v=" or "},{t="skill",v="Grace of Air Totem",id=8835},{t="text",v=" via "},{t="skill",v="Call of the Elements",id=66842},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Rage of the Farseer",id=425336},{t="text",v=" with any on-use effects."}},
      {{t="text",v="Cast "},{t="skill",v="Lightning Bolt",id=403},{t="text",v=" at 5 stacks of "},{t="skill",v="Maelstrom Weapon",id=408498},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Stormstrike",id=17364},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Flame Shock",id=8050},{t="text",v=" or "},{t="skill",v="Earth Shock",id=8042},{t="text",v=". If the target has the "},{t="skill",v="Flame Shock",id=8050},{t="text",v=" DoT, cast "},{t="skill",v="Earth Shock",id=8042},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Fire Nova",id=408345},{t="text",v="."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Enhancement Shamans get two big quality of life changes in "},{t="skill",v="Call of the Elements",id=66842},{t="text",v=" now dropping all 4 totems and "},{t="skill",v="Totemic Projection",id=437009},{t="text",v=" to reposition them. The rotation is similar to spellhance from WotLK thanks to the addition of "},{t="skill",v="Maelstrom Weapon",id=408498},{t="text",v=" and they get their own personal Bloodlust with "},{t="skill",v="Rage of the Farseer",id=425336},{t="text",v=". The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Windfury Weapon",id=8232},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Strength of Earth Totem",id=8075},{t="text",v=", "},{t="skill",v="Mana Spring Totem",id=5675},{t="text",v=", "},{t="skill",v="Searing Totem",id=3599},{t="text",v=", and either "},{t="skill",v="Windfury Totem",id=8512},{t="text",v=" or "},{t="skill",v="Grace of Air Totem",id=8835},{t="text",v=" via "},{t="skill",v="Call of the Elements",id=66842},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Stormstrike",id=17364},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Flame Shock",id=8050},{t="text",v=" or "},{t="skill",v="Earth Shock",id=8042},{t="text",v=". If the target has the "},{t="skill",v="Flame Shock",id=8050},{t="text",v=" DoT, prioritize "},{t="skill",v="Earth Shock",id=8042},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Fire Nova",id=408345},{t="text",v="."}},
      }},
    },
  },
  ["Restoration"] = {
    single = {
      {{t="text",v="Maintain totems that will benefit your group the most via "},{t="skill",v="Call of the Elements",id=66842},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Water Shield",id=408510},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Ancestral Healing",id=16176},{t="text",v=" on the tank if assigned and needed."}},
      {{t="text",v="Use "},{t="skill",v="Mana Tide Totem",id=16190},{t="text",v=" when everyone in your group will benefit the most from it."}},
      {{t="text",v="Use "},{t="skill",v="Nature's Swiftness",id=16188},{t="text",v=" with "},{t="skill",v="Healing Wave",id=331},{t="text",v=" or "},{t="skill",v="Chain Heal",id=1064},{t="text",v=" for an instant emergency heal."}},
      {{t="text",v="Maintain "},{t="skill",v="Riptide",id=408521},{t="text",v=" on the tank and players taking constant damage."}},
      {{t="text",v="Cast "},{t="skill",v="Chain Heal",id=1064},{t="text",v=" for AoE healing. Prioritize targets with a "},{t="skill",v="Riptide",id=408521},{t="text",v=" buff."}},
      {{t="text",v="Cast "},{t="skill",v="Healing Wave",id=331},{t="text",v=" or "},{t="skill",v="Lesser Healing Wave",id=8004},{t="text",v=" for single-target healing."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Restoration Shamans get three big quality of life changes in "},{t="skill",v="Call of the Elements",id=66842},{t="text",v=" now dropping all 4 totems, "},{t="skill",v="Totemic Projection",id=437009},{t="text",v=" to reposition them, and "},{t="skill",v="Ghost Wolf",id=2645},{t="text",v=" now being instant cast and useable indoors. They also gain access to "},{t="skill",v="Riptide",id=408521},{t="text",v=" and "},{t="skill",v="Water Shield",id=408510},{t="text",v=". We don't know how downranking heals will work, so for now we will just list 1 version of each spell until we learn more. A lot is still unknown, but below is an idea of what the playstyle look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Maintain totems that will benefit your group the most via "},{t="skill",v="Call of the Elements",id=66842},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Water Shield",id=408510},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Mana Tide Totem",id=16190},{t="text",v=" when everyone in your group will benefit the most from it."}},
        {{t="text",v="Use "},{t="skill",v="Nature's Swiftness",id=16188},{t="text",v=" with "},{t="skill",v="Healing Wave",id=331},{t="text",v=" for an instant emergency heal."}},
        {{t="text",v="Cast "},{t="skill",v="Healing Wave",id=331},{t="text",v=" or "},{t="skill",v="Lesser Healing Wave",id=8004},{t="text",v=" for single-target healing."}},
      }},
    },
  },
}
R["Warlock"] = {
  ["Affliction"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Create Spellstone",id=17728},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Demonic Sacrifice",id=18788},{t="text",v=" on "},{t="skill",v="Summon Imp",id=688},{t="text",v="."}},
      {{t="text",v="Maintain your assigned curse, otherwise use "},{t="skill",v="Curse of Shadow",id=402791},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Amplify Curse",id=18288},{t="text",v=" with "},{t="skill",v="Bane of Agony",id=980},{t="text",v=" and any on-use effects."}},
      {{t="text",v="Cast "},{t="skill",v="Shadow Bolt",id=686},{t="text",v=" with "},{t="skill",v="Nightfall",id=18094},{t="text",v=" procs."}},
      {{t="text",v="Maintain "},{t="skill",v="Bane of Agony",id=980},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Corruption",id=172},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Siphon Life",id=18265},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Wrack",id=1316697},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Life Tap",id=1454},{t="text",v=" when you need mana, ideally while moving."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Affliction Warlocks gain a new level 30 talent called "},{t="skill",v="Wrack",id=1316697},{t="text",v=" that will replace "},{t="skill",v="Shadow Bolt",id=686},{t="text",v=" as your filler spell. They also gain access to "},{t="skill",v="Demonic Sacrifice",id=18788},{t="text",v=" since it moved up in the Demonology tree. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Cast "},{t="skill",v="Shadow Bolt",id=686},{t="text",v=" when "},{t="skill",v="Nightfall",id=18094},{t="text",v=" procs."}},
        {{t="text",v="Maintain "},{t="skill",v="Bane of Agony",id=980},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Corruption",id=172},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Siphon Life",id=18265},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Shadow Bolt",id=686},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Life Tap",id=1454},{t="text",v=" when you need mana, ideally while moving."}},
      }},
    },
  },
  ["Demonology"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Create Spellstone",id=17728},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Demonic Sacrifice",id=18788},{t="text",v=" on "},{t="skill",v="Summon Imp",id=688},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Summon Succubus",id=712},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Soul Link",id=19028},{t="text",v="."}},
      {{t="text",v="Maintain your assigned curse, otherwise "},{t="skill",v="Curse of Shadow",id=402791},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Bane of Doom",id=603},{t="text",v=" if the target will live longer than 1 min."}},
      {{t="text",v="Cast "},{t="skill",v="Soul Fire",id=6353},{t="text",v=" on targets below 35% HP when "},{t="skill",v="Decimation",id=440870},{t="text",v=" is active."}},
      {{t="text",v="Cast "},{t="skill",v="Shadow Bolt",id=686},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Life Tap",id=1454},{t="text",v=" when you need mana, ideally while moving."}},
    },
    aoe = {
      {{t="text",v="Use "},{t="skill",v="Create Firestone",id=17953},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Demonic Sacrifice",id=18788},{t="text",v=" on "},{t="skill",v="Summon Succubus",id=712},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Summon Imp",id=688},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Soul Link",id=19028},{t="text",v="."}},
      {{t="text",v="Maintain your assigned curse, otherwise "},{t="skill",v="Curse of the Elements",id=440892},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Immolate",id=348},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Bane of Doom",id=603},{t="text",v=" if the target will live longer than 1 min."}},
      {{t="text",v="Cast "},{t="skill",v="Soul Fire",id=6353},{t="text",v=" on enemies below 35% health when "},{t="skill",v="Decimation",id=440870},{t="text",v=" is active."}},
      {{t="text",v="Cast "},{t="skill",v="Searing Pain",id=5676},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Life Tap",id=1454},{t="text",v=" when you need mana, ideally while moving."}},
    },
    intro = {{t="text",v="Demonology Warlocks gain a unique new talent called "},{t="skill",v="Demonic Pact",id=425464},{t="text",v=" which lets you sacrifice a demon with "},{t="skill",v="Demonic Sacrifice",id=18788},{t="text",v=" while still having one active. They also get an execute phase via "},{t="skill",v="Decimation",id=440870},{t="text",v=". It's unclear if the Shadow Succubus or Fire Imp version will be stronger. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Summon Succubus",id=712},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Shadow Bolt",id=686},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Life Tap",id=1454},{t="text",v=" when you need mana, ideally while moving."}},
      }},
    },
  },
  ["Destruction"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Create Firestone",id=17953},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Demonic Sacrifice",id=18788},{t="text",v=" on "},{t="skill",v="Summon Succubus",id=712},{t="text",v="."}},
      {{t="text",v="Maintain your assigned curse, otherwise "},{t="skill",v="Curse of the Elements",id=440892},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Shadow and Flame",id=426316},{t="text",v=" with "},{t="skill",v="Shadowburn",id=17877},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Searing Pain",id=5676},{t="text",v=" on targets below 35% HP to proc "},{t="skill",v="Decimation",id=440870},{t="text",v=" if "},{t="skill",v="Soul Fire",id=6353},{t="text",v=" is off cooldown."}},
      {{t="text",v="Cast "},{t="skill",v="Soul Fire",id=6353},{t="text",v=" on targets below 35% HP when "},{t="skill",v="Decimation",id=440870},{t="text",v=" is active."}},
      {{t="text",v="Maintain "},{t="skill",v="Immolate",id=348},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Bane of Doom",id=603},{t="text",v=" if the target will live longer than 1 min."}},
      {{t="text",v="Cast "},{t="skill",v="Conflagrate",id=17962},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Incinerate",id=412758},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Life Tap",id=1454},{t="text",v=" when you need mana, ideally while moving."}},
    },
    aoe = {
      {{t="text",v="Use "},{t="skill",v="Create Spellstone",id=17728},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Demonic Sacrifice",id=18788},{t="text",v=" on "},{t="skill",v="Summon Imp",id=688},{t="text",v="."}},
      {{t="text",v="Maintain your assigned curse, otherwise "},{t="skill",v="Curse of Shadow",id=402791},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Shadow and Flame",id=426316},{t="text",v=" with "},{t="skill",v="Immolate",id=348},{t="text",v=" and "},{t="skill",v="Conflagrate",id=17962},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Soul Fire",id=6353},{t="text",v=" on targets below 35% HP when "},{t="skill",v="Decimation",id=440870},{t="text",v=" is active."}},
      {{t="text",v="Cast "},{t="skill",v="Bane of Doom",id=603},{t="text",v=" if the target will live longer than 1 min."}},
      {{t="text",v="Cast "},{t="skill",v="Shadowburn",id=17877},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Shadow Bolt",id=686},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Life Tap",id=1454},{t="text",v=" when you need mana, ideally while moving."}},
    },
    intro = {{t="text",v="Desturction Warlocks gain a handful of new gameplay altering talents such as "},{t="skill",v="Shadow and Flame",id=426316},{t="text",v=" which removes the constraints on casting "},{t="skill",v="Shadowburn",id=17877},{t="text",v=". They also gain access to "},{t="skill",v="Bane of Havoc",id=1225228},{t="text",v=", buffing their 2-target damage and an execute phase via "},{t="skill",v="Decimation",id=440870},{t="text",v=". It's unclear if the Shadow Succubus or Fire Imp version will be stronger. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Maintain "},{t="skill",v="Immolate",id=348},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Conflagrate",id=17962},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Shadow Bolt",id=686},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Shadowburn",id=17877},{t="text",v=" on low HP targets."}},
        {{t="text",v="Cast "},{t="skill",v="Life Tap",id=1454},{t="text",v=" when you need mana, ideally while moving."}},
      }},
    },
  },
}
R["Warrior"] = {
  ["Arms"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Berserker Stance",id=2458},{t="text",v=". You'll have to swap to "},{t="skill",v="Battle Stance",id=2457},{t="text",v=" for "},{t="skill",v="Rend",id=772},{t="text",v=", "},{t="skill",v="Overpower",id=7384},{t="text",v=", and "},{t="skill",v="Spearing Strike",id=1310222},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Battle Shout",id=5242},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Recklessness",id=1719},{t="text",v=" with any on-use effects. Ideally used during the execute phase."}},
      {{t="text",v="Cast "},{t="skill",v="Bloodrage",id=2687},{t="text",v=" to generate Rage."}},
      {{t="text",v="Cast "},{t="skill",v="Sunder Armor",id=7386},{t="text",v=" if below 5 stacks or about to fall off."}},
      {{t="text",v="Cast "},{t="skill",v="Execute",id=5308},{t="text",v=" on targets below 20% HP."}},
      {{t="text",v="Maintain "},{t="skill",v="Rend",id=772},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Heroic Strike",id=78},{t="text",v=" with excess rage."}},
      {{t="text",v="Cast "},{t="skill",v="Spearing Strike",id=1310222},{t="text",v=" against Dragonkin or Giants."}},
      {{t="text",v="Cast "},{t="skill",v="Overpower",id=7384},{t="text",v=" with "},{t="skill",v="Bloodthrill",id=1289682},{t="text",v=" procs or when dodged."}},
      {{t="text",v="Cast "},{t="skill",v="Mortal Strike",id=12294},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Whirlwind",id=1680},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Slam",id=1464},{t="text",v="."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Arms Warriors get new playstyle defining talents that allow us to "},{t="skill",v="Slam",id=1464},{t="text",v=" without interrupting our swing timer and use "},{t="skill",v="Rend",id=772},{t="text",v=" to fish for "},{t="skill",v="Overpower",id=7384},{t="text",v=" procs. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Berserker Stance",id=2458},{t="text",v=". You'll have to swap to "},{t="skill",v="Battle Stance",id=2457},{t="text",v=" for "},{t="skill",v="Rend",id=772},{t="text",v=" and "},{t="skill",v="Overpower",id=7384},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Battle Shout",id=5242},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Bloodrage",id=2687},{t="text",v=" to generate Rage."}},
        {{t="text",v="Cast "},{t="skill",v="Execute",id=5308},{t="text",v=" on targets below 20% HP."}},
        {{t="text",v="Maintain "},{t="skill",v="Rend",id=772},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Heroic Strike",id=78},{t="text",v=" with excess rage."}},
        {{t="text",v="Cast "},{t="skill",v="Overpower",id=7384},{t="text",v=" when dodged."}},
        {{t="text",v="Cast "},{t="skill",v="Slam",id=1464},{t="text",v=" right after an auto attack."}},
      }},
    },
  },
  ["Fury"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Berserker Stance",id=2458},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Battle Shout",id=5242},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Recklessness",id=1719},{t="text",v=", "},{t="skill",v="Death Wish",id=12328},{t="text",v=", and any on-use effects. Ideally used during the execute phase."}},
      {{t="text",v="Cast "},{t="skill",v="Bloodrage",id=2687},{t="text",v=" to generate rage."}},
      {{t="text",v="Cast "},{t="skill",v="Sunder Armor",id=7386},{t="text",v=" if below 5 stacks or about to fall off."}},
      {{t="text",v="Cast "},{t="skill",v="Execute",id=5308},{t="text",v=" on targets below 20% health."}},
      {{t="text",v="Cast "},{t="skill",v="Heroic Strike",id=78},{t="text",v=" and "},{t="skill",v="Hamstring",id=7373},{t="text",v=" with excess rage."}},
      {{t="text",v="Cast "},{t="skill",v="Bloodthirst",id=23881},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Whirlwind",id=1680},{t="text",v="."}},
    },
    aoe = {
      {{t="text",v="Use "},{t="skill",v="Berserker Stance",id=2458},{t="text",v=". You'll have to swap to "},{t="skill",v="Battle Stance",id=2457},{t="text",v=" for "},{t="skill",v="Sweeping Strike",id=12292},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Battle Shout",id=5242},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Recklessness",id=1719},{t="text",v=", "},{t="skill",v="Death Wish",id=12328},{t="text",v=", and any on-use effects. Ideally used during the execute phase."}},
      {{t="text",v="Cast "},{t="skill",v="Bloodrage",id=2687},{t="text",v=" to generate rage."}},
      {{t="text",v="Cast "},{t="skill",v="Sunder Armor",id=7386},{t="text",v=" if below 5 stacks or about to fall off."}},
      {{t="text",v="Cast "},{t="skill",v="Execute",id=5308},{t="text",v=" on targets below 20% health."}},
      {{t="text",v="Cast "},{t="skill",v="Heroic Strike",id=78},{t="text",v=" and "},{t="skill",v="Hamstring",id=7373},{t="text",v=" with excess rage."}},
      {{t="text",v="Cast "},{t="skill",v="Whirlwind",id=1680},{t="text",v="."}},
    },
    intro = {{t="text",v="Fury Warriors don't seem to change much other than fury generation. They just get better at what they already did. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Berserker Stance",id=2458},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Battle Shout",id=5242},{t="text",v="."}},
        {{t="text",v="Cast "},{t="skill",v="Death Wish",id=12328},{t="text",v=" and any on-use effects. Ideally used during the execute phase."}},
        {{t="text",v="Cast "},{t="skill",v="Bloodrage",id=2687},{t="text",v=" to generate rage."}},
        {{t="text",v="Cast "},{t="skill",v="Sunder Armor",id=7386},{t="text",v=" if below 5 stacks or about to fall off."}},
        {{t="text",v="Cast "},{t="skill",v="Execute",id=5308},{t="text",v=" on targets below 20% health."}},
        {{t="text",v="Cast "},{t="skill",v="Heroic Strike",id=78},{t="text",v=" and "},{t="skill",v="Hamstring",id=7373},{t="text",v=" with excess rage."}},
      }},
    },
  },
  ["Protection"] = {
    single = {
      {{t="text",v="Use "},{t="skill",v="Defensive Stance",id=71},{t="text",v="."}},
      {{t="text",v="Use "},{t="skill",v="Battle Shout",id=5242},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Shield Wall",id=871},{t="text",v=" and "},{t="skill",v="Last Stand",id=12975},{t="text",v=" as your emergency defensive cooldowns."}},
      {{t="text",v="Cast "},{t="skill",v="Bloodrage",id=2687},{t="text",v=" to generate rage."}},
      {{t="text",v="Maintain 5 stacks of "},{t="skill",v="Sunder Armor",id=7386},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Thunder Clap",id=6343},{t="text",v="."}},
      {{t="text",v="Maintain "},{t="skill",v="Demoralizing Shout",id=1160},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Shield Block",id=2565},{t="text",v=" against physical attacks."}},
      {{t="text",v="Cast "},{t="skill",v="Heroic Strike",id=78},{t="text",v=" with excess rage."}},
      {{t="text",v="Cast "},{t="skill",v="Shield Slam",id=23922},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Revenge",id=6572},{t="text",v="."}},
      {{t="text",v="Cast "},{t="skill",v="Sunder Armor",id=7386},{t="text",v="."}},
    },
    aoe = {
    },
    intro = {{t="text",v="Protection Warriors are seemingly back to 1h + shield. "},{t="skill",v="Charge",id=100},{t="text",v=" and "},{t="skill",v="Thunder Clap",id=6343},{t="text",v=" are now useable in "},{t="skill",v="Defensive Stance",id=71},{t="text",v=" which is a big quality of life improvement. There are more offensive talent options, but we're opting for one that balances threat and defensiveness. The sims will eventually tell us what the optimal rotation is, but below is an idea of what that might look like:"}},
    sections = {
      {title="Single Target — Level 30",lv=30,kind="single",steps={
        {{t="text",v="Use "},{t="skill",v="Defensive Stance",id=71},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Battle Shout",id=5242},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Shield Wall",id=871},{t="text",v=" and "},{t="skill",v="Last Stand",id=12975},{t="text",v=" as your emergency defensive cooldowns."}},
        {{t="text",v="Use "},{t="skill",v="Bloodrage",id=2687},{t="text",v=" to generate rage."}},
        {{t="text",v="Maintain 5 stacks of "},{t="skill",v="Sunder Armor",id=7386},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Thunder Clap",id=6343},{t="text",v="."}},
        {{t="text",v="Maintain "},{t="skill",v="Demoralizing Shout",id=1160},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Shield Block",id=2565},{t="text",v=" against physical attacks."}},
        {{t="text",v="Use "},{t="skill",v="Heroic Strike",id=78},{t="text",v=" with excess rage."}},
        {{t="text",v="Use "},{t="skill",v="Revenge",id=6572},{t="text",v="."}},
        {{t="text",v="Use "},{t="skill",v="Sunder Armor",id=7386},{t="text",v="."}},
      }},
    },
  },
}
