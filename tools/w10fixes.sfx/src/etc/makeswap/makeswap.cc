#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
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

void gen_h(const char *f,const char *b){
  uint8_t swapbytes[256];
  uint8_t valuebytes[256];
  uint8_t symbol;
  uint16_t bytes=0;
  for(bytes=0;bytes<256;bytes++) valuebytes[bytes]=0;
  uint32_t seed=timebits();
  bytes=0;
  while(bytes<256){
    symbol=(uint8_t)seed;
    if(valuebytes[symbol]){
      seed=((seed*22695477+1)>>16)&0x00007fff;
      symbol=(uint8_t)seed;
    };
    if(valuebytes[symbol]){
      seed=((seed*22695477+1)>>16)&0x00007fff;
      symbol=(uint8_t)seed;
    };
    if(valuebytes[symbol]){
      seed=((seed*22695477+1)>>16)&0x00007fff;
      symbol=(uint8_t)seed;
    };
    if(valuebytes[symbol]){
      seed=timebits();
      continue;
    };
    valuebytes[symbol]=1;
    swapbytes[bytes++]=symbol;
  };
  FILE *ofile=fopen(f,"wb");
  fprintf(ofile,"#ifndef _SWAP_TBL\n#define _SWAP_TBL 1\n");
  fprintf(ofile,"#define F_0 (char)(0x%02x)\n",swapbytes[0]);
  for(bytes=0;bytes<256;bytes++) valuebytes[swapbytes[bytes]]=(uint8_t)bytes;
  fprintf(ofile,"static constexpr uint8_t swapbytes[]={\n");
  symbol=0;
  for(bytes=0;bytes<256;bytes++){
    if(symbol==20){
      symbol=0;
      fprintf(ofile,"\n");
    };
    fprintf(ofile,"0x%02X,",swapbytes[bytes]);
    symbol++;
  };
  fprintf(ofile,"0\n};\n");
  fprintf(ofile,"#endif\n");
  fclose(ofile);
  ofile=fopen(b,"wb");
  for(bytes=0;bytes<256;bytes++){
    fputc(valuebytes[bytes],ofile);
  };
  fclose(ofile);
}

int main(int argc,char *argv[]){
  if(argc>2) gen_h(argv[1],argv[2]);
  return 0;
}
