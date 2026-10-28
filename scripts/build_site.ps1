Add-Type -AssemblyName System.Web

$site = Get-Content "content/site-settings.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$homeData = Get-Content "content/pages/home.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$about = Get-Content "content/pages/about.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$contact = Get-Content "content/pages/contact.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$services = Get-Content "content/services/services.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$products = Get-Content "content/products/products.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$blogs = Get-Content "content/blogs/blogs.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$faqs = Get-Content "content/faqs/faqs.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$portfolio = Get-Content "content/portfolio/portfolio.json" -Raw -Encoding UTF8 | ConvertFrom-Json

function Get-Head($title, $desc, $depth = 0) {
    $prefix = if ($depth -eq 1) { "../" } else { "" }
    return @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$title</title>
  <meta name="description" content="$desc">
  <meta name="keywords" content="$($site.metaKeywords)">
  <link rel="canonical" href="https://ganeshaenterprises.in/">
  <link rel="icon" type="image/svg+xml" href="${prefix}assets/imgs/logo/favicon.svg">
  <!-- Open Graph -->
  <meta property="og:title" content="$title">
  <meta property="og:description" content="$desc">
  <meta property="og:type" content="website">
  <meta property="og:image" content="${prefix}assets/imgs/feature-5/Welcome_Kit.jpg">
  <!-- Stylesheets -->
  <link rel="stylesheet" href="${prefix}css/style.css">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
"@
}

function Get-TopBar($depth = 0) {
    return @"
  <!-- Top Bar -->
  <aside class="top-bar">
    <div class="container">
      <div class="top-bar-inner">
        <div class="top-bar-left">
          <a href="tel:$($site.contact.phoneRaw)" class="top-bar-item">
            <i class="fa-solid fa-phone"></i>
            <span>$($site.contact.phone)</span>
          </a>
          <a href="mailto:$($site.contact.email)" class="top-bar-item">
            <i class="fa-solid fa-envelope"></i>
            <span>$($site.contact.email)</span>
          </a>
          <span class="top-bar-item">
            <i class="fa-solid fa-location-dot"></i>
            <span>Naraina Industrial Area Phase 1, New Delhi</span>
          </span>
        </div>
        <div class="top-bar-right">
          <a href="$($site.socialLinks.whatsapp)" target="_blank" rel="noopener" class="top-bar-item" style="color:#25d366;font-weight:600;">
            <i class="fa-brands fa-whatsapp"></i>
            <span>WhatsApp Us</span>
          </a>
          <a href="$($site.socialLinks.instagram)" target="_blank" rel="noopener" class="top-bar-item">
            <i class="fa-brands fa-instagram"></i>
          </a>
          <a href="$($site.socialLinks.facebook)" target="_blank" rel="noopener" class="top-bar-item">
            <i class="fa-brands fa-facebook-f"></i>
          </a>
        </div>
      </div>
    </div>
  </aside>
"@
}

function Get-Header($activePage, $depth = 0) {
    $prefix = if ($depth -eq 1) { "../" } else { "" }
    return @"
  <!-- Main Header -->
  <header class="header-sticky">
    <div class="container">
      <nav class="navbar">
        <a href="${prefix}index.html" class="brand-logo" aria-label="Ganesha Enterprises Home">
          <img src="${prefix}assets/imgs/logo/logo.svg" alt="Ganesha Enterprises Logo" width="180" height="46">
        </a>

        <div class="nav-menu">
          <a href="${prefix}index.html" class="nav-link $(if ($activePage -eq 'home') { 'active' })">Home</a>
          <a href="${prefix}about.html" class="nav-link $(if ($activePage -eq 'about') { 'active' })">About Us</a>
          
          <div class="has-dropdown">
            <a href="${prefix}services.html" class="nav-link $(if ($activePage -eq 'services') { 'active' })">
              <span>Services</span>
              <i class="fa-solid fa-chevron-down" style="font-size: 11px;"></i>
            </a>
            <div class="dropdown-menu">
              <a href="${prefix}services/corporate-office-printing.html" class="dropdown-item"><i class="fa-solid fa-briefcase"></i> Corporate & Office Printing</a>
              <a href="${prefix}services/marketing-promotional-printing.html" class="dropdown-item"><i class="fa-solid fa-bullhorn"></i> Marketing & Promotional</a>
              <a href="${prefix}services/customized-merchandise.html" class="dropdown-item"><i class="fa-solid fa-shirt"></i> Customized Merchandise</a>
              <a href="${prefix}services/packaging-labels.html" class="dropdown-item"><i class="fa-solid fa-box-open"></i> Packaging & Labels</a>
              <a href="${prefix}services/large-format-event-printing.html" class="dropdown-item"><i class="fa-solid fa-panorama"></i> Large Format & Event</a>
              <a href="${prefix}services/books-photo-products.html" class="dropdown-item"><i class="fa-solid fa-book-open"></i> Books & Photo Products</a>
              <a href="${prefix}services/premium-finishing.html" class="dropdown-item"><i class="fa-solid fa-gem"></i> Premium Finishing</a>
              <a href="${prefix}services/digital-personalized-printing.html" class="dropdown-item"><i class="fa-solid fa-fingerprint"></i> Digital & Personalized</a>
            </div>
          </div>

          <div class="has-dropdown">
            <a href="${prefix}products.html" class="nav-link $(if ($activePage -eq 'products') { 'active' })">
              <span>Products</span>
              <i class="fa-solid fa-chevron-down" style="font-size: 11px;"></i>
            </a>
            <div class="dropdown-menu">
              <a href="${prefix}products.html" class="dropdown-item"><i class="fa-solid fa-table-cells"></i> All Products (90+)</a>
              <a href="${prefix}products.html?category=business-essentials" class="dropdown-item"><i class="fa-solid fa-id-card"></i> Business Essentials</a>
              <a href="${prefix}products.html?category=love-your-new-look" class="dropdown-item"><i class="fa-solid fa-shirt"></i> Clothing, Caps & Bags</a>
              <a href="${prefix}products.html?category=made-by-you" class="dropdown-item"><i class="fa-solid fa-palette"></i> Made by You</a>
              <a href="${prefix}products.html?category=home-gifts" class="dropdown-item"><i class="fa-solid fa-mug-hot"></i> Home & Gifts</a>
            </div>
          </div>

          <a href="${prefix}portfolio.html" class="nav-link $(if ($activePage -eq 'portfolio') { 'active' })">Portfolio</a>
          <a href="${prefix}blog.html" class="nav-link $(if ($activePage -eq 'blog') { 'active' })">Blogs</a>
          <a href="${prefix}contact.html" class="nav-link $(if ($activePage -eq 'contact') { 'active' })">Contact</a>
        </div>

        <div class="nav-actions">
          <a href="${prefix}contact.html" class="btn btn-primary" data-open-quote>
            <i class="fa-solid fa-paper-plane"></i>
            <span>Get A Quote</span>
          </a>
          <button id="mobileToggle" class="mobile-toggle" aria-label="Open Navigation Menu">
            <i class="fa-solid fa-bars"></i>
          </button>
        </div>
      </nav>
    </div>
  </header>

  <!-- Mobile Drawer -->
  <div id="mobileDrawer" class="mobile-drawer">
    <div class="drawer-header">
      <img src="${prefix}assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" height="38">
      <button id="drawerClose" class="drawer-close" aria-label="Close Navigation Menu"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <div class="drawer-nav">
      <a href="${prefix}index.html" class="drawer-link">Home</a>
      <a href="${prefix}about.html" class="drawer-link">About Us</a>
      <a href="${prefix}services.html" class="drawer-link">Services</a>
      <div class="drawer-sublinks">
        <a href="${prefix}services/corporate-office-printing.html" class="drawer-sublink">• Corporate & Office</a>
        <a href="${prefix}services/marketing-promotional-printing.html" class="drawer-sublink">• Marketing & Promotional</a>
        <a href="${prefix}services/customized-merchandise.html" class="drawer-sublink">• Customized Merchandise</a>
        <a href="${prefix}services/packaging-labels.html" class="drawer-sublink">• Packaging & Labels</a>
        <a href="${prefix}services/large-format-event-printing.html" class="drawer-sublink">• Large Format & Event</a>
        <a href="${prefix}services/books-photo-products.html" class="drawer-sublink">• Books & Photo Products</a>
        <a href="${prefix}services/premium-finishing.html" class="drawer-sublink">• Premium Finishing</a>
        <a href="${prefix}services/digital-personalized-printing.html" class="drawer-sublink">• Digital & Personalized</a>
      </div>
      <a href="${prefix}products.html" class="drawer-link">Products (90+ Items)</a>
      <div class="drawer-sublinks">
        <a href="${prefix}products.html?category=business-essentials" class="drawer-sublink">• Business Essentials</a>
        <a href="${prefix}products.html?category=love-your-new-look" class="drawer-sublink">• Clothing, Caps & Bags</a>
        <a href="${prefix}products.html?category=made-by-you" class="drawer-sublink">• Made by You</a>
        <a href="${prefix}products.html?category=home-gifts" class="drawer-sublink">• Home & Gifts</a>
      </div>
      <a href="${prefix}portfolio.html" class="drawer-link">Portfolio & Clients</a>
      <a href="${prefix}blog.html" class="drawer-link">Blog & News</a>
      <a href="${prefix}contact.html" class="drawer-link">Contact Us</a>
      <div style="margin-top:20px;">
        <a href="${prefix}contact.html" class="btn btn-primary" style="width:100%;" data-open-quote>Request A Quote</a>
      </div>
    </div>
  </div>
  <div id="mobileOverlay" class="mobile-overlay"></div>
"@
}

