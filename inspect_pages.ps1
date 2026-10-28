Add-Type -AssemblyName System.Web
$files = @("index.html", "about_us.html", "contact.html", "service.html", "portfolio.html")
foreach ($f in $files) {
    $p = "_raw_site/pages/$f"
    if (Test-Path $p) {
        $content = Get-Content $p -Raw -Encoding UTF8
        Write-Host "=== FILE: $f ==="
        $title = [regex]::Match($content, '(?s)<title>(.*?)</title>').Groups[1].Value.Trim()
        $desc = [regex]::Match($content, '(?s)<meta name="description" content="(.*?)">').Groups[1].Value.Trim()
        Write-Host "Title: $title"
        Write-Host "Description: $desc"
        
        $headings = [regex]::Matches($content, '(?s)<(h[1-6])[^>]*>(.*?)</\1>') | ForEach-Object {
            $tag = $_.Groups[1].Value
            $text = [regex]::Replace($_.Groups[2].Value, '<[^>]+>', '').Trim()
            $text = [System.Web.HttpUtility]::HtmlDecode($text) -replace '\s+', ' '
            if ($text) { "$($tag): $text" }
        }
        Write-Host "Headings: " ($headings -join " || ")
        Write-Host ""
    }
}
