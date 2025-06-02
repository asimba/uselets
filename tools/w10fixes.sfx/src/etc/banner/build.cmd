@echo off
setlocal enabledelayedexpansion
set "string=abcdefghijklmnopqrstuvwxyz"
set "exe="

for /L %%i in (1,1,8) do call :add
goto :stop
:add
set /a x=%random% %% 26 
set exe=%exe%!string:~%x%,1!
goto :eof
:stop

del /q banner.rc.o 2>&1 >nul
windres -i banner.rc -o banner.rc.o -F pe-x86-64
gcc -Os -s -static -m64 -mwindows -march=x86-64 -mtune=generic -Wall -fno-builtin -ftoplevel-reorder ^
-fomit-frame-pointer -fno-unwind-tables -fno-asynchronous-unwind-tables ^
-fmerge-constants -nodefaultlibs -ffunction-sections ^
-ffast-math -fno-inline-small-functions -fno-stack-protector -fno-exceptions -fno-ident -nostartfiles ^
-Wl,--entry=start,--enable-stdcall-fixup,--no-insert-timestamp,^
--major-image-version,255,--minor-image-version,255,--major-os-version,6,--major-subsystem-version,6,^
--gc-sections,--build-id ^
-o %exe%.exe banner.c banner.rc.o -lntdll -lkernel32 -luser32 -lgdi32
move /y %exe%.exe banner.exe 2>&1 >nul
del /q banner.rc.o 2>&1 >nul
