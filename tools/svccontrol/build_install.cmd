pack svccontrol svccontrol.qb
tcc install.c -o svccontrol-sfx.exe -L./ -lshell32 -ladvapi32 -luser32 -m32 -Wl,-subsystem=windows
upx --best --ultra-brute svccontrol-sfx.exe
copy /b svccontrol-sfx.exe + svccontrol.qb svccontrol.exe