; ---------------------------------------------------------------------------
; Called at the end of each frame to perform vertical synchronization
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Wait_VSync:
DelayProgram:
	if Debug_Lagometer
		move.w	#$9100,VDP_control_port		; NAT: Disable window
	endif
		enableInts

-		tst.b	(V_int_routine).w
		bne.s	-	; wait until V-int's run
		rts
; End of function Wait_VSync
