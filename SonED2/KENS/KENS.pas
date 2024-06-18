{---------------------------------------------------------------------------*\
|                                                                            |
| Kosinski.dll, Enigma.dll, Nemesis.dll, Saxman.dll: Compression and         |
| Decompression of data in Kosinski, Enimga, Nemesis and Saxman formats      |
| Copyright © 2002-2004 The KENS Project Development Team                    |
|                                                                            |
| This library is free software; you can redistribute it and/or              |
| modify it under the terms of the GNU Lesser General Public                 |
| License as published by the Free Software Foundation; either               |
| version 2.1 of the License, or (at your option) any later version.         |
|                                                                            |
| This library is distributed in the hope that it will be useful,            |
| but WITHOUT ANY WARRANTY; without even the implied warranty of             |
| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU          |
| Lesser General Public License for more details.                            |
|                                                                            |
| You should have received a copy of the GNU Lesser General Public           |
| License along with this library; if not, write to the Free Software        |
| Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA  |
|                                                                            |
\*---------------------------------------------------------------------------}
unit KENS;

{ C Header to Delphi Unit conversion by S.O. (amarokorama@msn.com)
  Version 1.0, 05.03.2004

  Note: There's one compiler switch, "DynamicLinking".
  If it is defined, Delphi KENS works just like the C version. That means you
  have to call "XInit" and check its return value before you are safe to use
  the "XComp" and "XDecomp" funtions.
  If "DynamicLinking" is not defined, then the KENS DLLs that are used by your
  Delphi program are statically imported, which means that your program won't
  start up if one of the used DLLs is missing. With "DynamicLinking" disabled,
  it's safe to use the "XComp" and "XDecomp" anytime, a call to "XInit" is not
  necessary. However, you are free to call the "XInit" functions anyway, in
  this case they are just dummies that always return "True". That way, you
  don't need to change your code, regardless whether you choose to statically
  or dynamically import the KENS DLLs.

  Examples (yeah, they are a bit silly):
  1)
    SrcFileName := 'Test.txt';
    if KComp(PChar(SrcFileName), 'Kosinski.bin', False) <> SUCCESS then
      ShowMessage('ERROR! KComp failed!');

  2)
    if KInit then
    begin
      SrcFileName := 'Test.txt';
      if KComp(PChar(SrcFileName), 'Kosinski.bin', False) <> SUCCESS then
        ShowMessage('ERROR! KComp failed!');
    end
    else ShowMessage('ERROR! Could not load the Kosinski functions!');

  Example 1) is only safe when "DynamicLinking" is NOT defined, because KInit
  isn't called. Example 2) is ALWAYS fine, with or without "DynamicLinking". }


interface

// Compiler switch DynamicLinking is defined by default
{$DEFINE DynamicLinking}


{$IFDEF DynamicLinking}

uses
  Windows;

var
  KComp:   function (SrcFile, DstFile: PChar; Moduled: Boolean): Longint; cdecl;
  KDecomp: function (SrcFile, DstFile: PChar; SrcFileOffset: Longint; Moduled: Boolean): Longint; cdecl;
  KCompEx: function (SrcFile, DstFile: PChar; SlideWin, RecLen: Longint; Moduled: Boolean): Longint; cdecl;

  EComp:   function (SrcFile, DstFile: PChar; Padding: Boolean): Longint; cdecl;
  EDecomp: function (SrcFile, DstFile: PChar; SrcFileOffset: Longint; Padding: Boolean): Longint; cdecl;

  NComp:   function (SrcFile, DstFile: PChar): Longint; cdecl;
  NDecomp: function (SrcFile, DstFile: PChar; SrcFileOffset: Longint): Longint; cdecl;

  SComp:   function (SrcFile, DstFile: PChar; WithSize: Boolean): Longint; cdecl;
  SDecomp: function (SrcFile, DstFile: PChar; SrcFileOffset, Size: Longint): Longint; cdecl;

{$ELSE}

// Kosinski.dll
function KComp(SrcFile, DstFile: PChar; Moduled: Boolean): Longint; cdecl;
function KDecomp(SrcFile, DstFile: PChar; SrcFileOffset: Longint; Moduled: Boolean): Longint; cdecl;
function KCompEx(SrcFile, DstFile: PChar; SlideWin, RecLen: Longint; Moduled: Boolean): Longint; cdecl;

// Enigma.dll
function EComp(SrcFile, DstFile: PChar; Padding: Boolean): Longint; cdecl;
function EDecomp(SrcFile, DstFile: PChar; SrcFileOffset: Longint; Padding: Boolean): Longint; cdecl;

