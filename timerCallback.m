function timerCallback(app)
        %Here we 'zero' the force by writing over it with the magnetic Force.
    app.particleArrayForce = app.particleFunctions.calculateMagneticForce(app.particleArrayLocation, [app.X1AGauge.Value app.Y1AGauge.Value], [app.X2AGauge.Value app.Y2AGauge.Value]);
        %dipole force %does this fit here or later?
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDipoleForce(app.particleArrayLocation, app.particleArrayForce);
        %drag
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDragForce(app.particleArrayVelocity);
        %get app.t for use in wall collision maths.
    timeNow = 86400 * now;
    app.tMax = timeNow - app.lastUpdate;
    app.lastUpdate = timeNow;
    	%particles are inelastic - no bouncing.
    [wallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.polygon, app.tMax);
        %friction
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, wallContact);
        %calculate the new velocity
    app.particleArrayVelocity = app.particleArrayVelocity + app.particleFunctions.calculateParticleVelocity(app.particleArrayForce, app.tMax);
        %calculate the new locations
    [app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.moveParticle(app.particleArrayLocation, app.particleArrayVelocity, app.tMax);
    fprintf(app.fileID,  datestr(now,'HH_MM_SS_FFF') + sprintf(",%d,%d,%d,%d,", app.X1AGauge.Value,app.Y1AGauge.Value,app.X2AGauge.Value,app.Y2AGauge.Value) + mat2str(app.particleArrayLocation) + mat2str(app.particleArrayVelocity) + "\r\n");
end