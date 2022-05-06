function timerCallback(app)
  %  if(~app.currentlyDoingWorkSemaphore)
  %      app.currentlyDoingWorkSemaphore = true; %let the earlier tasks complete first, try and force other to leave things alone        
        
        currentMagforce = app.particleFunctions.calculateMagneticForce([app.X1MAGauge.Value app.Y1MAGauge.Value]);
        vFlow = app.particleFunctions.calculateFlow(real(app.particleArrayLocation), app.fd.FlowValues, app.polygon, app.UIAxes);
        vFlow = vFlow .* app.FluidFlowmsEditField.Value;

        magForceAlpha = 0.05;
        magForce = app.previousMagforce;
        smallerTMaxTotalSteps = 75; %Any more speed comes from making the sim more efficient or slowing it down (not real time) %150
        smallerTMaxStep = app.simTimerPeriod / smallerTMaxTotalSteps;
        smallerTMaxStepReduced = smallerTMaxStep / 30; %use this to just run the simulation x times slower   %20
        for smallerTMaxIndex = 1:smallerTMaxTotalSteps 
            magForce = magForce .* (1-magForceAlpha) + currentMagforce.* magForceAlpha;
            app.particleArrayForce = magForce;

            %determine if particles are in collision with the wall - particles are inelastic - no bouncing.
            [wallContact, orthogonalWallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.polygon, smallerTMaxStepReduced);

            %drag (using last iterations velocity)
            dragForce = app.particleFunctions.calculateDragForce(app.particleArrayVelocity, vFlow);
            app.particleArrayForce = app.particleArrayForce - dragForce;
            
            %friction
        %TODO Friction doesn't seem to do anything here - maybe check
        %negative/positive?
            app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, orthogonalWallContact);

            app.particleArrayForce = app.particleArrayForce .* ~app.haltParticlesInEndZone;
            app.particleArrayVelocity = app.particleArrayVelocity .* ~app.haltParticlesInEndZone;
            temporaryVelocity = app.particleArrayVelocity;
            temporaryLocation = app.particleArrayLocation;
            
            %calculate the new locations 
            app.particleArrayLocation = app.particleFunctions.calculateCurrentLocationCD(app.particleArrayLocation, temporaryVelocity, app.particleArrayPreviousAcceleration, smallerTMaxStepReduced);
            %Make sure that we have the correct data stored for the next loop.        
            %calculate the new velocity
            [app.particleArrayVelocity,app.particleArrayPreviousAcceleration] = app.particleFunctions.calculateCurrentVelocityCD(orthogonalWallContact, wallContact, temporaryVelocity, app.particleArrayPreviousAcceleration, app.particleArrayForce, app.particleFunctions.particleMass, smallerTMaxStepReduced);
            app.particleArrayPreviousLocation = temporaryLocation;
    
            app.haltParticlesInEndZone = app.particleFunctions.isParticleInEndZone(app.polygon.currentEndZone,app.particleArrayLocation);
          %  app.haltParticlesInEndZone = (sum(endZoneParticles,2) > 0); %TODO need to check the dimension is correct
            goalPercentage = sum(app.haltParticlesInEndZone,1) ./ app.numParticles; 
            
            if(app.timestep == 0)
                %app.timePassed = round(etime(clock,app.startTime)*1000);
                app.timePassed = app.timePassed + smallerTMaxStepReduced;
            else                
                app.timePassed = app.timePassed + app.timestep / smallerTMaxTotalSteps;
            end
            fprintf(app.fileID, app.timePassed + "," + app.timeLag + "," + mat2str(magForce) + "," + mat2str(dragForce)+ "," + goalPercentage + "," + mat2str(app.particleArrayVelocity)+ "," + mat2str(app.particleArrayLocation) + "\r\n");
            %fprintf(app.fileID, app.timePassed + "," + app.timeLag + "," + (magForce(1,1)) + "," + dragForce(1,1)+ "," + goalPercentage + "," + app.particleArrayVelocity(1,1)+ "," + app.particleArrayLocation(1,1) + "\r\n");
        end
        app.previousMagforce = magForce;
        app.currentlyDoingWorkSemaphore = false;
 %   else
 %       fprintf(app.fileID,  app.timePassed + "," + "BADTIMING " + sprintf(",%d,%d,%d,%d", app.X1MAGauge.Value,app.Y1MAGauge.Value,app.X2MAGauge.Value,app.Y2MAGauge.Value) + mat2str(app.particleArrayLocation) + "," + mat2str(app.particleArrayVelocity) + "\r\n");
 %   end
end