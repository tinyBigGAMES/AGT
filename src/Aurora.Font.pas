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

unit Aurora.Font;

{$I Aurora.Defines.inc}

interface

uses
  WinApi.Windows,
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.Math,
  System.Classes,
  Aurora.CLibs,
  Aurora.OpenGL,
  Aurora.Common,
  Aurora.Color,
  Aurora.Math,
  Aurora.Utils,
  Aurora.IO,
  Aurora.MemoryIO,
  Aurora.FileIO,
  Aurora.ZipFileIO,
  Aurora.Window,
  Aurora.Texture;

type
  { AGT_Font }
  AGT_Font = class(TAGTBaseObject)
  protected const
    DEFAULT_GLYPHS = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~™©';
  protected type
    PFontGlyph = ^TFontGlyph;
    TFontGlyph = record
      SrcRect: AGT_Rect;
      DstRect: AGT_Rect;
      XAdvance: Single;
    end;
  protected
    FAtlasSize: Integer;
    FAtlas: AGT_Texture;
    FBaseLine: Single;
    FGlyph: TDictionary<Integer, TFontGlyph>;
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function  Load(const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: string=''): Boolean; overload;
    function  Load(const AWindow: AGT_Window; const AIO: AGT_IO; const ASize: Cardinal; const AGlyphs: string=''; const AOwnIO: Boolean=True): Boolean; overload;
    function  LoadFromFile(const AWindow: AGT_Window; const AFilename: string; const ASize: Cardinal; const AGlyphs: string=''): Boolean;
    function  LoadFromZipFile(const AWindow: AGT_Window; const AZipFilename, AFilename: string; const ASize: Cardinal; const AGlyphs: string=''; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): Boolean;
    procedure Unload();
    procedure DrawText(const AWindow: AGT_Window; const X, Y: Single; const AColor: AGT_Color; AHAlign: AGT_HAlign; const AText: string); overload;
    procedure DrawText(const AWindow: AGT_Window; const X: Single; var Y: Single; const aLineSpace: Single; const aColor: AGT_Color; AHAlign: AGT_HAlign; const AText: string); overload;
    procedure DrawText(const AWindow: AGT_Window; const X, Y: Single; const AColor: AGT_Color; AHAlign: AGT_HAlign; const AText: string; const AArgs: array of const); overload;
    procedure DrawText(const AWindow: AGT_Window; const X: Single; var Y: Single; const aLineSpace: Single; const aColor: AGT_Color; AHAlign: AGT_HAlign; const AText: string; const AArgs: array of const); overload;
    function  TextLength(const AText: string): Single; overload;
    function  TextLength(const AText: string; const AArgs: array of const): Single; overload;
    function  TextHeight(): Single;
    function  SaveTexture(const AFilename: string): Boolean;

    class function Init(const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: string=''): AGT_Font; overload; static;
    class function Init(const AWindow: AGT_Window; const AZipFilename, AFilename: string; const ASize: Cardinal; const AGlyphs: string=''; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): AGT_Font; overload; static;

  end;

