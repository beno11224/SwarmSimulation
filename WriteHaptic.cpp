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
    if(nrhs != 0)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "No inputs required.");
    }

    dhdSetBrakes(DHD_ON); //also apply zero force
    double mx0, my0, mz0 = 0.1;
    while( mx0 > 0){
        dhdGetPosition (&mx0, &my0, &mz0, 0);
        dhdSetForce(-1,-1,-1);
    };
   // dhdSetBrakes(); //also apply zero force
}