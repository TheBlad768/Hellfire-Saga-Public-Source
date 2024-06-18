// =============================================================================
// -----------------------------------------------------------------------------
// 
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <windows.h>
#include <dirent.h>
#include "..\..\..\..\..\..\_Headers\_bitmapx.h"

const char OutFolder [] = { "Include" };

char MainList [] = {	"_Body.png\0"
			"_Biceps.png\0"
			"_Arms.png\0"	};

IMG Body, Biceps, Arms;
IMG ImageList [3];

int WobbleBody [] = {	-1, -2, -2, -1, -1, +0, +0, +1, +1, +2, +1, +0,		0, 0, 0, 0, 0, 0, 0, 0 };
int WobbleBiceps [] = {	-0, -1, -1, -1, -0, +0, +0, +1, +1, +1, +0, +0,		0, 0, 0, 0, 0, 0, 0, 0 };
int WobbleArms [] = {	-1, -1, -1, -1, -1, +0, +1, +1, +1, +1, +1, +0,		0, 0, 0, 0, 0, 0, 0, 0 };
//int WobbleArms [] = {	-1, -2, -3, -2, -1, +0, +1, +2, +3, +4, +3, +1,		0, 0, 0, 0, 0, 0, 0, 0 };

// =============================================================================
// -----------------------------------------------------------------------------
// 
// -----------------------------------------------------------------------------

int main (int ArgNumber, char **ArgList, char **EnvList)