//=== EXPORTS ===============================================================
function  AGT_Font_Create(): AGT_Font; cdecl; exports AGT_Font_Create;
function  AGT_Font_CreateDefault(const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: PWideChar=nil): AGT_Font; cdecl; exports AGT_Font_CreateDefault;
function  AGT_Font_CreateFromZipFile(const AWindow: AGT_Window; const AZipFilename, AFilename, APassword: PWideChar; const ASize: Cardinal; const AGlyphs: PWideChar=nil): AGT_Font; cdecl; exports AGT_Font_CreateFromZipFile;
procedure AGT_Font_Destroy(var AFont: AGT_Font); cdecl; exports AGT_Font_Destroy;
procedure AGT_Font_Unload(const AFont: AGT_Font); cdecl; exports AGT_Font_Unload;
function  AGT_Font_LoadDefault(const AFont: AGT_Font; const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: PWideChar=nil): Boolean; cdecl; exports AGT_Font_LoadDefault;
function  AGT_Font_LoadFromIO(const AFont: AGT_Font; const AWindow: AGT_Window; const AIO: AGT_IO; const ASize: Cardinal; const AGlyphs: PWideChar=nil; const AOwnIO: Boolean=True): Boolean; cdecl; exports AGT_Font_LoadFromIO;
function  AGT_Font_LoadFromFile(const AFont: AGT_Font; const AWindow: AGT_Window; const AFilename: PWideChar; const ASize: Cardinal; const AGlyphs: PWideChar=nil): Boolean; cdecl; exports AGT_Font_LoadFromFile;
function  AGT_Font_LoadFromZipFile(const AFont: AGT_Font; const AWindow: AGT_Window; const AZipFilename, AFilename,  APassword: PWideChar; const ASize: Cardinal; const AGlyphs: PWideChar=nil): Boolean; cdecl; exports AGT_Font_LoadFromZipFile;
procedure AGT_Font_DrawText(const AFont: AGT_Font; const AWindow: AGT_Window; const X, Y: Single; const AColor: AGT_Color; AHAlign: AGT_HAlign; const AText: PWideChar); cdecl; exports AGT_Font_DrawText;
procedure AGT_Font_DrawTextVarY(const AFont: AGT_Font; const AWindow: AGT_Window; const X: Single; var Y: Single; const aLineSpace: Single; const aColor: AGT_Color; AHAlign: AGT_HAlign; const AText: PWideChar); cdecl; exports AGT_Font_DrawTextVarY;
function  AGT_Font_TextLength(const AFont: AGT_Font; const AText: PWideChar): Single; cdecl; exports AGT_Font_TextLength;
function  AGT_Font_TextHeight(const AFont: AGT_Font): Single; cdecl; exports AGT_Font_TextHeight;
function  AGT_Font_SaveTexture(const AFont: AGT_Font; const AFilename: PWideChar): Boolean; cdecl; exports AGT_Font_SaveTexture;

implementation

//=== EXPORTS ===============================================================
function  AGT_Font_Create(): AGT_Font;
begin
  Result := AGT_Font.Create();
end;

function  AGT_Font_CreateDefault(const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: PWideChar=nil): AGT_Font;
begin
  Result := AGT_Font.Init(AWindow, ASize, string(AGlyphs));
end;

function  AGT_Font_CreateFromZipFile(const AWindow: AGT_Window; const AZipFilename, AFilename, APassword: PWideChar; const ASize: Cardinal; const AGlyphs: PWideChar=nil): AGT_Font;
begin
  Result := AGT_Font.Init(AWindow, string(AZipFilename), string(AFilename), ASize, string(AGlyphs), string(APassword));
end;

procedure AGT_Font_Destroy(var AFont: AGT_Font);
begin
  if Assigned(AFont) then
  begin
    AFont.Free();
    AFont := nil;
  end;
end;

procedure AGT_Font_Unload(const AFont: AGT_Font);
begin
  if Assigned(AFont) then
  begin
    AFont.Unload();
  end;
end;

function  AGT_Font_LoadDefault(const AFont: AGT_Font; const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: PWideChar=nil): Boolean;
begin
  Result := False;
  if not Assigned(AFont) then Exit;

  Result := AFont.Load(AWindow, ASize, string(AGlyphs));
end;

function  AGT_Font_LoadFromIO(const AFont: AGT_Font; const AWindow: AGT_Window; const AIO: AGT_IO; const ASize: Cardinal; const AGlyphs: PWideChar=nil; const AOwnIO: Boolean=True): Boolean;
begin
  Result := False;
  if not Assigned(AFont) then Exit;

  Result := AFont.Load(AWindow, AIO, ASize, string(AGlyphs), AOwnIO);
end;

function  AGT_Font_LoadFromFile(const AFont: AGT_Font; const AWindow: AGT_Window; const AFilename: PWideChar; const ASize: Cardinal; const AGlyphs: PWideChar=nil): Boolean;
begin
  Result := False;
  if not Assigned(AFont) then Exit;

  Result := AFont.LoadFromFile(AWindow, string(AFilename), ASize, string(AGlyphs));
end;

function  AGT_Font_LoadFromZipFile(const AFont: AGT_Font; const AWindow: AGT_Window; const AZipFilename, AFilename,  APassword: PWideChar; const ASize: Cardinal; const AGlyphs: PWideChar=nil): Boolean;
begin
  Result := False;
  if not Assigned(AFont) then Exit;

  Result := AFont.LoadFromZipFile(AWindow, string(AZipFilename), string(AFilename), ASize, string(AGlyphs));
end;

