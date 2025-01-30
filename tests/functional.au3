; The file encoding is UTF-8 with BOM; the newline format is CR+LF
; Script file with functional tests
; Copyright (c) 2025 Nikita Tseykovets <tseikovets@rambler.ru>
; SPDX-License-Identifier: MIT
; Script is developed and debugged based on AutoIt v3.3.16.1

#include "common.au3"
#include "..\IniUnicode.au3"

Global Const $g_sIniFilePath = @ScriptDir & "\functional.ini"
Global Const _
	$g_sSection1 = "Первая секция", _
	$g_sSection2 = "Вторая секция", _
	$g_sKey1 = "Первый ключ", _
	$g_sKey2 = "Второй ключ", _
	$g_sValue1 = "Первое значение", _
	$g_sValue2 = "Второе значение"
Global $g_sIniReference = GetIniReference()

Functional()

Func Functional()
	Local $aTests[7] = ["Delete", "Read", "ReadSection", "ReadSectionNames", "RenameSection", "Write", "WriteSection"]

	Local $sReport = ""
	Local $bResult
	Local $iFailed = 0

	For $sTest In $aTests
		$sReport &= $sTest & ": "
		$bResult = Call($sTest)
		If $bResult Then
			$sReport &= "Passed"
		Else
			$sReport &= "Failed"
			$iFailed += 1
		EndIf
		$sReport &= @CRLF
	Next
	FileDelete($g_sIniFilePath)

	ReportFormat($sReport, UBound($aTests), $iFailed)
	ReportShow("Functional tests", $sReport, $iFailed)
EndFunc

Func GetIniReference()
	Local $sIniSectionTemplate = "%s=%s\r\n%s=%s"
	Local $sIniContentTemplate = "[%s]\r\n%s\r\n[%s]\r\n%s\r\n"
	Local $sSection = StringFormat($sIniSectionTemplate, $g_sKey1, $g_sValue1, $g_sKey2, $g_sValue2)
	Local $sIniContent = StringFormat($sIniContentTemplate, $g_sSection1, $sSection, $g_sSection2, $sSection)
	Return $sIniContent
EndFunc

Func CreateIniFile()
	Local $hFile = FileOpen($g_sIniFilePath, $FO_OVERWRITE + $FO_UTF8_NOBOM)
	FileWrite($hFile, $g_sIniReference)
	FileClose($hFile)
EndFunc

Func GetIniContent()
	Local $hIniFile = FileOpen($g_sIniFilePath, $FO_READ + $FO_UTF8_NOBOM)
	Local $sIniContent = FileRead($hIniFile)
	FileClose($hIniFile)
	Return $sIniContent
EndFunc

Func Delete()
	CreateIniFile()
	IniDelete($g_sIniFilePath, $g_sSection1)
	If UBound(IniReadSectionNames($g_sIniFilePath)) <> 3 Then Return False
	_IniUnicode_Delete($g_sIniFilePath, $g_sSection1)
	If UBound(_IniUnicode_ReadSectionNames($g_sIniFilePath)) <> 2 Then Return False
	Local $sIniReference = StringFormat("[%s]\r\n%s=%s\r\n", $g_sSection2, $g_sKey2, $g_sValue2)
	IniDelete($g_sIniFilePath, $g_sSection2, $g_sKey1)
	If $sIniReference == GetIniContent() Then Return False
	_IniUnicode_Delete($g_sIniFilePath, $g_sSection2, $g_sKey1)
	If Not ($sIniReference == GetIniContent()) Then Return False
	Return True
EndFunc

Func Read()
	CreateIniFile()
	Local Const $sDefault = "Значение по умолчанию"
	Local $sValue
	$sValue = IniRead($g_sIniFilePath, $g_sSection1, $g_sKey1, $sDefault)
	If $sValue == $g_sValue1 Then Return False
	$sValue = _IniUnicode_Read($g_sIniFilePath, $g_sSection1, $g_sKey1, $sDefault)
	If Not ($sValue == $g_sValue1) Then Return False
	$sValue = _IniUnicode_Read($g_sIniFilePath, $g_sSection1, $g_sSection1, $sDefault)
	If Not ($sValue == $sDefault) Then Return False
	Return True
