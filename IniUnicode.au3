; IniUnicode library v1.0
; Copyright (c) 2025 Nikita Tseykovets <tseikovets@rambler.ru>
; SPDX-License-Identifier: MIT

#include-once

#include <StringConstants.au3>

; #INDEX# =======================================================================================================================
; Title .........: IniUnicode
; AutoIt Version : 3.3.16.1
; Language ......: English
; Description ...: Unicode-enabled user defined functions (UDF) for working with standard format .ini files.
; Author(s) .....: Nikita Tseykovets
; Modifiers .....: 
; Link ..........: https://github.com/tseykovets/IniUnicode
; Dll ...........: 
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _IniUnicode_Delete
; _IniUnicode_Read
; _IniUnicode_ReadSection
; _IniUnicode_ReadSectionNames
; _IniUnicode_RenameSection
; _IniUnicode_Write
; _IniUnicode_WriteSection
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __IniUnicode_AnsiToUnicode
; __IniUnicode_UnicodeToAnsi
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: _IniUnicode_Delete
; Description ...: Deletes a value from a standard format .ini file. Supports Unicode in .ini file sections, keys and values.
; Syntax ........: _IniUnicode_Delete ( "filename", "section" [, "key"] )
; Parameters ....: filename - The filename of the .ini file.
;                  section - The section name in the .ini file.
;                  key - [optional] The key name in the .ini file to delete.
;                  + If the key name is not given the entire section is deleted. The Default keyword may also be used which will cause the section to be deleted.
; Return values .: Success - 1.
;                  Failure - 0 if the INI file does not exist or if the file is read-only.
; Author ........: Nikita Tseykovets
; Modified.......: 
; Remarks .......: This function copies the functionality of the standard IniDelete() function except for the addition
;                  Unicode enabling. See the AutoIt documentation for the IniDelete() function for more information.
;                  _IniUnicode_Delete() function are always slower and create more CPU load than the standard
;                  IniDelete() for working with standard format .ini files. This is true even for working with strings
;                  consisting only of ASCII characters.
; Related .......: _IniUnicode_Read, _IniUnicode_ReadSection, _IniUnicode_ReadSectionNames, _IniUnicode_RenameSection,
;                  _IniUnicode_Write, _IniUnicode_WriteSection
; Link ..........: 
; Example .......: Yes
; ===============================================================================================================================
Func _IniUnicode_Delete($sFile, $sSectionUnicode, $sKeyUnicode = Default)
	Local $sSectionAnsi = __IniUnicode_UnicodeToAnsi($sSectionUnicode)
	Local $sKeyAnsi
	If $sKeyUnicode = Default Then
		$sKeyAnsi = $sKeyUnicode
	Else
		$sKeyAnsi = __IniUnicode_UnicodeToAnsi($sKeyUnicode)
	EndIf
	Return IniDelete($sFile, $sSectionAnsi, $sKeyAnsi)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IniUnicode_Read
