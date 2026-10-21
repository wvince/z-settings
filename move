#!/bin/sh
# Moves this install's whole setup into another WoW install (default: _forever_): the shared addons as
# a git checkout, the addons git ignores, every account's addon settings and the /z save saves. Then
# /z copy on the new character brings the rest (bars, macros, keybinds, its own addon data).
# Nothing is deleted: what the target had goes into one before-move-<time> folder in that install.
set -e
src_addons=$(cd "$(dirname "$0")" && pwd)
src=$(cd "$src_addons/../.." && pwd)
dst=${1:-$src/../_forever_}
[ -d "$dst" ] || { echo "No WoW install at $dst. Start that game version once, then run this again." >&2; exit 1; }
dst=$(cd "$dst" && pwd)
[ "$dst" != "$src" ] || { echo "Source and target are the same install." >&2; exit 1; }
backup="$dst/before-move-$(date +%Y%m%d-%H%M%S)"

# WoW writes every settings file again at logout, which would undo the move
if ${TASKLIST:-tasklist.exe} 2>/dev/null | grep -qi '^wow'; then
  echo "WoW is running. Close every WoW window, then run this again." >&2
  exit 1
fi

# the target gets what is published, so the source must hold nothing unpublished
cd "$src_addons"
if [ -n "$(git status --porcelain)" ]; then
  echo "This AddOns folder has changes that aren't published. Run ./publish first, then this again." >&2
  exit 1
fi
git fetch -q
if [ "$(git rev-parse HEAD)" != "$(git rev-parse '@{u}')" ]; then
  echo "This AddOns folder and GitHub differ. Run ./publish (or git pull) first, then this again." >&2
  exit 1
fi
repo=$(git remote get-url origin)

# 1. shared addons: a checkout of the same repo, updated; anything else there is moved aside
addons="$dst/Interface/AddOns"
mkdir -p "$dst/Interface"
if [ -d "$addons/.git" ] && [ "$(git -C "$addons" remote get-url origin 2>/dev/null)" = "$repo" ]; then
  if [ -n "$(git -C "$addons" status --porcelain --untracked-files=no)" ]; then
    mkdir -p "$backup" && mv "$addons" "$backup/AddOns"
    git clone -q "$repo" "$addons"
  else
    git -C "$addons" pull -q --ff-only
  fi
else
  if [ -e "$addons" ]; then mkdir -p "$backup" && mv "$addons" "$backup/AddOns"; fi
  git clone -q "$repo" "$addons"
fi
git -C "$addons" config core.hooksPath .githooks
echo "Addons: $(git -C "$addons" log -1 --format='%h %s')"

# 2. addons git ignores (personal ones), copied as they are here
for dir in "$src_addons"/*/; do
  name=$(basename "$dir")
  git check-ignore -q "$name/" || continue
  rm -rf "${addons:?}/$name"
  cp -R "$dir" "$addons/$name"
  echo "Personal addon: $name"
done

# 3. account addon settings: the newest copy of each file across this install's accounts, into every
# account of the target (and one per source account, for an account not logged in there yet)
accounts=$( (ls "$src/WTF/Account"; ls "$dst/WTF/Account" 2>/dev/null) | grep '#' | sort -u)
[ -n "$accounts" ] || { echo "No game account folders in $src/WTF/Account." >&2; exit 1; }
files=$(ls -t "$src"/WTF/Account/*#*/SavedVariables/*.lua 2>/dev/null | awk -F/ '!seen[$NF]++')
[ -n "$files" ] || { echo "No addon settings in $src/WTF/Account." >&2; exit 1; }
for account in $accounts; do
  sv="$dst/WTF/Account/$account/SavedVariables"
  if [ -d "$sv" ] && [ -n "$(ls -A "$sv")" ]; then
    mkdir -p "$backup/WTF/Account/$account" && cp -R "$sv" "$backup/WTF/Account/$account/"
  fi
  mkdir -p "$sv"
  printf '%s\n' "$files" | while IFS= read -r f; do cp "$f" "$sv/"; done
done
echo "Addon settings: $(printf '%s\n' "$files" | wc -l | tr -d ' ') files into $(printf '%s\n' "$accounts" | wc -l | tr -d ' ') account(s)"

# 4. character saves from every account here, for /z copy
"$src_addons/characters" >/dev/null
cp "$src_addons/Z-Settings/ZCharacters.lua" "$addons/Z-Settings/ZCharacters.lua"
echo "Character saves: $(grep -c '"ZC1:' "$addons/Z-Settings/ZCharacters.lua")"

echo
[ -d "$backup" ] && echo "What the target had before: $backup"
echo "Done. In the new game: log in on your character, type /z copy, pick the character, click Copy."
