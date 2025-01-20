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

unit Aurora.Error;

{$I Aurora.Defines.inc}

interface

uses
  System.SysUtils,
  Aurora.CLibs;

type

  { AGT_Error }
  AGT_Error = class
  private class var
    FError: string;
  private
    class constructor Create();
    class destructor Destroy();
  public
    class procedure UnitInit();
    class procedure SetError(const AText: string; const AArgs: array of const); static;
    class function  GetError(): string; static;
  end;

implementation

// Callback function for GLFW errors
procedure ErrorCallback(AErrorCode: Integer; const ADescription: PUTF8Char); cdecl;
begin
  AGT_Error.SetError('GLFW Error %d: %s', [AErrorCode, string(ADescription)]);
end;

{ AGT_Error }
class constructor AGT_Error.Create();
begin
  FError := '';
end;

class destructor AGT_Error.Destroy();
begin
end;

class procedure AGT_Error.UnitInit();
begin
  glfwSetErrorCallback(ErrorCallback);
end;

class procedure AGT_Error.SetError(const AText: string; const AArgs: array of const);
begin
  FError := Format('%s', AArgs);
end;

class function AGT_Error.GetError(): string;
begin
  Result := FError;
end;

end.
