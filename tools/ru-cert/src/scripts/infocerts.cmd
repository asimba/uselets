@echo off
for %%f in (*.cer) do (
  openssl x509 -inform der -in "%%~nxf" -fingerprint -subject -issuer -dates -nameopt oneline,-esc_msb -noout >>list0.txt 2>nul
)
sed "s/SHA1 Fingerprint=//;s/notBefore=//;s/notAfter=//;s/^.*CN = //;s/^ //;s/\, .*$//;s/\\//g;s/$/;/" < list0.txt > list1.txt
del /q list0.txt
echo Отпечаток ключа;Кому выдан;Кем выдан;Когда выдан;Срок действия; > certinfo.csv
sed "N;s/\n//;N;s/\n//;N;s/\n//;N;s/\n//" < list1.txt >> certinfo.csv
del /q list1.txt
