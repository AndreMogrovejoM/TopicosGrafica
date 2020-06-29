####################################################
# Laboratorio 6 - Topicos en computacion grafica
#
# Utilizar el codigo fuente bajo su
# responsabilidad.
#
# Autores:
# Jesus Lazo Quevedo
# Andre Mogrovejo Martinez
# Nicolas Jimenez Artica
#
####################################################
#
# make				# compila el proyecto
# make clean	# remueve todos los binarios generados
#
####################################################

# archivos 
CPPFILES		:= main.o
CUFILES			:= kernel.o
CUHFILES		:= kernel.hpp
OPENCVFLAGS	:= `pkg-config --cflags --libs opencv4` -lcblas

# ejecutable
EXEC 				:= lab6

%.o: %.cu $(CUHFILES)
	nvcc -c -o $@ $<

lab6: main.o kernel.o
	nvcc -w -o $(EXEC) main.o kernel.o -I $(OPENCVFLAGS)

clear:
	rm -f *.o $(lab6)