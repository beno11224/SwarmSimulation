particlePaths = {};
if(false)
    FOLDERPATH = "C:\Users\beno1\Downloads\USETHISDATA";
    allFolders = dir(fullfile(FOLDERPATH));
    
    for i = 3:length(allFolders)
        abs = FOLDERPATH + '\' + string(allFolders(i).name);
        particlePaths(i-2) = {ReadAllResults(abs)};
    end
    save("particlePAthsAll.mat","particlePaths");
    "Done"
end
if(true)    
    load("particlePAthsAll.mat","particlePaths");
    for j = 1:size(particlePaths,2)
    %    ab = particlePaths{j}
        addpath 'E:\SwarmSimulation'
        DrawHeatMapFromParticlePath(particlePaths{j});
        %DrawInputAngle(particlePaths{j}) %Can't work this one out atm
        pause(0.01)
    end
end