{
	int ImageListLoc = 0;
	char T [0x1000];
	char *Main = MainList;
	printf ("Reading main files:\n\n");
	ImageList [0] = Body;
	ImageList [1] = Biceps;
	ImageList [2] = Arms;
	while (*Main != 0)
	{
		printf (" -> %s\n", Main);
		int RetLoad = ImageLoad (ImageList [ImageListLoc], Main);
		if (RetLoad != ERR_BX_SUCCESS)
		{
			while (ImageListLoc != 0) { free (ImageList [--ImageListLoc].Data); }
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
		Main += snprintf (T,0x1000,"%s", Main) + 1;
		ImageListLoc++;
	}
	Body	= ImageList [0];
	Biceps	= ImageList [1];
	Arms	= ImageList [2];


	for ( ; ; )
	{
		char Folder [0x1000];
		int FolderLoc = 0;
		for (int Loc = 0; ArgList [0] [Loc] != 0; Loc++) { Folder [Loc] = ArgList [0] [Loc]; if (ArgList [0] [Loc] == '\\' || ArgList [0] [Loc] == '/') { FolderLoc = Loc + 1; } };
		Folder [FolderLoc] = 0;
		FolderLoc += snprintf (&Folder [FolderLoc], 0x1000-FolderLoc, "/%s", OutFolder);
		DIR *dir;
		struct dirent *ent;
		dir = opendir (Folder);
		char Direct [0x1000];
		int DirectLoc = 0, DirectSize = 0;
		if (dir == NULL)
		{
			printf ("Error, Could not open directory:\n\"%s\"", Folder);
			fflush (stdin); getchar ( ); return (0);
		}
		else
		{
			int Frame = 0;
			int FileCount = 0;
			printf ("\nErasing files:\n\n");
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
				if (*ent->d_name == '_') { continue; }
				snprintf (Direct, 0x1000, "%s/%s", Folder, ent->d_name);
				ent->d_name [ExtLoc - 1] = 0;
				printf (" -> %s \n", ent->d_name);
				remove (Direct);
			}
		}
		break;
	}

	char Folder [0x1000];
	int FolderLoc = 0;
	for (int Loc = 0; ArgList [0] [Loc] != 0; Loc++) { Folder [Loc] = ArgList [0] [Loc]; if (ArgList [0] [Loc] == '\\' || ArgList [0] [Loc] == '/') { FolderLoc = Loc + 1; } };
	Folder [FolderLoc] = 0;
	DIR *dir;
	struct dirent *ent;
	dir = opendir (Folder);
	char Direct [0x1000];
	int DirectLoc = 0, DirectSize = 0;
	if (dir == NULL)
	{
		printf ("Error, Could not open directory:\n\"%s\"", Folder);
		fflush (stdin); getchar ( ); return (0);
	}
	else
	{
		int Frame = 0;
		int FileCount = 0;
		printf ("\nProcessing files:\n\n");
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
			if (*ent->d_name == '_') { continue; }
			snprintf (Direct, 0x1000, "%s%s", Folder, ent->d_name);
			ent->d_name [ExtLoc - 1] = 0;
			printf (" -> %s \n", ent->d_name);

			IMG Image;
			int RetLoad = ImageLoad (Image, Direct);
			if (RetLoad != ERR_BX_SUCCESS)
			{
				while (ImageListLoc != 0) { free (ImageList [--ImageListLoc].Data); }
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
			for (int Y = 0; Y < Image.SizeY; Y++)
			{
				for (int X = 0, XD = Image.SizeX - 1; X < Image.SizeX / 2; X++, XD--)
				{
					Image.Data [XD + (Y * Image.SizeX)] = Image.Data [X + (Y * Image.SizeX)];
				}
			}

			// --- Body fuse ---

			for (int Loc = 0; Loc < Image.Size; Loc++)
			{
				Image.Data [Loc].Alpha = 0xFF;
				if (	Body.Data [Loc].Blue  == 0xFF	&&
					Body.Data [Loc].Green == 0x00	&&
					Body.Data [Loc].Red   == 0xFF )
				{
					Image.Data [Loc].Blue  = 0x80;
					Image.Data [Loc].Green = 0x00;
					Image.Data [Loc].Red   = 0x00;
					continue;
				}
				if (	Body.Data [Loc].Blue  == 0x80	&&
					Body.Data [Loc].Green == 0x00	&&
					Body.Data [Loc].Red   == 0x00 ) { continue; }
				Image.Data [Loc] = Body.Data [Loc];
				Image.Data [Loc].Alpha = 0xFF;
			}


			// --- Biceps fuse ---

			for (int Y = 0; Y < Image.SizeY; Y++)
			{
				for (int X = 0; X < Image.SizeX; X++)
				{
					int Src = Y + WobbleBiceps [Frame];
					if (Src >= Biceps.SizeY) { break; }
					if (Src < 0) { Y -= Src; Src = 0; }
					Src = (Src * Biceps.SizeX) + X;
					int Loc = X + (Y * Image.SizeX);
					Image.Data [Loc].Alpha = 0xFF;
					if (	Biceps.Data [Src].Blue  == 0x80	&&
						Biceps.Data [Src].Green == 0x00	&&
						Biceps.Data [Src].Red   == 0x00 ) { continue; };
					Image.Data [Loc] = Biceps.Data [Src];
					Image.Data [Loc].Alpha = 0xFF;
				}
			}

			// --- Make separate version ---

			IMG ImageArms;
			ImageArms = Image;
			ImageArms.Data = (PIX_BGRA*) malloc (ImageArms.Size * sizeof (PIX_BGRA));
			memcpy (ImageArms.Data, Image.Data, ImageArms.Size * sizeof (PIX_BGRA));

			// --- Arms fuse ---

			for (int Y = 0; Y < ImageArms.SizeY; Y++)
			{
				for (int X = 0; X < ImageArms.SizeX; X++)
				{
					int Src = Y + WobbleArms [Frame];
					if (Src >= Arms.SizeY) { break; }
					if (Src < 0) { Y -= Src; Src = 0; }
					Src = (Src * Arms.SizeX) + X;
					int Loc = X + (Y * ImageArms.SizeX);
					ImageArms.Data [Loc].Alpha = 0xFF;
					if (	Arms.Data [Src].Blue  == 0x80	&&
						Arms.Data [Src].Green == 0x00	&&
						Arms.Data [Src].Red   == 0x00 ) { continue; };
					ImageArms.Data [Loc] = Arms.Data [Src];
					ImageArms.Data [Loc].Alpha = 0xFF;
				}
			}

			// --- Body wobble ---

			PIX_BGRA PadColour = Image.Data [0];

	// DO A TRUNCATE HERE TO CREATE UP/DOWN FLAPPING MOVEMENT
	// use WobbleBody...

		TruncateImage (Image, 0, WobbleBody [Frame], Image.SizeX, Image.SizeY + WobbleBody [Frame], PadColour);
		TruncateImage (ImageArms, 0, WobbleBody [Frame], ImageArms.SizeX, ImageArms.SizeY + WobbleBody [Frame], PadColour);

			// --- Tile masking/halving ---

			IMG *Slot = &Image;
			for (int Passes = 0; Passes < 2; Passes++)
			{
			    for (int YT = 0; YT < Slot->SizeY; YT += 8)
			    {
				for (int XT = 0; XT < Slot->SizeX; XT += 8)
				{
					bool FAIL = FALSE;
					for (int Y = 0; Y < 8; Y++)
					{
						for (int X = 0; X < 8; X++)
						{
							int Loc = (XT + X) + ((YT + Y) * Slot->SizeX);
							if (	Slot->Data [Loc].Blue  != 0x80	||
								Slot->Data [Loc].Green != 0x00	||
								Slot->Data [Loc].Red   != 0x00 ) { FAIL = TRUE; break; };
						}
					}
					if (FAIL == FALSE)
					{
						for (int Y = 0; Y < 8; Y++)
						{
							for (int X = 0; X < 8; X++)
							{
								int Loc = (XT + X) + ((YT + Y) * Slot->SizeX);
								Slot->Data [Loc].Blue  = 0x00;
								Slot->Data [Loc].Green = 0x80;
								Slot->Data [Loc].Red   = 0x00;
							}
						}
					}
					else { break; }
				}
			    }
			    TruncateImage (*Slot, 0, 0, Slot->SizeX / 2, Slot->SizeY, PadColour);
			    Slot = &ImageArms;
			}

			// --- Finish ---

			snprintf (T,0x1000,"%s/No Arms %0.2d.png", OutFolder, Frame);
			int RetSave = ImageSave (Image, T, "png");
			if (RetSave != ERR_BX_SUCCESS)
			{
				while (ImageListLoc != 0) { free (ImageList [--ImageListLoc].Data); }
				free (Image.Data); Image.Data = NULL;
				free (ImageArms.Data); ImageArms.Data = NULL;
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
			free (Image.Data); Image.Data = NULL;

			snprintf (T,0x1000,"%s/Arms %0.2d.png", OutFolder, Frame);
			RetSave = ImageSave (ImageArms, T, "png");
			if (RetSave != ERR_BX_SUCCESS)
			{
				while (ImageListLoc != 0) { free (ImageList [--ImageListLoc].Data); }
				free (ImageArms.Data); ImageArms.Data = NULL;
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
			free (ImageArms.Data); ImageArms.Data = NULL;

			Frame++;
		}
	}
	while (ImageListLoc != 0) { free (ImageList [--ImageListLoc].Data); }

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
