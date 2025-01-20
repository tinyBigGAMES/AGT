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

unit Aurora.Window;

{$I Aurora.Defines.inc}

interface

uses
  WinApi.Windows,
  WinApi.Messages,
  System.SysUtils,
  System.Math,
  Aurora.CLibs,
  Aurora.OpenGL,
  Aurora.Utils,
  Aurora.Common,
  Aurora.Math,
  Aurora.Color,
  Aurora.Error;

const
  AGT_KEY_UNKNOWN = -1;
  AGT_KEY_SPACE = 32;
  AGT_KEY_APOSTROPHE = 39;
  AGT_KEY_COMMA = 44;
  AGT_KEY_MINUS = 45;
  AGT_KEY_PERIOD = 46;
  AGT_KEY_SLASH = 47;
  AGT_KEY_0 = 48;
  AGT_KEY_1 = 49;
  AGT_KEY_2 = 50;
  AGT_KEY_3 = 51;
  AGT_KEY_4 = 52;
  AGT_KEY_5 = 53;
  AGT_KEY_6 = 54;
  AGT_KEY_7 = 55;
  AGT_KEY_8 = 56;
  AGT_KEY_9 = 57;
  AGT_KEY_SEMICOLON = 59;
  AGT_KEY_EQUAL = 61;
  AGT_KEY_A = 65;
  AGT_KEY_B = 66;
  AGT_KEY_C = 67;
  AGT_KEY_D = 68;
  AGT_KEY_E = 69;
  AGT_KEY_F = 70;
  AGT_KEY_G = 71;
  AGT_KEY_H = 72;
  AGT_KEY_I = 73;
  AGT_KEY_J = 74;
  AGT_KEY_K = 75;
  AGT_KEY_L = 76;
  AGT_KEY_M = 77;
  AGT_KEY_N = 78;
  AGT_KEY_O = 79;
  AGT_KEY_P = 80;
  AGT_KEY_Q = 81;
  AGT_KEY_R = 82;
  AGT_KEY_S = 83;
  AGT_KEY_T = 84;
  AGT_KEY_U = 85;
  AGT_KEY_V = 86;
  AGT_KEY_W = 87;
  AGT_KEY_X = 88;
  AGT_KEY_Y = 89;
  AGT_KEY_Z = 90;
  AGT_KEY_LEFT_BRACKET = 91;
  AGT_KEY_BACKSLASH = 92;
  AGT_KEY_RIGHT_BRACKET = 93;
  AGT_KEY_GRAVE_ACCENT = 96;
  AGT_KEY_WORLD_1 = 161;
  AGT_KEY_WORLD_2 = 162;
  AGT_KEY_ESCAPE = 256;
  AGT_KEY_ENTER = 257;
  AGT_KEY_TAB = 258;
  AGT_KEY_BACKSPACE = 259;
  AGT_KEY_INSERT = 260;
  AGT_KEY_DELETE = 261;
  AGT_KEY_RIGHT = 262;
  AGT_KEY_LEFT = 263;
  AGT_KEY_DOWN = 264;
  AGT_KEY_UP = 265;
  AGT_KEY_PAGE_UP = 266;
  AGT_KEY_PAGE_DOWN = 267;
  AGT_KEY_HOME = 268;
  AGT_KEY_END = 269;
  AGT_KEY_CAPS_LOCK = 280;
  AGT_KEY_SCROLL_LOCK = 281;
  AGT_KEY_NUM_LOCK = 282;
  AGT_KEY_PRINT_SCREEN = 283;
  AGT_KEY_PAUSE = 284;
  AGT_KEY_F1 = 290;
  AGT_KEY_F2 = 291;
  AGT_KEY_F3 = 292;
  AGT_KEY_F4 = 293;
  AGT_KEY_F5 = 294;
  AGT_KEY_F6 = 295;
  AGT_KEY_F7 = 296;
  AGT_KEY_F8 = 297;
  AGT_KEY_F9 = 298;
  AGT_KEY_F10 = 299;
  AGT_KEY_F11 = 300;
  AGT_KEY_F12 = 301;
  AGT_KEY_F13 = 302;
  AGT_KEY_F14 = 303;
  AGT_KEY_F15 = 304;
  AGT_KEY_F16 = 305;
  AGT_KEY_F17 = 306;
  AGT_KEY_F18 = 307;
  AGT_KEY_F19 = 308;
  AGT_KEY_F20 = 309;
  AGT_KEY_F21 = 310;
  AGT_KEY_F22 = 311;
  AGT_KEY_F23 = 312;
  AGT_KEY_F24 = 313;
  AGT_KEY_F25 = 314;
  AGT_KEY_KP_0 = 320;
  AGT_KEY_KP_1 = 321;
  AGT_KEY_KP_2 = 322;
  AGT_KEY_KP_3 = 323;
  AGT_KEY_KP_4 = 324;
  AGT_KEY_KP_5 = 325;
  AGT_KEY_KP_6 = 326;
  AGT_KEY_KP_7 = 327;
  AGT_KEY_KP_8 = 328;
  AGT_KEY_KP_9 = 329;
  AGT_KEY_KP_DECIMAL = 330;
  AGT_KEY_KP_DIVIDE = 331;
  AGT_KEY_KP_MULTIPLY = 332;
  AGT_KEY_KP_SUBTRACT = 333;
  AGT_KEY_KP_ADD = 334;
  AGT_KEY_KP_ENTER = 335;
  AGT_KEY_KP_EQUAL = 336;
  AGT_KEY_LEFT_SHIFT = 340;
  AGT_KEY_LEFT_CONTROL = 341;
  AGT_KEY_LEFT_ALT = 342;
  AGT_KEY_LEFT_SUPER = 343;
  AGT_KEY_RIGHT_SHIFT = 344;
  AGT_KEY_RIGHT_CONTROL = 345;
  AGT_KEY_RIGHT_ALT = 346;
  AGT_KEY_RIGHT_SUPER = 347;
  AGT_KEY_MENU = 348;
  AGT_KEY_LAST = AGT_KEY_MENU;

const
  AGT_MOUSE_BUTTON_1 = 0;
  AGT_MOUSE_BUTTON_2 = 1;
  AGT_MOUSE_BUTTON_3 = 2;
  AGT_MOUSE_BUTTON_4 = 3;
  AGT_MOUSE_BUTTON_5 = 4;
  AGT_MOUSE_BUTTON_6 = 5;
  AGT_MOUSE_BUTTON_7 = 6;
  AGT_MOUSE_BUTTON_8 = 7;
  AGT_MOUSE_BUTTON_LAST = 7;
  AGT_MOUSE_BUTTON_LEFT = 0;
  AGT_MOUSE_BUTTON_RIGHT = 1;
  AGT_MOUSE_BUTTON_MIDDLE = 2;

const
  AGT_GAMEPAD_1 = 0;
  AGT_GAMEPAD_2 = 1;
  AGT_GAMEPAD_3 = 2;
  AGT_GAMEPAD_4 = 3;
  AGT_GAMEPAD_5 = 4;
  AGT_GAMEPAD_6 = 5;
  AGT_GAMEPAD_7 = 6;
  AGT_GAMEPAD_8 = 7;
  AGT_GAMEPAD_9 = 8;
  AGT_GAMEPAD_10 = 9;
  AGT_GAMEPAD_11 = 10;
  AGT_GAMEPAD_12 = 11;
  AGT_GAMEPAD_13 = 12;
  AGT_GAMEPAD_14 = 13;
  AGT_GAMEPAD_15 = 14;
  AGT_GAMEPAD_16 = 15;
  AGT_GAMEPAD_LAST = AGT_GAMEPAD_16;

