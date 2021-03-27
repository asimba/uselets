@echo off
gcc pack.c -o pack.exe -m32 -Os -fno-exceptions -fno-stack-protector -fdata-sections -ffunction-sections -Wl,--gc-sections -s
pack.exe fixes fixes.qb
del /q fixes.qb
del /q pack.exe
rem tcc fixes.c -o fixes.exe -m32 -Wl,-subsystem=console
gcc fixes.c -o fixes.exe -m32 -Os -fno-exceptions -fno-stack-protector -fdata-sections -ffunction-sections -Wl,--gc-sections -s