function Get-Footer($depth = 0) {
    $prefix = if ($depth -eq 1) { "../" } else { "" }
    return @"
  <!-- Emergency Rush Order CTA -->
  <section class="section-sm bg-white" style="border-top: 1px solid var(--color-border);">
    <div class="container">
      <div class="emergency-banner">
        <div class="emergency-content">
          <div style="display:flex;align-items:center;gap:8px;margin-bottom:8px;">
            <i class="fa-solid fa-bolt" style="color:var(--color-accent);font-size:1.2rem;"></i>
            <span style="text-transform:uppercase;font-weight:700;letter-spacing:0.08em;font-size:0.85rem;color:var(--color-accent);">Express Service</span>
          </div>
          <h3>Do you have an emergency design or printing service?</h3>
          <p>Need same-day rush printing or urgent corporate gift kits for an upcoming exhibition or launch? Our team in Naraina Industrial Area is ready to deliver.</p>
        </div>
        <div class="emergency-actions">
          <a href="tel:$($site.contact.phoneRaw)" class="btn btn-primary btn-lg">
            <i class="fa-solid fa-phone"></i>
            <span>Call +91-9650044234</span>
          </a>
          <a href="$($site.socialLinks.whatsapp)" target="_blank" rel="noopener" class="btn btn-secondary btn-lg">
            <i class="fa-brands fa-whatsapp" style="color:#25d366;"></i>
            <span>WhatsApp Us</span>
          </a>
        </div>
      </div>
    </div>
  </section>

  <!-- Site Footer -->
  <footer class="site-footer">
    <div class="container">
      <div class="footer-grid">
        <div class="footer-brand">
          <img src="${prefix}assets/imgs/logo/logo.svg" alt="Ganesha Enterprises" height="42" style="filter: brightness(0) invert(1);">
          <p>Premier digital printing, offset printing, corporate gifting, customized merchandise, packaging, and branding solutions in Delhi NCR. Trusted by 1,000+ top brands.</p>
          <div class="social-links-bar">
            <a href="$($site.socialLinks.instagram)" target="_blank" rel="noopener" class="social-icon-btn" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
            <a href="$($site.socialLinks.facebook)" target="_blank" rel="noopener" class="social-icon-btn" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
            <a href="$($site.socialLinks.whatsapp)" target="_blank" rel="noopener" class="social-icon-btn" aria-label="WhatsApp"><i class="fa-brands fa-whatsapp"></i></a>
            <a href="mailto:$($site.contact.email)" class="social-icon-btn" aria-label="Email"><i class="fa-solid fa-envelope"></i></a>
          </div>
        </div>

        <div>
          <h4 class="footer-widget-title">Quick Links</h4>
          <div class="footer-links">
            <a href="${prefix}index.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Home</a>
            <a href="${prefix}about.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> About Ganesha Enterprises</a>
            <a href="${prefix}services.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> All Printing Services</a>
            <a href="${prefix}products.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Product Catalog (90+)</a>
            <a href="${prefix}portfolio.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Recent Portfolio & Clients</a>
            <a href="${prefix}blog.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Printing Insights & Blog</a>
            <a href="${prefix}contact.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Contact & Get Quote</a>
          </div>
        </div>

        <div>
          <h4 class="footer-widget-title">Core Services</h4>
          <div class="footer-links">
            <a href="${prefix}services/corporate-office-printing.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Corporate Stationery</a>
            <a href="${prefix}services/marketing-promotional-printing.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Marketing Collateral</a>
            <a href="${prefix}services/customized-merchandise.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Customized Merchandise</a>
            <a href="${prefix}services/packaging-labels.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Packaging & Labels</a>
            <a href="${prefix}services/large-format-event-printing.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Large Format & Event</a>
            <a href="${prefix}services/books-photo-products.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Books & Photo Products</a>
            <a href="${prefix}services/premium-finishing.html" class="footer-link"><i class="fa-solid fa-angle-right"></i> Luxury UV & Foil Finishing</a>
          </div>
        </div>

        <div>
          <h4 class="footer-widget-title">Studio Location</h4>
          <p style="font-size:0.92rem;color:var(--color-text-light);line-height:1.6;margin-bottom:16px;">
            <i class="fa-solid fa-location-dot" style="color:var(--color-accent);margin-right:6px;"></i>
            $($site.contact.address)
          </p>
          <p style="font-size:0.92rem;color:var(--color-text-light);line-height:1.6;margin-bottom:16px;">
            <i class="fa-solid fa-phone" style="color:var(--color-accent);margin-right:6px;"></i>
            <a href="tel:$($site.contact.phoneRaw)" style="color:#ffffff;">$($site.contact.phone)</a>
          </p>
          <p style="font-size:0.92rem;color:var(--color-text-light);line-height:1.6;margin-bottom:20px;">
            <i class="fa-solid fa-envelope" style="color:var(--color-accent);margin-right:6px;"></i>
            <a href="mailto:$($site.contact.email)" style="color:#ffffff;">$($site.contact.email)</a>
          </p>
          <a href="$($site.contact.googleMapsUrl)" target="_blank" rel="noopener" class="btn btn-outline btn-sm">
            <i class="fa-solid fa-map-location-dot"></i> View on Google Maps
          </a>
        </div>
      </div>

      <div class="footer-bottom">
        <div>
          &copy; $(Get-Date -Format yyyy) Ganesha Enterprises. All rights reserved.
        </div>
        <div class="footer-bottom-links">
          <a href="${prefix}privacy-policy.html">Privacy Policy</a>
          <a href="${prefix}terms-and-conditions.html">Terms & Conditions</a>
          <a href="${prefix}sitemap.xml">XML Sitemap</a>
        </div>
      </div>
    </div>
  </footer>

  <!-- Quote Request Modal -->
  <div id="quoteModal" class="modal-overlay">
    <div class="modal-box">
      <button id="modalClose" class="modal-close" aria-label="Close Quote Modal"><i class="fa-solid fa-xmark"></i></button>
      <div style="margin-bottom:24px;">
        <span class="section-eyebrow">Instant Quote</span>
        <h3 style="font-size:1.6rem;margin-top:4px;">Request A Fast Custom Quote</h3>
        <p style="color:var(--color-text-muted);font-size:0.95rem;">Tell us what you need and our printing specialists will prepare tailored pricing immediately.</p>
      </div>

      <form data-ajax-form>
        <div class="form-grid">
          <div class="form-group-full">
            <label class="form-label">Product / Service Requirement</label>
            <input type="text" name="requirement" id="modalRequirementInput" class="form-control" placeholder="e.g. Standard Visiting Cards / Employee Welcome Kits" required>
          </div>
          <div>
            <label class="form-label">Full Name *</label>
            <input type="text" name="name" class="form-control" placeholder="Your name" required>
          </div>
          <div>
            <label class="form-label">Phone / WhatsApp Number *</label>
            <input type="tel" name="phone" class="form-control" placeholder="+91 98765 43210" required>
          </div>
          <div class="form-group-full">
            <label class="form-label">Email Address</label>
            <input type="email" name="email" class="form-control" placeholder="name@company.com">
          </div>
          <div class="form-group-full">
            <label class="form-label">Quantity & Specifications</label>
            <textarea name="message" class="form-control" placeholder="Estimated quantity, dimensions, paper thickness, or delivery deadline..."></textarea>
          </div>
          <div class="form-group-full">
            <button type="submit" class="btn btn-primary" style="width:100%;">
              <i class="fa-solid fa-paper-plane"></i>
              <span>Send Inquiry to Specialist</span>
            </button>
            <p style="font-size:0.8rem;color:var(--color-text-muted);margin-top:10px;text-align:center;">
              <i class="fa-solid fa-shield-halved"></i> Your information is safe and directly routed to our studio specialists.
            </p>
          </div>
        </div>
      </form>
    </div>
  </div>

  <!-- Scripts -->
  <script src="${prefix}js/main.js"></script>
</body>
</html>
"@
}

# --------------------------------------------------------------------------
# BUILD 1: index.html
# --------------------------------------------------------------------------
Write-Host "Building index.html..."
$indexHtml = Get-Head -title $homeData.title -desc $homeData.metaDescription -depth 0
$indexHtml += Get-TopBar -depth 0
$indexHtml += Get-Header -activePage "home" -depth 0

