function DrawMeanParticlePath(particlePaths, stopDrawAtGoal, drawCorrectOutlet, drawIncorrectOutlet, drawIncomplete)
    addpath 'E:\SwarmSimulation'

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
    mesh = generateMesh(model, 'Hmax', 0.0005);%was 0.000073 for old one.
    meshValues = zeros([size(mesh.Nodes,2),1]);
    plotMesh = figure;
    axMesh = axes('Parent',plotMesh);
    hold on
    polyLineMesh = plot(axMesh,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
    endLineMesh = plot(axMesh,polygon.currentEndZone(1,:,1),polygon.currentEndZone(1,:,2), 'Color','g');

    DataAtTimeStep = [];
    ZSum = [];

    totalFileCount = 0;

    for(fileIndex = 1:size(particlePaths,1))
        for(pIndex = 1:size(particlePaths,2))
            if(~ particlePaths(fileIndex,pIndex).ValidRun)
                continue;
            end
            if(drawCorrectOutlet && particlePaths(fileIndex,pIndex).CorrectOutlet) || (drawIncorrectOutlet && ~particlePaths(fileIndex,pIndex).CorrectOutlet)
                totalFileCount = totalFileCount + 1;
                try
                    timeLimit = particlePaths(fileIndex,pIndex).GoalTime;
                catch
                    if(drawIncomplete)
                        timeLimit = 0;
                    else
                        break;
                    end
                end
                doForce = ~exist("ForceAngle");
                for(timeStepCount = 1: size(particlePaths(fileIndex,pIndex).Locations,2))                    
                    if(doForce)
                        forceAngle(timeStepCount,:) = particlePaths(fileIndex,pIndex).InputForces(timeStepCount,:);
                    end
                    if(stopDrawAtGoal && timeLimit < particlePaths(fileIndex,pIndex).TimeSteps(timeStepCount))
                        %break;
                        locationDataByTimeStepX(pIndex,timeStepCount) = NaN;
                        locationDataByTimeStepY(pIndex,timeStepCount) = NaN;
                      %  tempDataAtTimeStep(timeStepCount,:) = NaN;
                      if(doForce)
                          forceAngle(timeStepCount,:) = [NaN NaN];
                      end
                    end
                    locationDataByTimeStepX(pIndex,timeStepCount) = particlePaths(fileIndex,pIndex).Locations(1,timeStepCount);
                    locationDataByTimeStepY(pIndex,timeStepCount) = particlePaths(fileIndex,pIndex).Locations(2,timeStepCount);
                   % tempDataAtTimeStep(timeStepCount,:) = particlePaths(fileIndex,pIndex).Locations(:,timeStepCount);
                end
            end
        end
        %Averages for file:
    %    plot(locationDataByTimeStepX(10,:),locationDataByTimeStepY(10,:));
        avgLocationsX = mean(locationDataByTimeStepX,'omitnan');
        avgLocationsY = mean(locationDataByTimeStepY,'omitnan');
        avgLocations = [avgLocationsX;avgLocationsY]';
        forceAngleAtTimeStep = atan2d(forceAngle(:,2),forceAngle(:,1));%forceAngle;
        %plot(1:170,forceAngleAtTimeStep);
      %  plot(avgLocationsX,avgLocationsY);
       % plot(forceAtTimeStep(:,1),forceAtTimeStep(:,2))
        ZPlot = zeros(200);
        for(TimeStepCount = 1:size(avgLocations,1))
         %   ab = avgLocations(TimeStepCount,:);
         %   abc = size(ZPlot)./2 .* 100;
         %   abcd = (avgLocations(TimeStepCount,:) + 0.01) .* size(ZPlot)./2 .* 100;
            index = (round((avgLocations(TimeStepCount,:) + 0.01) .* size(ZPlot)./2 .* 100));
            if(isnan(ZPlot(index(1),index(2))))
                ZPlot(index(1),index(2)) = 0;
            end
           % ZPlot(index(1),index(2)) = %ZPlot(index(1),index(2)) + 1;
           ZPlot(index(1),index(2)) = forceAngleAtTimeStep(TimeStepCount);
        end
        %ZPlot (round(avgLocations + 0.01 * size(ZPlot/2 * 100))) = 100;
    %    ZSum(fileIndex,:,:) = imgaussfilt(ZPlot,2);
        ZSum(fileIndex,:,:) = ZPlot;

       % XYValues = size(ZPlot).*2 ./ 100 - 0.01;


  %      try
  %          DataAtTimeStep(fileIndex,:,:) = tempDataAtTimeStep;
  %      catch
  %          %data is probably wrong size, make it smaller/bigger.
  %          DataAtTimeStep(fileIndex,:,:) = NaN;
  %          DataAtTimeStep(fileIndex,1:size(tempDataAtTimeStep,1),1:size(tempDataAtTimeStep,2)) = tempDataAtTimeStep;
  %      end
        clear forceAngle;
    end


    XYIndexes = linspace(-0.01,0.01,size(ZSum,2));
    ZSum(ZSum == 0) = NaN;
    ZSum = ZSum ./ totalFileCount;
    ZSum = squeeze(sum(ZSum));

    s = surf(XYIndexes,XYIndexes,ZSum','FaceAlpha',0.5);%,colormap,'turbo');
    s.EdgeColor = 'none';
    colorbar;

    kMeansDataAtTimeStep = [];
    for (timeStep = 1:size(DataAtTimeStep,2))
        % https://uk.mathworks.com/matlabcentral/answers/18365-kernel-density-for-2d-data
        xData = squeeze(DataAtTimeStep(:,timeStep,1)) .* -1;
        yData = squeeze(DataAtTimeStep(:,timeStep,2)) .* -1;
        %abx = fitdist(xData,'Kernel','Width',4);
        %aby = fitdist(yData,'Kernel','Width',4);
        figure
        [f,xi] = ksdensity([xData,yData]);
        mesh(xi,f);
    %    [g, xj] = ksdensity(yData);

        %plot(xi,f);
     %   plot(xj,g);

       % f = mvksdensity(xData,yData)


        %[abvb,C] = kmeans(squeeze(DataAtTimeStep(:,timeStep,:)),4);
        %if(timeStep > 1)
        %    for i = 1:4
        %        for j = 1:4
        %           % aasgfa = squeeze(kMeansDataAtTimeStep(i,timeStep-1,:));
        %           % aasjgdb = C(j,:);
        %           % asdg = aasgfa - aasjgdb;
        %            closestmatrix(i,j) = norm(squeeze(kMeansDataAtTimeStep(i,timeStep-1,:)) - C(j,:));
        %        end
        %    end
        %    [amin,loc] = min(closestmatrix);
        %end
        kMeansDataAtTimeStep(:,timeStep,:) = C;
        
        %try to order KMeans??
        %Find closest one from last

    end
    plot(axMesh,kMeansDataAtTimeStep(1,:,1),kMeansDataAtTimeStep(1,:,2));
end


