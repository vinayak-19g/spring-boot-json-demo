Write-Host "Downloading Maven..." -ForegroundColor Green

# Create temp directory
$tempDir = Join-Path $env:TEMP "maven-download"
if (!(Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

# Download Maven
$mavenUrl = "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
$mavenZip = Join-Path $tempDir "maven.zip"
$mavenDir = Join-Path $tempDir "maven"

Write-Host "Downloading Maven from: $mavenUrl" -ForegroundColor Yellow
Invoke-WebRequest -Uri $mavenUrl -OutFile $mavenZip

# Extract Maven
Write-Host "Extracting Maven..." -ForegroundColor Yellow
Expand-Archive -Path $mavenZip -DestinationPath $tempDir -Force

# Find the extracted directory
$extractedDir = Get-ChildItem -Path $tempDir -Directory | Where-Object { $_.Name -like "apache-maven-*" } | Select-Object -First 1
if ($extractedDir) {
    $mavenBin = Join-Path $extractedDir.FullName "bin"
    Write-Host "Maven extracted to: $($extractedDir.FullName)" -ForegroundColor Green
    
    # Set PATH to include Maven
    $env:PATH = "$mavenBin;$env:PATH"
    
    # Build the project
    Write-Host "Building project with downloaded Maven..." -ForegroundColor Green
    mvn clean package -DskipTests
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Build successful!" -ForegroundColor Green
        Get-ChildItem "target\*.jar" -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Host "JAR file: $($_.Name)" -ForegroundColor Green
        }
    } else {
        Write-Host "Build failed!" -ForegroundColor Red
    }
} else {
    Write-Host "Failed to extract Maven" -ForegroundColor Red
}
