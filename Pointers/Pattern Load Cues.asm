; ===========================================================================
; Pattern load cues
; ===========================================================================

Offs_PLC: offsetTable
		offsetTableEntry.w PLC1_FDZ1_Misc
		offsetTableEntry.w PLC2_FDZ1_Enemy
		offsetTableEntry.w PLC1_FDZ2_Misc
		offsetTableEntry.w PLC2_FDZ2_Enemy
		offsetTableEntry.w PLC1_FDZ3_Misc
		offsetTableEntry.w PLC2_FDZ3_Enemy
		offsetTableEntry.w PLC1_FDZ1_Misc
		offsetTableEntry.w PLC2_GMZ4_Enemy

		offsetTableEntry.w PLC1_SCZ1_Misc
		offsetTableEntry.w PLC2_SCZ1_Enemy
		offsetTableEntry.w PLC1_SCZ2_Misc
		offsetTableEntry.w PLC2_SCZ2_Enemy
		offsetTableEntry.w PLC1_SCZ3_Misc
		offsetTableEntry.w PLC2_SCZ3_Enemy
		offsetTableEntry.w PLC1_SCZ4_Misc
		offsetTableEntry.w PLC2_SCZ4_Enemy

		offsetTableEntry.w PLC1_GMZ1_Misc
		offsetTableEntry.w PLC2_GMZ1_Enemy
		offsetTableEntry.w PLC1_GMZ2_Misc
		offsetTableEntry.w PLC2_GMZ2_Enemy
		offsetTableEntry.w PLC1_GMZ3_Misc
		offsetTableEntry.w PLC2_GMZ3_Enemy
		offsetTableEntry.w PLC1_GMZ4_Misc
		offsetTableEntry.w PLC2_GMZ4_Enemy

		offsetTableEntry.w PLC1_DDZ_Misc
		offsetTableEntry.w PLC2_DDZ_Enemy
		offsetTableEntry.w PLC1_DDZ_Misc
		offsetTableEntry.w PLC2_DDZ_Enemy
		offsetTableEntry.w PLC1_DDZ_Misc
		offsetTableEntry.w PLC2_DDZ_Enemy
		offsetTableEntry.w PLC1_DDZ_Misc
		offsetTableEntry.w PLC2_DDZ_Enemy

		offsetTableEntry.w PLC1_CRE_Misc
		offsetTableEntry.w PLC2_CRE_Enemy

; ===========================================================================
; Pattern load cues - Main 1
; ===========================================================================

PLC_Main: plrlistheader
		plreq $5EC, ArtKosM_Lamp						; lamppost
		plreq ArtTile_Ring_Sparks, ArtKosM_Ring			; rings
		plreq $6B4, ArtKosM_Hud		; $6C2					; HUD

	if GameDebug=1
		plreq $6EF, ArtKosM_DebugText					; Debug text
	endif

PLC_Main_End

; ===========================================================================
; Pattern load cues - Main 2
; ===========================================================================

PLC_Main2: plrlistheader
		plreq $4F0, ArtKosM_SpikesSprings					; spikes and normal spring
		plreq ArtTile_Powerups, ArtKosM_Monitors			; monitors
		plreq $558,  ArtKosM_Flesh						; blood
		plreq $5A8, ArtKosM_Explosion						; explosion
		plreq $7C0, ArtKosM_Blood						; blood explosion
PLC_Main2_End

; ===========================================================================
; Pattern load cues - Main (SCZ)
; ===========================================================================

PLC_MainSCZ: plrlistheader
		plreq $4F0, ArtKosM_SpikesSpringsBlood			; spikes and normal spring
		plreq ArtTile_Powerups, ArtKosM_Monitors			; monitors
		plreq $558,  ArtKosM_Flesh						; blood
		plreq $5A8, ArtKosM_Explosion						; explosion
		plreq $7C0, ArtKosM_Blood						; blood explosion
PLC_MainSCZ_End

; ===========================================================================
; Pattern load cues - Main (SCZ3)
; ===========================================================================

PLC_MainSCZ3: plrlistheader
		plreq $4F0, ArtKosM_SpikesSpringsBlood			; spikes and normal spring
		plreq ArtTile_Powerups, ArtKosM_Monitors			; monitors
		plreq $558,  ArtKosM_Flesh						; blood
		plreq $59C, ArtKosM_DEZExplosion					; explosion
		plreq $7C0, ArtKosM_Blood						; blood explosion
PLC_MainSCZ3_End

; ===========================================================================
; Pattern load cues - Main Extra
; ===========================================================================

PLC_Main7: plrlistheader
		plreq $5EC, ArtKosM_Lamp						; lamppost

	if GameDebug=1
		plreq $6EF, ArtKosM_DebugText					; Debug text
	endif

PLC_Main7_End

; ===========================================================================
; Pattern load cues - Forest Decay 1 (Misc)
; ===========================================================================

