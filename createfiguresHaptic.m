function createfiguresHaptic()
%CREATEFIGURE(X1, YMatrix1)
%  X1:  vector of plot x data
%  YMATRIX1:  matrix of plot y data

%  Auto-generated by MATLAB on 08-Apr-2022 11:27:04

close all;

xParticleSize = [50, 75, 100, 125, 150, 175, 200];
xForceCap = [0.5, 1, 1.5, 2, 2.25];
xFlow = [0.001, 0.0025, 0.005, 0.01, 0.015, 0.02, 0.025];
xStartDist = categorical({'Clump', 'Spread', 'Two'});
yParticleSize = [95.2, 98.4, 97.2, 96.4, 98.4, 98.6, 94.8];
yForceCap = [52.6, 61, 94.6, 94.2, 97.2];
yFlow = [0,0,98, 97.2, 96.4, 85, 86.8];
yStartDist = [97.2, 89.2, 81.8];
yOLDParticleSize = [63,81.2,80.2,69.6,66.6,71.6,78.8];
yOLDForceCap = [84.4,85.2,88,95.2,96.4];
yOLDFlow = [99.77777778,98.4,98.4,79.4,59.2,39,29.4];
SEParticleSize = [2.235073949, 0.777460253, 0.952190457, 1.783878421, 0.653197265, 0.426874949, 3.923717059];
SEForceCap = [6.593262554, 10.56303828, 2.04504822, 2.851120637, 1.339983416];
SEFlow = [0,0,0.843274043, 0.742368582, 0.653197265, 2.816617357, 2.048305533];
SEStartDist = [0.742368582, 5.225578118, 5.019517462];
SEOLDParticleSize = [4.592264026,2.274496281,3.903844259,3.550273855,3.967086812,3.396730454,3.043389923];
SEOLDForceCap = [4.73,2.274496281,3.438345856,2.653299832,1.066666667];
SEOLDFlow = [0.25,1,0.777460253,4.110150038,5.40945674,4.394440933,4.310710176];

% Create figure
figure1 = figure;
figure2 = figure;
figure3 = figure;
figure4 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
axes2 = axes('Parent',figure2);
hold(axes2,'on');
axes3 = axes('Parent',figure3);
hold(axes3,'on');
axes4 = axes('Parent',figure4);
hold(axes4,'on');


% Create multiple line objects using matrix input to plot
plot5 = errorbar(axes1, xParticleSize, yOLDParticleSize, SEOLDParticleSize,'diamond-','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','#ff3300');
plot6 = errorbar(axes2, xForceCap, yOLDForceCap, SEOLDForceCap, 'diamond-','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','#008002');
plot7 = errorbar(axes3, xFlow, yOLDFlow, SEOLDFlow,'diamond-','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','cyan');
plot1 = errorbar(axes1, xParticleSize, yParticleSize, SEParticleSize,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
plot2 = errorbar(axes2, xForceCap, yForceCap, SEForceCap, 'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','magenta');
plot3 = errorbar(axes3, xFlow, yFlow, SEFlow,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
plot4 = errorbar(axes4, xStartDist, yStartDist, SEStartDist,'o','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','#b49900');
%plot1 = plot(axes1,xParticleSize , yParticleSize,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
%plot2 = plot(axes2,xForceCap,yForceCap,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','magenta');
%plot3 = plot(axes3,xFlow,yFlow,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
%plot4 = plot(axes4,xStartDist,yStartDist,'o','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
plot1.Color = 'black';
plot2.Color = 'black';
plot3.Color = 'black';
plot4.Color = 'black';
plot5.Color = '#808080';
plot6.Color = '#808080';
plot7.Color = '#808080';
set(plot1,'DisplayName','Novint Falcon haptic device based control');%Effect of particle chain length on particle control
set(plot2,'DisplayName','Novint Falcon haptic device based control');
set(plot3,'DisplayName','Novint Falcon haptic device based control');
set(plot4,'DisplayName','Novint Falcon haptic device based control');

set(plot5,'DisplayName','Keyboard based control');
set(plot6,'DisplayName','Keyboard based control');
set(plot7,'DisplayName','Keyboard based control');

% Create x and y labels
xlabel(axes1,"Length of particle chain in whole particles");
ylabel(axes1, 'Percentage of particles reaching goal state');
ylim(axes1,[0,100]);
xlabel(axes2,"Maximum magnetic field gradient (MA/m^2)");
ylabel(axes2, 'Percentage of particles reaching goal state');
ylim(axes2,[0,100]);
xlabel(axes3,"Rate of simulated blood-flow (m/s)");
ylabel(axes3, 'Percentage of particles reaching goal state');
ylim(axes3,[0,100]);
xlabel(axes4,"Starting distribution");
ylabel(axes4, 'Percentage of particles reaching goal state');
ylim(axes4,[0,100]);
% Create title
title(axes1,'Effect of particle chain length on particle control');
title(axes2,'Effect of capping the magnetic force on particle control');
title(axes3,'Effect of flow rate on percentage of particles reaching the goal state');
title(axes4,'Effect of starting distribution on percentage of particles reaching the goal state');


box(axes1,'on');
grid(axes1,'on');
% Create legend
legend(axes1,'show','Location','southeast');
box(axes2,'on');
grid(axes2,'on');
% Create legend
legend(axes2,'show','Location','southeast');
box(axes3,'on');
grid(axes3,'on');
% Create legend
legend(axes3,'show','Location','southwest');
box(axes4,'on');
grid(axes4,'on');

