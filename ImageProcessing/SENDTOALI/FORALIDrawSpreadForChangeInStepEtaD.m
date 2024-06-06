close all
clear all

%For calculating how far the swarm moved
circleRadius = 262;
mmPerPixel = 10/(circleRadius*2);

Title = "different field rotation step angles \eta";
legendUnits = " ("+char(176)+")";
fileName = "DDistandTime.mat";
startFrom = 1;

load(fileName,"allDists","allTimes","allFileValues","allPix","allwPix","allMPix","allMwPix","allRadius");

AvgDiffSpread = [];
StandardDeviation = [];
MeanStandardDeviation = [];

for(i = startFrom:size(allDists,1))
    numPoints = 1000; % Whatever resolution you want.
    xCommon = linspace(0, 100, numPoints);
    yVals = [];
    xVals = [];
    lineAverage = [];


    %iterate over 3 identical traces
    for(j = 1:size(allDists,2))
        sensibleStartIndex = -1;
        allTimeValues = cell2mat(allTimes(i,j));
        allMwPixValues = cell2mat(allMwPix(i,j));
        allMPixValue = cell2mat(allMPix(i,j));

        %remove duplicate numbers (How did they get there?)
        uvec = true(size(allTimeValues));
        [bs, vec] = sort(allTimeValues(:).');
        uvec(vec) = [true, diff(bs) ~= 0];
        CORRECTallTimeValues = allTimeValues(uvec);
        CORRECTallMwPixValues = allMwPixValues(uvec);
        CORRECTallMPixValue = allMPixValue(uvec);

        sumVals = CORRECTallMwPixValues./CORRECTallMPixValue;
        for(k =1:size(sumVals,2))
            if((sumVals(k) < 0.75) & (sumVals(k) > 0.05)) & sensibleStartIndex == -1 %-----------------This line is important - limits data being shown - high value limits all white images, low value limits all black images. Threshold chosen to produce a reasonable result, but throwing a lot of data here.
                sensibleStartIndex = k;
                break;
            end
        end

        if(sensibleStartIndex == -1 || sensibleStartIndex+1 >= size(CORRECTallTimeValues,2))
            warning("Couldn't find a sensible starting index to compare to");
            continue;
        end

        CORRECTallTimeValues(1:sensibleStartIndex-1) = [];
        CORRECTallMwPixValues(1:sensibleStartIndex-1) = [];
        CORRECTallMPixValue(1:sensibleStartIndex-1) = [];
        
        yVals(j,:) = interp1(CORRECTallTimeValues, CORRECTallMwPixValues./CORRECTallMPixValue, xCommon);  %For spread
        plot(xCommon,yVals); %------------------------------This graph is for debugging and deciding the limit values above
        pause(0.2);
    end

    if(size(yVals) == 0)
        warning("No sensible start state for " + string(i));
        startFrom = startFrom + 1;
        continue;
    end

    %Clean the data
    xTwo = xCommon;
    avgVal = mean(yVals,1,'omitnan');
    stdVal = std(yVals,1,1,'omitnan');
    xTwo(isnan(avgVal)) = [];
    stdVal(isnan(avgVal)) = [];
    avgVal(isnan(avgVal)) = [];
    xTwo(avgVal == 0) = [];
    stdVal(avgVal == 0) = [];
    avgVal(avgVal == 0) = [];


    %Ignore '1 second', just take the last few points.
    %Average over how many points previous to Final Shown Time (To help with noise)?
    %Must be 1 or greater
    AverageOver = 3;
    if(AverageOver > size(avgVal,2))
        if(size(avgVal,2) == 1)
            warning("not enough data here");
            continue;
        end
        AverageOver = size(avgVal,2) - 1;
    end

    %Find the indexes we want to end on
    EndIndexes = [size(avgVal,2) - AverageOver + 1 : size(avgVal,2)];
    
    %Average and Standard Deviation over the last few
    AvgDiffSpread(end+1) = mean(avgVal(EndIndexes),'omitnan') ./ avgVal(1);
    StandardDeviation(end+1) = std(stdVal(EndIndexes),'omitnan') ./ avgVal(1); % Just average the standard deviation as sample size is the same... Not ideal.
    MeanStandardDeviation(end+1) = mean(stdVal(EndIndexes),'omitnan')./avgVal(1); %This is also not great, but produces a more reasonable uncertainty

end

%Plot only start/end comparison
XValues = sort(allFileValues);
Title = "Normalised increase in swarm spread for " + Title;
errorbar(XValues(startFrom:length(XValues)),AvgDiffSpread,MeanStandardDeviation,'x',LineStyle='none')
%avgLine = plot(XValues(startFrom:length(XValues)), AvgDiffSpread);
%patchLine = patch([XValues(startFrom:length(XValues)) fliplr(XValues(startFrom:length(XValues)))], [(AvgDiffSpread + StandardDeviation) fliplr((AvgDiffSpread - StandardDeviation))],avgLine.Color, 'FaceAlpha', .3 ,'LineStyle','none');
ylabel("Normalised increase in swarm spread (multiples of original spread)")
xlabel("Field Rotation Step ("+char(176)+")");
title(Title)
hold on
   
Title = erase(erase(Title," "),"\")
savefig(Title+".fig")