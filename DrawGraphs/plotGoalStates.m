function plotGoalStates(readAllFiles)
    if ~exist('readAllFiles','var')
     % third parameter does not exist, so default it to something
      readAllFiles = true;
    end
    poly = Polygons(0.0096,FlowData05());
    poly = poly.change(2,FlowData05()); 
    goalOutlet = 2; %for legacy reasons
    folderPath = uigetdir();
    allFiles = dir(fullfile(folderPath, '*.csv'));
    badFilesCount = 0;

    for fileIndex = 1:length(allFiles)
        
        useFile = 'y';
        if(~readAllFiles)
            allFiles(fileIndex).name
            useFile = input("Read This File?","s")
        end
        if(useFile == "y" || useFile == "Y" || useFile == "yes" || useFile == "Yes")
            %Now Do Stuff!
            if(~readAllFiles)
                %Do something?
            end

            fid = fopen(folderPath + "\" + allFiles(fileIndex).name);
            tline = fgetl(fid);
            if(tline == -1)
                "Nothing in the File : " + allFiles(fileIndex).name
                badFilesCount = badFilesCount + 1;
                continue;
            end

            tidiedPositions = [];
            tidiedVelocities = [];
            times = [];
            inputForce = [];

            %read last line
            val = "";
            while ischar(tline)
                val = tline;
                tline = fgetl(fid);
            end
            splitVal = split(val,',');
            goal = replace(replace(splitVal(6),"[",""),"]","");
            splitGoal = split(goal,';');
            resultGoal = [0,0,0,0,0];
            for particle = 1:length(splitGoal)
                individualGoal = split(splitGoal(particle),' ');
                for(i = 1:length(individualGoal))
                    resultGoal(i) = resultGoal(i) + str2double(individualGoal(i));
                end
            end
            allFiles(fileIndex).name
            resultGoal
        end
    end
end

