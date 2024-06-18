// =============================================================================
// -----------------------------------------------------------------------------
// Scale Stripper
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <direct.h>
#include <string.h>
#include "..\..\..\..\..\..\..\_Headers\_bitmapx.h"
#include "..\..\..\..\..\..\..\_Headers\Enigma.h"

#ifndef FALSE
	#define FALSE (1 != 1)
	#define TRUE (!FALSE)
#endif

const char PalFile [] = { "../_Palette" };
const char OutFolder [] = { "Output" };

// =============================================================================
// -----------------------------------------------------------------------------
// Entry point
// -----------------------------------------------------------------------------

int main (int ArgNumber, char **ArgList, char **EnvList)

{
	IMG Palette;
	char PalBin [2*0x10*4] = { 0 };

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
	int PalCount = Palette.SizeX;
	if (PalCount > 0x10) { PalCount = 0x10; }
	int PalSize = PalCount;
	int PalLine = Palette.SizeY;
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
	char Direct [0x1000];
	int DirectLoc = 0, DirectSize = 0;
	mkdir (OutFolder);
	char T [0x1000];
	if (dir == NULL)
	{
		printf ("Error, Could not open directory:\n\"%s\"", Folder);
		fflush (stdin); getchar ( ); return (0);
	}
	else
	{
		int FileCount = 0;
		printf ("Processing files:\n\n");
		IMG Merge;
		Merge.Data = NULL;
		char FirstName [0x100] = { 0 };
		PIX_BGRA PadMerge;
		while ((ent = readdir (dir)) != NULL)
		{
			int ExtLoc = 0;
			for (int Loc = 0; ent->d_name [Loc] != 0; Loc++)
			{
				if (ent->d_name [Loc] == '.') { ExtLoc = Loc + 1; }
			}
			if (ExtLoc == 0) { continue; }
			int Loc; for (Loc = 0; ExtList [Loc] [0] != 0; Loc++)
			{
				if (strcmp (ExtList [Loc], &ent->d_name [ExtLoc]) == 0) { break; }
			}
			if (ExtList [Loc] [0] == 0) { continue; }
			ent->d_name [ExtLoc - 1] = 0;
			if (strcmp (ent->d_name, PalFile) == 0) { continue; }
			ent->d_name [ExtLoc - 1] = '.';
			snprintf (Direct, 0x1000, "%s%s", Folder, ent->d_name);
			ent->d_name [ExtLoc - 1] = 0;
			printf (" -> %s \n", ent->d_name);
			if (FirstName [0] == 0)
			{
				strcpy (FirstName, ent->d_name);
			}
			IMG Image;
			int RetLoad = ImageLoad (Image, Direct);
			if (RetLoad != ERR_BX_SUCCESS)
			{
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
				fflush (stdin); getchar ( ); return (0);
			}
			if (Merge.Data == NULL)
			{
				Merge = Image;
				Merge.Data = (PIX_BGRA*) calloc (Merge.Size, sizeof (PIX_BGRA));
				for (int Loc = 0; Loc < Merge.Size; Loc++)
				{
					Merge.Data [Loc].Alpha = 0xFF;
				}
			}
			FlipImage (Image);
			if (Image.SizeX != Merge.SizeX || Image.SizeY != Merge.SizeY)
			{
				free (Merge.Data);
				free (Image.Data);
				printf ("    Error, all frames MUST be the same width/height\n\nPress enter key to exit...\n");
				fflush (stdin); getchar ( ); return (0);
			}
			PadMerge = Image.Data [0];
			for (int Loc = 0; Loc < Image.Size; Loc++)
			{
				if (	PadMerge.Blue  != Image.Data [Loc].Blue	||
					PadMerge.Green != Image.Data [Loc].Green	||
					PadMerge.Red   != Image.Data [Loc].Red	)
				{
					Merge.Data [Loc].Alpha = 0;
				}
			}
		}
		for (int Loc = 0; Loc < Merge.Size; Loc++)
		{
			if (Merge.Data [Loc].Alpha == 0xFF)
			{
				Merge.Data [Loc] = PadMerge;
			}
			else
			{
				Merge.Data [Loc].Blue  = PalBin [0] << 4;
				Merge.Data [Loc].Green = PalBin [1] & 0xE0;
				Merge.Data [Loc].Red   = PalBin [1] << 4;
				Merge.Data [Loc].Alpha = 0xFF;
			}
		}
		closedir (dir);
		printf ("\nRe-processing files:\n\n");
		dir = opendir (Folder);
		bool FirstData = TRUE;
		do
		{
			IMG Image = Merge;
			if (FirstData == FALSE)
			{
				int ExtLoc = 0;
				for (int Loc = 0; ent->d_name [Loc] != 0; Loc++)
				{
					if (ent->d_name [Loc] == '.') { ExtLoc = Loc + 1; }
				}
				if (ExtLoc == 0) { continue; }
				int Loc; for (Loc = 0; ExtList [Loc] [0] != 0; Loc++)
				{
					if (strcmp (ExtList [Loc], &ent->d_name [ExtLoc]) == 0) { break; }
				}
				if (ExtList [Loc] [0] == 0) { continue; }
				ent->d_name [ExtLoc - 1] = 0;
				if (strcmp (ent->d_name, PalFile) == 0) { continue; }
				ent->d_name [ExtLoc - 1] = '.';
				snprintf (Direct, 0x1000, "%s%s", Folder, ent->d_name);
				ent->d_name [ExtLoc - 1] = 0;
				printf (" -> %s \n", ent->d_name);

		//	printf ("\"%s\"\n", Direct);

		// Direct = Image file to process...

				int RetLoad = ImageLoad (Image, Direct);
				if (RetLoad != ERR_BX_SUCCESS)
				{
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
					fflush (stdin); getchar ( ); return (0);
				}
				FlipImage (Image);
			}
			PIX_BGRA PadColour = Image.Data [0];
			if (FirstData == FALSE)
			{
				for (int Loc = 0; Loc < Image.Size; Loc++)
				{
					if (	PadMerge.Blue  != Merge.Data [Loc].Blue	||
						PadMerge.Green != Merge.Data [Loc].Green	||
						PadMerge.Red   != Merge.Data [Loc].Red	)
					{
						if (	PadColour.Blue  == Image.Data [Loc].Blue	&&
							PadColour.Green == Image.Data [Loc].Green	&&
							PadColour.Red   == Image.Data [Loc].Red	)
						{
							Image.Data [Loc].Blue  = PalBin [0] << 4;
							Image.Data [Loc].Green = PalBin [1] & 0xE0;
							Image.Data [Loc].Red   = PalBin [1] << 4;
							Image.Data [Loc].Alpha = 0xFF;
						}
					}
				}
			}
			int ErrorCount = 0;
			for (int Y = 0; Y < Image.SizeY; Y++)
			{
				for (int X = 0; X < Image.SizeX; X++)
				{
					if (	PadColour.Blue  == Image.Data [X + (Y * Image.SizeX)].Blue	&&
						PadColour.Green == Image.Data [X + (Y * Image.SizeX)].Green	&&
						PadColour.Red   == Image.Data [X + (Y * Image.SizeX)].Red	)
					{
						Image.Data [X + (Y * Image.SizeX)].Alpha = 0xFF;
					}
					else
					{
						char Col [2];
						Col [0] =  (Image.Data [X + (Y * Image.SizeX)].Blue & 0xE0) >> 4;
						Col [1] = ((Image.Data [X + (Y * Image.SizeX)].Red  & 0xE0) >> 4) | (Image.Data [X + (Y * Image.SizeX)].Green & 0xE0);
						int Loc; for (Loc = 0; Loc < PalCount * 2; Loc += 2)
						{
							if (Col [0] == PalBin [Loc] && Col [1] == PalBin [Loc + 1]) { break; }
						}
						if (Loc >= PalCount * 2)
						{
							// Error X and Y positions
							if (ErrorCount++ == 0)
							{
								printf ("    Error, has a colour which does not match the palette at:\n\n", ent->d_name);
							}
							if (ErrorCount <= 10)
							{
								printf ("        %5d x %5d\n", X, Y);
							}
						}
						Image.Data [X + (Y * Image.SizeX)].Alpha = Loc / 2;
					}
				}
			}
			if (ErrorCount > 10)
			{
				free (Image.Data); Image.Data = NULL;
				printf ("\n    ...and %d more\n\nPress enter key to exit...\n", ErrorCount - 10);
				fflush (stdin); getchar ( ); return (0x00);
			}
			bool Warning = FALSE;
			FILE *File;
			if (FirstData == TRUE)
			{
				snprintf (T,0x1000,"%s\\Art %s.bin", OutFolder, FirstName);
			}
			else
			{
				snprintf (T,0x1000,"%s\\Art %s.bin", OutFolder, ent->d_name);
			}
			File = fopen (T, "wb");
			int LinePos [Image.SizeY] [2] = { 0 }; int LinePos_Loc = 0;
			int Longest = 0;
			int TotalSize = 0;
			for (int Y = 0; Y < Image.SizeY; Y++)
			{
				LinePos [LinePos_Loc] [0] = ftell (File);
				if (LinePos [LinePos_Loc] [0] >= 0x10000 && Warning == FALSE)
				{
					Warning = TRUE;
					printf ("    WARNING, Art is going to be larger than $FFFF\n");
				}
				int X = 0; for (X = 0; X < Image.SizeX; X++)
				{
					if (Image.Data [X + (Y * Image.SizeX)].Alpha != 0xFF) { break; }
				}
				int StartX = X;
				if (X < Image.SizeX)
				{
					char Byte = Image.Data [X++ + (Y * Image.SizeX)].Alpha;
					bool Break = FALSE;
					for ( ; X <= Image.SizeX && Break == FALSE; X++)
					{
						Byte = (Byte << 4);
						if (Image.Data [X + (Y * Image.SizeX)].Alpha == 0xFF || X >= Image.SizeX)
						{
							Byte |= (Byte >> 4) & 0x0F;
							Break = TRUE;
							X--;
						}
						else
						{
							Byte |= Image.Data [X + (Y * Image.SizeX)].Alpha;
						}
						fputc (Byte, File);
					}
				}
				LinePos [LinePos_Loc] [1] = X - StartX;
				LinePos [LinePos_Loc++] [0] += X - StartX;
				TotalSize += (X - StartX);
				if ((X - StartX) > Longest)
				{
					Longest = (X - StartX);
				}
			}
			fclose (File);
			if (FirstData == TRUE)
			{
				TotalSize /= 2;
				//printf ("%0.8X\n", (TotalSize / 2));
				snprintf (T,0x1000,"%s\\_Equates.asm", OutFolder);
				File = fopen (T, "wb");
				snprintf (T,0x1000,    "DE_DEVILARTSIZE		= $%0.4X\r\n", TotalSize);	fputs (T, File);
				snprintf (T,0x1000,    "DE_DEVILSECTSIZE	= $%0.4X\r\n", TotalSize / 2);	fputs (T, File);
				snprintf (T,0x1000,    "DE_DEVILSTREAM		= $%0.4X\r\n", (TotalSize / 8) / 2);	fputs (T, File);
				snprintf (T,0x1000,    "DE_DEVILLONGEST		= $%0.4X\r\n", Longest);	fputs (T, File);
				fclose (File);
			}
			if (FileCount == 0)
			{
				for (int S = 0; S < 2; S++)
				{
					int ArtStartLoc = 0;
					snprintf (T,0x1000,"%s\\_Line Info %d.bin", OutFolder, S + 1);
					File = fopen (T, "wb");
					for (int Y = 0; Y < 8; Y += 2)
					{
						for (int P = 0; P < Image.SizeY; P += 8)
						{
						//	fputc (LinePos [P+Y+S] [0] >> 0x18, File);
						//	fputc (LinePos [P+Y+S] [0] >> 0x10, File);
						//	fputc (LinePos [P+Y+S] [0] >> 0x08, File);
						//	fputc (LinePos [P+Y+S] [0] >> 0x00, File);
						//	fputc (LinePos [P+Y+S] [1] >> 0x18, File);
						//	fputc (LinePos [P+Y+S] [1] >> 0x10, File);
						//	fputc (LinePos [P+Y+S] [1] >> 0x08, File);
						//	fputc (LinePos [P+Y+S] [1] >> 0x00, File);


						/* divu version */

						//	char Byte = (LinePos [P+Y+S] [1] / 2) & 0xFF;
						//	fputc (Byte, File);
						//	fputc (Byte, File);

						/* mulu version */

						//	fputc ((LinePos [P+Y+S] [1] / 2) >> 0x08, File);
						//	fputc ((LinePos [P+Y+S] [1] / 2) >> 0x00, File);

							char Byte = (LinePos [P+Y+S] [1] / 2) & 0xFF;
							fputc (Byte, File);
							fputc (Byte, File);


							int ArtLoc = LinePos [P+Y+S] [0] - ArtStartLoc;
							ArtStartLoc = LinePos [P+Y+S] [0];
							fputc (ArtLoc >> 8, File);
							fputc (ArtLoc >> 0, File);

						}
					}
					fputc (0x00, File);
					fputc (0x00, File);
					fclose (File);
				}

			/*	snprintf (T,0x1000,"%s\\_Line Info.bin", OutFolder);
				File = fopen (T, "wb");
				for (int Loc = 0; Loc < Image.SizeY; Loc++)
				{
				//	fputc (LinePos [Loc] [1] >> 0x18, File);
				//	fputc (LinePos [Loc] [1] >> 0x10, File);
					fputc (LinePos [Loc] [1] >> 0x08, File);
					fputc (LinePos [Loc] [1] >> 0x00, File);
				//	fputc (LinePos [Loc] [0] >> 0x18, File);
				//	fputc (LinePos [Loc] [0] >> 0x10, File);
					fputc (LinePos [Loc] [0] >> 0x08, File);
					fputc (LinePos [Loc] [0] >> 0x00, File);
				}
				fputc (0xFF, File);
				fputc (0xFF, File);
				fclose (File);	*/



				char *Mappings = (char*) calloc (((Image.SizeY + 7) / 8) * (((Longest + 7) / 8) * 2) * 2, sizeof (char));
				int MapLoc = 0;
				u_short Word = 0;
				for (int Y = 0; Y < Image.SizeY; )
				{
					int Width = 0;
					for (int YT = 0; YT < 8; YT++)
					{
						if (LinePos [Y] [1] > Width) { Width = LinePos [Y] [1]; } Y++;
					}
					Width = (Width + 7) / 8;
					int TotalL = (((Longest + 7) / 8) - Width);
					int TotalR = (((Longest + 7) / 8) - Width);
					while (--TotalL >= 0)
					{
						Mappings [MapLoc++] = 0;
						Mappings [MapLoc++] = 0;
					}
					int WidthR = Width;
					while (--Width >= 0)
					{
						Word++;
						Mappings [MapLoc++] = Word >> 8;
						Mappings [MapLoc++] = Word;
					}
					u_short WordR = Word ^ 0x800;
					while (--WidthR >= 0)
					{
						Mappings [MapLoc++] = WordR >> 8;
						Mappings [MapLoc++] = WordR;
						--WordR;
					}
					while (--TotalR >= 0)
					{
						Mappings [MapLoc++] = 0;
						Mappings [MapLoc++] = 0;
					}
				}
				EniComp (Mappings, MapLoc);
				snprintf (T,0x1000,"%s\\_Map Data.eni", OutFolder);
				File = fopen (T, "wb");
				fwrite (Mappings, sizeof (char), MapLoc, File);	// Compressed mappings
				fputc (((Longest + 7) / 8) * 2, File);		// Width
				fputc (((Image.SizeY + 7) / 8), File);		// Height
				free (Mappings); Mappings = NULL;
				fclose (File);
			}
			if (FirstData == FALSE)
			{
				free (Image.Data); Image.Data = NULL;
			}
			FileCount++;
			FirstData = FALSE;
		}
		while ((ent = readdir (dir)) != NULL);
		free (Merge.Data); Merge.Data = NULL;
	}

	FILE *File;

	snprintf (T,0x1000,"%s\\_Palette.bin", OutFolder);
	if ((File = fopen (T, "wb")) == NULL)
	{
		printf ("Error, could not save palette\n");
		fflush (stdin); getchar ( ); return (0x00);
	}
	fputc (0x00, File);
	fputc (0x00, File);
	for (int Loc = 2; Loc < PalSize * 2; Loc++)
	{
		fputc (PalBin [Loc], File);
	}
	fclose (File);

	printf ("\n");
	if (ArgNumber > 1)
	{
		if (strcmp (ArgList [1], "1") == 0)
		{
			return (0);
		}
	}
	printf ("Press enter key to exit...\n");
	fflush (stdin); getchar ( ); return (0);
}

// =============================================================================