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

unit Aurora.Console;

{$I Aurora.Defines.inc}

interface

uses
  WinApi.Windows,
  WinApi.Messages,
  System.SysUtils,
  Aurora.CLibs,
  Aurora.Utils,
  Aurora.Math;

const
  AGT_LF   = AnsiChar(#10);
  AGT_CR   = AnsiChar(#13);
  AGT_CRLF = AGT_LF+AGT_CR;
  AGT_ESC  = AnsiChar(#27);

  AGT_VK_ESC = 27;

  // Cursor Movement
  AGT_CSICursorPos = AGT_ESC + '[%d;%dH';         // Set cursor position
  AGT_CSICursorUp = AGT_ESC + '[%dA';             // Move cursor up
  AGT_CSICursorDown = AGT_ESC + '[%dB';           // Move cursor down
  AGT_CSICursorForward = AGT_ESC + '[%dC';        // Move cursor forward
  AGT_CSICursorBack = AGT_ESC + '[%dD';           // Move cursor backward
  AGT_CSISaveCursorPos = AGT_ESC + '[s';          // Save cursor position
  AGT_CSIRestoreCursorPos = AGT_ESC + '[u';       // Restore cursor position

  // Cursor Visibility
  AGT_CSIShowCursor = AGT_ESC + '[?25h';          // Show cursor
  AGT_CSIHideCursor = AGT_ESC + '[?25l';          // Hide cursor
  AGT_CSIBlinkCursor = AGT_ESC + '[?12h';         // Enable cursor blinking
  AGT_CSISteadyCursor = AGT_ESC + '[?12l';        // Disable cursor blinking

  // Screen Manipulation
  AGT_CSIClearScreen = AGT_ESC + '[2J';           // Clear screen
  AGT_CSIClearLine = AGT_ESC + '[2K';             // Clear line
  AGT_CSIScrollUp = AGT_ESC + '[%dS';             // Scroll up by n lines
  AGT_CSIScrollDown = AGT_ESC + '[%dT';           // Scroll down by n lines

  // Text Formatting
  AGT_CSIBold = AGT_ESC + '[1m';                  // Bold text
  AGT_CSIUnderline = AGT_ESC + '[4m';             // Underline text
  AGT_CSIResetFormat = AGT_ESC + '[0m';           // Reset text formatting
  AGT_CSIResetBackground = #27'[49m';         // Reset background text formatting
  AGT_CSIResetForeground = #27'[39m';         // Reset forground text formatting
  AGT_CSIInvertColors = AGT_ESC + '[7m';          // Invert foreground/background
  AGT_CSINormalColors = AGT_ESC + '[27m';         // Normal colors

  AGT_CSIDim = AGT_ESC + '[2m';
  AGT_CSIItalic = AGT_ESC + '[3m';
  AGT_CSIBlink = AGT_ESC + '[5m';
  AGT_CSIFramed = AGT_ESC + '[51m';
  AGT_CSIEncircled = AGT_ESC + '[52m';

  // Text Modification
  AGT_CSIInsertChar = AGT_ESC + '[%d@';           // Insert n spaces at cursor position
  AGT_CSIDeleteChar = AGT_ESC + '[%dP';           // Delete n characters at cursor position
  AGT_CSIEraseChar = AGT_ESC + '[%dX';            // Erase n characters at cursor position

  // Colors (Foreground and Background)
  AGT_CSIFGBlack = AGT_ESC + '[30m';
  AGT_CSIFGRed = AGT_ESC + '[31m';
  AGT_CSIFGGreen = AGT_ESC + '[32m';
  AGT_CSIFGYellow = AGT_ESC + '[33m';
  AGT_CSIFGBlue = AGT_ESC + '[34m';
  AGT_CSIFGMagenta = AGT_ESC + '[35m';
  AGT_CSIFGCyan = AGT_ESC + '[36m';
  AGT_CSIFGWhite = AGT_ESC + '[37m';

  AGT_CSIBGBlack = AGT_ESC + '[40m';
  AGT_CSIBGRed = AGT_ESC + '[41m';
  AGT_CSIBGGreen = AGT_ESC + '[42m';
  AGT_CSIBGYellow = AGT_ESC + '[43m';
  AGT_CSIBGBlue = AGT_ESC + '[44m';
  AGT_CSIBGMagenta = AGT_ESC + '[45m';
  AGT_CSIBGCyan = AGT_ESC + '[46m';
  AGT_CSIBGWhite = AGT_ESC + '[47m';

  AGT_CSIFGBrightBlack = AGT_ESC + '[90m';
  AGT_CSIFGBrightRed = AGT_ESC + '[91m';
  AGT_CSIFGBrightGreen = AGT_ESC + '[92m';
  AGT_CSIFGBrightYellow = AGT_ESC + '[93m';
  AGT_CSIFGBrightBlue = AGT_ESC + '[94m';
  AGT_CSIFGBrightMagenta = AGT_ESC + '[95m';
  AGT_CSIFGBrightCyan = AGT_ESC + '[96m';
  AGT_CSIFGBrightWhite = AGT_ESC + '[97m';

  AGT_CSIBGBrightBlack = AGT_ESC + '[100m';
  AGT_CSIBGBrightRed = AGT_ESC + '[101m';
  AGT_CSIBGBrightGreen = AGT_ESC + '[102m';
  AGT_CSIBGBrightYellow = AGT_ESC + '[103m';
  AGT_CSIBGBrightBlue = AGT_ESC + '[104m';
  AGT_CSIBGBrightMagenta = AGT_ESC + '[105m';
  AGT_CSIBGBrightCyan = AGT_ESC + '[106m';
  AGT_CSIBGBrightWhite = AGT_ESC + '[107m';

  AGT_CSIFGRGB = AGT_ESC + '[38;2;%d;%d;%dm';        // Foreground RGB
  AGT_CSIBGRGB = AGT_ESC + '[48;2;%d;%d;%dm';        // Backg

type
  { AGT_CharSet }
  AGT_CharSet = set of AnsiChar;

  { AGT_Console }
  AGT_Console = class
  private class var
    FInputCodePage: Cardinal;
    FOutputCodePage: Cardinal;
    FTeletypeDelay: Integer;
    FKeyState: array [0..1, 0..255] of Boolean;
  private
    class constructor Create();
    class destructor Destroy();
  public
    class procedure UnitInit();
    class procedure Print(const AMsg: string); overload; static;
    class procedure PrintLn(const AMsg: string); overload; static;

    class procedure Print(const AMsg: string; const AArgs: array of const); overload; static;
    class procedure PrintLn(const AMsg: string; const AArgs: array of const); overload; static;

    class procedure Print(); overload; static;
    class procedure PrintLn(); overload; static;

    class procedure GetCursorPos(X, Y: PInteger); static;
    class procedure SetCursorPos(const X, Y: Integer); static;
    class procedure SetCursorVisible(const AVisible: Boolean); static;
    class procedure HideCursor(); static;
    class procedure ShowCursor(); static;
    class procedure SaveCursorPos(); static;
    class procedure RestoreCursorPos(); static;
    class procedure MoveCursorUp(const ALines: Integer); static;
    class procedure MoveCursorDown(const ALines: Integer); static;
    class procedure MoveCursorForward(const ACols: Integer); static;
    class procedure MoveCursorBack(const ACols: Integer); static;

    class procedure ClearScreen(); static;
    class procedure ClearLine(); static;
    class procedure ClearLineFromCursor(const AColor: string); static;

    class procedure SetBoldText(); static;
    class procedure ResetTextFormat(); static;
    class procedure SetForegroundColor(const AColor: string); static;
    class procedure SetBackgroundColor(const AColor: string); static;
    class procedure SetForegroundRGB(const ARed, AGreen, ABlue: Byte); static;
    class procedure SetBackgroundRGB(const ARed, AGreen, ABlue: Byte); static;

    class procedure GetSize(AWidth: PInteger; AHeight: PInteger); static;

    class procedure SetTitle(const ATitle: string); static;
    class function  GetTitle(): string; static;

    class function  HasOutput(): Boolean; static;
    class function  WasRunFrom(): Boolean; static;
    class procedure WaitForAnyKey(); static;
    class function  AnyKeyPressed(): Boolean; static;

    class procedure ClearKeyStates(); static;
    class procedure ClearKeyboardBuffer(); static;

    class function  IsKeyPressed(AKey: Byte): Boolean; static;
    class function  WasKeyReleased(AKey: Byte): Boolean; static;
    class function  WasKeyPressed(AKey: Byte): Boolean; static;

    class function  ReadKey(): WideChar; static;
    class function  ReadLnX(const AAllowedChars: AGT_CharSet; AMaxLength: Integer; const AColor: string=AGT_CSIFGWhite): string; static;

    class procedure Pause(const AForcePause: Boolean=False; AColor: string=AGT_CSIFGWhite; const AMsg: string=''); static;

    class function  WrapTextEx(const ALine: string; AMaxCol: Integer; const ABreakChars: AGT_CharSet=[' ', '-', ',', ':', #9]): string; static;
    class procedure Teletype(const AText: string; const AColor: string=AGT_CSIFGWhite; const AMargin: Integer=10; const AMinDelay: Integer=0; const AMaxDelay: Integer=3; const ABreakKey: Byte=VK_ESCAPE); static;
  end;

//=== EXPORTS ===============================================================
procedure AGT_Console_Print(const AText: PWideChar); cdecl; exports AGT_Console_Print;
procedure AGT_Console_PrintLn(const AText: PWideChar); cdecl; exports AGT_Console_PrintLn;
procedure AGT_Console_GetCursorPos(X, Y: PInteger); cdecl; exports AGT_Console_GetCursorPos;
procedure AGT_Console_SetCursorPos(const X, Y: Integer); cdecl; exports AGT_Console_SetCursorPos;
procedure AGT_Console_SetCursorVisible(const AVisible: Boolean); cdecl; exports AGT_Console_SetCursorVisible;
procedure AGT_Console_HideCursor(); cdecl; exports AGT_Console_HideCursor;
procedure AGT_Console_ShowCursor(); cdecl; exports AGT_Console_ShowCursor;
procedure AGT_Console_SaveCursorPos(); cdecl; exports AGT_Console_SaveCursorPos;
procedure AGT_Console_RestoreCursorPos(); cdecl; exports AGT_Console_RestoreCursorPos;
procedure AGT_Console_MoveCursorUp(const ALines: Integer); cdecl; exports AGT_Console_MoveCursorUp;
procedure AGT_Console_MoveCursorDown(const ALines: Integer); cdecl; exports AGT_Console_MoveCursorDown;
procedure AGT_Console_MoveCursorForward(const ACols: Integer); cdecl; exports AGT_Console_MoveCursorForward;
procedure AGT_Console_MoveCursorBack(const ACols: Integer); cdecl; exports AGT_Console_MoveCursorBack;
procedure AGT_Console_ClearScreen(); cdecl; exports AGT_Console_ClearScreen;
procedure AGT_Console_ClearLine(); cdecl; exports AGT_Console_ClearLine;
procedure AGT_Console_ClearLineFromCursor(const AColor: PWideChar); cdecl; exports AGT_Console_ClearLineFromCursor;
procedure AGT_Console_SetBoldText(); cdecl; exports AGT_Console_SetBoldText;
procedure AGT_Console_ResetTextFormat(); cdecl; exports AGT_Console_ResetTextFormat;
procedure AGT_Console_SetForegroundColor(const AColor: PWideChar); cdecl; exports AGT_Console_SetForegroundColor;
procedure AGT_Console_SetBackgroundColor(const AColor: PWideChar); cdecl; exports AGT_Console_SetBackgroundColor;
procedure AGT_Console_SetForegroundRGB(const ARed, AGreen, ABlue: Byte); cdecl; exports AGT_Console_SetForegroundRGB;
procedure AGT_Console_SetBackgroundRGB(const ARed, AGreen, ABlue: Byte); cdecl; exports AGT_Console_SetBackgroundRGB;
procedure AGT_Console_GetSize(AWidth: PInteger; AHeight: PInteger); cdecl; exports AGT_Console_GetSize;
procedure AGT_Console_SetTitle(const ATitle: PWideChar); cdecl; exports AGT_Console_SetTitle;
function  AGT_Console_GetTitle(): PWideChar; cdecl; exports AGT_Console_GetTitle;
function  AGT_Console_HasOutput(): Boolean; cdecl; exports AGT_Console_HasOutput;
function  AGT_Console_WasRunFrom(): Boolean; cdecl; exports AGT_Console_WasRunFrom;
procedure AGT_Console_WaitForAnyKey(); cdecl; exports AGT_Console_WaitForAnyKey;
function  AGT_Console_AnyKeyPressed(): Boolean; cdecl; exports AGT_Console_AnyKeyPressed;
procedure AGT_Console_ClearKeyStates(); cdecl; exports AGT_Console_ClearKeyStates;
procedure AGT_Console_ClearKeyboardBuffer(); cdecl; exports AGT_Console_ClearKeyboardBuffer;
function  AGT_Console_IsKeyPressed(AKey: Byte): Boolean; cdecl; exports AGT_Console_IsKeyPressed;
function  AGT_Console_WasKeyReleased(AKey: Byte): Boolean; cdecl; exports AGT_Console_WasKeyReleased;
function  AGT_Console_WasKeyPressed(AKey: Byte): Boolean; cdecl; exports AGT_Console_WasKeyPressed;
function  AGT_Console_ReadKey(): WideChar; cdecl; exports AGT_Console_ReadKey;
procedure AGT_Console_Pause(); cdecl; exports AGT_Console_Pause;
procedure AGT_Console_PauseEx(const AForcePause: Boolean; AColor: PWideChar; const AMsg: PWideChar); cdecl; exports AGT_Console_PauseEx;

implementation

//=== EXPORTS ===============================================================
procedure AGT_Console_Print(const AText: PWideChar);
begin
  AGT_Console.Print(string(AText));
end;

procedure AGT_Console_PrintLn(const AText: PWideChar);
begin
  AGT_Console.PrintLn(string(AText));
end;

procedure AGT_Console_GetCursorPos(X, Y: PInteger);
begin
  AGT_Console.GetCursorPos(X, Y);
end;

procedure AGT_Console_SetCursorPos(const X, Y: Integer);
begin
  AGT_Console.SetCursorPos(X, Y);
end;

procedure AGT_Console_SetCursorVisible(const AVisible: Boolean);
begin
  AGT_Console.SetCursorVisible(AVisible);
end;

procedure AGT_Console_HideCursor();
begin
  AGT_Console.HideCursor();
end;

procedure AGT_Console_ShowCursor();
begin
  AGT_Console.ShowCursor();
end;

procedure AGT_Console_SaveCursorPos();
begin
  AGT_Console.SaveCursorPos();
end;

procedure AGT_Console_RestoreCursorPos();
begin
  AGT_Console.RestoreCursorPos();
end;

procedure AGT_Console_MoveCursorUp(const ALines: Integer);
begin
  AGT_Console.MoveCursorUp(ALines);
end;

procedure AGT_Console_MoveCursorDown(const ALines: Integer);
begin
  AGT_Console.MoveCursorDown(ALines);
end;

procedure AGT_Console_MoveCursorForward(const ACols: Integer);
begin
  AGT_Console.MoveCursorForward(ACols);
end;

procedure AGT_Console_MoveCursorBack(const ACols: Integer);
begin
  AGT_Console.MoveCursorBack(ACols);
end;

procedure AGT_Console_ClearScreen();
begin
  AGT_Console.ClearScreen();
end;

procedure AGT_Console_ClearLine();
begin
  AGT_Console.ClearLine();
end;

procedure AGT_Console_ClearLineFromCursor(const AColor: PWideChar);
begin
  AGT_Console.ClearLineFromCursor(string(AColor));
end;

procedure AGT_Console_SetBoldText();
begin
  AGT_Console.SetBoldText();
end;

procedure AGT_Console_ResetTextFormat();
begin
  AGT_Console.ResetTextFormat();
end;

procedure AGT_Console_SetForegroundColor(const AColor: PWideChar);
begin
  AGT_Console.SetForegroundColor(string(AColor));
end;

procedure AGT_Console_SetBackgroundColor(const AColor: PWideChar);
begin
  AGT_Console.SetBackgroundColor(string(AColor));
end;

procedure AGT_Console_SetForegroundRGB(const ARed, AGreen, ABlue: Byte);
begin
  AGT_Console.SetForegroundRGB(ARed, AGreen, ABlue);
end;

procedure AGT_Console_SetBackgroundRGB(const ARed, AGreen, ABlue: Byte);
begin
  AGT_Console.SetBackgroundRGB(ARed, AGreen, ABlue);
end;

procedure AGT_Console_GetSize(AWidth: PInteger; AHeight: PInteger);
begin
  AGT_Console.GetSize(AWidth, AHeight);
end;

procedure AGT_Console_SetTitle(const ATitle: PWideChar);
begin
  AGT_Console.SetTitle(string(ATitle));
end;

function  AGT_Console_GetTitle(): PWideChar;
begin
  Result := PWideChar(AGT_Console.GetTitle());
end;

function  AGT_Console_HasOutput(): Boolean;
begin
  Result := AGT_Console.HasOutput();
end;

function  AGT_Console_WasRunFrom(): Boolean;
begin
  Result := AGT_Console.WasRunFrom();
end;

procedure AGT_Console_WaitForAnyKey();
begin
  AGT_Console.WaitForAnyKey();
end;

function  AGT_Console_AnyKeyPressed(): Boolean;
begin
  Result := AGT_Console.AnyKeyPressed();
end;

procedure AGT_Console_ClearKeyStates();
begin
  AGT_Console.ClearKeyStates();
end;

procedure AGT_Console_ClearKeyboardBuffer();
begin
  AGT_Console.ClearKeyboardBuffer();
end;

function  AGT_Console_IsKeyPressed(AKey: Byte): Boolean;
begin
  Result := AGT_Console.IsKeyPressed(AKey);
end;

function  AGT_Console_WasKeyReleased(AKey: Byte): Boolean;
begin
  Result := AGT_Console.WasKeyReleased(AKey);
end;

function  AGT_Console_WasKeyPressed(AKey: Byte): Boolean;
begin
  Result := AGT_Console.WasKeyPressed(AKey);
end;

function  AGT_Console_ReadKey(): WideChar;
begin
  Result := AGT_Console.ReadKey();
end;

procedure AGT_Console_Pause();
begin
  AGT_Console.Pause();
end;

procedure AGT_Console_PauseEx(const AForcePause: Boolean; AColor: PWideChar; const AMsg: PWideChar);
begin
  AGT_Console.Pause(AForcePause, string(AColor), string(AMsg));
end;

{ AGT_Console }
class constructor AGT_Console.Create();
begin
  FTeletypeDelay := 0;

  // save current console codepage
  FInputCodePage := GetConsoleCP();
  FOutputCodePage := GetConsoleOutputCP();

  // set code page to UTF8
  SetConsoleCP(CP_UTF8);
  SetConsoleOutputCP(CP_UTF8);

  AGT_Utils.EnableVirtualTerminalProcessing();
end;

class destructor AGT_Console.Destroy();
begin
  // restore code page
  SetConsoleCP(FInputCodePage);
  SetConsoleOutputCP(FOutputCodePage);
end;

class procedure AGT_Console.UnitInit();
begin
end;

class procedure AGT_Console.Print(const AMsg: string);
begin
  if not HasOutput() then Exit;
  Write(AMsg+AGT_CSIResetFormat);
end;

class procedure AGT_Console.PrintLn(const AMsg: string);
begin
  if not HasOutput() then Exit;
  WriteLn(AMsg+AGT_CSIResetFormat);
end;

class procedure AGT_Console.Print(const AMsg: string; const AArgs: array of const);
begin
  if not HasOutput() then Exit;
  Write(Format(AMsg, AArgs)+AGT_CSIResetFormat);
end;

class procedure AGT_Console.PrintLn(const AMsg: string; const AArgs: array of const);
begin
  if not HasOutput() then Exit;
  WriteLn(Format(AMsg, AArgs)+AGT_CSIResetFormat);
end;

class procedure AGT_Console.Print();
begin
  if not HasOutput() then Exit;
  Write(AGT_CSIResetFormat);
end;

class procedure AGT_Console.PrintLn();
begin
  if not HasOutput() then Exit;
  WriteLn(AGT_CSIResetFormat);
end;

class procedure AGT_Console.GetCursorPos(X, Y: PInteger);
var
  hConsole: THandle;
  BufferInfo: TConsoleScreenBufferInfo;
begin
  hConsole := GetStdHandle(STD_OUTPUT_HANDLE);
  if hConsole = INVALID_HANDLE_VALUE then
    Exit;

  if not GetConsoleScreenBufferInfo(hConsole, BufferInfo) then
    Exit;

  if Assigned(X) then
    X^ := BufferInfo.dwCursorPosition.X;
  if Assigned(Y) then
    Y^ := BufferInfo.dwCursorPosition.Y;
end;

class procedure AGT_Console.SetCursorPos(const X, Y: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(AGT_CSICursorPos, [X, Y]));
end;

class procedure AGT_Console.SetCursorVisible(const AVisible: Boolean);
var
  ConsoleInfo: TConsoleCursorInfo;
  ConsoleHandle: THandle;
begin
  ConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  ConsoleInfo.dwSize := 25; // You can adjust cursor size if needed
  ConsoleInfo.bVisible := AVisible;
  SetConsoleCursorInfo(ConsoleHandle, ConsoleInfo);
end;

class procedure AGT_Console.HideCursor();
begin
  if not HasOutput() then Exit;
  Write(AGT_CSIHideCursor);
end;

class procedure AGT_Console.ShowCursor();
begin
  if not HasOutput() then Exit;
  Write(AGT_CSIShowCursor);
end;

class procedure AGT_Console.SaveCursorPos();
begin
  if not HasOutput() then Exit;
  Write(AGT_CSISaveCursorPos);
end;

class procedure AGT_Console.RestoreCursorPos();
begin
  if not HasOutput() then Exit;
  Write(AGT_CSIRestoreCursorPos);
end;

class procedure AGT_Console.MoveCursorUp(const ALines: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(AGT_CSICursorUp, [ALines]));
end;

class procedure AGT_Console.MoveCursorDown(const ALines: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(AGT_CSICursorDown, [ALines]));
end;

class procedure AGT_Console.MoveCursorForward(const ACols: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(AGT_CSICursorForward, [ACols]));
end;

class procedure AGT_Console.MoveCursorBack(const ACols: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(AGT_CSICursorBack, [ACols]));
end;

class procedure AGT_Console.ClearScreen();
begin
  if not HasOutput() then Exit;
  Write(AGT_CSIClearScreen);
  SetCursorPos(0, 0);
end;

class procedure AGT_Console.ClearLine();
begin
  if not HasOutput() then Exit;
  Write(AGT_CSIClearLine);
end;

class procedure AGT_Console.ClearLineFromCursor(const AColor: string);
var
  LConsoleOutput: THandle;
  LConsoleInfo: TConsoleScreenBufferInfo;
  LNumCharsWritten: DWORD;
  LCoord: TCoord;
begin
  LConsoleOutput := GetStdHandle(STD_OUTPUT_HANDLE);

  if GetConsoleScreenBufferInfo(LConsoleOutput, LConsoleInfo) then
  begin
    LCoord.X := 0;
    LCoord.Y := LConsoleInfo.dwCursorPosition.Y;

    Print(AColor, []);
    FillConsoleOutputCharacter(LConsoleOutput, ' ', LConsoleInfo.dwSize.X
      - LConsoleInfo.dwCursorPosition.X, LCoord, LNumCharsWritten);
    SetConsoleCursorPosition(LConsoleOutput, LCoord);
  end;
end;

class procedure AGT_Console.SetBoldText();
begin
  if not HasOutput() then Exit;
  Write(AGT_CSIBold);
end;

class procedure AGT_Console.ResetTextFormat();
begin
  if not HasOutput() then Exit;
  Write(AGT_CSIResetFormat);
end;

class procedure AGT_Console.SetForegroundColor(const AColor: string);
begin
  if not HasOutput() then Exit;
  Write(AColor);
end;

class procedure AGT_Console.SetBackgroundColor(const AColor: string);
begin
  if not HasOutput() then Exit;
  Write(AColor);
end;

class procedure AGT_Console.SetForegroundRGB(const ARed, AGreen, ABlue: Byte);
begin
  if not HasOutput() then Exit;
  Write(Format(AGT_CSIFGRGB, [ARed, AGreen, ABlue]));
end;

class procedure AGT_Console.SetBackgroundRGB(const ARed, AGreen, ABlue: Byte);
begin
  if not HasOutput() then Exit;
  Write(Format(AGT_CSIBGRGB, [ARed, AGreen, ABlue]));
end;

class procedure AGT_Console.GetSize(AWidth: PInteger; AHeight: PInteger);
var
  LConsoleInfo: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), LConsoleInfo);
  if Assigned(AWidth) then
    AWidth^ := LConsoleInfo.dwSize.X;

  if Assigned(AHeight) then
  AHeight^ := LConsoleInfo.dwSize.Y;
end;

class procedure AGT_Console.SetTitle(const ATitle: string);
begin
  WinApi.Windows.SetConsoleTitle(PChar(ATitle));
end;

class function  AGT_Console.GetTitle(): string;
const
  MAX_TITLE_LENGTH = 1024;
var
  LTitle: array[0..MAX_TITLE_LENGTH] of WideChar;
  LTitleLength: DWORD;
begin
  // Get the console title and store it in LTitle
  LTitleLength := GetConsoleTitleW(LTitle, MAX_TITLE_LENGTH);

  // If the title is retrieved, assign it to the result
  if LTitleLength > 0 then
    Result := string(LTitle)
  else
    Result := '';
end;

class function  AGT_Console.HasOutput(): Boolean;
var
  LStdHandle: THandle;
begin
  LStdHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  Result := (LStdHandle <> INVALID_HANDLE_VALUE) and
            (GetFileType(LStdHandle) = FILE_TYPE_CHAR);
end;

class function  AGT_Console.WasRunFrom(): Boolean;
var
  LStartupInfo: TStartupInfo;
begin
  LStartupInfo.cb := SizeOf(TStartupInfo);
  GetStartupInfo(LStartupInfo);
  Result := ((LStartupInfo.dwFlags and STARTF_USESHOWWINDOW) = 0);
end;

class procedure AGT_Console.WaitForAnyKey();
var
  LInputRec: TInputRecord;
  LNumRead: Cardinal;
  LOldMode: DWORD;
  LStdIn: THandle;
begin
  LStdIn := GetStdHandle(STD_INPUT_HANDLE);
  GetConsoleMode(LStdIn, LOldMode);
  SetConsoleMode(LStdIn, 0);
  repeat
    ReadConsoleInput(LStdIn, LInputRec, 1, LNumRead);
  until (LInputRec.EventType and KEY_EVENT <> 0) and
    LInputRec.Event.KeyEvent.bKeyDown;
  SetConsoleMode(LStdIn, LOldMode);
end;

class function  AGT_Console.AnyKeyPressed(): Boolean;
var
  LNumberOfEvents     : DWORD;
  LBuffer             : TInputRecord;
  LNumberOfEventsRead : DWORD;
  LStdHandle           : THandle;
begin
  Result:=false;
  //get the console handle
  LStdHandle := GetStdHandle(STD_INPUT_HANDLE);
  LNumberOfEvents:=0;
  //get the number of events
  GetNumberOfConsoleInputEvents(LStdHandle,LNumberOfEvents);
  if LNumberOfEvents<> 0 then
  begin
    //retrieve the event
    PeekConsoleInput(LStdHandle,LBuffer,1,LNumberOfEventsRead);
    if LNumberOfEventsRead <> 0 then
    begin
      if LBuffer.EventType = KEY_EVENT then //is a Keyboard event?
      begin
        if LBuffer.Event.KeyEvent.bKeyDown then //the key was pressed?
          Result:=true
        else
          FlushConsoleInputBuffer(LStdHandle); //flush the buffer
      end
      else
      FlushConsoleInputBuffer(LStdHandle);//flush the buffer
    end;
  end;
end;

class procedure AGT_Console.ClearKeyStates();
begin
  FillChar(FKeyState, SizeOf(FKeyState), 0);
  ClearKeyboardBuffer();
end;

class procedure AGT_Console.ClearKeyboardBuffer();
var
  LInputRecord: TInputRecord;
  LEventsRead: DWORD;
  LMsg: TMsg;
begin
  while PeekConsoleInput(GetStdHandle(STD_INPUT_HANDLE), LInputRecord, 1, LEventsRead) and (LEventsRead > 0) do
  begin
    ReadConsoleInput(GetStdHandle(STD_INPUT_HANDLE), LInputRecord, 1, LEventsRead);
  end;

  while PeekMessage(LMsg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE) do
  begin
    // No operation; just removing messages from the queue
  end;
end;

class function  AGT_Console.IsKeyPressed(AKey: Byte): Boolean;
begin
  Result := (GetAsyncKeyState(AKey) and $8000) <> 0;
end;

class function  AGT_Console.WasKeyReleased(AKey: Byte): Boolean;
begin
  Result := False;
  if IsKeyPressed(AKey) and (not FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := True;
    Result := True;
  end
  else if (not IsKeyPressed(AKey)) and (FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := False;
    Result := False;
  end;
end;

class function  AGT_Console.WasKeyPressed(AKey: Byte): Boolean;
begin
  Result := False;
  if IsKeyPressed(AKey) and (not FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := True;
    Result := False;
  end
  else if (not IsKeyPressed(AKey)) and (FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := False;
    Result := True;
  end;
end;

class function  AGT_Console.ReadKey(): WideChar;
var
  LInputRecord: TInputRecord;
  LEventsRead: DWORD;
begin
  repeat
    ReadConsoleInput(GetStdHandle(STD_INPUT_HANDLE), LInputRecord, 1, LEventsRead);
  until (LInputRecord.EventType = KEY_EVENT) and LInputRecord.Event.KeyEvent.bKeyDown;
  Result := LInputRecord.Event.KeyEvent.UnicodeChar;
end;

class function  AGT_Console.ReadLnX(const AAllowedChars: AGT_CharSet; AMaxLength: Integer; const AColor: string): string;
var
  LInputChar: Char;
begin
  Result := '';

  repeat
    LInputChar := ReadKey;

    if CharInSet(LInputChar, AAllowedChars) then
    begin
      if Length(Result) < AMaxLength then
      begin
        if not CharInSet(LInputChar, [#10, #0, #13, #8])  then
        begin
          //Print(LInputChar, AColor);
          Print('%s%s', [AColor, LInputChar]);
          Result := Result + LInputChar;
        end;
      end;
    end;
    if LInputChar = #8 then
    begin
      if Length(Result) > 0 then
      begin
        //Print(#8 + ' ' + #8);
        Print(#8 + ' ' + #8, []);
        Delete(Result, Length(Result), 1);
      end;
    end;
  until (LInputChar = #13);

  PrintLn();
end;

class procedure AGT_Console.Pause(const AForcePause: Boolean; AColor: string; const AMsg: string);
var
  LDoPause: Boolean;
begin
  if not HasOutput then Exit;

  ClearKeyboardBuffer();

  if not AForcePause then
  begin
    LDoPause := True;
    if WasRunFrom() then LDoPause := False;
    if AGT_Utils.IsStartedFromDelphiIDE() then LDoPause := True;
    if not LDoPause then Exit;
  end;

  WriteLn;
  if AMsg = '' then
    Print('%sPress any key to continue... ', [aColor])
  else
    Print('%s%s', [aColor, AMsg]);

  WaitForAnyKey();
  WriteLn;
end;

class function  AGT_Console.WrapTextEx(const ALine: string; AMaxCol: Integer; const ABreakChars: AGT_CharSet): string;
var
  LText: string;
  LPos: integer;
  LChar: Char;
  LLen: Integer;
  I: Integer;
begin
  LText := ALine.Trim;

  LPos := 0;
  LLen := 0;

  while LPos < LText.Length do
  begin
    Inc(LPos);

    LChar := LText[LPos];

    if LChar = #10 then
    begin
      LLen := 0;
      continue;
    end;

    Inc(LLen);

    if LLen >= AMaxCol then
    begin
      for I := LPos downto 1 do
      begin
        LChar := LText[I];

        if CharInSet(LChar, ABreakChars) then
        begin
          LText.Insert(I, #10);
          Break;
        end;
      end;

      LLen := 0;
    end;
  end;

  Result := LText;
end;

class procedure AGT_Console.Teletype(const AText: string; const AColor: string; const AMargin: Integer; const AMinDelay: Integer; const AMaxDelay: Integer; const ABreakKey: Byte);
var
  LText: string;
  LMaxCol: Integer;
  LChar: Char;
  LWidth: Integer;
begin
  GetSize(@LWidth, nil);
  LMaxCol := LWidth - AMargin;

  LText := WrapTextEx(AText, LMaxCol);

  for LChar in LText do
  begin
    AGT_Utils.ProcessMessages();
    Print('%s%s', [AColor, LChar]);
    if not AGT_Math.RandomBool() then
      FTeletypeDelay := AGT_Math.RandomRange(AMinDelay, AMaxDelay);
    AGT_Utils.Wait(FTeletypeDelay);
    if IsKeyPressed(ABreakKey) then
    begin
      ClearKeyboardBuffer;
      Break;
    end;
  end;
end;

end.
