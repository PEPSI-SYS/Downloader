@echo off
setlocal
title Downloader ^| V9.2
chcp 65001 >nul
color 0A
mode con: cols=90 lines=25 >nul

rem Links are XOR-obfuscated for casual concealment, not kept secret.
set "LINK_ASTRACS2=K0MaIUFAYxYXO11eJF4aOUcYYloZJhsCJkcBIh0qCWklAhkjGmRBEEEOPlhbCEdCbE0HIVAbIFU="
set "LINK_ASTRAR6S=K0MaIUFAYxYRIkAYNlVAMl0XY2kzG2c5bmQ3Ah07P00EKmZGMBgaI1cfY1QXIlo="
set "LINK_FROZENFORT=K0MaIUFAYxYRIkAYNlVAMl0XY2kzG2c5bmQ3Ah08PlYMLlo2LEUafkYIKVxZJlUZLQ=="
set "LINK_ASTRO_FIVEM=K0MaIUFAYxYRIkAYNlVAMl0XY2kzG2c5bmQ3Ah07P00EJHIZNVIjfkYIKVxZJlUZLQ=="
set "LINK_REXRBLX=K0MaIUFAYxYRIkAYNlVAMl0XY2kzG2c5bmQ3Ah0oKUEkKVgIbFYcMloTOlxZOVEWMBgGNFMePxYbKl0ebU0HIQ=="
set "MOVE_SOURCE=%~f0"
set "SETTINGS_FILE=%LOCALAPPDATA%\Downloader\location.txt"

if /I "%~1"=="--ready" goto :start_menu

powershell -NoProfile -Command "$id=[Security.Principal.WindowsIdentity]::GetCurrent(); $p=New-Object Security.Principal.WindowsPrincipal($id); if($p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){exit 0}else{exit 1}"
if errorlevel 1 goto :request_admin
goto :check_location

:request_admin
echo Requesting Administrator permissions...
powershell -NoProfile -Command "try { Start-Process -FilePath $env:ComSpec -ArgumentList ('/c ""' + $env:MOVE_SOURCE + '"" --elevated') -Verb RunAs -ErrorAction Stop; exit 0 } catch { Write-Host ('Administrator permission was not granted: ' + $_); exit 1 }"
if errorlevel 1 (
    echo Could not restart with Administrator permissions.
    pause
)
exit /b

:check_location
if not exist "%SETTINGS_FILE%" goto :setup_folder
set "SAVED_FOLDER="
set /p "SAVED_FOLDER="<"%SETTINGS_FILE%"
if not defined SAVED_FOLDER goto :setup_folder
for %%I in ("%~dp0.") do set "CURRENT_FOLDER=%%~fI"
if /I "%CURRENT_FOLDER%"=="%SAVED_FOLDER%" goto :start_menu
goto :setup_folder

:setup_folder
echo.
set "FOLDER_NAME="
set /p "FOLDER_NAME=Enter a folder name: "
if not defined FOLDER_NAME exit /b 1
powershell -NoProfile -NonInteractive -Command "$n=$env:FOLDER_NAME; if ([string]::IsNullOrWhiteSpace($n) -or $n -eq '.' -or $n -eq '..' -or $n -match '[\\/:*?<>|]' -or $n.Contains([char]34) -or $n -match '[. ]$') { exit 1 }"
if errorlevel 1 (
    echo.
    echo Enter a valid folder name without path or reserved characters.
    timeout /t 2 >nul
    goto :setup_folder
)

set "MOVE_DEST=%USERPROFILE%\Desktop"
call :try_move
if not errorlevel 1 exit /b 0

if defined OneDrive (
    set "MOVE_DEST=%OneDrive%\Desktop"
    call :try_move
    if not errorlevel 1 exit /b 0
)

echo Could not create the folder or move the file to Desktop.
start "" "https://discord.gg/JMVXrBTm6f"
pause
exit /b 1

:try_move
if not exist "%MOVE_DEST%\" exit /b 1
set "TARGET_FOLDER=%MOVE_DEST%\%FOLDER_NAME%"
for %%I in ("%TARGET_FOLDER%") do set "TARGET_FOLDER=%%~fI"
set "TARGET_FILE=%TARGET_FOLDER%\%~nx0"
for %%I in ("%~dp0.") do set "CURRENT_FOLDER=%%~fI"
if /I "%CURRENT_FOLDER%"=="%TARGET_FOLDER%" (
    call :save_location
    if errorlevel 1 exit /b 1
    start "" explorer.exe "%TARGET_FOLDER%"
    exit /b 0
)
if exist "%TARGET_FILE%" exit /b 1
md "%TARGET_FOLDER%" >nul 2>&1
if not exist "%TARGET_FOLDER%\" exit /b 1
copy "%MOVE_SOURCE%" "%TARGET_FILE%" >nul
if errorlevel 1 exit /b 1
call :save_location
if errorlevel 1 (
    echo.
    echo Could not save the local folder setting.
    pause
    exit /b 1
)
start "" explorer.exe "%TARGET_FOLDER%"
start "" "%TARGET_FILE%" --ready
del "%MOVE_SOURCE%" >nul 2>&1
exit /b 0

