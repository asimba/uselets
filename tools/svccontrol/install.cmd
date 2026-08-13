@echo off
pushd "%~dp0"
schtasks /delete /tn svccontrol /f >nul 2>&1
schtasks.exe /create /tn svccontrol /ru system /xml "%~dp0svccontrol.xml" >nul 2>&1
popd
