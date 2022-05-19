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
uint8_t vocbuf[0x10000];
uint32_t frequency[257];
uint16_t buf_size;
uint16_t vocroot;
uint16_t offset;
uint16_t lenght;
uint16_t symbol;
uint32_t low;
uint32_t hlp;
uint32_t range;
uint32_t *fc;
char *lowp;
char *hlpp;
uint8_t *cpos;
uint8_t rle_flag;

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

uint8_t rc32_getc(uint8_t *c){
  while((range<0x10000)||(hlp<low)){
    if(((low&0xff0000)==0xff0000)&&(range+(uint16_t)low>=0x10000))
      range=0x10000-(uint16_t)low;
    hlp<<=8;
    *hlpp=dgetc();
    if(dptr==dsize) return 0;
    low<<=8;
    range<<=8;
  };
  range/=*fc;
  uint32_t count=(hlp-low)/range;
  if(count>=*fc) return 1;
  symbol=0;
  uint16_t i,j=128;
  while(j){
    if(frequency[symbol]<=count) symbol+=j;
    else{
      if(symbol) symbol-=j;
      else break;
    };
    j>>=1;
  };
  if(frequency[symbol]>count&&symbol) symbol--;
  *c=(uint8_t)symbol;
  j=frequency[symbol++];
  low+=j*range;
  range*=frequency[symbol]-j;
  for(i=symbol;i<257;i++) frequency[i]++;
  if(*fc>0xffff){
    uint32_t *fp=frequency;
    frequency[0]>>=1;
    for(i=1;i<257;i++){
      if((frequency[i]>>=1)==*fp++) frequency[i]++;
    };
  };
  return 0;
}

uint8_t unpack_file(){
  uint16_t i;
  if(lenght){
    if(!rle_flag){
      symbol=vocbuf[offset++];
      vocbuf[vocroot++]=symbol;
    };
    lenght--;
  }
  else{
    if(flags==0){
      cpos=cbuffer;
      if(rc32_getc(cpos++)) return 1;
      flags=8;
      lenght=0;
      symbol=*cbuffer;
      for(i=0;i<flags;i++){
        if(symbol&0x80) lenght++;
        else lenght+=3;
        symbol<<=1;
      };
      for(i=lenght;i;i--)
        if(rc32_getc(cpos++)) return 1;
      cpos=cbuffer+1;
    };
    lenght=0;
    if(*cbuffer&0x80){
      symbol=*cpos;
      vocbuf[vocroot++]=*cpos;
    }
    else{
      lenght=*cpos+++LZ_MIN_MATCH+1;
      offset=*(uint16_t*)cpos++;
      if(offset==0x0100) return 1;
      if(offset<0x0100){
        rle_flag=1;
        symbol=offset;
        for(i=0;i<lenght;i++) vocbuf[vocroot++]=symbol;
        lenght--;
      }
      else{
        rle_flag=0;
        offset=0xffff+(uint16_t)(vocroot+LZ_BUF_SIZE)-offset;
        symbol=vocbuf[offset++];
        vocbuf[vocroot++]=symbol;
        lenght--;
      };
    };
    *cbuffer<<=1;
    cpos++;
    flags--;
  };
  return 0;
}

void init_unpack(const uint8_t *data_ptr,const uint32_t data_size_in){
  pdata=(uint8_t *)data_ptr;
  dsize=data_size_in;
  dptr=buf_size=flags=vocroot=low=hlp=lenght=rle_flag=0;
  offset=range=0xffffffff;
  lowp=&((char *)&low)[3];
  hlpp=&((char *)&hlp)[0];
  fc=&frequency[256];
  uint32_t i;
  for(i=0;i<257;i++) frequency[i]=i;
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
