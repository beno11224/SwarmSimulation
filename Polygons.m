classdef Polygons
    %LINES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        allPolys;
        currentPoly;
        padding;
    end
    methods ( Access = public)
        function obj = Polygons(app)
            obj.padding = 0.0002;
            len = app.UIAxes.XLim(2) - obj.padding*2;
            obj.allPolys = zeros(1,18,2); %This will cause issues - only 5 points across a 2d axis atm - what do i do for matricies of different sizes           
           
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
               -len -len;
               -len -len;%          
               -len -len*0.5;
               -len -len*0.25;
               -len len*0.5;
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
               len len*0.5;                          
               len len; 
               len*0.5 len;
               -len*0.45 len*0.4;
               -len*0.9 len;
               -len len*0.9];  
           
           obj.allPolys(3,:,:) = [-len len*0.9; %Ex2
               -len*0.15 0;
               -len*0.2 -len;
               -len*0.1 -len
               0 -len;
               len*0.05 -len*0.1;  
               len*0.9 -len;
               len -len*0.9;
               len*0.05 len*0.05;
               len len*0.9;
               len*0.9 len;
               -len*0.05 len*0.1;                            
               -len*0.5 len*0.52; 
               -len*0.6 len*0.63;
               -len*0.7 len*0.75;
               -len*0.8 len*0.87;
               -len*0.9 len;
               -len len*0.9];
           
            obj.allPolys(4,:,:) = [-len len*0.9; % Ex3
               -len*0.55 -len*0.2;
               -len -len*0.9;
               -len*0.9 -len;
               -len*0.2 -len*0.1;
               -len*0.2 0;
               len*0.4 -len;
               len*0.5 -len;
               0 0;
               len len*0.2;
               len len*0.3;               
               -len*0.2 len*0.15; 
               len*0.5 len;
               len*0.4 len;               
               -len*0.45 len*0.15;
               -len*0.9 len;
               -len*0.9 len;
               -len len*0.9];
           
            obj.currentPoly = squeeze(obj.allPolys(1,:,:));
        end
        
        function obj = change(obj,num)
            obj.currentPoly = squeeze(obj.allPolys(num,:,:));
        end
    end
end

