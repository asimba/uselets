#include <windows.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <process.h>
#include <string.h>

#define LZ_BUF_SIZE 259
#define LZ_CAPACITY 24
#define LZ_MIN_MATCH 3

uint8_t flags;
uint8_t cbuffer[LZ_CAPACITY+1];
uint8_t vocbuf[0x10000];
uint16_t frequency[256][256];
uint16_t fcs[256];
uint16_t buf_size;
uint16_t vocroot;
uint16_t offset;
uint16_t length;
uint16_t symbol;
uint32_t low;
uint32_t hlp;
uint32_t range;
char *lowp;
char *hlpp;
uint8_t *cpos;
uint8_t rle_flag;
uint8_t cstate;

typedef struct _SHELLEXECUTEINFOA {
  DWORD     cbSize;
  ULONG     fMask;
  HWND      hwnd;
  LPCSTR    lpVerb;
  LPCSTR    lpFile;
  LPCSTR    lpParameters;
  LPCSTR    lpDirectory;
  int       nShow;
  HINSTANCE hInstApp;
  void      *lpIDList;
  LPCSTR    lpClass;
  HKEY      hkeyClass;
  DWORD     dwHotKey;
  union {
    HANDLE hIcon;
    HANDLE hMonitor;
  } DUMMYUNIONNAME;
  HANDLE    hProcess;
} SHELLEXECUTEINFOA, *LPSHELLEXECUTEINFOA;

HINSTANCE WINAPI ShellExecuteA(HWND,LPCSTR,LPCSTR,LPCSTR,LPCSTR,INT);
BOOL WINAPI ShellExecuteExA(SHELLEXECUTEINFOA *pExecInfo);

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

uint8_t rc32_getc(uint8_t *c,FILE *ifile){
  uint16_t *f=frequency[cstate],fc=fcs[cstate];
  uint32_t count,s=0;
  while((low^(low+range))<0x1000000||range<0x10000||hlp<low){
    hlp<<=8;
    *hlpp=fgetc(ifile);
    if(ferror(ifile)) return 1;
    if(feof(ifile)) return 0;
    low<<=8;
    range<<=8;
    if((uint32_t)(range+low)<low) range=~low;
  };
  if((count=(hlp-low)/(range/=fc))>=fc) return 1;
  while((s+=*f++)<=count);
  *c=(uint8_t)(--f-frequency[cstate]);
  low+=(s-*f)*range;
  range*=(*f)++;
  if(++fc==0){
    f=frequency[cstate];
    for(s=0;s<256;s++){
      *f=((*f)>>1)|1;
      fc+=*f++;
    };
  };
  fcs[cstate]=fc;
  cstate=*c;
  return 0;
}

uint8_t unpack_file(FILE *ifile){
  uint16_t i;
  if(length){
    if(!rle_flag){
      symbol=vocbuf[offset++];
      vocbuf[vocroot++]=symbol;
    };
    length--;
  }
  else{
    if(flags==0){
      cpos=cbuffer;
      if(rc32_getc(cpos++,ifile)) return 1;
      length=offset=flags=8;
      symbol=*cbuffer;
      while(offset--){
        if((symbol&0x1)==0) length+=2;
        symbol>>=1;
      };
      while(length--)
        if(rc32_getc(cpos++,ifile)) return 1;
      cpos=cbuffer+1;
    };
    length=0;
    if(*cbuffer&0x80){
      symbol=*cpos;
      vocbuf[vocroot++]=*cpos;
    }
    else{
      length=*cpos+++LZ_MIN_MATCH+1;
      offset=*(uint16_t*)cpos++;
      if(offset==0x0100) return 1;
      if(offset<0x0100){
        rle_flag=1;
        symbol=offset;
        for(i=0;i<length;i++) vocbuf[vocroot++]=symbol;
      }
      else{
        rle_flag=0;
        offset=~offset+(uint16_t)(vocroot+LZ_BUF_SIZE);
        symbol=vocbuf[offset++];
        vocbuf[vocroot++]=symbol;
      };
      length--;
    };
    *cbuffer<<=1;
    cpos++;
    flags--;
  };
  return 0;
}

void rmkdir(char *path,int depth){
  for(int i=depth;i<strlen(path);i++){
    if(path[i]=='/'){
      path[i]=0;
      if(access(path,0)!=0){
        mkdir(path);
        if(access(path,0)!=0) return;
      };
      path[i]='/';
      depth=i+1;
      rmkdir(path,depth);
      break;
    };
  };
  return;
}

void read_value(void *p,uint16_t s,FILE *f){
  for(uint16_t i=0;i<s;i++) ((char *)p)[i]=fgetc(f);
}

uint8_t read_packed_value(void *p,uint16_t s,FILE *f){
  for(uint16_t i=0;i<s;i++){
    if(unpack_file(f)) return 1;
    ((char *)p)[i]=(char)symbol;
  };
  return 0;
}

