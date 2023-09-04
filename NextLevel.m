function NextLevel(app)

%This file is for the ml training

    NUMOFEACH = 10; %120 total
    NUMOFEACH = 1;
    waitEvery = 25;

    delete(app.particlePoints);
    fclose(app.fileID);
    app.ScenarioEditField.Value = "Test " + app.testNumber;
    app.polygon = app.polygon.change(2,app.fd);
    app.rotation = 0;
    app.NumberofParticlesEditField.Value = 10;
    app.FluidFlowmsEditField.Value = 0.005;
    app.MagForceRestrictMAM2EditField.Value = 0;
    generateNewParticles = true;
    app.hapticFeedback = [0,0,0];
    app.slowDown = 1;
    app.goalIndex = 2;
    minTimeToTravel = 10;

   %replace switch with this
            app.fd = FlowData60(); %start at 30?
            app.polygon = app.polygon.change(4,app.fd);
        %    flowMultiplier = 1 + ((7/5)* (app.testNumber-1))
        %    app.FluidFlowmsEditField.Value = 1  + ((7/5)*(app.testNumber-1));
            app.FluidFlowmsEditField.Value = 1;
            if(ndims(app.polygon.currentStartZone) > 2)
                app.polygon.currentStartZone = squeeze(app.polygon.currentStartZone(1,:,:));
            end
            app.goalIndex = 4;
            app.slowDown = 1;
            minTimeToTravel = 20;


