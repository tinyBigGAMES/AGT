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

unit Aurora.Texture;

{$I Aurora.Defines.inc}

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Math,
  Aurora.CLibs,
  Aurora.OpenGL,
  Aurora.Common,
  Aurora.Color,
  Aurora.Math,
  Aurora.Utils,
  Aurora.IO,
  Aurora.FileIO,
  Aurora.ZipFileIO,
  Aurora.Window;

type
  { AGT_TextureBlend }
  AGT_TextureBlend = (AGT_tbNone, AGT_tbAlpha, AGT_tbAdditiveAlpha);

  { AGT_Texture }
  AGT_Texture = class(TAGTBaseObject)
  private type
    PRGBA = ^TRGBA;
    TRGBA = packed record
      R, G, B, A: Byte;
    end;
  private
    FHandle: Cardinal;
    FChannels: Integer;
    FSize: AGT_Size;
    FPivot: AGT_Point;
    FAnchor: AGT_Point;
    FBlend: AGT_TextureBlend;
    FPos: AGT_Point;
    FScale: Single;
    FColor: AGT_Color;
    FAngle: Single;
    FHFlip: Boolean;
    FVFlip: Boolean;
    FRegion: AGT_Rect;
    FLock: PByte;
    procedure ConvertMaskToAlpha(Data: Pointer; Width, Height: Integer; MaskColor: AGT_Color);
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function  Alloc(const AWidth, AHeight: Integer): Boolean;
    procedure Fill(const AColor: AGT_Color);
    function  Load(const ARGBData: Pointer; const AWidth, AHeight: Integer): Boolean; overload;
    function  Load(const AIO: AGT_IO; const AOwnIO: Boolean=True; const AColorKey: PAGT_Color=nil): Boolean; overload;
    function  LoadFromFile(const AFilename: string; const AColorKey: PAGT_Color=nil): Boolean;
    function  LoadFromZipFile(const AZipFilename, AFilename: string; const AColorKey: PAGT_Color=nil; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): Boolean;
    function  IsLoaded(): Boolean;
    procedure Unload();
    function  GetHandle(): Cardinal;
    function  GetChannels(): Integer;
    function  GetSize():AGT_Size;
    function  GetPivot(): AGT_Point;
    procedure SetPivot( const APoint: AGT_Point); overload;
    procedure SetPivot(const X, Y: Single); overload;
    function  GetAnchor(): AGT_Point;
    procedure SetAnchor(const APoint: AGT_Point); overload;
    procedure SetAnchor(const X, Y: Single); overload;
    function  GetBlend(): AGT_TextureBlend;
    procedure SetBlend(const AValue: AGT_TextureBlend);
    function  GetPos(): AGT_Point;
    procedure SetPos(const APos: AGT_Point); overload;
    procedure SetPos(const X, Y: Single); overload;
    function  GetScale(): Single;
    procedure SetScale(const AScale: Single);
    function  GetColor(): AGT_Color;
    procedure SetColor(const AColor: AGT_Color); overload;
    procedure SetColor(const ARed, AGreen, ABlue, AAlpha: Single); overload;
    function  GetAngle(): Single;
    procedure SetAngle(const AAngle: Single);
    function  GetHFlip(): Boolean;
    procedure SetHFlip(const AFlip: Boolean);
    function  GetVFlip(): Boolean;
    procedure SetVFlip(const AFlip: Boolean);
    function  GetRegion(): AGT_Rect;
    procedure SetRegion(const ARegion: AGT_Rect); overload;
    procedure SetRegion(const X, Y, AWidth, AHeight: Single); overload;
    procedure ResetRegion();
    procedure Draw(const AWindow: AGT_Window);
    procedure DrawTiled(const AWindow: AGT_Window; const ADeltaX, ADeltaY: Single);
    function  Save(const AFilename: string): Boolean;
    function  Lock(): Boolean;
    procedure Unlock();
    function  GetPixel(const X, Y: Single): AGT_Color;
    procedure SetPixel(const X, Y: Single; const AColor: AGT_Color); overload;
    procedure SetPixel(const X, Y: Single; const ARed, AGreen, ABlue, AAlpha: Byte); overload;
    function  CollideAABB(const ATexture: AGT_Texture): Boolean;
    function  CollideOBB(const ATexture: AGT_Texture): Boolean;
    class function Init(const AZipFilename, AFilename: string; const AColorKey: PAGT_Color=nil; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): AGT_Texture; static;
    class function Spine(const AIO: AGT_IO; const AOwnIO: Boolean=True): GLuint;
    class procedure Delete(const ATexture: GLuint);
  end;

