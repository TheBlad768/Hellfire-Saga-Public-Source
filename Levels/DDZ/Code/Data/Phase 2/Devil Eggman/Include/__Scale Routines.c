// =============================================================================
// -----------------------------------------------------------------------------
// Scale routine generator
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <direct.h>
#include <string.h>

#ifndef FALSE
	#define FALSE (1 != 1)
	#define TRUE (!FALSE)
#endif

const char MacroASM68K [] = {

	"DEDS_ScaleH	macro	SCALE\r\n"
	"COUNT = SCALE+$10000\r\n"
	"SCALESPEED = (COUNT*2)\r\n"
	"POS = SCALESPEED*(DE_DEVILLONGEST/2)\r\n"
	"SLOT = 0\r\n"
	"	rept	(DE_DEVILLONGEST/2)-((DE_DEVILLONGEST/2)<<$10)/COUNT\r\n"
	"SLOT = (SLOT+1)&3\r\n"
	"POS = POS-SCALESPEED\r\n"
	"	endr\r\n"
	"	rept	((DE_DEVILLONGEST/2)<<$10)/COUNT\r\n"
	"		if SLOT<2\r\n"
	"			move.b	-(POS>>$10)(a1),(a3)+\r\n"
	"		else\r\n"
	"			move.b	-(POS>>$10)(a1),(a4)+\r\n"
	"		endif\r\n"
	"SLOT = (SLOT+1)&3\r\n"
	"POS = POS-SCALESPEED\r\n"
	"	endr\r\n"
	"		jmp	(a5)\r\n"
	"		endm\r\n"

	};

const char MacroAS [] = {

	"DEDS_ScaleH	macro	SCALE\r\n"
	"COUNT := SCALE+$10000\r\n"
	"SCALESPEED := (COUNT*2)\r\n"
	"POS := SCALESPEED*(DE_DEVILLONGEST/2)\r\n"
	"SLOT := 0\r\n"
	"	rept	(DE_DEVILLONGEST/2)-((DE_DEVILLONGEST/2)<<$10)/COUNT\r\n"
	"SLOT := (SLOT+1)&3\r\n"
	"POS := POS-SCALESPEED\r\n"
	"	endr\r\n"
	"	rept	((DE_DEVILLONGEST/2)<<$10)/COUNT\r\n"
	"		if SLOT<2\r\n"
	"			move.b	-(POS>>$10)(a1),(a3)+\r\n"
	"		else\r\n"
	"			move.b	-(POS>>$10)(a1),(a4)+\r\n"
	"		endif\r\n"
	"SLOT := (SLOT+1)&3\r\n"
	"POS := POS-SCALESPEED\r\n"
	"	endr\r\n"
	"		rts\r\n"
	"		endm\r\n"

	};

// =============================================================================
// -----------------------------------------------------------------------------
// Entry point
// -----------------------------------------------------------------------------

int main (int ArgNumber, char **ArgList, char **EnvList)

{
	printf ("Scale Routines - by MarkeyJester\n");
	if (ArgNumber <= 1)
	{
		printf ("\n"
			"    Because AS takes forever to process the macro (due to multi-passes)\n"
			"    This will creat the macro source for assembly with asm68k, which can\n"
			"    then be bincluded with AS\n");
	}
	char T [0x1000];
	FILE *File = fopen ("_ScaleH.asm", "wb");

	fputs ("\r\n	include	\"Output/_Equates.asm\"\r\n\r\n", File);

	fputs (MacroASM68K, File);

	int Steps = 0x400;
	int Total = 0x7F0000/Steps;


	fputs ("\r\nDEDS_SH_List:\r\n", File);
	for (int Loc = 0; Loc < Total; Loc++)
	{
		snprintf (T,0x1000,	"		dc.l	DEDS_SH_%0.6X-2\r\n", Loc*Steps); fputs (T, File);
	}
	fputs ("\r\n		", File);
	for (int Loc = 0; Loc < Total; Loc++)
	{
		snprintf (T,0x1000,	"DEDS_ScaleH	$%0.8X\r\n"
					"DEDS_SH_%0.6X:	", Loc*Steps, Loc*Steps);
		fputs (T, File);
	}

	fclose (File);

	printf ("\n -> Finished...\n\n");
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