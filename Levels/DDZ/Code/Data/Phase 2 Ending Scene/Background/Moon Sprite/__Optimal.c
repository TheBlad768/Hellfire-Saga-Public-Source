// =============================================================================
// -----------------------------------------------------------------------------
// Sprite Maker
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include "..\..\..\..\..\..\..\_Headers\_bitmapx.h"
#include "..\..\..\..\..\..\..\_Headers\_sprite.h"
#include "..\..\..\..\..\..\..\_Headers\Kosinski.h"

#ifndef FALSE
	#define FALSE (1 != 1)
	#define TRUE (!FALSE)
#endif

ART Art;  MAPPING Map;  PLC Plc;
int PalLine, PalCount;
char PalBin [2*0x10*4] = { 0 };
char *Direct = NULL;

const char PalFile [] = { "_Palette" };

// =============================================================================
// -----------------------------------------------------------------------------
// Interpolation thread
// -----------------------------------------------------------------------------

int Return;
bool FinishConvert = FALSE;
bool FailedConvert = FALSE;

HANDLE ThreadSprite;
DWORD WINAPI Thread_Sprite (LPVOID lpParam)

{
	Return = FileSprites (PalBin, PalLine, PalCount,	Art, Map, Plc,	FALSE, SP_PLC_NONE, SP_AVERAGE,	Direct);
	if (Return != ERR_SP_SUCCESS)
	{
		printf ("\n");
		switch (Return)
		{
			case ERR_SP_MEMORY:	{ printf ("Error, could not allocate memory \"%s\"\n", ErrMsgSP); } break;
			case ERR_SP_MEMORYFILE:	{ printf ("Error, could not allocate memory \"%s\" for \"%s\"\n", ErrMsgSP, ErrFileSP); } break;
			case ERR_SP_FILE:	{ printf ("Error, could not open image file \"%s\"\n", ErrFileSP); } break;
			case ERR_SP_FORMAT:	{ printf ("Error, \"%s\" is a valid image file (or format is not supported)\n", ErrFileSP); } break;
			case ERR_SP_COPY:	{ printf ("Error, fread/fwrite copied wrong number of bytes of \"%s\"\n", ErrFileSP); } break;
			case ERR_SP_COMPRESS:	{ printf ("Error, \"%s\" contains compressed data, which is not supported\n", ErrFileSP); } break;
			case ERR_SP_GDI:	{ printf ("Error, GDI+ issue at \"%s\" for file \"%s\"\n", ErrMsgSP, ErrFileSP); } break;
			case ERR_SP_GDIVERSION:	{ printf ("Error, GDI+ version difference, file \"%s\"\n", ErrFileSP); } break;
			case ERR_SP_WIN32:	{ printf ("Error, WIN32 issue at \"%s\" for file \"%s\"\n", ErrMsgSP, ErrFileSP); } break;
			case ERR_SP_PIXEL:	{ printf ("Error, pixel at %d x %d in \"%s\" uses a colour not in the palette\n", ErrXSP, ErrYSP, ErrFileSP); } break;
			case ERR_SP_NOBITMAPX:	{ printf ("Error, using function \"FileSprites\" without \"bitmapx.h\" included\n"); } break;
		}
		FailedConvert = TRUE;
	}
	FinishConvert = TRUE;
}

// =============================================================================
// -----------------------------------------------------------------------------
// Entry point
// -----------------------------------------------------------------------------

int main (int ArgNumber, char **ArgList, char **EnvList)

