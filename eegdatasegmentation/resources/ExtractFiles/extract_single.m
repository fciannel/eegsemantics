function extract_single( pname,dname,total_songs_trial,num_trials,num_variations_set)
%EXTRACT_SINGLE Given a participant name and ID number, extract raw data
%   and store in data.mat
%   For experiment files with only one EEG data set.
%   For experiments with multiple sets that need to be combined, use
%       extract_multiple.

% -----------------------------------------------------------------------
% Construct datapaths to access sequence and data files for the given 
% participant. 
% ID must end in "..01201.edf"
% -----------------------------------------------------------------------
    % MATLABBASEDIR = 'C:\Users\Francesco Ciannella\Box Sync\Documents\Homeworks\NC-15686\NCProject\MusicEEGResearch\MATLAB';
    MATLABBASEDIR = 'C:\Users\Francesco Ciannella\Box Sync\Documents\Homeworks\NC-15686\NCProject\MusicEEGResearch\MATLAB\eegdatasegmentation';    
    params = {[dname '01201']};
    seq = ['stim_' pname '.txt'];
    resp = ['ratings_' pname '.txt'];
    outf = [MATLABBASEDIR '\DataFiles\data\' pname];
    inf = [MATLABBASEDIR '\DataFiles\data_raw\' dname '_1'];  
    disp(['extracting from file: ' inf]);
    disp(['storing data.mat to folder: ' outf]);
    seqf = [outf '\' seq];
    respf = [outf '\' resp];
% -----------------------------------------------------------------------
    fprintf('Running the single experiment \n')

% -----------------------------------------------------------------------
% Extract the music file order and participant responses.
% Extract the raw EEG data and the channels (20 channels with an extra
% event code channel in "data.mat - data")
% -----------------------------------------------------------------------
%    order = read_song_order(seqf, total_songs_trial, num_trials);
%    response = read_answer_file(respf);
    fprintf('Calling the abm function with: \n')
%    inf 
%    params
    [data, chans] = abm_to_common_mult(inf, params, 1);

    save([outf '\\data.mat'], 'data', 'chans');
    return
end