; Description ...: Reads a value from a standard format .ini file. Supports Unicode in .ini file sections, keys and values.
; Syntax ........: _IniUnicode_Read ( "filename", "section", "key", "default" )
; Parameters ....: filename - The filename of the .ini file.
;                  section - The section name in the .ini file.
;                  key - The key name in the .ini file.
;                  default - The default value to return if the requested key is not found.
; Return values .: Success - the requested key value as a string.
;                  Failure - the default string if requested key not found.
; Author ........: Nikita Tseykovets
; Modified.......: 
; Remarks .......: This function copies the functionality of the standard IniRead() function except for the addition
;                  Unicode enabling. See the AutoIt documentation for the IniRead() function for more information.
;                  _IniUnicode_Read() function are always slower and create more CPU load than the standard
;                  IniRead() for working with standard format .ini files. This is true even for working with strings
;                  consisting only of ASCII characters.
; Related .......: _IniUnicode_Delete, _IniUnicode_ReadSection, _IniUnicode_ReadSectionNames, _IniUnicode_RenameSection,
;                  _IniUnicode_Write, _IniUnicode_WriteSection
; Link ..........: 
; Example .......: Yes
; ===============================================================================================================================
Func _IniUnicode_Read($sFile, $sSectionUnicode, $sKeyUnicode, $sDefaultUnicode)
	Local $sSectionAnsi = __IniUnicode_UnicodeToAnsi($sSectionUnicode)
	Local $sKeyAnsi = __IniUnicode_UnicodeToAnsi($sKeyUnicode)
	Local $sDefaultAnsi = __IniUnicode_UnicodeToAnsi($sDefaultUnicode)
	Local $sValueAnsi = IniRead($sFile, $sSectionAnsi, $sKeyAnsi, $sDefaultAnsi)
	Local $sValueUnicode = __IniUnicode_AnsiToUnicode($sValueAnsi)
	Return $sValueUnicode
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IniUnicode_ReadSection
; Description ...: Reads all key/value pairs from a section in a standard format .ini file. Supports Unicode in .ini file
;                  sections, keys and values.
; Syntax ........: _IniUnicode_ReadSection ( "filename", "section" )
; Parameters ....: filename - The filename of the .ini file.
;                  section - The section name in the .ini file.
; Return values .: Success - a 2 dimensional array where element[n][0] is the key and element[n][1] is the value.
;                  Failure - sets the @error flag to non-zero if unable to read the section
;                  + (The INI file may not exist or the section may not exist or is empty).
; Author ........: Nikita Tseykovets
; Modified.......: 
; Remarks .......: This function copies the functionality of the standard IniReadSection() function except for the addition
;                  Unicode enabling. See the AutoIt documentation for the IniReadSection() function for more information.
;                  _IniUnicode_ReadSection() function are always slower and create more CPU load than the standard
;                  IniReadSection() for working with standard format .ini files. This is true even for working with strings
;                  consisting only of ASCII characters.
;                  The standard IniReadSection() function reads only the first 32767 bytes of a section content for legacy
;                  reasons. This limit also applies to the library's _IniUnicode_ReadSection() function. But keep in mind that
;                  non-ASCII characters in UTF-8 encoding take up from 2 to 4 bytes, so the maximum allowed size of the section
;                  contents with non-ASCII characters in UTF-8 will accommodate fewer characters than with ASCII characters
;                  in UTF-8 or standard ANSI text.
; Related .......: _IniUnicode_Delete, _IniUnicode_Read, _IniUnicode_ReadSectionNames, _IniUnicode_RenameSection,
;                  _IniUnicode_Write, _IniUnicode_WriteSection
; Link ..........: 
; Example .......: Yes
; ===============================================================================================================================
Func _IniUnicode_ReadSection($sFile, $sSectionUnicode)
	Local $sSectionAnsi = __IniUnicode_UnicodeToAnsi($sSectionUnicode)
	Local $vData = IniReadSection($sFile, $sSectionAnsi)
	If @error Then Return SetError(@error, Default, $vData)
	For $i = 1 To $vData[0][0]
		$vData[$i][0] = __IniUnicode_AnsiToUnicode($vData[$i][0])
		$vData[$i][1] = __IniUnicode_AnsiToUnicode($vData[$i][1])
	Next
	Return $vData
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IniUnicode_ReadSectionNames
; Description ...: Reads all sections in a standard format .ini file. Supports Unicode in .ini file sections, keys and values.
; Syntax ........: _IniUnicode_ReadSectionNames ( "filename" )
; Parameters ....: filename - The filename of the .ini file.
; Return values .: Success - an array of all section names in the INI file.
;                  Failure - sets the @error flag to non-zero.
; Author ........: Nikita Tseykovets
; Modified.......: 
; Remarks .......: This function copies the functionality of the standard IniReadSectionNames() function except for the addition
;                  Unicode enabling. See the AutoIt documentation for the IniReadSectionNames() function for more information.
;                  _IniUnicode_ReadSectionNames() function are always slower and create more CPU load than the standard
;                  IniReadSectionNames() for working with standard format .ini files. This is true even for working with strings
;                  consisting only of ASCII characters.
; Related .......: _IniUnicode_Delete, _IniUnicode_Read, _IniUnicode_ReadSection, _IniUnicode_RenameSection,
;                  _IniUnicode_Write, _IniUnicode_WriteSection
; Link ..........: 
; Example .......: Yes
; ===============================================================================================================================
Func _IniUnicode_ReadSectionNames($sFile)
	Local $vSectionNames = IniReadSectionNames($sFile)
	If @error Then Return SetError(@error, Default, $vSectionNames)
	For $i = 1 To $vSectionNames[0]
		$vSectionNames[$i] = __IniUnicode_AnsiToUnicode($vSectionNames[$i])
	Next
	Return $vSectionNames
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IniUnicode_RenameSection
; Description ...: Renames a section in a standard format .ini file. Supports Unicode in .ini file sections, keys and values.
; Syntax ........: _IniUnicode_RenameSection ( "filename", "section", "new section" [, flag = 0] )
; Parameters ....: filename - The filename of the .ini file.
;                  section - The section name in the .ini file.
;                  new section - The new section name.
;                  flag - [optional]
;                  |     $FC_NOOVERWRITE(0) = (default) Fail if "new section" already exists.
;                  |     $FC_OVERWRITE(1) = Overwrite "new section". This will erase any existing keys in "new section".
;                  | Constants are defined in FileConstants.au3.
; Return values .: Success - Non-zero.
;                  Failure - 0 and may sets the @error flag to non-zero, if renaming failed because the section already exists
;                  + (only when flag = 0).
; Author ........: Nikita Tseykovets
; Modified.......: 
; Remarks .......: This function copies the functionality of the standard IniRenameSection() function except for the addition
;                  Unicode enabling. See the AutoIt documentation for the IniRenameSection() function for more information.
;                  _IniUnicode_RenameSection() function are always slower and create more CPU load than the standard
;                  IniRenameSection() for working with standard format .ini files. This is true even for working with strings
;                  consisting only of ASCII characters.
; Related .......: _IniUnicode_Delete, _IniUnicode_Read, _IniUnicode_ReadSection, _IniUnicode_ReadSectionNames,
;                  _IniUnicode_Write, _IniUnicode_WriteSection
; Link ..........: 
; Example .......: Yes
; ===============================================================================================================================
Func _IniUnicode_RenameSection($sFile, $sSectionUnicode, $sNewSectionUnicode, $iFlag = Default)
	Local $sSectionAnsi = __IniUnicode_UnicodeToAnsi($sSectionUnicode)
	Local $sNewSectionAnsi = __IniUnicode_UnicodeToAnsi($sNewSectionUnicode)
	Local $iResult = IniRenameSection($sFile, $sSectionAnsi, $sNewSectionAnsi, $iFlag)
	Return SetError(@error, Default, $iResult)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IniUnicode_Write
