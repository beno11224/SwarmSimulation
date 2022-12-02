function ParticlePathData = ReadAllResults(readAllFiles, poly, goalOutlet)
    addpath 'E:\SwarmSimulation' %TODO remove
    if ~exist('readAllFiles','var')
     % third parameter does not exist, so default it to something
      readAllFiles = true;
    end
    if ~exist('goalOutlet','var') || ~exist('poly','var')
        poly = Polygons(0.0096);
        poly = poly.change(2); 
        goalOutlet = 2; %for legacy reasons
    end
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
            while ischar(tline)
               datas = split(tline,',');
               time = datas(1);
               magForce = datas(2);
               goalPercentage = datas(3);
               velocities = datas(4);
               positions = datas(5);

%TODO - make these all numerical please!!

               velocities = strip(velocities,'[');
               velocities = strip(velocities,']');
               allVelocities = split(velocities,';');
               positions = strip(positions,'[');
               positions = strip(positions,']');
               allPositions = split(positions,';');
               pagePositions = [];
               pageVelocities = [];
               inputForce = [inputForce; strip(strip(magForce,']'),'[')];
               times = [times; time];
               for(lineIndex = 1:length(allPositions))
                   xAndYPositions = split(allPositions(lineIndex),' ');
                   xAndYVelocities = split(allVelocities(lineIndex),' ');
                   pagePositions = [pagePositions; [str2double(xAndYPositions(1)), str2double(xAndYPositions(2))]];
                   pageVelocities = [pageVelocities; [str2double(xAndYVelocities(1)), str2double(xAndYVelocities(2))]];
               end
               tidiedPositions = cat(3,tidiedPositions, pagePositions);
               tidiedVelocities = cat(3,tidiedVelocities,pageVelocities);

               tline = fgetl(fid);    
            end
            
            pageCount = (fileIndex - 1 - badFilesCount) * size(tidiedPositions,1);
            fileCount = fileIndex - badFilesCount;
           % temporaryFileParticlePaths = [];
            for particleCount = 1: size(tidiedPositions,1)
                goalTime = 0;
                correctOutlet = false;
                particleFinish = false;
                for timeStepCount = 1:size(squeeze(tidiedPositions(particleCount,:,:)),2)
                   for(outletCount = 1:size(poly.currentEndZone,1))
                        if(inpolygon(tidiedPositions(particleCount,1,timeStepCount),tidiedPositions(particleCount,2,timeStepCount),poly.currentEndZone(outletCount,:,1),poly.currentEndZone(outletCount,:,2)))
                            correctOutlet = outletCount == goalOutlet;
                            goalTime = times(timeStepCount);
                            particleFinish = true;
                            break;
                        end
                    end
                    if particleFinish
                        break;
                    end
                end
                validParticle = inpolygon(tidiedPositions(particleCount,1,timeStepCount),tidiedPositions(particleCount,2,timeStepCount),poly.currentPoly(:,1),poly.currentPoly(:,2)); %If the particle is out of bounds at end then it's invalid.
                try
                    %LineCount? or some other way?
                %    ParticlePathData(particleCount + pageCount) = ParticlePath(validParticle, correctOutlet, goalTime, inputForce, squeeze(tidiedPositions(particleCount,:,:)), squeeze(tidiedVelocities(particleCount,:,:)), times, goalPercentage);
                %    a = ParticlePath(validParticle, correctOutlet, goalTime, inputForce, squeeze(tidiedPositions(particleCount,:,:)), squeeze(tidiedVelocities(particleCount,:,:)), times, goalPercentage);
               % ab(particleCount,fileCount) = (fileCount*50+particleCount)
                temporaryFileParticlePaths(particleCount) = ParticlePath(validParticle, correctOutlet, goalTime, inputForce, squeeze(tidiedPositions(particleCount,:,:)), squeeze(tidiedVelocities(particleCount,:,:)), times, goalPercentage);
                catch
                %    i = 1; %use to debug
                %    ParticlePathData(lineCount + pageCount) = ParticlePath(true, 0, inputForce, pagePositions, pageVelocities, times);
                end

            end
            ParticlePathData(fileCount,:) = temporaryFileParticlePaths;
            pause(0.05);
            fclose(fid);
        end
    end

end