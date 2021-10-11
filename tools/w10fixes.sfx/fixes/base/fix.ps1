$fc=$host.UI.RawUI.ForegroundColor

function write-header($text) {
    $host.UI.RawUI.ForegroundColor="green"
    Write-Output $text
    $host.UI.RawUI.ForegroundColor=$fc
}

function Set-Registry-ReadOnly($regpath) {
    Try{
        $acl = Get-Acl $regpath
        $acl.SetAccessRuleProtection($True, $True)
    }
    Catch { return }
    foreach ($a in $acl.Access) {
        Try{
            $u=$a.IdentityReference
            $propagation = $a.PropagationFlags
            $rule = New-Object System.Security.AccessControl.RegistryAccessRule($u, "ReadKey", @("ObjectInherit","ContainerInherit"), "None", "Allow")
            $acl.PurgeAccessRules($u)
            $acl.SetAccessRule($rule)
        }
       Catch {}
    }
    Try{
        Set-Acl -ErrorAction SilentlyContinue $regpath $acl | out-null;
    }
    Catch {}
}

function Takeown-File($path) {
    takeown.exe /A /F $path
    $acl = Get-Acl $path
    $admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $admins = $admins.Translate([System.Security.Principal.NTAccount])
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($admins, "FullControl", "None", "None", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl -Path $path -AclObject $acl
}

$apps = @(
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
    "Microsoft.Print3D"
    "Microsoft.MSPaint"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.Xbox.TCUI"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.DesktopAppInstaller"
    "Microsoft.StorePurchaseApp"
    "Windows.MiracastView"
    "Microsoft.YourPhone"
    "Microsoft.ScreenSketch"
    "Microsoft.MixedReality.Portal"
    "Microsoft.549981C3F5F10"
    "Microsoft.Todos"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.GamingApp"
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
    "Microsoft.Services.Store.Engagement"
)

$tasks = @(
    "\Microsoft\Windows\AppID\SmartScreenSpecific"
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
    "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    "\Microsoft\Windows\Feedback\Siuf\DmClient"
    "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
    "\Microsoft\Windows\Ras\MobilityManager"
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
    "\Microsoft\Windows\Speech\SpeechModelDownloadTask"
    "\Microsoft\Windows\Maps\MapsUpdateTask"
    "\Microsoft\Windows\Maps\MapsToastTask"
    "\Microsoft\Windows\DUSM\dusmtask"
    "\Microsoft\Windows\Defrag\ScheduledDefrag"
    "\Microsoft\Office\Office Automatic Updates"
    "\Microsoft\Office\Office ClickToRun Service Monitor"
    "\Microsoft\XblGameSave\XblGameSaveTask"
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
)

$root_tasks = @(
    "\MicrosoftEdgeUpdateTaskMachineCore"
    "\MicrosoftEdgeUpdateTaskMachineUA"
)

$tpaths = @(
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

$services = @(
    "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                # Diagnostics Tracking Service
    "dmwappushservice"                         # WAP Push Message Routing Service (see known issues)
    "lfsvc"                                    # Geolocation Service
    "MapsBroker"                               # Downloaded Maps Manager
    "RemoteAccess"                             # Routing and Remote Access
    "RemoteRegistry"                           # Remote Registry
    "SharedAccess"                             # Internet Connection Sharing (ICS)
    "TrkWks"                                   # Distributed Link Tracking Client
    "WbioSrvc"                                 # Windows Biometric Service
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
    "WSearch"                                  # Windows Search
    "XblAuthManager"                           # Xbox Live Auth Manager
    "XblGameSave"                              # Xbox Live Game Save Service
    "XboxNetApiSvc"                            # Xbox Live Networking Service
    "XboxGipSvc"
    "SSDPSRV"
    "BITS"
    "wuauserv"
    "MicrosoftEdgeElevationService"
    "MixedRealityOpenXRSvc"
    "edgeupdate"
    "edgeupdatem"
)

$bservices = @(
    "xbgm*"
    "OneSyncSvc*"
    "SecurityHealthService*"
)

$cleanflags = @(
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
    try{
        (Get-AppxPackage -Name "$app" -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue) | out-null;
        (Get-AppXProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object DisplayName -EQ "$app" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue) | out-null;
    }
    catch{
    };
}

function remove-apps() {
    write-header "Uninstalling default apps..."
    foreach ($app in $apps) {
        remove-app $app
    }
    Get-Job | Wait-Job
}

function remove-onedrive(){
    write-header "Removing OneDrive..."
    Write-Output "Kill OneDrive process"
    (taskkill.exe /F /IM "OneDrive.exe") | out-null
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
    # check if directory is empty before removing:
    If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
    }
    Write-Output "Remove Onedrive from explorer sidebar"
    (New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR") | out-null
    (mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}") | out-null
    (Set-ItemProperty "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0) | out-null
    (mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}") | out-null
    (Set-ItemProperty "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0) | out-null
    (Remove-PSDrive "HKCR") | out-null
    Write-Output "Removing run hook for new users"
    reg load "hku\Default" "C:\Users\Default\NTUSER.DAT" | out-null
    reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup" /f 2>&1 | out-null
    reg unload "hku\Default" | out-null
    reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup" /f 2>&1 | out-null
    Write-Output "Removing startmenu entry"
    Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
    Write-Output "Removing scheduled task"
    Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue | out-null
}

function fix-tasks(){
    write-header "Disabling some scheduled tasks..."
    foreach ($task in $tasks) {
        $parts = $task.split('\')
        $name = $parts[-1]
        $path = $parts[0..($parts.length-2)] -join '\'
        Disable-ScheduledTask -TaskName "$name" -TaskPath "$path" -ErrorAction SilentlyContinue
    }
}

function fix-root-tasks(){
    write-header "Disabling some scheduled root tasks..."
    foreach ($task in $root_tasks) {
        $parts = $task.split('\')
        $name = $parts[-1]
        Disable-ScheduledTask -TaskName "$name" -TaskPath "\" -ErrorAction SilentlyContinue
    }
}

function fix-tasks-files(){
    write-header "Removing some scheduled tasks..."
    foreach ($tpath in $tpaths) {
        Get-ChildItem -ErrorAction SilentlyContinue -Path "$env:systemroot$tpath" * | foreach {
            Takeown-File $_.FullName | out-null
            Remove-Item -ErrorAction SilentlyContinue -Path $_.FullName | out-null
        }
    }
}

function fix-services(){
    write-header "Disabling some services..."
    foreach ($service in $services) {
        Write-Output "Trying to disable $service"
        Get-Service -Name $service | Set-Service -StartupType Disabled
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

function fix-telemetry() {
    write-header "Disabling some telemetry..."
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 99 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v DisableSettingSync /t REG_DWORD /d 2 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v DisableSettingSyncUserOverride /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\FindMyDevice" /v AllowFindMyDevice /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v AllowBuildPreview /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites" /v Enabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Geolocation" /v PolicyDisableGeolocation /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v AllowOnlineTips /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v NoCloudApplicationNotification /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v ConfigureDoNotTrack /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HideFirstRunExperience /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v NewTabPageLocation /t REG_SZ /d "about:blank" /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v RestoreOnStartup /t REG_DWORD /d 5 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HomepageLocation /t REG_SZ /d "about:blank" /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HomepageIsNewTabPage /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\RestoreOnStartupURLs" /v "1" /t REG_SZ /d "about:blank" /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Internet Settings" /v ProvisionedHomePages /t REG_SZ /d "about:blank" /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v PreventFirstRunPage /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v DoNotTrack /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\ServiceUI" /v AllowWebContentOnNewTabPage /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\EdgeUpdate" /v UpdateDefault /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\EdgeUpdate" /v AutoUpdateCheckPeriodMinutes /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\EdgeUpdate" /v ExperimentationAndConfigurationServiceControl /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v NoActiveProbe /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsActivateWithVoice /t REG_DWORD /d "2" /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessPhone /t REG_DWORD /d "2" /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessMotion /t REG_DWORD /d "2" /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsGetDiagnosticInfo /t REG_DWORD /d "2" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v ModelDownloadAllowed /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v HasAccepted /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v PreventHandwritingDataSharing /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v PreventHandwritingErrorReports /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\EnhancedStorageDevices" /v TCGSecurityActivationDisabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v ChatIcon /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v DontSendAdditionalData /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v SafeSearchMode /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v IsMSACloudSearchEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v IsAADCloudSearchEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v IsDeviceSearchHistoryEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v AutoDownloadAndUpdateMapData /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\OneDrive" /v PreventNetworkTrafficPreUserSignIn /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana" /v value /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowIndexingEncryptedStoresOrItems /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowSearchToUseLocation /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AlwaysUseAutoLangDetection /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Telemetry" /v Enabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v Start /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v Start /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v Start /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisableUAR /t REG_DWORD /d 1 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Input\TIPC" /v Enabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager\config" /v AutoConnectAllowedOEM /t REG_DWORD /d 0 /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v EnableActiveProbing /t REG_DWORD /d 0 /f | out-null
    reg delete "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{77857D02-7A25-4B67-9266-3E122A8F39E4}" /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v 1001 /t REG_DWORD /d 3 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v 1004 /t REG_DWORD /d 3 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v 1001 /t REG_DWORD /d 3 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v 1004 /t REG_DWORD /d 3 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v 1001 /t REG_DWORD /d 3 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v 1004 /t REG_DWORD /d 3 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v 1001 /t REG_DWORD /d 3 /f | out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v 1004 /t REG_DWORD /d 3 /f | out-null

    reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v ModelDownloadAllowed /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v AgentActivationEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v AgentActivationOnLockScreenEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f | out-null
    reg add "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f | out-null
    reg add "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v Enabled /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f| out-null
    reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v PreventOverride /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge.stable_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge.stable_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v PreventOverride /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Edge\SmartScreenEnabled" /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Edge\SmartScreenPuaEnabled" /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CanCortanaBeEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v SafeSearchMode /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsMSACloudSearchEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsAADCloudSearchEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsDeviceSearchHistoryEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v Enabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v ContentDeliveryAllowed /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Messaging" /v CloudServiceSyncEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v Enabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v SensorPermissionState /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5}" /v SensorPermissionState /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v EnableWebContentEvaluation /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackDocs /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v PeopleBand /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{21157C1F-2651-4CC1-90CA-1F28B02263F6}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E390DF20-07DF-446D-B962-F5C953062741}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{235B668D-B2AC-4864-B49C-ED1084F6C9D3}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9D9E0118-1807-4F2E-96E4-2CE57142E196}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8c501030-f8c2-40b2-8b3b-e6605788ff39}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{B19F89AF-E3EB-444B-8DEA-202575A71599}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E83AF229-8640-4D18-A213-E22675EBB2C3}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{B1920448-233F-46CA-98E3-0839305F2141}" /v Value /t REG_SZ /d "Deny" /f | out-null
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v NoTileApplicationNotification /t REG_DWORD /d 1 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StartupNotify" /v EnableStartupAppNotification /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d "2" /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "about:blank" /f | out-null
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v DisableFirstRunCustomize /t REG_DWORD /d 1 /f | out-null
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Control Panel" /v HomePage /t REG_DWORD /d 1 /f | out-null
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\TabbedBrowsing" /v NewTabPageShow /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "about:blank" /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f | out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f | out-null

}

function cleanup(){
    #Disable system drive indexing
    $drive = Get-WmiObject -Class Win32_Volume -Filter "DriveLetter='$env:systemdrive'"
    $drive | Set-WmiInstance -Arguments @{IndexingEnabled=$False} | Out-Null
    write-header "Deleting system restore points..."
    vssadmin delete shadows /for=$env:systemdrive /all | Out-Null
    write-header "Deleting temporary folders..."
    if (test-path $env:systemdrive\Config.Msi) {remove-item -Path $env:systemdrive\Config.Msi -force -recurse}
    if (test-path $env:systemdrive\Intel) {remove-item -Path $env:systemdrive\Intel -force -recurse}
    if (test-path $env:systemdrive\PerfLogs) {remove-item -Path $env:systemdrive\PerfLogs -force -recurse}
    if (test-path $env:windir\memory.dmp) {remove-item $env:windir\memory.dmp -force}
    write-header "Deleting Windows error reporting files"
    if (test-path $env:systemdrive\ProgramData\Microsoft\Windows\WER) {Get-ChildItem -ErrorAction SilentlyContinue -Path $env:systemdrive\ProgramData\Microsoft\Windows\WER -Recurse | Remove-Item -ErrorAction SilentlyContinue -force -recurse}
    write-header "Removing system and user temporary Files"
    Remove-Item -Path "$env:windir\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:windir\minidump\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:windir\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\WER\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IECompatCache\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IECompatUaCache\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\IEDownloadHistory\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\INetCache\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Windows\INetCookies\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:systemdrive\Users\*\AppData\Local\Microsoft\Terminal Server Client\Cache\*" -Force -Recurse -ErrorAction SilentlyContinue
    write-header "Removing Windows updates downloads..."
    Stop-Service wuauserv -Force -Verbose -ErrorAction SilentlyContinue
    Stop-Service TrustedInstaller -Force -Verbose -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:windir\SoftwareDistribution\*" -Force -Recurse
    Remove-Item $env:windir\Logs\CBS\* -force -recurse
    Start-Service wuauserv -Verbose -ErrorAction SilentlyContinue
    Start-Service TrustedInstaller -Verbose -ErrorAction SilentlyContinue
    write-header "Running Windows system cleanup..."
    $StateFlags = 'StateFlags1234'
    $StateRun = $StateFlags.Substring($StateFlags.get_Length()-4)
    $StateRun = '/sagerun:' + $StateRun 
    foreach ($cleanflag in $cleanflags) {
        Set-ItemProperty -path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$cleanflag" -name $StateFlags -type DWORD -Value 2  -ErrorAction SilentlyContinue
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

function fix-taskbar(){
    write-header "Fixing taskbar view..."
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView" /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView" /v AllUpView /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f| out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f| out-null
}

function fix-tiles(){
    reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store" /f| out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f| out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideRecentlyAddedApps /t REG_DWORD /d 1 /f| out-null
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideRecentlyAddedApps /t REG_DWORD /d 1 /f| out-null
}

fix-taskbar
remove-apps
remove-onedrive
fix-tasks
fix-root-tasks
fix-tasks-files
fix-services
fix-bservices
fix-telemetry
fix-tiles
cleanup
