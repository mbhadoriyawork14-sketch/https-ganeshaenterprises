Add-Type -AssemblyName System.Web

$services = Get-Content "content/services/services.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$products = Get-Content "content/products/products.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$blogs = Get-Content "content/blogs/blogs.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$portfolio = Get-Content "content/portfolio/portfolio.json" -Raw -Encoding UTF8 | ConvertFrom-Json

# Helper for Nav
$navHtml = @'
  <aside class="top-bar">
    <div class="container">
      <div class="top-bar-inner">
        <div class="top-bar-left">
          <a href="tel:9650044234" class="top-bar-item"><i class="fa-solid fa-phone"></i> <span>+91-9650044234</span></a>
          <a href="mailto:vineet@ganeshaenterprises.in" class="top-bar-item"><i class="fa-solid fa-envelope"></i> <span>vineet@ganeshaenterprises.in</span></a>
          <span class="top-bar-item"><i class="fa-solid fa-location-dot"></i> <span>Naraina Industrial Area Phase 1, New Delhi</span></span>
        </div>
        <div class="top-bar-right">
          <a href="https://wa.me/919650044234" target="_blank" rel="noopener" class="top-bar-item" style="color:#25d366;font-weight:700;"><i class="fa-brands fa-whatsapp"></i> <span>WhatsApp Us</span></a>
          <a href="https://www.instagram.com/ganeshaent2/" target="_blank" rel="noopener" class="top-bar-item"><i class="fa-brands fa-instagram"></i></a>
          <a href="https://www.facebook.com/" target="_blank" rel="noopener" class="top-bar-item"><i class="fa-brands fa-facebook-f"></i></a>
        </div>
      </div>
    </div>
  </aside>
'@

