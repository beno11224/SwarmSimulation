function DrawNetworkWeights(networkSize,networkWeights,networkBias)
    close all
    if(length(networkSize) > 1)
        figure;

        %Draw first layer
        previousLayerCentres = [1:networkSize(1)] - networkSize(1)/2;
        xAxis = ones(1,length(previousLayerCentres));
        plot(xAxis,previousLayerCentres,'b.', 'markerSize', 50)
        hold on
        for layer = 2:(length(networkSize))
            %Draw layer
            xAxis = ones(1,networkSize(layer)).*layer;
            currentLayerCentres = [1:networkSize(layer)] - networkSize(layer)/2;
            plot(xAxis,currentLayerCentres,'b.', 'markerSize', 50)
            hold on
            %Draw weights from prev layer
            for (i = 1:length(previousLayerCentres))
                for(j = 1:length(currentLayerCentres))
                    connections = [previousLayerCentres(i),currentLayerCentres(j)];
                    plot([layer-1,layer],connections,'r-', LineWidth=0.5*j)
                end
            end
            previousLayerCentres = currentLayerCentres;
        end    
    else
        "Network size is invalid"
    end
end
