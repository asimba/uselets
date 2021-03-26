@echo off
cd /d "%~dp0"
powercfg /hibernate off
powershell -ExecutionPolicy Bypass -command "&`%~dp0\fix.ps1"
set list=(^
  wpad.localdomain,^
  www.bing.com,^
  europe.smartscreen-prod.microsoft.com,^
  wd-prod-ss-eu.trafficmanager.net,^
  wd-prod-ss-eu-north-1-fe.northeurope.cloudapp.azure.com,^
  go.microsoft.com,^
  go.microsoft.com.edgekey.net,^
  dmd.metaservices.microsoft.com,^
  dmd.metaservices.microsoft.com.akadns.net,^
  support.microsoft.com,^
  ev.support.microsoft.com.edgekey.net,^
  e3843.g.akamaiedge.net,^
  e11290.dspg.akamaiedge.net,^
  a-0001.a-afdentry.net.trafficmanager.net,^
  a-0001.a-msedge.net,^
  onecs-live.azureedge.net,^
  onecs-live.ec.azureedge.net,^
  cs9.wpc.v0cdn.net,^
  watson.telemetry.microsoft.com,^
  modern.watson.data.microsoft.com.akadns.net,^
  sls.update.microsoft.com,^
  ctldl.windowsupdate.com,^
  audownload.windowsupdate.nsatc.net,^
  au.au-msedge.net,^
  au.c-0001.c-msedge.net,^
  c-0001.c-msedge.net,^
  displaycatalog.mp.microsoft.com,^
  displaycatalog.md.mp.microsoft.com.akadns.net,^
  displaycatalog-europe.md.mp.microsoft.com.akadns.net,^
  db5.displaycatalog.md.mp.microsoft.com.akadns.net,^
  login.live.com,^
  login.msa.akadns6.net,^
  vs.login.msa.akadns6.net,^
  geo-prod.do.dsp.mp.microsoft.com,^
  geo-prod.dodsp.mp.microsoft.com.nsatc.net,^
  geover-prod.do.dsp.mp.microsoft.com,^
  geover-prod.dodsp.mp.microsoft.com.nsatc.net,^
  prod.do.dsp.mp.microsoft.com.edgekey.net,^
  e1706.g.akamaiedge.net,^
  array605-prod.do.dsp.mp.microsoft.com,^
  storecatalogrevocation.storequality.microsoft.com,^
  storecatalogrevocation.storequality.microsoft.com.edgekey.net,^
  e10198.b.akamaiedge.net,^
  kv601-prod.do.dsp.mp.microsoft.com,^
  kv601-prod.dodsp.mp.microsoft.com.nsatc.net,^
  kv601-prod.do.dsp.mp.microsoft.com.edgekey.net,^
  e12358.g.akamaiedge.net,^
  settings-win.data.microsoft.com,^
  asimov-win.settings.data.microsoft.com.akadns.net,^
  geo.settings.data.microsoft.com.akadns.net,^
  db5.settings.data.microsoft.com.akadns.net,^
  db5-eap.settings.data.microsoft.com.akadns.net,^
  checkappexec.microsoft.com,^
  wd-prod-ss.trafficmanager.net,^
  wd-prod-ss-eu-north-1-fe.northeurope.cloudapp.azure.com,^
  e11290.dspg.akamaiedge.net,^
  g.msn.com.nsatc.net,^
  g.live.com,^
  oneclient.sfx.ms,^
  oneclient.sfx.ms.edgekey.net,^
  e9659.dspg.akamaiedge.net,^
)
echo #>%SystemRoot%\System32\drivers\etc\hosts
for %%i in %list% do (
  echo 0.0.0.0 %%i>>%SystemRoot%\System32\drivers\etc\hosts
)
setlocal enabledelayedexpansion
set list=(^
  13.64.0.0/11,^
  13.96.0.0/13,^
  13.104.0.0/14,^
  40.64.0.0/13,^
  40.74.0.0/15,^
  40.76.0.0/14,^
  40.77.229.0/24,^
  40.80.0.0/12,^
  40.96.0.0/12,^
  40.112.0.0/13,^
  40.120.0.0/14,^
  40.124.0.0/16,^
  40.125.0.0/17,^
  157.54.0.0/15,^
  157.60.0.0/16,^
  157.56.0.0/14,^
)
set /a n=1
for %%i in %list% do (
  set namein=MS Block-In !n! %%i
  set nameout=MS Block-Out !n! %%i
  echo !namein!
  echo !nameout!
  netsh advfirewall firewall delete rule name="!namein!" >nul 2>&1
  netsh advfirewall firewall delete rule name="!nameout!" >nul 2>&1
  netsh advfirewall firewall add rule name="!namein!" dir=in interface=any action=block remoteip=%%i >nul 2>&1
  netsh advfirewall firewall add rule name="!nameout!" dir=out interface=any action=block remoteip=%%i >nul 2>&1
  set /a n=n+1
)
endlocal
netsh advfirewall firewall delete rule name="MS Block-In SpeechRuntime" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-In SystemSettings" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-In OneDriveSetup" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-Out SpeechRuntime" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-Out SystemSettings" >nul 2>&1
netsh advfirewall firewall delete rule name="MS Block-Out OneDriveSetup" >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-In SpeechRuntime" dir=in interface=any action=block program=%SystemRoot%\System32\Speech_OneCore\common\SpeechRuntime.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-In SystemSettings" dir=in interface=any action=block program=%SystemRoot%\ImmersiveControlPanel\SystemSettings.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-In OneDriveSetup" dir=in interface=any action=block program=%SystemRoot%\System32\OneDriveSetup.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-Out SpeechRuntime" dir=out interface=any action=block program=%SystemRoot%\System32\Speech_OneCore\common\SpeechRuntime.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-Out SystemSettings" dir=out interface=any action=block program=%SystemRoot%\ImmersiveControlPanel\SystemSettings.exe >nul 2>&1
netsh advfirewall firewall add rule name="MS Block-Out OneDriveSetup" dir=out interface=any action=block program=%SystemRoot%\System32\OneDriveSetup.exe >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "app-fix" /f >nul 2>&1
schtasks /delete /tn cmd_a /f
schtasks /delete /tn cmd_b /f
schtasks /run /tn cmd_c
schtasks /run /tn cmd_d
schtasks /run /tn cmd_e
schtasks /delete /tn cmd_c /f
schtasks /delete /tn cmd_d /f
schtasks /delete /tn cmd_e /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "reboot" /t REG_SZ /d "shutdown -f -r -t 30" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "cleanup" /t REG_SZ /d "cmd.exe /c rmdir /q /s %SYSTEMDRIVE%\fixes" /f
shutdown -f -r -t 5
