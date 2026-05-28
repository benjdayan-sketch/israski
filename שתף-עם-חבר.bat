@echo off
chcp 65001 >nul
title ISRASKI — Public Link

echo.
echo  ╔══════════════════════════════════════════╗
echo  ║      ISRASKI — Public Sharing Link       ║
echo  ╠══════════════════════════════════════════╣
echo  ║  מייצר כתובת ציבורית שניתן לשלוח לכולם  ║
echo  ╚══════════════════════════════════════════╝
echo.
echo  שלב 1: מפעיל שרת מקומי...
echo.

cd /d "%~dp0"

:: Start serve in background
start "ISRASKI-serve" /min cmd /c "npx --yes serve -l 3000 -s . > nul 2>&1"

timeout /t 3 /nobreak >nul

echo  שלב 2: יוצר כתובת ציבורית (localtunnel)...
echo.
echo  ══════════════════════════════════════════
echo  הכתובת הציבורית שלך תופיע כאן למטה:
echo  ══════════════════════════════════════════
echo.

npx --yes localtunnel --port 3000

echo.
echo  השרת נסגר. לשיתוף שוב — הרץ את הקובץ הזה מחדש.
pause
