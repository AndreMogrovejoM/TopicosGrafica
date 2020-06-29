#include "utils.hpp"
#include <cmath>

#ifdef __CUDACC__

#define SIZE_TRANS 6

__constant__ float M[SIZE_TRANS];

__global__
void affin_transform_kernel(uchar3* in_img, uchar3* out_img, size_t width, size_t height)
{
  uint tid = blockIdx.x*blockDim.x + threadIdx.x;
  uint x = tid/width;
  uint y = tid%width;

  uint nx,ny;

  nx = M[0]*x + M[1]*y + M[2];
  ny = M[3]*x + M[4]*y + M[5];

  uint ntid = nx*width + ny;
  out_img[ntid] = in_img[tid];
}

void affin_transform(uchar3* d_in_img, uchar3* d_out_img, float* trans, size_t width, size_t height)
{
  cudaMemcpyToSymbol(M, trans, SIZE_TRANS*sizeof(float));

  dim3 gridDim(std::ceil(width*height/warpSize),1,1);
  dim3 blockDim(warpSize,1,1);
  affin_transform_kernel<<<gridDim,blockDim>>>(d_in_img,d_out_img,width,height);
}

#endif