
; =============== S U B R O U T I N E =======================================

LoadObjects_Data:
SetUp_ObjAttributes:
		move.l	(a1)+,mappings(a0)			; Mapping offset

SetUp_ObjAttributes2:
		move.w	(a1)+,art_tile(a0)			; VRAM offset

SetUp_ObjAttributes3:
LoadObjects_ExtraData:
		move.w	(a1)+,priority(a0)			; Priority
		move.b	(a1)+,width_pixels(a0)			; Width
		move.b	(a1)+,height_pixels(a0)			; Height
		move.b	(a1)+,mapping_frame(a0)			; Frame number
		move.b	(a1)+,collision_flags(a0)		; Collision number
		bset	#2,render_flags(a0)			; Use screen coordinates
		addq.b	#2,routine(a0)				; Next routine
		rts
; End of function SetUp_ObjAttributes

; =============== S U B R O U T I N E =======================================

SetUp_ObjAttributesSlotted:
		moveq	#0,d0
		move.w	(a1)+,d1		; Maximum number of objects that can be made in this array
		move.w	d1,d2
		move.w	(a1)+,d3		; Base VRAM offset of object
		move.w	(a1)+,d4		; Amount to add to base VRAM offset for each slot
		moveq	#0,d5
		move.w	(a1)+,d5		; Index of slot array to use
		lea	(DPLC_SlottedRAM).w,a2
		adda.w	d5,a2			; Get the address of the array to use
		move.b	(a2),d5
		beq.s	+					; If array is clear, just make the object

-		lsr.b	#1,d5					; Check slot (each bit)
		bcc.s	+					; If clear, make object
		addq.w	#1,d0					; Increment bit number
		add.w	d4,d3					; Add VRAM offset
		dbf	d1,-					; Repeat max times

		moveq	#0,d0
		move.l	d0,(a0)					; If no open slots, then destroy this object
		move.l	d0,x_pos(a0)
		move.l	d0,y_pos(a0)
		move.b	d0,subtype(a0)
		move.b	d0,render_flags(a0)
		move.w	d0,status(a0)
		addq.w	#8,sp
		rts
; ---------------------------------------------------------------------------

+
		bset	d0,(a2)					; Turn this slot on
		move.b	d0,$3B(a0)
		move.w	a2,$3C(a0)				; Keep track of slot address and bit number
		move.w	d3,art_tile(a0)				; Use correct VRAM offset

		move.l	(a1)+,mappings(a0)			; Mapping address
		move.w	(a1)+,priority(a0)			; Priority
		move.b	(a1)+,width_pixels(a0)			; Width
		move.b	(a1)+,height_pixels(a0)			; Height
		move.b	(a1)+,mapping_frame(a0)			; Frame number
		move.b	(a1)+,collision_flags(a0)		; Collision number

		bset	#2,$2A(a0)				; Turn object slotting on
		st	$3A(a0)					; set current frame as invalid
		bset	#2,render_flags(a0)			; Use screen coordinates
		addq.b	#2,routine(a0)				; Next routine
		rts
; End of function SetUp_ObjAttributesSlotted

; =============== S U B R O U T I N E =======================================

Perform_DPLC:
		moveq	#0,d0
		move.b	mapping_frame(a0),d0	; Get the frame number
		cmp.b	objoff_3A(a0),d0			; If frame number remains the same as before, don't do anything
		beq.s	+
		move.b	d0,objoff_3A(a0)
		movea.l	(a2)+,a3					; Source address of art
		move.w	art_tile(a0),d4
		andi.w	#$7FF,d4				; Isolate tile location offset
		lsl.w	#5,d4						; Convert to VRAM address
		movea.l	(a2)+,a2					; Address of DPLC script
		add.w	d0,d0
		adda.w	(a2,d0.w),a2				; Apply offset to script
		move.w	(a2)+,d5					; Get number of DMA transactions
		bmi.s	+
		moveq	#0,d3