$indexHtml += @"
  <!-- Hero Section -->
  <section class="hero-section">
    <!-- Seamless Looping Video Background Layer -->
    <div class="hero-video-wrap" aria-hidden="true">
      <video class="hero-video" autoplay muted loop playsinline preload="auto">
        <source src="assets/videos/hero-background.mp4" type="video/mp4">
        <source src="public/videos/hero-background.mp4" type="video/mp4">
      </video>
      <div class="hero-video-overlay"></div>
    </div>

    <div class="container">
      <div class="hero-grid">
        <div class="hero-content">
          <div class="hero-badges">
            <span class="section-eyebrow">
              <i class="fa-solid fa-crown"></i>
              <span>$($homeData.hero.eyebrow)</span>
            </span>
            <span style="font-size:0.85rem;font-weight:700;color:var(--color-primary);background:#f1f5f9;padding:6px 12px;border-radius:var(--radius-full);">
              <i class="fa-solid fa-award" style="color:var(--color-accent);margin-right:4px;"></i> 25+ Years Legacy
            </span>
          </div>

          <h1 class="hero-title">
            Product Design & <span class="text-gradient">Custom Printing</span> Solutions
          </h1>

          <p class="hero-lead">
            $($homeData.hero.description)
          </p>

          <div class="hero-cta-group">
            <a href="products.html" class="btn btn-primary btn-lg">
              <i class="fa-solid fa-boxes-stacked"></i>
              <span>Explore Products (90+)</span>
            </a>
            <a href="contact.html" class="btn btn-secondary btn-lg" data-open-quote>
              <i class="fa-solid fa-calculator"></i>
              <span>Get A Custom Quote</span>
            </a>
          </div>

          <div class="hero-features-list">
            <div class="hero-feature-item">
              <i class="fa-solid fa-circle-check" style="color:var(--color-accent);"></i>
              <span>Customizable for Any Brand</span>
            </div>
            <div class="hero-feature-item">
              <i class="fa-solid fa-circle-check" style="color:var(--color-accent);"></i>
              <span>Unmatched Print Quality</span>
            </div>
            <div class="hero-feature-item">
              <i class="fa-solid fa-circle-check" style="color:var(--color-accent);"></i>
              <span>Fast Turnaround Times</span>
            </div>
            <div class="hero-feature-item">
              <i class="fa-solid fa-circle-check" style="color:var(--color-accent);"></i>
              <span>On-Time, Every Time Delivery</span>
            </div>
          </div>
        </div>

        <div class="hero-visual">
          <div class="hero-card-stack">
            <img src="assets/imgs/feature-5/Welcome_Kit.jpg" alt="Premium Employee Welcome Kit by Ganesha Enterprises" class="hero-card-img" width="560" height="420">
            
            <div class="floating-badge floating-badge-1">
              <div class="floating-icon"><i class="fa-solid fa-building"></i></div>
              <div>
                <div class="floating-title">1,000+ Brands</div>
                <div class="floating-sub">Trusted Printing Partner</div>
              </div>
            </div>

            <div class="floating-badge floating-badge-2">
              <div class="floating-icon"><i class="fa-solid fa-gift"></i></div>
              <div>
                <div class="floating-title">Corporate Joining Kits</div>
                <div class="floating-sub">Custom Merch & Drinkware</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Client Logos & Trust Section -->
  <section class="trust-section">
    <div class="container">
      <div class="trust-title">Trusted by Over 1,000+ Global & Local Brands</div>
      <div class="clients-grid">
        $(($site.clients | ForEach-Object {
          "<div class='client-logo-item'><img src='$($_.logo)' alt='$($_.name)' loading='lazy'></div>"
        }) -join "`n")
      </div>

      <div class="stats-bar">
        <div class="stat-item">
          <div class="stat-number">25+</div>
          <div class="stat-label">Years of Experience in Printing</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">1,000+</div>
          <div class="stat-label">Global & Local Corporate Brands</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">90+</div>
          <div class="stat-label">Curated Print & Merchandise Products</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">100%</div>
          <div class="stat-label">Quality & Color Match Guarantee</div>
        </div>
      </div>
    </div>
  </section>

  <!-- 4 Pillars Section -->
  <section class="section bg-alt">
    <div class="container">
      <div class="text-center" style="margin-bottom: 48px;">
        <span class="section-eyebrow">Our Core Strengths</span>
        <h2 class="display-2 section-title">Premier One-Stop Custom Print Solutions</h2>
        <p class="section-subtitle mx-auto">From concept to finished product, we provide end-to-end printing, packaging, and corporate gifting that elevate your enterprise reputation.</p>
      </div>

      <div class="pillar-grid">
        $(($homeData.keySellingPoints | ForEach-Object {
          @"
          <div class="pillar-card">
            <div class="pillar-icon-wrap">
              <img src="$($_.icon)" alt="$($_.title)" loading="lazy">
            </div>
            <h3 class="pillar-title">$($_.title)</h3>
            <p class="pillar-desc">$($_.description)</p>
          </div>
"@
        }) -join "`n")
      </div>
    </div>
  </section>

  <!-- Featured Corporate Gifting & Best Sellers -->
  <section class="section bg-white">
    <div class="container">
      <div style="display:flex;justify-content:space-between;align-items:flex-end;margin-bottom:48px;flex-wrap:wrap;gap:20px;">
        <div>
          <span class="section-eyebrow">Featured Showcase</span>
          <h2 class="display-2 section-title">Bestselling Products & Joining Kits</h2>
          <p class="section-subtitle" style="margin-bottom:0;">Explore customer favorites engineered for brand impact and corporate gifting.</p>
        </div>
        <a href="products.html" class="btn btn-secondary">
          <span>View All 90+ Products</span>
          <i class="fa-solid fa-arrow-right"></i>
        </a>
      </div>

      <div class="products-grid">
        $(($homeData.featuredShowcase | ForEach-Object {
          @"
          <div class="product-card">
            <div class="product-thumb">
              <span class="product-badge">$($_.badge)</span>
              <img src="$($_.image)" alt="$($_.title)" loading="lazy">
            </div>
            <div class="product-content">
              <div class="product-category">$($_.category)</div>
              <h3 class="product-title">$($_.title)</h3>
              <p class="product-desc">Premium quality custom branded solution with bespoke finishing options.</p>
              <div class="product-footer">
                <div class="rating-stars">
                  <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                </div>
                <button class="btn btn-primary btn-sm" data-open-quote data-product-name="$($_.title)">
                  Inquire Now
                </button>
              </div>
            </div>
          </div>
"@
        }) -join "`n")
      </div>
    </div>
  </section>

  <!-- About Teaser Section -->
  <section class="section bg-alt">
    <div class="container">
      <div class="hero-grid" style="align-items:center;">
        <div>
          <div class="hero-card-stack">
            <img src="assets/imgs/About/marketing-strategy-planning-strategy-concept_53876-42950.jpg" alt="Printing Solutions at Ganesha Enterprises" class="hero-card-img" width="560" height="420" loading="lazy">
            <div class="floating-badge floating-badge-2" style="bottom:-15px;right:20px;">
              <div class="floating-icon"><i class="fa-solid fa-certificate"></i></div>
              <div>
                <div class="floating-title">25+ Years</div>
                <div class="floating-sub">Excellence in Print & Signage</div>
              </div>
            </div>
          </div>
        </div>

        <div>
          <span class="section-eyebrow">$($homeData.aboutTeaser.eyebrow)</span>
          <h2 class="display-2 section-title">$($homeData.aboutTeaser.heading)</h2>
          <p style="font-size:1.05rem;color:var(--color-text-muted);line-height:1.7;margin-bottom:16px;">
            $($homeData.aboutTeaser.p1)
          </p>
          <p style="font-size:1.05rem;color:var(--color-text-muted);line-height:1.7;margin-bottom:28px;">
            $($homeData.aboutTeaser.p2)
          </p>

          <div style="display:grid;grid-template-columns:repeat(auto-fit, minmax(240px, 1fr));gap:12px;margin-bottom:32px;">
            $(($homeData.aboutTeaser.highlights | ForEach-Object {
              @"
              <div style="display:flex;align-items:center;gap:10px;font-size:0.95rem;font-weight:600;color:var(--color-primary);">
                <i class="fa-solid fa-circle-check" style="color:var(--color-accent);flex-shrink:0;"></i>
                <span>$_</span>
              </div>
"@
            }) -join "`n")
          </div>

          <div style="display:flex;gap:16px;flex-wrap:wrap;">
            <a href="about.html" class="btn btn-primary">
              <span>Read Our Full Story</span>
              <i class="fa-solid fa-arrow-right"></i>
            </a>
            <a href="contact.html" class="btn btn-secondary">
              <i class="fa-solid fa-envelope"></i>
              <span>Get In Touch</span>
            </a>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Services Grid (8 Core Services) -->
  <section class="section bg-white">
    <div class="container">
      <div class="text-center" style="margin-bottom: 48px;">
        <span class="section-eyebrow">Our Specializations</span>
        <h2 class="display-2 section-title">Professional Digital Printing Services</h2>
        <p class="section-subtitle mx-auto">Engineered for commercial enterprises, marketing agencies, retail brands, and institutions across Delhi NCR and India.</p>
      </div>

      <div class="services-grid">
        $(($services | ForEach-Object {
          $idx = [array]::IndexOf($services, $_) + 1
          @"
          <div class="service-card">
            <div class="service-card-img-wrap">
              <img src="$($_.image)" alt="$($_.title)" class="service-card-img" loading="lazy">
              <span class="service-rank-badge">#$idx</span>
            </div>
            <div class="service-card-body">
              <h3 class="service-card-title">$($_.title)</h3>
              <p class="service-card-desc">$($_.description)</p>
              <a href="services/$($_.slug).html" class="service-card-link">
                <span>Explore Vertical</span>
                <i class="fa-solid fa-arrow-right"></i>
              </a>
            </div>
          </div>
"@
        }) -join "`n")
      </div>
    </div>
  </section>

  <!-- Signature Interactive Product Showcase (Apple-Inspired Motion) -->
  <section class="product-showcase-section" id="productShowcase" aria-labelledby="showcaseTitle">
    <div class="container">
      <div class="showcase-header">
        <div>
          <span class="section-eyebrow">Signature Craftsmanship</span>
          <h2 class="display-2 section-title" id="showcaseTitle">Real Brand Projects & Custom Production</h2>
          <p class="section-subtitle" style="margin-bottom: 0;">Explore authentic corporate gifting, apparel, packaging, and event merchandise crafted for industry leaders.</p>
        </div>
        <a href="portfolio.html" class="btn btn-secondary">
          <span>View Full Portfolio</span>
          <i class="fa-solid fa-arrow-right"></i>
        </a>
      </div>

      <div class="showcase-grid">
        <article class="showcase-tile" tabindex="0" role="button" aria-haspopup="dialog" aria-label="View details for Custom Embroidered Jute Tote Bag" data-index="0">
          <div class="showcase-tile-media">
            <img src="assets/imgs/Our Work/WhatsApp Image 2025-06-20 at 19.14.39.jpeg" alt="Custom Embroidered Jute Tote Bag" class="showcase-img" style="object-position: center center;" loading="lazy">
            <div class="showcase-overlay"></div>
          </div>
          <div class="showcase-content">
            <div class="showcase-meta">
              <span class="showcase-client-badge"><i class="fa-solid fa-gem"></i> Retail & Merchandise</span>
              <span class="showcase-category-tag">Custom Bags & Apparel</span>
            </div>
            <h3 class="showcase-title">Custom Embroidered Jute Tote Bag</h3>
          </div>
          <button class="showcase-plus-btn" aria-label="Open project details for Custom Embroidered Jute Tote Bag" tabindex="-1">
            <i class="fa-solid fa-plus"></i>
          </button>
        </article>

        <article class="showcase-tile" tabindex="0" role="button" aria-haspopup="dialog" aria-label="View details for Executive Vegan Leather Notebook & Pen Set" data-index="1">
          <div class="showcase-tile-media">
            <img src="assets/imgs/Our Work/WhatsApp Image 2025-06-20 at 19.16.24.jpeg" alt="Executive Vegan Leather Notebook & Pen Set" class="showcase-img" style="object-position: center 35%;" loading="lazy">
            <div class="showcase-overlay"></div>
          </div>
          <div class="showcase-content">
            <div class="showcase-meta">
              <span class="showcase-client-badge"><i class="fa-solid fa-building"></i> Vistara Airlines</span>
              <span class="showcase-category-tag">Corporate Stationery</span>
            </div>
            <h3 class="showcase-title">Executive Vegan Leather Notebook & Pen Set</h3>
          </div>
          <button class="showcase-plus-btn" aria-label="Open project details for Executive Vegan Leather Notebook & Pen Set" tabindex="-1">
            <i class="fa-solid fa-plus"></i>
          </button>
        </article>

        <article class="showcase-tile" tabindex="0" role="button" aria-haspopup="dialog" aria-label="View details for Branded Event Twill Baseball Cap" data-index="2">
          <div class="showcase-tile-media">
            <img src="assets/imgs/Our Work/WhatsApp Image 2025-06-20 at 19.18.36.jpeg" alt="Branded Event Twill Baseball Cap" class="showcase-img" style="object-position: center 25%;" loading="lazy">
            <div class="showcase-overlay"></div>
          </div>
          <div class="showcase-content">
            <div class="showcase-meta">
              <span class="showcase-client-badge"><i class="fa-solid fa-award"></i> NTPC</span>
              <span class="showcase-category-tag">Apparel & Headwear</span>
            </div>
            <h3 class="showcase-title">Branded Event Twill Baseball Cap</h3>
          </div>
          <button class="showcase-plus-btn" aria-label="Open project details for Branded Event Twill Baseball Cap" tabindex="-1">
            <i class="fa-solid fa-plus"></i>
          </button>
        </article>

        <article class="showcase-tile" tabindex="0" role="button" aria-haspopup="dialog" aria-label="View details for Matte Black Laser-Engraved Vacuum Flask" data-index="3">
          <div class="showcase-tile-media">
            <img src="assets/imgs/Our Work/WhatsApp Image 2025-06-26 at 11.24.22.jpeg" alt="Matte Black Laser-Engraved Vacuum Flask" class="showcase-img" style="object-position: center 35%;" loading="lazy">
            <div class="showcase-overlay"></div>
          </div>
          <div class="showcase-content">
            <div class="showcase-meta">
              <span class="showcase-client-badge"><i class="fa-solid fa-crown"></i> Sargam Steels</span>
              <span class="showcase-category-tag">Drinkware & Gifts</span>
            </div>
            <h3 class="showcase-title">Matte Black Laser-Engraved Vacuum Flask</h3>
          </div>
          <button class="showcase-plus-btn" aria-label="Open project details for Matte Black Laser-Engraved Vacuum Flask" tabindex="-1">
            <i class="fa-solid fa-plus"></i>
          </button>
        </article>

        <article class="showcase-tile" tabindex="0" role="button" aria-haspopup="dialog" aria-label="View details for Handcrafted Pine Wood Easel Desk Calendar" data-index="4">
          <div class="showcase-tile-media">
            <img src="assets/imgs/Our Work/WhatsApp Image 2025-06-26 at 11.24.20.jpeg" alt="Handcrafted Pine Wood Easel Desk Calendar" class="showcase-img" style="object-position: center center;" loading="lazy">
            <div class="showcase-overlay"></div>
          </div>
          <div class="showcase-content">
            <div class="showcase-meta">
              <span class="showcase-client-badge"><i class="fa-solid fa-hotel"></i> Trot Hotels</span>
              <span class="showcase-category-tag">Calendars & Desk Décor</span>
            </div>
            <h3 class="showcase-title">Handcrafted Pine Wood Easel Desk Calendar</h3>
          </div>
          <button class="showcase-plus-btn" aria-label="Open project details for Handcrafted Pine Wood Easel Desk Calendar" tabindex="-1">
            <i class="fa-solid fa-plus"></i>
          </button>
        </article>

        <article class="showcase-tile" tabindex="0" role="button" aria-haspopup="dialog" aria-label="View details for Air India #IamCPRReady Event Button Badges" data-index="5">
          <div class="showcase-tile-media">
            <img src="assets/imgs/Our Work/WhatsApp Image 2025-06-26 at 11.24.23.jpeg" alt="Air India #IamCPRReady Event Button Badges" class="showcase-img" style="object-position: center center;" loading="lazy">
            <div class="showcase-overlay"></div>
          </div>
          <div class="showcase-content">
            <div class="showcase-meta">
              <span class="showcase-client-badge"><i class="fa-solid fa-plane"></i> Air India</span>
              <span class="showcase-category-tag">Event Merchandise & Badges</span>
            </div>
            <h3 class="showcase-title">Air India #IamCPRReady Event Button Badges</h3>
          </div>
          <button class="showcase-plus-btn" aria-label="Open project details for Air India #IamCPRReady Event Button Badges" tabindex="-1">
            <i class="fa-solid fa-plus"></i>
          </button>
        </article>
      </div>
    </div>
  </section>

  <!-- Interactive Product Detail Modal / Lightbox -->
  <div id="showcaseModal" class="showcase-modal" role="dialog" aria-modal="true" aria-labelledby="showcaseModalTitle" aria-hidden="true">
    <div class="showcase-modal-backdrop"></div>
    <button class="showcase-modal-nav prev" aria-label="Previous project"><i class="fa-solid fa-chevron-left"></i></button>
    <button class="showcase-modal-nav next" aria-label="Next project"><i class="fa-solid fa-chevron-right"></i></button>
    
    <div class="showcase-modal-dialog">
      <button class="showcase-modal-close" aria-label="Close project modal"><i class="fa-solid fa-xmark"></i></button>
      
      <div class="showcase-modal-media">
        <img src="" alt="" class="showcase-modal-img">
        <div class="showcase-modal-media-overlay"></div>
      </div>

      <div class="showcase-modal-body">
        <div>
          <div class="showcase-modal-header-tags">
            <span class="showcase-modal-client"><i class="fa-solid fa-building"></i> <span>Client</span></span>
            <span class="showcase-modal-category">Category</span>
          </div>
          <h2 class="showcase-modal-title" id="showcaseModalTitle">Product Title</h2>
          <p class="showcase-modal-desc">Project craftsmanship details.</p>

          <div class="showcase-modal-specs">
            <div class="showcase-spec-item">
              <div class="showcase-spec-icon"><i class="fa-solid fa-layer-group"></i></div>
              <div>
                <span class="showcase-spec-label">Substrate / Material</span>
                <span class="showcase-spec-val" data-spec="substrate">Spec</span>
              </div>
            </div>
            <div class="showcase-spec-item">
              <div class="showcase-spec-icon"><i class="fa-solid fa-print"></i></div>
              <div>
                <span class="showcase-spec-label">Printing Technique</span>
                <span class="showcase-spec-val" data-spec="technique">Spec</span>
              </div>
            </div>
            <div class="showcase-spec-item">
              <div class="showcase-spec-icon"><i class="fa-solid fa-truck-fast"></i></div>
              <div>
                <span class="showcase-spec-label">Turnaround Time</span>
                <span class="showcase-spec-val" data-spec="turnaround">Spec</span>
              </div>
            </div>
            <div class="showcase-spec-item">
              <div class="showcase-spec-icon"><i class="fa-solid fa-boxes-stacked"></i></div>
              <div>
                <span class="showcase-spec-label">Minimum Order</span>
                <span class="showcase-spec-val" data-spec="minorder">Spec</span>
              </div>
            </div>
          </div>
        </div>

        <div class="showcase-modal-actions">
          <a href="#" target="_blank" rel="noopener" class="btn btn-primary showcase-modal-whatsapp" style="background:#25d366;border-color:#25d366;">
            <i class="fa-brands fa-whatsapp"></i>
            <span>Inquire on WhatsApp</span>
          </a>
          <button class="btn btn-outline" data-open-quote>
            <i class="fa-solid fa-envelope"></i>
            <span>Request Custom Quote</span>
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Recent Blog Articles -->
  <section class="section bg-white">
    <div class="container">
      <div style="display:flex;justify-content:space-between;align-items:flex-end;margin-bottom:48px;flex-wrap:wrap;gap:20px;">
        <div>
          <span class="section-eyebrow">Industry Insights</span>
          <h2 class="display-2 section-title">Read Our Latest Articles</h2>
          <p class="section-subtitle" style="margin-bottom:0;">Expert tips on corporate branding, custom merchandise, packaging design, and sustainability.</p>
        </div>
        <a href="blog.html" class="btn btn-secondary">
          <span>Explore All Articles</span>
          <i class="fa-solid fa-arrow-right"></i>
        </a>
      </div>

      <div class="blogs-grid">
        $(($blogs | Select-Object -First 3 | ForEach-Object {
          $link = if ($_.id -eq "why-custom-printing-is-the-secret-weapon-of-modern-branding") { "blog/why-custom-printing-is-the-secret-weapon.html" } elseif ($_.id -eq "t-shirts-to-tumblers-top-10-custom-products") { "blog/t-shirts-to-tumblers-top-10-custom-products.html" } else { "blog.html" }
          @"
          <article class="blog-card">
            <div class="blog-card-img">
              <img src="$($_.image)" alt="$($_.title)" loading="lazy">
            </div>
            <div class="blog-card-body">
              <div class="blog-meta">
                <span><i class="fa-regular fa-calendar" style="color:var(--color-accent);margin-right:4px;"></i> $($_.date)</span>
                <span>•</span>
                <span><i class="fa-regular fa-user" style="color:var(--color-accent);margin-right:4px;"></i> $($_.author)</span>
              </div>
              <h3 class="blog-card-title"><a href="$link">$($_.title)</a></h3>
              <p class="blog-card-excerpt">$($_.summary)</p>
              <div class="blog-card-footer">
                <a href="$link" style="color:var(--color-accent);font-weight:700;display:inline-flex;align-items:center;gap:6px;">
                  <span>Read Article</span>
                  <i class="fa-solid fa-arrow-right"></i>
                </a>
              </div>
            </div>
          </article>
"@
        }) -join "`n")
      </div>
    </div>
  </section>

  <!-- FAQ Section -->
  <section class="section bg-alt">
    <div class="container">
      <div class="text-center" style="margin-bottom:48px;">
        <span class="section-eyebrow">Have Any Questions?</span>
        <h2 class="display-2 section-title">Frequently Asked Questions</h2>
        <p class="section-subtitle mx-auto">Everything you need to know about placing orders, turnarounds, deliveries, and print finishes.</p>
      </div>

      <div class="faq-container">
        $(($faqs | ForEach-Object {
          @"
          <div class="faq-item">
            <button class="faq-question">
              <span>$($_.question)</span>
              <i class="fa-solid fa-chevron-down faq-icon"></i>
            </button>
            <div class="faq-answer">
              <p>$($_.answer)</p>
            </div>
          </div>
"@
        }) -join "`n")
      </div>
    </div>
  </section>
