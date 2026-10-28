Add-Type -AssemblyName System.Web
$servicePages = Get-ChildItem "_raw_site/pages" -Filter "service_*.html"
foreach ($sp in $servicePages) {
    $content = Get-Content $sp.FullName -Raw -Encoding UTF8
    $title = [regex]::Match($content, '(?s)<title>(.*?)</title>').Groups[1].Value.Trim()
    $desc = [regex]::Match($content, '(?s)<meta name="description" content="(.*?)">').Groups[1].Value.Trim()
    Write-Host "=== SERVICE: $($sp.Name) ==="
    Write-Host "Title: $title"
    Write-Host "Desc: $desc"
    
    # Extract main content area (usually between header and footer or inside service details class)
    # Let's find h1, h2, h3, h4, and paragraphs
    $headings = [regex]::Matches($content, '(?s)<(h[1-4])[^>]*>(.*?)</\1>') | ForEach-Object {
        $tag = $_.Groups[1].Value
        $t = [regex]::Replace($_.Groups[2].Value, '<[^>]+>', '').Trim()
        $t = [System.Web.HttpUtility]::HtmlDecode($t) -replace '\s+', ' '
        if ($t -and $t -notmatch 'Business Essentials|Love Your New Look|Made by You|Home & Gifts|Looking for More|Subscribe|Quick Links') {
            "$($tag): $t"
        }
    }
    Write-Host "Headings: " ($headings -join " | ")

    # Extract paragraphs
    $paras = [regex]::Matches($content, '(?s)<p[^>]*>(.*?)</p>') | ForEach-Object {
        $t = [regex]::Replace($_.Groups[1].Value, '<[^>]+>', '').Trim()
        $t = [System.Web.HttpUtility]::HtmlDecode($t) -replace '\s+', ' '
        if ($t.Length -gt 40 -and $t -notmatch 'browserupgrade|All rights reserved|Discover premium') {
            $t
        }
    }
    Write-Host "Paragraphs count: $($paras.Count)"
    if ($paras.Count -gt 0) {
        Write-Host "P1: $($paras[0])"
    }
    Write-Host ""
}