const
  AGT_GAMEPAD_BUTTON_A = 0;
  AGT_GAMEPAD_BUTTON_B = 1;
  AGT_GAMEPAD_BUTTON_X = 2;
  AGT_GAMEPAD_BUTTON_Y = 3;
  AGT_GAMEPAD_BUTTON_LEFT_BUMPER = 4;
  AGT_GAMEPAD_BUTTON_RIGHT_BUMPER = 5;
  AGT_GAMEPAD_BUTTON_BACK = 6;
  AGT_GAMEPAD_BUTTON_START = 7;
  AGT_GAMEPAD_BUTTON_GUIDE = 8;
  AGT_GAMEPAD_BUTTON_LEFT_THUMB = 9;
  AGT_GAMEPAD_BUTTON_RIGHT_THUMB = 10;
  AGT_GAMEPAD_BUTTON_DPAD_UP = 11;
  AGT_GAMEPAD_BUTTON_DPAD_RIGHT = 12;
  AGT_GAMEPAD_BUTTON_DPAD_DOWN = 13;
  AGT_GAMEPAD_BUTTON_DPAD_LEFT = 14;
  AGT_GAMEPAD_BUTTON_LAST = AGT_GAMEPAD_BUTTON_DPAD_LEFT;
  AGT_GAMEPAD_BUTTON_CROSS = AGT_GAMEPAD_BUTTON_A;
  AGT_GAMEPAD_BUTTON_CIRCLE = AGT_GAMEPAD_BUTTON_B;
  AGT_GAMEPAD_BUTTON_SQUARE = AGT_GAMEPAD_BUTTON_X;
  AGT_AMEPAD_BUTTON_TRIANGLE = AGT_GAMEPAD_BUTTON_Y;

const
  AGT_GAMEPAD_AXIS_LEFT_X = 0;
  AGT_GAMEPAD_AXIS_LEFT_Y = 1;
  AGT_GAMEPAD_AXIS_RIGHT_X = 2;
  AGT_GAMEPAD_AXIS_RIGHT_Y = 3;
  AGT_GAMEPAD_AXIS_LEFT_TRIGGER = 4;
  AGT_GAMEPAD_AXIS_RIGHT_TRIGGER = 5;
  AGT_GAMEPAD_AXIS_LAST = AGT_GAMEPAD_AXIS_RIGHT_TRIGGER;

const
  AGT_DEFAULT_WINDOW_WIDTH  = 1920 div 2;
  AGT_DEFAULT_WINDOW_HEIGHT = 1080 div 2;

  AGT_DEFAULT_FPS = 60;

type
  { AGT_InputState }
  AGT_InputState = (AGT_isPressed, AGT_isWasPressed, AGT_isWasReleased);

  { AGT_Window }
  AGT_Window = class(TAGTBaseObject)
  protected type
    TTiming = record
      LastTime: Double;
      TargetTime: Double;
      CurrentTime: Double;
      ElapsedTime: Double;
      RemainingTime: Double;
      LastFPSTime: Double;
      Endtime: double;
      FrameCount: Cardinal;
      Framerate: Cardinal;
      TargetFrameRate: Cardinal;
      DeltaTime: Double;
    end;
  protected
    FParent: HWND;
    FHandle: PGLFWwindow;
    FVirtualSize: AGT_Size;
    FMaxTextureSize: Integer;
    FIsFullscreen: Boolean;
    FWindowedPosX, FWindowedPosY: Integer;
    FWindowedWidth, FWindowedHeight: Integer;
    FViewport: AGT_Rect;
    FKeyState: array [0..0, AGT_KEY_SPACE..AGT_KEY_LAST] of Boolean;
    FMouseButtonState: array [0..0, AGT_MOUSE_BUTTON_1..AGT_MOUSE_BUTTON_MIDDLE] of Boolean;
    FGamepadButtonState: array[0..0, AGT_GAMEPAD_BUTTON_A..AGT_GAMEPAD_BUTTON_LAST] of Boolean;
    FTiming: TTiming;
    FMouseWheel: AGT_Vector;
    procedure SetDefaultIcon();
    procedure StartTiming();
    procedure StopTiming();
  public
    property Handle: PGLFWwindow read FHandle;

    constructor Create(); override;
    destructor Destroy(); override;

    function  Open(const ATitle: string; const AVirtualWidth: Cardinal=AGT_DEFAULT_WINDOW_WIDTH; const AVirtualHeight: Cardinal=AGT_DEFAULT_WINDOW_HEIGHT; const AParent: NativeUInt=0): Boolean;
    procedure Close();

    function  GetTitle(): string;
    procedure SetTitle(const ATitle: string);

    procedure SetSizeLimits(const AMinWidth, AMinHeight, AMaxWidth, AMaxHeight: Integer);
    procedure Resize(const AWidth, AHeight: Cardinal);
    procedure ToggleFullscreen();
    function  IsFullscreen(): Boolean;

    function  HasFocus(): Boolean;

    function  GetVirtualSize(): AGT_Size;
    function  GetSize(): AGT_Size;
    function  GetScale(): AGT_Size;
    function  GetMaxTextureSize: Integer;

    function  GetViewport(): AGT_Rect;

    procedure Center();

    function  ShouldClose(): Boolean;
    procedure SetShouldClose(const AClose: Boolean);

    procedure StartFrame();
    procedure EndFrame();

    procedure StartDrawing();
    procedure ResetDrawing();
    procedure EndDrawing();

    procedure Clear(const AColor: AGT_Color);

    procedure DrawLine(const X1, Y1, X2, Y2: Single; const AColor: AGT_Color; const AThickness: Single);
    procedure DrawRect(const X, Y, AWidth, AHeight, AThickness: Single; const AColor: AGT_Color; const AAngle: Single);
    procedure DrawFilledRect(const X, Y, AWidth, AHeight: Single; const AColor: AGT_Color; const AAngle: Single);
    procedure DrawCircle(const X, Y, ARadius, AThickness: Single; const AColor: AGT_Color);
    procedure DrawFilledCircle(const X, Y, ARadius: Single; const AColor: AGT_Color);
    procedure DrawTriangle(const X1, Y1, X2, Y2, X3, Y3, AThickness: Single; const AColor: AGT_Color);
    procedure DrawFilledTriangle(const X1, Y1, X2, Y2, X3, Y3: Single; const AColor: AGT_Color);
    procedure DrawPolygon(const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color);
    procedure DrawFilledPolygon(const APoints: PAGT_Point; const ACount: UInt32; const AColor: AGT_Color);
    procedure DrawPolyline(const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color);

    procedure ClearInput();
    function  GetKey(const AKey: Integer; const AState: AGT_InputState): Boolean;
    function  GetMouseButton(const AButton: Byte; const AState: AGT_InputState): Boolean;
    procedure GetMousePos(const X, Y: System.PSingle); overload;
    function  GetMousePos(): AGT_Point; overload;
    procedure SetMousePos(const X, Y: Single);
    function  GetMouseWheel(): AGT_Vector;

    function  GamepadPresent(const AGamepad: Byte): Boolean;
    function  GetGamepadName(const AGamepad: Byte): string;
    function  GetGamepadButton(const AGamepad, AButton: Byte; const AState: AGT_InputState): Boolean;
    function  GetGamepadAxisValue(const AGamepad, AAxis: Byte): Single;

    function  VirtualToScreen(const X, Y: Single): AGT_Point;
    function  ScreenToVirtual(const X, Y: Single): AGT_Point;

    procedure SetTargetFrameRate(const ATargetFrameRate: UInt32=AGT_DEFAULT_FPS);
    function  GetTargetFrameRate(): UInt32;
    function  GetTargetTime(): Double;
    procedure ResetTiming();
    function  GetFrameRate(): UInt32;
    function  GetDeltaTime(): Double;

    class function  Init(const ATitle: string; const AVirtualWidth: Cardinal=AGT_DEFAULT_WINDOW_WIDTH; const AVirtualHeight: Cardinal=AGT_DEFAULT_WINDOW_HEIGHT; const AParent: NativeUInt=0): AGT_Window; static;
  end;

//=== EXPORTS ===============================================================

