#include  <iostream>

#include  "../Lab4/src/utils.h"

void image_sum(uchar3* const d_inImg1, uchar3* const d_inImg2, uchar3* const d_outImg, size_t n);

#include  "../Lab4/src/load.cpp"

using namespace cv;
using namespace std;

string path = "../images/";

int main(int argc, char** argv)
{
  /*if( argc < 2 )
  {
    cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
    return -1;
  }*/
  // filenames
  //getDeviceProperties();

  string filename1 = path+"img1_jesus.jpg";//path + argv[1];
  string filename2 = path+"img2_jesus.png";//path + argv[2];

  //color images input
  uchar3 *d_inImg1;
  uchar3 *d_inImg2;

  //mat images to show
  Mat matInImg1;
  Mat matInImg2;
  Mat matOutImg;

  //ouput
  uchar3 *d_outImg;
  uchar3 *h_outImg;

  size_t sizeImg;

  cout << filename1 << '\n';

  read_image(matInImg1, &d_inImg1, sizeImg, filename1);
  read_image(matInImg2, &d_inImg2, sizeImg, filename2);

  cudaMalloc(&d_outImg, sizeof(uchar3) * sizeImg);
  cudaMemset(d_outImg, 0, sizeof(uchar3) * sizeImg);

  size_t cols = matInImg1.cols;
  size_t rows = matInImg1.rows;

  matOutImg.create(rows,cols, CV_8UC3);
  h_outImg = (uchar3 *)matOutImg.ptr<unsigned char>(0);

  image_sum(d_inImg1, d_inImg2, d_outImg, sizeImg);

  cudaMemcpy(h_outImg, d_outImg, sizeof(uchar3) * sizeImg, cudaMemcpyDeviceToHost);

  Mat matOutImgBGR(rows, cols, CV_8UC3, (void *)h_outImg);

  string fileout = path+"outputsum.jpg";

  imwrite(fileout.c_str(),matOutImgBGR);
  
  cudaFree(d_outImg);
  cudaFree(d_inImg2);
  cudaFree(d_inImg1);
  
  return 0;
}

