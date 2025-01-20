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

unit Aurora.FileIO;

{$I Aurora.Defines.inc}

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  Aurora.CLibs,
  Aurora.Common,
  Aurora.IO;

type
  { AGT_IOMode }
  AGT_IOMode = (AGT_iomRead, AGT_iomWrite);

  { AGT_FileIO }
  AGT_FileIO = class(AGT_IO)
  protected
    FHandle: TFileStream;
    FMode: AGT_IOMode;
  public
    function  IsOpen(): Boolean; override;
    procedure Close(); override;
    function  Size(): Int64; override;
    function  Seek(const AOffset: Int64; const ASeek: AGT_IOSeek): Int64; override;
    function  Read(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Write(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Pos(): Int64; override;
    function  Eos(): Boolean; override;
    function  Open(const AFilename: string; const AMode: AGT_IOMode): Boolean;
  end;

//=== EXPORTS ===============================================================
function  AGT_FileIO_Open(const AFilename: PWideChar; const AMode: AGT_IOMode): AGT_FileIO; cdecl; exports AGT_FileIO_Open;

implementation

//=== EXPORTS ===============================================================
function  AGT_FileIO_Open(const AFilename: PWideChar; const AMode: AGT_IOMode): AGT_FileIO;
begin
  Result := nil;
  if AFilename = nil then Exit;

  Result := AGT_FileIO.Create();
  if not Result.Open(string(AFilename), AMode) then
  begin
    Result.Free();
    Result := nil;
    Exit;
  end;

end;

{ AGT_FileIO }
function  AGT_FileIO.IsOpen(): Boolean;
begin
  Result := Assigned(FHandle);
end;

procedure AGT_FileIO.Close();
begin
  if Assigned(FHandle) then
  begin
    FHandle.Free();
    FHandle := nil;
  end;
end;

function  AGT_FileIO.Size(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Size;
end;

function  AGT_FileIO.Seek(const AOffset: Int64; const ASeek: AGT_IOSeek): Int64;
begin
  Result := FHandle.Seek(AOffset, Ord(ASeek));
end;

function  AGT_FileIO.Read(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

 Result := FHandle.Read(AData^, ASize);
end;

function  AGT_FileIO.Write(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Write(AData^, ASize);
end;

function  AGT_FileIO.Pos(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Position;
end;

function  AGT_FileIO.Eos(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  Result := Boolean(Pos() >= Size());
end;

function AGT_FileIO.Open(const AFilename: string; const AMode: AGT_IOMode): Boolean;
var
  LHandle: TFileStream;
  LMode: AGT_IOMode;
begin
  Result := False;
  LHandle := nil;

  if AFilename.IsEmpty then Exit;

  LMode := AMode;

  try
    case AMode of
      AGT_iomRead:
      begin
        if not TFile.Exists(AFilename) then Exit;
        LHandle := TFile.OpenRead(AFilename);
      end;

      AGT_iomWrite:
      begin
        LHandle := TFile.Create(AFilename);
      end;
    end;
  except
    LHandle := nil;
  end;

  if not Assigned(LHandle) then
  begin
    Exit;
  end;

  FHandle := LHandle;
  FMode := LMode;

  Result := True;
end;

end.
