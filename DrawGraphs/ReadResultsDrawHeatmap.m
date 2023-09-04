function ReadResultsDrawHeatmap(polygon)
    folderPath = uigetdir();
    allFiles = dir(fullfile(folderPath, '*.csv'));
    inputReadAll = input("Show Only results from all files? This may cause errors if files are not sanitized","s")
    readAllFiles = (inputReadAll == "y" || inputReadAll == "Y" || inputReadAll == "yes" || inputReadAll == "Yes");
   

    tr = triangulation(polyshape(polygon.currentPoly(:,1),polygon.currentPoly(:,2)));
    model = createpde(1);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    model.geometryFromMesh(tnodes, telements);
    mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
              %  closestNode = findNodes(mesh, 'nearest', particleLocation');
              %  velocity(:,1) = flowMatrix(closestNode,1);
              %  velocity(:,2) = flowMatrix(closestNode,2);
    meshValues = zeros([size(mesh.Nodes,2),1]);
    plotMesh = figure;
    axMesh = axes('Parent',plotMesh);
    hold on
    polyLineMesh = plot(axMesh,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
    endLineMesh = plot(axMesh,polygon.currentEndZone(1,:,1),polygon.currentEndZone(1,:,2), 'Color','g');


        %if statement for printing centre mass of particles - TODO must modify
    %  if(app.CentreMassViewCheckBox.Value)
    %      avgLocation = sum(app.particleArrayLocation) ./ size(app.particleArrayLocation,1);
    %      absoluteDeviation = abs(app.particleArrayLocation - avgLocation);
    %      MAD = sum(absoluteDeviation) ./ size(app.particleArrayLocation,1);
    %      app.particlePoints = errorbar(app.UIAxes, avgLocation(1), avgLocation(2), MAD(1), MAD(1), MAD(2), MAD(2) ,'r.', 'markerSize', 18);
    %  else

    for fileIndex = 1:length(allFiles)
        
        useFile = 'y';
        if(~readAllFiles)
            allFiles(fileIndex).name
            useFile = input("Read This File?","s")
            plot1 = figure;
        end
        if(useFile == "y" || useFile == "Y" || useFile == "yes" || useFile == "Yes")
            %Now Do Stuff!

            if(~readAllFiles)
                close(plot1);
                plot1 = figure;
                ax1 = axes('Parent',plot1);
                hold on;
            end

            fid = fopen(folderPath + "\" + allFiles(fileIndex).name);
            lines = {}; %remove this?
            tline = fgetl(fid);
            if(tline == -1)
                "Nothing in the File"
                continue;
            end

                if(~readAllFiles)
                    polyLine = plot(ax1,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
                    endLine = plot(ax1,polygon.currentEndZone(1,:,1),polygon.currentEndZone(1,:,2), 'Color','g');
                end
            tidiedPositions = [];
            times = [];
            while ischar(tline)
                %TODO port this into Python - this is the reading bit
               datas = split(tline,',');
               time = datas(1);
               magForce = datas(2);
               goalPercentage = datas(3);
               velocities = datas(4);
               positions = datas(5);

               positions = strip(positions,'[');
               positions = strip(positions,']');
               allVelocities = split(positions,';');
               pagePositions = [];
               times = [times; time];
               for(lineIndex = 1:length(allVelocities))
                   xAndYVelocities = split(allVelocities(lineIndex),' ');
                   a = [str2double(xAndYVelocities(1)), str2double(xAndYVelocities(2))];
                   pagePositions = [pagePositions; [str2double(xAndYVelocities(1)), str2double(xAndYVelocities(2))]];
               end
               tidiedPositions = cat(3,tidiedPositions, pagePositions);
               tline = fgetl(fid);    
            end

            for(lineCount = 1: size(tidiedPositions,1))
                if(~readAllFiles)
                    plot(ax1, squeeze(tidiedPositions(lineCount,1,:)), squeeze(tidiedPositions(lineCount,2,:)),'-', 'markerSize', 1);
                end
            %    a = squeeze(tidiedPositions(lineCount,:,:))
                for(locationIndex = 1:size(squeeze(tidiedPositions(lineCount,:,:)),2))
                    %ab = tidiedPositions(locationIndex,:)'
                  %  ac = squeeze(tidiedPositions(lineCount,:,locationIndex))
                    closestNode = findNodes(mesh, 'nearest', squeeze(tidiedPositions(lineCount,:,locationIndex))');
                    meshValues(closestNode) = meshValues(closestNode) + 1;
                end
            end
            pause(0.1);
            fclose(fid);

        end
    end
    meshValues = meshValues ./ quantile(meshValues,0.9); %between 0 and 1
    meshValues(meshValues > 1) = 1; %limit extremes
    alpha = meshValues;
  %  MESHVALUES = repmat(meshValues,1,length(mesh.Nodes(1,:))) ;
    %alpha(alpha < 0.5) = 0.5; %lower bound the alpha
  %  scatter(axMesh,mesh.Nodes(1,:), mesh.Nodes(2,:),50, meshValues','filled');%, 'AlphaData', alpha, MarkerFaceAlpha='flat')
   % m = surf(mesh.Nodes(1,:), mesh.Nodes(2,:)', meshValues)
   % m = surf(mesh.Nodes(1,:), mesh.Nodes(2,:), MESHVALUES);
   % m = patch(mesh.Nodes, meshValues, 'FaceColor', 'interp');
  % m = patch('XData',mesh.Nodes(1,:), 'YData', mesh.Nodes(2,:), 'ZData', meshValues', 'FaceColor', 'interp');
  m = pdeplot(model, "XYData",meshValues, 'ColorMap', 'jet');
  %  shading interp 
  % view(2);
    %TODO use mesh(or equivalent) - need to make meshValues into a square,
    %same with X and Y
 %   m.FaceColor = 'flat';
    %m = mesh(mesh.Nodes(1,:), mesh.Nodes(2,:), meshValues)
  %  colorbar (axMesh);
    useFile = input("Press any key to exit","s")
    close all;
end