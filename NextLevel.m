function NextLevel(app)

%This file is for the Participant Experiment V2 (Mar/2024)

    if(app.testNumber > 120) %confirm number of tests
        fprintf("The experiment has now ended, thank you for your participation. Please close this window.\r\n");
        msgbox("The experiment has now ended, thank you for your participation. Please close the simulator. It would be appreciated if you could fill out the quality control questionaire","Information");
        app.polygon = app.polygon.change(1, app.fd);
        app.NumberofParticlesEditField.Value = 10;
        app.FluidFlowmsEditField.Value = 0;
        app.TimeRemainingsEditField.Value = 1200;
        app.MagForceRestrictTmEditField.Value = 0;
        return
    end
    
    NUMOFEACH = 10; %120 total
    waitEvery = 40; %so for 120 tests that's 3 breaks

    %Reset the rng so it's deterministic
    rng(1000,"twister");

    delete(app.particlePoints);
    fclose(app.fileID);
    app.ScenarioEditField.Value = "Test " + app.testNumber;
    app.goalIndex = 4;
    app.rotation = 0; 
    app.NumberofParticlesEditField.Value = 500; %
    app.numParticles = app.NumberofParticlesEditField.Value;
    app.MagForceRestrictTmEditField.Value = 1;
    app.hapticFeedback = [0,0,0];
    app.slowDown = 1;
    minTimeToTravel = 15; 
    app.PercentageinGoalEditField.Value = 0;

    scenario = floor((app.testNumber-1)/10);   
    switch(scenario)       
        case(0)
            app.fd = FlowData05();
        case(1)
            app.fd = FlowData10();
        case(2)
            app.fd = FlowData15();
        case(3)
            app.fd = FlowData20();
        case(4)
            app.fd = FlowData25();
        case(5)
            app.fd = FlowData30();
        case(6)
            app.fd = FlowData35();
        case(7)
            app.fd = FlowData40();
        case(8)
            app.fd = FlowData45();
        case(9) 
            app.fd = FlowData50();
        case(10)
            app.fd = FlowData55();
        case(11)
            app.fd = FlowData60();
    end
    app.MagneticFieldmTEditField.Value = 3;
    app.FluidFlowmsEditField.Value = 10;
    app.MagForceRestrictTmEditField.Value = 0.5;%1-(scenario./10);    
    app.ChainLengthEditField.Value = 12 .* app.MagForceRestrictTmEditField.Value.*1000 + 5000;
    app.polygon = app.polygon.change(4,app.fd);
 
    generateNewParticles = true;
    %app.particleArrayLocation = [-0.0094 -0.00325; -0.0094 -0.0035; -0.0094 -0.00375];
    %app.particleArrayVelocity = [0 0; 0 0; 0 0;];%[0.000223979975848616 0;0.000223979975848616 0;0.000223979975848616 0];

    minTimeToTravel = 10;
    app.TimeRemainingsEditField.Value = minTimeToTravel .* 5;
    app.timeLimit = app.TimeRemainingsEditField.Value;    
    app.previousMagforce = 0;
    app.lastUpdate = clock;
    paddedTestNumber = sprintf( '%04d', app.testNumber);
    newFileName = "Test" + paddedTestNumber + "_" + app.lastUpdate(4) + "_" + app.lastUpdate(5) + "_results.csv";
    app.fileID = fopen(newFileName,'w');
    app.loopComplete = true;             
    app.tMax = 1;

    app.mesh = delaunayTriangulation(app.polygon.currentFlowLocations);
    if(generateNewParticles)
        % %This is for two locations (split start)
        % app.particleArrayLocation(1:app.numParticles/2,:) = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones{3}), app.numParticles/2);
        % app.particleArrayLocation((app.numParticles/2+1):app.numParticles,:) = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones{4}(2,:,:)), app.numParticles/2);

       app.particleArrayLocation = app.particleFunctions.generateParticleLocations(squeeze(app.polygon.allStartZones{3}), app.numParticles);
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

    app.particleFunctions = app.particleFunctions.ChangeMetaValues(1.25663706e-6, app.MagneticFieldmTEditField.Value, app.IndividualDiameterEditField.Value, app.ParticleDensitygmlEditField.Value, app.ChainLengthEditField.Value, app.FluidViscocityEditField.Value, app.CeffStat, app.CeffMotion, app.UIAxes.XLim(2));

   % for(lineCount = 1:length(app.polygon.currentEndZone)-1)%??
    for(lineCount = 1:length(app.polygon.currentEndZone))
        rotatedEndZone = (rotateMatrix * squeeze(app.polygon.currentEndZone(lineCount,:,:))')';
        app.wrongEndLine(lineCount) = plot(app.UIAxes, rotatedEndZone(:,1), rotatedEndZone(:,2), 'Color','r');
        if(lineCount == app.goalIndex)
            app.endLine = plot(app.UIAxes, rotatedEndZone(:,1), rotatedEndZone(:,2), 'Color','g');
        end
    end 
    app.previousMagforce = 0;
    app.haltParticlesInEndZone = zeros(app.numParticles,1);
    app.currentlyDoingWorkSemaphore = false;
    app.timePassed = 0;
    app.timestep = 0;
    app.timeLag = 0; 
    app.mousePosition = [0 0];
    app.magLine = plot(app.UIAxes,0,0);    

   difficluty = 1;
    if(app.testNumber > 1 && mod(app.testNumber,waitEvery) == 0)
        msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty " + difficluty + "/6","Information");
    else
        messageToUser = msgbox("Difficulty " + difficluty + "/6","Information");
        
        % if(app.testNumber >= 1) %is there much point to this??
        %     pause(2);
        %     close(messageToUser);
        % end
        pause(0.5);
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
    end
end

