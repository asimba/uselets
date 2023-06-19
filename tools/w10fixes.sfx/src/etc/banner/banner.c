#include <io.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <windows.h>

#include "banner.h"

HBITMAP hBitmap,hOldBitmap;
HDC hdc,hdcMem;
BITMAP bm;
HINSTANCE hI;
PAINTSTRUCT ps;
RECT rect,rc;
HPEN hpen;
POINT mpos;
uint8_t *image;

LRESULT CALLBACK dlg_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
  switch(msg){
    case WM_CREATE:
      hBitmap=CreateBitmap(506,191,1,32,image);
      GetObjectA(hBitmap,sizeof(BITMAP),&bm);
      hdc=GetDC(hWnd);
      hdcMem=CreateCompatibleDC(hdc);
      hOldBitmap=(HBITMAP)SelectObject(hdcMem,hBitmap);
      hpen=CreatePen(PS_SOLID,8,RGB(39,39,39));
      ReleaseDC(hWnd,hdc);
      return 0;
    case WM_KEYDOWN:
      if(wParam==VK_ESCAPE||wParam=='N'||wParam=='n'){
        DestroyWindow(hWnd);
        return 0;
      };
      break;
    case WM_PAINT:
      hdc=BeginPaint(hWnd,&ps);
      GetClientRect(hWnd,&rect);
      BitBlt(hdc,0,0,rect.right,rect.bottom,hdcMem,0,0,SRCCOPY);
      SelectObject(hdc,hpen);
      MoveToEx(hdc,10,10,NULL);
      LineTo(hdc,40,40);
      MoveToEx(hdc,496,10,NULL);
      LineTo(hdc,466,40);
      MoveToEx(hdc,40,10,NULL);
      LineTo(hdc,70,40);
      LineTo(hdc,436,40);
      LineTo(hdc,466,10);
      MoveToEx(hdc,10,181,NULL);
      LineTo(hdc,40,151);
      MoveToEx(hdc,496,181,NULL);
      LineTo(hdc,466,151);
      MoveToEx(hdc,40,181,NULL);
      LineTo(hdc,70,151);
      LineTo(hdc,436,151);
      LineTo(hdc,466,181);
      EndPaint(hWnd,&ps);
      break;
    case WM_CLOSE:
    case WM_DESTROY:
      PostQuitMessage(0);
      DeleteDC(hdcMem);
      DeleteObject(hBitmap);
      DeleteObject(hOldBitmap);
      break;
  }
  return DefWindowProcA(hWnd,msg,wParam,lParam);
}

int dlg_window(HINSTANCE hInstance){
  hI=hInstance;
  WNDCLASS wc;
  wc.style=0;
  wc.lpfnWndProc=dlg_wndproc;
  wc.hInstance=hInstance;
  wc.hIcon=LoadIconA(NULL,IDI_APPLICATION);
  wc.hCursor=LoadCursorA(NULL,IDC_ARROW);
  wc.hbrBackground=(HBRUSH)(COLOR_WINDOW+1);
  wc.lpszClassName="imgdlgclass";
  wc.lpszMenuName=NULL;
  wc.cbClsExtra=0;
  wc.cbWndExtra=0;
  RegisterClassA(&wc);
  rc.top=0;
  rc.left=0;
  rc.bottom=191;
  rc.right=506;
  AdjustWindowRect(&rc,WS_POPUP,FALSE);
  int nWidth=rc.right-rc.left;
  int nHeight=rc.bottom-rc.top;
  int nX=(GetSystemMetrics(SM_CXSCREEN)-nWidth)/2;
  int nY=(GetSystemMetrics(SM_CYSCREEN)-nHeight)/2;
  if(nX<0) nX=0;
  if(nY<0) nY=0;
  HWND hWnd=CreateWindowExA(WS_EX_TOPMOST,wc.lpszClassName,NULL,WS_POPUP,nX,nY,nWidth,nHeight,NULL,NULL,hInstance,NULL);
  ShowWindow(hWnd,SW_SHOW);
  UpdateWindow(hWnd);
  MSG msg;
  while(GetMessageA(&msg,NULL,0,0)){
    DispatchMessageA(&msg);
    TranslateMessage(&msg);
  };
  UnregisterClassA(wc.lpszClassName, hInstance);
  return 0;
}

#define LZ_BUF_SIZE 259
#define LZ_CAPACITY 24
#define LZ_MIN_MATCH 3

