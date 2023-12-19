function timerCallback(app)
    %start by getting the magnetic force - this is the user input
    currentMagforce = app.particleFunctions.calculateMagneticForce([app.X1TmGauge.Value app.Y1TmGauge.Value],app.joyStick, 1, 3, app.controlMethod, app.mousePosition, app.MagForceRestrictTmEditField.Value, app.rotation, app.maxForce);
    currentDial = currentMagforce ./10^6 ./ app.particleFunctions.magneticForceConstant;
    if(app.controlMethod == "Controller")
        %For shared control/Neural Network control
        if(app.UseNetworkForHaptic)
            currentDial = -1 .* double(pyrun("pred = NNet.predict(np.array([state]),verbose=0, batch_size=1)","pred", state = app.particleFunctions.getState(app.particleArrayLocation, app.FluidFlowmsEditField.Value./6)));%,t,goalLocation)));
        end
        hapticSpring = app.HapticForceSlider.Value;
        hapticViscocity = 0.3;
        hapticVelocity = [1,currentDial(1),currentDial(2)] - app.hapticFeedback;
        app.hapticFeedback = [1,currentDial(1),currentDial(2)];
        hapticForce = app.hapticFeedback .* hapticSpring + hapticVelocity .* hapticViscocity;
        %To make the (haptic) mex files use this format:
        %mex "drdms64.lib" "dhdms64.lib" WriteHaptic.cpp
        WriteHaptic(-hapticForce(1), -hapticForce(2), -hapticForce(3));

        app.X1TmGauge.Value = currentDial(1);
        app.Y1TmGauge.Value = currentDial(2);
    end 

    vFlow = app.particleFunctions.calculateFlow(real(app.particleArrayLocation), app.polygon.currentFlowValues, app.mesh);
    vFlow = vFlow .* app.FluidFlowmsEditField.Value;
 
    magForceAlpha = 0.05;
    magForce = app.previousMagforce;
 
    % Each time timerCallback is called, this loop runs
    % 'smallerTMaxTotalSteps' number of times.
   % smallerTMaxTotalSteps = 25; %Any more speed comes from making the sim more efficient or slowing it down (not real time)
    smallerTMaxTotalSteps = 25;
    smallerTMaxStep = app.simTimerPeriod / smallerTMaxTotalSteps;
    smallerTMaxStepReduced = smallerTMaxStep / app.slowDown;
    for smallerTMaxIndex = 1:smallerTMaxTotalSteps        
        %Check if particle is on wall. Store if it bounced last loop as
        %this is used to determine wether to draw the particle or not.
        app.bouncedVisualLastLoop = app.bouncedLastLoop;
        [wallContact, orthogonalWallContact, app.particleArrayLocation, app.particleArrayVelocity, app.bouncedLastLoop] = app.particleFunctions.isParticleOnWallPIP(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayForce, app.polygon, smallerTMaxStepReduced,app,app.bouncedLastLoop);

       % magForce = magForce .* (1-magForceAlpha) + currentMagforce.* magForceAlpha;
        magForce = repmat(currentMagforce,app.NumberofParticlesEditField.Value,1);
        %friction
        ffric = app.particleFunctions.calculateFrictionForce(app.particleArrayVelocity, app.particleArrayForce, orthogonalWallContact);
        app.particleArrayForce = magForce - ffric;

        velocityFromMagForce = app.particleFunctions.calculateDragForceFromMagForce(app.particleArrayForce, vFlow); %Assuming instant acceleration up to the point where drag = mag
        app.particleArrayVelocity = velocityFromMagForce;

        %app.particleArrayForce = magForce;
        %drag (using last iterations velocity)
        %dragForce = app.particleFunctions.calculateDragForce(app.particleArrayVelocity, vFlow);
        %app.particleArrayForce = app.particleArrayForce - dragForce;

        %Prevent movement of particles that have reached the end of any of
        %the bifurcations
        %app.particleArrayForce = app.particleArrayForce .* ~app.haltParticlesInEndZone;
        app.particleArrayVelocity = app.particleArrayVelocity .* ~app.haltParticlesInEndZone;
        %temporaryVelocity = app.particleArrayVelocity;        
           
        %calculate the new locations 
      %  app.particleArrayLocation = app.particleFunctions.calculateCurrentLocationCD(app.particleArrayLocation, app.particleArrayVelocity, app.particleArrayPreviousAcceleration, smallerTMaxStepReduced);
        app.particleArrayLocation = app.particleArrayLocation + app.particleArrayVelocity .* smallerTMaxStepReduced;
        %Make sure that we have the correct data stored for the next loop.        
        %calculate the new velocity
     %   [app.particleArrayVelocity,app.particleArrayPreviousAcceleration, app.previousDelta] = app.particleFunctions.calculateCurrentVelocityCD(orthogonalWallContact, wallContact, temporaryVelocity, app.particleArrayPreviousAcceleration, app.particleArrayForce, app.particleFunctions.particleMass, smallerTMaxStepReduced, magForce);

        %Determine the end zone the particles are in
        particlesInEndZone = app.particleFunctions.isParticleInEndZone(app.polygon.currentEndZone,app.particleArrayLocation);
        app.haltParticlesInEndZone = any(particlesInEndZone,2);
        %Tell the user how well they're doing
        goalPercentage = sum(particlesInEndZone,1) ./ app.numParticles;
        goalPercentage = goalPercentage(app.goalIndex);        
        app.previousMagforce = magForce;
        
        %increment time - if no lag occurs this should be a good indicator
        %for how much time has passed. If lag occurs, this means that the
        %particles don't move for extra time, and we just let the lag pass.
        if(app.timestep == 0)
            app.timePassed = app.timePassed + smallerTMaxStepReduced;
        else                
            app.timePassed = app.timePassed + app.timestep / smallerTMaxTotalSteps;        
        end
        if(goalPercentage == 1)
            break;
        end
    end
    %Perform any rotation maths needed.
    rotMat = [cosd(app.rotation), sind(app.rotation); -sind(app.rotation), cos(app.rotation)];
    rotForce = (rotMat * [app.X1TmGauge.Value ; app.Y1TmGauge.Value])';
    rotVel = (rotMat * app.particleArrayVelocity')';
    rotLoc = (rotMat * app.particleArrayLocation')';
 
    %print the data in a readable format - this is critical for retrieving
    %data!
    if(app.writeToFile)
        fprintf(app.fileID, app.timePassed + "," + mat2str(rotForce) + "," + goalPercentage + "," + mat2str(rotVel)+ "," + mat2str(rotLoc) + "," + mat2str(particlesInEndZone) + "\r\n");
          app.printCounter = app.printCounter + 1;
    end

    %Update fields for user
    if(app.timeLimit > 0 && app.timePassed <= app.timeLimit && (goalPercentage ~= 1))
        app.TimeRemainingsEditField.Value = round(app.timeLimit - app.timePassed);
        app.PercentageinGoalEditField.Value = round(goalPercentage .* 100);
    else
        %Out of time, so perform a reset
        if(app.timeLimit > 0)
            if(app.controlMethod ~= "TrainingModel")
                stop(app.simulationTimerProperty);
                stop(app.drawTimerProperty);
                app.StartTrainingButton.Enable = true;
                set(app.StartTrainingButton,'Text',"Start Next Level");
                set(app.StartTrainingButton,'BackgroundColor',[1,0.7,0.7]);
                fprintf("Time Up! You got: " + goalPercentage .* 100 + "/%% of the particles in the goal outlet\r\n");
                delete(app.magLine);
                app.testNumber = app.testNumber + 1;
                NextLevel(app);
             %   start(app.hapticFeedbackIdleProperty);
            end
        else
            app.timeLimit = 1;
        end
    end

    app.previousMagforce = magForce;
    app.currentlyDoingWorkSemaphore = false;
end