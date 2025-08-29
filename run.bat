@echo off
echo Running SQL Webhook Application...
echo.

REM Check if JAR file exists
if not exist "target\sqlwebhook-0.0.1-SNAPSHOT.jar" (
    echo JAR file not found. Please build the project first using build.bat
    exit /b 1
)

REM Run the application
echo Starting application...
java -jar target\sqlwebhook-0.0.1-SNAPSHOT.jar

pause
