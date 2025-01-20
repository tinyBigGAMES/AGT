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

unit Aurora.Entity;

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
  Aurora.Color,
  Aurora.Window,
  Aurora.Texture,
  Aurora.Sprite;

type
  { AGT_EntityOverlap }
  AGT_EntityOverlap = (AGT_eoAABB, AGT_eoOBB);

  { AGT_Entity }
  AGT_Entity = class(TAGTBaseObject)
  protected
    FSprite: AGT_Sprite;
    FGroup: Integer;
    FFrame: Integer;
    FFrameSpeed: Single;
    FPos: AGT_Vector;
    FDir: AGT_Vector;
    FScale: Single;
    FAngle: Single;
    FAngleOffset : Single;
    FColor: AGT_Color;
    FHFlip: Boolean;
    FVFlip: Boolean;
    FLoopFrame: Boolean;
    FWidth: Single;
    FHeight: Single;
    FRadius: Single;
    FFirstFrame: Integer;
    FLastFrame: Integer;
    FShrinkFactor: Single;
    FPivot: AGT_Point;
    FAnchor: AGT_Point;
    FBlend: AGT_TextureBlend;
    FFrameTimer: TAGTTimer;
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function  Init(const ASprite: AGT_Sprite; const AGroup: Integer): Boolean;
    function  GetPivot(): AGT_Point;
    procedure SetPivot(const APoint: AGT_Point); overload;
    procedure SetPivot(const X, Y: Single); overload;
    function  GetAnchor(): AGT_Point;
    procedure SetAnchor(const APoint: AGT_Point); overload;
    procedure SetAnchor(const X, Y: Single); overload;
    procedure SetFrameRange(const aFirst, aLast: Integer);
    function  NextFrame(): Boolean;
    function  PrevFrame(): Boolean;
    function  GetFrame(): Integer;
    procedure SetFrame(const AFrame: Integer);
    function  GetFrameSpeed(): Single;
    procedure SetFrameSpeed(const AFrameSpeed: Single);
    function  GetFirstFrame(): Integer;
    function  GetLastFrame(): Integer;
    procedure SetPosAbs(const X, Y: Single);
    procedure SetPosRel(const X, Y: Single);
    function  GetPos(): AGT_Vector;
    function  GetDir(): AGT_Vector;
    procedure SetScaleAbs(const AScale: Single);
    procedure SetScaleRel(const AScale: Single);
    function  GetAngle(): Single;
    function  GetAngleOffset(): Single;
    procedure SetAngleOffset(const AAngle: Single);
    procedure RotateAbs(const AAngle: Single);
    procedure RotateRel(const AAngle: Single);
    function  RotateToAngle(const AAngle, ASpeed: Single): Boolean;
    function  RotateToPos(const X, Y, ASpeed: Single): Boolean;
    function  RotateToPosAt(const aSrcX, aSrcY, ADestX, ADestY, ASpeed: Single): Boolean;
    procedure Thrust(const ASpeed: Single);
    procedure ThrustAngle(const AAngle, ASpeed: Single);
    function  ThrustToPos(const aThrustSpeed, ARotSpeed, ADestX, ADestY, ASlowdownDist, AStopDist, AStopSpeed, AStopSpeedEpsilon: Single): Boolean;
    function  IsVisible(const AWindow: AGT_Window): Boolean;
    function  IsFullyVisible(const AWindow: AGT_Window): Boolean;
    function  Collide(const X, Y, aRadius, aShrinkFactor: Single): Boolean; overload;
    function  Collide(const AEntity: AGT_Entity; const AOverlap: AGT_EntityOverlap=AGT_eoAABB): Boolean; overload;
    procedure Render(const AWindow: AGT_Window);
    procedure RenderAt(const AWindow: AGT_Window; const X, Y: Single);
    function  GetSprite(): AGT_Sprite;
    function  GetGroup(): Integer;
    function  GetScale(): Single;
    function  GetColor(): AGT_Color;
    procedure SetColor(const AColor: AGT_Color);
    function  GetBlend(): AGT_TextureBlend;
    procedure SetBlend(const AValue: AGT_TextureBlend);
    function  GetHFlip(): Boolean;
    procedure SetHFlip(const AFlip: Boolean);
    function  GetVFlip: Boolean;
    procedure SetVFlip(const AFlip: Boolean);
    function  GetLoopFrame(): Boolean;
    procedure SetLoopFrame(const aLoop: Boolean);
    function  GetWidth(): Single;
    function  GetHeight(): Single;
    function  GetRadius(): Single;
  end;

