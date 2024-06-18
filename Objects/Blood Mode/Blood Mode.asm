; ---------------------------------------------------------------------------
; Blood Mode version v1.0(Informal name: Raspidorasilo Mode).
; Programmed by TheBlad768 (2017).
; ---------------------------------------------------------------------------

; Object variables
obVRAM_BloodShow:		= $7C0								; ���������� VRAM �����
; ---------------------------------------------------------------------------
; ��������� ��� �������� �������� ��������(�����, �����, ������, ����).
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_KillBloodCreate:
		movem.l	d0-d3/a0-a2,-(sp)
		lea	BloodCreate_Data(pc),a2								; ��������� ������.
		moveq	#0,d2										; �������� d2
		moveq	#0,d3										; �������� d3
		move.w	(Current_zone_and_act).w,d3
		lsl.b	#6,d3
		lsr.w	#5,d3
		move.w	(a2)+,d1									; ������� �������� �������.
		move.w	KillBlood_Vram(pc,d3.w),d3

-		jsr	(Create_New_Sprite).w								; ��������� �������� ��������.
		bne.s	OKBC_rts									; ���� ��� �� �� ���, �������.
		move.l	#Obj_BloodShow,(a1)								; ID �������.
		move.l	#Map_Flesh,obMap(a1)								; ���������� ����� ���������.
		move.w	d3,obGfx(a1)									; ���������� VRAM �����.
		move.w	obX(a0),obX(a1)									; ������������ ���� ������� �� X, ��� � ������(���������, ������� ������).
		move.w	obY(a0),obY(a1)									; ������������ ���� ������� �� Y, ��� � ������(���������, ������� ������).
		move.b	(a2)+,obAnim(a1)								; ���������� ��������.

		move.b	(a2)+,d2									; �������� ������ ���� ����������� ������� � d2.
		beq.s	+										; �� ������������� ������ �� �����������.
		bset	d2,obStatus(a1)									; ���������� ����(���) ����������� �������.

+
		or.b	#$80,obRender(a1)
		tst.b	GravityAngle.w									; NAT: Check if reverse gravity is active
		bpl.s	+										; if not, skip
		neg.w	obVelY(a1)									; negate y-velocity

+
		move.l	(a2)+,obVelX(a1)								; ���������� �������� �� XY.
		move.w	#6*$80,obPriority(a1)								; ���������� ���������.
		bset	#2,obRender(a1)									; ���������� ���� ��������� ������.
		dbf	d1,-										; ��������� ���� ��� ������� �� ����� ���������.

+		cmpi.b	#id_Null,anim(a0)								; is Sonic in his 'blank' animation
		bne.s	OKBC_rts									; if so, branch
		move.w	#1,(Sonic_Dead).w
		music	mus_ArthurDeath

OKBC_rts:
		movem.l	(sp)+,d0-d3/a0-a2
		rts
; ---------------------------------------------------------------------------

KillBlood_Vram:
		dc.w $558	; FDZ Act 1
		dc.w $558	; FDZ Act 2
		dc.w $558	; FDZ Act 3
		dc.w $558	; FDZ Act 4
		dc.w $558	; SCZ Act 1
		dc.w $558	; SCZ Act 2
		dc.w $558	; SCZ Act 3
		dc.w $558	; SCZ Act 4
		dc.w $558	; GMZ Act 1
		dc.w $558	; GMZ Act 2
		dc.w $558	; GMZ Act 3
		dc.w $562	; GMZ Act 4
		dc.w $558	; DDZ Act 1
		dc.w $558	; DDZ Act 2
		dc.w $558	; DDZ Act 3
		dc.w $558	; DDZ Act 4
; ---------------------------------------------------------------------------

BloodCreate_Data:
		dc.w ((BloodCreate_Data_End-BloodCreate_Data)/6)-1	; ������� �������� �������.
; ������
		dc.b 0, 0				; ��������, �����������.
		dc.w $50, -$A00		; X ��������, Y ��������.
; �����
		dc.b 1, 0				; ��������, �����������.
		dc.w 0, -$600		; X ��������, Y ��������.
; �����
		dc.b 1, 0				; ��������, �����������.
		dc.w $100, -$800		; X ��������, Y ��������.
