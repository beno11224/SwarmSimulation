function timerCallback(app)
    if(~app.currentlyDoingWorkSemaphore)
        app.currentlyDoingWorkSemaphore = true; %let the earlier tasks complete first, try and force other to leave things alone
        %'zero' the force by writing over it with the magnetic Force.
        
        %TODO make sure to ramp this up/down - use the steps decided before
        %to determine how many steps to use
        
        currentMagforce = app.particleFunctions.calculateMagneticForce([app.X1MAGauge.Value app.Y1MAGauge.Value]);% .* 1750;
        %app.particleArrayForce = magforce;
        %determine if particles are in collision with the wall - particles are inelastic - no bouncing.
      %  [wallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.polygon, app.tMax);
        %dipole force
      %  app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDipoleForce(app.particleArrayLocation, app.particleArrayForce); %TODO torque != force surely?
        %flow velocity for each particle - used for drag calculation
        vFlow = app.particleFunctions.calculateFlow(real(app.particleArrayLocation), app.fd.FlowValues, app.polygon, app.UIAxes);
              
        vFlow = vFlow .* 0;% + [0.01, 0];
        %friction
       % app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, wallContact);

        %now update tMax for this iteration
        if(app.timestep > 0)
            app.tMax = app.timestep;
        else
            
            timeNow = clock;
            app.tMax = round(etime(timeNow,app.lastUpdate)*1000)/1000;
            app.lastUpdate = timeNow;
            if app.tMax > (3 * app.simTimerPeriod)
                %just treat this as lag here, 3* the time is too long.
                %Users may just experience convential computer lag
                %here, hopefully only in the range of 100-400ms
                app.timeLag = app.timeLag + (app.tMax - app.simTimerPeriod);
                app.tMax = app.simTimerPeriod;
            end
        end
        smallerTMaxTotalSteps = 200; %150%can modify total steps here. low as you can, without stopping the simulation. Any more speed comes from making the sim more efficient or slowing it down (not real time)
        smallerTMaxStep = app.simTimerPeriod / smallerTMaxTotalSteps;
        smallerTMaxStepReduced = smallerTMaxStep / 50; %use this to just run the simulation x times slower
        for smallerTMaxIndex = 1:smallerTMaxTotalSteps 
          %  smallerTMax = smallerTMaxIndex * smallerTMaxStep; %YOU WALLY
          %  this is not what to do! FIX this...
            
            deltaMagForce = (currentMagforce - app.previousMagforce) .* (smallerTMaxIndex ./  smallerTMaxTotalSteps); %TODO make this correct, changes to MagField
            app.particleArrayForce = app.previousMagforce + deltaMagForce;

            %drag (using last iterations velocity)
            dragForce = app.particleFunctions.calculateDragForce(app.particleArrayVelocity, vFlow);
            app.particleArrayForce = app.particleArrayForce - dragForce;
            
            temporaryVelocity = app.particleArrayVelocity;
            temporaryLocation = app.particleArrayLocation;
            
            %calculate the new locations 
            app.particleArrayLocation = app.particleFunctions.calculateCurrentLocationCD(app.particleArrayLocation, temporaryVelocity, app.particleArrayPreviousAcceleration, smallerTMaxStepReduced);
            %Make sure that we have the correct data stored for the next loop.        
            %calculate the new velocity
            [app.particleArrayVelocity,app.particleArrayPreviousAcceleration] = app.particleFunctions.calculateCurrentVelocityCD(temporaryVelocity, app.particleArrayPreviousAcceleration, app.particleArrayForce, app.particleFunctions.particleMass, smallerTMaxStepReduced);
            app.particleArrayPreviousLocation = temporaryLocation;
    
            app.haltParticlesInEndZone = app.particleFunctions.isParticleInEndZone(app.polygon.currentEndZone,app.particleArrayLocation);
            goalPercentage = sum(app.haltParticlesInEndZone) / app.numParticles; %TODO store which exit each particle is in (0 is not in exit, 1,2... are the numbers of the exit channel)
    
            %Maybe can set this to go off outside the loop?
            
            if(app.timestep == 0)
                %app.timePassed = round(etime(clock,app.startTime)*1000);
                app.timePassed = app.timePassed + smallerTMaxStepReduced;
            else
                
                app.timePassed = app.timePassed + app.timestep / smallerTMaxTotalSteps;
            end
              %Log this all to a file for data collection
            %fprintf(app.fileID,  app.timePassed + "," + goalPercentage + sprintf(",%d,%d,%d,%d", app.X1MAGauge.Value,app.Y1MAGauge.Value,app.X2MAGauge.Value,app.Y2MAGauge.Value) + ","  + mat2str(app.particleArrayLocation) + "," + mat2str(app.particleArrayVelocity) + "\r\n");
              %For writing other stuff to file
            %fprintf(app.fileID,  app.timePassed + "," + magforce(1,1) + "," + magforce(1,2) + "," + dragForce(1,1)+ "," + dragForce(1,2) + "," + app.particleArrayVelocity(1,1) + "," + app.particleArrayVelocity(1,2) + "\r\n");
            actualTimePassed = round(etime(clock,app.startTime)*1000)/1000;
            fprintf(app.fileID, actualTimePassed + "," + app.timePassed + "," + smallerTMaxStepReduced + "," + smallerTMaxStepReduced + "," + app.timeLag + "," + (app.previousMagforce(1,1) + deltaMagForce(1,1)) + "," + dragForce(1,1)+ "," + goalPercentage + "," + app.particleArrayVelocity(1,1)+ "," + app.particleArrayLocation(1,1) + "\r\n");
        end
        app.previousMagforce = currentMagforce;
        app.currentlyDoingWorkSemaphore = false;
    else
        fprintf(app.fileID,  app.timePassed + "," + "BADTIMING " + sprintf(",%d,%d,%d,%d", app.X1MAGauge.Value,app.Y1MAGauge.Value,app.X2MAGauge.Value,app.Y2MAGauge.Value) + mat2str(app.particleArrayLocation) + "," + mat2str(app.particleArrayVelocity) + "\r\n");
    end
end