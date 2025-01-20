:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    _                                                                    ::
::   /_\   _  _  _ _  ___  _ _  __ _                                       ::
::  / _ \ | || || '_|/ _ \| '_|/ _` |                                      ::
:: /_/ \_\ \_,_||_|  \___/|_|  \__,_|                                      ::
::            Game Toolkit™                                                ::
::                                                                         ::
:: Copyright © 2024-present tinyBigGAMES™ LLC                              ::
:: All Rights Reserved.                                                    ::
::                                                                         ::
:: https://github.com/tinyBigGAMES/Aurora                                  ::
::                                                                         ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
cd /d "%~dp0"
@TITLE ConvertVideo
echo Converting audio to Aurora  compatible format....
echo(
ffmpeg.exe -i "%s" -ar 48000 -vn -c:a libvorbis -b:a 64k "%s" -loglevel quiet -stats -y