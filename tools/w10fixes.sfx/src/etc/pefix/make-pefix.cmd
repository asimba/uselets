@echo off
g++ -Os -m32 -mconsole -march=i686 -mtune=i686 -s -Wall -fmerge-constants -fno-exceptions -fno-builtin ^
-fno-rtti -fno-stack-protector -fpack-struct=1 -falign-jumps=1 -falign-loops=1 -falign-functions=1 ^
-mpreferred-stack-boundary=2 -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables ^
-fno-ident -ffast-math -fno-inline-small-functions -o pefix.exe pefix.cc -limagehlp

