@Echo off

IF EXIST SoundTest.gen del SoundTest.gen
IF EXIST "Fractal\Code\SoundTest.p" del "Fractal\Code\SoundTest.p"
IF EXIST "Fractal\Code\SoundTest.h" del "Fractal\Code\SoundTest.h"
IF EXIST "Fractal\Code\SoundTest.p" goto LABLERROR1
IF EXIST Sonic.log del Sonic.log

node "Fractal/Code/game.js" -as -base "Fractal" "Fractal/Data.json5"
pause
IF %ERRORLEVEL% NEQ 0 pause & exit 1

set AS_MSGPATH=Win32
set USEANSI=n
"Win32/asw.exe" -xx -q -c -A -L -i "%cd%" "Fractal/Code/SoundTest.asm"

IF EXIST "Fractal\Code\SoundTest.log" move "Fractal\Code\SoundTest.log" Sonic.log
IF EXIST "Fractal\Code\SoundTest.lst" move "Fractal\Code\SoundTest.lst" Sonic.lst

IF EXIST Sonic.log type Sonic.log
IF NOT EXIST "Fractal\Code\SoundTest.p" pause & exit 1

"Win32/s1p2bin.exe" "Fractal/Code/SoundTest.p" SoundTest.gen "Fractal/Code/SoundTest.h"
IF EXIST "Fractal\Code\SoundTest.p" del "Fractal\Code\SoundTest.p"
IF EXIST "Fractal\Code\SoundTest.h" del "Fractal\Code\SoundTest.h"

"Win32/convsym.exe" Sonic.lst SoundTest.gen -a -input as_lst
REM // "Win32/rompad"  SoundTest.gen 255 0
"Win32/fixheadr.exe" SoundTest.gen

IF NOT EXIST SoundTest.gen pause & exit 1
exit 0

:LABLERROR1
echo Failed to build because write access to Sonic.p was denied.
pause
exit 1
