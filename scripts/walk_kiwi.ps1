$fs = [System.IO.File]::OpenRead('NFT Market.fig')
$pos = 12

while ($pos -lt $fs.Length - 4) {
    $fs.Position = $pos
    $buf = New-Object byte[] 4
    $fs.Read($buf, 0, 4) | Out-Null
    $chunkLen = [System.BitConverter]::ToUInt32($buf, 0)
    Write-Output ("Chunk at offset 0x{0:X8} ({0}): length {1} bytes" -f $pos, $chunkLen)
    
    if ($chunkLen -eq 0 -or $chunkLen -gt 100000000) {
        Write-Output "Invalid chunk length, breaking."
        break
    }
    
    # Check first 8 bytes of payload:
    $payloadHeader = New-Object byte[] 16
    $fs.Read($payloadHeader, 0, 16) | Out-Null
    Write-Output ("  Payload preview: " + [System.BitConverter]::ToString($payloadHeader))
    
    # Try Deflate decompress or inspect
    $pos += 4 + $chunkLen
    if ($pos -ge $fs.Length) { break }
}
$fs.Close()
