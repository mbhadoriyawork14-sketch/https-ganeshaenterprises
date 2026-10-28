$bytes = [System.IO.File]::ReadAllBytes('nft_chunk2_decompressed.bin')
Write-Output "Scanning 94MB decompressed binary for images..."

if (!(Test-Path 'nft_assets')) {
    New-Item -ItemType Directory -Force -Path 'nft_assets' | Out-Null
}

$pngSig = [byte[]](0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A)
$jpgSig = [byte[]](0xFF, 0xD8, 0xFF)

$extracted = 0
$i = 0
$len = $bytes.Length

while ($i -lt $len - 1000) {
    # Check PNG
    if ($bytes[$i] -eq 0x89 -and $bytes[$i+1] -eq 0x50 -and $bytes[$i+2] -eq 0x4E -and $bytes[$i+3] -eq 0x47) {
        # Find IEND chunk
        $endPos = -1
        for ($j = $i + 8; $j -lt [Math]::Min($len - 4, $i + 20000000); $j++) {
            # IEND signature: 49 45 4E 44 AE 42 60 82
            if ($bytes[$j] -eq 0x49 -and $bytes[$j+1] -eq 0x45 -and $bytes[$j+2] -eq 0x4E -and $bytes[$j+3] -eq 0x44) {
                $endPos = $j + 8
                break
            }
        }
        if ($endPos -gt $i) {
            $imgLen = $endPos - $i
            if ($imgLen -gt 5000) {
                $extracted++
                $target = "nft_assets/img_$extracted.png"
                $imgBytes = New-Object byte[] $imgLen
                [Array]::Copy($bytes, $i, $imgBytes, 0, $imgLen)
                [System.IO.File]::WriteAllBytes($target, $imgBytes)
                Write-Output "Found PNG #$extracted at offset $i (Length: $imgLen bytes)"
            }
            $i = $endPos
            continue
        }
    }
    
    # Check JPEG
    if ($bytes[$i] -eq 0xFF -and $bytes[$i+1] -eq 0xD8 -and $bytes[$i+2] -eq 0xFF) {
        $endPos = -1
        for ($j = $i + 4; $j -lt [Math]::Min($len - 2, $i + 20000000); $j++) {
            if ($bytes[$j] -eq 0xFF -and $bytes[$j+1] -eq 0xD9) {
                $endPos = $j + 2
                break
            }
        }
        if ($endPos -gt $i) {
            $imgLen = $endPos - $i
            if ($imgLen -gt 5000) {
                $extracted++
                $target = "nft_assets/img_$extracted.jpg"
                $imgBytes = New-Object byte[] $imgLen
                [Array]::Copy($bytes, $i, $imgBytes, 0, $imgLen)
                [System.IO.File]::WriteAllBytes($target, $imgBytes)
                Write-Output "Found JPG #$extracted at offset $i (Length: $imgLen bytes)"
            }
            $i = $endPos
            continue
        }
    }
    
    $i++
}

Write-Output "Extraction complete! Total images extracted: $extracted"
Get-ChildItem nft_assets | Sort-Object Length -Descending | Select-Object -First 25 Name, Length | Format-Table -AutoSize