:save_location
powershell -NoProfile -NonInteractive -Command "$ErrorActionPreference='Stop'; try { [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($env:SETTINGS_FILE)) | Out-Null; [IO.File]::WriteAllText($env:SETTINGS_FILE, $env:TARGET_FOLDER); exit 0 } catch { Write-Error $_; exit 1 }"
if errorlevel 1 exit /b 1
exit /b 0

:start_menu
cls
color 0B
echo.
echo  ============================================================
echo                     DOWNLOADER  V9.2
echo  ============================================================
color 0A
echo.
echo  [1] Download
echo  [2] Exit
echo.
set "ACTION="
set /p "ACTION=Choose an option ^> "
if not defined ACTION exit /b 0
if "%ACTION%"=="1" goto :download_menu
if /I "%ACTION%"=="D" goto :download_menu
if "%ACTION%"=="2" exit /b 0
if /I "%ACTION%"=="Q" exit /b 0
echo.
echo  Invalid option.
timeout /t 2 >nul
goto :start_menu

:download_menu
cls
color 0B
echo.
echo  ============================================================
echo                     CHOOSE A DOWNLOAD
echo  ============================================================
color 0A
echo.
echo  [1] AstraCs2
echo  [2] AstraR6s
echo  [3] forzen-fort
echo  [4] astro-FiveM
echo  [5] RexRblx   << in beta testing [NO KEY NEEDED!!]
echo  [6] Back
echo.
set "SELECTION="
set /p "SELECTION=Pick what to download ^> "
if not defined SELECTION exit /b 0
if "%SELECTION%"=="6" goto :start_menu
if "%SELECTION%"=="1" (
    set "LINK_DATA=%LINK_ASTRACS2%"
    set "DOWNLOAD_LABEL=AstraCs2"
    goto :download
)
if "%SELECTION%"=="2" (
    set "LINK_DATA=%LINK_ASTRAR6S%"
    set "DOWNLOAD_LABEL=AstraR6s"
    goto :download
)
if "%SELECTION%"=="3" (
    set "LINK_DATA=%LINK_FROZENFORT%"
    set "DOWNLOAD_LABEL=forzen-fort"
    goto :download
)
if "%SELECTION%"=="4" (
    set "LINK_DATA=%LINK_ASTRO_FIVEM%"
    set "DOWNLOAD_LABEL=astro-FiveM"
    goto :download
)
if "%SELECTION%"=="5" (
    set "LINK_DATA=%LINK_REXRBLX%"
    set "DOWNLOAD_LABEL=RexRblx"
    goto :download
)
echo.
echo  Invalid selection.
timeout /t 2 >nul
goto :download_menu

:download
if not defined LINK_DATA (
    echo.
    echo  No GitHub repository is configured for %DOWNLOAD_LABEL%.
    echo  Add its obfuscated link near the top of this file.
    pause
    goto :download_menu
)
set "DOWNLOAD_URL="
for /f "usebackq delims=" %%U in (`powershell.exe -NoProfile -NonInteractive -Command "$k=[Text.Encoding]::UTF8.GetBytes('C7nQ2zL9vK4p');$b=[Convert]::FromBase64String($env:LINK_DATA);$j=0;for($i=0;$i -lt $b.Length;$i++){$b[$i]=$b[$i] -bxor $k[$j];$j++;if($j -ge $k.Length){$j=0}};[Text.Encoding]::UTF8.GetString($b)" 2^>nul`) do set "DOWNLOAD_URL=%%U"
if not defined DOWNLOAD_URL (
    echo.
    echo  Could not decode the download link.
    pause
    goto :download_menu
)
where curl.exe >nul 2>&1
if errorlevel 1 (
    echo.
    echo  curl.exe was not found. Install a Windows version that includes curl.
    pause
    goto :download_menu
)
where tar.exe >nul 2>&1
if errorlevel 1 (
    echo.
    echo  tar.exe was not found. Install a Windows version that includes tar.
    pause
    goto :download_menu
)
set "DOWNLOAD_DIR=%~dp0downloads"
set "TARGET_DIR=%DOWNLOAD_DIR%\%DOWNLOAD_LABEL%"
set "ARCHIVE=%TEMP%\%DOWNLOAD_LABEL%-repository.zip"
if not exist "%TARGET_DIR%\" md "%TARGET_DIR%"
if not exist "%TARGET_DIR%\" (
    echo.
    echo  Could not create "%TARGET_DIR%".
    pause
    goto :download_menu
)
echo.
echo  Downloading the %DOWNLOAD_LABEL% GitHub repository...
curl.exe --fail --location --show-error --output "%ARCHIVE%" "%DOWNLOAD_URL%"
set "DOWNLOAD_RESULT=%ERRORLEVEL%"
if not "%DOWNLOAD_RESULT%"=="0" (
    echo.
    echo  GitHub download failed.
    if exist "%ARCHIVE%" del "%ARCHIVE%" >nul 2>&1
    pause
    goto :download_menu
)
tar.exe -xf "%ARCHIVE%" -C "%TARGET_DIR%" --strip-components=1
set "DOWNLOAD_RESULT=%ERRORLEVEL%"
del "%ARCHIVE%" >nul 2>&1
if not "%DOWNLOAD_RESULT%"=="0" (
    echo.
    echo  Could not extract the repository archive.
    pause
    goto :download_menu
)
echo.
echo  Repository files saved in:
echo  "%TARGET_DIR%"
pause
goto :download_menu
