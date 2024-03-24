@echo off
start %SYSTEMDRIVE%\fixes\banner.exe /b
schtasks /create /sc once /tn cmd_a /tr %SYSTEMDRIVE%\fixes\ddefender\run.cmd /rl highest /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_b /tr %SYSTEMDRIVE%\fixes\base\run.cmd /rl highest /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_c /tr "reg delete \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\InstallService\" /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_d /tr "reg delete \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\WaaSMedic\" /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_e /tr "reg delete \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\UpdateOrchestrator\" /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_f /tr "reg delete \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\WindowsUpdate\Scheduled Start\" /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_g /tr "reg add \"HKLM\SYSTEM\CurrentControlSet\Services\WinDefend"  /v Start /t REG_DWORD /d 4 /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_h /tr "reg add \"HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc"  /v Start /t REG_DWORD /d 4 /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_i /tr "reg add \"HKLM\SYSTEM\CurrentControlSet\Services\Sense"  /v Start /t REG_DWORD /d 4 /f" /ru SYSTEM /sd 01/01/2000 /st 00:00 >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "app-fix" /t REG_SZ /d "schtasks /run /tn cmd_b" /f >nul 2>&1
schtasks /run /tn cmd_a >nul 2>&1
