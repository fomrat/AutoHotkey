#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#InstallKeybdHook
#UseHook, On
#WinActivateForce
#SingleInstance force
SendMode, Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode, RegEx
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
CoordMode, Mouse, Screen
DetectHiddenWindows, On
SetScrollLockState, Off

CheckAdmin()

RunIfExist(A_ScriptDir "\Utilities\VolumeScroll\VolumeScroll.ahk")
RunIfExist(A_ScriptDir "\Core\AutoCorrect.ahk")
Run, %A_ScriptDir%\Utilities\VirtualDesktopEnhancer\virtual-desktop-enhancer.ahk VirtualDesktopEnhancer.settings.ini

Notify(A_ScriptName . " Started!","",-3,"Style=Win10")

Editor := "C:\Program Files (x86)\Microsoft VS Code\Code.exe"
UserDir := "C:\Users\" A_UserName

Menu, Tray, Icon, lib\images\Portal.ico
Menu, Tray, Tip, Home Script
SetTimer, IntroSound, -1
SetTimer, IntroLights, -1000

; TaskBar_SetAttr(2)

CreateStartupShortcut()
Return ; End Auto-Execute

IntroSound:
	SoundPlay, lib\sounds\load.wav
	Return

IntroLights:
	kbdIndex := 1
	Loop, 4 ; flash all LEDs
	 {
	 KeyboardLED(4,"on", kbdIndex)
	 Sleep, 75
	 KeyboardLED(4,"off", kbdIndex)
	 Sleep, 75
	 }
	KeyboardLED(0,"off", kbdIndex)
	Return

^!s::
	RunProgFiles("Everything\Everything.exe")
	WinActivate
	WinMove, ahk_class EVERYTHING,, 1920,735,1280,705
	Return

; Rearrange windows
^!0::
	Run, "C:\Program Files (x86)\Steam\Steam.exe" steam://open/friends/
	WinMove, Friends,, 4680,44,312,1698
	WinMove, ahk_exe Discord.exe,, 1920,44,1536,1698
	Return

; Toggle Audio Device
^!Ins::
	AudioIniFile := "AudioDevices.ini"
	IfNotExist, %AudioIniFile%
	FileAppend, [AudioDevices], %AudioIniFile%
	IniRead, DefaultDevice, AudioDevices.ini, AudioDevices, DefaultDevice
	If (DefaultDevice != "G933")
	{
		NewDevice := "G933"
		IniWrite, "G933", AudioDevices.ini, AudioDevices, DefaultDevice
	}
	Else
	{
		NewDevice := "YU3"
		IniWrite, "YU3", AudioDevices.ini, AudioDevices, DefaultDevice
	}
	Run, Utilities\nircmd.exe setdefaultsounddevice %NewDevice%
	Notify("New Audio Device:" NewDevice,"",-1,"Style=Win10")
	Return

#c::Run, C:\
#p::Run, C:\Program Files (x86)\

:*:pd;::
	SendInput, playdemo picks\%clipboard%{Enter}
	Return

#l::
	Run,%A_WinDir%\System32\rundll32.exe user32.dll`,LockWorkStation
	Sleep 1000
	SendMessage, 0x112, 0xF170, 2,, Program Manager
	Return

CapsLock & /::
RCtrl & Del::Show_Start("- Google Chrome", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
CapsLock & SC027::
RCtrl & End::Show_Start("Cmder", "C:\tools\cmdermini\Cmder.exe")
CapsLock & '::
RCtrl & PgDn::Show_Start("- Visual Studio Code", "C:\Program Files (x86)\Microsoft VS Code\Code.exe")
RCtrl & PgUp::Show_Start(" - Discord", UserDir "\AppData\Local\Discord\app-0.0.299\Discord.exe")
; RCtrl & 5::Return
; RCtrl & 6::Return
; RCtrl & 7::Return
; RCtrl & 8::Return
; RCtrl & 9::Return

^!Enter::
	loop
	{
		WinClose, ahk_class CabinetWClass
		IfWinNotExist, ahk_class CabinetWClass
			break
	}
	WinClose ahk_class EVERYTHING
	Notify("Windows Purged","",-2,"Style=Win10")
	Return

; ~*LWin::
; 	Sleep, 200
; 	TaskBar_SetAttr(2)
; 	Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Folder Shortcuts ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!8:: Show_Dir("C:\dev")
!9:: Show_Dir("F:\Downloads\")
!0:: Show_Dir(A_ScriptDir)

^!r::	Reload
^!e::	Edit(A_ScriptName, Editor)
^!t::	Edit("test.ahk", Editor)
!t:: Run %A_ScriptDir%\test.ahk
^!x::AHKPanic(1,0,0,1)

CapsLock & w::
	WinGet, isMaxed, MinMax, A
	If (isMaxed)
	{
		Send #{Down}
		Sleep 20
		Monitor_MoveOptimal()
	}
	Else
		WPXA_MaximizeToggle("A")
	Return

CapsLock & q::WPXA_Move(-1, 0,  0.5, 1.0, "A")
CapsLock & e::WPXA_Move(+1, 0,  0.5, 1.0, "A")
CapsLock & Tab::WPXA_MoveWindowToMonitor("Prev", "A")

CapsLock & Space::LWin

#Include %A_ScriptDir%\Core\AppSpecific.ahk
#Include %A_ScriptDir%\Core\Functions.ahk
#Include %A_ScriptDir%\Core\HotStrings.ahk
#Include %A_ScriptDir%\Shortcuts\Media.ahk
#Include %A_ScriptDir%\Shortcuts\CapsNav.ahk
#Include %A_ScriptDir%\Shortcuts\VirtualDesktops.ahk
#Include %A_ScriptDir%\lib\VA.ahk
#Include %A_ScriptDir%\lib\Notify.ahk
#Include %A_ScriptDir%\lib\LedControl.ahk
#Include %A_ScriptDir%\lib\TaskBar_SetAttr.ahk
#Include %A_ScriptDir%\lib\WPXA.ahk
