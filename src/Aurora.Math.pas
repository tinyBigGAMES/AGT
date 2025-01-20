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

unit Aurora.Math;

{$I Aurora.Defines.inc}

interface

uses
  System.SysUtils,
  System.Math,
  Aurora.CLibs,
  Aurora.OpenGL,
  Aurora.Common;

const
  AGT_RADTODEG = 180.0 / PI;
  AGT_DEGTORAD = PI / 180.0;
  AGT_EPSILON  = 0.00001;
  AGT_NAN      =  0.0 / 0.0;
  AGT_KILOBYTE = 1024;                     // 1 KB = 1024 bytes
  AGT_MEGABYTE = 1024 * 1024;              // 1 MB = 1024 * 1024 bytes
  AGT_GIGABYTE = 1024 * 1024 * 1024;       // 1 GB = 1024 * 1024 * 1024 bytes

type
  { AGT_Vector }
  PAGT_Vector = ^AGT_Vector;
  AGT_Vector = record
    x,y,z,w: Single;
  end;

  { AGT_Point }
  PAGT_Point = ^AGT_Point;
  AGT_Point = record
    x,y: Single;
  end;

  { AGT_Size }
  PAGT_Size = ^AGT_Size;
  AGT_Size = record
    w,h: Single;
  end;

  { AGT_Rect }
  PAGT_Rect = ^AGT_Rect;
  AGT_Rect = record
    pos: AGT_Point;
    size: AGT_Size;
  end;

  { AGT_Extent }
  PAGT_Extent = ^AGT_Extent;
  AGT_Extent = record
    min: AGT_Point;
    max: AGT_Point;
  end;

  { AGT_OBB }
  PAGT_OBB = ^AGT_OBB;
  AGT_OBB = record
    Center: AGT_Point;
    Extents: AGT_Point;
    Rotation: Single;
  end;


  { AGT_LineIntersection }
  AGT_LineIntersection = (AGT_liNone, AGT_liTrue, AGT_liParallel);

  { AGT_EaseType }
  AGT_EaseType = (AGT_etLinearTween, AGT_etInQuad, AGT_etOutQuad, AGT_etInOutQuad, AGT_etInCubic,
    AGT_etOutCubic, AGT_etInOutCubic, AGT_etInQuart, AGT_etOutQuart, AGT_etInOutQuart, AGT_etInQuint,
    AGT_etOutQuint, AGT_etInOutQuint, AGT_etInSine, AGT_etOutSine, AGT_etInOutSine, AGT_etInExpo,
    AGT_etOutExpo, AGT_etInOutExpo, AGT_etInCircle, AGT_etOutCircle, AGT_etInOutCircle);


  { AGT_Math }
  AGT_Math = class
  private class var
    FCosTable: array [0..360] of Single;
    FSinTable: array [0..360] of Single;
  private
    class constructor Create();
    class destructor Destroy();

  public
    class procedure UnitInit(); static;
    class function Point(const X, Y: Single): AGT_Point; static;
    class function Vector(const X, Y: Single): AGT_Vector; static;
    class function Size(const W, H: Single): AGT_Size; static;
    class function Rect(const X, Y, W, H: Single): AGT_Rect; static;
    class function Extent(const AMinX, AMinY, AMaxX, AMaxY: Single): AGT_Extent; static;

    class procedure AssignVector(var A: AGT_Vector; const B: AGT_Vector); overload; static;
    class procedure ClearVector(var A: AGT_Vector); static;
    class procedure AddVector(var A: AGT_Vector; const B: AGT_Vector); static;
    class procedure SubVector(var A: AGT_Vector; const B: AGT_Vector); static;
    class procedure MulVector(var A: AGT_Vector; const B: AGT_Vector); static;
    class procedure DivideVector(var A: AGT_Vector; const B: AGT_Vector); overload; static;
    class procedure DivideVictor(var A: AGT_Vector; const AValue: Single); overload; static;
    class function  VectorMagnitude(const A: AGT_Vector): Single; static;
    class function  VectorMagnitudeTruncate(const A: AGT_Vector; const AMaxMagnitude: Single): AGT_Vector; static;
    class function  VectorDistance(const A, B: AGT_Vector): Single; static;
    class procedure NormalizeVector(var A: AGT_Vector); static;
    class function  VectorAngle(const A, B: AGT_Vector): Single; static;
    class procedure ThrustVector(var A: AGT_Vector; const AAngle, ASpeed: Single); static;
    class function  VectorMagnitudeSquared(const A: AGT_Vector): Single; static;
    class function  VectorDotProduct(const A, B: AGT_Vector): Single; static;
    class procedure ScaleVectory(var A: AGT_Vector; const AValue: Single); static;
    class function  ProjectVector(const A, B: AGT_Vector): AGT_Vector; static;
    class procedure NegateVector(var A: AGT_Vector); static;

    class function  UnitToScalarValue(const AValue, AMaxValue: Double): Double; static;

    class function AngleCos(const AAngle: Cardinal): Single; static;
    class function AngleSin(const AAngle: Cardinal): Single; static;

    class function  RandomRange(const AMin, AMax: Integer): Integer; static;
    class function  RandomRangef(const AMin, AMax: Single): Single; static;
    class function  RandomBool(): Boolean; static;
    class function  GetRandomSeed(): Integer; static;
    class procedure SetRandomSeed(const AVaLue: Integer); static;
    class function  ClipVaLuef(var AVaLue: Single; const AMin, AMax: Single; const AWrap: Boolean): Single; static;
    class function  ClipVaLue(var AVaLue: Integer; const aMin, AMax: Integer; const AWrap: Boolean): Integer; static;
    class function  SameSign(const AVaLue1, AVaLue2: Integer): Boolean; static;
    class function  SameSignf(const AVaLue1, AVaLue2: Single): Boolean; static;
    class function  SameVaLue(const AA, AB: Double; const AEpsilon: Double = 0): Boolean; static;
    class function  SameVaLuef(const AA, AB: Single; const AEpsilon: Single = 0): Boolean; static;
    class function  AngleDiff(const ASrcAngle, ADestAngle: Single): Single; static;
    class procedure AngleRotatePos(const AAngle: Single; var AX, AY: Single); static;
    class procedure SmoothMove(var AVaLue: Single; const AAmount, AMax, ADrag: Single); static;
    class function  Lerp(const AFrom, ATo, ATime: Double): Double; static;
    class function  PointInRectangle(APoint: AGT_Vector; ARect: AGT_Rect): Boolean; static;
    class function  PointInCircle(APoint, ACenter: AGT_Vector; ARadius: Single): Boolean; static;
    class function  PointInTriangle(APoint, AP1, AP2, AP3: AGT_Vector): Boolean; static;
    class function  CirclesOverlap(ACenter1: AGT_Vector; ARadius1: Single; ACenter2: AGT_Vector; ARadius2: Single): Boolean; static;
    class function  CircleInRectangle(ACenter: AGT_Vector; ARadius: Single; ARect: AGT_Rect): Boolean; static;
    class function  RectanglesOverlap(ARect1: AGT_Rect; ARect2: AGT_Rect): Boolean; static;
    class function  RectangleIntersection(ARect1, ARect2: AGT_Rect): AGT_Rect; static;
    class function  LineIntersection(AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Integer; var AX: Integer; var AY: Integer): AGT_LineIntersection; static;
    class function  RadiusOverlap(ARadius1, AX1, AY1, ARadius2, AX2, AY2, AShrinkFactor: Single): Boolean; static;
    class function  EaseValue(ACurrentTime: Double; AStartValue: Double; AChangeInValue: Double; ADuration: Double; AEaseType: AGT_EaseType): Double; static;
    class function  EasePosition(AStartPos: Double; AEndPos: Double; ACurrentPos: Double; AEaseType: AGT_EaseType): Double; static;
    class function  OBBIntersect(const AObbA, AObbB: AGT_OBB): Boolean; static;
  end;

