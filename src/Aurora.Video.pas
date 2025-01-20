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

unit Aurora.Video;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Math,
  Aurora.CLibs,
  Aurora.OpenGL,
  Aurora.Common,
  Aurora.Color,
  Aurora.Math,
  Aurora.Utils,
  Aurora.IO,
  Aurora.FileIO,
  Aurora.ZipFileIO,
  Aurora.Window,
  Aurora.Texture;


type
  { AGT_VideoStatus }
  AGT_VideoStatus = (AGT_vsStopped, AGT_vsPlaying);

  { AGT_VideoStatusCallback }
  AGT_VideoStatusCallback = procedure(const AStatus: AGT_VideoStatus; const AFilename: PWideChar; const AUserData: Pointer); cdecl;

  { AGT_Video }
  AGT_Video = class
  private const
    BUFFERSIZE = 1024;
    CSampleSize = 2304;
    CSampleRate = 44100;
  private class var
    FIO: AGT_IO;
    FStatus: AGT_VideoStatus;
    FStatusFlag: Boolean;
    FStaticPlmBuffer: array[0..BUFFERSIZE] of byte;
    FRingBuffer: TAGTVirtualRingBuffer<Single>;
    FDeviceConfig: ma_device_config;
    FDevice: ma_device;
    FPLM: Pplm_t;
    FVolume: Single;
    FLoop: Boolean;
    FRGBABuffer: array of uint8;
    FTexture: AGT_Texture;
    FCallback: TAGTCallback<AGT_VideoStatusCallback>;
    FFilename: string;
    class procedure OnStatusCallback(); static;
    class constructor Create();
    class destructor Destroy();
  public
    class procedure UnitInit; static;
    class function  GetStatusCallback(): AGT_VideoStatusCallback; static;
    class procedure SetStatusCallback(const AHandler: AGT_VideoStatusCallback; const AUserData: Pointer); static;
    class function  Play(const AIO: AGT_IO; const AFilename: string; const AVolume: Single; const ALoop: Boolean): Boolean; static;
    class function  PlayFromZipFile(const AZipFilename, AFilename: string; const AVolume: Single; const ALoop: Boolean; const APassword: string=AGT_DEFAULT_ZIPFILE_PASSWORD): Boolean; static;
    class procedure Stop(); static;
    class function  Update(const AWindow: AGT_Window): Boolean; static;
    class procedure Draw(const AWindow: AGT_Window; const X, Y, AScale: Single); static;
    class function  Status(): AGT_VideoStatus; static;
    class function  Volume(): Single; static;
    class procedure SetVolume(const AVolume: Single); static;
    class function  IsLooping(): Boolean; static;
    class procedure SetLooping(const ALoop: Boolean); static;
    class function  GetTexture(): AGT_Texture; static;
  end;

//=== EXPORTS ===============================================================
function  AGT_Video_GetStatusCallback(): AGT_VideoStatusCallback; cdecl; exports AGT_Video_GetStatusCallback;
procedure AGT_Video_SetStatusCallback(const AHandler: AGT_VideoStatusCallback; const AUserData: Pointer); cdecl; exports AGT_Video_SetStatusCallback;
function  AGT_Video_Play(const AIO: AGT_IO; const AFilename: PWideChar; const AVolume: Single; const ALoop: Boolean): Boolean; cdecl; exports AGT_Video_Play;
function  AGT_Video_PlayFromZipFile(const AZipFilename, AFilename, APassword: PWideChar; const AVolume: Single; const ALoop: Boolean): Boolean; cdecl; exports AGT_Video_PlayFromZipFile;
procedure AGT_Video_Stop(); cdecl; exports AGT_Video_Stop;
function  AGT_Video_Update(const AWindow: AGT_Window): Boolean; cdecl; exports AGT_Video_Update;
procedure AGT_Video_Draw(const AWindow: AGT_Window; const X, Y, AScale: Single); cdecl; exports AGT_Video_Draw;
function  AGT_Video_Status(): AGT_VideoStatus; cdecl; exports AGT_Video_Status;
function  AGT_Video_Volume(): Single; cdecl; exports AGT_Video_Volume;
procedure AGT_Video_SetVolume(const AVolume: Single); cdecl; exports AGT_Video_SetVolume;
function  AGT_Video_IsLooping(): Boolean; cdecl; exports AGT_Video_IsLooping;
procedure AGT_Video_SetLooping(const ALoop: Boolean); cdecl; exports AGT_Video_SetLooping;
function  AGT_Video_GetTexture(): AGT_Texture; cdecl; exports AGT_Video_GetTexture;