function Get-ServiceHtml($s) {
    $offLi = ($s.offerings | ForEach-Object { "<li style='display:flex;align-items:center;gap:10px;font-size:0.95rem;font-weight:600;color:var(--color-primary);'><i class='fa-solid fa-circle-check' style='color:var(--color-accent);flex-shrink:0;'></i> <span>$_</span></li>" }) -join "`n"
    $whyLi = ($s.whyChooseUs | ForEach-Object { "<li style='display:flex;align-items:center;gap:12px;font-size:0.95rem;color:var(--color-primary);'><i class='fa-solid fa-award' style='color:var(--color-accent);font-size:1.1rem;flex-shrink:0;'></i> <span>$_</span></li>" }) -join "`n"

    $otherSrv = ($services | Where-Object { $_.slug -ne $s.slug } | ForEach-Object {
        "<a href='$($_.slug).html' style='display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:#ffffff;border-radius:var(--radius-md);border:1px solid var(--color-border);font-size:0.9rem;font-weight:600;color:var(--color-primary);'><span>$($_.title)</span><i class='fa-solid fa-angle-right' style='color:var(--color-accent);'></i></a>"
    }) -join "`n"

    return @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$($s.title) | Ganesha Enterprises Delhi NCR</title>
  <meta name="description" content="$($s.subtitle). $($s.description)">
  <link rel="icon" type="image/svg+xml" href="../assets/imgs/logo/favicon.svg">
  <link rel="stylesheet" href="../css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
$navHtml
  <header class="header-sticky">
    <div class="container">
      <nav class="navbar">
        <a href="../index.html" class="brand-logo"><img src="../assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" width="180" height="46"></a>
        <div class="nav-menu">
          <a href="../index.html" class="nav-link">Home</a>
          <a href="../about.html" class="nav-link">About Us</a>
          <a href="../services.html" class="nav-link active">Services</a>
          <a href="../products.html" class="nav-link">Products</a>
          <a href="../portfolio.html" class="nav-link">Portfolio</a>
          <a href="../blog.html" class="nav-link">Blogs</a>
          <a href="../contact.html" class="nav-link">Contact</a>
        </div>
        <div class="nav-actions">
          <a href="../contact.html" class="btn btn-primary" data-open-quote><i class="fa-solid fa-paper-plane"></i> <span>Get A Quote</span></a>
          <button id="mobileToggle" class="mobile-toggle"><i class="fa-solid fa-bars"></i></button>
        </div>
      </nav>
    </div>
  </header>

  <div id="mobileDrawer" class="mobile-drawer">
    <div class="drawer-header">
      <img src="../assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" height="38">
      <button id="drawerClose" class="drawer-close"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <div class="drawer-nav">
      <a href="../index.html" class="drawer-link">Home</a>
      <a href="../about.html" class="drawer-link">About Us</a>
      <a href="../services.html" class="drawer-link">Services</a>
      <a href="../products.html" class="drawer-link">Products (90+ Items)</a>
      <a href="../portfolio.html" class="drawer-link">Portfolio & Clients</a>
      <a href="../blog.html" class="drawer-link">Blog & News</a>
      <a href="../contact.html" class="drawer-link">Contact Us</a>
    </div>
  </div>
  <div id="mobileOverlay" class="mobile-overlay"></div>

  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="../index.html">Home</a> <span>/</span> <a href="../services.html">Services</a> <span>/</span> <span style="color:var(--color-accent);font-weight:600;">$($s.title)</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2.2rem, 3.8vw, 3rem);">$($s.title)</h1>
      <p style="font-size:1.15rem;color:var(--color-accent);font-weight:600;margin-top:8px;">$($s.subtitle)</p>
    </div>
  </section>

  <section class="section bg-white">
    <div class="container">
      <div class="contact-layout">
        <div>
          <div style="border-radius:var(--radius-xl);overflow:hidden;margin-bottom:32px;box-shadow:var(--shadow-lg);border:1px solid var(--color-border);">
            <img src="../$($s.image)" alt="$($s.title)" style="width:100%;height:auto;aspect-ratio:16/10;object-fit:cover;">
          </div>

          <h2 style="font-size:1.8rem;margin-bottom:16px;">Overview</h2>
          <p style="font-size:1.05rem;color:var(--color-text-muted);line-height:1.8;margin-bottom:32px;">
            $($s.description)
          </p>

          <div style="background-color:var(--color-bg-alt);border-radius:var(--radius-lg);padding:32px;margin-bottom:36px;border:1px solid var(--color-border);">
            <h3 style="font-size:1.35rem;margin-bottom:18px;color:var(--color-primary);">Our Offerings:</h3>
            <ul style="display:grid;grid-template-columns:repeat(auto-fit, minmax(260px, 1fr));gap:12px;">
              $offLi
            </ul>
          </div>

          <div style="background-color:#ffffff;border-radius:var(--radius-lg);padding:32px;border:1px solid var(--color-border);margin-bottom:40px;">
            <h3 style="font-size:1.35rem;margin-bottom:18px;color:var(--color-primary);">Why Choose Us:</h3>
            <ul style="display:flex;flex-direction:column;gap:12px;">
              $whyLi
            </ul>
          </div>

          <div style="margin-top:40px;">
            <h3 style="font-size:1.5rem;margin-bottom:20px;">Frequently Asked Questions</h3>
            <div class="faq-container" style="max-width:100%;">
              <div class="faq-item">
                <button class="faq-question"><span>How do I place an order for this service?</span><i class="fa-solid fa-chevron-down faq-icon"></i></button>
                <div class="faq-answer"><p>You can place an order through our website, WhatsApp, or by visiting our Naraina studio. Share your specifications and file designs, and our team will prepare proofs immediately.</p></div>
              </div>
              <div class="faq-item">
                <button class="faq-question"><span>Do you deliver across Delhi NCR and nationwide?</span><i class="fa-solid fa-chevron-down faq-icon"></i></button>
                <div class="faq-answer"><p>Yes, we offer express local courier delivery in Delhi NCR and secure logistics across all Indian states and worldwide.</p></div>
              </div>
              <div class="faq-item">
                <button class="faq-question"><span>Can I see a sample before final printing?</span><i class="fa-solid fa-chevron-down faq-icon"></i></button>
                <div class="faq-answer"><p>Absolutely! We provide digital PDF proofs or physical material samples before proceeding with the full production run.</p></div>
              </div>
            </div>
          </div>
        </div>

        <div>
          <div style="position:sticky;top:90px;display:flex;flex-direction:column;gap:24px;">
            <div class="contact-info-card" style="padding:32px;">
              <h3 style="color:#ffffff;font-size:1.4rem;margin-bottom:8px;">Request Quote For This Service</h3>
              <p style="color:var(--color-text-light);font-size:0.9rem;margin-bottom:20px;">Get volume pricing and turnaround options from our Naraina print specialists.</p>
              <form data-ajax-form>
                <input type="hidden" name="requirement" value="Service Inquiry: $($s.title)">
                <div style="display:flex;flex-direction:column;gap:12px;margin-bottom:16px;">
                  <input type="text" name="name" class="form-control" placeholder="Your Name" required>
                  <input type="tel" name="phone" class="form-control" placeholder="Phone Number" required>
                  <input type="email" name="email" class="form-control" placeholder="Email Address">
                  <textarea name="message" class="form-control" placeholder="Specifications, quantity, delivery location..." style="min-height:90px;"></textarea>
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;"><i class="fa-solid fa-paper-plane"></i> <span>Send Request</span></button>
              </form>
            </div>

            <div style="background-color:var(--color-bg-alt);border:1px solid var(--color-border);border-radius:var(--radius-xl);padding:24px;">
              <h4 style="font-size:1.1rem;margin-bottom:16px;color:var(--color-primary);">Explore Other Services</h4>
              <div style="display:flex;flex-direction:column;gap:8px;">
                $otherSrv
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <footer class="site-footer">
    <div class="container">
      <div class="footer-bottom">
        <div>&copy; 2026 Ganesha Enterprises. All rights reserved.</div>
        <div class="footer-bottom-links">
          <a href="../privacy-policy.html">Privacy Policy</a>
          <a href="../terms-and-conditions.html">Terms & Conditions</a>
          <a href="../sitemap.xml">XML Sitemap</a>
        </div>
      </div>
    </div>
  </footer>
  <script src="../js/main.js"></script>
