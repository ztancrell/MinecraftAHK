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
; </Environment Setup>

; If not running as Admin, close non-Admin instance and relaunch as Admin.
if not A_IsAdmin
Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"

Info()

Menu, Tray, NoStandard ; remove default tray menu entries
Menu, Tray, Add, About, About ; add a new tray menu entry
Menu, Tray, Add, Exit, Exit ; add another tray menu entry
Menu, Tray, Default, About ; When doubleclicking the tray icon, run the tray menu entry called "About".

About() {
    MsgBox, `t`t======= About =======`n`nDeveloper :: Zach Tancrell <https://www.github.com/ztancrell>`nScript Created :: Sometime in 2019 `n`nMotivation :: I made this script because I wanted to AFK Mine on a skyblock Minecraft server. :)
}

Info() {
    MsgBox, `t======= Important Information =======`n`nThis script requires you to disable the "Pause on Lost Focus" in Minecraft - Press F3 + P until it says disabled. You need to ALT+TAB in order to navigate to other opened applications (browser, Discord, etc).
}

Exit() {
    ExitApp
}

TrayTip, Quick Help, F4 -- Toggle Auto-Mine `nWindows Key + ESC -- terminates script
SetTimer, HideTrayTip, -5000

HideTrayTip() {
    TrayTip
}

; F4 hotkey to toggle auto mine
$F4::
    toggle := !toggle

    if (toggle)
    {
        SetTimer, mineLoop, On

        ToolTip, Auto-Mine Enabled
        SetTimer, RemoveToolTip, -5000
    } else {
        SetTimer, mineLoop, Off

        ToolTip, Auto-Mine Disabled
        SetTimer, RemoveToolTip, -5000
    }
RETURN

RemoveToolTip:
    ToolTip
RETURN

#ESC::
	ExitApp ; press windows key+ESC to exit the script.

mineLoop:
    if( not GetKeyState("LButton", "P")) 
    {
        ;; only active auto mine on Minecraft window.
        ;; ControlClick allows for alt tabbing and using it in the background
		wTitle = Minecraft
		ControlClick, x-8 y-8, %wTitle%,,,, D
		Sleep, 1000
		ControlClick, X-8 Y-8, %wTitle%,,,, U
    }
    RETURN
RETURN