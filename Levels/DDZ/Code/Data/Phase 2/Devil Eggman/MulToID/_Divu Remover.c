// =============================================================================
// -----------------------------------------------------------------------------
// Divu remover...
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <windows.h>
#include <dirent.h>

// =============================================================================
// -----------------------------------------------------------------------------
// 
// -----------------------------------------------------------------------------

int main (int ArgNumber, char **ArgList, char **EnvList)

{
	printf ("Divu Remover - by MarkeyJester\n\n");
	FILE *File = fopen ("DivToMul.bin", "rb");
	if (File == NULL)
	{
		printf ("Error, could not find \"DivToMul.bin\"\n");
		printf ("Press enter key to exit...\n");
		fflush (stdin); getchar ( ); return (0);
	}
	fseek (File, 0, SEEK_END);
	int Size = ftell (File) / 2;
	rewind (File);
	unsigned char Mark [0x101] = { 0 };
	unsigned short DivToMul [Size] = { 0 };
	for (int Loc = 0; Loc < Size; Loc++)
	{
		unsigned short Word = fgetc (File) << 8;
		Word |= (fgetc (File) & 0xFF);
		DivToMul [Loc] = Word;
		if (Word > 0x100) { continue; }
		Mark [Word] |= 0xFF;
	}
	fclose (File);

	unsigned char ID [0x101] = { 0 };
	unsigned short Value [0x101] = { 0 };
	int MaxID = 0;
	for (int Loc = 0; Loc < 0x101; Loc++)
	{
		if (Mark [Loc] == 0) { continue; }
		ID [Loc] = MaxID;
		Value [MaxID++] = Loc;
	}

	if ((File = fopen ("MulToID.bin", "wb")) == NULL)
	{
		printf ("Error, could not create \"MulToID.bin\"\n");
		printf ("Press enter key to exit...\n");
		fflush (stdin); getchar ( ); return (0);
	}
	for (int Loc = 0; Loc < 0x101; Loc++)
	{
		fputc (ID [Loc], File);
	}
	fclose (File);


	const char List [] = {	"../Include/Output/_Line Info 1.bin\0"
				"../Include/Output/_Line Info 2.bin\0"	};

	int MaxRange = 0;	// render range largest value
	const char *ListPos = List;
	while (*ListPos != 0)
	{
		char T [0x100];
		ListPos = &ListPos [snprintf (T,0x100,"%s", ListPos) + 1];
		if ((File = fopen (T, "rb")) == NULL)
		{
			printf ("Error, could not open:\n\n  \"%s\"\n\n");
			printf ("Press enter key to exit...\n");
			fflush (stdin); getchar ( ); return (0);
		}
		fseek (File, 0, SEEK_END);
		int Size = ftell (File) - 2;
		for (int Loc = 0; Loc < Size; Loc += 4)
		{
			fseek (File, Loc, SEEK_SET);
			unsigned char Byte = fgetc (File);
			if (Byte > MaxRange) { MaxRange = Byte; }
		}
		fclose (File);
	}

	if (MaxRange > MaxID)
	{
		printf ("Note!  MaxRange is larger than MaxID, might\n"
			"be able to swap them for a smaller table~\n");
	}

	Size = (MaxRange + 1) << 8;

	if ((File = fopen ("MulSwap.bin", "wb")) == NULL)
	{
		printf ("Error, could not create \"MulSwap.bin\"\n");
		printf ("Press enter key to exit...\n");
		fflush (stdin); getchar ( ); return (0);
	}
	unsigned char Table [Size] = { 0 };
	for (int LocRange = 0; LocRange <= MaxRange; LocRange++)
	{
		for (int LocID = 0; LocID <= 0xFF; LocID++)
		{
			fputc ((LocRange * Value [LocID]) >> 8, File);
		}
	}
	fclose (File);


	printf (" -> Finished...\n\n");
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
