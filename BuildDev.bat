@Echo off
IF EXIST HellfireSagaDev.gen del HellfireSagaDev.gen
IF EXIST _ParametersDev.p del _ParametersDev.p
IF EXIST _ParametersDev.h del _ParametersDev.h
IF EXIST _ParametersDev.p goto LABLERROR1

node "Fractal/Code/game.js" -as -base "Fractal" "Fractal/Data.json5"

set AS_MSGPATH=Win32
set USEANSI=n
"Win32/asw.exe" -xx -q -c -A -L -i "%cd%" _ParametersDev.asm
IF EXIST _ParametersDev.log type _ParametersDev.log
IF NOT EXIST _ParametersDev.p pause & exit

"Win32/s1p2bin.exe" _ParametersDev.p HellfireSagaDev.gen _ParametersDev.h
IF EXIST _ParametersDev.p del _ParametersDev.p
IF EXIST _ParametersDev.h del _ParametersDev.h

"Win32/ConvSym.exe" _ParametersDev.lst HellfireSagaDev.gen -a -input as_lst
REM "Win32/rompad"  HellfireSagaDev.gen 255 0
"Win32/fixheader.exe" HellfireSagaDev.gen

REM IF EXIST _ParametersDev.lst del _ParametersDev.lst

IF NOT EXIST HellfireSagaDev.gen pause & exit 1
exit 0

:LABLERROR1
echo Failed to build because write access to _ParametersDev.p was denied.
pause
exit 1
