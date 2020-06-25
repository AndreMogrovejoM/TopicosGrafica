#include "cuda_runtime.h"
#include "cuda_runtime_api.h"
#include "device_launch_parameters.h"
#include <iostream>  
#include <fstream>   
#include <iomanip>   
#include <windows.h>
#include <io.h>                  
#include <stdio.h>
#include<conio.h>
#include <cstdlib>
#include "cstdlib"
#include <process.h>
#include <stdlib.h>
#include <malloc.h>
#include <ctime>

//for __syncthreads()
#ifndef __CUDACC__ 
#define __CUDACC__
#endif
#include <device_functions.h>

using namespace std;

using namespace std;

#define BLOCK_WIDTH 16 
#define BLOCK_HEIGHT 16

/*******************/
/* Div_entre_cero FUNCTION */
/*******************/
int Div_entre_cero(int a, int b) { return ((a % b) != 0) ? (a / b + 1) : (a / b); }

/********************/
/* CUDA ERROR CHECK */
/********************/
#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, char* file, int line, bool abort = true)
{
    if (code != cudaSuccess)
    {
        fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
        if (abort) exit(code);
    }
}


__global__ void Conv_2d_kernel_avg_pool(unsigned short* Img_entrada, unsigned short* Img_salida, int Img_w, int Img_h) {

    __shared__ unsigned short surround[BLOCK_WIDTH * BLOCK_HEIGHT][9];

    int iterador;
    //Ids de threads y blocks
    const int x = blockDim.x * blockIdx.x + threadIdx.x;
    const int y = blockDim.y * blockIdx.y + threadIdx.y;
    const int tid = threadIdx.y * blockDim.x + threadIdx.x;

    //Comprobando que el kernel este dentro de la imagen
    if ((x >= (Img_w - 1)) || (y >= Img_h - 1) || (x == 0) || (y == 0)) return;

    // --- LLenando memoria compartida
    iterador = 0;
    for (int r = x - 1; r <= x + 1; r++) {
        for (int c = y - 1; c <= y + 1; c++) {
            surround[tid][iterador] = Img_entrada[c * Img_w + r];
            iterador++;
        }
    }

    // Ordenamos la memoria compartida con bubblesort para calcular la media
    for (int i = 0; i < 5; ++i) {

        // Obtenemos el menor valor
        int minval = i;
        for (int l = i + 1; l < 9; ++l)
            if (surround[tid][l] < surround[tid][minval]) minval = l;

        // Ponemos el menor valor en su lugar
        unsigned short temp = surround[tid][i];
        surround[tid][i] = surround[tid][minval];
        surround[tid][minval] = temp;
    }

    // Elegimos el valor medio
    Img_salida[(y * Img_w) + x] = surround[tid][4];

    __syncthreads();

}


int main()
{
    //Dimension de la imagen
    const int Img_w = 1580;
    const int Img_h = 1348;

    // Abriendo imagen en formato raw
    ifstream is; is.open("ps5.raw", ios::binary);

    // Longitud del archivo
    is.seekg(0, ios::end);
    int img_long = is.tellg();
    is.seekg(0, ios::beg);

    // Lectura de la imagen y almacenaje en host
    unsigned short* Img_entrada_host = new unsigned short[img_long * sizeof(char) / sizeof(unsigned short)];
    is.read((char*)Img_entrada_host, img_long);
    is.close();

    // Comprobacion de error al separar memoria
    unsigned short* forFirstCudaMalloc; gpuErrchk(cudaMalloc((void**)&forFirstCudaMalloc, img_long * sizeof(unsigned short)));
    gpuErrchk(cudaFree(forFirstCudaMalloc));

    //Separamos memoria en host y device
    unsigned short* Img_salida_host = (unsigned short*)malloc(img_long);
    unsigned short* Img_entrada; gpuErrchk(cudaMalloc((void**)&Img_entrada, img_long * sizeof(unsigned short)));
    unsigned short* Img_salida; gpuErrchk(cudaMalloc((void**)&Img_salida, img_long * sizeof(unsigned short)));

    // Copiando la data del host al device
    gpuErrchk(cudaMemcpy(Img_entrada, Img_entrada_host, img_long, cudaMemcpyHostToDevice));// copying Host Data To Device Memory For Filtering

    // Calculo de tamaño grids y blocks
    const dim3 grid(Div_entre_cero(Img_w, BLOCK_WIDTH), Div_entre_cero(Img_h, BLOCK_HEIGHT), 1);
    const dim3 block(BLOCK_WIDTH, BLOCK_HEIGHT, 1);

    //Variables para la medicion de tiempo
    float time;
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0);

    //Ejecucion del kernel
    cudaFuncSetCacheConfig(Conv_2d_kernel_avg_pool, cudaFuncCachePreferShared);
    Conv_2d_kernel_avg_pool << <grid, block >> > (Img_entrada, Img_salida, Img_w, Img_h);
    gpuErrchk(cudaPeekAtLastError());
    gpuErrchk(cudaDeviceSynchronize());

    //Imprimir tiempos de ejecución en ms
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&time, start, stop);
    printf("Ejecución completa - time:  %3.3f ms \n", time);

    //Moviendo resultados del device al host
    gpuErrchk(cudaMemcpy(Img_salida_host, Img_salida, img_long, cudaMemcpyDeviceToHost));

    // Escribiendo resultados en archivo de salida .raw
    ofstream of2;     of2.open("ps5_filtrada.raw", ios::binary);
    of2.write((char*)Img_salida_host, img_long);
    of2.close();

    cout << "\n Press any Key!!";
    //Liberando memoria del device
    gpuErrchk(cudaFree(Img_entrada));
    //Liberando memoria del host
    delete Img_entrada_host;
    delete Img_salida_host;

    return 0;
}
