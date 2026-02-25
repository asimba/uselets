@echo off
curl "https://e-trust.gosuslugi.ru/app/scc/portal/api/v1/portal/ca/list" -X POST -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:109.0) Gecko/20100101 Firefox/117.0" -H "Accept: application/json, text/plain, */*" -H "Accept-Language: en-US,en;q=0.8,ru-RU;q=0.5,ru;q=0.3" -H "Accept-Encoding: gzip, deflate, br" -H "Content-Type: application/json" -H "Origin: https://e-trust.gosuslugi.ru" -H "DNT: 1" -H "Connection: keep-alive" -H "Referer: https://e-trust.gosuslugi.ru/" -H "Sec-Fetch-Dest: empty" -H "Sec-Fetch-Mode: cors" -H "Sec-Fetch-Site: same-origin" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data-raw "{""page"":1,""orderBy"":""id"",""ascending"":false,""recordsOnPage"":1000,""searchString"":null,""cities"":null,""software"":null,""cryptToolClasses"":null,""statuses"":null}" > json\ca_list_all.gz
curl "https://e-trust.gosuslugi.ru/app/scc/portal/api/v1/portal/ca/list" -X POST -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:109.0) Gecko/20100101 Firefox/117.0" -H "Accept: application/json, text/plain, */*" -H "Accept-Language: en-US,en;q=0.8,ru-RU;q=0.5,ru;q=0.3" -H "Accept-Encoding: gzip, deflate, br" -H "Content-Type: application/json" -H "Origin: https://e-trust.gosuslugi.ru" -H "DNT: 1" -H "Connection: keep-alive" -H "Referer: https://e-trust.gosuslugi.ru/" -H "Sec-Fetch-Dest: empty" -H "Sec-Fetch-Mode: cors" -H "Sec-Fetch-Site: same-origin" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data-raw "{""page"":1,""orderBy"":""id"",""ascending"":false,""recordsOnPage"":100,""searchString"":null,""cities"":null,""software"":null,""cryptToolClasses"":null,""statuses"":[""\u0414\u0435\u0439\u0441\u0442\u0432\u0443\u0435\u0442""]}" > json\ca_list_active.gz
curl "https://e-trust.gosuslugi.ru/app/scc/portal/api/v1/portal/mainca/get" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:109.0) Gecko/20100101 Firefox/117.0" -H "Accept: application/json, text/plain, */*" -H "Accept-Language: en-US,en;q=0.8,ru-RU;q=0.5,ru;q=0.3" -H "Accept-Encoding: gzip, deflate, br" -H "DNT: 1" -H "Connection: keep-alive" -H "Referer: https://e-trust.gosuslugi.ru/" -H "Sec-Fetch-Dest: empty" -H "Sec-Fetch-Mode: cors" -H "Sec-Fetch-Site: same-origin" -H "Pragma: no-cache" -H "Cache-Control: no-cache" > json\root_list.gz
cd json
7z x ca_list_all.gz
7z x ca_list_active.gz
7z x root_list.gz
del /q ca_list_all.gz
del /q ca_list_active.gz
del /q root_list.gz
cd ..
certparse.py
for %%f in (certs\active\*.cer,certs\active\*.crt) do (
  for /f "tokens=*" %%i in ('openssl x509 -inform der -in "%%~pnxf" -fingerprint -noout 2^>^&1 ^| grep Finger ^| sed "s/^.*=//;s/://g;s/\(.*\)/\L\1/"') do move /y "%%~pnxf" "certs\active\%%i.cer" >nul 2>&1
)
for %%f in (certs\all\*.cer,certs\all\*.crt) do (
  for /f "tokens=*" %%i in ('openssl x509 -inform der -in "%%~pnxf" -fingerprint -noout 2^>^&1 ^| grep Finger ^| sed "s/^.*=//;s/://g;s/\(.*\)/\L\1/"') do move /y "%%~pnxf" "certs\all\%%i.cer" >nul 2>&1
)
for %%f in (certs\root\*.cer,certs\root\*.crt) do (
  for /f "tokens=*" %%i in ('openssl x509 -inform der -in "%%~pnxf" -fingerprint -noout 2^>^&1 ^| grep Finger ^| sed "s/^.*=//;s/://g;s/\(.*\)/\L\1/"') do move /y "%%~pnxf" "certs\root\%%i.cer" >nul 2>&1
)
