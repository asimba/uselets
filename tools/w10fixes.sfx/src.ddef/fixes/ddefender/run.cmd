@echo off
cd /d "%~dp0"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "*ddf-fix" /t REG_SZ /d "%~dp0fix.cmd" /f >nul 2>&1
bcdedit /set {current} safeboot minimal >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\WinDefend" /f >nul 2>&1
shutdown -f -r -t 0 >nul 2>&1
