function drawTimerCallback(app)
    %get rid of drawings from last callback
    delete(app.particlePoints);
    delete(app.magLine);

    %Draw the visual user input line
    rotatedMagLine = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * [0,app.X1MAGauge.Value./(app.maxForce.*75) ; 0,app.Y1MAGauge.Value./(app.maxForce.*75)])';
    app.magLine = plot(app.UIAxes,rotatedMagLine(:,1),rotatedMagLine(:,2),'magenta');
    
    %Plot the particles
    notBounced = app.particleArrayLocation((app.bouncedLastLoop&app.bouncedVisualLastLoop) == 0,:);
    rotatedPoints = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * notBounced')';
    app.particlePoints = plot(app.UIAxes, app.particleFunctions.realNum(rotatedPoints(:,1)), app.particleFunctions.realNum(rotatedPoints(:,2)),'r.', 'markerSize', 23);
 end