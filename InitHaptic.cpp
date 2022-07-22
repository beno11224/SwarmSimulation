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

    if (drdOpen () < 0) {
    printf ("error: cannot open device (%s)\n", dhdErrorGetLastStr ());
    dhdSleep (2.0);
    //return -1;
    }

    dhdSetBrakes(); //also apply zero force
}