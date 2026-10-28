Add-Type -AssemblyName System.Web

function Fix-Text($txt) {
    if (!$txt) { return "" }
    $t = [System.Web.HttpUtility]::HtmlDecode($txt)
    # Fix UTF-8 mojibake
    $t = $t.Replace("â€™", "'").Replace("â€˜", "'").Replace("â€œ", '"').Replace("â€", '"')
    $t = $t.Replace("â€”", "—").Replace("â€“", "–").Replace("â€¢", "•").Replace("â€¦", "...")
    $t = $t.Replace("&nbsp;", " ")
    $t = [regex]::Replace($t, '\s+', ' ').Trim()
    return $t
}

# 1. Site Settings
$siteSettings = [ordered]@{
    companyName = "Ganesha Enterprises"
    tagline = "Top Printing Services in Delhi NCR | Custom & Digital Printing"
    description = "Discover premium digital printing and personalized product design at Ganesha Enterprises. Trusted by 5,000+ brands. Fast delivery, global shipping, and unbeatable quality."
    experienceYears = "25+"
    brandsCount = "1,000+ Global & Local Brands"
    trustedCount = "5,000+ Brands"
    contact = [ordered]@{
        phone = "+91-9650044234"
        phoneRaw = "9650044234"
        email = "vineet@ganeshaenterprises.in"
        address = "Ground floor, B191, Industrial Area Phase I, Block C, Naraina Industrial Area Phase 1, Naraina, New Delhi"
        googleMapsUrl = "https://g.co/kgs/FR5wZph"
        googleMapsEmbed = "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d14008.272102148118!2d77.127926!3d28.627763!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x390d0323382c40c9%3A0x6b131846b4146a48!2sNaraina%20Industrial%20Area%20Phase%201%2C%20New%20Delhi!5e0!3m2!1sen!2sin!4v1718000000000!5m2!1sen!2sin"
    }
    socialLinks = [ordered]@{
        instagram = "https://www.instagram.com/ganeshaent2/"
        facebook = "https://www.facebook.com/"
        whatsapp = "https://wa.me/919650044234"
    }
    logos = [ordered]@{
        main = "assets/imgs/logo/logo.svg"
        offcanvas = "assets/imgs/logo/offcanvas-logo.png"
        footer = "assets/imgs/footer/logo.svg"
        favicon = "assets/imgs/logo/favicon.svg"
    }
    clients = @(
        @{ name = "Vistara"; logo = "assets/imgs/Our Clients/Vistara_Logo.png" },
        @{ name = "SIG Holding"; logo = "assets/imgs/Our Clients/SIG_Holding_logo.png" },
        @{ name = "Radisson"; logo = "assets/imgs/Our Clients/Radisson_logo.png" },
        @{ name = "Netcracker Technology"; logo = "assets/imgs/Our Clients/Netcracker_Technology_logo.png" },
        @{ name = "National Thermal Power (NTPC)"; logo = "assets/imgs/Our Clients/National_Thermal_Power_logo.png" },
        @{ name = "Khan Academy"; logo = "assets/imgs/Our Clients/Khan_Academy_logo.png" },
        @{ name = "Awfis"; logo = "assets/imgs/Our Clients/Awfis_new_logo.png" },
        @{ name = "Air India"; logo = "assets/imgs/Our Clients/air_india_new_logo.png" },
        @{ name = "Air India Express"; logo = "assets/imgs/Our Clients/Air_India_Express-Logo.png" }
    )
}

$siteSettings | ConvertTo-Json -Depth 10 | Set-Content "content/site-settings.json" -Encoding UTF8
Write-Host "Saved content/site-settings.json"

