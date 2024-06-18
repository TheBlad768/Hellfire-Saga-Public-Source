; ---------------------------------------------------------------------------
; Dialog (After Results)
; By TheBlad768 (2023)
; ---------------------------------------------------------------------------

; Constants
Dialog_Offset:				= *

; RAM
	phase ramaddr(Camera_RAM)

; results data
							ds.b $20		; used by results screen

; misc
vDialog_Parent:				ds.w 1
vDialog_Timer:				ds.w 1
vDialog_Process:				ds.l 1
vDialog_End:					ds.b 1
vDialog_Routine:				ds.b 1

	dephase
	!org	Dialog_Offset

; =============== S U B R O U T I N E =======================================

Dialog_Screen:
		command	cmd_Reset
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.w	#-1,(Previous_zone).w			; MJ: reset previous zone/act
		move.l	#VInt,(V_int_addr).w			; MJ: restore V-blank address
		move.l	#HInt,(H_int_addr).w			; MJ: restore H-blank address
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)					; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)	; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)	; Command $8407 - Nametable B at $E000
		move.w	#$8700+(0<<4),(a6)			; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B00,(a6)					; Command $8B00 - Vscroll full, HScroll full
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
;		clearRAM Camera_RAM, Camera_RAM_End			; used by results screen
		clearRAM v_oscillate, v_oscillate_end
		ResetDMAQueue

		; load Sonic's palette
		moveq	#palid_Sonic,d0
		jsr	(LoadPalette).w

		; jmp
		move.l	#DialogScreen_Process,(vDialog_Process).w

		; play music
		samp	sfx_RainPCM

		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.loop
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w

		; jmp
		movea.l	(vDialog_Process).w,a1
		jsr	(a1)

		; check end
		tst.b	(vDialog_End).w
		beq.s	.loop
		clr.b	(vDialog_End).w

		; exit
		move.b	#id_Title,(Game_mode).w
		rts

; ---------------------------------------------------------------------------
; Dialog process
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DialogScreen_Process:

		; get dialog data
		moveq	#0,d1
		move.b	(vDialog_Routine).w,d1
		addq.b	#4,(vDialog_Routine).w
		jsr	.index(pc,d1.w)

		; skip dialog
		tst.w	d0
		bmi.s	.return

		; load dialog
		lea	(a2,d0.w),a2

		; start dialog
		move.l	#.wait,(vDialog_Process).w
		jsr	(Create_New_Sprite).w
		bne.s	.return
		move.w	a1,(vDialog_Parent).w
		move.l	#Obj_Dialog_Process,address(a1)
		move.b	#_Null,routine(a1)
		move.l	(a2),$34(a1)
		move.b	(a2),$39(a1)

.return
		rts
; ---------------------------------------------------------------------------

.index
		bra.w	.bdialog		; 0
		bra.w	.tdialog		; 4
		bra.w	.ddialog		; 8
		bra.w	.kdialog		; C
		bra.w	.didialog		; 10
		bra.w	.rdialog		; 14
		bra.w	.enddialog	; 18
; ---------------------------------------------------------------------------

.wait
		move.w	(vDialog_Parent).w,a1
		tst.l	address(a1)
		bne.s	.return2
		move.l	#DialogScreen_Process,(vDialog_Process).w

.return2
		rts
; ---------------------------------------------------------------------------

.bdialog
		moveq	#0,d0
		lea	.beginning_index(pc),a2
		rts
; ---------------------------------------------------------------------------

.tdialog

		; load time dialog
		moveq	#0,d0
		tst.b	(vResults_Timer).w
		beq.s	.gettime
		moveq	#4,d0
		cmpi.w	#3,(Difficulty_Flag).w								; set max pt. for maniac
		bne.s	.gettime
		moveq	#8,d0

.gettime
		lea	.time_index(pc),a2
		rts
; ---------------------------------------------------------------------------

.ddialog

		; skip maniac
		moveq	#-1,d0
		cmpi.w	#3,(Difficulty_Flag).w
		beq.s	.getdeaths

		; load death dialog
		moveq	#0,d0
		tst.b	(vResults_Death).w
		beq.s	.getdeaths
		moveq	#4,d0
		cmpi.b	#26,(vResults_Death).w
		bne.s	.getdeaths
		moveq	#8,d0

.getdeaths
		lea	.deaths_index(pc),a2
		rts
; ---------------------------------------------------------------------------

.kdialog

		; load keys dialog
		moveq	#0,d0
		tst.b	(TSecrets_count).w
		beq.s	.getkeys
		moveq	#4,d0
		cmpi.b	#12,(TSecrets_count).w
		bne.s	.getkeys
		moveq	#8,d0

