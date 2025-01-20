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

unit Aurora.Common;

{$I Aurora.Defines.inc}

interface

uses
  WinApi.Windows,
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  Aurora.CLibs;

const
  AGT_DONT_CARE = GLFW_DONT_CARE;

type
  { AGT_HAlign }
  AGT_HAlign = (AGT_haLeft, AGT_haCenter, AGT_haRight);

  { AGT_VAlign }
  AGT_VAlign = (AGT_vaTop, AGT_vaCenter, AGT_vaBottom);

  { TAGTCallback }
  TAGTCallback<T> = record
    Handler: T;
    UserData: Pointer;
  end;

type
  { TAGTVirtualBuffer }
  TAGTVirtualBuffer = class(TCustomMemoryStream)
  protected
    FHandle: THandle;
    FName: string;
    procedure Clear();
  public
    constructor Create(aSize: Cardinal);
    destructor Destroy(); override;
    function Write(const aBuffer; aCount: Longint): Longint; override;
    function Write(const aBuffer: TBytes; aOffset, aCount: Longint): Longint; override;
    procedure SaveToFile(aFilename: string);
    property Name: string read FName;
    function  Eob(): Boolean;
    function  ReadString(): string;
    class function LoadFromFile(const aFilename: string): TAGTVirtualBuffer;
  end;

  { TAGTRingBuffer }
  TAGTRingBuffer<T> = class
  private type
    PType = ^T;
  private
    FBuffer: array of T;
    FReadIndex, FWriteIndex, FCapacity: Integer;
  public
    constructor Create(ACapacity: Integer);
    function Write(const AData: array of T; ACount: Integer): Integer;
    function Read(var AData: array of T; ACount: Integer): Integer;
    function DirectReadPointer(ACount: Integer): Pointer;
    function AvailableBytes(): Integer;
    procedure Clear();
  end;

  { TAGTVirtualRingBuffer }
  TAGTVirtualRingBuffer<T> = class
  private type
    PType = ^T;
  private
    FBuffer: TAGTVirtualBuffer;
    FReadIndex, FWriteIndex, FCapacity: Integer;
    function GetArrayValue(AIndex: Integer): T;
    procedure SetArrayValue(AIndex: Integer; AValue: T);
  public
    constructor Create(ACapacity: Integer);
    destructor Destroy; override;
    function Write(const AData: array of T; ACount: Integer): Integer;
    function Read(var AData: array of T; ACount: Integer): Integer;
    function DirectReadPointer(ACount: Integer): Pointer;
    function AvailableBytes(): Integer;
    procedure Clear();
  end;

  { TAGTTimer }
  PAGTTimer = ^TAGTTimer;
  TAGTTimer = record
  private
    FLastTime: Double;
    FInterval: Double;
    FSpeed: Double;
  public
    class operator Initialize (out ADest: TAGTTimer);
    procedure InitMS(const AValue: Double);
    procedure InitFPS(const AValue: Double);
    function Check(): Boolean;
    procedure Reset();
    function  Speed(): Double;
  end;

  { TAGTBaseObject }
  TAGTBaseObject = class(TObject)
  public
    constructor Create(); virtual;
    destructor Destroy(); override;
  end;

  { TAGTAsyncProc }
  TAGTAsyncProc = reference to procedure;

  { TAGTAsyncThread }
  TAGTAsyncThread = class(TThread)
  protected
    FTask: TAGTAsyncProc;
    FWait: TAGTAsyncProc;
    FFinished: Boolean;
  public
    property TaskProc: TAGTAsyncProc read FTask write FTask;
    property WaitProc: TAGTAsyncProc read FWait write FWait;
    property Finished: Boolean read FFinished;
    constructor Create(); virtual;
    destructor Destroy(); override;
    procedure Execute(); override;
  end;

  { TAGTAsync }
  TAGTAsync = class(TAGTBaseObject)
  protected type
    TBusyData = record
      Name: string;
      Thread: Pointer;
      Flag: Boolean;
      Terminate: Boolean;
    end;
  protected
    FQueue: TList<TAGTAsyncThread>;
    FBusy: TDictionary<string, TBusyData>;
  public
    constructor Create(); override;
    destructor Destroy(); override;
    procedure Clear();
    procedure Process();
    procedure Exec(const AName: string; const ABackgroundTask: TAGTAsyncProc; const AWaitForgroundTask: TAGTAsyncProc);
    function  Busy(const AName: string): Boolean;
    procedure SetTerminate(const AName: string; const ATerminate: Boolean);
    function  ShouldTerminate(const AName: string): Boolean;
    procedure TerminateAll();
    procedure WaitForAllToTerminate();
    procedure Suspend();
    procedure Resume();
    procedure Enter();
    procedure Leave();
  end;