//=== EXPORTS ===============================================================
function  AGT_Point_Create(const X, Y: Single): AGT_Point; cdecl; exports AGT_Point_Create;
function  AGT_Vector_Create(const X, Y: Single): AGT_Vector; cdecl; exports AGT_Vector_Create;
function  AGT_Size_Create(const W, H: Single): AGT_Size; cdecl; exports AGT_Size_Create;
function  AGT_Rect_Create(const X, Y, W, H: Single): AGT_Rect; cdecl; exports AGT_Rect_Create;
function  AGT_Extent_Create(const AMinX, AMinY, AMaxX, AMaxY: Single): AGT_Extent; cdecl; exports AGT_Extent_Create;

procedure AGT_Vector_Assign(var A: AGT_Vector; const B: AGT_Vector); cdecl; exports AGT_Vector_Assign;
procedure AGT_Vector_Clear(var A: AGT_Vector); cdecl; exports AGT_Vector_Clear;
procedure AGT_Vector_Add(var A: AGT_Vector; const B: AGT_Vector); cdecl; exports AGT_Vector_Add;
procedure AGT_Vector_Subtract(var A: AGT_Vector; const B: AGT_Vector); cdecl; exports AGT_Vector_Subtract;
procedure AGT_Vector_Multiply(var A: AGT_Vector; const B: AGT_Vector); cdecl; exports AGT_Vector_Multiply;
procedure AGT_Vector_Divide(var A: AGT_Vector; const B: AGT_Vector); cdecl; exports AGT_Vector_Divide;
procedure AGT_Vector_DivideByValue(var A: AGT_Vector; const AValue: Single); cdecl; exports AGT_Vector_DivideByValue;
function  AGT_Vector_Magnitude(const A: AGT_Vector): Single; cdecl; exports AGT_Vector_Magnitude;
function  AGT_Vector_MagnitudeTruncate(const A: AGT_Vector; const AMaxMagnitude: Single): AGT_Vector; cdecl; exports AGT_Vector_MagnitudeTruncate;
function  AGT_Vector_Distance(const A, B: AGT_Vector): Single; cdecl; exports AGT_Vector_Distance;
procedure AGT_Vector_Normalize(var A: AGT_Vector); cdecl; exports AGT_Vector_Normalize;
function  AGT_Vector_Angle(const A, B: AGT_Vector): Single; cdecl; exports AGT_Vector_Angle;
procedure AGT_Vector_Thrust(var A: AGT_Vector; const AAngle, ASpeed: Single); cdecl; exports AGT_Vector_Thrust;
function  AGT_Vector_MagnitudeSquared(const A: AGT_Vector): Single; cdecl; exports AGT_Vector_MagnitudeSquared;
function  AGT_Vector_DotProduct(const A, B: AGT_Vector): Single; cdecl; exports AGT_Vector_DotProduct;
procedure AGT_Vector_ScaleByValue(var A: AGT_Vector; const AValue: Single); cdecl; exports AGT_Vector_ScaleByValue;
function  AGT_Vector_Project(const A, B: AGT_Vector): AGT_Vector; cdecl; exports AGT_Vector_Project;
procedure AGT_Vector_Negate(var A: AGT_Vector); cdecl; exports AGT_Vector_Negate;

function  AGT_UnitToScalarValue(const AValue, AMaxValue: Double): Double; cdecl; exports AGT_UnitToScalarValue;

function  AGT_AngleCos(const AAngle: Cardinal): Single; cdecl; exports AGT_AngleCos;
function  AGT_AngleSin(const AAngle: Cardinal): Single; cdecl; exports AGT_AngleSin;

function  AGT_RandomRange(const AMin, AMax: Integer): Integer; cdecl; exports AGT_RandomRange;
function  AGT_RandomRangef(const AMin, AMax: Single): Single; cdecl; exports AGT_RandomRangef;
function  AGT_RandomBool(): Boolean; cdecl; exports AGT_RandomBool;
function  AGT_GetRandomSeed(): Integer; cdecl; exports AGT_GetRandomSeed;
procedure AGT_SetRandomSeed(const AVaLue: Integer); cdecl; exports AGT_SetRandomSeed;

function  AGT_ClipVaLuef(var AVaLue: Single; const AMin, AMax: Single; const AWrap: Boolean): Single; cdecl; exports AGT_ClipVaLuef;
function  AGT_ClipVaLue(var AVaLue: Integer; const aMin, AMax: Integer; const AWrap: Boolean): Integer; cdecl; exports AGT_ClipVaLue;

function  AGT_SameSign(const AVaLue1, AVaLue2: Integer): Boolean; cdecl; exports AGT_SameSign;
function  AGT_SameSignf(const AVaLue1, AVaLue2: Single): Boolean; cdecl; exports AGT_SameSignf;
function  AGT_SameVaLue(const A, B: Double; const AEpsilon: Double = 0): Boolean; cdecl; exports AGT_SameVaLue;
function  AGT_SameVaLuef(const A, B: Single; const AEpsilon: Single = 0): Boolean; cdecl; exports AGT_SameVaLuef;

function  AGT_AngleDiff(const ASrcAngle, ADestAngle: Single): Single; cdecl; exports AGT_AngleDiff;
procedure AGT_AngleRotatePos(const AAngle: Single; var X, Y: Single); cdecl; exports AGT_AngleRotatePos;

procedure AGT_SmoothMove(var AVaLue: Single; const AAmount, AMax, ADrag: Single); cdecl; exports AGT_SmoothMove;

function  AGT_Lerp(const AFrom, ATo, ATime: Double): Double; cdecl; exports AGT_Lerp;