PLC1_FDZ1_Misc: plrlistheader
		plreq $2D0,  ArtKosM_FDZFan
		plreq $404,  ArtKosM_FDZShooter
		plreq $41D,	 ArtKosM_CollapsingStaircase
		plreq $42D,	 ArtKosM_SwingingPlatform
		plreq $4CA,  ArtKosM_MSkull
PLC1_FDZ1_Misc_End

; ===========================================================================
; Pattern load cues - Forest Decay 1 (Enemy)
; ===========================================================================

PLC2_FDZ1_Enemy: plrlistheader
		plreq $370,  ArtKosM_Fly
		plreq $39B,  ArtKosM_Wolf
		;plreq $412,  ArtKosM_Crow
		plreq $450,  ArtKosM_Grounder
		plreq $596,  ArtKosM_Secrets
PLC2_FDZ1_Enemy_End

; ===========================================================================
; Pattern load cues - Forest Decay 2 (Misc)
; ===========================================================================

PLC1_FDZ2_Misc: plrlistheader
		plreq $2D0,  ArtKosM_FDZFan
		plreq $404,  ArtKosM_FDZShooter
		plreq $41D,	 ArtKosM_CollapsingStaircase
		plreq $42D,	 ArtKosM_SwingingPlatform
		plreq $4CA,  ArtKosM_MSkull
PLC1_FDZ2_Misc_End

; ===========================================================================
; Pattern load cues - Forest Decay 2 (Enemy)
; ===========================================================================

PLC2_FDZ2_Enemy: plrlistheader
		plreq $39B,  ArtKosM_Wolf
		plreq $3E8,  ArtKosM_Fly
		plreq $32D,  ArtKosM_Phantom
		plreq $4AC,  ArtKosM_Bat
		plreq $596,  ArtKosM_Secrets
PLC2_FDZ2_Enemy_End

; ===========================================================================
; Pattern load cues - Forest Decay 3 (Misc)
; ===========================================================================

PLC1_FDZ3_Misc: plrlistheader
		plreq $404,  ArtKosM_FDZShooter
		plreq $41D,	 ArtKosM_CollapsingStaircase
		plreq $42D,	 ArtKosM_SwingingPlatform
		plreq $4E0,  ArtKosM_FDZ3Rain
		plreq $4CA,  ArtKosM_MSkull
PLC1_FDZ3_Misc_End

; ===========================================================================
; Pattern load cues - Forest Decay 3 (Enemy)
; ===========================================================================

PLC2_FDZ3_Enemy: plrlistheader
		plreq $2EA,  ArtKosM_Wolf
		plreq $337,  ArtKosM_AxeGhost
		plreq $38B,  ArtKosM_Feal
		plreq $462,  ArtKosM_Phantom
		plreq $3C0,  ArtKosM_Crow
		plreq $43E,  ArtKosM_Bat
		plreq $596,  ArtKosM_Secrets
PLC2_FDZ3_Enemy_End

; ===========================================================================
; Pattern load cues - Sin City 1 (Misc)
; ===========================================================================

PLC1_SCZ1_Misc: plrlistheader
		plreq $400, ArtKosM_Staircase
		plreq $410, ArtKosM_Bumper
		plreq $420, ArtKosM_ChainLink
		plreq $3B0, ArtKosM_HandLauncher
		plreq $3E0, ArtKosM_Bubbles
		plreq $4E0, ArtKosM_WaterWave		; water wave
PLC1_SCZ1_Misc_End

; ===========================================================================
; Pattern load cues - Sin City 1 (Enemy)
; ===========================================================================

PLC2_SCZ1_Enemy: plrlistheader
                 plreq $2B0,  ArtKosM_RedGuardian
                 plreq $2FD,  ArtKosM_KillerFish
                 plreq $375,  ArtKosM_Hellgirl
		plreq $596,  ArtKosM_Secrets
PLC2_SCZ1_Enemy_End

; ===========================================================================
; Pattern load cues - Sin City 2 (Misc)
; ===========================================================================

PLC1_SCZ2_Misc: plrlistheader
		plreq $400, ArtKosM_Staircase
		plreq $410, ArtKosM_Bumper
		plreq $420, ArtKosM_ChainLink
		plreq $340, ArtKosM_WaterTrigger
		plreq $3B0, ArtKosM_HandLauncher
		plreq $3E0, ArtKosM_Bubbles
		plreq $4E0, ArtKosM_WaterWave		; water wave
PLC1_SCZ2_Misc_End

; ===========================================================================
; Pattern load cues - Sin City 2 (Enemy)
; ===========================================================================

PLC2_SCZ2_Enemy: plrlistheader
                plreq $2B0,  ArtKosM_RedGuardian
                plreq $2FD,  ArtKosM_KillerFish
                plreq $375,  ArtKosM_Hellgirl
		plreq $596,  ArtKosM_Secrets
PLC2_SCZ2_Enemy_End

; ===========================================================================
; Pattern load cues - Sin City 3 (Misc)
; ===========================================================================

PLC1_SCZ3_Misc: plrlistheader
		plreq $3E0, ArtKosM_Bubbles
		plreq $4E0, ArtKosM_WaterWave		; water wave
