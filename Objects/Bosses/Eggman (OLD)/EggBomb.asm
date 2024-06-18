; ===========================================================================
; Egg Bomb, the only way to hurt Eggman
; ===========================================================================

Obj_EggBomb:
		move.l	#Map_EggmanBoss,obMap(a0)
		move.w	#$370,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#8,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#8,y_radius(a0)
		move.b	#$A,obAnim(a0)
		movea.w $46(a0),a1
		move.w a0,$46(a1)
		move.l	#Obj_EggBomb_FindSonic,(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)

Obj_EggBomb_FindSonic:
		cmpi.w  #0,obVelX(a0)
		blt.w   .isnegative
		cmpi.w   #$130,obVelX(a0)
		blt.s	.setminspeed
		bra.w	.final

.setminspeed:
		move.w	#$130,obVelX(a0)
		bra.w	.final

.isnegative:
		cmpi.w   #-$130,obVelX(a0)
		bcc.s	.setmaxspeed
		bra.w	.final

.setmaxspeed:
		move.w	#-$130,obVelX(a0)

.final:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bmi.w	+
								; При появлении бомба падает
		lea	(Player_1).w,a1						; Адрес соника
		lea	obDatum_CheckXY(pc),a2				; Данные для проверки позиции
		jsr	(Check_InMyRange).w
		beq.w	Obj_EggBomb_Draw				; Если соник не пересек позицию, переход

		jsr	(Check_PlayerAttack).l					; Проверить анимацию соника
	;	beq.w	Obj_EggBomb_HurtCharacter		; Если есть анимация атаки, переход
		beq.w	Obj_EggBomb_CheckForDebug
		bra.s	Obj_EggBomb_SetSpeeds

+               move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		move.w	#1,obSubtype(a0)

Obj_EggBomb_SetSpeeds:
		move.l	#Obj_EggBomb_FindBoss,(a0)		; Изменить адрес текущего объекта
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#$380,d2						; Скорость XY
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)					; Скорость X
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)					; Скорость Y

Obj_EggBomb_FindBoss:
		jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bmi.w	+
		movea.w	$46(a0),a1
		lea	obDatum_CheckXY(pc),a2
		jsr	(Check_InTheirRange).l
		beq.w	Obj_EggBomb_Draw

		bset	#6,$2A(a1)

		move.b	#$1D,$1C(a1)

		subq.b	#1,$29(a1)

		move.w	#sfx_KnucklesKick,d0
		jsr	(PlaySound_Special).l

		; Добавь свой код урона здесь

+               move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		move.w	#1,obSubtype(a0)
;		move.l	#Delete_Current_Sprite,(a0)

Obj_EggBomb_Return:
		rts

Obj_EggBomb_CheckForDebug;
		tst.w	(Debug_placement_mode).w			; is debug cheat enabled?
		beq.w	Obj_EggBomb_HurtCharacter			; if not, branch
; ---------------------------------------------------------------------------

Obj_EggBomb_Draw:
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).w
 		jmp	(Sprite_CheckDeleteTouchXY).w		; Эта функция уже имеет DisplaySprite
; ---------------------------------------------------------------------------

Obj_EggBomb_HurtCharacter:
;		pea	(Delete_Current_Sprite).w
		moveq	#sfx_Wallbreak,d0
		jsr	(Play_Sound_2).l
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		move.l	a0,-(sp)
		jsr	(HurtCharacter_Directly).l
		movea.l	(sp)+,a0
		rts
; ---------------------------------------------------------------------------

obDatum_CheckXY:	; Размер координат 4x4(Размер спрайта ?x?)
		dc.w -32
		dc.w 64
		dc.w -32
		dc.w 64