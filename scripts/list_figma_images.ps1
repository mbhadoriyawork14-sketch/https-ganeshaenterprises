Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('Instrument Design Studio Portfolio Template - (Get My FIgma Files Patreon).fig')
$entries = $zip.Entries | Where-Object { $_.FullName.StartsWith('images/') } | Sort-Object Length -Descending | Select-Object -First 20 Name, Length
$entries | Format-Table -AutoSize
$zip.Dispose()
