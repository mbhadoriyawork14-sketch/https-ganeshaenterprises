Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('Instrument Design Studio Portfolio Template - (Get My FIgma Files Patreon).fig')
$names = @('2a46c0267455aa7bc70d265af1d17d4b887d69ea', '7f85e27c42040cbc9463c858c21dcd0d8c68487d')
foreach ($name in $names) {
    $entry = $zip.GetEntry("images/$name")
    if ($entry) {
        $target = "figma_assets/$name.png"
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $target, $true)
        Write-Output "Extracted $target"
    }
}
$zip.Dispose()
