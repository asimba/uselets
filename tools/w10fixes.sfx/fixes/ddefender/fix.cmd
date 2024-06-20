@echo off
if exist %SYSTEMDRIVE%\fixes\banner.exe ( start "" /b %SYSTEMDRIVE%\fixes\banner.exe )
cd /d "%~dp0"
timeout 20
powershell -ExecutionPolicy Bypass -command "&`%~dp0\fix.ps1" >nul 2>&1
schtasks /run /tn cmd_g >nul 2>&1
schtasks /run /tn cmd_h >nul 2>&1
schtasks /run /tn cmd_i >nul 2>&1
schtasks /delete /tn cmd_g /f >nul 2>&1
schtasks /delete /tn cmd_h /f >nul 2>&1
schtasks /delete /tn cmd_i /f >nul 2>&1
bcdedit /deletevalue {current} safeboot >nul 2>&1
shutdown -f -r -t 0 >nul 2>&1
