function NextLevel(app)

%This file is for the Participant Experiment V2 (Mar/2024)

    if(app.testNumber > length(app.testOrder)) %confirm number of tests
        fprintf("The experiment has now ended, thank you for your participation. Please close this window.\r\n");
        msgbox("The experiment has now ended, thank you for your participation. Please close the simulator. It would be appreciated if you could fill out the quality control questionaire","Information");
        app.polygon = app.polygon.change(1, app.fd);
        app.NumberofParticlesEditField.Value = 10;
        app.FluidFlowmsEditField.Value = 0;
        app.TimeRemainingsEditField.Value = 1200;
        app.MagForceRestrictTmEditField.Value = 0;
        return
    end
    

    %Reset the rng so it's deterministic
    rng(1000,"twister");

    delete(app.particlePoints);
    if(app.fileID ~= -1)
        fclose(app.fileID);
    end

    %Set up environment
    waitEvery = 61; %so for 240 tests that's 3 breaks
    app.ScenarioEditField.Value = "Test " + app.testNumber;
    app.goalIndex = 4;
    app.rotation = 0; 
    app.NumberofParticlesEditField.Value = 500; %Sets the visual number
    app.numParticles = app.NumberofParticlesEditField.Value; %Set using the visual number
    app.MagForceRestrictTmEditField.Value = 1;
    app.hapticFeedback = [0,0,0];
    app.slowDown = 1;
    app.PercentageinGoalEditField.Value = 0;

    %Set up each test 'scenario' here
    %scenario = floor((app.testNumber-1)/10);   %In order - probably don't use this.
    scenario = floor((app.testOrder(app.testNumber)-1)/20); %Randomised order
    switch(scenario)
        case(0)
            app.fd = FlowData10();
        case(1)
            app.fd = FlowData20();
        case(2)
            app.fd = FlowData35();
        case(3)
            app.fd = FlowData40();
        case(4)
            app.fd = FlowData50();
        case(5)
            app.fd = FlowData60();
        case(6)
            app.rotation = 180;
            app.fd = FlowData10();
        case(7)
            app.rotation = 180;
            app.fd = FlowData20();
        case(8)
            app.rotation = 180;
            app.fd = FlowData35();
        case(9)
            app.rotation = 180;
            app.fd = FlowData40();
        case(10)
            app.rotation = 180;
            app.fd = FlowData50();
        case(11)
            app.rotation = 180;
            app.fd = FlowData60();
        % case(0)
        %     app.fd = FlowData05();
        % case(1)
        %     app.fd = FlowData10();
        % case(2)
        %     app.fd = FlowData15();
        % case(3)
        %     app.fd = FlowData20();
        % case(4)
        %     app.fd = FlowData25();
        % case(5)
        %     app.fd = FlowData30();
        % case(6)
        %     app.fd = FlowData35();
        % case(7)
        %     app.fd = FlowData40();
        % case(8)
        %     app.fd = FlowData45();
        % case(9) 
        %     app.fd = FlowData50();
        % case(10)
        %     app.fd = FlowData55();
        % case(11)
        %     app.fd = FlowData60();
    end
    app.MagneticFieldmTEditField.Value = 3;
    app.FluidFlowmsEditField.Value = 10;
    app.MagForceRestrictTmEditField.Value = 0.5;%1-(scenario./10);    
    app.ChainLengthEditField.Value = 12 .* app.MagForceRestrictTmEditField.Value.*1000 + 5000;
    app.polygon = app.polygon.change(4,app.fd); 
    generateNewParticles = true;

    %file operations and reset runtime vars
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
        
        %This is for one start location (clump start)
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
  %  app.UIAxes.XLim = [min(app.polygon.currentPoly(:,1)) + (min(app.polygon.currentPoly(:,1))/20), max(app.polygon.currentPoly(:,1)) + (max(app.polygon.currentPoly(:,1))/20)];
  %  app.UIAxes.YLim = [min(app.polygon.currentPoly(:,2)) + (min(app.polygon.currentPoly(:,2))/20), max(app.polygon.currentPoly(:,2)) + (max(app.polygon.currentPoly(:,2))/20)];
    app.UIAxes.XLim = [min(rotatedOutline(:,1)) + (min(rotatedOutline(:,1))/20), max(rotatedOutline(:,1)) + (max(rotatedOutline(:,1))/20)];
    app.UIAxes.YLim = [min(rotatedOutline(:,2)) + (min(rotatedOutline(:,2))/20), max(rotatedOutline(:,2)) + (max(rotatedOutline(:,2))/20)];

    app.particleFunctions = app.particleFunctions.ChangeMetaValues(1.25663706e-6, app.MagneticFieldmTEditField.Value, app.IndividualDiameterEditField.Value, app.ParticleDensitygmlEditField.Value, app.ChainLengthEditField.Value, app.FluidViscocityEditField.Value, app.CeffStat, app.CeffMotion, app.UIAxes.XLim(2));

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

    difficultyRating = mod(scenario,6);
    if(app.testNumber > 1 && mod(app.testNumber,waitEvery) == 0)
        handle = msgbox("Time to take a break. When ready to start again press the spacebar. Next Level difficulty " + (difficultyRating+1) + "/6","Information");
        set(handle, 'DeleteFcn', @msgBoxCloseCallback)
    else
        handle = msgbox("Difficulty " + (difficultyRating+1) + "/6","Information");
        set(handle, 'DeleteFcn', @msgBoxCloseCallback)
        pause(2);
        if ishandle(handle) && ~isempty(handle)
            close(handle);
        end
    end 
end

%callback to allow for better functionality with displaying message to
%user and carrying on with test
function msgBoxCloseCallback(~,~)
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

