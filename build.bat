@echo off
echo Building SQL Webhook Application...
echo.

REM Check Java version
java -version >nul 2>nul
if %errorlevel% neq 0 (
    echo Java is not available. Please install Java and add it to PATH.
    exit /b 1
)

REM Try to use Maven if available
where mvn >nul 2>nul
if %errorlevel% equ 0 (
    echo Using Maven from PATH...
    mvn clean package -DskipTests
) else (
    echo Maven not found in PATH, trying Maven wrapper...
    call mvnw.cmd clean package -DskipTests
)

if %errorlevel% equ 0 (
    echo.
    echo Build successful! JAR file created in target directory.
    dir target\*.jar
) else (
    echo.
    echo Build failed. Please check the error messages above.
    echo Note: This project requires Java 17 or higher.
    exit /b 1
)
