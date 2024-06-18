; ===========================================================================
; Levels Data
; ===========================================================================

		;		1st 8x8 data		1st 16x16 data		1st 128x128 data	palette
LevelLoadBlock:
		levartptrs FDZ1_8x8_KosM, FDZ1_16x16_Unc, FDZ1_128x128_Kos, palid_FDZ			; FDZ1
		levartptrs FDZ2_8x8_KosM, FDZ2_16x16_Unc, FDZ2_128x128_Kos, palid_FDZ		; FDZ2
		levartptrs FDZ3_8x8_KosM, FDZ3_16x16_Unc, FDZ3_128x128_Kos, palid_FDZ3		; FDZ3
		levartptrs FDZ3_8x8_KosM, FDZ3_16x16_Unc, FDZ3_128x128_Kos, palid_FDZ3		; FDZ4

		levartptrs SCZ1_8x8_KosM, SCZ1_16x16_Unc, SCZ1_128x128_Kos, palid_SCZ			; SCZ1
		levartptrs SCZ2_8x8_KosM, SCZ2_16x16_Unc, SCZ2_128x128_Kos, palid_SCZ2		; SCZ2
		levartptrs SCZ3_8x8_KosM, SCZ3_16x16_Unc, SCZ3_128x128_Kos, palid_SCZ2		; SCZ3
		levartptrs SCZ3_8x8_KosM, SCZ3_16x16_Unc, SCZ3_128x128_Kos, palid_SCZ			; SCZ4

		levartptrs GMZ_8x8_KosM, GMZ1_16x16_Unc, GMZ1_128x128_Kos, palid_GMZ		; GMZ1
		levartptrs GMZ2_8x8_KosM, GMZ2_16x16_Unc, GMZ2_128x128_Kos, palid_GMZ2	; GMZ2
		levartptrs GMZ3_8x8_KosM, GMZ3_16x16_Unc, GMZ3_128x128_Kos, palid_GMZ3	; GMZ3
		levartptrs GMZ_8x8_KosM, GMZ1_16x16_Unc, GMZ1_128x128_Kos, palid_GMZ		; GMZ4

		levartptrs DDZ_8x8_KosM, DDZ_16x16_Unc, DDZ_128x128_Kos, palid_DDZ			; DDZ1
		levartptrs DDZ_8x8_KosM, DDZ_16x16_Unc, DDZ_128x128_Kos, palid_DDZ			; DDZ2
		levartptrs DDZ_8x8_KosM, DDZ_16x16_Unc, DDZ_128x128_Kos, palid_DDZ			; DDZ3
		levartptrs DDZ_8x8_KosM, DDZ_16x16_Unc, DDZ_128x128_Kos, palid_DDZ			; DDZ4

		levartptrs CRE_8x8_KosM, CRE_16x16_Unc, CRE_128x128_Kos, palid_CRE			; Credits1

; ===========================================================================
; Levels Pointer Data
; ===========================================================================

LevelLoadPointer:

; FDZ1
		dc.l AnPal_None, Resize_FDZ1, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, FDZ_BackgroundInit, FDZ_ScreenEvent, FDZ1_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; FDZ2
		dc.l AnPal_None, Resize_FDZ2, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, FDZ_BackgroundInit, FDZ_ScreenEvent, FDZ2_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; FDZ3
		dc.l AnPal_FDZ3, Resize_FDZ3, No_WaterResize, AfterBoss_Null
		dc.l FDZ3_ScreenInit, FDZ3_BackgroundInit, SCZ1_ScreenEvent, FDZ3_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; FDZ4
		dc.l AnPal_None, Resize_FDZ4, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, FDZ3_BackgroundInit, SCZ1_ScreenEvent, FDZ3_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; SCZ1
		dc.l AnPal_None, Resize_SCZ1, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, SCZ1_BackgroundInit, SCZ1_ScreenEvent, SCZ1_BackgroundEvent
		dc.l AnimateTiles_SCZ1, AniPLC_SCZ1

; SCZ2
		dc.l AnPal_None, Resize_SCZ2, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, SCZ2_BackgroundInit, SCZ1_ScreenEvent, SCZ2_BackgroundEvent
		dc.l AnimateTiles_SCZ2, AniPLC_SCZ1

