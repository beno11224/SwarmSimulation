function NextLevel(app)
    delete(app.particlePoints);
    fclose(app.fileID);
    app.ScenarioEditField.Value = "Test " + app.testNumber;
    app.polygon = app.polygon.change(2);
    app.goalIndex = 1;
    app.rotation = 0;
    app.NumberofParticlesEditField.Value = 50;
    app.FluidFlowmsEditField.Value = 0.01;
    app.MagForceRestrictMAM2EditField.Value = 0;
    generateNewParticles = true;
    switch(floor((app.testNumber-1)/2)) %Do n of each
        %0.005 m/s
        %For Demos!!!
        case(0)
            app.polygon.change(3);
        case(1)
            app.polygon.change(3);
            app.goalIndex = 2;
            generateNewParticles = false;
            app.particleArrayLocation = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,2,:,:)), app.numParticles);
        case(2)
            app.polygon.change(3);
            generateNewParticles = false;
            app.particleArrayLocation(1:app.numParticles/2,:) = app.particleFunctions.generateParticleLocations(app.polygon.currentStartZone, app.numParticles/2);
            app.particleArrayLocation((app.numParticles/2+1):app.numParticles,:) = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,3,:,:)), app.numParticles/2);
        case(3)
            app.rotation = 180;
            app.polygon.change(3);
        case(4)
            app.rotation = 180;
            app.polygon.change(3);
            generateNewParticles = false;
            app.particleArrayLocation = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,2,:,:)), app.numParticles);
        case(5)
            app.rotation = 180;
            app.polygon.change(3);
            app.goalIndex = 2;
            generateNewParticles = false;
            app.particleArrayLocation(1:app.numParticles/2,:) = app.particleFunctions.generateParticleLocations(app.polygon.currentStartZone, app.numParticles/2);
            app.particleArrayLocation((app.numParticles/2+1):app.numParticles,:) = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,3,:,:)), app.numParticles/2);
        case(6)
            app.polygon.change(3);
            app.FluidFlowmsEditField.Value = 0.02;
        case(7)
            app.polygon.change(3);
            app.FluidFlowmsEditField.Value = 0.02;
            generateNewParticles = false;
            app.particleArrayLocation = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,2,:,:)), app.numParticles);
        case(8)
            app.polygon.change(3);
            app.FluidFlowmsEditField.Value = 0.02;
            generateNewParticles = false;
            app.particleArrayLocation(1:app.numParticles/2,:) = app.particleFunctions.generateParticleLocations(app.polygon.currentStartZone, app.numParticles/2);
            app.particleArrayLocation((app.numParticles/2+1):app.numParticles,:) = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,3,:,:)), app.numParticles/2);
        case(9)
            app.rotation = 180;
            app.polygon.change(3);
            app.FluidFlowmsEditField.Value = 0.02;
        case(10)
            app.rotation = 180;
            app.polygon.change(3);
            app.FluidFlowmsEditField.Value = 0.02;
            generateNewParticles = false;
            app.particleArrayLocation = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,2,:,:)), app.numParticles);
        case(11)
            app.rotation = 180;
            app.polygon.change(3);
            app.FluidFlowmsEditField.Value = 0.02;
            generateNewParticles = false;
            app.particleArrayLocation(1:app.numParticles/2,:) = app.particleFunctions.generateParticleLocations(app.polygon.currentStartZone, app.numParticles/2);
            app.particleArrayLocation((app.numParticles/2+1):app.numParticles,:) = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,3,:,:)), app.numParticles/2);
        
        
        otherwise
             fprintf("The experiment has now ended, thank you for your participation. Please close this window.\r\n");
             app.polygon = app.polygon.change(1);
             app.NumberofParticlesEditField.Value = 10;
             app.FluidFlowmsEditField.Value = 0;
             app.TimeRemainingsEditField.Value = 1200;
             app.MagForceRestrictMAM2EditField.Value = 0;
    end    

    minTimeToTravel = 4 * (0.005 ./ app.FluidFlowmsEditField.Value); %4 paths, length, velocity
    app.TimeRemainingsEditField.Value = minTimeToTravel .* 3.5;%2.5;
    app.timeLimit = app.TimeRemainingsEditField.Value;
    app.numParticles = app.NumberofParticlesEditField.Value;
    app.previousMagforce = 0;
    app.lastUpdate = clock;
    newFileName = "Test" + app.testNumber + "_" + app.lastUpdate(4) + "_" + app.lastUpdate(5) + "_results.csv";
    app.fileID = fopen(newFileName,'w');
    app.loopComplete = true;            
    app.particlePoints = plot(app.UIAxes,0,0);
    app.tMax = 1;
    if(generateNewParticles)
        app.particleArrayLocation = app.particleFunctions.generateParticleLocations(app.polygon.currentStartZone, app.numParticles);
    end
    app.particleArrayVelocity = zeros(app.numParticles, 2);
    app.particleArrayForce = zeros(app.numParticles, 2);
    app.particleArrayPreviousLocation = app.particleArrayLocation;
    app.particleArrayBaseVelocity = zeros(app.numParticles, 2);
    app.particleArrayBaseVelocityStartTime = clock;
    app.particleArrayPreviousDragForce = zeros(app.numParticles, 2);
    app.particleArrayPreviousAcceleration = zeros(app.numParticles, 2);
    hold (app.UIAxes, 'on');
    delete(app.polyLine);
    delete(app.endLine);
    delete(app.wrongEndLine); 
    
    rotateMatrix = [cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)];
    rotatedOutline = (rotateMatrix * app.polygon.currentPoly')';
    app.polyLine = plot(app.UIAxes, rotatedOutline(:,1), rotatedOutline(:,2), 'Color','b');
    for(lineCount = 1:length(app.polygon.currentEndZone)-1)
        rotatedEndZone = (rotateMatrix * squeeze(app.polygon.currentEndZone(lineCount,:,:))')';
        app.wrongEndLine(lineCount) = plot(app.UIAxes, rotatedEndZone(:,1), rotatedEndZone(:,2), 'Color','r');
        if(lineCount == app.goalIndex)
            app.endLine = plot(app.UIAxes, rotatedEndZone(:,1), rotatedEndZone(:,2), 'Color','g');
        end
    end 
    app.previousMagforce = 0;
    app.X1MAGauge.Value = 0;
    app.Y1MAGauge.Value = 0;
    %app.fd = FlowData();
    app.haltParticlesInEndZone = zeros(app.numParticles,1);
    app.currentlyDoingWorkSemaphore = false;
    app.timePassed = 0;
    app.timestep = 0;
    app.timeLag = 0;
    app.mousePosition = [0 0];
    app.magLine = plot(app.UIAxes,0,0);    

    tr = triangulation(polyshape(app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2)));
    model = createpde(1);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    g = model.geometryFromMesh(tnodes, telements);
    app.mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
end

