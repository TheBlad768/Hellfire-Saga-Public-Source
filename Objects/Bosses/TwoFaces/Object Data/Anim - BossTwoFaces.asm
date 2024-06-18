Anim_BossTwoFaces: offsetTable
		offsetTableEntry.w .blank				; 0
		offsetTableEntry.w .closed				; 1
		offsetTableEntry.w .appearanceclosed		; 2
		offsetTableEntry.w .open				; 3
		offsetTableEntry.w .disappearanceclosed	; 4
		offsetTableEntry.w .heart				; 5
		offsetTableEntry.w .defeated			; 6

.blank		dc.b 0, $1F, afEnd
.closed		dc.b 1, $1F, afEnd

.appearanceclosed
			dc.b 1, 0, afRoutine, afRoutine, 0, 10, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 10, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 10, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 9, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 8, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 7, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 6, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 5, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 4, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 3, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 3, 2, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 1, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 4, 0, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 0, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 5, 0, afChange, 1

.open		dc.b 2, $1F, afEnd

.disappearanceclosed
			dc.b 1, 0, afRoutine, afRoutine, 0, 10, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 10, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 10, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 9, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 8, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 7, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 6, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 5, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 4, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 3, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 3, 2, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 1, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 4, 0, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 0, 0, afRoutine, afRoutine
			dc.b 1, 0, afRoutine, afRoutine, 5, 0, afChange, 5

.heart		dc.b 3, 8, 4, 8, afEnd
.defeated		dc.b 3, 1, 4, 1, afEnd

	even
