@echo off
cd /d "%~dp0"
powercfg /hibernate off
powershell -ExecutionPolicy Bypass -command "&`%~dp0\fix.ps1"
set list=(^
  a-0001.a-afdentry.net.trafficmanager.net,^
  a-0001.a-msedge.net,^
  a-0003.a-msedge.net,^
  a767.dscg3.akamai.net,^
  activation-v2.sls.microsoft.com,^
  activation-v2.sls.trafficmanager.net,^
  array605-prod.do.dsp.mp.microsoft.com,^
  asimov-win.settings.data.microsoft.com.akadns.net,^
  au.au-msedge.net,^
  au-bg-shim.trafficmanager.net,^
  au.c-0001.c-msedge.net,^
  au.download.windowsupdate.com.edgesuite.net,^
  audownload.windowsupdate.nsatc.net,^
  auto.au.download.windowsupdate.com.c.footprint.net,^
  c-0001.c-msedge.net,^
  checkappexec.microsoft.com,^
  client.wns.windows.com,^
  cs9.wpc.v0cdn.net,^
  cs11.wpc.v0cdn.net,^
  ctldl.windowsupdate.com,^
  db5.displaycatalog.md.mp.microsoft.com.akadns.net,^
  db5-eap.settings.data.microsoft.com.akadns.net,^
  db5.settings.data.microsoft.com.akadns.net,^
  displaycatalog-europe.md.mp.microsoft.com.akadns.net,^
  displaycatalog.md.mp.microsoft.com.akadns.net,^
  displaycatalog.mp.microsoft.com,^
  fe3cr.delivery.mp.microsoft.com,^
  fe3.delivery.dsp.mp.microsoft.com.nsatc.net,^
  slscr.update.microsoft.com,^
  slscr.update.microsoft.com.akadns.net,^
  dlc-shim.trafficmanager.net,^
  dmd.metaservices.microsoft.com,^
  dmd.metaservices.microsoft.com.akadns.net,^
  download.microsoft.com,^
  download.microsoft.com.edgekey.net,^
  e10198.b.akamaiedge.net,^
  e11290.dspg.akamaiedge.net,^
  e12358.g.akamaiedge.net,^
  e12594.b.akamaiedge.net,^
  e1706.g.akamaiedge.net,^
  e3673.dscg.akamaiedge.net,^
  e3843.g.akamaiedge.net,^
  e9659.dspg.akamaiedge.net,^
  europe.smartscreen-prod.microsoft.com,^
  ev.support.microsoft.com.edgekey.net,^
  geo-prod.do.dsp.mp.microsoft.com,^
  geo-prod.dodsp.mp.microsoft.com.nsatc.net,^
  geo.settings.data.microsoft.com.akadns.net,^
  geover-prod.do.dsp.mp.microsoft.com,^
  geover-prod.dodsp.mp.microsoft.com.nsatc.net,^
  g.live.com,^
  g.msn.com.nsatc.net,^
  go.microsoft.com,^
  go.microsoft.com.edgekey.net,^
  kv601-prod.do.dsp.mp.microsoft.com,^
  kv601-prod.do.dsp.mp.microsoft.com.edgekey.net,^
  kv601-prod.dodsp.mp.microsoft.com.nsatc.net,^
  login.live.com,^
  login.msa.akadns6.net,^
  main.dl.ms.akadns.net,^
  microsoftupdate.com,^
  microsoftupdate.microsoft.com,^
  modern.watson.data.microsoft.com.akadns.net,^
  msdn.com,^
  msdn.microsoft.com,^
  msdn.microsoft.com.edgekey.net,^
  msn.com,^
  office.microsoft.com,^
  oneclient.sfx.ms,^
  oneclient.sfx.ms.edgekey.net,^
  onecs-live.azureedge.net,^
  onecs-live.ec.azureedge.net,^
  osi-prod-wus01-ocsa.cloudapp.net,^
  prod.do.dsp.mp.microsoft.com.edgekey.net,^
  prod.ocsa.live.com.akadns.net,^
  redir.update.microsoft.com.nsatc.net,^
  settings-win.data.microsoft.com,^
  sls.emea.update.microsoft.com.akadns.net,^
  sls.update.microsoft.com,^
  sls.update.microsoft.com.akadns.net,^
  storecatalogrevocation.storequality.microsoft.com,^
  storecatalogrevocation.storequality.microsoft.com.edgekey.net,^
  support.microsoft.com,^
  technet.com,^
  technet.microsoft.com,^
  technet.microsoft.com.edgekey.net,^
  update.microsoft.com,^
  update.microsoft.com.nsatc.net,^
  validation-v2.sls.microsoft.com,^
  validation-v2.sls.trafficmanager.net,^
  vs.login.msa.akadns6.net,^
  watson.telemetry.microsoft.com,^
  wd-prod-ss-eu-north-1-fe.northeurope.cloudapp.azure.com,^
  wd-prod-ss-eu.trafficmanager.net,^
  wd-prod-ss.trafficmanager.net,^
  windowsupdate.com,^
  windowsupdate.microsoft.com,^
  windowsupdate.redir.update.microsoft.com.nsatc.net,^
  wns.notify.trafficmanager.net,^
  wu.azureedge.net,^
  wu.ec.azureedge.net,^
  wu.wpc.apr-52dd2.edgecastdns.net,^
  hlb.apr-52dd2-0.edgecastdns.net,^
  wpad.localdomain,^
  wustats.microsoft.com,^
  wus-zzz.ocsa.officeapps.live.com,^
  www.bing.com,^
  www.msdn.com,^
  www.msn.com,^
  www-msn-com.a-0003.a-msedge.net,^
  www.technet.com,^
  www.update.microsoft.com.nsatc.net,^
  fp.msedge.net,^
)
echo #>%SystemRoot%\System32\drivers\etc\hosts
for %%i in %list% do (
  echo 0.0.0.0 %%i>>%SystemRoot%\System32\drivers\etc\hosts
)
setlocal enabledelayedexpansion
set list=(^
  2.18.32.0/22,^
  8.238.89.126,^
  8.238.100.0/22,^
  8.238.104.0/22,^
  8.238.108.0/22,^
  8.241.42.254,^
  8.249.39.254,^
  8.250.242.0/23,^
  8.250.243.254,^
  8.253.193.109,^
  13.64.0.0/11,^
  13.96.0.0/13,^
  13.104.0.0/14,^
  20.48.0.0/12,^
  23.46.124.128/25,^
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
  52.109.0.0/22,^
  52.152.108.0/22,^
  52.160.0.0/11,^
  52.224.0.0/11,^
  72.247.42.0/23,^
  92.122.64.0/22,^
  93.184.221.240,^
  104.208.0.0/13,^
  157.54.0.0/15,^
  157.60.0.0/16,^
  157.56.0.0/14,^
  170.165.0.0/16,^
  178.18.232.0/22,^
  204.79.197.0/24,^
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
