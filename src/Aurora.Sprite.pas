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

unit Aurora.Sprite;

{$I Aurora.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Net.HttpClient,
  System.Math,
  Aurora.CLibs,
  Aurora.Common,
  Aurora.Math,
  Aurora.IO,
  Aurora.ZipFileIO,
  Aurora.Color,
  Aurora.Texture;

type
  { AGT_Sprite }
  AGT_Sprite = class(TAGTBaseObject)
  protected type
    PImageRegion = ^TImageRegion;
    TImageRegion = record
      Rect: AGT_Rect;
      Page: Integer;
    end;
    PGroup = ^TGroup;
    TGroup = record
      Image: array of TImageRegion;
      Count: Integer;
    end;
  protected
    FTextures: array of AGT_Texture;
    FGroups: array of TGroup;
    FPageCount: Integer;
    FGroupCount: Integer;
  public
    constructor Create(); override;
    destructor Destroy(); override;
    procedure Clear();
    function LoadPageFromFile(const AFilename: string; AColorKey: PAGT_Color): Integer;
    function LoadPageFromZipFile(const AZipFilename, AFilename: string; AColorKey: PAGT_Color; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): Integer;
    function AddGroup(): Integer;
    function GetGroupCount(): Integer;
    function AddImageFromRect(const APage, AGroup: Integer; const ARect: AGT_Rect; const AXOffset: Integer=0; const AYOffset: Integer=0): Integer;
    function AddImageFromGrid(const APage, AGroup, AGridX, AGridY, AGridWidth, AGridHeight: Integer; const AXOffset: Integer=0; const AYOffset: Integer=0): Integer;
    function AddImages(const APage, AGroup, AColCount, ARowCount, AImageWidth, AImageHeight: Integer; const AXOffset: Integer=0; const AYOffset: Integer=0): Boolean;
    function GetImageCount(const AGroup: Integer): Integer;
    function GetImageWidth(const ANum, AGroup: Integer): Single;
    function GetImageHeight(const ANum, AGroup: Integer): Single;
    function GetImageTexture(const ANum, AGroup: Integer): AGT_Texture;
    function GetImageRegion(const ANum, AGroup: Integer): AGT_Rect;
  end;

implementation

{ AGT_Sprite }
constructor AGT_Sprite.Create();
begin
  inherited;
  FTextures := nil;
  FGroups := nil;
  FPageCount := 0;
  FGroupCount := 0;
end;

destructor AGT_Sprite.Destroy();
begin
  Clear();
  inherited;
end;

procedure AGT_Sprite.Clear();
var
  I: Integer;
begin
  if FTextures <> nil then
  begin
    // free group data
    for I := 0 to FGroupCount - 1 do
    begin
      // free image array
      FGroups[I].Image := nil;
    end;

    // free page
    for I := 0 to FPageCount - 1 do
    begin
      if Assigned(FTextures[I]) then
      begin
        FTextures[I].Free();
      end;
    end;
  end;

  FTextures := nil;
  FGroups := nil;
  FPageCount := 0;
  FGroupCount := 0;
end;

function AGT_Sprite.LoadPageFromFile(const AFilename: string; AColorKey: PAGT_Color): Integer;
var
  LTexture: AGT_Texture;
begin
  Result := -1;
  LTexture := AGT_Texture.Create();
  if not Assigned(LTexture) then Exit;
  if not LTexture.LoadFromFile(AFilename, AColorKey) then
  begin
    LTexture.Free();
    Exit;
  end;

  Result := FPageCount;
  Inc(FPageCount);
  SetLength(FTextures, FPageCount);
  FTextures[Result] := LTexture;
end;

function AGT_Sprite.LoadPageFromZipFile(const AZipFilename, AFilename: string; AColorKey: PAGT_Color; const APassword: string): Integer;
var
  LTexture: AGT_Texture;
begin
  Result := -1;
  LTexture := AGT_Texture.Create();
  if not Assigned(LTexture) then Exit;
  if not LTexture.LoadFromZipFile(AZipFilename, AFilename, AColorkey, APassword) then
  begin
    LTexture.Free();
    Exit;
  end;

  Result := FPageCount;
  Inc(FPageCount);
  SetLength(FTextures, FPageCount);
  FTextures[Result] := LTexture;
end;

function AGT_Sprite.AddGroup(): Integer;
begin
  Result := FGroupCount;
  Inc(FGroupCount);
  SetLength(FGroups, FGroupCount);
end;

function AGT_Sprite.GetGroupCount(): Integer;
begin
  Result := FGroupCount;
end;

function AGT_Sprite.AddImageFromRect(const APage, AGroup: Integer; const ARect: AGT_Rect; const AXOffset: Integer; const AYOffset: Integer): Integer;
begin
  Result := -1;
  if not InRange(APage, 0, FPageCount-1) then Exit;
  if not InRange(AGroup, 0, FGroupCount-1) then Exit;

  Result := FGroups[AGroup].Count;
  Inc(FGroups[AGroup].Count);
  SetLength(FGroups[AGroup].Image, FGroups[AGroup].Count);

  FGroups[AGroup].Image[Result].Rect.pos.X := ARect.pos.X + AXOffset;
  FGroups[AGroup].Image[Result].Rect.pos.Y := ARect.pos.Y + AYOffset;
  FGroups[AGroup].Image[Result].Rect.size.w := aRect.size.w;
  FGroups[AGroup].Image[Result].Rect.size.h := aRect.size.h;
  FGroups[AGroup].Image[Result].Page := APage;
end;

function AGT_Sprite.AddImageFromGrid(const APage, AGroup, AGridX, AGridY, AGridWidth, AGridHeight: Integer; const AXOffset: Integer; const AYOffset: Integer): Integer;
begin
  Result := -1;
  if not InRange(APage, 0, FPageCount-1) then Exit;
  if not InRange(AGroup, 0, FGroupCount-1) then Exit;

  Result := FGroups[AGroup].Count;
  Inc(FGroups[AGroup].Count);
  SetLength(FGroups[AGroup].Image, FGroups[AGroup].Count);

  FGroups[AGroup].Image[Result].Rect.pos.X := (aGridWidth * aGridX) + AXOffset;
  FGroups[AGroup].Image[Result].Rect.pos.Y := (aGridHeight * aGridY) + AYOffset;
  FGroups[AGroup].Image[Result].Rect.size.w := aGridWidth;
  FGroups[AGroup].Image[Result].Rect.size.h := aGridHeight;
  FGroups[AGroup].Image[Result].Page := APage;
end;

function AGT_Sprite.AddImages(const APage, AGroup, AColCount, ARowCount, AImageWidth, AImageHeight: Integer; const AXOffset: Integer=0; const AYOffset: Integer=0): Boolean;
var
  X, Y: Integer;
begin
  Result := False;
  for Y  := 0 to ARowCount-1 do
  begin
    for X := 0 to AColCount-1 do
    begin
      if AddImageFromGrid(APage, AGroup, X, Y,  AImageWidth, AImageHeight, AXOffset, AYOffset) = -1 then Exit;
    end;
  end;
  Result := True;
end;

function AGT_Sprite.GetImageCount(const AGroup: Integer): Integer;
begin
  Result := -1;
  if not InRange(AGroup, 0, FGroupCount-1) then Exit;
  Result := FGroups[AGroup].Count;
end;

function AGT_Sprite.GetImageWidth(const ANum, AGroup: Integer): Single;
begin
  Result := -1;
  if not InRange(AGroup, 0, FGroupCount-1) then Exit;
  if not InRange(ANum, 0, FGroups[AGroup].Count-1) then Exit;
  Result := FGroups[AGroup].Image[ANum].Rect.size.w;
end;

function AGT_Sprite.GetImageHeight(const ANum, AGroup: Integer): Single;
begin
  Result := 0;
  if not InRange(AGroup, 0, FGroupCount-1) then Exit;
  if not InRange(ANum, 0, FGroups[AGroup].Count-1) then Exit;
  Result := FGroups[AGroup].Image[ANum].Rect.size.h;
end;

function AGT_Sprite.GetImageTexture(const ANum, AGroup: Integer): AGT_Texture;
begin
  Result := nil;
  if not InRange(AGroup, 0, FGroupCount-1) then Exit;
  if not InRange(ANum, 0, FGroups[AGroup].Count-1) then Exit;
  Result := FTextures[FGroups[AGroup].Image[ANum].Page];
end;

function AGT_Sprite.GetImageRegion(const ANum, AGroup: Integer): AGT_Rect;
begin
  Result := AGT_Math.Rect(-1,-1,-1,-1);
  if not InRange(AGroup, 0, FGroupCount-1) then Exit;
  if not InRange(ANum, 0, FGroups[AGroup].Count-1) then Exit;
  Result := FGroups[AGroup].Image[ANum].Rect;
end;

end.
