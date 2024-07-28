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
"Microsoft.People"
"Microsoft.SkypeApp"
"Microsoft.WindowsAlarms"
"Microsoft.WindowsCamera"
"Microsoft.WindowsMaps"
"Microsoft.WindowsPhone"
"Microsoft.WindowsSoundRecorder"
"Microsoft.WindowsStore"
"Microsoft.Windows.DevHome"
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
"Microsoft.OutlookForWindows"
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
"Microsoft.Teams"
"Microsoft.Whiteboard"
"Microsoft.Windows.CapturePicker"
"Microsoft.Windows.Photos"
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
"Microsoft.Services.Store.Engagement*"
"MicrosoftWindows.Client.WebExperience*"
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
"\Microsoft\Windows\Application Experience\MareBackup"
"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
"\Microsoft\Windows\Application Experience\ProgramDataUpdater"
"\Microsoft\Windows\Autochk\Proxy"
"\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
"\Microsoft\Windows\CloudRestore\Backup"
"\Microsoft\Windows\CloudRestore\Restore"
"\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
"\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
"\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
"\Microsoft\Windows\Defrag\ScheduledDefrag"
"\Microsoft\Windows\Device Information\Device"
"\Microsoft\Windows\Device Information\Device User"
"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
"\Microsoft\Windows\DUSM\dusmtask"
"\Microsoft\Windows\Feedback\Siuf\DmClient"
"\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
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
"\Microsoft\Windows\Windows Error Reporting\QueueReporting"
"\Microsoft\Windows\WindowsUpdate\Scheduled Start"
"\Microsoft\Windows\WindowsUpdate\RUXIM\PLUGScheduler"
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
"\System32\Tasks\Microsoft\Windows\WindowsUpdate\Scheduled Start"
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
"UsoSvc"
"wuauserv"
"MicrosoftEdgeElevationService"
"MixedRealityOpenXRSvc"
"edgeupdate"
"edgeupdatem"
)

$bservices=@(
"xbgm*"
"OneSyncSvc*"
"WaaSMedicSvc"
)

$prg_list=@(
"%SystemRoot%\System32\SIHClient.exe"
"%SystemRoot%\System32\mousocoreworker.exe"
"%SystemRoot%\UUS\amd64\MoUsoCoreWorker.exe"
"%SystemRoot%\System32\Speech_OneCore\common\SpeechRuntime.exe"
"%SystemRoot%\System32\OneDriveSetup.exe"
"%SystemRoot%\ImmersiveControlPanel\SystemSettings.exe"
"%SystemRoot%\explorer.exe"
)

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
"$env:systemdrive\ProgramData\Microsoft\Windows Defender\*"
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

$reg_dw=@(
@("HKCU\Control Panel\International\User Profile","HttpAcceptLanguageOptOut",1),
@("HKCU\Control Panel\UnsupportedHardwareNotificationCache","SV1",0),
@("HKCU\Control Panel\UnsupportedHardwareNotificationCache","SV2",0),
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
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost","EnableWebContentEvaluation",0),
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost","PreventOverride",0),
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
@("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings","IsDynamicSearchBoxEnabled",0),
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
@("HKCU\SOFTWARE\Policies\Microsoft\Windows\TabletPC","DisableSnippingTool",1),
@("HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot","TurnOffWindowsCopilot",1),
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
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy","LetAppsRunInBackground",2),
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
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","EnableCdp",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","PublishUserActivities",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","UploadUserActivities",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","AllowCrossDeviceClipboard",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\System","EnableSmartScreen",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC","DisableSnippingTool",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC","PreventHandwritingDataSharing",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot","TurnOffWindowsCopilot",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat","ChatIcon",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting","Disabled",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting","DontSendAdditionalData",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds","EnableFeeds",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","AllowCortana",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","AllowCloudSearch",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","AllowIndexingEncryptedStoresOrItems",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","AllowSearchToUseLocation",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","AlwaysUseAutoLangDetection",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","ConnectedSearchUseWeb",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","DisableSearch",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","DisableWebSearch",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","FavoriteLocations",1),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","IsAADCloudSearchEnabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","IsDeviceSearchHistoryEnabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","IsMSACloudSearchEnabled",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","SafeSearchMode",0),
@("HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search","PreventRemoteQueries",1),
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
@("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer","SmartScreenEnabled","Off"),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","HomepageLocation","about:blank"),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge","NewTabPageLocation","about:blank"),
@("HKLM\SOFTWARE\Policies\Microsoft\Edge\RestoreOnStartupURLs","1","about:blank"),
@("HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Internet Settings","ProvisionedHomePages","about:blank")
)

