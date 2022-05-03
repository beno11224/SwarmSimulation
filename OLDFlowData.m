classdef FlowData
    
    properties
        FlowValues
    end
    
    methods
        function obj = FlowData()
            %The below data is for levels following Ex2, entered manually.
            %In future this will be read in from the filesystem
            
            obj.FlowValues = [0.001 0;
                0.001 0;
                0.001 0;
                0.0007 0.0007;
                0 0.001;
                0 0.001;
                0.001 0;
                0.001 0;
                0.0007 0.0007;
                0.0007 0.0007;
                0.001 0;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.001 0;
                0.0007 0.0007;
                0.001 0;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.001 0;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0 0.001;
                0 0.001;
                0 0.001;
                0 0.001;
                0 0.001;
                0 0.001;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0.0007 0.0007;
                0 0.001;
                0 0.001;
                0 0.001;
                0 0.001;
                0 0.001;
                0 0.001;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;
                0.001 0;               
                0.0007 -0.0007;               
                0.0007 -0.0007;               
                0.0007 -0.0007;                
                0.0007 -0.0007;               
                0.0007 -0.0007;       
                0.0007 -0.0007;
                0.7 -0.7;             
                0.7 0.7;
                0.7 0.7;
                0.7 0.7;
                1 0;
                0.7 -0.7; 
                0.7 -0.7;
                1 0;
                0.7 -0.7;
                0.7 -0.7;
                1 0;
                0.7 -0.7;
                1 0;
                0.7 -0.7;
                1 0;
                0.7 -0.7;                
                1 0;
                0.7 0.7;                
                0.7 0.7;
                0.7 0.7;
                0.7 0.7;
                0.7 0.7;
                0.7 0.7;
                1 0;
                0 1;
                1 0;
                0 1;
                1 0;
                0 1;
                1 0;
                0 1;
                1 0;
                0 1;
                0 1;               
                0.7 -0.7;
                0.7 -0.7;
                0.7 -0.7;
                0.7 -0.7;
                0.7 -0.7;
                0.7 -0.7;
                1 0;
                0.7 0.7;
                0.7 0.7;
                0.7 0.7;
                0.7 0.7;
                0.7 0.7;
                1 0;
                1 0;
                0 1;
                0.7 0.7;
                0.35 0.35;
                0.7 0.7;
                0.35 0.35;
                0.35 0.35;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.35 0.35;
                0.7 0.7;
                0.0007 0.0007;
                0.35 0.35;
                0 0.5;
                0 0.001;
                0 0.5;
                0.5 0;
                0.5 0;
                1 0;
                0 1;                
                0 0.001;
                0 0.5;
                0.35 0.35;
                0.35 0.35;
                0.7 0.7;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0 0.5;
                0 0.001;
                0 0.5;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0 0.5;
                0 0.001;
                0 0.5;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.35 0.35;
                0.45 -0.5;
                1 0;
                1 0;
                0.5 0;
                0.5 0;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.5 0;
                0.5 0;
                1 0;
                0.8 0.6;
                0.35 0.35;
                0 0.5;
                0 1;
                0 0.5;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0 0.5;
                0 0.001;
                0 0.5;
                0 0.001;
                0 0.5;
                0 1;
                0 0.5;
                0 0.5;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.35 -0.35;
                0.7 -0.7;
                0.35 -0.35;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.001 0;
                0.5 0;
                0.35 0.35;
                0.0007 0.0007;
                0 0.001;
                0 0.5;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.5 0;
                0.001 0;
                0.5 0;
                0.5 0;
                0.001 0;
                0.5 0;
                0.5 0;
                0.1 0.2;               
                0.7 0.7;
                0.5 0;
                0.001 0;                
                0.5 0;                
                0.5 0;                
                0.001 0;    
                0.5 0;
                0 0.5;
                0 0.001;
                0.35 -0.35;
                0.7 -0.7;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.5 0;
                0.0001 0;
                0.5 0;
                0.35 -0.35;
                0.35 -0.35;
                0.7 -0.7;
                0.35 0.35;
                0.7 0.7;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;               
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 -0.35;
                0.35 -0.35;
                0.35 -0.35;                
                0.0007 -0.0007;
                0.35 -0.35;
                0.5 0;
                0.001 0;
                0.5 0;
                0.5 0;
                0.001 0;
                0.5 0;
                0.7 -0.7;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 -0.35;               
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 -0.35;                
                0.0007 -0.0007;
                0.35 -0.35;                
                0.0007 0.0007;                
                0.35 0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 -0.35;
                0.0007 -0.0007;               
                0.35 -0.35;
                0.5 0;
                0.001 0;
                0.5 0;
                0.001 0;
                0.5 0;
                0.7 -0.7;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 -0.35;
                1 0;
                0.5 0;
                0.5 0;
                0.001 0;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.5 0;
                0.5 0;
                0.5 0;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 0.35;
                0.5 0.45;%Wrong
                0.06 0.1;%wrong
                1 0;
                0.5 0;
                0.5 0;
                0.001 0;
                0 0.5;
                0 0.001;
                0 0.5;
                0.5 0;
                0.001 0;
                0.5 0;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.7 0.7;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.35 -0.35;
                0.35 -0.35;
                0.7 -0.7;
                0.35 -0.35;
                0.35 -0.35;
                0.0007 -0.0007;
                0.5 0;
                0.001 0;
                0.5 0;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.7 -0.7;
                0.5 -0.15;
                0.0007 -0.0007;
                0.35 -0.35;
                0.7 0.7;
                0.35 0.35;
                0.5 0;
                1 0;
                0 0.5;
                0 0.001;
                0.5 0;
                0.5 0;
                0.5 0;
                1 0;
                0.5 0;
                0.5 0;
                0.35 -0.35;
                0.0007 -0.0007;               
                0.5 0;
                1 0;
                0.5 0;
                0.001 0;
                0.001 0;
                0.5 0;
                1 0;
                0.7 0.7;
                0.35 -0.35;
                0.7 -0.7;
                0.35 0.35;
                0.7 0.7;
                0.35 0.35;
                0.35 -0.35;
                0.0007 -0.0007;
                0 0.5;
                0 0.001;
                0 0.5;
                0 0.001;
                0 0.5;
                0.001 0;
                0.35 -0.35;
                0.7 -0.7;
                0.35 -0.35;
                0.7 -0.7;
                0.35 0.35;
                0.7 0.7;
                0.35 0.35;
                0.35 0.35;
                0.35 0.35;
                0.7 0.7;
                0.35 0.35;
                0.35 -0.35;
                0.0007 -0.0007;
                0.0007 -0.0007;
                0.0007 0.0007;
                0.35 -0.35;
                0.0007 -0.0007;
                0.5 0;
                0.5 0;
                0.001 0;
                0.5 0;
                0.5 0;
                0.35 0.35;
                0.0007 0.0007;
                0.35 0.35;
                0.5 0;
                0.001 0;
                0.5 0;
                0.001 0;
                0.001 0;
                0.5 0;
                0 1;
                0.0007 0.0007;
                0.35 0.35;
                0.35 0.35;
                0.7 0.7;
                0.35 0.35;
                0.7 -0.7;
                0 1;
                0 0.5;
                1 0;
                0.5 0;
                0.001 0;
                0.0007 0.0007;
                0.0007 0.0007;
                0.001 0;
                0.5 0;
                0.5 0;
                0.001 0
                0.35 -0.35;
                0.0007 -0.0007;
                0.35 -0.35;
                0.35 0.35;
                0.7 0.7;
                0.35 0.35;
                0.35 0.35;
                0.0007 0.0007;
                0.0007 0.0007;
                0.35 0.35;
                0 0.5;
                0 1;
                0.7 -0.7;
                0 1;
                0.001 0;
                0.35 0.35;
                0.0007 0.0007;
                0.5 0;
                0.5 0;
                0.001 0;
                0.5 0;
                0.0007 0.0007;
                0.0007 0.0007;
                1 0;
                0.7 -0.7;
                0.0007 0.0007;
                0.7 0.7;
                1 0;
                0 0.5;
                0 0.001;%??
                0.001 0;
                0.5 0;
                0.001 0;
                0.5 0;
                0 1;
                0.35 -0.35;
                0.0007 -0.0007;
                0.0007 0.0007;
                0.7 0.7;
                0 0.001;
                1 0];
        end
    end
end