{

	IMG Palette;

	const char *ExtID;
	int RetLoad = ImageLoadUnk (Palette, PalFile, ExtID);
	if (RetLoad != ERR_BX_SUCCESS)
	{
		if (ExtID == NULL)
		{
			printf ("Error, could not find \"%s\" image file\n", PalFile);
		}
		else
		{
			printf ("Palette file: \"%s%s\"\n", PalFile, ExtID);
			switch (RetLoad)
			{
				case ERR_BX_FILE: { printf ("Error, could not open the image file\n"); } break;
				case ERR_BX_MEMORY: { printf ("Error, memory allocation issue \"%s\"\n", ErrMsgBX); } break;
				case ERR_BX_FORMAT: { printf ("Error, the file is either not an image, or the format is not supported\n"); } break;
				case ERR_BX_COPY: { printf ("Error, fread/fwrite copied the wrong number of bytes\n"); } break;
				case ERR_BX_COMPRESS: { printf ("Error, the bitmap file contains compressed data, please enable GDI+\n"); } break;
				case ERR_BX_GDI: { printf ("Error, GDI+ issue at \"%s\"\n", ErrMsgBX); } break;
				case ERR_BX_GDIVERSION: { printf ("Error, GDI+ version difference\n"); } break;
				case ERR_BX_WIN32: { printf ("Error, WIN32 issue at \"%s\"\n", ErrMsgBX); } break;
			}
		}
		fflush (stdin); getchar ( ); return (0);
	}
	PerformResize (Palette, Palette.SizeX / 8, Palette.SizeY / 8, FALSE);
	FlipImage (Palette);
	PalCount = Palette.SizeX;
	if (PalCount > 0x10) { PalCount = 0x10; }
	int PalSize = PalCount;
	PalLine = Palette.SizeY;
	if (PalLine > 4) { PalLine = 4; }
	if (PalLine > 1) { PalSize = PalLine * 0x10; PalCount = 0x10; }
	for (int Y = 0; Y < PalLine; Y++)
	{
		for (int X = 0; X < PalCount; X++)
		{
			PalBin [((X * 2) + 0) + (Y * 0x10 * 2)] = (Palette.Data [X + (Y * Palette.SizeX)].Blue >> 4) & 0x0E;
			PalBin [((X * 2) + 1) + (Y * 0x10 * 2)] = (Palette.Data [X + (Y * Palette.SizeX)].Green & 0xE0);
			PalBin [((X * 2) + 1) + (Y * 0x10 * 2)] |= (Palette.Data [X + (Y * Palette.SizeX)].Red >> 4) & 0x0E;
		}
	}
	free (Palette.Data); Palette.Data = NULL;

	char Folder [0x1000];
	int FolderLoc = 0;
	for (int Loc = 0; ArgList [0] [Loc] != 0; Loc++) { Folder [Loc] = ArgList [0] [Loc]; if (ArgList [0] [Loc] == '\\' || ArgList [0] [Loc] == '/') { FolderLoc = Loc + 1; } };
	Folder [FolderLoc] = 0;
	DIR *dir;
	struct dirent *ent;
	dir = opendir (Folder);
	int DirectLoc = 0, DirectSize = 0;
	if (dir == NULL)
	{
		printf ("Error, Could not open directory:\n\"%s\"", Folder);
		fflush (stdin); getchar ( ); return (0);
	}
	else
	{
		while ((ent = readdir (dir)) != NULL)
		{
			int ExtLoc = 0;
			for (int Loc = 0; ent->d_name [Loc] != 0; Loc++)
			{
				if (ent->d_name [Loc] == '.') { ExtLoc = Loc + 1; }
			}
			int Loc; for (Loc = 0; ExtList [Loc] [0] != 0; Loc++)
			{
				if (strcmp (ExtList [Loc], &ent->d_name [ExtLoc]) == 0) { break; }
			}
			if (ExtList [Loc] [0] == 0) { continue; }
			ent->d_name [ExtLoc - 1] = 0;
			if (strcmp (ent->d_name, PalFile) == 0) { continue; }
			ent->d_name [ExtLoc - 1] = '.';
		//printf ("%s\n", ent->d_name);
			if ((DirectLoc + (FolderLoc + strlen (ent->d_name)) + 2) >= DirectSize)
			{
				DirectSize <<= 1; if (DirectSize == 0) { DirectSize = 0x1000; }
				char *New = (char*) realloc (Direct, DirectSize);
				if (New == NULL)
				{
					free (Direct); Direct = NULL;
					printf ("Error, could not reallocate memory for filename list\n");
					fflush (stdin); getchar ( ); return (0);
				}
				Direct = New;
			}
			DirectLoc += snprintf (&Direct [DirectLoc], DirectSize - DirectLoc, "%s%s", Folder, ent->d_name);
			Direct [DirectLoc++] = 0;
			Direct [DirectLoc] = 0;
		}
	}

	if ((ThreadSprite = CreateThread (NULL, 0x0000, Thread_Sprite, NULL, FALSE, 0x00)) == NULL)
	{
		printf ("Warning, could not create a thread...\n");
		printf ("Doing it threadless...  Please wait...\n");
		Thread_Sprite (NULL);	// call the thread as if it were a normal subroutine
	}
	else
	{
		for (int PerPrevSP = -1; FinishConvert == FALSE; )
		{
			Sleep (1);
			if (PercentSP != PerPrevSP)
			{
				PerPrevSP = PercentSP;
				printf ("\rProcessing... %3d%%", PercentSP);
			}
		}
		printf ("\n");
	}
	free (Direct); Direct = NULL;
	if (FailedConvert == TRUE)
	{
		fflush (stdin); getchar ( ); return (0);
	}

	FILE *File;

/*	if ((File = fopen ("Pal.bin", "wb")) == NULL)
	{
		FreeArt (Art);
		FreeMap (Map);
		FreePlc (Plc);
		printf ("Error, could not save palette\n");
		fflush (stdin); getchar ( ); return (0x00);
	}
	fputc (0x00, File);
	fputc (0x00, File);
	for (int Loc = 2; Loc < PalSize * 2; Loc++)
	{
		fputc (PalBin [Loc], File);
	}
	fclose (File);	*/


	KosComp (Art.Data, Art.Size);
	if ((File = fopen ("Art.kos", "wb")) == NULL)
	{
		FreeArt (Art);
		FreeMap (Map);
		FreePlc (Plc);
		printf ("Error, could not save Art\n");
		fflush (stdin); getchar ( ); return (0x00);
	}
	for (int Loc = 0; Loc < Art.Size; Loc++)
	{
		fputc (Art.Data [Loc], File);
	}
	fclose (File);




	if ((File = fopen ("Map.bin", "wb")) == NULL)
	{
		FreeArt (Art);
		FreeMap (Map);
		FreePlc (Plc);
		printf ("Error, could not save Map\n");
		fflush (stdin); getchar ( ); return (0x00);
	}
	int MapLoc = Map.Size*2;
	for (int Loc = 0; Loc < Map.Size; Loc++)
	{
		fseek (File, MapLoc, SEEK_SET);
		fputc ((Map.List [Loc].Count-1) >> 8, File);
		fputc ((Map.List [Loc].Count-1) >> 0, File);
		for (int Pos = 0; Pos < Map.List [Loc].Count; Pos++)
		{
			fputc ((Map.List [Loc].Piece [Pos].Y+0x80) >> 8, File);
			fputc ((Map.List [Loc].Piece [Pos].Y+0x80), File);
			fputc (0x00, File);
			fputc (Map.List [Loc].Piece [Pos].S, File);
			fputc (Map.List [Loc].Piece [Pos].V >> 8, File);
			fputc (Map.List [Loc].Piece [Pos].V, File);
			fputc ((Map.List [Loc].Piece [Pos].X+0x80) >> 8, File);
			fputc ((Map.List [Loc].Piece [Pos].X+0x80), File);
		}
		int MapPoint = MapLoc;
		MapLoc = ftell (File);
		fseek (File, Loc * 2, SEEK_SET);
		fputc (MapPoint >> 8, File);
		fputc (MapPoint >> 0, File);
	}
	fclose (File);




/*	if ((File = fopen ("Plc.bin", "wb")) == NULL)
	{
		FreeArt (Art);
		FreeMap (Map);
		FreePlc (Plc);
		printf ("Line Maker: Error, could not save Map\n");
		fflush (stdin); getchar ( ); return (0x00);
	}
	int PlcLoc = Plc.Size*2;
	for (int Loc = 0; Loc < Plc.Size; Loc++)
	{
		fseek (File, PlcLoc, SEEK_SET);
		fputc ((Plc.List [Loc].Count - 1) >> 8, File);
		fputc ((Plc.List [Loc].Count - 1) >> 0, File);
		for (int Pos = 0; Pos < Plc.List [Loc].Count; Pos++)
		{
			fputc (((Plc.List [Loc].Entry [Pos].Tile * 0x20) / 2) >> 0x08, File);
			fputc (((Plc.List [Loc].Entry [Pos].Tile * 0x20) / 2) >> 0x00, File);
			fputc (((Plc.List [Loc].Entry [Pos].Size * 0x20) / 2) >> 0x08, File);
			fputc (((Plc.List [Loc].Entry [Pos].Size * 0x20) / 2) >> 0x00, File);
		}
		int PlcPoint = PlcLoc;
		PlcLoc = ftell (File);
		fseek (File, Loc * 2, SEEK_SET);
		fputc (PlcPoint >> 8, File);
		fputc (PlcPoint >> 0, File);
	}
	fclose (File);	*/


	FreeArt (Art);
	FreeMap (Map);
	FreePlc (Plc);

	printf ("Complete...\n"); fflush (stdin); getchar ( );
	return (0);
}

// =============================================================================