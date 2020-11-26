### Короткие полезности.
---  
#### Работа с сетью.  
---  
##### Синхронизация времени с удалённым сервером из командной строки (Windows).  
```net time \\<сервер> /set /y```  
_Пример:_ ```net time \\192.168.0.1 /set /y```  
##### Блокирование доступа в интернет для всех программ, при сохранении доступа в локальную сеть (Windows).  
_Требования (зависимости):_ Windows Firewall, PowerShell  
```New-NetFirewallRule -DisplayName "block-internet" -Direction Outbound -RemoteAddress Internet -Action Block```  
##### Отправка почтового сообщения администратору системы при успешном входе в систему по протоколу SSH (Linux).  
_Инструкция: в директории "/etc/profile.d/" требуется разместить исполняемый файл сценария с инжеследующим содержанием:_  
```
if [ -n "$SSH_CLIENT" ]; then
    TEXT="$(date): ssh login to ${USER}@$(hostname -f)"
    TEXT="$TEXT from $(echo $SSH_CLIENT|awk '{print $1}')"
    echo $TEXT|mail -s "ssh login (hive)" root
fi
```  
##### Разрешение доступа в сеть (NAT) в CentOS 7.  
```firewall-cmd --zone=public --add-masquerade --permanent```  

---  
#### Работа с дисками/разделами/файловыми системами.  
---  
##### Создание архивированного образа файловой системы EXT3/EXT4, расположенной на томе LVM (Linux).  
_Требования (зависимости):_ xz-utils, dump  
```
#!/bin/bash
backup_path=./
vg_group=/dev/system
lvm_volume=host-root
lvremove -f $vg_group/$lvm_volume-snap
lvcreate -L4G -s -n $lvm_volume-snap $vg_group/$lvm_volume
fsck -yvf $vg_group/$lvm_volume-snap
dump -0uf $backup_path/$lvm_volume.dump $vg_group/$lvm_volume-snap
lvremove -f $vg_group/$lvm_volume-snap
xz -9 $backup_path/$lvm_volume.dump
```  
_Примечание: "backup_path" - директория для хранения архива, "vg_group" - группа томов, "lvm_volume" - наименование архивируемого тома. Восстановление осуществляется аналогичным образом при помощи комады "restore"._  
##### Создание архивированного образа тома LVM для последующего дифференциального резервирования (Linux).  
_Требования (зависимости):_ rdiff, lz4  
```
#!/bin/bash
backup_path=./system.images
vg_group=/dev/system
lvm_volume=srv1c-disk
if [ -f $backup_path/$lvm_volume ]; then
   cat  $backup_path/$lvm_volume | lz4 -z -1 -BD > $backup_path/$lvm_volume.before-`date +%Y-%m-%d`.lz4
   rm -f $backup_path/$lvm_volume
fi
if [ -f $backup_path/$lvm_volume.signature ]; then
   cat  $backup_path/$lvm_volume.signature | lz4 -z -1 -BD > $backup_path/$lvm_volume.before-`date +%Y-%m-%d`.signature.lz4
   rm -f $backup_path/$lvm_volume.signature
fi
lvremove -f $vg_group/$lvm_volume-snap
lvcreate -L16G -s -n $lvm_volume-snap $vg_group/$lvm_volume
dd if=$vg_group/$lvm_volume-snap of=$backup_path/$lvm_volume bs=64M
rdiff -b 262144 -I 67108864 -O 67108864 -- signature $backup_path/$lvm_volume $backup_path/$lvm_volume.signature
lvremove -f $vg_group/$lvm_volume-snap
```  
_Примечание: "backup_path" - директория для хранения архива, "vg_group" - группа томов, "lvm_volume" - наименование архивируемого тома. Способ подходит для разделов фиртуальных машин (параметры блоков "rdiff" подобраны для тома размером 256 GiB)._  
##### Создание дифференциальной резервной копии для архивированного образа тома LVM (см.выше) (Linux).  
_Требования (зависимости):_ rdiff, lz4  
```
#!/bin/bash
backup_path=./system.images
vg_group=/dev/system
lvm_volume=srv1c-disk
# удаление дельта файлов старше 60 дней
# find $backup_path -name "*.delta.*" -type f -mtime +60 -exec rm -f {} \;
lvremove -f $vg_group/$lvm_volume-snap
lvcreate -L16G -s -n $lvm_volume-snap $vg_group/$lvm_volume
rdiff -b 262144 -I 67108864 -O 67108864 -- delta $backup_path/$lvm_volume.signature $vg_group/$lvm_volume-snap - | lz4 -z -1 -BD > $backup_path/$lvm_volume.`date +%Y-%m-%d-%H:%M:%S`.delta.lz4
lvremove -f $vg_group/$lvm_volume-snap
```  
_Примечание: "backup_path" - директория для хранения архива, "vg_group" - группа томов, "lvm_volume" - наименование архивируемого тома. Способ подходит для разделов фиртуальных машин (параметры блоков "rdiff" подобраны для тома размером 256 GiB)._  
##### Восстановление дифференциальной резервной копии архивированного образа тома LVM (см.выше) (Linux).  
_Требования (зависимости):_ rdiff, lz4  
```
#!/bin/bash
backup_path=./system.images
lvm_volume=srv1c-disk
time_stamp=2019-10-02-14:50:18
lz4cat $backup_path/$lvm_volume.$time_stamp.delta.lz4 | rdiff -b 262144 -I 67108864 -O 67108864 -- patch $backup_path/$lvm_volume - $backup_path/$lvm_volume.new
dd of=$vg_group/$lvm_volume if=$backup_path/$lvm_volume.new bs=64M
```  
_Примечание: "backup_path" - директория хранения архива, "lvm_volume" - наименование тома, "time_stamp" - метка времени восстанавливаемой копии._  
##### Очистка журнала USN NTFS из командной строки (Windows).  
```fsutil usn deletejournal /n c:```  

