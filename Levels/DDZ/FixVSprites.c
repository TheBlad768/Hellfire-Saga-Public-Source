// =============================================================================
// -----------------------------------------------------------------------------
// Sprite Maker
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include "Code\Data\_Headers\_bitmapx.h"
#include "Code\Data\_Headers\Kosinski.h"

#ifndef FALSE
	#define FALSE (1 != 1)
	#define TRUE (!FALSE)
#endif

const char LayoutFile [] = { "Layout/1.bin" };
const char BlocksFile [] = { "Blocks/Primary.bin" };
const char ChunksFile [] = { "Chunks/Primary.bin" };
const char ArtFile [] = { "Tiles/Primary.bin" };
const char ColFile [] = { "Collision/1.bin" };
const char PatFile [] = { "FixVSprites.asm" };


int Cols [0x1000]; int ColsSize = 0;
int Rows [0x1000]; int RowsSize = 0;
unsigned short Patterns [0x1000]; int PatternsLoc = 0;

bool Error = FALSE;

char *Layout = NULL; int LayoutSize, LayoutPos, LayoutStart;
char *Chunks = NULL; int ChunksSize, ChunksPos;
char *Blocks = NULL; int BlocksSize, BlocksPos;
char *Art = NULL; int ArtSize, ArtPos;
char *Col = NULL; int ColSize, ColPos;
IMG ImageFG, ImageBG;

// =============================================================================
// -----------------------------------------------------------------------------
// Mass freeing data
// -----------------------------------------------------------------------------

void FreeData ( )

{
	free (Layout);		Layout = NULL;	LayoutSize = 0;	LayoutPos = 0;
	free (Chunks);		Chunks = NULL;	ChunksSize = 0;	ChunksPos = 0;
	free (Blocks);		Blocks = NULL;	BlocksSize = 0;	BlocksPos = 0;
	free (Col);		Col = NULL;	ColSize = 0;	ColPos = 0;
	free (Art);		Art = NULL;	ArtSize = 0;	ArtPos = 0;
	free (ImageFG.Data);	ImageFG.Data = NULL;
	free (ImageBG.Data);	ImageBG.Data = NULL;
}

// =============================================================================
// -----------------------------------------------------------------------------
// Reading settings file
// -----------------------------------------------------------------------------

const char ColTxt [] = { "Columns:" };
const char RowTxt [] = { "Rows:" };

void ReadTxt ( )

{
	FILE *File = fopen ("FixVSprites.txt", "rb");
	fseek (File, 0, SEEK_END);
	int Size = ftell (File);
	rewind (File);
	char *Memory = (char*) malloc (Size + 1);
	fread (Memory, sizeof (char), Size, File);
	fclose (File);
	Memory [Size++] = 0x0A;
	int Lines = 1;
	for (int Loc = 0; Loc < Size; Loc++)
	{
		if (Memory [Loc] == 0x0A) { Memory [Loc] = 0; Lines++; }
	}
	char Store;
	int Check;
	for (int Loc = 0; Lines > 0; Loc++)
	{
		if (Memory [Loc] == 0) { Lines--; continue; }
		Store = Memory [Loc + strlen (ColTxt)];
		Memory [Loc + strlen (ColTxt)] = 0;
		Check = strcmp (&Memory [Loc], ColTxt);
		Memory [Loc + strlen (ColTxt)] = Store;
		if (Check == 0)
		{
			Loc += strlen (ColTxt);
			while (Memory [Loc] != 0)
			{
				while (Memory [Loc] == '	' || Memory [Loc] == ' ') { Loc++; }
				if (Memory [Loc] == 0) { break; }
				int Number = 0; bool Write = FALSE;
				while ((Memory [Loc] != 0 && Memory [Loc] != ';' && Memory [Loc] != 0x0D) && ((Memory [Loc] >= '0' && Memory [Loc] <= '9') || (Memory [Loc] >= 'a' && Memory [Loc] <= 'f') || (Memory [Loc] >= 'A' && Memory [Loc] <= 'F')))
				{
					Write = TRUE;
					int Value = Memory [Loc] & 0xFF;
					if (Value >= 'a') { Value -= 'a' - 'A'; }
					if (Value >= 'A') { Value -= 'A' - ('9' + 1); }
					Number = (Number << 4) | (Value & 0x0F);
					Loc++;
				}
				if (Write == TRUE) { Cols [ColsSize++] = Number; }
				if (Memory [Loc] == ';') { while (Memory [Loc] != 0) { Loc++; } }
				else { Loc++; }
			}
			Lines--;
			continue;
		}
		Store = Memory [Loc + strlen (RowTxt)];
		Memory [Loc + strlen (RowTxt)] = 0;
		Check = strcmp (&Memory [Loc], RowTxt);
		Memory [Loc + strlen (RowTxt)] = Store;
		if (Check == 0)
		{
			Loc += strlen (RowTxt);
			while (Memory [Loc] != 0)
			{
				while (Memory [Loc] == '	' || Memory [Loc] == ' ') { Loc++; }
				if (Memory [Loc] == 0) { break; }
				int Number = 0; bool Write = FALSE;
				while ((Memory [Loc] != 0 && Memory [Loc] != ';' && Memory [Loc] != 0x0D) && ((Memory [Loc] >= '0' && Memory [Loc] <= '9') || (Memory [Loc] >= 'a' && Memory [Loc] <= 'f') || (Memory [Loc] >= 'A' && Memory [Loc] <= 'F')))
				{
					Write = TRUE;
					int Value = Memory [Loc] & 0xFF;
					if (Value >= 'a') { Value -= 'a' - 'A'; }
					if (Value >= 'A') { Value -= 'A' - ('9' + 1); }
					Number = (Number << 4) | (Value & 0x0F);
					Loc++;
				}
				if (Write == TRUE) { Rows [RowsSize++] = Number; }
				if (Memory [Loc] == ';') { while (Memory [Loc] != 0) { Loc++; } }
				else { Loc++; }
			}
			Lines--;
			continue;
		}
	}
	free (Memory); Memory = NULL;
}

