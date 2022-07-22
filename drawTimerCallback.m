function drawTimerCallback(app)
    delete(app.particlePoints);
    delete(app.magLine);
    %for i = 1:length(app.polygon.outOfBoundsPolys)
    %    ab = plot(app.UIAxes, app.polygon.outOfBoundsPolys(i,:,1), app.polygon.outOfBoundsPolys(i,:,2),'r-');
    %    delete(ab);
    %end
    app.magLine = plot(app.UIAxes,[0,app.X1MAGauge.Value./250],[0,app.Y1MAGauge.Value./250],'magenta');
    app.particlePoints = plot(app.UIAxes, app.particleFunctions.realNum(app.particleArrayLocation(:,1)), app.particleFunctions.realNum(app.particleArrayLocation(:,2)),'r.', 'markerSize', 23);
end