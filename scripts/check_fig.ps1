$item = Get-Item 'NFT Market.fig'
Write-Output "Size: $($item.Length)"
$fs = [System.IO.File]::OpenRead('NFT Market.fig')
$buf = New-Object byte[] 64
$bytesRead = $fs.Read($buf, 0, 64)
$fs.Close()
Write-Output "First 64 bytes as hex:"
Write-Output ([System.BitConverter]::ToString($buf))
Write-Output "First 64 bytes as ASCII:"
Write-Output ([System.Text.Encoding]::ASCII.GetString($buf))
