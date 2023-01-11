function ReadInFlowDataFromComsolCSV()
close all;
    %open polygon vertexes, then the flow data. - EITHER 
    % - must match the matlab ones OR
    % - matlab needs to load in these files.
    [fPName,fPPath] = uigetfile('*.csv'); %points are x,y, newline for each point.
    polyPath = fPPath +""+ fPName;
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

    [fName,fPath] = uigetfile('*.csv');
    fullPath = fPath +""+ fName;
    fid = fopen(fullPath);
    tline = fgetl(fid);
    if(tline == -1)
        "Nothing in the File : " + allFiles(fileIndex).name
        return;
    end

    lineCount = 0;
    while ischar(tline)
        if(tline(1) == '%')
            lineCount = lineCount + 1;
            %Not data
            tline = fgetl(fid);
            continue;
        end
        splits = split(tline,',');
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
   ashape = alphaShape(locX',locY');
    plot(ashape);
   % ashape.Points.
    %triplot(ashape);
%    polygon = Polygons(0.0096);
%    C = squeeze(polygon.allPolys(2,:,:));
%    tri = delaunayTriangulation([locX',locY']);%,C);
%    triplot(tri); %draw like this
%    IO = isInterior(tri);
   % triplot(tri(IO,:));
%    triplot(tri(IO, :),tri.Points(:,1), tri.Points(:,2));
end