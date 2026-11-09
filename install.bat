@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title JAVIS OS - One-Click Installer ^& Setup

echo.
echo ===============================================================================
echo   JAVIS OS - ONE-CLICK AUTOMATIC SETUP AND INSTALLER
echo ===============================================================================
echo   This one-click installer will automatically check, download, and configure:
echo     [1] Git (version control ^& auto-updater)
echo     [2] Python 3.12 (runtime environment ^& virtual environment)
echo     [3] Node.js LTS ^& npm (JavaScript runtime ^& tool manager)
echo     [4] Python Dependencies (FastAPI, Claude Agent SDK, Uvicorn, etc.)
echo     [5] AI CLI Engines ^& Tools:
echo         - Claude Code (@anthropic-ai/claude-code)
echo         - OpenAI Codex (@openai/codex)
echo         - Grok CLI (xAI)
echo         - Antigravity CLI (Google)
echo     [6] Project Configuration (.env file)
echo     [7] Clean Port 7777 ^& Launch JAVIS OS Server
echo     [8] Auto-open the Web Dashboard in your browser (http://localhost:7777)
echo ===============================================================================
echo.

cd /d "%~dp0"

REM -----------------------------------------------------------------------------
REM Locate PowerShell
REM -----------------------------------------------------------------------------
set "PS_CMD="
where powershell.exe >nul 2>&1
if not errorlevel 1 (
    set "PS_CMD=powershell.exe"
) else (
    if exist "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" (
        set "PS_CMD=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
    )
)

if "%PS_CMD%"=="" goto :fallback_batch

REM -----------------------------------------------------------------------------
REM Run PowerShell installer with Bypass ExecutionPolicy
REM -----------------------------------------------------------------------------
echo [*] Starting automated installer...
echo.

"%PS_CMD%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
set "INSTALL_EXIT_CODE=%errorlevel%"

echo.
if %INSTALL_EXIT_CODE% equ 0 (
    echo ===============================================================================
    echo   [SUCCESS] JAVIS OS installation and setup completed successfully!
    echo   Server is running at: http://localhost:7777
    echo   Dashboard has opened in your browser.
    echo ===============================================================================
    echo.
    echo This window will close automatically in 10 seconds, or press any key to exit.
    timeout /t 10 >nul 2>&1 || ping -n 11 127.0.0.1 >nul
    exit /b 0
) else (
    echo ===============================================================================
    echo   [WARNING] Setup exited with status code: %INSTALL_EXIT_CODE%
    echo   Please inspect the messages above to see any issues.
    echo ===============================================================================
    echo.
    pause
    exit /b %INSTALL_EXIT_CODE%
)

REM -----------------------------------------------------------------------------
REM Fallback pure Batch installation in case PowerShell is unavailable
REM -----------------------------------------------------------------------------
:fallback_batch
echo [!] PowerShell was not found. Running minimal Batch installer...

where python >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed and PowerShell is unavailable to auto-download.
    echo Please install Python 3.12 from https://www.python.org and tick "Add to PATH".
    pause
    exit /b 1
)

if not exist ".venv" (
    echo [*] Creating Python virtual environment...
    python -m venv .venv
)

echo [*] Installing Python dependencies...
call .venv\Scripts\activate.bat
python -m pip install --upgrade pip -q
pip install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] pip install failed.
    pause
    exit /b 1
)

if not exist ".env" (
    if exist "env.example" (
        copy "env.example" ".env" >nul
        echo [*] Created .env from env.example
    )
)

echo [*] Starting JAVIS OS...
if exist "start-javis.vbs" (
    wscript //nologo start-javis.vbs /open
) else (
    cd server
    start "" python main.py
)

echo.
echo ===============================================================================
echo   JAVIS OS is starting at: http://localhost:7777
echo ===============================================================================
timeout /t 5 >nul 2>&1 || ping -n 6 127.0.0.1 >nul
exit /b 0
