%im = imread('C:\Users\bj20907\Documents\291123\T1\image\raw\0\image-000130.jpg');
%D = 'C:\Users\bj20907\Documents\291123\T21\image\raw\0';
%D = 'C:\Users\bj20907\Documents\301123\T30\image\raw\0';
clear
resultString = "";
delteImage = rgb2gray(imread("F:\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\111223\image-000000.jpg"));
for(i=200:100:200)
    %D = 'C:\Users\bj20907\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\071223\x2mtRaw\'+string(i)+'T11';
   % D = 'C:\Users\bj20907\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\111223\FAKEmt\'+string(i);
    D = 'F:\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\111223\2mt\'+string(i);
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

        startEndFiles = [1000,1];
        startEndIndex = [1,1];
        for(j = 1:numel(S1))
            FrameNumber = str2double(extract(S1(j).name, digitsPattern));
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
            Fid = fopen(fullfile(D,'\',dirs(dirIndex).name,S1(startEndIndex(k)).name),'r');
           % FrameNumber = str2double(extract(startEndIndex(k).name, digitsPattern));

            fileContents = fscanf(Fid,'%s');
            fileContents = split(fileContents,'<');
            dateTime = fileContents(contains(fileContents,"hmsval"));
            dateTime = extractBetween(dateTime,15,20);
            
            %Read in the file
            F = fullfile(D,'\',dirs(dirIndex).name,S(startEndIndex(k)).name);
            start = k==1;
            image = rgb2gray(imread(F)); 


            %Try using a circle to filter out anything outside.
            [rows, columns, numberOfColorChannels] = size(image);
            imshow(image)
            hold on
            Center = [294,249];
            Radius = 308;
            
            angles = linspace(0, 2*pi, 10000);
            x = cos(angles) * Radius + Center(1);
            y = sin(angles) * Radius + Center(2);
            plot(x,y)
            mask = poly2mask(x, y, rows, columns);
            maskedImage = image; % Initialize with the entire image.
            maskedImage(~mask) = 255;
            maskedImage(1:37,:) = 255;
            maskedImage(455:475,:) = 255;
            maskedImage(:,1:78) = 255;
            imshow(maskedImage)

            th = 40;
            imageNegative2 = (maskedImage);
            %imageNegative2 = imsharpen(maskedImage);
            %imageNegative2 = filter2(fspecial('average',3),maskedImage);
            imageNegative2(imageNegative2<th)=0;           
            imageNegative2(imageNegative2>=th)=255;
            imageNegative2 = 255-imageNegative2;
            imshow(imageNegative2)
            pause(0.5)



%Trying thre3sholding whole image
            %imshow(delteImage)
            %imshow(image)
          %  imshow(delteImage)
       % %   for i = 1:50
       %      delteImageTr = imtranslate(delteImage,[-10, 0]);%,"OutputView","full");
       %      imageNegative = (uint8(255)-image) - (uint8(255)-delteImageTr);
       %      imshow(image)
       %      imshow(imneg)
       %     % imshow(im2bw(imneg,0.1))
       %    %  ab(i) = mean(mean(imneg))
       %    %  pause(0.5)
       %   % end
       %  %  plot(ab)
       % 
       %      % imshow(delteImageTr-image)
       %      % imageNegative = delteImage - image;
       %      % imshow(imageNegative)
       % 
       % 
       %      for i = 1:255
       %          i
       %          imageNegative2 = imsharpen(imageNegative);
       %          imageNegative2(imageNegative<i)=0;
       %         % imshow(imageNegative)
       %          imageNegative2(imageNegative2>=i)=255;
       %          imshow(imageNegative2)
       %          pause(0.1)
       %      end



    %         image(image>100)=255;
    % imshow(image)
    %         %Blur
    %         Kmedian230 = medfilt2(im230);
    %         Kaverage = filter2(fspecial('average',3),Kmedian230);
    % 
    %         %Actually threshold at 200 on the blurred image
    %         Kaverage(Kaverage<200)=0;
    %         Kaverage(Kaverage>=200) = 1;

            FrameNumber = str2double(extract(S1(startEndIndex(k)).name, digitsPattern));           
          %  if(start)
            if(k==1)
                fName = "\start.png";
                startTime = str2double(dateTime);
                startFrame = FrameNumber;
            else
                fName = "\end.png";
                endTime = str2double(dateTime);
                endFrame = FrameNumber;
            end
            %imwrite(image, string(D)+'\'+dirs(dirIndex).name+fName);
            imwrite(imageNegative2, string(D)+'\'+dirs(dirIndex).name+fName);
        end
        if(endTime<startTime)
            endTime = endTime+60;
        end
        timeDiff = endTime-startTime;
        resultString = resultString + string(i)+','+dirs(dirIndex).name+','+startFrame+','+endFrame+','+startTime+','+endTime+','+timeDiff+newline;
    end
end
resultString