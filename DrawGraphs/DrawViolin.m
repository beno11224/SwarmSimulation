function DrawViolin()%polygon)
    folderPath = uigetdir();
    allFiles = dir(fullfile(folderPath, '*.csv'));
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

            fid = fopen(folderPath + "\" + allFiles(fileIndex).name);
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
                    bifurcationInputs(fileIndex,bifurcationIndex,:) = averagePosition(:,lineCount);
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

%code originally from here: https://uk.mathworks.com/matlabcentral/fileexchange/45134-violin-plot
 %   for(xy = 1:2)%Do the x first then the y
        %defaults:
        %_____________________
        xL=[];
        fc=[1 0.5 0];
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
        Xx = squeeze(bifurcationInputs(:,:,2));
        Y = squeeze(bifurcationInputs(:,:,2));
        if iscell(Y)==0
            Xx = num2cell(Xx,1);
            Y = num2cell(Y,1);
        end

        if size(fc,1)==1
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

        for i=1:size(Y,2) %i=i:size..
        %    aa = F(:,i)+i;
        %    ab = flipud(i-F(:,i));
        %    ba = U(:,i);
        %    bb = flipud(U(:,i));
        %    ca = fc(i,:);

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
                    h(i)=fill([flipud(x(i)-Fx(:,i));x(i)+Fy(:,i)],[flipud(Ux(:,i));Uy(:,i)],fc(i,:),'FaceAlpha',alp,'EdgeColor',lc);
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

    %end



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