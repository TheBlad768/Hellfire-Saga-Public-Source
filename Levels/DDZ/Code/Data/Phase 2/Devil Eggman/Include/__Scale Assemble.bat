@echo off
"__Asm68k.exe" /o ae- /o l. /p /q "_ScaleH.asm", "_ScaleH.bin"
if "%1"=="1" goto Finish
pause
:Finish