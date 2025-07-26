$path = "yo_mama.bmp"
$targetMB = 0.6
$targetSize = $targetMB * 1MB

$currentSize = (Get-Item $path).Length
$padSize = $targetSize - $currentSize

if ($padSize -le 0) {
    Write-Host "yo_mama.bmp is already $([math]::Round($currentSize / 1MB, 2)) MB or larger."
} else {
    Write-Host "Padding yo_mama.bmp by $([math]::Round($padSize / 1MB, 2)) MB..."
    $fs = [System.IO.File]::OpenWrite($path)
    $fs.Seek(0, [System.IO.SeekOrigin]::End)
    $junk = New-Object Byte[] $padSize
    (New-Object Random).NextBytes($junk)
    $fs.Write($junk, 0, $padSize)
    $fs.Close()

    $newSize = (Get-Item $path).Length
    Write-Host "Done. New size: $([math]::Round($newSize / 1MB, 2)) MB"
}
