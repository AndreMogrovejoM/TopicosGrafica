#include "sumColsMatrix.cuh"
#include "sumColsMatrix.hpp"
#include <stdio.h>

#define ROW 1024
#define COL 512


int main(int argc, char** argv){

  int N, M;

  /*if (argc == 3){ //case input order: row col
    N = atoi(argv[1]);
    M = atoi(argv[2]);
  }
  else if (argc == 2){ //case number cols = number rows
    N = N = atoi(argv[1]);
  }
  else if (argc > 3){ //error case
    printf("Error typing dimension of a matrix (rows,columns), entered more than two values\n");
    return -1;
  }
  else{ //run example with predefined size 1024x512
    N = ROW;
    M = COL;
  }*/

  N = ROW;
  M = COL;


  /*int nDevices;

  cudaGetDeviceCount(&nDevices);
  for (int i = 0; i < nDevices; i++) {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, i);
    printf("Device Number: %d\n", i);
    printf("  Device name: %s\n", prop.name);
    printf("  Shared Memory per block: %d\n",
           prop.sharedMemPerBlock);
    printf("  Dimension of a grid: (%d,%d,%d)\n",
           prop.maxGridSize[0], prop.maxGridSize[1], prop.maxGridSize[2]);
    printf("  Warp size: %d\n",
           prop.warpSize);
    printf("  Peak Memory Bandwidth (GB/s): %f\n\n",
           2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
  }*/

  int *Mh;
  int *Nh;

  Mh = new int[N*M];

  for (int i = 0; i < N; ++i)
    for (int j = 0; j < M; ++j)
      Mh[i*M + j] = i;

  Nh = new int[M];

  sumColsMatrixGPU(Mh,Nh,M,N);

  for (int i = 0; i < M; ++i)
    printf("%d ",Nh[i]);
  printf("\n");

  delete Mh;
  delete Nh;

  return 0;
}
