classdef Polygons
    
    properties (Access = public)
        allPolys;
        outOfBoundsPolys;
        hardCodedWallContacts;
        hardCodedOrthogonalWallContacts;
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
            obj.outOfBoundsPolys = zeros(1,4,2);
           
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
           
           obj.allEndZones(1,1,:,:) = [0.00941 -0.00269 %Test?(same as 3 bifurcations)
               0.00870 -0.0034;
               0.00799 -0.00269;
               0.00870 -0.00198;
               0.00941 -0.00269];
           obj.allEndZones(1,2,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0007 -0.0063;
               -0.0015 -0.0071;
               -0.00096 -0.00754];
           obj.allEndZones(1,3,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0005 -0.006;%Values don't line up perfectly, but oh well - they are only used to stop particles
               -0.0018 -0.0068;
               -0.00096 -0.00754];
           obj.allEndZones(1,4,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0005 -0.006;%Values don't line up perfectly, but oh well - they are only used to stop particles
               -0.0018 -0.0068;
               -0.00096 -0.00754];

           obj.allEndZones(2,1,:,:) = [0.00941 -0.00269 %3 bifurcations
               0.00870 -0.0034;
               0.00799 -0.00269;
               0.00870 -0.00198;
               0.00941 -0.00269];          
           obj.allEndZones(2,2,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0007 -0.0063;
               -0.0015 -0.0071;
               -0.00096 -0.00754];
           obj.allEndZones(2,3,:,:) = [0.00941 0.00438;%upper3rd
               0.00870 0.00509;
               0.0083 0.0047;%TODO check...
               0.00905 0.004;%TODO
               0.00941 0.00438];
           obj.allEndZones(2,4,:,:) = [0.00006 0.00632;%upper2nd
               -0.00096 0.00632;
               -0.00099 0.006;%TODO check...
               0.00009 0.006;%TODO
               0.00006 0.00632];
          
        %   obj.allEndZones(3,:,:) = [0.00941 -0.00269
        %       0.00870 -0.0034;
        %       0.00799 -0.00269;
        %       0.00870 -0.00198;
        %       0.00941 -0.00269];
           obj.allEndZones(3,1,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0007 -0.0063;
               -0.0015 -0.0071;
               -0.00096 -0.00754];
           obj.allEndZones(3,2,:,:) = [-0.00025 0.00036;%1st upper
               -0.00096 0.00107;
               -0.00165 0.00027;
               -0.0009 -0.00043;
               -0.00025 0.00036];

           obj.allEndZones(4,1,:,:) = [0.00006 0.00632;%upper2nd
               -0.00096 0.00632;
               -0.00099 0.006;
               0.00009 0.006;
               0.00006 0.00632];
           obj.allEndZones(4,2,:,:) = [0.00501 0.00036;%centre
               0.00501 0.00132;
               0.0045 0.00132;
               0.0045 0.00036;
               0.00501 0.00036];
           obj.allEndZones(4,3,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0007 -0.0063;
               -0.0015 -0.0071;
               -0.00096 -0.00754];

        %   obj.allEndZones(3,1,:,:) = [-0.0044 -0.004; %drag force test
        %       -0.0035 -0.004;
        %       -0.0035 -0.003;
        %       -0.0044 -0.003;
        %       -0.0044 -0.004;];
           
           %obj.allEndZones(4,:,:) = [0.00941 -0.00269
           %    0.00870 -0.0034;
           %    0.00799 -0.00269;
           %    0.00870 -0.00198;
           %    0.00941 -0.00269];
           
          % obj.allEndZones(4,1,:,:) = [-0.0084 -0.004; %magnetic force test
          %     -0.0065 -0.004;
          %     -0.0065 -0.003;
          %     -0.0084 -0.003;
          %     -0.0084 -0.004;];
           
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
            
           obj.currentEndZone = squeeze(obj.allEndZones(1,:,:,:));
           %{
           [-0.0095 -0.004; %Ex1
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
            %}
           obj.outOfBoundsPolys(1,:,:) = [-0.0095 -0.00395;
               -0.0045 -0.00395;
               -0.0045 -0.005;
               -0.0095 -0.0045];
           obj.outOfBoundsPolys(2,:,:) = [-0.00455 -0.00395;
               -0.000955 -0.00754;
               -0.000955 -0.009;
               -0.00455 -0.009];         
           obj.outOfBoundsPolys(3,:,:) = [-0.000965 -0.00754;%1st lower
               -0.00025 -0.00677;
               0.001 -0.008;
               -0.000965 -0.009];
             obj.outOfBoundsPolys(4,:,:) = [-0.00025 -0.0069;%1st lower
               -0.00368 -0.0035;
               -0.00030 -0.0035;
               -0.00025 -0.0069];             
              obj.outOfBoundsPolys(5,:,:) = [-0.00368 -0.0035;%centre 1st
               -0.00025 0.00039;
               -0.00025 -0.0035;
               -0.00368 -0.0035];
              obj.outOfBoundsPolys(6,:,:) = [-0.00025 0.000365;%upper 1st
               0.00501 0.000365;
               0.00501 -0.0035;
               -0.00025 -0.0035];
              obj.outOfBoundsPolys(7,:,:) = [0.005 0.00039;%right2nd
               0.00875 -0.0034;
               0.005 -0.0035;
               0.005 0.00039];
              obj.outOfBoundsPolys(8,:,:) = [0.00865 -0.0034;%lower3rd
               0.00941 -0.00265;
               0.01 -0.0035;
               0.00950 -0.0044];
              obj.outOfBoundsPolys(9,:,:) = [0.00941 -0.00269;%lower3rdg
               0.00587 0.00085;
               0.00941 0.00085;
               0.00941 -0.00269];
              obj.outOfBoundsPolys(10,:,:) = [0.00587 0.00085;%centre3rd
               0.00941 0.00438;
               0.00941 0.00085;
               0.00587 0.00085];
              obj.outOfBoundsPolys(11,:,:) = [0.00941 0.00438;%upper3rd
               0.00870 0.00509;
               0.009 0.00609;
               0.01 0.005];
              obj.outOfBoundsPolys(12,:,:) = [0.00870 0.00509;%upper3rd
               0.00501 0.00132;
               0.00501 0.00509;
               0.00870 0.00509];              
              obj.outOfBoundsPolys(13,:,:) = [0.00505 0.0013;%right2nd
               0.00006 0.0013;
               0.002 0.0035;
               0.00505  0.003];
              obj.outOfBoundsPolys(14,:,:) = [0.00006 0.00132;%centre2nd
               0.00006 0.00632;
               0.002 0.00632;
               0.002 0.0035];
              obj.outOfBoundsPolys(15,:,:) = [0.00006 0.00632;%upper2nd
               -0.00096 0.00632;
               -0.00096 0.00732;
                0.00006 0.00732];              
              obj.outOfBoundsPolys(16,:,:) = [-0.00096 0.00632;%upper2nd
               -0.00096 0.00107;
               -0.0026 0.00107;
               -0.0026 0.00632];
              obj.outOfBoundsPolys(17,:,:) = [-0.00096 0.00107;%upper1st
               -0.0045 -0.003;
               -0.0045 0.00107;
               -0.00096 0.00107];
              obj.outOfBoundsPolys(18,:,:) = [-0.0045 -0.003;
               -0.0095 -0.003;
               -0.0095 -0.001;
               -0.0045 -0.001];
              obj.outOfBoundsPolys(19,:,:) = [-0.0095 -0.003;
               -0.0095 -0.004;
               -0.01 -0.004;
               -0.01 -0.003];             

        obj.hardCodedOrthogonalWallContacts = [0 1; 
            0.7071 0.7071;
            -0.7071 0.7071;
            -0.7018 -0.7124;
            -0.7523 0.6588;
            0 1;
            0.7137 0.7004;
            -0.7071 0.7071;
            -0.7071 -0.7071;
            -0.7061 0.7081;
            -0.7071 -0.7071;
            0.7146 -0.6995;
            0 -1;
            -1 0;
            0 -1;
            1 0;
            0.7545 -0.6563;
            0 -1;
            1 0];
       % obj.hardCodedOrthogonalWallContacts = [0 1; 0.5 0.5; 0 1];

            for i = 1:length(obj.currentPoly)-1 
                obj.currentPolyVector(i,:) = obj.currentPoly(i,:) - obj.currentPoly(i+1,:);
            end
        end
        
        function obj = change(obj,num, rotDeg) %TODO does rotDeg need to be supplied?
            if(~exist('rotDeg','var'))
                rotDeg = 0;
            end
            rotMatrix = [cosd(rotDeg), sind(rotDeg); -sind(rotDeg), cos(rotDeg)];
            obj.currentPoly = (rotMatrix * (squeeze(obj.allPolys(num,:,:))'))';
            for i = 1:length(obj.currentPoly)-1 
                obj.currentPolyVector(i,:) = obj.currentPoly(i,:) - obj.currentPoly(i+1,:);
            end
            obj.currentStartZone = (rotMatrix * (squeeze(obj.allStartZones(num,:,:))'))';
            for j = 1:size(squeeze(obj.allEndZones(num,:,:,:)),1)
                obj.currentEndZone(j,:,:) = (rotMatrix * (squeeze(obj.allEndZones(num,j,:,:))'))';
            end
            for k = 1:size(obj.outOfBoundsPolys,1)
                obj.outOfBoundsPolys(k,:,:) = (rotMatrix * (squeeze(obj.outOfBoundsPolys(k,:,:))'))';
            end
            obj.hardCodedOrthogonalWallContacts = (rotMatrix * obj.hardCodedOrthogonalWallContacts')';
        end

    end
end

