
; =============== S U B R O U T I N E =======================================

Obj_Staircase:
		ori.b	#4,render_flags(a0)
		move.b	subtype(a0),d0
		andi.w	#7,d0
		cmpi.w	#4,d0
		blo.s		loc_47658
		bchg	#0,render_flags(a0)

loc_47658:
		btst	#1,render_flags(a0)
		beq.s	loc_47666
		bchg	#0,render_flags(a0)

loc_47666:
		moveq	#$34,d3
		moveq	#2,d4
		btst	#0,status(a0)
		beq.s	loc_47676
		moveq	#$3A,d3
		moveq	#-2,d4

loc_47676:
		move.w	x_pos(a0),d2
		movea.l	a0,a1
		moveq	#4-1,d1
		bra.s	loc_47690
; ---------------------------------------------------------------------------

loc_47680:
		jsr	(Create_New_Sprite3).w
		bne.s	loc_476E4
		move.l	#loc_476FE,address(a1)

loc_47690:
		move.l	#Map_Stair,mappings(a1)
		move.w	#$4400,art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.w	#$180,priority(a1)
		move.w	#bytes_to_word(32/2,32/2),height_pixels(a1)		; set height and width
		move.b	subtype(a0),subtype(a1)
		move.w	d2,x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	x_pos(a0),$44(a1)
		move.w	y_pos(a1),$46(a1)
		addi.w	#32,d2
		move.b	d3,$33(a1)
		move.w	a0,$3E(a1)	; parent
		add.b	d4,d3
		dbf	d1,loc_47680

loc_476E4:
		move.l	#loc_476EA,address(a0)

loc_476EA:
		move.b	subtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_4773A(pc,d0.w),d0
		jsr	off_4773A(pc,d0.w)

loc_476FE:
		movea.w	$3E(a0),a2	; a2=object
		moveq	#0,d0
		move.b	$33(a0),d0
		move.w	(a2,d0.w),d0
		add.w	$46(a0),d0
		move.w	d0,y_pos(a0)

		moveq	#$1B,d1
		moveq	#$10,d2
		moveq	#$11,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w
		swap	d6
		or.b	d6,$32(a2)
		move.w	$44(a0),d0
		jmp	(Sprite_OnScreen_Test2).w
; ---------------------------------------------------------------------------

off_4773A: offsetTable
		offsetTableEntry.w loc_4774A	; 0
		offsetTableEntry.w loc_477C2	; 1
		offsetTableEntry.w loc_47774	; 2
		offsetTableEntry.w loc_477C2	; 3
		offsetTableEntry.w loc_4774A	; 4
		offsetTableEntry.w loc_477EC	; 5
		offsetTableEntry.w loc_47774	; 6
		offsetTableEntry.w loc_477EC	; 7
; ---------------------------------------------------------------------------

loc_4774A:
		tst.w	$30(a0)
		bne.s	loc_47762
		move.b	$32(a0),d0
		andi.b	#touch_top_mask,d0
		beq.s	locret_47760
		move.w	#(1*60)/2,$30(a0)

locret_47760:
		rts
; ---------------------------------------------------------------------------

loc_47762:
		subq.w	#1,$30(a0)
		bne.s	locret_47760
		addq.b	#1,subtype(a0)
		rts

;		moveq	#signextendB(sfx_FanBig),d0
;		jmp	(Play_SFX).w
; ---------------------------------------------------------------------------

loc_47774:
		tst.w	$30(a0)
		bne.s	loc_4778C
		move.b	$32(a0),d0
		andi.b	#touch_bottom_mask,d0
		beq.s	locret_4778A
		move.w	#1*60,$30(a0)

locret_4778A:
		rts
; ---------------------------------------------------------------------------

loc_4778C:
		subq.w	#1,$30(a0)
		bne.s	loc_4779E
		addq.b	#1,subtype(a0)
		rts

;		moveq	#signextendB(sfx_FanBig),d0
;		jmp	(Play_SFX).w
; ---------------------------------------------------------------------------

loc_4779E:
		lea	$34(a0),a1	; a1=object
		move.w	$30(a0),d0
		lsr.b	#2,d0
		andi.b	#1,d0
		move.w	d0,(a1)+
		eori.b	#1,d0
		move.w	d0,(a1)+
		eori.b	#1,d0
		move.w	d0,(a1)+
		eori.b	#1,d0
		move.w	d0,(a1)+
		rts
; ---------------------------------------------------------------------------

loc_477C2:
		lea	$34(a0),a1	; a1=object
		cmpi.w	#$80,(a1)
		beq.s	locret_477EA
		addq.w	#1,(a1)
		moveq	#0,d1
		move.w	(a1)+,d1
		swap	d1
		lsr.l	#1,d1
		move.l	d1,d2
		lsr.l	#1,d1
		move.l	d1,d3
		add.l	d2,d3
		swap	d1
		swap	d2
		swap	d3
		move.w	d3,(a1)+
		move.w	d2,(a1)+
		move.w	d1,(a1)+

locret_477EA:
		rts
; ---------------------------------------------------------------------------

loc_477EC:
		lea	$34(a0),a1	; a1=object
		cmpi.w	#-$80,(a1)
		beq.s	locret_47814
		subq.w	#1,(a1)
		moveq	#0,d1
		move.w	(a1)+,d1
		swap	d1
		asr.l	#1,d1
		move.l	d1,d2
		asr.l	#1,d1
		move.l	d1,d3
		add.l	d2,d3
		swap	d1
		swap	d2
		swap	d3
		move.w	d3,(a1)+
		move.w	d2,(a1)+
		move.w	d1,(a1)+

locret_47814:
		rts
; ---------------------------------------------------------------------------

		include "Objects/Staircase/Object data/Map - Staircase.asm"
