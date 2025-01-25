# IniUnicode

IniUnicode is a AutoIt library of unicode-enabled user defined functions (UDF) for working with standard format .ini files.

## INI files and Unicode support

AutoIt has Unicode support, but its standard functions for working with standard format .ini files are one of the exceptions. They just write ANSI text to files or read ANSI text from them. And this is not a bug.

INI files were introduced by 16-bit Windows, and 16-bit Windows appeared before Unicode, so INI files did not support Unicode at the time they were introduced. This format was used for operating system components, such as device drivers, fonts, and startup launchers. INI files were also generally used by applications to store individual settings. Thus, this format has become an informal standard in many contexts of configuration.

There is still some software in the industry that works with INI files but does not support Unicode. This in turn means that the format of INI files is pretty much locked and cannot be extended, since there is no mechanism for extending them in a way that won’t break those old or archaic INI file parsers.

For this reason, many tools, including AutoIt, intentionally do not support Unicode by default when working with standard format .ini files. This is done to ensure backward compatibility with old or archaic software and configuration files.

However, INI files are human-readable and simple to parse, so it is a usable format for configuration or data files that do not require much greater complexity. The relatively simple format of INI files means that many people parse (and sometimes even modify) them directly, without using special tools. All this makes standard format .ini files useful in many cases that go beyond the traditional functionality of 16-bit Windows.

In particular, users may want to use standard format .ini files to store configuration data using Unicode characters in INI files, such as arbitrary paths in the file system, or any arbitrary data, such as localizable program messages. And the IniUnicode library provides this capability while maintaining, as much as possible, backward compatibility with old or archaic INI file parsers.

## Implementation features

The library implements Unicode enabling for all structural elements of standard format .ini files: sections, keys and values. That is, the name of any of these elements can contain any set of characters (except for standard service characters and exception characters).

* During read operations, library functions read string values ??from a file, convert strings as ANSI text into binary data, convert the binary data into strings as UTF-8 text, and return the resulting Unicode representation of the text.
* During write operations, library functions take string values ??from parameters, convert strings as UTF-8 text into binary data, convert the binary data into strings as ANSI text, and write the resulting ANSI representation of the text to a file.

UTF-8 is capable of encoding all 1,112,064 valid Unicode scalar values using a variable-width encoding of one to four one-byte (8-bit) code units. It is also backward compatible with ASCII: the first 128 characters of Unicode, which correspond one-to-one with ASCII, are encoded using a single byte with the same binary value as ASCII, so that a UTF-8-encoded file using only those characters is identical to an ASCII file.

Thus, if the read and written strings contain only ASCII characters, then the standard AutoIt functions and the IniUnicode functions will work the same way and create files that are fully compatible with each other. But if the strings contain the second 128 characters of ANSI text in any one-byte (8-bit) encoding and other Unicode characters, then only the IniUnicode functions will provide the ability to fully work with them regardless of the system locale.

Also, please note the following features:

* The library's write functions create UTF-8 files without BOM. But they can also work with UTF-8 files with BOM. However, if the file is saved in UTF-8 with BOM, you should ensure that there is a newline character before the first section, otherwise it will not be read due to the 3 BOM bytes before the left square bracket.
* Due to the conversion of string data to binary and back, as well as additional checks, the library functions are always slower and create more CPU load than the standard AutoIt functions for working with standard format .ini files. This is true even for reading and writing strings consisting only of ASCII characters.
* The standard IniReadSection() function reads only the first 32767 bytes of a section content for legacy reasons. This limit also applies to the library's _IniUnicode_ReadSection() function. But keep in mind that non-ASCII characters in UTF-8 encoding take up from 2 to 4 bytes, so the maximum allowed size of the section contents with non-ASCII characters in UTF-8 will accommodate fewer characters than with ASCII characters in UTF-8 or standard ANSI text.

## Usage

Just include the library with

```
#include <IniUnicode.au3>
```

or

```
#include "IniUnicode.au3"
```

and use a familiar set of functions with recognizable names.

The 'examples' folder contains examples of using all public functions of the library.

## Correspondence between standard functions and library functions

The set of IniUnicode library functions replicates the set of standard AutoIt functions for working with .ini files. Their behavior is completely equivalent except for the addition Unicode enabling.

It is expected that in the source code the names of standard functions can simply be replaced with library functions and the code will no longer require any modifications.

Here is a complete table of correspondence between standard functions and library functions:

| Standart function       | Function of IniUnicode           |
| ----------------------- | -------------------------------- |
| `IniDelete()`           | `_IniUnicode_Delete()`           |
| `IniRead()`             | `_IniUnicode_Read()`             |
| `IniReadSection()`      | `_IniUnicode_ReadSection()`      |
| `IniReadSectionNames()` | `_IniUnicode_ReadSectionNames()` |
| `IniRenameSection()`    | `_IniUnicode_RenameSection()`    |
| `IniWrite()`            | `_IniUnicode_Write()`            |
| `IniWriteSection()`     | `_IniUnicode_WriteSection()`     |

## Compatibility and testing

Information about versions and tested compatibility is available at the beginning of the source code files in comments.

If you plan to use IniUnicode with a version of AutoIt whose compatibility with the library is unknown, you can use the automatic functional tests in the 'tests' folder to check compatibility.