-		move.w	(a2)+,d3					; Art source offset
		move.l	d3,d1
		andi.w	#$FFF0,d1				; Isolate all but lower 4 bits
		add.l	a3,d1					; Get final source address of art
		move.w	d4,d2					; Destination VRAM address
		andi.w	#$F,d3
		addq.w	#1,d3
		lsl.w	#4,d3						; d3 is the total number of words to transfer (maximum 16 tiles per transaction)
		add.w	d3,d4
		add.w	d3,d4
		jsr	(Add_To_DMA_Queue).w		; Add to queue
		dbf	d5,-							; Keep going
+		rts
; End of function Perform_DPLC

; =============== S U B R O U T I N E =======================================

Set_IndexedVelocity:
		moveq	#0,d1
		move.b	subtype(a0),d1
		add.w	d1,d1
		add.w	d1,d0
		lea	Obj_VelocityIndex(pc,d0.w),a1
		move.w	(a1)+,x_vel(a0)
		move.w	(a1)+,y_vel(a0)
		btst	#0,render_flags(a0)
		beq.s	+
		neg.w	x_vel(a0)
+		rts
; End of function Set_IndexedVelocity
; ---------------------------------------------------------------------------

Obj_VelocityIndex:
		dc.w  -$100, -$100	; 0
		dc.w   $100, -$100		; 4
		dc.w  -$200, -$200	; 8
		dc.w   $200, -$200	; �
		dc.w  -$300, -$200	; 10
		dc.w   $300, -$200	; 14
		dc.w  -$200, -$200	; 18
		dc.w	  0, -$200		; 1�
		dc.w  -$400, -$300	; 20
		dc.w   $400, -$300	; 24
		dc.w   $300, -$300	; 28
		dc.w  -$400, -$300	; 2�
		dc.w   $400, -$300	; 30
		dc.w  -$200, -$200	; 34
		dc.w   $200, -$200	; 38
		dc.w	  0, -$100		; 3�
		dc.w  -$40, -$700		; 40
		dc.w  -$80, -$700		; 44
		dc.w  -$180, -$700	; 48
		dc.w  -$100, -$700	; 4�
		dc.w  -$200, -$700	; 50
		dc.w  -$280, -$700	; 54
		dc.w  -$300, -$700	; 58
		dc.w	  0, -$100		; 5�
		dc.w  -$100, -$100	; 60
		dc.w   $100, -$100		; 64
		dc.w  -$200, -$100	; 68
		dc.w   $200, -$100	; 6�
		dc.w  -$200, -$200	; 70
		dc.w   $200, -$200	; 74
		dc.w  -$300, -$200	; 78
		dc.w   $300, -$200	; 7�
		dc.w  -$300, -$300	; 80
		dc.w   $300, -$300	; 84
		dc.w  -$400, -$300	; 88
		dc.w   $400, -$300	; 8�
		dc.w  -$200, -$300	; 90
		dc.w   $200, -$300	; 94

; =============== S U B R O U T I N E =======================================

Displace_PlayerOffObject:
		move.b	status(a0),d0
		andi.b	#$18,d0
		beq.s	Displace_PlayerOffObject_Return
		bclr	#Status_OnObj,status(a0)
		beq.s	+
		lea	(Player_1).w,a1
		bclr	#Status_OnObj,status(a1)
		bset	#Status_InAir,status(a1)
+		bclr	#Status_RollJump,status(a0)

Displace_PlayerOffObject_Return:
		rts
; End of function Displace_PlayerOffObject

; =============== S U B R O U T I N E =======================================

Obj_Song_Fade_Transition:
		fadeout					; fade out music

Obj_Song_Fade_Transition_2:
		move.l	#+,address(a0)
+
		tst.w	dxFadeOff.w
		bne.s	Displace_PlayerOffObject_Return
		command	cmd_FadeReset
		move.w	subtype(a0),d0
		move.w	d0,(Level_music).w
		st.b	(ForceMuteYM2612).w
		jsr	dFractalQueue
		bra.w	Delete_Current_Sprite

Obj_Song_Fade_Transition_LevelStart:
		command	cmd_Reset
		move.w	subtype(a0),d0
		move.w	d0,(Level_music).w
		st.b	(ForceMuteYM2612).w
		jsr	dFractalQueue
		bra.w	Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

Obj_Song_Fade_ToLevelMusic:
		fadeout					; fade out music
		move.l	#+,address(a0)
