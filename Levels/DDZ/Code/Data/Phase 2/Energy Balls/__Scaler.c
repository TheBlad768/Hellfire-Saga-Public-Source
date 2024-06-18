// =============================================================================
// -----------------------------------------------------------------------------
// 
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <windows.h>
#include "..\..\..\..\..\..\_Headers\_bitmapx.h"

// =============================================================================
// -----------------------------------------------------------------------------
// 
// -----------------------------------------------------------------------------

int main (int ArgNumber, char **ArgList, char **EnvList)

{
	IMG Main1, Main2, Image;
	int RetLoad = ImageLoad (Main1, "Main 1.png");
	if (RetLoad != ERR_BX_SUCCESS)
	{
		printf ("\"Main 1.png\"\n");
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
	RetLoad = ImageLoad (Main2, "Main 2.png");
	if (RetLoad != ERR_BX_SUCCESS)
	{
		free (Main1.Data); Main1.Data = NULL;
		printf ("\"Main 2.png\"\n");
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

	//int ScaleSpeeds [] = {	 0x08,  0x10,  0x18,  0x20,  0x28,  0x30,  0x38,  0x40,
	//			0x050, 0x060, 0x070, 0x080, 0x0C0, 0x100, 0x180, 0X200	};
	//int ScaleSlot = 0;
	int ScaleSpeed = 0x20;
	for (int Scale = ScaleSpeed; Scale < 0x200; Scale += ScaleSpeed)

	//for (int Scale = ScaleSpeeds [ScaleSlot]; Scale < 0x200; Scale = ScaleSpeeds [++ScaleSlot])
	{
		Image = Main1;
		for (int Rep = 0; Rep < 2; Rep++)
		{
			PIX_BGRA *Main = Image.Data;
			Image.Data = (PIX_BGRA*) malloc (Image.Size * sizeof (PIX_BGRA));
			memcpy (Image.Data, Main, Image.Size * sizeof (PIX_BGRA));

			PIX_BGRA PadColour = Image.Data [0];

			int NewSizeX = (Image.SizeX << 8) / (Scale + 0x100);
			int NewSizeY = (Image.SizeY << 8) / (Scale + 0x100);
			int OldSizeX = Image.SizeX;
			int OldSizeY = Image.SizeY;
			PerformResize (Image, NewSizeX, NewSizeY, FALSE);

			TruncateImage (Image, 0, 0, OldSizeX, OldSizeY, PadColour);
			TruncateImage (Image, -((OldSizeX-NewSizeX)/2), -((OldSizeY-NewSizeY)/2), Image.SizeX-((OldSizeX-NewSizeX)/2), Image.SizeY-((OldSizeY-NewSizeY)/2), PadColour);

			char T [0x100];
			snprintf (T, 0x100, "Z Out %0.4X %d.png", Scale, Rep);
			int RetSave = ImageSave (Image, T, "png");
			if (RetSave != ERR_BX_SUCCESS)
			{
				free (Main1.Data); Main1.Data = NULL;
				free (Main2.Data); Main2.Data = NULL;
				free (Image.Data); Image.Data = NULL;
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
			Image = Main2;
		}
	}
	free (Main1.Data); Main1.Data = NULL;
	free (Main2.Data); Main2.Data = NULL;

	printf ("Press enter key to exit...\n");
	fflush (stdin); getchar ( ); return (0);
}

// =============================================================================
