function readAndStoreCSVData(asState, folderPath)
    if nargin < 1
        asState = true;
    else
        if(~islogical(asState))
            error("asState must be true or false")
        end
    end
    if nargin < 2
        folderPath = "";    
    else
        if(~isstring(folderPath))
            error("folderPath must be a string")
        end
    end
    IMPORTEDexpertStates = [];
    IMPORTEDexpertActions = [];
    IMPORTEDFILEDELIMITERS = [];
    flowRates = [];
    dataFileNameList = [];

    if(folderPath == "")
        "Choose a Folder to read"
        folderPath = uigetdir;
    end
    if(length(dataFileNameList) < 1)
        "Reading FileNames"
        dOuter = dir(folderPath);
        for dirCount = 1:length(dOuter)
            innerFolderName = dOuter(dirCount).name;
            if(~(strcmp(innerFolderName,'.') || strcmp(innerFolderName,'..')))
                fileList = dir(strcat(dOuter(dirCount).folder,'\',dOuter(dirCount).name));
                for fileCount = 1:length(fileList)
                    if(~(strcmp(fileList(fileCount).name,'.') || strcmp(fileList(fileCount).name,'..')) && length(fileList(fileCount).name) >= 1)
                        filePathToAdd = strcat(fileList(fileCount).folder,'\',fileList(fileCount).name);
                        dataFileNameList{end+1} = filePathToAdd;
                    end
                end
            end
        end
    "All files located"
    end

    "Reading the expert files"
    for(fileCount = 1:length(dataFileNameList))
        chosenFile = string(dataFileNameList(fileCount));
        %Open the file to read
        flowRate = (split(chosenFile,'\'));
        flowag = flowRate(end-1);
        if(strlength(flowag)>1)
            flowRateNormalised = sscanf(flowag,'%*[^0123456789]%d');
        else
            flowRateNormalised = str2double(flowag);
        end
        if(isnan(flowRateNormalised))
            flowRateNormalised = realmin.*6;
            "There was some error with reading the flow rate - this data is bad..."
        end
        flowRateNormalised = flowRateNormalised./60; %Check this translates between matlab code and actual data - determines the flow velocities used to train with
        fileToUse = fopen(chosenFile);
        tline = fgetl(fileToUse);
        finished = false;
        lineCount=0;
        LastPercentage = 0;
        StatesToAdd = [];
        AllDataToAdd = [];
        ActionsToAdd = [];
        while(ischar(tline) && ~finished) %(app.timePassed <= app.timeLimit)
            lineCount = lineCount + 1;
            datas = split(tline,',');
            timeStr = datas(1);
            magForce = datas(2);
           % goalPercentage = datas(3);
           LastPercentage = str2double(datas(3));
           % velocities = datas(4);
            positions = datas(5);
            goalPositions = datas(6); %might be worth adding this in...

            time = str2double(timeStr);
            
            allMag = strip(magForce,'[');
            allMag = strip(allMag,']');
            allMag = split(allMag,' ');
            magx = str2double(allMag(1));
            magy = str2double(allMag(2));

            positions = strip(positions,'[');
            positions = strip(positions,']');
            allPositions = split(positions,';');
            positionArray = [];
            allDataArray = [];
            goalPositions = strip(goalPositions,'[');
            goalPositions = strip(goalPositions,']');
            allGoalPositions = split(goalPositions,';');
            for(lineIndex = 1:length(allPositions))
                yPos = split(allPositions(lineIndex)," ");
                xPos = str2double(yPos(1));
                yPos = str2double(yPos(2));
                gPos = split(allGoalPositions(lineIndex)," ");
                gp1 = str2double(gPos(1));
                gp2 = str2double(gPos(2));
                gp3 = str2double(gPos(3));
                gp4 = str2double(gPos(4));
                gp5 = str2double(gPos(5));
                positionArray(end+1,:) = [xPos.*100, yPos.*100,flowRateNormalised];
                allDataArray(end+1,:) = [xPos.*100, yPos.*100,flowRateNormalised,gp1,gp2,gp3,gp4,gp5,time];
            end
            ActionsToAdd(end+1,:) = [magx,magy];
            % if(lineCount==1)                            
            %     %IMPORTEDexpertActions(end,:) = [-100,-100];
            %     %IMPORTEDexpertActions(end,:) = [-100,-100];
            % end
            StatesToAdd(end+1,:,:) = positionArray;
            AllDataToAdd(end+1,:,:) = allDataArray;
            % if(any(positionArray(:,1)>0)) %??
            %     finished = true;
            % end
            tline = fgetl(fileToUse);
        end
        if(asState && (true || LastPercentage>0.13)) %this limits the data cleaning. Higher value is 'better' data, but less data to train on.
            IMPORTEDexpertStates(end+1:end+size(StatesToAdd,1),:,:) = StatesToAdd;
            IMPORTEDexpertActions(end+1:end+size(ActionsToAdd,1),:) = ActionsToAdd;
            IMPORTEDFILEDELIMITERS(end+1) = lineCount;
        else 
            if(~asState)
                IMPORTEDexpertStates(end+1:end+size(AllDataToAdd,1),:,:) = AllDataToAdd;
                IMPORTEDexpertActions(end+1:end+size(ActionsToAdd,1),:) = ActionsToAdd;
                IMPORTEDFILEDELIMITERS(end+1) = lineCount;
            end
        end
        fclose(fileToUse);
        "File" + fileCount + "/" + length(dataFileNameList) + " Read"
    end
    if(asState)
        save("storedTrainingVariables.mat","IMPORTEDexpertStates", "IMPORTEDexpertActions", "IMPORTEDFILEDELIMITERS", "flowRates");
    else
        save("storedAllDataVariables.mat","IMPORTEDexpertStates", "IMPORTEDexpertActions", "IMPORTEDFILEDELIMITERS", "flowRates");
    end
    "Complete"
end

 %Used for reading state from csv files. This is currently unused,
%but can be adjusted to work if more data needs to be converted.
function sl = statePairsToCorrectState(app, stateList)
    if(true) %This is when particles are being removed from the current state if they are in end zone.
        pALocation = squeeze(stateList(:,:,1:2));
        xSTD = zeros(size(pALocation,1),1);
        ySTD = zeros(size(pALocation,1),1);
        xAVG = zeros(size(pALocation,1),1);
        yAVG = zeros(size(pALocation,1),1);
        covar = zeros(size(pALocation,1),1);
        flowRate = zeros(size(pALocation,1),1);
        for(dataIndex = 1:size(pALocation,1))   %zeros(size(stateList,1),1);
            allEndZones = sum(app.particleFunctions.isParticleInEndZone(app.polygon.currentEndZone,squeeze(pALocation(dataIndex,:,:))),2);%This should be 1 or 0            
            OnlyParticlesInPlay = squeeze(pALocation(dataIndex,allEndZones==0,:));
            if(size(OnlyParticlesInPlay,1) == 0)
                matState = [0,0,0,0,0,0]; %FIXME!
                error("matState is blank here");
            else
                aa = sum(OnlyParticlesInPlay(:,1),1)./ size(OnlyParticlesInPlay,2);
                xSTD(dataIndex) = std(OnlyParticlesInPlay(:,1),0,1);
                ySTD(dataIndex) = std(OnlyParticlesInPlay(:,2),0,1);
               % aaaasdgf = size(OnlyParticlesInPlay,2)
               % asdghdf = OnlyParticlesInPlay(:,1)
               % asgasgag = sum(OnlyParticlesInPlay(:,1),1)
                xAVG(dataIndex) = sum(OnlyParticlesInPlay(:,1),1)./ size(OnlyParticlesInPlay,1);
                yAVG(dataIndex) = sum(OnlyParticlesInPlay(:,2),1)./ size(OnlyParticlesInPlay,1);
                particleCoV = cov(OnlyParticlesInPlay(:,1),OnlyParticlesInPlay(:,2));
                covar(dataIndex) = particleCoV(1,2);
            end
            flowRate(dataIndex) = squeeze(stateList(dataIndex,1,3));%Just need it for one particle, lots of spare data here
        end
        sl = [xSTD, ySTD, covar, xAVG, yAVG, flowRate];
        return
    end
    %This needs to match the getState function.
    xSTD = std(squeeze(stateList(:,:,1)),0,2);
    ySTD = std(squeeze(stateList(:,:,2)),0,2);
    xAVG = sum(squeeze(stateList(:,:,1)),2)./ size(stateList,2);
    yAVG = sum(squeeze(stateList(:,:,2)),2)./ size(stateList,2);
    covar = zeros(size(stateList,1),1);
    for(i = 1:size(stateList,1))
        particleCoV = cov(squeeze(stateList(i,:,1)),squeeze(stateList(i,:,2)));
        covar(i) = particleCoV(1,2);
    end
    flowRate = squeeze(stateList(:,1,3));%Just need it for one particle, lots of spare data here
    sl = [xSTD, ySTD, covar, xAVG, yAVG, flowRate];
end