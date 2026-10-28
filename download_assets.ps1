[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$baseUrl = "https://ganeshaenterprises.in/"
$images = Get-Content "_raw_site/images_list.txt" -Encoding UTF8
$wc = New-Object Net.WebClient
$wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")

$success = 0
$fail = 0

foreach ($img in $images) {
    $img = $img.Trim()
    if (!$img) { continue }
    
    # Target local path
    $localPath = $img.Replace("/", "\")
    # Clean any invalid characters or duplicate slashes
    $dir = Split-Path -Parent $localPath
    if ($dir -and !(Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }

    # Encode URL properly
    $parts = $img.Split('/')
    $encodedParts = $parts | ForEach-Object { [System.Uri]::EscapeDataString($_) }
    $encodedPath = [string]::Join('/', $encodedParts)
    $url = $baseUrl + $encodedPath

    try {
        if (!(Test-Path $localPath)) {
            $wc.DownloadFile($url, $localPath)
            $success++
        } else {
            $success++
        }
    } catch {
        # Try without escaping just in case
        try {
            $wc.DownloadFile($baseUrl + $img, $localPath)
            $success++
        } catch {
            Write-Host "Failed to download $url : $($_.Exception.Message)"
            $fail++
        }
    }
}

Write-Host "Downloaded: $success, Failed: $fail"
