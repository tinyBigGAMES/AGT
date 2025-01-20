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


unit Aurora.Color;

{$I Aurora.Defines.inc}

interface

uses
  System.Math;

type
  { AGT_Color }
  PAGT_Color = ^AGT_Color;
  AGT_Color = record
    r,g,b,a: Single;
    function  FromByte(const r, g, b, a: Byte): AGT_Color;
    function  FromFloat(const r, g, b, a: Single): AGT_Color;
    function  Fade(const ATo: AGT_Color; const APos: Single): AGT_Color;
    function  IsEqual(const AColor: AGT_Color): Boolean;
  end;

const
  AGT_ALICEBLUE           : AGT_Color = (r:$F0/$FF; g:$F8/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_ANTIQUEWHITE        : AGT_Color = (r:$FA/$FF; g:$EB/$FF; b:$D7/$FF; a:$FF/$FF);
  AGT_AQUA                : AGT_Color = (r:$00/$FF; g:$FF/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_AQUAMARINE          : AGT_Color = (r:$7F/$FF; g:$FF/$FF; b:$D4/$FF; a:$FF/$FF);
  AGT_AZURE               : AGT_Color = (r:$F0/$FF; g:$FF/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_BEIGE               : AGT_Color = (r:$F5/$FF; g:$F5/$FF; b:$DC/$FF; a:$FF/$FF);
  AGT_BISQUE              : AGT_Color = (r:$FF/$FF; g:$E4/$FF; b:$C4/$FF; a:$FF/$FF);
  AGT_BLACK               : AGT_Color = (r:$00/$FF; g:$00/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_BLANCHEDALMOND      : AGT_Color = (r:$FF/$FF; g:$EB/$FF; b:$CD/$FF; a:$FF/$FF);
  AGT_BLUE                : AGT_Color = (r:$00/$FF; g:$00/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_BLUEVIOLET          : AGT_Color = (r:$8A/$FF; g:$2B/$FF; b:$E2/$FF; a:$FF/$FF);
  AGT_BROWN               : AGT_Color = (r:$A5/$FF; g:$2A/$FF; b:$2A/$FF; a:$FF/$FF);
  AGT_BURLYWOOD           : AGT_Color = (r:$DE/$FF; g:$B8/$FF; b:$87/$FF; a:$FF/$FF);
  AGT_CADETBLUE           : AGT_Color = (r:$5F/$FF; g:$9E/$FF; b:$A0/$FF; a:$FF/$FF);
  AGT_CHARTREUSE          : AGT_Color = (r:$7F/$FF; g:$FF/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_CHOCOLATE           : AGT_Color = (r:$D2/$FF; g:$69/$FF; b:$1E/$FF; a:$FF/$FF);
  AGT_CORAL               : AGT_Color = (r:$FF/$FF; g:$7F/$FF; b:$50/$FF; a:$FF/$FF);
  AGT_CORNFLOWERBLUE      : AGT_Color = (r:$64/$FF; g:$95/$FF; b:$ED/$FF; a:$FF/$FF);
  AGT_CORNSILK            : AGT_Color = (r:$FF/$FF; g:$F8/$FF; b:$DC/$FF; a:$FF/$FF);
  AGT_CRIMSON             : AGT_Color = (r:$DC/$FF; g:$14/$FF; b:$3C/$FF; a:$FF/$FF);
  AGT_CYAN                : AGT_Color = (r:$00/$FF; g:$FF/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_DARKBLUE            : AGT_Color = (r:$00/$FF; g:$00/$FF; b:$8B/$FF; a:$FF/$FF);
  AGT_DARKCYAN            : AGT_Color = (r:$00/$FF; g:$8B/$FF; b:$8B/$FF; a:$FF/$FF);
  AGT_DARKGOLDENROD       : AGT_Color = (r:$B8/$FF; g:$86/$FF; b:$0B/$FF; a:$FF/$FF);
  AGT_DARKGRAY            : AGT_Color = (r:$A9/$FF; g:$A9/$FF; b:$A9/$FF; a:$FF/$FF);
  AGT_DARKGREEN           : AGT_Color = (r:$00/$FF; g:$64/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_DARKGREY            : AGT_Color = (r:$A9/$FF; g:$A9/$FF; b:$A9/$FF; a:$FF/$FF);
  AGT_DARKKHAKI           : AGT_Color = (r:$BD/$FF; g:$B7/$FF; b:$6B/$FF; a:$FF/$FF);
  AGT_DARKMAGENTA         : AGT_Color = (r:$8B/$FF; g:$00/$FF; b:$8B/$FF; a:$FF/$FF);
  AGT_DARKOLIVEGREEN      : AGT_Color = (r:$55/$FF; g:$6B/$FF; b:$2F/$FF; a:$FF/$FF);
  AGT_DARKORANGE          : AGT_Color = (r:$FF/$FF; g:$8C/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_DARKORCHID          : AGT_Color = (r:$99/$FF; g:$32/$FF; b:$CC/$FF; a:$FF/$FF);
  AGT_DARKRED             : AGT_Color = (r:$8B/$FF; g:$00/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_DARKSALMON          : AGT_Color = (r:$E9/$FF; g:$96/$FF; b:$7A/$FF; a:$FF/$FF);
  AGT_DARKSEAGREEN        : AGT_Color = (r:$8F/$FF; g:$BC/$FF; b:$8F/$FF; a:$FF/$FF);
  AGT_DARKSLATEBLUE       : AGT_Color = (r:$48/$FF; g:$3D/$FF; b:$8B/$FF; a:$FF/$FF);
  AGT_DARKSLATEGRAY       : AGT_Color = (r:$2F/$FF; g:$4F/$FF; b:$4F/$FF; a:$FF/$FF);
  AGT_DARKSLATEGREY       : AGT_Color = (r:$2F/$FF; g:$4F/$FF; b:$4F/$FF; a:$FF/$FF);
  AGT_DARKTURQUOISE       : AGT_Color = (r:$00/$FF; g:$CE/$FF; b:$D1/$FF; a:$FF/$FF);
  AGT_DARKVIOLET          : AGT_Color = (r:$94/$FF; g:$00/$FF; b:$D3/$FF; a:$FF/$FF);
  AGT_DEEPPINK            : AGT_Color = (r:$FF/$FF; g:$14/$FF; b:$93/$FF; a:$FF/$FF);
  AGT_DEEPSKYBLUE         : AGT_Color = (r:$00/$FF; g:$BF/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_DIMGRAY             : AGT_Color = (r:$69/$FF; g:$69/$FF; b:$69/$FF; a:$FF/$FF);
  AGT_DIMGREY             : AGT_Color = (r:$69/$FF; g:$69/$FF; b:$69/$FF; a:$FF/$FF);
  AGT_DODGERBLUE          : AGT_Color = (r:$1E/$FF; g:$90/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_FIREBRICK           : AGT_Color = (r:$B2/$FF; g:$22/$FF; b:$22/$FF; a:$FF/$FF);
  AGT_FLORALWHITE         : AGT_Color = (r:$FF/$FF; g:$FA/$FF; b:$F0/$FF; a:$FF/$FF);
  AGT_FORESTGREEN         : AGT_Color = (r:$22/$FF; g:$8B/$FF; b:$22/$FF; a:$FF/$FF);
  AGT_FUCHSIA             : AGT_Color = (r:$FF/$FF; g:$00/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_GAINSBORO           : AGT_Color = (r:$DC/$FF; g:$DC/$FF; b:$DC/$FF; a:$FF/$FF);
  AGT_GHOSTWHITE          : AGT_Color = (r:$F8/$FF; g:$F8/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_GOLD                : AGT_Color = (r:$FF/$FF; g:$D7/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_GOLDENROD           : AGT_Color = (r:$DA/$FF; g:$A5/$FF; b:$20/$FF; a:$FF/$FF);
  AGT_GRAY                : AGT_Color = (r:$80/$FF; g:$80/$FF; b:$80/$FF; a:$FF/$FF);
  AGT_GREEN               : AGT_Color = (r:$00/$FF; g:$80/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_GREENYELLOW         : AGT_Color = (r:$AD/$FF; g:$FF/$FF; b:$2F/$FF; a:$FF/$FF);
  AGT_GREY                : AGT_Color = (r:$80/$FF; g:$80/$FF; b:$80/$FF; a:$FF/$FF);
  AGT_HONEYDEW            : AGT_Color = (r:$F0/$FF; g:$FF/$FF; b:$F0/$FF; a:$FF/$FF);
  AGT_HOTPINK             : AGT_Color = (r:$FF/$FF; g:$69/$FF; b:$B4/$FF; a:$FF/$FF);
  AGT_INDIANRED           : AGT_Color = (r:$CD/$FF; g:$5C/$FF; b:$5C/$FF; a:$FF/$FF);
  AGT_INDIGO              : AGT_Color = (r:$4B/$FF; g:$00/$FF; b:$82/$FF; a:$FF/$FF);
  AGT_IVORY               : AGT_Color = (r:$FF/$FF; g:$FF/$FF; b:$F0/$FF; a:$FF/$FF);
  AGT_KHAKI               : AGT_Color = (r:$F0/$FF; g:$E6/$FF; b:$8C/$FF; a:$FF/$FF);
  AGT_LAVENDER            : AGT_Color = (r:$E6/$FF; g:$E6/$FF; b:$FA/$FF; a:$FF/$FF);
  AGT_LAVENDERBLUSH       : AGT_Color = (r:$FF/$FF; g:$F0/$FF; b:$F5/$FF; a:$FF/$FF);
  AGT_LAWNGREEN           : AGT_Color = (r:$7C/$FF; g:$FC/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_LEMONCHIFFON        : AGT_Color = (r:$FF/$FF; g:$FA/$FF; b:$CD/$FF; a:$FF/$FF);
  AGT_LIGHTBLUE           : AGT_Color = (r:$AD/$FF; g:$D8/$FF; b:$E6/$FF; a:$FF/$FF);
  AGT_LIGHTCORAL          : AGT_Color = (r:$F0/$FF; g:$80/$FF; b:$80/$FF; a:$FF/$FF);
  AGT_LIGHTCYAN           : AGT_Color = (r:$E0/$FF; g:$FF/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_LIGHTGOLDENRODYELLOW: AGT_Color = (r:$FA/$FF; g:$FA/$FF; b:$D2/$FF; a:$FF/$FF);
  AGT_LIGHTGRAY           : AGT_Color = (r:$D3/$FF; g:$D3/$FF; b:$D3/$FF; a:$FF/$FF);
  AGT_LIGHTGREEN          : AGT_Color = (r:$90/$FF; g:$EE/$FF; b:$90/$FF; a:$FF/$FF);
  AGT_LIGHTGREY           : AGT_Color = (r:$D3/$FF; g:$D3/$FF; b:$D3/$FF; a:$FF/$FF);
  AGT_LIGHTPINK           : AGT_Color = (r:$FF/$FF; g:$B6/$FF; b:$C1/$FF; a:$FF/$FF);
  AGT_LIGHTSALMON         : AGT_Color = (r:$FF/$FF; g:$A0/$FF; b:$7A/$FF; a:$FF/$FF);
  AGT_LIGHTSEAGREEN       : AGT_Color = (r:$20/$FF; g:$B2/$FF; b:$AA/$FF; a:$FF/$FF);
  AGT_LIGHTSKYBLUE        : AGT_Color = (r:$87/$FF; g:$CE/$FF; b:$FA/$FF; a:$FF/$FF);
  AGT_LIGHTSLATEGRAY      : AGT_Color = (r:$77/$FF; g:$88/$FF; b:$99/$FF; a:$FF/$FF);
  AGT_LIGHTSLATEGREY      : AGT_Color = (r:$77/$FF; g:$88/$FF; b:$99/$FF; a:$FF/$FF);
  AGT_LIGHTSTEELBLUE      : AGT_Color = (r:$B0/$FF; g:$C4/$FF; b:$DE/$FF; a:$FF/$FF);
  AGT_LIGHTYELLOW         : AGT_Color = (r:$FF/$FF; g:$FF/$FF; b:$E0/$FF; a:$FF/$FF);
  AGT_LIME                : AGT_Color = (r:$00/$FF; g:$FF/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_LIMEGREEN           : AGT_Color = (r:$32/$FF; g:$CD/$FF; b:$32/$FF; a:$FF/$FF);
  AGT_LINEN               : AGT_Color = (r:$FA/$FF; g:$F0/$FF; b:$E6/$FF; a:$FF/$FF);
  AGT_MAGENTA             : AGT_Color = (r:$FF/$FF; g:$00/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_MAROON              : AGT_Color = (r:$80/$FF; g:$00/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_MEDIUMAQUAMARINE    : AGT_Color = (r:$66/$FF; g:$CD/$FF; b:$AA/$FF; a:$FF/$FF);
  AGT_MEDIUMBLUE          : AGT_Color = (r:$00/$FF; g:$00/$FF; b:$CD/$FF; a:$FF/$FF);
  AGT_MEDIUMORCHID        : AGT_Color = (r:$BA/$FF; g:$55/$FF; b:$D3/$FF; a:$FF/$FF);
  AGT_MEDIUMPURPLE        : AGT_Color = (r:$93/$FF; g:$70/$FF; b:$DB/$FF; a:$FF/$FF);
  AGT_MEDIUMSEAGREEN      : AGT_Color = (r:$3C/$FF; g:$B3/$FF; b:$71/$FF; a:$FF/$FF);
  AGT_MEDIUMSLATEBLUE     : AGT_Color = (r:$7B/$FF; g:$68/$FF; b:$EE/$FF; a:$FF/$FF);
  AGT_MEDIUMSPRINGGREEN   : AGT_Color = (r:$00/$FF; g:$FA/$FF; b:$9A/$FF; a:$FF/$FF);
  AGT_MEDIUMTURQUOISE     : AGT_Color = (r:$48/$FF; g:$D1/$FF; b:$CC/$FF; a:$FF/$FF);
  AGT_MEDIUMVIOLETRED     : AGT_Color = (r:$C7/$FF; g:$15/$FF; b:$85/$FF; a:$FF/$FF);
  AGT_MIDNIGHTBLUE        : AGT_Color = (r:$19/$FF; g:$19/$FF; b:$70/$FF; a:$FF/$FF);
  AGT_MINTCREAM           : AGT_Color = (r:$F5/$FF; g:$FF/$FF; b:$FA/$FF; a:$FF/$FF);
  AGT_MISTYROSE           : AGT_Color = (r:$FF/$FF; g:$E4/$FF; b:$E1/$FF; a:$FF/$FF);
  AGT_MOCCASIN            : AGT_Color = (r:$FF/$FF; g:$E4/$FF; b:$B5/$FF; a:$FF/$FF);
  AGT_NAVAJOWHITE         : AGT_Color = (r:$FF/$FF; g:$DE/$FF; b:$AD/$FF; a:$FF/$FF);
  AGT_NAVY                : AGT_Color = (r:$00/$FF; g:$00/$FF; b:$80/$FF; a:$FF/$FF);
  AGT_OLDLACE             : AGT_Color = (r:$FD/$FF; g:$F5/$FF; b:$E6/$FF; a:$FF/$FF);
  AGT_OLIVE               : AGT_Color = (r:$80/$FF; g:$80/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_OLIVEDRAB           : AGT_Color = (r:$6B/$FF; g:$8E/$FF; b:$23/$FF; a:$FF/$FF);
  AGT_ORANGE              : AGT_Color = (r:$FF/$FF; g:$A5/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_ORANGERED           : AGT_Color = (r:$FF/$FF; g:$45/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_ORCHID              : AGT_Color = (r:$DA/$FF; g:$70/$FF; b:$D6/$FF; a:$FF/$FF);
  AGT_PALEGOLDENROD       : AGT_Color = (r:$EE/$FF; g:$E8/$FF; b:$AA/$FF; a:$FF/$FF);
  AGT_PALEGREEN           : AGT_Color = (r:$98/$FF; g:$FB/$FF; b:$98/$FF; a:$FF/$FF);
  AGT_PALETURQUOISE       : AGT_Color = (r:$AF/$FF; g:$EE/$FF; b:$EE/$FF; a:$FF/$FF);
  AGT_PALEVIOLETRED       : AGT_Color = (r:$DB/$FF; g:$70/$FF; b:$93/$FF; a:$FF/$FF);
  AGT_PAPAYAWHIP          : AGT_Color = (r:$FF/$FF; g:$EF/$FF; b:$D5/$FF; a:$FF/$FF);
  AGT_PEACHPUFF           : AGT_Color = (r:$FF/$FF; g:$DA/$FF; b:$B9/$FF; a:$FF/$FF);
  AGT_PERU                : AGT_Color = (r:$CD/$FF; g:$85/$FF; b:$3F/$FF; a:$FF/$FF);
  AGT_PINK                : AGT_Color = (r:$FF/$FF; g:$C0/$FF; b:$CB/$FF; a:$FF/$FF);
  AGT_PLUM                : AGT_Color = (r:$DD/$FF; g:$A0/$FF; b:$DD/$FF; a:$FF/$FF);
  AGT_POWDERBLUE          : AGT_Color = (r:$B0/$FF; g:$E0/$FF; b:$E6/$FF; a:$FF/$FF);
  AGT_PURPLE              : AGT_Color = (r:$80/$FF; g:$00/$FF; b:$80/$FF; a:$FF/$FF);
  AGT_REBECCAPURPLE       : AGT_Color = (r:$66/$FF; g:$33/$FF; b:$99/$FF; a:$FF/$FF);
  AGT_RED                 : AGT_Color = (r:$FF/$FF; g:$00/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_ROSYBROWN           : AGT_Color = (r:$BC/$FF; g:$8F/$FF; b:$8F/$FF; a:$FF/$FF);
  AGT_ROYALBLUE           : AGT_Color = (r:$41/$FF; g:$69/$FF; b:$E1/$FF; a:$FF/$FF);
  AGT_SADDLEBROWN         : AGT_Color = (r:$8B/$FF; g:$45/$FF; b:$13/$FF; a:$FF/$FF);
  AGT_SALMON              : AGT_Color = (r:$FA/$FF; g:$80/$FF; b:$72/$FF; a:$FF/$FF);
  AGT_SANDYBROWN          : AGT_Color = (r:$F4/$FF; g:$A4/$FF; b:$60/$FF; a:$FF/$FF);
  AGT_SEAGREEN            : AGT_Color = (r:$2E/$FF; g:$8B/$FF; b:$57/$FF; a:$FF/$FF);
  AGT_SEASHELL            : AGT_Color = (r:$FF/$FF; g:$F5/$FF; b:$EE/$FF; a:$FF/$FF);
  AGT_SIENNA              : AGT_Color = (r:$A0/$FF; g:$52/$FF; b:$2D/$FF; a:$FF/$FF);
  AGT_SILVER              : AGT_Color = (r:$C0/$FF; g:$C0/$FF; b:$C0/$FF; a:$FF/$FF);
  AGT_SKYBLUE             : AGT_Color = (r:$87/$FF; g:$CE/$FF; b:$EB/$FF; a:$FF/$FF);
  PySLATEBLUE           : AGT_Color = (r:$6A/$FF; g:$5A/$FF; b:$CD/$FF; a:$FF/$FF);
  AGT_SLATEGRAY           : AGT_Color = (r:$70/$FF; g:$80/$FF; b:$90/$FF; a:$FF/$FF);
  AGT_SLATEGREY           : AGT_Color = (r:$70/$FF; g:$80/$FF; b:$90/$FF; a:$FF/$FF);
  AGT_SNOW                : AGT_Color = (r:$FF/$FF; g:$FA/$FF; b:$FA/$FF; a:$FF/$FF);
  AGT_SPRINGGREEN         : AGT_Color = (r:$00/$FF; g:$FF/$FF; b:$7F/$FF; a:$FF/$FF);
  AGT_STEELBLUE           : AGT_Color = (r:$46/$FF; g:$82/$FF; b:$B4/$FF; a:$FF/$FF);
  AGT_TAN                 : AGT_Color = (r:$D2/$FF; g:$B4/$FF; b:$8C/$FF; a:$FF/$FF);
  AGT_TEAL                : AGT_Color = (r:$00/$FF; g:$80/$FF; b:$80/$FF; a:$FF/$FF);
  AGT_THISTLE             : AGT_Color = (r:$D8/$FF; g:$BF/$FF; b:$D8/$FF; a:$FF/$FF);
  AGT_TOMATO              : AGT_Color = (r:$FF/$FF; g:$63/$FF; b:$47/$FF; a:$FF/$FF);
  AGT_TURQUOISE           : AGT_Color = (r:$40/$FF; g:$E0/$FF; b:$D0/$FF; a:$FF/$FF);
  AGT_VIOLET              : AGT_Color = (r:$EE/$FF; g:$82/$FF; b:$EE/$FF; a:$FF/$FF);
  AGT_WHEAT               : AGT_Color = (r:$F5/$FF; g:$DE/$FF; b:$B3/$FF; a:$FF/$FF);
  AGT_WHITE               : AGT_Color = (r:$FF/$FF; g:$FF/$FF; b:$FF/$FF; a:$FF/$FF);
  AGT_WHITESMOKE          : AGT_Color = (r:$F5/$FF; g:$F5/$FF; b:$F5/$FF; a:$FF/$FF);
  AGT_YELLOW              : AGT_Color = (r:$FF/$FF; g:$FF/$FF; b:$00/$FF; a:$FF/$FF);
  AGT_YELLOWGREEN         : AGT_Color = (r:$9A/$FF; g:$CD/$FF; b:$32/$FF; a:$FF/$FF);
  AGT_BLANK               : AGT_Color = (r:$00;     g:$00;     b:$00;     a:$00);
  AGT_WHITE2              : AGT_Color = (r:$F5/$FF; g:$F5/$FF; b:$F5/$FF; a:$FF/$FF);
  AGT_RED2                : AGT_Color = (r:$7E/$FF; g:$32/$FF; b:$3F/$FF; a:255/$FF);
  AGT_COLORKEY            : AGT_Color = (r:$FF/$FF; g:$00;     b:$FF/$FF; a:$FF/$FF);
  AGT_OVERLAY1            : AGT_Color = (r:$00/$FF; g:$20/$FF; b:$29/$FF; a:$B4/$FF);
  AGT_OVERLAY2            : AGT_Color = (r:$01/$FF; g:$1B/$FF; b:$01/$FF; a:255/$FF);
  AGT_DIMWHITE            : AGT_Color = (r:$10/$FF; g:$10/$FF; b:$10/$FF; a:$10/$FF);
  AGT_DARKSLATEBROWN      : AGT_Color = (r:30/255; g:31/255; b:30/255; a:1/255);

//=== EXPORTS ===============================================================
function  AGT_Color_FromByte(const r, g, b, a: Byte): AGT_Color; cdecl; exports AGT_Color_FromByte;
function  AGT_Color_FromFloat(const r, g, b, a: Single): AGT_Color; cdecl; exports AGT_Color_FromFloat;
function  AGT_Color_Fade(const AFrom, ATo: AGT_Color; const APos: Single): AGT_Color; cdecl; exports AGT_Color_Fade;
function  AGT_Color_IsEqual(const AColor1, AColor2: AGT_Color): Boolean; cdecl; exports AGT_Color_IsEqual;

implementation

//=== EXPORTS ===============================================================
function  AGT_Color_FromByte(const r, g, b, a: Byte): AGT_Color;
begin
  Result.FromByte(r, g, b, a);
end;

function  AGT_Color_FromFloat(const r, g, b, a: Single): AGT_Color;
begin
  Result.FromFloat(r, g, b, a);
end;

function  AGT_Color_Fade(const AFrom, ATo: AGT_Color; const APos: Single): AGT_Color;
begin
  Result := AFrom.Fade(ATo, APos);
end;

function  AGT_Color_IsEqual(const AColor1, AColor2: AGT_Color): Boolean;
begin
  Result := AColor1.IsEqual(AColor2);
end;

{ AGT_Color }
function  AGT_Color.FromByte(const r, g, b, a: Byte): AGT_Color;
begin
  Result.r := EnsureRange(r, 0, 255) / $FF;
  Result.g := EnsureRange(g, 0, 255) / $FF;
  Result.b := EnsureRange(b, 0, 255) / $FF;
  Result.a := EnsureRange(a, 0, 255) / $FF;

  Self := Result;
end;

function  AGT_Color.FromFloat(const r, g, b, a: Single): AGT_Color;
begin
  Result.r := EnsureRange(r, 0, 1);
  Result.g := EnsureRange(g, 0, 1);
  Result.b := EnsureRange(b, 0, 1);
  Result.a := EnsureRange(a, 0, 1);

  Self := Result;
end;

function  AGT_Color.Fade(const ATo: AGT_Color; const APos: Single): AGT_Color;
var
  LPos: Single;
begin
  LPos := EnsureRange(APos, 0, 1);
  Result.r := r + ((ATo.r - r) * LPos);
  Result.g := g + ((ATo.g - g) * LPos);
  Result.b := b + ((ATo.b - b) * LPos);
  Result.a := a + ((ATo.a - a) * LPos);
end;

function  AGT_Color.IsEqual(const AColor: AGT_Color): Boolean;
begin
  Result := (r = AColor.r) and
            (g = AColor.g) and
            (b = AColor.b) and
            (a = AColor.a);
end;

end.
