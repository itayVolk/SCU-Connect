#Requires AutoHotkey v2.0
#SingleInstance Force

SilentPopUp(text, time := 750) {
	g := Gui("+AlwaysOnTop +Disabled -SysMenu", "AHK status")
	g.SetFont("s20 w300")
	g.AddText("R1",text)
	g.Show("AutoSize Center NoActivate")
	Sleep time
	g.Destroy()
}

Setup() {
	global input := Gui(, "User info")
    input.SetFont("s10 w300")
	input.AddText("x10 r1 w150", "Email (no @scu.edu)")
    input.AddEdit("yp r1 w250 vEmail")
	input.AddText("x10 r1 w150", "Portal password")
    input.AddEdit("yp r1 w250 vPortal Password")
	input.AddText("x10 r1 w150", "Github username")
    input.AddEdit("yp r1 w250 vGit")
	input.AddText("x10 r1 w150", "Github token")
    input.AddEdit("yp r1 w250 vToken Password WantReturn")
    input.AddButton("x10 w405 +Default", "Submit").OnEvent("Click", Submit)
	input.OnEvent("Close", Close)
    input.Show("Center AutoSize")
}

Submit(GuiCtrlObj, *) {
	global
    submmited := GuiCtrlObj.Gui.Submit()
    email := submmited.Email
    portal := submmited.Portal
    git := submmited.Git
    token := submmited.Token
    IniWrite(email, mem, "Info", "email")
    IniWrite(portal, mem, "Info", "portal")
    IniWrite(git, mem, "Info", "git")
    IniWrite(token, mem, "Info", "token")
	GuiCtrlObj.Gui.Destroy()
	input := false
	SilentPopUp("Please select a link/exe to where you installed the VPN (cancel if you're not using the VPN)")
	link := FileSelect("33",, "Select cisco location", "*.*")
	IniWrite(link, mem, "Info", "link")
}

Close(*) {
	ExitApp()
}

global ahkName := SubStr(A_ScriptName, 1, -4)
global mem := ahkName . ".ini"
global email, portal, git, token, link
if FileExist(mem) {
    email := IniRead(mem, "Info", "email")
    portal := IniRead(mem, "Info", "portal")
    git := IniRead(mem, "Info", "git")
    token := IniRead(mem, "Info", "token")
	link := IniRead(mem, "Info", "link")
} else {
    Setup()
}

#^r::
#HotIf IsSet(email) && link
Connect(show := true) {
	Run(link)
	WinWait("Cisco Secure Client ahk_exe csc_ui.exe")
	WinActivate("Cisco Secure Client ahk_exe csc_ui.exe")
	if(InStr(WinGetText("A"), "Ready to")) {
		Send("{Tab}{Tab}{Enter}")
		WinWaitActive(" | vpn.scu.edu")
		SendText("Portal2024`n")
		SilentPopUp("Please authorize DUO mobile push to activate VPN")
	}
	else {
		Send("{Tab}{Enter}")
		if (show)
			SilentPopUp("VPN disconnected")
	}
	WinClose("Cisco Secure Client ahk_exe csc_ui.exe")
}
#^v:: {
	Connect()
}
#^+v:: {
	choice := MsgBox("Is VPN connected / are you on SCU wifi?", "VPN", 0x4)
	if (choice == "No") {
		Connect(false)
		choice := MsgBox("VPN connected?", "VPN", 0x4)
	}
	if (choice == "Yes") {
		if (!WinExist(email "@linux ahk_exe cmd.exe")) {
			Run(A_ComSpec " /c ssh " email "@linux.dc.engr.scu.edu")
			WinWait("ahk_exe cmd.exe")
			WinActivate("ahk_exe cmd.exe")
			WinMaximize("ahk_exe cmd.exe")
			Sleep 100
			Send(portal "`n")
		}
		else {
			WinMaximize(email "@linux ahk_exe cmd.exe")
		}
	}
}
global input
#HotIf IsSet(email) && WinActive(email "@linux ahk_exe cmd.exe")
	DestroyInput(*) {
		global input
		input.Destroy()
		input := false
	}
	$^v:: {
		SendText A_Clipboard
	}
	!^v:: {
		Send "^v"
	}
	$^s:: {
		Send "{esc}:wq`n"
	}
	!^s:: {
		Send "^s"
	}
	Commit(GuiCtrlObj, *) {
		submmited := GuiCtrlObj.Gui.Submit()
		Send('git commit -a -m "' submmited.Title '" -m "' submmited.Message '"`n')
		GuiCtrlObj.Gui.Destroy()
		global input := false
	}
	Push(GuiCtrlObj, *) {
		Commit(GuiCtrlObj)
		Sleep(100)
		Send('git push`n')
		Sleep(500)
		SendText(git "`n")
		Sleep(500)
		SendText(token "`n")
	}
	^f:: {
		Send('git fetch`n')
		Sleep 500
		Send('git pull`n')
	}
	Tar(GuiCtrlObj, *) {
		submmited := GuiCtrlObj.Gui.Submit()
		SendText("tar --exclude='`.`/`.git' --exclude '`.`/" submmited.Name "`.tar' -cvzf " submmited.Name "`.tar .`n")
		GuiCtrlObj.Gui.Destroy()
		global input := false
	}
	^t:: {
		global input := Gui(, "Tar details")
		input.OnEvent("Close", DestroyInput)
		input.OnEvent("Escape", DestroyInput)
		input.SetFont("s10 w300")
		input.AddEdit("r1 w250 vName WantReturn", "Project Name")
		input.AddButton("w250 +Default", "Tar").OnEvent("Click", Tar)
		input.Show("Center AutoSize")
	}
	Init(GuiCtrlObj, *) {
		submmited := GuiCtrlObj.Gui.Submit()
		SendText('git init`n')
		Sleep(500)
		SendText('git remote add origin "https://github.com/' git '/' submmited.Name '.git"`n')
		Sleep(500)
		SendText('git add .`n')
		GuiCtrlObj.Gui.Destroy()
		global input := false
	}
	^i:: {
		global input := Gui(, "Project details")
		input.OnEvent("Close", DestroyInput)
		input.OnEvent("Escape", DestroyInput)
		input.SetFont("s10 w300")
		input.AddEdit("r1 w250 vName WantReturn", "Github name")
		input.AddButton("w250 +Default", "Initialize").OnEvent("Click", Init)
		input.Show("Center AutoSize")
	}
#HotIf IsSet(email) && IsSet(link) && link && WinActive(email "@linux ahk_exe cmd.exe")
	^p:: {
		global input := Gui(, "Commit details")
		input.OnEvent("Close", DestroyInput)
		input.OnEvent("Escape", DestroyInput)
		input.SetFont("s10 w300")
		input.AddEdit("r1 w250 vTitle", "Title")
		input.AddEdit("r10 w250 vMessage", "Message")
		input.AddButton("w120", "Commit").OnEvent("Click", Commit)
		input.AddButton("yp w120 +Default", "Push").OnEvent("Click", Push)
		input.Show("Center AutoSize")
	}
#HotIf IsSet(input) && input && WinExist("ahk_id " input.Hwnd) && input.FocusedCtrl.Name != "Token"
	enter:: {
		names := "Email,Portal,Git,Token"
		next := ""
		RegExMatch(names, input.FocusedCtrl.Name ",[^,]*", &next)
		next := next[0]
		RegExMatch(next, ",.*", &next)
		next := next[0]
		input[SubStr(next, 2)].focus()
	}