implementation

//=== EXPORTS ===============================================================
function  AGT_Video_GetStatusCallback(): AGT_VideoStatusCallback;
begin
  Result := AGT_Video.GetStatusCallback();
end;

procedure AGT_Video_SetStatusCallback(const AHandler: AGT_VideoStatusCallback; const AUserData: Pointer);
begin
  AGT_Video.SetStatusCallback(AHandler, AUserData);
end;

function  AGT_Video_Play(const AIO: AGT_IO; const AFilename: PWideChar; const AVolume: Single; const ALoop: Boolean): Boolean;
begin
  Result := AGT_Video.Play(AIO, AFilename, AVolume, ALoop);
end;

function  AGT_Video_PlayFromZipFile(const AZipFilename, AFilename, APassword: PWideChar; const AVolume: Single; const ALoop: Boolean): Boolean;
begin
  Result := AGT_Video.PlayFromZipFile(string(AZipFilename), string(AFilename), AVolume, ALoop, string(APassword));
end;

procedure AGT_Video_Stop();
begin
  AGT_Video.Stop();
end;

function  AGT_Video_Update(const AWindow: AGT_Window): Boolean;
begin
  Result := AGT_Video.Update(AWindow);
end;

procedure AGT_Video_Draw(const AWindow: AGT_Window; const X, Y, AScale: Single);
begin
  AGT_Video.Draw(AWindow, X, Y, AScale);
end;

function  AGT_Video_Status(): AGT_VideoStatus;
begin
  Result := AGT_Video.Status();
end;

function  AGT_Video_Volume(): Single;
begin
  Result := AGT_Video.Volume();
end;

procedure AGT_Video_SetVolume(const AVolume: Single);
begin
  AGT_Video.SetVolume(AVolume);
end;

function  AGT_Video_IsLooping(): Boolean;
begin
  Result := AGT_Video.IsLooping();
end;

procedure AGT_Video_SetLooping(const ALoop: Boolean);
begin
  AGT_Video.SetLooping(ALoop);
end;

function  AGT_Video_GetTexture(): AGT_Texture;
begin
  Result := AGT_Video.GetTexture();
end;

{ AGT_Video }
procedure TVideo_MADataCallback(ADevice: Pma_device; AOutput: Pointer; AInput: Pointer; AFrameCount: ma_uint32); cdecl;
var
  LReadPtr: PSingle;
  LFramesNeeded: Integer;
begin
  LFramesNeeded := AFrameCount * 2;
  LReadPtr := PSingle(AGT_Video.FRingBuffer.DirectReadPointer(LFramesNeeded));

  if AGT_Video.FRingBuffer.AvailableBytes >= LFramesNeeded then
    begin
      Move(LReadPtr^, AOutput^, LFramesNeeded * SizeOf(Single));
    end
  else
    begin
      FillChar(AOutput^, LFramesNeeded * SizeOf(Single), 0);
    end;
end;

procedure TVideo_PLMAudioDecodeCallback(APLM: Pplm_t; ASamples: Pplm_samples_t; AUserData: Pointer); cdecl;
begin
  AGT_Video.FRingBuffer.Write(ASamples^.interleaved, ASamples^.count*2);
end;

