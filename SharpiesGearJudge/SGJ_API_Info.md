# Sharpie's Gear Judge API

Ask Sharpie's Gear Judge (SGJ) **how much an item would upgrade a player**. You can ask about the player using your addon, or ask **everyone in the raid at once**.

> Works on WoW Forever, Classic Era and TBC. API version 1, starting with SGJ 3.2.7.

---

## 1. Setup

Add this line to your addon's TOC, so SGJ loads first when it's installed:

```
## OptionalDeps: SharpiesGearJudge
```

Then get the API. It is `nil` if SGJ isn't installed:

```lua
local SGJ = _G.SharpiesGearJudgeAPI
```

That's the only thing you need from SGJ. Its other functions are internal and can change in any release.

---

## 2. Score an item for yourself

```lua
if SGJ and SGJ.IsReady() then
    local result = SGJ.ScoreItem(itemLink)
    if result then
        print(result.specName .. ": " .. string.format("%+.1f%%", result.upgradePct))
        -- e.g.  Retribution: Raid: +4.2%
    end
end
```

`IsReady()` is true shortly after login.

**What you get back:**

| Field | Example | Meaning |
|---|---|---|
| `upgradePct` | `4.2` | How much better the whole character gets, in %. **Negative = downgrade.** |
| `upgrade` | `21.5` | The same as points. |
| `itemScore` | `60.0` | The item's own score. |
| `equippedScore` | `38.5` | The score of the item it would replace. |
| `equippedLink` | `[Old Ring]` | The item it would replace. |
| `slot` | `12` | The inventory slot it was compared against. |
| `equipped` | `false` | `true` if this exact item is already worn. |
| `spec`, `specName` | `"RET_STANDARD"`, `"Retribution: Raid"` | The spec it was judged for. |
| `characterScore`, `newCharacterScore` | `500`, `521.5` | The whole character's score now and with the item. |

These are the same numbers SGJ shows in its own tooltip.

**If it can't score**, you get `nil` plus a reason:

| Reason | What to do |
|---|---|
| `"NOT_CACHED"` | The game hasn't loaded that item yet. Try again in a second. |
| `"NOT_USABLE"` | This character can't use the item (wrong armor or weapon type). |
| `"NOT_EQUIPPABLE"` | It isn't gear. |
| `"NOT_READY"` | SGJ is still loading. |
| `"BAD_LINK"` | That wasn't an item link. |
| `"ERROR"` | Something broke on our side. Please tell us. |

---

## 3. Ask the whole raid (loot council)

SGJ on your computer only knows **your** character. So for an item that drops, ask the raid: every raider running SGJ checks the item against their own gear and spec, and sends back their result.

```lua
SGJ.RequestScores(itemLink, "RAID", nil, function(playerName, result)
    if result.status == "OK" then
        print(playerName .. ": " .. string.format("%+.1f%%", result.upgradePct))
    else
        print(playerName .. ": " .. result.status)   -- e.g. NOT_USABLE
    end
end)
```

**How it behaves:**
- Your function is called **once per raider who answers**, and once for you right away.
- You can pass one item link or a list of them, e.g. `{ link1, link2 }`.
- Answers arrive within a couple of seconds; they're spaced out so a full raid doesn't flood the chat channel.
- Raiders **without SGJ don't answer**. Neither do raiders who turned sharing off. So treat "no answer" as "unknown".
- Other channels: `"PARTY"`, `"GUILD"`, `"INSTANCE_CHAT"`, or `"WHISPER"` with a player name as the third argument.

**Each answer has:**
- `status`: `"OK"`, or one of the reasons from section 2.
- `upgradePct`, `itemScore`, `equippedScore`, `slot`, `spec`.
- `itemID`, and `equippedItemID` (what they'd replace).

**To compare raiders, use `upgradePct`, not scores.** Every character's scores are on their own scale, so a 60 for a Warrior and a 60 for a Mage don't mean the same thing.

---

## 4. Get told when things change (optional)

```lua
SGJ.RegisterCallback("SCORES_CHANGED", function()
    -- your gear, talents, level or SGJ settings changed: earlier results are out of date
end)

SGJ.RegisterCallback("SCORES_RECEIVED", function(playerName, result)
    -- every raid answer, from any RequestScores call
end)
```

---

## 5. Good to know

- **Privacy:** raiders can switch answering off in SGJ's settings ("Share Scores With Group Addons", on by default). Only the numbers listed above are sent, nothing else.
- **Version check:** `SGJ.GetVersion()` returns `1, "3.2.7"` (API version, addon version). The API version only goes up if something stops working the old way.
- **Current spec:** `SGJ.GetSpec()` returns the spec the player is judged for, e.g. `"RET_STANDARD", "Retribution: Raid"`.
- **Edge cases:**
  - Shield tanks are never told a two-hander is an upgrade.
  - Items with mostly useless stats score 0.

<details>
<summary>Message format (only if you don't want to use RequestScores)</summary>

Addon prefix `SGJ`, fields separated by `~`:

```
Request:  Q~1~<requestId>~<itemString>^<itemString>...
Answer:   A~1~<requestId>~<itemID>~<status>~<upgradePct>~<itemScore>~<equippedScore>~<slot>~<equippedItemID>~<specKey>
```

Answers are whispered back to whoever asked, one per item.

| Status code | Meaning |
|---|---|
| `OK` | Scored. |
| `NC` | Not cached. |
| `NU` | Not usable. |
| `NE` | Not equippable. |
| `NR` | SGJ not ready. |
| `ER` | Error. |
</details>

Questions or ideas: [GitHub](https://github.com/Supersharpie/SharpiesGearJudge) or the SGJ Discord.
