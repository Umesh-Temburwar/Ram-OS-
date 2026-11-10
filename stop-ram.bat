@echo off
chcp 65001 >nul
title Stopping RAM OS
echo Finding and stopping RAM OS...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop-ram.ps1"
taskkill /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq RAM OS*" >nul 2>&1
taskkill /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq Javis OS*" >nul 2>&1
echo Done.
exit /b 0

