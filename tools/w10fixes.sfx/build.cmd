@echo off
src\bin\pack.exe fixes src\data.qb
src\bin\makeswap.exe src\swap.h src\swap.bin
src\bin\mix.exe src\rsrc.dat src\swap.bin src\image.qb src\data.qb src\rsrc.bmp
windres -i src\rsrc.rc -o src\rsrc.o -F pe-i386
g++ -Os -m32 -mwindows -march=i386 -mtune=generic -s -Wall -fmerge-constants -fno-builtin -fno-rtti ^
-fno-stack-protector -fno-exceptions -fno-ident -nostartfiles ^
-Wl,--entry=_start,--enable-stdcall-fixup,--no-insert-timestamp,--nxcompat  -o fixes.exe ^
src\sfx.cc ^
src\rsrc.o
src\bin\padding.exe fixes.exe
