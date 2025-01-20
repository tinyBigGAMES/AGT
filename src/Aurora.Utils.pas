{===============================================================================
    _
   /_\   _  _  _ _  ___  _ _  __ _
  / _ \ | || || '_|/ _ \| '_|/ _` |
 /_/ \_\ \_,_||_|  \___/|_|  \__,_|
             Game Toolkit™

 Copyright © 2024-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/AGT

 See LICENSE for licensing information
===============================================================================}

unit Aurora.Utils;

{$I Aurora.Defines.inc}

interface

uses
  WinApi.Windows,
  System.SysUtils,
  System.SyncObjs,
  System.Classes,
  System.IOUtils,
  System.Math,
  Aurora.Common;

type

  { AGT_Utils }
  AGT_Utils = class
  private const
    CTempStaticBufferSize = 4096;
  private class var
    FCriticalSection: TCriticalSection;
    Marshaller: TMarshaller;
    TempStaticBuffer: array[0..CTempStaticBufferSize - 1] of Byte;
    FAsync: TAGTAsync;
  private
    class constructor Create();
    class destructor Destroy();
  public
    class procedure UnitInit(); static;
    class procedure FreeNilObject(const [ref] AObject: TObject); static;
    class function  UnitToScalarValue(const aValue, aMaxValue: Double): Double; static;
    class function  SampleTimeToPosition(SampleRate: Integer; TimeInSeconds: Double; Channels: Integer; SampleSizeInBits: Integer): Int64; static;
    class function  FloatToSmallInt(Value: Single): SmallInt; static;
    class procedure ClearKeyboardBuffer(); static;
    class function  WasRunFromConsole() : Boolean; static;
    class function  IsStartedFromDelphiIDE: Boolean; static;
    class function  GetTempStaticBuffer(): PByte; static;
    class function  GetTempStaticBufferSize(): Integer; static;
    class procedure EnterCriticalSection(); static;
    class procedure LeaveCriticalSection(); static;
    class function  EnableVirtualTerminalProcessing(): DWORD; static;
    class function  HasConsoleOutput: Boolean; static;
    class function  IsValidWin64PE(const AFilePath: string): Boolean; static;
    class function  AddResFromMemory(const aModuleFile: string; const aName: string; aData: Pointer; aSize: Cardinal): Boolean; static;
    class function  ResourceExists(aInstance: THandle; const aResName: string): Boolean; static;
    class function  RemoveBOM(const AString: string): string; overload; static;
    class function  RemoveBOM(const ABytes: TBytes): TBytes; overload; static;
    class function  AsUTF8(const AText: string; const AArgs: array of const; const AUseArgs: Boolean=True; const ARemoveBOM: Boolean=False): Pointer; overload; static;
    class function  AsUTF8(const AText: string; const ARemoveBOM: Boolean=False): Pointer; overload; static;
    class procedure UpdateIconResource(const AExeFilePath, AIconFilePath: string); static;
    class procedure UpdateVersionInfoResource(const PEFilePath: string; const AMajor, AMinor, APatch: Word; const AProductName, ADescription, AFilename, ACompanyName, ACopyright: string); static;
    class function  HasEnoughDiskSpace(const APath: string; ARequiredSpace: Int64): Boolean; static;
    class function  RemoveDuplicates(const aText: string): string; static;
    class procedure ProcessMessages(); static;
    class procedure Wait(const AMilliseconds: Double); static;
    class function  HudTextItem(const AKey: string; const AValue: string; const APaddingWidth: Cardinal=20; const ASeperator: string='-'): string; static;
    class procedure AsyncProcess(); static;
    class procedure AsyncClear(); static;
    class procedure AsyncRun(const AName: string; const ABackgroundTask: TAGTAsyncProc; const AWaitForgroundTask: TAGTAsyncProc); static;
    class function  AsyncIsBusy(const AName: string): Boolean; static;
    class procedure AsyncSetTerminate(const AName: string; const ATerminate: Boolean); static;
    class function  AsyncShouldTerminate(const AName: string): Boolean; static;
    class procedure AsyncTerminateAll(); static;
    class procedure AsyncWaitForAllToTerminate(); static;
    class procedure AsyncSuspend(); static;
    class procedure AsyncResume(); static;
  end;

//=== EXPORTS ===============================================================
function  AGT_AsUTF8(const AText: PWideChar; const ARemoveBOM: Boolean=False): Pointer; cdecl; exports AGT_AsUTF8;
function  AGT_HudTextItem(const AKey: PWideChar; const AValue: PWideChar; const ASeperator: PWideChar; const APaddingWidth: Cardinal=20): PWideChar; cdecl; exports AGT_HudTextItem;

implementation

//=== EXPORTS ===============================================================
function  AGT_AsUTF8(const AText: PWideChar; const ARemoveBOM: Boolean=False): Pointer;
begin
  Result := AGT_Utils.AsUTF8(string(AText), ARemoveBOM);
end;

function  AGT_HudTextItem(const AKey: PWideChar; const AValue: PWideChar; const ASeperator: PWideChar; const APaddingWidth: Cardinal): PWideChar;
begin
  Result := PWideChar(AGT_Utils.HudTextItem(string(AKey), string(AValue), APaddingWidth, string(ASeperator)));
end;

{ AGT_Utils }
class procedure AGT_Utils.UnitInit();
begin
  // force constructor call
end;

class constructor AGT_Utils.Create();
begin
  FCriticalSection := TCriticalSection.Create();
  FAsync := TAGTAsync.Create();
end;

class destructor AGT_Utils.Destroy();
begin
  FAsync.Free();
  FCriticalSection.Free();
end;

class function  AGT_Utils.UnitToScalarValue(const aValue, aMaxValue: Double): Double;
var
  LGain: Double;
  LFactor: Double;
  LVolume: Double;
begin
  LGain := (EnsureRange(aValue, 0.0, 1.0) * 50) - 50;
  LFactor := Power(10, LGain * 0.05);
  LVolume := EnsureRange(aMaxValue * LFactor, 0, aMaxValue);
  Result := LVolume;
end;

class procedure AGT_Utils.FreeNilObject(const [ref] AObject: TObject);
var
  LTemp: TObject;
begin
  if not Assigned(AObject) then Exit;
  try
    FCriticalSection.Enter;
    LTemp := AObject;
    TObject(Pointer(@AObject)^) := nil;
    LTemp.Free;
  finally
    FCriticalSection.Leave;
  end;
end;

class function AGT_Utils.SampleTimeToPosition(SampleRate: Integer; TimeInSeconds: Double; Channels: Integer; SampleSizeInBits: Integer): Int64;
begin
  Result := Round(SampleRate * TimeInSeconds * Channels * (SampleSizeInBits div 8));
end;

class function AGT_Utils.FloatToSmallInt(Value: Single): SmallInt;
begin
  Result := Round(EnsureRange(Value, -1.0, 1.0) * 32767);
end;

class procedure AGT_Utils.ClearKeyboardBuffer();
var
  inputRecord: TInputRecord;
  eventsRead: DWORD;
begin
  // Flush the keyboard buffer by reading all pending input events
  while PeekConsoleInput(GetStdHandle(STD_INPUT_HANDLE), inputRecord, 1,
    eventsRead) and (eventsRead > 0) do
  begin
    ReadConsoleInput(GetStdHandle(STD_INPUT_HANDLE), inputRecord, 1,
      eventsRead);
    // Optionally, you can process the input events if needed
  end;
end;

class function AGT_Utils.WasRunFromConsole() : Boolean;
var
  SI: TStartupInfo;
begin
  SI.cb := SizeOf(TStartupInfo);
  GetStartupInfo(SI);
  Result := ((SI.dwFlags and STARTF_USESHOWWINDOW) = 0);
end;

class function AGT_Utils.IsStartedFromDelphiIDE: Boolean;
begin
  // Check if the IDE environment variable is present
  Result := (GetEnvironmentVariable('BDS') <> '');
end;

class function  AGT_Utils.GetTempStaticBuffer(): PByte;
begin
  Result := @TempStaticBuffer[0];
end;

class function  AGT_Utils.GetTempStaticBufferSize(): Integer;
begin
  Result := CTempStaticBufferSize;
end;

class procedure AGT_Utils.EnterCriticalSection();
begin
  FCriticalSection.Enter;
end;

class procedure AGT_Utils.LeaveCriticalSection();
begin
  FCriticalSection.Leave;
end;

class function AGT_Utils.EnableVirtualTerminalProcessing(): DWORD;
var
  HOut: THandle;
  LMode: DWORD;
begin
  HOut := GetStdHandle(STD_OUTPUT_HANDLE);
  if HOut = INVALID_HANDLE_VALUE then
  begin
    Result := GetLastError;
    Exit;
  end;

  if not GetConsoleMode(HOut, LMode) then
  begin
    Result := GetLastError;
    Exit;
  end;

  LMode := LMode or ENABLE_VIRTUAL_TERMINAL_PROCESSING;
  if not SetConsoleMode(HOut, LMode) then
  begin
    Result := GetLastError;
    Exit;
  end;

  Result := 0;  // Success
end;

class function AGT_Utils.HasConsoleOutput: Boolean;
var
  Stdout: THandle;
begin
  Stdout := GetStdHandle(Std_Output_Handle);
  Win32Check(Stdout <> Invalid_Handle_Value);
  Result := Stdout <> 0;
end;

class function AGT_Utils.IsValidWin64PE(const AFilePath: string): Boolean;
var
  LFile: TFileStream;
  LDosHeader: TImageDosHeader;
  LPEHeaderOffset: DWORD;
  LPEHeaderSignature: DWORD;
  LFileHeader: TImageFileHeader;
begin
  Result := False;

  if not FileExists(AFilePath) then
    Exit;

  LFile := TFileStream.Create(AFilePath, fmOpenRead or fmShareDenyWrite);
  try
    // Check if file is large enough for DOS header
    if LFile.Size < SizeOf(TImageDosHeader) then
      Exit;

    // Read DOS header
    LFile.ReadBuffer(LDosHeader, SizeOf(TImageDosHeader));

    // Check DOS signature
    if LDosHeader.e_magic <> IMAGE_DOS_SIGNATURE then // 'MZ'
      Exit;

      // Validate PE header offset
    LPEHeaderOffset := LDosHeader._lfanew;
    if LFile.Size < LPEHeaderOffset + SizeOf(DWORD) + SizeOf(TImageFileHeader) then
      Exit;

    // Seek to the PE header
    LFile.Position := LPEHeaderOffset;

    // Read and validate the PE signature
    LFile.ReadBuffer(LPEHeaderSignature, SizeOf(DWORD));
    if LPEHeaderSignature <> IMAGE_NT_SIGNATURE then // 'PE\0\0'
      Exit;

   // Read the file header
    LFile.ReadBuffer(LFileHeader, SizeOf(TImageFileHeader));

    // Check if it is a 64-bit executable
    if LFileHeader.Machine <> IMAGE_FILE_MACHINE_AMD64 then   Exit;

    // If all checks pass, it's a valid Win64 PE file
    Result := True;
  finally
    LFile.Free;
  end;
end;

class function AGT_Utils.AddResFromMemory(const aModuleFile: string; const aName: string; aData: Pointer; aSize: Cardinal): Boolean;
var
  LHandle: THandle;
begin
  Result := False;
  if not TFile.Exists(aModuleFile) then Exit;
  LHandle := WinApi.Windows.BeginUpdateResourceW(PWideChar(aModuleFile), False);
  if LHandle <> 0 then
  begin
    WinApi.Windows.UpdateResourceW(LHandle, RT_RCDATA, PChar(aName), 1033 {ENGLISH, ENGLISH_US}, aData, aSize);
    Result := WinApi.Windows.EndUpdateResourceW(LHandle, False);
  end;
end;

class function AGT_Utils.ResourceExists(aInstance: THandle; const aResName: string): Boolean;
begin
  Result := Boolean((FindResource(aInstance, PChar(aResName), RT_RCDATA) <> 0));
end;

class function AGT_Utils.RemoveBOM(const AString: string): string;
const
  UTF8BOM: array[0..2] of Byte = ($EF, $BB, $BF);
var
  LBytes: TBytes;
begin
  // Convert the input string to a byte array
  LBytes := TEncoding.UTF8.GetBytes(AString);

  // Check for UTF-8 BOM at the beginning
  if (Length(LBytes) >= 3) and
     (LBytes[0] = UTF8BOM[0]) and
     (LBytes[1] = UTF8BOM[1]) and
     (LBytes[2] = UTF8BOM[2]) then
  begin
    // Remove the BOM by copying the bytes after it
    Result := TEncoding.UTF8.GetString(LBytes, 3, Length(LBytes) - 3);
  end
  else
  begin
    // Return the original string if no BOM is detected
    Result := AString;
  end;
end;

class function AGT_Utils.RemoveBOM(const ABytes: TBytes): TBytes;
const
  UTF8BOM: array[0..2] of Byte = ($EF, $BB, $BF);
  UTF16LEBOM: array[0..1] of Byte = ($FF, $FE);
  UTF16BEBOM: array[0..1] of Byte = ($FE, $FF);
var
  LStartIndex: Integer;
begin
  Result := ABytes;

  // Check for UTF-8 BOM
  if (Length(ABytes) >= 3) and
     (ABytes[0] = UTF8BOM[0]) and
     (ABytes[1] = UTF8BOM[1]) and
     (ABytes[2] = UTF8BOM[2]) then
  begin
    LStartIndex := 3; // Skip the UTF-8 BOM
  end
  // Check for UTF-16 LE BOM
  else if (Length(ABytes) >= 2) and
          (ABytes[0] = UTF16LEBOM[0]) and
          (ABytes[1] = UTF16LEBOM[1]) then
  begin
    LStartIndex := 2; // Skip the UTF-16 LE BOM
  end
  // Check for UTF-16 BE BOM
  else if (Length(ABytes) >= 2) and
          (ABytes[0] = UTF16BEBOM[0]) and
          (ABytes[1] = UTF16BEBOM[1]) then
  begin
    LStartIndex := 2; // Skip the UTF-16 BE BOM
  end
  else
  begin
    Exit; // No BOM found, return the original array
  end;

  // Create a new array without the BOM
  Result := Copy(ABytes, LStartIndex, Length(ABytes) - LStartIndex);
end;

class function AGT_Utils.AsUTF8(const AText: string; const AArgs: array of const; const AUseArgs: Boolean; const ARemoveBOM: Boolean): Pointer;
var
  LText: string;
begin
  if ARemoveBOM then
    LText := RemoveBOM(AText)
  else
    LText := AText;

  if AUseArgs then
    LText := Format(LText, AArgs);
  Result := Marshaller.AsUtf8(LText).ToPointer;
end;

class function  AGT_Utils.AsUTF8(const AText: string; const ARemoveBOM: Boolean=False): Pointer;
begin
  Result := AsUTF8(AText, [], False, ARemoveBOM);
end;

class procedure AGT_Utils.UpdateIconResource(const AExeFilePath, AIconFilePath: string);
type
  TIconDir = packed record
    idReserved: Word;  // Reserved, must be 0
    idType: Word;      // Resource type, 1 for icons
    idCount: Word;     // Number of images in the file
  end;
  PIconDir = ^TIconDir;

  TGroupIconDirEntry = packed record
    bWidth: Byte;            // Width of the icon (0 means 256)
    bHeight: Byte;           // Height of the icon (0 means 256)
    bColorCount: Byte;       // Number of colors in the palette (0 if more than 256)
    bReserved: Byte;         // Reserved, must be 0
    wPlanes: Word;           // Color planes
    wBitCount: Word;         // Bits per pixel
    dwBytesInRes: Cardinal;  // Size of the image data
    nID: Word;               // Resource ID of the icon
  end;

  TGroupIconDir = packed record
    idReserved: Word;  // Reserved, must be 0
    idType: Word;      // Resource type, 1 for icons
    idCount: Word;     // Number of images in the file
    Entries: array[0..0] of TGroupIconDirEntry; // Variable-length array
  end;

  TIconResInfo = packed record
    bWidth: Byte;            // Width of the icon (0 means 256)
    bHeight: Byte;           // Height of the icon (0 means 256)
    bColorCount: Byte;       // Number of colors in the palette (0 if more than 256)
    bReserved: Byte;         // Reserved, must be 0
    wPlanes: Word;           // Color planes (should be 1)
    wBitCount: Word;         // Bits per pixel
    dwBytesInRes: Cardinal;  // Size of the image data
    dwImageOffset: Cardinal; // Offset of the image data in the file
  end;
  PIconResInfo = ^TIconResInfo;

var
  LUpdateHandle: THandle;
  LIconStream: TMemoryStream;
  LIconDir: PIconDir;
  LIconGroup: TMemoryStream;
  LIconRes: PByte;
  LIconID: Word;
  I: Integer;
  LGroupEntry: TGroupIconDirEntry;
begin

  if not FileExists(AExeFilePath) then
    raise Exception.Create('The specified executable file does not exist.');

  if not FileExists(AIconFilePath) then
    raise Exception.Create('The specified icon file does not exist.');

  LIconStream := TMemoryStream.Create;
  LIconGroup := TMemoryStream.Create;
  try
    // Load the icon file
    LIconStream.LoadFromFile(AIconFilePath);

    // Read the ICONDIR structure from the icon file
    LIconDir := PIconDir(LIconStream.Memory);
    if LIconDir^.idReserved <> 0 then
      raise Exception.Create('Invalid icon file format.');

    // Begin updating the executable's resources
    LUpdateHandle := BeginUpdateResource(PChar(AExeFilePath), False);
    if LUpdateHandle = 0 then
      raise Exception.Create('Failed to begin resource update.');

    try
      // Process each icon image in the .ico file
      LIconRes := PByte(LIconStream.Memory) + SizeOf(TIconDir);
      for I := 0 to LIconDir^.idCount - 1 do
      begin
        // Assign a unique resource ID for the RT_ICON
        LIconID := I + 1;

        // Add the icon image data as an RT_ICON resource
        if not UpdateResource(LUpdateHandle, RT_ICON, PChar(LIconID), LANG_NEUTRAL,
          Pointer(PByte(LIconStream.Memory) + PIconResInfo(LIconRes)^.dwImageOffset),
          PIconResInfo(LIconRes)^.dwBytesInRes) then
          raise Exception.CreateFmt('Failed to add RT_ICON resource for image %d.', [I]);

        // Move to the next icon entry
        Inc(LIconRes, SizeOf(TIconResInfo));
      end;

      // Create the GROUP_ICON resource
      LIconGroup.Clear;
      LIconGroup.Write(LIconDir^, SizeOf(TIconDir)); // Write ICONDIR header

      LIconRes := PByte(LIconStream.Memory) + SizeOf(TIconDir);
      // Write each GROUP_ICON entry
      for I := 0 to LIconDir^.idCount - 1 do
      begin
        // Populate the GROUP_ICON entry
        LGroupEntry.bWidth := PIconResInfo(LIconRes)^.bWidth;
        LGroupEntry.bHeight := PIconResInfo(LIconRes)^.bHeight;
        LGroupEntry.bColorCount := PIconResInfo(LIconRes)^.bColorCount;
        LGroupEntry.bReserved := 0;
        LGroupEntry.wPlanes := PIconResInfo(LIconRes)^.wPlanes;
        LGroupEntry.wBitCount := PIconResInfo(LIconRes)^.wBitCount;
        LGroupEntry.dwBytesInRes := PIconResInfo(LIconRes)^.dwBytesInRes;
        LGroupEntry.nID := I + 1; // Match resource ID for RT_ICON

        // Write the populated GROUP_ICON entry to the stream
        LIconGroup.Write(LGroupEntry, SizeOf(TGroupIconDirEntry));

        // Move to the next ICONDIRENTRY
        Inc(LIconRes, SizeOf(TIconResInfo));
      end;

      // Add the GROUP_ICON resource to the executable
      if not UpdateResource(LUpdateHandle, RT_GROUP_ICON, 'MAINICON', LANG_NEUTRAL,
        LIconGroup.Memory, LIconGroup.Size) then
        raise Exception.Create('Failed to add RT_GROUP_ICON resource.');

      // Commit the resource updates
      if not EndUpdateResource(LUpdateHandle, False) then
        raise Exception.Create('Failed to commit resource updates.');
    except
      EndUpdateResource(LUpdateHandle, True); // Discard changes on failure
      raise;
    end;
  finally
    LIconStream.Free;
    LIconGroup.Free;
  end;
end;

class procedure AGT_Utils.UpdateVersionInfoResource(const PEFilePath: string; const AMajor, AMinor, APatch: Word; const AProductName, ADescription, AFilename, ACompanyName, ACopyright: string);
type
  { TVSFixedFileInfo }
  TVSFixedFileInfo = packed record
    dwSignature: DWORD;        // e.g. $FEEF04BD
    dwStrucVersion: DWORD;     // e.g. $00010000 for version 1.0
    dwFileVersionMS: DWORD;    // e.g. $00030075 for version 3.75
    dwFileVersionLS: DWORD;    // e.g. $00000031 for version 0.31
    dwProductVersionMS: DWORD; // Same format as dwFileVersionMS
    dwProductVersionLS: DWORD; // Same format as dwFileVersionLS
    dwFileFlagsMask: DWORD;    // = $3F for version "0011 1111"
    dwFileFlags: DWORD;        // e.g. VFF_DEBUG | VFF_PRERELEASE
    dwFileOS: DWORD;           // e.g. VOS_NT_WINDOWS32
    dwFileType: DWORD;         // e.g. VFT_APP
    dwFileSubtype: DWORD;      // e.g. VFT2_UNKNOWN
    dwFileDateMS: DWORD;       // file date
    dwFileDateLS: DWORD;       // file date
  end;

  { TStringPair }
  TStringPair = record
    Key: string;
    Value: string;
  end;

var
  LHandleUpdate: THandle;
  LVersionInfoStream: TMemoryStream;
  LFixedInfo: TVSFixedFileInfo;
  LDataPtr: Pointer;
  LDataSize: Integer;
  LStringFileInfoStart, LStringTableStart, LVarFileInfoStart: Int64;
  LStringPairs: array of TStringPair;
  LVErsion: string;
  LMajor, LMinor,LPatch: Word;
  LVSVersionInfoStart: Int64;
  LPair: TStringPair;
  LStringInfoEnd, LStringStart: Int64;
  LStringEnd, LFinalPos: Int64;
  LTranslationStart: Int64;

  procedure AlignStream(const AStream: TMemoryStream; const AAlignment: Integer);
  var
    LPadding: Integer;
    LPadByte: Byte;
  begin
    LPadding := (AAlignment - (AStream.Position mod AAlignment)) mod AAlignment;
    LPadByte := 0;
    while LPadding > 0 do
    begin
      AStream.WriteBuffer(LPadByte, 1);
      Dec(LPadding);
    end;
  end;

  procedure WriteWideString(const AStream: TMemoryStream; const AText: string);
  var
    LWideText: WideString;
  begin
    LWideText := WideString(AText);
    AStream.WriteBuffer(PWideChar(LWideText)^, (Length(LWideText) + 1) * SizeOf(WideChar));
  end;

  procedure SetFileVersionFromString(const AVersion: string; out AFileVersionMS, AFileVersionLS: DWORD);
  var
    LVersionParts: TArray<string>;
    LMajor, LMinor, LBuild, LRevision: Word;
  begin
    // Split the version string into its components
    LVersionParts := AVersion.Split(['.']);
    if Length(LVersionParts) <> 4 then
      raise Exception.Create('Invalid version string format. Expected "Major.Minor.Build.Revision".');

    // Parse each part into a Word
    LMajor := StrToIntDef(LVersionParts[0], 0);
    LMinor := StrToIntDef(LVersionParts[1], 0);
    LBuild := StrToIntDef(LVersionParts[2], 0);
    LRevision := StrToIntDef(LVersionParts[3], 0);

    // Set the high and low DWORD values
    AFileVersionMS := (DWORD(LMajor) shl 16) or DWORD(LMinor);
    AFileVersionLS := (DWORD(LBuild) shl 16) or DWORD(LRevision);
  end;

begin
  LMajor := EnsureRange(AMajor, 0, MaxWord);
  LMinor := EnsureRange(AMinor, 0, MaxWord);
  LPatch := EnsureRange(APatch, 0, MaxWord);
  LVersion := Format('%d.%d.%d.0', [LMajor, LMinor, LPatch]);

  SetLength(LStringPairs, 8);
  LStringPairs[0].Key := 'CompanyName';
  LStringPairs[0].Value := ACompanyName;
  LStringPairs[1].Key := 'FileDescription';
  LStringPairs[1].Value := ADescription;
  LStringPairs[2].Key := 'FileVersion';
  LStringPairs[2].Value := LVersion;
  LStringPairs[3].Key := 'InternalName';
  LStringPairs[3].Value := ADescription;
  LStringPairs[4].Key := 'LegalCopyright';
  LStringPairs[4].Value := ACopyright;
  LStringPairs[5].Key := 'OriginalFilename';
  LStringPairs[5].Value := AFilename;
  LStringPairs[6].Key := 'ProductName';
  LStringPairs[6].Value := AProductName;
  LStringPairs[7].Key := 'ProductVersion';
  LStringPairs[7].Value := LVersion;

  // Initialize fixed info structure
  FillChar(LFixedInfo, SizeOf(LFixedInfo), 0);
  LFixedInfo.dwSignature := $FEEF04BD;
  LFixedInfo.dwStrucVersion := $00010000;
  LFixedInfo.dwFileVersionMS := $00010000;
  LFixedInfo.dwFileVersionLS := $00000000;
  LFixedInfo.dwProductVersionMS := $00010000;
  LFixedInfo.dwProductVersionLS := $00000000;
  LFixedInfo.dwFileFlagsMask := $3F;
  LFixedInfo.dwFileFlags := 0;
  LFixedInfo.dwFileOS := VOS_NT_WINDOWS32;
  LFixedInfo.dwFileType := VFT_APP;
  LFixedInfo.dwFileSubtype := 0;
  LFixedInfo.dwFileDateMS := 0;
  LFixedInfo.dwFileDateLS := 0;

  // SEt MS and LS for FileVersion and ProductVersion
  SetFileVersionFromString(LVersion, LFixedInfo.dwFileVersionMS, LFixedInfo.dwFileVersionLS);
  SetFileVersionFromString(LVersion, LFixedInfo.dwProductVersionMS, LFixedInfo.dwProductVersionLS);

  LVersionInfoStream := TMemoryStream.Create;
  try
    // VS_VERSION_INFO
    LVSVersionInfoStart := LVersionInfoStream.Position;

    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(SizeOf(TVSFixedFileInfo));  // Value length
    LVersionInfoStream.WriteData<Word>(0);  // Type = 0
    WriteWideString(LVersionInfoStream, 'VS_VERSION_INFO');
    AlignStream(LVersionInfoStream, 4);

    // VS_FIXEDFILEINFO
    LVersionInfoStream.WriteBuffer(LFixedInfo, SizeOf(TVSFixedFileInfo));
    AlignStream(LVersionInfoStream, 4);

    // StringFileInfo
    LStringFileInfoStart := LVersionInfoStream.Position;
    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(0);  // Value length = 0
    LVersionInfoStream.WriteData<Word>(1);  // Type = 1
    WriteWideString(LVersionInfoStream, 'StringFileInfo');
    AlignStream(LVersionInfoStream, 4);

    // StringTable
    LStringTableStart := LVersionInfoStream.Position;
    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(0);  // Value length = 0
    LVersionInfoStream.WriteData<Word>(1);  // Type = 1
    WriteWideString(LVersionInfoStream, '040904B0'); // Match Delphi's default code page
    AlignStream(LVersionInfoStream, 4);

    // Write string pairs
    for LPair in LStringPairs do
    begin
      LStringStart := LVersionInfoStream.Position;

      LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
      LVersionInfoStream.WriteData<Word>((Length(LPair.Value) + 1) * 2);  // Value length
      LVersionInfoStream.WriteData<Word>(1);  // Type = 1
      WriteWideString(LVersionInfoStream, LPair.Key);
      AlignStream(LVersionInfoStream, 4);
      WriteWideString(LVersionInfoStream, LPair.Value);
      AlignStream(LVersionInfoStream, 4);

      LStringEnd := LVersionInfoStream.Position;
      LVersionInfoStream.Position := LStringStart;
      LVersionInfoStream.WriteData<Word>(LStringEnd - LStringStart);
      LVersionInfoStream.Position := LStringEnd;
    end;

    LStringInfoEnd := LVersionInfoStream.Position;

    // Write StringTable length
    LVersionInfoStream.Position := LStringTableStart;
    LVersionInfoStream.WriteData<Word>(LStringInfoEnd - LStringTableStart);

    // Write StringFileInfo length
    LVersionInfoStream.Position := LStringFileInfoStart;
    LVersionInfoStream.WriteData<Word>(LStringInfoEnd - LStringFileInfoStart);

    // Start VarFileInfo where StringFileInfo ended
    LVarFileInfoStart := LStringInfoEnd;
    LVersionInfoStream.Position := LVarFileInfoStart;

    // VarFileInfo header
    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(0);  // Value length = 0
    LVersionInfoStream.WriteData<Word>(1);  // Type = 1 (text)
    WriteWideString(LVersionInfoStream, 'VarFileInfo');
    AlignStream(LVersionInfoStream, 4);

    // Translation value block
    LTranslationStart := LVersionInfoStream.Position;
    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(4);  // Value length = 4 (size of translation value)
    LVersionInfoStream.WriteData<Word>(0);  // Type = 0 (binary)
    WriteWideString(LVersionInfoStream, 'Translation');
    AlignStream(LVersionInfoStream, 4);

    // Write translation value
    LVersionInfoStream.WriteData<Word>($0409);  // Language ID (US English)
    LVersionInfoStream.WriteData<Word>($04B0);  // Unicode code page

    LFinalPos := LVersionInfoStream.Position;

    // Update VarFileInfo block length
    LVersionInfoStream.Position := LVarFileInfoStart;
    LVersionInfoStream.WriteData<Word>(LFinalPos - LVarFileInfoStart);

    // Update translation block length
    LVersionInfoStream.Position := LTranslationStart;
    LVersionInfoStream.WriteData<Word>(LFinalPos - LTranslationStart);

    // Update total version info length
    LVersionInfoStream.Position := LVSVersionInfoStart;
    LVersionInfoStream.WriteData<Word>(LFinalPos);

    LDataPtr := LVersionInfoStream.Memory;
    LDataSize := LVersionInfoStream.Size;

    // Update the resource
    LHandleUpdate := BeginUpdateResource(PChar(PEFilePath), False);
    if LHandleUpdate = 0 then
      RaiseLastOSError;

    try
      if not UpdateResourceW(LHandleUpdate, RT_VERSION, MAKEINTRESOURCE(1),
         MAKELANGID(LANG_NEUTRAL, SUBLANG_NEUTRAL), LDataPtr, LDataSize) then
        RaiseLastOSError;

      if not EndUpdateResource(LHandleUpdate, False) then
        RaiseLastOSError;
    except
      EndUpdateResource(LHandleUpdate, True);
      raise;
    end;
  finally
    LVersionInfoStream.Free;
  end;
end;

class function AGT_Utils.HasEnoughDiskSpace(const APath: string; ARequiredSpace: Int64): Boolean;
var
  LFreeAvailable: Int64;
  LTotalSpace: Int64;
  LTotalFree: Int64;
begin
  Result := GetDiskFreeSpaceEx(PChar(APath), LFreeAvailable, LTotalSpace, @LTotalFree) and
            (LFreeAvailable >= ARequiredSpace);
end;

class function AGT_Utils.RemoveDuplicates(const aText: string): string;
var
  i, l: integer;
begin
  Result := '';
  l := Length(aText);
  for i := 1 to l do
  begin
    if (Pos(aText[i], result) = 0) then
    begin
      result := result + aText[i];
    end;
  end;
end;

class procedure AGT_Utils.ProcessMessages();
var
  LMsg: TMsg;
begin
  while Integer(PeekMessage(LMsg, 0, 0, 0, PM_REMOVE)) <> 0 do
  begin
    TranslateMessage(LMsg);
    DispatchMessage(LMsg);
  end;
end;

class procedure AGT_Utils.Wait(const AMilliseconds: Double);
var
  LFrequency, LStartCount, LCurrentCount: Int64;
  LElapsedTime: Double;
begin
  // Get the high-precision frequency of the system's performance counter
  QueryPerformanceFrequency(LFrequency);

  // Get the starting value of the performance counter
  QueryPerformanceCounter(LStartCount);

  // Convert milliseconds to seconds for precision timing
  repeat
    QueryPerformanceCounter(LCurrentCount);
    LElapsedTime := (LCurrentCount - LStartCount) / LFrequency * 1000.0; // Convert to milliseconds
  until LElapsedTime >= AMilliseconds;
end;

class function  AGT_Utils.HudTextItem(const AKey: string; const AValue: string; const APaddingWidth: Cardinal; const ASeperator: string): string;
begin
  Result := Format('%s %s %s', [aKey.PadRight(APaddingWidth), aSeperator, aValue]);
end;

class procedure AGT_Utils.AsyncProcess();
begin
  FAsync.Process();
end;

class procedure AGT_Utils.AsyncClear();
begin
  FAsync.Clear();
end;

class procedure AGT_Utils.AsyncRun(const AName: string; const ABackgroundTask: TAGTAsyncProc; const AWaitForgroundTask: TAGTAsyncProc);
begin
  FAsync.Exec(AName, ABackgroundTask, AWaitForgroundTask);
end;

class function  AGT_Utils.AsyncIsBusy(const AName: string): Boolean;
begin
  Result := FAsync.Busy(AName);
end;

class procedure AGT_Utils.AsyncSetTerminate(const AName: string; const ATerminate: Boolean);
begin
  FAsync.SetTerminate(AName, ATerminate);
end;

class function  AGT_Utils.AsyncShouldTerminate(const AName: string): Boolean;
begin
  Result := FAsync.ShouldTerminate(AName);
end;

class procedure AGT_Utils.AsyncTerminateAll();
begin
  FAsync.TerminateAll();
end;

class procedure AGT_Utils.AsyncWaitForAllToTerminate();
begin
  FAsync.WaitForAllToTerminate();
end;

class procedure AGT_Utils.AsyncSuspend();
begin
  FAsync.Suspend();
end;

class procedure AGT_Utils.AsyncResume();
begin
  FAsync.Resume();
end;

end.
