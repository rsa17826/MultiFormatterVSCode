; @name format includes
; @regex ^(#\w+ .*\n)\n+(#)
; @flags gim
; @untilfail
; @replace $1$2
; @endregex
; @regex ^#include .*(?=\n\w)
; @flags gim
; @replace $&
;
; @endregex

; @name max newlines
; @regex ^\n{3,}
; @flags gim
; @full
; @replace
;
;
; @endregex

; @name seperate different regexes
; @regex ( *)(;.*)\n(\1; @name)
; @full
; @replace $1$2
;
; $3
; @endregex

#Requires AutoHotkey v2.0
#SingleInstance Force

SetWorkingDir(A_ScriptDir)
#Include *i <AutoThemed>
#Include <vars>
#Include <base>
#Include <Misc>

data := JSON.parse(f.read("package.json"), , 0)
data.version := data.version.split(".").map((e, i) => i == 1 ? e + 1 : '0').join(".")
f.write("package.json", JSON.stringify(data))
cmd := "powershell.exe -command `"npm run compile; echo y | npx vsce package --allow-missing-repository"
if (RunWait(cmd "`"", A_ScriptDir, "hide"))
  RunWait(cmd "; pause`"", A_ScriptDir)
DirCreate("vsix")
FileMove('*.vsix', "vsix")