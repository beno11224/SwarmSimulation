function timerCallback(app)
        %Here we 'zero' the force by writing over it with the magnetic Force.
    app.particleArrayForce = app.particleFunctions.calculateMagneticForce(app.particleArrayLocation, [app.X1AGauge.Value app.Y1AGauge.Value], [app.X2AGauge.Value app.Y2AGauge.Value]);
    
    	%particles are inelastic - no bouncing.
    [wallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.lineSegments, app.tMax);
        
    %flowMatrix = ones(435,2); %REMOVE This
    flowMatrix = app.fd.FlowValues;
    flowMatrix = flowMatrix.*0.001; %REMOVE This
    vFlow = app.particleFunctions.calculateFlow(app.particleArrayLocation, flowMatrix, app.polygon); %Store in app somewhere after pulling in from a file. Must also store the mesh&Geometry. Might just calculate each time it's loaded?
    
        %dipole force %does this fit here or later?
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDipoleForce(app.particleArrayLocation, app.particleArrayForce);
        %drag
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateDragForce(app.particleArrayVelocity, vFlow);
        
        %now update tMax for this iteration
    timeNow = 86400 * now;
    app.tMax = timeNow - app.lastUpdate;
    app.lastUpdate = timeNow;
    
    %This is super hacky, but might help with debugging?
    if app.tMax <0.001
        app.tMax = 0.001;
    else if app.tMax > 0.1            
            app.tMax = 0.1;
        end
    end
    
    %app.tMax = 0.02; %REMOVE THIS AS IT WILL BREAK IT!
    
        %friction
    app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, wallContact);
        %calculate the new velocityee
    [a,b] = inpolygon(app.particleArrayLocation(:,1), app.particleArrayLocation(:,2), app.polygon.currentPoly(:,1), app.polygon.currentPoly(:,2));
        
    app.particleArrayVelocity = app.particleFunctions.calculateCumulativeParticlevelocityComponentFromForce(app.particleArrayForce, app.particleArrayVelocity, wallContact, app.tMax);
        %calculate the new locations bearing in mind wallContact and the
        %trajectories of the other particles.
    [app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.moveParticle(app.particleArrayLocation, app.particleArrayVelocity, app.tMax);
        %Log this all to a file for data collection
    fprintf(app.fileID,  datestr(now,'HH_MM_SS_FFF') + sprintf(",%d,%d,%d,%d,", app.X1AGauge.Value,app.Y1AGauge.Value,app.X2AGauge.Value,app.Y2AGauge.Value) + mat2str(app.particleArrayLocation) + mat2str(app.particleArrayVelocity) + "\r\n");
end