; �����
		dc.b 1, 1				; ��������, �����������.
		dc.w -$100, -$800		; X ��������, Y ��������.
; �����
		dc.b 1, 0				; ��������, �����������.
		dc.w -$100, -$600		; X ��������, Y ��������.
; �����
		dc.b 1, 1				; ��������, �����������.
		dc.w $200, -$500		; X ��������, Y ��������.
; �����
		dc.b 1, 0				; ��������, �����������.
		dc.w -$200, -$600	; X ��������, Y ��������.
; �����
		dc.b 1, 1				; ��������, �����������.
		dc.w $300, -$700		; X ��������, Y ��������.
; �����
		dc.b 1, 0				; ��������, �����������.
		dc.w -$300, -$800	; X ��������, Y ��������.
; �����
		dc.b 2, 0				; ��������, �����������.
		dc.w $100, -$700		; X ��������, Y ��������.
; ����
		dc.b 3, 0				; ��������, �����������.
		dc.w 0, -$500			; X ��������, Y ��������.
; ����
		dc.b 3, 1				; ��������, �����������.
		dc.w -$50, -$400		; X ��������, Y ��������.
; ����
		dc.b 3, 0				; ��������, �����������.
		dc.w -$100, -$500		; X ��������, Y ��������.
; ����
		dc.b 3, 1				; ��������, �����������.
		dc.w $150, -$850		; X ��������, Y ��������.
; ����
		dc.b 3, 0				; ��������, �����������.
		dc.w $200, -$650		; X ��������, Y ��������.
; ����
		dc.b 3, 1				; ��������, �����������.
		dc.w -$200, -$750		; X ��������, Y ��������.
; ����
		dc.b 3, 0				; ��������, �����������.
		dc.w $300, -$850		; X ��������, Y ��������.
; ����
		dc.b 3, 1				; ��������, �����������.
		dc.w -$300, -$950		; X ��������, Y ��������.
; ����� 2
		dc.b 4, 0				; ��������, �����������.
		dc.w $50, -$500		; X ��������, Y ��������.
; ����� 2
		dc.b 4, 1				; ��������, �����������.
		dc.w $100, -$450		; X ��������, Y ��������.
BloodCreate_Data_End
; ---------------------------------------------------------------------------
; ��������� ��� �������� �������� ��������(�����).
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_HurtBloodCreate:
		movem.l	d0-d2/a0-a2,-(sp)
		lea	BloodCreate_Data2(pc),a2								; ��������� ������.
		move.w	(a2)+,d1										; ������� �������� �������.

-		jsr	(Create_New_Sprite).w									; ��������� �������� ��������.
		bne.s	Obj_HBC_Ret										; ���� ��� �� �� ���, �������.
		move.l	#Obj_BloodShow.checkremove,(a1)								; ID �������.
		move.l	#Map_Flesh,obMap(a1)									; ���������� ����� ���������.
		move.w	#obVRAM_BloodShow,obGfx(a1)								; ���������� VRAM �����.
		move.w	obX(a0),obX(a1)										; ������������ ���� ������� �� X, ��� � ������(���������, ������� ������).
		move.w	obY(a0),obY(a1)										; ������������ ���� ������� �� Y, ��� � ������(���������, ������� ������).
		move.l	(a2),obVelX(a1)										; ������������ ������ ��� XY ��������.

		move.b	obStatus(a0),d0										; �������� ������ ���� ����������� ������� ������ � d0.
		bchg	#0,d0											; �������� ����(���) ����������� �������.
		bne.s	+
		neg.w	obVelX(a1)										; ������������� �������� �� X.

+		move.b	d0,obStatus(a1)										; ���������� ����(���) ����������� �������.
		andi.b	#1,obStatus(a1)										; ���������� ����(���) ����������� ������� �� �������������� �� �����������.
		or.b	#$80,obRender(a1)

		tst.b	GravityAngle.w										; NAT: Check if reverse gravity is active
		bpl.s	+											; if not, skip
		neg.w	obVelY(a1)										; negate y-velocity

+		tst.l	(a2)+											; ��������� �����������.
		bpl.s	+
		bchg	#0,obStatus(a1)										; �������� ����(���) ����������� �������.

