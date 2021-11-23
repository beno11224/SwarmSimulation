function FlowMatrix = CreateFlow(app)
    FlowMatrix = zeros(2000,2000,2);
    matrixSize = size(FlowMatrix,[1,2]);
    MagnitudeOfFlowAtCentreOfPipe = 0.5;
    %use FlowLines from Polygons
    
    %%vi = vmax(1- (r^2/R^2)) - formula for flow parabola

    tr = triangulation(polyshape(app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2)));
    model = createpde(1);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    model.geometryFromMesh(tnodes, telements);
    %pdegplot(model, 'VertexLabels','on');
    mesh = generateMesh(model, 'Hmax', 0.001);    
    figure
    pdemesh(model);
    hold on
    %results = solvepde(model);
    %pdegplot(results, 'VertexLabels','on');
    %trimesh(telements,tnodes(1,:),tnodes(2,:)); %???? that doesn't do anything?
    %polygonMesh = generateMesh(app.polygon.currentPoly);
    nodeToSearchFor = [0.67 * app.UIAxes.XLim(2) -0.92 * app.UIAxes.XLim(2)];
    nodes = findNodes(mesh, 'nearest', nodeToSearchFor');
    edgeid = nearestEdge(model.Geometry,nodeToSearchFor);
    place = [app.polygon.currentPoly(edgeid,1) app.polygon.currentPoly(edgeid,2);
        app.polygon.currentPoly(edgeid+1,1) app.polygon.currentPoly(edgeid+1,2)];
    plot(app.UIAxes, place(:,1), place(:,2), 'color', 'red');
    hold on
    plot(mesh.Nodes(1,nodes), mesh.Nodes(2,nodes), 'ok', 'MarkerFaceColor', 'cyan')
    flowSize = mesh.Nodes;
    asbasfg = [mesh.Nodes(1,nodes), mesh.Nodes(2,nodes)];    
end

function cellIndex = getCellIndex(pointLocation, flowChartSize, workSpaceSize)
    factorPosition = (pointLocation + workSpaceSize) ./ (workSpaceSize*2); %Do we know worksapceSize?
    flowChartNumericalPosition = round(factorPosition .* flowChartSize);
    flowChartNumericalPosition(flowChartNumericalPosition == 0) = 1;
    cellIndex = sub2ind(flowChartSize,flowChartNumericalPosition(:,1),flowChartNumericalPosition(:,2));
end

function cellCentre = getCellCentre(flowChartSize, cellIndex, workSpaceSize)
    %get cell width as a value???
    [cellSubR,cellSubC] = ind2sub(flowChartSize, cellIndex); %TODO do I need to (add 1/2?)
    factorPosition = ([cellSubR,cellSubC] - flowChartSize/2) ./ (flowChartSize/2);
    cellCentre = factorPosition .* workSpaceSize;
end

%start = app.particleFunctions.generateParticleLocations(app.polygon.currentStartZone,1);
%%1 - find direction of tube at start.
%aVector = app.polygon.currentStartZone(1,:) - app.polygon.currentStartZone(2,:);
%aVector(1,1) = -aVector(1,1);
%aVector = aVector/norm(aVector);
%bVector = app.polygon.currentStartZone(2,:) - app.polygon.currentStartZone(3,:);
%bVector(1,1) = -bVector(1,1);
%bVector = bVector/norm(bVector);
%%Now they are unit vectors determine the smallest OPPOSITE pair
%polygonVectorR = app.polygon.currentPolyVector;
%polygonStartP = app.polygon.currentPoly(1:end-1,:);
%startDistanceQP = (start - polygonStartP);
%startDistancePolyVectorCrossProductQPR = app.particleFunctions.crossProduct(startDistanceQP(:,1,:), startDistanceQP(:,2,:), polygonVectorR(:,1,:), polygonVectorR(:,2,:));
%vectorCrossProductRSa = app.particleFunctions.crossProduct(polygonVectorR(:,1,:), polygonVectorR(:,2,:), aVector(:,1), aVector(:,2));
%vectorCrossProductRSb = app.particleFunctions.crossProduct(polygonVectorR(:,1,:), polygonVectorR(:,2,:), bVector(:,1), bVector(:,2));
%aDist = (startDistancePolyVectorCrossProductQPR./vectorCrossProductRSa);
%aDist = aDist(:,:,3);
%bDist = (startDistancePolyVectorCrossProductQPR./vectorCrossProductRSb);
%bDist = bDist(:,:,3);
%[amin,aloc] = mink(abs(aDist),2);
%[bmin,bloc] = mink(abs(bDist),2);
%c= 1;