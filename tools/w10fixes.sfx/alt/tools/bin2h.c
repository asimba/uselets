#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>

void gen_h(char *qb){
  FILE *ifile=fopen(qb,"rb");
  FILE *ofile=fopen("data.h","wb");
  fprintf(ofile,"#ifndef _DATA_TBL\n#define _DATA_TBL 1\n");
  fprintf(ofile,"static const uint8_t data[]={\n");
  uint8_t s,c;
  uint32_t l=0;
  while(1){
    s=fgetc(ifile);
    if(feof(ifile)) break;
    if(c==20){
      c=0;
      fprintf(ofile,"\n");
    };
    fprintf(ofile,"0x%02X,",s);
    c++;
    l++;
  }
  fprintf(ofile,"0\n};\n");
  fprintf(ofile,"static const uint32_t data_size=%u;\n#endif\n",l);
  fclose(ifile);
  fclose(ofile);
}

int main(int argc,char *argv[]){
  if(argc>1) gen_h(argv[1]);
  return 0;
}