; SCZ3
		dc.l AnPal_None, SCZ3_Resize, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, SCZ2_BackgroundInit, SCZ1_ScreenEvent, SCZ2_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; SCZ4
		dc.l AnPal_None, Resize_SCZ4, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, SCZ1_BackgroundInit, SCZ1_ScreenEvent, SCZ1_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; GMZ1
		dc.l AnPal_None, Resize_GMZ1, No_WaterResize, AfterBoss_Null
		dc.l GMZ_ScreenInit, GMZ1_BackgroundInit, SCZ1_ScreenEvent, GMZ1_BackgroundEvent
		dc.l AnimateTiles_GMZ1, AniPLC_GMZ1

; GMZ2
		dc.l AnPal_None, Resize_GMZ2, No_WaterResize, AfterBoss_Null
		dc.l GMZ_ScreenInit, GMZ2_BackgroundInit, SCZ1_ScreenEvent, GMZ2_BackgroundEvent
		dc.l AnimateTiles_GMZ1, AniPLC_GMZ2

; GMZ3
		dc.l AnPal_None, Resize_GMZ3, No_WaterResize, AfterBoss_Null
		dc.l GMZ_ScreenInit, GMZ2_BackgroundInit, SCZ1_ScreenEvent, GMZ3_BackgroundEvent
		dc.l AnimateTiles_GMZ1, AniPLC_GMZ1

; GMZ4
		dc.l AnPal_None, Resize_GMZ4, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, GMZ_BackgroundInit, SCZ1_ScreenEvent, GMZ3_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; DDZ1
		dc.l AnPal_None, Resize_DDZ, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, DDZ_BackgroundInit, SCZ1_ScreenEvent, DDZ_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; DDZ2
		dc.l AnPal_None, Resize_DDZ, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, DDZ_BackgroundInit, SCZ1_ScreenEvent, DDZ_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; DDZ3
		dc.l AnPal_None, Resize_DDZ, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, DDZ_BackgroundInit, SCZ1_ScreenEvent, DDZ_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; DDZ4
		dc.l AnPal_None, Resize_DDZ, No_WaterResize, AfterBoss_Null
		dc.l SCZ1_ScreenInit, DDZ_BackgroundInit, SCZ1_ScreenEvent, DDZ_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; Credits
		dc.l AnPal_None, Resize_CRE, No_WaterResize, AfterBoss_Null
		dc.l CRE_ScreenInit, CRE_BackgroundInit, CRE_ScreenEvent, CRE_BackgroundEvent
		dc.l AnimateTiles_NULL, AniPLC_NULL

; ===========================================================================
; Collision index pointers
; ===========================================================================

SolidIndexes:
		dc.l Solid_FDZ1		; FDZ1
		dc.l Solid_FDZ2		; FDZ2
		dc.l Solid_FDZ3		; FDZ3
		dc.l Solid_FDZ3		; FDZ4
		dc.l Solid_SCZ1		; SCZ1
		dc.l Solid_SCZ2		; SCZ2
		dc.l Solid_SCZ3		; SCZ3
		dc.l Solid_SCZ3		; SCZ4
		dc.l Solid_GMZ1		; GMZ1
		dc.l Solid_GMZ2		; GMZ2
		dc.l Solid_GMZ3		; GMZ3
		dc.l Solid_GMZ1		; GMZ4
		dc.l Solid_DDZ		; DDZ1
		dc.l Solid_DDZ		; DDZ2
		dc.l Solid_DDZ		; DDZ3
		dc.l Solid_DDZ		; DDZ4
		dc.l Solid_CRE		; Credits

; ===========================================================================
; Level layout index
; ===========================================================================

