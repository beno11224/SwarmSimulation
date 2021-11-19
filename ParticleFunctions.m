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
             %Dodgy using other vars for length here, but hopefully won't be an issue as they must be the same length
            particleStartQ = squeeze(repmat(particleLocation,[1,1,length(polygon.currentPolyVector)]));
            polyLineStartP = permute(repmat(polygon.currentPoly(1:end-1,:)', [1,1,size(particleVelocity,1)]),[3,1,2]);
            startDistanceQP = (particleStartQ - polyLineStartP);
            startDistancePolyVectorCrossProductQPR = obj.crossProduct(startDistanceQP(:,1,:), startDistanceQP(:,2,:), polygonVectorR(:,1,:), polygonVectorR(:,2,:));
            vectorCrossProductRS = obj.crossProduct(polygonVectorR(:,1,:), polygonVectorR(:,2,:), particleVelocityVectorS(:,1,:), particleVelocityVectorS(:,2,:));
            timeParticleCrossedLine = startDistancePolyVectorCrossProductQPR./vectorCrossProductRS;
            timeParticleCrossedLine(timeParticleCrossedLine<0) = NaN;
            timeParticleCrossedLine(timeParticleCrossedLine == 0) = NaN; %0 to prevent errors in min calculation
            
            %TODO what about when the particle hits a second line? particle
            %will clip through one line then will be considered to be not
            %passing a line. This below code MUST reflect that this can
            %happen.
            
            [minTimeModifier,loc] = min(timeParticleCrossedLine,[],2);
            minTimeModifier = minTimeModifier(:,:,3);
            minTimeModifier(isinf(minTimeModifier)) = 0;
            minTimeModifier(isnan(minTimeModifier)) = 0;
            minTimeModifier = minTimeModifier .* ~in; %So we only care about the particles that are not in the space
            
            %remember tMax is the TIME not a DISTANCE
            %Similarly minTimeModifier is a Multiplier of TMAX
            %(it means nothing on it's own!)
            %location is current, velocity and tMax are from the previous calculations
            %reverseVelocityAmmount = ((-minTime + 1) ./ tMax) .* particleVelocity;
            reverseVelocityAmmount = ((minTimeModifier.*tMax) .* -particleVelocity) .* 1.015; %Think it's simple as this...
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
            %flowChart must be a nxn matrix. calculate the position of the
            %particle as a factor of the gamespace (0..1), say [0.6 0.4].
            %Then get the index that is that factor of the flowChart, and
            %that's the force?            
            factorPosition = (particleLocation + obj.workspaceSizePositive) ./ (obj.workspaceSizePositive*2);
            flowChartNumericalPosition = round(factorPosition .* size(flowChart));
            flowChartNumericalPosition(flowChartNumericalPosition == 0) = 1; %TODO confirm this indexing is correct.
            flowChartIndex = sub2ind(size(flowChart),flowChartNumericalPosition(:,1),flowChartNumericalPosition(:,2));
            force = flowChart(flowChartIndex); % might need to add more functionality in here?
        end
       
        function force = calculateFrictionForce(obj, particleVelocity, particleForce, wallContact)            
            totalVelocity = sum(abs(particleVelocity),2);
            movingParticles = totalVelocity > 0;
            force = zeros(size(particleForce));
            for i = 1:length(particleForce)
                if(any(~isnan(wallContact(i,:))))
                    %Use vector rejection to project force into the wall.
                    %Must check if this force is into the wall or not...
                    fOne = particleForce(i,:) - (dot(particleForce(i,:),wallContact(i,:)) / dot(wallContact(i,:), wallContact(i,:)) * wallContact(i,:));
                    if(movingParticles(i))
                        force(i,:) = fOne .*obj.movingFrictionCoefficient;
                    else
                        force(i,:) = fOne .*obj.staticFrictionCoefficient; %Don't hit this - if the particle is on the wall it must have velocity due to point maths.
                    end
                end
            end
            
            % totalVelocity = sum(abs(particleVelocity),2);
           % movingParticles = totalVelocity > 0;
           % force = zeros(size(particleForce));
           % for i = 1:length(particleVelocity)
           %     if(any(~isnan(wallContact(i,:))))
           %         rot = [wallContact(i,1) -wallContact(i,2); wallContact(i,2) wallContact(i,1)]; %wall Contact is a unit vector here
           %         rotatedForce = rot * particleForce(i,:)';
           %         rotatedForce(2) = 0;
           %         if(movingParticles(i))                        
           %             rotatedForce(1) = rotatedForce(1) .* obj.movingFrictionCoefficient;
           %         else                    
           %             rotatedForce(1) = rotatedForce(1) .* obj.staticFrictionCoefficient;
           %         end
           %         force(i,:) = (rot' * rotatedForce)';                    
           %     end
           % end
            %ForceOnMovingParticles = wallContact .* movingParticles .* particleForce .* obj.movingFrictionCoefficient;
            %ForceOnStationaryParticles = wallContact .* ~movingParticles .* particleForce .* obj.staticFrictionCoefficient;
            %force = ForceOnMovingParticles + ForceOnStationaryParticles; %uncertain if this is working fully correct
        end
        
        function velocity = calculateCumulativeParticlevelocityComponentFromForce(obj, particleForce, oldVelocity, wallContact, timeSinceLastUpdate)
            velocity = oldVelocity + (particleForce ./ obj.particleMass) .* timeSinceLastUpdate;

            for i = 1:length(velocity)
                if(any(~isnan(wallContact(i,:))))
                    %Use vector projection to restrict the velocity to only
                    %along a wall if applicable - may possibly be an issue
                    %with perfectly parallel lines, shouldn't come up.
                    velocity(i,:) = dot(velocity(i,:),wallContact(i,:)) / dot(wallContact(i,:), wallContact(i,:)) * wallContact(i,:);
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
            %unCheckedLocation = particleLocation + particleVelocity .* timeModifier;
            %[location,newVelocity] = calculateCollisionsAfter(obj, particleLocation, unCheckedLocation, particleVelocity, timeModifier);
            
            location = particleLocation + particleVelocity .* timeModifier;
            newVelocity = particleVelocity;
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
        
        function AB = crossProduct(obj, Ax, Ay, Bx, By)
            AB(:,:,3) = Ax.*By-Ay.*Bx; %No idea if this is right or not... lets try it!
        end
        %C must be scalar, AB must be vector
        function vec = scalarToVector(obj,C,AB)
            vec = (AB./norm(AB)) .* C;            
        end
    end
end

