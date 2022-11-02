$fc=$host.UI.RawUI.ForegroundColor

function write-header($text) {
  $host.UI.RawUI.ForegroundColor="green"
  Write-Output $text
  $host.UI.RawUI.ForegroundColor=$fc
}

function Set-Registry-ReadOnly($regpath) {
  Try{
    $acl=Get-Acl $regpath
    $acl.SetAccessRuleProtection($True,$True)
  }
  Catch { return }
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
    Set-Acl -ErrorAction SilentlyContinue $regpath $acl | Out-Null
  }
  Catch {}
}

function Takeown-File($path) {
  takeown.exe /A /F $path
  $acl=Get-Acl $path
  $admins=New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
  $admins=$admins.Translate([System.Security.Principal.NTAccount])
  $rule=New-Object System.Security.AccessControl.FileSystemAccessRule($admins,"FullControl","None","None", "Allow")
  $acl.AddAccessRule($rule)
  Set-Acl -Path $path -AclObject $acl
}

$apps=@(
"Microsoft.3DBuilder"
"Microsoft.Appconnector"
"Microsoft.BingFinance"
"Microsoft.BingNews"
"Microsoft.BingSports"
"Microsoft.BingWeather"
"Microsoft.Getstarted"
"Microsoft.MicrosoftOfficeHub"
"Microsoft.MicrosoftSolitaireCollection"
"Microsoft.MicrosoftStickyNotes"
"Microsoft.Office.OneNote"
"Microsoft.OneConnect"
"Microsoft.People"
"Microsoft.SkypeApp"
"Microsoft.WindowsAlarms"
"Microsoft.WindowsCamera"
"Microsoft.WindowsMaps"
"Microsoft.WindowsPhone"
"Microsoft.WindowsSoundRecorder"
"Microsoft.WindowsStore"
"Microsoft.XboxApp"
"Microsoft.ZuneMusic"
"Microsoft.ZuneVideo"
"microsoft.windowscommunicationsapps"
"Microsoft.MinecraftUWP"
"Microsoft.MicrosoftPowerBIForWindows"
"Microsoft.NetworkSpeedTest"
"Microsoft.CommsPhone"
"Microsoft.ConnectivityStore"
"Microsoft.Messaging"
"Microsoft.Office.Sway"
"Microsoft.OneConnect"
"Microsoft.WindowsFeedbackHub"
"Microsoft.BingFoodAndDrink"
"Microsoft.BingTravel"
"Microsoft.BingHealthAndFitness"
"Microsoft.WindowsReadingList"
"Microsoft.GetHelp"
"Microsoft.Wallet"
"Microsoft.Paint"
"Microsoft.Print3D"
"Microsoft.MSPaint"
"Microsoft.XboxSpeechToTextOverlay"
"Microsoft.XboxGameOverlay"
"Microsoft.XboxGamingOverlay"
"Microsoft.XboxIdentityProvider"
"Microsoft.Xbox.TCUI"
"Microsoft.Microsoft3DViewer"
"Microsoft.StorePurchaseApp"
"Microsoft.YourPhone"
"Microsoft.ScreenSketch"
"Microsoft.MixedReality.Portal"
"Microsoft.549981C3F5F10"
"Microsoft.Todos"
"Microsoft.PowerAutomateDesktop"
"Microsoft.GamingApp"
"Microsoft.Services.Store.Engagement"
"Microsoft.Teams"
"Microsoft.Whiteboard"
"Microsoft.Windows.CapturePicker"
"MicrosoftTeams"
"Windows.MiracastView"
"Clipchamp.Clipchamp"
"MicrosoftCorporationII.QuickAssist"
"MicrosoftCorporationII.MicrosoftFamily"
"*yandex*"
"*netflix*"
"*sodasaga*"
"*twitter*"
"*sketchbook*"
"*bubblewitch*"
"*advertising*"
"*hpjumpstart*"
"*dropbox*"
"*amazon*"
"*marchofempires*"
"*powermediaplayer*"
"*.plex*"
"*saladgames*"
"*king.com*"
"*polarr*"
"*minecraft*"
"*dolbyaccess*"
)

