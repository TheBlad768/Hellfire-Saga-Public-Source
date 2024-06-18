; ===========================================================================
; Uncompressed graphics
; ===========================================================================

ArtUnc_Ring:			binclude "Objects/Rings/Uncompressed Art/Rings.bin"
ArtUnc_Ring_End
	even
ArtUnc_RingTrans:		binclude "Objects/Rings/Uncompressed Art/RingsTrans.bin"
ArtUnc_RingTrans_End
	even
ArtUnc_Hud:				binclude "Objects/HUD/Uncompressed Art/HUD Numbers.bin"
	even
ArtUnc_HudRings:		binclude "Objects/HUD/Uncompressed Art/HUD Rings.bin"
	even
ArtUnc_EndSigns:		binclude "Objects/Signpost/Uncompressed Art/End Signs.bin"
	even
MapUnc_DialogWindow:	binclude "Objects/Dialog/Object data/Map - Dialog Windows.bin"
	even
ArtUnc_ResultsNumbers:	binclude "Data/Screens/Results/Uncompressed Art/Numbers.bin"
	even
ArtUnc_ResultsRank:		binclude "Data/Screens/Results/Uncompressed Art/Rank.bin"
	even
ArtUnc_TitleLogo:		binclude "Data/Screens/Title/Uncompressed Art/Art - Logo.bin"
ArtUnc_TitleLogo_End
	even
ArtUnc_Pause:		binclude "Objects/HUD/Uncompressed Art/Pause Art.unc"
ArtUnc_Pause_End:		even
ArtUnc_YouDied:		binclude "Objects/HUD/Uncompressed Art/You Died Art.unc"
ArtUnc_YouDied_End:		even


;		align $8000

ArtUnc_Gloamglozer:		binclude "Objects/Bosses/Gloamglozer/Uncompressed Art/Gloamglozer.bin"
	even
ArtUnc_DeathIntro:		binclude "Objects/Bosses/Gloamglozer/Uncompressed Art/Death.bin"
	even
ArtUnc_Shaft:			binclude "Objects/Bosses/Shaft/Uncompressed Art/Shaft.bin"
	even
ArtUnc_DPShaft:			binclude "Objects/Bosses/Dark Priest Shaft/Uncompressed Art/shaft.bin"
	even
ArtUnc_DPShaft_Sphere:	binclude "Objects/Bosses/Dark Priest Shaft/Uncompressed Art/sphere.bin"
	even
ArtUnc_OrbinautArmor:	binclude "Objects/Orbinaut Armor/Uncompressed Art/orbinautarmor.bin"
	even
ArtUnc_Arthur:			binclude "Objects/Bosses/Arthur/Uncompressed Art/arthur.bin"
	even
ArtUnc_Death:			binclude "Objects/Bosses/Death X/Uncompressed Art/Death.bin"
	even
ArtUnc_Firebrand:		binclude "Objects/Bosses/Firebrand/Uncompressed Art/Firebrand.bin"
	even
ArtUnc_FireHead:			binclude "Objects/Bosses/Fire Head/Uncompressed Art/Head.bin"
ArtUnc_FireHead_End
	even
ArtUnc_FireBall:			binclude "Objects/Bosses/Fire Head/Uncompressed Art/Ball.bin"
ArtUnc_FireBall_End
	even
ArtUnc_BossAim:			binclude "Objects/Bosses/Aim/Uncompressed Art/Aim.bin"
ArtUnc_BossAim_End:		even
ArtUnc_ArcherArmor:		binclude "Objects/Archer Armor/Kosinski-M Art/archerarmor.unc"
	even
ArtUnc_WalkArmor:		binclude "Objects/Walking Armor/Kosinski-M Art/walkarmor.unc"
	even
ArtUnc_PhantomHand:	binclude "Objects/Phantom Hand/Uncompressed art/phantomhand.bin"
	even
ArtUnc_Skeleton:		binclude "Objects/Skeleton/Uncompressed art/skeleton.bin"
	even
ArtUnc_Ghoul:		binclude "Objects/Ghoul/Uncompressed art/Ghoul.bin"
	even
ArtUnc_MechaSonic:              binclude "Objects/Bosses/Mecha Sonic/Uncompressed Art/MechaSonic.bin"
        even
ArtUnc_Pentagram:		binclude "Levels\DDZ\Code\Data\Intro\Line Maker\Line Art.bin"
	even

MapUnc_BossGrimReaper:		binclude "Objects/Bosses/Grim Reaper/Object Data/Map - BossGrimReaper.bin"
	even
ArtUnc_BossGrimReaperRings:	binclude "Objects/Bosses/Grim Reaper/Uncompressed Art/Rings.bin"
	even
MapUnc_BossTwoFaces:		binclude "Objects/Bosses/TwoFaces/Object Data/Map - BossTwoFaces.bin"
	even

		align $8000		; fixes glitched DDZ intro art

ArtUnc_EggmanIntro:		binclude "Levels\DDZ\Code\Data\Intro\Eggman\Art.bin"
	even

; ===========================================================================
; Animated uncompressed graphics for MGZ
; ===========================================================================

;		align $8000

ArtUnc_AniSCZ_Block:	binclude "Levels/SCZ/Animated Tiles/Block.bin"
	even
ArtUnc_AniSCZ_Line1:	binclude "Levels/SCZ/Animated Tiles/Line1.bin"
	even
ArtUnc_AniSCZ_Line2:	binclude "Levels/SCZ/Animated Tiles/Line2.bin"
	even
ArtUnc_AniSCZ_Penta:	binclude "Levels/SCZ/Animated Tiles/Penta.bin"
	even
ArtUnc_AniSCZ_Panel:	binclude "Levels/SCZ/Animated Tiles/Panel.bin"
	even
ArtUnc_AniGMZ__1:		binclude "Levels/GMZ/Animated Tiles/1.bin"
	even
ArtUnc_AniGMZ__2:		binclude "Levels/GMZ/Animated Tiles/2.bin"
	even
ArtUnc_AniGMZ__3:		binclude "Levels/GMZ/Animated Tiles/3.bin"
	even
ArtUnc_GMZ_TopLayer:	binclude "Levels/GMZ/Animated Tiles/Top Layer.unc"
	even
ArtUnc_GMZ_BotLayer:	binclude "Levels/GMZ/Animated Tiles/Bottom Layer.unc"
	even
