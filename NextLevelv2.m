function NextLevel(app)
    delete(app.particlePoints);
    app.MagForceRestrictMAM2EditField.Value = 0;
    app.NumberofParticlesEditField.Value = 10;
    app.FluidFlowmsEditField.Value = 0;
    app.MagForceRestrictMAM2EditField.Value = 0;
    fclose(app.fileID);
    app.ScenarioEditField.Value = "Test " + app.testNumber;
    app.goalIndex = 1;
    rotation = 0;
    app.polygon = app.polygon.change(3, 0);%NEED to reset mesh if using rotations%rotation);
    %don't redo the mesh, just rotate.
    tr = triangulation(polyshape(app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2)));
    model = createpde(1);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    g = model.geometryFromMesh(tnodes, telements);
    app.mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
    rotate(g,rotation);
  %  oldNodes = model.Mesh.Nodes;
  %  elements = model.Mesh.Elements;
 %   for l = 1:length(oldNodes)
 %       a = oldNodes(:,l)
 %       oldNodes(:,l) = [cosd(rotation), sind(rotation); -sind(rotation), cos(rotation)] * app.mesh.Nodes(:,l);
 %   end
 %   app.mesh.Nodes = oldNodes;
  %  app.mesh = geometryFromMesh(model,oldNodes, elements);

    app.fd.rotate(rotation);
    switch(app.testNumber)
        case(1) %low flow, no restrict
          %   app.polygon = app.polygon.change(3); %TODO make a 1 bifurcation set of tests. Switch bifurcations around when needed.
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.005;
             app.TimeRemainingsEditField.Value = 8;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(2)
             app.goalIndex = 2;
             app.polygon = app.polygon.change(2,90);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.005;
             app.TimeRemainingsEditField.Value = 8;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(3)
           %  app.polygon = app.polygon.change(3);
             app.polygon = app.polygon.change(3,180);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.005;
             app.TimeRemainingsEditField.Value = 8;
             app.MagForceRestrictMAM2EditField.Value = 0;
        case(4) %0.01, add restrict
             app.goalIndex = 2;
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 7;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(5)
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 7;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(6)
             app.goalIndex = 2;
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 7;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(7)
           %  app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 7;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(8)
             app.goalIndex = 2;
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 7;
             app.MagForceRestrictMAM2EditField.Value = 1;
         case(9)
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.01;
             app.TimeRemainingsEditField.Value = 7;
             app.MagForceRestrictMAM2EditField.Value = 1;
         case(10) %0.015, add restrict
             app.goalIndex = 2;
           %  app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(11)
           %  app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(12)
             app.goalIndex = 2;
           %  app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(13)
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(14)
             app.goalIndex = 2;
           %  app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 1;
         case(15)
         %    app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.015;
             app.TimeRemainingsEditField.Value = 5;
             app.MagForceRestrictMAM2EditField.Value = 1;
        case(16) %0.02, add restrict
             app.goalIndex = 2;
         %    app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 4;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(17)
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 4;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(18)
             app.goalIndex = 2;
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 4;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(19)
         %    app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 4;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(20)
             app.goalIndex = 2;
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 4;
             app.MagForceRestrictMAM2EditField.Value = 1;
         case(21)
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.02;
             app.TimeRemainingsEditField.Value = 4;
             app.MagForceRestrictMAM2EditField.Value = 1;
        case(22) %0.025, add restrict
             app.goalIndex = 2;
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 3;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(23)
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 3;
             app.MagForceRestrictMAM2EditField.Value = 0;
         case(24)
             app.goalIndex = 2;
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 3;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(25)
           %  app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 3;
             app.MagForceRestrictMAM2EditField.Value = 1.5;
         case(26)
             app.goalIndex = 2;
          %   app.polygon = app.polygon.change(3);
             app.NumberofParticlesEditField.Value = 50;
             app.FluidFlowmsEditField.Value = 0.025;
             app.TimeRemainingsEditField.Value = 3;
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
    delete(app.wrongEndLine); 
    app.polyLine = plot(app.UIAxes,app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2), 'Color','b');
    for(lineCount = 1:length(app.polygon.currentEndZone)-1)
        app.wrongEndLine(lineCount) = plot(app.UIAxes,app.polygon.currentEndZone(lineCount,:,1),app.polygon.currentEndZone(lineCount,:,2), 'Color','r');
    end 
    app.X1MAGauge.Value = 0;
    app.Y1MAGauge.Value = 0;
    app.endLine = plot(app.UIAxes,app.polygon.currentEndZone(app.goalIndex,:,1),app.polygon.currentEndZone(app.goalIndex,:,2), 'Color','g');
    app.fd = FlowData();
    app.haltParticlesInEndZone = zeros(app.numParticles,1);
    app.currentlyDoingWorkSemaphore = false;
    app.timePassed = 0;
    app.timestep = 0;
    app.timeLag = 0;
    app.mousePosition = [0 0];
    app.magLine = plot(app.UIAxes,0,0);    
end

