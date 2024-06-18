// =============================================================================
// -----------------------------------------------------------------------------
// Quick program to convert art to sprite tiles... nothing fancy.
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <windows.h>
#include "..\..\..\..\..\..\_Headers\_bitmapx.h"
#include "..\..\..\..\..\..\_Headers\Kosinski.h"

int main (int ArgNumber, char **ArgList, char **EnvList)

{
	if (ArgNumber <= 1)
	{
		printf ("For converting the body piece into a single sprite of tiles (nothing fancy)\n\n"
			"Drag and drop image files onto this program to convert to vertically mapped\n"
			"unoptimised tiles, please also ensure an image named \"Palette\" (containing\n"
			"an image of the palette) exists in the same directory.");
		fflush (stdin); getchar ( ); return (0);
	}
	const char *ExtID;
	IMG Palette;
	int Return = ImageLoadUnk (Palette, "Palette", ExtID);
	if (Return != ERR_BX_SUCCESS)
	{
		if (ExtID == NULL)
		{
			printf ("File \"Palette\"\n");
			printf ("Error, could not find the file with any valid extension names\n");
		}
		else
		{
			printf ("File \"Palette.%s\"\n", ExtID);
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
		fflush (stdin); getchar ( ); return (0);
	}
	Return = PerformResize (Palette, Palette.SizeX / 8, Palette.SizeY / 8, FALSE);
	if (Return != ERR_BX_SUCCESS)
	{
		free (Palette.Data); Palette.Data = NULL;
		printf ("Palette file \"Palette.%s\"\n", ExtID);
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
	FILE *File = fopen ("Palette.bin", "wb");
	if (File == NULL)
	{
		printf ("File \"Palette.bin\" could not be created...\n");
		free (Palette.Data); Palette.Data = NULL;
		fflush (stdin); getchar ( ); return (0);
	}
	fputc (0, File);
	fputc (0, File);
	for (int Loc = 1; Loc < Palette.Size; Loc++)
	{
		fputc ((Palette.Data [Loc].Blue & 0xE0) >> 4, File);
		fputc ((Palette.Data [Loc].Green & 0xE0) | ((Palette.Data [Loc].Red & 0xE0) >> 4), File);
	}
	fclose (File);

	char Direct [0x1000];
	IMG Image;
	for (int ArgCount = 1; ArgCount < ArgNumber; ArgCount++)
	{
		Return = ImageLoad (Image, ArgList [ArgCount]);
		if (Return != ERR_BX_SUCCESS)
		{
			printf ("File \"%s\"\n", ArgList [ArgCount]);
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
			printf ("Press enter to skip");
			fflush (stdin); getchar ( ); continue;
		}
		if (Image.SizeX > 32 || Image.SizeY > 32)
		{
			printf ("File \"%s\"\n", ArgList [ArgCount]);
			printf ("Width or height is larger than the size of a sprite (32 x 32)\n");
			printf ("Press enter to skip");
			free (Image.Data); Image.Data = NULL;
			fflush (stdin); getchar ( ); continue;
		}
		FlipImage (Image);
		if ((Image.SizeX & 7) != 0 || (Image.SizeY & 7) != 0)
		{
			TruncateImage (Image, 0, 0, (Image.SizeX + 7) & -8, (Image.SizeY + 7) & -8, Palette.Data [0]);
		}
		bool Error = FALSE;
		for (int XT = 0; XT < Image.SizeX; XT += 8)
		{
			for (int Y = 0; Y < Image.SizeY; Y++)
			{
				for (int X = 0; X < 8; X++)
				{
					int Pos = XT + X + (Y * Image.SizeX);
					int Loc; for (Loc = 0; Loc < Palette.Size; Loc++)
					{
						if (	Palette.Data [Loc].Blue  == Image.Data [Pos].Blue  &&
							Palette.Data [Loc].Green == Image.Data [Pos].Green &&
							Palette.Data [Loc].Red   == Image.Data [Pos].Red   )
						{
							break;
						}
					}
					if (Loc >= Palette.Size)
					{
						if (Error == FALSE)
						{
							printf ("File \"%s\"\n", ArgList [ArgCount]);
							printf ("Pixels at the following coordinates do not match the palette:\n");
							Error = TRUE;
						}
						printf ("%2d x %2d\n", XT + X, Y);
						Image.Data [Pos].Alpha = -1;
						Image.Data [Pos].Blue  = 0xFF;
						Image.Data [Pos].Green = 0xFF;
						Image.Data [Pos].Red   = 0xFF;
					}
					else
					{
						Image.Data [Pos].Alpha = Loc;
						Image.Data [Pos].Blue  = 0;
						Image.Data [Pos].Green = 0;
						Image.Data [Pos].Red   = 0;
					}
				}
			}
		}
		if (Error == TRUE)
		{
			int End = snprintf (Direct, 0x1000, "%s", ArgList [ArgCount]);
			int Loc = End; for ( ; Loc >= 0 && Direct [Loc] != '.'; Loc--) { }
			if (Loc <= 0)
			{
				Loc = End;
			}
			snprintf (&Direct [Loc], 0x1000 - Loc, ".err.png");
			FlipImage (Image);
			int RetSave = ImageSave (Image, Direct, "png");
			if (RetSave != ERR_BX_SUCCESS)
			{
				free (Image.Data); Image.Data = NULL;
				switch (RetSave)
				{
					case ERR_BX_FILE: { printf ("Error, could not create the file\n"); } break;
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
			fflush (stdin); getchar ( ); continue;
		}
		int End = snprintf (Direct, 0x1000, "%s", ArgList [ArgCount]);
		int Loc = End; for ( ; Loc >= 0 && Direct [Loc] != '.'; Loc--) { }
		if (Loc <= 0)
		{
			Loc = End;
		}

		int TilesSize = (Image.SizeX / 2) * Image.SizeY;
		char *Tiles = (char*) malloc (TilesSize);
		if (Tiles == NULL)
		{
			free (Image.Data); Image.Data = NULL;
			printf ("Error, could not allocate memory for tile data\n");
			fflush (stdin); getchar ( ); continue;
		}
		int TilesLoc = 0;
		for (int XT = 0; XT < Image.SizeX; XT += 8)
		{
			for (int Y = 0; Y < Image.SizeY; Y++)
			{
				int Pixels;
				for (int X = 0; X < 8; X++)
				{
					if ((X & 1) == 0)
					{
						Pixels = Image.Data [XT + X + (Y * Image.SizeX)].Alpha << 4;
					}
					else
					{
						Pixels |= Image.Data [XT + X + (Y * Image.SizeX)].Alpha;
						Tiles [TilesLoc++] = Pixels;
					}
				}
			}
		}
		free (Image.Data); Image.Data = NULL;


		KosMComp (Tiles, TilesSize);
		snprintf (&Direct [Loc], 0x1000 - Loc, ".kosm");
		FILE *File = fopen (Direct, "wb");
		if (File == NULL)
		{
			printf ("Error, could not create %s\n", Direct);
			printf ("Press enter to skip");
			free (Tiles); Tiles = NULL;
			fflush (stdin); getchar ( ); continue;
		}
		fwrite (Tiles, sizeof (char), TilesSize, File);
		fclose (File);
		free (Tiles); Tiles = NULL;
	}
	free (Palette.Data); Palette.Data = NULL;
	return (0);
}

// =============================================================================