// Nemesis.dll
function NComp(SrcFile, DstFile: PChar): Longint; cdecl;
function NDecomp(SrcFile, DstFile: PChar; SrcFileOffset: Longint): Longint; cdecl;

// Saxman.dll
function SComp(SrcFile, DstFile: PChar; WithSize: Boolean): Longint; cdecl;
function SDecomp(SrcFile, DstFile: PChar; SrcFileOffset, Size: Longint): Longint; cdecl;

{$ENDIF}



function KInit(DLLName: string = ''): Boolean;
function EInit(DLLName: string = ''): Boolean;
function NInit(DLLName: string = ''): Boolean;
function SInit(DLLName: string = ''): Boolean;



const
  // some return values
  SUCCESS                           = $00;
  ERROR_UNKNOWN                     = $01;
  ERROR_SOURCE_FILE_DOES_NOT_EXIST  = $02;
  ERROR_MODULED_GREATHER_THAN_65535 = $03;  // used only by KComp


  // default DLL names
  Kosinski = 'Kosinski.dll';
  Enigma   = 'Enigma.dll';
  Nemesis  = 'Nemesis.dll';
  Saxman   = 'Saxman.dll';
  // DLL Proc Names
  CompProcName    = 'Comp';
  Comp2ProcName   = 'Comp2';
  DecompProcName  = 'Decomp';
  Decomp2ProcName = 'Decomp2';
  CompExProcName  = 'CompEx';


implementation


{$IFDEF DynamicLinking}


function KInit(DLLName: string): Boolean;
var
  hKosinski: HMODULE;
begin
  if DLLName = '' then DLLName := Kosinski;
  hKosinski := LoadLibrary(PChar(DLLName));
  Result := (hKosinski <> 0);
  if Result then
  begin
    KComp   := GetProcAddress(hKosinski, CompProcName);
    KDecomp := GetProcAddress(hKosinski, DecompProcName);
    KCompEx := GetProcAddress(hKosinski, CompExProcName);
    Result := (@KComp <> nil) and (@KDecomp <> nil) and (@KCompEx <> nil);
  end;
end;



function EInit(DLLName: string): Boolean;
var
  hEnigma: HMODULE;
begin
  if DLLName = '' then DLLName := Enigma;
  hEnigma := LoadLibrary(PChar(DLLName));
  Result := (hEnigma <> 0);
  if Result then
  begin
    EComp   := GetProcAddress(hEnigma, CompProcName);
    EDecomp := GetProcAddress(hEnigma, DecompProcName);
    Result := (@EComp <> nil) and (@EDecomp <> nil);
  end;
end;



function NInit(DLLName: string): Boolean;
var
  hNemesis: HMODULE;
begin
  if DLLName = '' then DLLName := Nemesis;
  hNemesis := LoadLibrary(PChar(DLLName));
  Result := (hNemesis <> 0);
  if Result then
  begin
    NComp   := GetProcAddress(hNemesis, CompProcName);
    NDecomp := GetProcAddress(hNemesis, DecompProcName);
    Result := (@NComp <> nil) and (@NDecomp <> nil);
  end;
end;



function SInit(DLLName: string): Boolean;
var
  hSaxman: HMODULE;
begin
  if DLLName = '' then DLLName := Saxman;
  hSaxman := LoadLibrary(PChar(DLLName));
  Result := (hSaxman <> 0);
  if Result then
  begin
    SComp   := GetProcAddress(hSaxman, Comp2ProcName);
    SDecomp := GetProcAddress(hSaxman, Decomp2ProcName);
    Result := (@SComp <> nil) and (@SDecomp <> nil);
  end;
end;



{$ELSE}

{ Externals from Kosinski.dll }

function KComp; external Kosinski name CompProcName;
function KDecomp; external Kosinski name DecompProcName;
function KCompEx; external Kosinski name CompExProcName;

{ Externals from Enigma.dll }

function EComp; external Enigma name CompProcName;
function EDecomp; external Enigma name DecompProcName;

{ Externals from Nemesis.dll }

function NComp; external Nemesis name CompProcName;
function NDecomp; external Nemesis name DecompProcName;

{ Externals from Saxman.dll }

function SComp; external Saxman name Comp2ProcName;
function SDecomp; external Saxman name Decomp2ProcName;



{ XInit dummy functions }

function KInit(DLLName: string): Boolean;
begin
  Result := True;
end;

function EInit(DLLName: string): Boolean;
begin
  Result := True;
end;

function NInit(DLLName: string): Boolean;
begin
  Result := True;
end;

function SInit(DLLName: string): Boolean;
begin
  Result := True;
end;


{$ENDIF}


end.

