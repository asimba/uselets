pack certs certs.qb
tcc icert-all-to-my.c -o icert-all-to-my-sfx.exe -L./ -lshell32 -ladvapi32 -luser32 -m32 -Wl,-subsystem=windows
tcc icert-active-to-my.c -o icert-active-to-my-sfx.exe -L./ -lshell32 -ladvapi32 -luser32 -m32 -Wl,-subsystem=windows
tcc icert-root-to-my.c -o icert-root-to-my-sfx.exe -L./ -lshell32 -ladvapi32 -luser32 -m32 -Wl,-subsystem=windows
copy /b icert-all-to-my-sfx.exe + certs.qb icert-all-to-my-sfx.exe
copy /b icert-active-to-my-sfx.exe + certs.qb icert-active-to-my-sfx.exe
copy /b icert-root-to-my-sfx.exe + certs.qb icert-root-to-my-sfx.exe
