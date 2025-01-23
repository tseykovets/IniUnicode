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

	; Write the value of 'Значение' to the key 'Ключ' and in the section labelled 'Секция'.
	_IniUnicode_Write($sFilePath, "Секция", "Ключ", "Значение")

	; Read the INI file for the value of 'Ключ' in the section labelled 'Секция'.
	Local $sRead = _IniUnicode_Read($sFilePath, "Секция", "Ключ", "Значение по умолчанию")

	; Display the value returned by _IniUnicode_Read.
	MsgBox($MB_SYSTEMMODAL, "", "The value of 'Ключ' in the section labelled 'Секция' is: " & $sRead)

	; Delete the key labelled 'Ключ'.
	_IniUnicode_Delete($sFilePath, "Секция", "Ключ")

	; Read the INI file for the value of 'Ключ' in the section labelled 'Секция'.
	$sRead = _IniUnicode_Read($sFilePath, "Секция", "Ключ", "Значение по умолчанию")

	; Display the value returned by _IniUnicode_Read. Since there is no key stored the value will be the 'Значение по умолчанию' passed to _IniUnicode_Read.
	MsgBox($MB_SYSTEMMODAL, "", "The value of 'Ключ' in the section labelled 'Секция' is: " & $sRead)

	; Delete the INI file.
	FileDelete($sFilePath)
EndFunc   ;==>Example