"@

$indexHtml += Get-Footer -depth 0
Set-Content -Path "index.html" -Value $indexHtml -Encoding UTF8
Write-Host "Built index.html successfully!"

# --------------------------------------------------------------------------
# BUILD 2: about.html
# --------------------------------------------------------------------------
Write-Host "Building about.html..."
$aboutHtml = Get-Head -title $about.title -desc $about.metaDescription -depth 0
$aboutHtml += Get-TopBar -depth 0
$aboutHtml += Get-Header -activePage "about" -depth 0

$aboutHtml += @"
  <!-- Breadcrumb / Header Area -->
  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="index.html" style="color:var(--color-text-muted);">Home</a>
        <span>/</span>
        <span style="color:var(--color-accent);font-weight:600;">About Us</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">$($about.heading)</h1>
      <p style="font-size:1.15rem;color:var(--color-text-muted);max-width:700px;margin-top:10px;">
        $($about.subheading) - Delivering unmatched print craftsmanship and corporate branding across India for over two decades.
      </p>
    </div>
  </section>

  <!-- About Story Section -->
  <section class="section bg-white">
    <div class="container">
      <div class="hero-grid" style="align-items:center;">
        <div>
          <span class="section-eyebrow">Our Legacy</span>
          <h2 class="display-2 section-title">$($about.subheading)</h2>
          <p style="font-size:1.05rem;color:var(--color-text-muted);line-height:1.8;margin-bottom:18px;">
            $($about.p1)
          </p>
          <p style="font-size:1.05rem;color:var(--color-text-muted);line-height:1.8;margin-bottom:28px;">
            $($about.p2)
          </p>

          <h3 style="font-size:1.25rem;margin-bottom:16px;">Core Printing Capabilities:</h3>
          <div style="display:grid;grid-template-columns:repeat(auto-fit, minmax(260px, 1fr));gap:12px;margin-bottom:36px;">
            $(($about.capabilities | ForEach-Object {
              @"
              <div style="display:flex;align-items:center;gap:10px;font-size:0.95rem;font-weight:600;color:var(--color-primary);">
                <i class="fa-solid fa-circle-check" style="color:var(--color-accent);flex-shrink:0;"></i>
                <span>$_</span>
              </div>
"@
            }) -join "`n")
          </div>

          <a href="contact.html" class="btn btn-primary" data-open-quote>
            <i class="fa-solid fa-envelope"></i>
            <span>Partner With Us</span>
          </a>
        </div>

        <div>
          <div class="hero-card-stack">
            <img src="assets/imgs/About/book-printing-banner-0.jpg" alt="Print production at Ganesha Enterprises" class="hero-card-img" width="560" height="420">
            <div class="floating-badge floating-badge-2" style="bottom:-15px;right:20px;">
              <div class="floating-icon"><i class="fa-solid fa-award"></i></div>
              <div>
                <div class="floating-title">25+ Years</div>
                <div class="floating-sub">Trusted Printing Experience</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Why Choose Us -->
  <section class="section bg-alt">
    <div class="container">
      <div class="hero-grid" style="align-items:center;">
        <div>
          <div class="hero-card-stack">
            <img src="assets/imgs/About/AdobeStock_70903710-scaled.jpeg" alt="Precision printing machinery" class="hero-card-img" width="560" height="420">
          </div>
        </div>

        <div>
          <span class="section-eyebrow">$($about.whyChooseUs.eyebrow)</span>
          <h2 class="display-2 section-title">$($about.whyChooseUs.heading)</h2>
          <p style="font-size:1.05rem;color:var(--color-text-muted);line-height:1.7;margin-bottom:24px;">
            $($about.whyChooseUs.intro)
          </p>

          <div style="display:flex;flex-direction:column;gap:14px;margin-bottom:32px;">
            $(($about.whyChooseUs.points | ForEach-Object {
              @"
              <div style="display:flex;align-items:center;gap:12px;font-size:1rem;font-weight:600;color:var(--color-primary);background:#ffffff;padding:12px 18px;border-radius:var(--radius-md);border:1px solid var(--color-border);">
                <i class="fa-solid fa-circle-check" style="color:var(--color-accent);font-size:1.1rem;flex-shrink:0;"></i>
                <span>$_</span>
              </div>
"@
            }) -join "`n")
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Client Trust Brands -->
  <section class="trust-section">
    <div class="container">
      <div class="trust-title">$($about.trustIndicators.heading)</div>
      <div class="clients-grid">
        $(($site.clients | ForEach-Object {
          "<div class='client-logo-item'><img src='$($_.logo)' alt='$($_.name)' loading='lazy'></div>"
        }) -join "`n")
      </div>
    </div>
  </section>

  <!-- FAQ Section -->
  <section class="section bg-white">
    <div class="container">
      <div class="text-center" style="margin-bottom:48px;">
        <span class="section-eyebrow">Have Any Question</span>
        <h2 class="display-2 section-title">Frequently Asked Questions</h2>
        <p class="section-subtitle mx-auto">Get fast answers to common questions about our corporate printing workflow.</p>
      </div>

      <div class="faq-container">
        $(($faqs | ForEach-Object {
          @"
          <div class="faq-item">
            <button class="faq-question">
              <span>$($_.question)</span>
              <i class="fa-solid fa-chevron-down faq-icon"></i>
            </button>
            <div class="faq-answer">
              <p>$($_.answer)</p>
            </div>
          </div>
"@
        }) -join "`n")
      </div>
    </div>
  </section>
