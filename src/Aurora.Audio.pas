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

unit Aurora.Audio;

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
  Aurora.Utils,
  Aurora.Math,
  Aurora.IO,
  Aurora.FileIO,
  Aurora.ZipFileIO,
  Aurora.Window;

const
  AGT_AUDIO_ERROR           = -1;
  AGT_AUDIO_MUSIC_COUNT     = 256;
  AGT_AUDIO_SOUND_COUNT     = 256;
  AGT_AUDIO_CHANNEL_COUNT   = 16;
  AGT_AUDIO_CHANNEL_DYNAMIC = -2;

type
  { TPyMaVFS }
  PAGTMaVFS = ^TAGTMaVFS;
  TAGTMaVFS = record
  private
    Callbacks: ma_vfs_callbacks;
    IO: AGT_IO;
  public
    constructor Create(const AIO: AGT_IO);
  end;

  { AGT_Audio }
  AGT_Audio = class
  protected type
    TMusic = record
      Handle: ma_sound;
      Loaded: Boolean;
      Volume: Single;
      Pan: Single;
    end;
    TSound = record
      Handle: ma_sound;
      InUse: Boolean;
    end;
    TChannel = record
      Handle: ma_sound;
      Reserved: Boolean;
      InUse: Boolean;
      Volume: Single;
    end;
  protected class var
    FVFS: TAGTMaVFS;
    FEngineConfig: ma_engine_config;
    FEngine: ma_engine;
    FOpened: Boolean;
    FPaused: Boolean;
    FMusic: TMusic;
    snd1,snd2,snd3: ma_sound;
    FSound: array[0..AGT_AUDIO_SOUND_COUNT-1] of TSound;
    FChannel: array[0..AGT_AUDIO_CHANNEL_COUNT-1] of TChannel;
    class function FindFreeSoundSlot(): Integer; static;
    class function FindFreeChannelSlot(): Integer; static;
    class function ValidChannel(const AChannel: Integer): Boolean; static;
    class procedure InitData(); static;
    class constructor Create();
    class destructor Destroy();

  public
    class procedure UnitInit(); static;
    class procedure Update(); static;
    class function  Open(): Boolean; static;
    class function  IsOpen(): Boolean; static;
    class procedure Close(); static;
    class function  IsPaused(): Boolean; static;
    class procedure SetPause(const APause: Boolean); static;
    class function  PlayMusic(const AIO: AGT_IO; const AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean; static;
    class function  PlayMusicFromFile(const AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean; static;
    class function  PlayMusicFromZipFile(const AZipFilename, AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): Boolean; static;
    class procedure UnloadMusic(); static;
    class function  IsMusicLooping(): Boolean; static;
    class procedure SetMusicLooping(const ALoop: Boolean); static;
    class function  MusicVolume(): Single; static;
    class procedure SetMusicVolume(const AVolume: Single); static;
    class function  MusicPan(): Single; static;
    class procedure SetMusicPan(const APan: Single); static;
    class function  LoadSound(const AIO: AGT_IO; const AFilename: string): Integer; static;
    class function  LoadSoundFromFile(const AFilename: string): Integer; static;
    class function  LoadSoundFromZipFile(const AZipFilename, AFilename: string; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): Integer; static;
    class procedure UnloadSound(var ASound: Integer); static;
    class procedure UnloadAllSounds(); static;
    class function  PlaySound(const ASound, AChannel: Integer; const AVolume: Single; const ALoop: Boolean): Integer; static;
    class procedure ReserveChannel(const AChannel: Integer; const aReserve: Boolean); static;
    class function  IsChannelReserved(const AChannel: Integer): Boolean; static;
    class procedure StopChannel(const AChannel: Integer); static;
    class procedure SetChannelVolume(const AChannel: Integer; const AVolume: Single); static;
    class function  GetChannelVolume(const AChannel: Integer): Single; static;
    class procedure SetChannelPosition(const AChannel: Integer; const X, Y: Single); static;
    class procedure SetChannelLoop(const AChannel: Integer; const ALoop: Boolean); static;
    class function  IsChannelLooping(const AChannel: Integer): Boolean; static;
    class function  IsChannelPlaying(const AChannel: Integer): Boolean; static;
  end;

//=== EXPORTS ===============================================================
procedure AGT_Audio_Update(); cdecl; exports AGT_Audio_Update;
function  AGT_Audio_Open(): Boolean; cdecl; exports AGT_Audio_Open;
function  AGT_Audio_IsOpen(): Boolean; cdecl; exports AGT_Audio_IsOpen;
procedure AGT_Audio_Close(); cdecl; exports AGT_Audio_Close;
function  AGT_Audio_IsPaused(): Boolean; cdecl; exports AGT_Audio_IsPaused;
procedure AGT_Audio_SetPause(const APause: Boolean); cdecl; exports AGT_Audio_SetPause;
function  AGT_Audio_PlayMusic(const AIO: AGT_IO; const AFilename: PWideChar; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean; cdecl; exports AGT_Audio_PlayMusic;
function  AGT_Audio_PlayMusicFromFile(const AFilename: PWideChar; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean; cdecl; exports AGT_Audio_PlayMusicFromFile;
function  AGT_Audio_PlayMusicFromZipFile(const AZipFilename, AFilename, APassword: PWideChar; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean; cdecl; exports AGT_Audio_PlayMusicFromZipFile;
procedure AGT_Audio_UnloadMusic(); cdecl; exports AGT_Audio_UnloadMusic;
function  AGT_Audio_IsMusicLooping(): Boolean; cdecl; exports AGT_Audio_IsMusicLooping;
procedure AGT_Audio_SetMusicLooping(const ALoop: Boolean); cdecl; exports AGT_Audio_SetMusicLooping;
function  AGT_Audio_MusicVolume(): Single; cdecl; exports AGT_Audio_MusicVolume;
procedure AGT_Audio_SetMusicVolume(const AVolume: Single); cdecl; exports AGT_Audio_SetMusicVolume;
function  AGT_Audio_MusicPan(): Single; cdecl; exports AGT_Audio_MusicPan;
procedure AGT_Audio_SetMusicPan(const APan: Single); cdecl; exports AGT_Audio_SetMusicPan;
function  AGT_Audio_LoadSound(const AIO: AGT_IO; const AFilename: PWideChar): Integer; cdecl; exports AGT_Audio_LoadSound;
function  AGT_Audio_LoadSoundFromFile(const AFilename: PWideChar): Integer; cdecl; exports AGT_Audio_LoadSoundFromFile;
function  AGT_Audio_LoadSoundFromZipFile(const AZipFilename, AFilename, APassword: PWideChar): Integer; cdecl; exports AGT_Audio_LoadSoundFromZipFile;
procedure AGT_Audio_UnloadSound(var ASound: Integer); cdecl; exports AGT_Audio_UnloadSound;
procedure AGT_Audio_UnloadAllSounds(); cdecl; exports AGT_Audio_UnloadAllSounds;
function  AGT_Audio_PlaySound(const ASound, AChannel: Integer; const AVolume: Single; const ALoop: Boolean): Integer; cdecl; exports AGT_Audio_PlaySound;
procedure AGT_Audio_ReserveChannel(const AChannel: Integer; const aReserve: Boolean); cdecl; exports AGT_Audio_ReserveChannel;
function  AGT_Audio_IsChannelReserved(const AChannel: Integer): Boolean; cdecl; exports AGT_Audio_IsChannelReserved;
procedure AGT_Audio_StopChannel(const AChannel: Integer); cdecl; exports AGT_Audio_StopChannel;
procedure AGT_Audio_SetChannelVolume(const AChannel: Integer; const AVolume: Single); cdecl; exports AGT_Audio_SetChannelVolume;
function  AGT_Audio_GetChannelVolume(const AChannel: Integer): Single; cdecl; exports AGT_Audio_GetChannelVolume;
procedure AGT_Audio_SetChannelPosition(const AChannel: Integer; const X, Y: Single); cdecl; exports AGT_Audio_SetChannelPosition;
procedure AGT_Audio_SetChannelLoop(const AChannel: Integer; const ALoop: Boolean); cdecl; exports AGT_Audio_SetChannelLoop;
function  AGT_Audio_IsChannelLooping(const AChannel: Integer): Boolean; cdecl; exports AGT_Audio_IsChannelLooping;
function  AGT_Audio_IsChannelPlaying(const AChannel: Integer): Boolean; cdecl; exports AGT_Audio_IsChannelPlaying;

implementation

//=== EXPORTS ===============================================================
procedure AGT_Audio_Update();
begin
  AGT_Audio.Update();
end;

function  AGT_Audio_Open(): Boolean;
begin
  Result := AGT_Audio.Open();
end;

function  AGT_Audio_IsOpen(): Boolean;
begin
  Result := AGT_Audio.IsOpen();
end;

procedure AGT_Audio_Close();
begin
  AGT_Audio.Close();
end;

function  AGT_Audio_IsPaused(): Boolean;
begin
  Result := AGT_Audio.IsPaused();
end;

procedure AGT_Audio_SetPause(const APause: Boolean);
begin
  AGT_Audio.SetPause(APause);
end;

function  AGT_Audio_PlayMusic(const AIO: AGT_IO; const AFilename: PWideChar; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean;
begin
  Result := AGT_Audio.PlayMusic(AIO, string(AFilename), AVolume, ALoop, APan);
end;

function  AGT_Audio_PlayMusicFromFile(const AFilename: PWideChar; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean;
begin
  Result := AGT_Audio.PlayMusicFromFile(string(AFilename), AVolume, ALoop, APan)
end;

function  AGT_Audio_PlayMusicFromZipFile(const AZipFilename, AFilename, APassword: PWideChar; const AVolume: Single; const ALoop: Boolean; const APan: Single=0.0): Boolean;
begin
  Result := AGT_Audio.PlayMusicFromZipFile(string(AZipFilename), string(AFilename), AVolume, ALoop, APan, string(APassword));
end;

procedure AGT_Audio_UnloadMusic();
begin
  AGT_Audio.UnloadMusic();
end;

function  AGT_Audio_IsMusicLooping(): Boolean;
begin
  Result := AGT_Audio.IsMusicLooping();
end;

procedure AGT_Audio_SetMusicLooping(const ALoop: Boolean);
begin
  AGT_Audio.SetMusicLooping(ALoop);
end;

function  AGT_Audio_MusicVolume(): Single;
begin
  Result := AGT_Audio.MusicVolume();
end;

procedure AGT_Audio_SetMusicVolume(const AVolume: Single);
begin
  AGT_Audio.SetMusicVolume(AVolume);
end;

function  AGT_Audio_MusicPan(): Single;
begin
  Result := AGT_Audio.MusicPan();
end;

procedure AGT_Audio_SetMusicPan(const APan: Single);
begin
  AGT_Audio.SetMusicPan(APan);
end;

function  AGT_Audio_LoadSound(const AIO: AGT_IO; const AFilename: PWideChar): Integer;
begin
  Result := AGT_Audio.LoadSound(AIO, string(AFilename));
end;

function  AGT_Audio_LoadSoundFromFile(const AFilename: PWideChar): Integer;
begin
  Result := AGT_Audio.LoadSoundFromFile(string(AFilename));
end;

function  AGT_Audio_LoadSoundFromZipFile(const AZipFilename, AFilename, APassword: PWideChar): Integer;
begin
  Result := AGT_Audio.LoadSoundFromZipFile(string(AZipFilename), string(AFilename), string(APassword));
end;

procedure AGT_Audio_UnloadSound(var ASound: Integer);
begin
  AGT_Audio.UnloadSound(ASound);
end;

procedure AGT_Audio_UnloadAllSounds();
begin
  AGT_Audio.UnloadAllSounds();
end;

function  AGT_Audio_PlaySound(const ASound, AChannel: Integer; const AVolume: Single; const ALoop: Boolean): Integer;
begin
  Result := AGT_Audio.PlaySound(ASound, AChannel, AVolume, ALoop);
end;

procedure AGT_Audio_ReserveChannel(const AChannel: Integer; const aReserve: Boolean);
begin
  AGT_Audio.ReserveChannel(AChannel, AReserve);
end;

function  AGT_Audio_IsChannelReserved(const AChannel: Integer): Boolean;
begin
  Result := AGT_Audio.IsChannelReserved(AChannel);
end;

procedure AGT_Audio_StopChannel(const AChannel: Integer);
begin
  AGT_Audio.StopChannel(AChannel);
end;

procedure AGT_Audio_SetChannelVolume(const AChannel: Integer; const AVolume: Single);
begin
  AGT_Audio.SetChannelVolume(AChannel, AVolume);
end;

function  AGT_Audio_GetChannelVolume(const AChannel: Integer): Single;
begin
  Result := AGT_Audio.GetChannelVolume(AChannel);
end;

procedure AGT_Audio_SetChannelPosition(const AChannel: Integer; const X, Y: Single);
begin
  AGT_Audio.SetChannelPosition(AChannel, X, Y);
end;

procedure AGT_Audio_SetChannelLoop(const AChannel: Integer; const ALoop: Boolean);
begin
  AGT_Audio.SetChannelLoop(AChannel, ALoop);
end;

function  AGT_Audio_IsChannelLooping(const AChannel: Integer): Boolean;
begin
  Result := AGT_Audio.IsChannelLooping(AChannel);
end;

function  AGT_Audio_IsChannelPlaying(const AChannel: Integer): Boolean;
begin
  Result := AGT_Audio.IsChannelPlaying(AChannel);
end;

{ TMaVPS }
function TMaVFS_OnOpen(AVFS: Pma_vfs; const AFilename: PUTF8Char; AOpenMode: ma_uint32; AFile: Pma_vfs_file): ma_result; cdecl;
var
  LIO: AGT_IO;
begin
  Result := MA_ERROR;
  LIO := PAGTMaVFS(AVFS).IO;
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen() then Exit;
  AFile^ := LIO;
  Result := MA_SUCCESS;
end;

function TMaVFS_OnOpenW(AVFS: Pma_vfs; const AFilename: PWideChar; AOpenMode: ma_uint32; pFile: Pma_vfs_file): ma_result; cdecl;
begin
  Result := MA_ERROR;
end;

function TMaVFS_OnClose(AVFS: Pma_vfs; file_: ma_vfs_file): ma_result; cdecl;
var
  LIO: AGT_IO;
begin
  Result := MA_ERROR;
  LIO := AGT_IO(File_);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;
  LIO.Free();
  Result := MA_SUCCESS;
end;

function TMaVFS_OnRead(AVFS: Pma_vfs; file_: ma_vfs_file; AData: Pointer; ASizeInBytes: NativeUInt; ABytesRead: PNativeUInt): ma_result; cdecl;
var
  LIO: AGT_IO;
  LResult: Int64;
begin
  Result := MA_ERROR;
  LIO := AGT_IO(File_);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;
  LResult := LIO.Read(AData, ASizeInBytes);
  if LResult < 0 then Exit;
  ABytesRead^ := LResult;
  Result := MA_SUCCESS;
end;

function TMaVFS_OnWrite(AVFS: Pma_vfs; AVFSFile: ma_vfs_file; const AData: Pointer; ASizeInBytes: NativeUInt; ABytesWritten: PNativeUInt): ma_result; cdecl;
begin
  Result := MA_ERROR;
end;

function TMaVFS_OnSeek(AVFS: Pma_vfs; file_: ma_vfs_file; AOffset: ma_int64;
  AOrigin: ma_seek_origin): ma_result; cdecl;
var
  LIO: AGT_IO;
begin
  Result := MA_ERROR;
  LIO := AGT_IO(File_);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;
  LIO.Seek(AOffset, AGT_IOSeek(AOrigin));
  Result := MA_SUCCESS;
end;

function TMaVFS_OnTell(AVFS: Pma_vfs; file_: ma_vfs_file; ACursor: Pma_int64): ma_result; cdecl;
var
  LIO: AGT_IO;
begin
  Result := MA_ERROR;
  LIO := AGT_IO(File_);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;
  ACursor^ := LIO.Pos();
  Result := MA_SUCCESS;
end;

function TMaVFS_OnInfo(AVFS: Pma_vfs; AVFSFile: ma_vfs_file; AInfo: Pma_file_info): ma_result; cdecl;
var
  LIO: AGT_IO;
  LResult: Int64;
begin
  Result := MA_ERROR;
  LIO := AGT_IO(AVFSFile);
  if not Assigned(LIO) then Exit;
  if not LIO.IsOpen then Exit;

  LResult := LIO.Size;
  if LResult < 0 then Exit;

  AInfo.sizeInBytes := LResult;
  Result := MA_SUCCESS;
end;

constructor TAGTMaVFS.Create(const AIO: AGT_IO);
begin
  Self := Default(TAGTMaVFS);
  Callbacks.onopen := TMaVFS_OnOpen;
  Callbacks.onOpenW := TMaVFS_OnOpenW;
  Callbacks.onRead := TMaVFS_OnRead;
  Callbacks.onWrite := TMaVFS_OnWrite;
  Callbacks.onclose := TMaVFS_OnClose;
  Callbacks.onread := TMaVFS_OnRead;
  Callbacks.onseek := TMaVFS_OnSeek;
  Callbacks.onTell := TMaVFS_OnTell;
  Callbacks.onInfo := TMaVFS_OnInfo;
  IO := AIO;
end;

{ AGT_Audio }
class function AGT_Audio.FindFreeSoundSlot(): Integer;
var
  I: Integer;
begin
  Result := AGT_AUDIO_ERROR;
  for I := 0 to AGT_AUDIO_SOUND_COUNT-1 do
  begin
    if not FSound[I].InUse then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

class function AGT_Audio.FindFreeChannelSlot(): Integer;
var
  I: Integer;
begin
  Result := AGT_AUDIO_ERROR;
  for I := 0 to AGT_AUDIO_SOUND_COUNT-1 do
  begin
    if (not FChannel[I].InUse) and (not FChannel[I].Reserved) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

class function AGT_Audio.ValidChannel(const AChannel: Integer): Boolean;
begin
  Result := False;
  if not InRange(AChannel, 0, AGT_AUDIO_CHANNEL_COUNT-1) then Exit;
  if not FChannel[AChannel].InUse then Exit;
  Result := True;
end;

class constructor AGT_Audio.Create();
begin
  inherited;
end;

class destructor AGT_Audio.Destroy();
begin
  Close();
  inherited;
end;

class function  AGT_Audio.Open(): Boolean;
begin
  Result := False;
  if IsOpen() then Exit;

  FVFS := TAGTMaVFS.Create(nil);
  FEngineConfig := ma_engine_config_init;
  FEngineConfig.pResourceManagerVFS := @FVFS;
  if ma_engine_init(@FEngineConfig, @FEngine) <> MA_SUCCESS then Exit;

  FOpened := True;
  Result := IsOpen();
end;

class procedure AGT_Audio.Close();
begin
  if not IsOpen() then Exit;
  UnloadMusic();
  UnloadAllSounds();
  ma_engine_uninit(@FEngine);
  InitData;
end;

class function AGT_Audio.IsOpen(): Boolean;
begin
  Result := FOpened;
end;

class procedure AGT_Audio.InitData();
var
  I: Integer;
begin
  FEngine := Default(ma_engine);

  for I := Low(FSound) to High(FSound) do
    FSound[I] := Default(TSound);

  for I := Low(FChannel) to High(FChannel) do
    FChannel[i] := Default(TChannel);

  FOpened := False;
  FPaused := False;
end;

class procedure AGT_Audio.UnitInit();
begin
end;

class procedure AGT_Audio.Update();
var
  I: Integer;
begin
  if not IsOpen() then Exit;

  // check channels
  for I := 0 to AGT_AUDIO_CHANNEL_COUNT-1 do
  begin
    if FChannel[I].InUse then
    begin
      if ma_sound_is_playing(@FChannel[I].Handle) = MA_FALSE then
      begin
        ma_sound_uninit(@FChannel[I].Handle);
        FChannel[I].InUse := False;
      end;
    end;
  end;
end;

class function  AGT_Audio.IsPaused(): Boolean;
begin
  Result := FPaused;
end;

class procedure AGT_Audio.SetPause(const APause: Boolean);
begin
  if not IsOpen() then Exit;

  case aPause of
    True:
    begin
      if ma_engine_stop(@FEngine) = MA_SUCCESS then
        FPaused := aPause;
    end;

    False:
    begin
      if ma_engine_start(@FEngine) = MA_SUCCESS then
        FPaused := aPause;
    end;
  end;
end;

class function  AGT_Audio.PlayMusic(const AIO: AGT_IO; const AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single): Boolean;
begin
  Result := FAlse;
  if not IsOpen then Exit;
  if not Assigned(AIO) then Exit;
  UnloadMusic();
  FVFS.IO := AIO;
  if ma_sound_init_from_file(@FEngine, AGT_Utils.AsUtf8(AFilename, []), Ord(MA_SOUND_FLAG_STREAM), nil,
    nil, @FMusic.Handle) <> MA_SUCCESS then
  FVFS.IO := nil;
  ma_sound_start(@FMusic);
  FMusic.Loaded := True;
  SetMusicLooping(ALoop);
  SetMusicVolume(AVolume);
  SetMusicPan(APan);
end;

class function  AGT_Audio.PlayMusicFromFile(const AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single): Boolean;
var
  LIO: AGT_FileIO;
begin
  Result := False;
  //if not IGet(IFileIO, LIO) then Exit;
  LIO := AGT_FileIO.Create();
  if not LIO.Open(AFilename,AGT_iomRead) then
  begin
    LIO.Free();
    Exit;
  end;

  Result := PlayMusic(LIO, AFilename, AVolume, ALoop, APan);
end;

class function  AGT_Audio.PlayMusicFromZipFile(const AZipFilename, AFilename: string; const AVolume: Single; const ALoop: Boolean; const APan: Single; const APassword: string): Boolean;
var
  LIO: AGT_ZipFileIO;
begin
  Result := False;
  LIO := AGT_ZipFileIO.Create();

  if not LIO.Open(AZipFilename, AFilename, APassword) then
  begin
    LIO.Free();
    Exit;
  end;
  Result := PlayMusic(LIO, AFilename, AVolume, ALoop, APan);
end;

class procedure AGT_Audio.UnloadMusic();
begin
  if not IsOpen() then Exit;
  if not FMusic.Loaded then Exit;
  ma_sound_stop(@FMusic.Handle);
  ma_sound_uninit(@FMusic.Handle);
  FMusic.Loaded := False;
end;

class function  AGT_Audio.IsMusicLooping(): Boolean;
begin
  Result := False;
  if not IsOpen() then Exit;
  Result := Boolean(ma_sound_is_looping(@FMusic.Handle));
end;

class procedure AGT_Audio.SetMusicLooping(const ALoop: Boolean);
begin
  if not IsOpen() then Exit;
  ma_sound_set_looping(@FMusic.Handle, Ord(ALoop))
end;

class function  AGT_Audio.MusicVolume(): Single;
begin
  Result := 0;
  if not IsOpen() then Exit;
  Result := FMusic.Volume;
end;

class procedure AGT_Audio.SetMusicVolume(const AVolume: Single);
begin
  if not IsOpen() then Exit;
  FMusic.Volume := AVolume;
  ma_sound_set_volume(@FMusic.Handle, AGT_Math.UnitToScalarValue(AVolume, 1));
end;

class function  AGT_Audio.MusicPan(): Single;
begin
  Result := 0;
  if not IsOpen() then Exit;

  Result := ma_sound_get_pan(@FMusic.Handle);
end;

class procedure AGT_Audio.SetMusicPan(const APan: Single);
begin
  if not IsOpen() then Exit;

  ma_sound_set_pan(@FMusic.Handle, EnsureRange(APan, -1, 1));
end;

class function  AGT_Audio.LoadSound(const AIO: AGT_IO; const AFilename: string): Integer;
var
  LResult: Integer;
begin
  Result := AGT_AUDIO_ERROR;
  if not FOpened then Exit;
  if FPaused then Exit;
  LResult := FindFreeSoundSlot;
  if LResult = AGT_AUDIO_ERROR then Exit;

  FVFS.IO := AIO;
  if ma_sound_init_from_file(@FEngine, AGT_Utils.AsUtf8(AFilename, []), 0, nil, nil,
    @FSound[LResult].Handle) <> MA_SUCCESS then Exit;
  FVFS.IO := nil;
  FSound[LResult].InUse := True;
  Result := LResult;
end;

class function  AGT_Audio.LoadSoundFromFile(const AFilename: string): Integer;
var
  LIO: AGT_FileIO;
begin
  Result := -1;
  if not IsOpen() then Exit;

  LIO := AGT_FileIO.Create();
  try
    if not LIO.Open(AFilename, AGT_iomRead) then Exit;
    Result := LoadSound(LIO, AFilename);
  finally
    LIO.Free();
  end;
end;

class function  AGT_Audio.LoadSoundFromZipFile(const AZipFilename, AFilename: string; const APassword: string): Integer;
var
  LIO: AGT_ZipFileIO;
begin
  Result := -1;
  if not IsOpen() then Exit;

  LIO := AGT_ZipFileIO.Create();
  if not LIO.Open(AZipFilename, AFilename, APassword) then
  begin
    LIO.Free();
    Exit;
  end;

  Result := LoadSound(LIO, AFilename);
end;

class procedure AGT_Audio.UnloadSound(var aSound: Integer);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not InRange(aSound, 0, AGT_AUDIO_SOUND_COUNT-1) then Exit;
  ma_sound_uninit(@FSound[aSound].Handle);
  FSound[aSound].InUse := False;
  aSound := AGT_AUDIO_ERROR;
end;

class procedure AGT_Audio.UnloadAllSounds();
var
  I: Integer;
begin
  if not IsOpen() then Exit;

  // close all channels
  for I := 0 to AGT_AUDIO_CHANNEL_COUNT-1 do
  begin
    if FChannel[I].InUse then
    begin
      ma_sound_stop(@FChannel[I].Handle);
      ma_sound_uninit(@FChannel[I].Handle);
    end;
  end;

  // close all sound buffers
  for I := 0 to AGT_AUDIO_SOUND_COUNT-1 do
  begin
    if FSound[I].InUse then
    begin
      ma_sound_uninit(@FSound[I].Handle);
    end;
  end;

end;

class function  AGT_Audio.PlaySound(const aSound, aChannel: Integer; const AVolume: Single; const ALoop: Boolean): Integer;
var
  LResult: Integer;
begin
  Result := AGT_AUDIO_ERROR;

  if not FOpened then Exit;
  if FPaused then Exit;
  if not InRange(aSound, 0, AGT_AUDIO_SOUND_COUNT-1) then Exit;

  if aChannel = AGT_AUDIO_CHANNEL_DYNAMIC then
    LResult := FindFreeChannelSlot
  else
    begin
      LResult := aChannel;
      if not InRange(aChannel, 0, AGT_AUDIO_CHANNEL_COUNT-1) then Exit;
      StopChannel(LResult);
    end;
  if LResult = AGT_AUDIO_ERROR then Exit;
  if ma_sound_init_copy(@FEngine, @FSound[ASound].Handle, 0, nil,
    @FChannel[LResult].Handle) <> MA_SUCCESS then Exit;
  FChannel[LResult].InUse := True;

  SetChannelVolume(LResult, aVolume);
  SetChannelPosition(LResult, 0, 0);
  SetChannelLoop(LResult, aLoop);

  if ma_sound_start(@FChannel[LResult].Handle) <> MA_SUCCESS then
  begin
    StopChannel(LResult);
    LResult := AGT_AUDIO_ERROR;
  end;

  Result := LResult;
end;

class procedure AGT_Audio.ReserveChannel(const aChannel: Integer; const aReserve: Boolean);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not InRange(aChannel, 0, AGT_AUDIO_CHANNEL_COUNT-1) then Exit;
  FChannel[aChannel].Reserved := aReserve;
end;

class function AGT_Audio.IsChannelReserved(const AChannel: Integer): Boolean;
begin
  Result := False;
  if not FOpened then Exit;
  if FPaused then Exit;
  if not InRange(aChannel, 0, AGT_AUDIO_CHANNEL_COUNT-1) then Exit;
  Result := FChannel[aChannel].Reserved;
end;

class procedure AGT_Audio.StopChannel(const aChannel: Integer);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  ma_sound_uninit(@FChannel[aChannel].Handle);
  FChannel[aChannel].InUse := False;
end;

class procedure AGT_Audio.SetChannelVolume(const aChannel: Integer; const AVolume: Single);
var
  LVolume: Single;
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not InRange(aVolume, 0, 1) then Exit;
  if not ValidChannel(aChannel) then Exit;

  FChannel[aChannel].Volume := aVolume;
  LVolume := AGT_Math.UnitToScalarValue(aVolume, 1);
  ma_sound_set_volume(@FChannel[aChannel].Handle, LVolume);
end;

class function  AGT_Audio.GetChannelVolume(const aChannel: Integer): Single;
begin
Result := 0;
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;
  Result := FChannel[aChannel].Volume;
end;

class procedure AGT_Audio.SetChannelPosition(const aChannel: Integer; const X, Y: Single);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  ma_sound_set_position(@FChannel[aChannel].Handle, X, 0, Y);
end;

class procedure AGT_Audio.SetChannelLoop(const aChannel: Integer;
  const ALoop: Boolean);
begin
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  ma_sound_set_looping(@FChannel[aChannel].Handle, Ord(aLoop));
end;

class function  AGT_Audio.IsChannelLooping(const aChannel: Integer): Boolean;
begin
  Result := False;
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  Result := Boolean(ma_sound_is_looping(@FChannel[aChannel].Handle));
end;

class function  AGT_Audio.IsChannelPlaying(const aChannel: Integer): Boolean;
begin
  Result := False;
  if not FOpened then Exit;
  if FPaused then Exit;
  if not ValidChannel(aChannel) then Exit;

  Result := Boolean(ma_sound_is_playing(@FChannel[aChannel].Handle));
end;

end.
