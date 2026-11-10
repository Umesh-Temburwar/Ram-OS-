@echo off
chcp 65001 >nul
title Starting RAM OS
cd /d "%~dp0"

echo Starting RAM OS in background (port 7777)...
wscript //nologo start-ram.vbs

echo.
echo RAM OS started. Wait ~5-10 seconds then open http://localhost:7777
echo (Stop server: run stop-ram.bat. Logs: server\ram.log)
timeout /t 4 >nul 2>&1 || ping -n 5 127.0.0.1 >nul

