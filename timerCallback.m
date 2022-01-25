function timerCallback(app)
    %'zero' the force by writing over it with the magnetic Force.
    app.particleArrayForce = app.particleFunctions.calculateMagneticForce(app.particleArrayLocation, [app.X1mAGauge.Value/1000 app.Y1mAGauge.Value/1000], [app.X2mAGauge.Value/1000 app.Y2mAGauge.Value/1000]);
            %Use to test app%app.particleArrayForce = app.particleFunctions.calculateMagneticForce(app.particleArrayLocation, [0.225 app.Y1AGauge.Value], [app.X2AGauge.Value app.Y2AGauge.Value]);
    %determine if particles are in collision with the wall - particles are inelastic - no bouncing.
    [wallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.polygon, app.tMax);
    %dipole force
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDipoleForce(app.particleArrayLocation, app.particleArrayForce); %TODO torque != force surely?
    %flow velocity for each particle - used for drag calculation
    vFlow = app.particleFunctions.calculateFlow(real(app.particleArrayLocation), app.fd.FlowValues, app.polygon, app.UIAxes);
            %Use to test app %vFlow = [0.001 0; 0.001 0; 0.001 0];% Flow right
            %Use to test app %vFlow = [0 0; 0 0; 0 0]; %No flow
    %drag
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDragForce(app.particleArrayVelocity, vFlow);
    %friction
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, wallContact);
    
    %now update tMax for this iteration
    timeNow = 86400 * now;
    app.tMax = timeNow - app.lastUpdate;
    app.lastUpdate = timeNow;
    %This is useful for debugging, and will have no effect other than
    %preventing some slower systems from hanging when running this.
    if app.tMax <0.001
        app.tMax = 0.001;
    else if app.tMax > 0.1
            app.tMax = 0.1;
        end
    end
    
    %calculate the new velocity
    app.particleArrayVelocity = app.particleFunctions.calculateCumulativeParticleVelocityComponentFromForce(app.particleArrayForce, app.particleArrayVelocity, app.haltParticlesInEndZone, wallContact, app.tMax);
    %calculate the new locations bearing in mind wallContact and the trajectories of the other particles.
    [app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.moveParticle(app.particleArrayLocation, app.particleArrayVelocity, app.tMax);

    app.haltParticlesInEndZone = app.particleFunctions.isParticleInEndZone(app.polygon.currentEndZone,app.particleArrayLocation);
    goalPercentage = sum(app.haltParticlesInEndZone) / app.numParticles; %TODO store which exit each particle is in (0 is not in exit, 1,2... are the numbers of the exit channel)
    
    %Log this all to a file for data collection
    fprintf(app.fileID,  round(etime(clock,app.startTime)*1000) + "," + goalPercentage + sprintf(",%d,%d,%d,%d", app.X1mAGauge.Value,app.Y1mAGauge.Value,app.X2mAGauge.Value,app.Y2mAGauge.Value) + mat2str(app.particleArrayLocation) + "," + mat2str(app.particleArrayVelocity) + "\r\n");
end