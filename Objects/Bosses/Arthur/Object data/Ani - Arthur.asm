Ani_Arthur:
		dc.w byte_Stand-Ani_Arthur			; 0
		dc.w byte_Run-Ani_Arthur			; 1
		dc.w byte_Jump-Ani_Arthur			; 2
		dc.w byte_Attack-Ani_Arthur 		; 3
		dc.w byte_Spear-Ani_Arthur 			; 4
		dc.w byte_Firebomb-Ani_Arthur 		; 5
		dc.w byte_Flame-Ani_Arthur 			; 6
		dc.w byte_1shard-Ani_Arthur 		; 7
		dc.w byte_2shard-Ani_Arthur 		; 8
		dc.w byte_3shard-Ani_Arthur 		; 9
		dc.w byte_4shard-Ani_Arthur 		; $A
		dc.w byte_Axe-Ani_Arthur 			; $B
		dc.w byte_Hurt-Ani_Arthur 			; $C
		dc.w byte_AttackPrepare-Ani_Arthur	; $D

	; Arthur (Map - Arthur.asm)
						;	speed,	frame data
byte_Stand:				dc.b $00,	$00, $FF, $00
byte_Run:				dc.b $04,	$01, $02, $03, $04, $05, $06, $07, $08, $FF, 0
byte_Jump:				dc.b $00,	$0D, $FF, $00
byte_Attack:			dc.b $08,	$0C, $00, $FE, 1
byte_Hurt:				dc.b $00,	$00, $FF, $00		; is this used???
byte_AttackPrepare:		dc.b $02,	$09, $0A, $09, $0A	; Blink
						dc.b 		$0B, $FD, 3			; Throw

	; Attacks (Map - Weapon.asm)
				;	speed,	frame data
byte_Spear:		dc.b $00,	$0D, $FF, 0
byte_Firebomb:	dc.b $02,	$0E, $0F, $FF, 0
byte_Flame:		dc.b $01,	$10, $11, $12, $13		; Flame rising
				dc.b		$14, $15, $16, $17		; Flame Loop
				dc.b		$14, $15, $16, $17		
				dc.b		$18, $19, $FF			; Flame extinguish
byte_Axe:		dc.b $02,	$05, $06, $07, $08, $09, $0A, $0B, $0C, $FF

	; Armour Shards (Map - Weapon.asm)
				;	speed,	frame data
byte_1shard:	dc.b $00,	$01, $FF, 0
byte_2shard:	dc.b $00,	$02, $FF, 0
byte_3shard:	dc.b $00,	$03, $FF, 0
byte_4shard:	dc.b $00,	$04, $FF, 0
	even