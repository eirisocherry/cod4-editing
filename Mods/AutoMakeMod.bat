

@echo off

REM [1ST PART OF THE CODE] Checks if you put this bat in the right folder <cod4root>\mods\<mod_name>
REM goes two directories above and checks if one of this files exists

cd ..\..\
set CHECKER=0
if exist iw3mp.exe (
    set /a CHECKER+=1
)
if exist iw3sp.exe (
    set /a CHECKER+=1
)
if exist iw3xo.exe (
    set /a CHECKER+=1
)
REM switches back to the directory where this .bat is located
pushd %~dp0
REM  if directory is right - continue the code, if directory is wrong - ask the user if he wants to continue
if %CHECKER% gtr 0 (
	REM true
	) else (
    echo "Wrong folder. Place this .bat file to <cod4root>\mods\<mod_name>"
	echo "Are you sure the error is a mistake and want to proceed? (Y/N)"
	choice /c YN /n > nul
	if errorlevel 2 (
    echo "No". Exiting... 
	pause
	exit
	) else (
    echo "Yes". Continuing..."
	)
)



REM !!! READ BEFORE LAUNCHING THE makeMod.bat !!!
REM !!! READ BEFORE LAUNCHING THE makeMod.bat !!!
REM !!! READ BEFORE LAUNCHING THE makeMod.bat !!!

REM 1. Install CLEAN 1.7 COD4
REM 2. Install COD4X CLIENT or IW3XO.
REM https://cod4x.ovh/t/releases/24
REM https://github.com/xoxor4d/iw3xo-dev
REM 3. Download any mod you like (skin texture, custom model etc...).
REM https://cfgfactory.com/downloads/game/COD4
REM Extract it into `<cod4root>/mods/<mod_name>`. You can give any name to the <mod_name> folder.
REM a) If your downloaded mod has `mod.ff` or `z_<any_name>.iwd` files, then it's already compiled and you don't need to do anything.
REM Simply launch your game (iw3mp.exe), choose your mod and play (/devmap mp_<map_name>).
REM b) If your downloaded mod doesn't have such files, then it's uncompiled and you need to compile it using `makeMod.bat`, otherwise the mod will not work.

REM To СOMPILE a mod:
REM 1. Install COD4 MOD TOOLS: https://github.com/promod/CoD4-Mod-Tools
REM Simply download it and extract its content into your game folder `<cod4root>`. It's the folder where you have `iw3mp.exe`.
REM 1. Download a mod and paste it to the `<cod4root>/mods/<mod_name>` folder.
REM 2. Paste this `makeMod.bat` to `<cod4root>/mods/<mod_name>`.
REM 3. Setup `makeMod.bat`. To do so, just contunue reading the text and look [!!! MODIFY IT !!!] labels. They mean you must modify something in the code.

REM [0TH PART OF THE CODE] creates mod.csv file

echo 1: Generate mod.csv 
echo 2: Make mod
echo 3: Generate mod.csv and make mod
set /p "userInput=Choose an option: "

@echo on
if /i "%userInput%"=="2" goto MODMAKER_CODE



pushd %~dp0
if exist mod.csv del mod.csv

if exist "%cd%\materials\" (
dir /b "%cd%\materials\" > temp
for /f %%a in (temp) do (echo material,%%a>>mod.csv)
)

if exist "%cd%\xanim\" (
dir /b "%cd%\xanim\" > temp
for /f %%a in (temp) do (echo xanim,%%a>>mod.csv)
)

if exist "%cd%\xmodel\" (
dir /b "%cd%\xmodel\" > temp
for /f %%a in (temp) do (echo xmodel,%%a>>mod.csv)
)

if exist "%cd%\mp\" (
dir /b "%cd%\mp\" > temp
for /f %%a in (temp) do (echo rawfile,mp/%%a>>mod.csv)
)

if exist "%cd%\ui_mp\" (
dir /b "%cd%\ui_mp\" > temp
for /f %%a in (temp) do (echo menufile,ui_mp/%%a>>mod.csv)
)

if exist "%cd%\soundaliases\" (
dir /b "%cd%\soundaliases\" > temp
for /f %%a in (temp) do (echo sound,%%~na,,all_mp>>mod.csv)
)

if exist "%cd%\weapons\mp\" (
dir /b "%cd%\weapons\mp\" > temp
for /f %%a in (temp) do (echo weapon,mp/%%a>>mod.csv)
)

