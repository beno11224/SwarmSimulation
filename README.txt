SwarmSimulation is a platform to model a microswarm in real time.
It is written in Matlab, but uses other languages where appropriate:
 - COMSOL generated fluid flow data
 - C/C++ interfacing to Novint Falcon Haptic device
 - Python for NN integration (pythonNNConstructor)

The entry point for the simulator is a .mlapp file. There are a few of these to each perform certain tasks, 
for example _particleSimulationParticipant_ is used for data collection, and _particleSimulationValidation_ 
is used to run parametric studies

The simulator is drawn on the mlapp axes in a callback _drawTimerCallback_.

The running of the simulator happens in discrete timesteps. To calculate the state of the simulator at 
the given timestep _timerCallback_ is run. This is called on a timer during normal use, which allows 
the simulator to run at real time speed.
_timerCallback_ uses a suite of functions stored in _particleFunctions_. This file stores all the maths 
to run the model, in order to keep _timerCallback_ a bit cleaner.

_NextLevel_ performs a reset on the global variables and then sets up for the next level to start. This is 
used when running lots of tests rather than manually altering the test parameters.

Files called _FlowData..._ are used to store the fluid flow mesh values. These values are the velocities 
of the fluid at that node in the mesh.
_Polygons_ similarly stores the level data, such as the blue level outline and the goal locations.

The haptic device is controlled using a number of mex files. These have their respective .cpp source files.
To convert from cpp to mex files use this syntax: mex "drdms64.lib" "dhdms64.lib" WriteHaptic.cpp
The files connected to haptic:
 - CloseHaptic
 - idleHapticCallback
 - InitHaptic
 - ReadHaptic
 - WriteHaptic
And the library files required are:
 - dhd
 - dhd64
 - dhdc
 - dhdms
 - dhdms64
 - drd
 - drd64
 - drdc
 - drdms
 - Haptik.config
 - Haptik.Falcon
