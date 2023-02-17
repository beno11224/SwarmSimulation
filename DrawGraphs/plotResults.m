function plotResults()
%CREATEFIGURE(X1, YMatrix1)
%  X1:  vector of plot x data
%  YMATRIX1:  matrix of plot y data

%  Auto-generated by MATLAB on 08-Apr-2022 11:27:04

close all;

x = 5:5:60;
x = x ./ 1000;
yCOMSOL = [15	5	3	2	25;
15	5	2	2	25;
15	5	2	2	25;
15	5	2	2	25;
15	5	2	2	25;
15	5	2	2	25;
15	5	1	2	25;
15	5	2	1	25;
15	5	2	2	25;
15	5	2	2	25;
15	5	2	1	25;
15	5	1	2	25];
% yMATLAB = [23	13	0	0	14; %Something before?
% 3	0	0	36	11;
% 1	3	1	25	20;
% 0	13	1	14	22;
% 0	25	0	5	20;
% 0	19	1	7	19;
% 1	28	0	1	19;
% 0	26	1	1	21;
% 1	29	0	0	17;
% 0	30	0	1	18;
% 0	29	0	0	21;
% 0	25	0	0	25];
% yMATLAB = [13 20 0 0 13 %NewFlow
% 1 2 0 21 22
% 0 1 0 23 22
% 0 12 0 14 20
% 0 22 0 3 21
% 0 19 1 7 19
% 0 22 0 1 23
% 0 25 0 0 21
% 0 25 0 0 21
% 0 22 0 0 23
% 0 21 0 0 25
% 0 23 0 0 23];
% yMATLAB = [11	11	0	0	24; %Initial Velocity
% 1	1	0	33	11;
% 0	3	0	25	18;
% 1	15	2	11	17;
% 0	18	0	4	24;
% 0	22	0	4	20;
% 0	23	0	0	23;
% 0	26	0	0	20;
% 1	24	0	0	21;
% 0	20	0	0	26;
% 1	22	0	0	23;
% 0	25	0	0	20;
% ];
yMATLAB = [12 5 0 0 19; %FlowAsVelocity
11 6 0 0 20;
11 6 0 0 20;
10 6 0 0 20;
11 7 0 0 20;
10 6 0 0 20;
10 7 0 0 20;
12 5 1 0 21;
9 10 0 0 21;
11 6 0 0 21;
13 6 0 0 22;
11 5 0 0 22];

% yMATLAB = [16 12 0 0 22 %slowdown 15
% 3 0 0 12 35
% 2 3 0 20 25
% 0 7 0 13 30
% 0 10 0 7 33
% 0 11 0 3 33;
% 0 0 0 0 0;
% 0 0 0 0 0;
% 0 0 0 0 0;
% 0 0 0 0 0;
% 0 0 0 0 0;
% 0 0 0 0 0;];
% %yStartDist1OLD = [97.2, 89.2, 81.8];
% yStartDist = [97.6, 95.2, 94.2, 89.6; 
%     98.4, 97.6, 96.2, 93.2; 
%     94.6, 95.4, 88, 86; 
%     90, 97.8, 83.2, 83.8; 
%     94.4, 94, 81, 80; 
%     92, 87.4, 73.8, 83.2];
% yStartDist05 = [98.8, 100, 92.2];
% yStartDist1 = [94.4, 98.8, 92.6];
% yStartDist15 = [91.4, 94.4, 89];
% yStartDist2 = [95, 91.6, 82.4];
% yOLDParticleSize = [63,81.2,80.2,69.6,66.6,71.6,78.8];
% yOLDForceCap = [84.4,85.2,88,95.2,96.4];
% yOLDFlow = [99.77777778,98.4,98.4,79.4,59.2,39,29.4];
% SEParticleSize = [2.235073949, 0.777460253, 0.952190457, 1.783878421, 0.653197265, 0.426874949, 3.923717059];
% SEForceCap = [6.593262554, 10.56303828, 2.04504822, 2.851120637, 1.339983416];
% SEFlow = [1.627540749, 1.423610434, 0.843274043, 0.742368582, 0.653197265, 2.816617357, 2.048305533];
% %SEStartDist1OLD = [0.742368582, 5.225578118, 5.019517462];
% SEStartDist = [1.1384199576606147, 0.25298221281346944, 0.06324555320336848, 1.7708754896942906;
%     0.12649110640673697, 0.12649110640673697, 0.06324555320336848, 1.0119288512538822;
%     1.0751744044572507, 0.18973665961010097, 1.2649110640673518, 1.8973665961010275;
%     0.6324555320336759, 0.06324555320336848, 2.782804340948173, 4.4904342774391;
%     1.7708754896942906, 1.8973665961010275, 5.375872022286245, 1.2649110640673518;
%     1.8973665961010275, 2.7195587877448046, 0.6957010852370443, 0.8854377448471453];
% SEStartDist05 = [0.8, 0, 2.640706976];
% SEStartDist1 = [1.146976702, 0.611010093, 2.441311123];
% SEStartDist15 = [2.733333333, 1.107549848, 3.058685266];
% SEStartDist2 = [1.406334874, 3.109841011, 3.474350459];
% SEOLDParticleSize = [4.592264026,2.274496281,3.903844259,3.550273855,3.967086812,3.396730454,3.043389923];
% SEOLDForceCap = [4.73,2.274496281,3.438345856,2.653299832,1.066666667];
% SEOLDFlow = [0.25,1,0.777460253,4.110150038,5.40945674,4.394440933,4.310710176];

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

