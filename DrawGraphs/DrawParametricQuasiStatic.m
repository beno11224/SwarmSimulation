%%Draw data for experimentation occurring in Dec 23
close all
%--------------------Data:
%Comparison with real world
xMagneticGradient = [nan,200,300,400,500,600,700,800,900,1000;
    100,200,300,400,500,600,700,800,900,1000];
   % 100,200,300,400,500,600,700,800,900,1000];
ySIM = [46.512,11.628,5.168,2.908,1.862,1.292,0.95,0.728,0.576,0.466;
    8.454,3.542,2.032,1.338,0.954,0.716,0.56,0.45,0.37,0.31];
yCentreMass = [nan,12.17328176,3.812489495,2.642472035,2.118412431,1.304644141,0.876804441,0.760185999,0.526752971,0.429052288;
    8.981758654,3.422943992,2.256141739,1.243125878,1.022945019,0.817271251,0.560586891,0.442029934,0.39166477,0.329443422];
   % 2.304562612,1.518018258,0.901767579,0.779648928,0.590271474,0.608549841,0.603665914,0.451864794,0.466587043,0.442810586];
yErrCentreMass = [nan,2.156827227,0.341961349,0.104225931,0.312307199,0.147472215,0.048398177,0.029996719,0.027716329,0.045154457;
    1.949534974,0.349199702,0.319479026,0.036205572,0.084373467,0.094393343,0.024412964,0.053179545,0.018687939,0.035392207];
  %  0.060968828,0.058219436,0.063302935,0.047180716,0.040413652,0.019478045,0.038407423,0.029737199,0.056668734,0.026151592];
%No error for sim

xMagneticGradientAli = [0.6283186,0.9424779,1.2566372,1.8849558,2.5132744];
yAli = [3,1.6,1.3,1,0.7];
ySIMAli = [2.912,1.942,1.456,0.972,0.814];

%Flow@3mt:
xFlowVelocity = [0.005,0.01,0.015,0.02,0.025,0.03,0.035,0.04,0.045,0.05,0.055,0.06];
yFlowVelocity = [99.74,99.64,96.32,82.66,80.1,60.89999999999999,61.65999999999999,46.8,56.08,34.92,27.060000000000002,35.26];
yErrFlowVelocity = [0.08221921916437948,0.11384199576606148,0.22768399153212296,0.8411658576047878,0.6640783086353579,0.6008327554319939,1.9416384833433917,6.451046426743492,2.1250505876331505,3.9465225198901366,3.1433039942073684,0.9929551852928713]; %SE

xsplit = [0.005,0.01,0.015,0.02,0.025,0.03,0.035,0.04,0.045,0.05,0.055,0.06];
ysplit = [100,95.24,80.44,81.1,78.38,76.28,71.18,58.94,63.26,68.6,63.98,58.98];
yErrsplit = [0,1.505244166,0.999279741,1.106797181,1.005604296,2.049155924,2.156673364,3.181251326,0.018973666,8.032185257,9.986472851,5.938757446];

%Too low here
% xForceLimit = [1,0.5,0.25,0.125,0.0625,0.03125];
% yForceLimit = [99.64, 84.14, 54.62, 31.52, 28.88, 23.08];
% yErrForceLimit = [0.113841996,3.244496879,0.196061215,0.151789328,0.025298221,0.101192885];
xForceLimit = [1,0.5,0.4,0.3,0.2,0.1];
yForceLimit = [100, 82.26, 72.41999999999999, 58.06, 39.32000000000001, 29.660000000000004];
yErrForceLimit = [0,0.6574039853849377,0.8664640788861343,0.6261309767133448,1.176367289582639,0.5881836447913183];

%Value for report to paper
ySIM(1,:)
deviation = abs((ySIM(1,:) - yCentreMass(1,:))/yCentreMass(1,:))
deviation(2:end)
deviationa = abs((ySIM(2,:) - yCentreMass(2,:))/yCentreMass(2,:))
deviationnn = mean([deviation(2:end),deviationa])

%Figure 1 (CentreMass)
figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');

plot11 = errorbar(axes1,xMagneticGradient(1,:),yCentreMass(1,:), yErrCentreMass(1,:),'o-','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','blue','color','blue');%,'MarkerEdgeColor','#808080','MarkerFaceColor','#ff3300');
hold on
plot12 = errorbar(axes1,xMagneticGradient(2,:),yCentreMass(2,:), yErrCentreMass(2,:), 'square-','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','red');%,'MarkerEdgeColor','#808080','MarkerFaceColor','#008002');
hold on
plot13 = plot(axes1,xMagneticGradient(1,:),ySIM(1,:),'o--','MarkerEdgeColor','black','MarkerSize',4,'Color','blue','MarkerFaceColor','blue','color','blue');%,'MarkerEdgeColor','#808080','MarkerFaceColor','cyan');
hold on
plot14 = plot(axes1,xMagneticGradient(2,:),ySIM(2,:), 'square--','MarkerEdgeColor','black','MarkerSize',4,'Color','red','MarkerFaceColor','red');%,'MarkerEdgeColor','black','MarkerFaceColor','blue');
hold on

