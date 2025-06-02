@echo off
setlocal enabledelayedexpansion
set "string=abcdefghijklmnopqrstuvwxyz"
set "exe="
src\bin\pack.exe fixes src\data.qb
src\bin\makeswap.exe src\swap.h src\swap.bin
src\bin\makedefs.exe src\defs.h
src\bin\genico.exe src\icon.ico
src\bin\mix.exe src\rsrc.dat src\swap.bin src\image.qb src\data.qb src\rsrc.bmp

for /L %%i in (1,1,8) do call :add
goto :stop
:add
set /a x=%random% %% 26 
set exe=%exe%!string:~%x%,1!
goto :eof
:stop

echo Compiling: %exe%
windres -i src\rsrc.rc -o src\rsrc64.o -F pe-x86-64
g++ -Os -s -static -m64 -mwindows -march=x86-64 -mtune=generic -Wall -fno-builtin -ftoplevel-reorder ^
-fno-inline-small-functions -fno-stack-protector -fno-ident -ffunction-sections -fdata-sections ^
-nostartfiles -nodefaultlibs -fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables ^
-ffast-math -fno-enforce-eh-specs ^
-Wl,--entry,start,--no-insert-timestamp,--dynamicbase,--emit-relocs,^
--major-image-version,255,--minor-image-version,255,^
--major-os-version,6,--major-subsystem-version,6,^
--gc-sections,--export-all-symbols,--nxcompat,--enable-auto-image-base,--build-id -o %exe%.exe ^
src\sfx.cc ^
src\rsrc64.o ^
-lntdll -lkernel32 -luser32
del /q src\rsrc64.o 2>&1 >nul
move /y %exe%.exe fixes.exe 2>&1 >nul
objdump.exe -x fixes.exe > fixes.txt

cd src.ddef
call build.cmd
move /y ddef.exe ../ddef.exe 2>&1 >nul
cd ..
objdump.exe -x ddef.exe > ddef.txt
