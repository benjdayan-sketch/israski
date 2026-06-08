@echo off
chcp 65001 >nul
title ISRASKI — Local Server

cd /d "%~dp0"

echo.
echo  +------------------------------------------+
echo  ^|  מחשב:    http://localhost:8080           ^|
echo  ^|  מובייל:  http://192.168.1.122:8080       ^|
echo  +------------------------------------------+
echo  ^|  לעצירה — סגור חלון זה                   ^|
echo  +------------------------------------------+
echo.

:: Open browser after 3 seconds (while server starts)
start /b cmd /c "timeout /t 3 /nobreak >nul && start http://localhost:8080"

npx --yes serve -l 8080
