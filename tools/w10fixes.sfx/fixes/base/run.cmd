@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -command "&`%~dp0\fix.ps1"
netsh advfirewall firewall delete rule name="MS Block-In SpeechRuntime" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-In SystemSettings" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-In OneDriveSetup" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-Out SpeechRuntime" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-Out SystemSettings" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-Out OneDriveSetup" >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-In SIHClient" dir=in interface=any action=block program=%SystemRoot%\System32\SIHClient.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-In SpeechRuntime" dir=in interface=any action=block program=%SystemRoot%\System32\Speech_OneCore\common\SpeechRuntime.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-In SystemSettings" dir=in interface=any action=block program=%SystemRoot%\ImmersiveControlPanel\SystemSettings.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-In OneDriveSetup" dir=in interface=any action=block program=%SystemRoot%\System32\OneDriveSetup.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-Out SIHClient" dir=out interface=any action=block program=%SystemRoot%\System32\SIHClient.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-Out SpeechRuntime" dir=out interface=any action=block program=%SystemRoot%\System32\Speech_OneCore\common\SpeechRuntime.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-Out SystemSettings" dir=out interface=any action=block program=%SystemRoot%\ImmersiveControlPanel\SystemSettings.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-Out OneDriveSetup" dir=out interface=any action=block program=%SystemRoot%\System32\OneDriveSetup.exe >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "app-fix" /f >nul 2>&1
schtasks /delete /tn cmd_a /f >nul 2>&1
schtasks /delete /tn cmd_b /f >nul 2>&1
schtasks /run /tn cmd_c >nul 2>&1
schtasks /run /tn cmd_d >nul 2>&1
schtasks /run /tn cmd_e >nul 2>&1
schtasks /delete /tn cmd_c /f >nul 2>&1
schtasks /delete /tn cmd_d /f >nul 2>&1
schtasks /delete /tn cmd_e /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "reboot" /t REG_SZ /d "shutdown -f -r -t 30" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "cleanup" /t REG_SZ /d "cmd.exe /c rmdir /q /s %SYSTEMDRIVE%\fixes" /f >nul 2>&1
shutdown -f -r -t 5 >nul 2>&1
