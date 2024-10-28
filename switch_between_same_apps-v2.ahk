#HotIf
!`:: {  ; Alt + `
    oldClass := WinGetClass("A")
    activeProcessName := WinGetProcessName("A")
    winClassCount := WinGetCount("ahk_exe " activeProcessName)
    
    if (winClassCount = 1)
        return

    loop 2 {
        WinMoveBottom("A")  ; WinSet, Bottom replaced with WinMoveBottom
        WinActivate("ahk_exe " activeProcessName)
        newClass := WinGetClass("A")
        if (oldClass != "CabinetWClass" or newClass = "CabinetWClass")
            break
    }
}
