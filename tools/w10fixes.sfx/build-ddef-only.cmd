@echo off

cd src.ddef
call build.cmd
move /y ddef64.exe ../ddef64.exe 2>&1 >nul
cd ..
