function createfigures()
%CREATEFIGURE(X1, YMatrix1)
%  X1:  vector of plot x data
%  YMATRIX1:  matrix of plot y data

%  Auto-generated by MATLAB on 08-Apr-2022 11:27:04

close all;

tSim = [0.8592,0.6590,0.4250,0.3411,0.2854];

magForce = [0.75,1,1.5,2,2.25];
tExp = [0.8,0.65,0.5,0.35,0.25];
vExp = 0.0001./tExp;
vSim = 0.0001./tSim;

magForceTSim = magForce(length(magForce) - length(tSim) + 1:length(magForce));
% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple line objects using matrix input to plot
plot1 = plot(magForceTSim,tSim,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
plot2 = plot(magForce,tExp,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
plot1.Color = 'blue';
plot2.Color = 'red';
set(plot1,'DisplayName','Simulation');
set(plot2,'DisplayName','Real world Experimental Data');

% Create ylabel
ylabel('Time(s)');
ylim([0,max([max(tSim),max(tExp)]).*1.1]);
xlim([0,2.4]);

% Create xlabel
xlabel('Magnetic Gradient (MA/m^2)');

% Create title
title('Time taken to travel 1mm for differeing magnetic gradients');

box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
% Create legend
legend(axes1,'show','Location','northeast');


%Now Velocity
if(length(vSim) > 1)
    % Create figure
    figure2 = figure;
    % Create axes
    axes2 = axes('Parent',figure2);
    hold(axes2,'on');
    grid(axes2,'on');
    
    % Create multiple line objects using matrix input to plot
    plot3 = plot(magForceTSim,vSim,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
    plot4 = plot(magForce,vExp,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
    plot3.Color = 'blue';
    plot4.Color = 'red';
    set(plot3,'DisplayName','Simulation');
    set(plot4,'DisplayName','Real world Experimental Data');
    
    % Create ylabel
    ylabel('Velocity (m/s)');
    ylim([0,max([max(vSim),max(vExp)]).*1.1]);
    xlim([0,2.4]);
    
    % Create xlabel
    xlabel('Magnetic Gradient (MA/m^2)');
    
    % Create title
    title('Velocity recorded at 1mm for differing magnetic gradients');
    
    box(axes2,'on');
    hold(axes2,'off');
    % Create legend
    legend(axes2,'Location','northwest');
end
