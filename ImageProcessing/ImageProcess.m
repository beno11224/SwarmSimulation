%im = imread('C:\Users\bj20907\Documents\291123\T1\image\raw\0\image-000130.jpg');
%D = 'C:\Users\bj20907\Documents\291123\T21\image\raw\0';
%D = 'C:\Users\bj20907\Documents\301123\T30\image\raw\0';
for(i=200:200:200)
    D = 'C:\Users\bj20907\OneDrive - University of Essex\Ben\Work-in-Essex\Data & Code\ParticleExperiment\071223\x2mtRaw\'+string(i)+'T11';
    S = dir(fullfile(D,'*.jpg')); % pattern to match filenames.
    S1 = dir(fullfile(D,'*.xml'));
    % lowFile=1;
    % highFile=2;
    % if(highFile<=lowFile)
    %     highFile = numel(S);
    % end
    for k = 1:2 %lowFile:numel(S)

        Fid = fopen(fullfile(D,S1(1).name),'r');
        fileContents = fscanf(Fid,'%s');
        fileContents = split(fileContents,'<');
        dateTime = fileContents(contains(fileContents,"hmsval"));
        dateTime = extractBetween(dateTime,15,20);
        

        %Read in the file
        F = fullfile(D,S(k).name);
        %start = contains(F,"start");
        start = k==1;% contains(F,"start");
        im230=imread(F);
        
        %First(lower) threshold
        im230(im230<225)=0;

        %Blur
        Kmedian230 = medfilt2(im230);
        Kaverage = filter2(fspecial('average',3),Kmedian230);

        %Actually threshold at 200 on the blurred image
        Kaverage(Kaverage<200)=0;
        Kaverage(Kaverage>=200) = 1;
        
        %imshow(Kaverage)
        %imwrite(Kaverage, D+'binary'+ string(k)+'.png');
        if(start)
            fName = "\start.png";
            startTime = double(dateTime);
        else
            fName = "\end.png";
            endTime = double(dateTime);
        end
        imwrite(Kaverage, string(D)+fName);
        %pause(0.01);
        % if(k==highFile)
        %     close all;
        %     break
        % end
    end
    if(endTime<startTime)
        endTime = endTime+60;
    end
    timeDiff = endTime-startTime;
end