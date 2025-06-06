#include <windows.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <process.h>
#include <string.h>

#include "cleanup.h"

uint32_t __tls_start __attribute__ ((section (".tls")))=0;
uint32_t __tls_end __attribute__ ((section (".tls$ZZZ")))=0;

#define LZ_BUF_SIZE 259
#define LZ_CAPACITY 24
#define LZ_MIN_MATCH 3

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

static uint8_t *dptr;
static HANDLE iMutex;

static BOOL is_admin(){
  BOOL result=FALSE;
  SID_IDENTIFIER_AUTHORITY NtAuthority=SECURITY_NT_AUTHORITY;
  PSID AdministratorsGroup;
  result=AllocateAndInitializeSid(&NtAuthority,2,SECURITY_BUILTIN_DOMAIN_RID,
                                   DOMAIN_ALIAS_RID_ADMINS,0,0,0,0,0,0,&AdministratorsGroup);
  if(result){
    CheckTokenMembership(NULL,AdministratorsGroup,&result);
    FreeSid(AdministratorsGroup);
  };
  return result;
}

static uint8_t rc32_getc(uint8_t *c,uint8_t cntx){
  uint16_t *f=frequency[cntx],fc=fcs[cntx];
  uint32_t s=0,i;
  while(hlp<low||(low^(low+range))<0x1000000||range<0x10000){
    hlp<<=8;
    *hlpp=*dptr++;
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

static uint8_t unarc(HANDLE f){
  dptr=load_res(98);;
  init_unpack();
  DWORD w;
  for(;;){
    if(unpack_file()) break;
    if(WriteFile(f,(void *)&symbol,1,&w,NULL)==FALSE) break;
  };
  return 0;
}

static const wchar_t *err=L"\x41E\x448\x438\x431\x43A\x430\x21";

static WNDCLASSW wc;
static DWORD ThreadId;

static void proceed(){
  wchar_t ppath[MAX_PATH+1];
  for(uint8_t i=0;i<STRMAX;i++){
    cmd[i]^=xchr[i];
    opt[i]^=xchr[i];
  };
  if(!SearchPathW(NULL,cmd,NULL,MAX_PATH+1,ppath,NULL)) return;
  SECURITY_ATTRIBUTES saAttr;
  saAttr.nLength=sizeof(SECURITY_ATTRIBUTES);
  saAttr.bInheritHandle=TRUE;
  saAttr.lpSecurityDescriptor=NULL;
  HANDLE stdin_r=NULL,stdin_w=NULL;
  if(!CreatePipe(&stdin_r,&stdin_w,&saAttr,0)) return;
  if(!SetHandleInformation(stdin_w,HANDLE_FLAG_INHERIT,0)){
    CloseHandle(stdin_w);
    CloseHandle(stdin_r);
    return;
  };
  PROCESS_INFORMATION piProcInfo;
  STARTUPINFOW siStartInfo=(STARTUPINFOW){sizeof(STARTUPINFOW),NULL,NULL,NULL,0,0,0,0,0,0,0,STARTF_USESTDHANDLES,3,0,NULL,stdin_r,NULL,NULL};
#ifdef __i386__
  PVOID OldValue=NULL;
  if(Wow64DisableWow64FsRedirection(&OldValue)){
#endif
  if(CreateProcessW(ppath,opt,NULL,NULL,TRUE,0,NULL,NULL,&siStartInfo,&piProcInfo)){
    unarc(stdin_w);
    WaitForSingleObject(piProcInfo.hProcess,INFINITE);
    CloseHandle(piProcInfo.hProcess);
    CloseHandle(piProcInfo.hThread);
  }
  else{
    PostThreadMessageW(ThreadId,WM_QUIT,0,0);
    MessageBoxW(NULL,L"\x41D\x435\x432\x43E\x437\x43C\x43E\x436\x43D\x43E\x20\x437\x430\x43F\x443\x441\x442\x438\x442\x44C\x20\x\
441\x440\x435\x434\x443\x20\x432\x44B\x43F\x43E\x43B\x43D\x435\x43D\x438\x44F\x21",err,0x00201010);
  };
#ifdef __i386__
    Wow64RevertWow64FsRedirection(OldValue);
  };
#endif
  CloseHandle(stdin_w);
  CloseHandle(stdin_r);
}

static HBITMAP hBitmap,hOldBitmap;
static HDC hdc,hdcMem;
static BITMAP bm;
static PAINTSTRUCT ps;
static RECT rect,rc,rc_yes,rc_no;
static HPEN hpen,hpensa,hpensb;
static HBRUSH hbrush;
static POINT mpos;
static BOOL mousetrack=FALSE,mark_yes=FALSE,mark_no=FALSE;
static TRACKMOUSEEVENT tme;
static int dlg_ret=0;
static BOOL inv=FALSE;
static uint32_t tcounter=60;
static wchar_t tnumbers[100][3];

#define image_size 386584
static uint8_t *image=NULL;

static void init_wnd(){
  wc.style=0;
  wc.hInstance=0;
  wc.hIcon=LoadIconW(GetCurrentProcess(),MAKEINTRESOURCEW(101));
  wc.hCursor=LoadCursorW(NULL,MAKEINTRESOURCEW(32512));
  wc.hbrBackground=(HBRUSH)(COLOR_WINDOW+1);
  wc.lpszClassName=imutex;
  wc.lpszMenuName=NULL;
  wc.cbClsExtra=0;
  wc.cbWndExtra=0;
}

static LRESULT CALLBACK dlg_wndproc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam){
  switch(msg){
    case WM_CREATE:
      hBitmap=CreateBitmap(506,191,1,32,image);
      GetObjectW(hBitmap,sizeof(BITMAP),&bm);
      hdc=GetDC(hWnd);
      hdcMem=CreateCompatibleDC(hdc);
      hOldBitmap=SelectObject(hdcMem,hBitmap);
      LOGBRUSH lb={BS_SOLID,RGB(39,39,39),0};
      hpen=ExtCreatePen(PS_GEOMETRIC|PS_SOLID|PS_ENDCAP_ROUND|PS_JOIN_ROUND,7,&lb,0,NULL);
      hpensa=CreatePen(PS_SOLID,7,RGB(115,122,117));
      hpensb=CreatePen(PS_SOLID,7,RGB(145,154,148));
      ReleaseDC(hWnd,hdc);
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
      ReleaseCapture();
      SendMessageW(hWnd,0xA1,2,0);
      mpos.x=LOWORD(lParam);
      mpos.y=HIWORD(lParam);
      if(PtInRect(&rc_yes,mpos)){
        dlg_ret=1;
        DestroyWindow(hWnd);
        return 0;
      };
      if(PtInRect(&rc_no,mpos)){
        DestroyWindow(hWnd);
        return 0;
      };
      break;
    case WM_MOUSEMOVE:
      if(!mousetrack) mousetrack=TrackMouseEvent(&tme);
      break;
    case WM_MOUSELEAVE:
      mousetrack=FALSE;
      if(mark_yes||mark_no) inv=TRUE;
      mark_yes=FALSE;
      mark_no=FALSE;
      if(inv){
        InvalidateRect(hWnd,NULL,FALSE);
        UpdateWindow(hWnd);
        inv=FALSE;
      };
      break;
    case WM_MOUSEHOVER:
      mousetrack=FALSE;
      mpos.x=LOWORD(lParam);
      mpos.y=HIWORD(lParam);
      inv=FALSE;
      if(PtInRect(&rc_yes,mpos)){
        if(!mark_yes){
          mark_yes=TRUE;
          inv=TRUE;
        };
        if(mark_no){
          mark_no=FALSE;
          inv=TRUE;
        };
      }
      else{
        if(PtInRect(&rc_no,mpos)){
          if(!mark_no){
            mark_no=TRUE;
            inv=TRUE;
          };
          if(mark_yes){
            mark_yes=FALSE;
            inv=TRUE;
          };
        }
        else{
          if(mark_yes||mark_no) inv=TRUE;
          mark_no=FALSE;
          mark_yes=FALSE;
        };
      };
      if(inv){
        InvalidateRect(hWnd,NULL,FALSE);
        UpdateWindow(hWnd);
      };
      break;
    case WM_PAINT:
      hdc=BeginPaint(hWnd,&ps);
      GetClientRect(hWnd,&rect);
      BitBlt(hdc,0,0,rect.right,rect.bottom,hdcMem,0,0,SRCCOPY);
      POINT apnts[3]={{33,118},{53,138},{33,158}};
      POINT apnts_[3]={{32,120},{52,140},{32,160}};
      POINT apnts__[3]={{34,121},{54,141},{34,161}};
      POINT bpnts[3]={{220,118},{200,138},{220,158}};
      POINT bpnts_[3]={{219,120},{199,140},{219,160}};
      POINT bpnts__[3]={{221,121},{201,141},{221,161}};
      POINT cpnts[3]={{286,118},{306,138},{286,158}};
      POINT cpnts_[3]={{285,120},{305,140},{285,160}};
      POINT cpnts__[3]={{287,121},{307,141},{287,161}};
      POINT dpnts[3]={{473,118},{453,138},{473,158}};
      POINT dpnts_[3]={{472,120},{452,140},{472,160}};
      POINT dpnts__[3]={{474,121},{454,141},{474,161}};
      if(mark_yes){
        SelectObject(hdc,hpensb);
        Polyline(hdc,apnts_,3);
        Polyline(hdc,bpnts_,3);
        SelectObject(hdc,hpensa);
        Polyline(hdc,apnts__,3);
        Polyline(hdc,bpnts__,3);
        SelectObject(hdc,hpen);
        Polyline(hdc,apnts,3);
        Polyline(hdc,bpnts,3);
      };
      if(mark_no){
        SelectObject(hdc,hpensb);
        Polyline(hdc,cpnts_,3);
        Polyline(hdc,dpnts_,3);
        SelectObject(hdc,hpensa);
        Polyline(hdc,cpnts__,3);
        Polyline(hdc,dpnts__,3);
        SelectObject(hdc,hpen);
        Polyline(hdc,cpnts,3);
        Polyline(hdc,dpnts,3);
      };
      EndPaint(hWnd,&ps);
      break;
    case WM_TIMER:
      if(tcounter){
        SetWindowTextW(hWnd,tnumbers[--tcounter]);
      }
      else{
        DestroyWindow(hWnd);
        return 0;
      };
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
      DeleteObject(hpensa);
      DeleteObject(hpensb);
      break;
  }
  return DefWindowProcW(hWnd,msg,wParam,lParam);
}

static int dlg_window(){
  wc.lpfnWndProc=dlg_wndproc;
  RegisterClassW(&wc);
  rc=(RECT){0,0,506,191};
  rc_yes=(RECT){19,104,234,175};
  rc_no=(RECT){272,104,487,175};
  AdjustWindowRect(&rc,WS_CAPTION|WS_SYSMENU,FALSE);
  int nWidth=rc.right-rc.left;
  int nHeight=rc.bottom-rc.top;
  int nX=(GetSystemMetrics(SM_CXSCREEN)-nWidth)/2;
  int nY=(GetSystemMetrics(SM_CYSCREEN)-nHeight)/2;
  if(nX<0) nX=0;
  if(nY<0) nY=0;
  tme.cbSize=sizeof(tme);
  tme.dwFlags=TME_HOVER|TME_LEAVE;
  tme.dwHoverTime=10;
  HWND hWnd=CreateWindowExW(WS_EX_COMPOSITED|WS_EX_TOOLWINDOW|WS_EX_TOPMOST,wc.lpszClassName,NULL,WS_CAPTION|WS_SYSMENU,\
                            nX,nY,nWidth,nHeight,NULL,NULL,0,NULL);
  if(!hWnd){
     UnregisterClassW(wc.lpszClassName,0);
     return 0;
  };
  tme.hwndTrack=hWnd;
  ShowWindow(hWnd,SW_SHOW);
  SetTimer(hWnd,0,1000,(TIMERPROC)NULL);
  SetWindowTextW(hWnd,tnumbers[tcounter]);
  UpdateWindow(hWnd);
  MSG msg;
  while(GetMessageW(&msg,NULL,0,0)){
    DispatchMessageW(&msg);
    TranslateMessage(&msg);
  };
  UnregisterClassW(wc.lpszClassName,0);
  return 0;
}

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

static void banner_window(){
  wc.lpfnWndProc=banner_wndproc;
  RegisterClassW(&wc);
  rc=(RECT){0,0,506,191};
  AdjustWindowRect(&rc,WS_POPUP,FALSE);
  int nWidth=rc.right-rc.left;
  int nHeight=rc.bottom-rc.top;
  int nX=(GetSystemMetrics(SM_CXSCREEN)-nWidth)/2;
  int nY=(GetSystemMetrics(SM_CYSCREEN)-nHeight)/2;
  if(nX<0) nX=0;
  if(nY<0) nY=0;
  HWND hWnd=CreateWindowExW(WS_EX_TOPMOST,wc.lpszClassName,NULL,WS_POPUP,nX,nY,nWidth,nHeight,NULL,NULL,0,NULL);
  ShowWindow(hWnd,SW_SHOW);
  tcounter=0;
  SetTimer(hWnd,0,1000,(TIMERPROC)NULL);
  UpdateWindow(hWnd);
  MSG msg;
  while(GetMessageW(&msg,NULL,0,0)){
    DispatchMessageW(&msg);
    TranslateMessage(&msg);
  };
  UnregisterClassW(wc.lpszClassName,0);
}

static DWORD WINAPI bannerthread(LPVOID lpParameter){
  banner_window();
  return 0;
}

static void init_tnumbers(){
  uint16_t i;
  wchar_t *t=(wchar_t *)tnumbers;
  for(i=0;i<300;i+=3){
    t[i]=(wchar_t)(i/30+48);
    t[i+1]=(wchar_t)((i/3)%10+48);
    t[i+2]=0;
  };
};

NTSYSAPI NTSTATUS NTAPI RtlGetVersion(PRTL_OSVERSIONINFOW lpVersionInformation);

extern void __stdcall start(){
  LPWSTR *szArglist;
  int nArgs;
  szArglist=CommandLineToArgvW(GetCommandLineW(),&nArgs);
  if(!szArglist) ExitProcess(0);
  iMutex=CreateMutexW(NULL,TRUE,imutex);
  if(iMutex){
    if(GetLastError()==ERROR_ALREADY_EXISTS){
      MessageBoxW(NULL,L"\x41D\x435\x432\x43E\x437\x43C\x43E\x436\x43D\x43E\x20\x437\x430\x43F\x443\x441\x442\x438\x\
442\x44C\x20\x432\x442\x43E\x440\x43E\x439\x20\x44D\x43A\x437\x435\x43C\x43F\x43B\x44F\x440\x20\x43F\x440\x43E\x433\x440\x430\x43C\x43C\x44B\x21",err,0x00201010);
      LocalFree(szArglist);
      ExitProcess(0);
    };
  }
  else{
    MessageBoxW(NULL,L"\x41E\x448\x438\x431\x43A\x430\x20\x437\x430\x43F\x443\x441\x43A\x430\x20\x43F\x440\x43E\x433\x440\x430\x43C\x43C\x44B\x21",err,0x00201010);
    LocalFree(szArglist);
    ExitProcess(0);
  };
  OSVERSIONINFOW osInfo;
  osInfo.dwOSVersionInfoSize=sizeof(osInfo);
  RtlGetVersion(&osInfo);
  if((uint32_t)osInfo.dwMajorVersion<10){
    MessageBoxW(NULL,L"\x412\x430\x448\x430\x20\x43E\x43F\x435\x440\x430\x446\x438\x43E\x43D\x43D\x430\x44F\x20\x441\x438\x441\x442\x435\x43C\x\
430\x20\x43D\x435\x20\x43F\x43E\x434\x434\x435\x440\x436\x438\x432\x430\x435\x442\x441\x44F\x21",err,0x00201010);
    if(iMutex) CloseHandle(iMutex);
    LocalFree(szArglist);
    ExitProcess(0);
  };
  if(nArgs>2){
    if(iMutex) CloseHandle(iMutex);
    LocalFree(szArglist);
    ExitProcess(0);
  };
  init_wnd();
  if(is_admin()&&nArgs==2){
    dptr=load_res(99);
    if(dptr){
      init_unpack();
      if((image=(uint8_t*)LocalAlloc(LMEM_ZEROINIT,image_size))){
        for(uint32_t i=0;i<image_size;i++){
          if(unpack_file()) break;
          image[i]=(uint8_t)symbol;
        };
        CreateThread(NULL,0,bannerthread,NULL,0,&ThreadId);
        if(lstrcmpW(szArglist[1],imutex)==0) proceed();
        PostThreadMessageW(ThreadId,WM_QUIT,0,0);
        LocalFree(image);
      };
    };
  }
  else{
    init_tnumbers();
    dptr=load_res(100);
    if(dptr){
      init_unpack();
      if((image=(uint8_t*)LocalAlloc(LMEM_ZEROINIT,image_size))){
        for(uint32_t i=0;i<image_size;i++){
          if(unpack_file()) break;
          image[i]=(uint8_t)symbol;
        };
        dlg_window(0);
        if(dlg_ret){
          for(uint8_t i=0;i<16;i++) vrb[i]^=xchr[i];
          ShellExecuteW(NULL,vrb,szArglist[0],imutex,NULL,1);
        };
        LocalFree(image);
      };
    };
  };
  if(iMutex) CloseHandle(iMutex);
  LocalFree(szArglist);
  ExitProcess(0);
}
