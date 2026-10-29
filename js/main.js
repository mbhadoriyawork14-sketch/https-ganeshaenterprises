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
  initServiceCardAnimations();
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
   7. TOP 8 SERVICE VERTICALS - CONTINUOUS INFINITE SHOWCASE CONTROLLER
   -------------------------------------------------------------------------- */
function initServiceShowcase() {
  const section = document.getElementById('serviceVerticals') || document.querySelector('.service-verticals-section');
  if (!section) return;

  const track = section.querySelector('.service-showcase-track');
  if (!track) return;

  // Reduced-motion accessibility check
  if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    track.classList.remove('is-active');
    return;
  }

  // Smooth IntersectionObserver: activates animation when section scrolls into viewport,
  // and pauses offscreen to conserve CPU, battery, and GPU resources.
  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          track.classList.add('is-active');
        } else {
          track.classList.remove('is-active');
        }
      });
    }, {
      root: null,
      threshold: 0.05
    });
    observer.observe(section);
  } else {
    track.classList.add('is-active');
  }

  // Robust mouse enter / leave handlers to guarantee pause and hover zoom
  track.addEventListener('mouseenter', () => {
    track.classList.add('is-paused');
  });

  track.addEventListener('mouseleave', () => {
    track.classList.remove('is-paused');
  });

  const cards = track.querySelectorAll('.service-card');
  cards.forEach(card => {
    card.addEventListener('mouseenter', () => {
      card.classList.add('is-hovered');
    });
    card.addEventListener('mouseleave', () => {
      card.classList.remove('is-hovered');
    });
  });
}

// Retain alias for clean initialization
function initServiceCardAnimations() {
  initServiceShowcase();
}