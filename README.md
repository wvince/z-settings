# Z-Settings

A shared WoW Forever `Interface\AddOns` folder. Cloning it installs the addons, and the Z-Settings addon
does two things:

- **Setup sharing:** at login, a popup offers the parts of the published setup that differ from your UI,
  with keybinds converted to your keyboard.
- **Character copy:** copies one of your characters' complete setup onto another, on any account.

## Install

Requires [Git for Windows](https://git-scm.com/download/win) and collaborator access.

1. Close WoW.
2. In `World of Warcraft\_forever_\Interface`, rename `AddOns` to `AddOns-old`.
3. From `Interface`, run `git clone --depth 1 https://github.com/wvince/z-settings.git AddOns`. `--depth 1` skips
   the history, hundreds of MB of old addon versions you never need.
4. Optional: copy personal addons from `AddOns-old` into `AddOns`.
5. Start WoW, click Apply in the popup and press the key right of Tab (QWERTY or Belgian AZERTY).
   The key is asked once.
6. Put your own spells on your bars. Setup sharing never places anything on them.

## Update

1. Close WoW.
2. In `AddOns`, double-click `update.cmd`. What CurseForge or another updater changed in a shared addon
   is replaced by the published version; addons that aren't in the repo stay.
3. Start WoW and click Apply. The popup lists only the parts that differ from your UI, all ticked; untick
   one to keep yours. With nothing different there is no popup. Each character gets its own popup.

A new addon needs a full client restart. `git pull` works too, but stops with "your local changes" once
an updater has changed a shared addon.

## Commands

| Command | Does |
|---|---|
| `/z update` | opens the setup popup with every part, also after Later |
| `/z import` | applies the whole setup and asks the keyboard key again |
| `/z save` | saves this character for copying |
| `/z copy [name]` | copies a saved character onto this one; without a name, a list to choose from |
| `/z undo` | reverts the last apply or copy on this character |
| `/z export [note]` | saves your setup for publishing (publisher only) |
| `/z help` | lists the commands |

Each command reloads the UI when it changes something, and none runs in combat.
The minimap button (drag it round the edge) opens the same commands as a menu, Export only on the PC
that publishes. Its orange dot means the published setup still changes something on this character,
also after Later.

## Setup sharing

| Shared | Not shared |
|---|---|
| Interface settings, nameplates, keybinds, chat windows | Anything on action bars, Cooldown Manager |
| Enabled addons and their settings | Class macros, macros that cast a spell, RareScanner and RXP macros |
| Target and menu click casting, General macros without spells | Graphics, sound, addon data, per-character addon tables, Baganator, Clique's click spells |
| Your active profile in Dominos, Questie, Details and other profile addons | Your other profiles |
| Windows you dragged into place (guide window, RareScanner button) | Action bars you moved |

The publisher's active Edit Mode layout arrives as a layout named `Zeroshin UI` and is selected; your
other layouts stay. With every account slot taken it becomes a character layout; with every slot taken
Edit Mode is left alone. Addons that keep a profile per character work the same way: your active profile
arrives as `Zeroshin UI` and is selected on that character, their own profiles stay, and `/z undo`
selects theirs again. A macro an earlier import brought and the setup no longer has is deleted; your
own macros never are, even one sharing a name with a shared macro.

## Character copy

A copy replaces the whole setup of the character you are on: action bars, macros, keybinds, click
casting, settings, Edit Mode layouts, Cooldown Manager, chat windows, which addons are on and their
settings. It works across classes: spells the character doesn't know are listed and left off the bars.

1. On the character to copy from: `/z save`, then log out.
2. Only when copying to another game account whose `SavedVariables` folder isn't linked to this one: in
   `AddOns`, run `./characters`.
3. On the character to copy to: `/z copy`, choose the character, click Copy.
4. Check the result. `/z undo` puts the character back as it was.

Save right before copying: everything comes from the save, except addon settings files the two
characters already share (same account, or linked `SavedVariables` folders). Those stay as they are, and
only the saved character's AceDB profile and character data move over. Addons that store characters
another way keep this character's own entry. Saves stay on this PC and are never published.

## Publishing

1. In game: `/reload`, then `/z export [note]`.
2. In `AddOns`: `./publish`.

`./publish` commits everything and pushes. The commit hook writes `Z-Settings/ZBundle.lua`: each addon's
settings-table names, read from the tocs, and the latest export. It rejects the commit when there is no
export, when a shared addon was added after the export (it names them), or when nothing changed. Addon
folders in `.gitignore` are never shared and never ask for a re-export. `Z-Settings/ZCharacters.lua` is
never committed.

Tests: `uv run --with lupa --with pytest pytest .tests -q`.