function  AGT_Window_Open(const ATitle: PWideChar; const AVirtualWidth: Cardinal=AGT_DEFAULT_WINDOW_WIDTH; const AVirtualHeight: Cardinal=AGT_DEFAULT_WINDOW_HEIGHT; const AParent: NativeUInt=0): AGT_Window; cdecl; exports AGT_Window_Open;
procedure AGT_Window_Close(var AWindow: AGT_Window); cdecl; exports AGT_Window_Close;
function  AGT_Window_GetTitle(const AWindow: AGT_Window): PWideChar; cdecl; exports AGT_Window_GetTitle;
procedure AGT_Window_SetTitle(const AWindow: AGT_Window; const ATitle: PWideChar); cdecl; exports AGT_Window_SetTitle;
procedure AGT_Window_SetSizeLimits(const AWindow: AGT_Window; const AMinWidth, AMinHeight, AMaxWidth, AMaxHeight: Integer); cdecl; exports AGT_Window_SetSizeLimits;
procedure AGT_Window_Resize(const AWindow: AGT_Window; const AWidth, AHeight: Cardinal); cdecl; exports AGT_Window_Resize;
procedure AGT_Window_ToggleFullscreen(const AWindow: AGT_Window); cdecl; exports AGT_Window_ToggleFullscreen;
function  AGT_Window_IsFullscreen(const AWindow: AGT_Window): Boolean; cdecl; exports AGT_Window_IsFullscreen;
function  AGT_Window_HasFocus(const AWindow: AGT_Window): Boolean; cdecl; exports AGT_Window_HasFocus;
function  AGT_Window_GetVirtualSize(const AWindow: AGT_Window): AGT_Size; cdecl; exports AGT_Window_GetVirtualSize;
function  AGT_Window_GetSize(const AWindow: AGT_Window): AGT_Size; cdecl; exports AGT_Window_GetSize;
function  AGT_Window_GetScale(const AWindow: AGT_Window): AGT_Size; cdecl; exports AGT_Window_GetScale;
function  AGT_Window_GetMaxTextureSize(const AWindow: AGT_Window): Integer; cdecl; exports AGT_Window_GetMaxTextureSize;
function  AGT_Window_GetViewport(const AWindow: AGT_Window): AGT_Rect; cdecl; exports AGT_Window_GetViewport;
procedure AGT_Window_Center(const AWindow: AGT_Window); cdecl; exports AGT_Window_Center;
function  AGT_Window_ShouldClose(const AWindow: AGT_Window): Boolean; cdecl; exports AGT_Window_ShouldClose;
procedure AGT_Window_SetShouldClose(const AWindow: AGT_Window; const AClose: Boolean); cdecl; exports AGT_Window_SetShouldClose;
procedure AGT_Window_StartFrame(const AWindow: AGT_Window); cdecl; exports AGT_Window_StartFrame;
procedure AGT_Window_EndFrame(const AWindow: AGT_Window); cdecl; exports AGT_Window_EndFrame;
procedure AGT_Window_StartDrawing(const AWindow: AGT_Window); cdecl; exports AGT_Window_StartDrawing;
procedure AGT_Window_ResetDrawing(const AWindow: AGT_Window); cdecl; exports AGT_Window_ResetDrawing;
procedure AGT_Window_EndDrawing(const AWindow: AGT_Window); cdecl; exports AGT_Window_EndDrawing;
procedure AGT_Window_Clear(const AWindow: AGT_Window; const AColor: AGT_Color); cdecl; exports AGT_Window_Clear;
procedure AGT_Window_DrawLine(const AWindow: AGT_Window; const X1, Y1, X2, Y2: Single; const AColor: AGT_Color; const AThickness: Single); cdecl; exports AGT_Window_DrawLine;
procedure AGT_Window_DrawRect(const AWindow: AGT_Window; const X, Y, AWidth, AHeight, AThickness: Single; const AColor: AGT_Color; const AAngle: Single); cdecl; exports AGT_Window_DrawRect;
procedure AGT_Window_DrawFilledRect(const AWindow: AGT_Window; const X, Y, AWidth, AHeight: Single; const AColor: AGT_Color; const AAngle: Single); cdecl; exports AGT_Window_DrawFilledRect;
procedure AGT_Window_DrawCircle(const AWindow: AGT_Window; const X, Y, ARadius, AThickness: Single; const AColor: AGT_Color); cdecl; exports AGT_Window_DrawCircle;
procedure AGT_Window_DrawFilledCircle(const AWindow: AGT_Window; const X, Y, ARadius: Single; const AColor: AGT_Color); cdecl; exports AGT_Window_DrawFilledCircle;
procedure AGT_Window_DrawTriangle(const AWindow: AGT_Window; const X1, Y1, X2, Y2, X3, Y3, AThickness: Single; const AColor: AGT_Color); cdecl; exports AGT_Window_DrawTriangle;
procedure AGT_Window_DrawFilledTriangle(const AWindow: AGT_Window; const X1, Y1, X2, Y2, X3, Y3: Single; const AColor: AGT_Color); cdecl; exports AGT_Window_DrawFilledTriangle;
procedure AGT_Window_DrawPolygon(const AWindow: AGT_Window; const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color); cdecl; exports AGT_Window_DrawPolygon;
procedure AGT_Window_DrawFilledPolygon(const AWindow: AGT_Window; const APoints: PAGT_Point; const ACount: UInt32; const AColor: AGT_Color); cdecl; exports AGT_Window_DrawFilledPolygon;
procedure AGT_Window_DrawPolyline(const AWindow: AGT_Window; const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color); cdecl; exports AGT_Window_DrawPolyline;
procedure AGT_Window_ClearInput(const AWindow: AGT_Window); cdecl; exports AGT_Window_ClearInput;
function  AGT_Window_GetKey(const AWindow: AGT_Window; const AKey: Integer; const AState: AGT_InputState): Boolean; cdecl; exports AGT_Window_GetKey;
function  AGT_Window_GetMouseButton(const AWindow: AGT_Window; const AButton: Byte; const AState: AGT_InputState): Boolean; cdecl; exports AGT_Window_GetMouseButton;
procedure AGT_Window_GetMousePosXY(const AWindow: AGT_Window; const X, Y: System.PSingle); cdecl; exports AGT_Window_GetMousePosXY;
function  AGT_Window_GetMousePos(const AWindow: AGT_Window): AGT_Point; cdecl; exports AGT_Window_GetMousePos;
procedure AGT_Window_SetMousePos(const AWindow: AGT_Window; const X, Y: Single); cdecl; exports AGT_Window_SetMousePos;
function  AGT_Window_GetMouseWheel(const AWindow: AGT_Window): AGT_Vector; cdecl; exports AGT_Window_GetMouseWheel;
function  AGT_Window_GamepadPresent(const AWindow: AGT_Window; const AGamepad: Byte): Boolean; cdecl; exports AGT_Window_GamepadPresent;
function  AGT_Window_GetGamepadName(const AWindow: AGT_Window; const AGamepad: Byte): PWideChar; cdecl; exports AGT_Window_GetGamepadName;
function  AGT_Window_GetGamepadButton(const AWindow: AGT_Window; const AGamepad, AButton: Byte; const AState: AGT_InputState): Boolean; cdecl; exports AGT_Window_GetGamepadButton;
function  AGT_Window_GetGamepadAxisValue(const AWindow: AGT_Window; const AGamepad, AAxis: Byte): Single; cdecl; exports AGT_Window_GetGamepadAxisValue;
function  AGT_Window_VirtualToScreen(const AWindow: AGT_Window; const X, Y: Single): AGT_Point; cdecl; exports AGT_Window_VirtualToScreen;
function  AGT_Window_ScreenToVirtual(const AWindow: AGT_Window; const X, Y: Single): AGT_Point; cdecl; exports AGT_Window_ScreenToVirtual;
procedure AGT_Window_SetTargetFrameRate(const AWindow: AGT_Window; const ATargetFrameRate: UInt32=AGT_DEFAULT_FPS); cdecl; exports AGT_Window_SetTargetFrameRate;
function  AGT_Window_GetTargetFrameRate(const AWindow: AGT_Window): UInt32; cdecl; exports AGT_Window_GetTargetFrameRate;
function  AGT_Window_GetTargetTime(const AWindow: AGT_Window): Double; cdecl; exports AGT_Window_GetTargetTime;
procedure AGT_Window_ResetTiming(const AWindow: AGT_Window); cdecl; exports AGT_Window_ResetTiming;
function  AGT_Window_GetFrameRate(const AWindow: AGT_Window): UInt32; cdecl; exports AGT_Window_GetFrameRate;
function  AGT_Window_GetDeltaTime(const AWindow: AGT_Window): Double; cdecl; exports AGT_Window_GetDeltaTime;

implementation

uses
  Aurora.Audio,
  Aurora.Video;

//=== EXPORTS ===============================================================
function  AGT_Window_Open(const ATitle: PWideChar; const AVirtualWidth: Cardinal; const AVirtualHeight: Cardinal; const AParent: NativeUInt): AGT_Window;
begin
  Result := AGT_Window.Init(string(ATitle), AVirtualWidth, AVirtualHeight, AParent)
end;