function  AGT_PointInRectangle(APoint: AGT_Vector; ARect: AGT_Rect): Boolean; cdecl; exports AGT_PointInRectangle;
function  AGT_PointInCircle(APoint, ACenter: AGT_Vector; ARadius: Single): Boolean; cdecl; exports AGT_PointInCircle;
function  AGT_PointInTriangle(APoint, P1, P2, P3: AGT_Vector): Boolean; cdecl; exports AGT_PointInTriangle;
function  AGT_CirclesOverlap(ACenter1: AGT_Vector; ARadius1: Single; ACenter2: AGT_Vector; ARadius2: Single): Boolean; cdecl; exports AGT_CirclesOverlap;
function  AGT_CircleInRectangle(ACenter: AGT_Vector; ARadius: Single; ARect: AGT_Rect): Boolean; cdecl; exports AGT_CircleInRectangle;
function  AGT_RectanglesOverlap(ARect1: AGT_Rect; ARect2: AGT_Rect): Boolean; cdecl; exports AGT_RectanglesOverlap;
function  AGT_RectangleIntersection(ARect1, ARect2: AGT_Rect): AGT_Rect; cdecl; exports AGT_RectangleIntersection;
function  AGT_LineIntersect(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer; var X: Integer; var Y: Integer): AGT_LineIntersection; cdecl; exports AGT_LineIntersect;
function  AGT_RadiusOverlap(ARadius1, X1, Y1, ARadius2, X2, Y2, AShrinkFactor: Single): Boolean; cdecl; exports AGT_RadiusOverlap;
function  AGT_EaseValue(ACurrentTime: Double; AStartValue: Double; AChangeInValue: Double; ADuration: Double; AEaseType: AGT_EaseType): Double; cdecl; exports AGT_EaseValue;
function  AGT_EasePosition(AStartPos: Double; AEndPos: Double; ACurrentPos: Double; AEaseType: AGT_EaseType): Double; cdecl; exports AGT_EasePosition;
function  AGT_OBBIntersect(const AObbA, AObbB: AGT_OBB): Boolean; cdecl; exports AGT_OBBIntersect;

implementation

//=== EXPORTS ===============================================================
function  AGT_Point_Create(const X, Y: Single): AGT_Point;
begin
  Result.x := X;
  Result.y := Y;
end;

function  AGT_Vector_Create(const X, Y: Single): AGT_Vector;
begin
  Result := Default(AGT_Vector);
  Result.x := X;
  Result.y := Y;
end;

function  AGT_Size_Create(const W, H: Single): AGT_Size;
begin
  Result.w := W;
  Result.h := H;
end;

function  AGT_Rect_Create(const X, Y, W, H: Single): AGT_Rect;
begin
  Result.pos.x := X;
  Result.pos.y := y;
  Result.size.w := W;
  Result.size.h := H;
end;

function  AGT_Extent_Create(const AMinX, AMinY, AMaxX, AMaxY: Single): AGT_Extent;
begin
  Result.min.x := AMinX;
  Result.min.y := AMinY;
  Result.max.x := AMaxX;
  Result.max.y := AMaxY;
end;


procedure AGT_Vector_Assign(var A: AGT_Vector; const B: AGT_Vector);
begin
  AGT_Math.AssignVector(A, B);
end;

procedure AGT_Vector_Clear(var A: AGT_Vector);
begin
  AGT_Math.ClearVector(A);
end;

procedure AGT_Vector_Add(var A: AGT_Vector; const B: AGT_Vector);
begin
  AGT_Math.AddVector(A, B);
end;

procedure AGT_Vector_Subtract(var A: AGT_Vector; const B: AGT_Vector);
begin
  AGT_Math.SubVector(A, B);
end;

procedure AGT_Vector_Multiply(var A: AGT_Vector; const B: AGT_Vector);
begin
  AGT_Math.MulVector(A, B);
end;

procedure AGT_Vector_Divide(var A: AGT_Vector; const B: AGT_Vector);
begin
  AGT_Math.DivideVector(A, B);
end;

procedure AGT_Vector_DivideByValue(var A: AGT_Vector; const AValue: Single);
begin
  AGT_Math.DivideVictor(A, AValue);
end;

function  AGT_Vector_Magnitude(const A: AGT_Vector): Single;
begin
  Result := AGT_Math.VectorMagnitude(A);
end;

function  AGT_Vector_MagnitudeTruncate(const A: AGT_Vector; const AMaxMagnitude: Single): AGT_Vector;
begin
  Result := AGT_Math.VectorMagnitudeTruncate(A, AMaxMagnitude);
end;

function  AGT_Vector_Distance(const A, B: AGT_Vector): Single;
begin
  Result := AGT_Math.VectorDistance(A, B);
end;

procedure AGT_Vector_Normalize(var A: AGT_Vector);
begin
  AGT_Math.NormalizeVector(A)
end;

function  AGT_Vector_Angle(const A, B: AGT_Vector): Single;
begin
  Result := AGT_Math.VectorAngle(A, B);
end;

procedure AGT_Vector_Thrust(var A: AGT_Vector; const AAngle, ASpeed: Single);
begin
  AGT_Math.ThrustVector(A, AAngle, ASpeed);
end;

function  AGT_Vector_MagnitudeSquared(const A: AGT_Vector): Single;
begin
  Result := AGT_Math.VectorMagnitude(A);
end;

function  AGT_Vector_DotProduct(const A, B: AGT_Vector): Single;
begin
  Result := AGT_Math.VectorDotProduct(A, B);
end;

procedure AGT_Vector_ScaleByValue(var A: AGT_Vector; const AValue: Single);
begin
  AGT_Math.ScaleVectory(A, AValue);
end;

function  AGT_Vector_Project(const A, B: AGT_Vector): AGT_Vector;
begin
  Result := AGT_Math.ProjectVector(A, B);
end;

procedure AGT_Vector_Negate(var A: AGT_Vector);
begin
  AGT_Math.NegateVector(A);
end;


function  AGT_UnitToScalarValue(const AValue, AMaxValue: Double): Double;
begin
  Result := AGT_Math.UnitToScalarValue(AValue, AMaxValue);
end;


function  AGT_AngleCos(const AAngle: Cardinal): Single;
begin
  Result := AGT_Math.AngleCos(AAngle);
end;

function  AGT_AngleSin(const AAngle: Cardinal): Single;
begin
  Result := AGT_Math.AngleSin(AAngle);
end;


function  AGT_RandomRange(const AMin, AMax: Integer): Integer;
begin
  Result := AGT_Math.RandomRange(AMin, AMax);
end;

function  AGT_RandomRangef(const AMin, AMax: Single): Single;
begin
  Result := AGT_Math.RandomRangef(AMin, AMax)
end;

function  AGT_RandomBool(): Boolean;
begin
  Result := AGT_Math.RandomBool();
end;

function  AGT_GetRandomSeed(): Integer;
begin
  Result := AGT_Math.GetRandomSeed();
end;

procedure AGT_SetRandomSeed(const AVaLue: Integer);
begin
  AGT_Math.SetRandomSeed(AValue);
end;


function  AGT_ClipVaLuef(var AVaLue: Single; const AMin, AMax: Single; const AWrap: Boolean): Single;
begin
  Result := AGT_Math.ClipVaLuef(AValue, AMin, AMax, AWrap);
end;

function  AGT_ClipVaLue(var AVaLue: Integer; const aMin, AMax: Integer; const AWrap: Boolean): Integer;
begin
  Result := AGT_Math.ClipVaLue(AValue, AMin, AMax, AWrap);
end;


function  AGT_SameSign(const AVaLue1, AVaLue2: Integer): Boolean;
begin
  Result := AGT_Math.SameSign(AValue1, AValue2);
end;

function  AGT_SameSignf(const AVaLue1, AVaLue2: Single): Boolean;
begin
  Result := AGT_Math.SameSignf(AValue1, AValue2);
end;