implementation

{ AGT_Entity }
constructor AGT_Entity.Create();
begin
  inherited;
end;

destructor AGT_Entity.Destroy();
begin
  inherited;
end;

function AGT_Entity.Init(const ASprite: AGT_Sprite; const AGroup: Integer): Boolean;
begin
  Result := False;
  if not Assigned(ASprite) then Exit;
  if not InRange(AGroup, 0, ASprite.GetGroupCount()-1) then Exit;

  FSprite := aSprite;
  FGroup := AGroup;
  SetFrameRange(0, ASprite.GetImageCount(FGroup)-1);
  SetFrameSpeed(24);
  SetScaleAbs(1.0);
  RotateAbs(0);
  SetAngleOffset(0);
  SetColor(AGT_WHITE);
  SetHFlip(False);
  SetVFlip(False);
  SetLoopFrame(True);
  SetPosAbs(0, 0);
  SetBlend(AGT_tbAlpha);
  SetPivot(0.5, 0.5);
  SetAnchor(0.5, 0.5);
  SetFrame(0);

  Result := True;
end;

function  AGT_Entity.GetPivot(): AGT_Point;
begin
  Result := FPivot;
end;

procedure AGT_Entity.SetPivot(const APoint: AGT_Point);
begin
  FPivot := APoint;
end;

procedure AGT_Entity.SetPivot(const X, Y: Single);
begin
  FPivot.x := X;
  FPivot.y := Y;
end;

function  AGT_Entity.GetAnchor(): AGT_Point;
begin
  Result := FAnchor;
end;

procedure AGT_Entity.SetAnchor(const APoint: AGT_Point);
begin
  FAnchor := APoint;
end;

procedure AGT_Entity.SetAnchor(const X, Y: Single);
begin
  FAnchor.x := X;
  FAnchor.y := Y;
end;

procedure AGT_Entity.SetFrameRange(const aFirst, aLast: Integer);
begin
  FFirstFrame := aFirst;
  FLastFrame  := aLast;
end;

function  AGT_Entity.NextFrame(): Boolean;
begin
  Result := False;
  if FFrameTimer.Check() then
  begin
    Inc(FFrame);
    if FFrame > FLastFrame then
    begin
      if FLoopFrame then
        FFrame := FFirstFrame
      else
        FFrame := FLastFrame;
      Result := True;
    end;
    SetFrame(FFrame);
  end;
end;

function  AGT_Entity.PrevFrame(): Boolean;
begin
  Result := False;
  if FFrameTimer.Check() then
  begin
    Dec(FFrame);
    if FFrame < FFirstFrame then
    begin
      if FLoopFrame then
        FFrame := FLastFrame
      else
        FFrame := FFirstFrame;
      Result := True;
    end;
    SetFrame(FFrame);
  end;
end;

function  AGT_Entity.GetFrame(): Integer;
begin
  Result := FFrame;
end;

procedure AGT_Entity.SetFrame(const AFrame: Integer);
var
  LW, LH, LR: Single;
begin
  FFrame := aFrame;
  EnsureRange(FFrame, 0, FSprite.GetImageCount(FGroup)-1);

  LW := FSprite.GetImageWidth(FFrame, FGroup);
  LH := FSprite.GetImageHeight(FFrame, FGroup);

  LR := (LW + LH) / 2;

  FWidth  := LW * FScale;
  FHeight := LH * FScale;
  FRadius := LR * FScale;
end;

function  AGT_Entity.GetFrameSpeed(): Single;
begin
  Result := FFrameTimer.Speed();
end;

procedure AGT_Entity.SetFrameSpeed(const AFrameSpeed: Single);
begin
  FFrameTimer.InitFPS(AFrameSpeed);
end;

function  AGT_Entity.GetFirstFrame(): Integer;
begin
  Result := FFirstFrame;
end;

function  AGT_Entity.GetLastFrame(): Integer;
begin
  Result := FLastFrame;
end;

procedure AGT_Entity.SetPosAbs(const X, Y: Single);
begin
  FPos.X := X;
  FPos.Y := Y;
  FDir.X := 0;
  FDir.Y := 0;
end;

procedure AGT_Entity.SetPosRel(const X, Y: Single);
begin
  FPos.X := FPos.X + X;
  FPos.Y := FPos.Y + Y;
  FDir.X := X;
  FDir.Y := Y;
end;

