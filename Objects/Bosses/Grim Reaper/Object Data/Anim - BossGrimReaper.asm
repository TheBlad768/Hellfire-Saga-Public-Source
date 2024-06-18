Anim_BossGrimReaper: offsetTable
		offsetTableEntry.w .blank		; 0
		offsetTableEntry.w .stand		; 1
		offsetTableEntry.w .showarm	; 2
		offsetTableEntry.w .hidearm	; 3
		offsetTableEntry.w .flash		; 4
.blank		dc.b $1F, 0, afEnd
.stand		dc.b $1F, 1, afEnd
.showarm	dc.b 5, 1, 2, afBack, 1
.hidearm		dc.b 5, 2, afChange, 1
.flash		dc.b 1, 0, 1, afEnd
	even