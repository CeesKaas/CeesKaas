#Requires AutoHotkey v2.0
#SingleInstance force

 

^RButton:: {
    toSend := "{blind#^!+}"
    Loop Parse A_Clipboard
    {
        if (InStr("abcdefghijklmnopqrstuvwxyz0123456789;'[],./``-= ", A_LoopField, true) > 0)
        {
            ;msgBox "plain lower case or lower case special char '" . A_LoopField . "'"
            toSend := toSend . A_LoopField
        }
        else 
	{
            if (InStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", A_LoopField, true) > 0)
            {
                ;msgBox "plain upper case '" . A_LoopField . "'"
                toSend := toSend . "{Shift Down}" . StrLower(A_LoopField) . "{Shift Up}"
            }
            else 
	    {
                specialCharPos := InStr(")!@#$%^&*(", A_LoopField, true)
                if (specialCharPos > 0)
                {
                    ;msgBox "plain upper case number'" . A_LoopField . "' becomes '" . specialCharPos-1 . "'"
                    toSend := toSend . "{Shift Down}" . specialCharPos-1 . "{Shift Up}"
                }
                else 
		{
                    moreSpecialCharPos := InStr(":`"{}<>?~_+", A_LoopField, true)
                    moreSpecialChars := [";","'","[","]",",",".","/","``","-","="]
                    if (moreSpecialCharPos > 0)
                    {
                        ;msgBox "plain upper case special char'" . A_LoopField . "' becomes '" . moreSpecialChars[moreSpecialCharPos] . "'"
                        toSend := toSend . "{Shift Down}" . moreSpecialChars[moreSpecialCharPos] . "{Shift Up}"
                    }
                }
            }
        }
    }
    toSend := StrReplace(toSend, "{Shift Up}{Shift Down}")
    ;msgBox toSend
    ; Select VM

    If (WinActive("ahk_class VMPlayerFrame"))
    {
        SendInput("^g")
        Sleep 300
    }

    ; Paste content
    SendInput(toSend)
}