//=== EXPORTS ===============================================================
function  AGT_Texture_Create(): AGT_Texture; cdecl; exports AGT_Texture_Create;
function  AGT_Texture_CreateFromIO(const AIO: AGT_IO; const AOwnIO: Boolean=True; const AColorKey: PAGT_Color=nil): AGT_Texture; cdecl; exports AGT_Texture_CreateFromIO;
function  AGT_Texture_CreateFromZipFile(const AZipFilename, AFilename, APassword: PWideChar; const AColorKey: PAGT_Color=nil): AGT_Texture; cdecl; exports AGT_Texture_CreateFromZipFile;
procedure AGT_Texture_Destroy(var ATexture: AGT_Texture); cdecl; exports AGT_Texture_Destroy;
function  AGT_Texture_Alloc(const ATexture: AGT_Texture; const AWidth, AHeight: Integer): Boolean; cdecl; exports AGT_Texture_Alloc;
procedure AGT_Texture_Fill(const ATexture: AGT_Texture; const AColor: AGT_Color); cdecl; exports AGT_Texture_Fill;
function  AGT_Texture_LoadFromData(const ATexture: AGT_Texture; const ARGBData: Pointer; const AWidth, AHeight: Integer): Boolean; cdecl; exports AGT_Texture_LoadFromData;
function  AGT_Texture_LoadFromIO(const ATexture: AGT_Texture; const AIO: AGT_IO; const AOwnIO: Boolean=True; const AColorKey: PAGT_Color=nil): Boolean; cdecl; exports AGT_Texture_LoadFromIO;
function  AGT_Texture_LoadFromFile(const ATexture: AGT_Texture; const AFilename: PWideChar; const AColorKey: PAGT_Color=nil): Boolean; cdecl; exports AGT_Texture_LoadFromFile;
function  AGT_Texture_LoadFromZipFile(const ATexture: AGT_Texture; const AZipFilename, AFilename, APassword: PWideChar; const AColorKey: PAGT_Color=nil): Boolean; cdecl; exports AGT_Texture_LoadFromZipFile;
function  AGT_Texture_IsLoaded(const ATexture: AGT_Texture): Boolean; cdecl; exports AGT_Texture_IsLoaded;
procedure AGT_Texture_Unload(const ATexture: AGT_Texture); cdecl; exports AGT_Texture_Unload;
function  AGT_Texture_GetHandle(const ATexture: AGT_Texture): Cardinal; cdecl; exports AGT_Texture_GetHandle;
function  AGT_Texture_GetChannels(const ATexture: AGT_Texture): Integer; cdecl; exports AGT_Texture_GetChannels;
function  AGT_Texture_GetSize(const ATexture: AGT_Texture):AGT_Size; cdecl; exports AGT_Texture_GetSize;
function  AGT_Texture_GetPivot(const ATexture: AGT_Texture): AGT_Point; cdecl; exports AGT_Texture_GetPivot;
procedure AGT_Texture_SetPivot(const ATexture: AGT_Texture; const APoint: AGT_Point); cdecl; exports AGT_Texture_SetPivot;
procedure AGT_Texture_SetPivotEx(const ATexture: AGT_Texture; const X, Y: Single); cdecl; exports AGT_Texture_SetPivotEx;
function  AGT_Texture_GetAnchor(const ATexture: AGT_Texture): AGT_Point; cdecl; exports AGT_Texture_GetAnchor;
procedure AGT_Texture_SetAnchor(const ATexture: AGT_Texture; const APoint: AGT_Point); cdecl; exports AGT_Texture_SetAnchor;
procedure AGT_Texture_SetAnchorEx(const ATexture: AGT_Texture; const X, Y: Single); cdecl; exports AGT_Texture_SetAnchorEx;
function  AGT_Texture_GetBlend(const ATexture: AGT_Texture): AGT_TextureBlend; cdecl; exports AGT_Texture_GetBlend;
procedure AGT_Texture_SetBlend(const ATexture: AGT_Texture; const AValue: AGT_TextureBlend); cdecl; exports AGT_Texture_SetBlend;
function  AGT_Texture_GetPos(const ATexture: AGT_Texture): AGT_Point; cdecl; exports AGT_Texture_GetPos;
procedure AGT_Texture_SetPos(const ATexture: AGT_Texture; const APos: AGT_Point); cdecl; exports AGT_Texture_SetPos;
procedure AGT_Texture_SetPosEx(const ATexture: AGT_Texture; const X, Y: Single); cdecl; exports AGT_Texture_SetPosEx;
function  AGT_Texture_GetScale(const ATexture: AGT_Texture): Single; cdecl; exports AGT_Texture_GetScale;
procedure AGT_Texture_SetScale(const ATexture: AGT_Texture; const AScale: Single); cdecl; exports AGT_Texture_SetScale;
function  AGT_Texture_GetColor(const ATexture: AGT_Texture): AGT_Color; cdecl; exports AGT_Texture_GetColor;
procedure AGT_Texture_SetColor(const ATexture: AGT_Texture; const AColor: AGT_Color); cdecl; exports AGT_Texture_SetColor;
procedure AGT_Texture_SetColorEx(const ATexture: AGT_Texture; const ARed, AGreen, ABlue, AAlpha: Single); cdecl; exports AGT_Texture_SetColorEx;
function  AGT_Texture_GetAngle(const ATexture: AGT_Texture): Single; cdecl; exports AGT_Texture_GetAngle;
procedure AGT_Texture_SetAngle(const ATexture: AGT_Texture; const AAngle: Single); cdecl; exports AGT_Texture_SetAngle;
function  AGT_Texture_GetHFlip(const ATexture: AGT_Texture): Boolean; cdecl; exports AGT_Texture_GetHFlip;
procedure AGT_Texture_SetHFlip(const ATexture: AGT_Texture; const AFlip: Boolean); cdecl; exports AGT_Texture_SetHFlip;
function  AGT_Texture_GetVFlip(const ATexture: AGT_Texture): Boolean; cdecl; exports AGT_Texture_GetVFlip;
procedure AGT_Texture_SetVFlip(const ATexture: AGT_Texture; const AFlip: Boolean); cdecl; exports AGT_Texture_SetVFlip;
function  AGT_Texture_GetRegion(const ATexture: AGT_Texture): AGT_Rect; cdecl; exports AGT_Texture_GetRegion;
procedure AGT_Texture_SetRegion(const ATexture: AGT_Texture; const ARegion: AGT_Rect); cdecl; exports AGT_Texture_SetRegion;
procedure AGT_Texture_SetRegionEx(const ATexture: AGT_Texture; const X, Y, AWidth, AHeight: Single); cdecl; exports AGT_Texture_SetRegionEx;
procedure AGT_Texture_ResetRegion(const ATexture: AGT_Texture); cdecl; exports AGT_Texture_ResetRegion;
procedure AGT_Texture_Draw(const ATexture: AGT_Texture; const AWindow: AGT_Window); cdecl; exports AGT_Texture_Draw;
procedure AGT_Texture_DrawTiled(const ATexture: AGT_Texture; const AWindow: AGT_Window; const ADeltaX, ADeltaY: Single); cdecl; exports AGT_Texture_DrawTiled;
function  AGT_Texture_Save(const ATexture: AGT_Texture; const AFilename: PWideChar): Boolean; cdecl; exports AGT_Texture_Save;
function  AGT_Texture_Lock(const ATexture: AGT_Texture): Boolean; cdecl; exports AGT_Texture_Lock;
procedure AGT_Texture_Unlock(const ATexture: AGT_Texture); cdecl; exports AGT_Texture_Unlock;
function  AGT_Texture_GetPixel(const ATexture: AGT_Texture; const X, Y: Single): AGT_Color; cdecl; exports AGT_Texture_GetPixel;
procedure AGT_Texture_SetPixel(const ATexture: AGT_Texture; const X, Y: Single; const AColor: AGT_Color); cdecl; exports AGT_Texture_SetPixel;
procedure AGT_Texture_SetPixelEx(const ATexture: AGT_Texture; const X, Y: Single; const ARed, AGreen, ABlue, AAlpha: Byte); cdecl; exports AGT_Texture_SetPixelEx;
function  AGT_Texture_CollideAABB(const ATexture1: AGT_Texture; const ATexture2: AGT_Texture): Boolean; cdecl; exports AGT_Texture_CollideAABB;
function  AGT_Texture_CollideOBB(const ATexture1: AGT_Texture; const ATexture2: AGT_Texture): Boolean; cdecl; exports AGT_Texture_CollideOBB;

