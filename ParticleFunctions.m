classdef ParticleFunctions
    properties
        magneticForceConstant;
        dragForceConstant;
        dipoleForceConstant;
        particleDiameter; 
        staticFrictionCoefficient;
        movingFrictionCoefficient;
        particleMass;
        workspaceSizePositive;%use for the positive limits
        workspaceSizeMinus; %use for negative limits
    end
    methods (Access = public)
        %Constructor
        function obj = ParticleFunctions(permeabilityOfFreeSpace, particleDiameter, particleMass, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize)
            obj = obj.ChangeMetaValues(permeabilityOfFreeSpace, particleDiameter, particleMass, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize);

        end
        %So user can change parameters on the fly
        function obj = ChangeMetaValue(obj, permeabilityOfFreeSpace, particleDiameter, particleMass, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize)
            obj = obj.ChangeMetaValues(permeabilityOfFreeSpace, particleDiameter, particleMass, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize);
        end
        
        function obj = ChangeMetaValues(obj,permeabilityOfFreeSpace, particleDiameter, particleMass, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize)
            obj.magneticForceConstant = double(permeabilityOfFreeSpace .* 58 .* 2.25 .* 10^3 .* 4/3.*pi.*(particleDiameter/2)^3) .* 22;
            obj.dragForceConstant = double(3*pi * fluidViscocity * particleDiameter);
            obj.dipoleForceConstant = double(3*permeabilityOfFreeSpace / 4*pi);
            obj.staticFrictionCoefficient = staticFrictionCoefficient;
            obj.movingFrictionCoefficient = motionFrictionCoefficient;
            obj.particleMass = particleMass;
            obj.particleDiameter = particleDiameter;
            obj.workspaceSizePositive = workspaceSize;
            obj.workspaceSizeMinus = -1 * workspaceSize;
        end
        
        %public functions
        function force = calculateMagneticForce(obj, aCoils)
            %Now just using aCoils for the minute, will remove b coils from demo shortly.
            force = (aCoils.*10^6) .* obj.magneticForceConstant;
        end
        function force = calculateDipoleForce(obj, particleLocation, particleTorque)
            xYdistanceBetweenAllParticles = particleLocation - permute(particleLocation,[3,2,1]);
            distanceBetweenAllParticles = permute(sqrt(abs(xYdistanceBetweenAllParticles(:,1,:).^2 + xYdistanceBetweenAllParticles(:,2,:).^2)),[1,3,2]);
            distanceBetweenAllParticles(isnan(distanceBetweenAllParticles)) = 0;
            dipoleMoments = double(sum(particleTorque,2) .* distanceBetweenAllParticles);
            dipoleMoments = dipoleMoments .* dipoleMoments.';
            normalisedDipoleMoment = dipoleMoments ./ distanceBetweenAllParticles.^-4;
            sumOfAllDipoleMoments = obj.dipoleForceConstant .* sum(normalisedDipoleMoment,2); %sum along '2'axis to make it 5x1
            %now convert back to 5x2, x & y for the final result
            distanceMultiplier = permute(sum(xYdistanceBetweenAllParticles,1),[3,2,1]);
            force = sumOfAllDipoleMoments .* distanceMultiplier;
        end
        function force = calculateDragForce(obj, particleVelocity, flowVelocity)
            force = ((particleVelocity - flowVelocity) .* obj.dragForceConstant); %Stokes Drag Equation
        end
        function [wallContact, orthogonalWallContact, particleLocation, particleVelocity] = isParticleOnWallPIP(obj, particleLocation, particleVelocity, particleForce, polygon, tMax)
            %this just returns anything INSIDE the polygon, not anything on the walls
            in = inpolygon(particleLocation(:,1), particleLocation(:,2), polygon.currentPoly(:,1), polygon.currentPoly(:,2));
            wallContact = particleVelocity .* nan;
            orthogonalWallContact = wallContact;

            if(any(~in))
                %https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
                particleVelocityVectorS = squeeze(repmat(-particleVelocity.*tMax,[1,1,length(polygon.currentPolyVector)]));
                polygonVectorR = permute(repmat(polygon.currentPolyVector', [1,1,size(particleVelocity,1)]),[3,1,2]);
                particleStartQ = squeeze(repmat(particleLocation,[1,1,length(polygon.currentPolyVector)]));
                polyLineStartP = permute(repmat(polygon.currentPoly(1:end-1,:)', [1,1,size(particleVelocity,1)]),[3,1,2]);
                timeParticleCrossedLine = obj.multiplierOfLineVectorOfIntersectionOfTwoLines(particleStartQ, particleVelocityVectorS, polyLineStartP, polygonVectorR);
                %Now tidy the matricies up to something useable
                allTimeParticleCrossedLine = timeParticleCrossedLine;
                timeParticleCrossedLine(timeParticleCrossedLine <= 0) = nan;
                timeParticleCrossedLine(timeParticleCrossedLine > 1) = NaN; %remove 0 to prevent errors in min calculation %==0
                if(any(any(any(~isnan(timeParticleCrossedLine)))))
                    [minTimeModifier, indexOfClosestVector] = min(timeParticleCrossedLine,[],2);
                    minTimeModifier = obj.realNum(minTimeModifier(:,:,3)) .* -1;
                    minTimeModifier = minTimeModifier .* ~in; %So we only care about the particles that are not in the space
                    
                    %remember tMax is the TIME not a DISTANCE
                    %Similarly minTimeModifier is a Multiplier of TMAX
                    %(it means nothing on it's own!)
                    %location is current, velocity and tMax are from the previous calculations
                    reverseVelocityAmmount = ((minTimeModifier.*tMax) .* -particleVelocity) .* 1.015; %move the particle 1.5% away from the wall to prevent sticking
                    particleLocation = particleLocation + real(reverseVelocityAmmount); %plus as the particleVelocity was negative
                   
                    %WallContact shows the vector orthogonal to the wall. All other values in 
                    %WallContact are nans to show there is no contact
                    wallContact = polygon.currentPolyVector(indexOfClosestVector(:,:,3),:);
                    wallContact = wallContact .* ~in;
                    wallContact = wallContact ./ norm(wallContact); %to unit vector

                    %particleVelocity is determined by vector projection of velocity onto
                    %wall contact
                    %Use vector rejection to project force along the wall.
                    velocityOrthogonalToWallContact = obj.vectorProjection(particleVelocity,orthogonalWallContact);
                    testForSign = velocityOrthogonalToWallContact .* orthogonalWallContact;
                    velocityOrthogonalToWallContact(testForSign < 0) = 0;  %TODO this needs to have the sign match - it can't be going the wrong way.                                       
                    newParticleVelocity = obj.vectorProjection(particleVelocity,wallContact) + velocityOrthogonalToWallContact;
                    wallContact(~any(wallContact,2),:) = NaN; %Set 1's to nan
                    % newVelocityDistribution = 0.5;
                     %particleVelocity = particleVelocity .* isnan(wallContact) + particleVelocity .* (1 - newVelocityDistribution) .* ~isnan(wallContact)  + newParticleVelocity .* newVelocityDistribution .* ~isnan(wallContact);          
                    particleVelocity = particleVelocity .* isnan(wallContact) + newParticleVelocity .* ~isnan(wallContact); 
                else
                    [minTimeModifier, indexOfClosestVector] = min(abs(allTimeParticleCrossedLine),[],2);
                    minTimeModifier = obj.realNum(minTimeModifier(:,:,3)) .* -1;
                    minTimeModifier = minTimeModifier .* ~in; %So we only care about the particles that are not in the space
                    reverseVelocityAmmount = ((minTimeModifier(~in).*tMax) .* -particleVelocity(~in)) .* 1.015; %move the particle 1.5% away from the wall to prevent sticking
                    particleLocation(~in) = particleLocation(~in) + real(reverseVelocityAmmount); %plus as the particleVelocity was negative
                    wallContact = polygon.currentPolyVector(indexOfClosestVector(:,:,3),:);
                    wallContact = wallContact .* ~in;
                    wallContact = wallContact ./ norm(wallContact); %to unit vector
                    wallContact(~any(wallContact,2),:) = NaN; %Set 1's to nan
                    particleVelocity(~in) = 0; 
                end
                orthogonalWallContact = wallContact .* 0;
                velForWorkingStuffOut = particleVelocity + 1;
                for wallContactCount = 1:length(particleVelocity)
                    if(any(~isnan(wallContact(wallContactCount,:))))
                        orthogonalWallContact(wallContactCount,:) = velForWorkingStuffOut(wallContactCount,:) - obj.vectorProjection(velForWorkingStuffOut(wallContactCount,:),wallContact(wallContactCount,:));
                        orthogonalWallContact(wallContactCount,:) = orthogonalWallContact(wallContactCount,:) ./ norm(orthogonalWallContact(wallContactCount,:));
                        newPoint = particleLocation + orthogonalWallContact .* 0.0001; %go 0.1mm - this should be the right distance to go past a wall if there was one, but not past the one opposite.
                        if(~inpolygon(newPoint(1), newPoint(2),polygon.currentPoly(:,1), polygon.currentPoly(:,2)))
                            orthogonalWallContact(wallContactCount,:) = orthogonalWallContact(wallContactCount,:) .* -1;
                        end
                    end
                end            
            end
        end
        
        function velocity = calculateFlow(obj, particleLocation, flowMatrix, polygon, axes)
            %Remove this once values are loaded in from file
            tr = triangulation(polyshape(polygon.currentPoly(:,1),polygon.currentPoly(:,2)));
            model = createpde(1);
            tnodes = tr.Points';
            telements = tr.ConnectivityList';
            model.geometryFromMesh(tnodes, telements);
            mesh = generateMesh(model, 'Hmax', 0.000073);%was 0.001 for old one.
            
            plot(axes, mesh.Nodes(1,:), mesh.Nodes(2,:), '.','markerSize', 5 , 'color', 'red'); %visualise nodes
            
            flowMatrix = flowMatrix .* 3000;
            
            %for i = 1:size(mesh.Nodes,2)
            %    ab = plot(axes, mesh.Nodes(1,i), mesh.Nodes(2,i), '.', 'markerSize', 23, 'color', 'yellow');
            %    abz = plot(axes,[mesh.Nodes(1,i); mesh.Nodes(1,i) + flowMatrix(i,1)], [mesh.Nodes(2,i); mesh.Nodes(2,i) + flowMatrix(i,2)], 'color', 'red');
            %    abc(1,:) = [i i+11];
            %    abc(2,:) = flowMatrix(i,:);
            %    delete(ab);
            %    delete(abz);
            %end
            
           % closestNode = findNodes(mesh, 'nearest', particleLocation');
           % velocity(:,1) = flowMatrix(closestNode,1);
           % velocity(:,2) = flowMatrix(closestNode,2);
           velocity = particleLocation .* 0;
        end
       
        function writeMeshToFile(obj,polygon)
            tr = triangulation(polyshape(polygon.currentPoly(:,1),polygon.currentPoly(:,2)));
            model = createpde(1);
            tnodes = tr.Points';
            telements = tr.ConnectivityList';
            model.geometryFromMesh(tnodes, telements);
            mesh = generateMesh(model, 'Hmax', 0.001);
            fileidone = fopen('MeshAndPolygon.csv','w');
            for i = 1:length(mesh.Nodes)
                fprintf(fileidone, mesh.Nodes(1,i) + "," + mesh.Nodes(2,i) + "\r");
            end            
            fprintf(fileidone, "Poylgon" + "," + "Below" + "\r");
            for i = 1: length(polygon.currentPoly)
                fprintf(fileidone, polygon.currentPoly(i,1) + "," + polygon.currentPoly(i,2) + "\r");
            end                        
            fclose(fileidone);
        end
        
        function force = calculateFrictionForce(obj, particleVelocity, particleForce, wallContact)            
            trueParticleVelocity = sum(abs(particleVelocity),2);
            movingParticles = trueParticleVelocity > 0;
            %intialise return matrix
            force = zeros(size(particleForce));
            for i = 1:length(particleForce)
                %is the particle on a wall?
                if(any(~isnan(wallContact(i,:))))
                    %choose the coefficient based on particle moving or not
                    if(movingParticles(i))
                        coefficient = obj.movingFrictionCoefficient;
                    else
                        coefficient = obj.staticFrictionCoefficient; %TODO Currently not reached - if the particle is on the wall it must have velocity due to existing maths.
                    end
                    %Use vector rejection to project force into the wall.
                    force(i,:) = particleForce(i,:) - obj.vectorProjection(particleForce(i,:),wallContact(i,:)) .* coefficient;
                end
            end
        end
        
        function velocity = calculateCumulativeParticleVelocityComponentFromForce(obj, particleForce, oldVelocity, haltTheseParticles, wallContact, timeSinceLastUpdate)
            velocity = oldVelocity + calculatePointVelocityUpdate(obj,particleForce, obj.particleMass, timeSinceLastUpdate);
            for i = 1:length(velocity)
                if(any(~isnan(wallContact(i,:))))
                    velocity(i,:) = obj.vectorProjection(velocity(i,:),wallContact(i,:));
                end
            end
            %prevent these particles from moving
            velocity = velocity .* ~haltTheseParticles;
        end   
        
        function acceleration = calculateAcceleration(obj,particleForce, particleMass)
            acceleration = particleForce ./ particleMass;
        end
        
        function velocity = calculateDeltaVelocity(obj,particleForce, particleMass, timeSinceLastUpdate)
            velocity = obj.calculateAcceleration(particleForce, particleMass) ./ timeSinceLastUpdate;
        end
        
        function [velocity,acceleration] = calculateCurrentVelocityCD(obj, orthogonalWallContact, wallContact, previousVelocity, previousAcceleration, particleForce, particleMass, timeSinceLastUpdate)            
            currentAcceleration = obj.calculateAcceleration(particleForce, particleMass);
            %v = u + at - just the at bit here.
            hypotheticalDeltaVelocity = 0.5.*(currentAcceleration + previousAcceleration).* timeSinceLastUpdate; %timeSinceLastUpdate must be fairly constant for this to work - maybe avg time?
            
            wallContactVelocity = 0 .* hypotheticalDeltaVelocity;
            for i = 1:length(hypotheticalDeltaVelocity)
                %is the particle on a wall?
                if(any(~isnan(wallContact(i,:))))
                    %Use vector rejection to project force along the wall.
                    velocityOrthogonalToWallContact = obj.vectorProjection(hypotheticalDeltaVelocity(i,:),orthogonalWallContact(i,:));
                    testForSign = velocityOrthogonalToWallContact .* orthogonalWallContact(i,:);
                    velocityOrthogonalToWallContact(testForSign < 0) = 0;  %TODO this needs to have the sign match - it can't be going the wrong way.
                    %vectorprokected = obj.vectorProjection(hypotheticalDeltaVelocity(i,:),wallContact(i,:));
                    wallContactVelocity(i,:) = obj.vectorProjection(hypotheticalDeltaVelocity(i,:),wallContact(i,:)) + velocityOrthogonalToWallContact; %TODO now missing the part orthogonal to wall contact. how???
                    %perpendicularWallVelocity = hypotheticalDeltaVelocity - obj.vectorProjection(hypotheticalDeltaVelocity(i,:),wallContact(i,:));
                  %  if(inpolygon(location(i,1),location(i,2),polygon(??,1),polygon(??,2))) %TODO this needs to work better
                  %      wallContactVelocity(i,:) = wallContactVelocity(i,:) + TODO;
                  %  end
                end
            end
            %wallContactVelocity = vectorProjection( (hypotheticalDeltaVelocity .* ~isnan(wallContact)) , wallContact );
            hypotheticalDeltaVelocity = hypotheticalDeltaVelocity .* isnan(wallContact) + wallContactVelocity; %Try this?

            
            rateOfChange = (hypotheticalDeltaVelocity - previousVelocity) ./ previousVelocity; 
            %capRateofChangeAt = 5;%3;%1.1;
            %TODO can't use average or max for these particles, must do it
            %matrix wise. check it works then change it to matrix wise
            %capRateofChangeAt = (log(abs(previousVelocity)+0.000000000000000001)/log(0.00005)) - 0.5;
            %capRateofChangeAt = (log(abs(previousVelocity)+0.000001)/log(0.005)) - 1.8;
            capRateofChangeAt = (1*10e3 .* abs(previousVelocity./10) + 0.1).^-2;
            capRateofChangeAt(capRateofChangeAt < 0.1) = 0.1; %limit the lower end.
            rateOfChange(isinf(rateOfChange)) = intmax;
            rateOfChange(isnan(rateOfChange)) = 0;
            if(any(any(abs(rateOfChange) > capRateofChangeAt)))
                cappedRateOfChange = rateOfChange;
                cappedRateOfChange(abs(rateOfChange) > capRateofChangeAt) = capRateofChangeAt(abs(rateOfChange) > capRateofChangeAt); %cap it
                cappedRateOfChange(rateOfChange < 0) = ((capRateofChangeAt(rateOfChange < 0))./2) .* -1; %replace any negative signs, halve negative rate of change
                %set the capped deltaVelocity
                hypotheticalDeltaVelocity = obj.realNum((cappedRateOfChange./rateOfChange) .* hypotheticalDeltaVelocity);
                %set the capped acceleration
                acceleration = hypotheticalDeltaVelocity / timeSinceLastUpdate;
            else
                acceleration = currentAcceleration;
            end

            

           % acceleration = currentAcceleration;
            %set the velocity based on capped or not capped deltaVelocity
            velocity = (previousVelocity + hypotheticalDeltaVelocity);% .* ~haltTheseParticles;
        end
        
        function location = calculateCurrentLocationCD(obj,previousLocation, previousVelocity, previousAcceleration, timeSinceLastUpdate)
            %a = previousVelocity .* timeSinceLastUpdate;
            %b = 0.5.*previousAcceleration.*timeSinceLastUpdate^2;
            %finalDeltaVelocity = a + b
            %s = ut + 0.5at^2
            %is the previous acceleration wrong to use?
            location = previousLocation + previousVelocity .* timeSinceLastUpdate + 0.5.*previousAcceleration.*timeSinceLastUpdate^2; %as above for time
        end
        
        function [newLocations, newVelocity] = calculateCollisionsAfter(obj, oldParticleLocation, newParticleLocation, particleVelocity, timeModifier)
            positionsOfAnyParticleCollisions = obj.multiplierOfLineVectorOfIntersectionOfTwoLines(oldParticleLocation, particleVelocity, newParticleLocation, particleVelocity.*-1);
            positionsOfAnyParticleCollisions = positionsOfAnyParticleCollisions(:,:,3);
            positionsOfAnyParticleCollisions(isnan(positionsOfAnyParticleCollisions)) = 0;
            %set limits for back-movement of particle (-1<=x<0)
            positionsOfAnyParticleCollisions(positionsOfAnyParticleCollisions >= 0) = 0;
            positionsOfAnyParticleCollisions(positionsOfAnyParticleCollisions < -1) = 0;
            vectoredResetParticlesToCorrectLocations = particleVelocity .* -1 .* obj.realNum(positionsOfAnyParticleCollisions);
            newLocations = newParticleLocation + obj.realNum(vectoredResetParticlesToCorrectLocations);            
            %Now allow only velocity perpendicular to the contact                       
            newVelocity = particleVelocity;
        end
        function [location, newVelocity] = moveParticle(obj, particleLocation, particleVelocity, timeModifier)
            %unCheckedLocation = particleLocation + obj.realNum(particleVelocity .* timeModifier);
            %[location,newVelocity] = calculateCollisionsAfter(obj, particleLocation, unCheckedLocation, particleVelocity, timeModifier);
            %Comment above and Uncomment below to prevent particleCollisions
            location = particleLocation + obj.realNum(particleVelocity);
            newVelocity = particleVelocity;
        end
        
        function particleLocations = generateParticleLocations(obj, poly, particleLocationsLength)
            [xlim ylim] = boundingbox(polyshape(poly));
            particleLocationIndex = 1;
            particleLocations = zeros(length(particleLocationsLength), 2);
            %init return value
            while(particleLocationIndex <= particleLocationsLength)
                particleLocations(particleLocationIndex,:) = real([xlim(1), ylim(1)] + [xlim(2)-xlim(1),ylim(2)-xlim(1)] .* rand(1, 2));
                particleLocationXValue = particleLocations(particleLocationIndex,1);
                particleLocationYValue = particleLocations(particleLocationIndex,2);
                if(inpolygon(particleLocationXValue,particleLocationYValue,poly(:,1), poly(:,2)))
                    particleLocationIndex = particleLocationIndex + 1;
                end
            end
        end
        
        function inGoalZone = isParticleInEndZone(obj, goalZones, particleLocations)
           inGoalZone = zeros(length(particleLocations),length(goalZones));
           [in,on] = inpolygon(particleLocations(:,1), particleLocations(:,2), goalZones(:,1), goalZones(:,2));
           inGoalZone = in | on;
           % inGoalZone = zeros(length(particleLocations),length(goalZones));
           % for goalZoneIndex = 1:length(goalZones)
           %     [in,on] = inpolygon(particleLocations(:,1), particleLocations(:,2), goalZones(goalZoneIndex,:,1), goalZones(goalZoneIndex,:,2));
           %     inGoalZone{:,goalZoneIndex} = in | on;
           % end
        end
        
        %Helper function used for collision detection for both
        %particle/wall and particle/particle.
        %Result references the magnitude of the line1vector to get to the
        %intersection point. To get the same for line2, swap the parameters
        %round when calling.
        function [line1Multiplier] = multiplierOfLineVectorOfIntersectionOfTwoLines(obj, line1StartQ, line1VectorS, line2StartP, line2VectorR)
           
            startDistanceQP = (line1StartQ - line2StartP);
            startDistanceLine2VectorCrossProductQPR = obj.crossProduct(startDistanceQP(:,1,:), startDistanceQP(:,2,:), line2VectorR(:,1,:), line2VectorR(:,2,:));
            vectorCrossProductRS = obj.crossProduct(line2VectorR(:,1,:), line2VectorR(:,2,:), line1VectorS(:,1,:), line1VectorS(:,2,:));
            line1Multiplier = obj.realNum(startDistanceLine2VectorCrossProductQPR./vectorCrossProductRS);
        end
        
        %parameters are the x and y values as vectors corresponding to the cross product of matricies A and B
        function AB = crossProduct(obj, Ax, Ay, Bx, By)
            AB(:,:,3) = Ax.*By-Ay.*Bx;
        end
        
        %C must be scalar, AB must be vector
        function vec = scalarToVector(obj,C,AB)
            vec = (AB./norm(AB)) .* C;            
        end

        %Shortest distand from a point to a line
        function dist = distPointToLine(obj,point,lineA,lineB)
            a = lineA - lineB;
            b = point - lineB;
            dist = norm(cross(a,b)) / norm(a);
        end
        
        %vector projection of AB along line CD
        %To get vector rejection, just do AB - obj.vectorProjection(AB,CD)
        function vec = vectorProjection(obj, AB, CD)
            vec = obj.realNum((dot(AB,CD) / dot(CD, CD)) * CD);
        end
        
        %Fix matlabs tendency to make doubles into imaginary numbers
        function num = realNum(obj,num)            
            num(isinf(num)) = 0;
            num(isnan(num)) = 0;
            num = real(num);
        end
    end
end

