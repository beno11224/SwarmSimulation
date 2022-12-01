function DrawInputAngle(particlePaths, stopDrawAtGoal, drawCorrectOutlet, drawIncorrectOutlet, drawIncomplete)

    if ~exist('particlePaths','var')
     % parameter does not exist, so default it to something
      ReadAllResults();
    end
    if ~exist('stopDrawAtGoal','var')
      drawIncomplete = 1;
    end
    if ~exist('drawCorrectOutlet','var')
      drawIncomplete = 1;
    end
    if ~exist('drawIncorrectOutlet','var')
      drawIncomplete = 1;
    end
    if ~exist('drawIncomplete','var')
      drawIncomplete = 1;
    end

    plotGraph = figure;
    axGraph = axes('Parent',plotGraph);
    hold on
   % avgMagnitude = 0;
    for(pIndex = 1:length(particlePaths))
        if(~ particlePaths(pIndex).ValidRun)
            continue;
        end
        if(drawCorrectOutlet && particlePaths(pIndex).CorrectOutlet) || (drawIncorrectOutlet && ~particlePaths(pIndex).CorrectOutlet)
            try
                timeLimit = str2double(cell2mat(particlePaths(pIndex).GoalTime));
            catch
                if(drawIncomplete)
                    timeLimit = 0;
                else
                    break;
                end
            end
            angleSum = 0;
           % magnitudeSum = 0;
            timeStepCount = 1;
            for timeStepCount = 1:size(particlePaths(pIndex).InputForces,1)
                if(stopDrawAtGoal && timeLimit < str2double(cell2mat(particlePaths(pIndex).TimeSteps(timeStepCount))))
                    break;
                end
                %https://uk.mathworks.com/matlabcentral/answers/180131-how-can-i-find-the-angle-between-two-vectors-including-directional-information
                aa = str2num(cell2mat(particlePaths(pIndex).InputForces(timeStepCount,:)));
                thisAngle = atan2d(aa(2),aa(1));
                angleSum = angleSum + thisAngle;
            end
            avgAngle(pIndex) = angleSum / timeStepCount;
            scores(pIndex) = str2double(cell2mat(particlePaths(pIndex).overallPercentage));
        end
    end
    plot(axGraph,avgAngle,scores,'r.', 'markerSize', 5);
end

