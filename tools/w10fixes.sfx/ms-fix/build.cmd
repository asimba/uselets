@echo off
gcc -Os -s -static -m32 -mwindows -march=i386 -mtune=i386 -Wall -fno-builtin -ftoplevel-reorder ^
-mpreferred-stack-boundary=2 -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables ^
-fmerge-constants -fpack-struct=1 -falign-jumps=1 -falign-loops=1 -falign-functions=1 ^
-ffast-math -fno-inline-small-functions -fno-stack-protector -fno-exceptions -fno-ident -nostartfiles ^
-ffunction-sections -fdata-sections ^
-Wl,--entry=_start,--no-insert-timestamp,--gc-sections,--disable-dynamicbase,--disable-reloc,^
--section-alignment,16,--file-alignment,16 -o ms-fix.exe ms-fix.c