procedure AGT_Window_Close(var AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;
  AWindow.Free();
  AWindow := nil;
end;

function  AGT_Window_GetTitle(const AWindow: AGT_Window): PWideChar;
begin
  Result := nil;
  if not Assigned(AWindow) then Exit;

  Result := PWideChar(AWindow.GetTitle());
end;

procedure AGT_Window_SetTitle(const AWindow: AGT_Window; const ATitle: PWideChar);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.SetTitle(string(ATitle));
end;

procedure AGT_Window_SetSizeLimits(const AWindow: AGT_Window; const AMinWidth, AMinHeight, AMaxWidth, AMaxHeight: Integer);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.SetSizeLimits(AMinWidth, AMinHeight, AMaxWidth, AMaxHeight);
end;

procedure AGT_Window_Resize(const AWindow: AGT_Window; const AWidth, AHeight: Cardinal);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.Resize(AWidth, AHeight);
end;

procedure AGT_Window_ToggleFullscreen(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.ToggleFullscreen();
end;

function  AGT_Window_IsFullscreen(const AWindow: AGT_Window): Boolean;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.IsFullscreen();
end;

function  AGT_Window_HasFocus(const AWindow: AGT_Window): Boolean;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.HasFocus();
end;

function  AGT_Window_GetVirtualSize(const AWindow: AGT_Window): AGT_Size;
begin
  Result := Default(AGT_Size);
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetVirtualSize();
end;

function  AGT_Window_GetSize(const AWindow: AGT_Window): AGT_Size;
begin
  Result := Default(AGT_Size);
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetSize();
end;

function  AGT_Window_GetScale(const AWindow: AGT_Window): AGT_Size;
begin
  Result := Default(AGT_Size);
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetScale();
end;

function  AGT_Window_GetMaxTextureSize(const AWindow: AGT_Window): Integer;
begin
  Result := 0;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetMaxTextureSize();
end;

function  AGT_Window_GetViewport(const AWindow: AGT_Window): AGT_Rect;
begin
  Result := Default(AGT_Rect);
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetViewport();
end;

procedure AGT_Window_Center(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.Center();
end;

function  AGT_Window_ShouldClose(const AWindow: AGT_Window): Boolean;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.ShouldClose();
end;

procedure AGT_Window_SetShouldClose(const AWindow: AGT_Window; const AClose: Boolean);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.SetShouldClose(AClose);
end;

procedure AGT_Window_StartFrame(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.StartFrame();
end;

procedure AGT_Window_EndFrame(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.EndFrame();
end;

procedure AGT_Window_StartDrawing(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.StartDrawing();
end;

procedure AGT_Window_ResetDrawing(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.ResetDrawing();
end;

procedure AGT_Window_EndDrawing(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.EndDrawing();
end;

procedure AGT_Window_Clear(const AWindow: AGT_Window; const AColor: AGT_Color);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.Clear(AColor);
end;

procedure AGT_Window_DrawLine(const AWindow: AGT_Window; const X1, Y1, X2, Y2: Single; const AColor: AGT_Color; const AThickness: Single);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawLine(X1, Y1, X2, Y2, AColor, AThickness);
end;

procedure AGT_Window_DrawRect(const AWindow: AGT_Window; const X, Y, AWidth, AHeight, AThickness: Single; const AColor: AGT_Color; const AAngle: Single);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawRect(X, Y, AWidth, AHeight, AThickness, AColor, AAngle);
end;

procedure AGT_Window_DrawFilledRect(const AWindow: AGT_Window; const X, Y, AWidth, AHeight: Single; const AColor: AGT_Color; const AAngle: Single);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawFilledRect(X, Y, AWidth, aHeight, AColor, AAngle);
end;

procedure AGT_Window_DrawCircle(const AWindow: AGT_Window; const X, Y, ARadius, AThickness: Single; const AColor: AGT_Color);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawCircle(X, Y, ARadius, AThickness, AColor);
end;

procedure AGT_Window_DrawFilledCircle(const AWindow: AGT_Window; const X, Y, ARadius: Single; const AColor: AGT_Color);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawFilledCircle(X, Y, ARadius, AColor);
end;

procedure AGT_Window_DrawTriangle(const AWindow: AGT_Window; const X1, Y1, X2, Y2, X3, Y3, AThickness: Single; const AColor: AGT_Color);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawTriangle(X1, Y1, X2, Y2, X3, Y3, AThickness, AColor);
end;

procedure AGT_Window_DrawFilledTriangle(const AWindow: AGT_Window; const X1, Y1, X2, Y2, X3, Y3: Single; const AColor: AGT_Color);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawFilledTriangle(X1, Y1, X2, Y2, X3, Y3, AColor);
end;

procedure AGT_Window_DrawPolygon(const AWindow: AGT_Window; const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawPolygon(APoints, ACount, AThickness, AColor);
end;

procedure AGT_Window_DrawFilledPolygon(const AWindow: AGT_Window; const APoints: PAGT_Point; const ACount: UInt32; const AColor: AGT_Color);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawFilledPolygon(APoints, ACount, AColor);
end;

procedure AGT_Window_DrawPolyline(const AWindow: AGT_Window; const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.DrawPolyline(APoints, ACount, AThickness, AColor);
end;

procedure AGT_Window_ClearInput(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.ClearInput();
end;

function  AGT_Window_GetKey(const AWindow: AGT_Window; const AKey: Integer; const AState: AGT_InputState): Boolean;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetKey(AKey, AState);
end;

function  AGT_Window_GetMouseButton(const AWindow: AGT_Window; const AButton: Byte; const AState: AGT_InputState): Boolean;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetMouseButton(AButton, AState);
end;

procedure AGT_Window_GetMousePosXY(const AWindow: AGT_Window; const X, Y: System.PSingle);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.GetMousePos(X, Y);
end;

function  AGT_Window_GetMousePos(const AWindow: AGT_Window): AGT_Point;
begin
  Result := Default(AGT_Point);
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetMousePos();
end;

procedure AGT_Window_SetMousePos(const AWindow: AGT_Window; const X, Y: Single);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.SetMousePos(X, Y);
end;

function  AGT_Window_GetMouseWheel(const AWindow: AGT_Window): AGT_Vector;
begin
  Result := Default(AGT_Vector);
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetMouseWheel();
end;

function  AGT_Window_GamepadPresent(const AWindow: AGT_Window; const AGamepad: Byte): Boolean;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GamepadPresent(AGamepad);
end;

function  AGT_Window_GetGamepadName(const AWindow: AGT_Window; const AGamepad: Byte): PWideChar;
begin
  Result := nil;
  if not Assigned(AWindow) then Exit;

  Result := PWideChar(AWindow.GetGamepadName(AGamepad));
end;

function  AGT_Window_GetGamepadButton(const AWindow: AGT_Window; const AGamepad, AButton: Byte; const AState: AGT_InputState): Boolean;
begin
  Result := False;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetGamepadButton(AGamepad, AButton, AState);
end;

function  AGT_Window_GetGamepadAxisValue(const AWindow: AGT_Window; const AGamepad, AAxis: Byte): Single;
begin
  Result := 0;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetGamepadAxisValue(AGamepad, AAxis);
end;

function  AGT_Window_VirtualToScreen(const AWindow: AGT_Window; const X, Y: Single): AGT_Point;
begin
  Result := Default(AGT_Point);
  if not Assigned(AWindow) then Exit;

  Result := AWindow.VirtualToScreen(X, Y);
end;

function  AGT_Window_ScreenToVirtual(const AWindow: AGT_Window; const X, Y: Single): AGT_Point;
begin
  Result := Default(AGT_Point);
  if not Assigned(AWindow) then Exit;

  Result := AWindow.ScreenToVirtual(X, Y);
end;

procedure AGT_Window_SetTargetFrameRate(const AWindow: AGT_Window; const ATargetFrameRate: UInt32);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.SetTargetFrameRate(ATargetFrameRate);
end;

function  AGT_Window_GetTargetFrameRate(const AWindow: AGT_Window): UInt32;
begin
  Result := 0;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetTargetFrameRate();
end;

function  AGT_Window_GetTargetTime(const AWindow: AGT_Window): Double;
begin
  Result := 0;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetTargetTime();

end;

procedure AGT_Window_ResetTiming(const AWindow: AGT_Window);
begin
  if not Assigned(AWindow) then Exit;

  AWindow.ResetTiming();
end;

function  AGT_Window_GetFrameRate(const AWindow: AGT_Window): UInt32;
begin
  Result := 0;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetFrameRate();
end;

function  AGT_Window_GetDeltaTime(const AWindow: AGT_Window): Double;
begin
  Result := 0;
  if not Assigned(AWindow) then Exit;

  Result := AWindow.GetDeltaTime();
end;

{ AGT_Window }
procedure Window_ResizeCallback(AWindow: PGLFWwindow; AWidth, AHeight: Integer); cdecl;
var
  LWindow: AGT_Window;
  LAspectRatio: Single;
  LNewWidth, LNewHeight: Integer;
  LXOffset, LYOffset: Integer;
  LWidth, LHeight: Integer;
begin
  LWindow := glfwGetWindowUserPointer(AWindow);
  if not Assigned(LWindow) then Exit;

  LWidth :=  Round(LWindow.GetVirtualSize().w);
  LHeight := Round(LWindow.GetVirtualSize().h);

  // Calculate aspect ratio based on the initial window size
  LAspectRatio := LWidth / LHeight;

  // Adjust the viewport based on the new window size
  if AWidth / LAspectRatio <= AHeight then
  begin
    LNewWidth := AWidth;
    LNewHeight := Round(AWidth / LAspectRatio);
    LXOffset := 0;
    LYOffset := (AHeight - LNewHeight) div 2;
  end
  else
  begin
    LNewWidth := Round(AHeight * LAspectRatio);
    LNewHeight := AHeight;
    LXOffset := (AWidth - LNewWidth) div 2;
    LYOffset := 0;
  end;

  // Set the viewport to maintain the aspect ratio and leave black bars
  glViewport(LXOffset, LYOffset, LNewWidth, LNewHeight);

  // Set the scissor box to match the virtual resolution area
  glScissor(LXOffset, LYOffset, LNewWidth, LNewHeight);

  // Set up the orthographic projection
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0, LWidth, LHeight, 0, -1, 1);  // Always map to the virtual coordinates

  // Back to modelview mode
  glMatrixMode(GL_MODELVIEW);

  LWindow.FViewport.pos.x := LXOffset;
  LWindow.FViewport.pos.y := LYOffset;
  LWindow.FViewport.size.w := LNewWidth;
  LWindow.FViewport.size.h := LNewHeight;
end;

procedure TWindow_ScrollCallback(AWindow: PGLFWwindow; AOffsetX, AOffsetY: Double); cdecl;
var
  LWindow: AGT_Window;
begin
  LWindow := glfwGetWindowUserPointer(AWindow);
  if not Assigned(LWindow) then Exit;

  // Save the scroll offsets
  LWindow.FMouseWheel := AGT_Math.Vector(AOffsetX, AOffsetY);
end;

procedure AGT_Window.SetDefaultIcon();
var
  IconHandle: HICON;
begin
  if not Assigned(FHandle) then Exit;

  IconHandle := LoadIcon(GetModuleHandle(nil), 'MAINICON');
  if IconHandle <> 0 then
  begin
    SendMessage(glfwGetWin32Window(FHandle), WM_SETICON, ICON_BIG, IconHandle);
  end;
end;

constructor AGT_Window.Create();
begin
  inherited;
end;

destructor AGT_Window.Destroy();
begin
  Close();
  inherited;
end;

function  AGT_Window.Open(const ATitle: string; const AVirtualWidth: Cardinal; const AVirtualHeight: Cardinal; const AParent: NativeUInt): Boolean;
var
  LWindow: PGLFWwindow;
  LWidth: Integer;
  LHeight: Integer;
  LHWNative: HWND;
  LStyle: NativeInt;
begin
  Result := False;

  if Assigned(FHandle) then Exit;

  LWidth := AVirtualWidth;
  LHeight := AVirtualHeight;

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 2);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);

  // set hints if child or standalone window
  if AParent <> 0 then
    begin
      glfwWindowHint(GLFW_DECORATED, GLFW_FALSE);
      //glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE);
    end
  else
    begin
      glfwWindowHint(GLFW_SCALE_TO_MONITOR, GLFW_TRUE);
    end;

  glfwWindowHint(GLFW_SAMPLES, 4);

  // Create a windowed mode window and its OpenGL context
  LWindow := glfwCreateWindow(LWidth, LHeight, AGT_Utils.AsUTF8(ATitle, []), nil, nil);
  if LWindow = nil then Exit;

  // set hints if child or standalone window
  if AParent <> 0 then
  begin
    LHWNative := glfwGetWin32Window(LWindow);
    WinApi.Windows.SetParent(LHWNative, AParent);
    LStyle := GetWindowLong(LHWNative, GWL_STYLE);
    LStyle := LStyle and not WS_POPUP; // remove popup style
    LStyle := LStyle or WS_CHILDWINDOW; // add childwindow style
    SetWindowLong(LHWNative, GWL_STYLE, LStyle);
  end;

  // Make the window's context current
  glfwMakeContextCurrent(LWindow);

  // init OpenGL extensions
  if not LoadOpenGL() then
  begin
    glfwMakeContextCurrent(nil);
    glfwDestroyWindow(LWindow);
    Exit;
  end;

  // Set the resize callback
  glfwSetFramebufferSizeCallback(LWindow, Window_ResizeCallback);

  // Set the mouse scroll callback
  glfwSetScrollCallback(LWindow, TWindow_ScrollCallback);

  // Enable the scissor test
  glEnable(GL_SCISSOR_TEST);

  // Enable Line Smoothing
  glEnable(GL_LINE_SMOOTH);
  glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

  // Enable Polygon Smoothing
  glEnable(GL_POLYGON_SMOOTH);
  glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);

  // Enable Point Smoothing
  glEnable(GL_POINT_SMOOTH);
  glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);

  // Enable Multisampling for anti-aliasing (if supported)
  glEnable(GL_MULTISAMPLE);

  FHandle := LWindow;

  glfwGetWindowPos(FHandle, @FWindowedPosX, @FWindowedPosY);
  glfwGetWindowSize(FHandle, @FWindowedWidth, @FWindowedHeight);

  FVirtualSize.w := LWidth;
  FVirtualSize.h := LHeight;
  FParent := AParent;

  glGetIntegerv(GL_MAX_TEXTURE_SIZE, @FMaxTextureSize);
  glfwSetInputMode(FHandle, GLFW_STICKY_KEYS, GLFW_TRUE);
  glfwSetInputMode(FHandle, GLFW_STICKY_MOUSE_BUTTONS, GLFW_TRUE);

  glfwSwapInterval(0);

  glfwSetWindowUserPointer(FHandle, Self);

  if FParent = 0 then
    Center();

  glfwGetWindowSize(FHandle, @LWidth, @LHeight);

  FViewport.pos.x := 0;
  FViewport.pos.x := 0;
  FViewport.size.w := LWidth;
  FViewport.size.h := LHeight;

  SetDefaultIcon();

  SetTargetFrameRate(AGT_DEFAULT_FPS);

  Result := True;
end;

procedure AGT_Window.Close();
begin
  if not Assigned(FHandle) then Exit;
  glfwMakeContextCurrent(nil);
  glfwDestroyWindow(FHandle);
  FHandle := nil;
end;

function  AGT_Window.GetTitle(): string;
var
  LHwnd: HWND;
  LLen: Integer;
  LTitle: PChar;
begin
  Result := '';
  if not Assigned(FHandle) then Exit;

  LHwnd := glfwGetWin32Window(FHandle);
  LLen := GetWindowTextLength(LHwnd);
  GetMem(LTitle, LLen + 1);
  try
    GetWindowText(LHwnd, LTitle, LLen + 1);
    Result := string(LTitle);
  finally
    FreeMem(LTitle);
  end;
end;

procedure AGT_Window.SetTitle(const ATitle: string);
begin
  if not Assigned(FHandle) then Exit;

  SetWindowText(glfwGetWin32Window(FHandle), ATitle);
end;

procedure AGT_Window.Resize(const AWidth, AHeight: Cardinal);
begin
  glfwSetWindowSize(FHandle, AWidth, AHeight);
end;

procedure AGT_Window.SetSizeLimits(const AMinWidth, AMinHeight, AMaxWidth, AMaxHeight: Integer);
var
  LScale: AGT_Point;
  LMinWidth, LMinHeight, LMaxWidth, LMaxHeight: Integer;
begin
  glfwGetWindowContentScale(FHandle, @LScale.x, @LScale.y);

  LMinWidth := AMinWidth;
  LMinHeight := AMinHeight;
  LMaxWidth := AMaxWidth;
  LMaxHeight := AMaxHeight;

  if LMinWidth <> GLFW_DONT_CARE then
    LMinWidth := Round(LMinWidth * LScale.x);

  if LMinHeight <> GLFW_DONT_CARE then
    LMinHeight := Round(LMinHeight * LScale.y);


  if LMaxWidth <> GLFW_DONT_CARE then
    LMaxWidth := Round(LMaxWidth * LScale.x);


  if LMaxHeight <> GLFW_DONT_CARE then
    LMaxHeight := Round(LMaxHeight * LScale.y);

  glfwSetWindowSizeLimits(FHandle,LMinWidth, LMinHeight, LMaxWidth, LMaxHeight);
end;

procedure AGT_Window.ToggleFullscreen();
var
  LMonitor: PGLFWmonitor;
  LMode: PGLFWvidmode;
begin
  if not Assigned(FHandle) then Exit;

  if FIsFullscreen then
    begin
      // Switch to windowed mode using the saved window position and size
      glfwSetWindowMonitor(FHandle, nil, FWindowedPosX, FWindowedPosY, FWindowedWidth, FWindowedHeight, 0);
      FIsFullscreen := False;
    end
  else
    begin
      // Get the primary monitor and its video mode
      LMonitor := glfwGetPrimaryMonitor();
      LMode := glfwGetVideoMode(LMonitor);

      // Save the windowed mode position and size
      glfwGetWindowPos(FHandle, @FWindowedPosX, @FWindowedPosY);
      glfwGetWindowSize(FHandle, @FWindowedWidth, @FWindowedHeight);

      // Switch to fullscreen mode at the desktop resolution
      glfwSetWindowMonitor(FHandle, LMonitor, 0, 0, LMode.Width, LMode.Height, LMode.RefreshRate);
      FIsFullscreen := True;
    end;
end;

function  AGT_Window.IsFullscreen(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;
  Result := FIsFullscreen;
end;

function  AGT_Window.GetVirtualSize(): AGT_Size;
begin
  Result.w := 0;
  Result.h := 0;
  if not Assigned(FHandle) then Exit;
  Result := FVirtualSize;
end;

function  AGT_Window.HasFocus(): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;
  Result := Boolean(glfwGetWindowAttrib(FHandle, GLFW_FOCUSED) = GLFW_TRUE);
end;

function  AGT_Window.GetSize(): AGT_Size;
var
  LWindowWidth, LWindowHeight: Double;
begin
  Result.w := 0;
  Result.h := 0;
  if not Assigned(FHandle) then Exit;

  glfwGetWindowSize(FHandle, @LWindowWidth, @LWindowHeight);
  Result.w := LWindowWidth;
  Result.h := LWindowHeight;
end;

function  AGT_Window.GetScale(): AGT_Size;
begin
  Result.w := 0;
  Result.h := 0;
  if not Assigned(FHandle) then Exit;

  glfwGetWindowContentScale(FHandle, @Result.w, @Result.h);
end;

function  AGT_Window.GetMaxTextureSize(): Integer;
begin
  Result := FMaxTextureSize;
end;


function  AGT_Window.GetViewport(): AGT_Rect;
begin
  Result.pos.x := 0;
  Result.pos.y := 0;
  Result.size.w := 0;
  Result.size.h := 0;
  if not Assigned(FHandle) then Exit;
  Result := FViewport;
end;

procedure AGT_Window.Center();
var
  LMonitor: PGLFWmonitor;
  LVideoMode: PGLFWvidmode;
  LScreenWidth, LScreenHeight: Integer;
  LWindowWidth, LWindowHeight: Integer;
  LPosX, LPosY: Integer;
begin
  if not Assigned(FHandle) then Exit;

  if FIsFullscreen then Exit;

  // Get the primary monitor
  LMonitor := glfwGetPrimaryMonitor;

  // Get the video mode of the monitor (i.e., resolution)
  LVideoMode := glfwGetVideoMode(LMonitor);

  // Get the screen width and height
  LScreenWidth := LVideoMode.width;
  LScreenHeight := LVideoMode.height;

  // Get the window width and height
  glfwGetWindowSize(FHandle, @LWindowWidth, @LWindowHeight);

  // Calculate the position to center the window
  LPosX := (LScreenWidth - LWindowWidth) div 2;
  LPosY := (LScreenHeight - LWindowHeight) div 2;

  // Set the window position
  glfwSetWindowPos(FHandle, LPosX, LPosY);
end;

function  AGT_Window.ShouldClose(): Boolean;
begin
  Result := True;
  if not Assigned(FHandle) then Exit;
  Result := Boolean(glfwWindowShouldClose(FHandle) = GLFW_TRUE);
  if Result then
  begin
    AGT_Utils.AsyncWaitForAllToTerminate();
  end;
end;

procedure AGT_Window.SetShouldClose(const AClose: Boolean);
begin
  if not Assigned(FHandle) then Exit;
  glfwSetWindowShouldClose(FHandle, Ord(AClose))
end;

procedure AGT_Window.StartFrame();
begin
  if not Assigned(FHandle) then Exit;

  StartTiming();
  AGT_Audio.Update();
  AGT_Utils.AsyncProcess();
  AGT_Video.Update(Self);
  glfwPollEvents();
end;

procedure AGT_Window.EndFrame();
begin
  if not Assigned(FHandle) then Exit;

  // Reset mouse wheel deltas
  FMouseWheel := AGT_Math.Vector(0,0);

  StopTiming();
end;

procedure AGT_Window.StartDrawing();
begin
  if not Assigned(FHandle) then Exit;

  // Clear the entire screen to black (this will create the black bars)
  glClearColor(0, 0, 0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  ResetDrawing();
end;

procedure AGT_Window.ResetDrawing();
begin
  if not Assigned(FHandle) then Exit;

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0, FVirtualSize.w, FVirtualSize.h, 0, -1, 1);  // Set orthographic projection
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
end;

procedure AGT_Window.EndDrawing();
begin
  if not Assigned(FHandle) then Exit;
  glfwSwapBuffers(FHandle);
end;

procedure AGT_Window.Clear(const AColor: AGT_Color);
begin
  if not Assigned(FHandle) then Exit;
  glClearColor(AColor.r, AColor.g, AColor.b, AColor.a);
  glClear(GL_COLOR_BUFFER_BIT); // Only the viewport area is affected
end;

procedure AGT_Window.DrawLine(const X1, Y1, X2, Y2: Single; const AColor: AGT_Color; const AThickness: Single);
begin
  if not Assigned(FHandle) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);
  glBegin(GL_LINES);
    glVertex2f(X1, Y1);
    glVertex2f(X2, Y2);
  glEnd;
end;

procedure AGT_Window.DrawRect(const X, Y, AWidth, AHeight, AThickness: Single; const AColor: AGT_Color; const AAngle: Single);
var
  LHalfWidth, LHalfHeight: Single;
begin
  if not Assigned(FHandle) then Exit;

  LHalfWidth := AWidth / 2;
  LHalfHeight := AHeight / 2;

  glLineWidth(AThickness);
  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);

  glPushMatrix;  // Save the current matrix

  // Translate to the center point
  glTranslatef(X, Y, 0);

  // Rotate around the center
  glRotatef(AAngle, 0, 0, 1);

  glBegin(GL_LINE_LOOP);
    glVertex2f(-LHalfWidth, -LHalfHeight);      // Bottom-left corner
    glVertex2f(LHalfWidth, -LHalfHeight);       // Bottom-right corner
    glVertex2f(LHalfWidth, LHalfHeight);        // Top-right corner
    glVertex2f(-LHalfWidth, LHalfHeight);       // Top-left corner
  glEnd;

  glPopMatrix;  // Restore the original matrix
end;

procedure AGT_Window.DrawFilledRect(const X, Y, AWidth, AHeight: Single; const AColor: AGT_Color; const AAngle: Single);
var
  LHalfWidth, LHalfHeight: Single;
begin
  if not Assigned(FHandle) then Exit;

  LHalfWidth := AWidth / 2;
  LHalfHeight := AHeight / 2;

  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);

  glPushMatrix;  // Save the current matrix

  // Translate to the center point
  glTranslatef(X, Y, 0);

  // Rotate around the center
  glRotatef(AAngle, 0, 0, 1);

  glBegin(GL_QUADS);
    glVertex2f(-LHalfWidth, -LHalfHeight);      // Bottom-left corner
    glVertex2f(LHalfWidth, -LHalfHeight);       // Bottom-right corner
    glVertex2f(LHalfWidth, LHalfHeight);        // Top-right corner
    glVertex2f(-LHalfWidth, LHalfHeight);       // Top-left corner
  glEnd;

  glPopMatrix;  // Restore the original matrix
end;

procedure AGT_Window.DrawCircle(const X, Y, ARadius, AThickness: Single; const AColor: AGT_Color);
var
  I: Integer;
  LX, LY: Single;
begin
  if not Assigned(FHandle) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);
  glBegin(GL_LINE_LOOP);
    LX := X;
    LY := Y;
    for I := 0 to 360 do
    begin
      glVertex2f(LX + ARadius * AGT_Math.AngleCos(I), LY - ARadius * AGT_Math.AngleSin(I));
    end;
  glEnd();
end;

procedure AGT_Window.DrawFilledCircle(const X, Y, ARadius: Single; const AColor: AGT_Color);
var
  I: Integer;
  LX, LY: Single;
begin
  if not Assigned(FHandle) then Exit;

  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);
  glBegin(GL_TRIANGLE_FAN);
    LX := X;
    LY := Y;
    glVertex2f(LX, LY);
    for i := 0 to 360 do
    begin
      glVertex2f(LX + ARadius * AGT_Math.AngleCos(i), LY + ARadius * AGT_Math.AngleSin(i));
    end;
  glEnd();
end;

procedure AGT_Window.DrawTriangle(const X1, Y1, X2, Y2, X3, Y3, AThickness: Single; const AColor: AGT_Color);
begin
  if not Assigned(FHandle) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);
  glBegin(GL_LINE_LOOP);
    glVertex2f(X1, Y1);
    glVertex2f(X2, Y2);
    glVertex2f(X3, Y3);
  glEnd();
end;

procedure AGT_Window.DrawFilledTriangle(const X1, Y1, X2, Y2, X3, Y3: Single; const AColor: AGT_Color);
begin
  if not Assigned(FHandle) then Exit;

  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);
  glBegin(GL_TRIANGLES);
    glVertex2f(X1, Y1);
    glVertex2f(X2, Y2);
    glVertex2f(X3, Y3);
  glEnd();
