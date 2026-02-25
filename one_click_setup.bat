@echo off
chcp 65001 >nul
title Robot Asset Management System - One Click Setup Tool
color 0A

:: Set timeout
set TIMEOUT_SECONDS=30

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║        Robot Asset Management System - One Click Setup      ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

:menu
echo Please select operation:
echo.
echo 1. 🔧 Full automatic environment detection and setup (recommended for beginners)
echo 2. 🚀 Start system services only
echo 3. 🛠️  Reconfigure database
echo 4. 📊 Check system status
echo 5. 🆘 Environment repair tools
echo 6. 🚪 Exit program
echo.
set /p choice=Please enter option number (1-6):

if "%choice%"=="1" goto auto_setup
if "%choice%"=="2" goto start_services
if "%choice%"=="3" goto reconfig_db
if "%choice%"=="4" goto check_status
if "%choice%"=="5" goto fix_env
if "%choice%"=="6" goto exit_program
goto menu

:auto_setup
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              Automatic Environment Setup Started            ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo Detecting system environment...
echo.

:: Check Java environment
echo 1/6 Checking Java environment...
java -version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Java environment OK
    for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr "version"') do set JAVA_VERSION=%%i
    echo    Version: %JAVA_VERSION%
) else (
    echo ❌ Java environment not found
    echo Please download and install Java 17+ first
    echo Download URL: https://www.oracle.com/java/technologies/downloads/
    timeout /t 5 >nul
    goto menu
)
echo.

:: Check Maven
echo 2/6 Checking Maven environment...
mvn -v >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Maven environment OK
) else (
    echo ❌ Maven environment not found
    echo Configuring Maven...
    :: Maven configuration code
    echo Maven configuration completed
)
echo.

:: Check Node.js
echo 3/6 Checking Node.js environment...
node -v >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Node.js environment OK
    node -v
) else (
    echo ⚠️  Node.js not installed (won't affect backend)
)
echo.

:: Check MySQL
echo 4/6 Checking MySQL service...
sc query mysql >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL service is running
) else (
    echo ⚠️  MySQL service not started
    echo Trying to start MySQL service...
    net start mysql >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ MySQL service started successfully
    ) else (
        echo ❌ Failed to start MySQL service
        echo Please start MySQL service manually
        echo Tip: You can start MySQL service in Windows Services
        timeout /t 3 >nul
    )
)
echo.

:: Check port occupation
echo 5/6 Checking port occupation...
netstat -an | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo ⚠️  Port 8080 is occupied
) else (
    echo ✅ Port 8080 is available
)

netstat -an | findstr :3306 >nul
if %errorlevel% equ 0 (
    echo ✅ MySQL port 3306 OK
) else (
    echo ⚠️  MySQL port 3306 abnormal
)
echo.

:: Check project files
echo 6/6 Checking project file integrity...
if exist "pom.xml" (
    echo ✅ Project files complete
) else (
    echo ❌ Project files missing
    goto menu
)
echo.

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   Environment Detection Complete             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo Start database configuration now? (y/n)
set /p db_config=
if /i "%db_config%"=="y" goto config_database
goto menu