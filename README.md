### Короткие полезности.
---  
#### Работа с сетью.  
---  
- **Синхронизация времени с удалённым сервером из командной строки (Windows).**  
```net time \\<сервер> /set /y```  
_Пример:_ ```net time \\192.168.0.1 /set /y```  
- **Блокирование доступа в интернет для всех программ, при сохранении доступа в локальную сеть (Windows).**  
_Требования (зависимости):_ Windows Firewall, PowerShell  
```New-NetFirewallRule -DisplayName "block-internet" -Direction Outbound -RemoteAddress Internet -Action Block```  
---  
#### Работа с дисками/разделами/файловыми системами.  
---  
- **Очистка журнала USN NTFS из командной строки (Windows).**  
```fsutil usn deletejournal /n c:```  
---  
#### Системные операции.  
---  
- **Очистка всех журналов событий из командной строки (Windows).**  
_Требования (зависимости):_ PowerShell  
```wevtutil el | Foreach-Object {wevtutil cl "$_"}```  
---  
#### Работа с файлами.  
---  
- **Архивация всех директорий в текущей директории из командной строки (Windows).**  
_Требования (зависимости):_ [7-Zip](https://www.7-zip.org/)  
_Архив 7z:_ ```for /d %f in (*) do 7z a -t7z -ms=on -m0=LZMA2 -mx9 -mmt=4 -scsUTF-8 -ssc "%~pnf.7z" "%~pnxf"```  
_Архив zip:_ ```for /d %f in (*) do 7z a -tzip -m0=Deflate -mx9 "%~pnxf.zip" "%~pnxf"```  
- **Проверка целостности архива (7z) из командной строки (Linux).**  
_Требования (зависимости):_ [7-Zip](https://www.7-zip.org/)  
```for filename in *.7z; do if 7z t "$filename" 2>&1 > /dev/null; then echo $filename passed; else echo $filename failed; fi; done```  
- **Создание/проверка(/восстановление исходных данных) файлов с информацией для восстановления (parchive/par2) из командной строки (Linux).**  
_Требования (зависимости):_ par2  
_Создание:_ ```par2 c -n1 -u -r100 <имя_исходного_файла>.par2 <имя_исходного_файла>```  
_Пример:_ ```par2 c -n1 -u -r100 source.tar.gz.par2 source.tar.gz```  
_Примечание: значение параметра "r" - количество (в процентах) информации для восстановления, при 100% можно полностью восстановить отсутствующий исходный файл._  
_Проверка:_ ```par2 v <имя_исходного_файла>.par2```  
_Пример:_ ```par2 v source.tar.gz.par2```  
_Восстановление исходных данных:_ ```par2 r <имя_исходного_файла>.par2```  
_Пример:_ ```par2 r source.tar.gz.par2```  
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
- **Пакетное преобразование (сжатие) PDF-файлов (отдельных файлов страниц!) в текущей директории с установкой разрешения 200DPI (Windows).**  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [python](https://www.python.org/), [img2pdf](https://pypi.org/project/img2pdf/), [mozjpeg](https://github.com/mozilla/mozjpeg/releases)  
```for %f in (*.pdf) do convert -density 200 -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 75 -outfile "%~pnf.jpg"```  
```for %f in (*.jpg) do img2pdf.py -d 200 -o "%~pnf.pdf" "%~pnxf"```  
_Примечание: значение параметра "quality" ("качество") стоит варьировать в диапазоне от 70 до 90; хорошо подходит для больших сканированных изображений (размер файлов может быть уменьшен в несколько раз, но с векторными файлами ситуация обратная)._  
- **Пакетное преобразование DOCX-файлов в текущей директории в формат PDF (Windows).**  
_Требования (зависимости):_ [Microsoft Office 2013 или новее](https://www.office.com/), [docx2pdf.js](https://github.com/asimba/uselets/tree/main/tools/docx2pdf)  
```for %f in (*.docx) do cscript //nologo "docx2pdf.js" "%~pnxf"``` или ```docx2pdf.cmd```  
- **Пакетное преобразование RTF-файлов в текущей директории в формат PDF (Windows).**  
_Требования (зависимости):_ [Microsoft Office 2013 или новее](https://www.office.com/), [rtf2pdf.js](https://github.com/asimba/uselets/tree/main/tools/rtf2pdf)  
```for %f in (*.rtf) do cscript //nologo "rtf2pdf.js" "%~nxf""``` или ```rtf2pdf.cmd```  
- **Пакетное изменение размеров файлов изображений в текущей директории (Windows).**  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [mozjpeg](https://github.com/mozilla/mozjpeg/releases)  
```for %f in (*.jpg) do convert -strip -colorspace RGB -filter LanczosRadius -distort Resize "<ширина>>" -distort Resize ">x<высота>" -colorspace sRGB -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 85 -outfile "%~pnf-1.jpg"```  
_Пример:_```for %f in (*.jpg) do convert -strip -colorspace RGB -filter LanczosRadius -distort Resize "1280>" -distort Resize ">x960" -colorspace sRGB -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 85 -outfile "%~pnf-1.jpg"```  
_Примечание: значение параметра "quality" ("качество") стоит варьировать в диапазоне от 70 до 90._  
