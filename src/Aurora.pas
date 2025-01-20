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

unit Aurora;

{$I Aurora.Defines.inc}

interface

implementation

uses
  WinApi.Windows,
  System.SysUtils,
  Aurora.CLibs,
  Aurora.Console,
  Aurora.Error,
  Aurora.Utils,
  Aurora.Math,
  Aurora.Video,
  Aurora.Audio;

{$R Aurora.res}

initialization
begin
  ReportMemoryLeaksOnShutdown := True;

  try
    if glfwInit() <> GLFW_TRUE then
    begin
      MessageBox(0, 'Failed to initialize GLFW', 'Critical Initialization Error', MB_ICONERROR);
      Halt(1); // Exit the application with a non-zero exit code to indicate failure
    end;

    AGT_Console.UnitInit();
    AGT_Error.UnitInit();
    AGT_Utils.UnitInit();
    AGT_Math.UnitInit();
    AGT_Video.UnitInit();
    AGT_Audio.UnitInit();

  except
    on E: Exception do
    begin
      // Display any exceptions encountered during initialization.
      MessageBox(0, PChar(E.Message), 'Critical Initialization Error', MB_ICONERROR);
      Halt(1);
    end;
  end;

end;

finalization
begin
  try
    glfwTerminate();
  except
    on E: Exception do
    begin
      MessageBox(0, PChar(E.Message), 'Critical Shutdown Error', MB_ICONERROR);
    end;
  end;
end;

end.
