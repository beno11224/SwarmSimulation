function NextLevel(app)
    delete(app.particlePoints);
    app.MagForceRestrictMAM2EditField.Value = 0;
    app.NumberofParticlesEditField.Value = 10;
    app.FluidFlowmsEditField.Value = 0;
    app.MagForceRestrictMAM2EditField.Value = 0;
    fclose(app.fileID);
    app.ScenarioEditField.Value = "Test " + app.testNumber;
    switch(app.testNumber)
        case(1) %low flow, no restrict
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 40;
             app.FluidFlowmsEditField.Value = 0.005;
             app.TimeRemainingsEditField.Value = 15;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(2)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.005;
             app.TimeRemainingsEditField.Value = 15;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(3)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.005;
             app.TimeRemainingsEditField.Value = 15;
             app.MagForceRestrictMAM2EditField.Value = 0;
        case(4) %0.01, add restrict
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(5)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(6)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(7)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(8)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 1;
         case(9)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 1;
         case(10) %0.015, add restrict
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(11)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(12)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(13)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(14)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 1;
         case(15)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 12;
             app.MagForceRestrictMAM2EditField.Value = 1;
        case(16) %0.02, add restrict
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 8;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(17)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 8;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(18)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 8;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(19)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 8;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(20)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 8;
             app.MagForceRestrictMAM2EditField.Value = 1;
         case(21)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 8;
             app.MagForceRestrictMAM2EditField.Value = 1;
        case(22) %0.025, add restrict
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(23)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(24)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 20;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(25)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(26)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 1;
         case(27)
             app.polygon = app.polygon.change(2);
             app.NumberofParticlesEditField.Value = 80;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 1;
        otherwise
             fprintf("The experiment has now ended, thank you for your participation. Please close this window.\r\n");
             app.polygon = app.polygon.change(1);
             app.NumberofParticlesEditField.Value = 10;
             app.FluidFlowmsEditField.Value = 0;
             app.TimeRemainingsEditField.Value = 1200;
             app.MagForceRestrictMAM2EditField.Value = 0;
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
    app.particleArrayLocation = app.particleFunctions.generateParticleLocations(app.polygon.currentStartZone, app.numParticles);          
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
    app.polyLine = plot(app.UIAxes,app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2), 'Color','b');
    app.endLine = plot(app.UIAxes,app.polygon.currentEndZone(1,:,1),app.polygon.currentEndZone(1,:,2), 'Color','g');
    app.fd = FlowData();
    app.haltParticlesInEndZone = zeros(app.numParticles,1);
    app.currentlyDoingWorkSemaphore = false;
    app.timePassed = 0;
    app.timestep = 0;
    app.timeLag = 0;
    app.mousePosition = [0 0];
    app.magLine = plot(app.UIAxes,0,0);
    app.X1MAGauge.Value = 0;
    app.Y1MAGauge.Value = 0;
    
    tr = triangulation(polyshape(app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2)));
    model = createpde(1);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    model.geometryFromMesh(tnodes, telements);
    app.mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
end

