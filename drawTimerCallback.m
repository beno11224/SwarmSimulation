function drawTimerCallback(app)
    delete(app.particlePoints);
    delete(app.magLine);
    %for i = 1:length(app.polygon.outOfBoundsPolys)
    %    ab = plot(app.UIAxes, app.polygon.outOfBoundsPolys(i,:,1), app.polygon.outOfBoundsPolys(i,:,2),'r-');
    %    delete(ab);
    %end
    ab = plot(app.UIAxes, app.polygon.currentStartZone(:,1), app.polygon.currentStartZone(:,2),'m-');
    delete(ab)
    rotatedMagLine = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * [0,app.X1MAGauge.Value./250 ; 0,app.Y1MAGauge.Value./250])';
    app.magLine = plot(app.UIAxes,rotatedMagLine(:,1),rotatedMagLine(:,2),'magenta');

    rotatedPoints = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * app.particleArrayLocation')';
    app.particlePoints = plot(app.UIAxes, app.particleFunctions.realNum(rotatedPoints(:,1)), app.particleFunctions.realNum(rotatedPoints(:,2)),'r.', 'markerSize', 23);
end