#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#define _USE_MATH_DEFINES
#include <math.h>

#include "dhdc.h"
#include "drdc.h"

#define REFRESH_INTERVAL  0.1   // sec

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    //double a,b;
    //double *sum;

   /* if(nrhs != 2)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "Two inputs required.");
    }
    
    if(!mxIsDouble(prhs[0]) || mxGetNumberOfElements(prhs[0]) != 1)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "First argument must be number.");
    }
    
    if(!mxIsDouble(prhs[1]) || mxGetNumberOfElements(prhs[1]) != 1)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "Second argument must be number.");
    }*/

    //a = mxGetScalar(prhs[0]);
    //b = mxGetScalar(prhs[1]);
    //plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    //sum = mxGetPr(plhs[0]);
    //*sum = a + b;
    
    double *mx0;
    double *my0;
    double *mz0;

    // open the first available device
 if (drdOpen () < 0) {
    printf ("error: cannot open device (%s)\n", dhdErrorGetLastStr ());
    dhdSleep (2.0);
    //return -1;
  }
/*
  // print out device identifier
  if (!drdIsSupported ()) {
    printf ("unsupported device\n");
    printf ("exiting...\n");
    dhdSleep (2.0);
    drdClose ();
    return -1;
  }
  printf ("%s haptic device detected\n\n", dhdGetSystemName ());

  // perform auto-initialization
  if (!drdIsInitialized () && drdAutoInit () < 0) {
    printf ("error: auto-initialization failed (%s)\n", dhdErrorGetLastStr ());
    dhdSleep (2.0);
    return -1;
  }
  else if (drdStart () < 0) {
    printf ("error: regulation thread failed to start (%s)\n", dhdErrorGetLastStr ());
    dhdSleep (2.0);
    return -1;
  }


      dhdGetPosition (&mx0, &my0, &mz0, 0);*/

}