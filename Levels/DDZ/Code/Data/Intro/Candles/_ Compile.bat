@echo off

set MAINDIR=%CD%
set COMPDIR="C:\MinGW\mingw64\bin"
cd /d %COMPDIR%
setlocal
set PATH=%COMPDIR%

g++.exe -O3 -static-libgcc -static-libstdc++ -Wno-deprecated-declarations "%MAINDIR%\__Candles.c" -DUSEGDI -lgdi32 -lgdiplus -o "%MAINDIR%\__Candles.exe"

pause