plot1 = plot(x,yMATLAB, '.-','MarkerSize',4,'MarkerFaceColor','#ff3300');
%barPlot1 = bar(axes1, x, yCOMSOL);%,"stacked");
%barPlot2 = bar(axes1, x, yMATLAB);%,"stacked");




set(plot1(1),'DisplayName','Goal 1');
set(plot1(2),'DisplayName','Goal 2');
set(plot1(3),'DisplayName','Goal 3');
set(plot1(4),'DisplayName','Goal 4');
set(plot1(5),'DisplayName','Goal 5');
xlabel(axes1,"Maximum Fluid Velocity (m/s)");
ylabel(axes1, 'Number of particles reaching each goal state');
ylim(axes1,[0,40]);
title(axes1,'Number of particles reaching each goal state for different fluid velocities');
box(axes1,'on');
grid(axes1,'on');
legend(axes1,'show','Location','southeast');




%plot1 = errorbar(axes1, xParticleSize, yOLDParticleSize, 'diamond-','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','#ff3300');

% Create multiple line objects using matrix input to plot
% plot5 = errorbar(axes1, xParticleSize, yOLDParticleSize, SEOLDParticleSize,'diamond-','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','#ff3300');
% plot6 = errorbar(axes2, xForceCap, yOLDForceCap, SEOLDForceCap, 'diamond-','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','#008002');
% plot7 = errorbar(axes3, xFlow, yOLDFlow, SEOLDFlow,'diamond-','MarkerSize',4,'MarkerEdgeColor','#808080','MarkerFaceColor','cyan');
% plot1 = errorbar(axes1, xParticleSize, yParticleSize, SEParticleSize,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
% plot2 = errorbar(axes2, xForceCap, yForceCap, SEForceCap, 'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','magenta');
% plot3 = errorbar(axes3, xFlow, yFlow, SEFlow,'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
%plot05 = errorbar(axes4, xStartDist-0.05, yStartDist05, SEStartDist05,'o','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
%plot10 = errorbar(axes4, xStartDist, yStartDist1, SEStartDist1,'square','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
%plot15 = errorbar(axes4, xStartDist+0.05, yStartDist15, SEStartDist15,'<','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','magenta');
%plot20 = errorbar(axes4, xStartDist+0.1, yStartDist2,SEStartDist2,'>','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','cyan');
%plot05 = errorbar(axes4, xStartDistFlow, yStartDist(:,1), SEStartDist(:,1),'o--','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
%plot10 = errorbar(axes4, xStartDistFlow, yStartDist(:,2), SEStartDist(:,2),'square-','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
%plot15 = errorbar(axes4, xStartDistFlow, yStartDist(:,3), SEStartDist(:,3),'<-.','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','magenta');
%plot20 = errorbar(axes4, xStartDistFlow, yStartDist(:,4), SEStartDist(:,4),'>:','MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','#008002');
%barPlot05 = bar(axes4, xStartDistFlow, yflip,"stacked");


% newYStartDistTWO = yStartDist(:,[1,3]);
% newSESTARTDISTTWO = SEStartDist(:,[1,3]);
% barPlot05 = bar(axes4, xStartDistFlow.* 200, newYStartDistTWO,"grouped");
% hold on;
% barPlot05(1).FaceColor = 'red';
% barPlot05(2).FaceColor = 'blue';
% %barPlot05(3).FaceColor = 'magenta';
% %barPlot05(4).FaceColor = '#008002';
% 
% ngroups = size(newYStartDistTWO, 1);
% nbars = size(newYStartDistTWO, 2);
% % Calculating the width for each bar group
% groupwidth = min(0.8, nbars/(nbars + 1.5));
% for i = 1:nbars
%     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     errorbar(x, newYStartDistTWO(:,i), newSESTARTDISTTWO(:,i), '.','Color','black');
% end
% %plot05 = errorbar(axes4, xStartDistFlow, yStartDist(:,1), SEStartDist(:,1),'MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','red');
% %plot10 = errorbar(axes4, xStartDistFlow, yStartDist(:,2), SEStartDist(:,2),'MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','blue');
% %plot15 = errorbar(axes4, xStartDistFlow, yStartDist(:,3), SEStartDist(:,3),'MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','magenta');
% %plot20 = errorbar(axes4, xStartDistFlow, yStartDist(:,4), SEStartDist(:,4),'MarkerSize',4,'MarkerEdgeColor','black','MarkerFaceColor','#008002');
% %plot05.LineStyle = "none";
% %plot10.LineStyle = "none";
% %plot15.LineStyle = "none";
% %plot20.LineStyle = "none";
% 
% plot1.Color = 'black';
% plot2.Color = 'black';
% plot3.Color = 'black';
% %plot05.Color = 'red';
% %plot10.Color = 'blue';
% %plot15.Color = 'magenta';
% %plot20.Color = "#008002";
% %plot05.Color = 'red';
% %plot10.Color = 'blue';
% %plot15.Color = 'magenta';
% %plot20.Color = 'cyan';
% plot5.Color = '#808080';
% plot6.Color = '#808080';
% plot7.Color = '#808080';
% set(plot1,'DisplayName','Novint Falcon haptic device based control');%Effect of particle chain length on particle control
% set(plot2,'DisplayName','Novint Falcon haptic device based control');
% set(plot3,'DisplayName','Novint Falcon haptic device based control');
% 
% set(barPlot05(1),'DisplayName','Particles start in a "Clump" formation');
% set(barPlot05(2),'DisplayName','Particles start in a "Split" formation');
% %set(barPlot05(2),'DisplayName','Particles start in a "Spread" formation');
% %set(barPlot05(3),'DisplayName','Particles start in a "Split Clump" formation');
% %set(barPlot05(4),'DisplayName','Particles start in a "Split Spread" formation');
% %set(plot05,'DisplayName','Fluid Flow of 0.5 m/s');
% %set(plot10,'DisplayName','Fluid Flow of 1 m/s');
% %set(plot15,'DisplayName','Fluid Flow of 1.5 m/s');
% %set(plot20,'DisplayName','Fluid Flow of 2 m/s');
% 
% set(plot5,'DisplayName','Keyboard based control');
% set(plot6,'DisplayName','Keyboard based control');
% set(plot7,'DisplayName','Keyboard based control');
% 
% % Create x and y labels
% xlabel(axes1,"Length of particle chain in whole particles");
% ylabel(axes1, 'Percentage of particles reaching goal state');
% ylim(axes1,[0,100]);
% xlabel(axes2,"Maximum magnetic field gradient (MA/m^2)");
% ylabel(axes2, 'Percentage of particles reaching goal state');
% ylim(axes2,[0,100]);
% xlabel(axes3,"Rate of simulated blood-flow (m/s)");
% ylabel(axes3, 'Percentage of particles reaching goal state');
% ylim(axes3,[0,100]);
% xlabel(axes4,"Fluid Flow (m/s)");
% ylabel(axes4, 'Percentage of particles reaching goal state');
% ylim(axes4,[50,100]);
% % Create title
% title(axes1,'Effect of particle chain length on particle control');
% title(axes2,'Effect of capping the magnetic force on particle control');
% title(axes3,'Effect of flow rate on percentage on particle control');
% title(axes4,'Effect of starting distribution on particle control');
% 
% 
% box(axes1,'on');
% grid(axes1,'on');
% % Create legend
% legend(axes1,'show','Location','southeast');
% box(axes2,'on');
% grid(axes2,'on');
% % Create legend
% legend(axes2,'show','Location','southeast');
% box(axes3,'on');
% grid(axes3,'on');
% % Create legend
% legend(axes3,'show','Location','southwest');
% 
% legend(axes4,'Particles start in a "Clump" formation','Particles start in a "Split" formation','Location','southwest'); %Spread" formation','Particles start in a "Split Clump" formation','Particles start in a "Split Spread" formation','','','',''
% %axes4.XAxis.TickLabels = categorical(["Clump","Line","Split"]);
% %axes4.XAxis.TickLabels = categorical(["0.005","0.01","0.015","0.02","0.025","0.03"]);
% %axes4.XAxis.TickLabels = [0.005,"",0.01,"",0.015,"",0.02,"",0.025,"",0.03];
% axes4.XAxis.TickLabels = [0.005,0.01,0.015,0.02,0.025,0.03];
% %axes4.XAxis.TickValues = [0.005,0.01,0.015,0.02,0.025,0.03];
% %axes4.XAxis.TickLabels = [0.005,0.01,0.015,0.02,0.025,0.03];
% box(axes4,'on');
% grid(axes4,'on');

