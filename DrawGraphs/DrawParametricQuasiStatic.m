%%Draw data for experimentation occurring in Dec 23
close all
%--------------------Data:
%Comparison with real world
xMagneticGradient = [nan,200,300,400,500,600,700,800,900,1000;
    100,200,300,400,500,600,700,800,900,1000;
    100,200,300,400,500,600,700,800,900,1000];
ySIM = [18.274,9.138,6.092,4.57,3.656,3.046,2.612,2.286,2.032,1.828;
    9.304,4.652,3.102,2.326,1.862,1.552,1.33,1.164,1.034,0.932;
    6.99,3.496,2.33,1.748,1.398,1.166,1,0.874,0.778,0.7];
yCentreMass = [nan,12.17328176,3.812489495,2.642472035,2.118412431,1.304644141,0.876804441,0.760185999,0.526752971,0.429052288;
    8.981758654,3.422943992,2.256141739,1.243125878,1.022945019,0.817271251,0.560586891,0.442029934,0.39166477,0.329443422;
    2.304562612,1.518018258,0.901767579,0.779648928,0.590271474,0.608549841,0.603665914,0.451864794,0.466587043,0.442810586];
yErrCentreMass = [nan,2.156827227,0.341961349,0.104225931,0.312307199,0.147472215,0.048398177,0.029996719,0.027716329,0.045154457;
    1.949534974,0.349199702,0.319479026,0.036205572,0.084373467,0.094393343,0.024412964,0.053179545,0.018687939,0.035392207;
    0.060968828,0.058219436,0.063302935,0.047180716,0.040413652,0.019478045,0.038407423,0.029737199,0.056668734,0.026151592];
%No error for sim
%Flow@3mt:
xFlowVelocity = [0,10,20,30,40,50,60,70];
yFlowVelocity = [100,100,99.82,93.5,72.2,72.36,59.74,54.84];
yErrFlowVelocity = [0,0,0.54,8.867130314,15.84095957,17.39167617,12.70466056,8.548590527];

xForceLimit = [1,0.5,0.25,0.125,0.0625];
yForceLimit = [81.8,64.66,47.38,27.72,21.1];
yErrForceLimit = [23.57252638,4.067480793,7.483555305,1.505191018,0.286356421];


%Value for report to paper
deviation = abs(ySIM(3,:) - yCentreMass(3,:))
deviation = mean(deviation(2:end))

%Figure 1 (CentreMass)
figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');

plot11 = errorbar(axes1,xMagneticGradient(1,:),yCentreMass(1,:), yErrCentreMass(1,:),'o-','MarkerSize',4);%,'MarkerEdgeColor','#808080','MarkerFaceColor','#ff3300');
hold on
plot12 = errorbar(axes1,xMagneticGradient(2,:),yCentreMass(2,:), yErrCentreMass(2,:), 'o-','MarkerSize',4);%,'MarkerEdgeColor','#808080','MarkerFaceColor','#008002');
hold on
plot13 = errorbar(axes1,xMagneticGradient(3,:),yCentreMass(3,:), yErrCentreMass(3,:),'o-','MarkerSize',4);%,'MarkerEdgeColor','#808080','MarkerFaceColor','cyan');
hold on
plot14 = errorbar(axes1,xMagneticGradient(2,:),ySIM(2,:), yErrCentreMass(2,:),'x--','MarkerSize',4);%,'MarkerEdgeColor','black','MarkerFaceColor','blue');
hold on

xlim(axes1,[50,1050]);
xlabel("Magnetic Gradient applied (mT/m)");
ylabel("Average time for particles to travel 1mm (s)");
box(axes1,'on');
grid(axes1,'on');

% Create legend
legend(axes1,'Measured at 2mT','Measured at 3mT','Measured at 4mT','Simulated at 3mT','Location','northeast'); %Spread" formation','Particles start in a "Split Clump" formation','Particles start in a "Split Spread" formation','','','',''

%Figure 2 (Flow Velocity)
figure2 = figure;
axes2 = axes('Parent',figure2);
hold(axes2,'on');

plot21 = errorbar(axes2,xFlowVelocity(1,:),yFlowVelocity(1,:), yErrFlowVelocity(1,:),'o-','MarkerSize',4,'MarkerFaceColor','black');
hold on
% plot22 = errorbar(axes2,xFlowVelocity(2,:),yFlowVelocity(2,:), yErrCentreMass(2,:), 'o--','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','#008002');
% hold on
% plot23 = errorbar(axes2,xFlowVelocity(3,:),yFlowVelocity(3,:), yErrCentreMass(3,:),'o--','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','cyan');
% hold on
% plot24 = errorbar(axes2,xFlowVelocity(2,:),ySIM(2,:), yErrCentreMass(2,:),'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
% hold on

xlim(axes2,[-5,75]);
xlabel("Flow Velocity (m/s)");
ylabel("Percentage of particles reaching the goal");
box(axes2,'on');
grid(axes2,'on');

% Create legend
%legend(axes2,'Measured at 2mT','Measured at 3mT','Measured at 4mT','Simulated at 3mT','Location','northeast'); %Spread" formation','Particles start in a "Split Clump" formation','Particles start in a "Split Spread" formation','','','',''
%Title
%TODO

%Figure 3 (ForceLimit)
figure3 = figure;
axes3 = axes('Parent',figure3);
hold(axes3,'on');

plot31 = errorbar(axes3,xForceLimit(1,:).*1000,yForceLimit(1,:), yErrForceLimit(1,:),'o-','MarkerSize',4,'MarkerFaceColor','black');
hold on
% plot32 = errorbar(axes3,xMagneticGradient(2,:),yCentreMass(2,:), yErrCentreMass(2,:), 'o--','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','#008002');
% hold on
% plot33 = errorbar(axes3,xMagneticGradient(3,:),yCentreMass(3,:), yErrCentreMass(3,:),'o--','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','cyan');
% hold on
% plot34 = errorbar(axes3,xMagneticGradient(2,:),ySIM(2,:), yErrCentreMass(2,:),'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
% hold on

xlim(axes3,[50,1050]);
xlabel("Limit of force user is permitted to apply (mT/m)");
ylabel("Percentage of particles reaching the goal");
box(axes3,'on');
grid(axes3,'on');

% Create legend
%legend(axes2,'Measured at 2mT','Measured at 3mT','Measured at 4mT','Simulated at 3mT','Location','northeast'); %Spread" formation','Particles start in a "Split Clump" formation','Particles start in a "Split Spread" formation','','','',''
%Title
%TODO