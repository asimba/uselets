#include <windows.h>
#include <stdint.h>
#include <stdlib.h>

#define LZ_BUF_SIZE 259
#define LZ_MIN_MATCH 3
#define image_size 386584

static uint8_t flags;
static uint8_t cbuffer[4];
static uint8_t vocbuf[0x10000];
static uint16_t frequency[256][256];
static uint16_t fcs[256];
static uint16_t buf_size;
static uint16_t vocroot;
static uint16_t offset;
static uint16_t length;
static uint16_t symbol;
static uint32_t low;
static uint32_t hlp;
static uint32_t range;
static char *lowp;
static char *hlpp;
static uint8_t rle_flag;
static uint32_t tcounter;
static uint8_t *dptr;
static uint8_t *image=NULL;

static HBITMAP hBitmap,hOldBitmap;
static HDC hdc,hdcMem;
static BITMAP bm;
static PAINTSTRUCT ps;
static RECT rect,rc;
static HPEN hpen;
static HBRUSH hbrush;

static uint8_t rc32_getc(uint8_t *c,uint8_t cntx){
  uint16_t *f=frequency[cntx],fc=fcs[cntx];
  uint32_t s=0,i;
  while(hlp<low||(low^(low+range))<0x1000000||range<fc){
    hlp<<=8;
    *hlpp=*dptr++;
    low<<=8;
    range<<=8;
    if(range>~low) range=~low;
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

static uint8_t unpack_file(){
  for(;;){
    if(length){
      if(rle_flag) vocbuf[vocroot++]=symbol=offset;
      else symbol=vocbuf[vocroot++]=vocbuf[offset++];
      length--;
      return 0;
    };
    if(flags){
      length=rle_flag=1;
      if(*cbuffer&0x80){
        if(rc32_getc((uint8_t *)&offset,vocbuf[(uint16_t)(vocroot-1)])) return 1;
      }
      else{
        for(uint8_t c=1;c<4;c++)
          if(rc32_getc(cbuffer+c,c)) return 1;
        length=LZ_MIN_MATCH+1+cbuffer[1];
        if((offset=*(uint16_t*)(cbuffer+2))>=0x0100){
          if(offset==0x0100) return 1;
          offset=~offset+vocroot+LZ_BUF_SIZE;
          rle_flag=0;
        };
      };
      cbuffer[0]<<=1;
      flags<<=1;
      continue;
    };
    if(rc32_getc(cbuffer,0)) return 1;
    flags=0xff;
  };
  return 0;
}

static void init_unpack(){
  buf_size=flags=vocroot=low=hlp=length=rle_flag=0;
  offset=range=0xffffffff;
  lowp=&((char *)&low)[3];
  hlpp=&((char *)&hlp)[0];
  uint32_t i;
  for(i=0;i<256;i++){
    for(int j=0;j<256;j++) frequency[i][j]=1;
    fcs[i]=256;
  };
  for(i=0;i<0x10000;i++) vocbuf[i]=0xff;
  for(i=0;i<sizeof(uint32_t);i++){
    hlp<<=8;
    *hlpp=*dptr++;
  }
};

static uint8_t *load_res(uint32_t id){
  HRSRC fres=FindResourceW(NULL,MAKEINTRESOURCEW(id),MAKEINTRESOURCEW(10));
  if(fres){
    HGLOBAL res_handle=LoadResource(NULL,fres);
    if(res_handle) return (uint8_t*)LockResource(res_handle);
  };
  return NULL;
};

static LRESULT CALLBACK banner_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
  switch(msg){
    case WM_CREATE:
      hBitmap=CreateBitmap(506,191,1,32,image);
      GetObjectW(hBitmap,sizeof(BITMAP),&bm);
      hdc=GetDC(hWnd);
      hdcMem=CreateCompatibleDC(hdc);
      hOldBitmap=(HBITMAP)SelectObject(hdcMem,hBitmap);
      hpen=CreatePen(PS_NULL,1,RGB(39,39,39));
      hbrush=CreateSolidBrush(RGB(39,39,39));
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
      SelectObject(hdc,hbrush);
      Rectangle(hdc,425-44*(tcounter%9),32,434-44*(tcounter%9),40);
      Rectangle(hdc,73+44*(tcounter%9),152,82+44*(tcounter%9),160);
      EndPaint(hWnd,&ps);
      break;
    case WM_TIMER:
      tcounter++;
      InvalidateRect(hWnd,NULL,FALSE);
      UpdateWindow(hWnd);
      break;
    case WM_CLOSE:
    case WM_ENDSESSION:
    case WM_DESTROY:
      KillTimer(hWnd,0);
      PostQuitMessage(0);
      DeleteDC(hdcMem);
      DeleteObject(hBitmap);
      DeleteObject(hOldBitmap);
      DeleteObject(hpen);
      DeleteObject(hbrush);
      break;
  }
  return DefWindowProcW(hWnd,msg,wParam,lParam);
}

extern void __stdcall start(){
  WNDCLASS wc;
  wc.style=0;
  wc.lpfnWndProc=banner_wndproc;
  wc.hInstance=0;
  wc.hIcon=LoadIconA(NULL,IDI_APPLICATION);
  wc.hCursor=LoadCursorA(NULL,IDC_ARROW);
  wc.hbrBackground=(HBRUSH)(COLOR_WINDOW+1);
  wc.lpszClassName="bclass";
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
  dptr=load_res(100);
  if(dptr){
    init_unpack();
    if((image=(uint8_t*)LocalAlloc(LMEM_ZEROINIT,image_size))){
      for(uint32_t i=0;i<image_size;i++){
        if(unpack_file()) break;
        image[i]=(uint8_t)symbol;
      };
    };
  };
  HWND hWnd=CreateWindowExA(WS_EX_TOPMOST|WS_EX_TOOLWINDOW,wc.lpszClassName,NULL,WS_POPUP,nX,nY,nWidth,nHeight,NULL,NULL,0,NULL);
  tcounter=0;
  SetTimer(hWnd,0,1000,(TIMERPROC)NULL);
  ShowWindow(hWnd,SW_SHOW);
  UpdateWindow(hWnd);
  MSG msg;
  while(GetMessageA(&msg,NULL,0,0)){
    DispatchMessageA(&msg);
    TranslateMessage(&msg);
  };
  UnregisterClassA(wc.lpszClassName,0);
  if(image) LocalFree(image);
}
