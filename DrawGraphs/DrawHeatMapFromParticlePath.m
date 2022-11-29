function DrawHeatMapFromParticlePath(particlePaths)

    if ~exist('particlePaths','var')
     % third parameter does not exist, so default it to something
      ReadAllResults();
    end

    polygon = Polygons(0.0096);
    polygon = polygon.change(2);
    tr = triangulation(polyshape(polygon.currentPoly(:,1),polygon.currentPoly(:,2)));
    model = createpde(1);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    model.geometryFromMesh(tnodes, telements);
    mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
    meshValues = zeros([size(mesh.Nodes,2),1]);
    plotMesh = figure;
    axMesh = axes('Parent',plotMesh);
    hold on
    polyLineMesh = plot(axMesh,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
    endLineMesh = plot(axMesh,polygon.currentEndZone(1,:,1),polygon.currentEndZone(1,:,2), 'Color','g');

    for(pIndex = 1:length(particlePaths))
        if(~ particlePaths(pIndex).ValidRun)
            continue;
        end
        for(lineCount = 1: size(particlePaths(pIndex).Locations,1))
            abc = particlePaths(pIndex).Locations;
            for(locationIndex = 1:size(squeeze(particlePaths(pIndex).Locations(lineCount,:,:)),2))
            %    abca = particlePaths(pIndex).Locations(lineCount,:);
             %   abcb = particlePaths(pIndex).Locations(lineCount,:,locationIndex);
              %  abca = squeeze(particlePaths(pIndex).Locations(lineCount,:,locationIndex))';
              %  abca = squeeze(particlePaths(pIndex).Locations(lineCount,:,locationIndex))';
                closestNode = findNodes(mesh, 'nearest', particlePaths(pIndex).Locations(lineCount,:)');
                meshValues(closestNode) = meshValues(closestNode) + 1;
            end
        end
    end
        
    
    meshValues = meshValues ./ quantile(meshValues,0.9); %between 0 and 1
    meshValues(meshValues > 1) = 1; %limit extremes
    m = pdeplot(model, "XYData",meshValues, 'ColorMap', 'jet');

    useFile = input("Press any key to exit","s")
    close all;
end