"@

$aboutHtml += Get-Footer -depth 0
Set-Content -Path "about.html" -Value $aboutHtml -Encoding UTF8
Write-Host "Built about.html successfully!"

# --------------------------------------------------------------------------
# BUILD 3: services.html (Services Hub)
# --------------------------------------------------------------------------
Write-Host "Building services.html..."
$servicesHubTitle = "Digital & Custom Printing Services in Delhi NCR | Ganesha Enterprises"
$servicesHubDesc = "Explore our wide range of professional printing services in Delhi NCR. From business cards to large-format banners, labels to merchandise - we print it all with unmatched quality and speed."
$servicesHtml = Get-Head -title $servicesHubTitle -desc $servicesHubDesc -depth 0
$servicesHtml += Get-TopBar -depth 0
$servicesHtml += Get-Header -activePage "services" -depth 0

$servicesHtml += @"
  <!-- Breadcrumb -->
  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="index.html" style="color:var(--color-text-muted);">Home</a>
        <span>/</span>
        <span style="color:var(--color-accent);font-weight:600;">Our Services</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">Professional Printing Services</h1>
      <p style="font-size:1.15rem;color:var(--color-text-muted);max-width:760px;margin-top:10px;">
        Discover our 8 specialized commercial printing divisions engineered for brand consistency, high durability, and stunning tactile appeal.
      </p>
    </div>
  </section>

  <!-- Services Grid -->
  <section class="section bg-alt">
    <div class="container">
      <div class="services-grid services-hub-grid">
        $(($services | ForEach-Object {
          $idx = [array]::IndexOf($services, $_) + 1
          @"
          <div class="service-card">
            <div class="service-card-img-wrap">
              <img src="$($_.image)" alt="$($_.title)" class="service-card-img" loading="lazy">
              <span class="service-rank-badge">#$idx</span>
            </div>
            <div class="service-card-body">
              <h2 class="service-card-title">$($_.title)</h2>
              <div class="service-card-subtitle" style="font-size:0.92rem;color:var(--color-accent);font-weight:600;margin-bottom:12px;">$($_.subtitle)</div>
              <p class="service-card-desc">$($_.description)</p>

              <div style="margin-bottom:20px;border-top:1px solid var(--color-border);padding-top:16px;">
                <div style="font-size:0.85rem;font-weight:700;text-transform:uppercase;color:var(--color-text-muted);margin-bottom:8px;">Offerings Include:</div>
                <ul style="display:flex;flex-direction:column;gap:6px;font-size:0.85rem;color:var(--color-primary);">
                  $(($_.offerings | Select-Object -First 3 | ForEach-Object { "<li><i class='fa-solid fa-check' style='color:var(--color-accent);margin-right:6px;'></i> $_</li>" }) -join "`n")
                </ul>
              </div>

              <a href="services/$($_.slug).html" class="btn btn-primary btn-sm" style="width:100%;margin-top:auto;">
                <span>View Service Details</span>
                <i class="fa-solid fa-arrow-right"></i>
              </a>
            </div>
          </div>
"@
        }) -join "`n")
      </div>
    </div>
  </section>

  <!-- FAQ Section -->
  <section class="section bg-white">
    <div class="container">
      <div class="text-center" style="margin-bottom:48px;">
        <span class="section-eyebrow">Have Any Questions?</span>
        <h2 class="display-2 section-title">Frequently Asked Questions</h2>
        <p class="section-subtitle mx-auto">Learn more about our service turnarounds, proofs, and delivery options.</p>
      </div>

      <div class="faq-container">
        $(($faqs | ForEach-Object {
          @"
          <div class="faq-item">
            <button class="faq-question">
              <span>$($_.question)</span>
              <i class="fa-solid fa-chevron-down faq-icon"></i>
            </button>
            <div class="faq-answer">
              <p>$($_.answer)</p>
            </div>
          </div>
"@
        }) -join "`n")
      </div>
    </div>
  </section>
"@

$servicesHtml += Get-Footer -depth 0
Set-Content -Path "services.html" -Value $servicesHtml -Encoding UTF8
Write-Host "Built services.html successfully!"

# --------------------------------------------------------------------------
# BUILD 4: Individual Service Pages (8 pages)
# --------------------------------------------------------------------------
foreach ($s in $services) {
    Write-Host "Building services/$($s.slug).html..."
    $stitle = "$($s.title) | Ganesha Enterprises Delhi NCR"
    $sdesc = "$($s.subtitle). $($s.description)"
    $sHtml = Get-Head -title $stitle -desc $sdesc -depth 1
    $sHtml += Get-TopBar -depth 1
    $sHtml += Get-Header -activePage "services" -depth 1

    $sHtml += @"
  <!-- Breadcrumb -->
  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="../index.html" style="color:var(--color-text-muted);">Home</a>
        <span>/</span>
        <a href="../services.html" style="color:var(--color-text-muted);">Services</a>
        <span>/</span>
        <span style="color:var(--color-accent);font-weight:600;">$($s.title)</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">$($s.title)</h1>
      <p style="font-size:1.15rem;color:var(--color-accent);font-weight:600;margin-top:8px;">$($s.subtitle)</p>
    </div>
  </section>

  <!-- Service Detail Content -->
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
              $(($s.offerings | ForEach-Object {
                @"
                <li style="display:flex;align-items:center;gap:10px;font-size:0.95rem;font-weight:600;color:var(--color-primary);">
                  <i class="fa-solid fa-circle-check" style="color:var(--color-accent);flex-shrink:0;"></i>
                  <span>$_</span>
                </li>
"@
              }) -join "`n")
            </ul>
          </div>

          <div style="background-color:#ffffff;border-radius:var(--radius-lg);padding:32px;border:1px solid var(--color-border);margin-bottom:40px;">
            <h3 style="font-size:1.35rem;margin-bottom:18px;color:var(--color-primary);">Why Choose Us:</h3>
            <ul style="display:flex;flex-direction:column;gap:12px;">
              $(($s.whyChooseUs | ForEach-Object {
                @"
                <li style="display:flex;align-items:center;gap:12px;font-size:0.95rem;color:var(--color-primary);">
                  <i class="fa-solid fa-award" style="color:var(--color-accent);font-size:1.1rem;flex-shrink:0;"></i>
                  <span>$_</span>
                </li>
"@
              }) -join "`n")
            </ul>
          </div>

          <!-- In-Page FAQ for this Service -->
          <div style="margin-top:48px;">
            <h3 style="font-size:1.5rem;margin-bottom:20px;">Frequently Asked Questions</h3>
            <div class="faq-container" style="max-width:100%;">
              $(($faqs | Select-Object -First 3 | ForEach-Object {
                @"
                <div class="faq-item">
                  <button class="faq-question">
                    <span>$($_.question)</span>
                    <i class="fa-solid fa-chevron-down faq-icon"></i>
                  </button>
                  <div class="faq-answer">
                    <p>$($_.answer)</p>
                  </div>
                </div>
"@
              }) -join "`n")
            </div>
          </div>
        </div>

        <!-- Sidebar / Quote Action -->
        <div>
          <div style="position:sticky;top:90px;display:flex;flex-direction:column;gap:24px;">
            <div class="contact-info-card" style="padding:32px;">
              <h3 style="color:#ffffff;font-size:1.4rem;margin-bottom:8px;">Request Quote For This Service</h3>
              <p style="color:var(--color-text-light);font-size:0.9rem;margin-bottom:20px;">
                Get personalized volume pricing and fast turnaround options from our Naraina print studio.
              </p>
              
              <form data-ajax-form>
                <input type="hidden" name="requirement" value="Service Inquiry: $($s.title)">
                <div style="display:flex;flex-direction:column;gap:12px;margin-bottom:16px;">
                  <input type="text" name="name" class="form-control" placeholder="Your Name" required>
                  <input type="tel" name="phone" class="form-control" placeholder="Phone Number" required>
                  <input type="email" name="email" class="form-control" placeholder="Email Address">
                  <textarea name="message" class="form-control" placeholder="Specifications, quantity, delivery location..." style="min-height:90px;"></textarea>
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;">
                  <i class="fa-solid fa-paper-plane"></i>
                  <span>Send Request</span>
                </button>
              </form>
            </div>

            <!-- Other Services Navigation -->
            <div style="background-color:var(--color-bg-alt);border:1px solid var(--color-border);border-radius:var(--radius-xl);padding:24px;">
              <h4 style="font-size:1.1rem;margin-bottom:16px;color:var(--color-primary);">Explore Other Services</h4>
              <div style="display:flex;flex-direction:column;gap:8px;">
                $(($services | Where-Object { $_.slug -ne $s.slug } | ForEach-Object {
                  @"
                  <a href="$($_.slug).html" style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:#ffffff;border-radius:var(--radius-md);border:1px solid var(--color-border);font-size:0.9rem;font-weight:600;color:var(--color-primary);">
                    <span>$($_.title)</span>
                    <i class="fa-solid fa-angle-right" style="color:var(--color-accent);"></i>
                  </a>
"@
                }) -join "`n")
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
"@

    $sHtml += Get-Footer -depth 1
    Set-Content -Path "services/$($s.slug).html" -Value $sHtml -Encoding UTF8
}
Write-Host "Built all 8 service detail pages!"

# --------------------------------------------------------------------------
# BUILD 5: products.html (Catalog with all 90 products, live search, tabs)
# --------------------------------------------------------------------------
Write-Host "Building products.html with 90 products..."
$prodPageTitle = "Customized Print Products | Shop T-Shirts, Mugs, Bags & More Online | Ganesha Enterprises"
$prodPageDesc = "Browse 90+ custom printed products including business cards, custom apparel, mugs, promotional drinkware, acrylic signage, packaging boxes, and executive gifts."
$prodHtml = Get-Head -title $prodPageTitle -desc $prodPageDesc -depth 0
$prodHtml += Get-TopBar -depth 0
$prodHtml += Get-Header -activePage "products" -depth 0

$prodHtml += @"
  <!-- Breadcrumb -->
  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="index.html" style="color:var(--color-text-muted);">Home</a>
        <span>/</span>
        <span style="color:var(--color-accent);font-weight:600;">Products</span>
      </div>
      <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:20px;">
        <div>
          <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">Custom Print Products Catalog</h1>
          <p style="font-size:1.15rem;color:var(--color-text-muted);max-width:700px;margin-top:8px;">
            High-precision printing across 90+ product types with bespoke logo branding and bulk volume discounts.
          </p>
        </div>
        <div style="display:flex;align-items:center;gap:12px;">
          <a href="contact.html" class="btn btn-primary" data-open-quote>
            <i class="fa-solid fa-file-invoice"></i>
            <span>Bulk Order Quote</span>
          </a>
        </div>
      </div>
    </div>
  </section>

  <!-- Filter & Catalog -->
  <section class="section bg-alt">
    <div class="container">
      <!-- Search and Category Filters -->
      <div style="background-color:#ffffff;border:1px solid var(--color-border);border-radius:var(--radius-xl);padding:24px;margin-bottom:36px;box-shadow:var(--shadow-sm);">
        <div style="display:flex;flex-direction:column;gap:20px;">
          <!-- Search Input -->
          <div style="position:relative;width:100%;">
            <i class="fa-solid fa-magnifying-glass" style="position:absolute;left:18px;top:50%;transform:translateY(-50%);color:var(--color-text-muted);font-size:1.1rem;"></i>
            <input type="text" id="productSearchInput" class="form-control" placeholder="Search by product name (e.g. visiting cards, polo t-shirt, mug, diary, standee...)" style="padding-left:48px;height:52px;font-size:1.05rem;">
          </div>

          <!-- Category Buttons -->
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

      <!-- Products Grid -->
      <div class="products-grid">
        $(($products | ForEach-Object {
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
                <div class="rating-stars">
                  <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                </div>
                <button class="btn btn-primary btn-sm" data-open-quote data-product-name="$($_.name)">
                  Inquire Quote
                </button>
              </div>
            </div>
          </div>
"@
        }) -join "`n")
      </div>
    </div>
  </section>
