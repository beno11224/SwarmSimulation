classdef Polygons
    %LINES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        allPolys;
        currentPolyVector;
        currentPoly;
        padding;
        allStartZones;
        currentStartZone;
        allEndZones;
        currentEndZone;
        allPolyFlows;
        currentPolyFlows;
    end
    methods ( Access = public)
        function obj = Polygons(app)
            obj.padding = 0.0002;
            len = app.UIAxes.XLim(2) - obj.padding*2;
            obj.allPolys = zeros(1,20,2);
           
            obj.allPolys(1,:,:) = [-len len; %Training
               -len*0.5 len;
               -len*0.25 len;
               len*0.5 len;
               len len;%
               len len*0.5;
               len len*0.25;
               len -len*0.5;
               len -len;%
               len*0.5 -len;
               len*0.25 -len;              
               -len*0.5 -len;
               -len*0.25 -len;
               -len -len;
               -len -len;%          
               -len -len*0.5;
               -len -len*0.25;
               -len len*0.5;
               -len len*0.25;
               -len len];%
           
           obj.allPolys(2,:,:) = [-len len*0.9; %Ex1
               -len*0.5 len*0.1;
               len*0.6 len*0.8;
               len*0.8 len*0.8
               len*0.8 -len*0.8;
               -len*0.7 -len*0.8;  
               -len*0.1 -len*0.1;
               -len*0.3 -len*0.1;
               -len -len*0.9;
               -len -len;
               -len*0.95 -len;
               len -len;
               len -len*0.25;
               len -len*0.5
               len len*0.25;                          
               len len*0.5; 
               len*0.5 len;
               -len*0.45 len*0.4;
               -len*0.9 len;
               -len len*0.9];  
           
           obj.allPolys(3,:,:) = [-len -len*0.45; %Ex2
               -len*0.5 -len*0.45;
               -len*0.15 -len;
               -len*0.05 -len*0.95
               -len*0.4 -len*0.35;
               len*0.05 len*0.25;
               len*0.5 len*0.25;
               len*0.95 -len*0.15;
               len 0;
               len*0.65 len*0.35;
               len len*0.95;
               len*0.9 len;
               len*0.5 len*0.4;
               len*0.05 len*0.4;
               0 len;
               -len*0.15 len;
               -len*0.1 len*0.4;
               -len*0.5 -len*0.2;
               -len -len*0.2;
               -len -len*0.45];
           
            obj.allPolys(4,:,:) = [-len len*0.9; % Ex3
               -len*0.55 -len*0.2;
               -len -len*0.9;
               -len*0.9 -len;
               -len*0.2 -len*0.1;
               -len*0.2 0;
               len*0.4 -len;
               len*0.45 -len;
               len*0.5 -len;
               0 0;
               len len*0.2;
               len len*0.3;               
               -len*0.2 len*0.15; 
               len*0.5 len;
               len*0.45 len;
               len*0.4 len;               
               -len*0.45 len*0.15;
               -len*0.9 len;
               -len*0.9 len;
               -len len*0.9];
           
            obj.currentPoly = squeeze(obj.allPolys(1,:,:));
            
            obj.allStartZones(1,:,:) = [len*0.25, len*0.25;
                -len*0.25, len*0.25;
                -len*0.25, -len*0.25;
                len*0.25, -len*0.25;
                len*0.25, len*0.25];
            
            obj.allStartZones(2,:,:) = [-len len*0.9;
               -len*0.7 len*0.45;
               -len*0.5 len*0.45
               -len*0.9 len;
               -len len*0.9];
           
           %obj.allStartZones(3,:,:) = [-len len*0.9;
           %    -len*0.61 len*0.7;
           %    -len*0.55 len*0.82
           %    -len*0.9 len;
           %    -len len*0.9];
           
           obj.allStartZones(3,:,:) = [-len -len*0.45;
               -len*0.75 -len*0.45;
               -len*0.75 -len*0.2;
               -len -len*0.2;
               -len -len*0.45];
           
           obj.allStartZones(4,:,:) = [-len len*0.9;
               -len*0.5 len*0.1;
               len*0.6 len*0.8
               -len*0.9 len;
               -len len*0.9];
           
           obj.currentStartZone = squeeze(obj.allStartZones(1,:,:));
           
           obj.allEndZones(1,:,:) = [len*0.75, -len;
                len, -len;
                len, -len*0.75;
                len*0.75, -len*0.75;
                len*0.75, -len];
            
           obj.allEndZones(2,:,:) = [-len*0.28 -len*0.31;  
               -len*0.1 -len*0.1;
               -len*0.3 -len*0.1;
               -len*0.47 -len*0.3;
               -len*0.28 -len*0.31];
            
           %obj.allEndZones(3,:,:) = [len*0.7 len*0.75;
           %    len len*0.9;
           %    len*0.9 len;
           %    len*0.65 len*0.85;                            
           %    len*0.7 len*0.75];
           obj.allEndZones(3,:,:) = [len 0
               len*0.9 len*0.1;
               len*0.78 0;
               len*0.95 -len*0.15;
               len 0]; 
           
           obj.allEndZones(4,:,:) = [len*0.75, -len;
                len, -len;
                len, -len*0.75;
                len*0.75, -len*0.75;
                len*0.75, -len];
            
           obj.currentEndZone = squeeze(obj.allEndZones(1,:,:));
           
           obj.allPolyFlows(1,:,:) = [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]; %Leave as no flow. %Must be the same number of flows...
           
           obj.allPolyFlows(2,:,:) = [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0];
           
           obj.allPolyFlows(3,:,:) = [-len*0.95 -len*0.3 -len*0.5 -len*0.3;%right
               -len*0.45 -len*0.42 -len*0.11 -len*0.95;%down
               -len*0.45 -len*0.25 -len*0.05 len*0.3;%up
               -len*0.02 len*0.4 -len*0.05 len*0.95 %up
               len*0.05 len*0.35 len*0.5 len*0.35 %right
               len*0.55 len*0.4 len*0.9 len*0.95%up
               len*0.55 len*0.3 len*0.9 -len*0];%down
           
           obj.allPolyFlows(4,:,:) = [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0];
           
           obj.currentPolyFlows = squeeze(obj.allPolyFlows(1,:,:));
           
            %TODO remember to change this if needed.
            for i = 1:length(obj.currentPoly)-1 
                obj.currentPolyVector(i,:) = obj.currentPoly(i,:) - obj.currentPoly(i+1,:);
            end
        end
        
        function obj = change(obj,num)
            obj.currentPoly = squeeze(obj.allPolys(num,:,:));
            for i = 1:length(obj.currentPoly)-1 
                obj.currentPolyVector(i,:) = obj.currentPoly(i,:) - obj.currentPoly(i+1,:);
            end
            obj.currentStartZone = squeeze(obj.allStartZones(num,:,:));
            obj.currentEndZone = squeeze(obj.allEndZones(num,:,:));
           obj.currentPolyFlows = squeeze(obj.allPolyFlows(num,:,:));
        end
    end
end

