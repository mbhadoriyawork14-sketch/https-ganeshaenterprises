$fs = [System.IO.File]::OpenRead('NFT Market.fig')
$fs.Position = 92326836 + 4 # skip the 4-byte length
$buf = New-Object byte[] 114155
$fs.Read($buf, 0, 114155) | Out-Null
$fs.Close()

[System.IO.File]::WriteAllBytes('nft_market_preview.png', $buf)
Write-Output "Extracted nft_market_preview.png (114155 bytes)"