%     if(ndims(app.polygon.currentStartZone) > 2)
%         app.polygon.currentStartZone = squeeze(app.polygon.currentStartZone(1,:,:));
%     end
%     switch(floor((app.testOrder(app.testNumber)-1)/NUMOFEACH)) %Do n of each
% 
% 
% %%%% FOR THE SYSTEM TO REPRESENT ALI's, 2T/m means that the user can impart
% %%%% around 1.6MA/m maximum - drop by 1MA/m basically.
% 
% %1, 2.4, 3.8, 5.2, 6.6, 8
% 
%         case(0)
%             app.fd = FlowData60(); %start at 30?
%             app.polygon = app.polygon.change(4,app.fd);
%         %    flowMultiplier = 1 + ((7/5)* (app.testNumber-1))
%         %    app.FluidFlowmsEditField.Value = 1  + ((7/5)*(app.testNumber-1));
%             app.FluidFlowmsEditField.Value = 1;
%             if(ndims(app.polygon.currentStartZone) > 2)
%                 app.polygon.currentStartZone = squeeze(app.polygon.currentStartZone(1,:,:));
%             end
%             app.goalIndex = 4;
%             app.slowDown = 1;
%             minTimeToTravel = 15;
%         case(1)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%          %   flowMultiplier = 1 + ((7/5)*(app.testNumber-7)) %-6 if the prev is uncommented
%          %   app.FluidFlowmsEditField.Value = 1 + ((7/5)*(app.testNumber-7));
%             app.FluidFlowmsEditField.Value = 1;
%             app.goalIndex = 4;
%             app.slowDown = 1;
%             minTimeToTravel = 15;
%         case(2)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 2.4;
%             if(ndims(app.polygon.currentStartZone) > 2)
%                 app.polygon.currentStartZone = squeeze(app.polygon.currentStartZone(1,:,:));
%             end
%             app.goalIndex = 4;
%             app.slowDown = 1;
%             minTimeToTravel = 15;
%         case(3)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 2.4;
%             app.goalIndex = 4;
%             app.slowDown = 1;
%             minTimeToTravel = 15;
%         case(4)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 3.8;
%             if(ndims(app.polygon.currentStartZone) > 2)
%                 app.polygon.currentStartZone = squeeze(app.polygon.currentStartZone(1,:,:));
%             end
%             app.goalIndex = 4;
%             app.slowDown = 2;
%             minTimeToTravel = 12;
%         case(5)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 3.8;
%             app.goalIndex = 4;
%             app.slowDown = 2;
%             minTimeToTravel = 12;
%         case(6)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 5.2;
%             if(ndims(app.polygon.currentStartZone) > 2)
%                 app.polygon.currentStartZone = squeeze(app.polygon.currentStartZone(1,:,:));
%             end
%             app.goalIndex = 4;
%             app.slowDown = 2;
%             minTimeToTravel = 12;
%         case(7)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 5.2;
%             app.goalIndex = 4;
%             app.slowDown = 2;
%             minTimeToTravel = 12;
%         case(8)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 6.6;
%             if(ndims(app.polygon.currentStartZone) > 2)
%                 app.polygon.currentStartZone = squeeze(app.polygon.currentStartZone(1,:,:));
%             end
%             app.goalIndex = 4;
%             app.slowDown = 4;
%             minTimeToTravel = 10;
%         case(9)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 6.6;
%             app.goalIndex = 4;
%             app.slowDown = 4;
%             minTimeToTravel = 10;
%         case(10)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 8;
%             if(ndims(app.polygon.currentStartZone) > 2)
%                 app.polygon.currentStartZone = squeeze(app.polygon.currentStartZone(1,:,:));
%             end
%             app.goalIndex = 4;
%             app.slowDown = 4;
%             minTimeToTravel = 10;
%         case(11)
%             app.fd = FlowData60();
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 8;
%             app.goalIndex = 4;
%             app.slowDown = 4;
%             minTimeToTravel = 10;
%         otherwise
%             msgbox("The experiment has now ended, thank you for your participation. Please close this window.");
%             fprintf("The experiment has now ended, thank you for your participation. Please close this window.\r\n");
%             app.polygon = app.polygon.change(1,app.fd);
%             app.NumberofParticlesEditField.Value = 10;
%             app.FluidFlowmsEditField.Value = 0;
%             app.TimeRemainingsEditField.Value = 1200;
%             app.MagForceRestrictMAM2EditField.Value = 0;
%     end    

    app.TimeRemainingsEditField.Value = minTimeToTravel;% .* 5;%2.5;TODO RESET ME
    app.timeLimit = app.TimeRemainingsEditField.Value;
    app.numParticles = app.NumberofParticlesEditField.Value;
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
    app.particleArrayVelocity = app.particleFunctions.calculateFlow(app.particleArrayLocation,app.polygon.currentFlowValues,app.mesh);% zeros(app.numParticles, 2);
    
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



    for(lineCount = 1:size(app.polygon.currentEndZone,1))
        rotatedEndZone = (rotateMatrix * squeeze(app.polygon.currentEndZone(lineCount,:,:))')';
        app.wrongEndLine(lineCount) = plot(app.UIAxes, rotatedEndZone(:,1), rotatedEndZone(:,2), 'Color','r');
        if(lineCount == app.goalIndex)
            app.endLine = plot(app.UIAxes, rotatedEndZone(:,1), rotatedEndZone(:,2), 'Color','g');
        end
    end 
    app.previousMagforce = 0;
    app.X1MAGauge.Value = 0;
    app.Y1MAGauge.Value = 0;
   % app.fd = FlowData();
    app.haltParticlesInEndZone = zeros(app.numParticles,1);
    app.currentlyDoingWorkSemaphore = false;
    app.timePassed = 0;
    app.timestep = 0;
    app.timeLag = 0;
    app.mousePosition = [0 0];
    app.magLine = plot(app.UIAxes,0,0);    


    %Plotting flow
    if(false)
        plot(app.mesh.Points(:,1),app.mesh.Points(:,2),'r.')
        hold on
        for(i = 1:size(app.mesh.Points,1))
            plot([app.mesh.Points(i,1),app.mesh.Points(i,1)-app.polygon.currentFlowValues(i,1)*0.05],[app.mesh.Points(i,2),app.mesh.Points(i,2)-app.polygon.currentFlowValues(i,2)*0.05],'-');
            hold on
    %         if(mod(i,100) == 99)
    %             close all
    %             plot(app.mesh.Points(:,1),app.mesh.Points(:,2),'r.')
    %             hold on
    %         end
        end
    end




    %set(app.UIAxes,'padded')
    app.UIAxes.XLim = [min(app.polygon.currentPoly(:,1)) + (min(app.polygon.currentPoly(:,1))/20), max(app.polygon.currentPoly(:,1)) + (max(app.polygon.currentPoly(:,1))/20)];
    app.UIAxes.YLim = [min(app.polygon.currentPoly(:,2)) + (min(app.polygon.currentPoly(:,2))/20), max(app.polygon.currentPoly(:,2)) + (max(app.polygon.currentPoly(:,2))/20)];

    if(app.controlMethod ~= "TrainingModel")

        if(app.testNumber > 1 && mod(app.testNumber,waitEvery) == 0)
            switch(floor((app.testOrder(app.testNumber)-1)/NUMOFEACH)) %Do n of each
                case(0)
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 1/6","Information");
                case(1) 
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 1/6","Information");
                case(2)
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 2/6","Information");
                case(3) 
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 2/6","Information");
                case(4)
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 3/6","Information");
                case(5) 
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 3/6","Information");
                case(6)
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 4/6","Information");
                case(7) 
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 4/6","Information");
                case(8)
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 5/6","Information");
                case(9) 
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 5/6","Information");
                case(10)
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 6/6","Information");
                case(11) 
                    msgbox("Time to take a break. When ready to start again press the spacebar twice. Next Level difficulty 6/6","Information");
            end
        else
            switch(floor((app.testOrder(app.testNumber)-1)/NUMOFEACH)) %Do n of each
                case(0)
                    messageToUser = msgbox("Difficulty 1/6","Information");
                case(1) 
                    messageToUser = msgbox("Difficulty 1/6","Information");
                case(2)
                    messageToUser = msgbox("Difficulty 2/6","Information");
                case(3) 
                    messageToUser = msgbox("Difficulty 2/6","Information");
                case(4)
                    messageToUser = msgbox("Difficulty 3/6","Information");
                case(5) 
                    messageToUser = msgbox("Difficulty 3/6","Information");
                case(6)
                    messageToUser = msgbox("Difficulty 4/6","Information");
                case(7) 
                    messageToUser = msgbox("Difficulty 4/6","Information");
                case(8)
                    messageToUser = msgbox("Difficulty 5/6","Information");
                case(9) 
                    messageToUser = msgbox("Difficulty 5/6","Information");
                case(10)
                    messageToUser = msgbox("Difficulty 6/6","Information");
                case(11) 
                    messageToUser = msgbox("Difficulty 6/6","Information");
            end
            if(app.testNumber >= 1)
                pause(2);
                close(messageToUser);
            end
    
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
        end
    else
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
%    tr = triangulation(polyshape(app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2)));
%    model = createpde(1);
%    tnodes = tr.Points';
%    telements = tr.ConnectivityList';
%    g = model.geometryFromMesh(tnodes, telements);
%    app.mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
    app.printCounter = 0;

end

