﻿; The file encoding is UTF-8 with BOM
; This is a modified example from the AutoIt v3.3.16.1 documentation. See EULA_for_AutoIt.txt file for licensing information.

#include <IniUnicode.au3>

#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

AutoItSetOption("MustDeclareVars", 1) ; All variables must be pre-declared

Example()

Func Example()
	; Create a constant variable in Local scope of the filepath that will be read/written to.
	Local Const $sFilePath = _WinAPI_GetTempFileName(@TempDir)

	; Create an INI section structure as an array. The zeroth element is how many items are in the array, in this case 3.
	Local $aSection[4][2] = [[3, ""], ["Ключ1", "Значение1"], ["Ключ2", "Значение2"], ["Ключ3", "Значение3"]]

	; Write the array to the section labelled 'Секция'.
	_IniUnicode_WriteSection($sFilePath, "Секция", $aSection)

	; Read the INI section labelled 'Секция'. This will return a 2 dimensional array.
	Local $aArray = _IniUnicode_ReadSection($sFilePath, "Секция")

	; Check if an error occurred.
	If Not @error Then
		; Enumerate through the array displaying the keys and their respective values.
		For $i = 1 To $aArray[0][0]
			MsgBox($MB_SYSTEMMODAL, "", "Key: " & $aArray[$i][0] & @CRLF & "Value: " & $aArray[$i][1])
		Next
	EndIf

	; Delete the INI file.
	FileDelete($sFilePath)
EndFunc   ;==>Example
