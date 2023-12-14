%im = imread('C:\Users\bj20907\Documents\291123\T1\image\raw\0\image-000130.jpg');
%D = 'C:\Users\bj20907\Documents\291123\T21\image\raw\0';
%D = 'C:\Users\bj20907\Documents\301123\T30\image\raw\0';
resultString = "";
delteImage = rgb2gray(imread("C:\Users\bj20907\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\111223\image-000000.jpg"));
for(i=200:100:200)
    %D = 'C:\Users\bj20907\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\071223\x2mtRaw\'+string(i)+'T11';
    D = 'C:\Users\bj20907\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\111223\2mt\'+string(i)+'T2';
    dirs = dir(D);
    dirs(1:2)=[];
    dirFlags = [dirs.isdir];
    dirs = dirs(dirFlags);
    for(dirIndex = 1:length(dirs))
        S = dir(fullfile(D,'\',dirs(dirIndex).name,'*.jpg')); % pattern to match filenames.
        S1 = dir(fullfile(D,'\',dirs(dirIndex).name,'*.xml'));
        % lowFile=1;
        % highFile=2;
        % if(highFile<=lowFile)
        %     highFile = numel(S);
        % end


        %im2cr = imcrop(im2,[0,76+26,size(im2,2),size(im2,1)-76-26-20]);
        %im1cr = imcrop(im1tr,[0 76 size(im1tr,2) 354]);

        if(length(S1)==0)
            continue
        end

        startEndFiles = [1,1];
        startEndIndex = [1,1];
        for(j = 1:numel(S1))
            FrameNumber = str2double(extract(S1(k).name, digitsPattern));
            if(startEndFiles(1)>FrameNumber)
                startEndFiles(1) = FrameNumber;
                startEndIndex(1) = j;
            end
            if(startEndFiles(2)<FrameNumber)
                startEndFiles(2) = FrameNumber;
                startEndIndex(2) = j;
            end
        end

        for k = 1:2 %lowFile:numel(S)
    
            % Fid = fopen(fullfile(D,'\',dirs(dirIndex).name,S1(k).name),'r');
            % FrameNumber = str2double(extract(S1(k).name, digitsPattern));
            Fid = fopen(fullfile(D,'\',dirs(dirIndex).name,startEndIndex(k).name),'r');
           % FrameNumber = str2double(extract(startEndIndex(k).name, digitsPattern));

            fileContents = fscanf(Fid,'%s');
            fileContents = split(fileContents,'<');
            dateTime = fileContents(contains(fileContents,"hmsval"));
            dateTime = extractBetween(dateTime,15,20);
            
            %Read in the file
            F = fullfile(D,'\',dirs(dirIndex).name,S(k).name);
            start = k==1;
            image = rgb2gray(imread(F)); 
            %imshow(delteImage)
            %imshow(image)
            imageNegative = delteImage - image;
            %imshow(imageNegative)

            imageNegative(imageNegative<120)=0;
            imageNegative(imageNegative>=120)=255;



    %         image(image>100)=255;
    % imshow(image)
    %         %Blur
    %         Kmedian230 = medfilt2(im230);
    %         Kaverage = filter2(fspecial('average',3),Kmedian230);
    % 
    %         %Actually threshold at 200 on the blurred image
    %         Kaverage(Kaverage<200)=0;
    %         Kaverage(Kaverage>=200) = 1;

           
            if(start)
                fName = "\start.png";
                startTime = str2double(dateTime);
                startFrame = FrameNumber;
            else
                fName = "\end.png";
                endTime = str2double(dateTime);
                endFrame = FrameNumber;
            end
            %imwrite(image, string(D)+'\'+dirs(dirIndex).name+fName);
            imwrite(imageNegative, string(D)+'\'+dirs(dirIndex).name+fName);
        end
        if(endTime<startTime)
            endTime = endTime+60;
        end
        timeDiff = endTime-startTime;
        resultString = resultString + string(i)+','+dirs(dirIndex).name+','+startFrame+','+endFrame+','+startTime+','+endTime+','+timeDiff+newline;
    end
end
resultString