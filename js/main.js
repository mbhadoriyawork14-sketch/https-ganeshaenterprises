/* ==========================================================================
   GANESHA ENTERPRISES - CORE JAVASCRIPT CONTROLLER
   Responsive Interactions, Navigation, Catalog Filtering & Honest Forms
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  initNavigation();
  initFaqAccordion();
  initProductFilter();
  initQuoteModal();
  initForms();
  initHeroVideo();
  initProductShowcase();
});

/* --------------------------------------------------------------------------
   1. NAVIGATION & MOBILE DRAWER
   -------------------------------------------------------------------------- */
function initNavigation() {
  const mobileToggle = document.getElementById('mobileToggle');
  const mobileDrawer = document.getElementById('mobileDrawer');
  const mobileOverlay = document.getElementById('mobileOverlay');
  const drawerClose = document.getElementById('drawerClose');
  const header = document.querySelector('.header-sticky');

  function openDrawer() {
    if (mobileDrawer) mobileDrawer.classList.add('open');
    if (mobileOverlay) mobileOverlay.classList.add('open');
    document.body.style.overflow = 'hidden';
  }

  function closeDrawer() {
    if (mobileDrawer) mobileDrawer.classList.remove('open');
    if (mobileOverlay) mobileOverlay.classList.remove('open');
    document.body.style.overflow = '';
  }

  if (mobileToggle) mobileToggle.addEventListener('click', openDrawer);
  if (drawerClose) drawerClose.addEventListener('click', closeDrawer);
  if (mobileOverlay) mobileOverlay.addEventListener('click', closeDrawer);

  // Close drawer on ESC
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeDrawer();
  });

  // Sticky header shadow on scroll
  window.addEventListener('scroll', () => {
    if (header) {
      if (window.scrollY > 30) {
        header.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.08)';
      } else {
        header.style.boxShadow = 'none';
      }
    }
  });
}

/* --------------------------------------------------------------------------
   2. FAQ ACCORDION
   -------------------------------------------------------------------------- */
function initFaqAccordion() {
  const faqItems = document.querySelectorAll('.faq-item');
  faqItems.forEach(item => {
    const questionBtn = item.querySelector('.faq-question');
    if (questionBtn) {
      questionBtn.addEventListener('click', () => {
        const isActive = item.classList.contains('active');
        // Close other items
        faqItems.forEach(other => {
          if (other !== item) other.classList.remove('active');
        });
        // Toggle current item
        if (!isActive) {
          item.classList.add('active');
        } else {
          item.classList.remove('active');
        }
      });
    }
  });
}

/* --------------------------------------------------------------------------
   3. PRODUCT CATALOG LIVE FILTERING & SEARCH
   -------------------------------------------------------------------------- */
function initProductFilter() {
  const filterBtns = document.querySelectorAll('.filter-btn');
  const productCards = document.querySelectorAll('.product-card');
  const searchInput = document.getElementById('productSearchInput');
  const productCountDisplay = document.getElementById('productCountDisplay');

  // Check URL query parameters for pre-selected category
  const urlParams = new URLSearchParams(window.location.search);
  const initialCategory = urlParams.get('category');

  if (initialCategory && filterBtns.length > 0) {
    filterBtns.forEach(btn => {
      if (btn.dataset.category === initialCategory) {
        filterBtns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
      }
    });
  }

  function applyFilter() {
    const activeBtn = document.querySelector('.filter-btn.active');
    const selectedCat = activeBtn ? activeBtn.dataset.category : 'all';
    const query = searchInput ? searchInput.value.toLowerCase().trim() : '';

    let visibleCount = 0;

    productCards.forEach(card => {
      const cardCategory = card.dataset.category;
      const cardTitle = card.querySelector('.product-title')?.textContent.toLowerCase() || '';

      const matchesCat = (selectedCat === 'all' || cardCategory === selectedCat);
      const matchesSearch = (!query || cardTitle.includes(query));

      if (matchesCat && matchesSearch) {
        card.style.display = 'flex';
        visibleCount++;
      } else {
        card.style.display = 'none';
      }
    });

    if (productCountDisplay) {
      productCountDisplay.textContent = `Showing ${visibleCount} products`;
    }
  }

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      applyFilter();
    });
  });

  if (searchInput) {
    searchInput.addEventListener('input', applyFilter);
  }

  // Initial trigger
  if (productCards.length > 0) {
    applyFilter();
  }
}