EndFunc

Func ReadSection()
	CreateIniFile()
	IniReadSection($g_sIniFilePath, $g_sSection1)
	If Not @error Then Return False
	Local $aSection = _IniUnicode_ReadSection($g_sIniFilePath, $g_sSection1)
	If @error Then Return False
	If Not ($aSection[1][0] == $g_sKey1) Then Return False
	If Not ($aSection[1][1] == $g_sValue1) Then Return False
	Return True
EndFunc

Func ReadSectionNames()
	CreateIniFile()
	Local $aSections
	$aSections = IniReadSectionNames($g_sIniFilePath)
	If $aSections[1] == $g_sSection1 Then Return False
	$aSections = _IniUnicode_ReadSectionNames($g_sIniFilePath)
	If Not ($aSections[1] == $g_sSection1) Then Return False
	Return True
EndFunc

Func RenameSection()
	CreateIniFile()
	Local Const $sNewSection = "Новая секция"
	Local $sIniReference = StringReplace($g_sIniReference, $g_sSection2, $sNewSection, 1)
	Local $iResult
	$iResult = IniRenameSection($g_sIniFilePath, $g_sSection2, $sNewSection)
	If $iResult Then Return False
	_IniUnicode_RenameSection($g_sIniFilePath, $g_sSection2, $sNewSection)
	If Not ($sIniReference == GetIniContent()) Then Return False
	IniRenameSection($g_sIniFilePath, $g_sSection1, $sNewSection, $FC_NOOVERWRITE)
	If @error Then Return False
	_IniUnicode_RenameSection($g_sIniFilePath, $g_sSection1, $sNewSection, $FC_NOOVERWRITE)
	If Not @error Then Return False
	$iResult = IniRenameSection($g_sIniFilePath, $g_sSection1, $sNewSection, $FC_OVERWRITE)
	If $iResult Then Return False
	_IniUnicode_RenameSection($g_sIniFilePath, $g_sSection1, $sNewSection, $FC_OVERWRITE)
	$sIniReference = StringFormat("[%s]\r\n%s=%s\r\n%s=%s\r\n", $sNewSection, $g_sKey1, $g_sValue1, $g_sKey2, $g_sValue2)
	If Not ($sIniReference == GetIniContent()) Then Return False
	Return True
EndFunc

Func Write()
	Local $sIniReference = StringFormat("[%s]\r\n%s=%s\r\n", $g_sSection1, $g_sKey1, $g_sValue1)
	FileDelete($g_sIniFilePath)
	IniWrite($g_sIniFilePath, $g_sSection1, $g_sKey1, $g_sValue1)
	If $sIniReference == GetIniContent() Then Return False
	FileDelete($g_sIniFilePath)
	_IniUnicode_Write($g_sIniFilePath, $g_sSection1, $g_sKey1, $g_sValue1)
	If Not ($sIniReference == GetIniContent()) Then Return False
	Return True
EndFunc

Func WriteSection()
	Local $sData = $g_sKey1 & "=" & $g_sValue1
	Local $aData[2][2] = [[1, ""], [$g_sKey1, $g_sValue1]]
	Local $sIniReference = StringFormat("[%s]\r\n%s=%s\r\n", $g_sSection1, $g_sKey1, $g_sValue1)
	FileDelete($g_sIniFilePath)
	IniWriteSection($g_sIniFilePath, $g_sSection1, $sData)
	If $sIniReference == GetIniContent() Then Return False
	FileDelete($g_sIniFilePath)
	_IniUnicode_WriteSection($g_sIniFilePath, $g_sSection1, $sData)
	If Not ($sIniReference == GetIniContent()) Then Return False
	FileDelete($g_sIniFilePath)
	IniWriteSection($g_sIniFilePath, $g_sSection1, $aData)
	If $sIniReference == GetIniContent() Then Return False
	FileDelete($g_sIniFilePath)
	_IniUnicode_WriteSection($g_sIniFilePath, $g_sSection1, $aData)
	If Not ($sIniReference == GetIniContent()) Then Return False
	_IniUnicode_WriteSection($g_sIniFilePath, $g_sSection1, 0)
	If Not @error Then Return False
	Return True
EndFunc
