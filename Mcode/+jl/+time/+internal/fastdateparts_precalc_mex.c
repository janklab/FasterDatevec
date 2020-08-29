#include "mex.h"
#include "matrix.h"
#include <stdio.h>
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

  mexErrMsgIdAndTxt("jl:test", "Test error message!");

}
