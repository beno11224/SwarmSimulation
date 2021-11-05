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
            s = squeeze(repmat(particleVelocity.*tMax,[1,1,length(polygon.currentPolyVector)]))';
            r = repmat(polygon.currentPolyVector', [1,size(particleVelocity,1)])';
            %r = permute(r,[3,1,2]);
            q = squeeze(repmat(particleLocation,[1,1,length(polygon.currentPolyVector)]))'; %Dodgy using other vars for length here, but hopefully won't be an issue as they must be the same length
            p = repmat(polygon.currentPoly(1:end-1,:)', [1,1,size(particleVelocity,1)])';
            %p = permute(p,[3,1,2]);
            %ssq = squeeze(s);
            %rsq = squeeze(r);
            asd = obj.crossProduct(s(:,1), s(:,2), r(:,1), r(:,2)); %was ssq
            %asc = (r ./ asd);
            asb = (q - p);
            asc = obj.crossProduct(asb(:,1), asb(:,2), r(:,1), r(:,2));
            tbleh = asc./asd;
            
            
            t = cross((q - p), (r ./ asd)); %t is not being calculated correctly here. not sure what to do... %cross A&B must be same size...
            %silly. it's not .*, it's a cross product!!!
            [tMin,loc] = min(t,[],3);
            a = s(loc); %Um, loc doesn't produce what I'm thinking it does - please try to work this out!
            b = t(loc);
            correctRow = s(:,:,loc(2));
            correctRow = correctRow .* ~in;
            wallContact = correctRow(:,:)./norm(correctRow(:,:)); %TODO !?!?!?!?!??!?!?!?!?!?!?!?!?!?!??! don't think this is getting the unit vectors correctly - want it to be by row.
            wallContact(isnan(wallContact)) = 0;
            wallContact(isinf(wallContact)) = 0;
            wallContact(~any(wallContact,2),:) = 1; %Should turn any rows that are not in contact with the wall to 1s?
            tMin = squeeze(tMin);
            tMin(isinf(tMin)) = 0;
            tMin(isnan(tMin)) = 0; %TODO <><><><><><><><><><><><>Removing all movement here - this is why the particles are carrying on.
            %Once the particles go out of the play area, they go to complex
            %numbers which messes other things up.
            c = abs(tMin);
            tMin(abs(tMin) > 1 ) = 0; %cap the change at 1 so it doesn't try to do anything wrong
            negatives = particleVelocity<0;
            particleVelocity = particleVelocity - particleVelocity .* tMin;
            particleVelocity(negatives ~= (particleVelocity<0) ) = 0; %set all values that don't match sign to 0 - inelastic.
            particleLocation = particleLocation - particleVelocity .* tMin; %Just use the point of intersection, if the particle needs to be moved??
                
            
            %WallContact should show the 'normal' direction to the
            %wall. Can multiply this by expected velocity to just get the
            %component force? All Other values in WallContact are 1s so it
            %doesn't affect the other values.
            %In short, wall contact is the wall normal force? (with
            %adjustment)
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
        
        function velocity = calculateParticlevelocityComponentFromForce(obj, particleForce, timeSinceLastUpdate)
            velocity = (particleForce ./ obj.particleMass) .* timeSinceLastUpdate;
        end   
        
        function [newLocations, newVelocity] = calculateCollisionsAfter(obj, oldParticleLocation, newParticleLocation, particleVelocity, timeModifier)
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
        function [location, newVelocity] = moveParticle(obj, particleLocation, particleVelocity, wallContact, timeModifier)
            %Below for if calculating collisions before
            %collidedParticles = calculateCollisions(particleLocation, particleVelocity, timeModifier)
            %possibleLocation = particleLocation + particleVelocity.* timeModifier;
            %fullMoveParticles = possibleLocation .* isNan(collidedparticles)
            %location = fullMoveParticles + collidedParticles;
            
            %Below if calculating collisions after
            unCheckedLocation = particleLocation + (particleVelocity .* wallContact)  .* timeModifier;
            [location,newVelocity] = calculateCollisionsAfter(obj, particleLocation, unCheckedLocation, particleVelocity, timeModifier);
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
    end
end