# 2. Extract Services
$serviceFiles = @(
    @{ slug = "corporate-office-printing"; file = "service_Corporate_Office_Printing.html"; icon = "assets/imgs/Icons/stationery.png" },
    @{ slug = "marketing-promotional-printing"; file = "service_Marketing_&_Promotional_Printing.html"; icon = "assets/imgs/Icons/color-selection.png" },
    @{ slug = "customized-merchandise"; file = "service_Customized_Merchandise.html"; icon = "assets/imgs/Icons/customizable.png" },
    @{ slug = "packaging-labels"; file = "service_Packaging_&_Labels.html"; icon = "assets/imgs/Icons/package.png" },
    @{ slug = "large-format-event-printing"; file = "service_Large_Format_&_Event_Printing.html"; icon = "assets/imgs/Icons/poster.png" },
    @{ slug = "books-photo-products"; file = "service_Books_&_Photo_Products.html"; icon = "assets/imgs/Icons/book.png" },
    @{ slug = "premium-finishing"; file = "service_Premium_Finishing.html"; icon = "assets/imgs/Icons/printer.png" },
    @{ slug = "digital-personalized-printing"; file = "service_Digital_&_Personalized_Printing.html"; icon = "assets/imgs/Icons/printing.png" }
)

$servicesList = @()
foreach ($sf in $serviceFiles) {
    $p = "_raw_site/pages/$($sf.file)"
    if (Test-Path $p) {
        $html = Get-Content $p -Raw -Encoding UTF8
        
        $titleMatch = [regex]::Match($html, '(?s)<h2[^>]*class="service-details-content-title"[^>]*>(.*?)</h2>')
        $title = Fix-Text $titleMatch.Groups[1].Value
        
        $subtitleMatch = [regex]::Match($html, '(?s)</h3>|(?s)<h2[^>]*>.*?</h2>\s*<h3>(.*?)</h3>')
        $subtitle = Fix-Text $subtitleMatch.Groups[1].Value

        $imgMatch = [regex]::Match($html, '(?s)<div class="service-details-content-thumb[^"]*">\s*<img[^>]+src="([^"]+)"')
        $image = $imgMatch.Groups[1].Value

        $descMatch = [regex]::Match($html, '(?s)</h3>\s*<p>(.*?)</p>')
        $description = Fix-Text $descMatch.Groups[1].Value

        # Offerings
        $offeringSection = [regex]::Match($html, '(?s)<h4>Our Offerings:</h4>\s*<ul>(.*?)</ul>')
        $offerings = @()
        if ($offeringSection.Success) {
            $offerings = [regex]::Matches($offeringSection.Groups[1].Value, '(?s)<li>(.*?)</li>') | ForEach-Object { Fix-Text $_.Groups[1].Value }
        }

        # Why Choose Us
        $whySection = [regex]::Match($html, '(?s)<h4>Why Choose Us:</h4>\s*<ul>(.*?)</ul>')
        $whyChooseUs = @()
        if ($whySection.Success) {
            $whyChooseUs = [regex]::Matches($whySection.Groups[1].Value, '(?s)<li>(.*?)</li>') | ForEach-Object { Fix-Text $_.Groups[1].Value }
        }

        $srv = [ordered]@{
            slug = $sf.slug
            sourceFile = $sf.file
            title = $title
            subtitle = $subtitle
            image = $image
            icon = $sf.icon
            description = $description
            offerings = $offerings
            whyChooseUs = $whyChooseUs
        }
        $servicesList += $srv

        # Write individual service markdown
        $md = @"
# $($title)
**$($subtitle)**

![$($title)](/$($image))

$($description)

### Our Offerings
$((($offerings | ForEach-Object { "- $_" }) -join "`n"))

### Why Choose Us
$((($whyChooseUs | ForEach-Object { "- $_" }) -join "`n"))
"@
        Set-Content -Path "content/services/$($sf.slug).md" -Value $md -Encoding UTF8
    }
}

$servicesList | ConvertTo-Json -Depth 10 | Set-Content "content/services/services.json" -Encoding UTF8
Write-Host "Saved content/services/services.json with $($servicesList.Count) services"