// =============================================================================
// -----------------------------------------------------------------------------
// Loading data into char allocation
// -----------------------------------------------------------------------------

void LoadData (char *&Data, int &Size, const char *FileName)

{
	FILE *File = fopen (FileName, "rb");
	if (File == NULL)
	{
		Error = TRUE;
		FreeData ( );
		printf ("ERROR, could not open %s\n", FileName);
		fflush (stdin); getchar ( ); return;
	}
	fseek (File, 0, SEEK_END);
	Size = ftell (File);
	rewind (File);
	if ((Data = (char*) calloc (Size, sizeof (char))) == NULL)
	{
		Error = TRUE;
		FreeData ( );
		printf ("ERROR, could not allocate memory for %s\n", FileName);
		fflush (stdin); getchar ( ); return;
	}
	fread (Data, sizeof (char), Size, File);
	fclose (File);
	return;
}

void LoadKos (char *&Data, int &Size, const char *FileName)

{
	FILE *File = fopen (FileName, "rb");
	if (File == NULL)
	{
		Error = TRUE;
		FreeData ( );
		printf ("ERROR, could not open %s\n", FileName);
		fflush (stdin); getchar ( ); return;
	}
	fseek (File, 0, SEEK_END);
	Size = ftell (File);
	rewind (File);
	if ((Data = (char*) calloc (Size, sizeof (char))) == NULL)
	{
		Error = TRUE;
		FreeData ( );
		printf ("ERROR, could not allocate memory for %s\n", FileName);
		fflush (stdin); getchar ( ); return;
	}
	fread (Data, sizeof (char), Size, File);
	fclose (File);
	KosDec (Data, Size);
	return;
}

void LoadKosM (char *&Data, int &Size, const char *FileName)

{
	FILE *File = fopen (FileName, "rb");
	if (File == NULL)
	{
		Error = TRUE;
		FreeData ( );
		printf ("ERROR, could not open %s\n", FileName);
		fflush (stdin); getchar ( ); return;
	}
	fseek (File, 0, SEEK_END);
	Size = ftell (File);
	rewind (File);
	if ((Data = (char*) calloc (Size, sizeof (char))) == NULL)
	{
		Error = TRUE;
		FreeData ( );
		printf ("ERROR, could not allocate memory for %s\n", FileName);
		fflush (stdin); getchar ( ); return;
	}
	fread (Data, sizeof (char), Size, File);
	fclose (File);
	KosMDec (Data, Size);
	return;
}

// =============================================================================
// -----------------------------------------------------------------------------
// Unpacking level data
// -----------------------------------------------------------------------------

void LoadTile (IMG &Image, int TileID, int YL, int XL, int YC, int XC, int YB, int XB, int YF, int XF, int ColID1, int ColID2, int BlockID)

{
	switch (TileID & 0x1800)
	{
		case 0x0000:
		{
			for (int YR = 0, Y = 0; Y < 8; Y++, YR++)
			{
				for (int XR = 0, X = 0; X < 8; X++, XR++)
				{
					int Slot = ((XL*128)+(XC*16)+(XF*8)+XR) + (((YL*128)+(YC*16)+(YF*8)+YR) * Image.SizeX);
					Image.Data [Slot].Blue = (((Art [((TileID & 0x7FF) * 0x20) + (X / 2) + (Y * 4)] << (0 + ((X&1)*4))) & 0xF0)) | ((TileID & 0xE000) >> 0x0C);
					Image.Data [Slot].Red = (BlockID & 0xFC00) >> 0x08;
					Image.Data [Slot].Green = ColID1;
					Image.Data [Slot].Alpha = ColID2;
				}
			}
		}
		break;
		case 0x0800:
		{
			for (int YR = 0, Y = 0; Y < 8; Y++, YR++)
			{
				for (int XR = 0, X = 7; X >= 0; X--, XR++)
				{
					int Slot = ((XL*128)+(XC*16)+(XF*8)+XR) + (((YL*128)+(YC*16)+(YF*8)+YR) * Image.SizeX);
					Image.Data [Slot].Blue = (((Art [((TileID & 0x7FF) * 0x20) + (X / 2) + (Y * 4)] << (0 + ((X&1)*4))) & 0xF0)) | ((TileID & 0xE000) >> 0x0C);
					Image.Data [Slot].Red = (BlockID & 0xFC00) >> 0x08;
					Image.Data [Slot].Green = ColID1;
					Image.Data [Slot].Alpha = ColID2;
				}
			}
		}
		break;
		case 0x1000:
		{
			for (int YR = 0, Y = 7; Y >= 0; Y--, YR++)
			{
				for (int XR = 0, X = 0; X < 8; X++, XR++)
				{
					int Slot = ((XL*128)+(XC*16)+(XF*8)+XR) + (((YL*128)+(YC*16)+(YF*8)+YR) * Image.SizeX);
					Image.Data [Slot].Blue = (((Art [((TileID & 0x7FF) * 0x20) + (X / 2) + (Y * 4)] << (0 + ((X&1)*4))) & 0xF0)) | ((TileID & 0xE000) >> 0x0C);
					Image.Data [Slot].Red = (BlockID & 0xFC00) >> 0x08;
					Image.Data [Slot].Green = ColID1;
					Image.Data [Slot].Alpha = ColID2;
				}
			}
		}
		break;
		case 0x1800:
		{
			for (int YR = 0, Y = 7; Y >= 0; Y--, YR++)
			{
				for (int XR = 0, X = 7; X >= 0; X--, XR++)
				{
					int Slot = ((XL*128)+(XC*16)+(XF*8)+XR) + (((YL*128)+(YC*16)+(YF*8)+YR) * Image.SizeX);
					Image.Data [Slot].Blue = (((Art [((TileID & 0x7FF) * 0x20) + (X / 2) + (Y * 4)] << (0 + ((X&1)*4))) & 0xF0)) | ((TileID & 0xE000) >> 0x0C);
					Image.Data [Slot].Red = (BlockID & 0xFC00) >> 0x08;
					Image.Data [Slot].Green = ColID1;
					Image.Data [Slot].Alpha = ColID2;
				}
			}
		}
		break;
	}
}

