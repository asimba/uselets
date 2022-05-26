@echo off
src\bin\pack.exe fixes src\data.qb
src\bin\makeswap.exe src\swap.h src\swap.bin
src\bin\makedefs.exe src\defs.h
src\bin\mix.exe src\rsrc.dat src\swap.bin src\image.qb src\data.qb src\rsrc.bmp
windres -i src\rsrc.rc -o src\rsrc.o -F pe-i386
g++ -Os -s -m32 -mwindows -march=i386 -mtune=i386 -Wall -fno-builtin -fno-rtti -fno-toplevel-reorder ^
-mpreferred-stack-boundary=2 -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables ^
-ffast-math -fno-inline-small-functions -fno-stack-protector -fno-exceptions -fno-ident -nostartfiles ^
-Wl,--entry=_start,--enable-stdcall-fixup,--no-insert-timestamp,--dynamicbase,--emit-relocs,^
--export-all-symbols,--nxcompat -o fixes.exe ^
src\sfx.cc ^
src\rsrc.o
src\bin\padding.exe fixes.exe
