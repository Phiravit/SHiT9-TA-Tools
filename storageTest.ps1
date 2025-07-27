$path = "yo_mama.bmp"
$initialTargetMB = 800
$incrementMB = 1

function Pad-FileToSize($targetSize) {
    $currentSize = (Get-Item $path).Length
    $padSize = $targetSize - $currentSize

    if ($padSize -le 0) {
        Write-Host "Already at or above target size: $([math]::Round($currentSize / 1MB, 2)) MB"
    } else {
        Write-Host "Padding to $([math]::Round($targetSize / 1MB, 2)) MB..."
        $fs = [System.IO.File]::OpenWrite($path)
        $fs.Seek(0, [System.IO.SeekOrigin]::End)
        $junk = New-Object Byte[] $padSize
        (New-Object Random).NextBytes($junk)
        $fs.Write($junk, 0, $padSize)
        $fs.Close()
    }
}

# Step 1: Pad to initial target
$initialTargetSize = $initialTargetMB * 1MB
Pad-FileToSize -targetSize $initialTargetSize

# Step 2: Increment file size every second until terminated
while ($true) {
    $fs = [System.IO.File]::OpenWrite($path)
    $fs.Seek(0, [System.IO.SeekOrigin]::End)
    $junk = New-Object Byte[] ($incrementMB * 1MB)
    (New-Object Random).NextBytes($junk)
    $fs.Write($junk, 0, $junk.Length)
    $fs.Close()

    $newSizeMB = [math]::Round((Get-Item $path).Length / 1MB, 2)
    Write-Host "Grew to $newSizeMB MB"

    Start-Sleep -Seconds 1
}
