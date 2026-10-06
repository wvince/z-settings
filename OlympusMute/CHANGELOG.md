# OlympusMute Changelog

## 1.3.1

### New
- **Ask before trading.** When a muted player opens a trade with you, a window asks: Allow trade or Decline. Handy for enchants or mats bought in the world. Allowing covers trades with that player for the next 10 minutes, and they stay muted. If the trade ends on its own, the window closes. Replaces the automatic trade decline; turn it off with "Ask before trades" in the options or `/omute trades off`.

### Fixed
- Group invites from muted players are now really declined after the short pause. In 1.3.0, hiding the invite window could decline it right away.
- A pause that was still running can no longer decline a different player's invite that arrives right after.
- Turning off auto-decline, or unmuting someone, during the pause now gives you the invite or duel back. Turning on "Decline group invites and duels instantly" sends any waiting decline right away.
- "Unmute forever" in the group window now uses the full two-part name (like "Tiny Yackle"), and the window shows full names.
- Clicking "Unmute forever" or the log's "Never mute" a second time no longer undoes it.
- "Unmute while grouped" now ends on time even when nothing changes in the group, and after a /reload. Choosing it after the player has already left does nothing.
- An open message in the muted messages log no longer changes to a newer message.
- Removing a newly muted player's old messages no longer removes whispers you sent to them, and now also clears their older community channel messages.
- When a muted and an unmuted player say the same thing at the same time, the chat bubble stays visible.
- The whisper warning no longer appears for a player you've unmuted while grouped.

### Improved
- The Scan button also searches above the highest level it has seen so far, so higher-level members can't stay hidden behind a full first search.
- `/omute` help now says that `/omute allow Name` works as a toggle (type it again to undo).

## 1.3.0

### New
- **Unmute while grouped.** When a muted player is in your group (you join theirs, or they join yours), a window lets you choose: Unmute while grouped, Keep muted, or Unmute forever.
- When you invite a muted player, the window offers Unmute while grouped, Keep muted, or Cancel invite.
- "Unmute while grouped" shows their chat only while you're in the same group. They're muted again automatically when they leave, when the group ends, or if they never join. It lasts through a /reload.
- **Muted messages log.** Click "Muted messages..." in the options or type `/omute log` to see what OlympusMute hid in the last 15 minutes (up to 50 messages). It's kept in memory only: never saved, and cleared on /reload or logout.
- **Report from the log.** Click a message to open Blizzard's report window for that exact message. You can also choose Never mute for the sender from there.
- **Import your ignore list.** Click "Import ignore list..." or type `/omute import` to add everyone on your WoW ignore list to your mute list. They stay muted whatever guild they join, and you can choose to clear them from the ignore list to free up slots.

### Improved
- **Human-speed declines.** Group invites and duels from muted players are now declined after a short random pause (2 to 8 seconds), like a person clicking Decline, instead of instantly. You never see the request: its window is hidden right away. The pause is short enough that other players' invites still reach you. If you prefer the old behavior, tick "Decline group invites and duels instantly" in the options or type `/omute instant on`.
- Smoother performance in busy areas. When several muted players are spotted at once, their old chat lines are removed in one batch, one chat window per frame, instead of all at once. New messages from them are still hidden immediately; older lines may take a moment to disappear.
- Chat bubbles are checked less often, and turning bubble hiding off stops the checks right away.
- The muted players window has a "Sort: Name / Sort: Guild" button. Sorting by guild groups each guild's members together.
- The guild list and filtered words are shown in alphabetical order.
- Also hides muted players in community channels, and declines hardcore death-duel requests from them.
- Messages from GMs and Blizzard staff are never hidden by name keywords.

### Fixed
- Typing a two-part name with a dash (like "Tiny-Yackle") now mutes the right player. The player box now says "Player (First Last)".
- Targeting a muted player whose guild info hadn't loaded yet could unmute them.
- Running /who on a player no longer makes the result disappear when it reveals a new muted player.
- List sharing sends large lists reliably, tells you if part of your list didn't fit, and rejects malformed or formatted entries.
- Turning filtering off now brings back any hidden chat bubbles, and a bubble with the same text from someone else is no longer hidden.
- Role-check group invites from muted players are closed properly, and an old invite can't be declined minutes after it ended.

### Thanks
- @Dawnbard (Twitter) for the group idea
- JakeyCakey1124 (CurseForge) for temporary unmute of party members
- Mr_Zoner (forums) for the sorting and ignore list ideas
- Laurendor (CurseForge) for the idea of a place to see muted chat
- jstelzer (CurseForge) for tracking down the slowdown in busy areas and suggesting the batching approach
- user_pzoguhlc9va2le884725 (CurseForge) for comma-separated entry and the scan counter fix

