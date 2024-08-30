; <Environment Setup>
#Persistent                  ; script will stay running after the auto-execute section (top part of the script) completes.
#NoEnv                       ; Recommended for performance and compatibility with future AutoHotkey releases.
SetTitleMatchMode, 2
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance Force        ; Ensures only one instance of the script is running.
#InstallMouseHook
#MaxThreadsPerHotkey 2
; </Environment Setup>

; Developer :: Zach Tancrell <https://www.github.com/ztancrell>

$F6::
	toggle:=!toggle
	While toggle{
		wTitle = Minecraft
		ControlClick, x-8 y-8, %wTitle%,,,, D
		Sleep, 1000
		ControlClick, X-8 Y-8, %wTitle%,,,, U
		Sleep 625
	}
RETURN