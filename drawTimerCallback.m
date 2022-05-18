function drawTimerCallback(app)
    delete(app.particlePoints);
    %for i = 1:length(app.polygon.outOfBoundsPolys)
    %    ab = plot(app.UIAxes, app.polygon.outOfBoundsPolys(i,:,1), app.polygon.outOfBoundsPolys(i,:,2),'r-');
    %    delete(ab);
    %end
    app.particlePoints = plot(app.UIAxes, app.particleFunctions.realNum(app.particleArrayLocation(:,1)), app.particleFunctions.realNum(app.particleArrayLocation(:,2)),'r.', 'markerSize', 23);
end