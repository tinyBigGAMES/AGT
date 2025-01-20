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

unit Aurora.IO;

{$I Aurora.Defines.inc}

interface

uses
  Aurora.Common;

type
  { AGT_IOSeek }
  AGT_IOSeek = (AGT_iosStart, AGT_iosCurrent, AGT_iosEnd);

  { AGT_IO }
  AGT_IO = class(TAGTBaseObject)
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function  IsOpen(): Boolean; virtual;
    procedure Close(); virtual;
    function  Size(): Int64; virtual;
    function  Seek(const AOffset: Int64; const ASeek: AGT_IOSeek): Int64; virtual;
    function  Read(const AData: Pointer; const ASize: Int64): Int64; virtual;
    function  Write(const AData: Pointer; const ASize: Int64): Int64; virtual;
    function  Pos(): Int64; virtual;
    function  Eos(): Boolean; virtual;
  end;

//=== Exports ===============================================================

procedure AGT_IO_Destroy(var AIO: AGT_IO); cdecl; exports AGT_IO_Destroy;
function  AGT_IO_IsOpen(const AIO: AGT_IO): Boolean; cdecl; exports AGT_IO_IsOpen;
procedure AGT_IO_Close(const AIO: AGT_IO); cdecl; exports AGT_IO_Close;
function  AGT_IO_Size(const AIO: AGT_IO): Int64; cdecl; exports AGT_IO_Size;
function  AGT_IO_Seek(const AIO: AGT_IO; const AOffset: Int64; const ASeek: AGT_IOSeek): Int64; cdecl; exports AGT_IO_Seek;
function  AGT_IO_Read(const AIO: AGT_IO; const AData: Pointer; const ASize: Int64): Int64; cdecl; exports AGT_IO_Read;
function  AGT_IO_Write(const AIO: AGT_IO; const AData: Pointer; const ASize: Int64): Int64; cdecl; exports AGT_IO_Write;
function  AGT_IO_Pos(const AIO: AGT_IO): Int64; cdecl; exports AGT_IO_Pos;
function  AGT_IO_Eos(const AIO: AGT_IO): Boolean; cdecl; exports AGT_IO_Eos;

implementation


//=== Exports ===============================================================
procedure AGT_IO_Destroy(var AIO: AGT_IO);
begin
  if not Assigned(AIO) then Exit;
  AIO.Free();
  AIO := nil;
end;

function  AGT_IO_IsOpen(const AIO: AGT_IO): Boolean;
begin
  Result := False;
  if not Assigned(AIO) then Exit;

  Result := AIO.IsOpen();
end;

procedure AGT_IO_Close(const AIO: AGT_IO);
begin
  if not Assigned(AIO) then Exit;

  AIO.Close();
end;

function  AGT_IO_Size(const AIO: AGT_IO): Int64;
begin
  Result := -1;
  if not Assigned(AIO) then Exit;

  Result := AIO.Size();
end;

function  AGT_IO_Seek(const AIO: AGT_IO; const AOffset: Int64; const ASeek: AGT_IOSeek): Int64;
begin
  Result := -1;
  if not Assigned(AIO) then Exit;


  Result := AIO.Seek(AOffset, ASeek);
end;

function  AGT_IO_Read(const AIO: AGT_IO; const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(AIO) then Exit;

  Result := AIO.Read(AData, ASize);
end;

function  AGT_IO_Write(const AIO: AGT_IO; const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
  if not Assigned(AIO) then Exit;

  Result := AIO.Write(AData, ASize);
end;

function  AGT_IO_Pos(const AIO: AGT_IO): Int64;
begin
  Result := -1;
  if not Assigned(AIO) then Exit;

  Result := AIO.Pos();
end;

function  AGT_IO_Eos(const AIO: AGT_IO): Boolean;
begin
  Result := False;
  if not Assigned(AIO) then Exit;

  Result := AIO.Eos();
end;

{ AGT_IO }
constructor AGT_IO.Create();
begin
  inherited;
end;

destructor AGT_IO.Destroy();
begin
  Close();
  inherited;
end;

function  AGT_IO.IsOpen(): Boolean;
begin
  Result := False;
end;

procedure AGT_IO.Close();
begin
end;

function  AGT_IO.Size(): Int64;
begin
  Result := -1;
end;

function  AGT_IO.Seek(const AOffset: Int64; const ASeek: AGT_IOSeek): Int64;
begin
  Result := -1;
end;

function  AGT_IO.Read(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
end;

function  AGT_IO.Write(const AData: Pointer; const ASize: Int64): Int64;
begin
  Result := -1;
end;

function  AGT_IO.Pos(): Int64;
begin
  Result := -1;
end;

function  AGT_IO.Eos(): Boolean;
begin
  Result := False;
end;

end.
