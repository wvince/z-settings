# Z-Settings

A shared WoW Forever `Interface\AddOns` folder. Cloning it installs the addons; `/z import`
applies the bundled interface settings, with keybinds converted to the local keyboard layout.

## How it works

| Step | Command | Result |
|---|---|---|
| Export | `/z export` | setup saved to `WTF\...\SavedVariables\Z-Settings.lua`, UI reloads |
| Publish | `git commit`, `git push` | `.githooks/pre-commit` copies the setup into `Z-Settings/ZBundle.lua` |
| Update | `git pull` | addons added, updated and removed; untracked addons untouched |
| Apply | `/z import` | settings applied from `ZBundle.lua`, UI reloads |

## Install

Requires [Git for Windows](https://git-scm.com/download/win) and collaborator access.

1. Close WoW.
2. In `World of Warcraft\_classic_beta_\Interface`, rename `AddOns` to `AddOns-old`.
3. From `Interface`, run `git clone https://github.com/wvince/z-settings.git AddOns`.
4. Optional: copy personal addons from `AddOns-old` into `AddOns`.
5. Start WoW, run `/z import` and press the key right of Tab (QWERTY or Belgian AZERTY).

## Update

1. Close WoW.
2. In `AddOns`, run `git pull`.
3. Start WoW, run `/z import`.

A new addon needs a full client restart. If `git pull` reports local changes, `git reset --hard origin/main`
discards them.

## Scope

| Shared | Not shared |
|---|---|
| Interface settings, nameplates, keybinds, chat windows | Action bar contents, Cooldown Manager |
| Enabled addons and their settings | Class macros and spell macros |
| Target and menu click casting, General macros without spells | Graphics, sound |

The exporter's active Edit Mode layout arrives as a layout named `Zeroshin`, overwriting an earlier
one; other layouts stay. With every layout slot taken, the exporter's layouts replace them all.
`/z undo` restores the settings from before the last import.

## Publishing

```
git add -A && git commit -m "update setup" && git push
```

Run after `/z export`. The hook also writes each addon's settings-table names from the
tocs, and rejects the commit when no export exists or the addon list changed since the export. It
requires `git config core.hooksPath .githooks` once per clone. `BarSync` and `ZeroshinSetup` are ignored.

Tests: `uv run --with lupa --with pytest pytest .tests/test_zsettings.py -q`.
