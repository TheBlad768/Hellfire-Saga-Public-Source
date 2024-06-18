@echo off

set MAINDIR=%CD%
set COMPDIR="C:\MinGW\mingw64\bin"
cd /d %COMPDIR%
setlocal
set PATH=%COMPDIR%

g++.exe -static-libgcc -static-libstdc++ "%MAINDIR%\__Scale Stripper.c" -DUSEGDI -lgdi32 -lgdiplus -o "%MAINDIR%\__Scale Stripper.exe"
g++.exe -static-libgcc -static-libstdc++ "%MAINDIR%\__Scale Routines.c" -DUSEGDI -lgdi32 -lgdiplus -o "%MAINDIR%\__Scale Routines.exe"

pause
