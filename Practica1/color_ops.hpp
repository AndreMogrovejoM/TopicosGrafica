#ifndef COLOR_OP_HPP
#define COLOR_OP_HPP

#include  <opencv2/imgcodecs.hpp>
#include  <opencv2/core.hpp>

class IMAGE_EDITOR{
  public:
    IMAGE_EDITOR(char* filename,int flag = cv::IMREAD_COLOR);
    void weigthed_sum(char* filename, float alpha);           //0 < alpha < 1
    void transition(char* filename);
    void histogram_gray();
    void histogram_RG();
    void equializer();
  private:
    char* filename;
    cv::Mat img;
    int format_img;
};

#endif