implementation

//=== EXPORTS ===============================================================
function  AGT_Texture_Create(): AGT_Texture;
begin
  Result := AGT_Texture.Create();
end;

function  AGT_Texture_CreateFromIO(const AIO: AGT_IO; const AOwnIO: Boolean=True; const AColorKey: PAGT_Color=nil): AGT_Texture;
begin
  Result := AGT_Texture.Create();
  if not Result.Load(AIO, AOwnIO, AColorKey) then
  begin
    Result.Free();
    Result := nil;
    Exit;
  end;
end;

function  AGT_Texture_CreateFromZipFile(const AZipFilename, AFilename, APassword: PWideChar; const AColorKey: PAGT_Color=nil): AGT_Texture;
begin
  Result := AGT_Texture.Init(string(AZipFilename), string(AFilename), AColorKey, string(APassword));
end;

procedure AGT_Texture_Destroy(var ATexture: AGT_Texture);
begin
  if Assigned(ATexture) then
  begin
    ATexture.Free();
    ATexture := nil;
  end;
end;

function  AGT_Texture_Alloc(const ATexture: AGT_Texture; const AWidth, AHeight: Integer): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.Alloc(AWidth, AHeight);
end;

procedure AGT_Texture_Fill(const ATexture: AGT_Texture; const AColor: AGT_Color);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.Fill(AColor);
end;

function  AGT_Texture_LoadFromData(const ATexture: AGT_Texture; const ARGBData: Pointer; const AWidth, AHeight: Integer): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.Load(ARGBData, AWidth, AHeight);
end;

function  AGT_Texture_LoadFromIO(const ATexture: AGT_Texture; const AIO: AGT_IO; const AOwnIO: Boolean=True; const AColorKey: PAGT_Color=nil): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.Load(AIO, AOwnIO, AColorKey);
end;

function  AGT_Texture_LoadFromFile(const ATexture: AGT_Texture; const AFilename: PWideChar; const AColorKey: PAGT_Color=nil): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.LoadFromFile(string(AFilename), AColorKey);
end;

function  AGT_Texture_LoadFromZipFile(const ATexture: AGT_Texture; const AZipFilename, AFilename, APassword: PWideChar; const AColorKey: PAGT_Color=nil): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.LoadFromZipFile(string(AZipFilename), string(AFilename), AColorKey, string(APassword));
end;

function  AGT_Texture_IsLoaded(const ATexture: AGT_Texture): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.IsLoaded();
end;

procedure AGT_Texture_Unload(const ATexture: AGT_Texture);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.Unload();
end;

function  AGT_Texture_GetHandle(const ATexture: AGT_Texture): Cardinal;
begin
  Result := 0;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetHandle();
end;

function  AGT_Texture_GetChannels(const ATexture: AGT_Texture): Integer;
begin
  Result := 0;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetChannels();
end;

function  AGT_Texture_GetSize(const ATexture: AGT_Texture): AGT_Size;
begin
  Result := Default(AGT_Size);
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetSize();
end;

function  AGT_Texture_GetPivot(const ATexture: AGT_Texture): AGT_Point;
begin
  Result := Default(AGT_Point);
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetPivot();
end;

procedure AGT_Texture_SetPivot(const ATexture: AGT_Texture; const APoint: AGT_Point);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetPivot(APoint);
end;

procedure AGT_Texture_SetPivotEx(const ATexture: AGT_Texture; const X, Y: Single);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetPivot(X, Y);
end;

function  AGT_Texture_GetAnchor(const ATexture: AGT_Texture): AGT_Point;
begin
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetAnchor();
end;

procedure AGT_Texture_SetAnchor(const ATexture: AGT_Texture; const APoint: AGT_Point);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetAnchor(APoint);
end;

procedure AGT_Texture_SetAnchorEx(const ATexture: AGT_Texture; const X, Y: Single);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetPivot(X, Y);
end;

function  AGT_Texture_GetBlend(const ATexture: AGT_Texture): AGT_TextureBlend;
begin
  Result := AGT_tbNone;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetBlend();
end;

procedure AGT_Texture_SetBlend(const ATexture: AGT_Texture; const AValue: AGT_TextureBlend);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetBlend(AValue);
end;

function  AGT_Texture_GetPos(const ATexture: AGT_Texture): AGT_Point;
begin
  Result := Default(AGT_Point);
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetPos();
end;

procedure AGT_Texture_SetPos(const ATexture: AGT_Texture; const APos: AGT_Point);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetPos(APos);
end;

procedure AGT_Texture_SetPosEx(const ATexture: AGT_Texture; const X, Y: Single);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetPos(X, Y);
end;

