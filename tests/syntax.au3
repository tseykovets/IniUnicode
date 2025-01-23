; The file encoding is UTF-8 with BOM; the newline format is CR+LF
; Script file with syntax tests
; Copyright (c) 2025 Nikita Tseykovets <tseikovets@rambler.ru>
; SPDX-License-Identifier: MIT
; Script is developed and debugged based on AutoIt v3.3.16.1

#include <File.au3>

#include "common.au3"

Syntax()

Func Syntax()
	Local $aAu3Files = _FileListToArrayRec($g_sProjectFolder, "*.au3", _
		$FLTAR_FILES, _ ; Return files only
		$FLTAR_RECUR, _ ; Search in all subfolders (unlimited recursion)
		$FLTAR_NOSORT, _ ; Not sorted
		$FLTAR_RELPATH _ ; Relative to initial path
	)
	If @error Then
		MsgBox($MB_ICONERROR, "Error", "No *.au3 files found for syntax checking.")
		Exit 1
	EndIf

	Local $sReport = ""
	Local $sAu3Check = $g_sAutoItDir & "\Au3Check.exe"
	Local $iExitCode
	Local $iFailed = 0

	Local $sCommand = '"' & $sAu3Check & '" -q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7 -I "' & $g_sProjectFolder & '"'
	For $i = 1 To $aAu3Files[0]
		$sReport &= $aAu3Files[$i] & ": "
		$iExitCode = RunWait($sCommand & ' "' & $g_sProjectFolder & '\' & $aAu3Files[$i] & '"', _
		$g_sProjectFolder, @SW_HIDE)
		If $iExitCode Then
			$sReport &= "Failed"
			$iFailed += 1
		Else
			$sReport &= "Passed"
		EndIf
		$sReport &= @CRLF
	Next
	Local $iTotal = $i - 1

	ReportFormat($sReport, $iTotal, $iFailed)
	ReportShow("Syntax tests", $sReport, $iFailed)
EndFunc
