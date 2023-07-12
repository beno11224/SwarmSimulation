Values = [8,6;13,4;16,1];
Labels = {"Corrected Eyesight","Gender", "Handedness"};
BarLabels = {'Yes' 'No';'Male' 'Female';'Right' 'Left'};
%BarLabels = {'Yes' 'Male' 'Right' 'No' 'Female' 'Left'};% 'Right''Left'

figure(1)
hBar = bar(Values, 'stacked');
ylabel("Number of Responses")
xt = get(gca, 'XTick');
set(gca, 'XTick', xt, 'XTickLabel', Labels)
yd = get(hBar, 'YData');
barbase = cumsum([zeros(size(Values,1),1) Values(:,1:end-1)],2);
joblblpos = Values/2 + barbase;
for k1 = 1:size(Values,1)
    a = BarLabels(k1:size(Values,1):end)%
    %b = BarLabels(k1:end)
    text(xt(k1)*ones(1,size(Values,2)), joblblpos(k1,:), a, 'HorizontalAlignment','center')
end
axis([0.5 size(Values,1)+0.5 ceil(ylim*1.1)])