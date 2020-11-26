$cleanflags = @(
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
    "Memory Dump Files"
    "Recycle Bin"
    "RetailDemo Offline Content"
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

function cleanup(){
    $StateFlags = 'StateFlags1234'
    $StateRun = $StateFlags.Substring($StateFlags.get_Length()-4)
    $StateRun = '/sagerun:' + $StateRun
    foreach ($cleanflag in $cleanflags) {
        Set-ItemProperty -path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$cleanflag" -name $StateFlags -type DWORD -Value 2 -ErrorAction SilentlyContinue
    }
    Start-Process -FilePath CleanMgr.exe -ArgumentList $StateRun -WindowStyle Hidden -Wait
    foreach ($cleanflag in $cleanflags) {
        Remove-ItemProperty -path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$cleanflag" -name $StateFlags -ErrorAction SilentlyContinue
    }
} 

cleanup
