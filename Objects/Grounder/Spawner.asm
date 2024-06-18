; ---------------------------------------------------------------------------
; Spawner of Grounder badniks
; ---------------------------------------------------------------------------

Obj_GrounderSpawner:
                jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_GrounderSpawner_Index(pc,d0.w),d1
		jsr	Obj_GrounderSpawner_Index(pc,d1.w)
		lea	Ani_Grounder(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ===========================================================================
Obj_GrounderSpawner_Index:
		dc.w Obj_GrounderSpawner_Main-Obj_GrounderSpawner_Index
		dc.w Obj_GrounderSpawner_Test-Obj_GrounderSpawner_Index
; ===========================================================================

Obj_GrounderSpawner_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Grounder,obMap(a0)
		move.w	#$4000,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#48/2,obHeight(a0)
		move.b	#128/2,obWidth(a0)
; ===========================================================================

Obj_GrounderSpawner_Test:
		jsr	(Find_Sonic).w
		cmpi.w 	#$90,d2
		bcc.w 	Obj_GrounderSpawner_Return

		sfx	sfx_BreakWall

		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Brick,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w 	#$150,obVelX(a1)
                move.w 	#-$400,obVelY(a1)
		addi.w	#$F,obX(a1)
+
		jsr	(SingleObjLoad2).w
		bne.s	+
                move.l	#Obj_Brick,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w 	#-$150,obVelX(a1)
                move.w 	#-$400,obVelY(a1)
		subi.w	#$F,obX(a1)
+
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Brick,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		addq.w  #8,obY(a1)
                move.w 	#$100,obVelX(a1)
                move.w 	#-$300,obVelY(a1)
		addq.w	#8,obY(a1)
+
		jsr	(SingleObjLoad2).w
		bne.s	+
                move.l	#Obj_Brick,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		addq.w  #8,obY(a1)
                move.w 	#-$100,obVelX(a1)
                move.w 	#-$300,obVelY(a1)
		subq.w	#8,obY(a1)
+
		move.l	#Obj_Grounder,(a0)
                clr.b   routine(a0)
                move.w	#-$300,obVelY(a0)

Obj_GrounderSpawner_Return:
		rts
; ===========================================================================

				include "Objects/Grounder/Object data/Ani - Grounder.asm"
Map_Grounder:	include "Objects/Grounder/Object data/Map - Grounder.asm"
