classdef Lines
    %LINES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        totallinearray;
        linearray;
    end
    methods ( Access = public)
        function obj = Lines(app)
            %obj.linearray{1,1} = @(x,y,xLim) (y<(x + xLim  - 0.005));
            %obj.linearray{1,2} = @(x,y,xLim) (y>(x - xLim + 0.005));
            %obj.linearray{1,3} = @(x,y,xLim) (x<(y + xLim));
            %obj.linearray{1,4} = @(x,y,xLim) (x>(y - xLim));
            %linearray{1} = [@(x,y) (y<(x + app.UIAxes.XLim(2) - 0.005)) @(x,y) (y>(x - app.UIAxes.XLim(2) + 0.005)) @(x,y) (x<(y + app.UIAxes.XLim(2))) @(x,y) (x>(y - app.UIAxes.XLim(2)))];
            obj.totallinearray{1} = @(range) ([range,app.UIAxes.XLim(2) - 0.0002]);
            obj.totallinearray{2} = @(range) ([range,-app.UIAxes.XLim(2) + 0.0002]);
            obj.totallinearray{3} = @(range) ([app.UIAxes.XLim(2) - 0.0002, range]);
            obj.totallinearray{4} = @(range) ([-app.UIAxes.XLim(2) + 0.0002, range]);
            obj.linearray{1,1} = obj.totallinearray{1,1};
            obj.linearray{1,2} = obj.totallinearray{1,2};
            obj.linearray{1,3} = obj.totallinearray{1,3};
            obj.linearray{1,4} = obj.totallinearray{1,4};
            %^^^Basic square
            obj.totallinearray{2,1} = @(range) ([range, app.UIAxes.XLim(2)]);
        end
        function change(obj,nums)
            obj.linearray.clear;
            obj.linearray(1) = obj.totallinearray{1,1};
            obj.linearray(2) = obj.totallinearray{1,2};
            obj.linearray(3) = obj.totallinearray{1,3};
            obj.linearray(4) = obj.totallinearray{1,4};
            if(nums > 1)
                for i = 1:length(obj.totallinearray(nums))
                    obj.linearray(i+5) = obj.linearray{nums,i};
                end
            end
        end
    end
end

