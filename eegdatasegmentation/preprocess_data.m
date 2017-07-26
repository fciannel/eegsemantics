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
    MATLABBASEDIR = 'C:\Users\Francesco Ciannella\Box Sync\Documents\Homeworks\NC-15686\NCProject\MusicEEGResearch\MATLAB\eegdatasegmentation';        

    seconds_per_sample = 3;
    sample_frequency = 256;
    n_concepts = 17;
    n_trials = 10;
    n_modalities = 3;
    n_samples = n_concepts * n_trials * n_modalities;

    samples_per_stimulus = sample_frequency * seconds_per_sample;

    
    
    
    

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
    n_chans = 20;
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
all_stimuli = zeros(samples_per_stimulus, n_chans, n_samples);

data_matrix = data{1};
index = 0;
for i = 1:n_samples
    
   
    index = index + 1;
    
    %find the marker index for the rearranged and grouped songs
    from = event_indices(i);
    
    %and add the number of cells for the song
    to = from + samples_per_stimulus - 1;
    
    %extract that portion
    new_data = data_matrix(from:to, :); 
    
    %rearrange by location (left right middle), omits unused time between songs
    all_stimuli(:, :, index) = [new_data(:, left) new_data(:, right) new_data(:, middle)];
end




% -----------------------------------------------------------------------
% Perform wavelet analysis on the EEG data during the clip and reflection
%   sizebin: how large each window/segment of the song is
%   overlap: overlap between windows
% -----------------------------------------------------------------------


fprintf('3.a PERFORMING WAVELET ANALYSIS ON CLIP DATA...\n');
% Produces a set of feature vectors for the song periods
bands = [1 1 2 3 3 4 5 5 5 6 6 6]; % delta theta alpha spindle beta gamma
n_bands = length(bands); %12
sizebin = 1; % sec window
overlap = 0.5; % sec overlap between windows
n_bins = round((seconds_per_sample-sizebin)/(sizebin-overlap)+1);
n_used_bins = n_bins; % only use the last nUsedBins bins
samples_per_bin = sizebin*sample_frequency;
lengthleft = length(left); % 8
feats_channel = n_bands*n_chans; % Feature vector (12 * 20 = 240)
feats_diff = n_bands*lengthleft; % Computes difference b/w symmetric channels
feats_per_sample = feats_channel+feats_diff; % 240 + 96
step_per_bin = (sizebin-overlap)*sample_frequency;

data_processed = zeros(feats_per_sample, n_bins, n_samples);

sig = 0;
for i = 1:n_samples
        index = i;
        temp = all_stimuli(:, :, index);
        cc = abs(cwt_transform(temp, sample_frequency,sig,channelmap)).^2;
        from = 1;
        for k = 1:n_bins
            to = from+samples_per_bin-1;
            cc_binned = mean(cc(:,from:to),2);
            data_processed(1:feats_channel,k,i) = cc_binned(:);
            data_processed(feats_channel+1:feats_channel+feats_diff,k,i) = cc_binned(1:feats_diff)-cc_binned(feats_diff+1:feats_diff*2); 
            from = from+step_per_bin;
        end
        sig = 0;
end


save([data_out '/data_processed_diff.mat'], 'data_processed');



end