function  AGT_Texture_GetScale(const ATexture: AGT_Texture): Single;
begin
  Result := 0;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetScale();
end;

procedure AGT_Texture_SetScale(const ATexture: AGT_Texture; const AScale: Single);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetScale(AScale);
end;

function  AGT_Texture_GetColor(const ATexture: AGT_Texture): AGT_Color;
begin
  Result := Default(AGT_Color);
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetColor();
end;

procedure AGT_Texture_SetColor(const ATexture: AGT_Texture; const AColor: AGT_Color);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetColor(AColor);
end;

procedure AGT_Texture_SetColorEx(const ATexture: AGT_Texture; const ARed, AGreen, ABlue, AAlpha: Single);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetColor(ARed, AGreen, ABlue, AAlpha);
end;

function  AGT_Texture_GetAngle(const ATexture: AGT_Texture): Single;
begin
  Result := 0;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetAngle();
end;

procedure AGT_Texture_SetAngle(const ATexture: AGT_Texture; const AAngle: Single);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetAngle(AAngle);
end;

function  AGT_Texture_GetHFlip(const ATexture: AGT_Texture): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetHFlip();
end;

procedure AGT_Texture_SetHFlip(const ATexture: AGT_Texture; const AFlip: Boolean);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetHFlip(AFlip);
end;

function  AGT_Texture_GetVFlip(const ATexture: AGT_Texture): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetVFlip();
end;

procedure AGT_Texture_SetVFlip(const ATexture: AGT_Texture; const AFlip: Boolean);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetVFlip(AFlip);
end;

function  AGT_Texture_GetRegion(const ATexture: AGT_Texture): AGT_Rect;
begin
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetRegion();
end;

procedure AGT_Texture_SetRegion(const ATexture: AGT_Texture; const ARegion: AGT_Rect);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetRegion(ARegion);
end;

procedure AGT_Texture_SetRegionEx(const ATexture: AGT_Texture; const X, Y, AWidth, AHeight: Single);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetRegion(X, Y, AWidth, AHeight);
end;

procedure AGT_Texture_ResetRegion(const ATexture: AGT_Texture);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.ResetRegion();
end;

procedure AGT_Texture_Draw(const ATexture: AGT_Texture; const AWindow: AGT_Window);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.Draw(AWindow);
end;

procedure AGT_Texture_DrawTiled(const ATexture: AGT_Texture; const AWindow: AGT_Window; const ADeltaX, ADeltaY: Single);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.DrawTiled(AWindow, ADeltaX, ADeltaY);
end;

function  AGT_Texture_Save(const ATexture: AGT_Texture; const AFilename: PWideChar): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.Save(string(AFilename));
end;

function  AGT_Texture_Lock(const ATexture: AGT_Texture): Boolean;
begin
  Result := False;
  if not Assigned(ATexture) then Exit;

  Result := ATexture.Lock();
end;

procedure AGT_Texture_Unlock(const ATexture: AGT_Texture);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.Unlock();
end;

function  AGT_Texture_GetPixel(const ATexture: AGT_Texture; const X, Y: Single): AGT_Color;
begin
  Result := Default(AGT_Color);
  if not Assigned(ATexture) then Exit;

  Result := ATexture.GetPixel(X, Y);
end;

procedure AGT_Texture_SetPixel(const ATexture: AGT_Texture; const X, Y: Single; const AColor: AGT_Color);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetPixel(X, Y, AColor);
end;

procedure AGT_Texture_SetPixelEx(const ATexture: AGT_Texture; const X, Y: Single; const ARed, AGreen, ABlue, AAlpha: Byte);
begin
  if not Assigned(ATexture) then Exit;

  ATexture.SetPixel(X, Y, ARed, AGreen, ABlue, AAlpha);
end;

function  AGT_Texture_CollideAABB(const ATexture1: AGT_Texture; const ATexture2: AGT_Texture): Boolean;
begin
  Result := False;
  if not Assigned(ATexture1) then Exit;
  if not Assigned(ATexture2) then Exit;

  Result := ATexture1.CollideAABB(ATexture2);
end;

function  AGT_Texture_CollideOBB(const ATexture1: AGT_Texture; const ATexture2: AGT_Texture): Boolean;
begin
  Result := False;
  if not Assigned(ATexture1) then Exit;
  if not Assigned(ATexture2) then Exit;

  Result := ATexture1.CollideOBB(ATexture2);
end;

{ AGT_Texture }
function  Texture_Read(AUser: Pointer; AData: PUTF8Char; ASize: Integer): Integer; cdecl;
var
  LIO: AGT_IO;
begin
  Result := -1;

  LIO := AGT_IO(AUser);
  if not Assigned(LIO) then Exit;

  Result := LIO.Read(AData, ASize);
end;

procedure Texture_Skip(AUser: Pointer; AOffset: Integer); cdecl;
var
  LIO: AGT_IO;
begin
  LIO := AGT_IO(AUser);
  if not Assigned(LIO) then Exit;

  LIO.Seek(AOffset, AGT_iosCurrent);
end;

function  Texture_Eof(AUser: Pointer): Integer;  cdecl;
var
  LIO: AGT_IO;
begin
  Result := -1;

  LIO := AGT_IO(AUser);
  if not Assigned(LIO) then Exit;

  Result := Ord(LIO.Eos);
end;

procedure AGT_Texture.ConvertMaskToAlpha(Data: Pointer; Width, Height: Integer; MaskColor: AGT_Color);
var
  I: Integer;
  LPixelPtr: PRGBA;
begin
  LPixelPtr := PRGBA(Data);
  if not Assigned(LPixelPtr) then Exit;

  for I := 0 to Width * Height - 1 do
  begin
    if (LPixelPtr^.R = Round(MaskColor.r * 256)) and
       (LPixelPtr^.G = Round(MaskColor.g * 256)) and
       (LPixelPtr^.B = Round(MaskColor.b * 256)) then
      LPixelPtr^.A := 0
    else
      LPixelPtr^.A := 255;

    Inc(LPixelPtr);
  end;
