#NoEnv
SetBatchLines, -1
ListLines, Off
SetKeyDelay, -1, 110
SetTitleMatchMode, 2

global mouseControl := 0 ; 0 = off, 1 = on
toggleKey := "F12" ; Change this to your desired toggle key

; Toggle mouse control with the toggle key
Hotkey, %toggleKey%, toggleMouseControl
return

toggleMouseControl:
    mouseControl := !mouseControl
    if (mouseControl) {
        TrayTip, Mouse Control, Enabled, 1
    } else {
        TrayTip, Mouse Control, Disabled, 1
    }
return

; Arrow keys for mouse movement
#If (mouseControl)
    Up::MouseMove, 0, -10, 0, R
    Down::MouseMove, 0, 10, 0, R
    Left::MouseMove, -10, 0, 0, R
    Right::MouseMove, 10, 0, 0, R

    ; Holding Shift for faster movement
	+Up::MouseMove, 0, -75, 0, R
	+Down::MouseMove, 0, 75, 0, R
	+Left::MouseMove, -75, 0, 0, R
	+Right::MouseMove, 75, 0, 0, R

    ; Spacebar to simulate left mouse click
    Space::Click
#If
