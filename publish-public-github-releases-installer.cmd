@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ============================================================
echo  Brainal release publisher
echo ============================================================
echo.

rem --- Sync tags from GitHub so the release number accounts for tags
rem     created elsewhere; offline is fine, local tags are then used as-is.
git fetch origin --tags --quiet 2>nul

rem --- Base version comes from the app's package.json (e.g. 2.0.0)
set "BASE="
for /f "usebackq delims=" %%v in (`node -p "require('./packages/bruno-electron/package.json').version"`) do set "BASE=%%v"
if not defined BASE (
  echo ERROR: could not read version from packages/bruno-electron/package.json
  echo        ^(is Node.js installed and on PATH?^)
  goto :fail
)

rem --- Find the highest existing brainal release number for this base version
set /a MAX=0
for /f "usebackq delims=" %%t in (`git tag -l "v%BASE%-brainal.v*"`) do (
  set "TAG=%%t"
  set "N=!TAG:*brainal.v=!"
  echo !N!| findstr /r "^[0-9][0-9]*$" >nul && if !N! gtr !MAX! set /a MAX=!N!
)
set /a NEXT=MAX+1
set "NEWTAG=v%BASE%-brainal.v%NEXT%"

for /f "usebackq delims=" %%b in (`git rev-parse --abbrev-ref HEAD`) do set "BRANCH=%%b"
for /f "usebackq delims=" %%h in (`git rev-parse --short HEAD`) do set "COMMIT=%%h"

git status --porcelain | findstr . >nul && (
  echo WARNING: you have uncommitted changes - they will NOT be part of this release.
  echo.
)

echo   Base version   : %BASE%
echo   Last release   : v%BASE%-brainal.v%MAX%  ^(0 = none yet^)
echo   New release    : %NEWTAG%
echo   Will be built  : from commit %COMMIT% on branch %BRANCH%
echo.
choice /c YN /m "Create and push %NEWTAG% (triggers the GitHub Release build)?"
if errorlevel 2 goto :cancelled

git tag "%NEWTAG%" || goto :fail
git push origin "%NEWTAG%"
if errorlevel 1 (
  echo.
  echo Push failed - removing local tag %NEWTAG% so you can retry cleanly.
  git tag -d "%NEWTAG%"
  goto :fail
)

echo.
echo ============================================================
echo  Done. GitHub Actions is now building %NEWTAG%.
echo  Watch:    https://github.com/ignasga/Brainal/actions
echo  Release:  https://github.com/ignasga/Brainal/releases/tag/%NEWTAG%
echo  (installers appear when both Windows and macOS builds finish)
echo ============================================================
goto :end

:cancelled
echo.
echo Cancelled - nothing was tagged or pushed.
goto :end

:fail
echo.
echo Publish FAILED - see messages above.

:end
echo.
pause
