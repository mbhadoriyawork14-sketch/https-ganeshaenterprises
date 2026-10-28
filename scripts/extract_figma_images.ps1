Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('Instrument Design Studio Portfolio Template - (Get My FIgma Files Patreon).fig')
if (!(Test-Path 'figma_assets')) {
    New-Item -ItemType Directory -Force -Path 'figma_assets' | Out-Null
}

$i = 0
foreach ($entry in $zip.Entries) {
    if ($entry.FullName.StartsWith('images/') -and $entry.Length -gt 100000) {
        $target = Join-Path 'figma_assets' ($entry.Name + '.png')
        if (!(Test-Path $target)) {
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $target, $true)
        }
        $i++
        if ($i -ge 6) { break }
    }
}
$zip.Dispose()
Write-Output "Extracted $i images to figma_assets/"
Get-ChildItem figma_assets | Select-Object Name, Length | Format-Table
