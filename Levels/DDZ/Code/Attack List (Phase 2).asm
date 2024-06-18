; ===========================================================================
; ---------------------------------------------------------------------------
; Main attack list order
; ---------------------------------------------------------------------------

DEE_AttackDiff:	dc.l	DEE_ListEasy		; easy
		dc.l	DEE_ListNormal		; normal
		dc.l	DEE_ListHard		; hard
		dc.l	DEE_ListManiac		; maniac

; ---------------------------------------------------------------------------
; Easy mode
; ---------------------------------------------------------------------------

	; --- Order list ---
	; Each dc.l is a pointer to a pattern list the
	; last dc.w $FFFF is to mark the end of the boss
	; ---------------------

DEE_ListEasy:	dc.l	DEE_Easy1		; first pattern
		dc.l	DEE_Easy2		; second pattern
		dc.l	DEE_Easy3		; second pattern
		dc.l	DEE_Easy4		; second pattern
		dc.w	$FFFF			; end of list

	; --- Pattern lists -----------------------------------
	; Each list starts with two long-words:
	;
	;	dc.l	$PPPPPPPP, $SSSSSSSS
	;
	; P = Scale position to move back to before starting the pattern
	; S = Speed to move in (scale in) slowly while perfomring the pattern
	; Think of these as 16-bit fixed point math; $QQQQFFFF
	; Where Q is the quotient, and F is the fraction.
	;
	; The rest of the dc list is the attacks in order
	;
	;	dc.l	Main Attack,    Additional Attack
	;
	; Each entry can perform two attacks at once, if you want
	; to perform only one attack, keep the Additional Attack as 0
	;
	; The last dc.w $FFFF is to mark the end of the pattern, and the boss will
	; start doing the slash attack.
	;
	; If you only want the slash attack to occur in the entire pattern list
	; then ensure P and S are both completely 0, and just end with a dc.w $FFFF
	; the engine will handle the rest, for example:
	;
	;	dc.l	$00000000, $00000000
	;	dc.w	$FFFF
	;
	; It's recommended to not have P any larger than $00020000.  You are more
	; than welcome to scale back further, but the missiles, arms, and energy
	; balls won't scale back further than that.
	; -----------------------------------------------------

DEE_Easy1:	dc.l	$00000000, $00000000
		dc.w	$FFFF

DEE_Easy2:	dc.l	$00020000, $00000040
		dc.l	DEE_BallAttack,		0
		dc.l	DEE_BallAttack,		0
		dc.l	DEE_ArmAttack,		0
		dc.w	$FFFF

DEE_Easy3:	dc.l	$00020000, $00000040
		dc.l	DEE_MissileAttack,	0
		dc.l	DEE_BallAttack,		0
		dc.l	DEE_MissileAttack,	0
		dc.w	$FFFF

DEE_Easy4:	dc.l	$00020000, $00000030
		dc.l	DEE_BallAttack,		0
		dc.l	DEE_BallAttack,		DEE_ArmAttack
		dc.l	DEE_ArmAttack,		0
		dc.l	DEE_MissileAttack,	0
		dc.w	$FFFF

; ---------------------------------------------------------------------------
; Normal mode
; ---------------------------------------------------------------------------

	; --- Order list ---

DEE_ListNormal:
		dc.l	DEE_Normal1
		dc.l	DEE_Normal2
		dc.l	DEE_Normal3
		dc.l	DEE_Normal4
		dc.w	$FFFF

	; --- Pattern lists ---

DEE_Normal1:	dc.l	$00000000, $00000000
		dc.w	$FFFF

DEE_Normal2:	dc.l	$00020000, $00000040
		dc.l	DEE_BallAttack,		0
		dc.l	DEE_ArmAttack,		0
		dc.l	DEE_MissileAttack,	0
		dc.w	$FFFF

DEE_Normal3:	dc.l	$00020000, $00000040
		dc.l	DEE_BallAttack,		DEE_MissileAttack
		dc.l	DEE_BallAttack,		DEE_ArmAttack
		dc.l	DEE_MissileAttack,	0
		dc.w	$FFFF

DEE_Normal4:	dc.l	$00020000, $00000030
		dc.l	DEE_BallAttack,		DEE_MissileAttack
		dc.l	DEE_ArmAttack,		DEE_MissileAttack
		dc.l	DEE_MissileAttack,	0
		dc.l	DEE_ArmAttack,		DEE_MissileAttack
		dc.w	$FFFF

; ---------------------------------------------------------------------------
; Hard mode
; ---------------------------------------------------------------------------

DEE_ListHard:	dc.l	DEE_Hard1
		dc.l	DEE_Hard2
		dc.l	DEE_Hard3
		dc.l	DEE_Hard4
		dc.w	$FFFF

	; --- Pattern lists ---

DEE_Hard1:	dc.l	$00000000, $00000000
		dc.w	$FFFF

DEE_Hard2:	dc.l	$00020000, $00000040
		dc.l	DEE_BallAttack,		0
		dc.l	DEE_ArmAttack,		DEE_BallAttack
		dc.l	DEE_MissileAttack,	DEE_ArmAttack
		dc.w	$FFFF

DEE_Hard3:	dc.l	$00020000, $00000040
		dc.l	DEE_BallAttack,		DEE_ArmAttack
		dc.l	DEE_ArmAttack,		0
		dc.l	DEE_ArmAttack,		DEE_MissileAttack
		dc.w	$FFFF

DEE_Hard4:	dc.l	$00020000, $00000030
		dc.l	DEE_BallAttack,		DEE_ArmAttack
		dc.l	DEE_MissileAttack,	DEE_BallAttack
		dc.l	DEE_BallAttack,		DEE_ArmAttack
		dc.l	DEE_MissileAttack,	0
		dc.w	$FFFF

; ---------------------------------------------------------------------------
; Maniac mode
; ---------------------------------------------------------------------------

DEE_ListManiac:	dc.l	DEE_Maniac1
		dc.l	DEE_Maniac2
		dc.l	DEE_Maniac3
		dc.l	DEE_Maniac4
		dc.w	$FFFF

	; --- Pattern lists ---

DEE_Maniac1:	dc.l	$00000000, $00000000
		dc.w	$FFFF

DEE_Maniac2:	dc.l	$00020000, $00000040
		dc.l	DEE_BallAttack,		0
		dc.l	DEE_ArmAttack,		DEE_BallAttack
		dc.l	DEE_MissileAttack,	DEE_ArmAttack
		dc.w	$FFFF

DEE_Maniac3:	dc.l	$00020000, $00000040
		dc.l	DEE_BallAttack,		DEE_ArmAttack
		dc.l	DEE_ArmAttack,		0
		dc.l	DEE_ArmAttack,		DEE_MissileAttack
		dc.w	$FFFF

DEE_Maniac4:	dc.l	$00020000, $00000030
		dc.l	DEE_BallAttack,		DEE_ArmAttack
		dc.l	DEE_MissileAttack,	DEE_BallAttack
		dc.l	DEE_BallAttack,		DEE_ArmAttack
		dc.l	DEE_MissileAttack,	0
		dc.w	$FFFF

; ===========================================================================