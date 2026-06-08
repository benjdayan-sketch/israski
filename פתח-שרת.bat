@echo off
chcp 65001 >nul
title ISRASKI — Local Server

cd /d "%~dp0"

echo.
echo  +------------------------------------------+
echo  ^|  מחשב:    http://localhost:8080           ^|
echo  ^|  מובייל:  http://192.168.1.122:8080       ^|
echo  +------------------------------------------+
echo  ^|  שינויים ב-index.html מסונכרנים לGitHub  ^|
echo  ^|  לעצירה — סגור חלון זה                   ^|
echo  +------------------------------------------+
echo.

:: Start git auto-sync watcher in background window
start "ISRASKI Git Sync" powershell.exe -NoExit -ExecutionPolicy Bypass -File "C:\Users\User\AppData\Local\Temp\israski-watch.ps1" -root "%~dp0"

:: Open browser after 3 seconds
start /b cmd /c "timeout /t 3 /nobreak >nul && start http://localhost:8080"

npx --yes serve -l 8080
