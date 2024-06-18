
; =============== S U B R O U T I N E =======================================

Obj_HUD:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj21_Index(pc,d0.w),d0
		jmp	Obj21_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Obj21_Index: offsetTable
		offsetTableEntry.w Obj21_Init
		offsetTableEntry.w Obj21_Left
		offsetTableEntry.w Obj21_Check
		offsetTableEntry.w Obj21_Up
		offsetTableEntry.w Obj21_Delete
; ---------------------------------------------------------------------------

Obj21_Init:
		addq.b  #2,obRoutine(a0)
		move.l	#Map_HUD,obMap(a0)
		move.w	#$6C2,obGfx(a0)
		move.w	#$80,obX(a0)		; NOV: Move the HUD offscreen
		move.w	#$108,obY(a0)		; NOV: The HUD is no longer moving vertically
		move.w	#$800,obVelX(a0)	; NOV: Set the initial X velocity

Obj21_Left:
		subi.w	#$40,obVelX(a0)		; NOV: Slow down the HUD
		bpl.s	Obj21_Check			; NOV: If the HUD hasn't slowed to a stop, branch
		clr.w	obVelX(a0)			; NOV: Fully stop
		addq.b	#2,obRoutine(a0)

Obj21_Check:
		tst.b	(Level_end_flag).w
		beq.s	Obj21_Flash

Obj21_Next:
		addq.b	#2,obRoutine(a0)

Obj21_Up:
		subi.w	#$40,obVelX(a0)		; NOV: Speed up the HUD in the left direction
		cmpi.w	#$80,obX(a0)		; NOV: Has the HUD moved offscreen?
		bge.s	Obj21_Flash			; NOV: If not, branch
		addq.b	#2,obRoutine(a0)

Obj21_Flash:
		jsr	(MoveSprite2).w			; NOV: Apply velocity
		jmp	(DisplaySprite).w
; ---------------------------------------------------------------------------

Obj21_Delete:
                jmp	(DeleteObject).w
; ---------------------------------------------------------------------------

Map_HUD:
		include	"Objects/HUD/Object data/Map - HUD.asm"
		even