function wc($c,$m){Write-Host -ForegroundColor $c $m}
function wn($m){Write-Host -NoNewline $m}
function wh($m){wc 10 $m}
$ed={if($?){wc 1 " - Done."}else{wc 4 " - File deletion error ($($Error[0].CategoryInfo.Category))!"}}
function rf($f){try{wn "Trying to remove file     : `"$f`"";rm $f -Force -ea 0 *>$null;.$ed}catch{}}

function Set-Registry-ReadOnly($regpath){
  try{
    $acl=Get-Acl $regpath
    $acl.SetAccessRuleProtection($True,$True)
  }
  catch{return}
  foreach($a in $acl.Access){
    try{
      $u=$a.IdentityReference
      $propagation=$a.PropagationFlags
      $rule=New-Object System.Security.AccessControl.RegistryAccessRule($u,"ReadKey",@("ObjectInherit","ContainerInherit"),"None","Allow")
      $acl.PurgeAccessRules($u)
      $acl.SetAccessRule($rule)
    }
    catch{}
  }
  try{Set-Acl $regpath $acl -ea 0 *>$null}catch{}
}

function Takeown-File($path) {
  takeown /A /F $path *>$null
  $acl=Get-Acl $path
  $admins=New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
  $admins=$admins.Translate([System.Security.Principal.NTAccount])
  $rule=New-Object System.Security.AccessControl.FileSystemAccessRule($admins,"FullControl","None","None", "Allow")
  $acl.AddAccessRule($rule)
  try{Set-Acl $path $acl -ea 0 *>$null}catch{}
}

function remove-app($app) {
  write "Trying to remove $app"
  try{
    sajb -Name remappx -ScriptBlock {(Get-AppxPackage -Name "$using:app" -AllUsers -ea 0|Remove-AppxPackage -ea 0) *>$null} *>$null
    (gjb|wjb) *>$null
    sajb -Name remappxp -ScriptBlock {(Get-AppXProvisionedPackage -Online -ea 0|where DisplayName -EQ "$using:app"|Remove-AppxProvisionedPackage -Online -ea 0) *>$null} *>$null
    (gjb|wjb) *>$null
  }
  catch{}
}

function remove-cap($app) {
  write "Trying to remove $app"
  try{
    sajb -Name remcap -ScriptBlock {(Get-WindowsCapability -Online -Name "$using:app" -ea 0|where State -EQ "Installed"|Remove-WindowsCapability -Online -ea 0) *>$null} *>$null
    (gjb|wjb) *>$null
  }
  catch{}
}

function remove-apps() {
  wh "Uninstalling default apps..."
  foreach ($app in $apps) {
    remove-app $app
  }
  sajb -Name feature -ScriptBlock {Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ea 0 *>$null} *>$null
  (gjb|wjb) *>$null
  sajb -Name feature -ScriptBlock {Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Deprecation -NoRestart -ea 0 *>$null} *>$null
  (gjb|wjb) *>$null
  sajb -Name feature -ScriptBlock {Disable-WindowsOptionalFeature -Online -FeatureName WorkFolders-Client -NoRestart  -ea 0 *>$null} *>$null
  (gjb|wjb) *>$null
  sajb -Name feature -ScriptBlock {Disable-WindowsOptionalFeature -Online -FeatureName WindowsMediaPlayer -NoRestart  -ea 0 *>$null} *>$null
  (gjb|wjb) *>$null
  $pkgs=(Dism /Online /Get-Packages|select-string -pattern 'package'|%{$_.tostring()}|%{$_ -split ' : '})
  $pkgs=($pkgs|select-string -pattern 'package'|%{$_.tostring()})
  $pkgs|select-string -pattern 'hello-face'|%{$_.tostring();}|%{(Dism /Online /Remove-Package /PackageName:$_ /Quiet /NoRestart *>$null)}
  foreach($app in $caps){remove-cap $app}
  (gjb|wjb) *>$null
  (taskkill /F /IM "SnippingTool.exe") *>$null
  sajb -Name remsnipp -ScriptBlock {(cmd /c "$env:systemroot\System32\SnippingTool.exe /uninstall >nul 2>&1") *>$null} *>$null
  sleep -Seconds 15
  (taskkill /F /IM "SnippingTool.exe") *>$null
}

function remove-onedrive(){
  wh "Removing OneDrive..."
  write "Kill OneDrive process"
  (taskkill /F /IM "OneDrive.exe") *>$null
  write "Remove OneDrive"
  if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
  }
  if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
  }
  write "Removing OneDrive leftovers"
  rm -Recurse -Force -ea 0 "$env:localappdata\Microsoft\OneDrive"
  rm -Recurse -Force -ea 0 "$env:programdata\Microsoft OneDrive"
  rm -Recurse -Force -ea 0 "$env:systemdrive\OneDriveTemp"
  if((ls "$env:userprofile\OneDrive" -Recurse|Measure-Object).Count -eq 0){
    rm -Recurse -Force -ea 0 "$env:userprofile\OneDrive"
  }
  write "Remove Onedrive from explorer sidebar"
  (New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR") *>$null
  (mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}") *>$null
  (sp "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0) *>$null
  (mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}") *>$null
  (sp "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0) *>$null
  (Remove-PSDrive "HKCR") *>$null
  write "Removing run hook for new users"
  reg load "hku\Default" "C:\Users\Default\NTUSER.DAT" *>$null
  reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /f *>$null
  reg unload "hku\Default" *>$null
  reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /f *>$null
  write "Removing startmenu entry"
  rm -Force -ea 0 "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
  write "Removing scheduled task"
  Get-ScheduledTask 'OneDrive*' '\' -ea 0|Unregister-ScheduledTask -Confirm:$false -ea 0 *>$null
}

function fix-tasks(){
  wh "Disabling some scheduled tasks..."
  foreach($task in $tasks){
    $parts=$task.split('\')
    $name=$parts[-1]
    $path=$parts[0..($parts.length-2)] -join '\'
    Disable-ScheduledTask "$name" "$path" -ea 0 *>$null
  }
}

function fix-root-tasks(){
  wh "Disabling some scheduled root tasks..."
  foreach($task in $root_tasks){
    $parts=$task.split('\')
    $name=$parts[-1]
    Disable-ScheduledTask "$name" "\" -ea 0 *>$null
  }
}

function fix-tasks-files(){
  wh "Removing some scheduled tasks..."
  foreach($tpath in $tpaths){
    ls -ea 0 -Path "$env:systemroot$tpath" *|foreach{
      Takeown-File $_.FullName *>$null
      rm -ea 0 -Path $_.FullName *>$null
    }
  }
}

function fix-services(){
  wh "Disabling some services..."
  foreach($service in $services){
    write "Trying to disable $service"
    gsv -Name $service -ea 0|Set-Service -StartupType Disabled -ea 0 *>$null
  }
}

function fix-bservices(){
  wh "Disabling some bad services..."
  foreach($bservice in $bservices){
    write "Trying to disable $bservice"
    sp -ea 0 "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice" "Start" 4
    Set-Registry-ReadOnly "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice"
  }
}

function rdw($path,$key,$val){reg add $path /v $key /t REG_DWORD /d $val /f *>$null}

function rsz($path,$key,$val){reg add $path /v $key /t REG_SZ /d $val /f *>$null}

function fix-registry(){
  wh "Tuning registry keys..."
  foreach($r in $reg_dw){rdw $r[0] $r[1] $r[2]}
  foreach($r in $reg_sz){rsz $r[0] $r[1] $r[2]}
  reg add "HKCU\SOFTWARE\Microsoft\Edge\SmartScreenEnabled" /t REG_DWORD /d 0 /f *>$null
  reg delete "HKCR\ms-msdt" /f *>$null
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnostics" EnableDiagnostics 0
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnostics" DisableQueryRemoteServer 0
  reg delete "HKCR\search-ms" /f *>$null
  reg delete "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{77857D02-7A25-4B67-9266-3E122A8F39E4}" /f *>$null
  reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store" /f *>$null
}

function fix-network(){
  wh "Adding firewall rules..."
  foreach($p in $prg_list){
    Remove-NetFirewallRule -DisplayName "$p block-internet" -ea 0 *>$null
    New-NetFirewallRule -Program "$p" -DisplayName "$p block-internet" -Direction Outbound -RemoteAddress Internet -Action Block -ea 0 *>$null
  }
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
  $drive=Get-WmiObject -Class Win32_Volume -Filter "DriveLetter='$env:systemdrive'"
  $drive|Set-WmiInstance -Arguments @{IndexingEnabled=$False} *>$null
  wh "Windows components cleanup..."
  Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase /NoRestart /Quiet *>$null
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

function fix-view(){
  wh "Fixing view..."
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
  if(((Get-WmiObject Win32_OperatingSystem).Caption).Contains("11")){
    $Bags="HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags"
    $DLID="{885A186E-A440-4ADA-812B-DB871B942259}"
    (ls $bags -recurse|? PSChildName -eq $DLID )|rm -Force -ea 0 *>$null
    rdw "HKLM\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{885A186E-A440-4ADA-812B-DB871B942259}" Mode 4
    rdw "HKLM\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{885A186E-A440-4ADA-812B-DB871B942259}" GroupView 0
    reg add "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve /t REG_SZ /d " " *>$null
  }
  try{
    rm -Recurse -Force -ea 0 "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" *>$null
  }
  catch{}
  try{
    saps wt.exe -WindowStyle hidden *>$null
    sleep -s 5
    $r=(gc "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Encoding UTF8 -ea 0) -replace "^\s*\/\/.*"|Out-String -ea 0
    $j=(ConvertFrom-Json -InputObject $r -ea 0)
    $j.profiles.list|% {if($_.name -eq "Azure Cloud Shell"){$_.hidden=[boolean]"true"}}
    $j|ConvertTo-Json -depth 32  -ea 0|Set-Content "$env:localappdata\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Encoding UTF8 -ea 0
  }
  catch{}
}

function fix-tiles(){
  try{
    Import-StartLayout -LayoutPath "$env:systemdrive\fixes\base\layout.xml" -MountPath "$env:systemdrive\" -ea 0 *>$null
  }
  catch{}
  reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" /f *>$null
  rdw "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\StoreInit" HasStoreCacheInitialized 0
  (taskkill /F /IM "StartMenuExperienceHost.exe") *>$null
}

function fix-misc(){
  reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v "ForcedPhysicalSectorSizeInBytes" /t REG_MULTI_SZ /d "* 4095" /f *>$null
  rdw "HKLM\SYSTEM\CurrentControlSet\Control\Print" RpcAuthnLevelPrivacyEnabled 0
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint" RestrictDriverInstallationToAdministrators 0
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" RpcUseNamedPipeProtocol 1
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" RpcAuthentication 0
  rdw "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" RpcProtocols 0x7
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
fix-misc
cleanup
