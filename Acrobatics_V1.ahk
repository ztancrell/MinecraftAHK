#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Developer :: Zach Tancrell <https://www.github.com/ztancrell>

`::

Loop, 100 {
    Send t
    Sleep 100
    Send /home a{Enter}

    Send {W down}
    Sleep 1000
    Send {W up}

    Sleep 11750
}

^N::
    ExitApp ; Ctrl+M - Avoid the script from fucking up my computer.
RETURN