function  AGT_SameVaLue(const A, B: Double; const AEpsilon: Double = 0): Boolean;
begin
  Result := AGT_Math.SameVaLue(A, B, AEpsilon);
end;

function  AGT_SameVaLuef(const A, B: Single; const AEpsilon: Single = 0): Boolean;
begin
  Result := AGT_Math.SameVaLuef(A, B, AEpsilon);
end;


function  AGT_AngleDiff(const ASrcAngle, ADestAngle: Single): Single;
begin
  Result := AGT_Math.AngleDiff(ASrcAngle, ADestAngle);
end;

procedure AGT_AngleRotatePos(const AAngle: Single; var X, Y: Single);
begin
  AGT_Math.AngleRotatePos(AAngle, X, Y);
end;


procedure AGT_SmoothMove(var AVaLue: Single; const AAmount, AMax, ADrag: Single);
begin
  AGT_Math.SmoothMove(AValue, AAmount, AMax, ADrag);
end;


function  AGT_Lerp(const AFrom, ATo, ATime: Double): Double;
begin
  Result := AGT_Math.Lerp(AFrom, ATo, ATime);
end;


function  AGT_PointInRectangle(APoint: AGT_Vector; ARect: AGT_Rect): Boolean;
begin
  Result := AGT_Math.PointInRectangle(APoint, ARect);
end;

function  AGT_PointInCircle(APoint, ACenter: AGT_Vector; ARadius: Single): Boolean;
begin
  Result := AGT_Math.PointInCircle(APoint, ACenter, ARadius);
end;

function  AGT_PointInTriangle(APoint, P1, P2, P3: AGT_Vector): Boolean;
begin
  Result := AGT_Math.PointInTriangle(APoint, P1, P2, P3);
end;

function  AGT_CirclesOverlap(ACenter1: AGT_Vector; ARadius1: Single; ACenter2: AGT_Vector; ARadius2: Single): Boolean;
begin
  Result := AGT_Math.CirclesOverlap(ACenter1, ARadius1, ACenter2, ARadius2);
end;

function  AGT_CircleInRectangle(ACenter: AGT_Vector; ARadius: Single; ARect: AGT_Rect): Boolean;
begin
  Result := AGT_Math.CircleInRectangle(ACenter, ARadius, ARect);
end;

function  AGT_RectanglesOverlap(ARect1: AGT_Rect; ARect2: AGT_Rect): Boolean;
begin
  Result := AGT_Math.RectanglesOverlap(ARect1, ARect2);
end;

function  AGT_RectangleIntersection(ARect1, ARect2: AGT_Rect): AGT_Rect;
begin
  Result := AGT_Math.RectangleIntersection(ARect1, ARect2);
end;

function  AGT_LineIntersect(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer; var X: Integer; var Y: Integer): AGT_LineIntersection;
begin
  Result := AGT_Math.LineIntersection(X1, Y1, X2, Y2, X3, Y3, X4, Y4, X, Y);
end;

function  AGT_RadiusOverlap(ARadius1, X1, Y1, ARadius2, X2, Y2, AShrinkFactor: Single): Boolean;
begin
  Result := AGT_Math.RadiusOverlap(ARadius1, X1, Y1, ARadius2, X2, Y2, AShrinkFactor);
end;

function  AGT_EaseValue(ACurrentTime: Double; AStartValue: Double; AChangeInValue: Double; ADuration: Double; AEaseType: AGT_EaseType): Double;
begin
  Result := AGT_Math.EaseValue(ACurrentTime, AStartValue, AChangeInValue, ADuration, AEaseType);
end;

function  AGT_EasePosition(AStartPos: Double; AEndPos: Double; ACurrentPos: Double; AEaseType: AGT_EaseType): Double;
begin
  Result := AGT_Math.EasePosition(AStartPos, AEndPos, ACurrentPos, AEaseType);
end;

function  AGT_OBBIntersect(const AObbA, AObbB: AGT_OBB): Boolean;
begin
  Result := AGT_Math.OBBIntersect(AObbA, AObbB);
end;


{ AGT_Math }
class constructor AGT_Math.Create();
var
  I: Integer;
begin
  // init sin/cos tables
  for I := 0 to 360 do
  begin
    FCosTable[I] := cos((I * PI / 180.0));
    FSinTable[I] := sin((I * PI / 180.0));
  end;
end;

class destructor AGT_Math.Destroy();
begin
end;

class procedure AGT_Math.UnitInit();
begin
end;

class function AGT_Math.Point(const X, Y: Single): AGT_Point;
begin
  Result.x := X;
  Result.y := Y;
end;

class function AGT_Math.Vector(const X, Y: Single): AGT_Vector;
begin
  Result.x := X;
  Result.y := Y;
  Result.z := 0;
  Result.w := 0;
end;

class function AGT_Math.Size(const W, H: Single): AGT_Size;
begin
  Result.w := W;
  Result.h := H;
end;

class function AGT_Math.Rect(const X, Y, W, H: Single): AGT_Rect;
begin
  Result.pos.x := X;
  Result.pos.y := Y;
  Result.size.w := W;
  Result.size.h := H;
end;

class function AGT_Math.Extent(const AMinX, AMinY, AMaxX, AMaxY: Single): AGT_Extent;
begin
  Result.min.x := AMinX;
  Result.min.y := AMinY;

  Result.max.x := AMaxX;
  Result.max.y := AMaxY;
end;

class procedure AGT_Math.AssignVector(var A: AGT_Vector; const B: AGT_Vector);
begin
  A := B;
end;

class procedure AGT_Math.ClearVector(var A: AGT_Vector);
begin
  A := Default(AGT_Vector);
end;

class procedure AGT_Math.AddVector(var A: AGT_Vector; const B: AGT_Vector);
begin
  A.x := A.x + B.x;
  A.y := A.y + B.y;
end;

class procedure AGT_Math.SubVector(var A: AGT_Vector; const B: AGT_Vector);
begin
  A.x := A.x - B.x;
  A.y := A.y - B.y;
end;

class procedure AGT_Math.MulVector(var A: AGT_Vector; const B: AGT_Vector);
begin
  A.x := A.x * B.x;
  A.y := A.y * B.y;
end;

class procedure AGT_Math.DivideVector(var A: AGT_Vector; const B: AGT_Vector);
begin
  A.x := A.x / B.x;
  A.y := A.y / B.y;
end;

class procedure AGT_Math.DivideVictor(var A: AGT_Vector; const AValue: Single);
begin
begin
  A.x := A.x / AValue;
  A.y := A.y / AValue;
end;
end;

class function  AGT_Math.VectorMagnitude(const A: AGT_Vector): Single;
begin
  Result := Sqrt((A.x * A.x) + (A.y * A.y));
end;

class function  AGT_Math.VectorMagnitudeTruncate(const A: AGT_Vector; const AMaxMagnitude: Single): AGT_Vector;
var
  LMaxMagSqrd: Single;
  LVecMagSqrd: Single;
  LTruc: Single;
begin
  Result := Default(AGT_Vector);
  Result.x := A.x;
  Result.y := A.y;

  LMaxMagSqrd := AMaxMagnitude * AMaxMagnitude;
  LVecMagSqrd := VectorMagnitude(Result);
  if LVecMagSqrd > LMaxMagSqrd then
  begin
    LTruc := (AMaxMagnitude / Sqrt(LVecMagSqrd));
    Result.x := Result.x * LTruc;
    Result.y := Result.y * LTruc;
  end;