function  AGT_Entity.GetPos(): AGT_Vector;
begin
  Result := FPos;
end;

function  AGT_Entity.GetDir(): AGT_Vector;
begin
  Result := FDir;
end;

procedure AGT_Entity.SetScaleAbs(const AScale: Single);
begin
  FScale := AScale;
  SetFrame(FFrame);
end;

procedure AGT_Entity.SetScaleRel(const AScale: Single);
begin
  FScale := FScale + AScale;
  SetFrame(FFrame);
end;

function  AGT_Entity.GetAngle(): Single;
begin
  Result := FAngle;
end;

function  AGT_Entity.GetAngleOffset(): Single;
begin
  Result := FAngleOffset;
end;

procedure AGT_Entity.SetAngleOffset(const AAngle: Single);
begin
  FAngleOffset := FAngleOffset + AAngle;
  AGT_Math.ClipValuef(FAngleOffset, 0, 360, True);
end;

procedure AGT_Entity.RotateAbs(const AAngle: Single);
begin
  FAngle := AAngle;
  AGT_Math.ClipValuef(FAngle, 0, 360, True);
end;

procedure AGT_Entity.RotateRel(const AAngle: Single);
begin
  FAngle := FAngle + AAngle;
  AGT_Math.ClipValuef(FAngle, 0, 360, True);
end;

function  AGT_Entity.RotateToAngle(const AAngle, ASpeed: Single): Boolean;
var
  Step: Single;
  Len : Single;
  S   : Single;
begin
  Result := False;
  Step := AGT_Math.AngleDiff(FAngle, AAngle);
  Len  := Sqrt(Step*Step);
  if Len = 0 then
    Exit;
  S    := (Step / Len) * aSpeed;
  FAngle := FAngle + S;
  if AGT_Math.SameValuef(Step, 0, S) then
  begin
    RotateAbs(aAngle);
    Result := True;
  end;
end;

function  AGT_Entity.RotateToPos(const X, Y, ASpeed: Single): Boolean;
var
  LAngle: Single;
  LStep: Single;
  LLen: Single;
  LS: Single;
  LTmpPos: AGT_Vector;
begin
  Result := False;
  LTmpPos.X  := X;
  LTmpPos.Y  := Y;

  //LAngle := -FPos.Angle(LTmpPos);
  LAngle := -AGT_Math.VectorAngle(FPos, LTmpPos);
  LStep := AGT_Math.AngleDiff(FAngle, LAngle);
  LLen  := Sqrt(LStep*LStep);
  if LLen = 0 then
    Exit;
  LS := (LStep / LLen) * aSpeed;

  if not AGT_Math.SameValuef(LStep, LS, aSpeed) then
    RotateRel(LS)
  else begin
    RotateRel(LStep);
    Result := True;
  end;
end;

function  AGT_Entity.RotateToPosAt(const aSrcX, aSrcY, ADestX, ADestY, ASpeed: Single): Boolean;
var
  LAngle: Single;
  LStep : Single;
  LLen  : Single;
  LS    : Single;
  LSPos,LDPos : AGT_Vector;
begin
  Result := False;
  LSPos.X := aSrcX;
  LSPos.Y := aSrcY;
  LDPos.X  := aDestX;
  LDPos.Y  := aDestY;

  //LAngle := LSPos.Angle(LDPos);
  LAngle := AGT_Math.VectorAngle(LSPos, LDPos);
  LStep := AGT_Math.AngleDiff(FAngle, LAngle);
  LLen  := Sqrt(LStep*LStep);
  if LLen = 0 then
    Exit;
  LS := (LStep / LLen) * aSpeed;
  if not AGT_Math.SameValuef(LStep, LS, aSpeed) then
    RotateRel(LS)
  else begin
    RotateRel(LStep);
    Result := True;
  end;
end;

procedure AGT_Entity.Thrust(const ASpeed: Single);
var
  LS: Single;
  LA: Integer;
begin
  LA := Abs(Round(FAngle + 90.0));
  LA := AGT_Math.ClipValue(LA, 0, 360, True);

  LS := -aSpeed;

  FDir.x := AGT_Math.AngleCos(LA) * LS;
  FDir.y := AGT_Math.AngleSin(LA) * LS;

  FPos.x := FPos.x + FDir.x;
  FPos.y := FPos.y + FDir.y;
end;

procedure AGT_Entity.ThrustAngle(const AAngle, ASpeed: Single);
var
  LS: Single;
  LA: Integer;
