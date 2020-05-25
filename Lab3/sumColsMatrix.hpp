#include  <vector>
#include  "types.hpp"

void sumColsMatrixCPU(num *M, num *V, int m, int n){
  for(int i = 0; i < m; ++i)
    for(int j = 0; j < n; ++j)
      V[i] += M[i + (j * m)];
}