procedure TVideo_PLMVideoDecodeCallback(APLM: Pplm_t; AFrame: Pplm_frame_t; AUserData: Pointer); cdecl;
begin
  // convert YUV to RGBA

  plm_frame_to_rgba(AFrame, @AGT_Video.FRGBABuffer[0], Round(AGT_Video.GetTexture().GetSize().w*4));

  // update OGL texture
  glBindTexture(GL_TEXTURE_2D, AGT_Video.FTexture.GetHandle());
  glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, AFrame^.width, AFrame^.height, GL_RGBA, GL_UNSIGNED_BYTE, AGT_Video.FRGBABuffer);
end;

procedure TVideo_PLMLoadBufferCallback(ABuffer: pplm_buffer_t; AUserData: pointer); cdecl;
var
  LBytesRead: Int64;
begin
  // read data from inputstream
  LBytesRead := AGT_Video.FIO.Read(@AGT_Video.FStaticPlmBuffer[0], AGT_Video.BUFFERSIZE);

  // push LBytesRead to PLM buffer
  if LBytesRead > 0 then
    begin
      plm_buffer_write(aBuffer, @AGT_Video.FStaticPlmBuffer[0], LBytesRead);
    end
  else
    begin
      // set status to stopped
      AGT_Video.FStatus := AGT_vsStopped;
      AGT_Video.FStatusFlag := True;
    end;
end;

class procedure AGT_Video.OnStatusCallback();
begin
  if Assigned(FCallback.Handler) then
  begin
    FCallback.Handler(FStatus, PWideChar(FFilename), FCallback.UserData);
  end;
end;

class procedure AGT_Video.UnitInit;
begin
end;

class constructor AGT_Video.Create();
begin
end;

class destructor AGT_Video.Destroy();
begin
  Stop();

end;

class function  AGT_Video.GetStatusCallback(): AGT_VideoStatusCallback;
begin
  Result := FCallback.Handler;
end;

class procedure AGT_Video.SetStatusCallback(const AHandler: AGT_VideoStatusCallback; const AUserData: Pointer);
begin
  FCallback.Handler := AHandler;
  FCallback.UserData := AUserData;
end;

class function  AGT_Video.Play(const AIO: AGT_IO;  const AFilename: string; const AVolume: Single; const ALoop: Boolean): Boolean;
var
  LBuffer: Pplm_buffer_t;
begin
  Result := False;

  Stop();

  // set volume & loop status
  FVolume := AVolume;
  FLoop := ALoop;

  // init ringbuffer
  FRingBuffer := TAGTVirtualRingBuffer<Single>.Create(CSampleRate);
  if not Assigned(FRingBuffer) then Exit;

  // init device for audio playback
  FDeviceConfig := ma_device_config_init(ma_device_type_playback);
  FDeviceConfig.playback.format := ma_format_f32;
  FDeviceConfig.playback.channels := 2;
  FDeviceConfig.sampleRate := CSampleRate;
  FDeviceConfig.dataCallback := @TVideo_MADataCallback;
  if ma_device_init(nil, @FDeviceConfig, @FDevice) <> MA_SUCCESS then Exit;
  ma_device_start(@FDevice);
  SetVolume(AVolume);

  // set the input stream
  FIO := AIO;
  FFilename := AFilename;
  FStatus := AGT_vsPlaying;
  FStatusFlag := False;
  OnStatusCallback();

  // init plm buffer
  LBuffer := plm_buffer_create_with_capacity(BUFFERSIZE);
  if not Assigned(LBuffer) then
  begin
    ma_device_uninit(@FDevice);
    FRingBuffer.Free;
    Exit;
  end;

  plm_buffer_set_load_callback(LBuffer, TVideo_PLMLoadBufferCallback, AGT_Video);
  FPLM := plm_create_with_buffer(LBuffer, 1);
  if not Assigned(FPLM) then
  begin
    plm_buffer_destroy(LBuffer);
    ma_device_uninit(@FDevice);
    FRingBuffer.Free;
    Exit;
  end;

  // create video render texture
  FTexture := AGT_Texture.Create;
  FTexture.SetBlend(AGT_tbNone);
  FTexture.Alloc(plm_get_width(FPLM), plm_get_height(FPLM));

  // alloc the video rgba buffer
  SetLength(FRGBABuffer,
    Round(FTexture.GetSize.w*FTexture.GetSize.h*4));
  if not Assigned(FRGBABuffer) then
  begin
    plm_buffer_destroy(LBuffer);
    ma_device_uninit(@FDevice);
    FRingBuffer.Free;
    Exit;
  end;

  // set the audio lead time
  plm_set_audio_lead_time(FPLM, (CSampleSize*2)/FDeviceConfig.sampleRate);

  // set audio/video callbacks
  plm_set_audio_decode_callback(FPLM, TVideo_PLMAudioDecodeCallback, AGT_Video);
  plm_set_video_decode_callback(FPLM, TVideo_PLMVideoDecodeCallback, AGT_Video);

  FTexture.SetPivot(0, 0);
  FTexture.SetAnchor(0, 0);
  FTexture.SetBlend(AGT_tbNone);

  // return OK
  Result := True;