end;

procedure AGT_Window.DrawPolygon(const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color);
var
  I: Integer;
  LPoint: PAGT_Point;
begin
  if not Assigned(FHandle) or (APoints = nil) or (ACount <= 0) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);
  glBegin(GL_LINE_LOOP);

  LPoint := APoints;
  for I := 0 to ACount - 1 do
  begin
    glVertex2f(LPoint.X, LPoint.Y);
    Inc(LPoint);
  end;

  glEnd();
end;

procedure AGT_Window.DrawFilledPolygon(const APoints: PAGT_Point; const ACount: UInt32; const AColor: AGT_Color);
var
  I: Integer;
  LPoint: PAGT_Point;
begin
  if not Assigned(FHandle) then Exit;

  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);
  glBegin(GL_POLYGON);

  LPoint := APoints;
  for I := 0 to ACount - 1 do
  begin
    glVertex2f(LPoint.X, LPoint.Y);
    Inc(LPoint);
  end;
  glEnd();
end;

procedure AGT_Window.DrawPolyline(const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color);
var
  I: Integer;
  LPoint: PAGT_Point;
begin
  if not Assigned(FHandle) then Exit;

  glLineWidth(AThickness);
  glColor4f(AColor.r, AColor.g, AColor.b, AColor.a);
  glBegin(GL_LINE_STRIP);

  LPoint := APoints;
  for I := 0 to ACount - 1 do
  begin
    glVertex2f(LPoint.X, LPoint.Y);
    Inc(LPoint);
  end;

  glEnd();
