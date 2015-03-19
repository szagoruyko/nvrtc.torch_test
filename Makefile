
all:
	clang helper.c -I/usr/local/include/TH -I/Developer/NVIDIA/CUDA-7.0/include -L/Developer/NVIDIA/CUDA-7.0/lib -framework CUDA -dynamiclib -o libhelper.dylib -lTHC