.getkeys
		lea	.keys_index(pc),a2
		rts
; ---------------------------------------------------------------------------

.didialog

		; load difficulty dialog
		moveq	#0,d0
		move.w	(Difficulty_Flag).w,d1
		subq.w	#1,d1											; normal?
		beq.s	.getdifficulty										; if yes, branch
		bmi.s	.difail											; easy???
		moveq	#4,d0
		subq.w	#1,d1											; hard?
		beq.s	.getdifficulty										; if yes, branch
		moveq	#8,d0											; maniac

.getdifficulty
		lea	.difficulty_index(pc),a2
		rts
; ---------------------------------------------------------------------------

.difail

		; exit
		addq.w	#8,sp											; exit from dialog process and screen
		move.b	#id_Title,(Game_mode).w
		rts
; ---------------------------------------------------------------------------

.rdialog

		; load rank dialog
		moveq	#0,d0
		tst.b	(vResults_Rank).w										; S rank?
		bne.s	.getrank											; if not, branch
		moveq	#4,d0

.getrank
		lea	.rank_index(pc),a2
		rts
; ---------------------------------------------------------------------------

.enddialog

		; set
		addq.w	#4,sp											; exit from dialog process
		move.w	#7,(vDialog_Timer).w
		move.l	#.endwait,(vDialog_Process).w

.endwait
		subq.w	#1,(vDialog_Timer).w
		bpl.s	.endreturn
		move.l	#.endreturn,(vDialog_Process).w
		st	(vDialog_End).w

.endreturn
		rts
; ---------------------------------------------------------------------------

.beginning_index
		dc.l ((DialogEnding_Beginning_Process_Index_End-DialogEnding_Beginning_Process_Index)/8)<<24|(DialogEnding_Beginning_Process_Index-4)	; startup
.time_index
		dc.l ((DialogEnding_TimeA_Process_Index_End-DialogEnding_TimeA_Process_Index)/8)<<24|(DialogEnding_TimeA_Process_Index-4)			; 0 points
		dc.l ((DialogEnding_TimeB_Process_Index_End-DialogEnding_TimeB_Process_Index)/8)<<24|(DialogEnding_TimeB_Process_Index-4)			; else
		dc.l ((DialogEnding_TimeC_Process_Index_End-DialogEnding_TimeC_Process_Index)/8)<<24|(DialogEnding_TimeC_Process_Index-4)			; maniac
.deaths_index
		dc.l ((DialogEnding_DeathsA_Process_Index_End-DialogEnding_DeathsA_Process_Index)/8)<<24|(DialogEnding_DeathsA_Process_Index-4)		; 0 points
		dc.l ((DialogEnding_DeathsB_Process_Index_End-DialogEnding_DeathsB_Process_Index)/8)<<24|(DialogEnding_DeathsB_Process_Index-4)		; else
		dc.l ((DialogEnding_DeathsC_Process_Index_End-DialogEnding_DeathsC_Process_Index)/8)<<24|(DialogEnding_DeathsC_Process_Index-4)		; max points
.keys_index
		dc.l ((DialogEnding_KeysA_Process_Index_End-DialogEnding_KeysA_Process_Index)/8)<<24|(DialogEnding_KeysA_Process_Index-4)			; 0 keys
		dc.l ((DialogEnding_KeysB_Process_Index_End-DialogEnding_KeysB_Process_Index)/8)<<24|(DialogEnding_KeysB_Process_Index-4)			; else
		dc.l ((DialogEnding_KeysC_Process_Index_End-DialogEnding_KeysC_Process_Index)/8)<<24|(DialogEnding_KeysC_Process_Index-4)			; 12 keys
.difficulty_index
		dc.l ((DialogEnding_DiffA_Process_Index_End-DialogEnding_DiffA_Process_Index)/8)<<24|(DialogEnding_DiffA_Process_Index-4)				; normal
		dc.l ((DialogEnding_DiffB_Process_Index_End-DialogEnding_DiffB_Process_Index)/8)<<24|(DialogEnding_DiffB_Process_Index-4)				; hard
		dc.l ((DialogEnding_DiffC_Process_Index_End-DialogEnding_DiffC_Process_Index)/8)<<24|(DialogEnding_DiffC_Process_Index-4)				; maniac
.rank_index
		dc.l ((DialogEnding_Bad_Process_Index_End-DialogEnding_Bad_Process_Index)/8)<<24|(DialogEnding_Bad_Process_Index-4)					; bad
		dc.l ((DialogEnding_Good_Process_Index_End-DialogEnding_Good_Process_Index)/8)<<24|(DialogEnding_Good_Process_Index-4)				; good
