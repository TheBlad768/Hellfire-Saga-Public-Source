; ---------------------------------------------------------------------------
; Sonic Animation Script
; ---------------------------------------------------------------------------

AniSonic:
Ani_Sonic:
		dc.w SonAni_Walk-Ani_Sonic			; 0
		dc.w SonAni_Run-Ani_Sonic			; 1
		dc.w SonAni_Roll-Ani_Sonic			; 2
		dc.w SonAni_Roll2-Ani_Sonic			; 3
		dc.w SonAni_Push-Ani_Sonic			; 4
		dc.w SonAni_Wait-Ani_Sonic			; 5
		dc.w SonAni_Balance-Ani_Sonic		; 6
		dc.w SonAni_LookUp-Ani_Sonic		; 7
		dc.w SonAni_Duck-Ani_Sonic			; 8
		dc.w SonAni_Spin_Dash-Ani_Sonic		; 9
		dc.w byte_12BA8-Ani_Sonic			; A
		dc.w byte_12BBF-Ani_Sonic			; B
		dc.w SonAni_Balance2-Ani_Sonic		; C
		dc.w SonAni_Stop-Ani_Sonic			; D
		dc.w SonAni_Float1-Ani_Sonic			; E
		dc.w SonAni_Float2-Ani_Sonic			; F
		dc.w SonAni_Spring-Ani_Sonic			; 10
		dc.w SonAni_LZHang-Ani_Sonic		; 11
		dc.w SonAni_Leap1-Ani_Sonic			; 12
		dc.w SonAni_Landing-Ani_Sonic		; 13
		dc.w SonAni_Surf-Ani_Sonic			; 14
		dc.w SonAni_Bubble-Ani_Sonic			; 15
		dc.w SonAni_Death1-Ani_Sonic			; 16
		dc.w SonAni_Drown-Ani_Sonic			; 17
		dc.w SonAni_Death2-Ani_Sonic			; 18
		dc.w SonAni_Shrink-Ani_Sonic			; 19
		dc.w SonAni_Hurt-Ani_Sonic			; 1A
		dc.w SonAni_Blank-Ani_Sonic			; 1B
		dc.w SonAni_Float3-Ani_Sonic			; 1C
		dc.w SonAni_Float4-Ani_Sonic			; 1D
		dc.w SonAni_Run2-Ani_Sonic			; 1E
		dc.w SonAni_Wait2-Ani_Sonic			; 1F
		dc.w SonAni_LookLR-Ani_Sonic			; 20
		dc.w SonAni_LookL-Ani_Sonic			; 21
		dc.w SonAni_LookF-Ani_Sonic			; 22
		dc.w SonAni_LookU-Ani_Sonic			; 23
		dc.w SonAni_HandUp-Ani_Sonic		; 24
		dc.w SonAni_Flip-Ani_Sonic			; 25
		dc.w SonAni_Lies-Ani_Sonic			; 26
		dc.w SonAni_Tired-Ani_Sonic			; 27
		dc.w SonAni_Wonder-Ani_Sonic		; 28
		dc.w SonAni_RiseUp-Ani_Sonic		; 29

SonAni_Walk:		dc.b  $FF,   7,	  8,   1,   2,	 3,   4,   5,	6, $FF
SonAni_Run:			dc.b  $FF, $21,	$22, $23, $24, $8C, $8D, $8E, $8F, $FF, $FF, $FF, $FF, $FF
SonAni_Roll:		dc.b  $FE, $46, $46, $47, $A0, $46, $46, $48, $A1, $46, $46, $49, $A2, $46, $46, $4A, $A3, $FF
SonAni_Roll2:		dc.b  $FE, $46,	$47, $46, $A0, $46, $48, $46, $A1, $46, $49, $46, $A2, $46, $4A, $46, $A3, $FF
SonAni_Push:		dc.b  $FD, $61,	$62, $63, $64, $FF, $FF, $FF, $FF, $FF
SonAni_Wait:		dc.b    5, $65, $65, $65, $65, $89, $8A, $8A, $8A, $8A, $8B, $65, $65, $65, $65, $89, $8A, $8A, $8A, $8A
					dc.b  $8B, $65, $65, $65, $65, $89, $8A, $8A, $8A, $8A, $8B, $65, $65, $65, $65, $89, $8A, $8A, $8A, $8A
					dc.b  $8B, $65, $65, $65, $65, $89, $8A, $8A, $8A, $8A, $8B, $66, $67, $67, $68, $68, $69, $69, $68, $68
					dc.b  $69, $69, $68, $68, $69, $69, $68, $68, $69, $69, $68, $68, $69, $69, $68, $68, $69, $69, $68, $68
					dc.b  $69, $69, $68, $68, $69, $69, $5A, $5A, $5A, $5A, $5A, $5A, $5B, $5B, $5B, $5B, $5B, $5B, $5C, $6C
					dc.b  $6C, $6C, $6C, $6C, $6C, $5C, $5C, $FE, $35
