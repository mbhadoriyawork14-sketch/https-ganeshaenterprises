Add-Type -AssemblyName System.IO.Compression

$fs = [System.IO.File]::OpenRead('NFT Market.fig')
$fs.Position = 9862 + 4 # chunk 2 length was at 9862, payload starts at 9866
$chunk2Len = 92316970

Write-Output "Attempting to stream-decompress Chunk 2 (raw Deflate)..."

try {
    $deflate = New-Object System.IO.Compression.DeflateStream($fs, [System.IO.Compression.CompressionMode]::Decompress)
    $outPath = 'nft_chunk2_decompressed.bin'
    $outFs = [System.IO.File]::Create($outPath)
    
    $buffer = New-Object byte[] (1024 * 1024)
    $totalRead = 0
    $lastReport = 0
    
    while ($true) {
        $read = $deflate.Read($buffer, 0, $buffer.Length)
        if ($read -le 0) { break }
        $outFs.Write($buffer, 0, $read)
        $totalRead += $read
        if ($totalRead - $lastReport -ge 20000000) {
            Write-Output "Decompressed: $([math]::Round($totalRead / 1MB, 2)) MB..."
            $lastReport = $totalRead
        }
    }
    
    $outFs.Close()
    $deflate.Close()
    Write-Output "Success! Total decompressed size: $( (Get-Item $outPath).Length ) bytes"
} catch {
    Write-Output "Deflate error: $_"
} finally {
    $fs.Close()
}
