#include <assert.h>
#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

/*  
   Compilar con:
   $ nvcc example_intro.cu */

const int N = 16384;
const int THREADS_PER_BLOCK = 512;


/* Ejecucion de un thread por cada bloque*/
__global__ void add_blocks (int *a, int *b, int *c) {

  /* blockIdx.x indica el id de cada bloque */

  c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

/* Ejecucion de multiples threads en un bloque */
__global__ void add_threads (int *a, int *b, int *c) {

  /* threadIdx.x indica el id de cada thread */

  c[threadIdx.x] = a[threadIdx.x] + b[threadIdx.x];
}


 /* Ejecucion de multiples threads en multiples bloques */
__global__ void add_threads_blocks (int *a, int *b, int *c, int n) {

     /* blockDim.x indica el numero de threads por bloque, combinandolo con 
     threadIdx.x y blockIdx.x nos da el indice global de cada thread*/

  int index = blockIdx.x * blockDim.x + threadIdx.x;
  //Comprobando que el indice no sobrepase el tamaño de la matriz
  if (index < n) {
    c[index] = a[index] + b[index];
  }
}

int main(void) {
  int *a, *b, *c; /* Copias del Host (CPU) a, b, c */
  int *d_a, *d_b, *d_c; /* Copias del Device (GPU) a, b, c */
  size_t size = N * sizeof(int);

  srand(1);


  /* Separando memoria en el device */
  cudaMalloc((void **) &d_a, size);
  cudaMalloc((void **) &d_b, size);
  cudaMalloc((void **) &d_c, size);

  /* Separando memoria en el host*/
  a = (int *) malloc(size);
  b = (int *) malloc(size);
  c = (int *) malloc(size);

  /* llenando los vectores a y b de manera aleatoria*/
  for (int i = 0; i < N; ++i) {
    a[i] = 1;
    b[i] = 1;
  }

  /* transfiriendo data del host al device */
  cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

  /* Ejecucion del kernel en el device con N bloques */
  add_blocks<<<N,1>>>(d_a, d_b, d_c);
  /* transifiriendo resultados del device al host*/
  cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

  /* Comprobando que los resultados son correctos*/
  for (int i = 0; i < N; ++i) {
    assert(c[i] == a[i] + b[i]);
  }
  printf("Se ejecuto exitosamente %d blocks\n", N);

  /* Ejecutando kernel en el device con N threads */
  add_threads<<<1,N>>>(d_a, d_b, d_c);
  cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

  /* Comprobando que los resultados son correctos*/
  for (int i = 0; i < N; ++i) {
    assert(c[i] == a[i] + b[i]);
  }
  printf("Se ejecuto exitosamente %d threads\n", N);

  /* Ejecucion del kernel en el device con N threads en N bloques */
  add_threads_blocks<<<(N + (THREADS_PER_BLOCK - 1)) / THREADS_PER_BLOCK, THREADS_PER_BLOCK>>>(d_a, d_b, d_c, N);
  cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

   /* Comprobando que los resultados son correctos*/
  for (int i = 0; i < N; ++i) {
    assert(c[i] == a[i] + b[i]);
  }
  printf("Se ejecuto exitosamente %d threads/blocks\n", N);

  /* Liberando memoria */
  free(a); free(b); free(c);
  cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);

  return 0;
}
