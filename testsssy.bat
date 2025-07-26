@echo off
setlocal enabledelayedexpansion

:: === CONFIG ===
set "IMAGE_PATH=%~dp02game.png"
set "SPAM_DIR=%TEMP%\sam_spam"
set "MESSAGE=This student is playing Roblox during class."

:: === Max volume (PowerShell method) ===
echo Setting volume to MAX...
for ($i = 0; $i -lt 50; $i++) {
    (New-Object -ComObject WScript.Shell).SendKeys([char]175)
    Start-Sleep -Milliseconds 50
}

:: === Speak message aloud ===
echo Yelling at student...
powershell -Command "Add-Type –AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.Volume = 100; $speak.Rate = -2; $speak.Speak('%MESSAGE%');"

:: === Open image fullscreen (using Windows Photo Viewer hack) ===
echo Showing Sam’s face of despair...
start "" "%IMAGE_PATH%"

:: === Simulate image spam ===
echo Creating fake spam images...
mkdir "%SPAM_DIR%" >nul 2>&1

for /L %%i in (1,1,10) do (
    set /A SIZE=%%i * 100
    powershell -Command "$bmp = New-Object Drawing.Bitmap(!SIZE!,!SIZE!); $bmp.Save('%SPAM_DIR%\sam_%%i.bmp'); $bmp.Dispose()"
    timeout /t 1 >nul
)

:: === (Optional) Run self again for dramatic effect ===
:: echo Re-running script for more chaos...
:: call "%~f0" || call "%~f0"

echo Done. Press any key to exit.
pause >nul
