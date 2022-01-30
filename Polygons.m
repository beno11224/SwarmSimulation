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
           
           obj.allPolys(2,:,:) = [-0.00095 -0.0004; %Ex1
               -0.00045 -0.0004;
               -0.000096 -0.000754;%1st lower
               -0.000025 -0.000683;%1st lower
               -0.000363 -0.00035;%centre 1st
               -0.000025 0.000036;%upper 1st
               0.000501 0.000036;%right2nd
               0.000870 -0.00034;%lower3rd
               0.000941 -0.000269;%lower3rdg
               0.000587 0.000085;%centre3rd
               0.000941 0.000438;%upper3rd
               0.000870 0.000509;%upper3rd
               0.000501 0.000132;%right2nd
               0.000006 0.000132;%centre2nd %done
               0.000006 0.000632;%upper2nd
               -0.000096 0.000632;%upper2nd
               -0.000096 0.000107;%upper1st
               -0.00045 -0.0003;
               -0.00095 -0.0003;
               -0.00095 -0.0004]; 
           
           obj.allPolys(3,:,:) = [-0.00095 -0.0004; %Ex2
               -0.00045 -0.0004;
               -0.000096 -0.000754;%1st lower
               -0.000025 -0.000683;%1st lower
               -0.000363 -0.00035;%centre 1st
               -0.000025 0.000036;%upper 1st
               0.000501 0.000036;%right2nd
               0.000870 -0.00034;%lower3rd
               0.000941 -0.000269;%lower3rdg
               0.000587 0.000085;%centre3rd
               0.000941 0.000438;%upper3rd
               0.000870 0.000509;%upper3rd
               0.000501 0.000132;%right2nd
               0.000006 0.000132;%centre2nd %done
               0.000006 0.000632;%upper2nd
               -0.000096 0.000632;%upper2nd
               -0.000096 0.000107;%upper1st
               -0.00045 -0.0003;
               -0.00095 -0.0003;
               -0.00095 -0.0004];
           
            obj.allPolys(4,:,:) = [-0.00095 -0.0004; %Ex3
               -0.00045 -0.0004;
               -0.000096 -0.000754;%1st lower
               -0.000025 -0.000683;%1st lower
               -0.000363 -0.00035;%centre 1st
               -0.000025 0.000036;%upper 1st
               0.000501 0.000036;%right2nd
               0.000870 -0.00034;%lower3rd
               0.000941 -0.000269;%lower3rdg
               0.000587 0.000085;%centre3rd
               0.000941 0.000438;%upper3rd
               0.000870 0.000509;%upper3rd
               0.000501 0.000132;%right2nd
               0.000006 0.000132;%centre2nd %done
               0.000006 0.000632;%upper2nd
               -0.000096 0.000632;%upper2nd
               -0.000096 0.000107;%upper1st
               -0.00045 -0.0003;
               -0.00095 -0.0003;
               -0.00095 -0.0004];
           
            obj.currentPoly = squeeze(obj.allPolys(1,:,:));
            
            obj.allStartZones(1,:,:) = [len*0.25, len*0.25;
                -len*0.25, len*0.25;
                -len*0.25, -len*0.25;
                len*0.25, -len*0.25;
                len*0.25, len*0.25];
            
            obj.allStartZones(2,:,:) = [-0.00095 -0.0004;
               -0.00085 -0.0004;
               -0.00085 -0.0003;
               -0.00095 -0.0003;
               -0.00095 -0.0004];
               
           obj.allStartZones(3,:,:) = [-0.00095 -0.0004;
               -0.00085 -0.0004;
               -0.00085 -0.0003;
               -0.00095 -0.0003;
               -0.00095 -0.0004];  
           
           obj.allStartZones(4,:,:) = [-0.00095 -0.0004;
               -0.00094 -0.0004;
               -0.00094 -0.0003;
               -0.00095 -0.0003;
               -0.00095 -0.0004];
           
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
            
           obj.allEndZones(2,:,:) = [0.000941 -0.000269
               0.000870 -0.00034;
               0.000799 -0.000269;
               0.000870 -0.000198;
               0.000941 -0.000269];
           
           obj.allEndZones(3,:,:) = [0.000941 -0.000269
               0.000870 -0.00034;
               0.000799 -0.000269;
               0.000870 -0.000198;
               0.000941 -0.000269];
           
           %obj.allEndZones(4,:,:) = [0.000941 -0.000269
           %    0.000870 -0.00034;
           %    0.000799 -0.000269;
           %    0.000870 -0.000198;
           %    0.000941 -0.000269];
           
           obj.allEndZones(4,:,:) = [-0.00084 -0.0004; %magnetic force test
               -0.00075 -0.0004;
               -0.00075 -0.0003;
               -0.00084 -0.0003;
               -0.00084 -0.0004;];
           
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

