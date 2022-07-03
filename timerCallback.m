function timerCallback(app)
  %  if(~app.currentlyDoingWorkSemaphore)
  %      app.currentlyDoingWorkSemaphore = true; %let the earlier tasks complete first, try and force other to leave things alone        
        
        WindowLocation = app.UIFigure.Position;
        MouseXY = get(0, 'PointerLocation');
        %Use this one for just  within the window. NE is (1,1)
        mousePosition = ((MouseXY) - WindowLocation(1:2)) ./ WindowLocation(3:4);
        %Use this one for control with the entire screen
        %mousePosition = (MouseXY) ./ (WindowLocation(3:4) - WindowLocation(1:2)))

        currentMagforce = app.particleFunctions.calculateMagneticForce([app.X1MAGauge.Value app.Y1MAGauge.Value],app.joyStick, 1, 3, app.controlMethod, mousePosition);
        vFlow = app.particleFunctions.calculateFlow(real(app.particleArrayLocation), app.fd.FlowValues, app.polygon, app.UIAxes);
        vFlow = vFlow .* app.FluidFlowmsEditField.Value;

        magForceAlpha = 0.05;
        magForce = app.previousMagforce;
        smallerTMaxTotalSteps = 50; %Any more speed comes from making the sim more efficient or slowing it down (not real time) %150
        smallerTMaxStep = app.simTimerPeriod / smallerTMaxTotalSteps;
        smallerTMaxStepReduced = smallerTMaxStep;% / 20; %use this to just run the simulation x times slower   %20
        for smallerTMaxIndex = 1:smallerTMaxTotalSteps 
            magForce = magForce .* (1-magForceAlpha) + currentMagforce.* magForceAlpha;
            app.particleArrayForce = magForce;

            %determine if particles are in collision with the wall - particles are inelastic - no bouncing.
            [wallContact, orthogonalWallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.polygon, smallerTMaxStepReduced);

            %drag (using last iterations velocity)
            dragForce = app.particleFunctions.calculateDragForce(app.particleArrayVelocity, vFlow);
            app.particleArrayForce = app.particleArrayForce - dragForce;

           % exportgraphics(app.UIAxes,'test.png','Resolution',1200);
           % exportapp(app.UIFigure,'testFig.pdf');
          %  exportapp(app.UIFigure,'testFig.png');
            
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
    
            particlesInEndZone = app.particleFunctions.isParticleInEndZone(app.polygon.currentEndZone,app.particleArrayLocation);
            app.haltParticlesInEndZone = any(particlesInEndZone,2);
            goalPercentage = sum(particlesInEndZone,1) ./ app.numParticles;
            goalPercentage = goalPercentage(1);

            %goalPercentage = 0;
            
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