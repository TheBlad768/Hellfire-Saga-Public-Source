Anim_BossGrimReaperScythe: offsetTable
		offsetTableEntry.w .ball		; 0
		offsetTableEntry.w .scythe		; 1
.ball			dc.b 3, 0, 1, 2, afRoutine, afChange, 1
.scythe		dc.b 0, 3, 4, 5, 6, 7, 8, 9, $A, afEnd
	even