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
        fiftyParticleStartLocations;
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
            obj.fiftyParticleStartLocations = [-0.00949, -0.00398;
                -0.00949, -0.00397;
                -0.00949, -0.00395;
                -0.00949, -0.00393;
                -0.00949, -0.00391
                -0.00949, -0.00389;
                -0.00949, -0.00387;
                -0.00949, -0.00385;
                -0.00949, -0.00383;
                -0.00949, -0.00381;
                -0.00949, -0.00379;
                -0.00949, -0.00377;
                -0.00949, -0.00375;
                -0.00949, -0.00373;
                -0.00949, -0.00371;
                -0.00949, -0.00369;
                -0.00949, -0.00367;
                -0.00949, -0.00365;
                -0.00949, -0.00363;
                -0.00949, -0.00361;
                -0.00949, -0.00359;
                -0.00949, -0.00357;
                -0.00949, -0.00355;
                -0.00949, -0.00353;
                -0.00949, -0.00351;%];  %%MIDPOINT
                -0.00949, -0.00349;
                -0.00949, -0.00347;
                -0.00949, -0.00345;
                -0.00949, -0.00343;
                -0.00949, -0.00341;
                -0.00949, -0.00339;
                -0.00949, -0.00337;
                -0.00949, -0.00335;
                -0.00949, -0.00333;
                -0.00949, -0.00331;
                -0.00949, -0.00329;
                -0.00949, -0.00327;
                -0.00949, -0.00325;
                -0.00949, -0.00323;
                -0.00949, -0.00321;
                -0.00949, -0.00319;
                -0.00949, -0.00317;
                -0.00949, -0.00315;
                -0.00949, -0.00313;
                -0.00949, -0.00311;
                -0.00949, -0.00309;
                -0.00949, -0.00307;
                -0.00949, -0.00305;
                -0.00949, -0.00303;
               -0.00949, -0.00302];
        end
        
        %public functions
        function force = calculateMagneticForce(obj, aCoils,joyStick, h, v, controlMethod, mouseLocation, magForceRestrict, rotation)
            switch(controlMethod)      
                case("Keyboard")
                    totalForce = aCoils.* 10^6;
                case("Mouse")
                    totalForce = mouseLocation .* 2.25*10^8; %Mouse Force is a bit lower than the others
                case("Controller")                    
                    %newHapticValues = (HapticSpoofTest() + 0.05) .* 25;
                    newHapticValues = ReadHaptic() .* 30;
                    if magForceRestrict ~= 0
                        newHapticValues = newHapticValues .* (magForceRestrict/2.25);
                    end
                    totalForce = [newHapticValues(1)*10^6, newHapticValues(2)*10^6];                    
                otherwise
                    totalForce = [0 0];
            end
            if(norm(totalForce) > 2.25*10^6)
                totalForce = totalForce ./ norm(totalForce) .* 2.25*10^6;
            end
            force = ([cosd(-rotation), sind(-rotation); -sind(-rotation), cos(-rotation)] * (obj.magneticForceConstant .* totalForce)')' ;
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

        function [wallContact, orthogonalWallContact, particleLocation, particleVelocity] = isParticleOnWallPIP(obj, particleLocation, particleVelocity, particleForce, polygon, tMax,app)
            %this just returns anything INSIDE the polygon, not anything on the walls
            in = inpolygon(particleLocation(:,1), particleLocation(:,2), polygon.currentPoly(:,1), polygon.currentPoly(:,2));

            wallContact = particleVelocity .* nan;
            orthogonalWallContact = wallContact;
            %If no particles are outside the shape, we can skip all this.
            if(any(~in))
                distMove = particleVelocity .* 0;
                dists = zeros(length(wallContact),1);
                for outOfBoundsCount = 1:size(polygon.currentOutOfBoundsPolys,1)
                    [inOOB,onOOB] = inpolygon(particleLocation(:,1), particleLocation(:,2), polygon.currentOutOfBoundsPolys(outOfBoundsCount,:,1), polygon.currentOutOfBoundsPolys(outOfBoundsCount,:,2));
                    inOnOOB = (inOOB|onOOB); %Or together to get anything that is in or on the polygon
                    if(any(inOnOOB))
                        repmatLength = length(inOnOOB);
                        wallContactVector = repmat(polygon.currentPolyVector(outOfBoundsCount,:),repmatLength,1);
                        orthogonalWallContactVector = repmat(polygon.currentHardCodedOrthogonalWallContacts(outOfBoundsCount,:),repmatLength,1);
                        wallContact(inOnOOB == 1,:) = wallContactVector(inOOB == 1,:);
                        orthogonalWallContact(inOnOOB == 1,:) = orthogonalWallContactVector(inOnOOB == 1,:);
                        dists(inOnOOB == 1,:) = obj.distPointToLine(particleLocation(inOnOOB == 1,:), polygon.currentPoly(outOfBoundsCount,:), polygon.currentPoly(outOfBoundsCount + 1,:));
                    end
                end
                distMove = dists .* orthogonalWallContact;
                distMove(isnan(distMove)) = 0;
                particleLocation = particleLocation + distMove;
                
                parallelVelocity = particleLocation .* 0;
                perpendicularVelocity = parallelVelocity;
                testForSign = parallelVelocity;

                parallelVelocity(~in,:) = obj.vectorProjection(particleVelocity(~in,:),wallContact(~in,:));
                perpendicularVelocity(~in,:) = obj.vectorProjection(particleVelocity(~in,:),orthogonalWallContact(~in,:));
                testForSign(~in,:) = perpendicularVelocity(~in,:) .* orthogonalWallContact(~in,:);
                perpendicularVelocity(testForSign < 0) = perpendicularVelocity(testForSign < 0).*-1;  %bounce particles off wall by inverting any momentum into the wall.
%                perpendicularVelocity(testForSign < 0) = 0;% perpendicularVelocity(testForSign < 0).*-1;  %bounce particles off wall by inverting any momentum into the wall.
                   
                particleVelocity = particleVelocity .* in + parallelVelocity + perpendicularVelocity;                
            end
        end
        
        function velocity = calculateFlow(obj, particleLocation, flowMatrix, mesh)%, axes) 
            %{    
                plot(axes, mesh.Nodes(1,:), mesh.Nodes(2,:), '.','markerSize', 5 , 'color', 'red'); %visualise nodes
                
                flowMatrix = flowMatrix .* 3000;
    
                for i = 1:size(mesh.Nodes,2)
                    ab = plot(axes, mesh.Nodes(1,i), mesh.Nodes(2,i), '.', 'markerSize', 23, 'color', 'yellow');
                    abz = plot(axes,[mesh.Nodes(1,i); mesh.Nodes(1,i) + flowMatrix(i,1)], [mesh.Nodes(2,i); mesh.Nodes(2,i) + flowMatrix(i,2)], 'color', 'red');
                    flowVel = flowMatrix(i,:)
                    abc(1,:) = [i i+11];
                    abc(2,:) = flowMatrix(i,:);
                    delete(ab);
                    delete(abz);
                end
            %}
            if(size(mesh.Points,1) == size(flowMatrix,1))
              %  closestNode = findNodes(mesh, 'nearest', particleLocation');
                closestNode = nearestNeighbor(mesh,particleLocation);
                velocity(:,1) = flowMatrix(closestNode,1);
                velocity(:,2) = flowMatrix(closestNode,2);
            else
                velocity = [0 0];
            end
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
        
        function force = calculateFrictionForce(obj, particleVelocity, particleForce, orthogonalWallContact)
            trueParticleVelocity = sum(abs(particleVelocity),2);
            movingParticles = trueParticleVelocity > 0;
            coefficient = particleVelocity(:,1) .* 0;
            coefficient(movingParticles == 1) = obj.movingFrictionCoefficient;
            coefficient(coefficient == 0) = obj.staticFrictionCoefficient;
            force = obj.matrixVectorProjection(particleForce, orthogonalWallContact) .* coefficient;

            testForSign = force .* orthogonalWallContact; %TODO need to check this...
            force(testForSign > 0) = 0;
            force(particleForce < 0 & force > 0) = force(particleForce < 0 & force > 0) .* -1; %Make  sign match force to allow it to be negated later
            force(particleForce > 0 & force < 0) = force(particleForce > 0 & force < 0) .* -1; %Make  sign match force to allow it to be negated late
            %Using the normal force, must convert to correct dimension
            tempForce = force(:,1);
            force(:,1) = force(:,2);
            force(:,2) = tempForce;
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
            hypotheticalDeltaVelocity = currentAcceleration .* timeSinceLastUpdate; 
%             hypotheticalDeltaVelocity = 0.5.*(currentAcceleration + previousAcceleration).* timeSinceLastUpdate; %timeSinceLastUpdate must be fairly constant for this to work - maybe avg time?
                                                                                                                    %This is v = u+at : the 0.5 is _averaging_ the accelerations.
            
            velocityOrthogonalToWallContact = obj.matrixVectorProjection(hypotheticalDeltaVelocity,orthogonalWallContact);
            testForSign = velocityOrthogonalToWallContact .* orthogonalWallContact;
            velocityOrthogonalToWallContact(testForSign < 0) = 0;
            wallContactVelocity = obj.matrixVectorProjection(hypotheticalDeltaVelocity,wallContact) + velocityOrthogonalToWallContact;
            hypotheticalDeltaVelocity = hypotheticalDeltaVelocity .* isnan(wallContact) + wallContactVelocity;

            
            rateOfChange = (hypotheticalDeltaVelocity - previousVelocity) ./ previousVelocity; 
            capRateofChangeAt = (1*10e3 .* abs(previousVelocity./10) + 0.1).^-2;
            capRateofChangeAt(capRateofChangeAt < 0.1) = 0.1; %limit the lower end.
            rateOfChange(isinf(rateOfChange)) = intmax;
            rateOfChange(isnan(rateOfChange)) = 0;
            %yes, this is aboslutely required, otherwise we IMMEDIATELY get
            %lots of errors
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
            velocity = (previousVelocity + hypotheticalDeltaVelocity);% .* ~haltTheseParticles;
        end
        
        function location = calculateCurrentLocationCD(obj,previousLocation, previousVelocity, previousAcceleration, timeSinceLastUpdate)
            location = previousLocation + previousVelocity .* timeSinceLastUpdate + 0.5.*previousAcceleration.*timeSinceLastUpdate^2;
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
            %TODO THIS DOESN'T WORK!
          %  unCheckedLocation = particleLocation + obj.realNum(particleVelocity .* timeModifier);
          %  [location,newVelocity] = calculateCollisionsAfter(obj, particleLocation, unCheckedLocation, particleVelocity, timeModifier);
            %Comment above and Uncomment below to prevent particleCollisions
            location = particleLocation + obj.realNum(particleVelocity);
            newVelocity = particleVelocity;
        end
        
        function particleLocations = generateParticleLocations(obj, poly, particleLocationsLength)
            if(true)
                particleLocations = obj.fiftyParticleStartLocations;
            else
                [xlim ylim] = boundingbox(polyshape(poly));
                particleLocationIndex = 1;
                particleLocations = zeros(length(particleLocationsLength), 2);
                %init return value
                while(particleLocationIndex <= particleLocationsLength)
                    particleLocations(particleLocationIndex,:) = real([xlim(1), ylim(1)] + [xlim(2)-xlim(1),ylim(2)-ylim(1)] .* rand(1, 2));
                    particleLocationXValue = particleLocations(particleLocationIndex,1);
                    particleLocationYValue = particleLocations(particleLocationIndex,2);
                    if(inpolygon(particleLocationXValue,particleLocationYValue,poly(:,1), poly(:,2)))
                        particleLocationIndex = particleLocationIndex + 1;
                    end
                end
            end
        end
        
        function inGoalZone = isParticleInEndZone(obj, goalZones, particleLocations)
            inGoalZone = zeros(size(particleLocations,1),size(goalZones,2));
            for goalZoneIndex = 1:size(goalZones,1)
                [in,on] = inpolygon(particleLocations(:,1), particleLocations(:,2), goalZones(goalZoneIndex,:,1), goalZones(goalZoneIndex,:,2));
                inGoalZone(:,goalZoneIndex) = in | on;
            end
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
            for pointIndex = 1:size(point,1)
                a = lineA - lineB;
                b = point(pointIndex,:) - lineB;
                a(3) = 0;
                b(3) = 0;
                dist(pointIndex) = norm(cross(a,b)) / norm(a);
            end
        end
        
        %vector projection of AB along line CD
        %To get vector rejection, just do AB - obj.vectorProjection(AB,CD)
        function vec = vectorProjection(obj, AB, CD)
            vec = obj.realNum((dot(AB,CD) / dot(CD, CD)) * CD);
        end
        function matVec = matrixVectorProjection(obj,AB,CD)
            matVec = obj.realNum(dot(AB,CD,2) ./ dot(CD,CD,2) .* CD); %TODO - division - is this correct?
        end
        
        %Fix matlabs tendency to make doubles into imaginary numbers
        function num = realNum(obj,num)            
            num(isinf(num)) = 0;
            num(isnan(num)) = 0;
            num = real(num);
        end
    end
end

