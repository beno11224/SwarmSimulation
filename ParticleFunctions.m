classdef ParticleFunctions
    properties
        magneticForceConstant; %TODO ALL of these need to be calculated at a relevant point
                %(obj.permFreeSpace * xOneCurrent * xRadius^2) / (2*(xRadius^2 + (obj.particleLocation(1)+0.1)^2)^(3/2));
        dragForceConstant;%fluidViscocity*particleDiameter)
        dipoleForceConstant;
        %app.ParticleDiametermEditField, 
        staticFrictionCoefficient;
        movingFrictionCoefficient;
        particleMass;
    end
    methods (Access = public)
        %Constructor
        function obj = ParticleFunctions(permeabilityOfFreeSpace, particleDiameter, particleMass, fluidViscocity, staticFrictionCoefficient, motionFrictionCoefficient)
            obj.magneticForceConstant = double(permeabilityOfFreeSpace * (particleDiameter/2)^2 * 10^6);
            obj.dragForceConstant = double(3*pi*fluidViscocity * particleDiameter);
            obj.dipoleForceConstant = double(3*permeabilityOfFreeSpace / 4*pi);
            obj.staticFrictionCoefficient = staticFrictionCoefficient;
            obj.movingFrictionCoefficient = motionFrictionCoefficient;
            obj.particleMass = particleMass;
        end
        %public functions
        function force = calculateMagneticForce(obj, particleLocation, aCoils, bCoils)
            %a coils 'push' in the positive direction, b coils 'push' in
            %the negative direction
            particleLocation(particleLocation<-0.1) = -0.1; %limit values
            particleLocation(particleLocation>0.1) = 0.1;
            force = double(10000000 .*(obj.magneticForceConstant .* aCoils) ./ ((particleLocation + 0.999).^1.5) + (obj.magneticForceConstant .* bCoils) ./ ((0.2 - (particleLocation + 0.999)).^ 1.5));
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
        function [wallContact, particleLocation, particleVelocity] = isParticleOnWall(obj, particleLocation, particleVelocity) %TODO - issue when hitting negative walls...
            wallContactN = (particleLocation <= -0.1) .* -1;
            wallContactP = (particleLocation >= 0.1);
            particlesAllowedToMove = double((~wallContactN & (particleVelocity < 0)) | (~wallContactP & (particleVelocity > 0)));
            particleVelocity = double(particleVelocity .* particlesAllowedToMove);
            wallContact = wallContactN + wallContactP; %combine negative and positive directions + as there should be no case where a particle can touch both walls simultaneously
            particleLocation = ((wallContact == 0 ) .* particleLocation ) + (wallContact .* 0.1);
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
        function collisions = calculateCollisions(obj, particleLocation, particleVelocity, timeModifier)
            %just the collisions - if particles are inelastic there are no
            %contact/adhesion forces - just dipole force holds them
            %together
            %NaNs for no contact, values for collision points (cartesian...)
            soooo
        end
        function location = moveParticle(obj, particleLocation, particleVelocity, timeModifier)
            collidedParticles = calculateCollisions(particleLocation, particleVelocity, timeModifier)
            possibleLocation = particleLocation + particleVelocity.* timeModifier;
            fullMoveParticles = possibleLocation .* isNan(collidedparticles)
            location = fullMoveParticles + collidedParticles;
        end
    end
    methods (Access = private)        
        
    end
end

