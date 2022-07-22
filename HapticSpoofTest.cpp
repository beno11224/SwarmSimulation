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

    //double a,b;
    //double *sum;
    
 /*   if(!mxIsDouble(prhs[0]) || mxGetNumberOfElements(prhs[0]) != 1)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "First argument must be number.");
    }
    
    if(!mxIsDouble(prhs[1]) || mxGetNumberOfElements(prhs[1]) != 1)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "Second argument must be number.");
    }
*/
    //a = mxGetScalar(prhs[0]);
    //b = mxGetScalar(prhs[1]);
    //plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    //sum = mxGetPr(plhs[0]);
    //*sum = a + b;

    // open the first available device
 if (drdOpen () < 0) {
    printf ("error: cannot open device (%s)\n", dhdErrorGetLastStr ());
    dhdSleep (2.0);
    //return -1;
  }

  // print out device identifier
/*  if (!drdIsSupported ()) {
    printf ("unsupported device\n");
    printf ("exiting...\n");
    dhdSleep (2.0);
    drdClose ();
    //return -1;
  }
  printf ("%s haptic device detected\n\n", dhdGetSystemName ());

  // perform auto-initialization
  if (!drdIsInitialized () && drdAutoInit () < 0) {
    printf ("error: auto-initialization failed (%s)\n", dhdErrorGetLastStr ());
    dhdSleep (2.0);
    //return -1;
  }
  else if (drdStart () < 0) {
    printf ("error: regulation thread failed to start (%s)\n", dhdErrorGetLastStr ());
    dhdSleep (2.0);
    //return -1;
  }*/

    dhdSetBrakes(); //also apply zero force
        // apply zero force
   // if (dhdSetForceAndTorqueAndGripperForce (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) < DHD_NO_ERROR) {
   //   printf ("error: cannot set force (%s)\n", dhdErrorGetLastStr());
   // }

    double mx0, my0, mz0;
    dhdGetPosition (&mx0, &my0, &mz0, 0); 
    dhdClose();
    
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