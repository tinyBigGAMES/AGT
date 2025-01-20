{===============================================================================
    _
   /_\   _  _  _ _  ___  _ _  __ _
  / _ \ | || || '_|/ _ \| '_|/ _` |
 /_/ \_\ \_,_||_|  \___/|_|  \__,_|
             Game Toolkit™

 Copyright © 2024-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/AGT

BSD 3-Clause License

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

-------------------------------------------------------------------------------

 This project uses the following open-source libraries:
 * cute_headers - https://github.com/RandyGaul/cute_headers
 * glfw         - https://github.com/glfw/glfw
 * miniaudio    - https://github.com/mackron/miniaudio
 * pl_mpeg      - https://github.com/phoboslab/pl_mpeg
 * stb          - https://github.com/nothings/stb
 * zlib         - https://github.com/madler/zlib

-------------------------------------------------------------------------------

 >>> CHANGELOG <<<
 =================

 Version 0.1.0:
  - Initial release

===============================================================================}

unit AGT;

{$IFDEF FPC}
{$MODE DELPHIUNICODE}
{$ENDIF}

{$IFNDEF WIN64}
  // Generates a compile-time error if the target platform is not Win64
  {$MESSAGE Error 'Unsupported platform'}
{$ENDIF}

{$Z4}  // Sets the enumeration size to 4 bytes
{$A8}  // Sets the alignment for record fields to 8 bytes

interface

const
  AGT_DLL = 'AGT.dll';

//=== COMMON ================================================================
/// <summary>
///   Represents a constant value indicating no preference or a "don't care" state.
/// </summary>
const
  AGT_DONT_CARE = -1;

type
  /// <summary>
  ///   Specifies horizontal alignment options.
  /// </summary>
  /// <remarks>
  ///   This enumeration is used to define the alignment of elements along the horizontal axis.
  /// </remarks>
  AGT_HAlign = (
    /// <summary>
    ///   Align to the left.
    /// </summary>
    AGT_haLeft,

    /// <summary>
    ///   Align to the center.
    /// </summary>
    AGT_haCenter,

    /// <summary>
    ///   Align to the right.
    /// </summary>
    AGT_haRight
  );

  /// <summary>
  ///   Specifies vertical alignment options.
  /// </summary>
  /// <remarks>
  ///   This enumeration is used to define the alignment of elements along the vertical axis.
  /// </remarks>
  AGT_VAlign = (
    /// <summary>
    ///   Align to the top.
    /// </summary>
    AGT_vaTop,

    /// <summary>
    ///   Align to the center.
    /// </summary>
    AGT_vaCenter,

    /// <summary>
    ///   Align to the bottom.
    /// </summary>
    AGT_vaBottom
  );

//=== UTILS =================================================================
/// <summary>
///   Creates a HUD text item formatted with a key, value, and separator, with optional padding.
/// </summary>
/// <param name="AKey">
///   The key text to display in the HUD.
/// </param>
/// <param name="AValue">
///   The value text associated with the key.
/// </param>
/// <param name="ASeperator">
///   The separator string used between the key and value.
/// </param>
/// <param name="APaddingWidth">
///   The width of the padding between the key, separator, and value. Default is 20.
/// </param>
/// <returns>
///   A pointer to a wide character string containing the formatted HUD text.
/// </returns>
function AGT_HudTextItem(const AKey: PWideChar; const AValue: PWideChar; const ASeperator: PWideChar; const APaddingWidth: Cardinal = 20): PWideChar; cdecl; external AGT_DLL;

//=== IO ====================================================================
/// <summary>
///   Represents a generic I/O pointer.
/// </summary>
type
  AGT_IO = Pointer;

  /// <summary>
  ///   Specifies seek origin options for I/O operations.
/// </summary>
/// <remarks>
///   This enumeration is used to determine the reference point for seeking within a stream.
/// </remarks>
  AGT_IOSeek = (
    /// <summary>
    ///   Seek from the beginning of the stream.
/// </summary>
    AGT_iosStart,

    /// <summary>
    ///   Seek from the current position in the stream.
/// </summary>
    AGT_iosCurrent,

    /// <summary>
    ///   Seek from the end of the stream.
/// </summary>
    AGT_iosEnd
  );

/// <summary>
///   Destroys the specified I/O object and releases its resources.
/// </summary>
/// <param name="AIO">
///   The I/O object to be destroyed. This parameter is passed by reference and set to nil upon destruction.
/// </param>
/// <remarks>
///   Ensure the I/O object is properly closed before destruction to avoid resource leaks.
/// </remarks>
procedure AGT_IO_Destroy(var AIO: AGT_IO); cdecl; external AGT_DLL;

/// <summary>
///   Checks if the specified I/O object is open.
/// </summary>
/// <param name="AIO">
///   The I/O object to check.
/// </param>
/// <returns>
///   True if the I/O object is open; otherwise, False.
/// </returns>
function AGT_IO_IsOpen(const AIO: AGT_IO): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Closes the specified I/O object.
/// </summary>
/// <param name="AIO">
///   The I/O object to close.
/// </param>
/// <remarks>
///   Closing an already closed object has no effect.
/// </remarks>
procedure AGT_IO_Close(const AIO: AGT_IO); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the size of the specified I/O object.
/// </summary>
/// <param name="AIO">
///   The I/O object whose size is to be determined.
/// </param>
/// <returns>
///   The size of the I/O object in bytes.
/// </returns>
function AGT_IO_Size(const AIO: AGT_IO): Int64; cdecl; external AGT_DLL;

/// <summary>
///   Moves the position within the specified I/O object.
/// </summary>
/// <param name="AIO">
///   The I/O object to seek within.
/// </param>
/// <param name="AOffset">
///   The offset to move, relative to the specified seek origin.
/// </param>
/// <param name="ASeek">
///   The seek origin (start, current, or end).
/// </param>
/// <returns>
///   The new position within the I/O object.
/// </returns>
/// <remarks>
///   Seeking beyond the bounds of the I/O object may result in undefined behavior.
/// </remarks>
function AGT_IO_Seek(const AIO: AGT_IO; const AOffset: Int64; const ASeek: AGT_IOSeek): Int64; cdecl; external AGT_DLL;

/// <summary>
///   Reads data from the specified I/O object.
/// </summary>
/// <param name="AIO">
///   The I/O object to read from.
/// </param>
/// <param name="AData">
///   A pointer to the buffer where the read data will be stored.
/// </param>
/// <param name="ASize">
///   The number of bytes to read.
/// </param>
/// <returns>
///   The number of bytes successfully read.
/// </returns>
/// <remarks>
///   Ensure the buffer is large enough to accommodate the specified size to prevent memory corruption.
/// </remarks>
function AGT_IO_Read(const AIO: AGT_IO; const AData: Pointer; const ASize: Int64): Int64; cdecl; external AGT_DLL;

/// <summary>
///   Writes data to the specified I/O object.
/// </summary>
/// <param name="AIO">
///   The I/O object to write to.
/// </param>
/// <param name="AData">
///   A pointer to the buffer containing the data to write.
/// </param>
/// <param name="ASize">
///   The number of bytes to write.
/// </param>
/// <returns>
///   The number of bytes successfully written.
/// </returns>
/// <remarks>
///   Writing beyond the bounds of the I/O object may result in an error.
/// </remarks>
function AGT_IO_Write(const AIO: AGT_IO; const AData: Pointer; const ASize: Int64): Int64; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current position within the specified I/O object.
/// </summary>
/// <param name="AIO">
///   The I/O object to query.
/// </param>
/// <returns>
///   The current position in bytes.
/// </returns>
function AGT_IO_Pos(const AIO: AGT_IO): Int64; cdecl; external AGT_DLL;

/// <summary>
///   Checks if the end of the specified I/O object has been reached.
/// </summary>
/// <param name="AIO">
///   The I/O object to check.
/// </param>
/// <returns>
///   True if the end of the I/O object has been reached; otherwise, False.
/// </returns>
/// <remarks>
///   This function is useful for determining if a read or write operation has consumed all available data.
/// </remarks>
function AGT_IO_Eos(const AIO: AGT_IO): Boolean; cdecl; external AGT_DLL;

//=== MEMORYIO ===============================================================
/// <summary>
///   Represents a memory-based I/O object.
/// </summary>
type
  AGT_MemoryIO = Pointer;

/// <summary>
///   Opens a memory-based I/O object for reading and/or writing.
/// </summary>
/// <param name="AData">
///   A pointer to the memory buffer to be used by the I/O object.
/// </param>
/// <param name="ASize">
///   The size of the memory buffer in bytes.
/// </param>
/// <returns>
///   A pointer to the created memory-based I/O object.
/// </returns>
/// <remarks>
///   The memory buffer must remain valid for the lifetime of the memory-based I/O object.
/// </remarks>
function AGT_MemoryIO_Open(const AData: Pointer; const ASize: Int64): AGT_MemoryIO; cdecl; external AGT_DLL;

/// <summary>
///   Allocates a new memory buffer and creates a memory-based I/O object for it.
/// </summary>
/// <param name="ASize">
///   The size of the memory buffer to allocate, in bytes.
/// </param>
/// <returns>
///   A pointer to the created memory-based I/O object.
/// </returns>
/// <remarks>
///   The allocated memory buffer is managed internally by the memory-based I/O object.
///   Use <c>AGT_IO_Destroy</c> to release the allocated resources when no longer needed.
/// </remarks>
function AGT_MemoryIO_Alloc(const ASize: Int64): AGT_MemoryIO; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves a pointer to the memory buffer associated with the specified memory-based I/O object.
/// </summary>
/// <param name="AMemoryIO">
///   The memory-based I/O object to query.
/// </param>
/// <returns>
///   A pointer to the memory buffer used by the I/O object.
/// </returns>
/// <remarks>
///   The returned pointer allows direct access to the memory buffer for read or write operations.
/// </remarks>
function AGT_MemoryIO_Memory(const AMemoryIO: AGT_MemoryIO): Pointer; cdecl; external AGT_DLL;

//=== FILEIO =================================================================
/// <summary>
///   Represents a file-based I/O object.
/// </summary>
type
  AGT_FileIO = Pointer;

  /// <summary>
  ///   Specifies the mode in which a file-based I/O object should be opened.
/// </summary>
/// <remarks>
///   This enumeration determines whether the file is opened for reading or writing.
/// </remarks>
  AGT_IOMode = (
    /// <summary>
    ///   Open the file in read mode.
/// </summary>
    AGT_iomRead,

    /// <summary>
    ///   Open the file in write mode.
/// </summary>
    AGT_iomWrite
  );

/// <summary>
///   Opens a file and creates a file-based I/O object.
/// </summary>
/// <param name="AFilename">
///   The name of the file to open, as a wide-character string.
/// </param>
/// <param name="AMode">
///   The mode in which to open the file (read or write).
/// </param>
/// <returns>
///   A pointer to the created file-based I/O object, or nil if the operation fails.
/// </returns>
/// <remarks>
///   Ensure the file exists when opening in read mode. For write mode, a new file is created if it does not already exist.
///   Use <c>AGT_IO_Close</c> to close the file-based I/O object when it is no longer needed.
/// </remarks>
function AGT_FileIO_Open(const AFilename: PWideChar; const AMode: AGT_IOMode): AGT_FileIO; cdecl; external AGT_DLL;

//=== ZIPFILEIO ==============================================================
/// <summary>
///   Default password used for zip file operations.
/// </summary>
/// <remarks>
///   This constant provides a default password for zip files when no custom password is specified.
///   It is recommended to override this value for security purposes.
/// </remarks>
const
  AGT_DEFAULT_ZIPFILE_PASSWORD = 'N^TpjE5/*czG,<ns>$}w;?x_uBm9[JSr{(+FRv7ZW@C-gd3D!PRUgWE4P2/wpm9-dt^Y?e)Az+xsMb@jH"!X`B3ar(yq=nZ_~85<';

type
  /// <summary>
  ///   Represents a zip file-based I/O object.
/// </summary>
  AGT_ZipFileIO = Pointer;

  /// <summary>
  ///   Callback procedure for tracking progress during zip file creation.
/// </summary>
/// <param name="AFilename">
///   The name of the file being processed.
/// </param>
/// <param name="AProgress">
///   The current progress as a percentage (0-100).
/// </param>
/// <param name="ANewFile">
///   Indicates whether the file being processed is new.
/// </param>
/// <param name="AUserData">
///   Custom user data passed to the callback.
/// </param>
/// <remarks>
///   This callback is invoked during the build process of a zip file to provide progress updates.
/// </remarks>
  AGT_ZipFileIOBuildProgressCallback = procedure(const AFilename: PWideChar; const AProgress: Integer; const ANewFile: Boolean; const AUserData: Pointer); cdecl;

/// <summary>
///   Creates a zip file from a specified directory.
/// </summary>
/// <param name="AZipFilename">
///   The name of the zip file to create.
/// </param>
/// <param name="ADirectoryName">
///   The directory to compress into the zip file.
/// </param>
/// <param name="APassword">
///   The password to secure the zip file. If nil, no password is applied.
/// </param>
/// <param name="AHandler">
///   An optional callback for tracking progress during the build process.
/// </param>
/// <param name="AUserData">
///   Custom user data passed to the callback.
/// </param>
/// <returns>
///   True if the zip file was successfully created; otherwise, False.
/// </returns>
/// <remarks>
///   Use this function to compress a directory into a password-protected zip file.
///   Ensure the directory and its contents are accessible before calling this function.
/// </remarks>
function AGT_ZipFileIO_Build(const AZipFilename, ADirectoryName, APassword: PWideChar; const AHandler: AGT_ZipFileIOBuildProgressCallback = nil; const AUserData: Pointer = nil): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Opens a file within a zip archive and creates a zip file-based I/O object.
/// </summary>
/// <param name="AZipFilename">
///   The name of the zip file containing the target file.
/// </param>
/// <param name="AFilename">
///   The name of the file within the zip archive to open.
/// </param>
/// <param name="APassword">
///   The password for the zip file. If nil, the default password is used.
/// </param>
/// <returns>
///   A pointer to the created zip file-based I/O object, or nil if the operation fails.
/// </returns>
/// <remarks>
///   Use this function to access a specific file inside a zip archive. Ensure the zip file exists and is accessible.
/// </remarks>
function AGT_ZipFileIO_Open(const AZipFilename, AFilename, APassword: PWideChar): AGT_ZipFileIO; cdecl; external AGT_DLL;

/// <summary>
///   Loads a file from a zip archive into memory.
/// </summary>
/// <param name="AZipFilename">
///   The name of the zip file containing the target file.
/// </param>
/// <param name="AFilename">
///   The name of the file within the zip archive to load.
/// </param>
/// <param name="APassword">
///   The password for the zip file. If nil, the default password is used.
/// </param>
/// <returns>
///   A pointer to a memory-based I/O object containing the loaded file data, or nil if the operation fails.
/// </returns>
/// <remarks>
///   This function is useful for reading files from zip archives directly into memory for further processing.
/// </remarks>
function AGT_ZipFileIO_LoadToMemory(const AZipFilename, AFilename, APassword: PWideChar): AGT_MemoryIO; cdecl; external AGT_DLL;

//=== MATH ==================================================================
/// <summary>
///   Converts radians to degrees.
/// </summary>
const
  AGT_RADTODEG = 180.0 / PI;

/// <summary>
///   Converts degrees to radians.
/// </summary>
const
  AGT_DEGTORAD = PI / 180.0;

/// <summary>
///   A very small value used to handle floating-point precision.
/// </summary>
const
  AGT_EPSILON = 0.00001;

/// <summary>
///   Represents a "Not-a-Number" (NaN) value.
/// </summary>
const
  AGT_NAN = 0.0 / 0.0;

/// <summary>
///   Represents the number of bytes in a kilobyte.
/// </summary>
const
  AGT_KILOBYTE = 1024;

/// <summary>
///   Represents the number of bytes in a megabyte.
/// </summary>
const
  AGT_MEGABYTE = 1024 * 1024;

/// <summary>
///   Represents the number of bytes in a gigabyte.
/// </summary>
const
  AGT_GIGABYTE = 1024 * 1024 * 1024;


/// <summary>
///   Represents a 4D vector with components X, Y, Z, and W.
/// </summary>
type
  PAGT_Vector = ^AGT_Vector;
  AGT_Vector = record
    /// <summary>
    ///   The X component of the vector.
/// </summary>
    x: Single;
    /// <summary>
    ///   The Y component of the vector.
/// </summary>
    y: Single;
    /// <summary>
    ///   The Z component of the vector.
/// </summary>
    z: Single;
    /// <summary>
    ///   The W component of the vector.
/// </summary>
    w: Single;
  end;

/// <summary>
///   Represents a 2D point with X and Y coordinates.
/// </summary>
type
  PAGT_Point = ^AGT_Point;
  AGT_Point = record
    /// <summary>
    ///   The X coordinate of the point.
/// </summary>
    x: Single;
    /// <summary>
    ///   The Y coordinate of the point.
/// </summary>
    y: Single;
  end;

/// <summary>
///   Represents a size with width (W) and height (H) components.
/// </summary>
type
  PAGT_Size = ^AGT_Size;
  AGT_Size = record
    /// <summary>
    ///   The width component.
/// </summary>
    w: Single;
    /// <summary>
    ///   The height component.
/// </summary>
    h: Single;
  end;

/// <summary>
///   Represents a rectangle defined by a position and size.
/// </summary>
type
  PAGT_Rect = ^AGT_Rect;
  AGT_Rect = record
    /// <summary>
    ///   The position of the rectangle, represented as a point.
/// </summary>
    pos: AGT_Point;
    /// <summary>
    ///   The size of the rectangle, represented as width and height.
/// </summary>
    size: AGT_Size;
  end;

/// <summary>
///   Represents an extent defined by minimum and maximum points.
/// </summary>
type
  PAGT_Extent = ^AGT_Extent;
  AGT_Extent = record
    /// <summary>
    ///   The minimum point of the extent.
/// </summary>
    min: AGT_Point;
    /// <summary>
    ///   The maximum point of the extent.
/// </summary>
    max: AGT_Point;
  end;

/// <summary>
///   Represents an Oriented Bounding Box (OBB) defined by a center, extents, and rotation.
/// </summary>
type
  PAGT_OBB = ^AGT_OBB;
  AGT_OBB = record
    /// <summary>
    ///   The center point of the OBB.
/// </summary>
    Center: AGT_Point;
    /// <summary>
    ///   The extents of the OBB along the X and Y axes.
/// </summary>
    Extents: AGT_Point;
    /// <summary>
    ///   The rotation of the OBB in degrees.
/// </summary>
    Rotation: Single;
  end;

/// <summary>
///   Represents the result of a line intersection calculation.
/// </summary>
type
  AGT_LineIntersection = (
    /// <summary>
    ///   No intersection.
/// </summary>
    AGT_liNone,
    /// <summary>
    ///   A valid intersection occurred.
/// </summary>
    AGT_liTrue,
    /// <summary>
    ///   The lines are parallel.
/// </summary>
    AGT_liParallel
  );

/// <summary>
///   Specifies the type of easing function for animations or transitions.
/// </summary>
/// <remarks>
///   These easing functions control how values change over time, creating smooth or dynamic effects.
/// </remarks>
type
  AGT_EaseType = (
    /// <summary>
    ///   Linear easing (no acceleration or deceleration).
/// </summary>
    AGT_etLinearTween,
    /// <summary>
    ///   Quadratic easing in (acceleration).
/// </summary>
    AGT_etInQuad,
    /// <summary>
    ///   Quadratic easing out (deceleration).
/// </summary>
    AGT_etOutQuad,
    /// <summary>
    ///   Quadratic easing in and out (acceleration and deceleration).
/// </summary>
    AGT_etInOutQuad,
    /// <summary>
    ///   Cubic easing in (stronger acceleration).
/// </summary>
    AGT_etInCubic,
    /// <summary>
    ///   Cubic easing out (stronger deceleration).
/// </summary>
    AGT_etOutCubic,
    /// <summary>
    ///   Cubic easing in and out (stronger acceleration and deceleration).
/// </summary>
    AGT_etInOutCubic,
    /// <summary>
    ///   Quartic easing in.
/// </summary>
    AGT_etInQuart,
    /// <summary>
    ///   Quartic easing out.
/// </summary>
    AGT_etOutQuart,
    /// <summary>
    ///   Quartic easing in and out.
/// </summary>
    AGT_etInOutQuart,
    /// <summary>
    ///   Quintic easing in.
/// </summary>
    AGT_etInQuint,
    /// <summary>
    ///   Quintic easing out.
/// </summary>
    AGT_etOutQuint,
    /// <summary>
    ///   Quintic easing in and out.
/// </summary>
    AGT_etInOutQuint,
    /// <summary>
    ///   Sine wave easing in.
/// </summary>
    AGT_etInSine,
    /// <summary>
    ///   Sine wave easing out.
/// </summary>
    AGT_etOutSine,
    /// <summary>
    ///   Sine wave easing in and out.
/// </summary>
    AGT_etInOutSine,
    /// <summary>
    ///   Exponential easing in.
/// </summary>
    AGT_etInExpo,
    /// <summary>
    ///   Exponential easing out.
/// </summary>
    AGT_etOutExpo,
    /// <summary>
    ///   Exponential easing in and out.
/// </summary>
    AGT_etInOutExpo,
    /// <summary>
    ///   Circular easing in.
/// </summary>
    AGT_etInCircle,
    /// <summary>
    ///   Circular easing out.
/// </summary>
    AGT_etOutCircle,
    /// <summary>
    ///   Circular easing in and out.
/// </summary>
    AGT_etInOutCircle
  );

/// <summary>
///   Creates a 2D point with specified X and Y coordinates.
/// </summary>
/// <param name="X">
///   The X-coordinate of the point.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the point.
/// </param>
/// <returns>
///   An <c>AGT_Point</c> structure representing the created point.
/// </returns>
/// <remarks>
///   Use this function to instantiate a 2D point for geometry operations or rendering purposes.
/// </remarks>
function AGT_Point_Create(const X, Y: Single): AGT_Point; cdecl; external AGT_DLL;

/// <summary>
///   Creates a 4D vector with specified X and Y components. Z and W are set to 0 by default.
/// </summary>
/// <param name="X">
///   The X component of the vector.
/// </param>
/// <param name="Y">
///   The Y component of the vector.
/// </param>
/// <returns>
///   An <c>AGT_Vector</c> structure representing the created vector.
/// </returns>
/// <remarks>
///   This function initializes a vector with the provided X and Y values. Z and W components are optional and default to 0.
/// </remarks>
function AGT_Vector_Create(const X, Y: Single): AGT_Vector; cdecl; external AGT_DLL;

/// <summary>
///   Creates a size structure with specified width and height.
/// </summary>
/// <param name="W">
///   The width component of the size.
/// </param>
/// <param name="H">
///   The height component of the size.
/// </param>
/// <returns>
///   An <c>AGT_Size</c> structure representing the created size.
/// </returns>
/// <remarks>
///   Use this function to define dimensions for UI elements, geometry, or other scalable objects.
/// </remarks>
function AGT_Size_Create(const W, H: Single): AGT_Size; cdecl; external AGT_DLL;

/// <summary>
///   Creates a rectangle with specified position and dimensions.
/// </summary>
/// <param name="X">
///   The X-coordinate of the rectangle's top-left corner.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the rectangle's top-left corner.
/// </param>
/// <param name="W">
///   The width of the rectangle.
/// </param>
/// <param name="H">
///   The height of the rectangle.
/// </param>
/// <returns>
///   An <c>AGT_Rect</c> structure representing the created rectangle.
/// </returns>
/// <remarks>
///   This function is useful for creating rectangles for collision detection, UI layout, or rendering.
/// </remarks>
function AGT_Rect_Create(const X, Y, W, H: Single): AGT_Rect; cdecl; external AGT_DLL;

/// <summary>
///   Creates an extent structure with specified minimum and maximum points.
/// </summary>
/// <param name="AMinX">
///   The X-coordinate of the minimum point.
/// </param>
/// <param name="AMinY">
///   The Y-coordinate of the minimum point.
/// </param>
/// <param name="AMaxX">
///   The X-coordinate of the maximum point.
/// </param>
/// <param name="AMaxY">
///   The Y-coordinate of the maximum point.
/// </param>
/// <returns>
///   An <c>AGT_Extent</c> structure representing the created extent.
/// </returns>
/// <remarks>
///   Use this function to define a bounding box or area for spatial calculations.
/// </remarks>
function AGT_Extent_Create(const AMinX, AMinY, AMaxX, AMaxY: Single): AGT_Extent; cdecl; external AGT_DLL;

/// <summary>
///   Assigns the values of one vector to another.
/// </summary>
/// <param name="A">
///   The destination vector that will be modified.
/// </param>
/// <param name="B">
///   The source vector whose values will be assigned to <c>A</c>.
/// </param>
/// <remarks>
///   This procedure copies all components (X, Y, Z, W) of the source vector to the destination.
/// </remarks>
procedure AGT_Vector_Assign(var A: AGT_Vector; const B: AGT_Vector); cdecl; external AGT_DLL;

/// <summary>
///   Clears the vector by setting all components (X, Y, Z, W) to zero.
/// </summary>
/// <param name="A">
///   The vector to clear.
/// </param>
/// <remarks>
///   This is useful for resetting a vector to a neutral state.
/// </remarks>
procedure AGT_Vector_Clear(var A: AGT_Vector); cdecl; external AGT_DLL;

/// <summary>
///   Adds one vector to another.
/// </summary>
/// <param name="A">
///   The first vector, which will be modified.
/// </param>
/// <param name="B">
///   The second vector to add to the first.
/// </param>
/// <remarks>
///   The result is stored in the first vector <c>A</c>.
/// </remarks>
procedure AGT_Vector_Add(var A: AGT_Vector; const B: AGT_Vector); cdecl; external AGT_DLL;

/// <summary>
///   Subtracts one vector from another.
/// </summary>
/// <param name="A">
///   The first vector, which will be modified.
/// </param>
/// <param name="B">
///   The second vector to subtract from the first.
/// </param>
/// <remarks>
///   The result is stored in the first vector <c>A</c>.
/// </remarks>
procedure AGT_Vector_Subtract(var A: AGT_Vector; const B: AGT_Vector); cdecl; external AGT_DLL;

/// <summary>
///   Multiplies one vector by another component-wise.
/// </summary>
/// <param name="A">
///   The first vector, which will be modified.
/// </param>
/// <param name="B">
///   The second vector to multiply with the first.
/// </param>
/// <remarks>
///   Each component of the first vector is multiplied by the corresponding component of the second vector.
/// </remarks>
procedure AGT_Vector_Multiply(var A: AGT_Vector; const B: AGT_Vector); cdecl; external AGT_DLL;

/// <summary>
///   Divides one vector by another component-wise.
/// </summary>
/// <param name="A">
///   The first vector, which will be modified.
/// </param>
/// <param name="B">
///   The second vector to divide the first vector by.
/// </param>
/// <remarks>
///   Each component of the first vector is divided by the corresponding component of the second vector.
///   Ensure the components of <c>B</c> are non-zero to avoid division by zero.
/// </remarks>
procedure AGT_Vector_Divide(var A: AGT_Vector; const B: AGT_Vector); cdecl; external AGT_DLL;

/// <summary>
///   Divides all components of a vector by a scalar value.
/// </summary>
/// <param name="A">
///   The vector to modify.
/// </param>
/// <param name="AValue">
///   The scalar value to divide each component of the vector by.
/// </param>
/// <remarks>
///   Ensure <c>AValue</c> is non-zero to avoid division by zero.
/// </remarks>
procedure AGT_Vector_DivideByValue(var A: AGT_Vector; const AValue: Single); cdecl; external AGT_DLL;

/// <summary>
///   Calculates the magnitude (length) of a vector.
/// </summary>
/// <param name="A">
///   The vector whose magnitude is to be calculated.
/// </param>
/// <returns>
///   The magnitude of the vector.
/// </returns>
/// <remarks>
///   The magnitude is computed as the square root of the sum of the squares of the components.
/// </remarks>
function AGT_Vector_Magnitude(const A: AGT_Vector): Single; cdecl; external AGT_DLL;

/// <summary>
///   Truncates the magnitude of a vector to a maximum value.
/// </summary>
/// <param name="A">
///   The vector to truncate.
/// </param>
/// <param name="AMaxMagnitude">
///   The maximum magnitude allowed.
/// </param>
/// <returns>
///   A new vector with the truncated magnitude.
/// </returns>
/// <remarks>
///   This is useful for limiting the length of a vector while preserving its direction.
/// </remarks>
function AGT_Vector_MagnitudeTruncate(const A: AGT_Vector; const AMaxMagnitude: Single): AGT_Vector; cdecl; external AGT_DLL;

/// <summary>
///   Calculates the distance between two vectors.
/// </summary>
/// <param name="A">
///   The first vector.
/// </param>
/// <param name="B">
///   The second vector.
/// </param>
/// <returns>
///   The distance between the two vectors.
/// </returns>
function AGT_Vector_Distance(const A, B: AGT_Vector): Single; cdecl; external AGT_DLL;

/// <summary>
///   Normalizes a vector to make its magnitude equal to 1.
/// </summary>
/// <param name="A">
///   The vector to normalize.
/// </param>
/// <remarks>
///   A normalized vector maintains its direction but has a unit length.
///   Ensure the vector's magnitude is non-zero before calling this procedure.
/// </remarks>
procedure AGT_Vector_Normalize(var A: AGT_Vector); cdecl; external AGT_DLL;

/// <summary>
///   Calculates the angle between two vectors.
/// </summary>
/// <param name="A">
///   The first vector.
/// </param>
/// <param name="B">
///   The second vector.
/// </param>
/// <returns>
///   The angle between the two vectors in degrees.
/// </returns>
function AGT_Vector_Angle(const A, B: AGT_Vector): Single; cdecl; external AGT_DLL;

/// <summary>
///   Applies thrust to a vector in a specified direction and speed.
/// </summary>
/// <param name="A">
///   The vector to modify.
/// </param>
/// <param name="AAngle">
///   The angle of the thrust in degrees.
/// </param>
/// <param name="ASpeed">
///   The speed of the thrust.
/// </param>
/// <remarks>
///   This procedure modifies the vector to simulate movement in the given direction and speed.
/// </remarks>
procedure AGT_Vector_Thrust(var A: AGT_Vector; const AAngle, ASpeed: Single); cdecl; external AGT_DLL;

/// <summary>
///   Calculates the squared magnitude of a vector.
/// </summary>
/// <param name="A">
///   The vector whose squared magnitude is to be calculated.
/// </param>
/// <returns>
///   The squared magnitude of the vector.
/// </returns>
/// <remarks>
///   This function avoids the performance cost of calculating a square root.
/// </remarks>
function AGT_Vector_MagnitudeSquared(const A: AGT_Vector): Single; cdecl; external AGT_DLL;

/// <summary>
///   Calculates the dot product of two vectors.
/// </summary>
/// <param name="A">
///   The first vector.
/// </param>
/// <param name="B">
///   The second vector.
/// </param>
/// <returns>
///   The dot product of the two vectors.
/// </returns>
function AGT_Vector_DotProduct(const A, B: AGT_Vector): Single; cdecl; external AGT_DLL;

/// <summary>
///   Scales a vector by a scalar value.
/// </summary>
/// <param name="A">
///   The vector to scale.
/// </param>
/// <param name="AValue">
///   The scalar value to scale the vector by.
/// </param>
/// <remarks>
///   Each component of the vector is multiplied by <c>AValue</c>.
/// </remarks>
procedure AGT_Vector_ScaleByValue(var A: AGT_Vector; const AValue: Single); cdecl; external AGT_DLL;

/// <summary>
///   Projects one vector onto another.
/// </summary>
/// <param name="A">
///   The vector to project.
/// </param>
/// <param name="B">
///   The vector to project onto.
/// </param>
/// <returns>
///   The projected vector.
/// </returns>
function AGT_Vector_Project(const A, B: AGT_Vector): AGT_Vector; cdecl; external AGT_DLL;

/// <summary>
///   Negates all components of a vector.
/// </summary>
/// <param name="A">
///   The vector to negate.
/// </param>
/// <remarks>
///   Negating a vector inverts its direction.
/// </remarks>
procedure AGT_Vector_Negate(var A: AGT_Vector); cdecl; external AGT_DLL;

/// <summary>
///   Calculates the cosine of an angle.
/// </summary>
/// <param name="AAngle">
///   The angle in degrees for which to calculate the cosine.
/// </param>
/// <returns>
///   The cosine of the specified angle.
/// </returns>
/// <remarks>
///   This function uses degrees rather than radians. Ensure the angle is within the valid range for accurate results.
/// </remarks>
function AGT_AngleCos(const AAngle: Cardinal): Single; cdecl; external AGT_DLL;

/// <summary>
///   Calculates the sine of an angle.
/// </summary>
/// <param name="AAngle">
///   The angle in degrees for which to calculate the sine.
/// </param>
/// <returns>
///   The sine of the specified angle.
/// </returns>
/// <remarks>
///   This function uses degrees rather than radians. Ensure the angle is within the valid range for accurate results.
/// </remarks>
function AGT_AngleSin(const AAngle: Cardinal): Single; cdecl; external AGT_DLL;

/// <summary>
///   Calculates the shortest difference between two angles.
/// </summary>
/// <param name="ASrcAngle">
///   The source angle in degrees.
/// </param>
/// <param name="ADestAngle">
///   The destination angle in degrees.
/// </param>
/// <returns>
///   The shortest angular difference in degrees.
/// </returns>
/// <remarks>
///   The result is the signed difference, which can be negative if the shortest rotation is counterclockwise.
/// </remarks>
function AGT_AngleDiff(const ASrcAngle, ADestAngle: Single): Single; cdecl; external AGT_DLL;

/// <summary>
///   Rotates a position (X, Y) around the origin by a specified angle.
/// </summary>
/// <param name="AAngle">
///   The angle in degrees to rotate the position.
/// </param>
/// <param name="X">
///   The X-coordinate of the position to rotate. This value is modified in place.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the position to rotate. This value is modified in place.
/// </param>
/// <remarks>
///   Rotation is performed around the origin (0, 0). Positive angles rotate the position counterclockwise.
/// </remarks>
procedure AGT_AngleRotatePos(const AAngle: Single; var X, Y: Single); cdecl; external AGT_DLL;

/// <summary>
///   Generates a random integer within a specified range.
/// </summary>
/// <param name="AMin">
///   The minimum value (inclusive) of the range.
/// </param>
/// <param name="AMax">
///   The maximum value (inclusive) of the range.
/// </param>
/// <returns>
///   A random integer between <c>AMin</c> and <c>AMax</c>, inclusive.
/// </returns>
/// <remarks>
///   The range is inclusive on both ends. Ensure that <c>AMin</c> is less than or equal to <c>AMax</c> to avoid undefined behavior.
/// </remarks>
function AGT_RandomRange(const AMin, AMax: Integer): Integer; cdecl; external AGT_DLL;

/// <summary>
///   Generates a random floating-point number within a specified range.
/// </summary>
/// <param name="AMin">
///   The minimum value (inclusive) of the range.
/// </param>
/// <param name="AMax">
///   The maximum value (exclusive) of the range.
/// </param>
/// <returns>
///   A random floating-point number between <c>AMin</c> and <c>AMax</c>.
/// </returns>
/// <remarks>
///   The range is inclusive for <c>AMin</c> and exclusive for <c>AMax</c>. Ensure that <c>AMin</c> is less than <c>AMax</c>.
/// </remarks>
function AGT_RandomRangef(const AMin, AMax: Single): Single; cdecl; external AGT_DLL;

/// <summary>
///   Generates a random Boolean value.
/// </summary>
/// <returns>
///   A random Boolean value (<c>True</c> or <c>False</c>).
/// </returns>
/// <remarks>
///   The result is equally likely to be <c>True</c> or <c>False</c>.
/// </remarks>
function AGT_RandomBool(): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current random seed value.
/// </summary>
/// <returns>
///   The current random seed value as an integer.
/// </returns>
/// <remarks>
///   The random seed determines the sequence of random numbers generated. Use this function to retrieve the current seed for reproducibility.
/// </remarks>
function AGT_GetRandomSeed(): Integer; cdecl; external AGT_DLL;

/// <summary>
///   Sets a custom seed value for the random number generator.
/// </summary>
/// <param name="AVaLue">
///   The seed value to set.
/// </param>
/// <remarks>
///   Setting a custom seed allows for reproducible sequences of random numbers. Use this for testing or predictable behavior.
/// </remarks>
procedure AGT_SetRandomSeed(const AVaLue: Integer); cdecl; external AGT_DLL;

/// <summary>
///   Clips a floating-point value within a specified range, with an option to wrap around.
/// </summary>
/// <param name="AVaLue">
///   The value to be clipped or wrapped. This parameter is modified in place.
/// </param>
/// <param name="AMin">
///   The minimum allowable value.
/// </param>
/// <param name="AMax">
///   The maximum allowable value.
/// </param>
/// <param name="AWrap">
///   Determines whether the value should wrap around when outside the range.
///   - <c>True</c>: The value wraps around the range (cyclic behavior).
///   - <c>False</c>: The value is clamped to the range.
/// </param>
/// <returns>
///   The clipped or wrapped value.
/// </returns>
/// <remarks>
///   - If <c>AWrap</c> is set to <c>True</c>, the value will "wrap" around the range using modulo arithmetic.
///   - If <c>AWrap</c> is set to <c>False</c>, the value is clamped to the nearest bound (AMin or AMax).
///   - Ensure <c>AMin</c> is less than or equal to <c>AMax</c> for correct behavior.
/// </remarks>
function AGT_ClipVaLuef(var AVaLue: Single; const AMin, AMax: Single; const AWrap: Boolean): Single; cdecl; external AGT_DLL;

/// <summary>
///   Clips an integer value within a specified range, with an option to wrap around.
/// </summary>
/// <param name="AVaLue">
///   The value to be clipped or wrapped. This parameter is modified in place.
/// </param>
/// <param name="AMin">
///   The minimum allowable value.
/// </param>
/// <param name="AMax">
///   The maximum allowable value.
/// </param>
/// <param name="AWrap">
///   Determines whether the value should wrap around when outside the range.
///   - <c>True</c>: The value wraps around the range (cyclic behavior).
///   - <c>False</c>: The value is clamped to the range.
/// </param>
/// <returns>
///   The clipped or wrapped value.
/// </returns>
/// <remarks>
///   - If <c>AWrap</c> is set to <c>True</c>, the value will "wrap" around the range using modulo arithmetic.
///   - If <c>AWrap</c> is set to <c>False</c>, the value is clamped to the nearest bound (AMin or AMax).
///   - Ensure <c>AMin</c> is less than or equal to <c>AMax</c> for correct behavior.
/// </remarks>
function AGT_ClipVaLue(var AVaLue: Integer; const AMin, AMax: Integer; const AWrap: Boolean): Integer; cdecl; external AGT_DLL;

/// <summary>
///   Determines if two integer values have the same sign.
/// </summary>
/// <param name="AVaLue1">
///   The first integer value to compare.
/// </param>
/// <param name="AVaLue2">
///   The second integer value to compare.
/// </param>
/// <returns>
///   <c>True</c> if both values have the same sign or are zero; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   Zero is considered to have the same sign as any other zero.
///   Positive values and negative values are compared for their signs.
/// </remarks>
function AGT_SameSign(const AVaLue1, AVaLue2: Integer): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Determines if two floating-point values have the same sign.
/// </summary>
/// <param name="AVaLue1">
///   The first floating-point value to compare.
/// </param>
/// <param name="AVaLue2">
///   The second floating-point value to compare.
/// </param>
/// <returns>
///   <c>True</c> if both values have the same sign or are zero; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   Zero is considered to have the same sign as any other zero.
///   Positive values and negative values are compared for their signs.
/// </remarks>
function AGT_SameSignf(const AVaLue1, AVaLue2: Single): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Determines if two double-precision floating-point values are approximately equal.
/// </summary>
/// <param name="A">
///   The first double-precision value to compare.
/// </param>
/// <param name="B">
///   The second double-precision value to compare.
/// </param>
/// <param name="AEpsilon">
///   The allowable difference between the two values. Default is 0.
/// </param>
/// <returns>
///   <c>True</c> if the difference between the values is less than or equal to <c>AEpsilon</c>; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   Use this function for comparing floating-point values where small differences may occur due to precision issues.
///   If <c>AEpsilon</c> is 0, an exact comparison is performed.
/// </remarks>
function AGT_SameVaLue(const A, B: Double; const AEpsilon: Double = 0): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Determines if two single-precision floating-point values are approximately equal.
/// </summary>
/// <param name="A">
///   The first single-precision value to compare.
/// </param>
/// <param name="B">
///   The second single-precision value to compare.
/// </param>
/// <param name="AEpsilon">
///   The allowable difference between the two values. Default is 0.
/// </param>
/// <returns>
///   <c>True</c> if the difference between the values is less than or equal to <c>AEpsilon</c>; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   Use this function for comparing floating-point values where small differences may occur due to precision issues.
///   If <c>AEpsilon</c> is 0, an exact comparison is performed.
/// </remarks>
function AGT_SameVaLuef(const A, B: Single; const AEpsilon: Single = 0): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Smoothly moves a value toward a target using specified parameters for maximum speed and drag.
/// </summary>
/// <param name="AVaLue">
///   The current value to be modified. This parameter is updated in place.
/// </param>
/// <param name="AAmount">
///   The target value to move toward.
/// </param>
/// <param name="AMax">
///   The maximum allowable change in value per update.
/// </param>
/// <param name="ADrag">
///   The drag coefficient, which controls the rate of deceleration as the value approaches the target.
/// </param>
/// <remarks>
///   - This procedure is useful for creating smooth transitions or animations.
///   - A higher <c>AMax</c> allows faster movement toward the target.
///   - A higher <c>ADrag</c> results in more gradual deceleration.
/// </remarks>
procedure AGT_SmoothMove(var AVaLue: Single; const AAmount, AMax, ADrag: Single); cdecl; external AGT_DLL;

/// <summary>
///   Linearly interpolates between two values over a specified time.
/// </summary>
/// <param name="AFrom">
///   The starting value of the interpolation.
/// </param>
/// <param name="ATo">
///   The ending value of the interpolation.
/// </param>
/// <param name="ATime">
///   A normalized time factor between 0.0 and 1.0:
///   - 0.0 corresponds to the starting value (<c>AFrom</c>).
///   - 1.0 corresponds to the ending value (<c>ATo</c>).
/// </param>
/// <returns>
///   The interpolated value.
/// </returns>
/// <remarks>
///   - This function calculates the value at a specific point along a straight line between <c>AFrom</c> and <c>ATo</c>.
///   - Ensure <c>ATime</c> is within the range [0.0, 1.0] for predictable results.
/// </remarks>
function AGT_Lerp(const AFrom, ATo, ATime: Double): Double; cdecl; external AGT_DLL;

/// <summary>
///   Determines if a point lies within a rectangle.
/// </summary>
/// <param name="APoint">
///   The point to check, represented as a vector with X and Y coordinates.
/// </param>
/// <param name="ARect">
///   The rectangle to test against, defined by a position and size.
/// </param>
/// <returns>
///   <c>True</c> if the point is inside the rectangle; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The rectangle is defined by its top-left corner (ARect.pos) and dimensions (ARect.size).
///   - This function checks whether the point's X and Y coordinates fall within the bounds of the rectangle.
/// </remarks>
function AGT_PointInRectangle(APoint: AGT_Vector; ARect: AGT_Rect): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Determines if a point lies within a circle.
/// </summary>
/// <param name="APoint">
///   The point to check, represented as a vector with X and Y coordinates.
/// </param>
/// <param name="ACenter">
///   The center of the circle, represented as a vector with X and Y coordinates.
/// </param>
/// <param name="ARadius">
///   The radius of the circle.
/// </param>
/// <returns>
///   <c>True</c> if the point is inside the circle; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   This function calculates the Euclidean distance between the point and the circle's center
///   and checks if it is less than or equal to the radius.
/// </remarks>
function AGT_PointInCircle(APoint, ACenter: AGT_Vector; ARadius: Single): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Determines if a point lies within a triangle.
/// </summary>
/// <param name="APoint">
///   The point to check, represented as a vector with X and Y coordinates.
/// </param>
/// <param name="P1">
///   The first vertex of the triangle.
/// </param>
/// <param name="P2">
///   The second vertex of the triangle.
/// </param>
/// <param name="P3">
///   The third vertex of the triangle.
/// </param>
/// <returns>
///   <c>True</c> if the point is inside the triangle; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   This function uses a barycentric or area-based method to determine if the point lies within the triangle's bounds.
/// </remarks>
function AGT_PointInTriangle(APoint, P1, P2, P3: AGT_Vector): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks if two circles overlap.
/// </summary>
/// <param name="ACenter1">
///   The center of the first circle, represented as a vector with X and Y coordinates.
/// </param>
/// <param name="ARadius1">
///   The radius of the first circle.
/// </param>
/// <param name="ACenter2">
///   The center of the second circle, represented as a vector with X and Y coordinates.
/// </param>
/// <param name="ARadius2">
///   The radius of the second circle.
/// </param>
/// <returns>
///   <c>True</c> if the circles overlap; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   This function calculates the distance between the centers of the circles and checks
///   if it is less than or equal to the sum of their radii.
/// </remarks>
function AGT_CirclesOverlap(ACenter1: AGT_Vector; ARadius1: Single; ACenter2: AGT_Vector; ARadius2: Single): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Determines if a circle lies entirely within a rectangle.
/// </summary>
/// <param name="ACenter">
///   The center of the circle, represented as a vector with X and Y coordinates.
/// </param>
/// <param name="ARadius">
///   The radius of the circle.
/// </param>
/// <param name="ARect">
///   The rectangle to test against, defined by a position and size.
/// </param>
/// <returns>
///   <c>True</c> if the circle is fully contained within the rectangle; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   This function checks if all edges of the circle fall within the bounds of the rectangle.
///   It is useful for containment tests in 2D spatial calculations.
/// </remarks>
function AGT_CircleInRectangle(ACenter: AGT_Vector; ARadius: Single; ARect: AGT_Rect): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks if two rectangles overlap.
/// </summary>
/// <param name="ARect1">
///   The first rectangle, defined by its position and size.
/// </param>
/// <param name="ARect2">
///   The second rectangle, defined by its position and size.
/// </param>
/// <returns>
///   <c>True</c> if the rectangles overlap; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   This function compares the bounds of the rectangles to determine if they intersect.
///   Useful for collision detection or layout overlap checks.
/// </remarks>
function AGT_RectanglesOverlap(ARect1: AGT_Rect; ARect2: AGT_Rect): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Calculates the intersection of two rectangles.
/// </summary>
/// <param name="ARect1">
///   The first rectangle, defined by its position and size.
/// </param>
/// <param name="ARect2">
///   The second rectangle, defined by its position and size.
/// </param>
/// <returns>
///   An <c>AGT_Rect</c> representing the overlapping area of the rectangles. If no overlap exists, the result may be undefined.
/// </returns>
/// <remarks>
///   - This function returns a rectangle representing the overlapping region between the two input rectangles.
///   - Ensure the rectangles overlap by using <c>AGT_RectanglesOverlap</c> before calling this function to avoid undefined results.
/// </remarks>
function AGT_RectangleIntersection(ARect1, ARect2: AGT_Rect): AGT_Rect; cdecl; external AGT_DLL;

/// <summary>
///   Determines the intersection of two line segments.
/// </summary>
/// <param name="X1">
///   The X-coordinate of the first endpoint of the first line segment.
/// </param>
/// <param name="Y1">
///   The Y-coordinate of the first endpoint of the first line segment.
/// </param>
/// <param name="X2">
///   The X-coordinate of the second endpoint of the first line segment.
/// </param>
/// <param name="Y2">
///   The Y-coordinate of the second endpoint of the first line segment.
/// </param>
/// <param name="X3">
///   The X-coordinate of the first endpoint of the second line segment.
/// </param>
/// <param name="Y3">
///   The Y-coordinate of the first endpoint of the second line segment.
/// </param>
/// <param name="X4">
///   The X-coordinate of the second endpoint of the second line segment.
/// </param>
/// <param name="Y4">
///   The Y-coordinate of the second endpoint of the second line segment.
/// </param>
/// <param name="X">
///   The X-coordinate of the intersection point, if it exists. This parameter is modified in place.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the intersection point, if it exists. This parameter is modified in place.
/// </param>
/// <returns>
///   An <c>AGT_LineIntersection</c> value indicating the intersection status:
///   - <c>AGT_liNone</c>: No intersection.
///   - <c>AGT_liTrue</c>: The lines intersect at a point.
///   - <c>AGT_liParallel</c>: The lines are parallel and do not intersect.
/// </returns>
/// <remarks>
///   This function calculates whether the line segments intersect and, if so, provides the intersection point.
/// </remarks>
function AGT_LineIntersect(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer; var X: Integer; var Y: Integer): AGT_LineIntersection; cdecl; external AGT_DLL;

/// <summary>
///   Checks if two circles overlap, considering an optional shrink factor.
/// </summary>
/// <param name="ARadius1">
///   The radius of the first circle.
/// </param>
/// <param name="X1">
///   The X-coordinate of the center of the first circle.
/// </param>
/// <param name="Y1">
///   The Y-coordinate of the center of the first circle.
/// </param>
/// <param name="ARadius2">
///   The radius of the second circle.
/// </param>
/// <param name="X2">
///   The X-coordinate of the center of the second circle.
/// </param>
/// <param name="Y2">
///   The Y-coordinate of the center of the second circle.
/// </param>
/// <param name="AShrinkFactor">
///   A value to reduce the effective radii of both circles during the overlap check.
/// </param>
/// <returns>
///   <c>True</c> if the circles overlap after applying the shrink factor; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function calculates the distance between the centers of the circles and compares it to the adjusted radii.
///   - A positive <c>AShrinkFactor</c> reduces the overlap area, while a negative value increases it.
/// </remarks>
function AGT_RadiusOverlap(ARadius1, X1, Y1, ARadius2, X2, Y2, AShrinkFactor: Single): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Calculates an eased value over time using a specified easing type.
/// </summary>
/// <param name="ACurrentTime">
///   The current time in the animation or transition, typically ranging from 0 to <c>ADuration</c>.
/// </param>
/// <param name="AStartValue">
///   The starting value of the easing function.
/// </param>
/// <param name="AChangeInValue">
///   The total change in value from the start to the end of the transition.
/// </param>
/// <param name="ADuration">
///   The total duration of the easing transition.
/// </param>
/// <param name="AEaseType">
///   The type of easing to apply. For example:
///   - <c>AGT_etLinearTween</c>: Linear transition.
///   - <c>AGT_etInQuad</c>: Ease in using quadratic function.
///   - <c>AGT_etOutQuad</c>: Ease out using quadratic function.
///   (See <c>AGT_EaseType</c> for all supported easing types.)
/// </param>
/// <returns>
///   The calculated eased value at the specified time.
/// </returns>
/// <remarks>
///   - The function computes a smoothed value based on the elapsed time and easing type.
///   - Ensure <c>ADuration</c> is greater than 0 to avoid division by zero.
///   - Commonly used in animations, UI transitions, and physics-based motion.
/// </remarks>
function AGT_EaseValue(ACurrentTime: Double; AStartValue: Double; AChangeInValue: Double; ADuration: Double; AEaseType: AGT_EaseType): Double; cdecl; external AGT_DLL;

/// <summary>
///   Eases the position of a value between a start and end position using a specified easing type.
/// </summary>
/// <param name="AStartPos">
///   The starting position.
/// </param>
/// <param name="AEndPos">
///   The ending position.
/// </param>
/// <param name="ACurrentPos">
///   The current position, typically a normalized time factor between 0.0 and 1.0.
/// </param>
/// <param name="AEaseType">
///   The type of easing to apply. For example:
///   - <c>AGT_etLinearTween</c>: Linear transition.
///   - <c>AGT_etInQuad</c>: Ease in using quadratic function.
///   - <c>AGT_etOutQuad</c>: Ease out using quadratic function.
///   (See <c>AGT_EaseType</c> for all supported easing types.)
/// </param>
/// <returns>
///   The eased position between the start and end points.
/// </returns>
/// <remarks>
///   - This function interpolates smoothly between two positions based on the current position and easing type.
///   - Commonly used for animations, smooth scrolling, or UI effects.
/// </remarks>
function AGT_EasePosition(AStartPos: Double; AEndPos: Double; ACurrentPos: Double; AEaseType: AGT_EaseType): Double; cdecl; external AGT_DLL;

/// <summary>
///   Determines if two Oriented Bounding Boxes (OBBs) intersect.
/// </summary>
/// <param name="AObbA">
///   The first OBB, defined by its center, extents, and rotation.
/// </param>
/// <param name="AObbB">
///   The second OBB, defined by its center, extents, and rotation.
/// </param>
/// <returns>
///   <c>True</c> if the OBBs intersect; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - An OBB is a rectangle (or box) that can be rotated and is not necessarily axis-aligned.
///   - This function calculates if the two OBBs overlap using their geometries and rotations.
///   - Commonly used for collision detection in 2D or 3D spaces.
/// </remarks>
function AGT_OBBIntersect(const AObbA, AObbB: AGT_OBB): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Converts a normalized unit value (0.0 to 1.0) to a scalar value based on a maximum value.
/// </summary>
/// <param name="AValue">
///   The normalized unit value to convert. Typically between 0.0 and 1.0.
/// </param>
/// <param name="AMaxValue">
///   The maximum scalar value corresponding to a unit value of 1.0.
/// </param>
/// <returns>
///   The scalar value, calculated as <c>AValue * AMaxValue</c>.
/// </returns>
/// <remarks>
///   - Use this function to scale a normalized value to a specific range.
///   - Ensure <c>AValue</c> is within the range [0.0, 1.0] for meaningful results, though values outside this range are technically allowed.
///   - Useful for mapping percentage-based values to their actual representations in a given scale.
/// </remarks>
function AGT_UnitToScalarValue(const AValue, AMaxValue: Double): Double; cdecl; external AGT_DLL;

//=== COLOR =================================================================
/// <summary>
///   Represents a color with red, green, blue, and alpha (opacity) components.
/// </summary>
type
  PAGT_Color = ^AGT_Color;
  AGT_Color = record
    /// <summary>
    ///   The red component of the color, represented as a floating-point value between 0.0 and 1.0.
/// </summary>
    r: Single;
    /// <summary>
    ///   The green component of the color, represented as a floating-point value between 0.0 and 1.0.
/// </summary>
    g: Single;
    /// <summary>
    ///   The blue component of the color, represented as a floating-point value between 0.0 and 1.0.
/// </summary>
    b: Single;
    /// <summary>
    ///   The alpha (opacity) component of the color, represented as a floating-point value between 0.0 and 1.0.
/// </summary>
    a: Single;
  end;

/// <summary>
///   Creates a color from byte components (0-255).
/// </summary>
/// <param name="r">
///   The red component of the color, as a byte (0-255).
/// </param>
/// <param name="g">
///   The green component of the color, as a byte (0-255).
/// </param>
/// <param name="b">
///   The blue component of the color, as a byte (0-255).
/// </param>
/// <param name="a">
///   The alpha (opacity) component of the color, as a byte (0-255).
/// </param>
/// <returns>
///   An <c>AGT_Color</c> structure with the specified components, converted to floating-point values (0.0 to 1.0).
/// </returns>
/// <remarks>
///   This function is useful for creating colors from standard 8-bit RGB(A) values.
/// </remarks>
function AGT_Color_FromByte(const r, g, b, a: Byte): AGT_Color; cdecl; external AGT_DLL;

/// <summary>
///   Creates a color from floating-point components (0.0-1.0).
/// </summary>
/// <param name="r">
///   The red component of the color, as a floating-point value (0.0-1.0).
/// </param>
/// <param name="g">
///   The green component of the color, as a floating-point value (0.0-1.0).
/// </param>
/// <param name="b">
///   The blue component of the color, as a floating-point value (0.0-1.0).
/// </param>
/// <param name="a">
///   The alpha (opacity) component of the color, as a floating-point value (0.0-1.0).
/// </param>
/// <returns>
///   An <c>AGT_Color</c> structure with the specified components.
/// </returns>
/// <remarks>
///   This function is ideal for creating colors when the input is already normalized to the 0.0-1.0 range.
/// </remarks>
function AGT_Color_FromFloat(const r, g, b, a: Single): AGT_Color; cdecl; external AGT_DLL;

/// <summary>
///   Performs a linear interpolation (fade) between two colors.
/// </summary>
/// <param name="AFrom">
///   The starting color.
/// </param>
/// <param name="ATo">
///   The target color.
/// </param>
/// <param name="APos">
///   The interpolation factor, where 0.0 corresponds to <c>AFrom</c> and 1.0 corresponds to <c>ATo</c>.
/// </param>
/// <returns>
///   An <c>AGT_Color</c> structure representing the interpolated color.
/// </returns>
/// <remarks>
///   - This function calculates a color that is a blend between <c>AFrom</c> and <c>ATo</c>.
///   - Ensure <c>APos</c> is within the range [0.0, 1.0] for predictable results, though values outside this range are technically allowed.
/// </remarks>
function AGT_Color_Fade(const AFrom, ATo: AGT_Color; const APos: Single): AGT_Color; cdecl; external AGT_DLL;

/// <summary>
///   Checks if two colors are equal, considering all components (R, G, B, A).
/// </summary>
/// <param name="AColor1">
///   The first color to compare.
/// </param>
/// <param name="AColor2">
///   The second color to compare.
/// </param>
/// <returns>
///   <c>True</c> if all components of the colors are equal; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   This function performs a direct comparison of the floating-point components of both colors.
/// </remarks>
function AGT_Color_IsEqual(const AColor1, AColor2: AGT_Color): Boolean; cdecl; external AGT_DLL;

{$REGION ' COMMON COLORS '}
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
{$ENDREGION}

//=== WINDOW ================================================================

{$REGION ' KEYS, BUTTONS & GAMEPAD CONST '}
const
  AGT_KEY_UNKNOWN = -1;
  AGT_KEY_SPACE = 32;
  AGT_KEY_APOSTROPHE = 39;
  AGT_KEY_COMMA = 44;
  AGT_KEY_MINUS = 45;
  AGT_KEY_PERIOD = 46;
  AGT_KEY_SLASH = 47;
  AGT_KEY_0 = 48;
  AGT_KEY_1 = 49;
  AGT_KEY_2 = 50;
  AGT_KEY_3 = 51;
  AGT_KEY_4 = 52;
  AGT_KEY_5 = 53;
  AGT_KEY_6 = 54;
  AGT_KEY_7 = 55;
  AGT_KEY_8 = 56;
  AGT_KEY_9 = 57;
  AGT_KEY_SEMICOLON = 59;
  AGT_KEY_EQUAL = 61;
  AGT_KEY_A = 65;
  AGT_KEY_B = 66;
  AGT_KEY_C = 67;
  AGT_KEY_D = 68;
  AGT_KEY_E = 69;
  AGT_KEY_F = 70;
  AGT_KEY_G = 71;
  AGT_KEY_H = 72;
  AGT_KEY_I = 73;
  AGT_KEY_J = 74;
  AGT_KEY_K = 75;
  AGT_KEY_L = 76;
  AGT_KEY_M = 77;
  AGT_KEY_N = 78;
  AGT_KEY_O = 79;
  AGT_KEY_P = 80;
  AGT_KEY_Q = 81;
  AGT_KEY_R = 82;
  AGT_KEY_S = 83;
  AGT_KEY_T = 84;
  AGT_KEY_U = 85;
  AGT_KEY_V = 86;
  AGT_KEY_W = 87;
  AGT_KEY_X = 88;
  AGT_KEY_Y = 89;
  AGT_KEY_Z = 90;
  AGT_KEY_LEFT_BRACKET = 91;
  AGT_KEY_BACKSLASH = 92;
  AGT_KEY_RIGHT_BRACKET = 93;
  AGT_KEY_GRAVE_ACCENT = 96;
  AGT_KEY_WORLD_1 = 161;
  AGT_KEY_WORLD_2 = 162;
  AGT_KEY_ESCAPE = 256;
  AGT_KEY_ENTER = 257;
  AGT_KEY_TAB = 258;
  AGT_KEY_BACKSPACE = 259;
  AGT_KEY_INSERT = 260;
  AGT_KEY_DELETE = 261;
  AGT_KEY_RIGHT = 262;
  AGT_KEY_LEFT = 263;
  AGT_KEY_DOWN = 264;
  AGT_KEY_UP = 265;
  AGT_KEY_PAGE_UP = 266;
  AGT_KEY_PAGE_DOWN = 267;
  AGT_KEY_HOME = 268;
  AGT_KEY_END = 269;
  AGT_KEY_CAPS_LOCK = 280;
  AGT_KEY_SCROLL_LOCK = 281;
  AGT_KEY_NUM_LOCK = 282;
  AGT_KEY_PRINT_SCREEN = 283;
  AGT_KEY_PAUSE = 284;
  AGT_KEY_F1 = 290;
  AGT_KEY_F2 = 291;
  AGT_KEY_F3 = 292;
  AGT_KEY_F4 = 293;
  AGT_KEY_F5 = 294;
  AGT_KEY_F6 = 295;
  AGT_KEY_F7 = 296;
  AGT_KEY_F8 = 297;
  AGT_KEY_F9 = 298;
  AGT_KEY_F10 = 299;
  AGT_KEY_F11 = 300;
  AGT_KEY_F12 = 301;
  AGT_KEY_F13 = 302;
  AGT_KEY_F14 = 303;
  AGT_KEY_F15 = 304;
  AGT_KEY_F16 = 305;
  AGT_KEY_F17 = 306;
  AGT_KEY_F18 = 307;
  AGT_KEY_F19 = 308;
  AGT_KEY_F20 = 309;
  AGT_KEY_F21 = 310;
  AGT_KEY_F22 = 311;
  AGT_KEY_F23 = 312;
  AGT_KEY_F24 = 313;
  AGT_KEY_F25 = 314;
  AGT_KEY_KP_0 = 320;
  AGT_KEY_KP_1 = 321;
  AGT_KEY_KP_2 = 322;
  AGT_KEY_KP_3 = 323;
  AGT_KEY_KP_4 = 324;
  AGT_KEY_KP_5 = 325;
  AGT_KEY_KP_6 = 326;
  AGT_KEY_KP_7 = 327;
  AGT_KEY_KP_8 = 328;
  AGT_KEY_KP_9 = 329;
  AGT_KEY_KP_DECIMAL = 330;
  AGT_KEY_KP_DIVIDE = 331;
  AGT_KEY_KP_MULTIPLY = 332;
  AGT_KEY_KP_SUBTRACT = 333;
  AGT_KEY_KP_ADD = 334;
  AGT_KEY_KP_ENTER = 335;
  AGT_KEY_KP_EQUAL = 336;
  AGT_KEY_LEFT_SHIFT = 340;
  AGT_KEY_LEFT_CONTROL = 341;
  AGT_KEY_LEFT_ALT = 342;
  AGT_KEY_LEFT_SUPER = 343;
  AGT_KEY_RIGHT_SHIFT = 344;
  AGT_KEY_RIGHT_CONTROL = 345;
  AGT_KEY_RIGHT_ALT = 346;
  AGT_KEY_RIGHT_SUPER = 347;
  AGT_KEY_MENU = 348;
  AGT_KEY_LAST = AGT_KEY_MENU;

const
  AGT_MOUSE_BUTTON_1 = 0;
  AGT_MOUSE_BUTTON_2 = 1;
  AGT_MOUSE_BUTTON_3 = 2;
  AGT_MOUSE_BUTTON_4 = 3;
  AGT_MOUSE_BUTTON_5 = 4;
  AGT_MOUSE_BUTTON_6 = 5;
  AGT_MOUSE_BUTTON_7 = 6;
  AGT_MOUSE_BUTTON_8 = 7;
  AGT_MOUSE_BUTTON_LAST = 7;
  AGT_MOUSE_BUTTON_LEFT = 0;
  AGT_MOUSE_BUTTON_RIGHT = 1;
  AGT_MOUSE_BUTTON_MIDDLE = 2;

const
  AGT_GAMEPAD_1 = 0;
  AGT_GAMEPAD_2 = 1;
  AGT_GAMEPAD_3 = 2;
  AGT_GAMEPAD_4 = 3;
  AGT_GAMEPAD_5 = 4;
  AGT_GAMEPAD_6 = 5;
  AGT_GAMEPAD_7 = 6;
  AGT_GAMEPAD_8 = 7;
  AGT_GAMEPAD_9 = 8;
  AGT_GAMEPAD_10 = 9;
  AGT_GAMEPAD_11 = 10;
  AGT_GAMEPAD_12 = 11;
  AGT_GAMEPAD_13 = 12;
  AGT_GAMEPAD_14 = 13;
  AGT_GAMEPAD_15 = 14;
  AGT_GAMEPAD_16 = 15;
  AGT_GAMEPAD_LAST = AGT_GAMEPAD_16;

const
  AGT_GAMEPAD_BUTTON_A = 0;
  AGT_GAMEPAD_BUTTON_B = 1;
  AGT_GAMEPAD_BUTTON_X = 2;
  AGT_GAMEPAD_BUTTON_Y = 3;
  AGT_GAMEPAD_BUTTON_LEFT_BUMPER = 4;
  AGT_GAMEPAD_BUTTON_RIGHT_BUMPER = 5;
  AGT_GAMEPAD_BUTTON_BACK = 6;
  AGT_GAMEPAD_BUTTON_START = 7;
  AGT_GAMEPAD_BUTTON_GUIDE = 8;
  AGT_GAMEPAD_BUTTON_LEFT_THUMB = 9;
  AGT_GAMEPAD_BUTTON_RIGHT_THUMB = 10;
  AGT_GAMEPAD_BUTTON_DPAD_UP = 11;
  AGT_GAMEPAD_BUTTON_DPAD_RIGHT = 12;
  AGT_GAMEPAD_BUTTON_DPAD_DOWN = 13;
  AGT_GAMEPAD_BUTTON_DPAD_LEFT = 14;
  AGT_GAMEPAD_BUTTON_LAST = AGT_GAMEPAD_BUTTON_DPAD_LEFT;
  AGT_GAMEPAD_BUTTON_CROSS = AGT_GAMEPAD_BUTTON_A;
  AGT_GAMEPAD_BUTTON_CIRCLE = AGT_GAMEPAD_BUTTON_B;
  AGT_GAMEPAD_BUTTON_SQUARE = AGT_GAMEPAD_BUTTON_X;
  AGT_AMEPAD_BUTTON_TRIANGLE = AGT_GAMEPAD_BUTTON_Y;

const
  AGT_GAMEPAD_AXIS_LEFT_X = 0;
  AGT_GAMEPAD_AXIS_LEFT_Y = 1;
  AGT_GAMEPAD_AXIS_RIGHT_X = 2;
  AGT_GAMEPAD_AXIS_RIGHT_Y = 3;
  AGT_GAMEPAD_AXIS_LEFT_TRIGGER = 4;
  AGT_GAMEPAD_AXIS_RIGHT_TRIGGER = 5;
  AGT_GAMEPAD_AXIS_LAST = AGT_GAMEPAD_AXIS_RIGHT_TRIGGER;
{$ENDREGION}

/// <summary>
///   The default width of the application window, set to half of 1920 pixels (960 pixels).
/// </summary>
const
  AGT_DEFAULT_WINDOW_WIDTH = 1920 div 2;

/// <summary>
///   The default height of the application window, set to half of 1080 pixels (540 pixels).
/// </summary>
const
  AGT_DEFAULT_WINDOW_HEIGHT = 1080 div 2;

/// <summary>
///   The default frames per second (FPS) for the application.
/// </summary>
/// <remarks>
///   This value represents the target frame rate, commonly used for smooth animations and rendering.
/// </remarks>
const
  AGT_DEFAULT_FPS = 60;

/// <summary>
///   Represents a pointer to a window object, used for managing application windows.
/// </summary>
/// <remarks>
///   This type is abstract and intended to encapsulate platform-specific window management details.
/// </remarks>
type
  AGT_Window = Pointer;

/// <summary>
///   Enumerates the possible states of an input device (e.g., keyboard, mouse).
/// </summary>
type
  AGT_InputState = (
    /// <summary>
    ///   The input is currently pressed.
/// </summary>
    AGT_isPressed,

    /// <summary>
    ///   The input was pressed in the last frame.
/// </summary>
    AGT_isWasPressed,

    /// <summary>
    ///   The input was released in the last frame.
/// </summary>
    AGT_isWasReleased
  );

/// <summary>
///   Opens a new application window with the specified title and dimensions.
/// </summary>
/// <param name="ATitle">
///   The title of the window, as a wide-character string.
/// </param>
/// <param name="AVirtualWidth">
///   The virtual width of the window in pixels. Defaults to <c>AGT_DEFAULT_WINDOW_WIDTH</c> (960 pixels).
/// </param>
/// <param name="AVirtualHeight">
///   The virtual height of the window in pixels. Defaults to <c>AGT_DEFAULT_WINDOW_HEIGHT</c> (540 pixels).
/// </param>
/// <param name="AParent">
///   A handle to the parent window (optional). Use 0 if the window has no parent.
/// </param>
/// <returns>
///   A pointer to the created <c>AGT_Window</c> object, or <c>nil</c> if the operation fails.
/// </returns>
/// <remarks>
///   - This function initializes and opens a new window for rendering or user interaction.
///   - The window dimensions can be specified explicitly, or default to half-HD resolution.
///   - The <c>AParent</c> parameter can be used to embed the window within another window, if supported by the platform.
///   - The caller is responsible for closing the window using <c>AGT_Window_Close</c>.
/// </remarks>
function AGT_Window_Open(const ATitle: PWideChar; const AVirtualWidth: Cardinal = AGT_DEFAULT_WINDOW_WIDTH; const AVirtualHeight: Cardinal = AGT_DEFAULT_WINDOW_HEIGHT; const AParent: NativeUInt = 0): AGT_Window; cdecl; external AGT_DLL;

/// <summary>
///   Closes an open window and releases its associated resources.
/// </summary>
/// <param name="AWindow">
///   The window to close. This parameter is passed by reference and is set to <c>nil</c> upon successful closure.
/// </param>
/// <remarks>
///   - This function ensures that all resources associated with the window are properly released.
///   - After calling this function, the <c>AWindow</c> variable is set to <c>nil</c>, indicating that the window is no longer valid.
///   - Ensure that the window is closed before program termination to avoid resource leaks.
/// </remarks>
procedure AGT_Window_Close(var AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the title of the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose title is to be retrieved.
/// </param>
/// <returns>
///   A wide-character string containing the title of the window, or <c>nil</c> if the operation fails.
/// </returns>
/// <remarks>
///   - This function returns the current title of the window as a wide-character string.
///   - The returned string is managed by the window system and should not be modified or freed by the caller.
///   - Ensure the window handle is valid before calling this function to avoid undefined behavior.
/// </remarks>
function AGT_Window_GetTitle(const AWindow: AGT_Window): PWideChar; cdecl; external AGT_DLL;

/// <summary>
///   Sets the title of the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose title is to be set.
/// </param>
/// <param name="ATitle">
///   A wide-character string containing the new title for the window.
/// </param>
/// <remarks>
///   - This function updates the title displayed in the window's title bar.
///   - Ensure the window handle is valid before calling this function to avoid undefined behavior.
///   - The title string must be null-terminated and properly encoded as a wide-character string.
/// </remarks>
procedure AGT_Window_SetTitle(const AWindow: AGT_Window; const ATitle: PWideChar); cdecl; external AGT_DLL;

/// <summary>
///   Sets the minimum and maximum size limits for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose size limits are to be set.
/// </param>
/// <param name="AMinWidth">
///   The minimum allowable width of the window, in pixels.
/// </param>
/// <param name="AMinHeight">
///   The minimum allowable height of the window, in pixels.
/// </param>
/// <param name="AMaxWidth">
///   The maximum allowable width of the window, in pixels. Use 0 to indicate no upper limit.
/// </param>
/// <param name="AMaxHeight">
///   The maximum allowable height of the window, in pixels. Use 0 to indicate no upper limit.
/// </param>
/// <remarks>
///   - Use this function to constrain the resizable bounds of a window.
///   - Setting both maximum width and height to 0 removes any upper size restrictions.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
procedure AGT_Window_SetSizeLimits(const AWindow: AGT_Window; const AMinWidth, AMinHeight, AMaxWidth, AMaxHeight: Integer); cdecl; external AGT_DLL;

/// <summary>
///   Resizes the specified window to the given dimensions.
/// </summary>
/// <param name="AWindow">
///   A handle to the window to be resized.
/// </param>
/// <param name="AWidth">
///   The new width of the window, in pixels.
/// </param>
/// <param name="AHeight">
///   The new height of the window, in pixels.
/// </param>
/// <remarks>
///   - This function explicitly sets the window's size, overriding any size constraints.
///   - Ensure the window handle is valid and that the dimensions are within acceptable ranges.
///   - May not have an immediate effect if the window is in fullscreen mode.
/// </remarks>
procedure AGT_Window_Resize(const AWindow: AGT_Window; const AWidth, AHeight: Cardinal); cdecl; external AGT_DLL;

/// <summary>
///   Toggles the fullscreen mode of the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose fullscreen state is to be toggled.
/// </param>
/// <remarks>
///   - If the window is currently in windowed mode, this function switches it to fullscreen mode, and vice versa.
///   - Fullscreen mode may adjust the resolution and aspect ratio of the display.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
procedure AGT_Window_ToggleFullscreen(const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Checks if the specified window is currently in fullscreen mode.
/// </summary>
/// <param name="AWindow">
///   A handle to the window to check.
/// </param>
/// <returns>
///   <c>True</c> if the window is in fullscreen mode; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function is useful for determining the current display mode of a window.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_IsFullscreen(const AWindow: AGT_Window): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks if the specified window currently has input focus.
/// </summary>
/// <param name="AWindow">
///   A handle to the window to check.
/// </param>
/// <returns>
///   <c>True</c> if the window has input focus; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - A window with input focus is the active window that receives user input, such as keyboard or mouse events.
///   - This function is useful for determining whether the application should process input or pause when the window is not active.
///   - Ensure the window handle is valid before calling this function to avoid undefined behavior.
/// </remarks>
function AGT_Window_HasFocus(const AWindow: AGT_Window): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the virtual size of the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose virtual size is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Size</c> structure representing the virtual width and height of the window.
/// </returns>
/// <remarks>
///   - The virtual size refers to the logical dimensions of the window, which may differ from its actual physical size.
///   - This is useful for applications with scaling or resolution independence.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetVirtualSize(const AWindow: AGT_Window): AGT_Size; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the actual size of the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose size is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Size</c> structure representing the actual width and height of the window in pixels.
/// </returns>
/// <remarks>
///   - The actual size corresponds to the physical dimensions of the window on the screen.
///   - This function is useful for handling high-DPI displays or when calculating pixel-based layouts.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetSize(const AWindow: AGT_Window): AGT_Size; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the scaling factor of the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose scale factor is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Size</c> structure representing the horizontal and vertical scale factors.
/// </returns>
/// <remarks>
///   - The scale factor represents the ratio between the virtual size and the actual size of the window.
///   - A scale of (1.0, 1.0) indicates no scaling, while values greater than 1.0 indicate upscaling.
///   - This function is useful for UI scaling, resolution independence, or adapting to high-DPI displays.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetScale(const AWindow: AGT_Window): AGT_Size; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the maximum texture size supported by the window's rendering context.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which to query the maximum texture size.
/// </param>
/// <returns>
///   The maximum texture size, in pixels, supported by the rendering context.
/// </returns>
/// <remarks>
///   - The maximum texture size depends on the capabilities of the underlying graphics hardware and driver.
///   - This value is useful for optimizing texture usage and ensuring compatibility with the rendering pipeline.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetMaxTextureSize(const AWindow: AGT_Window): Integer; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the viewport of the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose viewport is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Rect</c> structure representing the viewport, defined by its position and size.
/// </returns>
/// <remarks>
///   - The viewport defines the visible area of the window where rendering occurs.
///   - The position and size of the viewport may differ from the window's actual dimensions, especially with scaling or letterboxing.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetViewport(const AWindow: AGT_Window): AGT_Rect; cdecl; external AGT_DLL;

/// <summary>
///   Centers the specified window on the screen.
/// </summary>
/// <param name="AWindow">
///   A handle to the window to be centered.
/// </param>
/// <remarks>
///   - This function adjusts the position of the window so it appears centered on the primary display or the display where the window resides.
///   - Ensure the window handle is valid before calling this function.
///   - The centering behavior may vary depending on the window manager or operating system.
/// </remarks>
procedure AGT_Window_Center(const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Checks if the specified window has been flagged for closure.
/// </summary>
/// <param name="AWindow">
///   A handle to the window to check.
/// </param>
/// <returns>
///   <c>True</c> if the window is flagged for closure; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function is typically used in an application's main loop to determine whether the user has requested the window to close.
///   - Flags for closure can be set through user actions (e.g., clicking the close button) or programmatically.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_ShouldClose(const AWindow: AGT_Window): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Sets the closure flag for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which to set the closure flag.
/// </param>
/// <param name="AClose">
///   A Boolean value indicating whether the window should be flagged for closure.
///   - <c>True</c>: The window will be marked as ready to close.
///   - <c>False</c>: The closure flag will be cleared, preventing the window from closing.
/// </param>
/// <remarks>
///   - Use this function to programmatically control whether a window should close.
///   - Setting the flag to <c>True</c> typically terminates the application's main loop.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
procedure AGT_Window_SetShouldClose(const AWindow: AGT_Window; const AClose: Boolean); cdecl; external AGT_DLL;

/// <summary>
///   Prepares the specified window for a new frame of rendering.
/// </summary>
/// <param name="AWindow">
///   A handle to the window to prepare for rendering.
/// </param>
/// <remarks>
///   - This procedure sets up the necessary state for rendering a new frame in the specified window.
///   - It is typically called at the beginning of a frame before any drawing or updates.
///   - Ensure the window handle is valid before calling this procedure.
///   - Must be paired with a call to <c>AGT_Window_EndFrame</c> to complete the rendering process.
/// </remarks>
procedure AGT_Window_StartFrame(const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Completes the rendering process for the current frame in the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the frame rendering is to be completed.
/// </param>
/// <remarks>
///   - This procedure finalizes the rendering process for the current frame, presenting the rendered content to the window.
///   - It is typically called at the end of a frame after all drawing and updates are complete.
///   - Ensure the window handle is valid before calling this procedure.
///   - Must be paired with a preceding call to <c>AGT_Window_StartFrame</c> to ensure a proper rendering cycle.
/// </remarks>
procedure AGT_Window_EndFrame(const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Prepares the specified window for drawing operations.
/// </summary>
/// <param name="AWindow">
///   A handle to the window to prepare for drawing.
/// </param>
/// <remarks>
///   - This procedure sets up the rendering context for drawing on the specified window.
///   - It is typically called at the beginning of a drawing phase before any rendering commands are issued.
///   - Ensure the window handle is valid before calling this procedure.
///   - Must be followed by a call to <c>AGT_Window_EndDrawing</c> to finalize the drawing phase.
/// </remarks>
procedure AGT_Window_StartDrawing(const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Resets the current drawing state for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose drawing state is to be reset.
/// </param>
/// <remarks>
///   - This procedure clears or resets the rendering context, preparing it for a fresh set of drawing operations.
///   - Useful for reinitializing the drawing state mid-frame without ending the current drawing phase.
///   - Ensure the window handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Window_ResetDrawing(const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Finalizes the drawing operations for the specified window and presents the result.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which drawing is to be finalized.
/// </param>
/// <remarks>
///   - This procedure completes the drawing phase and displays the rendered content in the specified window.
///   - It is typically called after all rendering commands are executed during a frame.
///   - Ensure the window handle is valid before calling this procedure.
///   - Must be paired with a preceding call to <c>AGT_Window_StartDrawing</c> to ensure a proper drawing cycle.
/// </remarks>
procedure AGT_Window_EndDrawing(const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Clears the content of the specified window with a given color.
/// </summary>
/// <param name="AWindow">
///   A handle to the window to clear.
/// </param>
/// <param name="AColor">
///   The color to use for clearing the window, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <remarks>
///   - This procedure fills the entire rendering area of the window with the specified color.
///   - Typically called at the beginning of a frame or drawing cycle to reset the rendering surface.
///   - Ensure the window handle is valid before calling this procedure.
///   - The clearing color can include transparency if supported by the rendering context.
/// </remarks>
procedure AGT_Window_Clear(const AWindow: AGT_Window; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Draws a line on the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the line will be drawn.
/// </param>
/// <param name="X1">
///   The X-coordinate of the starting point of the line.
/// </param>
/// <param name="Y1">
///   The Y-coordinate of the starting point of the line.
/// </param>
/// <param name="X2">
///   The X-coordinate of the ending point of the line.
/// </param>
/// <param name="Y2">
///   The Y-coordinate of the ending point of the line.
/// </param>
/// <param name="AColor">
///   The color of the line, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <param name="AThickness">
///   The thickness of the line, in pixels.
/// </param>
/// <remarks>
///   - This procedure draws a straight line between two points using the specified color and thickness.
///   - Ensure the window handle is valid before calling this procedure.
///   - The thickness affects the visual width of the line and may depend on the rendering context's support for line thickness.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawLine(const AWindow: AGT_Window; const X1, Y1, X2, Y2: Single; const AColor: AGT_Color; const AThickness: Single); cdecl; external AGT_DLL;

/// <summary>
///   Draws a rectangle on the specified window with a border of a specified thickness.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the rectangle will be drawn.
/// </param>
/// <param name="X">
///   The X-coordinate of the rectangle's center.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the rectangle's center.
/// </param>
/// <param name="AWidth">
///   The width of the rectangle, in pixels.
/// </param>
/// <param name="AHeight">
///   The height of the rectangle, in pixels.
/// </param>
/// <param name="AThickness">
///   The thickness of the rectangle's border, in pixels.
/// </param>
/// <param name="AColor">
///   The color of the rectangle's border, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <param name="AAngle">
///   The rotation angle of the rectangle, in degrees, counterclockwise.
/// </param>
/// <remarks>
///   - This procedure draws only the border of the rectangle, leaving the interior transparent.
///   - Ensure the window handle is valid before calling this procedure.
///   - The rotation is applied around the rectangle's center.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawRect(const AWindow: AGT_Window; const X, Y, AWidth, AHeight, AThickness: Single; const AColor: AGT_Color; const AAngle: Single); cdecl; external AGT_DLL;

/// <summary>
///   Draws a filled rectangle on the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the rectangle will be drawn.
/// </param>
/// <param name="X">
///   The X-coordinate of the rectangle's center.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the rectangle's center.
/// </param>
/// <param name="AWidth">
///   The width of the rectangle, in pixels.
/// </param>
/// <param name="AHeight">
///   The height of the rectangle, in pixels.
/// </param>
/// <param name="AColor">
///   The color of the rectangle, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <param name="AAngle">
///   The rotation angle of the rectangle, in degrees, counterclockwise.
/// </param>
/// <remarks>
///   - This procedure fills the entire area of the rectangle with the specified color.
///   - Ensure the window handle is valid before calling this procedure.
///   - The rotation is applied around the rectangle's center.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawFilledRect(const AWindow: AGT_Window; const X, Y, AWidth, AHeight: Single; const AColor: AGT_Color; const AAngle: Single); cdecl; external AGT_DLL;

/// <summary>
///   Draws a circle on the specified window with a border of a specified thickness.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the circle will be drawn.
/// </param>
/// <param name="X">
///   The X-coordinate of the circle's center.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the circle's center.
/// </param>
/// <param name="ARadius">
///   The radius of the circle, in pixels.
/// </param>
/// <param name="AThickness">
///   The thickness of the circle's border, in pixels.
/// </param>
/// <param name="AColor">
///   The color of the circle's border, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <remarks>
///   - This procedure draws only the border of the circle, leaving the interior transparent.
///   - Ensure the window handle is valid before calling this procedure.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawCircle(const AWindow: AGT_Window; const X, Y, ARadius, AThickness: Single; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Draws a filled circle on the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the circle will be drawn.
/// </param>
/// <param name="X">
///   The X-coordinate of the circle's center.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the circle's center.
/// </param>
/// <param name="ARadius">
///   The radius of the circle, in pixels.
/// </param>
/// <param name="AColor">
///   The color of the circle, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <remarks>
///   - This procedure fills the entire area of the circle with the specified color.
///   - Ensure the window handle is valid before calling this procedure.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawFilledCircle(const AWindow: AGT_Window; const X, Y, ARadius: Single; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Draws a triangle on the specified window with a border of a specified thickness.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the triangle will be drawn.
/// </param>
/// <param name="X1">
///   The X-coordinate of the first vertex of the triangle.
/// </param>
/// <param name="Y1">
///   The Y-coordinate of the first vertex of the triangle.
/// </param>
/// <param name="X2">
///   The X-coordinate of the second vertex of the triangle.
/// </param>
/// <param name="Y2">
///   The Y-coordinate of the second vertex of the triangle.
/// </param>
/// <param name="X3">
///   The X-coordinate of the third vertex of the triangle.
/// </param>
/// <param name="Y3">
///   The Y-coordinate of the third vertex of the triangle.
/// </param>
/// <param name="AThickness">
///   The thickness of the triangle's border, in pixels.
/// </param>
/// <param name="AColor">
///   The color of the triangle's border, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <remarks>
///   - This procedure draws only the border of the triangle, leaving the interior transparent.
///   - Ensure the window handle is valid before calling this procedure.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawTriangle(const AWindow: AGT_Window; const X1, Y1, X2, Y2, X3, Y3, AThickness: Single; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Draws a filled triangle on the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the triangle will be drawn.
/// </param>
/// <param name="X1">
///   The X-coordinate of the first vertex of the triangle.
/// </param>
/// <param name="Y1">
///   The Y-coordinate of the first vertex of the triangle.
/// </param>
/// <param name="X2">
///   The X-coordinate of the second vertex of the triangle.
/// </param>
/// <param name="Y2">
///   The Y-coordinate of the second vertex of the triangle.
/// </param>
/// <param name="X3">
///   The X-coordinate of the third vertex of the triangle.
/// </param>
/// <param name="Y3">
///   The Y-coordinate of the third vertex of the triangle.
/// </param>
/// <param name="AColor">
///   The color of the triangle, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <remarks>
///   - This procedure fills the entire area of the triangle with the specified color.
///   - Ensure the window handle is valid before calling this procedure.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawFilledTriangle(const AWindow: AGT_Window; const X1, Y1, X2, Y2, X3, Y3: Single; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Draws a polygon on the specified window with a border of a specified thickness.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the polygon will be drawn.
/// </param>
/// <param name="APoints">
///   A pointer to an array of <c>AGT_Point</c> structures representing the vertices of the polygon.
/// </param>
/// <param name="ACount">
///   The number of vertices in the polygon.
/// </param>
/// <param name="AThickness">
///   The thickness of the polygon's border, in pixels.
/// </param>
/// <param name="AColor">
///   The color of the polygon's border, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <remarks>
///   - This procedure draws only the border of the polygon, leaving the interior transparent.
///   - The vertices are connected sequentially, and the last vertex is connected back to the first.
///   - Ensure the window handle, the array of points, and the count are valid before calling this procedure.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawPolygon(const AWindow: AGT_Window; const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Draws a filled polygon on the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the polygon will be drawn.
/// </param>
/// <param name="APoints">
///   A pointer to an array of <c>AGT_Point</c> structures representing the vertices of the polygon.
/// </param>
/// <param name="ACount">
///   The number of vertices in the polygon.
/// </param>
/// <param name="AColor">
///   The color of the polygon, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <remarks>
///   - This procedure fills the entire area of the polygon with the specified color.
///   - The vertices are connected sequentially, and the interior is filled.
///   - Ensure the window handle, the array of points, and the count are valid before calling this procedure.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawFilledPolygon(const AWindow: AGT_Window; const APoints: PAGT_Point; const ACount: UInt32; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Draws a polyline on the specified window with a specified thickness.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the polyline will be drawn.
/// </param>
/// <param name="APoints">
///   A pointer to an array of <c>AGT_Point</c> structures representing the vertices of the polyline.
/// </param>
/// <param name="ACount">
///   The number of vertices in the polyline.
/// </param>
/// <param name="AThickness">
///   The thickness of the polyline, in pixels.
/// </param>
/// <param name="AColor">
///   The color of the polyline, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <remarks>
///   - This procedure draws a series of connected line segments, defined by the sequence of vertices.
///   - The polyline is not closed (does not connect the last vertex back to the first).
///   - Ensure the window handle, the array of points, and the count are valid before calling this procedure.
///   - The color supports RGBA values, allowing for transparency if the rendering context supports it.
/// </remarks>
procedure AGT_Window_DrawPolyline(const AWindow: AGT_Window; const APoints: PAGT_Point; const ACount: UInt32; const AThickness: Single; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Clears the input state for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window whose input state is to be cleared.
/// </param>
/// <remarks>
///   - This procedure resets all recorded input states for the specified window.
///   - Useful for ensuring no lingering input events affect subsequent input handling.
///   - Typically called at the beginning or end of a frame to reset input processing.
///   - Ensure the window handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Window_ClearInput(const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Checks the state of a specific key in the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the key state is to be checked.
/// </param>
/// <param name="AKey">
///   The key code of the key to check, typically corresponding to a predefined key constant or platform-specific value.
/// </param>
/// <param name="AState">
///   The desired input state to check, specified as an <c>AGT_InputState</c> value:
///   - <c>AGT_isPressed</c>: The key is currently pressed.
///   - <c>AGT_isWasPressed</c>: The key was pressed in the last frame.
///   - <c>AGT_isWasReleased</c>: The key was released in the last frame.
/// </param>
/// <returns>
///   <c>True</c> if the key is in the specified state; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function allows checking for specific input events (e.g., key presses, releases) for a given key.
///   - Ensure the window handle and key code are valid before calling this function.
///   - The key codes and their mappings depend on the platform and input library used.
/// </remarks>
function AGT_Window_GetKey(const AWindow: AGT_Window; const AKey: Integer; const AState: AGT_InputState): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks the state of a specific mouse button in the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the mouse button state is to be checked.
/// </param>
/// <param name="AButton">
///   The mouse button to check, specified as a byte. Common values:
///   - <c>0</c>: Left mouse button.
///   - <c>1</c>: Right mouse button.
///   - <c>2</c>: Middle mouse button (scroll wheel button).
/// </param>
/// <param name="AState">
///   The desired input state to check, specified as an <c>AGT_InputState</c> value:
///   - <c>AGT_isPressed</c>: The button is currently pressed.
///   - <c>AGT_isWasPressed</c>: The button was pressed in the last frame.
///   - <c>AGT_isWasReleased</c>: The button was released in the last frame.
/// </param>
/// <returns>
///   <c>True</c> if the button is in the specified state; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function allows checking for specific mouse button events (e.g., press, release) for the specified button.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetMouseButton(const AWindow: AGT_Window; const AButton: Byte; const AState: AGT_InputState): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current position of the mouse cursor relative to the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the mouse position is to be retrieved.
/// </param>
/// <param name="X">
///   A pointer to a variable to store the X-coordinate of the mouse position.
/// </param>
/// <param name="Y">
///   A pointer to a variable to store the Y-coordinate of the mouse position.
/// </param>
/// <remarks>
///   - This function writes the mouse coordinates into the provided variables.
///   - Ensure the window handle and pointers are valid before calling this function.
/// </remarks>
procedure AGT_Window_GetMousePosXY(const AWindow: AGT_Window; const X, Y: System.PSingle); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current position of the mouse cursor relative to the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the mouse position is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Point</c> structure containing the X and Y coordinates of the mouse position.
/// </returns>
/// <remarks>
///   - This function provides a convenient way to retrieve the mouse position as a single value.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetMousePos(const AWindow: AGT_Window): AGT_Point; cdecl; external AGT_DLL;

/// <summary>
///   Sets the position of the mouse cursor relative to the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the mouse position is to be set.
/// </param>
/// <param name="X">
///   The new X-coordinate of the mouse position.
/// </param>
/// <param name="Y">
///   The new Y-coordinate of the mouse position.
/// </param>
/// <remarks>
///   - This function moves the mouse cursor to the specified coordinates within the window.
///   - Ensure the window handle is valid before calling this function.
///   - May not work as expected if the operating system restricts mouse position control.
/// </remarks>
procedure AGT_Window_SetMousePos(const AWindow: AGT_Window; const X, Y: Single); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current state of the mouse wheel in the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the mouse wheel state is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Vector</c> structure representing the mouse wheel movement:
///   - <c>X</c>: Horizontal scroll amount.
///   - <c>Y</c>: Vertical scroll amount.
/// </returns>
/// <remarks>
///   - This function provides the scroll deltas for the mouse wheel since the last frame.
///   - Ensure the window handle is valid before calling this function.
///   - Values are typically integers, but they may depend on the input device or platform.
/// </remarks>
function AGT_Window_GetMouseWheel(const AWindow: AGT_Window): AGT_Vector; cdecl; external AGT_DLL;

/// <summary>
///   Checks if a gamepad is connected to the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window to check for gamepad connectivity.
/// </param>
/// <param name="AGamepad">
///   The gamepad index to check (e.g., <c>0</c> for the first gamepad, <c>1</c> for the second, etc.).
/// </param>
/// <returns>
///   <c>True</c> if the specified gamepad is connected; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - Use this function to determine if a specific gamepad is available for input.
///   - Ensure the gamepad index is valid and supported by the system.
/// </remarks>
function AGT_Window_GamepadPresent(const AWindow: AGT_Window; const AGamepad: Byte): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the name of a connected gamepad.
/// </summary>
/// <param name="AWindow">
///   A handle to the window associated with the gamepad.
/// </param>
/// <param name="AGamepad">
///   The gamepad index to query (e.g., <c>0</c> for the first gamepad, <c>1</c> for the second, etc.).
/// </param>
/// <returns>
///   A wide-character string containing the name of the gamepad, or <c>nil</c> if the gamepad is not connected or the operation fails.
/// </returns>
/// <remarks>
///   - This function provides the name of the gamepad as reported by the system or driver.
///   - The returned string is managed internally and should not be modified or freed by the caller.
/// </remarks>
function AGT_Window_GetGamepadName(const AWindow: AGT_Window; const AGamepad: Byte): PWideChar; cdecl; external AGT_DLL;

/// <summary>
///   Checks the state of a specific button on a connected gamepad.
/// </summary>
/// <param name="AWindow">
///   A handle to the window associated with the gamepad.
/// </param>
/// <param name="AGamepad">
///   The gamepad index to query (e.g., <c>0</c> for the first gamepad, <c>1</c> for the second, etc.).
/// </param>
/// <param name="AButton">
///   The button index to check (e.g., <c>0</c> for the A button, <c>1</c> for the B button, etc.).
/// </param>
/// <param name="AState">
///   The desired input state to check, specified as an <c>AGT_InputState</c> value:
///   - <c>AGT_isPressed</c>: The button is currently pressed.
///   - <c>AGT_isWasPressed</c>: The button was pressed in the last frame.
///   - <c>AGT_isWasReleased</c>: The button was released in the last frame.
/// </param>
/// <returns>
///   <c>True</c> if the button is in the specified state; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function allows querying specific button events for the gamepad.
///   - Ensure the gamepad and button indices are valid before calling this function.
/// </remarks>
function AGT_Window_GetGamepadButton(const AWindow: AGT_Window; const AGamepad, AButton: Byte; const AState: AGT_InputState): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the value of a specific axis on a connected gamepad.
/// </summary>
/// <param name="AWindow">
///   A handle to the window associated with the gamepad.
/// </param>
/// <param name="AGamepad">
///   The gamepad index to query (e.g., <c>0</c> for the first gamepad, <c>1</c> for the second, etc.).
/// </param>
/// <param name="AAxis">
///   The axis index to check (e.g., <c>0</c> for the left stick X-axis, <c>1</c> for the left stick Y-axis, etc.).
/// </param>
/// <returns>
///   A floating-point value representing the axis position, typically normalized between -1.0 and 1.0.
/// </returns>
/// <remarks>
///   - This function provides the current position of the specified axis.
///   - Values may vary depending on the input device and calibration.
///   - Ensure the gamepad and axis indices are valid before calling this function.
/// </remarks>
function AGT_Window_GetGamepadAxisValue(const AWindow: AGT_Window; const AGamepad, AAxis: Byte): Single; cdecl; external AGT_DLL;

/// <summary>
///   Converts a point from virtual coordinates to screen coordinates for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the conversion is to be performed.
/// </param>
/// <param name="X">
///   The X-coordinate of the point in virtual coordinates.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the point in virtual coordinates.
/// </param>
/// <returns>
///   An <c>AGT_Point</c> structure containing the equivalent screen coordinates of the point.
/// </returns>
/// <remarks>
///   - Virtual coordinates are logical coordinates used within the window's rendering context, independent of the actual screen resolution.
///   - Screen coordinates are pixel-based coordinates relative to the actual physical window.
///   - This function is useful for mapping virtual positions to physical screen positions, such as for aligning UI elements.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_VirtualToScreen(const AWindow: AGT_Window; const X, Y: Single): AGT_Point; cdecl; external AGT_DLL;

/// <summary>
///   Converts a point from screen coordinates to virtual coordinates for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the conversion is to be performed.
/// </param>
/// <param name="X">
///   The X-coordinate of the point in screen coordinates.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the point in screen coordinates.
/// </param>
/// <returns>
///   An <c>AGT_Point</c> structure containing the equivalent virtual coordinates of the point.
/// </returns>
/// <remarks>
///   - Screen coordinates are pixel-based coordinates relative to the actual physical window.
///   - Virtual coordinates are logical coordinates used within the window's rendering context, independent of the screen resolution.
///   - This function is useful for mapping mouse or touch input positions to the virtual coordinate space.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_ScreenToVirtual(const AWindow: AGT_Window; const X, Y: Single): AGT_Point; cdecl; external AGT_DLL;

/// <summary>
///   Sets the target frame rate for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the target frame rate is to be set.
/// </param>
/// <param name="ATargetFrameRate">
///   The desired frame rate in frames per second (FPS). Defaults to <c>AGT_DEFAULT_FPS</c> (60 FPS).
/// </param>
/// <remarks>
///   - This procedure sets the desired update rate for rendering and logic processing in the specified window.
///   - A higher frame rate results in smoother visuals but may increase resource usage.
///   - A lower frame rate reduces resource consumption but may impact the smoothness of animations or updates.
///   - Ensure the window handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Window_SetTargetFrameRate(const AWindow: AGT_Window; const ATargetFrameRate: UInt32 = AGT_DEFAULT_FPS); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current target frame rate for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the target frame rate is to be retrieved.
/// </param>
/// <returns>
///   The current target frame rate in frames per second (FPS).
/// </returns>
/// <remarks>
///   - Use this function to query the frame rate set for rendering and updates in the specified window.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetTargetFrameRate(const AWindow: AGT_Window): UInt32; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the target frame time for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the target frame time is to be retrieved.
/// </param>
/// <returns>
///   The target frame time in seconds (e.g., 1/60 for 60 FPS).
/// </returns>
/// <remarks>
///   - The target frame time is the inverse of the target frame rate, representing the duration each frame should ideally take.
///   - Use this function to determine the desired timing precision for updates and rendering.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetTargetTime(const AWindow: AGT_Window): Double; cdecl; external AGT_DLL;

/// <summary>
///   Resets the timing statistics for the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the timing data is to be reset.
/// </param>
/// <remarks>
///   - This procedure clears accumulated timing data, including frame time and rate statistics.
///   - Useful for restarting timing measurements or clearing outdated data.
///   - Ensure the window handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Window_ResetTiming(const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the actual frame rate of the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the actual frame rate is to be retrieved.
/// </param>
/// <returns>
///   The current frame rate in frames per second (FPS), calculated based on recent frames.
/// </returns>
/// <remarks>
///   - The actual frame rate reflects the performance of the application and may differ from the target frame rate.
///   - Useful for debugging, profiling, or dynamically adjusting application behavior.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetFrameRate(const AWindow: AGT_Window): UInt32; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the time elapsed since the last frame in the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window for which the delta time is to be retrieved.
/// </param>
/// <returns>
///   The time elapsed since the last frame, in seconds.
/// </returns>
/// <remarks>
///   - Delta time is a critical value for frame-independent updates, ensuring consistent motion and timing across varying frame rates.
///   - Use this value to scale animations, physics updates, or other time-dependent processes.
///   - Ensure the window handle is valid before calling this function.
/// </remarks>
function AGT_Window_GetDeltaTime(const AWindow: AGT_Window): Double; cdecl; external AGT_DLL;

//=== TEXTURE ===============================================================
/// <summary>
///   Represents a handle to a texture resource used for rendering.
/// </summary>
/// <remarks>
///   - The <c>AGT_Texture</c> type is an abstract pointer that encapsulates the details of a texture.
///   - Textures are typically loaded from image files or generated dynamically and used in rendering operations.
///   - Ensure proper management of texture resources to avoid memory leaks.
/// </remarks>
type
  AGT_Texture = Pointer;

/// <summary>
///   Specifies the blending mode to use when rendering a texture.
/// </summary>
/// <remarks>
///   - Blending modes determine how the texture is combined with the background or other elements during rendering.
/// </remarks>
type
  AGT_TextureBlend = (
    /// <summary>
    ///   No blending; the texture is drawn as-is, fully opaque.
    /// </summary>
    AGT_tbNone,

    /// <summary>
    ///   Alpha blending; combines the texture with the background based on the texture's alpha channel.
    /// </summary>
    AGT_tbAlpha,

    /// <summary>
    ///   Additive alpha blending; adds the texture's colors to the background, creating a glowing effect.
    /// </summary>
    AGT_tbAdditiveAlpha
  );

/// <summary>
///   Creates an empty texture resource.
/// </summary>
/// <returns>
///   A handle to the newly created <c>AGT_Texture</c>, or <c>nil</c> if the operation fails.
/// </returns>
/// <remarks>
///   - This function initializes an empty texture that can be populated or manipulated later.
///   - Ensure the returned texture is properly managed and destroyed using <c>AGT_Texture_Destroy</c>.
/// </remarks>
function AGT_Texture_Create(): AGT_Texture; cdecl; external AGT_DLL;

/// <summary>
///   Creates a texture resource from an input/output (IO) object.
/// </summary>
/// <param name="AIO">
///   A handle to the IO object from which to load the texture data.
/// </param>
/// <param name="AOwnIO">
///   Indicates whether the IO object should be automatically destroyed when the texture is destroyed (<c>True</c>) or not (<c>False</c>).
/// </param>
/// <param name="AColorKey">
///   A pointer to an <c>AGT_Color</c> structure specifying a color to be treated as transparent, or <c>nil</c> for no color keying.
/// </param>
/// <returns>
///   A handle to the created <c>AGT_Texture</c>, or <c>nil</c> if the operation fails.
/// </returns>
/// <remarks>
///   - The IO object should provide valid texture data (e.g., an image file in a supported format).
///   - Color keying allows a specific color in the texture to be treated as fully transparent.
///   - Ensure the texture is destroyed using <c>AGT_Texture_Destroy</c> to free resources.
/// </remarks>
function AGT_Texture_CreateFromIO(const AIO: AGT_IO; const AOwnIO: Boolean = True; const AColorKey: PAGT_Color = nil): AGT_Texture; cdecl; external AGT_DLL;

/// <summary>
///   Creates a texture resource from a file inside a ZIP archive.
/// </summary>
/// <param name="AZipFilename">
///   The path to the ZIP archive containing the texture file.
/// </param>
/// <param name="AFilename">
///   The name of the texture file within the ZIP archive.
/// </param>
/// <param name="APassword">
///   The password for the ZIP archive, if required. Use <c>nil</c> if no password is needed.
/// </param>
/// <param name="AColorKey">
///   A pointer to an <c>AGT_Color</c> structure specifying a color to be treated as transparent, or <c>nil</c> for no color keying.
/// </param>
/// <returns>
///   A handle to the created <c>AGT_Texture</c>, or <c>nil</c> if the operation fails.
/// </returns>
/// <remarks>
///   - This function loads a texture directly from a compressed file within a ZIP archive.
///   - Useful for managing bundled resources in a compressed format.
///   - Color keying allows a specific color in the texture to be treated as fully transparent.
///   - Ensure the texture is destroyed using <c>AGT_Texture_Destroy</c> to free resources.
/// </remarks>
function AGT_Texture_CreateFromZipFile(const AZipFilename, AFilename, APassword: PWideChar; const AColorKey: PAGT_Color = nil): AGT_Texture; cdecl; external AGT_DLL;

/// <summary>
///   Destroys a texture resource and releases its associated memory.
/// </summary>
/// <param name="ATexture">
///   A reference to the <c>AGT_Texture</c> handle to be destroyed. The handle is set to <c>nil</c> after destruction.
/// </param>
/// <remarks>
///   - Always call this procedure to properly release texture resources when they are no longer needed.
///   - Failing to destroy textures can result in memory leaks or other resource issues.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_Destroy(var ATexture: AGT_Texture); cdecl; external AGT_DLL;

/// <summary>
///   Allocates memory for a texture with the specified dimensions.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to allocate memory for.
/// </param>
/// <param name="AWidth">
///   The width of the texture in pixels.
/// </param>
/// <param name="AHeight">
///   The height of the texture in pixels.
/// </param>
/// <returns>
///   <c>True</c> if the allocation is successful; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function reserves memory for a texture, allowing it to hold image data of the specified size.
///   - Ensure the texture handle is valid before calling this function.
///   - If the texture already has allocated memory, this function reinitializes it with the new dimensions.
/// </remarks>
function AGT_Texture_Alloc(const ATexture: AGT_Texture; const AWidth, AHeight: Integer): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Fills the specified texture with a solid color.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to fill.
/// </param>
/// <param name="AColor">
///   The color to use for filling the texture, specified as an <c>AGT_Color</c> structure.
/// </param>
/// <remarks>
///   - This function overwrites the entire texture with the specified color.
///   - Useful for initializing or clearing textures to a uniform color.
///   - Ensure the texture has been allocated and is valid before calling this function.
/// </remarks>
procedure AGT_Texture_Fill(const ATexture: AGT_Texture; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Loads texture data from a raw ARGB data pointer.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture where the data will be loaded.
/// </param>
/// <param name="ARGBData">
///   A pointer to the raw ARGB data.
/// </param>
/// <param name="AWidth">
///   The width of the texture, in pixels.
/// </param>
/// <param name="AHeight">
///   The height of the texture, in pixels.
/// </param>
/// <returns>
///   <c>True</c> if the texture is successfully loaded; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The raw data must be in ARGB format and match the specified dimensions.
///   - This function replaces any existing data in the texture.
///   - Ensure the texture handle and data pointer are valid before calling this function.
/// </remarks>
function AGT_Texture_LoadFromData(const ATexture: AGT_Texture; const ARGBData: Pointer; const AWidth, AHeight: Integer): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Loads texture data from an input/output (IO) object.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture where the data will be loaded.
/// </param>
/// <param name="AIO">
///   A handle to the IO object from which the texture data will be loaded.
/// </param>
/// <param name="AOwnIO">
///   Indicates whether the IO object should be automatically destroyed when the function completes (<c>True</c>) or not (<c>False</c>).
/// </param>
/// <param name="AColorKey">
///   A pointer to an <c>AGT_Color</c> structure specifying a color to be treated as transparent, or <c>nil</c> for no color keying.
/// </param>
/// <returns>
///   <c>True</c> if the texture is successfully loaded; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The IO object should provide valid texture data (e.g., an image file in a supported format).
///   - Color keying allows a specific color in the texture to be treated as fully transparent.
/// </remarks>
function AGT_Texture_LoadFromIO(const ATexture: AGT_Texture; const AIO: AGT_IO; const AOwnIO: Boolean = True; const AColorKey: PAGT_Color = nil): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Loads texture data from a file.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture where the data will be loaded.
/// </param>
/// <param name="AFilename">
///   The file path of the texture image to load.
/// </param>
/// <param name="AColorKey">
///   A pointer to an <c>AGT_Color</c> structure specifying a color to be treated as transparent, or <c>nil</c> for no color keying.
/// </param>
/// <returns>
///   <c>True</c> if the texture is successfully loaded; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The file must contain valid texture data in a supported format.
///   - Color keying allows a specific color in the texture to be treated as fully transparent.
/// </remarks>
function AGT_Texture_LoadFromFile(const ATexture: AGT_Texture; const AFilename: PWideChar; const AColorKey: PAGT_Color = nil): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Loads texture data from a file inside a ZIP archive.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture where the data will be loaded.
/// </param>
/// <param name="AZipFilename">
///   The path to the ZIP archive containing the texture file.
/// </param>
/// <param name="AFilename">
///   The name of the texture file within the ZIP archive.
/// </param>
/// <param name="APassword">
///   The password for the ZIP archive, if required. Use <c>nil</c> if no password is needed.
/// </param>
/// <param name="AColorKey">
///   A pointer to an <c>AGT_Color</c> structure specifying a color to be treated as transparent, or <c>nil</c> for no color keying.
/// </param>
/// <returns>
///   <c>True</c> if the texture is successfully loaded; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function loads a texture directly from a compressed file within a ZIP archive.
///   - Useful for managing bundled resources in a compressed format.
///   - Color keying allows a specific color in the texture to be treated as fully transparent.
/// </remarks>
function AGT_Texture_LoadFromZipFile(const ATexture: AGT_Texture; const AZipFilename, AFilename, APassword: PWideChar; const AColorKey: PAGT_Color = nil): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks if a texture is loaded with valid data.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to check.
/// </param>
/// <returns>
///   <c>True</c> if the texture is loaded with valid data; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function verifies whether the specified texture has been successfully loaded or allocated with data.
///   - Useful for ensuring a texture is ready before attempting to use it in rendering or operations.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_IsLoaded(const ATexture: AGT_Texture): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Unloads the data from a texture, releasing its associated memory.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to unload.
/// </param>
/// <remarks>
///   - This procedure clears the data associated with a texture, effectively making it empty.
///   - The texture handle remains valid, allowing it to be reused for new data if needed.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_Unload(const ATexture: AGT_Texture); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the internal handle of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the internal handle is to be retrieved.
/// </param>
/// <returns>
///   A <c>Cardinal</c> value representing the internal texture handle, or <c>0</c> if the texture is invalid or uninitialized.
/// </returns>
/// <remarks>
///   - The internal handle is typically used for low-level rendering operations or integration with external rendering APIs.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetHandle(const ATexture: AGT_Texture): Cardinal; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the number of color channels in the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the number of channels is to be retrieved.
/// </param>
/// <returns>
///   An integer representing the number of color channels (e.g., 3 for RGB, 4 for RGBA), or <c>0</c> if the texture is invalid or uninitialized.
/// </returns>
/// <remarks>
///   - The number of channels indicates the format of the texture's color data.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetChannels(const ATexture: AGT_Texture): Integer; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the dimensions of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the dimensions are to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Size</c> structure containing the width and height of the texture in pixels, or <c>(0, 0)</c> if the texture is invalid or uninitialized.
/// </returns>
/// <remarks>
///   - The size reflects the actual dimensions of the texture's data.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetSize(const ATexture: AGT_Texture): AGT_Size; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the pivot point of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the pivot point is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Point</c> structure representing the pivot point of the texture.
/// </returns>
/// <remarks>
///   - The pivot point defines the reference point for transformations such as rotation, scaling, and positioning.
///   - The pivot point is relative to the texture's top-left corner, where <c>(0, 0)</c> represents the top-left and <c>(width, height)</c> represents the bottom-right.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetPivot(const ATexture: AGT_Texture): AGT_Point; cdecl; external AGT_DLL;

/// <summary>
///   Sets the pivot point of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the pivot point is to be set.
/// </param>
/// <param name="APoint">
///   An <c>AGT_Point</c> structure specifying the new pivot point.
/// </param>
/// <remarks>
///   - The pivot point is relative to the texture's top-left corner, where <c>(0, 0)</c> represents the top-left and <c>(width, height)</c> represents the bottom-right.
///   - This function updates the texture's internal pivot point for future transformations.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetPivot(const ATexture: AGT_Texture; const APoint: AGT_Point); cdecl; external AGT_DLL;

/// <summary>
///   Sets the pivot point of the specified texture using individual coordinates.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the pivot point is to be set.
/// </param>
/// <param name="X">
///   The X-coordinate of the new pivot point.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the new pivot point.
/// </param>
/// <remarks>
///   - The pivot point is relative to the texture's top-left corner, where <c>(0, 0)</c> represents the top-left and <c>(width, height)</c> represents the bottom-right.
///   - This function is equivalent to <c>AGT_Texture_SetPivot</c>, but allows specifying the coordinates directly.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetPivotEx(const ATexture: AGT_Texture; const X, Y: Single); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the anchor point of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the anchor point is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Point</c> structure representing the anchor point of the texture.
/// </returns>
/// <remarks>
///   - The anchor point is used as a reference for positioning the texture relative to its parent or drawing context.
///   - The anchor point is relative to the texture's top-left corner, where <c>(0, 0)</c> represents the top-left and <c>(width, height)</c> represents the bottom-right.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetAnchor(const ATexture: AGT_Texture): AGT_Point; cdecl; external AGT_DLL;

/// <summary>
///   Sets the anchor point of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the anchor point is to be set.
/// </param>
/// <param name="APoint">
///   An <c>AGT_Point</c> structure specifying the new anchor point.
/// </param>
/// <remarks>
///   - The anchor point defines how the texture is positioned relative to its parent or the drawing context.
///   - The anchor point is relative to the texture's top-left corner, where <c>(0, 0)</c> represents the top-left and <c>(width, height)</c> represents the bottom-right.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetAnchor(const ATexture: AGT_Texture; const APoint: AGT_Point); cdecl; external AGT_DLL;

/// <summary>
///   Sets the anchor point of the specified texture using individual coordinates.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the anchor point is to be set.
/// </param>
/// <param name="X">
///   The X-coordinate of the new anchor point.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the new anchor point.
/// </param>
/// <remarks>
///   - The anchor point defines how the texture is positioned relative to its parent or the drawing context.
///   - The anchor point is relative to the texture's top-left corner, where <c>(0, 0)</c> represents the top-left and <c>(width, height)</c> represents the bottom-right.
///   - This function is equivalent to <c>AGT_Texture_SetAnchor</c>, but allows specifying the coordinates directly.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetAnchorEx(const ATexture: AGT_Texture; const X, Y: Single); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current blending mode of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the blending mode is to be retrieved.
/// </param>
/// <returns>
///   The current blending mode, specified as an <c>AGT_TextureBlend</c> value:
///   - <c>AGT_tbNone</c>: No blending (fully opaque).
///   - <c>AGT_tbAlpha</c>: Alpha blending for transparency effects.
///   - <c>AGT_tbAdditiveAlpha</c>: Additive alpha blending for glowing or light effects.
/// </returns>
/// <remarks>
///   - The blending mode determines how the texture is drawn over existing content.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetBlend(const ATexture: AGT_Texture): AGT_TextureBlend; cdecl; external AGT_DLL;

/// <summary>
///   Sets the blending mode for the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the blending mode is to be set.
/// </param>
/// <param name="AValue">
///   The blending mode to set, specified as an <c>AGT_TextureBlend</c> value:
///   - <c>AGT_tbNone</c>: No blending (fully opaque).
///   - <c>AGT_tbAlpha</c>: Alpha blending for transparency effects.
///   - <c>AGT_tbAdditiveAlpha</c>: Additive alpha blending for glowing or light effects.
/// </param>
/// <remarks>
///   - Setting the blending mode changes how the texture is drawn over other content during rendering.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetBlend(const ATexture: AGT_Texture; const AValue: AGT_TextureBlend); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the position of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the position is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Point</c> structure representing the position of the texture.
/// </returns>
/// <remarks>
///   - The position represents the texture's origin in the rendering context or parent object.
///   - The position is typically specified in virtual or world coordinates, depending on the rendering system.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetPos(const ATexture: AGT_Texture): AGT_Point; cdecl; external AGT_DLL;

/// <summary>
///   Sets the position of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the position is to be set.
/// </param>
/// <param name="APos">
///   An <c>AGT_Point</c> structure specifying the new position of the texture.
/// </param>
/// <remarks>
///   - This function updates the texture's position, affecting where it is drawn in the rendering context or parent object.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetPos(const ATexture: AGT_Texture; const APos: AGT_Point); cdecl; external AGT_DLL;

/// <summary>
///   Sets the position of the specified texture using individual coordinates.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the position is to be set.
/// </param>
/// <param name="X">
///   The X-coordinate of the new position.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the new position.
/// </param>
/// <remarks>
///   - This function is equivalent to <c>AGT_Texture_SetPos</c>, but allows specifying the coordinates directly.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetPosEx(const ATexture: AGT_Texture; const X, Y: Single); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current scale factor of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the scale factor is to be retrieved.
/// </param>
/// <returns>
///   A floating-point value representing the scale factor of the texture.
/// </returns>
/// <remarks>
///   - The scale factor determines how the texture is resized when drawn.
///   - A scale of <c>1.0</c> represents the texture's original size, while values greater or less than <c>1.0</c> resize the texture proportionally.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetScale(const ATexture: AGT_Texture): Single; cdecl; external AGT_DLL;

/// <summary>
///   Sets the scale factor of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the scale factor is to be set.
/// </param>
/// <param name="AScale">
///   A floating-point value specifying the new scale factor.
/// </param>
/// <remarks>
///   - The scale factor determines how the texture is resized when drawn.
///   - A scale of <c>1.0</c> represents the texture's original size, while values greater or less than <c>1.0</c> resize the texture proportionally.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetScale(const ATexture: AGT_Texture; const AScale: Single); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current color modulation applied to the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the color modulation is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Color</c> structure representing the current color modulation.
/// </returns>
/// <remarks>
///   - The color modulation determines how the texture is tinted or blended with a specific color during rendering.
///   - The default modulation is white (<c>(1.0, 1.0, 1.0, 1.0)</c>), which applies no tinting.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetColor(const ATexture: AGT_Texture): AGT_Color; cdecl; external AGT_DLL;

/// <summary>
///   Sets the color modulation for the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the color modulation is to be set.
/// </param>
/// <param name="AColor">
///   An <c>AGT_Color</c> structure specifying the new color modulation.
/// </param>
/// <remarks>
///   - The color modulation tints the texture by multiplying its colors with the specified values.
///   - The default modulation is white (<c>(1.0, 1.0, 1.0, 1.0)</c>), which applies no tinting.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetColor(const ATexture: AGT_Texture; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Sets the color modulation for the specified texture using individual RGBA values.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the color modulation is to be set.
/// </param>
/// <param name="ARed">
///   The red component of the modulation color, ranging from 0.0 to 1.0.
/// </param>
/// <param name="AGreen">
///   The green component of the modulation color, ranging from 0.0 to 1.0.
/// </param>
/// <param name="ABlue">
///   The blue component of the modulation color, ranging from 0.0 to 1.0.
/// </param>
/// <param name="AAlpha">
///   The alpha (transparency) component of the modulation color, ranging from 0.0 to 1.0.
/// </param>
/// <remarks>
///   - This function is equivalent to <c>AGT_Texture_SetColor</c>, but allows specifying the RGBA values directly.
///   - The default modulation is white (<c>(1.0, 1.0, 1.0, 1.0)</c>), which applies no tinting.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetColorEx(const ATexture: AGT_Texture; const ARed, AGreen, ABlue, AAlpha: Single); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current rotation angle of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the rotation angle is to be retrieved.
/// </param>
/// <returns>
///   A floating-point value representing the rotation angle of the texture, in degrees.
/// </returns>
/// <remarks>
///   - The rotation angle specifies how the texture is rotated around its pivot point during rendering.
///   - Angles are measured in degrees, where 0.0 represents no rotation, positive values rotate counterclockwise, and negative values rotate clockwise.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetAngle(const ATexture: AGT_Texture): Single; cdecl; external AGT_DLL;

/// <summary>
///   Sets the rotation angle of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the rotation angle is to be set.
/// </param>
/// <param name="AAngle">
///   A floating-point value specifying the new rotation angle, in degrees.
/// </param>
/// <remarks>
///   - The rotation angle specifies how the texture is rotated around its pivot point during rendering.
///   - Angles are measured in degrees, where 0.0 represents no rotation, positive values rotate counterclockwise, and negative values rotate clockwise.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetAngle(const ATexture: AGT_Texture; const AAngle: Single); cdecl; external AGT_DLL;

/// <summary>
///   Checks whether the specified texture is horizontally flipped.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to check for horizontal flipping.
/// </param>
/// <returns>
///   <c>True</c> if the texture is horizontally flipped; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - Horizontal flipping mirrors the texture along the vertical axis.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetHFlip(const ATexture: AGT_Texture): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Sets the horizontal flipping state of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to modify.
/// </param>
/// <param name="AFlip">
///   <c>True</c> to enable horizontal flipping; <c>False</c> to disable it.
/// </param>
/// <remarks>
///   - Horizontal flipping mirrors the texture along the vertical axis.
///   - Use this function to dynamically adjust the texture's appearance during rendering.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetHFlip(const ATexture: AGT_Texture; const AFlip: Boolean); cdecl; external AGT_DLL;

/// <summary>
///   Checks whether the specified texture is vertically flipped.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to check for vertical flipping.
/// </param>
/// <returns>
///   <c>True</c> if the texture is vertically flipped; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - Vertical flipping mirrors the texture along the horizontal axis.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetVFlip(const ATexture: AGT_Texture): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Sets the vertical flipping state of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to modify.
/// </param>
/// <param name="AFlip">
///   <c>True</c> to enable vertical flipping; <c>False</c> to disable it.
/// </param>
/// <remarks>
///   - Vertical flipping mirrors the texture along the horizontal axis.
///   - Use this function to dynamically adjust the texture's appearance during rendering.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetVFlip(const ATexture: AGT_Texture; const AFlip: Boolean); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the currently defined rendering region of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the rendering region is to be retrieved.
/// </param>
/// <returns>
///   An <c>AGT_Rect</c> structure representing the rendering region of the texture.
/// </returns>
/// <remarks>
///   - The rendering region defines a subsection of the texture to be used during rendering.
///   - By default, the region encompasses the entire texture.
///   - Ensure the texture handle is valid before calling this function.
/// </remarks>
function AGT_Texture_GetRegion(const ATexture: AGT_Texture): AGT_Rect; cdecl; external AGT_DLL;

/// <summary>
///   Sets the rendering region of the specified texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the rendering region is to be set.
/// </param>
/// <param name="ARegion">
///   An <c>AGT_Rect</c> structure specifying the new rendering region.
/// </param>
/// <remarks>
///   - The rendering region defines a subsection of the texture to be used during rendering.
///   - This function allows for partial rendering of a texture, useful for sprite sheets or texture atlases.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetRegion(const ATexture: AGT_Texture; const ARegion: AGT_Rect); cdecl; external AGT_DLL;

/// <summary>
///   Sets the rendering region of the specified texture using individual coordinates and dimensions.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the rendering region is to be set.
/// </param>
/// <param name="X">
///   The X-coordinate of the region's top-left corner.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the region's top-left corner.
/// </param>
/// <param name="AWidth">
///   The width of the region.
/// </param>
/// <param name="AHeight">
///   The height of the region.
/// </param>
/// <remarks>
///   - This function is equivalent to <c>AGT_Texture_SetRegion</c>, but allows specifying the region's coordinates and dimensions directly.
///   - Useful for working with sprite sheets or texture atlases where precise regions are required.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_SetRegionEx(const ATexture: AGT_Texture; const X, Y, AWidth, AHeight: Single); cdecl; external AGT_DLL;

/// <summary>
///   Resets the rendering region of the specified texture to encompass the entire texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture for which the rendering region is to be reset.
/// </param>
/// <remarks>
///   - This function restores the rendering region to its default state, covering the entire texture.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_ResetRegion(const ATexture: AGT_Texture); cdecl; external AGT_DLL;

/// <summary>
///   Draws the specified texture onto the specified window.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to be drawn.
/// </param>
/// <param name="AWindow">
///   A handle to the window where the texture will be rendered.
/// </param>
/// <remarks>
///   - The texture is drawn at its current position, scale, rotation, and other transformations.
///   - Ensure both the texture and window handles are valid before calling this procedure.
///   - Use this function for basic texture rendering operations.
/// </remarks>
procedure AGT_Texture_Draw(const ATexture: AGT_Texture; const AWindow: AGT_Window); cdecl; external AGT_DLL;

/// <summary>
///   Draws the specified texture as a tiled pattern onto the specified window.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to be drawn.
/// </param>
/// <param name="AWindow">
///   A handle to the window where the texture will be rendered.
/// </param>
/// <param name="ADeltaX">
///   The horizontal offset between repeated tiles.
/// </param>
/// <param name="ADeltaY">
///   The vertical offset between repeated tiles.
/// </param>
/// <remarks>
///   - The texture is repeated to fill the rendering area, with each tile offset by <c>ADeltaX</c> and <c>ADeltaY</c>.
///   - Ensure both the texture and window handles are valid before calling this procedure.
///   - Use this function for creating seamless patterns or backgrounds.
/// </remarks>
procedure AGT_Texture_DrawTiled(const ATexture: AGT_Texture; const AWindow: AGT_Window; const ADeltaX, ADeltaY: Single); cdecl; external AGT_DLL;

/// <summary>
///   Saves the specified texture to a file.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to be saved.
/// </param>
/// <param name="AFilename">
///   The file path where the texture will be saved.
/// </param>
/// <returns>
///   <c>True</c> if the texture is successfully saved; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The texture is saved in a format determined by the file extension (e.g., PNG, BMP, JPG).
///   - Ensure the texture handle is valid and the file path is writable before calling this function.
///   - Use this function to export textures for debugging, storage, or further editing.
/// </remarks>
function AGT_Texture_Save(const ATexture: AGT_Texture; const AFilename: PWideChar): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Locks the specified texture for direct access or modification.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to be locked.
/// </param>
/// <returns>
///   <c>True</c> if the texture is successfully locked; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - Locking a texture allows direct access to its data for reading or writing.
///   - While a texture is locked, it cannot be used for rendering or other operations.
///   - Ensure the texture handle is valid before calling this function.
///   - Always unlock the texture after modifications using <c>AGT_Texture_Unlock</c>.
/// </remarks>
function AGT_Texture_Lock(const ATexture: AGT_Texture): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Unlocks the specified texture after it has been locked for modification.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture to be unlocked.
/// </param>
/// <remarks>
///   - Unlocking a texture re-enables it for rendering or other operations after it was locked.
///   - Ensure that any modifications to the texture data are completed before calling this procedure.
///   - Ensure the texture handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Texture_Unlock(const ATexture: AGT_Texture); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the color of a specific pixel in the texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture from which the pixel color is to be retrieved.
/// </param>
/// <param name="X">
///   The X-coordinate of the pixel, in texture space.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the pixel, in texture space.
/// </param>
/// <returns>
///   An <c>AGT_Color</c> structure representing the color of the specified pixel.
/// </returns>
/// <remarks>
///   - The X and Y coordinates are relative to the texture's dimensions.
///   - Ensure the texture handle is valid and the coordinates are within bounds before calling this function.
///   - This function requires the texture to be locked before accessing the pixel data.
/// </remarks>
function AGT_Texture_GetPixel(const ATexture: AGT_Texture; const X, Y: Single): AGT_Color; cdecl; external AGT_DLL;

/// <summary>
///   Sets the color of a specific pixel in the texture.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture where the pixel color is to be set.
/// </param>
/// <param name="X">
///   The X-coordinate of the pixel, in texture space.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the pixel, in texture space.
/// </param>
/// <param name="AColor">
///   An <c>AGT_Color</c> structure specifying the new color for the pixel.
/// </param>
/// <remarks>
///   - The X and Y coordinates are relative to the texture's dimensions.
///   - Ensure the texture handle is valid and the coordinates are within bounds before calling this procedure.
///   - This function requires the texture to be locked before modifying the pixel data.
/// </remarks>
procedure AGT_Texture_SetPixel(const ATexture: AGT_Texture; const X, Y: Single; const AColor: AGT_Color); cdecl; external AGT_DLL;

/// <summary>
///   Sets the color of a specific pixel in the texture using individual RGBA components.
/// </summary>
/// <param name="ATexture">
///   A handle to the texture where the pixel color is to be set.
/// </param>
/// <param name="X">
///   The X-coordinate of the pixel, in texture space.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the pixel, in texture space.
/// </param>
/// <param name="ARed">
///   The red component of the new color (0 to 255).
/// </param>
/// <param name="AGreen">
///   The green component of the new color (0 to 255).
/// </param>
/// <param name="ABlue">
///   The blue component of the new color (0 to 255).
/// </param>
/// <param name="AAlpha">
///   The alpha (transparency) component of the new color (0 to 255).
/// </param>
/// <remarks>
///   - The X and Y coordinates are relative to the texture's dimensions.
///   - Ensure the texture handle is valid and the coordinates are within bounds before calling this procedure.
///   - This function requires the texture to be locked before modifying the pixel data.
/// </remarks>
procedure AGT_Texture_SetPixelEx(const ATexture: AGT_Texture; const X, Y: Single; const ARed, AGreen, ABlue, AAlpha: Byte); cdecl; external AGT_DLL;

/// <summary>
///   Checks for a collision between two textures using Axis-Aligned Bounding Box (AABB) collision detection.
/// </summary>
/// <param name="ATexture1">
///   A handle to the first texture.
/// </param>
/// <param name="ATexture2">
///   A handle to the second texture.
/// </param>
/// <returns>
///   <c>True</c> if the bounding boxes of the two textures overlap; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - AABB collision detection uses simple rectangular bounds that do not account for rotation.
///   - This method is fast and efficient but may not provide precise results for rotated or irregularly shaped textures.
///   - Ensure both texture handles are valid before calling this function.
/// </remarks>
function AGT_Texture_CollideAABB(const ATexture1: AGT_Texture; const ATexture2: AGT_Texture): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks for a collision between two textures using Oriented Bounding Box (OBB) collision detection.
/// </summary>
/// <param name="ATexture1">
///   A handle to the first texture.
/// </param>
/// <param name="ATexture2">
///   A handle to the second texture.
/// </param>
/// <returns>
///   <c>True</c> if the oriented bounding boxes of the two textures overlap; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - OBB collision detection accounts for rotation and orientation, making it more accurate for rotated or irregularly aligned textures.
///   - This method is computationally more expensive than AABB.
///   - Ensure both texture handles are valid before calling this function.
/// </remarks>
function AGT_Texture_CollideOBB(const ATexture1: AGT_Texture; const ATexture2: AGT_Texture): Boolean; cdecl; external AGT_DLL;

//=== FONT ==================================================================
/// <summary>
///   Represents a handle to a font resource used for rendering text.
/// </summary>
/// <remarks>
///   - The <c>AGT_Font</c> type is an abstract pointer that encapsulates font-related data.
///   - Fonts are used in conjunction with rendering functions to display text in a window.
///   - Ensure proper management of font resources to avoid memory leaks.
/// </remarks>
type
  AGT_Font = Pointer;

/// <summary>
///   Creates an empty font resource.
/// </summary>
/// <returns>
///   A handle to the newly created <c>AGT_Font</c>, or <c>nil</c> if the operation fails.
/// </returns>
/// <remarks>
///   - This function initializes an empty font resource that can be configured or populated later.
///   - Ensure the returned font handle is properly managed and destroyed when no longer needed.
/// </remarks>
function AGT_Font_Create(): AGT_Font; cdecl; external AGT_DLL;

/// <summary>
///   Creates a default font resource with a specified size.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the font will be used.
/// </param>
/// <param name="ASize">
///   The size of the font in points.
/// </param>
/// <param name="AGlyphs">
///   A null-terminated string specifying the glyphs to include in the font, or <c>nil</c> to include default glyphs.
/// </param>
/// <returns>
///   A handle to the created <c>AGT_Font</c>, or <c>nil</c> if the operation fails.
/// </returns>
/// <remarks>
///   - This function generates a basic font suitable for most text rendering needs.
///   - Specifying glyphs allows optimization by only including necessary characters, reducing memory usage.
/// </remarks>
function AGT_Font_CreateDefault(const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: PWideChar = nil): AGT_Font; cdecl; external AGT_DLL;

/// <summary>
///   Creates a font resource from a font file inside a ZIP archive.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the font will be used.
/// </param>
/// <param name="AZipFilename">
///   The path to the ZIP archive containing the font file.
/// </param>
/// <param name="AFilename">
///   The name of the font file within the ZIP archive.
/// </param>
/// <param name="APassword">
///   The password for the ZIP archive, if required. Use <c>nil</c> if no password is needed.
/// </param>
/// <param name="ASize">
///   The size of the font in points.
/// </param>
/// <param name="AGlyphs">
///   A null-terminated string specifying the glyphs to include in the font, or <c>nil</c> to include default glyphs.
/// </param>
/// <returns>
///   A handle to the created <c>AGT_Font</c>, or <c>nil</c> if the operation fails.
/// </returns>
/// <remarks>
///   - This function loads a font directly from a compressed file within a ZIP archive.
///   - Specifying glyphs allows optimization by only including necessary characters, reducing memory usage.
///   - Useful for managing bundled resources in a compressed format.
/// </remarks>
function AGT_Font_CreateFromZipFile(const AWindow: AGT_Window; const AZipFilename, AFilename, APassword: PWideChar; const ASize: Cardinal; const AGlyphs: PWideChar = nil): AGT_Font; cdecl; external AGT_DLL;

/// <summary>
///   Destroys a font resource and releases its associated memory.
/// </summary>
/// <param name="AFont">
///   A variable containing the handle to the font to be destroyed. This variable will be set to <c>nil</c> after destruction.
/// </param>
/// <remarks>
///   - This procedure completely removes the font resource from memory.
///   - Once destroyed, the font handle is no longer valid and should not be used.
///   - Ensure that any references to the font are cleared to avoid undefined behavior.
/// </remarks>
procedure AGT_Font_Destroy(var AFont: AGT_Font); cdecl; external AGT_DLL;

/// <summary>
///   Unloads the data associated with a font resource while keeping its handle valid.
/// </summary>
/// <param name="AFont">
///   A handle to the font to unload.
/// </param>
/// <remarks>
///   - This procedure clears the data associated with the font but retains the font handle.
///   - The font handle can be reused for loading new font data.
///   - Ensure the font handle is valid before calling this procedure.
/// </remarks>
procedure AGT_Font_Unload(const AFont: AGT_Font); cdecl; external AGT_DLL;

/// <summary>
///   Loads a default font into an existing font handle.
/// </summary>
/// <param name="AFont">
///   A handle to the font where the default font will be loaded.
/// </param>
/// <param name="AWindow">
///   A handle to the window where the font will be used.
/// </param>
/// <param name="ASize">
///   The size of the font in points.
/// </param>
/// <param name="AGlyphs">
///   A null-terminated string specifying the glyphs to include in the font, or <c>nil</c> to include default glyphs.
/// </param>
/// <returns>
///   <c>True</c> if the font is successfully loaded; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function loads a basic font into an existing font handle.
///   - Specifying glyphs optimizes memory usage by including only the necessary characters.
///   - Ensure the font handle is valid before calling this function.
/// </remarks>
function AGT_Font_LoadDefault(const AFont: AGT_Font; const AWindow: AGT_Window; const ASize: Cardinal; const AGlyphs: PWideChar = nil): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Loads a font from an input/output (IO) object into an existing font handle.
/// </summary>
/// <param name="AFont">
///   A handle to the font where the data will be loaded.
/// </param>
/// <param name="AWindow">
///   A handle to the window where the font will be used.
/// </param>
/// <param name="AIO">
///   A handle to the IO object containing the font data.
/// </param>
/// <param name="ASize">
///   The size of the font in points.
/// </param>
/// <param name="AGlyphs">
///   A null-terminated string specifying the glyphs to include in the font, or <c>nil</c> to include default glyphs.
/// </param>
/// <param name="AOwnIO">
///   Indicates whether the IO object should be automatically destroyed after the function completes (<c>True</c>) or not (<c>False</c>).
/// </param>
/// <returns>
///   <c>True</c> if the font is successfully loaded; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The IO object must provide valid font data (e.g., a supported font file format).
///   - Ensure the font handle and IO object are valid before calling this function.
/// </remarks>
function AGT_Font_LoadFromIO(const AFont: AGT_Font; const AWindow: AGT_Window; const AIO: AGT_IO; const ASize: Cardinal; const AGlyphs: PWideChar = nil; const AOwnIO: Boolean = True): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Loads a font from a file into an existing font handle.
/// </summary>
/// <param name="AFont">
///   A handle to the font where the data will be loaded.
/// </param>
/// <param name="AWindow">
///   A handle to the window where the font will be used.
/// </param>
/// <param name="AFilename">
///   The file path of the font file to load.
/// </param>
/// <param name="ASize">
///   The size of the font in points.
/// </param>
/// <param name="AGlyphs">
///   A null-terminated string specifying the glyphs to include in the font, or <c>nil</c> to include default glyphs.
/// </param>
/// <returns>
///   <c>True</c> if the font is successfully loaded; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The file must contain valid font data in a supported format.
///   - Ensure the font handle and file path are valid before calling this function.
/// </remarks>
function AGT_Font_LoadFromFile(const AFont: AGT_Font; const AWindow: AGT_Window; const AFilename: PWideChar; const ASize: Cardinal; const AGlyphs: PWideChar = nil): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Loads a font from a file inside a ZIP archive into an existing font handle.
/// </summary>
/// <param name="AFont">
///   A handle to the font where the data will be loaded.
/// </param>
/// <param name="AWindow">
///   A handle to the window where the font will be used.
/// </param>
/// <param name="AZipFilename">
///   The path to the ZIP archive containing the font file.
/// </param>
/// <param name="AFilename">
///   The name of the font file within the ZIP archive.
/// </param>
/// <param name="APassword">
///   The password for the ZIP archive, if required. Use <c>nil</c> if no password is needed.
/// </param>
/// <param name="ASize">
///   The size of the font in points.
/// </param>
/// <param name="AGlyphs">
///   A null-terminated string specifying the glyphs to include in the font, or <c>nil</c> to include default glyphs.
/// </param>
/// <returns>
///   <c>True</c> if the font is successfully loaded; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function loads font data from a compressed ZIP archive.
///   - Specifying glyphs optimizes memory usage by including only the necessary characters.
///   - Ensure the font handle, ZIP file path, and font file name are valid before calling this function.
/// </remarks>
function AGT_Font_LoadFromZipFile(const AFont: AGT_Font; const AWindow: AGT_Window; const AZipFilename, AFilename, APassword: PWideChar; const ASize: Cardinal; const AGlyphs: PWideChar = nil): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Draws a single line of text using the specified font.
/// </summary>
/// <param name="AFont">
///   A handle to the font to use for rendering the text.
/// </param>
/// <param name="AWindow">
///   A handle to the window where the text will be drawn.
/// </param>
/// <param name="X">
///   The X-coordinate of the starting position for the text.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the starting position for the text.
/// </param>
/// <param name="AColor">
///   The color to use for rendering the text.
/// </param>
/// <param name="AHAlign">
///   The horizontal alignment of the text. Possible values are:
///   - <c>AGT_haLeft</c>: Aligns text to the left of the X position.
///   - <c>AGT_haCenter</c>: Centers text on the X position.
///   - <c>AGT_haRight</c>: Aligns text to the right of the X position.
/// </param>
/// <param name="AText">
///   The null-terminated string containing the text to render.
/// </param>
/// <remarks>
///   - Ensure the font and window handles are valid before calling this procedure.
///   - The text will be rendered at the specified position with the chosen alignment and color.
/// </remarks>
procedure AGT_Font_DrawText(const AFont: AGT_Font; const AWindow: AGT_Window; const X, Y: Single; const AColor: AGT_Color; AHAlign: AGT_HAlign; const AText: PWideChar); cdecl; external AGT_DLL;

/// <summary>
///   Draws a single line of text with variable Y position using the specified font.
/// </summary>
/// <param name="AFont">
///   A handle to the font to use for rendering the text.
/// </param>
/// <param name="AWindow">
///   A handle to the window where the text will be drawn.
/// </param>
/// <param name="X">
///   The X-coordinate of the starting position for the text.
/// </param>
/// <param name="Y">
///   A variable containing the Y-coordinate for the starting position. This value will be updated after rendering.
/// </param>
/// <param name="aLineSpace">
///   The spacing between consecutive lines of text, in pixels.
/// </param>
/// <param name="aColor">
///   The color to use for rendering the text.
/// </param>
/// <param name="AHAlign">
///   The horizontal alignment of the text. Possible values are:
///   - <c>AGT_haLeft</c>: Aligns text to the left of the X position.
///   - <c>AGT_haCenter</c>: Centers text on the X position.
///   - <c>AGT_haRight</c>: Aligns text to the right of the X position.
/// </param>
/// <param name="AText">
///   The null-terminated string containing the text to render. Newline characters (<c>\n</c>) are used to separate lines.
/// </param>
/// <remarks>
///   - Ensure the font and window handles are valid before calling this procedure.
///   - This procedure is ideal for rendering multi-line text with consistent spacing between lines.
///   - The Y variable is incremented for each rendered line based on the font size and line spacing.
/// </remarks>
procedure AGT_Font_DrawTextVarY(const AFont: AGT_Font; const AWindow: AGT_Window; const X: Single; var Y: Single; const aLineSpace: Single; const aColor: AGT_Color; AHAlign: AGT_HAlign; const AText: PWideChar); cdecl; external AGT_DLL;

/// <summary>
///   Calculates the length (width) of a given text string when rendered using the specified font.
/// </summary>
/// <param name="AFont">
///   A handle to the font to use for measuring the text.
/// </param>
/// <param name="AText">
///   A null-terminated string containing the text to measure.
/// </param>
/// <returns>
///   A floating-point value representing the width of the text in pixels.
/// </returns>
/// <remarks>
///   - The width is calculated based on the current font settings, including size and glyphs.
///   - Ensure the font handle is valid before calling this function.
///   - Useful for aligning or positioning text dynamically in the UI or rendering context.
/// </remarks>
function AGT_Font_TextLength(const AFont: AGT_Font; const AText: PWideChar): Single; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the height of the text when rendered using the specified font.
/// </summary>
/// <param name="AFont">
///   A handle to the font to use for measuring the text height.
/// </param>
/// <returns>
///   A floating-point value representing the height of a single line of text in pixels.
/// </returns>
/// <remarks>
///   - The height is determined by the font size and settings.
///   - Ensure the font handle is valid before calling this function.
///   - Useful for calculating spacing in multi-line text rendering or aligning text vertically.
/// </remarks>
function AGT_Font_TextHeight(const AFont: AGT_Font): Single; cdecl; external AGT_DLL;

/// <summary>
///   Saves the texture associated with the specified font to a file.
/// </summary>
/// <param name="AFont">
///   A handle to the font whose texture is to be saved.
/// </param>
/// <param name="AFilename">
///   The file path where the font's texture will be saved.
/// </param>
/// <returns>
///   <c>True</c> if the font texture is successfully saved; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The font texture contains the rendered glyphs used for text rendering.
///   - The texture is saved in a format determined by the file extension of <c>AFilename</c> (e.g., PNG, BMP, JPG).
///   - Ensure the font handle is valid and the file path is writable before calling this function.
///   - Useful for debugging, visualization, or exporting font textures for use in other applications or systems.
/// </remarks>
function AGT_Font_SaveTexture(const AFont: AGT_Font; const AFilename: PWideChar): Boolean; cdecl; external AGT_DLL;

//=== VIDEO =================================================================
/// <summary>
///   Represents the playback status of a video.
/// </summary>
/// <remarks>
///   - The video status is used to monitor and control video playback states.
/// </remarks>
type
  AGT_VideoStatus = (
    AGT_vsStopped,  // Indicates that the video is stopped.
    AGT_vsPlaying   // Indicates that the video is currently playing.
  );

/// <summary>
///   Defines a callback procedure for handling changes in video playback status.
/// </summary>
/// <param name="AStatus">
///   The new status of the video playback, represented as an <c>AGT_VideoStatus</c>.
/// </param>
/// <param name="AFilename">
///   The file path of the video whose status has changed.
/// </param>
/// <param name="AUserData">
///   A pointer to user-defined data, typically provided when setting up the callback.
/// </param>
/// <remarks>
///   - This callback is triggered when the video status changes (e.g., starts playing or stops).
///   - Use this to implement custom behavior or notifications in response to video playback events.
/// </remarks>
type
  AGT_VideoStatusCallback = procedure(const AStatus: AGT_VideoStatus; const AFilename: PWideChar; const AUserData: Pointer); cdecl;

/// <summary>
///   Retrieves the current callback handler for video playback status changes.
/// </summary>
/// <returns>
///   A reference to the currently assigned <c>AGT_VideoStatusCallback</c>, or <c>nil</c> if no callback is set.
/// </returns>
/// <remarks>
///   - This function allows you to query the currently assigned callback for video status changes.
///   - If no callback has been assigned, it returns <c>nil</c>.
/// </remarks>
function AGT_Video_GetStatusCallback(): AGT_VideoStatusCallback; cdecl; external AGT_DLL;

/// <summary>
///   Sets a callback handler to handle video playback status changes.
/// </summary>
/// <param name="AHandler">
///   A reference to the callback function to be invoked on status changes, or <c>nil</c> to remove the existing callback.
/// </param>
/// <param name="AUserData">
///   A pointer to user-defined data to be passed to the callback when it is triggered.
/// </param>
/// <remarks>
///   - The provided callback function will be triggered whenever the video playback status changes (e.g., starts playing or stops).
///   - Setting <c>AHandler</c> to <c>nil</c> disables the status callback.
///   - Use this function to implement custom behavior or notifications in response to video events.
/// </remarks>
procedure AGT_Video_SetStatusCallback(const AHandler: AGT_VideoStatusCallback; const AUserData: Pointer); cdecl; external AGT_DLL;

/// <summary>
///   Plays a MPEG-1 video from an input/output (IO) source.
/// </summary>
/// <param name="AIO">
///   A handle to the input/output object containing the video data.
/// </param>
/// <param name="AFilename">
///   A null-terminated string representing the name of the video file (for reference or display purposes).
/// </param>
/// <param name="AVolume">
///   The playback volume, ranging from <c>0.0</c> (mute) to <c>1.0</c> (maximum volume).
/// </param>
/// <param name="ALoop">
///   A boolean indicating whether the video should loop after reaching the end.
/// </param>
/// <returns>
///   <c>True</c> if the video starts playing successfully; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The video data must be in a supported format and accessible via the provided IO object.
///   - Ensure the IO object is valid and contains readable video data.
///   - Playback will start immediately upon successful execution of this function.
/// </remarks>
function AGT_Video_Play(const AIO: AGT_IO; const AFilename: PWideChar; const AVolume: Single; const ALoop: Boolean): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Plays a MPEG-1 video from a file stored within a ZIP archive.
/// </summary>
/// <param name="AZipFilename">
///   A null-terminated string representing the path to the ZIP archive containing the video file.
/// </param>
/// <param name="AFilename">
///   A null-terminated string representing the name of the video file inside the ZIP archive.
/// </param>
/// <param name="APassword">
///   A null-terminated string representing the password for the ZIP archive, or <c>nil</c> if no password is required.
/// </param>
/// <param name="AVolume">
///   The playback volume, ranging from <c>0.0</c> (mute) to <c>1.0</c> (maximum volume).
/// </param>
/// <param name="ALoop">
///   A boolean indicating whether the video should loop after reaching the end.
/// </param>
/// <returns>
///   <c>True</c> if the video starts playing successfully; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - The ZIP archive must be accessible, and the video file inside it must be in a supported format.
///   - Playback will start immediately upon successful execution of this function.
///   - Useful for playing bundled or compressed video resources.
/// </remarks>
function AGT_Video_PlayFromZipFile(const AZipFilename, AFilename, APassword: PWideChar; const AVolume: Single; const ALoop: Boolean): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Stops the currently playing video and releases allocated resources.
/// </summary>
/// <remarks>
///   - This procedure halts video playback immediately and resets its state.
///   - If no video is currently playing, the procedure has no effect.
///   - Use this to stop video playback manually before starting another video or exiting the application.
/// </remarks>
procedure AGT_Video_Stop(); cdecl; external AGT_DLL;

/// <summary>
///   Updates the video playback and renders the current frame onto the specified window.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the video frame will be rendered.
/// </param>
/// <returns>
///   <c>True</c> if the video playback continues successfully; <c>False</c> if the video has finished or playback fails.
/// </returns>
/// <remarks>
///   - This function should be called regularly (e.g., in the main application loop) to update and render video playback.
///   - Ensure the window handle is valid before calling this function.
///   - If <c>False</c> is returned, the video has either finished playing or encountered an error.
/// </remarks>
function AGT_Video_Update(const AWindow: AGT_Window): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Draws the current video frame onto the specified window at a given position and scale.
/// </summary>
/// <param name="AWindow">
///   A handle to the window where the video frame will be rendered.
/// </param>
/// <param name="X">
///   The X-coordinate of the top-left corner where the video will be drawn.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the top-left corner where the video will be drawn.
/// </param>
/// <param name="AScale">
///   The scaling factor for rendering the video. A value of <c>1.0</c> renders the video at its original size, while other values scale it proportionally.
/// </param>
/// <remarks>
///   - The video frame is drawn at the specified position with the specified scale.
///   - Ensure the video is currently playing and the window handle is valid before calling this procedure.
///   - Use this for precise control over the placement and scaling of the video on the window.
/// </remarks>
procedure AGT_Video_Draw(const AWindow: AGT_Window; const X, Y, AScale: Single); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current playback status of the video.
/// </summary>
/// <returns>
///   The current video playback status, represented as an <c>AGT_VideoStatus</c>:
///   - <c>AGT_vsStopped</c>: The video is stopped and not playing.
///   - <c>AGT_vsPlaying</c>: The video is currently playing.
/// </returns>
/// <remarks>
///   - This function provides the current state of video playback, which can be used to determine whether a video is actively playing or has stopped.
///   - Useful for managing video playback logic and ensuring proper sequencing of operations.
/// </remarks>
function AGT_Video_Status(): AGT_VideoStatus; cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current volume level for video playback.
/// </summary>
/// <returns>
///   A floating-point value representing the current playback volume, where:
///   - <c>0.0</c>: Mute
///   - <c>1.0</c>: Maximum volume
/// </returns>
/// <remarks>
///   - Use this function to get the current volume setting for the video.
///   - The returned value is in the range [0.0, 1.0].
///   - Useful for displaying or adjusting volume controls dynamically.
/// </remarks>
function AGT_Video_Volume(): Single; cdecl; external AGT_DLL;

/// <summary>
///   Sets the volume level for video playback.
/// </summary>
/// <param name="AVolume">
///   A floating-point value representing the desired playback volume, where:
///   - <c>0.0</c>: Mute
///   - <c>1.0</c>: Maximum volume
/// </param>
/// <remarks>
///   - The volume level is clamped to the range [0.0, 1.0].
///   - Use this procedure to adjust the playback volume dynamically during playback.
///   - Ensure a video is playing or will play for this setting to take effect.
/// </remarks>
procedure AGT_Video_SetVolume(const AVolume: Single); cdecl; external AGT_DLL;

/// <summary>
///   Checks whether the current video playback is set to loop.
/// </summary>
/// <returns>
///   <c>True</c> if the video playback is set to loop; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - Use this function to determine if the current video will restart automatically after reaching the end.
///   - Useful for managing playback logic in scenarios where looping may or may not be desired.
/// </remarks>
function AGT_Video_IsLooping(): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Sets whether the current video playback should loop.
/// </summary>
/// <param name="ALoop">
///   A boolean value specifying whether the video should loop:
///   - <c>True</c>: Enable looping (video will restart automatically after finishing).
///   - <c>False</c>: Disable looping (video will stop after finishing).
/// </param>
/// <remarks>
///   - This procedure allows dynamic control over video looping behavior.
///   - Ensure a video is currently playing or will play for this setting to take effect.
/// </remarks>
procedure AGT_Video_SetLooping(const ALoop: Boolean); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the texture associated with the current video frame.
/// </summary>
/// <returns>
///   A handle to the <c>AGT_Texture</c> representing the current video frame, or <c>nil</c> if no video is playing.
/// </returns>
/// <remarks>
///   - This function provides direct access to the texture of the current video frame, which can be used for custom rendering or additional processing.
///   - Ensure that a video is currently playing before calling this function to retrieve a valid texture handle.
///   - The returned texture is dynamically updated with each video frame.
/// </remarks>
function AGT_Video_GetTexture(): AGT_Texture; cdecl; external AGT_DLL;

//=== AUDIO =================================================================
/// <summary>
///   Indicates a general error related to audio operations.
/// </summary>
/// <remarks>
///   - This constant is used to represent an error condition in audio-related functions.
///   - Functions returning this value indicate a failure or invalid operation.
/// </remarks>
const
  AGT_AUDIO_ERROR = -1;

/// <summary>
///   Specifies the maximum number of music tracks that can be loaded simultaneously.
/// </summary>
/// <remarks>
///   - This limit defines the maximum capacity for music resources in the audio system.
///   - Attempting to load more than this number of tracks will result in errors.
/// </remarks>
const
  AGT_AUDIO_MUSIC_COUNT = 256;

/// <summary>
///   Specifies the maximum number of sound effects that can be loaded simultaneously.
/// </summary>
/// <remarks>
///   - This limit defines the maximum capacity for sound effects in the audio system.
///   - Attempting to load more than this number of effects will result in errors.
/// </remarks>
const
  AGT_AUDIO_SOUND_COUNT = 256;

/// <summary>
///   Specifies the total number of audio channels available for playback.
/// </summary>
/// <remarks>
///   - This value defines the maximum number of audio channels that can be used concurrently.
///   - Channels are used for playing sounds or music simultaneously.
/// </remarks>
const
  AGT_AUDIO_CHANNEL_COUNT = 16;

/// <summary>
///   Indicates that a sound should be played on a dynamically assigned audio channel.
/// </summary>
/// <remarks>
///   - When this value is used, the audio system automatically assigns an available channel for playback.
///   - Useful for simplifying playback without managing channel allocation manually.
/// </remarks>
const
  AGT_AUDIO_CHANNEL_DYNAMIC = -2;

/// <summary>
///   Updates the audio system, processing ongoing audio playback and managing resources.
/// </summary>
/// <remarks>
///   - This procedure is essential for maintaining audio playback, handling dynamic updates, and ensuring smooth operation.
///   - Call this procedure regularly (e.g., within the main application loop) to process audio events and maintain playback states.
///   - Failure to call this procedure in a timely manner may result in audio playback interruptions or inconsistent behavior.
/// </remarks>
procedure AGT_Audio_Update(); cdecl; external AGT_DLL;

/// <summary>
///   Opens the audio system for playback.
/// </summary>
/// <returns>
///   <c>True</c> if the audio system was successfully opened and is ready for playback; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function initializes the audio system, preparing it to play sounds, music, and other audio resources.
///   - Ensure that the audio system is opened before attempting to play any sounds or music.
///   - Call this function early in the application lifecycle, typically during initialization.
/// </remarks>
function AGT_Audio_Open(): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks if the audio system is currently open and ready for playback.
/// </summary>
/// <returns>
///   <c>True</c> if the audio system is open; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - Use this function to verify whether the audio system has been successfully initialized.
///   - If the audio system is not open, you should call <c>AGT_Audio_Open</c> to initialize it.
/// </remarks>
function AGT_Audio_IsOpen(): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Closes the audio system and releases its resources.
/// </summary>
/// <remarks>
///   - This procedure stops all audio playback, releases resources associated with the audio system, and shuts down the audio engine.
///   - It is essential to call this function when the application is closing or when audio playback is no longer needed.
///   - Always call <c>AGT_Audio_Close</c> before exiting the application to properly release the audio system resources.
/// </remarks>
procedure AGT_Audio_Close(); cdecl; external AGT_DLL;

/// <summary>
///   Checks if the audio system is currently paused.
/// </summary>
/// <returns>
///   <c>True</c> if the audio system is paused; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function allows you to check the current state of the audio system to determine if playback is paused.
///   - Useful for implementing controls or logic related to audio playback (e.g., pause/resume buttons).
/// </remarks>
function AGT_Audio_IsPaused(): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Pauses or resumes audio playback.
/// </summary>
/// <param name="APause">
///   A boolean value indicating whether to pause (<c>True</c>) or resume (<c>False</c>) audio playback.
/// </param>
/// <remarks>
///   - When <c>APause</c> is <c>True</c>, the audio system will pause playback.
///   - When <c>APause</c> is <c>False</c>, the audio system will resume playback from where it was paused.
///   - This function provides the ability to control audio playback dynamically, such as for pause/resume functionality in media players or games.
/// </remarks>
procedure AGT_Audio_SetPause(const APause: Boolean); cdecl; external AGT_DLL;

/// <summary>
///   Plays music from an input/output (IO) source.
/// </summary>
/// <param name="AIO">
///   A handle to the input/output object containing the music data.
/// </param>
/// <param name="AFilename">
///   The filename or name of the music file (for reference or display purposes).
/// </param>
/// <param name="AVolume">
///   The volume level for the music playback, where <c>0.0</c> is mute and <c>1.0</c> is the maximum volume.
/// </param>
/// <param name="ALoop">
///   A boolean value specifying whether the music should loop after it finishes.
/// </param>
/// <param name="APan">
///   The stereo panning for the music, where <c>-1.0</c> is full left, <c>0.0</c> is centered, and <c>1.0</c> is full right.
/// </param>
/// <returns>
///   <c>True</c> if the music started playing successfully, otherwise <c>False</c>.
/// </returns>
/// <remarks>
///   - This function allows playing music from an IO object, enabling dynamic loading of music data.
///   - The panning parameter allows you to adjust the stereo output of the music.
/// </remarks>
function AGT_Audio_PlayMusic(const AIO: AGT_IO; const AFilename: PWideChar; const AVolume: Single; const ALoop: Boolean; const APan: Single = 0.0): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Plays music from a file.
/// </summary>
/// <param name="AFilename">
///   The file path to the music file.
/// </param>
/// <param name="AVolume">
///   The volume level for the music playback, where <c>0.0</c> is mute and <c>1.0</c> is the maximum volume.
/// </param>
/// <param name="ALoop">
///   A boolean value specifying whether the music should loop after it finishes.
/// </param>
/// <param name="APan">
///   The stereo panning for the music, where <c>-1.0</c> is full left, <c>0.0</c> is centered, and <c>1.0</c> is full right.
/// </param>
/// <returns>
///   <c>True</c> if the music started playing successfully, otherwise <c>False</c>.
/// </returns>
/// <remarks>
///   - This function plays music directly from a file path.
///   - Panning and volume settings allow for more dynamic control over the audio playback.
/// </remarks>
function AGT_Audio_PlayMusicFromFile(const AFilename: PWideChar; const AVolume: Single; const ALoop: Boolean; const APan: Single = 0.0): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Plays music from a file stored inside a ZIP archive.
/// </summary>
/// <param name="AZipFilename">
///   The path to the ZIP archive containing the music file.
/// </param>
/// <param name="AFilename">
///   The name of the music file inside the ZIP archive.
/// </param>
/// <param name="APassword">
///   The password for the ZIP archive, if required. Pass <c>nil</c> if no password is needed.
/// </param>
/// <param name="AVolume">
///   The volume level for the music playback, where <c>0.0</c> is mute and <c>1.0</c> is the maximum volume.
/// </param>
/// <param name="ALoop">
///   A boolean value specifying whether the music should loop after it finishes.
/// </param>
/// <param name="APan">
///   The stereo panning for the music, where <c>-1.0</c> is full left, <c>0.0</c> is centered, and <c>1.0</c> is full right.
/// </param>
/// <returns>
///   <c>True</c> if the music started playing successfully, otherwise <c>False</c>.
/// </returns>
/// <remarks>
///   - This function plays music from a ZIP archive, allowing for bundled audio resources.
///   - Panning and volume settings are supported to customize audio output.
/// </remarks>
function AGT_Audio_PlayMusicFromZipFile(const AZipFilename, AFilename, APassword: PWideChar; const AVolume: Single; const ALoop: Boolean; const APan: Single = 0.0): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Unloads the currently loaded music from memory.
/// </summary>
/// <remarks>
///   - This function stops any playing music and releases memory allocated for it.
///   - Call this when the music is no longer needed or when switching between music tracks.
/// </remarks>
procedure AGT_Audio_UnloadMusic(); cdecl; external AGT_DLL;

/// <summary>
///   Checks whether the currently playing music is set to loop.
/// </summary>
/// <returns>
///   <c>True</c> if the music is set to loop; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - Use this function to determine the loop state of the currently playing music.
///   - If the music is set to loop, it will restart automatically when it reaches the end.
///   - Useful for implementing logic related to dynamic music settings (e.g., toggle loop on or off).
/// </remarks>
function AGT_Audio_IsMusicLooping(): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Sets whether the currently playing music should loop or not.
/// </summary>
/// <param name="ALoop">
///   A boolean value specifying whether to loop the music:
///   - <c>True</c>: Music will loop (restart after reaching the end).
///   - <c>False</c>: Music will not loop (it will stop after finishing).
/// </param>
/// <remarks>
///   - Use this function to toggle the looping behavior for the currently playing music.
///   - If called while music is playing, it will update the looping behavior immediately.
///   - If the music is not currently playing, it will apply when the music starts playing.
/// </remarks>
procedure AGT_Audio_SetMusicLooping(const ALoop: Boolean); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current volume level of the music playback.
/// </summary>
/// <returns>
///   A floating-point value representing the current music volume, where:
///   - <c>0.0</c> represents mute (no sound),
///   - <c>1.0</c> represents the maximum volume.
/// </returns>
/// <remarks>
///   - This function allows you to get the current volume setting for music playback.
///   - Use this function to display or adjust the music volume in the application dynamically.
/// </remarks>
function AGT_Audio_MusicVolume(): Single; cdecl; external AGT_DLL;

/// <summary>
///   Sets the volume level for music playback.
/// </summary>
/// <param name="AVolume">
///   A floating-point value representing the desired music volume, where:
///   - <c>0.0</c> mutes the music,
///   - <c>1.0</c> sets the maximum volume.
/// </param>
/// <remarks>
///   - This function sets the volume for music playback. The volume value is clamped to the range [0.0, 1.0].
///   - Use this procedure to adjust the volume dynamically during gameplay or media playback.
/// </remarks>
procedure AGT_Audio_SetMusicVolume(const AVolume: Single); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current stereo pan setting for the music playback.
/// </summary>
/// <returns>
///   A floating-point value representing the current music panning, where:
///   - <c>-1.0</c> represents full left,
///   - <c>0.0</c> represents center,
///   - <c>1.0</c> represents full right.
/// </returns>
/// <remarks>
///   - Use this function to get the current pan setting for music, allowing you to check or adjust stereo positioning dynamically.
///   - This value is applied to the music playback to control its positioning in the stereo field.
/// </remarks>
function AGT_Audio_MusicPan(): Single; cdecl; external AGT_DLL;

/// <summary>
///   Sets the stereo pan for the music playback.
/// </summary>
/// <param name="APan">
///   A floating-point value representing the desired stereo pan, where:
///   - <c>-1.0</c> for full left,
///   - <c>0.0</c> for center,
///   - <c>1.0</c> for full right.
/// </param>
/// <remarks>
///   - Use this procedure to control the stereo positioning of the music playback in the left-right audio field.
///   - The pan value can be dynamically adjusted to create an immersive audio experience.
/// </remarks>
procedure AGT_Audio_SetMusicPan(const APan: Single); cdecl; external AGT_DLL;

/// <summary>
///   Loads a sound effect from an input/output (IO) source.
/// </summary>
/// <param name="AIO">
///   A handle to the input/output object containing the sound data.
/// </param>
/// <param name="AFilename">
///   The filename or name of the sound file (for reference or display purposes).
/// </param>
/// <returns>
///   An integer representing the sound handle. This handle is used to identify and play the sound.
///   If loading fails, returns <c>AGT_AUDIO_ERROR</c>.
/// </returns>
/// <remarks>
///   - This function allows loading sound effects dynamically from an IO object.
///   - Use the returned sound handle to play, adjust, or unload the sound later.
/// </remarks>
function AGT_Audio_LoadSound(const AIO: AGT_IO; const AFilename: PWideChar): Integer; cdecl; external AGT_DLL;

/// <summary>
///   Loads a sound effect from a file.
/// </summary>
/// <param name="AFilename">
///   The path to the sound file to load.
/// </param>
/// <returns>
///   An integer representing the sound handle. If loading fails, returns <c>AGT_AUDIO_ERROR</c>.
/// </returns>
/// <remarks>
///   - This function loads a sound effect directly from a file.
///   - Use the returned sound handle to play or manipulate the sound.
/// </remarks>
function AGT_Audio_LoadSoundFromFile(const AFilename: PWideChar): Integer; cdecl; external AGT_DLL;

/// <summary>
///   Loads a sound effect from a file stored inside a ZIP archive.
/// </summary>
/// <param name="AZipFilename">
///   The path to the ZIP archive containing the sound file.
/// </param>
/// <param name="AFilename">
///   The name of the sound file inside the ZIP archive.
/// </param>
/// <param name="APassword">
///   The password for the ZIP archive, if required. Pass <c>nil</c> if no password is needed.
/// </param>
/// <returns>
///   An integer representing the sound handle. If loading fails, returns <c>AGT_AUDIO_ERROR</c>.
/// </returns>
/// <remarks>
///   - This function allows loading sound effects stored within a ZIP archive.
///   - The returned handle can be used for playing or manipulating the sound.
/// </remarks>
function AGT_Audio_LoadSoundFromZipFile(const AZipFilename, AFilename, APassword: PWideChar): Integer; cdecl; external AGT_DLL;

/// <summary>
///   Unloads a sound effect from memory.
/// </summary>
/// <param name="ASound">
///   The handle of the sound to be unloaded.
/// </param>
/// <remarks>
///   - Use this function to free the resources associated with the loaded sound.
///   - After unloading, the sound handle is no longer valid, and the sound can no longer be played.
/// </remarks>
procedure AGT_Audio_UnloadSound(var ASound: Integer); cdecl; external AGT_DLL;

/// <summary>
///   Unloads all sound effects from memory.
/// </summary>
/// <remarks>
///   - This function frees all resources associated with the loaded sounds.
///   - Use this when no sounds are needed anymore or before unloading the audio system to clean up all resources.
/// </remarks>
procedure AGT_Audio_UnloadAllSounds(); cdecl; external AGT_DLL;

/// <summary>
///   Plays a sound effect on a specified audio channel.
/// </summary>
/// <param name="ASound">
///   The handle to the loaded sound effect that will be played.
/// </param>
/// <param name="AChannel">
///   The audio channel on which the sound will be played. The channel can be one of the predefined channels, or a dynamically assigned channel (use `AGT_AUDIO_CHANNEL_DYNAMIC` for dynamic assignment).
/// </param>
/// <param name="AVolume">
///   The volume level for the sound playback, where <c>0.0</c> is mute and <c>1.0</c> is the maximum volume.
/// </param>
/// <param name="ALoop">
///   A boolean value indicating whether the sound should loop. Pass <c>True</c> for looping, or <c>False</c> for a one-time play.
/// </param>
/// <returns>
///   An integer representing the status of the sound playback. Returns <c>AGT_AUDIO_ERROR</c> if the sound failed to play, or a positive value indicating the channel of the playback.
/// </returns>
/// <remarks>
///   - Use this function to play a loaded sound on a specific audio channel with control over the volume and looping behavior.
///   - If you want to use a dynamically assigned channel, pass `AGT_AUDIO_CHANNEL_DYNAMIC` for the `AChannel` parameter.
/// </remarks>
function AGT_Audio_PlaySound(const ASound, AChannel: Integer; const AVolume: Single; const ALoop: Boolean): Integer; cdecl; external AGT_DLL;

/// <summary>
///   Reserves or releases a specific audio channel for exclusive use.
/// </summary>
/// <param name="AChannel">
///   The audio channel to reserve or release.
/// </param>
/// <param name="aReserve">
///   A boolean value specifying whether to reserve or release the channel:
///   - <c>True</c>: Reserve the channel (no other sound can use this channel).
///   - <c>False</c>: Release the channel (allow other sounds to use this channel).
/// </param>
/// <remarks>
///   - Use this function to reserve a specific channel for exclusive use, preventing other sounds from using the same channel.
///   - A reserved channel can be released later, allowing other sounds to be played on it.
///   - This can be useful when you need to ensure that certain sounds play without interruption (e.g., background music).
/// </remarks>
procedure AGT_Audio_ReserveChannel(const AChannel: Integer; const aReserve: Boolean); cdecl; external AGT_DLL;

/// <summary>
///   Checks if a specific audio channel is currently reserved for exclusive use.
/// </summary>
/// <param name="AChannel">
///   The audio channel to check.
/// </param>
/// <returns>
///   <c>True</c> if the channel is reserved; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - Use this function to check if a specific channel is currently reserved or available for playback.
///   - This is useful when you want to confirm whether a channel is available for use by other sounds or music.
/// </remarks>
function AGT_Audio_IsChannelReserved(const AChannel: Integer): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Stops all audio playback on the specified audio channel.
/// </summary>
/// <param name="AChannel">
///   The audio channel on which to stop the playback.
/// </param>
/// <remarks>
///   - This function immediately stops any sound or music playing on the specified channel.
///   - Useful for stopping specific audio channels, such as when a certain sound or music is no longer needed.
///   - This does not affect other channels, which can continue playing their respective sounds or music.
/// </remarks>
procedure AGT_Audio_StopChannel(const AChannel: Integer); cdecl; external AGT_DLL;

/// <summary>
///   Sets the volume for a specific audio channel.
/// </summary>
/// <param name="AChannel">
///   The audio channel whose volume is to be adjusted.
/// </param>
/// <param name="AVolume">
///   The desired volume level for the channel, where:
///   - <c>0.0</c> is mute,
///   - <c>1.0</c> is the maximum volume.
/// </param>
/// <remarks>
///   - This function allows you to set the volume of individual audio channels, providing granular control over the audio levels of different sounds or music playing on separate channels.
///   - It’s useful for adjusting the volume dynamically for specific audio sources (e.g., background music, sound effects).
/// </remarks>
procedure AGT_Audio_SetChannelVolume(const AChannel: Integer; const AVolume: Single); cdecl; external AGT_DLL;

/// <summary>
///   Gets the current volume for a specific audio channel.
/// </summary>
/// <param name="AChannel">
///   The audio channel whose volume level is to be retrieved.
/// </param>
/// <returns>
///   A floating-point value representing the current volume of the channel, where:
///   - <c>0.0</c> is mute,
///   - <c>1.0</c> is the maximum volume.
/// </returns>
/// <remarks>
///   - Use this function to retrieve the volume setting of a particular audio channel.
///   - It’s useful for monitoring or displaying the current volume levels of different audio sources.
/// </remarks>
function AGT_Audio_GetChannelVolume(const AChannel: Integer): Single; cdecl; external AGT_DLL;

/// <summary>
///   Sets the position of a specific audio channel in the stereo or 3D space.
/// </summary>
/// <param name="AChannel">
///   The audio channel whose position is to be adjusted.
/// </param>
/// <param name="X">
///   The X-coordinate of the audio channel's position, where the value represents the horizontal position in 3D space or stereo field.
/// </param>
/// <param name="Y">
///   The Y-coordinate of the audio channel's position, where the value represents the vertical position in 3D space (or an alternative dimension for 2D panning).
/// </param>
/// <remarks>
///   - This function allows you to control the spatial positioning of sounds or music playing on a specific audio channel.
///   - Typically, you would use this to control the panning of a sound in a 2D stereo field or position it in 3D space for spatial audio effects.
///   - Adjusting the position of the channel can simulate directional audio or the placement of sound sources in a virtual environment.
/// </remarks>
procedure AGT_Audio_SetChannelPosition(const AChannel: Integer; const X, Y: Single); cdecl; external AGT_DLL;

/// <summary>
///   Sets whether a specific audio channel should loop its sound or music playback.
/// </summary>
/// <param name="AChannel">
///   The audio channel whose looping behavior is to be adjusted.
/// </param>
/// <param name="ALoop">
///   A boolean value indicating whether to loop the audio on the specified channel:
///   - <c>True</c>: Loop the sound or music on the channel.
///   - <c>False</c>: Do not loop the sound or music (it will stop after completing).
/// </param>
/// <remarks>
///   - Use this function to enable or disable looping for sounds or music on a specific audio channel.
///   - This function is helpful for controlling whether background music or sound effects repeat or stop after playing once.
/// </remarks>
procedure AGT_Audio_SetChannelLoop(const AChannel: Integer; const ALoop: Boolean); cdecl; external AGT_DLL;

/// <summary>
///   Checks whether a specific audio channel is set to loop its sound or music playback.
/// </summary>
/// <param name="AChannel">
///   The audio channel to check for looping status.
/// </param>
/// <returns>
///   <c>True</c> if the audio on the specified channel is set to loop; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function allows you to check if the playback on a channel is set to loop.
///   - It is useful for managing the playback behavior of sounds or music in applications with dynamic audio content.
/// </remarks>
function AGT_Audio_IsChannelLooping(const AChannel: Integer): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks whether a specific audio channel is currently playing sound.
/// </summary>
/// <param name="AChannel">
///   The audio channel to check for playback status.
/// </param>
/// <returns>
///   <c>True</c> if the audio on the specified channel is currently playing; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function is useful for determining if a specific sound is playing on a given audio channel.
///   - You can use this to manage playback behavior, such as preventing overlapping sounds or ensuring that certain sounds are not played while others are still active.
/// </remarks>
function AGT_Audio_IsChannelPlaying(const AChannel: Integer): Boolean; cdecl; external AGT_DLL;

//=== CONSOLE ===============================================================
const
  AGT_LF   = AnsiChar(#10);
  AGT_CR   = AnsiChar(#13);
  AGT_CRLF = AGT_LF+AGT_CR;
  AGT_ESC  = AnsiChar(#27);

  AGT_VK_ESC = 27;

  // Cursor Movement
  AGT_CSICursorPos = AGT_ESC + '[%d;%dH';         // Set cursor position
  AGT_CSICursorUp = AGT_ESC + '[%dA';             // Move cursor up
  AGT_CSICursorDown = AGT_ESC + '[%dB';           // Move cursor down
  AGT_CSICursorForward = AGT_ESC + '[%dC';        // Move cursor forward
  AGT_CSICursorBack = AGT_ESC + '[%dD';           // Move cursor backward
  AGT_CSISaveCursorPos = AGT_ESC + '[s';          // Save cursor position
  AGT_CSIRestoreCursorPos = AGT_ESC + '[u';       // Restore cursor position

  // Cursor Visibility
  AGT_CSIShowCursor = AGT_ESC + '[?25h';          // Show cursor
  AGT_CSIHideCursor = AGT_ESC + '[?25l';          // Hide cursor
  AGT_CSIBlinkCursor = AGT_ESC + '[?12h';         // Enable cursor blinking
  AGT_CSISteadyCursor = AGT_ESC + '[?12l';        // Disable cursor blinking

  // Screen Manipulation
  AGT_CSIClearScreen = AGT_ESC + '[2J';           // Clear screen
  AGT_CSIClearLine = AGT_ESC + '[2K';             // Clear line
  AGT_CSIScrollUp = AGT_ESC + '[%dS';             // Scroll up by n lines
  AGT_CSIScrollDown = AGT_ESC + '[%dT';           // Scroll down by n lines

  // Text Formatting
  AGT_CSIBold = AGT_ESC + '[1m';                  // Bold text
  AGT_CSIUnderline = AGT_ESC + '[4m';             // Underline text
  AGT_CSIResetFormat = AGT_ESC + '[0m';           // Reset text formatting
  AGT_CSIResetBackground = #27'[49m';         // Reset background text formatting
  AGT_CSIResetForeground = #27'[39m';         // Reset forground text formatting
  AGT_CSIInvertColors = AGT_ESC + '[7m';          // Invert foreground/background
  AGT_CSINormalColors = AGT_ESC + '[27m';         // Normal colors

  AGT_CSIDim = AGT_ESC + '[2m';
  AGT_CSIItalic = AGT_ESC + '[3m';
  AGT_CSIBlink = AGT_ESC + '[5m';
  AGT_CSIFramed = AGT_ESC + '[51m';
  AGT_CSIEncircled = AGT_ESC + '[52m';

  // Text Modification
  AGT_CSIInsertChar = AGT_ESC + '[%d@';           // Insert n spaces at cursor position
  AGT_CSIDeleteChar = AGT_ESC + '[%dP';           // Delete n characters at cursor position
  AGT_CSIEraseChar = AGT_ESC + '[%dX';            // Erase n characters at cursor position

  // Colors (Foreground and Background)
  AGT_CSIFGBlack = AGT_ESC + '[30m';
  AGT_CSIFGRed = AGT_ESC + '[31m';
  AGT_CSIFGGreen = AGT_ESC + '[32m';
  AGT_CSIFGYellow = AGT_ESC + '[33m';
  AGT_CSIFGBlue = AGT_ESC + '[34m';
  AGT_CSIFGMagenta = AGT_ESC + '[35m';
  AGT_CSIFGCyan = AGT_ESC + '[36m';
  AGT_CSIFGWhite = AGT_ESC + '[37m';

  AGT_CSIBGBlack = AGT_ESC + '[40m';
  AGT_CSIBGRed = AGT_ESC + '[41m';
  AGT_CSIBGGreen = AGT_ESC + '[42m';
  AGT_CSIBGYellow = AGT_ESC + '[43m';
  AGT_CSIBGBlue = AGT_ESC + '[44m';
  AGT_CSIBGMagenta = AGT_ESC + '[45m';
  AGT_CSIBGCyan = AGT_ESC + '[46m';
  AGT_CSIBGWhite = AGT_ESC + '[47m';

  AGT_CSIFGBrightBlack = AGT_ESC + '[90m';
  AGT_CSIFGBrightRed = AGT_ESC + '[91m';
  AGT_CSIFGBrightGreen = AGT_ESC + '[92m';
  AGT_CSIFGBrightYellow = AGT_ESC + '[93m';
  AGT_CSIFGBrightBlue = AGT_ESC + '[94m';
  AGT_CSIFGBrightMagenta = AGT_ESC + '[95m';
  AGT_CSIFGBrightCyan = AGT_ESC + '[96m';
  AGT_CSIFGBrightWhite = AGT_ESC + '[97m';

  AGT_CSIBGBrightBlack = AGT_ESC + '[100m';
  AGT_CSIBGBrightRed = AGT_ESC + '[101m';
  AGT_CSIBGBrightGreen = AGT_ESC + '[102m';
  AGT_CSIBGBrightYellow = AGT_ESC + '[103m';
  AGT_CSIBGBrightBlue = AGT_ESC + '[104m';
  AGT_CSIBGBrightMagenta = AGT_ESC + '[105m';
  AGT_CSIBGBrightCyan = AGT_ESC + '[106m';
  AGT_CSIBGBrightWhite = AGT_ESC + '[107m';

  AGT_CSIFGRGB = AGT_ESC + '[38;2;%d;%d;%dm';        // Foreground RGB
  AGT_CSIBGRGB = AGT_ESC + '[48;2;%d;%d;%dm';        // Backg

/// <summary>
///   Prints text to the console without adding a newline at the end.
/// </summary>
/// <param name="AText">
///   The text to be printed to the console.
/// </param>
/// <remarks>
///   - This function outputs the provided text to the console and leaves the cursor at the end of the printed text.
///   - Useful for printing continuous or dynamic content without starting a new line.
/// </remarks>
procedure AGT_Console_Print(const AText: PWideChar); cdecl; external AGT_DLL;

/// <summary>
///   Prints text to the console and adds a newline at the end.
/// </summary>
/// <param name="AText">
///   The text to be printed to the console.
/// </param>
/// <remarks>
///   - This function outputs the provided text to the console, followed by a newline character.
///   - Use this function for printing complete messages or logs where each message should appear on a new line.
/// </remarks>
procedure AGT_Console_PrintLn(const AText: PWideChar); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current position of the cursor in the console.
/// </summary>
/// <param name="X">
///   A pointer to an integer that will receive the X-coordinate (horizontal position) of the cursor.
/// </param>
/// <param name="Y">
///   A pointer to an integer that will receive the Y-coordinate (vertical position) of the cursor.
/// </param>
/// <remarks>
///   - This function retrieves the current cursor position in the console and stores the X and Y values in the provided variables.
///   - The position is returned in terms of the console's coordinate system, with (0,0) typically representing the top-left corner.
/// </remarks>
procedure AGT_Console_GetCursorPos(X, Y: PInteger); cdecl; external AGT_DLL;

/// <summary>
///   Sets the cursor position in the console.
/// </summary>
/// <param name="X">
///   The X-coordinate (horizontal position) to move the cursor to.
/// </param>
/// <param name="Y">
///   The Y-coordinate (vertical position) to move the cursor to.
/// </param>
/// <remarks>
///   - This function moves the cursor to the specified (X, Y) position in the console's coordinate system.
///   - Useful for formatting console output and placing the cursor at specific locations for dynamic text updates.
/// </remarks>
procedure AGT_Console_SetCursorPos(const X, Y: Integer); cdecl; external AGT_DLL;

/// <summary>
///   Sets the visibility of the console cursor.
/// </summary>
/// <param name="AVisible">
///   A boolean value that controls the cursor visibility:
///   - <c>True</c>: Make the cursor visible.
///   - <c>False</c>: Hide the cursor.
/// </param>
/// <remarks>
///   - This function allows you to dynamically show or hide the console cursor during runtime.
///   - Useful for creating cleaner interfaces or hiding the cursor while it is not needed (e.g., during game or animation playback).
/// </remarks>
procedure AGT_Console_SetCursorVisible(const AVisible: Boolean); cdecl; external AGT_DLL;

/// <summary>
///   Hides the console cursor.
/// </summary>
/// <remarks>
///   - This function specifically hides the console cursor, making it invisible to the user.
///   - Use this when you need to hide the cursor during certain operations, such as when updating the console display without cursor interference.
/// </remarks>
procedure AGT_Console_HideCursor(); cdecl; external AGT_DLL;

/// <summary>
///   Shows the console cursor.
/// </summary>
/// <remarks>
///   - This function makes the console cursor visible again, allowing the user to see it and interact with it.
///   - Use this to restore the cursor visibility after it has been hidden.
/// </remarks>
procedure AGT_Console_ShowCursor(); cdecl; external AGT_DLL;

/// <summary>
///   Saves the current position of the console cursor.
/// </summary>
/// <remarks>
///   - This function saves the current cursor position in the console so that it can be restored later.
///   - Useful when you want to temporarily move the cursor for printing something and then return to the original position to continue printing other content.
/// </remarks>
procedure AGT_Console_SaveCursorPos(); cdecl; external AGT_DLL;

/// <summary>
///   Restores the console cursor to the previously saved position.
/// </summary>
/// <remarks>
///   - This function restores the cursor to the position that was saved using the <c>AGT_Console_SaveCursorPos</c> procedure.
///   - It is useful for scenarios where you need to move the cursor temporarily, and then return to the original position for further text output.
/// </remarks>
procedure AGT_Console_RestoreCursorPos(); cdecl; external AGT_DLL;

/// <summary>
///   Moves the console cursor up by a specified number of lines.
/// </summary>
/// <param name="ALines">
///   The number of lines to move the cursor up. A positive integer moves the cursor up.
/// </param>
/// <remarks>
///   - This function moves the cursor upward by the specified number of lines.
///   - Useful for modifying output placement in a console window, such as adjusting text positioning for dynamic content.
/// </remarks>
procedure AGT_Console_MoveCursorUp(const ALines: Integer); cdecl; external AGT_DLL;

/// <summary>
///   Moves the console cursor down by a specified number of lines.
/// </summary>
/// <param name="ALines">
///   The number of lines to move the cursor down. A positive integer moves the cursor down.
/// </param>
/// <remarks>
///   - This function moves the cursor downward by the specified number of lines.
///   - Useful for adjusting the cursor's position when new output is added below existing content.
/// </remarks>
procedure AGT_Console_MoveCursorDown(const ALines: Integer); cdecl; external AGT_DLL;

/// <summary>
///   Moves the console cursor forward by a specified number of columns.
/// </summary>
/// <param name="ACols">
///   The number of columns to move the cursor forward. A positive integer moves the cursor right.
/// </param>
/// <remarks>
///   - This function moves the cursor to the right by the specified number of columns.
///   - It is useful for formatting text output horizontally, such as shifting the cursor to start printing text from a specific column.
/// </remarks>
procedure AGT_Console_MoveCursorForward(const ACols: Integer); cdecl; external AGT_DLL;

/// <summary>
///   Moves the console cursor back by a specified number of columns.
/// </summary>
/// <param name="ACols">
///   The number of columns to move the cursor back. A positive integer moves the cursor left.
/// </param>
/// <remarks>
///   - This function moves the cursor to the left by the specified number of columns.
///   - Useful for adjusting horizontal text placement in the console window.
/// </remarks>
procedure AGT_Console_MoveCursorBack(const ACols: Integer); cdecl; external AGT_DLL;

/// <summary>
///   Clears the entire console screen, removing all content.
/// </summary>
/// <remarks>
///   - This function will clear all text from the console, effectively resetting the console's display to a blank state.
///   - Useful for starting fresh with a clean screen, especially during certain phases of a program or game (e.g., clearing the screen after a menu selection).
/// </remarks>
procedure AGT_Console_ClearScreen(); cdecl; external AGT_DLL;

/// <summary>
///   Clears the current line where the cursor is positioned.
/// </summary>
/// <remarks>
///   - This function removes all text on the current line and leaves the cursor at the beginning of the line.
///   - Useful for situations where you want to update or overwrite the current line's content without affecting other lines.
/// </remarks>
procedure AGT_Console_ClearLine(); cdecl; external AGT_DLL;

/// <summary>
///   Clears the part of the current line from the cursor position onward and applies a specified background color to the cleared area.
/// </summary>
/// <param name="AColor">
///   A wide character string representing the color to apply to the cleared area.
/// </param>
/// <remarks>
///   - This function clears the content from the cursor's current position to the end of the line and optionally applies a color to the cleared space.
///   - Useful for dynamic console interfaces where part of the line needs to be cleared and updated with new content while preserving the rest of the line.
/// </remarks>
procedure AGT_Console_ClearLineFromCursor(const AColor: PWideChar); cdecl; external AGT_DLL;

/// <summary>
///   Sets the console text to bold formatting.
/// </summary>
/// <remarks>
///   - This function allows you to change the text format to bold. It affects all text printed to the console after calling this function.
///   - Use this to highlight specific parts of your console output, such as titles, headings, or important information.
/// </remarks>
procedure AGT_Console_SetBoldText(); cdecl; external AGT_DLL;

/// <summary>
///   Resets the console text formatting to default (non-bold).
/// </summary>
/// <remarks>
///   - This function resets any text formatting (like bold) applied by `AGT_Console_SetBoldText` or other formatting functions.
///   - Use this after applying bold or other text styles to return the text to the standard formatting for future output.
/// </remarks>
procedure AGT_Console_ResetTextFormat(); cdecl; external AGT_DLL;

/// <summary>
///   Sets the foreground (text) color of the console.
/// </summary>
/// <param name="AColor">
///   A wide character string representing the color name for the foreground (text) color (e.g., "Red", "Green", "Blue", etc.).
/// </param>
/// <remarks>
///   - This function changes the color of text printed to the console.
///   - Useful for emphasizing certain parts of your output by using different text colors.
/// </remarks>
procedure AGT_Console_SetForegroundColor(const AColor: PWideChar); cdecl; external AGT_DLL;

/// <summary>
///   Sets the background color of the console.
/// </summary>
/// <param name="AColor">
///   A wide character string representing the color name for the background (e.g., "Black", "White", "Yellow", etc.).
/// </param>
/// <remarks>
///   - This function changes the background color behind the text in the console.
///   - Use this to highlight certain sections of the console or to create a more visually distinct output environment.
/// </remarks>
procedure AGT_Console_SetBackgroundColor(const AColor: PWideChar); cdecl; external AGT_DLL;

/// <summary>
///   Sets the foreground (text) color of the console using RGB values.
/// </summary>
/// <param name="ARed">
///   The red component of the foreground color (0 to 255).
/// </param>
/// <param name="AGreen">
///   The green component of the foreground color (0 to 255).
/// </param>
/// <param name="ABlue">
///   The blue component of the foreground color (0 to 255).
/// </param>
/// <remarks>
///   - This function allows you to set the text color using RGB values instead of predefined color names.
///   - Useful for custom colors that are not part of the standard predefined color set.
/// </remarks>
procedure AGT_Console_SetForegroundRGB(const ARed, AGreen, ABlue: Byte); cdecl; external AGT_DLL;

/// <summary>
///   Sets the background color of the console using RGB values.
/// </summary>
/// <param name="ARed">
///   The red component of the background color (0 to 255).
/// </param>
/// <param name="AGreen">
///   The green component of the background color (0 to 255).
/// </param>
/// <param name="ABlue">
///   The blue component of the background color (0 to 255).
/// </param>
/// <remarks>
///   - This function allows you to set the background color using RGB values instead of predefined color names.
///   - Useful for creating custom background colors to match a specific color scheme or theme.
/// </remarks>
procedure AGT_Console_SetBackgroundRGB(const ARed, AGreen, ABlue: Byte); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current size of the console window, including its width and height.
/// </summary>
/// <param name="AWidth">
///   A pointer to an integer that will receive the console's width (in characters).
/// </param>
/// <param name="AHeight">
///   A pointer to an integer that will receive the console's height (in lines).
/// </param>
/// <remarks>
///   - This function retrieves the current width and height of the console window in terms of characters and lines.
///   - Useful for adjusting the layout or content of your console application based on the available console size.
/// </remarks>
procedure AGT_Console_GetSize(AWidth: PInteger; AHeight: PInteger); cdecl; external AGT_DLL;

/// <summary>
///   Sets the title of the console window.
/// </summary>
/// <param name="ATitle">
///   A wide character string representing the title to set for the console window.
/// </param>
/// <remarks>
///   - This function allows you to change the title of the console window, which is displayed in the title bar of the console.
///   - Useful for displaying dynamic information, such as the name of the application, status updates, or user-customized titles.
/// </remarks>
procedure AGT_Console_SetTitle(const ATitle: PWideChar); cdecl; external AGT_DLL;

/// <summary>
///   Retrieves the current title of the console window.
/// </summary>
/// <returns>
///   A wide character string representing the current title of the console window.
/// </returns>
/// <remarks>
///   - This function returns the current title of the console window.
///   - Useful for retrieving and displaying the current title or for further manipulation of the window title during runtime.
/// </remarks>
function AGT_Console_GetTitle(): PWideChar; cdecl; external AGT_DLL;

/// <summary>
///   Checks if the console is active and has output available.
/// </summary>
/// <returns>
///   <c>True</c> if the console is active and has output available; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function checks if the console window is present and actively producing output (such as print statements, logs, or errors).
///   - Useful for determining if there is content to process, display, or monitor in the console before performing actions in your application.
///   - This function is typically used in interactive console applications to check if new output is available for further actions.
/// </remarks>
function AGT_Console_HasOutput(): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks if the console was launched with an associated console window or if the process was run without it.
/// </summary>
/// <returns>
///   <c>True</c> if the process was started with a console window (either explicitly or implicitly); otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function helps determine whether the current process is running with an associated console window.
///   - It's useful for understanding if the application was executed from a console, a script, or as a background process without a console (e.g., from a graphical user interface or service).
///   - This can be particularly important for handling logging, user input, or debugging behavior, depending on whether the console is available.
/// </remarks>
function AGT_Console_WasRunFrom(): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Waits for the user to press any key in the console.
/// </summary>
/// <remarks>
///   - This function pauses the execution of the program and waits until the user presses any key.
///   - Useful for interactive console applications where you need the user to acknowledge something before proceeding, such as a "press any key to continue" prompt.
/// </remarks>
procedure AGT_Console_WaitForAnyKey(); cdecl; external AGT_DLL;

/// <summary>
///   Checks if any key has been pressed in the console.
/// </summary>
/// <returns>
///   <c>True</c> if any key has been pressed; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function checks whether a key has been pressed in the console, returning immediately with a boolean result.
///   - Useful for non-blocking checks when you want to know if any key has been pressed without halting program execution.
/// </remarks>
function AGT_Console_AnyKeyPressed(): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Clears the key states in the console, resetting any keys that were previously pressed.
/// </summary>
/// <remarks>
///   - This function clears all the current key states, effectively resetting the console’s key input tracking.
///   - Useful for scenarios where you need to clear key states before checking for fresh user input or resetting the keyboard state between different input phases.
/// </remarks>
procedure AGT_Console_ClearKeyStates(); cdecl; external AGT_DLL;

/// <summary>
///   Clears the console's keyboard buffer, removing any queued keys.
/// </summary>
/// <remarks>
///   - This function clears any keys that are currently in the console’s input buffer.
///   - Useful when you need to discard any queued input that has not been processed yet, especially after an input event or when starting a new phase of input.
/// </remarks>
procedure AGT_Console_ClearKeyboardBuffer(); cdecl; external AGT_DLL;

/// <summary>
///   Checks if a specific key is currently pressed in the console.
/// </summary>
/// <param name="AKey">
///   The key to check, represented by its key code (usually corresponding to the key's ASCII or virtual key code).
/// </param>
/// <returns>
///   <c>True</c> if the specified key is currently pressed; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function is useful for detecting if a specific key is held down during runtime.
///   - It is commonly used in interactive applications, games, or command-line tools that need to track key states in real-time.
/// </remarks>
function AGT_Console_IsKeyPressed(AKey: Byte): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks if a specific key was released in the console during the last frame or cycle.
/// </summary>
/// <param name="AKey">
///   The key to check, represented by its key code (usually corresponding to the key's ASCII or virtual key code).
/// </param>
/// <returns>
///   <c>True</c> if the specified key was released during the last frame; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function checks if a key was released in the previous input cycle.
///   - Useful for detecting key release events in interactive applications or games where certain actions are triggered when a key is released.
/// </remarks>
function AGT_Console_WasKeyReleased(AKey: Byte): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Checks if a specific key was pressed in the console during the last frame or cycle.
/// </summary>
/// <param name="AKey">
///   The key to check, represented by its key code (usually corresponding to the key's ASCII or virtual key code).
/// </param>
/// <returns>
///   <c>True</c> if the specified key was pressed during the last frame; otherwise, <c>False</c>.
/// </returns>
/// <remarks>
///   - This function checks if a key was pressed in the previous input cycle.
///   - Useful for detecting key press events in interactive applications or games where certain actions are triggered when a key is pressed.
/// </remarks>
function AGT_Console_WasKeyPressed(AKey: Byte): Boolean; cdecl; external AGT_DLL;

/// <summary>
///   Reads a key input from the console.
/// </summary>
/// <returns>
///   A wide character representing the key that was pressed.
/// </returns>
/// <remarks>
///   - This function waits for the user to press a key and returns the corresponding key as a wide character.
///   - Useful for reading user input from the console in interactive applications or games.
///   - The returned value can be used for further processing, such as triggering actions based on the specific key pressed.
/// </remarks>
function AGT_Console_ReadKey(): WideChar; cdecl; external AGT_DLL;

/// <summary>
///   Pauses the execution of the program until the user presses any key.
/// </summary>
/// <remarks>
///   - This function halts the program's execution and waits for the user to press any key to continue.
///   - Commonly used in console applications to allow the user to acknowledge a message before proceeding.
/// </remarks>
procedure AGT_Console_Pause(); cdecl; external AGT_DLL;

/// <summary>
///   Pauses the execution of the program with additional customizable options, including forcing a pause, setting a display color, and showing a custom message.
/// </summary>
/// <param name="AForcePause">
///   A boolean value:
///   - <c>True</c> forces a pause, regardless of any other conditions.
///   - <c>False</c> allows for the normal pause behavior based on user interaction.
/// </param>
/// <param name="AColor">
///   A wide character string representing the color to display during the pause, or <c>nil</c> for no specific color.
/// </param>
/// <param name="AMsg">
///   A wide character string representing the message to display during the pause. If <c>nil</c>, no message is displayed.
/// </param>
/// <remarks>
///   - This function provides more control over the pause behavior, including forcing the pause, customizing the displayed message, and adjusting the text color.
///   - Useful for adding customizable user prompts or ensuring that a pause occurs under specific conditions.
/// </remarks>
procedure AGT_Console_PauseEx(const AForcePause: Boolean; AColor: PWideChar; const AMsg: PWideChar); cdecl; external AGT_DLL;

implementation

uses
  Math;

initialization

{$IFNDEF FPC}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}

  SetExceptionMask(GetExceptionMask + [exOverflow, exInvalidOp]);

end.
