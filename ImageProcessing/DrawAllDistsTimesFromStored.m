close all
startFrom = 1;

Title = "different field magnitudes";
legendUnits = " (mT)";
fileName = "ADistandTime.mat";
startFrom = 2;

% Title = "different field rotation freqencies \theta";
% legendUnits = " (Hz)";
% fileName = "BDistandTime.mat";

% Title = "different field rotation step freqencies \phi";
% legendUnits = " (Hz)";
% fileName = "CDistandTime.mat";

% Title = "different field rotation step angles \eta";
% legendUnits = " ("+char(176)+")";
% fileName = "DDistandTime.mat";

% Title = "different field roll angles";
% legendUnits = " ("+char(176)+")";
% fileName = "EDistandTime.mat";

% Title = "Distance travelled by swarm over time for " + Title;
%YLIMES = [0,5]
Title = "Relative ratio pixels occupied by particles for " + Title;
YLIMES = [0.01,0.2]
load(fileName,"allDists","allTimes","allFileValues","allPix","allwPix","allMPix","allMwPix","allRadius");

legendNames = string(sort(allFileValues)) + legendUnits;
ab = size(allTimes);
for(i = startFrom:size(allDists,1))
    maxX = 0;
    numPoints = 1000; % Whatever resolution you want.
    xCommon = linspace(0, 100, numPoints);
    ySum = zeros(1, numPoints);
    circleRadius = 0;

    for(j = 1:size(allDists,2))
        allTimeValues = cell2mat(allTimes(i,j));
        if(maxX< max(allTimeValues))
            maxX = max(allTimeValues);
        end
        % if(~isempty(allRadius(i,j)))
        %     circleRadius = cell2mat(allRadius(i,j));
        % end
    end
    % if(circleRadius == 0)
    %     %Provide circle radius
    %     circleRadius = 262;
    % end
    %This method is a bit sketchy. Just use 262 for the time being, if it
    %seems very wrong later then fix it.
    circleRadius = 262;
    mmPerPixel = 10/(circleRadius*2);
    lineAverage = [];

    yVals = [];
    for(j = 1:size(allDists,2))
        allDistValues = cell2mat(allDists(i,j));
        allTimeValues = cell2mat(allTimes(i,j));
        allPixValues = cell2mat(allPix(i,j));
        allwPixValues = cell2mat(allwPix(i,j));
        allMwPixValues = cell2mat(allMwPix(i,j));
        allMPixValue = cell2mat(allMPix(i,j));
        
        %yCom = interp1(allTimeValues, allDistValues, xCommon);
        %ySum = ySum + interp1(allTimeValues, allDistValues, xCommon);
        %yCom = interp1(allTimeValues, allwPixValues./allPixValues, xCommon);
        yCom = interp1(allTimeValues, allMwPixValues./allMPixValue, xCommon);
        ySum = ySum + yCom;
        yVals(j,:) = yCom;

        % plot(allTimeValues,allDistValues);
        % hold on
    end

    %Plot Distance
    if(false)
        plot(xCommon,(ySum./size(allDists,2))*mmPerPixel);
        ylabel("Distance travelled from original location (mm)")
        xlabel("Time(s)")
        legend(legendNames)
        title(Title)
        hold on
        ylim(YLIMES)
    end
    %Plot Relative Density (Image proportion)
    if(true)
        aaa = isnan(yVals);
        avgVal = mean(yVals,1);
        stdVal = std(yVals,1,1);
        xCommon(isnan(avgVal)) = [];
        stdVal(isnan(avgVal)) = [];
        avgVal(isnan(avgVal)) = [];
        avgLine = plot(xCommon,avgVal);
        patchLine = patch([xCommon fliplr(xCommon)], [(avgVal + stdVal) fliplr((avgVal - stdVal))],avgLine.Color, 'FaceAlpha', .3 ,'LineStyle','none');
        ylabel("Relative pixel density as a proportion of the image over time")
        xlabel("Time(s)")
        legendNamesdupe = sort([legendNames(startFrom:size(allDists,1)) (insertAfter(legendNames(startFrom:size(allDists,1)),1," STD"))]);
        legend(legendNamesdupe)
        title(Title)
        hold on
        ylim(YLIMES)
    end
    %Plot Relative Density (Percentage of initial Density)
    if(false)
        plot(xCommon,(ySum./size(allDists,2))*mmPerPixel);
        ylabel("Relative pixel density difference from the initial relative pixel density over time")
        xlabel("Time(s)")
        legend(legendNames)
        title(Title)
        hold on
        ylim(YLIMES)
    end
end
Title = erase(erase(Title," "),"\")
savefig(Title+"OpticalFlow.fig")