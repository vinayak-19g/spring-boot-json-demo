Write-Host "Building SQL Webhook Application..." -ForegroundColor Green
Write-Host ""

# Check Java version
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "Java version: $javaVersion" -ForegroundColor Yellow
} catch {
    Write-Host "Java is not available. Please install Java and add it to PATH." -ForegroundColor Red
    exit 1
}

# Try to use Maven if available
try {
    $mvnVersion = mvn -version 2>&1
    Write-Host "Using Maven from PATH..." -ForegroundColor Yellow
    mvn clean package -DskipTests
} catch {
    Write-Host "Maven not found in PATH, trying Maven wrapper..." -ForegroundColor Yellow
    
    # Try to run Maven wrapper with proper path handling
    try {
        $mvnwPath = Join-Path $PSScriptRoot "mvnw.cmd"
        if (Test-Path $mvnwPath) {
            Write-Host "Found Maven wrapper at: $mvnwPath" -ForegroundColor Yellow
            & $mvnwPath clean package -DskipTests
        } else {
            Write-Host "Maven wrapper not found" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "Failed to run Maven wrapper: $_" -ForegroundColor Red
        exit 1
    }
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Build successful! JAR file created in target directory." -ForegroundColor Green
    Get-ChildItem "target\*.jar" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "JAR file: $($_.Name)" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "Build failed. Please check the error messages above." -ForegroundColor Red
    Write-Host "Note: This project requires Java 17 or higher." -ForegroundColor Yellow
    exit 1
}
