// Language Switcher Functionality
class LanguageSwitcher {
  constructor() {
    this.currentLanguage = localStorage.getItem('preferredLanguage') || 'en';
    this.translations = {
      en: {
        site: {
          title: "SMILE Platform Documentation",
          description: "Documentation for the SMILE Digital Public Good (DPG) platform"
        },
        nav: {
          documentation: "Documentation",
          about: "About",
          contact: "Contact"
        },
        hero: {
          title: "SMILE Platform Documentation",
          subtitle: "SMILE (Sistem Monitoring Imunisasi dan Logistik secara Elektronik) is a system that helps healthcare workers record and monitor vaccine ordering, distribution, and logistics in real-time. Developed jointly by the Ministry of Health of Indonesia and UNDP Indonesia since 2018, SMILE has evolved into a robust Digital Public Good that supports multiple Sustainable Development Goals (SDGs).",
          stats: {
            core_documents: "Core Documents",
            since: "Since",
            sdgs_supported: "SDGs Supported"
          }
        },
        dashboard: {
          title: "Executive Dashboard",
          metrics: {
            total_vaccine: "Total Vaccine Distribution",
            damaged: "Damaged Vaccines",
            broken: "Broken Vaccines",
            expired: "Expired Vaccines"
          },
          charts: {
            stock_status: "Stock Availability Status",
            distribution_by_level: "Vaccine Distribution by Level",
            temperature_status: "Vaccine Refrigerator Temperature Status",
            national_flow: "National Vaccine Distribution Flow"
          }
        },
        about: {
          title: "About SMILE",
          description1: "SMILE (Sistem Monitoring Imunisasi dan Logistik secara Elektronik) is a system that helps healthcare workers record and monitor vaccine ordering, distribution, and logistics in real-time. Developed jointly by the Ministry of Health of Indonesia and UNDP Indonesia since 2018, SMILE has evolved into a robust Digital Public Good that supports multiple Sustainable Development Goals (SDGs).",
          description2: "The platform has been successfully deployed across multiple regions, improving healthcare supply chain management and ensuring equitable distribution of medical resources to communities in need."
        },
        footer: {
          privacy: "Privacy Policy",
          terms: "Terms of Use",
          support: "Support",
          copyright: "© 2024 SMILE Platform. A Digital Public Good initiative."
        },
        docs: {
          dpg_tracker: "DPG Tasks Tracker",
          dpg_description: "Track immediate tasks, governance requirements, and evidence needed for DPG preparation and compliance.",
          deployment_guide: "Deployment Guide",
          deployment_description: "Comprehensive guide for deploying SMILE5 on AWS, including prerequisites, configuration, and troubleshooting.",
          technical_overview: "Technical Overview",
          technical_description: "Centralized technical documentation covering technologies, frameworks, data pipeline, and infrastructure.",
          cloud_infrastructure: "Cloud Infrastructure",
          cloud_description: "Detailed architecture and setup of SMILE's cloud infrastructure on AWS, including networking and security.",
          data_streaming: "Data Streaming",
          streaming_description: "Documentation of SMILE's data streaming architecture, including real-time data processing and integration.",
          view_source: "View Source",
          view_html: "View HTML"
        }
      },
      id: {
        site: {
          title: "Dokumentasi Platform SMILE",
          description: "Dokumentasi untuk platform Digital Public Good (DPG) SMILE"
        },
        nav: {
          documentation: "Dokumentasi",
          about: "Tentang",
          contact: "Kontak"
        },
        hero: {
          title: "Dokumentasi Platform SMILE",
          subtitle: "SMILE (Sistem Monitoring Imunisasi dan Logistik secara Elektronik) adalah sistem yang membantu tenaga kesehatan dalam mencatat dan memantau pemesanan, distribusi, dan logistik vaksin secara real-time. Dikembangkan bersama oleh Kementerian Kesehatan Indonesia dan UNDP Indonesia sejak tahun 2018, SMILE telah berkembang menjadi Digital Public Good yang kuat yang mendukung beberapa Tujuan Pembangunan Berkelanjutan (SDGs).",
          stats: {
            core_documents: "Dokumen Inti",
            since: "Sejak",
            sdgs_supported: "SDG Didukung"
          }
        },
        dashboard: {
          title: "Dashboard Eksekutif",
          metrics: {
            total_vaccine: "Total Penyebaran Vaksin",
            damaged: "Vaksin Rusak",
            broken: "Vaksin Pecah",
            expired: "Vaksin Kedaluwarsa"
          },
          charts: {
            stock_status: "Status Ketersediaan Stok",
            distribution_by_level: "Distribusi Vaksin per Tingkat",
            temperature_status: "Status Suhu Kulkas Vaksin",
            national_flow: "Alur Distribusi Vaksin Nasional"
          }
        },
        about: {
          title: "Tentang SMILE",
          description1: "SMILE (Sistem Monitoring Imunisasi dan Logistik secara Elektronik) adalah sistem yang membantu tenaga kesehatan dalam mencatat dan memantau pemesanan, distribusi, dan logistik vaksin secara real-time. Dikembangkan bersama oleh Kementerian Kesehatan Indonesia dan UNDP Indonesia sejak tahun 2018, SMILE telah berkembang menjadi Digital Public Good yang kuat yang mendukung beberapa Tujuan Pembangunan Berkelanjutan (SDGs).",
          description2: "Platform ini telah berhasil diterapkan di berbagai wilayah, meningkatkan manajemen rantai pasokan layanan kesehatan dan memastikan distribusi sumber daya medis yang adil kepada komunitas yang membutuhkan."
        },
        footer: {
          privacy: "Kebijakan Privasi",
          terms: "Ketentuan Penggunaan",
          support: "Dukungan",
          copyright: "© 2024 Platform SMILE. Inisiatif Digital Public Good."
        },
        docs: {
          dpg_tracker: "Pelacak Tugas DPG",
          dpg_description: "Lacak tugas langsung, persyaratan tata kelola, dan bukti yang diperlukan untuk persiapan dan kepatuhan DPG.",
          deployment_guide: "Panduan Deploy",
          deployment_description: "Panduan komprehensif untuk deploying SMILE5 di AWS, termasuk prasyarat, konfigurasi, dan pemecahan masalah.",
          technical_overview: "Ikhtisar Teknis",
          technical_description: "Dokumentasi teknis terpusat yang mencakup teknologi, kerangka kerja, alur data, dan infrastruktur.",
          cloud_infrastructure: "Infrastruktur Cloud",
          cloud_description: "Arsitektur dan penyiapan terperinci infrastruktur cloud SMILE di AWS, termasuk jaringan dan keamanan.",
          data_streaming: "Streaming Data",
          streaming_description: "Dokumentasi arsitektur streaming data SMILE, termasuk pemrosesan dan integrasi data real-time.",
          view_source: "Lihat Sumber",
          view_html: "Lihat HTML"
        }
      }
    };
    
    this.init();
  }

