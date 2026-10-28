Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('NFT Market.fig')
Write-Output "Total entries in NFT Market.fig: $($zip.Entries.Count)"

$thumb = $zip.GetEntry('thumbnail.png')
if ($thumb) {
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($thumb, 'nft_thumbnail.png', $true)
    Write-Output "Extracted nft_thumbnail.png ($( (Get-Item 'nft_thumbnail.png').Length ) bytes)"
}

$meta = $zip.GetEntry('meta.json')
if ($meta) {
    $stream = $meta.Open()
    $reader = New-Object System.IO.StreamReader($stream)
    $metaContent = $reader.ReadToEnd()
    $reader.Dispose()
    Write-Output "Meta.json:"
    Write-Output $metaContent
}

$zip.Dispose()
