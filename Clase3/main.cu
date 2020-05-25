//#include "shared.cuh"
#include <stdio.h>

#define ROW 1024
#define COL 512


int main(int argc, char** argv){
  int row,col;

  if (argc == 3){ //case input order: row col
    row = atoi(argv[1]);
    col = atoi(argv[2]);
  }
  else if (argc == 2){ //case number cols = number rows
    row = col = atoi(argv[1]);
  }
  else if (argc > 3){ //error case
    printf("Error typing dimension of a matrix (rows,columns), entered more than two values\n");
    return -1;
  }
  else{ //run example with predefined size 1024x512
    row = ROW;
    col = COL;
  }

  int nDevices;

  cudaGetDeviceCount(&nDevices);
  for (int i = 0; i < nDevices; i++) {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, i);
    printf("Device Number: %d\n", i);
    printf("  Device name: %s\n", prop.name);
    printf("  Shared Memory per block: %d\n",
           prop.sharedMemPerBlock);
    printf("  Registers per block: %d\n",
           prop.regsPerBlock);
    printf("  Warp size: %d\n",
           prop.warpSize);
    printf("  Peak Memory Bandwidth (GB/s): %f\n\n",
           2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
  }
  return 0;
}
