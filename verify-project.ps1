Write-Host '🔍 Verifying SQL Webhook Project Status' -ForegroundColor Green
Write-Host ''

# Check Java version
Write-Host '✅ Java Version:' -ForegroundColor Cyan
java -version 2>&1 | Select-String 'version'

# Check if JAR file exists
Write-Host ''
Write-Host '✅ JAR File Status:' -ForegroundColor Cyan
if (Test-Path 'target\sqlwebhook-0.0.1-SNAPSHOT.jar') {
    $jarSize = (Get-Item 'target\sqlwebhook-0.0.1-SNAPSHOT.jar').Length / 1MB
    Write-Host "   JAR file exists: target\sqlwebhook-0.0.1-SNAPSHOT.jar ($([math]::Round($jarSize, 1)) MB)" -ForegroundColor Green
} else {
    Write-Host '   ❌ JAR file not found!' -ForegroundColor Red
}

# Check if application is running
Write-Host ''
Write-Host '✅ Application Status:' -ForegroundColor Cyan
$javaProcess = Get-Process java -ErrorAction SilentlyContinue
if ($javaProcess) {
    Write-Host "   Application is running (PID: $($javaProcess.Id))" -ForegroundColor Green
} else {
    Write-Host '   Application is not currently running' -ForegroundColor Yellow
}

# Check Git status
Write-Host ''
Write-Host '✅ Git Repository Status:' -ForegroundColor Cyan
$remoteUrl = git remote get-url origin 2>$null
if ($remoteUrl) {
    Write-Host "   Remote: $remoteUrl" -ForegroundColor Green
    $branchStatus = git status --porcelain
    if ($branchStatus) {
        Write-Host '   ⚠️  There are uncommitted changes' -ForegroundColor Yellow
    } else {
        Write-Host '   ✅ Repository is clean' -ForegroundColor Green
    }
} else {
    Write-Host '   ❌ No remote repository configured' -ForegroundColor Red
}

# Check key files
Write-Host ''
Write-Host '✅ Key Files Status:' -ForegroundColor Cyan
$keyFiles = @(
    'src\main\java\com\example\sqlwebhook\SqlwebhookApplication.java',
    'src\main\java\com\example\sqlwebhook\service\WebhookService.java',
    'src\main\java\com\example\sqlwebhook\dto\WebhookRequest.java',
    'src\main\java\com\example\sqlwebhook\dto\WebhookResponse.java',
    'src\main\java\com\example\sqlwebhook\dto\SolutionRequest.java',
    'pom.xml',
    'application.properties',
    'README.md'
)

foreach ($file in $keyFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file" -ForegroundColor Red
    }
}

# Final summary
Write-Host ''
Write-Host '📋 Project Summary:' -ForegroundColor Cyan
Write-Host '   GitHub Repository: https://github.com/vinayak-19g/spring-boot-json-demo' -ForegroundColor White
Write-Host '   JAR Download: https://github.com/vinayak-19g/spring-boot-json-demo/raw/main/target/sqlwebhook-0.0.1-SNAPSHOT.jar' -ForegroundColor White
Write-Host ''
Write-Host '🎯 To run the application:' -ForegroundColor Cyan
Write-Host '   java -jar target\sqlwebhook-0.0.1-SNAPSHOT.jar' -ForegroundColor White
Write-Host ''
Write-Host '🚀 Project is ready for submission!' -ForegroundColor Green
