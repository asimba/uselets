#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include <windows.h>

#define TIME_TYPE LARGE_INTEGER
#define GET_TIME(s) (QueryPerformanceCounter(&(s)))
#define GET_TIME_LAST_2BYTES(s) ((uint32_t)((s).QuadPart&0xffff))
#define GET_TIME_LAST_BIT(s) ((uint32_t)((s).QuadPart&1))

inline double pi(uint32_t t){
  double p=0.0;
  double s=1.0;
  for(uint32_t i=0; i<t; i++){
    double k=8.0*i;
    p+=(4.0/(k+1)-2.0/(k+4)-1.0/(k+5)-1.0/(k+6))/s;
    s*=16.0;
  };
  return p;
}

uint32_t timeshift(){
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

uint32_t timebits(){
  uint32_t l=0;
  for(uint8_t i=0; i<32; i++){
    l<<=1;
    l|=timeshift();
  };
  return l;
}

uint8_t mask=0;

uint8_t write_shift=0;

inline void byte2bytes_raw(uint8_t *&p,uint8_t b){
  *p=(*p&0xfc)|((b>>6)&0x03);
  p++;
  write_shift++;
  if(write_shift==3){
    p++;
    write_shift=0;
  };
  *p=(*p&0xfc)|((b>>4)&0x03);
  p++;
  write_shift++;
  if(write_shift==3){
    p++;
    write_shift=0;
  };
  *p=(*p&0xfc)|((b>>2)&0x03);
  p++;
  write_shift++;
  if(write_shift==3){
    p++;
    write_shift=0;
  };
  *p=(*p&0xfc)|(b&0x03);
  p++;
  write_shift++;
  if(write_shift==3){
    p++;
    write_shift=0;
  };
};

inline void byte2bytes(uint8_t *&p,uint8_t b){
  uint8_t c=b;
  b^=mask;
  byte2bytes_raw(p,b);
  mask=c;
};

inline void uint2bytes(uint8_t *&p,uint32_t b){
  byte2bytes(p,(uint8_t)(b>>24));
  byte2bytes(p,(uint8_t)(b>>16));
  byte2bytes(p,(uint8_t)(b>>8));
  byte2bytes(p,(uint8_t)(b));
};

int main(int argc,char *argv[]){
  if(argc<6) return 0;
  FILE *n=fopen(argv[1],"rb");
  fseek(n,0,SEEK_END);
  uint32_t nsize=ftell(n),datasize=0;
  fseek(n,0,SEEK_SET);
  printf("Source  image  size  (bytes): %u\n",nsize);
  if(nsize<=54){
    fclose(n);
    return 0;
  };
  nsize-=54;
  printf("Available space size (bytes): %u\n",nsize/5-1);
  FILE *a=fopen(argv[2],"rb");
  fseek(a,0,SEEK_END);
  uint32_t asize=ftell(a);
  fseek(a,0,SEEK_SET);
  FILE *b=fopen(argv[3],"rb");
  fseek(b,0,SEEK_END);
  uint32_t bsize=ftell(b);
  fseek(b,0,SEEK_SET);
  FILE *c=fopen(argv[4],"rb");
  fseek(c,0,SEEK_END);
  uint32_t csize=ftell(c);
  fseek(c,0,SEEK_SET);
  datasize=asize+bsize+csize+3*sizeof(uint32_t);
  printf("Data  size  (bytes)         : %u\n",datasize);
  if(datasize>nsize/5-1){
    printf("Error! Space insufficient!\n");
    fclose(n);
    fclose(a);
    fclose(b);
    fclose(c);
    return 1;
  };
  FILE *o=fopen(argv[5],"wb");
  nsize+=54;
  uint8_t *ibytes=(uint8_t*)calloc(nsize,1);
  fread(ibytes,1,nsize,n);
  uint32_t i;
  uint8_t *write_ptr=ibytes+54,s;
  uint32_t seed=timebits();
  mask=(uint8_t)seed;
  byte2bytes_raw(write_ptr,mask);
  uint2bytes(write_ptr,asize);
  for(i=0;i<asize;i++) byte2bytes(write_ptr,(uint8_t)fgetc(a));
  uint2bytes(write_ptr,bsize);
  for(i=0;i<bsize;i++) byte2bytes(write_ptr,(uint8_t)fgetc(b));
  uint2bytes(write_ptr,csize);
  for(i=0;i<csize;i++) byte2bytes(write_ptr,(uint8_t)fgetc(c));
  if(write_ptr<ibytes+nsize){
    while(write_ptr<ibytes+nsize){
      s=(uint8_t)seed;
      byte2bytes(write_ptr,s);
      seed=((seed*22695477+1)>>16)&0x00007fff;
    };
  };
  fwrite(ibytes,1,nsize,o);
  free(ibytes);
  fclose(o);
  fclose(a);
  fclose(b);
  fclose(c);
  fclose(n);
  return 0;
}
