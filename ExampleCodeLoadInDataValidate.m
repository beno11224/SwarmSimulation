

if(false) %Load in raw data and process (true) or just load in processed data (false)
    
    
    load("ExampleAllDataVariables.mat","IMPORTEDexpertStates", "IMPORTEDexpertActions", "IMPORTEDFILEDELIMITERS", "flowRates","meshToUse");
    expertStates = [];
    expertActions = [];
    valExpertStates = [];
    valExpertActions = [];
    flowRates = [];
    
    mesh = meshToUse;

    numberOfValidationTraces = 0.2; % 20% of data goes to validation - probably not required but this is how the data is used.
    
     %Sorting out Validation. This sorts 'raw' data.
    if(numberOfValidationTraces<1)
        lengthValidation = floor(numberOfValidationTraces .* length(IMPORTEDFILEDELIMITERS));
    else
        lengthValidation = numberOfValidationTraces;
    end
    
    validationSet = randi(length(IMPORTEDFILEDELIMITERS),lengthValidation,1);
    fileStartCursor = 1;
    for(fileCount = 1:length(IMPORTEDFILEDELIMITERS))
        if(any(validationSet(:) == fileCount))    
            % fileCount
            % if(fileCount == 209 || fileCount == 207 || fileCount == 197)
            %     "iiiiiii"
            % end
            valExpertActions(end+1:end+IMPORTEDFILEDELIMITERS(fileCount),:) = squeeze(IMPORTEDexpertActions(fileStartCursor:(fileStartCursor + IMPORTEDFILEDELIMITERS(fileCount)-1),:));
            valExpertStates(end+1:end+IMPORTEDFILEDELIMITERS(fileCount),:,:) = squeeze(IMPORTEDexpertStates(fileStartCursor:(fileStartCursor + IMPORTEDFILEDELIMITERS(fileCount)-1),:,:));
        else                    
            aaa = squeeze(IMPORTEDexpertActions(fileStartCursor:(fileStartCursor + IMPORTEDFILEDELIMITERS(fileCount)-1),:));
            expertActions(end+1:end+IMPORTEDFILEDELIMITERS(fileCount),:) = squeeze(IMPORTEDexpertActions(fileStartCursor:(fileStartCursor + IMPORTEDFILEDELIMITERS(fileCount)-1),:));
            expertStates(end+1:end+IMPORTEDFILEDELIMITERS(fileCount),:,:) = squeeze(IMPORTEDexpertStates(fileStartCursor:(fileStartCursor + IMPORTEDFILEDELIMITERS(fileCount)-1),:,:));
        end
        fileStartCursor = fileStartCursor+IMPORTEDFILEDELIMITERS(fileCount); %added filecount here
    end  
    
    
    
        %Now turn the raw data into the points on the mesh
    for i = 1:2
        if(i == 1)  %Don't worry, the action list and statelist should stay lined up after this
            stateList = expertStates;
        else
            stateList = valExpertStates;
        end
    
    
        sl = [];
        if(size(stateList) == 0)
            return
        end
        pALocation = squeeze(stateList(:,:,1:2))./100; %divide by 100 as it's saved as * 100 (For data representation)
        pAGoals = squeeze(stateList(:,:,4:8));   
        sl = zeros(size(pALocation,1),size(mesh,1));
        
        for(dataIndex = 1:size(pALocation,1))
            sl(dataIndex,:) = zeros(size(mesh,1),1);
        
            particlesInAnyGoalZone = any(squeeze(pAGoals(dataIndex,:,:))==1,2);
          %  OnlyParticlesInPlay = squeeze(pALocation(dataIndex,:,:)); %Use all particle locations
            OnlyParticlesInPlay = squeeze(pALocation(dataIndex,particlesInAnyGoalZone==0,:)); %Use only particles still in play
            if(any(size(OnlyParticlesInPlay,1) == 0))
                warning("State is blank here");
            else
                if(size(OnlyParticlesInPlay,2) == 1) %This complexity is brought on by reducing the number of particles being tracked using OnlyParticlesInPlay. To remove complexity consider all particles (pALocation)
                    if(size(OnlyParticlesInPlay,1) == 2)
                        OnlyParticlesInPlay = OnlyParticlesInPlay';
                    else
                        %There's an issue here
                        warning("State is wrong shape: " + size(OnlyParticlesInPlay));
                        continue;
                    end
                end
        
              %  closestNode = nearestNeighbor(mesh,OnlyParticlesInPlay);
                closestNode = knnsearch(mesh.Points,OnlyParticlesInPlay,'K',5,'Distance','euclidean');
                for(neuronIndex = 1:size(mesh,1))
                    %Limit between 0 and 1, and only up to 10% of all particles present. Any more saturates
                    valueToUse = sum(closestNode(:,1) == neuronIndex)./2; 
                    valueToUse = valueToUse + sum(closestNode(:,2) == neuronIndex)./4; 
                    valueToUse = valueToUse + sum(closestNode(:,3) == neuronIndex)./6; 
                    valueToUse = valueToUse + sum(closestNode(:,4) == neuronIndex)./8; 
                    valueToUse = valueToUse + sum(closestNode(:,5) == neuronIndex)./16; 
                    if(valueToUse > (size(pALocation,2)*0.1))
                        valueToUse = size(pALocation,2)*0.1;
                    end
                    sl(dataIndex,neuronIndex) = valueToUse./(size(pALocation,2)*0.1);    
                end    
            end
        end
        if(i == 1)  %Don't worry, the action list and statelist should stay lined up after this
            expertStates = sl;
        else
            valExpertStates = sl;
        end
    end
else
    %Just load in pre processed data
    load("ExampleTunedDataFile.mat","expertStates","expertActions","valExpertStates","valExpertActions")
end

%Setup sizes
n_states = size(expertStates,2);
n_actions = 2;
h_Layers = [6];
    
%Setup pyenv here - needs to be the location of your python.exe
try
    pyenv("Version","C:\Users\beno1\AppData\Local\Programs\Python\Python310\python.exe",ExecutionMode="OutOfProcess");
catch
    error("Please correct the python location on line 111, cannot find that executable")
end

%Now python as before:
pyrun("from pythonNNContstructor import *")
pyrun("model = NNClass(numStates,numActions,hiddenLayers)",numStates=n_states,numActions=n_actions,hiddenLayers=h_Layers)
pyrun("model.model.summary()")

hist = pyrun("uu = model.model.fit(np.array(state),np.array(target),batch_size=int(bS),epochs=int(ep), validation_data=(np.array(xT), np.array(yT)) ,verbose=0)","uu",state = expertStates, target = expertActions, bS = 49, ep = 1, xT = valExpertStates, yT = valExpertActions)
    %This line is used to decide the action in the play loop - not running
    %here as the sim isn't accessible in this file. getState will return a
    %state same format as expertStates (but just one state, not an array of states)
%action = double(pyrun("pred = model.model.predict(np.array([state]),verbose=0, batch_size=1)","pred",state=app.particleFunctions.getState(app.particleArrayLocation, flowRate, xShift, yShift, app.polygon.currentEndZone, app.ParticleLocationMesh)));
                