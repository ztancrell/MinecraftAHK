#Requires AutoHotkey v2.0
#SingleInstance Force              ; Ensures only one instance of the script is running.

; <Environment Setup>
Persistent                         ; script will stay running after the auto-execute section (top part of the script) completes.
SetTitleMatchMode 2                ; Sets the matching behavior of the WinTitle parameter in built-in functions such as WinWait.
SetWorkingDir A_InitialWorkingDir  ; Ensures a consistent starting directory.
InstallMouseHook                   ; Installs the mouse hook 
DetectHiddenWindows True           ; Determines whether invisible windows are "seen" by the script.
DetectHiddenText True              ; Determines whether invisible text in a window is "seen" for the purpose of finding the window
; </Environment Setup>

CheckAdmin() ; checks for admin, relaunches if not.

; Global variable for Minecraft title (easier to update)
Global wTitle := "Minecraft 1.20.2"

; Custom tray menu
Tray := A_TrayMenu
Tray.Delete() ; removes default tray entries
Tray.Add("About", About)

Info() ; display important info at script startup

; display quick help for users, remove notification
TrayTip "F4 -- Toggle Auto-Mine `nWindows Key + ESC -- terminates script", "Quick Help"
SetTimer () => HideTrayTip, -5000

; F4 hotkey to toggle auto mine
F4:: {
    Static toggle := False

    if (toggle := !toggle)
    {
        SetTimer(MineLoop, 1), MineLoop(), SoundBeep(1500)

        ToolTip "Auto-Mine Enabled"
        SetTimer(RemoveToolTip, -5000)
    } else {
        SetTimer(MineLoop, 0), SoundBeep(1000)

        ReleaseKey()

        ToolTip "Auto-Mine Disabled"
        SetTimer(RemoveToolTip, -5000)
    }
    RETURN
}

#ESC:: { ; Windows + ESC to kill script
    Exit
}

MineLoop()
{
    ;; only active auto mine on Minecraft window.
    ;; ControlClick allows for alt tabbing and using it in the background
    SetControlDelay -1
    ControlClick("x-8 y-8", wTitle,, "Left",, "D",,)
}
RETURN

/*
Functions & A_TrayMenu Handlers --- Start
*/
About(*) ; About message handler for A_TrayMenu
{
    MsgBox "
    (
        `t`t======= About =======
        
        Developer :: Zach Tancrell <https://www.github.com/ztancrell>
        Script Created :: Sometime in 2019
        Motivation :: I made this script because I wanted to AFK Mine on a skyblock Minecraft server. :)
    )"
}

Info() ; Function for displaying important info at script startup
{
    MsgBox "
    (
        ======= Important Information =======

        This script requires you to disable the "Pause on Lost Focus" in Minecraft - Press F3 + P until it says disabled. 
        
        You need to ALT+TAB in order to navigate to other opened applications (browser, Discord, etc).
    )", "Startup Info", "" ; iconi
}

Exit()
{
    ExitApp
}

; https://www.autohotkey.com/docs/v2/lib/TrayTip.htm#Hiding_the_Traytip
HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        A_IconHidden := true
        Sleep 200  ; It may be necessary to adjust this sleep.
        A_IconHidden := false
    }
}

RemoveToolTip()
{
    ToolTip
}

ReleaseKey()
{
    ControlClick("x-8 y-8", wTitle,, "Left",, "U",,)
}

CheckAdmin()
{
    ; If not running as Admin, close non-Admin instance and relaunch as Admin.
    ; https://www.autohotkey.com/docs/v2/lib/Run.htm#RunAs
    full_command_line := DllCall("GetCommandLine", "str")
    if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
    {
        try
        {
            if A_IsCompiled
                Run '*RunAs "' A_ScriptFullPath '" /restart'
            else
                Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
        }
        ExitApp
    }
}
/*
Functions & A_TrayMenu Handlers --- End
*/