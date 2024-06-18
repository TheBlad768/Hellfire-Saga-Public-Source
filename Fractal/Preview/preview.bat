@echo off
pushd %~dp0
cd ../../

rem Check if nodejs is installed
node -v > Nul
if "%errorlevel%" == "9009" echo nodejs is not installed! Please install nodejs v16 or higher: https://nodejs.org/ && goto error

rem Check if ASM68K is installed
if not exist "asm68k.exe" echo asm68k.exe is not found! Please make sure to put asm68k.exe in the root directory. && goto error

node "Fractal/Code/makeROM.js" -base "Fractal" %*
if %errorlevel% NEQ 0 goto error

"asm68k" /p /m "Fractal/Preview/Shell.asm", "Fractal/Preview/preview.gen", , "Fractal/Preview/preview.lst"
if %errorlevel% NEQ 0 goto error
error\convsym "Fractal/Preview/preview.lst" "Fractal/Preview/preview.gen" -input asm68k_lst -inopt "/localSign=. /localJoin=. /ignoreMacroDefs+ /ignoreMacroExp- /addMacrosAsOpcodes+" -a
goto :eof

:error
echo Conversion aborted!
pause