/* --------------------------------------------------------------------------
   4. INTERACTIVE QUOTE MODAL (WITH PREPOPULATED PRODUCT/SERVICE)
   -------------------------------------------------------------------------- */
function initQuoteModal() {
  const modal = document.getElementById('quoteModal');
  const modalClose = document.getElementById('modalClose');
  const quoteItemInput = document.getElementById('modalRequirementInput');
  const openButtons = document.querySelectorAll('[data-open-quote]');

  function openModal(itemName = '') {
    if (modal) {
      modal.classList.add('open');
      document.body.style.overflow = 'hidden';
      if (quoteItemInput && itemName) {
        quoteItemInput.value = `Inquiry for: ${itemName}`;
      }
    }
  }

  function closeModal() {
    if (modal) {
      modal.classList.remove('open');
      document.body.style.overflow = '';
    }
  }

  openButtons.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      const targetName = btn.dataset.productName || btn.dataset.serviceName || '';
      openModal(targetName);
    });
  });

  if (modalClose) modalClose.addEventListener('click', closeModal);

  if (modal) {
    modal.addEventListener('click', (e) => {
      if (e.target === modal) closeModal();
    });
  }

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && modal && modal.classList.contains('open')) {
      closeModal();
    }
  });

  // Global helper for opening from anywhere
  window.openQuoteFor = openModal;
}

/* --------------------------------------------------------------------------
   5. HONEST FORM SUBMISSION & DIRECT WHATSAPP / EMAIL ROUTING
   -------------------------------------------------------------------------- */
function initForms() {
  const contactForms = document.querySelectorAll('form[data-ajax-form]');

  contactForms.forEach(form => {
    form.addEventListener('submit', (e) => {
      e.preventDefault();

      const name = form.querySelector('[name="name"]')?.value || '';
      const email = form.querySelector('[name="email"]')?.value || '';
      const phone = form.querySelector('[name="phone"]')?.value || '';
      const requirement = form.querySelector('[name="subject"]')?.value || form.querySelector('[name="requirement"]')?.value || 'Custom Printing Requirement';
      const message = form.querySelector('[name="message"]')?.value || '';

      if (!name || (!email && !phone)) {
        showToast('Please provide your name and at least an email or phone number.');
        return;
      }

      // Format WhatsApp message for instant delivery to +919650044234
      const whatsappText = encodeURIComponent(
        `Hello Ganesha Enterprises,\n\nI would like to request a quote:\n` +
        `• Name: ${name}\n` +
        `• Phone: ${phone}\n` +
        `• Email: ${email}\n` +
        `• Requirement: ${requirement}\n` +
        `• Details: ${message}\n\n` +
        `Please share pricing and timeline.`
      );

      // Show user immediate transparent feedback
      showToast('Thank you! Redirecting to WhatsApp to send your details directly to our printing specialists...');

      setTimeout(() => {
        window.open(`https://wa.me/919650044234?text=${whatsappText}`, '_blank');
        form.reset();
        const modal = document.getElementById('quoteModal');
        if (modal) modal.classList.remove('open');
        document.body.style.overflow = '';
      }, 1200);
    });
  });
}

function showToast(msg) {
  let toast = document.getElementById('siteToast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'siteToast';
    toast.className = 'toast-notice';
    document.body.appendChild(toast);
  }

  toast.innerHTML = `
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
      <polyline points="22 4 12 14.01 9 11.01"></polyline>
    </svg>
    <span>${msg}</span>
  `;

  toast.classList.add('show');
  setTimeout(() => {
    toast.classList.remove('show');
  }, 4000);
}

/* --------------------------------------------------------------------------
   6. HERO SEAMLESS BACKGROUND VIDEO HANDLER
   -------------------------------------------------------------------------- */
