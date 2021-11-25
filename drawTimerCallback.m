function drawTimerCallback(app)
    delete(app.particlePoints);
    app.particlePoints = plot(app.UIAxes,app.particleArrayLocation(:,1),app.particleArrayLocation(:,2),'r.', 'markerSize', 23);    
    %app.LocationXEditField.Value = round(app.particleArrayLocation(1, 1), 3);
    %app.LocationYEditField.Value = round(app.particleArrayLocation(1, 2), 3);
end