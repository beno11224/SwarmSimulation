function drawnFigure = DrawNetworkValues(networkSize, inputState)
    try
        pyrun("model.model.summary()");
    catch 
        networkSize = nan;
    end
    if(size(networkSize>0))
        
        % #create new model
        % new_model= Sequential([
        %     Dense(32, input_dim=784), # first number is output_dim
        %     Activation('relu')])
        % 
        % #set weights of the first layer
        % new_model.set_weights(model.layers[0].get_weights())
        % 
        % #compile it after setting the weights
        % new_model.compile(optimizer='adam', loss='categorical_crossentropy')
        % 
        % #get output of the first dens layer
        % output = new_model.predict(samples)
        pyrun("new_model = Sequential([Dense(32, input_dim=784) Activation('relu')]"); 



        pyrun("extractor = keras.Model(inputs=model.inputs, outputs=[layer.output for layer in model.layers])",model = network);
        ff = pyrun("features = extractor(data)","features",data=inputState)

        drawnFigure = figure;
        currentBiases = cell2mat(networkBias(1));
        %Draw first layer
        previousLayerCentres = [1:networkSize(1)] - networkSize(1)/2;
       % xAxis = ones(1,length(previousLayerCentres));
        % for(i = 1:length(previousLayerCentres))
        %     if(currentBiases(i)<0)
        %         plot(1,previousLayerCentres(i),'r.', 'markerSize', -50*currentBiases(i))
        %     else
        %         plot(1,previousLayerCentres(i),'b.', 'markerSize', 50*currentBiases(i))
        %     end
        %     hold on
        % end
        for layer = 2:(length(networkSize))
            %Draw layer
          %  xAxis = ones(1,networkSize(layer)).*layer;
            currentLayerCentres = [1:networkSize(layer)] - networkSize(layer)/2;
            currentBiases = cell2mat(networkBias(layer-1));
            for(i = 1:length(currentLayerCentres))
                cappedBias = abs(currentBiases(i));
                cappedBias(cappedBias>1) = 1;
                if(currentBiases(i)<0)
                    plot(layer,currentLayerCentres(i),'.', 'markerSize', -50*currentBiases(i), 'Color',[0.8 0.7-cappedBias/2 0.4])
                else
                    plot(layer,currentLayerCentres(i),'.', 'markerSize', 50*currentBiases(i), 'Color',[0.7-cappedBias/2 0.8 0.4])
                end
                hold on
            end
            hold on
            %Draw weights from prev layer
            currentWeights = cell2mat(networkWeights(layer-1))
            for (i = 1:length(previousLayerCentres))
                for(j = 1:length(currentLayerCentres))
                    connections = [previousLayerCentres(i),currentLayerCentres(j)];
                    if(currentWeights(i,j)<0)
                        plot([layer-1,layer],connections,'-', LineWidth= -5*currentWeights(i,j), Color=[0.7 0.7-cappedBias/2 0.3])
                    else
                        plot([layer-1,layer],connections,'-', LineWidth= 5*currentWeights(i,j), Color=[0.7-cappedBias/2 0.7 0.3])
                    end
                end
            end
            previousLayerCentres = currentLayerCentres;
        end  
    else
        "Please initialise the network, and ensure the python variable is named 'model'"
    end
end
