; ---------------------------------------------------------------------------
; Dr. Eggman, final boss of hack
; ---------------------------------------------------------------------------

Obj_Eggman:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Eggman_Index(pc,d0.w),d1
		jsr	Obj_Eggman_Index(pc,d1.w)
		jmp	(Draw_And_Touch_Sprite).w
; ===========================================================================

Obj_Eggman_Index:
		dc.w Obj_Eggman_Main-Obj_Eggman_Index
		dc.w Obj_Eggman_ShipMain-Obj_Eggman_Index
; ===========================================================================

Obj_Eggman_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_EggmanBoss,obMap(a0)
		move.w	#$370,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#0,obColType(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$1F,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$1F,y_radius(a0)
		move.w  #59,obTimer(a0)
		move.b	#0,obAnim(a0)						; set touch response
		move.w  obX(a0),obX(a0)					; copy X-pos to secondary X-pos
		move.w	obY(a0),obY(a0)					; copy Y-pos to secondary Y-pos
		move.b  #8,$29(a0)  ;

Obj_Eggman_ShipMain:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj_Eggman_ShipIndex(pc,d0.w),d1
		jsr	Obj_Eggman_ShipIndex(pc,d1.w)
		bsr.w	Obj_Eggman_ShipProcess
		bsr.w	Obj_Eggman_CheckVictory
		lea	(Ani_Eggman).l,a1
		jmp	(AnimateSprite).w
; ===========================================================================

Obj_Eggman_ShipIndex:
		dc.w Obj_Eggman_SetUpTimer-Obj_Eggman_ShipIndex ; 0
		dc.w Obj_Eggman_ChkSonic-Obj_Eggman_ShipIndex ; 2
		dc.w Obj_Eggman_Laughing-Obj_Eggman_ShipIndex ; 4
		dc.w Obj_Eggman_Combat-Obj_Eggman_ShipIndex ; 6
		dc.w Obj_Eggman_Cast-Obj_Eggman_ShipIndex ; 8
		dc.w Obj_Eggman_Jump-Obj_Eggman_ShipIndex ; $A
		dc.w Obj_Eggman_Jump2-Obj_Eggman_ShipIndex ; $C
		dc.w Obj_Eggman_SitDown-Obj_Eggman_ShipIndex ; $E
		dc.w Obj_Eggman_GotoCredits-Obj_Eggman_ShipIndex ; $10
		dc.w Obj_Eggman_Victory-Obj_Eggman_ShipIndex ; $12
; ===========================================================================

Obj_Eggman_ShipProcess:
		tst.b	$1C(a0)
		beq.s   Obj_Eggman_lacricium
		move.b	#5,obAnim(a0)
		subq.b	#1,$1C(a0)
		bne.s	Obj_Eggman_lacricium

+		cmpi.b	#$A,routine_secondary(a0)
		blt.s   +
		move.b  #4,obAnim(a0)
		bra.w	Obj_Eggman_clrstats
+		move.b  #3,obAnim(a0)


Obj_Eggman_clrstats:
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)
		tst.b   $29(a0)
		bne.s   Obj_Eggman_lacricium
		move.b  #$E,routine_secondary(a0)
		bra.w	Obj_Eggman_lacricium


Obj_Eggman_CheckVictory:
		lea	(Player_1).w,a1
		cmpi.b	#id_Null,obAnim(a1)
		bne.s	Obj_Eggman_lacricium
		move.w	#0,obVelX(a0)
		move.b  #$12,routine_secondary(a0)


Obj_Eggman_lacricium:
		rts
; ===========================================================================
;loc_1784C:
Obj_Eggman_ShipGone:
		move.b	#0,obColType(a0)
		move.b  #6,obAnim(a0)
		move.b	#$C,routine_secondary(a0)	; set routine to 8 (Obj93_Explode)
                rts
; ===========================================================================

Obj_Eggman_SetUpTimer:
		cmpi.b  #$01,(Check_dead).w
		beq.s   +
		move.b	#1,(Lust_Cutscene).w
		move.w  #360,obTimer(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggMonologue,(a1)
		move.w	#$3D0,obX(a1)
		move.w	#$17D,obY(a1)
+		addq.b  #2,routine_secondary(a0)

Obj_Eggman_ChkSonic:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Eggman_Return
		move.b  #$78,obTimer(a0)
		addq.b  #2,routine_secondary(a0)
		move.b	#1,obAnim(a0)
		move.b  #$01,(Check_dead).w
                moveq 	#dMwahaha,d0
                jsr 	(SMPS_PlayDACSample).l
		move.b	#0,(Lust_Cutscene).w
		moveq 	#bgm_EggmanDevil,d0
		jmp   	(PlaySound).l

Obj_Eggman_Laughing:
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_Eggman_Return
		clr.b	(Ctrl_1_locked).w
		move.b  #$5A,obTimer(a0)
		addq.b  #2,routine_secondary(a0)
		move.b	#2,obAnim(a0)

Obj_Eggman_Combat:
		move.b	#$83,obColType(a0)
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.w	Obj_Eggman_Return
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		cmpi.b  #5,obAnim(a0)
		beq.w   Obj_Eggman_Return
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_Eggman_Return
		move.b  #$5A,obTimer(a0)
		move.b	#0,d0
		jsr     (RandomNumber).w
                andi.b  #3,d0
		cmpi.b  #3,d0
		beq.s   +
		move.b  #$3C,obTimer(a0)
		addq.b  #2,routine_secondary(a0)
		move.b  #3,obAnim(a0)
		bra.w	Obj_Eggman_Return
