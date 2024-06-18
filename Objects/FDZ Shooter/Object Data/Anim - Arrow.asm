Anim_FDZShooter_Arrow: offsetTable
		offsetTableEntry.w .normal
		offsetTableEntry.w .bend
.normal:		dc.b $1F, 4, afEnd
.bend:		dc.b 1, 4, 6, 5, 4, 6, 4, 5, 4, 6, 4, 4, 6, 5, 4, 6
			dc.b 4, 5, 4, 6, 4, afChange, 0
	even