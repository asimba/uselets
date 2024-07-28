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
"$env:systemdrive\Users\*\AppData\Local\Temp\*"
"$env:systemdrive\ProgramData\Microsoft\Windows\WER\*"
"$env:systemdrive\ProgramData\Microsoft\Windows Defender\Scans\mpcache*.bin"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\Default\Cache\Cache_Data\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Edge\User Data\Default\IndexedDB\*"
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
"$env:systemdrive\`$SysReset"
"$env:systemdrive\`$WinREAgent"
"$env:systemdrive\Config.Msi"
"$env:systemdrive\Intel"
"$env:systemdrive\PerfLogs"
)

$acl_reset_dirs=@(
"$env:windir\Logs\waasmedic"
)

function wc($c,$m){Write-Host -ForegroundColor $c $m}
function wn($m){Write-Host -NoNewline $m}
function wh($m){wc 10 $m}
$ed={if($?){wc 1 " - Done."}else{wc 4 " - File deletion error ($($Error[0].CategoryInfo.Category))!"}}
function rf($f){try{wn "Trying to remove file     : `"$f`"";rm $f -Force -ea 0 *>$null;.$ed}catch{}}

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
  taskkill /f /im msedge.exe *>$null
  gps dllhost* -ea 0|foreach{$p=$_;$_.Modules|foreach{if($_.ModuleName -eq "wininet.dll"){spps $p.id -Force -ea 0}}}
  wh "Deleting temporary folders and files..."
  foreach($p in $acl_reset_dirs) {
    takeown /a /f $p *>$null
    icacls $p /reset /t /c /q *>$null
    cmd /c "del /q /s `"$p\*`"" *>$null
  }
  foreach($p in $temp_dirs){clean_dir($p)}
  try{ls $env:systemdrive\ -Include "*.log","*.tmp","*.dmp" -Force -s -File -ea 0|foreach{rf($_)}}catch{}
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
