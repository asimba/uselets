@echo off
gcc -Os -s -static -m64 -mwindows -march=x86-64 -mtune=x86-64 -mtune=generic -Wall ^
-mpreferred-stack-boundary=3 -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables ^
-fmerge-constants -fpack-struct=1 -falign-jumps=1 -falign-loops=1 -falign-functions=1 -nodefaultlibs ^
-ffast-math -fno-stack-protector -fno-exceptions -fno-ident -nostartfiles ^
-fdata-sections -ffunction-sections -Wl,--entry=start,--enable-stdcall-fixup,--no-insert-timestamp,--gc-sections ^
-o services.exe services.c -lkernel32 -ladvapi32
