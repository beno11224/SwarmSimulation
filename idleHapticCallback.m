function idleHapticCallback(app)
    %This keeps the haptic device awake and applying force when the
    %simulator isn't actually running, for example during loading of each
    %level.
    if(app.controlMethod == "Controller")
        newHapticValues = ReadHaptic() .* 30;
        if app.MagForceRestrictTmEditField.Value ~= 0
            newHapticValues = newHapticValues .* (app.MagForceRestrictTmEditField.Value/2.25);
        end
        totalForce = [newHapticValues(1)*10^6, newHapticValues(2)*10^6];
        if(norm(totalForce) > 2.25*10^6)
            totalForce = totalForce ./ norm(totalForce) .* 2.25*10^6;
        end
        currentMagForce = ([cosd(-app.rotation), sind(-app.rotation); -sind(-app.rotation), cos(-app.rotation)] * (app.particleFunctions.magneticForceConstant .* totalForce)')' ;
        
        currentDial = currentMagForce ./10^6 ./ app.particleFunctions.magneticForceConstant;
        hapticSpring = app.HapticForceSlider.Value;
        hapticViscocity = 0.3;
        hapticVelocity = [1,currentDial(1),currentDial(2)] - app.hapticFeedback;
        app.hapticFeedback = [1,currentDial(1),currentDial(2)];
        hapticForce = app.hapticFeedback .* hapticSpring + hapticVelocity .* hapticViscocity;
        %mex "drdms64.lib" "dhdms64.lib" WriteHaptic.cpp
        WriteHaptic(-hapticForce(1), -hapticForce(2), -hapticForce(3));   

        app.X1TmGauge.Value = currentDial(1);
        app.Y1TmGauge.Value = currentDial(2); 
    end
 end