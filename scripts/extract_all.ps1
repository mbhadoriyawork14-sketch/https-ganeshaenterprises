Add-Type -AssemblyName System.Web

function Clean-Text($str) {
    if ([string]::IsNullOrEmpty($str)) { return "" }
    $s = [System.Web.HttpUtility]::HtmlDecode($str)
    $s = [regex]::Replace($s, '<[^>]+>', ' ')
    $s = [regex]::Replace($s, '[â\u0080\u0098\u0099\u2018\u2019]', "'")
    $s = [regex]::Replace($s, '[â\u0080\u009c\u009d\u201c\u201d]', '"')
    $s = [regex]::Replace($s, '[â\u0080\u0094\u2014]', ' - ')
    $s = [regex]::Replace($s, '[â\u0080\u0093\u2013]', '-')
    $s = [regex]::Replace($s, '[â\u0080\u00a2\u2022]', '•')
    $s = [regex]::Replace($s, '\s+', ' ')
    return $s.Trim()
}

# 1. Site Settings
$siteSettings = [ordered]@{
    companyName = "Ganesha Enterprises"
    tagline = "Top Printing Services in Delhi NCR | Custom & Digital Printing"
    description = "Discover premium digital printing and personalized product design at Ganesha Enterprises. Trusted by 5,000+ brands. Fast delivery, global shipping, and unbeatable quality."
    metaKeywords = "digital printing services Delhi NCR, custom printing Delhi, product printing Delhi NCR, printing company in Delhi, business card printing Delhi, brochure printing Delhi, t-shirt printing Delhi NCR, vinyl printing Delhi, banner printing Delhi, customized merchandise Delhi, mug printing Delhi, bottle printing Delhi, corporate printing services Delhi NCR, commercial printing Delhi, print shop near me Delhi NCR"
    experienceYears = "25+"
    brandsCount = "1,000+ Global & Local Brands"
    trustedCount = "5,000+ Brands"
    contact = [ordered]@{
        phone = "+91-9650044234"
        phoneRaw = "9650044234"
        email = "vineet@ganeshaenterprises.in"
        address = "Ground floor, B191, Industrial Area Phase I, Block C, Naraina Industrial Area Phase 1, Naraina, New Delhi"
        googleMapsUrl = "https://g.co/kgs/FR5wZph"
        googleMapsEmbed = "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3502.261972844893!2d77.13524177617454!3d28.62198088457788!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x390d0322d71859bf%3A0xe543dc6ec7be4f59!2sGanesha%20Enterprises!5e0!3m2!1sen!2sin!4v1718000000000!5m2!1sen!2sin"
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
Write-Host "Wrote content/site-settings.json"

# 2. Services Extraction
$serviceDefs = @(
    @{ slug = "corporate-office-printing"; file = "service_Corporate_Office_Printing.html"; icon = "assets/imgs/Icons/stationery.png" },
    @{ slug = "marketing-promotional-printing"; file = "service_Marketing_&_Promotional_Printing.html"; icon = "assets/imgs/Icons/color-selection.png" },
    @{ slug = "customized-merchandise"; file = "service_Customized_Merchandise.html"; icon = "assets/imgs/Icons/customizable.png" },
    @{ slug = "packaging-labels"; file = "service_Packaging_&_Labels.html"; icon = "assets/imgs/Icons/package.png" },
    @{ slug = "large-format-event-printing"; file = "service_Large_Format_&_Event_Printing.html"; icon = "assets/imgs/Icons/poster.png" },
    @{ slug = "books-photo-products"; file = "service_Books_&_Photo_Products.html"; icon = "assets/imgs/Icons/book.png" },
    @{ slug = "premium-finishing"; file = "service_Premium_Finishing.html"; icon = "assets/imgs/Icons/printer.png" },
    @{ slug = "digital-personalized-printing"; file = "service_Digital_&_Personalized_Printing.html"; icon = "assets/imgs/Icons/printing.png" }
)

$servicesData = @()
foreach ($s in $serviceDefs) {
    $filePath = "_raw_site/pages/$($s.file)"
    if (Test-Path $filePath) {
        $raw = Get-Content $filePath -Raw -Encoding UTF8
        
        $tM = [regex]::Match($raw, '(?s)<h2 class="service-details-content-title">\s*(.*?)\s*</h2>')
        $title = Clean-Text $tM.Groups[1].Value
        
        $subM = [regex]::Match($raw, '(?s)<h2[^>]*>.*?</h2>\s*<h3>(.*?)</h3>')
        $subtitle = Clean-Text $subM.Groups[1].Value

        $imgM = [regex]::Match($raw, '(?s)<div class="service-details-content-thumb[^"]*">\s*<img[^>]+src="([^"]+)"')
        $image = $imgM.Groups[1].Value

        $descM = [regex]::Match($raw, '(?s)</h3>\s*<p>(.*?)</p>')
        $description = Clean-Text $descM.Groups[1].Value

        $offM = [regex]::Match($raw, '(?s)<h4>Our Offerings:</h4>\s*<ul>(.*?)</ul>')
        $offerings = @()
        if ($offM.Success) {
            $offerings = [regex]::Matches($offM.Groups[1].Value, '(?s)<li>(.*?)</li>') | ForEach-Object { Clean-Text $_.Groups[1].Value }
        }

        $whyM = [regex]::Match($raw, '(?s)<h4>Why Choose Us:</h4>\s*<ul>(.*?)</ul>')
        $whyChooseUs = @()
        if ($whyM.Success) {
            $whyChooseUs = [regex]::Matches($whyM.Groups[1].Value, '(?s)<li>(.*?)</li>') | ForEach-Object { Clean-Text $_.Groups[1].Value }
        }

        $serviceObj = [ordered]@{
            id = $s.slug
            slug = $s.slug
            sourceFile = $s.file
            title = $title
            subtitle = $subtitle
            image = $image
            icon = $s.icon
            description = $description
            offerings = $offerings
            whyChooseUs = $whyChooseUs
        }
        $servicesData += $serviceObj

        $offMd = ($offerings | ForEach-Object { "- $_" }) -join "`n"
        $whyMd = ($whyChooseUs | ForEach-Object { "- $_" }) -join "`n"
        $mdContent = @"
# $title
*$subtitle*

![$title](/$image)

$description

## Our Offerings
$offMd

## Why Choose Us
$whyMd
"@
        Set-Content -Path "content/services/$($s.slug).md" -Value $mdContent -Encoding UTF8
    }
}
$servicesData | ConvertTo-Json -Depth 10 | Set-Content "content/services/services.json" -Encoding UTF8
Write-Host "Wrote content/services/services.json with $($servicesData.Count) services"

# 3. FAQs Extraction
$faqHtml = Get-Content "_raw_site/pages/about_us.html" -Raw -Encoding UTF8
$faqCards = [regex]::Matches($faqHtml, '(?s)<div class="card[^"]*">\s*<div class="card-header">\s*<button[^>]*>(.*?)</button>\s*</div>\s*<div[^>]*>\s*<div class="card-body">\s*<p>(.*?)</p>')
$faqList = @()
foreach ($fc in $faqCards) {
    $q = Clean-Text $fc.Groups[1].Value
    $a = Clean-Text $fc.Groups[2].Value
    if ($q -and $a) {
        $faqList += [ordered]@{ question = $q; answer = $a; category = "General" }
    }
}

# Also check service FAQs
$srvFaqHtml = Get-Content "_raw_site/pages/service_Corporate_Office_Printing.html" -Raw -Encoding UTF8
$srvFaqCards = [regex]::Matches($srvFaqHtml, '(?s)<div class="card[^"]*">\s*<div class="card-header">\s*<a[^>]*>(.*?)</a>\s*</div>\s*<div[^>]*>\s*<div class="card-body">\s*<p>(.*?)</p>')
foreach ($fc in $srvFaqCards) {
    $q = Clean-Text $fc.Groups[1].Value
    $a = Clean-Text $fc.Groups[2].Value
    if ($q -and $a -and !($faqList | Where-Object { $_.question -eq $q })) {
        $faqList += [ordered]@{ question = $q; answer = $a; category = "Ordering & Process" }
    }
}

$faqList | ConvertTo-Json -Depth 10 | Set-Content "content/faqs/faqs.json" -Encoding UTF8
Write-Host "Wrote content/faqs/faqs.json with $($faqList.Count) FAQs"

# 4. Blogs Extraction
$blogDefs = @(
    @{ id = "why-custom-printing-is-the-secret-weapon-of-modern-branding"; title = "Why Custom Printing Is the Secret Weapon of Modern Branding"; date = "25 June 2025"; author = "Ganesha Enterprises"; image = "assets/imgs/blog/bank-phrom-Tzm3Oyu_6sk-unsplash.jpg"; sourceFile = "blog_1.html" },
    @{ id = "t-shirts-to-tumblers-top-10-custom-products"; title = "T-Shirts to Tumblers: Top 10 Custom Products to Boost Brand Loyalty"; date = "25 June 2025"; author = "Ganesha Enterprises"; image = "assets/imgs/blog/alexey-demidov-GwyI9juslws-unsplash.png"; sourceFile = "blog_2.html" },
    @{ id = "the-psychology-of-colors-in-custom-printing"; title = "The Psychology of Colors in Custom Printing: What Your Brand Is Really Saying"; date = "25 June 2025"; author = "Ganesha Enterprises"; image = "assets/imgs/blog/in-tr-ng-d-ng-daZPDnz9lQY-unsplash.jpg"; sourceFile = "blog_grid.html" },
    @{ id = "eco-friendly-custom-printing-5-sustainable-materials"; title = "Eco-Friendly Custom Printing: 5 Sustainable Materials You Should Try"; date = "25 June 2025"; author = "Ganesha Enterprises"; image = "assets/imgs/blog/mika-baumeister-PtabTe6iJ_8-unsplash.jpg"; sourceFile = "blog_grid.html" },
    @{ id = "from-file-to-finish-what-to-expect"; title = "From File to Finish: What to Expect in a Custom Printing Project"; date = "25 June 2025"; author = "Ganesha Enterprises"; image = "assets/imgs/blog/brands-people-0adHvNJu-Zo-unsplash.jpg"; sourceFile = "blog_grid.html" },
    @{ id = "how-small-businesses-can-win-big-with-custom-packaging"; title = "How Small Businesses Can Win Big with Custom Packaging"; date = "25 June 2025"; author = "Ganesha Enterprises"; image = "assets/imgs/blog/mildlee-fMveBTz2qWw-unsplash.jpg"; sourceFile = "blog_grid.html" }
)

$blogsData = @()

# Blog 1 full content
$b1Raw = Get-Content "_raw_site/pages/blog_1.html" -Raw -Encoding UTF8
$b1ContentMatch = [regex]::Match($b1Raw, '(?s)<div class="blog__details-content">(.*?)<div class="blog__details-bottom')
$b1Html = $b1ContentMatch.Groups[1].Value

# Blog 2 full content
$b2Raw = Get-Content "_raw_site/pages/blog_2.html" -Raw -Encoding UTF8
$b2ContentMatch = [regex]::Match($b2Raw, '(?s)<div class="blog__details-content">(.*?)<div class="blog__details-bottom')
$b2Html = $b2ContentMatch.Groups[1].Value

foreach ($b in $blogDefs) {
    $fullContent = ""
    $summary = ""
    if ($b.id -eq "why-custom-printing-is-the-secret-weapon-of-modern-branding") {
        $summary = "In a world dominated by digital ads and fast scrolling, physical brand touchpoints have become more powerful than ever. One of the most overlooked branding tools is custom printing - a cost-effective, tangible way to create lasting impressions."
        $fullContent = Clean-Text $b1Html
    } elseif ($b.id -eq "t-shirts-to-tumblers-top-10-custom-products") {
        $summary = "Brand loyalty doesn't come from just ads and discounts - it comes from meaningful experiences. One of the most powerful ways to create those moments is through custom-branded products."
        $fullContent = Clean-Text $b2Html
    } elseif ($b.id -eq "the-psychology-of-colors-in-custom-printing") {
        $summary = "Color plays a vital psychological role in brand perception. Explore how specific palettes, hues, and print finishes communicate your company values and influence customer trust."
        $fullContent = "Color plays a vital psychological role in brand perception. Explore how specific palettes, hues, and print finishes communicate your company values and influence customer trust. From bold vibrant shades that drive retail purchases to classic matte blues and monochromes that convey corporate stability, every pigment choice creates an subconscious impact."
    } elseif ($b.id -eq "eco-friendly-custom-printing-5-sustainable-materials") {
        $summary = "Discover 5 sustainable print materials - from recycled kraft paper to organic cotton and soy-based inks - that reduce environmental footprint while maintaining exceptional print quality."
        $fullContent = "Discover 5 sustainable print materials - from recycled kraft paper to organic cotton and soy-based inks - that reduce environmental footprint while maintaining exceptional print quality. Modern eco-printing gives brands the power to stay green without compromising on tactile quality or visual brilliance."
    } elseif ($b.id -eq "from-file-to-finish-what-to-expect") {
        $summary = "A comprehensive step-by-step walkthrough of the commercial printing workflow: prepress file preparation, color proofing, material selection, plate making, digital press runs, and post-press finishing."
        $fullContent = "A comprehensive step-by-step walkthrough of the commercial printing workflow: prepress file preparation, color proofing, material selection, plate making, digital press runs, and post-press finishing. Understanding each stage ensures seamless project execution and pristine finished output."
    } elseif ($b.id -eq "how-small-businesses-can-win-big-with-custom-packaging") {
        $summary = "Why custom packaging is the ultimate brand ambassador for e-commerce and retail brands, turning unboxing moments into powerful customer acquisition and retention engines."
        $fullContent = "Why custom packaging is the ultimate brand ambassador for e-commerce and retail brands, turning unboxing moments into powerful customer acquisition and retention engines. Customized mailer boxes, branded tape, and custom tissue paper create memorable first impressions that customers share on social media."
    }

    $blogObj = [ordered]@{
        id = $b.id
        title = $b.title
        slug = $b.id
        date = $b.date
        author = $b.author
        image = $b.image
        summary = $summary
        content = $fullContent
        tags = @("Branding", "Custom Printing", "Corporate Gifting", "Packaging")
    }
    $blogsData += $blogObj

    $blogMd = @"
# $($b.title)
*Published on $($b.date) by $($b.author)*

![$($b.title)](/$($b.image))

$fullContent
"@
    Set-Content -Path "content/blogs/$($b.id).md" -Value $blogMd -Encoding UTF8
}

$blogsData | ConvertTo-Json -Depth 10 | Set-Content "content/blogs/blogs.json" -Encoding UTF8
Write-Host "Wrote content/blogs/blogs.json with $($blogsData.Count) blog posts"

# 5. Products Extraction (from all shop HTML files)
$shopFiles = @(
    @{ category = "Business Essentials"; slug = "business-essentials"; file = "shop _Business_Essentials.html" },
    @{ category = "Love Your New Look"; slug = "love-your-new-look"; file = "shop _Love_Your_New_Look.html" },
    @{ category = "Made by You"; slug = "made-by-you"; file = "shop_Made_by_You.html" },
    @{ category = "Home & Gifts"; slug = "home-gifts"; file = "shop_Home_&_Gifts.html" }
)

$allProducts = @()
$seenNames = New-Object System.Collections.Generic.HashSet[string]

foreach ($sf in $shopFiles) {
    $p = "_raw_site/pages/$($sf.file)"
    if (Test-Path $p) {
        $html = Get-Content $p -Raw -Encoding UTF8
        # Match product items
        $items = [regex]::Matches($html, '(?s)<div class="rr-fea-product__item[^"]*">(.*?)<div class="rr-fea-product__link-box">')
        foreach ($item in $items) {
            $itemHtml = $item.Groups[1].Value
            $imgM = [regex]::Match($itemHtml, '(?s)<img[^>]+src="([^"]+)"')
            $titleM = [regex]::Match($itemHtml, '(?s)<h4[^>]*>\s*<a[^>]*>(.*?)</a>\s*</h4>')
            
            $prodTitle = Clean-Text $titleM.Groups[1].Value
            $prodImg = $imgM.Groups[1].Value
            
            if ($prodTitle -and !$seenNames.Contains($prodTitle)) {
                $seenNames.Add($prodTitle) | Out-Null
                $prodSlug = ($prodTitle.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')
                $allProducts += [ordered]@{
                    id = $prodSlug
                    name = $prodTitle
                    slug = $prodSlug
                    category = $sf.category
                    categorySlug = $sf.slug
                    image = $prodImg
                    rating = 5
                    description = "Premium customized $($prodTitle.ToLower()) with precision printing and tailored finishes for corporate branding and personalized gifting."
                }
            }
        }
    }
}

# Also parse any additional items from master shop.html
$masterShop = Get-Content "_raw_site/pages/shop.html" -Raw -Encoding UTF8
$mItems = [regex]::Matches($masterShop, '(?s)<div class="rr-fea-product__item[^"]*">(.*?)<div class="rr-fea-product__link-box">')
foreach ($item in $mItems) {
    $itemHtml = $item.Groups[1].Value
    $imgM = [regex]::Match($itemHtml, '(?s)<img[^>]+src="([^"]+)"')
    $titleM = [regex]::Match($itemHtml, '(?s)<h4[^>]*>\s*<a[^>]*>(.*?)</a>\s*</h4>')
    $prodTitle = Clean-Text $titleM.Groups[1].Value
    $prodImg = $imgM.Groups[1].Value
    if ($prodTitle -and !$seenNames.Contains($prodTitle)) {
        $seenNames.Add($prodTitle) | Out-Null
        $prodSlug = ($prodTitle.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')
        
        # Categorize by keyword
        $cat = "Business Essentials"
        $catSlug = "business-essentials"
        if ($prodTitle -match 'T-Shirt|Cap|Bag|Vest|Apron|Coat|Polo') {
            $cat = "Love Your New Look"
            $catSlug = "love-your-new-look"
        } elseif ($prodTitle -match 'Mug|Bottle|Flask|Glass|Umbrella|Kit|Hamper|Pen Stand|Organizer') {
            $cat = "Home & Gifts"
            $catSlug = "home-gifts"
        } elseif ($prodTitle -match 'Calendar|Photo|Canvas|Frame|Puzzle|Magnet|Keychain|Diary|Notebook') {
            $cat = "Made by You"
            $catSlug = "made-by-you"
        }

        $allProducts += [ordered]@{
            id = $prodSlug
            name = $prodTitle
            slug = $prodSlug
            category = $cat
            categorySlug = $catSlug
            image = $prodImg
            rating = 5
            description = "High quality custom printed $($prodTitle.ToLower()) designed for durability, vibrant color reproduction, and professional brand presentation."
        }
    }
}

$allProducts | ConvertTo-Json -Depth 10 | Set-Content "content/products/products.json" -Encoding UTF8
Write-Host "Wrote content/products/products.json with $($allProducts.Count) products"

# 6. Portfolio Extraction
$portfolioHtml = Get-Content "_raw_site/pages/portfolio.html" -Raw -Encoding UTF8
$workItems = @(
    @{ title = "Vistara Branded Cap"; category = "Cap Printing"; client = "Vistara"; image = "assets/imgs/Our Work/WhatsApp Image 2025-06-20 at 19.14.39.jpeg" },
    @{ title = "Vistara Executive Notebook"; category = "Notebook Printing"; client = "Vistara"; image = "assets/imgs/Our Work/WhatsApp Image 2025-06-20 at 19.16.24.jpeg" },
    @{ title = "NTPC Corporate Cap"; category = "Cap Printing"; client = "NTPC"; image = "assets/imgs/Our Work/WhatsApp Image 2025-06-20 at 19.18.36.jpeg" },
    @{ title = "Custom Insulated Bottle"; category = "Bottle Printing"; client = "Custom Print Design"; image = "assets/imgs/Our Work/WhatsApp Image 2025-06-26 at 11.24.22.jpeg" },
    @{ title = "Trot Hotels Desk Calendar"; category = "Calendar Printing"; client = "Trot Hotels"; image = "assets/imgs/Our Work/WhatsApp Image 2025-06-26 at 11.24.20.jpeg" },
    @{ title = "Air India Event Badge"; category = "Badge Printing"; client = "Air India"; image = "assets/imgs/Our Work/WhatsApp Image 2025-06-26 at 11.24.23.jpeg" },
    @{ title = "Custom Branded Bags"; category = "Bag Printing"; client = "Retail & Merchandise"; image = "assets/imgs/Our Work/Bag (2).jpg" },
    @{ title = "Vacuum Flask With Steel Cup"; category = "Corporate Gifting"; client = "Corporate Clients"; image = "assets/imgs/feature-5/Vacuum_Flask_with_3 Steel_Cup.jpg" },
    @{ title = "Employee Welcome Kit"; category = "Joining Kits"; client = "Corporate Enterprise"; image = "assets/imgs/feature-5/Welcome_Kit.jpg" }
)
$workItems | ConvertTo-Json -Depth 10 | Set-Content "content/portfolio/portfolio.json" -Encoding UTF8
Write-Host "Wrote content/portfolio/portfolio.json with $($workItems.Count) portfolio items"
