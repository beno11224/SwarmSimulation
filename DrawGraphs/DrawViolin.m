function DrawViolin(loadedfileslocation)
     if nargin < 1
        loadedfileslocation = "";
    end
    if(loadedfileslocation ~= "")
        return
        %TODO maybe fix this. Needs to read through each 'state' in order
        %it was done, then record the action taken at that time.
        load(loadedfileslocation,"IMPORTEDexpertStates", "IMPORTEDexpertActions", "IMPORTEDFILEDELIMITERS", "flowRates");
        stateOne = statePairsToCorrectState(IMPORTEDexpertStates);
        bifurcationThresholds = [-0.0045, (-0.002644437 + -0.001720557)./2, (0.002516157 + 0.00289884)./2, (0.007518238 + 0.007900921)./2]; %X positions for cutoff from each bifurcation. Once midpoint crosses that one mark input and move to next
        bifurcationInputs = zeros(length(allFiles), size(bifurcationThresholds,2), 2); %remember the x and y values
        
        DoPlot(bifurcationInputs);
    else
        folderPath = uigetdir();
    
        %Now decide if this is 
        folderContents = dir(fullfile(folderPath));
        innerFolderList = [];
        for(folderIndex = 1:length(folderContents))
            asf = folderContents(folderIndex).name;
            if(isfolder(fullfile(folderPath,folderContents(folderIndex).name)) && folderContents(folderIndex).name ~= "." && folderContents(folderIndex).name ~= "..")            
                innerFolderList{end+1} = fullfile(folderPath,folderContents(folderIndex).name);
            end
        end
        if(length(innerFolderList)== 0)
            innerFolderList = [{folderPath}];
        end
    
        for(innerFolderIndex = 1: length(innerFolderList))
            cscsc = innerFolderList(innerFolderIndex);
            sdfhhdsf = cell2mat(innerFolderList(innerFolderIndex));
            allFiles = dir(fullfile(cell2mat(innerFolderList(innerFolderIndex)), '*.csv'));
            %allFiles = dir(fullfile(folderPath, '*.csv'));
            %if(length(allFiles) == 0)
            %    allFolders = 
            inputReadAll = "y";
            %inputReadAll = input("Show Only results from all files? This may cause errors if files are not sanitized","s")
            readAllFiles = (inputReadAll == "y" || inputReadAll == "Y" || inputReadAll == "yes" || inputReadAll == "Yes");
           
        
            % tr = triangulation(polyshape(polygon.currentPoly(:,1),polygon.currentPoly(:,2)));
            % model = createpde(1);
            % tnodes = tr.Points';
            % telements = tr.ConnectivityList';
            % model.geometryFromMesh(tnodes, telements);
            % mesh = generateMesh(model, 'Hmax', 0.001);%was 0.000073 for old one.
            %           %  closestNode = findNodes(mesh, 'nearest', particleLocation');
            %           %  velocity(:,1) = flowMatrix(closestNode,1);
            %           %  velocity(:,2) = flowMatrix(closestNode,2);
            % meshValues = zeros([size(mesh.Nodes,2),1]);
            plotMesh = figure;
            axMesh = axes('Parent',plotMesh);
            hold on
          %  polyLineMesh = plot(axMesh,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
          %  endLineMesh = plot(axMesh,polygon.currentEndZone(1,:,1),polygon.currentEndZone(1,:,2), 'Color','g');
        
            bifurcationThresholds = [-0.0045, (-0.002644437 + -0.001720557)./2, (0.002516157 + 0.00289884)./2, (0.007518238 + 0.007900921)./2]; %X positions for cutoff from each bifurcation. Once midpoint crosses that one mark input and move to next
            bifurcationInputs = zeros(length(allFiles), size(bifurcationThresholds,2), 2); %remember the x and y values
        
            for fileIndex = 1:length(allFiles)
                
                useFile = 'y';
                if(~readAllFiles)
                    allFiles(fileIndex).name
                    useFile = input("Read This File?","s")
                    plot1 = figure;
                end
                if(useFile == "y" || useFile == "Y" || useFile == "yes" || useFile == "Yes")
                    %Now Do Stuff!
        
                    if(~readAllFiles)
                        close(plot1);
                        plot1 = figure;
                        ax1 = axes('Parent',plot1);
                        hold on;
                    end
        
                    %fid = fopen(folderPath + "\" + allFiles(fileIndex).name);
                    sdgsd = allFiles(fileIndex).name;
                    sdgh = fullfile(cell2mat(innerFolderList(innerFolderIndex)),allFiles(fileIndex).name);
                    fid = fopen(fullfile(cell2mat(innerFolderList(innerFolderIndex)),allFiles(fileIndex).name));
                    lines = {}; %remove this?
                    tline = fgetl(fid);
                    if(tline == -1)
                        "Nothing in the File"
                        continue;
                    end
        
                        % if(~readAllFiles)
                        %     polyLine = plot(ax1,polygon.currentPoly(:,1),polygon.currentPoly(:,2), 'Color','b');
                        %     endLine = plot(ax1,polygon.currentEndZone(1,:,1),polygon.currentEndZone(1,:,2), 'Color','g');
                        % end
                    tidiedPositions = [];
                    times = [];
                    magForces = [];
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
                       allLocations = split(positions,';');
    
                       magForce = strip(magForce,'[');
                       magForce = strip(magForce,']');
                       bothForces = split(magForce,' ');
                       magForces = [magForces; [str2double(bothForces(1)),str2double(bothForces(2))]];
    
                       pagePositions = [];
                       times = [times; time];
                       for(lineIndex = 1:length(allLocations))
                           xAndYVelocities = split(allLocations(lineIndex),' ');
                           a = [str2double(xAndYVelocities(1)), str2double(xAndYVelocities(2))];
                           pagePositions = [pagePositions; [str2double(xAndYVelocities(1)), str2double(xAndYVelocities(2))]];
                       end
                       tidiedPositions = cat(3,tidiedPositions, pagePositions);
                       tline = fgetl(fid);    
                    end
        
                    %remove particles that are in the goals?
                    averagePosition = squeeze(mean(tidiedPositions,1)); %(:,1,:)
                    bifurcationIndex = 1;
        
                    for(lineCount = 1: size(averagePosition,2))
                        if(averagePosition(1,lineCount) > bifurcationThresholds(bifurcationIndex))
                            a = averagePosition(:,lineCount);
                            b = bifurcationInputs(fileIndex,bifurcationIndex,:);
                            %bifurcationInputs(fileIndex,bifurcationIndex,:) = averagePosition(:,lineCount);
                            bifurcationInputs(fileIndex,bifurcationIndex,:) = magForces(lineCount,:);
                            if(bifurcationIndex == size(bifurcationThresholds,2))
                                break;
                            else
                                bifurcationIndex = bifurcationIndex + 1;
                            end
                        end
                    end
                    fclose(fid);
        
                end
            end
    
            DoPlot(bifurcationInputs)
        
        end
    end

 %    meshValues = meshValues ./ quantile(meshValues,0.9); %between 0 and 1
 %    meshValues(meshValues > 1) = 1; %limit extremes
 %    alpha = meshValues;
 %  %  MESHVALUES = repmat(meshValues,1,length(mesh.Nodes(1,:))) ;
 %    %alpha(alpha < 0.5) = 0.5; %lower bound the alpha
 %  %  scatter(axMesh,mesh.Nodes(1,:), mesh.Nodes(2,:),50, meshValues','filled');%, 'AlphaData', alpha, MarkerFaceAlpha='flat')
 %   % m = surf(mesh.Nodes(1,:), mesh.Nodes(2,:)', meshValues)
 %   % m = surf(mesh.Nodes(1,:), mesh.Nodes(2,:), MESHVALUES);
 %   % m = patch(mesh.Nodes, meshValues, 'FaceColor', 'interp');
 %  % m = patch('XData',mesh.Nodes(1,:), 'YData', mesh.Nodes(2,:), 'ZData', meshValues', 'FaceColor', 'interp');
 %  m = pdeplot(model, "XYData",meshValues, 'ColorMap', 'jet');
 %  %  shading interp 
 %  % view(2);
 %    %TODO use mesh(or equivalent) - need to make meshValues into a square,
 %    %same with X and Y
 % %   m.FaceColor = 'flat';
 %    %m = mesh(mesh.Nodes(1,:), mesh.Nodes(2,:), meshValues)
 %  %  colorbar (axMesh);
    useFile = input("Press any key to exit","s");
    close all;
end


function DoPlot(bifurcationInputs)
    %code originally from here: https://uk.mathworks.com/matlabcentral/fileexchange/45134-violin-plot
    %   for(xy = 1:2)%Do the x first then the y
    %defaults:
    %_____________________
    xL=[];
    fcx=[0.3 1 0];
    fc=[1 0.3 0];
    lc='k';
    alp=0.5;
    mc='k';
    medc='r';
    b=[]; %bandwidth
    plotlegend=1;
    plotmean=0;
    plotmedian=0;
    x = [1,2,3,4];
    %_____________________
    Fx = [];
    Ux = [];
    MEDx = [];
    MXx = [];
    bwx = [];
    fy = [];
    Fy = [];
    Uy = [];
    MEDy = [];
    MXy = [];
    bwy = [];
    fx = [];
    fy = [];
    ux = [];
    uy = [];
    bbx = [];
    bby = [];
    %_____________________
    Xx = squeeze(bifurcationInputs(:,:,1));
    Y = squeeze(bifurcationInputs(:,:,2));
    if iscell(Y)==0
        Xx = num2cell(Xx,1);
        Y = num2cell(Y,1);
    end

    if size(fc,1)==1
        fcx=repmat(fcx,size(Y,2),1);
        fc=repmat(fc,size(Y,2),1);
    end

    for i=1:size(Y,2)    
        % if isempty(b)==0
        %     [f, u, bb]=ksdensity(Y{i},'bandwidth',b(i));
        % elseif isempty(b)
            [fx, ux, bbx]=ksdensity(Xx{i});
            [fy, uy, bby]=ksdensity(Y{i});
        % end
        
        fx=fx/max(fx)*0.3; %normalize
        Fx(:,i)=fx;
        Ux(:,i)=ux;
        MEDx(:,i)=nanmedian(Xx{i});
        MXx(:,i)=nanmean(Xx{i});
        bwx(:,i)=bbx;  

        fy=fy/max(fy)*0.3; %normalize
        Fy(:,i)=fy;
        Uy(:,i)=uy;
        MEDy(:,i)=nanmedian(Y{i});
        MXy(:,i)=nanmean(Y{i});
        bwy(:,i)=bby;     
    end
    %Check x-value options
    if isempty(x)
        x = zeros(size(Y,2));
        setX = 0;
    else
        setX = 1;
        if isempty(xL)==0
            disp('_________________________________________________________________')
            warning('Function is not designed for x-axis specification with string label')
            warning('when providing x, xlabel can be set later anyway')
            error('please provide either x or xlabel. not both.')
        end
    end

    xrepd = repmat(x,size(Fx,1),1);

    for i=1:size(Y,2) %i=i:size..
    %    aa = F(:,i)+i;
    %    ab = flipud(i-F(:,i));
    %    ba = U(:,i);
    %    bb = flipud(U(:,i));
    %    ca = fc(i,:);
       % aa = Fx(:,i)+x(i);
       % ab = flipud(x(i)-Fx(:,i));
       % ac = xrepd(i);
       % ad = xrepd(:,i);
       % ba = Ux(:,i);
       % bb = flipud(Ux(:,i));
       % ca = fc(i,:);

        % if isempty(lc) == 1
        %     if setX == 0
        %         h(i)=fill([F(:,i)+i;flipud(i-F(:,i))],[U(:,i);flipud(U(:,i))],fc(i,:),'FaceAlpha',alp,'EdgeColor','none');
        %     else
        %         h(i)=fill([F(:,i)+x(i);flipud(x(i)-F(:,i))],[U(:,i);flipud(U(:,i))],fc(i,:),'FaceAlpha',alp,'EdgeColor','none');
        %     end
        % else
            % if setX == 0
            %     h(i)=fill([F(:,i)+i;flipud(i-F(:,i))],[U(:,i);flipud(U(:,i))],fc(i,:),'FaceAlpha',alp,'EdgeColor',lc);
            % else

                ffadgdgg = fill([flipud(x(i)-Fx(:,i));xrepd(:,i)],[flipud(Ux(:,i));Ux(:,i)],fcx(i,:),'FaceAlpha',alp,'EdgeColor',lc) %or just Uy;Uy?
                h(i)=fill([xrepd(:,i);x(i)+Fy(:,i)],[Uy(:,i);flipud(Uy(:,i))],fc(i,:),'FaceAlpha',alp,'EdgeColor',lc);

               % ffadgdgg = fill([flipud(x(i)-Fy(:,i));xrepd(:,i)],[flipud(Uy(:,i));Uy(:,i)],fc(i,:),'FaceAlpha',alp,'EdgeColor',lc) %or just Uy;Uy?
          %      h(i)=fill([Fy(:,i)+x(i);flipud(x(i)-Fy(:,i))],[Uy(:,i);flipud(Uy(:,i))],fc(i,:),'FaceAlpha',alp,'EdgeColor',lc);
            % end
        % end

        hold on
        % if setX == 0
        %     if plotmean == 1
        %         p(1)=plot([interp1(U(:,i),F(:,i)+i,MX(:,i)), interp1(flipud(U(:,i)),flipud(i-F(:,i)),MX(:,i)) ],[MX(:,i) MX(:,i)],mc,'LineWidth',2);
        %     end
        %     if plotmedian == 1
        %         p(2)=plot([interp1(U(:,i),F(:,i)+i,MED(:,i)), interp1(flipud(U(:,i)),flipud(i-F(:,i)),MED(:,i)) ],[MED(:,i) MED(:,i)],medc,'LineWidth',2);
        %     end
        % elseif setX == 1
            if plotmean == 1
                p(1)=plot([interp1(U(:,i),F(:,i)+i,MX(:,i))+x(i)-i, interp1(flipud(U(:,i)),flipud(i-F(:,i)),MX(:,i))+x(i)-i],[MX(:,i) MX(:,i)],mc,'LineWidth',2);
            end
            if plotmedian == 1
                p(2)=plot([interp1(U(:,i),F(:,i)+i,MED(:,i))+x(i)-i, interp1(flipud(U(:,i)),flipud(i-F(:,i)),MED(:,i))+x(i)-i],[MED(:,i) MED(:,i)],medc,'LineWidth',2);
            end
        %end
    end
    legend(["x input","y input"])
    xlabel('Bifurcation position');
    ylabel('User input (T/m)');
end

%copied DIRECTLY from particleSimulationTrainModeFFPlayFirstHomePC, line 546 ish
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
