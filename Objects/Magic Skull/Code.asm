
Obj_MSkull:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	MSkull_Index(pc,d0.w),d1
		jsr	MSkull_Index(pc,d1.w)

		bsr.w	Obj_MSkull_Process

		lea	Ani_MSkull(pc),a1
		jsr	(AnimateSprite).w
		jmp	(DisplaySprite).w
; ---------------------------------------------------------------------------

MSkull_Index:
		dc.w MSkull_Main-MSkull_Index	; 0
		dc.w MSkull_Collect-MSkull_Index	; 0
		dc.w MSkull_Collect2-MSkull_Index	; 0
		dc.w MSkull_Return-MSkull_Index	; 0
		dc.w MSkull_Collect3-MSkull_Index	; 0
		dc.w MSkull_Return2-MSkull_Index	; 0
; ---------------------------------------------------------------------------

Obj_MSkull_Process:
		tst.b   $29(a0)
		beq.s   Obj_MSkull_gone
		bra.w   MSkull_Return

Obj_MSkull_gone:
		tst.w	(Skull_Invulnerability).w
		bne.s	+
		move.b	#8,routine(a0)
+		rts
; ---------------------------------------------------------------------------

MSkull_Main:
		addq.b	#2,routine(a0)
		cmpi.w	#$200,(Current_zone_and_act).w
		beq.w	.gmzgfx
		move.w	#$4CA,obGfx(a0)
		bra.s   .cont
		
.gmzgfx:
		move.w	#$3A0,obGfx(a0)

.cont:
		move.l	#Map_MSkull,obMap(a0)
		move.b	#4,render_flags(a0)
		move.w	#$100,priority(a0)
		move.b	#8,width_pixels(a0)
		move.b	#1,$29(a0)
		move.b	#0,obAnim(a0)
		jmp	(Swing_Setup_Hellgirl).w

MSkull_Collect:
		jsr	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
	if GameDebug=1
		tst.w	(Debug_placement_mode).w
		bne.w	MSkull_Return
	endif
		lea	(Player_1).w,a1						; ����� ������
		lea	obDatum_MSkull_CheckXY(pc),a2				; ������ ��� �������� �������
		jsr	(Check_InMyRange).w
		beq.w	MSkull_Return					; ���� ����� �� ������� �������, �������
		move.w	#$78,$2E(a0)
		fadeout							; fade out music
		move.w	#780,(Skull_Invulnerability).w

		cmpi.w	#$002,(Current_zone_and_act).w
		beq.w	.pafdz3sp
		cmpi.w	#$200,(Current_zone_and_act).w
		beq.w	.pagmz2sp
		cmpi.w	#$201,(Current_zone_and_act).w
		beq.w	.pagmz2sp

		lea	(Pal_FDZSpirits+$20).l,a1
		jsr	(PalLoad_Line2).w
		lea	(Pal_FDZSpirits+$40).l,a1
		jsr	(PalLoad_Line3).w
		bra	.cont

.pafdz3sp:
		lea	(Pal_FDZ3Spirits+$20).l,a1
		jsr	(PalLoad_Line2).w
		lea	(Pal_FDZ3Spirits+$40).l,a1
		jsr	(PalLoad_Line3).w
		bra	.cont

.pagmz2sp:
		lea	(Pal_GMZ2Spirits+$20).l,a1
		jsr	(PalLoad_Line2).w
		lea	(Pal_GMZ2Spirits+$40).l,a1
		jsr	(PalLoad_Line3).w

.cont:
		addq.b	#2,routine(a0)
		move.b	#1,obAnim(a0)
		jsr	(Obj_MSkull_Flash).l;
		subq.b	#1,$29(a0)

MSkull_Collect2:
		subq.w	#1,$2E(a0)
		bpl.w	MSkull_Return
		command	cmd_FadeReset				; ensure fadeout is reset
		music	mus_Invincible
		addq.b	#2,routine(a0)

MSkull_Return:
		rts

MSkull_Collect3:
		tst.w	dxFadeOff.w
		bne.w	MSkull_Return2
		cmpi.b	#1,(MidBoss_flag).w
		beq.s	.microbossmusic
		cmpi.b	#1,(Boss_flag).w
		beq.s   .bossmusic
		jsr	(Obj_PlayLevelMusic).w
		bra.s	.returngfx
		
.microbossmusic:
		music	mus_Microboss
                bra.s   .returngfx
.bossmusic:
                music   mus_Boss1

.returngfx:
		command	cmd_FadeReset				; ensure fadeout is reset
		jsr	(Obj_MSkull_Flash).l

		cmpi.w	#$002,(Current_zone_and_act).w
		beq.w	.pafdz3
		cmpi.w	#$200,(Current_zone_and_act).w
		beq.w	.pagmz
		cmpi.w	#$201,(Current_zone_and_act).w
		beq.w	.pagmz2

		lea	(Pal_FDZ+$20).l,a1
		jsr	(PalLoad_Line2).w
		lea	(Pal_FDZ+$40).l,a1
		jsr	(PalLoad_Line3).w
		move.l	#Delete_Current_Sprite,(a0)
		rts

.pafdz3:

		cmpi.b	#4,(Dynamic_resize_routine).w
		bcc.s	.loadother
		lea	(Pal_FDZ3+$20).l,a1
		jsr	(PalLoad_Line2).w
		bra	.cont

.loadother:
		jsr	FDZ3_LoadRainPalette2

.cont:
		lea	(Pal_FDZ3+$40).l,a1
		jsr	(PalLoad_Line3).w
		move.l	#Delete_Current_Sprite,(a0)
		rts

.pagmz2:
		lea	(Pal_GMZ2+$20).l,a1
		jsr	(PalLoad_Line2).w
		lea	(Pal_GMZ2+$40).l,a1
		jsr	(PalLoad_Line3).w
		move.l	#Delete_Current_Sprite,(a0)
		rts

.pagmz:
		lea	(Pal_GMZ+$20).l,a1
		jsr	(PalLoad_Line2).w
		lea	(Pal_GMZ+$40).l,a1
		jsr	(PalLoad_Line3).w
		move.l	#Delete_Current_Sprite,(a0)

MSkull_Return2:
		rts


Obj_MSkull_Flash:
                move.b	#$4,(Hyper_Sonic_flash_timer).w
		samp	sfx_Teleport		; use sample slot, not sfx slot
		rts


obDatum_MSkull_CheckXY:	; ������ ��������� 4x4(������ ������� ?x?)
		dc.w -32
		dc.w 32
		dc.w -32
		dc.w 32

MSkull_Palettes_Normal:
		dc.l palid_FDZ
		dc.l palid_FDZ
		dc.l palid_FDZ3
		dc.l palid_FDZ3
		dc.l palid_SCZ
		dc.l palid_SCZ
		dc.l palid_SCZ
		dc.l palid_SCZ
		dc.l palid_GMZ
		dc.l palid_GMZ2
		dc.l palid_GMZ3
		dc.l palid_GMZ

		include "Objects/Magic Skull/Object data/Ani - Magic Skull.asm"
		include "Objects/Magic Skull/Object data/Map - Magic Skull.asm"
