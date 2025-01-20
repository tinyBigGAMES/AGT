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

unit UTestbed;

interface

procedure RunTests();

implementation

uses
  System.SysUtils,
  AGT;

const
  CZipFilename = 'Data.zip';

procedure Test01_ZipFileBuildProgress(const AFilename: PWideChar; const AProgress: Integer; const ANewFile: Boolean; const AUserData: Pointer); cdecl;
begin
  if aNewFile then AGT_Console_PrintLn('');
  AGT_Console_Print(PWideChar(Format(AGT_CSIDim+AGT_CSIFGWhite+AGT_CR+'Adding %s(%d%s)...', [ExtractFileName(string(aFilename)), aProgress, '%'])));
end;

procedure Test01();
begin
  AGT_Console_SetTitle('AGT: Zip Build');

  AGT_Console_PrintLn('Creating ' + CZipFilename + '...');

  if AGT_ZipFileIO_Build(CZipFilename, 'res', AGT_DEFAULT_ZIPFILE_PASSWORD, Test01_ZipFileBuildProgress, nil) then
    AGT_Console_PrintLn(AGT_CSIFGCyan+AGT_CSIBlink+AGT_CRLF+'Success!')
  else
    AGT_Console_PrintLn(AGT_CSIFGRed+AGT_CSIBlink+AGT_CRLF+'Failed!');
end;

procedure Test02();
var
  LMem: AGT_MemoryIO;
  LFile: AGT_FileIO;
begin
  AGT_Console_SetTitle('AGT: Zip Extract');

  if FileExists('image.png') then
    DeleteFile('image.png');

  AGT_Console_PrintLn('Extracting "res/images/aurora.png..."');

  LMem := AGT_ZipFileIO_LoadToMemory(CZipFilename, 'res/images/aurora.png', AGT_DEFAULT_ZIPFILE_PASSWORD);

  AGT_Console_PrintLn('Creating "image.png..."');

  LFile := AGT_FileIO_Open('image.png', AGT_iomWrite);

  AGT_Console_PrintLn('Writing "image.png..."');

  AGT_IO_Write(LFile, AGT_MemoryIO_Memory(LMem), AGT_IO_Size(LMem));

  if FileExists('image.png') then
    AGT_Console_PrintLn(AGT_CSIFGCyan+AGT_CSIBlink+'Success!')
  else
    AGT_Console_PrintLn(AGT_CSIFGRed+AGT_CSIBlink+AGT_CRLF+'Failed!');

  AGT_IO_Destroy(LFile);

  AGT_IO_Destroy(LMem);
end;

procedure Test03();
var
  LWindow: AGT_Window;
  LColor: AGT_Color;
  LFont: AGT_Font;
  LHud: AGT_Point;
begin
  LColor := AGT_Color_FromByte(30, 31, 30, 255);

  LWindow := AGT_Window_Open('AGT: Window');
  AGT_Window_SetSizeLimits(LWindow, Round(AGT_Window_GetVirtualSize(LWindow).w), Round(AGT_Window_GetVirtualSize(LWindow).h), AGT_DONT_CARE, AGT_DONT_CARE);

  LFont := AGT_Font_CreateDefault(LWindow, 12);

  while not AGT_Window_ShouldClose(LWindow) do
  begin
    AGT_Window_StartFrame(LWindow);

      if AGT_Window_GetKey(LWindow, AGT_KEY_ESCAPE, AGT_isWasReleased) then
        AGT_Window_SetShouldClose(LWindow, True);

      if AGT_Window_GetKey(LWindow, AGT_KEY_F11, AGT_isWasReleased) then
        AGT_Window_ToggleFullscreen(LWindow);

      AGT_Window_StartDrawing(LWindow);

        AGT_Window_Clear(LWindow, LColor);

        LHud := AGT_Point_Create(3, 3);
        AGT_Font_DrawTextVarY(LFont, LWindow, LHud.x, LHud.y, 0, AGT_WHITE, AGT_haLeft, PWideChar(Format('%d fps', [AGT_Window_GetFrameRate(LWindow)])));
        AGT_Font_DrawTextVarY(LFont, LWindow, LHud.x, LHud.y, 0, AGT_DARKGREEN, AGT_haLeft, AGT_HudTextItem('ESC', 'Quit', '-'));
        AGT_Font_DrawTextVarY(LFont, LWindow, LHud.x, LHud.y, 0, AGT_DARKGREEN, AGT_haLeft, AGT_HudTextItem('F11', 'Fullscreen toggle', '-'));

      AGT_Window_EndDrawing(LWindow);

    AGT_Window_EndFrame(LWindow);
  end;

  AGT_Font_Destroy(LFont);

  AGT_Window_Close(LWindow);
end;

procedure Test04();
var
  LWindow: AGT_Window;
  LFont: AGT_Font;
  LHud: AGT_Point;
  LTexture: AGT_Texture;
  LAngle: Single;