procedure AGT_Font_DrawText(const AFont: AGT_Font; const AWindow: AGT_Window; const X, Y: Single; const AColor: AGT_Color; AHAlign: AGT_HAlign; const AText: PWideChar);
begin
  if not Assigned(AFont) then Exit;

  AFont.DrawText(AWindow, X, Y, AColor, AHAlign, string(AText));
end;

procedure AGT_Font_DrawTextVarY(const AFont: AGT_Font; const AWindow: AGT_Window; const X: Single; var Y: Single; const aLineSpace: Single; const aColor: AGT_Color; AHAlign: AGT_HAlign; const AText: PWideChar);
begin
  if not Assigned(AFont) then Exit;

  AFont.DrawText(AWindow, X, Y, ALineSpace, AColor, AHAlign, string(AText));
end;

function  AGT_Font_TextLength(const AFont: AGT_Font; const AText: PWideChar): Single;
begin
  Result := 0;
  if not Assigned(AFont) then Exit;

  Result := AFont.TextLength(string(AText));
end;

function  AGT_Font_TextHeight(const AFont: AGT_Font): Single;
begin
  Result := 0;
  if not Assigned(AFont) then Exit;

  Result := AFont.TextHeight();
end;

function  AGT_Font_SaveTexture(const AFont: AGT_Font; const AFilename: PWideChar): Boolean;
begin
  Result := False;
  if not Assigned(AFont) then Exit;

  Result := AFont.SaveTexture(string(AFilename));
end;

{ AGT_Font }
constructor AGT_Font.Create();
begin
  inherited;
  FGlyph := TDictionary<Integer, TFontGlyph>.Create();
end;

destructor AGT_Font.Destroy();
begin
  Unload();
  FGlyph.Free();

  inherited;
end;

function  AGT_Font.Load(const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: string): Boolean;
const
  CDefaultFontResName = 'db1184eec13447cb8cceb28a1052bd96';
var
  LResStream: TResourceStream;
  LIO: AGT_MemoryIO;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;
  if not AGT_Utils.ResourceExists(HInstance, CDefaultFontResName) then Exit;

  LResStream := TResourceStream.Create(HInstance, CDefaultFontResName, RT_RCDATA);
  try
    LIO := AGT_MemoryIO.Create;
    LIO.Open(LResStream.Memory, LResStream.Size);
    if not Load(AWindow, LIO, ASize, AGlyphs) then Exit;
  finally
    LResStream.Free();
  end;
end;

