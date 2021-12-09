classdef ParticleFunctions
    properties
        magneticForceConstant;
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
        end
        function force = calculateDragForce(obj, particleVelocity, flowVelocity)
            force = (particleVelocity - flowVelocity) .* obj.dragForceConstant;
        end
        function [wallContact, particleLocation, particleVelocity] = isParticleOnWallPIP(obj, particleLocation, particleVelocity, particleForce, polygon, tMax)
            in = inpolygon(particleLocation(:,1), particleLocation(:,2), polygon.currentPoly(:,1), polygon.currentPoly(:,2));

            %TODO this could be tidied up a bit
            %https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
            particleVelocityVectorS = squeeze(repmat(-particleVelocity.*tMax,[1,1,length(polygon.currentPolyVector)]));
            polygonVectorR = permute(repmat(polygon.currentPolyVector', [1,1,size(particleVelocity,1)]),[3,1,2]);
            particleStartQ = squeeze(repmat(particleLocation,[1,1,length(polygon.currentPolyVector)]));
            polyLineStartP = permute(repmat(polygon.currentPoly(1:end-1,:)', [1,1,size(particleVelocity,1)]),[3,1,2]);
            startDistanceQP = (particleStartQ - polyLineStartP);
            startDistancePolyVectorCrossProductQPR = obj.crossProduct(startDistanceQP(:,1,:), startDistanceQP(:,2,:), polygonVectorR(:,1,:), polygonVectorR(:,2,:));
            vectorCrossProductRS = obj.crossProduct(polygonVectorR(:,1,:), polygonVectorR(:,2,:), particleVelocityVectorS(:,1,:), particleVelocityVectorS(:,2,:));
            timeParticleCrossedLine = startDistancePolyVectorCrossProductQPR./vectorCrossProductRS;
            timeParticleCrossedLine(timeParticleCrossedLine<0) = NaN;
            timeParticleCrossedLine(timeParticleCrossedLine == 0) = NaN; %0 to prevent errors in min calculation           
            [minTimeModifier,loc] = min(timeParticleCrossedLine,[],2);
            minTimeModifier = minTimeModifier(:,:,3);
            minTimeModifier(isinf(minTimeModifier)) = 0;
            minTimeModifier(isnan(minTimeModifier)) = 0;
            minTimeModifier = minTimeModifier .* ~in; %So we only care about the particles that are not in the space
            
            %remember tMax is the TIME not a DISTANCE
            %Similarly minTimeModifier is a Multiplier of TMAX
            %(it means nothing on it's own!)
            %location is current, velocity and tMax are from the previous calculations
            reverseVelocityAmmount = ((minTimeModifier.*tMax) .* -particleVelocity) .* 1.015; %move the particle 1.5% away from the wall to prevent sticking
            particleLocation = particleLocation + real(reverseVelocityAmmount); %plus as the particleVelocity was negative
           
            %WallContact shows the vector orthogonal to the wall. All other values in 
            %WallContact are nans to show there is no contact
            wallContact = polygon.currentPolyVector(loc(:,:,3),:);
            wallContact = wallContact .* ~in;
            wallContact = wallContact ./ norm(wallContact); %to unit vector
            wallContact(~any(wallContact,2),:) = NaN; %Set 1's to nan s?
        end
        
        function velocity = calculateFlow(obj, particleLocation, flowMatrix, polygon, axes)
            %Remove this once values are loaded in from file
            tr = triangulation(polyshape(polygon.currentPoly(:,1),polygon.currentPoly(:,2)));
            model = createpde(1);
            tnodes = tr.Points';
            telements = tr.ConnectivityList';
            model.geometryFromMesh(tnodes, telements);
            mesh = generateMesh(model, 'Hmax', 0.001);
            
            closestNode = findNodes(mesh, 'nearest', particleLocation');
            velocity(:,1) = flowMatrix(closestNode,1);
            velocity(:,2) = flowMatrix(closestNode,2);
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
            totalVelocity = sum(abs(particleVelocity),2);
            movingParticles = totalVelocity > 0;
            force = zeros(size(particleForce));
            for i = 1:length(particleForce)
                if(any(~isnan(wallContact(i,:))))
                    %Use vector rejection to project force into the wall.
                    fOne = particleForce(i,:) - (dot(particleForce(i,:),wallContact(i,:)) / dot(wallContact(i,:), wallContact(i,:)) * wallContact(i,:));
                    if(movingParticles(i))
                        force(i,:) = fOne .*obj.movingFrictionCoefficient;
                    else
                        force(i,:) = fOne .*obj.staticFrictionCoefficient; %TODO Currently not reached - if the particle is on the wall it must have velocity due to existing maths.
                    end
                end
            end
        end
        
        function velocity = calculateCumulativeParticlevelocityComponentFromForce(obj, particleForce, oldVelocity, haltTheseParticles, wallContact, timeSinceLastUpdate)
            velocity = oldVelocity + (particleForce ./ obj.particleMass) .* timeSinceLastUpdate;

            for i = 1:length(velocity)
                if(any(~isnan(wallContact(i,:))))
                    %Use vector projection to restrict the velocity where a
                    %particle is on a wall to only along the wall
                    velocity(i,:) = real(dot(velocity(i,:),wallContact(i,:)) / dot(wallContact(i,:), wallContact(i,:)) * wallContact(i,:));
                end
            end
            velocity = velocity .* ~haltTheseParticles;
        end   
        
        function [newLocations, newVelocity] = calculateCollisionsAfter(obj, oldParticleLocation, newParticleLocation, particleVelocity, timeModifier)
            %TODO use the same code as in wall contact.
            
            %get distances between each particle and all the others:            
            xYDistances = newParticleLocation - permute(newParticleLocation,[3,2,1]);
            xYDistances(isnan(xYDistances)) = 0;
            xYDistances(isinf(xYDistances)) = 0;
            distances = permute(sqrt(abs(xYDistances(:,1,:).^2 + xYDistances(:,2,:).^2)),[1,3,2]);
            distances(isnan(distances)) = 0;
            distances(isinf(distances)) = 0;
            actualCollisions = distances < obj.particleDiameter / 2; % /2 is to use radius and not diameter
            try
                actualCollisions = triu(actualCollisions,1);%everything above main diagonal. - this does mean only one particle in a collision is moved
            catch ME
                abcd = 0;
            end
            
                %we have the collisions above, now move the particles
            resetParticlesToCorrectLocations = sum(actualCollisions .* -1 .* distances,2);
            resetParticlesToCorrectLocations(isinf(resetParticlesToCorrectLocations)) = 0;
            componentFraction = (particleVelocity ./ sum(particleVelocity,2)); %the fraction
            componentFraction(isnan(componentFraction)) = 0;
            componentFraction(isinf(componentFraction)) = 0;
            %occupied by each x/y component
            vectoredResetParticlesToCorrectLocations = componentFraction .* resetParticlesToCorrectLocations;
            vectoredResetParticlesToCorrectLocations(isnan(vectoredResetParticlesToCorrectLocations)) = 0;
            vectoredResetParticlesToCorrectLocations(isinf(vectoredResetParticlesToCorrectLocations)) = 0;
            
            newLocations = real(newParticleLocation + vectoredResetParticlesToCorrectLocations);
            %Now use just the velocity perpendicular to the contact...
            newVelocity = real(particleVelocity .* ~any(actualCollisions,2));
        end
        function [location, newVelocity] = moveParticle(obj, particleLocation, particleVelocity, timeModifier)
            unCheckedLocation = particleLocation + particleVelocity .* timeModifier;
            unCheckedLocation(isinf(unCheckedLocation)) = 0; 
            unCheckedLocation(isnan(unCheckedLocation)) = 0; 
            [location,newVelocity] = calculateCollisionsAfter(obj, particleLocation, unCheckedLocation, particleVelocity, timeModifier);
            
            location = real(particleLocation + particleVelocity .* timeModifier);
            newVelocity = particleVelocity;
        end
        
        function particleLocations = generateParticleLocations(obj, poly, particleLocationsLength)
            [xlim ylim] = boundingbox(polyshape(poly));
            particleLocationIndex = 1;
            while(particleLocationIndex <= particleLocationsLength)
                particleLocations(particleLocationIndex,:) = real([xlim(1), ylim(1)] + [xlim(2)-xlim(1),ylim(2)-xlim(1)] .* rand(1, 2));
                a = particleLocations(particleLocationIndex,1);
                b = particleLocations(particleLocationIndex,2);
                if(inpolygon(a,b,poly(:,1), poly(:,2)))
                    particleLocationIndex = particleLocationIndex + 1;
                end
            end
        end
        
        function inGoalZone = isParticleInEndZone(obj, poly, particleLocations)
            inGoalZone = inpolygon(particleLocations(:,1), particleLocations(:,2), poly(:,1), poly(:,2));
            %TODO put any other logic for goal zone in here
        end
        
        function AB = crossProduct(obj, Ax, Ay, Bx, By)
            AB(:,:,3) = Ax.*By-Ay.*Bx;
        end
        %C must be scalar, AB must be vector
        function vec = scalarToVector(obj,C,AB)
            vec = (AB./norm(AB)) .* C;            
        end
    end
end

