@echo off
if exist %SYSTEMDRIVE%\fixes\banner.exe ( start "" /b %SYSTEMDRIVE%\fixes\banner.exe )
cd /d "%~dp0"
timeout 20
powershell -ExecutionPolicy Bypass -command "&`%~dp0\fix.ps1" >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "cleanup" /t REG_SZ /d "cmd.exe /c rd /q /s %SYSTEMDRIVE%\fixes" /f >nul 2>&1
bcdedit /deletevalue {current} safeboot >nul 2>&1
shutdown -f -r -t 0 >nul 2>&1