void LoadLevel (IMG &Image, char *LayCur)

{
	int SizeX = ((LayCur [0] & 0xFF) << 8) | (LayCur [1] & 0xFF);
	int SizeY = ((LayCur [4] & 0xFF) << 8) | (LayCur [5] & 0xFF);
	char *LaySlot = &LayCur [8];
	for (int YL = 0; YL < SizeY; YL++)
	{
	    int Slot = ((LaySlot [0] & 0xFF) << 8) | (LaySlot [1] & 0xFF);
	    LaySlot = &LaySlot [4];
	    char *LayData = &Layout [Slot & 0x7FFF];
	    for (int XL = 0; XL < SizeX; XL++)
	    {
		int ChunkID = (*LayData++ & 0xFF) * 0x80;
		for (int YC = 0; YC < 128/16; YC++)
		{
		    for (int XC = 0; XC < 128/16; XC++)
		    {
			int BlockID = (Chunks [ChunkID + ((XC + (YC * (128/16)))*2) + 0] & 0xFF) << 8;
			    BlockID |= Chunks [ChunkID + ((XC + (YC * (128/16)))*2) + 1] & 0xFF;
			int ColID1 = Col [((BlockID & 0x3FF) * 2) + 0] & 0xFF;
			int ColID2 = Col [((BlockID & 0x3FF) * 2) + 1] & 0xFF;
			switch (BlockID & 0x0C00)
			{
			    case 0x0000:
			    {
				for (int YB = 0, YF = 0; YB < 16/8; YB++, YF++)
				{
				    for (int XB = 0, XF = 0; XB < 16/8; XB++, XF++)
				    {
					int TileID = (Blocks [((BlockID & 0x3FF) * 8) + ((XB + (YB * 2)) * 2) + 0] & 0xFF) << 8;
					    TileID |= Blocks [((BlockID & 0x3FF) * 8) + ((XB + (YB * 2)) * 2) + 1] & 0xFF;
					LoadTile (Image, TileID ^ 0x0000, YL, XL, YC, XC, YB, XB, YF, XF, ColID1, ColID2, BlockID);
				    }
				}
			    }
			    break;
			    case 0x0400:
			    {
				for (int YB = 0, YF = 0; YB < 16/8; YB++, YF++)
				{
				    for (int XB = (16/8)-1, XF = 0; XB >= 0; XB--, XF++)
				    {
					int TileID = (Blocks [((BlockID & 0x3FF) * 8) + ((XB + (YB * 2)) * 2) + 0] & 0xFF) << 8;
					    TileID |= Blocks [((BlockID & 0x3FF) * 8) + ((XB + (YB * 2)) * 2) + 1] & 0xFF;
					LoadTile (Image, TileID ^ 0x0800, YL, XL, YC, XC, YB, XB, YF, XF, ColID1, ColID2, BlockID);
				    }
				}
			    }
			    break;
			    case 0x0800:
			    {
				for (int YB = (16/8)-1, YF = 0; YB >= 0; YB--, YF++)
				{
				    for (int XB = 0, XF = 0; XB < 16/8; XB++, XF++)
				    {
					int TileID = (Blocks [((BlockID & 0x3FF) * 8) + ((XB + (YB * 2)) * 2) + 0] & 0xFF) << 8;
					    TileID |= Blocks [((BlockID & 0x3FF) * 8) + ((XB + (YB * 2)) * 2) + 1] & 0xFF;
					LoadTile (Image, TileID ^ 0x1000, YL, XL, YC, XC, YB, XB, YF, XF, ColID1, ColID2, BlockID);
				    }
				}
			    }
			    break;
			    case 0x0C00:
			    {
				for (int YB = (16/8)-1, YF = 0; YB >= 0; YB--, YF++)
				{
				    for (int XB = (16/8)-1, XF = 0; XB >= 0; XB--, XF++)
				    {
					int TileID = (Blocks [((BlockID & 0x3FF) * 8) + ((XB + (YB * 2)) * 2) + 0] & 0xFF) << 8;
					    TileID |= Blocks [((BlockID & 0x3FF) * 8) + ((XB + (YB * 2)) * 2) + 1] & 0xFF;
					LoadTile (Image, TileID ^ 0x1800, YL, XL, YC, XC, YB, XB, YF, XF, ColID1, ColID2, BlockID);
				    }
				}
			    }
			    break;
			}
		    }
		}
	    }
	}
}

// =============================================================================
// -----------------------------------------------------------------------------
// Saving the tiles of the sprite rows first
// -----------------------------------------------------------------------------

void SaveRows (IMG Image)

