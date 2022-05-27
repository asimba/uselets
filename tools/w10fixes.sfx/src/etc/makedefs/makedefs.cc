#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/types.h>
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

void base64(const char *src,char *dst){
  char base64chars[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789__";
  uint8_t *in_b=(uint8_t *)src,*out_b=(uint8_t *)dst;
  for(uint16_t i=0;i<3;i++){
    *(uint32_t*)out_b=0x3d3d3d3d;
    out_b[0]=base64chars[in_b[0]>>2];
    out_b[1]=base64chars[((in_b[0]&0x03)<<4)|(in_b[1]>>4)];
    out_b[2]=base64chars[((in_b[1]&0x0f)<<2)|(in_b[2]>>6)];
    out_b[3]=base64chars[in_b[2]&0x3f];
    out_b+=4;
    in_b+=3;
  };
};

void gen_h(const char *f){
  uint8_t swapbytes[256];
  uint8_t valuebytes[256];
  uint8_t symbol;
  uint16_t bytes=0;
  for(bytes=0;bytes<256;bytes++) valuebytes[bytes]=0;
  bytes=0;
  std::mt19937 mt(timebits());
  while(bytes<256){
    symbol=(uint8_t)mt();
    if(valuebytes[symbol]) continue;
    valuebytes[symbol]=1;
    swapbytes[bytes++]=symbol;
  };
  FILE *ofile=fopen(f,"wb");
  fprintf(ofile,"#ifndef _DEFS_TBL\n#define _DEFS_TBL 1\n");
  char src[10],dst[13];
  src[9]=0;
  dst[12]=0;
  fprintf(ofile,"typedef uint8_t (__stdcall *ffn)();\n");
  for(bytes=0;bytes<256;bytes++){
    sprintf(src,"%02x%02x%02x%02x",swapbytes[bytes],swapbytes[(uint8_t)(bytes+1)],
            swapbytes[(uint8_t)(bytes+2)],swapbytes[(uint8_t)(bytes+3)]);
    src[8]=swapbytes[(uint8_t)(bytes+4)];
    base64(src,dst);
    fprintf(ofile,"extern const uint8_t __%s=0x%02X;\n",dst,swapbytes[bytes]);
    fprintf(ofile,"extern \"C\" uint8_t __stdcall __%s_g(){ return __%s; };\n",dst,dst);
    fprintf(ofile,"#define FF%03u (ffn)__%s_g\n",bytes,dst);
    symbol++;
  };
  fprintf(ofile,"static ffn ffs[]={\n");
  uint8_t c=0;
  for(bytes=0;bytes<256;bytes++){
    if(c==10){
      c=0;
      fprintf(ofile,"\n");
    };
    fprintf(ofile,"FF%03u,",bytes);
    c++;
  }
  fprintf(ofile,"0\n};\n");
  fprintf(ofile,"#endif\n");
  fclose(ofile);
}

int main(int argc,char *argv[]){
  if(argc>1) gen_h(argv[1]);
  return 0;
}
