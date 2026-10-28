Add-Type -AssemblyName System.Web
$blogPages = @("blog_grid.html", "blog_1.html", "blog_2.html")
foreach ($bp in $blogPages) {
    $p = "_raw_site/pages/$bp"
    if (Test-Path $p) {
        $content = Get-Content $p -Raw -Encoding UTF8
        Write-Host "=== BLOG FILE: $bp ==="
        $title = [regex]::Match($content, '(?s)<title>(.*?)</title>').Groups[1].Value.Trim()
        Write-Host "Title: $title"
        
        $headings = [regex]::Matches($content, '(?s)<(h[1-4])[^>]*>(.*?)</\1>') | ForEach-Object {
            $tag = $_.Groups[1].Value
            $t = [regex]::Replace($_.Groups[2].Value, '<[^>]+>', '').Trim()
            $t = [System.Web.HttpUtility]::HtmlDecode($t) -replace '\s+', ' '
            if ($t -and $t -notmatch 'Business Essentials|Love Your New Look|Made by You|Home & Gifts|Looking for More|Subscribe|Quick Links') {
                "$($tag): $t"
            }
        }
        Write-Host "Headings: " ($headings -join " | ")
        Write-Host ""
    }
}