</body>
</html>
"@
}

# Generate 8 services
foreach ($s in $services) {
    $content = Get-ServiceHtml $s
    Set-Content -Path "services/$($s.slug).html" -Value $content -Encoding UTF8
    Write-Host "Generated services/$($s.slug).html"
}

# Helper for Product Cards
$prodCards = ($products | ForEach-Object {
    @"
    <div class="product-card" data-category="$($_.categorySlug)">
      <div class="product-thumb">
        <span class="product-badge">$($_.category)</span>
        <img src="$($_.image)" alt="$($_.name)" loading="lazy">
      </div>
      <div class="product-content">
        <div class="product-category">$($_.category)</div>
        <h3 class="product-title">$($_.name)</h3>
        <p class="product-desc">$($_.description)</p>
        <div class="product-footer">
          <div class="rating-stars"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></div>
          <button class="btn btn-primary btn-sm" data-open-quote data-product-name="$($_.name)">Inquire Quote</button>
        </div>
      </div>
    </div>
"@
}) -join "`n"

$productsPageHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customized Print Products | Shop T-Shirts, Mugs, Bags & More Online | Ganesha Enterprises</title>
  <meta name="description" content="Browse 90+ custom printed products including business cards, custom apparel, mugs, promotional drinkware, acrylic signage, packaging boxes, and executive gifts.">
  <link rel="icon" type="image/svg+xml" href="assets/imgs/logo/favicon.svg">
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
$navHtml
  <header class="header-sticky">
    <div class="container">
      <nav class="navbar">
        <a href="index.html" class="brand-logo"><img src="assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" width="180" height="46"></a>
        <div class="nav-menu">
          <a href="index.html" class="nav-link">Home</a>
          <a href="about.html" class="nav-link">About Us</a>
          <a href="services.html" class="nav-link">Services</a>
          <a href="products.html" class="nav-link active">Products</a>
          <a href="portfolio.html" class="nav-link">Portfolio</a>
          <a href="blog.html" class="nav-link">Blogs</a>
          <a href="contact.html" class="nav-link">Contact</a>
        </div>
        <div class="nav-actions">
          <a href="contact.html" class="btn btn-primary" data-open-quote><i class="fa-solid fa-paper-plane"></i> <span>Get A Quote</span></a>
          <button id="mobileToggle" class="mobile-toggle"><i class="fa-solid fa-bars"></i></button>
        </div>
      </nav>
    </div>
  </header>

  <div id="mobileDrawer" class="mobile-drawer">
    <div class="drawer-header">
      <img src="assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" height="38">
      <button id="drawerClose" class="drawer-close"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <div class="drawer-nav">
      <a href="index.html" class="drawer-link">Home</a>
      <a href="about.html" class="drawer-link">About Us</a>
      <a href="services.html" class="drawer-link">Services</a>
      <a href="products.html" class="drawer-link">Products (90+ Items)</a>
      <a href="portfolio.html" class="drawer-link">Portfolio & Clients</a>
      <a href="blog.html" class="drawer-link">Blog & News</a>
      <a href="contact.html" class="drawer-link">Contact Us</a>
    </div>
  </div>
  <div id="mobileOverlay" class="mobile-overlay"></div>

  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="index.html">Home</a> <span>/</span> <span style="color:var(--color-accent);font-weight:600;">Products</span>
      </div>
      <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:20px;">
        <div>
          <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">Custom Print Products Catalog</h1>
          <p style="font-size:1.15rem;color:var(--color-text-muted);max-width:700px;margin-top:8px;">
            High-precision printing across 90+ product types with bespoke logo branding and bulk volume discounts.
          </p>
        </div>
        <a href="contact.html" class="btn btn-primary" data-open-quote><i class="fa-solid fa-file-invoice"></i> <span>Bulk Order Quote</span></a>
      </div>
    </div>
  </section>

  <section class="section bg-alt">
    <div class="container">
      <div style="background-color:#ffffff;border:1px solid var(--color-border);border-radius:var(--radius-xl);padding:24px;margin-bottom:36px;box-shadow:var(--shadow-sm);">
        <div style="display:flex;flex-direction:column;gap:20px;">
          <div style="position:relative;width:100%;">
            <i class="fa-solid fa-magnifying-glass" style="position:absolute;left:18px;top:50%;transform:translateY(-50%);color:var(--color-text-muted);font-size:1.1rem;"></i>
            <input type="text" id="productSearchInput" class="form-control" placeholder="Search by product name (e.g. visiting cards, polo t-shirt, mug, diary, standee...)" style="padding-left:48px;height:52px;font-size:1.05rem;">
          </div>
          <div class="filter-nav" style="margin-bottom:0;justify-content:flex-start;">
            <button class="filter-btn active" data-category="all">All Categories (90)</button>
            <button class="filter-btn" data-category="business-essentials">Business Essentials (38)</button>
            <button class="filter-btn" data-category="love-your-new-look">Clothing, Caps & Bags (7)</button>
            <button class="filter-btn" data-category="made-by-you">Made by You (15)</button>
            <button class="filter-btn" data-category="home-gifts">Home & Gifts (12)</button>
          </div>
        </div>
        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:16px;padding-top:16px;border-top:1px solid var(--color-border);font-size:0.9rem;color:var(--color-text-muted);">
          <span id="productCountDisplay">Showing 90 products</span>
          <span><i class="fa-solid fa-truck-fast" style="color:var(--color-accent);margin-right:6px;"></i> Delivery Across Delhi NCR & Nationwide</span>
        </div>
      </div>

      <div class="products-grid">
        $prodCards
      </div>
    </div>
  </section>

  <footer class="site-footer">
    <div class="container">
      <div class="footer-bottom">
        <div>&copy; 2026 Ganesha Enterprises. All rights reserved.</div>
        <div class="footer-bottom-links">
          <a href="privacy-policy.html">Privacy Policy</a>
          <a href="terms-and-conditions.html">Terms & Conditions</a>
          <a href="sitemap.xml">XML Sitemap</a>
        </div>
      </div>
    </div>
  </footer>

  <div id="quoteModal" class="modal-overlay">
    <div class="modal-box">
      <button id="modalClose" class="modal-close"><i class="fa-solid fa-xmark"></i></button>
      <div style="margin-bottom:24px;">
        <span class="section-eyebrow">Instant Quote</span>
        <h3 style="font-size:1.6rem;margin-top:4px;">Request A Fast Custom Quote</h3>
        <p style="color:var(--color-text-muted);font-size:0.95rem;">Tell us what you need and our printing specialists will prepare tailored pricing immediately.</p>
      </div>
      <form data-ajax-form>
        <div class="form-grid">
          <div class="form-group-full">
            <label class="form-label">Product / Requirement</label>
            <input type="text" name="requirement" id="modalRequirementInput" class="form-control" placeholder="e.g. Standard Visiting Cards" required>
          </div>
          <div><label class="form-label">Full Name *</label><input type="text" name="name" class="form-control" required></div>
          <div><label class="form-label">Phone *</label><input type="tel" name="phone" class="form-control" required></div>
          <div class="form-group-full"><label class="form-label">Email</label><input type="email" name="email" class="form-control"></div>
          <div class="form-group-full"><label class="form-label">Quantity & Specs</label><textarea name="message" class="form-control" placeholder="Quantity, paper stock, delivery location..."></textarea></div>
          <div class="form-group-full"><button type="submit" class="btn btn-primary" style="width:100%;"><i class="fa-solid fa-paper-plane"></i> <span>Send Inquiry to Specialist</span></button></div>
        </div>
      </form>
    </div>
  </div>
  <script src="js/main.js"></script>
