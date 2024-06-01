clear
close all
resultString = "";
%delteImage = rgb2gray(imread("F:\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\111223\image-000000.jpg"));
for(i=200:100:200)
   % D = 'F:\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\111223\2mt\'+string(i);
   % D = 'C:\Users\beno1\Desktop\A';
    D = 'C:\Users\beno1\Desktop\May24(RotSwarm)\E';
    dirs = dir(D);
    dirs(1:2)=[];
    dirFlags = [dirs.isdir];
    dirs = dirs(dirFlags);

    allTimes = {};
    allDists = {};
    allFileValues = [];
    allpix = {};
    allwpix = {};
    allMpix = {};
    allMwPix = {};
    allRadius = {};
    ExperimentLetter = "";

    for(dirIndex = 1:length(dirs))
        opticFlow = opticalFlowHS;
        fullFileName = dirs(dirIndex).name;
        splitNames = split(fullFileName,'-');
        fileExperimentLetter = string(splitNames(1));
        if(ExperimentLetter ~= fileExperimentLetter)
            if(ExperimentLetter == "")
            ExperimentLetter = fileExperimentLetter;
            else
                warning("Multiple experiments involved - this will corrupt data. Quit now to prevent existing data loss.")
                pause(3);
            end
        end
        fileValue = str2num(cell2mat(splitNames(2)));
        fileIndex = str2num(cell2mat(splitNames(3)));
        indexesOfCurrentValues = find(allFileValues == fileValue);
        if(isempty(indexesOfCurrentValues))
            allFileValues(end+1) = fileValue;
            indexesOfCurrentValues = length(allFileValues);
        end
        if(length(indexesOfCurrentValues) > 1)
            warning("Duplicate folder name detected: " + fullFileName)
        end

        S = dir(fullfile(D,'\',dirs(dirIndex).name,'*.jpg')); % pattern to match filenames.
        S1 = dir(fullfile(D,'\',dirs(dirIndex).name,'*.xml'));

        if(length(S1)==0)
            continue
        end

        frameNum = [];
        frameTime = [];
        frameDist = [];
        frameLoc = [];
        totalPixels = [];
        whitePixels = [];
        maskPixels = [];
        maskWhitePixels = [];
        initialLocation = [];
        initialTime = NaN;
        initialSpread = []; %TODO work out a way of determining distribution of particles (a percentage? an area?)

        CircleCenter = [];
        CircleRadius = [];
        for k = 1:numel(S)

            Fid = fopen(fullfile(D,'\',dirs(dirIndex).name,S1(k).name),'r'); %Open data file for reading (time)
            fileContents = fscanf(Fid,'%s');
            fclose(Fid);
            fileContents = split(fileContents,'<');
            dateTime = fileContents(contains(fileContents,"hmsval"));
            dateTime = str2double(extractBetween(dateTime,15,20));
            % if(k == 0)
            %     initialTime = dateTime;
            % end
            
            %Read in the image file
            F = fullfile(D,'\',dirs(dirIndex).name,S(k).name);
            start = k==1;
            image = rgb2gray(imread(F)); 


            flow = estimateFlow(opticFlow,image);
            imageSGL = flow.Magnitude;
            imshow(imageSGL);
            hold on

            [centres1, rad1] = imfindcircles(imageSGL,[200 600],"Sensitivity",0.989,"EdgeThreshold",0.1);
            if(size(centres1) > 0)
                CircleCenter = centres1(1,:);
                CircleRadius = rad1(1)*0.97; %take 3% off the radius to allow for the boundary to be removed
            end

            %Try using a circle to filter out anything outside.
            [rows, columns, numberOfColorChannels] = size(image);
       %     imshow(image)
       %     hold on
           % Center = [294,249];
           % Radius = 308;
           % Remember that circle diameter should be the 1cm internal diameter of the space
      %      Center = [340,220]; %Think this is a good split for A.
      %      Radius = 262;
            % Center = [340,220]; %Think this is a good split for A.
            % Radius = 262;
            
            maskedFlow = imageSGL; % Initialize with the entire image.
            maskedImage = image;
            if(length(CircleCenter)>0)
                angles = linspace(0, 2*pi, 10000);
                x = cos(angles) * CircleRadius + CircleCenter(1);
                y = sin(angles) * CircleRadius + CircleCenter(2);
                if(k==1)
                    plot(x,y)
                    pause(1)
                end
                mask = poly2mask(x, y, rows, columns);
                maskedFlow(~mask) = 0;
                maskedImage(~mask) = 0;
            end
            

            % figure
            % imshow(maskedImage./max(max(maskedImage)))
            % pause(0.05);

            th = graythresh(maskedFlow);
            maskedBinary = imbinarize(maskedFlow,th);
            thi = graythresh(maskedImage); 
            imageBinary = ~imbinarize(maskedImage,thi);

            % imshow(maskedBinary);
            % imshow(imageBinary);

            %Check for masked image being totally white (indicates no flow)
            useMaskedFlow = true;
            if(length(CircleCenter)>0)
                %If there is more than 85% white then assume that no flow observed
                useMaskedFlow = (sum(maskedBinary(mask)==1)/sum(sum(mask)) < 0.85); 
            end

            %This allows for 'useMaskedFlow' to turn off the opticalFlow
            %option. Tends to not work as expected, so if this is off then
            %discard frame...
            %imageNegative2 = (maskedBinary & imageBinary) | ((~useMaskedFlow & ~maskedBinary) & imageBinary);
            imageNegative2 = (maskedBinary & imageBinary);

            imshow(imageNegative2);
         
            FrameNumber = str2double(extract(S1(k).name, digitsPattern)); 

            [r, c] = find(imageNegative2 >= 1); %Average Location (so centre mass) - this accounts for all particles, including edge cases.
            rowcolCoordinates = [mean(c), mean(r)]; %Had to swap round to match 1,2 notation
            if(~useMaskedFlow)
                if(size(initialLocation) > 0)
                    %Don't do this onthe first loop as coords havent been set
                    rowcolCoordinates = initialLocation;
                else
                    rowcolCoordinates = NaN;
                end
            end
            plot(rowcolCoordinates(1),rowcolCoordinates(2),'r-x')
            pause(0.01);

            if(size(initialLocation) == 0) %Setup the initials
                initialLocation = rowcolCoordinates;
                initialTime = dateTime;
            end
            if(dateTime<initialTime)
               dateTime = dateTime+60;
            end
            timeDiff = dateTime-initialTime;
            frameNum(end+1) = FrameNumber;
            frameTime(end+1) = timeDiff;
            frameDist(end+1) = norm(rowcolCoordinates - initialLocation);
            %frameLoc(end+1,:) = rowcolCoordinates;
            totalPixels(end+1) = size(imageNegative2,1) * size(imageNegative2,2); %Duplicate data here
            whitePixels(end+1) = sum(sum(imageNegative2==1));
            if(length(CircleCenter)>0)
                maskPixels(end+1) = sum(sum(mask));
                maskWhitePixels(end+1) = sum(maskedBinary(mask)==1);
            else
                maskPixels(end+1) = 0;
                maskWhitePixels(end+1) = 0;
            end
        end
        allDists(indexesOfCurrentValues,fileIndex) = {frameDist};
        allTimes(indexesOfCurrentValues,fileIndex) = {frameTime};
        allPix(indexesOfCurrentValues,fileIndex) = {totalPixels};
        allwPix(indexesOfCurrentValues,fileIndex) = {whitePixels};
        allMPix(indexesOfCurrentValues,fileIndex) = {maskPixels};
        allMwPix(indexesOfCurrentValues,fileIndex) = {maskWhitePixels};
       % if(isempty(rad1))
       %     rad1 = 0;
       % end
        allRadius(indexesOfCurrentValues,fileIndex) = {CircleRadius};

        clf
        plot(frameTime,frameDist)
        pause(0.5)
    end
    %figure
    %plot(allTimes,allDists)
    save(fileExperimentLetter+"DistandTime.mat","allTimes","allDists","allFileValues","allPix","allwPix","allMPix","allMwPix");
end
close all
%resultString