implementation

uses
  Aurora.Utils;

{ TAGTVirtualBuffer }
procedure TAGTVirtualBuffer.Clear();
begin
  if (Memory <> nil) then
  begin
    if not UnmapViewOfFile(Memory) then
      raise Exception.Create('Error deallocating mapped memory');
  end;

  if (FHandle <> 0) then
  begin
    if not CloseHandle(FHandle) then
      raise Exception.Create('Error freeing memory mapping handle');
  end;
end;

constructor TAGTVirtualBuffer.Create(aSize: Cardinal);
var
  P: Pointer;
begin
  inherited Create;
  FName := TPath.GetGUIDFileName;
  FHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, aSize, PChar(FName));
  if FHandle = 0 then
    begin
      Clear;
      raise Exception.Create('Error creating memory mapping');
      FHandle := 0;
    end
  else
    begin
      P := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
      if P = nil then
        begin
          Clear;
          raise Exception.Create('Error creating memory mapping');
        end
      else
        begin
          Self.SetPointer(P, aSize);
          Position := 0;
        end;
    end;
end;

destructor TAGTVirtualBuffer.Destroy();
begin
  Clear;
  inherited;
end;

function TAGTVirtualBuffer.Write(const aBuffer; aCount: Longint): Longint;
var
  LPos: Int64;
begin
  if (Position >= 0) and (aCount >= 0) then
  begin
    LPos := Position + aCount;
    if LPos > 0 then
    begin
      if LPos > Size then
      begin
        Result := 0;
        Exit;
      end;
      System.Move(aBuffer, (PByte(Memory) + Position)^, aCount);
      Position := LPos;
      Result := aCount;
      Exit;
    end;
  end;
  Result := 0;
end;

function TAGTVirtualBuffer.Write(const aBuffer: TBytes; aOffset, aCount: Longint): Longint;
var
  LPos: Int64;
begin
  if (Position >= 0) and (aCount >= 0) then
  begin
    LPos := Position + aCount;
    if LPos > 0 then
    begin
      if LPos > Size then
      begin
        Result := 0;
        Exit;
      end;
      System.Move(aBuffer[aOffset], (PByte(Memory) + Position)^, aCount);
      Position := LPos;
      Result := aCount;
      Exit;
    end;
  end;
  Result := 0;
end;

procedure TAGTVirtualBuffer.SaveToFile(aFilename: string);
var
  LStream: TFileStream;
begin
  LStream := TFile.Create(aFilename);
  try
    LStream.Write(Memory^, Size);
  finally
    LStream.Free;
  end;
end;

class function TAGTVirtualBuffer.LoadFromFile(const aFilename: string): TAGTVirtualBuffer;
var
  LStream: TStream;
  LBuffer: TAGTVirtualBuffer;
begin
  Result := nil;
  if aFilename.IsEmpty then Exit;
  if not TFile.Exists(aFilename) then Exit;
  LStream := TFile.OpenRead(aFilename);
  try
    LBuffer := TAGTVirtualBuffer.Create(LStream.Size);
    if LBuffer <> nil then
    begin
      LBuffer.CopyFrom(LStream);
    end;
  finally
    FreeAndNil(LStream);
  end;
  Result := LBuffer;
