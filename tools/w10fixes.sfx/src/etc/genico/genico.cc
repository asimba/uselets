#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <windows.h>
#include <random>

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

int main(int argc,char *argv[]){
  FILE *f=NULL;
  uint32_t size=0;
  if(argc<2) return 1;
  f=fopen(argv[1],"wb");
  uint8_t *buf=(uint8_t *)calloc(4096,1);
  uint8_t *ptr=buf;
  if(!buf){
    fclose(f);
    return 0;
  };
  *(uint16_t*)ptr=0;
  ptr+=2;
  *(uint16_t*)ptr=1;
  ptr+=2;
  *(uint16_t*)ptr=1;
  ptr+=2;
  *ptr++=48;
  *ptr++=48;
  ptr+=2;
  *(uint16_t*)ptr=1;
  ptr+=2;
  *(uint16_t*)ptr=8;
  ptr+=2;
  size=40+48*48+48*8+256*4;
  *(uint32_t*)ptr=size;
  ptr+=4;
  *(uint32_t*)ptr=ptr-buf+4;
  ptr+=4;
  size+=(uint32_t)(ptr-buf);
  *(uint32_t*)ptr=40;
  ptr+=4;
  *(uint32_t*)ptr=48;
  ptr+=4;
  *(uint32_t*)ptr=48+48;
  ptr+=4;
  *(uint16_t*)ptr=1;
  ptr+=2;
  *(uint16_t*)ptr=8;
  ptr+=2;
  *(uint32_t*)ptr=0;
  ptr+=4;
  *(uint32_t*)ptr=0;
  ptr+=20;
  std::mt19937 mt(timebits());
  uint32_t mask=0;
  for(uint32_t i=0;i<256;i++){
    *(uint32_t*)ptr=mt()&0xffffff00;
    ptr+=4;
  };
  //ptr+=256*4;
  printf("ICO size (bytes): %u\n",size);
  uint8_t *p;
  for(uint32_t l=0;l<6;l++){
    for(uint32_t i=0;i<6;i++){
      mask=(uint8_t)mt();
      p=ptr;
      for(uint32_t j=0;j<8;j++){
        for(uint32_t k=0;k<8;k++) *(uint8_t*)(p+k)=(uint8_t)mask;
        p+=48;
      };
      ptr+=8;
    };
    ptr+=336;
  };
  /*
  for(uint32_t i=0;i<48*48;i++){
    if(i%384==0) mask=(uint8_t)mt();
    *ptr++=(uint8_t)mask;
  };
  */
  fwrite(buf,size,1,f);
  free(buf);
  fclose(f);
  return 0;
}