## 1.2.1
- Fixed: shared lists are now only accepted from your group, your guild, or your friends list, with at most one share window per minute. Strangers can no longer send you share popups.
- Fixed: a flood of incomplete share messages can no longer build up in the background.
- Fixed: auto-decline messages (duels, trades, group and guild invites) are shown at most once per player per minute, so someone spamming requests can't flood your chat.

## 1.2.0
- New: share your lists. Send your guild names and filtered words to a friend (`/omute share Name`), your group (`/omute share`) or your guild (`/omute share guild`), or use the "Share lists..." button in the options. They see what's in it and choose Add to mine, Replace mine, or Cancel. Players are never shared. Turn off incoming shares with `/omute shares off`. Thanks to delro_ed (Twitch chat) for the idea.
- New: mute by name. Hide chat from any player whose character name contains a word, with the "Name contains" button in the options or `/omute name add|remove text`. Thanks to ENDrain (CurseForge) for the suggestion.
- New: inviting someone on your mute list now opens a window with a "Cancel invite" button, instead of only a chat warning.
- New: `/omute tally` shows your total hidden messages, this session's count, and how many players are muted, in one line in your chat. (`/omute stats` still works too.)

## 1.1.2
- Fixed: a player whose name hadn't loaded yet (shown as "Unknown") could overwrite or remove someone's entry on your mute list. Any "Unknown" entries this created are cleaned up automatically. If a player you muted by hand has gone missing from your list, mute them again.
- Fixed: players from other realms are no longer renamed by the 1.1.1 name repair. Name repair now happens when a player is next seen or their name is typed, instead of all at once at login. Entries 1.1.1 changed by mistake are corrected once you see that player again.
- Fixed: realm names with spaces or dashes (like "Aerie Peak") now match everywhere: typed names, names the addon learns, and entries saved before. They're stored the way chat writes them.
- Fixed: when you mute someone, their old messages are now removed no matter how you capitalize the name, and a player with the same name on another realm keeps theirs.
- Fixed: whisper pop-out windows are now cleaned up and scanned for /who results too, like your normal chat tabs.
- Fixed: a damaged settings file is now repaired on login instead of stopping parts of the addon from working.
- Fixed: on non-English game clients, a guild invite from a whitelisted guild could still be declined.
- Fixed: declining group invites from muted players could miss them when matching by character.
- Fixed: old entries saved with a comma in them (from before 1.1.0) can be removed again by typing them exactly as shown.
- Improved: the Scan button now reads "Next scan 4/9 in 5s" while it cools down, so it no longer looks out of step with the chat message for the scan that just ran.
- Improved: the addon keeps working if a future game update renames the function it uses to filter chat.

## 1.1.1
- Fixed: players with two-part names (like "Bacon Eggz") weren't recognized by name. Their chat was still hidden, but whisper and invite warnings, `/omute check`, Unmute, and duel and trade declines missed them. Existing saved names are repaired automatically the first time you log in.
- Improved: the whisper warning also recognizes muted players by character, so it works even if the name is written differently.
- Improved: whisper, invite and group warnings are now one short line each instead of a paragraph.
- Improved: performance. Chat lines are checked about 3x faster, and players you pass in cities (nameplates, mouseover) about 4x faster. Removing a guild name or whitelisting a guild with a big mute list no longer causes a hitch.

## 1.1.0
- New: warning when you whisper someone on your mute list. The chat box header turns red and a note explains their replies will be hidden, so you can press Esc before sending.
- New: warning when you invite someone on your mute list to your group, since their party chat would be hidden.
- Both can be toggled with "Warn if I whisper/invite a muted player" in the options, or `/omute whisperwarn on|off`.
- New: add several entries at once by separating them with commas, in the guild, word and player boxes and in `/omute` commands (e.g. `olympus, holypmus` or `/omute add Name1, Name2`).
- Fixed: word filters no longer match hidden link data, so a filter like "item" doesn't hide every message with an item link. The visible link name, like [Thunderfury], can still be filtered.
- Fixed: messages from GMs and Blizzard staff are never hidden by the word filter.
- Fixed: clicking Mute on a player the addon had already found now keeps them muted even if they change guilds.
- Fixed: removing a word filter typed with extra spaces, or with/without quotes, now works.
- Fixed: `/omute` on/off settings accept any capitalization (e.g. `/omute bubbles OFF`).
- Fixed: `/omute clear` now asks for confirmation, like the button does.
- Fixed: you can no longer mute yourself.
- Fixed: errors while declining group invites are now reported instead of failing silently.
- The `/omute` help line now lists every command.
- Thanks to Adondriel2 for suggesting the whisper/invite warnings.