end;

function  TAGTVirtualBuffer.Eob(): Boolean;
begin
  Result := Boolean(Position >= Size);
end;

function  TAGTVirtualBuffer.ReadString(): string;
var
  LLength: LongInt;
begin
  Read(LLength, SizeOf(LLength));
  SetLength(Result, LLength);
  if LLength > 0 then Read(Result[1], LLength * SizeOf(Char));
end;

{ TAGTRingBuffer }
constructor TAGTRingBuffer<T>.Create(ACapacity: Integer);
begin
  SetLength(FBuffer, ACapacity);
  FReadIndex := 0;
  FWriteIndex := 0;
  FCapacity := ACapacity;
  Clear;
end;

function TAGTRingBuffer<T>.Write(const AData: array of T; ACount: Integer): Integer;
var
  i, WritePos: Integer;
begin
  AGT_Utils.EnterCriticalSection();
  try
    for i := 0 to ACount - 1 do
    begin
      WritePos := (FWriteIndex + i) mod FCapacity;
      FBuffer[WritePos] := AData[i];
    end;
    FWriteIndex := (FWriteIndex + ACount) mod FCapacity;
    Result := ACount;
  finally
    AGT_Utils.LeaveCriticalSection();
  end;
end;

function TAGTRingBuffer<T>.Read(var AData: array of T; ACount: Integer): Integer;
var
  i, ReadPos: Integer;
begin
  for i := 0 to ACount - 1 do
  begin
    ReadPos := (FReadIndex + i) mod FCapacity;
    AData[i] := FBuffer[ReadPos];
  end;
  FReadIndex := (FReadIndex + ACount) mod FCapacity;
  Result := ACount;
end;

function TAGTRingBuffer<T>.DirectReadPointer(ACount: Integer): Pointer;
begin
  Result := @FBuffer[FReadIndex mod FCapacity];
  FReadIndex := (FReadIndex + ACount) mod FCapacity;
end;

function TAGTRingBuffer<T>.AvailableBytes(): Integer;
begin
  Result := (FCapacity + FWriteIndex - FReadIndex) mod FCapacity;
end;

procedure TAGTRingBuffer<T>.Clear();
var
  I: Integer;
begin

  AGT_Utils.EnterCriticalSection();
  try
    for I := Low(FBuffer) to High(FBuffer) do
    begin
     FBuffer[i] := Default(T);
    end;

    FReadIndex := 0;
    FWriteIndex := 0;
  finally
    AGT_Utils.LeaveCriticalSection();
  end;
end;

{ TAGTVirtualRingBuffer }
function TAGTVirtualRingBuffer<T>.GetArrayValue(AIndex: Integer): T;
begin
  Result := PType(PByte(FBuffer.Memory) + AIndex * SizeOf(T))^;
end;

procedure TAGTVirtualRingBuffer<T>.SetArrayValue(AIndex: Integer; AValue: T);
begin
  PType(PByte(FBuffer.Memory) + AIndex * SizeOf(T))^ := AValue;
end;

constructor TAGTVirtualRingBuffer<T>.Create(ACapacity: Integer);
begin
  FBuffer := TAGTVirtualBuffer.Create(ACapacity*SizeOf(T));
  FReadIndex := 0;
  FWriteIndex := 0;
  FCapacity := ACapacity;
  Clear;
end;

destructor TAGTVirtualRingBuffer<T>.Destroy;
begin
  FBuffer.Free;
  inherited;
end;

function TAGTVirtualRingBuffer<T>.Write(const AData: array of T; ACount: Integer): Integer;
var
  i, WritePos: Integer;
begin
  AGT_Utils.EnterCriticalSection();
  try
    for i := 0 to ACount - 1 do
    begin
      WritePos := (FWriteIndex + i) mod FCapacity;
      SetArrayValue(WritePos, AData[i]);
    end;
    FWriteIndex := (FWriteIndex + ACount) mod FCapacity;
    Result := ACount;
  finally
    AGT_Utils.LeaveCriticalSection();
  end;
