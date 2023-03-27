pack certs certs.qb
tcc icert.c -o icert.exe -L./ -lshell32 -ladvapi32 -luser32 -m32 -Wl,-subsystem=windows
copy /b icert.exe + certs.qb icerts-cer.exe