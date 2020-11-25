@echo off
for %%f in (*.rtf) do cscript //nologo "%~dp0\rtf2pdf.js" "%%~nxf"