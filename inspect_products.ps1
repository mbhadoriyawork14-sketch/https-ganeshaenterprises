Add-Type -AssemblyName System.Web
$shopFiles = @("shop.html", "shop _Business_Essentials.html", "shop _Love_Your_New_Look.html", "shop_Made_by_You.html", "shop_Home_&_Gifts.html")

foreach ($sf in $shopFiles) {
    $p = "_raw_site/pages/$sf"
    if (Test-Path $p) {
        $content = Get-Content $p -Raw -Encoding UTF8
        Write-Host "=== SHOP FILE: $sf ==="
        $title = [regex]::Match($content, '(?s)<title>(.*?)</title>').Groups[1].Value.Trim()
        Write-Host "Title: $title"
        
        # Match product card items (e.g. class containing product or item or shop__item)
        # Let's find h4 or h5 or titles inside shop items
        $prodMatches = [regex]::Matches($content, '(?s)<h[45][^>]*class="[^"]*(?:product|title)[^"]*"[^>]*>(.*?)</h[45]>')
        if ($prodMatches.Count -eq 0) {
            # Let's inspect general structure
            $prodMatches = [regex]::Matches($content, '(?s)<div class="shop-item[^"]*"[^>]*>(.*?)</div>\s*</div>')
        }
        Write-Host "Found product card matches: $($prodMatches.Count)"
        
        # Let's sample the first 5 product names
        $sampleNames = [regex]::Matches($content, '(?s)<h4[^>]*>\s*<a[^>]*>(.*?)</a>\s*</h4>') | ForEach-Object {
            [System.Web.HttpUtility]::HtmlDecode($_.Groups[1].Value.Trim())
        } | Where-Object { $_ -notmatch 'Business Essentials|Love Your New Look|Made by You|Home & Gifts|Looking for More|Quick Links|Our Services|Subscribe' }
        Write-Host "Sample products count: $($sampleNames.Count)"
        Write-Host "First 10 products: " (($sampleNames | Select-Object -First 10) -join ", ")
        Write-Host ""
    }
}