end;

function TAGTVirtualRingBuffer<T>.Read(var AData: array of T; ACount: Integer): Integer;
var
  i, ReadPos: Integer;
begin
  for i := 0 to ACount - 1 do
  begin
    ReadPos := (FReadIndex + i) mod FCapacity;
    AData[i] := GetArrayValue(ReadPos);
  end;
  FReadIndex := (FReadIndex + ACount) mod FCapacity;
  Result := ACount;
end;

function TAGTVirtualRingBuffer<T>.DirectReadPointer(ACount: Integer): Pointer;
begin
  Result := PType(PByte(FBuffer.Memory) + (FReadIndex mod FCapacity) * SizeOf(T));
  FReadIndex := (FReadIndex + ACount) mod FCapacity;
end;

function TAGTVirtualRingBuffer<T>.AvailableBytes(): Integer;
begin
  Result := (FCapacity + FWriteIndex - FReadIndex) mod FCapacity;
end;

procedure TAGTVirtualRingBuffer<T>.Clear();
var
  I: Integer;
begin

  AGT_Utils.EnterCriticalSection();
  try
    for I := 0 to FCapacity-1 do
    begin
     SetArrayValue(I, Default(T));
    end;

    FReadIndex := 0;
    FWriteIndex := 0;
  finally
    AGT_Utils.LeaveCriticalSection();
  end;
end;

{ TAGTTimer }
class operator TAGTTimer.Initialize (out ADest: TAGTTimer);
begin
  ADest.FLastTime := 0;
  ADest.FInterval := 0;
  ADest.FSpeed := 0;
end;

procedure TAGTTimer.InitMS(const AValue: Double);
begin
  FInterval := AValue / 1000.0; // convert milliseconds to seconds
  FLastTime := glfwGetTime;
  FSpeed := AValue;
end;

procedure TAGTTimer.InitFPS(const AValue: Double);
begin
  if AValue > 0 then
    FInterval := 1.0 / AValue
  else
    FInterval := 0; // Prevent division by zero if FPS is not positive
  FLastTime := glfwGetTime;
  FSpeed := AValue;
end;

function TAGTTimer.Check(): Boolean;
begin
  Result := (glfwGetTime - FLastTime) >= FInterval;
  if Result then
    FLastTime := glfwGetTime; // Auto-reset on check
end;

procedure TAGTTimer.Reset();
begin
  FLastTime := glfwGetTime;
end;

function  TAGTTimer.Speed(): Double;
begin
  Result := FSpeed;
end;

{ TAGTBaseObject }
constructor TAGTBaseObject.Create();
begin
  inherited;
end;

destructor TAGTBaseObject.Destroy();
begin
  inherited;
end;

{ TAGTAsyncThread }
constructor TAGTAsyncThread.Create();
begin
  inherited Create(True);

  FTask := nil;
  FWait := nil;
  FFinished := False;
end;

destructor TAGTAsyncThread.Destroy();
begin
  inherited;
end;

procedure TAGTAsyncThread.Execute();
begin
  FFinished := False;

  if Assigned(FTask) then
  begin
    FTask();
  end;

  FFinished := True;
end;

{ TAGTAsync }
constructor TAGTAsync.Create();
begin
  inherited;

  FQueue := TList<TAGTAsyncThread>.Create;
  FBusy := TDictionary<string, TBusyData>.Create;
end;

destructor TAGTAsync.Destroy();
begin

  FBusy.Free();
  FQueue.Free();

  inherited;
end;

procedure TAGTAsync.Clear();
begin
  WaitForAllToTerminate();
  FBusy.Clear();
  FQueue.Clear();
end;

procedure TAGTAsync.Process();
var
  LAsyncThread: TAGTAsyncThread;
  LAsyncThread2: TAGTAsyncThread;
  LIndex: TBusyData;
  LBusy: TBusyData;
