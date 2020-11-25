@echo off

rem Linux:
rem pdftk in.pdf output - uncompress | sed '/^\/Annots/d' | pdftk - output out.pdf compress

if "%~1"=="" goto stop
if "%~2"=="" goto stop

pdftk "%~dpnx1" output "%temp%\%~n1-tmp.pdf" uncompress
sed --binary -n "/^\/Annots/!p" "%temp%\%~n1-tmp.pdf" > "%temp%\%~n1-stripped.pdf"
pdftk "%temp%\%~n1-stripped.pdf" output "%~dpnx2" compress
del "%temp%\%~n1-stripped.pdf"
del "%temp%\%~n1-tmp.pdf"

:stop
