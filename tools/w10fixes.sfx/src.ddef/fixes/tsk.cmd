@echo off
start %SYSTEMDRIVE%\fixes\banner.exe /b
schtasks /create /sc once /tn cmd_a /tr %SYSTEMDRIVE%\fixes\ddefender\run.cmd /rl highest /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_f /tr "reg add \"HKLM\SYSTEM\CurrentControlSet\Services\WinDefend"  /v Start /t REG_DWORD /d 4 /f" /ru SYSTEM /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_g /tr "reg add \"HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc"  /v Start /t REG_DWORD /d 4 /f" /ru SYSTEM /st 00:00 >nul 2>&1
schtasks /create /sc once /tn cmd_h /tr "reg add \"HKLM\SYSTEM\CurrentControlSet\Services\Sense"  /v Start /t REG_DWORD /d 4 /f" /ru SYSTEM /st 00:00 >nul 2>&1
schtasks /run /tn cmd_a >nul 2>&1 && schtasks /delete /tn cmd_a /f >nul 2>&1
