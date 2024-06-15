$reg_dw=@(
@("HKCU\SOFTWARE\Microsoft\Edge","SmartScreenEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Edge","SmartScreenPuaEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows Defender","DisableAntiSpyware",1),
@("HKCU\SOFTWARE\Microsoft\Windows Defender","DisableAntiVirus",1),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost","EnableWebContentEvaluation",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance","Enabled",0),
@("HKLM\SOFTWARE\Microsoft\Windows Defender","DisableAntiSpyware",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender","DisableAntiVirus",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender","ServiceStartStates",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Features","DisableCoreService1DSTelemetry",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Features","DisableCoreServiceECSIntegration",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Features","TamperProtection",0),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection","DisableBehaviorMonitoring",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection","DisableIOAVProtection",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection","DisableOnAccessProtection",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection","DisableRealtimeMonitoring",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection","DisableRoutinelyTakingAction",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection","DisableScanOnRealtimeEnable",1),
@("HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection","DpaDisabled",1),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation","Enabled",0),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation","PreventOverride",0),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock","AllowDevelopmentWithoutDevLicense",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","SmartScreenEnabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter","EnabledV9",0),
@("HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter","EnabledV9",0),
@("HKLM\SOFTWARE\Policies\Microsoft\MRT","DontReportInfectionInformation",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications","DisableEnhancedNotifications",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications","DisableNotifications",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender","AllowFastServiceStartup",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender","DisableAntiSpyware",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender","DisableAntiVirus",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender","DisableRealtimeMonitoring",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender","DisableSpecialRunningModes",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender","ServiceKeepAlive",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Features","DisableCoreService1DSTelemetry",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Features","DisableCoreServiceECSIntegration",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine","MpEnablePus",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection","DisableBehaviorMonitoring",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection","DisableIOAVProtection",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection","DisableOnAccessProtection",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection","DisableRealtimeMonitoring",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection","DisableRoutinelyTakingAction",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection","DisableScanOnRealtimeEnable",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection","DpaDisabled",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting","DisableEnhancedNotifications",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen","ConfigureAppInstallControlEnabled",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet","DisableBlockAtFirstSeen",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet","SpyNetReporting",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet","SubmitSamplesConsent",2),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx","AllowDevelopmentWithoutDevLicense",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion","EnableWebContentEvaluation",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard","EnableVirtualizationBasedSecurity",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard","LsaCfgFlags",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard","RequirePlatformSecurityFeatures",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","EnableSmartScreen",0),
@("HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy","VerifiedAndReputablePolicyState",0),
@("HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard","EnableVirtualizationBasedSecurity",0),
@("HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard","RequirePlatformSecurityFeatures",0),
@("HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity","Enabled",0),
@("HKLM\SYSTEM\CurrentControlSet\Control\Lsa","LsaCfgFlags",0),
@("HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger","Start",0),
@("HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger","Start",0)
)

$bservices=@(
"SecurityHealthService*"
"WinDefend*"
"WdNisSvc"
"WdNisDrv"
"WdBoot"
"MDCoreSvc"
"WdFilter"
"webthreatdefsvc"
"webthreatdefusersvc*"
"Sense"
)

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

function fix-services() {
  foreach ($bservice in $bservices) {
    Set-ItemProperty -ErrorAction SilentlyContinue "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice" "Start" 4 | Out-Null
    Set-Registry-ReadOnly "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice"
  }
}

function rdw($path,$key,$val) {
  reg add $path /v $key /t REG_DWORD /d $val /f | Out-Null
}

function rsz($path,$key,$val) {
  reg add $path /v $key /t REG_SZ /d $val /f | Out-Null
}

function fix-registry() {
  foreach ($r in $reg_dw) {
    rdw $r[0] $r[1] $r[2]
  }
  rsz "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" "ConfigureAppInstallControl" "Anywhere"
  rsz "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "SmartScreenEnabled" "Off"
  reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /f | Out-Null
  reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SecurityHealth /f | Out-Null
  Remove-Item "C:\ProgramData\Microsoft\Windows Defender\Scans\mpenginedb.db" -ErrorAction SilentlyContinue | Out-Null
}

fix-services
fix-registry
