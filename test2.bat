@echo off
setlocal enabledelayedexpansion

:: === Setup paths ===
set "SCRIPT=%TEMP%\sam_ta_warning.ps1"

:: === Write PowerShell script ===
> "%SCRIPT%" echo $sh = New-Object -ComObject WScript.Shell
>> "%SCRIPT%" echo for ($i = 0; $i -lt 50; $i++) { $sh.SendKeys([char]175); Start-Sleep -Milliseconds 50 }

>> "%SCRIPT%" echo Add-Type -AssemblyName System.Speech
>> "%SCRIPT%" echo $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
>> "%SCRIPT%" echo $speak.Volume = 100
>> "%SCRIPT%" echo $speak.Rate = -2
>> "%SCRIPT%" echo $speak.Speak("a")

>> "%SCRIPT%" echo Add-Type -AssemblyName System.Windows.Forms
>> "%SCRIPT%" echo Add-Type -AssemblyName System.Drawing

>> "%SCRIPT%" echo # Create application context to keep forms alive
>> "%SCRIPT%" echo $applicationContext = New-Object System.Windows.Forms.ApplicationContext

>> "%SCRIPT%" echo $images = @('%~dp0sam.jpg','%~dp02game.png','%~dp0hello.jpg')
>> "%SCRIPT%" echo $forms = @()

>> "%SCRIPT%" echo # Function to create a new form
>> "%SCRIPT%" echo function Create-RandomForm {
>> "%SCRIPT%" echo     $rand = New-Object System.Random
>> "%SCRIPT%" echo     $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
>> "%SCRIPT%" echo     $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
>> "%SCRIPT%" echo     $x = $rand.Next(0, $screenWidth - 300)
>> "%SCRIPT%" echo     $y = $rand.Next(0, $screenHeight - 300)

>> "%SCRIPT%" echo     $form = New-Object Windows.Forms.Form
>> "%SCRIPT%" echo     $form.FormBorderStyle = 'None'
>> "%SCRIPT%" echo     $form.TopMost = $true
>> "%SCRIPT%" echo     $form.StartPosition = 'Manual'
>> "%SCRIPT%" echo     $form.Location = New-Object System.Drawing.Point($x, $y)
>> "%SCRIPT%" echo     $form.Size = New-Object System.Drawing.Size(300,300)

>> "%SCRIPT%" echo     $imgPath = $images[$rand.Next(0, $images.Count)]
>> "%SCRIPT%" echo     if (Test-Path $imgPath) {
>> "%SCRIPT%" echo         $pic = New-Object Windows.Forms.PictureBox
>> "%SCRIPT%" echo         $pic.Image = [System.Drawing.Image]::FromFile($imgPath)
>> "%SCRIPT%" echo         $pic.SizeMode = 'StretchImage'
>> "%SCRIPT%" echo         $pic.Dock = 'Fill'
>> "%SCRIPT%" echo         $form.Controls.Add($pic)
>> "%SCRIPT%" echo     }

>> "%SCRIPT%" echo     $form.Show()
>> "%SCRIPT%" echo     return $form
>> "%SCRIPT%" echo }

>> "%SCRIPT%" echo # Main timer to create new forms periodically
>> "%SCRIPT%" echo $mainTimer = New-Object Windows.Forms.Timer
>> "%SCRIPT%" echo $mainTimer.Interval = 100  # Create new form every 1 second
>> "%SCRIPT%" echo $mainTimer.Add_Tick({
>> "%SCRIPT%" echo     $newForm = Create-RandomForm
>> "%SCRIPT%" echo     $script:forms += $newForm
>> "%SCRIPT%" echo })
>> "%SCRIPT%" echo $mainTimer.Start()

>> "%SCRIPT%" echo # Create initial form
>> "%SCRIPT%" echo $forms += Create-RandomForm

>> "%SCRIPT%" echo # Keep application running
>> "%SCRIPT%" echo Write-Host "Press Ctrl+C to stop the program"
>> "%SCRIPT%" echo try {
>> "%SCRIPT%" echo     [System.Windows.Forms.Application]::Run()
>> "%SCRIPT%" echo } finally {
>> "%SCRIPT%" echo     foreach ($form in $forms) {
>> "%SCRIPT%" echo         if ($form -and !$form.IsDisposed) {
>> "%SCRIPT%" echo             $form.Close()
>> "%SCRIPT%" echo         }
>> "%SCRIPT%" echo     }
>> "%SCRIPT%" echo }

:: === Run PowerShell script ===
echo Starting the image display program...
echo Press Ctrl+C in the PowerShell window to stop
powershell -ExecutionPolicy Bypass -File "%SCRIPT%"

echo.
echo Program stopped. Press any key to exit.
pause >nul