SonAni_Balance:		dc.b	7, $54,	$55, $56, $FF
SonAni_LookUp:		dc.b	3, $6A,	$6B, $FE,   1
SonAni_Duck:		dc.b	3, $A4,	$A5, $FE,   1
SonAni_Spin_Dash:	dc.b	0, $3D,	$3E, $3D, $3F, $3D, $40, $3D, $41, $3D,	$42, $FF

byte_12BA8:			dc.b	9, $BA,	$C5, $C6, $C6, $C6, $C6, $C6, $C6, $C7,	$C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7,	$C7, $C7
					dc.b  $C7, $FD,   0
byte_12BBF:			dc.b   $F, $8F,	$FF
SonAni_Balance2:		dc.b	5, $51,	$52, $53, $FF

SonAni_Stop:			dc.b	3, $4D,	$4E, $4F, $50, $FD,   0
SonAni_Float1:		dc.b	7, $C8,	$FF
SonAni_Float2:		dc.b	7, $C8,	$C9, $CA, $CB, $CC, $CD, $CE, $CF, $FF
SonAni_Spring:		dc.b  $2F, $45,	$FD,   0
SonAni_LZHang:		dc.b	1, $AA,	$AB, $FF
SonAni_Leap1:		dc.b   $F, $43,	$43, $43, $FE,	 1
SonAni_Landing:		dc.b	7, $5D,	$5E, $5F, $FE,	 1
SonAni_Surf:			dc.b  $13, $88,	$FF
SonAni_Bubble:		dc.b   $B, $59,	$59,   3,   4, $FD,   0
SonAni_Death1:		dc.b  $20, $57,	$FF
SonAni_Drown:		dc.b  $20, $58,	$FF
SonAni_Death2:		dc.b	$20, $57,	$FF
SonAni_Shrink:		dc.b  $40, $8D,	$FF
SonAni_Hurt:		dc.b 9, $43, $44, $FF
SonAni_Blank:		dc.b $77,   0,	$FF
SonAni_Float3:		dc.b 3,	$3C, $3D, $53, $3E, $54, $FF, 0
SonAni_Float4:		dc.b 3,	$3C, $FD, 0
SonAni_Run2:		dc.b  2, $8C, $8D, $8E, $8F, $90, $91, $92, $93, $FF, $FF, $FF, $FF, $FF
SonAni_Wait2:		dc.b 5, $65, $65, $65, $65, $89, $8A, $8A, $8A, $8A, $8B, $65, $65, $65, $65, $89, $8A, $8A, $8A, $8A, $FF, 0
SonAni_LookLR:		dc.b 7, $71, $71, $71, $71, $70, $6F, $6E, $6E, $6E, $6E, $6E, $6E, $6F, $70, $71, $FE, 1
SonAni_LookL:		dc.b	$E, $73, $FF, 0
SonAni_LookF:		dc.b $E, $74, $FF, 0
SonAni_LookU:		dc.b $E, $75, $FF, 0
SonAni_HandUp:		dc.b $E, $76, $FF, 0
SonAni_Flip:			dc.b 5, $77, $9C, $78, $9D, $79, $9E, $7A, $9F, $FF
SonAni_Lies:			dc.b $E, $7D, $FF, 0
SonAni_Tired:		dc.b 9, $7E, $7F, $FF, 0
SonAni_Wonder:		dc.b $E, $81, $FF, 0
SonAni_RiseUp:		dc.b	$10, $70, $81, $45, $FE, $01
	even

id_Walk:			equ 0
id_Run:			equ 1
id_Roll:			equ 2
id_Roll2:			equ 3
id_Push:			equ 4
id_Wait:			equ 5
id_Balance:		equ 6
id_LookUp:		equ 7
id_Duck:			equ 8
id_SpinDash:		equ 9
id_Blink			equ $A
id_GetUp		equ $B
id_Balance2:		equ $C
id_Stop:			equ $D
id_Float1:		equ $E
id_Float2:		equ $F
id_Spring:		equ $10
id_Hang:		equ $11
id_Leap1:		equ $12
id_Landing:		equ $13
id_Surf:			equ $14
id_GetAir:		equ $15
id_Burnt:		equ $16
id_Drown:		equ $17
id_Death:		equ $18
id_Shrink:		equ $19
id_Hurt:			equ $1A
id_Null:			equ $1B
id_Float3:		equ $1C
id_Float4:		equ $1D
id_Run2:		equ $1E
id_Wait2:		equ $1F
id_LookLR:		equ $20
id_LookL:		equ $21
id_LookF:		equ $22
id_LookU:		equ $23
id_HandUp:		equ $24
id_Flip:			equ $25
id_Lies:			equ $26
id_Tired:		equ $27
id_Wonder:		equ $28
id_Rise:		equ $29