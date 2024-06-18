// =============================================================================
// -----------------------------------------------------------------------------
// 
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <windows.h>
#include <dirent.h>
#include "..\..\..\..\..\..\_Headers\_bitmapx.h"

const char Folder [] = { "Frame" };

// =============================================================================
// -----------------------------------------------------------------------------
// 
// -----------------------------------------------------------------------------

int main (int ArgNumber, char **ArgList, char **EnvList)

{
	const char *ExtID;

	char Direct [0x1000];
	DIR *Dir = opendir (Folder);
	if (Dir == NULL)
	{
		printf ("Error, there is no folder called \"%s\" to process images from\n", Folder);
		fflush (stdin); getchar ( ); return (0);
	}
	int FileLoc = snprintf (Direct, 0x1000, "%s\\", Folder);
	struct dirent *Entry;
	IMG Image [0x100]; int ImageSize = 0;
	while ((Entry = readdir (Dir)) != NULL)
	{
		if (strcmp (Entry->d_name, ".") == 0) { continue; }
		if (strcmp (Entry->d_name, "..") == 0) { continue; }
		strcpy (&Direct [FileLoc], Entry->d_name);
		int Dot = -1;
		for (int Loc = 0; Direct [Loc] != 0; Loc++) { if (Direct [Loc] == '.') { Dot = Loc; } }
		if (Dot >= 0) { Direct [Dot] = 0; }
		int Return = ImageLoadUnk (Image [ImageSize], Direct, ExtID);
		if (Return != ERR_BX_SUCCESS)
		{
			if (ExtID == NULL)
			{
				printf ("File \"%s\"\n", Direct);
				printf ("Error, could not find the file with any valid extension names\n");
			}
			else
			{
				printf ("File \"%s.%s\"\n", Direct, ExtID);
				switch (Return)
				{
					case ERR_BX_FILE: { printf ("Error, could not open the file\n"); } break;
					case ERR_BX_MEMORY: { printf ("Error, memory allocation issue \"%s\"\n", ErrMsgBX); } break;
					case ERR_BX_FORMAT: { printf ("Error, the file is either not an image, or the format is not supported\n"); } break;
					case ERR_BX_COPY: { printf ("Error, fread/fwrite copied the wrong number of bytes\n"); } break;
					case ERR_BX_COMPRESS: { printf ("Error, the bitmap file contains compressed data, please enable GDI+\n"); } break;
					case ERR_BX_GDI: { printf ("Error, GDI+ issue at \"%s\"\n", ErrMsgBX); } break;
					case ERR_BX_GDIVERSION: { printf ("Error, GDI+ version difference\n"); } break;
					case ERR_BX_WIN32: { printf ("Error, WIN32 issue at \"%s\"\n", ErrMsgBX); } break;
				}
			}
			while (ImageSize > 0)
			{
				free (Image [--ImageSize].Data);
			}
			fflush (stdin); getchar ( ); return (0);
		}
		FlipImage (Image [ImageSize]);
		ImageSize++;
	}
	closedir (Dir);
	printf ("Loaded %d files\n", ImageSize);
	if (ImageSize <= 0) { printf ("No image files found...\n"); fflush (stdin); getchar ( ); return (0); }
	int POT = 0; for (int V = ImageSize, i = 0x20; i > 0; i--, V <<= 1) { if (V < 0) { POT++; } } if (POT != 1) { printf ("Error, there must be a power of two number of images to process\n"); fflush (stdin); getchar ( ); }












	IMG BG, Pal;
	int Return = ImageLoadUnk (Pal, "Background.pal", ExtID);
	if (Return != ERR_BX_SUCCESS)
	{
		if (ExtID == NULL)
		{
			printf ("File \"%s\"\n", Direct);
			printf ("Error, could not find the file with any valid extension names\n");
		}
		else
		{
			printf ("File \"%s.%s\"\n", Direct, ExtID);
			switch (Return)
			{
				case ERR_BX_FILE: { printf ("Error, could not open the file\n"); } break;
				case ERR_BX_MEMORY: { printf ("Error, memory allocation issue \"%s\"\n", ErrMsgBX); } break;
				case ERR_BX_FORMAT: { printf ("Error, the file is either not an image, or the format is not supported\n"); } break;
				case ERR_BX_COPY: { printf ("Error, fread/fwrite copied the wrong number of bytes\n"); } break;
				case ERR_BX_COMPRESS: { printf ("Error, the bitmap file contains compressed data, please enable GDI+\n"); } break;
				case ERR_BX_GDI: { printf ("Error, GDI+ issue at \"%s\"\n", ErrMsgBX); } break;
				case ERR_BX_GDIVERSION: { printf ("Error, GDI+ version difference\n"); } break;
				case ERR_BX_WIN32: { printf ("Error, WIN32 issue at \"%s\"\n", ErrMsgBX); } break;
			}
		}
		while (ImageSize > 0)
		{
			free (Image [--ImageSize].Data);
		}
		fflush (stdin); getchar ( ); return (0);
	}
	FlipImage (Pal);
	Return = ImageLoadUnk (BG, "Background", ExtID);
	if (Return != ERR_BX_SUCCESS)
	{
		if (ExtID == NULL)
		{
			printf ("File \"%s\"\n", Direct);
			printf ("Error, could not find the file with any valid extension names\n");
		}
		else
		{
			printf ("File \"%s.%s\"\n", Direct, ExtID);
			switch (Return)
			{
				case ERR_BX_FILE: { printf ("Error, could not open the file\n"); } break;
				case ERR_BX_MEMORY: { printf ("Error, memory allocation issue \"%s\"\n", ErrMsgBX); } break;
				case ERR_BX_FORMAT: { printf ("Error, the file is either not an image, or the format is not supported\n"); } break;
				case ERR_BX_COPY: { printf ("Error, fread/fwrite copied the wrong number of bytes\n"); } break;
				case ERR_BX_COMPRESS: { printf ("Error, the bitmap file contains compressed data, please enable GDI+\n"); } break;
				case ERR_BX_GDI: { printf ("Error, GDI+ issue at \"%s\"\n", ErrMsgBX); } break;
				case ERR_BX_GDIVERSION: { printf ("Error, GDI+ version difference\n"); } break;
				case ERR_BX_WIN32: { printf ("Error, WIN32 issue at \"%s\"\n", ErrMsgBX); } break;
			}
		}
		free (Pal.Data); Pal.Data = NULL;
		while (ImageSize > 0)
		{
			free (Image [--ImageSize].Data);
		}
		fflush (stdin); getchar ( ); return (0);
	}
	FlipImage (BG);

	PIX_BGRA PadColour = Pal.Data [0];
	TruncateImage (Pal, 4, 4, 128 + 4, Pal.SizeY + 4, PadColour);
	PerformResize (Pal, Pal.SizeX / 8, Pal.SizeY / 8, FALSE);
	TruncateImage (Pal, 0, -1, Pal.SizeX, Pal.SizeY, PadColour);
	PIX_BGRA Col = { 0, 0, 0, 0xFF };
	for (int Loc = 1; Loc < Pal.SizeX; )
	{
		Col.Red += 0x20;
		if (Col.Red == 0)
		{
			Col.Green += 0x20;
			if (Col.Green == 0)
			{
				Col.Blue += 0x20;
			}
		}
		int P; for (P = Pal.SizeX; P < Pal.SizeX * Pal.SizeY; P++)
		{
			if (	(Pal.Data [P].Blue & 0xE0)  == Col.Blue  &&
				(Pal.Data [P].Green & 0xE0) == Col.Green &&
				(Pal.Data [P].Red & 0xE0)   == Col.Red   ) { break; }
		}
		if (P >= Pal.SizeX)
		{
			// Save..
			Pal.Data [Loc++] = Col;
		}
	}

	IMG Frame [4];
	IMG Plane;
	Plane.SizeX = 1024;
	Plane.SizeY = 224;
	Plane.Size = Plane.SizeX * Plane.SizeY;
	Plane.Data = (PIX_BGRA*) calloc (Plane.Size, sizeof (PIX_BGRA));
	for (int Loc = 0; Loc < Plane.Size; Loc++) { Plane.Data [Loc].Alpha = 0xFF; }
	for (int Y = 0; Y < Plane.SizeY; Y++) { memcpy (&Plane.Data [Y * Plane.SizeX], &BG.Data [Y * BG.SizeX], BG.SizeX * sizeof (PIX_BGRA)); }
	free (BG.Data); BG.Data = NULL;

	for (int Sect = 0, Side = 0, PlaneNo = 0; Sect < ImageSize; Sect += 8, Side = (Side + 1) & 1)
	{
		Frame [0].Data = NULL;
		Frame [1].Data = NULL;
		Frame [2].Data = NULL;
		Frame [3].Data = NULL;
		for (int Odd = 0; Odd < 2; Odd++)
		{
			for (int ImageLoc = Odd + Sect, Slot = 0; ImageLoc < (Sect + 8); ImageLoc += 2, Slot++)
			{
				printf ("%d\n", ImageLoc);

				if ((Slot & 1) == 0)
				{
					Frame [(Slot / 2) + (Odd << 1)] = Image [0];
					Frame [(Slot / 2) + (Odd << 1)].Data = (PIX_BGRA*) malloc (Frame [(Slot / 2) + (Odd << 1)].Size * sizeof (PIX_BGRA));
					for (int Loc = 0; Loc < Image [0].Size; Loc++)
					{
						Frame [(Slot / 2) + (Odd << 1)].Data [Loc].Blue  = Image [ImageLoc].Data [Loc].Blue  & 0x20;
						Frame [(Slot / 2) + (Odd << 1)].Data [Loc].Green = Image [ImageLoc].Data [Loc].Green & 0x20;
						Frame [(Slot / 2) + (Odd << 1)].Data [Loc].Red   = Image [ImageLoc].Data [Loc].Red   & 0x20;
					}
				}
				else
				{
					for (int Loc = 0; Loc < Image [0].Size; Loc++)
					{
						Frame [(Slot / 2) + (Odd << 1)].Data [Loc].Blue  += (Image [ImageLoc].Data [Loc].Blue  & 0x10);
						Frame [(Slot / 2) + (Odd << 1)].Data [Loc].Green += (Image [ImageLoc].Data [Loc].Green & 0x10);
						Frame [(Slot / 2) + (Odd << 1)].Data [Loc].Red   += (Image [ImageLoc].Data [Loc].Red   & 0x10);
					}
				}
			}
			for (int Loc = 0; Loc < Image [0].Size; Loc++)
			{
				Frame [(Odd << 1) + 0].Data [Loc].Blue  += Frame [(Odd << 1) + 1].Data [Loc].Blue  << 2;
				Frame [(Odd << 1) + 0].Data [Loc].Green += Frame [(Odd << 1) + 1].Data [Loc].Green << 2;
				Frame [(Odd << 1) + 0].Data [Loc].Red   += Frame [(Odd << 1) + 1].Data [Loc].Red   << 2;
				Frame [(Odd << 1) + 0].Data [Loc].Alpha = 0xFF;
			}



		}
		PIX_BGRA Col;
		int X = Side; if (X == 0) { X = Plane.SizeX - Image [0].SizeX * 2; } else { X = Plane.SizeX - Image [0].SizeX; }
		for (int Y = 0; Y < Image [0].SizeY / 2; Y++)
		{
			for (int W = 0, XP = X; W < Image [0].SizeX; W++, XP++)
			{
				int Slot = (Frame [(Y & 1) << 1].Data [W + (Y * Image [0].SizeX)].Blue & 0xF0) >> 4;
				Plane.Data [XP + (Y * Plane.SizeX)] = Pal.Data [(Slot + 1)];
			}
		//	memcpy (&Plane.Data [X + (Y * Plane.SizeX)], &Frame [(Y & 1) << 1].Data [Y * Image [0].SizeX], Image [0].SizeX * sizeof (PIX_BGRA));
		}
		for (int Y = (Image [0].SizeY / 2), Z = (Image [0].SizeY / 2) - 1; Y < Image [0].SizeY; Y++, Z--)
		{
			for (int W = Image [0].SizeX - 1, XP = X; W >= 0; W--, XP++)
			{
				int Slot = (Frame [(Z & 1) << 1].Data [W + (Z * Image [0].SizeX)].Blue & 0xF0) >> 4;
				Plane.Data [XP + (Y * Plane.SizeX)] = Pal.Data [(Slot + 1)];
			//	Plane.Data [XP + (Y * Plane.SizeX)] = Frame [(Z & 1) << 1].Data [W + (Z * Image [0].SizeX)];
			}
		}



		free (Frame [0].Data);
		free (Frame [1].Data);
		free (Frame [2].Data);
		free (Frame [3].Data);
		if (Side != 0)
		{
			FlipImage (Plane);
			char T [0x100];
			snprintf (T,0x100,"Plane %0.2d.png", PlaneNo++);
			printf ("Saving \"%s\"\n", T);
			int RetSave = ImageSave (Plane, T, "png");
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
			FlipImage (Plane);
		}
	}
	free (Plane.Data); Plane.Data = NULL;

	FlipImage (Pal);
	PerformResize (Pal, Pal.SizeX * 8, Pal.SizeY * 8, FALSE);
	ImageSave (Pal, "Palette.png", "png");
	free (Pal.Data); Pal.Data = NULL;

	printf ("Complete...\n");
	while (ImageSize > 0)
	{
		free (Image [--ImageSize].Data);
	}
	fflush (stdin); getchar ( );
	return (0);
}

// =============================================================================
