@echo off
for /r %%f in (*.docx) do cscript //nologo "%~dp0\docx2pdf.js" "%%~pnxf"