"@

$prodHtml += Get-Footer -depth 0
Set-Content -Path "products.html" -Value $prodHtml -Encoding UTF8
Write-Host "Built products.html successfully!"

# --------------------------------------------------------------------------
# BUILD 6: portfolio.html (Our Work)
# --------------------------------------------------------------------------
Write-Host "Building portfolio.html..."
$portfolioTitle = "Our Work | Print Portfolio of Ganesha Enterprises - Delhi NCR"
$portfolioDesc = "View our portfolio featuring print projects for top brands across Delhi NCR and beyond. From promotional material to branded merchandise - our work speaks for itself."
$portHtml = Get-Head -title $portfolioTitle -desc $portfolioDesc -depth 0
$portHtml += Get-TopBar -depth 0
$portHtml += Get-Header -activePage "portfolio" -depth 0

$portHtml += @"
  <!-- Breadcrumb -->
  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="index.html" style="color:var(--color-text-muted);">Home</a>
        <span>/</span>
        <span style="color:var(--color-accent);font-weight:600;">Portfolio</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">Our Print & Gifting Portfolio</h1>
      <p style="font-size:1.15rem;color:var(--color-text-muted);max-width:700px;margin-top:8px;">
        Browse actual client projects delivered for premier airlines, hotels, public sector enterprises, and corporate teams.
      </p>
    </div>
  </section>

  <!-- Portfolio Grid -->
  <section class="section bg-alt">
    <div class="container">
      <div class="portfolio-grid">
        $(($portfolio | ForEach-Object {
          @"
          <div class="portfolio-card">
            <div class="portfolio-img-wrap">
              <img src="$($_.image)" alt="$($_.title)" loading="lazy">
            </div>
            <div class="portfolio-info">
              <span class="portfolio-tag">$($_.category)</span>
              <h3 class="portfolio-title">$($_.title)</h3>
              <div class="portfolio-client"><i class="fa-solid fa-building" style="color:var(--color-accent);margin-right:6px;"></i> Client: $($_.client)</div>
            </div>
          </div>
"@
        }) -join "`n")
      </div>
    </div>
  </section>

  <!-- Client Logos Section -->
  <section class="trust-section">
    <div class="container">
      <div class="trust-title">Trusted by Leading Enterprises Across Industries</div>
      <div class="clients-grid">
        $(($site.clients | ForEach-Object {
          "<div class='client-logo-item'><img src='$($_.logo)' alt='$($_.name)' loading='lazy'></div>"
        }) -join "`n")
      </div>
    </div>
  </section>
"@

$portHtml += Get-Footer -depth 0
Set-Content -Path "portfolio.html" -Value $portHtml -Encoding UTF8
Write-Host "Built portfolio.html successfully!"

# --------------------------------------------------------------------------
# BUILD 7: blog.html (Blog Hub)
# --------------------------------------------------------------------------
Write-Host "Building blog.html..."
$blogHubTitle = "Printing Tips, Branding Ideas & Industry Trends | Ganesha Blog"
$blogHubDesc = "Stay ahead with expert articles on modern branding, merchandise trends, eco-friendly printing materials, and packaging strategies from Ganesha Enterprises."
$blogHtml = Get-Head -title $blogHubTitle -desc $blogHubDesc -depth 0
$blogHtml += Get-TopBar -depth 0
$blogHtml += Get-Header -activePage "blog" -depth 0

$blogHtml += @"
  <!-- Breadcrumb -->
  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="index.html" style="color:var(--color-text-muted);">Home</a>
        <span>/</span>
        <span style="color:var(--color-accent);font-weight:600;">Blog</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">Printing Tips & Industry Insights</h1>
      <p style="font-size:1.15rem;color:var(--color-text-muted);max-width:700px;margin-top:8px;">
        Discover how thoughtful design, custom physical touchpoints, and sustainable materials build unforgettable brand equity.
      </p>
    </div>
  </section>

  <!-- Blog Grid -->
  <section class="section bg-alt">
    <div class="container">
      <div class="blogs-grid">
        $(($blogs | ForEach-Object {
          $link = if ($_.id -eq "why-custom-printing-is-the-secret-weapon-of-modern-branding") { "blog/why-custom-printing-is-the-secret-weapon.html" } elseif ($_.id -eq "t-shirts-to-tumblers-top-10-custom-products") { "blog/t-shirts-to-tumblers-top-10-custom-products.html" } else { "#" }
          @"
          <article class="blog-card">
            <div class="blog-card-img">
              <img src="$($_.image)" alt="$($_.title)" loading="lazy">
            </div>
            <div class="blog-card-body">
              <div class="blog-meta">
                <span><i class="fa-regular fa-calendar" style="color:var(--color-accent);margin-right:4px;"></i> $($_.date)</span>
                <span>•</span>
                <span><i class="fa-regular fa-user" style="color:var(--color-accent);margin-right:4px;"></i> $($_.author)</span>
              </div>
              <h2 class="blog-card-title"><a href="$link">$($_.title)</a></h2>
              <p class="blog-card-excerpt">$($_.summary)</p>
              <div class="blog-card-footer">
                $(if ($link -ne "#") {
                  @"
                  <a href="$link" style="color:var(--color-accent);font-weight:700;display:inline-flex;align-items:center;gap:6px;">
                    <span>Read Full Guide</span>
                    <i class="fa-solid fa-arrow-right"></i>
                  </a>
"@
                } else {
                  @"
                  <span style="color:var(--color-text-muted);font-size:0.85rem;font-weight:600;">
                    <i class="fa-solid fa-newspaper" style="color:var(--color-accent);margin-right:4px;"></i> Full Article Preserved in Content Inventory
                  </span>
"@
                })
              </div>
            </div>
          </article>
"@
        }) -join "`n")
      </div>
    </div>
  </section>
"@

$blogHtml += Get-Footer -depth 0
Set-Content -Path "blog.html" -Value $blogHtml -Encoding UTF8
Write-Host "Built blog.html successfully!"

# --------------------------------------------------------------------------
# BUILD 8: Individual Blog Articles (blog/...)
# --------------------------------------------------------------------------
# Article 1
Write-Host "Building blog/why-custom-printing-is-the-secret-weapon.html..."
$b1 = $blogs | Where-Object { $_.id -eq "why-custom-printing-is-the-secret-weapon-of-modern-branding" }
$b1HtmlDoc = Get-Head -title "$($b1.title) | Ganesha Blog" -desc $b1.summary -depth 1
$b1HtmlDoc += Get-TopBar -depth 1
$b1HtmlDoc += Get-Header -activePage "blog" -depth 1

$b1HtmlDoc += @"
  <!-- Breadcrumb -->
  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="../index.html" style="color:var(--color-text-muted);">Home</a>
        <span>/</span>
        <a href="../blog.html" style="color:var(--color-text-muted);">Blog</a>
        <span>/</span>
        <span style="color:var(--color-accent);font-weight:600;">Article</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2rem, 3.5vw, 2.8rem);max-width:850px;">$($b1.title)</h1>
      <div style="display:flex;align-items:center;gap:16px;margin-top:14px;color:var(--color-text-muted);font-size:0.9rem;">
        <span><i class="fa-regular fa-calendar" style="color:var(--color-accent);margin-right:6px;"></i> $($b1.date)</span>
        <span>•</span>
        <span><i class="fa-regular fa-user" style="color:var(--color-accent);margin-right:6px;"></i> By $($b1.author)</span>
      </div>
    </div>
  </section>

  <!-- Article Body -->
  <section class="section bg-white">
    <div class="container">
      <div class="contact-layout">
        <div>
          <div style="border-radius:var(--radius-xl);overflow:hidden;margin-bottom:36px;box-shadow:var(--shadow-lg);">
            <img src="../$($b1.image)" alt="$($b1.title)" style="width:100%;height:auto;aspect-ratio:16/9;object-fit:cover;">
          </div>

          <div style="font-size:1.1rem;line-height:1.8;color:var(--color-text-main);">
            <p style="margin-bottom:24px;">In a world dominated by digital ads and fast scrolling, physical brand touchpoints have become more powerful than ever. One of the most overlooked branding tools is custom printing - a cost-effective, tangible way to create lasting impressions. Whether you're a startup, an artist, or an established business, your brand deserves to be seen, felt, and remembered. That's where custom printing steps in.</p>

            <h2 style="font-size:1.6rem;margin-top:36px;margin-bottom:16px;">What Is Custom Printing?</h2>
            <p style="margin-bottom:24px;">Custom printing refers to the process of designing and printing personalized designs, logos, or artwork on various surfaces such as apparel, packaging, labels, mugs, tote bags, and more. Unlike standard mass production, custom printing focuses on your brand, your style, and your audience.</p>

            <h2 style="font-size:1.6rem;margin-top:36px;margin-bottom:16px;">Why It's a Branding Powerhouse</h2>
            <div style="display:flex;flex-direction:column;gap:18px;margin-bottom:32px;">
              <div style="background:var(--color-bg-alt);padding:20px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.15rem;margin-bottom:6px;">1. Creates Instant Recognition</h3>
                <p style="color:var(--color-text-muted);font-size:0.95rem;">Your brand identity - colors, fonts, logo - needs to stay consistent across every platform. Custom printing ensures that your packaging, merchandise, and promotional items look exactly how your customers expect.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:20px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.15rem;margin-bottom:6px;">2. Builds Emotional Connection</h3>
                <p style="color:var(--color-text-muted);font-size:0.95rem;">People connect with physical items. Receiving a beautifully printed product or package feels more personal, memorable, and trustworthy than receiving a generic or unbranded one.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:20px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.15rem;margin-bottom:6px;">3. Boosts Professionalism</h3>
                <p style="color:var(--color-text-muted);font-size:0.95rem;">Whether it's a custom invoice book, branded merchandise, or product packaging, good printing shows your attention to detail. It signals that you're invested in your brand.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:20px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.15rem;margin-bottom:6px;">4. Makes You Stand Out</h3>
                <p style="color:var(--color-text-muted);font-size:0.95rem;">In saturated markets, visual uniqueness matters. Custom-printed items - like water bottles with your own logo or vibrant product boxes - help you stand out from cookie-cutter competitors.</p>
              </div>
            </div>

            <h2 style="font-size:1.6rem;margin-top:36px;margin-bottom:16px;">Trends in Custom Printing</h2>
            <ul style="display:flex;flex-direction:column;gap:12px;margin-bottom:36px;">
              <li style="display:flex;gap:10px;"><i class="fa-solid fa-leaf" style="color:#10b981;margin-top:4px;"></i> <div><strong>Sustainable materials:</strong> Eco-conscious printing options are in high demand.</div></li>
              <li style="display:flex;gap:10px;"><i class="fa-solid fa-paintbrush" style="color:var(--color-accent);margin-top:4px;"></i> <div><strong>Minimalist design:</strong> Clean and elegant prints are trending.</div></li>
              <li style="display:flex;gap:10px;"><i class="fa-solid fa-gear" style="color:var(--color-secondary);margin-top:4px;"></i> <div><strong>Personalization at scale:</strong> Businesses are offering name-printed items to customers - powered by smart printing tech.</div></li>
            </ul>

            <div style="padding:24px;border:1px solid var(--color-border);border-radius:var(--radius-lg);background:var(--color-bg-alt);margin-top:40px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;">
              <div>
                <strong>Tags:</strong>
                <span class="portfolio-tag" style="margin-left:8px;">Branding</span>
                <span class="portfolio-tag">Custom Printing</span>
                <span class="portfolio-tag">Creative</span>
              </div>
              <a href="../contact.html" class="btn btn-primary btn-sm" data-open-quote>Start Your Custom Print Project</a>
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div>
          <div style="position:sticky;top:90px;display:flex;flex-direction:column;gap:24px;">
            <div style="background:#ffffff;border:1px solid var(--color-border);border-radius:var(--radius-xl);padding:24px;">
              <h4 style="font-size:1.15rem;margin-bottom:16px;">Other Articles</h4>
              <a href="t-shirts-to-tumblers-top-10-custom-products.html" style="display:flex;gap:12px;align-items:center;padding:10px 0;border-bottom:1px solid var(--color-border);">
                <img src="../assets/imgs/blog/alexey-demidov-GwyI9juslws-unsplash.png" style="width:70px;height:55px;object-fit:cover;border-radius:var(--radius-sm);" alt="Blog 2">
                <div>
                  <div style="font-size:0.85rem;font-weight:700;color:var(--color-primary);line-height:1.3;">T-Shirts to Tumblers: Top 10 Custom Products</div>
                  <div style="font-size:0.75rem;color:var(--color-text-muted);">25 June 2025</div>
                </div>
              </a>
            </div>

            <div class="contact-info-card" style="padding:28px;">
              <h4 style="color:#ffffff;font-size:1.25rem;margin-bottom:8px;">Need Custom Print Advice?</h4>
              <p style="color:var(--color-text-light);font-size:0.9rem;margin-bottom:16px;">Our specialists are on hand to advise on paper stock, finishes, and sample proofs.</p>
              <a href="tel:$($site.contact.phoneRaw)" class="btn btn-primary" style="width:100%;"><i class="fa-solid fa-phone"></i> Call +91-9650044234</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
