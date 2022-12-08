function DrawHeatMapFromParticlePath(particlePaths, stopDrawAtGoal, drawCorrectOutlet, drawIncorrectOutlet, drawIncomplete)

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

    polygon = Polygons(0.0096);
    polygon = polygon.change(2);
    tr = triangulation(polyshape(polygon.currentPoly(:,1),polygon.currentPoly(:,2)));
    model = createpde(1);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    model.geometryFromMesh(tnodes, telements);
  %  mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
    mesh = generateMesh(model, 'Hmax', 0.00075);%was 0.000073 for old one.
    meshValues = zeros([size(mesh.Nodes,2),1]);
    plotMesh = figure;
    axMesh = axes('Parent',plotMesh);
    hold on
    polyLineMesh = plot(axMesh,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
    endLineMesh = plot(axMesh,polygon.currentEndZone(1,:,1),polygon.currentEndZone(1,:,2), 'Color','g');

    for(fileIndex = 1:size(particlePaths,1))
        for(pIndex = 1:size(particlePaths,2))
            if(~ particlePaths(fileIndex,pIndex).ValidRun)
                continue;
            end
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