$caps=@(
"Analog.Holographic.Desktop*"
"App.StepsRecorder*"
"App.Support.QuickAssist*"
"Language.Handwriting*"
"Language.OCR*"
"MathRecognizer*"
"Media.WindowsMediaPlayer*"
"OneCoreUAP.OneSync*"
)

$tasks=@(
"\Microsoft\Office\Office Automatic Updates"
"\Microsoft\Office\Office ClickToRun Service Monitor"
"\Microsoft\Windows\AppID\SmartScreenSpecific"
"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
"\Microsoft\Windows\Application Experience\ProgramDataUpdater"
"\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
"\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
"\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
"\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
"\Microsoft\Windows\Defrag\ScheduledDefrag"
"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
"\Microsoft\Windows\DUSM\dusmtask"
"\Microsoft\Windows\Feedback\Siuf\DmClient"
"\Microsoft\Windows\LanguageComponentsInstaller\Installation"
"\Microsoft\Windows\LanguageComponentsInstaller\ReconcileLanguageResources"
"\Microsoft\Windows\Management\Provisioning\Cellular"
"\Microsoft\Windows\Management\Provisioning\Logon"
"\Microsoft\Windows\Maps\MapsToastTask"
"\Microsoft\Windows\Maps\MapsUpdateTask"
"\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
"\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
"\Microsoft\Windows\Ras\MobilityManager"
"\Microsoft\Windows\Speech\SpeechModelDownloadTask"
"\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
"\Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
"\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
"\Microsoft\Windows\Windows Defender\Windows Defender Verification"
"\Microsoft\Windows\Windows Error Reporting\QueueReporting"
"\Microsoft\Windows\WindowsUpdate\Scheduled Start"
"\Microsoft\XblGameSave\XblGameSaveTask"
)

$root_tasks=@(
"\MicrosoftEdgeUpdateTaskMachineCore"
"\MicrosoftEdgeUpdateTaskMachineUA"
)

$tpaths=@(
"\WaaS\services"
"\WaaS\tasks"
"\System32\Tasks\Microsoft\Windows\Customer Experience Improvement Program"
"\System32\Tasks\Microsoft\Windows\Feedback\Siuf"
"\System32\Tasks\Microsoft\Windows\InstallService"
"\System32\Tasks\Microsoft\Windows\Setup"
"\System32\Tasks\Microsoft\Windows\SyncCenter"
"\System32\Tasks\Microsoft\Windows\UNP"
"\System32\Tasks\Microsoft\Windows\Windows Error Reporting"
"\System32\Tasks_Migrated\Microsoft\Windows\InstallService"
"\System32\Tasks_Migrated\Microsoft\Windows\Setup"
"\System32\Tasks_Migrated\Microsoft\Windows\UNP"
"\System32\Tasks_Migrated\Microsoft\Windows\Windows Error Reporting"
"\System32\Tasks_Migrated\Microsoft\Windows\Windows Media Sharing"
)

$services=@(
"diagnosticshub.standardcollector.service"
"DiagTrack"
"dmwappushservice"
"lfsvc"
"MapsBroker"
"RemoteAccess"
"RemoteRegistry"
"SharedAccess"
"TrkWks"
"WbioSrvc"
"WMPNetworkSvc"
"WSearch"
"XblAuthManager"
"XblGameSave"
"XboxNetApiSvc"
"XboxGipSvc"
"SmsRouter"
"SSDPSRV"
"WerSvc"
"BITS"
"wuauserv"
"UsoSvc"
"MicrosoftEdgeElevationService"
"MixedRealityOpenXRSvc"
"edgeupdate"
"edgeupdatem"
)

$bservices=@(
"xbgm*"
"OneSyncSvc*"
)

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

function remove-app($app) {
  Write-Output "Trying to remove $app"
  Try{
    Start-Job -Name remappx -ScriptBlock {(Get-AppxPackage -Name "$using:app" -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue) | Out-Null} | Out-Null
    (Get-Job | Wait-Job) | Out-Null
    Start-Job -Name remappxp -ScriptBlock {(Get-AppXProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object DisplayName -EQ "$using:app" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue) | Out-Null} | Out-Null
    (Get-Job | Wait-Job) | Out-Null
  }
  Catch {}
}