PLC1_SCZ3_Misc_End

; ===========================================================================
; Pattern load cues - Sin City 3 (Enemy)
; ===========================================================================

PLC2_SCZ3_Enemy: plrlistheader
		plreq $323, ArtKosM_BossGrimReaperBoat			; boat (misc)
		plreq $3B0, ArtKosM_HandLauncher
PLC2_SCZ3_Enemy_End

; ===========================================================================
; Pattern load cues - Sin City 4 (Misc)
; ===========================================================================

PLC1_SCZ4_Misc: plrlistheader
PLC1_SCZ4_Misc_End

; ===========================================================================
; Pattern load cues - SCZ4 (Enemy)
; ===========================================================================

PLC2_SCZ4_Enemy: plrlistheader
PLC2_SCZ4_Enemy_End

; ===========================================================================
; Pattern load cues - Glance of malice (Misc)
; ===========================================================================

PLC1_GMZ1_Misc: plrlistheader
		plreq $350, ArtKosM_MGZSwingingSpikeBall
		plreq $35C, ArtKosM_MGZFireballLauncher
		plreq $388, ArtKosM_MGZNut
		plreq $3CF, ArtKosM_MGZLavaFall
PLC1_GMZ1_Misc_End

; ===========================================================================
; Pattern load cues - Glance of malice (Enemy)
; ===========================================================================

PLC2_GMZ1_Enemy: plrlistheader
		plreq $3A0,  ArtKosM_MSkull
		plreq $69D,  ArtKosM_GMZ1Embers		; $6E0
		plreq $596,  ArtKosM_Secrets
PLC2_GMZ1_Enemy_End

; ===========================================================================
; Pattern load cues - Glance of malice (Misc)
; ===========================================================================

PLC1_GMZ2_Misc: plrlistheader
		plreq $310, ArtKosM_MGZFlamethrower
		plreq $350, ArtKosM_MGZSwingingSpikeBall
		plreq $35C, ArtKosM_MGZFireballLauncher
		plreq $388, ArtKosM_MGZNut
		plreq $3B0,  ArtKosM_GravitySwitch
		plreq $69D,  ArtKosM_GMZ1Embers		; $6E0
PLC1_GMZ2_Misc_End

; ===========================================================================
; Pattern load cues - Glance of malice (Enemy)
; ===========================================================================

PLC2_GMZ2_Enemy: plrlistheader
		plreq $3D0,  ArtKosM_OrbiBall
		plreq $4CA,  ArtKosM_MSkull
		plreq $596,  ArtKosM_Secrets
PLC2_GMZ2_Enemy_End

; ===========================================================================
; Pattern load cues - Glance of malice (Misc)
; ===========================================================================

PLC1_GMZ3_Misc: plrlistheader
		plreq $69D,  ArtKosM_GMZ1Embers		; $6E0
PLC1_GMZ3_Misc_End

; ===========================================================================
; Pattern load cues - Glance of malice (Enemy)
; ===========================================================================

PLC2_GMZ3_Enemy: plrlistheader
PLC2_GMZ3_Enemy_End

; ===========================================================================
; Pattern load cues - Glance of malice (Misc)
; ===========================================================================

PLC1_GMZ4_Misc: plrlistheader
		plreq $69D,  ArtKosM_GMZ1Embers		; $6E0
PLC1_GMZ4_Misc_End

; ===========================================================================
; Pattern load cues - Glance of malice (Enemy)
; ===========================================================================

PLC2_GMZ4_Enemy: plrlistheader
PLC2_GMZ4_Enemy_End

; ===========================================================================
; Pattern load cues - Devil's Descent (Misc)
; ===========================================================================

PLC1_DDZ_Misc: plrlistheader
		plreq (VDD_CandleArt/$20), ArtKosM_Candles
		plreq (VDD_WormBodyArt/$20), ArtKosM_WormBody
PLC1_DDZ_Misc_End

; ===========================================================================
; Pattern load cues - Devil's Descent (Enemy)
; ===========================================================================

PLC2_DDZ_Enemy: plrlistheader
PLC2_DDZ_Enemy_End

; ===========================================================================
; Pattern load cues - Credits (Misc)
; ===========================================================================

PLC1_CRE_Misc: plrlistheader
		plreq (VRAM_CreditsArt/$20), CRE_8x8_KosM_B
		plreq (VRAM_CreditsMiso/$20), ArtKosM_MisoSmallLogo
		plreq (VRAM_CreditsText/$20), ArtKosM_CreditsText
		plreq (VRAM_CreditsClouds/$20), ArtKosM_CreditsClouds
PLC1_CRE_Misc_End

; ===========================================================================
; Pattern load cues - Credits (Enemy)
; ===========================================================================

PLC2_CRE_Enemy: plrlistheader
		plreq ArtTile_Powerups+$18, ArtKosM_MonCredits			; monitor credit icons
		plreq (VRAM_CreditsFeal/$20), ArtKosM_Feal
PLC2_CRE_Enemy_End
