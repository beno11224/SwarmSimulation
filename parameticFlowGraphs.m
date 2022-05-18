function parametricFlowGraphs()

close all;

FlowVel = [0.001,0.0025, 0.005, 0.01, 0.015, 0.02, 0.025];
AvgPercent = [99.6,96.8,97.6,82.8,54.8,36,18.8];
Minpercent = [98,92,92,64,44,20,8];
MaxPercent = [100,100,100,96,64,60,34];
STDFlowErr = [0.4,1.356465997,1.469693846,5.782732918,3.666060556,7.720103626,4.409081537];

particleSize = [50, 75, 100, 125, 150, 175,200];
sizePercent = [69.33333333,80.66666667,79.33333333,70.66666667,68.66666667,63.33333333,74.66666667];
MinSizepercent = [64,68,68,70,60,56,66];
MaxSizepercent = [74,88,86,72,84,70,90];
STDSizeErr = [2.905932629,6.359594676,5.696002497,0.666666667,7.688375063,4.05517502,7.688375063];

MagForce = [1,1.5,2,2.25];
MFNFPercent = [98.4,100,98.8,99.6];
MinMFNFpercent = [94,100,98,98];
MaxMFNFpercent = [100,100,100,100];
STDMFNFErr = [1.166190379,0,0.489897949,0.4];
MFFPercent = [85.6,87.6,98.8,96.4];
MinMFFpercent = [72,74,98,92];
MaxMFFpercent = [100,100,100,100];
STDMFFErr = [4.489988864,5.635601121,0.489897949,1.469693846];



%Flow
figFlow = figure;

% Create axes
axes1 = axes('Parent',figFlow);
hold(axes1,'on');

% Create multiple line objects using matrix input to plot
%plot1 = plot(FlowVel,AvgPercent,'.-');
%set(plot1,'DisplayName','Percentage of particles reaching the goal state');

%data1 = errorbar(FlowVel,AvgPercent,AvgPercent - Minpercent,MaxPercent - AvgPercent);
data1 = errorbar(FlowVel,AvgPercent,STDFlowErr,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
data1.Color = 'black';
set(data1,'DisplayName','Percentage of particles reaching the goal state');

% Create ylabel
ylabel('Percentage');
ylim([0,100]);

% Create xlabel
xlabel('Flow (m/s)');

% Create title
title('Percentage of particles reaching the goal state');

box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
% Create legend
legend(axes1,'show','Location','southwest');

%--------------------------------------------------------------------------

%ParticleSize
figSize = figure;

% Create axes
axes2 = axes('Parent',figSize);
hold(axes2,'on');

% Create multiple line objects using matrix input to plot
%plot2 = plot(particleSize,sizePercent,'.-');
%set(plot2,'DisplayName','Percentage of particles reaching the goal state');

%data2 = errorbar(particleSize,sizePercent,sizePercent - MinSizepercent,MaxSizepercent - sizePercent);
data2 = errorbar(particleSize,sizePercent,STDSizeErr,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
data2.Color = 'black';
set(data2,'DisplayName','Percentage of particles reaching the goal state');

% Create ylabel
ylabel('Percentage');
ylim([0,100]);

% Create xlabel
xlabel('Length of particle chain in whole particles');

% Create title
title('Effect of particle chain length on particle control');

box(axes2,'on');
grid(axes2,'on');
hold(axes2,'off');
% Create legend
legend(axes2,'show','Location','southwest');

%--------------------------------------------------------------------------

%MagForce
figMag = figure;

% Create axes
axes3 = axes('Parent',figMag);
hold(axes3,'on');

% Create multiple line objects using matrix input to plot
%plot3 = plot(MagForce,MFFPercent,'.-');
%set(plot3,'DisplayName','Flow 0.01m/s Percentage of particles reaching the goal state');
%plot3a = plot(MagForce,MFNFPercent,'.-');
%set(plot3a,'DisplayName','NoFlow Percentage of particles reaching the goal state');

%data3 = errorbar(MagForce,MFNFPercent,MFNFPercent - MinMFNFpercent,MaxMFNFpercent - MFNFPercent);
%data3 = errorbar(MagForce,MFNFPercent,STDMFNFErr);
%set(data3,'DisplayName','NoFlow Percentage of particles reaching the goal state');
%data3a = errorbar(MagForce,MFFPercent,MFFPercent - MinMFFpercent,MaxMFFpercent - MFFPercent);
data3a = errorbar(MagForce,MFFPercent,STDMFFErr,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','magenta');
data3a.Color = 'black';
set(data3a,'DisplayName','Flow 0.01m/s Percentage of particles reaching the goal state');

% Create ylabel
ylabel('Percentage');
ylim([0,100]);

% Create xlabel
xlabel('Magnetic Field Gradient (MA/m^2)');

% Create title
title('Effect of capping the magnetic force on particle control');

box(axes3,'on');
grid(axes3,'on');
hold(axes3,'off');
% Create legend
legend(axes3,'show','Location','southwest');