function remove-cap($app) {
  Write-Output "Trying to remove $app"
  Try{
    Start-Job -Name remcap -ScriptBlock {(Get-WindowsCapability -Online -Name "$using:app" -ErrorAction SilentlyContinue | Where-Object State -EQ "Installed" | Remove-WindowsCapability -Online -ErrorAction SilentlyContinue) | Out-Null} | Out-Null
    (Get-Job | Wait-Job) | Out-Null
  }
  Catch {}
}

function remove-apps() {
  write-header "Uninstalling default apps..."
  Remove-Item $env:windir\Logs\CBS\* -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  foreach ($app in $apps) {
    remove-app $app
  }
  Start-Job -Name feature -ScriptBlock {Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue | Out-Null} | Out-Null
  (Get-Job | Wait-Job) | Out-Null
  Start-Job -Name feature -ScriptBlock {Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Deprecation -NoRestart -ErrorAction SilentlyContinue | Out-Null} | Out-Null
  (Get-Job | Wait-Job) | Out-Null
  Start-Job -Name feature -ScriptBlock {Disable-WindowsOptionalFeature -Online -FeatureName WorkFolders-Client -NoRestart  -ErrorAction SilentlyContinue | Out-Null} | Out-Null
  (Get-Job | Wait-Job) | Out-Null
  Start-Job -Name feature -ScriptBlock {Disable-WindowsOptionalFeature -Online -FeatureName WindowsMediaPlayer -NoRestart  -ErrorAction SilentlyContinue | Out-Null} | Out-Null
  (Get-Job | Wait-Job) | Out-Null
  $pkgs=(dism /online /get-packages | select-string -pattern 'package' | %{ $_.tostring(); } | %{ $_ -split ' : '; } )
  $pkgs=($pkgs | select-string -pattern 'package' | %{ $_.tostring(); } )
  $pkgs | select-string -pattern 'hello-face' | %{ $_.tostring(); } | %{(dism /online /remove-package /packagename:$_ /quiet /norestart 2>&1)|out-null ;}
  foreach ($app in $caps) {
    remove-cap $app
  }
  (Get-Job | Wait-Job) | Out-Null
}

