/-------------------------------------------------------------------------------------\
| KENS - Kosinski / Enigma / Nemesis / Saxman Compression and Decompression Libraries |
| Copyright © 2002-2004 The KENS Project Development Team			      |
|-------------------------------------------------------------------------------------|
| The KENS Project Development Team (contributors are considered as members)	      |
|    David "Magus" Declerck	ChaosIsLight@aol.com				      |
|    Roger "Nemesis" Sanders	nemesis2k2hacker@hotmail.com			      |
|    Damian "Saxman" Grove	saxman@shentel.net				      |
|    Brett Kosinski		brettk@gpu.srv.ualberta.ca			      |
|    Korama			amarokorama@msn.com				      |
|    Ultima			ultima@shadowsoft-games.com			      |
\-------------------------------------------------------------------------------------/


 /------------\
| Introduction |
 \------------/

KENS is a group of four libraries that allow to compress and decompress data using the Kosinski, Enigma, Nemesis and Saxman compression formats. These libraries, programmed using Visual C++, can be easily used from your applications, even from Visual Basic and Game Maker applications.

KENS is being distributed under LGPL. For more info about the LGPL, read LICENSE.TXT.


 /-------------------\
| Function parameters |
 \-------------------/

* Common to all decompression functions:
Each decompression function requires two files to be passed as parameters, aswell as a pointer. The source file is the ROM from which you want to extract the data, the destination file is a new file that will receive the decompressed data. The pointer is the location in the ROM where to start decompressing from.

* Common to all compression functions:
Each compression function requires two files to be passed as parameters. The source file is the file that contains the data you want to compress, the destination file is a new file that will receive the compressed data. You will then have to put the file into the ROM by yourself. This was done this way to prevent the compressor from overwriting ROM data.

* Specific to Enigma compression and decompression functions:
The Enigma compression and decompression functions require an additionnal parameter to be passed. This parameter indicates whether or not to add or remove padding when decompressing or compressing. When decompressing a S1 special stage, you might want to add padding to the decompressed file, in some cases. You will then have to remove padding from the file when recompressing it. Otherwise, you mustn't use padding.

* Specific to Kosinski compression and decompression functions:
The Kosinski compression and decompression functions require an additionnal parameter to be passed. This parameter indicates whether the data will be compressed or decompressed using the Moduled Kosinski format instead of the Standard Kosinski format. The Moduled Kosinski format MUST be used when compressing or decompressing S3K level art, and it is sometimes used to compress some pieces of art in the ROM.

* Specific to Kosinski extended compression function:
The Kosinski extended compression function allows to specify a custom reccurence length and sliding window when compressing. This might in some cases allow to save 2 or 3 bytes, or it can also speed up compression if you specify values smaller than the default ones (Default values: SW = 8192, RL = 256). Game Maker applications can not call this function because of the restriction on the number of parameters.

* Specific to Saxman decompression function:
The Saxman decompression function requires an additional parameter to be passed. This parameter allows you to specify a custom data size if the data you want to decompress does not contain its own size. This is the case for the Sonic 2 Sound Driver, so you will have to specify the value by yourself (for info, the Sonic 2 Sound Driver is 0x0F64 in size). If you specify 0 as the size, the decompressor will read the size from the compressed data.

* Specific to Saxman compression function:
The Saxman compression function requires an additional parameter to be passed. This parameter allows you to tell whether or not you want the size of the compressed data to be included in the output file. In most cases, you should pass 'true'; the exception is when you are compressing the Sonic 2 Sound Driver, in this case you must pass 'false'. Also, remember that, if you want to put back a recompressed sound driver to the ROM, you will have to write the size of the compressed file *plus* one at 0x0EC050 (big endian word).


 /---------------------------------\
| Using the KENS Libraries in C/C++ |
 \---------------------------------/

Include the Kosinski.h, Enigma.h, Nemesis.h or Saxman.h files into any file that calls the compression / decompression routines. Alternatively, you can just include KENS.h, which contains the definitions of all these four files. Then, you have to call KInit, EInit, NInit or SInit before using any of the routines (these functions are used to initialize the pointers to the routines).


 /----------------------------------\
| Using the KENS Libraries in Delphi |
 \----------------------------------/

Include the unit KENS into the "uses" clause of any unit that calls the compression / decompression functions. In KENS.pas, there's a compiler switch "DynamicLinking", which controls whether the KENS DLLs are imported statically (when your program starts up) or dynamically (during runtime of your program). If "DynamicLinking" is disabled, your program won't load if one of the used KENS DLLs is missing. If "DynamicLinking" is enabled (default), then you have to call KInit, EInit, NInit or SInit and check the return value before using any of the routines (these functions are used to load the DLLs at runtime and initialize the pointers to the routines). 


 /---------------------------------------------\
