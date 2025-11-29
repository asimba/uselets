$cleanflags=@(
"Active Setup Temp Folders"
"BranchCache"
"Content Indexer Cleaner"
"D3D Shader Cache"
"Delivery Optimization Files"
"Device Driver Packages"
"Diagnostic Data Viewer database files"
"Downloaded Program Files"
"GameNewsFiles"
"GameStatisticsFiles"
"GameUpdateFiles"
"Internet Cache Files"
"Offline Pages Files"
"Old ChkDsk Files"
"Previous Installations"
"RetailDemo Offline Content"
"Memory Dump Files"
"Recycle Bin"
"Service Pack Cleanup"
"Setup Log Files"
"System error memory dump files"
"System error minidump files"
"Temporary Files"
"Temporary Setup Files"
"Temporary Sync Files"
"Thumbnail Cache"
"Update Cleanup"
"Upgrade Discarded Files"
"User file versions"
"Windows Defender"
"Windows Error Reporting Archive Files"
"Windows Error Reporting Queue Files"
"Windows Error Reporting System Archive Files"
"Windows Error Reporting System Queue Files"
"Windows Error Reporting Temp Files"
"Windows Error Reporting Files"
"Windows ESD installation files"
"Windows Upgrade Log Files"
)

$temp_dirs=@(
"$env:windir\memory.dmp"
"$env:windir\minidump\*"
"$env:windir\Logs\CBS\*"
"$env:windir\Logs\DISM\*"
"$env:windir\Logs\PLUG\*"
"$env:windir\Logs\SIH\*"
"$env:windir\Logs\waasmedic\*"
"$env:windir\Logs\waasmediccapsule\*"
"$env:windir\Logs\WindowsUpdate\*"
"$env:windir\servicing\LCU\*"
"$env:windir\System32\sru\*"
"$env:windir\System32\config\systemprofile\AppData\Local\Microsoft\Windows\WebCache\*"
"$env:windir\System32\config\systemprofile\AppData\Local\*.tmp"
"$env:windir\SoftwareDistribution\*"
"$env:windir\Temp\*"
"$env:windir\Prefetch\*"
"$env:systemdrive\ProgramData\Microsoft\Windows\WER\*"
"$env:systemdrive\ProgramData\Microsoft\Windows Defender\Scans\mpcache*.bin"
"$env:systemdrive\Program Files (x86)\Microsoft\EdgeCore\*"
"$env:systemdrive\Program Files (x86)\Microsoft\Edge\Application\SetupMetrics\*"
"$env:systemdrive\Program Files (x86)\Microsoft\EdgeWebView\Application\1*"
"$env:systemdrive\Program Files (x86)\Microsoft\EdgeWebView\Application\SetupMetrics\*"
"$env:systemdrive\Program Files (x86)\Microsoft\EdgeUpdate\Install\*"
"$env:systemdrive\Program Files (x86)\Microsoft\EdgeUpdate\Download\*"
"$env:systemdrive\Users\*\AppData\Local\Temp\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\AutofillAiModelCache\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\Cache\Cache_Data\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\Code Cache\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\DawnGraphiteCache\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\DawnWebGPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\GPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\Sessions\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\Crashpad\attachments\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\Crashpad\reports\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\GraphiteDawnCache\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\GrShaderCache\*"
"$env:systemdrive\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\ShaderCache\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\*\AutofillAiModelCache\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\*\Cache\Cache_Data\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\*\Code Cache\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\*\DawnGraphiteCache\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\*\DawnWebGPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\*\GPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\*\IndexedDB\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\*\Sessions\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\*\Storage\ext\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\BrowserMetrics\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\Crashpad\attachments\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\Crashpad\reports\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\GraphiteDawnCache\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\GrShaderCache\*"
"$env:systemdrive\Users\*\AppData\Local\Google\Chrome\User Data\ShaderCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\*\AutofillAiModelCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\*\Cache\Cache_Data\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\*\Code Cache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\*\DawnGraphiteCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\*\DawnWebGPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\*\GPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\*\IndexedDB\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\*\Sessions\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\*\Storage\ext\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\BrowserMetrics\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\Crashpad\attachments\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\Crashpad\reports\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\GraphiteDawnCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\GrShaderCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\ShaderCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\WebCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\WebCache.old\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\WER\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\INetCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IECompatCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IECompatUaCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IEDownloadHistory\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\INetCookies\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Terminal Server Client\Cache\*"
"$env:systemdrive\Users\*\AppData\Local\Packages\Microsoft.*\AC\*\*"
"$env:systemdrive\Users\*\AppData\Local\Packages\Microsoft.*\AppData\*\*"
"$env:systemdrive\Users\*\AppData\Local\Moonchild Productions\Pale Moon\Profiles\*\cache2\*"
"$env:systemdrive\Users\*\AppData\Local\Moonchild Productions\Pale Moon\Profiles\*\jumpListCache\*"
"$env:systemdrive\Users\*\AppData\Local\Moonchild Productions\Pale Moon\Profiles\*\startupCache\*"
"$env:systemdrive\Users\*\AppData\Local\Moonchild Productions\Pale Moon\Profiles\*\thumbnails\*"
"$env:systemdrive\Users\*\AppData\Local\Mozilla\Firefox\Profiles\*\cache2\*"
"$env:systemdrive\Users\*\AppData\Local\Mozilla\Firefox\Profiles\*\startupCache\*"
"$env:systemdrive\Users\*\AppData\Local\Mozilla\Firefox\Profiles\*\thumbnails\*"
"$env:systemdrive\Users\*\AppData\Roaming\Mozilla\Firefox\Crash Reports\*"
"$env:systemdrive\Users\*\AppData\Roaming\Mozilla\Firefox\Pending Pings\*"
"$env:systemdrive\Users\*\AppData\Roaming\Mozilla\Firefox\Profiles\*\crashes\*"
"$env:systemdrive\Users\*\AppData\Roaming\Mozilla\Firefox\Profiles\*\datareporting\*"
"$env:systemdrive\Users\*\AppData\Roaming\Mozilla\Firefox\Profiles\*\minidumps\*"
"$env:systemdrive\Users\*\AppData\Roaming\Mozilla\Firefox\Profiles\*\saved-telemetry-pings\*"
"$env:systemdrive\Users\*\AppData\Roaming\Mozilla\Firefox\Profiles\*\security_state\*.delta"
"$env:systemdrive\Users\*\AppData\Local\Opera Software\Opera Stable\*\Cache\Cache_Data\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\Crash Reports\attachments\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\Crash Reports\reports\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\GraphiteDawnCache\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\GrShaderCache\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\ShaderCache\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\Code Cache\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\Crash Reports\attachments\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\Crash Reports\reports\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\DawnGraphiteCache\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\DawnWebGPUCache\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\GPUCache\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\IndexedDB\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\StatsSessions\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\Service Worker\CacheStorage\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\Service Worker\Database\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\Service Worker\ScriptCache\*"
"$env:systemdrive\Users\*\AppData\Roaming\Opera Software\Opera Stable\*\Sessions\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\*\AutofillAiModelCache\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\*\Cache\Cache_Data\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\*\Code Cache\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\*\DawnGraphiteCache\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\*\DawnWebGPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\*\GPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\*\IndexedDB\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\*\Sessions\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\*\Storage\ext\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\GraphiteDawnCache\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\GrShaderCache\*"
"$env:systemdrive\Users\*\AppData\Local\Vivaldi\User Data\ShaderCache\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\*\Cache\Cache_Data\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\*\Code Cache\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\*\DawnGraphiteCache\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\*\DawnWebGPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\*\GPUCache\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\*\IndexedDB\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\*\Sessions\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\BrowserMetrics\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\Crashpad\attachments\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\Crashpad\reports\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\GraphiteDawnCache\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\GrShaderCache\*"
"$env:systemdrive\Users\*\AppData\Local\Yandex\YandexBrowser\User Data\ShaderCache\*"
"$env:systemdrive\`$SysReset"
"$env:systemdrive\`$WinREAgent"
"$env:systemdrive\Config.Msi"
"$env:systemdrive\Intel"
"$env:systemdrive\PerfLogs"
"$env:systemdrive\Windows.old"
)