function remove-onedrive(){
  write-header "Removing OneDrive..."
  Write-Output "Kill OneDrive process"
  (taskkill.exe /F /IM "OneDrive.exe") 2>&1 | Out-Null
  Write-Output "Remove OneDrive"
  if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
  }
  if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
  }
  Write-Output "Removing OneDrive leftovers"
  Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
  Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
  Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:systemdrive\OneDriveTemp"
  If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
  }
  Write-Output "Remove Onedrive from explorer sidebar"
  (New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR") | Out-Null
  (mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}") | Out-Null
  (Set-ItemProperty "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0) | Out-Null
  (mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}") | Out-Null
  (Set-ItemProperty "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0) | Out-Null
  (Remove-PSDrive "HKCR") | Out-Null
  Write-Output "Removing run hook for new users"
  reg load "hku\Default" "C:\Users\Default\NTUSER.DAT" | Out-Null
  reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /f 2>&1 | Out-Null
  reg unload "hku\Default" | Out-Null
  reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /f 2>&1 | Out-Null
  Write-Output "Removing startmenu entry"
  Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
  Write-Output "Removing scheduled task"
  Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
}

function fix-tasks(){
  write-header "Disabling some scheduled tasks..."
  foreach ($task in $tasks) {
    $parts=$task.split('\')
    $name=$parts[-1]
    $path=$parts[0..($parts.length-2)] -join '\'
    Disable-ScheduledTask -TaskName "$name" -TaskPath "$path" -ErrorAction SilentlyContinue | Out-Null
  }
}

function fix-root-tasks(){
  write-header "Disabling some scheduled root tasks..."
  foreach ($task in $root_tasks) {
    $parts=$task.split('\')
    $name=$parts[-1]
    Disable-ScheduledTask -TaskName "$name" -TaskPath "\" -ErrorAction SilentlyContinue | Out-Null
  }
}

function fix-tasks-files(){
  write-header "Removing some scheduled tasks..."
  foreach ($tpath in $tpaths) {
    Get-ChildItem -ErrorAction SilentlyContinue -Path "$env:systemroot$tpath" * | foreach {
      Takeown-File $_.FullName | Out-Null
      Remove-Item -ErrorAction SilentlyContinue -Path $_.FullName | Out-Null
    }
  }
}

function fix-services(){
  write-header "Disabling some services..."
  foreach ($service in $services) {
    Write-Output "Trying to disable $service"
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue | Out-Null
  }
}

function fix-bservices() {
  write-header "Disabling some bad services..."
  foreach ($bservice in $bservices) {
    Write-Output "Trying to disable $bservice"
    Set-ItemProperty -ErrorAction SilentlyContinue "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice" "Start" 4
    Set-Registry-ReadOnly "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice"
  }
}

function rdw($path,$key,$val) {
  reg add $path /v $key /t REG_DWORD /d $val /f | Out-Null
}

function rsz($path,$key,$val) {
  reg add $path /v $key /t REG_SZ /d $val /f | Out-Null
}

$reg_dw=@(
@("HKCU\Control Panel\International\User Profile","HttpAcceptLanguageOptOut",1),
@("HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter","EnabledV9",0),
@("HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter","PreventOverride",0),
@("HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge.stable_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter","EnabledV9",0),
@("HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge.stable_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter","PreventOverride",0),
@("HKCU\SOFTWARE\Microsoft\InputPersonalization","RestrictImplicitInkCollection",1),
@("HKCU\SOFTWARE\Microsoft\InputPersonalization","RestrictImplicitTextCollection",1),
@("HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore","HarvestContacts",0),
@("HKCU\SOFTWARE\Microsoft\Input\TIPC","Enabled",0),
@("HKCU\SOFTWARE\Microsoft\Messaging","CloudServiceSyncEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Personalization\Settings","AcceptedPrivacyPolicy",0),
@("HKCU\SOFTWARE\Microsoft\Siuf\Rules","NumberOfSIUFInPeriod",0),
@("HKCU\SOFTWARE\Microsoft\Siuf\Rules","PeriodInNanoSeconds",0),
@("HKCU\SOFTWARE\Microsoft\Speech_OneCore\Preferences","ModelDownloadAllowed",0),
@("HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps","AgentActivationEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps","AgentActivationOnLockScreenEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications","GlobalUserDisabled",1),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager","ContentDeliveryAllowed",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager","RotatingLockScreenEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager","RotatingLockScreenOverlayEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager","SilentInstalledAppsEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager","SoftLandingEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager","SystemPaneSuggestionsEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People","PeopleBand",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced","ShowSyncProviderNotifications",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced","TaskbarAl",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced","TaskbarMn",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer","ShowFrequent",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds","IsFeedsAvailable",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds","ShellFeedsTaskbarViewMode",2),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds","ShellFeedsTaskbarOpenOnHover",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance","Enabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel","Enabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy","TailoredExperiencesWithDiagnosticDataEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search","BingSearchEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search","CanCortanaBeEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search","CortanaConsent",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search","CortanaEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings","IsAADCloudSearchEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings","IsDeviceSearchHistoryEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings","IsMSACloudSearchEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings","SafeSearchMode",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StartupNotify","EnableStartupAppNotification",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement","ScoobeSystemSettingEnabled",0),
@("HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}","SensorPermissionState",0),
@("HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5}","SensorPermissionState",0),
@("HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization","RestrictImplicitInkCollection",1),
@("HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization","RestrictImplicitTextCollection",1),
@("HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization\TrainedDataStore","HarvestContacts",0),
@("HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Control Panel","HomePage",1),
@("HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main","DisableFirstRunCustomize",1),
@("HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\TabbedBrowsing","NewTabPageShow",0),
@("HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications","NoTileApplicationNotification",1),
@("HKLM\SOFTWARE\Microsoft\InputPersonalization","RestrictImplicitInkCollection",1),
@("HKLM\SOFTWARE\Microsoft\InputPersonalization","RestrictImplicitTextCollection",1),
@("HKLM\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore","HarvestContacts",0),
@("HKLM\SOFTWARE\Microsoft\Input\TIPC","Enabled",0),
@("HKLM\SOFTWARE\Microsoft\OneDrive","PreventNetworkTrafficPreUserSignIn",1),
@("HKLM\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana","value",0),
@("HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences","ModelDownloadAllowed",0),
@("HKLM\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy","HasAccepted",0),
@("HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager\config","AutoConnectAllowedOEM",0),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer","AllowOnlineTips",0),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search","CortanaEnabled",0),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Telemetry","Enabled",0),
@("HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting","Disabled",1),
@("HKLM\SOFTWARE\Microsoft\Windows Search","AllowCortana",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","ConfigureDoNotTrack",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge\EdgeUpdate","AutoUpdateCheckPeriodMinutes",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge\EdgeUpdate","ExperimentationAndConfigurationServiceControl",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge\EdgeUpdate","UpdateDefault",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","HideFirstRunExperience",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","HomepageIsNewTabPage",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","RestoreOnStartup",5),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","StartupBoostEnabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization","RestrictImplicitInkCollection",1),
@("HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization","RestrictImplicitTextCollection",1),
@("HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization\TrainedDataStore","HarvestContacts",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Geolocation","PolicyDisableGeolocation",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites","Enabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main","DoNotTrack",1),
@("HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main","PreventFirstRunPage",1),
@("HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\ServiceUI","AllowWebContentOnNewTabPage",0),
@("HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows","CEIPEnable",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo","DisabledByGroupPolicy",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo","Enabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat","AITEnable",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat","DisableUAR",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy","LetAppsAccessMotion",2),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy","LetAppsAccessPhone",2),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy","LetAppsActivateWithVoice",2),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy","LetAppsGetDiagnosticInfo",2),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent","DisableSoftLanding",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent","DisableWindowsConsumerFeatures",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent","DisableWindowsSpotlightFeatures",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0","1001",3),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0","1004",3),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1","1001",3),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1","1004",3),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2","1001",3),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2","1004",3),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3","1001",3),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3","1004",3),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications","NoCloudApplicationNotification",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection","AllowTelemetry",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection","DisableOneSettingsDownloads",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection","DoNotShowFeedbackNotifications",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization","DODownloadMode",99),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\EnhancedStorageDevices","TCGSecurityActivationDisabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer","DisableSearchBoxSuggestions",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\FindMyDevice","AllowFindMyDevice",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports","PreventHandwritingErrorReports",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps","AutoDownloadAndUpdateMapData",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator","NoActiveProbe",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive","DisableFileSyncNGSC",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds","AllowBuildPreview",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync","DisableSettingSync",2),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync","DisableSettingSyncUserOverride",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","EnableActivityFeed",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","PublishUserActivities",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","UploadUserActivities",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","AllowCrossDeviceClipboard",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC","PreventHandwritingDataSharing",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat","ChatIcon",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting","Disabled",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting","DontSendAdditionalData",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds","EnableFeeds",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","AllowCortana",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","AllowIndexingEncryptedStoresOrItems",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","AllowSearchToUseLocation",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","AlwaysUseAutoLangDetection",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","ConnectedSearchUseWeb",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","DisableWebSearch",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","IsAADCloudSearchEnabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","IsDeviceSearchHistoryEnabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","IsMSACloudSearchEnabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","SafeSearchMode",0),
@("HKLM\SOFTWARE\Policies\Microsoft\WindowsStore","AutoDownload",2),
@("HKLM\SOFTWARE\Policies\Microsoft\WindowsStore\WindowsUpdate","AutoDownload",2),
@("HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener","Start",0),
@("HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger","Start",0),
@("HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet","EnableActiveProbing",0)
)

