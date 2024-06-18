@echo off

set MAINDIR=%CD%
set COMPDIR="C:\MinGW\mingw64\bin"
cd /d %COMPDIR%
setlocal
set PATH=%COMPDIR%

g++.exe -O3 -static-libgcc -static-libstdc++ "%MAINDIR%\_Vortex Maker.c" -DUSEGDI -lgdi32 -lgdiplus -lglu32 -lopengl32 -lwinmm -o "%MAINDIR%\_Vortex Maker.exe"

g++.exe -static-libgcc -static-libstdc++ "%MAINDIR%\_Vortex Plane Arranger.c" -DUSEGDI -lgdi32 -lgdiplus -o "%MAINDIR%\_Vortex Plane Arranger.exe"


pause
