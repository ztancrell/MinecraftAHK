#Requires AutoHotkey v1.1

; <Environment Setup>
#Persistent                  ; script will stay running after the auto-execute section (top part of the script) completes.
#NoEnv                       ; Recommended for performance and compatibility with future AutoHotkey releases.
SetTitleMatchMode, 2
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance Force        ; Ensures only one instance of the script is running.
#InstallMouseHook
DetectHiddenWindows on
DetectHiddenText on
Process, Priority, , High
SetControlDelay, -1
SetBatchLines, -1
SetWinDelay, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen
MouseMove, (A_ScreenWidth/2), (A_ScreenHeight/2)
; </Environment Setup>

; Developer :: Zach Tancrell <https://www.github.com/ztancrell>

; If not running as Admin, close non-Admin instance and relaunch as Admin.
if not A_IsAdmin
Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"

Loop,
{	Text1 = Pixel Found In Box `n%Color% Under Pointer
	Text2 = Searching In Box `n%Color% Under Pointer
	; LFColors, hex codes for the color in the deepslate ore textures. Used in finding on screen to mine.
	;
	; Lapis ore Colors - 0x092669|0x0d2f74|0x263d87|0x3a5295|0x0c2656|0x082260|0x0b2351|0x30457c
	; Redstone ore Colors - 0x770404|0x590202|0x770404|0x970000|0x640202|0x6d0303|0x473535|0x402e2f|0x412f30
	; Gold ore Colors - 0x35584c|0x8f4d3d|0x84442d|0x723d29|0x4c4c34|0x2b4a40
	; Iron ore colors - 0x857164|0x806757|0x6f5a4c|0x604f40|0x594a39
	; Coal ore Colors - 0x060606|0x0e0e0e|0x121212|0x161616|0x181818|0x202024|0x141414|0x222226|0x1c1c21
	; Copper ore colors - 0x284b40|0x723d29|0x4c4c34|0x84442d|0x8f4d3d
	; Diamond ore colors - 0x34667f|0x243539|0x2b3b3f|0x536e82|0x175d61|0x547083|0x6e7f8c|0x516c7f|0x70828f|0x526d80|0x32627a|0x316179|0x16595d|0x6d7f8b|0x516c7e|0x316078|0x33637c|0x2e5a70|0x2d596f
	; Emerald ore colors - 0x789184|0x1e7840|0x00490e
	LFColors := "0x092669|0x0d2f74|0x263d87|0x3a5295|0x0c2656|0x082260|0x0b2351|0x30457c|0x770404|0x590202|0x770404|0x970000|0x640202|0x6d0303|0x473535|0x402e2f|0x412f30|0x35584c|0x8f4d3d|0x84442d|0x723d29|0x4c4c34|0x2b4a40|0x857164|0x806757|0x6f5a4c|0x604f40|0x594a39|0x060606|0x0e0e0e|0x121212|0x161616|0x181818|0x202024|0x141414|0x222226|0x1c1c21|0x284b40|0x723d29|0x4c4c34|0x84442d|0x8f4d3d|0x34667f|0x243539|0x2b3b3f|0x536e82|0x175d61|0x547083|0x6e7f8c|0x516c7f|0x70828f|0x526d80|0x32627a|0x316179|0x16595d|0x6d7f8b|0x516c7e|0x316078|0x33637c|0x2e5a70|0x2d596f|0x789184|0x1e7840|0x00490e"
	Loop, Parse, LFColors, `|
	{	PixelSearch, X, Y, X1, Y1, X2, Y2, A_LoopField, 0, RGB, Fast
		If (!ErrorLevel)
		{	FrameColor := "Lime"
			GoSub, Box
			PixelGetColor, Color, X, Y, RGB
			ToolTip, %Text1%, (X-52), (Y+57), 1
			
			; Check for Minecraft window and hold down Left mouse to mine. Prevents the sript from causing chaos.
			if( not GetKeyState("LButton", "P")) 
			{
				wTitle = Minecraft
				Sleep, 500
				ControlClick, x-8 y-8, %wTitle%,,,, D
				Sleep, 1000
				ControlClick, X-8 Y-8, %wTitle%,,,, U
			}
			Break
		} Else,
		{	FrameColor := "Red"
			GoSub, Box
			PixelGetColor, Color, X, Y, RGB
			ToolTip, %Text2%, (X-58), (Y+57), 1
			Continue
		}	
	}	
} Return

; Draws a box around the cursor. Used to detect colors.
Box:
{	WinGetPos,,, WindowWidth, WindowHeight, %WinTitle%
	MouseGetPos, X, Y
	;	Uupper Left Corner		|	Lower Right Corner
	;	Left		   Top		|	Right		Bottom
	X1 := (X-50), Y1 := (Y-50), X2 := (X+50), Y2 := (Y+50) ;Adjust The Size of The Search Area/Box.
	FrameThickness := (1), FrameWidth := (X2-X1), FrameHeight := (Y2-Y1)
	Gui, 1: Margin, %FrameThickness%, %FrameThickness%
	Gui, 1: Color, %FrameColor%
	Gui, 1: Add, Text, W%FrameWidth% H%FrameHeight% 0x6
	Gui, 1: -Caption +AlwaysOnTop +ToolWindow +LastFound
	Gui, 1: Show, NoActivate, Gui1
	WinSet, TransColor, White
	WinMove, %WinTitle%,, (X-(WindowWidth/2)), (Y-(WindowHeight/2))
} Return

; ESC exits the script; incase things go wrong.
Esc::ExitApp