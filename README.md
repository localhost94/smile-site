# SMILE Platform Documentation

This repository contains the documentation for the SMILE (Sistem Monitoring Imunisasi dan Logistik Secara Elektronik) Digital Public Good (DPG) platform.

## Overview

SMILE is a comprehensive logistics management platform developed jointly by the Ministry of Health of Indonesia and UNDP Indonesia. Since its inception in 2018, SMILE has evolved into a robust Digital Public Good that addresses multiple Sustainable Development Goals (SDGs).

## Documentation Structure

### Core Documentation

- **[DPG Tasks Tracker](docs/dpg/tasks-tracker.md)** - Track immediate tasks, governance requirements, and evidence needed for DPG preparation and compliance
  - [View as HTML](assets/html/dpg-tasks-tracker.html) (GitHub Pages)
- **[Cloud Infrastructure](docs/cloud-infrastructure.md)** - Detailed architecture and setup of SMILE's cloud infrastructure on AWS
  - [View as HTML](assets/html/cloud-infrastructure.html) (GitHub Pages)
- **[Data Streaming Mechanism](docs/data-streaming.md)** - Documentation of SMILE's data streaming architecture
  - [View as HTML](assets/html/data-streaming.html) (GitHub Pages)
- **[Deployment and Installation Guide](docs/deployment-guide.md)** - Comprehensive guide for deploying SMILE5 on AWS
  - [View as HTML](assets/html/deployment-guide.html) (GitHub Pages)
- **[Technical Overview Document](docs/technical-overview.md)** - Centralized technical documentation covering technologies, frameworks, and infrastructure
  - [View as HTML](assets/html/technical-overview.html) (GitHub Pages)

## Getting Started

1. Clone this repository
2. Navigate to the `site` directory
3. Open `index.html` in your browser to view the documentation hub
4. Access documents either as markdown source or rendered HTML versions
5. Deploy to GitHub Pages or your preferred hosting platform

## Local Development

### Using Jekyll

```bash
# Install Jekyll and dependencies
gem install jekyll bundler

# Navigate to the site directory
cd site

# Install dependencies
bundle install

# Serve locally
bundle exec jekyll serve
```

### Using Python (Simple HTTP Server)

```bash
# Navigate to the site directory
cd site

# Start a simple HTTP server
python -m http.server 8000
```

Then visit `http://localhost:8000` in your browser.

## GitHub Pages

This site is configured to work with GitHub Pages. To deploy:

1. Push the repository to GitHub
2. Enable GitHub Pages in repository settings
3. Select the main branch as source
4. The site will be available at `https://yourusername.github.io/repository-name`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is part of the SMILE Digital Public Good initiative.

## Contact

For questions or support regarding SMILE platform documentation, please contact the development team.