uint8_t flags;
uint8_t cbuffer[LZ_CAPACITY+1];
uint8_t cntxs[LZ_CAPACITY+1];
uint8_t vocbuf[0x10000];
uint16_t frequency[256][256];
uint16_t fcs[256];
uint16_t buf_size;
uint16_t vocroot;
uint16_t offset;
uint16_t length;
uint16_t symbol;
uint32_t low;
uint32_t hlp;
uint32_t range;
char *lowp;
char *hlpp;
uint8_t *cpos;
uint8_t rle_flag;
uint8_t scntx;

uint32_t dptr;
uint32_t dsize;
uint8_t *pdata;

uint8_t dgetc(){
  uint8_t s=0;
  if(dptr<dsize){
    s=pdata[dptr];
    dptr++;
  };
  return s;
}

uint8_t rc32_getc(uint8_t *c,uint8_t cntx){
  uint16_t *f=frequency[cntx],fc=fcs[cntx];
  uint32_t s=0,i;
  while(hlp<low||(low^(low+range))<0x1000000||range<0x10000){
    hlp<<=8;
    *hlpp=dgetc();
    if(dptr==dsize) return 0;
    low<<=8;
    range<<=8;
    if((uint32_t)(range+low)<low) range=~low;
  };
  if((i=(hlp-low)/(range/=fc))<fc){
    while((s+=*f)<=i) f++;
    low+=(s-*f)*range;
    *c=(uint8_t)(f-frequency[cntx]);
    range*=(*f)++;
    if(++fc==0){
      f=frequency[cntx];
      for(s=0;s<256;s++) fc+=(*f=((*f)>>1)|(*f&1)),f++;
    };
    fcs[cntx]=fc;
    return 0;
  }
  else return 1;
}

uint8_t unpack_file(){
  for(;;){
    if(length){
      if(rle_flag==0) symbol=vocbuf[offset++];
      vocbuf[vocroot++]=symbol;
      length--;
      return 0;
    }
    else{
      if(flags==0){
        cpos=cbuffer;
        if(rc32_getc(cpos++,0)) return 1;
        for(uint8_t c=~*cbuffer;c;flags++) c&=c-1;
        uint8_t cflags=*cbuffer;
        flags=8+(flags<<1);
        for(uint8_t c=0;c<flags;){
          if(cflags&0x80) cntxs[c++]=4;
          else{
            *(uint32_t*)(cntxs+c)=0x00030201;
            c+=3;
          };
          cflags<<=1;
        };
        for(uint8_t c=0;c<flags;c++){
          if(cntxs[c]==4){
            if(rc32_getc(cpos,scntx)) return;
            scntx=*cpos++;
          }
          else{
            if(rc32_getc(cpos++,cntxs[c])) return;
          };
        };
        cpos=&cbuffer[1];
        flags=8;
      };
      length=rle_flag=1;
      if(*cbuffer&0x80) symbol=*cpos;
      else{
        length=LZ_MIN_MATCH+1+*cpos++;
        if((offset=*(uint16_t*)cpos++)<0x0100) symbol=(uint8_t)(offset);
        else{
          if(offset==0x0100) break;
          offset=~offset+(uint16_t)(vocroot+LZ_BUF_SIZE);
          rle_flag=0;
        };
      };
      *cbuffer<<=1;
      cpos++;
      flags--;
    };
  };
  return 0;
}

void init_unpack(const uint8_t *data_ptr,const uint32_t data_size_in){
  pdata=(uint8_t *)data_ptr;
  dsize=data_size_in;
  dptr=buf_size=flags=vocroot=low=hlp=length=rle_flag=0;
  offset=range=0xffffffff;
  lowp=&((char *)&low)[3];
  hlpp=&((char *)&hlp)[0];
  scntx=0xff;
  uint32_t i;
  for(i=0;i<256;i++){
    for(int j=0;j<256;j++) frequency[i][j]=1;
    fcs[i]=256;
  };
  for(i=0;i<0x10000;i++) vocbuf[i]=0xff;
  for(i=0;i<sizeof(uint32_t);i++){
    hlp<<=8;
    *hlpp=dgetc();
  }
};

INT WINAPI WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,PSTR lpCmdLine,INT nCmdShow){
  image=(uint8_t*)calloc(image_size,1);
  if(image){
    init_unpack(packed_image,image_data_size);
    for(uint32_t i=0;i<image_size;i++){
      if(unpack_file()) break;
      image[i]=(uint8_t)symbol;
      if(dptr==dsize) break;
    };
    dlg_window(0);
    free(image);
  };
  return 0;
}
