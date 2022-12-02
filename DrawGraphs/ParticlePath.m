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
        function obj = ParticlePath(validRun, correctOutlet, goalTime, inputForces, locations, velocities, timeSteps, recPercentage)

            %Boolean
            obj.ValidRun = validRun;
            obj.CorrectOutlet = correctOutlet;

            %Double
            if(iscell(goalTime))
                goalTime = str2double(cell2mat(goalTime));
            end
            if(iscell(recPercentage))
                recPercentage = str2double(cell2mat(recPercentage));
            end
            obj.GoalTime = goalTime;
            obj.overallPercentage = recPercentage;

            %Double Array
            obj.InputForces = inputForces;
            obj.Locations = locations;
            obj.Velocities = velocities;
            obj.TimeSteps = timeSteps;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

