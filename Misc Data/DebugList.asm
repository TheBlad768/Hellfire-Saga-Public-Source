; ===========================================================================
; Debug mode item lists
; ===========================================================================

DebugList: offsetTable
	offsetTableEntry.w .SCZ1
        offsetTableEntry.w .SCZ1
	offsetTableEntry.w .SCZ1
        offsetTableEntry.w .SCZ1

	offsetTableEntry.w .SCZ1
        offsetTableEntry.w .SCZ1
	offsetTableEntry.w .SCZ1
        offsetTableEntry.w .SCZ1

	offsetTableEntry.w .MGZ1
        offsetTableEntry.w .MGZ1
	offsetTableEntry.w .MGZ1
        offsetTableEntry.w .MGZ1

	offsetTableEntry.w .SCZ1
        offsetTableEntry.w .SCZ1
	offsetTableEntry.w .SCZ1
        offsetTableEntry.w .SCZ1

	offsetTableEntry.w .SCZ1
        offsetTableEntry.w .SCZ1
	offsetTableEntry.w .SCZ1
        offsetTableEntry.w .SCZ1
; ---------------------------------------------------------------------------

			; Object Mappings Subtype Frame Arttile
.SCZ1: dbglistheader                               ;6 is chains amount 2 is monitor type ,the other 2 is mapping frame


	dbglistobj Obj_Ring, Map_Ring, 0, 0, make_art_tile(ArtTile_Ring,0,1)
	dbglistobj Obj_Monitor, Map_Monitor, 1, 3, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 2, 4, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 3, 5, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 4, 6, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 5, 7, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 6, 8, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 7, 9, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 8, $A, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 9, 0, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_PathSwap, Map_PathSwap, 9, 1, make_art_tile(ArtTile_Ring,0,0)
	dbglistobj Obj_PathSwap, Map_PathSwap, $D, 5, make_art_tile(ArtTile_Ring,0,0)
	dbglistobj Obj_Spring, Map_Spring, $81, 0, make_art_tile($500,0,0)
	dbglistobj Obj_Spring, Map_Spring2, $82, 0, make_art_tile($500,0,0)
	dbglistobj Obj_Spring, Map_Spring, $90, 3, make_art_tile($50C,0,0)
	dbglistobj Obj_Spring, Map_Spring2, $92, 3, make_art_tile($50C,0,0)
	dbglistobj Obj_Spring, Map_Spring, $A0, 6, make_art_tile($500,0,0)
	dbglistobj Obj_Spring, Map_Spring2, $A2, 6, make_art_tile($500,0,0)
	dbglistobj Obj_Spikes, Map_Spikes, 0, 0, make_art_tile($4F8,0,0)
	dbglistobj Obj_Spikes, Map_Spikes, $40, 4, make_art_tile($4F0,0,0)
	dbglistobj Obj_StarPost, Map_StarPost, 1, 0, make_art_tile($5EC,0,0)
.SCZ1_End:
 .MGZ1:  dbglistheader
        dbglistobj Obj_Ring, Map_Ring, 0, 0, make_art_tile(ArtTile_Ring,0,1)
	dbglistobj Obj_Monitor, Map_Monitor, 1, 3, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 2, 4, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 3, 5, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 4, 6, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 5, 7, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 6, 8, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 7, 9, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 8, $A, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_Monitor, Map_Monitor, 9, 0, make_art_tile(ArtTile_Powerups,0,0)
	dbglistobj Obj_PathSwap, Map_PathSwap, 9, 1, make_art_tile(ArtTile_Ring,0,0)
	dbglistobj Obj_PathSwap, Map_PathSwap, $D, 5, make_art_tile(ArtTile_Ring,0,0)
	dbglistobj Obj_Spring, Map_Spring, $81, 0, make_art_tile($500,0,0)
	dbglistobj Obj_Spring, Map_Spring2, $82, 0, make_art_tile($500,0,0)
	dbglistobj Obj_Spring, Map_Spring, $90, 3, make_art_tile($50C,0,0)
	dbglistobj Obj_Spring, Map_Spring2, $92, 3, make_art_tile($50C,0,0)
	dbglistobj Obj_Spring, Map_Spring, $A0, 6, make_art_tile($500,0,0)
	dbglistobj Obj_Spring, Map_Spring2, $A2, 6, make_art_tile($500,0,0)
	dbglistobj Obj_Spikes, Map_Spikes, 0, 0, make_art_tile($4F8,0,0)
	dbglistobj Obj_Spikes, Map_Spikes, $40, 4, make_art_tile($4F0,0,0)
	dbglistobj Obj_StarPost, Map_StarPost, 1, 0, make_art_tile($5EC,0,0)
	; addr,map,(subtype = link,Monitortype),frame,art_tile
        dbglistobj MGZSwingingBall2, Map_FGPlant, $61, 2, $C000
        dbglistobj MGZSwingingBall2, Map_FGPlant, $62, 2, $C000
        dbglistobj MGZSwingingBall2, Map_FGPlant, $63, 2, $C000
        dbglistobj MGZSwingingBall2, Map_FGPlant, $64, 2, $C000
        dbglistobj MGZSwingingBall2, Map_FGPlant, $65, 2, $C000
        dbglistobj MGZSwingingBall2, Map_FGPlant, $66, 2, $C000
        dbglistobj MGZSwingingBall2, Map_FGPlant, $67, 2, $C000
        dbglistobj MGZSwingingBall2, Map_FGPlant, $68, 2, $C000
        dbglistobj MGZSwingingBall2, Map_FGPlant, $69, 2, $C000
 .MGZ1_End:
	even