@echo off

set MAINDIR=%CD%
set COMPDIR="C:\MinGW\mingw64\bin"
cd /d %COMPDIR%
setlocal
set PATH=%COMPDIR%

g++.exe -static-libgcc -static-libstdc++ "%MAINDIR%\_Divu Remover.c" -DUSEGDI -lgdi32 -lgdiplus -o "%MAINDIR%\_Divu Remover.exe"

pause
