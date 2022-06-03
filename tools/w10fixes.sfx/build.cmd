@echo off
src\bin\pack.exe fixes src\data.qb
src\bin\makeswap.exe src\swap.h src\swap.bin
src\bin\makedefs.exe src\defs.h
src\bin\genico.exe src\icon.ico
src\bin\mix.exe src\rsrc.dat src\swap.bin src\image.qb src\data.qb src\rsrc.bmp
windres -i src\rsrc.rc -o src\rsrc.o -F pe-i386
g++ -Os -s -static -m32 -mwindows -march=i386 -mtune=i386 -Wall -fno-builtin -fno-rtti -ftoplevel-reorder ^
-mpreferred-stack-boundary=2 -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables ^
-fmerge-constants -fpack-struct=1 -falign-jumps=1 -falign-loops=1 -falign-functions=1  ^
-ffast-math -fno-inline-small-functions -fno-stack-protector -fno-exceptions -fno-ident -nostartfiles ^
-Wl,--entry=_start,--enable-stdcall-fixup,--no-insert-timestamp,--dynamicbase,--emit-relocs,^
--major-image-version,255,--minor-image-version,255,--major-os-version,6,--major-subsystem-version,6,^
--export-all-symbols,--nxcompat,--enable-auto-image-base,--build-id -o fixes.exe ^
src\sfx.cc ^
src\rsrc.o -lntdll
src\bin\padding.exe fixes.exe
