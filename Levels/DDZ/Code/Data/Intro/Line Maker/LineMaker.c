// =============================================================================
// -----------------------------------------------------------------------------
// Line Maker
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include "..\..\..\..\..\..\_Headers\_bitmapx.h"
#include "..\..\..\..\..\..\_Headers\_sprite.h"

#ifndef FALSE
	#define FALSE (1 != 1)
	#define TRUE (!FALSE)
#endif

#define rangeof(ENTRY) (0x01<<(0x08*sizeof(ENTRY)))
#define PI 3.14159265
#define SINEWAVE rangeof(char)

#define THICKNESS 2
#define EDGE (8-(8-THICKNESS))





ART Art;  MAPPING Map;  PLC Plc;

char PalBin [] = {	0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00,
			0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00, 0x0E,0x0E, 0x0E,0xEE	};

char **THR_ImageData = NULL;
int *THR_SizeData = NULL;

// =============================================================================
// -----------------------------------------------------------------------------
// Interpolation thread
// -----------------------------------------------------------------------------

int Return;
bool FinishConvert = FALSE;

HANDLE ThreadSprite;
DWORD WINAPI Thread_Sprite (LPVOID lpParam)

{
	Return = DataSprites (PalBin, 1, 0x10,	Art, Map, Plc,	FALSE, SP_PLC_FULL, SP_SPRITES,	THR_ImageData, THR_SizeData, SP_BGRA, 8, sizeof (PIX_BGRA));
	FinishConvert = TRUE;
}

// =============================================================================
// -----------------------------------------------------------------------------
// Entry point
// -----------------------------------------------------------------------------

int main ( )

