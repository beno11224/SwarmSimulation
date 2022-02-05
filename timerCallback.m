function timerCallback(app)
    if(~app.currentlyDoingWorkSemaphore)
        app.currentlyDoingWorkSemaphore = true; %let the earlier tasks complete first, try and force other to leave things alone
        %'zero' the force by writing over it with the magnetic Force.
        magforce = app.particleFunctions.calculateMagneticForce(app.particleArrayLocation, [app.X1mAGauge.Value*1000 app.Y1mAGauge.Value*1000], [app.X2mAGauge.Value*1000 app.Y2mAGauge.Value*1000]);
        app.particleArrayForce = magforce;
        %determine if particles are in collision with the wall - particles are inelastic - no bouncing.
        [wallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.polygon, app.tMax);
        %dipole force
    %    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDipoleForce(app.particleArrayLocation, app.particleArrayForce); %TODO torque != force surely?
        %flow velocity for each particle - used for drag calculation
        vFlow = app.particleFunctions.calculateFlow(real(app.particleArrayLocation), app.fd.FlowValues, app.polygon, app.UIAxes);
                %Use to test app %vFlow = [0.001 0; 0.001 0; 0.001 0];% Flow right
                %Use to test app %vFlow = [0 0; 0 0; 0 0]; %No flow
                
        

        
        %friction
   %     app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, wallContact);

        %now update tMax for this iteration
        timeNow = 86400 * now;
        app.tMax = timeNow - app.lastUpdate;
        app.lastUpdate = timeNow;
        %This is useful for debugging, and should have no effect other than
        %preventing some slower systems from hanging when running this.
        %app.tMax = 0.001;%DELETEME
        if app.tMax > 0.1
            app.tMax = 0.1;
        end
        
        %drag (using last iterations velocity) %Reduce velocity by 10^-6, .* 0.000001
        %and flow by relevant value (set to 0.0000005 is decent)
        dragCurrentVelocity = app.particleFunctions.calculateCurrentVelocityCD(app.particleArrayPreviousVelocity, app.particleArrayPreviousAcceleration, app.particleArrayForce, app.particleFunctions.particleMass, app.tMax);
        dragforce = app.particleFunctions.calculateDragForce(dragCurrentVelocity .* 0.000001, vFlow.*0 .* 10^-6);%.0000005);%0.0000005 IS PROBABLY THE BEST VALUE HERE!
        app.particleArrayForce = app.particleArrayForce - dragforce;
        
        temporaryVelocity = app.particleArrayVelocity;
        temporaryLocation = app.particleArrayLocation;
        
        %calculate the new velocity
        app.particleArrayVelocity = app.particleFunctions.calculateCurrentVelocityCD(app.particleArrayPreviousVelocity, app.particleArrayPreviousAcceleration, app.particleArrayForce, app.particleFunctions.particleMass, app.tMax);
        %calculate the new locations
        app.particleArrayLocation = app.particleFunctions.calculateCurrentLocationCD(app.particleArrayPreviousLocation, app.particleArrayPreviousVelocity, app.particleArrayPreviousAcceleration, app.tMax);
        %Make sure that we have the correct data stored for the next loop.
        app.particleArrayPreviousVelocity = temporaryVelocity;
        app.particleArrayPreviousLocation = temporaryLocation;
        app.particleArrayPreviousAcceleration = app.particleFunctions.calculateAcceleration(app.particleArrayForce, app.tMax);
        %now check for wallContact and the trajectories of the other particles.
     %   [app.particleArrayLocation, app.particleArrayPreviousVelocity] = app.particleFunctions.calculateCollisionsAfter(app.particleArrayPreviousLocation, app.particleArrayLocation, app.particleArrayPreviousVelocity, app.tMax);
        
        %calculate the new velocity
        %app.particleArrayVelocity = app.particleFunctions.calculateCumulativeParticleVelocityComponentFromForce(app.particleArrayForce, app.particleArrayVelocity, app.haltParticlesInEndZone, wallContact, app.tMax);    

        %calculate the new locations bearing in mind wallContact and the trajectories of the other particles.
        %[app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.moveParticle(app.particleArrayLocation, app.particleArrayVelocity, app.tMax);

        app.haltParticlesInEndZone = app.particleFunctions.isParticleInEndZone(app.polygon.currentEndZone,app.particleArrayLocation);
        goalPercentage = sum(app.haltParticlesInEndZone) / app.numParticles; %TODO store which exit each particle is in (0 is not in exit, 1,2... are the numbers of the exit channel)

        %Log this all to a file for data collection
        fprintf(app.fileID,  round(etime(clock,app.startTime)*1000) + "," + goalPercentage + sprintf(",%d,%d,%d,%d", app.X1mAGauge.Value,app.Y1mAGauge.Value,app.X2mAGauge.Value,app.Y2mAGauge.Value) + ","  + mat2str(app.particleArrayLocation) + "," + mat2str(app.particleArrayVelocity) + "\r\n");
     %For writing other stuff to file 
        %fprintf(app.fileID,  round(etime(clock,app.startTime)*1000) + "," + magforce(1,1) + "," + magforce(1,2) + "," + dragforce(1,1)+ "," + dragforce(1,2) + "," + app.particleArrayVelocity(1,1) + "," + app.particleArrayVelocity(1,1) + "\r\n");
        %goalPercentage + sprintf(",%d,%d,%d,%d", app.X1mAGauge.Value,app.Y1mAGauge.Value,app.X2mAGauge.Value,app.Y2mAGauge.Value) + mat2str(app.particleArrayLocation) + "," + mat2str(app.particleArrayVelocity) + "\r\n");
        app.currentlyDoingWorkSemaphore = false;
    else
        fprintf(app.fileID,  round(etime(clock,app.startTime)*1000) + "," + "BADTIMING " + sprintf(",%d,%d,%d,%d", app.X1mAGauge.Value,app.Y1mAGauge.Value,app.X2mAGauge.Value,app.Y2mAGauge.Value) + mat2str(app.particleArrayLocation) + "," + mat2str(app.particleArrayVelocity) + "\r\n");
    end
end