end;

procedure AGT_Window.ClearInput();
begin
  if not Assigned(FHandle) then Exit;
  FillChar(FKeyState, SizeOf(FKeyState), 0);
  FillChar(FMouseButtonState, SizeOf(FMouseButtonState), 0);
  FillChar(FGamepadButtonState, SizeOf(FGamepadButtonState), 0);
end;

function  AGT_Window.GetKey(const AKey: Integer; const AState: AGT_InputState): Boolean;

  function IsKeyPressed(const AKey: Integer): Boolean;
  begin
    Result :=  Boolean(glfwGetKey(FHandle, AKey) = GLFW_PRESS);
  end;

begin
  Result := False;

  if not Assigned(FHandle) then Exit;

  if not InRange(AKey,  AGT_KEY_SPACE, AGT_KEY_LAST) then Exit;

  case AState of
    AGT_isPressed:
    begin
      Result :=  IsKeyPressed(AKey);
    end;

    AGT_isWasPressed:
    begin
      if IsKeyPressed(AKey) and (not FKeyState[0, AKey]) then
      begin
        FKeyState[0, AKey] := True;
        Result := True;
      end
      else if (not IsKeyPressed(AKey)) and (FKeyState[0, AKey]) then
      begin
        FKeyState[0, AKey] := False;
        Result := False;
      end;
    end;

    AGT_isWasReleased:
    begin
      if IsKeyPressed(AKey) and (not FKeyState[0, AKey]) then
      begin
        FKeyState[0, AKey] := True;
        Result := False;
      end
      else if (not IsKeyPressed(AKey)) and (FKeyState[0, AKey]) then
      begin
        FKeyState[0, AKey] := False;
        Result := True;
      end;
    end;
  end;
