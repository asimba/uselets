#include <stdint.h>
#include <windows.h>
#include <shlwapi.h>

#define SVCNAME "RServer3"

void __stdcall start(){
  SC_HANDLE schSCManager,schService;
  SERVICE_STATUS_PROCESS ssp;
  DWORD dwStartTime=GetTickCount(), dwBytesNeeded, dwTimeout=10000;
  if((schSCManager=OpenSCManagerA(NULL,NULL,SC_MANAGER_ALL_ACCESS))==NULL) return;
  if((schService=OpenServiceA(schSCManager,SVCNAME,SERVICE_ALL_ACCESS))==NULL){
    CloseServiceHandle(schSCManager);
    return;
  };
  if(!QueryServiceStatusEx(schService,SC_STATUS_PROCESS_INFO,(LPBYTE)&ssp,
                           sizeof(SERVICE_STATUS_PROCESS),&dwBytesNeeded)) goto stop_cleanup;
  if(ssp.dwCurrentState!=SERVICE_STOPPED&&ssp.dwCurrentState!=SERVICE_STOP_PENDING) goto stop_cleanup;
  while(ssp.dwCurrentState==SERVICE_STOP_PENDING){
    Sleep(ssp.dwWaitHint);
    if(!QueryServiceStatusEx(schService,SC_STATUS_PROCESS_INFO,(LPBYTE)&ssp,
                 sizeof(SERVICE_STATUS_PROCESS),&dwBytesNeeded)) goto stop_cleanup;
    if(GetTickCount()-dwStartTime>dwTimeout) goto stop_cleanup;
  };
  if(!StartServiceA(schService,0,NULL)) goto stop_cleanup;
  if(!QueryServiceStatusEx(schService,SC_STATUS_PROCESS_INFO,(LPBYTE)&ssp,
                           sizeof(SERVICE_STATUS_PROCESS),&dwBytesNeeded)) goto stop_cleanup;
  while(ssp.dwCurrentState==SERVICE_START_PENDING){
    Sleep(ssp.dwWaitHint);
    if(!QueryServiceStatusEx(schService,SC_STATUS_PROCESS_INFO,(LPBYTE)&ssp,
                 sizeof(SERVICE_STATUS_PROCESS),&dwBytesNeeded)) goto stop_cleanup;
    if(GetTickCount()-dwStartTime>dwTimeout) goto stop_cleanup;
  };
  if(ssp.dwCurrentState==SERVICE_RUNNING) goto stop_cleanup;
stop_cleanup:
  CloseServiceHandle(schService);
  CloseServiceHandle(schSCManager);
}
