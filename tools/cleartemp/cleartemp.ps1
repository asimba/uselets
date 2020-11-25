$ErrorActionPreference = "SilentlyContinue"

function clean-temp() {
  $users = Get-ChildItem C:\Users
  foreach ($user in $users){
    $folder = "$($user.fullname)\AppData\Local\temp"
    If (Test-Path $folder) {
      Write-Output "Clearing: $folder"
      Get-ChildItem -Path $folder -Include * | Remove-Item -recurse;
    }
  }
}

clean-temp
