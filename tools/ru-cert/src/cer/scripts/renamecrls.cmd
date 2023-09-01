@echo off
for %%f in (*.crl) do (
  for /f "tokens=*" %%i in ('openssl crl -inform der -in "%%~nxf" -fingerprint -noout 2^>^&1 ^| grep Finger ^| sed "s/^.*=//;s/://g;s/\(.*\)/\L\1/"') do move /y "%%~nxf" "%%i.crl"
)