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

unit Aurora.ZipFileIO;

{$I Aurora.Defines.inc}

interface

uses
  System.Types,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  Aurora.CLibs,
  Aurora.Common,
  Aurora.Utils,
  Aurora.Console,
  Aurora.IO,
  Aurora.MemoryIO;

const
  { AGT_DEFAULT_ZIPFILE_PASSWORD }
  AGT_DEFAULT_ZIPFILE_PASSWORD = 'N^TpjE5/*czG,<ns>$}w;?x_uBm9[JSr{(+FRv7ZW@C-gd3D!PRUgWE4P2/wpm9-dt^Y?e)Az+xsMb@jH"!X`B3ar(yq=nZ_~85<';

type
  { AGT_ZipFileIOBuildProgressCallback }
  AGT_ZipFileIOBuildProgressCallback = procedure(const AFilename: PWideChar; const AProgress: Integer; const ANewFile: Boolean; const AUserData: Pointer); cdecl;

  { AGT_ZipFileIO }
  AGT_ZipFileIO = class(AGT_IO)
  protected
    FHandle: unzFile;
    FPassword: AnsiString;
    FFilename: AnsiString;
  public
    function  IsOpen(): Boolean; override;
    procedure Close(); override;
    function  Size(): Int64; override;
    function  Seek(const AOffset: Int64; const ASeek: AGT_IOSeek): Int64; override;
    function  Read(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Write(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Pos(): Int64; override;
    function  Eos(): Boolean; override;
    function Open(const AZipFilename, AFilename: string; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): Boolean;
    class function Init(const AZipFilename, AFilename: string; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): AGT_ZipFileIO; static;
    class function LoadToMemoryStream(const AZipFilename, AFilename: string; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): TMemoryStream; static;
    class function LoadToMemoryIO(const AZipFilename, AFilename: string; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): AGT_MemoryIO; static;
    class function Build(const AZipFilename, ADirectoryName: string; const AHandler: AGT_ZipFileIOBuildProgressCallback=nil; const AUserData: Pointer=nil; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): Boolean; static;
  end;

//=== EXPORTS ===============================================================
function AGT_ZipFileIO_Build(const AZipFilename, ADirectoryName, APassword: PWideChar; const AHandler: AGT_ZipFileIOBuildProgressCallback=nil; const AUserData: Pointer=nil): Boolean; cdecl; exports AGT_ZipFileIO_Build;
function AGT_ZipFileIO_Open(const AZipFilename, AFilename, APassword: PWideChar): AGT_ZipFileIO; cdecl; exports AGT_ZipFileIO_Open;
function AGT_ZipFileIO_LoadToMemory(const AZipFilename, AFilename, APassword: PWideChar): AGT_MemoryIO; cdecl; exports AGT_ZipFileIO_LoadToMemory;


implementation

//=== EXPORTS ===============================================================
function AGT_ZipFileIO_Build(const AZipFilename, ADirectoryName, APassword: PWideChar; const AHandler: AGT_ZipFileIOBuildProgressCallback=nil; const AUserData: Pointer=nil): Boolean;
begin
  Result := AGT_ZipFileIO.Build(string(AZipFilename), string(ADirectoryName), AHandler, AUserData, string(APassword));
end;

function AGT_ZipFileIO_Open(const AZipFilename, AFilename, APassword: PWideChar): AGT_ZipFileIO;
begin
  Result := AGT_ZipFileIO.Init(string(AZipFilename), string(AFilename), string(APassword));
end;

function AGT_ZipFileIO_LoadToMemory(const AZipFilename, AFilename, APassword: PWideChar): AGT_MemoryIO;
begin
  Result := AGT_ZipFileIO.LoadToMemoryIO(string(AZipFilename), string(AFilename), string(APassword));
end;

//===========================================================================

{ AGT_ZipFileIO }
function  AGT_ZipFileIO.IsOpen(): Boolean;
begin
  Result := Assigned(FHandle);
end;

procedure AGT_ZipFileIO.Close();
begin
  if not Assigned(FHandle) then Exit;

  Assert(unzCloseCurrentFile(FHandle) = UNZ_OK);
  Assert(unzClose(FHandle) = UNZ_OK);
  FHandle := nil;
end;

function  AGT_ZipFileIO.Size(): Int64;
var
  LInfo: unz_file_info64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  unzGetCurrentFileInfo64(FHandle, @LInfo, nil, 0, nil, 0, nil, 0);
  Result := LInfo.uncompressed_size;
end;

function  AGT_ZipFileIO.Seek(const AOffset: Int64; const ASeek: AGT_IOSeek): Int64;
var
  LFileInfo: unz_file_info64;
  LCurrentOffset, LBytesToRead: UInt64;
  LOffset: Int64;

  procedure SeekToLoc;
  begin
    LBytesToRead := UInt64(LOffset) - unztell64(FHandle);
    while LBytesToRead > 0 do
    begin
      if LBytesToRead > AGT_Utils.GetTempStaticBufferSize() then
        unzReadCurrentFile(FHandle, AGT_Utils.GetTempStaticBuffer(), AGT_Utils.GetTempStaticBufferSize())
      else
        unzReadCurrentFile(FHandle, AGT_Utils.GetTempStaticBuffer(), LBytesToRead);

      LBytesToRead := UInt64(LOffset) - unztell64(FHandle);
    end;
  end;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  if (FHandle = nil) or (unzGetCurrentFileInfo64(FHandle, @LFileInfo, nil, 0, nil, 0, nil, 0) <> UNZ_OK) then
  begin
    Exit;
  end;

  LOffset := AOffset;

  LCurrentOffset := unztell64(FHandle);
  if LCurrentOffset = -1 then Exit;

  case ASeek of
    // offset is already relative to the start of the file
    AGT_iosStart: ;

    // offset is relative to current position
    AGT_iosCurrent: Inc(LOffset, LCurrentOffset);

    // offset is relative to end of the file
    AGT_iosEnd: Inc(LOffset, LFileInfo.uncompressed_size);
  else
    Exit;
  end;

  if LOffset < 0 then Exit

  else if AOffset > LCurrentOffset then
    begin
      SeekToLoc();
    end
  else // offset < current_offset
    begin
      unzCloseCurrentFile(FHandle);
      unzLocateFile(FHandle, PAnsiChar(FFilename), 0);
      unzOpenCurrentFilePassword(FHandle, PAnsiChar(FPassword));
      SeekToLoc();
    end;

  Result := unztell64(FHandle);
end;

function  AGT_ZipFileIO.Read(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := unzReadCurrentFile(FHandle, AData, ASize);
end;

function  AGT_ZipFileIO.Write(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;
end;

function  AGT_ZipFileIO.Pos(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := unztell64(FHandle);
end;

function  AGT_ZipFileIO.Eos(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  Result := Boolean(Pos() >= Size());
end;

procedure TZipFileIO_BuildProgress(const AFilename: PWideChar; const AProgress: Integer; const ANewFile: Boolean; const AUserData: Pointer); cdecl;
begin
  if aNewFile then AGT_Console.PrintLn('', []);
  AGT_Console.Print(AGT_CR+'Adding %s(%d%s)...', [ExtractFileName(string(aFilename)), aProgress, '%']);
end;

function AGT_ZipFileIO.Open(const AZipFilename, AFilename: string; const APassword: string): Boolean;
var
  LPassword: PAnsiChar;
  LZipFilename: PAnsiChar;
  LFilename: PAnsiChar;
  LFile: unzFile;
begin
  Result := False;

  LPassword := PAnsiChar(AnsiString(APassword));
  LZipFilename := PAnsiChar(AnsiString(StringReplace(string(AZipFilename), '/', '\', [rfReplaceAll])));
  LFilename := PAnsiChar(AnsiString(StringReplace(string(AFilename), '/', '\', [rfReplaceAll])));

  LFile := unzOpen64(LZipFilename);
  if not Assigned(LFile) then Exit;

  if unzLocateFile(LFile, LFilename, 0) <> UNZ_OK then
  begin
    unzClose(LFile);
    Exit;
  end;

  if unzOpenCurrentFilePassword(LFile, LPassword) <> UNZ_OK then
  begin
    unzClose(LFile);
    Exit;
  end;

  FHandle := LFile;
  FPassword := LPassword;
  FFilename := LFilename;

  Result := True;
end;

class function AGT_ZipFileIO.Init(const AZipFilename, AFilename: string; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): AGT_ZipFileIO;
begin
  Result := AGT_ZipFileIO.Create();
  if not Result.Open(AZipFilename, AFilename, APassword) then
  begin
    Result.Free();
    Result := nil;
  end;
end;

class function AGT_ZipFileIO.LoadToMemoryStream(const AZipFilename, AFilename: string; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): TMemoryStream;
var
  LIO: AGT_ZipFileIO;
begin
  LIO := AGT_ZipFileIO.Init(AZipFilename, AFilename, APassword);
  Result := TMemoryStream.Create();
  Result.SetSize(LIO.Size());
  LIO.Read(Result.Memory, LIO.Size);
  LIO.Free();
  Result.Position := 0;
end;

class function AGT_ZipFileIO.LoadToMemoryIO(const AZipFilename, AFilename: string; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): AGT_MemoryIO;
var
  LIO: AGT_ZipFileIO;
begin
  LIO := AGT_ZipFileIO.Init(AZipFilename, AFilename, APassword);
  Result := AGT_MemoryIO.Create();
  Result.Open(LIO.Size());
  LIO.Read(Result.Memory, LIO.Size);
  LIO.Free();
  Result.Seek(0, AGT_iosStart);
end;

class function AGT_ZipFileIO.Build(const AZipFilename, ADirectoryName: string; const AHandler: AGT_ZipFileIOBuildProgressCallback; const AUserData: Pointer; const APassword: string): Boolean;
var
  LFileList: TStringDynArray;
  LArchive: PAnsiChar;
  LFilename: string;
  LFilename2: PAnsiChar;
  LPassword: PAnsiChar;
  LZipFile: zipFile;
  LZipFileInfo: zip_fileinfo;
  LFile: System.Classes.TStream;
  LCrc: Cardinal;
  LBytesRead: Integer;
  LFileSize: Int64;
  LProgress: Single;
  LNewFile: Boolean;
  LHandler: AGT_ZipFileIOBuildProgressCallback;
  LUserData: Pointer;

  function GetCRC32(aStream: System.Classes.TStream): uLong;
  var
    LBytesRead: Integer;
    LBuffer: array of Byte;
  begin
    Result := crc32(0, nil, 0);
    repeat
      LBytesRead := AStream.Read(AGT_Utils.GetTempStaticBuffer()^, AGT_Utils.GetTempStaticBufferSize());
      Result := crc32(Result, PBytef(AGT_Utils.GetTempStaticBuffer()), LBytesRead);
    until LBytesRead = 0;

    LBuffer := nil;
  end;
begin
  Result := False;

  // check if directory exists
  if not TDirectory.Exists(ADirectoryName) then Exit;

  // init variabls
  FillChar(LZipFileInfo, SizeOf(LZipFileInfo), 0);

  // scan folder and build file list
  LFileList := TDirectory.GetFiles(ADirectoryName, '*',
    TSearchOption.soAllDirectories);

  LArchive := PAnsiChar(AnsiString(AZipFilename));
  LPassword := PAnsiChar(AnsiString(APassword));

  // create a zip file
  LZipFile := zipOpen64(LArchive, APPEND_STATUS_CREATE);

  // init handler
  LHandler := AHandler;
  LUserData := AUserData;

  if not Assigned(LHandler) then
    LHandler := TZipFileIO_BuildProgress;

  // process zip file
  if LZipFile <> nil then
  begin
    // loop through all files in list
    for LFilename in LFileList do
    begin
      // open file
      LFile := TFile.OpenRead(LFilename);

      // get file size
      LFileSize := LFile.Size;

      // get file crc
      LCrc := GetCRC32(LFile);

      // open new file in zip
      LFilename2 := PAnsiChar(AnsiString(LFilename));
      if ZipOpenNewFileInZip3_64(LZipFile, LFilename2, @LZipFileInfo, nil, 0,
        nil, 0, '',  Z_DEFLATED, 9, 0, 15, 9, Z_DEFAULT_STRATEGY,
        LPassword, LCrc, 1) = Z_OK then
      begin
        // make sure we start at star of stream
        LFile.Position := 0;

        LNewFile := True;

        // read through file
        repeat
          // read in a buffer length of file
          LBytesRead := LFile.Read(AGT_Utils.GetTempStaticBuffer()^, AGT_Utils.GetTempStaticBufferSize());

          // write buffer out to zip file
          zipWriteInFileInZip(LZipFile, AGT_Utils.GetTempStaticBuffer(), LBytesRead);

          // calc file progress percentage
          LProgress := 100.0 * (LFile.Position / LFileSize);

          // show progress
          if Assigned(LHandler) then
          begin
            LHandler(PWideChar(LFilename), Round(LProgress), LNewFile, LUserData);
          end;

          LNewFile := False;

        until LBytesRead = 0;

        // close file in zip
        zipCloseFileInZip(LZipFile);

        // free file stream
        LFile.Free;
      end;
    end;

    // close zip file
    zipClose(LZipFile, '');
  end;

  // return true if new zip file exits
  Result := TFile.Exists(LFilename);
end;

end.
