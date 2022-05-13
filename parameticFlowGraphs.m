function parametricFlowGraphs()

close all;

FlowVel = [0.001,0.0025, 0.005, 0.01, 0.015, 0.02, 0.025];
AvgPercent = [99.3,95.3,96.7,86,54.7,33.3,12.7];
Minpercent = [98,92,92,76,10,20,8];
MaxPercent = [100,98,100,96,82,60,16];


% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple line objects using matrix input to plot
%plot1 = plot(FlowVel,AvgPercent,'.-');
%set(plot1,'DisplayName','Percentage of particles reaching the goal state');

data1 = errorbar(FlowVel,AvgPercent,AvgPercent - Minpercent,MaxPercent - AvgPercent);
set(data1,'DisplayName','Percentage of particles reaching the goal state');

% Create ylabel
ylabel('Percentage');

% Create xlabel
xlabel('Flow(m/s)');

% Create title
title('Percentage of particles reaching the goal state');

box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
% Create legend
legend(axes1,'show','Location','southwest');
