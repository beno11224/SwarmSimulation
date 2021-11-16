function timerCallback(app)
        %Here we 'zero' the force by writing over it with the magnetic Force.
    app.particleArrayForce = app.particleFunctions.calculateMagneticForce(app.particleArrayLocation, [app.X1AGauge.Value app.Y1AGauge.Value], [app.X2AGauge.Value app.Y2AGauge.Value]);
        %dipole force %does this fit here or later?
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDipoleForce(app.particleArrayLocation, app.particleArrayForce);
        %drag
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDragForce(app.particleArrayVelocity);
        
    
    %f = app.particleFunctions.calculateFlowForce(app.particleArrayLocation, [0.01,0.02,0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.95]);
    	%particles are inelastic - no bouncing.
    [wallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.polygon, app.tMax);
    
        %now update tMax for this iteration
    timeNow = 86400 * now;
    app.tMax = timeNow - app.lastUpdate;
    app.lastUpdate = timeNow;   
    
        %friction
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, wallContact);
        %calculate the new velocity
    app.particleArrayVelocity = app.particleFunctions.calculateCumulativeParticlevelocityComponentFromForce(app.particleArrayForce, app.particleArrayVelocity, wallContact, app.tMax);
        %calculate the new locations bearing in mind wallContact and the
        %trajectories of the other particles.
    [app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.moveParticle(app.particleArrayLocation, app.particleArrayVelocity, app.tMax);
        %Log this all to a file for data collection
    fprintf(app.fileID,  datestr(now,'HH_MM_SS_FFF') + sprintf(",%d,%d,%d,%d,", app.X1AGauge.Value,app.Y1AGauge.Value,app.X2AGauge.Value,app.Y2AGauge.Value) + mat2str(app.particleArrayLocation) + mat2str(app.particleArrayVelocity) + "\r\n");
end