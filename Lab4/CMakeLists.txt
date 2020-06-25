# collect source files

cmake_minimum_required(VERSION 3.8)

find_package(CUDA REQUIRED)
find_package(OpenCV REQUIRED)

set(CUDA_SEPARABLE_COMPILATION ON)
set(CUDA_PROPAGATE_HOST_FLAGS OFF)
set(CUDA_HOST_COMPILER clang++)

file( GLOB  hdr src/*.hpp src/*.h )
file( GLOB  cu  "src/" *.cu)

list( APPEND CUDA_NVCC_FLAGS "-gencode arch=compute_30,code=sm_30; -std=c++11")
CUDA_COMPILE(CU_O ${cu})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

SET (global_op_files main.cpp)

CUDA_INCLUDE_DIRECTORIES(src/)
CUDA_ADD_EXECUTABLE(global_op ${global_op_files} ${hdr} ${CU_O})
target_link_libraries(global_op ${CUDA_LIBRARIES} ${OpenCV_LIBS})
