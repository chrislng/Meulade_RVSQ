@echo off
echo Building Meulade_RVSQ Windows executable...
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://python.org
    pause
    exit /b 1
)

REM Install required packages
echo Installing required packages...
pip install -r requirements.txt

REM Install playwright browsers
echo Installing Playwright browsers...
playwright install chromium

REM Build the executable
echo.
echo Building executable with PyInstaller...
python build_windows.py

REM Check if build was successful
if exist "dist\Meulade_RVSQ.exe" (
    echo.
    echo ================================
    echo BUILD SUCCESSFUL!
    echo ================================
    echo.
    echo Executable created: dist\Meulade_RVSQ.exe
    echo.
    echo You can now distribute the executable to other Windows machines.
    echo The executable should work without requiring Python installation.
    echo.
) else (
    echo.
    echo BUILD FAILED!
    echo Check the output above for errors.
    echo.
)

pause
