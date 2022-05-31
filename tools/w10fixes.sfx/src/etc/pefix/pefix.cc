#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <windows.h>
#include <imagehlp.h>
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
  f=fopen(argv[1],"r+b");
	fflush(f);
  fseek(f,0,SEEK_END);
  size=ftell(f);
  printf("File size         : %u\n",size);
  fseek(f,0,SEEK_SET);
  if(size<2048){
    fclose(f);
    return 0;
  };
  uint8_t *buf=(uint8_t *)calloc(size,1);
  if(!buf){
    fclose(f);
    return 0;
  };
  fread(buf,1,size,f);
  PIMAGE_DOS_HEADER dosHeader;
  dosHeader=(PIMAGE_DOS_HEADER)buf;
  if(dosHeader->e_magic!=IMAGE_DOS_SIGNATURE){
		printf("MZ signature error!\n");
    free(buf);
    fclose(f);
	};
	fseek(f,0,SEEK_SET);
	PIMAGE_NT_HEADERS ntHeaders=(PIMAGE_NT_HEADERS)(buf+dosHeader->e_lfanew);
	struct tm ts;
	char tbuf[80];
	time_t rt;
	rt=(uint32_t)ntHeaders->FileHeader.TimeDateStamp;
	ts=*localtime(&rt);
	strftime(tbuf,sizeof(tbuf),"%Y-%m-%d %H:%M:%S",&ts);
	printf("Timedate stamp    : %u (%s)\n",(uint32_t)ntHeaders->FileHeader.TimeDateStamp,tbuf);
	std::mt19937 mt(timebits());
	uint32_t tmp=1500000000+mt()%150000000;
	ntHeaders->FileHeader.TimeDateStamp=tmp;
	rt=(uint32_t)ntHeaders->FileHeader.TimeDateStamp;
	ts=*localtime(&rt);
	strftime(tbuf,sizeof(tbuf),"%Y-%m-%d %H:%M:%S",&ts);
	printf("New timedate stamp: %u (%s)\n",(uint32_t)ntHeaders->FileHeader.TimeDateStamp,tbuf);
	ntHeaders->OptionalHeader.MajorLinkerVersion=14;
	ntHeaders->OptionalHeader.MinorLinkerVersion=28;
  uint32_t h,c;
  MapFileAndCheckSumA(argv[1],(PDWORD)&h,(PDWORD)&c);
  printf("Old PE Image CRC  : %u\n",c);
	fwrite(buf,size,1,f);
	fflush(f);
  MapFileAndCheckSumA(argv[1],(PDWORD)&h,(PDWORD)&c);
  printf("New PE Image CRC  : %u\n",c);
  fseek(f,0,SEEK_SET);
  ntHeaders->OptionalHeader.CheckSum=c;
	fwrite(buf,size,1,f);
	fflush(f);
  free(buf);
  fclose(f);
  return 0;
}
