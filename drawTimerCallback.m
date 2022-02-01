function drawTimerCallback(app)
    delete(app.particlePoints);
    app.particlePoints = plot(app.UIAxes, app.particleFunctions.realNum(app.particleArrayLocation(:,1)), app.particleFunctions.realNum(app.particleArrayLocation(:,2)),'r.', 'markerSize', 23);
end