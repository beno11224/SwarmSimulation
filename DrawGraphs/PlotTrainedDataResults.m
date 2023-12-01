function PlotTrainedDataResults(fileName)

    %--------Combine two files together:--------

   %  Folder = cd;
   %  Folder = fullfile(Folder, '..');
   %  load(fullfile(Folder,"TrainedDataResults_RandSeed_HiddenLayer.mat"),"summed_reward_histories","loss_history","loss_history_val");
   %  srh = summed_reward_histories;
   %  lh = loss_history
   %  lhv = loss_history_val
   %  load(fullfile(Folder,"TrainedDataResults_RandSeed_SAVEME_HiddenLayer.mat"),"summed_reward_histories","loss_history","loss_history_val");
   %  srh(:,:,1:3) = summed_reward_histories;
   % % lh(1:3,:) = loss_history;
   % % lhv(1:3,:) = loss_history_val;
   % 
   %  summed_reward_histories = srh;
   %  loss_history = lh;
   %  loss_history_val = lhv;
   % 
   %  save("TrainedDataResults_RandSeedCombined_HiddenLayer.mat","summed_reward_histories","loss_history","loss_history_val");
    %--------------------------------------------
    
    close all
    Folder = cd;
    Folder = fullfile(Folder, '..');
    load(fullfile(Folder,fileName),"summed_reward_histories","loss_history","loss_history_val");
    summed_reward_histories

%    plot(summed_reward_histories-1)

    numPlots = 3;
    %for(j = 1:numPlots)
    for(i=1:size(summed_reward_histories,3))
        figure;
        %for(i=1:size(summed_reward_histories,3))
        for(j = 1:numPlots)
            xlength = sum(squeeze(summed_reward_histories(:,:,i)),2);
            x = 4+(1:length(xlength));
           % plot(x,sum(squeeze(summed_reward_histories(:,:,i)),2)/10)
            plot(x,squeeze(summed_reward_histories(:,2*j+(4),i)))
            hold on
        end
        title("Flow:" + i)
        legend("train6","train8","train10",'location','southeast')%,"train8","train10")
        xlabel("Nodes in hidden layer")
        ylabel("Percentage in goal")
        ylim([0,100])
    end


    % squeeze(summed_reward_histories(:,:,1))
    % for(i=1:size(summed_reward_histories,3))
    %     xlength = sum(squeeze(summed_reward_histories(:,:,i)),2);
    %     x = 4+(1:length(xlength));
    %    % plot(x,sum(squeeze(summed_reward_histories(:,:,i)),2)/10)
    %     plot(x,squeeze(summed_reward_histories(:,10,i)))
    %     hold on
    % end
    % legend({"Flow 0.006m/s","Flow 0.012m/s","Flow 0.018m/s","Flow 0.024m/s","Flow 0.03m/s","Flow 0.036m/s",})
    % xlabel("Number of neurons in the hidden layer")
    % ylabel("Percentage of particles reaching the end goal (Average over 5 runs, after 10 training epochs)")


 %   plot(loss_history')
 %   figure
 %   plot(loss_history_val')
end