+
		tst.w	dxFadeOff.w
		bne.w	Displace_PlayerOffObject_Return
		command	cmd_FadeReset
		bsr.s	Obj_PlayLevelMusic
		bra.w	Delete_Current_Sprite
; End of function Obj_Song_Fade_ToLevelMusic

; =============== S U B R O U T I N E =======================================

Obj_PlayLevelMusic:
		move.w	Transition_Zone.w,d0		; NAT: Updated because FDZ3 transition requires this
		ror.b	#2,d0
		lsr.w	#5,d0
		lea	(LevelMusic_Playlist).l,a2
		move.w	(a2,d0.w),d0
		move.w	d0,(Level_music).w

		btst	#Status_Invincible,(Player_1+status_secondary).w
		beq.s	+
		move.w	#mus_Invincible,d0		; If invincible, play invincibility music
+
		st.b	(ForceMuteYM2612).w
		jmp	dFractalQueue
; End of function Obj_PlayLevelMusic

; =============== S U B R O U T I N E =======================================

Init_BossArena:
		st	(Boss_flag).w

Init_BossArena2:
		fadeout					; fade out music
		move.w	#2*60,$2E(a0)

Init_BossArena3:
		move.w	(Camera_min_Y_pos).w,(Saved_Camera_min_Y_pos).w
		move.w	(Camera_target_max_Y_pos).w,(Saved_Camera_max_Y_pos).w
		move.w	(Camera_min_X_pos).w,(Saved_Camera_min_X_pos).w
		move.w	(Camera_max_X_pos).w,(Saved_Camera_max_X_pos).w
		move.w	(a1)+,(Camera_min_Y_pos).w
		move.w	(a1)+,(Camera_max_Y_pos).w
		move.w	(a1)+,(Camera_min_X_pos).w
		move.w	(a1)+,(Camera_max_X_pos).w
		rts
; End of function Init_BossArena

; =============== S U B R O U T I N E =======================================

StackLoad_Routine:
		movea.l	(sp)+,a1

Load_Routine:
		andi.w	#$FE,d0
		adda.w	(a1,d0.w),a1
		jmp	(a1)
; End of function ObjectsRoutine

; =============== S U B R O U T I N E =======================================

HurtCharacter_Directly2:
		tst.b	invulnerability_timer(a1)
		bne.s	HurtCharacter_Directly_Locret
		btst	#Status_Invincible,status_secondary(a1)
		bne.s	HurtCharacter_Directly_Locret

HurtCharacter_Directly:
		movea.l	a0,a2
		movea.l	a1,a0
		bsr.w	HurtCharacter
		movea.l	a2,a0

HurtCharacter_Directly_Locret:
		rts
; End of function HurtCharacter_Directly

; =============== S U B R O U T I N E =======================================

HurtCharacter_WithoutDamage:
		lea	(Player_1).w,a1
		move.b	#4,routine(a1)		; Hit animation
		bclr	#3,status(a1)
		bclr	#5,status(a1)				; Player is not standing on/pushing an object
		bset	#1,status(a1)
		move.w	#-$200,x_vel(a1)		; Set speed of player
		move.w	#-$300,y_vel(a1)
		move.w	#0,ground_vel(a1)		; Zero out inertia
		move.b	#id_Hurt,anim(a1)	; Set falling animation
		sfx	sfx_Death,0
		rts
; End of function HurtCharacter_WithoutDamage

; =============== S U B R O U T I N E =======================================

Check_PlayerAttack:
		lea	(Player_1).w,a1
		btst	#1,shield_reaction(a1)
		bne.s	loc_85822
		cmpi.b	#id_SpinDash,anim(a1)
		beq.s	loc_85822
		cmpi.b	#id_Roll,anim(a1)
		beq.s	loc_85822
		moveq	#0,d0
		move.b	character_id(a1),d0
		add.w	d0,d0
		move.w	off_857EA(pc,d0.w),d0
		jmp	off_857EA(pc,d0.w)
; ---------------------------------------------------------------------------

off_857EA: offsetTable
		offsetTableEntry.w Check_SonicAttack	; 0 - Sonic
		offsetTableEntry.w Check_SonicAttack	; 1 - Tails
		offsetTableEntry.w Check_SonicAttack	; 2 - Knuckles
