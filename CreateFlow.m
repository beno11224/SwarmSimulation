function FlowMatrix = CreateFlow(app)
    FlowMatrix = zeros(2000,2000,2);
    matrixSize = size(FlowMatrix,[1,2]);
    MagnitudeOfFlowAtCentreOfPipe = 0.5;
    %use FlowLines from Polygons

    %%vi = vmax(1- (r^2/R^2)) - formula for flow parabola

    if(app.polygon.currentPolyFlows(1,:) ~=  [0 0 0 0]) %check this?
        for flowLineIndex = 1:length(size(app.polygon.currentPolyFlows,1))
            startPoint = app.polygon.currentPolyFlows(flowLineIndex,1:2);
            lineVector = startPoint - app.polygon.currentPolyFlows(flowLineIndex,3:4);
            unitLineVector = lineVector/norm(lineVector);
            midPoint = startPoint + lineVector./2;

            %Now they are unit vectors determine the smallest OPPOSITE pair
            polygonVectorR = app.polygon.currentPolyVector;
            polygonStartP = app.polygon.currentPoly(1:end-1,:);
            startDistanceQP = (midPoint - polygonStartP);
            startDistancePolyVectorCrossProductQPR = app.particleFunctions.crossProduct(startDistanceQP(:,1,:), startDistanceQP(:,2,:), polygonVectorR(:,1,:), polygonVectorR(:,2,:));
            vectorCrossProductRS = app.particleFunctions.crossProduct(polygonVectorR(:,1,:), polygonVectorR(:,2,:), lineVector(:,1), lineVector(:,2));
            lineDist = (startDistancePolyVectorCrossProductQPR./vectorCrossProductRS);
            lineDist = lineDist(:,:,3);
            [minDist,locDist] = mink(abs(lineDist),2); %These SHOULD be the lines either side of the line provided.
            totalRadius = (minDist(2) + minDist(1)) / 2; %capital R - Radius of pipe
            radiusSq = totalRadius*totalRadius; %square it

            lineStarts = [app.polygon.currentPoly(locDist(1),:); app.polygon.currentPoly(locDist(2),:)];
            lineEnds = [app.polygon.currentPoly(locDist(1)+1,:); app.polygon.currentPoly(locDist(2)+1,:)];

            %Now go along each tube - start from the walls then go in each
            %iteration. use the centre of each square for context.
            unitVectorLine1 = app.polygon.currentPolyVector(locDist(1),:)/norm(app.polygon.currentPolyVector(locDist(1),:)); %TODO Get the correct vector out here...
            pointers(1,:) = app.polygon.currentPoly(locDist(1),:);
            unitVectorLine2 = app.polygon.currentPolyVector(locDist(2),:)/norm(app.polygon.currentPolyVector(locDist(2),:)); %TODO Get the correct vector out here...
            pointers(2,:) = app.polygon.currentPoly(locDist(2),:); %Is pointer the wrong way up?
            pipePoly = [app.polygon.currentPoly(locDist(1) ,:); 
                app.polygon.currentPoly(locDist(1)+1 ,:);
                app.polygon.currentPoly(locDist(2) ,:); 
                app.polygon.currentPoly(locDist(2)+1 ,:);
                app.polygon.currentPoly(locDist(1) ,:)]; %Check this works, it should since the lines are linked in one long poly.
            reachedCentre = false;
            countToJumpOut = 0;
            while(~reachedCentre)
                endOfLine = false;
                while(~endOfLine)
                    [in,on] = inpolygon(pointers(:,1), pointers(:,2), pipePoly(:,1), pipePoly(:,2));
                    inOrOn = in|on; %If it's on the edge that's fine too.
                    for i = 1:2

                            %isPointer in the poly?
                        if(inOrOn(i)) %i for line 1 or 2
                            cellIndex = getCellIndex(pointers(i,:),matrixSize, app.UIAxes.XLim(2));

                                %has the cell got a value in it?
                            if(FlowMatrix(cellIndex) == 0)

                                %are the pointers in the same cell? (Maybe obsolete from has cell got value in it?)
                                %If none of above, what is the centre of the cell we are in?
                                cellCentre = getCellCentre(matrixSize, cellIndex, app.UIAxes.XLim(2)); %This may be pointless once at a certain resolution, but oh well.

                                %TODO get litteR;
                                cellDist = (((lineEnds(i,1) - lineStarts(i,1))*(lineStarts(i,2) - cellCentre(2)) ) - ((lineStarts(i,1) - cellCentre(1))*(lineEnds(i,2) - lineStarts(i,2)) )) / (totalRadius*2);
                                cellRadius = abs(totalRadius - cellDist); %TODO This is wrong - check for negatives etc maybe?

                                %cell value = vi formula above
                                aaa = 1- ((cellRadius*cellRadius)/radiusSq);
                                aab = MagnitudeOfFlowAtCentreOfPipe.*(1- ((cellRadius*cellRadius)/radiusSq));
                                aac = unitLineVector .* MagnitudeOfFlowAtCentreOfPipe.*(1- ((cellRadius*cellRadius)/radiusSq));
                                %flowMatrixFullIndex = [cellCentre,:];
                                VectorToAdd = unitLineVector .* MagnitudeOfFlowAtCentreOfPipe.*(1- ((cellRadius*cellRadius)/radiusSq));
                                %cellCentreIndex = getCellIndex(cellCentre, size(FlowMatrix), app.UIAxes.XLim(2));
                                FlowMatrix(cellIndex) = VectorToAdd(1);                            
                                FlowMatrix(cellIndex*2) = VectorToAdd(2); %It's not x2...
                            end
                        else
                            if(all(inOrOn(i) == 0))
                                endOfLine = true;
                                %TODO move to next line
                                %Backtrack by setting the pointer location to a
                                %valid location.
                                %Here should add the check for if we have
                                %finished or not.
                                if(countToJumpOut > 1000 || cellRadius <= 1/matrixSize(1).*totalRadius)
                                    reachedCentre = true; %TODO does this stop once values are small enough?
                                end
                            end
                        end
                    end
                    countToJumpOut = countToJumpOut + 1;
                    %Now add the unit vector...;
                    pointers(1,:) = pointers(1,:) - (unitVectorLine1 .* 1/matrixSize(1)); %What value to make it small? just want a step of < 1 square... %TODO the unit vectors went down the wrong lines when negated. how does that work??
                    pointers(2,:) = pointers(2,:) - (unitVectorLine2 .* 1/matrixSize(1));
                end
            end
        end
    end
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