end;

class function  AGT_Math.VectorDistance(const A, B: AGT_Vector): Single;
var
  LDirVec: AGT_Vector;
begin
  LDirVec.x := A.x - B.x;
  LDirVec.y := A.y - B.y;
  Result := VectorMagnitude(LDirVec);
end;

class procedure AGT_Math.NormalizeVector(var A: AGT_Vector);
var
  LLen, LOOL: Single;
begin
  LLen := VectorMagnitude(A);
  if LLen <> 0 then
  begin
    LOOL := 1.0 / LLen;
    A.x := A.x * LOOL;
    A.y := A.y * LOOL;
  end;
end;

class function  AGT_Math.VectorAngle(const A, B: AGT_Vector): Single;
var
  LXOY: Single;
  LR: AGT_Vector;
begin
  AssignVector(LR, A);
  SubVector(LR, B);
  NormalizeVector(LR);

  if LR.y = 0 then
  begin
    LR.y := 0.001;
  end;

  LXOY := LR.x / LR.y;

  Result := ArcTan(LXOY) * AGT_RADTODEG;
  if LR.y < 0 then
    Result := Result + 180.0;
end;


class procedure AGT_Math.ThrustVector(var A: AGT_Vector; const AAngle, ASpeed: Single);
var
  LA: Single;
begin
  LA := AAngle + 90.0;
  ClipValuef(LA, 0, 360, True);

  A.x := A.x + AngleCos(Round(LA)) * -(aSpeed);
  A.y := A.y + AngleSin(Round(LA)) * -(aSpeed);
end;

class function  AGT_Math.VectorMagnitudeSquared(const A: AGT_Vector): Single;
begin
  Result := (A.x * A.x) + (A.y * A.y);
end;

class function  AGT_Math.VectorDotProduct(const A, B: AGT_Vector): Single;
begin
  Result := (A.x * B.x) + (A.y * B.y);
end;

class procedure AGT_Math.ScaleVectory(var A: AGT_Vector; const AValue: Single);
begin
  A.x := A.x * AValue;
  A.y := A.y * AValue;
end;

class function  AGT_Math.ProjectVector(const A, B: AGT_Vector): AGT_Vector;
var
  LDP: Single;
begin
  LDP :=  VectorDotProduct(A, B);
  Result.x := (LDP / (B.x * B.x + B.y * B.y)) * B.x;
  Result.y := (LDP / (B.x * B.x + B.y * B.y)) * B.y;
end;

class procedure AGT_Math.NegateVector(var A: AGT_Vector);
begin
  A.x := -A.x;
  A.y := -A.y;
end;

class function  AGT_Math.UnitToScalarValue(const AValue, AMaxValue: Double): Double;
var
  LGain: Double;
  LFactor: Double;
  LVolume: Double;
begin
  LGain := (EnsureRange(AValue, 0.0, 1.0) * 50) - 50;
  LFactor := Power(10, LGain * 0.05);
  LVolume := EnsureRange(AMaxValue * LFactor, 0, AMaxValue);
  Result := LVolume;
end;

class function AGT_Math.AngleCos(const AAngle: Cardinal): Single;
var
  LAngle: Cardinal;
begin
  LAngle := EnsureRange(AAngle, 0, 360);
  Result := FCosTable[LAngle];
end;

class function AGT_Math.AngleSin(const AAngle: Cardinal): Single;
var
  LAngle: Cardinal;
begin
  LAngle := EnsureRange(AAngle, 0, 360);
  Result := FSinTable[LAngle];
end;

function _RandomRange(const aFrom, aTo: Integer): Integer;
var
  LFrom: Integer;
  LTo: Integer;
begin
  LFrom := aFrom;
  LTo := aTo;

  if AFrom > ATo then
    Result := Random(LFrom - LTo) + ATo
  else
    Result := Random(LTo - LFrom) + AFrom;
end;

class function  AGT_Math.RandomRange(const AMin, AMax: Integer): Integer;
begin
  Result := _RandomRange(AMin, AMax + 1);
end;

class function  AGT_Math.RandomRangef(const AMin, AMax: Single): Single;
var
  LNum: Single;
begin
  LNum := _RandomRange(0, MaxInt) / MaxInt;
  Result := AMin + (LNum * (AMax - AMin));
end;

class function  AGT_Math.RandomBool(): Boolean;
begin
  Result := Boolean(_RandomRange(0, 2) = 1);
end;

class function  AGT_Math.GetRandomSeed(): Integer;
begin
  Result := System.RandSeed;
end;

class procedure AGT_Math.SetRandomSeed(const AVaLue: Integer);
begin
  System.RandSeed := AVaLue;
end;

class function  AGT_Math.ClipVaLuef(var AVaLue: Single; const AMin, AMax: Single; const AWrap: Boolean): Single;
begin
  if AWrap then
    begin
      if (AVaLue > AMax) then
      begin
        AVaLue := AMin + Abs(AVaLue - AMax);
        if AVaLue > AMax then
          AVaLue := AMax;
      end
      else if (AVaLue < AMin) then
      begin
        AVaLue := AMax - Abs(AVaLue - AMin);
        if AVaLue < AMin then
          AVaLue := AMin;
      end
    end
  else
    begin
      if AVaLue < AMin then
        AVaLue := AMin
      else if AVaLue > AMax then
        AVaLue := AMax;
    end;

  Result := AVaLue;
end;

class function  AGT_Math.ClipVaLue(var AVaLue: Integer; const aMin, AMax: Integer; const AWrap: Boolean): Integer;
begin
  if AWrap then
    begin
      if (AVaLue > AMax) then
      begin
        AVaLue := aMin + Abs(AVaLue - AMax);
        if AVaLue > AMax then
          AVaLue := AMax;
      end
      else if (AVaLue < aMin) then
      begin
        AVaLue := AMax - Abs(AVaLue - aMin);
        if AVaLue < aMin then
          AVaLue := aMin;
      end
    end
  else
    begin
      if AVaLue < aMin then
        AVaLue := aMin
      else if AVaLue > AMax then
        AVaLue := AMax;
    end;

  Result := AVaLue;
end;

class function  AGT_Math.SameSign(const AVaLue1, AVaLue2: Integer): Boolean;
begin
  if Sign(AVaLue1) = Sign(AVaLue2) then
    Result := True
  else
    Result := False;
end;

class function  AGT_Math.SameSignf(const AVaLue1, AVaLue2: Single): Boolean;
begin
  if System.Math.Sign(AVaLue1) = System.Math.Sign(AVaLue2) then
    Result := True
  else
    Result := False;
end;

class function  AGT_Math.SameValue(const AA, AB: Double; const AEpsilon: Double = 0): Boolean;
begin
  Result := System.Math.SameVaLue(AA, AB, AEpsilon);
end;

class function  AGT_Math.SameVaLuef(const AA, AB: Single; const AEpsilon: Single = 0): Boolean;
begin
  Result := System.Math.SameVaLue(AA, AB, AEpsilon);
