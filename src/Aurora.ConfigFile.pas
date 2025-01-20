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


unit Aurora.ConfigFile;

{$I Aurora.Defines.inc}

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.IniFiles,
  Aurora.CLibs,
  Aurora.Common,
  Aurora.IO;

type
  { AGT_ConfigFile }
  AGT_ConfigFile = class(TAGTBaseObject)
  private
    FHandle: TIniFile;
    FFilename: string;
    FSection: TStringList;
  public
    constructor Create(); override;
    destructor Destroy(); override;
    function  Open(const AFilename: string=''): Boolean;
    procedure Close();
    function  Opened(): Boolean;
    procedure Update();
    function  RemoveSection(const AName: string): Boolean;
    procedure SetValue(const ASection, AKey, AValue: string);  overload;
    procedure SetValue(const ASection, AKey: string; AValue: Integer); overload;
    procedure SetValue(const ASection, AKey: string; AValue: Boolean); overload;
    procedure SetValue(const ASection, AKey: string; AValue: Pointer; AValueSize: Cardinal); overload;
    function  GetValue(const ASection, AKey, ADefaultValue: string): string; overload;
    function  GetValue(const ASection, AKey: string; ADefaultValue: Integer): Integer; overload;
    function  GetValue(const ASection, AKey: string; ADefaultValue: Boolean): Boolean; overload;
    procedure GetValue(const ASection, AKey: string; AValue: Pointer; AValueSize: Cardinal); overload;
    function  RemoveKey(const ASection, AKey: string): Boolean;
    function  GetSectionValues(const ASection: string): Integer;
    function  GetSectionValue(const AIndex: Integer; const ADefaultValue: string): string; overload;
    function  GetSectionValue(const AIndex, ADefaultValue: Integer): Integer; overload;
    function  GetSectionValue(const AIndex: Integer; const ADefaultValue: Boolean): Boolean; overload;
  end;

implementation

{ AGT_ConfigFile }
constructor AGT_ConfigFile.Create();
begin
  inherited;
  FHandle := nil;
  FSection := TStringList.Create();
end;

destructor AGT_ConfigFile.Destroy();
begin
  Close;
  FSection.Free();
  inherited;
end;

function  AGT_ConfigFile.Open(const AFilename: string=''): Boolean;
var
  LFilename: string;
begin
  Close;
  LFilename := AFilename;
  if LFilename.IsEmpty then LFilename := TPath.ChangeExtension(ParamStr(0), 'ini');
  FHandle := TIniFile.Create(LFilename);
  Result := Boolean(FHandle <> nil);
  FFilename := LFilename;
end;

procedure AGT_ConfigFile.Close();
begin
  if not Opened then Exit;
  FHandle.UpdateFile;
  FreeAndNil(FHandle);
end;

function  AGT_ConfigFile.Opened(): Boolean;
begin
  Result := Boolean(FHandle <> nil);
end;

procedure AGT_ConfigFile.Update();
begin
  if not Opened then Exit;
  FHandle.UpdateFile;
end;

function  AGT_ConfigFile.RemoveSection(const AName: string): Boolean;
var
  LName: string;
begin
  Result := False;
  if not Opened then Exit;
  LName := AName;
  if LName.IsEmpty then Exit;
  FHandle.EraseSection(LName);
  Result := True;
end;

procedure AGT_ConfigFile.SetValue(const ASection, AKey, AValue: string);
begin
  if not Opened then Exit;
  FHandle.WriteString(ASection, AKey, AValue);
end;

procedure AGT_ConfigFile.SetValue(const ASection, AKey: string; AValue: Integer);
begin
  if not Opened then Exit;
  SetValue(ASection, AKey, AValue.ToString);
end;

procedure AGT_ConfigFile.SetValue(const ASection, AKey: string; AValue: Boolean);
begin
  if not Opened then Exit;
  SetValue(ASection, AKey, AValue.ToInteger);