$acl_reset_dirs=@(
"$env:windir\Logs\waasmedic"
)

function wc($c,$m){Write-Host -ForegroundColor $c $m}
function wn($m){Write-Host -NoNewline $m}
function wh($m){wc 10 $m}
$ed={if($?){wc 1 " - Done."}else{wc 4 " - File deletion error ($($Error[0].CategoryInfo.Category))!"}}
function rf($f){try{wn "Trying to remove file     : `"$f`"";rm $f -Recurse -Force -ea 0 *>$null;.$ed}catch{}}

function stop_browsers(){
  $bs=gci -r 'HKLM:\SOFTWARE\Clients\StartMenuInternet\*\shell\open'|% {$_.GetValue("").Trim('"') -replace("exe.+$","exe")}|`
  sls -Pattern 'firefox|palemoon|chrome|opera|vivaldi|brave|yandex|browser|edge'|sort|gu|% {foreach($f in $_){gi $f|% {$_.Basename+$_.Extension}}}
  foreach($b in $bs){taskkill /f /im $b  *>$null}
}

function clean_dir($path){
  if (!(Test-Path -LiteralPath $path -Type leaf)){
    try{
      if(Test-Path -Path $path){
        foreach($f in (ls -Path $path -Force)){
          if(Test-Path -LiteralPath $f -Type leaf){rf($f)}
          else{
            wn "Trying to remove directory: `"$f`"";wc 14 " - Background operation."
            cmd /c "rd /q /s `"$($f.FullName)`"" *>$null
          }
        }
      }
    }catch{}
  }
  if(Test-Path -LiteralPath $path){rf($path)}
}

function cleanup(){
  wh "Windows components cleanup..."
  Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase /NoRestart /Quiet
  wh "Disabling Windows reserved storage..."
  Dism /Online /Set-ReservedStorageState /State:Disabled /NoRestart /Quiet
  wh "Deleting system restore points..."
  vssadmin delete shadows /for=$env:systemdrive /all /quiet *>$null
  spsv DPS -Force -ea 0 *>$null
  spsv wuauserv -Force -ea 0 *>$null
  spsv TrustedInstaller -Force -ea 0 *>$null
  sajb -Name regprop -ScriptBlock {Stop-ScheduledTask CacheTask "\Microsoft\Windows\Wininet" -ea 0 *>$null} *>$null
  (gjb|wjb) *>$null
  stop_browsers
  gps dllhost* -ea 0|foreach{$p=$_;$_.Modules|foreach{if($_.ModuleName -eq "wininet.dll"){spps $p.id -Force -ea 0}}}
  wh "Deleting temporary folders and files..."
  foreach($p in $acl_reset_dirs) {
    takeown /a /f $p *>$null
    icacls $p /reset /t /c /q *>$null
    cmd /c "del /q /s `"$p\*`"" *>$null
  }
  foreach($p in $temp_dirs){clean_dir($p)}
  try{ls $env:systemdrive\ -Include "*.log","*.tmp","*.dmp","*.mdmp","*.old","LOG","LOCK","iconcache*.db","thumbcache*.db" -Force -s -File -ea 0|foreach{rf($_)}}catch{}
  sasv DPS -ea 0 *>$null
  sasv TrustedInstaller -ea 0 *>$null
  Start-ScheduledTask CacheTask "\Microsoft\Windows\Wininet" -ea 0 *>$null
  wh "Running Windows system cleanup..."
  $StateFlags='StateFlags1234'
  $StateRun=$StateFlags.Substring($StateFlags.get_Length()-4)
  $StateRun='/sagerun:' + $StateRun
  foreach($cleanflag in $cleanflags){
    sp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$cleanflag" $StateFlags 2 -Type 4 -ea 0 *>$null
  }
  saps -FilePath CleanMgr.exe -Args $StateRun -WindowStyle 1 -Wait
  foreach($cleanflag in $cleanflags){
    rp "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$cleanflag" $StateFlags -ea 0 *>$null
  }
  ipconfig /flushdns *>$null
  wh "Deleting system notifications..."
  [Windows.UI.Notifications.ToastNotificationManager,Windows.UI.Notifications,ContentType=WindowsRuntime]>$null
  $notifications=ls -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings"|select -ExpandProperty Name
  foreach($notification in $notifications){ 
    $lastRegistryKeyName=($notification -split "\\")[-1] -replace "\\$"
    [Windows.UI.Notifications.ToastNotificationManager]::History.Clear($lastRegistryKeyName)
  }
  wh "Clearing all event logs..."
  wevtutil el|foreach{write "Clearing $_";wevtutil cl "$_" *>$null}
  wh "Clearing filesystem journal..."
  fsutil usn deletejournal /n $env:systemdrive *>$null
  wh "Windows system drive defragmentation..."
  defrag $env:systemdrive /H /X /V /U
} 

cleanup
exit
