$fs = [System.IO.File]::OpenRead('NFT Market.fig')
$buf = New-Object byte[] 128
$fs.Read($buf, 0, 128) | Out-Null
$fs.Close()

for ($i = 0; $i -lt 128; $i += 16) {
    $hex = [System.BitConverter]::ToString($buf, $i, [Math]::Min(16, 128 - $i))
    $ascii = ""
    for ($j = $i; $j -lt [Math]::Min($i + 16, 128); $j++) {
        $c = [char]$buf[$j]
        if ([char]::IsControl($c)) { $ascii += "." } else { $ascii += $c }
    }
    Write-Output ("{0:X4}: {1,-48} {2}" -f $i, $hex, $ascii)
}