function initHeroVideo() {
  const video = document.querySelector('.hero-background-video') || document.querySelector('.hero-video');
  if (!video) return;

  // Guarantee muted and playsinline attributes for unrestricted modern browser autoplay compliance
  video.muted = true;
  video.defaultMuted = true;
  video.playsInline = true;
  video.setAttribute('muted', '');
  video.setAttribute('playsinline', '');

  const playVideo = () => {
    const playPromise = video.play();
    if (playPromise !== undefined) {
      playPromise.then(() => {
        // Video playing smoothly
      }).catch((err) => {
        console.warn('Hero video autoplay notice (will retry on interaction):', err);
      });
    }
  };

  if (video.readyState >= 2) {
    playVideo();
  } else {
    video.addEventListener('canplay', playVideo, { once: true });
    video.addEventListener('loadeddata', playVideo, { once: true });
  }

  // Fallback: Ensure playback starts on first touch/click/scroll if browser held it back
  const onUserInteract = () => {
    if (video.paused) {
      playVideo();
    }
    window.removeEventListener('click', onUserInteract);
    window.removeEventListener('touchstart', onUserInteract);
    window.removeEventListener('scroll', onUserInteract);
  };
  window.addEventListener('click', onUserInteract, { passive: true });
  window.addEventListener('touchstart', onUserInteract, { passive: true });
  window.addEventListener('scroll', onUserInteract, { passive: true });

  // Conserve device battery and CPU cycles when user switches tabs
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
      video.pause();
    } else {
      playVideo();
    }
  });
}

/* --------------------------------------------------------------------------
   7. PREMIUM EDITORIAL PRODUCT SHOWCASE & APPLE-INSPIRED MOTION
   Scroll Stagger Reveals, Tactile Hover, and Accessible Lightbox Modal
   -------------------------------------------------------------------------- */
