@echo off
cd /d "%~dp0"
timeout 20
powershell -ExecutionPolicy Bypass -command "&`%~dp0\fix.ps1"
bcdedit /deletevalue {current} safeboot
shutdown -f -r -t 0
