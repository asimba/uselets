@echo off
if exist %SYSTEMDRIVE%\fixes\banner.exe ( start "" /b %SYSTEMDRIVE%\fixes\banner.exe )
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -command "&`%~dp0\fix.ps1"
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "app-fix" /f >nul 2>&1
schtasks /delete /tn cmd_a /f >nul 2>&1
schtasks /delete /tn cmd_b /f >nul 2>&1
schtasks /run /tn cmd_c >nul 2>&1
schtasks /run /tn cmd_d >nul 2>&1
schtasks /run /tn cmd_e >nul 2>&1
schtasks /run /tn cmd_f >nul 2>&1
schtasks /delete /tn cmd_c /f >nul 2>&1
schtasks /delete /tn cmd_d /f >nul 2>&1
schtasks /delete /tn cmd_e /f >nul 2>&1
schtasks /delete /tn cmd_f /f >nul 2>&1
MsiExec.exe /q /X{73829F4D-CC8E-4FB4-A7F2-92430EC2210E} >nul 2>&1
MsiExec.exe /q /X{16A15A77-242A-412C-86EF-C4D58BD80ED0} >nul 2>&1
MsiExec.exe /q /X{7B1FCD52-8F6B-4F12-A143-361EA39F5E7C} >nul 2>&1
MsiExec.exe /q /X{43D501A5-E5E3-46EC-8F33-9E15D2A2CBD5} >nul 2>&1
MsiExec.exe /q /X{2953E19B-9F91-4A49-A23B-7E25970A1951} >nul 2>&1
MsiExec.exe /q /X{AF47B488-9780-4AB5-A97E-762E28013CA6} >nul 2>&1
MsiExec.exe /q /X{1FC1A6C2-576E-489A-9B4A-92D21F542136} >nul 2>&1
MsiExec.exe /q /X{C6FD611E-7EFE-488C-A0E0-974C09EF6473} >nul 2>&1
MsiExec.exe /q /X{A7AB73A3-CB10-4AA5-9D38-6AEFFBDE4C91} >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "cleanup" /t REG_SZ /d "schtasks /run /tn cmd_g" /f >nul 2>&1
shutdown -f -r -t 5 >nul 2>&1
