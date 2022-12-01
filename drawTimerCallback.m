function drawTimerCallback(app)
    delete(app.particlePoints);
    delete(app.magLine);

    rotatedMagLine = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * [0,app.X1MAGauge.Value./250 ; 0,app.Y1MAGauge.Value./250])';
    app.magLine = plot(app.UIAxes,rotatedMagLine(:,1),rotatedMagLine(:,2),'magenta');

    rotatedPoints = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * app.particleArrayLocation')';
    app.particlePoints = plot(app.UIAxes, app.particleFunctions.realNum(rotatedPoints(:,1)), app.particleFunctions.realNum(rotatedPoints(:,2)),'r.', 'markerSize', 23);
   % plot(app.polygon.allPolys(2,:,1), app.polygon.allPolys(2,:,2));
   % hold on
   % plot(app.polygon.allPolys(2,:,1), app.polygon.allPolys(2,:,2),'r.', 'markerSize', 13);
end