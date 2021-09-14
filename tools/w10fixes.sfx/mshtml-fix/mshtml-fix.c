#include <stdint.h>
#include <string.h>
#include <windows.h>
#include <winreg.h>

HINSTANCE WINAPI ShellExecuteA(HWND,LPCSTR,LPCSTR,LPCSTR,LPCSTR,INT);

BOOL is_admin(){
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

#include <stdio.h>

int main(int argc, char *argv[]){
  if(is_admin()||(is_admin()&&argc==2)){
    HKEY  hreg_key=NULL;
    DWORD ck_status=0;
    BYTE  value[]={0x03,0,0,0};
    char path[]="SOFTWARE\\Policies\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\0";
    char vals[4]={'0','1','2','3'};
    for(BYTE i=0;i<sizeof(DWORD);i++){
      path[75]=vals[i];
      if(RegCreateKeyExA(HKEY_LOCAL_MACHINE,path,0,NULL,
           REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL,&hreg_key,&ck_status)==ERROR_SUCCESS){
        RegSetValueExA(hreg_key,"1001",0,REG_DWORD,value,sizeof(DWORD));
        RegSetValueExA(hreg_key,"1004",0,REG_DWORD,value,sizeof(DWORD));
        RegCloseKey(hreg_key);
      };
    };
  }
  else{
    if(argc==1) ShellExecuteA(NULL,"runas",argv[0],argv[0],NULL,0);
  };
  return 0;
}
