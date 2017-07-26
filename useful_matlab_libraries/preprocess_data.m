function preprocess_data( subject_name )
%PREPROCESS_DATA Segment the data according to event codes and perform
%wavelet analysis.
%   Requires manual input of experiment parameters

% -----------------------------------------------------------------------    
% Parameters
%   nSamples: number of total songs tested
%   timePerSong: song length in seconds
%   reflTime: either 2 or 3 seconds (check later)
%   nSongs: number of different songs (10 good 10 bad)
%   samplesPer__: num samples EEG takes in one song or refl
%   nTrials: number of trials in total
% -----------------------------------------------------------------------    
    MATLABBASEDIR = 'C:\Users\Francesco Ciannella\Box Sync\Documents\Homeworks\NC-15686\NCProject\MusicEEGResearch\MATLAB';

    nSamples = 400;
    timePerSong = 5;
    reflTime = 3; 
    %reflTime = 5; %TEMP
    sampleFrequency = 256;
    nSongs = 20;
    nTrials = 20;
    
    samplesPerSong = sampleFrequency*timePerSong;
    samplesPerRefl = sampleFrequency*reflTime;
    
    % if subject is xingyu, account for the missing set
    if(strcmp('xingyu',subject_name))
        nSamples = 300;
        nTrials = 15;
    elseif(strcmp('francis',subject_name))
        nSamples = 300;
        nTrials = 15;
    elseif(strcmp('alice',subject_name))
        nSamples = 200;
        nTrials = 10;
    end
        
 