end;

class function  AGT_Math.AngleDiff(const ASrcAngle, ADestAngle: Single): Single;
var
  LAngleDiff: Single;
begin
  LAngleDiff := ADestAngle-ASrcAngle-(Floor((ADestAngle-ASrcAngle)/360.0)*360.0);

  if LAngleDiff >= (360.0 / 2) then
  begin
    LAngleDiff := LAngleDiff - 360.0;
  end;
  Result := LAngleDiff;
end;

class procedure AGT_Math.AngleRotatePos(const AAngle: Single; var AX, AY: Single);
var
  LNX,LNY: Single;
  LIA: Integer;
  LAngle: Single;
begin
  LAngle := EnsureRange(AAngle, 0, 360);

  LIA := Round(LAngle);

  LNX := AX*FCosTable[LIA] - AY*FSinTable[LIA];
  LNY := AY*FCosTable[LIA] + AX*FSinTable[LIA];

  AX := LNX;
  AY := LNY;
end;

class procedure AGT_Math.SmoothMove(var AVaLue: Single; const AAmount, AMax, ADrag: Single);
var
  LAmt: Single;
begin
  LAmt := AAmount;

  if LAmt > 0 then
  begin
    AVaLue := AVaLue + LAmt;
    if AVaLue > AMax then
      AVaLue := AMax;
  end else if LAmt < 0 then
  begin
    AVaLue := AVaLue + LAmt;
    if AVaLue < -AMax then
      AVaLue := -AMax;
  end else
  begin
    if AVaLue > 0 then
    begin
      AVaLue := AVaLue - ADrag;
      if AVaLue < 0 then
        AVaLue := 0;
    end else if AVaLue < 0 then
    begin
      AVaLue := AVaLue + ADrag;
      if AVaLue > 0 then
        AVaLue := 0;
    end;
  end;
end;

class function  AGT_Math.Lerp(const AFrom, ATo, ATime: Double): Double;
begin
  if ATime <= 0.5 then
    Result := AFrom + (ATo - AFrom) * ATime
  else
    Result := ATo - (ATo - AFrom) * (1.0 - ATime);
end;

class function  AGT_Math.PointInRectangle(APoint: AGT_Vector; ARect: AGT_Rect): Boolean;
begin
  if ((APoint.x >= ARect.pos.x) and (APoint.x <= (ARect.pos.x + ARect.size.w)) and
    (APoint.y >= ARect.pos.y) and (APoint.y <= (ARect.pos.y + ARect.size.h))) then
    Result := True
  else
    Result := False;
end;

class function  AGT_Math.PointInCircle(APoint, ACenter: AGT_Vector; ARadius: Single): Boolean;
begin
  Result := CirclesOverlap(APoint, 0, ACenter, ARadius);
end;

class function  AGT_Math.PointInTriangle(APoint, AP1, AP2, AP3: AGT_Vector): Boolean;
var
  LAlpha, LBeta, LGamma: Single;
begin
  LAlpha := ((AP2.y - AP3.y) * (APoint.x - AP3.x) + (AP3.x - AP2.x) *
    (APoint.y - AP3.y)) / ((AP2.y - AP3.y) * (AP1.x - AP3.x) + (AP3.x - AP2.x) *
    (AP1.y - AP3.y));

  LBeta := ((AP3.y - AP1.y) * (APoint.x - AP3.x) + (AP1.x - AP3.x) *
    (APoint.y - AP3.y)) / ((AP2.y - AP3.y) * (AP1.x - AP3.x) + (AP3.x - AP2.x) *
    (AP1.y - AP3.y));

  LGamma := 1.0 - LAlpha - LBeta;

  if ((LAlpha > 0) and (LBeta > 0) and (LGamma > 0)) then
    Result := True
  else
    Result := False;
end;

class function  AGT_Math.CirclesOverlap(ACenter1: AGT_Vector; ARadius1: Single; ACenter2: AGT_Vector; ARadius2: Single): Boolean;
var
  LDX, LDY, LDistance: Single;
begin
  LDX := ACenter2.x - ACenter1.x; // X distance between centers
  LDY := ACenter2.y - ACenter1.y; // Y distance between centers

  LDistance := sqrt(LDX * LDX + LDY * LDY); // Distance between centers

  if (LDistance <= (ARadius1 + ARadius2)) then
    Result := True
  else
    Result := False;
end;

class function  AGT_Math.CircleInRectangle(ACenter: AGT_Vector; ARadius: Single; ARect: AGT_Rect): Boolean;
var
  LDX, LDY: Single;
  LCornerDistanceSq: Single;
  LRecCenterX: Integer;
  LRecCenterY: Integer;
begin
  LRecCenterX := Round(ARect.pos.x + ARect.size.w / 2);
  LRecCenterY := Round(ARect.pos.y + ARect.size.h / 2);

  LDX := abs(ACenter.x - LRecCenterX);
  LDY := abs(ACenter.y - LRecCenterY);

  if (LDX > (ARect.size.w / 2.0 + ARadius)) then
  begin
    Result := False;
    Exit;
  end;

  if (LDY > (ARect.size.h / 2.0 + ARadius)) then
  begin
    Result := False;
    Exit;
  end;

  if (LDX <= (ARect.size.w / 2.0)) then
  begin
    Result := True;
    Exit;
  end;
  if (LDY <= (ARect.size.h / 2.0)) then
  begin
    Result := True;
    Exit;
  end;

  LCornerDistanceSq := (LDX - ARect.size.w / 2.0) * (LDX - ARect.size.w / 2.0) +
    (LDY - ARect.size.h / 2.0) * (LDY - ARect.size.h / 2.0);

  Result := Boolean(LCornerDistanceSq <= (ARadius * ARadius));
end;

class function  AGT_Math.RectanglesOverlap(ARect1: AGT_Rect; ARect2: AGT_Rect): Boolean;
var
  LDX, LDY: Single;
begin
  LDX := abs((ARect1.pos.x + ARect1.size.w / 2) - (ARect2.pos.x + ARect2.size.w / 2));
  LDY := abs((ARect1.pos.y + ARect1.size.h / 2) - (ARect2.pos.y + ARect2.size.h / 2));

  if ((LDX <= (ARect1.size.w / 2 + ARect2.size.w / 2)) and
    ((LDY <= (ARect1.size.h / 2 + ARect2.size.h / 2)))) then
    Result := True
  else
    Result := False;
end;

class function  AGT_Math.RectangleIntersection(ARect1, ARect2: AGT_Rect): AGT_Rect;
var
  LDXX, LDYY: Single;
