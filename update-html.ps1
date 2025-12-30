# PowerShell script to update HTML files with new design

$files = @(
    "assets\html\cloud-infrastructure.html",
    "assets\html\data-streaming.html",
    "assets\html\deployment-guide.html",
    "assets\html\technical-overview.html",
    "assets\html\dpg-tasks-tracker.html"
)

foreach ($file in $files) {
    Write-Host "Processing $file..."
    
    # Read the original file
    $content = Get-Content -Path $file -Raw
    
    # Extract the main content (look for the main content div)
    if ($content -match '<div id="main-content"[^>]*>(.*?)</div>\s*</div>\s*</div>\s*</body>') {
        $mainContent = $matches[1]
        
        # Read the template
        $template = Get-Content -Path "assets\html-template.html" -Raw
        
        # Replace the placeholder with actual content
        $newContent = $template -replace '<!-- Content will be inserted here -->', $mainContent
        
        # Write the updated file
        $newContent | Out-File -FilePath $file -Encoding UTF8
        Write-Host "Updated $file successfully"
    } else {
        Write-Host "Could not find main content in $file"
    }
}

Write-Host "All files updated!"
