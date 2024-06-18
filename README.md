# Hellfire Saga

## Build

To build the ROM, you first need to copy the ```_ParametersDev.asm.example``` file into ```_ParametersDev.asm``` and set the game parameters there.

```asm
; ===========================================================================
; User build options
; ===========================================================================

; This is an example file. 
; Before building, copy this file into _ParametersDev.asm (without the .example suffix).
; After that, set the parameters and run Build.bat.

; This way these parameters can be changed without having to deal with git conflicts.
; _ParametersDev.asm MUST be excluded from git.

Debug_Title         = 1     ; set to 1 to enable title screen
GameDebug           = 1     ; If 1, enable debug mode for sonic
Debug_Lagometer     = 1     ; set to 1 to enable CPU lagometer
Debug_EasyBoss      = 1     ; set to 1 to make every boss 1-hit kill

DisableSRAM         = 0     ; set to 1 to create a ROM without SRAM

Debug_LevelId       = -1    ; $0202 ; set to -1 to disable debugging a level
Debug_Xpos          = $0234 ; xpos to spawn to
Debug_Ypos          = $0728 ; ypos to spawn to

; ---------------------------------------------------------------------------

    include "Sonic.asm"
```

Afterwards:

- ```BuildDev.bat``` builds a dev build with the provided parameters.
- ```BuildProduction.bat``` builds a production build intended for releases.

This process requires Node.js for Fractal.

Do note that ```build.sh``` is out of date.

# Usage of parts made by Red Miso Studios

## I want to study them

Feel free to!

## I want to take something from them

You can use material from here, as long as you:
- make it clear that material comes from Hellfire Saga; 
- give credit to Red Miso Studios.

You also can not use logos of Hellfire Saga or Red Miso Studios in your own projects.

## I want to fork this

You can make a build of this, as long as you:
- make it clear this is a fork and not a build made by Red Miso Studios;
- make it clear the build derives from Hellfire Saga;
- leave credits to Red Miso Studios in the game.

# DISCLAIMER

Any and all content presented in this repository is presented for informational and educational purposes only. Commercial usage is expressly prohibited. We claim no ownership of any of the original Sonic 3 & Knuckles code. You assume any and all responsibility for using this content responsibly.

