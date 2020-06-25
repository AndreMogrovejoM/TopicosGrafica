
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <math.h> 
#include <stdio.h>


#define ThreadsPerBlock 512


__global__
void GammaKernel(const uchar4* const rgbaImage, uchar4* const outputImage, int numRows, int numCols, float gamma)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if (i < numRows * numCols) {
		uchar4 px = rgbaImage[i]; 
		unsigned char rcolor = round(pow((px.x / 255.0f), (1.0f / gamma)) * 255.0f);
		outputImage[i].x = (rcolor > 255.0f) ? 255.0f : rcolor;
		unsigned char gcolor = round(pow((px.y / 255.0f), (1.0f / gamma)) * 255.0f);
		outputImage[i].y = (gcolor > 255.0f) ? 255.0f : gcolor;
		unsigned char bcolor = round(pow((px.z / 255.0f), (1.0f / gamma)) * 255.0f);
		outputImage[i].z = (bcolor > 255.0f) ? 255.0f : bcolor;

		
	}

}

void CorreccionGamma(uchar4* const d_rgbaImage, uchar4* const d_outputImage, size_t numRows, size_t numCols, float gamma)
{
	long long int total_px = numRows * numCols;  
	long int grids_n = ceil(total_px / ThreadsPerBlock); 
	const dim3 blockSize(ThreadsPerBlock, 1, 1);
	const dim3 gridSize(grids_n, 1, 1);
	GammaKernel <<<gridSize, blockSize >>> (d_rgbaImage, d_outputImage, numRows, numCols, gamma);
	cudaDeviceSynchronize();
}