end;

class function  AGT_Video.PlayFromZipFile(const AZipFilename, AFilename: string; const AVolume: Single; const ALoop: Boolean; const APassword: string): Boolean;
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

  Result := Play(LIO, AFilename, AVolume, ALoop);
end;

class procedure AGT_Video.Stop();
begin
  if not Assigned(FPLM) then Exit;

  ma_device_stop(@FDevice);
  ma_device_uninit(@FDevice);

  plm_destroy(FPLM);

  //FIO.Free;
  FIO.Free();
  FTexture.Free;
  FRingBuffer.Free;

  FPLM := nil;
  FRingBuffer := nil;
  FStatus := AGT_vsStopped;
  FTexture := nil;
end;

class function  AGT_Video.Update(const AWindow: AGT_Window): Boolean;
begin
  Result := False;
  if not Assigned(FPLM) then Exit;
  if FStatusFlag then
  begin
    FStatusFlag := False;
    OnStatusCallback();
  end;

  if FStatus = AGT_vsStopped then
  begin
    ma_device_stop(@FDevice);

    if FLoop then
    begin
      plm_rewind(FPLM);
      FIO.Seek(0, AGT_iosStart);
      FRingBuffer.Clear;
      ma_device_start(@FDevice);
      SetVolume(FVolume);
      FStatus := AGT_vsPlaying;
      plm_decode(FPLM, AWindow.GetTargetTime());
      OnStatusCallback();
      Exit;
    end;
    Result := True;
    Exit;
  end;

  plm_decode(FPLM, AWindow.GetTargetTime());
end;

class procedure AGT_Video.Draw(const AWindow: AGT_Window; const X, Y, AScale: Single);
begin
  if FStatus <> AGT_vsPlaying then Exit;
  FTexture.SetPos(X, Y);
  FTexture.SetScale(AScale);
  FTexture.Draw(AWindow);
end;

class function  AGT_Video.Status(): AGT_VideoStatus;
begin
  Result := FStatus;
end;

class function  AGT_Video.Volume(): Single;
begin
  Result := FVolume;
end;

class procedure AGT_Video.SetVolume(const AVolume: Single);
begin
  FVolume := EnsureRange(AVolume, 0, 1);
  ma_device_set_master_volume(@FDevice, AGT_Math.UnitToScalarValue(FVolume, 1));
end;

class function  AGT_Video.IsLooping(): Boolean;
begin
  Result := FLoop;
end;

class procedure AGT_Video.SetLooping(const ALoop: Boolean);
begin
  FLoop := ALoop;
end;

class function  AGT_Video.GetTexture(): AGT_Texture;
begin
  Result := FTexture;
end;

end.
