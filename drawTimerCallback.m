function drawTimerCallback(app)
    %hold(app.UIAxes, 'off');
    plot(app.UIAxes,app.particleArrayLocation(:,1),app.particleArrayLocation(:,2),'r.', 'markerSize', 23);
    %timeNow = (86400 * now);
    app.LocationXEditField.Value = round(app.particleArrayLocation(1, 1), 3);
    app.LocationYEditField.Value = round(app.particleArrayLocation(1, 2), 3);
    %plot(timeNow, abs(app.particleArrayVelocity(1,1)) + abs(app.particleArrayVelocity(1,2)), 'b.');
    %hold on
end