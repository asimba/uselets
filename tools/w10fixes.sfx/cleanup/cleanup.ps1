$fc=$host.UI.RawUI.ForegroundColor

function write-header($text) {
  $host.UI.RawUI.ForegroundColor="green"
  write $text
  $host.UI.RawUI.ForegroundColor=$fc
}

$cleanflags=@(
"Active Setup Temp Folders"
"BranchCache"
"Content Indexer Cleaner"
"D3D Shader Cache"
"Delivery Optimization Files"
"Device Driver Packages"
"Downloaded Program Files"
"GameNewsFiles"
"GameStatisticsFiles"
"GameUpdateFiles"
"Internet Cache Files"
"Offline Pages Files"
"Old ChkDsk Files"
"Previous Installations"
"Memory Dump Files"
"Recycle Bin"
"Service Pack Cleanup"
"Setup Log Files"
"System error memory dump files"
"System error minidump files"
"Temporary Files"
"Temporary Setup Files"
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
"$env:windir\SoftwareDistribution\*"
"$env:windir\servicing\LCU\*"
"$env:windir\Temp\*"
"$env:windir\memory.dmp"
"$env:windir\minidump\*"
"$env:windir\Prefetch\*"
"$env:windir\Logs\CBS\*"
"$env:windir\Logs\DISM\*"
"$env:windir\Logs\PLUG\*"
"$env:windir\Logs\SIH\*"
"$env:windir\Logs\waasmedic\*"
"$env:windir\Logs\waasmediccapsule\*"
"$env:windir\Logs\WindowsUpdate\*"
"$env:systemdrive\Users\*\AppData\Local\Temp\*"
"$env:systemdrive\ProgramData\Microsoft\Windows\WER\*"
"$env:systemdrive\ProgramData\Microsoft\Windows Defender\Scans\mpcache*.bin"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\WER\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\INetCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IECompatCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IECompatUaCache\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IEDownloadHistory\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\INetCookies\*"
"$env:systemdrive\Users\*\AppData\Local\Microsoft\Terminal Server Client\Cache\*"
"$env:systemdrive\`$SysReset"
"$env:systemdrive\`$WinREAgent"
"$env:systemdrive\Config.Msi"
"$env:systemdrive\Intel"
"$env:systemdrive\PerfLogs"
)

$acl_reset_dirs=@(
"$env:windir\Logs\waasmedic"
)

function clean_dir($path){
  if (!(Test-Path -LiteralPath $path -Type leaf)){
    try{
      if (Test-Path -Path $path){
        foreach($f in (ls -Path $path -Force)){
          if (Test-Path -LiteralPath $f -Type leaf){                        
            try{
              Write-Host "Trying to remove file     : `"$f`""
              rm $f -Force -ea 0 2>&1 | Out-Null
            }catch{}
          }
          else{
            Write-Host "Trying to remove directory: `"$f`""
            cmd.exe /c "rd /q /s `"$($f.FullName)`"" 2>&1 | Out-Null
          }
        }
      }
    }catch{}
  }
  if (Test-Path -LiteralPath $path){                        
    try{
      Write-Host "Trying to remove file     : `"$path`""
      rm $path -Force -ea 0 2>&1 | Out-Null
    }catch{}
  }
}

function cleanup(){
  write-header "Windows components cleanup..."
  Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase /NoRestart /Quiet
  write-header "Disabling Windows reserved storage..."
  Dism /Online /Set-ReservedStorageState /State:Disabled /NoRestart /Quiet
  write-header "Deleting system restore points..."
  vssadmin delete shadows /for=$env:systemdrive /all /quiet 2>&1 | Out-Null
  spsv wuauserv -Force -ea 0 2>&1 | Out-Null
  spsv TrustedInstaller -Force -ea 0 2>&1 | Out-Null
  write-header "Deleting temporary folders and files..."
  foreach($p in $acl_reset_dirs) {
    takeown /a /f $p 2>&1 | Out-Null
    icacls $p /reset /t /c /q 2>&1 | Out-Null
    cmd.exe /c "del /q /s `"$p\*`"" 2>&1 | Out-Null
  }
  foreach($p in $temp_dirs) { clean_dir($p) }
  try{
    ls $env:systemdrive\ -Include "*.log","*.tmp","*.dmp" -Force -s -File -ea 0 | foreach {
      Write-Host "Trying to remove file     : `"$_`""
      try{ rm $_ -Force -ea 0 2>&1 | Out-Null } catch {}
    }
  }catch{}
  sasv TrustedInstaller -ea 0 2>&1 | Out-Null
  write-header "Running Windows system cleanup..."
  $StateFlags='StateFlags1234'
  $StateRun=$StateFlags.Substring($StateFlags.get_Length()-4)
  $StateRun='/sagerun:' + $StateRun 
  foreach ($cleanflag in $cleanflags) {
    sajb -Name regprop -ScriptBlock {sp -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$using:cleanflag" -Name $using:StateFlags -Type DWORD -Value 2 -ea 0  2>&1 | Out-Null }  2>&1 | Out-Null
    (gjb | wjb) | Out-Null
  }
  saps -FilePath CleanMgr.exe -ArgumentList $StateRun -WindowStyle 1 -Wait
  foreach ($cleanflag in $cleanflags) {
    rp -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$cleanflag" -Name $StateFlags -ea 0 2>&1 | Out-Null
  }
  write-header "Deleting system notifications..."
  [Windows.UI.Notifications.ToastNotificationManager,Windows.UI.Notifications,ContentType=WindowsRuntime] | Out-Null
  $notifications=ls -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" | select -ExpandProperty Name
  foreach ($notification in $notifications){ 
    $lastRegistryKeyName=($notification -split "\\")[-1] -replace "\\$"
    [Windows.UI.Notifications.ToastNotificationManager]::History.Clear($lastRegistryKeyName)
  }
  write-header "Clearing all event logs..."
  wevtutil el | foreach { Write-Host "Clearing $_"; wevtutil cl "$_" 2>&1 | Out-Null }
  write-header "Clearing filesystem journal..."
  fsutil usn deletejournal /n $env:systemdrive | Out-Null
  write-header "Windows system drive defragmentation..."
  defrag $env:systemdrive /H /X /V /U
} 

cleanup
exit
