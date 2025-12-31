// Language Switcher Functionality
class LanguageSwitcher {
  constructor() {
    this.currentLanguage = localStorage.getItem('preferredLanguage') || 'en';
    this.translations = {};
    this.init();
  }

  async init() {
    await this.loadTranslations();
    this.setupEventListeners();
    this.applyLanguage(this.currentLanguage);
    this.updateLanguageDisplay();
  }

  async loadTranslations() {
    try {
      const response = await fetch('./_data/translations.yml');
      const yamlText = await response.text();
      // Simple YAML parser for our specific structure
      this.translations = this.parseYaml(yamlText);
    } catch (error) {
      console.error('Error loading translations:', error);
    }
  }

  parseYaml(yamlText) {
    const lines = yamlText.split('\n');
    const result = { en: {}, id: {} };
    let currentLang = null;
    let currentSection = null;
    let currentSubsection = null;

    lines.forEach(line => {
      const trimmed = line.trim();
      
      if (trimmed === 'en:') {
        currentLang = 'en';
        currentSection = null;
        currentSubsection = null;
      } else if (trimmed === 'id:') {
        currentLang = 'id';
        currentSection = null;
        currentSubsection = null;
      } else if (currentLang && trimmed && !trimmed.startsWith('#')) {
        if (trimmed.endsWith(':')) {
          const key = trimmed.slice(0, -1);
          if (line.startsWith('  ')) {
            if (line.startsWith('    ')) {
              currentSubsection = key;
              if (!result[currentLang][currentSection]) {
                result[currentLang][currentSection] = {};
              }
              result[currentLang][currentSection][currentSubsection] = {};
            } else {
              currentSection = key;
              currentSubsection = null;
              result[currentLang][currentSection] = {};
            }
          }
        } else if (trimmed.includes(':')) {
          const [key, ...valueParts] = trimmed.split(':');
          const value = valueParts.join(':').trim().replace(/['"]/g, '');
          
          if (currentSubsection && currentSection) {
            result[currentLang][currentSection][currentSubsection][key.trim()] = value;
          } else if (currentSection) {
            result[currentLang][currentSection][key.trim()] = value;
          }
        }
      }
    });

    return result;
  }

  setupEventListeners() {
    const toggle = document.getElementById('languageToggle');
    const dropdown = document.getElementById('languageDropdown');
    const options = document.querySelectorAll('.language-option');

    toggle.addEventListener('click', (e) => {
      e.stopPropagation();
      dropdown.classList.toggle('show');
    });

    document.addEventListener('click', () => {
      dropdown.classList.remove('show');
    });

    options.forEach(option => {
      option.addEventListener('click', (e) => {
        e.preventDefault();
        const lang = option.dataset.lang;
        this.switchLanguage(lang);
      });
    });
  }

  switchLanguage(lang) {
    if (lang !== this.currentLanguage) {
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
  new LanguageSwitcher();
});
