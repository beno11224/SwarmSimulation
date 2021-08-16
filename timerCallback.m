function timerCallback(app)
        %Here we 'zero' the force by writing over it with the magnetic Force.
    app.particleArrayForce = app.particleFunctions.calculateMagneticForce(app.particleArrayLocation, [app.X1AGauge.Value app.Y1AGauge.Value], [app.X2AGauge.Value app.Y2AGauge.Value]);
        %dipole force %does this fit here or later?
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDipoleForce(app.particleArrayLocation, app.particleArrayForce);
        %drag
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDragForce(app.particleArrayVelocity);
        %halt any CURRENT movement of particles in contact with the walls
    [wallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWall(app.particleArrayLocation, app.particleArrayVelocity);
    func1 = @(x,y) (y>(x ));
    %func1(1,2)
    app.particleFunctions.isParticleOnWallFunction(app.particleArrayLocation, app.particleArrayVelocity, func1)
    %app.particleFunctions.isParticleOnWallFunction(app.particleArrayLocation, app.particleArrayVelocity)
        %friction
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, wallContact);
        %calculate the new velocity
    timeNow = 86400 * now;
    timeSinceLastUpdate = timeNow - app.lastUpdate;
    app.lastUpdate = timeNow;
    app.particleArrayVelocity = app.particleArrayVelocity + app.particleFunctions.calculateParticleVelocity(app.particleArrayForce, 1 , timeSinceLastUpdate); %app.ParticleMasskgEditField.Value
        %calculate the new locations
    [app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.moveParticle(app.particleArrayLocation, app.particleArrayVelocity, timeSinceLastUpdate);
    fprintf(app.fileID,  datestr(now,'HH_MM_SS_FFF') + sprintf(",%d,%d,%d,%d,", app.X1AGauge.Value,app.Y1AGauge.Value,app.X2AGauge.Value,app.Y2AGauge.Value) + mat2str(app.particleArrayLocation) + mat2str(app.particleArrayVelocity) + "\r\n");
end