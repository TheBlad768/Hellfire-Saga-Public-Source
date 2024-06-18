; ---------------------------------------------------------------------------
; Subroutine to	check if an object is on the screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ChkObjOnScreen:
		move.w	$10(a0),d0	; get object x-position
		sub.w	(Camera_X_Pos).w,d0 ; subtract screen x-position
		bmi.s	NotOnScreen
		cmpi.w	#320,d0		; is object on the screen?
		bge.s	NotOnScreen	; if not, branch

		move.w	$14(a0),d1	; get object y-position
		sub.w	(Camera_Y_Pos).w,d1 ; subtract screen y-position
		bmi.s	NotOnScreen
		cmpi.w	#224,d1		; is object on the screen?
		bge.s	NotOnScreen	; if not, branch

		moveq	#0,d0		; set flag to 0
		rts	
; ===========================================================================

NotOnScreen:				; XREF: ChkObjOnScreen
		moveq	#1,d0		; set flag to 1
		rts
; End of function ChkObjOnScreen