begin
  LA := Abs(Round(AAngle));

  AGT_Math.ClipValue(LA, 0, 360, True);

  LS := -aSpeed;

  FDir.x := AGT_Math.AngleCos(LA) * LS;
  FDir.y := AGT_Math.AngleSin(LA) * LS;

  FPos.x := FPos.x + FDir.x;
  FPos.y := FPos.y + FDir.y;
end;

function  AGT_Entity.ThrustToPos(const aThrustSpeed, ARotSpeed, ADestX, ADestY, ASlowdownDist, AStopDist, AStopSpeed, AStopSpeedEpsilon: Single): Boolean;
var
  LDist : Single;
  LStep : Single;
  LSpeed: Single;
  LDestPos: AGT_Vector;
  LStopDist: Single;
begin
  Result := False;

  if aSlowdownDist <= 0 then Exit;
  LStopDist := AStopDist;
  if LStopDist < 0 then LStopDist := 0;

  LDestPos.X := aDestX;
  LDestPos.Y := aDestY;
  //LDist := FPos.Distance(LDestPos);
  LDist := AGT_Math.VectorDistance(FPos, LDestPos);

  LDist := LDist - LStopDist;

  if LDist > aSlowdownDist then
    begin
      LSpeed := aThrustSpeed;
    end
  else
    begin
      LStep := (LDist/aSlowdownDist);
      LSpeed := (aThrustSpeed * LStep);
      if LSpeed <= aStopSpeed then
      begin
        LSpeed := 0;
        Result := True;
      end;
    end;

  if RotateToPos(aDestX, aDestY, aRotSpeed) then
  begin
    Thrust(LSpeed);
  end;
end;

function  AGT_Entity.IsVisible(const AWindow: AGT_Window): Boolean;
var
  LHW,LHH: Single;
  LVPW,LVPH: Integer;
  LX,LY: Single;
begin
  Result := False;

  LHW := FWidth / 2;
  LHH := FHeight / 2;

  //AWindow.GetViewport(@LVPX, @LVPY, @LVPW, @LVPH);
  LVPW := Round(AWindow.GetVirtualSize().w);
  LVPH := Round(AWindow.GetVirtualSize().h);

  Dec(LVPW); Dec(LVPH);

  LX := FPos.X;
  LY := FPos.Y;

  if LX > (LVPW + LHW) then Exit;
  if LX < -LHW    then Exit;
  if LY > (LVPH + LHH) then Exit;
  if LY < -LHH    then Exit;

  Result := True;
end;

function  AGT_Entity.IsFullyVisible(const AWindow: AGT_Window): Boolean;
var
  LHW,LHH: Single;
  LVPW,LVPH: Integer;
  LX,LY: Single;
begin
  Result := False;

  LHW := FWidth / 2;
  LHH := FHeight / 2;

  //AWindow.GetViewport(@LVPX, @LVPY, @LVPW, @LVPH);
  LVPW := Round(AWindow.GetVirtualSize().w);
  LVPH := Round(AWindow.GetVirtualSize().h);

  Dec(LVPW); Dec(LVPH);

  LX := FPos.X;
  LY := FPos.Y;

  if LX > (LVPW - LHW) then Exit;
  if LX <  LHW       then Exit;
  if LY > (LVPH - LHH) then Exit;
  if LY <  LHH       then Exit;

  Result := True;
end;

function  AGT_Entity.Collide(const X, Y, aRadius, aShrinkFactor: Single): Boolean;
var
  LDist: Single;
  LR1,LR2: Single;
  LV0,LV1: AGT_Vector;
begin
  LR1  := FRadius * aShrinkFactor;
  LR2  := aRadius * aShrinkFactor;

  LV0.X := FPos.X;
  LV0.Y := FPos.Y;

  LV1.x := X;
  LV1.y := Y;

  //LDist := LV0.Distance(LV1);
  LDist := AGT_Math.VectorDistance(LV0, LV1);

  if (LDist < LR1) or (LDist < LR2) then
    Result := True
  else
   Result := False;
end;

function  AGT_Entity.Collide(const AEntity: AGT_Entity; const AOverlap: AGT_EntityOverlap): Boolean;
var
  LTextureA, LTextureB: AGT_Texture;
