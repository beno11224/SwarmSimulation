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
            obj.magneticForceConstant = double(permeabilityOfFreeSpace * (particleDiameter/2)^2 * 10^11);
            obj.dragForceConstant = double(3*pi*fluidViscocity * particleDiameter) * 10^6;
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
            particleLocation(particleLocation < obj.workspaceSizeMinus) = obj.workspaceSizeMinus; %limit values
            particleLocation(particleLocation > obj.workspaceSizePositive) = obj.workspaceSizePositive;
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
            force = particleVelocity .* obj.dragForceConstant;
        end
        function [wallContact, particleLocation, particleVelocity] = isParticleOnWallPIP(obj, particleLocation, particleVelocity, poly)
            %poly = [xlim, xlim; -xlim, xlim; -xlim, -xlim; -xlim, xlim]; % Make Poly an app.poly thing so it can be changed. Change line drawing too.
            in = inpolygon(particleLocation(:,1), particleLocation(:,2), poly(:,1), poly(:,2));
            %distanceMatrix = poly(n,1),poly(1,2)... 
            %Try to do this in matrix not in for loop.
            distances = zeros(length(particleLocation(:,2)),length(poly));
            for lineCount = 1:length(poly)
                if(~in(lineCount))
                    for pointCount = 1:length(particleLocation(:,2))
                        a = poly(lineCount,:) - poly(lineCount + 1,:); %what about last one? needs to link to start.
                        a(3) = 0;
                        b = particleLocation(pointCount,:) - poly(lineCount + 1,:);
                        b(3) = 0;
                        d = norm(cross(a,b)) / norm(a);
                        distances(pointCount,lineCount) = d;
                    end
                end
            end
            distances = min(distances(:,2)); %now just pick the minimum distance - this is how far back the particle Needs to go.
            
            %Below - sort out so that particles past the wall are moved to
            %the wall.
            componentFraction = (abs(particleVelocity) ./ abs(sum(particleVelocity,2))) %the fraction
            componentFraction(isnan(componentFraction)) = 0;
            componentFraction(isinf(componentFraction)) = 0;
            removeVelocity = (distances .* ~in .* componentFraction) %todo do this as a function of the distance...
            removeVelocity(isinf(removeVelocity)) = 0;
            removeVelocity(isnan(removeVelocity)) = 0;
            
            particleLocation = particleLocation - removeVelocity;
            %particleVelocity = particleVelocity .* ~resultOfAllFunctions; %TODO - this is too simplistic - negate the component perpendicular to the wall, nothing else.
                
            wallContact = ~in;
        end
        function [wallContact, particleLocation, particleVelocity] = isParticleOnWall(obj, particleLocation, particleVelocity) %TODO - issue when hitting negative walls...
            wallContactN = (particleLocation <= obj.workspaceSizeMinus) .* -1;
            wallContactP = (particleLocation >= obj.workspaceSizePositive);
            particlesAllowedToMove = double((~wallContactN & (particleVelocity < 0)) | (~wallContactP & (particleVelocity > 0)));
            particleVelocity = double(particleVelocity .* particlesAllowedToMove);
            wallContact = wallContactN + wallContactP; %combine negative and positive directions + as there should be no case where a particle can touch both walls simultaneously
            particleLocation = ((wallContact == 0 ) .* particleLocation ) + (wallContact .* obj.workspaceSizePositive);
        end
        function [wallContact,particleLocation,particleVelocity] = isParticleOnWallFunction(obj,particleLocation,particleVelocity, wallFunctions, xLim)
            resultOfAllFunctions = zeros(length(particleLocation),1);
            distances = zeros(length(particleLocation),1);
            for i = 1:length(wallFunctions)
                %list of lines through origin for particle?
                positionOfParticleRelavtiveToWall = wallFunctions{i}(particleLocation(:,1), particleLocation(:,2),xLim);
                resultOfAllFunctions = resultOfAllFunctions | (positionOfParticleRelavtiveToWall < 0); %check particles don't get stuck...
                positionOfParticleRelavtiveToWall(positionOfParticleRelavtiveToWall > 0) = 0;
                distances = distances + positionOfParticleRelavtiveToWall;
                %instead of magic number, use particeDiameter/2.                
            end
            
            %resultOfAllFunctions = app.testfunc(0,2)%(particleLocation[ : , 1 ], particleLocation[ : , 2 ])
            %wallContact = any(resultOfAllFunctions,3)
            componentFraction = (abs(particleVelocity) ./ abs(sum(particleVelocity,2))) %the fraction
            componentFraction(isnan(componentFraction)) = 0;
            componentFraction(isinf(componentFraction)) = 0;
            removeVelocity = (distances .* resultOfAllFunctions .* componentFraction) %todo do this as a function of the distance...
            removeVelocity(isinf(removeVelocity)) = 0;
            removeVelocity(isnan(removeVelocity)) = 0;
            
            particleLocation = particleLocation - removeVelocity;
            particleVelocity = particleVelocity .* ~resultOfAllFunctions; %TODO - this is too simplistic - negate the component perpendicular to the wall, nothing else.
                
            wallContact = resultOfAllFunctions;
            %particleLocation = particleLocation;
            %particleVelocity = particleVelocity;
            
            %new page for result of each function - use position - if there
            %is one different position on each page, use that one (IDK how
            %to do that...)
            %perform the function on each xy value - is it the wrong side
            %of the function?
            %this should just result in the wallContact bit.
            %Only perform the further calculations on location and vel once!
        end
        function force = calculateFrictionForce(obj, particleVelocity, particleForce, wallContact)
            totalVelocity = sum(abs(particleVelocity),2);
            movingParticles = totalVelocity > 0;
            ForceOnMovingParticles = wallContact .* movingParticles .* particleForce .* obj.movingFrictionCoefficient;
            ForceOnStationaryParticles = wallContact .* ~movingParticles .* particleForce .* obj.staticFrictionCoefficient;
            force = ForceOnMovingParticles + ForceOnStationaryParticles; %uncertain if this is working fully correct
        end
        function velocity = calculateParticleVelocity(obj, particleForce, particleMass, timeSinceLastUpdate)
            velocity = (particleForce ./ particleMass) * timeSinceLastUpdate;
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
        function [location, newVelocity] = moveParticle(obj, particleLocation, particleVelocity, timeModifier)
            %Below for if calculating collisions before
            %collidedParticles = calculateCollisions(particleLocation, particleVelocity, timeModifier)
            %possibleLocation = particleLocation + particleVelocity.* timeModifier;
            %fullMoveParticles = possibleLocation .* isNan(collidedparticles)
            %location = fullMoveParticles + collidedParticles;
            
            %Below if calculating collisions after
            unCheckedLocation = particleLocation + particleVelocity .* timeModifier;
            [location,newVelocity] = calculateCollisionsAfter(obj, particleLocation, unCheckedLocation, particleVelocity, timeModifier);
        end
    end
    methods (Access = private)        
        
    end
end

