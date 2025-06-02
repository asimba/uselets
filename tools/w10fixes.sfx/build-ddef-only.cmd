@echo off

cd src.ddef
call build.cmd
move /y ddef.exe ../ddef.exe 2>&1 >nul
cd ..
objdump.exe -x ddef.exe > ddef.txt