function  AGT_Font.Load(const AWindow: AGT_Window; const AIO: AGT_IO; const ASize: Cardinal; const AGlyphs: string; const AOwnIO: Boolean): Boolean;
var
  LBuffer: TAGTVirtualBuffer;
  LChars: TAGTVirtualBuffer;
  LFileSize: Int64;
  LFontInfo: stbtt_fontinfo;
  NumOfGlyphs: Integer;
  LGlyphChars: string;
  LCodePoints: array of Integer;
  LBitmap: array of Byte;
  LPackContext: stbtt_pack_context;
  LPackRange: stbtt_pack_range;
  I: Integer;
  LGlyph: TFontGlyph;
  LChar: Pstbtt_packedchar;
  LScale: Single;
  LAscent: Integer;
  LSize: Single;
  LMaxTextureSize: Integer;
  LDpiScale: Single;
  LIO: AGT_IO;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;
  if not Assigned(AIO) then Exit;

  LIO := AIO;

  LDpiScale := AWindow.GetScale().h;
  LMaxTextureSize :=  AWindow.GetMaxTextureSize();

  LSize := aSize * LDpiScale;
  LFileSize :=  LIO.Size();
  LBuffer := TAGTVirtualBuffer.Create(LFileSize);
  try
    LIO.Read(LBuffer.Memory, LFileSize);

    if stbtt_InitFont(@LFontInfo, LBuffer.Memory, 0) = 0 then Exit;
    LGlyphChars := DEFAULT_GLYPHS + aGlyphs;
    LGlyphChars := AGT_Utils.RemoveDuplicates(LGlyphChars);
    NumOfGlyphs :=  LGlyphChars.Length;
    SetLength(LCodePoints, NumOfGlyphs);

    for I := 1 to NumOfGlyphs do
    begin
      LCodePoints[I-1] := Integer(Char(LGlyphChars[I]));
    end;

    LChars := TAGTVirtualBuffer.Create(SizeOf(stbtt_packedchar) * (NumOfGlyphs+1));
    try
      LPackRange.font_size := -LSize;
      LPackRange.first_unicode_codepoint_in_range := 0;
      LPackRange.array_of_unicode_codepoints := @LCodePoints[0];
      LPackRange.num_chars := NumOfGlyphs;
      LPackRange.chardata_for_range := LChars.Memory;
      LPackRange.h_oversample := 1;
      LPackRange.v_oversample := 1;

      FAtlasSize := 32;

      while True do
      begin
        SetLength(LBitmap, FAtlasSize * FAtlasSize);
        stbtt_PackBegin(@LPackContext, @LBitmap[0], FAtlasSize, FAtlasSize, 0, 1, nil);
        stbtt_PackSetOversampling(@LPackContext, 1, 1);
        if stbtt_PackFontRanges(@LPackContext, LBuffer.Memory, 0, @LPackRange, 1) = 0  then
          begin
            LBitmap := nil;
            stbtt_PackEnd(@LPackContext);
            FAtlasSize := FAtlasSize * 2;
            if (FAtlasSize > LMaxTextureSize) then
            begin
              raise Exception.Create(Format('Font texture too large. Max size: %d', [LMaxTextureSize]));
            end;
          end
        else
          begin
            stbtt_PackEnd(@LPackContext);
            break;
          end;
      end;

      FAtlas := AGT_Texture.Create();
      FAtlas.Load(@LBitmap[0], FAtlasSize, FAtlasSize);
      FAtlas.SetPivot(0, 0);
      FAtlas.SetAnchor(0, 0);
      FAtlas.SetBlend(AGT_tbAlpha);
      FAtlas.SetColor(AGT_WHITE);

      LBitmap := nil;

      LScale := stbtt_ScaleForMappingEmToPixels(@LFontInfo, LSize);
      stbtt_GetFontVMetrics(@LFontInfo, @LAscent, nil, nil);
      FBaseline := LAscent * LScale;

      FGlyph.Clear();
      for I := Low(LCodePoints) to High(LCodePoints) do
      begin
        LChar := Pstbtt_packedchar(LChars.Memory);
        Inc(LChar, I);

        LGlyph.SrcRect.pos.x := LChar.x0;
        LGlyph.SrcRect.pos.y := LChar.y0;
        LGlyph.SrcRect.size.w := LChar.x1-LChar.x0;
        LGlyph.SrcRect.size.h := LChar.y1-LChar.y0;

        LGlyph.DstRect.pos.x := 0 + LChar.xoff;
        LGlyph.DstRect.pos.y := 0 + LChar.yoff + FBaseline;
        LGlyph.DstRect.size.w := (LChar.x1-LChar.x0);
        LGlyph.DstRect.size.h := (LChar.y1-LChar.y0);

        LGlyph.XAdvance := LChar.xadvance;

        FGlyph.Add(LCodePoints[I], LGlyph);
      end;

      if AOwnIO then
      begin
        LIO.Free();
      end;

      Result := True;

    finally
      LChars.Free();
    end;

  finally
    LBuffer.Free();
  end;
end;

function  AGT_Font.LoadFromFile(const AWindow: AGT_Window; const AFilename: string; const ASize: Cardinal; const AGlyphs: string): Boolean;
var
  LIO: AGT_FileIO;
begin
  Result := False;
  LIO := AGT_FileIO.Create();
  try
    if not LIO.Open(AFilename, AGT_iomRead) then Exit;
    Result := Load(AWindow, LIO, ASize, AGlyphs, False);
  finally
    LIO.Free();
  end;
end;

function  AGT_Font.LoadFromZipFile(const AWindow: AGT_Window; const AZipFilename, AFilename: string; const ASize: Cardinal; const AGlyphs: string; const APassword: string): Boolean;
var
  LIO: AGT_ZipFileIO;
begin
  Result := False;

  LIO := AGT_ZipFileIO.Create();
  if not LIO.Open(AZipFilename, AFilename, APassword) then
  begin
    LIO.Free();
    Exit;
  end;

  Result := Load(AWindow, LIO, ASize, AGlyphs, True);
end;

procedure AGT_Font.Unload();
begin
  if Assigned(FAtlas) then
  begin
    FAtlas.Free();
    FGlyph.Clear();
  end;
end;

