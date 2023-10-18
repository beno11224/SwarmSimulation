 function [locX,locY,flowX,flowY] = ReadInFlowDataFromComsolCSV(polyPath, meshPath)
    close all;
    %open polygon vertexes, then the flow data. - EITHER 
    % - must match the matlab ones OR
    % - matlab needs to load in these files.
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

    if(meshPath == "")
        [fName,fPath] = uigetfile('*.csv');
        meshPath = fPath +""+ fName;
    end
    fid = fopen(meshPath);
    tline = fgetl(fid);
    if(tline == -1)
        "Nothing in the File : " + allFiles(fileIndex).name
        return;
    end

    lineCount = 1;
    while ischar(tline)
        if(tline(1) == '%')
          %  lineCount = lineCount + 1;
            %Not data
            tline = fgetl(fid);
            continue;
        end
        %splits = split(tline,',');
        splits = split(tline);
        x = str2double(splits(1));
        y = str2double(splits(2));
        if(inpolygon(x, y, poly(:,1), poly(:,2)))
            locX(lineCount) = x;
            locY(lineCount) = y;
            flowX(lineCount) = str2double(splits(3));
            flowY(lineCount) = str2double(splits(4));
            lineCount = lineCount + 1;
        end
        tline = fgetl(fid);
    end
%     
    writefidlocs = fopen("Location.txt","w");
    writefidvalues = fopen("Values.txt","w");
    ab = length(locX);
    for(i = 1:length(locX))
        fprintf(writefidlocs, '%s', string(locX(i)) + " " + string(locY(i)) + ";" + newline);
        fprintf(writefidvalues, '%s', string(flowX(i)) + " " + string(flowY(i))+";" + newline);
    end
    fclose(writefidlocs);
    fclose(writefidvalues);


% %ASHAPE CODE WORKS, can't do colour though.
%     ashape = alphaShape(locX',locY','HoleThreshold',0.05);
%     ashape.Alpha = 0.00009;
% %     [faces,nodes] = boundaryFacets(ashape)
% %     for(i = 1:length(faces))
% %         for(j = 1:length(locX))
% %             if(nodes(i,:) == [locX(j),locY(j)])
% %                 colorValues(i) = flowX(j).*flowY(j);
% %             end
% %         end
% %     end
% %     patch(nodes(:,1),nodes(:,2),1:length(nodes));
% %     hold on;
% %     patch(nodes(:,1),nodes(:,2),colorValues)
%    % colortoUse = flowX.*flowY;
%     aplot = plot(ashape,'FaceAlpha',0,'LineWidth',0.001);
    % ashape = alphaShape(locX',locY','HoleThreshold',0.05);
    % ashape.Alpha = 0.001;
    % aplot = plot(ashape,'FaceAlpha',0,'LineWidth',0.01);


   % ashape.Points.
    %triplot(ashape);
   polygon = Polygons(0.0096, FlowData05());
   C = cell2mat(polygon.allPolys(2));
   %C = squeeze(polygon.allPolys(2,:,:));
constraints = [(1:length(poly))',((1:length(poly))+1)'];
constraints(length(constraints),2) = 1;
   tri = delaunayTriangulation([poly;[locX',locY']],constraints);%,C);
  %  tri = delaunayTriangulation([locX',locY'],constraints);%,C);
    IO = isInterior(tri);
    triInt = tri(IO,:);
   % triplot(tri(IO,:),tri.Points(:,1),tri.Points(:,2),[flowX',flowY']);
   % %draw like this

   AverageColours = zeros(size(triInt,1),1);
   for(i = 1:size(triInt,1))
        x1 = triInt(i,:)-length(poly)
        if~(any(x1 < 1))
            AverageColours(i) = [sum(abs(flowX(x1))) .* sum(abs(flowY(x1)))];
        end
   end

   AverageColours = AverageColours + abs(min(AverageColours));
   AverageColours = AverageColours./max(AverageColours);

   ab = tri(IO,:);
   colurs = [flowX'.*flowY'];
   patch('Faces',triInt,'Vertices',tri.Points,'FaceVertexCData',AverageColours,'FaceColor','flat'); %draw like this
   %patch(triInt,tri.Points,AverageColours); %draw like this
%    IO = isInterior(tri);
  %  triplot(tri(IO,:));
  % triplot(tri(IO, :),tri.Points(:,1), tri.Points(:,2));
end