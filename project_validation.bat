@echo off
chcp 65001 >nul
title Project Cleanup and Validation Tool
color 0A

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║        Robot Asset Management - Project Validation          ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo Starting project validation and cleanup...
echo.

:: 1. Validate file structure
echo [1/5] Validating file structure...
echo.

set EXPECTED_FILES=README.md README_EN.md pom.xml package.json Dockerfile docker-compose.yml environment.yml
set MISSING_FILES=0

for %%f in (%EXPECTED_FILES%) do (
    if exist "%%f" (
        echo   ✅ %%f
    ) else (
        echo   ❌ %%f (Missing)
        set /a MISSING_FILES+=1
    )
)

echo.

:: 2. Check batch files
echo [2/5] Checking batch files...
echo.

set BATCH_FILES=test.bat one_click_setup.bat quick_setup.bat emergency_setup.bat enhanced_setup.bat anti_freeze_setup.bat diagnostic_tool.bat full_diagnostics.bat database_test.bat api_test.bat conda_setup.bat
set BATCH_MISSING=0

for %%f in (%BATCH_FILES%) do (
    if exist "%%f" (
        echo   ✅ %%f
    ) else (
        echo   ⚠️  %%f (Not found - may need renaming)
        set /a BATCH_MISSING+=1
    )
)

echo.

:: 3. Check documentation files
echo [3/5] Checking documentation files...
echo.

set DOC_FILES=beginner_guide.md quick_start.md workflow_diagram.md environment_setup_guide.md faq_troubleshooting.md conda_quick_guide.md conda_setup_guide.md diagnostics_template.md
set DOC_MISSING=0

for %%f in (%DOC_FILES%) do (
    if exist "%%f" (
        echo   ✅ %%f
    ) else (
        echo   ⚠️  %%f (Not found - may need renaming)
        set /a DOC_MISSING+=1
    )
)

echo.

:: 4. Check directory structure
echo [4/5] Checking directory structure...
echo.

if exist "src" (
    echo   ✅ src directory exists
) else (
    echo   ❌ src directory missing
)

if exist "sql" (
    echo   ✅ sql directory exists
) else (
    echo   ❌ sql directory missing
)

if exist ".lingma" (
    echo   ✅ .lingma directory exists
) else (
    echo   ⚠️  .lingma directory not found
)

echo.

:: 5. Environment validation
echo [5/5] Environment validation...
echo.

:: Check Java
java -version >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Java environment OK
) else (
    echo   ⚠️  Java environment not found
)

:: Check Maven
mvn -v >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Maven environment OK
) else (
    echo   ⚠️  Maven environment not found
)

:: Check Node.js
node -v >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Node.js environment OK
) else (
    echo   ⚠️  Node.js environment not found
)

:: Check MySQL service
sc query mysql >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ MySQL service exists
) else (
    echo   ⚠️  MySQL service not found
)

echo.

:: Generate summary report
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    Validation Summary                        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo Core files missing: %MISSING_FILES%
echo Batch files missing: %BATCH_MISSING%
echo Documentation files missing: %DOC_MISSING%
echo.

set TOTAL_ISSUES=0
set /a TOTAL_ISSUES=%MISSING_FILES%+%BATCH_MISSING%+%DOC_MISSING%

if %TOTAL_ISSUES% equ 0 (
    echo 🎉 All core files present! Project structure is complete.
    color 0A
) else (
    echo ⚠️  Found %TOTAL_ISSUES% issues that need attention.
    echo Please review the file renaming plan and complete missing files.
    color 0E
)

echo.
echo Current working directory: %cd%
echo Timestamp: %date% %time%
echo.

:: Cleanup suggestions
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    Cleanup Suggestions                       ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo Recommended cleanup actions:
echo 1. Review file_rename_plan.md for complete renaming list
echo 2. Delete old Chinese-named files after confirming new ones work
echo 3. Update internal document references to new file names
echo 4. Test all batch scripts functionality
echo 5. Verify all documentation links are working
echo.

echo Press any key to exit...
pause >nul
exit /b