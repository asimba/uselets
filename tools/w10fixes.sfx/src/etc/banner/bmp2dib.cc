#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <windows.h>

int main(int argc,char *argv[]){
  if(argc>1){
    FILE *ifile=fopen(argv[1],"rb");
    char buf[1024];
    fread(buf,1,1024,ifile);
    fclose(ifile);
    tagBITMAPINFOHEADER bih=*(tagBITMAPINFOHEADER*)(buf+sizeof(tagBITMAPFILEHEADER));
    HBITMAP hBitmap;
    HDC hdcMem;
    hBitmap=(HBITMAP)LoadImageA(NULL,argv[1],IMAGE_BITMAP,0,0,LR_LOADFROMFILE);
    if(hBitmap){
      printf("Bitmap loaded.\n");
      printf("Image size %lu x %lu.\n",bih.biWidth,bih.biHeight);
      hdcMem=CreateCompatibleDC(0);
      LPBYTE lpBits;
      uint32_t bs=bih.biWidth*bih.biHeight*4;
      lpBits=(LPBYTE)GlobalAlloc(GMEM_FIXED,bs);
      if(lpBits){
        printf("Allocated %u bytes.\n",bs);

        BITMAPINFO bi;
        bi.bmiHeader.biSize=sizeof(bi.bmiHeader);
        bi.bmiHeader.biWidth=bih.biWidth;
        bi.bmiHeader.biHeight=-bih.biHeight;
        bi.bmiHeader.biPlanes=1;
        bi.bmiHeader.biBitCount=32;
        bi.bmiHeader.biCompression=BI_RGB;

        if(!GetDIBits(hdcMem,hBitmap,0,bih.biHeight,lpBits,&bi,DIB_RGB_COLORS)){
          printf("GetDIBits error.\n");
        }
        else{
          uint32_t l=0;
          FILE *ofile=fopen("image.dib","wb");
          while(l<bs){
            fputc(lpBits[l],ofile);
            l++;
          }
          fclose(ofile);
          printf("Writen %u bytes.",l);
        };
        GlobalFree((HGLOBAL)lpBits);
      };
      DeleteDC(hdcMem);
      DeleteObject(hBitmap);
    };
  };
  return 0;
}
