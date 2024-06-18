@Echo off
IF EXIST HellfireSaga.gen del HellfireSaga.gen
IF EXIST _ParametersProduction.p del _ParametersProduction.p
IF EXIST _ParametersProduction.h del _ParametersProduction.h
IF EXIST _ParametersProduction.p goto LABLERROR1

node "Fractal/Code/game.js" -as -base "Fractal" "Fractal/Data.json5"

set AS_MSGPATH=Win32
set USEANSI=n
"Win32/asw.exe" -xx -q -c -A -L -i "%cd%" _ParametersProduction.asm
IF EXIST _ParametersProduction.log type _ParametersProduction.log
IF NOT EXIST _ParametersProduction.p pause & exit

"Win32/s1p2bin.exe" _ParametersProduction.p HellfireSaga.gen _ParametersProduction.h
IF EXIST _ParametersProduction.p del _ParametersProduction.p
IF EXIST _ParametersProduction.h del _ParametersProduction.h

"Win32/ConvSym.exe" _ParametersProduction.lst HellfireSaga.gen -a -input as_lst
REM "Win32/rompad"  HellfireSaga.gen 255 0
"Win32/fixheader.exe" HellfireSaga.gen

REM IF EXIST _ParametersProduction.lst del _ParametersProduction.lst

IF NOT EXIST HellfireSaga.gen pause & exit 1
exit 0

:LABLERROR1
echo Failed to build because write access to _ParametersProduction.p was denied.
pause
exit 1
