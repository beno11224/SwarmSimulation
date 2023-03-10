function drawTimerCallback(app)
    delete(app.particlePoints);
    delete(app.magLine);

    rotatedMagLine = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * [0,app.X1MAGauge.Value./(app.maxForce.*75) ; 0,app.Y1MAGauge.Value./(app.maxForce.*75)])';
    app.magLine = plot(app.UIAxes,rotatedMagLine(:,1),rotatedMagLine(:,2),'magenta');
    
    %a = app.bouncedLastLoop&app.bouncedVisualLastLoop
    notBounced = app.particleArrayLocation((app.bouncedLastLoop&app.bouncedVisualLastLoop) == 0,:);
    rotatedPoints = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * notBounced')';
    %rotatedPoints = ([cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)] * app.particleArrayLocation')';
    app.particlePoints = plot(app.UIAxes, app.particleFunctions.realNum(rotatedPoints(:,1)), app.particleFunctions.realNum(rotatedPoints(:,2)),'r.', 'markerSize', 23);
    % plot(app.polygon.allPolys(2,:,1), app.polygon.allPolys(2,:,2));
   % hold on
   % plot(app.polygon.allPolys(2,:,1), app.polygon.allPolys(2,:,2),'r.', 'markerSize', 13);

%    n = 3;
%    a = plot(app.UIAxes,0,0,'r.', 'markerSize', 15);
%      for(i = 1:size(app.polygon.outOfBoundsPolys{n}))
%          ab = plot(app.UIAxes, app.polygon.outOfBoundsPolys{n}(i,:,1), app.polygon.outOfBoundsPolys{n}(i,:,2));
%          ac = plot(app.UIAxes, [0;app.polygon.hardCodedOrthogonalWallContacts{n}(i,1).*0.001], [0;app.polygon.hardCodedOrthogonalWallContacts{n}(i,2).*0.001]);
%       %   ad = app.polygon.hardCodedOrthogonalWallContacts{3}(i,:);
%       %   ae = app.polygon.hardCodedOrthogonalWallContacts{n}(i,:);
%       asf = app.polygon.outOfBoundsPolys{n}(i,:,:);
%          delete(ab);
%          delete(ac);
%      end

end