+		move.b	#5,obAnim(a1)										; ���������� ��������.
		move.w	#6*$80,obPriority(a1)									; ���������� ���������.
		bset	#2,obRender(a1)										; ���������� ���� ��������� ������.
		dbf	d1,-											; ��������� ���� ��� ������� �� ����� ���������.

Obj_HBC_Ret:
		movem.l	(sp)+,d0-d2/a0-a2
		rts
; ---------------------------------------------------------------------------

Obj_SmallBloodCreate:
		movem.l	d0-d2/a0-a2,-(sp)
		lea	BloodCreate_Data3(pc),a2								; ��������� ������.
		moveq	#0,d2											; �������� d2
		move.w	(a2)+,d1										; ������� �������� �������.

-		jsr	(Create_New_Sprite).w									; ��������� �������� ��������.
		bne.s	Obj_SBC_Ret										; ���� ��� �� �� ���, �������.
		move.l	#Obj_BloodShow.checkremove,(a1)								; ID �������.
		move.l	#Map_Flesh,obMap(a1)									; ���������� ����� ���������.
		move.w	#obVRAM_BloodShow,obGfx(a1)								; ���������� VRAM �����.
		move.w	obX(a0),obX(a1)										; ������������ ���� ������� �� X, ��� � ������(���������, ������� ������).
		move.w	obY(a0),obY(a1)										; ������������ ���� ������� �� Y, ��� � ������(���������, ������� ������).
		move.l	(a2),obVelX(a1)										; ������������ ������ ��� XY ��������.

		move.b	obStatus(a0),d0										; �������� ������ ���� ����������� ������� ������ � d0.
		bchg	#0,d0											; �������� ����(���) ����������� �������.
		bne.s	+
		neg.w	obVelX(a1)										; ������������� �������� �� X.

+		move.b	d0,obStatus(a1)										; ���������� ����(���) ����������� �������.
		andi.b	#1,obStatus(a1)										; ���������� ����(���) ����������� ������� �� �������������� �� �����������.
		or.b	#$80,obRender(a1)

		tst.b	GravityAngle.w										; NAT: Check if reverse gravity is active
		bpl.s	+											; if not, skip
		neg.w	obVelY(a1)										; negate y-velocity

+		tst.l	(a2)+											; ��������� �����������.
		bpl.s	+
		bchg	#0,obStatus(a1)										; �������� ����(���) ����������� �������.

+		move.b	#5,obAnim(a1)										; ���������� ��������.
		move.w	#6*$80,obPriority(a1)									; ���������� ���������.
		bset	#2,obRender(a1)										; ���������� ���� ��������� ������.
		dbf	d1,-											; ��������� ���� ��� ������� �� ����� ���������.

Obj_SBC_Ret:
		movem.l	(sp)+,d0-d2/a0-a2
		rts
; ---------------------------------------------------------------------------

BloodCreate_Data2:
		dc.w ((BloodCreate_Data2_End-BloodCreate_Data2)/4)-1	; ������� �������� �������.
; �����
		dc.w $50, -$500		; X ��������, Y ��������.
; �����
		dc.w $100, -$500		; X ��������, Y ��������.
; �����
		dc.w $150, -$550		; X ��������, Y ��������.
; �����
		dc.w $200, -$600		; X ��������, Y ��������.
; �����
		dc.w $300, -$600		; X ��������, Y ��������.
; �����
		dc.w $100, -$600		; X ��������, Y ��������.
; �����
		dc.w $100, -$700		; X ��������, Y ��������.
; �����
		dc.w $150, -$800		; X ��������, Y ��������.
; �����
		dc.w $200, -$800		; X ��������, Y ��������.
; �����
		dc.w $300, -$800		; X ��������, Y ��������.
; �����
		dc.w $100, -$900		; X ��������, Y ��������.
; �����
		dc.w $300, -$900		; X ��������, Y ��������.
; �����
		dc.w $200, -$900		; X ��������, Y ��������.
; �����
		dc.w -$150, -$550		; X ��������, Y ��������.
; �����
		dc.w -$200, -$600	; X ��������, Y ��������.
; �����
		dc.w -$100, -$700		; X ��������, Y ��������.
; �����
		dc.w -$150, -$800		; X ��������, Y ��������.
BloodCreate_Data2_End

