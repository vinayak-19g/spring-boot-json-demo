Write-Host '🚀 Pushing SQL Webhook Project to GitHub' -ForegroundColor Green
Write-Host ''

# Check if we're in a git repository
if (!(Test-Path '.git')) {
    Write-Host '❌ Not in a Git repository. Please run git init first.' -ForegroundColor Red
    exit 1
}

# Check if remote origin exists
$remoteExists = git remote get-url origin 2>$null
if ($remoteExists) {
    Write-Host "✅ Remote origin already exists: $remoteExists" -ForegroundColor Yellow
    Write-Host ''
    Write-Host 'To push to GitHub, run:' -ForegroundColor Cyan
    Write-Host '  git push -u origin main' -ForegroundColor White
} else {
    Write-Host '📋 To connect to your GitHub repository, follow these steps:' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '1. Go to https://github.com and create a new repository' -ForegroundColor White
    Write-Host '2. Name it something like sqlwebhook or spring-boot-webhook' -ForegroundColor White
    Write-Host '3. Make it PUBLIC' -ForegroundColor White
    Write-Host '4. Do NOT initialize with README, .gitignore, or license' -ForegroundColor White
    Write-Host ''
    Write-Host '5. After creating the repository, GitHub will show you commands like:' -ForegroundColor White
    Write-Host '   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git' -ForegroundColor Yellow
    Write-Host '   git branch -M main' -ForegroundColor Yellow
    Write-Host '   git push -u origin main' -ForegroundColor Yellow
    Write-Host ''
    Write-Host '6. Replace YOUR_USERNAME and YOUR_REPO_NAME with your actual values' -ForegroundColor White
    Write-Host ''
    Write-Host '7. Run those commands in this terminal' -ForegroundColor White
}

Write-Host ''
Write-Host '📁 Current project files:' -ForegroundColor Cyan
Get-ChildItem -Name | ForEach-Object {
    Write-Host "   $_" -ForegroundColor White
}

Write-Host ''
Write-Host '🎯 JAR file location:' -ForegroundColor Cyan
if (Test-Path 'target\sqlwebhook-0.0.1-SNAPSHOT.jar') {
    $jarSize = (Get-Item 'target\sqlwebhook-0.0.1-SNAPSHOT.jar').Length / 1MB
    Write-Host "   target\sqlwebhook-0.0.1-SNAPSHOT.jar ($([math]::Round($jarSize, 1)) MB)" -ForegroundColor Green
} else {
    Write-Host '   ❌ JAR file not found in target directory' -ForegroundColor Red
}

Write-Host ''
Write-Host '📋 After pushing to GitHub, your submission details will be:' -ForegroundColor Cyan
Write-Host '   GitHub URL: https://github.com/YOUR_USERNAME/YOUR_REPO_NAME' -ForegroundColor White
Write-Host '   JAR Download: https://github.com/YOUR_USERNAME/YOUR_REPO_NAME/raw/main/target/sqlwebhook-0.0.1-SNAPSHOT.jar' -ForegroundColor White