  init() {
    // Check URL parameter for language
    const urlParams = new URLSearchParams(window.location.search);
    const urlLang = urlParams.get('lang');
    if (urlLang && (urlLang === 'en' || urlLang === 'id')) {
      this.currentLanguage = urlLang;
      localStorage.setItem('preferredLanguage', urlLang);
    }

    this.setupEventListeners();
    this.applyLanguage(this.currentLanguage);
    this.updateLanguageDisplay();
  }

  setupEventListeners() {
    const toggle = document.getElementById('languageToggle');
    const dropdown = document.getElementById('languageDropdown');
    const options = document.querySelectorAll('.language-option');

    if (!toggle || !dropdown || options.length === 0) {
      console.error('Language switcher elements not found');
      return;
    }

    // Toggle dropdown
    toggle.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopPropagation();
      console.log('Toggle clicked');
      dropdown.classList.toggle('show');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.language-switcher')) {
        dropdown.classList.remove('show');
      }
    });

    // Language option clicks
    options.forEach(option => {
      option.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        console.log('Language option clicked:', option.dataset.lang);
        const lang = option.dataset.lang;
        this.switchLanguage(lang);
      });
    });
  }

  switchLanguage(lang) {
    if (lang !== this.currentLanguage) {
      console.log('Switching language to:', lang);
      this.currentLanguage = lang;
      localStorage.setItem('preferredLanguage', lang);
      this.applyLanguage(lang);
      this.updateLanguageDisplay();
      
      // Update URL to include language parameter
      const url = new URL(window.location);
      url.searchParams.set('lang', lang);
      window.history.replaceState({}, '', url);
      
      // Update document links to include language parameter
      this.updateDocumentLinks(lang);
    }
    document.getElementById('languageDropdown').classList.remove('show');
  }

  applyLanguage(lang) {
    const t = this.translations[lang];
    if (!t) return;

    // Update page title and meta
    document.title = t.site?.title || 'SMILE Platform';
    const metaDescription = document.querySelector('meta[name="description"]');
    if (metaDescription) {
      metaDescription.content = t.site?.description || '';
    }

    // Update navigation
    this.updateTextContent('[data-translate="nav-home"]', t.nav?.home);
    this.updateTextContent('[data-translate="nav-documentation"]', t.nav?.documentation);
    this.updateTextContent('[data-translate="nav-about"]', t.nav?.about);
    this.updateTextContent('[data-translate="nav-contact"]', t.nav?.contact);

    // Update hero section
    this.updateTextContent('[data-translate="hero-title"]', t.hero?.title);
    this.updateTextContent('[data-translate="hero-subtitle"]', t.hero?.subtitle);
    this.updateTextContent('[data-translate="stat-core-docs"]', t.hero?.stats?.core_documents);
    this.updateTextContent('[data-translate="stat-since"]', t.hero?.stats?.since);
    this.updateTextContent('[data-translate="stat-sdgs"]', t.hero?.stats?.sdgs_supported);

    // Update dashboard
    this.updateTextContent('[data-translate="dashboard-title"]', t.dashboard?.title);
    this.updateTextContent('[data-translate="metric-total"]', t.dashboard?.metrics?.total_vaccine);
    this.updateTextContent('[data-translate="metric-damaged"]', t.dashboard?.metrics?.damaged);
    this.updateTextContent('[data-translate="metric-broken"]', t.dashboard?.metrics?.broken);
    this.updateTextContent('[data-translate="metric-expired"]', t.dashboard?.metrics?.expired);
    this.updateTextContent('[data-translate="chart-stock"]', t.dashboard?.charts?.stock_status);
    this.updateTextContent('[data-translate="chart-distribution"]', t.dashboard?.charts?.distribution_by_level);
    this.updateTextContent('[data-translate="chart-temperature"]', t.dashboard?.charts?.temperature_status);
    this.updateTextContent('[data-translate="chart-flow"]', t.dashboard?.charts?.national_flow);

    // Update about section
    this.updateTextContent('[data-translate="about-title"]', t.about?.title);
    this.updateTextContent('[data-translate="about-desc-1"]', t.about?.description1);
    this.updateTextContent('[data-translate="about-desc-2"]', t.about?.description2);

    // Update footer
    this.updateTextContent('[data-translate="footer-privacy"]', t.footer?.privacy);
    this.updateTextContent('[data-translate="footer-terms"]', t.footer?.terms);
    this.updateTextContent('[data-translate="footer-support"]', t.footer?.support);
    this.updateTextContent('[data-translate="footer-copyright"]', t.footer?.copyright);

    // Update document cards
    this.updateTextContent('[data-translate="doc-dpg-title"]', t.docs?.dpg_tracker);
    this.updateTextContent('[data-translate="doc-dpg-desc"]', t.docs?.dpg_description);
    this.updateTextContent('[data-translate="doc-deploy-title"]', t.docs?.deployment_guide);
    this.updateTextContent('[data-translate="doc-deploy-desc"]', t.docs?.deployment_description);
    this.updateTextContent('[data-translate="doc-tech-title"]', t.docs?.technical_overview);
    this.updateTextContent('[data-translate="doc-tech-desc"]', t.docs?.technical_description);
    this.updateTextContent('[data-translate="doc-cloud-title"]', t.docs?.cloud_infrastructure);
    this.updateTextContent('[data-translate="doc-cloud-desc"]', t.docs?.cloud_description);
    this.updateTextContent('[data-translate="doc-streaming-title"]', t.docs?.data_streaming);
    this.updateTextContent('[data-translate="doc-streaming-desc"]', t.docs?.streaming_description);
    this.updateTextContent('[data-translate="view-source"]', t.docs?.view_source);
    this.updateTextContent('[data-translate="view-html"]', t.docs?.view_html);

    // Update HTML lang attribute
    document.documentElement.lang = lang;
  }

  updateTextContent(selector, text) {
    const elements = document.querySelectorAll(selector);
    elements.forEach(element => {
      if (text) {
        element.textContent = text;
      }
    });
  }

  updateLanguageDisplay() {
    const currentLangSpan = document.getElementById('currentLang');
    currentLangSpan.textContent = this.currentLanguage.toUpperCase();
  }

  updateDocumentLinks(lang) {
    // Update all documentation links to include language parameter
    const docLinks = document.querySelectorAll('.doc-link');
    docLinks.forEach(link => {
      const href = link.getAttribute('href');
      if (href && (href.endsWith('.md') || href.endsWith('.html'))) {
        if (lang === 'id') {
          // For Indonesian, redirect to id folder
          if (href.includes('docs/')) {
            const newHref = href.replace('docs/', 'docs/id/');
            link.setAttribute('href', newHref);
          }
        } else {
          // For English, ensure original path
          const newHref = href.replace('docs/id/', 'docs/');
          link.setAttribute('href', newHref);
        }
      }
    });
  }
}

// Initialize language switcher when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  console.log('Initializing language switcher...');
  new LanguageSwitcher();
});
