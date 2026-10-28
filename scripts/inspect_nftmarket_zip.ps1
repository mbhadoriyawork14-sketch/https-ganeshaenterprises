Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('C:\Users\digi2\Downloads\NFTMarket.zip')
$entries = $zip.Entries | Select-Object -First 50 Name, Length, FullName
$entries | Format-Table -AutoSize
Write-Output "Total entries: $($zip.Entries.Count)"
$zip.Dispose()
