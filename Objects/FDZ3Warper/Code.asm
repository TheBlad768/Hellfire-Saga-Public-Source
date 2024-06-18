
; =============== S U B R O U T I N E =======================================

Obj_FDZ3Warper:
		move.l	#Map_PathSwap,mappings(a0)
		move.w	#make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#128/2,width_pixels(a0)
		move.b	#128/2,height_pixels(a0)
		move.w	#$280,priority(a0)
		move.l	#FDZ3Warper_SonicCol,address(a0)

FDZ3Warper_SonicCol:
		lea	(Player_1).w,a1
		lea	FDZ3Warper_CheckXY(pc),a2
		jsr	(Check_InMyRange).w
		beq.w	FDZ3Warper_Return
		move.l	#Delete_Current_Sprite,address(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		cmp.b	(Warper_Flag).w,d0
		bne.s	FDZ3Warper_Return
		eori.b	#1,(Warper_Flag).w
		add.w	d0,d0
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	FDZ3Warper_Data(pc,d0.w),a1
		tst.b (Extended_mode).w
		beq.s .skip
		lea	FDZ3Warper_Data2(pc,d0.w),a1

.skip:
		movea.l	(a1)+,a2
		move.l	a2,(Level_layout_addr_ROM).w
		addq.l	#8,a2
		move.l	a2,(Level_layout2_addr_ROM).w
		movea.l	(a1)+,a2
		move.l	a2,(Object_load_addr_front).w
		move.l	a2,(Object_load_addr_back).w
		addq.b	#2,(Object_load_routine).w
		movea.l	(a1)+,a2
		move.l	a2,(Ring_start_addr_ROM).w
		addq.b	#2,(Rings_manager_routine).w
		samp	sfx_ThunderLightning
		move.b	#4,(Hyper_Sonic_flash_timer).w

FDZ3Warper_Return:
		rts
; ---------------------------------------------------------------------------

FDZ3Warper_Data:
		dc.l Layout_FDZ3_Alt		; 0
		dc.l FDZ3_Sprites_Alt
		dc.l FDZ3_Rings_Alt
		dc.l Layout_FDZ3			; C
		dc.l FDZ3_Sprites
		dc.l FDZ3_Rings

; ---------------------------------------------------------------------------

FDZ3Warper_Data2:
		dc.l Layout_FDZ3_Altex		; 0
		dc.l FDZ3_Sprites_Alt2
		dc.l FDZ3_Rings_Alt2
		dc.l Layout_FDZ3ex			; C
		dc.l FDZ3_Sprites2
		dc.l FDZ3_Rings2
; ---------------------------------------------------------------------------

FDZ3Warper_CheckXY:
		dc.w -48
		dc.w 96
		dc.w -48
		dc.w 96
