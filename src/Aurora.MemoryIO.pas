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

unit Aurora.MemoryIO;

{$I Aurora.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  Aurora.CLibs,
  Aurora.Common,
  Aurora.IO;

type
  { AGT_MemoryIO }
  AGT_MemoryIO = class(AGT_IO)
  protected
    FHandle: TMemoryStream;
  public
    function  IsOpen(): Boolean; override;
    procedure Close(); override;
    function  Size(): Int64; override;
    function  Seek(const AOffset: Int64; const ASeek: AGT_IOSeek): Int64; override;
    function  Read(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Write(const AData: Pointer; const ASize: Int64): Int64; override;
    function  Pos(): Int64; override;
    function  Eos(): Boolean; override;
    function  Open(const AData: Pointer; ASize: Int64): Boolean; overload;
    function  Open(const ASize: Int64): Boolean; overload;
    function  Memory(): Pointer;
  end;

//=== EXPORTS ===============================================================
function AGT_MemoryIO_Open(const AData: Pointer; const ASize: Int64): AGT_MemoryIO; cdecl; exports AGT_MemoryIO_Open;
function AGT_MemoryIO_Alloc(const ASize: Int64): AGT_MemoryIO; cdecl; exports AGT_MemoryIO_Alloc;
function AGT_MemoryIO_Memory(const AMemoryIO: AGT_MemoryIO): Pointer; cdecl; exports AGT_MemoryIO_Memory;

implementation

//=== EXPORTS ===============================================================
function AGT_MemoryIO_Open(const AData: Pointer; const ASize: Int64): AGT_MemoryIO;
begin
  Result := AGT_MemoryIO.Create();
  if not Result.Open(AData, ASize) then
  begin
    Result.Free();
    Result := nil;
    Exit;
  end;
end;

function AGT_MemoryIO_Alloc(const ASize: Int64): AGT_MemoryIO;
begin
  Result := AGT_MemoryIO.Create();
  if not Result.Open(ASize) then
  begin
    Result.Free();
    Result := nil;
    Exit;
  end;
end;

function AGT_MemoryIO_Memory(const AMemoryIO: AGT_MemoryIO): Pointer;
begin
  Result := nil;
  if not Assigned(AMemoryIO) then Exit;

  Result := AMemoryIO.Memory();
end;

{ AGT_MemoryIO }
function  AGT_MemoryIO.IsOpen(): Boolean;
begin
  Result := Assigned(FHandle);
end;

procedure AGT_MemoryIO.Close();
begin
  if Assigned(FHandle) then
  begin
    FHandle.Free();
    FHandle := nil;
  end;
end;

function  AGT_MemoryIO.Size(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Size;
end;

function  AGT_MemoryIO.Seek(const AOffset: Int64; const ASeek: AGT_IOSeek): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Seek(AOffset, Ord(ASeek));
end;

function  AGT_MemoryIO.Read(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

 Result := FHandle.Read(AData^, ASize);
end;

function  AGT_MemoryIO.Write(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Write(AData^, ASize);
end;

function  AGT_MemoryIO.Pos(): Int64;
begin
  Result := -1;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Position;
end;

function  AGT_MemoryIO.Eos(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  Result := Boolean(Pos() >= Size());
end;

function  AGT_MemoryIO.Open(const AData: Pointer; ASize: Int64): Boolean;
begin
  Result := False;
  if Assigned(FHandle) then Exit;

  FHandle := TMemoryStream.Create;
  FHandle.Write(AData^, ASize);
  FHandle.Position := 0;

  Result := True;
end;

function  AGT_MemoryIO.Open(const ASize: Int64): Boolean;
begin
  Result := False;
  if Assigned(FHandle) then Exit;

  FHandle := TMemoryStream.Create;
  FHandle.SetSize(ASize);

  Result := True;

end;

function  AGT_MemoryIO.Memory: Pointer;
begin
  Result := nil;
  if not Assigned(FHandle) then Exit;

  Result := FHandle.Memory;
end;

end.
