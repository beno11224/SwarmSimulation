close all

%For calculating how far the swarm moved
circleRadius = 262;
mmPerPixel = 10/(circleRadius*2);

Title = "different field roll angles";
legendUnits = " ("+char(176)+")";
fileName = "EDistandTime.mat";
startFrom = 1;

load(fileName,"allDists","allTimes","allFileValues","allPix","allwPix","allMPix","allMwPix","allRadius");

AvgDistance = [];
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
        allDistValues = cell2mat(allDists(i,j));
        allTimeValues = cell2mat(allTimes(i,j));

        allTimeValues(isnan(allDistValues)) = [];
        allDistValues(isnan(allDistValues)) = [];      

        if(size(allTimeValues)>0)
            yVals(j,:) = interp1(allTimeValues, allDistValues, xCommon); %For Distance 
        end
        
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
    
    if(size(EndIndexes) > 0 & size(avgVal) > 0)
        AvgDistance(end+1) = mean(avgVal(EndIndexes));        
    else
        AvgDistance(end+1) = NaN;
    end
    
end

XValues = sort(allFileValues);
Title = "Distance travelled by swarm in one second for " + Title;
plot(XValues(startFrom:length(XValues)),(AvgDistance)*mmPerPixel);
ylabel("Distance travelled from original location (mm)")
xlabel("Roll ("+char(176)+")");
%legend(legendNames)
title(Title)
hold on

Title = erase(erase(Title," "),"\")
savefig(Title+".fig")