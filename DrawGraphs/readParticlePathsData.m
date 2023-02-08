function readParticlePathsData(particlePaths)
    for(fileIndex = 1:size(particlePaths,1))
        for(pIndex = 1:size(particlePaths,2))
          %  if(~ particlePaths(fileIndex,pIndex).ValidRun)
          %      continue;
          %  end
            test1 = particlePaths(fileIndex,pIndex);
           % plot(abs(test1.Velocities(1,:).*test1.Velocities(2,:)));
           % plot(abs(test1.Locations(1,:).*test1.Locations(2,:)));
           % plot(abs(test1.InputForces(1,:).*test1.InputForces(2,:)));

            newVal = test1.Velocities(1,:).*test1.Velocities(2,:);
           % newVal = abs(test1.Locations(1,:).*test1.Locations(2,:));
           % newVal = sum(abs(test1.InputForces));
            if(true)
                if(pIndex == 1)
                    fileAverage = newVal;
                else
                    fileAverage = fileAverage + newVal;
                end
            end
            %velocities(fileIndex,pIndex,:,:) = test1.Velocities;
            hold on;
        end
        plot(fileAverage ./ 400);
        %a = velocities(1,:,:);
    end
end

