classdef Polygons
    
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
    end
    methods ( Access = public)
        function obj = Polygons(width)
            obj.padding = 0.0002;
            len = width - obj.padding*2;
            obj.allPolys = zeros(1,20,2);
           
            obj.allPolys(1,:,:) = [-len len; %Training
               -len*0.5 len;
               -len*0.25 len;
               len*0.5 len;
               len len;
               len len*0.5;
               len len*0.25;
               len -len*0.5;
               len -len;
               len*0.5 -len;
               len*0.25 -len;              
               -len*0.5 -len;
               -len*0.25 -len;
               -len -len;
               -len -len;       
               -len -len*0.5;
               -len -len*0.25;
               -len len*0.5;
               -len len*0.25;
               -len len];
           
           %obj.allPolys(2,:,:) = [-len -len*0.45; %Original version.
           %    -len*0.5 -len*0.45;
           %    -len*0.15 -len;
           %    -len*0.05 -len*0.95
           %    -len*0.4 -len*0.35;
           %    len*0.05 len*0.25;
           %    len*0.5 len*0.25;
           %    len*0.95 -len*0.15;
           %    len 0;
           %    len*0.65 len*0.35;
           %    len len*0.95;
           %    len*0.9 len;
           %    len*0.5 len*0.4;
           %    len*0.05 len*0.4;
           %    0 len;
           %    -len*0.15 len;
           %    -len*0.1 len*0.4;
           %    -len*0.5 -len*0.2;
           %    -len -len*0.2;
           %    -len -len*0.45]; 
           
           obj.allPolys(2,:,:) = [-0.0095 -0.004; %Ex1
               -0.0045 -0.004;
               -0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;%1st lower
               -0.00363 -0.0035;%centre 1st
               -0.00025 0.00036;%upper 1st
               0.00501 0.00036;%right2nd
               0.00870 -0.0034;%lower3rd
               0.00941 -0.00269;%lower3rdg
               0.00587 0.00085;%centre3rd
               0.00941 0.00438;%upper3rd
               0.00870 0.00509;%upper3rd
               0.00501 0.00132;%right2nd
               0.00006 0.00132;%centre2nd %done
               0.00006 0.00632;%upper2nd
               -0.00096 0.00632;%upper2nd
               -0.00096 0.00107;%upper1st
               -0.0045 -0.003;
               -0.0095 -0.003;
               -0.0095 -0.004]; 
           
           obj.allPolys(3,:,:) = [-0.0095 -0.004; %Ex2
               -0.0045 -0.004;
               -0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;%1st lower
               -0.00363 -0.0035;%centre 1st
               -0.00025 0.00036;%upper 1st
               0.00501 0.00036;%right2nd
               0.00870 -0.0034;%lower3rd
               0.00941 -0.00269;%lower3rdg
               0.00587 0.00085;%centre3rd
               0.00941 0.00438;%upper3rd
               0.00870 0.00509;%upper3rd
               0.00501 0.00132;%right2nd
               0.00006 0.00132;%centre2nd %done
               0.00006 0.00632;%upper2nd
               -0.00096 0.00632;%upper2nd
               -0.00096 0.00107;%upper1st
               -0.0045 -0.003;
               -0.0095 -0.003;
               -0.0095 -0.004];
           
            obj.allPolys(4,:,:) = [-0.0095 -0.004; %Ex3
               -0.0045 -0.004;
               -0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;%1st lower
               -0.00363 -0.0035;%centre 1st
               -0.00025 0.00036;%upper 1st
               0.00501 0.00036;%right2nd
               0.00870 -0.0034;%lower3rd
               0.00941 -0.00269;%lower3rdg
               0.00587 0.00085;%centre3rd
               0.00941 0.00438;%upper3rd
               0.00870 0.00509;%upper3rd
               0.00501 0.00132;%right2nd
               0.00006 0.00132;%centre2nd %done
               0.00006 0.00632;%upper2nd
               -0.00096 0.00632;%upper2nd
               -0.00096 0.00107;%upper1st
               -0.0045 -0.003;
               -0.0095 -0.003;
               -0.0095 -0.004];
           
            obj.currentPoly = squeeze(obj.allPolys(1,:,:));
            
            obj.allStartZones(1,:,:) = [len*0.25, len*0.25;
                -len*0.25, len*0.25;
                -len*0.25, -len*0.25;
                len*0.25, -len*0.25;
                len*0.25, len*0.25];
            
            obj.allStartZones(2,:,:) = [-0.0095 -0.004;
               -0.0085 -0.004;
               -0.0085 -0.003;
               -0.0095 -0.003;
               -0.0095 -0.004];
               
           obj.allStartZones(3,:,:) = [-0.0095 -0.004;
               -0.0094 -0.004;
               -0.0094 -0.003;
               -0.0095 -0.003;
               -0.0095 -0.004];  
           
           obj.allStartZones(4,:,:) = [-0.0095 -0.004;
               -0.0094 -0.004;
               -0.0094 -0.003;
               -0.0095 -0.003;
               -0.0095 -0.004];
           
           %Comment out these tests and replace with new start/goals - Use with the original scenario, they
           %might not fit on new ones.
           %obj.allStartZones(3,:,:) = [-len -len*0.25; %Flow Test
           %    -len*0.9 -len*0.25;
           %    -len*0.9 -len*0.35;
           %    -len -len*0.35;
           %    -len -len*0.25];   
           
           %obj.allStartZones(4,:,:) = [-len -len*0.45; %Magnetic Force Test
           %    -len*0.6 -len*0.45;
           %    -len*0.6 -len*0.43;
           %    -len -len*0.43;
           %    -len -len*0.45];  
           
           obj.currentStartZone = squeeze(obj.allStartZones(1,:,:));
           
           obj.allEndZones(1,:,:) = [len*0.75, -len;
                len, -len;
                len, -len*0.75;
                len*0.75, -len*0.75;
                len*0.75, -len];
            
           obj.allEndZones(2,:,:) = [0.00941 -0.00269
               0.00870 -0.0034;
               0.00799 -0.00269;
               0.00870 -0.00198;
               0.00941 -0.00269];
           
           obj.allEndZones(3,:,:) = [0.00941 -0.00269
               0.00870 -0.0034;
               0.00799 -0.00269;
               0.00870 -0.00198;
               0.00941 -0.00269];
           
           obj.allEndZones(3,:,:) = [-0.0044 -0.004; %drag force test
               -0.0035 -0.004;
               -0.0035 -0.003;
               -0.0044 -0.003;
               -0.0044 -0.004;];
           
           %obj.allEndZones(4,:,:) = [0.00941 -0.00269
           %    0.00870 -0.0034;
           %    0.00799 -0.00269;
           %    0.00870 -0.00198;
           %    0.00941 -0.00269];
           
           obj.allEndZones(4,:,:) = [-0.0084 -0.004; %magnetic force test
               -0.0065 -0.004;
               -0.0065 -0.003;
               -0.0084 -0.003;
               -0.0084 -0.004;];
           
           %obj.allEndZones(3,:,:) = [-len*0.5 -len*0.25; %Flow Test
           %    -len*0.4 -len*0.25;
           %    -len*0.4 -len*0.35;
           %    -len*0.5 -len*0.35;
           %    -len*0.5 -len*0.25];
           
           %obj.allEndZones(4,:,:) = [-len -len*0.38; %Magnetic Force Test
           %    -len*0.6 -len*0.38;
           %    -len*0.6 -len*0.35;
           %    -len -len*0.35;
           %    -len -len*0.38]; 
            
           obj.currentEndZone = squeeze(obj.allEndZones(1,:,:));
           
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
        end
    end
end

