@echo off
setlocal enabledelayedexpansion
title iw3xo launcher



:1
rem Checking if folder is dragged into this batch file
if "%~1"=="" (
    goto 2
)

rem Getting the folder name
set "folderPath=%~1"
for %%i in ("%folderPath%") do set "modname=mods/%%~nxi"
goto launch



:2

echo Drag your MOD folder into this window and press ENTER to launch iw3xo with the mod
echo OR
echo Leave empty and press ENTER to launch without mods
set /p modPath=iw3mp.exe: %=%

if "!modPath!"=="" (
set "modname="
goto launch
)
if "!modPath!"==" " (
set "modname="
goto launch
)
if "!modPath!"=="  " (
set "modname="
goto launch
)

rem Getting the last folder name
for %%B in ("%modPath%") do (
    set "modname=mods/%%~nxB"
)



:launch
cd ../
start iw3mpHAMACHI1.7.exe +set fs_game "%modname%" +set sv_punkbuster 0 +set cl_punkbuster 0 +set r_custommode "1920x1080" +set r_aspectratio 3 +set r_fullscreen 0 +set r_noborder 0 +set developer 0 +set developer_script 0

endlocal