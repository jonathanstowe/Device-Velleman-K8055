 
#include <string.h>
#include <stdio.h>
#include <usb.h>
#include <assert.h>
#include <sys/time.h>
#include "k8055.h"

#define STR_BUFF 256
#define false 0
#define true 1

extern int DEBUG;

int ia1 = -1;
int ia2 = -1;
int id8 = -1;
int ipid = 0;

int numread = 1;

int debug = 0;

int dbt1 = -1; // (-1 => not to set)
int dbt2 = -1; // (-1 => not to set)

int resetcnt1 = false;
int resetcnt2 = false;

int delay = 0;

int main (int argc,char *params[]) 
{
	int i,result;
	long d=0;
	long a1=0,a2=0;
	long c1=0, c2=0;
	unsigned long int start,mstart=0,lastcall=0;

	if ( OpenDevice(ipid)<0 ) 
	{
			printf("Could not open the k8055 (port:%d)\nPlease ensure that the device is correctly connected.\n",ipid);
			return (-1);
			
	} 
        else 
        {
            int j;
		for ( j = 0; j <1256; j++ )
		{
		int i;
                int k = 0;
		for ( i = 0; i <8; i++ )
                {
			k = k + ( 1<< i);
			usleep(100000);
			result=WriteAllDigital((long)k);
		}
		for ( i = 8; i >= 0; i-- )
                {
			k = k - ( 1<< i);
			usleep(100000);
			result=WriteAllDigital((long)k);
		}
                k = 255;
		for ( i = -1; i <8; i++ )
                {
			k = k - ( 1<< i);
			usleep(100000);
			result=WriteAllDigital((long)k);
		}
		for ( i = 8; i >= 0; i-- )
                {
			k = k + ( 1<< i);
			usleep(100000);
			result=WriteAllDigital((long)k);
		}
		}	
		CloseDevice();
	}
	return 0;
}
