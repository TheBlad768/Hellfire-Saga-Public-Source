
; =============== S U B R O U T I N E =======================================

Obj_HiddenMonitor:
		lea	ObjDat_HiddenMonitor(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#Obj_HiddenMonitorMain,address(a0)
		move.b	#30/2,y_radius(a0)
		move.b	#30/2,x_radius(a0)
		move.b	#$46,collision_flags(a0)
		move.b	subtype(a0),anim(a0)			; Backup object subtype
		rts
; ---------------------------------------------------------------------------

Obj_HiddenMonitorMain:
		move.w	(Signpost_addr).w,d0
		beq.s	loc_8375A
		movea.w	d0,a1						; Get Signpost address
		cmpi.l	#Obj_EndSign,address(a1)
		bne.s	loc_8375A					; If no signpost is active, branch
		btst	#0,$38(a1)
		beq.s	loc_8375A					; If signpost hasn't landed, branch
		lea	word_8379E(pc),a2
		move.w	x_pos(a0),d0
		move.w	x_pos(a1),d1
		add.w	(a2)+,d0
		cmp.w	d0,d1
		blo.s		loc_8374C
		add.w	(a2)+,d0
		cmp.w	d0,d1
		bhs.s	loc_8374C
		move.w	y_pos(a0),d0
		move.w	y_pos(a1),d1
		add.w	(a2)+,d0
		cmp.w	d0,d1
		blo.s		loc_8374C
		add.w	(a2)+,d0
		cmp.w	d0,d1
		blo.s		loc_83760

loc_8374C:
;		moveq	#sfx_GroundSlide,d0				; If signpost has landed
;		jsr	(Play_Sound_2).l

		sfx	sfx_Signpost

		move.l	#Sprite_OnScreen_Test,address(a0)

loc_8375A:
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

loc_83760:
		bclr	#0,$38(a1)							; If signpost has landed and is in range
		move.l	#Obj_Monitor,address(a0)			; make this object a monitor
		move.b	#2,routine(a0)
		move.b	#4,$3C(a0)
		move.w	#-$500,y_vel(a0)
		sfx	sfx_BubbleAttack
		bclr	#0,render_flags(a0)
		beq.s	loc_83798
		bset	#7,art_tile(a0)
		clr.b	status(a0)

loc_83798:
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

word_8379E:		dc.w  -$E, $1C, -$80, $C0

ObjDat_HiddenMonitor:
		dc.l Map_Monitor
		dc.w make_art_tile(ArtTile_Powerups,0,0)
		dc.w $280
		dc.b $E
		dc.b $10
		dc.b 0
		dc.b 0