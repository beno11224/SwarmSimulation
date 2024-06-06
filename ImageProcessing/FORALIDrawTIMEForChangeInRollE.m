close all
clear all

%For calculating how far the swarm moved
circleRadius = 262;
mmPerPixel = 10/(circleRadius*2);

Title = "different field roll angles";
legendUnits = " ("+char(176)+")";
fileName = "EDistandTime.mat";
startFrom = 1;

load(fileName,"allDists","allTimes","allFileValues","allPix","allwPix","allMPix","allMwPix","allRadius");

AvgPositiveVelocity = [];
PeakVelocity = [];
StandardStandardDeviation = []; %???
peakSTD = [];

%Loop over each trace
    %Loop over three runs
        %This velocity is (currentDist-lastDist)/(timeNow-timeLast)
        %Add this velocity to list.
        %If time>1 (?) then skip out -- 1 second is not right - needs to be once they reach a location threshold
%Interpolate to same x values
%Find Averages and STD...

numPoints = 1000; % Whatever resolution you want.
xCommon = linspace(0, 100, numPoints);
for(i = startFrom:size(allDists,1))
    velocities = [];
    for(j = 1:size(allDists,2))
        allDistValues = cell2mat(allDists(i,j));
        allTimeValues = cell2mat(allTimes(i,j));
        if(all(isnan(allDistValues)))
            warning("nan value at: "+string(i)+string(j))
            continue
        end

        reachedLimit = false;
        for(k = 1:size(allDistValues,2))
            if(reachedLimit)
                allDistValues(k) = NaN;
            end
            if(allDistValues(k)>(2/mmPerPixel)) %3mm limit
                reachedLimit = true;
            end
        end
        plot(allTimeValues(2:end),allDistValues(2:end))
        ylim([0,(2/mmPerPixel)])
        ylabel("DistanceTravelled(Pixels)")
        xlabel("TimeSinceStart(S)")
        pause(0.1)
        DistCovered = (allDistValues(2:end) - allDistValues(1:end-1)) .* mmPerPixel;
        TimeTaken = allTimeValues(2:end) - allTimeValues(1:end-1);
        % timesUsed(j,:) = allTimeValues(2:end);
        % Velocities(j,:) = DistCovered./TimeTaken;
        velocities(j,:) = interp1(allTimeValues(2:end), DistCovered./TimeTaken, xCommon); %For Distance 
    end
    velocities(velocities < 0.01) = NaN;
    avgVal = mean(velocities,1,"omitnan");
    stdVal = std(velocities,1,1,"omitnan");
    xCommon(isnan(avgVal)) =  NaN;
    stdVal(isnan(avgVal)) =  NaN;
   % avgVal(isnan(avgVal)) = [];
    %xCommon(avgVal<=0) = 0;
    stdVal(avgVal<=0) = NaN;
    avgVal(avgVal<=0) = NaN;
    if(isempty(avgVal))
        avgVal = 0;
        stdVal = 0;
        xCommon = 0;
    end
    % plot(xCommon,avgVal,'rx',LineStyle="none")
    AvgPositiveVelocity(end+1) = mean(avgVal,"omitnan");
    PeakVelocity(end+1) = max(avgVal);
    StandardStandardDeviation(end+1) = std(stdVal,"omitnan");
    if(all(isnan(avgVal)))
        peakSTD(end+1) = NaN;
    else
        peakSTD(end+1) = stdVal(avgVal == max(avgVal));
    end
end
%plot(startFrom:size(allDists,1),PeakVelocity)
%legend(["avg","peak"])

XValues = sort(allFileValues);
Title = "Average velocity of swarm centroid for " + Title;
errorbar(XValues(startFrom:length(XValues)),AvgPositiveVelocity,StandardStandardDeviation,'x',LineStyle='none')
ylabel("Average swarm centroid velocity (mm/s)")
xlabel("Roll ("+char(176)+")");
%legend(legendNames)
title(Title)
hold on

Title = erase(erase(Title," "),"\")
savefig(Title+".fig")