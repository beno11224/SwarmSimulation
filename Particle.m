classdef Particle
    properties
        particleLocation = [0 0]; %x y
        particleVelocity = [0 0]; %x y
        lastUpdate = 0; %realTime for now, this will have to change and provide a SET time difference
        permFreeSpace = 1.25663706e-6
    end
    methods (Access = public)
      %public
      
        function obj = Particle(location, velocity)
            obj.particleLocation = location;
            obj.particleVelocity = velocity;
            obj.lastUpdate = 86400 * now;
        end
        
        %call this for each particle BEFORE moving any of them
        function obj = applyForce(obj, xOne, xTwo, yOne, yTwo, externalForce, fluidViscocity, staticFrictionCoefficient, movingFrictionCoefficient, particleDiameter, particleMass)
            magneticForce = obj.calculateMagneticForce(1, 1, xOne, xTwo, yOne, yTwo);
            dragForce = obj.calculateDragForce(fluidViscocity, particleDiameter);            
            totalForce = magneticForce + externalForce - dragForce;
            %Now look at friction
            [wallContact,obj] = obj.isParticleInterferingWithWall();
            effectiveParticleWeight = wallContact.*(totalForce.*particleMass);
            if(wallContact(1) ~= 0)
                if( ( (wallContact(1) == -1) && (totalForce(1) < 0) ) || ( (wallContact(1) == 1) && (totalForce(1) > 0) ) )
                    totalForce(1) = 0;
                end
            end
            if(wallContact(2) ~= 0)
                if( ( (wallContact(2) == -1) && (totalForce(2) < 0) ) || ( (wallContact(2) == 1) && (totalForce(2) > 0) ) )
                    totalForce(2) = 0;
                end
            end            
            frictionForce = obj.calculateFrictionForce(staticFrictionCoefficient, movingFrictionCoefficient, wallContact, effectiveParticleWeight);
            totalForce(1) = obj.compareFrictionForce(totalForce(1), frictionForce(1));
            totalForce(2) = obj.compareFrictionForce(totalForce(2), frictionForce(2));
            %Work out how long that all took, in order to determine dV
            timeNow = 86400 * now;
            timeSinceLastUpdate = timeNow - obj.lastUpdate;
            obj.lastUpdate = timeNow;
            obj.particleVelocity = obj.particleVelocity + (totalForce/particleMass * timeSinceLastUpdate) * 0.0001;
        end
        
        %call this in a draw loop
        function obj =  moveParticle(obj)
            obj.particleLocation = obj.particleLocation + obj.particleVelocity;
        end
        function [obj, externalForce] = calculateExternalInfluence(obj,comparisonParticle)
            distance = norm(obj.particleLocation - comparisonParticle.particleLocation);
            %TODO dipole forces
            %TODO remember to call this in the major loop BEFORE applyForce
            %TODO provide new param in applyForce for external (to the particle) forces
            %TODO good place to add contact and adhesion
        end
    end
    methods (Access = private)
        function force = calculateMagneticForce(obj, xRadius, yRadius, xOneCurrent, xTwoCurrent, yOneCurrent, yTwoCurrent)
            xOneForce = (obj.permFreeSpace * xOneCurrent * xRadius^2) / (2*(xRadius^2 + (obj.particleLocation(1)+0.1)^2)^(3/2));
            xTwoForce = (obj.permFreeSpace * xTwoCurrent * xRadius^2) / (2*(xRadius^2 + (0.2 - obj.particleLocation(1)+0.1)^2)^(3/2));
            yOneForce = (obj.permFreeSpace * yOneCurrent * yRadius^2) / (2*(yRadius^2 + (obj.particleLocation(2)+0.1)^2)^(3/2));
            yTwoForce = (obj.permFreeSpace * yTwoCurrent * yRadius^2) / (2*(yRadius^2 + (0.2 - obj.particleLocation(2)+0.1)^2)^(3/2));
            force = [xOneForce + xTwoForce yOneForce + yTwoForce];
        end
        
        function force = calculateDragForce(obj, fluidViscocity, particleDiameter)
            force = 3*pi*fluidViscocity*particleDiameter*obj.particleVelocity;
            %drag is a vector with the same dimensions as velocity.
        end
        
        function force = calculateFrictionForce(obj, staticFrictionCoefficient, movingFrictionCoefficient, wallContact, effectiveParticleWeight)
            if(any(wallContact) == false)
                %not touching a wall, so no friction.
                force = [0 0];
                return
            end
            velocityDirections = ~wallContact;
            totalParticleVelocity = sum(velocityDirections.*obj.particleVelocity);
            if(totalParticleVelocity == 0)
                force = effectiveParticleWeight * staticFrictionCoefficient;
            else
                force = effectiveParticleWeight * movingFrictionCoefficient;
            end
        end
        
        function [interference, obj] = isParticleInterferingWithWall(obj)
            %TODO remove magic numbers sometime...
            temporaryInterference = [0 0];
            %x
            if(obj.particleLocation(1) >= 0.1)
                temporaryInterference(1) = 1;
                obj.particleLocation(1) = 0.1;
                obj.particleVelocity(1) = 0;
            end
            if(obj.particleLocation(1) <= -0.1)
                temporaryInterference(1) = -1;
                obj.particleLocation(1) = -0.1;
                obj.particleVelocity(1) = 0;
            end
            %y
            if(obj.particleLocation(2) >= 0.1)
                temporaryInterference(2) = 1;
                obj.particleLocation(2) = 0.1;
                obj.particleVelocity(2) = 0;
            end
            if(obj.particleLocation(2) <= -0.1)
                temporaryInterference(2) = -1;
                obj.particleLocation(2) = -0.1;
                obj.particleVelocity(2) = 0;
            end
            interference = temporaryInterference;
        end
        
        function endForce = compareFrictionForce(obj, currentForce, maxFrictionForce)
            if( (maxFrictionForce < 0 && currentForce > 0) || (maxFrictionForce > 0 && currentForce < 0) )
                %friction and other forces acting in opposite directions
                xDifference = abs(currentForce) - abs(maxFrictionForce);
                %is the maximum friction enough to be overcome
                if(xDifference >= 0)
                    endForce = sign(totalForce1) * xDifference;
                else
                    endForce = 0;
                end
            else
                endForce = currentForce;
            end
        end
    end
end