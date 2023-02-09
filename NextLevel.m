function NextLevel(app)
    delete(app.particlePoints);
    fclose(app.fileID);
    app.ScenarioEditField.Value = "Test " + app.testNumber;
    app.polygon = app.polygon.change(2,app.fd);
    app.rotation = 0;
    app.NumberofParticlesEditField.Value = 50;
    app.FluidFlowmsEditField.Value = 0.005;
    app.MagForceRestrictMAM2EditField.Value = 0;
    generateNewParticles = true;
    app.hapticFeedback = [0,0,0];
    app.slowDown = 1;
    app.goalIndex = 2;
    app.HapticForceSlider.Enable = false;
 %   minTimeToTravel = 1.7;
    minTimeToTravel = 10;
%   minTimeToTravel = 4 * (0.005 ./ app.FluidFlowmsEditField.Value); %4 paths, length, velocity
   % meshLocations = app.fd.FlowLocations{1};
    switch(floor((app.testOrder(app.testNumber)-1)/1)) %Do n of each
        
%         case(0)
%             app.polygon = app.polygon.change(3,app.fd);
% %             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 1;
%            % app.FluidFlowmsEditField.Value = 0.001;
%             app.slowDown = 1;
% %             app.goalIndex = 3;
%             app.goalIndex = 1;
%          %   minTimeToTravel = 3;
%         %    meshLocations = app.fd.FlowLocations{4};
%         %    app.currentFlowValues = app.fd.FlowValues{4};

        
%         case(1)
%             app.polygon = app.polygon.change(4,app.fd);
%             app.FluidFlowmsEditField.Value = 1;
%            % app.FluidFlowmsEditField.Value = 0.001;
%             app.slowDown = 1;
%             app.goalIndex = 3;
%          %   minTimeToTravel = 3;
%         %    meshLocations = app.fd.FlowLocations{4};
%         %    app.currentFlowValues = app.fd.FlowValues{4};


        case(0)
            app.fd = FlowData05();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
          %  app.slowDown = 2;
            minTimeToTravel = 150;
        case(1)
            app.fd = FlowData10();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
           %app.slowDown = 2;
            minTimeToTravel = 150;
        case(2)
            app.fd = FlowData15();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
           % app.slowDown = 8;
            minTimeToTravel = 150;
        case(3)
            app.fd = FlowData20();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
           % app.slowDown = 16;
            minTimeToTravel = 150;
        case(4)
            app.fd = FlowData25();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
            minTimeToTravel = 150;
        case(5)
            app.fd = FlowData30();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
            minTimeToTravel = 150;
        case(6)
            app.fd = FlowData35();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
            minTimeToTravel = 150;
        case(7)
            app.fd = FlowData40();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
            minTimeToTravel = 120;
        case(8)
            app.fd = FlowData45();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
            minTimeToTravel = 120;
        case(9)
            app.fd = FlowData50();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
            minTimeToTravel = 120;
        case(10)
            app.fd = FlowData55();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
            minTimeToTravel = 120;
        case(11)
            app.fd = FlowData60();
            app.polygon = app.polygon.change(4,app.fd);
            app.FluidFlowmsEditField.Value = 1;
            app.goalIndex = 4;
            minTimeToTravel = 120;
        otherwise
            fprintf("The experiment has now ended, thank you for your participation. Please close this window.\r\n");
            app.polygon = app.polygon.change(1,app.fd);
            app.NumberofParticlesEditField.Value = 10;
            app.FluidFlowmsEditField.Value = 0;
            app.TimeRemainingsEditField.Value = 1200;
            app.MagForceRestrictMAM2EditField.Value = 0;
%             meshLocations = app.fd.FlowLocations{1};
%             app.currentFlowValues = app.fd.FlowValues{1};
    end    


    app.TimeRemainingsEditField.Value = minTimeToTravel;% .* 5;%2.5;TODO RESET ME
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


 %   app.mesh = alphaShape(meshLocations(:,1),meshLocations(:,2));
%     app.mesh = delaunayTriangulation(meshLocations);
    app.mesh = delaunayTriangulation(app.polygon.currentFlowLocations);


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

%    tr = triangulation(polyshape(app.polygon.currentPoly(:,1),app.polygon.currentPoly(:,2)));
%    model = createpde(1);
%    tnodes = tr.Points';
%    telements = tr.ConnectivityList';
%    g = model.geometryFromMesh(tnodes, telements);
%    app.mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.

end

