; The file encoding is UTF-8 with BOM
; This is a modified example from the AutoIt v3.3.16.1 documentation. See EULA_for_AutoIt.txt file for licensing information.

#include <IniUnicode.au3>

#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

AutoItSetOption("MustDeclareVars", 1) ; All variables must be pre-declared

Example()

Func Example()
	; Create a constant variable in Local scope of the filepath that will be read/written to.
	Local Const $sFilePath = _WinAPI_GetTempFileName(@TempDir)

	; Create an INI section structure as a string.
	Local $sSection = "Ключ1=Значение1" & @LF & "Ключ2=Значение2" & @LF & "Ключ3=Значение3"

	; Write the string to the sections labelled 'Секция1', 'Секция2' and 'Секция3'.
	_IniUnicode_WriteSection($sFilePath, "Секция1", $sSection)
	_IniUnicode_WriteSection($sFilePath, "Секция2", $sSection)
	_IniUnicode_WriteSection($sFilePath, "Секция3", $sSection)

	; Read the INI section names. This will return a 1 dimensional array.
	Local $aArray = _IniUnicode_ReadSectionNames($sFilePath)

	; Check if an error occurred.
	If Not @error Then
		; Enumerate through the array displaying the section names.
		For $i = 1 To $aArray[0]
			MsgBox($MB_SYSTEMMODAL, "", "Section: " & $aArray[$i])
		Next
	EndIf

	; Delete the INI file.
	FileDelete($sFilePath)
EndFunc   ;==>Example
