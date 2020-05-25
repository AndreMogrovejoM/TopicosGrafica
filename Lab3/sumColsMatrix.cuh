#include  <cuda.h>
#include  <stdio.h>

#include  "types.hpp"

#define WARP 32
#define DIMBLOCKX 32
#define DIMBLOCKY 32

__global__ void sumColsMatrixGPUKernel(num *Md, num *Nd, int M, int N){

  __shared__ num Nds[DIMBLOCKX][DIMBLOCKY];
  num Pvalue = 0;
  int col = blockIdx.x * (M / gridDim.x) + threadIdx.y;
  int pasos = N / blockDim.x;
  int posInit = col + (threadIdx.x * M * blockDim.x);
  for (int k = 0; k < pasos; ++k)
    Pvalue += Md[posInit + (k * M)];

  Nds[threadIdx.y][threadIdx.x] = Pvalue;
  __syncthreads();

  if (threadIdx.x == 0){
    int blockRow = threadIdx.y;
    for (int i = 1; i < blockDim.x; ++i)
      atomicAdd(&(Nds[blockRow][0]), Nds[blockRow][i]);
    Nd[col] = Nds[blockRow][0];
  }
}

void sumColsMatrixGPU(num *Mh, num *Nh, int M, int N){

  num *Md;
  num *Nd;

  size_t size_Md = M*N*sizeof(num);
  size_t size_Nd = M*sizeof(num);
  cudaMalloc(&Md, size_Md);
  cudaMalloc(&Nd, size_Nd);

  cudaMemcpy(Md, Mh, size_Md, cudaMemcpyHostToDevice);
  cudaMemset(Nd, 0, size_Nd);

  //kernel
  dim3 dimGrid(M/WARP,1,1);
  dim3 dimBlock(N/WARP,WARP,1);

  sumColsMatrixGPUKernel<<<dimGrid,dimBlock>>>(Md, Nd, M, N);

  cudaMemcpy(Nh, Nd, size_Nd, cudaMemcpyDeviceToHost);

  cudaFree(Md);
  cudaFree(Nd);
}
