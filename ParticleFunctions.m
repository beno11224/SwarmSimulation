classdef ParticleFunctions
    properties
        magneticForceConstant; %TODO ALL of these need to be calculated at a relevant point
                %(obj.permFreeSpace * xOneCurrent * xRadius^2) / (2*(xRadius^2 + (obj.particleLocation(1)+0.1)^2)^(3/2));
        dragForceConstant;
        dipoleForceConstant;
        particleDiameter; 
        staticFrictionCoefficient;
        movingFrictionCoefficient;
        particleMass;
        workspaceSizePositive;%use for the positive limits!
        workspaceSizeMinus; %use for negative limits
    end
    methods (Access = public)
        %Constructor
        function obj = ParticleFunctions(permeabilityOfFreeSpace, particleDiameter, particleMass, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize)
            obj.magneticForceConstant = double(permeabilityOfFreeSpace * (particleDiameter/2)^2 * 10^5);
            obj.dragForceConstant = double(3*pi*fluidViscocity * particleDiameter);
            obj.dipoleForceConstant = double(3*permeabilityOfFreeSpace / 4*pi);
            obj.staticFrictionCoefficient = staticFrictionCoefficient;
            obj.movingFrictionCoefficient = motionFrictionCoefficient;
            obj.particleMass = particleMass;
            obj.particleDiameter = particleDiameter;
            obj.workspaceSizePositive = workspaceSize;
            obj.workspaceSizeMinus = -1 * workspaceSize;
        end
        %So user can change parameters on the fly
        function obj = ChangeMetaValue(obj, permeabilityOfFreeSpace, particleDiameter, particleMass, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient, workspaceSize)
            obj.magneticForceConstant = double(permeabilityOfFreeSpace * (particleDiameter/2)^2 * 10^6);
            obj.dragForceConstant = double(3*pi*fluidViscocity * particleDiameter);
            obj.dipoleForceConstant = double(3*permeabilityOfFreeSpace / 4*pi);
            obj.staticFrictionCoefficient = staticFrictionCoefficient;
            obj.movingFrictionCoefficient = motionFrictionCoefficient;
            obj.particleMass = particleMass;
            obj.particleDiameter = particleDiameter;
            obj.workspaceSizePositive = workspaceSize;
            obj.workspaceSizeMinus = -1 * workspaceSize;
        end
        %public functions
        function force = calculateMagneticForce(obj, particleLocation, aCoils, bCoils)
            %a coils 'push' in the positive direction, b coils 'push' in
            %the negative direction
            particleLocation(particleLocation < obj.workspaceSizeMinus) = obj.workspaceSizeMinus; %pretend that the particles don't reach the magnetic centres, or it messes up calculations.
            particleLocation(particleLocation > obj.workspaceSizePositive) = obj.workspaceSizePositive;
            %good breakpoint condition: any(any(particleLocation > obj.workspaceSizePositive))
            force = double((obj.magneticForceConstant .* aCoils) ./ ((particleLocation + (0.999 * obj.workspaceSizePositive)).^1.5) + (obj.magneticForceConstant .* bCoils) ./ (((2 * obj.workspaceSizePositive) - (particleLocation + (0.999 * obj.workspaceSizePositive))).^ 1.5));
            force(isinf(force)) = 0;
            force(isnan(force)) = 0;
        end
        function force = calculateDipoleForce(obj, particleLocation, particleTorque)
            xYDistances = particleLocation - permute(particleLocation,[3,2,1]);
            distances = permute(sqrt(abs(xYDistances(:,1,:).^2 + xYDistances(:,2,:).^2)),[1,3,2]);
            distances(isnan(distances)) = 0;
            dipoleMoments = double(sum(particleTorque,2) .* distances);
            dipoleMoments = dipoleMoments .* dipoleMoments.';
            normalisedDipoleMoment = dipoleMoments ./ distances.^-4;
            combinedForce = obj.dipoleForceConstant .* sum(normalisedDipoleMoment,2); %sum along '2'axis to make it 5x1
            %now convert back to 5x2, x & y for the final result
            distSum = permute(sum(xYDistances,1),[3,2,1]);
            force = combinedForce .* distSum;
            %force = dipoleConstant * sum(1-5.*(normalisedDipoleMoment).^2 .* distances + 2.*(normalisedDipoleMoment).*particleTorque,3); %can't do Mci * Mcj/r^4 in this way
        end
        function force = calculateDragForce(obj, particleVelocity)
            force = particleVelocity .* obj.dragForceConstant; %Something here is broken - Drag force can't force the particle the wrong way??
        end
        function [wallContact, particleLocation, particleVelocity] = isParticleOnWallPIP(obj, particleLocation, particleVelocity, particleForce, polygon, tMax)
            in = inpolygon(particleLocation(:,1), particleLocation(:,2), polygon.currentPoly(:,1), polygon.currentPoly(:,2));

            %https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
            particleVelocityVectorS = squeeze(repmat(-particleVelocity.*tMax,[1,1,length(polygon.currentPolyVector)]));
            polygonVectorR = permute(repmat(polygon.currentPolyVector', [1,1,size(particleVelocity,1)]),[3,1,2]);
            particleStartQ = squeeze(repmat(particleLocation,[1,1,length(polygon.currentPolyVector)])); %Dodgy using other vars for length here, but hopefully won't be an issue as they must be the same length
            polyLineStartP = permute(repmat(polygon.currentPoly(1:end-1,:)', [1,1,size(particleVelocity,1)]),[3,1,2]); %Are we looking at all the lines here? or not all of them
            startDistanceQP = (particleStartQ - polyLineStartP);
            startDistancePolyVectorCrossProductQPR = obj.crossProduct(startDistanceQP(:,1,:), startDistanceQP(:,2,:), polygonVectorR(:,1,:), polygonVectorR(:,2,:));
            vectorCrossProductRS = obj.crossProduct(polygonVectorR(:,1,:), polygonVectorR(:,2,:), particleVelocityVectorS(:,1,:), particleVelocityVectorS(:,2,:));
            timeParticleCrossedLine = startDistancePolyVectorCrossProductQPR./vectorCrossProductRS;
            a = timeParticleCrossedLine;
            amin = min(abs(timeParticleCrossedLine),[],2);
            timeParticleCrossedLine(timeParticleCrossedLine<0) = NaN;
            timeParticleCrossedLine(timeParticleCrossedLine == 0) = NaN; %0 to prevent errors in min calculation
            
            %TODO what about when the particle hits a second line? particle
            %will clip through one line then will be considered to be not
            %passing a line. This below code MUST reflect that this can
            %happen.
            
            %rename tmin
            [minTime,loc] = min(timeParticleCrossedLine,[],2);
            minTime = minTime(:,:,3);
            minTime(isinf(minTime)) = 0;
            minTime(isnan(minTime)) = 0;
            %don't like this 1 - I think it's wrong? tbh do we actually
            %care about this?
            %minTime(abs(minTime) > 1 ) = 0; %cap the change at 1 to ignore the impossible intersections
            %><><This should now match up with ~in
            %Instead using ~in to selectively remove ones we don't need.
            minTime = minTime .* ~in;
            %minTime(minTime == 0) = 1;
            
            %remember tMax is the TIME not a DISTANCE
            %location is current, velocity and tMax are from the previous calculations
            %reverseVelocityAmmount = ((-minTime + 1) ./ tMax) .* particleVelocity;
            reverseVelocityAmmount = minTime .* -particleVelocity; %Think it's simple as this...
            particleLocation = particleLocation + reverseVelocityAmmount; %plus as the particleVelocity was negative
            %reverseVelocityScalar = (-minTime + 1) .* tMax.*norm(particleVelocity); % get components of this velocity reverse - a^2 + b^ 2 = c ^ 2
            %a = obj.scalarToVector(reverseVelocityScalar, particleVelocity);
            %a(isinf(a)) = 0;
            %a(isnan(a)) = 0;
            %particleLocation = particleLocation - a; %Just use the point of intersection, if the particle needs to be moved??
           
            %WallContact shows the vector orthogonal to the wall. All other values in 
            %WallContact are nans to show there is no contact
            wallContact = polygon.currentPolyVector(loc(:,:,3),:);
            wallContact = wallContact .* ~in;
            wallContact = wallContact ./ norm(wallContact); %to unit vector
            wallContact(~any(wallContact,2),:) = NaN; %Set 1's to nan s?
        end
        
        function force = calculateFlowForce(obj, particleLocation, flowChart)
            %f = spline(flowChart, particleLocation(1,:))
            for particleCount = 1:length(particleLocation(1,:))
                searchArray = flowChart(1,:);
                while(length(searchArray) > 2)
                    a = particleLocation(particleCount,1);
                    midpoint = floor(length(searchArray)/2);
                    c = searchArray(midpoint);
                    if (particleLocation(particleCount,1) > searchArray(midpoint))
                        searchArray = searchArray(midpoint : length(searchArray));
                    else
                        searchArray = searchArray(1 : midpoint);
                    end
                end
                if(length(searchArray) == 2)
                    if(searchArray(1) > particleLocation(particleCount,1)) %TODO use the actual distance here, that will make it work
                        answer = searchArray(2);
                    else
                        answer = searchArray(1);
                    end
                else
                    answer = searchArray(1);
                end
            end
            %TODO make this matrix based
        end
       
        function force = calculateFrictionForce(obj, particleVelocity, particleForce, wallContact)
            totalVelocity = sum(abs(particleVelocity),2);
            movingParticles = totalVelocity > 0;
            ForceOnMovingParticles = wallContact .* movingParticles .* particleForce .* obj.movingFrictionCoefficient;
            ForceOnStationaryParticles = wallContact .* ~movingParticles .* particleForce .* obj.staticFrictionCoefficient;
            force = ForceOnMovingParticles + ForceOnStationaryParticles; %uncertain if this is working fully correct
        end
        
        function velocity = calculateParticlevelocityComponentFromForce(obj, particleForce, wallContact, timeSinceLastUpdate)
            velocity = (particleForce ./ obj.particleMass) .* timeSinceLastUpdate;

            %velocity = velocity.* wallContact; %but only where the velocity direction matches the wallContact?
            %UseWallContact to make sure that there is 0 velocity in the
            %wall direction - moving away from the wall is OK obviously.
            
            %calcualte veclocityMagnitude:
            %magnitude = norm(velocity);
            %rot = zeros(velocity);
            %Now multiply by the vector orthagonal to the wall
            for i = 1:length(velocity)
                if(any(~isnan(wallContact(i,:))))
                    rot = [wallContact(i,1) -wallContact(i,2); wallContact(i,2) wallContact(i,1)];
                    rotatedVector = rot * velocity(i,:)';
                    rotatedVector(1) = 0;
                    velocity(i,:) = (rot' * rotatedVector)';
                end
            end            
        end   
        
        function [newLocations, newVelocity] = calculateCollisionsAfter(obj, oldParticleLocation, newParticleLocation, particleVelocity, timeModifier)
            %Think the component part of this is wrong
            %Modify this to be similar to the wallContact code - ideally
            %take the collision part out to a shared function and just pass
            %in the relevant stuff.
            
            %get distances between each particle and all the others:            
            xYDistances = newParticleLocation - permute(newParticleLocation,[3,2,1]);
            distances = permute(sqrt(abs(xYDistances(:,1,:).^2 + xYDistances(:,2,:).^2)),[1,3,2]);
            distances(isnan(distances)) = 0;
            actualCollisions = distances < obj.particleDiameter / 2; %/2 for the radius
            actualCollisions = triu(actualCollisions,1);%everything above main diagonal. - means only one particle in a collision is moved
            %we have the collisions above, now move the particles...
            resetParticlesToCorrectLocations = sum(actualCollisions .* -1 .* distances,2);
            componentFraction = (particleVelocity ./ sum(particleVelocity,2)); %the fraction
            componentFraction(isnan(componentFraction)) = 0;
            componentFraction(isinf(componentFraction)) = 0;
            %occupied by each x/y component
            vectoredResetParticlesToCorrectLocations = componentFraction .* resetParticlesToCorrectLocations;
            vectoredResetParticlesToCorrectLocations(isnan(vectoredResetParticlesToCorrectLocations)) = 0;
            vectoredResetParticlesToCorrectLocations(isinf(vectoredResetParticlesToCorrectLocations)) = 0;
            
            newLocations = newParticleLocation + vectoredResetParticlesToCorrectLocations; %TODO this is super broken...
            %(xYDistances .* permute(actualCollisions,[1,3,2]))
            %newLocations = newParticleLocation - (actualCollisions .* xYDistances)
            %Now just the velocity perpendicular to the contact...
            newVelocity = particleVelocity .* ~any(actualCollisions,2);
            %particleDistanceDifferences = sum(oldParticleLocation - newParticleLocation,2)
            %newVelocity = particleVelocity - (resetParticlesToCorrectLocations ./ particleDistanceDifferences); %What is this?? This is so not right...
        end
        function [location, newVelocity] = moveParticle(obj, particleLocation, particleVelocity, timeModifier)
            %Below for if calculating collisions before
            %collidedParticles = calculateCollisions(particleLocation, particleVelocity, timeModifier)
            %possibleLocation = particleLocation + particleVelocity.* timeModifier;
            %fullMoveParticles = possibleLocation .* isNan(collidedparticles)
            %location = fullMoveParticles + collidedParticles;
            
            %Below if calculating collisions after
            unCheckedLocation = particleLocation + particleVelocity .* timeModifier;
            location = particleLocation + particleVelocity .* timeModifier;
            newVelocity = particleVelocity;
            %[location,newVelocity] = calculateCollisionsAfter(obj, particleLocation, unCheckedLocation, particleVelocity, timeModifier);
        end
        
        function particleLocations = generateParticleLocations(obj, poly, particleLocationsLength)
            [xlim ylim] = boundingbox(polyshape(poly));
            particleLocationIndex = 1;
            while(particleLocationIndex <= particleLocationsLength)
                particleLocations(particleLocationIndex,:) = [xlim(1), ylim(1)] + [xlim(2)-xlim(1),ylim(2)-xlim(1)] .* rand(1, 2);
                a = particleLocations(particleLocationIndex,1);
                b = particleLocations(particleLocationIndex,2);
                if(inpolygon(a,b,poly(:,1), poly(:,2)))
                    particleLocationIndex = particleLocationIndex + 1;
                end
            end
        end
        
        function inGoalZone = isParticleInEndZone(poly, particleLocations)
            inGoalZone = inpolyon(particleLocations, poly);
            %TODO maybe put other goal zone logic in here?
        end
    end
    methods (Access = private)        
        function AB = crossProduct(obj, Ax, Ay, Bx, By)
            AB(:,:,3) = Ax.*By-Ay.*Bx; %No idea if this is right or not... lets try it!
        end
        %C must be scalar, AB must be vector
        function vec = scalarToVector(obj,C,AB)
            vec = (AB./norm(AB)) .* C;            
        end
    end
end

