function NextLevel(app)

%This file is for the validation DEC2023 %ParametricV2

    NUMOFEACH = 10; %120 total
    NUMOFEACH = 1;
    waitEvery = 100;

    %Reset the rng so it's deterministic
    rng(1000,"twister");

    delete(app.particlePoints);
    fclose(app.fileID);
    app.ScenarioEditField.Value = "Test " + app.testNumber;
    app.polygon = app.polygon.change(4,app.fd);
    app.goalIndex = 5;
    app.rotation = 0; 
  %  app.NumberofParticlesEditField.Value = 3; %just check they are the same times.
    app.numParticles = app.NumberofParticlesEditField.Value;
    app.FluidFlowmsEditField.Value = 0.00; %NO Flow for validation
    app.MagForceRestrictTmEditField.Value = 1;
    app.hapticFeedback = [0,0,0];
    app.slowDown = 1;
    minTimeToTravel = 10; 
    app.PercentageinGoalEditField.Value = 0;
    mSAT = 12;
    app.ParticleDensitygmlEditField.Value = 4.8;
    app.IndividualDiameterEditField.Value = 75 *10^-9;

    app.FluidFlowmsEditField.Value = 10;

    permeabilityOfFreeSpace = 1.25663706e-6;
    fieldInMT = 3;
    mSAT = 1 + 19 * (fieldInMT .* 10).^(0.16); %2mt %31.687?
    aggregateLength = 0;
    individualDiameter= 75 *10^-9;
    chainLength = 12000;
 
    if(aggregateLength~=0)
        chainLength = aggregateLength /individualDiameter;  
    end
      
    density = 4.8 * 1000; %density in g/cm3, change to  kg/m3 with the 1000
    particleDiameter = (1.5*chainLength * individualDiameter^3 )^(1/3);
    particleMass = 4/3*pi*density * (particleDiameter/2)^3; %This is in kilograms
    app.FluidViscocityEditField.Value = 0.001; %water is 0.001

    app.ParticleDiametermEditField.Value = particleDiameter;
    app.ParticleMasskgEditField.Value = particleMass;



    generateNewParticles = true;
  %  app.particleArrayLocation = [-0.0094 -0.00325; -0.0094 -0.0035; -0.0094 -0.00375];
  %  app.particleArrayVelocity = [0 0; 0 0; 0 0;];%[0.000223979975848616 0;0.000223979975848616 0;0.000223979975848616 0];

    % switch(floor((app.testNumber-1)/10)) %Do n of each        
    %     case(0)
    %         % app.FluidFlowmsEditField.Value = 0.005;
    %         % generateNewParticles = false;
    %         % app.particleArrayLocation(1:app.numParticles/2,:) = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones(2,2,:,:)), app.numParticles/2);
    %         % app.particleArrayLocation((app.numParticles/2+1):app.numParticles,:) = app.particleFunctions.generate articleLocations(squeeze(app.polygon.allStartZones(2,4,:,:)), app.numParticles/2);
    %     case(1)
    % 
    %     otherwise
    %          fprintf("The experiment has now ended, thank you for your participation. Please close this window.\r\n");
    %          app.polygon = app.polygon.change(1);
    %          app.NumberofParticlesEditField.Value = 10;
    %          app.FluidFlowmsEditField.Value = 0;
    %          app.TimeRemainingsEditField.Value = 1200;
    %          app.MagForceRestrictTmEditField.Value = 0;
    % end    

    app.particleFunctions.magneticForceConstant = double(permeabilityOfFreeSpace .* mSAT .* density .* 4/3.*pi.*(particleDiameter/2)^3);% .* 22; %22 is conversion factor
    app.particleFunctions.dragForceConstant = double(3*pi * app.FluidViscocityEditField.Value * individualDiameter);%particleDiameter);
 

  %  minTimeToTravel = 4 * (0.005 ./ app.FluidFlowmsEditField.Value); %4 paths, length, velocity
    minTimeToTravel = 2;
    app.TimeRemainingsEditField.Value = minTimeToTravel .* 5;
    app.timeLimit = app.TimeRemainingsEditField.Value;    
    app.previousMagforce = 0;
    app.lastUpdate = clock;
    paddedTestNumber = sprintf( '%04d', app.testNumber);
    newFileName = "Test" + paddedTestNumber + "_" + app.lastUpdate(4) + "_" + app.lastUpdate(5) + "_results.csv";
    app.fileID = fopen(newFileName,'w');
    app.loopComplete = true;            
    app.particlePoints = plot(app.UIAxes,0,0);
    app.tMax = 1;

    app.mesh = delaunayTriangulation(app.polygon.currentFlowLocations);
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
    app.bouncedLastLoop = zeros(app.numParticles,1); 
    hold (app.UIAxes, 'on');
    delete(app.polyLine);
    delete(app.endLine);
    delete(app.wrongEndLine); 
    
    rotateMatrix = [cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)];
    rotatedOutline = (rotateMatrix * app.polygon.currentPoly')';
    app.polyLine = plot(app.UIAxes, rotatedOutline(:,1), rotatedOutline(:,2), 'Color','b');


    %set(app.UIAxes,'padded')
     app.UIAxes.XLim = [min(app.polygon.currentPoly(:,1)) + (min(app.polygon.currentPoly(:,1))/20), max(app.polygon.currentPoly(:,1)) + (max(app.polygon.currentPoly(:,1))/20)];
    app.UIAxes.YLim = [min(app.polygon.currentPoly(:,2)) + (min(app.polygon.currentPoly(:,2))/20), max(app.polygon.currentPoly(:,2)) + (max(app.polygon.currentPoly(:,2))/20)];


   % for(lineCount = 1:length(app.polygon.currentEndZone)-1)%??
    for(lineCount = 1:length(app.polygon.currentEndZone))
        rotatedEndZone = (rotateMatrix * squeeze(app.polygon.currentEndZone(lineCount,:,:))')';
        app.wrongEndLine(lineCount) = plot(app.UIAxes, rotatedEndZone(:,1), rotatedEndZone(:,2), 'Color','r');
        if(lineCount == app.goalIndex)
            app.endLine = plot(app.UIAxes, rotatedEndZone(:,1), rotatedEndZone(:,2), 'Color','g');
        end
    end 
    app.previousMagforce = 0;
  %  app.X1TmGauge.Value = 0;
  %  app.Y1TmGauge.Value = 0;
    %app.fd = FlowData();
    app.haltParticlesInEndZone = zeros(app.numParticles,1);
    app.currentlyDoingWorkSemaphore = false;
    app.timePassed = 0;
    app.timestep = 0;
    app.timeLag = 0;
    app.mousePosition = [0 0];
    app.magLine = plot(app.UIAxes,0,0);    


   % app.X1MAGauge.Value = 10^6 .* (0.25+0.25*app.testNumber).*1.2566;% .* 1.5;
   % app.X1MAGauge.Value = 10^6 .* (0.1+0.1*app.testNumber);%.*1.5;
   % app.Y1MAGauge.Value = 0;


    pause(0.3);
    import java.awt.*;
    import java.awt.event.*;
    %Create a Robot-object to do the key-pressing
    rob=Robot;
    %Commands for pressing keys:
    % If the text cursor isn't in the edit box allready, then it
    % needs to be placed there for ctrl+a to select the text.
    % Therefore, we make sure the cursor is in the edit box by
    % forcing a mouse button press:
    rob.mousePress(InputEvent.BUTTON1_MASK );
    rob.mouseRelease(InputEvent.BUTTON1_MASK );
    % CONTROL + A : 
    rob.keyPress(KeyEvent.VK_SPACE)
    rob.keyRelease(KeyEvent.VK_SPACE)

    %This is old I think - check and REMOVEME
    % tr = triangulation(polyshape(app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2)));
    % model = createpde(1);
    % tnodes = tr.Points';
    % telements = tr.ConnectivityList';
    % g = model.geometryFromMesh(tnodes, telements);
    % app.mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
end

