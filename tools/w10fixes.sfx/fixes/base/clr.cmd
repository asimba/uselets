@echo off
if exist %SYSTEMDRIVE%\fixes\banner.exe ( start "" /b %SYSTEMDRIVE%\fixes\banner.exe )
cd /d "%~dp0"
schtasks /delete /tn cmd_g /f >nul 2>&1
Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase /NoRestart /Quiet
for /f "tokens=*" %%e in ('wevtutil el') do @wevtutil cl "%%e" >nul 2>&1
sc config wuauserv start=disabled /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "reboot" /t REG_SZ /d "shutdown -f -r -t 30" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "cleanup" /t REG_SZ /d "cmd.exe /c rd /q /s %SYSTEMDRIVE%\fixes" /f >nul 2>&1
shutdown -f -r -t 5 >nul 2>&1
