 magneticGraphData = [
0.008,5.216,nan;
0.009,4.705,nan;
0.01,4.205,nan;
0.011,3.654,nan;
0.012,3.457,nan;
0.015,2.805,nan;
0.018,2.161,nan;
0.02,2.111,nan;
0.025,1.705,nan;
0.033,1.266,nan;
0.045,0.955,2.000;
0.05,0.860,1.500;
0.075,0.556,0.800;
0.1,0.457,0.650;
0.15,0.370,0.500;
0.2,0.264,0.350;
0.225,0.259,0.250
];

plot(magneticGraphData(8:end,1),magneticGraphData(8:end,2:3))
title('Comparison of experimental and simulated magnetic force')
xlabel('Magnetic Force (MA/m^2)')
ylabel('Time to reach the edge of the chamber (s)')