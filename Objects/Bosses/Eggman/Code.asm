Obj_Eggman_LookOnSonic:
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.w	+
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		rts