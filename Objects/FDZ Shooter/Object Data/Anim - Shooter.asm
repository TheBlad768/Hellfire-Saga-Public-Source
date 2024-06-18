Anim_FDZShooter: offsetTable
		offsetTableEntry.w .wait
		offsetTableEntry.w .flash
		offsetTableEntry.w .openclose
.wait:		dc.b $1F, 0, afEnd
.flash:		dc.b 3, 0, 1, afEnd
.openclose:	dc.b 7, 2, 3, afRoutine, 3, 2, 0, afChange, 0
	even