</body>
</html>
"@
Set-Content -Path "products.html" -Value $productsPageHtml -Encoding UTF8
Write-Host "Generated products.html with 90 products!"

# Portfolio Page
$portCards = ($portfolio | ForEach-Object {
    @"
    <div class="portfolio-card">
      <div class="portfolio-img-wrap"><img src="$($_.image)" alt="$($_.title)" loading="lazy"></div>
      <div class="portfolio-info">
        <span class="portfolio-tag">$($_.category)</span>
        <h3 class="portfolio-title">$($_.title)</h3>
        <div class="portfolio-client"><i class="fa-solid fa-building" style="color:var(--color-accent);margin-right:6px;"></i> Client: $($_.client)</div>
      </div>
    </div>
"@
}) -join "`n"

$portfolioPageHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Our Work | Print Portfolio of Ganesha Enterprises – Delhi NCR</title>
  <meta name="description" content="View our portfolio featuring print projects for top brands across Delhi NCR and beyond. From promotional material to branded merchandise - our work speaks for itself.">
  <link rel="icon" type="image/svg+xml" href="assets/imgs/logo/favicon.svg">
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
$navHtml
  <header class="header-sticky">
    <div class="container">
      <nav class="navbar">
        <a href="index.html" class="brand-logo"><img src="assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" width="180" height="46"></a>
        <div class="nav-menu">
          <a href="index.html" class="nav-link">Home</a>
          <a href="about.html" class="nav-link">About Us</a>
          <a href="services.html" class="nav-link">Services</a>
          <a href="products.html" class="nav-link">Products</a>
          <a href="portfolio.html" class="nav-link active">Portfolio</a>
          <a href="blog.html" class="nav-link">Blogs</a>
          <a href="contact.html" class="nav-link">Contact</a>
        </div>
        <div class="nav-actions">
          <a href="contact.html" class="btn btn-primary" data-open-quote><i class="fa-solid fa-paper-plane"></i> <span>Get A Quote</span></a>
          <button id="mobileToggle" class="mobile-toggle"><i class="fa-solid fa-bars"></i></button>
        </div>
      </nav>
    </div>
  </header>

  <div id="mobileDrawer" class="mobile-drawer">
    <div class="drawer-header">
      <img src="assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" height="38">
      <button id="drawerClose" class="drawer-close"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <div class="drawer-nav">
      <a href="index.html" class="drawer-link">Home</a>
      <a href="about.html" class="drawer-link">About Us</a>
      <a href="services.html" class="drawer-link">Services</a>
      <a href="products.html" class="drawer-link">Products</a>
      <a href="portfolio.html" class="drawer-link">Portfolio & Clients</a>
      <a href="blog.html" class="drawer-link">Blog & News</a>
      <a href="contact.html" class="drawer-link">Contact Us</a>
    </div>
  </div>
  <div id="mobileOverlay" class="mobile-overlay"></div>

  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="index.html">Home</a> <span>/</span> <span style="color:var(--color-accent);font-weight:600;">Portfolio</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">Our Print & Gifting Portfolio</h1>
      <p style="font-size:1.15rem;color:var(--color-text-muted);max-width:700px;margin-top:8px;">
        View our portfolio featuring print projects for top brands across Delhi NCR and beyond. From promotional material to branded merchandise — our work speaks for itself.
      </p>
    </div>
  </section>

  <section class="section bg-alt">
    <div class="container">
      <div class="portfolio-grid">
        $portCards
      </div>
    </div>
  </section>

  <section class="trust-section">
    <div class="container">
      <div class="trust-title">Trusted by Over 1,000+ Global & Local Brands</div>
      <div class="clients-grid">
        <div class="client-logo-item"><img src="assets/imgs/Our Clients/Vistara_Logo.png" alt="Vistara"></div>
        <div class="client-logo-item"><img src="assets/imgs/Our Clients/SIG_Holding_logo.png" alt="SIG Holding"></div>
        <div class="client-logo-item"><img src="assets/imgs/Our Clients/Radisson_logo.png" alt="Radisson"></div>
        <div class="client-logo-item"><img src="assets/imgs/Our Clients/Netcracker_Technology_logo.png" alt="Netcracker"></div>
        <div class="client-logo-item"><img src="assets/imgs/Our Clients/National_Thermal_Power_logo.png" alt="NTPC"></div>
        <div class="client-logo-item"><img src="assets/imgs/Our Clients/Khan_Academy_logo.png" alt="Khan Academy"></div>
        <div class="client-logo-item"><img src="assets/imgs/Our Clients/Awfis_new_logo.png" alt="Awfis"></div>
        <div class="client-logo-item"><img src="assets/imgs/Our Clients/air_india_new_logo.png" alt="Air India"></div>
        <div class="client-logo-item"><img src="assets/imgs/Our Clients/Air_India_Express-Logo.png" alt="Air India Express"></div>
      </div>
    </div>
  </section>

  <footer class="site-footer">
    <div class="container">
      <div class="footer-bottom">
        <div>&copy; 2026 Ganesha Enterprises. All rights reserved.</div>
        <div class="footer-bottom-links">
          <a href="privacy-policy.html">Privacy Policy</a>
          <a href="terms-and-conditions.html">Terms & Conditions</a>
          <a href="sitemap.xml">XML Sitemap</a>
        </div>
      </div>
    </div>
  </footer>
  <script src="js/main.js"></script>