begin
  Result := Rect(0, 0, 0, 0);

  if RectanglesOverlap(ARect1, ARect2) then
  begin
    LDXX := abs(ARect1.pos.x - ARect2.pos.x);
    LDYY := abs(ARect1.pos.y - ARect2.pos.y);

    if (ARect1.pos.x <= ARect2.pos.x) then
    begin
      if (ARect1.pos.y <= ARect2.pos.y) then
      begin
        Result.pos.x := ARect2.pos.x;
        Result.pos.y := ARect2.pos.y;
        Result.size.w := ARect1.size.w - LDXX;
        Result.size.h := ARect1.size.h - LDYY;
      end
      else
      begin
        Result.pos.x := ARect2.pos.x;
        Result.pos.y := ARect1.pos.y;
        Result.size.w := ARect1.size.w - LDXX;
        Result.size.h := ARect2.size.h - LDYY;
      end
    end
    else
    begin
      if (ARect1.pos.y <= ARect2.pos.y) then
      begin
        Result.pos.x := ARect1.pos.x;
        Result.pos.y := ARect2.pos.y;
        Result.size.w := ARect2.size.w - LDXX;
        Result.size.h := ARect1.size.h - LDYY;
      end
      else
      begin
        Result.pos.x := ARect1.pos.x;
        Result.pos.y := ARect1.pos.y;
        Result.size.w := ARect2.size.w - LDXX;
        Result.size.h := ARect2.size.h - LDYY;
      end
    end;

    if (ARect1.size.w > ARect2.size.w) then
    begin
      if (Result.size.w >= ARect2.size.w) then
        Result.size.w := ARect2.size.w;
    end
    else
    begin
      if (Result.size.w >= ARect1.size.w) then
        Result.size.w := ARect1.size.w;
    end;

    if (ARect1.size.h > ARect2.size.h) then
    begin
      if (Result.size.h >= ARect2.size.h) then
        Result.size.h := ARect2.size.h;
    end
    else
    begin
      if (Result.size.h >= ARect1.size.h) then
        Result.size.h := ARect1.size.h;
    end
  end;
end;

class function  AGT_Math.LineIntersection(AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Integer; var AX: Integer; var AY: Integer): AGT_LineIntersection;
var
  LAX, LBX, LCX, LAY, LBY, LCY, LD, LE, LF, LNum: Integer;
  LOffset: Integer;
  LX1Lo, LX1Hi, LY1Lo, LY1Hi: Integer;
begin
  Result := AGT_liNone;

  LAX := AX2 - AX1;
  LBX := AX3 - AX4;

  if (LAX < 0) then // X bound box test
  begin
    LX1Lo := AX2;
    LX1Hi := AX1;
  end
  else
  begin
    LX1Hi := AX2;
    LX1Lo := AX1;
  end;

  if (LBX > 0) then
  begin
    if (LX1Hi < AX4) or (AX3 < LX1Lo) then
      Exit;
  end
  else
  begin
    if (LX1Hi < AX3) or (AX4 < LX1Lo) then
      Exit;
  end;

  LAY := AY2 - AY1;
  LBY := AY3 - AY4;

  if (LAY < 0) then // Y bound box test
  begin
    LY1Lo := AY2;
    LY1Hi := AY1;
  end
  else
  begin
    LY1Hi := AY2;
    LY1Lo := AY1;
  end;

  if (LBY > 0) then
  begin
    if (LY1Hi < AY4) or (AY3 < LY1Lo) then
      Exit;
  end
  else
  begin
    if (LY1Hi < AY3) or (AY4 < LY1Lo) then
      Exit;
  end;

  LCX := AX1 - AX3;
  LCY := AY1 - AY3;
  LD := LBY * LCX - LBX * LCY; // alpha numerator
  LF := LAY * LBX - LAX * LBY; // both denominator

  if (LF > 0) then // alpha tests
  begin
    if (LD < 0) or (LD > LF) then
      Exit;
  end
  else
  begin
    if (LD > 0) or (LD < LF) then
      Exit
  end;

  LE := LAX * LCY - LAY * LCX; // beta numerator
  if (LF > 0) then // beta tests
  begin
    if (LE < 0) or (LE > LF) then
      Exit;
  end
  else
  begin
    if (LE > 0) or (LE < LF) then
      Exit;
  end;

  // compute intersection coordinates
  if (LF = 0) then
  begin
    Result := AGT_liParallel;
    Exit;
  end;

  LNum := LD * LAX; // numerator
  // if SameSigni(num, f) then
  if Sign(LNum) = Sign(LF) then

    LOffset := LF div 2
  else
    LOffset := -LF div 2;
  AX := AX1 + (LNum + LOffset) div LF; // intersection x

  LNum := LD * LAY;
  // if SameSigni(num, f) then
  if Sign(LNum) = Sign(LF) then
    LOffset := LF div 2
  else
    LOffset := -LF div 2;

  AY := AY1 + (LNum + LOffset) div LF; // intersection y

  Result := AGT_liTrue;
end;

class function  AGT_Math.RadiusOverlap(ARadius1, AX1, AY1, ARadius2, AX2, AY2, AShrinkFactor: Single): Boolean;
var
  LDist: Single;
  LR1, LR2: Single;
  LV1, LV2: AGT_Vector;
begin
  LR1 := ARadius1 * AShrinkFactor;
  LR2 := ARadius2 * AShrinkFactor;

  LV1.x := AX1;
  LV1.y := AY1;
  LV2.x := AX2;
  LV2.y := AY2;

  //LDist := LV1.distance(LV2);
  LDist := VectorDistance(LV1, LV2);

  if (LDist < LR1) or (LDist < LR2) then
    Result := True
  else
    Result := False;
end;

