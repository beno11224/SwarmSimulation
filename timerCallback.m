function timerCallback(app)
    %if(~app.currentlyDoingWorkSemaphore)
    %   app.currentlyDoingWorkSemaphore = true; %let the earlier tasks complete first, try and force other to leave things alone        
        


    currentMagforce = app.particleFunctions.calculateMagneticForce([app.X1MAGauge.Value app.Y1MAGauge.Value],app.joyStick, 1, 3, app.controlMethod, app.mousePosition, app.MagForceRestrictMAM2EditField.Value, app.rotation);
    currentDial = currentMagforce ./10^6 ./ app.particleFunctions.magneticForceConstant;
    hapticSpring = 5;
    hapticViscocity = 0.5;
    app.hapticVelocity = [0,currentDial(1),currentDial(2)] - app.hapticFeedback;
    app.hapticFeedback = [0,currentDial(1),currentDial(2)];
    hapticForce = app.hapticFeedback(size(app.hapticFeedback,1),:) .* hapticSpring + app.hapticVelocity(size(app.hapticVelocity,1),:) .* hapticViscocity;
    WriteHaptic(hapticForce(1), -hapticForce(2), -hapticForce(3));

    if(app.controlMethod == "Controller")
        app.X1MAGauge.Value = currentDial(1);% ./10^6 ./ app.particleFunctions.magneticForceConstant;
        app.Y1MAGauge.Value = currentDial(2);% ./10^6 ./ app.particleFunctions.magneticForceConstant;
    end

    %TODO ADD THIS BACK IN
    vFlow = app.particleFunctions.calculateFlow(real(app.particleArrayLocation), app.fd.FlowValues, app.mesh);
    vFlow = vFlow .* app.FluidFlowmsEditField.Value;
    %vFlow = [0 0];

    magForceAlpha = 0.05;
    magForce = app.previousMagforce;
    smallerTMaxTotalSteps = 50; %Any more speed comes from making the sim more efficient or slowing it down (not real time) %150
    smallerTMaxStep = app.simTimerPeriod / smallerTMaxTotalSteps;
    smallerTMaxStepReduced = smallerTMaxStep / app.slowDown;
    for smallerTMaxIndex = 1:smallerTMaxTotalSteps 
        
        magForce = magForce .* (1-magForceAlpha) + currentMagforce.* magForceAlpha;
        app.particleArrayForce = magForce;

        %determine if particles are in collision with the wall - particles are inelastic - no bouncing.
        [wallContact, orthogonalWallContact, app.particleArrayLocation, app.particleArrayVelocity] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.polygon, smallerTMaxStepReduced);

        %drag (using last iterations velocity)
        dragForce = app.particleFunctions.calculateDragForce(app.particleArrayVelocity, vFlow);
        app.particleArrayForce = app.particleArrayForce - dragForce;

       % exportgraphics(app.UIAxes,'test.png','Resolution',1200);
       % exportapp(app.UIFigure,'testFig.pdf');
      %  exportapp(app.UIFigure,'testFig.png');
        
        %friction
        app.particleArrayForce = app.particleArrayForce - app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, orthogonalWallContact);

        app.particleArrayForce = app.particleArrayForce .* ~app.haltParticlesInEndZone;
        app.particleArrayVelocity = app.particleArrayVelocity .* ~app.haltParticlesInEndZone;
        temporaryVelocity = app.particleArrayVelocity;
        temporaryLocation = app.particleArrayLocation;
        
        %calculate the new locations 
        app.particleArrayLocation = app.particleFunctions.calculateCurrentLocationCD(app.particleArrayLocation, temporaryVelocity, app.particleArrayPreviousAcceleration, smallerTMaxStepReduced);
        %Make sure that we have the correct data stored for the next loop.        
        %calculate the new velocity
        [app.particleArrayVelocity,app.particleArrayPreviousAcceleration] = app.particleFunctions.calculateCurrentVelocityCD(orthogonalWallContact, wallContact, temporaryVelocity, app.particleArrayPreviousAcceleration, app.particleArrayForce, app.particleFunctions.particleMass, smallerTMaxStepReduced);
        app.particleArrayPreviousLocation = temporaryLocation;

        particlesInEndZone = app.particleFunctions.isParticleInEndZone(app.polygon.currentEndZone,app.particleArrayLocation);
        app.haltParticlesInEndZone = any(particlesInEndZone,2);
        goalPercentage = sum(particlesInEndZone,1) ./ app.numParticles;
        goalPercentage = goalPercentage(app.goalIndex);
        
        if(app.timestep == 0)
            app.timePassed = app.timePassed + smallerTMaxStepReduced;
        else                
            app.timePassed = app.timePassed + app.timestep / smallerTMaxTotalSteps;        
        end
    end
    %fprintf(app.fileID, app.timePassed + "," + app.timeLag + "," + mat2str(magForce) + "," + mat2str(dragForce)+ "," + goalPercentage + "," + mat2str(app.particleArrayVelocity)+ "," + mat2str(app.particleArrayLocation) + "\r\n");
    %Now rotate location values:
    rotMat = [cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)];
    rotForce = (rotMat * [app.X1MAGauge.Value ; app.Y1MAGauge.Value])';
    rotVel = (rotMat * app.particleArrayVelocity')';
    rotLoc = (rotMat * app.particleArrayLocation')';
    if(app.printCounter >= app.slowDown)
        fprintf(app.fileID, app.timePassed + "," + mat2str(rotForce) + "," + goalPercentage + "," + mat2str(rotVel)+ "," + mat2str(rotLoc) + "\r\n");
        app.printCounter = 1;
    else
        app.printCounter = app.printCounter + 1;
    end
    if(app.timeLimit > 0 && app.timePassed <= app.timeLimit)
        app.TimeRemainingsEditField.Value = round(app.timeLimit - app.timePassed);
        app.PercentageinGoalEditField.Value = round(goalPercentage .* 100);
    else
        if(app.timeLimit > 0)
            stop(app.simulationTimerProperty);
            stop(app.drawTimerProperty);
            app.StartTrainingButton.Enable = true;
            set(app.StartTrainingButton,'Text',"Start Next Level");
            set(app.StartTrainingButton,'BackgroundColor',[1,0.7,0.7]);
            fprintf("Time Up! You got: " + goalPercentage .* 100 + "/%% of the particles in the goal outlet\r\n");
            delete(app.magLine);
            app.testNumber = app.testNumber + 1;
            NextLevel(app);
        else
            app.timeLimit = 1;
        end
    end
    app.previousMagforce = magForce;
    app.currentlyDoingWorkSemaphore = false;
end