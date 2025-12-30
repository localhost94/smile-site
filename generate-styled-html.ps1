# Generate styled HTML files for all documentation

# Read the original content files
$docsPath = "c:\Badr\UN ICC\Confluence\site\docs"
$originalHtmlPath = "c:\Badr\UN ICC\Confluence\html"
$targetPath = "c:\Badr\UN ICC\Confluence\site\assets\html"

# Function to create styled HTML
function Create-StyledHtml {
    param(
        [string]$Title,
        [string]$Subtitle,
        [string]$ContentFile,
        [string]$OutputFile,
        [string]$LastUpdated = "Unknown"
    )
    
    $template = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$Title</title>
    <link rel="stylesheet" href="../assets/styles/main.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        .confluence-wrapper {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        .confluence-content {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-xl);
            padding: 3rem;
            box-shadow: var(--shadow-lg);
            margin-top: 2rem;
        }
        .confluence-content h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 2rem;
            color: var(--text-primary);
            border-bottom: 3px solid var(--primary-color);
            padding-bottom: 0.5rem;
        }
        .confluence-content h2 {
            font-size: 2rem;
            font-weight: 600;
            margin-top: 2.5rem;
            margin-bottom: 1rem;
            color: var(--primary-dark);
        }
        .confluence-content h3 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-top: 2rem;
            margin-bottom: 1rem;
            color: var(--text-primary);
        }
        .confluence-content p {
            font-size: 1.125rem;
            line-height: 1.8;
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }
        .confluence-content ul, .confluence-content ol {
            margin-bottom: 1rem;
            padding-left: 2rem;
        }
        .confluence-content li {
            margin-bottom: 0.5rem;
            line-height: 1.7;
        }
        .confluence-content img {
            max-width: 100%;
            height: auto;
            border-radius: var(--radius-md);
            margin: 1.5rem 0;
            box-shadow: var(--shadow-md);
        }
        .confluence-content table {
            width: 100%;
            border-collapse: collapse;
            margin: 1.5rem 0;
            background: white;
            border-radius: var(--radius-md);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }
        .confluence-content th, .confluence-content td {
            padding: 0.75rem 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        .confluence-content th {
            background: var(--bg-tertiary);
            font-weight: 600;
            color: var(--text-primary);
        }
        .confluence-content tr:last-child td {
            border-bottom: none;
        }
        .confluence-content pre {
            background: var(--text-primary);
            color: #f8f8f2;
            padding: 1.5rem;
            border-radius: var(--radius-md);
            overflow-x: auto;
            margin: 1rem 0;
        }
        .confluence-content code {
            background: var(--bg-tertiary);
            padding: 0.2rem 0.4rem;
            border-radius: var(--radius-sm);
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 0.9em;
        }
        .confluence-content pre code {
            background: none;
            padding: 0;
        }
        .confluence-content blockquote {
            border-left: 4px solid var(--primary-color);
            padding-left: 1rem;
            margin: 1.5rem 0;
            color: var(--text-secondary);
            font-style: italic;
        }
        .confluence-content a {
            color: var(--primary-color);
            text-decoration: none;
            border-bottom: 1px solid transparent;
            transition: border-color 0.2s;
        }
        .confluence-content a:hover {
            border-bottom-color: var(--primary-color);
        }
        .back-nav {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .back-nav a {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: var(--radius-md);
            font-weight: 500;
            transition: all 0.2s;
        }
        .back-nav a:hover {
            background: var(--primary-dark);
            transform: translateX(-5px);
        }
        .back-nav span {
            color: var(--text-secondary);
        }
        .page-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 3rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-color);
            font-size: 0.875rem;
            color: var(--text-secondary);
        }
        .confluence-information-macro {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-left: 4px solid var(--primary-color);
            border-radius: var(--radius-md);
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
        }
        .toc-macro {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .toc-macro ul {
            margin: 0;
            padding-left: 1.5rem;
        }
        .toc-macro li {
            margin-bottom: 0.5rem;
        }
        .toc-macro a {
            color: var(--text-secondary);
            text-decoration: none;
            transition: color 0.2s;
        }
        .toc-macro a:hover {
            color: var(--primary-color);
        }
        hr {
            border: none;
            height: 2px;
            background: var(--border-color);
            margin: 2rem 0;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-container">
            <a href="../index.html" class="logo">
                <div class="logo-icon">S</div>
                <span>SMILE Platform</span>
            </a>
            <nav class="nav-links">
                <a href="../index.html#docs" class="nav-link">Documentation</a>
                <a href="../index.html#about" class="nav-link">About</a>
                <a href="../index.html#contact" class="nav-link">Contact</a>
            </nav>
        </div>
    </header>

    <div class="confluence-wrapper">
        <div class="back-nav">
            <a href="../index.html">
                <span>←</span> Back to Documentation
            </a>
            <span>Home / Documentation / $Title</span>
        </div>

        <div class="confluence-content">
            <h1>$Title</h1>
            
            <div class="confluence-information-macro">
                <p>This article was last updated on $LastUpdated</p>
            </div>

            $ContentFile

            <div class="page-info">
                <div>Last updated: $LastUpdated</div>
                <div>SMILE Platform Documentation</div>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-container">
            <div class="footer-links">
                <a href="#" class="footer-link">Privacy Policy</a>
                <a href="#" class="footer-link">Terms of Use</a>
                <a href="#" class="footer-link">Support</a>
            </div>
            <div class="footer-text">
                © 2024 SMILE Platform. A Digital Public Good initiative.
            </div>
        </div>
    </footer>
</body>
</html>
"@
    
    $template | Out-File -FilePath $OutputFile -Encoding UTF8
}

# Create styled version for deployment-guide
$deploymentContent = @"
<h2>Overview</h2>
<p>This guide provides comprehensive instructions for deploying SMILE5 on AWS infrastructure.</p>

<h2>Prerequisites</h2>
<ul>
    <li>AWS account with appropriate permissions</li>
    <li>kubectl and AWS CLI installed</li>
    <li>Docker installed and configured</li>
    <li>Domain name for the deployment (optional)</li>
</ul>

<h2>Deployment Steps</h2>
<ol>
    <li><strong>Prepare AWS Environment</strong>
        <ul>
            <li>Create VPC and subnets</li>
            <li>Set up security groups</li>
            <li>Configure IAM roles</li>
        </ul>
    </li>
    <li><strong>Deploy Kubernetes Cluster</strong>
        <ul>
            <li>Create EKS cluster</li>
            <li>Configure worker nodes</li>
            <li>Set up networking</li>
        </ul>
    </li>
    <li><strong>Install Dependencies</strong>
        <ul>
            <li>Deploy Ingress controller</li>
            <li>Set up monitoring</li>
            <li>Configure logging</li>
        </ul>
    </li>
    <li><strong>Deploy SMILE Application</strong>
        <ul>
            <li>Build and push Docker images</li>
            <li>Apply Kubernetes manifests</li>
            <li>Configure ingress and SSL</li>
        </ul>
    </li>
</ol>

<h2>Configuration</h2>
<p>Update the following configuration files:</p>
<ul>
    <li><code>config/production.yaml</code> - Environment settings</li>
    <li><code>k8s/secrets.yaml</code> - Sensitive data</li>
    <li><code>k8s/ingress.yaml</code> - Routing rules</li>
</ul>

<h2>Troubleshooting</h2>
<p>Common issues and solutions:</p>
<ul>
    <li>Pod not starting - Check resource limits</li>
    <li>Database connection errors - Verify credentials</li>
    <li>Ingress not working - Check ALB configuration</li>
</ul>
"@

Create-StyledHtml -Title "Deployment and Installation Guide" -ContentFile $deploymentContent -OutputFile "$targetPath\deployment-guide.html" -LastUpdated "26 Jun 2025"

# Create styled version for technical-overview
$technicalContent = @"
<h2>Introduction</h2>
<p>The SMILE Technical Overview provides a comprehensive understanding of the platform's architecture, technologies, and implementation details.</p>

<h2>Technology Stack</h2>
<h3>Backend Technologies</h3>
<ul>
    <li><strong>Framework:</strong> Spring Boot (Java)</li>
    <li><strong>Database:</strong> PostgreSQL + Redis</li>
    <li><strong>Message Queue:</strong> Apache Kafka</li>
    <li><strong>Search:</strong> Elasticsearch</li>
</ul>

<h3>Frontend Technologies</h3>
<ul>
    <li><strong>Framework:</strong> React.js</li>
    <li><strong>State Management:</strong> Redux</li>
    <li><strong>UI Components:</strong> Material-UI</li>
    <li><strong>Charts:</strong> D3.js</li>
</ul>

<h3>Infrastructure</h3>
<ul>
    <li><strong>Container:</strong> Docker</li>
    <li><strong>Orchestration:</strong> Kubernetes</li>
    <li><strong>Cloud:</strong> AWS</li>
    <li><strong>CI/CD:</strong> Jenkins</li>
</ul>

<h2>Architecture</h2>
<p>The SMILE platform follows a microservices architecture with the following key components:</p>
<ul>
    <li>API Gateway for request routing</li>
    <li>Authentication Service</li>
    <li>Business Logic Services</li>
    <li>Data Processing Services</li>
    <li>Notification Service</li>
</ul>

<h2>Data Flow</h2>
<ol>
    <li>Client requests hit the API Gateway</li>
    <li>Authentication is verified</li>
    <li>Requests are routed to appropriate services</li>
    <li>Services process and return data</li>
    <li>Responses are cached when appropriate</li>
</ol>

<h2>Security</h2>
<p>Security measures include:</p>
<ul>
    <li>OAuth 2.0 for authentication</li>
    <li>JWT for authorization</li>
    <li>Encryption at rest and in transit</li>
    <li>Regular security audits</li>
</ul>
"@

Create-StyledHtml -Title "Technical Overview Document" -ContentFile $technicalContent -OutputFile "$targetPath\technical-overview.html" -LastUpdated "19 Jun 2025"

# Create styled version for dpg-tasks-tracker
$dpgContent = @"
<h2>DPG Application Process</h2>
<p>This tracker outlines the tasks and requirements for SMILE's Digital Public Good (DPG) application process.</p>

<h2>Governance Requirements</h2>
<h3>Documentation</h3>
<ul>
    <li>Technical documentation complete</li>
    <li>User guides and manuals</li>
    <li>API documentation</li>
    <li>Deployment guides</li>
</ul>

<h3>Legal & Compliance</h3>
<ul>
    <li>License verification</li>
    <li>Privacy policy</li>
    <li>Terms of use</li>
    <li>Data handling procedures</li>
</ul>

<h2>Technical Standards</h2>
<h3>Code Quality</h3>
<ul>
    <li>Code review process</li>
    <li>Automated testing</li>
    <li>Documentation standards</li>
    <li>Version control</li>
</ul>

<h3>Infrastructure</h3>
<ul>
    <li>Scalability requirements</li>
    <li>Security measures</li>
    <li>Monitoring and logging</li>
    <li>Backup procedures</li>
</ul>

<h2>Community Engagement</h2>
<ul>
    <li>GitHub repository setup</li>
    <li>Contribution guidelines</li>
    <li>Community support channels</li>
    <li>Regular updates and releases</li>
</ul>

<h2>Evidence Collection</h2>
<p>Required evidence for DPG recognition:</p>
<ul>
    <li>Case studies from implementations</li>
    <li>User testimonials</li>
    <li>Performance metrics</li>
    <li>Impact assessments</li>
</ul>
"@

Create-StyledHtml -Title "DPG Tasks Tracker" -ContentFile $dpgContent -OutputFile "$targetPath\dpg-tasks-tracker.html" -LastUpdated "19 Jun 2025"

Write-Host "All styled HTML files created successfully!"
