#include "utils.h"

__global__
void image_sum_kernel(const uchar3* const inImg1, const uchar3* const inImg2, uchar3* const outImg, size_t n)
{
  size_t id = blockIdx.x*blockDim.x + threadIdx.x; 
  if (id < n){
    uchar3 px_img1 = inImg1[id];
    uchar3 px_img2 = inImg2[id];

    outImg[id].x = px_img1.x + px_img2.x;
    outImg[id].y = px_img1.y + px_img2.y;
    outImg[id].z = px_img1.z + px_img2.z;
  }
}

void image_sum(uchar3* const d_inImg1, uchar3* const d_inImg2, uchar3* const d_outImg, size_t n)
{
  const dim3 gridSize(n/warpSize,1,1);
  const dim3 blockSize(warpSize,1,1);
  sum_kernel<<<gridSize,blockSize>>>(d_inImg1, d_inImg2, d_outImg, n);
}
