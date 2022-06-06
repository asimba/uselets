#include <windows.h>
#include <winreg.h>

//HINSTANCE WINAPI ShellExecuteA(HWND,LPCSTR,LPCSTR,LPCSTR,LPCSTR,INT);
WINADVAPI LONG WINAPI RegDeleteTreeA(HKEY,LPCSTR);

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

void del_hkcr_reg_branch(const char *s){
  RegDeleteTreeA(HKEY_CLASSES_ROOT,s);
  RegDeleteKeyA(HKEY_CLASSES_ROOT,s);
};

extern void start(){
  if(is_admin()){
    //CVE-2021-40444
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
    //CVE-2022-30190
    del_hkcr_reg_branch("ms-msdt");
    //search-ms
    del_hkcr_reg_branch("search-ms");
  }
  else{
    char path[MAX_PATH];
    GetModuleFileNameA(0,path,MAX_PATH);
    ShellExecuteA(NULL,"runas",path,NULL,NULL,0);
  };
}
