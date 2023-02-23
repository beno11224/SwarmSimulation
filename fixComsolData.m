function fixComsolData()
    flowValuesNumber = 4;
    for(fileCount = 1:12)
        fd = 0;
        switch(fileCount)
            case 1
                fd = FlowData05();
            case 2
                fd = FlowData10();
            case 3
                fd = FlowData15();
            case 4
                fd = FlowData20();
            case 5
                fd = FlowData25();
            case 6
                fd = FlowData30();
            case 7
                fd = FlowData35();
            case 8
                fd = FlowData40();
            case 9
                fd = FlowData45();
            case 10
                fd = FlowData50();
            case 11
                fd = FlowData55();
            case 12
                fd = FlowData60();
        end
        mesh = delaunayTriangulation(fd.FlowLocations{flowValuesNumber});
        fname = "reworkedValues"+fileCount+".txt";
        writeTo = fopen(fname,'w');
        for(i = 1:length(fd.FlowValues{flowValuesNumber}))
            loc = fd.FlowLocations{flowValuesNumber}(i,:);
            val = fd.FlowValues{flowValuesNumber}(i,:);
            if(val(1) == 0 && val(2) == 0)
                meshList = fd.FlowLocations{flowValuesNumber};
                found = false;
                pointToSearchFor = loc;
                while(~found)
                    meshOfmeshList = delaunayTriangulation(meshList);
                    index = meshOfmeshList.nearestNeighbor(pointToSearchFor);
                    nn = meshOfmeshList.Points(index,:);
                    for(j = 1:length(fd.FlowLocations{flowValuesNumber}))
                        if(fd.FlowLocations{flowValuesNumber}(j,:) == nn)
                            val = fd.FlowValues{flowValuesNumber}(j,:);
                            if(val(1) ~= 0 || val(2) ~= 0)
                                found = true;
                            end
                            break;
                        end
                    end
                    meshList(index,:) = [-1000,-1000];
                    pointToSearchFor = nn;
                end
                %val = closest non-zero node.
            end
            fprintf(writeTo,"%d %d;\n",val(1),val(2));
        end
        fclose(writeTo);
    end
end

