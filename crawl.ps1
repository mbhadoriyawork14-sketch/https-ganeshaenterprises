[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$baseUrl = "https://ganeshaenterprises.in/"
$visited = New-Object System.Collections.Generic.HashSet[string]
$queue = New-Object System.Collections.Generic.Queue[string]
$allImages = New-Object System.Collections.Generic.HashSet[string]
$allLinks = New-Object System.Collections.Generic.HashSet[string]

New-Item -ItemType Directory -Force -Path "_raw_site" | Out-Null
New-Item -ItemType Directory -Force -Path "_raw_site/pages" | Out-Null

$initialPages = @(
    "index.html",
    "about_us.html",
    "service.html",
    "service_Corporate_Office_Printing.html",
    "service_Large_Format_&_Event_Printing.html",
    "service_Marketing_&_Promotional_Printing.html",
    "service-details.html",
    "portfolio.html",
    "portfolio-details.html",
    "shop.html",
    "shop _Business_Essentials.html",
    "shop _Love_Your_New_Look.html",
    "shop_Made_by_You.html",
    "shop_Home_&_Gifts.html",
    "blog_grid.html",
    "blog_2.html",
    "blog-details.html",
    "contact.html",
    "privacy-policy.html",
    "terms-and-conditions.html",
    "faq.html"
)

foreach ($p in $initialPages) {
    $queue.Enqueue($p)
}

$wc = New-Object Net.WebClient
$wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")

while ($queue.Count -gt 0) {
    $page = $queue.Dequeue()
    $encodedPage = [System.Uri]::EscapeUriString($page)
    if ($visited.Contains($page)) { continue }
    $visited.Add($page) | Out-Null

    $url = $baseUrl + $encodedPage
    Write-Host "Fetching: $url"
    try {
        $html = $wc.DownloadString($url)
        $safeName = $page -replace '[\\/:*?"<>|]', '_'
        Set-Content -Path "_raw_site/pages/$safeName" -Value $html -Encoding UTF8

        # Extract images
        $imgMatches = [regex]::Matches($html, '<img[^>]+src\s*=\s*["'']([^"'']+)["'']', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        foreach ($m in $imgMatches) {
            $src = $m.Groups[1].Value.Trim()
            if ($src -and !$src.StartsWith("data:")) {
                $allImages.Add($src) | Out-Null
            }
        }

        # Extract links
        $linkMatches = [regex]::Matches($html, 'href\s*=\s*["'']([^"'']+)["'']', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        foreach ($m in $linkMatches) {
            $href = $m.Groups[1].Value.Trim()
            $allLinks.Add($href) | Out-Null
            if ($href.EndsWith(".html") -or $href.Contains(".html?")) {
                $cleanHref = $href.Split('?')[0].Split('#')[0]
                if (!$cleanHref.StartsWith("http") -and !$visited.Contains($cleanHref)) {
                    $queue.Enqueue($cleanHref)
                }
            }
        }
    } catch {
        Write-Host "Failed to fetch $url : $($_.Exception.Message)"
    }
}

$allImages | Out-File -FilePath "_raw_site/images_list.txt" -Encoding UTF8
$allLinks | Out-File -FilePath "_raw_site/links_list.txt" -Encoding UTF8
Write-Host "Total pages visited: $($visited.Count)"
Write-Host "Total images found: $($allImages.Count)"
Write-Host "Total links found: $($allLinks.Count)"
