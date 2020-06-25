#include "utils.h"

#include <stdio.h>

void getDeviceProperties()
{
  cudaDeviceProp prop;
  cudaGetDeviceProperties(&prop, 0); //assuming there is one device
  printf("ThreadsXblock: &d",prop.maxThreadsPerBlock);
  printf("ThreadsXsm: &d",prop.maxThreadsPerMultiProcessor);
  //printf("BlocksXsm: &d",prop.maxBlocksPerMultiProcessor);
  printf("GridDim: &d",prop.maxGridSize);
}