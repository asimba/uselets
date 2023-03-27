@echo off
for %%f in (*.cer,*.crt) do (
  for /f "tokens=*" %%i in ('openssl x509 -inform der -in "%%~nxf" -fingerprint -noout 2^>^&1 ^| grep Finger ^| sed "s/^.*=//;s/://g;s/\(.*\)/\L\1/"') do move /y "%%~nxf" "%%i.cer"
)