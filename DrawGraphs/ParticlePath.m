classdef ParticlePath
    %PARTICLEPATH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ValidRun
        CorrectOutlet
        GoalTime
        InputForces
        Locations
        Velocities
        TimeSteps
        overallPercentage
    end
    
    methods
        function obj = ParticlePath(validRun, correctOutlet, goalTime, inputForces, locations, velocities, timeSteps, recPercentage) %String? File?
            %PARTICLEPATH Construct an instance of this class
            %   Detailed explanation goes here
            obj.ValidRun = validRun;
            obj.CorrectOutlet = correctOutlet;
            obj.GoalTime = goalTime;
            obj.InputForces = inputForces;
            obj.Locations = locations;
            obj.Velocities = velocities;
            obj.TimeSteps = timeSteps;
            obj.overallPercentage = recPercentage;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