; ---------------------------------------------------------------------------

Check_SonicAttack:
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_85822:
		moveq	#1,d0
		rts

; =============== S U B R O U T I N E =======================================

Set_LostRings:
		moveq	#0,d0
		move.w	(Difficulty_Flag).w,d0
		move.b	(a1,d0.w),d0
		cmp.b	(v_rings).w,d0
		blo.s		+
		move.b	d0,(v_rings).w
		move.b	#$80,(Update_HUD_ring_count).w
+		rts

; =============== S U B R O U T I N E =======================================

Check_PlayerCollision:
		move.b	collision_property(a0),d0
		beq.s	+
		clr.b	collision_property(a0)
		andi.w	#3,d0
		add.w	d0,d0
		lea	word_85890(pc),a1
		movea.w	(a1,d0.w),a1
		move.w	a1,$44(a0)
		moveq	#1,d1
+		rts
; End of function Check_PlayerCollision
; ---------------------------------------------------------------------------

word_85890:
		dc.w Player_1
		dc.w Player_1
		dc.w Player_1
		dc.w Player_1

; =============== S U B R O U T I N E =======================================

Load_LevelResults:
		lea	(Player_1).w,a1
		btst	#7,status(a1)
		bne.s	+
		btst	#1,status(a1)
		bne.s	+
		cmpi.b	#6,routine(a1)
		bcc.s	+
		jsr	(Set_PlayerEndingPose).w
		clr.b	(TitleCard_end_flag).w
		bsr.w	Create_New_Sprite
		bne.s	+
		move.l	#Obj_LevelResults,(a1)
+		rts
; End of function Load_LevelResults

; =============== S U B R O U T I N E =======================================

Set_PlayerEndingPose:
		move.b	#-$7F,object_control(a1)
		move.b	#id_Landing,anim(a1)
		clr.b	spin_dash_flag(a1)
		clr.l	x_vel(a1)
		clr.w	ground_vel(a1)
		bclr	#5,status(a0)
		bclr	#6,status(a0)
		bclr	#5,status(a1)
		rts
; End of function Set_PlayerEndingPose

; =============== S U B R O U T I N E =======================================

Stop_Object:
		clr.l	x_vel(a1)
		clr.w	ground_vel(a1)
		rts
; End of function Stop_Object

; =============== S U B R O U T I N E =======================================

Restore_PlayerControl:
		lea	(Player_1).w,a1

Restore_PlayerControl2:
		clr.b	object_control(a1)
		bclr	#1,status(a1)
		move.w	#id_Wait<<8|id_Wait,anim(a1)
		clr.b	anim_frame(a1)
		clr.b	anim_frame_timer(a1)
		rts
; End of function Restore_PlayerControl

; =============== S U B R O U T I N E =======================================

StartNewLevel:
		move.w	d0,(Current_zone_and_act).w
		move.w	#1,(Restart_level_flag).w
		clr.b	(Last_star_post_hit).w

.return
		rts
; End of function StartNewLevel

; =============== S U B R O U T I N E =======================================

Play_SFX_Continuous:
		move.b	(V_int_run_count+3).w,d1
		and.b	d2,d1
		bne.s	StartNewLevel.return
		jmp	dFractalQueue	; play sfx

; =============== S U B R O U T I N E =======================================

Wait_NewDelay:
		subq.w	#1,$2E(a0)
		bmi.s	+
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

+		bclr	#7,render_flags(a0)
		move.w	#$77,$2E(a0)
		movea.l	$34(a0),a1
		jmp	(a1)

; =============== S U B R O U T I N E =======================================

Wait_FadeToLevelMusic:
		subq.w	#1,$2E(a0)
		bmi.s	+
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

+		bclr	#7,render_flags(a0)
		move.w	#$77,$2E(a0)
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_Song_Fade_ToLevelMusic,(a1)
+		movea.l	$34(a0),a1
		jmp	(a1)

; =============== S U B R O U T I N E =======================================

BossDefeated_StopTimer:
BossDefeated:
		move.w	#$3F,$2E(a0)

BossDefeated_NoTime:
		bclr	#7,render_flags(a0)
		rts