; Description ...: Writes a value to a standard format .ini file. Supports Unicode in .ini file sections, keys and values.
; Syntax ........: _IniUnicode_Write ( "filename", "section", "key", "value" )
; Parameters ....: filename - The filename of the .ini file.
;                  section - The section name in the .ini file.
;                  key - The key name in the .ini file.
;                  value - The value to write/change.
; Return values .: Success - 1.
;                  Failure - 0 if file is read-only.
; Author ........: Nikita Tseykovets
; Modified.......: 
; Remarks .......: This function copies the functionality of the standard IniWrite() function except for the addition
;                  Unicode enabling. See the AutoIt documentation for the IniWrite() function for more information.
;                  _IniUnicode_Write() function are always slower and create more CPU load than the standard
;                  IniWrite() for working with standard format .ini files. This is true even for working with strings
;                  consisting only of ASCII characters.
; Related .......: _IniUnicode_Delete, _IniUnicode_Read, _IniUnicode_ReadSection, _IniUnicode_ReadSectionNames,
;                  _IniUnicode_RenameSection, _IniUnicode_WriteSection
; Link ..........: 
; Example .......: Yes
; ===============================================================================================================================
Func _IniUnicode_Write($sFile, $sSectionUnicode, $sKeyUnicode, $sValueUnicode)
	Local $sSectionAnsi = __IniUnicode_UnicodeToAnsi($sSectionUnicode)
	Local $sKeyAnsi = __IniUnicode_UnicodeToAnsi($sKeyUnicode)
	Local $sValueAnsi = __IniUnicode_UnicodeToAnsi($sValueUnicode)
	Return IniWrite($sFile, $sSectionAnsi, $sKeyAnsi, $sValueAnsi)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IniUnicode_WriteSection
