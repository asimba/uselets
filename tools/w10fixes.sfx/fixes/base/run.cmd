@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -command "&`%~dp0\fix.ps1"
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "app-fix" /f >nul 2>&1
schtasks /delete /tn cmd_a /f >nul 2>&1
schtasks /delete /tn cmd_b /f >nul 2>&1
schtasks /run /tn cmd_c >nul 2>&1
schtasks /run /tn cmd_d >nul 2>&1
schtasks /run /tn cmd_e >nul 2>&1
schtasks /delete /tn cmd_c /f >nul 2>&1
schtasks /delete /tn cmd_d /f >nul 2>&1
schtasks /delete /tn cmd_e /f >nul 2>&1
MsiExec.exe /q /X{73829F4D-CC8E-4FB4-A7F2-92430EC2210E} >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "reboot" /t REG_SZ /d "shutdown -f -r -t 30" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "cleanup" /t REG_SZ /d "cmd.exe /c rmdir /q /s %SYSTEMDRIVE%\fixes" /f >nul 2>&1
shutdown -f -r -t 5 >nul 2>&1
