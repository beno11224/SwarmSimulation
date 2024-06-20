function GraphInputAngles()

    close all
    matFileData = matfile("storedAllDataVariables.mat");
    IMPORTEDexpertStates = matFileData.IMPORTEDexpertStates;
    IMPORTEDexpertActions = matFileData.IMPORTEDexpertActions;
    IMPORTEDFILEDELIMITERS = matFileData.IMPORTEDFILEDELIMITERS;
    IMPORTEDLastPercentages = matFileData.IMPORTEDLastPercentages;

    fig1 = figure;
    ax1 = axes(fig1);
    DelimSum = 0;
    legStrings = {};
    xlabel("time(s)")
    ylabel("anti-clockwise angle from positive x axis (deg)")
    for(traceCount = 1: size(IMPORTEDLastPercentages,2))
        if(IMPORTEDLastPercentages(traceCount) > 0.99)
            xvals = IMPORTEDexpertActions(DelimSum+1 : DelimSum + IMPORTEDFILEDELIMITERS(traceCount),1);
            yvals = IMPORTEDexpertActions(DelimSum+1 : DelimSum + IMPORTEDFILEDELIMITERS(traceCount),2);
            atanvals = atan2d(yvals,xvals);
            %atanvals(atanvals < 0) = atanvals(atanvals < 0);% + 360;
            xs = 0.05:0.05:0.05*size(atanvals,1);
            plot(ax1, xs, atanvals);
            hold on
            legStrings{end+1} = string(IMPORTEDLastPercentages(traceCount));
        end
        DelimSum = DelimSum + IMPORTEDFILEDELIMITERS(traceCount);
    end
    legend(legStrings)
return

%pp = ReadAllResults(true); - read the sorted data (one folder at a time)
%DrawHeatMapFromParticlePath(pp,true,true,false,false) - does one
%participant, one flow value

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

   polygon = Polygons(0.0096,FlowData60());
   polygon = polygon.change(4,FlowData60());
    tr = triangulation(polyshape(polygon.currentPoly(:,1),polygon.currentPoly(:,2)));
     model = createpde(1);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    model.geometryFromMesh(tnodes, telements);
  %  mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
    mesh = generateMesh(model, 'Hmax', 0.00075);%was 0.000073 for old one.
     meshValues = zeros([size(mesh.Nodes,2),1]);

    correctFlowLocation = 4;
%     polygon = Polygons(0.0096,FlowData60());
%     polygon = polygon.change(correctFlowLocation,FlowData60());
%     mesh = delaunayTriangulation(polygon.currentFlowLocations);
%     meshValues = zeros([size(mesh.Points,1),1]);
    plotMesh = figure;
    axMesh = axes('Parent',plotMesh);
    hold on
    polyLineMesh = plot(axMesh,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
    endLineMesh = plot(axMesh,polygon.currentEndZone(correctFlowLocation,:,1),polygon.currentEndZone(correctFlowLocation,:,2), 'Color','g');

    for(fileIndex = 1:size(particlePaths,1))
        for(pIndex = 1:size(particlePaths,2))
            % if(~ particlePaths(fileIndex,pIndex).ValidRun || particlePaths(fileIndex,pIndex).overallPercentage < 50)
            %     continue;
            % end
            if(drawCorrectOutlet && particlePaths(fileIndex,pIndex).CorrectOutlet) || (drawIncorrectOutlet && ~particlePaths(fileIndex,pIndex).CorrectOutlet)
                try
                    timeLimit = particlePaths(fileIndex,pIndex).GoalTime;
                catch
                    if(drawIncomplete)
                        timeLimit = 0;
                    else
                        break;
                    end
                end
                for(timeStepCount = 1: size(particlePaths(fileIndex,pIndex).Locations,2))
                    %a = str2double(cell2mat(particlePaths(pIndex).TimeSteps(timeStepCount)));
                    if(stopDrawAtGoal && timeLimit < particlePaths(fileIndex,pIndex).TimeSteps(timeStepCount))
                        break;
                    end
                    %closestNode = findNodes(mesh, 'nearest', particlePaths(pIndex).Locations(lineCount,:)');
                %    aafb = particlePaths(pIndex).Locations(:,timeStepCount);
                    closestNode = findNodes(mesh, 'nearest', particlePaths(fileIndex,pIndex).Locations(:,timeStepCount));
%                     closestNode = nearestNeighbor(mesh,particlePaths(fileIndex,pIndex).Locations(:,timeStepCount)');
                    meshValues(closestNode) = meshValues(closestNode) + 1;
                end
            end
        end
    end
    
    meshValues = meshValues ./ quantile(meshValues,0.9); %between 0 and 1
    meshValues(meshValues > 1) = 1; %limit extremes
    m = pdeplot(model, "XYData",meshValues, 'ColorMap', 'jet');

 %   useFile = input("Press any key to exit","s")
 %   close all; %commented out to not close...
end


