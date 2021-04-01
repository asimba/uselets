@echo off
powershell -Command "Start-Process %SYSTEMDRIVE%\fixes\tsk.cmd -Verb RunAs" >nul 2>&1
