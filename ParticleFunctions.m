classdef ParticleFunctions
    properties
        equivalentDiameter;
        magneticForceConstant;
        dragForceConstant;
        dipoleForceConstant;
        staticFrictionCoefficient;
        movingFrictionCoefficient;
        particleMass;
        workspaceSizePositive;%use for the positive limits
        workspaceSizeMinus; %use for negative limits
        fiftyParticleStartLocations;
    end
    methods (Access = public)
        %Constructor
        function obj = ParticleFunctions(permeabilityOfFreeSpace, magneticField, individualDiameter, particleDensity, chainLength, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize)
            obj = obj.ChangeMetaValues(permeabilityOfFreeSpace, magneticField, individualDiameter, particleDensity, chainLength, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize);
        end
        
        function obj = ChangeMetaValues(obj,permeabilityOfFreeSpace, magneticField, individualDiameter, particleDensity, chainLength, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize)
            msat = 1 + 19 * (magneticField .* 10).^(0.16);
            obj.equivalentDiameter =  (3*chainLength * individualDiameter^3 )^(1/3);
            obj.magneticForceConstant = double(permeabilityOfFreeSpace .* msat.* particleDensity .* 1000 .* 4/3.*pi.*(obj.equivalentDiameter/2)^3);
            obj.dragForceConstant = double(3*pi * fluidViscocity * individualDiameter); 
            obj.dipoleForceConstant = double(3*permeabilityOfFreeSpace / 4*pi);
            obj.staticFrictionCoefficient = staticFrictionCoefficient;
            obj.movingFrictionCoefficient = motionFrictionCoefficient;
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

        %Only used for NN control, the state needs to be known.
        function matState = getState(obj, particleArrayLocation, FlowRate, xOffset, yOffset)
            xLoc = (particleArrayLocation(:,1) + xOffset).*100;
            yLoc = (particleArrayLocation(:,2) + yOffset).*100;
            covar = cov(xLoc,yLoc);
            covar = covar(1,2);
            matState = [std(xLoc), std(yLoc),covar, sum(xLoc)./size(xLoc,1), sum(yLoc)./size(yLoc,1), FlowRate, xOffset, yOffset];
        end

        function force = calculateMagneticForce(obj, aCoils,joyStick, h, v, controlMethod, mouseLocation, magForceRestrict, rotation, maxUserForce)
            %Fetch the input - how it's fetched is determined by the
            %'controlMethod' variable, changed in NextLevel or in the UI
            %before runtime.
            switch(controlMethod)      
                case("Keyboard")
                    totalForce = aCoils.* 10^6;
                case("Mouse")
                    totalForce = mouseLocation .* maxuserForce*10^8; %Mouse Force is a bit lower than the others
                case("Controller")
                    newHapticValues = ReadHaptic() .* (1/0.077);
                    if magForceRestrict ~= 0
                        newHapticValues = newHapticValues .* (magForceRestrict/maxUserForce);
                    end
                    totalForce = [newHapticValues(1)*10^6, newHapticValues(2)*10^6];
                case("TrainingModel")
                    totalForce = aCoils * 10^6;
                otherwise
                    totalForce = [0 0];
            end
            %If the force is too big then limit it
            if(norm(totalForce) > maxUserForce*10^6)
                totalForce = totalForce ./ norm(totalForce) .* maxUserForce*10^6;
            end
            %rotate the force after multiplying by the constant determined
            %in construction.
            force = ([cosd(-rotation), sind(-rotation); -sind(-rotation), cos(-rotation)] * (obj.magneticForceConstant .* totalForce)')' ;
        end

        function particleVelocity = calculateDragForceFromMagForce(obj, magForce, flowVelocity)
            particleVelocity = (magForce ./ obj.dragForceConstant) + flowVelocity; %+ or -?
        end

        %used to keep particles within the polygon. Does not include
        %friction, that is separate but is also based on location.
        function [wallContact, orthogonalWallContact, particleLocation, particleVelocity, bouncedLastLoop] = isParticleOnWallPIP(obj, particleLocation, particleVelocity, particleForce, polygon, tMax,app, bouncedLastLoop)
            %this just returns anything INSIDE the polygon, not anything on the walls
            in = inpolygon(particleLocation(:,1), particleLocation(:,2), polygon.currentPoly(:,1), polygon.currentPoly(:,2));

            wallContact = particleVelocity .* nan;
            orthogonalWallContact = wallContact;
            %If no particles are outside the shape, we can skip all this.
            if(any(~in))
                distMove = particleVelocity .*  0;
                dists = zeros(length(wallContact),1);
                for outOfBoundsCount = 1:size(polygon.currentOutOfBoundsPolys,1)
                    [inOOB,onOOB] = inpolygon(particleLocation(:,1), particleLocation(:,2), polygon.currentOutOfBoundsPolys(outOfBoundsCount,:,1), polygon.currentOutOfBoundsPolys(outOfBoundsCount,:,2));
                    inOnOOB = (inOOB|onOOB); %Or together to get anything that is in or on the polygon
                    if(any(inOnOOB))
                        %determine, for any particles outside the polygon
                        %play space, the orthogonal distance to the nearest
                        % line, which should be the one jumped over
                        repmatLength = length(inOnOOB);
                        wallContactVector = repmat(polygon.currentPolyVector(outOfBoundsCount,:),repmatLength,1);
                        orthogonalWallContactVector = repmat(polygon.currentHardCodedOrthogonalWallContacts(outOfBoundsCount,:),repmatLength,1);
                        wallContact(inOnOOB == 1,:) = wallContactVector(inOOB == 1,:);
                        orthogonalWallContact(inOnOOB == 1,:) = orthogonalWallContactVector(inOnOOB == 1,:);
                        dists(inOnOOB == 1,:) = obj.distPointToLine(particleLocation(inOnOOB == 1,:), polygon.currentPoly(outOfBoundsCount,:), polygon.currentPoly(outOfBoundsCount + 1,:));
                    end
                end
                %Move the particles to where they should be from their
                %velocities
                distMove = dists .* orthogonalWallContact;
                distMove(isnan(distMove)) = 0;
                particleLocation = particleLocation + distMove;
                
                parallelVelocity = particleLocation .* 0;
                perpendicularVelocity = parallelVelocity;
                testForSign = parallelVelocity;

                %now determine which particles should bounce
                parallelVelocity(~in,:) = obj.vectorProjection(particleVelocity(~in,:),wallContact(~in,:));
                perpendicularVelocity(~in,:) = obj.vectorProjection(particleVelocity(~in,:),orthogonalWallContact(~in,:));
                testForSign(~in,:) = perpendicularVelocity(~in,:) .* orthogonalWallContact(~in,:);
                %bounce particles off wall by inverting any momentum into the wall.                
                perpendicularVelocity(testForSign < 0) = perpendicularVelocity(testForSign < 0).*-1;  
                %If particles have bounced too many times then they are
                %halted to prevent explosive velocities
                perpendicularVelocity(bouncedLastLoop == 1,:) = 0;
                particleVelocity = particleVelocity .* in + parallelVelocity + perpendicularVelocity;            
            end
            %store if the particles bounced off the wall - this is
            %considered when drawing the particles
            bouncedLastLoop = ~in;
        end
        
        %Find the closest node in the flow mesh, then use that value as the
        %flow velocity
        function velocity = calculateFlow(obj, particleLocation, flowMatrix, mesh)
            if(size(mesh.Points,1) == size(flowMatrix,1))
                closestNode = nearestNeighbor(mesh,particleLocation);
                velocity(:,1) = flowMatrix(closestNode,1);
                velocity(:,2) = flowMatrix(closestNode,2);
            else
                %can't find a node - best to just set flow to 0 so the
                %program can run
                velocity = [0 0];
            end
        end
               
        %Determine the fricitonal force on any particles that are at the
        %boundary. This is sped up by using matrices
        function force = calculateFrictionForce(obj, particleVelocity, particleForce, orthogonalWallContact)
            %which particles are moving
            trueParticleVelocity = sum(abs(particleVelocity),2);
            movingParticles = trueParticleVelocity > 0;

            %setup coefficients
            coefficient = particleVelocity(:,1) .* 0;
            coefficient(movingParticles == 1) = obj.movingFrictionCoefficient;
            coefficient(coefficient == 0) = obj.staticFrictionCoefficient;
            %Now apply those coeffificients to particles that are near the
            %wall
            force = obj.matrixVectorProjection(particleForce, orthogonalWallContact) .* coefficient;
            testForSign = force .* orthogonalWallContact;

            %double check the signs
            force(testForSign > 0) = 0;
            force(particleForce < 0 & force > 0) = force(particleForce < 0 & force > 0) .* -1; %Make  sign match force to allow it to be negated later
            force(particleForce > 0 & force < 0) = force(particleForce > 0 & force < 0) .* -1; %Make  sign match force to allow it to be negated later
            %Using the normal force, must convert to correct dimension
            tempForce = force(:,1);
            force(:,1) = force(:,2);
            force(:,2) = tempForce;
        end
                
        % function acceleration = calculateAcceleration(obj,particleForce, particleMass)
        %     acceleration = particleForce ./ particleMass;
        % end
        
        % function velocity = calculateDeltaVelocity(obj,particleForce, particleMass, timeSinceLastUpdate)
        %     velocity = obj.calculateAcceleration(particleForce, particleMass) ./ timeSinceLastUpdate;
        % end
        
        %Turn the forces applied into a velocity
        % function [velocity,acceleration,hypotheticalDeltaVelocity] = calculateCurrentVelocityCD(obj, orthogonalWallContact, wallContact, previousVelocity, previousAcceleration, particleForce, particleMass, timeSinceLastUpdate, magForce)            
        %     %using acceleration, give a velocity change
        %     currentAcceleration = obj.calculateAcceleration(particleForce, particleMass);
        %     hypotheticalDeltaVelocity = currentAcceleration .* timeSinceLastUpdate;
        % 
        %     %Now make sure that any particles that go out of bounds are
        %     %bounced back into the play area
        %     velocityOrthogonalToWallContact = obj.matrixVectorProjection(hypotheticalDeltaVelocity,orthogonalWallContact);
        %     testForSign = velocityOrthogonalToWallContact .* orthogonalWallContact;
        %     velocityOrthogonalToWallContact(testForSign < 0) = 0;
        %     wallContactVelocity = obj.matrixVectorProjection(hypotheticalDeltaVelocity,wallContact) + velocityOrthogonalToWallContact;
        %     hypotheticalDeltaVelocity = hypotheticalDeltaVelocity .* isnan(wallContact) + wallContactVelocity;
        % 
        %     %checkForSign = (previousVelocity+hypotheticalDeltaVelocity).*previousVelocity;
        % 
        %     %determine the rate of change, it's useful in a second
        %     rateOfChange = (abs(hypotheticalDeltaVelocity) - abs(previousVelocity)) ./ abs(previousVelocity);
        %     capRateofChangeAt = 0.002.* 2.^(-1 .* log10(abs(previousVelocity))); %%Size must be changed here
        %     capRateofChangeAt(capRateofChangeAt>1500) = 1500;
        %     rateOfChange(isinf(rateOfChange)) = intmax;
        %     rateOfChange(isnan(rateOfChange)) = 0;
        %     %yes, this is aboslutely required, otherwise errors
        %     %Use a rate of change cap to damp any big oscillations.
        %     if(any(any(rateOfChange > capRateofChangeAt)))
        %         cappedRateOfChange = rateOfChange;
        %         capRateofChangeAt(capRateofChangeAt == 0) = abs(rateOfChange(capRateofChangeAt == 0)); %If there is no rate of change this is an error above. don't cap change.
        %         cappedRateOfChange(rateOfChange > capRateofChangeAt) = capRateofChangeAt(rateOfChange > capRateofChangeAt); %cap it
        %         %set the capped deltaVelocity
        %         checkChangeSign = previousAcceleration.*hypotheticalDeltaVelocity;
        %         hypotheticalDeltaVelocity = obj.realNum((cappedRateOfChange./rateOfChange) .* hypotheticalDeltaVelocity);
        %         hypotheticalDeltaVelocity(checkChangeSign<0) = hypotheticalDeltaVelocity(checkChangeSign<0)./50;
        %         %set the capped acceleration
        %         acceleration = hypotheticalDeltaVelocity / timeSinceLastUpdate;  
        %     else
        %         acceleration = currentAcceleration;
        %     end            
        %     velocity = (previousVelocity + hypotheticalDeltaVelocity);
        % end
        
        %using a variant of suvat, determine th new location: 
        % s= ut + 1/2(at^2)
     %   function location = calculateCurrentLocationCD(obj,previousLocation, previousVelocity, previousAcceleration, timeSinceLastUpdate)
     %       location = previousLocation + previousVelocity .* timeSinceLastUpdate + 0.5.*previousAcceleration.*timeSinceLastUpdate^2;
     %   end
        
        %Random generation in the start zone for particle locations.
        %locations are generated in a bounding box, and then tested to see
        %if the location is in the start zone.
        function particleLocations = generateParticleLocations(obj, poly, particleLocationsLength)
            %set to true to not generate the locations, instead use the
            %locations stored at the top of this file. NumParticles MUST be
            %set to 50 or this will cause errors. Mainly used for testing.
             if(true && particleLocationsLength==50)
                particleLocations = obj.fiftyParticleStartLocations;
            else
                loopMax = ndims(poly);
                if(loopMax > 2)
                    loopMax = size(poly,1);
                else
                    loopMax = 1;
                end
                outerIndex = 1;
                particleLocations = zeros(length(particleLocationsLength), 2);
                for(loopCount = 1:loopMax)
                    innerIndex = 1;
                    if(loopMax == 1)
                        innerpoly = poly;
                    else
                        innerpoly = squeeze(poly(loopCount,:,:));
                    end
                    [xlim ylim] = boundingbox(polyshape(innerpoly));
                    %init return value
                    while(outerIndex <= particleLocationsLength)
                        particleLocations(outerIndex,:) = real([xlim(1), ylim(1)] + [xlim(2)-xlim(1),ylim(2)-ylim(1)] .* rand(1, 2));
                        particleLocationXValue = particleLocations(outerIndex,1);
                        particleLocationYValue = particleLocations(outerIndex,2);
                        if(inpolygon(particleLocationXValue,particleLocationYValue,innerpoly(:,1), innerpoly(:,2)))
                           % particleLocationIndex = particleLocationIndex + 1;
                            outerIndex = outerIndex + 1;
                            innerIndex = innerIndex + 1;
                        end
                        %If we have around enough particles in this
                        %partition then jump out so we can do the rest.
                        %Includes checking last one fills properly.
                        if((innerIndex > (particleLocationsLength/loopMax) && loopCount < loopMax) || outerIndex > particleLocationsLength)
                            break;
                        end
                    end
                end
            end
        end
        
        %Work out which of the denoted 'goal zones' the particles are in,
        %then return an array [NumParticles, NumGoals] detailing those
        %locations - if a particle is in a goal, that is represented by 1.
        %If it isn't, that's represented by 0. If there are no 1's in a
        %row, that particle is not in any goal.
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
        % function [line1Multiplier] = multiplierOfLineVectorOfIntersectionOfTwoLines(obj, line1StartQ, line1VectorS, line2StartP, line2VectorR)
        % 
        %     startDistanceQP = (line1StartQ - line2StartP);
        %     startDistanceLine2VectorCrossProductQPR = obj.crossProduct(startDistanceQP(:,1,:), startDistanceQP(:,2,:), line2VectorR(:,1,:), line2VectorR(:,2,:));
        %     vectorCrossProductRS = obj.crossProduct(line2VectorR(:,1,:), line2VectorR(:,2,:), line1VectorS(:,1,:), line1VectorS(:,2,:));
        %     line1Multiplier = obj.realNum(startDistanceLine2VectorCrossProductQPR./vectorCrossProductRS);
        % end

        %A helper function to create a mesh of the playspace, then write
        %those locations to a csv file for data manipulation.
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