$reg_sz=@(
@("HKCU\SOFTWARE\Microsoft\Internet Explorer\Main","Start Page","about:blank"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{21157C1F-2651-4CC1-90CA-1F28B02263F6}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{235B668D-B2AC-4864-B49C-ED1084F6C9D3}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8c501030-f8c2-40b2-8b3b-e6605788ff39}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9D9E0118-1807-4F2E-96E4-2CE57142E196}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{B1920448-233F-46CA-98E3-0839305F2141}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{B19F89AF-E3EB-444B-8DEA-202575A71599}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E390DF20-07DF-446D-B962-F5C953062741}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E83AF229-8640-4D18-A213-E22675EBB2C3}","Value","Deny"),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled","Value","Deny"),
@("HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main","Start Page","about:blank"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener","Value","Deny"),
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary","Value","Deny"),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","HomepageLocation","about:blank"),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","NewTabPageLocation","about:blank"),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge\RestoreOnStartupURLs","1","about:blank"),
@("HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Internet Settings","ProvisionedHomePages","about:blank")
)

function fix-registry() {
  write-header "Tuning registry keys..."
  foreach ($r in $reg_dw) {
    rdw $r[0] $r[1] $r[2]
  }
  foreach ($r in $reg_sz) {
    rsz $r[0] $r[1] $r[2]
  }
  reg delete "HKCR\ms-msdt" /f 2>&1 | Out-Null
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnostics" EnableDiagnostics 0
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnostics" DisableQueryRemoteServer 0
  reg delete "HKCR\search-ms" /f 2>&1 | Out-Null
  reg delete "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{77857D02-7A25-4B67-9266-3E122A8F39E4}" /f 2>&1 | Out-Null
  reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store" /f 2>&1 | Out-Null
}

