; The file encoding is UTF-8 with BOM; the newline format is CR+LF
; Script file with performance tests
; Copyright (c) 2025 Nikita Tseykovets <tseikovets@rambler.ru>
; SPDX-License-Identifier: MIT
; Script is developed and debugged based on AutoIt v3.3.16.1

#include "common.au3"
#include "..\IniUnicode.au3"

Global Const $g_sIniFilePath = @ScriptDir & "\performance.ini"
Global Const $g_iIterations = 1000
Global Const $g_iCharacters = 10

Performance()

Func Performance()
	Local $sReportTemplate = "%i iterations of reading strings (%i characters per string):"
	Local $sReport = StringFormat($sReportTemplate, $g_iIterations, $g_iCharacters)

	$sReportTemplate = "\r\n- %s characters using the %s: %f milliseconds"
	Local $fStdMS = WriteRead("R", False)
	$sReport &= StringFormat($sReportTemplate, "1-byte ASCII", "standart function", $fStdMS)

	$sReportTemplate &= " (%.f%% slower than standard function)"
	Local $fLibMS
	$fLibMS = WriteRead("R")
	$sReport &= StringFormat($sReportTemplate, "1-byte ASCII", "IniUnicode function", $fLibMS, Difference($fStdMS, $fLibMS))
	$fLibMS = WriteRead("Р")
	$sReport &= StringFormat($sReportTemplate, "2-byte UTF-8", "IniUnicode function", $fLibMS, Difference($fStdMS, $fLibMS))
	$fLibMS = WriteRead("₽")
	$sReport &= StringFormat($sReportTemplate, "3-byte UTF-8", "IniUnicode function", $fLibMS, Difference($fStdMS, $fLibMS))
	$fLibMS = WriteRead("𐞪")
	$sReport &= StringFormat($sReportTemplate, "4-byte UTF-8", "IniUnicode function", $fLibMS, Difference($fStdMS, $fLibMS))

	FileDelete($g_sIniFilePath)

	ReportFormat($sReport)
	ReportShow("Performance tests", $sReport, 0)
EndFunc

Func WriteRead($sChr, $bLib = True)
	If $bLib = Default Then $bLib = True
	Local $sString = ""
	For $i = 1 To $g_iCharacters
		$sString &= $sChr
	Next
	FileDelete($g_sIniFilePath)

	Local $hTimer, $fDiff
	If $bLib Then
		_IniUnicode_Write($g_sIniFilePath, $sString, $sString, $sString)
		$hTimer = TimerInit()
		For $i = 1 To $g_iIterations
			_IniUnicode_Read($g_sIniFilePath, $sString, $sString, $sString)
		Next
		$fDiff = TimerDiff($hTimer)
	Else
		IniWrite($g_sIniFilePath, $sString, $sString, $sString)
		$hTimer = TimerInit()
		For $i = 1 To $g_iIterations
			IniRead($g_sIniFilePath, $sString, $sString, $sString)
		Next
		$fDiff = TimerDiff($hTimer)
	EndIf
	Return $fDiff
EndFunc

Func Difference($fFirst, $fSecond)
	Return ($fSecond - $fFirst) / $fFirst * 100
EndFunc
