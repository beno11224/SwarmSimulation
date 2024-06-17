function DrawInputAngle(particlePaths, stopDrawAtGoal, drawCorrectOutlet, drawIncorrectOutlet, drawIncomplete)

    if ~exist('particlePaths','var')
     % parameter does not exist, so default it to something
      particlePaths = ReadAllResults();
    end
    if ~exist('stopDrawAtGoal','var')
      stopDrawAtGoal = 1;
    end
    if ~exist('drawCorrectOutlet','var')
      drawCorrectOutlet = 1;
    end
    if ~exist('drawIncorrectOutlet','var')
      drawIncorrectOutlet = 1;
    end
    if ~exist('drawIncomplete','var')
      drawIncomplete = 1;
    end

    plotGraph = figure;
    axGraph = axes('Parent',plotGraph);
    hold on
   % avgMagnitude = 0;
    for(fileIndex = 1:size(particlePaths,1))
        quickestIndex = 1;
        quickestTime = particlePaths(fileIndex,1).GoalTime;
        for(pIndex = 2:size(particlePaths,2))
            if((drawCorrectOutlet && particlePaths(fileIndex,pIndex).CorrectOutlet || (drawIncorrectOutlet && ~particlePaths(pIndex).CorrectOutlet)) && particlePaths(fileIndex,pIndex).GoalTime < quickestTime)
                quickestIndex = pIndex;
                quickestTime = particlePaths(fileIndex,pIndex).GoalTime;
            end
        end
        if(~drawIncomplete && quickestTime == 0)
            continue;
        end
       % if(~ particlePaths(pIndex).ValidRun)   %if something goes wrong try this
       %     continue;
       % end
  %      if(drawCorrectOutlet && particlePaths(pIndex).CorrectOutlet) || (drawIncorrectOutlet && ~particlePaths(pIndex).CorrectOutlet)
  %          try
  %              timeLimit = str2double(cell2mat(particlePaths(pIndex).GoalTime));
  %          catch
  %              if(drawIncomplete)
  %                  timeLimit = 0; %Above may fail, use this.
  %              else
  %                  break;
  %              end
  %          end
        angleSum = 0;
       % magnitudeSum = 0;
        timeStepCount = 1;
        angleArr = [];
        for timeStepCount = 1:size(particlePaths(fileIndex,quickestIndex).InputForces,1)
            if(stopDrawAtGoal && quickestTime < particlePaths(fileIndex,quickestIndex).TimeSteps(timeStepCount))
                break;
            end
            %https://uk.mathworks.com/matlabcentral/answers/180131-how-can-i-find-the-angle-between-two-vectors-including-directional-information
            aa = particlePaths(fileIndex,quickestIndex).InputForces(timeStepCount,:);
            angleArr(timeStepCount) = atan2d(aa(2),aa(1));
            angleSum = angleSum + angleArr(timeStepCount);
        end
        avgAngle(fileIndex) = angleSum / timeStepCount;
        
        %Now to get the variance...
        stdErr(fileIndex) = std(angleArr)/sqrt(length(angleArr));
        scores(fileIndex) = particlePaths(fileIndex,quickestIndex).overallPercentage;
    end
    if(~exist("avgAngle"))
        fprintf("No data to show")
    else
        %plot(axGraph,avgAngle,scores,'r.', 'markerSize', 5);
        errorbar(axGraph,avgAngle,scores,stdErr,'horizontal','.', 'markerSize', 10,"MarkerEdgeColor","red","Color",[0.65 0.55 0.45]);
        axGraph.XLim = [-180,180];
     %   axGraph.XLabel = "Average angle from the positive X axis (deg)";
     %   axGraph.YLabel = "Percentage of particles that reached the goal";
    end
end

