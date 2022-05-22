@echo off
g++ -Os -m32 -mconsole -march=i686 -mtune=i686 -s -Wall -o bmp2dib.exe bmp2dib.cc -lgdi32
