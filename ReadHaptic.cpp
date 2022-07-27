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
    double mx0, my0, mz0;
    dhdGetPosition (&mx0, &my0, &mz0, 0);
    double * data;
    int numVals = 2;
    plhs[0] = mxCreateDoubleMatrix(1,numVals,mxREAL);
    data = (double *) malloc(numVals * sizeof(data));
    //for (int idx = 0; idx < numVals; ++idx) {
    //    (data)[idx] = idx * 0.1 + ((double) rand() / (RAND_MAX));
    //}
    //(data)[0] = mx0;
    (data)[0] = my0;
    (data)[1] = mz0;
    memcpy(mxGetPr(plhs[0]), data, numVals * sizeof(double));
    free(data);
    //TODO get mx0, my0, mz0 into the array above, to return those. Then this should work.
}