del temp

if /i "%userInput%"=="1" (
echo mod.csv is successfully created.
pause
exit
)



:MODMAKER_CODE

REM [1st PART OF THE CODE] deletes specified files in the current folder (they will be recreated later)
REM [!!! MODIFY IT !!!] replace <mod_name> with your mod's name, for example, if your directory looks like `<cod4root>/mods/magnum` then rename `del z_<mod_name>.iwd` to `del z_magnum.iwd`

REM mod_name = mod's folder name
for %%i in ("%~dp0.") do set "mod_name=%%~nxi"
del z_%mod_name%.iwd
del mod.ff



REM [2nd PART OF THE CODE] copies mod's folders into `<cod4root>/raw` folder, so they can be compiled in the 3rd part of the code.
REM To be more precise, 2nd PART OF THE CODE copies specified folders (ex: images, maps, materials, weapons...), goes to a directory located two levels above, and pastes them into `<cod4root>/raw` folder

REM For example, this command: `images ..\..\raw\images /SIY`
REM 1. Copies the folder `images` 
REM 2. Goes to a directory located two levels above (from `<cod4root>/mods/<mod_name>` to `<cod4root>`)
REM 3. Enters `raw/images` directory
REM 4. Pastes the contents of the `images` folder copied earlier in step 1.

REM Switches:
REM /I - destination is a directory
REM /S - copy directories and subdirectories, excluding empty ones
REM /E - copy directories and subdirectories, including empty ones
REM /Y - suppress prompting for confirmation before overwriting existing files

rem [!!! MODIFY IT !!!] if your mod has folders that are not specified below then add them by creating new lines of code (template: `xcopy <folder_name> ..\..\raw\<folder_name> /SIY`)
rem For example, if you have `fonts` folder in your mod folder, then add a line that looks like this `xcopy fonts ..\..\raw\fonts /SIY`

xcopy images ..\..\raw\images /SIY
xcopy maps ..\..\raw\maps /SIY
xcopy material_properties ..\..\raw\material_properties /SIY
xcopy materials ..\..\raw\materials /SIY
xcopy sound ..\..\raw\sound /SIY
xcopy soundaliases ..\..\raw\soundaliases /SIY
xcopy ui_mp ..\..\raw\ui_mp /SIY
xcopy weapons ..\..\raw\weapons /SIY
xcopy xanim ..\..\raw\xanim /SIY
xcopy xmodel ..\..\raw\xmodel /SIY
xcopy xmodelparts ..\..\raw\xmodelparts /SIY
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SIY



REM [3nd PART OF THE CODE] compiles mod.csv to mod.ff
REM mod.csv - uncompiled mod (it says what assets mod should use) 
REM mod.ff - compiled mod (ready to use mod)

REM copies `mod.csv`, goes to a directory located two levels above, and pastes it into `<cod4root>/zone_source` folder
copy /Y mod.csv ..\..\zone_source
REM enters `<cod4root>/bin` folder
cd ..\..\bin
REM opens `linker_pc.exe` that compiles `mod.csv` to mod.ff
linker_pc.exe -language english -compress -cleanup mod
REM [!!! MODIFY IT !!!] enters `mods/<mod_name>` folder
cd ..\mods\%mod_name%
REM copies compiled `mod.ff` into the `mods/<mod_name>` folder
copy ..\..\zone\english\mod.ff



REM [!!! MODIFY IT !!!] You must have `7za.exe` in your current folder or the 4th part of the code will not work.
REM If you don't have `7za.exe`, then simply copy it from `<cod4root>/mods/ModWarfare`.

REM [4th PART OF THE CODE] creates `z_<modname>.iwd` file (copies and pastes specified folders into `z_<modname>.iwd` file)
REM z_<modname>.iwd - container for assets, which could be anything: images (.iwi), sounds (.wav), scripts (.gsc), models etc.

7za a -r -tzip z_%mod_name%.iwd weapons
7za a -r -tzip z_%mod_name%.iwd images
7za a -r -tzip z_%mod_name%.iwd ui_mp
7za a -r -tzip z_%mod_name%.iwd maps
7za a -r -tzip z_%mod_name%.iwd scripts

REM [5th PART OF THE CODE] pauses the cmd.exe (prevents it from autoclosing, so you can check if the whole operation was completed without any errors)
REM If you have a lot of red texts. 

pause 