</body>
</html>
"@
Set-Content -Path "portfolio.html" -Value $portfolioPageHtml -Encoding UTF8
Write-Host "Generated portfolio.html!"

# Blog Hub Page
$blogCards = ($blogs | ForEach-Object {
    $link = if ($_.id -eq "why-custom-printing-is-the-secret-weapon-of-modern-branding") { "blog/why-custom-printing-is-the-secret-weapon.html" } elseif ($_.id -eq "t-shirts-to-tumblers-top-10-custom-products") { "blog/t-shirts-to-tumblers-top-10-custom-products.html" } else { "#" }
    @"
    <article class="blog-card">
      <div class="blog-card-img"><img src="$($_.image)" alt="$($_.title)" loading="lazy"></div>
      <div class="blog-card-body">
        <div class="blog-meta">
          <span><i class="fa-regular fa-calendar" style="color:var(--color-accent);margin-right:4px;"></i> $($_.date)</span>
          <span>•</span>
          <span><i class="fa-regular fa-user" style="color:var(--color-accent);margin-right:4px;"></i> $($_.author)</span>
        </div>
        <h2 class="blog-card-title"><a href="$link">$($_.title)</a></h2>
        <p class="blog-card-excerpt">$($_.summary)</p>
        <div class="blog-card-footer">
          $(if ($link -ne "#") { "<a href='$link' style='color:var(--color-accent);font-weight:700;display:inline-flex;align-items:center;gap:6px;'><span>Read Full Article</span> <i class='fa-solid fa-arrow-right'></i></a>" } else { "<span style='color:var(--color-text-muted);font-size:0.85rem;font-weight:600;'><i class='fa-solid fa-newspaper' style='color:var(--color-accent);margin-right:4px;'></i> Full Article Preserved in Inventory</span>" })
        </div>
      </div>
    </article>
"@
}) -join "`n"

$blogHubHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Printing Tips, Branding Ideas & Industry Trends | Ganesha Blog</title>
  <meta name="description" content="Stay ahead with expert articles on modern branding, merchandise trends, eco-friendly printing materials, and packaging strategies from Ganesha Enterprises.">
  <link rel="icon" type="image/svg+xml" href="assets/imgs/logo/favicon.svg">
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
$navHtml
  <header class="header-sticky">
    <div class="container">
      <nav class="navbar">
        <a href="index.html" class="brand-logo"><img src="assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" width="180" height="46"></a>
        <div class="nav-menu">
          <a href="index.html" class="nav-link">Home</a>
          <a href="about.html" class="nav-link">About Us</a>
          <a href="services.html" class="nav-link">Services</a>
          <a href="products.html" class="nav-link">Products</a>
          <a href="portfolio.html" class="nav-link">Portfolio</a>
          <a href="blog.html" class="nav-link active">Blogs</a>
          <a href="contact.html" class="nav-link">Contact</a>
        </div>
        <div class="nav-actions">
          <a href="contact.html" class="btn btn-primary" data-open-quote><i class="fa-solid fa-paper-plane"></i> <span>Get A Quote</span></a>
          <button id="mobileToggle" class="mobile-toggle"><i class="fa-solid fa-bars"></i></button>
        </div>
      </nav>
    </div>
  </header>

  <div id="mobileDrawer" class="mobile-drawer">
    <div class="drawer-header">
      <img src="assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" height="38">
      <button id="drawerClose" class="drawer-close"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <div class="drawer-nav">
      <a href="index.html" class="drawer-link">Home</a>
      <a href="about.html" class="drawer-link">About Us</a>
      <a href="services.html" class="drawer-link">Services</a>
      <a href="products.html" class="drawer-link">Products</a>
      <a href="portfolio.html" class="drawer-link">Portfolio & Clients</a>
      <a href="blog.html" class="drawer-link">Blog & News</a>
      <a href="contact.html" class="drawer-link">Contact Us</a>
    </div>
  </div>
  <div id="mobileOverlay" class="mobile-overlay"></div>

  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="index.html">Home</a> <span>/</span> <span style="color:var(--color-accent);font-weight:600;">Blog</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">Printing Tips & Industry Insights</h1>
      <p style="font-size:1.15rem;color:var(--color-text-muted);max-width:700px;margin-top:8px;">
        Discover how thoughtful design, custom physical touchpoints, and sustainable materials build unforgettable brand equity.
      </p>
    </div>
  </section>

  <section class="section bg-alt">
    <div class="container">
      <div class="blogs-grid">
        $blogCards
      </div>
    </div>
  </section>

  <footer class="site-footer">
    <div class="container">
      <div class="footer-bottom">
        <div>&copy; 2026 Ganesha Enterprises. All rights reserved.</div>
        <div class="footer-bottom-links">
          <a href="privacy-policy.html">Privacy Policy</a>
          <a href="terms-and-conditions.html">Terms & Conditions</a>
          <a href="sitemap.xml">XML Sitemap</a>
        </div>
      </div>
    </div>
  </footer>
  <script src="js/main.js"></script>
</body>
</html>
"@
Set-Content -Path "blog.html" -Value $blogHubHtml -Encoding UTF8
Write-Host "Generated blog.html!"