void unarc(char *out,char *fn){
  FILE *f=fopen(fn,"rb"),*o;
  uint32_t fl=0,i;
  char *t=(char *)&fl,fp[257];
  fseek(f,60,SEEK_SET);
  read_value(&range,sizeof(uint32_t),f);
  fseek(f,range+6,SEEK_SET);
  read_value(&length,sizeof(uint16_t),f);
  fseek(f,0x100,SEEK_CUR);
  while(length--){
    read_value(&hlp,sizeof(uint32_t),f);
    read_value(&low,sizeof(uint32_t),f);
    if(low>fl){
      fl=low;
      range=low+hlp;
    }
    fseek(f,32,SEEK_CUR);
  };
  fseek(f,range,SEEK_SET);
  if(feof(f)) return;
  buf_size=flags=vocroot=low=hlp=length=rle_flag=cstate=0;
  offset=range=0xffffffff;
  lowp=&((char *)&low)[3];
  hlpp=&((char *)&hlp)[0];
  for(i=0;i<256;i++){
    for(int j=0;j<256;j++) frequency[i][j]=1;
    fcs[i]=256;
  };
  for(i=0;i<0x10000;i++) vocbuf[i]=0xff;
  for(i=0;i<sizeof(uint32_t);i++){
    hlp<<=8;
    *hlpp=fgetc(f);
    if(ferror(f)||feof(f)) return;
  }
  for(;;){
    if(read_packed_value(t,sizeof(uint32_t),f)) goto close_fp;
    if(feof(f)) break;
    for(i=0;i<strlen(out);i++) fp[i]=out[i];
    fp[i]='/';
    if(read_packed_value(&fp[strlen(out)+1],fl,f)) goto close_fp;
    fp[fl+strlen(out)+1]=0;
    if(read_packed_value(t,sizeof(uint32_t),f)) goto close_fp;
    rmkdir(fp,0);
    o=fopen(fp,"wb");
    for(i=0;i<fl;i++){
      if(unpack_file(f)) goto close_fp;
      if(o) fputc((char)symbol,o);
    };
    if(o) fclose(o);
  };
close_fp:
  fclose(f);
}

void install_certs(char *src){
  char tpath[MAX_PATH+1];
  if(GetTempPathA(MAX_PATH,tpath)==0) return;
  char dpath[MAX_PATH+1];
  if(GetTempFileNameA(tpath,"crt",0,dpath)==0) return;
  remove(dpath);
  dpath[strlen(dpath)+1]=0;
  dpath[strlen(dpath)]='\\';
  unarc(dpath,src);
  char cmd[MAX_PATH+1];
  sprintf(cmd,"%s\\System32\\certutil.exe",getenv("WINDIR"));
  SHELLEXECUTEINFOA ShExecInfo;
  ShExecInfo.cbSize=sizeof(SHELLEXECUTEINFOA);
  ShExecInfo.lpDirectory=NULL;
  ShExecInfo.hwnd=NULL;
  ShExecInfo.nShow=0;
  ShExecInfo.hInstApp=0;
  ShExecInfo.fMask=0x00000140;
  ShExecInfo.lpVerb="runas";
  ShExecInfo.lpFile=cmd;
  char fpath[MAX_PATH+1];
  ShExecInfo.lpParameters=fpath;
  sprintf(tpath,"%scerts\\",dpath);
  sprintf(fpath," -f -addstore Root \"%sroot.sst\"",tpath);
  if(ShellExecuteExA(&ShExecInfo)!=FALSE){
    WaitForSingleObject(ShExecInfo.hProcess,INFINITE);
    CloseHandle(ShExecInfo.hProcess);
  };
  sprintf(fpath,"%sroot.sst",tpath);
  remove(fpath);
  sprintf(fpath," -f -addstore CA \"%sca.sst\"",tpath);
  if(ShellExecuteExA(&ShExecInfo)!=FALSE){
    WaitForSingleObject(ShExecInfo.hProcess,INFINITE);
    CloseHandle(ShExecInfo.hProcess);
  };
  sprintf(fpath,"%sca.sst",tpath);
  remove(fpath);
  rmdir(tpath);
  rmdir(dpath);
}

int main(int argc,char *argv[]){
  if(argc>2) return 0;
  if(is_admin()&&argc==2){
    if(strcmp(argv[1],"install")==0) install_certs(argv[0]);
  }
  else{
    if(MessageBoxA(NULL,"���������� �������� �����������?","��������!",0x00001034)==6){
      SHELLEXECUTEINFOA ShExecInfo;
      ShExecInfo.cbSize=sizeof(SHELLEXECUTEINFOA);
      ShExecInfo.lpDirectory=NULL;
      ShExecInfo.hwnd=NULL;
      ShExecInfo.nShow=0;
      ShExecInfo.hInstApp=0;
      ShExecInfo.fMask=0x00000140;
      ShExecInfo.lpVerb="runas";
      ShExecInfo.lpFile=argv[0];
      char fpath[MAX_PATH+1];
      ShExecInfo.lpParameters="install";
      if(ShellExecuteExA(&ShExecInfo)!=FALSE){
        WaitForSingleObject(ShExecInfo.hProcess,INFINITE);
        CloseHandle(ShExecInfo.hProcess);
      };
    };
  };
  return 0;
}
