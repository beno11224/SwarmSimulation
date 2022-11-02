#include "mex.h"
#include <stdlib.h>
#include <string.h>
#define _USE_MATH_DEFINES
#include <math.h>

#include "dhdc.h"
#include "drdc.h"

#define REFRESH_INTERVAL  0.1   // sec

constexpr double K = 100000.0;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if(nrhs != 0)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "No inputs required.");
    }

 //   dhdOpen();

    //dhdSetBrakes(DHD_ON); //also apply zero force
    double mx0, my0, mz0;
    dhdGetPosition (&mx0, &my0, &mz0, 0);
    double fx, fy, fz;
    fx = -K * mx0 * mx0 * mx0 ;
    fy = -K * my0 * my0 * my0 ;
    fz = -K * mz0 * mz0 * mz0 ;
    dhdSetForce(fx,fy,fz);
    
    dhdSetBrakes(); //also apply zero force

 //   dhdClose();
}