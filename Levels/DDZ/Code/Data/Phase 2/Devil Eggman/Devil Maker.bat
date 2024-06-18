@echo off

set MAINDIR=%CD%
set COMPDIR="C:\MinGW\mingw64\bin"
cd /d %COMPDIR%
setlocal
set PATH=%COMPDIR%

g++.exe -static-libgcc -static-libstdc++ "%MAINDIR%\Devil Maker.c" -DUSEGDI -lgdi32 -lgdiplus -o "%MAINDIR%\Devil Maker.exe"

pause