end;

constructor AGT_Texture.Create();
begin
  inherited;
end;

destructor AGT_Texture.Destroy();
begin
  Unload();
  inherited;
end;

function  AGT_Texture.Alloc(const AWidth, AHeight: Integer): Boolean;
var
  LData: array of Byte;
begin
  Result := False;

  if FHandle <> 0 then Exit;

  // init RGBA data
  SetLength(LData, AWidth * AHeight * 4);

  glGenTextures(1, @FHandle);
  glBindTexture(GL_TEXTURE_2D, FHandle);

  // init the texture with transparent pixels
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, AWidth, AHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, @LData[0]);

  // set texture parameters
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

  FSize.w := AWidth;
  FSize.h := AHeight;
  FChannels := 4;

  SetBlend(AGT_tbAlpha);
  SetColor(AGT_WHITE);
  SetScale(1.0);
  SetAngle(0.0);
  SetHFlip(False);
  SetVFlip(False);
  SetPivot(0.5, 0.5);
  SetAnchor(0.5, 0.5);
  SetPos(0.0, 0.0);
  ResetRegion();

  glBindTexture(GL_TEXTURE_2D, 0);

  Result := True;
end;

procedure AGT_Texture.Fill(const AColor: AGT_Color);
var
  X,Y,LWidth,LHeight: Integer;
begin
  if FHandle = 0 then Exit;

  LWidth := Round(FSize.w);
  LHeight := Round(FSize.h);

  glBindTexture(GL_TEXTURE_2D, FHandle);

  for X := 0 to LWidth-1 do
  begin
    for Y := 0 to LHeight-1 do
    begin
      glTexSubImage2D(GL_TEXTURE_2D, 0, X, Y, 1, 1, GL_RGBA, GL_FLOAT, @AColor);
    end;
  end;

  glBindTexture(GL_TEXTURE_2D, 0);
end;

function  AGT_Texture.Load(const ARGBData: Pointer; const AWidth, AHeight: Integer): Boolean;
begin
  Result := False;

  if FHandle > 0 then Exit;

  if not Alloc(AWidth, AHeight) then Exit;

  glBindTexture(GL_TEXTURE_2D, FHandle);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, AWidth, AHeight, 0, GL_ALPHA, GL_UNSIGNED_BYTE, ARGBData);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glBindTexture(GL_TEXTURE_2D, 0);

  Result := True;
end;

function  AGT_Texture.Load(const AIO: AGT_IO; const AOwnIO: Boolean; const AColorKey: PAGT_Color): Boolean;
var
  LCallbacks: stbi_io_callbacks;
  LData: Pstbi_uc;
  LWidth,LHeight,LChannels: Integer;
  LIO: AGT_IO;
begin
  Result := False;

  if FHandle > 0 then Exit;

  if not Assigned(AIO) then Exit;

  LIO := AIO;

  LCallbacks.read := Texture_Read;
  LCallbacks.skip := Texture_Skip;
  LCallbacks.eof := Texture_Eof;

  LData := stbi_load_from_callbacks(@LCallbacks, LIO, @LWidth, @LHeight, @LChannels, 4);
  if not Assigned(LData) then Exit;

  if Assigned(AColorKey) then
    ConvertMaskToAlpha(LData, LWidth, LHeight, AColorKey^);

  glGenTextures(1, @FHandle);
  glBindTexture(GL_TEXTURE_2D, FHandle);

  // Set texture parameters
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, LWidth, LHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, LData);

  stbi_image_free(LData);

  FSize.w := LWidth;
  FSize.h := LHeight;
  FChannels := LChannels;

  SetBlend(AGT_tbAlpha);
  SetColor(AGT_WHITE);
  SetScale(1.0);
  SetAngle(0.0);
  SetHFlip(False);
  SetVFlip(False);
  SetPivot(0.5, 0.5);
  SetAnchor(0.5, 0.5);
  SetPos(0.0, 0.0);
  ResetRegion();

  glBindTexture(GL_TEXTURE_2D, 0);

  if AOwnIO then
  begin
    AIO.Free();
  end;

  Result := True;
end;

function  AGT_Texture.LoadFromFile(const AFilename: string; const AColorKey: PAGT_Color): Boolean;
var
  LIO: AGT_FileIO;
begin
  Result := False;
  //if not IGet(IFileIO, LIO) then Exit;
  LIO := AGT_FileIO.Create();
  try
    if not LIO.Open(AFilename, AGT_iomRead) then Exit;
    Result := Load(LIO, False, AColorKey);
  finally
    LIO.Free();
  end;
end;

function  AGT_Texture.LoadFromZipFile(const AZipFilename, AFilename: string; const AColorKey: PAGT_Color; const APassword: string): Boolean;
var
  LIO: AGT_ZipFileIO;
begin
  Result := False;
  LIO := AGT_ZipFileIO.Create();
  try
    if not LIO.Open(AZipFilename, AFilename, APassword) then Exit;
    Result := Load(LIO, False, AColorkey);
  finally
    LIO.Free();
  end;
end;

function  AGT_Texture.IsLoaded(): Boolean;
begin
  Result := Boolean(FHandle > 0);
end;

procedure AGT_Texture.Unload();
begin
  if FHandle > 0 then
  begin
    glDeleteTextures(1, @FHandle);
  end;
  FHandle := 0;
end;

function  AGT_Texture.GetHandle(): Cardinal;
begin
  Result := FHandle;
end;

function  AGT_Texture.GetChannels(): Integer;
begin
  Result := -1;
  if FHandle = 0 then Exit;
  Result := FChannels;
end;

function  AGT_Texture.GetSize(): AGT_Size;
begin
  Result := AGT_Math.Size(0,0);
  if FHandle = 0 then Exit;
  Result := FSize;
