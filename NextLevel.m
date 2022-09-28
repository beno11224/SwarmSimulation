function NextLevel(app)
    delete(app.particlePoints);
    fclose(app.fileID);
    app.ScenarioEditField.Value = "Test " + app.testNumber;
    app.polygon = app.polygon.change(2);
    app.goalIndex = 1;
    app.rotation = 0;
    app.NumberofParticlesEditField.Value = 50;
    app.FluidFlowmsEditField.Value = 0.005;
    app.MagForceRestrictMAM2EditField.Value = 0;
    app.TimeRemainingsEditField.Value = 1;
    generateNewParticles = true;
    newTime = true;
    switch(floor((app.testNumber-1)/2)) %Do n of each
        %0.005 m/s
        %For Demos!!!
        case(0)
            newTime = false;
            app.polygon.change(3);
        case(1)
            app.polygon.change(3);
            generateNewParticles = false;
            app.particleArrayLocation(1:app.numParticles/2,:) = app.particleFunctions.generateParticleLocations(app.polygon.currentStartZone, app.numParticles/2);
            app.particleArrayLocation((app.numParticles/2+1):app.numParticles,:) = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,3,:,:)), app.numParticles/2);
            app.goalIndex = 2;
        case(2)
            app.rotation = 90;
            app.polygon.change(3);
        case(3)
            app.rotation = 90;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(4)
            app.rotation = 180;
            app.polygon.change(3);
        case(5)
            app.rotation = 180;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(6)
            app.rotation = 270;
            app.polygon.change(3);
        case(7)
            app.rotation = 270;
            app.polygon.change(3);
            app.goalIndex = 2;
        %0.01 m/s         
        case(8) %low flow, no restrict
            app.FluidFlowmsEditField.Value = 0.01;
            app.polygon.change(3);
        case(9)
            app.FluidFlowmsEditField.Value = 0.01;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(10)
            app.rotation = 90;
            app.FluidFlowmsEditField.Value = 0.01;
            app.polygon.change(3);
        case(11)
            app.rotation = 90;
            app.FluidFlowmsEditField.Value = 0.01;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(12)
            app.rotation = 180;
            app.FluidFlowmsEditField.Value = 0.01;
            app.polygon.change(3);
        case(13)
            app.rotation = 180;
            app.FluidFlowmsEditField.Value = 0.01;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(14)
            app.rotation = 270;
            app.FluidFlowmsEditField.Value = 0.01;
            app.polygon.change(3);
        case(15)
            app.rotation = 270;
            app.FluidFlowmsEditField.Value = 0.01;
            app.polygon.change(3);
            app.goalIndex = 2;
        %0.015 m/s         
        case(16) %low flow, no restrict
            app.FluidFlowmsEditField.Value = 0.015;
            app.polygon.change(3);
        case(17)
            app.FluidFlowmsEditField.Value = 0.015;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(18)
            app.rotation = 90;
            app.FluidFlowmsEditField.Value = 0.015;
            app.polygon.change(3);
        case(19)
            app.rotation = 90;
            app.FluidFlowmsEditField.Value = 0.015;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(20)
            app.rotation = 180;
            app.FluidFlowmsEditField.Value = 0.015;
            app.polygon.change(3);
        case(21)
            app.rotation = 180;
            app.FluidFlowmsEditField.Value = 0.015;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(22)
            app.rotation = 270;
            app.FluidFlowmsEditField.Value = 0.015;
            app.polygon.change(3);
        case(23)
            app.rotation = 270;
            app.FluidFlowmsEditField.Value = 0.015;
            app.polygon.change(3);
            app.goalIndex = 2;
        %0.02 m/s         
        case(24) %low flow, no restrict
            app.FluidFlowmsEditField.Value = 0.02;
            app.polygon.change(3);
        case(25)
            app.FluidFlowmsEditField.Value = 0.02;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(26)
            app.rotation = 90;
            app.FluidFlowmsEditField.Value = 0.02;
            app.polygon.change(3);
        case(27)
            app.rotation = 90;
            app.FluidFlowmsEditField.Value = 0.02;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(28)
            app.rotation = 180;
            app.FluidFlowmsEditField.Value = 0.02;
            app.polygon.change(3);
        case(29)
            app.rotation = 180;
            app.FluidFlowmsEditField.Value = 0.02;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(30)
            app.rotation = 270;
            app.FluidFlowmsEditField.Value = 0.02;
            app.polygon.change(3);
        case(31)
            app.rotation = 270;
            app.FluidFlowmsEditField.Value = 0.02;
            app.polygon.change(3);
            app.goalIndex = 2;
        %0.025 m/s         
        case(32) %low flow, no restrict
            app.FluidFlowmsEditField.Value = 0.025;
            app.polygon.change(3);
        case(33)
            app.FluidFlowmsEditField.Value = 0.025;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(34)
            app.rotation = 90;
            app.FluidFlowmsEditField.Value = 0.025;
            app.polygon.change(3);
        case(35)
            app.rotation = 90;
            app.FluidFlowmsEditField.Value = 0.025;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(36)
            app.rotation = 180;
            app.FluidFlowmsEditField.Value = 0.025;
            app.polygon.change(3);
        case(37)
            app.rotation = 180;
            app.FluidFlowmsEditField.Value = 0.025;
            app.polygon.change(3);
            app.goalIndex = 2;
        case(38)
            app.rotation = 270;
            app.FluidFlowmsEditField.Value = 0.025;
            app.polygon.change(3);
        case(39)
            app.rotation = 270;
            app.FluidFlowmsEditField.Value = 0.025;
            app.polygon.change(3);
            app.goalIndex = 2;
        
        otherwise
             fprintf("The experiment has now ended, thank you for your participation. Please close this window.\r\n");
             app.polygon = app.polygon.change(1);
             app.NumberofParticlesEditField.Value = 10;
             app.FluidFlowmsEditField.Value = 0;
             app.TimeRemainingsEditField.Value = 1200;
             app.MagForceRestrictMAM2EditField.Value = 0;
    end    

    minTimeToTravel = 4 * (0.005 ./ app.FluidFlowmsEditField.Value); %4 paths, length, velocity
    if(newTime)
        app.TimeRemainingsEditField.Value = minTimeToTravel .* 2.5;
    end
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