| Using the KENS Libraries in Visual Basic (5+) |
 \---------------------------------------------/

Copy / paste the required declarations at the begining of a module:

Kosinski:
Declare Function KComp Lib "Kosinski.dll" Alias "VBComp" (ByVal Source As Variant, ByVal Destination As Variant, ByVal Moduled As Boolean) As Long
Declare Function KDecomp Lib "Kosinski.dll" Alias "VBDecomp" (ByVal Source As Variant, ByVal Destination As Variant, ByVal Pointer As Long, ByVal Moduled As Boolean) As Long
Declare Function KCompEx Lib "Kosinski.dll" Alias "VBCompEx" (ByVal Source As Variant, ByVal Destination As Variant, ByVal SlideWin As Long, ByVal RecLen As Long, ByVal Moduled As Boolean) As Long

Enigma:
Declare Function EComp Lib "Enigma.dll" Alias "VBComp" (ByVal Source As Variant, ByVal Destination As Variant, ByVal Padding As Boolean) As Long
Declare Function EDecomp Lib "Enigma.dll" Alias "VBDecomp" (ByVal Source As Variant, ByVal Destination As Variant, ByVal Pointer As Long, ByVal Padding As Boolean) As Long

Nemesis:
Declare Function NComp Lib "Nemesis.dll" Alias "VBComp" (ByVal Source As Variant, ByVal Destination As Variant) As Long
Declare Function NDecomp Lib "Nemesis.dll" Alias "VBDecomp" (ByVal Source As Variant, ByVal Destination As Variant, ByVal Pointer As Long) As Long

Saxman:
Declare Function SComp Lib "Saxman.dll" Alias "VBComp2" (ByVal Source As Variant, ByVal Destination As Variant, ByVal WithSize As Boolean) As Long
Declare Function SDecomp Lib "Saxman.dll" Alias "VBDecomp2" (ByVal Source As Variant, ByVal Destination As Variant, ByVal Pointer As Long, ByVal Size As Long) As Long


 /--------------------------------------\
| Using the KENS Libraries in Game Maker |
 \--------------------------------------/

Declare the functions as follows:

Kosinski:
external_define('Kosinski.dll', 'GMComp', dll_cdecl, ty_real, 3, ty_string, ty_string, ty_real);
external_define('Kosinski.dll', 'GMDecomp', dll_cdecl, ty_real, 4, ty_string, ty_string, ty_real, ty_real);

The first parameter is a string representing the source file. The second parameter is a string representing the destination file. In the decompression function, the third parameter is a real indicating the offset to start decompressing from. The last parameter in both functions indicates whether or not to use the Moduled Kosinski compression (specify 0 for Standard Kosinski compression and 1 or above for Moduled Kosinski compression).

Enigma:
external_define('Enigma.dll', 'GMComp', dll_cdecl, ty_real, 3, ty_string, ty_string, ty_real);
external_define('Enigma.dll', 'GMDecomp', dll_cdecl, ty_real, 4, ty_string, ty_string, ty_real, ty_real);

The first parameter is a string representing the source file. The second parameter is a string representing the destination file. In the decompression function, the third parameter is a real indicating the offset to start decompressing from. The last parameter in both functions indicates whether or not to add or remove the padding (specify 0 for No Padding and 1 or above for Padding).

Nemesis:
external_define('Nemesis.dll', 'GMComp', dll_cdecl, ty_real, 2, ty_string, ty_string);
external_define('Nemesis.dll', 'GMDecomp', dll_cdecl, ty_real, 3, ty_string, ty_string, ty_real);

The first parameter is a string representing the source file. The second parameter is a string representing the destination file. In the decompression function, the third parameter is a real indicating the offset to start decompressing from.

Saxman:
external_define('Saxman.dll', 'GMComp2', dll_cdecl, ty_real, 3, ty_string, ty_string, ty_real);
external_define('Saxman.dll', 'GMDecomp2', dll_cdecl, ty_real, 4, ty_string, ty_string, ty_real, ty_real);

The first parameter is a string representing the source file. The second parameter is a string representing the destination file. In the compression function, the third parameter indicates whether or not to add the size of the compressed file to the output (specify 0 for No Size and 1 or above for Size). In the decompression function, the third parameter is a real indicating the offset to start decompressing from. The fourth parameter indicates a custom size (specify 0 if you want the decompressor to read the size from the compressed data, otherwise specify a value above 0).
