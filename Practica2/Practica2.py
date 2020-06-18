import cv2
import numpy as np
from matplotlib import pyplot as plt

#img = cv2.imread('gatorojo.jpg')
#img2 = cv2.imread('gatosonriendo.jpg')

def Transicion(filename1,filename2,n=100,step=20):
  
  img = cv2.imread(filename1)
  img2 = cv2.imread(filename2)
  for i in range(0,n+1,step):
    img_1 = cv2.blur(img,(i*4+1,1))
    img_2 = cv2.blur(img2,((n-i)*4+1,1))
    cv2.addWeighted(img_1,1-i/n,img_2,i/n,0,img)
    cv2.imwrite("salida_gato"+str(i)+'.jpg',img)
    print(i)
  

#Transicion("img1_jesus.jpg","img2_jesus.png")

def sovel(filename):
  scale = 1
  delta = 0
  ddepth = cv2.CV_16S

  src = cv2.imread(filename, cv2.IMREAD_COLOR)
  src = cv2.GaussianBlur(src, (3, 3), 0)
  
  gray = cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)

  grad_x = cv2.Sobel(src, ddepth, 1, 0, ksize=3, scale=scale, delta=delta, borderType=cv2.BORDER_DEFAULT)

  grad_y = cv2.Sobel(src, ddepth, 0, 1, ksize=3, scale=scale, delta=delta, borderType=cv2.BORDER_DEFAULT)
    
    
  abs_grad_x = cv2.convertScaleAbs(grad_x)
  abs_grad_y = cv2.convertScaleAbs(grad_y)
    
    
  grad = cv2.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0)

  cv2.imwrite("salida"+'.jpg',grad)

#sovel("img1_jesus.jpg")


def Laplace(filename):
  ddepth = cv2.CV_16S
  kernel_size = 3
  src = cv2.imread(filename, cv2.IMREAD_COLOR)
  src = cv2.GaussianBlur(src, (3, 3), 0)
  src_gray = cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)
  dst = cv2.Laplacian(src, ddepth, ksize=kernel_size)
  abs_dst = cv2.convertScaleAbs(dst)
  cv2.imwrite("salida"+'.jpg',abs_dst)

#Laplace("img1_jesus.jpg")

def filtro_ajuste(filename):
  img = cv2.imread(filename, cv2.IMREAD_COLOR)

  tam= 2*5+1; # tamaño de vecindad local
  #MinLocal(img, mini, tam, tam)
  #MaxLocal(img, maxi, tam, tam)
  kernel = np.ones((tam,tam),np.uint8)
  mini = cv2.erode(img,kernel,iterations = 25)
  maxi = cv2.dilate(img,kernel,iterations = 25)
  res= img-mini
  maxi= maxi-mini
  cv2.divide(res, maxi, res, 255.0);
  cv2.imwrite("salida"+'.jpg',res)

filtro_ajuste("entrada2.jpg")

def Canny(filename):
  
  img = cv2.imread(filename,cv2.IMREAD_COLOR)

  edges = cv2.Canny(img,100,60)
  cv2.imwrite("salida"+'.jpg',edges)
  

#Canny("img1_jesus.jpg")
