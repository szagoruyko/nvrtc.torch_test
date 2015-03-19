#include <cuda.h>
#include <stdio.h>
#include <THC/THC.h>

void foo(THCudaTensor* a, THCudaTensor*b, THCudaTensor* c, char* ptx)
{
  const float* a_p = THCudaTensor_data(NULL, a);
  const float* b_p = THCudaTensor_data(NULL, b);
  float* c_p = THCudaTensor_data(NULL, c);
  int n = THCudaTensor_nElement(NULL, a);

  CUdevice cuDevice;
  CUcontext context;
  CUmodule module;
  CUfunction kernel;
  CUresult err;

  CUdeviceptr a_dp = (CUdeviceptr)a_p;
  CUdeviceptr b_dp = (CUdeviceptr)b_p;
  CUdeviceptr c_dp = (CUdeviceptr)c_p;

  void *args[] = {&a_dp, &b_dp, &c_dp, &n};

  err = cuDeviceGet(&cuDevice, 0);
  if (err != CUDA_SUCCESS) printf("error code: %d\n", err);
  err = cuCtxGetCurrent(&context);
  if (err != CUDA_SUCCESS) printf("error code: %d\n", err);
  err = cuModuleLoadDataEx(&module, ptx, 0, 0, 0);
  if (err != CUDA_SUCCESS) printf("error code: %d\n", err);
  err = cuModuleGetFunction(&kernel, module, "cmul");
  if (err != CUDA_SUCCESS) printf("error code: %d\n", err);

  err = cuLaunchKernel(kernel,
      		       8, 1, 1,
		       1, 1, 1,
		       0, NULL,
		       args, 0);
  if (err != CUDA_SUCCESS) printf("error code: %d\n", err);

  cuCtxSynchronize();
  cuModuleUnload(module);
  cuCtxDestroy(context);
}
