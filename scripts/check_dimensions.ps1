Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile('nft_assets/img_1.png')
Write-Output "img_1.png: $($img.Width) x $($img.Height)"
$img.Dispose()
$img3 = [System.Drawing.Image]::FromFile('nft_assets/img_3.png')
Write-Output "img_3.png: $($img3.Width) x $($img3.Height)"
$img3.Dispose()