{
	IMG *Image = NULL;
	int ImgLoc = 0, ImgSize = 0;

	PIX_BGRA White = { 0xFF, 0xFF, 0xFF, 0xFF };

	for (int Angle = 0; Angle < 0x100; Angle++, ImgLoc++)
	{
		if (ImgLoc >= ImgSize)
		{
			ImgSize <<= 1; if (ImgSize == 0) { ImgSize = 10; }
			IMG *New = (IMG*) realloc (Image, ImgSize * sizeof (IMG));
			if (New == NULL)
			{
				while (--ImgLoc >= 0) { free (Image [ImgLoc].Data); }
				free (Image);
				printf ("Line Maker: Error, could not reallocate image list\n");
				fflush (stdin); getchar ( ); return (0);
			}
			Image = New;
		}
		Image [ImgLoc].SizeX = (32 << 1) + 1;
		Image [ImgLoc].SizeY = (32 << 1) + 1;
		Image [ImgLoc].Size = Image [ImgLoc].SizeX * Image [ImgLoc].SizeY;
		Image [ImgLoc].Data = (PIX_BGRA*) calloc (Image [ImgLoc].Size, sizeof (PIX_BGRA));
		if (Image [ImgLoc].Data == NULL)
		{
			while (--ImgLoc >= 0) { free (Image [ImgLoc].Data); }
			free (Image);
			printf ("Line Maker: Error, could not allocate pixel memory for image\n");
			fflush (stdin); getchar ( ); return (0);
		}
		for (int Loc = 0; Loc < Image [ImgLoc].Size; Loc++) { Image [ImgLoc].Data [Loc].Alpha = 0xFF; }
		if (Angle <= 0x40)
		{
			float Scale = 256.0; if (Angle < (SINEWAVE / 2)) { Scale -= 0.1; }
			int SineX = (int) (sin (Angle * PI / (SINEWAVE / 2)) * Scale);
			int SineY = (int) (cos (Angle * PI / (SINEWAVE / 2)) * Scale);

			int PosX = (Image [ImgLoc].SizeX / 2) * 256;
			int PosY = (Image [ImgLoc].SizeY / 2) * 256;

		for (int Count = 0; Count <= (32-EDGE); Count++)
		//	while (	PosX >= (((Image [ImgLoc].SizeX / 2) - (32-EDGE)) * 256) && PosX <= (((Image [ImgLoc].SizeX / 2) + (32-EDGE)) * 256)	&&
		//		PosY >= (((Image [ImgLoc].SizeY / 2) - (32-EDGE)) * 256) && PosY <= (((Image [ImgLoc].SizeY / 2) + (32-EDGE)) * 256)	)
			{
				for (int Circ = 0; Circ < 0x100; Circ++)
				{
					float Scale = 256.0; if (Circ < (SINEWAVE / 2)) { Scale -= 0.1; }
					int SX = (int) (sin (Circ * PI / (SINEWAVE / 2)) * Scale);
					int SY = (int) (cos (Circ * PI / (SINEWAVE / 2)) * Scale);
					int PX = PosX + (SX * (THICKNESS/2));
					int PY = PosY + (SY * (THICKNESS/2));
					Image [ImgLoc].Data [(PX / 256) + ((PY / 256) * Image [ImgLoc].SizeX)] = White;
				}
				PosX += SineX;
				PosY += SineY;
			}

		/*	for (int Y = 1; Y < Image [ImgLoc].SizeY - 1; Y++)
			{
				for (int X = 1; X < Image [ImgLoc].SizeX - 1; X++)
				{
					if (Image [ImgLoc].Data [X + (Y * Image [ImgLoc].SizeX)].Green == 0xFF)
					{
						bool Mark = FALSE;
						     if (Image [ImgLoc].Data [(X - 1) + ((Y - 1) * Image [ImgLoc].SizeX)].Red == 0) { Mark = TRUE; }
						else if (Image [ImgLoc].Data [(X + 1) + ((Y - 1) * Image [ImgLoc].SizeX)].Red == 0) { Mark = TRUE; }
						else if (Image [ImgLoc].Data [(X - 1) + ((Y + 1) * Image [ImgLoc].SizeX)].Red == 0) { Mark = TRUE; }
						else if (Image [ImgLoc].Data [(X + 1) + ((Y + 1) * Image [ImgLoc].SizeX)].Red == 0) { Mark = TRUE; }
						if (Mark == TRUE)
						{
							Image [ImgLoc].Data [X + (Y * Image [ImgLoc].SizeX)].Green = 0x00;
						}
					}
				}
			}	*/
		}
		else if (Angle <= 0x80)
		{
			int ImgPos = -(Angle - 0x40) * 2;
			memcpy (Image [ImgLoc].Data, Image [ImgLoc + ImgPos].Data, Image [ImgLoc].Size * sizeof (PIX_BGRA));
			FlipImage (Image [ImgLoc]);
		}
		else if (Angle <= 0xC0)
		{
			int ImgPos = -(Angle - 0x80) * 2;
			for (int Y = 0; Y < Image [ImgLoc].SizeY; Y++)
			{
				for (int X = 0; X < Image [ImgLoc].SizeX; X++)
				{
					Image [ImgLoc].Data [X + (Y * Image [ImgLoc].SizeX)] = Image [ImgLoc + ImgPos].Data [((Image [ImgLoc].SizeX - X) - 1) + (Y * Image [ImgLoc].SizeX)];
				}
			}
		}
		else
		{
			int ImgPos = -(Angle - 0xC0) * 2;
			memcpy (Image [ImgLoc].Data, Image [ImgLoc + ImgPos].Data, Image [ImgLoc].Size * sizeof (PIX_BGRA));
			FlipImage (Image [ImgLoc]);
		}

	/*	int RetSave = ImageSave (Image [ImgLoc], "Out.png", "png");
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
			printf ("Save error...");
			fflush (stdin); getchar ( ); return (0);
		}
		fflush (stdin); getchar ( );	*/

	}
	ImgSize = ImgLoc;

	char *ImageData [ImgSize] = { 0 };
	int SizeData [(ImgSize * 2) + 1];
	SizeData [(ImgSize * 2)] = 0;
	for (int Loc = 0; Loc < ImgSize; Loc++)
	{
		FlipImage (Image [Loc]);
		ImageData [Loc] = (char*) Image [Loc].Data;
		SizeData [(Loc * 2) + 0] = Image [Loc].SizeX;
		SizeData [(Loc * 2) + 1] = Image [Loc].SizeY;
	}

	THR_ImageData = ImageData;
	THR_SizeData = SizeData;
	if ((ThreadSprite = CreateThread (NULL, 0x0000, Thread_Sprite, NULL, FALSE, 0x00)) == NULL)
	{
		printf ("Line Maker: Warning, could not create a thread...\n");
		printf ("Line Maker: Doing it threadless...  Please wait...\n");
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
				printf ("\rLine Maker: Processing... %3d%%", PercentSP);
			}
		}
		printf ("\n");
	}
	while (--ImgSize >= 0) { free (Image [ImgSize].Data); }
	if (Return != ERR_SP_SUCCESS)
	{
		switch (Return)
		{
			case ERR_SP_MEMORY:	{ printf ("Line Maker: Error, could not allocate memory \"%s\"\n", ErrMsgSP); } break;
			case ERR_SP_MEMORYFILE:	{ printf ("Line Maker: Error, could not allocate memory \"%s\" for \"%s\"\n", ErrMsgSP, ErrFileSP); } break;
			case ERR_SP_FILE:	{ printf ("Line Maker: Error, could not open image file \"%s\"\n", ErrFileSP); } break;
			case ERR_SP_FORMAT:	{ printf ("Line Maker: Error, \"%s\" is a valid image file (or format is not supported)\n", ErrFileSP); } break;
			case ERR_SP_COPY:	{ printf ("Line Maker: Error, fread/fwrite copied wrong number of bytes of \"%s\"\n", ErrFileSP); } break;
			case ERR_SP_COMPRESS:	{ printf ("Line Maker: Error, \"%s\" contains compressed data, which is not supported\n", ErrFileSP); } break;
			case ERR_SP_GDI:	{ printf ("Line Maker: Error, GDI+ issue at \"%s\" for file \"%s\"\n", ErrMsgSP, ErrFileSP); } break;
			case ERR_SP_GDIVERSION:	{ printf ("Line Maker: Error, GDI+ version difference, file \"%s\"\n", ErrFileSP); } break;
			case ERR_SP_WIN32:	{ printf ("Line Maker: Error, WIN32 issue at \"%s\" for file \"%s\"\n", ErrMsgSP, ErrFileSP); } break;
			case ERR_SP_PIXEL:	{ printf ("Line Maker: Error, pixel at %d x %d in \"%s\" uses a colour not in the palette\n", ErrXSP, ErrYSP, ErrFileSP); } break;
			case ERR_SP_NOBITMAPX:	{ printf ("Line Maker: Error, using function \"FileSprites\" without \"bitmapx.h\" included\n"); } break;
		}
		fflush (stdin); getchar ( ); return (0x00);
	}



	FILE *File;

	if ((File = fopen ("Line Art.bin", "wb")) == NULL)
	{
		FreeArt (Art);
		FreeMap (Map);
		FreePlc (Plc);
		printf ("Line Maker: Error, could not save Art\n");
		fflush (stdin); getchar ( ); return (0x00);
	}
	for (int Loc = 0; Loc < Art.Size; Loc++)
	{
		fputc (Art.Data [Loc], File);
	}
	fclose (File);




	if ((File = fopen ("Line Map.bin", "wb")) == NULL)
	{
		FreeArt (Art);
		FreeMap (Map);
		FreePlc (Plc);
		printf ("Line Maker: Error, could not save Map\n");
		fflush (stdin); getchar ( ); return (0x00);
	}
	//int MapLoc = Map.Size*2;
	for (int Loc = 0; Loc < Map.Size; Loc++)
	{
	//	fseek (File, MapLoc, SEEK_SET);
		if (Plc.List [Loc].Count != 1) { printf ("Line Maker: Warning, frame %d has more than one MAP entry\n", Loc); }
	//	fputc ((Map.List [Loc].Count - 1) >> 8, File);
	//	fputc ((Map.List [Loc].Count - 1) >> 0, File);
		for (int Pos = 0; Pos < Map.List [Loc].Count; Pos++)
		{
			fputc (Map.List [Loc].Piece [Pos].Y >> 8, File);
			fputc (Map.List [Loc].Piece [Pos].Y, File);
			fputc (0x00, File);
			fputc (Map.List [Loc].Piece [Pos].S, File);
			fputc (Map.List [Loc].Piece [Pos].V >> 8, File);
			fputc (Map.List [Loc].Piece [Pos].V, File);
			fputc (Map.List [Loc].Piece [Pos].X >> 8, File);
			fputc (Map.List [Loc].Piece [Pos].X, File);
		}
	//	int MapPoint = MapLoc;
	//	MapLoc = ftell (File);
	//	fseek (File, Loc * 2, SEEK_SET);
	//	fputc (MapPoint >> 8, File);
	//	fputc (MapPoint >> 0, File);
	}
	fclose (File);





	if ((File = fopen ("Line Plc.bin", "wb")) == NULL)
	{
		FreeArt (Art);
		FreeMap (Map);
		FreePlc (Plc);
		printf ("Line Maker: Error, could not save Map\n");
		fflush (stdin); getchar ( ); return (0x00);
	}
	//int PlcLoc = Plc.Size*2;
	for (int Loc = 0; Loc < Plc.Size; Loc++)
	{
	//	fseek (File, PlcLoc, SEEK_SET);
		if (Plc.List [Loc].Count != 1) { printf ("Line Maker: Warning, frame %d has more than one PLC entry\n", Loc); }
	//	fputc ((Plc.List [Loc].Count - 1) >> 8, File);
	//	fputc ((Plc.List [Loc].Count - 1) >> 0, File);
		for (int Pos = 0; Pos < Plc.List [Loc].Count; Pos++)
		{
			fputc (((Plc.List [Loc].Entry [Pos].Tile * 0x20) / 2) >> 0x08, File);
			fputc (((Plc.List [Loc].Entry [Pos].Tile * 0x20) / 2) >> 0x00, File);
			fputc (((Plc.List [Loc].Entry [Pos].Size * 0x20) / 2) >> 0x08, File);
			fputc (((Plc.List [Loc].Entry [Pos].Size * 0x20) / 2) >> 0x00, File);
		}
	//	int PlcPoint = PlcLoc;
	//	PlcLoc = ftell (File);
	//	fseek (File, Loc * 2, SEEK_SET);
	//	fputc (PlcPoint >> 8, File);
	//	fputc (PlcPoint >> 0, File);
	}
	fclose (File);

	FreeArt (Art);
	FreeMap (Map);
	FreePlc (Plc);

	printf ("Line Maker: Complete...\n"); fflush (stdin); getchar ( );
	return (0);
}

// =============================================================================