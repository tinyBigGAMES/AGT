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


unit Aurora.Camera;

{$I Aurora.Defines.inc}

interface

uses
  System.SysUtils,
  System.Math,
  Aurora.CLibs,
  Aurora.OpenGL,
  Aurora.Common,
  Aurora.Window;

type
  { AGT_Camera }
  AGT_Camera = class(TAGTBaseObject)
  private
    FX, FY: Single;
    FRotation: Single;
    FScale: Single;
    FWindow: AGT_Window;
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function  GetX(): Single;
    procedure SetX(const AValue: Single);
    function  GetY(): Single;
    procedure SetY(const AValue: Single);
    function  GetRotation(): Single;
    procedure SetRotation(const AValue: Single);
    function  GetScale(): Single;
    procedure SetScale(const AValue: Single);
    procedure Move(const X, Y: Single);
    procedure Zoom(const AScale: Single);
    procedure Rotate(const ARotation: Single);
    procedure Use(const AWindow: AGT_Window);
    procedure Reset();
  end;

implementation

{ AGT_Camera }
constructor AGT_Camera.Create();
begin
  inherited;
  FScale := 1;
end;

destructor AGT_Camera.Destroy();
begin
  Reset();
  inherited;
end;

function  AGT_Camera.GetX(): Single;
begin
  Result := FX;
end;

procedure AGT_Camera.SetX(const AValue: Single);
begin
  FX := AValue;
end;

function  AGT_Camera.GetY(): Single;
begin
  Result := FY;
end;

procedure AGT_Camera.SetY(const AValue: Single);
begin
  FY := AValue;
end;

function  AGT_Camera.GetRotation(): Single;
begin
  Result := FRotation;
end;

procedure AGT_Camera.SetRotation(const AValue: Single);
begin
  FRotation := EnsureRange(AValue, 0, 360);
end;

function  AGT_Camera.GetScale(): Single;
begin
  Result := FScale;
end;

procedure AGT_Camera.SetScale(const AValue: Single);
begin
  FScale := AValue;
end;

procedure AGT_Camera.Move(const X, Y: Single);
begin
  FX := FX + (X / FScale);
  FY := FY + (Y / FScale);
end;

procedure AGT_Camera.Zoom(const AScale: Single);
begin
  FScale := FScale + (AScale * FScale);
end;

procedure AGT_Camera.Rotate(const ARotation: Single);
begin
  FRotation := FRotation + ARotation;
end;

procedure AGT_Camera.Use(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then
  begin
    glPopMatrix();
    FWindow := nil;
    Exit;
  end;

  glPushMatrix();
  glTranslatef((AWindow.GetVirtualSize().w/2), (AWindow.GetVirtualSize().h/2), 0);
  glRotatef(FRotation, 0, 0, 1);
  glScalef(FScale, FScale, 1);
  glTranslatef(-FX, -FY, 0);
end;

procedure AGT_Camera.Reset();
begin
  if Assigned(FWindow) then
  begin
    glPopMatrix();
  end;
  FX := 0;
  FY := 0;
  FRotation := 0;
  FScale := 1;
end;

end.