$prg_list=@(
"%SystemRoot%\System32\SIHClient.exe"
"%SystemRoot%\System32\mousocoreworker.exe"
"%SystemRoot%\UUS\amd64\MoUsoCoreWorker.exe"
"%SystemRoot%\System32\Speech_OneCore\common\SpeechRuntime.exe"
"%SystemRoot%\System32\OneDriveSetup.exe"
"%SystemRoot%\ImmersiveControlPanel\SystemSettings.exe"
"%SystemRoot%\explorer.exe"
)

function fix-network() {
  write-header "Adding firewall rules..."
  foreach ($p in $prg_list) {
    Remove-NetFirewallRule -DisplayName "$p block-internet" -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -Program "$p" -DisplayName "$p block-internet" -Direction Outbound -RemoteAddress Internet -Action Block -ErrorAction SilentlyContinue | Out-Null
  }
}

function cleanup(){
  $drive=Get-WmiObject -Class Win32_Volume -Filter "DriveLetter='$env:systemdrive'"
  $drive | Set-WmiInstance -Arguments @{IndexingEnabled=$False} | Out-Null
  write-header "Deleting system restore points..."
  vssadmin delete shadows /for=$env:systemdrive /all | Out-Null
  write-header "Deleting temporary folders..."
  if (test-path $env:systemdrive\Config.Msi) {Remove-Item -Path $env:systemdrive\Config.Msi -Force -Recurse}
  if (test-path $env:systemdrive\Intel) {Remove-Item -Path $env:systemdrive\Intel -Force -Recurse}
  if (test-path $env:systemdrive\PerfLogs) {Remove-Item -Path $env:systemdrive\PerfLogs -Force -Recurse}
  if (test-path $env:windir\memory.dmp) {Remove-Item $env:windir\memory.dmp -Force}
  write-header "Deleting Windows error reporting files"
  if (test-path $env:systemdrive\ProgramData\Microsoft\Windows\WER) {Get-ChildItem -ErrorAction SilentlyContinue -Path $env:systemdrive\ProgramData\Microsoft\Windows\WER -Recurse | Remove-Item -ErrorAction SilentlyContinue -Force -Recurse 2>&1 | Out-Null}
  write-header "Removing system and user temporary Files"
  try{
    Get-ChildItem $env:systemdrive\ -Include @("*.log","*.tmp","*.dmp") -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue | Out-Null
  }catch{}
  Remove-Item -Path "$env:windir\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:windir\minidump\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:windir\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\WER\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IECompatCache\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IECompatUaCache\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IEDownloadHistory\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  try{
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\INetCache\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  }catch{}
  Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\INetCookies\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Terminal Server Client\Cache\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  write-header "Removing Windows updates downloads..."
  Stop-Service wuauserv -Force -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Stop-Service TrustedInstaller -Force -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Remove-Item -Path "$env:windir\SoftwareDistribution\*" -Force -Recurse -ErrorAction SilentlyContinue 2>&1 | Out-Null
  Start-Service TrustedInstaller -ErrorAction SilentlyContinue 2>&1 | Out-Null
  write-header "Running Windows system cleanup..."
  $StateFlags='StateFlags1234'
  $StateRun=$StateFlags.Substring($StateFlags.get_Length()-4)
  $StateRun='/sagerun:' + $StateRun 
  foreach ($cleanflag in $cleanflags) {
    Start-Job -Name regprop -ScriptBlock {Set-ItemProperty -path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$using:cleanflag" -name $using:StateFlags -type DWORD -Value 2 -ErrorAction SilentlyContinue} | Out-Null
    (Get-Job | Wait-Job) | Out-Null
  }
  Start-Process -FilePath CleanMgr.exe -ArgumentList $StateRun  -WindowStyle Hidden -Wait
  write-header "Clearing all event logs..."
  wevtutil el | Foreach-Object {Write-Host "Clearing $_"; wevtutil cl "$_"}
  foreach ($cleanflag in $cleanflags) {
    Remove-ItemProperty -path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$cleanflag" -name $StateFlags -ErrorAction SilentlyContinue
  }
  Remove-Item "C:\ProgramData\Microsoft\Windows Defender\Scans\mpenginedb.db" -ErrorAction SilentlyContinue
  fsutil usn deletejournal /n $env:systemdrive | Out-Null
} 

