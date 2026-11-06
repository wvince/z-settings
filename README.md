# Z-Settings

Zeroshin's WoW Forever UI: every addon, plus the Z-Settings addon, which does two things:

- **Setup sharing:** after you log in, a popup offers the parts of Zeroshin's setup that differ from your
  UI, with keybinds converted to your keyboard.
- **Character copy:** copies one of your characters' complete setup onto another, on any account.

## Install

There are two ways. Both give the same UI; they differ in how you update later.

| | Download (no Git) | Git |
|---|---|---|
| Install | download a ZIP file, unzip it | install Git, paste one command |
| Update | download the ZIP again | double-click `update.cmd` |

Not sure? Take the download.

### 1. Find your addons folder

1. Close WoW.
2. In the Battle.net app, select World of Warcraft, click the gear next to Play and choose Show in
   Explorer. Usually that's `C:\Program Files (x86)\World of Warcraft`.
3. Open `_forever_`, then `Interface`. No `Interface` folder? Create it.
4. Is there an `AddOns` folder? Rename it to `AddOns-old`.

### 2a. Install by download

1. Go to [github.com/wvince/z-settings](https://github.com/wvince/z-settings), click the green Code
   button, then Download ZIP. It's a big download (about 800 MB unpacked).
2. Right-click the downloaded `z-settings-main.zip` and choose Extract All.
3. Click Browse, pick the `Interface` folder from part 1 and click Extract.
4. In `Interface`, rename `z-settings-main` to `AddOns`.
5. Check that this file exists: `Interface\AddOns\Z-Settings\Z-Settings.toc`. Is there an
   `AddOns\z-settings-main` folder in between? Move its contents up one level, or the game finds no
   addons.

### 2b. Install with Git

1. Install [Git for Windows](https://git-scm.com/download/win). Keep every default the installer
   offers.
2. In the `Interface` folder from part 1, click Explorer's address bar, type `cmd` and press Enter.
3. In the black window, paste this and press Enter:
   `git clone --depth 1 https://github.com/wvince/z-settings.git AddOns`
4. Wait until it's done and close the window.

### 3. First start

1. Had your own addons? Move them from `AddOns-old` into `AddOns`.
2. Start WoW and log in to a character. Click Apply in the popup.
3. Press the key right of Tab when asked (QWERTY or Belgian AZERTY). It's asked once.
4. Put your own spells on your bars. Setup sharing never places anything on them.

## Update

Your settings and characters are stored outside `AddOns`, so an update keeps them.

**Downloaded:**

1. Close WoW.
2. In `Interface`, delete `AddOns-old` if it's still there, then rename `AddOns` to `AddOns-old`.
3. Do part 2a again, then move your own addons over from `AddOns-old`.
4. Start WoW and click Apply.

`update.cmd` doesn't work for a download. It says so when you try.

**With Git:**

1. Close WoW.
2. In `AddOns`, double-click `update.cmd`. Shared addons that CurseForge or another updater changed go
   back to Zeroshin's version; your own addons stay.
3. Start WoW and click Apply.

The popup lists only the parts that differ from your UI, all ticked. Untick one to keep yours. With
nothing different there is no popup, and each character gets its own. A new addon needs a full game
restart, not just `/reload`.

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
