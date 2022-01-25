classdef FlowData
    
    properties
        FlowValues
    end
    
    methods
        function obj = FlowData()
            %The below data is for levels following Ex2, entered manually.
            %In future this will be read in from the filesystem
            
            obj.FlowValues = [0.1 0;
                0.1 0;
                0.1 0;
                0.07 0.1;
                0 0;
                0 0;
                0.1 0;
                0.1 0;
                0 0;
                0 0;
                0.1 0;
                0 0;
                0 0;
                0.1 0;
                0.07 0.1;
                0.1 0;
                0 0;
                0 0;
                0.1 0;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.06 0.1;
                0.1 -0.1;
                0.1 -0.1;
                0.1 -0.1;
                0.1 -0.1;
                0.1 0;
                0.1 0;
                0.1 0;
                0 0;
                0.1 -0.1;
                0.1 -0.1;
                0.1 -0.1;
                0.1 -0.1;
                0.1 -0.1;
                0.1 0;
                0.1 0;
                0.1 0;
                -0.01 0.1;
                -0.01 0.1;
                -0.01 0.1;
                -0.01 0.1;
                -0.01 0.1;
                0.07 0.1;
                0.07 0.1;
                0.07 0.1;
                0.07 0.1;
                0.07 0.1;
                0.07 0.1;
                -0.01 0.1;
                -0.01 0.1;
                -0.01 0.1;
                -0.01 0.1;
                -0.01 0.1;
                0 0;
                0.08 0.1;
                0.08 0.1;
                0.08 0.1;
                0.08 0.1;
                0.08 0.1;
                0.08 0.1;
                0.06 -0.1;
                0.06 -0.1;
                0.06 -0.1;
                0.06 -0.1;
                0.06 -0.1;
                0.06 -0.1;
                0.1 0;
                0.1 0;
                0.1 0;
                0.1 0;
                0.06 -0.1;
                0.06 -0.1;
                0.06 -0.1;
                0.06 -0.1;
                0.06 -0.1;
                0.1 0;
                0.1 0;
                0.1 0;
                0.1 0;
                1 0;
                -0.1 1;
                1 1;
                1 -0.5;
                0.8 1;
                0.75 0;
                0.6 -1;
                1 0;                
                1 0;                
                1 0;                
                1 0;                
                1 0;                
                1 0;                
                1 0;
                0.7 1;                
                0.7 1;
                1 0.8;
                0.8 1;
                0.8 1;
                0.8 1;
                0.8 1;
                -0.1 1;
                -0.1 1;
                1 0;
                -0.1 1;
                1 0;
                -0.1 1;
                1 0;
                1 0;
                1 -1;                
                1 -1;
                1 -1;
                1 -1;
                1 -1;
                0.6 1;
                0.6 1;
                0.6 1;
                0.6 1;
                0.6 1;
                0.6 1;
                1 0;
                0.7 1;
                1 0;
                0.5 -0.5;
                0.5 -0.5;
                0.5 -0.5;
                0.5 -0.5;
                0.1 -0.08;                
                0.5 -0.45;
                0.3 0.5;
                0.06 0.1;
                0.3 0.5;
                0 0;
                0.3 0.5;
                0.5 0;
                0.1 0;
                0.5 0;
                0.4 0;
                0.3 0;
                0.2 -0.2;
                0.5 -0.45;
                0.1 -0.08;                
                0.5 -0.45;
                0.5 0;
                0.1 0;
                0.5 0;
                1 -0.9;
                0 0;
                0.6 -0.5;
                0.5 0;
                0.25 0;
                0.6 -1;
                0.3 -0.6;
                0.3 -0.6;
                0.5 0;
                0 0;
                0.5 0;
                -0.05 0.5;                
                -0.05 0.5;
                -0.01 1;
                0.3 0;
                0.5 0;                
                0.5 0;
                1 0;
                0.25 -0.4;
                0.06 -0.1;
                0.12 -0.2;
                0.5 0;
                0.1 0;
                0.5 0;
                0.17 -0.3;
                0.35 -0.5;
                0.44 0.6;
                0.07 0.1;
                0.4 0.6;  
                0.5 0;
                1 0;
                0.4 -0.4;
                1 -1;
                0.25 0;
                0.1 0;
                0.3 0.3;
                0.2 0.05;
                0.5 0.2;
                0.5 0.2;
                0.5 0;
                1 0;
                0.8 0;
                0.8 0;
                1 0;
                0.1 0;
                0.25 0;
                0.4 -0.37;
                0.4 -0.37;
                0.5 0;
                0.5 0;
                0.5 0;
                0.1 0;
                0.5 0;                
                0.3 0.4;
                -0.02 0.5;
                0 0.9;
                0.25 0;
                0.1 0;
                0.25 0;
                0.62,1;
                0.47 0.7;
                0.47 0.7;
                0.1 -0.1;
                0.4 -0.4;
                0.25 0;
                0.25 0;
                0.065 0.1;
                0.27 0.4;
                0.25 0;
                0.1 0;
                0.25 0;
                0.3 -0.4;
                0.1 -0.1;
                0.7 1;
                0.38 0.5;
                0.07 0.1;
                0.38 0.5;
                1 0;
                1 0;
                1 0;
                0.5 0;
                0.3 0.5;
                0.06 0.1;
                0.3 0.5;
                0.3 0.5;
                0.3 0.5;
                0.6 1;
                0.4 0.5;
                0.08 0.1;
                0.4 0.5;
                0.8 1;
                0.4 0.5;
                0.8 1;
                0.38 0.5;
                0.38 0.5;
                0.38 0.5;
                0.07 0.1;
                0.38 0.5;
                0.1 -0.09;
                0 0;
                0.4 -0.3;
                0.1 -0.09;
                0.5 -0.45;                
                0.5 -0.45;
                0.1 -0.1;
                0.5 -0.45;                
                0.38 0.5;                
                0.38 0.5;                
                0.38 0.5;
                0.08 0.1;
                0.1 0;
                0.5 0;
                0.1 0;
                0.25 0;
                0.1 0;
                0.25 0;
                0.1 0;
                0.25 0;
                0.06 -0.1;
                -0.05 0.5;
                -0.01 0.1;
                -0.05 0.5;
                -0.05 0.5;
                -0.01 0.1;
                -0.05 0.5;
                1 -1;
                -0.01 0.1;
                -0.05 0.5;
                0.5 -0.45;
                0.5 -0.45;
                1 -0.9;                
                0.38 0.5;
                0.07 0.1;
                0.38 0.5;
                1 0;
                0.7 -0.1;
                0.25 0;
                0.1 0;
                1 0;
                0.2 0.5;
                0.08 0.1;
                0.3 0.5;
                0.3 0.5;
                0.06 0.1;
                0.3 0.5;
                0.3 0.5;
                0.08 0.1;
                0.3 0.5;
                0.5 0;
                0.38 0.5;                
                0.38 0.5;
                0.07 0.1;
                0.38 0.5;                
                0.5 -0.2;
                0.7 1;                
                0.38 0.5;                
                0.5 -0.45;
                0.1 -0.09;
                0.5 0.5;
                0 0.5;
                0.3 0.4;                
                0.38 0.5;
                0.07 0.1;
                -0.05 0.5;
                -0.01 0.1;
                -0.05 0.5;
                -0.05 0.5;
                -0.01 0.1;
                0.5 -0.45;
                0.1 -0.09;
                0.06 -0.1;
                0.6 -1;
                0.6 -1;
                0.6 -1;
                0.06 -0.1;
                0.6 -1;
                -0.01 0.1;
                -0.05 0.5;
                0.6 1;
                0.3 0.5;
                0.3 0.5;
                0.06 -0.1;
                0.7 -0.4;
                0.06 -0.1;
                0.6 -1;
                0 0;
                0.6 0.8;
                0.38 0.5;
                0.06 0.1;
                0.38 0.5;
                0.6 1;
                -0.05 0.5;
                0.25 0;
                0.5 0;
                1 0;
                0.7 0;
                0.7 1;
                0 1;
                0 0.5;
                -0.05 0.5;
                0.1 0;
                0.1 -0.1;
                0.5 -0.5;
                -0.05 0.5;
                0 0.1;
                0.3 0.5;
                0.3 0.5;
                0.6 1;
                0.3 0.5;
                0.45 0.6;
                0.7 1;
                1 0;
                1 0;
                1 0;
                0.75 0;
                0.3 0.5;
                0.06 0.1;
                0.3 0.5;
                0.1 0;
                0.25 0;
                0.38 0.5;
                0.07 0.1;
                0.38 0.5;
                0.06 0.1;
                -0.05 0.5;
                -0.01 1;
                -0.05 0.5;
                0.6 -1;
                0.06 -0.1;
                0.6 -1;
                0.6 1;
                -0.05 0.5;
                0 0;
                0.1 -0.1;
                0.3 0.5;
                0.6 1;                
                0.3 0.5;
                0.07 0.1;
                -0.05 0.5;
                -0.1 1;
                -0.01 0.1;
                0 0;
                0.5 0;
                0.1 0;
                0.5 0;
                0.38 0.5;
                0.7 1;
                0.4 0.4;
                0.6 0.2;
                0.25 0;
                0.1 0;
                -0.01 0.1;
                -0.01 0.1;
                0.06 0.1;
                0.06 0.1;
                0.38 0.5;
                0.07 0.1;
                -0.01 0.1;
                0.7 0;
                0.06 0.1;
                0.06 0.1;
                -0.05 0.5;
                -0.1 1;
                0.8 0.2;
                0.1 0.1;
                0.1 -0.1;
                0.1 -0.1;
                -0.01 0.1;
                1 0;
                0.5 0.4;
                0.6 -1;
                0.06 -0.1;
                0.06 -0.1;
                0.07 0.1;
                0.07 0.1;
                0.07 0.1;
                0.38 0.5;
                0.06 -0.1;
                0.6 -1;
                0.06 -0.1];
        end
    end
end