---  
#### Системные операции.  
---  
##### Очистка всех журналов событий из командной строки (Windows).  
_Требования (зависимости):_ PowerShell  
```wevtutil el | Foreach-Object {wevtutil cl "$_"}```  
##### Удаление временных файлов для всех пользователей из командной строки (Windows).  
_Требования (зависимости):_ PowerShell, [cleartemp.ps1](https://github.com/asimba/uselets/blob/main/tools/cleartemp/cleartemp.ps1)  
```powershell -ExecutionPolicy Bypass -command "cleartemp.ps1"```  
##### Получение информации о материнской плате из командной строки (Windows).  
```wmic baseboard get product,Manufacturer,version,serialnumber```  
---  
#### Работа с файлами.  
---  
##### Архивация всех директорий в текущей директории из командной строки (Windows).  
_Требования (зависимости):_ [7-Zip](https://www.7-zip.org/)  
_Архив 7z:_ ```for /d %f in (*) do 7z a -t7z -ms=on -m0=LZMA2 -mx9 -mmt=4 -scsUTF-8 -ssc "%~pnf.7z" "%~pnxf"```  
_Архив zip:_ ```for /d %f in (*) do 7z a -tzip -m0=Deflate -mx9 "%~pnxf.zip" "%~pnxf"```  
##### Проверка целостности архива (7z) из командной строки (Linux).  
_Требования (зависимости):_ [7-Zip](https://www.7-zip.org/)  
```for filename in *.7z; do if 7z t "$filename" 2>&1 > /dev/null; then echo $filename passed; else echo $filename failed; fi; done```  
##### Создание/проверка(/восстановление исходных данных) файлов с информацией для восстановления (parchive/par2) из командной строки (Linux).  
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
##### Разбиение PDF-файла на отдельные страницы (Windows).  
_Требования (зависимости):_ [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) (PDFtk free)  
```pdftk <имя_файла> burst```  
_Пример:_```pdftk source.pdf burst```  
##### Склеивание PDF-файла из отдельных файлов страниц в текущей директории (Windows).  
_Требования (зависимости):_ [qpdf](https://github.com/qpdf/qpdf/releases)  
```qpdf --empty <имя_файла_результата> --pages *.pdf 1-z --```  
_Пример:_```qpdf --empty destination.pdf --pages *.pdf 1-z --```  
##### Пакетное преобразование (сжатие) PDF-файлов (отдельных файлов страниц!) в текущей директории в чёрно-белые с установкой разрешения 200DPI (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [python](https://www.python.org/), [img2pdf](https://pypi.org/project/img2pdf/)  
```for %f in (*.pdf) do convert.exe -density 200 -colorspace Gray -normalize -compress group4 "%~nxf" "%~nf.tif"```  
```for %f in (*.tif) do img2pdf.py -d 200 -o "%~pnf.pdf" "%~pnxf"```  
##### Пакетное преобразование (сжатие) PDF-файлов (отдельных файлов страниц!) в текущей директории с установкой разрешения 200DPI (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [python](https://www.python.org/), [img2pdf](https://pypi.org/project/img2pdf/), [mozjpeg](https://github.com/mozilla/mozjpeg/releases)  
```for %f in (*.pdf) do convert -density 200 -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 75 -outfile "%~pnf.jpg"```  
```for %f in (*.jpg) do img2pdf.py -d 200 -o "%~pnf.pdf" "%~pnxf"```  
_Примечание: значение параметра "quality" ("качество") стоит варьировать в диапазоне от 70 до 90; хорошо подходит для больших сканированных изображений (размер файлов может быть уменьшен в несколько раз, но с векторными файлами ситуация обратная)._  
##### Пакетное преобразование DOCX-файлов в текущей директории в формат PDF (Windows).  
_Требования (зависимости):_ [Microsoft Office 2013 или новее](https://www.office.com/), [docx2pdf.js](https://github.com/asimba/uselets/tree/main/tools/docx2pdf)  
```for %f in (*.docx) do cscript //nologo "docx2pdf.js" "%~pnxf"``` или ```docx2pdf.cmd```  
##### Пакетное преобразование RTF-файлов в текущей директории в формат PDF (Windows).  
_Требования (зависимости):_ [Microsoft Office 2013 или новее](https://www.office.com/), [rtf2pdf.js](https://github.com/asimba/uselets/tree/main/tools/rtf2pdf)  
```for %f in (*.rtf) do cscript //nologo "rtf2pdf.js" "%~nxf""``` или ```rtf2pdf.cmd```  
##### Пакетное удаление фона в PDF-файлах (отдельных файлах страниц!) в текущей директории с установкой разрешения 300DPI (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [python](https://www.python.org/), [img2pdf](https://pypi.org/project/img2pdf/), [mozjpeg](https://github.com/mozilla/mozjpeg/releases)  
```for %f in (*.pdf) do convert -density 300 -fuzz 10%% -fill white -opaque white -units pixelsperinch -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 85 -outfile "%~pnf.jpg"```  
```for %f in (*.jpg) do img2pdf.py -d 300 -o "%~pnf.pdf" "%~pnxf"```  
_Примечание: значение параметра "fuzz" соответствует уровню "фонового шума"._  
##### Удаление аннотаций из PDF-файлов (Linux).  
_Требования (зависимости):_ pdftk
```pdftk <имя_исходного_файла> output - uncompress | sed '/^\/Annots/d' | pdftk - output <имя_результирующего_файла> compress```  
_Пример:_```pdftk in.pdf output - uncompress | sed '/^\/Annots/d' | pdftk - output out.pdf compress```  
_Примечание: обычно используется для удаления комментариев "AutoCAD SHX"._  
##### Удаление аннотаций из PDF-файлов (Windows).  
_Требования (зависимости):_ [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) (PDFtk free), [sed](http://gnuwin32.sourceforge.net/packages/sed.htm), [stripannot](https://github.com/asimba/uselets/tree/main/tools/stripannot)  
```stripannot.cmd <имя_исходного_файла> <имя_результирующего_файла>```  
_Пример:_```stripannot.cmd in.pdf out.pdf```  
_Примечание: обычно используется для удаления комментариев "AutoCAD SHX"._  
##### Пакетное изменение размеров файлов изображений в текущей директории (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php), [mozjpeg](https://github.com/mozilla/mozjpeg/releases)  
```for %f in (*.jpg) do convert -strip -colorspace RGB -filter LanczosRadius -distort Resize "<ширина>>" -distort Resize ">x<высота>" -colorspace sRGB -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 85 -outfile "%~pnf-1.jpg"```  
_Пример:_```for %f in (*.jpg) do convert -strip -colorspace RGB -filter LanczosRadius -distort Resize "1280>" -distort Resize ">x960" -colorspace sRGB -compress none "%~pnxf" ppm:- | cjpeg-static -sample 2x2 -dct int -optimize -progressive -quality 85 -outfile "%~pnf-1.jpg"```  
_Примечание: значение параметра "quality" ("качество") стоит варьировать в диапазоне от 70 до 90._  
##### Создание страниц с миниатюрами файлов изображений для всех поддиректорий в текущей директории (Windows).  
_Требования (зависимости):_ [ImageMagick](https://imagemagick.org/script/download.php)  
```for /d %d in (*) do montage -limit thread 6 -limit file 64 -limit memory 8192Mib -limit map 16384MiB -define registry:temporary-path=..\temp -pointsize 10 -label "%wx%h\n%t" -tile 10x10 -geometry 164x162+1+0 -density 200 -units pixelsperinch "%~npxd\*.png" "..\thumbs\%~nxd.png"```  
_Примечание: параметр "temporary-path" - путь к директории для хранения временных файлов, параметр "tile" - количество миниатюр по горизонтали и вертикали, страницы в данном примере генерируются для "png" файлов, результат размещается в директории "..\thumbs\%~nxd.png"_  
##### Пакетная генерация файлов скринлистов для всех "mp4" файлов в текущей директории (Windows) (пример).  
_Требования (зависимости):_ [movie thumbnailer (mtn)](http://moviethumbnail.sourceforge.net/index.en.html)  
```for %f in (*.mp4) do mtn -c 4 -r 4 -j 100 -o .jpg -P -w 1200 -Z -D6 "%~pnxf"```  
##### Пакетное преобразование видео файлов (Windows) (пример).  
_Требования (зависимости):_ [ffmpeg](https://ffmpeg.org/), [GPAC MP4Box](https://www.videohelp.com/software/MP4Box), [movie thumbnailer (mtn)](http://moviethumbnail.sourceforge.net/index.en.html)  
```
@echo off
for %%f in (in\*.wmv,in\*.avi,in\*.mp4,in\*.mkv,in\*.flv) do (
echo "%%~dpnxf"
ffmpeg -i "%%~dpnxf" -hide_banner -an -filter_complex "scale=1280:720:flags=lanczos,setdar=16/9,setsar=1/1,unsharp,hqdn3d=2:1:2" -c:v libx264 -b:v 2000k -x264opts frameref=15:fast_pskip=0 -pass 1 -passlogfile tmp\mp4 -preset slow -threads 4 -f rawvideo -y -r film NUL
ffmpeg -i "%%~dpnxf" -hide_banner -c:a aac -b:a 128k -ar 44100 -filter_complex "scale=1280:720:flags=lanczos,setdar=16/9,setsar=1/1,unsharp,hqdn3d=2:1:2" -c:v libx264 -b:v 2000k -x264opts frameref=15:fast_pskip=0 -pass 2 -passlogfile tmp\mp4 -preset slow -threads 4 -y -r film "tmp\out.mp4"
mp4box -isma -inter 500 -add "tmp\out.mp4" -new "out\%%~nf.mp4"
mtn -c 4 -r 4 -j 100 -o .jpg -O out -P -w 1200 -Z -D6 "out\%%~nf.mp4"
del /q tmp\tmp.h264 tmp\mp4-0.log tmp\mp4-0.log.mbtree tmp\out.mp4
)
```  
