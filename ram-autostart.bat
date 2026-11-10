@echo off
chcp 65001 >nul
title RAM OS Autostart
REM Autostart RAM OS on Windows login. Usage: ram-autostart.bat install | uninstall | status
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ram-autostart.ps1" %1

