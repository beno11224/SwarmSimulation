function FlowMatrix = CreateFlow(app)
    %FlowMatrix = zeros(2000,2000,2);
    %matrixSize = size(FlowMatrix,[1,2]);
    VelocityAtCentreOfPipe = 0.5;
    %use FlowLines from Polygons
    
    %%vi = vmax(1- (r^2/R^2)) - formula for flow parabola

    %Get the mesh object to use for locating FlowPoints.
    tr = triangulation(polyshape(app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2)));
    model = createpde(1);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    model.geometryFromMesh(tnodes, telements);
    mesh = generateMesh(model, 'Hmax', 0.001); %Hmax is the size - use app.UIAxes.XLim(2) to decide how to do this    
    
    %Get FlowMatrix
    FlowMatrix = zeros(size(mesh.Nodes));
    
    %Start filling all points
    for pointIndex = 1 : size(mesh.Nodes,1)
        %Each node is a valid simulation location.
        
        %Start with the closest edge - this must be a side and NOT an
        %in/out flow.
        nearestEdgeID = nearestEdge(model.Geometry,mesh.Nodes(:,pointIndex)');
        
        %Now find the opposite edge
        
        %Now get the max radius^2 (distance to the opposite edge / 2)^2
        totalRadiusSQUARED = 1;%TODO
        
        %And the distance to the closest edge
        %TODO Edgeid is not the correct one...
        pointRadius = getDistanceFromPointToVectorLine(mesh.Nodes(1,pointIndex),mesh.Nodes(2,pointIndex),app.polygon.currentPoly(edgeid,1), app.polygon.currentPoly(edgeid,2),app.polygon.currentPoly(edgeid+1,1), app.polygon.currentPoly(edgeid+1,2));
        
        %Set the value
        FlowMatrix(pointIndex,:) = VelocityAtCentreOfPipe * (1 - (pointRadius*pointRadius) /  totalRadiusSQUARED);         
    end
    
    %Worth mentioning that this method will not work in bifurcations
    %and will make some weird lower (more turbulent?) numbers.
    
    
    
    %location
    %nodeToSearchFor = [0.67 * app.UIAxes.XLim(2) -0.92 * app.UIAxes.XLim(2)];
    
    %How to find closest node
    %nodes = findNodes(mesh, 'nearest', nodeToSearchFor');
    
    %can get edgeID but this is only relevant to the edges in the mesh?
    %edgeid = nearestEdge(model.Geometry,nodeToSearchFor);
    %place = [app.polygon.currentPoly(edgeid,1) app.polygon.currentPoly(edgeid,2);
    %    app.polygon.currentPoly(edgeid+1,1) app.polygon.currentPoly(edgeid+1,2)];
   
    %drawing and locating.
    %plot(app.UIAxes, place(:,1), place(:,2), 'color', 'red');
    %hold on
    %plot(mesh.Nodes(1,nodes), mesh.Nodes(2,nodes), 'ok', 'MarkerFaceColor', 'cyan')
    
    
    %How to locate: a = [mesh.Nodes(1,nodes), mesh.Nodes(2,nodes)];    
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

function dist = getDistanceFromPointToVectorLine(px,py, vStartx,vStarty, vEndx,vEndy)  
    dist = (((vEndx - vStartx)*(vStarty - py) ) - ((vStartx - px)*(vEndy - vStarty) )) / norm([vEndx vEndy] - [vStartx vStarty]);
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