end;

function  AGT_Texture.GetPivot(): AGT_Point;
begin
  Result := AGT_Math.Point(0,0);
  if FHandle = 0 then Exit;
  Result := FPivot;
end;

procedure AGT_Texture.SetPivot(const APoint: AGT_Point);
begin
  if FHandle = 0 then Exit;
  SetPivot(APoint.X, APoint.Y);
end;

procedure AGT_Texture.SetPivot(const X, Y: Single);
begin
  if FHandle = 0 then Exit;
  FPivot.x := EnsureRange(X, 0, 1);
  FPivot.y := EnsureRange(Y, 0, 1);
end;

function  AGT_Texture.GetAnchor(): AGT_Point;
begin
  if FHandle = 0 then Exit;
  Result := FAnchor;
end;

procedure AGT_Texture.SetAnchor(const APoint: AGT_Point);
begin
  if FHandle = 0 then Exit;
  SetAnchor(APoint.x, APoint.y);
end;

procedure AGT_Texture.SetAnchor(const X, Y: Single);
begin
  if FHandle = 0 then Exit;
  FAnchor.x := EnsureRange(X, 0, 1);
  FAnchor.y := EnsureRange(Y, 0, 1);
end;

function  AGT_Texture.GetBlend(): AGT_TextureBlend;
begin
  Result := AGT_tbNone;
  if FHandle = 0 then Exit;
  Result := FBlend;
end;

procedure AGT_Texture.SetBlend(const AValue: AGT_TextureBlend);
begin
  if FHandle = 0 then Exit;
  FBlend := AValue;
end;

function  AGT_Texture.GetPos(): AGT_Point;
begin
  if FHandle = 0 then Exit;
  Result := FPos;
end;

procedure AGT_Texture.SetPos(const APos: AGT_Point);
begin
  if FHandle = 0 then Exit;
  FPos := APos;
end;

procedure AGT_Texture.SetPos(const X, Y: Single);
begin
  if FHandle = 0 then Exit;
  FPos.x := X;
  FPos.y := Y;
end;

function  AGT_Texture.GetScale(): Single;
begin
  Result := 0;
  if FHandle = 0 then Exit;
  Result := FScale;
end;

procedure AGT_Texture.SetScale(const AScale: Single);
begin
  if FHandle = 0 then Exit;
  FScale := AScale;
end;

function  AGT_Texture.GetColor(): AGT_Color;
begin
  Result := AGT_BLANK;
  if FHandle = 0 then Exit;
  Result := FColor;
end;

procedure AGT_Texture.SetColor(const AColor: AGT_Color);
begin
  if FHandle = 0 then Exit;
  FColor := AColor;
end;

procedure AGT_Texture.SetColor(const ARed, AGreen, ABlue, AAlpha: Single);
begin
  if FHandle = 0 then Exit;

  FColor.r:= EnsureRange(ARed, 0, 1);
  FColor.g := EnsureRange(AGreen, 0, 1);
  FColor.b := EnsureRange(ABlue, 0, 1);
  FColor.a := EnsureRange(AAlpha, 0, 1);
end;

function  AGT_Texture.GetAngle(): Single;
begin
  Result := 0;
  if FHandle = 0 then Exit;
  Result := FAngle;
end;

procedure AGT_Texture.SetAngle(const AAngle: Single);
begin
  if FHandle = 0 then Exit;
  FAngle := AAngle;
end;

function  AGT_Texture.GetHFlip(): Boolean;
begin
  Result := FAlse;
  if FHandle = 0 then Exit;
  Result := FHFlip;
end;

procedure AGT_Texture.SetHFlip(const AFlip: Boolean);
begin
  if FHandle = 0 then Exit;
  FHFlip := AFlip;
end;

function  AGT_Texture.GetVFlip(): Boolean;
begin
  Result := False;
  if FHandle = 0 then Exit;
  Result := FVFlip;
end;

procedure AGT_Texture.SetVFlip(const AFlip: Boolean);
begin
  if FHandle = 0 then Exit;
  FVFlip := AFlip;
end;

function  AGT_Texture.GetRegion(): AGT_Rect;
begin
  Result := AGT_Math.Rect(0,0,0,0);
  if FHandle = 0 then Exit;
  Result := FRegion;
end;

procedure AGT_Texture.SetRegion(const ARegion: AGT_Rect);
begin
  if FHandle = 0 then Exit;
  SetRegion(ARegion.pos.x, ARegion.pos.y, ARegion.size.w, ARegion.size.h);
end;

procedure AGT_Texture.SetRegion(const X, Y, AWidth, AHeight: Single);
begin
  if FHandle = 0 then Exit;
 FRegion.pos.X := X;
 FRegion.pos.Y := Y;
 FRegion.size.w := AWidth;
 FRegion.size.h := AHeight;
end;

procedure AGT_Texture.ResetRegion();
begin
  if FHandle = 0 then Exit;
  FRegion.pos.X := 0;
  FRegion.pos.Y := 0;
  FRegion.size.W := FSize.w;
  FRegion.size.H := FSize.h;
end;

procedure AGT_Texture.Draw(const AWindow: AGT_Window);
var
  FlipX, FlipY: Single;
