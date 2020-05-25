#include "head.h"


/*
Integrantes:
-Andre Mogrovejo Martinez
-Nicolas Jimenez Artica
-Jesus Lazo Quevedo
*/

int main() {
    //carga del archivo e inicializacion de estructura Bitmap
    BitMap ejemplo_bmp("gatote.bmp"); 

    //ejemplo get vector <r,g,b> para el pixel (1,1)
    vector<unsigned int> example_vector = ejemplo_bmp.getPixel(1,1); 

    ejemplo_bmp.makeCopy("gatote2.bmp");
    //ejemplo_bmp.dispPixelData();
    
    int altura = ejemplo_bmp.height();
    int ancho = ejemplo_bmp.width();
    vector<unsigned int> RGB;
    int griss = 0;
    for(int j= 0; j<(ancho-20);j++){
      for(int i=0;i<(altura-20);i++)
      {
        RGB = ejemplo_bmp.getPixel(i,j);
        griss =255-RGB[0] +255- RGB[1] + 255-RGB[2];
        ejemplo_bmp.writePixel(i,j,255-RGB[0],255- RGB[1],255-RGB[2]);
      }
    }
  return 0;
}