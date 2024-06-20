#include <io.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <windows.h>

#include "banner.h"

HBITMAP hBitmap,hOldBitmap;
HDC hdc,hdcMem;
BITMAP bm;
PAINTSTRUCT ps;
RECT rect,rc;
HPEN hpen;
POINT mpos;

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

extern void __stdcall start(){
  WNDCLASS wc;
  wc.style=0;
  wc.lpfnWndProc=dlg_wndproc;
  wc.hInstance=0;
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
  HWND hWnd=CreateWindowExA(WS_EX_TOPMOST,wc.lpszClassName,NULL,WS_POPUP,nX,nY,nWidth,nHeight,NULL,NULL,0,NULL);
  ShowWindow(hWnd,SW_SHOW);
  UpdateWindow(hWnd);
  MSG msg;
  while(GetMessageA(&msg,NULL,0,0)){
    DispatchMessageA(&msg);
    TranslateMessage(&msg);
  };
  UnregisterClassA(wc.lpszClassName,0);
}