begin
  if FHandle = 0 then Exit;
  if not Assigned(AWindow) then Exit;

  glBindTexture(GL_TEXTURE_2D, FHandle);
  glEnable(GL_TEXTURE_2D);

  glPushMatrix();

  // Set the color
  glColor4f(FColor.r, FColor.g, FColor.b, FColor.a);

  // set blending
  case FBlend of
    AGT_tbNone: // no blending
    begin
      glDisable(GL_BLEND);
      glBlendFunc(GL_ONE, GL_ZERO);
    end;

    AGT_tbAlpha: // alpha blending
    begin
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    end;

    AGT_tbAdditiveAlpha: // addeditve blending
    begin
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    end;
  end;

  // Use the normalized anchor value
  glTranslatef(FPos.X - (FAnchor.X * FRegion.size.w * FScale), FPos.Y - (FAnchor.Y * FRegion.size.h * FScale), 0);
  glScalef(FScale, FScale, 1);

  // Apply rotation using the normalized pivot value
  glTranslatef(FPivot.X * FRegion.size.w, FPivot.Y * FRegion.size.h, 0);
  glRotatef(FAngle, 0, 0, 1);
  glTranslatef(-FPivot.X * FRegion.size.w, -FPivot.Y * FRegion.size.h, 0);

  // Apply flip
  if FHFlip then FlipX := -1 else FlipX := 1;
  if FVFlip then FlipY := -1 else FlipY := 1;
  glScalef(FlipX, FlipY, 1);

  // Adjusted texture coordinates and vertices for the specified rectangle
  glBegin(GL_QUADS);
    glTexCoord2f(FRegion.pos.X/FSize.w, FRegion.pos.Y/FSize.h); glVertex2f(0, 0);
    glTexCoord2f((FRegion.pos.X + FRegion.size.w)/FSize.w, FRegion.pos.Y/FSize.h); glVertex2f(FRegion.size.w, 0);
    glTexCoord2f((FRegion.pos.X + FRegion.size.W)/FSize.w, (FRegion.pos.Y + FRegion.size.h)/FSize.h); glVertex2f(FRegion.size.w, FRegion.size.h);
    glTexCoord2f(FRegion.pos.X/FSize.w, (FRegion.pos.Y + FRegion.size.H)/FSize.h); glVertex2f(0, FRegion.size.h);
  glEnd();

  glPopMatrix();

  glDisable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, 0);
end;

procedure AGT_Texture.DrawTiled(const AWindow: AGT_Window; const ADeltaX, ADeltaY: Single);
var
  LW,LH    : Integer;
  LOX,LOY  : Integer;
  LPX,LPY  : Single;
  LFX,LFY  : Single;
  LTX,LTY  : Integer;
  LVPW,LVPH: Integer;
  LVR,LVB  : Integer;
  LIX,LIY  : Integer;
  LViewport: AGT_Rect;
begin
  if FHandle = 0 then Exit;

  SetPivot(0, 0);
  SetAnchor(0, 0);

  LViewport := AWindow.GetViewport();
  LVPW := Round(LViewport.size.w);
  LVPH := Round(LViewport.size.h);

  LW := Round(FSize.w);
  LH := Round(FSize.h);

  LOX := -LW+1;
  LOY := -LH+1;

  LPX := aDeltaX;
  LPY := aDeltaY;

  LFX := LPX-floor(LPX);
  LFY := LPY-floor(LPY);

  LTX := floor(LPX)-LOX;
  LTY := floor(LPY)-LOY;

  if (LTX>=0) then LTX := LTX mod LW + LOX else LTX := LW - -LTX mod LW + LOX;
  if (LTY>=0) then LTY := LTY mod LH + LOY else LTY := LH - -LTY mod LH + LOY;

  LVR := LVPW;
  LVB := LVPH;
  LIY := LTY;

  while LIY<LVB do
  begin
    LIX := LTX;
    while LIX<LVR do
    begin
      SetPos(LIX+LFX, LIY+LFY);
      Draw(AWindow);
      LIX := LIX+LW;
    end;
   LIY := LIY+LH;
  end;
end;

function  AGT_Texture.Save(const AFilename: string): Boolean;
var
  LData: array of Byte;
  LFilename: string;
begin
  Result := False;
  if FHandle = 0 then Exit;

  if AFilename.IsEmpty then Exit;

  // Allocate space for the texture data
  SetLength(LData, Round(FSize.w * FSize.h * 4)); // Assuming RGBA format

  // Bind the texture
  glBindTexture(GL_TEXTURE_2D, FHandle);

  // Read the texture data
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, @LData[0]);

  LFilename := TPath.ChangeExtension(AFilename, 'png');

  // Use stb_image_write to save the texture to a PNG file
  Result := Boolean(stbi_write_png(AGT_Utils.AsUtf8(LFilename, []), Round(FSize.w), Round(FSize.h), 4, @LData[0], Round(FSize.w * 4)));

  // Unbind the texture
  glBindTexture(GL_TEXTURE_2D, 0);
end;

function  AGT_Texture.Lock(): Boolean;
begin
  Result := False;
  if FHandle = 0 then Exit;

  if Assigned(FLock) then Exit;

  GetMem(FLock, Round(FSize.w*FSize.h*4));
  if not Assigned(FLock) then Exit;

  glBindTexture(GL_TEXTURE_2D, FHandle);
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, FLock);
  glBindTexture(GL_TEXTURE_2D, 0);

  Result := True;
end;

procedure AGT_Texture.Unlock();
begin
  if FHandle = 0 then Exit;

  if not Assigned(FLock) then Exit;

  glBindTexture(GL_TEXTURE_2D, FHandle);
  glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, Round(FSize.w), Round(FSize.h), GL_RGBA, GL_UNSIGNED_BYTE, FLock);
  glBindTexture(GL_TEXTURE_2D, 0);
  FreeMem(FLock);
  FLock := nil;
end;

function  AGT_Texture.GetPixel(const X, Y: Single): AGT_Color;
var
  LOffset: Integer;
  LPixel: Cardinal;
begin
  Result := AGT_BLANK;
  if FHandle = 0 then Exit;

  if not Assigned(FLock) then Exit;

  LOffset := Round((Y * FSize.w + X) * 4);
  LPixel := PCardinal(FLock + LOffset)^;

  Result.a := (LPixel shr 24) / $FF;
  Result.b := ((LPixel shr 16) and $FF) / $FF;
  Result.g := ((LPixel shr 8) and $FF) / $FF;
  Result.r := (LPixel and $FF) / $FF;
end;

procedure AGT_Texture.SetPixel(const X, Y: Single; const AColor: AGT_Color);
var
  LOffset: Integer;
