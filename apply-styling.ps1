# PowerShell script to apply modern styling to all HTML documentation files

$basePath = "c:\Badr\UN ICC\Confluence\site"
$files = @(
    "$basePath\assets\html\cloud-infrastructure.html",
    "$basePath\assets\html\data-streaming.html",
    "$basePath\assets\html\deployment-guide.html",
    "$basePath\assets\html\technical-overview.html",
    "$basePath\assets\html\dpg-tasks-tracker.html"
)

# Header template
$headerTemplate = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{TITLE}</title>
    <link rel="stylesheet" href="../assets/styles/main.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        .confluence-wrapper {{
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }}
        .confluence-content {{
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-xl);
            padding: 3rem;
            box-shadow: var(--shadow-lg);
            margin-top: 2rem;
        }}
        .confluence-content h1 {{
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 2rem;
            color: var(--text-primary);
            border-bottom: 3px solid var(--primary-color);
            padding-bottom: 0.5rem;
        }}
        .confluence-content h2 {{
            font-size: 2rem;
            font-weight: 600;
            margin-top: 2.5rem;
            margin-bottom: 1rem;
            color: var(--primary-dark);
        }}
        .confluence-content h3 {{
            font-size: 1.5rem;
            font-weight: 600;
            margin-top: 2rem;
            margin-bottom: 1rem;
            color: var(--text-primary);
        }}
        .confluence-content p {{
            font-size: 1.125rem;
            line-height: 1.8;
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }}
        .confluence-content ul, .confluence-content ol {{
            margin-bottom: 1rem;
            padding-left: 2rem;
        }}
        .confluence-content li {{
            margin-bottom: 0.5rem;
            line-height: 1.7;
        }}
        .confluence-content img {{
            max-width: 100%;
            height: auto;
            border-radius: var(--radius-md);
            margin: 1.5rem 0;
            box-shadow: var(--shadow-md);
        }}
        .confluence-content table {{
            width: 100%;
            border-collapse: collapse;
            margin: 1.5rem 0;
            background: white;
            border-radius: var(--radius-md);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }}
        .confluence-content th, .confluence-content td {{
            padding: 0.75rem 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }}
        .confluence-content th {{
            background: var(--bg-tertiary);
            font-weight: 600;
            color: var(--text-primary);
        }}
        .confluence-content tr:last-child td {{
            border-bottom: none;
        }}
        .confluence-content pre {{
            background: var(--text-primary);
            color: #f8f8f2;
            padding: 1.5rem;
            border-radius: var(--radius-md);
            overflow-x: auto;
            margin: 1rem 0;
        }}
        .confluence-content code {{
            background: var(--bg-tertiary);
            padding: 0.2rem 0.4rem;
            border-radius: var(--radius-sm);
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 0.9em;
        }}
        .confluence-content pre code {{
            background: none;
            padding: 0;
        }}
        .confluence-content blockquote {{
            border-left: 4px solid var(--primary-color);
            padding-left: 1rem;
            margin: 1.5rem 0;
            color: var(--text-secondary);
            font-style: italic;
        }}
        .confluence-content a {{
            color: var(--primary-color);
            text-decoration: none;
            border-bottom: 1px solid transparent;
            transition: border-color 0.2s;
        }}
        .confluence-content a:hover {{
            border-bottom-color: var(--primary-color);
        }}
        .back-nav {{
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }}
        .back-nav a {{
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
        }}
        .back-nav a:hover {{
            background: var(--primary-dark);
            transform: translateX(-5px);
        }}
        .back-nav span {{
            color: var(--text-secondary);
        }}
        .page-info {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 3rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-color);
            font-size: 0.875rem;
            color: var(--text-secondary);
        }}
        .confluence-information-macro {{
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-left: 4px solid var(--primary-color);
            border-radius: var(--radius-md);
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
        }}
        .toc-macro {{
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }}
        .toc-macro ul {{
            margin: 0;
            padding-left: 1.5rem;
        }}
        .toc-macro li {{
            margin-bottom: 0.5rem;
        }}
        .toc-macro a {{
            color: var(--text-secondary);
            text-decoration: none;
            transition: color 0.2s;
        }}
        .toc-macro a:hover {{
            color: var(--primary-color);
        }}
        hr {{
            border: none;
            height: 2px;
            background: var(--border-color);
            margin: 2rem 0;
        }}
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
            <span>{BREADCRUMB}</span>
        </div>

        <div class="confluence-content">
            <h1>{TITLE}</h1>
"@

# Footer template
$footerTemplate = @"
            <div class="page-info">
                <div>{LAST_UPDATED}</div>
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

foreach ($file in $files) {
    Write-Host "Processing $file..."
    
    # Read the original file
    $content = Get-Content -Path $file -Raw -Encoding UTF8
    
    # Extract the main content
    if ($content -match '<div id="main-content" class="wiki-content group">(.*?)</div>\s*</div>\s*</div>\s*</body>') {
        $mainContent = $matches[1]
        
        # Determine title and breadcrumb
        $filename = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $titleMap = @{
            'cloud-infrastructure' = 'SMILE Cloud Infrastructure'
            'data-streaming' = 'SMILE Data Streaming Mechanism'
            'deployment-guide' = 'SMILE Deployment and Installation Guide'
            'technical-overview' = 'SMILE Technical Overview Document'
            'dpg-tasks-tracker' = 'DPG Tasks Tracker'
        }
        
        $title = $titleMap[$filename]
        $breadcrumb = "Home / Documentation / $title"
        
        # Extract last updated date if present
        $lastUpdated = "Last updated: Unknown"
        if ($content -match 'last updated on <time datetime="([^"]*)"[^>]*>([^<]*)</time>') {
            $lastUpdated = "Last updated: $($matches[2])"
        }
        
        # Fix image paths
        $mainContent = $mainContent -replace 'src="images/', 'src="../assets/images/'
        $mainContent = $mainContent -replace 'href="attachments/', 'href="../assets/attachments/'
        
        # Build the new file
        $newContent = $headerTemplate -replace '\{TITLE\}', $title -replace '\{BREADCRUMB\}', $breadcrumb
        $newContent += $mainContent
        $newContent += $footerTemplate -replace '\{LAST_UPDATED\}', $lastUpdated
        
        # Write the updated file
        $newContent | Out-File -FilePath $file -Encoding UTF8
        Write-Host "Updated $file successfully"
    } else {
        Write-Host "Could not find main content in $file"
    }
}

Write-Host "All files updated!"