{
	char Slot [(4 * 2) * (8 * 8)];	// Max sprite size
	for (int ColsLoc = 0; ColsLoc < ColsSize; ColsLoc++)
	{
		int PosX = Cols [ColsLoc];
		int PosY = 0;
		for (int RowsLoc = 0; RowsLoc < RowsSize; RowsLoc++)
		{
			int SizeY = Rows [RowsLoc] * 8;
			if ((ArtPos + (SizeY * (2 * 8))) > ArtSize)
			{
				ArtSize <<= 1; if (ArtSize == 0) { ArtSize = 0x800; }
				char *New = (char*) realloc (Art, ArtSize);
				if (New == NULL)
				{
					Error = TRUE;
					FreeData ( );
					printf ("ERROR, could not reallocate art tiles...\n");
					fflush (stdin); getchar ( ); return;
				}
				Art = New;
			}
			int SlotSize = 0;
			for (int Side = 0; Side < 0x10; Side += 8)
			{
			    for (int Y = 0; Y < SizeY; Y++)
			    {
				for (int X = 0; X < 8; X++)
				{
					Slot [SlotSize++] = (Image.Data [(PosX + X + Side) + ((PosY + Y) * Image.SizeX)].Blue >> 4) & 0x0F;
				}
			    }
			}
			int BestMatch = 0, BestLoc = ArtPos;
			for (int ArtLoc = 0; ArtLoc < ArtPos; ArtLoc += 8 * 8)
			{
				int ArtMoc = ArtLoc, SlotLoc = 0;
				for ( ; ArtMoc < ArtPos || SlotLoc < SlotSize; SlotLoc++, ArtMoc++)
				{
					if (Slot [SlotLoc] != Art [ArtMoc]) { break; }
				}
				if (SlotLoc >= SlotSize || ArtMoc >= ArtPos)
				{
					if ((SlotLoc / (8 * 8)) > BestMatch)
					{
						BestMatch = SlotLoc / (8 * 8);
						BestLoc = ArtLoc;
					}
				}
			}
			int Copy = (SlotSize / (8 * 8)) - BestMatch;
			for (int SlotLoc = BestMatch * (8 * 8); SlotLoc < SlotSize; SlotLoc++)
			{
				Art [ArtPos++] = Slot [SlotLoc];
			}

			Patterns [PatternsLoc++] = ((BestLoc / (8 * 8)) & 0x7FF) | ((Image.Data [PosX + (PosY * Image.SizeX)].Blue << 0x0C) & 0xE000);

			PosY += SizeY;
		}
	}
}

// =============================================================================
// -----------------------------------------------------------------------------
// Saving level data
// -----------------------------------------------------------------------------

void SaveLevel (IMG Image, char *LayCur)