function fix-view(){
  write-header "Fixing view..."
  rdw "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" ShowTaskViewButton 0
  rdw "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" Start_Layout 1
  rdw "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" Start_TrackDocs 0
  rdw "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" Start_TrackProgs 0
  rdw "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView" AllUpView 0
  rdw "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" HideSCAMeetNow 1
  rdw "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" SearchboxTaskbarMode 0
  rdw "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" HideRecentlyAddedApps 1
  rdw "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" HideRecommendedSection 1
  rdw "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" HideSCAMeetNow 1
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Dsh" AllowNewsAndInterests 0
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" HideRecentlyAddedApps 1
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" HideRecommendedSection 1
  $Bags="HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags"
  $DLID="{885A186E-A440-4ADA-812B-DB871B942259}"
  (Get-ChildItem $bags -recurse | ? PSChildName -eq $DLID ) | Remove-Item -Force -ErrorAction SilentlyContinue 2>&1 | Out-Null
  rdw "HKLM\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{885A186E-A440-4ADA-812B-DB871B942259}" Mode 4
  rdw "HKLM\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{885A186E-A440-4ADA-812B-DB871B942259}" GroupView 0
  Try{
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" 2>&1 | Out-Null
  }
  Catch {}
  Try{
    Start-Process wt.exe -WindowStyle hidden 2>&1 | Out-Null
    Start-Sleep -s 5
    $r=(Get-Content "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Encoding UTF8 -ErrorAction SilentlyContinue) -replace "^\s*\/\/.*" | Out-String -ErrorAction SilentlyContinue
    $j=(ConvertFrom-Json -InputObject $r -ErrorAction SilentlyContinue)
    $j.profiles.list | % {if($_.name -eq "Azure Cloud Shell"){$_.hidden=[boolean]"true"}}
    $j | ConvertTo-Json -depth 32  -ErrorAction SilentlyContinue | Set-Content "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Encoding UTF8 -ErrorAction SilentlyContinue
  }
  Catch {}
}

function fix-tiles(){
  Import-StartLayout -LayoutPath "$env:systemdrive\fixes\base\layout.xml" -MountPath "$env:systemdrive\" -ErrorAction SilentlyContinue | Out-Null
  reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" /f 2>&1 | Out-Null
  rdw "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\StoreInit" HasStoreCacheInitialized 0
  (taskkill.exe /F /IM "StartMenuExperienceHost.exe") 2>&1 | Out-Null
}

fix-view
remove-apps
remove-onedrive
fix-tasks
fix-root-tasks
fix-tasks-files
fix-services
fix-bservices
fix-registry
fix-network
fix-tiles
cleanup
