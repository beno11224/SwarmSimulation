close all

%For calculating how far the swarm moved
circleRadius = 262;
mmPerPixel = 10/(circleRadius*2);

Title = "different field rotation step freqencies \phi";
legendUnits = " (Hz)";
fileName = "CDistandTime.mat";
startFrom = 1;

load(fileName,"allDists","allTimes","allFileValues","allPix","allwPix","allMPix","allMwPix","allRadius");

AvgDiffSpread = [];
StandardDeviation = [];

for(i = startFrom:size(allDists,1))
    maxX = 0;
    numPoints = 1000; % Whatever resolution you want.
    xCommon = linspace(0, 100, numPoints);
    yVals = [];

    for(j = 1:size(allDists,2))
        allTimeValues = cell2mat(allTimes(i,j));
        if(maxX< max(allTimeValues))
            maxX = max(allTimeValues);
        end
    end
    lineAverage = [];

    for(j = 1:size(allDists,2))
        allTimeValues = cell2mat(allTimes(i,j));
        allMwPixValues = cell2mat(allMwPix(i,j));
        allMPixValue = cell2mat(allMPix(i,j));
        
        yVals(j,:) = interp1(allTimeValues, allMwPixValues./allMPixValue, xCommon);  %For spread
    end

    avgVal = mean(yVals,1);
    stdVal = std(yVals,1,1);
    xCommon(isnan(avgVal)) = [];
    stdVal(isnan(avgVal)) = [];
    avgVal(isnan(avgVal)) = [];

   %Find last high number, or use 1 second for time being?
    EndTime = 1;
    %Average over how many points previous to EndTime (To help with noise)?
    %Must be 1 or greater
    AverageOver = 3;

    %Find the index we want to end on
    EndIndexes = xCommon( 1:find( xCommon > EndTime, 1 ) );
    if(size(EndIndexes)<= AverageOver)
        warning("Not enough data to average over the last "+AverageOver+" values");
    end
    EndIndexes = [size(EndIndexes,2) - AverageOver + 1 : size(EndIndexes,2)];
    
    %Average and Standard Deviation over the last few
    AvgDiffSpread(end+1) = (mean(avgVal(EndIndexes)) ./ avgVal(1));
    StandardDeviation(end+1) = sum(stdVal(EndIndexes))./size(EndIndexes,2).*100; % Just average the standard deviation as sample size is the same... Not ideal.

end

%Plot only start/end comparison
XValues = sort(allFileValues);
Title = "Normalised increase in swarm spread for " + Title;
YLIMS = [0.01,0.2];
avgLine = plot(XValues(startFrom:length(XValues)), AvgDiffSpread);
patchLine = patch([XValues(startFrom:length(XValues)) fliplr(XValues(startFrom:length(XValues)))], [(AvgDiffSpread + StandardDeviation) fliplr((AvgDiffSpread - StandardDeviation))],avgLine.Color, 'FaceAlpha', .3 ,'LineStyle','none');
ylabel("Normalised increase in swarm spread in multiples of original spread")
xlabel("Rotation Frequency (Hz)")
% legendNames = string(XValues(startFrom:length(XValues))) + legendUnits;
% legendNamesdupe = sort([legendNames insertAfter(legendNames,1," STD")]);
% legend(legendNamesdupe)
title(Title)
hold on
%ylim(YLIMS)
   
Title = erase(erase(Title," "),"\")
savefig(Title+".fig")