LevelPtrs:
		dc.l Layout_FDZ1		; FDZ1
		dc.l Layout_FDZ2		; FDZ2
		dc.l Layout_FDZ3		; FDZ3
		dc.l Layout_FDZ4		; FDZ4
		dc.l Layout_SCZ1		; SCZ1
		dc.l Layout_SCZ2		; SCZ2
		dc.l Layout_SCZ3		; SCZ3
		dc.l Layout_SCZ4		; SCZ4
		dc.l Layout_GMZ1		; GMZ1
		dc.l Layout_GMZ2		; GMZ2
		dc.l Layout_GMZ3		; GMZ3
		dc.l Layout_GMZ4		; GMZ4
		dc.l Layout_DDZ		; DDZ1
		dc.l Layout_DDZ		; DDZ2
		dc.l Layout_DDZ		; DDZ3
		dc.l Layout_DDZ		; DDZ4
		dc.l Layout_CRE		; Credits

; ===========================================================================
; Level layout for new game+ index
; ===========================================================================

LevelPtrs2:
		dc.l Layout_FDZ1ex		; FDZ1
		dc.l Layout_FDZ2ex		; FDZ2
		dc.l Layout_FDZ3ex		; FDZ3
		dc.l Layout_FDZ4		; FDZ4
		dc.l Layout_SCZ1ex		; SCZ1
		dc.l Layout_SCZ2ex		; SCZ2
		dc.l Layout_SCZ3		; SCZ3
		dc.l Layout_SCZ4		; SCZ4
		dc.l Layout_GMZ1ex		; GMZ1
		dc.l Layout_GMZ2ex		; GMZ2
		dc.l Layout_GMZ3		; GMZ3
		dc.l Layout_GMZ4		; GMZ4
		dc.l Layout_DDZ		; DDZ1
		dc.l Layout_DDZ		; DDZ2
		dc.l Layout_DDZ		; DDZ3
		dc.l Layout_DDZ		; DDZ4
		dc.l Layout_CRE		; Credits

; ===========================================================================
; Sprite locations index
; ===========================================================================

SpriteLocPtrs:
		dc.l FDZ1_Sprites		; FDZ1
		dc.l FDZ2_Sprites		; FDZ2
		dc.l FDZ3_Sprites		; FDZ3
		dc.l FDZ4_Sprites		; FDZ4
		dc.l SCZ1_Sprites		; SCZ1
		dc.l SCZ2_Sprites		; SCZ2
		dc.l SCZ3_Sprites		; SCZ3
		dc.l SCZ4_Sprites		; SCZ4
		dc.l GMZ1_Sprites		; GMZ1
		dc.l GMZ2_Sprites	; GMZ2
		dc.l GMZ3_Sprites	; GMZ3
		dc.l GMZ4_Sprites	; GMZ4
		dc.l DDZ_Sprites		; DDZ1
		dc.l DDZ_Sprites		; DDZ2
		dc.l DDZ_Sprites		; DDZ3
		dc.l DDZ_Sprites		; DDZ4
		dc.l CRE_Sprites		; Credits

; ===========================================================================
; Sprite locations for new game+ index
; ===========================================================================

SpriteLocPtrs2:
		dc.l FDZ1_Sprites2		; FDZ1
		dc.l FDZ2_Sprites2		; FDZ2
		dc.l FDZ3_Sprites2		; FDZ3
		dc.l FDZ4_Sprites		; FDZ4
		dc.l SCZ1_Sprites2		; SCZ1
		dc.l SCZ2_Sprites2		; SCZ2
		dc.l SCZ3_Sprites2		; SCZ3
		dc.l SCZ4_Sprites		; SCZ4
		dc.l GMZ1_Sprites2		; GMZ1
		dc.l GMZ2_Sprites2	; GMZ2
		dc.l GMZ3_Sprites2	; GMZ3
		dc.l GMZ4_Sprites	; GMZ4
		dc.l DDZ_Sprites		; DDZ1
		dc.l DDZ_Sprites		; DDZ2
		dc.l DDZ_Sprites		; DDZ3
		dc.l DDZ_Sprites		; DDZ4
		dc.l CRE_Sprites		; Credits

; ===========================================================================
; Ring locations index
; ===========================================================================

