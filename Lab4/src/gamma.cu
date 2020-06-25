#include <cmath>
#include "utils.h"

__global__
void gamma_kernel(const uchar3* const inImg, uchar3* const outImg, const size_t n, const int gamma)
{
  size_t id = blockIdx.x*blockDim.x + threadIdx.x; 
  if (id < n){
    uchar3 px_img = inImg[id];

    outImg[id].x = 255 * pow(px_img.x / 255, gamma);
    outImg[id].y = 255 * pow(px_img.y / 255, gamma);
    outImg[id].z = 255 * pow(px_img.z / 255, gamma);
  }
}

void gamma_func(uchar3* const d_inImg, uchar3* const d_outImg, size_t &n, int gamma)
{
  const dim3 gridSize(n/warpSize,1,1);
  const dim3 blockSize(warpSize,1,1);
  gamma_kernel<<<gridSize,blockSize>>>(d_inImg, d_outImg, n, 1/gamma);
}