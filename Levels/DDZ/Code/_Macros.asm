; ===========================================================================
; ---------------------------------------------------------------------------
; Macros specialised for the DDZ boss
; ---------------------------------------------------------------------------

	; --- DMA transfer ---
	; VRAM, CRAM and VSRAM were already defined, but
	; it doesn't matter what they represent specifically
	; --------------------

DMA:		macro	Size, Type, Destination, Source
		move.l	#((((((Size)/$02)&$FF00)<<$08)+(((Size)/$02)&$FF))+$94009300),(a6)
		move.l	#(((((((Source)&$FFFFFF)/$02)&$FF00)<<$08)+((((Source)&$FFFFFF)/$02)&$FF))+$96009500),(a6)
		if Type=VRAM
		move.l	#((((((Source)&$FFFFFF)/$02)&$7F0000)+$97000000)+((Destination)&$3FFF)|$4000),(a6)
		move.w	#((((Destination)>>$0E)&$03)|$80),(DMA_trigger_word).w
		elseif Type=CRAM
		move.l	#((((((Source)&$FFFFFF)/$02)&$7F0000)+$97000000)+((Destination)&$3FFF)|$C000),(a6)
		move.w	#((((Destination)>>$0E)&$03)|$80),(DMA_trigger_word).w
		else
		move.l	#((((((Source)&$FFFFFF)/$02)&$7F0000)+$97000000)+((Destination)&$3FFF)|$4000),(a6)
		move.w	#((((Destination)>>$0E)&$03)|$90),(DMA_trigger_word).w
		endif
		move.w	(DMA_trigger_word).w,(a6)
		endm

; ===========================================================================