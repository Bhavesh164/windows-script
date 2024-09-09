#Requires AutoHotkey v2.0

SetCapsLockState "AlwaysOff"

CapsLock::
{
    static key := ""
    
    ; Start capturing input
    ih := InputHook("L1 T1")
    ih.Start()
    ih.Wait()
    key := ih.Input

    ; Check if a key was pressed (not timed out)
    if (not ih.Timeout and key != "")
    {
        Send "{Ctrl Down}{" key "}"
        KeyWait "CapsLock"
        Send "{Ctrl Up}"
    }
    else
    {
        Send "{Ctrl Down}"
        KeyWait "CapsLock"
        Send "{Ctrl Up}"
    }
}

CapsLock up::
{
    if (A_PriorKey == "CapsLock" and A_TimeSinceThisHotkey < 200)
    {
        Send "{Esc 2}"
    }
}

; Enable Caps Lock with Shift+CapsLock
+CapsLock::
{
    SetCapsLockState !GetKeyState("CapsLock", "T")
}
