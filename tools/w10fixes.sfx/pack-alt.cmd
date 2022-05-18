@echo off
alt\bin\pack.exe fixes fixes.qb
alt\bin\bin2h.exe fixes.qb
alt\bin\makeswap.exe alt\c.src\swap.h
move /y data.h alt\c.src\
del /q fixes.qb
windres -i alt\c.src\manifest.rc -o alt\c.src\manifest.o -F pe-i386
g++ -Os -m32 -mwindows -march=i686 -mtune=i686 -s -Wall -fmerge-constants -fno-exceptions -fno-builtin -fno-rtti -fno-stack-protector -fpack-struct=1 -falign-jumps=1 -falign-loops=1 -falign-functions=1 -mpreferred-stack-boundary=2 -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-ident -ffast-math -fno-inline-small-functions -nostartfiles -Wl,--entry=_WinMain,--enable-stdcall-fixup,--no-insert-timestamp -o fixes-alt.exe alt\c.src\sfx.cc alt\c.src\manifest.o