const showcaseProjects = [
  {
    id: 'custom-jute-tote-bag',
    title: 'Custom Embroidered Jute Tote Bag',
    client: 'Retail & Merchandise',
    category: 'Custom Bags & Apparel',
    image: 'assets/imgs/Our Work/WhatsApp Image 2025-06-20 at 19.14.39.jpeg',
    objectPosition: 'center center',
    desc: 'High-durability natural golden jute tote bag crafted with reinforced padded cotton rope handles, laminated water-resistant interior lining, and intricate multi-thread metallic gold geometric embroidery.',
    substrate: 'Premium Natural Laminated Jute',
    technique: 'Multi-Thread Computerized Gold Embroidery',
    turnaround: '3–5 Business Days pan-India',
    minOrder: '100 Units'
  },
  {
    id: 'vistara-executive-notebook',
    title: 'Executive Vegan Leather Notebook & Pen Set',
    client: 'Vistara Airlines',
    category: 'Corporate Stationery',
    image: 'assets/imgs/Our Work/WhatsApp Image 2025-06-20 at 19.16.24.jpeg',
    objectPosition: 'center 35%',
    desc: 'Bespoke corporate executive notebook with supple saddle-tan vegan PU leather cover, integrated magnetic spine pen-holder sleeve, custom debossed Vistara branding, and matching laser-engraved luxury ballpoint pen.',
    substrate: '100gsm Acid-Free Ivory Paper & Vegan PU',
    technique: 'Precision Blind Debossing & Laser Engraving',
    turnaround: '2–4 Business Days',
    minOrder: '50 Sets'
  },
  {
    id: 'ntpc-corporate-cap',
    title: 'Branded Event Twill Baseball Cap',
    client: 'NTPC',
    category: 'Apparel & Headwear',
    image: 'assets/imgs/Our Work/WhatsApp Image 2025-06-20 at 19.18.36.jpeg',
    objectPosition: 'center 25%',
    desc: 'Structured 6-panel athletic baseball cap produced in bright white heavy brushed cotton twill. Features vibrant high-density 3D embroidery of the official "Yoga for One Earth, One Health" emblem alongside corporate NTPC insignia.',
    substrate: 'Heavyweight Brushed 100% Cotton Twill',
    technique: 'Multi-Thread High-Density Direct Embroidery',
    turnaround: '3–5 Business Days',
    minOrder: '100 Caps'
  },
  {
    id: 'gratitude-vacuum-flask',
    title: 'Matte Black Laser-Engraved Vacuum Flask',
    client: 'Sargam Steels',
    category: 'Drinkware & Executive Gifts',
    image: 'assets/imgs/Our Work/WhatsApp Image 2025-06-26 at 11.24.22.jpeg',
    objectPosition: 'center 35%',
    desc: 'Double-wall insulated vacuum thermal bottle in velvet matte black finish, engineered to retain beverage temperature for 24 hours. Custom laser rotary etched with elegant cursive "Gratitude" and corporate branding.',
    substrate: 'Food-Grade 304 Stainless Steel (500ml)',
    technique: 'Precision Fiber Laser Rotary Engraving',
    turnaround: '2–4 Business Days',
    minOrder: '50 Units'
  },
  {
    id: 'trot-hotels-desk-calendar',
    title: 'Handcrafted Pine Wood Easel Desk Calendar',
    client: 'Trot Hotels',
    category: 'Calendars & Desk Décor',
    image: 'assets/imgs/Our Work/WhatsApp Image 2025-06-26 at 11.24.20.jpeg',
    objectPosition: 'center center',
    desc: 'Minimalist executive desktop calendar featuring a smooth natural solid pine easel stand supporting 12 individual monthly date cards printed on textured fine art stock with precision die-cut rounded corners.',
    substrate: 'Natural Pine Wood + 300gsm Art Board',
    technique: 'High-Gamut 4-Color Digital Offset + Die-Cutting',
    turnaround: '3–5 Business Days',
    minOrder: '100 Units'
  },
  {
    id: 'air-india-event-badges',
    title: 'Air India #IamCPRReady Event Button Badges',
    client: 'Air India',
    category: 'Event Merchandise & Badges',
    image: 'assets/imgs/Our Work/WhatsApp Image 2025-06-26 at 11.24.23.jpeg',
    objectPosition: 'center center',
    desc: 'Vibrant round event button badges designed for Air India’s #IamCPRReady health & emergency awareness campaign. Features rich corporate purple color matching, high-gloss protective mylar film, and nickel-plated safety pin backing.',
    substrate: 'Rust-Resistant Tinplate Shell + Gloss Mylar Shield',
    technique: 'High-Resolution Pantone Digital Print & Die-Press',
    turnaround: '24–48 Hours Pan-India',
    minOrder: '200 Badges'
  }
];