begin
  Result := False;

  LTextureA := FSprite.GetImageTexture(FFrame, FGroup);
  LTextureB := AEntity.GetSprite().GetImageTexture(AEntity.GetFrame(), AEntity.GetGroup());

  LTextureA.SetPivot(FPivot);
  LTextureA.SetAnchor(FAnchor);
  LTextureA.SetPos(FPos.x, FPos.y);
  LTextureA.SetScale(FScale);
  LTextureA.SetAngle(FAngle);
  LTextureA.SetHFlip(FHFlip);
  LTextureA.SetVFlip(FVFlip);
  LTextureA.SetRegion(FSprite.GetImageRegion(FFrame, FGroup));

  LTextureB.SetPivot(AEntity.GetPivot());
  LTextureB.SetAnchor(AEntity.GetAnchor());
  LTextureB.SetPos(AEntity.GetPos().x, AEntity.GetPos().y);
  LTextureB.SetScale(AEntity.GetScale());
  LTextureB.SetAngle(AEntity.GetAngle());
  LTextureB.SetHFlip(AEntity.GetHFlip());
  LTextureB.SetVFlip(AEntity.GetVFlip());
  LTextureB.SetRegion(AEntity.GetSprite().GetImageRegion(FFrame, FGroup));

  case AOverlap of
    AGT_eoAABB: Result := LTextureA.CollideAABB(LTextureB);
    AGT_eoOBB : Result := LTextureA.CollideOBB(LTextureB);
  end;

end;

procedure AGT_Entity.Render(const AWindow: AGT_Window);
var
  LTexture: AGT_Texture;
begin
  LTexture := FSprite.GetImageTexture(FFrame, FGroup);
  LTexture.SetPivot(FPivot);
  LTexture.SetAnchor(FAnchor);
  LTexture.SetPos(FPos.x, FPos.y);
  LTexture.SetScale(FScale);
  LTexture.SetAngle(FAngle);
  LTexture.SetHFlip(FHFlip);
  LTexture.SetVFlip(FVFlip);
  LTexture.SetRegion(FSprite.GetImageRegion(FFrame, FGroup));
  LTexture.SetBlend(FBlend);
  LTexture.SetColor(FColor);
  LTexture.Draw(AWindow);
end;

procedure AGT_Entity.RenderAt(const AWindow: AGT_Window; const X, Y: Single);
var
  LTexture: AGT_Texture;
begin
  LTexture := FSprite.GetImageTexture(FFrame, FGroup);
  LTexture.SetPivot(FPivot);
  LTexture.SetAnchor(FAnchor);
  LTexture.SetPos(X, Y);
  LTexture.SetScale(FScale);
  LTexture.SetAngle(FAngle);
  LTexture.SetHFlip(FHFlip);
  LTexture.SetVFlip(FVFlip);
  LTexture.SetRegion(FSprite.GetImageRegion(FFrame, FGroup));
  LTexture.SetBlend(FBlend);
  LTexture.SetColor(FColor);
  LTexture.Draw(AWindow);
end;

function  AGT_Entity.GetSprite(): AGT_Sprite;
begin
  Result := FSprite;
end;

function  AGT_Entity.GetGroup(): Integer;
begin
  Result := FGroup;
end;

function  AGT_Entity.GetScale(): Single;
begin
  Result := FScale;
end;

function  AGT_Entity.GetColor(): AGT_Color;
begin
  Result := FColor;
end;

procedure AGT_Entity.SetColor(const AColor: AGT_Color);
begin
  FColor := AColor;
end;

function  AGT_Entity.GetBlend(): AGT_TextureBlend;
begin
  Result := FBlend;
end;

procedure AGT_Entity.SetBlend(const AValue: AGT_TextureBlend);
begin
  FBlend := AValue;
end;

function  AGT_Entity.GetHFlip(): Boolean;
begin
  Result := FHFlip;
end;

procedure AGT_Entity.SetHFlip(const AFlip: Boolean);
begin
  FHFlip := AFlip;
end;

function  AGT_Entity.GetVFlip(): Boolean;
begin
  Result := FVFlip;
end;

procedure AGT_Entity.SetVFlip(const AFlip: Boolean);
begin
  FVFlip := AFlip;
end;

function  AGT_Entity.GetLoopFrame(): Boolean;
begin
  Result := FLoopFrame;
end;

procedure AGT_Entity.SetLoopFrame(const aLoop: Boolean);
begin
  FLoopFrame := ALoop;
end;

function  AGT_Entity.GetWidth(): Single;
begin
  Result := FWidth;
end;

function  AGT_Entity.GetHeight(): Single;
begin
  Result := FHeight;
end;

function  AGT_Entity.GetRadius(): Single;
begin
  Result := FRadius;
end;

end.
