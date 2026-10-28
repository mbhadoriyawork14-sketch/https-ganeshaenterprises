Add-Type -AssemblyName System.Drawing
$files = Get-ChildItem nft_assets | Where-Object { $_.Length -gt 100000 } | Sort-Object Length -Descending
foreach ($f in $files | Select-Object -First 30) {
    try {
        $img = [System.Drawing.Image]::FromFile($f.FullName)
        Write-Output ("{0,-15}: {1,6} KB  {2,5}x{3,5}" -f $f.Name, [math]::Round($f.Length/1024), $img.Width, $img.Height)
        $img.Dispose()
    } catch {}
}
