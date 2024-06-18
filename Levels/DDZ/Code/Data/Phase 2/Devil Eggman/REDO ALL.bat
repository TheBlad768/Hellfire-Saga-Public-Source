@echo off
set MAINDIR=%CD%

REM Need to use the full path, or else ArgList [0] will only contain the file name, not the directory...

"%MAINDIR%\Devil Maker.exe" 1

CD "%MAINDIR%\Include"
set MAINDIR=%CD%

"%MAINDIR%\__Scale Stripper.exe" 1
"%MAINDIR%\__Scale Routines.exe" 1
call "%MAINDIR%\__Scale Assemble.bat" 1

CD "%MAINDIR%\.."
set MAINDIR=%CD%
CD "%MAINDIR%\MulToID"
"_Divu Remover.exe" 1

pause