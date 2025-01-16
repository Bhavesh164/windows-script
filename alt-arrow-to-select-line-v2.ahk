!Left::SelectLineLeft()
!Right::SelectLineRight()

SelectLineLeft() {
    Send("{Shift Down}") ; Hold Shift for selection
    Send("{Home}")       ; Move to the beginning of the line
    Send("{Shift Up}")   ; Release Shift
}

SelectLineRight() {
    Send("{Shift Down}") ; Hold Shift for selection
    Send("{End}")        ; Move to the end of the line
    Send("{Shift Up}")   ; Release Shift
}
