@echo off
chcp 65001 >nul
title ISRASKI — Local Server

echo.
echo  ╔══════════════════════════════════════════╗
echo  ║         ISRASKI — Local Server           ║
echo  ╚══════════════════════════════════════════╝
echo.

:: Get local IP
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4" ^| findstr /v "169.254"') do (
    set IP=%%i
    goto :found
)
:found
set IP=%IP: =%

echo  המחשב שלך:   http://localhost:3000
echo  הטלפון שלך:  http://%IP%:3000
echo.
echo  החבר את הטלפון לאותה WiFi ופתח את כתובת הטלפון.
echo  לעצירה — סגור את החלון הזה.
echo.

cd /d "%~dp0"
npx --yes serve -l 3000 -s .

pause
