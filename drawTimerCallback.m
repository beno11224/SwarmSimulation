function drawTimerCallback(app)
    delete(app.particlePoints);
    delete(app.magLine);
    %for i = 1:length(app.polygon.outOfBoundsPolys)
    %    ab = plot(app.UIAxes, app.polygon.outOfBoundsPolys(i,:,1), app.polygon.outOfBoundsPolys(i,:,2),'r-');
    %    delete(ab);
    %end
 %   aa = plot(app.UIAxes, squeeze(app.polygon.allStartZones(2,2,:,1)), squeeze(app.polygon.allStartZones(2,2,:,2)),'m-');
 %   ab = plot(app.UIAxes, squeeze(app.polygon.allStartZones(2,4,:,1)), squeeze(app.polygon.allStartZones(2,4,:,2)),'m-');
 %   delete(ab)
 %   delete(aa)
 %   for i = 1:size(app.mesh.Nodes,2)
 %       ab = plot(app.UIAxes, app.mesh.Nodes(1,i), app.mesh.Nodes(2,i), '.', 'markerSize', 23, 'color', 'red');
 %       abz = plot(app.UIAxes,[app.mesh.Nodes(1,i); app.mesh.Nodes(1,i) + app.fd.FlowValues(i,1)], [app.mesh.Nodes(2,i); app.mesh.Nodes(2,i) + app.fd.FlowValues(i,2)], 'color', 'yellow');
 %       abc(1,:) = [i i+11];
 %       abc(2,:) = app.fd.FlowValues(i,:);
 %       delete(ab);
 %       delete(abz);
 %   end

    rotatedMagLine = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * [0,app.X1MAGauge.Value./250 ; 0,app.Y1MAGauge.Value./250])';
    app.magLine = plot(app.UIAxes,rotatedMagLine(:,1),rotatedMagLine(:,2),'magenta');

    rotatedPoints = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * app.particleArrayLocation')';
    app.particlePoints = plot(app.UIAxes, app.particleFunctions.realNum(rotatedPoints(:,1)), app.particleFunctions.realNum(rotatedPoints(:,2)),'r.', 'markerSize', 23);
end