tcc arc-sfx.c -o arc-sfx.exe  -L./ -lshell32 -luser32 -m32 -Wl,-subsystem=windows
upx --best --ultra-brute arc-sfx.exe