RingLocPtrs:
		dc.l FDZ1_Rings		; FDZ1
		dc.l FDZ2_Rings		; FDZ2
		dc.l FDZ3_Rings		; FDZ3
		dc.l FDZ4_Rings		; FDZ4
		dc.l SCZ1_Rings		; SCZ1
		dc.l SCZ2_Rings		; SCZ2
		dc.l SCZ3_Rings		; SCZ3
		dc.l SCZ4_Rings		; SCZ4
		dc.l GMZ1_Rings		; GMZ1
		dc.l GMZ2_Rings		; GMZ2
		dc.l GMZ3_Rings		; GMZ3
		dc.l GMZ4_Rings		; GMZ4
		dc.l DDZ_Rings		; DDZ1
		dc.l DDZ_Rings		; DDZ2
		dc.l DDZ_Rings		; DDZ3
		dc.l DDZ_Rings		; DDZ4
		dc.l CRE_Rings		; Credits

; ===========================================================================
; Ring locations for new game+ index
; ===========================================================================

RingLocPtrs2:
		dc.l FDZ1_Rings2		; FDZ1
		dc.l FDZ2_Rings2		; FDZ2
		dc.l FDZ3_Rings2		; FDZ3
		dc.l FDZ4_Rings		; FDZ4
		dc.l SCZ1_Rings2		; SCZ1
		dc.l SCZ2_Rings2		; SCZ2
		dc.l SCZ3_Rings2		; SCZ3
		dc.l SCZ4_Rings		; SCZ4
		dc.l GMZ1_Rings2		; GMZ1
		dc.l GMZ2_Rings2		; GMZ2
		dc.l GMZ3_Rings2		; GMZ3
		dc.l GMZ4_Rings		; GMZ4
		dc.l DDZ_Rings		; DDZ1
		dc.l DDZ_Rings		; DDZ2
		dc.l DDZ_Rings		; DDZ3
		dc.l DDZ_Rings		; DDZ4
		dc.l CRE_Rings		; Credits
; ===========================================================================
; Compressed graphics - primary patterns and block mappings
; ===========================================================================

FDZ1_8x8_KosM:				binclude "Levels/FDZ/Tiles/1.bin"
	even
FDZ2_8x8_KosM:				binclude "Levels/FDZ/Tiles/2.bin"
	even
FDZ3_8x8_KosM:				binclude "Levels/FDZ/Tiles/3.bin"
	even
FDZ1_16x16_Unc:				binclude "Levels/FDZ/Blocks/1.bin"
	even
FDZ2_16x16_Unc:				binclude "Levels/FDZ/Blocks/2.bin"
	even
FDZ3_16x16_Unc:				binclude "Levels/FDZ/Blocks/3.bin"
	even
FDZ1_128x128_Kos:			binclude "Levels/FDZ/Chunks/1.bin"
	even
FDZ2_128x128_Kos:			binclude "Levels/FDZ/Chunks/2.bin"
	even
FDZ3_128x128_Kos:			binclude "Levels/FDZ/Chunks/3.bin"
	even
SCZ1_8x8_KosM:				binclude "Levels/SCZ/Tiles/1.bin"
	even
SCZ2_8x8_KosM:				binclude "Levels/SCZ/Tiles/2.bin"
	even
SCZ3_8x8_KosM:				binclude "Levels/SCZ/Tiles/3.bin"
	even
SCZ1_16x16_Unc:				binclude "Levels/SCZ/Blocks/1.bin"
	even
SCZ2_16x16_Unc:				binclude "Levels/SCZ/Blocks/2.bin"
	even
SCZ3_16x16_Unc:				binclude "Levels/SCZ/Blocks/3.bin"
	even
SCZ1_128x128_Kos:			binclude "Levels/SCZ/Chunks/1.bin"
	even
SCZ2_128x128_Kos:			binclude "Levels/SCZ/Chunks/2.bin"
	even
SCZ3_128x128_Kos:			binclude "Levels/SCZ/Chunks/3.bin"
	even
GMZ_8x8_KosM:				binclude "Levels/GMZ/Tiles/1.bin"
	even
GMZ2_8x8_KosM:			binclude "Levels/GMZ/Tiles/2.bin"
	even
GMZ3_8x8_KosM:			binclude "Levels/GMZ/Tiles/3.bin"
	even
GMZ1_16x16_Unc:			binclude "Levels/GMZ/Blocks/1.bin"
	even