end;

function  AGT_Window.GetMouseButton(const AButton: Byte; const AState: AGT_InputState): Boolean;

  function IsButtonPressed(const AKey: Integer): Boolean;
  begin
    Result :=  Boolean(glfwGetMouseButton(FHandle, AButton) = GLFW_PRESS);
  end;

begin
  Result := False;

  if not Assigned(FHandle) then Exit;
  if not InRange(AButton,  AGT_MOUSE_BUTTON_1, AGT_MOUSE_BUTTON_MIDDLE) then Exit;

  case AState of
    AGT_isPressed:
    begin
      Result :=  IsButtonPressed(AButton);
    end;

    AGT_isWasPressed:
    begin
      if IsButtonPressed(AButton) and (not FMouseButtonState[0, AButton]) then
      begin
        FMouseButtonState[0, AButton] := True;
        Result := True;
      end
      else if (not IsButtonPressed(AButton)) and (FMouseButtonState[0, AButton]) then
      begin
        FMouseButtonState[0, AButton] := False;
        Result := False;
      end;
    end;

    AGT_isWasReleased:
    begin
      if IsButtonPressed(AButton) and (not FMouseButtonState[0, AButton]) then
      begin
        FMouseButtonState[0, AButton] := True;
        Result := False;
      end
      else if (not IsButtonPressed(AButton)) and (FMouseButtonState[0, AButton]) then
      begin
        FMouseButtonState[0, AButton] := False;
        Result := True;
      end;
    end;
  end;
end;

procedure AGT_Window.GetMousePos(const X, Y: System.PSingle);
var
  LPos: AGT_Point;
begin
  if not Assigned(FHandle) then Exit;

  LPos := GetMousePos();

  if Assigned(X) then
    X^ := LPos.x;

  if Assigned(Y) then
    Y^ := LPos.y;
end;

function AGT_Window.GetMousePos(): AGT_Point;
var
  LMouseX, LMouseY: Double;
begin
  if not Assigned(FHandle) then Exit;

  glfwGetCursorPos(FHandle, @LMouseX, @LMouseY);
  Result := VirtualToScreen(LMouseX, LMouseY);
end;

procedure AGT_Window.SetMousePos(const X, Y: Single);
var
  LPos: AGT_Point;
begin
  if not Assigned(FHandle) then Exit;

  LPos := ScreenToVirtual(X, Y);
  glfwSetCursorPos(FHandle, LPos.X, LPos.y);
end;

function  AGT_Window.GetMouseWheel(): AGT_Vector;
begin
  Result := AGT_Math.Vector(0,0);
  if not Assigned(FHandle) then Exit;
  Result := FMouseWheel;
end;

function  AGT_Window.GamepadPresent(const AGamepad: Byte): Boolean;
begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  Result := Boolean(glfwJoystickIsGamepad(EnsureRange(AGamepad, AGT_GAMEPAD_1, AGT_GAMEPAD_LAST)));
end;

function  AGT_Window.GetGamepadName(const AGamepad: Byte): string;
begin
  Result := 'Not present';

  if not Assigned(FHandle) then Exit;
  if not GamepadPresent(AGamepad) then Exit;

  Result := string(glfwGetGamepadName(AGamepad));
end;

