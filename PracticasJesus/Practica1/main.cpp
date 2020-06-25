//#include "color_ops.hpp"

#include  <opencv2/core.hpp>
#include  <opencv2/imgcodecs.hpp>
#include  <opencv2/opencv.hpp>

#include  <iostream>

int C = 1;

using namespace cv;

Mat addWeighted(Mat &A, double a, Mat &B, double b, double c){
  return A*a + B*b + c;
}

void transition(Mat &A, Mat &B, double T){
  for(double i = 0; i < T; ++i){
    Mat C = addWeighted(A,i/T,B,1-i/T,0);
    std::string dest = "Transitions/fish_on_sea_"+std::to_string(int(i))+".jpg";
    imwrite(dest,C);
  }
}

void histogram_gray(Mat &A){
  Mat gray,hist;
  cvtColor(A,gray,COLOR_BGR2GRAY);
  int canales[1]= {0};
  int bins[1]= {256};
  float rango[2]= {0, 256};
  const float *rangos[]= {rango};
  calcHist(&gray, 1, canales, noArray(), hist, 1, bins, rangos);
  int histSize = 256;
  int hist_w = 512, hist_h = 400;
  int bin_w = cvRound( (double) hist_w/histSize);
  Mat histImage( hist_h, hist_w, CV_8UC3, Scalar( 255,255,255) );
  for( int i = 1; i < histSize; i++ ){
    line( histImage, Point( bin_w*(i-1), hist_h - cvRound(hist.at<float>(i-1)) ), Point( bin_w*(i), hist_h - cvRound(hist.at<float>(i)) ), Scalar( 0, 0, 0), 2, 8, 0  );
  }
  imshow("Histogram Gray", histImage);
  imwrite("histogram_gray.jpg",histImage);
  /*for (int i= 0; i<256; i++)
    qDebug("Celda %d: %g", i, hist.at<float>(i));*/
}

void equalize(Mat img){
  Mat gris, hist;
  cvtColor(img, gris, COLOR_BGR2GRAY);
  int canales[1]= {0}, bins[1]= {256};
  float rango[2]= {0, 256};
  const float *rangos[]= {rango};
  calcHist(&gris, 1, canales, noArray(), hist, 1, bins, rangos);
  hist*= 255.0/norm(hist, NORM_L1);
  Mat lut(1, 256, CV_8UC1);
  float acum= 0.0;
  for (int i= 0; i<256; i++) {
    lut.at<uchar>(0, i)= acum;
    acum+= hist.at<float>(i);
  }
  Mat res;
  LUT(img, lut, res);
  imshow("Ecualizada", res);
  waitKey(0);
  imwrite("equalize"+std::to_string(C++)+".jpg",res);
}

void histogram_RG(Mat &img){
  Mat hist;
  int canales[2]= {2, 1};
  int bins[2]= {64, 64};
  float rango[2]= {0, 256};
  const float *rangos[]= {rango, rango};
  calcHist(&img, 1, canales, noArray(), hist, 2, bins, rangos);
  Mat pinta(64, 64, CV_8UC1);
  double minval, maxval;
  minMaxLoc(hist, &minval, &maxval);
  for (int r= 0; r<64; r++)
    for (int g= 0; g<64; g++)
      pinta.at<uchar>(r, g)= 255-(255*hist.at<float>(r, g)/maxval);
  namedWindow("Histograma R-G", 0);
  imshow("Histograma R-G", pinta);
  waitKey(0);
  imwrite("histogram_RG.jpg",pinta);
}

int main(){
  Mat img;
  img = imread("cuchaa.jpg");
  Mat img1 = imread("andre1.jpg");
  Mat img2 = imread("andre2.jpg");
  Mat img3 = imread("nico1.jpg");
  Mat img4 = imread("nico2.jpg");

  //Mat img2 = imread("a.jpg");

  //Mat w = addWeighted(img, 0.3, img2, 0.7, 0.5);
  //imwrite("fish_on_sea.jpg",w);

  //transition(img,img2,20);

  histogram_RG(img2);
  equalize(img);
  equalize(img1);
  equalize(img2);
  equalize(img3);
  equalize(img4);

  //namedWindow("Display Image", WINDOW_AUTOSIZE );
  //imshow("Display Image", w);
  //waitKey(0);

  return 0;
}