GMZ2_16x16_Unc:			binclude "Levels/GMZ/Blocks/2.bin"
	even
GMZ3_16x16_Unc:			binclude "Levels/GMZ/Blocks/3.bin"
	even
GMZ1_128x128_Kos:			binclude "Levels/GMZ/Chunks/1.bin"
	even
GMZ2_128x128_Kos:			binclude "Levels/GMZ/Chunks/2.bin"
	even
GMZ3_128x128_Kos:			binclude "Levels/GMZ/Chunks/3.bin"
	even
DDZ_8x8_KosM:				binclude "Levels/DDZ/Tiles/Primary.bin"
	even
DDZ_16x16_Unc:				binclude "Levels/DDZ/Blocks/Primary.bin"
	even
DDZ_128x128_Kos:			binclude "Levels/DDZ/Chunks/Primary.bin"
	even
CRE_8x8_KosM:				binclude "Levels/CRE/Tiles/1.bin"
	even
CRE_8x8_KosM_B:				binclude "Levels/CRE/Tiles/1b.bin"
	even
CRE_16x16_Unc:				binclude "Levels/CRE/Blocks/1.bin"
	even
CRE_128x128_Kos:			binclude "Levels/CRE/Chunks/1.bin"
	even

; ===========================================================================
; Collision data
; ===========================================================================

;	align $1000		; this was the only fucking way to make AS assemble this piece of fucking shit align instruction fuck my life may as well go jump down a fucking roof while I am at this

AngleArray:				binclude "Misc Data/Angle Map.bin"
	even
HeightMaps:				binclude "Misc Data/Height Maps.bin"
	even
HeightMapsRot:			binclude "Misc Data/Height Maps Rotated.bin"
	even

; ===========================================================================
; Level collision data
; ===========================================================================

Solid_FDZ1:				binclude "Levels/FDZ/Collision/1.bin"
	even
Solid_FDZ2:				binclude "Levels/FDZ/Collision/2.bin"
	even
Solid_FDZ3:				binclude "Levels/FDZ/Collision/3.bin"
	even
Solid_SCZ1:				binclude "Levels/SCZ/Collision/1.bin"
	even
Solid_SCZ2:				binclude "Levels/SCZ/Collision/2.bin"
	even
Solid_SCZ3:				binclude "Levels/SCZ/Collision/3.bin"
	even
Solid_GMZ1:				binclude "Levels/GMZ/Collision/1.bin"
	even
Solid_GMZ2:				binclude "Levels/GMZ/Collision/2.bin"
	even
Solid_GMZ3:				binclude "Levels/GMZ/Collision/3.bin"
	even
Solid_DDZ:				binclude "Levels/DDZ/Collision/1.bin"
	even
Solid_CRE:				binclude "Levels/CRE/Collision/1.bin"
	even

; ===========================================================================
; Level layout data
; ===========================================================================

		align $8000

Layout_FDZ1:			binclude "Levels/FDZ/Layout/1.bin"
	even
Layout_FDZ2:			binclude "Levels/FDZ/Layout/2.bin"
	even
Layout_FDZ2_CutScene:	binclude "Levels/FDZ/Layout/2cs.bin"
	even
Layout_FDZ3:			binclude "Levels/FDZ/Layout/3.bin"
	even
Layout_FDZ3_Alt:			binclude "Levels/FDZ/Layout/3.2.bin"
	even
Layout_FDZ4:			binclude "Levels/FDZ/Layout/4.bin"
	even
Layout_SCZ1:				binclude "Levels/SCZ/Layout/1.bin"
	even
Layout_SCZ2:			binclude "Levels/SCZ/Layout/2.bin"
	even
Layout_SCZ3:			binclude "Levels/SCZ/Layout/3.bin"
	even
Layout_SCZ4:			binclude "Levels/SCZ/Layout/4.bin"
	even
Layout_GMZ1:			binclude "Levels/GMZ/Layout/1.bin"
	even
Layout_GMZ2:			binclude "Levels/GMZ/Layout/2.bin"
	even
Layout_GMZ2_Alt:		binclude "Levels/GMZ/Layout/2.2.bin"
	even
Layout_GMZ3:			binclude "Levels/GMZ/Layout/3.bin"
	even