{
	char LayTemp [Image.SizeX / 128];
	char Tile [4] [8 * 8];
	char Block [4] [4 * 2];
	char Chunk [8 * 8 * 2];
	for (int YL = 0; YL < Image.SizeY / 128; YL++)
	{
		int LayLoc = 0;
	    for (int XL = 0; XL < Image.SizeX / 128; XL++)
	    {
		int ChunkLoc = 0;
		for (int YC = 0; YC < 128 / 16; YC++)
		{
		    for (int XC = 0; XC < 128 / 16; XC++)
		    {
			int BlockLoc = 0;
			for (int YB = 0; YB < 16 / 8; YB++)
			{
			    for (int XB = 0; XB < 16 / 8; XB++)
			    {
				int TileLoc = 0;
				for (int Y = 0; Y < 8; Y++)
				{
				    for (int X = 0; X < 8; X++)
				    {
					Tile [0] [TileLoc] = (Image.Data [((XL*128)+(XC*16)+(XB*8)+(0+X)) + (((YL*128)+(YC*16)+(YB*8)+(0+Y)) * Image.SizeX)].Blue >> 4) & 0x0F;
					Tile [1] [TileLoc] = (Image.Data [((XL*128)+(XC*16)+(XB*8)+(7-X)) + (((YL*128)+(YC*16)+(YB*8)+(0+Y)) * Image.SizeX)].Blue >> 4) & 0x0F;
					Tile [2] [TileLoc] = (Image.Data [((XL*128)+(XC*16)+(XB*8)+(0+X)) + (((YL*128)+(YC*16)+(YB*8)+(7-Y)) * Image.SizeX)].Blue >> 4) & 0x0F;
					Tile [3] [TileLoc] = (Image.Data [((XL*128)+(XC*16)+(XB*8)+(7-X)) + (((YL*128)+(YC*16)+(YB*8)+(7-Y)) * Image.SizeX)].Blue >> 4) & 0x0F;
					TileLoc++;
				    }
				}
				int ArtMatch = -1;
				int StateMatch;
				int State;
				for (State = 0; State < 4; State++)
				{
					for (int ArtLoc = 0; ArtLoc < ArtPos; ArtLoc += 8 * 8)
					{
						int TileLoc = 0;
						for (int ArtMoc = ArtLoc; TileLoc < 8 * 8; ArtMoc++, TileLoc++)
						{
							if (Tile [State] [TileLoc] != Art [ArtMoc]) { break; }
						}
						if (TileLoc >= 8 * 8)
						{
							ArtMatch = ArtLoc;
							StateMatch = State;
							break;
						}
					}
					if (ArtMatch != -1) { break; }
				}
				if (ArtMatch == -1)
				{
					if ((ArtPos + (8 * 8)) > ArtSize)
					{
						ArtSize <<= 1; if (ArtSize == 0) { ArtSize = 0x800; }
						char *New = (char*) realloc (Art, ArtSize);
						if (New == NULL)
						{
							Error = TRUE;
							FreeData ( );
							printf ("ERROR, could not reallocate art tiles...\n");
							fflush (stdin); getchar ( ); return;
						}
						Art = New;
					}
					ArtMatch = ArtPos;
					StateMatch = 0;
					for (int TileLoc = 0; TileLoc < 8 * 8; TileLoc++)
					{
						Art [ArtPos++] = Tile [0] [TileLoc];
					}
				}
				// StateMatch = flip/mirror
				// ArtMatch = tile to use

				int Slot = ((XL*128)+(XC*16)+(XB*8)+0) + (((YL*128)+(YC*16)+(YB*8)+0) * Image.SizeX);
			//	if (	Image.Data [Slot].Green != 0x00 && Image.Data [Slot].Green != 0xFF ||
			//		Image.Data [Slot].Alpha != 0x00 && Image.Data [Slot].Alpha != 0xFF	)
			//	{
			//		// Collision is not 00 or FF on path 1 or 2, so need to take flip/mirror into account
			//		State ^= (Image.Data [Slot].Red & 0x0C) >> 2;	// reverse flip/mirror of tile to take into account the block needing mirror/flip for collision
			//	}
				Block [0] [BlockLoc++] = (((Image.Data [Slot].Blue & 0x0E) << 4) | (StateMatch << 3)) | ((ArtMatch / (8 * 8)) >> 8);
				Block [0] [BlockLoc++] = (ArtMatch / (8 * 8)) & 0xFF;

				//	Image.Data [Slot].Blue = (((Art [((TileID & 0x7FF) * 0x20) + (X / 2) + (Y * 4)] << (0 + ((X&1)*4))) & 0xF0)) | ((TileID & 0xE000) >> 0x0C);
				//	Image.Data [Slot].Red = (BlockID & 0xFC00) >> 0x08;
				//	Image.Data [Slot].Green = ColID1;
				//	Image.Data [Slot].Alpha = ColID2;
			    }
			}


			int Slot = ((XL*128)+(XC*16)+0+0) + (((YL*128)+(YC*16)+0+0) * Image.SizeX);
			int UseState = -1;
			if (	Image.Data [Slot].Green != 0x00 && Image.Data [Slot].Green != 0xFF ||
				Image.Data [Slot].Alpha != 0x00 && Image.Data [Slot].Alpha != 0xFF	)
			{
				// Collision is not 00 or FF on path 1 or 2, so need to take flip/mirror into account
				UseState = (Image.Data [Slot].Red & 0x0C) >> 2;
			}
			else
			{
				int TempBlock = 0;
				for (int Loc = 0; Loc < 8; )
				{
					TempBlock |= Block [0] [Loc++] << 8;
					TempBlock |= Block [0] [Loc++] & 0xFF;
				}
				if ((TempBlock & 0x3FF) == 0)
				{
					for (int Loc = 0; Loc < 8; Loc++)
					{
						Block [0] [Loc] = 0;
					}
				}
			}

			Block [1] [2] = Block [0] [0];
			Block [1] [3] = Block [0] [1];
			Block [1] [0] = Block [0] [2];
			Block [1] [1] = Block [0] [3];
			Block [1] [6] = Block [0] [4];
			Block [1] [7] = Block [0] [5];
			Block [1] [4] = Block [0] [6];
			Block [1] [5] = Block [0] [7];

			Block [2] [4] = Block [0] [0];
			Block [2] [5] = Block [0] [1];
			Block [2] [6] = Block [0] [2];
			Block [2] [7] = Block [0] [3];
			Block [2] [0] = Block [0] [4];
			Block [2] [1] = Block [0] [5];
			Block [2] [2] = Block [0] [6];
			Block [2] [3] = Block [0] [7];

			Block [3] [2] = Block [2] [0];
			Block [3] [3] = Block [2] [1];
			Block [3] [0] = Block [2] [2];
			Block [3] [1] = Block [2] [3];
			Block [3] [6] = Block [2] [4];
			Block [3] [7] = Block [2] [5];
			Block [3] [4] = Block [2] [6];
			Block [3] [5] = Block [2] [7];

			for (int Slot = 0; Slot < 8; Slot += 2)
			{
				int TileID = (Block [0] [Slot] & 0x07) << 8;
				    TileID |= Block [0] [Slot + 1] & 0xFF;
				TileID *= 8 * 8;

				for (int Y = 0, Loc = 0; Y < 8; Y++)
				{
					for (int X = 7; X >= 0; X--)
					{
						Tile [1] [X + (Y * 8)] = Art [TileID + Loc++];
					}
				}
				for (int Y = 7, Loc = 0; Y >= 0; Y--)
				{
					for (int X = 0; X < 8; X++)
					{
						Tile [2] [X + (Y * 8)] = Art [TileID + Loc++];
					}
				}
				for (int Y = 7, Loc = 0; Y >= 0; Y--)
				{
					for (int X = 7; X >= 0; X--)
					{
						Tile [3] [X + (Y * 8)] = Art [TileID + Loc++];
					}
				}
				int Loc;
				for (Loc = 0; Loc < 8 * 8; Loc++)
				{
					if (Art [TileID + Loc] != Tile [1] [Loc]) { break; }
				}
				if (Loc < 8 * 8)
				{
					char Swap [] = { 2, 3, 0, 1, 6, 7, 4, 5 };
					Block [1] [Swap [Slot]] ^= 0x08;
				}
				for (Loc = 0; Loc < 8 * 8; Loc++)
				{
					if (Art [TileID + Loc] != Tile [2] [Loc]) { break; }
				}
				if (Loc < 8 * 8)
				{
					char Swap [] = { 4, 5, 6, 7, 0, 1, 2, 3 };
					Block [2] [Swap [Slot]] ^= 0x10;
				}
				for (Loc = 0; Loc < 8 * 8; Loc++)
				{
					if (Art [TileID + Loc] != Tile [3] [Loc]) { break; }
				}
				if (Loc < 8 * 8)
				{
					char Swap [] = { 6, 7, 4, 5, 2, 3, 0, 1 };
					Block [3] [Swap [Slot]] ^= 0x18;
				}
			}

			int State, BestLoc;
			for (int BlocksLoc = 0; BlocksLoc < BlocksPos; BlocksLoc += 8)
			{
				for (State = 0; State < 4; State++)
				{
					if (UseState != -1)
					{
						if (UseState >= 4) { break; }
						State = UseState;
						UseState += 4;
					}
					int BlLoc = 0;
					for (int BlocksMoc = BlocksLoc; BlLoc < 8; BlocksMoc++, BlLoc++)
					{
						if (Blocks [BlocksMoc] != Block [State] [BlLoc]) { break; }
					}
					if (BlLoc >= 8)
					{
						BestLoc = BlocksLoc;
						break;
					}
				}
				if (State < 4) { break; }
			}
			if (UseState != -1)
			{
				UseState -= 4;
			}
			if (State >= 4)
			{
				State = 0;
				if (UseState != -1)
				{
					State = UseState;
				}
				BestLoc = BlocksPos;
				if ((BlocksPos + 8) > BlocksSize)
				{
					BlocksSize <<= 1; if (BlocksSize == 0) { BlocksSize = 0x800; }
					char *New = (char*) realloc (Blocks, BlocksSize);
					if (New == NULL)
					{
						Error = TRUE;
						FreeData ( );
						printf ("ERROR, could not reallocate blocks...\n");
						fflush (stdin); getchar ( ); return;
					}
					Blocks = New;
				}
				for (int BlLoc = 0; BlLoc < 8; BlLoc++)
				{
					Blocks [BlocksPos++] = Block [State] [BlLoc];
				}


				if ((ColPos + 2) >= ColSize)
				{
					ColSize <<= 1; if (ColSize == 0) { ColSize = 0x800; }
					char *New = (char*) realloc (Col, ColSize);
					if (New == NULL)
					{
						Error = TRUE;
						FreeData ( );
						printf ("ERROR, could not reallocate collision...\n");
						fflush (stdin); getchar ( ); return;
					}
					Col = New;
				}
				Col [ColPos++] = Image.Data [Slot].Green;
				Col [ColPos++] = Image.Data [Slot].Alpha;
			}

			Chunk [ChunkLoc++] = (((BestLoc / 8) & 0x3FF) >> 8) | (State << 2) | (Image.Data [Slot].Red & 0xF0);
			Chunk [ChunkLoc++] = ((BestLoc / 8) & 0x3FF) & 0xFF;

			// State = flip/mirror
			// BestLoc = Block to use
		    }
		}
		int ChunksLoc;
		for (ChunksLoc = 0; ChunksLoc < ChunksPos; ChunksLoc += 8 * 8 * 2)
		{
			int ChLoc = 0;
			for (int ChunksMoc = ChunksLoc; ChLoc < 8 * 8 * 2; ChunksMoc++, ChLoc++)
			{
				if (Chunks [ChunksMoc] != Chunk [ChLoc]) { break; }
			}
			if (ChLoc >= 8 * 8 * 2) { break; }
		}
		if (ChunksLoc >= ChunksPos)
		{
			if ((ChunksPos + (8 * 8 * 2)) >= ChunksSize)
			{
				ChunksSize <<= 1; if (ChunksSize == 0) { ChunksSize = 0x800; }
				char *New = (char*) realloc (Chunks, ChunksSize);
				if (New == NULL)
				{
					Error = TRUE;
					FreeData ( );
					printf ("ERROR, could not reallocate chunks...\n");
					fflush (stdin); getchar ( ); return;
				}
				Chunks = New;
			}
			for (int ChLoc = 0; ChLoc < 8 * 8 * 2; ChLoc++)
			{
				Chunks [ChunksPos++] = Chunk [ChLoc];
			}
		}
		LayTemp [LayLoc++] = ChunksLoc / (8 * 8 * 2);
	    }
		// find matching layout strip and store...
		int BestMatch = (Image.SizeX / 128);
		int BestLoc = LayoutPos;
		for (int LayoutLoc = LayoutStart; LayoutLoc < LayoutPos; LayoutLoc++)
		{
			int LayLoc = 0;
			int LayoutMoc = LayoutLoc;
			for ( ; LayoutMoc < LayoutPos && LayLoc < (Image.SizeX / 128); LayoutMoc++, LayLoc++)
			{
				if (Layout [LayoutMoc] != LayTemp [LayLoc]) { break; }
			}
			if (LayoutMoc >= LayoutPos || LayLoc >= (Image.SizeX / 128))
			{
				if (LayLoc < BestMatch)
				{
					BestMatch = LayLoc;
					BestLoc = LayoutLoc;
				}
			}
		}
		int Copy = BestMatch;
		int Match = (Image.SizeX / 128) - Copy;

		*LayCur++ = ((BestLoc >> 8) & 0xFF) | 0x80;
		*LayCur++ = (BestLoc & 0xFF);
		LayCur = &LayCur [2];
		BestLoc += Match;
		for (int LayLoc = Match; LayLoc < (Image.SizeX / 128); LayLoc++)
		{
			Layout [LayoutPos++] = LayTemp [LayLoc];
		}
	}
}

