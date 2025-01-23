; The file encoding is UTF-8 with BOM; the newline format is CR+LF
; Script file with global variables and common functions for other scripts
; Copyright (c) 2025 Nikita Tseykovets <tseikovets@rambler.ru>
; SPDX-License-Identifier: MIT
; Script is developed and debugged based on AutoIt v3.3.16.1

#include-once

#include <Date.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>

Global $g_sAutoItDir = FileGetFolder(@AutoItExe)
Global $g_sProjectFolder = FileGetFolder(@ScriptDir)

Func FileGetFolder($sFilePath)
	Local $iPosition = StringInStr($sFilePath, "\", $STR_NOCASESENSE, -1)
	Return StringLeft($sFilePath, $iPosition - 1)
EndFunc

Func ReportFormat(ByRef $sReport, $iTotal = 0, $iFailed = 0)
	If $iTotal = Default Then $iTotal = 0
	If $iFailed = Default Then $iFailed = 0

	Local $tTime = _Date_Time_GetLocalTime()
	$sReport = "Report from " _
	& _Date_Time_SystemTimeToDateTimeStr($tTime, 1) & @CRLF & @CRLF & $sReport

	If $iTotal Then
		$sReport &= @CRLF & "Total tests: " & $iTotal
		$sReport &= @CRLF & "Passed tests: " & $iTotal - $iFailed
		$sReport &= @CRLF & "Failed tests: " & $iFailed
	EndIf
EndFunc

Func ReportShow($sTitle, ByRef $sReport, $iFailed)
	Local $iFlag
	If $iFailed Then
		$iFlag = $MB_ICONERROR
	Else
		$iFlag = $MB_ICONINFORMATION
	EndIf

	Local $sMessage = $sReport & @CRLF & @CRLF _
	& "Do you want to save the report as a file next to the test script file?"

	$sTitle &= " (AutoIt v" & @AutoItVersion & ")"
	If MsgBox($MB_YESNOCANCEL + $iFlag, $sTitle, $sMessage) = $IDYES Then
		Local $sLog = StringLeft(@ScriptFullPath, StringInStr(@ScriptFullPath, ".")) & "log"
		Local $hLog = FileOpen($sLog, $FO_OVERWRITE + $FO_UTF8)
		FileWrite($hLog, $sTitle & @CRLF & $sReport)
		FileClose($hLog)
	EndIf
EndFunc