function initProductShowcase() {
  const showcaseSection = document.getElementById('productShowcase');
  if (!showcaseSection) return;

  // 1. Apple-Inspired Scroll-Triggered Reveal via IntersectionObserver
  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          showcaseSection.classList.add('is-revealed');
          observer.unobserve(entry.target);
        }
      });
    }, {
      root: null,
      threshold: 0.12,
      rootMargin: '0px 0px -40px 0px'
    });

    observer.observe(showcaseSection);
  } else {
    // Fallback for older browsers
    showcaseSection.classList.add('is-revealed');
  }

  // 2. Interactive Lightbox Modal Controller
  const modal = document.getElementById('showcaseModal');
  if (!modal) return;

  const modalImg = modal.querySelector('.showcase-modal-img');
  const modalClient = modal.querySelector('.showcase-modal-client span');
  const modalCategory = modal.querySelector('.showcase-modal-category');
  const modalTitle = modal.querySelector('.showcase-modal-title');
  const modalDesc = modal.querySelector('.showcase-modal-desc');
  const modalSubstrate = modal.querySelector('[data-spec="substrate"]');
  const modalTechnique = modal.querySelector('[data-spec="technique"]');
  const modalTurnaround = modal.querySelector('[data-spec="turnaround"]');
  const modalMinOrder = modal.querySelector('[data-spec="minorder"]');
  const modalWhatsAppBtn = modal.querySelector('.showcase-modal-whatsapp');
  const modalCloseBtn = modal.querySelector('.showcase-modal-close');
  const modalBackdrop = modal.querySelector('.showcase-modal-backdrop');
  const navPrevBtn = modal.querySelector('.showcase-modal-nav.prev');
  const navNextBtn = modal.querySelector('.showcase-modal-nav.next');

  let currentProjectIndex = 0;
  let lastFocusedElement = null;

  function renderModalProject(index) {
    const project = showcaseProjects[index];
    if (!project) return;

    currentProjectIndex = index;

    if (modalImg) {
      modalImg.style.opacity = '0';
      setTimeout(() => {
        modalImg.src = project.image;
        modalImg.alt = project.title;
        modalImg.style.objectPosition = project.objectPosition || 'center center';
        modalImg.style.opacity = '1';
      }, 150);
    }

    if (modalClient) modalClient.textContent = project.client;
    if (modalCategory) modalCategory.textContent = project.category;
    if (modalTitle) modalTitle.textContent = project.title;
    if (modalDesc) modalDesc.textContent = project.desc;
    if (modalSubstrate) modalSubstrate.textContent = project.substrate;
    if (modalTechnique) modalTechnique.textContent = project.technique;
    if (modalTurnaround) modalTurnaround.textContent = project.turnaround;
    if (modalMinOrder) modalMinOrder.textContent = project.minOrder;

    if (modalWhatsAppBtn) {
      const msg = encodeURIComponent(`Hello Ganesha Enterprises, I am inquiring about the ${project.title} (${project.client}) showcased on your website.`);
      modalWhatsAppBtn.href = `https://wa.me/919650044234?text=${msg}`;
    }
  }

  function openModal(index) {
    lastFocusedElement = document.activeElement;
    renderModalProject(index);
    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';

    // Focus close button for accessibility
    setTimeout(() => {
      if (modalCloseBtn) modalCloseBtn.focus();
    }, 100);
  }

  function closeModal() {
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
    if (lastFocusedElement && typeof lastFocusedElement.focus === 'function') {
      lastFocusedElement.focus();
    }
  }

  function nextProject() {
    const nextIdx = (currentProjectIndex + 1) % showcaseProjects.length;
    renderModalProject(nextIdx);
  }

  function prevProject() {
    const prevIdx = (currentProjectIndex - 1 + showcaseProjects.length) % showcaseProjects.length;
    renderModalProject(prevIdx);
  }

  // Attach click and keyboard events to showcase tiles
  const tiles = showcaseSection.querySelectorAll('.showcase-tile');
  tiles.forEach((tile, idx) => {
    tile.addEventListener('click', (e) => {
      e.preventDefault();
      openModal(idx);
    });

    tile.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        openModal(idx);
      }
    });

    const plusBtn = tile.querySelector('.showcase-plus-btn');
    if (plusBtn) {
      plusBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        openModal(idx);
      });
    }
  });

  // Modal controls
  if (modalCloseBtn) modalCloseBtn.addEventListener('click', closeModal);
  if (modalBackdrop) modalBackdrop.addEventListener('click', closeModal);
  if (navNextBtn) navNextBtn.addEventListener('click', nextProject);
  if (navPrevBtn) navPrevBtn.addEventListener('click', prevProject);

  // Keyboard accessibility (Esc to close, Arrow keys to navigate, Tab trap)
  document.addEventListener('keydown', (e) => {
    if (!modal.classList.contains('is-open')) return;

    if (e.key === 'Escape') {
      closeModal();
    } else if (e.key === 'ArrowRight') {
      nextProject();
    } else if (e.key === 'ArrowLeft') {
      prevProject();
    } else if (e.key === 'Tab') {
      // Focus trap within modal
      const focusableElements = modal.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
      if (focusableElements.length === 0) return;

      const firstElement = focusableElements[0];
      const lastElement = focusableElements[focusableElements.length - 1];

      if (e.shiftKey) {
        if (document.activeElement === firstElement) {
          e.preventDefault();
          lastElement.focus();
        }
      } else {
        if (document.activeElement === lastElement) {
          e.preventDefault();
          firstElement.focus();
        }
      }
    }
  });
}

