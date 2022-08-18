function ReadResults()
    folderPath = uigetdir();
    allFiles = dir(fullfile(folderPath, '*.csv'));
    polygon = Polygons(0.0096);
    polygon = polygon.change(2);    
    plot1 = figure;

    for fileIndex = 1:length(allFiles)
        
        allFiles(fileIndex).name
        useFile = input("Read This File?","s")
        if(useFile == "y" || useFile == "Y" || useFile == "yes" || useFile == "Yes")
            %Now Do Stuff!

            close(plot1);
            plot1 = figure;
            ax1 = axes('Parent',plot1);
            hold on;
            fid = fopen(folderPath + "\" + allFiles(fileIndex).name);
            lines = {}; %remove this?
            tline = fgetl(fid);
            if(tline == -1)
                "Nothing in the File"
                continue;
            end
            polyLine = plot(ax1,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
            endLine = plot(ax1,polygon.currentEndZone(1,:,1),polygon.currentEndZone(1,:,2), 'Color','g');
            tidiedPositions = [];
            times = [];
            while ischar(tline)
                %TODO port this into Python - this is the reading bit
               datas = split(tline,',');
               time = datas(1);
               magForce = datas(2);
               goalPercentage = datas(3);
               velocities = datas(4);
               positions = datas(5);

               positions = strip(positions,'[');
               positions = strip(positions,']');
               allVelocities = split(positions,';');
               pagePositions = [];
               times = [times; time];
               for(lineIndex = 1:length(allVelocities))
                   xAndYVelocities = split(allVelocities(lineIndex),' ');
                   a = [str2double(xAndYVelocities(1)), str2double(xAndYVelocities(2))];
                   pagePositions = [pagePositions; [str2double(xAndYVelocities(1)), str2double(xAndYVelocities(2))]];
               end
               tidiedPositions = cat(3,tidiedPositions, pagePositions);
               tline = fgetl(fid);
            end

            for(lineCount = 1: size(tidiedPositions,1))
              %  scatter(ax1, squeeze(tidiedPositions(lineCount,1,:)), squeeze(tidiedPositions(lineCount,2,:)),1:100,[],1:4);
                %particlePoints = 
                plot(ax1, squeeze(tidiedPositions(lineCount,1,:)), squeeze(tidiedPositions(lineCount,2,:)),'-', 'markerSize', 1);
              %  pause(0.3);
              %  delete(particlePoints);
            end
            pause(0.1);
            fclose(fid);

        end
    end
    useFile = input("Press any key to exit","s")
    close all;
end