begin
  if FHandle = 0 then Exit;

  if not Assigned(FLock) then Exit;

  LOffset := Round((Y * FSize.w + X) * 4);
  PCardinal(FLock + LOffset)^ :=
    (Round(AColor.a*$FF) shl 24) or
    (Round(AColor.b*$FF) shl 16) or
    (Round(AColor.g*$FF) shl 8) or
    Round(AColor.r*$FF);
end;

procedure AGT_Texture.SetPixel(const X, Y: Single; const ARed, AGreen, ABlue, AAlpha: Byte);
var
  LOffset: Integer;
begin
  if FHandle = 0 then Exit;

  if not Assigned(FLock) then Exit;

  LOffset := Round((Y * FSize.w + X) * 4);
  PCardinal(FLock + LOffset)^ :=
    (AAlpha shl 24) or
    (ABlue shl 16) or
    (AGreen shl 8) or
    ARed;
end;

function  AGT_Texture.CollideAABB(const ATexture: AGT_Texture): Boolean;
var
  LA: AGT_Texture;
  LB: AGT_Texture;
  boxA, boxB: c2AABB;

  function _c2v(x, y: Single): c2v;
  begin
    result.x := x;
    result.y := y;
  end;

begin
  Result := False;

  LA := Self;
  LB := ATexture as AGT_Texture;

  if not Assigned(LA) then Exit;
  if LA.FHandle = 0 then Exit;

  if not Assigned(LB) then Exit;
  if LB.FHandle = 0 then Exit;

  // Set up AABB for this texture
  boxA.min := _c2V(LA.FPos.X - (LA.FAnchor.X * LA.FRegion.size.w * LA.FScale), LA.FPos.Y - (LA.FAnchor.Y * LA.FRegion.size.h * LA.FScale));
  boxA.max := _c2V((LA.FPos.X - (LA.FAnchor.X * LA.FRegion.size.w * LA.FScale)) + LA.FRegion.size.w * LA.FScale, (LA.FPos.Y - (LA.FAnchor.Y * LA.FRegion.size.h * LA.FScale)) + LA.FRegion.size.h * LA.FScale);

  // Set up AABB for the other texture
  boxB.min := _c2V(LB.FPos.X - (LB.FAnchor.X * LB.FRegion.size.w * LB.FScale), LB.FPos.Y - (LB.FAnchor.Y * LB.FRegion.size.h * LB.FScale));
  boxB.max := _c2V((LB.FPos.X - (LB.FAnchor.X * LB.FRegion.size.w * LB.FScale)) + LB.FRegion.size.w * LB.FScale, (LB.FPos.Y - (LB.FAnchor.Y * LB.FRegion.size.h * LB.FScale)) + LB.FRegion.size.h * LB.FScale);

  // Check for collision and return result
  Result := Boolean(c2AABBtoAABB(boxA, boxB));
end;

function AGT_Texture.CollideOBB(const ATexture: AGT_Texture): Boolean;
var
  obbA, obbB: AGT_OBB;
begin
  // Set up OBB for this texture
  obbA.Center := AGT_Math.Point(FPos.X, FPos.Y);
  obbA.Extents := AGT_Math.Point(FRegion.size.w * FScale / 2, FRegion.size.h * FScale / 2);
  obbA.Rotation := FAngle;

  // Set up OBB for the other texture
  obbB.Center := AGT_Math.Point(ATexture.GetPos().X, ATexture.GetPos().Y);
  obbB.Extents := AGT_Math.Point(ATexture.GetRegion().size.w * ATexture.GetScale() / 2, ATexture.GetRegion().size.h * ATexture.GetScale() / 2);
  obbB.Rotation := ATexture.GetAngle();

  // Check for collision and return result
  Result := AGT_Math.OBBIntersect(obbA, obbB);
end;

class function AGT_Texture.Init(const AZipFilename, AFilename: string; const AColorKey: PAGT_Color=nil; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): AGT_Texture;
begin
  Result := AGT_Texture.Create();
  if not Result.LoadFromZipFile(AZipFilename, AFilename, AColorKey, APassword) then
  begin
    Result.Free();
    Result := nil;
  end;
end;

class function AGT_Texture.Spine(const AIO: AGT_IO; const AOwnIO: Boolean=True): GLuint;
var
  LCallbacks: stbi_io_callbacks;
  LData: Pstbi_uc;
  LWidth,LHeight,LChannels: Integer;
  LIO: AGT_IO;
  LPrevTexture: GLuint;
begin
  Result := 0;
  if not Assigned(AIO) then Exit;

  LIO := AIO;

  LCallbacks.read := Texture_Read;
  LCallbacks.skip := Texture_Skip;
  LCallbacks.eof := Texture_Eof;

  LData := stbi_load_from_callbacks(@LCallbacks, LIO, @LWidth, @LHeight, @LChannels, 4);
  if not Assigned(LData) then Exit;

  glGenTextures(1, @Result);

  glGetIntegerv(GL_TEXTURE_BINDING_2D, @LPrevTexture);

  glBindTexture(GL_TEXTURE_2D, Result);

  // Set texture parameters
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, LWidth, LHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, LData);

  stbi_image_free(LData);

  glBindTexture(GL_TEXTURE_2D, LPrevTexture);

  if AOwnIO then
  begin
    AIO.Free();
  end;
end;

class procedure AGT_Texture.Delete(const ATexture: GLuint);
var
  LCurrentTexture: GLuInt;
begin
  // Exit if the texture pointer is not valid.
  if ATexture = 0 then Exit;

  // Save current texture
  glGetIntegerv(GL_TEXTURE_BINDING_2D, @LCurrentTexture);

  // Delete spine texture
  glDeleteTextures(1, @ATexture);

  // Restore current texture
  if LCurrentTexture <> 0 then
  begin
    glBindTexture(GL_TEXTURE_2D, LCurrentTexture);
  end;
end;

end.
