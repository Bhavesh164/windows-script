#Requires AutoHotkey v2.0

; This script creates a new file in the current Explorer window using Alt+N
; and opens it in Notepad++ for editing.
; Modified for Windows 11 compatibility

; Get Explorer path using COM interface
GetExplorerPath() {
    explorerHwnd := WinExist("A")
    for window in ComObject("Shell.Application").Windows {
        try {
            if (window.HWND == explorerHwnd) {
                return window.Document.Folder.Self.Path
            }
        }
    }
    return ""
}

; Only run when Windows Explorer or Desktop is active
#HotIf WinActive("ahk_class CabinetWClass") or 
      WinActive("ahk_exe explorer.exe")

; Alt+N
!n::
{
    ; Get current explorer path
    FullPath := GetExplorerPath()
    if !FullPath {
        MsgBox("Could not determine current folder path.")
        return
    }

    ; Change working directory
    try {
        SetWorkingDir(FullPath)
    } catch {
        MsgBox("Failed to set working directory to: " FullPath)
        return
    }
    
    ; Display input box for filename
    try {
        UserInput := InputBox("New File", "Enter filename:", "w400 h100")
        if UserInput.Result = "Cancel"
            return
        
        if UserInput.Value = "" {
            MsgBox("Filename cannot be empty!")
            return
        }
        
        ; Create file
        FileAppend("", UserInput.Value)
        
        ; Open the file in Notepad++
        try {
            Run('"C:\Program Files\Notepad++\notepad++.exe" "' UserInput.Value '"')
        } catch {
            ; If Notepad++ fails to open, try the default notepad
            try {
                Run('notepad.exe "' UserInput.Value '"')
            } catch {
                MsgBox("Failed to open the file. The file was created but could not be opened.")
            }
        }
    } catch as err {
        MsgBox("An error occurred: " err.Message)
        return
    }
}

#HotIf
