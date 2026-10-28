$fs = [System.IO.File]::OpenRead('NFT Market.fig')
$len = $fs.Length

Write-Output "Scanning 'NFT Market.fig' ($len bytes) for PNG and JPEG images..."

$pngSig = [byte[]](0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A)
$jpgSig = [byte[]](0xFF, 0xD8, 0xFF)

if (!(Test-Path 'nft_assets')) {
    New-Item -ItemType Directory -Force -Path 'nft_assets' | Out-Null
}

$chunkSize = 4096 * 1024
$buffer = New-Object byte[] ($chunkSize + 16)
$pos = 0
$imgIndex = 0

# We can find PNGs and JPEGs or decompress zlib chunks
# Let's inspect the first 16 bytes:
# fig-kiwi: 8 bytes
# uint32: 4 bytes
# uint32: 4 bytes
$fs.Position = 0
$header = New-Object byte[] 16
$fs.Read($header, 0, 16) | Out-Null

Write-Output "fig-kiwi version: $([System.BitConverter]::ToUInt32($header, 8))"

# Check if the rest of the stream is zlib / deflate:
$fs.Position = 12
try {
    # In fig-kiwi, offset 12 is often zlib or raw deflate
    # Let's check byte at 12 and 13: 78 9C or 78 01 or 78 DA is standard zlib header!
    # In our hex dump above: bytes 16.. is B5 7C 69 9C...
    # Let's check byte 12..15: 76 26 00 00
} catch {}

$fs.Close()
