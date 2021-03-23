@echo off
cd /d "%~dp0"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "*ddf-fix" /t REG_SZ /d "%~dp0fix.cmd" /f
bcdedit /set {current} safeboot minimal
shutdown -f -r -t 0
