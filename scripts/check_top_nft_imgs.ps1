Add-Type -AssemblyName System.Drawing
$names = @('img_91.png', 'img_5.png', 'img_3.png', 'img_89.png', 'img_1.png', 'img_46.png', 'img_44.png', 'img_50.png')
foreach ($n in $names) {
    $path = Join-Path 'nft_assets' $n
    if (Test-Path $path) {
        $img = [System.Drawing.Image]::FromFile($path)
        Write-Output ("{0,-15}: {1} x {2}" -f $n, $img.Width, $img.Height)
        $img.Dispose()
    }
}
