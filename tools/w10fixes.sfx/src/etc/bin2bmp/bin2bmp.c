#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <windows.h>

PBITMAPINFO CreateBitmapInfoStruct(HWND hwnd,HBITMAP hBmp){
  BITMAP bmp;
  PBITMAPINFO pbmi;
  WORD cClrBits=32;
  if (!GetObject(hBmp,sizeof(BITMAP),(LPSTR)&bmp)) return pbmi;
  pbmi=(PBITMAPINFO)LocalAlloc(LPTR,sizeof(BITMAPINFOHEADER));
  pbmi->bmiHeader.biSize=sizeof(BITMAPINFOHEADER);
  pbmi->bmiHeader.biWidth=bmp.bmWidth;
  pbmi->bmiHeader.biHeight=bmp.bmHeight;
  pbmi->bmiHeader.biPlanes=bmp.bmPlanes;
  pbmi->bmiHeader.biBitCount=bmp.bmBitsPixel;
  pbmi->bmiHeader.biCompression=BI_RGB;
  pbmi->bmiHeader.biSizeImage=((pbmi->bmiHeader.biWidth*cClrBits+31)&~31)/8*pbmi->bmiHeader.biHeight;
  pbmi->bmiHeader.biClrImportant=0;
  return pbmi;
};

int main(int argc,char *argv[]){
  FILE *f=NULL;
  uint32_t size=0,image_size=0,x=0,y=0,i=0;
  if(argc<3) return 1;
  f=fopen(argv[1],"rb");
  fseek(f,0,SEEK_END);
  size=ftell(f);
  fseek(f,0,SEEK_SET);
  size+=sizeof(uint32_t);
  printf("data  file size  : %u\n",size);
  x=(int)(ceil(sqrt(size/4)));
  y=x;
  while((x*y*4)>size) y--;
  if((x*y*4)<size) y++;
  image_size=x*y*4;
  printf("data  geom. size : %ux%u (delta: %u)\n",x,y,image_size-size);
  printf("image data  size : %u (%ux%u)\n",image_size,x,y);
  VOID *lpBits=(VOID *)calloc(image_size,1);
  *((uint32_t *)lpBits)=size;
  srand(size);
  for(i=sizeof(uint32_t);i<size;i++) ((uint8_t *)lpBits)[i]=fgetc(f);
  while(i<image_size) ((uint8_t *)lpBits)[i++]=(uint8_t)(rand()%0xff);
  fclose(f);
  HBITMAP hBmp=CreateBitmap(x,y,1,32,lpBits);
  PBITMAPINFO pbmi=CreateBitmapInfoStruct(0,hBmp);

  BITMAPFILEHEADER hdr;
  PBITMAPINFOHEADER pbih=(PBITMAPINFOHEADER)pbmi;
  size=0;
  hdr.bfType=0x4d42;
  hdr.bfSize=(DWORD)(sizeof(BITMAPFILEHEADER)+pbih->biSize+pbih->biClrUsed*sizeof(RGBQUAD)+pbih->biSizeImage);
  hdr.bfReserved1=0;
  hdr.bfReserved2=0;
  hdr.bfOffBits=(DWORD)sizeof(BITMAPFILEHEADER)+pbih->biSize+pbih->biClrUsed*sizeof(RGBQUAD);
  f=fopen(argv[2],"wb");
  fwrite(&hdr,1,sizeof(BITMAPFILEHEADER),f);
  size+=sizeof(BITMAPFILEHEADER);
  fwrite(pbih,1,sizeof(BITMAPINFOHEADER)+pbih->biClrUsed*sizeof(RGBQUAD),f);
  size+=sizeof(BITMAPINFOHEADER)+pbih->biClrUsed*sizeof(RGBQUAD);
  printf("image header size: %u\n",size);
  fwrite(lpBits,1,pbih->biSizeImage,f);
  fclose(f);

  free(lpBits);
  return 0;
}