## 1.0.11
- Improved: word filter entries with several words now match messages that contain all of those words in any order, e.g. "invite layer" hides "inv to asmon layer pls". Put an entry in quotes to match only that exact phrase.
- Fixed: the muted-player list window now shows every player. Long lists used to get cut off partway through the alphabet. It also has a search box.
- Improved: guild names don't need a * wildcard (they already match any part of the name). A * is ignored, and entries already covered by a shorter name (like "olympusa" when "olympus" is listed) are cleaned up automatically, which also shortens the Scan rotation.
- Fixed: shift-click and /who results are recognized again when chat timestamps are turned on.
- Fixed: typing /omute during combat no longer causes an "action blocked" error. The options now open as soon as combat ends.
- Changed: clearer wording in the options page about how players get added to the mute list.
- Changed: more compact options page so it fits in the Settings window: checkboxes in two columns, one player box with Mute / Never mute / Unmute, and the list buttons grouped together.
- Thanks to Aenaura for reporting the list cut-off and wildcard issues in-game.

## 1.0.10
- Performance: when a message shows in several chat windows, the mute decision is made once and reused, instead of once per window.
- Performance: ordinary chat lines are skipped almost immediately; only /who results, invite lines, and the /who throttle notice get parsed.
- Performance: each sender's name is processed once per message, and your realm is looked up once instead of on every message.
- Performance: seeing a player from a non-muted guild no longer checks the entire muted list.
- Performance: a /who scan or group scan clears old chat lines in one pass per window, not one pass per player found.
- Performance: the muted-list window updates only when the list changes, instead of recounting every second.
- Fixed: a muted player who moves to a different muted guild (e.g. OLYMPUS II to OLYMPUS IX) now shows the new guild in the list, tooltips, and warnings, and guild removal or whitelisting uses it.
- Fixed: the list window now also updates for Never mute changes, and when one player is muted and another unmuted in the same moment.
- Changed: player counts show thousands separators (1,565).
- Thanks to a community member for a detailed performance review.

## 1.0.9
- Fixed: the Scan button now has a 5-second cooldown with a countdown, and if the server still says to wait, the same search is retried on the next click instead of being skipped.
- New: OlympusMute now shows its logo in the in-game AddOns list.
- Changed: the muted-player list moved to its own window ("View list" button next to the muted count, or `/omute list`), so the options page fits on screen.
- New: word filter. Hide messages from anyone that contain a word or phrase you choose, e.g. "asmon layer" (options panel, or `/omute word add text`).
- Fixed: the addon is now flagged for the current WoW Forever client (1.60.1), so it loads without needing "Load out of date AddOns".

## 1.0.8
- New: warns you when you're in a group with a muted player, with a note that their chat is hidden (toggle in options, or `/omute groupwarn on|off`).
- New: guild whitelist for exact guild names that should never be muted, e.g. "Anti Olympus" (button in the guild section, or `/omute guild whitelist Name`).
- New: hides muted players' chat bubbles in the open world (dungeons and raids don't allow addons to touch bubbles). Toggle in options or `/omute bubbles on|off`.
- Changed: hidden-message stats now sit at the top of the options panel.
- Fixed: duplicate /who result lines (the same player listed several times) are collapsed into one.

## 1.0.7
- New: muted players show a "Muted by OlympusMute" line in their tooltip.
- New: hidden-message counter in the options panel (and `/omute stats`).
- New: auto-decline duels and trades from muted players (toggle in options, or `/omute duels|trades on|off`).
- New: "Never mute" list for friends in muted guilds (button next to Add to list, or `/omute allow Name`).
- Changed: "Clear list" is now "Unmute all players..." next to the muted-player header, away from the Scan button, with a clearer confirmation.

## 1.0.6
- New: add your own guild names to mute, under "Muted guild names" in the options or `/omute guild add Name`. Olympus stays on the list by default.
- New: players who leave a muted guild are automatically unmuted when a /who or shift-click shows their new guild (players you added by hand stay muted).
- Improved: the Scan button cycles through every guild on your list, and only up to the highest level it has seen.

## 1.0.5
- New: separate options for auto-declining guild invites and group invites.
- Improved: the Scan button cycles through level ranges to get around /who's 50-result limit; `/omute check Name` shows whether a player is muted.

## 1.0.4
- Fixed: auto-decline reliably closes guild invites from muted guilds.
- Fixed: shift-clicking a name no longer sends the same /who several times in a row.
- New: errors are shown in chat instead of failing silently; `/omute debug` for troubleshooting.

## 1.0.3
- Fixed: shift-click and single-player /who results are now detected on the Forever client.
- New: "Add to list" to mute a player by hand.

## 1.0.2
- New: auto-declines group invites from muted players.

## 1.0.1
- New: auto-declines guild invites from Olympus guilds and mutes the inviter.

## 1.0.0
- Initial release.