begin
  Enter();

  if TThread.CurrentThread.ThreadID = MainThreadID then
  begin
    for LAsyncThread in FQueue do
    begin
      if Assigned(LAsyncThread) then
      begin
        if LAsyncThread.Finished then
        begin
          LAsyncThread.WaitFor();
          if Assigned(LAsyncThread.WaitProc) then
            LAsyncThread.WaitProc();
          FQueue.Remove(LAsyncThread);
          for LIndex in FBusy.Values do
          begin
            if Lindex.Thread = LAsyncThread then
            begin
              LBusy := LIndex;
              LBusy.Flag := False;
              FBusy.AddOrSetValue(LBusy.Name, LBusy);
              Break;
            end;
          end;
          LAsyncThread2 := LAsyncThread;
          FreeAndNil(LAsyncThread2);
        end;
      end;
    end;
    FQueue.Pack;
  end;

  Leave();
end;

procedure TAGTAsync.Exec(const AName: string; const ABackgroundTask: TAGTAsyncProc; const AWaitForgroundTask: TAGTAsyncProc);
var
  LAsyncThread: TAGTAsyncThread;
  LBusy: TBusyData;
begin
  if not Assigned(ABackgroundTask) then Exit;
  if AName.IsEmpty then Exit;
  if Busy(AName) then Exit;
  Enter;
  LAsyncThread := TAGTAsyncThread.Create;
  LAsyncThread.TaskProc := ABackgroundTask;
  LAsyncThread.WaitProc := AWaitForgroundTask;
  FQueue.Add(LAsyncThread);
  LBusy.Name := AName;
  LBusy.Thread := LAsyncThread;
  LBusy.Flag := True;
  LBusy.Terminate := False;
  FBusy.AddOrSetValue(AName, LBusy);
  LAsyncThread.Start;
  Leave;
end;

function  TAGTAsync.Busy(const AName: string): Boolean;
var
  LBusy: TBusyData;
begin
  Result := False;
  if AName.IsEmpty then Exit;
  Enter;
  FBusy.TryGetValue(AName, LBusy);
  Leave;
  Result := LBusy.Flag;
end;

procedure TAGTAsync.SetTerminate(const AName: string; const ATerminate: Boolean);
var
  LBusy: TBusyData;
begin
  if AName.IsEmpty then Exit;
  Enter();
  FBusy.TryGetValue(AName, LBusy);
  LBusy.Terminate := ATerminate;
  FBusy.AddOrSetValue(AName, LBusy);
  Leave();
end;

function  TAGTAsync.ShouldTerminate(const AName: string): Boolean;
var
  LBusy: TBusyData;
begin
  Result := False;
  if AName.IsEmpty then Exit;
  Enter();
  FBusy.TryGetValue(AName, LBusy);
  Result := LBusy.Terminate;
  Leave();
end;

procedure TAGTAsync.TerminateAll();
var
  LBusy: TPair<string, TBusyData>;
begin
  for LBusy in FBusy do
  begin
    SetTerminate(LBusy.Key, True);
  end;
end;

procedure TAGTAsync.WaitForAllToTerminate();
var
  LDone: Boolean;
begin
  TerminateAll();
  Resume();
  LDone := False;
  while not LDone do
  begin
    if FQueue.Count = 0 then
      Break;
    Process();
    Sleep(0);
  end;
end;

procedure TAGTAsync.Suspend();
var
  LAsyncThread: TAGTAsyncThread;
begin
  for LAsyncThread in FQueue do
  begin
    if not LAsyncThread.Suspended then
      LAsyncThread.Suspend;
  end;
end;

procedure TAGTAsync.Resume();
var
  LAsyncThread: TAGTAsyncThread;
begin
  for LAsyncThread in FQueue do
  begin
    if LAsyncThread.Suspended then
      LAsyncThread.Resume;
  end;
end;

procedure TAGTAsync.Enter();
begin
  AGT_Utils.EnterCriticalSection();
end;

procedure TAGTAsync.Leave();
begin
  AGT_Utils.LeaveCriticalSection();
end;



end.