BloodCreate_Data3:
		dc.w ((BloodCreate_Data3_End-BloodCreate_Data3)/4)-1	; ������� �������� �������.
; �����
		dc.w $150, -$550		; X ��������, Y ��������.
; �����
		dc.w $100, -$6A0		; X ��������, Y ��������.
; �����
		dc.w -$100, -$6B0		; X ��������, Y ��������.
; �����
		dc.w -$150, -$550		; X ��������, Y ��������.
BloodCreate_Data3_End
; ---------------------------------------------------------------------------
; ������������� ��� ��� �������� ��������(�����, �����, �����, ������, ����).
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BloodShow:
.checkfloor
		pea	Sprite_CheckDeleteXY_NoDraw		             	; check if object is still visible

		jsr	SpeedToPos						; update speed
		bclr	#2,obStatus(a1)						; don't flip
		tst.b	GravityAngle.w						; NAT: Check if reverse gravity is active
		bpl.s	.norev							; if not, skip

		bset	#2,obStatus(a1)						; flip vertically
		sub.w	#$38,obVelY(a0)						; apply gravity, and, check if the object is moving upwards
		bpl.s	.display						; if not, skip

		moveq	#$C,d5							; check the top solid bit instead
		jsr	ObjCheckCeilingDist_Rev					; check the ceiling distance... Which is actually floor. Logic!
		tst.w	d1							; check result
		bpl.s	.display						; if no collision occurred, branch
		neg.w	d1							; negate offset
		bra.s	.floor

.norev
		add.w	#$38,obVelY(a0)						; apply gravity, and check if the object is moving downwards
		bmi.s	.display						; if not, skip
		jsr	ObjCheckFloorDist					; check for collision with floor
		tst.w	d1							; check result
		bpl.s	.display						; if no collision occurred, branch

.floor
		add.w	d1,obY(a0)						; align with floor
		move.l	#.checkfall,(a0)					; go to new routine
		bra.s	.display

.grav
		jsr	SpeedToPos						; update speed
		moveq	#$38,d0							; prepare gravity
	;	bclr	#2,obStatus(a1)						; dont flip

		tst.b	GravityAngle.w						; NAT: Check if reverse gravity is active
		bpl.s	.gotgrav						; if not, skip
		moveq	#-$38,d0						; negative gravity
	;	bset	#2,obStatus(a1)						; flip vertically

.gotgrav
		add.w	d0,obVelY(a0)						; apply gravity, and, check if the object is moving upwards

.display
		lea	Ani_Flesh(pc),a1					; animate object
		jsr	Animate_Sprite

		move.b	Level_frame_counter+1.w,d0
		add.b	d7,d0						; d7 - object count (Process_Sprites)
		andi.b	#1,d0						; render sprite only every other frame
		bne.s	.rts							; branch if we won't render this frame

		jmp	Draw_Sprite						; render

.rts
		rts
; ---------------------------------------------------------------------------

.checkfall
		pea	Sprite_CheckDeleteXY_NoDraw				; check if object is still visible

		move.w	obVelY(a0),d0
		tst.b	GravityAngle.w						; NAT: Check if reverse gravity is active
		bpl.s	.rev							; if yes, branch

		cmpi.w	#-$180,d0						; check for specific speed
		bhs.s	.delete							; if the speed is lower, delete object
		bra.s	.setvel

.rev
		cmpi.w	#$180,d0						; check for specific speed
		blo.s		.delete						; if the speed is higher, delete object

.setvel
		asr.w	d0							; halve speed
		neg.w	d0							; negate speed
		move.w	d0,obVelY(a0)						; save as the current y-velocity
		move.l	#.checkfloor,(a0)					; go back to the previous routine
		bra.s	.display
; ---------------------------------------------------------------------------

.checkremove
		pea	Sprite_CheckDeleteXY_NoDraw				; check if object is still visible
		bra.s	.grav

.delete
		move.l	#Delete_Current_Sprite,(a0)				; delete object
		rts

; =============== S U B R O U T I N E =======================================

Ani_Flesh:		include "Objects/Blood Mode/Object data/Anim - Flesh.asm"
	even
Map_Flesh:		binclude "Objects/Blood Mode/Object data/Map - Flesh.bin"
	even