Layout_GMZ4:			binclude "Levels/GMZ/Layout/4.bin"
	even
Layout_DDZ:				binclude "Levels/DDZ/Layout/1.bin"
	even
Layout_CRE:				binclude "Levels/CRE/Layout/1.bin"
	even

; ===========================================================================
; Level layout data for new game +
; ===========================================================================

Layout_FDZ1ex:			binclude "Levels/FDZ/Layout/1ex.bin"
	even
Layout_FDZ2ex:			binclude "Levels/FDZ/Layout/2ex.bin"
	even
Layout_FDZ3ex:			binclude "Levels/FDZ/Layout/3ex.bin"
	even
Layout_FDZ3_Altex:			binclude "Levels/FDZ/Layout/3.2ex.bin"
	even
Layout_SCZ1ex:				binclude "Levels/SCZ/Layout/1ex.bin"
	even
Layout_SCZ2ex:			binclude "Levels/SCZ/Layout/2ex.bin"
	even
Layout_GMZ1ex:			binclude "Levels/GMZ/Layout/1ex.bin"
	even
Layout_GMZ2ex:			binclude "Levels/GMZ/Layout/2ex.bin"
	even
Layout_GMZ2_Altex:		binclude "Levels/GMZ/Layout/2.2ex.bin"
	even

; ===========================================================================
; Level sprite data
; ===========================================================================

	ObjectLayoutBoundary
Null_Sprites:
	ObjectLayoutBoundary
FDZ1_Sprites:	binclude "Levels/FDZ/Object Pos/1.bin"
	ObjectLayoutBoundary
FDZ2_Sprites:	binclude "Levels/FDZ/Object Pos/2.bin"
	ObjectLayoutBoundary
FDZ3_Sprites:	binclude "Levels/FDZ/Object Pos/3.bin"
	ObjectLayoutBoundary
FDZ3_Sprites_Alt:binclude "Levels/FDZ/Object Pos/3.2.bin"
	ObjectLayoutBoundary
FDZ4_Sprites:	binclude "Levels/FDZ/Object Pos/4.bin"
	ObjectLayoutBoundary
SCZ1_Sprites:	binclude "Levels/SCZ/Object Pos/1.bin"
	ObjectLayoutBoundary
SCZ2_Sprites:	binclude "Levels/SCZ/Object Pos/2.bin"
	ObjectLayoutBoundary
SCZ3_Sprites:	binclude "Levels/SCZ/Object Pos/3.bin"
	ObjectLayoutBoundary
SCZ4_Sprites:	binclude "Levels/SCZ/Object Pos/4.bin"
	ObjectLayoutBoundary
GMZ1_Sprites:	binclude "Levels/GMZ/Object Pos/1.bin"
	ObjectLayoutBoundary
GMZ2_Sprites:	binclude "Levels/GMZ/Object Pos/2.bin"
	ObjectLayoutBoundary
GMZ3_Sprites:	binclude "Levels/GMZ/Object Pos/3.bin"
	ObjectLayoutBoundary
GMZ4_Sprites:	binclude "Levels/GMZ/Object Pos/4.bin"
	ObjectLayoutBoundary
DDZ_Sprites:		binclude "Levels/DDZ/Object Pos/1.bin"
	ObjectLayoutBoundary
CRE_Sprites:		binclude "Levels/CRE/Object Pos/1.bin"
	ObjectLayoutBoundary

; ===========================================================================
; Level sprite data for new game +
; ===========================================================================
FDZ1_Sprites2:	binclude "Levels/FDZ/Object Pos/1ex.bin"
	ObjectLayoutBoundary
FDZ2_Sprites2:	binclude "Levels/FDZ/Object Pos/2ex.bin"
	ObjectLayoutBoundary
FDZ3_Sprites2:	binclude "Levels/FDZ/Object Pos/3ex.bin"
	ObjectLayoutBoundary
FDZ3_Sprites_Alt2:binclude "Levels/FDZ/Object Pos/3.2ex.bin"
	ObjectLayoutBoundary
SCZ1_Sprites2:	binclude "Levels/SCZ/Object Pos/1ex.bin"
	ObjectLayoutBoundary
