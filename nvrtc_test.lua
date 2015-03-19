dofile 'ffi.lua'
require 'cutorch'

ffi.cdef[[
void foo(THCudaTensor* a, THCudaTensor*b, THCudaTensor* c, char* ptx)
]]
Ch = ffi.load './libhelper.dylib'

local kernel = [[
extern "C" __global__
void cmul(const float* a, const float* b, float* c, int n)
{
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  if (tid < n)
    c[tid] = a[tid] * b[tid];
}
]]

program = ffi.new'nvrtcProgram[1]'
err = C.nvrtcCreateProgram(program, kernel, 'cmul.cu', 0, nil, nil)
print(err)

err = C.nvrtcCompileProgram(program[0], 0, nil)
print(err)

log = ffi.new'char[1]'
err = C.nvrtcGetProgramLog(program[0], log)
print(err)
print(ffi.string(log))

ptx = ffi.new'char[1]'
err = C.nvrtcGetPTX(program[0], ptx)
print(err)
print(ffi.string(ptx))

a = torch.rand(8):cuda()
b = torch.rand(8):cuda()
c = torch.CudaTensor(8):zero()

Ch['foo'](a:cdata(),b:cdata(),c:cdata(),ptx)

assert((torch.cmul(a,b) - c):max() == 0)
