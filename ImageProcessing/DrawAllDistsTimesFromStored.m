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


load(fileName,"allDists","allTimes","allFileValues","allPix","allwPix","allMPix","allMwPix","allRadius");

legendNames = string(sort(allFileValues)) + legendUnits;
ab = size(allTimes);
for(i = startFrom:size(allDists,1))
    maxX = 0;
    numPoints = 1000; % Whatever resolution you want.
    xCommon = linspace(0, 100, numPoints);
    yVals = [];
    circleRadius = 0;

    for(j = 1:size(allDists,2))
        allTimeValues = cell2mat(allTimes(i,j));
        if(maxX< max(allTimeValues))
            maxX = max(allTimeValues);
        end
    end

    circleRadius = 262;
    mmPerPixel = 10/(circleRadius*2);
    lineAverage = [];

    for(j = 1:size(allDists,2))
        allDistValues = cell2mat(allDists(i,j));
        allTimeValues = cell2mat(allTimes(i,j));
        allPixValues = cell2mat(allPix(i,j));
        allwPixValues = cell2mat(allwPix(i,j));
        allMwPixValues = cell2mat(allMwPix(i,j));
        allMPixValue = cell2mat(allMPix(i,j));
        
        % yVals(j,:) = interp1(allTimeValues, allDistValues, xCommon); %For Distance 
        yVals(j,:) = interp1(allTimeValues, allMwPixValues./allMPixValue, xCommon);  %For spread
    end

    avgVal = mean(yVals,1);
    stdVal = std(yVals,1,1);
    xCommon(isnan(avgVal)) = [];
    stdVal(isnan(avgVal)) = [];
    avgVal(isnan(avgVal)) = [];

    %Plot only start/end comparison
    if(true)
    end

    %Plot Whole data
    %Plot Distance
    if(false)
        Title = "Distance travelled by swarm for " + Title;
        YLIMS = [0,5];
        plot(xCommon,(avgVal)*mmPerPixel);
        ylabel("Distance travelled from original location (mm)")
        xlabel("Time(s)") %No...
        legend(legendNames)
        title(Title)
        hold on
        ylim(YLIMS)
    end
    %Plot Relative Density (Image proportion)
    if(true)
        Title = "Swarm area spread in ratio of pixels for " + Title;
        YLIMS = [0.01,0.2];
        avgLine = plot(xCommon,avgVal);
        patchLine = patch([xCommon fliplr(xCommon)], [(avgVal + stdVal) fliplr((avgVal - stdVal))],avgLine.Color, 'FaceAlpha', .3 ,'LineStyle','none');
        ylabel("Relative change in particle spread when measured as a ratio in pixels")
        xlabel("Time(s)")
        legendNamesdupe = sort([legendNames(startFrom:size(allDists,1)) (insertAfter(legendNames(startFrom:size(allDists,1)),1," STD"))]);
        legend(legendNamesdupe)
        title(Title)
        hold on
        ylim(YLIMS)
    end
end
Title = erase(erase(Title," "),"\")
savefig(Title+".fig")