SCZ2_Sprites2:	binclude "Levels/SCZ/Object Pos/2ex.bin"
	ObjectLayoutBoundary
SCZ3_Sprites2:	binclude "Levels/SCZ/Object Pos/3ex.bin"
	ObjectLayoutBoundary
GMZ1_Sprites2:	binclude "Levels/GMZ/Object Pos/1ex.bin"
	ObjectLayoutBoundary
GMZ2_Sprites2:	binclude "Levels/GMZ/Object Pos/2ex.bin"
	ObjectLayoutBoundary
GMZ3_Sprites2:	binclude "Levels/GMZ/Object Pos/3ex.bin"
	ObjectLayoutBoundary
	even

; ===========================================================================
; Level ring data
; ===========================================================================

	RingLayoutBoundary
Null_Rings:
	RingLayoutBoundary
FDZ1_Rings:	binclude "Levels/FDZ/Ring Pos/1.bin"
	RingLayoutBoundary
FDZ2_Rings:	binclude "Levels/FDZ/Ring Pos/2.bin"
	RingLayoutBoundary
FDZ3_Rings:	binclude "Levels/FDZ/Ring Pos/3.bin"
	RingLayoutBoundary
FDZ3_Rings_Alt:	binclude "Levels/FDZ/Ring Pos/3.2.bin"
	RingLayoutBoundary
FDZ4_Rings:	binclude "Levels/FDZ/Ring Pos/4.bin"
	RingLayoutBoundary
SCZ1_Rings:	binclude "Levels/SCZ/Ring Pos/1.bin"
	RingLayoutBoundary
SCZ2_Rings:	binclude "Levels/SCZ/Ring Pos/2.bin"
	RingLayoutBoundary
SCZ3_Rings:	binclude "Levels/SCZ/Ring Pos/3.bin"
	RingLayoutBoundary
SCZ4_Rings:	binclude "Levels/SCZ/Ring Pos/4.bin"
	RingLayoutBoundary
GMZ1_Rings:	binclude "Levels/GMZ/Ring Pos/1.bin"
	RingLayoutBoundary
GMZ2_Rings:	binclude "Levels/GMZ/Ring Pos/2.bin"
	RingLayoutBoundary
GMZ3_Rings:	binclude "Levels/GMZ/Ring Pos/3.bin"
	RingLayoutBoundary
GMZ4_Rings:	binclude "Levels/GMZ/Ring Pos/4.bin"
	RingLayoutBoundary
DDZ_Rings:		binclude "Levels/DDZ/Ring Pos/1.bin"
	RingLayoutBoundary
CRE_Rings:		binclude "Levels/CRE/Ring Pos/1.bin"
	RingLayoutBoundary

; ===========================================================================
; Level ring data for new game +
; ===========================================================================

FDZ1_Rings2:	binclude "Levels/FDZ/Ring Pos/1ex.bin"
	RingLayoutBoundary
FDZ2_Rings2:	binclude "Levels/FDZ/Ring Pos/2ex.bin"
	RingLayoutBoundary
FDZ3_Rings2:	binclude "Levels/FDZ/Ring Pos/3ex.bin"
	RingLayoutBoundary
FDZ3_Rings_Alt2:	binclude "Levels/FDZ/Ring Pos/3.2ex.bin"
	RingLayoutBoundary
SCZ1_Rings2:	binclude "Levels/SCZ/Ring Pos/1ex.bin"
	RingLayoutBoundary
SCZ2_Rings2:	binclude "Levels/SCZ/Ring Pos/2ex.bin"
	RingLayoutBoundary
SCZ3_Rings2:	binclude "Levels/SCZ/Ring Pos/3ex.bin"
	RingLayoutBoundary
GMZ1_Rings2:	binclude "Levels/GMZ/Ring Pos/1ex.bin"
	RingLayoutBoundary
GMZ2_Rings2:	binclude "Levels/GMZ/Ring Pos/2ex.bin"
	RingLayoutBoundary
GMZ3_Rings2:	binclude "Levels/GMZ/Ring Pos/3ex.bin"
	RingLayoutBoundary
	even