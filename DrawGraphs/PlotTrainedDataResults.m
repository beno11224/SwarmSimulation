function PlotTrainedDataResults(fileName)
    close all
    Folder = cd;
    Folder = fullfile(Folder, '..');
    load(fullfile(Folder,fileName),"summed_reward_histories","loss_history","loss_history_val");
  %  summed_reward_histories
    plot(loss_history')
    figure
    plot(loss_history_val')
end