; Description ...: Writes a section to a standard format .ini file. Supports Unicode in .ini file sections, keys and values.
; Syntax ........: _IniUnicode_WriteSection ( "filename", "section", "data" [, index = 1] )
; Parameters ....: filename - The filename of the .ini file.
;                  section - The section name in the .ini file.
;                  data - The data to write. The data can either be a string or an array. If the data is a string,
;                  + then each key=value pair must be delimited by @LF. If the data is an array, the array must be 2-dimensional
;                  + and the second dimension must be 2 elements.
;                  index - [optional] If an array is passed as data, this specifies the index to start writing from.
;                  + By default, this is 1 so that the return value of _IniUnicode_ReadSection() can be used immediately.
;                  + For manually created arrays, this value may need to be different depending on how the array was created.
;                  + This parameter is ignored if a string is passed as data.
; Return values .: Success - 1.
;                  Failure - 0. The function will sets the @error flag to 1 if the data format is invalid.
; Author ........: Nikita Tseykovets
; Modified.......: 
; Remarks .......: This function copies the functionality of the standard IniWriteSection() function except for the addition
;                  Unicode enabling. See the AutoIt documentation for the IniWriteSection() function for more information.
;                  _IniUnicode_WriteSection() function are always slower and create more CPU load than the standard
;                  IniDelete() for working with standard format .ini files. This is true even for working with strings
;                  consisting only of ASCII characters.
; Related .......: _IniUnicode_Delete, _IniUnicode_Read, _IniUnicode_ReadSection, _IniUnicode_ReadSectionNames,
;                  _IniUnicode_RenameSection, _IniUnicode_Write
; Link ..........: 
; Example .......: Yes
; ===============================================================================================================================
Func _IniUnicode_WriteSection($sFile, $sSectionUnicode, $vData, $iIndex = Default)
	If $iIndex = Default Then $iIndex = 1
	Local $sSectionAnsi = __IniUnicode_UnicodeToAnsi($sSectionUnicode)
	If IsArray($vData) Then
		For $i = $iIndex To $vData[0][0]
			$vData[$i][0] = __IniUnicode_UnicodeToAnsi($vData[$i][0])
			$vData[$i][1] = __IniUnicode_UnicodeToAnsi($vData[$i][1])
		Next
	Else
		; Self-handling of the error is required
		; because due to implicit type conversion in
		; the __IniUnicode_UnicodeToAnsi() function, handling of the data
		; type error in the IniWriteSection() function is not possible.
		If Not IsString($vData) Then Return SetError(1, Default, 0)
		$vData = __IniUnicode_UnicodeToAnsi($vData)
	EndIf
	Local $iResult = IniWriteSection($sFile, $sSectionAnsi, $vData, $iIndex)
	Return SetError(@error, Default, $iResult)
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __IniUnicode_AnsiToUnicode
; Description ...: Converts an Ansi-encoded string to an UTF-8-encoded string.
; Syntax.........: __IniUnicode_AnsiToUnicode ( "string" )
; Parameters ....: string - A string in Ansi encoding.
; Return values .: Returns a string in UTF-8 encoding.
; Author ........: Nikita Tseykovets
; Modified.......: 
; Remarks .......: Requires an included StringConstants.au3.
; Related .......: __IniUnicode_UnicodeToAnsi
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func __IniUnicode_AnsiToUnicode($sString)
	If StringIsASCII($sString) Then
		Return $sString
	Else
		Return BinaryToString(StringToBinary($sString, $SB_ANSI), $SB_UTF8)
	EndIf
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __IniUnicode_UnicodeToAnsi
; Description ...: Converts an UTF-8-encoded string to an Ansi-encoded string.
; Syntax.........: __IniUnicode_UnicodeToAnsi ( "string" )
; Parameters ....: string - A string in UTF-8 encoding.
; Return values .: Returns a string in Ansi encoding.
; Author ........: Nikita Tseykovets
; Modified.......: 
; Remarks .......: Requires an included StringConstants.au3.
; Related .......: __IniUnicode_AnsiToUnicode
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func __IniUnicode_UnicodeToAnsi($sString)
	If StringIsASCII($sString) Then
		Return $sString
	Else
		Return BinaryToString(StringToBinary($sString, $SB_UTF8), $SB_ANSI)
	EndIf
EndFunc
