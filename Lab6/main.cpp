//#include "kernel.cu"
#include "load.hpp"

#include <string>

void affin_transform(uchar3* d_in_img, uchar3* d_out_img, float* trans, size_t width, size_t height);

using namespace std;

int main()
{
    /*if( argc < 2 )
  {
    cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
    return -1;
  }*/
  // filenames
  //getDeviceProperties();

  //color images input
  uchar3 *d_inImg;

  //mat images to show
  Mat matInImg;
  Mat matOutImg;

  //ouput
  uchar3 *d_outImg;
  uchar3 *h_outImg;

  int cx=50,cy=50;
  float trans[6] = {1.0,.5,.0,-0.0,1.0,0.0};

  size_t sizeImg;

  read_image(matInImg, &d_inImg, sizeImg, "scream.jpg");

  cudaMalloc(&d_outImg, sizeof(uchar3) * sizeImg);
  cudaMemset(d_outImg, 0, sizeof(uchar3) * sizeImg);

  size_t cols = matInImg.cols;
  size_t rows = matInImg.rows;

  matOutImg.create(rows,cols, CV_8UC3);
  h_outImg = (uchar3 *)matOutImg.ptr<unsigned char>(0);

  affin_transform(d_inImg, d_outImg, trans, cols, rows);

  cudaMemcpy(h_outImg, d_outImg, sizeof(uchar3) * sizeImg, cudaMemcpyDeviceToHost);

  Mat matOutImgBGR(rows, cols, CV_8UC3, (void *)h_outImg);

  string fileout = "output.jpg";

  imwrite(fileout.c_str(),matOutImgBGR);
  
  cudaFree(d_outImg);
  cudaFree(d_inImg);
  
  return 0;
}