library AGT;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters.

  Important note about VCL usage: when this DLL will be implicitly
  loaded and this DLL uses TWicImage / TImageCollection created in
  any unit initialization section, then Vcl.WicImageInit must be
  included into your library's USES clause. }

uses
  System.SysUtils,
  System.Classes,
  Aurora.CLibs in 'Aurora.CLibs.pas',
  Aurora.OpenGL in 'Aurora.OpenGL.pas',
  Aurora.Audio in 'Aurora.Audio.pas',
  Aurora.Camera in 'Aurora.Camera.pas',
  Aurora.Color in 'Aurora.Color.pas',
  Aurora.Common in 'Aurora.Common.pas',
  Aurora.ConfigFile in 'Aurora.ConfigFile.pas',
  Aurora.Console in 'Aurora.Console.pas',
  Aurora.Entity in 'Aurora.Entity.pas',
  Aurora.Error in 'Aurora.Error.pas',
  Aurora.FileIO in 'Aurora.FileIO.pas',
  Aurora.Font in 'Aurora.Font.pas',
  Aurora.IO in 'Aurora.IO.pas',
  Aurora.Math in 'Aurora.Math.pas',
  Aurora.Sprite in 'Aurora.Sprite.pas',
  Aurora.Texture in 'Aurora.Texture.pas',
  Aurora.Utils in 'Aurora.Utils.pas',
  Aurora.Video in 'Aurora.Video.pas',
  Aurora.Window in 'Aurora.Window.pas',
  Aurora.ZipFileIO in 'Aurora.ZipFileIO.pas',
  Aurora.MemoryIO in 'Aurora.MemoryIO.pas',
  Aurora in 'Aurora.pas';

{$R *.res}

begin
end.
