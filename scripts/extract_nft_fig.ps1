Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('C:\Users\digi2\Downloads\NFTMarket.zip')
$entry = $zip.GetEntry('NFT Market.fig')
if ($entry) {
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, 'NFT Market.fig', $true)
    Write-Output "Successfully extracted 'NFT Market.fig' ($( (Get-Item 'NFT Market.fig').Length ) bytes)"
} else {
    Write-Output "NFT Market.fig not found in zip"
}
$zip.Dispose()
