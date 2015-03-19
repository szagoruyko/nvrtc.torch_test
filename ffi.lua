ffi = require 'ffi'

ffi.cdef[[
typedef enum {
  NVRTC_SUCCESS = 0,
  NVRTC_ERROR_OUT_OF_MEMORY = 1,
  NVRTC_ERROR_PROGRAM_CREATION_FAILURE = 2,
  NVRTC_ERROR_INVALID_INPUT = 3,
  NVRTC_ERROR_INVALID_PROGRAM = 4,
  NVRTC_ERROR_INVALID_OPTION = 5,
  NVRTC_ERROR_COMPILATION = 6,
  NVRTC_ERROR_BUILTIN_OPERATION_FAILURE = 7
} nvrtcResult;
const char *nvrtcGetErrorString(nvrtcResult result);
nvrtcResult nvrtcVersion(int *major, int *minor);
typedef struct _nvrtcProgram *nvrtcProgram;
nvrtcResult nvrtcCreateProgram(nvrtcProgram *prog,
                               const char *src,
                               const char *name,
                               int numHeaders,
                               const char **headers,
                               const char **includeNames);
nvrtcResult nvrtcDestroyProgram(nvrtcProgram *prog);
nvrtcResult nvrtcCompileProgram(nvrtcProgram prog,
                                int numOptions, const char **options);
nvrtcResult nvrtcGetPTXSize(nvrtcProgram prog, size_t *ptxSizeRet);
nvrtcResult nvrtcGetPTX(nvrtcProgram prog, char *ptx);
nvrtcResult nvrtcGetProgramLogSize(nvrtcProgram prog, size_t *logSizeRet);
nvrtcResult nvrtcGetProgramLog(nvrtcProgram prog, char *log);
]]

C = ffi.load'/Developer/NVIDIA/CUDA-7.0/lib/libnvrtc.dylib'
