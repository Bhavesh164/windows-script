; This is part of my AutoHotKey [1] script. When you are in Windows Explorer it
; allows you to press Alt+N and type a filename, and that file is created
; in the current directory and opened in the appropriate editor (usually
; [gVim](http://www.vim.org/) in my case, but it will use whatever program is
; associated with the file in Windows Explorer).

; This is much easier than the alternative that I have been using until now:
; Right click > New > Text file, delete default filename and extension (which
; isn't highlighted in Windows 7), type the filename, press enter twice.
; (Particularly for creating dot files like ".htaccess".)

; Credit goes to aubricus [2] who wrote most of this and davejamesmiller [3] who
; added the 'IfWinActive' check and 'Run %UserInput%' at the end. Also to 
; syon [4] who changed regexp to make script work on non-english versions
; of Windows. And I changed the way how script gets full path to make it
; compatible with Windows 10 and also changed hotkey to Alt+N

; [1]: http://www.autohotkey.com/
; [2]: https://gist.github.com/1148174
; [3]: https://gist.github.com/1965432
; [4]: https://github.com/syon/ahk/blob/master/NewFile/NewFile.ahk


; Only run when Windows Explorer or Desktop is active
; Alt+N
#IfWinActive ahk_class CabinetWClass
!SC031::
#IfWinActive ahk_class ExploreWClass
!SC031::
#IfWinActive ahk_class Progman
!SC031::
#IfWinActive ahk_class WorkerW
!SC031::

    ; Get full path from open Explorer window
    WinGetText, FullPath, A

    ; Split up result (it returns paths seperated by newlines)
    StringSplit, PathArray, FullPath, `n
	
	; Find line with backslash which is the path
	Loop, %PathArray0%
    {
        StringGetPos, pos, PathArray%a_index%, \
        if (pos > 0) {
            FullPath:= PathArray%a_index%
            break
        }
    }
	
    ; Clean up result
    FullPath := RegExReplace(FullPath, "(^.+?: )", "")
	StringReplace, FullPath, FullPath, `r, , all


    ; Change working directory
    SetWorkingDir, %FullPath%

    ; An error occurred with the SetWorkingDir directive
    If ErrorLevel
        Return

    ; Display input box for filename
    InputBox, UserInput, New File, , , 400, 100, , , , ,

    ; User pressed cancel
    If ErrorLevel
        Return

    ; Create file
    FileAppend, , %UserInput%

    ; Open the file in the appropriate editor
    ;Run %UserInput%
	
	; Create file
	FileAppend, , %UserInput%

	; Open the file in Notepad++
	Run, "C:\Program Files\Notepad++\notepad++.exe" "%UserInput%"

    Return

#IfWinActive