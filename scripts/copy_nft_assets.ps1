$targetDir = 'assets/imgs/nft'
if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
}

$copyList = @('img_4.png', 'img_44.png', 'img_46.png', 'img_26.png', 'nft_market_preview.png')
foreach ($f in $copyList) {
    $src = Join-Path 'nft_assets' $f
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination (Join-Path $targetDir $f) -Force
        Write-Output "Copied $f to $targetDir"
    }
}
