### Короткие полезности.
---  
#### Работа с сетью.  
---  
- **Синхронизация времени с удалённым сервером из командной строки (Windows).**  
```net time \\<сервер> /set /y```  
_Пример:_ ```net time \\192.168.0.1 /set /y```  
- *Блокирование доступа в интернет для всех программ, при сохранении доступа в локальную сеть (Windows).*  
_Требования (зависимости):_ Windows Firewall, PowerShell  
```New-NetFirewallRule -DisplayName "block-internet" -Direction Outbound -RemoteAddress Internet -Action Block```  
---  
#### Работа с файлами.  
---  
- **Архивация всех директорий в текущей директории из командной строки (Windows).**  
_Требования (зависимости):_ [7-Zip](https://www.7-zip.org/)  
_Архив 7z:_ ```for /d %f in (*) do 7z a -t7z -ms=on -m0=LZMA2 -mx9 -mmt=4 -scsUTF-8 -ssc "%~pnf.7z" "%~pnxf"```  
_Архив zip:_ ```for /d %f in (*) do 7z a -tzip -m0=Deflate -mx9 "%~pnxf.zip" "%~pnxf"```  
---  
#### Работа с документами.  
---  
- **Разбиение PDF-файла на отдельные страницы (Windows).**  
_Требования (зависимости):_ [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) (PDFtk free)  
```pdftk <имя_файла> burst```  
_Пример:_```pdftk source.pdf burst```  
- **Склеивание PDF-файла из отдельных файлов страниц в текущей директории (Windows).**  
_Требования (зависимости):_ [qpdf](https://github.com/qpdf/qpdf/releases)  
```qpdf --empty <имя_файла_результата> --pages *.pdf 1-z --```  
_Пример:_```qpdf --empty destination.pdf --pages *.pdf 1-z --```  
- **Пакетное преобразование (сжатие) PDF-файлов (отдельных файлов страниц!) в текущей директории в чёрно-белые с установкой разрешения 200DPI (Windows).**  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [python](https://www.python.org/), [img2pdf](https://pypi.org/project/img2pdf/)  
```for %f in (*.pdf) do convert.exe -density 200 -colorspace Gray -normalize -compress group4 "%~nxf" "%~nf.tif"```  
```for %f in (*.tif) do img2pdf.py -d 200 -o "%~pnf.pdf" "%~pnxf"```  