// =============================================================================
// -----------------------------------------------------------------------------
// Main entry point
// -----------------------------------------------------------------------------

int main ( )

{
	ReadTxt ( );

	ImageFG.Data = NULL;
	ImageBG.Data = NULL;

	LoadData (Layout, LayoutSize,	LayoutFile);	if (Error == TRUE) { return (0); }
	LoadData (Blocks, BlocksSize,	BlocksFile);	if (Error == TRUE) { return (0); }
	LoadKos  (Chunks, ChunksSize,	ChunksFile);	if (Error == TRUE) { return (0); }
	LoadKosM (Art,    ArtSize,	ArtFile);	if (Error == TRUE) { return (0); }
	LoadData (Col,    ColSize,	ColFile);	if (Error == TRUE) { return (0); }

	if (ColSize == 0x604)
	{
		if (	Col [0x600] == 'M'	&&
			Col [0x601] == 'A'	&&
			Col [0x602] == 'R'	&&
			Col [0x603] == 'K'	) { printf ("Conversion has already been done, won't do it again....\n"); fflush (stdin); getchar ( ); return (0); }
	}

	printf ("Columns: ");
	for (int Loc = 0; Loc < ColsSize; Loc++)
	{
		printf ("%4X ", Cols [Loc]);
	} printf ("\n");
	printf ("Rows:     ");
	for (int Loc = 0; Loc < RowsSize; Loc++)
	{
		printf ("%1X ", Rows [Loc]);
	} printf ("\n");

	ImageFG.SizeX = (((Layout [0] & 0xFF) << 8) | (Layout [1] & 0xFF)) * 128;
	ImageBG.SizeX = (((Layout [2] & 0xFF) << 8) | (Layout [3] & 0xFF)) * 128;
	ImageFG.SizeY = (((Layout [4] & 0xFF) << 8) | (Layout [5] & 0xFF)) * 128;
	ImageBG.SizeY = (((Layout [6] & 0xFF) << 8) | (Layout [7] & 0xFF)) * 128;

	int RowsSizeY = 0;
	for (int RowsLoc = 0; RowsLoc < RowsSize; RowsLoc++)
	{
		RowsSizeY += Rows [RowsLoc] * 8;
	}
	if (RowsSizeY >= ImageFG.SizeY)
	{
		FreeData ( );
		printf ("ERROR, a sprite rows add up to a position outside the level range...  Aborted.\n");
		fflush (stdin); getchar ( ); return (0);
	}
	for (int ColsLoc = 0; ColsLoc < ColsSize; ColsLoc++)
	{
		if (Cols [ColsLoc] >= ImageFG.SizeX)
		{
			FreeData ( );
			printf ("ERROR, a column position is outside the level range...  Aborted.\n");
			fflush (stdin); getchar ( ); return (0);
		}
	}
	ImageFG.Size = ImageFG.SizeX * ImageFG.SizeY;
	ImageBG.Size = ImageBG.SizeX * ImageBG.SizeY;
	ImageFG.Data = (PIX_BGRA*) calloc (ImageFG.Size, sizeof (PIX_BGRA));
	ImageBG.Data = (PIX_BGRA*) calloc (ImageBG.Size, sizeof (PIX_BGRA));
	if (ImageFG.Data == NULL || ImageBG.Data == NULL)
	{
		FreeData ( );
		printf ("ERROR, could not allocate memory for layout data...\n");
		fflush (stdin); getchar ( ); return (0);
	}


	LoadLevel (ImageFG, &Layout [0]);
	LoadLevel (ImageBG, &Layout [2]);

/*	FlipImage (ImageFG);
	FlipImage (ImageBG);
	int RetSave = ImageSave (ImageFG, "FG.png", "png");
	if (RetSave != ERR_BX_SUCCESS)
	{
		switch (RetSave)
		{
			case ERR_BX_FILE: { printf ("Error, could not create the image file\n"); } break;
			case ERR_BX_MEMORY: { printf ("Error, memory allocation issue \"%s\"\n", ErrMsgBX); } break;
			case ERR_BX_FORMAT: { printf ("Error, the file is either not an image, or the format is not supported\n"); } break;
			case ERR_BX_COPY: { printf ("Error, fread/fwrite copied the wrong number of bytes\n"); } break;
			case ERR_BX_COMPRESS: { printf ("Error, the bitmap file contains compressed data, please enable GDI+\n"); } break;
			case ERR_BX_GDI: { printf ("Error, GDI+ issue at \"%s\"\n", ErrMsgBX); } break;
			case ERR_BX_GDIVERSION: { printf ("Error, GDI+ version difference\n"); } break;
			case ERR_BX_WIN32: { printf ("Error, WIN32 issue at \"%s\"\n", ErrMsgBX); } break;
		}
		FreeData ( );
		fflush (stdin); getchar ( ); return (0);
	}
	RetSave = ImageSave (ImageBG, "BG.png", "png");
	if (RetSave != ERR_BX_SUCCESS)
	{
		switch (RetSave)
		{
			case ERR_BX_FILE: { printf ("Error, could not create the image file\n"); } break;
			case ERR_BX_MEMORY: { printf ("Error, memory allocation issue \"%s\"\n", ErrMsgBX); } break;
			case ERR_BX_FORMAT: { printf ("Error, the file is either not an image, or the format is not supported\n"); } break;
			case ERR_BX_COPY: { printf ("Error, fread/fwrite copied the wrong number of bytes\n"); } break;
			case ERR_BX_COMPRESS: { printf ("Error, the bitmap file contains compressed data, please enable GDI+\n"); } break;
			case ERR_BX_GDI: { printf ("Error, GDI+ issue at \"%s\"\n", ErrMsgBX); } break;
			case ERR_BX_GDIVERSION: { printf ("Error, GDI+ version difference\n"); } break;
			case ERR_BX_WIN32: { printf ("Error, WIN32 issue at \"%s\"\n", ErrMsgBX); } break;
		}
		FreeData ( );
		fflush (stdin); getchar ( ); return (0);
	}
	FlipImage (ImageFG);
	FlipImage (ImageBG);	*/

	ArtPos = 8 * 8;
	memset (Art, 0, ArtPos * sizeof (char));
	BlocksPos = 8;
	memset (Blocks, 0, BlocksPos * sizeof (char));
	ChunksPos = 8 * 8 * 2;
	memset (Chunks, 0, ChunksPos * sizeof (char));
	ColPos = 2;
	memset (Col, 0, ColPos * sizeof (char));
	SaveRows (ImageFG); if (Error == TRUE) { return (0); }

	LayoutSize = 0x10000; // being generous for the header
	if ((Layout = (char*) calloc (LayoutSize, sizeof (char))) == NULL)
	{
		FreeData ( );
		printf ("ERROR, could not allocate memory for layout data...\n");
		fflush (stdin); getchar ( ); return (0);
	}
	Layout [0] = (ImageFG.SizeX / 128) >> 8;
	Layout [1] = (ImageFG.SizeX / 128) >> 0;
	Layout [2] = (ImageBG.SizeX / 128) >> 8;
	Layout [3] = (ImageBG.SizeX / 128) >> 0;
	Layout [4] = (ImageFG.SizeY / 128) >> 8;
	Layout [5] = (ImageFG.SizeY / 128) >> 0;
	Layout [6] = (ImageBG.SizeY / 128) >> 8;
	Layout [7] = (ImageBG.SizeY / 128) >> 0;
	int Height = ImageFG.SizeY / 128;
	if (ImageBG.SizeY / 128 > Height)
	{
		Height = ImageBG.SizeY / 128;
	}
	LayoutPos = 8 + (Height * 4);
	LayoutStart = LayoutPos;
	SaveLevel (ImageFG, &Layout [0x8]); if (Error == TRUE) { return (0); }
	SaveLevel (ImageBG, &Layout [0xA]); if (Error == TRUE) { return (0); }

	char Byte;
	for (int Loc = 0, Pos = 0; Loc < ArtPos; Loc++)
	{
		if ((Loc & 1) == 0)
		{
			Byte = Art [Loc] << 4;
		}
		else
		{
			Byte |= Art [Loc] & 0x0F;
			Art [Pos++] = Byte;
		}
	}
	ArtPos /= 2;
	FILE *File;

	KosMComp (Art, ArtPos);

	File = fopen (ArtFile, "wb");
	for (int Loc = 0; Loc < ArtPos; Loc++)
	{
		fputc (Art [Loc], File);
	}
	fclose (File);

	File = fopen (BlocksFile, "wb");
	for (int Loc = 0; Loc < BlocksPos; Loc++)
	{
		fputc (Blocks [Loc], File);
	}
	fclose (File);

	KosComp (Chunks, ChunksPos);

	File = fopen (ChunksFile, "wb");
	for (int Loc = 0; Loc < ChunksPos; Loc++)
	{
		fputc (Chunks [Loc], File);
	}
	fclose (File);

	File = fopen (LayoutFile, "wb");
	for (int Loc = 0; Loc < LayoutPos; Loc++)
	{
		fputc (Layout [Loc], File);
	}
	fclose (File);

	File = fopen (ColFile, "wb");
	for (int Loc = 0; Loc < ColPos; Loc++)
	{
		fputc (Col [Loc], File);
	}
	for (int Loc = ColPos; Loc < 0x600; Loc++)
	{
		fputc (0x00, File);
	}
	fputc ('M', File);
	fputc ('A', File);
	fputc ('R', File);
	fputc ('K', File);
	fclose (File);

	File = fopen (PatFile, "wb");
	fputs (	"; ===========================================================================\r\n"
		"; ---------------------------------------------------------------------------\r\n"
		"; Pattern addresses for left V-scroll column sprites (generated by \"FixVSprites.exe\")\r\n"
		"; ---------------------------------------------------------------------------\r\n"
		"\r\n"
		"DDZ_VSF_Patterns:\r\n", File);

	char String [0x1000];
	snprintf (String, 0x1000, "		dc.w	$%0.4X\r\n", Cols [0]);
	fputs (String, File);
	for (int Loc = 0; Loc < ColsSize; Loc++)
	{
		snprintf (String, 0x1000, "		dc.w	DDZ_VSF_%0.2d-(DDZ_VSF_Patterns+2)\r\n", Loc);
		fputs (String, File);
	}
	fputs (	"\r\n", File);
	int PatLoc = 0;
	for (int Loc = 0; Loc < ColsSize; Loc++)
	{
		snprintf (String, 0x1000, "DDZ_VSF_%0.2d:	dc.w	", Loc);
		fputs (String, File);
		for (int X = 0; X < RowsSize; X++)
		{
			snprintf (String, 0x1000, "$%0.2X,", Patterns [PatLoc++]);
			fputs (String, File);
		}
		fseek (File, -1, SEEK_CUR);
		fputs (	"\r\n", File);
	}
	fputs (	"\r\n; ===========================================================================\r\n", File);
	fclose (File);



	FreeData ( );
	printf ("Converted...\n");
	fflush (stdin); getchar ( );
	return (0);
}

// =============================================================================