class function  AGT_Math.EaseValue(ACurrentTime: Double; AStartValue: Double; AChangeInValue: Double; ADuration: Double; AEaseType: AGT_EaseType): Double;
begin
  Result := 0;
  case AEaseType of
    AGT_etLinearTween:
      begin
        Result := AChangeInValue * ACurrentTime / ADuration + AStartValue;
      end;

    AGT_etInQuad:
      begin
        ACurrentTime := ACurrentTime / ADuration;
        Result := AChangeInValue * ACurrentTime * ACurrentTime + AStartValue;
      end;

    AGT_etOutQuad:
      begin
        ACurrentTime := ACurrentTime / ADuration;
        Result := -AChangeInValue * ACurrentTime * (ACurrentTime-2) + AStartValue;
      end;

    AGT_etInOutQuad:
      begin
        ACurrentTime := ACurrentTime / (ADuration / 2);
        if ACurrentTime < 1 then
          Result := AChangeInValue / 2 * ACurrentTime * ACurrentTime + AStartValue
        else
        begin
          ACurrentTime := ACurrentTime - 1;
          Result := -AChangeInValue / 2 * (ACurrentTime * (ACurrentTime - 2) - 1) + AStartValue;
        end;
      end;

    AGT_etInCubic:
      begin
        ACurrentTime := ACurrentTime / ADuration;
        Result := AChangeInValue * ACurrentTime * ACurrentTime * ACurrentTime + AStartValue;
      end;

    AGT_etOutCubic:
      begin
        ACurrentTime := (ACurrentTime / ADuration) - 1;
        Result := AChangeInValue * ( ACurrentTime * ACurrentTime * ACurrentTime + 1) + AStartValue;
      end;

    AGT_etInOutCubic:
      begin
        ACurrentTime := ACurrentTime / (ADuration/2);
        if ACurrentTime < 1 then
          Result := AChangeInValue / 2 * ACurrentTime * ACurrentTime * ACurrentTime + AStartValue
        else
        begin
          ACurrentTime := ACurrentTime - 2;
          Result := AChangeInValue / 2 * (ACurrentTime * ACurrentTime * ACurrentTime + 2) + AStartValue;
        end;
      end;

    AGT_etInQuart:
      begin
        ACurrentTime := ACurrentTime / ADuration;
        Result := AChangeInValue * ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime + AStartValue;
      end;

    AGT_etOutQuart:
      begin
        ACurrentTime := (ACurrentTime / ADuration) - 1;
        Result := -AChangeInValue * (ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime - 1) + AStartValue;
      end;

    AGT_etInOutQuart:
      begin
        ACurrentTime := ACurrentTime / (ADuration / 2);
        if ACurrentTime < 1 then
          Result := AChangeInValue / 2 * ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime + AStartValue
        else
        begin
          ACurrentTime := ACurrentTime - 2;
          Result := -AChangeInValue / 2 * (ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime - 2) + AStartValue;
        end;
      end;

    AGT_etInQuint:
      begin
        ACurrentTime := ACurrentTime / ADuration;
        Result := AChangeInValue * ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime + AStartValue;
      end;

    AGT_etOutQuint:
      begin
        ACurrentTime := (ACurrentTime / ADuration) - 1;
        Result := AChangeInValue * (ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime + 1) + AStartValue;
      end;

    AGT_etInOutQuint:
      begin
        ACurrentTime := ACurrentTime / (ADuration / 2);
        if ACurrentTime < 1 then
          Result := AChangeInValue / 2 * ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime + AStartValue
        else
        begin
          ACurrentTime := ACurrentTime - 2;
          Result := AChangeInValue / 2 * (ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime * ACurrentTime + 2) + AStartValue;
        end;
      end;

    AGT_etInSine:
      begin
        Result := -AChangeInValue * Cos(ACurrentTime / ADuration * (PI / 2)) + AChangeInValue + AStartValue;
      end;

    AGT_etOutSine:
      begin
        Result := AChangeInValue * Sin(ACurrentTime / ADuration * (PI / 2)) + AStartValue;
      end;

    AGT_etInOutSine:
      begin
        Result := -AChangeInValue / 2 * (Cos(PI * ACurrentTime / ADuration) - 1) + AStartValue;
      end;

    AGT_etInExpo:
      begin
        Result := AChangeInValue * Power(2, 10 * (ACurrentTime/ADuration - 1) ) + AStartValue;
      end;

    AGT_etOutExpo:
      begin
        Result := AChangeInValue * (-Power(2, -10 * ACurrentTime / ADuration ) + 1 ) + AStartValue;
      end;

    AGT_etInOutExpo:
      begin
        ACurrentTime := ACurrentTime / (ADuration/2);
        if ACurrentTime < 1 then
          Result := AChangeInValue / 2 * Power(2, 10 * (ACurrentTime - 1) ) + AStartValue
        else
         begin
           ACurrentTime := ACurrentTime - 1;
           Result := AChangeInValue / 2 * (-Power(2, -10 * ACurrentTime) + 2 ) + AStartValue;
         end;
      end;

    AGT_etInCircle:
      begin
        ACurrentTime := ACurrentTime / ADuration;
        Result := -AChangeInValue * (Sqrt(1 - ACurrentTime * ACurrentTime) - 1) + AStartValue;
      end;

    AGT_etOutCircle:
      begin
        ACurrentTime := (ACurrentTime / ADuration) - 1;
        Result := AChangeInValue * Sqrt(1 - ACurrentTime * ACurrentTime) + AStartValue;
      end;

    AGT_etInOutCircle:
      begin
        ACurrentTime := ACurrentTime / (ADuration / 2);
        if ACurrentTime < 1 then
          Result := -AChangeInValue / 2 * (Sqrt(1 - ACurrentTime * ACurrentTime) - 1) + AStartValue
        else
        begin
          ACurrentTime := ACurrentTime - 2;
          Result := AChangeInValue / 2 * (Sqrt(1 - ACurrentTime * ACurrentTime) + 1) + AStartValue;
        end;
      end;
  end;
end;

class function  AGT_Math.EasePosition(AStartPos: Double; AEndPos: Double; ACurrentPos: Double; AEaseType: AGT_EaseType): Double;
var
  LT, LB, LC, LD: Double;
begin
  LC := AEndPos - AStartPos;
  LD := 100;
  LT := ACurrentPos;
  LB := AStartPos;
  Result := EaseValue(LT, LB, LC, LD, AEaseType);
  if Result > 100 then
    Result := 100;
end;

class function  AGT_Math.OBBIntersect(const AObbA, AObbB: AGT_OBB): Boolean;
var
  LAxes: array[0..3] of AGT_Point;
  I: Integer;
  LProjA, LProjB: AGT_Point;

  function Dot(const A, B: AGT_Point): Single;
  begin
    Result := A.x * B.x + A.y * B.y;
  end;

  function Rotate(const V: AGT_Point; AAngle: Single): AGT_Point;
  var
    s, c: Single;
    LAngle: Cardinal;
  begin
    LAngle := Abs(Round(AAngle));
    s := AGT_Math.AngleSin(LAngle);
    c := AGT_Math.AngleCos(LAngle);
    Result.x := V.x * c - V.y * s;
    Result.y := V.x * s + V.y * c;
  end;

  function Project(const AObb: AGT_OBB; const AAxis: AGT_Point): AGT_Point;
  var
    LCorners: array[0..3] of AGT_Point;
    I: Integer;
    LDot: Single;
  begin
    LCorners[0] := Rotate(AGT_Math.Point(AObb.Extents.x, AObb.Extents.y), AObb.Rotation);
    LCorners[1] := Rotate(AGT_Math.Point(-AObb.Extents.x, AObb.Extents.y), AObb.Rotation);
    LCorners[2] := Rotate(AGT_Math.Point(AObb.Extents.x, -AObb.Extents.y), AObb.Rotation);
    LCorners[3] := Rotate(AGT_Math.Point(-AObb.Extents.x, -AObb.Extents.y), AObb.Rotation);

    Result.x := Dot(AAxis, AGT_Math.Point(AObb.Center.x + LCorners[0].x, AObb.Center.y + LCorners[0].y));
    Result.y := Result.x;

    for I := 1 to 3 do
    begin
      LDot := Dot(AAxis, AGT_Math.Point(AObb.Center.x + LCorners[I].x, AObb.Center.y + LCorners[I].y));
      if LDot < Result.x then Result.x := LDot;
      if LDot > Result.y then Result.y := LDot;
    end;
  end;

begin
  LAxes[0] := Rotate(AGT_Math.Point(1, 0), AObbA.Rotation);
  LAxes[1] := Rotate(AGT_Math.Point(0, 1), AObbA.Rotation);
  LAxes[2] := Rotate(AGT_Math.Point(1, 0), AObbB.Rotation);
  LAxes[3] := Rotate(AGT_Math.Point(0, 1), AObbB.Rotation);

  for I := 0 to 3 do
  begin
    LProjA := Project(AObbA, LAxes[I]);
    LProjB := Project(AObbB, LAxes[I]);
    if (LProjA.y < LProjB.x) or (LProjB.y < LProjA.x) then Exit(False);
  end;

  Result := True;
end;

end.
