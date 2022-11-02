#include "mex.h"
#include <stdlib.h>
#include <string.h>
#define _USE_MATH_DEFINES
#include <math.h>

#include "dhdc.h"
#include "drdc.h"

#define REFRESH_INTERVAL  0.1   // sec

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
   // if(nrhs != 1)
   // {
   //     mexErrMsgIdAndTxt("bitmarker:my_sum", "Array of three inputs required.");
   // }

   // dhdOpen();
    double fx, fy, fz;
    fx = *mxGetPr(prhs[0]);
    fy = *mxGetPr(prhs[1]);
    fz = *mxGetPr(prhs[2]);
    dhdSetForce(fx,fy,fz);
    //dhdSetBrakes(); //also apply zero force
   // dhdClose();
}