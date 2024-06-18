@echo off

set MAINDIR=%CD%
set COMPDIR="C:\MinGW\mingw64\bin"
cd /d %COMPDIR%
setlocal
set PATH=%COMPDIR%

g++.exe -O3 -static-libgcc -static-libstdc++ -Wno-deprecated-declarations "%MAINDIR%\LineMaker.c" -DUSEGDI -lgdi32 -lgdiplus -o "%MAINDIR%\LineMaker.exe"

pause
