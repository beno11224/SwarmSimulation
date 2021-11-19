FlowMatrix = zeros(2000,2000,2);
MagnitudeOfFlowAtCentreOfPipe = 0.5;
%use FlowLines from Polygons
if(app.polygon.currentPolyFlows(1,:) ~=  [0 0 0 0]) %check this?
    for flowLineIndex = 1:length(size(app.polygon.currentPolyFlows,1))
        startPoint = app.polygon.currentPolyFlows(flowLineIndex,1:2);
        lineVector = startPoint - app.polygon.currentPolyFlows(flowLineIndex,3:4);
        midPoint = startPoint + lineVector./2;

        %Now they are unit vectors determine the smallest OPPOSITE pair
        polygonVectorR = app.polygon.currentPolyVector;
        polygonStartP = app.polygon.currentPoly(1:end-1,:);
        startDistanceQP = (midPoint - polygonStartP);
        startDistancePolyVectorCrossProductQPR = app.particleFunctions.crossProduct(startDistanceQP(:,1,:), startDistanceQP(:,2,:), polygonVectorR(:,1,:), polygonVectorR(:,2,:));
        vectorCrossProductRS = app.particleFunctions.crossProduct(polygonVectorR(:,1,:), polygonVectorR(:,2,:), lineVector(:,1), lineVector(:,2));
        lineDist = (startDistancePolyVectorCrossProductQPR./vectorCrossProductRS);
        lineDist = lineDist(:,:,3);
        [amin,aloc] = mink(abs(aDist),2); %These SHOULD be the lines either side of the line provided.
    end
end

%start = app.particleFunctions.generateParticleLocations(app.polygon.currentStartZone,1);
%%vi = vmax(1- (r^2/R^2)) - formula for flow parabola
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