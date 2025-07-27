# Get the path to the current user's Downloads folder and combine it with the filename
$downloadsPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Downloads)
$path = Join-Path -Path $downloadsPath -ChildPath "yo_mama.bmp"

# Check if the file exists before running the script
if (-not (Test-Path -Path $path)) {
    Write-Host "Error: File not found at '$path'. Please make sure 'yo_mama.bmp' is in your Downloads folder."
    # Stop the script if the file doesn't exist
    return
}

$initialTargetMB = 800
$incrementMB = 1

function Pad-FileToSize($targetSize) {
    $currentSize = (Get-Item $path).Length
    $padSize = $targetSize - $currentSize

    if ($padSize -le 0) {
        Write-Host "File is already at or above the target size: $([math]::Round($currentSize / 1MB, 2)) MB"
    } else {
        Write-Host "Padding file to $([math]::Round($targetSize / 1MB, 2)) MB..."
        $fs = [System.IO.File]::OpenWrite($path)
        $fs.Seek(0, [System.IO.SeekOrigin]::End)
        $junk = New-Object Byte[] $padSize
        (New-Object Random).NextBytes($junk)
        $fs.Write($junk, 0, $padSize)
        $fs.Close()
    }
}

# Step 1: Pad to the initial target size
$initialTargetSize = $initialTargetMB * 1MB
Pad-FileToSize -targetSize $initialTargetSize

# Step 2: Increment the file size every second until the script is manually stopped
while ($true) {
    # Open the file in write mode
    $fs = [System.IO.File]::OpenWrite($path)
    # Seek to the end of the file
    $fs.Seek(0, [System.IO.SeekOrigin]::End)
    # Create a byte array for the increment
    $junk = New-Object Byte[] ($incrementMB * 1MB)
    (New-Object Random).NextBytes($junk)
    # Write the random bytes to the end of the file
    $fs.Write($junk, 0, $junk.Length)
    $fs.Close()

    # Get the new size and display it
    $newSizeMB = [math]::Round((Get-Item $path).Length / 1MB, 2)
    Write-Host "File grew to $newSizeMB MB"

    # Wait for 1 second
    Start-Sleep -Seconds 1
}
