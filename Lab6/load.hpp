#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>

#include "utils.hpp"

#include <iostream>

using namespace cv;

int read_image(Mat &img, uchar3 **d_inputImg, size_t &sizeImg, const std::string filename){

  img = imread(filename, IMREAD_COLOR);

  if(img.empty()){
    std::cout << "Could not read the image: " << filename << '\n';
    return -1;
  }

  if (!img.isContinuous()) {
    std::cerr << "Image isn't continuous!! Exiting." << '\n';
    return -1;
  }

  uchar3* h_inputImg = (uchar3 *)img.ptr<unsigned char>(0);

  sizeImg = img.cols * img.rows;

  cudaMalloc(d_inputImg, sizeof(uchar3) * sizeImg);

  cudaMemcpy(*d_inputImg, h_inputImg, sizeof(uchar3) * sizeImg, cudaMemcpyHostToDevice);

  //delete h_inputImg;

  return 1;
}