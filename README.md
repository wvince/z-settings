# Z-Settings

A shared WoW Forever `Interface\AddOns` folder. Cloning it installs the addons; at login a popup
offers the parts of the bundled setup that differ from your UI, with keybinds converted to your keyboard.

## How it works

| Step | Command | Result |
|---|---|---|
| Export | `/z export [note]` | setup saved to `WTF\...\SavedVariables\Z-Settings.lua`, UI reloads |
| Publish | `git commit`, `git push` | `.githooks/pre-commit` copies the setup into `Z-Settings/ZBundle.lua` |
| Update | `git pull` | addons added, updated and removed; untracked addons untouched |
| Apply | log in, click Apply | the listed parts applied from `ZBundle.lua`, UI reloads |

## Install

Requires [Git for Windows](https://git-scm.com/download/win) and collaborator access.

1. Close WoW.
2. In `World of Warcraft\_classic_beta_\Interface`, rename `AddOns` to `AddOns-old`.
3. From `Interface`, run `git clone https://github.com/wvince/z-settings.git AddOns`.
4. Optional: copy personal addons from `AddOns-old` into `AddOns`.
5. Start WoW, click Apply in the popup and press the key right of Tab (QWERTY or Belgian AZERTY).
   The key is asked once.
6. Put your own spells on your bars. Nothing is ever placed on them.

## Update

1. Close WoW.
2. In `AddOns`, run `git pull`.
3. Start WoW and click Apply. The popup lists only the parts that differ from your UI, all ticked; untick
   one to keep yours. With nothing different there is no popup. Each character gets its own popup.

A new addon needs a full client restart. Let only git manage this folder: CurseForge or WowUp updates
block `git pull`. If `git pull` reports local changes, `git reset --hard origin/main` discards them.

## Commands

| Command | Does |
|---|---|
| `/z update` | opens the popup with every part, also after Later |
| `/z import` | applies every part and asks the keyboard key again |
| `/z undo` | puts back what the last apply on this character changed |

## Scope

| Shared | Not shared |
|---|---|
| Interface settings, nameplates, keybinds, chat windows | Anything on action bars, Cooldown Manager |
| Enabled addons and their settings | Class macros and macros that cast a spell |
| Target and menu click casting, General macros without spells | Graphics, sound, addon data and per-character profiles |

The exporter's active Edit Mode layout arrives as a layout named `Zeroshin UI`, imported through Edit
Mode's own layout string and selected; other layouts stay. With every account slot taken it becomes a
character layout; with every slot taken Edit Mode is left alone. A macro an earlier import brought and
the setup no longer has is deleted; your own macros never are, even one sharing a name with a shared macro.

## Publishing

```
git add -A && git commit -m "update setup" && git push
```

Run after `/z export`. The hook also writes each addon's settings-table names from the
tocs, and rejects the commit when no export exists or the addon list changed since the export. It
requires `git config core.hooksPath .githooks` once per clone. `BarSync` and `WoWCompanion` are ignored.

Tests: `uv run --with lupa --with pytest pytest .tests/test_zsettings.py -q`.
