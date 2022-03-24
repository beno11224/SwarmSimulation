function timerCallback(app)
    if(~app.currentlyDoingWorkSemaphore)
        app.currentlyDoingWorkSemaphore = true; %let the earlier tasks complete first, try and force other to leave things alone
        %'zero' the force by writing over it with the magnetic Force.
        magforce = app.particleFunctions.calculateMagneticForce([app.X1mAGauge.Value app.Y1mAGauge.Value]);
        app.particleArrayForce = magforce;
        %determine if particles are in collision with the wall - particles are inelastic - no bouncing.
       % [wallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.polygon, app.tMax);
        %dipole force
      %  app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDipoleForce(app.particleArrayLocation, app.particleArrayForce); %TODO torque != force surely?
        %flow velocity for each particle - used for drag calculation
        vFlow = app.particleFunctions.calculateFlow(real(app.particleArrayLocation), app.fd.FlowValues, app.polygon, app.UIAxes);
                
        %friction
   %     app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, wallContact);

        %now update tMax for this iteration
        if(app.timestep > 0)
            app.tMax = app.timestep;
        else
            timeNow = clock;
            app.tMax = round(etime(timeNow,app.lastUpdate)*1000);
            app.lastUpdate = timeNow;
            %This is useful for debugging, and should have no effect other than
            %preventing some slower systems from hanging when running this.
            if app.tMax > 0.1
                app.tMax = 0.1;
            end
        end
        %drag (using last iterations velocity)
        dragForce = app.particleFunctions.calculateDragForce(app.particleArrayVelocity, vFlow.*0);
        app.particleArrayForce = app.particleArrayForce - dragForce;
        
        temporaryVelocity = app.particleArrayVelocity;
       % temporaryLocation = app.particleArrayLocation;
        
        %calculate the new locations
        app.particleArrayLocation = app.particleFunctions.calculateCurrentLocationCD(app.particleArrayLocation, temporaryVelocity, app.particleArrayPreviousAcceleration, app.tMax);
        %Make sure that we have the correct data stored for the next loop.        
        %calculate the new velocity
        [app.particleArrayVelocity,app.particleArrayPreviousAcceleration] = app.particleFunctions.calculateCurrentVelocityCD(temporaryVelocity, app.particleArrayPreviousAcceleration, app.particleArrayForce, app.particleFunctions.particleMass, app.tMax);
       % app.particleArrayPreviousLocation = temporaryLocation;

        app.haltParticlesInEndZone = app.particleFunctions.isParticleInEndZone(app.polygon.currentEndZone,app.particleArrayLocation);
        goalPercentage = sum(app.haltParticlesInEndZone) / app.numParticles; %TODO store which exit each particle is in (0 is not in exit, 1,2... are the numbers of the exit channel)

        if(app.timestep == 0)
            app.timePassed = round(etime(clock,app.startTime)*1000);
        else
            
            app.timePassed = app.timePassed + app.timestep;
        end
          %Log this all to a file for data collection
        %fprintf(app.fileID,  app.timePassed + "," + goalPercentage + sprintf(",%d,%d,%d,%d", app.X1mAGauge.Value,app.Y1mAGauge.Value,app.X2MAGauge.Value,app.Y2MAGauge.Value) + ","  + mat2str(app.particleArrayLocation) + "," + mat2str(app.particleArrayVelocity) + "\r\n");
          %For writing other stuff to file
        %fprintf(app.fileID,  app.timePassed + "," + magforce(1,1) + "," + magforce(1,2) + "," + dragForce(1,1)+ "," + dragForce(1,2) + "," + app.particleArrayVelocity(1,1) + "," + app.particleArrayVelocity(1,2) + "\r\n");
      fprintf(app.fileID, app.timePassed + "," + magforce(1,1) + "," + dragForce(1,1)+ "," + goalPercentage + "," + app.particleArrayVelocity(1,1)+ "," + app.particleArrayLocation(1,1) + "\r\n");
        app.currentlyDoingWorkSemaphore = false;
    else
        fprintf(app.fileID,  app.timePassed + "," + "BADTIMING " + sprintf(",%d,%d,%d,%d", app.X1mAGauge.Value,app.Y1mAGauge.Value,app.X2mAGauge.Value,app.Y2mAGauge.Value) + mat2str(app.particleArrayLocation) + "," + mat2str(app.particleArrayVelocity) + "\r\n");
    end
end