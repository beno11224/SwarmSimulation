classdef LineSegments
    %Everything to do with the scenarios
    
    properties (Access = public)
        padding;
        allScenarios;
        allScenarioRadius;
        currentScenario;
        currentScenarioRadius;
        currentScenarioVector;
        currentScenarioPoly;
        allStartZones; %TODO maybe do this alorithmically? not squares of a certain size?
        currentStartZone;
        allEndZones;
        currentEndZone;
    end
    
    methods
        function obj = LineSegments(app)
            obj.padding = 0.0002;
            len = app.UIAxes.XLim(2) - obj.padding*2;
            obj.allPolys = zeros(1,20,2);
            
            allScenarios(1,:,:) = [-len*0.95 -len*0.3 -len*0.5 -len*0.3;%right
               -len*0.45 -len*0.42 -len*0.11 -len*0.95;%down
               -len*0.45 -len*0.25 -len*0.05 len*0.3;%up
               -len*0.02 len*0.4 -len*0.05 len*0.95 %up
               len*0.05 len*0.35 len*0.5 len*0.35 %right
               len*0.55 len*0.4 len*0.9 len*0.95%up
               len*0.55 len*0.3 len*0.9 -len*0];
            
            allScenarios(2,:,:) = [-len*0.95 -len*0.3 -len*0.5 -len*0.3;%right
               -len*0.45 -len*0.42 -len*0.11 -len*0.95;%down
               -len*0.45 -len*0.25 -len*0.05 len*0.3;%up
               -len*0.02 len*0.4 -len*0.05 len*0.95 %up
               len*0.05 len*0.35 len*0.5 len*0.35 %right
               len*0.55 len*0.4 len*0.9 len*0.95%up
               len*0.55 len*0.3 len*0.9 -len*0];
           
           allScenarios(3,:,:) = [-len*0.95 -len*0.3 -len*0.5 -len*0.3;%right
               -len*0.45 -len*0.42 -len*0.11 -len*0.95;%down
               -len*0.45 -len*0.25 -len*0.05 len*0.3;%up
               -len*0.02 len*0.4 -len*0.05 len*0.95 %up
               len*0.05 len*0.35 len*0.5 len*0.35 %right
               len*0.55 len*0.4 len*0.9 len*0.95%up
               len*0.55 len*0.3 len*0.9 -len*0];
           
           allScenarios(4,:,:) = [-len*0.95 -len*0.3 -len*0.5 -len*0.3;%right
               -len*0.45 -len*0.42 -len*0.11 -len*0.95;%down
               -len*0.45 -len*0.25 -len*0.05 len*0.3;%up
               -len*0.02 len*0.4 -len*0.05 len*0.95 %up
               len*0.05 len*0.35 len*0.5 len*0.35 %right
               len*0.55 len*0.4 len*0.9 len*0.95%up
               len*0.55 len*0.3 len*0.9 -len*0];
                      
            allScenarioRadius(1,:) = [len*0.3 len*0.3 len*0.3 len*0.3 len*0.3 len*0.3 len*0.3];
            allScenarioRadius(2,:) = [len*0.3 len*0.3 len*0.3 len*0.3 len*0.3 len*0.3 len*0.3];
            allScenarioRadius(3,:) = [len*0.2 len*0.2 len*0.2 len*0.2 len*0.2 len*0.2 len*0.2];
            allScenarioRadius(4,:) = [len*0.2 len*0.2 len*0.2 len*0.2 len*0.2 len*0.2 len*0.2];
            
        end
        
        function obj = change(obj,num)
            obj.currentScenario = squeeze(obj.allScenarios(num,:,:));
            obj.currentScenario = squeeze(obj.allScenariosRadius(num,:));            
            for i = 1:length(obj.currentScenario)-1 
                obj.currentScenarioVector(i) = obj.currentScenario(i,1:2) - obj.currentScenario(i,3:4);
                obj.currentScenarioPoly = 1%TODO;
            end
            obj.currentStartZone = squeeze(obj.allStartZones(num,:,:));
            obj.currentEndZone = squeeze(obj.allEndZones(num,:,:));
        end
    end
end

