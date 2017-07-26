nRounds = 8;
%mode = {'forest','svm','vis'};
mode = {'svm'};
%leaveOut = {'random','repeats','clips'};
leaveOut = {'random','clips'}; 
features = {'allused','front','temp','cent','par','occ','diff','all'};
%portion = {'song','refl'};
portion = {'song'};
colors = 'krgbmc';
dashes = '-:::::';
points = 'oxxxxx';

t = numel(leaveOut);

row = numel(features);
%row = 1;
%nameRows = {'all'};
result_all_mean = zeros(row,t);
result_all_std = zeros(row,t);
for k = 1:numel(mode)
    for feats = 1:numel(features)
        for validation = 1:numel(leaveOut)
            result = [];
            for i = 1:nRounds
                fprintf('Round %d of %d\n',i,nRounds);
                  x = classify_songs(dir, mode{k},leaveOut{validation},portion{k},features{feats});
                result = [result x(:,1)];
            end
            result_all_mean(feats,validation)=mean(result,2);
            result_all_std(feats,validation)=std(result,0,2);
        end
    end
end
figure
hold on
for k=1:numel(leaveOut)
    errorbar(1:row,result_all_mean(:,k),result_all_std(:,k),[colors(k) dashes(k) points(k)],'LineWidth',2);
end
set(gca,'xtick', 1:row);
set(gca,'xticklabel',features);
legend(leaveOut);
ylim([0 100]);
xlabel('Considered Features');
ylabel('Accuracy (%)');