end;

procedure AGT_ConfigFile.SetValue(const ASection, AKey: string; AValue: Pointer; AValueSize: Cardinal);
var
  LValue: TMemoryStream;
begin
  if not Opened then Exit;
  if AValue = nil then Exit;
  LValue := TMemoryStream.Create;
  try
    LValue.Position := 0;
    LValue.Write(AValue^, AValueSize);
    LValue.Position := 0;
    FHandle.WriteBinaryStream(ASection, AKey, LValue);
  finally
    FreeAndNil(LValue);
  end;
end;

function  AGT_ConfigFile.GetValue(const ASection, AKey, ADefaultValue: string): string;
begin
  Result := '';
  if not Opened then Exit;
  Result := FHandle.ReadString(ASection, AKey, ADefaultValue);
end;

function  AGT_ConfigFile.GetValue(const ASection, AKey: string; ADefaultValue: Integer): Integer;
var
  LResult: string;
begin
  Result := ADefaultValue;
  if not Opened then Exit;
  LResult := GetValue(ASection, AKey, ADefaultValue.ToString);
  Integer.TryParse(LResult, Result);
end;

function  AGT_ConfigFile.GetValue(const ASection, AKey: string; ADefaultValue: Boolean): Boolean;
begin
  Result := ADefaultValue;
  if not Opened then Exit;
  Result := GetValue(ASection, AKey, ADefaultValue.ToInteger).ToBoolean;
end;

procedure AGT_ConfigFile.GetValue(const ASection, AKey: string; AValue: Pointer; AValueSize: Cardinal);
var
  LValue: TMemoryStream;
  LSize: Cardinal;
begin
  if not Opened then Exit;
  if not Assigned(AValue) then Exit;
  if AValueSize = 0 then Exit;
  LValue := TMemoryStream.Create;
  try
    LValue.Position := 0;
    FHandle.ReadBinaryStream(ASection, AKey, LValue);
    LSize := AValueSize;
    if AValueSize > LValue.Size then
      LSize := LValue.Size;
    LValue.Position := 0;
    LValue.Write(AValue^, LSize);
  finally
    FreeAndNil(LValue);
  end;
end;

function  AGT_ConfigFile.RemoveKey(const ASection, AKey: string): Boolean;
var
  LSection: string;
  LKey: string;
begin
  Result := False;
  if not Opened then Exit;
  LSection := ASection;
  LKey := AKey;
  if LSection.IsEmpty then Exit;
  if LKey.IsEmpty then Exit;
  FHandle.DeleteKey(LSection, LKey);
  Result := True;
end;

function  AGT_ConfigFile.GetSectionValues(const ASection: string): Integer;
var
  LSection: string;
begin
  Result := 0;
  if not Opened then Exit;
  LSection := ASection;
  if LSection.IsEmpty then Exit;
  FSection.Clear;
  FHandle.ReadSectionValues(LSection, FSection);
  Result := FSection.Count;
end;

function  AGT_ConfigFile.GetSectionValue(const AIndex: Integer; const ADefaultValue: string): string;
begin
  Result := '';
  if not Opened then Exit;
  if (AIndex < 0) or (AIndex > FSection.Count - 1) then Exit;
  Result := FSection.ValueFromIndex[AIndex];
  if Result = '' then Result := ADefaultValue;
end;

function  AGT_ConfigFile.GetSectionValue(const AIndex, ADefaultValue: Integer): Integer;
begin
  Result := ADefaultValue;
  if not Opened then Exit;
  Result := string(GetSectionValue(AIndex, ADefaultValue.ToString)).ToInteger;
end;

function  AGT_ConfigFile.GetSectionValue(const AIndex: Integer; const ADefaultValue: Boolean): Boolean;
begin
  Result := ADefaultValue;
  if not Opened then Exit;
  Result := string(GetSectionValue(AIndex, ADefaultValue.ToString)).ToBoolean
end;

end.
