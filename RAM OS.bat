@echo off
chcp 65001 >nul
title RAM OS
cd /d "%~dp0"

REM ============================================================
REM  RAM OS - Launch as an application on Windows
REM  Double-click: background server starts automatically,
REM  then dashboard opens in dedicated window (Edge/Chrome app mode).
REM ============================================================

if "%JAVIS_PORT%"=="" set JAVIS_PORT=7777
set "URL=http://127.0.0.1:%JAVIS_PORT%"

REM If server is already running, open window directly
curl -sf -m 2 -o nul %URL%/health 2>nul
if %errorlevel%==0 goto :open

echo Starting RAM OS (background server, logs in server\ram.log)...
wscript //nologo start-ram.vbs

REM Wait for server to become healthy (up to ~45 seconds)
where curl >nul 2>&1
if not %errorlevel%==0 (
  timeout /t 8 >nul
  goto :open
)
set /a _thu=0
:wait
set /a _thu+=1
if %_thu% gtr 45 goto :open
timeout /t 1 >nul
curl -sf -m 2 -o nul %URL%/health 2>nul
if not %errorlevel%==0 goto :wait

:open
REM Prioritize application window (no browser address bar)
set "EDGE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if exist "%EDGE%" ( start "" "%EDGE%" --app=%URL% & goto :eof )
set "EDGE=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if exist "%EDGE%" ( start "" "%EDGE%" --app=%URL% & goto :eof )
set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if exist "%CHROME%" ( start "" "%CHROME%" --app=%URL% & goto :eof )
set "CHROME=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if exist "%CHROME%" ( start "" "%CHROME%" --app=%URL% & goto :eof )

start "" "%URL%"
goto :eof

