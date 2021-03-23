@echo off
arc-pack.exe fixes fixes.qb
copy /b arc-sfx.exe + fixes.qb fixes.exe
del /q fixes.qb