"@

$b1HtmlDoc += Get-Footer -depth 1
Set-Content -Path "blog/why-custom-printing-is-the-secret-weapon.html" -Value $b1HtmlDoc -Encoding UTF8
Write-Host "Built blog/why-custom-printing-is-the-secret-weapon.html!"

# Article 2
Write-Host "Building blog/t-shirts-to-tumblers-top-10-custom-products.html..."
$b2 = $blogs | Where-Object { $_.id -eq "t-shirts-to-tumblers-top-10-custom-products" }
$b2HtmlDoc = Get-Head -title "$($b2.title) | Ganesha Blog" -desc $b2.summary -depth 1
$b2HtmlDoc += Get-TopBar -depth 1
$b2HtmlDoc += Get-Header -activePage "blog" -depth 1

$b2HtmlDoc += @"
  <!-- Breadcrumb -->
  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="../index.html" style="color:var(--color-text-muted);">Home</a>
        <span>/</span>
        <a href="../blog.html" style="color:var(--color-text-muted);">Blog</a>
        <span>/</span>
        <span style="color:var(--color-accent);font-weight:600;">Article</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2rem, 3.5vw, 2.8rem);max-width:850px;">$($b2.title)</h1>
      <div style="display:flex;align-items:center;gap:16px;margin-top:14px;color:var(--color-text-muted);font-size:0.9rem;">
        <span><i class="fa-regular fa-calendar" style="color:var(--color-accent);margin-right:6px;"></i> $($b2.date)</span>
        <span>•</span>
        <span><i class="fa-regular fa-user" style="color:var(--color-accent);margin-right:6px;"></i> By $($b2.author)</span>
      </div>
    </div>
  </section>

  <!-- Article Body -->
  <section class="section bg-white">
    <div class="container">
      <div class="contact-layout">
        <div>
          <div style="border-radius:var(--radius-xl);overflow:hidden;margin-bottom:36px;box-shadow:var(--shadow-lg);">
            <img src="../$($b2.image)" alt="$($b2.title)" style="width:100%;height:auto;aspect-ratio:16/9;object-fit:cover;">
          </div>

          <div style="font-size:1.1rem;line-height:1.8;color:var(--color-text-main);">
            <p style="margin-bottom:20px;">Brand loyalty doesn't come from just ads and discounts - it comes from meaningful experiences. One of the most powerful ways to create those moments is through custom-branded products. From everyday essentials to gift-worthy keepsakes, custom printing helps businesses turn ordinary items into walking billboards and relationship builders.</p>
            
            <p style="margin-bottom:32px;">Whether you're launching a new brand, planning a corporate giveaway, or hosting an event, here are 10 custom-printed items that customers actually love - and remember.</p>

            <div style="display:flex;flex-direction:column;gap:20px;margin-bottom:36px;">
              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">1. Custom T-Shirts</h3>
                <p><strong>Why they work:</strong> Everyone wears them. T-shirts are wearable marketing tools that spread your logo wherever your customers go.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Use soft fabric and clean typography. Minimalist designs often get worn more frequently.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">2. Printed Mugs</h3>
                <p><strong>Why they work:</strong> A staple in homes and offices, mugs are perfect for daily exposure.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Add a witty quote or logo on one side and a QR code linking to your website on the other.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">3. Branded Water Bottles</h3>
                <p><strong>Why they work:</strong> Eco-friendly, practical, and perfect for fitness or wellness brands.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Choose stainless steel or BPA-free materials and a sleek print finish to appeal to modern users.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">4. Tote Bags</h3>
                <p><strong>Why they work:</strong> Reusable totes have become a fashion statement and eco-conscious choice.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Design something customers would want to carry around - cool graphics and your logo subtly placed.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">5. Custom Notebooks</h3>
                <p><strong>Why they work:</strong> Ideal for both corporate events and student marketing.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Use high-quality paper and offer personalization (e.g., name or initials) to make them feel premium.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">6. Branded Pens</h3>
                <p><strong>Why they work:</strong> Budget-friendly and surprisingly effective for mass distribution.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Go for smooth-writing ink pens with metallic printing or rubber grip for added appeal.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">7. Caps and Hats</h3>
                <p><strong>Why they work:</strong> Especially popular in outdoor events, fashion, and sports branding.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Embroidered logos add a luxury feel. Keep the design minimal to ensure wearability.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">8. Custom Product Boxes</h3>
                <p><strong>Why they work:</strong> First impressions matter - especially for online orders and gifting.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Print inside the box as well. A small quote or thank-you message surprises and delights.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">9. Stickers and Labels</h3>
                <p><strong>Why they work:</strong> Low cost, high visibility. Perfect for branding packaging or giving out as freebies.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Die-cut vinyl stickers with your logo or tagline are great for laptops, notebooks, and bottles.</p>
              </div>

              <div style="background:var(--color-bg-alt);padding:24px;border-radius:var(--radius-md);border-left:4px solid var(--color-accent);">
                <h3 style="font-size:1.2rem;margin-bottom:8px;">10. Cosmetic or Gel Paint Bottles</h3>
                <p><strong>Why they work:</strong> If you sell nail gels, essential oils, or cosmetics, custom-printed bottles level up your shelf appeal.</p>
                <p style="color:var(--color-text-muted);margin-top:6px;"><strong>Tip:</strong> Use frosted bottles with matte or metallic foil stamping for a luxury, salon-quality finish.</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div>
          <div style="position:sticky;top:90px;display:flex;flex-direction:column;gap:24px;">
            <div style="background:#ffffff;border:1px solid var(--color-border);border-radius:var(--radius-xl);padding:24px;">
              <h4 style="font-size:1.15rem;margin-bottom:16px;">Other Articles</h4>
              <a href="why-custom-printing-is-the-secret-weapon.html" style="display:flex;gap:12px;align-items:center;padding:10px 0;">
                <img src="../assets/imgs/blog/bank-phrom-Tzm3Oyu_6sk-unsplash.jpg" style="width:70px;height:55px;object-fit:cover;border-radius:var(--radius-sm);" alt="Blog 1">
                <div>
                  <div style="font-size:0.85rem;font-weight:700;color:var(--color-primary);line-height:1.3;">Why Custom Printing Is the Secret Weapon</div>
                  <div style="font-size:0.75rem;color:var(--color-text-muted);">25 June 2025</div>
                </div>
              </a>
            </div>

            <div class="contact-info-card" style="padding:28px;">
              <h4 style="color:#ffffff;font-size:1.25rem;margin-bottom:8px;">Order Sample Merchandise</h4>
              <p style="color:var(--color-text-light);font-size:0.9rem;margin-bottom:16px;">Test print quality on mugs, bottles, caps, and t-shirts before full run.</p>
              <a href="../contact.html" class="btn btn-primary" style="width:100%;" data-open-quote>Request Product Samples</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
"@

$b2HtmlDoc += Get-Footer -depth 1
Set-Content -Path "blog/t-shirts-to-tumblers-top-10-custom-products.html" -Value $b2HtmlDoc -Encoding UTF8
Write-Host "Built blog/t-shirts-to-tumblers-top-10-custom-products.html!"

# --------------------------------------------------------------------------
# BUILD 9: contact.html (Contact Us)
# --------------------------------------------------------------------------
Write-Host "Building contact.html..."
$cHtml = Get-Head -title $contact.title -desc $contact.metaDescription -depth 0
$cHtml += Get-TopBar -depth 0
$cHtml += Get-Header -activePage "contact" -depth 0

