 function [locX,locY,flowX,flowY] = ReadInFlowDataFromComsolCSV(polyPath, meshPath)
    close all;
    % % open polygon vertexes, then the flow data. - EITHER 
    % % - must match the matlab ones OR
    % % - matlab needs to load in these files.
    if(polyPath == "")
        [fPName,fPPath] = uigetfile('*.csv'); %points are x,y, newline for each point.
        polyPath = fPPath +""+ fPName;
    end
    pfid = fopen(polyPath);
    polyCount = 0;
    tline = fgetl(pfid);
    while ischar(tline)
        polyCount = polyCount + 1;
        splits = split(tline,',');
        x = str2double(splits(1));
        y = str2double(splits(2));
        poly(polyCount,:) = [x, y];
        tline = fgetl(pfid);
    end

    % if(meshPath == "")
    %     [fName,fPath] = uigetfile('*.csv');
    %     meshPath = fPath +""+ fName;
    % end
    % fid = fopen(meshPath);
    % tline = fgetl(fid);
    % if(tline == -1)
    %     "Nothing in the File : " + allFiles(fileIndex).name
    %     return;
    % end
    % 
    % lineCount = 1;
    % while ischar(tline)
    %     if(tline(1) == '%')
    %        lineCount = lineCount + 1;
    %         Not data
    %         tline = fgetl(fid);
    %         continue;
    %     end
    %     splits = split(tline,',');
    %     splits = split(tline);
    %     x = str2double(splits(1));
    %     y = str2double(splits(2));
    %     if(inpolygon(x, y, poly(:,1), poly(:,2)))
    %         locX(lineCount) = x;
    %         locY(lineCount) = y;
    %         flowX(lineCount) = str2double(splits(3));
    %         flowY(lineCount) = str2double(splits(4));
    %         lineCount = lineCount + 1;
    %     end
    %     tline = fgetl(fid);
    % end
    % 
    % writefidlocs = fopen("Location.txt","w");
    % writefidvalues = fopen("Values.txt","w");
    % ab = length(locX);
    % for(i = 1:length(locX))
    %     fprintf(writefidlocs, '%s', string(locX(i)) + " " + string(locY(i)) + ";" + newline);
    %     fprintf(writefidvalues, '%s', string(flowX(i)) + " " + string(flowY(i))+";" + newline);
    % end
    % fclose(writefidlocs);
    % fclose(writefidvalues);


% %ASHAPE CODE WORKS, can't do colour though.
    % ashape = alphaShape(locX',locY','HoleThreshold',0.05);
    % ashape.Alpha = 0.001;
    % aplot = plot(ashape,'FaceAlpha',0,'LineWidth',0.01);


    
    fd = FlowData05();
    locs = cell2mat(fd.FlowLocations(4));
    values = cell2mat(fd.FlowValues(4));
    totalColors = abs(values(:,1))+abs(values(:,2));
    totalColors = totalColors./max(totalColors);
    max(totalColors)
    min(totalColors)
    for(i = 1:size(locs,1))

        plot(locs(i,1),locs(i,2),'.', 'MarkerSize', 25,'Color',[totalColors(i), 1-totalColors(i), 1-totalColors(i)])
        hold on
    end
    close()

    %constraints = [(1:length(poly))',((1:length(poly))+1)'];
    %constraints(length(constraints),2) = 1;
    tri = delaunayTriangulation(locs(:,1),locs(:,2));%,constraints);
    IO = isinterior(polyshape(poly),incenter(tri));
   % IO2 =  isinterior(tri)
    triInt = tri(IO,:);
    AverageColours = zeros(size(tri.Points,1),1);  
    j = 1;
    for(i = 1:size(tri.Points,1))
        if(triInt(i) && j <= size(values,1))
            AverageColours(i) = [sqrt(values(j,1)^2 + values(j,2)^2)];
            j = j + 1;
        else
            AverageColours(i) = 0;
        end
    end
    %%Use this loop to view individual faces for debugging
    % for(iii = 1:size(tri.Points,1)) %25
    %     iii
    %     if(iii ~= 25 && iii ~= 621)
    %         plot(tri.Points(triInt(iii,:)',1),tri.Points(triInt(iii,:)',2))
    %         hold on
    %     end
    %     %pause(0.2)
    % end
    triInt([25;621],:) = []; %Remove individual faces (these two cross between two lowest branches)
    patch('Faces',triInt,'Vertices',tri.Points,'FaceVertexCData',AverageColours,'FaceColor','interp','EdgeAlpha',0.25);
    colormap(turbo(256))
    cb = colorbar()
    ylabel(cb,"Example Fluid Flow (M/s)","FontSize",20);
    set(gca,'Visible','off')
    set(gca,'PlotBoxAspectRatio', [1.0000    0.7903    0.7903])
    txt1 = "Inlet"
    txt2 = "Goal Outlet"
    txt3 = "Incorrect Outlet"
    text(-0.0095,-0.0022,txt1,'HorizontalAlignment','left','FontSize',24)
    text(0.0105,-0.00365,txt2,'HorizontalAlignment','right','FontSize',24)
    text(-0.0026,-0.0088,txt3,'HorizontalAlignment','left','FontSize',16)
    text(-0.0037,0.007,txt3,'HorizontalAlignment','right','FontSize',16)
    text(0.0044,0.009,txt3,'HorizontalAlignment','left','FontSize',16)
    text(0.013,0.004,txt3,'HorizontalAlignment','right','FontSize',16)
end