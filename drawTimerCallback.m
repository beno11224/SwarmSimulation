function drawTimerCallback(app)
    hold(app.UIAxes, 'off');
    %rectangle(app.UIAxes,'Position',[-0.1 -0.1 0.1 0.1]);
    plot(app.UIAxes,app.particleArrayLocation(:,1),app.particleArrayLocation(:,2),'r.');
    timeNow = (86400 * now);
    app.LocationXEditField.Value = round(app.particleArrayLocation(1, 1), 3);
    app.LocationYEditField.Value = round(app.particleArrayLocation(1, 2), 3);
    plot(timeNow, abs(app.particleArrayVelocity(1,1)) + abs(app.particleArrayVelocity(1,2)), 'b.');
    hold on
end