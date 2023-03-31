pack certs certs.qb
tcc icert.c -o icert-sfx.exe -L./ -lshell32 -ladvapi32 -luser32 -m32 -Wl,-subsystem=windows
copy /b icert-sfx.exe + certs.qb ru-certs-202303.exe