xlim(axes1,[50,1050]);
xlabel("Magnetic Gradient applied (mT/m)");
ylabel("Average time for particles to travel 1mm (s)");
box(axes1,'on');
grid(axes1,'on');

% Create legend
legend(axes1,'Measured at 2mT','Measured at 3mT','Simulated at 2mT','Simulated at 3mT','Location','northeast'); %Spread" formation','Particles start in a "Split Clump" formation','Particles start in a "Split Spread" formation','','','',''
title(axes1,"Time taken to travel 1mm for differing magnetic gradients");
fontname(axes1,"times new roman")

%Figure 2 (Ali Data)
figure2 = figure;
axes2 = axes('Parent',figure2);
hold(axes2,'on');

plot21 = plot(axes2,xMagneticGradientAli.*1000,yAli,'o-','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','blue','color','blue');
hold on
plot22 = plot(axes2,xMagneticGradientAli.*1000,ySIMAli,'square--','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','black','Color','blue');
hold on

xlim(axes2,[500,3000]);
xlabel("Limit of force user is permitted to apply (mT/m)");
ylabel("Percentage of particles reaching the goal");
box(axes2,'on');
grid(axes2,'on');
legend(axes2,'Previous experimental data','New simulated data','Location','northeast'); %Spread" formation','Particles start in a "Split Clump" formation','Particles start in a "Split Spread" formation','','','',''
title(axes2,"Time taken to travel 1mm for differing magnetic gradients");
fontname(axes2,"times new roman")

%Figure 1a (NewParticlesComparison)
figure1a = figure;
axes1a = axes('Parent',figure1a);
hold(axes1a,'on');

plot1a = plot(axes1a,yCentreMass(1,:),ySIM(1,:) ,'o-','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','blue','color','blue');
hold on
plot1b = plot(axes1a,yCentreMass(2,:),ySIM(2,:) ,'square-','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','blue');
hold on
plot1c = plot(axes1a,[0:12],[0:12],'-','Color','black');
hold on

xlabel("Experimental results time to reach 1mm");
ylabel("Simulated results time to reach 1mm");
box(axes1a,'on');
grid(axes1a,'on');
legend(axes1a,'2mt','3mt','Ideal Simulation','Location','southeast')
title(axes1a,"Comparison of simulated vs recorded times to travel 1mm");
fontname(axes1a,"times new roman")

%Figure 2a (NewParticlesComparison)
figure2a = figure;
axes2a = axes('Parent',figure2a);
hold(axes2a,'on');

plot1a = plot(axes2a,yAli,ySIMAli ,'o-','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','blue','color','blue');
hold on
plot1c = plot(axes2a,[0.6:0.1:3.1],[0.6:0.1:3.1],'-','Color','black');
hold on

xlim(axes2a,[0.6,3.1]);
ylim(axes2a,[0.6,3.1]);
xlabel("Experimental results time to reach 1mm");
ylabel("Simulated results time to reach 1mm");
box(axes2a,'on');
grid(axes2a,'on');
legend(axes2a,'Previous Experimental Data','Ideal Simulation','Location','southeast')
title(axes2a,"Comparison of simulated vs recorded times to travel 1mm");
fontname(axes2a,"times new roman")

%Figure 3 (Flow Velocity)
figure3 = figure;
axes3 = axes('Parent',figure3);
hold(axes3,'on');

plot31 = errorbar(axes3,xFlowVelocity(1,:),yFlowVelocity(1,:), yErrFlowVelocity(1,:),'o-','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','blue','color','blue');
hold on
plot32 = errorbar(axes3,xsplit(1,:),ysplit(1,:), yErrsplit(1,:),'square-','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','red','color','red');
hold on

xlim(axes3,[0,0.065]);
xlabel("Flow Velocity (m/s)");
ylabel("Percentage of particles reaching the goal");
box(axes3,'on');
grid(axes3,'on');

%Create Title
title(axes3,"Percentage of particles reaching the goal state for different fluid flow velocities");
legend(axes3,'clump start','split start','Location','southwest')
fontname(axes3,"times new roman")

%Figure 4 (ForceLimit)
figure4 = figure;
axes4 = axes('Parent',figure4);
hold(axes4,'on');

plot41 = errorbar(axes4,xForceLimit(1,:).*1000,yForceLimit(1,:), yErrForceLimit(1,:),'o-','MarkerEdgeColor','black','MarkerSize',4,'MarkerFaceColor','blue','color','blue');
hold on

xlim(axes4,[0,1050]);
xlabel("Limit of force user is permitted to apply (mT/m)");
ylabel("Percentage of particles reaching the goal");
box(axes4,'on');
grid(axes4,'on');

%Create Title
title(axes4,"Percentage of particles reaching the goal for different limits applied to user input");
fontname(axes4,"times new roman")