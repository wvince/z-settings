@echo off
rem Brings this AddOns folder to the published setup, addon for addon: whatever CurseForge or another
rem updater changed in a shared addon is replaced by the published version, so this never conflicts the
rem way git pull does. Addons that aren't in the repo (your own) stay as they are. Double-click it.
cd /d "%~dp0"
rem full paths: Git for Windows can put its own find first on the PATH
"%SystemRoot%\System32\tasklist.exe" /fi "imagename eq Wow.exe" /nh 2>nul | "%SystemRoot%\System32\findstr.exe" /i /b "Wow.exe" >nul && (
  echo Close WoW first, then run this again.
  pause
  exit /b 1
)
git fetch --quiet origin || (
  echo Couldn't reach GitHub. Check your internet connection and try again.
  pause
  exit /b 1
)
git reset --hard --quiet origin/main || (
  pause
  exit /b 1
)
for /f "delims=" %%d in ('git log -1 --format^=%%cd --date^=format:"%%Y-%%m-%%d %%H:%%M"') do echo Up to date with the setup published %%d.
echo Start WoW and click Apply in the popup.
pause
