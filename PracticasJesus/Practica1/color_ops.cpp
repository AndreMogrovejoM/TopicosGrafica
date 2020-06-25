#include  "color_ops.hpp"

#include  <opencv2/core.hpp>
#include  <opencv2/imgcodecs.hpp>

#include  <iostream>

using namespace cv;

IMAGE_EDITOR::IMAGE_EDITOR(char* filename_, int format = IMREAD_COLOR){
  format_img = format;
  filename = filename_;
  img = imread(filename,format_img)
}