+		addq.b  #4,routine_secondary(a0)
		move.b  #4,obAnim(a0)
		bra.w	Obj_Eggman_Return

Obj_Eggman_Cast:
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.w	Obj_Eggman_Return
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		cmpi.b  #5,obAnim(a0)
		beq.w   Obj_Eggman_Return
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_Eggman_Return

		cmpi.b  #0,obSubtype(a0)
		beq.w   FireCast
		cmpi.b  #1,obSubtype(a0)
		beq.w   EnergyBallCast
		cmpi.b  #2,obSubtype(a0)
		beq.w   StoneCast
		cmpi.b  #3,obSubtype(a0)
		beq.w   EggBombCast

FireCast:
		move.b  #$3C,obTimer(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggFireball,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(Player_1+obY).w,d0
		sub.w	obY(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelY(a1)
                move.w 	#$400,obVelX(a1);
		add.w   #8,obX(a1)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a1)
		sub.w   #$10,obX(a1)


+		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggFireball,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(Player_1+obY).w,d0
		sub.w	obY(a0),d0
		sub.w	#$30,d0
		asl.w	#2,d0
		move.w	d0,obVelY(a1)
                move.w 	#$380,obVelX(a1);
		add.w   #8,obX(a1)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a1)
		sub.w   #$10,obX(a1)

+		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggFireball,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(Player_1+obY).w,d0
		sub.w	obY(a0),d0
		add.w	#$30,d0
		asl.w	#2,d0
		move.w	d0,obVelY(a1)
                move.w 	#$380,obVelX(a1);
		add.w   #8,obX(a1)
		btst	#0,obStatus(a0)
		bne.w	ReturnToNormalEgg
		neg.w	obVelX(a1)
		sub.w   #$10,obX(a1)
		bra.w	ReturnToNormalEgg

StoneCast:
		move.b  #$43,obTimer(a0)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggStone,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		add.w	#$30,obX(a1)
		move.w	#$1D0,obY(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggStone,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		sub.w	#$28,obX(a1)
		move.w	#$1D0,obY(a1)

		bra.w	ReturnToNormalEgg

MiniFireCast:
		move.b  #$3C,obTimer(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggMiniFire,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w 	#-$600,obVelY(a1);
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		add.w   #8,obX(a1)

+		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggMiniFire,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w 	#-$800,obVelY(a1);
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		add.w   #$60,obVelX(a1)
		add.w   #8,obX(a1)

+		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggMiniFire,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w 	#-$500,obVelY(a1);
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		sub.w   #$60,obVelX(a1)
		sub.w   #8,obX(a1)
		bra.w	ReturnToNormalEgg

EnergyBallCast:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggEnergyBall,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w 	#-$600,obVelY(a1);
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		add.w   #8,obX(a1)
		move.b  #$50,obTimer(a0)
		bra.w	ReturnToNormalEgg

EggBombCast:
		move.b  #$3C,obTimer(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_EggBomb,(a1)	; load missile object
		movea.w a0,$46(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w 	#-$700,obVelY(a1);
		add.w   #8,obX(a1)
		btst	#0,obStatus(a0)
		bne.w	ReturnToNormalEgg
		neg.w	obVelX(a1)
		sub.w   #$10,obX(a1)


ReturnToNormalEgg:
		move.w	#sfx_FireAttack,d0
		jsr	(PlaySound_Special).l ;	play flame sound
		move.b	#6,routine_secondary(a0)
		move.b	#2,obAnim(a0)
		add.b	#1,obSubtype(a0)
		cmpi.b	#4,obSubtype(a0)
		bne.s	+
		move.b	#0,obSubtype(a0)
+		rts

Obj_Eggman_Jump:
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.w	Obj_Eggman_Return
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		addq.b	#2,routine_secondary(a0)
		move.w	#-$500,obVelY(a0)
                move.w 	#$E0,obVelX(a0)
		btst	#0,obStatus(a0)
		bne.w	Obj_Eggman_Return
		neg.w	obVelX(a0)

Obj_Eggman_Jump2:
		jsr	(SpeedToPos).w
           	jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Eggman_Return
                add.w d1,obY(a0)
		cmpi.w	#$3E2,obX(a0)
		blt.s   +
		move.w	#$3E2,obX(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_Explosion,(a1)
                move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
+		cmpi.w	#$2D1,obX(a0)
		bcc.s   +
		move.w	#$2D1,obX(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Eggman_Return
		move.l	#Obj_Explosion,(a1)
                move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
+		move.b	#6,routine_secondary(a0)
		move.b	#2,obAnim(a0)
		rts

; ===========================================================================

Obj_Eggman_SitDown:
             	jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Eggman_Return
                add.w d1,obY(a0)
		move.b  #$00,(Check_dead).w
		move.w  #120,obTimer(a0)
		addq.b  #2,routine_secondary(a0)
		move.w	#0,obVelY(a0)
                move.w 	#0,obVelX(a0)

Obj_Eggman_GotoCredits:
		move.b	#6,obAnim(a0)
		subq.w	#1,obTimer(a0)
		bpl.s	Obj_Eggman_Return
		move.b	#id_Credits,(Game_mode).w
		bra.w	Obj_Eggman_Return

Obj_Eggman_Victory:
             	jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Eggman_Return
                add.w d1,obY(a0)
		move.w	#0,obVelY(a0)
		move.b	#1,obAnim(a0)

; ===========================================================================

Obj_Eggman_Return:
		rts



		include "Objects/Bosses/Eggman/Object data/Ani - Eggman.asm"
		include "Objects/Bosses/Eggman/Object data/Map - Eggman.asm"