% -----------------------------------------------------------------------
% Load the participant's data.mat file 
% The following will be saved to workspace: chans, data, order, response
% -----------------------------------------------------------------------
    data_out = [MATLABBASEDIR '\DataFiles\data\' subject_name];
    load([data_out '/data.mat']);
    
    
% -----------------------------------------------------------------------
% Extract the indices of the event codes
% -----------------------------------------------------------------------
% adding {1} fciannel
event_indices = find(data{1}(:,45)~=0); 
    
    
   
    
% -----------------------------------------------------------------------
% EEG Parameters
% -----------------------------------------------------------------------
    nchans = 20;
    left = [25 36 26 31 42 30 34 33];
    right = [32 38 27 28 39 29 40 44];
    middle = [37 43 35 41];
    channelmap = {'fp1', 'f3', 'f7', 't3', 'c3', 't5', 'p3', 'o1', ...
                'fp2', 'f4', 'f8', 't4', 'c4', 't6', 'p4', 'o2', ...
                'fz', 'cz', 'pz', 'oz'};




% -----------------------------------------------------------------------
% Obtain arranged data for song EEG data
%   SORTED: rearrange 'order' so that all repeats of the same song are
%       grouped together
%   IND: saves the location of 'sorted' from its source matrix 'order'
% -----------------------------------------------------------------------
arrangedSongs = zeros(samplesPerSong, nchans, nSongs*nTrials);

[sorted, ind] = sort(order);
sortedResponse = response(ind); % sort response along sorted order
index = 0;
for i = 1:nSamples
    
    % discard pieces that are not expected
    if i > nTrials && strcmp(sorted{i},sorted{i-nTrials}) 
        continue
    end
    
    index = index + 1;
    
    %find the marker index for the rearranged and grouped songs
    from = event_indices(ind(i));
    
    %and add the number of cells for the song
    to = from + samplesPerSong - 1;
    
    %extract that portion
    newData = data(from:to, :); 
    
    %rearrange by location (left right middle), omits unused time between songs
    arrangedSongs(:, :, index) = [newData(:, left) newData(:, right) newData(:, middle)];
end



% -----------------------------------------------------------------------
% Obtain arranged data for refl EEG data
%   SORTED: rearrange 'order' so that all repeats of the same song are
%       grouped together
%   IND: saves the location of 'sorted' from its source matrix 'order'
% -----------------------------------------------------------------------
% arrangedSongsRefl = zeros(samplesPerRefl, nchans, nSongs*nTrials);
% 
% [sorted, ind] = sort(order);
% sortedResponse = response(ind); % sort response along sorted order
% index = 0;
% for i = 1:nSamples
%     
%     % discard pieces that are not expected
%     if i > nTrials && strcmp(sorted{i},sorted{i-nTrials}) 
%         continue
%     end
%     
%     index = index + 1;
%     
%     %find the marker index for the rearranged and grouped songs
%     %then add the length of the song
%     from = event_indices(ind(i)) + samplesPerSong - 1;
%     
%     %and add the number of cells for the reflection period
%     to = from + samplesPerRefl - 1;
%     
%     %extract that portion
%     newData = data(from:to, :); 
%     
%     %rearrange by location (left right middle), omits unused time between songs
%     arrangedSongsRefl(:, :, index) = [newData(:, left) newData(:, right) newData(:, middle)];
% end
% 

% -----------------------------------------------------------------------
% Perform wavelet analysis on the EEG data during the clip and reflection
%   sizebin: how large each window/segment of the song is
%   overlap: overlap between windows
% -----------------------------------------------------------------------


fprintf('3.a PERFORMING WAVELET ANALYSIS ON CLIP DATA...\n');
% Produces a set of feature vectors for the song periods
bands = [1 1 2 3 3 4 5 5 5 6 6 6]; % delta theta alpha spindle beta gamma
nbands = length(bands); %12
sizebin = 1; % sec window
overlap = 0.5; % sec overlap between windows
nBins = round((timePerSong-sizebin)/(sizebin-overlap)+1);
nUsedBins = nBins; % only use the last nUsedBins bins
samplesPerBin = sizebin*sampleFrequency;
lengthleft = length(left); % 8
featsChannel = nbands*nchans; % Feature vector (12 * 20 = 240)
featsDiff = nbands*lengthleft; % Computes difference b/w symmetric channels
featsPerSong = featsChannel+featsDiff; % 240 + 96
stepPerBin = (sizebin-overlap)*sampleFrequency;

data_processed = zeros(featsPerSong, nBins, nTrials, nSongs);

sig = 0;
for i = 1:nSongs
    for j = 1:nTrials
        index = (i-1)*nTrials+j;
        temp = arrangedSongs(:, :, index);
        cc = abs(cwt_transform(temp, sampleFrequency,sig,channelmap)).^2;
        
        from = 1;
        for k = 1:nBins
            to = from+samplesPerBin-1;
            cc_binned = mean(cc(:,from:to),2);
            data_processed(1:featsChannel,k,j,i) = cc_binned(:);
            data_processed(featsChannel+1:featsChannel+featsDiff,k,j,i) = cc_binned(1:featsDiff)-cc_binned(featsDiff+1:featsDiff*2); 
            from = from+stepPerBin;
        end
        sig = 0;
    end
end


save([data_out '/data_processed_diff.mat'], 'data_processed', 'sortedResponse');


% 
% fprintf('3.b PERFORMING WAVELET ANALYSIS ON REFL DATA...\n');
% % Produces a set of feature vectors for the refl period
% bands = [1 1 2 3 3 4 5 5 5 6 6 6]; % delta theta alpha spindle beta gamma
% nbands = length(bands); %12
% sizebin = 1.5;
% overlap = 0.75;
% %overlap = 0.625; %TEMP
% nBins = (reflTime-sizebin)/(sizebin-overlap)+1;
% samplesPerBin = sizebin*sampleFrequency;
% lengthleft = length(left); % 8
% featsChannel = nbands*nchans; % Feature vector (12 * 20 = 240)
% featsDiff = nbands*lengthleft; % Computes difference b/w symmetric channels
% featsPerSong = featsChannel+featsDiff; % 240 + 96
% stepPerBin = (sizebin-overlap)*sampleFrequency;
% 
% data_processed = zeros(featsPerSong, nBins, nTrials, nSongs);
% 
% sig = 0;
% for i = 1:nSongs
%     for j = 1:nTrials
%         index = (i-1)*nTrials+j;
%         temp = arrangedSongsRefl(:, :, index);
%         cc = abs(cwt_transform(temp, sampleFrequency,sig,channelmap)).^2;
% 
%         from = timePerSong;
%         %from = 3; %TEMP
%         for k = 1:nBins
%             to = from+samplesPerBin-1;
%             cc_binned = mean(cc(:,from:to),2);
%             data_processed(1:featsChannel,k,j,i) = cc_binned(:);
%             data_processed(featsChannel+1:featsChannel+featsDiff,k,j,i) = cc_binned(1:featsDiff)-cc_binned(featsDiff+1:featsDiff*2);
%             from = from+stepPerBin;
%         end
%         sig = 0;
%     end
% end
% 
% 
% save([data_out '/data_processed_diff_refl.mat'], 'data_processed', 'sortedResponse');
% 
% 
end

