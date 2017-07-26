function visualize( out )
    % change these parameters:
    compareClips = [15 8]; % the indices of clips to be compared. Refer to sortedRandallClipLabels
    viewChannel = 3; % select which of 20+8 channels to compare.
    viewFreq = 12; % select which of 12 frequencies to compare.
    
    load([out '/data_processed_diff.mat']);
    load([out '/data_tSNE.mat']);
    sizebin = 1.5;
    overlap = 0.625;
    timePerSong = 5;
    reflTime = 3;
    nBins = (timePerSong-sizebin)/(sizebin-overlap)+1; 
    overlay = true;
    nFreqs = 12;
    nClips = 20;
    nRepeats = 20; % num repeats of each clip
    nFeats = 336;
    vecsPerClip = nRepeats*nBins; % num feat vectors we get from one playthrough of a clip
    totalBins = nRepeats*nBins*nClips;
    subjBinLabel = kron(sortedResponse,ones(1,nBins));
    subjBinLabel = subjBinLabel';
    clipLabel = kron(1:20,ones(1,nBins*nRepeats))';
    sortedRandallClipLabels = [1 -1 -1 -1 -1 1 1 -1 1 1 -1 -1 1 -1 1 -1 1 1 -1 -1]; 
    RandallBinLabel = kron(sortedRandallClipLabels,ones(1,nBins*nRepeats));
    RandallBinLabel = RandallBinLabel';
    trialLabel = repmat(1:20,1,nBins*nClips)';
    
    figure();
    for clip = 1:length(compareClips)
        viewClip = compareClips(clip);
        offset = (viewClip-1)*vecsPerClip;
        subplot(2,1,clip);
        ylim manual;
        ylim([0 1]); % restrain to [0 1]
        hold on;
        for rpt = 1:nRepeats % plot these repeats to compare
            from = nBins*(rpt-1)+1 + offset;
            to = nBins*(rpt) + offset;
            chan_freq = (viewChannel-1)*nFreqs+viewFreq;
            %plot([1:nBins],datax(from:to,chan_freq)); % plot the reading from the channel's frequency for each time bin
        end
    end
    hold off;
    figure();
    %subplot(1,2,1);
    scatter(tsne_data(:,1),tsne_data(:,2),15,clipLabel,'filled');
    %subplot(1,2,2);
    
    %scatter(tsne_data(:,1),tsne_data(:,2),15,RandallBinLabel,'filled');
    figure();
    scatter3(tsne_data(:,1),tsne_data(:,2),clipLabel,15,trialLabel,'filled');
    return;

end