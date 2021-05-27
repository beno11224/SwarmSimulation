function timerCallback(app)
        %Here we 'zero' the force by writing over it with the magnetic Force.
    app.particleArrayForce = app.particleFunctions.calculateMagneticForce(app.particleArrayLocation, [app.X1AGauge.Value * 0.001 app.Y1AGauge.Value * 0.001], [app.X2AGauge.Value * 0.001 app.Y2AGauge.Value * 0.001]);
        %dipole force %does this fit here or later?
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDipoleForce(app.particleArrayLocation, app.particleArrayForce);
        %drag
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDragForce(app.particleArrayForce);
        %halt any CURRENT movement of particles in contact with the walls. Make
        %sure they don't keep moving though...
    [wallContact app.particleArrayLocation app.particleArrayVelocity] = app.particleFunctions.isParticleOnWall(app.particleArrayLocation, app.particleArrayVelocity);
        %friction
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, wallContact);
        %calculate the new velocity
    timeNow = 86400 * now;
    timeSinceLastUpdate = timeNow - app.lastUpdate;
    app.lastUpdate = timeNow;
    app.particleArrayVelocity = app.particleArrayVelocity + app.particleFunctions.calculateParticleVelocity(app.particleArrayForce, 1 , timeSinceLastUpdate); %app.ParticleMasskgEditField.Value
        %calculate the new locations
    app.particleArrayLocation = app.particleFunctions.moveParticle(app.particleArrayLocation, app.particleArrayVelocity, timeSinceLastUpdate);
end