#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void read_value(void *p,uint16_t s,FILE *f){
  for(uint16_t i=0;i<s;i++) ((char *)p)[i]=fgetc(f);
}

void get_padding(const char *fn){
  FILE *f=fopen(fn,"rb");
  uint32_t range=0,fl=0,hlp,low;
  uint16_t lenght=0;
  fseek(f,60,SEEK_SET);
  read_value(&range,sizeof(uint32_t),f);
  fseek(f,range+6,SEEK_SET);
  read_value(&lenght,sizeof(uint16_t),f);
  fseek(f,0x100,SEEK_CUR);
  while(lenght--){
    read_value(&hlp,sizeof(uint32_t),f);
    read_value(&low,sizeof(uint32_t),f);
    if(low>fl){
      fl=low;
      range=low+hlp;
    }
    fseek(f,32,SEEK_CUR);
  };
  fseek(f,range,SEEK_SET);
  low=ftell(f);
  fseek(f,0,SEEK_END);
  hlp=ftell(f);
  printf("PE size  : %u\n",low);
  printf("File size: %u\n",hlp);
  fclose(f);
}

int main(int argc,char *argv[]){
  if(argc>1) get_padding(argv[1]);
  return 0;
}