function  AGT_Window.GetGamepadButton(const AGamepad, AButton: Byte; const AState: AGT_InputState): Boolean;
var
  LState: GLFWgamepadstate;

  function IsButtonPressed(const AButton: Byte): Boolean;
  begin
    Result :=  Boolean(LState.buttons[AButton]);
  end;

begin
  Result := False;
  if not Assigned(FHandle) then Exit;

  if not Boolean(glfwGetGamepadState(EnsureRange(AGamepad, AGT_GAMEPAD_1, AGT_GAMEPAD_LAST), @LState)) then Exit;

  case AState of
    AGT_isPressed:
    begin
      Result :=  IsButtonPressed(AButton);
    end;

    AGT_isWasPressed:
    begin
      if IsButtonPressed(AButton) and (not FGamepadButtonState[0, AButton]) then
      begin
        FGamepadButtonState[0, AButton] := True;
        Result := True;
      end
      else if (not IsButtonPressed(AButton)) and (FGamepadButtonState[0, AButton]) then
      begin
        FGamepadButtonState[0, AButton] := False;
        Result := False;
      end;
    end;

    AGT_isWasReleased:
    begin
      if IsButtonPressed(AButton) and (not FGamepadButtonState[0, AButton]) then
      begin
        FGamepadButtonState[0, AButton] := True;
        Result := False;
      end
      else if (not IsButtonPressed(AButton)) and (FGamepadButtonState[0, AButton]) then
      begin
        FGamepadButtonState[0, AButton] := False;
        Result := True;
      end;
    end;
  end;
end;

function  AGT_Window.GetGamepadAxisValue(const AGamepad, AAxis: Byte): Single;
var
  LState: GLFWgamepadstate;
begin
  Result := 0;
  if not Assigned(FHandle) then Exit;

  if not Boolean(glfwGetGamepadState(EnsureRange(AGamepad, AGT_GAMEPAD_1, AGT_GAMEPAD_LAST), @LState)) then Exit;
  Result := LState.axes[EnsureRange(AAxis, AGT_GAMEPAD_AXIS_LEFT_X, GLFW_GAMEPAD_AXIS_LAST)];
end;

function  AGT_Window.VirtualToScreen(const X, Y: Single): AGT_Point;
var
  LWindowWidth, LWindowHeight: Integer;
  LScreenX, LScreenY: Double;
  LVirtualScreenX, LVirtualScreenY: Double;
  LScaleX, LScaleY, LDpiScaleX, LDpiScaleY: Single;
  LViewportOffsetX, LViewportOffsetY: Double;
begin
  Result.x := 0;
  Result.y := 0;
  if not Assigned(FHandle) then Exit;

  // Get the actual window size
  glfwGetWindowSize(FHandle, @LWindowWidth, @LWindowHeight);

  // Get the DPI scaling factors (from glfwGetWindowContentScale)
  glfwGetWindowContentScale(FHandle, @LDpiScaleX, @LDpiScaleY);

  // Safety check to avoid invalid DPI scale values
  if (LDpiScaleX = 0) or (LDpiScaleY = 0) then
  begin
    LDpiScaleX := 1.0; // Default to 1.0 if invalid DPI scale is retrieved
    LDpiScaleY := 1.0;
  end;

  // Adjust window size by DPI scaling
  LWindowWidth := Trunc(LWindowWidth / LDpiScaleX);
  LWindowHeight := Trunc(LWindowHeight / LDpiScaleY);

  // Calculate the scaling factors for X and Y axes
  LScaleX := FVirtualSize.w / FViewport.size.w;  // Scale based on viewport width
  LScaleY := FVirtualSize.h / FViewport.size.h;  // Scale based on viewport height

  // Get the screen position
  LScreenX := X;
  LScreenY := Y;

  // Calculate the viewport offset
  LViewportOffsetX := FViewport.pos.x;
  LViewportOffsetY := FViewport.pos.y;

  // Adjust the mouse position by subtracting the viewport offset
  LScreenX := LScreenX - LViewportOffsetX;
  LScreenY := LScreenY - LViewportOffsetY;

  // Convert the adjusted mouse position to virtual coordinates
  LVirtualScreenX := LScreenX * LScaleX;
  LVirtualScreenY := LScreenY * LScaleY;

  // Clamp the virtual mouse position within the virtual resolution
  Result.x := EnsureRange(LVirtualScreenX, 0, FVirtualSize.w - 1);
  Result.y := EnsureRange(LVirtualScreenY, 0, FVirtualSize.h - 1);
end;

function  AGT_Window.ScreenToVirtual(const X, Y: Single): AGT_Point;
var
  LScreenX, LScreenY: Double;
  LScaleX, LScaleY: Single;
  LViewportOffsetX, LViewportOffsetY: Double;
begin
  Result.x := 0;
  Result.y := 0;
  if not Assigned(FHandle) then Exit;

  // Calculate the scaling factors (consistent with GetMousePos)
  LScaleX := FVirtualSize.w / FViewport.size.w;
  LScaleY := FVirtualSize.h / FViewport.size.h;

  // Calculate the viewport offsets
  LViewportOffsetX := FViewport.pos.x;
  LViewportOffsetY := FViewport.pos.y;

  // Convert virtual coordinates to adjusted screen position
  LScreenX := (X / LScaleX) + LViewportOffsetX;
  LScreenY := (Y / LScaleY) + LViewportOffsetY;

  // Return the virtual screen position
  Result.x := LScreenX;
  Result.y := LScreenY;
end;

procedure AGT_Window.StartTiming();
begin
  FTiming.CurrentTime := glfwGetTime();
  FTiming.ElapsedTime := FTiming.CurrentTime - FTiming.LastTime;
end;


procedure AGT_Window.StopTiming();
begin
  Inc(FTiming.FrameCount);
  if (FTiming.CurrentTime - FTiming.LastFPSTime >= 1.0) then
  begin
    FTiming.Framerate := FTiming.FrameCount;
    FTiming.LastFPSTime := FTiming.CurrentTime;
    FTiming.FrameCount := 0;
  end;

  // Calculate delta time
  FTiming.DeltaTime := FTiming.CurrentTime - FTiming.LastTime;

  FTiming.LastTime := FTiming.CurrentTime;
  FTiming.RemainingTime := FTiming.TargetTime - (FTiming.CurrentTime - FTiming.LastTime);
  if (FTiming.RemainingTime > 0) then
   begin
      FTiming.Endtime := FTiming.CurrentTime + FTiming.RemainingTime;
      while glfwGetTime() < FTiming.Endtime do
      begin
        // Busy-wait for the remaining time
        Sleep(0); // allow other background tasks to run
      end;
    end;
end;

procedure AGT_Window.SetTargetFrameRate(const ATargetFrameRate: UInt32);
begin
  FTiming.LastTime := glfwGetTime();
  FTiming.LastFPSTime := FTiming.LastTime;
  FTiming.TargetFrameRate := ATargetFrameRate;
  FTiming.TargetTime := 1.0 / FTiming.TargetFrameRate;
  FTiming.FrameCount := 0;
  FTiming.Framerate :=0;
  FTiming.Endtime := 0;
end;

function  AGT_Window.GetTargetFrameRate(): UInt32;
begin
  Result := FTiming.TargetFrameRate;
end;

function  AGT_Window.GetTargetTime(): Double;
begin
  Result := FTiming.TargetTime;
end;

procedure AGT_Window.ResetTiming();
begin
  FTiming.LastTime := glfwGetTime();
  FTiming.LastFPSTime := FTiming.LastTime;
  FTiming.TargetTime := 1.0 / FTiming.TargetFrameRate;
  FTiming.FrameCount := 0;
  FTiming.Framerate :=0;
  FTiming.Endtime := 0;
end;

function  AGT_Window.GetFrameRate(): UInt32;
begin
  Result := FTiming.Framerate;
end;

function  AGT_Window.GetDeltaTime(): Double;
begin
  Result := FTiming.DeltaTime;
end;

class function  AGT_Window.Init(const ATitle: string; const AVirtualWidth: Cardinal=AGT_DEFAULT_WINDOW_WIDTH; const AVirtualHeight: Cardinal=AGT_DEFAULT_WINDOW_HEIGHT; const AParent: NativeUInt=0): AGT_Window;
begin
  Result := AGT_Window.Create();
  if not Result.Open(ATitle, AVirtualWidth, AVirtualHeight, AParent) then
  begin
    Result.Free();
    Result := nil;
  end;
end;

end.
