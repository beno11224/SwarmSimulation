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
        currentFlowValues;
        currentFlowLocations;
        currentOutOfBoundsPolys;
        currentHardCodedOrthogonalWallContacts;
    end
    methods ( Access = public)
        function obj = Polygons(width,fd)
            obj.padding = 0.0002;
            len = width - obj.padding*2;
           
            obj.allPolys{1} = [-len len; %Training
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
           
           obj.allPolys{2} = [-0.0095 -0.004; %Ex1
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
           
           obj.allPolys{3} = [-0.0095 -0.004; %Ex2
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
           
%            obj.allPolys{4} = [-0.0095 -0.004; %Ex3
%               -0.0045 -0.004;
%               -0.00096 -0.00754;%1st lower
%               -0.00025 -0.00683;%1st lower
%               -0.00363 -0.0035;%centre 1st
%               -0.00025 0.00036;%upper 1st
%               0.00501 0.00036;%right2nd
%               0.00870 -0.0034;%lower3rd
%               0.00941 -0.00269;%lower3rdg
%               0.00587 0.00085;%centre3rd
%               0.00941 0.00438;%upper3rd
%               0.00870 0.00509;%upper3rd
%               0.00501 0.00132;%right2nd
%               0.00006 0.00132;%centre2nd %done
%               0.00006 0.00632;%upper2nd
%               -0.00096 0.00632;%upper2nd
%               -0.00096 0.00107;%upper1st
%               -0.0045 -0.003;
%               -0.0095 -0.003;
%               -0.0095 -0.004];
            obj.allPolys{4} = [0.010644161 -0.002909076;
                0.008509683 0.001249924;
                0.012959844 0.002681477;
                0.01264254 0.0036298;
                0.007900921 0.002043277;
                0.003507602 0.003826168;
                0.005353453 0.008193409;
                0.004429574 0.008576092;
                0.002516157 0.003956694;
                -0.001851084 0.002110843;
                -0.003633975 0.006504162;
                -0.004557854 0.006121479;
                -0.002644437 0.001502081;
                -0.0045 -0.003;
                -0.0095 -0.003;
                -0.0095 -0.004;
                -0.0045 -0.004;
                -0.0045 -0.004;
                -0.002644437 -0.008502081;
                -0.001720557 -0.008119398;
                -0.003633975 -0.0035;
                -0.001720557 0.001119398;
                0.00289884 0.003032815;
                0.007518238 0.001119398;
                0.009749227 -0.003355274];
           
            obj.currentPoly = squeeze(obj.allPolys{1});
            
            obj.allStartZones{1} = [len*0.25, len*0.25;
                -len*0.25, len*0.25;
                -len*0.25, -len*0.25;
                len*0.25, -len*0.25;
                len*0.25, len*0.25];
            
            allStartZones3bif(1,:,:) = [-0.0095 -0.004;
               -0.0085 -0.004;
               -0.0085 -0.003;
               -0.0095 -0.003;
               -0.0095 -0.004];
            allStartZones3bif(2,:,:) = [-0.0095 -0.0037;
               -0.007 -0.0036;
               -0.007 -0.0034;
               -0.0095 -0.0032;
               -0.0095 -0.0037];
            allStartZones3bif(3,:,:) = [-0.00363 -0.0035;
               -0.0045 -0.003;
               -0.0037 -0.0025;
               -0.0035 -0.0027;
               -0.00363 -0.0035];
            allStartZones3bif(4,:,:) = [-0.0038 -0.0034;%1st upper
               -0.0043 -0.0031;
               -0.0024 -0.0012;%%
               -0.0022 -0.0013;%%
               -0.0038 -0.0034];
            
           obj.allStartZones{2} = allStartZones3bif;

               
           obj.allStartZones{3} = [-0.0095 -0.004;
               -0.0094 -0.004;
               -0.0094 -0.003;
               -0.0095 -0.003;
               -0.0095 -0.004];  
           
           obj.allStartZones{4} = [-0.0095 -0.004;
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
           
           obj.currentStartZone = squeeze(obj.allStartZones{1});
           
           allEndZones3bif(1,:,:) = [0.00941 -0.00269 %Test?(same as 3 bifurcations)
               0.00870 -0.0034;
               0.00799 -0.00269;
               0.00870 -0.00198;
               0.00941 -0.00269];
           allEndZones3bif(2,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0007 -0.0063;
               -0.0015 -0.0071;
               -0.00096 -0.00754];
           allEndZones3bif(3,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0005 -0.006;%Values don't line up perfectly, but oh well - they are only used to stop particles
               -0.0018 -0.0068;
               -0.00096 -0.00754];
           allEndZones3bif(4,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0005 -0.006;%Values don't line up perfectly, but oh well - they are only used to stop particles
               -0.0018 -0.0068;
               -0.00096 -0.00754];

            obj.allEndZones{1} = allEndZones3bif;
            obj.allEndZones{2} = allEndZones3bif;
       %    obj.allEndZones(2,1,:,:) = [0.00941 -0.00269 %3 bifurcations
       %        0.00870 -0.0034;
       %        0.00799 -0.00269;
       %        0.00870 -0.00198;
       %        0.00941 -0.00269];
       %    obj.allEndZones(2,2,:,:) = [0.00941 0.00438;%upper3rd
       %        0.00870 0.00509;
       %        0.0083 0.0047;%TODO check...
       %        0.00905 0.004;%TODO
       %        0.00941 0.00438];
       %    obj.allEndZones(2,3,:,:) = [-0.00096 -0.00754;%1st lower
       %        -0.00025 -0.00683;
       %        -0.0007 -0.0063;
       %        -0.0015 -0.0071;
       %        -0.00096 -0.00754];
       %    obj.allEndZones(2,4,:,:) = [0.00006 0.00632;%upper2nd
       %        -0.00096 0.00632;
       %        -0.00099 0.006;%TODO check...
       %        0.00009 0.006;%TODO
       %        0.00006 0.00632];
          
        %   obj.allEndZones(3,:,:) = [0.00941 -0.00269
        %       0.00870 -0.0034;
        %       0.00799 -0.00269;
        %       0.00870 -0.00198;
        %       0.00941 -0.00269];
           v3endzones(1,:,:) = [-0.00096 -0.00754;%1st lower
               -0.00025 -0.00683;
               -0.0007 -0.0063;
               -0.0015 -0.0071;
               -0.00096 -0.00754];
           v3endzones(2,:,:) = [-0.00025 0.00036;%1st upper
               -0.00096 0.00107;
               -0.00165 0.00027;
               -0.0009 -0.00043;
               -0.00025 0.00036];
           obj.allEndZones{3} = v3endzones;
           allEndZones4bif(1,:,:) = [0.009749227 -0.003355274;%lastLower
               0.010644161,-0.002909076;
               0.010644161,-0.001909076%TODO back up
               0.0149227 -0.003355274;%TODO back up
               0.009749227 -0.003355274];
           allEndZones4bif(2,:,:) = [0.012959844 0.002681477;%lastUpper
               0.012659844 0.002181477;%TODO back up
               0.01064254 0.0031298;%TODO back up
               0.01264254 0.0036298;
               0.012959844 0.002681477];
            allEndZones4bif(3,:,:) = [0.005353453 0.008193409;%Mid
                0.004429574 0.008576092;
                0.004429574 0.008176092;%TODO back up
                0.005353453 0.008093409;%TODO back up
                0.005353453 0.008193409];
            allEndZones4bif(4,:,:) = [-0.003633975,0.006504162;%SecondUpper
                -0.004557854,0.006121479;
                -0.004157854,0.006021479;%TODO back up
                -0.003333975,0.006204162;%TODO back up
                -0.003633975,0.006504162];
            allEndZones4bif(5,:,:) = [-0.002644437,-0.008502081;%FirstLower
                -0.001720557,-0.008119398;
                -0.001220557,-0.008019398;%TODO back up
                -0.002244437,-0.008102081;%TODO back up
                -0.002644437,-0.008502081];

           obj.allEndZones{4} = allEndZones4bif;

      %     obj.allEndZones(4,1,:,:) = [0.00006 0.00632;%upper2nd
      %         -0.00096 0.00632;
      %         -0.00099 0.006;
      %         0.00009 0.006;
      %         0.00006 0.00632];
      %     obj.allEndZones(4,2,:,:) = [0.00501 0.00036;%centre
      %         0.00501 0.00132;
      %         0.0045 0.00132;
      %         0.0045 0.00036;
      %         0.00501 0.00036];
      %     obj.allEndZones(4,3,:,:) = [-0.00096 -0.00754;%1st lower
      %         -0.00025 -0.00683;
      %         -0.0007 -0.0063;
       %        -0.0015 -0.0071;
       %        -0.00096 -0.00754];

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
            
           obj.currentEndZone = squeeze(obj.allEndZones{1});
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
           
            outOfBoundsPolys3BIF(1,:,:) = [-0.0095 -0.004;
                -0.0045 -0.004;
                -0.0045 -0.005;
                -0.0095 -0.005];
            outOfBoundsPolys3BIF(2,:,:) = [-0.0045 -0.004;
                -0.00096 -0.00754;
                -0.000955 -0.009;
                -0.0045 -0.009];         
            outOfBoundsPolys3BIF(3,:,:) = [-0.00096 -0.00754;%1st lower
                -0.00025 -0.00683;
                0.001 -0.008;
                -0.00096 -0.009];
            outOfBoundsPolys3BIF(4,:,:) = [-0.00025 -0.00683;%1st lower
                -0.00363 -0.0035;
                -0.00030 -0.0035;
                -0.00025 -0.00683];             
            outOfBoundsPolys3BIF(5,:,:) = [-0.00363 -0.0035;%centre 1st
                -0.00025 0.00036;
                -0.00025 -0.0035;
                -0.00363 -0.0035];
            outOfBoundsPolys3BIF(6,:,:) = [-0.00025 0.00036;%upper 1st
                0.00501 0.00036;
                0.00501 -0.0035;
                -0.00025 -0.0035];
            outOfBoundsPolys3BIF(7,:,:) = [0.00501 0.00036;%right2nd
                0.0087 -0.0034;
                0.00501 -0.0034;
                0.00501 0.00036];
            outOfBoundsPolys3BIF(8,:,:) = [0.0087 -0.0034;%lower3rd
                0.00941 -0.00269;
                0.01 -0.0035;
                0.00950 -0.0044];
            outOfBoundsPolys3BIF(9,:,:) = [0.00941 -0.00269;%lower3rdg
                0.00587 0.00085;
                0.00941 0.00085;
                0.00941 -0.00269];
            outOfBoundsPolys3BIF(10,:,:) = [0.00587 0.00085;%centre3rd
                0.00941 0.00438;
                0.00941 0.00085;
                0.00587 0.00085];
            outOfBoundsPolys3BIF(11,:,:) = [0.00941 0.00438;%upper3rd
                0.00870 0.00509;
                0.009 0.00609;
                0.01 0.005];
            outOfBoundsPolys3BIF(12,:,:) = [0.0087 0.00509;%upper3rd
                0.00501 0.00132;
                0.00501 0.00509;
                0.0087 0.00509];              
            outOfBoundsPolys3BIF(13,:,:) = [0.00501 0.00132;%right2nd
                0.00006 0.00132;
                0.002 0.0035;
                0.00501  0.0035];
            outOfBoundsPolys3BIF(14,:,:) = [0.00006 0.00132;%centre2nd
                0.00006 0.00632;
                0.002 0.00632;
                0.002 0.0035];
            outOfBoundsPolys3BIF(15,:,:) = [0.00006 0.00632;%upper2nd
                -0.00096 0.00632;
                -0.00096 0.00732;
                0.00006 0.00732];              
            outOfBoundsPolys3BIF(16,:,:) = [-0.00096 0.00632;%upper2nd
                -0.00096 0.00107;
                -0.0026 0.00107;
                -0.0026 0.00632];
            outOfBoundsPolys3BIF(17,:,:) = [-0.00096 0.00107;%upper1st
                -0.0045 -0.003;
                -0.0045 0.00107;
                -0.00096 0.00107];
            outOfBoundsPolys3BIF(18,:,:) = [-0.0045 -0.003;
                -0.0095 -0.003;
                -0.0095 -0.001;
                -0.0045 -0.001];
            outOfBoundsPolys3BIF(19,:,:) = [-0.0095 -0.003;
                -0.0095 -0.004;
                -0.01 -0.004;
                -0.01 -0.003];  

            outOfBoundsPolys4BIF(1,:,:) = [-0.0095 -0.004;
                -0.0045 -0.004;
                -0.0045 -0.005;
                -0.0095 -0.005];
            outOfBoundsPolys4BIF(2,:,:) = [-0.0095 -0.003;
                -0.0095 -0.004;
                -0.01 -0.004;
                -0.01 -0.003];
            outOfBoundsPolys4BIF(3,:,:) = [-0.0095 -0.003;
                -0.0045,-0.003;
                -0.0045,-0.001;
                -0.0095 -0.001];   %TODO!

            obj.outOfBoundsPolys{1} = outOfBoundsPolys3BIF; %change this for the square at the start if needed.
            obj.outOfBoundsPolys{2} = outOfBoundsPolys3BIF;
            obj.outOfBoundsPolys{3} = outOfBoundsPolys3BIF;
            obj.outOfBoundsPolys{4} = outOfBoundsPolys4BIF;

            obj.currentOutOfBoundsPolys = obj.outOfBoundsPolys{1};

            obj.hardCodedOrthogonalWallContacts{1} = [0 1; 
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
            obj.hardCodedOrthogonalWallContacts{2} = obj.hardCodedOrthogonalWallContacts{1};
            obj.hardCodedOrthogonalWallContacts{3} = obj.hardCodedOrthogonalWallContacts{1};
            obj.hardCodedOrthogonalWallContacts{4} = [1 0;
                0 -1];   %TODO

            obj.currentHardCodedOrthogonalWallContacts = obj.hardCodedOrthogonalWallContacts{1};

            for i = 1:length(obj.currentPoly)-1 
                obj.currentPolyVector(i,:) = obj.currentPoly(i,:) - obj.currentPoly(i+1,:);
            end
            obj.currentFlowValues = fd.FlowValues{1};
            obj.currentFlowLocations = fd.FlowLocations{1};

        end
        
        function obj = change(obj,num,fd)
            obj.currentPoly = squeeze(obj.allPolys{num});
            for i = 1:length(obj.currentPoly)-1 
                obj.currentPolyVector(i,:) = obj.currentPoly(i,:) - obj.currentPoly(i+1,:);
            end
            obj.currentStartZone = squeeze(obj.allStartZones{num});
            if(size(obj.currentStartZone) == 3)
                obj.currentStartZone = squeeze(obj.currentStartZone(1,:,:));
            end
            obj.currentEndZone = squeeze(obj.allEndZones{num});
            obj.currentOutOfBoundsPolys = squeeze(obj.outOfBoundsPolys{num});
             obj.currentHardCodedOrthogonalWallContacts = squeeze(obj.hardCodedOrthogonalWallContacts{num});
            obj.currentFlowValues = fd.FlowValues{num};
            obj.currentFlowLocations = fd.FlowValues{num};
        end

    end
end