begin
  LAngle := 0;

  LWindow := AGT_Window_Open('AGT: Texture');
  AGT_Window_SetSizeLimits(LWindow, Round(AGT_Window_GetVirtualSize(LWindow).w), Round(AGT_Window_GetVirtualSize(LWindow).h), AGT_DONT_CARE, AGT_DONT_CARE);

  LFont := AGT_Font_CreateDefault(LWindow, 12);

  LTexture := AGT_Texture_CreateFromZipFile(CZipFilename, 'res/images/aurora.png', AGT_DEFAULT_ZIPFILE_PASSWORD);
  AGT_Texture_SetPosEx(LTexture, AGT_Window_GetVirtualSize(LWindow).w/2, AGT_Window_GetVirtualSize(LWindow).h/2);
  AGT_Texture_SetScale(LTexture, 0.5);

  while not AGT_Window_ShouldClose(LWindow) do
  begin
    AGT_Window_StartFrame(LWindow);

      if AGT_Window_GetKey(LWindow, AGT_KEY_ESCAPE, AGT_isWasReleased) then
        AGT_Window_SetShouldClose(LWindow, True);

      if AGT_Window_GetKey(LWindow, AGT_KEY_F11, AGT_isWasReleased) then
        AGT_Window_ToggleFullscreen(LWindow);


      LAngle := LAngle + 0.1;
      AGT_ClipVaLuef(LAngle, 0, 360, True);
      AGT_Texture_SetAngle(LTexture, LAngle);

      AGT_Window_StartDrawing(LWindow);

        AGT_Window_Clear(LWindow, AGT_DARKSLATEBROWN);

        AGT_Texture_Draw(LTexture, LWindow);

        LHud := AGT_Point_Create(3, 3);
        AGT_Font_DrawTextVarY(LFont, LWindow, LHud.x, LHud.y, 0, AGT_WHITE, AGT_haLeft, PWideChar(Format('%d fps', [AGT_Window_GetFrameRate(LWindow)])));
        AGT_Font_DrawTextVarY(LFont, LWindow, LHud.x, LHud.y, 0, AGT_DARKGREEN, AGT_haLeft, AGT_HudTextItem('ESC', 'Quit', '-'));
        AGT_Font_DrawTextVarY(LFont, LWindow, LHud.x, LHud.y, 0, AGT_DARKGREEN, AGT_haLeft, AGT_HudTextItem('F11', 'Fullscreen toggle', '-'));

      AGT_Window_EndDrawing(LWindow);

    AGT_Window_EndFrame(LWindow);
  end;

  AGT_Texture_Destroy(LTexture);

  AGT_Font_Destroy(LFont);

  AGT_Window_Close(LWindow);
end;

procedure Test05_VideoStatusCallback(const AStatus: AGT_VideoStatus; const AFilename: PWideChar; const AUserData: Pointer); cdecl;
var
  LFilename: string;
begin
  if AStatus = AGT_vsStopped then
  begin
    LFilename := string(AFilename);
    if LFilename = 'res/videos/aurora.mpg' then
      AGT_Video_PlayFromZipFile(CZipFilename, 'res/videos/tbg.mpg', AGT_DEFAULT_ZIPFILE_PASSWORD, 1.0, False)
    else
    if LFilename = 'res/videos/tbg.mpg' then
      AGT_Video_PlayFromZipFile(CZipFilename, 'res/videos/sample01.mpg', AGT_DEFAULT_ZIPFILE_PASSWORD, 1.0, False)
    else
    if LFilename = 'res/videos/sample01.mpg' then
      AGT_Video_PlayFromZipFile(CZipFilename, 'res/videos/aurora.mpg', AGT_DEFAULT_ZIPFILE_PASSWORD, 1.0, False)
  end;
end;

procedure Test05();
var
  LWindow: AGT_Window;
  LFont: AGT_Font;
  LHud: AGT_Point;
begin

  LWindow := AGT_Window_Open('AGT: Video');
  AGT_Window_SetSizeLimits(LWindow, Round(AGT_Window_GetVirtualSize(LWindow).w), Round(AGT_Window_GetVirtualSize(LWindow).h), AGT_DONT_CARE, AGT_DONT_CARE);

  LFont := AGT_Font_CreateDefault(LWindow, 12);

  AGT_Video_SetStatusCallback(Test05_VideoStatusCallback, nil);
  AGT_Video_PlayFromZipFile(CZipFilename, 'res/videos/aurora.mpg', AGT_DEFAULT_ZIPFILE_PASSWORD, 1.0, False);

  while not AGT_Window_ShouldClose(LWindow) do
  begin
    AGT_Window_StartFrame(LWindow);

      if AGT_Window_GetKey(LWindow, AGT_KEY_ESCAPE, AGT_isWasReleased) then
        AGT_Window_SetShouldClose(LWindow, True);

      if AGT_Window_GetKey(LWindow, AGT_KEY_F11, AGT_isWasReleased) then
        AGT_Window_ToggleFullscreen(LWindow);

      AGT_Window_StartDrawing(LWindow);

        AGT_Window_Clear(LWindow, AGT_DARKSLATEBROWN);

        AGT_Video_Draw(LWindow, 0, 0, 0.5);

        LHud := AGT_Point_Create(3, 3);
        AGT_Font_DrawTextVarY(LFont, LWindow, LHud.x, LHud.y, 0, AGT_WHITE, AGT_haLeft, PWideChar(Format('%d fps', [AGT_Window_GetFrameRate(LWindow)])));
        AGT_Font_DrawTextVarY(LFont, LWindow, LHud.x, LHud.y, 0, AGT_DARKGREEN, AGT_haLeft, AGT_HudTextItem('ESC', 'Quit', '-'));
        AGT_Font_DrawTextVarY(LFont, LWindow, LHud.x, LHud.y, 0, AGT_DARKGREEN, AGT_haLeft, AGT_HudTextItem('F11', 'Fullscreen toggle', '-'));

      AGT_Window_EndDrawing(LWindow);

    AGT_Window_EndFrame(LWindow);
  end;

  AGT_Video_Stop();

  AGT_Font_Destroy(LFont);

  AGT_Window_Close(LWindow);
end;

procedure RunTests();
var
  LNum: Integer;
begin
  LNum := 01;   //<--- Be sure to run #01 first to create the zip file used by the examples

  case LNum of
    01: Test01();
    02: Test02();
    03: Test03();
    04: Test04();
    05: Test05();
  end;

  AGT_Console_Pause();
end;

end.