; End of function BossDefeated

; =============== S U B R O U T I N E =======================================

CopyWordData_8:
		movea.w	(a1)+,a3
		move.w	(a2)+,(a3)+

CopyWordData_7:
		movea.w	(a1)+,a3
		move.w	(a2)+,(a3)+

CopyWordData_6:
		movea.w	(a1)+,a3
		move.w	(a2)+,(a3)+

CopyWordData_5:
		movea.w	(a1)+,a3
		move.w	(a2)+,(a3)+

CopyWordData_4:
		movea.w	(a1)+,a3
		move.w	(a2)+,(a3)+

CopyWordData_3:
		movea.w	(a1)+,a3
		move.w	(a2)+,(a3)+

CopyWordData_2:
		movea.w	(a1)+,a3
		move.w	(a2)+,(a3)+

CopyWordData_1:
		movea.w	(a1)+,a3
		move.w	(a2)+,(a3)+
		rts
; End of function CopyWordData

; =============== S U B R O U T I N E =======================================

Check_CameraXBoundary:
		tst.w	x_vel(a0)
		beq.s	+
		bmi.s	++
		move.w	(Camera_X_pos).w,d0
		addi.w	#$130,d0
		cmp.w	x_pos(a0),d0
		bhi.s	+
		clr.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------
+		move.w	(Camera_X_pos).w,d0
		addi.w	#$10,d0
		cmp.w	x_pos(a0),d0
		blo.s		+
		clr.w	x_vel(a0)
+		rts
; End of function Check_CameraXBoundary

; =============== S U B R O U T I N E =======================================

Obj_IncLevEndXGradual:
		move.w	(Camera_max_X_pos).w,d0
		move.l	$30(a0),d1
		addi.l	#$4000,d1
		move.l	d1,$30(a0)
		swap	d1
		add.w	d1,d0
		cmp.w	(Saved_Camera_max_X_pos).w,d0
		bhs.s	+
		move.w	d0,(Camera_max_X_pos).w
		rts
; ---------------------------------------------------------------------------
+		move.w	(Saved_Camera_max_X_pos).w,(Camera_max_X_pos).w
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_DecLevStartXGradual:
		move.w	(Camera_min_X_pos).w,d0
		move.l	$30(a0),d1
		addi.l	#$4000,d1
		move.l	d1,$30(a0)
		swap	d1
		sub.w	d1,d0
		cmp.w	(Saved_Camera_min_X_pos).w,d0
		ble.s		+
		move.w	d0,(Camera_min_X_pos).w
		rts
; ---------------------------------------------------------------------------
+		move.w	(Saved_Camera_min_X_pos).w,(Camera_min_X_pos).w
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_DecLevStartYGradual:
		move.w	(Camera_min_Y_pos).w,d0
		move.l	$30(a0),d1
		addi.l	#$4000,d1
		move.l	d1,$30(a0)
		swap	d1
		sub.w	d1,d0
		cmp.w	(Saved_Camera_min_Y_pos).w,d0
		ble.s		+
		move.w	d0,(Camera_min_Y_pos).w
		rts
; ---------------------------------------------------------------------------
+		move.w	(Saved_Camera_min_Y_pos).w,(Camera_min_Y_pos).w
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_IncLevEndYGradual:
		move.w	(Camera_max_Y_pos).w,d0
		move.l	$30(a0),d1
		addi.l	#$8000,d1
		move.l	d1,$30(a0)
		swap	d1
		add.w	d1,d0
		cmp.w	(Saved_Camera_max_Y_pos).w,d0
		bgt.s	+
		move.w	d0,(Camera_max_Y_pos).w
		rts
; ---------------------------------------------------------------------------
+		move.w	(Saved_Camera_max_Y_pos).w,(Camera_max_Y_pos).w
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

Child6_IncLevX:
		dc.w 0
		dc.l Obj_IncLevEndXGradual
Child6_DecLevX:
		dc.w 0
		dc.l Obj_DecLevStartXGradual
Child6_IncLevY:
		dc.w 0
		dc.l Obj_IncLevEndYGradual
Child6_DecLevY:
		dc.w 0
		dc.l Obj_DecLevStartYGradual