$cHtml += @"
  <!-- Breadcrumb -->
  <section class="section-sm bg-white" style="border-bottom: 1px solid var(--color-border);">
    <div class="container">
      <div style="display:flex;align-items:center;gap:8px;font-size:0.9rem;color:var(--color-text-muted);margin-bottom:12px;">
        <a href="index.html" style="color:var(--color-text-muted);">Home</a>
        <span>/</span>
        <span style="color:var(--color-accent);font-weight:600;">Contact Us</span>
      </div>
      <h1 class="display-1" style="font-size:clamp(2.4rem, 4vw, 3.2rem);">$($contact.heading)</h1>
      <p style="font-size:1.15rem;color:var(--color-text-muted);max-width:700px;margin-top:8px;">
        $($contact.subIntro)
      </p>
    </div>
  </section>

  <!-- Contact Details & Form -->
  <section class="section bg-alt">
    <div class="container">
      <div class="contact-layout">
        <!-- Contact Information Card -->
        <div class="contact-info-card">
          <span class="section-eyebrow" style="background:rgba(255,255,255,0.15);color:#ffffff;">$($contact.intro)</span>
          <h2 class="contact-info-title">Give Us A Printing Deal From Company</h2>
          <p class="contact-info-desc">
            Visit our studio in Naraina Industrial Area Phase 1 or contact our production team directly.
          </p>

          <div class="contact-list">
            <div class="contact-item">
              <div class="contact-icon-box"><i class="fa-solid fa-phone"></i></div>
              <div>
                <div class="contact-item-label">Direct Phone</div>
                <div class="contact-item-value"><a href="tel:$($contact.phoneRaw)">$($contact.phone)</a></div>
              </div>
            </div>

            <div class="contact-item">
              <div class="contact-icon-box"><i class="fa-solid fa-envelope"></i></div>
              <div>
                <div class="contact-item-label">Direct Email</div>
                <div class="contact-item-value"><a href="mailto:$($contact.email)">$($contact.email)</a></div>
              </div>
            </div>

            <div class="contact-item">
              <div class="contact-icon-box"><i class="fa-solid fa-location-dot"></i></div>
              <div>
                <div class="contact-item-label">Business Studio Address</div>
                <div class="contact-item-value">
                  <a href="$($contact.googleMapsUrl)" target="_blank" rel="noopener">
                    $($contact.address)
                  </a>
                </div>
              </div>
            </div>

            <div class="contact-item">
              <div class="contact-icon-box"><i class="fa-solid fa-clock"></i></div>
              <div>
                <div class="contact-item-label">Working Hours</div>
                <div class="contact-item-value">$($contact.businessHours)</div>
              </div>
            </div>
          </div>

          <div style="border-top:1px solid rgba(255,255,255,0.12);padding-top:24px;">
            <a href="$($site.socialLinks.whatsapp)" target="_blank" rel="noopener" class="btn btn-primary" style="width:100%;background:#25d366;box-shadow:none;">
              <i class="fa-brands fa-whatsapp"></i>
              <span>Chat on WhatsApp (+91-9650044234)</span>
            </a>
          </div>
        </div>

        <!-- Contact Form Card -->
        <div class="contact-form-card">
          <span class="section-eyebrow">Send A Message</span>
          <h2 style="font-size:1.8rem;margin-bottom:12px;color:var(--color-primary);">Request A Quote / Place An Order</h2>
          <p style="color:var(--color-text-muted);font-size:0.95rem;margin-bottom:28px;">
            Fill out your project specifications below. Our specialists review every submission and respond promptly with tailored pricing.
          </p>

          <form data-ajax-form>
            <div class="form-grid">
              <div>
                <label class="form-label">Full Name *</label>
                <input type="text" name="name" class="form-control" placeholder="John Doe" required>
              </div>
              <div>
                <label class="form-label">Phone Number *</label>
                <input type="tel" name="phone" class="form-control" placeholder="+91 96500 44234" required>
              </div>
              <div>
                <label class="form-label">Email Address *</label>
                <input type="email" name="email" class="form-control" placeholder="john@company.com" required>
              </div>
              <div>
                <label class="form-label">Subject / Requirement *</label>
                <input type="text" name="subject" class="form-control" placeholder="e.g. Employee Welcome Kit / Banners" required>
              </div>
              <div class="form-group-full">
                <label class="form-label">Project Details & Quantity *</label>
                <textarea name="message" class="form-control" placeholder="Tell us about the quantity, material preferences, dimensions, and your required completion date..." required></textarea>
              </div>
              <div class="form-group-full">
                <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">
                  <i class="fa-solid fa-paper-plane"></i>
                  <span>Submit Inquiry</span>
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>

      <!-- Embedded Google Map -->
      <div style="margin-top:60px;border-radius:var(--radius-xl);overflow:hidden;box-shadow:var(--shadow-lg);border:1px solid var(--color-border);">
        <iframe src="$($contact.googleMapsEmbed)" width="100%" height="450" style="border:0;display:block;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade" title="Ganesha Enterprises Naraina Location"></iframe>
      </div>
    </div>
  </section>
"@

$cHtml += Get-Footer -depth 0
Set-Content -Path "contact.html" -Value $cHtml -Encoding UTF8
Write-Host "Built contact.html successfully!"

# --------------------------------------------------------------------------
# BUILD 10: privacy-policy.html & terms-and-conditions.html
# --------------------------------------------------------------------------
Write-Host "Building legal policy pages..."
$privHtml = Get-Head -title "Privacy Policy | Ganesha Enterprises" -desc "Privacy Policy for Ganesha Enterprises print and branding services." -depth 0
$privHtml += Get-TopBar -depth 0
$privHtml += Get-Header -activePage "privacy" -depth 0
$privHtml += @"
  <section class="section-sm bg-white" style="border-bottom:1px solid var(--color-border);">
    <div class="container">
      <h1 class="display-1" style="font-size:2.5rem;">Privacy Policy</h1>
      <p style="color:var(--color-text-muted);">Last Updated: October 2026</p>
    </div>
  </section>
  <section class="section bg-white">
    <div class="container" style="max-width:800px;font-size:1.05rem;line-height:1.8;">
      <h2 style="margin-bottom:12px;">1. Information We Collect</h2>
      <p style="margin-bottom:24px;">At Ganesha Enterprises, we respect your privacy. When you request a quote, submit an inquiry, or place a print order, we collect information such as your name, corporate business name, email address, phone number, delivery address, and artwork assets needed to execute your printing requests.</p>

      <h2 style="margin-bottom:12px;">2. Use of Information</h2>
      <p style="margin-bottom:24px;">We use your contact and specification data solely for preparing pricing estimates, delivering physical sample proofs, communicating regarding project progress, and fulfilling logistics delivery. We do not sell or lease customer information to third-party advertisers.</p>

      <h2 style="margin-bottom:12px;">3. Artwork & Intellectual Property</h2>
      <p style="margin-bottom:24px;">All logos, brand guidelines, and graphics uploaded or supplied for printing remain the intellectual property of their respective owners. We treat all commercial files with high confidentiality.</p>

      <h2 style="margin-bottom:12px;">4. Contact Us</h2>
      <p>If you have any questions regarding our privacy practices, contact us directly at <a href="mailto:vineet@ganeshaenterprises.in" style="color:var(--color-accent);font-weight:600;">vineet@ganeshaenterprises.in</a> or call <a href="tel:9650044234" style="color:var(--color-accent);font-weight:600;">+91-9650044234</a>.</p>
    </div>
  </section>
"@
$privHtml += Get-Footer -depth 0
Set-Content -Path "privacy-policy.html" -Value $privHtml -Encoding UTF8

$termsHtml = Get-Head -title "Terms and Conditions | Ganesha Enterprises" -desc "Terms and conditions for custom printing and branding orders at Ganesha Enterprises." -depth 0
$termsHtml += Get-TopBar -depth 0
$termsHtml += Get-Header -activePage "terms" -depth 0
$termsHtml += @"
  <section class="section-sm bg-white" style="border-bottom:1px solid var(--color-border);">
    <div class="container">
      <h1 class="display-1" style="font-size:2.5rem;">Terms and Conditions</h1>
      <p style="color:var(--color-text-muted);">Last Updated: October 2026</p>
    </div>
  </section>
  <section class="section bg-white">
    <div class="container" style="max-width:800px;font-size:1.05rem;line-height:1.8;">
      <h2 style="margin-bottom:12px;">1. Order Approvals & Proofing</h2>
      <p style="margin-bottom:24px;">Before production commences, digital proofs or physical samples are shared with the client for verification of content, layout, dimensions, and typography. Approval signifies authorization to print as presented.</p>

      <h2 style="margin-bottom:12px;">2. Turnaround & Delivery</h2>
      <p style="margin-bottom:24px;">Standard orders are dispatched within 2-5 business days. Rush orders are accommodated based on press capacity. Delivery times depend on courier logistics and destination location.</p>

      <h2 style="margin-bottom:12px;">3. Payment Terms</h2>
      <p style="margin-bottom:24px;">Commercial and custom merchandise orders are executed in accordance with agreed proforma invoices and purchase orders.</p>

      <h2 style="margin-bottom:12px;">4. Governing Law</h2>
      <p>All transactions and terms are subject to the jurisdiction of the courts of New Delhi, India.</p>
    </div>
  </section>
"@
$termsHtml += Get-Footer -depth 0
Set-Content -Path "terms-and-conditions.html" -Value $termsHtml -Encoding UTF8

# --------------------------------------------------------------------------
# BUILD 11: Compatibility redirects for legacy URLs
# --------------------------------------------------------------------------
function Create-Redirect($fromFile, $toUrl) {
    $rHtml = @"
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Redirecting to Ganesha Enterprises...</title>
  <meta http-equiv="refresh" content="0; url=$toUrl">
  <link rel="canonical" href="$toUrl">
</head>
<body>
  <p>Redirecting to <a href="$toUrl">$toUrl</a>...</p>
  <script>window.location.replace("$toUrl");</script>
</body>
</html>
"@
    Set-Content -Path $fromFile -Value $rHtml -Encoding UTF8
}

Create-Redirect "about_us.html" "about.html"
Create-Redirect "service.html" "services.html"
Create-Redirect "shop.html" "products.html"
Create-Redirect "shop _Business_Essentials.html" "products.html?category=business-essentials"
Create-Redirect "shop _Love_Your_New_Look.html" "products.html?category=love-your-new-look"
Create-Redirect "shop_Made_by_You.html" "products.html?category=made-by-you"
Create-Redirect "shop_Home_&_Gifts.html" "products.html?category=home-gifts"
Create-Redirect "blog_grid.html" "blog.html"
Create-Redirect "blog_1.html" "blog/why-custom-printing-is-the-secret-weapon.html"
Create-Redirect "blog_2.html" "blog/t-shirts-to-tumblers-top-10-custom-products.html"
Create-Redirect "service-details.html" "services.html"
Create-Redirect "portfolio-details.html" "portfolio.html"
Create-Redirect "blog-details.html" "blog.html"

# --------------------------------------------------------------------------
# BUILD 12: robots.txt & sitemap.xml
# --------------------------------------------------------------------------
$robots = @"
User-agent: *
Allow: /
Sitemap: https://ganeshaenterprises.in/sitemap.xml
"@
Set-Content -Path "robots.txt" -Value $robots -Encoding UTF8

$sitemap = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://ganeshaenterprises.in/</loc><priority>1.0</priority></url>
  <url><loc>https://ganeshaenterprises.in/about.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/services.html</loc><priority>0.9</priority></url>
  <url><loc>https://ganeshaenterprises.in/services/corporate-office-printing.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/services/marketing-promotional-printing.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/services/customized-merchandise.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/services/packaging-labels.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/services/large-format-event-printing.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/services/books-photo-products.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/services/premium-finishing.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/services/digital-personalized-printing.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/products.html</loc><priority>0.9</priority></url>
  <url><loc>https://ganeshaenterprises.in/portfolio.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/blog.html</loc><priority>0.7</priority></url>
  <url><loc>https://ganeshaenterprises.in/blog/why-custom-printing-is-the-secret-weapon.html</loc><priority>0.7</priority></url>
  <url><loc>https://ganeshaenterprises.in/blog/t-shirts-to-tumblers-top-10-custom-products.html</loc><priority>0.7</priority></url>
  <url><loc>https://ganeshaenterprises.in/contact.html</loc><priority>0.8</priority></url>
  <url><loc>https://ganeshaenterprises.in/privacy-policy.html</loc><priority>0.3</priority></url>
  <url><loc>https://ganeshaenterprises.in/terms-and-conditions.html</loc><priority>0.3</priority></url>
</urlset>
"@
Set-Content -Path "sitemap.xml" -Value $sitemap.Trim() -Encoding UTF8
Write-Host "Generated robots.txt & sitemap.xml successfully!"
Write-Host "=== COMPLETE SITE BUILD FINISHED! ==="