procedure AGT_Font.DrawText(const AWindow: AGT_Window; const X, Y: Single; const AColor: AGT_Color; AHAlign: AGT_HAlign; const AText: string);
var
  LText: string;
  LChar: Integer;
  LGlyph: TFontGlyph;
  I, LLen: Integer;
  LX, LY: Single;
  LViewport: AGT_Rect;
  LWidth: Single;
begin
  LText := AText;
  LLen := LText.Length;

  LX := X;
  LY := Y;

  LViewport := AWindow.GetViewport();

  case aHAlign of
    AGT_haLeft:
      begin
      end;
    AGT_haCenter:
      begin
        LWidth := TextLength(AText, []);
        LX := (LViewport.size.w - LWidth)/2;
      end;
    AGT_haRight:
      begin
        LWidth := TextLength(AText, []);
        LX := LViewport.size.w - LWidth;
      end;
  end;

  FAtlas.SetColor(AColor);

  for I := 1 to LLen do
  begin
    LChar := Integer(Char(LText[I]));
    if FGlyph.TryGetValue(LChar, LGlyph) then
    begin
      LGlyph.DstRect.pos.x := LGlyph.DstRect.pos.x + LX;
      LGlyph.DstRect.pos.y := LGlyph.DstRect.pos.y + LY;

      FAtlas.SetRegion(LGlyph.SrcRect);
      FAtlas.SetPos(LGlyph.DstRect.pos.x, LGlyph.DstRect.pos.y);
      FAtlas.Draw(AWindow);
      LX := LX + LGlyph.XAdvance;
    end;
  end;
end;

procedure AGT_Font.DrawText(const AWindow: AGT_Window; const X: Single; var Y: Single; const aLineSpace: Single; const aColor: AGT_Color; AHAlign: AGT_HAlign; const AText: string);
begin
  DrawText(AWindow, X, Y, aColor, aHAlign, AText);
  Y := Y + FBaseLine + ALineSpace;
end;

procedure AGT_Font.DrawText(const AWindow: AGT_Window; const X, Y: Single; const AColor: AGT_Color; AHAlign: AGT_HAlign; const AText: string; const AArgs: array of const);
begin
  DrawText(AWindow, X, Y, AColor, AHAlign, Format(AText, AArgs));
end;

procedure AGT_Font.DrawText(const AWindow: AGT_Window; const X: Single; var Y: Single; const aLineSpace: Single; const aColor: AGT_Color; AHAlign: AGT_HAlign; const AText: string; const AArgs: array of const);
begin
  DrawText(AWindow, X, Y, ALineSpace, AColor, AHAlign, Format(AText, AArgs));
end;

function  AGT_Font.TextLength(const AText: string): Single;
var
  LText: string;
  LChar: Integer;
  LGlyph: TFontGlyph;
  I, LLen: Integer;
  LWidth: Single;
begin
  Result := 0;
  if not Assigned(FAtlas) then Exit;

  LText := AText;
  LLen := LText.Length;

  LWidth := 0;

  for I := 1 to LLen do
  begin
    LChar := Integer(Char(LText[I]));
    if FGlyph.TryGetValue(LChar, LGlyph) then
    begin
      LWidth := LWidth + LGlyph.XAdvance;
    end;
  end;

  Result := LWidth;
end;

function  AGT_Font.TextLength(const AText: string; const AArgs: array of const): Single;
begin
  Result := TextLength(Format(AText, AArgs));
end;

function  AGT_Font.TextHeight(): Single;
begin
  Result :=0;
  if not Assigned(FAtlas) then Exit;
  Result := FBaseLine;
end;

function  AGT_Font.SaveTexture(const AFilename: string): Boolean;
begin
  Result := False;
  if not Assigned(FAtlas) then Exit;
  if AFilename.IsEmpty then Exit;
  FAtlas.Save(AFilename);
end;

class function AGT_Font.Init(const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: string=''): AGT_Font;
begin
  Result := AGT_Font.Create();
  Result.Load(AWindow, ASize, AGlyphs);
end;

class function AGT_Font.Init(const AWindow: AGT_Window; const AZipFilename, AFilename: string; const ASize: Cardinal; const AGlyphs: string=''; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): AGT_Font;
begin
  Result := AGT_Font.Create();
  if not Result.LoadFromZipFile(AWindow, AZipFilename, AFilename, ASize, AGlyphs, APassword) then
  begin
    Result.Free();
    Result := nil;
  end;
end;

end.
